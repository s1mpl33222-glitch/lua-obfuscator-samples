--[[
    Synapse X Celestial Hub
    Cyan / Purple / Black theme
    GUI backgrounds removed, steal bar restyled, overhead speed only
    Mobile buttons: cyan outline + S X C
]]

TweenService = game:GetService("TweenService")
RunService = game:GetService("RunService")
Players = game:GetService("Players")
UserInputService = game:GetService("UserInputService")
HttpService = game:GetService("HttpService")
Lighting = game:GetService("Lighting")
Workspace = game:GetService("Workspace")

player = Players.LocalPlayer
LP = player
playerGui = player:WaitForChild("PlayerGui")

COLORS = {
    Background = Color3.fromRGB(0, 0, 0),
    Row = Color3.fromRGB(0, 0, 0),
    RowDark = Color3.fromRGB(0, 0, 0),
    Badge = Color3.fromRGB(0, 0, 0),
    TabBar = Color3.fromRGB(0, 0, 0),
    TabActive = Color3.fromRGB(0, 220, 255),
    ToggleActive = Color3.fromRGB(0, 220, 255),
    White = Color3.fromRGB(255, 255, 255),
    PurpleText = Color3.fromRGB(140, 60, 220),
    TextDim = Color3.fromRGB(0, 220, 255),
    Stroke = Color3.fromRGB(0, 220, 255),
    Accent = Color3.fromRGB(0, 220, 255),
    AccentSoft = Color3.fromRGB(80, 40, 160),
    Success = Color3.fromRGB(0, 220, 255),
    Red = Color3.fromRGB(0, 220, 255),
    Blue = Color3.fromRGB(0, 220, 255),
    Purple = Color3.fromRGB(80, 40, 160),
}

State = {
    autoLeftEnabled = false,
    autoRightEnabled = false,
    autoBatToggled = false,
    bypassAimbotToggled = false,
    hittingCooldown = false,
}

dropActive = false
mobBtnRefs = {}


carrySpeedEnabled = false
laggerModeEnabled = false
laggerSpeedEnabled = false
laggerCarryEnabled = false
autoCarryBoost = false

Config = {
    NormalSpeed = 59,
    CarrySpeed = 29,
    AutoCarrySpeed = false,
    AutoCarryRadius = 10, -- studs from enemy podium that triggers Carry Speed
    CarrySpeedKey = "C",
    LaggerSpeed = 40,
    LaggerCarry = 20,
    LaggerSpeedKey = "X",
    LaggerCarryKey = "X",
    TPDownKey = "E",
    DropKey = "F",
    InstaResetKey = "G",
    TPDownGamepadKey = "ButtonY",
    DropGamepadKey = "ButtonX",
    InstaResetGamepadKey = "ButtonB",
    TPDownDistance = 10,
    AutoTPDown = false,
    TPDownHeight = 20,
    AutoLeft = false,
    AutoLeftKey = "A",
    AutoRight = false,
    AutoRightKey = "D",
    AutoPlayMode = "1 Btn",
    AutoPlayKey = "P",
    InfiniteJump = false,
    InfJumpMode = "Hold",
    AntiRagdoll = false,
    AntiRagdollMode = "V1",
    BatCounter = false,
    MedusaCounter = false,
    AntiDie = false,
    Spin = false,
    SafeMode = false,
    UIScale = 30,
    LockUI = false,
    HideUI = false,
    HideUIKey = "RightControl",
    MobileButtonSize = 50,
    StealBarSize = 40,
    UIBackgroundIndex = 1,
    ButtonsGuiTheme = "Cyan",
    CircleButtons = false,
    HideButtons = false,
    IntroEnabled = true,
    IntroMusicUrl = "https://files.catbox.moe/sdfi1j.mp3",
    UIBackgroundUrl = "https://files.catbox.moe/sz7icy.png",
    PlayerESP = false,
    PlayerTracers = false,
    RagdollCountdown = false,
    BrainrotTransparencyBase = false,
    BrainrotTransparencyHeld = false,
    CustomSky = false,
    CustomSkyTheme = "Night",
    CustomAnim = false,
    Unwalk = false,
    AnimPack = "Bubbly",
    BatSkin = "Katana",
    Headless = false,
    Korblox = false,
    AntiLag = false,
    StretchRes = false,
    FOVChange = false,
    FOVValue = 70,
    BatAimbot = false,
    BatAimbotKey = "H",
    AimbotSpeed = 55,
    BypassAimbot = false,
    AutoSwing = true,
    AutoBrainrot = false,
    MirrorTPDown = false,
    NoCamCollision = true,
    AutoSteal = false,
    AutoStealMode = "Normal",
    AutoStealVersion = "V1",
    AutoStealStopAt = 75,
    AutoStealStopWhenHit = false,
    AutoStealHitPauseSeconds = 1.3,
    AutoStealRadius = 61,
    AutoStealRadiusNormal = 61,
    AutoStealRadiusSemi = 9,
    StealBarPosX = nil,
    StealBarPosY = nil,
}

CONFIG_FILE = "CelestialCC2_Config.json"

function saveConfig()
    pcall(function()
        if writefile then
            writefile(CONFIG_FILE, HttpService:JSONEncode(Config))
        end
    end)
end

function loadConfig()
if Config.AutoPlayMode == "Semi" then Config.AutoPlayMode = "1 Btn" end


Config.UIBackgroundUrl = ""
    pcall(function()
        if readfile and isfile and isfile(CONFIG_FILE) then
            local data = HttpService:JSONDecode(readfile(CONFIG_FILE))
            for k, v in pairs(data) do
                if Config[k] ~= nil then
                    Config[k] = v
                end
            end
        end
    end)
end

loadConfig()

-- Lock UI persists from saved config (do not force off on every inject)
_G.CelestialUILocked = Config.LockUI == true

Config.UIBackgroundUrl = ""


DEFAULT_KEYS = {
    CarrySpeedKey="C",
    LaggerCarryKey="X",
    TPDownKey="E",
    DropKey="F",
    InstaResetKey="G",
    TPDownGamepadKey="ButtonY",
    DropGamepadKey="ButtonX",
    InstaResetGamepadKey="ButtonB",
    AutoLeftKey="A",
    AutoRightKey="D",
    AutoPlayKey="P",
    BatAimbotKey="H",
    HideUIKey="RightControl",
}
for k, v in pairs(DEFAULT_KEYS) do
    if type(Config[k]) ~= "string" or Config[k] == "" then Config[k] = v end
end
Config.NoCamCollision = true
if Config.ButtonsGuiTheme ~= "Cyan" and Config.ButtonsGuiTheme ~= "Purple" then Config.ButtonsGuiTheme = "Cyan" end
State.autoBatToggled = Config.BatAimbot

function corner(parent, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius)
    c.Parent = parent
    return c
end

function celestialAccentColor()
    return _G.CelestialThemeAccent or COLORS.Stroke or COLORS.Accent or Color3.fromRGB(0, 220, 255)
end

function celestialSoftColor()
    return _G.CelestialThemeSoft or COLORS.AccentSoft or COLORS.Purple or Color3.fromRGB(80, 40, 160)
end

function celestialIsAccentTone(color)
    if typeof(color) ~= "Color3" then return false end
    if color == COLORS.Stroke or color == COLORS.Accent or color == COLORS.ToggleActive
        or color == COLORS.TabActive or color == COLORS.Success or color == COLORS.Red
        or color == COLORS.Blue or color == _G.CelestialThemeAccent or color == _G.CelestialThemeSoft
        or color == COLORS.AccentSoft or color == COLORS.Purple then
        return true
    end
    local r, g, b = color.R * 255, color.G * 255, color.B * 255
    return r >= 95 and r > g * 1.22 and g >= b * 1.18 and b <= 115 and g <= 190
end

function stroke(parent, thickness, color, transparency)
    local s = Instance.new("UIStroke")
    s.Thickness = thickness or 1
    local requestedColor = color or COLORS.Stroke
    local isThemeAccent = celestialIsAccentTone(requestedColor)
    s.Color = isThemeAccent and celestialAccentColor() or requestedColor
    if isThemeAccent then
        s:SetAttribute("CelestialHubThemeAccentStroke", true)
    end
    s.Transparency = transparency or 0
    s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    s.Parent = parent
    return s
end

function padding(parent, l, r, t, b)
    local p = Instance.new("UIPadding")
    p.PaddingLeft = UDim.new(0, l)
    p.PaddingRight = UDim.new(0, r)
    p.PaddingTop = UDim.new(0, t)
    p.PaddingBottom = UDim.new(0, b)
    p.Parent = parent
    return p
end

screenGui = Instance.new("ScreenGui")
screenGui.Name = "CelestialHubUI"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- Lock UI state already loaded from config above
main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 340, 0, 545)
main.AnchorPoint = Vector2.new(0.5, 0.5)
main.Position = UDim2.new(0.143, 0, 0.436, 0)
main.BackgroundColor3 = COLORS.Background
main.BackgroundTransparency = 1
main.BorderSizePixel = 0
main.Active = true
main.Draggable = not (Config.LockUI == true)
main.Parent = screenGui

do
    local uiDragging = false
    local dragInput = nil
    local dragStart = nil
    local startPosition = nil

    main.InputBegan:Connect(function(input)
        if Config.LockUI or _G.CelestialUILocked then return end
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            uiDragging = true
            dragStart = input.Position
            startPosition = main.Position
            dragInput = input
        end
    end)

    main.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if Config.LockUI or _G.CelestialUILocked then uiDragging = false; return end
        if not uiDragging or not dragStart or not startPosition then return end
        if input ~= dragInput and input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        local delta = input.Position - dragStart
        main.Position = UDim2.new(
            startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
        )
        _G.CelestialMainWasDragged = true
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            uiDragging = false
            dragInput = nil
        end
    end)
end

corner(main, 14)
stroke(main, 1, COLORS.Stroke, 0.25)



main.BackgroundTransparency = 0
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)

uiBgImage = Instance.new("ImageLabel")
uiBgImage.Name = "UIBackground"
uiBgImage.Size = UDim2.new(1, 0, 1, 0)
uiBgImage.Position = UDim2.new(0, 0, 0, 0)
uiBgImage.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
uiBgImage.BackgroundTransparency = 0
uiBgImage.BorderSizePixel = 0
uiBgImage.Image = ""
uiBgImage.ScaleType = Enum.ScaleType.Crop
uiBgImage.ImageTransparency = 1
uiBgImage.ZIndex = 0
uiBgImage.Active = false
uiBgImage.Selectable = false
uiBgImage.Visible = false
uiBgImage.Parent = main
corner(uiBgImage, 14)

uiBgDim = Instance.new("Frame")
uiBgDim.Name = "UIBackgroundDim"
uiBgDim.Size = UDim2.new(1, 0, 1, 0)
uiBgDim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
uiBgDim.BackgroundTransparency = 1
uiBgDim.BorderSizePixel = 0
uiBgDim.ZIndex = 1
uiBgDim.Active = false
uiBgDim.Selectable = false
uiBgDim.Parent = main
corner(uiBgDim, 14)

BG_DEFAULT_URL = ""

function backgroundCacheFile(url)
    return "CelestialHub_UI_BG_" .. tostring(url):match("([^/]+)$"):gsub("[^%w%.%-_]", "_")
end

function cachedBackgroundAsset(url)
    local file = backgroundCacheFile(url)
    if not (isfile and isfile(file)) then return nil end
    local id
    pcall(function()
        if getcustomasset then
            id = getcustomasset(file)
        elseif getsynasset then
            id = getsynasset(file)
        end
    end)
    return id
end

-- Built-in backgrounds (embedded in the script, no download needed)
CELESTIAL_EMBEDDED_BG = {
    ["embedded://celestial_cyan_purple_v2.jpg"] = [=[
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
]=],
    ["embedded://celestial_tanjiro_v2.jpg"] = [=[
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
]=],
    ["embedded://celestial_pagoda_v2.jpg"] = [=[
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
]=],
    ["embedded://celestial_black_v2.jpg"] = [=[
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
QFFFFAUUUUH/2Q==
]=],
}

function celestialB64Decode(data)
    local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local lookup = {}
    for i = 1, #chars do
        lookup[string.byte(chars, i)] = i - 1
    end
    data = string.gsub(data, "[^%w%+/]", "")
    local out, n = {}, 0
    local len = #data
    local i = 1
    while i + 3 <= len do
        local a, b, c, d = string.byte(data, i, i + 3)
        local v = lookup[a] * 262144 + lookup[b] * 4096 + lookup[c] * 64 + lookup[d]
        n = n + 1
        out[n] = string.char(math.floor(v / 65536) % 256, math.floor(v / 256) % 256, v % 256)
        i = i + 4
    end
    local rem = len - i + 1
    if rem == 3 then
        local a, b, c = string.byte(data, i, i + 2)
        local v = lookup[a] * 4096 + lookup[b] * 64 + lookup[c]
        n = n + 1
        out[n] = string.char(math.floor(v / 1024) % 256, math.floor(v / 4) % 256)
    elseif rem == 2 then
        local a, b = string.byte(data, i, i + 1)
        local v = lookup[a] * 64 + lookup[b]
        n = n + 1
        out[n] = string.char(math.floor(v / 16) % 256)
    end
    return table.concat(out)
end

function celestialWriteEmbeddedBackground(url)
    local b64 = CELESTIAL_EMBEDDED_BG[url]
    if not b64 or not writefile then return false end
    local ok = pcall(function()
        writefile(backgroundCacheFile(url), celestialB64Decode(b64))
    end)
    return ok
end

function applyUIBackground(url)
    url = tostring(url or BG_DEFAULT_URL):gsub("^%s+", ""):gsub("%s+$", "")
    if url == "" then url = BG_DEFAULT_URL end
    local lower = string.lower(url)
    local isRobloxAsset = lower:match("^rbxassetid://%d+$") ~= nil
    local isEmbedded = lower:sub(1, 11) == "embedded://" and CELESTIAL_EMBEDDED_BG[url] ~= nil
    if not isRobloxAsset and not isEmbedded and not (lower:sub(1, 8) == "https://" or lower:sub(1, 7) == "http://") then
        url = BG_DEFAULT_URL
    end
    Config.UIBackgroundUrl = url

    local function setImage(imageId)
        if not imageId then
            uiBgImage.Image = ""
            uiBgImage.Visible = true
            uiBgDim.BackgroundTransparency = 1
            uiBgImage.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            uiBgImage.BackgroundTransparency = 0
            main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            main.BackgroundTransparency = 0
            return
        end
        uiBgImage.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        uiBgImage.BackgroundTransparency = 0
        uiBgImage.Image = imageId
        uiBgImage.ImageTransparency = 0
        uiBgImage.Visible = true
        uiBgDim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        uiBgDim.BackgroundTransparency = 0.35
        main.BackgroundTransparency = 1
    end

    if isRobloxAsset then
        setImage(url)
        return
    end

    if isEmbedded then
        local embeddedAsset = cachedBackgroundAsset(url)
        if not embeddedAsset then
            if celestialWriteEmbeddedBackground(url) then
                embeddedAsset = cachedBackgroundAsset(url)
            end
        end
        setImage(embeddedAsset)
        return
    end

    local cached = cachedBackgroundAsset(url)
    if cached then
        setImage(cached)
        return
    end
    setImage(url)

    task.spawn(function()
        local data
        pcall(function() data = game:HttpGet(url) end)
        if not data or #data < 100 then
            pcall(function()
                local req = request or http_request or (syn and syn.request)
                if not req then return end
                local res = req({Url = url, Method = "GET"})
                if res then data = res.Body or res.body end
            end)
        end
        if data and #data > 100 and writefile then
            local file = backgroundCacheFile(url)
            pcall(function() writefile(file, data) end)
            local asset = cachedBackgroundAsset(url)
            if asset and Config.UIBackgroundUrl == url then
                setImage(asset)
            end
        end
    end)
end

_G.CelestialApplyUIBackground = applyUIBackground
-- Backgrounds removed for clean black UI
uiBgImage.Visible = false
uiBgImage.Image = ""
uiBgDim.BackgroundTransparency = 1
main.BackgroundTransparency = 0
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)


uiScaleObj = Instance.new("UIScale")
deviceScaleFactor = 1
MAIN_UI_WIDTH = 340
MAIN_UI_HEIGHT = 545

function getViewportSize()
    local cam = workspace.CurrentCamera
    return cam and cam.ViewportSize or Vector2.new(1280, 720)
end

function getMaxFitScale()
    local viewport = getViewportSize()
    if not UserInputService.TouchEnabled then
        return 2
    end
    local maxH = viewport.Y * 0.88
    local maxW = viewport.X * 0.92
    local fit = math.min(maxH / MAIN_UI_HEIGHT, maxW / MAIN_UI_WIDTH)
    if viewport.Y < 520 then
        fit = fit * 0.94
    elseif viewport.Y < 700 then
        fit = fit * 0.97
    end
    return math.clamp(fit, 0.28, 1.2)
end

function getUserBaseScale()
    return math.clamp((tonumber(Config.UIScale) or 30) / 40, 0.2, 2)
end

function getEffectiveUIScale()
    local base = getUserBaseScale()
    if not UserInputService.TouchEnabled then
        return math.clamp(base * 0.96, 0.2, 2)
    end
    return math.clamp(base, 0.28, 2)
end

function getFitScaleForViewport(base)
    base = math.clamp(tonumber(base) or getUserBaseScale(), 0.15, 2)
    if not UserInputService.TouchEnabled then
        return math.clamp(base * 0.96, 0.2, 2)
    end
    return math.clamp(base, 0.28, 2)
end

function refreshDeviceLayout(forcePosition)
    deviceScaleFactor = 1
    if uiScaleObj then
        uiScaleObj.Scale = getEffectiveUIScale()
    end
    if forcePosition or not _G.CelestialMainWasDragged then
        if UserInputService.TouchEnabled then
            main.AnchorPoint = Vector2.new(0, 0.5)
            main.Position = UDim2.new(0, 6, 0.5, 0)
        else
            main.AnchorPoint = Vector2.new(0.5, 0.5)
            main.Position = UDim2.new(0.143, 0, 0.436, 0)
        end
    end
end
uiScaleObj.Scale = 0.88
uiScaleObj.Parent = main
refreshDeviceLayout(true)
if workspace.CurrentCamera then
    workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
        if uiScaleObj then
            uiScaleObj.Scale = getEffectiveUIScale()
        end
    end)
end

function getTargetUIScale()
    return getUserBaseScale()
end

function applyUIScale(val)
    Config.UIScale = math.clamp(tonumber(val) or 30, 10, 100)
    local target = getEffectiveUIScale()
    if uiScaleObj then
        TweenService:Create(uiScaleObj, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Scale = target
        }):Play()
    end
    pcall(saveConfig)
end


task.defer(function()
    local target = getEffectiveUIScale()
    main.BackgroundTransparency = 1
    if uiScaleObj then
        TweenService:Create(uiScaleObj, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Scale = target
        }):Play()
    end
end)



header = Instance.new("Frame")
header.Name = "Header"
header.Size = UDim2.new(1, 0, 0, 12)
header.BackgroundTransparency = 1
header.ZIndex = 2
header.Parent = main


minimizeButton = Instance.new("TextButton")
minimizeButton.Name = "MinimizeButton"
minimizeButton.Size = UDim2.new(0, 30, 0, 30)
minimizeButton.Position = UDim2.new(1, -38, 0, 13)
minimizeButton.BackgroundColor3 = COLORS.Row
minimizeButton.BackgroundTransparency = 0.05
minimizeButton.BorderSizePixel = 0
minimizeButton.Text = "-"
minimizeButton.TextColor3 = COLORS.White
minimizeButton.TextSize = 20
minimizeButton.Font = Enum.Font.GothamBold
minimizeButton.AutoButtonColor = false
minimizeButton.Parent = header
corner(minimizeButton, 9)
stroke(minimizeButton, 1, COLORS.Stroke, 0.35)


miniRestoreButton = Instance.new("ImageButton")
miniRestoreButton.Name = "MiniRestoreButton"
miniRestoreButton.Size = UDim2.new(0, 112, 0, 42)
miniRestoreButton.Position = UDim2.fromOffset(12, 12)
miniRestoreButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
miniRestoreButton.BackgroundTransparency = 0
miniRestoreButton.BorderSizePixel = 0
miniRestoreButton.Image = ""
miniRestoreButton.ScaleType = Enum.ScaleType.Fit
miniRestoreButton.ImageTransparency = 0
miniRestoreButton.AutoButtonColor = false
miniRestoreButton.Visible = false
miniRestoreButton.Parent = screenGui
corner(miniRestoreButton, 9)
stroke(miniRestoreButton, 2, Color3.fromRGB(0, 220, 255), 0)

local miniLabel = Instance.new("TextLabel")
miniLabel.Name = "MiniLabel"
miniLabel.Size = UDim2.new(1, 0, 1, 0)
miniLabel.Position = UDim2.new(0, 0, 0, 0)
miniLabel.BackgroundTransparency = 1
miniLabel.Text = "S X C"
miniLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
miniLabel.Font = Enum.Font.GothamBlack
miniLabel.TextSize = 18
miniLabel.TextXAlignment = Enum.TextXAlignment.Center
miniLabel.TextYAlignment = Enum.TextYAlignment.Center
miniLabel.Active = false
miniLabel.Selectable = false
miniLabel.ZIndex = 3
miniLabel.Parent = miniRestoreButton


MINI_LOGO_URL = ""
MINI_LOGO_FILE = "CelestialHub_Mini_Restore_Logo.png"
task.spawn(function()
    local assetId = nil
    pcall(function()
        if isfile and isfile(MINI_LOGO_FILE) then
            if getcustomasset then
                assetId = getcustomasset(MINI_LOGO_FILE)
            elseif getsynasset then
                assetId = getsynasset(MINI_LOGO_FILE)
            end
        end
    end)
    if not assetId then
        local data = nil
        pcall(function() data = game:HttpGet(MINI_LOGO_URL) end)
        if not data or #data < 100 then
            pcall(function()
                local req = request or http_request or (syn and syn.request)
                if req then
                    local res = req({Url = MINI_LOGO_URL, Method = "GET"})
                    if res then data = res.Body or res.body end
                end
            end)
        end
        if data and #data > 100 and writefile then
            pcall(function() writefile(MINI_LOGO_FILE, data) end)
            pcall(function()
                if getcustomasset then
                    assetId = getcustomasset(MINI_LOGO_FILE)
                elseif getsynasset then
                    assetId = getsynasset(MINI_LOGO_FILE)
                end
            end)
        end
    end
    if assetId then
        miniRestoreButton.Image = assetId
    end
end)

uiMinimized = false
miniDragging = false
miniDragged = false
miniDragStart = nil
miniStartPos = nil

function showMiniOnly()
    uiMinimized = true
    Config.HideUI = true
    local targetScale = getEffectiveUIScale()
    local curScale = uiScaleObj and uiScaleObj.Scale or targetScale
    if uiScaleObj then
        TweenService:Create(uiScaleObj, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Scale = curScale * 0.92
        }):Play()
    end
    TweenService:Create(main, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
    }):Play()
    task.delay(0.18, function()
        main.Visible = false
        main.BackgroundTransparency = 1
        if uiScaleObj then
            uiScaleObj.Scale = targetScale
        end
        miniRestoreButton.Visible = true
        miniRestoreButton.BackgroundTransparency = 1
        TweenService:Create(miniRestoreButton, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            BackgroundTransparency = 0.05,
        }):Play()
    end)
    pcall(saveConfig)
end

function restoreFromMini()
    uiMinimized = false
    Config.HideUI = false
    miniRestoreButton.Visible = false
    main.Visible = true
    main.Size = UDim2.new(0, MAIN_UI_WIDTH or 340, 0, MAIN_UI_HEIGHT or 545)
    main.BackgroundTransparency = 1
    local targetScale = getEffectiveUIScale()
    if uiScaleObj then
        uiScaleObj.Scale = targetScale * 0.9
        TweenService:Create(uiScaleObj, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Scale = targetScale
        }):Play()
    end
    main.BackgroundTransparency = 1
    pcall(saveConfig)
end

minimizeButton.Activated:Connect(function()
    showMiniOnly()
end)

miniRestoreButton.Active = true
miniRestoreButton.Selectable = true
miniRestoreButton.Activated:Connect(function()
    if miniDragged then
        miniDragged = false
        return
    end
    restoreFromMini()
end)


miniRestoreButton.InputBegan:Connect(function(input)
    if Config.LockUI or _G.CelestialUILocked then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        miniDragging = true
        miniDragged = false
        miniDragStart = input.Position
        miniStartPos = miniRestoreButton.Position
    end
end)

miniRestoreButton.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        miniDragging = false
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if Config.LockUI or _G.CelestialUILocked then miniDragging = false; return end
    if not miniDragging then return end
    if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
    if not miniDragStart or not miniStartPos then return end

    local delta = input.Position - miniDragStart
    if math.abs(delta.X) > 4 or math.abs(delta.Y) > 4 then
        miniDragged = true
    end

    local cam = workspace.CurrentCamera
    local viewport = cam and cam.ViewportSize or Vector2.new(1920, 1080)
    local size = miniRestoreButton.AbsoluteSize
    local x = math.clamp(miniStartPos.X.Offset + delta.X, 0, math.max(0, viewport.X - size.X))
    local y = math.clamp(miniStartPos.Y.Offset + delta.Y, 0, math.max(0, viewport.Y - size.Y))
    miniRestoreButton.Position = UDim2.fromOffset(x, y)
end)

function syncMiniState()
    if uiMinimized or Config.HideUI then
        main.Visible = false
        miniRestoreButton.Visible = true
    else
        main.Visible = true
        miniRestoreButton.Visible = false
    end
end

lineTrack = Instance.new("Frame")
lineTrack.Name = "IntroLineTrack"
lineTrack.Size = UDim2.new(0, 180, 0, 2)
lineTrack.Position = UDim2.new(0.5, -90, 1, -18)
lineTrack.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
lineTrack.BackgroundTransparency = 0.25
lineTrack.BorderSizePixel = 0
lineTrack.ClipsDescendants = true
lineTrack.ZIndex = 3
lineTrack.Parent = main
corner(lineTrack, 1)

movingLine = Instance.new("Frame")
movingLine.Name = "MovingLine"
movingLine.Size = UDim2.new(0, 90, 1, 0)
movingLine.Position = UDim2.new(0, -90, 0, 0)
movingLine.BackgroundColor3 = COLORS.TabActive
movingLine.BorderSizePixel = 0
movingLine.Parent = lineTrack
corner(movingLine, 1)

lineGrad = Instance.new("UIGradient")
lineGrad.Transparency = NumberSequence.new({
    NumberSequenceKeypoint.new(0, 1),
    NumberSequenceKeypoint.new(0.5, 0.3),
    NumberSequenceKeypoint.new(1, 0),
})
lineGrad.Parent = movingLine

task.spawn(function()
    local speed = 150
    local x = -90
    RunService.RenderStepped:Connect(function(dt)
        x = x + speed * dt
        if not lineTrack or not lineTrack.Parent then return end
        local trackWidth = lineTrack.AbsoluteSize.X
        if x > trackWidth then
            x = -90
        end
        movingLine.Position = UDim2.new(0, x, 0, 0)
    end)
end)

tabBar = Instance.new("Frame")
tabBar.Name = "TabBar"
tabBar.Size = UDim2.new(1, -32, 0, 48)
tabBar.Position = UDim2.new(0, 16, 1, -64)
tabBar.BackgroundColor3 = COLORS.TabBar
tabBar.BackgroundTransparency = 0.25
tabBar.BorderSizePixel = 0
tabBar.ZIndex = 2
tabBar.Parent = main
corner(tabBar, 10)
stroke(tabBar, 1, COLORS.Stroke, 0.3)
padding(tabBar, 5, 5, 5, 5)
tabBar.Visible = false

tabLayout = Instance.new("UIListLayout")
tabLayout.FillDirection = Enum.FillDirection.Horizontal
tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
tabLayout.Padding = UDim.new(0, 4)
tabLayout.Parent = tabBar

content = Instance.new("ScrollingFrame")
content.Name = "Content"
content.Size = UDim2.new(1, -32, 1, -188)
content.Position = UDim2.new(0, 16, 0, 172)
content.BackgroundTransparency = 1
content.BorderSizePixel = 0
content.ScrollBarThickness = 3
content.ScrollBarImageColor3 = COLORS.Badge
content.CanvasSize = UDim2.new(0, 0, 0, 0)
content.AutomaticCanvasSize = Enum.AutomaticSize.Y
content.ZIndex = 2
content.Parent = main

listLayout = Instance.new("UIListLayout")
listLayout.SortOrder = Enum.SortOrder.LayoutOrder
listLayout.Padding = UDim.new(0, 10)
listLayout.Parent = content

order = 0
function nextOrder()
    order = order + 1
    return order
end

function sectionLabel(parent, text)
    local wrap = Instance.new("Frame")
    wrap.Size = UDim2.new(1, 0, 0, 22)
    wrap.BackgroundTransparency = 1
    wrap.LayoutOrder = nextOrder()
    wrap.ClipsDescendants = true
    wrap.Parent = parent

    local lbl = Instance.new("TextLabel")
    lbl.Text = string.upper(text)
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = wrap


    local shine = Instance.new("Frame")
    shine.Size = UDim2.new(0, 48, 1, 0)
    shine.Position = UDim2.new(0, -60, 0, 0)
    shine.BackgroundColor3 = COLORS.White
    shine.BackgroundTransparency = 0.92
    shine.BorderSizePixel = 0
    shine.ZIndex = 2
    shine.Parent = wrap
    local g = Instance.new("UIGradient")
    g.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 0.35),
        NumberSequenceKeypoint.new(1, 1),
    })
    g.Parent = shine
    task.spawn(function()
        while wrap.Parent do
            shine.Position = UDim2.new(0, -60, 0, 0)
            local tw = TweenService:Create(shine, TweenInfo.new(2.8, Enum.EasingStyle.Linear), {
                Position = UDim2.new(1, 20, 0, 0)
            })
            tw:Play()
            tw.Completed:Wait()
            task.wait(3.5)
        end
    end)
    return lbl
end

function celestialUsesGuiThemeOutline(rowOrText)
    return false
end

function celestialRowOutlineColor(rowOrText)
    return celestialAccentColor()
end

function celestialForceRowThemeOutline(row)
    if not row or not row.Parent then return end
    local accent = celestialAccentColor()
    local st = row:FindFirstChild("RowStroke") or row:FindFirstChildOfClass("UIStroke")
    if st then
        st.Color = accent
        st:SetAttribute("CelestialHubThemeAccentStroke", true)
    end
    for _, child in ipairs(row:GetDescendants()) do
        if child:IsA("UIStroke") then
            child.Color = accent
            child:SetAttribute("CelestialHubThemeAccentStroke", true)
        end
    end
end

function rowBase(parent, labelText, accent)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 44)
    row.BackgroundColor3 = COLORS.Row
    row.BackgroundTransparency = 0.4
    row.BorderSizePixel = 0
    row.LayoutOrder = nextOrder()
    row.Parent = parent
    corner(row, 10)
    local rowStroke = stroke(row, 1.2, celestialAccentColor(), 0.45)
    rowStroke.Name = "RowStroke"
    rowStroke.Color = celestialAccentColor()
    rowStroke:SetAttribute("CelestialHubThemeAccentStroke", true)

    local lbl = Instance.new("TextLabel")
    lbl.Text = labelText
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 13
    lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(0.55, 0, 1, 0)
    lbl.Position = UDim2.new(0, 14, 0, 0)
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.Parent = row

    row:SetAttribute("GlowOn", false)
    row.MouseEnter:Connect(function()
        if row:GetAttribute("GlowOn") then return end
        TweenService:Create(row, TweenInfo.new(0.12), {BackgroundColor3 = celestialSoftColor()}):Play()
        rowStroke.Color = celestialAccentColor()
        rowStroke:SetAttribute("CelestialHubThemeAccentStroke", true)
        TweenService:Create(rowStroke, TweenInfo.new(0.12), {Transparency = 0.15}):Play()
    end)
    row.MouseLeave:Connect(function()
        if row:GetAttribute("GlowOn") then return end
        TweenService:Create(row, TweenInfo.new(0.15), {BackgroundColor3 = COLORS.Row}):Play()
        rowStroke.Color = celestialAccentColor()
        rowStroke:SetAttribute("CelestialHubThemeAccentStroke", true)
        TweenService:Create(rowStroke, TweenInfo.new(0.15), {Transparency = 0.45}):Play()
    end)

    return row
end

function setRowGlow(row, enabled)
    if not row then return end
    row:SetAttribute("GlowOn", enabled == true)
    local st = row:FindFirstChild("RowStroke") or row:FindFirstChildOfClass("UIStroke")
    if not st then return end
    local info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local rowAccent = celestialAccentColor()
    st.Color = rowAccent
    st:SetAttribute("CelestialHubThemeAccentStroke", true)
    if celestialForceRowThemeOutline then celestialForceRowThemeOutline(row) end
    if enabled then
        TweenService:Create(st, info, {
            Transparency = 0,
            Thickness = 3,
            Color = rowAccent,
        }):Play()
        TweenService:Create(row, info, {
            BackgroundColor3 = celestialSoftColor(),
            BackgroundTransparency = 0.08,
        }):Play()
    else
        TweenService:Create(st, info, {
            Transparency = 0.45,
            Thickness = 1.2,
            Color = rowAccent,
        }):Play()
        TweenService:Create(row, info, {
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 0.4,
        }):Play()
    end
end

keybindCaptureActive = false

function keybindDisplay(v)
    v = tostring(v or "")
    if v == "" or v == "None" or v == "NONE" then return "None" end
    return v
end

function keybindBadge(parent, initialText, offsetX, width, onKeyChanged)
    local btn = Instance.new("TextButton")
    btn.Text = keybindDisplay(initialText)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 11
    btn.TextColor3 = COLORS.White
    btn.BackgroundColor3 = COLORS.Badge
    btn.BackgroundTransparency = 0.35
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(0, width or 48, 0, 24)
    btn.Position = UDim2.new(1, offsetX, 0.5, -12)
    btn.AutoButtonColor = false
    btn.Parent = parent
    corner(btn, 8)
    local kbStroke = stroke(btn, 1.4, COLORS.Stroke, 0.25)
    btn.MouseEnter:Connect(function()
        if btn.Text == "..." then return end
        TweenService:Create(kbStroke, TweenInfo.new(0.1), {Transparency = 0}):Play()
    end)
    btn.MouseLeave:Connect(function()
        if btn.Text == "..." then return end
        TweenService:Create(kbStroke, TweenInfo.new(0.12), {Transparency = 0.25}):Play()
    end)

    local listening = false
    local currentValue = tostring(initialText)

    btn.Activated:Connect(function()
        if listening then return end
        listening = true
        keybindCaptureActive = true
        btn.Text = "..."

        btn.BackgroundColor3 = COLORS.TabActive
        btn.TextColor3 = COLORS.White
        local st = btn:FindFirstChildOfClass("UIStroke")
        if st then st.Transparency = 0; st.Color = COLORS.Stroke end

        local conn
        conn = UserInputService.InputBegan:Connect(function(input, gp)
            local isKeyboard = input.UserInputType == Enum.UserInputType.Keyboard
            local inputTypeName = input.UserInputType.Name
            local isGamepad = inputTypeName:match("^Gamepad%d+$") ~= nil
            if not (isKeyboard or isGamepad) then return end

            local key = input.KeyCode.Name
            if isKeyboard and key == "Escape" then
                currentValue = "None"
                btn.Text = "None"
            else
                currentValue = key
                btn.Text = key
            end
            if onKeyChanged then
                onKeyChanged(currentValue)
            end
            saveConfig()
            listening = false
            btn.BackgroundColor3 = COLORS.Badge
            btn.TextColor3 = COLORS.White
            if st then st.Transparency = 0.25; st.Color = COLORS.Stroke end
            conn:Disconnect()
            task.defer(function()
                keybindCaptureActive = false
            end)
        end)
    end)

    return btn, function() return currentValue end
end

function formatSpeedNum(n)
    n = tonumber(n)
    if not n then return "0" end

    if math.abs(n - math.floor(n + 1e-9)) < 1e-9 then
        return tostring(math.floor(n + 0.5))
    end
    return string.format("%.1f", n)
end

function parseNumInput(str)
    if str == nil then return nil end
    str = tostring(str):gsub("%s+", ""):gsub(",", ".")
    return tonumber(str)
end

function numberBadge(parent, initialValue, offsetX, width, onChanged)
    local btn = Instance.new("TextButton")
    btn.Text = formatSpeedNum(initialValue)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 12
    btn.TextColor3 = COLORS.White
    btn.BackgroundColor3 = COLORS.Badge
    btn.BackgroundTransparency = 0.35
    btn.BorderSizePixel = 0
    btn.Size = UDim2.new(0, width or 44, 0, 24)
    btn.Position = UDim2.new(1, offsetX, 0.5, -12)
    btn.AutoButtonColor = false
    btn.Parent = parent
    corner(btn, 8)
    local nStroke = stroke(btn, 1.4, COLORS.Stroke, 0.25)
    btn.MouseEnter:Connect(function()
        TweenService:Create(nStroke, TweenInfo.new(0.1), {Transparency = 0}):Play()
    end)
    btn.MouseLeave:Connect(function()
        TweenService:Create(nStroke, TweenInfo.new(0.12), {Transparency = 0.25}):Play()
    end)

    local currentValue = formatSpeedNum(initialValue)

    btn.Activated:Connect(function()
        local box = Instance.new("TextBox")
        box.Text = currentValue
        box.Font = Enum.Font.GothamBold
        box.TextSize = 12
        box.TextColor3 = COLORS.White
        box.BackgroundColor3 = COLORS.Badge
        box.BackgroundTransparency = 0.25
        box.BorderSizePixel = 0
        box.Size = btn.Size
        box.Position = btn.Position
        box.ClearTextOnFocus = false
        box.TextXAlignment = Enum.TextXAlignment.Center
        box.Parent = parent
        corner(box, 8)
        stroke(box, 1, COLORS.Stroke, 0.2)
        btn.Visible = false
        box:CaptureFocus()
        box.CursorPosition = #box.Text + 1

        local function finish()
            local num = parseNumInput(box.Text)
            if num then

                num = math.floor(num * 10 + 0.5) / 10
                currentValue = formatSpeedNum(num)
                if onChanged then
                    onChanged(num)
                end
                saveConfig()
            end
            btn.Text = currentValue
            box:Destroy()
            btn.Visible = true
        end

        box.FocusLost:Connect(function()
            finish()
        end)
    end)

    local function getValue()
        return parseNumInput(currentValue) or tonumber(initialValue) or 0
    end

    local function setValue(v)
        currentValue = formatSpeedNum(v)
        btn.Text = currentValue
    end

    return btn, getValue, setValue
end

function toggleRow(parent, labelText, defaultOn, onToggle, initialKey, onKeyChanged)
    local row = rowBase(parent, labelText, true)

    local track = Instance.new("TextButton")
    track.Text = ""
    track.AutoButtonColor = false
    track.Size = UDim2.new(0, 44, 0, 24)
    track.Position = UDim2.new(1, -60, 0.5, -12)
    track.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    track.BackgroundTransparency = 0
    track.BorderSizePixel = 0
    track.Parent = row
    corner(track, 12)
    local toggleStroke = stroke(track, 1.5, _G.CelestialThemeAccent or COLORS.Accent or Color3.fromRGB(0, 220, 255), 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = defaultOn and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = COLORS.White
    knob.BorderSizePixel = 0
    knob.Parent = track
    corner(knob, 9)

    local on = defaultOn
    local function setVisual(state)
        on = state == true
        local info = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        TweenService:Create(knob, info, {
            Position = on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
            BackgroundColor3 = COLORS.White,
        }):Play()

        track.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        track.BackgroundTransparency = 0
        if toggleStroke then
            TweenService:Create(toggleStroke, info, {
                Color = _G.CelestialThemeAccent or COLORS.ToggleActive or COLORS.Accent or Color3.fromRGB(0, 220, 255),
                Transparency = 0,
                Thickness = on and 2 or 1.5,
            }):Play()
        end

        if toggleStroke then
            toggleStroke.Color = _G.CelestialThemeAccent or COLORS.ToggleActive or COLORS.Accent or Color3.fromRGB(0, 220, 255)
        end
        local rowStroke = row:FindFirstChild("RowStroke")
        if rowStroke then
            TweenService:Create(rowStroke, info, {
                Color = COLORS.Stroke,
                Transparency = 0.25,
                Thickness = on and 1.6 or 1.2,
            }):Play()
        end
    end

    local lastToggleActivation = 0
    track.Activated:Connect(function()
        local now = os.clock()
        if now - lastToggleActivation < 0.28 then return end
        lastToggleActivation = now
        local nextState = not on
        setVisual(nextState)
        if onToggle then onToggle(nextState) end
        saveConfig()
    end)

    if initialKey and tostring(initialKey) ~= "" then
        keybindBadge(row, initialKey, -112, 34, function(key)
            if onKeyChanged then onKeyChanged(key) end
            saveConfig()
        end)
    end
    return row, setVisual
end

function toggleWithKeybindRow(parent, labelText, defaultOn, initialKey, onToggle, onKeyChanged)
    local row = rowBase(parent, labelText, true)

    local track = Instance.new("TextButton")
    track.Text = ""
    track.AutoButtonColor = false
    track.Size = UDim2.new(0, 44, 0, 24)
    track.Position = UDim2.new(1, -60, 0.5, -12)
    track.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    track.BackgroundTransparency = 0
    track.BorderSizePixel = 0
    track.Parent = row
    corner(track, 12)
    do
        local trackStroke = stroke(track, 1, celestialAccentColor(), 0.4)
        trackStroke:SetAttribute("CelestialHubThemeAccentStroke", true)
    end

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = defaultOn and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = COLORS.White
    knob.BorderSizePixel = 0
    knob.Parent = track
    corner(knob, 9)

    local on = defaultOn
    setRowGlow(row, defaultOn == true)
    track.Activated:Connect(function()
        on = not on
        local info = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        TweenService:Create(knob, info, {
            Position = on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
            BackgroundColor3 = COLORS.White,
        }):Play()
        TweenService:Create(track, info, {
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
            BackgroundTransparency = 0,
        }):Play()
        setRowGlow(row, on)
        if onToggle then
            onToggle(on)
        end
        saveConfig()
    end)

    keybindBadge(row, initialKey, -112, 34, function(key)
        if onKeyChanged then
            onKeyChanged(key)
        end
        saveConfig()
    end)

    _G.CelestialSetBatAimbotUI = function(value)
        if labelText ~= "Bat Aimbot" then return end
        on = value == true
        local info = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(knob, info, {Position = on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)}):Play()
        setRowGlow(row, on)
    end
    return row
end

function toggleWithNumberRow(parent, labelText, defaultOn, initialVal, onToggle, onChanged, initialKey, onKeyChanged)
    local row = rowBase(parent, labelText, true)

    local track = Instance.new("TextButton")
    track.Text = ""
    track.AutoButtonColor = false
    track.Size = UDim2.new(0, 44, 0, 24)
    track.Position = UDim2.new(1, -112, 0.5, -12)
    track.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    track.BackgroundTransparency = 0
    track.BorderSizePixel = 0
    track.Parent = row
    corner(track, 12)
    local toggleStroke = stroke(track, 1.5, celestialAccentColor(), 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 18, 0, 18)
    knob.Position = defaultOn and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    knob.BackgroundColor3 = COLORS.White
    knob.BorderSizePixel = 0
    knob.Parent = track
    corner(knob, 9)

    local on = defaultOn == true
    local function setVisual(state)
        on = state == true
        local info = TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        TweenService:Create(knob, info, {
            Position = on and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9),
            BackgroundColor3 = COLORS.White,
        }):Play()
        track.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        track.BackgroundTransparency = 0

        local accent = celestialAccentColor()
        toggleStroke.Color = accent
        toggleStroke.Thickness = on and 2 or 1.5
        toggleStroke.Transparency = 0
        toggleStroke:SetAttribute("CelestialHubThemeAccentStroke", true)

        local rowStroke = row:FindFirstChild("RowStroke") or row:FindFirstChildOfClass("UIStroke")
        if rowStroke then
            rowStroke.Color = accent
            rowStroke.Transparency = 0.25
            rowStroke.Thickness = on and 1.6 or 1.2
            rowStroke:SetAttribute("CelestialHubThemeAccentStroke", true)
        end
    end

    setVisual(on)
    track.Activated:Connect(function()
        setVisual(not on)
        if onToggle then onToggle(on) end
        saveConfig()
    end)

    if initialKey and tostring(initialKey) ~= "" then
        keybindBadge(row, initialKey, -156, 34, function(key)
            if onKeyChanged then onKeyChanged(key) end
            saveConfig()
        end)
    end

    numberBadge(row, initialVal, -60, 44, function(val)
        if onChanged then onChanged(val) end
        saveConfig()
    end)

    return row
end

function cycleSelectorRow(parent, labelText, options, currentValue, onChanged)
    local row = rowBase(parent, labelText, false)
    local opts = options or {}
    local idx = 1
    for i, o in ipairs(opts) do
        if o == currentValue then idx = i break end
    end

    local valueLbl = Instance.new("TextLabel")
    valueLbl.BackgroundTransparency = 1
    valueLbl.Size = UDim2.new(0, 110, 0, 22)
    valueLbl.Position = UDim2.new(1, -150, 0.5, -11)
    valueLbl.Font = Enum.Font.GothamBold
    valueLbl.TextSize = 12
    valueLbl.TextColor3 = COLORS.White
    valueLbl.Text = tostring(currentValue or (opts[1] or "-"))
    valueLbl.TextXAlignment = Enum.TextXAlignment.Center
    valueLbl.TextTruncate = Enum.TextTruncate.AtEnd
    valueLbl.Parent = row

    local function makeArrow(text, xOff)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 28, 0, 22)
        b.Position = UDim2.new(1, xOff, 0.5, -11)
        b.BackgroundColor3 = COLORS.Badge
        b.BackgroundTransparency = 0.25
        b.BorderSizePixel = 0
        b.Text = text
        b.Font = Enum.Font.GothamBlack
        b.TextSize = 14
        b.TextColor3 = COLORS.White
        b.AutoButtonColor = false
        b.Parent = row
        corner(b, 6)
        return b
    end

    local left = makeArrow("<", -188)
    local right = makeArrow(">", -32)

    local function setIndex(i)
        if #opts == 0 then return end
        if i < 1 then i = #opts end
        if i > #opts then i = 1 end
        idx = i
        valueLbl.Text = tostring(opts[idx])
        if onChanged then onChanged(opts[idx]) end
    end

    left.Activated:Connect(function() setIndex(idx - 1) end)
    right.Activated:Connect(function() setIndex(idx + 1) end)

    return {
        set = function(val)
            for i, o in ipairs(opts) do
                if o == val then
                    idx = i
                    valueLbl.Text = tostring(val)
                    break
                end
            end
        end
    }
end

_G.__CelestialHubModeButtonRefreshers = _G.__CelestialHubModeButtonRefreshers or {}

function modeButtonsRow(parent, options, currentOption, onSelected)
    local row = Instance.new("Frame")
    row.Size = UDim2.new(1, 0, 0, 50)
    row.BackgroundColor3 = COLORS.RowDark
    row.BackgroundTransparency = 0.1
    row.BorderSizePixel = 0
    row.LayoutOrder = nextOrder()
    row.Parent = parent
    corner(row, 14)
    local rowSt = stroke(row, 1, COLORS.Stroke, 0.5)

    local container = Instance.new("Frame")
    container.Size = UDim2.new(1, -16, 1, -12)
    container.Position = UDim2.new(0, 8, 0, 6)
    container.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    container.BackgroundTransparency = 0.15
    container.BorderSizePixel = 0
    container.Parent = row
    corner(container, 12)

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 4)
    layout.Parent = container

    local padInner = Instance.new("UIPadding")
    padInner.PaddingLeft = UDim.new(0, 4)
    padInner.PaddingRight = UDim.new(0, 4)
    padInner.PaddingTop = UDim.new(0, 4)
    padInner.PaddingBottom = UDim.new(0, 4)
    padInner.Parent = container

    local buttons = {}
    local strokes = {}

    local function refreshAll()
        local liveAccent = celestialAccentColor()
        local liveSoft = celestialSoftColor()
        for opt, btn in pairs(buttons) do
            local active = (opt == currentOption)
            local st = strokes[opt]
            local info = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            if active then

                TweenService:Create(btn, info, {
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    BackgroundTransparency = 0,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                }):Play()
                if st then
                    st.Thickness = 2
                    st:SetAttribute("CelestialHubThemeAccentStroke", true)
                    TweenService:Create(st, info, {Transparency = 0, Color = liveAccent}):Play()
                end
            else

                TweenService:Create(btn, info, {
                    BackgroundColor3 = Color3.fromRGB(0, 0, 0),
                    BackgroundTransparency = 0,
                    TextColor3 = Color3.fromRGB(255, 255, 255),
                }):Play()
                if st then
                    st.Thickness = 1.4
                    st:SetAttribute("CelestialHubThemeAccentStroke", true)
                    TweenService:Create(st, info, {Transparency = 0.45, Color = liveSoft}):Play()
                end
            end
        end
    end

    table.insert(_G.__CelestialHubModeButtonRefreshers, refreshAll)

    local n = math.max(#options, 1)
    local pad = 4
    for _, opt in ipairs(options) do
        local btn = Instance.new("TextButton")
        btn.Text = opt
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 12
        btn.AutoButtonColor = false
        btn.Size = UDim2.new(1 / n, -math.floor(pad * (n - 1) / n), 1, 0)
        btn.BorderSizePixel = 0
        btn.BackgroundColor3 = COLORS.Badge
        btn.BackgroundTransparency = 0
        btn.TextColor3 = COLORS.White
        btn.Parent = container
        corner(btn, 8)
        local st = stroke(btn, 1.4, COLORS.Stroke, 0.25)
        buttons[opt] = btn
        strokes[opt] = st

        btn.MouseEnter:Connect(function()
            if opt == currentOption then return end
            local st2 = strokes[opt]
            if st2 then
                st2:SetAttribute("CelestialHubThemeAccentStroke", true)
                TweenService:Create(st2, TweenInfo.new(0.1), {Transparency = 0.15, Color = celestialAccentColor()}):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if opt == currentOption then return end
            local st2 = strokes[opt]
            if st2 then TweenService:Create(st2, TweenInfo.new(0.12), {Transparency = 0.45}):Play() end
        end)

        btn.Activated:Connect(function()
            if currentOption == opt then return end
            currentOption = opt

            TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundTransparency = 0}):Play()
            refreshAll()
            if onSelected then onSelected(opt) end
            saveConfig()
        end)
    end

    refreshAll()
    return row
end

function textRow(parent, labelText, rightText)
    local row = rowBase(parent, labelText, false)
    local r = Instance.new("TextLabel")
    r.Text = rightText
    r.Font = Enum.Font.GothamBold
    r.TextSize = 12
    r.TextColor3 = COLORS.White
    r.BackgroundTransparency = 1
    r.Size = UDim2.new(0, 100, 1, 0)
    r.Position = UDim2.new(1, -116, 0, 0)
    r.TextXAlignment = Enum.TextXAlignment.Right
    r.Parent = row
    return row
end

pages = {}

function makePage(name)
    local page = Instance.new("Frame")
    page.Name = name
    page.Size = UDim2.new(1, 0, 0, 0)
    page.AutomaticSize = Enum.AutomaticSize.Y
    page.BackgroundTransparency = 1
    page.Visible = false
    page.Parent = content

    local layout = Instance.new("UIListLayout")
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 10)
    layout.Parent = page

    pages[name] = page
    return page
end

movement = makePage("Movement")
combat = makePage("Combat")






CelestialSpeed = {}
do
    local MOVE_KEYS = {
        [Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true,
        [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
        [Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true,
        [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true,
    }

    local S = {
        lastMoveDir = Vector3.zero,
        currentPlane = Vector2.zero,
        spoofed = Vector3.zero,
        root = nil,
        hooked = false,
    }

    local function _V3new(x, y, z)
        return Vector3.new(x, y, z)
    end

    local function isRagdollState(hum)
        if not hum then return true end
        local st = hum:GetState()
        return hum.PlatformStand == true
            or st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown
    end

    local function destroyLinVel()
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        for _, child in ipairs(hrp:GetChildren()) do
            if child.Name == "CelestialHubSpeedVelocity" or child.Name == "CelestialHubSpeedAttachment" then
                pcall(function() child:Destroy() end)
            end
        end
    end

    local function setupLV(char)
        destroyLinVel()
        if not char then S.root = nil; return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then
            local ok, res = pcall(function() return char:WaitForChild("HumanoidRootPart", 5) end)
            if ok then hrp = res end
        end
        S.root = hrp
        S.lastMoveDir = Vector3.zero
        S.currentPlane = Vector2.zero
        S.spoofed = Vector3.zero
    end

    local function ensure()
        local char = LP.Character
        if not char then return false end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end
        S.root = hrp
        return true
    end

    local function applyXZ(hrp, x, z)
        if not hrp or not hrp.Parent then return end
        local y = hrp.AssemblyLinearVelocity.Y
        local sx, sz = tonumber(x) or 0, tonumber(z) or 0
        hrp.AssemblyLinearVelocity = _V3new(sx, y, sz)
        local vis = math.min(math.sqrt(sx * sx + sz * sz), 20)
        if vis > 0.05 then
            local u = Vector3.new(sx, 0, sz)
            if u.Magnitude > 0.001 then u = u.Unit end
            S.spoofed = _V3new(u.X * vis, y, u.Z * vis)
        else
            S.spoofed = _V3new(0, y, 0)
        end
        S.currentPlane = Vector2.new(sx, sz)
    end

    local function setXZ(x, z)
        ensure()
        local hrp = S.root or (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"))
        applyXZ(hrp, x, z)
    end

    local function getPlane()
        return S.currentPlane
    end

    local function clear()
        S.currentPlane = Vector2.zero
        S.lastMoveDir = Vector3.zero
        local hrp = S.root or (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"))
        if hrp and hrp.Parent then
            local y = hrp.AssemblyLinearVelocity.Y
            hrp.AssemblyLinearVelocity = _V3new(0, y, 0)
            S.spoofed = _V3new(0, y, 0)
        else
            S.spoofed = Vector3.zero
        end
    end

    local function speedLVSet(hrp, x, z)
        if hrp then S.root = hrp end
        applyXZ(hrp or S.root, x, z)
    end

    local function speedLVClear(hrp)
        if hrp then S.root = hrp end
        clear()
    end

    -- Bubble Hub movement speed logic (Oi): MoveDirection * speed, keep Y
    local function applyVelocityToHRP(dir, speed, hrp)
        if not hrp or not hrp.Parent then return end
        if State and (State.autoBatToggled or State.bypassAimbotToggled) then return end
        if type(speed) ~= "number" or speed ~= speed or speed <= 0 or speed == math.huge then return end

        local verticalVelocity = hrp.AssemblyLinearVelocity.Y
        if _G._ZurichHub_MovementBlocked == true
            or _G._CrystalHub_MovementBlocked == true
            or _G._BubbleHub_MovementBlocked == true then
            hrp.AssemblyLinearVelocity = _V3new(0, math.min(verticalVelocity, 0), 0)
            return
        end

        if dir and dir.Magnitude > 0.05 then
            pcall(function()
                if hrp.SetNetworkOwner then hrp:SetNetworkOwner(LP) end
            end)
            local unit = dir.Unit
            -- Bubble: AssemblyLinearVelocity = Unit * speed, preserve Y
            hrp.AssemblyLinearVelocity = _V3new(unit.X * speed, verticalVelocity, unit.Z * speed)
            local visibleSpeed = math.min(speed, 20)
            S.spoofed = _V3new(unit.X * visibleSpeed, verticalVelocity, unit.Z * visibleSpeed)
            S.currentPlane = Vector2.new(unit.X * speed, unit.Z * speed)
            S.lastMoveDir = unit
        else
            -- Bubble: no input -> zero XZ, keep Y
            S.spoofed = _V3new(0, verticalVelocity, 0)
            S.currentPlane = Vector2.zero
            hrp.AssemblyLinearVelocity = _V3new(0, verticalVelocity, 0)
        end
    end

    -- Bubble Hub applySpeed: MoveDirection or held keys keep last dir
    local function applySpeed(speed)
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end
        -- Bubble: skip while aimbot / bypass aimbot / auto path / drop
        if State and (State.autoBatToggled or State.bypassAimbotToggled) then return end
        if Config.AutoLeft or Config.AutoRight then return end
        if _G.dropActive or dropActive then return end
        if isRagdollState(hum) then
            S.lastMoveDir = Vector3.zero
            return
        end

        S.root = root
        local direction = nil
        if hum.MoveDirection.Magnitude > 0 then
            S.lastMoveDir = hum.MoveDirection
            direction = hum.MoveDirection
        elseif S.lastMoveDir.Magnitude > 0 then
            for key in pairs(MOVE_KEYS) do
                if UserInputService:IsKeyDown(key) then
                    direction = S.lastMoveDir
                    break
                end
            end
        end
        applyVelocityToHRP(direction, tonumber(speed) or 16, root)
    end

    pcall(function()
        if not (getrawmetatable and setreadonly and newcclosure and checkcaller) then return end
        if S.hooked then return end
        local mt = getrawmetatable(game)
        if not mt then return end
        setreadonly(mt, false)
        local oldIndex = mt.__index
        local oldNewIndex = mt.__newindex
        local function isOurRoot(t, k)
            local tk = tostring(k)
            if tk ~= "AssemblyLinearVelocity" and tk ~= "Velocity" then return false end
            if typeof(t) ~= "Instance" or not t:IsA("BasePart") then return false end
            local tn = t.Name
            if tn ~= "HumanoidRootPart" and tn ~= "Torso" and tn ~= "UpperTorso" then return false end
            local char = LP.Character
            return char ~= nil and t:IsDescendantOf(char)
        end
        if type(oldIndex) == "function" or type(oldIndex) == "table" then
            mt.__index = newcclosure(function(self, key)
                if not checkcaller() then
                    local good, mine = pcall(isOurRoot, self, key)
                    if good and mine then return S.spoofed end
                end
                if type(oldIndex) == "function" then return oldIndex(self, key) end
                return oldIndex[key]
            end)
        end
        if type(oldNewIndex) == "function" then
            mt.__newindex = newcclosure(function(self, key, value)
                if not checkcaller() then
                    local good, mine = pcall(isOurRoot, self, key)
                    if good and mine then
                        S.spoofed = value
                        return
                    end
                end
                return oldNewIndex(self, key, value)
            end)
        end
        setreadonly(mt, true)
        S.hooked = true
    end)

    LP.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        pcall(setupLV, char)
        S.lastMoveDir = Vector3.zero
    end)

    task.defer(function()
        if LP.Character then
            task.wait(0.3)
            pcall(setupLV, LP.Character)
        end
    end)

    CelestialSpeed.apply = applySpeed
    CelestialSpeed.set = speedLVSet
    CelestialSpeed.clear = speedLVClear
    CelestialSpeed.setup = setupLV
    CelestialSpeed.ensure = ensure
    CelestialSpeed.setXZ = setXZ
    CelestialSpeed.getPlane = getPlane
end

function applyVelocitySpeed(...)
    return CelestialSpeed.apply(...)
end
function _speedLVSet(...)
    return CelestialSpeed.set(...)
end
function _speedLVClear(...)
    return CelestialSpeed.clear(...)
end

function getActiveSpeed()
    local char = LP.Character
    local inLagger = laggerModeEnabled or laggerSpeedEnabled or laggerCarryEnabled


    if carrySpeedEnabled then
        return inLagger and (tonumber(Config.LaggerCarry) or 20) or (tonumber(Config.CarrySpeed) or 29)
    end

    if autoCarryBoost and Config.AutoCarrySpeed then
        return inLagger and (tonumber(Config.LaggerCarry) or 20) or (tonumber(Config.CarrySpeed) or 29)
    end
    if laggerCarryEnabled then return tonumber(Config.LaggerCarry) or 20 end
    if laggerModeEnabled or laggerSpeedEnabled then return tonumber(Config.LaggerSpeed) or 40 end
    return tonumber(Config.NormalSpeed) or 59
end

function getPathSpeed()
    if laggerModeEnabled or laggerSpeedEnabled or laggerCarryEnabled then
        return tonumber(Config.LaggerSpeed) or 40
    end
    return tonumber(Config.NormalSpeed) or 59
end


autoTPDownConn = nil

function getTPDownLandingY(char, root, hum)
    local halfHeight = 1
    pcall(function() halfHeight = math.max(1, root.Size.Y * 0.5) end)
    local hipOffset = halfHeight * 3
    pcall(function()
        if hum.RigType == Enum.HumanoidRigType.R6 then
            hipOffset = halfHeight * 3
        else
            hipOffset = halfHeight + (hum.HipHeight or halfHeight * 2)
        end
    end)
    if hipOffset ~= hipOffset or hipOffset < 1 or hipOffset > 12 then hipOffset = halfHeight * 3 end

    local ignored = {char}
    pcall(function()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then table.insert(ignored, player.Character) end
        end
    end)
    local params = RaycastParams.new()
    params.FilterDescendantsInstances = ignored
    pcall(function() params.FilterType = Enum.RaycastFilterType.Exclude end)
    params.IgnoreWater = true
    pcall(function() params.RespectCanCollide = true end)

    local pos = root.Position
    local castY = pos.Y - math.max(1, root.Size.Y * 0.5) - 0.1
    local floorY
    for _ = 1, 12 do
        local hit
        pcall(function() hit = workspace:Raycast(Vector3.new(pos.X, castY, pos.Z), Vector3.new(0, -4000, 0), params) end)
        if not hit then break end
        local part = hit.Instance
        local skip = false
        pcall(function()
            if part:IsA("BasePart") and not part.CanCollide then skip = true end
            local model = part:FindFirstAncestorOfClass("Model")
            if model and model:FindFirstChildOfClass("Humanoid") then skip = true end
        end)
        if not skip then floorY = hit.Position.Y; break end
        table.insert(ignored, part)
        params.FilterDescendantsInstances = ignored
        castY = hit.Position.Y - 0.05
    end
    if floorY then return floorY + hipOffset + 0.15 end
    return -7
end

function doAutoTPDown(force)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end

    if not force then
        if hum.FloorMaterial ~= Enum.Material.Air then return end
        if hrp.Position.Y < (tonumber(Config.TPDownHeight) or 20) then return end
    end

    local landingY = getTPDownLandingY(char, hrp, hum)
    local _, yaw = hrp.CFrame:ToEulerAnglesYXZ()
    local currentVelocity = hrp.AssemblyLinearVelocity
    hrp.CFrame = CFrame.new(hrp.Position.X, landingY, hrp.Position.Z) * CFrame.Angles(0, yaw, 0)
    hrp.AssemblyLinearVelocity = Vector3.new(currentVelocity.X, 0, currentVelocity.Z)
    pcall(function()
        local current = hrp.Velocity
        hrp.Velocity = Vector3.new(current.X, 0, current.Z)
    end)
    pcall(function() hrp.AssemblyAngularVelocity = Vector3.zero end)
    pcall(function() hrp.RotVelocity = Vector3.zero end)
end

function startAutoTPDown()
    if autoTPDownConn then pcall(task.cancel, autoTPDownConn); autoTPDownConn = nil end
    autoTPDownConn = task.spawn(function()
        while Config.AutoTPDown do
            task.wait(0.1)
            pcall(function() doAutoTPDown(false) end)
        end
        autoTPDownConn = nil
    end)
end

function stopAutoTPDown()
    Config.AutoTPDown = false
    if autoTPDownConn then pcall(task.cancel, autoTPDownConn); autoTPDownConn = nil end
end

function performTPDown()
    pcall(function() doAutoTPDown(true) end)
end



_GACC = _GACC or {}
;(function()
 local state={applied=false,waiting=false,watchUntil=0,graceUntil=0,stealWasActive=false}
 local function ignored(n)
  local x=tostring(n or ""):lower()
  return x:find("bat",1,true) or x:find("slap",1,true) or x:find("medusa",1,true)
    or x:find("head",1,true) or x:find("stone",1,true)
 end
 
 -- Near enemy base detection (from Celestial Duels / Clean Hub)
 _GACC.plotCache = {}
 _GACC.plotCacheTime = {}
 _GACC.isMyPlotByName = function(plotName)
  local ct = tick()
  if _GACC.plotCache[plotName] ~= nil and (ct - (_GACC.plotCacheTime[plotName] or 0)) < 2 then
    return _GACC.plotCache[plotName]
  end
  local plots = workspace:FindFirstChild("Plots")
  if not plots then
    _GACC.plotCache[plotName] = false
    _GACC.plotCacheTime[plotName] = ct
    return false
  end
  local plot = plots:FindFirstChild(plotName)
  if not plot then
    _GACC.plotCache[plotName] = false
    _GACC.plotCacheTime[plotName] = ct
    return false
  end
  local sign = plot:FindFirstChild("PlotSign")
  if sign then
    local yb = sign:FindFirstChild("YourBase")
    if yb and yb:IsA("BillboardGui") then
      local r = yb.Enabled == true
      _GACC.plotCache[plotName] = r
      _GACC.plotCacheTime[plotName] = ct
      return r
    end
    local sg = sign:FindFirstChild("SurfaceGui")
    local frame = sg and sg:FindFirstChild("Frame")
    local lbl = frame and frame:FindFirstChild("TextLabel")
    if lbl and lbl.Text and lbl.Text ~= "Empty Base" then
      local owner = lbl.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
      local r = (owner == LP.DisplayName) or (owner == LP.Name)
      _GACC.plotCache[plotName] = r
      _GACC.plotCacheTime[plotName] = ct
      return r
    end
  end
  _GACC.plotCache[plotName] = false
  _GACC.plotCacheTime[plotName] = ct
  return false
 end
 -- true when standing close to an enemy podium (triggers Carry Speed)
 _GACC.nearEnemyBase = function(radius)
  local char = LP.Character
  local root = char and char:FindFirstChild("HumanoidRootPart")
  if not root then return false end
  local plots = workspace:FindFirstChild("Plots")
  if not plots then return false end
  local rpos = root.Position
  radius = tonumber(radius) or tonumber(Config.AutoCarryRadius) or 10
  for _, plot in ipairs(plots:GetChildren()) do
    if plot:IsA("Model") and not _GACC.isMyPlotByName(plot.Name) then
      local pods = plot:FindFirstChild("AnimalPodiums")
      if pods then
        for _, pod in ipairs(pods:GetChildren()) do
          local base = pod:FindFirstChild("Base")
          local sp = base and base:FindFirstChild("Spawn")
          if sp and (sp.Position - rpos).Magnitude <= radius then
            return true
          end
        end
      end
    end
  end
  return false
 end
 _GACC._autoCarryLatched = false
 _GACC._autoCarrySuppressed = false
 _GACC._autoCarryWasHolding = false

_GACC.autoCarryDetect=function()
  local c=LP.Character
  if not c then return false end
  for _,n in ipairs({"Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab"}) do
    local x=c:FindFirstChild(n,true)
    if x and ((x:IsA("BoolValue") and x.Value) or (x:IsA("ObjectValue") and x.Value)
      or (x:IsA("StringValue") and x.Value~="")) then
      return true
    end
  end

  for _,x in ipairs(c:GetChildren()) do
    local n=x.Name:lower()
    if x:IsA("Model") and x:FindFirstChildWhichIsA("BasePart",true) then
      if n:find("brainrot") or n:find("animal") or n:find("carry") or n:find("grab") then
        return true
      end
    end
  end
  return false
 end
 local function enable()
  state.waiting=false; state.watchUntil=0
  state.applied=true; state.graceUntil=tick()+0.75
  autoCarryBoost=true
 end
 local function disable()
  state.applied=false; state.waiting=false; state.watchUntil=0; state.graceUntil=0
  autoCarryBoost=false
 end
 _GACC.autoCarryWatch=function(sec)
  if Config.AutoCarrySpeed then
    state.waiting=true; state.watchUntil=tick()+(sec or 1.25)
  end
 end
 _GACC.disableAutoCarry=disable
 RunService.RenderStepped:Connect(function()
  if not Config.AutoCarrySpeed then
    if state.applied or autoCarryBoost then disable() end
    _GACC._autoCarryLatched = false
    _GACC._autoCarrySuppressed = false
    _GACC._autoCarryWasHolding = false
    return
  end
  local c=LP.Character
  local h=c and c:FindFirstChildOfClass("Humanoid")
  local r=c and c:FindFirstChild("HumanoidRootPart")
  if not c or not h or not r then
    disable(); state.stealWasActive=false; return
  end
  local st=h:GetState()
  local hit=st==Enum.HumanoidStateType.Physics or st==Enum.HumanoidStateType.Ragdoll
    or st==Enum.HumanoidStateType.FallingDown
  local stealing=LP:GetAttribute("Stealing")==true or c:GetAttribute("Stealing")==true
  local carrying=_GACC.autoCarryDetect()

  -- Duels-style: near enemy podium -> latch Carry Speed until you drop + leave radius
  local near = false
  pcall(function() near = _GACC.nearEnemyBase(Config.AutoCarryRadius or 10) end)
  local holding = carrying or stealing
  if _GACC._autoCarryWasHolding and not holding then
    -- just dropped: suppress while still near base so you get Normal Speed to escape
    _GACC._autoCarrySuppressed = near
    _GACC._autoCarryLatched = false
  end
  _GACC._autoCarryWasHolding = holding
  if not near then _GACC._autoCarrySuppressed = false end
  if near and not _GACC._autoCarrySuppressed then
    _GACC._autoCarryLatched = true
  elseif _GACC._autoCarryLatched and not holding then
    _GACC._autoCarryLatched = false
  end

  if stealing and not state.stealWasActive then
    state.stealWasActive=true; enable()
  elseif not stealing then
    state.stealWasActive=false
  end
  if state.waiting then
    if hit or tick()>state.watchUntil then
      state.waiting=false; state.watchUntil=0
    elseif carrying then
      enable()
    end
  end
  if (carrying or _GACC._autoCarryLatched) and not state.applied then enable() end
  -- stay in carry while latched near enemy base (even before grab completes)
  if _GACC._autoCarryLatched and not state.applied then enable() end
  if state.applied and not _GACC._autoCarryLatched and (hit or (tick()>state.graceUntil and not carrying and not stealing)) then
    disable()
  end
 end)
end)()





sectionLabel(movement, "Speed Settings")


normRow = rowBase(movement, "Normal Speed", false)
keybindBadge(normRow, Config.CarrySpeedKey or "None", -156, 48, function(key)
    Config.CarrySpeedKey = key
end)
numberBadge(normRow, Config.NormalSpeed, -102, 40, function(val)
    Config.NormalSpeed = val
end)
numberBadge(normRow, Config.CarrySpeed, -56, 40, function(val)
    Config.CarrySpeed = val
end)

laggerRow = rowBase(movement, "Lagger Speed", false)
keybindBadge(laggerRow, Config.LaggerSpeedKey or Config.LaggerCarryKey or "None", -156, 48, function(key)
    Config.LaggerSpeedKey = key
    Config.LaggerCarryKey = key
end)
numberBadge(laggerRow, Config.LaggerSpeed, -102, 40, function(val)
    Config.LaggerSpeed = val
end)
numberBadge(laggerRow, Config.LaggerCarry, -56, 40, function(val)
    Config.LaggerCarry = val
end)

toggleRow(movement, "Auto Carry Speed", Config.AutoCarrySpeed, function(state)
    Config.AutoCarrySpeed = state
    saveConfig()
end)
do
    local radiusRow = rowBase(movement, "Carry Near Radius", false)
    numberBadge(radiusRow, Config.AutoCarryRadius or 10, -60, 44, function(val)
        Config.AutoCarryRadius = math.clamp(tonumber(val) or 10, 1, 80)
        saveConfig()
    end)
end

sectionLabel(movement, "Teleport")
toggleWithNumberRow(movement, "Auto TP Down", Config.AutoTPDown, Config.TPDownHeight, function(state)
    Config.AutoTPDown = state
    if state then
        startAutoTPDown()
    else
        stopAutoTPDown()
    end
    saveConfig()
end, function(val)
    Config.TPDownHeight = val
    saveConfig()
end)

sectionLabel(movement, "AUTO PATHS")

do
autoLeftRow, autoRightRow, autoPlayRow = nil, nil, nil
function renderAutoDirectionRows()
    if autoLeftRow then autoLeftRow:Destroy(); autoLeftRow = nil end
    if autoRightRow then autoRightRow:Destroy(); autoRightRow = nil end
    mobBtnRefs.autoLeft = nil
    mobBtnRefs.autoRight = nil
    if Config.AutoPlayMode ~= "2 Btn" then return end

    autoLeftRow = rowBase(movement, "Auto Left", false)
    celestialForceRowThemeOutline(autoLeftRow)
    mobBtnRefs.autoLeft = function(enabled) setRowGlow(autoLeftRow, enabled) end
    setRowGlow(autoLeftRow, Config.AutoLeft == true)
    keybindBadge(autoLeftRow, Config.AutoLeftKey, -60, 34, function(key)
        Config.AutoLeftKey = key
        saveConfig()
    end)
    celestialForceRowThemeOutline(autoLeftRow)

    autoRightRow = rowBase(movement, "Auto Right", false)
    celestialForceRowThemeOutline(autoRightRow)
    mobBtnRefs.autoRight = function(enabled) setRowGlow(autoRightRow, enabled) end
    setRowGlow(autoRightRow, Config.AutoRight == true)
    keybindBadge(autoRightRow, Config.AutoRightKey, -60, 34, function(key)
        Config.AutoRightKey = key
        saveConfig()
    end)
    celestialForceRowThemeOutline(autoRightRow)
end

function renderAutoPlayKeybindRow()
    if autoPlayRow then autoPlayRow:Destroy(); autoPlayRow = nil end
    mobBtnRefs.autoPlay = nil
    if Config.AutoPlayMode ~= "1 Btn" then return end
    autoPlayRow = rowBase(movement, "Auto Play", false)
    celestialForceRowThemeOutline(autoPlayRow)
    mobBtnRefs.autoPlay = function(enabled) setRowGlow(autoPlayRow, enabled) end
    setRowGlow(autoPlayRow, Config.AutoLeft == true or Config.AutoRight == true)
    keybindBadge(autoPlayRow, Config.AutoPlayKey or "P", -60, 34, function(key)
        Config.AutoPlayKey = key
        saveConfig()
    end)
    celestialForceRowThemeOutline(autoPlayRow)
end

cycleSelectorRow(movement, "Auto Play Modes", {"1 Btn", "2 Btn"}, Config.AutoPlayMode or "1 Btn", function(mode)
    Config.AutoPlayMode = mode
    if mode == "1 Btn" then
        Config.AutoLeft = false
        Config.AutoRight = false
        if stopAutoLeft then stopAutoLeft() end
        if stopAutoRight then stopAutoRight() end
    end
    renderAutoPlayKeybindRow()
    renderAutoDirectionRows()
    saveConfig()
    if _G.CelestialApplyMobileButtonSize then task.defer(_G.CelestialApplyMobileButtonSize) end
end)
renderAutoPlayKeybindRow()
renderAutoDirectionRows()
end -- scoped Auto Play UI rows




sectionLabel(combat, "Aim Assist")

local startBatAimbot, stopBatAimbot, startBypassAimbot, stopBypassAimbot
local startAntiDie, stopAntiDie, syncAutoAntiDie
local startSpin, stopSpin
local setSpinGuiVisual
spinWasEnabledBeforeBat = false
local applyBatSpinRule
local startAutoStealSystem, stopAutoStealSystem
local startAutoLeft, stopAutoLeft, startAutoRight, stopAutoRight
local startBatCounter, stopBatCounter, startMedusaCounter, stopMedusaCounter
local startPlayerEsp, stopPlayerEsp, startPlayerTracers, stopPlayerTracers
local hookRagdollCountdown, stopRagdollCountdown
local applyCustomSky, applyAnimPack
local enableAntiLag, disableAntiLag, enableStretchRez, disableStretchRez
local enableCustomFov, disableCustomFov
local setNoCamCollision
local StealSys
local refreshStealBarMeta
mirrorTPActive = false
mirrorTPPreviousY = {}
mirrorTPDownEnabled = Config.MirrorTPDown == true
mirrorTPDownSetVisual = nil

function celestialEquipBatOnce()
    local character = LP.Character
    local backpack = LP:FindFirstChildOfClass("Backpack")
    local function isBatTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local name = tool.Name:lower()
        return name:find("bat", 1, true) ~= nil or name:find("slap", 1, true) ~= nil
    end
    if character then
        local equipped = character:FindFirstChildOfClass("Tool")
        if isBatTool(equipped) then return true end
    end
    if not character or not backpack then return false end
    for _, tool in ipairs(backpack:GetChildren()) do
        if isBatTool(tool) then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                pcall(function() humanoid:EquipTool(tool) end)
                return true
            end
        end
    end
    return false
end

batAimbotRow = toggleWithKeybindRow(combat, "Bat Aimbot", Config.BatAimbot, Config.BatAimbotKey, function(state)
    Config.BatAimbot = state
    State.autoBatToggled = state
    if mobBtnRefs and mobBtnRefs.autoBat then pcall(mobBtnRefs.autoBat, state) end
    if _G.CelestialSetBatAimbotUI then pcall(_G.CelestialSetBatAimbotUI, state) end
    if applyBatSpinRule then pcall(applyBatSpinRule, state) end
    if state then
        celestialEquipBatOnce()
        if startBatAimbot then startBatAimbot() end
    else
        if stopBatAimbot then stopBatAimbot() end
    end
end, function(key)
    Config.BatAimbotKey = key
end)

if batAimbotRow then
    celestialForceRowThemeOutline(batAimbotRow)
    setRowGlow(batAimbotRow, Config.BatAimbot == true or State.autoBatToggled == true)
end


aimbotSpeedRow = rowBase(combat, "Aimbot Speed", false)
numberBadge(aimbotSpeedRow, Config.AimbotSpeed, -60, 44, function(val)
    Config.AimbotSpeed = val
end)

autoSwingRow, setAutoSwingVisual = toggleRow(combat, "Auto Swing", Config.AutoSwing, function(state)
    Config.AutoSwing = state
    if state then celestialEquipBatOnce() end
end)


toggleRow(combat, "Mirror TP Down", Config.MirrorTPDown, function(state)
    Config.MirrorTPDown = state
    mirrorTPDownEnabled = state
    if not state then table.clear(mirrorTPPreviousY) end
    saveConfig()
end)

sectionLabel(combat, "AUTO STEAL")

toggleRow(combat, "Auto Steal", Config.AutoSteal, function(state)
    Config.AutoSteal = state
    if state then
        if os.clock() >= (Config._AutoStealHitPauseUntil or 0) then
            startAutoStealSystem()
        end
    else
        stopAutoStealSystem()
    end
end)

toggleRow(combat, "Ragdoll Steal", Config.AutoStealStopWhenHit, function(state)
    Config.AutoStealStopWhenHit = state
    if not state and os.clock() < (Config._AutoStealHitPauseUntil or 0) then
        Config._AutoStealHitPauseUntil = 0
        if Config.AutoSteal then
            stopAutoStealSystem()
            startAutoStealSystem()
        end
    end
    saveConfig()
end)

local stealVersionRow
local stealStopAtRow
local setStealRadiusBadge


if not Config.AutoStealRadiusNormal then Config.AutoStealRadiusNormal = 61 end
if not Config.AutoStealRadiusSemi then Config.AutoStealRadiusSemi = 9 end
if Config.AutoStealMode == "Semi" then
    Config.AutoStealRadius = Config.AutoStealRadiusSemi or 9
else
    Config.AutoStealRadius = Config.AutoStealRadiusNormal or 61
end

modeButtonsRow(combat, { "Normal", "Semi" }, Config.AutoStealMode, function(mode)
    Config.AutoStealMode = mode
    if mode == "Semi" then
        Config.AutoStealRadius = Config.AutoStealRadiusSemi or 9
        if stealVersionRow then stealVersionRow.Visible = false end
        if stealStopAtRow then stealStopAtRow.Visible = false end
    else
        Config.AutoStealRadius = Config.AutoStealRadiusNormal or 61
        if stealVersionRow then stealVersionRow.Visible = true end
        if stealStopAtRow then stealStopAtRow.Visible = Config.AutoStealVersion == "V2" end
    end
    if setStealRadiusBadge then setStealRadiusBadge(Config.AutoStealRadius) end
    pcall(function() refreshStealBarMeta() end)
    if Config.AutoSteal then
        stopAutoStealSystem()
        if os.clock() >= (Config._AutoStealHitPauseUntil or 0) then startAutoStealSystem() end
    end
end)


if Config.AutoStealVersion == "V3" then Config.AutoStealVersion = "V2" end

stealVersionRow = modeButtonsRow(combat, { "V1", "V2" }, Config.AutoStealVersion, function(ver)
    Config.AutoStealVersion = ver
    if stealStopAtRow then
        stealStopAtRow.Visible = Config.AutoStealMode ~= "Semi" and ver == "V2"
    end
    pcall(function() refreshStealBarMeta() end)
    if Config.AutoSteal then
        stopAutoStealSystem()
        if os.clock() >= (Config._AutoStealHitPauseUntil or 0) then startAutoStealSystem() end
    end
end)
if Config.AutoStealMode == "Semi" then
    stealVersionRow.Visible = false
end

Config.AutoStealStopAt = ({[75]=75,[80]=80,[85]=85,[90]=90,[95]=95})[tonumber(Config.AutoStealStopAt)] or 75
stealStopAtRow = rowBase(combat, "Stop At", false)
stopAtChoices = { 75, 80, 85, 90, 95 }
stopAtButtons = {}
function refreshStopAtButtons()
    for percent, button in pairs(stopAtButtons) do
        local active = percent == Config.AutoStealStopAt
        button.TextColor3 = Color3.fromRGB(255, 255, 255)
        local outline = button:FindFirstChildOfClass("UIStroke")
        if outline then
            outline.Color = active and celestialAccentColor() or celestialSoftColor()
            outline:SetAttribute("CelestialHubThemeAccentStroke", true)
            outline.Transparency = active and 0 or 0.45
            outline.Thickness = active and 2 or 1.2
        end
    end
end
for index, percent in ipairs(stopAtChoices) do
    local button = Instance.new("TextButton")
    button.Name = "StopAt" .. tostring(percent)
    button.Text = tostring(percent) .. "%"
    button.Font = Enum.Font.GothamBlack
    button.TextSize = 10
    button.TextColor3 = Color3.fromRGB(255, 255, 255)
    button.AutoButtonColor = false
    button.Size = UDim2.new(0, 30, 0, 26)
    button.Position = UDim2.new(1, -160 + (index - 1) * 31, 0.5, -13)
    button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    button.BorderSizePixel = 0
    button.Parent = stealStopAtRow
    corner(button, 6)
    local stopAtStroke = stroke(button, 1.2, celestialSoftColor(), 0.45)
    stopAtStroke:SetAttribute("CelestialHubThemeAccentStroke", true)
    stopAtButtons[percent] = button
    button.Activated:Connect(function()
        Config.AutoStealStopAt = percent
        refreshStopAtButtons()
        saveConfig()
        if Config.AutoSteal then
            stopAutoStealSystem()
            if os.clock() >= (Config._AutoStealHitPauseUntil or 0) then startAutoStealSystem() end
        end
    end)
end
refreshStopAtButtons()
stealStopAtRow.Visible = Config.AutoStealMode ~= "Semi" and Config.AutoStealVersion == "V2"

stealRadiusRow = rowBase(combat, "Steal Radius", false)
_, _, setRad = numberBadge(stealRadiusRow, Config.AutoStealRadius, -60, 44, function(val)
    Config.AutoStealRadius = val
    if Config.AutoStealMode == "Semi" then
        Config.AutoStealRadiusSemi = val
    else
        Config.AutoStealRadiusNormal = val
    end
    pcall(function() refreshStealBarMeta() end)
end)
setStealRadiusBadge = setRad




function safeModeHoldingBrainrot() local ok,x=pcall(function() return LP:GetAttribute("Stealing") end);if ok and x then return true end;local ok2,x2=pcall(function() return LP:GetAttribute("AntiKick") end);if ok2 and x2 then return true end;local c=LP.Character;if c then local ok3,x3=pcall(function() return c:GetAttribute("Stealing") end);if ok3 and x3 then return true end end;if _GACC.autoCarryDetect then local ok4,x4=pcall(_GACC.autoCarryDetect);if ok4 and x4 then return true end end;return false end
function safeModeIsLocked() return Config.SafeMode and safeModeHoldingBrainrot() end
function safeModeAllowsAction(a) if not Config.SafeMode then return true end;if a=="drop" or a=="tpDown" or a=="reset" or a=="carrySpeed" or a=="laggerCarry" or a=="lagger" then return true end;return not safeModeIsLocked() end
function safeModeForceStop(reason) if not Config.SafeMode then return end;if State.autoBatToggled then if stopBatAimbot then stopBatAimbot() end;State.autoBatToggled=false;Config.BatAimbot=false end;if State.bypassAimbotToggled then local sf=stopBypassAimbot or _G.CelestialStopBypassAimbot;if sf then pcall(sf) end;State.bypassAimbotToggled=false;Config.BypassAimbot=false end;if Config.AutoLeft then if stopAutoLeft then stopAutoLeft() end;Config.AutoLeft=false end;if Config.AutoRight then if stopAutoRight then stopAutoRight() end;Config.AutoRight=false end;end
function safeModeTryStart() if safeModeIsLocked() then safeModeForceStop("SAFE MODE LOCK");return false end;return true end
if not _G.__CelestialSafeModeMonitorStarted then _G.__CelestialSafeModeMonitorStarted=true;RunService.Heartbeat:Connect(function() if Config.SafeMode and safeModeIsLocked() then pcall(safeModeForceStop,"SAFE MODE LOCK") end end) end

misc = makePage("Misc")
sectionLabel(misc, "JUMP")
toggleRow(misc, "Infinite Jump", Config.InfiniteJump, function(state)
    Config.InfiniteJump = state == true
    saveConfig()
end)
antiRagdollRow, setAntiRagdollVisual = toggleRow(misc, "Anti Ragdoll", Config.AntiRagdoll, function(state)
    Config.AntiRagdoll = state
    if state then
        if Config.AntiRagdollMode == "V2" then
            if _G._CelestialStartAntiRagdollV2 then _G._CelestialStartAntiRagdollV2() end
        elseif _G._CelestialStartAntiRagdoll then
            _G._CelestialStartAntiRagdoll()
        end
    else
        if _G._CelestialStopAntiRagdoll then _G._CelestialStopAntiRagdoll() end
        if _G._CelestialStopAntiRagdollV2 then _G._CelestialStopAntiRagdollV2() end
    end
end)

antiRagModeButtons = {}
function setAntiRagdollMode(mode)
    mode = mode == "V2" and "V2" or "V1"
    Config.AntiRagdollMode = mode
    for name, button in pairs(antiRagModeButtons) do
        local selected = name == mode
        button.BackgroundColor3 = selected and (COLORS.Accent or Color3.fromRGB(0, 220, 255)) or Color3.fromRGB(0,0,0)
        button.TextColor3 = Color3.fromRGB(255,255,255)
        local outline = button:FindFirstChildOfClass("UIStroke")
        if outline then outline.Thickness = selected and 2 or 1; outline.Transparency = selected and 0 or 0.3 end
    end
    if Config.AntiRagdoll then
        if _G._CelestialStopAntiRagdoll then _G._CelestialStopAntiRagdoll() end
        if _G._CelestialStopAntiRagdollV2 then _G._CelestialStopAntiRagdollV2() end
        if mode == "V2" then
            if _G._CelestialStartAntiRagdollV2 then _G._CelestialStartAntiRagdollV2() end
        elseif _G._CelestialStartAntiRagdoll then
            _G._CelestialStartAntiRagdoll()
        end
    end
    saveConfig()
end
for index, mode in ipairs({"V1", "V2"}) do
    local button = Instance.new("TextButton")
    button.Name = "AntiRagdoll" .. mode
    button.Size = UDim2.new(0, 30, 0, 24)
    button.Position = UDim2.new(1, index == 1 and -132 or -98, 0.5, -12)
    button.BackgroundColor3 = Color3.fromRGB(0,0,0)
    button.BorderSizePixel = 0
    button.AutoButtonColor = false
    button.Text = mode
    button.TextColor3 = Color3.fromRGB(255,255,255)
    button.TextSize = 11
    button.Font = Enum.Font.GothamBold
    button.Parent = antiRagdollRow
    corner(button, 6)
    stroke(button, 1.2, _G.CelestialThemeAccent or COLORS.Accent or Color3.fromRGB(0, 220, 255), 0.2)
    button.Activated:Connect(function() setAntiRagdollMode(mode) end)
    antiRagModeButtons[mode] = button
end
setAntiRagdollMode(Config.AntiRagdollMode or "V1")

toggleRow(misc, "Ragdoll Countdown", Config.RagdollCountdown, function(state)
    Config.RagdollCountdown = state
    if state then
        if type(hookRagdollCountdown) == "function" and LP.Character then
            pcall(hookRagdollCountdown, LP.Character)
        end
    else
        if type(stopRagdollCountdown) == "function" then pcall(stopRagdollCountdown) end
    end
    saveConfig()
end)

sectionLabel(misc, "COUNTERS")
toggleRow(misc, "Bat Counter", Config.BatCounter, function(state)
    Config.BatCounter = state
    if state then startBatCounter() else stopBatCounter() end
end)
toggleRow(misc, "Medusa Counter", Config.MedusaCounter, function(state)
    Config.MedusaCounter = state
    if state then startMedusaCounter() else stopMedusaCounter() end
end)

sectionLabel(misc, "SAFETY")

toggleRow(misc, "Safe Mode", Config.SafeMode, function(state)
    Config.SafeMode = state
    if state then
        safeModeForceStop("SAFE MODE LOCK")
        if Config.AutoSteal and stopAutoStealSystem then
            Config.AutoSteal = false
            pcall(stopAutoStealSystem)
        end
    end
end)

toggleRow(misc, "Anti Die", Config.AntiDie, function(state)
    Config.AntiDie = state
    if syncAutoAntiDie then
        pcall(syncAutoAntiDie)
    elseif state then
        if startAntiDie then pcall(startAntiDie) end
    else
        if stopAntiDie then pcall(stopAntiDie) end
    end
    saveConfig()
end)

local spinRow
spinRow, setSpinGuiVisual = toggleRow(misc, "Spin", Config.Spin, function(state)
    if state and (Config.BatAimbot or State.autoBatToggled) then
        Config.Spin = false
        if stopSpin then pcall(stopSpin) end
        if setSpinGuiVisual then pcall(setSpinGuiVisual, false) end
    else
        if Config.AutoBrainrot then
            Config.Spin = state == true and characterHasBrainrotEquipped()
        else
            Config.Spin = state == true
        end
        if Config.Spin then
            if startSpin then pcall(startSpin) end
        else
            if stopSpin then pcall(stopSpin) end
        end
        if setSpinGuiVisual then pcall(setSpinGuiVisual, Config.Spin) end
    end
    if syncAutoAntiDie then pcall(syncAutoAntiDie) end
    saveConfig()
end)


local autoBrainrotRow, setAutoBrainrotVisual
autoBrainrotExpanded = false
autoBrainrotExpandButton = Instance.new("TextButton")
autoBrainrotExpandButton.Name = "AutoBrainrotExpand"
autoBrainrotExpandButton.Size = UDim2.new(0, 22, 0, 22)
autoBrainrotExpandButton.Position = UDim2.new(1, -88, 0.5, -11)
autoBrainrotExpandButton.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
autoBrainrotExpandButton.BackgroundTransparency = 0
autoBrainrotExpandButton.BorderSizePixel = 0
autoBrainrotExpandButton.AutoButtonColor = false
autoBrainrotExpandButton.Text = ">"
autoBrainrotExpandButton.TextColor3 = _G.CelestialThemeAccent or celestialAccentColor()
autoBrainrotExpandButton.TextSize = 20
autoBrainrotExpandButton.Font = Enum.Font.GothamBold
autoBrainrotExpandButton.Parent = spinRow
spinTrack = spinRow:FindFirstChildWhichIsA("TextButton")
if spinTrack then
    spinTrack.Position = UDim2.new(1, -60, 0.5, -12)
end
corner(autoBrainrotExpandButton, 6)
autoBrainrotExpandStroke = stroke(autoBrainrotExpandButton, 1.2, _G.CelestialThemeAccent or celestialAccentColor(), 0.15)
autoBrainrotExpandButton.Activated:Connect(function()
    autoBrainrotExpanded = not autoBrainrotExpanded
    autoBrainrotExpandButton.Text = autoBrainrotExpanded and "⌄" or "›"
    autoBrainrotExpandButton.TextColor3 = _G.CelestialThemeAccent or celestialAccentColor()
    autoBrainrotExpandStroke.Color = _G.CelestialThemeAccent or celestialAccentColor()
    if autoBrainrotRow then
        autoBrainrotRow.Visible = autoBrainrotExpanded
    end
end)

local autoBrainrotSwingVisual
autoBrainrotActive = false
local autoBrainrotConn
function characterHasBrainrotEquipped()
    local character = LP.Character
    if not character then return false end

    local okSteal, stealing = pcall(function()
        return LP:GetAttribute("Stealing") == true
            or character:GetAttribute("Stealing") == true
    end)
    if okSteal and stealing then return true end

    if _GACC and type(_GACC.autoCarryDetect) == "function" then
        local ok, carrying = pcall(_GACC.autoCarryDetect)
        if ok and carrying == true then return true end
    end

    for _, item in ipairs(character:GetChildren()) do
        if item:IsA("Model") then
            local name = item.Name:lower()
            if (name:find("brainrot", 1, true) or name:find("animal", 1, true))
                and item:FindFirstChildWhichIsA("BasePart", true) then
                return true
            end
        end
    end

    return false
end

function updateAutoBrainrot()
    if Config.AutoBrainrot ~= true then
        autoBrainrotActive = false
        return
    end

    local shouldBeActive = characterHasBrainrotEquipped()
    local stateChanged = shouldBeActive ~= autoBrainrotActive
    local spinOutOfSync = (Config.Spin == true) ~= shouldBeActive
    autoBrainrotActive = shouldBeActive

    if stateChanged or spinOutOfSync then
        Config.Spin = shouldBeActive
        if shouldBeActive then
            if startSpin then pcall(startSpin) end
        else
            if stopSpin then pcall(stopSpin) end
        end
        if setSpinGuiVisual then pcall(setSpinGuiVisual, shouldBeActive) end
        if syncAutoAntiDie then pcall(syncAutoAntiDie) end
    end
end

autoBrainrotRow, setAutoBrainrotVisual = toggleRow(misc, "    Auto Brainrot", Config.AutoBrainrot, function(state)
    Config.AutoBrainrot = state == true
    if not state then
        autoBrainrotActive = false
        if setSpinGuiVisual then pcall(setSpinGuiVisual, Config.Spin == true) end
        if syncAutoAntiDie then pcall(syncAutoAntiDie) end
    else
        updateAutoBrainrot()
    end
    saveConfig()
end)
autoBrainrotRow.Visible = false
autoBrainrotRow.LayoutOrder = spinRow.LayoutOrder + 1
autoBrainrotSwingVisual = function(state)
end
if autoBrainrotConn then autoBrainrotConn:Disconnect() end
autoBrainrotConn = RunService.Heartbeat:Connect(updateAutoBrainrot)


applyBatSpinRule = function(enabled)
    if enabled then
        if Config.Spin == true then
            spinWasEnabledBeforeBat = true
            Config.Spin = false
            if stopSpin then pcall(stopSpin) end
            if setSpinGuiVisual then pcall(setSpinGuiVisual, false) end
        end
    else
        if spinWasEnabledBeforeBat then
            Config.Spin = true
            if startSpin then pcall(startSpin) end
            if setSpinGuiVisual then pcall(setSpinGuiVisual, true) end
        end
        spinWasEnabledBeforeBat = false
    end
    if syncAutoAntiDie then pcall(syncAutoAntiDie) end
    saveConfig()
end

if Config.BatAimbot or State.autoBatToggled then
    if mobBtnRefs and mobBtnRefs.autoBat then pcall(mobBtnRefs.autoBat, true) end
    if _G.CelestialSetBatAimbotUI then pcall(_G.CelestialSetBatAimbotUI, true) end
    if applyBatSpinRule then pcall(applyBatSpinRule, true) end
end

sectionLabel(misc, "ACTIONS")

dropActionRow = rowBase(misc, "Drop", false)
setRowGlow(dropActionRow, false)
keybindBadge(dropActionRow, Config.DropKey, -60, 48, function(key)
    Config.DropKey = key
end)

tpDownActionRow = rowBase(misc, "TP Down", false)
keybindBadge(tpDownActionRow, Config.TPDownKey, -60, 48, function(key)
    Config.TPDownKey = key
end)

instaResetActionRow = rowBase(misc, "Instant Reset", false)
keybindBadge(instaResetActionRow, Config.InstaResetKey, -60, 48, function(key)
    Config.InstaResetKey = key
end)


CELESTIAL_BAT_SKIN_ASSETS = {
    Scythe = "8699386664",
    ["Ban Hammer"] = "14701192921",
    ["Minecraft Sword"] = "minecraft_mesh",
}
CELESTIAL_BAT_SKIN_ADJUST = {
    Scythe = {x = 0.09, y = -1, z = -0.8, rx = 0, ry = -90, rz = 0, size = 6},
    ["Ban Hammer"] = {x = 0, y = -1, z = 0, rx = 0, ry = 180, rz = 0, size = 4},
}
CELESTIAL_BAT_SKIN_FOLDER = "CelestialHubBatSkin"

function celestialIsBatTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local n = string.lower(tool.Name or "")
    return string.find(n, "bat", 1, true) ~= nil or string.find(n, "slap", 1, true) ~= nil
end

function celestialGetHandle(tool)
    return tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart", true)
end

CELESTIAL_BAT_SKIN_ANIM_CONNECTIONS = setmetatable({}, {__mode = "k"})

function celestialRestoreBatTool(tool)
    if CELESTIAL_BAT_SKIN_ANIM_CONNECTIONS[tool] then
        pcall(function() CELESTIAL_BAT_SKIN_ANIM_CONNECTIONS[tool]:Disconnect() end)
        CELESTIAL_BAT_SKIN_ANIM_CONNECTIONS[tool] = nil
    end
    local oldFolder = tool:FindFirstChild(CELESTIAL_BAT_SKIN_FOLDER)
    if oldFolder then pcall(function() oldFolder:Destroy() end) end
    for _, obj in ipairs(tool:GetDescendants()) do
        if obj:IsA("BasePart") and obj:GetAttribute("CelestialHubBatSkinHidden") then
            pcall(function()
                obj.LocalTransparencyModifier = obj:GetAttribute("CelestialHubOldLTM") or 0
                obj.Transparency = obj:GetAttribute("CelestialHubOldTransparency") or 0
                obj.CastShadow = true
                obj:SetAttribute("CelestialHubBatSkinHidden", nil)
                obj:SetAttribute("CelestialHubOldLTM", nil)
                obj:SetAttribute("CelestialHubOldTransparency", nil)
            end)
        end
    end
end

function celestialHideBatOriginal(tool)
    for _, obj in ipairs(tool:GetDescendants()) do
        if obj:IsA("BasePart") and not obj:GetAttribute("CelestialHubBatSkinPart") then
            if not obj:GetAttribute("CelestialHubBatSkinHidden") then
                obj:SetAttribute("CelestialHubOldLTM", obj.LocalTransparencyModifier)
                obj:SetAttribute("CelestialHubOldTransparency", obj.Transparency)
                obj:SetAttribute("CelestialHubBatSkinHidden", true)
            end
            obj.LocalTransparencyModifier = 1
            obj.Transparency = 1
            obj.CastShadow = false
        end
    end
end

function celestialMakeSkinPart(parent, name, size, color, material)
    local p = Instance.new("Part")
    p.Name = name
    p.Size = size
    p.Color = color
    p.Material = material or Enum.Material.Metal
    p.Anchored = false
    p.CanCollide = false
    p.CanTouch = false
    p.CanQuery = false
    p.Massless = true
    p:SetAttribute("CelestialHubBatSkinPart", true)
    p.Parent = parent
    return p
end

function celestialWeldSkin(handle, part, offset)
    part.CFrame = handle.CFrame * (offset or CFrame.new())
    local weld = Instance.new("WeldConstraint")
    weld.Part0 = handle
    weld.Part1 = part
    weld.Parent = part
end

CELESTIAL_BAT_SKIN_CONNECTIONS = setmetatable({}, {__mode = "k"})
CELESTIAL_BAT_SKIN_SOUNDS = {
    Katana = "rbxassetid://111808555599832",
    ["Minecraft Sword"] = "rbxassetid://12222216",
}

celestialSwingSoundLastAt = 0

function celestialMuteDefaultSlash(tool)
    if not tool then return end
    local slash = tool:FindFirstChild("Slash")
    if slash and slash:IsA("Sound") then
        slash.Volume = 0
        slash.Playing = false
    end
end

function celestialEnsureSwingSound(tool, soundId)
    if not tool or not soundId then return nil end
    local handle = tool:FindFirstChild("Handle") or tool
    local s = tool:FindFirstChild("CelestialHubSwingSound") or (handle and handle:FindFirstChild("CelestialHubSwingSound"))
    if not s then
        s = Instance.new("Sound")
        s.Name = "CelestialHubSwingSound"
        s.Volume = 1
        s.RollOffMode = Enum.RollOffMode.InverseTapered
        s.Parent = handle or tool
    end
    if s.SoundId ~= soundId then
        s.SoundId = soundId
    end
    return s
end

function celestialPlaySwingSound(tool, skin)
    skin = skin or Config.BatSkin
    local soundId = CELESTIAL_BAT_SKIN_SOUNDS[skin]
    if not soundId or not tool then return end
    celestialMuteDefaultSlash(tool)
    local now = tick()
    local cooldown = (skin == "Minecraft Sword") and 0.1 or 0.2
    if now - celestialSwingSoundLastAt < cooldown then return end
    celestialSwingSoundLastAt = now
    local s = celestialEnsureSwingSound(tool, soundId)
    if not s then return end
    pcall(function()
        s:Stop()
        if skin == "Minecraft Sword" then
            s.PlaybackSpeed = 1.45
            s.TimePosition = 0
            s.Volume = 1
        else
            s.PlaybackSpeed = 1
            s.TimePosition = 0
            s.Volume = 0.95
        end
        s:Play()
    end)
end

function celestialSetupBatSkinEffects(tool, skin, folder)
    if not tool or not folder or not folder.Parent then return end
    local handle = celestialGetHandle(tool)
    if not handle then return end
    if CELESTIAL_BAT_SKIN_CONNECTIONS[tool] then
        pcall(function() CELESTIAL_BAT_SKIN_CONNECTIONS[tool]:Disconnect() end)
        CELESTIAL_BAT_SKIN_CONNECTIONS[tool] = nil
    end

    local bestPart, bestAxis, bestLength = nil, "Y", 0
    for _, obj in ipairs(folder:GetDescendants()) do
        if obj:IsA("BasePart") then
            local sz = obj.Size
            local axis, length = "Y", sz.Y
            if sz.X > length then axis, length = "X", sz.X end
            if sz.Z > length then axis, length = "Z", sz.Z end
            if length > bestLength then bestPart, bestAxis, bestLength = obj, axis, length end
        end
    end
    if bestPart and bestLength > 0.5 then
        local a0, a1 = Instance.new("Attachment"), Instance.new("Attachment")
        a0.Name, a1.Name = "CelestialBatTrailTop", "CelestialBatTrailBottom"
        local half = bestLength * 0.46
        if bestAxis == "X" then
            a0.Position, a1.Position = Vector3.new(-half, 0, 0), Vector3.new(half, 0, 0)
        elseif bestAxis == "Z" then
            a0.Position, a1.Position = Vector3.new(0, 0, -half), Vector3.new(0, 0, half)
        else
            a0.Position, a1.Position = Vector3.new(0, half, 0), Vector3.new(0, -half, 0)
        end
        a0.Parent, a1.Parent = bestPart, bestPart
        local trail = Instance.new("Trail")
        trail.Name = "CelestialBatSwingTrail"
        trail.Attachment0, trail.Attachment1 = a0, a1
        trail.Color = ColorSequence.new(Color3.fromRGB(255, 180, 70), Color3.fromRGB(255, 95, 0))
        trail.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0.12), NumberSequenceKeypoint.new(1, 1)})
        trail.Lifetime = 0.22
        trail.LightEmission = 0.8
        trail.Enabled = false
        trail.Parent = folder
    end

    if CELESTIAL_BAT_SKIN_SOUNDS[skin] then
        celestialMuteDefaultSlash(tool)
        celestialEnsureSwingSound(tool, CELESTIAL_BAT_SKIN_SOUNDS[skin])
    end

    CELESTIAL_BAT_SKIN_CONNECTIONS[tool] = tool.Activated:Connect(function()
        if not tool.Parent or Config.BatSkin ~= skin then return end
        local trail = folder:FindFirstChild("CelestialBatSwingTrail", true)
        if trail and trail:IsA("Trail") then
            trail.Enabled = true
            task.delay(0.24, function()
                if trail and trail.Parent then trail.Enabled = false end
            end)
        end
        if CELESTIAL_BAT_SKIN_SOUNDS[Config.BatSkin] then
            celestialPlaySwingSound(tool, Config.BatSkin)
        end
    end)
end

function celestialApplyBatSkin(tool)
    if not celestialIsBatTool(tool) then return end
    if Config.BatSkin == "Scythe" or Config.BatSkin == "Ban Hammer" then Config.BatSkin = "Katana" end
    local skin = Config.BatSkin or "Katana"
    if CELESTIAL_BAT_SKIN_CONNECTIONS[tool] then
        pcall(function() CELESTIAL_BAT_SKIN_CONNECTIONS[tool]:Disconnect() end)
        CELESTIAL_BAT_SKIN_CONNECTIONS[tool] = nil
    end
    celestialRestoreBatTool(tool)
    if skin == "None" then return end
    local handle = celestialGetHandle(tool)
    if not handle then return end

    local folder = Instance.new("Folder")
    folder.Name = CELESTIAL_BAT_SKIN_FOLDER
    folder.Parent = tool

    if skin == "Minecraft Sword" then
        celestialHideBatOriginal(tool)
        local swordPart = Instance.new("Part")
        swordPart.Name = "CelestialMinecraftSwordMesh"
        swordPart.Size = Vector3.new(1, 1, 1)
        swordPart.Transparency = 0
        swordPart.Anchored = false
        swordPart.CanCollide = false
        swordPart.CanTouch = false
        swordPart.CanQuery = false
        swordPart.Massless = true
        swordPart:SetAttribute("CelestialHubBatSkinPart", true)
        swordPart.Parent = folder
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = "rbxassetid://8827558932"
        mesh.TextureId = "rbxassetid://8827558969"
        mesh.Scale = Vector3.new(0.2, 0.2, 0.2)
        mesh.Parent = swordPart
        local motor = Instance.new("Motor6D")
        motor.Name = "CelestialMinecraftSwordGrip"
        motor.Part0 = handle
        motor.Part1 = swordPart
        motor.C0 = CFrame.new(-0.05, -0.1, -0.12)
            * CFrame.Angles(math.rad(90), math.rad(180), math.rad(300))
        motor.Parent = handle
        celestialSetupBatSkinEffects(tool, skin, folder)
        return
    end

    if skin == "Katana" then
        celestialHideBatOriginal(tool)
        local blade = celestialMakeSkinPart(folder, "CelestialKatanaBlade",
            Vector3.new(0.19, 4.15, 0.065), Color3.fromRGB(205, 215, 225), Enum.Material.Metal)
        celestialWeldSkin(handle, blade, CFrame.new(0, 1.17, 0))
        local edge = celestialMakeSkinPart(folder, "CelestialKatanaEdge",
            Vector3.new(0.025, 4.05, 0.075), Color3.fromRGB(0, 220, 255), Enum.Material.Neon)
        celestialWeldSkin(handle, edge, CFrame.new(0.105, 1.15, -0.008))
        local guard = celestialMakeSkinPart(folder, "CelestialKatanaGuard",
            Vector3.new(0.78, 0.09, 0.27), Color3.fromRGB(35, 35, 35), Enum.Material.Metal)
        celestialWeldSkin(handle, guard, CFrame.new(0, -0.39, 0))
        local grip = celestialMakeSkinPart(folder, "CelestialKatanaGrip",
            Vector3.new(0.22, 0.82, 0.22), Color3.fromRGB(15, 15, 15), Enum.Material.SmoothPlastic)
        celestialWeldSkin(handle, grip, CFrame.new(0, -1.15, 0))
        for i = 1, 5 do
            local wrap = celestialMakeSkinPart(folder, "CelestialKatanaWrap" .. i,
                Vector3.new(0.235, 0.035, 0.235),
                i % 2 == 0 and Color3.fromRGB(0, 220, 255) or Color3.fromRGB(28, 28, 28),
                Enum.Material.SmoothPlastic)
            celestialWeldSkin(handle, wrap, CFrame.new(0, -1.45 + i * 0.145, 0))
        end
        local pommel = celestialMakeSkinPart(folder, "CelestialKatanaPommel",
            Vector3.new(0.27, 0.13, 0.27), Color3.fromRGB(0, 220, 255), Enum.Material.Metal)
        celestialWeldSkin(handle, pommel, CFrame.new(0, -1.59, 0))
        task.defer(function()
            if tool and tool.Parent and folder and folder.Parent then
                celestialSetupBatSkinEffects(tool, skin, folder)
            end
        end)
        return
    end

    local assetId = CELESTIAL_BAT_SKIN_ASSETS[skin]
    if not assetId then return end
    local ok, objects = pcall(function()
        return game:GetObjects("rbxassetid://" .. assetId)
    end)
    if not ok or not objects or not objects[1] then return end

    local model = objects[1]
    if model:IsA("BasePart") then
        local wrapper = Instance.new("Model")
        wrapper.Name = "CelestialHubBatSkinModel"
        model.Parent = wrapper
        model = wrapper
    end
    model.Name = "CelestialHubBatSkinAsset"
    model.Parent = folder

    local parts = {}
    for _, obj in ipairs(model:GetDescendants()) do
        if obj:IsA("BasePart") then
            table.insert(parts, obj)
            obj.Anchored = false
            obj.CanCollide = false
            obj.CanTouch = false
            obj.CanQuery = false
            obj.Massless = true
            obj:SetAttribute("CelestialHubBatSkinPart", true)
        elseif obj:IsA("Script") or obj:IsA("LocalScript") or obj:IsA("ModuleScript")
            or obj:IsA("ScreenGui") or obj:IsA("BillboardGui") then
            pcall(function() obj:Destroy() end)
        end
    end
    if #parts == 0 then pcall(function() model:Destroy() end); return end

    local adjust = CELESTIAL_BAT_SKIN_ADJUST[skin] or {x = 0, y = 0, z = -0.5, rx = 0, ry = 0, rz = 0, size = 5}
    local bboxSize
    local okBounds = pcall(function()
        local _, size = model:GetBoundingBox()
        bboxSize = size
    end)
    if okBounds and bboxSize then
        local longest = math.max(bboxSize.X, bboxSize.Y, bboxSize.Z)
        if longest > 0 then
            pcall(function() model:ScaleTo(math.clamp((adjust.size or 5) / longest, 0.05, 8)) end)
        end
    end

    local orient = CFrame.new()
    local _, scaledSize = model:GetBoundingBox()
    if scaledSize.X > scaledSize.Y and scaledSize.X > scaledSize.Z then
        orient = CFrame.Angles(0, 0, math.rad(90))
    elseif scaledSize.Z > scaledSize.Y and scaledSize.Z > scaledSize.X then
        orient = CFrame.Angles(math.rad(90), 0, 0)
    end
    local desiredBox = handle.CFrame
        * CFrame.new(adjust.x or 0, adjust.y or 0, adjust.z or 0)
        * orient
        * CFrame.Angles(math.rad(adjust.rx or 0), math.rad(adjust.ry or 0), math.rad(adjust.rz or 0))

    local currentPivot = model:GetPivot()
    local currentBox = select(1, model:GetBoundingBox())
    local boxFromPivot = currentPivot:ToObjectSpace(currentBox)
    pcall(function() model:PivotTo(desiredBox * boxFromPivot:Inverse()) end)

    celestialHideBatOriginal(tool)
    for _, part in ipairs(parts) do
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = handle
        weld.Part1 = part
        weld.Parent = part
    end
    celestialSetupBatSkinEffects(tool, skin, folder)
end

function applyCelestialBatSkinToAll()
    local containers = {}
    if LP.Character then table.insert(containers, LP.Character) end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if backpack then table.insert(containers, backpack) end
    for _, container in ipairs(containers) do
        for _, tool in ipairs(container:GetChildren()) do
            if celestialIsBatTool(tool) then pcall(celestialApplyBatSkin, tool) end
        end
    end
end

function celestialWatchBatContainer(container)
    if not container then return end
    container.ChildAdded:Connect(function(child)
        if celestialIsBatTool(child) then
            task.wait(0.15)
            pcall(celestialApplyBatSkin, child)
        end
    end)
end
celestialWatchBatContainer(LP:FindFirstChildOfClass("Backpack"))
celestialWatchBatContainer(LP.Character)
LP.ChildAdded:Connect(function(child)
    if child:IsA("Backpack") then celestialWatchBatContainer(child) end
end)
LP.CharacterAdded:Connect(function(char)
    task.wait(0.75)
    celestialWatchBatContainer(char)
    pcall(applyCelestialBatSkinToAll)
end)
task.defer(function()
    task.wait(1)
    pcall(applyCelestialBatSkinToAll)
end)

task.spawn(function()
    while true do
        pcall(function()
            local skin = Config.BatSkin
            local soundId = CELESTIAL_BAT_SKIN_SOUNDS[skin]
            if not soundId then return end
            local containers = {LP.Character, LP:FindFirstChildOfClass("Backpack")}
            for _, container in ipairs(containers) do
                if container then
                    for _, tool in ipairs(container:GetChildren()) do
                        if celestialIsBatTool(tool) then
                            celestialMuteDefaultSlash(tool)
                            celestialEnsureSwingSound(tool, soundId)
                        end
                    end
                end
            end
        end)
        task.wait(0.5)
    end
end)

visual = makePage("Visual")


sectionLabel(visual, "ESP")
toggleRow(visual, "ESP", Config.PlayerESP, function(state)
    Config.PlayerESP = state
    Config.PlayerTracers = state
    if state then
        if startPlayerEsp then startPlayerEsp() end
        if startPlayerTracers then startPlayerTracers() end
    else
        if stopPlayerEsp then stopPlayerEsp() end
        if stopPlayerTracers then stopPlayerTracers() end
    end
end)
toggleRow(visual, "Transparency Base", Config.BrainrotTransparencyBase, function(state)
    Config.BrainrotTransparencyBase = state
    if _G.CelestialBrainrotTransparency then
        pcall(_G.CelestialBrainrotTransparency.SetBase, state)
    end
    saveConfig()
end)


sectionLabel(visual, "VISUAL")
toggleRow(visual, "Custom Animation", Config.CustomAnim, function(state)
    customAnimApplyToken = (customAnimApplyToken or 0) + 1
    local applyToken = customAnimApplyToken
    if state and Config.AnimPack == "Unwalk" then
        Config.Unwalk = true
        Config.CustomAnim = false
        if type(startUnwalk) == "function" then pcall(startUnwalk) end
    else
        Config.CustomAnim = state
        if state then
            Config.Unwalk = false
            if type(stopUnwalk) == "function" then pcall(stopUnwalk) end
            task.spawn(function()
                for _, delayTime in ipairs({0, 0.25, 0.75, 1.25}) do
                    if delayTime > 0 then task.wait(delayTime) end
                    if applyToken ~= customAnimApplyToken or not Config.CustomAnim then return end
                    if applyAnimPack then pcall(applyAnimPack, Config.AnimPack) end
                end
            end)
        else
            if restoreCharacterAnimations then pcall(restoreCharacterAnimations, LP.Character) end
        end
    end
    saveConfig()
end)
cycleSelectorRow(visual, "Anim Pack", {"Unwalk","Adidas Sports","Adidas Community","Adidas Aura","Wicked Popular","Elder","Zombie","Mage","Catwalk Glam","Astronaut","Wicked Dancing Through Life","Werewolf","Superhero","Toy","No Boundaries","NFL","Amazon Unboxed","Vampire","Ninja","Robot","Levitation","Stylish","Bubbly","Cartoon"}, Config.Unwalk and "Unwalk" or Config.AnimPack, function(mode)
    if mode == "Unwalk" then
        Config.AnimPack = "Unwalk"
        Config.Unwalk = true
        Config.CustomAnim = false
        if type(startUnwalk) == "function" then pcall(startUnwalk) end
    else
        Config.AnimPack = mode
        if Config.Unwalk then
            Config.Unwalk = false
            if type(stopUnwalk) == "function" then pcall(stopUnwalk) end
        end
        if Config.CustomAnim then
            customAnimApplyToken = (customAnimApplyToken or 0) + 1
            local applyToken = customAnimApplyToken
            task.spawn(function()
                for _, delayTime in ipairs({0, 0.25, 0.75}) do
                    if delayTime > 0 then task.wait(delayTime) end
                    if applyToken ~= customAnimApplyToken or not Config.CustomAnim then return end
                    if applyAnimPack then pcall(applyAnimPack, mode) end
                end
            end)
        end
    end
    saveConfig()
end)
cycleSelectorRow(visual, "Bat Skin", {"Katana", "Minecraft Sword", "None"}, Config.BatSkin, function(skin)
    Config.BatSkin = skin
    if applyCelestialBatSkinToAll then
        task.spawn(function() pcall(applyCelestialBatSkinToAll) end)
    end
    saveConfig()
end)

sectionLabel(visual, "SKY")
cycleSelectorRow(visual, "Sky Theme", {
    "Off", "Night", "Aurora", "Sunset", "Galaxy", "Cyber", "Sakura",
    "Pink Night", "Blood Moon", "Emerald Dawn", "Volcanic", "Arctic", "Midnight Ocean",
    "Vaporwave", "Toxic", "Solar Eclipse", "Hellscape", "Heaven", "Storm", "Sunrise",
    "Deep Space", "Lavender Dream", "Inferno", "Mint Sky"
}, Config.CustomSkyTheme or "Night", function(theme)
    Config.CustomSkyTheme = theme
    Config.CustomSky = theme ~= "Off"
    if applyCustomSky then
        task.spawn(function() pcall(applyCustomSky, theme) end)
    end
    saveConfig()
end)


sectionLabel(visual, "PERFORMANCE")
toggleRow(visual, "Anti Lag", Config.AntiLag, function(state)
    Config.AntiLag = state
    if state then enableAntiLag() else disableAntiLag() end
end)
toggleRow(visual, "Stretch Res", Config.StretchRes, function(state)
    Config.StretchRes = state
    if state then enableStretchRez() else disableStretchRez() end
end)
toggleRow(visual, "FOV Change", Config.FOVChange, function(state)
    Config.FOVChange = state
    if state then enableCustomFov() else disableCustomFov() end
end)
fovRow = rowBase(visual, "FOV Value", false)
numberBadge(fovRow, Config.FOVValue, -60, 44, function(val)
    Config.FOVValue = math.clamp(val, 30, 120)
    if Config.FOVChange then
        pcall(function() workspace.CurrentCamera.FieldOfView = Config.FOVValue end)
    end
end)


do
sectionLabel(visual, "HEADLESS & KORBLOX")

celestialAppearanceState = {
    headless = setmetatable({}, {__mode = "k"}),
    korblox = setmetatable({}, {__mode = "k"}),
}

function setCelestialHeadless(active, character)
    character = character or LP.Character
    local head = character and character:FindFirstChild("Head")
    if not head or not head:IsA("BasePart") then return false end
    if active then
        if not celestialAppearanceState.headless[character] then
            local saved = {
                transparency = head.Transparency,
                localTransparency = head.LocalTransparencyModifier,
                faces = {},
            }
            for _, item in ipairs(head:GetChildren()) do
                if item:IsA("Decal") or item:IsA("Texture") then
                    table.insert(saved.faces, {item = item, transparency = item.Transparency})
                end
            end
            celestialAppearanceState.headless[character] = saved
        end
        head.Transparency = 1
        head.LocalTransparencyModifier = 1
        for _, item in ipairs(head:GetChildren()) do
            if item:IsA("Decal") or item:IsA("Texture") then item.Transparency = 1 end
        end
        return true
    end
    local saved = celestialAppearanceState.headless[character]
    if not saved then return false end
    if head.Parent then
        head.Transparency = saved.transparency
        head.LocalTransparencyModifier = saved.localTransparency
    end
    for _, face in ipairs(saved.faces) do
        if face.item and face.item.Parent then face.item.Transparency = face.transparency end
    end
    celestialAppearanceState.headless[character] = nil
    return true
end

function setCelestialKorblox(active, character)
    character = character or LP.Character
    if not character then return false end
    local saved = celestialAppearanceState.korblox[character]
    local function removeVisual()
        local old = character:FindFirstChild("CelestialVisual_Korblox")
        if old then pcall(function() old:Destroy() end) end
        for _, child in ipairs(character:GetChildren()) do
            if child:IsA("CharacterMesh") and child.Name == "CelestialVisual_KorbloxCharacterMesh" then
                pcall(function() child:Destroy() end)
            end
        end
    end
    if not active then
        removeVisual()
        if not saved then return true end
        for _, partState in ipairs(saved.parts) do
            if partState.part and partState.part.Parent then
                partState.part.Transparency = partState.transparency
                partState.part.LocalTransparencyModifier = partState.localTransparency
            end
        end
        celestialAppearanceState.korblox[character] = nil
        return true
    end

    local target = character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg")
    if not target or not target:IsA("BasePart") then return false end
    local ok, objects = pcall(function() return game:GetObjects("rbxassetid://139607673") end)
    if not ok or type(objects) ~= "table" or not objects[1] then
        warn("Synapse X Celestial Hub Korblox: unable to load visual asset 139607673")
        return false
    end
    removeVisual()
    local visual = Instance.new("Model")
    visual.Name = "CelestialVisual_Korblox"
    for _, object in ipairs(objects) do object.Parent = visual end
    local importedParts, characterMeshes = {}, {}
    for _, descendant in ipairs(visual:GetDescendants()) do
        if descendant:IsA("BasePart") then table.insert(importedParts, descendant) end
        if descendant:IsA("CharacterMesh") then table.insert(characterMeshes, descendant) end
    end
    if #importedParts == 0 and #characterMeshes == 0 then
        visual:Destroy()
        warn("Synapse X Celestial Hub Korblox: asset has no compatible visual parts")
        return false
    end
    if not saved then
        saved = {parts = {}}
        for _, partName in ipairs({"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg"}) do
            local part = character:FindFirstChild(partName)
            if part and part:IsA("BasePart") then
                table.insert(saved.parts, {part = part, transparency = part.Transparency, localTransparency = part.LocalTransparencyModifier})
            end
        end
        celestialAppearanceState.korblox[character] = saved
    end
    visual.Parent = character
    local isR15 = character:FindFirstChild("LeftUpperLeg") ~= nil
    if isR15 then
        for _, partState in ipairs(saved.parts) do
            if partState.part and partState.part.Parent then
                partState.part.Transparency = 1
                partState.part.LocalTransparencyModifier = 1
            end
        end
    end
    for _, part in ipairs(importedParts) do
        local matchingTarget = character:FindFirstChild(part.Name)
        if not matchingTarget or not matchingTarget:IsA("BasePart") then matchingTarget = target end
        part.Anchored = false
        part.CanCollide = false
        part.Massless = true
        part.CFrame = matchingTarget.CFrame
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = matchingTarget
        weld.Part1 = part
        weld.Parent = part
    end
    for _, mesh in ipairs(characterMeshes) do
        mesh.Name = "CelestialVisual_KorbloxCharacterMesh"
        mesh.Parent = character
    end
    return true
end

toggleRow(visual, "Headless", Config.Headless, function(state)
    Config.Headless = state
    setCelestialHeadless(state, LP.Character)
    saveConfig()
end)
toggleRow(visual, "Korblox", Config.Korblox, function(state)
    Config.Korblox = state
    task.spawn(function() setCelestialKorblox(state, LP.Character) end)
    saveConfig()
end)

LP.CharacterAdded:Connect(function(character)
    task.wait(0.75)
    if Config.Headless then pcall(setCelestialHeadless, true, character) end
    if Config.Korblox then task.spawn(function() pcall(setCelestialKorblox, true, character) end) end
end)
task.defer(function()
    task.wait(1)
    if Config.Headless then pcall(setCelestialHeadless, true, LP.Character) end
    if Config.Korblox then task.spawn(function() pcall(setCelestialKorblox, true, LP.Character) end) end
end)
end -- scoped Headless & Korblox locals

settings = makePage("Settings")



main.Active = true
_G.CelestialUILocked = Config.LockUI == true
main.Draggable = not (Config.LockUI == true)
if Config.HideUI then
    main.Visible = false
    uiMinimized = true
    miniRestoreButton.Visible = true
else
    main.Visible = true
    miniRestoreButton.Visible = false
end

sectionLabel(settings, "UI")

do
    local BACKGROUND_URLS = {
        [1] = "embedded://celestial_cyan_purple_v2.jpg",
        [2] = "embedded://celestial_tanjiro_v2.jpg",
        [3] = "embedded://celestial_pagoda_v2.jpg",
        [4] = "embedded://celestial_black_v2.jpg",
    }
    local NUM_BG = #BACKGROUND_URLS

    task.spawn(function()
        for i = 1, NUM_BG do
            local url = BACKGROUND_URLS[i]
            if url and url:sub(1, 11) ~= "embedded://" and not cachedBackgroundAsset(url) then
                task.spawn(function()
                    local data
                    pcall(function() data = game:HttpGet(url) end)
                    if not data or #data < 100 then
                        pcall(function()
                            local req = request or http_request or (syn and syn.request)
                            if not req then return end
                            local res = req({Url = url, Method = "GET"})
                            if res then data = res.Body or res.body end
                        end)
                    end
                    if data and #data > 100 and writefile then
                        pcall(function() writefile(backgroundCacheFile(url), data) end)
                    end
                end)
                task.wait(0.08)
            end
        end
    end)

    local BACKGROUND_THEMES = {
        [1]  = {accent = Color3.fromRGB(0, 220, 255), soft = Color3.fromRGB(80, 40, 160)},
        [2]  = {accent = Color3.fromRGB(255, 75, 75), soft = Color3.fromRGB(105, 25, 25)},
        [3]  = {accent = Color3.fromRGB(255, 190, 55), soft = Color3.fromRGB(105, 70, 15)},
        [4]  = {accent = Color3.fromRGB(70, 190, 255), soft = Color3.fromRGB(15, 65, 105)},
        [5]  = {accent = Color3.fromRGB(190, 100, 255), soft = Color3.fromRGB(65, 25, 105)},
        [6]  = {accent = Color3.fromRGB(255, 90, 165), soft = Color3.fromRGB(105, 25, 65)},
        [7]  = {accent = Color3.fromRGB(70, 230, 160), soft = Color3.fromRGB(15, 85, 55)},
        [8]  = {accent = Color3.fromRGB(80, 130, 255), soft = Color3.fromRGB(20, 40, 105)},
        [9]  = {accent = Color3.fromRGB(235, 235, 245), soft = Color3.fromRGB(65, 65, 80)},
        [10] = {accent = Color3.fromRGB(255, 215, 110), soft = Color3.fromRGB(100, 75, 25)},
        [11] = {accent = Color3.fromRGB(110, 235, 95), soft = Color3.fromRGB(25, 85, 20)},
        [12] = {accent = Color3.fromRGB(55, 220, 215), soft = Color3.fromRGB(15, 80, 80)},
    }

    local BUTTON_THEMES = {
        Cyan = {accent = Color3.fromRGB(0, 220, 255), soft = Color3.fromRGB(80, 40, 160)},
        Purple = {accent = Color3.fromRGB(175, 95, 255), soft = Color3.fromRGB(64, 30, 128)},
    }
    local function isThemeAccent(c)
        return c == BUTTON_THEMES.Cyan.accent or c == BUTTON_THEMES.Purple.accent
    end
    local function isThemeSoft(c)
        return c == BUTTON_THEMES.Cyan.soft or c == BUTTON_THEMES.Purple.soft
    end

    local function isWarmAccent(c)
        local r, g, b = math.floor(c.R * 255 + 0.5), math.floor(c.G * 255 + 0.5), math.floor(c.B * 255 + 0.5)
        return r >= 95 and r > g * 1.08 and g >= b * 1.08 and b <= 175 and g <= 235
    end
    local function isColoredAccent(c)
        local r, g, b = c.R, c.G, c.B
        local hi = math.max(r, g, b)
        local lo = math.min(r, g, b)
        return hi > 0.16 and (hi - lo) > 0.10 and not (lo > 0.88 and (hi - lo) < 0.12)
    end
    local function applyBackgroundTheme(index)
        local theme = BUTTON_THEMES[Config.ButtonsGuiTheme] or BUTTON_THEMES.Cyan
        _G.CelestialThemeAccent = theme.accent
        _G.CelestialThemeSoft = theme.soft
        if type(_G.CelestialHubRefreshVisualAccents) == "function" then
            pcall(_G.CelestialHubRefreshVisualAccents)
        end
        local oldAccent = COLORS.Accent
        local oldSoft = COLORS.AccentSoft
        COLORS.TabActive = theme.accent
        COLORS.ToggleActive = theme.accent
        COLORS.PurpleText = theme.accent
        COLORS.TextDim = theme.accent
        COLORS.Stroke = theme.accent
        COLORS.Accent = theme.accent
        COLORS.Success = theme.accent
        COLORS.Red = theme.accent
        COLORS.Blue = theme.accent
        COLORS.AccentSoft = theme.soft
        COLORS.Purple = theme.soft

        local guiRoots = {screenGui}
        local mobileGui = playerGui:FindFirstChild("CelestialMobileButtons")
        if mobileGui then table.insert(guiRoots, mobileGui) end
        for _, root in ipairs(guiRoots) do
            for _, obj in ipairs(root:GetDescendants()) do
                if obj:IsA("UIGradient") then
                    pcall(function()
                        local seq = obj.Color
                        local keys = seq.Keypoints
                        local shouldRecolor = false
                        for _, keypoint in ipairs(keys) do
                            local c = keypoint.Value
                            if isWarmAccent(c) or isColoredAccent(c) or (c == oldAccent or isThemeAccent(c)) or (c == oldSoft or isThemeSoft(c)) then
                                shouldRecolor = true
                                break
                            end
                        end
                        if shouldRecolor then
                            local recolored = {}
                            for _, keypoint in ipairs(keys) do
                                local c = keypoint.Value
                                if isWarmAccent(c) or (c == oldAccent or isThemeAccent(c)) then
                                    c = theme.accent
                                elseif (c == oldSoft or isThemeSoft(c)) then
                                    c = theme.soft
                                elseif isColoredAccent(c) then
                                    local brightness = (c.R * 0.299) + (c.G * 0.587) + (c.B * 0.114)
                                    c = brightness > 0.58 and theme.accent or theme.soft
                                end
                                table.insert(recolored, ColorSequenceKeypoint.new(keypoint.Time, c))
                            end
                            obj.Color = ColorSequence.new(recolored)
                        end
                    end)
                elseif obj:IsA("GuiObject") then
                    pcall(function()
                        local name = string.lower(obj.Name or "")
                        local isToggle = name == "toggle" or name == "togglestroke" or name == "track"
                        local isActiveSideButton = obj:IsA("TextButton") and obj.Parent == mobileGui and obj:GetAttribute("CelestialHubActive") == true
                        if obj:IsA("TextButton") or obj:IsA("ImageButton") then
                            if isWarmAccent(obj.BackgroundColor3) or isColoredAccent(obj.BackgroundColor3) or (obj.BackgroundColor3 == oldAccent or isThemeAccent(obj.BackgroundColor3)) or (obj.BackgroundColor3 == oldSoft or isThemeSoft(obj.BackgroundColor3)) then
                                obj.BackgroundColor3 = theme.accent
                            end
                        elseif isWarmAccent(obj.BackgroundColor3) or isColoredAccent(obj.BackgroundColor3) or (obj.BackgroundColor3 == oldAccent or isThemeAccent(obj.BackgroundColor3)) or (obj.BackgroundColor3 == oldSoft or isThemeSoft(obj.BackgroundColor3)) then
                            obj.BackgroundColor3 = theme.soft
                        end
                        if obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox") then
                            if isWarmAccent(obj.TextColor3) or isColoredAccent(obj.TextColor3) or (obj.TextColor3 == oldAccent or isThemeAccent(obj.TextColor3)) or (obj.TextColor3 == oldSoft or isThemeSoft(obj.TextColor3)) then
                                obj.TextColor3 = theme.accent
                            end
                        end
                        if isToggle and obj:IsA("GuiObject") then
                            local strokeObj = obj:FindFirstChildOfClass("UIStroke")
                            if strokeObj then strokeObj.Color = theme.accent end
                        end
                        if name == "divider" then obj.BackgroundColor3 = theme.accent end
                    end)
                elseif obj:IsA("UIStroke") then
                    pcall(function()
                        if obj:GetAttribute("CelestialHubThemeAccentStroke") == true
                            or isWarmAccent(obj.Color) or isColoredAccent(obj.Color)
                            or (obj.Color == oldAccent or isThemeAccent(obj.Color)) or (obj.Color == oldSoft or isThemeSoft(obj.Color)) then
                            obj:SetAttribute("CelestialHubThemeAccentStroke", true)
                            obj.Color = theme.accent
                        end
                    end)
                end
            end
        end
        for _, obj in ipairs(screenGui:GetDescendants()) do
            if obj:IsA("UIStroke") and obj.Parent then
                local parentName = obj.Parent.Name
                if obj.Name == "RowStroke"
                    or obj:GetAttribute("CelestialHubThemeAccentStroke") == true
                    or parentName == "Toggle" or parentName == "Track" or parentName == "ToggleStroke" then
                    obj:SetAttribute("CelestialHubThemeAccentStroke", true)
                    obj.Color = theme.accent
                end
            end
        end
        for _, obj in ipairs(screenGui:GetDescendants()) do
            if obj:IsA("Frame") then
                local rowStroke = obj:FindFirstChild("RowStroke")
                if rowStroke and rowStroke:IsA("UIStroke") then
                    rowStroke.Color = theme.accent
                    rowStroke:SetAttribute("CelestialHubThemeAccentStroke", true)
                    if obj:GetAttribute("GlowOn") == true then
                        rowStroke.Transparency = 0
                        rowStroke.Thickness = 3
                    else
                        rowStroke.Transparency = 0.25
                        rowStroke.Thickness = 1.2
                    end
                end
            end
            if obj:IsA("UIStroke") then
                local c = obj.Color
                local r = math.floor(c.R * 255 + 0.5)
                local g = math.floor(c.G * 255 + 0.5)
                local b = math.floor(c.B * 255 + 0.5)
                if (r == 255 and g == 120 and b == 0)
                    or obj:GetAttribute("CelestialHubThemeAccentStroke") == true
                    or obj.Name == "RowStroke" then
                    obj.Color = theme.accent
                    obj:SetAttribute("CelestialHubThemeAccentStroke", true)
                end
            end
        end
        if mobileGui then
            for _, btn in ipairs(mobileGui:GetChildren()) do
                if btn:IsA("TextButton") then
                    local active = btn:GetAttribute("CelestialHubActive") == true
                    local st = btn:FindFirstChildOfClass("UIStroke")
                    local grad = btn:FindFirstChildOfClass("UIGradient")
                    local topAccent = btn:FindFirstChild("OrangeAccent")
                    btn.BackgroundColor3 = active and theme.accent or Color3.fromRGB(18, 18, 20)
                    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                    btn.TextTransparency = 0
                    btn.TextStrokeTransparency = 1
                    if grad then
                        if active then
                            grad.Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, theme.soft),
                                ColorSequenceKeypoint.new(1, theme.accent),
                            })
                        else
                            grad.Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, Color3.fromRGB(35, 35, 40)),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(18, 18, 20)),
                            })
                        end
                    end
                    if st then
                        st.Color = theme.accent
                        st.Thickness = active and 3 or 1.8
                        st.Transparency = active and 0 or 0.05
                        st:SetAttribute("CelestialHubThemeAccentStroke", true)
                    end
                    if topAccent and topAccent:IsA("GuiObject") then
                        topAccent.BackgroundColor3 = theme.accent
                        topAccent.Visible = active
                    end
                end
            end
        end
        if type(_G.CelestialHubRefreshMobileButtonTheme) == "function" then
            pcall(_G.CelestialHubRefreshMobileButtonTheme, theme.accent, theme.soft)
        end
        if StealSys and StealSys.applyTheme then pcall(StealSys.applyTheme) end

        local function recolorNamedRow(targetText)
            local target = string.lower((targetText or ""):gsub("%s+", " "))
            for _, label in ipairs(screenGui:GetDescendants()) do
                if (label:IsA("TextLabel") or label:IsA("TextButton"))
                    and string.lower((label.Text or ""):gsub("%s+", " ")) == target then
                    label.TextColor3 = Color3.fromRGB(255, 255, 255)
                    local node = label.Parent
                    while node and node ~= screenGui do
                        if node:IsA("Frame") then
                            local outline = node:FindFirstChild("RowStroke")
                            if outline and outline:IsA("UIStroke") then
                                node:SetAttribute("CelestialHubThemeRow", true)
                                outline.Color = theme.accent or _G.CelestialThemeAccent or Color3.fromRGB(155, 75, 195)
                                outline:SetAttribute("CelestialHubThemeAccentStroke", true)
                                break
                            end
                        end
                        node = node.Parent
                    end
                end
            end
        end
        recolorNamedRow("Drop")

        local function forceNamedRowTheme(targetName)
            local targetLower = string.lower(targetName)
            for _, label in ipairs(screenGui:GetDescendants()) do
                if (label:IsA("TextLabel") or label:IsA("TextButton"))
                    and string.lower((label.Text or ""):gsub("%s+", " ")) == targetLower then
                    local node = label.Parent
                    while node and node ~= screenGui do
                        if node:IsA("Frame") then
                            if celestialForceRowThemeOutline then celestialForceRowThemeOutline(node) end
                            local glow = node:GetAttribute("GlowOn") == true
                            if setRowGlow then pcall(setRowGlow, node, glow) end
                            break
                        end
                        node = node.Parent
                    end
                end
            end
        end
        for _, name in ipairs({"Auto Left", "Auto Right", "Auto Play", "Bat Aimbot"}) do
            forceNamedRowTheme(name)
        end
        if autoLeftRow then pcall(celestialForceRowThemeOutline, autoLeftRow); pcall(setRowGlow, autoLeftRow, autoLeftRow:GetAttribute("GlowOn") == true) end
        if autoRightRow then pcall(celestialForceRowThemeOutline, autoRightRow); pcall(setRowGlow, autoRightRow, autoRightRow:GetAttribute("GlowOn") == true) end
        if autoPlayRow then pcall(celestialForceRowThemeOutline, autoPlayRow); pcall(setRowGlow, autoPlayRow, autoPlayRow:GetAttribute("GlowOn") == true) end
        if batAimbotRow then pcall(celestialForceRowThemeOutline, batAimbotRow); pcall(setRowGlow, batAimbotRow, batAimbotRow:GetAttribute("GlowOn") == true or Config.BatAimbot == true) end

        if false and StealSys then
            for _, label in ipairs({StealSys.titleLabel, StealSys.modeLabel, StealSys.radiusLabel, StealSys.progressLabel, StealSys.discordLabel}) do
                if label and label:IsA("TextLabel") then label.TextColor3 = theme.accent end
            end
        end
        for _, label in ipairs(screenGui:GetDescendants()) do
            if label:IsA("TextLabel") and ({ModeLabel=true, DiscordHeaderLabel=true, RadiusLabel=true, Status=true})[label.Name] then
                label.TextColor3 = theme.accent
            end
        end

        if dropActionRow then pcall(setRowGlow, dropActionRow, dropActionRow:GetAttribute("GlowOn") == true) end
        if autoLeftRow then pcall(setRowGlow, autoLeftRow, autoLeftRow:GetAttribute("GlowOn") == true) end
        if autoRightRow then pcall(setRowGlow, autoRightRow, autoRightRow:GetAttribute("GlowOn") == true) end
        if type(_G.__CelestialHubModeButtonRefreshers) == "table" then
            for _, refreshModeRow in ipairs(_G.__CelestialHubModeButtonRefreshers) do
                if type(refreshModeRow) == "function" then pcall(refreshModeRow) end
            end
        end

        if type(selectTab) == "function" then
            task.defer(function()
                pcall(function() selectTab(_G.CelestialHubSelectedTab or "Movement") end)
            end)
        end
    end

    pcall(function() applyBackgroundTheme(Config.UIBackgroundIndex) end)

    -- Buttons&Gui theme: Cyan / Purple (recolors buttons, toggles, tabs and the settings GUI)
    local themeRow = rowBase(settings, "Buttons&Gui Theme", false)
    local themeValLbl = Instance.new("TextLabel")
    themeValLbl.BackgroundTransparency = 1
    themeValLbl.Size = UDim2.new(0, 64, 0, 22)
    themeValLbl.Position = UDim2.new(1, -128, 0.5, -11)
    themeValLbl.Font = Enum.Font.GothamBold
    themeValLbl.TextSize = 13
    themeValLbl.TextColor3 = COLORS.White
    themeValLbl.Text = tostring(Config.ButtonsGuiTheme)
    themeValLbl.Parent = themeRow
    local function mkThemeArrow(txt, x)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 28, 0, 22)
        b.Position = UDim2.new(1, x, 0.5, -11)
        b.BackgroundColor3 = COLORS.Badge
        b.BackgroundTransparency = 0.25
        b.BorderSizePixel = 0
        b.Text = txt
        b.Font = Enum.Font.GothamBlack
        b.TextSize = 14
        b.TextColor3 = COLORS.White
        b.Parent = themeRow
        corner(b, 6)
        return b
    end
    local function setButtonsGuiTheme(name)
        if name ~= "Cyan" and name ~= "Purple" then name = "Cyan" end
        Config.ButtonsGuiTheme = name
        themeValLbl.Text = name
        pcall(function() applyBackgroundTheme(Config.UIBackgroundIndex) end)
        saveConfig()
        task.defer(function()
            pcall(function() applyBackgroundTheme(Config.UIBackgroundIndex) end)
        end)
    end
    mkThemeArrow("<", -156).Activated:Connect(function() setButtonsGuiTheme("Cyan") end)
    mkThemeArrow(">", -64).Activated:Connect(function() setButtonsGuiTheme("Purple") end)

    local row = rowBase(settings, "Background", false)
    local valLbl = Instance.new("TextLabel")
    valLbl.BackgroundTransparency = 1
    valLbl.Size = UDim2.new(0, 42, 0, 22)
    valLbl.Position = UDim2.new(1, -120, 0.5, -11)
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 13
    valLbl.TextColor3 = COLORS.White
    Config.UIBackgroundIndex = math.clamp(tonumber(Config.UIBackgroundIndex) or 1, 1, NUM_BG)
    valLbl.Text = tostring(Config.UIBackgroundIndex)
    valLbl.Parent = row
    local function mkBackgroundArrow(txt, x)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 28, 0, 22)
        b.Position = UDim2.new(1, x, 0.5, -11)
        b.BackgroundColor3 = COLORS.Badge
        b.BackgroundTransparency = 0.25
        b.BorderSizePixel = 0
        b.Text = txt
        b.Font = Enum.Font.GothamBlack
        b.TextSize = 14
        b.TextColor3 = COLORS.White
        b.Parent = row
        corner(b, 6)
        return b
    end
    local function setBackgroundIndex(n)
        Config.UIBackgroundIndex = math.clamp(tonumber(n) or 1, 1, NUM_BG)
        valLbl.Text = tostring(Config.UIBackgroundIndex)
        applyBackgroundTheme(Config.UIBackgroundIndex)
        local url = BACKGROUND_URLS[Config.UIBackgroundIndex]
        if url then
            applyUIBackground(url)
        else
            Config.UIBackgroundUrl = ""
            if uiBgImage then uiBgImage.Image = ""; uiBgImage.Visible = false end
            if uiBgDim then uiBgDim.BackgroundColor3 = Color3.fromRGB(0, 0, 0); uiBgDim.BackgroundTransparency = 0 end
            main.BackgroundTransparency = 0
            main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        end
        saveConfig()
        task.defer(function()
            pcall(function() applyBackgroundTheme(Config.UIBackgroundIndex) end)
        end)
    end
    mkBackgroundArrow("<", -156).Activated:Connect(function() setBackgroundIndex(math.max(1, Config.UIBackgroundIndex - 1)) end)
    mkBackgroundArrow(">", -64).Activated:Connect(function() setBackgroundIndex(math.min(NUM_BG, Config.UIBackgroundIndex + 1)) end)
    setBackgroundIndex(Config.UIBackgroundIndex)
    task.defer(function()
        pcall(function() applyBackgroundTheme(Config.UIBackgroundIndex) end)
    end)
end

do
    local row = rowBase(settings, "UI Scale", false)
    local valLbl = Instance.new("TextLabel")
    valLbl.BackgroundTransparency = 1
    valLbl.Size = UDim2.new(0, 48, 0, 22)
    valLbl.Position = UDim2.new(1, -120, 0.5, -11)
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 13
    valLbl.TextColor3 = COLORS.White
    valLbl.Text = tostring(Config.UIScale)
    valLbl.TextXAlignment = Enum.TextXAlignment.Center
    valLbl.Parent = row
    local function mkArr(txt, x)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 28, 0, 22)
        b.Position = UDim2.new(1, x, 0.5, -11)
        b.BackgroundColor3 = COLORS.Badge
        b.BackgroundTransparency = 0.25
        b.BorderSizePixel = 0
        b.Text = txt
        b.Font = Enum.Font.GothamBlack
        b.TextSize = 14
        b.TextColor3 = COLORS.White
        b.Parent = row
        corner(b, 6)
        return b
    end
    local left = mkArr("<", -156)
    local right = mkArr(">", -64)
    left.Activated:Connect(function()
        applyUIScale(Config.UIScale - 5)
        valLbl.Text = tostring(Config.UIScale)
        saveConfig()
    end)
    right.Activated:Connect(function()
        applyUIScale(Config.UIScale + 5)
        valLbl.Text = tostring(Config.UIScale)
        saveConfig()
    end)
end


do
    Config.StealBarSize = math.clamp(tonumber(Config.StealBarSize) or 40, 20, 90)
    local row = rowBase(settings, "Steal Bar Size", false)
    local valLbl = Instance.new("TextLabel")
    valLbl.BackgroundTransparency = 1
    valLbl.Size = UDim2.new(0, 48, 0, 22)
    valLbl.Position = UDim2.new(1, -120, 0.5, -11)
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 13
    valLbl.TextColor3 = COLORS.White
    valLbl.Text = tostring(Config.StealBarSize or 40)
    valLbl.TextXAlignment = Enum.TextXAlignment.Center
    valLbl.Parent = row
    local function mkArr(txt, x)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 28, 0, 22)
        b.Position = UDim2.new(1, x, 0.5, -11)
        b.BackgroundColor3 = COLORS.Badge
        b.BackgroundTransparency = 0.25
        b.BorderSizePixel = 0
        b.Text = txt
        b.Font = Enum.Font.GothamBlack
        b.TextSize = 14
        b.TextColor3 = COLORS.White
        b.Parent = row
        corner(b, 6)
        return b
    end
    local left = mkArr("<", -156)
    local right = mkArr(">", -64)
    left.Activated:Connect(function()
        Config.StealBarSize = math.clamp((Config.StealBarSize or 40) - 5, 20, 90)
        valLbl.Text = tostring(Config.StealBarSize)
        if StealSys and StealSys.applyBarSize then StealSys.applyBarSize() end
        saveConfig()
    end)
    right.Activated:Connect(function()
        Config.StealBarSize = math.clamp((Config.StealBarSize or 40) + 5, 20, 90)
        valLbl.Text = tostring(Config.StealBarSize)
        if StealSys and StealSys.applyBarSize then StealSys.applyBarSize() end
        saveConfig()
    end)
end

toggleRow(settings, "Lock UI", Config.LockUI, function(state)
    Config.LockUI = state
    main.Active = true
    main.Draggable = not state
    _G.CelestialUILocked = state
    if state then
        _G.CelestialMainWasDragged = _G.CelestialMainWasDragged or false
    end
    saveConfig()
end)

do
    local hideRow = rowBase(settings, "Hide UI", false)
    keybindBadge(hideRow, Config.HideUIKey, -60, 34, function(key)
        Config.HideUIKey = key
        saveConfig()
    end)
end


sectionLabel(settings, "MOBILE BUTTONS")
do
    local row = rowBase(settings, "Button Size", false)
    local valLbl = Instance.new("TextLabel")
    valLbl.BackgroundTransparency = 1
    valLbl.Size = UDim2.new(0, 48, 0, 22)
    valLbl.Position = UDim2.new(1, -120, 0.5, -11)
    valLbl.Font = Enum.Font.GothamBold
    valLbl.TextSize = 13
    valLbl.TextColor3 = COLORS.White
    valLbl.Text = tostring(Config.MobileButtonSize or 50)
    valLbl.TextXAlignment = Enum.TextXAlignment.Center
    valLbl.Parent = row
    local function mkArr(txt, x)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 28, 0, 22)
        b.Position = UDim2.new(1, x, 0.5, -11)
        b.BackgroundColor3 = COLORS.Badge
        b.BackgroundTransparency = 0.25
        b.BorderSizePixel = 0
        b.Text = txt
        b.Font = Enum.Font.GothamBlack
        b.TextSize = 14
        b.TextColor3 = COLORS.White
        b.Parent = row
        corner(b, 6)
        return b
    end
    local left = mkArr("<", -156)
    local right = mkArr(">", -64)
    left.Activated:Connect(function()
        Config.MobileButtonSize = math.clamp((Config.MobileButtonSize or 50) - 5, 10, 125)
        valLbl.Text = tostring(Config.MobileButtonSize)
        if _G.CelestialApplyMobileButtonSize then pcall(_G.CelestialApplyMobileButtonSize) end
        saveConfig()
    end)
    right.Activated:Connect(function()
        Config.MobileButtonSize = math.clamp((Config.MobileButtonSize or 50) + 5, 10, 125)
        valLbl.Text = tostring(Config.MobileButtonSize)
        if _G.CelestialApplyMobileButtonSize then pcall(_G.CelestialApplyMobileButtonSize) end
        saveConfig()
    end)
end

toggleRow(settings, "Hide Buttons", Config.HideButtons, function(state)
    Config.HideButtons = state
    if _G.CelestialApplyHideButtons then pcall(_G.CelestialApplyHideButtons, state) end
    saveConfig()
end)

toggleRow(settings, "Circle Buttons", Config.CircleButtons, function(state)
    Config.CircleButtons = state
    if _G.CelestialApplyMobileButtonShape then pcall(_G.CelestialApplyMobileButtonShape) end
end)

do
    local row = rowBase(settings, "Reset Buttons Position", false)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 72, 0, 24)
    btn.Position = UDim2.new(1, -84, 0.5, -12)
    btn.BackgroundColor3 = COLORS.Badge
    btn.BackgroundTransparency = 0.15
    btn.BorderSizePixel = 0
    btn.Text = "RESET"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextColor3 = COLORS.White
    btn.Parent = row
    corner(btn, 8)
    btn.Activated:Connect(function()
        if _G.CelestialResetMobileButtons then pcall(_G.CelestialResetMobileButtons) end
        btn.Text = "DONE"
        task.delay(1.2, function() if btn and btn.Parent then btn.Text = "RESET" end end)
    end)
end

sectionLabel(settings, "INTRO")
toggleRow(settings, "Intro", Config.IntroEnabled, function(state)
    Config.IntroEnabled = state
end)

do
    local row = rowBase(settings, "Save Settings", false)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 90, 0, 24)
    btn.Position = UDim2.new(1, -102, 0.5, -12)
    btn.BackgroundColor3 = COLORS.Badge
    btn.BackgroundTransparency = 0.15
    btn.BorderSizePixel = 0
    btn.Text = "SAVE"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextColor3 = COLORS.White
    btn.Parent = row
    corner(btn, 8)
    btn.Activated:Connect(function()
        saveConfig()
        btn.Text = "SAVED!"
        task.delay(3, function() if btn and btn.Parent then btn.Text = "SAVE" end end)
    end)
end

do
    local row = rowBase(settings, "Reset All Settings", false)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 90, 0, 24)
    btn.Position = UDim2.new(1, -102, 0.5, -12)
    btn.BackgroundColor3 = Color3.fromRGB(0, 220, 255)
    btn.BackgroundTransparency = 0.1
    btn.BorderSizePixel = 0
    btn.Text = "RESET"
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 11
    btn.TextColor3 = COLORS.White
    btn.Parent = row
    corner(btn, 8)
    btn.Activated:Connect(function()

        Config.NormalSpeed = 59
        Config.CarrySpeed = 29
        Config.TPDownHeight = 20
        Config.AutoCarrySpeed = false
        Config.LaggerSpeed = 40
        Config.LaggerCarry = 20
        Config.BatAimbot = false
        Config.AutoSwing = true
        Config.AutoSteal = false
        Config.InfiniteJump = false
        Config.AntiRagdoll = false
        Config.BatCounter = false
        Config.MedusaCounter = false
        Config.AntiDie = false
        Config.SafeMode = false
        Config.PlayerESP = false
        Config.PlayerTracers = false
        Config.RagdollCountdown = false
        Config.BrainrotTransparencyBase = false
        Config.BrainrotTransparencyHeld = false
        Config.CustomAnim = false
        Config.AntiLag = false
        Config.StretchRes = false
        Config.FOVChange = false
        Config.FOVValue = 70
        Config.UIScale = 30
        Config.LockUI = false
        Config.HideUI = false
        Config.StealBarPosX = nil
        Config.StealBarPosY = nil
        uiMinimized = false
        miniRestoreButton.Visible = false
        Config.MobileButtonSize = 50
        Config.CircleButtons = false
        Config.HideButtons = false
        Config.IntroEnabled = true
        applyUIScale(30)
        main.Active = true
        main.Draggable = true
        main.Visible = true
        if State.autoBatToggled and stopBatAimbot then pcall(stopBatAimbot); State.autoBatToggled = false end
        if stopPlayerEsp then pcall(stopPlayerEsp) end
        if stopPlayerTracers then pcall(stopPlayerTracers) end
        if stopAntiDie then pcall(stopAntiDie) end
        if disableAntiLag then pcall(disableAntiLag) end
        if disableStretchRez then pcall(disableStretchRez) end
        if disableCustomFov then pcall(disableCustomFov) end
        if stopAutoStealSystem then pcall(stopAutoStealSystem) end
        saveConfig()
        btn.Text = "DONE"
        task.delay(1.5, function() if btn and btn.Parent then btn.Text = "RESET" end end)
    end)
end



movement.Visible = true




_aimbotTarget = nil
Conns = { aimbot = nil, bypassAimbot = nil }



BAT_PREDICTION_CACHE = {}

function getEnvyPredictedPosition(target)
    if not target or not target.Parent then return nil end

    local velocity = target.AssemblyLinearVelocity
    if not velocity or velocity.Magnitude < 0.1 then
        return target.Position + target.CFrame.LookVector * 1.5
    end

    return target.Position + target.CFrame.LookVector * 5
end

function findBat()
    local char = LP.Character
    if not char then return nil end
    for _, tool in ipairs(char:GetChildren()) do
        if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then return tool end
        end
    end
    return nil
end

function getClosestTarget()
    local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local closest, minDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then minDist = dist; closest = tRoot end
            end
        end
    end
    return closest
end

batSwingCooldown = false

function tryBatSwing()
    if batSwingCooldown then return end
    batSwingCooldown = true
    pcall(function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hum then return end
        local bat = char:FindFirstChildOfClass("Tool")
        if not bat or not (bat.Name:lower():find("bat",1,true) or bat.Name:lower():find("slap",1,true)) then
            bat = findBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        if bat and bat:IsA("Tool") and (bat.Name:lower():find("bat",1,true) or bat.Name:lower():find("slap",1,true)) then
            if CELESTIAL_BAT_SKIN_SOUNDS[Config.BatSkin] then
                celestialPlaySwingSound(bat, Config.BatSkin)
            end
            bat:Activate()
        end
    end)
    task.delay(0.3, function() batSwingCooldown = false end)
end

function getAimbotChaseSpeed()
    local laggerActive = (laggerModeEnabled == true)
        or (laggerCarryActive == true)
        or (laggerSpeedEnabled == true)
        or (laggerCarryEnabled == true)
    local keyName = type(Config.LaggerCarryKey) == "string" and Config.LaggerCarryKey or ""
    if keyName ~= "" then
        local ok, keyCode = pcall(function() return Enum.KeyCode[keyName] end)
        if ok and keyCode and UserInputService:IsKeyDown(keyCode) then laggerActive = true end
    end
    if laggerActive then return math.max(0, tonumber(Config.LaggerSpeed) or 40) end
    return math.max(0, tonumber(Config.AimbotSpeed) or 55)
end

startBatAimbot=function()
    if safeModeTryStart and not safeModeTryStart() then return end
    if State.bypassAimbotToggled then
        local stopFn = stopBypassAimbot or _G.CelestialStopBypassAimbot
        if stopFn then pcall(stopFn) end
    end
    pcall(celestialEquipBatOnce)
    if Conns.aimbot then Conns.aimbot:Disconnect(); Conns.aimbot=nil end
    mirrorTPActive=true
    table.clear(mirrorTPPreviousY)
    if syncAutoAntiDie then pcall(syncAutoAntiDie) end

    local HIT_DIST = 8
    local SWING_CD = 0.35
    local hitCD = false
    local prevAutoRotate = nil
    local lockedChar = nil
    local noTargetSince = nil

    local BAT_SLAP_LIST = {
        "Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap",
        "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap",
        "Nuclear Slap", "Galaxy Slap", "Glitched Slap"
    }

    local function findBatLocal()
        local char = LP.Character
        if not char then return nil end
        for _, name in ipairs(BAT_SLAP_LIST) do
            local t = char:FindFirstChild(name)
            if t and t:IsA("Tool") then return t end
        end
        local bp = LP:FindFirstChildOfClass("Backpack")
        if bp then
            for _, name in ipairs(BAT_SLAP_LIST) do
                local t = bp:FindFirstChild(name)
                if t and t:IsA("Tool") then return t end
            end
        end
        for _, ch in ipairs(char:GetChildren()) do
            if ch:IsA("Tool") then
                local n = ch.Name:lower()
                if n:find("bat", 1, true) or n:find("slap", 1, true) then return ch end
            end
        end
        if bp then
            for _, ch in ipairs(bp:GetChildren()) do
                if ch:IsA("Tool") then
                    local n = ch.Name:lower()
                    if n:find("bat", 1, true) or n:find("slap", 1, true) then return ch end
                end
            end
        end
        return nil
    end

    local function trySwing()
        if hitCD then return end
        if not (Config.AutoSwing and Config.BatAimbot and State.autoBatToggled) then return end
        hitCD = true
        pcall(function()
            local char = LP.Character
            if not char then return end
            local bat = findBatLocal()
            if not bat then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if bat.Parent ~= char and hum then
                pcall(function() hum:EquipTool(bat) end)
            end
            pcall(function() bat:Activate() end)
        end)
        task.delay(SWING_CD, function() hitCD = false end)
    end

    local function validTarget(char)
        if not char or not char.Parent then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        return hum and hrp and hum.Health > 0
    end

    local function getClosestTarget(root)
        if lockedChar and not validTarget(lockedChar) then lockedChar = nil end
        if lockedChar then
            local hrp = lockedChar:FindFirstChild("HumanoidRootPart")
            if hrp then
                return hrp, (hrp.Position - root.Position).Magnitude
            end
            lockedChar = nil
        end
        local closest, minDist = nil, math.huge
        local bestChar = nil
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and validTarget(plr.Character) then
                local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                local dist = (tRoot.Position - root.Position).Magnitude
                if dist < minDist then
                    minDist = dist
                    closest = tRoot
                    bestChar = plr.Character
                end
            end
        end
        lockedChar = bestChar
        return closest, minDist
    end

    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then
        prevAutoRotate = hum0.AutoRotate
        hum0.AutoRotate = false
    end

    Conns.aimbot = RunService.RenderStepped:Connect(function()
        if not State.autoBatToggled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end

        hum.AutoRotate = false

        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBatLocal()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end

        local target, targetDist = getClosestTarget(root)
        if not target then
            _aimbotTarget = nil
            if not noTargetSince then noTargetSince = tick() end
            if tick() - noTargetSince > 1.5 then
                lockedChar = nil
            end
            return
        end
        noTargetSince = nil
        _aimbotTarget = target

        local myPos = root.Position
        local targetPos = target.Position

        local targetVelocity = target.AssemblyLinearVelocity
        local predictionTime = 0.14
        local targetLook = target.CFrame.LookVector
        local predictedPos = targetPos + targetVelocity * predictionTime + targetLook * 0.3
        local lead = predictedPos - targetPos
        local maxLeadDistance = 7.5
        if lead.Magnitude > maxLeadDistance then
            predictedPos = targetPos + lead.Unit * maxLeadDistance
        end

        local targetForward = Vector3.new(targetLook.X, 0, targetLook.Z)
        if targetForward.Magnitude < 0.001 then
            local fallback = target.CFrame.RightVector
            targetForward = Vector3.new(-fallback.X, 0, -fallback.Z)
        end
        if targetForward.Magnitude > 0 then
            targetForward = targetForward.Unit
        else
            targetForward = Vector3.new(0, 0, -1)
        end
        local FRONT_OFFSET = 3.5
        local chasePos = predictedPos + targetForward * FRONT_OFFSET

        local direction = chasePos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0 then
            flatDir = flatDir.Unit
        else
            flatDir = Vector3.zero
        end

        local chaseSpeed = math.clamp(
            (getAimbotChaseSpeed and getAimbotChaseSpeed()) or tonumber(Config.AimbotSpeed) or 58,
            1, 120
        )

        local desiredHeight = chasePos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5
        if hum.FloorMaterial ~= Enum.Material.Air then
            yVel = math.max(yVel, 13)
        end
        yVel = math.clamp(yVel, -70, 110)

        local desiredVel = Vector3.new(flatDir.X * chaseSpeed, yVel, flatDir.Z * chaseSpeed)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)

        local travelDir = Vector3.new(targetVelocity.X, 0, targetVelocity.Z)
        if travelDir.Magnitude > 1.25 then
            travelDir = travelDir.Unit
        else
            travelDir = targetForward
        end
        local facePos = myPos + travelDir * 10
        if (facePos - myPos).Magnitude > 0.1 then
            root.CFrame = CFrame.lookAt(myPos, facePos)
            root.AssemblyAngularVelocity = Vector3.zero
        end

        if targetDist <= HIT_DIST then
            trySwing()
        end
    end)
end

stopBatAimbot=function()
    if Conns.aimbot then Conns.aimbot:Disconnect(); Conns.aimbot=nil end
    _aimbotTarget=nil
    batSwingCooldown=false
    BAT_PREDICTION_CACHE={}
    local c=LP.Character
    local root=c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity=Vector3.zero
        root.AssemblyAngularVelocity=Vector3.zero
    end
    local hum2=c and c:FindFirstChildOfClass("Humanoid")
    if hum2 then
        hum2.AutoRotate=true
        hum2.PlatformStand=false
        pcall(function() hum2:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    end
    State.hittingCooldown=false
    mirrorTPActive=false
    table.clear(mirrorTPPreviousY)
    if syncAutoAntiDie then pcall(syncAutoAntiDie) end
end

-- ============================================================
-- BYPASS AIMBOT (Anti Bat Bypass Lock from Celestial Duels)
-- ============================================================
BypassAimbotState = { swingCooldown = false, prevAutoRotate = nil }

startBypassAimbot = function()
    if safeModeTryStart and not safeModeTryStart() then
        State.bypassAimbotToggled = false
        Config.BypassAimbot = false
        return
    end

    if State.autoBatToggled or Config.BatAimbot then
        State.autoBatToggled = false
        Config.BatAimbot = false
        if stopBatAimbot then pcall(stopBatAimbot) end
        if mobBtnRefs and mobBtnRefs.autoBat then pcall(mobBtnRefs.autoBat, false) end
        if _G.CelestialSetBatAimbotUI then pcall(_G.CelestialSetBatAimbotUI, false) end
        if applyBatSpinRule then pcall(applyBatSpinRule, false) end
    end

    if Conns.bypassAimbot then
        pcall(function() Conns.bypassAimbot:Disconnect() end)
        Conns.bypassAimbot = nil
    end

    State.bypassAimbotToggled = true
    Config.BypassAimbot = true
    pcall(celestialEquipBatOnce)

    local BAT_LIST = {
        "Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap",
        "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap",
        "Nuclear Slap", "Galaxy Slap", "Glitched Slap"
    }

    local function findBat()
        local char = LP.Character
        if not char then return nil end
        local bp = LP:FindFirstChildOfClass("Backpack")
        for _, name in ipairs(BAT_LIST) do
            local t = char:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
            if t and t:IsA("Tool") then return t end
        end
        for _, container in ipairs({char, bp}) do
            if container then
                for _, ch in ipairs(container:GetChildren()) do
                    if ch:IsA("Tool") then
                        local n = ch.Name:lower()
                        if n:find("bat", 1, true) or n:find("slap", 1, true) then
                            return ch
                        end
                    end
                end
            end
        end
        return nil
    end

    local function trySwing()
        if BypassAimbotState.swingCooldown then return end
        if Config.AutoSwing == false then return end
        BypassAimbotState.swingCooldown = true
        pcall(function()
            local char = LP.Character
            if not char then return end
            local bat = findBat()
            if not bat then return end
            local hum = char:FindFirstChildOfClass("Humanoid")
            if bat.Parent ~= char and hum then
                pcall(function() hum:EquipTool(bat) end)
            end
            pcall(function() bat:Activate() end)
        end)
        task.delay(0.05, function() BypassAimbotState.swingCooldown = false end)
    end

    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then
        BypassAimbotState.prevAutoRotate = hum0.AutoRotate
        hum0.AutoRotate = false
    end
    if syncAutoAntiDie then pcall(syncAutoAntiDie) end

    Conns.bypassAimbot = RunService.RenderStepped:Connect(function()
        if not State.bypassAimbotToggled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return end

        hum.AutoRotate = false

        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end

        local closest, minDist = nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LP and plr.Character then
                local th = plr.Character:FindFirstChildOfClass("Humanoid")
                local tr = plr.Character:FindFirstChild("HumanoidRootPart")
                if th and tr and th.Health > 0 then
                    local d = (tr.Position - root.Position).Magnitude
                    if d < minDist then
                        minDist = d
                        closest = tr
                    end
                end
            end
        end
        if not closest then return end

        local myPos = root.Position
        local targetPos = closest.Position
        local direction = targetPos - myPos
        local flatDir = Vector3.new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0.05 then
            flatDir = flatDir.Unit
        else
            flatDir = Vector3.zero
        end

        local speed = 58
        if laggerModeEnabled or laggerCarryEnabled or laggerSpeedEnabled then
            speed = tonumber(Config.LaggerSpeed) or 40
        else
            speed = tonumber(Config.AimbotSpeed) or 58
        end
        speed = math.clamp(speed, 1, 120)

        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 19.5
        if hum.FloorMaterial ~= Enum.Material.Air then
            yVel = math.max(yVel, 13)
        end
        yVel = math.clamp(yVel, -70, 110)

        local desiredVel = Vector3.new(flatDir.X * speed, yVel, flatDir.Z * speed)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.85)

        if direction.Magnitude > 0.15 then
            local flatTarget = Vector3.new(targetPos.X, myPos.Y, targetPos.Z)
            if (flatTarget - myPos).Magnitude > 0.1 then
                root.CFrame = CFrame.lookAt(myPos, flatTarget)
            end
            root.AssemblyAngularVelocity = Vector3.zero
        end

        if minDist <= 9 then
            trySwing()
        end
    end)

    if mobBtnRefs and mobBtnRefs.bypassAimbot then
        pcall(mobBtnRefs.bypassAimbot, true)
    end
end

stopBypassAimbot = function()
    State.bypassAimbotToggled = false
    Config.BypassAimbot = false
    if Conns.bypassAimbot then
        pcall(function() Conns.bypassAimbot:Disconnect() end)
        Conns.bypassAimbot = nil
    end
    BypassAimbotState.swingCooldown = false
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if hum then
        local prev = BypassAimbotState.prevAutoRotate
        hum.AutoRotate = (prev == nil) and true or prev
    end
    BypassAimbotState.prevAutoRotate = nil
    if syncAutoAntiDie then pcall(syncAutoAntiDie) end
    if mobBtnRefs and mobBtnRefs.bypassAimbot then
        pcall(mobBtnRefs.bypassAimbot, false)
    end
end

_G.CelestialStartBypassAimbot = startBypassAimbot
_G.CelestialStopBypassAimbot = stopBypassAimbot



do
    local MIRROR_TP_DROP_THRESHOLD = 3
    local MIRROR_TP_DOWN_Y = -7
    local mirrorTPDownPreviousY = {}
    local mirrorTPLastTeleport = 0

    local function mirrorTPDownActive()
        return mirrorTPDownEnabled == true and State.autoBatToggled == true
    end

    local function mirrorTeleportLocalPlayerDown()
        local character = LP.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid or humanoid.Health <= 0 then return end
        local now = tick()
        if now - mirrorTPLastTeleport < 0.08 then return end
        mirrorTPLastTeleport = now
        local _, yaw = root.CFrame:ToEulerAnglesYXZ()
        root.CFrame = CFrame.new(root.Position.X, MIRROR_TP_DOWN_Y, root.Position.Z)
            * CFrame.Angles(0, yaw, 0)
        root.Velocity = Vector3.zero
        pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
    end

    RunService.Heartbeat:Connect(function()
        if not mirrorTPDownActive() then
            table.clear(mirrorTPDownPreviousY)
            return
        end
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
                if targetRoot then
                    local currentY = targetRoot.Position.Y
                    local previousY = mirrorTPDownPreviousY[player.UserId]
                    if previousY and previousY - currentY >= MIRROR_TP_DROP_THRESHOLD then
                        pcall(mirrorTeleportLocalPlayerDown)
                        table.clear(mirrorTPDownPreviousY)
                        return
                    end
                    mirrorTPDownPreviousY[player.UserId] = currentY
                end
            end
        end
    end)
end




local celestialResetCooldown = false
local celestialResetThread = nil
local celestialResetCameraLocked = false
local celestialResetCameraCFrame = nil
local celestialLastResetRequest = 0
local celestialResetCharacterConnection = nil

local function celestialInstantReset()
    local now = os.clock()
    if now - celestialLastResetRequest < 0.75 or celestialResetCooldown then return end
    celestialLastResetRequest = now

    local character = LP and LP.Character
    if not character or not character.Parent then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end

    celestialResetCooldown = true
    _isInstaResetting = true -- Prevent AntiDie from restoring health during the reset.
    celestialResetCameraLocked = false
    local camera = workspace.CurrentCamera
    if camera then
        celestialResetCameraCFrame = camera.CFrame
        celestialResetCameraLocked = true
    end

    if celestialResetThread then pcall(task.cancel, celestialResetThread); celestialResetThread = nil end
    celestialResetThread = task.spawn(function()
        local savedHipHeight = humanoid.HipHeight
        local savedAutoRotate = humanoid.AutoRotate
        local savedCollision = {}
        local success = false
        local attempts = 0

        while attempts < 40 and character.Parent and humanoid.Parent and humanoid.Health > 0 do
            if not LP or LP.Character ~= character then success = true; break end
            pcall(function()
                humanoid.HipHeight = 1e30
                humanoid.AutoRotate = true
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        if savedCollision[part] == nil then savedCollision[part] = part.CanCollide end
                        part.CanCollide = false
                    end
                end
            end)
            attempts += 1
            task.wait(0.05)
        end

        if not success and character.Parent and humanoid.Parent and humanoid.Health > 0 and LP.Character == character then
            pcall(function() humanoid.Health = 0 end)
            task.wait(0.15)
            success = (not character.Parent) or (not humanoid.Parent) or humanoid.Health <= 0 or LP.Character ~= character
        else
            success = success or (not character.Parent) or (not humanoid.Parent) or humanoid.Health <= 0 or LP.Character ~= character
        end

        if not success and character.Parent and humanoid.Parent then
            pcall(function()
                humanoid.HipHeight = savedHipHeight
                humanoid.AutoRotate = savedAutoRotate
                for part, canCollide in pairs(savedCollision) do
                    if part and part.Parent then part.CanCollide = canCollide end
                end
            end)
        end

        celestialResetCameraLocked = false
        celestialResetCameraCFrame = nil
        celestialResetThread = nil
        celestialResetCooldown = false
        _isInstaResetting = false
    end)
end

_G.CelestialHubInstantReset = celestialInstantReset
_G.InstaReset = { Trigger = celestialInstantReset }

if celestialResetCharacterConnection then pcall(function() celestialResetCharacterConnection:Disconnect() end) end
celestialResetCharacterConnection = LP.CharacterAdded:Connect(function()
    celestialResetCameraLocked = false
    celestialResetCameraCFrame = nil
    celestialResetCooldown = false
    _isInstaResetting = false
    celestialResetThread = nil
end)

task.spawn(function()
    while true do
        task.wait(0.016)
        local camera = workspace.CurrentCamera
        if celestialResetCameraLocked and celestialResetCameraCFrame and camera then
            pcall(function() camera.CFrame = celestialResetCameraCFrame end)
        end
    end
end)

antiDieHeartConn = nil
antiDieDeathConns = {}
antiDieCharConn = nil
antiDieActive = false
_isInstaResetting = false

function isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand
        or st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown
end

function protectCharAntiDie(char)
    -- Bubble-style Anti Die only
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
    if not hum then return end

    pcall(function()
        hum.BreakJointsOnDeath = false
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end)

    local sc = hum.StateChanged:Connect(function(_, new)
        if not antiDieActive or _isInstaResetting then return end
        if new == Enum.HumanoidStateType.Dead then
            pcall(function()
                hum.BreakJointsOnDeath = false
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                hum.Health = hum.MaxHealth
            end)
        end
    end)
    table.insert(antiDieDeathConns, sc)

    local hc = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not antiDieActive or _isInstaResetting then return end
        if hum.Health <= 0 then
            pcall(function()
                hum.BreakJointsOnDeath = false
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                hum.Health = hum.MaxHealth
            end)
        end
    end)
    table.insert(antiDieDeathConns, hc)

    local died = hum.Died:Connect(function()
        if not antiDieActive or _isInstaResetting then return end
        task.defer(function()
            if not antiDieActive or not hum or not hum.Parent then return end
            pcall(function()
                hum.BreakJointsOnDeath = false
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                hum.Health = hum.MaxHealth
            end)
        end)
    end)
    table.insert(antiDieDeathConns, died)

    if antiDieHeartConn then antiDieHeartConn:Disconnect() end
    antiDieHeartConn = RunService.Heartbeat:Connect(function()
        if not antiDieActive or _isInstaResetting then return end
        if not hum or not hum.Parent then return end
        if hum.BreakJointsOnDeath then
            pcall(function() hum.BreakJointsOnDeath = false end)
        end
        if hum:GetStateEnabled(Enum.HumanoidStateType.Dead) then
            pcall(function() hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false) end)
        end
        if hum.Health <= 0 then
            pcall(function() hum.Health = hum.MaxHealth end)
        end
    end)
end

startAntiDie = function()
    if antiDieActive then return end
    antiDieActive = true
    for _, c in ipairs(antiDieDeathConns) do pcall(function() c:Disconnect() end) end
    antiDieDeathConns = {}
    if antiDieHeartConn then antiDieHeartConn:Disconnect(); antiDieHeartConn = nil end
    if antiDieCharConn then antiDieCharConn:Disconnect(); antiDieCharConn = nil end
    protectCharAntiDie(LP.Character)
    antiDieCharConn = LP.CharacterAdded:Connect(function(c)
        if not antiDieActive then return end
        task.wait(0.1)
        for _, c2 in ipairs(antiDieDeathConns) do pcall(function() c2:Disconnect() end) end
        antiDieDeathConns = {}
        protectCharAntiDie(c)
    end)
end

stopAntiDie = function()
    antiDieActive = false
    for _, c in ipairs(antiDieDeathConns) do pcall(function() c:Disconnect() end) end
    antiDieDeathConns = {}
    if antiDieHeartConn then antiDieHeartConn:Disconnect(); antiDieHeartConn = nil end
    if antiDieCharConn then antiDieCharConn:Disconnect(); antiDieCharConn = nil end
    local c = LP.Character
    local h = c and c:FindFirstChildOfClass("Humanoid")
    if h then
        pcall(function()
            h:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            h.MaxHealth = 100
            if h.Health > 100 then h.Health = 100 end
        end)
    end
end


spinConn = nil
spinOldAutoRotate = nil
spinHumanoid = nil
startSpin = function()
    if spinConn then spinConn:Disconnect(); spinConn = nil end
    spinHumanoid = nil
    spinOldAutoRotate = nil
    spinConn = RunService.RenderStepped:Connect(function(dt)
        if not Config.Spin then return end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if hum and hum ~= spinHumanoid then
            if spinHumanoid and spinOldAutoRotate ~= nil then
                pcall(function() spinHumanoid.AutoRotate = spinOldAutoRotate end)
            end
            spinHumanoid = hum
            spinOldAutoRotate = hum.AutoRotate
        end
        if hum and root and hum.Health > 0 then
            pcall(function() hum.AutoRotate = false end)
            pcall(function()
                root.CFrame = root.CFrame * CFrame.Angles(0, 0.90, 0)
                root.AssemblyAngularVelocity = Vector3.zero
            end)
        end
    end)
end

stopSpin = function()
    if spinConn then spinConn:Disconnect(); spinConn = nil end
    if spinHumanoid and spinOldAutoRotate ~= nil then
        pcall(function() spinHumanoid.AutoRotate = spinOldAutoRotate end)
    end
    spinHumanoid = nil
    spinOldAutoRotate = nil
end

syncAutoAntiDie = function()
    local need = (Config.AntiDie == true)
        or (Config.Spin == true)
        or (Config.BatAimbot == true)
        or (State.autoBatToggled == true)
        or (dropActive == true)
    if need then
        if startAntiDie then startAntiDie() end
    else
        if stopAntiDie then stopAntiDie() end
    end
end

if Config.Spin == true then
    if startSpin then pcall(startSpin) end
end
if syncAutoAntiDie then pcall(syncAutoAntiDie) end

function __celestialInitMiscLogic()









infiniteJumpGamepadHeld = false
infiniteJumpTouchHeld = false
infiniteJumpMobileConns = {}

function applyInfiniteJumpVelocity()
    if not Config.InfiniteJump then return end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not char or not hum or not root or hum.Health <= 0 then return end

    local vx, vz = 0, 0
    pcall(function()
        local plane = CelestialSpeed.getPlane and CelestialSpeed.getPlane()
        if plane then vx, vz = plane.X, plane.Y end
    end)
    if math.abs(vx) < 0.05 and math.abs(vz) < 0.05 then
        local md = hum.MoveDirection
        if md.Magnitude > 0.05 then
            local spd = 16
            pcall(function() spd = getActiveSpeed() or 16 end)
            vx, vz = md.X * spd, md.Z * spd
        end
    end
    root.Velocity = Vector3.new(vx, 55, vz)
end


UserInputService.JumpRequest:Connect(function()
    if not Config.InfiniteJump or Config.InfJumpMode == "Hold" then return end
    if UserInputService:GetFocusedTextBox() then return end
    applyInfiniteJumpVelocity()
end)

function isInfiniteJumpGamepad(input)
    local t = input.UserInputType
    return t == Enum.UserInputType.Gamepad1 or t == Enum.UserInputType.Gamepad2
        or t == Enum.UserInputType.Gamepad3 or t == Enum.UserInputType.Gamepad4
        or t == Enum.UserInputType.Gamepad5 or t == Enum.UserInputType.Gamepad6
        or t == Enum.UserInputType.Gamepad7 or t == Enum.UserInputType.Gamepad8
end
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if UserInputService:GetFocusedTextBox() then return end
    if input.KeyCode == Enum.KeyCode.ButtonA and isInfiniteJumpGamepad(input) then
        infiniteJumpGamepadHeld = true
        return
    end
    if gameProcessed then return end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.ButtonA and isInfiniteJumpGamepad(input) then
        infiniteJumpGamepadHeld = false
    end
end)

function bindInfiniteJumpMobileButton(button)
    for _, conn in ipairs(infiniteJumpMobileConns) do pcall(function() conn:Disconnect() end) end
    table.clear(infiniteJumpMobileConns)
    infiniteJumpTouchHeld = false
    if not button or not button:IsA("GuiButton") then return end
    table.insert(infiniteJumpMobileConns, button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then infiniteJumpTouchHeld = true end
    end))
    table.insert(infiniteJumpMobileConns, button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Touch then infiniteJumpTouchHeld = false end
    end))
    table.insert(infiniteJumpMobileConns, button.AncestryChanged:Connect(function(_, parent)
        if not parent then infiniteJumpTouchHeld = false end
    end))
end
if UserInputService.TouchEnabled then
    local pg = LP:WaitForChild("PlayerGui")
    local function findJumpButton()
        local button = pg:FindFirstChild("JumpButton", true)
        if button and button:IsA("GuiButton") then bindInfiniteJumpMobileButton(button) end
    end
    pg.DescendantAdded:Connect(function(descendant)
        if descendant.Name == "JumpButton" and descendant:IsA("GuiButton") then
            bindInfiniteJumpMobileButton(descendant)
        end
    end)
    task.defer(findJumpButton)
end

RunService.PreSimulation:Connect(function()
    if not Config.InfiniteJump or Config.InfJumpMode ~= "Hold" then return end
    if UserInputService:GetFocusedTextBox() then return end
    local held = false
    pcall(function() held = UserInputService:IsKeyDown(Enum.KeyCode.Space) end)
    if not held then
        held = infiniteJumpGamepadHeld or infiniteJumpTouchHeld
    end
    if held then applyInfiniteJumpVelocity() end
end)


function keyMatches(cfgKey, keyName)
    if not cfgKey or cfgKey == "" or cfgKey == "None" or cfgKey == "NONE" then return false end
    return tostring(cfgKey):upper() == tostring(keyName):upper()
end

UserInputService.InputBegan:Connect(function(input, gp)
    if keybindCaptureActive then return end
    local isKb = input.UserInputType == Enum.UserInputType.Keyboard
    local isPad = input.UserInputType == Enum.UserInputType.Gamepad1
    if not (isKb or isPad) then return end
    local keyName = input.KeyCode.Name

end)




AntiRagdollV1 = {
    Enabled = false,
    HeartbeatThread = false,
    CharacterConnection = nil,
    CameraConnection = nil,
    CachedCharacter = nil,
    IsBoosting = false,
    LastBoostTime = 0,
    Connections = {},
}

function cacheAntiRagdollCharacter()
    local char = LP.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return false end
    AntiRagdollV1.CachedCharacter = { character = char, humanoid = hum, root = root }
    return true
end

function isAntiRagdollCharacterDown()
    local cached = AntiRagdollV1.CachedCharacter
    if not cached or not cached.humanoid or not cached.humanoid.Parent then return false end
    local state = cached.humanoid:GetState()
    return state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Ragdoll
        or state == Enum.HumanoidStateType.FallingDown
        or cached.humanoid.PlatformStand
end

function forceAntiRagdollRecovery()
    local cached = AntiRagdollV1.CachedCharacter
    if not cached or not cached.character or not cached.humanoid or not cached.root then return end
    local char, hum, root = cached.character, cached.humanoid, cached.root
    if not char.Parent or not hum.Parent or not root.Parent or hum.Health <= 0 then return end

    pcall(function()
        LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
    end)

    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BallSocketConstraint")
            or (obj:IsA("Attachment") and string.find(obj.Name, "RagdollAttachment", 1, true)) then
            pcall(function() obj:Destroy() end)
        end
    end

    AntiRagdollV1.IsBoosting = true
    AntiRagdollV1.LastBoostTime = os.clock()
    pcall(function()
        root.Anchored = false
        hum.PlatformStand = false
        hum.Sit = false
        hum.AutoRotate = true
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end)
end

antiRagdollV1ReferenceConnection = nil
antiRagdollV1CharacterConnection = nil

function resetAntiRagdollV1Character(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end
    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        hum:ChangeState(Enum.HumanoidStateType.Running)
        root.Velocity = Vector3.zero
        root.RotVelocity = Vector3.zero
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        hum.PlatformStand = false
        hum.Sit = false
        hum.AutoRotate = true
        hum.JumpPower = hum.JumpPower > 0 and hum.JumpPower or 50
        hum.WalkSpeed = hum.WalkSpeed > 0 and hum.WalkSpeed or 16
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then
                obj.Enabled = true
            elseif obj:IsA("Constraint") then
                obj.Enabled = true
            elseif obj:IsA("BasePart") then
                obj.CanCollide = true
                obj.AssemblyLinearVelocity = Vector3.zero
                obj.AssemblyAngularVelocity = Vector3.zero
            end
        end
        local cam = workspace.CurrentCamera
        if cam then cam.CameraSubject = hum end
        local playerScripts = LP:FindFirstChild("PlayerScripts")
        local playerModule = playerScripts and playerScripts:FindFirstChild("PlayerModule")
        local controlModule = playerModule and playerModule:FindFirstChild("ControlModule")
        if controlModule then
            local ok, mod = pcall(require, controlModule)
            if ok and mod and mod.Enable then mod:Enable() end
        end
    end)
end

function startAntiRagdollLH()
    if antiRagdollV1ReferenceConnection then return end
    AntiRagdollV1.Enabled = true
    cacheAntiRagdollCharacter()
    antiRagdollV1ReferenceConnection = RunService.Heartbeat:Connect(function()
        if not Config.AntiRagdoll or Config.AntiRagdollMode ~= "V1" then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown
            or state == Enum.HumanoidStateType.Dead
            or hum.PlatformStand == true
            or hum.Sit == true then
            resetAntiRagdollV1Character(char)
        end
    end)
    antiRagdollV1CharacterConnection = LP.CharacterAdded:Connect(function(char)
        task.wait(0.25)
        if Config.AntiRagdoll and Config.AntiRagdollMode == "V1" then
            resetAntiRagdollV1Character(char)
            cacheAntiRagdollCharacter()
        end
    end)
end

function stopAntiRagdollLH()
    AntiRagdollV1.Enabled = false
    AntiRagdollV1.IsBoosting = false
    if antiRagdollV1ReferenceConnection then
        antiRagdollV1ReferenceConnection:Disconnect()
        antiRagdollV1ReferenceConnection = nil
    end
    if antiRagdollV1CharacterConnection then
        antiRagdollV1CharacterConnection:Disconnect()
        antiRagdollV1CharacterConnection = nil
    end
    if AntiRagdollV1.CameraConnection then
        AntiRagdollV1.CameraConnection:Disconnect()
        AntiRagdollV1.CameraConnection = nil
    end
    if AntiRagdollV1.CharacterConnection then
        AntiRagdollV1.CharacterConnection:Disconnect()
        AntiRagdollV1.CharacterConnection = nil
    end
    for _, conn in ipairs(AntiRagdollV1.Connections) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(AntiRagdollV1.Connections)
    AntiRagdollV1.CachedCharacter = nil
end

AntiRagdollV2 = { Connection = nil, Character = nil, Humanoid = nil, Root = nil, CharacterConnection = nil }
function cacheAntiRagdollV2Character()
    local char = LP.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return false end
    AntiRagdollV2.Character, AntiRagdollV2.Humanoid, AntiRagdollV2.Root = char, hum, root
    local cam = workspace.CurrentCamera
    if cam then cam.CameraSubject = hum end
    return true
end
function stopAntiRagdollV2()
    if AntiRagdollV2.Connection then AntiRagdollV2.Connection:Disconnect(); AntiRagdollV2.Connection = nil end
    if AntiRagdollV2.CharacterConnection then AntiRagdollV2.CharacterConnection:Disconnect(); AntiRagdollV2.CharacterConnection = nil end
    AntiRagdollV2.Character, AntiRagdollV2.Humanoid, AntiRagdollV2.Root = nil, nil, nil
end
function startAntiRagdollV2()
    if AntiRagdollV2.Connection then return end
    if not cacheAntiRagdollV2Character() then return end
    AntiRagdollV2.CharacterConnection = LP.CharacterAdded:Connect(function()
        task.wait(0.25)
        if Config.AntiRagdoll and Config.AntiRagdollMode == "V2" then cacheAntiRagdollV2Character() end
    end)
    AntiRagdollV2.Connection = RunService.RenderStepped:Connect(function()
        local char, hum, root = AntiRagdollV2.Character, AntiRagdollV2.Humanoid, AntiRagdollV2.Root
        if not char or not char.Parent or not hum or not hum.Parent or not root or not root.Parent then
            cacheAntiRagdollV2Character()
            return
        end
        local state = hum:GetState()
        local ragdollEnd = LP:GetAttribute("RagdollEndTime")
        local timerActive = ragdollEnd and (ragdollEnd - workspace:GetServerTimeNow()) > 0
        if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown or timerActive then
            pcall(function() LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end)
            for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("BallSocketConstraint") or (obj:IsA("Attachment") and string.find(obj.Name, "RagdollAttachment", 1, true)) then
                    pcall(function() obj:Destroy() end)
                end
            end
            pcall(function()
                root.Anchored = false
                root.AssemblyLinearVelocity = Vector3.zero
                root.AssemblyAngularVelocity = Vector3.zero
                if hum.Health > 0 then hum:ChangeState(Enum.HumanoidStateType.Running) end
                local cam = workspace.CurrentCamera
                if cam and cam.CameraSubject ~= hum then cam.CameraSubject = hum end
            end)
        end
    end)
end
_G._CelestialStartAntiRagdollV2 = startAntiRagdollV2
_G._CelestialStopAntiRagdollV2 = stopAntiRagdollV2
_G._CelestialStartAntiRagdoll = startAntiRagdollLH
_G._CelestialStopAntiRagdoll = stopAntiRagdollLH
if Config.AntiRagdoll then
    if Config.AntiRagdollMode == "V2" then startAntiRagdollV2() else startAntiRagdollLH() end
end


BAT_COUNTER_SLAP_LIST = {
    "Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap", "Emerald Slap",
    "Ruby Slap", "Dark Matter Slap", "Flame Slap", "Nuclear Slap", "Galaxy Slap", "Glitched Slap",
}
batCounterConn = nil
batCounterDebounce = false
batCounterWasRagdoll = false


function brieflyFaceNearestPlayer(char, duration)
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso"))
    if not root or not root:IsA("BasePart") then return end
    local targetRoot, bestDistance = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local otherRoot = player.Character:FindFirstChild("HumanoidRootPart") or player.Character:FindFirstChild("Torso")
            local otherHum = player.Character:FindFirstChildOfClass("Humanoid")
            if otherRoot and otherRoot:IsA("BasePart") and otherHum and otherHum.Health > 0 then
                local distance = (otherRoot.Position - root.Position).Magnitude
                if distance < bestDistance then
                    bestDistance, targetRoot = distance, otherRoot
                end
            end
        end
    end
    if not targetRoot then return end
    local untilTime = tick() + (duration or 0.1)
    task.spawn(function()
        while tick() < untilTime and Config.BatCounter and LP.Character == char and root.Parent and targetRoot.Parent do
            local pos = root.Position
            local targetPos = targetRoot.Position
            local flatTarget = Vector3.new(targetPos.X, pos.Y, targetPos.Z)
            if (flatTarget - pos).Magnitude > 0.01 then
                root.CFrame = CFrame.lookAt(pos, flatTarget)
            end
            RunService.Heartbeat:Wait()
        end
    end)
end

function findBatForCounter()
    local c = LP.Character
    if not c then return nil end
    local bp = LP:FindFirstChild("Backpack") or LP:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t = c:FindFirstChild(name) or (bp and bp:FindFirstChild(name))
        if t then return t end
    end
    for _, ch in ipairs(c:GetChildren()) do
        if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
    end
    if bp then
        for _, ch in ipairs(bp:GetChildren()) do
            if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch end
        end
    end
    return nil
end

function swingBatForCounter(bat, char)
    if not bat or not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if bat.Parent ~= char then
        if hum then pcall(function() hum:EquipTool(bat) end) end
        task.wait(0.05)
    end
    local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end)
        task.wait(0.15)
        pcall(function() remote:FireServer() end)
    else
        pcall(function() bat:Activate() end)
        task.wait(0.15)
        pcall(function() bat:Activate() end)
    end
end

function counterIsRagdoll(hum)
    if not hum then return false end
    local st = hum:GetState()
    return st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown
        or hum.PlatformStand == true
end

startBatCounter = function()
    if batCounterConn then return end
    batCounterWasRagdoll = false
    batCounterDebounce = false
    local lastTrigger = 0

    batCounterConn = RunService.Heartbeat:Connect(function()
        if not Config.BatCounter then
            batCounterWasRagdoll = false
            return
        end
        if Config.BatTP or Config._smartBatTpDriving or Config._instaResetInProgress then
            batCounterWasRagdoll = false
            return
        end

        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not char or not hum then return end
        local ragdolledNow = hum:GetState() == Enum.HumanoidStateType.Physics
        if not (ragdolledNow and not batCounterWasRagdoll) then
            batCounterWasRagdoll = ragdolledNow
            return
        end
        batCounterWasRagdoll = true
        if batCounterDebounce or os.clock() - lastTrigger < 0.1 then return end
        lastTrigger = os.clock()
        batCounterDebounce = true

        task.spawn(function()
            local function release()
                batCounterDebounce = false
            end
            local ok, err = pcall(function()
                if not Config.BatCounter or Config.BatTP or Config._smartBatTpDriving then return end
                local currentChar = LP.Character
                local root = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
                local currentHum = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
                if not currentChar or not root or not currentHum then return end

                local targetRoot, bestDistance = nil, math.huge
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LP and player.Character then
                        local otherRoot = player.Character:FindFirstChild("HumanoidRootPart")
                        local otherHum = player.Character:FindFirstChildOfClass("Humanoid")
                        if otherRoot and otherHum and otherHum.Health > 0 then
                            local distance = (otherRoot.Position - root.Position).Magnitude
                            if distance < bestDistance then
                                bestDistance, targetRoot = distance, otherRoot
                            end
                        end
                    end
                end
                if not targetRoot then return end

                local bat = findBatForCounter()
                if not bat then return end
                if bat.Parent ~= currentChar then
                    pcall(function() currentHum:EquipTool(bat) end)
                    task.wait(0.015)
                end
                if not Config.BatCounter or Config.BatTP or Config._smartBatTpDriving or Config._instaResetInProgress then return end
                currentChar = LP.Character
                root = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
                currentHum = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
                if not root or not currentHum or not targetRoot.Parent then return end

                local targetPos = targetRoot.Position
                local flatTarget = Vector3.new(targetPos.X, root.Position.Y, targetPos.Z)
                if (flatTarget - root.Position).Magnitude > 0.001 then
                    currentHum.AutoRotate = false
                    root.CFrame = CFrame.lookAt(root.Position, flatTarget)
                end
                task.wait(0.02)
                if bat.Parent == currentChar then
                    pcall(function()
                        bat:Activate()
                        local remote = bat:FindFirstChildWhichIsA("RemoteEvent")
                        if remote then remote:FireServer() end
                    end)
                else
                    swingBatForCounter(bat, currentChar)
                end
                task.wait(0.2)
                if root and root.Parent then
                    pcall(function()
                        root.RotVelocity = Vector3.zero
                        root.AssemblyAngularVelocity = Vector3.zero
                    end)
                end
                if currentHum and currentHum.Parent then currentHum.AutoRotate = true end
            end)
            if not ok then warn("[Synapse X Celestial Hub] Bat Counter:", err) end
            release()
        end)
    end)
end

stopBatCounter = function()
    if batCounterConn then
        batCounterConn:Disconnect()
        batCounterConn = nil
    end
    batCounterDebounce = false
    batCounterWasRagdoll = false
end

MEDUSA_COOLDOWN = 25
medConns = {}
medDebounce = false
medLastUsed = 0

function findMedusa()
    local c = LP.Character
    if not c then return nil end
    for _, t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") then
            local n = t.Name:lower()
            if n:find("medusa") or n:find("head") or n:find("stone") then return t end
        end
    end
    local bp = LP:FindFirstChild("Backpack") or LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("medusa") or n:find("head") or n:find("stone") then return t end
            end
        end
    end
    return nil
end

function useMedusaCounter()
    if not Config.MedusaCounter then return end
    if medDebounce then return end
    if tick() - medLastUsed < MEDUSA_COOLDOWN then return end
    local c = LP.Character
    if not c then return end
    medDebounce = true
    local med = findMedusa()
    if not med then
        medDebounce = false
        return
    end
    if med.Parent ~= c then
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then pcall(function() hum:EquipTool(med) end) end
        task.wait(0.05)
    end
    pcall(function() med:Activate() end)
    medLastUsed = tick()
    medDebounce = false
end

function onMedusaAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if Config.MedusaCounter and part.Anchored and part.Transparency == 1 then
            useMedusaCounter()
        end
    end)
end

startMedusaCounter = function(char)
    stopMedusaCounter()
    char = char or LP.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(medConns, onMedusaAnchorChanged(part))
        end
    end
    table.insert(medConns, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            table.insert(medConns, onMedusaAnchorChanged(part))
        end
    end))
end

stopMedusaCounter = function()
    for _, c in pairs(medConns) do
        pcall(function() c:Disconnect() end)
    end
    medConns = {}
    medDebounce = false
end

LP.CharacterAdded:Connect(function(c)
    if Config.MedusaCounter then
        task.wait(0.2)
        startMedusaCounter(c)
    end
end)


end
__celestialInitMiscLogic()




MIRROR_TP_DROP_THRESHOLD = 3
MIRROR_TP_DOWN_Y = -7.00
mirrorTPLastTeleport = 0

function mirrorTPTeleportDown()
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then return end

    local now = tick()
    if now - (mirrorTPLastTeleport or 0) < 0.08 then return end
    mirrorTPLastTeleport = now

    local _, yaw = root.CFrame:ToEulerAnglesYXZ()
    local y = (MIRROR_TP_DOWN_Y or -7) + (math.random() * 0.6 - 0.3)
    root.CFrame = CFrame.new(root.Position.X, y, root.Position.Z) * CFrame.Angles(0, yaw, 0)
    root.AssemblyLinearVelocity = Vector3.new((math.random() - 0.5) * 0.4, 0, (math.random() - 0.5) * 0.4)
end

RunService.Heartbeat:Connect(function()
    if not mirrorTPActive or not State.autoBatToggled then
        if next(mirrorTPPreviousY) then
            table.clear(mirrorTPPreviousY)
        end
        return
    end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local root = plr.Character:FindFirstChild("HumanoidRootPart")
            if root then
                local currentY = root.Position.Y
                local previousY = mirrorTPPreviousY[plr.UserId]
                if previousY and previousY - currentY >= (MIRROR_TP_DROP_THRESHOLD or 3) then
                    pcall(mirrorTPTeleportDown)
                    table.clear(mirrorTPPreviousY)
                    return
                end
                mirrorTPPreviousY[plr.UserId] = currentY
            end
        end
    end
end)






noCamCollisionOriginal = setmetatable({}, {__mode = "k"})
noCamCollisionConns = {}

function setCharacterNoCamCollision(char, enabled)
    if not char then return end

    for _, obj in ipairs(char:GetDescendants()) do
        if obj:IsA("BasePart") then
            if enabled then
                if noCamCollisionOriginal[obj] == nil then
                    noCamCollisionOriginal[obj] = obj.CanCollide
                end
                obj.CanCollide = false
            else
                local old = noCamCollisionOriginal[obj]
                if old ~= nil then
                    pcall(function() obj.CanCollide = old end)
                    noCamCollisionOriginal[obj] = nil
                end
            end
        end
    end
end

setNoCamCollision = function(enabled)
    Config.NoCamCollision = enabled == true

    for _, c in ipairs(noCamCollisionConns) do
        pcall(function() c:Disconnect() end)
    end
    noCamCollisionConns = {}

    if not Config.NoCamCollision then
        setCharacterNoCamCollision(LP.Character, false)
        return
    end

    setCharacterNoCamCollision(LP.Character, true)

    local char = LP.Character
    if char then
        table.insert(noCamCollisionConns, char.DescendantAdded:Connect(function(obj)
            if Config.NoCamCollision and obj:IsA("BasePart") then
                if noCamCollisionOriginal[obj] == nil then
                    noCamCollisionOriginal[obj] = obj.CanCollide
                end
                obj.CanCollide = false
            end
        end))
    end
end


Config.NoCamCollision = true
pcall(setNoCamCollision, true)

LP.CharacterAdded:Connect(function(char)
    if Config.NoCamCollision then
        task.wait(0.15)
        pcall(setNoCamCollision, true)
    end
end)




ACE_ANTI_FLING_ENABLED = true
ACE_ANTI_FLING_MAX_SPEED = 200
ACE_ANTI_FLING_MAX_Y = 120
ACE_ANTI_FLING_MAX_ANG = 40

function disableCanCollideForCharacter(character)
    if not character then return end
    for _, part in ipairs(character:GetDescendants()) do
        if part:IsA("BasePart") then
            pcall(function() part.CanCollide = false end)
        end
    end
end

function applyAceAntiFling()
    if not ACE_ANTI_FLING_ENABLED or dropActive then return end

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            disableCanCollideForCharacter(plr.Character)
        end
    end

    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    pcall(function()
        local v = root.AssemblyLinearVelocity
        if v.Magnitude > ACE_ANTI_FLING_MAX_SPEED or math.abs(v.Y) > ACE_ANTI_FLING_MAX_Y then
            root.AssemblyLinearVelocity = Vector3.new(
                math.clamp(v.X, -ACE_ANTI_FLING_MAX_SPEED, ACE_ANTI_FLING_MAX_SPEED),
                math.clamp(v.Y, -ACE_ANTI_FLING_MAX_Y, ACE_ANTI_FLING_MAX_Y),
                math.clamp(v.Z, -ACE_ANTI_FLING_MAX_SPEED, ACE_ANTI_FLING_MAX_SPEED)
            )
        end

        local av = root.AssemblyAngularVelocity
        if av.Magnitude > ACE_ANTI_FLING_MAX_ANG then
            root.AssemblyAngularVelocity = av.Unit * ACE_ANTI_FLING_MAX_ANG
        end
    end)
end

RunService.PreSimulation:Connect(function()
    pcall(applyAceAntiFling)
end)

Players.PlayerAdded:Connect(function(plr)
    plr.CharacterAdded:Connect(function(char)
        task.wait(0.3)
        if ACE_ANTI_FLING_ENABLED then
            pcall(disableCanCollideForCharacter, char)
        end
    end)
end)

for _, plr in ipairs(Players:GetPlayers()) do
    if plr ~= LP then
        plr.CharacterAdded:Connect(function(char)
            task.wait(0.3)
            if ACE_ANTI_FLING_ENABLED then
                pcall(disableCanCollideForCharacter, char)
            end
        end)
    end
end







StealSys = {
    conn = nil,
    isStealing = false,
    stealStart = 0,
    totalDuration = 1.4,
    progressManual = false,
    data = {},
    animalCache = {},
    promptCache = {},
    scanLast = 0,
    progressFill = nil,
    progressLabel = nil,
    progressFrame = nil,
    titleLabel = nil,
    modeLabel = nil,
    radiusLabel = nil,
}

function StealSys.fmtMeta(fps, ms)
    return string.format('<font color="#6e6e6e">%d FPS</font> <font color="#ffffff">| %dms</font>', fps, ms)
end





function initStealProgressUI()
    local old = playerGui:FindFirstChild("CelestialStealProgress")
    if old then old:Destroy() end

    local spGui = Instance.new("ScreenGui")
    spGui.Name = "CelestialStealProgress"
    spGui.ResetOnSpawn = false
    spGui.DisplayOrder = 200
    spGui.IgnoreGuiInset = true
    spGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    spGui.Parent = playerGui

    local barW = math.floor(math.clamp(tonumber(Config.StealBarSize) or 40, 20, 90) * 6.5)

    -- outer pill: black, thin white outline
    local card = Instance.new("Frame")
    card.Name = "StealBar"
    card.Size = UDim2.new(0, barW, 0, 36)
    local savedBarX = tonumber(Config.StealBarPosX)
    local savedBarY = tonumber(Config.StealBarPosY)
    if savedBarX and savedBarY then
        card.Position = UDim2.fromOffset(savedBarX, savedBarY)
    else
        card.Position = UDim2.new(0.5, -math.floor(barW / 2), 1, -90)
    end
    card.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    card.BackgroundTransparency = 0
    card.BorderSizePixel = 0
    card.ClipsDescendants = false
    card.Active = false
    card.Selectable = false
    card.Parent = spGui

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0.5, 0)
    cardCorner.Parent = card

    local cardStroke = Instance.new("UIStroke")
    cardStroke.Name = "BarOutline"
    cardStroke.Thickness = 1.5
    cardStroke.Color = Color3.fromRGB(232, 232, 232)
    cardStroke.Transparency = 0.05
    cardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    cardStroke.Parent = card

    -- inner pill (progress track) with a thinner grey outline
    local track = Instance.new("Frame")
    track.Name = "ProgressTrack"
    track.AnchorPoint = Vector2.new(0, 0.5)
    track.Position = UDim2.new(0, 6, 0.5, 0)
    track.Size = UDim2.new(0.6, 0, 1, -10)
    track.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    track.BackgroundTransparency = 0
    track.BorderSizePixel = 0
    track.ClipsDescendants = true
    track.Active = false
    track.Selectable = false
    track.ZIndex = 2
    track.Parent = card

    local trackCorner = Instance.new("UICorner")
    trackCorner.CornerRadius = UDim.new(0.5, 0)
    trackCorner.Parent = track

    local trackStroke = Instance.new("UIStroke")
    trackStroke.Name = "TrackOutline"
    trackStroke.Thickness = 1.1
    trackStroke.Color = Color3.fromRGB(150, 150, 150)
    trackStroke.Transparency = 0.3
    trackStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    trackStroke.Parent = track

    -- progress fill (soft white, grows left to right inside the inner pill)
    local fill = Instance.new("Frame")
    fill.Name = "ProgressFill"
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.Position = UDim2.new(0, 0, 0, 0)
    fill.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
    fill.BackgroundTransparency = 0.72
    fill.BorderSizePixel = 0
    fill.Active = false
    fill.Selectable = false
    fill.ZIndex = 3
    fill.Parent = track

    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(0.5, 0)
    fillCorner.Parent = fill

    -- STEAL text (left, white fading to grey)
    local titleLbl = Instance.new("TextLabel")
    titleLbl.Name = "TitleLabel"
    titleLbl.Size = UDim2.new(0, 60, 1, 0)
    titleLbl.Position = UDim2.new(0, 12, 0, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = "STEAL"
    titleLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLbl.Font = Enum.Font.GothamBold
    titleLbl.TextSize = 14
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 6
    titleLbl.Parent = track

    local titleGradient = Instance.new("UIGradient")
    titleGradient.Color = ColorSequence.new(Color3.fromRGB(240, 240, 240), Color3.fromRGB(105, 105, 105))
    titleGradient.Parent = titleLbl

    -- percent (right side of the inner pill)
    local modeLbl = Instance.new("TextLabel")
    modeLbl.Name = "DiscordHeaderLabel"
    modeLbl.AnchorPoint = Vector2.new(1, 0)
    modeLbl.Size = UDim2.new(0.5, 0, 1, 0)
    modeLbl.Position = UDim2.new(1, -12, 0, 0)
    modeLbl.BackgroundTransparency = 1
    modeLbl.Text = "0%"
    modeLbl.TextColor3 = Color3.fromRGB(225, 225, 225)
    modeLbl.Font = Enum.Font.GothamBold
    modeLbl.TextSize = 13
    modeLbl.TextXAlignment = Enum.TextXAlignment.Right
    modeLbl.ZIndex = 6
    modeLbl.Parent = track

    -- thin vertical divider
    local headerRule = Instance.new("Frame")
    headerRule.Name = "HeaderRule"
    headerRule.Size = UDim2.new(0, 1, 0.5, 0)
    headerRule.Position = UDim2.new(0.645, 0, 0.25, 0)
    headerRule.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
    headerRule.BackgroundTransparency = 0.2
    headerRule.BorderSizePixel = 0
    headerRule.ZIndex = 4
    headerRule.Parent = card

    -- FPS | ms (right side)
    local radLbl = Instance.new("TextLabel")
    radLbl.Name = "RadiusLabel"
    radLbl.Size = UDim2.new(0.34, 0, 1, 0)
    radLbl.Position = UDim2.new(0.655, 0, 0, 0)
    radLbl.BackgroundTransparency = 1
    radLbl.RichText = true
    radLbl.Text = StealSys.fmtMeta(60, 0)
    radLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    radLbl.Font = Enum.Font.GothamBold
    radLbl.TextSize = 11
    radLbl.TextXAlignment = Enum.TextXAlignment.Center
    radLbl.ZIndex = 6
    radLbl.Parent = card

    local dragHandle = Instance.new("TextButton")
    dragHandle.Name = "DragHandle"
    dragHandle.Size = UDim2.new(1, 0, 1, 0)
    dragHandle.Position = UDim2.new(0, 0, 0, 0)
    dragHandle.BackgroundTransparency = 1
    dragHandle.Text = ""
    dragHandle.AutoButtonColor = false
    dragHandle.Active = true
    dragHandle.Selectable = false
    dragHandle.ZIndex = 8
    dragHandle.Parent = card

    -- hidden labels kept for the rest of the script
    local pct = Instance.new("TextLabel")
    pct.Name = "Status"
    pct.Size = UDim2.new(0, 0, 0, 0)
    pct.BackgroundTransparency = 1
    pct.Text = "0%"
    pct.Visible = false
    pct.Parent = card

    local discLbl = Instance.new("TextLabel")
    discLbl.Name = "DiscordLabel"
    discLbl.Size = UDim2.new(0, 0, 0, 0)
    discLbl.BackgroundTransparency = 1
    discLbl.Text = ""
    discLbl.Visible = false
    discLbl.Parent = card

    StealSys.progressGui = spGui
    StealSys.progressFill = fill
    StealSys.progressLabel = pct
    StealSys.progressFrame = card
    StealSys.titleLabel = titleLbl
    StealSys.modeLabel = modeLbl
    StealSys.discordLabel = discLbl
    StealSys.radiusLabel = radLbl

    -- the steal bar keeps its own black / white look, it is not affected by the Buttons&Gui theme
    local function applyStealBarTheme()
        cardStroke.Color = Color3.fromRGB(232, 232, 232)
        trackStroke.Color = Color3.fromRGB(150, 150, 150)
        headerRule.BackgroundColor3 = Color3.fromRGB(150, 150, 150)
        fill.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
    end
    StealSys.applyTheme = applyStealBarTheme
    applyStealBarTheme()

    do
        local dragging, dragStart, startPos
        dragHandle.InputBegan:Connect(function(input)
            if Config.LockUI or _G.CelestialUILocked then return end
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = card.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if Config.LockUI or _G.CelestialUILocked then dragging = false; return end
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                local d = input.Position - dragStart
                card.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + d.X,
                    startPos.Y.Scale, startPos.Y.Offset + d.Y
                )
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    if StealSys.saveBarPosition then
                        StealSys.saveBarPosition()
                    else
                        Config.StealBarPosX = card.AbsolutePosition.X
                        Config.StealBarPosY = card.AbsolutePosition.Y
                        saveConfig()
                    end
                end
                dragging = false
            end
        end)
    end

    function StealSys.applyBarSize()
        local s = math.clamp(tonumber(Config.StealBarSize) or 40, 20, 90)
        local scale = s / 40
        local w = math.floor(s * 6.5)
        local h = math.floor(36 * scale)

        if StealSys.progressFrame then
            local p = StealSys.progressFrame.Position
            StealSys.progressFrame.Size = UDim2.new(0, w, 0, h)
            StealSys.progressFrame.Position = UDim2.new(p.X.Scale, p.X.Offset, p.Y.Scale, p.Y.Offset)
        end
        local trackObj = StealSys.progressFrame and StealSys.progressFrame:FindFirstChild("ProgressTrack")
        if trackObj then
            trackObj.Position = UDim2.new(0, math.max(4, math.floor(6 * scale)), 0.5, 0)
            trackObj.Size = UDim2.new(0.6, 0, 1, -math.max(8, math.floor(10 * scale)))
        end
        if StealSys.titleLabel then
            StealSys.titleLabel.Text = "STEAL"
            StealSys.titleLabel.TextSize = math.clamp(math.floor(14 * scale + 0.5), 10, 20)
            StealSys.titleLabel.Size = UDim2.new(0, math.floor(60 * scale), 1, 0)
            StealSys.titleLabel.Position = UDim2.new(0, math.floor(12 * scale), 0, 0)
        end
        if StealSys.modeLabel then
            StealSys.modeLabel.TextSize = math.clamp(math.floor(13 * scale + 0.5), 10, 18)
            StealSys.modeLabel.Size = UDim2.new(0.5, 0, 1, 0)
            StealSys.modeLabel.Position = UDim2.new(1, -math.floor(12 * scale), 0, 0)
        end
        if StealSys.radiusLabel then
            StealSys.radiusLabel.TextSize = math.clamp(math.floor(11 * scale + 0.5), 8, 15)
            StealSys.radiusLabel.Size = UDim2.new(0.34, 0, 1, 0)
            StealSys.radiusLabel.Position = UDim2.new(0.655, 0, 0, 0)
        end
        if StealSys.discordLabel then
            StealSys.discordLabel.Visible = false
        end
        if StealSys.progressLabel then
            StealSys.progressLabel.Visible = false
        end

        saveConfig()
    end

    function StealSys.saveBarPosition()
        local cardRef = StealSys.progressFrame
        if not cardRef then return end
        Config.StealBarPosX = cardRef.AbsolutePosition.X
        Config.StealBarPosY = cardRef.AbsolutePosition.Y
        saveConfig()
    end

    function StealSys.resetBarPosition()
        local cardRef = StealSys.progressFrame
        if not cardRef then return end
        local cam = workspace.CurrentCamera
        local viewport = cam and cam.ViewportSize or Vector2.new(1920, 1080)
        local w = cardRef.AbsoluteSize.X
        local h = cardRef.AbsoluteSize.Y
        local x = math.max(0, math.floor((viewport.X - w) / 2))
        local y = math.max(0, math.floor(viewport.Y - h - 100))
        cardRef.Position = UDim2.fromOffset(x, y)
        Config.StealBarPosX = x
        Config.StealBarPosY = y
        saveConfig()
    end

    task.defer(function()
        if StealSys.applyBarSize then StealSys.applyBarSize() end
    end)
end
initStealProgressUI()

function StealSys.refreshMeta()
    if StealSys.titleLabel then
        StealSys.titleLabel.Text = "STEAL"
    end
    -- radiusLabel used as FPS/ms display (updated from RenderStepped elsewhere)
    if StealSys.radiusLabel then
        local fps = StealSys._lastFps or 60
        local ms = StealSys._lastMs or 0
        StealSys.radiusLabel.Text = StealSys.fmtMeta(fps, ms)
    end
end

refreshStealBarMeta = function()
    StealSys.refreshMeta()
    if StealSys.applyTheme then pcall(StealSys.applyTheme) end
end

local activeStealFillTween
function updateStealProgress(progress, label)
    local f = math.clamp(tonumber(progress) or 0, 0, 1)
    if StealSys.progressFill then
        local fill = StealSys.progressFill
        fill.BackgroundColor3 = Color3.fromRGB(235, 235, 235)
        if activeStealFillTween then
            pcall(function() activeStealFillTween:Cancel() end)
        end
        activeStealFillTween = TweenService:Create(fill, TweenInfo.new(0.07, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), {
            Size = UDim2.new(f, 0, 1, 0)
        })
        activeStealFillTween:Play()
    end
    -- also drive the AccentRail width like the image progress
    local rail = StealSys.progressFrame and StealSys.progressFrame:FindFirstChild("AccentRail")
    if rail then
        rail.Size = UDim2.new(f, 0, 1, 0)
    end
    local pctText = "0%"
    if label and label ~= "" then
        pctText = label
    elseif f > 0 then
        pctText = string.format("%d%%", math.floor(f * 100 + 0.5))
    else
        pctText = Config.AutoSteal and "0%" or "OFF"
    end
    if StealSys.modeLabel then
        StealSys.modeLabel.Text = pctText
        StealSys.modeLabel.TextColor3 = Color3.fromRGB(220, 220, 220)
    end
    if StealSys.progressLabel then
        StealSys.progressLabel.Text = pctText
    end
    refreshStealBarMeta()
end

function resetStealProgress()
    updateStealProgress(0, Config.AutoSteal and "0%" or "OFF")
    refreshStealBarMeta()
end


task.defer(refreshStealBarMeta)


local _stealFpsLast = tick()
local _stealFpsFrames = 0
RunService.RenderStepped:Connect(function(dt)
    _stealFpsFrames = _stealFpsFrames + 1
    local now = tick()
    if now - _stealFpsLast >= 0.5 then
        local fps = math.floor(_stealFpsFrames / (now - _stealFpsLast) + 0.5)
        StealSys._lastFps = fps
        StealSys._lastMs = math.floor((dt or 0.016) * 1000 + 0.5)
        _stealFpsFrames = 0
        _stealFpsLast = now
        if StealSys.radiusLabel and not StealSys.isStealing then
            StealSys.radiusLabel.Text = StealSys.fmtMeta(StealSys._lastFps, StealSys._lastMs)
        end
    end
    if not StealSys.progressFrame then return end
    if StealSys.progressManual then return end
    if StealSys.isStealing and StealSys.stealStart > 0 then
        local dur = StealSys.totalDuration > 0 and StealSys.totalDuration or 1.3
        local f = math.clamp((tick() - StealSys.stealStart) / dur, 0, 1)
        updateStealProgress(f)
    end
end)

function stealIsMyPlot(plotName)
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return false end
    local plot = plots:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
    end
    return false
end

function stealFindNearestPrompt(radius)
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local nearest, dist = nil, math.huge
    for _, plot in ipairs(plots:GetChildren()) do
        if not stealIsMyPlot(plot.Name) then
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _, pod in ipairs(pods:GetChildren()) do
                    local base = pod:FindFirstChild("Base")
                    local sp = base and base:FindFirstChild("Spawn")
                    if sp then
                        local d = (sp.Position - root.Position).Magnitude
                        if d <= radius and d < dist then
                            local found = nil
                            local att = sp:FindFirstChild("PromptAttachment")
                            if att then
                                for _, pr in ipairs(att:GetChildren()) do
                                    if pr:IsA("ProximityPrompt") and pr.ActionText and pr.ActionText:find("Steal") then
                                        found = pr
                                    end
                                end
                            end
                            if not found then
                                for _, pr in ipairs(sp:GetDescendants()) do
                                    if pr:IsA("ProximityPrompt") and pr.ActionText and pr.ActionText:find("Steal") then
                                        found = pr
                                    end
                                end
                            end
                            if found then nearest, dist = found, d end
                        end
                    end
                end
            end
        end
    end
    return nearest, dist
end

function stealPromptDist(prompt)
    local char = LP.Character
    if not char then return math.huge end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return math.huge end
    local part = prompt.Parent
    if part and part:IsA("Attachment") then part = part.Parent end
    if part and part:IsA("BasePart") then
        return (part.Position - root.Position).Magnitude
    end
    return math.huge
end

function stealBuildCallbacks(prompt)
    if StealSys.data[prompt] then return StealSys.data[prompt] end
    local data = { hold = {}, trigger = {}, ready = true }
    if getconnections then
        pcall(function()
            for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                if c.Function then table.insert(data.hold, c.Function) end
            end
            for _, c in ipairs(getconnections(prompt.Triggered)) do
                if c.Function then table.insert(data.trigger, c.Function) end
            end
        end)
    end
    StealSys.data[prompt] = data
    return data
end

function stealScanAnimals()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return end
    local newCache = {}
    for _, plot in ipairs(plots:GetChildren()) do
        if plot:IsA("Model") and not stealIsMyPlot(plot.Name) then
            local pods = plot:FindFirstChild("AnimalPodiums")
            if pods then
                for _, pod in ipairs(pods:GetChildren()) do
                    if pod:IsA("Model") and pod:FindFirstChild("Base") then
                        local uid = plot.Name .. "_" .. pod.Name
                        table.insert(newCache, {
                            name = pod.Name,
                            plot = plot.Name,
                            slot = pod.Name,
                            worldPosition = pod:GetPivot().Position,
                            uid = uid,
                        })
                    end
                end
            end
        end
    end
    StealSys.animalCache = newCache
end

function stealFindPromptForAnimal(ad)
    if not ad then return nil end
    local cp = StealSys.promptCache[ad.uid]
    if cp and cp.Parent then return cp end
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    local plot = plots:FindFirstChild(ad.plot)
    if not plot then return nil end
    local pods = plot:FindFirstChild("AnimalPodiums")
    if not pods then return nil end
    local pod = pods:FindFirstChild(ad.slot)
    if not pod then return nil end
    local base = pod:FindFirstChild("Base")
    local spawn = base and base:FindFirstChild("Spawn")
    if not spawn then return nil end
    local prompt = nil
    local att = spawn:FindFirstChild("PromptAttachment")
    if att then
        for _, p in ipairs(att:GetChildren()) do
            if p:IsA("ProximityPrompt") then prompt = p; break end
        end
    end
    if not prompt then
        for _, obj in ipairs(spawn:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then prompt = obj; break end
        end
    end
    if prompt then StealSys.promptCache[ad.uid] = prompt end
    return prompt
end

function stealNearestAnimal(radius)
    local char = LP.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    local best, bestD = nil, math.huge
    for _, ad in ipairs(StealSys.animalCache) do
        if ad.worldPosition then
            local d = (hrp.Position - ad.worldPosition).Magnitude
            if d <= radius and d < bestD then
                bestD = d
                best = ad
            end
        end
    end
    return best, bestD
end


function executeStealV1(prompt)
    if StealSys.isStealing then return end
    local data = stealBuildCallbacks(prompt)
    if not data.ready then return end
    data.ready = false
    StealSys.isStealing = true
    StealSys.stealStart = tick()
    StealSys.totalDuration = 1.3
    updateStealProgress(0, "STEALING")
    task.spawn(function()
        for _, fn in ipairs(data.hold) do task.spawn(fn) end
        task.wait(StealSys.totalDuration)
        for _, fn in ipairs(data.trigger) do task.spawn(fn) end
        data.ready = true
        StealSys.isStealing = false
        StealSys.stealStart = 0
        updateStealProgress(1, "READY")
        task.wait(0.15)
        resetStealProgress()
    end)
end


function stealGetPromptPosition(prompt)
    if not prompt then return nil end
    local p = prompt.Parent
    while p and p ~= workspace do
        if p:IsA("BasePart") then return p.Position end
        p = p.Parent
    end
    return nil
end

function executeStealV2(prompt, animalData)
    local podName = animalData and (animalData.name or animalData.slot) or nil
    if StealSys.isStealing then return end
    if not Config.AutoSteal then return end
    local data = stealBuildCallbacks(prompt)
    if not data.ready then return end
    data.ready = false
    StealSys.isStealing = true
    StealSys.progressManual = true
    StealSys.stealStart = tick()


    local duration = 1.35
    local stopAtPercent = tonumber(Config.AutoStealStopAt) or 75
    local threshold = math.clamp(stopAtPercent, 75, 95) / 100
    local nearDist = threshold >= 0.80 and 7 or 9.3
    local timeToThreshold = math.max(0.05, duration * threshold)
    local timeAfterThreshold = math.max(0.05, duration - timeToThreshold)
    local waitNearMax = 1.6

    StealSys.totalDuration = duration
    updateStealProgress(0, "0%")

    task.spawn(function()

        for _, fn in ipairs(data.hold) do
            pcall(function() task.spawn(fn) end)
        end

        local startTime = tick()


        while tick() - startTime < timeToThreshold do
            if not Config.AutoSteal or not StealSys.isStealing then
                data.ready = true
                StealSys.isStealing = false
                StealSys.progressManual = false
                StealSys.stealStart = 0
                resetStealProgress()
                return
            end
            local p = math.clamp((tick() - startTime) / duration, 0, threshold)
            updateStealProgress(p, string.format("%d%%", math.floor(p * 100 + 0.5)))
            task.wait()
        end
        updateStealProgress(threshold, string.format("%d%%", math.floor(threshold * 100 + 0.5)))


        local function isNear()
            local char = LP.Character
            local hrp = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
            if not hrp then return false end
            if animalData and animalData.plot and animalData.slot then
                local plots = workspace:FindFirstChild("Plots")
                local plot = plots and plots:FindFirstChild(animalData.plot)
                local pods = plot and plot:FindFirstChild("AnimalPodiums")
                local pod = pods and pods:FindFirstChild(animalData.slot)
                if pod then
                    local ok, pos = pcall(function() return pod:GetPivot().Position end)
                    if ok and pos then return (pos - hrp.Position).Magnitude <= nearDist end
                end
            end
            local pos = stealGetPromptPosition(prompt)
            if not pos then return false end
            return (pos - hrp.Position).Magnitude <= nearDist
        end

        local stillNear = isNear()
        if not stillNear then
            local holdStart = tick()
            while tick() - holdStart < waitNearMax do
                if not Config.AutoSteal or not StealSys.isStealing then
                    data.ready = true
                    StealSys.isStealing = false
                    StealSys.progressManual = false
                    StealSys.stealStart = 0
                    resetStealProgress()
                    return
                end
                updateStealProgress(threshold, string.format("%d%%", math.floor(threshold * 100 + 0.5)))
                if isNear() then
                    stillNear = true
                    break
                end
                task.wait()
            end
            if not stillNear then
                data.ready = true
                StealSys.isStealing = false
                StealSys.progressManual = false
                StealSys.stealStart = 0
                resetStealProgress()
                return
            end
        end


        local resumeTime = tick()
        while tick() - resumeTime < timeAfterThreshold do
            if not Config.AutoSteal or not StealSys.isStealing then
                data.ready = true
                StealSys.isStealing = false
                StealSys.progressManual = false
                StealSys.stealStart = 0
                resetStealProgress()
                return
            end
            local fin = (tick() - resumeTime) / math.max(timeAfterThreshold, 0.01)
            local overall = threshold + fin * (1 - threshold)
            updateStealProgress(overall, string.format("%d%%", math.floor(overall * 100 + 0.5)))
            task.wait()
        end
        updateStealProgress(1, "100%")

        for _, fn in ipairs(data.trigger) do
            pcall(function() task.spawn(fn) end)
        end
        pcall(function()
            local remote = game:GetService("ReplicatedStorage"):FindFirstChild("StealAnimal")
            if remote and podName then
                remote:FireServer(podName)
            end
            if prompt and prompt.Fire then
                pcall(function() prompt:Fire() end)
            end
        end)

        task.wait(0.05)
        data.ready = true
        StealSys.isStealing = false
        StealSys.progressManual = false
        StealSys.stealStart = 0
        updateStealProgress(1, "READY")
        task.wait(0.12)
        resetStealProgress()
    end)
end


function executeStealSemi(prompt, animalData)
    if StealSys.isStealing then return end
    local data = stealBuildCallbacks(prompt)
    if not data.ready then return end
    data.ready = false
    StealSys.isStealing = true
    StealSys.stealStart = tick()
    local HOLD_MIN = 1.3
    local HOLD_MAX = 2.6
    local STEAL_RANGE = 8
    local ENTRY_DELAY = 0.3
    StealSys.totalDuration = HOLD_MAX
    updateStealProgress(0, "STEALING")
    task.spawn(function()
        local function liveRadius()
            return math.max(1, tonumber(Config.AutoStealRadius) or 61)
        end
        local function distNow()
            if animalData and animalData.worldPosition then
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then return (hrp.Position - animalData.worldPosition).Magnitude end
            end
            return stealPromptDist(prompt)
        end
        for _, fn in ipairs(data.hold) do task.spawn(fn) end
        task.wait(HOLD_MIN)
        if distNow() > liveRadius() then
            data.ready = true
            StealSys.isStealing = false
            StealSys.stealStart = 0
            resetStealProgress()
            return
        end
        local alreadyInRange = distNow() <= STEAL_RANGE
        while true do
            local el = tick() - StealSys.stealStart
            if el > HOLD_MAX or not prompt.Parent then break end
            if not Config.AutoSteal then break end
            local d = distNow()
            if d > liveRadius() then
                data.ready = true
                StealSys.isStealing = false
                StealSys.stealStart = 0
                resetStealProgress()
                return
            end
            if d <= STEAL_RANGE then
                if not alreadyInRange then task.wait(ENTRY_DELAY) end
                for _, fn in ipairs(data.trigger) do task.spawn(fn) end
                break
            end
            task.wait()
        end
        task.wait(0.05)
        data.ready = true
        StealSys.isStealing = false
        StealSys.stealStart = 0
        updateStealProgress(1, "READY")
        task.wait(0.15)
        resetStealProgress()
    end)
end

startAutoStealSystem = function()
    if StealSys.conn then return end
    stealScanAnimals()
    resetStealProgress()
    StealSys.conn = RunService.Heartbeat:Connect(function()
        if not Config.AutoSteal then return end
        if os.clock() < (Config._AutoStealHitPauseUntil or 0) then return end
        if StealSys.isStealing then return end


        if tick() - StealSys.scanLast > 5 then
            StealSys.scanLast = tick()
            stealScanAnimals()
        end

        local radius = tonumber(Config.AutoStealRadius) or 9
        local mode = Config.AutoStealMode

        if mode == "Semi" then
            local target = nil
            local bestD = math.huge
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, ad in ipairs(StealSys.animalCache) do
                    if ad.worldPosition then
                        local d = (hrp.Position - ad.worldPosition).Magnitude
                        if d <= radius and d < bestD then
                            bestD = d
                            target = ad
                        end
                    end
                end
            end
            if not target then return end
            local prompt = stealFindPromptForAnimal(target)
            if prompt then executeStealSemi(prompt, target) end
            return
        end


        local ver = Config.AutoStealVersion or "V1"
        if ver == "V3" then ver = "V2" end

        if ver == "V2" then
            local target, dist = stealNearestAnimal(radius)
            if not target then return end
            if dist and dist > radius then return end
            local prompt = stealFindPromptForAnimal(target)
            if prompt then executeStealV2(prompt, target) end
        else

            local prompt = stealFindNearestPrompt(radius)
            if prompt then executeStealV1(prompt) end
        end
    end)
end

stopAutoStealSystem = function()
    if StealSys.conn then
        StealSys.conn:Disconnect()
        StealSys.conn = nil
    end
    StealSys.isStealing = false
    StealSys.progressManual = false
    StealSys.stealStart = 0
    resetStealProgress()
end

Config._AutoStealHitPauseUntil = Config._AutoStealHitPauseUntil or 0
Config._AutoStealHitToken = Config._AutoStealHitToken or 0
Config._AutoStealLastRagdoll = false
Config._AutoStealLastHealth = nil

function isAutoStealCharacterRagdolled()
    local character = LP.Character
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end
    local now = workspace:GetServerTimeNow()
    local ragdollEnd = LP:GetAttribute("RagdollEndTime") or character:GetAttribute("RagdollEndTime") or humanoid:GetAttribute("RagdollEndTime")
    if type(ragdollEnd) == "number" and ragdollEnd > now then return true end
    if LP:GetAttribute("Ragdolled") == true or LP:GetAttribute("Ragdoll") == true
        or character:GetAttribute("Ragdolled") == true or character:GetAttribute("Ragdoll") == true
        or humanoid:GetAttribute("Ragdolled") == true or humanoid:GetAttribute("Ragdoll") == true then
        return true
    end
    local state = humanoid:GetState()
    return humanoid.PlatformStand or state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
end

function triggerAutoStealHitPause()
    if not Config.AutoStealStopWhenHit or not Config.AutoSteal then return end
    if os.clock() < (Config._AutoStealHitPauseUntil or 0) then return end
    local pause = math.clamp(tonumber(Config.AutoStealHitPauseSeconds) or 1.3, 0.1, 30)
    Config._AutoStealHitPauseUntil = os.clock() + pause
    Config._AutoStealHitToken = Config._AutoStealHitToken + 1
    local token = Config._AutoStealHitToken
    stopAutoStealSystem()
    task.delay(pause, function()
        if token ~= Config._AutoStealHitToken then return end
        Config._AutoStealHitPauseUntil = 0
        if Config.AutoSteal and Config.AutoStealStopWhenHit then startAutoStealSystem() end
    end)
end

function bindAutoStealHitSignals(character)
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    Config._AutoStealLastHealth = humanoid.Health
    humanoid.HealthChanged:Connect(function(health)
        local previous = Config._AutoStealLastHealth
        Config._AutoStealLastHealth = health
        if previous and health < previous then triggerAutoStealHitPause() end
    end)
    humanoid.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Physics or newState == Enum.HumanoidStateType.Ragdoll
            or newState == Enum.HumanoidStateType.FallingDown then
            triggerAutoStealHitPause()
        end
    end)
    humanoid:GetPropertyChangedSignal("PlatformStand"):Connect(function()
        if humanoid.PlatformStand then triggerAutoStealHitPause() end
    end)
    for _, object in ipairs({LP, character, humanoid}) do
        for _, attribute in ipairs({"RagdollEndTime", "Ragdolled", "Ragdoll"}) do
            object:GetAttributeChangedSignal(attribute):Connect(function()
                if isAutoStealCharacterRagdolled() then triggerAutoStealHitPause() end
            end)
        end
    end
end

if not Config._AutoStealHitMonitorStarted then
    Config._AutoStealHitMonitorStarted = true
    RunService.Heartbeat:Connect(function()
        if not Config.AutoStealStopWhenHit or not Config.AutoSteal then
            Config._AutoStealLastRagdoll = false
            return
        end
        local ragdolled = isAutoStealCharacterRagdolled()
        if ragdolled and not Config._AutoStealLastRagdoll then triggerAutoStealHitPause() end
        Config._AutoStealLastRagdoll = ragdolled
    end)
    LP.CharacterAdded:Connect(function(character)
        Config._AutoStealLastRagdoll = false
        task.delay(0.1, function() bindAutoStealHitSignals(character) end)
    end)
    task.defer(function()
        if LP.Character then bindAutoStealHitSignals(LP.Character) end
    end)
end

if Config.AutoSteal then
    task.defer(function()
        task.wait(0.5)
        pcall(startAutoStealSystem)
    end)
end




AP_LEFT_FULL = {
    Vector3.new(-475.86, -7, 91.97),
    Vector3.new(-485.83, -7, 97.37),
    Vector3.new(-475.86, -7, 91.97),
    Vector3.new(-476.35, -7, 27.88),
    Vector3.new(-477.09, -7, 19.85),
}
AP_RIGHT_FULL = {
    Vector3.new(-475.84, -7, 28.81),
    Vector3.new(-486.04, -7, 23.32),
    Vector3.new(-475.51, -7, 29.01),
    Vector3.new(-476.43, -7, 91.61),
    Vector3.new(-476.27, -7, 98.86),
}
AP_LEFT_HALF = {
    Vector3.new(-476.48, -6.28, 92.73),
    Vector3.new(-483.12, -4.95, 94.8),
}
AP_RIGHT_HALF = {
    Vector3.new(-476.16, -6.52, 25.62),
    Vector3.new(-483.06, -5.03, 25.48),
}
AP_L1 = AP_LEFT_HALF[1]
AP_L2 = AP_LEFT_HALF[2]
AP_R1 = AP_RIGHT_HALF[1]
AP_R2 = AP_RIGHT_HALF[2]

alConn, arConn = nil, nil
alPhase, arPhase = 1, 1
pathMoveDir = Vector3.zero

function pathApplySpeed(hrp, hum, dir, spd)
    if not hrp or not hum then return end
    if dir.Magnitude < 0.01 then
        _speedLVClear(hrp)
        hum:Move(Vector3.zero, false)
        hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
        return
    end
    local unit = dir.Unit
    pcall(function()
        hum.AutoRotate = true
        hum:Move(Vector3.new(unit.X, 0, unit.Z), false)
    end)
    _speedLVSet(hrp, unit.X * spd, unit.Z * spd)
end

function pathDirTo(hrp, target)
    local d = target - hrp.Position
    local mv = Vector3.new(d.X, 0, d.Z)
    if mv.Magnitude > 0.01 then return mv.Unit end
    return Vector3.zero
end

function celestialDetectAutoPlaySide()
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return "left" end
    for _, plot in ipairs(plots:GetChildren()) do
        local sign = plot:FindFirstChild("PlotSign")
        local yourBase = sign and sign:FindFirstChild("YourBase")
        if yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled then
            local marker = plot:FindFirstChild("AnimalTarget", true)
            local pos = marker and marker.Position
            if not pos then
                local delivery = plot:FindFirstChild("DeliveryHitbox")
                pos = delivery and delivery.Position
            end
            if pos then
                local dL = (pos - AP_LEFT_FULL[1]).Magnitude
                local dR = (pos - AP_RIGHT_FULL[1]).Magnitude
                return dL <= dR and "left" or "right"
            end
            local pivotPos
            pcall(function()
                if typeof(plot.GetPivot) == "function" then
                    local piv = plot:GetPivot()
                    if piv then pivotPos = piv.Position end
                end
            end)
            if pivotPos then
                return pivotPos.Z >= 60 and "right" or "left"
            end
            local root = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if root then
                return root.Position.Z >= 60 and "right" or "left"
            end
        end
    end
    return "left"
end

function celestialGetAutoPlayWaypoints(side)
    return side == "right" and AP_RIGHT_HALF or AP_LEFT_HALF
end

function celestialStopAutoPath(side)
    if side == "left" then
        if alConn then alConn:Disconnect(); alConn = nil end
        alPhase = 1
        Config.AutoLeft = false
        if mobBtnRefs and mobBtnRefs.autoLeft then pcall(mobBtnRefs.autoLeft, false) end
    else
        if arConn then arConn:Disconnect(); arConn = nil end
        arPhase = 1
        Config.AutoRight = false
        if mobBtnRefs and mobBtnRefs.autoRight then pcall(mobBtnRefs.autoRight, false) end
    end
    pathMoveDir = Vector3.zero
    if Config.AutoPlayMode == "1 Btn" and mobBtnRefs and mobBtnRefs.autoPlay then
        if not Config.AutoLeft and not Config.AutoRight then
            pcall(mobBtnRefs.autoPlay, false)
        end
    end
    local char = LP.Character
    if char then
        local h = char:FindFirstChildOfClass("Humanoid")
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if h then pcall(function() h:Move(Vector3.zero, false) end) end
        if hrp then
            _speedLVClear(hrp)
            hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
        end
    end
end

stopAutoLeft = function()
    celestialStopAutoPath("left")
end

stopAutoRight = function()
    celestialStopAutoPath("right")
end

function celestialRunAutoPath(side)
    if safeModeTryStart and not safeModeTryStart() then return end
    if side == "left" then
        if arConn then stopAutoRight() end
        if alConn then alConn:Disconnect(); alConn = nil end
        Config.AutoLeft = true
        Config.AutoRight = false
        alPhase = 1
    else
        if alConn then stopAutoLeft() end
        if arConn then arConn:Disconnect(); arConn = nil end
        Config.AutoRight = true
        Config.AutoLeft = false
        arPhase = 1
    end
    pathMoveDir = Vector3.zero
    local waypoints = celestialGetAutoPlayWaypoints(side)
    local wpIndex = 1
    local missingSince = nil

    local conn
    conn = RunService.Heartbeat:Connect(function()
        local active = side == "left" and Config.AutoLeft or Config.AutoRight
        if not active then return end
        local char = LP.Character
        if not char then
            missingSince = missingSince or os.clock()
            if os.clock() - missingSince > 5 then
                if side == "left" then stopAutoLeft() else stopAutoRight() end
            end
            return
        end
        missingSince = nil
        local hrp = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end
        if isRagdollState and isRagdollState(hum) then
            pathMoveDir = Vector3.zero
            pcall(function() hum:Move(Vector3.zero, false) end)
            return
        end

        local target = waypoints[wpIndex]
        if not target then
            if side == "left" then stopAutoLeft() else stopAutoRight() end
            return
        end

        local flatPos = Vector3.new(hrp.Position.X, 0, hrp.Position.Z)
        local flatTgt = Vector3.new(target.X, 0, target.Z)
        local dist = (flatTgt - flatPos).Magnitude
        local horizVel = Vector3.new(hrp.AssemblyLinearVelocity.X, 0, hrp.AssemblyLinearVelocity.Z)

        if dist <= 1.1 and (horizVel.Magnitude < 28 or dist <= 0.4) then
            pathApplySpeed(hrp, hum, Vector3.zero, 0)
            if wpIndex >= #waypoints then
                if side == "left" then stopAutoLeft() else stopAutoRight() end
                return
            end
            wpIndex = wpIndex + 1
            if side == "left" then alPhase = wpIndex else arPhase = wpIndex end
            return
        end

        local dir = flatTgt - flatPos
        if dir.Magnitude > 0.001 then dir = dir.Unit else dir = Vector3.zero end
        pathMoveDir = dir
        local spd = getPathSpeed()
        if dist < 1.5 then
            spd = spd * math.clamp(dist / 1.5, 0.6, 1)
        end
        pathApplySpeed(hrp, hum, dir, spd)
    end)

    if side == "left" then
        alConn = conn
    else
        arConn = conn
    end
end

startAutoLeft = function()
    celestialRunAutoPath("left")
end

startAutoRight = function()
    celestialRunAutoPath("right")
end




LP:GetAttributeChangedSignal("Stealing"):Connect(function()

    if not Config.AutoCarrySpeed then
        autoCarryBoost = false
        return
    end
    local isStealing = LP:GetAttribute("Stealing") == true
    autoCarryBoost = isStealing == true
end)

-- AutoSwing stay on PreSimulation
RunService.PreSimulation:Connect(function()
    local char = LP.Character
    if char and Config.AutoSwing and State.autoBatToggled and Config.BatAimbot then
        local tool = char:FindFirstChildOfClass("Tool")
        if tool and (tool.Name:lower():find("bat") or tool.Name:lower():find("slap")) then
            tool:Activate()
        end
    end

    if Config.AutoLeft or Config.AutoRight then
        if pathMoveDir and pathMoveDir.Magnitude > 0.01 then
            local char2 = LP.Character
            local hrp2 = char2 and char2:FindFirstChild("HumanoidRootPart")
            local hum2 = char2 and char2:FindFirstChildOfClass("Humanoid")
            if hrp2 and hum2 then
                pathApplySpeed(hrp2, hum2, pathMoveDir, getPathSpeed())
            end
        end
    end
end)

-- Bubble Hub Speed Boost movement (RenderStepped) - same Oi logic
RunService.RenderStepped:Connect(function()
    if State and (State.autoBatToggled or State.bypassAimbotToggled) then return end
    if Config.AutoLeft or Config.AutoRight then return end
    if _G.dropActive or dropActive then return end
    applyVelocitySpeed(getActiveSpeed())
end)

lastCarryKeyTime = 0
UserInputService.InputBegan:Connect(function(input, processed)
    local isKb = input.UserInputType == Enum.UserInputType.Keyboard
    local isPad = input.UserInputType == Enum.UserInputType.Gamepad1
    if not (isKb or isPad) then return end
    if keybindCaptureActive then return end
    local key = input.KeyCode.Name

    local function is(k)
        if k == nil then return false end
        local value = tostring(k)
        return value ~= "" and key:upper() == value:upper()
    end
    local function canStart(action)
        return safeModeAllowsAction(action)
    end

    if is(Config.DropKey) then
        if canStart("drop") and type(runDrop) == "function" then
            pcall(runDrop)
            saveConfig()
        end
        return
    elseif is(Config.TPDownKey) then
        if processed then return end
        if canStart("tpDown") then performTPDown(); saveConfig() end
    elseif (isKb and is(Config.InstaResetKey)) or (isPad and is(Config.InstaResetGamepadKey)) then
        if not processed then celestialInstantReset() end
        return
    elseif processed then
        return
    elseif is(Config.CarrySpeedKey) then
        local now = tick()
        if now - lastCarryKeyTime < 0.35 then
            carrySpeedEnabled = false
            laggerCarryEnabled = false
            laggerSpeedEnabled = false
            lastCarryKeyTime = 0
        else
            carrySpeedEnabled = not carrySpeedEnabled
            if carrySpeedEnabled then
                laggerSpeedEnabled = false
                laggerCarryEnabled = false
                laggerModeEnabled = false
            end
            lastCarryKeyTime = now
        end
        if mobBtnRefs then
            if mobBtnRefs.carrySpeed then pcall(mobBtnRefs.carrySpeed, carrySpeedEnabled) end
            if not carrySpeedEnabled then
                if mobBtnRefs.lagger then pcall(mobBtnRefs.lagger, laggerModeEnabled) end
                if mobBtnRefs.laggerCarry then pcall(mobBtnRefs.laggerCarry, laggerCarryEnabled) end
            else
                if mobBtnRefs.lagger then pcall(mobBtnRefs.lagger, false) end
                if mobBtnRefs.laggerCarry then pcall(mobBtnRefs.laggerCarry, false) end
            end
        end
        saveConfig()

    elseif is(Config.LaggerSpeedKey or Config.LaggerCarryKey) then
        if laggerModeEnabled then
            laggerModeEnabled = false
            laggerCarryEnabled = true
        elseif laggerCarryEnabled then
            laggerCarryEnabled = false
            laggerModeEnabled = false
        else
            laggerModeEnabled = true
            laggerCarryEnabled = false
        end
        laggerSpeedEnabled = false
        carrySpeedEnabled = false
        if mobBtnRefs then
            if mobBtnRefs.carrySpeed then pcall(mobBtnRefs.carrySpeed, false) end
            if mobBtnRefs.lagger then pcall(mobBtnRefs.lagger, laggerModeEnabled) end
            if mobBtnRefs.laggerCarry then pcall(mobBtnRefs.laggerCarry, laggerCarryEnabled) end
        end
        saveConfig()

    elseif Config.AutoPlayMode == "1 Btn" and is(Config.AutoPlayKey) then
        if canStart("autoplay") then
            if Config.AutoLeft or Config.AutoRight then
                Config.AutoLeft = false
                Config.AutoRight = false
                if stopAutoLeft then stopAutoLeft() end
                if stopAutoRight then stopAutoRight() end
                if mobBtnRefs.autoPlay then pcall(mobBtnRefs.autoPlay, false) end
            else
                local baseSide = celestialDetectAutoPlaySide and celestialDetectAutoPlaySide() or "left"
                local useLeft = baseSide ~= "left"
                if useLeft then
                    Config.AutoRight = false
                    if stopAutoRight then stopAutoRight() end
                    Config.AutoLeft = true
                    if startAutoLeft then startAutoLeft() end
                else
                    Config.AutoLeft = false
                    if stopAutoLeft then stopAutoLeft() end
                    Config.AutoRight = true
                    if startAutoRight then startAutoRight() end
                end
                if mobBtnRefs.autoPlay then pcall(mobBtnRefs.autoPlay, true) end
            end
            saveConfig()
        end
    elseif Config.AutoPlayMode == "2 Btn" and is(Config.AutoLeftKey) then
        if canStart() then
            Config.AutoLeft = not Config.AutoLeft
            if Config.AutoLeft then if Config.AutoRight then stopAutoRight() end; startAutoLeft() else stopAutoLeft() end
            saveConfig()
        end
    elseif Config.AutoPlayMode == "2 Btn" and is(Config.AutoRightKey) then
        if canStart() then
            Config.AutoRight = not Config.AutoRight
            if Config.AutoRight then if Config.AutoLeft then stopAutoLeft() end; startAutoRight() else stopAutoRight() end
            saveConfig()
        end
    elseif is(Config.BatAimbotKey) then
        if canStart() then
            Config.BatAimbot = not Config.BatAimbot
            State.autoBatToggled = Config.BatAimbot
            if Config.BatAimbot then startBatAimbot() else stopBatAimbot() end
            if mobBtnRefs and mobBtnRefs.autoBat then pcall(mobBtnRefs.autoBat, Config.BatAimbot) end
            if _G.CelestialSetBatAimbotUI then pcall(_G.CelestialSetBatAimbotUI, Config.BatAimbot) end
            if applyBatSpinRule then pcall(applyBatSpinRule, Config.BatAimbot) end
            saveConfig()
        end

    end
end)



pcall(function()
    if _G.__CelestialActionKeyConnection then
        _G.__CelestialActionKeyConnection:Disconnect()
    end
end)
_G.__CelestialActionKeyConnection = UserInputService.InputBegan:Connect(function(input, processed)
    if keybindCaptureActive then return end
    local isKeyboard = input.UserInputType == Enum.UserInputType.Keyboard
    if not isKeyboard then return end

    local keyName = input.KeyCode.Name:upper()
    local dropKey = tostring(Config.DropKey or ""):upper()
    local resetKey = tostring(Config.InstaResetKey or ""):upper()
    local tpDownKey = tostring(Config.TPDownKey or ""):upper()


    if dropKey ~= "" and keyName == dropKey then
        if safeModeAllowsAction("drop") then pcall(runDrop); saveConfig() end
        return
    end
    if resetKey ~= "" and keyName == resetKey then
        celestialInstantReset()
        return
    end
    if tpDownKey ~= "" and keyName == tpDownKey then
        if not processed and safeModeAllowsAction("tpDown") then performTPDown(); saveConfig() end
        return
    end
end)

tabNames = { "Movement", "Combat", "Misc", "Visual", "Settings" }
tabButtons = {}
currentTab = "Movement"

TAB_ACCENTS = {
    Movement = COLORS.Accent,
    Combat = COLORS.Accent,
    Misc = COLORS.Accent,
    Visual = COLORS.Accent,
    Settings = COLORS.Accent,
}

function selectTab(name)
    currentTab = name or currentTab
    _G.CelestialHubSelectedTab = currentTab
    for i, tabName in ipairs(tabNames) do
        local page = pages[tabName]
        if page then
            page.LayoutOrder = i
            page.Visible = true
            if not page:FindFirstChild("PageHeader") then
                local header = Instance.new("TextLabel")
                header.Name = "PageHeader"
                header.LayoutOrder = 0
                header.Size = UDim2.new(1, 0, 0, 26)
                header.BackgroundTransparency = 1
                header.Text = string.upper(tabName)
                header.Font = Enum.Font.GothamBlack
                header.TextSize = 16
                header.TextColor3 = Color3.fromRGB(255, 255, 255)
                header.TextXAlignment = Enum.TextXAlignment.Left
                header.Parent = page
            end
        end
    end
end

for i, name in ipairs(tabNames) do
    local active0 = (name == currentTab)
    local accent = _G.CelestialThemeAccent or TAB_ACCENTS[name] or COLORS.Stroke
    local themeSoft = _G.CelestialThemeSoft or COLORS.AccentSoft or Color3.fromRGB(80, 40, 160)

    local btn = Instance.new("TextButton")
    btn.Name = name
    btn.Text = ""
    btn.AutoButtonColor = false
    btn.Size = UDim2.new(1 / #tabNames, -4, 1, -4)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.BackgroundTransparency = active0 and 0.08 or 0.18
    btn.BorderSizePixel = 0
    btn.LayoutOrder = i
    btn.Parent = tabBar
    corner(btn, 11)

    local tabStroke = stroke(btn, active0 and 2 or 1, active0 and accent or themeSoft, active0 and 0 or 0.48)


    local glow = Instance.new("Frame")
    glow.Name = "Glow"
    glow.Size = UDim2.new(1, -8, 0, 10)
    glow.Position = UDim2.new(0, 4, 0, 2)
    glow.BackgroundColor3 = accent
    glow.BackgroundTransparency = 1
    glow.BorderSizePixel = 0
    glow.ZIndex = 1
    glow.Parent = btn
    corner(glow, 6)
    local glowGrad = Instance.new("UIGradient")
    glowGrad.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.2),
        NumberSequenceKeypoint.new(1, 1),
    })
    glowGrad.Rotation = 90
    glowGrad.Parent = glow

    local lbl = Instance.new("TextLabel")
    lbl.Name = "Label"
    lbl.Text = name
    lbl.Font = Enum.Font.GothamBold
    lbl.TextSize = 11
    lbl.TextColor3 = COLORS.White
    lbl.TextTransparency = active0 and 0 or 0.18
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, -4, 0, 16)
    lbl.Position = UDim2.new(0, 2, 0.5, -10)
    lbl.ZIndex = 3
    lbl.Parent = btn

    local underline = Instance.new("Frame")
    underline.Name = "Underline"
    underline.AnchorPoint = Vector2.new(0.5, 0)
    underline.Position = UDim2.new(0.5, 0, 1, -7)
    underline.Size = active0 and UDim2.new(0.72, 0, 0, 2) or UDim2.new(0, 0, 0, 2)
    underline.BackgroundColor3 = accent
    underline.BackgroundTransparency = active0 and 0 or 1
    underline.BorderSizePixel = 0
    underline.ZIndex = 3
    underline.Parent = btn
    corner(underline, 2)

    tabButtons[name] = { button = btn, label = lbl, underline = underline, stroke = tabStroke, glow = glow }

    btn.MouseEnter:Connect(function()
        if currentTab == name then return end
        TweenService:Create(btn, TweenInfo.new(0.12), {
            BackgroundTransparency = 0.08,
        }):Play()
        TweenService:Create(tabStroke, TweenInfo.new(0.12), {
            Transparency = 0.18,
            Color = _G.CelestialThemeAccent or COLORS.Accent,
            Thickness = 1.4,
        }):Play()
    end)
    btn.MouseLeave:Connect(function()
        if currentTab == name then return end
        TweenService:Create(btn, TweenInfo.new(0.15), {
            BackgroundTransparency = 0.12,
            BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        }):Play()
        TweenService:Create(tabStroke, TweenInfo.new(0.15), {
            Transparency = 0.48,
            Color = _G.CelestialThemeSoft or COLORS.AccentSoft,
            Thickness = 1.25,
        }):Play()
    end)

    btn.Activated:Connect(function()
        selectTab(name)
    end)
end
selectTab(currentTab)
task.defer(function()
    task.wait()
    pcall(function()
        selectTab(currentTab)
    end)
end)


function __celestialInitVisualLogic()





_dropConn = nil
DROP_ASCEND_DURATION = 0.2
DROP_ASCEND_SPEED = 150

function stopDropBrainrot()
    dropActive = false
    if dropActionRow then setRowGlow(dropActionRow, false) end
    if _dropConn then pcall(function() _dropConn:Disconnect() end); _dropConn = nil end
    local c = LP.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end
end

DROP_ASCEND_DURATION=.22
DROP_ASCEND_SPEED=160
function runDrop() if dropActive then return end;local c=LP.Character;if not c then return end;local r=c:FindFirstChild("HumanoidRootPart");if not r then return end;dropActive=true;if dropActionRow then setRowGlow(dropActionRow, true) end;if syncAutoAntiDie then pcall(syncAutoAntiDie) end;local t0=tick();if _dropConn then _dropConn:Disconnect() end;_dropConn=RunService.Heartbeat:Connect(function() local cc=LP.Character;local rr=cc and cc:FindFirstChild("HumanoidRootPart");if not rr then if _dropConn then _dropConn:Disconnect();_dropConn=nil end;dropActive=false;if dropActionRow then setRowGlow(dropActionRow, false) end;if syncAutoAntiDie then pcall(syncAutoAntiDie) end;return end;if not dropActive then if _dropConn then _dropConn:Disconnect();_dropConn=nil end;return end;if tick()-t0>=DROP_ASCEND_DURATION then if _dropConn then _dropConn:Disconnect();_dropConn=nil end;pcall(function() local rp=RaycastParams.new();rp.FilterDescendantsInstances={cc};rp.FilterType=Enum.RaycastFilterType.Exclude;local hit=workspace:Raycast(rr.Position,Vector3.new(0,-3000,0),rp);if hit then local hum=cc:FindFirstChildOfClass("Humanoid");local off=((hum and hum.HipHeight) or 2)+(rr.Size.Y/2);rr.CFrame=CFrame.new(rr.Position.X,hit.Position.Y+off,rr.Position.Z);rr.AssemblyLinearVelocity=Vector3.zero end end);dropActive=false;if dropActionRow then setRowGlow(dropActionRow, false) end;if syncAutoAntiDie then pcall(syncAutoAntiDie) end;return end;local lv=rr.AssemblyLinearVelocity;rr.AssemblyLinearVelocity=Vector3.new(lv.X,DROP_ASCEND_SPEED,lv.Z) end) end


resetting = false

MOB_POS_FILE = "CelestialCC2_MobPos.json"
mobGuiRef = nil

mobBtnFrames = {}

function loadMobPos()
    local out = {}
    pcall(function()
        if isfile and isfile(MOB_POS_FILE) then
            local data = HttpService:JSONDecode(readfile(MOB_POS_FILE))
            if type(data) == "table" then out = data end
        end
    end)
    return out
end

function saveMobPos()
    local out = loadMobPos()
    for key, fr in pairs(mobBtnFrames) do
        if fr and fr.Parent then
            local saveKey = key
            if key == "autoPlay" then
                saveKey = "autoPlay_1Btn"
            elseif key == "autoLeft" or key == "autoRight" then
                saveKey = key .. "_2Btn"
            end
            out[saveKey] = {
                sx = fr.Position.X.Scale, sy = fr.Position.Y.Scale,
                ox = fr.Position.X.Offset, oy = fr.Position.Y.Offset,
            }
        end
    end
    pcall(function()
        if writefile then writefile(MOB_POS_FILE, HttpService:JSONEncode(out)) end
    end)
end

function destroyMobileButtons()
    if mobGuiRef then pcall(function() mobGuiRef:Destroy() end); mobGuiRef = nil end
    mobBtnRefs = {}
    mobBtnFrames = {}
end

function celestialApplyHideButtons(hide)
    hide = hide == true
    Config.HideButtons = hide
    if mobGuiRef then
        pcall(function() mobGuiRef.Enabled = not hide end)
    end
    for _, fr in pairs(mobBtnFrames) do
        if fr then
            pcall(function() fr.Visible = not hide end)
        end
    end
end
_G.CelestialApplyHideButtons = celestialApplyHideButtons

function buildMobileButtons()
    if next(mobBtnFrames) ~= nil then
        pcall(saveMobPos)
    end
    destroyMobileButtons()


    local OFF_BG = Color3.fromRGB(18, 18, 20)
    local BLACK = Color3.fromRGB(0, 0, 0)
    local function mobileContrastText(color)
        local function linearChannel(v)
            if v <= 0.04045 then return v / 12.92 end
            return ((v + 0.055) / 1.055) ^ 2.4
        end
        local luminance = 0.2126 * linearChannel(color.R)
            + 0.7152 * linearChannel(color.G)
            + 0.0722 * linearChannel(color.B)
        if luminance > 0.179 then
            return Color3.fromRGB(8, 8, 8)
        end
        return Color3.fromRGB(255, 255, 255)
    end
    local function liveMobileAccent()
        return _G.CelestialThemeAccent or COLORS.Accent or Color3.fromRGB(0, 220, 255)
    end
    local function liveMobileSoft()
        return _G.CelestialThemeSoft or COLORS.AccentSoft or Color3.fromRGB(80, 40, 160)
    end

    local scale = math.clamp((tonumber(Config.MobileButtonSize) or 50) / 50, 0.2, 2.5)
    if UserInputService.TouchEnabled then
        local vp = getViewportSize and getViewportSize() or Vector2.new(1280, 720)
        if vp.Y < 520 then
            scale = scale * 0.82
        elseif vp.Y < 700 then
            scale = scale * 0.9
        end
    end
    local BTN_W = math.floor(64 * scale)
    local BTN_H = math.floor(64 * scale)
    local GAP = math.floor(10 * scale)
    local isCircle = Config.CircleButtons == true
    local cornerR = isCircle and math.floor(BTN_W / 2) or math.floor(16 * scale)

    local gui = Instance.new("ScreenGui")
    gui.Name = "CelestialMobileButtons"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 100
    gui.IgnoreGuiInset = true
    gui.Parent = playerGui
    mobGuiRef = gui

    local saved = loadMobPos()






    local defs = {
        {key="reset",        label="INSTA\nRESET",   toggle=false, col=0, row=0},
        {key="drop",         label="DROP\nBR",        toggle=false, col=1, row=0},
        {key="autoBat",      label="BAT\nAIMBOT",    toggle=true,  col=1, row=1},
        {key="bypassAimbot", label="BYPASS\nAIMBOT", toggle=true,  col=0, row=1},
        {key="tpDown",       label="TP\nDOWN",        toggle=false, col=1, row=2},
        {key="carrySpeed",   label="CARRY\nSPEED",   toggle=true,  col=2, row=2},
        {key="laggerCarry",  label="LAGGER\nCARRY",  toggle=true,  col=1, row=3},
        {key="lagger",       label="LAGGER\nMODE",   toggle=true,  col=2, row=3},
    }
    if Config.AutoPlayMode == "2 Btn" then
        table.insert(defs, {key="autoLeft", label="AUTO\nLEFT", toggle=true, col=2, row=0})
        table.insert(defs, {key="autoRight", label="AUTO\nRIGHT", toggle=true, col=2, row=1})
    else
        table.insert(defs, {key="autoPlay", label="AUTO\nPLAY", toggle=true, col=2, row=0})
    end

    local function defaultPos(def)
        local cols = 3
        local rows = 4
        local gridW = cols * (BTN_W + GAP) - GAP
        local gridH = rows * (BTN_H + GAP) - GAP
        local margin = 16
        return UDim2.new(
            1, -(gridW + margin) + (def.col or 0) * (BTN_W + GAP),
            0.5, -gridH / 2 + (def.row or 0) * (BTN_H + GAP)
        )
    end

    local function setBtnVisual(btn, on)
        local st = btn:FindFirstChildOfClass("UIStroke")
        local grad = btn:FindFirstChildOfClass("UIGradient")
        local topLine = btn:FindFirstChild("OrangeAccent")
        local innerStroke = btn:FindFirstChild("CelestialHubInnerAccent")
        local accent = liveMobileAccent()
        local soft = liveMobileSoft()
        local themeHighlight = accent:Lerp(Color3.fromRGB(255, 255, 255), 0.24)
        if on then
            btn:SetAttribute("CelestialHubActive", true)
            btn.BackgroundColor3 = accent
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextTransparency = 0
            btn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            btn.TextStrokeTransparency = 1
            if topLine then topLine.Visible = false end
            if innerStroke then innerStroke.Enabled = false end
            local gloss = btn:FindFirstChild("CelestialHubGloss")
            if gloss then gloss.Visible = false end
            if grad then
                grad.Enabled = false
            end
            if st then
                st.Color = BLACK -- black outline when ON
                st.Thickness = 3.5
                st.Transparency = 0
                st:SetAttribute("CelestialHubThemeAccentStroke", true)
            end
        else
            btn:SetAttribute("CelestialHubActive", false)
            btn.BackgroundColor3 = OFF_BG
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextTransparency = 0
            btn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            btn.TextStrokeTransparency = 1
            if topLine then topLine.Visible = false end
            if innerStroke then innerStroke.Enabled = false end
            local gloss = btn:FindFirstChild("CelestialHubGloss")
            if gloss then gloss.Visible = false end
            if grad then
                grad.Enabled = false
            end
            if st then
                st.Color = accent
                st.Thickness = 1.8
                st.Transparency = 0.05
                st:SetAttribute("CelestialHubThemeAccentStroke", true)
            end
        end
    end

    _G.CelestialHubRefreshMobileButtonTheme = function()
        local accent = liveMobileAccent()
        local soft = liveMobileSoft()
        local themeHighlight = accent:Lerp(Color3.fromRGB(255, 255, 255), 0.24)
        for _, btn in ipairs(gui:GetChildren()) do
            if btn:IsA("TextButton") then
                local active = btn:GetAttribute("CelestialHubActive") == true
                local offColor = OFF_BG
                local st = btn:FindFirstChildOfClass("UIStroke")
                local grad = btn:FindFirstChildOfClass("UIGradient")
                local topLine = btn:FindFirstChild("OrangeAccent")
                local innerStroke = btn:FindFirstChild("CelestialHubInnerAccent")
                btn.BackgroundColor3 = active and accent or offColor
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
                btn.TextTransparency = 0
                btn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                btn.TextStrokeTransparency = 1
                if grad then
                    grad.Enabled = false
                end
                if st then
                    st.Color = active and BLACK or accent
                    st.Thickness = active and 3.5 or 1.8
                    st.Transparency = active and 0 or 0.05
                    st:SetAttribute("CelestialHubThemeAccentStroke", true)
                end
                if topLine then topLine.Visible = false end
                if innerStroke then innerStroke.Enabled = false end
                local gloss = btn:FindFirstChild("CelestialHubGloss")
                if gloss then gloss.Visible = false end
            end
        end
    end

    local function makeDrag(btn)
        local dragging, dragStart, startPos
        btn.InputBegan:Connect(function(input)
            if Config.LockUI or _G.CelestialUILocked then
                dragging = false
                return
            end
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true
                dragStart = input.Position
                startPos = btn.Position
            end
        end)
        UserInputService.InputChanged:Connect(function(input)
            if Config.LockUI or _G.CelestialUILocked then
                dragging = false
                return
            end
            if not dragging or not dragStart or not startPos then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                local d = input.Position - dragStart
                btn.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + d.X,
                    startPos.Y.Scale, startPos.Y.Offset + d.Y
                )
            end
        end)
        UserInputService.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    dragging = false
                    if not Config.LockUI and not _G.CelestialUILocked then saveMobPos() end
                end
            end
        end)
    end

    for _, def in ipairs(defs) do
        local btn = Instance.new("TextButton")
        btn.Name = def.key
        btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        local pos = defaultPos(def)
        local savedPos
        if def.key == "autoPlay" then
            savedPos = saved.autoPlay_1Btn or saved.autoPlay
        elseif def.key == "autoLeft" then
            savedPos = saved.autoLeft_2Btn or saved.autoLeft
        elseif def.key == "autoRight" then
            savedPos = saved.autoRight_2Btn or saved.autoRight
        else
            savedPos = saved[def.key]
        end
        if type(savedPos) == "table" then
            local sx, sy = tonumber(savedPos.sx), tonumber(savedPos.sy)
            local ox, oy = tonumber(savedPos.ox), tonumber(savedPos.oy)
            if sx and sy and ox and oy then
                pos = UDim2.new(sx, ox, sy, oy)
            end
        end
        btn.Position = pos
        btn.BackgroundColor3 = OFF_BG
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.TextTransparency = 0
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = math.max(10, math.floor(12 * scale))
        btn.TextStrokeTransparency = 1
        btn.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        btn.TextScaled = false
        btn.TextWrapped = true
        btn.Text = def.label
        btn.TextXAlignment = Enum.TextXAlignment.Center
        btn.TextYAlignment = Enum.TextYAlignment.Center
        btn.AutoButtonColor = false
        btn.BorderSizePixel = 0
        btn.Parent = gui
        corner(btn, cornerR)
        local mobStroke = stroke(btn, 2, Color3.fromRGB(0, 220, 255), 0.15)
        mobStroke.Name = "CelestialMobileStroke"

        -- S X C watermark in middle
        local sxc = Instance.new("TextLabel")
        sxc.Name = "SXCMark"
        sxc.Size = UDim2.new(1, 0, 0, math.max(10, math.floor(11 * scale)))
        sxc.Position = UDim2.new(0, 0, 0.5, -math.floor(5 * scale))
        sxc.BackgroundTransparency = 1
        sxc.Text = "S X C"
        sxc.Font = Enum.Font.GothamBold
        sxc.TextSize = math.max(8, math.floor(9 * scale))
        sxc.TextColor3 = Color3.fromRGB(0, 220, 255)
        sxc.TextTransparency = 0.35
        sxc.ZIndex = 5
        sxc.Parent = btn

        local gradient = Instance.new("UIGradient")
        gradient.Rotation = 90
        gradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(1, OFF_BG),
        })
        gradient.Parent = btn
        gradient.Enabled = false

        local topAccent = Instance.new("Frame")
        topAccent.Name = "OrangeAccent"
        topAccent.Size = UDim2.new(0.52, 0, 0, math.max(3, math.floor(4 * scale)))
        topAccent.Position = UDim2.new(0, math.floor(9 * scale), 0, math.floor(7 * scale))
        topAccent.BackgroundColor3 = liveMobileAccent()
        topAccent.BorderSizePixel = 0
        topAccent.ZIndex = btn.ZIndex + 1
        topAccent.Parent = btn
        topAccent.Visible = false
        topAccent.BackgroundTransparency = 1
        corner(topAccent, math.max(2, math.floor(2 * scale)))

        local shine = Instance.new("Frame")
        shine.Name = "CelestialHubGloss"
        shine.Size = UDim2.new(0.72, 0, 0, math.max(2, math.floor(2 * scale)))
        shine.Position = UDim2.new(0.14, 0, 0, math.floor(4 * scale))
        shine.BackgroundColor3 = Color3.fromRGB(255, 220, 150)
        shine.BackgroundTransparency = 0.12
        shine.BorderSizePixel = 0
        shine.ZIndex = btn.ZIndex + 1
        shine.Parent = btn
        shine.Visible = false
        corner(shine, math.max(2, math.floor(2 * scale)))

        local innerStroke = Instance.new("UIStroke")
        innerStroke.Name = "CelestialHubInnerAccent"
        innerStroke.Color = liveMobileAccent():Lerp(Color3.fromRGB(255, 255, 255), 0.24)
        innerStroke.Thickness = 1
        innerStroke.Transparency = 0.12
        innerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        innerStroke.Parent = btn
        innerStroke.Enabled = false

        local st = Instance.new("UIStroke")
        st.Color = liveMobileAccent()
        st:SetAttribute("CelestialHubThemeAccentStroke", true)
        st.Thickness = 1.6
        st.Transparency = 0.2
        st.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
        st.Parent = btn
        makeDrag(btn)
        mobBtnFrames[def.key] = btn

        local active = false
        local function setVisual(on)
            active = on == true
            setBtnVisual(btn, active)
        end
        mobBtnRefs[def.key] = setVisual

        btn.Activated:Connect(function()
            if def.key == "drop" then
                if not safeModeAllowsAction("drop") then setVisual(false); return end
                setVisual(true)
                runDrop()
                task.spawn(function()
                    while dropActive do task.wait() end
                    setVisual(false)
                end)
            elseif def.key == "reset" then
                setVisual(true)
                celestialInstantReset()
                task.delay(0.6, function() setVisual(false) end)
            elseif def.key == "tpDown" then
                if not safeModeAllowsAction("tpDown") then setVisual(false); return end
                setVisual(true)
                if performTPDown then performTPDown(Config.TPDownDistance or 10) end
                task.delay(0.25, function() setVisual(false) end)
            elseif def.key == "autoPlay" then
                if Config.AutoPlayMode ~= "1 Btn" then setVisual(false); return end
                if Config.SafeMode and safeModeIsLocked() then setVisual(false); return end
                if Config.AutoLeft or Config.AutoRight then
                    Config.AutoLeft = false
                    Config.AutoRight = false
                    if stopAutoLeft then stopAutoLeft() end
                    if stopAutoRight then stopAutoRight() end
                    setVisual(false)
                else
                    local baseSide = celestialDetectAutoPlaySide and celestialDetectAutoPlaySide() or "left"
                    local useLeft = baseSide ~= "left"
                    if useLeft then
                        Config.AutoRight = false
                        if stopAutoRight then stopAutoRight() end
                        Config.AutoLeft = true
                        if startAutoLeft then startAutoLeft() end
                    else
                        Config.AutoLeft = false
                        if stopAutoLeft then stopAutoLeft() end
                        Config.AutoRight = true
                        if startAutoRight then startAutoRight() end
                    end
                    setVisual(true)
                end
                if mobBtnRefs.autoPlay then pcall(mobBtnRefs.autoPlay, Config.AutoLeft or Config.AutoRight) end
                saveConfig()
            elseif def.key == "autoLeft" then
                if Config.AutoPlayMode ~= "2 Btn" then setVisual(false); return end
                if Config.SafeMode and safeModeIsLocked() then
                    setVisual(false)
                    return
                end
                if Config.AutoLeft then
                    Config.AutoLeft = false
                    if stopAutoLeft then stopAutoLeft() end
                    setVisual(false)
                else
                    Config.AutoLeft = true
                    if startAutoLeft then startAutoLeft() end
                    setVisual(true)
                end
                saveConfig()
            elseif def.key == "autoRight" then
                if Config.AutoPlayMode ~= "2 Btn" then setVisual(false); return end
                if Config.SafeMode and safeModeIsLocked() then
                    setVisual(false)
                    return
                end
                if Config.AutoRight then
                    Config.AutoRight = false
                    if stopAutoRight then stopAutoRight() end
                    setVisual(false)
                else
                    Config.AutoRight = true
                    if startAutoRight then startAutoRight() end
                    setVisual(true)
                end
                saveConfig()
            elseif def.key == "bypassAimbot" then
                if Config.SafeMode and safeModeIsLocked() then setVisual(false); return end
                local startFn = startBypassAimbot or _G.CelestialStartBypassAimbot
                local stopFn = stopBypassAimbot or _G.CelestialStopBypassAimbot
                if State.bypassAimbotToggled then
                    if stopFn then pcall(stopFn) end
                    State.bypassAimbotToggled = false
                    Config.BypassAimbot = false
                    setVisual(false)
                else
                    if State.autoBatToggled then
                        State.autoBatToggled = false
                        Config.BatAimbot = false
                        if stopBatAimbot then pcall(stopBatAimbot) end
                        if mobBtnRefs.autoBat then pcall(mobBtnRefs.autoBat, false) end
                        if _G.CelestialSetBatAimbotUI then pcall(_G.CelestialSetBatAimbotUI, false) end
                        if applyBatSpinRule then pcall(applyBatSpinRule, false) end
                    end
                    if startFn then
                        pcall(startFn)
                    end
                    -- visual follows actual state after start (start may abort on safe mode)
                    local on = State.bypassAimbotToggled == true
                    setVisual(on)
                    if not on then
                        Config.BypassAimbot = false
                    end
                end
                if syncAutoAntiDie then pcall(syncAutoAntiDie) end
                saveConfig()
            elseif def.key == "autoBat" then
                if Config.SafeMode and safeModeIsLocked() then setVisual(false); return end
                if State.autoBatToggled then
                    State.autoBatToggled = false
                    Config.BatAimbot = false
                    if stopBatAimbot then stopBatAimbot() end
                    setVisual(false)
                    if _G.CelestialSetBatAimbotUI then pcall(_G.CelestialSetBatAimbotUI, false) end
                    if applyBatSpinRule then pcall(applyBatSpinRule, false) end
                    if syncAutoAntiDie then pcall(syncAutoAntiDie) end
                else
                    if State.bypassAimbotToggled then
                        local stopFn = stopBypassAimbot or _G.CelestialStopBypassAimbot
                        if stopFn then pcall(stopFn) end
                        if mobBtnRefs.bypassAimbot then pcall(mobBtnRefs.bypassAimbot, false) end
                    end
                    State.autoBatToggled = true
                    Config.BatAimbot = true
                    if startBatAimbot then startBatAimbot() end
                    setVisual(true)
                    if _G.CelestialSetBatAimbotUI then pcall(_G.CelestialSetBatAimbotUI, true) end
                    if applyBatSpinRule then pcall(applyBatSpinRule, true) end
                    if syncAutoAntiDie then pcall(syncAutoAntiDie) end
                end
                saveConfig()
            elseif def.key == "carrySpeed" then
                if not safeModeAllowsAction("carrySpeed") then setVisual(false); return end
                carrySpeedEnabled = not carrySpeedEnabled
                if carrySpeedEnabled then
                    laggerModeEnabled = false
                    laggerCarryEnabled = false
                    if mobBtnRefs.lagger then mobBtnRefs.lagger(false) end
                    if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(false) end
                else

                    carrySpeedEnabled = false
                end
                setVisual(carrySpeedEnabled == true)
                saveConfig()
            elseif def.key == "lagger" then
                if not safeModeAllowsAction("lagger") then setVisual(false); return end
                laggerModeEnabled = not laggerModeEnabled
                if laggerModeEnabled then
                    carrySpeedEnabled = false
                    laggerCarryEnabled = false
                    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(false) end
                    if mobBtnRefs.laggerCarry then mobBtnRefs.laggerCarry(false) end
                end
                setVisual(laggerModeEnabled)
                saveConfig()
            elseif def.key == "laggerCarry" then
                if not safeModeAllowsAction("laggerCarry") then setVisual(false); return end
                laggerCarryEnabled = not laggerCarryEnabled
                if laggerCarryEnabled then
                    carrySpeedEnabled = false
                    laggerModeEnabled = false
                    if mobBtnRefs.carrySpeed then mobBtnRefs.carrySpeed(false) end
                    if mobBtnRefs.lagger then mobBtnRefs.lagger(false) end
                end
                setVisual(laggerCarryEnabled)
                saveConfig()
            end
        end)
    end


    if (Config.AutoLeft or Config.AutoRight) and mobBtnRefs.autoPlay then mobBtnRefs.autoPlay(true) end
    if Config.AutoPlayMode == "2 Btn" and Config.AutoLeft and mobBtnRefs.autoLeft then mobBtnRefs.autoLeft(true) end
    if Config.AutoPlayMode == "2 Btn" and Config.AutoRight and mobBtnRefs.autoRight then mobBtnRefs.autoRight(true) end
    if Config.BatAimbot and mobBtnRefs.autoBat then mobBtnRefs.autoBat(true) end
    if (Config.BypassAimbot or State.bypassAimbotToggled) and mobBtnRefs.bypassAimbot then mobBtnRefs.bypassAimbot(true) end

    pcall(_G.CelestialHubRefreshMobileButtonTheme)

    _G.__CelestialRefreshSafeModeMobileVisuals = function()
        local locked = Config.SafeMode and safeModeIsLocked()
        if not locked then return end
        for _, key in ipairs({"autoLeft", "autoRight", "autoBat", "bypassAimbot"}) do
            if mobBtnRefs[key] then pcall(mobBtnRefs[key], false) end
        end
    end

    pcall(_G.__CelestialRefreshSafeModeMobileVisuals)
    if celestialApplyHideButtons then pcall(celestialApplyHideButtons, Config.HideButtons == true) end
end

_G.CelestialApplyMobileButtonSize = function()
    buildMobileButtons()
end
_G.CelestialApplyMobileButtonShape = function()
    buildMobileButtons()
end
_G.CelestialResetMobileButtons = function()
    destroyMobileButtons()
    pcall(function()
        if writefile then writefile(MOB_POS_FILE, "{}") end
    end)
    buildMobileButtons()
end

mobileBuildOK, mobileBuildError = pcall(buildMobileButtons)
if not mobileBuildOK then
    warn("[Synapse X Celestial Hub] Mobile button creation failed: " .. tostring(mobileBuildError))
end






playerEspEnabled = false
playerTracersEnabled = false
_espConn = nil
_espObjects = {}
TRACER_COLOR = _G.CelestialThemeAccent or Color3.fromRGB(0, 220, 255)
TRACER_THICKNESS = 1
_tracerGui = nil

function ensureTracerGui()
    if _tracerGui and _tracerGui.Parent then return _tracerGui end
    local sg = Instance.new("ScreenGui")
    sg.Name = "CelestialTracers"
    sg.ResetOnSpawn = false
    sg.IgnoreGuiInset = true
    sg.DisplayOrder = 50
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function()
        if gethui then
            sg.Parent = gethui()
        else
            sg.Parent = game:GetService("CoreGui")
        end
    end)
    if not sg.Parent then
        sg.Parent = LP:WaitForChild("PlayerGui")
    end
    _tracerGui = sg
    return sg
end

function destroyTracerLine(line)
    if not line then return end
    pcall(function()
        if typeof(line) == "Instance" then
            line:Destroy()
        elseif line.Remove then
            line.Visible = false
            line:Remove()
        end
    end)
end

function makeGuiTracerLine()
    local parent = ensureTracerGui()
    local fr = Instance.new("Frame")
    fr.Name = "TracerLine"
    fr.AnchorPoint = Vector2.new(0.5, 0.5)
    fr.BorderSizePixel = 0
    fr.BackgroundColor3 = TRACER_COLOR
    fr.BackgroundTransparency = 0
    fr.Size = UDim2.fromOffset(0, TRACER_THICKNESS)
    fr.Visible = false
    fr.ZIndex = 10
    fr.Parent = parent
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(1, 0)
    c.Parent = fr
    return fr
end

function updateGuiTracerLine(fr, from, to)
    local dx = to.X - from.X
    local dy = to.Y - from.Y
    local dist = math.sqrt(dx * dx + dy * dy)
    if dist < 1 then
        fr.Visible = false
        return
    end
    local midX = (from.X + to.X) * 0.5
    local midY = (from.Y + to.Y) * 0.5
    fr.Size = UDim2.fromOffset(dist, TRACER_THICKNESS)
    fr.Position = UDim2.fromOffset(midX, midY)
    fr.Rotation = math.deg(math.atan2(dy, dx))
    fr.BackgroundColor3 = TRACER_COLOR
    fr.Visible = true
end

function clearEspFor(plr)
    local o = _espObjects[plr]
    if not o then return end
    if o.highlight then pcall(function() o.highlight:Destroy() end) end
    if o.billboard then pcall(function() o.billboard:Destroy() end) end
    if o.line then destroyTracerLine(o.line) end
    _espObjects[plr] = nil
end

function clearAllEsp()
    for plr in pairs(_espObjects) do clearEspFor(plr) end
    _espObjects = {}
    if _tracerGui then
        pcall(function() _tracerGui:Destroy() end)
        _tracerGui = nil
    end
end

function updatePlayerEsp(plr)
    if not plr or plr == LP then return end
    local char = plr.Character
    local myChar = LP.Character
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local head = char and (char:FindFirstChild("Head") or hrp)
    local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
    local cam = workspace.CurrentCamera
    local o = _espObjects[plr]
    if not o then o = {}; _espObjects[plr] = o end

    if not char or not hrp or not cam then
        if o.highlight then o.highlight.Enabled = false end
        if o.billboard then o.billboard.Enabled = false end
        if o.line then
            if typeof(o.line) == "Instance" then o.line.Visible = false
            else pcall(function() o.line.Visible = false end) end
        end
        return
    end

    local accent = _G.CelestialThemeAccent or TRACER_COLOR or Color3.fromRGB(0, 220, 255)
    local pg = LP:FindFirstChild("PlayerGui")

    if playerEspEnabled then
        if not o.highlight or not o.highlight.Parent then
            pcall(function() if o.highlight then o.highlight:Destroy() end end)
            local hl = Instance.new("Highlight")
            hl.Name = "CelestialHL"
            hl.FillColor = accent
            hl.OutlineColor = accent
            hl.FillTransparency = 0.45
            hl.OutlineTransparency = 0
            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.Adornee = char
            hl.Parent = char
            o.highlight = hl
        else
            o.highlight.Enabled = true
            o.highlight.Adornee = char
            o.highlight.FillColor = accent
            o.highlight.OutlineColor = accent
        end

        -- Bubble-style: name + horizontal speed (persistent billboard on PlayerGui)
        if not o.billboard or not o.billboard.Parent then
            pcall(function() if o.billboard then o.billboard:Destroy() end end)
            local bb = Instance.new("BillboardGui")
            bb.Name = "CelestialHubPlayerESP_" .. tostring(plr.UserId)
            bb.Size = UDim2.fromOffset(160, 44)
            bb.StudsOffset = Vector3.new(0, 2.4, 0)
            bb.AlwaysOnTop = true
            bb.MaxDistance = math.huge
            bb.Adornee = head
            bb.ResetOnSpawn = false
            if pg then bb.Parent = pg
            else
                pcall(function()
                    if gethui then bb.Parent = gethui() else bb.Parent = game:GetService("CoreGui") end
                end)
                if not bb.Parent then bb.Parent = head end
            end
            local nameLbl = Instance.new("TextLabel")
            nameLbl.Name = "NameLabel"
            nameLbl.Size = UDim2.new(1, 0, 0, 20)
            nameLbl.BackgroundTransparency = 1
            nameLbl.Font = Enum.Font.GothamBlack
            nameLbl.TextSize = 14
            nameLbl.TextColor3 = accent
            nameLbl.TextStrokeTransparency = 0.15
            nameLbl.TextStrokeColor3 = Color3.new(0, 0, 0)
            nameLbl.Text = plr.DisplayName or plr.Name or ""
            nameLbl.Parent = bb
            local speedLbl = Instance.new("TextLabel")
            speedLbl.Name = "SpeedLabel"
            speedLbl.Size = UDim2.new(1, 0, 0, 18)
            speedLbl.Position = UDim2.new(0, 0, 0, 20)
            speedLbl.BackgroundTransparency = 1
            speedLbl.Font = Enum.Font.GothamBold
            speedLbl.TextSize = 13
            speedLbl.TextColor3 = accent
            speedLbl.TextStrokeTransparency = 0.15
            speedLbl.TextStrokeColor3 = Color3.new(0, 0, 0)
            speedLbl.Text = "0"
            speedLbl.Parent = bb
            o.billboard = bb
            o.nameLabel = nameLbl
            o.speedLabel = speedLbl
        else
            o.billboard.Enabled = true
            o.billboard.Adornee = head
            if o.nameLabel then
                o.nameLabel.Text = plr.DisplayName or plr.Name or ""
                o.nameLabel.TextColor3 = accent
            end
        end
        if o.speedLabel then
            local vel = hrp.AssemblyLinearVelocity
            local spd = Vector3.new(vel.X, 0, vel.Z).Magnitude
            o.speedLabel.Text = tostring(spd < 0.5 and 0 or math.floor(spd + 0.5))
            o.speedLabel.TextColor3 = accent
        end
    else
        if o.highlight then pcall(function() o.highlight:Destroy() end); o.highlight = nil end
        if o.billboard then
            pcall(function() o.billboard:Destroy() end)
            o.billboard = nil; o.nameLabel = nil; o.speedLabel = nil
        end
    end

    if not myHrp then
        if o.line then
            if typeof(o.line) == "Instance" then o.line.Visible = false
            else pcall(function() o.line.Visible = false end) end
        end
        return
    end

    if not playerTracersEnabled then
        if o.line then destroyTracerLine(o.line); o.line = nil end
        return
    end

    if not o.line or (typeof(o.line) == "Instance" and not o.line.Parent) then
        if o.line then destroyTracerLine(o.line) end
        o.line = makeGuiTracerLine()
    end
    if not o.line then return end

    local p1 = cam:WorldToViewportPoint(myHrp.Position)
    local p2 = cam:WorldToViewportPoint(hrp.Position)
    if p1.Z > 0 and p2.Z > 0 then
        local vsize = cam.ViewportSize
        updateGuiTracerLine(o.line,
            Vector2.new(math.clamp(p1.X, -50, vsize.X + 50), math.clamp(p1.Y, -50, vsize.Y + 50)),
            Vector2.new(math.clamp(p2.X, -50, vsize.X + 50), math.clamp(p2.Y, -50, vsize.Y + 50)))
    else
        if typeof(o.line) == "Instance" then o.line.Visible = false
        else pcall(function() o.line.Visible = false end) end
    end
end

function refreshAllEsp()
    if not playerEspEnabled and not playerTracersEnabled then
        clearAllEsp()
        return
    end
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then pcall(updatePlayerEsp, plr) end
    end
    for plr in pairs(_espObjects) do
        if not plr.Parent then clearEspFor(plr) end
    end
end

startPlayerEsp = function()
    playerEspEnabled = true
    Config.PlayerESP = true
    refreshAllEsp()
    if not _espConn then
        _espConn = RunService.RenderStepped:Connect(function()
            if playerEspEnabled or playerTracersEnabled then refreshAllEsp() end
        end)
    end
end

stopPlayerEsp = function()
    playerEspEnabled = false
    Config.PlayerESP = false
    if not playerTracersEnabled then
        if _espConn then _espConn:Disconnect(); _espConn = nil end
        clearAllEsp()
    else
        refreshAllEsp()
    end
end

startPlayerTracers = function()
    playerTracersEnabled = true
    Config.PlayerTracers = true
    refreshAllEsp()
    if not _espConn then
        _espConn = RunService.RenderStepped:Connect(function()
            if playerEspEnabled or playerTracersEnabled then refreshAllEsp() end
        end)
    end
end

stopPlayerTracers = function()
    playerTracersEnabled = false
    Config.PlayerTracers = false
    if not playerEspEnabled then
        if _espConn then _espConn:Disconnect(); _espConn = nil end
        clearAllEsp()
    else
        refreshAllEsp()
    end
end

Players.PlayerRemoving:Connect(function(plr) clearEspFor(plr) end)

LP.CharacterAdded:Connect(function()
    task.defer(function()
        task.wait(0.35)
        if Config.PlayerESP then
            playerEspEnabled = true
            if startPlayerEsp then pcall(startPlayerEsp) end
        end
        if Config.PlayerESP or Config.PlayerTracers then
            if Config.PlayerESP then Config.PlayerTracers = true end
            playerTracersEnabled = Config.PlayerTracers == true
            if playerTracersEnabled and startPlayerTracers then pcall(startPlayerTracers) end
        end
        if refreshAllEsp then pcall(refreshAllEsp) end
    end)
end)



ragdollCountdownConn, ragdollCountdownCharConn = nil, nil
ragdollCountdownEndTime = 0
RAGDOLL_COUNTDOWN_SECONDS = 2.6
ragdollCountdownGui, ragdollCountdownLabel = nil, nil

_G.CelestialHubRefreshVisualAccents = function()
    local accent = _G.CelestialThemeAccent or COLORS.Accent or Color3.fromRGB(0, 220, 255)
    TRACER_COLOR = accent
    for _, objects in pairs(_espObjects) do
        if objects.highlight then
            pcall(function()
                objects.highlight.FillColor = accent
                objects.highlight.OutlineColor = accent
            end)
        end
        if objects.line then
            pcall(function() objects.line.BackgroundColor3 = accent end)
            pcall(function() objects.line.Color = accent end)
        end
    end
    if ragdollCountdownLabel then
        pcall(function() ragdollCountdownLabel.TextColor3 = accent end)
    end
end


function getRagdollCountdownAnchor(char)
    if not char then return nil end
    local preferred = {"HumanoidRootPart", "UpperTorso", "Torso", "LowerTorso", "Head", "RightUpperArm", "LeftUpperArm", "Right Arm", "Left Arm", "RightUpperLeg", "LeftUpperLeg", "Right Leg", "Left Leg"}
    for _, name in ipairs(preferred) do
        local part = char:FindFirstChild(name)
        if part and part:IsA("BasePart") then return part end
    end
    for _, item in ipairs(char:GetDescendants()) do
        if item:IsA("BasePart") and item.Name ~= "Handle" then return item end
    end
    return nil
end

function ensureRagdollCdGui()
    if ragdollCountdownLabel and ragdollCountdownLabel.Parent then
        local anchor = getRagdollCountdownAnchor(LP.Character)
        if ragdollCountdownGui and anchor then ragdollCountdownGui.Adornee = anchor end
        return
    end
    local bb = Instance.new("BillboardGui")
    bb.Name = "CelestialRagdollCD"
    bb.Size = UDim2.new(0, 220, 0, 30)
    bb.StudsOffset = Vector3.new(0, 5.0, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 200
    bb.Adornee = getRagdollCountdownAnchor(LP.Character)
    pcall(function()
        if gethui then bb.Parent = gethui() else bb.Parent = game:GetService("CoreGui") end
    end)
    if not bb.Parent then bb.Parent = LP:WaitForChild("PlayerGui") end
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = ""

    lbl.Visible = false
    lbl.TextColor3 = _G.CelestialThemeAccent or COLORS.Accent or Color3.fromRGB(0, 220, 255)
    lbl.TextStrokeTransparency = 0.1
    lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 18
    lbl.Parent = bb
    ragdollCountdownGui = bb
    ragdollCountdownLabel = lbl
end

stopRagdollCountdown = function()
    if ragdollCountdownConn then ragdollCountdownConn:Disconnect(); ragdollCountdownConn = nil end
    if ragdollCountdownCharConn then ragdollCountdownCharConn:Disconnect(); ragdollCountdownCharConn = nil end
    if ragdollCountdownLabel then
        ragdollCountdownLabel.Visible = false
        ragdollCountdownLabel.Text = ""
    end
end

hookRagdollCountdown = function(char)
    stopRagdollCountdown()
    if not Config.RagdollCountdown then return end
    ensureRagdollCdGui()
    char = char or LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 4)
    if not hum then return end
    local countdownWasRag = false
    local function beginCountdown()
        countdownWasRag = true
        ragdollCountdownEndTime = tick() + RAGDOLL_COUNTDOWN_SECONDS
        if ragdollCountdownLabel then

            ragdollCountdownLabel.Visible = false
            ragdollCountdownLabel.Text = ""
        end
    end
    local function isRag()
        local st = hum:GetState()
        return hum.PlatformStand
            or st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown
    end
    ragdollCountdownCharConn = hum.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Physics
            or newState == Enum.HumanoidStateType.Ragdoll
            or newState == Enum.HumanoidStateType.FallingDown then
            beginCountdown()
        end
    end)
    ragdollCountdownConn = RunService.RenderStepped:Connect(function()
        if not Config.RagdollCountdown then stopRagdollCountdown(); return end
        local anchor = getRagdollCountdownAnchor(LP.Character)
        if ragdollCountdownGui and anchor and ragdollCountdownGui.Adornee ~= anchor then
            ragdollCountdownGui.Adornee = anchor
        end
        if not ragdollCountdownLabel then return end
        local ragNow = isRag()
        if ragNow and not countdownWasRag then beginCountdown() end
        if not ragNow then countdownWasRag = false end
        local left = math.max(0, ragdollCountdownEndTime - tick())


        ragdollCountdownLabel.Visible = false
        ragdollCountdownLabel.Text = ""
    end)
end

LP.CharacterAdded:Connect(function(char)
    if Config.RagdollCountdown then
        task.wait(0.4)
        hookRagdollCountdown(char)
    end
end)


SKY_TAG = "_CelestialSky"
SKY_PRESETS = {
    ["Off"] = { kind = "off" },
    ["Night"] = { clock = 22, brightness = 2, ambient = {110,100,130}, outAmb = {120,110,140}, sky = {stars=4000,moon=18,sun=0,moonTex=true}, atm = {dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2} },
    ["Aurora"] = { clock = 14, brightness = 3, ambient = {150,120,150}, outAmb = {160,130,150}, atm = {dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3}, clouds = {cover=0.7,dens=0.7,color={255,240,250}} },
    ["Sunset"] = { clock = 17.2, brightness = 2.5, ambient = {170,120,100}, outAmb = {180,130,110}, sky = {stars=0,sun=25,moon=0}, atm = {dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5}, clouds = {cover=0.55,dens=0.55,color={255,200,140}} },
    ["Galaxy"] = { clock = 0, brightness = 1.5, ambient = {70,60,100}, outAmb = {80,70,110}, sky = {stars=10000,moon=30,sun=0}, atm = {dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5} },
    ["Cyber"] = { clock = 21, brightness = 2.2, ambient = {90,130,170}, outAmb = {100,140,180}, sky = {stars=2000,moon=12}, atm = {dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2}, clouds = {cover=0.4,dens=0.6,color={100,200,255}} },
    ["Sakura"] = { clock = 11, brightness = 3.5, ambient = {170,150,160}, outAmb = {180,160,170}, sky = {sun=8}, atm = {dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5}, clouds = {cover=0.6,dens=0.4,color={255,250,252}} },
    ["Pink Night"] = { clock = 23, brightness = 2.2, ambient = {120,60,110}, outAmb = {140,70,120}, sky = {stars=5000,moon=22,sun=0,moonTex=true}, atm = {dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4}, clouds = {cover=0.3,dens=0.5,color={180,90,150}} },
    ["Blood Moon"] = { clock = 22.5, brightness = 1.6, ambient = {130,40,40}, outAmb = {150,50,50}, sky = {stars=1500,moon=28,sun=0,moonTex=true}, atm = {dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2}, clouds = {cover=0.5,dens=0.7,color={120,30,30}} },
    ["Emerald Dawn"] = { clock = 6.5, brightness = 2.8, ambient = {130,170,140}, outAmb = {140,180,150}, sky = {sun=18,moon=0,stars=0}, atm = {dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2}, clouds = {cover=0.5,dens=0.5,color={200,255,220}} },
    ["Volcanic"] = { clock = 19, brightness = 2, ambient = {180,80,40}, outAmb = {200,90,50}, sky = {stars=200,sun=12,moon=0}, atm = {dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5}, clouds = {cover=0.8,dens=0.9,color={120,40,20}} },
    ["Arctic"] = { clock = 9, brightness = 3.2, ambient = {200,220,235}, outAmb = {210,230,245}, sky = {sun=10,stars=0,moon=0}, atm = {dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8}, clouds = {cover=0.7,dens=0.6,color={250,253,255}} },
    ["Midnight Ocean"] = { clock = 1.5, brightness = 1.7, ambient = {60,90,130}, outAmb = {70,100,140}, sky = {stars=6000,moon=24,sun=0,moonTex=true}, atm = {dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5} },
    ["Vaporwave"] = { clock = 19.5, brightness = 2.4, ambient = {180,120,200}, outAmb = {190,130,210}, sky = {stars=1000,moon=14}, atm = {dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4}, clouds = {cover=0.55,dens=0.55,color={200,150,255}} },
    ["Toxic"] = { clock = 13, brightness = 2.5, ambient = {140,180,80}, outAmb = {150,190,90}, atm = {dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6}, clouds = {cover=0.65,dens=0.7,color={180,255,120}} },
    ["Solar Eclipse"] = { clock = 12, brightness = 1.2, ambient = {70,60,80}, outAmb = {80,70,90}, sky = {stars=3500,sun=22,moon=0}, atm = {dens=0.4,color={255,180,90},decay={50,40,60},glare=2.0,haze=1.5} },
    ["Hellscape"] = { clock = 18, brightness = 2.2, ambient = {200,100,80}, outAmb = {220,110,90}, sky = {stars=100,sun=30,moon=0}, atm = {dens=0.6,color={255,90,60},decay={140,50,40},glare=2.2,haze=2.4}, clouds = {cover=0.8,dens=0.8,color={90,50,40}} },
    ["Heaven"] = { clock = 12, brightness = 4, ambient = {240,235,210}, outAmb = {250,245,220}, sky = {sun=16,moon=0,stars=0}, atm = {dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5}, clouds = {cover=0.85,dens=0.5,color={255,255,255}} },
    ["Storm"] = { clock = 15, brightness = 1.4, ambient = {90,90,110}, outAmb = {100,100,120}, sky = {stars=0,sun=6,moon=0}, atm = {dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3}, clouds = {cover=0.95,dens=0.95,color={60,65,80}} },
    ["Sunrise"] = { clock = 6.2, brightness = 2.8, ambient = {220,180,130}, outAmb = {230,190,140}, sky = {sun=22,stars=0,moon=0}, atm = {dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2}, clouds = {cover=0.4,dens=0.4,color={255,220,180}} },
    ["Deep Space"] = { clock = 0, brightness = 1, ambient = {30,25,50}, outAmb = {40,35,60}, sky = {stars=15000,moon=0,sun=0}, atm = {dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3} },
    ["Lavender Dream"] = { clock = 18.5, brightness = 2.6, ambient = {180,160,220}, outAmb = {190,170,230}, sky = {stars=800,moon=16,sun=0}, atm = {dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8}, clouds = {cover=0.55,dens=0.5,color={220,200,255}} },
    ["Inferno"] = { clock = 17.5, brightness = 2.4, ambient = {220,140,90}, outAmb = {235,150,100}, sky = {sun=26,moon=0,stars=0}, atm = {dens=0.5,color={255,130,70},decay={200,80,40},glare=2.2,haze=2.2}, clouds = {cover=0.6,dens=0.6,color={200,110,80}} },
    ["Mint Sky"] = { clock = 10, brightness = 3.2, ambient = {180,230,210}, outAmb = {190,240,220}, sky = {sun=10}, atm = {dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6}, clouds = {cover=0.55,dens=0.45,color={240,255,250}} },
}
function _vC3(rgb) return Color3.fromRGB(rgb[1], rgb[2], rgb[3]) end
function clearCelestialSky()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute(SKY_TAG) then pcall(function() child:Destroy() end) end
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:GetAttribute(SKY_TAG) then pcall(function() child:Destroy() end) end
        end
    end
end

applyCustomSky = function(mode)
    clearCelestialSky()
    local preset = SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        Lighting.ClockTime = 14
        Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.fromRGB(80, 40, 160)
        Lighting.Ambient = Color3.fromRGB(80, 40, 160)
        Lighting.FogEnd = 100000
        Lighting.FogColor = Color3.fromRGB(80, 40, 160)
        Lighting.GlobalShadows = true
        return
    end
    Lighting.FogStart = 0
    Lighting.FogEnd = 100000
    Lighting.FogColor = Color3.fromRGB(80, 40, 160)
    Lighting.ColorShift_Top = Color3.fromRGB(0, 0, 0)
    Lighting.ColorShift_Bottom = Color3.fromRGB(0, 0, 0)
    Lighting.GlobalShadows = true
    Lighting.ClockTime = preset.clock or 14
    Lighting.Brightness = preset.brightness or 2
    if preset.outAmb then Lighting.OutdoorAmbient = _vC3(preset.outAmb) end
    if preset.ambient then Lighting.Ambient = _vC3(preset.ambient) end
    if preset.sky then
        local skyInst = Instance.new("Sky")
        skyInst:SetAttribute(SKY_TAG, true)
        if preset.sky.stars then skyInst.StarCount = preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize = preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize = preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId = "rbxasset://sky/moon.jpg" end
        skyInst.Parent = Lighting
    end
    if preset.atm then
        local atm = Instance.new("Atmosphere")
        atm:SetAttribute(SKY_TAG, true)
        atm.Density = preset.atm.dens or 0.3
        atm.Color = _vC3(preset.atm.color)
        atm.Decay = _vC3(preset.atm.decay)
        atm.Glare = preset.atm.glare or 1
        atm.Haze = preset.atm.haze or 1
        atm.Parent = Lighting
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if preset.clouds and terrain then
        local clouds = Instance.new("Clouds")
        clouds:SetAttribute(SKY_TAG, true)
        clouds.Cover = preset.clouds.cover or 0.5
        clouds.Density = preset.clouds.dens or 0.5
        clouds.Color = _vC3(preset.clouds.color)
        clouds.Parent = terrain
    end
end

if Config.CustomSky and Config.CustomSkyTheme and Config.CustomSkyTheme ~= "Off" then
    task.defer(function()
        if applyCustomSky then pcall(applyCustomSky, Config.CustomSkyTheme) end
    end)
end

customAnimSnapshots = setmetatable({}, {__mode = "k"})

function snapshotCharacterAnimations(char)
    if not char or customAnimSnapshots[char] then return end
    local animate = char:FindFirstChild("Animate")
    if not animate then return end

    local snap = {
        animateDisabled = animate.Disabled,
        objects = {},
    }

    for _, obj in ipairs(animate:GetDescendants()) do
        if obj:IsA("Animation") then
            snap.objects[obj] = {
                parent = obj.Parent,
                name = obj.Name,
                id = obj.AnimationId,
            }
        end
    end

    customAnimSnapshots[char] = snap
end

function restoreCharacterAnimations(char)
    local snap = char and customAnimSnapshots[char]
    local animate = char and char:FindFirstChild("Animate")
    if not animate then return end

    if snap then
        for obj, info in pairs(snap.objects) do
            if obj and obj.Parent then
                pcall(function()
                    obj.AnimationId = info.id
                    obj.Name = info.name
                end)
            elseif info.parent and info.parent.Parent then
                local restored = Instance.new("Animation")
                restored.Name = info.name
                restored.AnimationId = info.id
                restored.Parent = info.parent
            end
        end

        for _, obj in ipairs(animate:GetDescendants()) do
            if obj:IsA("Animation") and not snap.objects[obj] then
                pcall(function() obj:Destroy() end)
            end
        end

        customAnimSnapshots[char] = nil
    end

    animate.Disabled = false

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
            pcall(function() track:Stop(0) end)
        end
    end

    task.defer(function()
        if animate and animate.Parent then
            animate.Disabled = true
            task.wait(0.03)
            if animate.Parent then animate.Disabled = false end
        end
    end)
end


ANIM_PACKS = {
    ["Adidas Sports"] = {WalkAnim=18537392113, RunAnim=18537384940, JumpAnim=18537380791, FallAnim=18537367238, SwimIdle=18537387180, Swim=18537389531, Animation1=18537376492, Animation2=18537371272, ClimbAnim=18537363391},
    ["Adidas Community"] = {WalkAnim=122150855457006, RunAnim=82598234841035, JumpAnim=75290611992385, FallAnim=98600215928904, SwimIdle=109346520324160, Swim=133308483266208, Animation1=122257458498464, Animation2=102357151005774, ClimbAnim=88763136693023},
    ["Adidas Aura"] = {WalkAnim=83842218823011, RunAnim=118320322718866, JumpAnim=109996626521204, FallAnim=95603166884636, SwimIdle=94922130551805, Swim=134530128383903, Animation1=110211186840347, Animation2=114191137265065, ClimbAnim=97824616490448},
    ["Wicked Popular"] = {WalkAnim=92072849924640, RunAnim=72301599441680, JumpAnim=104325245285198, FallAnim=121152442762481, Animation1=118832222982049, ClimbAnim=131326830509784, SwimIdle=113199415118199, Swim=99384245425157, Animation2=76049494037641},
    Elder = {WalkAnim=10921111375, RunAnim=10921104374, JumpAnim=10921107367, FallAnim=10921105765, SwimIdle=10921110146, Swim=10921108971, ClimbAnim=10921100400, Animation1=10921101664, Animation2=10921102574},
    Zombie = {WalkAnim=10921355261, RunAnim=616163682, JumpAnim=10921351278, FallAnim=10921350320, SwimIdle=10921353442, Swim=10921352344, Animation1=10921344533, Animation2=10921345304, ClimbAnim=10921343576},
    Mage = {WalkAnim=10921152678, RunAnim=10921148209, JumpAnim=10921149743, FallAnim=10921148939, SwimIdle=10921151661, Swim=10921150788, ClimbAnim=10921143404, Animation1=10921144709, Animation2=10921145797},
    ["Catwalk Glam"] = {WalkAnim=109168724482748, RunAnim=81024476153754, JumpAnim=116936326516985, FallAnim=92294537340807, SwimIdle=98854111361360, Swim=134591743181628, ClimbAnim=119377220967554, Animation1=133806214992291, Animation2=94970088341563},
    Astronaut = {WalkAnim=10921046031, RunAnim=10921039308, JumpAnim=10921042494, FallAnim=10921040576, SwimIdle=10921045006, Swim=10921044000, ClimbAnim=10921032124, Animation1=10921034824, Animation2=10921036806},
    ["Wicked Dancing Through Life"] = {WalkAnim=73718308412641, RunAnim=135515454877967, JumpAnim=78508480717326, FallAnim=78147885297412, SwimIdle=129183123083281, Swim=110657013921774, ClimbAnim=129447497744818, Animation1=92849173543269, Animation2=132238900951109},
    Werewolf = {WalkAnim=10921342074, RunAnim=10921336997, FallAnim=10921337907, SwimIdle=10921341319, Swim=10921340419, ClimbAnim=10921329322, Animation1=10921330408, Animation2=10921333667},
    Superhero = {WalkAnim=10921298616, RunAnim=10921291831, JumpAnim=10921294559, FallAnim=10921293373, SwimIdle=10921297391, Swim=10921295495, ClimbAnim=10921286911, Animation1=10921288909, Animation2=10921290167},
    Toy = {WalkAnim=10921312010, RunAnim=10921306285, JumpAnim=10921308158, FallAnim=10921307241, SwimIdle=10921310341, Swim=10921309319, ClimbAnim=10921300839, Animation1=10921301576},
    ["No Boundaries"] = {WalkAnim=18747074203, RunAnim=18747070484, JumpAnim=18747069148, FallAnim=18747062535, SwimIdle=18747071682, Swim=18747073181, ClimbAnim=18747060903, Animation1=18747067405, Animation2=18747063918},
    NFL = {WalkAnim=110358958299415, RunAnim=117333533048078, JumpAnim=119846112151352, FallAnim=129773241321032, SwimIdle=79090109939093, Swim=132697394189921, ClimbAnim=134630013742019, Animation1=92080889861410, Animation2=74451233229259},
    ["Amazon Unboxed"] = {WalkAnim=90478085024465, RunAnim=134824450619865, JumpAnim=121454505477205, FallAnim=94788218468396, SwimIdle=129126268464847, Swim=105962919001086, ClimbAnim=121145883950231, Animation1=98281136301627},
    Vampire = {WalkAnim=10921326949, RunAnim=10921320299, JumpAnim=10921322186, FallAnim=10921321317, SwimIdle=10921325443, Swim=10921324408, ClimbAnim=10921314188, Animation1=10921315373},
    Ninja = {RunAnim=656118852, WalkAnim=656121766, JumpAnim=656117878, FallAnim=656115606, Swim=656119721, SwimIdle=656121397, ClimbAnim=656114359, Idle={656117400,656118341}},
    Robot = {RunAnim=616091570, WalkAnim=616095330, JumpAnim=616090535, FallAnim=616087089, Swim=616092998, SwimIdle=616094091, ClimbAnim=616086039, Idle={616088211,616089559}},
    Levitation = {RunAnim=616010382, WalkAnim=616013216, JumpAnim=616008936, FallAnim=616005863, Swim=616011509, SwimIdle=616012453, ClimbAnim=616003713, Idle={616006778,616008087}},
    Stylish = {RunAnim=616140816, WalkAnim=616146177, JumpAnim=616139451, FallAnim=616134815, Swim=616143378, SwimIdle=616144772, ClimbAnim=616133594, Idle={616136790,616138447}},
    Bubbly = {RunAnim=910025107, WalkAnim=910034870, JumpAnim=910016857, FallAnim=910001910, Swim=910028158, SwimIdle=910030921, ClimbAnim=909997997, Idle={910004836,910009958}},
    Cartoon = {RunAnim=742638842, WalkAnim=742640026, JumpAnim=742637942, FallAnim=742637151, Swim=742639220, SwimIdle=742639812, ClimbAnim=742636889, Idle={742637544,742638445}},
}

function _pick(pack, ...)
    for i = 1, select("#", ...) do
        local v = pack[select(i, ...)]
        if v ~= nil then return v end
    end
    return nil
end

_unwalkConn = nil
customAnimApplyToken = 0

function _setAnim(animObj, id)
    if not animObj or not id then return end
    pcall(function()
        animObj.AnimationId = "rbxassetid://" .. tostring(id)
    end)
end

function _ensureAnim(folder, name)
    if not folder then return nil end
    local a = folder:FindFirstChild(name)
    if not a then
        a = Instance.new("Animation")
        a.Name = name
        a.Parent = folder
    end
    return a
end

function _ensureFolder(animate, folderName)
    local f = animate:FindFirstChild(folderName)
    if not f then
        f = Instance.new("Folder")
        f.Name = folderName
        f.Parent = animate
    end
    return f
end

function waitForAnimate(char)
    if not char then return nil end
    for _ = 1, 60 do
        if not char.Parent then return nil end
        local a = char:FindFirstChild("Animate")
        if a and a:FindFirstChild("walk") and a:FindFirstChild("run") then
            local walk = a:FindFirstChild("walk")
            local run = a:FindFirstChild("run")
            if walk and run then return a end
        end
        task.wait(0.1)
    end
    return char:FindFirstChild("Animate")
end

applyAnimPack = function(packName)
    if not Config.CustomAnim then return end
    Config.Unwalk = false
    if type(stopUnwalk) == "function" then

        if _unwalkConn then pcall(function() _unwalkConn:Disconnect() end); _unwalkConn = nil end
    end
    packName = packName or Config.AnimPack
    local pack = ANIM_PACKS[packName]
    if not pack then

        for k, v in pairs(ANIM_PACKS) do
            if string.lower(k) == string.lower(tostring(packName)) then
                pack = v
                packName = k
                break
            end
        end
    end
    if not pack then return end
    Config.AnimPack = packName

    local char = LP.Character
    if not char then return end
    local animate = waitForAnimate(char)
    if not animate then return end

    snapshotCharacterAnimations(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
            pcall(function() t:Stop(0) end)
        end
    end

    local runObj = _ensureAnim(_ensureFolder(animate, "run"), "RunAnim")
    local walkObj = _ensureAnim(_ensureFolder(animate, "walk"), "WalkAnim")
    local jumpObj = _ensureAnim(_ensureFolder(animate, "jump"), "JumpAnim")
    local fallObj = _ensureAnim(_ensureFolder(animate, "fall"), "FallAnim")
    local climbObj = _ensureAnim(_ensureFolder(animate, "climb"), "ClimbAnim")
    local swimObj = _ensureAnim(_ensureFolder(animate, "swim"), "Swim")
    local swimIdleObj = _ensureAnim(_ensureFolder(animate, "swimidle"), "SwimIdle")
    local idleFolder = _ensureFolder(animate, "idle")

    _setAnim(walkObj, _pick(pack, "WalkAnim", "Walk"))
    _setAnim(runObj, _pick(pack, "RunAnim", "Run"))
    _setAnim(jumpObj, _pick(pack, "JumpAnim", "Jump"))
    _setAnim(fallObj, _pick(pack, "FallAnim", "Fall"))
    _setAnim(climbObj, _pick(pack, "ClimbAnim", "Climb"))
    _setAnim(swimObj, _pick(pack, "Swim"))
    _setAnim(swimIdleObj, _pick(pack, "SwimIdle") or _pick(pack, "Swim"))

    if idleFolder then
        local a1 = _pick(pack, "Animation1")
        local a2 = _pick(pack, "Animation2")
        if a1 or a2 then
            _setAnim(_ensureAnim(idleFolder, "Animation1"), a1 or a2)
            _setAnim(_ensureAnim(idleFolder, "Animation2"), a2 or a1)
        elseif pack.Idle then
            _setAnim(_ensureAnim(idleFolder, "Animation1"), pack.Idle[1])
            _setAnim(_ensureAnim(idleFolder, "Animation2"), pack.Idle[2] or pack.Idle[1])
        end
    end

    animate.Disabled = true
    task.wait(0.06)
    animate.Disabled = false

    if hum then
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.Landed)
            task.wait(0.03)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
end

function startUnwalk()
    Config.Unwalk = true
    Config.CustomAnim = false
    if _unwalkConn then pcall(function() _unwalkConn:Disconnect() end); _unwalkConn = nil end
    local function stopTracks(char)
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
                pcall(function() t:Stop(0) end)
            end
        end
        local animate = char:FindFirstChild("Animate")
        if animate then
            pcall(function() animate.Disabled = true end)
        end
    end
    local char = LP.Character
    if char then
        pcall(function() snapshotCharacterAnimations(char) end)
        stopTracks(char)
    end

    _unwalkConn = RunService.Heartbeat:Connect(function()
        if not Config.Unwalk then return end
        local c = LP.Character
        if not c then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
            pcall(function() t:Stop(0) end)
        end
        local animate = c:FindFirstChild("Animate")
        if animate and not animate.Disabled then
            pcall(function() animate.Disabled = true end)
        end
    end)
end

function stopUnwalk()
    Config.Unwalk = false
    if _unwalkConn then pcall(function() _unwalkConn:Disconnect() end); _unwalkConn = nil end
    local char = LP.Character
    if not char then return end
    local animate = char:FindFirstChild("Animate")
    if animate then pcall(function() animate.Disabled = false end) end
    if Config.CustomAnim then
        pcall(function() applyAnimPack(Config.AnimPack) end)
    else
        pcall(function() restoreCharacterAnimations(char) end)
    end
end

LP.CharacterAdded:Connect(function(char)
    customAnimApplyToken = (customAnimApplyToken or 0) + 1
    local applyToken = customAnimApplyToken
    if Config.Unwalk then
        task.wait(0.5)
        if Config.Unwalk then pcall(startUnwalk) end
    elseif Config.CustomAnim then
        task.spawn(function()
            for _, delayTime in ipairs({0.35, 0.8, 1.4}) do
                task.wait(delayTime)
                if applyToken ~= customAnimApplyToken or not Config.CustomAnim or LP.Character ~= char then return end
                if applyAnimPack then pcall(applyAnimPack, Config.AnimPack) end
            end
        end)
    else
        task.wait(0.15)
        pcall(function()
            local animate = char and char:FindFirstChild("Animate")
            if animate then animate.Disabled = false end
        end)
    end
end)


antiLagState = {
    conn = nil,
    active = false,
    cache = {},
    lighting = nil,
    effects = {},
    beauty = {},
}

function celestialCacheProperty(instance, property)
    local entry = antiLagState.cache[instance]
    if not entry then entry = {}; antiLagState.cache[instance] = entry end
    if entry[property] == nil then
        local ok, value = pcall(function() return instance[property] end)
        if ok then entry[property] = value end
    end
end

function _applyAntiLagObj(instance)
    if not antiLagState.active then return end
    pcall(function()
        if instance:IsA("ParticleEmitter") or instance:IsA("Trail") or instance:IsA("Beam")
            or instance:IsA("Fire") or instance:IsA("Smoke") or instance:IsA("Sparkles") then
            celestialCacheProperty(instance, "Enabled")
            instance.Enabled = false
        elseif instance:IsA("BasePart") then
            celestialCacheProperty(instance, "CastShadow")
            instance.CastShadow = false
            if instance.Material == Enum.Material.Glass or instance.Material == Enum.Material.ForceField then
                celestialCacheProperty(instance, "Material")
                celestialCacheProperty(instance, "Reflectance")
                instance.Material = Enum.Material.SmoothPlastic
                instance.Reflectance = 0
            end
        end
    end)
end

function celestialClearBeautyEffects()
    for _, obj in pairs(antiLagState.beauty) do
        pcall(function()
            if obj and obj.Parent then obj:Destroy() end
        end)
    end
    table.clear(antiLagState.beauty)
end

function celestialApplyEmotionalGraphics()
    celestialClearBeautyEffects()

    local cc = Instance.new("ColorCorrectionEffect")
    cc.Name = "CelestialHubEmotionCC"
    cc.Brightness = 0.06
    cc.Contrast = 0.18
    cc.Saturation = 0.22
    cc.TintColor = Color3.fromRGB(180, 140, 255)
    cc.Parent = Lighting
    antiLagState.beauty.cc = cc

    local bloom = Instance.new("BloomEffect")
    bloom.Name = "CelestialHubEmotionBloom"
    bloom.Intensity = 0.55
    bloom.Size = 28
    bloom.Threshold = 0.92
    bloom.Parent = Lighting
    antiLagState.beauty.bloom = bloom

    local dof = Instance.new("DepthOfFieldEffect")
    dof.Name = "CelestialHubEmotionDoF"
    dof.FarIntensity = 0.18
    dof.NearIntensity = 0.05
    dof.FocusDistance = 28
    dof.InFocusRadius = 22
    dof.Parent = Lighting
    antiLagState.beauty.dof = dof

    local rays = Instance.new("SunRaysEffect")
    rays.Name = "CelestialHubEmotionRays"
    rays.Intensity = 0.08
    rays.Spread = 0.65
    rays.Parent = Lighting
    antiLagState.beauty.rays = rays

    local atmo = Lighting:FindFirstChildOfClass("Atmosphere")
    if not atmo then
        atmo = Instance.new("Atmosphere")
        atmo.Name = "CelestialHubEmotionAtmosphere"
        atmo.Parent = Lighting
        antiLagState.beauty.atmo = atmo
    else
        antiLagState.beauty.atmoSaved = {
            Density = atmo.Density,
            Offset = atmo.Offset,
            Color = atmo.Color,
            Decay = atmo.Decay,
            Glare = atmo.Glare,
            Haze = atmo.Haze,
        }
    end
    atmo.Density = 0.28
    atmo.Offset = 0.12
    atmo.Color = Color3.fromRGB(140, 60, 220)
    atmo.Decay = Color3.fromRGB(80, 40, 160)
    atmo.Glare = 0.35
    atmo.Haze = 1.6

    Lighting.Ambient = Color3.fromRGB(40, 20, 80)
    Lighting.OutdoorAmbient = Color3.fromRGB(60, 30, 120)
    Lighting.ColorShift_Top = Color3.fromRGB(0, 200, 255)
    Lighting.ColorShift_Bottom = Color3.fromRGB(40, 20, 80)
    Lighting.Brightness = 2.15
    Lighting.EnvironmentDiffuseScale = 0.55
    Lighting.EnvironmentSpecularScale = 0.35
    Lighting.GlobalShadows = false
    Lighting.FogColor = Color3.fromRGB(60, 40, 120)
    Lighting.FogStart = 40
    Lighting.FogEnd = 520
    Lighting.ClockTime = 19.35
    Lighting.GeographicLatitude = 25

    task.spawn(function()
        local t0 = tick()
        while antiLagState.active do
            local t = tick() - t0
            local pulse = 0.5 + 0.5 * math.sin(t * 0.55)
            local warm = Color3.fromRGB(0, 220, 255)
            local cool = Color3.fromRGB(140, 60, 220)
            if antiLagState.beauty.cc and antiLagState.beauty.cc.Parent then
                antiLagState.beauty.cc.TintColor = warm:Lerp(cool, pulse * 0.45)
                antiLagState.beauty.cc.Brightness = 0.04 + pulse * 0.05
                antiLagState.beauty.cc.Saturation = 0.18 + pulse * 0.08
            end
            if antiLagState.beauty.bloom and antiLagState.beauty.bloom.Parent then
                antiLagState.beauty.bloom.Intensity = 0.42 + pulse * 0.22
            end
            task.wait(0.08)
        end
    end)
end

enableAntiLag = function()
    if antiLagState.active then return end
    antiLagState.active = true
    antiLagState.cache = {}
    antiLagState.lighting = {
        GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd,
        FogStart = Lighting.FogStart,
        FogColor = Lighting.FogColor,
        Brightness = Lighting.Brightness,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        ColorShift_Top = Lighting.ColorShift_Top,
        ColorShift_Bottom = Lighting.ColorShift_Bottom,
        EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
        ClockTime = Lighting.ClockTime,
        GeographicLatitude = Lighting.GeographicLatitude,
    }
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:IsA("PostEffect") then
            antiLagState.effects[child] = child.Enabled
            pcall(function() child.Enabled = false end)
        end
    end

    celestialApplyEmotionalGraphics()

    if antiLagState.conn then antiLagState.conn:Disconnect() end
    antiLagState.conn = workspace.DescendantAdded:Connect(function(descendant)
        if antiLagState.active then _applyAntiLagObj(descendant) end
    end)
    task.spawn(function()
        local descendants = workspace:GetDescendants()
        for i = 1, #descendants do
            if not antiLagState.active then break end
            _applyAntiLagObj(descendants[i])
            if i % 220 == 0 then task.wait() end
        end
    end)
end

disableAntiLag = function()
    antiLagState.active = false
    if antiLagState.conn then antiLagState.conn:Disconnect(); antiLagState.conn = nil end

    celestialClearBeautyEffects()

    for instance, properties in pairs(antiLagState.cache) do
        if instance and instance.Parent then
            for property, value in pairs(properties) do
                pcall(function() instance[property] = value end)
            end
        end
    end
    table.clear(antiLagState.cache)

    for effect, enabled in pairs(antiLagState.effects) do
        if effect and effect.Parent then pcall(function() effect.Enabled = enabled end) end
    end
    table.clear(antiLagState.effects)

    if antiLagState.lighting then
        for property, value in pairs(antiLagState.lighting) do
            pcall(function() Lighting[property] = value end)
        end
        antiLagState.lighting = nil
    end

    local atmo = Lighting:FindFirstChild("CelestialHubEmotionAtmosphere")
    if atmo then pcall(function() atmo:Destroy() end) end
    local saved = antiLagState.beauty and antiLagState.beauty.atmoSaved
    if saved then
        local existing = Lighting:FindFirstChildOfClass("Atmosphere")
        if existing then
            for k, v in pairs(saved) do pcall(function() existing[k] = v end) end
        end
    end
    table.clear(antiLagState.beauty)
end


stretchRezConn = nil
stretchValue = 0.70
enableStretchRez = function()
    if stretchRezConn then stretchRezConn:Disconnect() end
    stretchRezConn = RunService.RenderStepped:Connect(function()
        if not Config.StretchRes then
            if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn = nil end
            return
        end
        local cam = workspace.CurrentCamera
        if cam then
            cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, stretchValue, 0, 0, 0, 1)
        end
    end)
end
disableStretchRez = function()
    if stretchRezConn then stretchRezConn:Disconnect(); stretchRezConn = nil end
end


customFovConn = nil
enableCustomFov = function()
    if customFovConn then customFovConn:Disconnect() end
    pcall(function() workspace.CurrentCamera.FieldOfView = Config.FOVValue end)
    customFovConn = RunService.RenderStepped:Connect(function()
        if not Config.FOVChange then
            if customFovConn then customFovConn:Disconnect(); customFovConn = nil end
            return
        end
        pcall(function() workspace.CurrentCamera.FieldOfView = Config.FOVValue end)
    end)
end
disableCustomFov = function()
    if customFovConn then customFovConn:Disconnect(); customFovConn = nil end
    pcall(function() workspace.CurrentCamera.FieldOfView = 70 end)
end






overheadGui = nil
overheadDiscord = nil
overheadSpeed = nil
overheadRagdoll = nil
overheadConn = nil
overheadRagEnd = 0
OVERHEAD_CYAN = Color3.fromRGB(0, 220, 255)



function getOverheadBodyAnchor(char)
    if not char then return nil end
    local preferred = {
        "HumanoidRootPart", "UpperTorso", "Torso", "LowerTorso",
        "Head", "UpperTorso", "RightUpperTorso", "LeftUpperTorso",
        "RightUpperArm", "LeftUpperArm", "Right Arm", "Left Arm",
        "RightUpperLeg", "LeftUpperLeg", "Right Leg", "Left Leg",
    }
    for _, partName in ipairs(preferred) do
        local part = char:FindFirstChild(partName)
        if part and part:IsA("BasePart") and part:IsDescendantOf(char) then
            return part
        end
    end

    for _, item in ipairs(char:GetDescendants()) do
        if item:IsA("BasePart") and item.Name ~= "Handle" then
            return item
        end
    end
    return nil
end

function ensureOverheadLabels(char)
    char = char or LP.Character
    if not char then return end
    local anchor = getOverheadBodyAnchor(char)
    if not anchor then return end

    if overheadGui and overheadGui.Parent then
        if overheadGui.Adornee ~= anchor then
            overheadGui.Adornee = anchor
        end
        if overheadGui.Parent ~= anchor then
            overheadGui.Parent = anchor
        end
        return
    end

    pcall(function()
        if overheadGui then overheadGui:Destroy() end
    end)

    local bb = Instance.new("BillboardGui")
    bb.Name = "CelestialOverhead"
    bb.Size = UDim2.new(0, 200, 0, 70)
    bb.StudsOffset = Vector3.new(0, 3.4, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = 200
    bb.Adornee = anchor
    bb.Parent = anchor
    overheadGui = bb

    bb.Size = UDim2.new(0, 160, 0, 30)
    bb.StudsOffset = Vector3.new(0, 3.0, 0)

    local function makeLbl(y, size, text)
        local lbl = Instance.new("TextLabel")
        lbl.Size = UDim2.new(1, 0, 0, size)
        lbl.Position = UDim2.new(0, 0, 0, y)
        lbl.BackgroundTransparency = 1
        lbl.Text = text
        lbl.TextColor3 = _G.CelestialThemeAccent or OVERHEAD_CYAN
        lbl.Font = Enum.Font.GothamBlack
        lbl.TextSize = size
        lbl.TextStrokeTransparency = 0.25
        lbl.TextStrokeColor3 = Color3.new(0, 0, 0)
        lbl.Parent = bb
        return lbl
    end


    -- Only speed number kept on head
    overheadRagdoll = nil
    overheadDiscord = nil

    overheadSpeed = makeLbl(0, 22, "Speed: " .. formatSpeedNum(Config.NormalSpeed or 59.5))
    overheadSpeed.TextSize = 16
    overheadSpeed.Position = UDim2.new(0, 0, 0, 0)
end

function updateOverheadSpeedText()
    if overheadSpeed then
        overheadSpeed.Text = "Speed: " .. formatSpeedNum(getActiveSpeed())
        overheadSpeed.TextColor3 = _G.CelestialThemeAccent or OVERHEAD_CYAN
    end
end



overheadWasInRag = false
OVERHEAD_RAGDOLL_SECONDS = 2.6

RunService.RenderStepped:Connect(function()
    ensureOverheadLabels(LP.Character)
    updateOverheadSpeedText()
    if overheadSpeed then overheadSpeed.TextColor3 = _G.CelestialThemeAccent or OVERHEAD_CYAN end

    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local inRag = false
    if hum then
        local st = hum:GetState()
        inRag = hum.PlatformStand
            or st == Enum.HumanoidStateType.Physics
            or st == Enum.HumanoidStateType.Ragdoll
            or st == Enum.HumanoidStateType.FallingDown
    end


    local endAttr = LP:GetAttribute("RagdollEndTime")
    if type(endAttr) == "number" and endAttr > workspace:GetServerTimeNow() then
        inRag = true
    end



    if inRag and not overheadWasInRag then
        overheadRagEnd = tick() + OVERHEAD_RAGDOLL_SECONDS
    end
    overheadWasInRag = inRag

    -- ragdoll label removed
end)

overheadRespawnToken = 0
LP.CharacterAdded:Connect(function(char)
    overheadRespawnToken += 1
    local thisToken = overheadRespawnToken
    task.spawn(function()
        local deadline = os.clock() + 8
        repeat
            if thisToken ~= overheadRespawnToken or LP.Character ~= char then return end
            ensureOverheadLabels(char)
            if overheadGui and overheadGui.Parent and overheadGui.Adornee
                and overheadGui.Adornee:IsDescendantOf(char) then
                return
            end
            task.wait(0.15)
        until os.clock() >= deadline
    end)
end)
if LP.Character then
    task.defer(function()
        local char = LP.Character
        for _ = 1, 20 do
            if LP.Character ~= char then return end
            ensureOverheadLabels(char)
            if overheadGui and overheadGui.Parent and overheadGui.Adornee
                and overheadGui.Adornee:IsDescendantOf(char) then
                return
            end
            task.wait(0.15)
        end
    end)
end




task.defer(function()
    task.wait(0.25)
    if Config.AntiRagdoll and _G._CelestialStartAntiRagdoll then
        pcall(_G._CelestialStartAntiRagdoll)
    end
    if syncAutoAntiDie then pcall(syncAutoAntiDie) end
    if Config.BatCounter and startBatCounter then pcall(startBatCounter) end
    if Config.MedusaCounter and startMedusaCounter then pcall(startMedusaCounter) end
    if Config.PlayerESP and startPlayerEsp then
        pcall(startPlayerEsp)
        Config.PlayerTracers = true
        if startPlayerTracers then pcall(startPlayerTracers) end
    elseif Config.PlayerTracers and startPlayerTracers then
        pcall(startPlayerTracers)
    end
    if Config.RagdollCountdown and LP.Character and hookRagdollCountdown then
        pcall(hookRagdollCountdown, LP.Character)
    end
    if Config.Unwalk and startUnwalk then pcall(startUnwalk) elseif Config.CustomAnim and applyAnimPack then pcall(applyAnimPack, Config.AnimPack) end
    if Config.NoCamCollision and setNoCamCollision then pcall(setNoCamCollision, true) end
    if Config.AutoTPDown then pcall(startAutoTPDown) end
    if Config.AntiLag and enableAntiLag then pcall(enableAntiLag) end
    if Config.StretchRes and enableStretchRez then pcall(enableStretchRez) end
    if Config.FOVChange and enableCustomFov then pcall(enableCustomFov) end
    if Config.AutoSteal and startAutoStealSystem then pcall(startAutoStealSystem) end
    if Config.BatAimbot and startBatAimbot then
        State.autoBatToggled = true
        pcall(startBatAimbot)
    end
end)



end
__celestialInitVisualLogic()






do
    local LPl = LP
    local ALPHA_HELD = 0.85
    local ALPHA_BASE = 0.7
    local ATTR = "RHBrOrigT"
    local state = {
        held = Config.BrainrotTransparencyHeld == true,
        base = Config.BrainrotTransparencyBase == true,
        heldDirty = true,
        baseDirty = true,
    }

    local BODY = {
        Head=1, Torso=1, UpperTorso=1, LowerTorso=1, HumanoidRootPart=1,
        ["Left Arm"]=1, ["Right Arm"]=1, ["Left Leg"]=1, ["Right Leg"]=1,
        LeftUpperArm=1, LeftLowerArm=1, LeftHand=1, RightUpperArm=1, RightLowerArm=1, RightHand=1,
        LeftUpperLeg=1, LeftLowerLeg=1, LeftFoot=1, RightUpperLeg=1, RightLowerLeg=1, RightFoot=1,
    }

    local function isMedusaPiece(inst)
        local cur = inst
        while cur and cur ~= workspace and cur ~= game do
            if cur.Name == "RivalMedusaReplica" or cur.Name == "ShelMedusaBombSkin"
                or cur.Name:lower():find("medusa", 1, true) then
                return true
            end
            if cur:IsA("Tool") then
                local n = cur.Name:lower()
                if n:find("medusa", 1, true) or n:find("stone", 1, true) or n:find("head", 1, true) then
                    return true
                end
            end
            cur = cur.Parent
        end
        return false
    end

    local function setT(inst, on, alpha)
        if inst:IsA("BasePart") or inst:IsA("Decal") or inst:IsA("Texture") then
            local o = inst:GetAttribute(ATTR)
            if isMedusaPiece(inst) then
                if o ~= nil then
                    inst.Transparency = o
                    inst:SetAttribute(ATTR, nil)
                end
                return
            end
            if on then
                if o == nil then o = inst.Transparency; inst:SetAttribute(ATTR, o) end
                local want = math.max(o, alpha)
                if inst.Transparency ~= want then inst.Transparency = want end
            elseif o ~= nil then
                inst.Transparency = o
                inst:SetAttribute(ATTR, nil)
            end
        end
    end

    local function setXray(root, on)
        local hl = root:FindFirstChild("RHBrXray")
        if on then
            if not hl then
                hl = Instance.new("Highlight")
                hl.Name = "RHBrXray"
                hl.Adornee = root
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.FillColor = Color3.fromRGB(0, 220, 255)
                hl.FillTransparency = 1
                hl.OutlineColor = Color3.fromRGB(140, 60, 220)
                hl.OutlineTransparency = 1
                hl.Parent = root
            else
                hl.FillTransparency = 1
                hl.OutlineTransparency = 1
            end
        elseif hl then
            hl:Destroy()
        end
    end

    local function applyTree(root, on, alpha)
        setT(root, on, alpha)
        for _, d in ipairs(root:GetDescendants()) do setT(d, on, alpha) end
        setXray(root, on)
    end

    local function topOf(part, char)
        local top = part
        local m = part:FindFirstAncestorOfClass("Model")
        while m and m ~= workspace and m ~= char and not m:IsDescendantOf(char) do
            top = m
            m = m.Parent and m.Parent:FindFirstAncestorOfClass("Model")
        end
        return top
    end

    local function heldTargets(char)
        local list, seen = {}, {}
        local function add(o) if o and not seen[o] then seen[o] = true; list[#list+1] = o end end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Model") then
                add(child)
            elseif child:IsA("BasePart") and not BODY[child.Name] then
                add(child)
            end
        end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            local ok, connected = pcall(function() return root:GetConnectedParts(true) end)
            if ok and connected then
                for _, p in ipairs(connected) do
                    if not p:IsDescendantOf(char) then add(topOf(p, char)) end
                end
            end
        end
        return list
    end

    local function myPlot()
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return nil end
        for _, plot in ipairs(plots:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            local yb = sign and sign:FindFirstChild("YourBase")
            if yb and yb:IsA("BillboardGui") and yb.Enabled then return plot end
        end
        return nil
    end

    local lastHeld = {}
    local function processHeld(on)
        local char = LPl.Character
        if not char then return end
        local targets = heldTargets(char)
        local current = {}
        for _, o in ipairs(targets) do
            current[o] = true
            applyTree(o, on, ALPHA_HELD)
            lastHeld[o] = true
        end
        for o in pairs(lastHeld) do
            if not current[o] then
                if o.Parent then applyTree(o, false, ALPHA_HELD) end
                lastHeld[o] = nil
            end
        end
    end

    local lastBase = {}
    local function baseTargets()
        local list, seen = {}, {}
        local function add(o) if o and not seen[o] then seen[o] = true; list[#list+1] = o end end
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return list end

        for _, plot in ipairs(plots:GetChildren()) do
            local pods = plot:FindFirstChild("AnimalPodiums")
            if not pods then continue end

            local function isContainer(inst)
                return inst == workspace or inst == plot or inst == pods or inst.Parent == pods
                    or inst:IsA("Folder")
            end

            for _, pod in ipairs(pods:GetChildren()) do
                local podBase = pod:FindFirstChild("Base")
                for _, c in ipairs(pod:GetChildren()) do
                    if c ~= podBase and c:IsA("Model") and not c:FindFirstChildOfClass("Humanoid") then add(c) end
                end
                local spawnPart = podBase and podBase:FindFirstChild("Spawn")
                if spawnPart and spawnPart:IsA("BasePart") then
                    local ok, parts = pcall(function()
                        return workspace:GetPartBoundsInRadius(spawnPart.Position + Vector3.new(0, 3, 0), 6)
                    end)
                    if ok and parts then
                        for _, part in ipairs(parts) do
                            if not part:IsDescendantOf(LPl.Character or workspace) or not LPl.Character then
                                local top = nil
                                local cur = part.Parent
                                while cur and not isContainer(cur) do
                                    if cur:IsA("Model") then top = cur end
                                    cur = cur.Parent
                                end
                                if top and top ~= pod and top ~= podBase and not top:IsAncestorOf(podBase)
                                   and not top:FindFirstChild("Spawn", true)
                                   and not top:FindFirstChildOfClass("Humanoid")
                                   and not top:IsDescendantOf(podBase)
                                   and not (LPl.Character and top:IsDescendantOf(LPl.Character)) then
                                    add(top)
                                end
                            end
                        end
                    end
                end
            end
        end
        return list
    end

    local function processBase(on)
        local targets = baseTargets()
        local current = {}
        for _, o in ipairs(targets) do
            current[o] = true
            applyTree(o, on, ALPHA_BASE)
            lastBase[o] = true
        end
        for o in pairs(lastBase) do
            if not current[o] then
                if o.Parent then applyTree(o, false, ALPHA_BASE) end
                lastBase[o] = nil
            end
        end
    end

    local api = {
        SetHeld = function(v)
            state.held = v and true or false
            state.heldDirty = true
            Config.BrainrotTransparencyHeld = state.held
        end,
        SetBase = function(v)
            state.base = v and true or false
            state.baseDirty = true
            Config.BrainrotTransparencyBase = state.base
        end,
    }
    _G.CelestialBrainrotTransparency = api
    _G.CelestialHubBrainrotTransparency = api

    task.spawn(function()
        while true do
            pcall(function()
                if state.held or state.heldDirty then processHeld(state.held); state.heldDirty = false end
            end)
            task.wait(0.1)
        end
    end)
    task.spawn(function()
        while true do
            pcall(function()
                if state.base or state.baseDirty then processBase(state.base); state.baseDirty = false end
            end)
            task.wait(0.4)
        end
    end)

    if Config.BrainrotTransparencyBase then api.SetBase(true) end
    if Config.BrainrotTransparencyHeld then api.SetHeld(true) end
end

function playCelestialIntro()
    if Config.IntroEnabled == false then return end

    -- SYNPASE X CELESTIAL | 10 second intro v10
    -- Skip: SKIP button, double tap / double click, or Space / Enter / Esc.
    -- Just execute it. The song builds itself (needs an executor with writefile + getcustomasset).
    -- Optional: put your own song ID below to use that instead.

    local SONG_ID = "" -- optional, e.g. "rbxassetid://123456789" (leave empty for the built-in song)

    local Players = game:GetService("Players")
    local TS = game:GetService("TweenService")
    local RS = game:GetService("RunService")
    local SoundService = game:GetService("SoundService")
    local Debris = game:GetService("Debris")
    local UIS = game:GetService("UserInputService")
    local TextService = game:GetService("TextService")

    local CYAN = Color3.fromRGB(0, 229, 255)
    local PURPLE = Color3.fromRGB(150, 50, 255)
    local DEEP = Color3.fromRGB(70, 0, 140)
    local SMOKEBLACK = Color3.fromRGB(4, 4, 8)
    local BLACK = Color3.new(0, 0, 0)
    local WHITE = Color3.new(1, 1, 1)

    local DURATION = 10
    local BEAT = 60 / 140
    local DROP1 = 7 * BEAT   -- ~3.0s  title slams in
    local DROP2 = 15 * BEAT  -- ~6.43s big drop

    local function parentGui(g)
    	pcall(function()
    		if typeof(protect_gui) == "function" then protect_gui(g)
    		elseif syn and syn.protect_gui then syn.protect_gui(g)
    		elseif typeof(hide_in_gcoregui) == "function" then hide_in_gcoregui(g)
    		end
    	end)
    	local ok = false
    	if gethui then ok = pcall(function() g.Parent = gethui() end) end
    	if not ok or not g.Parent then ok = pcall(function() g.Parent = game:GetService("CoreGui") end) end
    	if not g.Parent then g.Parent = Players.LocalPlayer:WaitForChild("PlayerGui") end
    end

    -- full screen gui (covers notch / side corners too)
    local gui = Instance.new("ScreenGui")
    gui.Name = "SynpaseIntro"
    gui.IgnoreGuiInset = true
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 999999
    gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() gui.ScreenInsets = Enum.ScreenInsets.None end)
    parentGui(gui)

    -- root is bigger than the screen so shaking never shows edges
    local root = Instance.new("CanvasGroup")
    root.AnchorPoint = Vector2.new(0.5, 0.5)
    root.Position = UDim2.fromScale(0.5, 0.5)
    root.Size = UDim2.new(1, 200, 1, 200)
    root.BackgroundColor3 = BLACK
    root.BorderSizePixel = 0
    root.Active = true
    root.Parent = gui

    local cam = workspace.CurrentCamera
    local VS = cam and cam.ViewportSize or Vector2.new(1280, 720)
    local barPx = math.floor(VS.Y * 0.09)

    ------------------------------------------------------------------
    -- SONG (generated in code, written to a wav file, played with getcustomasset)
    ------------------------------------------------------------------
    local function buildSong()
    	local ga = getcustomasset or getsynasset
    	if not (writefile and ga) then return nil end
    	local SR = 22050
    	local N = SR * DURATION
    	local TAU = math.pi * 2
    	local buf = table.create(N, 0)
    	local STEP = BEAT / 4

    	local function add(t0, len, fn)
    		local s = math.floor(t0 * SR)
    		for i = 0, math.floor(len * SR) - 1 do
    			local idx = s + i + 1
    			if idx > N then break end
    			buf[idx] += fn(i / SR)
    		end
    	end
    	-- hard punchy kick with a click
    	local function kick(t0)
    		local ph = 0
    		add(t0, 0.18, function(t)
    			ph += TAU * (48 + 170 * math.exp(-t * 38)) / SR
    			local click = (math.random() * 2 - 1) * math.exp(-t * 600) * 0.4
    			return (math.sin(ph) * math.exp(-t * 16) + click) * 0.9
    		end)
    	end
    	-- distorted 808 sub (saturation makes it audible on phone speakers)
    	local function sub808(t0, f, len)
    		local ph = 0
    		add(t0, len, function(t)
    			ph += TAU * f * (1 + 1.2 * math.exp(-t * 28)) / SR
    			local x = math.sin(ph) * 1.4
    			x = x / (1 + math.abs(x) * 1.5) * 1.6
    			return x * 0.9 * math.exp(-t * 3.2) * math.min(1, t / 0.003) * math.min(1, (len - t) / 0.03)
    		end)
    	end
    	local function clap(t0)
    		local l1, l2 = 0, 0
    		add(t0, 0.25, function(t)
    			l1 += 0.45 * ((math.random() * 2 - 1) - l1)
    			local band = l1 - l2
    			l2 += 0.08 * (l1 - l2)
    			local env = math.exp(-t * 16)
    			if t < 0.033 then env *= 0.5 + 0.5 * math.abs(math.sin(t * math.pi / 0.011)) end
    			return band * 3 * env * 0.55 + math.sin(TAU * 190 * t) * math.exp(-t * 40) * 0.12
    		end)
    	end
    	local function hat(t0, v)
    		local lp = 0
    		add(t0, 0.06, function(t)
    			local n = math.random() * 2 - 1
    			lp += 0.25 * (n - lp)
    			return (n - lp) * v * math.exp(-t * 70)
    		end)
    	end
    	local function cow(t0)
    		add(t0, 0.25, function(t)
    			local a = (math.sin(TAU * 540 * t) > 0 and 1 or -1) + (math.sin(TAU * 800 * t) > 0 and 1 or -1)
    			return a * 0.045 * math.exp(-t * 14)
    		end)
    	end
    	local function thump(t0, v)
    		local ph = 0
    		add(t0, 0.25, function(t)
    			ph += TAU * (45 + 50 * math.exp(-t * 30)) / SR
    			return math.sin(ph) * math.exp(-t * 16) * v
    		end)
    	end
    	local function boom(t0)
    		local ph = 0
    		add(t0, 1.4, function(t)
    			ph += TAU * (28 + 62 * math.exp(-t * 4)) / SR
    			local n = (math.random() * 2 - 1) * math.exp(-t * 6)
    			return math.sin(ph) * math.exp(-t * 2.8) * 0.9 + n * 0.25
    		end)
    	end
    	-- dark noise swell
    	local function riser(len)
    		local y = 0
    		add(0, len, function(t)
    			local p = t / len
    			local fc = 200 * (35 ^ p)
    			y += (1 - math.exp(-TAU * fc / SR)) * ((math.random() * 2 - 1) - y)
    			return y * (0.05 + 0.9 * p * p) * 0.5
    		end)
    	end
    	-- low evil drone under the intro
    	local function drone(len)
    		local ph1, ph2, y = 0, 0, 0
    		add(0, len, function(t)
    			local p = t / len
    			ph1 += TAU * (43.65 + 6 * p) / SR
    			ph2 = (ph2 + 87.3 * 1.004 / SR) % 1
    			local fc = 120 + 700 * p * p
    			y += (1 - math.exp(-TAU * fc / SR)) * ((ph2 * 2 - 1) - y)
    			local lfo = 0.7 + 0.3 * math.sin(TAU * 0.6 * t)
    			return (math.sin(ph1) * 0.5 + y * 0.45 * lfo) * (0.2 + 0.8 * p) * 0.8
    		end)
    	end

    	-- 0 - 3s: drone + accelerating heartbeat + swell, then a hard cut before the drop
    	local PRE = DROP1 - 0.1
    	drone(PRE)
    	riser(PRE)
    	local th = {0.35, 0.8, 1.2, 1.55, 1.85, 2.1, 2.3, 2.48, 2.64, 2.78}
    	for i, tt in ipairs(th) do thump(tt, 0.35 + 0.65 * i / #th) end
    	boom(DROP1)
    	boom(DROP2)

    	-- trap / phonk groove: 808 + kick + half-time clap + hat rolls (+ cowbell after drop 2)
    	local A808 = {[0] = {43.65, 0.6}, [6] = {43.65, 0.34}, [10] = {34.65, 0.5}}
    	local B808 = {[0] = {43.65, 0.6}, [6] = {43.65, 0.34}, [10] = {34.65, 0.34}, [13] = {38.89, 0.3}}
    	local s = 0
    	while true do
    		local t = DROP1 + s * STEP
    		if t >= DURATION - 0.45 then break end
    		local b = s % 16
    		local bar = (s // 16) % 2
    		local post = t >= DROP2 - 0.001
    		if s ~= 31 then -- one step of silence right before drop 2
    			if b == 0 or b == 6 or b == 10 or (bar == 1 and b == 13) then kick(t) end
    			local n = (bar == 0 and A808 or B808)[b]
    			if n then sub808(t, n[1], n[2]) end
    			hat(t, (b % 2 == 0) and 0.12 or 0.2)
    			if b >= 12 or (post and b == 7) then hat(t + STEP / 2, 0.14) end
    		end
    		if b == 8 then clap(t) end
    		if s >= 28 and s < 32 then
    			clap(t)
    			clap(t + STEP / 2)
    		end
    		if post and (b == 0 or b == 3 or b == 6 or b == 10) then cow(t) end
    		s += 1
    	end

    	local out = table.create(N)
    	for n = 1, N do
    		local t = (n - 1) / SR
    		local x = buf[n] * math.min(1, t / 0.1) * math.min(1, (DURATION - t) / 0.7) * 1.8
    		x = x / (1 + math.abs(x)) * 1.6
    		out[n] = string.pack("<i2", math.floor(math.clamp(x, -1, 1) * 32000))
    	end
    	local dataSize = N * 2
    	local header = string.pack("<c4I4c4c4I4I2I2I4I4I2I2c4I4", "RIFF", 36 + dataSize, "WAVE", "fmt ", 16, 1, 1, SR, SR * 2, 2, 16, "data", dataSize)
    	if not pcall(writefile, "synpase_intro_song.wav", header .. table.concat(out)) then return nil end
    	local ok, asset = pcall(ga, "synpase_intro_song.wav")
    	return ok and asset or nil
    end

    local songAsset = SONG_ID
    if songAsset == "" then
    	local ok, res = pcall(buildSong)
    	songAsset = (ok and res) or ""
    end

    local snd = Instance.new("Sound")
    snd.SoundId = songAsset
    snd.Volume = 1
    snd.Parent = SoundService
    local waited = 0
    while songAsset ~= "" and not snd.IsLoaded and waited < 3 do
    	waited += task.wait()
    end

    ------------------------------------------------------------------
    -- NEON FOG (left cyan, right purple) behind the smoke
    ------------------------------------------------------------------
    local function fog(color, x, rot)
    	local f = Instance.new("Frame")
    	f.BackgroundColor3 = color
    	f.BackgroundTransparency = 0.8
    	f.BorderSizePixel = 0
    	f.Position = UDim2.fromScale(x, 0)
    	f.Size = UDim2.fromScale(0.65, 1)
    	f.ZIndex = 1
    	local ug = Instance.new("UIGradient")
    	ug.Transparency = NumberSequence.new(0, 1)
    	ug.Rotation = rot
    	ug.Parent = f
    	f.Parent = root
    	return f
    end
    local glowL, glowR = fog(CYAN, 0, 0), fog(PURPLE, 0.35, 180)

    ------------------------------------------------------------------
    -- SMOKE (no textures: stacked soft blobs, so it always shows)
    ------------------------------------------------------------------
    local smokeLayer = Instance.new("Frame")
    smokeLayer.Size = UDim2.fromScale(1, 1)
    smokeLayer.BackgroundTransparency = 1
    smokeLayer.ZIndex = 2
    smokeLayer.Parent = root

    local LAYERS = {1, 0.82, 0.64, 0.46, 0.3}
    local function blob(color, op)
    	local c = Instance.new("Frame")
    	c.BackgroundTransparency = 1
    	c.AnchorPoint = Vector2.new(0.5, 0.5)
    	for i, k in ipairs(LAYERS) do
    		local f = Instance.new("Frame")
    		f.AnchorPoint = Vector2.new(0.5, 0.5)
    		local j = (i - 1) * 0.04
    		f.Position = UDim2.fromScale(0.5 + (math.random() * 2 - 1) * j, 0.5 + (math.random() * 2 - 1) * j)
    		f.Size = UDim2.fromScale(k * (0.85 + math.random() * 0.3), k * (0.85 + math.random() * 0.3))
    		f.BackgroundColor3 = color
    		f.BackgroundTransparency = 1 - op
    		f.BorderSizePixel = 0
    		Instance.new("UICorner", f).CornerRadius = UDim.new(1, 0)
    		f.Parent = c
    	end
    	return c
    end

    local alive = true
    local colOp = 0.07
    local function puff(color, op, minS, maxS, life, z, pre)
    	local size = math.random(minS, maxS)
    	local dir = math.random() < 0.5 and -1 or 1
    	local x0 = math.random()
    	local c = blob(color, op)
    	c.ZIndex = z
    	c.Size = pre and UDim2.fromOffset(size * 0.7, size * 0.7) or UDim2.fromOffset(0, 0)
    	c.Position = pre and UDim2.fromScale(x0, math.random(30, 110) / 100) or UDim2.fromScale(x0, 1.2)
    	c.Parent = smokeLayer
    	TS:Create(c, TweenInfo.new(life * 0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {
    		Size = UDim2.fromOffset(size, size),
    		Position = UDim2.fromScale(x0 + dir * 0.12, math.random(10, 60) / 100),
    	}):Play()
    	task.delay(life * 0.55, function()
    		TS:Create(c, TweenInfo.new(life * 0.45, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {
    			Size = UDim2.fromOffset(0, 0),
    			Position = UDim2.fromScale(x0 + dir * 0.3, math.random(-15, 25) / 100),
    		}):Play()
    	end)
    	Debris:AddItem(c, life + 0.2)
    end

    local colors = {CYAN, PURPLE, DEEP, PURPLE}
    for i = 1, 10 do
    	puff(colors[math.random(1, 4)], colOp, 800, 1300, 8, 1, true)
    	puff(SMOKEBLACK, 0.1, 900, 1500, 9, 2, true)
    end
    task.spawn(function()
    	while alive do
    		puff(colors[math.random(1, 4)], colOp, 800, 1300, math.random(70, 100) / 10, 1)
    		task.wait(0.4)
    	end
    end)
    task.spawn(function()
    	while alive do
    		puff(SMOKEBLACK, 0.1, 900, 1500, math.random(70, 100) / 10, 2)
    		task.wait(0.3)
    	end
    end)

    -- floating dust / embers
    task.spawn(function()
    	local cols = {CYAN, PURPLE, WHITE}
    	while alive do
    		local p = Instance.new("Frame")
    		p.BackgroundColor3 = cols[math.random(1, 3)]
    		p.BackgroundTransparency = 0.35
    		p.BorderSizePixel = 0
    		p.Size = UDim2.fromOffset(3, 3)
    		p.Position = UDim2.fromScale(math.random(), 1.05)
    		p.ZIndex = 6
    		p.Parent = root
    		local life = math.random(50, 80) / 10
    		TS:Create(p, TweenInfo.new(life, Enum.EasingStyle.Sine), {
    			Position = UDim2.fromScale(p.Position.X.Scale + math.random(-15, 15) / 100, -0.05),
    			BackgroundTransparency = 1,
    		}):Play()
    		Debris:AddItem(p, life + 0.1)
    		task.wait(0.1)
    	end
    end)

    -- dark vignette on all four edges
    local function edge(pos, size, rot)
    	local f = Instance.new("Frame")
    	f.BackgroundColor3 = BLACK
    	f.BorderSizePixel = 0
    	f.Position = pos
    	f.Size = size
    	f.ZIndex = 5
    	local ug = Instance.new("UIGradient")
    	ug.Transparency = NumberSequence.new(0, 1)
    	ug.Rotation = rot
    	ug.Parent = f
    	f.Parent = root
    end
    edge(UDim2.fromScale(0, 0), UDim2.fromScale(0.3, 1), 0)
    edge(UDim2.fromScale(0.7, 0), UDim2.fromScale(0.3, 1), 180)
    edge(UDim2.fromScale(0, 0), UDim2.fromScale(1, 0.3), 90)
    edge(UDim2.fromScale(0, 0.7), UDim2.fromScale(1, 0.3), 270)

    -- cinematic bars with neon lines
    local barLines = {}
    local function bar(top)
    	local b = Instance.new("Frame")
    	b.BackgroundColor3 = BLACK
    	b.BorderSizePixel = 0
    	b.AnchorPoint = Vector2.new(0, top and 0 or 1)
    	b.Position = UDim2.fromScale(0, top and 0 or 1)
    	b.Size = UDim2.new(1, 0, 0, 0)
    	b.ZIndex = 15
    	b.Parent = root
    	TS:Create(b, TweenInfo.new(0.7, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 100 + barPx)}):Play()
    	local l = Instance.new("Frame")
    	l.BackgroundColor3 = top and CYAN or PURPLE
    	l.BorderSizePixel = 0
    	l.AnchorPoint = Vector2.new(0.5, top and 1 or 0)
    	l.Position = UDim2.fromScale(0.5, top and 1 or 0)
    	l.Size = UDim2.new(0, 0, 0, 2)
    	l.Parent = b
    	table.insert(barLines, l)
    end
    bar(true)
    bar(false)

    local hint = Instance.new("TextLabel")
    hint.AnchorPoint = Vector2.new(0.5, 0.5)
    hint.Position = UDim2.new(0.5, 0, 1, -(100 + math.floor(barPx / 2)))
    hint.Size = UDim2.fromOffset(300, 20)
    hint.BackgroundTransparency = 1
    hint.Font = Enum.Font.GothamMedium
    hint.Text = "double tap to skip"
    hint.TextSize = math.clamp(math.floor(VS.Y * 0.025), 12, 20)
    hint.TextColor3 = Color3.fromRGB(190, 190, 205)
    hint.TextTransparency = 1
    hint.ZIndex = 16
    hint.Parent = root
    local skipBtn = Instance.new("TextButton")
    skipBtn.AnchorPoint = Vector2.new(1, 1)
    skipBtn.Position = UDim2.new(1, -34, 1, -22)
    skipBtn.Size = UDim2.fromOffset(96, 34)
    skipBtn.BackgroundColor3 = Color3.fromRGB(14, 14, 18)
    skipBtn.BackgroundTransparency = 1
    skipBtn.BorderSizePixel = 0
    skipBtn.Text = "SKIP  \u{25B6}"
    skipBtn.TextColor3 = WHITE
    skipBtn.TextTransparency = 1
    skipBtn.Font = Enum.Font.GothamBold
    skipBtn.TextSize = 13
    skipBtn.AutoButtonColor = false
    skipBtn.ZIndex = 100
    skipBtn.Parent = gui
    Instance.new("UICorner", skipBtn).CornerRadius = UDim.new(0, 10)
    local skipStroke = Instance.new("UIStroke", skipBtn)
    skipStroke.Color = CYAN
    skipStroke.Thickness = 1.5
    skipStroke.Transparency = 1

    task.delay(0.8, function()
    	TS:Create(hint, TweenInfo.new(0.5), {TextTransparency = 0.45}):Play()
    	TS:Create(skipBtn, TweenInfo.new(0.5), {BackgroundTransparency = 0.15, TextTransparency = 0}):Play()
    	TS:Create(skipStroke, TweenInfo.new(0.5), {Transparency = 0.3}):Play()
    end)

    ------------------------------------------------------------------
    -- TITLE: SYNPASE / [X emblem] / CELESTIAL (brush lettering, drips, crown)
    ------------------------------------------------------------------
    local shaker = Instance.new("Frame")
    shaker.AnchorPoint = Vector2.new(0.5, 0.5)
    shaker.Position = UDim2.fromScale(0.5, 0.5)
    shaker.Size = UDim2.fromScale(0.8, 0.78)
    shaker.BackgroundTransparency = 1
    shaker.ZIndex = 10
    shaker.Parent = root
    local scaleObj = Instance.new("UIScale")
    scaleObj.Scale = 1.15
    scaleObj.Parent = shaker

    local textLines, strokes, deco, drips = {}, {}, {}, {}
    local TFONT = Enum.Font.PermanentMarker -- brush / marker lettering
    local SILVER_TOP, SILVER_BOT = Color3.fromRGB(255, 255, 255), Color3.fromRGB(150, 150, 165)
    local TILT = -5 -- slanted, like hand painted lettering
    local function measure(text, size)
        local ok, b = pcall(function()
            return TextService:GetTextSize(text, size, TFONT, Vector2.new(10000, 1000))
        end)
        return (ok and b.X > 0) and b.X or (#text * size * 0.6)
    end
    local TSIZE = math.max(18, math.floor(math.min(100 * (VS.X * 0.7) / measure("CELESTIAL", 100), VS.Y * 0.17)))
    local function addDeco(f, base)
        table.insert(deco, {f = f, base = base})
    end
    local function round(f)
        Instance.new("UICorner", f).CornerRadius = UDim.new(1, 0)
    end

    local function line(text, y, tint)
        local function mk(c, z)
            local l = Instance.new("TextLabel")
            l.AnchorPoint = Vector2.new(0.5, 0.5)
            l.Position = UDim2.new(0.5, 0, 0.5, y)
            l.Size = UDim2.new(1.4, 0, 0, TSIZE + 20)
            l.BackgroundTransparency = 1
            l.Font = TFONT
            l.TextSize = TSIZE
            l.TextColor3 = c
            l.TextTransparency = 1
            l.Text = text
            l.Rotation = TILT
            l.ZIndex = z
            l.Parent = shaker
            return l
        end
        local L = {c = mk(tint, 10), p = mk(WHITE, 11), m = mk(WHITE, 12), y = y}
        -- silver brush look: white on top fading to grey, neon outline in the line color
        local ug = Instance.new("UIGradient")
        ug.Color = ColorSequence.new(SILVER_TOP, SILVER_BOT)
        ug.Rotation = 90
        ug.Parent = L.m
        local st = Instance.new("UIStroke")
        st.Color = tint
        st.Thickness = 2
        st.Transparency = 1
        st.Parent = L.m
        table.insert(textLines, L)
        table.insert(strokes, st)

        local w = measure(text, TSIZE)
        -- ink spatter around the word
        for i = 1, 26 do
            local s = math.random(2, 5)
            local d = Instance.new("Frame")
            d.AnchorPoint = Vector2.new(0.5, 0.5)
            d.Position = UDim2.new(0.5, (math.random() - 0.5) * (w + TSIZE * 0.8), 0.5, y + (math.random() - 0.5) * TSIZE * 1.5)
            d.Size = UDim2.fromOffset(s, s)
            d.BackgroundColor3 = WHITE
            d.BorderSizePixel = 0
            d.BackgroundTransparency = 1
            d.ZIndex = 9
            round(d)
            d.Parent = shaker
            addDeco(d, 0.45 + math.random() * 0.3)
        end
        -- paint drips that run down from the letters
        for i = 1, 7 do
            local th = math.random(3, 5)
            local f = Instance.new("Frame")
            f.AnchorPoint = Vector2.new(0.5, 0)
            f.Position = UDim2.new(0.5, ((i - 0.5) / 7 - 0.5) * w * 0.9 + math.random(-8, 8), 0.5, y + TSIZE * 0.3)
            f.Size = UDim2.fromOffset(th, 2)
            f.BackgroundColor3 = WHITE
            f.BorderSizePixel = 0
            f.BackgroundTransparency = 1
            f.ZIndex = 12
            round(f)
            f.Parent = shaker
            addDeco(f, 0.1)
            table.insert(drips, {f = f, h = math.random(14, 46), w = th})
        end
    end
    local DY = math.floor(VS.Y * 0.30) -- distance of each word from the center, stays between the black bars
    line("SYNPASE", -DY, CYAN)
    line("CELESTIAL", DY, PURPLE)

    -- crown above CELESTIAL (drawn with frames)
    local function seg(parent, x1, y1, x2, y2, th)
        local dx, dy = x2 - x1, y2 - y1
        local f = Instance.new("Frame")
        f.AnchorPoint = Vector2.new(0.5, 0.5)
        f.Position = UDim2.fromOffset((x1 + x2) / 2, (y1 + y2) / 2)
        f.Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy) + th, th)
        f.Rotation = math.deg(math.atan2(dy, dx))
        f.BackgroundColor3 = WHITE
        f.BorderSizePixel = 0
        f.BackgroundTransparency = 1
        f.ZIndex = 13
        round(f)
        f.Parent = parent
        addDeco(f, 0.05)
    end
    do
        local cw, ch = math.floor(TSIZE * 0.62), math.floor(TSIZE * 0.4)
        local th = math.max(2, math.floor(TSIZE * 0.035))
        local h = Instance.new("Frame")
        h.AnchorPoint = Vector2.new(0.5, 0.5)
        h.Position = UDim2.new(0.5, 0, 0.5, DY - math.floor(TSIZE * 0.42) - math.floor(ch / 2) - 6)
        h.Size = UDim2.fromOffset(cw, ch)
        h.BackgroundTransparency = 1
        h.ZIndex = 13
        h.Parent = shaker
        local pts = {{0, 0.15}, {0.25, 0.6}, {0.5, 0}, {0.75, 0.6}, {1, 0.15}}
        for i = 1, #pts - 1 do
            seg(h, pts[i][1] * cw, pts[i][2] * ch, pts[i + 1][1] * cw, pts[i + 1][2] * ch, th)
        end
        seg(h, 0, 0.15 * ch, 0, 0.74 * ch, th)
        seg(h, cw, 0.15 * ch, cw, 0.74 * ch, th)
        local base = Instance.new("Frame")
        base.Position = UDim2.fromOffset(0, math.floor(0.74 * ch))
        base.Size = UDim2.fromOffset(cw, math.ceil(0.26 * ch))
        base.BackgroundColor3 = WHITE
        base.BorderSizePixel = 0
        base.BackgroundTransparency = 1
        base.ZIndex = 13
        Instance.new("UICorner", base).CornerRadius = UDim.new(0, 3)
        base.Parent = h
        addDeco(base, 0.05)
        for _, p in ipairs({pts[1], pts[3], pts[5]}) do
            local j = Instance.new("Frame")
            j.AnchorPoint = Vector2.new(0.5, 0.5)
            j.Position = UDim2.fromOffset(p[1] * cw, p[2] * ch)
            j.Size = UDim2.fromOffset(th * 3, th * 3)
            j.BackgroundColor3 = WHITE
            j.BorderSizePixel = 0
            j.BackgroundTransparency = 1
            j.ZIndex = 14
            round(j)
            j.Parent = h
            addDeco(j, 0.05)
        end
    end

    -- X emblem: two crossed blades, cyan + purple glitch layers under a white core
    local xBox = Instance.new("Frame")
    xBox.AnchorPoint = Vector2.new(0.5, 0.5)
    xBox.Position = UDim2.fromScale(0.5, 0.5)
    xBox.Size = UDim2.fromScale(0.24, 0.32)
    xBox.BackgroundTransparency = 1
    xBox.ZIndex = 12
    xBox.Parent = shaker
    Instance.new("UIAspectRatioConstraint", xBox).AspectRatio = 1
    local xScale = Instance.new("UIScale")
    xScale.Scale = 0
    xScale.Parent = xBox

    local function xlayer(color, z)
    	local f = Instance.new("Frame")
    	f.AnchorPoint = Vector2.new(0.5, 0.5)
    	f.Position = UDim2.fromScale(0.5, 0.5)
    	f.Size = UDim2.fromScale(1, 1)
    	f.BackgroundTransparency = 1
    	f.ZIndex = z
    	f.Parent = xBox
    	local bars = {}
    	for _, r in ipairs({45, -45}) do
    		local b = Instance.new("Frame")
    		b.AnchorPoint = Vector2.new(0.5, 0.5)
    		b.Position = UDim2.fromScale(0.5, 0.5)
    		b.Size = UDim2.fromScale(1.2, 0.14)
    		b.Rotation = r
    		b.BackgroundColor3 = color
    		b.BackgroundTransparency = 1
    		b.BorderSizePixel = 0
    		b.ZIndex = z
    		if z == 12 then
    			local ug = Instance.new("UIGradient")
    			ug.Color = ColorSequence.new({
    				ColorSequenceKeypoint.new(0, CYAN),
    				ColorSequenceKeypoint.new(0.5, Color3.fromRGB(95, 140, 255)),
    				ColorSequenceKeypoint.new(1, PURPLE),
    			})
    			ug.Parent = b
    		end
    		b.Parent = f
    		table.insert(bars, b)
    	end
    	return f, bars
    end
    local xc, xcb = xlayer(CYAN, 10)
    local xp, xpb = xlayer(PURPLE, 11)
    local xm, xmb = xlayer(WHITE, 12)
    local function setX(m, c, p)
    	for i = 1, 2 do
    		xmb[i].BackgroundTransparency = m
    		xcb[i].BackgroundTransparency = c
    		xpb[i].BackgroundTransparency = p
    	end
    end
    local function setText(m, c, p)
    	for _, L in ipairs(textLines) do
    		L.m.TextTransparency, L.c.TextTransparency, L.p.TextTransparency = m, c, p
    	end
    	for _, d in ipairs(deco) do
    		d.f.BackgroundTransparency = 1 - (1 - d.base) * (1 - m)
    	end
    end

    local sv = Instance.new("NumberValue") -- title scale
    sv.Value = 1.15
    local xsv = Instance.new("NumberValue") -- X scale
    xsv.Value = 3
    local xrv = Instance.new("NumberValue") -- X rotation
    xrv.Value = 180

    ------------------------------------------------------------------
    -- EFFECTS
    ------------------------------------------------------------------
    local function flash(color, a)
    	local f = Instance.new("Frame")
    	f.Size = UDim2.fromScale(1, 1)
    	f.BackgroundColor3 = color
    	f.BackgroundTransparency = a
    	f.BorderSizePixel = 0
    	f.ZIndex = 20
    	f.Parent = root
    	TS:Create(f, TweenInfo.new(0.35), {BackgroundTransparency = 1}):Play()
    	Debris:AddItem(f, 0.4)
    end

    local function ring(color, delay)
    	task.delay(delay, function()
    		local r = Instance.new("Frame")
    		r.AnchorPoint = Vector2.new(0.5, 0.5)
    		r.Position = UDim2.fromScale(0.5, 0.5)
    		r.Size = UDim2.fromOffset(0, 0)
    		r.BackgroundTransparency = 1
    		r.ZIndex = 8
    		Instance.new("UICorner", r).CornerRadius = UDim.new(1, 0)
    		local st = Instance.new("UIStroke", r)
    		st.Color = color
    		st.Thickness = 6
    		r.Parent = root
    		TS:Create(r, TweenInfo.new(1.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(2800, 2800)}):Play()
    		TS:Create(st, TweenInfo.new(1.3), {Transparency = 1}):Play()
    		Debris:AddItem(r, 1.5)
    	end)
    end

    local function sparks()
    	local cols = {CYAN, PURPLE, WHITE}
    	for i = 1, 90 do
    		local p = Instance.new("Frame")
    		local a = math.random() * math.pi * 2
    		local d = math.random(300, 1400)
    		local t = 0.9 + math.random()
    		p.AnchorPoint = Vector2.new(0.5, 0.5)
    		p.Position = UDim2.fromScale(0.5, 0.5)
    		p.Size = UDim2.fromOffset(math.random(20, 50), 2)
    		p.Rotation = math.deg(a)
    		p.BackgroundColor3 = cols[(i % 3) + 1]
    		p.BorderSizePixel = 0
    		p.ZIndex = 9
    		p.Parent = root
    		TS:Create(p, TweenInfo.new(t, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
    			Position = UDim2.new(0.5, math.cos(a) * d, 0.5, math.sin(a) * d),
    			BackgroundTransparency = 1,
    		}):Play()
    		Debris:AddItem(p, t + 0.1)
    	end
    end

    ------------------------------------------------------------------
    -- TIMELINE
    ------------------------------------------------------------------
    snd:Play()
    local t0 = os.clock()
    local did1, did2, didEnd = false, false, false
    local glowBase = 0.8

    -- hide the hub's mobile buttons (CELESTIALMobileButtons) while the intro plays, restore after
    local hiddenGuis = {}
    local function hideHubButtons()
    	local containers = {}
    	pcall(function() if gethui then table.insert(containers, gethui()) end end)
    	pcall(function() table.insert(containers, game:GetService("CoreGui")) end)
    	pcall(function() table.insert(containers, Players.LocalPlayer.PlayerGui) end)
    	for _, c in ipairs(containers) do
    		pcall(function()
    			local g = c:FindFirstChild("CelestialMobileButtons") or c:FindFirstChild("CELESTIALMobileButtons")
    			if g and g:IsA("ScreenGui") and g.Enabled and not table.find(hiddenGuis, g) then
    				g.Enabled = false
    				table.insert(hiddenGuis, g)
    			end
    		end)
    	end
    end
    local function restoreHubButtons()
    	for _, g in ipairs(hiddenGuis) do
    		pcall(function() g.Enabled = true end)
    	end
    	hiddenGuis = {}
    end
    hideHubButtons()
    task.spawn(function()
    	while alive do
    		hideHubButtons()
    		task.wait(0.25)
    	end
    end)

    local skipAt = nil
    local conn, inputConn
    local function cleanup()
    	if didEnd then return end
    	didEnd = true
    	alive = false
    	restoreHubButtons()
    	if conn then conn:Disconnect() end
    	if inputConn then inputConn:Disconnect() end
    	snd:Stop()
    	snd:Destroy()
    	sv:Destroy()
    	xsv:Destroy()
    	xrv:Destroy()
    	gui:Destroy()
    	pcall(function() delfile("synpase_intro_song.wav") end)
    end
    local function requestSkip()
    	if skipAt then return end
    	skipAt = os.clock() - t0
    	TS:Create(skipBtn, TweenInfo.new(0.3), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
    	TS:Create(skipStroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
    	TS:Create(hint, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
    end
    skipBtn.Activated:Connect(requestSkip)
    local lastTap = -1
    inputConn = UIS.InputBegan:Connect(function(input)
    	local ty = input.UserInputType
    	if ty == Enum.UserInputType.Touch or ty == Enum.UserInputType.MouseButton1 then
    		local now = os.clock()
    		if now - lastTap <= 0.5 then requestSkip() end
    		lastTap = now
    	elseif ty == Enum.UserInputType.Keyboard then
    		local kc = input.KeyCode
    		if kc == Enum.KeyCode.Space or kc == Enum.KeyCode.Return or kc == Enum.KeyCode.Escape then
    			requestSkip()
    		end
    	end
    end)
    task.delay(DURATION + 0.3, cleanup) -- hard stop no matter what
    conn = RS.Heartbeat:Connect(function()
    	local t = os.clock() - t0

    	if t >= DROP1 and not did1 then
    		did1 = true
    		colOp = 0.1
    		glowBase = 0.7
    		flash(CYAN, 0.4)
    		ring(CYAN, 0)
    		for _, st in ipairs(strokes) do st.Transparency = 0.2 end
    		task.delay(0.4, function()
    			for _, d in ipairs(drips) do
    				TS:Create(d.f, TweenInfo.new(1.2 + math.random(), Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = UDim2.fromOffset(d.w, d.h)}):Play()
    			end
    		end)
    		TS:Create(sv, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Value = 1}):Play()
    		task.delay(0.15, function()
    			TS:Create(xsv, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Value = 1}):Play()
    			TS:Create(xrv, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Value = 0}):Play()
    		end)
    		for _, l in ipairs(barLines) do
    			TS:Create(l, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 2)}):Play()
    		end
    	end

    	if t >= DROP2 and not did2 then
    		did2 = true
    		colOp = 0.13
    		glowBase = 0.55
    		flash(WHITE, 0.1)
    		task.delay(0.1, function() flash(PURPLE, 0.3) end)
    		task.delay(0.2, function() flash(CYAN, 0.3) end)
    		ring(PURPLE, 0)
    		ring(CYAN, 0.12)
    		sparks()
    		TS:Create(xrv, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Value = 90}):Play()
    	end

    	-- beat kick (hits on every beat after the first drop)
    	local k = 0
    	if t >= DROP1 and t < DURATION - 0.7 then
    		k = math.exp(-((t - DROP1) % BEAT) * 7)
    	end
    	local g = k * 7
    	local after = (t > DROP2 and t < DROP2 + 1.2) and (1 - (t - DROP2) / 1.2) or 0
    	g += after * 16

    	-- reveal: text glitch-flickers in, then the X slams in
    	if t < DROP1 then
    		setText(1, 1, 1)
    		setX(1, 1, 1)
    	elseif t < DROP1 + 0.35 then
    		local on = math.random() < 0.5
    		setText(on and 0 or 1, on and 0.3 or 1, on and 0.3 or 1)
    		setX(1, 1, 1)
    	else
    		setText(0, 0.3, 0.3)
    		if t < DROP1 + 0.55 then
    			local on = math.random() < 0.5
    			setX(on and 0 or 1, on and 0.3 or 1, on and 0.3 or 1)
    		else
    			setX(0, 0.3, 0.3)
    		end
    	end

    	for _, L in ipairs(textLines) do
    		L.c.Position = UDim2.new(0.5, -g, 0.5, L.y)
    		L.p.Position = UDim2.new(0.5, g, 0.5, L.y)
    	end
    	xc.Position = UDim2.new(0.5, -g, 0.5, 0)
    	xp.Position = UDim2.new(0.5, g, 0.5, 0)
    	xBox.Rotation = xrv.Value
    	xScale.Scale = t < DROP1 and 0 or xsv.Value * (1 + k * 0.1)
    	scaleObj.Scale = (t < DROP1 and 1.15 or sv.Value) * (1 + k * 0.03 + (did2 and 0.02 or 0))

    	-- screen shake + neon pulse
    	local sk = k * 6 + after * 18
    	root.Position = UDim2.new(0.5, (math.random() * 2 - 1) * sk, 0.5, (math.random() * 2 - 1) * sk)
    	glowL.BackgroundTransparency = glowBase - k * 0.25
    	glowR.BackgroundTransparency = glowBase - k * 0.25

    	-- outro fade (or fast fade if skipped with a double tap)
    	if skipAt then
    		local q = (t - skipAt) / 0.3
    		root.GroupTransparency = math.clamp(q, 0, 1)
    		snd.Volume = math.clamp(1 - q, 0, 1)
    		if q >= 1 then cleanup() end
    	elseif t >= DURATION - 1 then
    		local f = math.clamp(t - (DURATION - 1), 0, 1)
    		root.GroupTransparency = f
    		snd.Volume = math.clamp(DURATION - t, 0, 1)
    		skipBtn.BackgroundTransparency = math.max(0.15, f)
    		skipBtn.TextTransparency = f
    		skipStroke.Transparency = math.max(0.3, f)
    		hint.TextTransparency = math.max(0.45, f)
    	end

    	if t >= DURATION then cleanup() end
    end)
end

task.spawn(function()
    pcall(playCelestialIntro)
end)


UserInputService.InputBegan:Connect(function(input, gp)
    if keybindCaptureActive then return end
    if input.UserInputType ~= Enum.UserInputType.Keyboard then return end
    if tostring(Config.HideUIKey or "") ~= "" and input.KeyCode.Name:upper() == tostring(Config.HideUIKey):upper() then
        if Config.HideUI or uiMinimized then
            restoreFromMini()
        else
            showMiniOnly()
            saveConfig()
        end
    end
end)

if Config.BatAimbot and not Config.SafeMode then
    startBatAimbot()
end


function celestialMakeGuiClickable(obj)
    if not obj or not obj:IsA("GuiObject") then return end
    if obj:IsA("GuiButton") then
        obj.Active = true
        obj.Selectable = true
    elseif obj:IsA("TextBox") then
        obj.Active = true
        obj.Selectable = true
    elseif obj.Name == "UIBackground" or obj.Name == "UIBackgroundDim" then
        obj.Active = false
        obj.Selectable = false
    end
end
for _, guiObject in ipairs(screenGui:GetDescendants()) do celestialMakeGuiClickable(guiObject) end
screenGui.DescendantAdded:Connect(function(guiObject)
    task.defer(function() pcall(celestialMakeGuiClickable, guiObject) end)
end)
