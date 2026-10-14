local SCRIPTS = {
    hub = { id = "b89f5a1e5a90ea37267083f09cb5b14f", name = "MiyabiHub" },
    kaitun = { id = "19e60bf7353fa7a4621cb4f8e1dcc21a", name = "MiyabiKaitun" },
}
local KEY_LINKS = {
    LootLabs = "https://ads.luarmor.net/get_key?for=MiyabiHub__Lootlab-GZkJlRRTkzUz",
    Linkvertise = "https://ads.luarmor.net/get_key?for=Miyabi_Hub__Premium_-PKyKbsMvHRvp",
}
local DISCORD_LINK = "https://discord.gg/miyabihub"
local ART_BASE = "https://gist.githubusercontent.com/njspeeder/1b3bd0256dd62bac53bb7ca4b15088f4/raw/"
local KEY_FILE = "MiyabiHub/key.txt"

if not game:IsLoaded() then game.Loaded:Wait() end

local env = getgenv and getgenv() or _G
if env.MiyabiKeyClose then pcall(env.MiyabiKeyClose) end

local TARGET = SCRIPTS[env.MiyabiKeyTarget] or SCRIPTS.hub
env.MiyabiKeyTarget = nil
local SCRIPT_ID = TARGET.id
local LOADER_URL = "https://api.luarmor.net/files/v3/loaders/" .. SCRIPT_ID .. ".lua"

if not env.MiyabiQuietPrint then
    local consolePrint = print
    env.MiyabiQuietPrint = function(...)
        if select("#", ...) == 1 and tostring((...)):match("^%s*%d+%s*$") then return end
        return consolePrint(...)
    end
    env.print = env.MiyabiQuietPrint
end

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local StarterGui = game:GetService("StarterGui")
local LocalPlayer = Players.LocalPlayer

local Colors = {
    Glass = Color3.fromRGB(14, 15, 21),
    Field = Color3.fromRGB(22, 24, 33),
    Accent = Color3.fromRGB(79, 107, 255),
    Violet = Color3.fromRGB(167, 139, 250),
    Sky = Color3.fromRGB(77, 163, 255),
    Fg = Color3.fromRGB(243, 244, 248),
    Muted = Color3.fromRGB(146, 151, 170),
    White = Color3.new(1, 1, 1),
    Black = Color3.new(0, 0, 0),
    Bad = Color3.fromRGB(255, 107, 122),
    Good = Color3.fromRGB(61, 220, 151),
}

local REASONS = {
    KEY_EXPIRED = "Your key expired, get a new one",
    KEY_HWID_LOCKED = "Key is locked to another device, reset it in the Discord panel",
    KEY_INCORRECT = "That key doesn't exist",
    KEY_INVALID = "That doesn't look like a key",
    KEY_BANNED = "This key is blacklisted",
}

local function notify(text, duration)
    pcall(function()
        StarterGui:SetCore("SendNotification", { Title = TARGET.name, Text = text, Duration = duration or 5 })
    end)
end

local api
pcall(function()
    api = loadstring(game:HttpGet("https://sdkapi-public.luarmor.net/library.lua"))()
    api.script_id = SCRIPT_ID
end)

local function cleanKey(text)
    return (tostring(text or ""):gsub("%s", ""))
end

local function readSavedKey()
    local ok, key = pcall(function()
        return isfile(KEY_FILE) and readfile(KEY_FILE) or ""
    end)
    return ok and cleanKey(key) or ""
end

local function saveKey(key)
    pcall(function()
        if not isfolder("MiyabiHub") then makefolder("MiyabiHub") end
        writefile(KEY_FILE, key)
    end)
end

local function forgetKey()
    env.script_key = nil
    pcall(function()
        if isfile(KEY_FILE) then delfile(KEY_FILE) end
    end)
end

local function checkKey(key)
    if not api then return true end
    local ok, status = pcall(api.check_key, key)
    if not ok or type(status) ~= "table" then return true end
    if status.code == "KEY_VALID" then return true end
    local reason = REASONS[status.code]
    if reason then return false, reason, true end
    return false, "Couldn't check the key (" .. tostring(status.code) .. "), try again", false
