if not game:IsLoaded() then game.Loaded:Wait() end

-- ============================================================
--  ScriptFarmer Key System • Professional UI
--  Powered by Junkie SDK  •  discord.gg/7q2TvZ9GYX
-- ============================================================

-- [ CRITICAL FIX: Clear old keys from executor memory so it doesn't bypass ]
getgenv().SCRIPT_KEY = nil
local IS_VALIDATED = false 

-- SETTINGS
local Options = {
    Draggable = true,
    Background = true,
    BlurBackground = true,
    AutoClose = true,
    PlayAnimations = true,
    BlockReExecute = true,
    AutoLoad = true,
    UUIDCheck = false, -- Disabled regex check to rely fully on Junkie Backend
}

local Links = {
    Discord = "https://discord.gg/7q2TvZ9GYX",
    BuyText = "https://discord.gg/7q2TvZ9GYX",
}

local LaunchJunkie = {
    Provider = "ScriptFarmer Key Systeam",
    Service = "rivals skin",
    Identifier = "1089078",
}

local YT_NAME      = "ScriptFarmer"
local GUI_NAME     = "ScriptFarmerUI"
local VERSION      = "v1.0.0"

-- [ JUNKIE SDK INITIALIZATION ]
local Junkie = nil
local success, sdk = pcall(function()
    return loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
end)

if success and type(sdk) == "table" then
    Junkie = sdk
    Junkie.service = LaunchJunkie.Service
    Junkie.identifier = LaunchJunkie.Identifier
    Junkie.provider = LaunchJunkie.Provider
else
    warn("ScriptFarmer: Failed to load Junkie SDK. Check your internet connection or URL.")
end

local KEY_FILE = "sf_verified_key.txt"

if Options.BlockReExecute then
    if getgenv().__SCRIPTFARMER_KS_OPEN then return end
    getgenv().__SCRIPTFARMER_KS_OPEN = true
end

-- FIXED CLONEREF
cloneref = cloneref or function(obj) return obj end
local service = setmetatable({}, {
    __index = function(self, name)
        rawset(self, name, cloneref(game:GetService(name)))
        return rawget(self, name)
    end
})

local Players = service.Players
local TweenService = service.TweenService
local UserInputService = service.UserInputService
local RunService = service.RunService
local HttpService = service.HttpService
local CoreGui = service.CoreGui
local LocalPlayer = Players.LocalPlayer
local IS_MOBILE = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

local Themes = {
    Background = Color3.fromRGB(7,   7,   9),
    Header = Color3.fromRGB(12,  12,  14),
    Input = Color3.fromRGB(18,  18,  21),
    Card = Color3.fromRGB(22,  22,  26),
    Pending = Color3.fromRGB(28,  28,  33),
    Divider = Color3.fromRGB(32,  32,  38),
    Border = Color3.fromRGB(44,  44,  52),
    Text = Color3.fromRGB(232, 232, 238),
    TextDim = Color3.fromRGB(130, 130, 138),
    Accent = Color3.fromRGB(188, 188, 196),
    Success = Color3.fromRGB(90,  200, 160),
    Error = Color3.fromRGB(220, 80,  90),
    Warning = Color3.fromRGB(255, 170, 70),
    Idle = Color3.fromRGB(100, 100, 108),
    Discord = Color3.fromRGB(88,  101, 242),
}

local Icons = {
    Logo = "rbxassetid://88551528231080", -- MAIN LOGO
    Key = "rbxassetid://10871266112",
    Redeem = "rbxassetid://10709790644",
    Close = "rbxassetid://10747384394",
    Copy = "rbxassetid://10734940376",
    Clock = "rbxassetid://10723415903",
    UserInfo = "rbxassetid://9405926389",
    Changelog = "rbxassetid://96498567035505",
    Discord = "rbxassetid://101192191207677",
    KeyInput = "rbxassetid://10747373176",
    Buy = "rbxassetid://135780702746673",
}

local function Tween(object, properties, duration, style, direction)
    TweenService:Create(object, TweenInfo.new(
        duration  or 0.2,
        style     or Enum.EasingStyle.Quint,
        direction or Enum.EasingDirection.Out
    ), properties):Play()
end

local function Spring(object, properties, duration)
    TweenService:Create(object, TweenInfo.new(
        duration or 0.35,
        Enum.EasingStyle.Back,
        Enum.EasingDirection.Out
    ), properties):Play()
end

local function New(className, properties)
    local object = Instance.new(className)
    for key, value in pairs(properties) do
        if key ~= "Parent" then object[key] = value end
    end
    if properties.Parent then object.Parent = properties.Parent end
    return object
end

local function Round(object, radius)
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, radius or 6)
    corner.Parent = object
    return corner
end

local function Stroke(object, color, thickness, transparency)
    local stroke = Instance.new("UIStroke")
    stroke.Color = color or Themes.Border
    stroke.Thickness = thickness or 1
    stroke.Transparency = transparency or 0
    stroke.Parent = object
    return stroke
end

local function TouchCooldown(flag, seconds)
    if not getgenv then return false end
    if getgenv()[flag] then return true end
    getgenv()[flag] = true
    task.delay(seconds or 0.5, function()
        if getgenv then getgenv()[flag] = nil end
    end)
    return false
end

local function SaveKey(key)
    pcall(function()
        if writefile then
            writefile(KEY_FILE, HttpService:JSONEncode({key=key}))
        end
    end)
end

local function LoadKey()
    local success, result = pcall(function()
        if not (isfile and readfile) then return nil end
        if not isfile(KEY_FILE) then return nil end
        local raw = readfile(KEY_FILE)
        if not raw or #raw == 0 then return nil end
        local data = HttpService:JSONDecode(raw)
        return data and data.key or nil
    end)
    return success and result or nil
end

local function GetHWID()
    local id = ""
    if gethwid then
        local success, value = pcall(gethwid)
        if success and value then id = tostring(value) end
    end
    if id == "" then
        pcall(function()
            id = tostring(service.RbxAnalyticsService:GetClientId())
        end)
    end
    return id
end

local WINDOW_WIDTH = 360
local WINDOW_HEIGHT = 388
local HEADER_HEIGHT = 46
local TABBAR_HEIGHT = 36
local CONTENT_Y = HEADER_HEIGHT + TABBAR_HEIGHT
local CONTENT_H = WINDOW_HEIGHT - CONTENT_Y
local INNER_PAD = 12
local TAB_COUNT = 3

local ScreenGui = New("ScreenGui", {
    Name = GUI_NAME,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
    IgnoreGuiInset = true,
    Parent = CoreGui,
})

