getgenv().DS = "discord.gg/f8WPPgsfDX"

if getgenv().averlik_loaded == true then
    while task.wait(99999999) do end
end

local Luarmor = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
print("Luarmor: ",Luarmor)

if not isfolder("Averlik Hub") then
    makefolder("Averlik Hub")
end
writefile("Averlik Hub/Discord.txt",getgenv().DS)

local Config = {
    Id = "AverlikKeyGui",
    Title = "Averlik Hub",
    Subtitle = "Key system",
    Footer = getgenv().DS,
    GetKey = nil, --
    OnVerified = nil,
    OnFooterClick = nil,
}

local Games = {
    ["10200395747"] = {id = "c6ccaebf880f5614ee1121cfb0e10740", keyless = true}, -- gag2
    ["6035872082"] = {id = "8f607144fa2a449f600b0cf7a0852597",keyless = true}, -- rivals
    ["66654135"] = {id = "6223a21ff3757d564b1911e94270a98e",keyless = true}, -- mm2
    ["10144280947"] = {id = "c2bda132c0248cfe3f90b98e16d5975e",keyless = true}, -- monke
    ["9855761734"] = {id = "78d777167283167b334564a8fa57b490",keyless = true}, -- sandieo
    ["9584852943"] = {id = "7124692d8300ccbd8eb76179ad91f4a7",keyless = true}, --keyboard
}

local Assets = {
    ["logo.jpg"] = "nil",
}

local Lucide = loadstring(game:HttpGet("https://gitlab.com/upio/lucide-roblox-direct/-/raw/main/source.lua"))()
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")


local function trim(value)
    return string.match(value, "^%s*(.-)%s*$") or ""
end

local function loadAssets()
    local ok = pcall(function()
        if not isfolder("Averlik Hub") then
            makefolder("Averlik Hub")
        end
        if not isfolder("Averlik Hub/Assets") then
            makefolder("Averlik Hub/Assets")
        end

        for name in pairs(Assets) do
            local path = "Averlik Hub/Assets/" .. name
            if not isfile(path) then
                writefile(path, game:HttpGet("https://github.com/Tarmaster/Library/blob/main/assets/" .. name .. "?raw=true"))
                task.wait(0.05)
            end
            Assets[name] = getcustomasset(path)
        end
    end)

    if not ok then
        warn("[Averlik Key GUI] Could not load local GUI assets.")
    end
end

local function JoinDS()
    local ds = getgenv().DS
    local HS = game:GetService("HttpService")
    local code = tostring(ds):match("discord%.gg/([%w]+)")
        or tostring(ds):match("discord%.com/invite/([%w]+)")
        or tostring(ds)
    if not code or code == "" then
        return
    end

    local copy = setclipboard or toclipboard
    if copy then
        pcall(copy, "https://discord.gg/" .. code)
    end

    local req = request or (syn and syn.request) or (http and http.request)
    if req then
        pcall(req, {
            Url = "http://127.0.0.1:6463/rpc?v=1",
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["Origin"] = "https://discord.com",
            },
            Body = HS:JSONEncode({
                cmd = "INVITE_BROWSER",
                args = { code = code },
                nonce = HS:GenerateGUID(false),
            }),
            Timeout = 2,
        })
    end
end


local closeui = function() return end
local setResult = function() return end
local submitting = false