end

local function launch(key)
    env.script_key = key
    saveKey(key)
    local ok, err = pcall(function()
        loadstring(game:HttpGet(LOADER_URL))()
    end)
    if not ok then
        notify("Couldn't start " .. TARGET.name .. ": " .. tostring(err), 8)
        warn("[" .. TARGET.name .. "] " .. tostring(err))
    end
end

local startMessage
local savedKey = cleanKey(env.script_key)
if savedKey == "" then savedKey = readSavedKey() end
if savedKey ~= "" then
    local valid, reason, badKey = checkKey(savedKey)
    if valid then
        launch(savedKey)
        return
    end
    if badKey then forgetKey() end
    startMessage = reason
end

local Fonts = {}
do
    local family = "rbxasset://fonts/families/Montserrat.json"
    pcall(function() family = Font.fromEnum(Enum.Font.Montserrat).Family end)
    Fonts.Semi = Font.new(family, Enum.FontWeight.SemiBold)
    Fonts.Bold = Font.new(family, Enum.FontWeight.Bold)
    Fonts.Heavy = Font.new(family, Enum.FontWeight.ExtraBold)
end

local function New(class, props, children)
    local inst = Instance.new(class)
    local parent = props.Parent
    props.Parent = nil
    for key, value in props do inst[key] = value end
    for _, child in children or {} do child.Parent = inst end
    inst.Parent = parent
    return inst
end

local function Corner(radius)
    return New("UICorner", { CornerRadius = UDim.new(0, radius) })
end

local function Stroke(transparency, color, thickness)
    return New("UIStroke", {
        Color = color or Colors.White,
        Transparency = transparency or 0.92,
        Thickness = thickness or 1,
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    })
end

local function Label(props)
    props.BackgroundTransparency = 1
    props.FontFace = props.FontFace or Fonts.Semi
    props.TextColor3 = props.TextColor3 or Colors.Fg
    props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
    return New("TextLabel", props)
end

local function Tween(inst, time, goal, style)
    local info = TweenInfo.new(time, style or Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    local tween = TweenService:Create(inst, info, goal)
    tween:Play()
    return tween
end

local function brandGradient(rotation)
    return New("UIGradient", {
        Rotation = rotation or 0,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Colors.Accent),
            ColorSequenceKeypoint.new(0.5, Colors.Violet),
            ColorSequenceKeypoint.new(1, Colors.Sky),
        }),
    })
end

local function guiParent()
    local ok, hui = pcall(function() return gethui() end)
    if ok and hui then return hui end
    local coreOk, core = pcall(function() return game:GetService("CoreGui") end)
    if coreOk and pcall(function() return core.Name end) then return core end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local function loadArt(file)
    local customAsset = getcustomasset or getsynasset
    if type(customAsset) ~= "function" or type(writefile) ~= "function" then return nil end
    local ok, id = pcall(function()
        for _, folder in { "MiyabiHub", "MiyabiHub/art" } do
            if not isfolder(folder) then makefolder(folder) end
        end
        local path = "MiyabiHub/art/" .. LocalPlayer.UserId .. "_" .. file
        if not isfile(path) then
            local data = game:HttpGet(ART_BASE .. file)
            local isImage = type(data) == "string" and (data:sub(2, 4) == "PNG" or data:sub(1, 2) == "\255\216")
            if not isImage then return nil end
            writefile(path, data)
        end
        return customAsset(path)
    end)
    return ok and id or nil
end

local WIDTH, HEIGHT, BANNER = 440, 438, 132

local conns = {}
local function on(signal, fn)
    local conn = signal:Connect(fn)
    table.insert(conns, conn)
    return conn
end

local Gui = New("ScreenGui", {
    Name = "MiyabiHubKey",
    ResetOnSpawn = false,
    IgnoreGuiInset = true,
    DisplayOrder = 1000,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    Parent = guiParent(),
})