local Lighting = service.Lighting
local BlurEffect = nil
if Options.BlurBackground then
    BlurEffect = Instance.new("BlurEffect")
    BlurEffect.Name = GUI_NAME .. "Blur"
    BlurEffect.Size = 0
    BlurEffect.Parent  = Lighting
end

local BackgroundOverlay = New("Frame", {
    Size = UDim2.new(1, 0, 1, 0),
    BackgroundColor3 = Color3.new(0, 0, 0),
    BackgroundTransparency = Options.Background and 1 or 1,
    BorderSizePixel = 0,
    ZIndex = 1,
    Parent = ScreenGui,
})

local Window = New("Frame", {
    Size = UDim2.new(0, WINDOW_WIDTH, 0, WINDOW_HEIGHT),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = Themes.Background,
    BorderSizePixel  = 0,
    ClipsDescendants = true,
    Visible = false,
    ZIndex = 2,
    Parent = ScreenGui,
})
Round(Window, 6)
Stroke(Window, Color3.fromRGB(36, 36, 44), 1, 0)

local LeftDoor = New("Frame", {
    Size = UDim2.new(0.5, 0, 1, 0),
    Position = UDim2.new(0, 0, 0, 0),
    BackgroundColor3 = Themes.Background,
    BorderSizePixel  = 0,
    ZIndex = 10,
    Parent = Window,
})
Round(LeftDoor, 0)

local RightDoor = New("Frame", {
    Size = UDim2.new(0.5, 0, 1, 0),
    Position = UDim2.new(0.5, 0, 0, 0),
    BackgroundColor3 = Themes.Background,
    BorderSizePixel  = 0,
    ZIndex = 10,
    Parent = Window,
})

local DoorLogo = New("ImageLabel", {
    Size = UDim2.new(0, 58, 0, 58),
    Position = UDim2.new(0.5, -29, 0.5, -29),
    BackgroundTransparency = 1,
    Image = Icons.Logo,
    ImageColor3 = Themes.Accent,
    ImageTransparency = 0,
    ZIndex = 11,
    Parent = Window,
})