local function submitKey(key)
    if submitting then
        return
    end

    local enteredKey = trim(key)
    if enteredKey == "" then
        setResult("Enter a key before submitting.", "error")
        return
    end

    submitting = true
    setResult("Checking key...", "info")

    task.wait(0.5)

    task.spawn(function()
        print('Submit')
        local Game = Games[tostring(game.GameId)]

        if Game then
            Luarmor.script_id = Game["id"]
            if Game["keyless"] then
                if enteredKey == "AVERLIK_123" then
                    setResult("Success. The script is loading.", "success")
                    writefile("Averlik Hub/SavedKey.txt",enteredKey)
                    task.delay(1.5,closeui)
                    getgenv().averlik_loaded = true
                    Luarmor.load_script()
                    submitting = false
                    return
                else
                    setResult("Error. The provided key is incorrect / it does not exist.", "error")
                    submitting = false
                    return
                end
            else
                local status = Luarmor.check_key(enteredKey)

                if status.code == "KEY_VALID" then
                    setResult("Success. The script is loading.", "success")
                    writefile("Averlik Hub/SavedKey.txt",enteredKey)
                    script_key = enteredKey
                    task.delay(1.5,closeui)
                    getgenv().averlik_loaded = true
                    Luarmor.load_script()
                    submitting = false
                    return
                else
                    setResult("Error. "..status.message.."", "error")
                    submitting = false
                    return
                end

            end
        else
            setResult("Error. Not supported game.", "error")
        end
    end)
end

Config.GetKey = JoinDS
Config.OnFooterClick = JoinDS

loadAssets()

local Theme = {
    Background = Color3.fromRGB(13, 13, 14),
    Sidebar = Color3.fromRGB(16, 16, 17),
    Header = Color3.fromRGB(15, 15, 16),
    Surface = Color3.fromRGB(29, 29, 30),
    SurfaceHover = Color3.fromRGB(37, 37, 38),
    SurfacePressed = Color3.fromRGB(48, 48, 49),
    Border = Color3.fromRGB(56, 56, 58),
    Text = Color3.fromRGB(241, 241, 242),
    MutedText = Color3.fromRGB(151, 151, 154),
    SubtleText = Color3.fromRGB(105, 105, 108),
    Accent = Color3.fromRGB(112, 210, 76),
    Shadow = Color3.fromRGB(0, 0, 0),
    SidebarTop = Color3.fromRGB(10, 10, 11),
    SidebarBottom = Color3.fromRGB(10, 10, 11),
    CloseButton = Color3.fromRGB(25, 25, 26),
    Error = Color3.fromRGB(241, 112, 112),
}

local function new(className, properties)
    local object = Instance.new(className)
    for property, value in pairs(properties or {}) do
        object[property] = value
    end
    return object
end

local function corner(parent, radius)
    return new("UICorner", {
        CornerRadius = UDim.new(0, radius or 7),
        Parent = parent,
    })
end

local function stroke(parent, color, thickness, transparency)
    return new("UIStroke", {
        Color = color,
        Thickness = thickness or 1,
        Transparency = transparency or 0,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
        Parent = parent,
    })
end

local function uiShadow(parent, color, transparency, blurRadius, offset, spread)
    local ok, shadow = pcall(Instance.new, "UIShadow")
    if not ok then
        return nil
    end
    shadow.Color = color
    shadow.Transparency = transparency
    shadow.BlurRadius = UDim.new(0, blurRadius)
    shadow.Offset = offset or UDim2.new()
    shadow.Spread = spread or UDim2.new()
    shadow.ZIndex = -1
    shadow.Parent = parent
    return shadow
end

local function padding(parent, left, right, top, bottom)
    return new("UIPadding", {
        PaddingLeft = UDim.new(0, left or 0),
        PaddingRight = UDim.new(0, right or left or 0),
        PaddingTop = UDim.new(0, top or 0),
        PaddingBottom = UDim.new(0, bottom or top or 0),
        Parent = parent,
    })
end

local function text(parent, properties)
    properties = properties or {}
    properties.BackgroundTransparency = 1
    properties.BorderSizePixel = 0
    properties.Font = properties.Font or Enum.Font.Gotham
    properties.TextColor3 = properties.TextColor3 or Theme.Text
    properties.TextSize = properties.TextSize or 12
    properties.TextXAlignment = properties.TextXAlignment or Enum.TextXAlignment.Left
    properties.TextYAlignment = properties.TextYAlignment or Enum.TextYAlignment.Center
    properties.Parent = parent
    return new("TextLabel", properties)
end