local closed = false
local function close()
    if closed then return end
    closed = true
    env.MiyabiKeyClose = nil
    for _, conn in conns do pcall(function() conn:Disconnect() end) end
    pcall(function() Gui:Destroy() end)
end
env.MiyabiKeyClose = close

local Dim = New("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Colors.Black,
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    Parent = Gui,
})

local Scale = New("UIScale", { Scale = 0.85 })
local Holder = New("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.fromOffset(WIDTH, HEIGHT),
    BackgroundTransparency = 1,
    Parent = Gui,
}, { Scale })

local Glow = New("Frame", {
    AnchorPoint = Vector2.new(0.5, 0.5),
    Position = UDim2.fromScale(0.5, 0.5),
    Size = UDim2.new(1, 24, 1, 24),
    BackgroundColor3 = Colors.Accent,
    BackgroundTransparency = 0.9,
    BorderSizePixel = 0,
    Parent = Holder,
}, { Corner(30) })

local BorderGradient = brandGradient(0)
local Main = New("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundColor3 = Colors.Glass,
    BackgroundTransparency = 0.02,
    BorderSizePixel = 0,
    ZIndex = 2,
    Parent = Holder,
}, { Corner(20) })
New("UIStroke", {
    Thickness = 1.6,
    Transparency = 0.15,
    Color = Colors.White,
    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    Parent = Main,
}, { BorderGradient })

local BannerFrame = New("Frame", {
    Size = UDim2.new(1, 0, 0, BANNER),
    BackgroundColor3 = Colors.Accent,
    BorderSizePixel = 0,
    ClipsDescendants = true,
    ZIndex = 1,
    Parent = Main,
}, { Corner(20), brandGradient(25) })

local BannerTitle = Label({
    Size = UDim2.new(1, 0, 1, -24),
    Text = TARGET.name,
    FontFace = Fonts.Heavy,
    TextSize = 34,
    TextXAlignment = Enum.TextXAlignment.Center,
    Parent = BannerFrame,
})

local Banner = New("ImageLabel", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    ScaleType = Enum.ScaleType.Crop,
    ImageTransparency = 1,
    Parent = BannerFrame,
}, { Corner(20) })

local SnowLayer = New("Frame", {
    Size = UDim2.fromScale(1, 1),
    BackgroundTransparency = 1,
    Parent = BannerFrame,
})

New("Frame", {
    AnchorPoint = Vector2.new(0, 1),
    Position = UDim2.new(0, 0, 0, BANNER + 1),
    Size = UDim2.new(1, 0, 0, 70),
    BackgroundColor3 = Colors.Glass,
    BorderSizePixel = 0,
    ZIndex = 2,
    Parent = Main,
}, {
    New("UIGradient", {
        Rotation = 90,
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.75, 0.05),
            NumberSequenceKeypoint.new(1, 0),
        }),
    }),
})

local Badge = New("Frame", {
    Position = UDim2.fromOffset(14, 14),
    Size = UDim2.fromOffset(0, 24),
    AutomaticSize = Enum.AutomaticSize.X,
    BackgroundColor3 = Colors.Black,
    BackgroundTransparency = 0.45,
    BorderSizePixel = 0,
    ZIndex = 3,
    Parent = Main,
}, {
    Corner(12),
    Stroke(0.85),
    New("UIPadding", { PaddingLeft = UDim.new(0, 10), PaddingRight = UDim.new(0, 10) }),
})
local BadgeDot = New("Frame", {
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.fromScale(0, 0.5),
    Size = UDim2.fromOffset(6, 6),
    BackgroundColor3 = Colors.Good,
    BorderSizePixel = 0,
    Parent = Badge,
}, { Corner(3) })
Label({
    Position = UDim2.fromOffset(12, 0),
    Size = UDim2.new(0, 0, 1, 0),
    AutomaticSize = Enum.AutomaticSize.X,
    Text = "KEY SYSTEM",
    FontFace = Fonts.Heavy,
    TextSize = 10,
    Parent = Badge,
})

