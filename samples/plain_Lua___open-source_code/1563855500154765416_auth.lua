-- ============================================
-- Toolbox Hub — Authenticated Session
-- Licensed to p04j
-- Panel: premium
-- Premium role: True
-- ============================================
_G.TB_LICENSE = "TB-EC5A3AF3"
_G.TB_DISCORD_USERNAME = "p04j"
_G.TB_ROBLOX_USERNAME = "stephaniekobza94"
_G.TB_BOUND_ROBLOX_ID = "2835865"
_G.TB_PANEL_TYPE = "premium"
_G.TB_HAS_PREMIUM_ROLE = true

-- ============================================
-- Account binding enforcement
-- ============================================
do
    local __tb_ok, __tb_lp = pcall(function()
        return game:GetService("Players").LocalPlayer
    end)
    if __tb_ok and __tb_lp then
        local __tb_uid = tostring(__tb_lp.UserId)
        local __tb_bound = tostring(_G.TB_BOUND_ROBLOX_ID or "")
        if _G.TB_PANEL_TYPE == "premium" then
            if __tb_bound == "" then
                __tb_lp:Kick("[Toolbox] Your account is not bound. Re-login on the Premium Panel to bind it.")
                return
            end
            if __tb_bound ~= __tb_uid then
                __tb_lp:Kick("[Toolbox] This script is bound to a different Roblox account. Reset HWID on the Premium Panel to re-bind.")
                return
            end
        else
            if __tb_bound ~= "" and __tb_bound ~= __tb_uid then
                __tb_lp:Kick("[Toolbox] This script is bound to a different Roblox account. Reset HWID on the panel to re-bind.")
                return
            end
        end
    end
end


local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local CoreGui = game:GetService("CoreGui")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer

--========================================================--
-- LICENSE SETUP (100% KEYLESS)
--========================================================--

local LICENSE_API = "https://ohtoolboxhub.up.railway.app/api/license/verify"
local TRACK_ENDPOINT = "https://ohtoolboxhub.up.railway.app/track_execution"

local MY_LICENSE = ""
local BOUND_ROBLOX_ID = ""
local PANEL_TYPE = "buyer"
local HAS_PREMIUM_ROLE = false

pcall(function()
    if type(_G.TB_LICENSE) == "string" and _G.TB_LICENSE ~= "" then
        MY_LICENSE = _G.TB_LICENSE
    end
    if type(_G.TB_BOUND_ROBLOX_ID) == "string" then
        BOUND_ROBLOX_ID = _G.TB_BOUND_ROBLOX_ID
    end
    if type(_G.TB_PANEL_TYPE) == "string" then
        PANEL_TYPE = _G.TB_PANEL_TYPE
    end
    local v = _G.TB_HAS_PREMIUM_ROLE
    if type(v) == "boolean" then
        HAS_PREMIUM_ROLE = v
    elseif type(v) == "string" then
        HAS_PREMIUM_ROLE = (v == "true")
    end
end)

if MY_LICENSE == "" then
    pcall(function()
        if typeof(isfile) == "function" and isfile("Toolbox_license.txt")
            and typeof(readfile) == "function" then
            local content = tostring(readfile("Toolbox_license.txt") or "")
            content = content:gsub("^%s+", ""):gsub("%s+$", "")
            if content ~= "" then MY_LICENSE = content end
        end
    end)
end

local LICENSE_INFO = nil
local LICENSE_STATE = "none"

local function verifyLicense()
    if MY_LICENSE == "" then return "none" end
    local requestFn = request or http_request
        or (syn and syn.request) or (http and http.request)
    if not requestFn then return "error" end
    local url = LICENSE_API .. "?license=" .. MY_LICENSE
    local ok, res = pcall(function()
        return requestFn({ Url = url, Method = "GET" })
    end)
    if not ok or not res then return "error" end
    local body = res.Body or res.body
    if not body then return "error" end
    local decodeOk, data = pcall(function()
        return HttpService:JSONDecode(body)
    end)
    if not decodeOk or type(data) ~= "table" then return "error" end
    if data.valid == true then
        LICENSE_INFO = data
        if (BOUND_ROBLOX_ID == "" or BOUND_ROBLOX_ID == "nil") and data.roblox_id then
            BOUND_ROBLOX_ID = tostring(data.roblox_id)
        end
        if data.panel_type then
            PANEL_TYPE = tostring(data.panel_type)
        end
        return "valid"
    end
    return "invalid"
end

if MY_LICENSE ~= "" then
    LICENSE_STATE = verifyLicense()
    if LICENSE_STATE == "invalid" then
        LocalPlayer:Kick("Invalid license.\n\nThis account is not authorized for Toolbox Hub Premium.")
        return
    end
end

local IS_LICENSED = (LICENSE_STATE == "valid")

if IS_LICENSED and BOUND_ROBLOX_ID ~= "" and BOUND_ROBLOX_ID ~= "nil" then
    if tostring(LocalPlayer.UserId) ~= tostring(BOUND_ROBLOX_ID) then
        LocalPlayer:Kick(
            "This script is licensed to a different Roblox account.\n\n" ..
            "Ask the owner to re-license it to your account."
        )
        return
    end
end

print("[Toolbox Loader] License:", MY_LICENSE ~= "" and MY_LICENSE or "(none)",
    "| State:", LICENSE_STATE, "| Panel:", PANEL_TYPE,
    "| Bound ID:", BOUND_ROBLOX_ID ~= "" and BOUND_ROBLOX_ID or "(none)",
    "| Premium role:", HAS_PREMIUM_ROLE,
    "| KEY SYSTEM: NONE — keyless loader")

local function addLicenseToUrl(url)
    if not MY_LICENSE or MY_LICENSE == "" then return url end
    local sep = string.find(url, "?", 1, true) and "&" or "?"
    return url .. sep .. "licence=" .. MY_LICENSE
end

local function injectLicenseIntoScript(script)
    if not MY_LICENSE or MY_LICENSE == "" then return script end
    if type(script) ~= "string" then return script end
    return script:gsub(
        'game:HttpGet%s*%(%s*"([^"]+)"',
        function(url)
            return 'game:HttpGet("' .. addLicenseToUrl(url) .. '"'
        end
    )
end

--========================================================--
-- HTTP HELPERS
--========================================================--

local function getRequestFn()
    return request or http_request
        or (syn and syn.request) or (http and http.request)
end

local function getPlaceName()
    local name = "Unknown"
    pcall(function()
        local info = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
        if info and info.Name then name = info.Name end
    end)
    return name
end

local function getExecutorInfo()
    local exec_name = "Unknown"
    local exec_ver = ""
    pcall(function()
        if identifyexecutor then
            local n, v = identifyexecutor()
            if n then exec_name = tostring(n) end
            if v then exec_ver = tostring(v) end
        end
    end)
    return exec_name, exec_ver
end

--========================================================--
-- STARTUP HEARTBEAT
--========================================================--

task.spawn(function()
    local requestFn = getRequestFn()
    if not requestFn then return end
    local exec_name, exec_ver = getExecutorInfo()
    local body = {
        roblox_id = tostring(LocalPlayer.UserId),
        roblox_username = tostring(LocalPlayer.Name),
        display_name = tostring(LocalPlayer.DisplayName),
        place_id = tostring(game.PlaceId),
        place_name = getPlaceName(),
        executor = exec_name,
        executor_version = exec_ver,
    }
    pcall(function()
        requestFn({
            Url = TRACK_ENDPOINT,
            Method = "POST",
            Body = HttpService:JSONEncode(body),
            Headers = { ["Content-Type"] = "application/json" },
        })
    end)
end)

--========================================================--
-- LOG SCRIPT EXECUTION
--========================================================--

local function logScriptExecution(scriptName, isPremium)
    local requestFn = getRequestFn()
    if not requestFn then return end
    local exec_name, exec_ver = getExecutorInfo()
    local body = {
        roblox_id = tostring(LocalPlayer.UserId),
        roblox_username = tostring(LocalPlayer.Name),
        display_name = tostring(LocalPlayer.DisplayName),
        place_id = tostring(game.PlaceId),
        place_name = getPlaceName(),
        executor = exec_name,
        executor_version = exec_ver,
        script_name = tostring(scriptName),
        is_premium = isPremium and true or false,
        license = tostring(MY_LICENSE or ""),
        discord_username = tostring(_G.TB_DISCORD_USERNAME or ""),
        panel_type = tostring(_G.TB_PANEL_TYPE or PANEL_TYPE or ""),
    }
    pcall(function()
        requestFn({
            Url = TRACK_ENDPOINT,
            Method = "POST",
            Body = HttpService:JSONEncode(body),
            Headers = { ["Content-Type"] = "application/json" },
        })
    end)
end

--========================================================--
-- GUI
--========================================================--

local GUI_NAME = "Leaderboard"

local TargetParent
local parentSuccess = pcall(function()
    TargetParent = CoreGui
    local _ = CoreGui.Name
end)
if not parentSuccess or not TargetParent then
    TargetParent = LocalPlayer:WaitForChild("PlayerGui")
end

local existing = TargetParent:FindFirstChild(GUI_NAME)
if existing then existing:Destroy() end

local Config = {
    Title = "Toolbox Loader",
    Subtitle = "Execute your favorite script",
    DiscordLink = "https://discord.gg/Vuj9j5MrDq"
}

