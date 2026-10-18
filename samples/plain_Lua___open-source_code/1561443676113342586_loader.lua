--[[
    =======================================================
    LIYHUB SECURE CLIENT BOOTSTRAPPER (Luarmor Architecture)
    Protected by LiyHub Cloud DRM & Script Vault
    =======================================================
]]

local __SERVER_URL = "https://thanhub.site"
local __PROJECT_ID = "default"
local __SCRIPT_ID = "auto"
local __KEY = ""
local __FREE_FOR_ALL = false
local __DISCORD_URL = "https://discord.gg/YSJDUB9kUf"
local __KEY_IS_CACHED = false
local __CACHE_VERSION = 1

-- Reject values that are clearly URLs/invite links or otherwise cannot be a license key.
-- This prevents common executor globals such as "key" from accidentally supplying
-- a Discord invite URL to the license validator.
local function __isLicenseKeyCandidate(value)
    if type(value) ~= "string" then
        return false
    end

    local candidate = value:match("^%s*(.-)%s*$")
    if not candidate or candidate == "" or candidate == "" then
        return false
    end

    local lower = string.lower(candidate)

    -- License keys are opaque tokens, never web URLs or Discord invite links.
    if string.find(lower, "://", 1, true)
        or string.find(lower, "discord.gg/", 1, true)
        or string.find(lower, "discord.com/invite/", 1, true)
        or string.find(lower, "discordapp.com/invite/", 1, true)
        or string.find(lower, "www.", 1, true)
        or string.find(lower, "http", 1, true) then
        return false
    end

    -- Avoid treating a plain Discord hostname/invite as a key as well.
    if lower == "discord.gg" or lower == "discord.com" or lower == "discordapp.com" then
        return false
    end

    return #candidate >= 6
end

-- Helper to safely find the key from all possible executor scopes & stack frames
local function __resolveKey()
    if __isLicenseKeyCandidate(__KEY) then
        return __KEY:match("^%s*(.-)%s*$")
    end

    local candidates = {"script_key", "ScriptKey", "SCRIPT_KEY", "Key", "key", "KEY", "license_key", "LicenseKey"}

    -- 1. Check getgenv()
    if getgenv then
        local g = getgenv()
        for _, k in ipairs(candidates) do
            if __isLicenseKeyCandidate(g[k]) then
                return g[k]:match("^%s*(.-)%s*$")
            end
        end
    end

    -- 2. Check _G
    if _G then
        for _, k in ipairs(candidates) do
            if __isLicenseKeyCandidate(_G[k]) then
                return _G[k]:match("^%s*(.-)%s*$")
            end
        end
    end

    -- 3. Check shared
    if shared then
        for _, k in ipairs(candidates) do
            if __isLicenseKeyCandidate(shared[k]) then
                return shared[k]:match("^%s*(.-)%s*$")
            end
        end
    end

    -- 4. Check Call Stack Environments (getfenv)
    if getfenv then
        for frame = 0, 7 do
            pcall(function()
                local env = getfenv(frame)
                if env and type(env) == "table" then
                    for _, k in ipairs(candidates) do
                        local val = nil
                        pcall(function()
                            val = rawget(env, k) or env[k]
                        end)
                        if __isLicenseKeyCandidate(val) then
                            __KEY = val:match("^%s*(.-)%s*$")
                            return
                        end
                    end
                end
            end)
            if __KEY and __KEY ~= "" and __KEY ~= "" then
                return __KEY
            end
        end
    end

    -- 5. Delete stale executor key file if present (cache disabled to prevent auto-execution)
    pcall(function()
        if delfile and isfile and isfile("liyhub_key.txt") then
            delfile("liyhub_key.txt")
        end
    end)
    if __isLicenseKeyCandidate(__KEY) then
        return __KEY:match("^%s*(.-)%s*$")
    end

    -- 6. Check Roblox global environment
    if getrenv and getrenv()._G then
        for _, k in ipairs(candidates) do
            if __isLicenseKeyCandidate(getrenv()._G[k]) then
                return getrenv()._G[k]:match("^%s*(.-)%s*$")
            end
        end
    end

    return nil
end

__KEY = __resolveKey() or ""

-- ============================================================================
-- OFFICIAL LIYHUB THEME (Exact match with Liyhub UI)
-- ============================================================================
local __Theme = {
    Accent       = Color3.fromRGB(0, 132, 255),       -- Electric Cyan-Blue
    AccentHover  = Color3.fromRGB(0, 155, 255),
    AccentGlow   = Color3.fromRGB(0, 200, 255),
    AccentCyan   = Color3.fromRGB(0, 200, 255),
    Background   = Color3.fromRGB(10, 11, 15),       -- Void Dark
    Surface      = Color3.fromRGB(16, 18, 24),       -- Inset Surface
    Surface2     = Color3.fromRGB(24, 27, 36),       -- Elevated Surface
    SurfaceDeep  = Color3.fromRGB(12, 14, 19),       -- Console Deep Inset
    Border       = Color3.fromRGB(255, 255, 255),    -- Frosted Glass Border
    Text         = Color3.fromRGB(245, 248, 255),    -- Bright Header Text
    TextSecondary= Color3.fromRGB(145, 155, 175),    -- Secondary Slate Text
    SubText      = Color3.fromRGB(145, 155, 175),
    TextMuted    = Color3.fromRGB(85, 95, 115),      -- Dark Micro Labels
    Muted        = Color3.fromRGB(85, 95, 115),
    Success      = Color3.fromRGB(0, 230, 118),      -- Online / 200 OK Green
    Warning      = Color3.fromRGB(250, 204, 21),     -- 401 Warning Yellow
    Error        = Color3.fromRGB(248, 113, 113),    -- 403 / 500 Error Crimson
    ErrorBg      = Color3.fromRGB(28, 14, 18),
    ErrorBorder  = Color3.fromRGB(110, 32, 42),
    ScriptBlox   = Color3.fromRGB(0, 205, 255),      -- Official ScriptBlox Brand Cyan
    Hover        = Color3.fromRGB(32, 36, 48)
}

local function __resolveLogoAsset()
    local logoAsset = nil
    pcall(function()
        if typeof(getcustomasset) == "function" and typeof(writefile) == "function" and typeof(isfile) == "function" then
            if not isfile("liyhub_logo.png") then
                local ok, data = pcall(function()
                    return game:HttpGet("https://raw.githubusercontent.com/loizs1/LiyhubUI/main/liyhub_logo.png")
                end)
                if ok and data and #data > 0 then
                    writefile("liyhub_logo.png", data)
                end
            end
            if isfile("liyhub_logo.png") then
                logoAsset = getcustomasset("liyhub_logo.png")
            end
        end
    end)
    if logoAsset and logoAsset ~= "" then return logoAsset end

    pcall(function()
        if game:GetService("RunService"):IsStudio() then
            logoAsset = "rbxasset://textures/liyhub_logo.png"
        end
    end)
    if logoAsset and logoAsset ~= "" then return logoAsset end

    return "rbxassetid://79284224001788"
end

local __OFFICIAL_LOGO_ASSET = "rbxassetid://79284224001788"

-- ============================================================================
-- ERROR & DIAGNOSTIC CODE DEFINITIONS
-- ============================================================================
local __DiagnosticCodes = {
    IDLE = {
        Code = "STATUS: 200_ONLINE",
        Color = __Theme.Success,
        Line1 = "> [GATEWAY]: Security cluster operational. TLS v1.3 enclave active.",
        Line2 = "> [REQUIREMENT]: You must join our official Discord before obtaining a key.",
        Line3 = "> [DISCORD]: Join https://discord.gg/TTCCnJcyeQ to get & redeem license key."
    },
    VERIFYING = {
        Code = "STATUS: 102_PROCESSING",
        Color = __Theme.AccentGlow,
        Line1 = "> [AUTH]: Transmitting authorization challenge to security host...",
        Line2 = "> [CIPHER]: Validating cryptographic signatures and node timestamp...",
        Line3 = "> [SYNC]: Awaiting authorized payload container stream..."
    },
    SUCCESS = {
        Code = "STATUS: 200_AUTHORIZED",
        Color = __Theme.Success,
        Line1 = "> [ACCESS]: Credential verified. Ephemeral session key allocated.",
        Line2 = "> [CONTAINER]: Decrypting protected runtime payload...",
        Line3 = "> [DISPATCH]: Mounting interface and initializing client core..."
    },
    HWID_MISMATCH = {
        Code = "ERROR: 403_HWID_MISMATCH",
        Color = __Theme.Error,
        Line1 = "> [ERROR]: Hardware ID mismatch detected on authentication server.",
        Line2 = "> [CAUSE]: License key is permanently bound to a different machine.",
        Line3 = "> [ACTION]: Reset HWID via Discord (https://discord.gg/TTCCnJcyeQ)."
    },
    KEY_EXPIRED = {
        Code = "ERROR: 401_KEY_EXPIRED",
        Color = __Theme.Warning,
        Line1 = "> [ERROR]: License session has expired (validity limit reached).",
        Line2 = "> [REQUIREMENT]: Must join official Discord to claim a new key.",
        Line3 = "> [ACTION]: Join https://discord.gg/TTCCnJcyeQ to generate a fresh key."
    },
    INVALID_KEY = {
        Code = "ERROR: 401_UNAUTHORIZED",
        Color = __Theme.Error,
        Line1 = "> [REJECTED]: Authorization challenge failed verification.",
        Line2 = "> [CAUSE]: Credential string empty, malformed, or expired.",
        Line3 = "> [ACTION]: Get a valid key from Discord: https://discord.gg/TTCCnJcyeQ."
    },
    DISCORD_UNLINKED = {
        Code = "ERROR: 402_UNLINKED_ACCOUNT",
        Color = __Theme.Warning,
        Line1 = "> [ERROR]: License key is not linked to a Discord user account.",
        Line2 = "> [REQUIREMENT]: You must join official Discord first before taking key.",
        Line3 = "> [ACTION]: Join https://discord.gg/TTCCnJcyeQ and redeem your key in bot."
    },
    RATE_LIMITED = {
        Code = "ERROR: 429_RATE_LIMITED",
        Color = __Theme.Warning,
        Line1 = "> [PROTECTION]: High-frequency request throttle engaged.",
        Line2 = "> [SECURITY]: Gateway backoff enforced on current node.",
        Line3 = "> [ACTION]: Standby for 10 seconds before transmitting new challenge."
    },
    BLACKLISTED = {
        Code = "ERROR: 403_BLACKLISTED",
        Color = __Theme.Error,
        Line1 = "> [CRITICAL]: License or hardware fingerprint blacklisted.",
        Line2 = "> [CAUSE]: Security violation or tampering detected.",
        Line3 = "> [ACTION]: Access permanently revoked. Contact administration."
    },
    SERVER_DOWN = {
        Code = "ERROR: 503_NETWORK_UNREACHABLE",
        Color = __Theme.Error,
        Line1 = "> [NETWORK]: Failed to connect to Liyhub validation API.",
        Line2 = "> [CAUSE]: Request timeout or network socket blocked.",
        Line3 = "> [ACTION]: Check internet connection and VPN settings."
    }
}