local CloseButton = New("TextButton", {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, -12, 0, 12),
    Size = UDim2.fromOffset(30, 30),
    BackgroundColor3 = Colors.Black,
    BackgroundTransparency = 0.45,
    AutoButtonColor = false,
    Text = "",
    ZIndex = 3,
    Parent = Main,
}, { Corner(15), Stroke(0.85) })
for _, angle in { 45, -45 } do
    New("Frame", {
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(11, 2),
        Rotation = angle,
        BackgroundColor3 = Colors.Fg,
        BorderSizePixel = 0,
        Parent = CloseButton,
    }, { Corner(1) })
end

local Content = New("Frame", {
    Position = UDim2.fromOffset(22, BANNER - 8),
    Size = UDim2.new(1, -44, 1, -(BANNER + 8)),
    BackgroundTransparency = 1,
    ZIndex = 3,
    Parent = Main,
})

local Title = Label({
    Size = UDim2.new(1, 0, 0, 24),
    Text = "Unlock " .. TARGET.name,
    FontFace = Fonts.Heavy,
    TextSize = 20,
    Parent = Content,
})
New("UIGradient", {
    Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Colors.White),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(205, 214, 255)),
        ColorSequenceKeypoint.new(1, Colors.Violet),
    }),
    Parent = Title,
})

Label({
    Position = UDim2.fromOffset(0, 26),
    Size = UDim2.new(1, 0, 0, 16),
    Text = "Grab a free key, or paste your Premium key",
    TextSize = 12,
    TextColor3 = Colors.Muted,
    Parent = Content,
})

local StepRow = New("Frame", {
    Position = UDim2.fromOffset(0, 54),
    Size = UDim2.new(1, 0, 0, 26),
    BackgroundTransparency = 1,
    Parent = Content,
}, {
    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        Padding = UDim.new(0, 6),
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
    }),
})

local steps = {}
for index, text in { "Get Key", "Finish steps", "Paste key" } do
    local chip = New("Frame", {
        Size = UDim2.fromOffset(0, 26),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Colors.White,
        BackgroundTransparency = 0.95,
        BorderSizePixel = 0,
        LayoutOrder = index,
        Parent = StepRow,
    }, {
        Corner(13),
        New("UIPadding", { PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 10) }),
    })
    local chipStroke = Stroke(0.9)
    chipStroke.Parent = chip
    local dot = New("Frame", {
        AnchorPoint = Vector2.new(0, 0.5),
        Position = UDim2.fromScale(0, 0.5),
        Size = UDim2.fromOffset(18, 18),
        BackgroundColor3 = Colors.White,
        BackgroundTransparency = 0.88,
        BorderSizePixel = 0,
        Parent = chip,
    }, { Corner(9) })
    local number = Label({
        Size = UDim2.fromScale(1, 1),
        Text = tostring(index),
        FontFace = Fonts.Heavy,
        TextSize = 10,
        TextXAlignment = Enum.TextXAlignment.Center,
        Parent = dot,
    })
    local caption = Label({
        Position = UDim2.fromOffset(24, 0),
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Text = text,
        FontFace = Fonts.Bold,
        TextSize = 11,
        TextColor3 = Colors.Muted,
        Parent = chip,
    })
    steps[index] = { chip = chip, stroke = chipStroke, dot = dot, number = number, caption = caption }
end

local currentStep = 0
local function setStep(active)
    if active <= currentStep then return end
    currentStep = active
    for index, step in steps do
        local done, now = index < active, index == active
        Tween(step.dot, 0.25, {
            BackgroundColor3 = (done or now) and Colors.Accent or Colors.White,
            BackgroundTransparency = done and 0 or (now and 0.15 or 0.88),
        })
        Tween(step.stroke, 0.25, {
            Color = now and Colors.Accent or Colors.White,
            Transparency = now and 0.35 or 0.9,
        })
        Tween(step.chip, 0.25, { BackgroundTransparency = now and 0.9 or 0.95 })
        Tween(step.caption, 0.25, { TextColor3 = (done or now) and Colors.Fg or Colors.Muted })
    end
end