local SupportedGames = {
    { Name = "Universal [INFINITE YIELD]", Description = "Universal admin and utility command hub.",
      Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/edgeiy/infiniteyield/master/source"))()' },
    { Name = "+1 keyboard escape", Description = "Keyboard escape tools with a speed boost.",
      Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Abdullahking20/loader-lua/refs/heads/main/1%20keyboard%20escape"))()' },
    { Name = "asylum life", Description = "Gameplay utilities for Asylum Life.",
      Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Abdullahking20/loader-lua/refs/heads/main/asylum%20life"))()' },
    { Name = "doors", Description = "Gameplay utilities for Doors.",
      Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Abdullahking20/loader-lua/refs/heads/main/doors%20script%20free%20tier"))()' },
    { Name = "mm2", Description = "Tools for Murder Mystery 2 matches.",
      Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Abdullahking20/loader-lua/refs/heads/main/murder%20mystery%202%20free%20tier"))()' },
    { Name = "sell lemons", Description = "Gameplay utilities for collecting and selling lemons.",
      Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Abdullahking20/loader-lua/refs/heads/main/sell%20lemon%20free%20tier"))()' },
    { Name = "grow a garden 2", Description = "Automation and utility tools for Grow a Garden 2.",
      Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Abdullahking20/loader-lua/refs/heads/main/grow%20a%20garden%202%20free%20tier"))()' },
    { Name = "steal an egg", Description = "Gameplay utilities for collecting eggs.",
      Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Abdullahking20/loader-lua/refs/heads/main/steal%20an%20egg"))()' },
    { Name = "slap battles", Description = "Gameplay utilities for Slap Battles.",
      Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Abdullahking20/loader-lua/refs/heads/main/slap%20battle"))()' },
    { Name = "Fling Things and People", Description = "A physics-based fling utility for the current game.",
      Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Abdullahking20/loader-lua/main/fling%20things%20and%20people"))()' }
}

local PremiumGames = {
    { Name = "Blox Fruits", Description = "Premium automation and utilities for Blox Fruits.",
      Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Abdullahking20/loader-lua/main/blox%20fruit"))()' },
    { Name = "Untitled Tag Game", Description = "Premium utilities for Untitled Tag Game.",
      Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Abdullahking20/loader-lua/main/utg"))()' },
    { Name = "Forsaken", Description = "Premium tools and utilities for Forsaken.",
      Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Abdullahking20/loader-lua/main/forsaken"))()' },
    { Name = "+1 Keyboard Escape", Description = "Premium keyboard escape tools with enhanced features.",
      Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Abdullahking20/loader-lua/main/1%20keyboard%20escape"))()' },
    { Name = "Fling Things and People", Description = "Premium physics-based fling utility for the current game.",
      Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Abdullahking20/loader-lua/main/fling%20things%20and%20people"))()' },
    { Name = "Muscle Legends", Description = "Premium automation and utility tools for Muscle Legends.",
      Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Abdullahking20/loader-lua/main/muscle%20legends"))()' },
    { Name = "Steal an Egg", Description = "Premium tools for collecting eggs faster.",
      Script = 'loadstring(game:HttpGet("https://raw.githubusercontent.com/Abdullahking20/loader-lua/main/steal%20an%20egg"))()' },
    { Name = "Murder Mystery 2", Description = "Premium tools for Murder Mystery 2 — coming soon.",
      Script = "", ComingSoon = true },
}

local Theme = {
    Background    = Color3.fromRGB(8, 8, 10),
    SidebarBg     = Color3.fromRGB(11, 11, 14),
    CardBg        = Color3.fromRGB(15, 15, 18),
    CardHover     = Color3.fromRGB(22, 22, 26),
    TabActive     = Color3.fromRGB(24, 24, 30),
    Border        = Color3.fromRGB(30, 30, 36),
    BorderSoft    = Color3.fromRGB(20, 20, 24),
    Primary       = Color3.fromRGB(88, 101, 242),
    PrimaryHover  = Color3.fromRGB(71, 82, 196),
    TextWhite     = Color3.fromRGB(245, 245, 250),
    TextMuted     = Color3.fromRGB(130, 130, 140),
    TextDark      = Color3.fromRGB(75, 75, 85),
    Success       = Color3.fromRGB(46, 204, 113),
    Danger        = Color3.fromRGB(235, 75, 75),
    Premium       = Color3.fromRGB(155, 89, 182),
    PremiumSoft   = Color3.fromRGB(180, 130, 220),
    Free          = Color3.fromRGB(46, 204, 113),
    FreeSoft      = Color3.fromRGB(120, 230, 170)
}

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = GUI_NAME
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.DisplayOrder = 999999
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = TargetParent

local DarkOverlay = Instance.new("Frame")
DarkOverlay.Size = UDim2.new(1, 0, 1, 0)
DarkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
DarkOverlay.BackgroundTransparency = 0.5
DarkOverlay.BorderSizePixel = 0
DarkOverlay.ZIndex = 0
DarkOverlay.Parent = ScreenGui

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 880, 0, 530)
MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.BackgroundColor3 = Theme.Background
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = false
MainFrame.ZIndex = 2
MainFrame.Parent = ScreenGui

local MainScale = Instance.new("UIScale")
MainScale.Parent = MainFrame

local BASE_WIDTH, BASE_HEIGHT, PADDING = 880, 530, 16

local function updateScale()
    local screenSize = ScreenGui.AbsoluteSize
    if screenSize.X <= 0 or screenSize.Y <= 0 then
        local cam = workspace.CurrentCamera
        if cam then screenSize = cam.ViewportSize end
    end
    if screenSize.X > 0 and screenSize.Y > 0 then
        local scaleX = (screenSize.X - PADDING * 2) / BASE_WIDTH
        local scaleY = (screenSize.Y - PADDING * 2) / BASE_HEIGHT
        MainScale.Scale = math.clamp(math.min(1, math.min(scaleX, scaleY)), 0.35, 1)
    end
end

updateScale()
ScreenGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(updateScale)

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Thickness = 1.2
MainStroke.Color = Theme.Border
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

local ToastContainer = Instance.new("Frame")
ToastContainer.Position = UDim2.new(1, -280, 1, -75)
ToastContainer.Size = UDim2.new(0, 260, 0, 55)
ToastContainer.BackgroundTransparency = 1
ToastContainer.ZIndex = 100
ToastContainer.Parent = MainFrame

local LoadingOverlay = Instance.new("Frame")
LoadingOverlay.Size = UDim2.fromScale(1, 1)
LoadingOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
LoadingOverlay.BackgroundTransparency = 0.25
LoadingOverlay.Visible = false
LoadingOverlay.ZIndex = 200
LoadingOverlay.Parent = ScreenGui

local LoadingCard = Instance.new("Frame")
LoadingCard.Size = UDim2.fromOffset(340, 128)
LoadingCard.Position = UDim2.fromScale(0.5, 0.5)
LoadingCard.AnchorPoint = Vector2.new(0.5, 0.5)
LoadingCard.BackgroundColor3 = Color3.fromRGB(5, 5, 7)
LoadingCard.BorderSizePixel = 0
LoadingCard.ZIndex = 201
LoadingCard.Parent = LoadingOverlay

local LoadingCorner = Instance.new("UICorner")
LoadingCorner.CornerRadius = UDim.new(0, 10)
LoadingCorner.Parent = LoadingCard

local LoadingStroke = Instance.new("UIStroke")
LoadingStroke.Color = Theme.Border
LoadingStroke.Thickness = 1.2
LoadingStroke.Parent = LoadingCard

local LoadingTitle = Instance.new("TextLabel")
LoadingTitle.Size = UDim2.new(1, -28, 0, 24)
LoadingTitle.Position = UDim2.fromOffset(14, 14)
LoadingTitle.BackgroundTransparency = 1
LoadingTitle.Font = Enum.Font.GothamBold
LoadingTitle.Text = "Injecting script..."
LoadingTitle.TextColor3 = Theme.TextWhite
LoadingTitle.TextSize = 14
LoadingTitle.TextXAlignment = Enum.TextXAlignment.Left
LoadingTitle.ZIndex = 202
LoadingTitle.Parent = LoadingCard

local LoadingStatus = Instance.new("TextLabel")
LoadingStatus.Size = UDim2.new(1, -28, 0, 20)
LoadingStatus.Position = UDim2.fromOffset(14, 45)
LoadingStatus.BackgroundTransparency = 1
LoadingStatus.Font = Enum.Font.Gotham
LoadingStatus.Text = "Preparing script..."
LoadingStatus.TextColor3 = Theme.TextMuted
LoadingStatus.TextSize = 11
LoadingStatus.TextXAlignment = Enum.TextXAlignment.Left
LoadingStatus.ZIndex = 202
LoadingStatus.Parent = LoadingCard

local LoadingBar = Instance.new("Frame")
LoadingBar.Size = UDim2.new(1, -28, 0, 7)
LoadingBar.Position = UDim2.fromOffset(14, 83)
LoadingBar.BackgroundColor3 = Theme.BorderSoft
LoadingBar.BorderSizePixel = 0
LoadingBar.ZIndex = 202
LoadingBar.Parent = LoadingCard

local LoadingBarCorner = Instance.new("UICorner")
LoadingBarCorner.CornerRadius = UDim.new(0, 4)
LoadingBarCorner.Parent = LoadingBar

local LoadingFill = Instance.new("Frame")
LoadingFill.Size = UDim2.new(0, 0, 1, 0)
LoadingFill.BackgroundColor3 = Theme.Primary
LoadingFill.BorderSizePixel = 0
LoadingFill.ZIndex = 203
LoadingFill.Parent = LoadingBar

local LoadingFillCorner = Instance.new("UICorner")
LoadingFillCorner.CornerRadius = UDim.new(0, 4)
LoadingFillCorner.Parent = LoadingFill

local function ShowNotification(title, message, isSuccess)
    local Toast = Instance.new("Frame")
    Toast.Size = UDim2.new(1, 0, 1, 0)
    Toast.Position = UDim2.new(0, 30, 0, 0)
    Toast.BackgroundColor3 = Theme.CardBg
    Toast.BackgroundTransparency = 1
    Toast.BorderSizePixel = 0
    Toast.ZIndex = 101
    Toast.Parent = ToastContainer

    local TC = Instance.new("UICorner")
    TC.CornerRadius = UDim.new(0, 10)
    TC.Parent = Toast

    local TS = Instance.new("UIStroke")
    TS.Color = isSuccess and Theme.Primary or Theme.Border
    TS.Thickness = 1
    TS.Transparency = 1
    TS.Parent = Toast

    local TT = Instance.new("TextLabel")
    TT.Position = UDim2.new(0, 16, 0, 9)
    TT.Size = UDim2.new(1, -32, 0, 18)
    TT.BackgroundTransparency = 1
    TT.Font = Enum.Font.GothamBold
    TT.Text = title
    TT.TextColor3 = Theme.TextWhite
    TT.TextSize = 13
    TT.TextXAlignment = Enum.TextXAlignment.Left
    TT.TextTransparency = 1
    TT.ZIndex = 102
    TT.Parent = Toast

    local TD = Instance.new("TextLabel")
    TD.Position = UDim2.new(0, 16, 0, 27)
    TD.Size = UDim2.new(1, -32, 0, 20)
    TD.BackgroundTransparency = 1
    TD.Font = Enum.Font.Gotham
    TD.Text = message
    TD.TextColor3 = Theme.TextMuted
    TD.TextSize = 11
    TD.TextXAlignment = Enum.TextXAlignment.Left
    TD.TextTransparency = 1
    TD.TextTruncate = Enum.TextTruncate.AtEnd
    TD.ZIndex = 102
    TD.Parent = Toast

    TweenService:Create(Toast, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Position = UDim2.new(0, 0, 0, 0), BackgroundTransparency = 0
    }):Play()
    TweenService:Create(TS, TweenInfo.new(0.3), { Transparency = 0 }):Play()
    TweenService:Create(TT, TweenInfo.new(0.3), { TextTransparency = 0 }):Play()
    TweenService:Create(TD, TweenInfo.new(0.3), { TextTransparency = 0 }):Play()

    task.delay(3, function()
        if Toast and Toast.Parent then
            local tw = TweenService:Create(Toast, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Position = UDim2.new(0, 40, 0, 0), BackgroundTransparency = 1
            })
            TweenService:Create(TS, TweenInfo.new(0.2), { Transparency = 1 }):Play()
            TweenService:Create(TT, TweenInfo.new(0.2), { TextTransparency = 1 }):Play()
            TweenService:Create(TD, TweenInfo.new(0.2), { TextTransparency = 1 }):Play()
            tw:Play()
            tw.Completed:Connect(function() Toast:Destroy() end)
        end
    end)
end

--========================================================--
-- PREMIUM ROLE REQUIRED DIALOG
--========================================================--

local function ShowPremiumRequiredDialog()
    local dialogGui = Instance.new("ScreenGui")
    dialogGui.Name = "ToolboxPremiumRequired"
    dialogGui.ResetOnSpawn = false
    dialogGui.IgnoreGuiInset = true
    dialogGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    dialogGui.DisplayOrder = 999997
    dialogGui.Parent = TargetParent

    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 0.4
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 1
    overlay.Parent = dialogGui

    local card = Instance.new("Frame")
    card.Size = UDim2.fromOffset(460, 200)
    card.Position = UDim2.new(0.5, -230, 0.5, -100)
    card.BackgroundColor3 = Color3.fromRGB(20, 12, 25)
    card.BorderSizePixel = 0
    card.ZIndex = 2
    card.Parent = overlay

    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 14)
    corner.Parent = card

    local stroke = Instance.new("UIStroke")
    stroke.Color = Theme.Premium
    stroke.Thickness = 2
    stroke.Parent = card

    local icon = Instance.new("TextLabel")
    icon.Size = UDim2.fromOffset(50, 50)
    icon.Position = UDim2.new(0, 30, 0, 30)
    icon.BackgroundColor3 = Theme.Premium
    icon.BorderSizePixel = 0
    icon.Font = Enum.Font.GothamBold
    icon.Text = "!"
    icon.TextColor3 = Color3.fromRGB(255, 255, 255)
    icon.TextSize = 28
    icon.ZIndex = 3
    icon.Parent = card

    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = icon

    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -100, 0, 26)
    title.Position = UDim2.new(0, 95, 0, 42)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "Premium Role Required"
    title.TextColor3 = Color3.fromRGB(245, 220, 255)
    title.TextSize = 16
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 3
    title.Parent = card

    local desc = Instance.new("TextLabel")
    desc.Size = UDim2.new(1, -60, 0, 60)
    desc.Position = UDim2.new(0, 30, 0, 100)
    desc.BackgroundTransparency = 1
    desc.Font = Enum.Font.Gotham
    desc.Text = "You need the Premium role in our Discord to use premium scripts.\nIf you think this is a mistake, please contact support in the Discord."
    desc.TextColor3 = Color3.fromRGB(180, 180, 190)
    desc.TextSize = 12
    desc.TextXAlignment = Enum.TextXAlignment.Left
    desc.TextYAlignment = Enum.TextYAlignment.Top
    desc.TextWrapped = true
    desc.ZIndex = 3
    desc.Parent = card

    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 100, 0, 34)
    closeBtn.Position = UDim2.new(1, -130, 1, -46)
    closeBtn.BackgroundColor3 = Theme.Premium
    closeBtn.BorderSizePixel = 0
    closeBtn.AutoButtonColor = false
    closeBtn.Text = "Got it"
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.TextSize = 12
    closeBtn.ZIndex = 3
    closeBtn.Parent = card

    local btnCorner = Instance.new("UICorner")
    btnCorner.CornerRadius = UDim.new(0, 6)
    btnCorner.Parent = closeBtn

    closeBtn.MouseEnter:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), { BackgroundColor3 = Color3.fromRGB(180, 110, 210) }):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TweenService:Create(closeBtn, TweenInfo.new(0.2), { BackgroundColor3 = Theme.Premium }):Play()
    end)

    closeBtn.MouseButton1Click:Connect(function()
        dialogGui:Destroy()
    end)
end

--========================================================--
-- WELCOME ALERT
--========================================================--

local warningGuiParent = TargetParent

local function showWelcomeAlert(discordUsername)
    if not discordUsername or discordUsername == "" then
        discordUsername = "User"
    end

    local welcomeGui = Instance.new("ScreenGui")
    welcomeGui.Name = "ToolboxWelcomeAlert"
    welcomeGui.ResetOnSpawn = false
    welcomeGui.IgnoreGuiInset = true
    welcomeGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    welcomeGui.DisplayOrder = 999998
    welcomeGui.Parent = warningGuiParent

    local overlay = Instance.new("Frame")
    overlay.Size = UDim2.new(1, 0, 1, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    overlay.BackgroundTransparency = 1
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 1
    overlay.Parent = welcomeGui

    local card = Instance.new("Frame")
    card.Size = UDim2.fromOffset(420, 130)
    card.Position = UDim2.new(0.5, -210, 0.5, -65)
    card.BackgroundColor3 = Color3.fromRGB(18, 26, 20)
    card.BackgroundTransparency = 1
    card.BorderSizePixel = 0
    card.ZIndex = 2
    card.Parent = overlay

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 16)
    cardCorner.Parent = card

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Color = Color3.fromRGB(46, 204, 113)
    cardStroke.Thickness = 2
    cardStroke.Transparency = 1
    cardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    cardStroke.Parent = card

    local accentBar = Instance.new("Frame")
    accentBar.Size = UDim2.new(0, 5, 1, -24)
    accentBar.Position = UDim2.new(0, 12, 0, 12)
    accentBar.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    accentBar.BorderSizePixel = 0
    accentBar.ZIndex = 3
    accentBar.Parent = card

    local accentCorner = Instance.new("UICorner")
    accentCorner.CornerRadius = UDim.new(1, 0)
    accentCorner.Parent = accentBar

    local iconBox = Instance.new("Frame")
    iconBox.Size = UDim2.fromOffset(46, 46)
    iconBox.Position = UDim2.new(0, 30, 0.5, -23)
    iconBox.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
    iconBox.BackgroundTransparency = 1
    iconBox.BorderSizePixel = 0
    iconBox.ZIndex = 3
    iconBox.Parent = card

    local iconCorner = Instance.new("UICorner")
    iconCorner.CornerRadius = UDim.new(1, 0)
    iconCorner.Parent = iconBox

    local iconLabel = Instance.new("TextLabel")
    iconLabel.Size = UDim2.fromScale(1, 1)
    iconLabel.BackgroundTransparency = 1
    iconLabel.Font = Enum.Font.GothamBold
    iconLabel.Text = "✓"
    iconLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    iconLabel.TextSize = 28
    iconLabel.TextTransparency = 1
    iconLabel.ZIndex = 4
    iconLabel.Parent = iconBox

    local title = Instance.new("TextLabel")
    title.Position = UDim2.new(0, 92, 0, 28)
    title.Size = UDim2.new(1, -110, 0, 18)
    title.BackgroundTransparency = 1
    title.Font = Enum.Font.GothamBold
    title.Text = "WELCOME"
    title.TextColor3 = Color3.fromRGB(120, 230, 170)
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.TextTransparency = 1
    title.ZIndex = 3
    title.Parent = card

    local greeting = Instance.new("TextLabel")
    greeting.Position = UDim2.new(0, 92, 0, 46)
    greeting.Size = UDim2.new(1, -110, 0, 30)
    greeting.BackgroundTransparency = 1
    greeting.Font = Enum.Font.GothamBlack
    greeting.Text = "Hello, " .. tostring(discordUsername) .. "!"
    greeting.TextColor3 = Color3.fromRGB(245, 245, 250)
    greeting.TextSize = 20
    greeting.TextXAlignment = Enum.TextXAlignment.Left
    greeting.TextTruncate = Enum.TextTruncate.AtEnd
    greeting.TextTransparency = 1
    greeting.ZIndex = 3
    greeting.Parent = card

    local subtitle = Instance.new("TextLabel")
    subtitle.Position = UDim2.new(0, 92, 0, 78)
    subtitle.Size = UDim2.new(1, -110, 0, 16)
    subtitle.BackgroundTransparency = 1
    subtitle.Font = Enum.Font.Gotham
    subtitle.Text = "Licensed session · Enjoy Toolbox Hub"
    subtitle.TextColor3 = Color3.fromRGB(130, 130, 140)
    subtitle.TextSize = 11
    subtitle.TextXAlignment = Enum.TextXAlignment.Left
    subtitle.TextTransparency = 1
    subtitle.ZIndex = 3
    subtitle.Parent = card

    card.Position = UDim2.new(0.5, -210, 0.5, -50)
    card.Size = UDim2.fromOffset(400, 120)

    TweenService:Create(card, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(0.5, -210, 0.5, -65),
        Size = UDim2.fromOffset(420, 130),
        BackgroundTransparency = 0,
    }):Play()

    TweenService:Create(cardStroke, TweenInfo.new(0.35), { Transparency = 0.15 }):Play()

    iconBox.Size = UDim2.fromOffset(0, 0)
    iconBox.Position = UDim2.new(0, 53, 0.5, 0)
    TweenService:Create(iconBox, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Size = UDim2.fromOffset(46, 46),
        Position = UDim2.new(0, 30, 0.5, -23),
        BackgroundTransparency = 0,
    }):Play()

    task.delay(0.15, function()
        TweenService:Create(iconLabel, TweenInfo.new(0.2), { TextTransparency = 0 }):Play()
    end)
    task.delay(0.10, function()
        TweenService:Create(title, TweenInfo.new(0.25), { TextTransparency = 0 }):Play()
    end)
    task.delay(0.18, function()
        TweenService:Create(greeting, TweenInfo.new(0.25), { TextTransparency = 0 }):Play()
    end)
    task.delay(0.26, function()
        TweenService:Create(subtitle, TweenInfo.new(0.25), { TextTransparency = 0 }):Play()
    end)
    task.delay(0.35, function()
        TweenService:Create(accentBar, TweenInfo.new(0.5), {
            BackgroundColor3 = Color3.fromRGB(90, 230, 145),
        }):Play()
    end)

    task.delay(3.0, function()
        if not welcomeGui.Parent then return end

        local outInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In)

        TweenService:Create(card, outInfo, {
            Position = UDim2.new(0.5, -210, 0.5, -90),
            BackgroundTransparency = 1,
        }):Play()

        TweenService:Create(cardStroke, outInfo, { Transparency = 1 }):Play()
        TweenService:Create(iconBox, outInfo, { BackgroundTransparency = 1 }):Play()
        TweenService:Create(iconLabel, outInfo, { TextTransparency = 1 }):Play()
        TweenService:Create(title, outInfo, { TextTransparency = 1 }):Play()
        TweenService:Create(greeting, outInfo, { TextTransparency = 1 }):Play()
        TweenService:Create(subtitle, outInfo, { TextTransparency = 1 }):Play()
        TweenService:Create(accentBar, outInfo, { BackgroundTransparency = 1 }):Play()

        task.delay(0.4, function()
            if welcomeGui then welcomeGui:Destroy() end
        end)
    end)
end

--========================================================--
-- SIDEBAR
--========================================================--

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 205, 1, 0)
Sidebar.BackgroundColor3 = Theme.SidebarBg
Sidebar.BorderSizePixel = 0
Sidebar.ZIndex = 3
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 14)
SidebarCorner.Parent = Sidebar

local SidebarMask = Instance.new("Frame")
SidebarMask.Size = UDim2.new(0, 16, 1, 0)
SidebarMask.Position = UDim2.new(1, -16, 0, 0)
SidebarMask.BackgroundColor3 = Theme.SidebarBg
SidebarMask.BorderSizePixel = 0
SidebarMask.ZIndex = 3
SidebarMask.Parent = Sidebar

local SidebarDivider = Instance.new("Frame")
SidebarDivider.Size = UDim2.new(0, 1, 1, 0)
SidebarDivider.Position = UDim2.new(1, 0, 0, 0)
SidebarDivider.BackgroundColor3 = Theme.BorderSoft
SidebarDivider.BorderSizePixel = 0
SidebarDivider.ZIndex = 3
SidebarDivider.Parent = Sidebar

local BrandFrame = Instance.new("Frame")
BrandFrame.Size = UDim2.new(1, 0, 0, 75)
BrandFrame.BackgroundTransparency = 1
BrandFrame.ZIndex = 4
BrandFrame.Parent = Sidebar

local LogoBox = Instance.new("Frame")
LogoBox.Size = UDim2.new(0, 38, 0, 38)
LogoBox.Position = UDim2.new(0, 16, 0.5, -19)
LogoBox.BackgroundTransparency = 1
LogoBox.ZIndex = 4
LogoBox.Parent = BrandFrame

local LogoImage = Instance.new("ImageLabel")
LogoImage.Size = UDim2.new(1, 0, 1, 0)
LogoImage.BackgroundTransparency = 1
LogoImage.Image = "rbxassetid://135709393000657"
LogoImage.ScaleType = Enum.ScaleType.Fit
LogoImage.ZIndex = 5
LogoImage.Parent = LogoBox

local LogoCorner = Instance.new("UICorner")
LogoCorner.CornerRadius = UDim.new(0, 9)
LogoCorner.Parent = LogoImage

local BrandTitle = Instance.new("TextLabel")
BrandTitle.Size = UDim2.new(1, -66, 0, 20)
BrandTitle.Position = UDim2.new(0, 62, 0.5, -17)
BrandTitle.BackgroundTransparency = 1
BrandTitle.Font = Enum.Font.GothamBold
BrandTitle.Text = Config.Title
BrandTitle.TextColor3 = Theme.TextWhite
BrandTitle.TextSize = 15
BrandTitle.TextXAlignment = Enum.TextXAlignment.Left
BrandTitle.ZIndex = 4
BrandTitle.Parent = BrandFrame

local BrandSub = Instance.new("TextLabel")
BrandSub.Size = UDim2.new(1, -66, 0, 16)
BrandSub.Position = UDim2.new(0, 62, 0.5, 3)
BrandSub.BackgroundTransparency = 1
BrandSub.Font = Enum.Font.Gotham
BrandSub.Text = Config.Subtitle
BrandSub.TextColor3 = Theme.TextMuted
BrandSub.TextSize = 10
BrandSub.TextXAlignment = Enum.TextXAlignment.Left
BrandSub.ZIndex = 4
BrandSub.Parent = BrandFrame

local NavContainer = Instance.new("Frame")
NavContainer.Size = UDim2.new(1, -24, 0, 200)
NavContainer.Position = UDim2.new(0, 12, 0, 85)
NavContainer.BackgroundTransparency = 1
NavContainer.ZIndex = 4
NavContainer.Parent = Sidebar

local NavLayout = Instance.new("UIListLayout")
NavLayout.SortOrder = Enum.SortOrder.LayoutOrder
NavLayout.Padding = UDim.new(0, 8)
NavLayout.Parent = NavContainer

-- HOME TAB
local HomeTab = Instance.new("TextButton")
HomeTab.Size = UDim2.new(1, 0, 0, 42)
HomeTab.BackgroundColor3 = Theme.TabActive
HomeTab.BorderSizePixel = 0
HomeTab.AutoButtonColor = false
HomeTab.Text = ""
HomeTab.LayoutOrder = 1
HomeTab.ZIndex = 4
HomeTab.Parent = NavContainer

local HomeTabCorner = Instance.new("UICorner")
HomeTabCorner.CornerRadius = UDim.new(0, 8)
HomeTabCorner.Parent = HomeTab

local HomeTabStroke = Instance.new("UIStroke")
HomeTabStroke.Color = Theme.Border
HomeTabStroke.Thickness = 1
HomeTabStroke.Parent = HomeTab

local HomeIcon = Instance.new("ImageLabel")
HomeIcon.Size = UDim2.new(0, 20, 0, 20)
HomeIcon.Position = UDim2.new(0, 14, 0.5, -10)
HomeIcon.BackgroundTransparency = 1
HomeIcon.Image = "rbxassetid://6031075931"
HomeIcon.ImageColor3 = Theme.Primary
HomeIcon.ZIndex = 5
HomeIcon.Parent = HomeTab

local HomeLabel = Instance.new("TextLabel")
HomeLabel.Size = UDim2.new(1, -46, 1, 0)
HomeLabel.Position = UDim2.new(0, 44, 0, 0)
HomeLabel.BackgroundTransparency = 1
HomeLabel.Font = Enum.Font.GothamBold
HomeLabel.Text = "Home"
HomeLabel.TextColor3 = Color3.new(1, 1, 1)
HomeLabel.TextSize = 13
HomeLabel.TextXAlignment = Enum.TextXAlignment.Left
HomeLabel.ZIndex = 5
HomeLabel.Parent = HomeTab

-- PREMIUM TAB
local PremiumTab = Instance.new("TextButton")
PremiumTab.Size = UDim2.new(1, 0, 0, 42)
PremiumTab.BackgroundColor3 = Theme.TabActive
PremiumTab.BackgroundTransparency = 1
PremiumTab.BorderSizePixel = 0
PremiumTab.AutoButtonColor = false
PremiumTab.Text = ""
PremiumTab.LayoutOrder = 2
PremiumTab.ZIndex = 4
PremiumTab.Parent = NavContainer

local PremiumTabCorner = Instance.new("UICorner")
PremiumTabCorner.CornerRadius = UDim.new(0, 8)
PremiumTabCorner.Parent = PremiumTab

local PremiumTabStroke = Instance.new("UIStroke")
PremiumTabStroke.Color = Theme.Border
PremiumTabStroke.Thickness = 1
PremiumTabStroke.Transparency = 1
PremiumTabStroke.Parent = PremiumTab

local PremiumIcon = Instance.new("ImageLabel")
PremiumIcon.Size = UDim2.new(0, 20, 0, 20)
PremiumIcon.Position = UDim2.new(0, 14, 0.5, -10)
PremiumIcon.BackgroundTransparency = 1
PremiumIcon.Image = "rbxassetid://6031075931"
PremiumIcon.ImageColor3 = Theme.TextMuted
PremiumIcon.ZIndex = 5
PremiumIcon.Parent = PremiumTab

local PremiumLabel = Instance.new("TextLabel")
PremiumLabel.Size = UDim2.new(1, -100, 1, 0)
PremiumLabel.Position = UDim2.new(0, 44, 0, 0)
PremiumLabel.BackgroundTransparency = 1
PremiumLabel.Font = Enum.Font.GothamMedium
PremiumLabel.Text = "Premium"
PremiumLabel.TextColor3 = Theme.TextMuted
PremiumLabel.TextSize = 13
PremiumLabel.TextXAlignment = Enum.TextXAlignment.Left
PremiumLabel.ZIndex = 5
PremiumLabel.Parent = PremiumTab

local PremiumPill = Instance.new("Frame")
PremiumPill.Size = UDim2.fromOffset(52, 16)
PremiumPill.Position = UDim2.new(1, -60, 0.5, -8)
PremiumPill.BackgroundColor3 = Theme.Premium
PremiumPill.BackgroundTransparency = 0.25
PremiumPill.BorderSizePixel = 0
PremiumPill.ZIndex = 5
PremiumPill.Parent = PremiumTab

local PremiumPillCorner = Instance.new("UICorner")
PremiumPillCorner.CornerRadius = UDim.new(1, 0)
PremiumPillCorner.Parent = PremiumPill

local PremiumPillLabel = Instance.new("TextLabel")
PremiumPillLabel.Size = UDim2.fromScale(1, 1)
PremiumPillLabel.BackgroundTransparency = 1
PremiumPillLabel.Font = Enum.Font.GothamBold
PremiumPillLabel.Text = "VIP"
PremiumPillLabel.TextColor3 = Color3.fromRGB(240, 215, 255)
PremiumPillLabel.TextSize = 9
PremiumPillLabel.ZIndex = 6
PremiumPillLabel.Parent = PremiumPill

-- CREDITS TAB
local CreditsTab = Instance.new("TextButton")
CreditsTab.Size = UDim2.new(1, 0, 0, 42)
CreditsTab.BackgroundColor3 = Theme.TabActive
CreditsTab.BackgroundTransparency = 1
CreditsTab.BorderSizePixel = 0
CreditsTab.AutoButtonColor = false
CreditsTab.Text = ""
CreditsTab.LayoutOrder = 3
CreditsTab.ZIndex = 4
CreditsTab.Parent = NavContainer

local CreditsTabCorner = Instance.new("UICorner")
CreditsTabCorner.CornerRadius = UDim.new(0, 8)
CreditsTabCorner.Parent = CreditsTab

local CreditsTabStroke = Instance.new("UIStroke")
CreditsTabStroke.Color = Theme.Border
CreditsTabStroke.Thickness = 1
CreditsTabStroke.Transparency = 1
CreditsTabStroke.Parent = CreditsTab

local CreditsIcon = Instance.new("ImageLabel")
CreditsIcon.Size = UDim2.new(0, 20, 0, 20)
CreditsIcon.Position = UDim2.new(0, 14, 0.5, -10)
CreditsIcon.BackgroundTransparency = 1
CreditsIcon.Image = "rbxassetid://6031075929"
CreditsIcon.ImageColor3 = Theme.TextMuted
CreditsIcon.ZIndex = 5
CreditsIcon.Parent = CreditsTab

local CreditsLabel = Instance.new("TextLabel")
CreditsLabel.Size = UDim2.new(1, -46, 1, 0)
CreditsLabel.Position = UDim2.new(0, 44, 0, 0)
CreditsLabel.BackgroundTransparency = 1
CreditsLabel.Font = Enum.Font.GothamMedium
CreditsLabel.Text = "Credits"
CreditsLabel.TextColor3 = Theme.TextMuted
CreditsLabel.TextSize = 13
CreditsLabel.TextXAlignment = Enum.TextXAlignment.Left
CreditsLabel.ZIndex = 5
CreditsLabel.Parent = CreditsTab

local activeTab = "Home"

HomeTab.MouseEnter:Connect(function()
    if activeTab ~= "Home" then
        TweenService:Create(HomeTab, TweenInfo.new(0.2), { BackgroundTransparency = 0.5 }):Play()
        TweenService:Create(HomeLabel, TweenInfo.new(0.2), { TextColor3 = Theme.TextWhite }):Play()
        TweenService:Create(HomeIcon, TweenInfo.new(0.2), { ImageColor3 = Theme.TextWhite }):Play()
    end
end)
HomeTab.MouseLeave:Connect(function()
    if activeTab ~= "Home" then
        TweenService:Create(HomeTab, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
        TweenService:Create(HomeLabel, TweenInfo.new(0.2), { TextColor3 = Theme.TextMuted }):Play()
        TweenService:Create(HomeIcon, TweenInfo.new(0.2), { ImageColor3 = Theme.TextMuted }):Play()
    else HomeIcon.ImageColor3 = Theme.Primary end
end)

PremiumTab.MouseEnter:Connect(function()
    if activeTab ~= "Premium" then
        TweenService:Create(PremiumTab, TweenInfo.new(0.2), { BackgroundTransparency = 0.5 }):Play()
        TweenService:Create(PremiumLabel, TweenInfo.new(0.2), { TextColor3 = Theme.TextWhite }):Play()
        TweenService:Create(PremiumIcon, TweenInfo.new(0.2), { ImageColor3 = Theme.TextWhite }):Play()
    end
end)
PremiumTab.MouseLeave:Connect(function()
    if activeTab ~= "Premium" then
        TweenService:Create(PremiumTab, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
        TweenService:Create(PremiumLabel, TweenInfo.new(0.2), { TextColor3 = Theme.TextMuted }):Play()
        TweenService:Create(PremiumIcon, TweenInfo.new(0.2), { ImageColor3 = Theme.TextMuted }):Play()
    else PremiumIcon.ImageColor3 = Theme.PremiumSoft end
end)

CreditsTab.MouseEnter:Connect(function()
    if activeTab ~= "Credits" then
        TweenService:Create(CreditsTab, TweenInfo.new(0.2), { BackgroundTransparency = 0.5 }):Play()
        TweenService:Create(CreditsLabel, TweenInfo.new(0.2), { TextColor3 = Theme.TextWhite }):Play()
        TweenService:Create(CreditsIcon, TweenInfo.new(0.2), { ImageColor3 = Theme.TextWhite }):Play()
    end
end)
CreditsTab.MouseLeave:Connect(function()
    if activeTab ~= "Credits" then
        TweenService:Create(CreditsTab, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
        TweenService:Create(CreditsLabel, TweenInfo.new(0.2), { TextColor3 = Theme.TextMuted }):Play()
        TweenService:Create(CreditsIcon, TweenInfo.new(0.2), { ImageColor3 = Theme.TextMuted }):Play()
    else CreditsIcon.ImageColor3 = Theme.Primary end
end)

-- PROFILE CARD
local ProfileCard = Instance.new("Frame")
ProfileCard.Size = UDim2.new(1, -20, 0, 56)
ProfileCard.Position = UDim2.new(0, 10, 1, -66)
ProfileCard.BackgroundColor3 = Color3.fromRGB(14, 14, 17)
ProfileCard.BorderSizePixel = 0
ProfileCard.ZIndex = 4
ProfileCard.Parent = Sidebar

local ProfileCorner = Instance.new("UICorner")
ProfileCorner.CornerRadius = UDim.new(0, 10)
ProfileCorner.Parent = ProfileCard

local ProfileStroke = Instance.new("UIStroke")
ProfileStroke.Color = Theme.BorderSoft
ProfileStroke.Thickness = 1
ProfileStroke.Parent = ProfileCard

local AvatarContainer = Instance.new("Frame")
AvatarContainer.Size = UDim2.new(0, 36, 0, 36)
AvatarContainer.Position = UDim2.new(0, 10, 0.5, -18)
AvatarContainer.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
AvatarContainer.BorderSizePixel = 0
AvatarContainer.ZIndex = 5
AvatarContainer.Parent = ProfileCard

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarContainer

local AvatarStroke = Instance.new("UIStroke")
AvatarStroke.Color = HAS_PREMIUM_ROLE and Theme.Premium or Theme.Primary
AvatarStroke.Thickness = 1.5
AvatarStroke.Parent = AvatarContainer

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(1, 0, 1, 0)
AvatarImage.BackgroundTransparency = 1
AvatarImage.Image = string.format("rbxthumb://type=AvatarHeadShot&id=%d&w=150&h=150&filters=0", LocalPlayer.UserId)
AvatarImage.ZIndex = 6
AvatarImage.Parent = AvatarContainer

local AvatarImgCorner = Instance.new("UICorner")
AvatarImgCorner.CornerRadius = UDim.new(1, 0)
AvatarImgCorner.Parent = AvatarImage

task.spawn(function()
    pcall(function()
        local content, isReady = Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
        if isReady and content and AvatarImage then
            AvatarImage.Image = content
        end
    end)
end)

local UserNameLabel = Instance.new("TextLabel")
UserNameLabel.Size = UDim2.new(1, -85, 0, 18)
UserNameLabel.Position = UDim2.new(0, 54, 0.5, -18)
UserNameLabel.BackgroundTransparency = 1
UserNameLabel.Font = Enum.Font.GothamBold
UserNameLabel.Text = LocalPlayer.DisplayName
UserNameLabel.TextColor3 = Theme.TextWhite
UserNameLabel.TextSize = 13
UserNameLabel.TextXAlignment = Enum.TextXAlignment.Left
UserNameLabel.TextTruncate = Enum.TextTruncate.AtEnd
UserNameLabel.ZIndex = 5
UserNameLabel.Parent = ProfileCard

local UserHandleLabel = Instance.new("TextLabel")
UserHandleLabel.Size = UDim2.new(1, -85, 0, 14)
UserHandleLabel.Position = UDim2.new(0, 54, 0.5, 2)
UserHandleLabel.BackgroundTransparency = 1
UserHandleLabel.Font = Enum.Font.Gotham
UserHandleLabel.TextSize = 11
UserHandleLabel.TextXAlignment = Enum.TextXAlignment.Left
UserHandleLabel.TextTruncate = Enum.TextTruncate.AtEnd
UserHandleLabel.ZIndex = 5
UserHandleLabel.Parent = ProfileCard

if IS_LICENSED and LICENSE_INFO then
    local dname = LICENSE_INFO.discord_username or "Unknown"
    UserHandleLabel.Text = "via " .. tostring(dname)
    UserHandleLabel.TextColor3 = Theme.PremiumSoft
else
    UserHandleLabel.Text = "@" .. LocalPlayer.Name
    UserHandleLabel.TextColor3 = Theme.TextMuted
end

local Chevron = Instance.new("ImageLabel")
Chevron.Size = UDim2.new(0, 14, 0, 14)
Chevron.Position = UDim2.new(1, -22, 0.5, -7)
Chevron.BackgroundTransparency = 1
Chevron.Image = "rbxassetid://6034384749"
Chevron.ImageColor3 = Theme.TextDark
Chevron.ZIndex = 5
Chevron.Parent = ProfileCard

-- TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, -205, 0, 65)
TopBar.Position = UDim2.new(0, 205, 0, 0)
TopBar.BackgroundTransparency = 1
TopBar.ZIndex = 3
TopBar.Parent = MainFrame

local SearchBoxContainer = Instance.new("Frame")
SearchBoxContainer.Size = UDim2.new(0, 360, 0, 38)
SearchBoxContainer.Position = UDim2.new(0, 24, 0.5, -19)
SearchBoxContainer.BackgroundColor3 = Theme.CardBg
SearchBoxContainer.BorderSizePixel = 0
SearchBoxContainer.ZIndex = 4
SearchBoxContainer.Parent = TopBar

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 8)
SearchCorner.Parent = SearchBoxContainer

local SearchStroke = Instance.new("UIStroke")
SearchStroke.Color = Theme.Border
SearchStroke.Thickness = 1
SearchStroke.Parent = SearchBoxContainer

local SearchIcon = Instance.new("ImageLabel")
SearchIcon.Size = UDim2.new(0, 16, 0, 16)
SearchIcon.Position = UDim2.new(0, 12, 0.5, -8)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Image = "rbxassetid://6031154871"
SearchIcon.ImageColor3 = Theme.TextMuted
SearchIcon.ZIndex = 5
SearchIcon.Parent = SearchBoxContainer

-- *** This is the ONLY TextBox in the entire loader (search bar). ***
local SearchInput = Instance.new("TextBox")
SearchInput.Size = UDim2.new(1, -40, 1, 0)
SearchInput.Position = UDim2.new(0, 36, 0, 0)
SearchInput.BackgroundTransparency = 1
SearchInput.Font = Enum.Font.Gotham
SearchInput.PlaceholderText = "Search supported games..."
SearchInput.PlaceholderColor3 = Theme.TextDark
SearchInput.Text = ""
SearchInput.TextColor3 = Theme.TextWhite
SearchInput.TextSize = 13
SearchInput.TextXAlignment = Enum.TextXAlignment.Left
SearchInput.ClearTextOnFocus = false
SearchInput.ZIndex = 5
SearchInput.Parent = SearchBoxContainer

SearchInput.Focused:Connect(function()
    TweenService:Create(SearchStroke, TweenInfo.new(0.2), { Color = Theme.Primary }):Play()
    TweenService:Create(SearchIcon, TweenInfo.new(0.2), { ImageColor3 = Theme.Primary }):Play()
end)
SearchInput.FocusLost:Connect(function()
    TweenService:Create(SearchStroke, TweenInfo.new(0.2), { Color = Theme.Border }):Play()
    TweenService:Create(SearchIcon, TweenInfo.new(0.2), { ImageColor3 = Theme.TextMuted }):Play()
end)

-- TIER BADGE
local TierBadge = Instance.new("Frame")
TierBadge.Size = UDim2.fromOffset(92, 26)
TierBadge.Position = UDim2.new(1, -240, 0.5, -13)
TierBadge.BackgroundColor3 = Theme.Premium
TierBadge.BackgroundTransparency = 0.15
TierBadge.BorderSizePixel = 0
TierBadge.ZIndex = 4
TierBadge.Parent = TopBar

local TierBadgeCorner = Instance.new("UICorner")
TierBadgeCorner.CornerRadius = UDim.new(1, 0)
TierBadgeCorner.Parent = TierBadge

local TierBadgeStroke = Instance.new("UIStroke")
TierBadgeStroke.Color = Theme.PremiumSoft
TierBadgeStroke.Thickness = 1
TierBadgeStroke.Transparency = 0.3
TierBadgeStroke.Parent = TierBadge

local TierBadgeIcon = Instance.new("ImageLabel")
TierBadgeIcon.Size = UDim2.fromOffset(14, 14)
TierBadgeIcon.Position = UDim2.new(0, 9, 0.5, -7)
TierBadgeIcon.BackgroundTransparency = 1
TierBadgeIcon.Image = "rbxassetid://6031075931"
TierBadgeIcon.ImageColor3 = Color3.fromRGB(245, 220, 255)
TierBadgeIcon.ZIndex = 5
TierBadgeIcon.Parent = TierBadge

local TierBadgeLabel = Instance.new("TextLabel")
TierBadgeLabel.Size = UDim2.new(1, -26, 1, 0)
TierBadgeLabel.Position = UDim2.new(0, 26, 0, 0)
TierBadgeLabel.BackgroundTransparency = 1
TierBadgeLabel.Font = Enum.Font.GothamBold
TierBadgeLabel.Text = "PREMIUM"
TierBadgeLabel.TextColor3 = Color3.fromRGB(245, 220, 255)
TierBadgeLabel.TextSize = 11
TierBadgeLabel.TextXAlignment = Enum.TextXAlignment.Left
TierBadgeLabel.ZIndex = 5
TierBadgeLabel.Parent = TierBadge

local WindowControls = Instance.new("Frame")
WindowControls.Size = UDim2.new(0, 70, 0, 32)
WindowControls.Position = UDim2.new(1, -85, 0.5, -16)
WindowControls.BackgroundTransparency = 1
WindowControls.ZIndex = 4
WindowControls.Parent = TopBar

local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(0, 0, 0, 1)
MinimizeBtn.BackgroundColor3 = Theme.CardBg
MinimizeBtn.BackgroundTransparency = 0.8
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Text = "—"
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.TextColor3 = Theme.TextMuted
MinimizeBtn.TextSize = 13
MinimizeBtn.AutoButtonColor = false
MinimizeBtn.ZIndex = 5
MinimizeBtn.Parent = WindowControls

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeBtn

local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(0, 36, 0, 1)
CloseBtn.BackgroundColor3 = Theme.CardBg
CloseBtn.BackgroundTransparency = 0.8
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextColor3 = Theme.TextMuted
CloseBtn.TextSize = 12
CloseBtn.AutoButtonColor = false
CloseBtn.ZIndex = 5
CloseBtn.Parent = WindowControls

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseBtn

MinimizeBtn.MouseEnter:Connect(function()
    TweenService:Create(MinimizeBtn, TweenInfo.new(0.2), { BackgroundTransparency = 0.2, TextColor3 = Theme.TextWhite }):Play()
end)
MinimizeBtn.MouseLeave:Connect(function()
    TweenService:Create(MinimizeBtn, TweenInfo.new(0.2), { BackgroundTransparency = 0.8, TextColor3 = Theme.TextMuted }):Play()
end)
CloseBtn.MouseEnter:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), { BackgroundTransparency = 0.1, BackgroundColor3 = Theme.Danger, TextColor3 = Color3.new(1,1,1) }):Play()
end)
CloseBtn.MouseLeave:Connect(function()
    TweenService:Create(CloseBtn, TweenInfo.new(0.2), { BackgroundTransparency = 0.8, BackgroundColor3 = Theme.CardBg, TextColor3 = Theme.TextMuted }):Play()
end)