local function button(parent, properties)
    properties = properties or {}
    properties.AutoButtonColor = false
    properties.BorderSizePixel = 0
    properties.Font = properties.Font or Enum.Font.Gotham
    properties.TextColor3 = properties.TextColor3 or Theme.Text
    properties.TextSize = properties.TextSize or 12
    properties.TextXAlignment = properties.TextXAlignment or Enum.TextXAlignment.Center
    properties.TextYAlignment = properties.TextYAlignment or Enum.TextYAlignment.Center
    properties.Parent = parent
    return new("TextButton", properties)
end

local function tween(instance, duration, properties, style, direction)
    local animation = TweenService:Create(
        instance,
        TweenInfo.new(duration or 0.12, style or Enum.EasingStyle.Quint, direction or Enum.EasingDirection.Out),
        properties
    )
    animation:Play()
    return animation
end

local function isPointerInput(input)
    return input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch
end

local function resolveGuiParent()
    if type(gethui) == "function" then
        local ok, hiddenGui = pcall(gethui)
        if ok and typeof(hiddenGui) == "Instance" then
            return hiddenGui
        end
    end

    local player = Players.LocalPlayer
    if player then
        return player:WaitForChild("PlayerGui")
    end

    local ok, coreGui = pcall(function()
        return game:GetService("CoreGui")
    end)
    if ok then
        return coreGui
    end
end

local function formatSessionDuration(seconds)
    seconds = math.max(0, math.floor(seconds))
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor(seconds % 3600 / 60)
    local remainingSeconds = seconds % 60

    if hours > 0 then
        return string.format("%d:%02d:%02d", hours, minutes, remainingSeconds)
    end
    return string.format("%d:%02d", minutes, remainingSeconds)
end

local parent = resolveGuiParent()
assert(parent, "Averlik key GUI could not find a Gui parent")

local existing = parent:FindFirstChild(Config.Id)
if existing then
    existing:Destroy()
end

local screenGui = new("ScreenGui", {
    Name = Config.Id,
    DisplayOrder = 999,
    IgnoreGuiInset = true,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = parent,
})

local runtimeConnections = {}
local destroyed = false
local function trackConnection(connection)
    table.insert(runtimeConnections, connection)
    return connection
end

local function destroyGui()
    if destroyed then
        return
    end
    destroyed = true
    for _, connection in ipairs(runtimeConnections) do
        connection:Disconnect()
    end
    table.clear(runtimeConnections)
    if screenGui.Parent then
        screenGui:Destroy()
    end
end

local window = new("CanvasGroup", {
    Name = "KeyWindow",
    AnchorPoint = Vector2.new(0.5, 0.5),
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    GroupTransparency = 1,
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(535, 322),
    Parent = screenGui,
})
corner(window, 18)
uiShadow(window, Theme.Shadow, 0.72, 14, UDim2.fromOffset(0, 4), UDim2.fromOffset(2, 2))

local sidebar = new("Frame", {
    Name = "Sidebar",
    BackgroundColor3 = Theme.Sidebar,
    BorderSizePixel = 0,
    Size = UDim2.fromOffset(151, 322),
    ZIndex = 2,
    Parent = window,
})
new("Frame", {
    BackgroundColor3 = Theme.Border,
    BackgroundTransparency = 0.45,
    BorderSizePixel = 0,
    Position = UDim2.new(1, -1, 0, 0),
    Size = UDim2.new(0, 1, 1, 0),
    Parent = sidebar,
})

local brand = new("Frame", {
    Name = "Brand",
    BackgroundColor3 = Theme.SidebarTop,
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(10, 10),
    Size = UDim2.new(1, -20, 0, 43),
    Parent = sidebar,
})
corner(brand, 12)