local KeyField = New("Frame", {
    Position = UDim2.fromOffset(0, 92),
    Size = UDim2.new(1, 0, 0, 46),
    BackgroundColor3 = Colors.Field,
    BorderSizePixel = 0,
    Parent = Content,
}, { Corner(14) })
local KeyStroke = Stroke(0.9)
KeyStroke.Parent = KeyField

local PasteButton = New("TextButton", {
    AnchorPoint = Vector2.new(0, 0.5),
    Position = UDim2.new(0, 8, 0.5, 0),
    Size = UDim2.fromOffset(56, 30),
    BackgroundColor3 = Colors.White,
    BackgroundTransparency = 0,
    AutoButtonColor = false,
    Text = "",
    Parent = KeyField,
}, { Corner(10), brandGradient(35) })
Label({
    Size = UDim2.fromScale(1, 1),
    Text = "PASTE",
    FontFace = Fonts.Heavy,
    TextSize = 11,
    TextXAlignment = Enum.TextXAlignment.Center,
    Parent = PasteButton,
})

local KeyBox = New("TextBox", {
    Position = UDim2.fromOffset(76, 0),
    Size = UDim2.new(1, -88, 1, 0),
    BackgroundTransparency = 1,
    Text = "",
    PlaceholderText = "Paste your key here",
    PlaceholderColor3 = Colors.Muted,
    ClearTextOnFocus = false,
    TextTruncate = Enum.TextTruncate.AtEnd,
    FontFace = Fonts.Semi,
    TextSize = 13,
    TextColor3 = Colors.Fg,
    TextXAlignment = Enum.TextXAlignment.Left,
    Parent = KeyField,
})

local function pressable(button, rest, hover)
    local scale = New("UIScale", { Parent = button })
    on(button.MouseEnter, function() Tween(button, 0.15, { BackgroundTransparency = hover }) end)
    on(button.MouseLeave, function()
        Tween(button, 0.15, { BackgroundTransparency = rest })
        Tween(scale, 0.15, { Scale = 1 })
    end)
    on(button.MouseButton1Down, function() Tween(scale, 0.1, { Scale = 0.96 }) end)
    on(button.MouseButton1Up, function() Tween(scale, 0.2, { Scale = 1 }, Enum.EasingStyle.Back) end)
end

local function providerButton(text, xScale, xOffset)
    local button = New("TextButton", {
        Position = UDim2.new(xScale, xOffset, 0, 150),
        Size = UDim2.new(0.5, -5, 0, 44),
        BackgroundColor3 = Colors.White,
        BackgroundTransparency = 0.93,
        AutoButtonColor = false,
        Text = "",
        Parent = Content,
    }, {
        Corner(22),
        Stroke(0.88),
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
        }),
    })
    local logo = New("ImageLabel", {
        Size = UDim2.fromOffset(20, 20),
        BackgroundTransparency = 1,
        ScaleType = Enum.ScaleType.Fit,
        Visible = false,
        LayoutOrder = 1,
        Parent = button,
    })
    Label({
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        Text = text,
        FontFace = Fonts.Bold,
        TextSize = 14,
        LayoutOrder = 2,
        Parent = button,
    })
    pressable(button, 0.93, 0.87)
    return button, logo
end

local providerButtons, providerLogos = {}, {}
providerButtons.LootLabs, providerLogos.LootLabs = providerButton("LootLabs", 0, 0)
providerButtons.Linkvertise, providerLogos.Linkvertise = providerButton("Linkvertise", 0.5, 5)

local CheckButton = New("TextButton", {
    Position = UDim2.fromOffset(0, 204),
    Size = UDim2.new(1, 0, 0, 44),
    BackgroundColor3 = Colors.White,
    BackgroundTransparency = 0,
    AutoButtonColor = false,
    Text = "",
    Parent = Content,
}, { Corner(22), brandGradient(0) })
pressable(CheckButton, 0, 0.12)

local CheckLabel = Label({
    Size = UDim2.fromScale(1, 1),
    Text = "Check Key",
    FontFace = Fonts.Heavy,
    TextSize = 14,
    TextColor3 = Colors.White,
    TextXAlignment = Enum.TextXAlignment.Center,
    Parent = CheckButton,
})