local isGuiClosing = false

local function CloseGuiAnimated(onComplete)
    if isGuiClosing then return end
    isGuiClosing = true
    TweenService:Create(DarkOverlay, TweenInfo.new(0.25), { BackgroundTransparency = 1 }):Play()
    local tw = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset + 50),
        BackgroundTransparency = 1
    })
    TweenService:Create(MainStroke, TweenInfo.new(0.25), { Transparency = 1 }):Play()
    tw:Play()
    tw.Completed:Connect(function()
        ScreenGui:Destroy()
        if onComplete then onComplete() end
    end)
end

CloseBtn.MouseButton1Click:Connect(function() CloseGuiAnimated() end)

-- RIGHT PANEL
local RightPanel = Instance.new("Frame")
RightPanel.Size = UDim2.new(0, 205, 1, -80)
RightPanel.Position = UDim2.new(1, -220, 0, 65)
RightPanel.BackgroundTransparency = 1
RightPanel.ZIndex = 3
RightPanel.Parent = MainFrame

local RightLayout = Instance.new("UIListLayout")
RightLayout.SortOrder = Enum.SortOrder.LayoutOrder
RightLayout.Padding = UDim.new(0, 12)
RightLayout.Parent = RightPanel

local QuickCard = Instance.new("Frame")
QuickCard.Size = UDim2.new(1, 0, 0, 120)
QuickCard.BackgroundColor3 = Theme.CardBg
QuickCard.BorderSizePixel = 0
QuickCard.LayoutOrder = 1
QuickCard.ZIndex = 4
QuickCard.Parent = RightPanel