local logo = new("ImageLabel", {
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Image = Assets["logo.jpg"],
    Position = UDim2.fromOffset(7, 7),
    Size = UDim2.fromOffset(29, 29),
    Parent = brand,
})
corner(logo, 8)
text(brand, {
    Text = Config.Title,
    Font = Enum.Font.GothamBold,
    TextSize = 11,
    TextTruncate = Enum.TextTruncate.AtEnd,
    Size = UDim2.new(1, -49, 0, 19),
    Position = UDim2.fromOffset(43, 5),
})
text(brand, {
    Text = Config.Subtitle,
    TextColor3 = Theme.MutedText,
    TextSize = 11,
    TextTruncate = Enum.TextTruncate.AtEnd,
    Size = UDim2.new(1, -49, 0, 14),
    Position = UDim2.fromOffset(43, 22),
})


local footer = new("Frame", {
    BackgroundColor3 = Theme.SidebarBottom,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 10, 1, -55),
    Size = UDim2.new(1, -20, 0, 46),
    Parent = sidebar,
})
corner(footer, 12)
local footerTitle = text(footer, {
    Text = Config.Footer,
    Font = Enum.Font.GothamBold,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Center,
    Size = UDim2.new(1, -16, 0, 22),
    Position = UDim2.fromOffset(8, 4),
})
local footerStats = text(footer, {
    Name = "SessionStats",
    Text = "0:00  •  0 fps",
    Font = Enum.Font.GothamMedium,
    TextColor3 = Theme.MutedText,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Center,
    Size = UDim2.new(1, -16, 0, 15),
    Position = UDim2.fromOffset(8, 24),
})
local footerButton = button(footer, {
    Name = "FooterButton",
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    Text = "",
    ZIndex = 2,
})

local main = new("Frame", {
    Name = "Main",
    BackgroundColor3 = Theme.Background,
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(151, 0),
    Size = UDim2.new(1, -151, 1, 0),
    ZIndex = 2,
    Parent = window,
})
local header = new("Frame", {
    Name = "Header",
    BackgroundColor3 = Theme.Header,
    BorderSizePixel = 0,
    Size = UDim2.new(1, 0, 0, 62),
    Parent = main,
})
new("Frame", {
    BackgroundColor3 = Theme.Border,
    BackgroundTransparency = 0.48,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 0, 1, -1),
    Size = UDim2.new(1, 0, 0, 1),
    Parent = header,
})
text(header, {
    Text = "Key verification",
    Font = Enum.Font.GothamBold,
    TextSize = 15,
    Size = UDim2.new(1, -60, 0, 23),
    Position = UDim2.fromOffset(14, 11),
})
text(header, {
    Text = "Submit your key to unlock the script",
    TextColor3 = Theme.MutedText,
    TextSize = 11,
    TextTruncate = Enum.TextTruncate.AtEnd,
    Size = UDim2.new(1, -60, 0, 15),
    Position = UDim2.fromOffset(14, 34),
})

local closeButton = button(header, {
    Name = "Close",
    BackgroundColor3 = Theme.CloseButton,
    AnchorPoint = Vector2.new(1, 0.5),
    Position = UDim2.new(1, -10, 0.5, 0),
    Size = UDim2.fromOffset(35, 35),
    Text = "×",
    TextColor3 = Theme.Text,
    TextSize = 27,
    Parent = header,
})
corner(closeButton, 10)
closeButton.Text = ""
local closeIconData = nil
if Lucide and Lucide.GetAsset then
    local ok, iconData = pcall(Lucide.GetAsset, "x")
    if ok then
        closeIconData = iconData
    end
end
local closeIcon = nil
if type(closeIconData) == "table" and type(closeIconData.Url) == "string" then
    closeIcon = new("ImageLabel", {
        Name = "CloseIcon",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        Image = closeIconData.Url,
        ImageRectOffset = closeIconData.ImageRectOffset,
        ImageRectSize = closeIconData.ImageRectSize,
        ImageColor3 = Theme.Text,
        Position = UDim2.fromScale(0.5, 0.5),
        ScaleType = Enum.ScaleType.Fit,
        Size = UDim2.fromOffset(18, 18),
        ZIndex = 4,
        Parent = closeButton,
    })
    corner(closeIcon, 14)
    uiShadow(closeIcon, Theme.Text, 0.92, 11, UDim2.new(), UDim2.fromOffset(0, 0))