local Status = Label({
    Position = UDim2.fromOffset(0, 258),
    Size = UDim2.new(1, 0, 0, 16),
    Text = "",
    TextSize = 12,
    TextColor3 = Colors.Muted,
    TextTruncate = Enum.TextTruncate.AtEnd,
    TextXAlignment = Enum.TextXAlignment.Center,
    Parent = Content,
})

New("Frame", {
    Position = UDim2.fromOffset(0, 282),
    Size = UDim2.new(1, 0, 0, 1),
    BackgroundColor3 = Colors.White,
    BackgroundTransparency = 0.92,
    BorderSizePixel = 0,
    Parent = Content,
})

Label({
    Position = UDim2.fromOffset(0, 290),
    Size = UDim2.new(1, -90, 0, 16),
    Text = "Premium skips the ads and never expires",
    TextSize = 11,
    TextColor3 = Colors.Muted,
    Parent = Content,
})

local DiscordButton = New("TextButton", {
    AnchorPoint = Vector2.new(1, 0),
    Position = UDim2.new(1, 0, 0, 290),
    Size = UDim2.fromOffset(80, 16),
    BackgroundTransparency = 1,
    AutoButtonColor = false,
    Text = "Join Discord",
    FontFace = Fonts.Bold,
    TextSize = 11,
    TextColor3 = Colors.Sky,
    TextXAlignment = Enum.TextXAlignment.Right,
    Parent = Content,
})

local function setStatus(text, color)
    Status.Text = text
    Status.TextColor3 = color or Colors.Muted
end

local function copy(text)
    local setter = setclipboard or toclipboard
    return setter ~= nil and pcall(setter, text)
end

local function fitScale()
    local camera = workspace.CurrentCamera
    local view = camera and camera.ViewportSize or Vector2.new(1280, 720)
    return math.min(1, (view.X - 32) / WIDTH, (view.Y - 32) / HEIGHT)
end

setStep(1)
if startMessage then setStatus(startMessage, Colors.Bad) end

task.spawn(function()
    local id = loadArt("banner.jpg")
    if id and not closed then
        Banner.Image = id
        Tween(Banner, 0.6, { ImageTransparency = 0 })
        BannerTitle.Visible = false
    end
end)

for provider, logo in providerLogos do
    task.spawn(function()
        local id = loadArt(provider:lower() .. ".png")
        if id and not closed then
            logo.Image = id
            logo.Visible = true
        end
    end)
end

task.spawn(function()
    local snow = loadArt("snow.png")
    while not closed do
        local size = math.random(4, 9)
        local startX = math.random(10, WIDTH - 10)
        local flake = New("ImageLabel", {
            Position = UDim2.fromOffset(startX, -10),
            Size = UDim2.fromOffset(size, size),
            BackgroundColor3 = Colors.White,
            BackgroundTransparency = snow and 1 or 0.3,
            Image = snow or "",
            ImageTransparency = 0.15,
            BorderSizePixel = 0,
            Parent = SnowLayer,
        }, snow and {} or { Corner(size) })
        local fall = math.random(35, 60) / 10
        Tween(flake, fall, {
            Position = UDim2.fromOffset(startX + math.random(-30, 30), BANNER + 10),
            Rotation = math.random(-180, 180),
            ImageTransparency = 0.6,
        }, Enum.EasingStyle.Linear)
        task.delay(fall, function() flake:Destroy() end)
        task.wait(0.22)
    end
end)

TweenService:Create(
    BorderGradient,
    TweenInfo.new(4, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1),
    { Rotation = 360 }
):Play()
TweenService:Create(
    Glow,
    TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    { BackgroundTransparency = 0.96, Size = UDim2.new(1, 36, 1, 36) }
):Play()
TweenService:Create(
    BadgeDot,
    TweenInfo.new(0.9, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true),
    { BackgroundTransparency = 0.7 }
):Play()