local QuickCorner = Instance.new("UICorner")
QuickCorner.CornerRadius = UDim.new(0, 10)
QuickCorner.Parent = QuickCard

local QuickStroke = Instance.new("UIStroke")
QuickStroke.Color = Theme.BorderSoft
QuickStroke.Thickness = 1
QuickStroke.Parent = QuickCard

local QuickTitle = Instance.new("TextLabel")
QuickTitle.Size = UDim2.new(1, -24, 0, 24)
QuickTitle.Position = UDim2.new(0, 12, 0, 8)
QuickTitle.BackgroundTransparency = 1
QuickTitle.Font = Enum.Font.GothamBold
QuickTitle.Text = "Quick Actions"
QuickTitle.TextColor3 = Theme.TextWhite
QuickTitle.TextSize = 12
QuickTitle.TextXAlignment = Enum.TextXAlignment.Left
QuickTitle.ZIndex = 5
QuickTitle.Parent = QuickCard

local function CreateQuickButton(order, name, iconId, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -16, 0, 34)
    btn.Position = UDim2.new(0, 8, 0, 34 + (order - 1) * 38)
    btn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    btn.BackgroundTransparency = 0.6
    btn.BorderSizePixel = 0
    btn.AutoButtonColor = false
    btn.Text = ""
    btn.ZIndex = 5
    btn.Parent = QuickCard

    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(0, 6)
    BC.Parent = btn

    local BI = Instance.new("ImageLabel")
    BI.Size = UDim2.new(0, 16, 0, 16)
    BI.Position = UDim2.new(0, 10, 0.5, -8)
    BI.BackgroundTransparency = 1
    BI.Image = iconId
    BI.ImageColor3 = Theme.TextMuted
    BI.ZIndex = 6
    BI.Parent = btn

    local BT = Instance.new("TextLabel")
    BT.Size = UDim2.new(1, -48, 1, 0)
    BT.Position = UDim2.new(0, 32, 0, 0)
    BT.BackgroundTransparency = 1
    BT.Font = Enum.Font.GothamMedium
    BT.Text = name
    BT.TextColor3 = Theme.TextWhite
    BT.TextSize = 11
    BT.TextXAlignment = Enum.TextXAlignment.Left
    BT.ZIndex = 6
    BT.Parent = btn

    local BA = Instance.new("ImageLabel")
    BA.Size = UDim2.new(0, 12, 0, 12)
    BA.Position = UDim2.new(1, -18, 0.5, -6)
    BA.BackgroundTransparency = 1
    BA.Image = "rbxassetid://6034384749"
    BA.ImageColor3 = Theme.TextDark
    BA.ZIndex = 6
    BA.Parent = btn

    btn.MouseEnter:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundTransparency = 0.2, BackgroundColor3 = Theme.CardHover }):Play()
        TweenService:Create(BI, TweenInfo.new(0.2), { ImageColor3 = Theme.Primary }):Play()
        TweenService:Create(BA, TweenInfo.new(0.2), { ImageColor3 = Theme.TextWhite }):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(btn, TweenInfo.new(0.2), { BackgroundTransparency = 0.6, BackgroundColor3 = Color3.fromRGB(20, 20, 24) }):Play()
        TweenService:Create(BI, TweenInfo.new(0.2), { ImageColor3 = Theme.TextMuted }):Play()
        TweenService:Create(BA, TweenInfo.new(0.2), { ImageColor3 = Theme.TextDark }):Play()
    end)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