-- ============================================================================
-- CORE ROBLOX SERVICES
-- ============================================================================
local Players = game:GetService("Players")
local UserInputService = nil
pcall(function() UserInputService = game:GetService("UserInputService") end)
local TweenService = nil
pcall(function() TweenService = game:GetService("TweenService") end)
local HttpService = nil
pcall(function() HttpService = game:GetService("HttpService") end)
local RunService = nil
pcall(function() RunService = game:GetService("RunService") end)
local MarketplaceService = nil
pcall(function() MarketplaceService = game:GetService("MarketplaceService") end)

-- Safe GUI Parent Resolver (Prioritize PlayerGui for universal thread capability & bypass CoreGui restrictions)
local function __getSafeGuiParent()
    local LocalPlayer = Players and Players.LocalPlayer
    local guiParent = nil

    if LocalPlayer then
        pcall(function()
            guiParent = LocalPlayer:FindFirstChildOfClass("PlayerGui") or LocalPlayer:WaitForChild("PlayerGui", 3)
        end)
    end
    if not guiParent then
        pcall(function()
            if gethui then
                guiParent = gethui()
            else
                local CoreGui = game:GetService("CoreGui")
                if CoreGui then
                    local test = Instance.new("Folder")
                    test.Parent = CoreGui
                    test:Destroy()
                    guiParent = CoreGui
                end
            end
        end)
    end
    return guiParent
end

-- ============================================================================
-- 1. LOADER PROGRESS OVERLAY (Desktop Sleek & Android/iOS Friendly)
-- ============================================================================
local function __createLoadingOverlay(statusText)
    local guiParent = __getSafeGuiParent()
    if not guiParent then return nil end

    if guiParent:FindFirstChild("LiyHubLoadingGui") then
        pcall(function() guiParent.LiyHubLoadingGui:Destroy() end)
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LiyHubLoadingGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 9999
    ScreenGui.IgnoreGuiInset = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    if typeof(syn) == "table" and typeof(syn.protect_gui) == "function" then
        pcall(syn.protect_gui, ScreenGui)
    elseif typeof(protect_gui) == "function" then
        pcall(protect_gui, ScreenGui)
    elseif typeof(protectgui) == "function" then
        pcall(protectgui, ScreenGui)
    end

    local cam = workspace.CurrentCamera
    local vp = (cam and cam.ViewportSize) or Vector2.new(1280, 720)
    local isTouch = false
    pcall(function()
        if UserInputService then
            isTouch = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
        end
    end)
    local isPhone = isTouch or vp.X < 700

    local targetW = isPhone and 290 or 340
    local targetH = isPhone and 42 or 46
    local topOffset = isPhone and 10 or 14

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.AnchorPoint = Vector2.new(0.5, 0)
    MainFrame.Size = UDim2.fromOffset(targetW, targetH)
    MainFrame.Position = UDim2.new(0.5, 0, 0, topOffset)
    MainFrame.BackgroundColor3 = __Theme.Background
    MainFrame.BackgroundTransparency = 0.05
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = true
    MainFrame.Active = false
    MainFrame.Parent = ScreenGui
    Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

    local barGrad = Instance.new("UIGradient")
    barGrad.Rotation = 35
    barGrad.Color = ColorSequence.new(__Theme.Background, __Theme.Surface)
    barGrad.Parent = MainFrame

    local uiScale = Instance.new("UIScale")
    uiScale.Parent = MainFrame

    local loadScaleConn = nil
    local function updateLoadingScale()
        pcall(function()
            if not ScreenGui or not ScreenGui.Parent or not uiScale or not uiScale.Parent then
                if loadScaleConn then
                    pcall(function() loadScaleConn:Disconnect() end)
                    loadScaleConn = nil
                end
                return
            end
            local sz = ScreenGui.AbsoluteSize
            if sz and sz.X > 0 then
                local scaleX = (sz.X - 32) / targetW
                uiScale.Scale = math.clamp(math.min(scaleX, 1), 0.65, 1)
            end
        end)
    end
    updateLoadingScale()
    pcall(function()
        loadScaleConn = ScreenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateLoadingScale)
    end)

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(255, 255, 255)
    Stroke.Transparency = 0.8
    Stroke.Thickness = 1
    Stroke.Parent = MainFrame

    local LogoFrame = Instance.new("Frame")
    LogoFrame.Name = "LogoFrame"
    LogoFrame.Size = UDim2.fromOffset(26, 26)
    LogoFrame.Position = UDim2.new(0, 10, 0, 5)
    LogoFrame.BackgroundColor3 = __Theme.Surface2
    LogoFrame.BackgroundTransparency = 0.35
    LogoFrame.Parent = MainFrame
    Instance.new("UICorner", LogoFrame).CornerRadius = UDim.new(0, 7)
    local lfStroke = Instance.new("UIStroke", LogoFrame)
    lfStroke.Color = Color3.fromRGB(255, 255, 255)
    lfStroke.Transparency = 0.72

    local LogoImg = Instance.new("ImageLabel")
    LogoImg.Size = UDim2.new(1, -4, 1, -4)
    LogoImg.AnchorPoint = Vector2.new(0.5, 0.5)
    LogoImg.Position = UDim2.fromScale(0.5, 0.5)
    LogoImg.BackgroundTransparency = 1
    LogoImg.Image = __resolveLogoAsset()
    LogoImg.ScaleType = Enum.ScaleType.Fit
    LogoImg.Parent = LogoFrame
    Instance.new("UICorner", LogoImg).CornerRadius = UDim.new(0, 5)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(0, 56, 0, 15)
    Title.Position = UDim2.new(0, 44, 0, 5)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.Text = "LIYHUB"
    Title.TextColor3 = __Theme.Text
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = MainFrame

    local Subtitle = Instance.new("TextLabel")
    Subtitle.Name = "Subtitle"
    Subtitle.Size = UDim2.new(1, -145, 0, 15)
    Subtitle.Position = UDim2.new(0, 94, 0, 7)
    Subtitle.BackgroundTransparency = 1
    Subtitle.Font = Enum.Font.Gotham
    Subtitle.Text = "| " .. (statusText or "Loading Payload...")
    Subtitle.TextColor3 = __Theme.TextSecondary
    Subtitle.TextSize = 10
    Subtitle.TextTruncate = Enum.TextTruncate.AtEnd
    Subtitle.TextXAlignment = Enum.TextXAlignment.Left
    Subtitle.Parent = MainFrame

    local PctLabel = Instance.new("TextLabel")
    PctLabel.Name = "PctLabel"
    PctLabel.Size = UDim2.new(0, 44, 0, 15)
    PctLabel.Position = UDim2.new(1, -50, 0, 7)
    PctLabel.BackgroundTransparency = 1
    PctLabel.Font = Enum.Font.GothamBold
    PctLabel.Text = "0%"
    PctLabel.TextColor3 = Color3.fromRGB(0, 200, 255)
    PctLabel.TextSize = 10.5
    PctLabel.TextXAlignment = Enum.TextXAlignment.Right
    PctLabel.Parent = MainFrame

    local Track = Instance.new("Frame")
    Track.Size = UDim2.new(1, -20, 0, 4)
    Track.Position = UDim2.new(0, 10, 1, -8)
    Track.BackgroundColor3 = __Theme.SurfaceDeep
    Track.BorderSizePixel = 0
    Track.Parent = MainFrame
    Instance.new("UICorner", Track).CornerRadius = UDim.new(0, 2)

    local FillBar = Instance.new("Frame")
    FillBar.Name = "FillBar"
    FillBar.Size = UDim2.new(0, 0, 1, 0)
    FillBar.BackgroundColor3 = __Theme.Accent
    FillBar.BorderSizePixel = 0
    FillBar.Parent = Track
    Instance.new("UICorner", FillBar).CornerRadius = UDim.new(0, 2)

    local fillGrad = Instance.new("UIGradient")
    fillGrad.Color = ColorSequence.new(__Theme.Accent, Color3.fromRGB(0, 200, 255))
    fillGrad.Parent = FillBar

    ScreenGui.Parent = guiParent

    local TweenService = game:GetService("TweenService")
    local overlayStartTime = os.clock()

    local overlayObj = {
        Update = function(self, pct, text)
            pcall(function()
                pct = math.clamp(pct, 0, 100)
                local elapsed = os.clock() - overlayStartTime
                local timeStr = string.format("(%.1fs)", elapsed)
                if text then
                    Subtitle.Text = "| " .. text .. " " .. timeStr
                end
                PctLabel.Text = string.format("%d%%", pct)
                TweenService:Create(FillBar, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(pct / 100, 0, 1, 0)
                }):Play()
            end)
        end,
        GetElapsed = function(self)
            return os.clock() - overlayStartTime
        end,
        Destroy = function(self)
            if loadScaleConn then
                pcall(function() loadScaleConn:Disconnect() end)
                loadScaleConn = nil
            end
            pcall(function() ScreenGui:Destroy() end)
        end
    }

    -- Safety watchdog: auto-dismiss overlay after 6s max so it never stays stuck on screen
    task.delay(6, function()
        pcall(function()
            if ScreenGui and ScreenGui.Parent then
                overlayObj:Destroy()
            end
        end)
    end)

    return overlayObj
end