else
    closeButton.Text = "×"
    closeButton.TextColor3 = Theme.Text
    closeButton.TextSize = 27
end

local content = new("Frame", {
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(11, 72),
    Size = UDim2.new(1, -22, 1, -83),
    Parent = main,
})

local sectionHeading = text(content, {
    Text = "ACCESS KEY",
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.Text,
    TextSize = 12,
    Size = UDim2.fromOffset(76, 24),
})
local headingDivider = new("Frame", {
    BackgroundColor3 = Theme.Border,
    BackgroundTransparency = 0.22,
    BorderSizePixel = 0,
    Position = UDim2.new(0, 84, 0, 11),
    Size = UDim2.new(1, -84, 0, 1),
    Parent = content,
})

local keyBox = new("TextBox", {
    Name = "KeyInput",
    BackgroundColor3 = Color3.fromRGB(19, 19, 20),
    BorderSizePixel = 0,
    ClearTextOnFocus = false,
    Font = Enum.Font.Gotham,
    PlaceholderColor3 = Theme.SubtleText,
    PlaceholderText = "Enter your key...",
    Size = UDim2.new(1, 0, 0, 39),
    Position = UDim2.fromOffset(0, 29),
    Text = "",
    TextColor3 = Theme.Text,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = content,
})
corner(keyBox, 10)
local keyBoxStroke = stroke(keyBox, Theme.Border, 1, 0.48)
local keyBoxGlow = uiShadow(keyBox, Theme.Accent, 0.42, 6, UDim2.new(), UDim2.fromOffset(1, 1))
if keyBoxGlow then
    keyBoxGlow.Enabled = false
end
padding(keyBox, 10, 10)

local submitButton = button(content, {
    Name = "SubmitKey",
    BackgroundColor3 = Theme.Accent,
    Position = UDim2.fromOffset(0, 80),
    Size = UDim2.new(0.58, -4, 0, 31),
    Text = "Submit key",
    Font = Enum.Font.GothamBold,
    TextColor3 = Color3.fromRGB(10, 10, 10),
    TextSize = 12,
    Parent = content,
})
corner(submitButton, 10)
local submitShadow = uiShadow(submitButton, Theme.Accent, 0.46, 7, UDim2.new(), UDim2.fromOffset(1, 1))

local getKeyButton = button(content, {
    Name = "GetKey",
    BackgroundColor3 = Theme.SurfacePressed,
    Position = UDim2.new(0.58, 4, 0, 80),
    Size = UDim2.new(0.42, -4, 0, 31),
    Text = "Get key",
    Font = Enum.Font.GothamBold,
    TextColor3 = Theme.Text,
    TextSize = 12,
    Parent = content,
})
corner(getKeyButton, 10)
uiShadow(getKeyButton, Theme.SurfacePressed, 0.56, 7, UDim2.new(), UDim2.fromOffset(1, 1))

local resultFrame = new("Frame", {
    Name = "Result",
    BackgroundColor3 = Theme.Surface,
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(0, 124),
    Size = UDim2.new(1, 0, 0, 40),
    Parent = content,
})
corner(resultFrame, 10)
local resultStroke = stroke(resultFrame, Theme.Border, 1, 0.58)
-- Mirrors the textbox focus glow: normal information stays neutral, while
-- validation results receive a matching green or red outline glow.
local resultGlow = uiShadow(resultFrame, Theme.MutedText, 0.42, 6, UDim2.new(), UDim2.fromOffset(1, 1))
if resultGlow then
    resultGlow.Enabled = false