local function OpenDoorAnimation(callback)
    Window.Visible = true
    if not Options.PlayAnimations then
        LeftDoor.Visible  = false
        RightDoor.Visible = false
        DoorLogo.Visible  = false
        if Options.Background then BackgroundOverlay.BackgroundTransparency = 0.62 end
        if BlurEffect then BlurEffect.Size = 18 end
        if callback then callback() end
        return
    end
    if Options.Background then
        Tween(BackgroundOverlay, { BackgroundTransparency = 0.62 }, 0.6)
    end
    if BlurEffect then
        Tween(BlurEffect, { Size = 18 }, 0.6)
    end
    Tween(DoorLogo, { ImageTransparency = 1 }, 0.5)
    task.delay(0.45, function()
        Tween(LeftDoor,  { Position = UDim2.new(-0.5, 0, 0, 0) }, 0.72, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        Tween(RightDoor, { Position = UDim2.new(1,    0, 0, 0) }, 0.72, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
        task.delay(0.76, function()
            LeftDoor.Visible  = false
            RightDoor.Visible = false
            DoorLogo.Visible  = false
            if callback then callback() end
        end)
    end)
end

local function CloseDoorAnimation(callback)
    if not Options.PlayAnimations then
        if Options.Background then BackgroundOverlay.BackgroundTransparency = 1 end
        if BlurEffect then BlurEffect.Size = 0 end
        ScreenGui:Destroy()
        if callback then callback() end
        return
    end
    LeftDoor.Visible  = true
    RightDoor.Visible = true
    DoorLogo.Visible  = true
    LeftDoor.Position  = UDim2.new(-0.5, 0, 0, 0)
    RightDoor.Position = UDim2.new(1,    0, 0, 0)
    DoorLogo.ImageTransparency = 1
    Tween(LeftDoor,  { Position = UDim2.new(0,   0, 0, 0) }, 0.48, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    Tween(RightDoor, { Position = UDim2.new(0.5, 0, 0, 0) }, 0.48, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    task.delay(0.38, function()
        Tween(DoorLogo, { ImageTransparency = 0 }, 0.28)
    end)
    if Options.Background then
        task.delay(0.1, function()
            Tween(BackgroundOverlay, { BackgroundTransparency = 1 }, 0.38)
        end)
    end
    if BlurEffect then
        task.delay(0.1, function()
            Tween(BlurEffect, { Size = 0 }, 0.38)
        end)
    end
    task.delay(0.82, function()
        ScreenGui:Destroy()
        if callback then callback() end
    end)
end

local Header = New("Frame", {
    Size = UDim2.new(1, 0, 0, HEADER_HEIGHT),
    BackgroundColor3 = Themes.Header,
    BorderSizePixel  = 0,
    ZIndex = 3,
    Parent = Window,
})
Round(Header, 6)
New("Frame", {
    Size = UDim2.new(1, 0, 0, 10),
    Position = UDim2.new(0, 0, 1, -10),
    BackgroundColor3 = Themes.Header,
    BorderSizePixel  = 0,
    ZIndex = 3,
    Parent = Header,
})
New("Frame", {
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.new(0, 0, 1, -1),
    BackgroundColor3 = Themes.Divider,
    BorderSizePixel  = 0,
    ZIndex = 4,
    Parent = Header,
})

-- DRAGGABLE LOGIC
if Options.Draggable then
    local CameraInput = nil
    pcall(function()
        CameraInput = require(LocalPlayer.PlayerScripts
            :WaitForChild("PlayerModule")
            :WaitForChild("CameraModule")
            :WaitForChild("CameraInput"))
    end)
    
    local uiDragging = false
    local activeDragInput = nil
    local dragStart = nil
    local startPos = nil
    local hasMoved = false

    local function isClickInput(input)
        return input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch
    end

    local function clampWindow()
        local vp = workspace.CurrentCamera.ViewportSize
        local pos = Window.Position
        local clampX = math.clamp(pos.X.Offset, 0, vp.X - WINDOW_WIDTH)
         local clampY = math.clamp(pos.Y.Offset, 0, vp.Y - WINDOW_HEIGHT)
        return UDim2.new(0, clampX, 0, clampY)
    end

    local function startDrag(input)
        if not isClickInput(input) then return end
        if uiDragging then return end
        uiDragging = true
        activeDragInput = input
        dragStart = input.Position
        startPos = Window.Position
        hasMoved = false
        if CameraInput then pcall(function() CameraInput.setInputEnabled(false) end) end
    end

    Header.InputBegan:Connect(startDrag)
    Window.InputBegan:Connect(startDrag)

    UserInputService.InputChanged:Connect(function(input)
        if not uiDragging then return end
        if IS_MOBILE then
            if activeDragInput ~= input then return end
            if input.UserInputType ~= Enum.UserInputType.Touch then return end
        else
             if input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
        end
        local delta = input.Position - dragStart
        if math.abs(delta.X) > 4 or math.abs(delta.Y) > 4 then
            hasMoved = true
        end
        Window.Position = UDim2.new(0,
            startPos.X.Offset + delta.X, 0,
            startPos.Y.Offset + delta.Y
        )
    end)

    UserInputService.InputEnded:Connect(function(input)
        if not uiDragging then return end
        if IS_MOBILE then
            if activeDragInput ~= input then return end
            if input.UserInputType ~= Enum.UserInputType.Touch then return end
        else
             if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
        end
        uiDragging = false
        activeDragInput = nil
        if CameraInput then pcall(function() CameraInput.setInputEnabled(true) end) end
        task.spawn(function()
            task.wait(0.05)
            hasMoved = false
        end)
        local clamped = clampWindow()
        Tween(Window, { Position = clamped }, 0.2, Enum.EasingStyle.Quint)
    end)
end

New("ImageLabel", {
    Size = UDim2.new(0, 18, 0, 18),
    Position = UDim2.new(0, 14, 0.5, -9),
    BackgroundTransparency = 1,
    Image = Icons.Logo,
    ImageColor3 = Themes.Accent,
    ZIndex = 4,
    Parent = Header,
})
New("TextLabel", {
    Size = UDim2.new(0, 70, 0, 18),
    Position = UDim2.new(0, 38, 0.5, -9),
    BackgroundTransparency = 1,
    Text = "SCRIPTFARMER",
    TextColor3 = Themes.Text,
    Font = Enum.Font.GothamBlack,
    TextSize = 13,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
    Parent = Header,
})

local HeaderSubtitle = New("TextLabel", {
    Size = UDim2.new(1, -210, 0, 14),
    Position = UDim2.new(0, 112, 0.5, -7),
    BackgroundTransparency = 1,
    Text = "Get a key, paste it below",
    TextColor3 = Themes.TextDim,
    Font = Enum.Font.Gotham,
    TextSize = 10,
    TextXAlignment = Enum.TextXAlignment.Left,
    ZIndex = 4,
    Parent = Header,
})

local DiscordButton = New("TextButton", {
    Size = UDim2.new(0, 26, 0, 26),
    Position = UDim2.new(1, -68, 0.5, -13),
    BackgroundColor3 = Color3.fromRGB(28, 28, 34),
    Text = "",
    AutoButtonColor = false,
    ZIndex = 5,
    Parent = Header,
})
Round(DiscordButton, 5)
New("ImageLabel", {
    Size = UDim2.new(0, 14, 0, 14),
    Position = UDim2.new(0.5, -7, 0.5, -7),
    BackgroundTransparency = 1,
    Image = Icons.Discord,
    ImageColor3 = Themes.Discord,
    ZIndex = 6,
    Parent = DiscordButton,
})
DiscordButton.MouseEnter:Connect(function() Tween(DiscordButton, { BackgroundColor3 = Color3.fromRGB(88, 101, 242) }, 0.12) end)
DiscordButton.MouseLeave:Connect(function() Tween(DiscordButton, { BackgroundColor3 = Color3.fromRGB(28, 28, 34) }, 0.12) end)
DiscordButton.MouseButton1Click:Connect(function()
    pcall(function() setclipboard(Links.Discord) end)
    local img = DiscordButton:FindFirstChildOfClass("ImageLabel")
    if img then
        local orig = img.ImageColor3
        Tween(img, { ImageColor3 = Themes.Success }, 0.15)
        task.delay(1.2, function() Tween(img, { ImageColor3 = Themes.Discord }, 0.2) end)
    end
end)

local CloseButton = New("TextButton", {
    Size = UDim2.new(0, 26, 0, 26),
    Position = UDim2.new(1, -36, 0.5, -13),
    BackgroundColor3 = Color3.fromRGB(28, 28, 34),
    Text = "",
    AutoButtonColor  = false,
    ZIndex = 5,
    Parent = Header,
})
Round(CloseButton, 5)
New("ImageLabel", {
    Size = UDim2.new(0, 11, 0, 11),
    Position = UDim2.new(0.5, -5, 0.5, -6),
    BackgroundTransparency = 1,
    Image = Icons.Close,
    ImageColor3 = Themes.TextDim,
    ZIndex = 6,
    Parent = CloseButton,
})
CloseButton.MouseEnter:Connect(function() Tween(CloseButton, { BackgroundColor3 = Themes.Error }, 0.12) end)
CloseButton.MouseLeave:Connect(function() Tween(CloseButton, { BackgroundColor3 = Color3.fromRGB(28, 28, 34) }, 0.12) end)
CloseButton.MouseButton1Click:Connect(function() 
    CloseDoorAnimation(function()
        -- If they closed the UI manually before validating, halt everything!
        if not IS_VALIDATED then
            error("ScriptFarmer: Key System closed by user.")
        end
    end) 
end)

local TabBar = New("Frame", {
    Size = UDim2.new(1, 0, 0, TABBAR_HEIGHT),
    Position = UDim2.new(0, 0, 0, HEADER_HEIGHT),
    BackgroundColor3 = Themes.Header,
    BorderSizePixel  = 0,
    ZIndex = 3,
    Parent = Window,
})
New("Frame", {
    Size = UDim2.new(1, 0, 0, 1),
    Position = UDim2.new(0, 0, 1, -1),
    BackgroundColor3 = Themes.Divider,
    BorderSizePixel  = 0,
    ZIndex = 4,
    Parent = TabBar,
})

local TAB_WIDTH = math.floor(WINDOW_WIDTH / TAB_COUNT)

local TabPill = New("Frame", {
    Size = UDim2.new(0, TAB_WIDTH - 14, 0, 24),
    Position = UDim2.new(0, 7, 0.5, -12),
    BackgroundColor3 = Color3.fromRGB(38, 38, 48),
    BorderSizePixel  = 0,
    ZIndex = 4,
    Parent = TabBar,
})
Round(TabPill, 5)
Stroke(TabPill, Color3.fromRGB(52, 52, 62), 1, 0)

local TabDefinitions = {
    { label = "Key", icon = Icons.Key},
    { label = "User Info", icon = Icons.UserInfo},
  { label = "Changelog", icon = Icons.Changelog  },
}

local TabButtons = {}
local TabPages = {}
local ActiveTab = 0

local function ActivateTab(index)
    if index == ActiveTab then return end
    local previous = ActiveTab
    ActiveTab = index

    local pillX = (index - 1) * TAB_WIDTH + 7
    Spring(TabPill, { Position = UDim2.new(0, pillX, 0.5, -12) }, 0.28)

    for i, tabData in ipairs(TabButtons) do
        local isActive = i == index
        Tween(tabData.Label, { TextColor3   = isActive and Themes.Text   or Themes.TextDim }, 0.16)
        Tween(tabData.Icon,  { ImageColor3  = isActive and Themes.Accent or Themes.TextDim }, 0.16)
    end

    if previous > 0 then TabPages[previous].Visible = false end
    TabPages[index].Visible = true
end

for i, definition in ipairs(TabDefinitions) do
    local buttonX = (i - 1) * TAB_WIDTH

    local button = New("TextButton", {
        Size = UDim2.new(0, TAB_WIDTH, 1, 0),
        Position = UDim2.new(0, buttonX, 0, 0),
        BackgroundTransparency = 1,
        Text = "",
        AutoButtonColor  = false,
        ZIndex = 5,
        Parent = TabBar,
    })
    local tabInner = New("Frame", {
        Size = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        ZIndex = 6,
        Parent = button,
    })
    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 5),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = tabInner,
    })
    local icon = New("ImageLabel", {
        Size = UDim2.new(0, 13, 0, 13),
        BackgroundTransparency = 1,
        Image = definition.icon,
        ImageColor3 = Themes.TextDim,
        LayoutOrder = 1,
        ZIndex = 6,
        Parent = tabInner,
    })
    local labelObj = New("TextLabel", {
        Size = UDim2.new(0, 0, 0, 13),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Text = definition.label,
        TextColor3 = Themes.TextDim,
        Font = Enum.Font.GothamSemibold,
        TextSize = 11,
        LayoutOrder = 2,
        ZIndex = 6,
        Parent = tabInner,
    })

    TabButtons[i] = { Button = button, Label = labelObj, Icon = icon }

    local page = New("Frame", {
        Size = UDim2.new(1, 0, 0, CONTENT_H),
        Position = UDim2.new(0, 0, 0, CONTENT_Y),
        BackgroundTransparency = 1,
        Visible = false,
        ClipsDescendants = true,
        ZIndex = 3,
        Parent = Window,
    })
    TabPages[i] = page

    button.MouseButton1Click:Connect(function() ActivateTab(i) end)
end

local KeyPage = TabPages[1]
local UserInfoPage = TabPages[2]
local ChangelogPage = TabPages[3]

local function MakeScrollFrame(parent)
    local scroll = New("ScrollingFrame", {
        Size                   = UDim2.new(1, 0, 1, 0),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ScrollBarThickness = 3,
        ScrollBarImageColor3 = Color3.fromRGB(55, 55, 65),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ZIndex = 4,
        Parent = parent,
    })
    New("UIPadding", {
        PaddingTop    = UDim.new(0, INNER_PAD),
        PaddingBottom = UDim.new(0, INNER_PAD),
        PaddingLeft   = UDim.new(0, INNER_PAD),
        PaddingRight  = UDim.new(0, INNER_PAD + 2),
        Parent        = scroll,
    })
    New("UIListLayout", {
        SortOrder = Enum.SortOrder.LayoutOrder,
        Padding   = UDim.new(0, 8),
        Parent    = scroll,
    })
    return scroll
end

local function MakeCard(parent, height, layoutOrder)
    local card = New("Frame", {
        Size = UDim2.new(1, 0, 0, height),
        BackgroundColor3 = Themes.Card,
        BorderSizePixel  = 0,
        LayoutOrder = layoutOrder or 0,
        ZIndex = 5,
        Parent = parent,
    })
    Round(card, 6)
    return card
end

local function MakeDivider(parent, layoutOrder)
    return New("Frame", {
        Size = UDim2.new(1, 0, 0, 1),
        BackgroundColor3 = Themes.Divider,
        BorderSizePixel  = 0,
        LayoutOrder = layoutOrder or 0,
        ZIndex = 5,
        Parent = parent,
    })
end

local function MakeLabel(parent, text, font, size, color, alignX, extraProps)
    local props = {
        BackgroundTransparency = 1,
        Text = text,
        TextColor3 = color or Themes.Text,
        Font = font or Enum.Font.Gotham,
        TextSize = size or 12,
        TextXAlignment = alignX  or Enum.TextXAlignment.Left,
        ZIndex = 6,
        Parent = parent,
    }
    if extraProps then
        for k, v in pairs(extraProps) do props[k] = v end
    end
    return New("TextLabel", props)
end

local KeyScroll = MakeScrollFrame(KeyPage)

local InputCard = MakeCard(KeyScroll, 44, 1)
local InputStroke = Stroke(InputCard, Themes.Border, 1, 0)
New("ImageLabel", {
    Size = UDim2.new(0, 15, 0, 15),
    Position = UDim2.new(0, 11, 0.5, -7),
    BackgroundTransparency = 1,
    Image = Icons.KeyInput,
    ImageColor3 = Themes.TextDim,
    ZIndex = 7,
    Parent = InputCard,
})
local KeyBox = New("TextBox", {
    Size = UDim2.new(1, -34, 1, -2),
    Position = UDim2.new(0, 32, 0, 1),
    BackgroundTransparency = 1,
    Text = "",
    PlaceholderText = "Paste your key here...",
    TextColor3 = Themes.Text,
    PlaceholderColor3 = Themes.TextDim,
    Font = Enum.Font.GothamMedium,
    TextSize = 12,
    TextXAlignment = Enum.TextXAlignment.Left,
    ClearTextOnFocus = false,
    ZIndex = 7,
    Parent = InputCard,
})
KeyBox.Focused:Connect(function()
    Tween(InputStroke, { Color = Themes.Accent, Transparency = 0 }, 0.15)
end)
KeyBox.FocusLost:Connect(function()
    Tween(InputStroke, { Color = Themes.Border, Transparency = 0 }, 0.15)
end)
KeyBox:GetPropertyChangedSignal("Text"):Connect(function()
    local text = KeyBox.Text
    local len = #text
    if len == 0 then
        Tween(InputStroke, { Color = Themes.Border, Transparency = 0 }, 0.1)
        return
    end
    if len > 0 then
        Tween(InputStroke, { Color = Themes.Accent, Transparency = 0.3 }, 0.15)
    end
end)

local StatusCard = MakeCard(KeyScroll, 34, 2)
StatusCard.BackgroundColor3 = Color3.fromRGB(14, 14, 17)
Stroke(StatusCard, Themes.Divider, 1, 0)
local StatusDot = New("Frame", {
    Size = UDim2.new(0, 6, 0, 6),
    Position = UDim2.new(0, 11, 0.5, -3),
    BackgroundColor3 = Themes.Idle,
    BorderSizePixel  = 0,
    ZIndex = 6,
    Parent = StatusCard,
})
local _dotCorner = Instance.new("UICorner")
_dotCorner.CornerRadius = UDim.new(1, 0)
_dotCorner.Parent = StatusDot
local StatusLabel = MakeLabel(StatusCard, "Get a key, paste it below", Enum.Font.Gotham, 10, Themes.Idle, Enum.TextXAlignment.Left, {
    Size     = UDim2.new(1, -24, 1, 0),
    Position = UDim2.new(0, 22, 0, 0),
})

local ExpiryCard = MakeCard(KeyScroll, 28, 3)
ExpiryCard.BackgroundTransparency = 1
ExpiryCard.Visible = false
New("ImageLabel", {
    Size = UDim2.new(0, 12, 0, 12),
    Position = UDim2.new(0, 0, 0.5, -6),
    BackgroundTransparency = 1,
    Image = Icons.Clock,
    ImageColor3 = Themes.TextDim,
    ZIndex = 6,
    Parent = ExpiryCard,
})
local ExpiryLabel = MakeLabel(ExpiryCard, "", Enum.Font.Gotham, 10, Themes.TextDim, Enum.TextXAlignment.Left, {
    Size     = UDim2.new(1, -16, 1, 0),
    Position = UDim2.new(0, 16, 0, 0),
})

MakeDivider(KeyScroll, 4)

local GetKeyButton = New("TextButton", {
    Size = UDim2.new(1, 0, 0, 44),
    BackgroundColor3 = Themes.Pending,
    Text = "",
    AutoButtonColor = false,
    LayoutOrder = 5,
    ZIndex = 5,
    Parent = KeyScroll,
})
Round(GetKeyButton, 8)
Stroke(GetKeyButton, Themes.Border, 1, 0)
New("ImageLabel", {
    Size = UDim2.new(0, 16, 0, 16),
    Position = UDim2.new(0.5, -52, 0.5, -8),
    BackgroundTransparency = 1,
    Image = Icons.Key,
    ImageColor3 = Themes.TextDim,
    ZIndex = 6,
    Parent = GetKeyButton,
})
local GetKeyLabel = MakeLabel(GetKeyButton, "Get Key", Enum.Font.GothamBold, 13, Themes.TextDim, Enum.TextXAlignment.Left, {
    Size     = UDim2.new(0, 58, 0, 16),
    Position = UDim2.new(0.5, -28, 0.5, -8),
})

local RedeemButton = New("TextButton", {
    Size = UDim2.new(1, 0, 0, 44),
    BackgroundColor3 = Themes.Pending,
    Text = "",
    AutoButtonColor  = false,
    LayoutOrder = 6,
    ZIndex = 5,
    Parent = KeyScroll,
})
Round(RedeemButton, 8)
Stroke(RedeemButton, Themes.Border, 1, 0)
New("ImageLabel", {
    Size = UDim2.new(0, 16, 0, 16),
    Position = UDim2.new(0.5, -60, 0.5, -8),
    BackgroundTransparency = 1,
    Image = Icons.Redeem,
    ImageColor3 = Themes.TextDim,
    ZIndex = 6,
    Parent = RedeemButton,
})
local RedeemLabel = MakeLabel(RedeemButton, "Redeem Key", Enum.Font.GothamBold, 13, Themes.TextDim, Enum.TextXAlignment.Left, {
    Size = UDim2.new(0, 82, 0, 16),
    Position = UDim2.new(0.5, -36, 0.5, -8),
})

MakeDivider(KeyScroll, 7)

local ShopBanner = New("Frame", {
    Size = UDim2.new(1, 0, 0, 48),
    BackgroundColor3 = Themes.Pending,
    BorderSizePixel  = 0,
    LayoutOrder = 8,
    ZIndex = 5,
    Parent = KeyScroll,
})
Round(ShopBanner, 8)
local ShopLogoBg = New("Frame", {
    Size = UDim2.new(0, 32, 0, 32),
    Position = UDim2.new(0, 8, 0.5, -16),
    BackgroundColor3 = Themes.Input,
    BorderSizePixel  = 0,
    ZIndex = 6,
    Parent = ShopBanner,
})
Round(ShopLogoBg, 6)
New("ImageLabel", {
    Size = UDim2.new(0, 17, 0, 17),
    Position = UDim2.new(0.5, -8, 0.5, -9),
    BackgroundTransparency = 1,
    Image = Icons.Logo,
    ImageColor3 = Themes.Accent,
    ZIndex = 7,
    Parent = ShopLogoBg,
})
MakeLabel(ShopBanner, "Get Lifetime-Key NOW!!", Enum.Font.GothamBold, 11, Themes.Text, Enum.TextXAlignment.Left, {
    Size = UDim2.new(1, -100, 0, 16),
    Position = UDim2.new(0, 50, 0, 8),
})
MakeLabel(ShopBanner, "Fast Delivery｜24/7 Support", Enum.Font.Gotham, 10, Themes.TextDim, Enum.TextXAlignment.Left, {
    Size = UDim2.new(1, -100, 0, 14),
    Position = UDim2.new(0, 50, 0, 26),
})
local BuyButton = New("TextButton", {
    Size = UDim2.new(0, 44, 0, 26),
    Position = UDim2.new(1, -52, 0.5, -13),
    BackgroundColor3 = Themes.Input,
    Text = "BUY",
    TextColor3 = Themes.TextDim,
    Font = Enum.Font.GothamBold,
    TextSize = 10,
    AutoButtonColor  = false,
    ZIndex = 7,
    Parent = ShopBanner,
})
Round(BuyButton, 5)
Stroke(BuyButton, Color3.fromRGB(50, 50, 60), 1, 0)
BuyButton.MouseEnter:Connect(function() Tween(BuyButton, { BackgroundColor3 = Color3.fromRGB(34, 34, 42) }, 0.1) end)
BuyButton.MouseLeave:Connect(function() Tween(BuyButton, { BackgroundColor3 = Themes.Input }, 0.1) end)
BuyButton.MouseButton1Click:Connect(function()
    pcall(function() setclipboard(Links.BuyText) end)
    local originalText = BuyButton.TextColor3
    BuyButton.Text = "Copied!"
    BuyButton.TextColor3 = Themes.Success
    task.delay(1.4, function()
        BuyButton.Text = "BUY"
        BuyButton.TextColor3 = Themes.TextDim
    end)
end)

for _, btn in ipairs({ GetKeyButton, RedeemButton }) do
    btn.MouseEnter:Connect(function() Tween(btn, { BackgroundColor3 = Color3.fromRGB(36, 36, 44) }, 0.1) end)
    btn.MouseLeave:Connect(function() Tween(btn, { BackgroundColor3 = Themes.Pending }, 0.1) end)
end

local UserInfoScroll = MakeScrollFrame(UserInfoPage)

local AvatarCard = MakeCard(UserInfoScroll, 70, 1)
local AvatarImage = New("ImageLabel", {
    Size = UDim2.new(0, 44, 0, 44),
    Position = UDim2.new(0, 12, 0.5, -22),
    BackgroundColor3 = Themes.Pending,
    BackgroundTransparency = 0,
    BorderSizePixel = 0,
    Image = "",
    ZIndex = 6,
    Parent = AvatarCard,
})
Round(AvatarImage, 6)
Stroke(AvatarImage, Themes.Accent, 1.5, 0.5)
task.spawn(function()
    local success, url = pcall(function()
        return Players:GetUserThumbnailAsync(
            LocalPlayer.UserId,
            Enum.ThumbnailType.AvatarBust,
            Enum.ThumbnailSize.Size150x150
        )
    end)
    if success and url then AvatarImage.Image = url end
end)
MakeLabel(AvatarCard, "Welcome back,", Enum.Font.Gotham, 10, Themes.TextDim, Enum.TextXAlignment.Left, {
    Size     = UDim2.new(1, -68, 0, 14),
    Position = UDim2.new(0, 66, 0, 16),
})
MakeLabel(AvatarCard, LocalPlayer.DisplayName, Enum.Font.GothamBold, 14, Themes.Text, Enum.TextXAlignment.Left, {
    Size = UDim2.new(1, -68, 0, 18),
    Position = UDim2.new(0, 66, 0, 32),
    TextTruncate = Enum.TextTruncate.AtEnd,
})

local function InfoRow(labelText, valueText, layoutOrder)
    local card = MakeCard(UserInfoScroll, 34, layoutOrder)
    MakeLabel(card, labelText, Enum.Font.Gotham, 10, Themes.TextDim, Enum.TextXAlignment.Left, {
        Size = UDim2.new(0, 88, 1, 0),
        Position = UDim2.new(0, 12, 0, 0),
    })
    local valueLabel = MakeLabel(card, valueText, Enum.Font.GothamSemibold, 11, Themes.Text, Enum.TextXAlignment.Right, {
        Size = UDim2.new(1, -104, 1, 0),
        Position = UDim2.new(0, 92, 0, 0),
        TextTruncate = Enum.TextTruncate.AtEnd,
    })
    return valueLabel
end

local executorName = "Unknown"
if identifyexecutor then
    local success, name = pcall(identifyexecutor)
    if success and name then executorName = tostring(name) end
end
InfoRow("Executor", executorName, 2)
InfoRow("Device", IS_MOBILE and "Mobile" or "PC", 3)

local HWIDCard = MakeCard(UserInfoScroll, 34, 4)
MakeLabel(HWIDCard, "HWID", Enum.Font.Gotham, 10, Themes.TextDim, Enum.TextXAlignment.Left, {
    Size = UDim2.new(0, 50, 1, 0),
    Position = UDim2.new(0, 12, 0, 0),
})
local hwidValue = GetHWID()
local HWIDDots = MakeLabel(HWIDCard, string.rep("•", 18), Enum.Font.Gotham, 10, Themes.Text, Enum.TextXAlignment.Left, {
    Size     = UDim2.new(1, -84, 1, 0),
    Position = UDim2.new(0, 60, 0, 0),
})
local CopyButton = New("TextButton", {
    Size = UDim2.new(0, 22, 0, 22),
    Position = UDim2.new(1, -28, 0.5, -11),
    BackgroundColor3 = Themes.Pending,
    Text = "",
    AutoButtonColor  = false,
    ZIndex = 6,
    Parent = HWIDCard,
})
Round(CopyButton, 4)
New("ImageLabel", {
    Size = UDim2.new(0, 11, 0, 11),
    Position = UDim2.new(0.5, -5, 0.5, -6),
    BackgroundTransparency = 1,
    Image = Icons.Copy,
    ImageColor3 = Themes.TextDim,
    ZIndex = 7,
    Parent = CopyButton,
})
local alreadyCopied = false
CopyButton.MouseButton1Click:Connect(function()
    if alreadyCopied then return end
    alreadyCopied = true
    pcall(function() setclipboard(hwidValue) end)
    HWIDDots.Text = "Copied!"
    HWIDDots.TextColor3 = Themes.Success
    task.delay(1.5, function()
        alreadyCopied = false
        HWIDDots.Text = string.rep("｜", 18)
        HWIDDots.TextColor3 = Themes.Text
    end)
end)

MakeDivider(UserInfoScroll, 5)

local ClockCard = MakeCard(UserInfoScroll, 46, 6)
ClockCard.BackgroundColor3 = Color3.fromRGB(10, 10, 13)
local ClockTime = MakeLabel(ClockCard, "", Enum.Font.GothamBold, 17, Themes.Text, Enum.TextXAlignment.Center, {
    Size = UDim2.new(1, 0, 0, 22),
    Position = UDim2.new(0, 0, 0, 6),
})
local ClockDate = MakeLabel(ClockCard, "", Enum.Font.Gotham, 10, Themes.TextDim, Enum.TextXAlignment.Center, {
    Size = UDim2.new(1, 0, 0, 14),
    Position = UDim2.new(0, 0, 0, 30),
})
local MONTHS = {"Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"}
local clockConnection = RunService.Heartbeat:Connect(function()
    local timeData = os.date("*t")
    local hour = timeData.hour
    local ampm = hour >= 12 and "PM" or "AM"
    hour = hour % 12
    if hour == 0 then hour = 12 end
    ClockTime.Text = string.format("%d:%02d:%02d %s", hour, timeData.min, timeData.sec, ampm)
    ClockDate.Text = MONTHS[timeData.month] .. " " .. string.format("%02d", timeData.day) .. ", " .. timeData.year
end)
ScreenGui.Destroying:Connect(function()
    if clockConnection then clockConnection:Disconnect() end
    if BlurEffect then pcall(function() BlurEffect:Destroy() end) end
    if Options.BlockReExecute then getgenv().__SCRIPTFARMER_KS_OPEN = nil end
end)

local ChangelogScroll = MakeScrollFrame(ChangelogPage)

local ChangelogEntries = {
    { 
        Version = "v2.0.0", 
        Date = "July 25, 2026", 
        Changes = { 
            "Fixed All Bugs", 
            "Enhanced overall script performance", 
            "Script Now Support Executors Like Xeno" 
        } 
    }
}

for index, entry in ipairs(ChangelogEntries) do
    local CHANGE_ROW_H = 26
    local cardHeight = 40 + #entry.Changes * CHANGE_ROW_H + 8
    local card = MakeCard(ChangelogScroll, cardHeight, index)

    local badge = New("Frame", {
        Size = UDim2.new(0, 0, 0, 20),
        Position = UDim2.new(0, 10, 0, 10),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundColor3 = Themes.Pending,
        BorderSizePixel = 0,
        ZIndex = 6,
        Parent = card,
    })
    Round(badge, 4)
    New("UIPadding", {
        PaddingLeft  = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        Parent = badge,
    })
    New("TextLabel", {
        Size = UDim2.new(0, 0, 1, 0),
        AutomaticSize = Enum.AutomaticSize.X,
        BackgroundTransparency = 1,
        Text = entry.Version,
        TextColor3 = index == 1 and Themes.Accent or Themes.TextDim,
        Font = Enum.Font.GothamBold,
        TextSize = 11,
        ZIndex = 7,
        Parent = badge,
    })
    if index == 1 then
        Stroke(badge, Themes.Accent, 1, 0.45)
    end

    MakeLabel(card, entry.Date, Enum.Font.Gotham, 10, Themes.TextDim, Enum.TextXAlignment.Right, {
        Size     = UDim2.new(1, -12, 0, 20),
        Position = UDim2.new(0, 0, 0, 10),
    })

    for i, changeText in ipairs(entry.Changes) do
        local dotY = 40 + (i - 1) * CHANGE_ROW_H + 10
        local dot = New("Frame", {
            Size = UDim2.new(0, 3, 0, 3),
            Position = UDim2.new(0, 13, 0, dotY),
            BackgroundColor3 = Themes.TextDim,
            BorderSizePixel  = 0,
            ZIndex = 6,
            Parent = card,
        })
        Round(dot, 2)
        New("TextLabel", {
            Size = UDim2.new(1, -26, 0, CHANGE_ROW_H),
            Position = UDim2.new(0, 24, 0, 40 + (i - 1) * CHANGE_ROW_H),
            BackgroundTransparency = 1,
            Text = changeText,
            TextColor3 = Themes.Text,
            Font = Enum.Font.Gotham,
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            ZIndex = 6,
            Parent = card,
        })
    end
end

local function SetStatus(message, statusType)
    local color = statusType == "success" and Themes.Success
               or statusType == "error"   and Themes.Error
               or statusType == "warning" and Themes.Warning
               or Themes.Idle
    Tween(StatusDot,   { BackgroundColor3 = color }, 0.12)
    Tween(StatusLabel, { TextColor3       = color }, 0.12)
    StatusLabel.Text = message
end

local function ShakeInput()
    local orig = InputCard.Position
    local ox = orig.X.Offset
    for _, offset in ipairs({ 5, -5, 3, -3, 1, -1, 0 }) do
        InputCard.Position = UDim2.new(orig.X.Scale, ox + offset, orig.Y.Scale, orig.Y.Offset)
        task.wait(0.025)
    end
    InputCard.Position = orig
end

local processing = false

-- [ UPDATED TryValidate TO USE JUNKIE SDK CHECK ]
local function TryValidate(key)
    if not key or #key == 0 then
        SetStatus("Enter a key first", "warning")
        ShakeInput()
        return
    end
    if processing then return end
    if TouchCooldown("_ASCEND_KS_LOCK", 0.8) then return end

    if not Junkie then
        SetStatus("SDK loading, please wait...", "warning")
        ShakeInput()
        return
    end

    processing = true
    RedeemLabel.Text    = "Checking..."
    RedeemButton.Active = false
    Tween(RedeemButton, { BackgroundColor3 = Color3.fromRGB(24, 24, 30) }, 0.15)
    Tween(InputStroke,  { Color = Themes.Border, Transparency = 0 }, 0.15)

    -- Call Junkie Backend
    local validation = Junkie.check_key(key)

    if validation and (validation.valid or validation.success) then
        -- KEY SUCCESSFUL
        SaveKey(key)
        getgenv().SCRIPT_KEY = key
        IS_VALIDATED = true  -- <-- Flags the loop to let the main script run
        
        print("ScriptFarmer | Key accepted via Junkie Backend.")

        SetStatus("Key Accepted", "success")
        Tween(InputCard,    { BackgroundColor3 = Color3.fromRGB(10, 28, 18) }, 0.2)
        Tween(InputStroke,  { Color = Themes.Success, Transparency = 0 }, 0.2)
        Tween(RedeemButton, { BackgroundColor3 = Color3.fromRGB(16, 46, 28) }, 0.2)
        RedeemLabel.Text = "Redeemed"
        RedeemLabel.TextColor3 = Themes.Success

        if getgenv then getgenv()._ASCEND_KS_LOCK = nil end
        processing = false

        if Options.AutoClose then
            task.delay(1.25, function() CloseDoorAnimation() end)
        end
    else
        -- KEY FAILED
        local errorMsg = validation and validation.error or "Unknown Error"
        local displayMsg = "Invalid Key"
        
        -- Map specific Junkie errors to UI friendly text
        if errorMsg == "KEY_INVALID" then displayMsg = "Key not found in system"
        elseif errorMsg == "KEY_EXPIRED" then displayMsg = "Key expired - get a new one"
        elseif errorMsg == "HWID_BANNED" then 
            displayMsg = "Hardware banned"
            pcall(function() game.Players.LocalPlayer:Kick("Hardware banned") end)
        elseif errorMsg == "KEY_INVALIDATED" then displayMsg = "Key was manually disabled"
        elseif errorMsg == "ALREADY_USED" then displayMsg = "One-time key already used"
        elseif errorMsg == "HWID_MISMATCH" then displayMsg = "HWID limit reached"
        elseif errorMsg == "SERVICE_NOT_FOUND" then displayMsg = "Service doesn't exist"
        elseif errorMsg == "SERVICE_MISMATCH" then displayMsg = "Key is for a different service"
        elseif errorMsg == "PREMIUM_REQUIRED" then displayMsg = "Premium key required"
        elseif errorMsg == "ERROR" then displayMsg = "Network error - try again"
        elseif errorMsg:match("^http %d+") then displayMsg = "Server error: " .. errorMsg
        else displayMsg = "Invalid: " .. tostring(errorMsg) end

        SetStatus(displayMsg, "error")
        Tween(InputStroke, { Color = Themes.Error, Transparency = 0 }, 0.15)
        ShakeInput()
        
        task.delay(0.5, function() Tween(InputStroke, { Color = Themes.Border, Transparency = 0 }, 0.3) end)
        RedeemLabel.Text       = "Redeem Key"
        RedeemLabel.TextColor3 = Themes.TextDim
        RedeemButton.Active    = true
        Tween(RedeemButton, { BackgroundColor3 = Themes.Pending }, 0.15)
        if getgenv then getgenv()._ASCEND_KS_LOCK = nil end
        processing = false
    end
end

-- [ UPDATED GetKey TO USE JUNKIE SDK LINK GENERATOR ]
GetKeyButton.MouseButton1Click:Connect(function()
    if processing then return end
    if TouchCooldown("_ASCEND_GETCD", 0.6) then return end
    GetKeyButton.Active = false

    if not Junkie then
        SetStatus("Loading SDK... try again", "warning")
        task.delay(1.5, function() GetKeyButton.Active = true end)
        return
    end

    SetStatus("Opening link...", "warning")
    local ok, link_or_err = pcall(function() return Junkie.get_key_link() end)
    
    if ok and type(link_or_err) == "string" and link_or_err:match("^http") then
        pcall(function() setclipboard(link_or_err) end)
        SetStatus("Link copied  ｜  complete steps & paste key", "success")
        HeaderSubtitle.Text = "Complete steps then paste your key"
    else
        -- If Junkie rate limited us
        local errorTxt = link_or_err == "RATE_LIMITTED" and "Rate limited  ｜  wait 5 mins" or "Error getting link"
        SetStatus(errorTxt, "error")
    end

    task.delay(0.7, function() GetKeyButton.Active = true end)
end)

RedeemButton.MouseButton1Click:Connect(function()
    if TouchCooldown("_ASCEND_RDMCD", 0.5) then return end
    TryValidate(KeyBox.Text)
end)

KeyBox.FocusLost:Connect(function(enterPressed)
    if enterPressed then TryValidate(KeyBox.Text) end
end)

local savedKey = LoadKey()
if savedKey and #savedKey > 0 then
    KeyBox.Text = savedKey
    if Options.AutoLoad then
        SetStatus("Checking saved key...", "warning")
        task.delay(0.6, function() TryValidate(savedKey) end)
    else
        SetStatus("Saved key loaded", "warning")
    end
end

do
    local vp = workspace.CurrentCamera.ViewportSize
    Window.Position = UDim2.new(0,
        math.floor(vp.X / 2 - WINDOW_WIDTH  / 2), 0,
        math.floor(vp.Y / 2 - WINDOW_HEIGHT / 2)
    )
end

ActivateTab(1)
print("ScriptFarmer | Key system loaded")

task.spawn(function()
    local ContentProvider = service.ContentProvider
    local preloadInstances = {}
    for _, icon in pairs(Icons) do
        local img = Instance.new("ImageLabel")
        img.Image = icon
        table.insert(preloadInstances, img)
    end
    pcall(function() ContentProvider:PreloadAsync(preloadInstances) end)
    for _, img in ipairs(preloadInstances) do img:Destroy() end
end)

task.wait(0.1)
OpenDoorAnimation()

-- ================================================================
-- [ THE FIX: WAIT UNTIL THE FLAG 'IS_VALIDATED' IS TRUE ]
-- ================================================================
print("ScriptFarmer | Waiting for valid key...")
repeat 
    task.wait(0.1) 
until IS_VALIDATED == true
print("ScriptFarmer | Key verified, continuing script execution!")

if Options.BlockReExecute then
    getgenv().__SCRIPTFARMER_KS_OPEN = nil
end

do ("JNKIE Loader - Unauthorized tampering or debugging of protected scripts is strictly prohibited and may result in a global blacklist from JNKIE protected scripts."):sub(1,1);local k=getgenv().SCRIPT_KEY or SCRIPT_KEY;local m="Could not load the script. Check your internet connection and try again later.";local function v(h)warn(h);task.spawn(function()pcall(function()game:GetService("Players").LocalPlayer:Kick(h)end);task.wait();pcall(function()local p=game:GetService("CoreGui").RobloxPromptGui.promptOverlay.ErrorPrompt;p.TitleFrame.ErrorTitle.Text="JNKIE";p.MessageArea.ErrorFrame.ErrorMessage.Text=h end)end)end;local r=(type(syn)=="table" and type(syn.request)=="function" and syn.request)or(type(request)=="function" and request)or(type(http_request)=="function" and http_request)or(type(http)=="table" and type(http.request)=="function" and http.request);if type(k)~="string" then v("No key provided. Get a key from the script provider, enter it, then try again.");return end;if type(r)~="function" then warn(m);return end;local function q(o)local d,a,x;task.spawn(function()a,x=pcall(r,o);d=true end);local s=os.clock();repeat task.wait()until d or os.clock()-s>15;if not d then return false,nil end;return a,x end;local a,x=q({Url="https://api.jnkie.com/api/v1/luascripts/delivery/738d2f252b6cc61416487e8ec5a094d29c0eda19f1415d68a4c770aef3a6de6d?v=2&errors=text",Method="POST",Headers={["Content-Type"]="text/plain"},Body=k});local h=a and type(x)=="table" and type(x.Body)=="string" and(x.StatusCode==400 or x.StatusCode==401 or x.StatusCode==403)and x.Body;if h then local c,n=h:match("^([^\r\n]+)\n([^\r\n]+)$");c=c or h;if#c<=75 and(c=="LDR-DENIED"or c:match("^LDR%-DENIED:[A-Z_]+$"))then if not n or#n>512 then n=m;if k==""or k:match("^%s*$")then n="No key provided. Get a key from the script provider, enter it, then try again." end end;v(n.." ("..c..")");return end end;if a and type(x)=="table" and x.StatusCode==200 and type(x.Body)=="string" and (string.sub(x.Body,1,8)=="https://") then a,x=q({Url=x.Body,Method="GET"})end;if a and type(x)=="table" and(x.StatusCode==302 or x.StatusCode==303)then local h=x.Headers or x.headers;local l=type(h)=="table" and(h.Location or h.location);if type(l)=="string" and (string.sub(l,1,8)=="https://") then a,x=q({Url=l,Method="GET"})end end;if not a or type(x)~="table" or x.StatusCode~=200 or type(x.Body)~="string" or#x.Body==0 then warn(m);return end;local b=x.Body;x=nil;local f=loadstring(b);b=nil;if type(f)~="function" then warn(m);return end;f()end