-- ============================================================================
-- 2. KEY VERIFICATION GATEWAY & SCRIPT DIRECTORY (Authentic Liyhub UI)
-- ============================================================================
local function __showKeyPromptGui(getKeyUrl, onKeySubmitted, initialGameName)
    local guiParent = __getSafeGuiParent()
    if not guiParent then return end

    if guiParent:FindFirstChild("LiyHubKeySystemGui") then
        pcall(function() guiParent.LiyHubKeySystemGui:Destroy() end)
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "LiyHubKeySystemGui"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.DisplayOrder = 999999
    ScreenGui.IgnoreGuiInset = true
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    if typeof(syn) == "table" and typeof(syn.protect_gui) == "function" then
        pcall(syn.protect_gui, ScreenGui)
    elseif typeof(protect_gui) == "function" then
        pcall(protect_gui, ScreenGui)
    elseif typeof(protectgui) == "function" then
        pcall(protectgui, ScreenGui)
    end

    local TweenService = game:GetService("TweenService")
    local UserInputService = game:GetService("UserInputService")
    local MarketplaceService = game:GetService("MarketplaceService")
    local HttpService = game:GetService("HttpService")
    local Players = game:GetService("Players")
    local LocalPlayer = Players.LocalPlayer
    local currentPlaceId = game.PlaceId or 0

    -- UI Element Helper Builders
    local function corner(p, r)
        local x = Instance.new("UICorner")
        x.CornerRadius = UDim.new(0, r or 8)
        x.Parent = p
        return x
    end

    local function stroke(p, col, tr, th)
        local x = Instance.new("UIStroke")
        x.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        x.Color = col or __Theme.Border
        x.Thickness = th or 1
        local trans = tr or 0
        if x.Color == Color3.fromRGB(255, 255, 255) and trans < 0.6 then
            trans = 0.85
        end
        x.Transparency = trans
        x.Parent = p
        return x
    end

    local function pad(p, topOrAll, right, bottom, left)
        local x = Instance.new("UIPadding")
        local t = topOrAll or 8
        local r = right or t
        local b = bottom or t
        local l = left or r
        x.PaddingTop = UDim.new(0, t)
        x.PaddingRight = UDim.new(0, r)
        x.PaddingBottom = UDim.new(0, b)
        x.PaddingLeft = UDim.new(0, l)
        x.Parent = p
        return x
    end

    local function text(p, s, z, c)
        local x = Instance.new("TextLabel")
        x.BackgroundTransparency = 1
        x.Text = s or ""
        x.TextColor3 = c or __Theme.Text
        x.TextSize = z or 13
        x.Font = Enum.Font.GothamBold
        x.TextXAlignment = Enum.TextXAlignment.Left
        x.TextWrapped = true
        x.Parent = p
        return x
    end

    local function tween(inst, duration, props)
        pcall(function()
            TweenService:Create(inst, TweenInfo.new(duration or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
        end)
    end

    -- Adaptive Device Layout (Exact Liyhub UI Specification)
    local function getDeviceLayout()
        local cam = workspace.CurrentCamera
        local vp = (cam and cam.ViewportSize) or Vector2.new(1280, 720)
        local isTouch = false
        pcall(function()
            if UserInputService then
                isTouch = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
            end
        end)
        if isTouch or vp.X < 700 then
            local w = math.clamp(math.floor(vp.X * 0.88), 440, 520)
            local h = math.clamp(math.floor(vp.Y * 0.82), 290, 325)
            local leftW = math.floor(w * 0.58)
            return "Mobile", w, h, leftW, 46
        elseif vp.X < 1024 or vp.Y < 640 then
            local w = math.clamp(math.floor(vp.X * 0.82), 540, 620)
            local h = math.clamp(math.floor(vp.Y * 0.80), 340, 380)
            local leftW = math.floor(w * 0.58)
            return "Tablet", w, h, leftW, 50
        else
            return "PC", 680, 385, 390, 54
        end
    end

    local devType, winW, winH, leftPanelW, topbarH = getDeviceLayout()
    local isMobile = (devType == "Mobile")

    -- Detect Current Game Information
    local detectedGameTitle = initialGameName
    if not detectedGameTitle or detectedGameTitle == "" then
        pcall(function()
            local assetInfo = MarketplaceService:GetProductInfo(currentPlaceId)
            if assetInfo and assetInfo.Name then
                detectedGameTitle = assetInfo.Name
            end
        end)
    end
    if not detectedGameTitle or detectedGameTitle == "" then
        detectedGameTitle = (currentPlaceId > 0) and ("Game " .. tostring(currentPlaceId)) or "Universal"
    end

    local targetScript = {
        Id = __SCRIPT_ID or "auto",
        Name = detectedGameTitle,
        Desc = "Targeting Experience • PlaceId: " .. tostring(currentPlaceId),
        Status = "ONLINE"
    }

    local Main = Instance.new("Frame")
    Main.Name = "LiyhubLoaderWindow"
    Main.Size = UDim2.fromOffset(winW, winH)
    Main.Position = UDim2.fromScale(0.5, 0.5)
    Main.AnchorPoint = Vector2.new(0.5, 0.5)
    Main.BackgroundColor3 = __Theme.Background
    Main.BackgroundTransparency = 0.04
    Main.ClipsDescendants = true
    Main.Active = true
    Main.Parent = ScreenGui
    corner(Main, 16)
    stroke(Main, Color3.fromRGB(255, 255, 255), 0.75, 1)

    local bgGrad = Instance.new("UIGradient")
    bgGrad.Rotation = 35
    bgGrad.Color = ColorSequence.new(__Theme.Background, __Theme.Surface)
    bgGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.1),
        NumberSequenceKeypoint.new(1, 0.32)
    })
    bgGrad.Parent = Main

    local uiScale = Instance.new("UIScale")
    uiScale.Parent = Main

    local keyScaleConn = nil
    local function updateWindowScale()
        pcall(function()
            if not ScreenGui or not ScreenGui.Parent or not uiScale or not uiScale.Parent then
                if keyScaleConn then
                    pcall(function() keyScaleConn:Disconnect() end)
                    keyScaleConn = nil
                end
                return
            end
            local dev, w, h, lW, tbH = getDeviceLayout()
            winW = w
            winH = h
            leftPanelW = lW
            topbarH = tbH
            Main.Size = UDim2.fromOffset(w, h)

            local cam = workspace.CurrentCamera
            local vp = (cam and cam.ViewportSize) or Vector2.new(1920, 1080)
            local scaleX = (vp.X - 20) / w
            local scaleY = (vp.Y - 20) / h
            uiScale.Scale = math.clamp(math.min(scaleX, scaleY, 1), 0.52, 1)
        end)
    end
    updateWindowScale()
    pcall(function()
        keyScaleConn = ScreenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateWindowScale)
    end)
    if workspace.CurrentCamera then
        workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(updateWindowScale)
    end

    local function destroyKeyGui()
        if keyScaleConn then
            pcall(function() keyScaleConn:Disconnect() end)
            keyScaleConn = nil
        end
        pcall(function()
            ScreenGui.Enabled = false
            if Main then
                Main.Visible = false
                Main:Destroy()
            end
            ScreenGui:ClearAllChildren()
            ScreenGui.Parent = nil
            ScreenGui:Destroy()
        end)
    end

    -- ========================================================================
    -- TOPBAR
    -- ========================================================================
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, topbarH)
    Topbar.BackgroundTransparency = 1
    Topbar.ZIndex = 3
    Topbar.Parent = Main

    -- Draggable Topbar
    pcall(function()
        local dragging, dragStart, startPos, dragInput
        Topbar.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = Main.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        Topbar.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        if UserInputService then
            UserInputService.InputChanged:Connect(function(input)
                if input == dragInput and dragging then
                    pcall(function()
                        local delta = input.Position - dragStart
                        Main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
                    end)
                end
            end)
        end
    end)

    local logoFrameDim = isMobile and 30 or 34
    local logoFrameY = math.floor((topbarH - logoFrameDim) / 2)

    local logoFrame = Instance.new("Frame")
    logoFrame.Name = "TopbarLogoFrame"
    logoFrame.Size = UDim2.fromOffset(logoFrameDim, logoFrameDim)
    logoFrame.Position = UDim2.fromOffset(isMobile and 12 or 16, logoFrameY)
    logoFrame.BackgroundColor3 = __Theme.Surface2
    logoFrame.BackgroundTransparency = 0.35
    logoFrame.ZIndex = 5
    logoFrame.Parent = Topbar
    corner(logoFrame, 8)
    stroke(logoFrame, Color3.fromRGB(255, 255, 255), 0.72)

    local logoImg = Instance.new("ImageLabel")
    logoImg.Name = "TopbarLogo"
    logoImg.Size = UDim2.new(1, -6, 1, -6)
    logoImg.AnchorPoint = Vector2.new(0.5, 0.5)
    logoImg.Position = UDim2.fromScale(0.5, 0.5)
    logoImg.BackgroundTransparency = 1
    logoImg.Image = __resolveLogoAsset()
    logoImg.ScaleType = Enum.ScaleType.Fit
    logoImg.ZIndex = 6
    logoImg.Parent = logoFrame
    corner(logoImg, 6)

    local titleX = (isMobile and 12 or 16) + logoFrameDim + 12

    local winTitle = text(Topbar, "Liyhub", isMobile and 14 or 16, __Theme.Text)
    winTitle.Position = UDim2.fromOffset(titleX, logoFrameY - 1)
    winTitle.Size = UDim2.new(0, 140, 0, 18)
    winTitle.Font = Enum.Font.GothamBold
    winTitle.ZIndex = 5

    local winSub = text(Topbar, "License Verification Gateway", isMobile and 9.5 or 10.5, __Theme.SubText)
    winSub.Position = UDim2.fromOffset(titleX, logoFrameY + 17)
    winSub.Size = UDim2.new(0, 200, 0, 14)
    winSub.Font = Enum.Font.Gotham
    winSub.ZIndex = 5

    -- Close Button
    local closeBtn = Instance.new("TextButton")
    closeBtn.Name = "CloseBtn"
    closeBtn.Text = ""
    closeBtn.AutoButtonColor = false
    closeBtn.BackgroundColor3 = __Theme.Surface
    closeBtn.Size = UDim2.fromOffset(26, 26)
    closeBtn.Position = UDim2.new(1, -38, 0.5, -13)
    closeBtn.ZIndex = 5
    closeBtn.Parent = Topbar
    corner(closeBtn, 7)
    stroke(closeBtn, __Theme.Border, 0.35)

    local closeIco = Instance.new("ImageLabel")
    closeIco.Size = UDim2.fromOffset(13, 13)
    closeIco.Position = UDim2.fromOffset(6.5, 6.5)
    closeIco.BackgroundTransparency = 1
    closeIco.Image = "rbxassetid://10747384394"
    closeIco.ImageColor3 = __Theme.SubText
    closeIco.ScaleType = Enum.ScaleType.Fit
    closeIco.ZIndex = 6
    closeIco.Parent = closeBtn

    closeBtn.MouseEnter:Connect(function()
        tween(closeBtn, 0.1, { BackgroundColor3 = __Theme.Hover })
        tween(closeIco, 0.1, { ImageColor3 = __Theme.Text })
    end)
    closeBtn.MouseLeave:Connect(function()
        tween(closeBtn, 0.1, { BackgroundColor3 = __Theme.Surface })
        tween(closeIco, 0.1, { ImageColor3 = __Theme.SubText })
    end)
    closeBtn.MouseButton1Click:Connect(function()
        destroyKeyGui()
    end)

    -- Topbar Glowing Separator Line
    local topLine = Instance.new("Frame")
    topLine.Name = "TopLine"
    topLine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    topLine.BorderSizePixel = 0
    topLine.Position = UDim2.fromOffset(isMobile and 12 or 16, topbarH)
    topLine.Size = UDim2.new(1, isMobile and -24 or -32, 0, 1)
    topLine.ZIndex = 4
    topLine.Parent = Main

    local lineGrad = Instance.new("UIGradient")
    lineGrad.Color = ColorSequence.new(Color3.fromRGB(255, 255, 255))
    lineGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.5),
        NumberSequenceKeypoint.new(0.2, 0.1),
        NumberSequenceKeypoint.new(0.8, 0.1),
        NumberSequenceKeypoint.new(1, 0.5),
    })
    lineGrad.Parent = topLine

    -- ========================================================================
    -- BODY CONTAINER
    -- ========================================================================
    local Body = Instance.new("Frame")
    Body.Name = "Body"
    Body.Size = UDim2.new(1, isMobile and -24 or -32, 1, -(topbarH + 12))
    Body.Position = UDim2.new(0, isMobile and 12 or 16, 0, topbarH + 6)
    Body.BackgroundTransparency = 1
    Body.ZIndex = 2
    Body.Parent = Main

    -- ========================================================================
    -- LEFT PANEL: KEY AUTH & SECURITY DIAGNOSTICS CONSOLE
    -- ========================================================================
    local KeyPanel = Instance.new("Frame")
    KeyPanel.Name = "KeyPanel"
    KeyPanel.Size = UDim2.new(0, leftPanelW, 1, 0)
    KeyPanel.BackgroundColor3 = __Theme.Surface
    KeyPanel.BackgroundTransparency = 0.25
    KeyPanel.ZIndex = 3
    KeyPanel.Parent = Body
    corner(KeyPanel, 11)
    stroke(KeyPanel, __Theme.Border, 0.35)
    pad(KeyPanel, 8, 10, 8, 10)

    -- Profile Bar
    local profileBar = Instance.new("Frame")
    profileBar.Name = "ProfileBar"
    profileBar.Size = UDim2.new(1, 0, 0, 36)
    profileBar.BackgroundColor3 = __Theme.Surface2
    profileBar.BackgroundTransparency = 0.45
    profileBar.Parent = KeyPanel
    corner(profileBar, 7)
    stroke(profileBar, __Theme.Border, 0.3)

    local avatar = Instance.new("ImageLabel")
    avatar.Size = UDim2.fromOffset(26, 26)
    avatar.Position = UDim2.new(0, 5, 0.5, -13)
    avatar.BackgroundColor3 = __Theme.Surface
    avatar.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
    avatar.Parent = profileBar
    corner(avatar, 13)

    local statusDot = Instance.new("Frame")
    statusDot.Size = UDim2.fromOffset(6, 6)
    statusDot.Position = UDim2.new(1, -5, 1, -5)
    statusDot.BackgroundColor3 = __Theme.Success
    statusDot.BorderSizePixel = 0
    statusDot.Parent = avatar
    corner(statusDot, 3)

    task.spawn(function()
        if LocalPlayer then
            pcall(function()
                local content = Players:GetUserThumbnailAsync(
                    LocalPlayer.UserId,
                    Enum.ThumbnailType.HeadShot,
                    Enum.ThumbnailSize.Size100x100
                )
                if content then avatar.Image = content end
            end)
        end
    end)

    local profName = text(profileBar, LocalPlayer and LocalPlayer.DisplayName or "Client User", 11, __Theme.Text)
    profName.Position = UDim2.new(0, 38, 0, 4)
    profName.Size = UDim2.new(0.5, -38, 0, 14)
    profName.Font = Enum.Font.GothamBold
    profName.TextTruncate = Enum.TextTruncate.AtEnd

    local profHandle = text(profileBar, LocalPlayer and ("@" .. LocalPlayer.Name) or "@user", 9, __Theme.SubText)
    profHandle.Position = UDim2.new(0, 38, 0, 18)
    profHandle.Size = UDim2.new(0.5, -38, 0, 13)
    profHandle.Font = Enum.Font.Gotham
    profHandle.TextTruncate = Enum.TextTruncate.AtEnd

    local targetTag = text(profileBar, "TARGET: " .. string.upper(targetScript.Name), 9, __Theme.AccentGlow)
    targetTag.Position = UDim2.new(0.5, 0, 0, 0)
    targetTag.Size = UDim2.new(0.5, -8, 1, 0)
    targetTag.Font = Enum.Font.GothamBold
    targetTag.TextXAlignment = Enum.TextXAlignment.Right
    targetTag.TextTruncate = Enum.TextTruncate.AtEnd

    -- License Key Input
    local inputLabel = text(KeyPanel, "LICENSE KEY", 9.5, __Theme.SubText)
    inputLabel.Position = UDim2.new(0, 0, 0, 42)
    inputLabel.Size = UDim2.new(1, 0, 0, 14)
    inputLabel.Font = Enum.Font.GothamBold

    local inputFrame = Instance.new("Frame")
    inputFrame.Name = "InputFrame"
    inputFrame.Size = UDim2.new(1, 0, 0, 32)
    inputFrame.Position = UDim2.new(0, 0, 0, 58)
    inputFrame.BackgroundColor3 = __Theme.SurfaceDeep
    inputFrame.Parent = KeyPanel
    corner(inputFrame, 6)
    local inStroke = stroke(inputFrame, __Theme.Border, 0.35)

    local inputBox = Instance.new("TextBox")
    inputBox.Name = "KeyInput"
    inputBox.Size = UDim2.new(1, -16, 1, 0)
    inputBox.Position = UDim2.new(0, 8, 0, 0)
    inputBox.BackgroundTransparency = 1
    inputBox.Font = Enum.Font.GothamMedium
    inputBox.Text = (__KEY and __KEY ~= "") and __KEY or ""
    inputBox.PlaceholderText = "Paste license key here..."
    inputBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    inputBox.PlaceholderColor3 = __Theme.Muted
    inputBox.TextSize = 11.5
    inputBox.TextXAlignment = Enum.TextXAlignment.Left
    inputBox.ClearTextOnFocus = false
    inputBox.Parent = inputFrame

    inputBox.Focused:Connect(function()
        tween(inStroke, 0.15, { Color = __Theme.Accent, Transparency = 0.2 })
    end)
    inputBox.FocusLost:Connect(function()
        tween(inStroke, 0.15, { Color = __Theme.Border, Transparency = 0.35 })
    end)

    -- Security Diagnostics Console
    local consoleBox = Instance.new("Frame")
    consoleBox.Name = "DiagnosticsConsole"
    consoleBox.Size = UDim2.new(1, 0, 0, isMobile and 84 or 92)
    consoleBox.Position = UDim2.new(0, 0, 0, 96)
    consoleBox.BackgroundColor3 = __Theme.SurfaceDeep
    consoleBox.ClipsDescendants = true
    consoleBox.Parent = KeyPanel
    corner(consoleBox, 6)
    local consoleStroke = stroke(consoleBox, __Theme.Border, 0.35)

    local consoleHeader = Instance.new("Frame")
    consoleHeader.Size = UDim2.new(1, 0, 0, 20)
    consoleHeader.BackgroundColor3 = __Theme.Surface2
    consoleHeader.BackgroundTransparency = 0.45
    consoleHeader.Parent = consoleBox

    local consoleTitle = text(consoleHeader, "SECURITY DIAGNOSTICS", 9, __Theme.SubText)
    consoleTitle.Position = UDim2.new(0, 8, 0, 0)
    consoleTitle.Size = UDim2.new(0.5, 0, 1, 0)
    consoleTitle.Font = Enum.Font.GothamBold

    local statusTag = text(consoleHeader, __DiagnosticCodes.IDLE.Code, 9, __Theme.Success)
    statusTag.Position = UDim2.new(0.5, 0, 0, 0)
    statusTag.Size = UDim2.new(0.5, -8, 1, 0)
    statusTag.Font = Enum.Font.GothamBold
    statusTag.TextXAlignment = Enum.TextXAlignment.Right

    local logLine1 = text(consoleBox, __DiagnosticCodes.IDLE.Line1, 10, __Theme.Text)
    logLine1.Position = UDim2.new(0, 8, 0, 24)
    logLine1.Size = UDim2.new(1, -16, 0, 16)
    logLine1.Font = Enum.Font.GothamMedium
    logLine1.TextTruncate = Enum.TextTruncate.AtEnd

    local logLine2 = text(consoleBox, __DiagnosticCodes.IDLE.Line2, 9.5, __Theme.SubText)
    logLine2.Position = UDim2.new(0, 8, 0, 42)
    logLine2.Size = UDim2.new(1, -16, 0, 16)
    logLine2.Font = Enum.Font.Gotham
    logLine2.TextTruncate = Enum.TextTruncate.AtEnd

    local logLine3 = text(consoleBox, __DiagnosticCodes.IDLE.Line3, 9.5, __Theme.Muted)
    logLine3.Position = UDim2.new(0, 8, 0, 60)
    logLine3.Size = UDim2.new(1, -16, 0, 16)
    logLine3.Font = Enum.Font.Gotham
    logLine3.TextTruncate = Enum.TextTruncate.AtEnd

    local function SetDiagnosticState(diagKey)
        local diag = __DiagnosticCodes[diagKey] or __DiagnosticCodes.IDLE
        statusTag.Text = diag.Code
        statusTag.TextColor3 = diag.Color
        logLine1.Text = diag.Line1
        logLine2.Text = diag.Line2
        logLine3.Text = diag.Line3

        if diag.Color == __Theme.Error then
            tween(consoleStroke, 0.2, { Color = __Theme.ErrorBorder, Transparency = 0 })
            tween(consoleBox, 0.2, { BackgroundColor3 = __Theme.ErrorBg })
            logLine1.TextColor3 = __Theme.Error
        else
            tween(consoleStroke, 0.2, { Color = __Theme.Border, Transparency = 0.35 })
            tween(consoleBox, 0.2, { BackgroundColor3 = __Theme.SurfaceDeep })
            logLine1.TextColor3 = __Theme.Text
        end
    end

    -- Action Buttons
    local buttonRow = Instance.new("Frame")
    buttonRow.Size = UDim2.new(1, 0, 0, 32)
    buttonRow.Position = UDim2.new(0, 0, 0, isMobile and 188 or 198)
    buttonRow.BackgroundTransparency = 1
    buttonRow.Parent = KeyPanel

    local submitBtn = Instance.new("TextButton")
    submitBtn.Name = "SubmitBtn"
    submitBtn.Size = UDim2.new(0.5, -4, 1, 0)
    submitBtn.BackgroundColor3 = __Theme.Accent
    submitBtn.AutoButtonColor = false
    submitBtn.Text = ""
    submitBtn.Parent = buttonRow
    corner(submitBtn, 7)
    stroke(submitBtn, __Theme.AccentGlow, 0.35)

    local submitTxt = text(submitBtn, "Authenticate", 11.5, Color3.fromRGB(255, 255, 255))
    submitTxt.Size = UDim2.fromScale(1, 1)
    submitTxt.TextXAlignment = Enum.TextXAlignment.Center
    submitTxt.Font = Enum.Font.GothamBold

    submitBtn.MouseEnter:Connect(function()
        tween(submitBtn, 0.1, { BackgroundColor3 = __Theme.AccentHover })
    end)
    submitBtn.MouseLeave:Connect(function()
        tween(submitBtn, 0.1, { BackgroundColor3 = __Theme.Accent })
    end)

    local getKeyBtn = Instance.new("TextButton")
    getKeyBtn.Name = "GetKeyBtn"
    getKeyBtn.Size = UDim2.new(0.5, -4, 1, 0)
    getKeyBtn.Position = UDim2.new(0.5, 4, 0, 0)
    getKeyBtn.BackgroundColor3 = __Theme.Surface2
    getKeyBtn.BackgroundTransparency = 0.45
    getKeyBtn.AutoButtonColor = false
    getKeyBtn.Text = ""
    getKeyBtn.Parent = buttonRow
    corner(getKeyBtn, 7)
    stroke(getKeyBtn, __Theme.Border, 0.3)

    local getKeyTxt = text(getKeyBtn, "Get Key (Discord)", 11, __Theme.SubText)
    getKeyTxt.Size = UDim2.fromScale(1, 1)
    getKeyTxt.TextXAlignment = Enum.TextXAlignment.Center
    getKeyTxt.Font = Enum.Font.GothamMedium

    getKeyBtn.MouseEnter:Connect(function()
        tween(getKeyBtn, 0.1, { BackgroundColor3 = __Theme.Hover, BackgroundTransparency = 0 })
        tween(getKeyTxt, 0.1, { TextColor3 = __Theme.Text })
    end)
    getKeyBtn.MouseLeave:Connect(function()
        tween(getKeyBtn, 0.1, { BackgroundColor3 = __Theme.Surface2, BackgroundTransparency = 0.45 })
        tween(getKeyTxt, 0.1, { TextColor3 = __Theme.SubText })
    end)

    local resolvedDiscordUrl = (__DISCORD_URL and __DISCORD_URL ~= "" and __DISCORD_URL ~= "https://discord.gg/YSJDUB9kUf")
        and __DISCORD_URL
        or "https://discord.gg/TTCCnJcyeQ"

    getKeyBtn.MouseButton1Click:Connect(function()
        pcall(function()
            if setclipboard then
                setclipboard(resolvedDiscordUrl)
            elseif toclipboard then
                toclipboard(resolvedDiscordUrl)
            end
        end)
        getKeyTxt.Text = "Discord Copied!"
        logLine1.Text = "> [DISCORD]: Link https://discord.gg/TTCCnJcyeQ copied to clipboard!"
        logLine2.Text = "> [REQUIREMENT]: You must join our official Discord before obtaining a key."
        logLine3.Text = "> [ACTION]: Join server, claim license key via bot channel, then paste here."
        task.delay(2.5, function()
            getKeyTxt.Text = "Get Key (Discord)"
        end)
    end)

    local isSubmitting = false
    local function doSubmitKey()
        if isSubmitting then return end
        local entered = inputBox.Text:match("^%s*(.-)%s*$")
        if not __isLicenseKeyCandidate(entered) then
            SetDiagnosticState("INVALID_KEY")
            logLine1.Text = "> [INPUT]: Key is invalid or empty. Minimum length: 6."
            logLine2.Text = "> [CAUSE]: Please paste a valid license token."
            logLine3.Text = "> [ACTION]: Copy key from Discord/portal and retry."
            return
        end

        isSubmitting = true
        submitTxt.Text = "Authenticating..."
        SetDiagnosticState("VERIFYING")

        task.spawn(function()
            local callOk, res1, res2, res3 = pcall(onKeySubmitted, entered)
            local success, err, errCode
            if not callOk then
                local luaError = tostring(res1 or "Unknown client error")
                warn("[LiyHub] Verification error: " .. luaError)
                success = false
                err = luaError
                errCode = "CLIENT_ERROR"
            else
                success = res1
                err = res2
                errCode = res3
            end

            if success then
                SetDiagnosticState("SUCCESS")
                submitTxt.Text = "Authorized"
                pcall(function()
                    if delfile and isfile and isfile("liyhub_key.txt") then
                        delfile("liyhub_key.txt")
                    end
                end)
                destroyKeyGui()
            else
                isSubmitting = false
                submitTxt.Text = "Authenticate"

                local codeStr = tostring(errCode or "")
                local errLower = string.lower(tostring(err or ""))

                if codeStr == "HWID_MISMATCH" or string.find(errLower, "hwid") then
                    SetDiagnosticState("HWID_MISMATCH")
                elseif codeStr == "KEY_EXPIRED" or codeStr == "LICENSE_EXPIRED" or string.find(errLower, "expired") then
                    SetDiagnosticState("KEY_EXPIRED")
                elseif codeStr == "DISCORD_UNLINKED" or codeStr == "DISCORD_NOT_LINKED" or string.find(errLower, "discord") or string.find(errLower, "redeem") then
                    SetDiagnosticState("DISCORD_UNLINKED")
                elseif codeStr == "BLACKLISTED" or codeStr == "LICENSE_BLACKLISTED" or string.find(errLower, "blacklist") then
                    SetDiagnosticState("BLACKLISTED")
                elseif codeStr == "RATE_LIMITED" or string.find(errLower, "rate") or string.find(errLower, "too many") then
                    SetDiagnosticState("RATE_LIMITED")
                elseif codeStr == "SERVER_DOWN" or string.find(errLower, "connect") or string.find(errLower, "server connection error") or string.find(errLower, "handshake failed") then
                    SetDiagnosticState("SERVER_DOWN")
                elseif codeStr == "CLIENT_ERROR" then
                    SetDiagnosticState("INVALID_KEY")
                    logLine1.Text = "> [RUNTIME ERROR]: " .. tostring(err):sub(1, 75)
                    logLine2.Text = "> [CAUSE]: Loader internal error during execution."
                    logLine3.Text = "> [ACTION]: Check executor console output."
                else
                    SetDiagnosticState("INVALID_KEY")
                    if err and err ~= "" then
                        logLine1.Text = "> [SERVER]: " .. tostring(err):sub(1, 80)
                    end
                end
            end
        end)
    end

    submitBtn.MouseButton1Click:Connect(doSubmitKey)
    inputBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then
            doSubmitKey()
        end
    end)

    -- Footer note on KeyPanel
    local footerNote = text(KeyPanel, "LIYHUB BOOTSTRAPPER v2.4 • PROTECTED BY LIYHUB DRM", 8.5, __Theme.Muted)
    footerNote.Position = UDim2.new(0, 0, 1, -12)
    footerNote.Size = UDim2.new(1, 0, 0, 12)
    footerNote.Font = Enum.Font.Gotham

    -- ========================================================================
    -- RIGHT PANEL: SUPPORTED SCRIPT CATALOG (Database Synced)
    -- ========================================================================
    local RightPanel = Instance.new("Frame")
    RightPanel.Name = "RightPanel"
    RightPanel.Size = UDim2.new(1, -(leftPanelW + 10), 1, 0)
    RightPanel.Position = UDim2.new(0, leftPanelW + 10, 0, 0)
    RightPanel.BackgroundColor3 = __Theme.Surface
    RightPanel.BackgroundTransparency = 0.25
    RightPanel.ZIndex = 3
    RightPanel.Parent = Body
    corner(RightPanel, 11)
    pad(RightPanel, 8, 10, 8, 10)

    -- Header: SUPPORTED SCRIPTS + Count Tag
    local listHeader = Instance.new("Frame")
    listHeader.Size = UDim2.new(1, 0, 0, 20)
    listHeader.BackgroundTransparency = 1
    listHeader.Parent = RightPanel

    local listTitle = text(listHeader, "SUPPORTED SCRIPTS", 10.5, __Theme.SubText)
    listTitle.Size = UDim2.new(0.6, 0, 1, 0)
    listTitle.Font = Enum.Font.GothamBold

    local countBadge = text(listHeader, "SYNCING...", 9, __Theme.AccentGlow)
    countBadge.Position = UDim2.new(0.6, 0, 0, 0)
    countBadge.Size = UDim2.new(0.4, 0, 1, 0)
    countBadge.Font = Enum.Font.GothamBold
    countBadge.TextXAlignment = Enum.TextXAlignment.Right

    -- Search Box
    local searchBoxFrame = Instance.new("Frame")
    searchBoxFrame.Name = "SearchFrame"
    searchBoxFrame.Size = UDim2.new(1, 0, 0, 24)
    searchBoxFrame.Position = UDim2.new(0, 0, 0, 24)
    searchBoxFrame.BackgroundColor3 = __Theme.SurfaceDeep
    searchBoxFrame.Parent = RightPanel
    corner(searchBoxFrame, 6)
    stroke(searchBoxFrame, __Theme.Border, 0.3)

    local searchIcon = Instance.new("ImageLabel")
    searchIcon.Size = UDim2.fromOffset(11, 11)
    searchIcon.Position = UDim2.new(0, 8, 0.5, -5.5)
    searchIcon.BackgroundTransparency = 1
    searchIcon.Image = "rbxassetid://10709805569"
    searchIcon.ImageColor3 = __Theme.SubText
    searchIcon.ScaleType = Enum.ScaleType.Fit
    searchIcon.Parent = searchBoxFrame

    local searchBox = Instance.new("TextBox")
    searchBox.Name = "SearchBox"
    searchBox.Size = UDim2.new(1, -26, 1, 0)
    searchBox.Position = UDim2.new(0, 24, 0, 0)
    searchBox.BackgroundTransparency = 1
    searchBox.Font = Enum.Font.Gotham
    searchBox.PlaceholderText = "Search supported games..."
    searchBox.PlaceholderColor3 = __Theme.Muted
    searchBox.Text = ""
    searchBox.TextColor3 = __Theme.Text
    searchBox.TextSize = 10
    searchBox.ClearTextOnFocus = false
    searchBox.TextXAlignment = Enum.TextXAlignment.Left
    searchBox.Parent = searchBoxFrame

    -- Scrollable Script Catalog
    local scrollList = Instance.new("ScrollingFrame")
    scrollList.Name = "ScriptScroll"
    scrollList.Size = UDim2.new(1, 0, 1, -74)
    scrollList.Position = UDim2.new(0, 0, 0, 52)
    scrollList.BackgroundTransparency = 1
    scrollList.BorderSizePixel = 0
    scrollList.ScrollBarThickness = 3
    scrollList.ScrollBarImageColor3 = __Theme.Border
    scrollList.ScrollBarImageTransparency = 0.35
    scrollList.CanvasSize = UDim2.new(0, 0, 0, 0)
    scrollList.AutomaticCanvasSize = Enum.AutomaticSize.None
    scrollList.ScrollingDirection = Enum.ScrollingDirection.Y
    scrollList.ElasticBehavior = Enum.ElasticBehavior.Always
    scrollList.Parent = RightPanel

    local listLayout = Instance.new("UIListLayout")
    listLayout.Padding = UDim.new(0, 5)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.Parent = scrollList

    local function updateCanvas()
        pcall(function()
            scrollList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 8)
        end)
    end
    listLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(updateCanvas)

    local SupportedScripts = {}
    local scriptRows = {}
    local skeletonCards = {}

    local function clearSkeletons()
        for _, sk in ipairs(skeletonCards) do
            pcall(function() sk:Destroy() end)
        end
        skeletonCards = {}
    end

    local function renderSkeletonLoading()
        clearSkeletons()
        countBadge.Text = "SYNCING..."
        countBadge.TextColor3 = __Theme.AccentGlow

        for i = 1, 4 do
            local sk = Instance.new("Frame")
            sk.Name = "Skeleton_" .. i
            sk.Size = UDim2.new(1, -6, 0, 36)
            sk.BackgroundColor3 = __Theme.Surface2
            sk.BackgroundTransparency = 0.5
            sk.Parent = scrollList
            corner(sk, 7)
            stroke(sk, __Theme.Border, 0.25)

            local dot = Instance.new("Frame")
            dot.Size = UDim2.fromOffset(6, 6)
            dot.Position = UDim2.new(0, 8, 0.5, -3)
            dot.BackgroundColor3 = __Theme.SurfaceDeep
            dot.BorderSizePixel = 0
            dot.Parent = sk
            corner(dot, 3)

            local titleBar = Instance.new("Frame")
            titleBar.Size = UDim2.new(0.45, 0, 0, 10)
            titleBar.Position = UDim2.new(0, 20, 0, 7)
            titleBar.BackgroundColor3 = __Theme.SurfaceDeep
            titleBar.BorderSizePixel = 0
            titleBar.Parent = sk
            corner(titleBar, 4)

            local subBar = Instance.new("Frame")
            subBar.Size = UDim2.new(0.65, 0, 0, 8)
            subBar.Position = UDim2.new(0, 20, 0, 20)
            subBar.BackgroundColor3 = __Theme.SurfaceDeep
            subBar.BorderSizePixel = 0
            subBar.Parent = sk
            corner(subBar, 4)

            local anim = TweenService:Create(sk, TweenInfo.new(0.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                BackgroundTransparency = 0.8
            })
            anim:Play()

            table.insert(skeletonCards, sk)
        end
        updateCanvas()
    end

    local function renderScripts(query)
        clearSkeletons()
        for _, r in ipairs(scriptRows) do pcall(function() r:Destroy() end) end
        scriptRows = {}

        local q = string.lower(query or "")
        for _, scr in ipairs(SupportedScripts) do
            local match = (q == "")
                or string.find(string.lower(scr.Name), q, 1, true)
                or string.find(string.lower(scr.Desc or ""), q, 1, true)

            if match then
                local isCurrent = (scr == targetScript or (targetScript and scr.Id and scr.Id == targetScript.Id))

                local card = Instance.new("Frame")
                card.Name = "Script_" .. scr.Name
                card.Size = UDim2.new(1, -6, 0, 36)
                card.BackgroundColor3 = __Theme.Surface2
                card.BackgroundTransparency = isCurrent and 0.25 or 0.5
                card.Parent = scrollList
                corner(card, 7)
                stroke(card, isCurrent and __Theme.Accent or __Theme.Border, isCurrent and 0.25 or 0.45)

                local dot = Instance.new("Frame")
                dot.Size = UDim2.fromOffset(6, 6)
                dot.Position = UDim2.new(0, 8, 0.5, -3)
                dot.BackgroundColor3 = isCurrent and __Theme.Success or __Theme.Accent
                dot.BorderSizePixel = 0
                dot.Parent = card
                corner(dot, 3)

                local sName = text(card, scr.Name, 11, isCurrent and __Theme.Accent or __Theme.Text)
                sName.Position = UDim2.new(0, 20, 0, 4)
                sName.Size = UDim2.new(1, -68, 0, 15)
                sName.Font = Enum.Font.GothamBold
                sName.TextTruncate = Enum.TextTruncate.AtEnd

                local sDesc = text(card, scr.Desc or "Database Enclave Package", 9, __Theme.SubText)
                sDesc.Position = UDim2.new(0, 20, 0, 19)
                sDesc.Size = UDim2.new(1, -68, 0, 13)
                sDesc.Font = Enum.Font.Gotham
                sDesc.TextTruncate = Enum.TextTruncate.AtEnd

                local tagPill = Instance.new("Frame")
                tagPill.Size = UDim2.fromOffset(44, 16)
                tagPill.Position = UDim2.new(1, -50, 0.5, -8)
                tagPill.BackgroundColor3 = isCurrent and Color3.fromRGB(0, 200, 115) or __Theme.Surface
                tagPill.BackgroundTransparency = isCurrent and 0.82 or 0.4
                tagPill.Parent = card
                corner(tagPill, 4)
                stroke(tagPill, isCurrent and Color3.fromRGB(0, 200, 115) or __Theme.Border, 0.4)

                local tagTxt = text(tagPill, isCurrent and "TARGET" or "ONLINE", 7.5, isCurrent and __Theme.Success or __Theme.SubText)
                tagTxt.Size = UDim2.fromScale(1, 1)
                tagTxt.TextXAlignment = Enum.TextXAlignment.Center
                tagTxt.Font = Enum.Font.GothamBold

                table.insert(scriptRows, card)
            end
        end
        updateCanvas()
    end

    local function fetchDatabaseCatalog()
        renderSkeletonLoading()

        local rawJson = nil
        pcall(function()
            local httpReq = (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request) or request or http_request
            if httpReq then
                local r = httpReq({
                    Url = __SERVER_URL .. "/v1/public-scripts",
                    Method = "GET",
                    Headers = { ["Content-Type"] = "application/json" }
                })
                if r and (r.StatusCode == 200 or r.Status == 200) then
                    rawJson = r.Body or r.body
                end
            end
        end)
        if not rawJson then
            pcall(function()
                rawJson = game:HttpGet(__SERVER_URL .. "/v1/public-scripts")
            end)
        end

        local list = {}
        if rawJson and rawJson ~= "" then
            local decodeOk, res = pcall(function()
                return HttpService:JSONDecode(rawJson)
            end)
            if decodeOk and res and res.success and res.scripts then
                for _, s in ipairs(res.scripts) do
                    table.insert(list, {
                        Id = s.id,
                        Name = s.name,
                        Desc = "Verified Package • Database Synced",
                        PlaceIds = tostring(s.placeIds or ""),
                        FreeForAll = s.freeForAll,
                        Status = "ONLINE"
                    })
                end
            end
        end

        if #list > 0 then
            SupportedScripts = list
            countBadge.Text = tostring(#SupportedScripts) .. " READY"
            countBadge.TextColor3 = __Theme.AccentGlow

            -- Auto-match game PlaceId
            local matched = nil
            for _, s in ipairs(SupportedScripts) do
                if string.find(s.PlaceIds, tostring(currentPlaceId)) then
                    matched = s
                    break
                end
            end
            if matched then
                targetScript = matched
                if __SCRIPT_ID == "auto" or __SCRIPT_ID == "" then
                    __SCRIPT_ID = matched.Id
                end
            else
                targetScript = SupportedScripts[1]
            end
        else
            SupportedScripts = {
                {
                    Id = __SCRIPT_ID or "universal",
                    Name = detectedGameTitle,
                    Desc = "Active Experience • PlaceId: " .. tostring(currentPlaceId),
                    PlaceIds = tostring(currentPlaceId),
                    Status = "ONLINE"
                }
            }
            countBadge.Text = "1 ACTIVE"
            countBadge.TextColor3 = __Theme.Success
            targetScript = SupportedScripts[1]
        end

        if targetTag then
            targetTag.Text = "TARGET: " .. string.upper(targetScript.Name)
        end
        renderScripts(searchBox.Text)
    end

    task.spawn(fetchDatabaseCatalog)

    searchBox:GetPropertyChangedSignal("Text"):Connect(function()
        renderScripts(searchBox.Text)
    end)

    -- ScriptBlox Attribution Footer
    local scriptbloxCard = Instance.new("TextButton")
    scriptbloxCard.Name = "ScriptbloxAttribution"
    scriptbloxCard.Size = UDim2.new(1, 0, 0, 18)
    scriptbloxCard.Position = UDim2.new(0, 0, 1, -18)
    scriptbloxCard.BackgroundTransparency = 1
    scriptbloxCard.AutoButtonColor = false
    scriptbloxCard.Text = ""
    scriptbloxCard.Parent = RightPanel

    local sbCenterContainer = Instance.new("Frame")
    sbCenterContainer.Size = UDim2.fromScale(1, 1)
    sbCenterContainer.BackgroundTransparency = 1
    sbCenterContainer.Parent = scriptbloxCard

    local sbLayout = Instance.new("UIListLayout")
    sbLayout.FillDirection = Enum.FillDirection.Horizontal
    sbLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    sbLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    sbLayout.Padding = UDim.new(0, 5)
    sbLayout.Parent = sbCenterContainer

    local sbIcon = Instance.new("ImageLabel")
    sbIcon.Size = UDim2.fromOffset(10, 10)
    sbIcon.BackgroundTransparency = 1
    sbIcon.Image = "rbxassetid://10709798433"
    sbIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
    sbIcon.ScaleType = Enum.ScaleType.Fit
    sbIcon.Parent = sbCenterContainer

    local sbTitle = Instance.new("TextLabel")
    sbTitle.BackgroundTransparency = 1
    sbTitle.Text = "Supported by ScriptBlox"
    sbTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    sbTitle.TextSize = 9
    sbTitle.Font = Enum.Font.GothamMedium
    sbTitle.AutomaticSize = Enum.AutomaticSize.XY
    sbTitle.Parent = sbCenterContainer

    scriptbloxCard.MouseEnter:Connect(function()
        tween(sbTitle, 0.15, { TextTransparency = 0.35 })
        tween(sbIcon, 0.15, { ImageTransparency = 0.35 })
    end)
    scriptbloxCard.MouseLeave:Connect(function()
        tween(sbTitle, 0.15, { TextTransparency = 0 })
        tween(sbIcon, 0.15, { ImageTransparency = 0 })
    end)
    scriptbloxCard.MouseButton1Click:Connect(function()
        pcall(function()
            if setclipboard then
                setclipboard("https://scriptblox.com")
            elseif toclipboard then
                toclipboard("https://scriptblox.com")
            end
        end)
        sbTitle.Text = "Link Copied"
        task.delay(1.5, function()
            sbTitle.Text = "Supported by ScriptBlox"
        end)
    end)

    ScreenGui.Parent = guiParent
end

-- ============================================================
-- VM HARDENING: Compatibility & Safe Environment Setup
-- Ensures seamless execution across Solara, Delta, Wave, Hydrogen,
-- Fluxus, Arceus, Codex, Celery, and all Roblox executors.
-- ============================================================

-- Capture originals BEFORE any hook could be placed
local __raw_type        = type
local __raw_pcall       = pcall
local __raw_tostring    = tostring
local __raw_pairs       = pairs
local __raw_ipairs      = ipairs
local __raw_select      = select
local __raw_unpack      = table.unpack or unpack

-- 1. Environment & Game Sanity Check (Executor Quality & UNC Gate)
local function __verifyEnvironment()
    if not game or not game.GetService then
        return false, "Invalid Roblox game environment"
    end

    -- Identify executor name
    local rawName = ""
    pcall(function()
        if identifyexecutor then
            rawName = tostring(identifyexecutor())
        elseif getexecutorname then
            rawName = tostring(getexecutorname())
        end
    end)
    local lowerName = string.lower(rawName)

    -- Block known low-UNC / broken capability executors
    local blockedExecutors = { "xeno", "solara", "jjsploit" }
    for _, blocked in ipairs(blockedExecutors) do
        if string.find(lowerName, blocked) then
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "❌ Unsupported Executor",
                    Text = rawName .. " has low UNC & broken Luau capability. Please use Delta, Codex, Wave, or Macsploit.",
                    Duration = 10
                })
            end)
            return false, "Unsupported executor: " .. rawName .. " (low UNC / lacking core capability)"
        end
    end

    -- Minimum UNC Capability Check: Must have loadstring, hook/request, and standard library
    local hasLoadstring = (loadstring ~= nil) or (getgenv and getgenv().loadstring ~= nil)
    if not hasLoadstring then
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "❌ Missing Capability",
                Text = "Your executor lacks loadstring capability.",
                Duration = 8
            })
        end)
        return false, "Executor missing loadstring capability"
    end

    return true