CreateQuickButton(1, "Discord Server", "rbxassetid://6031075938", function()
    if typeof(setclipboard) == "function" then
        setclipboard(Config.DiscordLink)
        ShowNotification("Discord Link Copied", "Pasted to your clipboard!", true)
    else
        ShowNotification("Discord Server", Config.DiscordLink, true)
    end
end)

CreateQuickButton(2, "Rejoin Server", "rbxassetid://6031094687", function()
    ShowNotification("Teleporting...", "Rejoining server instance", true)
    task.delay(0.5, function()
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end)
end)

-- HOME VIEW
local CenterContent = Instance.new("Frame")
CenterContent.Size = UDim2.new(1, -450, 1, -75)
CenterContent.Position = UDim2.new(0, 225, 0, 65)
CenterContent.BackgroundTransparency = 1
CenterContent.ZIndex = 3
CenterContent.Parent = MainFrame

local HeaderArea = Instance.new("Frame")
HeaderArea.Size = UDim2.new(1, 0, 0, 48)
HeaderArea.BackgroundTransparency = 1
HeaderArea.ZIndex = 3
HeaderArea.Parent = CenterContent

local MainTitle = Instance.new("TextLabel")
MainTitle.Size = UDim2.new(1, 0, 0, 24)
MainTitle.BackgroundTransparency = 1
MainTitle.Font = Enum.Font.GothamBlack
MainTitle.Text = "Supported Games"
MainTitle.TextColor3 = Theme.TextWhite
MainTitle.TextSize = 20
MainTitle.TextXAlignment = Enum.TextXAlignment.Left
MainTitle.ZIndex = 4
MainTitle.Parent = HeaderArea