local busy = false
local function submit()
    if busy or closed then return end
    local key = cleanKey(KeyBox.Text)
    if key == "" then
        setStatus("Paste your key first", Colors.Bad)
        return
    end
    busy = true
    setStep(3)
    CheckLabel.Text = "Checking..."
    setStatus("Checking your key")
    local valid, reason = checkKey(key)
    if closed then return end
    if valid then
        setStep(4)
        CheckLabel.Text = "Unlocked"
        setStatus("Key works, loading " .. TARGET.name, Colors.Good)
        task.wait(0.5)
        Tween(Scale, 0.3, { Scale = fitScale() * 0.9 })
        Tween(Dim, 0.3, { BackgroundTransparency = 1 })
        task.wait(0.25)
        close()
        launch(key)
    else
        CheckLabel.Text = "Check Key"
        setStatus(reason, Colors.Bad)
        Tween(KeyStroke, 0.15, { Color = Colors.Bad, Transparency = 0.2 })
        busy = false
    end
end

for provider, button in providerButtons do
    on(button.MouseButton1Click, function()
        local link = KEY_LINKS[provider]
        setStep(2)
        if copy(link) then
            setStatus(provider .. " link copied, open it in your browser", Colors.Good)
            notify(provider .. " link copied, open it in your browser", 4)
        else
            KeyBox.Text = link
            setStatus("Couldn't copy, the link is in the box", Colors.Bad)
        end
    end)
end

on(DiscordButton.MouseButton1Click, function()
    if copy(DISCORD_LINK) then
        setStatus("Discord invite copied", Colors.Good)
    else
        setStatus(DISCORD_LINK)
    end
end)

pressable(PasteButton, 0, 0.15)
on(PasteButton.MouseButton1Click, function()
    local ok, clip = false, nil
    if getclipboard then ok, clip = pcall(getclipboard) end
    local text = ok and cleanKey(clip) or ""
    if text ~= "" then
        KeyBox.Text = text
        setStatus("Key pasted, press Check Key", Colors.Good)
    else
        KeyBox:CaptureFocus()
        setStatus("Press Ctrl+V to paste your key")
    end
end)

on(CheckButton.MouseButton1Click, function()
    task.spawn(submit)
end)

on(KeyBox.Focused, function()
    Tween(KeyStroke, 0.15, { Color = Colors.Accent, Transparency = 0.15 })
end)

on(KeyBox.FocusLost, function(enterPressed)
    Tween(KeyStroke, 0.15, { Color = Colors.White, Transparency = 0.9 })
    if enterPressed then task.spawn(submit) end
end)

on(KeyBox:GetPropertyChangedSignal("Text"), function()
    local text = cleanKey(KeyBox.Text)
    if text ~= "" and not text:find("://", 1, true) then setStep(3) end
end)

on(CloseButton.MouseButton1Click, close)
on(CloseButton.MouseEnter, function() Tween(CloseButton, 0.15, { BackgroundTransparency = 0.2 }) end)
on(CloseButton.MouseLeave, function() Tween(CloseButton, 0.15, { BackgroundTransparency = 0.45 }) end)
on(DiscordButton.MouseEnter, function() Tween(DiscordButton, 0.15, { TextColor3 = Colors.White }) end)
on(DiscordButton.MouseLeave, function() Tween(DiscordButton, 0.15, { TextColor3 = Colors.Sky }) end)

local dragStart, startPosition
on(Holder.InputBegan, function(input)
    local isPress = input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch
    if isPress and input.Position.Y - Holder.AbsolutePosition.Y < BANNER * Scale.Scale then
        dragStart, startPosition = input.Position, Holder.Position
    end
end)

on(UserInputService.InputChanged, function(input)
    if not dragStart then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - dragStart
        Holder.Position = UDim2.new(
            startPosition.X.Scale, startPosition.X.Offset + delta.X,
            startPosition.Y.Scale, startPosition.Y.Offset + delta.Y
        )
    end
end)

on(UserInputService.InputEnded, function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragStart = nil
    end
end)

Tween(Dim, 0.35, { BackgroundTransparency = 0.45 })
Tween(Scale, 0.45, { Scale = fitScale() }, Enum.EasingStyle.Back)