end

-- 2. Memory dump mitigation: zero out sensitive string locals
-- Call after key/token/payload have been consumed
local function __wipeLocals(tbl)
    if __raw_type(tbl) ~= "table" then return end
    for k in __raw_pairs(tbl) do
        tbl[k] = nil
    end
end

-- 2. Reliable HWID & Fingerprint Collector
local function __getHwid()
    local hwid = nil
    pcall(function()
        if gethwid then
            hwid = gethwid()
        elseif syn and syn.crypt and syn.crypt.custom_hash then
            local cid = game:GetService("RbxAnalyticsService"):GetClientId()
            hwid = syn.crypt.custom_hash("sha256", cid)
        elseif getexecutorname then
            local cid = game:GetService("RbxAnalyticsService"):GetClientId()
            hwid = cid .. "_" .. tostring(getexecutorname())
        else
            hwid = game:GetService("RbxAnalyticsService"):GetClientId()
        end
    end)
    if not hwid or hwid == "" then
        pcall(function()
            local lp = game:GetService("Players").LocalPlayer
            if lp and lp.UserId then
                hwid = "CLIENT_" .. tostring(lp.UserId)
            end
        end)
    end
    return hwid or "CLIENT_ANONYMOUS"
end

-- 3. Executor Info
local function __getExecutor()
    local name = "Unknown"
    pcall(function()
        if identifyexecutor then
            name = identifyexecutor()
        elseif getexecutorname then
            name = getexecutorname()
        end
    end)
    return name