local MainSubtitle = Instance.new("TextLabel")
MainSubtitle.Size = UDim2.new(1, 0, 0, 18)
MainSubtitle.Position = UDim2.new(0, 0, 0, 24)
MainSubtitle.BackgroundTransparency = 1
MainSubtitle.Font = Enum.Font.Gotham
MainSubtitle.Text = "Games that we support are listed below. Have fun :)"
MainSubtitle.TextColor3 = Theme.TextMuted
MainSubtitle.TextSize = 12
MainSubtitle.TextXAlignment = Enum.TextXAlignment.Left
MainSubtitle.ZIndex = 4
MainSubtitle.Parent = HeaderArea

local GamesScroll = Instance.new("ScrollingFrame")
GamesScroll.Size = UDim2.new(1, 0, 1, -56)
GamesScroll.Position = UDim2.new(0, 0, 0, 52)
GamesScroll.BackgroundTransparency = 1
GamesScroll.BorderSizePixel = 0
GamesScroll.ScrollBarThickness = 3
GamesScroll.ScrollBarImageColor3 = Theme.Border
GamesScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
GamesScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
GamesScroll.ClipsDescendants = true
GamesScroll.ZIndex = 3
GamesScroll.Parent = CenterContent

local GamesLayout = Instance.new("UIListLayout")
GamesLayout.SortOrder = Enum.SortOrder.LayoutOrder
GamesLayout.Padding = UDim.new(0, 10)
GamesLayout.Parent = GamesScroll

local ScrollPadding = Instance.new("UIPadding")
ScrollPadding.PaddingRight = UDim.new(0, 8)
ScrollPadding.PaddingBottom = UDim.new(0, 16)
ScrollPadding.Parent = GamesScroll

-- PREMIUM VIEW
local PremiumView = Instance.new("Frame")
PremiumView.Size = UDim2.new(1, -450, 1, -75)
PremiumView.Position = UDim2.new(0, 225, 0, 65)
PremiumView.BackgroundTransparency = 1
PremiumView.Visible = false
PremiumView.ZIndex = 3
PremiumView.Parent = MainFrame

local PremiumHeaderArea = Instance.new("Frame")
PremiumHeaderArea.Size = UDim2.new(1, 0, 0, 48)
PremiumHeaderArea.BackgroundTransparency = 1
PremiumHeaderArea.ZIndex = 3
PremiumHeaderArea.Parent = PremiumView

local PremiumMainTitle = Instance.new("TextLabel")
PremiumMainTitle.Size = UDim2.new(1, 0, 0, 24)
PremiumMainTitle.BackgroundTransparency = 1
PremiumMainTitle.Font = Enum.Font.GothamBlack
PremiumMainTitle.Text = "Premium Scripts"
PremiumMainTitle.TextColor3 = Theme.PremiumSoft
PremiumMainTitle.TextSize = 20
PremiumMainTitle.TextXAlignment = Enum.TextXAlignment.Left
PremiumMainTitle.ZIndex = 4
PremiumMainTitle.Parent = PremiumHeaderArea

local PremiumMainSubtitle = Instance.new("TextLabel")
PremiumMainSubtitle.Size = UDim2.new(1, 0, 0, 18)
PremiumMainSubtitle.Position = UDim2.new(0, 0, 0, 24)
PremiumMainSubtitle.BackgroundTransparency = 1
PremiumMainSubtitle.Font = Enum.Font.Gotham
PremiumMainSubtitle.Text = "Exclusive premium scripts — requires the Premium Discord role."
PremiumMainSubtitle.TextColor3 = Theme.TextMuted
PremiumMainSubtitle.TextSize = 12
PremiumMainSubtitle.TextXAlignment = Enum.TextXAlignment.Left
PremiumMainSubtitle.ZIndex = 4
PremiumMainSubtitle.Parent = PremiumHeaderArea

local PremiumScroll = Instance.new("ScrollingFrame")
PremiumScroll.Size = UDim2.new(1, 0, 1, -56)
PremiumScroll.Position = UDim2.new(0, 0, 0, 52)
PremiumScroll.BackgroundTransparency = 1
PremiumScroll.BorderSizePixel = 0
PremiumScroll.ScrollBarThickness = 3
PremiumScroll.ScrollBarImageColor3 = Theme.Border
PremiumScroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
PremiumScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
PremiumScroll.ClipsDescendants = true
PremiumScroll.ZIndex = 3
PremiumScroll.Parent = PremiumView

local PremiumLayout = Instance.new("UIListLayout")
PremiumLayout.SortOrder = Enum.SortOrder.LayoutOrder
PremiumLayout.Padding = UDim.new(0, 10)
PremiumLayout.Parent = PremiumScroll