end
local resultDot = new("Frame", {
    BackgroundColor3 = Theme.MutedText,
    BorderSizePixel = 0,
    Position = UDim2.fromOffset(11, 16),
    Size = UDim2.fromOffset(7, 7),
    Parent = resultFrame,
})
corner(resultDot, 4)
local resultLabel = text(resultFrame, {
    Name = "ResultLabel",
    Text = "Enter your key and press Submit key.",
    Font = Enum.Font.GothamMedium,
    TextColor3 = Theme.MutedText,
    TextSize = 12,
    TextTruncate = Enum.TextTruncate.AtEnd,
    Size = UDim2.new(1, -39, 1, 0),
    Position = UDim2.fromOffset(28, 0),
})

setResult = function(message, kind)
    local color = Theme.MutedText
    if kind == "success" then
        color = Theme.Accent
    elseif kind == "error" then
        color = Theme.Error
    end
    resultLabel.Text = tostring(message or "")
    tween(resultLabel, 0.12, { TextColor3 = color })
    tween(resultDot, 0.12, { BackgroundColor3 = color })
    tween(resultStroke, 0.12, { Color = color, Transparency = kind == "info" and 0.58 or 0.30 })
    if resultGlow then
        resultGlow.Color = color
        resultGlow.Enabled = kind == "success" or kind == "error"
    end
end

do
    local sessionStartedAt = os.clock()
    local displayedSessionSecond = -1
    local fpsSampleStartedAt = sessionStartedAt
    local frameCount = 0

    trackConnection(RunService.RenderStepped:Connect(function()
        frameCount = frameCount + 1
    end))
    trackConnection(RunService.Heartbeat:Connect(function()
        local now = os.clock()
        local sessionSeconds = math.floor(now - sessionStartedAt)
        if sessionSeconds == displayedSessionSecond then
            return
        end

        local sampleDuration = math.max(now - fpsSampleStartedAt, 0.001)
        local fps = math.floor(frameCount / sampleDuration + 0.5)
        footerStats.Text = string.format("%s  •  %d fps", formatSessionDuration(sessionSeconds), fps)
        displayedSessionSecond = sessionSeconds
        fpsSampleStartedAt = now
        frameCount = 0
    end))

end

footerButton.MouseEnter:Connect(function()
    tween(footer, 0.12, { BackgroundColor3 = Theme.Surface })
end)
footerButton.MouseLeave:Connect(function()
    tween(footer, 0.12, { BackgroundColor3 = Theme.SidebarBottom })
end)
footerButton.Activated:Connect(function()
    local sessionText = footerStats.Text
    if type(Config.OnFooterClick) ~= "function" then
        setResult("Session: " .. sessionText, "info")
        return
    end

    task.spawn(function()
        local ok, err = pcall(Config.OnFooterClick, sessionText)
        if not ok then
            warn("[Averlik Key GUI] footer callback error: " .. tostring(err))
            setResult("Footer action failed.", "error")
        end
    end)
end)

local function animateButton(control, normal, hover, pressed, shadow)
    local held = false
    local hovered = false
    control.MouseEnter:Connect(function()
        hovered = true
        if not held then
            tween(control, 0.12, { BackgroundColor3 = hover })
            if shadow then
                tween(shadow, 0.12, { Color = hover })
            end
        end
    end)
    control.MouseLeave:Connect(function()
        hovered = false
        if not held then
            tween(control, 0.12, { BackgroundColor3 = normal })
            if shadow then
                tween(shadow, 0.12, { Color = normal })
            end
        end
    end)
    control.InputBegan:Connect(function(input)
        if isPointerInput(input) then
            held = true
            local downColor = pressed or normal:Lerp(Color3.fromRGB(0, 0, 0), 0.12)
            tween(control, 0.08, { BackgroundColor3 = downColor })
            if shadow then
                tween(shadow, 0.08, { Color = downColor })
            end
        end
    end)
    control.InputEnded:Connect(function(input)
        if isPointerInput(input) then
            held = false
            local color = hovered and hover or normal
            tween(control, 0.12, { BackgroundColor3 = color })
            if shadow then
                tween(shadow, 0.12, { Color = color })
            end
        end
    end)
end