end

-- ============================================================
-- AUTO-REJOIN & SERVER-HOP PERSISTENCE (Must be declared before __executeHandshake)
-- ============================================================
local function __setupPersistence()
    -- Disabled by user request: do NOT queue re-execution on teleport or hook disconnects
end

-- Helper to safely extract HTTP response body across all executor implementations
local function __extractBody(res)
    if type(res) == "table" then
        return res.Body or res.body or res.Response or res.response or res.data or ""
    elseif type(res) == "string" then
        return res
    end
    return ""
end

-- 4. Handshake Function
local function __executeHandshake(keyToTry, isCachedParam, cacheVersionParam, isSilentParam)
    local isSilent = (isSilentParam == true)
    local loaderOverlay = nil
    if not isSilent then
        pcall(function()
            loaderOverlay = __createLoadingOverlay("Verifying Key...")
            if loaderOverlay and loaderOverlay.Update then
                loaderOverlay:Update(25, "Verifying Key...")
            end
        end)
    end

    local isCached = false
    if isCachedParam ~= nil then
        isCached = (isCachedParam == true)
    else
        isCached = __KEY_IS_CACHED
    end
    local cacheVer = cacheVersionParam or __CACHE_VERSION or 1

    local hwid = __getHwid()
    local executor = __getExecutor()

    local player = game:GetService("Players").LocalPlayer
    local username = player and player.Name or "Unknown"
    local userId = player and player.UserId or 0
    local accountAge = player and player.AccountAge or 0
    local placeId = game.PlaceId or 0
    local jobId = game.JobId or "N/A"
    local gameId = game.GameId or 0

    local httpService = game:GetService("HttpService")
    local requestFn = (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request) or (crypt and crypt.request) or request or http_request

    local handshakePayload = httpService:JSONEncode({
        projectId = __PROJECT_ID,
        scriptId = __SCRIPT_ID,
        key = keyToTry or "",
        hwid = hwid,
        keySource = isCached and "cache" or "manual",
        cacheVersion = cacheVer,
        executor = executor,
        username = username,
        userId = userId,
        accountAge = accountAge,
        placeId = placeId,
        jobId = jobId,
        gameId = gameId,
        timestamp = os.time()
    })

    local handshakeRes = nil
    if requestFn then
        local reqOk, reqResult = pcall(requestFn, {
            Url = __SERVER_URL .. "/api/v1/validate",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["User-Agent"] = "LiyHub-Bootstrapper/2.0"
            },
            Body = handshakePayload
        })
        if reqOk and reqResult then
            handshakeRes = __extractBody(reqResult)
        end
    end

    -- Universal Fallback via /v1/handshake or HttpGet if requestFn failed
    if not handshakeRes or handshakeRes == "" then
        pcall(function()
            local qs = string.format(
                "%s/api/v1/validate?projectId=%s&scriptId=%s&key=%s&hwid=%s&keySource=%s&cacheVersion=%s&executor=%s&username=%s&userId=%s&accountAge=%s&placeId=%s&jobId=%s&gameId=%s&timestamp=%s",
                __SERVER_URL,
                httpService:UrlEncode(tostring(__PROJECT_ID)),
                httpService:UrlEncode(tostring(__SCRIPT_ID)),
                httpService:UrlEncode(tostring(keyToTry or "")),
                httpService:UrlEncode(tostring(hwid or "")),
                httpService:UrlEncode(isCached and "cache" or "manual"),
                tostring(cacheVer),
                httpService:UrlEncode(tostring(executor or "")),
                httpService:UrlEncode(tostring(username or "")),
                tostring(userId or 0),
                tostring(accountAge or 0),
                tostring(placeId or 0),
                httpService:UrlEncode(tostring(jobId or "")),
                tostring(gameId or 0),
                tostring(os.time())
            )
            handshakeRes = game:HttpGet(qs)
        end)
    end

    local data = nil
    local jsonOk = pcall(function()
        data = httpService:JSONDecode(handshakeRes)
    end)

    if not jsonOk or not data then
        if loaderOverlay then pcall(function() loaderOverlay:Destroy() end) end
        return false, "Server connection error (Handshake failed)", "SERVER_DOWN"
    end

    if not data.success or not data.authorized then
        if loaderOverlay then pcall(function() loaderOverlay:Destroy() end) end

        local code = tostring(data.code or "")
        local isTransient = (code == "DEPENDENCY_UNAVAILABLE" or code == "RATE_LIMITED")

        -- Clear stale cache only for permanently invalid / blacklisted keys.
        -- Always delete liyhub_key.txt and reset __KEY on handshake failure
        pcall(function()
            if delfile and isfile and isfile("liyhub_key.txt") then
                delfile("liyhub_key.txt")
            end
        end)
        __KEY = ""
        __KEY_IS_CACHED = false

        local errTitle = "❌ Verification Failed"
        if code == "SCRIPT_NOT_FOUND" then
            errTitle = "❌ Game Not Supported"
        elseif code == "DISCORD_NOT_LINKED" then
            errTitle = "❌ Discord Redeem Required"
        elseif code == "CACHE_REENTRY_REQUIRED" then
            errTitle = "🔑 Key Re-entry Required"
        elseif code == "LICENSE_EXPIRED" or data.expired == true then
            errTitle = "❌ License Expired"
        elseif code == "HWID_MISMATCH" then
            errTitle = "❌ HWID Mismatch"
        elseif code == "LICENSE_BLACKLISTED" then
            errTitle = "❌ License Blacklisted"
        elseif code == "SCRIPT_NOT_ALLOWED" then
            errTitle = "❌ Access Denied"
        elseif code == "RATE_LIMITED" then
            errTitle = "⏳ Rate Limited"
        end

        if not isSilent or code == "SCRIPT_NOT_FOUND" then
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = errTitle,
                    Text = data.message or "Invalid key or access denied.",
                    Duration = 8
                })
            end)
        end

        return false, data.message or "Access denied", code
    end

    if loaderOverlay then loaderOverlay:Update(60, "Downloading Payload...") end

    -- Cache disabled by user request: delete any existing key file to avoid auto-execution
    pcall(function()
        if delfile and isfile and isfile("liyhub_key.txt") then
            delfile("liyhub_key.txt")
        end
    end)

    -- Download & execute payload via canonical /api/v1/fetch
    local fetchPayload = httpService:JSONEncode({
        sessionToken = data.sessionToken
    })

    local payloadRes = nil
    if requestFn then
        local reqOk, reqResult = pcall(requestFn, {
            Url = __SERVER_URL .. "/api/v1/fetch",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["User-Agent"] = "LiyHub-Bootstrapper/2.0"
            },
            Body = fetchPayload
        })
        if reqOk and reqResult then
            payloadRes = __extractBody(reqResult)
        end
    end

    -- Universal Fallback via HttpGet
    if not payloadRes or payloadRes == "" then
        pcall(function()
            local qs = string.format(
                "%s/api/v1/fetch?sessionToken=%s",
                __SERVER_URL,
                httpService:UrlEncode(tostring(data.sessionToken or ""))
            )
            payloadRes = game:HttpGet(qs)
        end)
    end

    local payloadData = nil
    pcall(function()
        payloadData = httpService:JSONDecode(payloadRes)
    end)

    if not payloadData or not payloadData.success or not payloadData.payload then
        if loaderOverlay then pcall(function() loaderOverlay:Destroy() end) end
        local errDetail = (payloadData and payloadData.message) or ("Payload fetch error: " .. tostring(payloadRes):sub(1, 100))
        return false, errDetail, "FETCH_ERROR"
    end

    if loaderOverlay then
        pcall(function() loaderOverlay:Update(85, "Compiling Script...") end)
    end

    -- Extract payload string and metadata BEFORE wiping structures
    local payloadStr = payloadData.payload
    local scriptTitle = tostring(data.scriptName or "Script")
    local tierName = tostring(data.tier or "Freemium")
    local isPrem = data.isPremium
    local isSingleUse = data.isSingleUse
    local expiresTimestamp = tonumber(data.expiresTimestamp or 0)
    local remainingSeconds = tonumber(data.remainingSeconds or 0)
    local expiresFormatted = tostring(data.expiresFormatted or "")
    local validatedKey = tostring(keyToTry or "")
    local sessionNumber = tonumber(data.sessionNumber or (payloadData and payloadData.sessionNumber) or 0)

    -- Zero sensitive structures
    __wipeLocals(data)
    __wipeLocals(payloadData)
    payloadRes = nil
    handshakeRes = nil
    handshakePayload = nil
    fetchPayload = nil
    keyToTry = nil

    local loadstringFn = loadstring or (getgenv and getgenv().loadstring) or (syn and syn.loadstring)
    if not loadstringFn then
        warn("[LiyHub] Executor missing loadstring capability")
        return false, "Executor missing loadstring capability"
    end

    local fn, loadErr = loadstringFn(payloadStr)
    payloadStr = nil
    if not fn then
        warn("[LiyHub Parse Error] " .. tostring(loadErr))
        pcall(function()
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "❌ Script Parse Error",
                Text = tostring(loadErr):sub(1, 80),
                Duration = 8
            })
        end)
        return false, "Parse error: " .. tostring(loadErr)
    end

    -- Inject Expiry details into getgenv for UI automatic countdown
    pcall(function()
        if getgenv then
            local g = getgenv()
            if isreadonly and isreadonly(g) and setreadonly then
                pcall(setreadonly, g, false)
            end
            pcall(function() g.LiyHubKey = validatedKey end)
            pcall(function() g.LiyHubTier = tierName end)
            pcall(function() g.LiyHubIsPremium = isPrem end)
            if expiresTimestamp > 0 then
                pcall(function() g.LiyHubExpiryTimestamp = expiresTimestamp end)
            end
            if remainingSeconds > 0 then
                pcall(function() g.LiyHubRemainingSeconds = remainingSeconds end)
            end
            if expiresFormatted ~= "" then
                pcall(function() g.LiyHubRemainingTime = expiresFormatted end)
            end
        end
        pcall(function()
            if _G then
                _G.LiyHubKey = validatedKey
                _G.LiyHubTier = tierName
                _G.LiyHubIsPremium = isPrem
            end
            if shared then
                shared.LiyHubKey = validatedKey
                shared.LiyHubTier = tierName
                shared.LiyHubIsPremium = isPrem
            end
        end)
    end)

    -- Ensure getgenv contains standard references safely
    pcall(function()
        if getgenv then
            local g = getgenv()
            if g.game == nil then g.game = game end
            if g.workspace == nil then g.workspace = workspace end
        end
    end)

    -- Launch Real-Time Watchdog & Automatic Disconnect
    if (sessionNumber and sessionNumber > 0) or (validatedKey ~= "") then
        local getKeyUrl = __SERVER_URL .. "/getkey?project=" .. __PROJECT_ID .. "&hwid=" .. tostring(__getHwid())
        local hbUrl = __SERVER_URL .. "/api/v1/heartbeat"
        local savedHwid = tostring(__getHwid())
        local effectiveKey = (validatedKey ~= "" and validatedKey) or "FREE-FOR-ALL"

        task.spawn(function()
            local disconnected = false
            local function doDisconnect(msg)
                if disconnected then return end
                disconnected = true

                pcall(function()
                    if getgenv and getgenv()._LIYHUB_CLEANUP then
                        getgenv()._LIYHUB_CLEANUP()
                    end

                    pcall(function()
                        if delfile and isfile then
                            if isfile("liyhub_key.txt") then delfile("liyhub_key.txt") end
                        end
                    end)

                    pcall(function()
                        local parent = __getSafeGuiParent()
                        if parent and parent:FindFirstChild("LiyHubKeySystemGui") then
                            parent.LiyHubKeySystemGui:Destroy()
                        end
                        local CoreGui = game:GetService("CoreGui")
                        if CoreGui and CoreGui:FindFirstChild("LiyHubKeySystemGui") then
                            CoreGui.LiyHubKeySystemGui:Destroy()
                        end
                    end)

                    local lp = game:GetService("Players").LocalPlayer
                    if lp then
                        lp:Kick("[LiyHub DRM] " .. tostring(msg or "Key expired. Disconnected."))
                    end
                end)
            end

            -- 1. Precision 1-second local countdown check (immune to device clock-drift)
            if remainingSeconds > 0 and validatedKey ~= "" and validatedKey ~= "FREE-FOR-ALL" then
                task.spawn(function()
                    local secLeft = remainingSeconds
                    while task.wait(1) do
                        if disconnected then break end
                        secLeft = secLeft - 1
                        if secLeft <= 0 then
                            doDisconnect("Your license key has expired. Session disconnected automatically. Get a new key at: " .. getKeyUrl)
                            break
                        end
                    end
                end)
            end

            -- 2. Periodic server heartbeat validation (every 30s for all active sessions)
            task.spawn(function()
                local reqFn = (syn and syn.request) or (http and http.request) or (fluxus and fluxus.request) or (crypt and crypt.request) or request or http_request
                local httpSvc = game:GetService("HttpService")
                local consecutiveHbFails = 0

                while task.wait(30) do
                    if disconnected then break end
                    local ok, hbRes = pcall(function()
                        if reqFn then
                            local body = httpSvc:JSONEncode({
                                key = effectiveKey,
                                hwid = savedHwid,
                                sessionNumber = sessionNumber
                            })
                            return reqFn({
                                Url = hbUrl,
                                Method = "POST",
                                Headers = { ["Content-Type"] = "application/json", ["User-Agent"] = "LiyHub-ClientLoader/2.0" },
                                Body = body
                            })
                        end
                        return nil
                    end)

                    if ok and hbRes then
                        local code = hbRes.StatusCode or hbRes.status_code
                        if code == 200 then
                            consecutiveHbFails = 0
                            if hbRes.Body then
                                local jOk, jData = pcall(function() return httpSvc:JSONDecode(hbRes.Body) end)
                                if jOk and jData and (jData.expired == true or jData.success == false) then
                                    doDisconnect(jData.message or "Your license has expired or was revoked. Session disconnected automatically.")
                                    break
                                end
                            end
                        elseif code == 401 or code == 403 then
                            consecutiveHbFails = consecutiveHbFails + 1
                            local reason = "Your license has expired or was revoked. Session disconnected automatically."
                            if hbRes.Body then
                                local jOk, jData = pcall(function() return httpSvc:JSONDecode(hbRes.Body) end)
                                if jOk and jData and jData.message then reason = jData.message end
                            end
                            if consecutiveHbFails >= 3 then
                                doDisconnect(reason)
                                break
                            end
                        else
                            consecutiveHbFails = consecutiveHbFails + 1
                            if consecutiveHbFails >= 5 then
                                doDisconnect("Authentication server connection lost during AFK.")
                                break
                            end
                        end
                    else
                        consecutiveHbFails = consecutiveHbFails + 1
                        if consecutiveHbFails >= 5 then
                            doDisconnect("Authentication server connection timed out.")
                            break
                        end
                    end
                end
            end)
        end)
    end

    -- Run script safely in executor background with deferred frame synchronization for LiyhubUI
    local spawnFn = (task and task.defer) or (task and task.spawn) or spawn
    spawnFn(function()
        local totalElapsed = 0
        if loaderOverlay then
            pcall(function()
                if loaderOverlay.GetElapsed then
                    totalElapsed = loaderOverlay:GetElapsed()
                end
                if loaderOverlay.Update then
                    loaderOverlay:Update(100, "Ready!")
                end
                task.delay(0.4, function()
                    pcall(function() loaderOverlay:Destroy() end)
                end)
            end)
        end

        local timeText = string.format("%.2fs", totalElapsed)
        print("[LiyHub] Launching " .. scriptTitle .. " (loaded in " .. timeText .. ")...")

        -- Show Tier & Game badge notification with exact elapsed load duration
        pcall(function()
            local title = isPrem and ("👑 LiyHub • " .. scriptTitle .. " [VIP]") or ("⚡ LiyHub • " .. scriptTitle)
            local desc = string.format("Tier: %s • Loaded in %s!", tierName, timeText)
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = title,
                Text = desc,
                Duration = 6
            })
        end)

        local ok, runErr = pcall(function()
            local res = fn()
            if typeof(res) == "function" or type(res) == "function" then
                return res()
            end
            return res
        end)
        fn = nil

        if not ok then
            warn("[LiyHub Runtime Error] " .. tostring(runErr))
            pcall(function()
                game:GetService("StarterGui"):SetCore("SendNotification", {
                    Title = "❌ Script Runtime Error",
                    Text = tostring(runErr):sub(1, 80),
                    Duration = 8
                })
            end)
        else
            print("[LiyHub] " .. scriptTitle .. " executed successfully!")
        end
    end)

    pcall(__setupPersistence)
    return true
end

-- Main Init
local function __init()
    pcall(function()
        if not game:IsLoaded() then
            game.Loaded:Wait()
        end
    end)

    local envOk, envErr = __verifyEnvironment()
    if not envOk then
        warn("[LiyHub] " .. tostring(envErr))
        return
    end

    local hwid = __getHwid()
    local getKeyUrl = __SERVER_URL .. "/getkey?project=" .. __PROJECT_ID .. "&hwid=" .. tostring(hwid)

    -- 1. If explicit valid key is supplied (via environment / getgenv), validate and execute
    if __isLicenseKeyCandidate(__KEY) then
        local success, errMsg, errCode = __executeHandshake(__KEY, false, 1, false)
        if success then
            return
        end

        warn("[LiyHub] Key validation failed (" .. tostring(errMsg) .. "). Prompting Key GUI...")
    end

    -- 2. If no valid key is present or failed, open Key GUI directly without silent auto-load
    __showKeyPromptGui(getKeyUrl, function(enteredKey)
        return __executeHandshake(enteredKey, false, 1, false)
    end)
end

return __init()