local PremiumScrollPadding = Instance.new("UIPadding")
PremiumScrollPadding.PaddingRight = UDim.new(0, 8)
PremiumScrollPadding.PaddingBottom = UDim.new(0, 16)
PremiumScrollPadding.Parent = PremiumScroll

-- CARD CREATION
local GameCards = {}
local PremiumCards = {}

local function CreateGameCard(gameData, index, parentScroll, cardsList, isPremium)
    local isComingSoon = gameData.ComingSoon == true

    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, 0, 0, 64)
    Card.BackgroundColor3 = Theme.CardBg
    Card.BorderSizePixel = 0
    Card.LayoutOrder = index
    Card.ZIndex = 4
    Card.Parent = parentScroll

    local CC = Instance.new("UICorner")
    CC.CornerRadius = UDim.new(0, 10)
    CC.Parent = Card

    local CS = Instance.new("UIStroke")
    CS.Color = isPremium and Color3.fromRGB(55, 35, 70) or Theme.BorderSoft
    CS.Thickness = 1
    CS.Parent = Card

    local InfoFrame = Instance.new("Frame")
    InfoFrame.Size = UDim2.new(1, -125, 1, 0)
    InfoFrame.Position = UDim2.new(0, 16, 0, 0)
    InfoFrame.BackgroundTransparency = 1
    InfoFrame.ZIndex = 5
    InfoFrame.Parent = Card

    local Badge = Instance.new("Frame")
    Badge.Size = UDim2.fromOffset(isPremium and 62 or 40, 15)
    Badge.Position = UDim2.new(1, isPremium and -62 or -40, 0.5, -22)
    Badge.BackgroundColor3 = isPremium and Theme.Premium or Theme.Free
    Badge.BackgroundTransparency = 0.25
    Badge.BorderSizePixel = 0
    Badge.ZIndex = 6
    Badge.Parent = InfoFrame

    local BC = Instance.new("UICorner")
    BC.CornerRadius = UDim.new(1, 0)
    BC.Parent = Badge

    local BL = Instance.new("TextLabel")
    BL.Size = UDim2.fromScale(1, 1)
    BL.BackgroundTransparency = 1
    BL.Font = Enum.Font.GothamBold
    BL.Text = isPremium and "PREMIUM" or "FREE"
    BL.TextColor3 = isPremium and Color3.fromRGB(245, 220, 255) or Color3.fromRGB(215, 255, 230)
    BL.TextSize = 9
    BL.ZIndex = 7
    BL.Parent = Badge

    local TL = Instance.new("TextLabel")
    TL.Size = UDim2.new(1, isPremium and -70 or -48, 0, 20)
    TL.Position = UDim2.new(0, 0, 0.5, -18)
    TL.BackgroundTransparency = 1
    TL.Font = Enum.Font.GothamBold
    TL.Text = gameData.Name
    TL.TextColor3 = Theme.TextWhite
    TL.TextSize = 14
    TL.TextXAlignment = Enum.TextXAlignment.Left
    TL.TextTruncate = Enum.TextTruncate.AtEnd
    TL.ZIndex = 5
    TL.Parent = InfoFrame

    local DL = Instance.new("TextLabel")
    DL.Size = UDim2.new(1, 0, 0, 16)
    DL.Position = UDim2.new(0, 0, 0.5, 2)
    DL.BackgroundTransparency = 1
    DL.Font = Enum.Font.Gotham
    DL.Text = gameData.Description
    DL.TextColor3 = Theme.TextMuted
    DL.TextSize = 11
    DL.TextXAlignment = Enum.TextXAlignment.Left
    DL.TextTruncate = Enum.TextTruncate.AtEnd
    DL.ZIndex = 5
    DL.Parent = InfoFrame

    if isComingSoon then
        local ComingSoonFrame = Instance.new("Frame")
        ComingSoonFrame.Size = UDim2.new(0, 92, 0, 36)
        ComingSoonFrame.Position = UDim2.new(1, -104, 0.5, -18)
        ComingSoonFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        ComingSoonFrame.BackgroundTransparency = 0.4
        ComingSoonFrame.BorderSizePixel = 0
        ComingSoonFrame.ZIndex = 5
        ComingSoonFrame.Parent = Card

        local CSC = Instance.new("UICorner")
        CSC.CornerRadius = UDim.new(0, 8)
        CSC.Parent = ComingSoonFrame

        local CSS = Instance.new("UIStroke")
        CSS.Color = Color3.fromRGB(38, 38, 48)
        CSS.Thickness = 1
        CSS.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        CSS.Parent = ComingSoonFrame

        local CSL = Instance.new("TextLabel")
        CSL.Size = UDim2.fromScale(1, 1)
        CSL.BackgroundTransparency = 1
        CSL.Font = Enum.Font.GothamBold
        CSL.Text = "Coming Soon"
        CSL.TextColor3 = Theme.TextMuted
        CSL.TextSize = 11
        CSL.ZIndex = 6
        CSL.Parent = ComingSoonFrame
    else
        local LoadBtn = Instance.new("TextButton")
        LoadBtn.Size = UDim2.new(0, 92, 0, 36)
        LoadBtn.Position = UDim2.new(1, -104, 0.5, -18)
        LoadBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 29)
        LoadBtn.BorderSizePixel = 0
        LoadBtn.AutoButtonColor = false
        LoadBtn.Text = "Execute"
        LoadBtn.Font = Enum.Font.GothamBold
        LoadBtn.TextColor3 = Color3.fromRGB(215, 215, 225)
        LoadBtn.TextSize = 12
        LoadBtn.ZIndex = 5
        LoadBtn.Parent = Card

        local LC = Instance.new("UICorner")
        LC.CornerRadius = UDim.new(0, 8)
        LC.Parent = LoadBtn

        local LS = Instance.new("UIStroke")
        LS.Color = isPremium and Color3.fromRGB(60, 40, 80) or Color3.fromRGB(38, 38, 48)
        LS.Thickness = 1
        LS.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        LS.Parent = LoadBtn

        local hasExecuted = false

        LoadBtn.MouseEnter:Connect(function()
            if not hasExecuted then
                TweenService:Create(LoadBtn, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(28, 28, 34),
                    TextColor3 = isPremium and Theme.PremiumSoft or Theme.Primary
                }):Play()
                TweenService:Create(LS, TweenInfo.new(0.2), { Color = Color3.fromRGB(45, 45, 58) }):Play()
            end
        end)
        LoadBtn.MouseLeave:Connect(function()
            if not hasExecuted then
                TweenService:Create(LoadBtn, TweenInfo.new(0.2), {
                    BackgroundColor3 = Color3.fromRGB(24, 24, 29),
                    TextColor3 = Color3.fromRGB(215, 215, 225)
                }):Play()
                TweenService:Create(LS, TweenInfo.new(0.2), {
                    Color = isPremium and Color3.fromRGB(60, 40, 80) or Color3.fromRGB(38, 38, 48)
                }):Play()
            end
        end)

        LoadBtn.MouseButton1Click:Connect(function()
            if hasExecuted then return end

            if isPremium and not HAS_PREMIUM_ROLE then
                ShowPremiumRequiredDialog()
                return
            end

            hasExecuted = true
            LoadBtn.Text = "Loading..."

            pcall(function()
                logScriptExecution(gameData.Name, isPremium)
            end)

            LoadingOverlay.Visible = true
            LoadingTitle.Text = "Starting script..."
            LoadingStatus.Text = "Starting script..."
            LoadingStatus.TextColor3 = Theme.TextMuted
            LoadingFill.Size = UDim2.new(0.25, 0, 1, 0)
            LoadingFill.BackgroundColor3 = isPremium and Theme.Premium or Theme.Primary
            TweenService:Create(LoadBtn, TweenInfo.new(0.2), { TextColor3 = Theme.TextMuted }):Play()

            task.spawn(function()
                task.wait(0.2)
                LoadingTitle.Text = "Injecting script..."
                local success, err = pcall(function()
                    LoadingStatus.Text = "Injecting script..."
                    local pt = TweenService:Create(LoadingFill, TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        Size = UDim2.new(0.75, 0, 1, 0)
                    })
                    pt:Play()
                    task.wait(0.2)

                    local finalScript = gameData.Script
                    if isPremium and typeof(finalScript) == "string" then
                        finalScript = injectLicenseIntoScript(finalScript)
                    end

                    if typeof(finalScript) == "string" then
                        local fn, loadErr = loadstring(finalScript)
                        if fn then fn() else error(loadErr or "Failed to compile loadstring") end
                    elseif typeof(finalScript) == "function" then
                        finalScript()
                    end
                end)

                task.wait(0.3)

                if success then
                    LoadBtn.Text = "Loaded"
                    LoadingStatus.Text = "Successful!"
                    LoadingStatus.TextColor3 = Theme.Success
                    TweenService:Create(LoadingFill, TweenInfo.new(0.2), {
                        Size = UDim2.new(1, 0, 1, 0),
                        BackgroundColor3 = Theme.Success
                    }):Play()
                    TweenService:Create(LoadBtn, TweenInfo.new(0.2), { TextColor3 = Theme.Success }):Play()
                    ShowNotification("Script Loaded", gameData.Name .. " loaded!", true)
                    task.wait(0.6)
                    CloseGuiAnimated()
                else
                    LoadBtn.Text = "Failed"
                    LoadingTitle.Text = "Execution failed"
                    LoadingStatus.Text = tostring(err)
                    LoadingStatus.TextColor3 = Theme.Danger
                    LoadingFill.BackgroundColor3 = Theme.Danger
                    TweenService:Create(LoadBtn, TweenInfo.new(0.2), { TextColor3 = Theme.Danger }):Play()
                    ShowNotification("Error Loading", tostring(err), false)
                end
            end)
        end)
    end

    table.insert(cardsList, {
        Frame = Card,
        Name = string.lower(gameData.Name),
        Desc = string.lower(gameData.Description)
    })
end

for i, g in ipairs(SupportedGames) do
    CreateGameCard(g, i, GamesScroll, GameCards, false)
end
for i, g in ipairs(PremiumGames) do
    CreateGameCard(g, i, PremiumScroll, PremiumCards, true)
end

local function applySearchFilter()
    local query = string.lower(SearchInput.Text or "")
    local list = (activeTab == "Premium") and PremiumCards or GameCards
    for _, cd in ipairs(list) do
        if query == "" or string.find(cd.Name, query, 1, true) or string.find(cd.Desc, query, 1, true) then
            cd.Frame.Visible = true
        else
            cd.Frame.Visible = false
        end
    end
end

SearchInput:GetPropertyChangedSignal("Text"):Connect(applySearchFilter)

-- CREDITS VIEW
local CreditsView = Instance.new("Frame")
CreditsView.Size = CenterContent.Size
CreditsView.Position = CenterContent.Position
CreditsView.BackgroundTransparency = 1
CreditsView.Visible = false
CreditsView.ZIndex = 3
CreditsView.Parent = MainFrame

local CreditsHead = Instance.new("TextLabel")
CreditsHead.Size = UDim2.new(1, 0, 0, 24)
CreditsHead.BackgroundTransparency = 1
CreditsHead.Font = Enum.Font.GothamBlack
CreditsHead.Text = "Credits & Info"
CreditsHead.TextColor3 = Theme.TextWhite
CreditsHead.TextSize = 20
CreditsHead.TextXAlignment = Enum.TextXAlignment.Left
CreditsHead.ZIndex = 4
CreditsHead.Parent = CreditsView