animateButton(submitButton, Theme.Accent, Theme.Accent:Lerp(Color3.fromRGB(255, 255, 255), 0.10), nil, submitShadow)
animateButton(getKeyButton, Theme.SurfacePressed, Theme.SurfaceHover)
animateButton(closeButton, Theme.CloseButton, Theme.CloseButton:Lerp(Color3.fromRGB(255, 255, 255), 0.08))
if closeIcon then
    closeButton.MouseEnter:Connect(function()
        tween(closeIcon, 0.12, {
            Size = UDim2.fromOffset(19, 19),
            ImageColor3 = Theme.Text:Lerp(Color3.fromRGB(255, 255, 255), 0.18),
        })
    end)
    closeButton.MouseLeave:Connect(function()
        tween(closeIcon, 0.12, {
            Size = UDim2.fromOffset(18, 18),
            ImageColor3 = Theme.Text,
        })
    end)
end
submitButton.Activated:Connect(function()
    submitKey(keyBox.Text)
end)
keyBox.Focused:Connect(function()
    tween(keyBox, 0.12, { BackgroundColor3 = Color3.fromRGB(24, 24, 25) })
    tween(keyBoxStroke, 0.12, { Color = Theme.Accent, Transparency = 0.18 })
    if keyBoxGlow then
        keyBoxGlow.Color = Theme.Accent
        keyBoxGlow.Enabled = true
    end
end)
keyBox.FocusLost:Connect(function(enterPressed)
    tween(keyBox, 0.12, { BackgroundColor3 = Color3.fromRGB(19, 19, 20) })
    tween(keyBoxStroke, 0.12, { Color = Theme.Border, Transparency = 0.48 })
    if keyBoxGlow then
        keyBoxGlow.Enabled = false
    end
    if enterPressed then
        submitKey(keyBox.Text)
    end
end)

getKeyButton.Activated:Connect(function()
    setResult("Getting key instructions...", "info")
    task.spawn(function()
        local ok, success, message = pcall(Config.GetKey)
        if not ok then
            warn("[Averlik Key GUI] get-key error: " .. tostring(success))
            setResult("Could not get key instructions.", "error")
            return
        end
        if success == false then
            setResult(message or "Could not get key instructions.", "error")
        else
            setResult("Success. Check your discord.", "success")
        end
    end)
end)

closeui = function()
    tween(window, 0.16, { GroupTransparency = 1 }, Enum.EasingStyle.Quint, Enum.EasingDirection.In)
    task.delay(0.17, destroyGui)
end

local closing = false
closeButton.Activated:Connect(function()
    if closing then
        return
    end
    closing = true
    closeui()
end)

local dragHandle = new("Frame", {
    Name = "DragHandle",
    Active = true,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Size = UDim2.new(1, -55, 1, 0),
    Parent = header,
})
local dragInput = nil
local dragStart = nil
local windowStart = nil
dragHandle.InputBegan:Connect(function(input)
    if isPointerInput(input) then
        dragInput = input
        dragStart = input.Position
        windowStart = window.Position
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if not dragInput then
        return
    end
    local mouseDrag = dragInput.UserInputType == Enum.UserInputType.MouseButton1
        and input.UserInputType == Enum.UserInputType.MouseMovement
    local touchDrag = dragInput.UserInputType == Enum.UserInputType.Touch and input == dragInput
    if mouseDrag or touchDrag then
        local delta = input.Position - dragStart
        window.Position = UDim2.new(
            windowStart.X.Scale,
            windowStart.X.Offset + delta.X,
            windowStart.Y.Scale,
            windowStart.Y.Offset + delta.Y
        )
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input == dragInput then
        dragInput = nil
    end
end)

tween(window, 0.26, { GroupTransparency = 0.05 }, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

task.wait(0.3)
if isfile("Averlik Hub/SavedKey.txt") then
    print("read from save")
    keyBox.Text = readfile("Averlik Hub/SavedKey.txt")
    submitKey(readfile("Averlik Hub/SavedKey.txt"))
end