local CreditsBody = Instance.new("TextLabel")
CreditsBody.Size = UDim2.new(1, 0, 0, 24)
CreditsBody.Position = UDim2.new(0, 0, 0, 36)
CreditsBody.BackgroundTransparency = 1
CreditsBody.Font = Enum.Font.GothamMedium
CreditsBody.Text = "Toolbox Loader team"
CreditsBody.TextColor3 = Theme.TextMuted
CreditsBody.TextSize = 13
CreditsBody.TextXAlignment = Enum.TextXAlignment.Left
CreditsBody.ZIndex = 4
CreditsBody.Parent = CreditsView

local OwnerCredit = Instance.new("TextLabel")
OwnerCredit.Size = UDim2.new(1, 0, 0, 24)
OwnerCredit.Position = UDim2.new(0, 0, 0, 64)
OwnerCredit.BackgroundTransparency = 1
OwnerCredit.Font = Enum.Font.GothamBold
OwnerCredit.Text = "Owner: Abdullah"
OwnerCredit.TextColor3 = Color3.fromRGB(255, 255, 255)
OwnerCredit.TextSize = 14
OwnerCredit.TextXAlignment = Enum.TextXAlignment.Left
OwnerCredit.ZIndex = 4
OwnerCredit.Parent = CreditsView

local CoOwnerCredit = Instance.new("TextLabel")
CoOwnerCredit.Size = UDim2.new(1, 0, 0, 24)
CoOwnerCredit.Position = UDim2.new(0, 0, 0, 92)
CoOwnerCredit.BackgroundTransparency = 1
CoOwnerCredit.Font = Enum.Font.GothamBold
CoOwnerCredit.Text = "Co-owner: Homelander"
CoOwnerCredit.TextColor3 = Theme.TextWhite
CoOwnerCredit.TextSize = 14
CoOwnerCredit.TextXAlignment = Enum.TextXAlignment.Left
CoOwnerCredit.ZIndex = 4
CoOwnerCredit.Parent = CreditsView

local CreatorCredit = Instance.new("TextLabel")
CreatorCredit.Size = UDim2.new(1, 0, 0, 24)
CreatorCredit.Position = UDim2.new(0, 0, 0, 120)
CreatorCredit.BackgroundTransparency = 1
CreatorCredit.Font = Enum.Font.GothamBold
CreatorCredit.Text = "Made by: Japan"
CreatorCredit.TextColor3 = Color3.fromRGB(255, 255, 255)
CreatorCredit.TextSize = 14
CreatorCredit.TextXAlignment = Enum.TextXAlignment.Left
CreatorCredit.ZIndex = 4
CreatorCredit.Parent = CreditsView

local CatCard = Instance.new("Frame")
CatCard.Size = UDim2.new(0, 340, 0, 115)
CatCard.Position = UDim2.new(0, 0, 0, 158)
CatCard.BackgroundColor3 = Theme.CardBg
CatCard.BorderSizePixel = 0
CatCard.ZIndex = 4
CatCard.Parent = CreditsView

local CatCorner = Instance.new("UICorner")
CatCorner.CornerRadius = UDim.new(0, 10)
CatCorner.Parent = CatCard

local CatStroke = Instance.new("UIStroke")
CatStroke.Color = Theme.BorderSoft
CatStroke.Thickness = 1
CatStroke.Parent = CatCard

local CatLabel = Instance.new("TextLabel")
CatLabel.Size = UDim2.new(1, -20, 1, -16)
CatLabel.Position = UDim2.new(0, 10, 0, 8)
CatLabel.BackgroundTransparency = 1
CatLabel.Font = Enum.Font.Code
CatLabel.Text = table.concat({
    " (\"`-''-/\" ).___.." .. string.char(45, 45) .. "''\"`-._",
    " `6_ 6  )   `-.  (     ).`-.__.`)",
    " (_Y_.)'  ._   )  `._ `. ``" .. string.char(45, 45) .. "..-'",
    "   _..`" .. string.char(45, 45) .. "'_..-_/  /" .. string.char(45, 45) .. "'_.'",
    "  ((((." .. string.char(45, 45) .. "''  ((((.'  (((.-'"
}, "\n")
CatLabel.TextColor3 = Theme.PrimaryHover
CatLabel.TextSize = 12
CatLabel.TextXAlignment = Enum.TextXAlignment.Left
CatLabel.TextYAlignment = Enum.TextYAlignment.Center
CatLabel.ZIndex = 5
CatLabel.Parent = CatCard

-- TAB SWITCHING
HomeTab.MouseButton1Click:Connect(function()
    if activeTab == "Home" then return end
    activeTab = "Home"
    CenterContent.Visible = true
    PremiumView.Visible = false
    CreditsView.Visible = false
    RightPanel.Visible = true
    TweenService:Create(HomeTab, TweenInfo.new(0.2), { BackgroundColor3 = Theme.TabActive, BackgroundTransparency = 0 }):Play()
    TweenService:Create(HomeTabStroke, TweenInfo.new(0.2), { Transparency = 0 }):Play()
    HomeLabel.TextColor3 = Theme.TextWhite
    HomeIcon.ImageColor3 = Theme.Primary
    TweenService:Create(PremiumTab, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(PremiumTabStroke, TweenInfo.new(0.2), { Transparency = 1 }):Play()
    PremiumLabel.TextColor3 = Theme.TextMuted
    PremiumIcon.ImageColor3 = Theme.TextMuted
    TweenService:Create(CreditsTab, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(CreditsTabStroke, TweenInfo.new(0.2), { Transparency = 1 }):Play()
    CreditsLabel.TextColor3 = Theme.TextMuted
    CreditsIcon.ImageColor3 = Theme.TextMuted
    applySearchFilter()
end)

PremiumTab.MouseButton1Click:Connect(function()
    if activeTab == "Premium" then return end
    activeTab = "Premium"
    CenterContent.Visible = false
    PremiumView.Visible = true
    CreditsView.Visible = false
    RightPanel.Visible = true
    TweenService:Create(PremiumTab, TweenInfo.new(0.2), { BackgroundColor3 = Theme.TabActive, BackgroundTransparency = 0 }):Play()
    TweenService:Create(PremiumTabStroke, TweenInfo.new(0.2), { Transparency = 0 }):Play()
    PremiumLabel.TextColor3 = Theme.TextWhite
    PremiumIcon.ImageColor3 = Theme.PremiumSoft
    TweenService:Create(HomeTab, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(HomeTabStroke, TweenInfo.new(0.2), { Transparency = 1 }):Play()
    HomeLabel.TextColor3 = Theme.TextMuted
    HomeIcon.ImageColor3 = Theme.TextMuted
    TweenService:Create(CreditsTab, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(CreditsTabStroke, TweenInfo.new(0.2), { Transparency = 1 }):Play()
    CreditsLabel.TextColor3 = Theme.TextMuted
    CreditsIcon.ImageColor3 = Theme.TextMuted
    applySearchFilter()
end)

CreditsTab.MouseButton1Click:Connect(function()
    if activeTab == "Credits" then return end
    activeTab = "Credits"
    CenterContent.Visible = false
    PremiumView.Visible = false
    CreditsView.Visible = true
    RightPanel.Visible = false
    TweenService:Create(CreditsTab, TweenInfo.new(0.2), { BackgroundColor3 = Theme.TabActive, BackgroundTransparency = 0 }):Play()
    TweenService:Create(CreditsTabStroke, TweenInfo.new(0.2), { Transparency = 0 }):Play()
    CreditsLabel.TextColor3 = Theme.TextWhite
    CreditsIcon.ImageColor3 = Theme.Primary
    TweenService:Create(HomeTab, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(HomeTabStroke, TweenInfo.new(0.2), { Transparency = 1 }):Play()
    HomeLabel.TextColor3 = Theme.TextMuted
    HomeIcon.ImageColor3 = Theme.TextMuted
    TweenService:Create(PremiumTab, TweenInfo.new(0.2), { BackgroundTransparency = 1 }):Play()
    TweenService:Create(PremiumTabStroke, TweenInfo.new(0.2), { Transparency = 1 }):Play()
    PremiumLabel.TextColor3 = Theme.TextMuted
    PremiumIcon.ImageColor3 = Theme.TextMuted
end)

-- DRAG
local dragging, dragInput, dragStart, startPos, dragTween

local function updateDrag(input)
    local delta = input.Position - dragStart
    local target = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    if dragTween then dragTween:Cancel() end
    dragTween = TweenService:Create(MainFrame, TweenInfo.new(0.08, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), { Position = target })
    dragTween:Play()
end

MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        local pos = input.Position
        local tbP, tbS = TopBar.AbsolutePosition, TopBar.AbsoluteSize
        local sbP = Sidebar.AbsolutePosition
        local bS = BrandFrame.AbsoluteSize
        local inTopBar = (pos.X >= tbP.X and pos.X <= tbP.X + tbS.X and pos.Y >= tbP.Y and pos.Y <= tbP.Y + tbS.Y)
        local inBrand = (pos.X >= sbP.X and pos.X <= sbP.X + Sidebar.AbsoluteSize.X and pos.Y >= sbP.Y and pos.Y <= sbP.Y + bS.Y)
        if inTopBar or inBrand then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then updateDrag(input) end
end)

-- MINIMIZE
local isMinimized = false
local originalSize = MainFrame.Size

MinimizeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    local offsetDelta = ((530 - 75) / 2) * MainScale.Scale
    if isMinimized then
        CenterContent.Visible = false
        PremiumView.Visible = false
        RightPanel.Visible = false
        CreditsView.Visible = false
        NavContainer.Visible = false
        ProfileCard.Visible = false
        SearchBoxContainer.Visible = false
        TierBadge.Visible = false
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = UDim2.new(0, 880, 0, 75),
            Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset - offsetDelta)
        }):Play()
        MinimizeBtn.Text = "＋"
    else
        local tw = TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = originalSize,
            Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset + offsetDelta)
        })
        tw:Play()
        tw.Completed:Connect(function()
            if not isMinimized then
                CenterContent.Visible = (activeTab == "Home")
                PremiumView.Visible = (activeTab == "Premium")
                RightPanel.Visible = (activeTab ~= "Credits")
                NavContainer.Visible = true
                ProfileCard.Visible = true
                SearchBoxContainer.Visible = true
                TierBadge.Visible = true
            end
        end)
        MinimizeBtn.Text = "—"
    end
end)

MainFrame.Position = UDim2.new(0.5, 0, 0.5, 35)
MainFrame.BackgroundTransparency = 0.5
DarkOverlay.BackgroundTransparency = 1

TweenService:Create(DarkOverlay, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = 0.5 }):Play()
TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
    Position = UDim2.new(0.5, 0, 0.5, 0),
    BackgroundTransparency = 0
}):Play()

-- WELCOME
local welcome_name = nil

if type(_G.TB_DISCORD_USERNAME) == "string" and _G.TB_DISCORD_USERNAME ~= "" then
    welcome_name = _G.TB_DISCORD_USERNAME
elseif IS_LICENSED and LICENSE_INFO and LICENSE_INFO.discord_username then
    welcome_name = LICENSE_INFO.discord_username
end

if welcome_name then
    showWelcomeAlert(welcome_name)
else
    ShowNotification("Toolbox Loader", "Welcome, " .. LocalPlayer.DisplayName .. "!", true)
end

return ScreenGui
