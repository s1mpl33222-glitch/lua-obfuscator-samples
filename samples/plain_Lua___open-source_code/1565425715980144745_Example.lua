--!unstack
--!stacking
-- Just a note: some elements/features in this script are only for performance testing and real-time testing, tabs like Empty and Premium are just documentation for Emptystate and dynamic adding, you can freely modify these and delete anything you want. 
local Fluent = loadstring(game:HttpGet("https://github.com/StyearX/Fluent-Modded/releases/download/1.6.0/main.lua"))()

Workspace = game:GetService("Workspace")
RunService = game:GetService("RunService")
Players = game:GetService("Players")
Lighting = game:GetService("Lighting")
StarterGui = game:GetService("StarterGui")
ReplicatedStorage = game:GetService("ReplicatedStorage")
Camera = Workspace.CurrentCamera
LocalPlayer = Players.LocalPlayer
UserInputService = game:GetService("UserInputService")
TweenService = game:GetService("TweenService")
PathfindingService = game:GetService("PathfindingService")
CAS = game:GetService("ContextActionService")
HttpService = game:GetService("HttpService")
TeleportService = game:GetService("TeleportService")
MarketplaceService = game:GetService("MarketplaceService")
Stats = game:GetService("Stats")
Sounds = game:GetService("SoundService")

isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled and not UserInputService.KeyboardEnabled

function Notify(Title, Content, Status, Icon, Duration)
    Fluent:Notify({
        Title = Title,
        Content = Content,
        SubContent = Status,
        Image = Icon,
        Duration = Duration or 3,
    })
end

local ExecutorName, ExecutorVersion = "Unknown", ""
task.spawn(function()
    pcall(function()
        if identifyexecutor then
            ExecutorName, ExecutorVersion = identifyexecutor()
        elseif getexecutorname then
            ExecutorName = getexecutorname()
        end
    end)
    Notify(
        "GoonWares",
        string.format("Player: %s | Executor: %s %s", LocalPlayer.Name, ExecutorName or "Unknown", ExecutorVersion or ""),
        "Info",
        nil,
        6
    )
end)

-- the script below is the Built-in Minimazer 
local Minimizer = Fluent:CreateMinimizer({
    Icon = "rbxassetid://109639117875913",
    Size = UDim2.fromOffset(64, 64),
    Position = UDim2.new(0.101969875, 0, 0.110441767, 0),
    Corner = 12,
    BackgroundTransparency = 1,
    IconCorner = 6,
    Transparency = 0,
    Lockable = true,
    LockHoldTime = 1.0,
    Draggable = true,
    OnClickSound = {
        "7127123605", "137566474343039", "438666542",
        "257001341", "257000833", "7127123554",
        "131607746976396", "97325669841459", "109312518223078",
    },
})

Minimizer.Visible = true

-- the script below is my custom Minimazer you can freely modify it frr
local Assets = {
    ["Dark"]          = "rbxassetid://112989097449975",
    ["Charcoal"]      = "rbxassetid://100096489709504",
    ["Pearl White"]   = "rbxassetid://91320093440746",
    ["Blood Red"]     = "rbxassetid://82205615960902",
    ["Neon Purple"]   = "rbxassetid://122136578005735",
    ["Deep Ocean"]    = "rbxassetid://125419002163537",
    ["Midnight Blue"] = "rbxassetid://117942410949253",
    ["Royal Blue"]    = "rbxassetid://102100010369948",
    ["Deep Violet"]   = "rbxassetid://78622715445158",
    ["Rose"]          = "rbxassetid://123035916719169",
    ["Neon Cyber"]    = "rbxassetid://121871712581976",
    ["Arctic Frost"]  = "rbxassetid://133933491104820",
    ["Cotton Candy"]  = "rbxassetid://128869678908856",
    ["Cyanic"]        = "rbxassetid://78285794098636",
    ["Amber Glow"]    = "rbxassetid://81215128277340",
    ["Bloomings"]     = "rbxassetid://138908725318095",
    ["Crimson"]       = "rbxassetid://73057086743861",
    ["Gold"]          = "rbxassetid://100401168268376",
    ["Lavender Pink"] = "rbxassetid://126095928220634",
}

local OpenShit = Instance.new("ScreenGui")
OpenShit.Name = "OpenShit"
OpenShit.Parent = game.CoreGui
OpenShit.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
OpenShit.ResetOnSpawn = false

local MainOpen = Instance.new("TextButton")
MainOpen.Name = "MainOpen"
MainOpen.Parent = OpenShit
MainOpen.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainOpen.BackgroundTransparency = 1
MainOpen.Position = UDim2.new(0.101969875, 0, 0.110441767, 0)
MainOpen.Size = UDim2.new(0, 64, 0, 42)
MainOpen.Text = ""
MainOpen.Visible = true

local MainOpenCorner = Instance.new("UICorner")
MainOpenCorner.Parent = MainOpen

local BackgroundImage = Instance.new("ImageLabel")
BackgroundImage.Name = "RotatingBackground"
BackgroundImage.Parent = MainOpen
BackgroundImage.Size = UDim2.new(2.7, 0, 2.7, 0)
BackgroundImage.Position = UDim2.new(0.5, 0, 0.5, 0)
BackgroundImage.AnchorPoint = Vector2.new(0.5, 0.5)
BackgroundImage.BackgroundTransparency = 1
BackgroundImage.Image = ""
BackgroundImage.SizeConstraint = Enum.SizeConstraint.RelativeXX
BackgroundImage.ZIndex = 0

local FrontImage = Instance.new("ImageLabel")
FrontImage.Name = "StaticIcon"
FrontImage.Parent = MainOpen
FrontImage.Size = UDim2.new(1, 0, 1.2, 0)
FrontImage.Position = UDim2.new(0.5, 0, 0.5, 0)
FrontImage.AnchorPoint = Vector2.new(0.5, 0.5)
FrontImage.BackgroundTransparency = 1
FrontImage.Image = "rbxassetid://109639117875913"
FrontImage.ZIndex = 1

local FrontCorner = Instance.new("UICorner")
FrontCorner.CornerRadius = UDim.new(1, 0)
FrontCorner.Parent = FrontImage

local Rotation = 0
local Speed = 90
local LastTime = tick()

task.spawn(function()
    while true do
        local Now = tick()
        local Delta = Now - LastTime
        LastTime = Now
        Rotation = (Rotation + Speed * Delta) % 360
        BackgroundImage.Rotation = Rotation
        task.wait()
    end
end)

local function UpdateTheme(ThemeName)
    BackgroundImage.Image = Assets[ThemeName] or ""
end

local LastTheme = nil
task.spawn(function()
    while true do
        task.wait(0.1)
        if not (Fluent and Fluent.Theme) then continue end
        local CurrentTheme = Fluent.Theme
        if CurrentTheme ~= LastTheme then
            LastTheme = CurrentTheme
            UpdateTheme(CurrentTheme)
        end
    end
end)

local function MakeDraggable(TopbarObject, Object, Locked)
    local Dragging = false
    local DragInput
    local DragStart
    local StartPosition
    local Holding = false
    local HoldTime = 1.0
    local MoveCancelThreshold = 6
    local HoldToken = 0

    Object:SetAttribute("Locked", Locked or false)

    local function Update(Input)
        if Object:GetAttribute("Locked") then return end
        local Delta = Input.Position - DragStart
        Object.Position = UDim2.new(
            StartPosition.X.Scale,
            StartPosition.X.Offset + Delta.X,
            StartPosition.Y.Scale,
            StartPosition.Y.Offset + Delta.Y
        )
    end

    local function ToggleLock()
        local NewState = not Object:GetAttribute("Locked")
        Object:SetAttribute("Locked", NewState)
        if Fluent then
            Fluent:Notify({
                Title = NewState and "Button Locked" or "Button Unlocked",
                Content = NewState and "This button is now locked in place." or "This button can now be moved.",
                Duration = 2
            })
        end
    end

    TopbarObject.InputBegan:Connect(function(Input)
        if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then return end
        Dragging = not Object:GetAttribute("Locked")
        Holding = true
        DragStart = Input.Position
        StartPosition = Object.Position
        HoldToken += 1
        local Token = HoldToken
        task.delay(HoldTime, function()
            if Holding and Token == HoldToken then ToggleLock() end
        end)
        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                Dragging = false
                Holding = false
            end
        end)
    end)

    TopbarObject.InputChanged:Connect(function(Input)
        if not DragStart then return end
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            if (Input.Position - DragStart).Magnitude > MoveCancelThreshold then Holding = false end
            DragInput = Input
        end
    end)

    game:GetService("UserInputService").InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then Update(Input) end
    end)
end

MakeDraggable(MainOpen, MainOpen, false)

local function PlaySound(SoundId)
    local Sound = Instance.new("Sound")
    Sound.SoundId = "rbxassetid://" .. SoundId
    Sound.Parent = game:GetService("SoundService")
    Sound:Play()
    Sound.Ended:Connect(function() Sound:Destroy() end)
end

MainOpen.MouseButton1Click:Connect(function()
    local Sounds = { "7127123605", "137566474343039", "438666542", "257001341", "257000833", "7127123554", "131607746976396", "97325669841459", "109312518223078" }
    PlaySound(Sounds[math.random(#Sounds)])
    if Window then Window:Minimize() end
    local function SmoothSpeed(Target, Duration)
        local Start = Speed
        local Steps = 30
        for I = 1, Steps do
            Speed = Start + (Target - Start) * (I / Steps)
            task.wait(Duration / Steps)
        end
        Speed = Target
    end
    SmoothSpeed(360, 0.4)
    task.wait(0.5)
    SmoothSpeed(180, 0.4)
    task.wait(0.3)
    SmoothSpeed(90, 0.4)
end)

Fluent:AddTheme({
    Name = "Dark Violet",
    Accent = "#7850c8",
    AcrylicMain = "#141414",
    AcrylicBorder = "#0f0f0f",
    AcrylicGradient = ColorSequence.new(Color3.fromHex("#191919"), Color3.fromHex("#0a0a0a")),
    AcrylicNoise = 0.9,
    TitleBarLine = "#6433b4",
    Tab = "#8256d2",
    Element = "#6e46be",
    ElementBorder = "#5a32aa",
    InElementBorder = "#8c64dc",
    ElementTransparency = 0.9,
    ElementBorderThickness = 0.5,
    ToggleSlider = "#6433b4",
    ToggleToggled = "#966ee6",
    SliderRail = "#502890",
    CheckboxUnchecked = "#5a32aa",
    CheckboxChecked = "#8c64dc",
    CheckboxCheck = "#c8aaff",
    ProgressBarRail = "#461e96",
    ProgressBarFill = "#a078f0",
    DropdownFrame = "#6433b4",
    DropdownHolder = "#6e46be",
    DropdownBorder = "#502890",
    DropdownOption = "#7850c8",
    DropdownBorderThickness = 0.5,
    Keybind = "#8256d2",
    Input = "#6433b4",
    InputFocused = "#966ee6",
    InputIndicator = "#aa82fa",
    Dialog = "#6e46be",
    DialogHolder = "#8256d2",
    DialogHolderLine = "#5a32aa",
    DialogButton = "#8c64dc",
    DialogButtonBorder = "#502890",
    DialogBorder = "#7850c8",
    DialogInput = "#6433b4",
    DialogInputLine = "#966ee6",
    Text = "#dcc8ff",
    SubText = "#b4a0dc",
    Hover = "#a078f0",
    HoverChange = 0.5,
    Background = "https://raw.githubusercontent.com/StyearX/Assets/main/Test.png",
    BackgroundTransparency = 0,
    ViewportBackground = Color3.fromHex("#281450"),
    ViewportBackgroundImages = false,
    DropdownOutsideWindowBackground = Color3.fromHex("#1e0f3c"),
    DropdownOutsideWindowBackgroundImages = false,
    ShineEnabled = true,
    Shine = {
        Speed = 2.5,
        RotationSpeed = 1.0,
        ColorSequence = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromHex("#1e1e1e")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#503296")),
            ColorSequenceKeypoint.new(1,   Color3.fromHex("#1e1e1e")),
        }),
    },
    StrokeShine = true,
    StrokeDark = Color3.fromHex("#3c1e78"),
    ButtonGradient = {
        Background = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#191919")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#503296")),
        }),
        Stroke = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromHex("#0f0f0f")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#3c1e78")),
            ColorSequenceKeypoint.new(1,   Color3.fromHex("#0f0f0f")),
        }),
    },
    DiscordJoinButton = "#7850c8",
    WarningNotifyColor = "#b478ff",
    SuccessNotifyColor = "#a0c8ff",
    ErrorNotifyColor = "#c864c8",
    InfoNotifyColor = "#8c64dc",
})

Fluent:AddTheme({
    Name = "Monochrome Noir",
    Accent = "#b4b4c3",
    AcrylicMain = "#0c0c0e",
    AcrylicBorder = "#28282d",
    AcrylicGradient = ColorSequence.new({
        ColorSequenceKeypoint.new(0,    Color3.fromHex("#0a0a0c")),
        ColorSequenceKeypoint.new(0.33, Color3.fromHex("#121216")),
        ColorSequenceKeypoint.new(0.66, Color3.fromHex("#16161c")),
        ColorSequenceKeypoint.new(1,    Color3.fromHex("#19191e")),
    }),
    AcrylicNoise = 0.9,
    TitleBarLine = "#50505f",
    Tab = "#141417",
    Element = "#121215",
    ElementBorder = "#323237",
    InElementBorder = "#232328",
    ElementTransparency = 0.92,
    ElementBorderThickness = 1,
    ToggleSlider = "#37373c",
    ToggleToggled = "#c8c8d7",
    SliderRail = "#2d2d32",
    CheckboxUnchecked = "#28282d",
    CheckboxChecked = "#c8c8d7",
    CheckboxCheck = "#0f0f12",
    ProgressBarRail = "#232328",
    ProgressBarFill = "#c8c8d7",
    DropdownFrame = "#0f0f12",
    DropdownHolder = "#141418",
    DropdownBorder = "#323237",
    DropdownOption = "#19191d",
    DropdownBorderThickness = 1,
    Keybind = "#1e1e22",
    Input = "#141418",
    InputFocused = "#1e1e23",
    InputIndicator = "#b4b4c3",
    Dialog = "#0e0e11",
    DialogHolder = "#141418",
    DialogHolderLine = "#323237",
    DialogButton = "#32323a",
    DialogButtonBorder = "#4b4b55",
    DialogBorder = "#2d2d32",
    DialogInput = "#16161a",
    DialogInputLine = "#a0a0af",
    Text = "#ebebf0",
    SubText = "#8c8c94",
    Hover = "#232328",
    HoverChange = 0.06,
    Background = "https://raw.githubusercontent.com/StyearX/Assets/main/backgrounds.png",
    BackgroundTransparency = 0,
    ShineEnabled = true,
    Shine = {
        Speed = 3,
        RotationSpeed = 1.5,
        ColorSequence = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromHex("#000000")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#c8c8d7")),
            ColorSequenceKeypoint.new(1,   Color3.fromHex("#000000")),
        }),
    },
    StrokeShine = true,
    StrokeDark = Color3.fromHex("#19191e"),
    ButtonGradient = {
        Background = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromHex("#2d2d34")),
            ColorSequenceKeypoint.new(1, Color3.fromHex("#19191e")),
        }),
        Stroke = ColorSequence.new({
            ColorSequenceKeypoint.new(0,   Color3.fromHex("#646473")),
            ColorSequenceKeypoint.new(0.5, Color3.fromHex("#41414b")),
            ColorSequenceKeypoint.new(1,   Color3.fromHex("#646473")),
        }),
    },
    DiscordJoinButton = "#5865f2",
    WarningNotifyColor = "#c8a028",
    SuccessNotifyColor = "#3cb45a",
    ErrorNotifyColor = "#c83232",
    InfoNotifyColor = "#5096dc",
})

Window = Fluent:CreateWindow({
    Title = "GoonWares",
    TabWidth = isMobile and 130 or 150,
    SubTitle = "Made by: StyearX",
    Acrylic = true,
    Size = isMobile and UDim2.fromOffset(640, 640) or UDim2.fromOffset(680, 680),
    Theme = "Basically Pink",
    Background = true,
    Tags = {
        { Text = ExecutorName, Color = Color3.fromRGB(255, 100, 180) },
        { Text = "Hello " .. tostring(LocalPlayer.DisplayName), Color = Color3.fromRGB(0, 0, 0) },
    },
    Font = "GothamSSm",
    TitleIcon = "rbxassetid://77838416429094",
    Search = {
        Search = true,
        Highlight = true,
        HighlightColor = Color3.fromRGB(180, 10, 20),
    },
    UserInfo = {
        UserInfo = true,
        UserInfoTitle = LocalPlayer.Name,
        UserInfoSubtitle = LocalPlayer.DisplayName,
        UserInfoColor = Color3.fromRGB(180, 10, 20),
    },
    Anonymous = {
        Default = false,
        ShowAno = true,
        AnoUserInfoTitle = "Hide For You",
        AnoUserInfoSubTitle = "Holy moly",
        Icons = "rbxassetid://77838416429094",
    },
    FolderName = "GoonWares",
    ScreenGuiName = "GoonWares",
})

Tabs = {
    Divider       = Window:AddDividerTabs(),
    Main       = Window:AddTab({ Title = "Main", Icon = "circle-dot" }),
    Divider       = Window:AddDividerTabs(),
    Combat     = Window:AddTab({ Title = "Combat", Icon = "swords" }),
    Divider       = Window:AddDividerTabs(),
    Extensions = Window:AddTab({ Title = "Extensions", Icon = "blocks" }),
    Visual     = Window:AddTabsInHeader({ Title = " Visual", Icon = "image" }),
    Misc       = Window:AddTabsInHeader({ Title = " Misc", Icon = "diamond" }),
    Info       = Window:AddTabsInHeader({ Title = " Info", Icon = "info" }),
    Divider       = Window:AddDividerTabs(),
    empty     = Window:AddTab({ Title = " empty", Icon = "info" }),
    Divider       = Window:AddDividerTabs(),
    Settings   = Window:AddTabsInHeader({ Title = " Configuration", Icon = "settings" }),
    Premium = Window:AddTab({ Title = "Premium" }),
    Divider       = Window:AddDividerTabs(),
}

Tabs.empty:SetEmptyState({
    Text = "Nothing Here Sucker",
    SubText = "Nothing Here Tabs empty",
    Icon = "lucide/face-angry",
})

Fluent.NotifyInsideWindow = true

FpsData = {
    GUI = nil,
    Connection = nil,
    AnimatedConnections = {},
    ShineCheckConnection = nil,
    Enabled = true
}

local FpsStartTime = tick()

local function MakeDraggableFps(TopbarObject, Object, Locked, Fluent)
    local Dragging, DragInput, DragStart, StartPosition = false, nil, nil, nil
    local Holding, HoldTime, MoveCancelThreshold, HoldToken = false, 1.0, 6, 0
    Object:SetAttribute("Locked", Locked or false)

    local function Update(Input)
        if Object:GetAttribute("Locked") then return end
        local Delta = Input.Position - DragStart
        Object.Position = UDim2.new(StartPosition.X.Scale, StartPosition.X.Offset + Delta.X, StartPosition.Y.Scale, StartPosition.Y.Offset + Delta.Y)
    end

    local function ToggleLock()
        local NewState = not Object:GetAttribute("Locked")
        Object:SetAttribute("Locked", NewState)
        if Fluent and Fluent.Notify then
            Fluent:Notify({
                Title = NewState and "Button Locked" or "Button Unlocked",
                Content = NewState and "Locked in place." or "Can now be moved.",
                Duration = 2,
            })
        end
    end

    TopbarObject.InputBegan:Connect(function(Input)
        if Input.UserInputType ~= Enum.UserInputType.MouseButton1 and Input.UserInputType ~= Enum.UserInputType.Touch then return end
        Dragging = not Object:GetAttribute("Locked")
        Holding = true
        DragStart = Input.Position
        StartPosition = Object.Position
        HoldToken += 1
        local Token = HoldToken
        task.delay(HoldTime, function()
            if Holding and Token == HoldToken then ToggleLock() end
        end)
        Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                Dragging = false
                Holding = false
            end
        end)
    end)

    TopbarObject.InputChanged:Connect(function(Input)
        if not DragStart then return end
        if Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch then
            if (Input.Position - DragStart).Magnitude > MoveCancelThreshold then Holding = false end
            DragInput = Input
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then Update(Input) end
    end)
end

local function SetupFpsAnimations(Frame, Gradient, GradientStroke, UIStroke, BackgroundGradient, DividerFrames, DividerGradients, LabelGradients, Fluent)
    for _, conn in ipairs(FpsData.AnimatedConnections) do
        pcall(function() conn:Disconnect() end)
    end
    FpsData.AnimatedConnections = {}

    if FpsData.ShineCheckConnection then
        pcall(function() FpsData.ShineCheckConnection:Disconnect() end)
        FpsData.ShineCheckConnection = nil
    end

    local t = 0
    local lastShineState = Fluent and Fluent.ShineEnabled == true

    local conn = RunService.RenderStepped:Connect(function(dt)
        if not Frame or not Frame.Parent then
            for _, c in ipairs(FpsData.AnimatedConnections) do
                pcall(function() c:Disconnect() end)
            end
            FpsData.AnimatedConnections = {}
            return
        end

        local Animated = Fluent and Fluent.ShineEnabled == true

        if Animated ~= lastShineState then
            lastShineState = Animated
            t = 0
        end

        local Grad = Fluent and (Fluent:GetButtonGradient() or Fluent.ButtonGradients) or Fluent.ButtonGradients

        Gradient.Color = Grad.Background
        GradientStroke.Color = Grad.Stroke

        if BackgroundGradient then
            BackgroundGradient.Color = Grad.Background
        end

        for _, divGrad in ipairs(DividerGradients) do
            if divGrad and divGrad.Parent then
                divGrad.Color = Grad.Stroke
            end
        end

        for _, labelGrad in ipairs(LabelGradients) do
            if labelGrad and labelGrad.Parent then
                labelGrad.Color = Grad.Stroke
            end
        end

        if Animated then
            t = t + dt

            Gradient.Rotation = (t * 30) % 360
            GradientStroke.Rotation = (t * 15) % 360

            if BackgroundGradient then
                BackgroundGradient.Rotation = (t * -20) % 360
                BackgroundGradient.Offset = Vector2.new(math.sin(t * 0.3) * 0.1, math.cos(t * 0.25) * 0.1)
            end

            local Pulse = (math.sin(t * 0.5 * math.pi) + 1) / 2
            local MainThickness = 1.25 + Pulse * 1.25
            UIStroke.Thickness = MainThickness
            Frame.BackgroundTransparency = 0.27 + (math.sin(t * 0.4) * 0.05)

            for _, divGrad in ipairs(DividerGradients) do
                if divGrad and divGrad.Parent then
                    divGrad.Rotation = GradientStroke.Rotation
                end
            end

            for _, divider in ipairs(DividerFrames) do
                if divider and divider.Parent then
                    divider.BackgroundTransparency = 0.1 + (1 - Pulse) * 0.4
                end
            end

            for i, labelGrad in ipairs(LabelGradients) do
                if labelGrad and labelGrad.Parent then
                    labelGrad.Rotation = (t * 25 + i * 45) % 360
                end
            end
        else
            Gradient.Rotation = 0
            GradientStroke.Rotation = 0

            if BackgroundGradient then
                BackgroundGradient.Rotation = 0
                BackgroundGradient.Offset = Vector2.new(0, 0)
            end

            UIStroke.Thickness = 2
            Frame.BackgroundTransparency = 0.27

            for _, divGrad in ipairs(DividerGradients) do
                if divGrad and divGrad.Parent then
                    divGrad.Rotation = 0
                end
            end

            for _, divider in ipairs(DividerFrames) do
                if divider and divider.Parent then
                    divider.BackgroundTransparency = 0
                end
            end

            for _, labelGrad in ipairs(LabelGradients) do
                if labelGrad and labelGrad.Parent then
                    labelGrad.Rotation = 0
                end
            end
        end
    end)

    table.insert(FpsData.AnimatedConnections, conn)

    if Fluent then
        FpsData.ShineCheckConnection = RunService.Heartbeat:Connect(function()
            if Fluent then
                local currentShine = Fluent.ShineEnabled == true
                if currentShine ~= lastShineState then
                    lastShineState = currentShine
                    t = 0
                end
            end
        end)
    end
end

local function CreateFpsCounter()
    if FpsData.GUI then
        FpsData.GUI:Destroy()
        FpsData.GUI = nil
    end
    for _, conn in ipairs(FpsData.AnimatedConnections) do
        pcall(function() conn:Disconnect() end)
    end
    FpsData.AnimatedConnections = {}
    if FpsData.ShineCheckConnection then
        pcall(function() FpsData.ShineCheckConnection:Disconnect() end)
        FpsData.ShineCheckConnection = nil
    end
    if FpsData.Connection then
        FpsData.Connection:Disconnect()
        FpsData.Connection = nil
    end

    local FpsCounter = Instance.new("ScreenGui")
    FpsCounter.Name = "FPSCounter"
    FpsCounter.Parent = game.CoreGui
    FpsCounter.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    FpsCounter.ResetOnSpawn = false
    FpsCounter.DisplayOrder = 0

    FpsData.GUI = FpsCounter

    local Grad = Fluent:GetButtonGradient() or Fluent.ButtonGradients
    local StrokeColor3 = Grad.Stroke.Keypoints[1].Value

    local Frame = Instance.new("Frame")
    Frame.Parent = FpsCounter
    Frame.Size = UDim2.new(0, 320, 0, 45)
    Frame.Position = UDim2.new(0, 300, 0, 10)
    Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Frame.BackgroundTransparency = 0.85
    Frame.ZIndex = -10
    Frame.ClipsDescendants = true

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 12)
    Corner.Parent = Frame

    local BackgroundGradient = Instance.new("UIGradient")
    BackgroundGradient.Color = Grad.Background
    BackgroundGradient.Rotation = 0
    BackgroundGradient.Parent = Frame

    local Gradient = Instance.new("UIGradient")
    Gradient.Color = Grad.Background
    Gradient.Rotation = 0
    Gradient.Parent = Frame

    local GlassLayer = Instance.new("Frame")
    GlassLayer.Name = "_FBGlass"
    GlassLayer.Size = UDim2.fromScale(1, 1)
    GlassLayer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GlassLayer.BackgroundTransparency = 0.88
    GlassLayer.BorderSizePixel = 0
    GlassLayer.ZIndex = -9
    GlassLayer.Parent = Frame
    local GlassCorner = Instance.new("UICorner")
    GlassCorner.CornerRadius = UDim.new(0, 12)
    GlassCorner.Parent = GlassLayer
    local GlassGradient = Instance.new("UIGradient")
    GlassGradient.Rotation = 90
    GlassGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180)),
    })
    GlassGradient.Parent = GlassLayer

    local Noise = Instance.new("ImageLabel")
    Noise.Name = "_FBNoise"
    Noise.Image = "rbxassetid://9968344227"
    Noise.ScaleType = Enum.ScaleType.Tile
    Noise.TileSize = UDim2.new(0, 128, 0, 128)
    Noise.Size = UDim2.fromScale(1, 1)
    Noise.BackgroundTransparency = 1
    Noise.ImageTransparency = 0.92
    Noise.ZIndex = -8
    Noise.Parent = Frame
    local NoiseCorner = Instance.new("UICorner")
    NoiseCorner.CornerRadius = UDim.new(0, 12)
    NoiseCorner.Parent = Noise

    local UIStroke = Instance.new("UIStroke")
    UIStroke.Thickness = 2
    UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    UIStroke.Color = Color3.new(1, 1, 1)
    UIStroke.Parent = Frame

    local GradientStroke = Instance.new("UIGradient")
    GradientStroke.Color = Grad.Stroke
    GradientStroke.Rotation = 0
    GradientStroke.Parent = UIStroke

    local LabelGradients = {}

    local FPSLabel = Instance.new("TextLabel")
    FPSLabel.Parent = Frame
    FPSLabel.Size = UDim2.new(0, 90, 1, -10)
    FPSLabel.Position = UDim2.new(0, 6, 0, 5)
    FPSLabel.BackgroundTransparency = 1
    FPSLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    FPSLabel.Font = Enum.Font.GothamBlack
    FPSLabel.TextSize = 13
    FPSLabel.TextXAlignment = Enum.TextXAlignment.Center
    FPSLabel.TextYAlignment = Enum.TextYAlignment.Center
    FPSLabel.Text = "FPS: 0"
    FPSLabel.ZIndex = -7
    FPSLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    FPSLabel.TextStrokeTransparency = 0.3
    local FPSLabelGrad = Instance.new("UIGradient")
    FPSLabelGrad.Color = Grad.Stroke
    FPSLabelGrad.Rotation = 0
    FPSLabelGrad.Parent = FPSLabel
    table.insert(LabelGradients, FPSLabelGrad)

    local PingLabel = Instance.new("TextLabel")
    PingLabel.Parent = Frame
    PingLabel.Size = UDim2.new(0, 90, 1, -10)
    PingLabel.Position = UDim2.new(0, 108, 0, 5)
    PingLabel.BackgroundTransparency = 1
    PingLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    PingLabel.Font = Enum.Font.GothamBlack
    PingLabel.TextSize = 13
    PingLabel.TextXAlignment = Enum.TextXAlignment.Center
    PingLabel.TextYAlignment = Enum.TextYAlignment.Center
    PingLabel.Text = "Ping: 0 ms"
    PingLabel.ZIndex = -7
    PingLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    PingLabel.TextStrokeTransparency = 0.3
    local PingLabelGrad = Instance.new("UIGradient")
    PingLabelGrad.Color = Grad.Stroke
    PingLabelGrad.Rotation = 0
    PingLabelGrad.Parent = PingLabel
    table.insert(LabelGradients, PingLabelGrad)

    local PlaytimeLabel = Instance.new("TextLabel")
    PlaytimeLabel.Parent = Frame
    PlaytimeLabel.Size = UDim2.new(0, 100, 1, -10)
    PlaytimeLabel.Position = UDim2.new(0, 214, 0, 5)
    PlaytimeLabel.BackgroundTransparency = 1
    PlaytimeLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    PlaytimeLabel.Font = Enum.Font.GothamBlack
    PlaytimeLabel.TextSize = 13
    PlaytimeLabel.TextXAlignment = Enum.TextXAlignment.Center
    PlaytimeLabel.TextYAlignment = Enum.TextYAlignment.Center
    PlaytimeLabel.Text = "0h 0m 0s"
    PlaytimeLabel.ZIndex = -7
    PlaytimeLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    PlaytimeLabel.TextStrokeTransparency = 0.3
    local PlaytimeLabelGrad = Instance.new("UIGradient")
    PlaytimeLabelGrad.Color = Grad.Stroke
    PlaytimeLabelGrad.Rotation = 0
    PlaytimeLabelGrad.Parent = PlaytimeLabel
    table.insert(LabelGradients, PlaytimeLabelGrad)

    local DividerFrames = {}
    local DividerGradients = {}

    local Divider1 = Instance.new("Frame")
    Divider1.Parent = Frame
    Divider1.Size = UDim2.new(0, 1, 0.6, 0)
    Divider1.Position = UDim2.new(0, 97, 0.2, 0)
    Divider1.BackgroundColor3 = StrokeColor3
    Divider1.BackgroundTransparency = 0
    Divider1.BorderSizePixel = 0
    Divider1.ZIndex = -7

    local DividerGradient1 = Instance.new("UIGradient")
    DividerGradient1.Color = Grad.Stroke
    DividerGradient1.Rotation = 0
    DividerGradient1.Parent = Divider1
    table.insert(DividerFrames, Divider1)
    table.insert(DividerGradients, DividerGradient1)

    local Divider2 = Instance.new("Frame")
    Divider2.Parent = Frame
    Divider2.Size = UDim2.new(0, 1, 0.6, 0)
    Divider2.Position = UDim2.new(0, 199, 0.2, 0)
    Divider2.BackgroundColor3 = StrokeColor3
    Divider2.BackgroundTransparency = 0
    Divider2.BorderSizePixel = 0
    Divider2.ZIndex = -7

    local DividerGradient2 = Instance.new("UIGradient")
    DividerGradient2.Color = Grad.Stroke
    DividerGradient2.Rotation = 0
    DividerGradient2.Parent = Divider2
    table.insert(DividerFrames, Divider2)
    table.insert(DividerGradients, DividerGradient2)

    SetupFpsAnimations(Frame, Gradient, GradientStroke, UIStroke, BackgroundGradient, DividerFrames, DividerGradients, LabelGradients, Fluent)

    local Glow = Instance.new("ImageLabel")
    Glow.Name = "_Glow"
    Glow.Size = UDim2.new(1.2, 0, 1.2, 0)
    Glow.Position = UDim2.new(0.5, 0, 0.5, 0)
    Glow.AnchorPoint = Vector2.new(0.5, 0.5)
    Glow.BackgroundTransparency = 1
    Glow.Image = "rbxassetid://5028857081"
    Glow.ImageTransparency = 0.7
    Glow.ZIndex = -11
    Glow.Parent = Frame
    local GlowCorner = Instance.new("UICorner")
    GlowCorner.CornerRadius = UDim.new(0, 12)
    GlowCorner.Parent = Glow

    MakeDraggableFps(Frame, Frame, false, Fluent)

    local LastUpdateTime = tick()
    local FrameCount = 0

    FpsData.Connection = RunService.RenderStepped:Connect(function()
        FrameCount = FrameCount + 1
        local Now = tick()
        local Dt = Now - LastUpdateTime

        if Dt >= 1 then
            local Fps = math.round(FrameCount / Dt)
            local Elapsed = Now - FpsStartTime
            local H = math.floor(Elapsed / 3600)
            local M = math.floor((Elapsed % 3600) / 60)
            local S = math.floor(Elapsed % 60)

            local Ping = 0
            pcall(function()
                Ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
            end)

            FPSLabel.Text = string.format("FPS: %d", Fps)
            PingLabel.Text = string.format("Ping: %d ms", Ping)
            PlaytimeLabel.Text = string.format("%dh %dm %ds", H, M, S)

            LastUpdateTime = Now
            FrameCount = 0
        end
    end)

    local function Cleanup()
        if FpsData.Connection then
            FpsData.Connection:Disconnect()
            FpsData.Connection = nil
        end
        for _, conn in ipairs(FpsData.AnimatedConnections) do
            pcall(function() conn:Disconnect() end)
        end
        FpsData.AnimatedConnections = {}
        if FpsData.ShineCheckConnection then
            pcall(function() FpsData.ShineCheckConnection:Disconnect() end)
            FpsData.ShineCheckConnection = nil
        end
        if FpsData.GUI then
            FpsData.GUI:Destroy()
            FpsData.GUI = nil
        end
    end

    return FpsCounter, Cleanup
end

local function ToggleFpsCounter(State)
    FpsData.Enabled = State

    if State then
        if not FpsData.GUI then
            CreateFpsCounter()
        end
    else
        if FpsData.GUI then
            if FpsData.Connection then
                FpsData.Connection:Disconnect()
                FpsData.Connection = nil
            end
            for _, conn in ipairs(FpsData.AnimatedConnections) do
                pcall(function() conn:Disconnect() end)
            end
            FpsData.AnimatedConnections = {}
            if FpsData.ShineCheckConnection then
                pcall(function() FpsData.ShineCheckConnection:Disconnect() end)
                FpsData.ShineCheckConnection = nil
            end
            FpsData.GUI:Destroy()
            FpsData.GUI = nil
        end
    end
end

ToggleFpsCounter(true)

local secSettingsFps = Tabs.Settings:AddSection("FPS Counter", "solar/gauge-bold")
secSettingsFps:AddToggle("FPSCounterToggle", {
    Title = "Show FPS Counter",
    Description = "Toggle the FPS counter display",
    Default = true,
    Callback = function(Value)
        ToggleFpsCounter(Value)
    end
})

MediaManager:SetFolder("GoonWares/Base")

InterfaceManager:SetLibrary(Fluent)
InterfaceManager:SetFolder("GoonWares/GameName")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
InterfaceManager:LoadSettings()

SaveManager:SetLibrary(Fluent)
SaveManager:SetFolder("GoonWares/GameName/Config")
SaveManager:IgnoreThemeSettings()
SaveManager:BuildConfigSection(Tabs.Settings)
SaveManager:LoadAutoloadConfig()

FloatingButtonManager:SetLibrary(Fluent)
FloatingButtonManager:SetFolder("GoonWares/GameName/Floating")
FloatingButtonManager:BuildConfigSection(Tabs.Settings)
FloatingButtonManager:LoadAutoloadConfig()

local FloatingButtonLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/StyearX/GoonWares/refs/heads/main/Module/FloatingButtonModule.luau"))()
local FloatButtons = FloatingButtonLib.new(Fluent, FloatingButtonManager)

local ToggleFrame, ToggleButton, _, ToggleSetMode = FloatButtons:Create("DemoToggleFloat", "Auto Jump", true, function(Button)
    local NewState = not Button:GetAttribute("Active")
    Button:SetAttribute("Active", NewState)
    FloatingButtonLib.SetActive(Button, NewState, "Auto Jump")
    Notify("Floating Button", "Auto Jump " .. (NewState and "enabled" or "disabled"), "Info", "solar/widget-bold", 2)
end)

local ButtonFrame, ButtonButton, _, ButtonSetMode = FloatButtons:Create("DemoClickFloat", "Reset Character", false, {
    Text = "Clicked!",
    Callback = function(Button)
        Notify("Floating Button", "Reset Character triggered", "Success", "solar/restart-bold", 2)
    end,
})

local SecFloatToggle = Tabs.Settings:AddSection("Toggle Mode", "solar/toggle-on-circle-bold")

SecFloatToggle:AddToggle("ShowDemoToggleFloat", {
    Title = "Show Auto Jump Floating Button",
    Description = "Toggle mode: text switches between ON and OFF",
    Icon = "solar/widget-bold",
    Default = false,
    Callback = function(Value)
        FloatingButtonLib.SetVisible(ToggleFrame, Value)
    end,
})
FloatButtons:AddModeDropdown(SecFloatToggle, "DemoToggleFloat", ToggleSetMode)
FloatButtons:AddSizeInputs(SecFloatToggle, "DemoToggleFloat", "Auto Jump")
FloatButtons:AddKeybind(SecFloatToggle, "DemoToggleFloat", "Auto Jump", function()
    local NewState = not ToggleButton:GetAttribute("Active")
    ToggleButton:SetAttribute("Active", NewState)
    FloatingButtonLib.SetActive(ToggleButton, NewState, "Auto Jump")
end, "")

SecFloatToggle:AddDivider()

local SecFloatButton = Tabs.Settings:AddSection("Button Mode", "solar/cursor-bold")

SecFloatButton:AddToggle("ShowDemoClickFloat", {
    Title = "Show Reset Character Floating Button",
    Description = "Button mode: click once, text changes to Clicked!, auto resets",
    Icon = "solar/restart-bold",
    Default = false,
    Callback = function(Value)
        FloatingButtonLib.SetVisible(ButtonFrame, Value)
    end,
})
FloatButtons:AddModeDropdown(SecFloatButton, "DemoClickFloat", ButtonSetMode)
FloatButtons:AddSizeInputs(SecFloatButton, "DemoClickFloat", "Reset Character")
FloatButtons:AddKeybind(SecFloatButton, "DemoClickFloat", "Reset Character", function()
    Notify("Floating Button", "Reset Character triggered", "Success", "solar/restart-bold", 2)
end, "")

SecFloatButton:AddDivider()

DConfiguration = {
    Esp = {
        Enabled = false,
        TeamCheck = false,
        IncludeNpc = false,
        BoxType = "3D",
        BoxesEnabled = true,
        NamesEnabled = false,
        DistanceEnabled = false,
        HighlightsEnabled = false,
        TracerEnabled = false,
        TracerPosition = "Top",
        TracerThickness = 1,
        Elements = {},
        RenderConnection = nil,
        TrackedTargets = {},
        EventConnections = {},
    },
    Lighting = {
        OutdoorAmbient = Color3.fromRGB(127, 127, 127),
        Brightness = 2,
        AtmosEnabled = false,
        AtmosDensity = 0,
        AtmosOffset = 0,
        AtmosHaze = 0,
        AtmosGlare = 0,
        AtmosColor = Color3.fromRGB(199, 170, 107),
        AtmosDecay = Color3.fromRGB(91, 127, 232),
        SunRayEnabled = false,
        SunRayIntensity = 0.25,
        SunRaySpread = 0.5,
        CcEnabled = false,
        CcBrightness = 0,
        CcContrast = 0,
        CcSaturation = 0,
        CcTintColor = Color3.fromRGB(255, 255, 255),
        BloomEnabled = false,
        BloomIntensity = 0.35,
        BloomSize = 24,
        BloomThreshold = 0.95,
        CloudsEnabled = false,
        CloudsDensity = 0.5,
        CloudsCover = 0.5,
        CloudsColor = Color3.fromRGB(199, 199, 199),
        BlurEnabled = false,
        BlurSize = 24,
        DofEnabled = false,
        DofFocusDistance = 50,
        DofInFocusRadius = 10,
        DofNearIntensity = 1,
        DofFarIntensity = 1,
    },
    FovCircle = {
        enabled = false,
        size = 150,
        primaryColor = Color3.fromRGB(255, 255, 255),
        secondaryColor = Color3.fromRGB(255, 80, 120),
        rgbMode = false,
        gui = nil,
        circleFrame = nil,
        strokeGradient = nil,
        innerGradient = nil,
        rgbConn = nil,
        loopConn = nil,
        rgbHue = 0,
        loopT = 0,
    },
}

local function loadPremiumFeatures(tab)
    local sec = Tabs.Premium:AddSection("Dynamic Elements — Added at Runtime", "lucide/star")
    sec:AddSpace({ Height = 10 })

    sec:AddParagraph({
        Title = "Premium Tab — Dynamic Add Test",
        Content = "This entire section was added <b>after</b> the window was created, triggered by the Unlock Premium button on Premium.\nEvery element below has a real callback to confirm dynamic element injection works correctly.",
    })

    sec:AddSpace({ Height = 8 })

    sec:AddToggle("PremShadowToggle", {
        Title = "Character Shadows [Toggle]",
        Description = "Dynamically injected toggle — toggles CastShadow on character parts",
        Default = false,
        Callback = function(v)
            pcall(function()
                local char = LocalPlayer.Character
                if not char then return end
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then part.CastShadow = v end
                end
            end)
            Notify("Premium Toggle", "Shadows " .. (v and "ON" or "OFF"), v and "Success" or "Info", nil, 2)
        end,
    })

    sec:AddSlider("PremFovSlider", {
        Title = "Camera FOV [Slider]",
        Description = "Dynamically injected slider — adjusts FieldOfView in real-time",
        Min = 30,
        Max = 120,
        Default = 70,
        Rounding = 0,
        LeftIcons = "minus",
        RightIcons = "plus",
        Callback = function(v)
            pcall(function()
                workspace.CurrentCamera.FieldOfView = v
            end)
        end,
    })

    sec:AddDropdown("PremQualityDropdown", {
        Title = "Graphics Quality [Dropdown]",
        Description = "Dynamically injected dropdown — adjusts render quality level",
        Values = { "1", "3", "5", "7", "10" },
        Default = "5",
        ThemedDropdown = true,
        Callback = function(v)
            pcall(function()
                settings().Rendering.QualityLevel = Enum.QualityLevel["Level0" .. v] or Enum.QualityLevel.Level05
            end)
            Notify("Premium Dropdown", "Quality → " .. v, "Info", nil, 2)
        end,
    })

    sec:AddButton({
        Title = "Reset Character [Button]",
        Description = "Dynamically injected button — calls LocalPlayer:LoadCharacter()",
        Icon = "solar/restart-bold",
        Callback = function()
            pcall(function()
                LocalPlayer:LoadCharacter()
            end)
            Notify("Premium Button", "Character reset", "Success", nil, 2)
        end,
    })

    sec:AddColorpicker("PremAmbientPicker", {
        Title = "Ambient Color [Colorpicker]",
        Description = "Dynamically injected colorpicker — sets Lighting.Ambient live",
        Default = game:GetService("Lighting").Ambient,
        Callback = function(c)
            pcall(function()
                game:GetService("Lighting").Ambient = c
            end)
        end,
    })

    sec:AddSpace({ Height = 8 })
    Notify("Premium", "Features unlocked and injected!", "Success", nil, 3)
end

Tabs.Premium:AddButton({
    Title = "Unlock Premium",
    Callback = function()
        Window:Dialog({
            Title = "Confirm",
            Buttons = {
                { Title = "Yes", Callback = function() loadPremiumFeatures(Tabs.Premium) end },
                { Title = "No" },
            }
        })
    end,
})

local function CalculateBoxScale(Distance)
    if Distance <= 20 then return 1 else return math.max(20 / Distance, 0.25) end
end

local function GetHumanoidRootLike(Character)
    return Character:FindFirstChild("HumanoidRootPart")
        or Character:FindFirstChild("Torso")
        or Character:FindFirstChild("UpperTorso")
        or Character:FindFirstChild("LowerTorso")
        or Character:FindFirstChild("Head")
end

local function Create2DBox(Character, Color, Scale)
    local Existing = Character:FindFirstChild("Esp_2DBox")
    if Existing then Existing:Destroy() end
    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "Esp_2DBox"
    Billboard.AlwaysOnTop = true
    Billboard.Size = UDim2.new(0, 60 * Scale, 0, 80 * Scale)
    Billboard.StudsOffset = Vector3.new(0, 0, 0)
    Billboard.ClipsDescendants = false
    Billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Billboard.Active = true
    local RootPart = GetHumanoidRootLike(Character)
    if RootPart then
        Billboard.Adornee = RootPart
        Billboard.Parent = RootPart
    else
        Billboard.Adornee = Character
        Billboard.Parent = Character
    end
    local Frame = Instance.new("Frame")
    Frame.Name = "BoxFrame"
    Frame.Size = UDim2.new(1, 0, 1, 0)
    Frame.BackgroundTransparency = 1
    Frame.BorderSizePixel = 0
    Frame.Parent = Billboard
    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = math.max(1.5 * Scale, 1)
    Stroke.Transparency = 0.3
    Stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    Stroke.Color = Color
    Stroke.Parent = Frame
    return { Billboard = Billboard, Frame = Frame, Stroke = Stroke, Scale = Scale }
end

local function Update2DBox(BoxData, Color, Scale)
    if BoxData then
        if BoxData.Stroke then BoxData.Stroke.Color = Color end
        if BoxData.Billboard then BoxData.Billboard.Size = UDim2.new(0, 60 * Scale, 0, 80 * Scale) end
        if BoxData.Stroke then BoxData.Stroke.Thickness = math.max(1.5 * Scale, 1) end
        BoxData.Scale = Scale
    end
end

local function Remove2DBox(Character)
    local Box = Character:FindFirstChild("Esp_2DBox")
    if Box then Box:Destroy() end
    local RootPart = GetHumanoidRootLike(Character)
    if RootPart then
        local BoxInRoot = RootPart:FindFirstChild("Esp_2DBox")
        if BoxInRoot then BoxInRoot:Destroy() end
    end
end

local function Create3DBox(Character, Color, Size)
    local Folder = Character:FindFirstChild("Esp_3DBox")
    if Folder then Folder:Destroy() end
    local RootPart = GetHumanoidRootLike(Character)
    if not RootPart then return nil end
    Folder = Instance.new("Folder")
    Folder.Name = "Esp_3DBox"
    Folder.Parent = Character
    Size = Size or Vector3.new(3, 4, 2.5)
    local Ox = Size.X / 2
    local Oy = Size.Y / 2
    local Oz = Size.Z / 2
    local Edges = {
        {Vector3.new(0, Oy, Oz), Vector3.new(Size.X, 0.1, 0.1)},
        {Vector3.new(0, Oy, -Oz), Vector3.new(Size.X, 0.1, 0.1)},
        {Vector3.new(-Ox, Oy, 0), Vector3.new(0.1, 0.1, Size.Z)},
        {Vector3.new(Ox, Oy, 0), Vector3.new(0.1, 0.1, Size.Z)},
        {Vector3.new(0, -Oy, Oz), Vector3.new(Size.X, 0.1, 0.1)},
        {Vector3.new(0, -Oy, -Oz), Vector3.new(Size.X, 0.1, 0.1)},
        {Vector3.new(-Ox, -Oy, 0), Vector3.new(0.1, 0.1, Size.Z)},
        {Vector3.new(Ox, -Oy, 0), Vector3.new(0.1, 0.1, Size.Z)},
        {Vector3.new(-Ox, 0, Oz), Vector3.new(0.1, Size.Y, 0.1)},
        {Vector3.new(Ox, 0, Oz), Vector3.new(0.1, Size.Y, 0.1)},
        {Vector3.new(-Ox, 0, -Oz), Vector3.new(0.1, Size.Y, 0.1)},
        {Vector3.new(Ox, 0, -Oz), Vector3.new(0.1, Size.Y, 0.1)},
    }
    for _, Edge in ipairs(Edges) do
        local Adornment = Instance.new("BoxHandleAdornment")
        Adornment.Adornee = RootPart
        Adornment.Size = Edge[2]
        Adornment.CFrame = CFrame.new(Edge[1])
        Adornment.Color3 = Color
        Adornment.Transparency = 0.2
        Adornment.ZIndex = 10
        Adornment.AlwaysOnTop = true
        Adornment.Visible = true
        Adornment.Parent = Folder
    end
    return Folder
end

local function Update3DBox(Character, Color)
    local Folder = Character:FindFirstChild("Esp_3DBox")
    if Folder then
        for _, Adornment in ipairs(Folder:GetChildren()) do
            if Adornment:IsA("BoxHandleAdornment") then
                Adornment.Color3 = Color
            end
        end
    end
end

local function Remove3DBox(Character)
    local Folder = Character:FindFirstChild("Esp_3DBox")
    if Folder then Folder:Destroy() end
end

local function CreateBillboard(Character, Name, Color)
    local Existing = Character:FindFirstChild("Esp_Billboard")
    if Existing then Existing:Destroy() end
    local Billboard = Instance.new("BillboardGui")
    Billboard.Name = "Esp_Billboard"
    Billboard.AlwaysOnTop = true
    Billboard.Size = UDim2.new(0, 200, 0, 40)
    Billboard.StudsOffset = Vector3.new(0, 2.5, 0)
    Billboard.ClipsDescendants = false
    Billboard.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    Billboard.Active = true
    local RootPart = GetHumanoidRootLike(Character)
    if RootPart then
        Billboard.Adornee = RootPart
        Billboard.Parent = RootPart
    else
        Billboard.Adornee = Character
        Billboard.Parent = Character
    end
    local NameLabel = Instance.new("TextLabel")
    NameLabel.Name = "NameLabel"
    NameLabel.Size = UDim2.new(1, 0, 0, 20)
    NameLabel.Position = UDim2.new(0, 0, 0, 0)
    NameLabel.BackgroundTransparency = 1
    NameLabel.Text = Name
    NameLabel.TextColor3 = Color
    NameLabel.TextSize = 13
    NameLabel.Font = Enum.Font.GothamSemibold
    NameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    NameLabel.TextStrokeTransparency = 0.3
    NameLabel.TextXAlignment = Enum.TextXAlignment.Center
    NameLabel.TextYAlignment = Enum.TextYAlignment.Bottom
    NameLabel.Parent = Billboard
    local DistanceLabel = Instance.new("TextLabel")
    DistanceLabel.Name = "DistanceLabel"
    DistanceLabel.Size = UDim2.new(1, 0, 0, 16)
    DistanceLabel.Position = UDim2.new(0, 0, 0, 18)
    DistanceLabel.BackgroundTransparency = 1
    DistanceLabel.Text = ""
    DistanceLabel.TextColor3 = Color
    DistanceLabel.TextSize = 11
    DistanceLabel.Font = Enum.Font.Gotham
    DistanceLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    DistanceLabel.TextStrokeTransparency = 0.3
    DistanceLabel.TextXAlignment = Enum.TextXAlignment.Center
    DistanceLabel.TextYAlignment = Enum.TextYAlignment.Top
    DistanceLabel.Parent = Billboard
    return { Billboard = Billboard, NameLabel = NameLabel, DistanceLabel = DistanceLabel }
end

local function UpdateBillboard(BillboardData, Name, Distance, Color)
    if not BillboardData then return end
    if Name then
        BillboardData.NameLabel.Text = Name
        BillboardData.NameLabel.TextColor3 = Color
    end
    if Distance then
        BillboardData.DistanceLabel.Text = string.format("%.0f studs", Distance)
        BillboardData.DistanceLabel.TextColor3 = Color
    end
    BillboardData.NameLabel.Visible = Name ~= nil
    BillboardData.DistanceLabel.Visible = Distance ~= nil
end

local function RemoveBillboard(Character)
    local Bill = Character:FindFirstChild("Esp_Billboard")
    if Bill then Bill:Destroy() end
    local RootPart = GetHumanoidRootLike(Character)
    if RootPart then
        local BillInRoot = RootPart:FindFirstChild("Esp_Billboard")
        if BillInRoot then BillInRoot:Destroy() end
    end
end

local function CreateHighlight(Character, Color)
    local Existing = Character:FindFirstChild("Esp_Highlight")
    if Existing then Existing:Destroy() end
    local Highlight = Instance.new("Highlight")
    Highlight.Name = "Esp_Highlight"
    Highlight.Adornee = Character
    Highlight.FillColor = Color
    Highlight.OutlineColor = Color
    Highlight.FillTransparency = 0.5
    Highlight.OutlineTransparency = 0.3
    Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    Highlight.Parent = Character
    return Highlight
end

local function UpdateHighlight(Highlight, Color)
    if Highlight then
        Highlight.FillColor = Color
        Highlight.OutlineColor = Color
    end
end

local function RemoveHighlight(Character)
    local Highlight = Character:FindFirstChild("Esp_Highlight")
    if Highlight then Highlight:Destroy() end
end

local function CreateTracer(Color, Thickness)
    local Line = Drawing.new("Line")
    Line.Thickness = Thickness or 1
    Line.Color = Color or Color3.fromRGB(255, 255, 255)
    Line.Transparency = 1
    Line.Visible = false
    return Line
end

local function UpdateTracer(Tracer, Character, Color)
    if not Tracer then return end
    local Hrp = GetHumanoidRootLike(Character)
    if not Hrp or not Hrp:IsDescendantOf(Workspace) then
        Tracer.Visible = false
        return
    end
    local ScreenPos, OnScreen = Camera:WorldToViewportPoint(Hrp.Position)
    if OnScreen then
        local Pos = DConfiguration.Esp.TracerPosition
        local Vp = Camera.ViewportSize
        local From
        if Pos == "Top" then From = Vector2.new(Vp.X / 2, 0)
        elseif Pos == "Center" then From = Vector2.new(Vp.X / 2, Vp.Y / 2)
        else From = Vector2.new(Vp.X / 2, Vp.Y) end
        if Color then Tracer.Color = Color end
        Tracer.Thickness = math.max(1, DConfiguration.Esp.TracerThickness or 1)
        Tracer.From = From
        Tracer.To = Vector2.new(ScreenPos.X, ScreenPos.Y)
        Tracer.Visible = true
    else
        Tracer.Visible = false
    end
end

local function RemoveTracer(Tracer)
    if Tracer then pcall(function() Tracer:Remove() end) end
end

local function CleanupEsp()
    for Character, Esp in pairs(DConfiguration.Esp.Elements) do
        if Esp.Box2D then Remove2DBox(Character) end
        if Esp.Box3D then Remove3DBox(Character) end
        if Esp.Highlight then RemoveHighlight(Character) end
        if Esp.Billboard then RemoveBillboard(Character) end
        if Esp.Tracer then RemoveTracer(Esp.Tracer) end
    end
    DConfiguration.Esp.Elements = {}
end

local function GetTeamColor(Team)
    if Team and Team.TeamColor then return Team.TeamColor.Color end
    return Color3.fromRGB(255, 255, 255)
end

local function ApplyEspToCharacter(Character, DisplayName, Color)
    local Humanoid = Character:FindFirstChildOfClass("Humanoid")
    if not (Humanoid and Humanoid.Health > 0) then return false end
    local RefPart = GetHumanoidRootLike(Character)
    if not RefPart then return false end
    if not DConfiguration.Esp.Elements[Character] then
        DConfiguration.Esp.Elements[Character] = {}
    end
    local Esp = DConfiguration.Esp.Elements[Character]
    local Distance = (RefPart.Position - Camera.CFrame.Position).Magnitude
    local Scale = CalculateBoxScale(Distance)
    if DConfiguration.Esp.BoxesEnabled then
        if DConfiguration.Esp.BoxType == "2D" then
            if not Esp.Box2D then Esp.Box2D = Create2DBox(Character, Color, Scale) end
            if Esp.Box2D then Update2DBox(Esp.Box2D, Color, Scale) end
            if Esp.Box3D then Remove3DBox(Character); Esp.Box3D = nil end
        else
            local BoxSize = Vector3.new(2.5, Humanoid.HipHeight + 4, 2)
            if not Esp.Box3D then Esp.Box3D = Create3DBox(Character, Color, BoxSize) end
            if Esp.Box3D then Update3DBox(Character, Color) end
            if Esp.Box2D then Remove2DBox(Character); Esp.Box2D = nil end
        end
    else
        if Esp.Box2D then Remove2DBox(Character); Esp.Box2D = nil end
        if Esp.Box3D then Remove3DBox(Character); Esp.Box3D = nil end
    end
    if DConfiguration.Esp.HighlightsEnabled then
        if not Esp.Highlight then Esp.Highlight = CreateHighlight(Character, Color) end
        if Esp.Highlight then UpdateHighlight(Esp.Highlight, Color) end
    else
        if Esp.Highlight then RemoveHighlight(Character); Esp.Highlight = nil end
    end
    if DConfiguration.Esp.TracerEnabled then
        if not Esp.Tracer then Esp.Tracer = CreateTracer(Color, DConfiguration.Esp.TracerThickness) end
        if Esp.Tracer then UpdateTracer(Esp.Tracer, Character, Color) end
    else
        if Esp.Tracer then RemoveTracer(Esp.Tracer); Esp.Tracer = nil end
    end
    if DConfiguration.Esp.NamesEnabled or DConfiguration.Esp.DistanceEnabled then
        if not Esp.Billboard then Esp.Billboard = CreateBillboard(Character, DisplayName, Color) end
        if Esp.Billboard then
            UpdateBillboard(
                Esp.Billboard,
                DConfiguration.Esp.NamesEnabled and DisplayName or nil,
                DConfiguration.Esp.DistanceEnabled and Distance or nil,
                Color
            )
        end
    else
        if Esp.Billboard then RemoveBillboard(Character); Esp.Billboard = nil end
    end
    return true
end

local function RemoveTrackedCharacter(Character)
    DConfiguration.Esp.TrackedTargets[Character] = nil
    local Esp = DConfiguration.Esp.Elements[Character]
    if Esp then
        if Esp.Box2D then Remove2DBox(Character) end
        if Esp.Box3D then Remove3DBox(Character) end
        if Esp.Highlight then RemoveHighlight(Character) end
        if Esp.Billboard then RemoveBillboard(Character) end
        if Esp.Tracer then RemoveTracer(Esp.Tracer) end
        DConfiguration.Esp.Elements[Character] = nil
    end
end

local function TrackPlayerCharacter(Player, Character)
    if Player == LocalPlayer then return end
    local Color = GetTeamColor(Player.Team)
    DConfiguration.Esp.TrackedTargets[Character] = {
        DisplayName = Player.Name,
        Color = Color,
        IsPlayer = true,
        Player = Player,
    }
    Character.AncestryChanged:Connect(function(_, Parent)
        if not Parent then
            RemoveTrackedCharacter(Character)
        end
    end)
end

local function IsPlayerRig(Model)
    local ModelNameLower = Model.Name:lower()
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player.Name:lower() == ModelNameLower or Player.DisplayName:lower() == ModelNameLower then
            return true
        end
    end
    for _, Child in ipairs(Model:GetChildren()) do
        local ChildNameLower = Child.Name:lower()
        if Child:IsA("Shirt") or Child:IsA("Pants") then
            return true
        end
        for _, Player in ipairs(Players:GetPlayers()) do
            if ChildNameLower == Player.Name:lower() or ChildNameLower == Player.DisplayName:lower() then
                return true
            end
        end
    end
    return false
end

local function TrackNpcCharacter(Model)
    local Humanoid = Model:FindFirstChildOfClass("Humanoid")
    local RefPart = GetHumanoidRootLike(Model)
    if not Humanoid or not RefPart then return end
    if IsPlayerRig(Model) then return end
    DConfiguration.Esp.TrackedTargets[Model] = {
        DisplayName = Model.Name,
        Color = Color3.fromRGB(255, 200, 0),
        IsPlayer = false,
        Player = nil,
    }
    Model.AncestryChanged:Connect(function(_, Parent)
        if not Parent then
            RemoveTrackedCharacter(Model)
        end
    end)
end

local function SetupPlayerTracking()
    for _, Player in ipairs(Players:GetPlayers()) do
        if Player ~= LocalPlayer then
            local Conn = Player.CharacterAdded:Connect(function(Character)
                TrackPlayerCharacter(Player, Character)
            end)
            table.insert(DConfiguration.Esp.EventConnections, Conn)
            if Player.Character then
                TrackPlayerCharacter(Player, Player.Character)
            end
        end
    end
    local ConnAdded = Players.PlayerAdded:Connect(function(Player)
        if Player == LocalPlayer then return end
        local Conn = Player.CharacterAdded:Connect(function(Character)
            TrackPlayerCharacter(Player, Character)
        end)
        table.insert(DConfiguration.Esp.EventConnections, Conn)
    end)
    local ConnRemoving = Players.PlayerRemoving:Connect(function(Player)
        if Player.Character then
            RemoveTrackedCharacter(Player.Character)
        end
    end)
    table.insert(DConfiguration.Esp.EventConnections, ConnAdded)
    table.insert(DConfiguration.Esp.EventConnections, ConnRemoving)
end

local NpcScanConnection = nil

local function SetupNpcTracking()
    if NpcScanConnection then return end
    for _, Desc in ipairs(Workspace:GetDescendants()) do
        if Desc:IsA("Model") and not DConfiguration.Esp.TrackedTargets[Desc] then
            local IsPlayerChar = false
            for _, P in ipairs(Players:GetPlayers()) do
                if P.Character == Desc then
                    IsPlayerChar = true
                    break
                end
            end
            if not IsPlayerChar then
                TrackNpcCharacter(Desc)
            end
        end
    end
    NpcScanConnection = Workspace.DescendantAdded:Connect(function(Desc)
        if Desc:IsA("Model") and DConfiguration.Esp.IncludeNpc then
            local IsPlayerChar = false
            for _, P in ipairs(Players:GetPlayers()) do
                if P.Character == Desc then
                    IsPlayerChar = true
                    break
                end
            end
            if not IsPlayerChar then
                task.delay(0.5, function()
                    if Desc and Desc.Parent then
                        TrackNpcCharacter(Desc)
                    end
                end)
            end
        end
    end)
    table.insert(DConfiguration.Esp.EventConnections, NpcScanConnection)
end

local function TeardownNpcTracking()
    if NpcScanConnection then
        NpcScanConnection:Disconnect()
        NpcScanConnection = nil
    end
    for Character, Data in pairs(DConfiguration.Esp.TrackedTargets) do
        if not Data.IsPlayer then
            RemoveTrackedCharacter(Character)
        end
    end
end

local function UpdateEsp()
    if not DConfiguration.Esp.Enabled then return end

    for Character, Data in pairs(DConfiguration.Esp.TrackedTargets) do
        if Data.IsPlayer then
            if DConfiguration.Esp.TeamCheck and Data.Player and Data.Player.Team == LocalPlayer.Team then
                RemoveTrackedCharacter(Character)
            else
                local Color = GetTeamColor(Data.Player and Data.Player.Team)
                ApplyEspToCharacter(Character, Data.DisplayName, Color)
            end
        elseif DConfiguration.Esp.IncludeNpc then
            ApplyEspToCharacter(Character, Data.DisplayName, Data.Color)
        end
    end

    local CharsToRemove = {}
    for Character, _ in pairs(DConfiguration.Esp.Elements) do
        if not DConfiguration.Esp.TrackedTargets[Character] then
            table.insert(CharsToRemove, Character)
        end
    end
    for _, Character in ipairs(CharsToRemove) do
        local Esp = DConfiguration.Esp.Elements[Character]
        if Esp then
            if Esp.Box2D then Remove2DBox(Character) end
            if Esp.Box3D then Remove3DBox(Character) end
            if Esp.Highlight then RemoveHighlight(Character) end
            if Esp.Billboard then RemoveBillboard(Character) end
            if Esp.Tracer then RemoveTracer(Esp.Tracer) end
        end
        DConfiguration.Esp.Elements[Character] = nil
    end
end

local function StartEspRender()
    if DConfiguration.Esp.RenderConnection then return end
    DConfiguration.Esp.TrackedTargets = {}
    DConfiguration.Esp.EventConnections = {}
    SetupPlayerTracking()
    if DConfiguration.Esp.IncludeNpc then
        SetupNpcTracking()
    end
    DConfiguration.Esp.RenderConnection = RunService.RenderStepped:Connect(UpdateEsp)
end

local function StopEspRender()
    if DConfiguration.Esp.RenderConnection then
        DConfiguration.Esp.RenderConnection:Disconnect()
        DConfiguration.Esp.RenderConnection = nil
    end
    for _, Conn in ipairs(DConfiguration.Esp.EventConnections) do
        Conn:Disconnect()
    end
    DConfiguration.Esp.EventConnections = {}
    NpcScanConnection = nil
    DConfiguration.Esp.TrackedTargets = {}
    CleanupEsp()
end

local function RandFlag(Name)
    return Name .. "_" .. tostring(math.random(100000, 999999))
end

local SecEsp = Tabs.Main:AddSection("Player ESP", "solar/eye-bold")

local EspEnabledFlag = "EspEnabled"
SecEsp:AddToggle(EspEnabledFlag, {
    Title = "Enable ESP",
    Default = false,
    Callback = function(Value)
        DConfiguration.Esp.Enabled = Value
        if Value then StartEspRender() else StopEspRender() end
        if EspButton then
            EspButton:SetAttribute("Active", Value)
            FloatingButtonLib.SetActive(EspButton, Value, "ESP")
        end
    end
})

local GrpEspFilters = SecEsp:AddGroup({ Columns = 2, Gap = 6 })
local ColEspTeamCheck = GrpEspFilters:AddElement()
local ColEspIncludeNpc = GrpEspFilters:AddElement()

ColEspTeamCheck:AddToggle(RandFlag("EspTeamCheck"), {
    Title = "Team Check",
    Default = false,
    Callback = function(Value) DConfiguration.Esp.TeamCheck = Value end
})

ColEspIncludeNpc:AddToggle(RandFlag("EspIncludeNpc"), {
    Title = "Include Npc",
    Default = false,
    Callback = function(Value)
        DConfiguration.Esp.IncludeNpc = Value
        if DConfiguration.Esp.Enabled then
            if Value then SetupNpcTracking() else TeardownNpcTracking() end
        end
    end
})

SecEsp:AddToggle(RandFlag("EspBoxes"), {
    Title = "Show Boxes",
    Default = false,
    Callback = function(Value) DConfiguration.Esp.BoxesEnabled = Value end
})

SecEsp:AddDropdown(RandFlag("EspBoxType"), {
    Title = "Box Type",
    Values = { "2D", "3D" },
    Default = "3D",
    ThemedDropdown = true,
    Callback = function(Value) DConfiguration.Esp.BoxType = Value end
})

SecEsp:AddToggle(RandFlag("EspNames"), {
    Title = "Names",
    Default = false,
    Callback = function(Value) DConfiguration.Esp.NamesEnabled = Value end
})

SecEsp:AddToggle(RandFlag("EspDistance"), {
    Title = "Distance",
    Default = false,
    Callback = function(Value) DConfiguration.Esp.DistanceEnabled = Value end
})

SecEsp:AddToggle(RandFlag("EspHighlight"), {
    Title = "Highlight",
    Default = false,
    Callback = function(Value) DConfiguration.Esp.HighlightsEnabled = Value end
})

SecEsp:AddToggle(RandFlag("EspTracer"), {
    Title = "Tracer",
    Default = false,
    Callback = function(Value) DConfiguration.Esp.TracerEnabled = Value end
})

SecEsp:AddDropdown(RandFlag("EspTracerPos"), {
    Title = "Tracer Origin",
    Values = { "Bottom", "Center", "Top" },
    Default = "Top",
    ThemedDropdown = true,
    Callback = function(Value) DConfiguration.Esp.TracerPosition = Value end
})

SecEsp:AddDivider()
SecEsp:AddSpace({ Height = 20 })
SecEsp:AddDivider()

local EspFrame, EspButton, _, EspSetMode = FloatButtons:Create("EspBtn", "ESP", true, function(Button)
    local NewState = not Button:GetAttribute("Active")
    Button:SetAttribute("Active", NewState)
    DConfiguration.Esp.Enabled = NewState
    if NewState then StartEspRender() else StopEspRender() end
    FloatingButtonLib.SetActive(Button, NewState, "ESP")
    if Fluent.Options[EspEnabledFlag] then
        Fluent.Options[EspEnabledFlag]:SetValue(NewState)
    end
end)
FloatingButtonLib.SetVisible(EspFrame, false)

SecEsp:AddToggle(RandFlag("EspShowBtn"), {
    Title = "Show ESP Button",
    Default = false,
    Callback = function(Value) FloatingButtonLib.SetVisible(EspFrame, Value) end
})

FloatButtons:AddModeDropdown(SecEsp, "EspBtn", EspSetMode)
FloatButtons:AddSizeInputs(SecEsp, "EspBtn", "ESP")
FloatButtons:AddKeybind(SecEsp, "EspBtn", "ESP", function()
    local NewState = not EspButton:GetAttribute("Active")
    EspButton:SetAttribute("Active", NewState)
    DConfiguration.Esp.Enabled = NewState
    if NewState then StartEspRender() else StopEspRender() end
    FloatingButtonLib.SetActive(EspButton, NewState, "ESP")
    if Fluent.Options[EspEnabledFlag] then
        Fluent.Options[EspEnabledFlag]:SetValue(NewState)
    end
end, "")

SecEsp:AddDivider()

function UniverseServerTools(Tabs)
    jobId = game.JobId
    placeId = game.PlaceId
    StartTime = tick()
    ENGINE_TARGET_MB = 3000
    FrameCount = 0
    LastTime = tick()
    CurrentFPS = 0

    RunService.RenderStepped:Connect(function()
        FrameCount = FrameCount + 1
        local CurrentTime = tick()
        if CurrentTime - LastTime >= 1 then
            CurrentFPS = FrameCount
            FrameCount = 0
            LastTime = CurrentTime
        end
    end)

    function ConvertToDetailedTime(Seconds, Milliseconds)
        local Years = math.floor(Seconds / 31536000); Seconds = Seconds % 31536000
        local Months = math.floor(Seconds / 2592000); Seconds = Seconds % 2592000
        local Weeks = math.floor(Seconds / 604800); Seconds = Seconds % 604800
        local Days = math.floor(Seconds / 86400); Seconds = Seconds % 86400
        local Hours = math.floor(Seconds / 3600); Seconds = Seconds % 3600
        local Minutes = math.floor(Seconds / 60)
        local Secs = Seconds % 60
        return { Years = Years, Months = Months, Weeks = Weeks, Days = Days, Hours = Hours, Minutes = Minutes, Seconds = Secs, Milliseconds = Milliseconds or 0 }
    end

    function GetServerUptimeString()
        local Total = time()
        local Ms = math.floor((Total - math.floor(Total)) * 1000)
        local Up = ConvertToDetailedTime(math.floor(Total), Ms)
        return string.format("%dY %dMth %dW %dD %dH %dMin %dSec %dMS", Up.Years, Up.Months, Up.Weeks, Up.Days, Up.Hours, Up.Minutes, Up.Seconds, Up.Milliseconds)
    end

    function GetLastJoinedString()
        local CurrentTimeSeconds = os.time()
        local JoinedTimeSeconds = CurrentTimeSeconds - math.floor(time())
        local JoinedTime = os.date("*t", JoinedTimeSeconds)
        local Hour = JoinedTime.hour
        local Ampm = Hour >= 12 and "PM" or "AM"
        local Hour12 = Hour % 12
        if Hour12 == 0 then Hour12 = 12 end
        local Ms = math.floor((time() - math.floor(time())) * 1000)
        local MonthNames = { "Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec" }
        return string.format("%02d:%02d:%02d.%03d %s - %s %d, %d", Hour12, JoinedTime.min, JoinedTime.sec, Ms, Ampm, MonthNames[JoinedTime.month], JoinedTime.day, JoinedTime.year)
    end

    function GetScriptRuntime()
        local Elapsed = tick() - StartTime
        local Ms = math.floor((Elapsed - math.floor(Elapsed)) * 1000)
        local Runtime = ConvertToDetailedTime(math.floor(Elapsed), Ms)
        return string.format("%dY %dMth %dW %dD %dH %dMin %dSec %dMS", Runtime.Years, Runtime.Months, Runtime.Weeks, Runtime.Days, Runtime.Hours, Runtime.Minutes, Runtime.Seconds, Runtime.Milliseconds)
    end

    function GetExecutedSince()
        return os.date("%I:%M:%S %p", StartTime)
    end

    function GetOSClock()
        local Now = os.date("*t")
        local Hour = Now.hour
        local Ampm = Hour >= 12 and "PM" or "AM"
        local Hour12 = Hour % 12
        if Hour12 == 0 then Hour12 = 12 end
        return string.format("%02d:%02d:%02d %s", Hour12, Now.min, Now.sec, Ampm)
    end

    function GetCalendarDate()
        local Now = os.date("*t")
        local MonthNames = { "January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December" }
        local Suffix = "th"
        if Now.day == 1 or Now.day == 21 or Now.day == 31 then Suffix = "st"
        elseif Now.day == 2 or Now.day == 22 then Suffix = "nd"
        elseif Now.day == 3 or Now.day == 23 then Suffix = "rd" end
        return string.format("%s %d%s, %d", MonthNames[Now.month], Now.day, Suffix, Now.year)
    end

    function GetGPUInfo()
        return string.format("%.2f ms", Stats.RenderGPUFrameTime * 1000)
    end

    function GetCPUInfo()
        return string.format("%.2f ms", Stats.RenderCPUFrameTime * 1000)
    end

    function GetRAMInfo()
        local Ram = Stats:GetTotalMemoryUsageMb()
        return string.format("%.2f MB / %d MB (%d%%)", Ram, ENGINE_TARGET_MB, math.floor((Ram / ENGINE_TARGET_MB) * 100))
    end

    function GetNetworkSent()
        return string.format("%.2f KB/s", Stats.DataSendKbps)
    end

    function GetNetworkReceived()
        return string.format("%.2f KB/s", Stats.DataReceiveKbps)
    end

    function GetPing()
        return string.format("%d ms", math.floor(math.clamp(Stats.Network.ServerStatsItem["Data Ping"]:GetValue(), 10, 700)))
    end

    function GetFPS()
        return string.format("%d fps", CurrentFPS)
    end

    function GetLaunchId()
        return string.format("roblox://placeId=%d&gameInstanceId=%s", placeId, jobId)
    end

    function GetServerLink()
        return string.format("darahub.pages.dev/roblox-launch.html?placeId=%d&gameInstanceId=%s", placeId, jobId)
    end

    function RejoinServer()
        local Ok, Err = pcall(function()
            local CurrentJobId = game.JobId
            local Cursor = ""
            local Found = false
            repeat
                local Url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?limit=100"
                if Cursor ~= "" then Url = Url .. "&cursor=" .. Cursor end
                local Ok2, Result = pcall(function() return game:HttpGet(Url) end)
                if not Ok2 then return end
                local Data = HttpService:JSONDecode(Result)
                if Data and Data.data then
                    for _, Server in ipairs(Data.data) do
                        if Server.id == CurrentJobId then
                            Found = true
                            TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Players.LocalPlayer)
                            return
                        end
                    end
                end
                Cursor = Data and Data.nextPageCursor or ""
            until Cursor == ""
            if not Found then TeleportService:Teleport(game.PlaceId) end
        end)
        if not Ok then Notify("Rejoin Error", "Failed to rejoin: " .. tostring(Err), "Error", nil, 3) end
    end

    TotalFriends = 0
    OnlineFriends = 0
    OfflineFriends = 0

    function UpdateFriendData()
        pcall(function()
            local Total = 0
            local Online = 0
            local FriendsList = Players:GetFriendsAsync(LocalPlayer.UserId)
            while true do
                for _ in ipairs(FriendsList:GetCurrentPage()) do Total = Total + 1 end
                if FriendsList.IsFinished then break else FriendsList:AdvanceToNextPageAsync() end
            end
            for _ in pairs(LocalPlayer:GetFriendsOnline()) do Online = Online + 1 end
            TotalFriends = Total
            OnlineFriends = Online
            OfflineFriends = Total - Online
        end)
    end

    task.spawn(UpdateFriendData)
    task.spawn(function()
        while true do task.wait(30); UpdateFriendData() end
    end)

    local PlaceName = "Unknown"
    pcall(function()
        local Info = MarketplaceService:GetProductInfo(placeId)
        if Info and Info.Name then PlaceName = Info.Name end
    end)

    local SecServerInfo = Tabs.Misc:AddSection("Server Information", "solar/widget-2-bold")
    SecServerInfo:AddSpace({ Height = 15 })
    SecServerInfo:AddDivider()

    local ServerInfoParagraph = SecServerInfo:AddParagraph({ Title = "<b>In Server For</b>", Content = GetServerUptimeString() })
    task.spawn(function() while true do task.wait() pcall(function() ServerInfoParagraph:SetDesc(GetServerUptimeString()) end) end end)
    SecServerInfo:AddParagraph({ Title = "<b>Server Started</b>", Content = GetLastJoinedString() })
    SecServerInfo:AddParagraph({ Title = "<b>Game</b>", Content = PlaceName })
    local CurrentPlayersParagraph = SecServerInfo:AddParagraph({ Title = "<b>Current Players</b>", Content = #Players:GetPlayers() .. " / " .. Players.MaxPlayers })
    task.spawn(function() while true do task.wait() pcall(function() CurrentPlayersParagraph:SetDesc(#Players:GetPlayers() .. " / " .. Players.MaxPlayers) end) end end)
    SecServerInfo:AddParagraph({ Title = "<b>Server ID</b>", Content = string.sub(jobId, 1, 30) .. "..." })
    SecServerInfo:AddSpace({ Height = 15 })

    local SecClientInfo = Tabs.Misc:AddSection("Client Information", "solar/widget-2-bold")
    SecClientInfo:AddSpace({ Height = 15 })
    SecClientInfo:AddDivider()

    local ScriptRuntimeParagraph = SecClientInfo:AddParagraph({ Title = "<b>Script Running For</b>", Content = GetScriptRuntime() })
    task.spawn(function() while true do task.wait() pcall(function() ScriptRuntimeParagraph:SetDesc(GetScriptRuntime()) end) end end)
    SecClientInfo:AddParagraph({ Title = "<b>Executed Since</b>", Content = GetExecutedSince() })
    SecClientInfo:AddSpace({ Height = 15 })

    local SecSystemInfo = Tabs.Misc:AddSection("System Information", "solar/widget-2-bold")
    SecSystemInfo:AddSpace({ Height = 15 })
    SecSystemInfo:AddDivider()

    local OSClockParagraph = SecSystemInfo:AddParagraph({ Title = "<b>OS Clock</b>", Content = GetOSClock() })
    task.spawn(function() while true do task.wait() pcall(function() OSClockParagraph:SetDesc(GetOSClock()) end) end end)
    local CalendarParagraph = SecSystemInfo:AddParagraph({ Title = "<b>Calendar</b>", Content = GetCalendarDate() })
    task.spawn(function() while true do task.wait(60) pcall(function() CalendarParagraph:SetDesc(GetCalendarDate()) end) end end)
    local GpuParagraph = SecSystemInfo:AddParagraph({ Title = "<font color=\"rgb(180,220,255)\"><b>GPU</b></font>", Content = GetGPUInfo() })
    local CpuParagraph = SecSystemInfo:AddParagraph({ Title = "<font color=\"rgb(180,220,255)\"><b>CPU</b></font>", Content = GetCPUInfo() })
    local RamParagraph = SecSystemInfo:AddParagraph({ Title = "<font color=\"rgb(180,220,255)\"><b>RAM</b></font>", Content = GetRAMInfo() })
    local SentParagraph = SecSystemInfo:AddParagraph({ Title = "<font color=\"rgb(120,255,160)\"><b>Sent</b></font>", Content = GetNetworkSent() })
    local ReceivedParagraph = SecSystemInfo:AddParagraph({ Title = "<font color=\"rgb(120,255,160)\"><b>Received</b></font>", Content = GetNetworkReceived() })
    local PingParagraph = SecSystemInfo:AddParagraph({ Title = "<b>Ping</b>", Content = GetPing() })
    local FpsParagraph = SecSystemInfo:AddParagraph({ Title = "<b>FPS</b>", Content = GetFPS() })

    task.spawn(function()
        while true do
            task.wait(0.2)
            pcall(function()
                GpuParagraph:SetDesc(GetGPUInfo())
                CpuParagraph:SetDesc(GetCPUInfo())
                RamParagraph:SetDesc(GetRAMInfo())
                SentParagraph:SetDesc(GetNetworkSent())
                ReceivedParagraph:SetDesc(GetNetworkReceived())
                PingParagraph:SetDesc(GetPing())
                FpsParagraph:SetDesc(GetFPS())
            end)
        end
    end)
    SecSystemInfo:AddSpace({ Height = 15 })

    local SecPlayerInfo = Tabs.Misc:AddSection("Player Information", "solar/widget-2-bold")
    SecPlayerInfo:AddSpace({ Height = 15 })
    SecPlayerInfo:AddDivider()

    SecPlayerInfo:AddParagraph({ Title = "<b>Username</b>", Content = LocalPlayer.Name })
    SecPlayerInfo:AddParagraph({ Title = "<b>Display Name</b>", Content = LocalPlayer.DisplayName })
    SecPlayerInfo:AddParagraph({ Title = "<b>User ID</b>", Content = tostring(LocalPlayer.UserId) })

    local AccountCreationString = "Unknown"
    pcall(function()
        local AccountAge = LocalPlayer.AccountAge
        if AccountAge then AccountCreationString = os.date("%B %d, %Y", os.time() - (AccountAge * 86400)) end
    end)
    SecPlayerInfo:AddParagraph({ Title = "<b>Account Created</b>", Content = AccountCreationString })
    SecPlayerInfo:AddSpace({ Height = 15 })

    local SecFriendsData = Tabs.Misc:AddSection("Friends Data", "solar/widget-2-bold")
    SecFriendsData:AddSpace({ Height = 15 })
    SecFriendsData:AddDivider()

    local FriendsOnlineParagraph = SecFriendsData:AddParagraph({ Title = "<font color=\"rgb(120,255,160)\"><b>Online Friends</b></font>", Content = "0" })
    local FriendsOfflineParagraph = SecFriendsData:AddParagraph({ Title = "<font color=\"rgb(200,200,200)\"><b>Offline Friends</b></font>", Content = "0" })
    local FriendsTotalParagraph = SecFriendsData:AddParagraph({ Title = "<b>Total Friends</b>", Content = "0" })

    task.spawn(function()
        while true do
            task.wait(30)
            pcall(function()
                UpdateFriendData()
                FriendsOnlineParagraph:SetDesc(tostring(OnlineFriends))
                FriendsOfflineParagraph:SetDesc(tostring(OfflineFriends))
                FriendsTotalParagraph:SetDesc(tostring(TotalFriends))
            end)
        end
    end)

    pcall(function()
        UpdateFriendData()
        FriendsOnlineParagraph:SetDesc(tostring(OnlineFriends))
        FriendsOfflineParagraph:SetDesc(tostring(OfflineFriends))
        FriendsTotalParagraph:SetDesc(tostring(TotalFriends))
    end)
    SecFriendsData:AddSpace({ Height = 15 })

    local SecServerTools = Tabs.Misc:AddSection("Server Tools", "solar/widget-2-bold")
    SecServerTools:AddSpace({ Height = 15 })
    SecServerTools:AddDivider()

    SecServerTools:AddButton({
        Title = "Rejoin",
        Description = "Rejoin the current server",
        Icon = "refresh-cw",
        Callback = function()
            Window:Dialog({
                Title = "Rejoin",
                Content = "Are you sure you want to rejoin the current server?",
                Buttons = {
                    { Title = "Yes", Callback = function() RejoinServer() end },
                    { Title = "No" },
                },
            })
        end
    })

    SecServerTools:AddButton({
        Title = "Copy Server Launch ID",
        Description = "Copy the current server Launch ID",
        Icon = "link",
        Callback = function()
            pcall(function() if setclipboard then setclipboard(GetLaunchId()) end end)
            Notify("Copied", "Server Launch ID copied", "Info", nil, 2)
        end
    })

    SecServerTools:AddButton({
        Title = "Copy Server Link",
        Description = "Copy the current server join link",
        Icon = "link",
        Callback = function()
            pcall(function() if setclipboard then setclipboard(GetServerLink()) end end)
            Notify("Copied", "Server link copied", "Info", nil, 2)
        end
    })
    SecServerTools:AddSpace({ Height = 15 })
end

UniverseServerTools(Tabs)

local LC = DConfiguration.Lighting

local function GetOrCreateSky()
    local sky = Lighting:FindFirstChildOfClass("Sky")
    if not sky then
        sky = Instance.new("Sky")
        sky.Name = "Sky"
        sky.Parent = Lighting
    end
    return sky
end

local function GetOrCreate(className, name)
    local inst = Lighting:FindFirstChildOfClass(className)
    if not inst then
        inst = Instance.new(className)
        inst.Name = name or className
        inst.Parent = Lighting
    end
    return inst
end

local function GetOrCreateDoF()
    local cam = workspace.CurrentCamera
    local dof = cam:FindFirstChildOfClass("DepthOfFieldEffect")
    if not dof then
        dof = Instance.new("DepthOfFieldEffect")
        dof.Name = "DepthOfFieldEffect"
        dof.Parent = cam
    end
    return dof
end

local SecLighting = Tabs.Visual:AddSection("Lighting Configuration", "solar/sun-fog-bold")
SecLighting:AddSpace({ Height = 15 })

SecLighting:AddToggle("LightingCelestialBodies", {
    Title = "Celestial Bodies",
    Description = "Show sun & moon in the sky",
    Default = GetOrCreateSky().CelestialBodiesShown,
    Callback = function(v)
        GetOrCreateSky().CelestialBodiesShown = v
    end,
})

SecLighting:AddSlider("LightingSunAngularSize", {
    Title = "Sun Angular Size",
    Min = 0, Max = 60, Default = math.round(GetOrCreateSky().SunAngularSize), Rounding = 0,
    Callback = function(v)
        GetOrCreateSky().SunAngularSize = v
    end,
})

SecLighting:AddSlider("LightingMoonAngularSize", {
    Title = "Moon Angular Size",
    Min = 0, Max = 60, Default = math.round(GetOrCreateSky().MoonAngularSize), Rounding = 0,
    Callback = function(v)
        GetOrCreateSky().MoonAngularSize = v
    end,
})

SecLighting:AddInput("LightingSunTextureId", {
    Title = "Sun Texture ID",
    Placeholder = "rbxassetid://...",
    Default = "rbxassetid://91816974179437",
    Finished = true,
    Callback = function(v)
        v = v:gsub("^%s*(.-)%s*$", "%1")
        if v ~= "" then
            if not v:match("^rbxassetid://") then v = "rbxassetid://" .. v end
            GetOrCreateSky().SunTextureId = v
        end
    end,
})

SecLighting:AddInput("LightingMoonTextureId", {
    Title = "Moon Texture ID",
    Placeholder = "rbxassetid://...",
    Finished = true,
    Callback = function(v)
        v = v:gsub("^%s*(.-)%s*$", "%1")
        if v ~= "" then
            if not v:match("^rbxassetid://") then v = "rbxassetid://" .. v end
            GetOrCreateSky().MoonTextureId = v
        end
    end,
})

SecLighting:AddSlider("LightingStarCount", {
    Title = "Star Count",
    Min = 0, Max = 5000, Default = GetOrCreateSky().StarCount, Rounding = 0,
    Callback = function(v)
        GetOrCreateSky().StarCount = v
    end,
})

SecLighting:AddSlider("LightingBrightness", {
    Title = "Ambient Brightness",
    Min = 0, Max = 2, Default = LC.Brightness, Rounding = 2,
    Callback = function(v)
        LC.Brightness = v
        Lighting.Brightness = v
    end,
})

SecLighting:AddColorpicker("LightingOutdoorAmbient", {
    Title = "Outdoor Ambient",
    Default = LC.OutdoorAmbient,
    Callback = function(v)
        LC.OutdoorAmbient = v
        Lighting.OutdoorAmbient = v
    end,
})

SecLighting:AddDivider()
SecLighting:AddSpace({ Height = 15 })

local colAtmos = SecLighting:AddCollapsibleSection("Atmosphere", "solar/clouds-bold", false)

colAtmos:AddToggle("AtmosEnabled", {
    Title = "Enable Atmosphere",
    Default = LC.AtmosEnabled,
    Callback = function(v)
        LC.AtmosEnabled = v
        local atmos = Lighting:FindFirstChildOfClass("Atmosphere")
        if v then
            if not atmos then
                atmos = Instance.new("Atmosphere")
                atmos.Name = "Atmosphere"
                atmos.Parent = Lighting
            end
            atmos.Density = LC.AtmosDensity
            atmos.Offset = LC.AtmosOffset
            atmos.Haze = LC.AtmosHaze
            atmos.Glare = LC.AtmosGlare
            atmos.Color = LC.AtmosColor
            atmos.Decay = LC.AtmosDecay
        else
            if atmos then atmos:Destroy() end
        end
    end,
})
colAtmos:AddSlider("AtmosDensity", {
    Title = "Density",
    Min = 0, Max = 1, Default = LC.AtmosDensity, Rounding = 2,
    Callback = function(v)
        LC.AtmosDensity = v
        local atmos = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmos then atmos.Density = v end
    end,
})
colAtmos:AddSlider("AtmosOffset", {
    Title = "Offset",
    Min = 0, Max = 1, Default = LC.AtmosOffset, Rounding = 2,
    Callback = function(v)
        LC.AtmosOffset = v
        local atmos = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmos then atmos.Offset = v end
    end,
})
colAtmos:AddSlider("AtmosHaze", {
    Title = "Haze",
    Min = 0, Max = 10, Default = LC.AtmosHaze, Rounding = 1,
    Callback = function(v)
        LC.AtmosHaze = v
        local atmos = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmos then atmos.Haze = v end
    end,
})
colAtmos:AddSlider("AtmosGlare", {
    Title = "Glare",
    Min = 0, Max = 1, Default = LC.AtmosGlare, Rounding = 2,
    Callback = function(v)
        LC.AtmosGlare = v
        local atmos = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmos then atmos.Glare = v end
    end,
})
colAtmos:AddColorpicker("AtmosColor", {
    Title = "Color",
    Default = LC.AtmosColor,
    Callback = function(v)
        LC.AtmosColor = v
        local atmos = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmos then atmos.Color = v end
    end,
})
colAtmos:AddColorpicker("AtmosDecay", {
    Title = "Decay",
    Default = LC.AtmosDecay,
    Callback = function(v)
        LC.AtmosDecay = v
        local atmos = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmos then atmos.Decay = v end
    end,
})

SecLighting:AddSpace({ Height = 15 })

local colSunRay = SecLighting:AddCollapsibleSection("Sun Rays", "solar/sun-bold", false)

colSunRay:AddToggle("SunRayEnabled", {
    Title = "Enable Sun Rays",
    Default = LC.SunRayEnabled,
    Callback = function(v)
        LC.SunRayEnabled = v
        local sr = Lighting:FindFirstChildOfClass("SunRaysEffect")
        if v then
            if not sr then
                sr = Instance.new("SunRaysEffect")
                sr.Name = "SunRaysEffect"
                sr.Parent = Lighting
            end
            sr.Intensity = LC.SunRayIntensity
            sr.Spread = LC.SunRaySpread
        else
            if sr then sr:Destroy() end
        end
    end,
})
colSunRay:AddSlider("SunRayIntensity", {
    Title = "Intensity",
    Min = 0, Max = 1, Default = LC.SunRayIntensity, Rounding = 2,
    Callback = function(v)
        LC.SunRayIntensity = v
        local sr = Lighting:FindFirstChildOfClass("SunRaysEffect")
        if sr then sr.Intensity = v end
    end,
})
colSunRay:AddSlider("SunRaySpread", {
    Title = "Spread",
    Min = 0, Max = 1, Default = LC.SunRaySpread, Rounding = 2,
    Callback = function(v)
        LC.SunRaySpread = v
        local sr = Lighting:FindFirstChildOfClass("SunRaysEffect")
        if sr then sr.Spread = v end
    end,
})

SecLighting:AddSpace({ Height = 15 })

local colCC = SecLighting:AddCollapsibleSection("Color Correction", "solar/eye-bold", false)

colCC:AddToggle("CCEnabled", {
    Title = "Enable Color Correction",
    Default = LC.CcEnabled,
    Callback = function(v)
        LC.CcEnabled = v
        local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
        if v then
            if not cc then
                cc = Instance.new("ColorCorrectionEffect")
                cc.Name = "ColorCorrectionEffect"
                cc.Parent = Lighting
            end
            cc.TintColor = LC.CcTintColor
        else
            if cc then cc:Destroy() end
        end
    end,
})
colCC:AddSlider("CCBrightness", {
    Title = "Brightness",
    Min = -1, Max = 1, Default = LC.CcBrightness, Rounding = 2,
    Callback = function(v)
        LC.CcBrightness = v
        local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
        if cc then cc.Brightness = v end
    end,
})
colCC:AddSlider("CCContrast", {
    Title = "Contrast",
    Min = -1, Max = 1, Default = LC.CcContrast, Rounding = 2,
    Callback = function(v)
        LC.CcContrast = v
        local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
        if cc then cc.Contrast = v end
    end,
})
colCC:AddSlider("CCSaturation", {
    Title = "Saturation",
    Min = -1, Max = 1, Default = LC.CcSaturation, Rounding = 2,
    Callback = function(v)
        LC.CcSaturation = v
        local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
        if cc then cc.Saturation = v end
    end,
})
colCC:AddColorpicker("CCTintColor", {
    Title = "Tint Color",
    Default = LC.CcTintColor,
    Callback = function(v)
        LC.CcTintColor = v
        local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
        if cc then cc.TintColor = v end
    end,
})

SecLighting:AddSpace({ Height = 15 })


local colBloom = SecLighting:AddCollapsibleSection("Bloom", "solar/star-shine-bold", false)

colBloom:AddToggle("BloomEnabled", {
    Title = "Enable Bloom",
    Default = LC.BloomEnabled,
    Callback = function(v)
        LC.BloomEnabled = v
        local bl = Lighting:FindFirstChildOfClass("BloomEffect")
        if v then
            if not bl then
                bl = Instance.new("BloomEffect")
                bl.Name = "BloomEffect"
                bl.Parent = Lighting
            end
        else
            if bl then bl:Destroy() end
        end
    end,
})
colBloom:AddSlider("BloomIntensity", {
    Title = "Intensity",
    Min = 0, Max = 1, Default = LC.BloomIntensity, Rounding = 2,
    Callback = function(v)
        LC.BloomIntensity = v
        local bl = Lighting:FindFirstChildOfClass("BloomEffect")
        if bl then bl.Intensity = v end
    end,
})
colBloom:AddSlider("BloomSize", {
    Title = "Size",
    Min = 0, Max = 56, Default = LC.BloomSize, Rounding = 0,
    Callback = function(v)
        LC.BloomSize = v
        local bl = Lighting:FindFirstChildOfClass("BloomEffect")
        if bl then bl.Size = v end
    end,
})
colBloom:AddSlider("BloomThreshold", {
    Title = "Threshold",
    Min = 0, Max = 1, Default = LC.BloomThreshold, Rounding = 2,
    Callback = function(v)
        LC.BloomThreshold = v
        local bl = Lighting:FindFirstChildOfClass("BloomEffect")
        if bl then bl.Threshold = v end
    end,
})

SecLighting:AddSpace({ Height = 15 })


local colClouds = SecLighting:AddCollapsibleSection("Clouds", "solar/clouds-bold", false)

colClouds:AddToggle("CloudsEnabled", {
    Title = "Enable Clouds",
    Default = LC.CloudsEnabled,
    Callback = function(v)
        LC.CloudsEnabled = v
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if not terrain then return end
        local clouds = terrain:FindFirstChildOfClass("Clouds")
        if v then
            if not clouds then
                clouds = Instance.new("Clouds")
                clouds.Parent = terrain
            end
            clouds.Color = LC.CloudsColor
        else
            if clouds then clouds:Destroy() end
        end
    end,
})
colClouds:AddSlider("CloudsDensity", {
    Title = "Density",
    Min = 0, Max = 1, Default = LC.CloudsDensity, Rounding = 2,
    Callback = function(v)
        LC.CloudsDensity = v
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if not terrain then return end
        local clouds = terrain:FindFirstChildOfClass("Clouds")
        if clouds then clouds.Density = v end
    end,
})
colClouds:AddSlider("CloudsCover", {
    Title = "Cover",
    Min = 0, Max = 1, Default = LC.CloudsCover, Rounding = 2,
    Callback = function(v)
        LC.CloudsCover = v
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if not terrain then return end
        local clouds = terrain:FindFirstChildOfClass("Clouds")
        if clouds then clouds.Cover = v end
    end,
})
colClouds:AddColorpicker("CloudsColor", {
    Title = "Color",
    Default = LC.CloudsColor,
    Callback = function(v)
        LC.CloudsColor = v
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if not terrain then return end
        local clouds = terrain:FindFirstChildOfClass("Clouds")
        if clouds then clouds.Color = v end
    end,
})

SecLighting:AddSpace({ Height = 15 })

local colBlur = SecLighting:AddCollapsibleSection("Blur", "solar/layers-minimalistic-bold", false)

colBlur:AddToggle("BlurEnabled", {
    Title = "Enable Blur",
    Default = LC.BlurEnabled,
    Callback = function(v)
        LC.BlurEnabled = v
        local blur = Lighting:FindFirstChildOfClass("BlurEffect")
        if v then
            if not blur then
                blur = Instance.new("BlurEffect")
                blur.Name = "BlurEffect"
                blur.Parent = Lighting
            end
        else
            if blur then blur:Destroy() end
        end
    end,
})
colBlur:AddSlider("BlurSize", {
    Title = "Size",
    Min = 0, Max = 56, Default = LC.BlurSize, Rounding = 0,
    Callback = function(v)
        LC.BlurSize = v
        local blur = Lighting:FindFirstChildOfClass("BlurEffect")
        if blur then blur.Size = v end
    end,
})

SecLighting:AddSpace({ Height = 15 })


local colDoF = SecLighting:AddCollapsibleSection("Depth Of Field", "solar/camera-bold", false)

colDoF:AddToggle("DoFEnabled", {
    Title = "Enable Depth Of Field",
    Default = LC.DofEnabled,
    Callback = function(v)
        LC.DofEnabled = v
        local cam = workspace.CurrentCamera
        local dof = cam:FindFirstChildOfClass("DepthOfFieldEffect")
        if v then
            GetOrCreateDoF()
        else
            if dof then dof:Destroy() end
        end
    end,
})
colDoF:AddSlider("DoFFocusDistance", {
    Title = "Focus Distance",
    Min = 0, Max = 150, Default = LC.DofFocusDistance, Rounding = 0,
    Callback = function(v)
        LC.DofFocusDistance = v
        local dof = workspace.CurrentCamera:FindFirstChildOfClass("DepthOfFieldEffect")
        if dof then dof.FocusDistance = v end
    end,
})
colDoF:AddSlider("DoFInFocusRadius", {
    Title = "In-Focus Radius",
    Min = 0, Max = 50, Default = LC.DofInFocusRadius, Rounding = 0,
    Callback = function(v)
        LC.DofInFocusRadius = v
        local dof = workspace.CurrentCamera:FindFirstChildOfClass("DepthOfFieldEffect")
        if dof then dof.InFocusRadius = v end
    end,
})
colDoF:AddSlider("DoFNearIntensity", {
    Title = "Near Intensity",
    Min = 0, Max = 1, Default = LC.DofNearIntensity, Rounding = 2,
    Callback = function(v)
        LC.DofNearIntensity = v
        local dof = workspace.CurrentCamera:FindFirstChildOfClass("DepthOfFieldEffect")
        if dof then dof.NearIntensity = v end
    end,
})
colDoF:AddSlider("DoFFarIntensity", {
    Title = "Far Intensity",
    Min = 0, Max = 1, Default = LC.DofFarIntensity, Rounding = 2,
    Callback = function(v)
        LC.DofFarIntensity = v
        local dof = workspace.CurrentCamera:FindFirstChildOfClass("DepthOfFieldEffect")
        if dof then dof.FarIntensity = v end
    end,
})

SecLighting:AddSpace({ Height = 15 })


SecSetTime = Tabs.Visual:AddSection("Set Time", "solar/clock-circle-bold")
SecSetTime:AddSpace({ Height = 15 })

local SetTimeInput = ""
local SetTimeEnabled = false
local SetTimeConnection = nil

local function ApplyLightingTime(TimeStr)
    local H, M = TimeStr:match("^(%d+):(%d+)$")
    H, M = tonumber(H), tonumber(M)
    if not H or not M or H > 23 or M > 59 then
        Notify("Set Time", "Invalid format! Use HH:MM (e.g. 14:30)", "Error", nil, 3)
        return false
    end
    Lighting.TimeOfDay = string.format("%02d:%02d:00", H, M)
    return true
end

SecSetTime:AddInput("SetTimeInput", {
    Title = "Time (HH:MM)",
    Placeholder = "e.g. 14:30",
    Numeric = false,
    Callback = function(Value)
        SetTimeInput = Value
    end,
})

SecSetTime:AddDivider()
SecSetTime:AddSpace({ Height = 15 })
SecSetTime:AddDivider()

SecSetTime:AddButton({
    Title = "Apply Time",
    Callback = function()
        if ApplyLightingTime(SetTimeInput) then
            Notify("Set Time", "Time set to " .. SetTimeInput, "Success", nil, 3)
        end
    end,
})

SecSetTime:AddToggle("SetTimeLockToggle", {
    Title = "Lock Time",
    Description = "Prevent the game from changing the time",
    Default = false,
    Callback = function(State)
        SetTimeEnabled = State
        if SetTimeConnection then
            SetTimeConnection:Disconnect()
            SetTimeConnection = nil
        end
        if State then
            if SetTimeInput == "" then
                Notify("Set Time", "Enter a time first!", "Warning", nil, 3)
                return
            end
            ApplyLightingTime(SetTimeInput)
            SetTimeConnection = RunService.Heartbeat:Connect(function()
                if not SetTimeEnabled then return end
                local H, M = SetTimeInput:match("^(%d+):(%d+)$")
                if H and M then
                    Lighting.TimeOfDay = string.format("%02d:%02d:00", tonumber(H), tonumber(M))
                end
            end)
        end
    end,
})

SecSetTime:AddSpace({ Height = 15 })

-- Credit To https://youtube.com/@r0l1?si=ecl7FwqRWTAnR0w5 , https://pvprp.com/profile/xThonyG , https://pvprp.com/profile/SVENZZY8
BuiltInSkyboxes = {
    ["[sfw] Waguri"] = {
        Folder = "GoonWares/Skyboxes/Waguri",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Waguri/waguri_ft.png", File = "Waguri_bk.png" },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Waguri/waguri_bk.png", File = "Waguri_ft.png" },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Waguri/waguri_rt.png", File = "Waguri_lf.png" },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Waguri/waguri_lf.png", File = "Waguri_rt.png" },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Waguri/waguri_up.png", File = "Waguri_up.png" },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Waguri/waguri_dn.png", File = "Waguri_dn.png" },
        },
    },
    ["[sfw] Reynai"] = {
        Folder = "GoonWares/Skyboxes/Reynai",
        ResetHaze = true,
        Faces = {
        	{ Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Reynai/back.png", File = "Reynai_bk.png" },
	        { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Reynai/front.png", File = "Reynai_ft.png" },
	        { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Reynai/left.png", File = "Reynai_lf.png" },
        	{ Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Reynai/right.png", File = "Reynai_rt.png" },
	        { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Reynai/top.png", File = "Reynai_up.png" },
	        { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Reynai/down.png", File = "Reynai_dn.png" },
       },
    },
    ["[mature] Cryene"] = {
        Folder = "GoonWares/Skyboxes/cryene",
        ResetHaze = true,
        Faces = {
        	{ Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Cryene/back.png", File = "Cryene_bk.png" },
	        { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Cryene/front.png", File = "Cryene_ft.png" },
	        { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Cryene/left.png", File = "Cryene_lf.png" },
        	{ Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Cryene/right.png", File = "Cryene_rt.png" },
	        { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Cryene/Top.png", File = "Cryene_up.png" },
	        { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Cryene/down.png", File = "Cryene_dn.png" },
       },
    },
    ["[sfw] Yue"] = {
        Folder = "GoonWares/Skyboxes/Yue",
        ResetHaze = true,
        Faces = {
        { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Yue/Yue-Back.png", File = "YueBack.png" },
        { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Yue/Yue-Front.png", File = "YueFront.png" },
        { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Yue/Yue-Left.png", File = "YueLeft.png" },
        { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Yue/Yue-Right.png", File = "YueRight.png" },
        { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Yue/Yue-Top.png", File = "YueTop.png" },
        { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Yue/Yue-Down.png", File = "YueDown.png" },
        },
    },
    ["[sfw] miku "] = {
        Folder = "GoonWares/Skyboxes/miku",
        ResetHaze = true,
        Faces = {
        	{ Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Miku/Miku-Back.png", File = "back1m.png" },
	        { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Miku/Miku-Front.png", File = "front1m.png" },
	        { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Miku/Miku-Left.png", File = "left1m.png" },
        	{ Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Miku/Miku-Right.png", File = "rightm.png" },
	        { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Miku/Miku-Top.png", File = "up1m.png" },
	        { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Miku/Miku-Down.png", File = "dn1m.png" },
       },
    },
    ["[nsfw] RiasGremory"] = {
        Folder = "GoonWares/Skyboxes/RiasGremory",
        ResetHaze = true,
        Faces = {
        	{ Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/RiasGremory/RiasGremory-Back.png", File = "back1r.png" },
	        { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/RiasGremory/RiasGremory-Front.png", File = "front1r.png" },
	        { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/RiasGremory/RiasGremory-Left.png", File = "left1r.png" },
        	{ Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/RiasGremory/RiasGremory-Right.png", File = "rightr.png" },
	        { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/RiasGremory/RiasGremory-Top.png", File = "up1r.png" },
	        { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/RiasGremory/RiasGremory-Down.png", File = "dn1r.png" },
       },
    },
    ["[nsfw] MaiSakurajima"] = {
        Folder = "GoonWares/Skyboxes/18+ MaiSakurajima",
        ResetHaze = true,
        Faces = {
        	{ Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/MaiSakurajima-Back.png", File = "backm.png" },
	        { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/MaiSakurajima-Front.png", File = "frontm.png" },
	        { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/MaiSakurajima-Left.png", File = "leftm.png" },
        	{ Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/MaiSakurajima-Right.png", File = "rightm.png" },
	        { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/MaiSakurajima-Top.png", File = "upm.png" },
	        { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/MaiSakurajima-Down.png", File = "dnm.png" },
       },
    },
    ["[nsfw] Elbe"] = {
        Folder = "GoonWares/Skyboxes/Elbe",
        ResetHaze = true,
        Faces = {
        	{ Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Elbe/Elbe-AzurLane-Back.png", File = "back1.png" },
	        { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Elbe/Elbe-AzurLane-Front.png", File = "front1.png" },
	        { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Elbe/Elbe-AzurLane-Left.png", File = "left1.png" },
        	{ Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Elbe/Elbe-AzurLane-Right.png", File = "right.png" },
	        { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Elbe/Elbe-AzurLane-Top.png", File = "up1.png" },
	        { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Elbe/Elbe-AzurLane-Down.png", File = "dn1.png" },
       },
    },
    ["[nsfw] Mitsuri"] = {
        Folder = "GoonWares/Skyboxes/Mitsuri",
        ResetHaze = true,
        Faces = {
        	{ Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Mitsuri/Mitsuri-Back.png", File = "backMit.png" },
	        { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Mitsuri/Mitsuri-Front.png", File = "frontMit.png" },
	        { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Mitsuri/Mitsuri-Left.png", File = "leftMit.png" },
        	{ Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Mitsuri/Mitsuri-Right.png", File = "rightMit.png" },
	        { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Mitsuri/Mitsuri-Top.png", File = "upMit.png" },
	        { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Mitsuri/Mitsuri-Down.png", File = "dnMit.png" },
       },
    },
    ["[nsfw] Itsuki Nakano"] = {
        Folder = "GoonWares/Skyboxes/ItsukiNakano",
        ResetHaze = true,
        Faces = {
        	{ Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/Itsuki-Nakano-Back.png", File = "back1its.png" },
	        { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/Itsuki-Nakano-Front.png", File = "front1its.png" },
	        { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/Itsuki-Nakano-Left.png", File = "left1its.png" },
        	{ Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/Itsuki-Nakano-Right.png", File = "rightits.png" },
	        { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/Itsuki-Nakano-Top.png", File = "up1its.png" },
	        { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/Itsuki-Nakano-Down.png", File = "dn1its.png" },
       },
    },
    ["[sfw] EllenJoe"] = {
        Folder = "GoonWares/Skyboxes/Ellen-Joe",
        ResetHaze = true,
        Faces = {
        { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/EllenJoe/Ellen-Joe-Back.png", File = "EllenJoeBack.png" },
        { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/EllenJoe/Ellen-Joe-Front.png", File = "EllenJoeFront.png" },
        { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/EllenJoe/Ellen-Joe-Left.png", File = "EllenJoeLeft.png" },
        { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/EllenJoe/Ellen-Joe-Right.png", File = "EllenJoeRight.png" },
        { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/EllenJoe/Ellen-Joe-Top.png", File = "EllenJoeTop.png" },
        { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/EllenJoe/Ellen-Joe-Down.png", File = "EllenJoeDown.png" },
        },
    },
    ["[nsfw] Lucoa"] = {
        Folder = "GoonWares/Skyboxes/Lucoa",
        ResetHaze = true,
        Faces = {
        { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Lucoa/Lucoa-Back.png", File = "LucoaBack.png" },
        { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Lucoa/Lucoa-Front.png", File = "LucoaFront.png" },
        { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Lucoa/Lucoa-Left.png", File = "LucoaLeft.png" },
        { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Lucoa/Lucoa-Right.png", File = "LucoaRight.png" },
        { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Lucoa/Lucoa-Top.png", File = "LucoaTop.png" },
        { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Lucoa/Lucoa-Down.png", File = "LucoaDown.png" },
        },
    },
    ["Castorice"] = {
        Folder = "GoonWares/Skyboxes/Castorice",
        ResetHaze = true,
        Faces = {
        	{ Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Castorice/back.png", File = "Castorice_bk.png" },
	        { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Castorice/front.png", File = "Castorice_ft.png" },
	        { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Castorice/left.png", File = "Castorice_lf.png" },
        	{ Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Castorice/right.png", File = "Castorice_rt.png" },
	        { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Castorice/top.png", File = "Castorice_up.png" },
	        { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Castorice/down.png", File = "Castorice_dn.png" },
       },
    },
	["[sfw] IochiMari"] = {
        Folder = "GoonWares/Skyboxes/IochiMari",
        ResetHaze = true,
        Faces = {
        	{ Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/IochiMari/back.png", File = "IochiMari_bk.png" },
	        { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/IochiMari/front.png", File = "IochiMari_ft.png" },
	        { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/IochiMari/left.png", File = "IochiMari_lf.png" },
        	{ Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/IochiMari/right.png", File = "IochiMari_rt.png" },
	        { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/IochiMari/top.png", File = "IochiMari_up.png" },
	        { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/IochiMari/down.png", File = "IochiMari_dn.png" },
       },
    },
    ["[sfw] Hoshimachi"] = {
        Folder = "GoonWares/Skyboxes/Hoshimachi",
        ResetHaze = true,
        Faces = {
        	{ Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Hoshimachi/back.png", File = "_bk.png" },
	        { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Hoshimachi/front.png", File = "_ft.png" },
	        { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Hoshimachi/left.png", File = "_lf.png" },
        	{ Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Hoshimachi/right.png", File = "_rt.png" },
	        { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Hoshimachi/top.png", File = "_up.png" },
	        { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Hoshimachi/down.png", File = "_dn.png" },
       },
    },
    ["[mature] Hoshino"] = {
        Folder = "GoonWares/Skyboxes/Hoshino",
        ResetHaze = true,
        Faces = {
        	{ Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Hoshino/back.png", File = "Hoshino_bk.png" },
	        { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Hoshino/front.png", File = "Hoshino_ft.png" },
	        { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Hoshino/left.png", File = "Hoshino_lf.png" },
        	{ Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Hoshino/right.png", File = "Hoshino_rt.png" },
	        { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Hoshino/top.png", File = "Hoshino_up.png" },
	        { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Hoshino/down.png", File = "Hoshino_dn.png" },
       },
    },
    ["[nsfw] Rossweisse"] = {
        Folder = "GoonWares/Skyboxes/Rossweisse",
        ResetHaze = true,
        Faces = {
        	{ Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rossweisse/back.png", File = "Rossweisse_bk.png" },
	        { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rossweisse/front.png", File = "Rossweisse_ft.png" },
	        { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rossweisse/left.png", File = "Rossweisse_lf.png" },
        	{ Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rossweisse/right.png", File = "Rossweisse_rt.png" },
	        { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rossweisse/top.png", File = "Rossweisse_up.png" },
	        { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rossweisse/down.png", File = "Rossweisse_dn.png" },
       },
    },
    ["[sfw] ItsukiNakano"] = {
        Folder = "GoonWares/Skyboxes/ItsukiNakano",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/ItsukiNakano_Bk.png", File = "ItsukiNakano_Bk.png" },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/ItsukiNakano_Ft.png", File = "ItsukiNakano_Ft.png" },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/ItsukiNakano_Lf.png", File = "ItsukiNakano_Lf.png" },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/ItsukiNakano_Rt.png", File = "ItsukiNakano_Rt.png" },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/ItsukiNakano_Up.png", File = "ItsukiNakano_Up.png" },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano/ItsukiNakano_Dn.png", File = "ItsukiNakano_Dn.png" },
        },
    },
    ["[sfw] ItsukiNakano2"] = {
        Folder = "GoonWares/Skyboxes/ItsukiNakano2",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano2/ItsukiNakano2_Bk.png", File = "ItsukiNakano2_Bk.png" },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano2/ItsukiNakano2_Ft.png", File = "ItsukiNakano2_Ft.png" },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano2/ItsukiNakano2_Lf.png", File = "ItsukiNakano2_Lf.png" },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano2/ItsukiNakano2_Rt.png", File = "ItsukiNakano2_Rt.png" },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano2/ItsukiNakano2_Up.png", File = "ItsukiNakano2_Up.png" },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/ItsukiNakano2/ItsukiNakano2_Dn.png", File = "ItsukiNakano2_Dn.png" },
        },
    },
    ["[sfw] MaiSakurajima"] = {
        Folder = "GoonWares/Skyboxes/MaiSakurajima",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/top.png", File = "MaiSakurajima_up.png" },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/down.png", File = "MaiSakurajima_dn.png" },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/left.png", File = "MaiSakurajima_lf.png" },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/right.png", File = "MaiSakurajima_rt.png" },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/front.png", File = "MaiSakurajima_ft.png" },
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MaiSakurajima/back.png", File = "MaiSakurajima_bk.png" },
        },
    },
    ["[mature] Nakiri-Ayame [Heavy:50+mb]"] = {
        Folder = "GoonWares/Skyboxes/Nakiri-Ayame",
        ResetHaze = true,
        Faces = {
        { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Nakiri-Ayame/Nakiri-Ayame-Back.png", File = "Nakiri-AyameBack.png" },
        { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Nakiri-Ayame/Nakiri-Ayame-Front.png", File = "Nakiri-AyameFront.png" },
        { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Nakiri-Ayame/Nakiri-Ayame-Left.png", File = "Nakiri-AyameLeft.png" },
        { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Nakiri-Ayame/Nakiri-Ayame-Right.png", File = "Nakiri-AyameRight.png" },
        { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Nakiri-Ayame/Nakiri-Ayame-Top.png", File = "Nakiri-AyameTop.png" },
        { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Nakiri-Ayame/Nakiri-Ayame-Down.png", File = "Nakiri-AyameDown.png" },
        },
    },
    ["[mature] MikuNakano"] = {
        Folder = "GoonWares/Skyboxes/MikuNakano",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MikuNakano/MikuNakano_Bk.png", File = "MikuNakano_Bk.png" },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MikuNakano/MikuNakano_Ft.png", File = "MikuNakano_Ft.png" },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MikuNakano/MikuNakano_Lf.png", File = "MikuNakano_Lf.png" },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MikuNakano/MikuNakano_Rt.png", File = "MikuNakano_Rt.png" },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MikuNakano/MikuNakano_Up.png", File = "MikuNakano_Up.png" },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/MikuNakano/MikuNakano_Dn.png", File = "MikuNakano_Dn.png" },
        },
    },
    ["[sfw] TohkaYatogami"] = {
        Folder = "GoonWares/Skyboxes/TohkaYatogami",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami_BK.png", File = "TohkaYatogami_BK.png" },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami_FT.png", File = "TohkaYatogami_FT.png" },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami_LF.png", File = "TohkaYatogami_LF.png" },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami_RT.png", File = "TohkaYatogami_RT.png" },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami_UP.png", File = "TohkaYatogami_UP.png" },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami_DN.png", File = "TohkaYatogami_DN.png" },
        },
    },
    ["[sfw] TohkaYatogami2"] = {
        Folder = "GoonWares/Skyboxes/TohkaYatogami",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami2_BK.png", File = "TohkaYatogami2_BK.png" },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami2_FT.png", File = "TohkaYatogami2_FT.png" },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami2_LF.png", File = "TohkaYatogami2_LF.png" },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami2_RT.png", File = "TohkaYatogami2_RT.png" },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami2_UP.png", File = "TohkaYatogami2_UP.png" },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/TohkaYatogami/TohkaYatogami2_DN.png", File = "TohkaYatogami2_DN.png" },
        },
    },
    ["[mature] LilithAsami"] = {
        Folder = "GoonWares/Skyboxes/LilithAsami",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/LilithAsami/LilithAsami_BK.png", File = "LilithAsami_BK.png" },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/LilithAsami/LilithAsami_FT.png", File = "LilithAsami_FT.png" },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/LilithAsami/LilithAsami_LF.png", File = "LilithAsami_LF.png" },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/LilithAsami/LilithAsami_RT.png", File = "LilithAsami_RT.png" },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/LilithAsami/LilithAsami_UP.png", File = "LilithAsami_UP.png" },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/LilithAsami/LilithAsami_DN.png", File = "LilithAsami_DN.png" },
        },
    },
    ["[sfw] Evernight"] = {
        Folder = "GoonWares/Skyboxes/Evernight",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Evernight/evernight_RT.png", File = "SkyRt.png" },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Evernight/evernight_LF.png", File = "SkyLf.png" },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Evernight/evernight_BK.png", File = "SkyBk.png" },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Evernight/evernight_FT.png", File = "SkyFt.png" },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Evernight/evernight_UP.png", File = "SkyUp.png" },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Evernight/evernight_DN.png", File = "SkyDn.png" },
        },
    },
    ["[nsfw] Rem"] = {
        Folder = "GoonWares/Skyboxes/Rem",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rem/Rem-ReZero-Back.png", File = "SkyBk.png" },
            { Prop = "SkyboxRt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rem/Rem-ReZero-Right.png", File = "SkyRt.png" },
            { Prop = "SkyboxLf", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rem/Rem-ReZero-Left.png", File = "SkyLf.png" },
            { Prop = "SkyboxFt", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rem/Rem-ReZero-Front.png", File = "SkyFt.png" },
            { Prop = "SkyboxUp", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rem/Rem-ReZero-Top.png", File = "SkyUp.png" },
            { Prop = "SkyboxDn", Url = "https://raw.githubusercontent.com/StyearX/Custom-skybox/main/Rem/Rem-ReZero-Down.png", File = "SkyDn.png" },
        },
    },
    ["[mature] Xenovia Quarta"] = {
        Folder = "GoonWares/Skyboxes/XenoviaQuarta",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxLf", Url = "https://od.lk/d/NjNfOTg0NjM0ODhf/if.png", File = "if.png" },
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NjM0ODlf/ft.png", File = "ft.png" },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NjM0OTBf/dn.png", File = "dn.png" },
            { Prop = "SkyboxFt", Url = "https://od.lk/d/NjNfOTg0NjM0OTFf/bk.png", File = "bk.png" },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NjM0ODZf/up.png", File = "up.png" },
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NjM0ODdf/rt.png", File = "rt.png" },
        },
    },
    ["[sfw] Nino Nakano"] = {
        Folder = "GoonWares/Skyboxes/NinoNakano",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NjQyODNf/right1.png", File = "right1.png" },
            { Prop = "SkyboxLf", Url = "https://od.lk/d/NjNfOTg0NjQyNzhf/back.png", File = "back.png" },
            { Prop = "SkyboxFt", Url = "https://od.lk/d/NjNfOTg0NjQyODBf/front.png", File = "front.png" },
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NjQyODJf/left1.png", File = "left1.png" },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NjQyNzlf/down.png", File = "down.png" },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NjQyODFf/up.png", File = "up.png" },
        },
    },
    ["[sfw] Nino Nakano 2"] = {
        Folder = "GoonWares/Skyboxes/NinoNakano2",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NjQyNTJf/rt.png", File = "rt.png" },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NjQyNTBf/up.png", File = "up.png" },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NjQyNTVf/dn.png", File = "dn.png" },
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NjQyNTNf/if.png", File = "if.png" },
            { Prop = "SkyboxFt", Url = "https://od.lk/d/NjNfOTg0NjQyNTZf/bk.png", File = "bk.png" },
            { Prop = "SkyboxLf", Url = "https://od.lk/d/NjNfOTg0NjQyNTRf/ft.png", File = "ft.png" },
        },
    },
    ["[sfw] Saki Saki"] = {
        Folder = "GoonWares/Skyboxes/SakiSaki",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NjQyNzNf/right.png", File = "right.png" },
            { Prop = "SkyboxLf", Url = "https://od.lk/d/NjNfOTg0NjQyNzBf/left.png", File = "left.png" },
            { Prop = "SkyboxFt", Url = "https://od.lk/d/NjNfOTg0NjQyNjhf/front1.png", File = "front1.png" },
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NjQyNjZf/back1.png", File = "back1.png" },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NjQyNjdf/down1.png", File = "down1.png" },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NjQyNjlf/Up1.png", File = "Up1.png" },
        },
    },
    ["[mature] Rias Gremory"] = {
        Folder = "GoonWares/Skyboxes/RiasGremory",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NzkyOTFf/RightRias.png", File = "RightRias.png" },
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NzkyOTNf/leftRias.png", File = "leftRias.png" },
            { Prop = "SkyboxFt", Url = "https://od.lk/d/NjNfOTg0NzkyOTVf/front%20Rias.png", File = "frontRias.png" },
            { Prop = "SkyboxLf", Url = "https://od.lk/d/NjNfOTg0NzkyOTRf/BackRias.png", File = "BackRias.png" },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NzkyOThf/downRias.png", File = "downRias.png" },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NzkyOTJf/UpRias.png", File = "UpRias.png" },
        },
    },
    ["[sfw] Yotsuba Nakano"] = {
        Folder = "GoonWares/Skyboxes/YotsubaNakano",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NzkzMzdf/YotsubaRt.png", File = "YotsubaRt.png" },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NzkzMzhf/YotsubaUp.png", File = "YotsubaUp.png" },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NzkzMzNf/YotsubaDn.png", File = "YotsubaDn.png" },
            { Prop = "SkyboxFt", Url = "https://od.lk/d/NjNfOTg0NzkzMzRf/YotsubaFt.png", File = "YotsubaFt.png" },
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NzkzMzFf/YotsubaBk.png", File = "YotsubaBk.png" },
            { Prop = "SkyboxLf", Url = "https://od.lk/d/NjNfOTg0NzkzMzZf/YotsubaLeft.png", File = "YotsubaLeft.png" },
        },
    },
    ["[sfw] Hakari Hananozo"] = {
        Folder = "GoonWares/Skyboxes/hk",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NjEzMTVf/SkyBk.tex", File = "SkyBk.png" },
            { Prop = "SkyboxFt", Url = "https://od.lk/s/NjNfOTg0NjEzMTdf/SkyFt.tex", File = "SkyFt.png" },
            { Prop = "SkyboxLf", Url = "https://od.lk/s/NjNfOTg0NjEzMThf/SkyIf.tex", File = "SkyIf.png" },
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NjEzMTlf/SkyRt.tex", File = "SkyRt.png" },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NjEzMjBf/SkyUp.tex", File = "SkyUp.png" },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NjEzMTZf/Skydn.tex", File = "Skydn.png" },
        },
    },
    ["[sfw] Alya"] = {
        Folder = "GoonWares/Skyboxes/Alya",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NzkzMTZf/Rt.png", File = "Rt.png" },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NzkzMTVf/Up.png", File = "Up.png" },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NzkzMTJf/dn.png", File = "dn.png" },
            { Prop = "SkyboxFt", Url = "https://od.lk/d/NjNfOTg0NzkzMTNf/ft.png", File = "ft.png" },
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NzkzMTFf/bk.png", File = "bk.png" },
            { Prop = "SkyboxLf", Url = "https://od.lk/d/NjNfOTg0NzkzMTRf/if.png", File = "if.png" },
        },
    },
    ["[sfw] Alya 2"] = {
        Folder = "GoonWares/Skyboxes/Alya2",
        ResetHaze = true,
        Faces = {
            { Prop = "SkyboxRt", Url = "https://od.lk/d/NjNfOTg0NzkzMjRf/AlyaRt.png", File = "AlyaRt.png" },
            { Prop = "SkyboxUp", Url = "https://od.lk/d/NjNfOTg0NzkzMjVf/AlyaUp.png", File = "AlyaUp.png" },
            { Prop = "SkyboxDn", Url = "https://od.lk/d/NjNfOTg0NzkzMjFf/alyaDn.png", File = "alyaDn.png" },
            { Prop = "SkyboxFt", Url = "https://od.lk/d/NjNfOTg0NzkzMjJf/AlyaFt.png", File = "AlyaFt.png" },
            { Prop = "SkyboxBk", Url = "https://od.lk/d/NjNfOTg0NzkzMjBf/AlyaBk.png", File = "AlyaBk.png" },
            { Prop = "SkyboxLf", Url = "https://od.lk/d/NjNfOTg0NzkzMjNf/AlyaLf.png", File = "AlyaLf.png" },
        },
    },
    ["Iteration 3.2.0"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxLf = "rbxassetid://111969418190645",
            SkyboxFt = "rbxassetid://86300370158690",
            SkyboxRt = "rbxassetid://90660761614046",
            SkyboxBk = "rbxassetid://94155581950702",
            SkyboxDn = "rbxassetid://74377450776557",
            SkyboxUp = "rbxassetid://110123630908028",
        },
        StarCount = 3000,
        SunAngularSize = 0,
        MoonAngularSize = 0,
    },
    ["IterationT Remake"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxLf = "rbxassetid://131895067742893",
            SkyboxFt = "rbxassetid://139394863985793",
            SkyboxRt = "rbxassetid://93313124175539",
            SkyboxBk = "rbxassetid://93271230842735",
            SkyboxDn = "rbxassetid://72142305760362",
            SkyboxUp = "rbxassetid://86656757951125",
        },
        StarCount = 3000,
        SunAngularSize = 0,
        MoonAngularSize = 0,
    },
    ["Black Storm"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://15502511288",
            SkyboxDn = "rbxassetid://15502508460",
            SkyboxFt = "rbxassetid://15502510289",
            SkyboxLf = "rbxassetid://15502507918",
            SkyboxRt = "rbxassetid://15502509398",
            SkyboxUp = "rbxassetid://15502511911",
        },
    },
    ["HD"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://16553658937",
            SkyboxDn = "rbxassetid://16553660713",
            SkyboxFt = "rbxassetid://16553662144",
            SkyboxLf = "rbxassetid://16553664042",
            SkyboxRt = "rbxassetid://16553665766",
            SkyboxUp = "rbxassetid://16553667750",
        },
    },
    ["Snow"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://155657655",
            SkyboxDn = "rbxassetid://155674246",
            SkyboxFt = "rbxassetid://155657609",
            SkyboxLf = "rbxassetid://155657671",
            SkyboxRt = "rbxassetid://155657619",
            SkyboxUp = "rbxassetid://155674931",
        },
    },
    ["Blue Space"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://15536110634",
            SkyboxDn = "rbxassetid://15536112543",
            SkyboxFt = "rbxassetid://15536116141",
            SkyboxLf = "rbxassetid://15536114370",
            SkyboxRt = "rbxassetid://15536118762",
            SkyboxUp = "rbxassetid://15536117282",
        },
    },
    ["Realistic"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://653719502",
            SkyboxDn = "rbxassetid://653718790",
            SkyboxFt = "rbxassetid://653719067",
            SkyboxLf = "rbxassetid://653719190",
            SkyboxRt = "rbxassetid://653718931",
            SkyboxUp = "rbxassetid://653719321",
        },
    },
    ["Stormy"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://18703245834",
            SkyboxDn = "rbxassetid://18703243349",
            SkyboxFt = "rbxassetid://18703240532",
            SkyboxLf = "rbxassetid://18703237556",
            SkyboxRt = "rbxassetid://18703235430",
            SkyboxUp = "rbxassetid://18703232671",
        },
    },
    ["Pink"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://12216109205",
            SkyboxDn = "rbxassetid://12216109875",
            SkyboxFt = "rbxassetid://12216109489",
            SkyboxLf = "rbxassetid://12216110170",
            SkyboxRt = "rbxassetid://12216110471",
            SkyboxUp = "rbxassetid://12216108877",
        },
    },
    ["Sunset"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://600830446",
            SkyboxDn = "rbxassetid://600831635",
            SkyboxFt = "rbxassetid://600832720",
            SkyboxLf = "rbxassetid://600886090",
            SkyboxRt = "rbxassetid://600833862",
            SkyboxUp = "rbxassetid://600835177",
        },
    },
    ["Arctic"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://225469390",
            SkyboxDn = "rbxassetid://225469395",
            SkyboxFt = "rbxassetid://225469403",
            SkyboxLf = "rbxassetid://225469450",
            SkyboxRt = "rbxassetid://225469471",
            SkyboxUp = "rbxassetid://225469481",
        },
    },
    ["Space"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://166509999",
            SkyboxDn = "rbxassetid://166510057",
            SkyboxFt = "rbxassetid://166510116",
            SkyboxLf = "rbxassetid://166510092",
            SkyboxRt = "rbxassetid://166510131",
            SkyboxUp = "rbxassetid://166510114",
        },
    },
    ["Roblox Default"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxasset://textures/sky/sky512_bk.tex",
            SkyboxDn = "rbxasset://textures/sky/sky512_dn.tex",
            SkyboxFt = "rbxasset://textures/sky/sky512_ft.tex",
            SkyboxLf = "rbxasset://textures/sky/sky512_lf.tex",
            SkyboxRt = "rbxasset://textures/sky/sky512_rt.tex",
            SkyboxUp = "rbxasset://textures/sky/sky512_up.tex",
        },
    },
    ["Red Night"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://401664839",
            SkyboxDn = "rbxassetid://401664862",
            SkyboxFt = "rbxassetid://401664960",
            SkyboxLf = "rbxassetid://401664881",
            SkyboxRt = "rbxassetid://401664901",
            SkyboxUp = "rbxassetid://401664936",
        },
    },
    ["Deep Space 1"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://149397692",
            SkyboxDn = "rbxassetid://149397686",
            SkyboxFt = "rbxassetid://149397697",
            SkyboxLf = "rbxassetid://149397684",
            SkyboxRt = "rbxassetid://149397688",
            SkyboxUp = "rbxassetid://149397702",
        },
    },
    ["Pink Skies"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://151165214",
            SkyboxDn = "rbxassetid://151165197",
            SkyboxFt = "rbxassetid://151165224",
            SkyboxLf = "rbxassetid://151165191",
            SkyboxRt = "rbxassetid://151165206",
            SkyboxUp = "rbxassetid://151165227",
        },
    },
    ["Purple Sunset"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://264908339",
            SkyboxDn = "rbxassetid://264907909",
            SkyboxFt = "rbxassetid://264909420",
            SkyboxLf = "rbxassetid://264909758",
            SkyboxRt = "rbxassetid://264908886",
            SkyboxUp = "rbxassetid://264907379",
        },
    },
    ["Blue Night"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://12064107",
            SkyboxDn = "rbxassetid://12064152",
            SkyboxFt = "rbxassetid://12064121",
            SkyboxLf = "rbxassetid://12063984",
            SkyboxRt = "rbxassetid://12064115",
            SkyboxUp = "rbxassetid://12064131",
        },
    },
    ["Blossom Daylight"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://271042516",
            SkyboxDn = "rbxassetid://271077243",
            SkyboxFt = "rbxassetid://271042556",
            SkyboxLf = "rbxassetid://271042310",
            SkyboxRt = "rbxassetid://271042467",
            SkyboxUp = "rbxassetid://271077958",
        },
    },
    ["Blue Nebula"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://135207744",
            SkyboxDn = "rbxassetid://135207662",
            SkyboxFt = "rbxassetid://135207770",
            SkyboxLf = "rbxassetid://135207615",
            SkyboxRt = "rbxassetid://135207695",
            SkyboxUp = "rbxassetid://135207794",
        },
    },
    ["Blue Planet"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://218955819",
            SkyboxDn = "rbxassetid://218953419",
            SkyboxFt = "rbxassetid://218954524",
            SkyboxLf = "rbxassetid://218958493",
            SkyboxRt = "rbxassetid://218957134",
            SkyboxUp = "rbxassetid://218950090",
        },
    },
    ["Deep Space 2"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://159248188",
            SkyboxDn = "rbxassetid://159248183",
            SkyboxFt = "rbxassetid://159248187",
            SkyboxLf = "rbxassetid://159248173",
            SkyboxRt = "rbxassetid://159248192",
            SkyboxUp = "rbxassetid://159248176",
        },
    },
    ["Summer"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://16648590964",
            SkyboxDn = "rbxassetid://16648617436",
            SkyboxFt = "rbxassetid://16648595424",
            SkyboxLf = "rbxassetid://16648566370",
            SkyboxRt = "rbxassetid://16648577071",
            SkyboxUp = "rbxassetid://16648598180",
        },
    },
    ["Galaxy"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://15983968922",
            SkyboxDn = "rbxassetid://15983966825",
            SkyboxFt = "rbxassetid://15983965025",
            SkyboxLf = "rbxassetid://15983967420",
            SkyboxRt = "rbxassetid://15983966246",
            SkyboxUp = "rbxassetid://15983964246",
        },
    },
    ["Stylized"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://18351376859",
            SkyboxDn = "rbxassetid://18351374919",
            SkyboxFt = "rbxassetid://18351376800",
            SkyboxLf = "rbxassetid://18351376469",
            SkyboxRt = "rbxassetid://18351376457",
            SkyboxUp = "rbxassetid://18351377189",
        },
    },
    ["Minecraft"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://8735166756",
            SkyboxDn = "rbxassetid://8735166707",
            SkyboxFt = "rbxassetid://8735231668",
            SkyboxLf = "rbxassetid://8735166755",
            SkyboxRt = "rbxassetid://8735166751",
            SkyboxUp = "rbxassetid://8735166729",
        },
    },
    ["Cloudy Rain"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://4498828382",
            SkyboxDn = "rbxassetid://4498828812",
            SkyboxFt = "rbxassetid://4498829917",
            SkyboxLf = "rbxassetid://4498830911",
            SkyboxRt = "rbxassetid://4498830417",
            SkyboxUp = "rbxassetid://4498831746",
        },
    },
    ["Black Cloudy Rain"] = {
        ResetHaze = true,
        RbxAssetIds = {
            SkyboxBk = "rbxassetid://149679669",
            SkyboxDn = "rbxassetid://149681979",
            SkyboxFt = "rbxassetid://149679690",
            SkyboxLf = "rbxassetid://149679709",
            SkyboxRt = "rbxassetid://149679722",
            SkyboxUp = "rbxassetid://149680199",
        },
    },
}

function ApplyBuiltInSkybox(Data)
    for _, V in pairs(Lighting:GetChildren()) do
        if V:IsA("Sky") then V:Destroy() end
    end
    local NativeSky = Instance.new("Sky")
    NativeSky.SkyboxBk = "rbxasset://textures/sky/sky512_bk.tex"
    NativeSky.SkyboxDn = "rbxasset://textures/sky/sky512_dn.tex"
    NativeSky.SkyboxFt = "rbxasset://textures/sky/sky512_ft.tex"
    NativeSky.SkyboxLf = "rbxasset://textures/sky/sky512_lf.tex"
    NativeSky.SkyboxRt = "rbxasset://textures/sky/sky512_rt.tex"
    NativeSky.SkyboxUp = "rbxasset://textures/sky/sky512_up.tex"
    NativeSky.Parent = Lighting
    NativeSky:Destroy()
    for _, V in pairs(Lighting:GetChildren()) do
        if V:IsA("Atmosphere") then V.Haze = 0 end
    end
    local SkyInstance = Instance.new("Sky")
    SkyInstance.Name = "Sky"
    SkyInstance.CelestialBodiesShown = false
    SkyInstance.StarCount = Data.StarCount or 0
    if Data.SunAngularSize then SkyInstance.SunAngularSize = Data.SunAngularSize end
    if Data.MoonAngularSize then SkyInstance.MoonAngularSize = Data.MoonAngularSize end
    if Data.RbxAssetIds then
        for Prop, Id in pairs(Data.RbxAssetIds) do
            SkyInstance[Prop] = Id
        end
    elseif Data.Faces then
        pcall(function() makefolder("GoonWares/Skyboxes") end)
        pcall(function() makefolder(Data.Folder) end)
        for _, Face in ipairs(Data.Faces) do
            local Path = Data.Folder .. "/" .. Face.File
            if not isfile(Path) then
                writefile(Path, game:HttpGet(Face.Url, true))
            end
            SkyInstance[Face.Prop] = getcustomasset(Path)
        end
    end
    SkyInstance.Parent = Lighting
end

BuiltInSkyboxNames = {}
for SkyboxName in pairs(BuiltInSkyboxes) do
    table.insert(BuiltInSkyboxNames, SkyboxName)
end
table.sort(BuiltInSkyboxNames)
SelectedBuiltInSkybox = BuiltInSkyboxNames[1]

SecSkyboxChanger = Tabs.Visual:AddSection("Skybox Changer", "solar/sun-bold")
SecSkyboxChanger:AddSpace({ Height = 15 })

SecSkyboxChanger:AddDropdown("BuiltInSkyboxDropdown", {
    ThemedDropdown = true,
    DropdownOutsideWindow = true,
    DropdownBackgroundImages = "rbxassetid://126107479485287",
    Search = true,
    UseArcylic = true,
    Title = "Built-in Skybox",
    Values = BuiltInSkyboxNames,
    Default = SelectedBuiltInSkybox,
    Callback = function(Value) SelectedBuiltInSkybox = Value end
})

SecSkyboxChanger:AddButton({
    Title = "Apply Skybox",
    Callback = function()
        local Data = BuiltInSkyboxes[SelectedBuiltInSkybox]
        if Data then
            local Ok = pcall(ApplyBuiltInSkybox, Data)
            if Ok then
                Notify("Skybox", SelectedBuiltInSkybox .. " applied.", "Success", nil, 3)
            else
                Notify("Skybox", "Failed to apply skybox.", "Error", nil, 3)
            end
        end
    end
})

SkyboxForceEnabled = false
SkyboxForceConnection = nil
SkyboxApplyingNow = false

function ApplySelectedSkyboxSafely()
    local Data = BuiltInSkyboxes[SelectedBuiltInSkybox]
    if not Data then return end
    SkyboxApplyingNow = true
    pcall(ApplyBuiltInSkybox, Data)
    task.wait(0.2)
    SkyboxApplyingNow = false
end

SecSkyboxChanger:AddToggle("SkyboxForceToggle", {
    Title = "Lock Skybox",
    Default = false,
    Callback = function(State)
        SkyboxForceEnabled = State
        if SkyboxForceConnection then
            SkyboxForceConnection:Disconnect()
            SkyboxForceConnection = nil
        end
        if State then
            ApplySelectedSkyboxSafely()
            SkyboxForceConnection = Lighting.ChildAdded:Connect(function(Child)
                if not SkyboxForceEnabled then return end
                if SkyboxApplyingNow then return end
                if Child:IsA("Sky") then
                    task.wait(0.1)
                    ApplySelectedSkyboxSafely()
                end
            end)
        end
    end
})

SecSkyboxChanger:AddParagraph({
    Title = "Built-in Skybox Info",
    Content = "Apply custom skyboxes. Some may take a moment to load. Use Lock/force mode to keep it Forever."
})

SecSkyboxChanger:AddSpace({ Height = 15 })

SecCustomSkybox = Tabs.Visual:AddSection("Custom Skybox", "solar/gallery-bold")
SecCustomSkybox:AddSpace({ Height = 15 })

CustomSkyboxInputs = { Lf = "", Rt = "", Up = "", Dn = "", Ft = "", Bk = "" }

function ResolveSkyboxInput(Value, FaceName)
    Value = tostring(Value or ""):gsub("^%s*(.-)%s*$", "%1")
    if Value == "" then return nil end
    if Value:match("^rbxassetid://") then return Value
    elseif Value:match("^%d+$") then return "rbxassetid://" .. Value
    elseif Value:match("^https?://") then
        pcall(function() makefolder("GoonWares/Skyboxes/Custom") end)
        local Path = "GoonWares/Skyboxes/Custom/" .. FaceName .. ".png"
        local Ok = pcall(function() writefile(Path, game:HttpGet(Value, true)) end)
        if Ok then return getcustomasset(Path) end
    end
    return nil
end

function ApplyCustomSkybox()
    local PropMap = { Lf = "SkyboxLf", Rt = "SkyboxRt", Up = "SkyboxUp", Dn = "SkyboxDn", Ft = "SkyboxFt", Bk = "SkyboxBk" }
    for _, V in pairs(Lighting:GetChildren()) do
        if V:IsA("Sky") then V:Destroy() end
    end
    local SkyInstance = Instance.new("Sky")
    SkyInstance.Name = "Sky"
    SkyInstance.CelestialBodiesShown = false
    SkyInstance.StarCount = 0
    local AppliedAny = false
    for Face, Prop in pairs(PropMap) do
        local Resolved = ResolveSkyboxInput(CustomSkyboxInputs[Face], Face)
        if Resolved then
            SkyInstance[Prop] = Resolved
            AppliedAny = true
        end
    end
    if AppliedAny then
        SkyInstance.Parent = Lighting
        Notify("Skybox", "Custom skybox applied.", "Success", nil, 3)
    else
        SkyInstance:Destroy()
        Notify("Skybox", "No valid inputs provided.", "Error", nil, 3)
    end
end

SecCustomSkybox:AddInput("CustomSkyboxLf", { Title = "Left (Lf)", Placeholder = "rbxassetid or URL", Callback = function(V) CustomSkyboxInputs.Lf = V end })
SecCustomSkybox:AddInput("CustomSkyboxRt", { Title = "Right (Rt)", Placeholder = "rbxassetid or URL", Callback = function(V) CustomSkyboxInputs.Rt = V end })
SecCustomSkybox:AddInput("CustomSkyboxUp", { Title = "Up", Placeholder = "rbxassetid or URL", Callback = function(V) CustomSkyboxInputs.Up = V end })
SecCustomSkybox:AddInput("CustomSkyboxDn", { Title = "Down (Dn)", Placeholder = "rbxassetid or URL", Callback = function(V) CustomSkyboxInputs.Dn = V end })
SecCustomSkybox:AddInput("CustomSkyboxFt", { Title = "Front (Ft)", Placeholder = "rbxassetid or URL", Callback = function(V) CustomSkyboxInputs.Ft = V end })
SecCustomSkybox:AddInput("CustomSkyboxBk", { Title = "Back (Bk)", Placeholder = "rbxassetid or URL", Callback = function(V) CustomSkyboxInputs.Bk = V end })

SecCustomSkybox:AddButton({
    Title = "Apply Custom Skybox",
    Callback = ApplyCustomSkybox
})

SecCustomSkybox:AddParagraph({
    Title = "Custom Skybox Info",
    Content = "Upload 6 cube skybox faces to Roblox or use direct download links, then enter the URL or rbxassetid into the 6 inputs in the correct cube directions."
})

SecCustomSkybox:AddSpace({ Height = 15 })

local secImportantNote = Tabs.Info:AddSection("Important Note", "solar/danger-triangle-bold")
secImportantNote:AddSpace({ Height = 10 })
secImportantNote:AddParagraph({
    Title = "Variable Name from Loadstring",
    Content = "All documentation in the Info tab uses <b>Fluent</b> as the variable name.\nHowever, the actual variable name depends on how you define the result of loadstring.\n\nExample:\n<b>local Fluent = loadstring(...)()</b> → use <b>Fluent</b>\n<b>local Fggesfc = loadstring(...)()</b> → use <b>Fggesfc</b>\n<b>local UI = loadstring(...)()</b> → use <b>UI</b>\n\nSo <b>Fluent:CreateWindow()</b>, <b>Fluent:SetTheme()</b>, <b>Fluent.Options</b>, and all other methods must be replaced with the variable name you used for the loadstring result.\n\n<font color=\"rgb(255,100,100)\">The loadstring variable name = the name you use throughout the ENTIRE script.</font>",
})
secImportantNote:AddSpace({ Height = 15 })

local secSpecialComponents = Tabs.Info:AddSection("Special Properties & Method list | Components", "solar/cpu-bolt-bold")
secSpecialComponents:AddSpace({ Height = 10 })

secSpecialComponents:AddParagraph({
    Title = "Window — Special Properties & Methods",
    Content = "• <b>Title</b> <font color=\"rgb(255,100,100)\">[required]</font> — The main window title displayed in the title bar.\n• <b>SubTitle</b> — A subtitle shown below the main title.\n• <b>Size</b> — UDim2 size of the window (e.g. UDim2.fromOffset(680, 680)).\n• <b>TabWidth</b> — Width of the tab sidebar in pixels.\n• <b>Acrylic</b> — Enable acrylic blur background effect.\n• <b>Background</b> — Enable background image rendering.\n• <b>Theme</b> — Name of the active theme to apply on creation.\n• <b>Font</b> — Font family name used across the UI.\n• <b>MinimizeKey</b> — String key name to toggle minimize (e.g. \"LeftControl\").\n• <b>TitleIcon</b> — rbxassetid or URL for the icon shown in the title bar.\n• <b>FolderName</b> — Folder name used for saving configs and assets.\n• <b>ScreenGuiName</b> — Name given to the ScreenGui instance.\n• <b>Tags</b> — Array of { Text, Color } tag badges shown in the title bar.\n• <b>Search</b> — Table: { Search, Highlight, HighlightColor }.\n• <b>UserInfo</b> — Table: { UserInfo, UserInfoTitle, UserInfoSubtitle, UserInfoColor }.\n• <b>Anonymous</b> — Table: { Default, ShowAno, AnoUserInfoTitle, AnoUserInfoSubTitle, Icons }.\n• <b>:AddTab(options)</b> — Add a new full tab to the sidebar.\n• <b>:AddTabsInHeader(options)</b> — Add a compact tab inside the header bar.\n• <b>:Minimize()</b> — Toggle the minimize state of the window.\n• <b>:SelectTab(index)</b> — Switch to a tab by its 1-based index.\n• <b>:Dialog(options)</b> — Open a modal dialog with Title, Content, and Buttons.",
})

secSpecialComponents:AddSpace({ Height = 8 })

secSpecialComponents:AddParagraph({
    Title = "Tab — Special Properties & Methods",
    Content = "• <b>Title</b> <font color=\"rgb(255,100,100)\">[required]</font> — Label shown in the sidebar or header.\n• <b>Icon</b> — Solar/Lucide icon name displayed next to the title.\n• <b>EmptyState</b> — Table: { Text, SubText, Icon } shown when the tab has no elements.\n• <b>:AddSection(title, icon)</b> — Add a named section inside this tab.\n• <b>:AddCollapsibleSection(title, icon, openState)</b> — Add a collapsible section.\n• <b>:AddGroup(options)</b> — Add a multi-column group layout directly in the tab.\n• <b>:HGroup({ Gap })</b> — Add a horizontal row container. Call :VGroup() on it to make columns.\n• <b>:VGroup({ Gap })</b> — Add a vertical stack container directly in the tab.\n• <b>:SetEmptyState({ Text, SubText, Icon })</b> — Override the empty state text and icon at runtime.\n\n<b>Tab Spacing & Dividers (sidebar):</b>\n• <b>Window:AddSpaceTabs({ Height = n })</b> — Empty vertical gap between sidebar tabs.\n• <b>Window:AddDividerTabs()</b> — Thin horizontal rule between sidebar tabs.\n\n<b>Tab Spacing & Dividers (header):</b>\n• <b>Window:AddSpaceTabsHead({ Height = n })</b> — Horizontal gap between header tabs.\n• <b>Window:AddDividerTabsHead()</b> — Thin vertical divider between header tabs.\n\n<b>Minimizer:</b> Created via <b>Fluent:CreateMinimizer(cfg)</b>.\n• <b>Icon</b> — rbxassetid:// texture, never tinted by theme.\n• <b>Size</b> / <b>Position</b> / <b>Corner</b> / <b>Transparency</b> — Visual properties.\n• <b>Lockable</b> — Hold to lock in place (prevents drag, not click).\n• <b>Draggable</b> — Whether button can be dragged.\n• <b>LockHoldTime</b> — Seconds to hold before locking.\n• <b>OnClickSound</b> — String or array of rbxassetid strings, one picked at random.\n• <b>Minimizer.Visible = bool</b> — Show or hide the minimizer.",
})

secSpecialComponents:AddSpace({ Height = 8 })

secSpecialComponents:AddParagraph({
    Title = "HGroup & VGroup — Special Properties & Methods",
    Content = "Layout containers that let you arrange elements horizontally or vertically — similar to HStack/VStack.\n\n<b>HGroup</b> — Horizontal row. Children (VGroups) are placed left to right.\n<b>VGroup</b> — Vertical column. All standard element methods work inside it.\n\n• <b>Gap</b> — Pixel spacing between children (default: 6).\n• All VGroups inside an HGroup split width <b>equally</b> and recalculate automatically as more VGroups are added.\n\nUsage:\nlocal row = Tab:HGroup({ Gap = 8 })\nlocal left  = row:VGroup({ Gap = 6 })\nlocal right = row:VGroup({ Gap = 6 })\nleft:Button({ Title = \"A\", Callback = function() end })\nright:Toggle(\"T\", { Title = \"B\", Default = false, Callback = function(v) end })\n\nShorthand (no Add prefix):\nTab:HGroup() / Tab:VGroup()\nrow:VGroup()",
})

secSpecialComponents:AddSpace({ Height = 8 })

secSpecialComponents:AddParagraph({
    Title = "TabsInHeader — Special Properties & Methods",
    Content = "Created via <b>Window:AddTabsInHeader(options)</b> instead of AddTab.\nRenders as a compact tab button inside the top header bar rather than the sidebar.\nAll section and element methods are identical to a regular Tab.\n\n• <b>Title</b> <font color=\"rgb(255,100,100)\">[required]</font> — Label shown inside the header button.\n• <b>Icon</b> — Solar/Lucide icon displayed next to the title in the header.\n• <b>:AddSection(title, icon)</b> — Add a named section inside this header tab.\n• <b>:AddCollapsibleSection(title, icon, openState)</b> — Add a collapsible section.\n• <b>:AddGroup(options)</b> — Add a multi-column group layout.\n\nKey difference from <b>AddTab</b>: does not appear in the sidebar. Best used for utility tabs (Settings, Info, Config) to keep the sidebar clean.",
})

secSpecialComponents:AddSpace({ Height = 8 })

secSpecialComponents:AddParagraph({
    Title = "Section — Special Properties & Methods",
    Content = "• <b>Title</b> <font color=\"rgb(255,100,100)\">[required]</font> — Header label of the section.\n• <b>Icon</b> — Optional Solar/Lucide icon shown next to the section title.\n• <b>:AddToggle(flag, options)</b> — Add a toggle switch element.\n• <b>:AddSlider(flag, options)</b> — Add a slider element.\n• <b>:AddButton(options)</b> — Add a clickable button element.\n• <b>:AddDropdown(flag, options)</b> — Add a dropdown selection element.\n• <b>:AddInput(flag, options)</b> — Add a text input element.\n• <b>:AddKeybind(flag, options)</b> — Add a keybind binding element.\n• <b>:AddColorpicker(flag, options)</b> — Add a color picker element.\n• <b>:AddCheckbox(flag, options)</b> — Add a checkbox element.\n• <b>:AddProgressBar(flag, options)</b> — Add a progress bar element.\n• <b>:AddParagraph(options)</b> — Add a rich-text paragraph block.\n• <b>:AddCode(options)</b> — Add a copyable code block.\n• <b>:AddImage(options)</b> — Add an image element.\n• <b>:AddVideo(options)</b> — Add a video player element.\n• <b>:AddAudio(options)</b> — Add an audio player element.\n• <b>:AddViewport(flag, options)</b> — Add a 3D viewport element.\n• <b>:AddDiscord(options)</b> — Add a Discord invite button.\n• <b>:AddSocial(options)</b> — Add a social media profile card.\n• <b>:AddGroup(options)</b> — Add a multi-column group layout.\n• <b>:HGroup({ Gap })</b> — Add a horizontal row container (HGroup).\n• <b>:VGroup({ Gap })</b> — Add a vertical stack container (VGroup).\n• <b>:AddDivider()</b> — Add a horizontal divider line.\n• <b>:AddSpace(options)</b> — Add vertical spacing (Height in pixels).\n\nAll methods above also work without the <b>Add</b> prefix: sec:Button(), sec:Toggle(), sec:HGroup(), etc.",
})

secSpecialComponents:AddSpace({ Height = 8 })

secSpecialComponents:AddParagraph({
    Title = "CollapsibleSection — Special Properties & Methods",
    Content = "• <b>title</b> <font color=\"rgb(255,100,100)\">[required]</font> — Header label of the collapsible section.\n• <b>icon</b> — Optional Solar/Lucide icon name.\n• <b>openState</b> — Whether the section is expanded by default (true / false).\nUsage: local col = sec:AddCollapsibleSection(\"Title\", \"solar/icon-name\", false)\nAll standard section methods (:AddToggle, :AddSlider, etc.) are available on the returned object.",
})

secSpecialComponents:AddSpace({ Height = 8 })

secSpecialComponents:AddParagraph({
    Title = "Group — Special Properties & Methods",
    Content = "• <b>Columns</b> — Number of horizontal columns (default: 2).\n• <b>Gap</b> — Gap between columns in pixels (default: 6).\n• <b>:AddElement()</b> — Adds a new column slot, returns a section-like object.\nUsage:\nlocal grp = sec:AddGroup({ Columns = 3, Gap = 8 })\nlocal col = grp:AddElement()\ncol:AddButton({ Title = \"...\", Callback = function() end })",
})

secSpecialComponents:AddSpace({ Height = 8 })

secSpecialComponents:AddParagraph({
    Title = "Notification — Special Properties",
    Content = "• <b>Title</b> <font color=\"rgb(255,100,100)\">[required]</font> — Bold header text of the notification.\n• <b>Content</b> — Main body text shown below the title.\n• <b>SubContent</b> — Small secondary text shown below content.\n• <b>Image</b> — Solar icon name or rbxassetid for the notification icon.\n• <b>Duration</b> — How long the notification stays visible in seconds.\nUsage via helper: Notify(Title, Content, Status, Icon, Duration)\nStatus options: \"Success\", \"Error\", \"Warning\", \"Info\"",
})

secSpecialComponents:AddSpace({ Height = 8 })

secSpecialComponents:AddParagraph({
    Title = "Dialog — Special Properties",
    Content = "• <b>Title</b> <font color=\"rgb(255,100,100)\">[required]</font> — Header text of the dialog modal.\n• <b>Content</b> — Body text describing the dialog action.\n• <b>Buttons</b> — Array of { Title, Callback } button definitions.\nUsage: Window:Dialog({ Title = \"...\", Content = \"...\", Buttons = { { Title = \"Yes\", Callback = function() end }, { Title = \"No\" } } })",
})

secSpecialComponents:AddSpace({ Height = 15 })

local secSpecialElements = Tabs.Info:AddSection("Special Properties & Method list | Element", "solar/star-bold")
secSpecialElements:AddSpace({ Height = 10 })

secSpecialElements:AddParagraph({
    Title = "Button — Special Properties & Methods",
    Content = "• <b>Title</b> <font color=\"rgb(255,100,100)\">[required]</font> — Main label text of the button.\n• <b>Description</b> — Small subtext shown below the title.\n• <b>Icon</b> — Solar/Lucide icon on the right side of the button.\n• <b>Callback</b> — Function called when the button is clicked.\n• <b>:SetTitle(str)</b> — Update the button label text at runtime.\n• <b>:SetDesc(str)</b> — Update the description subtext at runtime.\n• <b>:Destroy()</b> — Remove the button element from the UI entirely.",
})

secSpecialElements:AddSpace({ Height = 6 })

secSpecialElements:AddParagraph({
    Title = "Toggle — Special Properties & Methods",
    Content = "• <b>Title</b> <font color=\"rgb(255,100,100)\">[required]</font> — Label of the toggle.\n• <b>Description</b> — Subtext shown below the title.\n• <b>Default</b> — Initial boolean state (true / false).\n• <b>Icon</b> — Optional Solar/Lucide icon on the element.\n• <b>Callback(value)</b> — Called every time the state changes.\n• <b>:SetValue(bool)</b> — Set state programmatically.\n• <b>:SetTitle(str)</b> / <b>:SetDesc(str)</b> — Update text at runtime.",
})

secSpecialElements:AddSpace({ Height = 6 })

secSpecialElements:AddParagraph({
    Title = "Slider — Special Properties & Methods",
    Content = "• <b>Title</b> <font color=\"rgb(255,100,100)\">[required]</font> — Label text of the slider.\n• <b>Min</b> / <b>Max</b> — Minimum and maximum boundary values.\n• <b>Default</b> — Initial slider value.\n• <b>Rounding</b> — Decimal places (0 = whole integer).\n• <b>LeftIcons</b> — Lucide/Solar icon at the left end of the rail.\n• <b>RightIcons</b> — Lucide/Solar icon at the right end of the rail.\n• <b>Callback(value)</b> — Called when the value changes.\n• <b>:SetValue(n)</b> — Set value programmatically.\n• <b>:SetMax(n)</b> — Update the maximum value at runtime.",
})

secSpecialElements:AddSpace({ Height = 6 })

secSpecialElements:AddParagraph({
    Title = "Dropdown — Special Properties & Methods",
    Content = "• <b>Title</b> <font color=\"rgb(255,100,100)\">[required]</font> — Label text of the dropdown.\n• <b>Values</b> — Table of available option strings.\n• <b>Default</b> — The option selected by default.\n• <b>Multi</b> — Allow multi-select (true / false).\n• <b>AllowNull</b> — Allow no option to be selected.\n• <b>Search</b> — Show a search bar inside the dropdown.\n• <b>NoSearch</b> — Force-hide the search bar.\n• <b>Animated</b> — Shine animation when the dropdown opens.\n• <b>ThemedDropdown</b> — Use the active theme color for the background.\n• <b>DropdownOutsideWindow</b> — Render outside window bounds to avoid clipping.\n• <b>UseAcrylic / UseArcylic</b> — Apply acrylic blur effect to the dropdown frame.\n• <b>DropdownBackgroundImages</b> — Custom background image for the dropdown.\n• <b>:SetValue(val)</b> — Set selected value programmatically.",
})

secSpecialElements:AddSpace({ Height = 6 })

secSpecialElements:AddParagraph({
    Title = "Input — Special Properties & Methods",
    Content = "• <b>Title</b> <font color=\"rgb(255,100,100)\">[required]</font> — Label text of the input field.\n• <b>Placeholder</b> — Hint text shown when the input is empty.\n• <b>Default</b> — Initial text value.\n• <b>Numeric</b> — Accept only numeric input.\n• <b>Finished</b> — Callback is only called on Enter or unfocus.\n• <b>MaxLength</b> — Maximum character limit.\n• <b>ClearButton</b> — Show a clear button inside the input field.\n• <b>Callback(value)</b> — Called when the value changes.\n• <b>:SetValue(str)</b> — Set input value programmatically.",
})

secSpecialElements:AddSpace({ Height = 6 })

secSpecialElements:AddParagraph({
    Title = "Keybind — Special Properties & Methods",
    Content = "• <b>Title</b> <font color=\"rgb(255,100,100)\">[required]</font> — Label text of the keybind element.\n• <b>Default</b> — String key name for the default binding (e.g. \"Space\", \"N\", \"V\").\n• <b>Mode</b> — Keybind behavior mode: Toggle / Hold / Always.\n• <b>ChangedCallback(key)</b> — Called when the user rebinds the key.\n• <b>Callback()</b> — Called when the keybind is pressed.\n• <b>:SetValue(keyName)</b> — Set keybind programmatically via string.\n• <b>:GetState()</b> — Returns the current toggled state.",
})

secSpecialElements:AddSpace({ Height = 6 })

secSpecialElements:AddParagraph({
    Title = "Colorpicker — Special Properties & Methods",
    Content = "• <b>Title</b> <font color=\"rgb(255,100,100)\">[required]</font> — Label text of the color picker.\n• <b>Default</b> <font color=\"rgb(255,100,100)\">[required]</font> — Initial Color3 value.\n• <b>Transparency</b> — Initial transparency value (0–1).\n• <b>Gradient</b> — When <b>true</b>, becomes a full ColorSequence editor (GradientPicker). Callback receives a ColorSequence instead of Color3. Compatible with Beam, Trail, ParticleEmitter, UIGradient.\n• <b>Callback(color)</b> — Called when the color changes. Returns Color3 normally, ColorSequence when Gradient = true.\n• <b>:SetValue(color)</b> — Set color programmatically.\n• <b>.Hue / .Sat / .Vib</b> — Access HSV component values directly.\n\n<b>GradientPicker dialog:</b>\n• HSV canvas, Hue bar, Hex input.\n• 2 color slots — click to switch active keypoint.",
})

secSpecialElements:AddSpace({ Height = 6 })

secSpecialElements:AddParagraph({
    Title = "Paragraph — Special Properties & Methods",
    Content = "• <b>Title</b> — Header text of the paragraph.\n• <b>Content</b> — Body text of the paragraph.\n• <b>:SetDesc(str)</b> — Update the Content text at runtime.\nSupports Roblox Rich Text: <b>&lt;b&gt;</b> bold · <b>&lt;i&gt;</b> italic · <b>&lt;u&gt;</b> underline · <b>&lt;font color=\"rgb(R,G,B)\"&gt;</b> custom color.",
})

secSpecialElements:AddSpace({ Height = 6 })

secSpecialElements:AddParagraph({
    Title = "Checkbox — Special Properties & Methods",
    Content = "• <b>Title</b> <font color=\"rgb(255,100,100)\">[required]</font> — Label of the checkbox.\n• <b>Default</b> — Initial boolean state.\n• <b>Callback(value)</b> — Called when the state changes.\n• <b>:SetValue(bool)</b> — Set state programmatically.\n• <b>:SetTitle(str)</b> — Update the title text at runtime.\nDiffers from Toggle: uses a square-box visual instead of a pill slider.",
})

secSpecialElements:AddSpace({ Height = 6 })

secSpecialElements:AddParagraph({
    Title = "ProgressBar — Special Properties & Methods",
    Content = "• <b>Title</b> <font color=\"rgb(255,100,100)\">[required]</font> — Label text of the progress bar.\n• <b>Min</b> / <b>Max</b> — Value boundary of the bar (default: 0–100).\n• <b>Default</b> — Initial bar value.\n• <b>ShowPercent</b> — Show a percentage label beside the bar.\n• <b>:SetValue(n)</b> — Update the bar value at runtime.\n• <b>:SetMax(n)</b> — Update the maximum value at runtime.\n• <b>:SetTitle(str)</b> — Replace the title text at runtime.",
})

secSpecialElements:AddSpace({ Height = 6 })

secSpecialElements:AddParagraph({
    Title = "Viewport — Special Properties & Methods",
    Content = "• <b>Object</b> — Model/Instance rendered inside the viewport.\n• <b>Camera</b> — Custom Camera instance (optional, auto-created if nil).\n• <b>Height</b> — Viewport height in pixels (default: 200).\n• <b>Focused</b> — Auto-focus the camera onto the object (default: true).\n• <b>Interactive</b> — Enable drag-to-rotate and scroll-to-zoom.\n• <b>AspectRatio</b> — Display ratio string, e.g. \"16:9\".\n• <b>:SetValue(dist)</b> — Set camera distance at runtime.\n• <b>:Focus()</b> — Refocus the camera onto the object.",
})

secSpecialElements:AddSpace({ Height = 6 })

secSpecialElements:AddParagraph({
    Title = "Image — Special Properties & Methods",
    Content = "• <b>Image</b> — URL, rbxassetid, or asset ID of the image.\n• <b>AspectRatio</b> — Display ratio of the image (default: \"16:9\").\n• <b>Radius</b> — Corner radius in pixels (default: 8).\n• <b>:SetImage(src)</b> — Replace the image source at runtime.\n• <b>:SetAspectRatio(r)</b> — Update the aspect ratio at runtime.",
})

secSpecialElements:AddSpace({ Height = 6 })

secSpecialElements:AddParagraph({
    Title = "Video — Special Properties",
    Content = "• <b>Video</b> — rbxassetid of the video to play.\n• <b>AspectRatio</b> — Display ratio of the video (default: \"16:9\").\n• <b>Radius</b> — Corner radius of the video frame.\n• <b>Looped</b> — Automatically loop the video.\n• <b>AutoPlay</b> — Start playing immediately on creation.\n• <b>Volume</b> — Initial volume (0–1).",
})

secSpecialElements:AddSpace({ Height = 6 })

secSpecialElements:AddParagraph({
    Title = "Audio — Special Properties & Methods",
    Content = "• <b>Audio / Sound</b> — rbxassetid of the audio to play.\n• <b>Title / AudioTitle</b> — Song title displayed on the player.\n• <b>SubTitle / AudioSubtitle</b> — Subtitle or artist name.\n• <b>Looped</b> — Automatically loop the audio.\n• <b>AutoPlay</b> — Start playing immediately on creation.\n• <b>Volume</b> — Initial volume (0–1).\n• <b>PlayOutsideWindow</b> — Keep audio playing even when the window is hidden.\n• <b>:SetAudioTitle(title, subtitle)</b> — Update title/subtitle at runtime.\n• <b>:SetVolume(n)</b> — Set volume at runtime.",
})

secSpecialElements:AddSpace({ Height = 6 })

secSpecialElements:AddParagraph({
    Title = "Code — Special Properties & Methods",
    Content = "• <b>Code</b> — String of code or URL text to display.\n• <b>Title</b> — Small label shown above the code block (optional).\n• <b>OnCopy</b> — Callback called when the copy button is pressed.\n• <b>:SetCode(str)</b> / <b>:Set(str)</b> — Update the code content at runtime.",
})

secSpecialElements:AddSpace({ Height = 6 })

secSpecialElements:AddParagraph({
    Title = "Discord — Special Properties",
    Content = "• <b>InviteCode / Invite</b> — Discord invite code (the part after discord.gg/).\nUsage: sec:AddDiscord({ InviteCode = \"QBhcVu6c\" })",
})

secSpecialElements:AddSpace({ Height = 6 })

secSpecialElements:AddParagraph({
    Title = "Social — Special Properties",
    Content = "• <b>Platform</b> — Platform name (\"YouTube\", \"TikTok\", etc.).\n• <b>Username</b> — Account username.\n• <b>DisplayName</b> — Display name shown on the card.\n• <b>Avatar</b> — URL or asset ID for the avatar image.\n• <b>AvatarService</b> — Service used to auto-fetch the avatar (optional).\n• <b>Url / ProfileUrl</b> — Full profile URL.",
})

secSpecialElements:AddSpace({ Height = 15 })

SecUiLibrary = Tabs.Info:AddSection("UI Library", "solar/widget-bold")
SecUiLibrary:AddSpace({ Height = 15 })
SecUiLibrary:AddParagraph({ Title = "Fluent Modded", Content = "The UI Library used in this script." })
SecUiLibrary:AddCode({
    Title = "",
    Code = "https://github.com/StyearX/Fluent-modded",
    OnCopy = function() Notify("Link", "Copied", "Info", nil, 2) end,
})
SecUiLibrary:AddSpace({ Height = 15 })

local secOtherFeatures = Tabs.Info:AddSection("Other Features — Custom Theme & Theme Properties", "solar/pallete-2-bold")
secOtherFeatures:AddSpace({ Height = 10 })

secOtherFeatures:AddParagraph({
    Title = "AddTheme — New Simplified Method",
    Content = "A cleaner alternative to <b>RegisterCustomTheme</b> that accepts a single table with the theme name included.\n\n<b>Fluent:AddTheme(themeTable)</b>\n• Must be called <b>before</b> <b>CreateWindow()</b>.\n• <b>Name</b> <font color=\"rgb(255,100,100)\">[required]</font> — Unique string name of the theme (inside the table).\n• All color values support <b>hex strings</b> directly — no need to wrap in Color3.fromRGB.\n• Non-color properties (ColorSequence, numbers, booleans) still use their native types.\n• Missing properties are automatically inherited from the built-in <b>Dark</b> theme.\n\nExample:\nFluent:AddTheme({\n    Name   = \"Midnight\",\n    Accent = \"#6366f1\",\n    Text   = \"#FFFFFF\",\n    AcrylicMain = Color3.fromHex(\"#18181b\"),\n})\nFluent:SetTheme(\"Midnight\")",
})

secOtherFeatures:AddSpace({ Height = 8 })

secOtherFeatures:AddParagraph({
    Title = "RegisterCustomTheme — Legacy Method",
    Content = "Still fully supported. Registers a custom theme using two separate arguments.\n\n<b>Fluent:RegisterCustomTheme(name, themeTable)</b>\n• <b>name</b> <font color=\"rgb(255,100,100)\">[required]</font> — Unique string name of the theme.\n• <b>themeTable</b> <font color=\"rgb(255,100,100)\">[required]</font> — Table of theme properties.\nAlias: <b>Fluent:AddCustomTheme(name, themeTable)</b>\n\nExample:\nFluent:RegisterCustomTheme(\"My Theme\", {\n    Accent = Color3.fromRGB(100, 200, 255),\n    AcrylicMain = Color3.fromRGB(15, 15, 20),\n    ...\n})\nFluent:SetTheme(\"My Theme\")",
})

secOtherFeatures:AddSpace({ Height = 8 })

secOtherFeatures:AddParagraph({
    Title = "Theme Property List — Colors",
    Content = "• <b>Accent</b> — Primary accent color used for highlights and active states.\n• <b>AcrylicMain</b> — Background color of the main window frame.\n• <b>AcrylicBorder</b> — Color of the outer window border/stroke.\n• <b>AcrylicGradient</b> — ColorSequence applied as a gradient overlay on the window.\n• <b>TitleBarLine</b> — Color of the divider line below the title bar.\n• <b>Tab</b> — Background color of the tab sidebar.\n• <b>Element</b> — Background color of individual elements.\n• <b>ElementBorder</b> — Outer border color of elements.\n• <b>InElementBorder</b> — Inner/subtle border color inside elements.\n• <b>ToggleSlider</b> — Background color of the toggle track (off state).\n• <b>ToggleToggled</b> — Color of the toggle knob when enabled.\n• <b>SliderRail</b> — Background rail color of sliders.\n• <b>CheckboxUnchecked</b> — Background color of unchecked checkboxes.\n• <b>CheckboxChecked</b> — Background color of checked checkboxes.\n• <b>CheckboxCheck</b> — Color of the checkmark icon inside the checkbox.\n• <b>ProgressBarRail</b> — Background rail of progress bars.\n• <b>ProgressBarFill</b> — Fill color of the progress bar.\n• <b>DropdownFrame</b> — Background of the dropdown container.\n• <b>DropdownHolder</b> — Background of the dropdown list holder.\n• <b>DropdownBorder</b> — Border color of dropdown frames.\n• <b>DropdownOption</b> — Background color of individual dropdown options.\n• <b>Keybind</b> — Background color of the keybind display box.\n• <b>Input</b> — Background color of input fields (unfocused).\n• <b>InputFocused</b> — Background color of input fields when focused.\n• <b>InputIndicator</b> — Color of the input underline indicator (unfocused).\n• <b>InputIndicatorFocus</b> — Color of the input underline indicator (focused).\n• <b>Dialog</b> — Background color of dialog modals.\n• <b>DialogHolder</b> — Background of the dialog inner holder.\n• <b>DialogHolderLine</b> — Divider line color inside the dialog.\n• <b>DialogButton</b> — Background color of dialog action buttons.\n• <b>DialogButtonBorder</b> — Border color of dialog action buttons.\n• <b>DialogBorder</b> — Outer border color of the dialog modal.\n• <b>DialogInput</b> — Background of input fields inside dialogs.\n• <b>DialogInputLine</b> — Underline indicator color inside dialog inputs.\n• <b>Text</b> — Primary text color across all elements.\n• <b>SubText</b> — Secondary/description text color.\n• <b>IconColor</b> — Tint color applied to icon images.\n• <b>Hover</b> — Background color shown on element hover.\n• <b>StrokeDark</b> — Darker stroke color used in shine gradient endpoints.\n• <b>DiscordJoinButton</b> — Background color of Discord invite buttons.\n• <b>WarningNotifyColor</b> — Stripe color for Warning notifications.\n• <b>SuccessNotifyColor</b> — Stripe color for Success notifications.\n• <b>ErrorNotifyColor</b> — Stripe color for Error notifications.\n• <b>InfoNotifyColor</b> — Stripe color for Info notifications.\n• <b>ViewportBackground</b> — Background color of Viewport elements.",
})

secOtherFeatures:AddSpace({ Height = 8 })

secOtherFeatures:AddParagraph({
    Title = "Theme Property List — Numbers & Booleans",
    Content = "• <b>AcrylicNoise</b> — Noise texture transparency on the acrylic overlay (0–1).\n• <b>ElementTransparency</b> — Background transparency of elements (0 = solid, 1 = invisible).\n• <b>ElementBorderThickness</b> — Pixel thickness of element borders (default: 1).\n• <b>DropdownBorderThickness</b> — Pixel thickness of dropdown borders (default: 1).\n• <b>HoverChange</b> — Delta applied to ElementTransparency on hover (e.g. 0.05).\n• <b>BackgroundTransparency</b> — Transparency of the background image (0 = opaque, 1 = hidden).\n• <b>ShineEnabled</b> — Whether the gradient shine animation plays on the window.\n• <b>StrokeShine</b> — Whether UIStroke elements pulse during the shine animation.",
})

secOtherFeatures:AddSpace({ Height = 8 })

secOtherFeatures:AddParagraph({
    Title = "Theme Property List — Special Types",
    Content = "• <b>Background</b> — rbxassetid string for the window background image. Set to <b>nil</b> for no background.\n• <b>ThemeAccentColors</b> — Array of Color3 values shown as swatches in the theme accent picker.\n• <b>Shine</b> — Table: { Speed, RotationSpeed, ColorSequence } — controls the window shine animation.\n  - <b>Speed</b>: Animation cycle speed multiplier.\n  - <b>RotationSpeed</b>: Degrees per second the gradient rotates.\n  - <b>ColorSequence</b>: ColorSequence defining the gradient color sweep.\n• <b>ButtonGradient</b> — Table: { Background, Stroke } — both ColorSequence values applied to button visuals.\n  - <b>Background</b>: ColorSequence for the button fill gradient.\n  - <b>Stroke</b>: ColorSequence for the button border gradient.",
})

secOtherFeatures:AddSpace({ Height = 8 })

secOtherFeatures:AddParagraph({
    Title = "Theme Color Input — Hex, RGB & HSV Support",
    Content = "FluentPro accepts three formats for every color field in a theme table:\n\n<b>Hex strings</b> — any property value starting with <b>#</b> is auto-converted:\n    Accent = \"#6366f1\"\n    Text   = \"#ffffff\"\n\n<b>RGB / Color3 natives</b> — standard Roblox types work as-is:\n    Accent = Color3.fromRGB(99, 102, 241)\n    Accent = Color3.fromHex(\"#6366f1\")\n    Accent = Color3.new(0.388, 0.4, 0.945)\n\n<b>HSV</b> — use Color3.fromHSV() to build colors from hue/saturation/brightness:\n    Accent = Color3.fromHSV(0.667, 0.6, 0.95)  -- same violet\n\nAll three formats can be freely mixed within the same theme table. Missing properties fall back to the built-in <b>Dark</b> theme.\n\nColorpicker element: access the live HSV components via:\n    picker.Hue  -- current hue (0–1)\n    picker.Sat  -- current saturation (0–1)\n    picker.Vib  -- current brightness/value (0–1)",
})

secOtherFeatures:AddSpace({ Height = 15 })

local secSecretMethods = Tabs.Info:AddSection("Secret Methods & Advanced API", "solar/ghost-bold")
secSecretMethods:AddSpace({ Height = 10 })

secSecretMethods:AddParagraph({
    Title = "Fetch Theme Color / Property",
    Content = "The library exposes the full theme table via a global: <b>Fluent_Themes</b>.\nCombine it with <b>Fluent.Theme</b> (current theme name) to read any property of the active theme at runtime.\n\nUsage:\nlocal thm = Fluent_Themes[Fluent.Theme]\nprint(thm.Accent)       -- Color3\nprint(thm.AcrylicMain)  -- Color3\nprint(thm.Text)         -- Color3\nprint(thm.ElementTransparency) -- number\nprint(thm.ShineEnabled) -- boolean\n\nYou can also read any other theme by name:\nlocal darkThm = Fluent_Themes[\"Dark\"]\nprint(darkThm.Accent)\n\nThis works for every theme property listed in the Other Features section.",
})

secSecretMethods:AddSpace({ Height = 6 })

secSecretMethods:AddParagraph({
    Title = "Fluent.NotifyInsideWindow",
    Content = "Boolean flag — when set to <b>true</b>, notifications are anchored inside the window frame instead of floating on screen.\n\nUsage:\n<b>Fluent.NotifyInsideWindow = true</b>",
})

secSecretMethods:AddSpace({ Height = 6 })

secSecretMethods:AddParagraph({
    Title = "Fluent.Options",
    Content = "A flat lookup table that maps every element's flag string to its live element object.\nAllows direct access to any element without holding a reference variable.\n\nUsage:\n<b>Fluent.Options[\"MyToggleFlag\"]:SetValue(true)</b>\n<b>Fluent.Options[\"MySliderFlag\"].Value</b>",
})

secSecretMethods:AddSpace({ Height = 6 })

secSecretMethods:AddParagraph({
    Title = "Fluent:GetButtonGradient()",
    Content = "Returns the current active <b>ButtonGradient</b> table for the active theme.\nContains two ColorSequence fields: <b>Background</b> and <b>Stroke</b>.\n\nUsage:\nlocal grad = Fluent:GetButtonGradient()\nprint(grad.Background) -- ColorSequence\nprint(grad.Stroke)     -- ColorSequence",
})

secSecretMethods:AddSpace({ Height = 6 })

secSecretMethods:AddParagraph({
    Title = "Fluent:GetShine()",
    Content = "Returns a table of shine-related values from the currently active theme.\n\nReturned fields:\n• <b>Enabled</b> — boolean, whether shine is active.\n• <b>Shine</b> — the raw Shine config table { Speed, RotationSpeed, ColorSequence }.\n• <b>StrokeShine</b> — boolean, whether stroke pulse is active.\n• <b>StrokeDark</b> — Color3, the darker end of the stroke pulse.\n• <b>Accent</b> — Color3, the theme accent color.\n\nUsage: local s = Fluent:GetShine()",
})

secSecretMethods:AddSpace({ Height = 6 })

secSecretMethods:AddParagraph({
    Title = "Fluent:NotifyError(title, message, duration)",
    Content = "Shows a copyable error notification with automatic error hint detection.\nInternally uses the built-in error pattern matcher to append a helpful tip.\n\n• <b>title</b> — Notification header string.\n• <b>message</b> — The error message string.\n• <b>duration</b> — How long to show it (default: 6s).\n\nUsage: Fluent:NotifyError(\"Oops\", tostring(err))",
})

secSecretMethods:AddSpace({ Height = 6 })

secSecretMethods:AddParagraph({
    Title = "Fluent:SafeCallback(fn, ...)",
    Content = "Wraps a function call in a protected pcall. On failure, automatically fires <b>NotifyError</b> with the error message and line info.\n\nUsage:\nFluent:SafeCallback(function()\n    -- risky code here\nend)",
})

secSecretMethods:AddSpace({ Height = 6 })

secSecretMethods:AddParagraph({
    Title = "Fluent:SetErrorHandler(fn)",
    Content = "Registers a custom callback that gets called whenever <b>NotifyError</b> or <b>SafeCallback</b> catches an error.\n\n• <b>fn(message, rawErr)</b> — receives the error string.\n\nUsage:\nFluent:SetErrorHandler(function(msg)\n    warn(\"[MyScript] \" .. msg)\nend)",
})

secSecretMethods:AddSpace({ Height = 6 })

secSecretMethods:AddParagraph({
    Title = "Fluent:GetIcon(iconStr)",
    Content = "Resolves an icon string into an image data table used by the library internally.\nSupports all icon packs: <b>lucide</b>, <b>solar</b>, <b>gravity</b>, <b>sfsymbols</b>, <b>craft</b>, <b>geist</b>, <b>hero</b>, <b>gmi</b>.\n\nReturned table: { Image, ImageRectOffset, ImageRectSize }\n\nUsage:\nlocal icon = Fluent:GetIcon(\"solar/star-bold\")\nprint(icon.Image) -- rbxassetid spritesheet",
})

secSecretMethods:AddSpace({ Height = 6 })

secSecretMethods:AddParagraph({
    Title = "Fluent:LoadCustomAsset(url)",
    Content = "Downloads a file from a URL, caches it to disk, and returns a local <b>rbxassetid</b> via getcustomasset.\nRequires executor support for writefile + getcustomasset.\n\n• <b>url</b> — Full https:// URL to the asset.\n\nUsage:\nlocal id = Fluent:LoadCustomAsset(\"https://example.com/font.ttf\")\nprint(id) -- rbxasset://... local path",
})

secSecretMethods:AddSpace({ Height = 6 })

secSecretMethods:AddParagraph({
    Title = "Fluent:LoadCustomFont(url, weight, style)",
    Content = "Downloads a font file and returns a <b>Font</b> object ready to use in TextLabel.FontFace.\nBuilt on top of LoadCustomAsset.\n\n• <b>url</b> — URL to the .ttf or .otf file.\n• <b>weight</b> — Enum.FontWeight (default: Regular).\n• <b>style</b> — Enum.FontStyle (default: Normal).\n\nUsage:\nlocal fnt = Fluent:LoadCustomFont(\"https://example.com/MyFont.ttf\")\nmyLabel.FontFace = fnt",
})

secSecretMethods:AddSpace({ Height = 6 })

secSecretMethods:AddParagraph({
    Title = "Fluent:CopyableNotify(options)",
    Content = "Identical to <b>Fluent:Notify()</b> but the notification content is copyable via a copy button.\nAccepts the same options table as Notify.\n\nUsage:\nFluent:CopyableNotify({\n    Title = \"Result\",\n    Content = someString,\n    Duration = 5\n})",
})

secSecretMethods:AddSpace({ Height = 6 })

secSecretMethods:AddParagraph({
    Title = "Fluent:ToggleAcrylic(bool) & Fluent:ToggleTransparency(bool)",
    Content = "<b>ToggleAcrylic(bool)</b> — Enables or disables the acrylic blur effect on the window at runtime. Only works if Acrylic was enabled on window creation.\n\n<b>ToggleTransparency(bool)</b> — Applies a semi-transparent tint to the window background frame (true = 35% transparent, false = opaque).\n\nUsage:\nFluent:ToggleAcrylic(false)\nFluent:ToggleTransparency(true)",
})

secSecretMethods:AddSpace({ Height = 6 })

secSecretMethods:AddParagraph({
    Title = "Fluent.ShineEnabled & Fluent.UseAcrylic",
    Content = "<b>Fluent.ShineEnabled</b> — Boolean, reflects whether the shine/gradient animation is currently active on the window.\n\n<b>Fluent.UseAcrylic</b> — Boolean, reflects whether acrylic blur was enabled when the window was created.\n\nBoth are read-only state flags set at window creation via the <b>Animated</b> and <b>Acrylic</b> config keys.",
})

secSecretMethods:AddSpace({ Height = 6 })

secSecretMethods:AddParagraph({
    Title = "Fluent.Theme & Fluent.Themes & Fluent.Version",
    Content = "<b>Fluent.Theme</b> — String name of the currently active theme. Updated automatically on <b>SetTheme()</b>.\n\n<b>Fluent.Themes</b> — Array of all registered theme name strings (built-in + custom).\n\n<b>Fluent.Version</b> — String version of the FluentPro library (e.g. \"1.5.8\").\n\nUsage:\nprint(Fluent.Theme)    -- \"AMOLED\"\nprint(Fluent.Version)  -- \"1.5.8\"\nfor _, t in ipairs(Fluent.Themes) do print(t) end",
})

secSecretMethods:AddSpace({ Height = 6 })

secSecretMethods:AddParagraph({
    Title = "Fluent:AddTheme() — Hex Color Support",
    Content = "Any Color3 theme property can be written as a plain hex string. The library converts strings starting with <b>#</b> to Color3 automatically at registration time.\n\nMix hex strings and native Color3 values freely:\nFluent:AddTheme({\n    Name        = \"Example\",\n    Accent      = \"#6366f1\",\n    Text        = Color3.fromHex(\"#ffffff\"),\n    AcrylicMain = Color3.fromRGB(18, 18, 27),\n})",
})

secSecretMethods:AddSpace({ Height = 6 })

secSecretMethods:AddParagraph({
    Title = "Tab:SetEmptyState(options)",
    Content = "Override the default empty state shown when a tab has no elements.\nThe overlay appears automatically on any tab with zero elements, and hides as soon as any element is added.\n\n• <b>Text</b> — Primary text (default: \"Nothing here sucker\").\n• <b>SubText</b> — Secondary text below.\n• <b>Icon</b> — Solar/Lucide icon name.\n\nCan also be set at tab creation via the <b>EmptyState</b> property in AddTab/AddTabsInHeader:\nWindow:AddTab({ Title = \"Empty\", EmptyState = { Text = \"Nothing\", SubText = \"...\", Icon = \"solar/sad-circle-bold-duotone\" } })\n\nOr called at runtime:\nTabs.empty:SetEmptyState({ Text = \"Nothing here sucker\", SubText = \"Ask the developer\", Icon = \"lucide/face-angry\" })",
})

secSecretMethods:AddSpace({ Height = 6 })

secSecretMethods:AddParagraph({
    Title = "element:SetTitle(str)",
    Content = "Updates the <b>title label</b> text of any element at runtime without destroying and recreating it.\nWorks on: Toggle, Slider, Button, Dropdown, Input, Keybind, Colorpicker, Checkbox, ProgressBar, and more.\n\n• <b>str</b> — New title string.\n\nUsage:\nlocal toggle = sec:AddToggle(\"Flag\", { Title = \"Old Title\", ... })\ntoggle:SetTitle(\"New Title\")",
})

secSecretMethods:AddSpace({ Height = 6 })

secSecretMethods:AddParagraph({
    Title = "element:SetDesc(str)",
    Content = "Updates the <b>description / subtext</b> of any element at runtime.\nAlso works on <b>Paragraph</b> elements to replace the Content body text.\nWorks on: Toggle, Slider, Button, Dropdown, Input, Keybind, Colorpicker, Checkbox, ProgressBar, Paragraph, and more.\n\n• <b>str</b> — New description string. Supports Roblox rich text tags.\n\nUsage:\nlocal para = sec:AddParagraph({ Title = \"T\", Content = \"old\" })\npara:SetDesc(\"Updated content at runtime\")\n\nlocal toggle = sec:AddToggle(\"Flag\", { Description = \"Old desc\", ... })\ntoggle:SetDesc(\"New desc\")",
})

secSecretMethods:AddSpace({ Height = 6 })

secSecretMethods:AddParagraph({
    Title = "element:Destroy()",
    Content = "Removes an element from the UI entirely and cleans up its internal state.\nCalling <b>:Destroy()</b> on an element is permanent — the element cannot be recovered after destruction.\n\nWorks on any element returned by AddToggle, AddSlider, AddButton, AddDropdown, AddInput, AddColorpicker, etc.\n\nUsage:\nlocal btn = sec:AddButton({ Title = \"Click Me\", Callback = function() end })\nbtn:Destroy()\n\nNote: <b>Fluent:Destroy()</b> (no element prefix) destroys the <b>entire window</b>. See below.",
})

secSecretMethods:AddSpace({ Height = 6 })

secSecretMethods:AddParagraph({
    Title = "Fluent:Destroy()",
    Content = "Fully destroys the window GUI, disconnects all connections, clears overlays and scroll GUIs, and sets <b>Fluent.Unloaded = true</b>.\nUse this for clean script unloading.\n\nUsage: Fluent:Destroy()",
})

secSecretMethods:AddSpace({ Height = 6 })

secSecretMethods:AddParagraph({
    Title = "Fluent.Round(value, decimals)",
    Content = "Utility rounding function used internally by sliders.\n\n• <b>value</b> — Number to round.\n• <b>decimals</b> — Decimal places. Pass <b>0</b> for integer floor.\n\nUsage:\nFluent.Round(nil, 3.14159, 2) -- \"3.14\"\nFluent.Round(nil, 3.7, 0)     -- 3",
})

secSecretMethods:AddSpace({ Height = 15 })

local FFlagHandler = {}

function FFlagHandler:SetFFlag(flag, value)
    if type(flag) ~= "string" or flag:gsub(" ", ""):len() == 0 then
        return false, "InvalidFlagName"
    end

    local stripped = flag
        :gsub("^DFInt", "")
        :gsub("^DFFlag", "")
        :gsub("^FFlag", "")
        :gsub("^FInt", "")
        :gsub("^DFString", "")
        :gsub("^FString", "")

    local strValue
    if type(value) == "boolean" then
        strValue = value and "True" or "False"
    else
        strValue = tostring(value)
    end

    local success = false
    local method = "Unknown"

    local ok, result = (setfflag ~= nil) and pcall(setfflag, flag, strValue) or false, false
    if ok and result ~= false then
        success = true
        method = "NativeFull"
    else
        local ok2, result2 = (setfflag ~= nil) and pcall(setfflag, stripped, strValue) or false, false
        if ok2 and result2 ~= false then
            success = true
            method = "NativeStripped"
        elseif setfastflag then
            local ok3, result3 = pcall(setfastflag, flag, strValue)
            if ok3 and result3 ~= false then
                success = true
                method = "NativeFastFlag"
            end
        end
        if not success then
            local ok4 = pcall(function()
                if settings() and settings().FFlags then
                    settings().FFlags[flag] = strValue
                end
            end)
            if ok4 then
                success = true
                method = "Settings"
            end
        end
    end

    if success then
        pcall(function()
            local raw = readfile(StoragePath)
            local fflagfile = raw and HttpService:JSONDecode(raw) or {}
            fflagfile[flag] = strValue
            writefile(StoragePath, HttpService:JSONEncode(fflagfile))
        end)
        return true, method
    end

    return false, "InjectionFailed"
end

function FFlagHandler:BulkSet(flagsTable)
    local results = { success = 0, failed = 0, failedFlags = {} }

    for flag, value in pairs(flagsTable) do
        local ok = self:SetFFlag(flag, value)
        if ok then
            results.success = results.success + 1
        else
            results.failed = results.failed + 1
            table.insert(results.failedFlags, flag)
        end
        task.wait(0.05)
    end

    return results
end

function FFlagHandler:ClearFlags()
    pcall(function()
        writefile(StoragePath, "{}")
    end)
    return true
end

local FFlagPresets = {
    LagOptimizer = {
        ["FFlagDebugDisplayFPS"] = true,
        ["FFlagDebugSkyGray"] = true,
        ["FLogNetwork"] = "7",
    },
    HighGraphics = {
        ["FIntRomarkStartWithGraphicQualityLevel"] = 21,
        ["DFFlagTextureQualityOverrideEnabled"] = true,
        ["DFIntTextureQualityOverride"] = 3,
        ["FIntDebugForceMSAASamples"] = 4,
        ["FIntRenderShadowmapBias"] = 75,
    },
    UiCleanup = {
        ["FFlagAdServiceEnabled"] = false,
        ["FFlagVoiceBetaBadge"] = false,
        ["FFlagTopBarUseNewBadge"] = false,
        ["FFlagEnableBetaBadgeLearnMore"] = false,
        ["FIntRobloxGuiBlurIntensity"] = 0,
    },
    NetworkTweak = {
        ["FFlagDebugDisableTelemetryEphemeralCounter"] = true,
        ["FFlagDebugDisableTelemetryEphemeralStat"] = true,
        ["FFlagDebugDisableTelemetryEventIngest"] = true,
        ["FFlagDebugDisableTelemetryPoint"] = true,
        ["FFlagDebugDisableTelemetryV2Counter"] = true,
        ["FFlagDebugDisableTelemetryV2Event"] = true,
        ["FFlagDebugDisableTelemetryV2Stat"] = true,
    },
}

local secFastFlags = Tabs.Extensions:AddSection("Fastflags Injector", "solar/programming-bold")

secFastFlags:AddParagraph({
    Title = "About Fastflags",
    Content = "Modify internal Roblox client settings. Some changes require a rejoin.",
})

local presetGrp = secFastFlags:AddGroup({ Columns = 2, Gap = 8 })
local presetCol1 = presetGrp:AddElement()
local presetCol2 = presetGrp:AddElement()

local ffPresetDropdown = presetCol1:AddDropdown("FF_PresetSelect", {
    ThemedDropdown = true,
    Search = false,
    Description = " ",
    Title = "",
    Icon = "solar/list-bold",
    Values = { "LagOptimizer", "HighGraphics", "UiCleanup", "NetworkTweak" },
    Default = "LagOptimizer",
    Callback = function(v) end,
})

presetCol2:AddButton({
    Title = "Load Preset",
    Icon = "solar/download-minimalistic-bold",
    Description = " ",
    Callback = function()
        local selected = ffPresetDropdown.Value
        local flags = FFlagPresets[selected]

        if not flags then
            Notify("Fastflags", "No preset selected", "Warning")
            return
        end

        local results = FFlagHandler:BulkSet(flags)
        Notify("Fastflags", string.format("%s loaded: %d success, %d failed", selected, results.success, results.failed), "Success")
    end,
})

secFastFlags:AddDivider()

secFastFlags:AddParagraph({
    Title = "<b>Single Flag Injection</b>",
    Content = "Enter the flag name and its value, then click Inject Flag.",
})

local singleGrp = secFastFlags:AddGroup({ Columns = 2, Gap = 8 })
local singleCol1 = singleGrp:AddElement()
local singleCol2 = singleGrp:AddElement()

local ffNameInput = singleCol1:AddInput("FF_FlagName", {
    Title = " ",
    Icon = "solar/pen-bold",
    Description = " ",
    Placeholder = "fastflag (String)",
    Default = "",
    Callback = function(v) end,
})

local ffValueInput = singleCol2:AddInput("FF_FlagValue", {
    Title = "",
    Icon = "solar/pen-2-bold",
    Description = " ",
    Placeholder = "number/boolean",
    Default = "",
    Callback = function(v) end,
})

secFastFlags:AddButton({
    Title = "Inject Flag",
    Icon = "solar/syringe-bold",
    Callback = function()
        local flag = ffNameInput.Value
        local rawValue = ffValueInput.Value

        if not flag or flag == "" then
            Notify("Fastflags", "Please enter a flag name", "Warning")
            return
        end

        local parsedValue
        if rawValue:lower() == "true" then
            parsedValue = true
        elseif rawValue:lower() == "false" then
            parsedValue = false
        elseif tonumber(rawValue) then
            parsedValue = tonumber(rawValue)
        else
            parsedValue = rawValue
        end

        local ok, method = FFlagHandler:SetFFlag(flag, parsedValue)
        if ok then
            Notify("Fastflags", string.format("%s = %s (%s)", flag, tostring(parsedValue), method), "Success")
        else
            Notify("Fastflags", string.format("Failed to inject %s. Your executor may not expose setfflag.", flag), "Error")
        end
    end,
})

secFastFlags:AddDivider()

secFastFlags:AddParagraph({
    Title = "<b>Bulk Json Injection</b>",
    Content = "Paste a JSON object with multiple flags, then click Inject Json Flags.",
})

local ffJsonInput = secFastFlags:AddInput("FF_JsonFlags", {
    Title = "Json Fastflag",
    Icon = "solar/code-bold",
    Placeholder = '{ "FFlagDebugDisplayFPS": "True", "FFlagDebugSkyGray": "True" }',
    Default = "",
    Callback = function(v) end,
})

secFastFlags:AddButton({
    Title = "Inject Json Flags",
    Icon = "solar/code-2-bold",
    Callback = function()
        local json = ffJsonInput.Value

        if not json or json == "" then
            Notify("Fastflags", "Please enter JSON data", "Warning")
            return
        end

        local ok, flags = pcall(function()
            return HttpService:JSONDecode(json)
        end)

        if not ok or type(flags) ~= "table" then
            Notify("Fastflags", "Invalid JSON syntax", "Error")
            return
        end

        local results = FFlagHandler:BulkSet(flags)
        Notify("Fastflags", string.format("Json inject: %d success, %d failed", results.success, results.failed), "Success")
    end,
})

secFastFlags:AddDivider()

local maintGrp = secFastFlags:AddGroup({ Columns = 2, Gap = 8 })
local maintCol1 = maintGrp:AddElement()
local maintCol2 = maintGrp:AddElement()

maintCol1:AddButton({
    Title = "Clear Injected Flags",
    Icon = "solar/trash-bin-trash-bold",
    Description = " ",
    Callback = function()
        FFlagHandler:ClearFlags()
        Notify("Fastflags", "All saved flags cleared", "Info")
    end,
})

maintCol2:AddButton({
    Title = "Rejoin To Fully Apply Fastflags",
    Icon = "solar/restart-bold",
    Description = "Rejoins the game to fully apply all flags.",
    Callback = function()
        Window:Dialog({
            Title = "Rejoin Required",
            Content = "Some flags only take full effect after rejoining. Rejoin now?",
            Buttons = {
                {
                    Title = "Rejoin",
                    Callback = function()
                        Notify("Fastflags", "Rejoining...", "Info")
                        task.wait(0.5)
                        TeleportService:Teleport(game.PlaceId, LocalPlayer)
                    end,
                },
                { Title = "Cancel" },
            },
        })
    end,
})

local FreecamModule = loadstring(game:HttpGet("https://raw.githubusercontent.com/StyearX/GoonWares/refs/heads/main/Module/FreecamModule.lua"))()
local Freecam = FreecamModule.Init(Fluent, FloatingButtonManager)

local secFreecamLauncher = Tabs.Extensions:AddSection("Freecam", "solar/videocamera-record-bold")
secFreecamLauncher:AddParagraph({
    Title = "About Freecam",
    Content = "Detached camera you can fly around the map with. Toggle the panel below to show or hide the Freecam UI. The panel is styled to match your current FluentPro theme.",
})

secFreecamLauncher:AddToggle("FreecamGuiToggle", {
    Title = "Show Freecam Panel",
    Description = "Show or hide the Freecam control panel",
    Default = false,
    Callback = function(state)
        if Freecam.SetFreecamGuiVisible then
            Freecam.SetFreecamGuiVisible(state)
        elseif Freecam.freecamGui then
            Freecam.freecamGui.Enabled = state
        end
    end,
})


local SecPlayerStats = Tabs.Combat:AddSection("Player Stats", "solar/heart-pulse-bold")
SecPlayerStats:AddSpace({ Height = 12 })

SecPlayerStats:AddParagraph({
    Title = "Live Health Monitor [Paragraph]",
    Content = "The progress bar auto-syncs to the Humanoid HP every frame. Use the slider to set HP directly. ProgressBar supports SetValue, SetMax and SetTitle at runtime.",
})

SecPlayerStats:AddSpace({ Height = 6 })

local HealthBar = SecPlayerStats:AddProgressBar("PlayerHealthBar", {
    Title = "Health Points [ProgressBar]",
    Min = 0,
    Max = 100,
    Default = 100,
    ShowPercent = true,
})

SecPlayerStats:AddSlider("PlayerHealthSlider", {
    Title = "Set Health [Slider]",
    Description = "Drag to set the character HP value directly",
    Min = 0,
    Max = 100,
    Default = 100,
    Rounding = 0,
    LeftIcons = "minus",
    RightIcons = "plus",
    Callback = function(Value)
        pcall(function()
            local Char = LocalPlayer.Character
            if not Char then return end
            local Hum = Char:FindFirstChildOfClass("Humanoid")
            if Hum then Hum.Health = Value end
        end)
    end,
})

RunService.Heartbeat:Connect(function()
    pcall(function()
        local Char = LocalPlayer.Character
        if not Char then return end
        local Hum = Char:FindFirstChildOfClass("Humanoid")
        if not Hum then return end
        local Hp = math.max(0, math.floor(Hum.Health))
        local MaxHp = math.max(1, math.floor(Hum.MaxHealth))
        HealthBar:SetMax(MaxHp)
        HealthBar:SetValue(Hp)
        if Fluent.Options and Fluent.Options["PlayerHealthSlider"] then
            Fluent.Options["PlayerHealthSlider"]:SetMax(MaxHp)
        end
    end)
end)

SecPlayerStats:AddSpace({ Height = 8 })

local GodModeConn = nil
SecPlayerStats:AddToggle("GodModeToggle", {
    Title = "God Mode [Toggle]",
    Description = "Lock HP at maximum every frame via RunService.Heartbeat",
    Icon = "solar/shield-bold",
    Default = false,
    Callback = function(Value)
        if Value then
            GodModeConn = RunService.Heartbeat:Connect(function()
                pcall(function()
                    local Char = LocalPlayer.Character
                    if not Char then return end
                    local Hum = Char:FindFirstChildOfClass("Humanoid")
                    if Hum then Hum.Health = Hum.MaxHealth end
                end)
            end)
            Notify("God Mode", "HP locked at maximum", "Success", "solar/shield-bold", 3)
        else
            if GodModeConn then GodModeConn:Disconnect(); GodModeConn = nil end
            Notify("God Mode", "God Mode disabled", "Info", "solar/shield-bold", 2)
        end
    end,
})

SecPlayerStats:AddButton({
    Title = "Rename HP Bar [Button]",
    Description = "Demonstrates ProgressBar:SetTitle() at runtime",
    Icon = "solar/pen-bold",
    Callback = function()
        local names = { "Health Points [ProgressBar]", "Vitality [ProgressBar]", "HP [ProgressBar]", "Life [ProgressBar]" }
        local idx = math.random(1, #names)
        HealthBar:SetTitle(names[idx])
        Notify("ProgressBar", "Title → " .. names[idx], "Info", nil, 2)
    end,
})

local StatsBtnGrp = SecPlayerStats:AddGroup({ Columns = 2, Gap = 8 })
local StatsCol1 = StatsBtnGrp:AddElement()
local StatsCol2 = StatsBtnGrp:AddElement()

StatsCol1:AddButton({
    Title = "Heal to Full [Button]",
    Icon = "solar/heart-bold",
    Description = " ",
    Callback = function()
        pcall(function()
            local Char = LocalPlayer.Character
            if not Char then return end
            local Hum = Char:FindFirstChildOfClass("Humanoid")
            if Hum then
                Hum.Health = Hum.MaxHealth
                Notify("Stats", "HP restored to maximum!", "Success", "solar/heart-bold", 2)
            end
        end)
    end,
})

StatsCol2:AddButton({
    Title = "Kill Character [Button]",
    Icon = "solar/skull-bold",
    Description = " ",
    Callback = function()
        Window:Dialog({
            Title = "Kill Character",
            Content = "Set HP to 0? The character will die.",
            Buttons = {
                {
                    Title = "Yes, Kill!",
                    Callback = function()
                        pcall(function()
                            local Char = LocalPlayer.Character
                            if not Char then return end
                            local Hum = Char:FindFirstChildOfClass("Humanoid")
                            if Hum then Hum.Health = 0 end
                        end)
                        Notify("Stats", "HP set to 0!", "Warning", nil, 2)
                    end,
                },
                { Title = "Cancel" },
            },
        })
    end,
})

SecPlayerStats:AddDivider()
SecPlayerStats:AddSpace({ Height = 12 })

local SecCombatFeatures = Tabs.Combat:AddSection("Combat Features", "solar/swords-bold")
SecCombatFeatures:AddSpace({ Height = 10 })

SecCombatFeatures:AddToggle("SpeedHackToggle", {
    Title = "Speed Hack [Toggle]",
    Description = "Enable custom WalkSpeed from the slider below",
    Icon = "solar/running-bold",
    Default = false,
    Callback = function(Value)
        pcall(function()
            local Char = LocalPlayer.Character
            if not Char then return end
            local Hum = Char:FindFirstChildOfClass("Humanoid")
            if Hum then
                Hum.WalkSpeed = Value and (Fluent.Options["WalkSpeedSlider"] and Fluent.Options["WalkSpeedSlider"].Value or 50) or 16
            end
        end)
        if not Value then
            Notify("Speed Hack", "WalkSpeed reset to 16", "Info", nil, 2)
        end
    end,
})

SecCombatFeatures:AddSlider("WalkSpeedSlider", {
    Title = "WalkSpeed [Slider]",
    Description = "Applied live when Speed Hack is enabled",
    Min = 1,
    Max = 250,
    Default = 50,
    Rounding = 0,
    LeftIcons = "walking",
    RightIcons = "zap",
    Callback = function(Value)
        pcall(function()
            if not (Fluent.Options["SpeedHackToggle"] and Fluent.Options["SpeedHackToggle"].Value) then return end
            local Char = LocalPlayer.Character
            if not Char then return end
            local Hum = Char:FindFirstChildOfClass("Humanoid")
            if Hum then Hum.WalkSpeed = Value end
        end)
    end,
})

SecCombatFeatures:AddToggle("JumpHackToggle", {
    Title = "Jump Hack [Toggle]",
    Description = "Enable custom JumpPower from the slider below",
    Icon = "solar/arrow-up-bold",
    Default = false,
    Callback = function(Value)
        pcall(function()
            local Char = LocalPlayer.Character
            if not Char then return end
            local Hum = Char:FindFirstChildOfClass("Humanoid")
            if Hum then
                Hum.JumpPower = Value and (Fluent.Options["JumpPowerSlider"] and Fluent.Options["JumpPowerSlider"].Value or 100) or 50
            end
        end)
        Notify("Jump Hack", "Jump Hack " .. (Value and "enabled" or "disabled"), Value and "Success" or "Info", nil, 2)
    end,
})

SecCombatFeatures:AddSlider("JumpPowerSlider", {
    Title = "JumpPower [Slider]",
    Description = "Applied live when Jump Hack is enabled",
    Min = 1,
    Max = 500,
    Default = 100,
    Rounding = 0,
    LeftIcons = "chevron-up",
    RightIcons = "chevrons-up",
    Callback = function(Value)
        pcall(function()
            if not (Fluent.Options["JumpHackToggle"] and Fluent.Options["JumpHackToggle"].Value) then return end
            local Char = LocalPlayer.Character
            if not Char then return end
            local Hum = Char:FindFirstChildOfClass("Humanoid")
            if Hum then Hum.JumpPower = Value end
        end)
    end,
})

SecCombatFeatures:AddToggle("InfJumpToggle", {
    Title = "Infinite Jump [Toggle]",
    Description = "Allows jumping without limit while mid-air via the keybind below",
    Icon = "solar/transfer-vertical-bold",
    Default = false,
    Callback = function(Value)
        Notify("Combat", "Infinite Jump " .. (Value and "enabled" or "disabled"), Value and "Success" or "Info", nil, 2)
    end,
})

SecCombatFeatures:AddKeybind("InfJumpKeybind", {
    Title = "Infinite Jump [Keybind]",
    Description = "Press while mid-air to launch upward (requires Infinite Jump enabled)",
    Icon = "solar/keyboard-bold",
    Default = "Space",
    ChangedCallback = function(New)
        Notify("Keybind", "Inf Jump bound to: " .. tostring(New), "Info", nil, 2)
    end,
    Callback = function()
        if not (Fluent.Options["InfJumpToggle"] and Fluent.Options["InfJumpToggle"].Value) then return end
        pcall(function()
            local Char = LocalPlayer.Character
            if not Char then return end
            local Hrp = Char:FindFirstChild("HumanoidRootPart")
            if Hrp then
                Hrp.Velocity = Vector3.new(Hrp.Velocity.X, 50, Hrp.Velocity.Z)
            end
        end)
    end,
})

SecCombatFeatures:AddDivider()
SecCombatFeatures:AddSpace({ Height = 10 })

local NoclipConn = nil
SecCombatFeatures:AddToggle("NoclipToggle", {
    Title = "Noclip [Toggle]",
    Description = "Disable collision on all character BaseParts each Stepped frame",
    Icon = "solar/ghost-bold",
    Default = false,
    Callback = function(Value)
        if Value then
            NoclipConn = RunService.Stepped:Connect(function()
                pcall(function()
                    local Char = LocalPlayer.Character
                    if not Char then return end
                    for _, Part in ipairs(Char:GetDescendants()) do
                        if Part:IsA("BasePart") then Part.CanCollide = false end
                    end
                end)
            end)
            Notify("Noclip", "Noclip enabled", "Success", nil, 2)
        else
            if NoclipConn then NoclipConn:Disconnect(); NoclipConn = nil end
            pcall(function()
                local Char = LocalPlayer.Character
                if not Char then return end
                for _, Part in ipairs(Char:GetDescendants()) do
                    if Part:IsA("BasePart") then Part.CanCollide = true end
                end
            end)
            Notify("Noclip", "Noclip disabled", "Info", nil, 2)
        end
    end,
})

SecCombatFeatures:AddKeybind("NoclipKeybind", {
    Title = "Noclip [Keybind]",
    Description = "Toggle Noclip on/off without opening the UI",
    Default = "N",
    ChangedCallback = function(New)
        Notify("Keybind", "Noclip bound to: " .. tostring(New), "Info", nil, 2)
    end,
    Callback = function()
        if Fluent.Options["NoclipToggle"] then
            Fluent.Options["NoclipToggle"]:SetValue(not Fluent.Options["NoclipToggle"].Value)
        end
    end,
})

SecCombatFeatures:AddSpace({ Height = 12 })

local SecCheckbox = Tabs.Combat:AddSection("Checkbox Element", "solar/check-square-bold")
SecCheckbox:AddSpace({ Height = 10 })

SecCheckbox:AddParagraph({
    Title = "Checkbox vs Toggle [Paragraph]",
    Content = "Checkbox is a compact element with a distinct square-box UI. It differs visually from Toggle's pill switch but works the same: fires Callback(bool) and supports SetValue.",
})

SecCheckbox:AddSpace({ Height = 6 })

SecCheckbox:AddCheckbox("CheckboxShadows", {
    Title = "Character Cast Shadows [Checkbox]",
    Default = true,
    Callback = function(Value)
        pcall(function()
            local Char = LocalPlayer.Character
            if not Char then return end
            for _, Part in ipairs(Char:GetDescendants()) do
                if Part:IsA("BasePart") then Part.CastShadow = Value end
            end
        end)
        Notify("Checkbox", "Cast Shadows: " .. (Value and "ON" or "OFF"), "Info", nil, 2)
    end,
})

SecCheckbox:AddCheckbox("CheckboxZeroGravity", {
    Title = "Zero Gravity [Checkbox]",
    Default = false,
    Callback = function(Value)
        pcall(function()
            workspace.Gravity = Value and 0 or 196.2
        end)
        Notify("Checkbox", "Gravity: " .. (Value and "0 (zero-G)" or "196.2 (default)"), Value and "Warning" or "Info", nil, 2)
    end,
})

SecCheckbox:AddCheckbox("CheckboxGlobalShadows", {
    Title = "Global Shadows [Checkbox]",
    Default = true,
    Callback = function(Value)
        pcall(function()
            game:GetService("Lighting").GlobalShadows = Value
        end)
        Notify("Checkbox", "Global Shadows: " .. (Value and "ON" or "OFF"), "Info", nil, 2)
    end,
})

SecCheckbox:AddDivider()
SecCheckbox:AddSpace({ Height = 12 })

local SecViewport = Tabs.Combat:AddSection("Viewport Element", "solar/3d-square-bold")
SecViewport:AddSpace({ Height = 10 })

SecViewport:AddParagraph({
    Title = "Interactive 3D Viewport [Paragraph]",
    Content = "Viewport renders a live 3D object inside the UI panel. Interactive=true allows drag-to-rotate and scroll-to-zoom. Use the slider and buttons below to control it via the API.",
})

SecViewport:AddSpace({ Height = 6 })

local vpModel = Instance.new("Model")
local vpPart = Instance.new("Part")
vpPart.Size = Vector3.new(4, 4, 4)
vpPart.Material = Enum.Material.SmoothPlastic
vpPart.Color = Color3.fromRGB(100, 149, 237)
vpPart.Anchored = true
vpPart.CastShadow = false
vpPart.Parent = vpModel

local vpCam = Instance.new("Camera")

local ViewportObj = SecViewport:AddViewport("ShowcaseViewport", {
    Object = vpModel,
    Camera = vpCam,
    Height = 180,
    Focused = true,
    Interactive = true,
    AspectRatio = "16:9",
})

local vpRot = 0
RunService.Heartbeat:Connect(function(dt)
    vpRot = vpRot + dt * 1.2
    pcall(function()
        vpPart.CFrame = CFrame.new(0, 0, 0) * CFrame.Angles(0, vpRot, 0)
    end)
end)

SecViewport:AddSlider("ViewportZoom", {
    Title = "Zoom Distance [Slider]",
    Description = "Calls Viewport:SetValue(distance) to adjust camera distance",
    Min = 5,
    Max = 30,
    Default = 10,
    Rounding = 1,
    LeftIcons = "minus",
    RightIcons = "plus",
    Callback = function(Value)
        ViewportObj:SetValue(Value)
    end,
})

SecViewport:AddColorpicker("ViewportColor", {
    Title = "Object Color [Colorpicker]",
    Description = "Changes the viewport Part.Color live",
    Default = Color3.fromRGB(100, 149, 237),
    Callback = function(Value)
        pcall(function() vpPart.Color = Value end)
    end,
})

local vpMaterials = { "SmoothPlastic", "Neon", "Metal", "DiamondPlate", "Granite", "Marble" }
SecViewport:AddDropdown("ViewportMaterial", {
    Title = "Object Material [Dropdown]",
    Description = "Changes the viewport Part.Material",
    Values = vpMaterials,
    Default = "SmoothPlastic",
    ThemedDropdown = true,
    NoSearch = true,
    Callback = function(Value)
        pcall(function()
            vpPart.Material = Enum.Material[Value]
        end)
        Notify("Viewport", "Material → " .. tostring(Value), "Info", nil, 2)
    end,
})

local vpBtnGrp = SecViewport:AddGroup({ Columns = 2, Gap = 8 })
local vpBtnA = vpBtnGrp:AddElement()
local vpBtnB = vpBtnGrp:AddElement()

vpBtnA:AddButton({
    Title = "Refocus Camera [Button]",
    Icon = "solar/camera-bold",
    Description = " ",
    Callback = function()
        ViewportObj:Focus()
        Notify("Viewport", "Camera refocused via :Focus()", "Info", nil, 2)
    end,
})

vpBtnB:AddButton({
    Title = "Resize Object [Button]",
    Icon = "solar/maximize-bold",
    Description = " ",
    Callback = function()
        pcall(function()
            local s = vpPart.Size.X
            vpPart.Size = s < 7 and Vector3.new(s + 1, s + 1, s + 1) or Vector3.new(2, 2, 2)
        end)
        Notify("Viewport", "Part resized!", "Info", nil, 2)
    end,
})

SecViewport:AddDivider()
SecViewport:AddSpace({ Height = 12 })

local function buildColorSequence()
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0, DConfiguration.FovCircle.primaryColor),
        ColorSequenceKeypoint.new(1, DConfiguration.FovCircle.secondaryColor),
    })
end

local function applyFovColors()
    if not DConfiguration.FovCircle.strokeGradient then return end
    local cs = buildColorSequence()
    DConfiguration.FovCircle.strokeGradient.Color = cs
    if DConfiguration.FovCircle.innerGradient then
        DConfiguration.FovCircle.innerGradient.Color = cs
    end
end

local function syncFovSize()
    if not DConfiguration.FovCircle.circleFrame then return end
    local s = DConfiguration.FovCircle.size
    DConfiguration.FovCircle.circleFrame.Size = UDim2.new(0, s, 0, s)
    DConfiguration.FovCircle.circleFrame.Position = UDim2.new(0.5, -s / 2, 0.5, -s / 2)
end

local function stopFovLoop()
    if DConfiguration.FovCircle.loopConn then
        DConfiguration.FovCircle.loopConn:Disconnect()
        DConfiguration.FovCircle.loopConn = nil
    end
end

local function startFovLoop()
    stopFovLoop()
    DConfiguration.FovCircle.loopT = 0
    DConfiguration.FovCircle.loopConn = RunService.RenderStepped:Connect(function(dt)
        if not DConfiguration.FovCircle.strokeGradient then return end
        DConfiguration.FovCircle.loopT += dt
        if not DConfiguration.FovCircle.rgbMode then
            DConfiguration.FovCircle.strokeGradient.Rotation = (DConfiguration.FovCircle.loopT * 60) % 360
            if DConfiguration.FovCircle.innerGradient then
                DConfiguration.FovCircle.innerGradient.Rotation = (DConfiguration.FovCircle.loopT * 60) % 360
            end
        end
    end)
end

local function stopFovRgb()
    if DConfiguration.FovCircle.rgbConn then
        DConfiguration.FovCircle.rgbConn:Disconnect()
        DConfiguration.FovCircle.rgbConn = nil
    end
    applyFovColors()
end

local function startFovRgb()
    if DConfiguration.FovCircle.rgbConn then
        DConfiguration.FovCircle.rgbConn:Disconnect()
        DConfiguration.FovCircle.rgbConn = nil
    end
    DConfiguration.FovCircle.rgbHue = 0
    DConfiguration.FovCircle.rgbConn = RunService.Heartbeat:Connect(function(dt)
        if not DConfiguration.FovCircle.strokeGradient then return end
        DConfiguration.FovCircle.rgbHue = (DConfiguration.FovCircle.rgbHue + dt * 0.2) % 1
        local c1 = Color3.fromHSV(DConfiguration.FovCircle.rgbHue, 1, 1)
        local c2 = Color3.fromHSV((DConfiguration.FovCircle.rgbHue + 0.5) % 1, 1, 1)
        local cs = ColorSequence.new({
            ColorSequenceKeypoint.new(0, c1),
            ColorSequenceKeypoint.new(1, c2),
        })
        DConfiguration.FovCircle.strokeGradient.Color = cs
        if DConfiguration.FovCircle.innerGradient then
            DConfiguration.FovCircle.innerGradient.Color = cs
        end
    end)
end

local function createFovGui()
    if DConfiguration.FovCircle.gui then
        DConfiguration.FovCircle.gui:Destroy()
        DConfiguration.FovCircle.gui = nil
    end
    local s = DConfiguration.FovCircle.size
    local screenGui = Instance.new("ScreenGui")
    screenGui.Name = "FovCircleGui"
    screenGui.ResetOnSpawn = false
    screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    screenGui.DisplayOrder = 5
    screenGui.Parent = game.CoreGui
    DConfiguration.FovCircle.gui = screenGui
    local circleFrame = Instance.new("Frame")
    circleFrame.Name = "FovCircle"
    circleFrame.Size = UDim2.new(0, s, 0, s)
    circleFrame.Position = UDim2.new(0.5, -s / 2, 0.5, -s / 2)
    circleFrame.BackgroundTransparency = 1
    circleFrame.BorderSizePixel = 0
    circleFrame.ZIndex = 1
    circleFrame.Parent = screenGui
    DConfiguration.FovCircle.circleFrame = circleFrame
    Instance.new("UICorner", circleFrame).CornerRadius = UDim.new(1, 0)
    local innerFrame = Instance.new("Frame")
    innerFrame.Name = "FovInner"
    innerFrame.Size = UDim2.fromScale(1, 1)
    innerFrame.BackgroundColor3 = Color3.new(1, 1, 1)
    innerFrame.BackgroundTransparency = 0.50
    innerFrame.BorderSizePixel = 0
    innerFrame.ZIndex = 2
    innerFrame.Parent = circleFrame
    Instance.new("UICorner", innerFrame).CornerRadius = UDim.new(1, 0)
    local innerGradient = Instance.new("UIGradient")
    innerGradient.Rotation = 90
    innerGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0,   0.15),
        NumberSequenceKeypoint.new(0.5, 0.75),
        NumberSequenceKeypoint.new(1,   0.15),
    })
    innerGradient.Parent = innerFrame
    DConfiguration.FovCircle.innerGradient = innerGradient
    local glassFrame = Instance.new("Frame")
    glassFrame.Name = "FovGlass"
    glassFrame.Size = UDim2.fromScale(1, 1)
    glassFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    glassFrame.BackgroundTransparency = 0.88
    glassFrame.BorderSizePixel = 0
    glassFrame.ZIndex = 3
    glassFrame.Parent = circleFrame
    Instance.new("UICorner", glassFrame).CornerRadius = UDim.new(1, 0)
    local glassGradient = Instance.new("UIGradient")
    glassGradient.Rotation = 90
    glassGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 180, 180)),
    })
    glassGradient.Parent = glassFrame
    local noiseLabel = Instance.new("ImageLabel")
    noiseLabel.Name = "FovNoise"
    noiseLabel.Image = "rbxassetid://9968344227"
    noiseLabel.ScaleType = Enum.ScaleType.Tile
    noiseLabel.TileSize = UDim2.new(0, 128, 0, 128)
    noiseLabel.Size = UDim2.fromScale(1, 1)
    noiseLabel.BackgroundTransparency = 1
    noiseLabel.ImageTransparency = 0.92
    noiseLabel.ZIndex = 4
    noiseLabel.Parent = circleFrame
    Instance.new("UICorner", noiseLabel).CornerRadius = UDim.new(1, 0)
    local circleStroke = Instance.new("UIStroke")
    circleStroke.Thickness = 2
    circleStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    circleStroke.Parent = circleFrame
    local strokeGradient = Instance.new("UIGradient")
    strokeGradient.Rotation = 90
    strokeGradient.Parent = circleStroke
    DConfiguration.FovCircle.strokeGradient = strokeGradient
    applyFovColors()
    startFovLoop()
    if DConfiguration.FovCircle.rgbMode then startFovRgb() end
end

local function destroyFovGui()
    stopFovLoop()
    stopFovRgb()
    if DConfiguration.FovCircle.gui then
        DConfiguration.FovCircle.gui:Destroy()
        DConfiguration.FovCircle.gui = nil
        DConfiguration.FovCircle.circleFrame = nil
        DConfiguration.FovCircle.strokeGradient = nil
        DConfiguration.FovCircle.innerGradient = nil
    end
end

local secFovCircle = Tabs.Combat:AddSection("FOV Circle", "solar/record-circle-bold")
secFovCircle:AddSpace({ Height = 6 })

secFovCircle:AddCheckbox(RandFlag("FovCircleEnabled"), {
    Title = "Enable FOV Circle",
    Default = DConfiguration.FovCircle.enabled,
    Callback = function(value)
        DConfiguration.FovCircle.enabled = value
        if value then createFovGui() else destroyFovGui() end
    end,
})

secFovCircle:AddSlider(RandFlag("FovCircleSize"), {
    Title = "FOV Circle Size",
    Min = 10,
    Max = 1000,
    Default = DConfiguration.FovCircle.size,
    Rounding = 0,
    LeftIcons = "minus",
    RightIcons = "plus",
    Callback = function(value)
        DConfiguration.FovCircle.size = value
        syncFovSize()
    end,
})

local colFovColor = secFovCircle:AddCollapsibleSection("FOV Circle Color", "solar/palette-bold", false)

colFovColor:AddToggle(RandFlag("FovCircleRgb"), {
    Title = "RGB Mode",
    Default = DConfiguration.FovCircle.rgbMode,
    Callback = function(value)
        DConfiguration.FovCircle.rgbMode = value
        if value then startFovRgb() else stopFovRgb() end
    end,
})

colFovColor:AddColorpicker(RandFlag("FovCircleGradient"), {
    Title = "Stroke Gradient",
    Default = DConfiguration.FovCircle.primaryColor,
    Gradient = true,
    Callback = function(colorSequence)
        if not DConfiguration.FovCircle.strokeGradient then return end
        DConfiguration.FovCircle.primaryColor = colorSequence.Keypoints[1].Value
        DConfiguration.FovCircle.secondaryColor = colorSequence.Keypoints[#colorSequence.Keypoints].Value
        if not DConfiguration.FovCircle.rgbMode then
            DConfiguration.FovCircle.strokeGradient.Color = colorSequence
            if DConfiguration.FovCircle.innerGradient then
                DConfiguration.FovCircle.innerGradient.Color = colorSequence
            end
        end
    end,
})

secFovCircle:AddSpace({ Height = 6 })

local SecShowcase = Tabs.Combat:AddSection("All Elements Showcase", "solar/widget-2-bold")
SecShowcase:AddSpace({ Height = 10 })

SecShowcase:AddParagraph({
    Title = "Element Reference [Paragraph]",
    Content = "Every element below is fully functional. Paragraph supports <b>bold</b>, <i>italic</i>, <u>underline</u> and <font color=\"rgb(255,100,180)\">custom colors</font> via Roblox rich text.",
})

SecShowcase:AddDivider()
SecShowcase:AddSpace({ Height = 6 })

SecShowcase:AddToggle("ShowcaseToggle", {
    Title = "Character Shadows [Toggle]",
    Description = "Toggles CastShadow on every BasePart of the local character",
    Icon = "solar/sun-fog-bold",
    Default = true,
    Callback = function(Value)
        pcall(function()
            local Char = LocalPlayer.Character
            if not Char then return end
            for _, Part in ipairs(Char:GetDescendants()) do
                if Part:IsA("BasePart") then Part.CastShadow = Value end
            end
        end)
        Notify("Toggle", "Character shadows: " .. (Value and "ON" or "OFF"), "Info", nil, 2)
    end,
})

SecShowcase:AddSlider("ShowcaseFOVSlider", {
    Title = "Camera FOV [Slider]",
    Description = "Sets workspace.CurrentCamera.FieldOfView in real-time",
    Min = 30,
    Max = 120,
    Default = 70,
    Rounding = 0,
    LeftIcons = "minus",
    RightIcons = "plus",
    Callback = function(Value)
        pcall(function()
            workspace.CurrentCamera.FieldOfView = Value
        end)
    end,
})

local customTagValue = ""
SecShowcase:AddInput("ShowcaseTextInput", {
    Title = "Custom Chat Tag [Input]",
    Description = "Text input with ClearButton=true. Value stored and shown on notify.",
    Placeholder = "Enter your tag...",
    Default = "",
    ClearButton = true,
    Callback = function(Value)
        customTagValue = Value
    end,
})

SecShowcase:AddInput("ShowcaseNumericInput", {
    Title = "Workspace Gravity [Input]",
    Description = "Numeric input, Finished=true — applies only on Enter/unfocus",
    Placeholder = "0 – 1000 (default: 196.2)",
    Default = "196.2",
    Numeric = true,
    Finished = true,
    Callback = function(Value)
        pcall(function()
            local g = tonumber(Value)
            if g then
                workspace.Gravity = math.clamp(g, 0, 1000)
                Notify("Gravity", "workspace.Gravity = " .. workspace.Gravity, "Info", nil, 2)
            end
        end)
    end,
})

SecShowcase:AddDivider()
SecShowcase:AddSpace({ Height = 6 })

SecShowcase:AddButton({
    Title = "Copy Player Stats [Button]",
    Description = "Copies HP / Speed / Jump / Position to clipboard via toclipboard()",
    Icon = "solar/copy-bold",
    Callback = function()
        pcall(function()
            local Char = LocalPlayer.Character
            local Hum = Char and Char:FindFirstChildOfClass("Humanoid")
            local Hrp = Char and Char:FindFirstChild("HumanoidRootPart")
            if Hum and Hrp then
                local tag = customTagValue ~= "" and (" | Tag:" .. customTagValue) or ""
                local text = string.format(
                    "HP:%d/%d | Speed:%d | Jump:%d | Pos:(%.1f,%.1f,%.1f)%s",
                    math.floor(Hum.Health), math.floor(Hum.MaxHealth),
                    math.floor(Hum.WalkSpeed), math.floor(Hum.JumpPower),
                    Hrp.Position.X, Hrp.Position.Y, Hrp.Position.Z,
                    tag
                )
                toclipboard(text)
                Notify("Stats", "Copied: " .. text, "Success", nil, 4)
            end
        end)
    end,
})

SecShowcase:AddButton({
    Title = "Open Dialog [Button]",
    Description = "Demonstrates Window:Dialog with multiple actions",
    Icon = "solar/dialog-2-bold",
    Callback = function()
        Window:Dialog({
            Title = "Dialog Component",
            Content = "This is Window:Dialog. Choose an action to fire a different Notify type:",
            Buttons = {
                {
                    Title = "Confirm",
                    Callback = function()
                        Notify("Dialog", "Action confirmed!", "Success", nil, 2)
                    end,
                },
                {
                    Title = "Warn Me",
                    Callback = function()
                        Notify("Dialog", "Warning fired from dialog!", "Warning", nil, 2)
                    end,
                },
                { Title = "Cancel" },
            },
        })
    end,
})

SecShowcase:AddDivider()
SecShowcase:AddSpace({ Height = 6 })

SecShowcase:AddDropdown("ShowcaseDropdownSingle", {
    Title = "Exposure Level [Dropdown]",
    Description = "Sets Lighting.ExposureCompensation. Single-select with Search=true.",
    Values = { "Very Dark", "Dark", "Normal", "Bright", "Very Bright" },
    Default = "Normal",
    ThemedDropdown = true,
    Search = true,
    Callback = function(Value)
        local map = { ["Very Dark"] = -4, ["Dark"] = -2, ["Normal"] = 0, ["Bright"] = 2, ["Very Bright"] = 4 }
        pcall(function()
            game:GetService("Lighting").ExposureCompensation = map[Value] or 0
        end)
        Notify("Dropdown", "Exposure → " .. tostring(Value), "Info", nil, 2)
    end,
})

local activeOverlays = {}
SecShowcase:AddDropdown("ShowcaseDropdownMulti", {
    Title = "Active Overlays [Dropdown]",
    Description = "Multi-select with ThemedDropdown=true. Tracks selected overlay labels.",
    Values = { "Health Bar", "Minimap", "FPS Counter", "Compass" },
    Default = {},
    Multi = true,
    ThemedDropdown = true,
    Callback = function(Value)
        activeOverlays = {}
        for k, v in pairs(Value) do
            if v then table.insert(activeOverlays, k) end
        end
        if #activeOverlays > 0 then
            Notify("Overlays", "Active: " .. table.concat(activeOverlays, ", "), "Info", nil, 3)
        else
            Notify("Overlays", "No overlays active", "Info", nil, 2)
        end
    end,
})

SecShowcase:AddDropdown("ShowcaseCameraShake", {
    Title = "Camera Shake [Dropdown]",
    Description = "AllowNull=true, NoSearch=true. Select null to clear, or a preset to shake.",
    Values = { "Subtle", "Medium", "Strong" },
    Default = nil,
    AllowNull = true,
    NoSearch = true,
    ThemedDropdown = true,
    Callback = function(Value)
        if not Value then
            Notify("Camera", "Shake preset cleared", "Info", nil, 2)
            return
        end
        local intensities = { Subtle = 0.4, Medium = 1.2, Strong = 2.8 }
        local intensity = intensities[Value] or 0.4
        task.spawn(function()
            for _ = 1, 10 do
                pcall(function()
                    local cam = workspace.CurrentCamera
                    local ox = (math.random() - 0.5) * 2 * intensity
                    local oy = (math.random() - 0.5) * 2 * intensity
                    cam.CFrame = cam.CFrame * CFrame.new(ox, oy, 0)
                end)
                task.wait(0.04)
            end
        end)
        Notify("Camera", "Shake: " .. tostring(Value), "Warning", nil, 2)
    end,
})

SecShowcase:AddDivider()
SecShowcase:AddSpace({ Height = 6 })

SecShowcase:AddColorpicker("ShowcaseColorpicker", {
    Title = "Outdoor Ambient [Colorpicker]",
    Description = "Sets Lighting.OutdoorAmbient live via the color wheel",
    Default = Color3.fromRGB(70, 70, 73),
    Callback = function(Value)
        pcall(function()
            game:GetService("Lighting").OutdoorAmbient = Value
        end)
    end,
})

local charVisible = true
SecShowcase:AddKeybind("ShowcaseKeybind", {
    Title = "Toggle Visibility [Keybind]",
    Description = "Press to toggle LocalTransparencyModifier on all character BaseParts",
    Icon = "solar/eye-bold",
    Default = "V",
    ChangedCallback = function(New)
        Notify("Keybind", "Visibility bind → " .. tostring(New), "Info", nil, 2)
    end,
    Callback = function()
        charVisible = not charVisible
        pcall(function()
            local Char = LocalPlayer.Character
            if not Char then return end
            for _, Part in ipairs(Char:GetDescendants()) do
                if Part:IsA("BasePart") then
                    Part.LocalTransparencyModifier = charVisible and 0 or 1
                end
            end
        end)
        Notify("Visibility", charVisible and "Character shown" or "Character hidden", "Info", nil, 2)
    end,
})

SecShowcase:AddDivider()
SecShowcase:AddSpace({ Height = 8 })

local LiveCode = SecShowcase:AddCode({
    Title = "Live Player Stats [Code]",
    Code = "-- Click Refresh Stats to populate",
    OnCopy = function()
        Notify("Code", "Stats copied to clipboard!", "Info", nil, 2)
    end,
})

SecShowcase:AddButton({
    Title = "Refresh Stats [Button]",
    Description = "Calls Code:SetCode() to update the code block above",
    Icon = "solar/refresh-bold",
    Callback = function()
        pcall(function()
            local Char = LocalPlayer.Character
            local Hum = Char and Char:FindFirstChildOfClass("Humanoid")
            local Hrp = Char and Char:FindFirstChild("HumanoidRootPart")
            if Hum and Hrp then
                local stats = string.format(
                    "HP = %d / %d\nWalkSpeed = %d\nJumpPower = %d\nPosition = (%.1f, %.1f, %.1f)\nGravity = %.1f",
                    math.floor(Hum.Health), math.floor(Hum.MaxHealth),
                    math.floor(Hum.WalkSpeed), math.floor(Hum.JumpPower),
                    Hrp.Position.X, Hrp.Position.Y, Hrp.Position.Z,
                    workspace.Gravity
                )
                LiveCode:SetCode(stats)
                Notify("Code", "Stats refreshed!", "Success", nil, 2)
            end
        end)
    end,
})

SecShowcase:AddSpace({ Height = 8 })

local ImgEl = SecShowcase:AddImage({
    Image = "https://unavatar.io/github/StyearX",
    AspectRatio = "4:3",
    Radius = 16,
})

local imgToggle = false
SecShowcase:AddButton({
    Title = "Swap Image [Button]",
    Description = "Calls Image:SetImage() to switch between two sources at runtime",
    Icon = "solar/gallery-bold",
    Callback = function()
        imgToggle = not imgToggle
        if imgToggle then
            ImgEl:SetImage("https://unavatar.io/github/roblox")
            Notify("Image", "Image → github/roblox", "Info", nil, 2)
        else
            ImgEl:SetImage("https://unavatar.io/github/StyearX")
            Notify("Image", "Image → github/StyearX", "Info", nil, 2)
        end
    end,
})

SecShowcase:AddSpace({ Height = 8 })

local AudioEl = SecShowcase:AddAudio({
    Title = "Background Track [Audio]",
    Audio = "rbxassetid://131607746976396",
    AudioTitle = "Sample Audio Track",
    AudioSubtitle = "FluentPro Audio Element",
    Volume = 0.5,
    Looped = true,
    AutoPlay = false,
})

SecShowcase:AddSlider("AudioVolumeSlider", {
    Title = "Audio Volume [Slider]",
    Description = "Calls Audio:SetVolume() on the player above",
    Min = 0,
    Max = 10,
    Default = 5,
    Rounding = 1,
    LeftIcons = "volume-x",
    RightIcons = "volume-2",
    Callback = function(Value)
        AudioEl:SetVolume(Value)
    end,
})

SecShowcase:AddButton({
    Title = "Update Audio Title [Button]",
    Description = "Calls Audio:SetAudioTitle() to change the title and subtitle",
    Icon = "solar/pen-bold",
    Callback = function()
        local titles = {
            { "Track A", "First sample" },
            { "Track B", "Second sample" },
            { "Track C", "Third sample" },
        }
        local pick = titles[math.random(1, #titles)]
        AudioEl:SetAudioTitle(pick[1], pick[2])
        Notify("Audio", "Title → " .. pick[1], "Info", nil, 2)
    end,
})

SecShowcase:AddSpace({ Height = 8 })

SecShowcase:AddVideo({
    Title = "Video Preview [Video]",
    Video = "rbxassetid://857669048",
    AspectRatio = "16:9",
    Radius = 12,
    Looped = true,
    Volume = 0,
    AutoPlay = false,
})

SecShowcase:AddSpace({ Height = 8 })

SecShowcase:AddParagraph({
    Title = "3-Column Group [Paragraph]",
    Content = "Group arranges elements in a horizontal multi-column layout. Columns and Gap are configurable.",
})

local ShowGrp3 = SecShowcase:AddGroup({ Columns = 3, Gap = 8 })
local SG3a = ShowGrp3:AddElement()
local SG3b = ShowGrp3:AddElement()
local SG3c = ShowGrp3:AddElement()

SG3a:AddButton({
    Title = "FOV – [Button]",
    Description = " ",
    Callback = function()
        pcall(function()
            local cam = workspace.CurrentCamera
            cam.FieldOfView = math.max(30, cam.FieldOfView - 10)
            Notify("FOV", "FOV → " .. cam.FieldOfView, "Info", nil, 1)
        end)
    end,
})

SG3b:AddButton({
    Title = "FOV Reset [Button]",
    Description = " ",
    Callback = function()
        pcall(function()
            workspace.CurrentCamera.FieldOfView = 70
            if Fluent.Options["ShowcaseFOVSlider"] then
                Fluent.Options["ShowcaseFOVSlider"]:SetValue(70)
            end
            Notify("FOV", "FOV reset to 70", "Info", nil, 1)
        end)
    end,
})

SG3c:AddButton({
    Title = "FOV + [Button]",
    Description = " ",
    Callback = function()
        pcall(function()
            local cam = workspace.CurrentCamera
            cam.FieldOfView = math.min(120, cam.FieldOfView + 10)
            Notify("FOV", "FOV → " .. cam.FieldOfView, "Info", nil, 1)
        end)
    end,
})

SecShowcase:AddSpace({ Height = 6 })

local ShowGrp2 = SecShowcase:AddGroup({ Columns = 2, Gap = 8 })
local SG2a = ShowGrp2:AddElement()
local SG2b = ShowGrp2:AddElement()

SG2a:AddToggle("GroupShadowToggle", {
    Title = "Shadows [Toggle]",
    Default = true,
    Callback = function(Value)
        pcall(function()
            local Char = LocalPlayer.Character
            if not Char then return end
            for _, Part in ipairs(Char:GetDescendants()) do
                if Part:IsA("BasePart") then Part.CastShadow = Value end
            end
        end)
    end,
})

SG2b:AddSlider("GroupFOVSlider", {
    Title = "FOV [Slider]",
    Min = 30,
    Max = 120,
    Default = 70,
    Rounding = 0,
    Callback = function(Value)
        pcall(function()
            workspace.CurrentCamera.FieldOfView = Value
        end)
    end,
})

SecShowcase:AddDivider()
SecShowcase:AddSpace({ Height = 10 })

local FogSection = SecShowcase:AddCollapsibleSection("Fog Controls [CollapsibleSection]", "solar/fog-bold", false)
FogSection:AddSpace({ Height = 6 })

FogSection:AddParagraph({
    Title = "Fog Settings [Paragraph]",
    Content = "CollapsibleSection is collapsed by default (openState=false). Toggle below controls Lighting.FogEnabled, slider sets FogEnd, colorpicker sets FogColor.",
})

FogSection:AddToggle("FogEnabledToggle", {
    Title = "Fog Enabled [Toggle]",
    Default = game:GetService("Lighting").FogEnd < 100000,
    Callback = function(Value)
        pcall(function()
            local L = game:GetService("Lighting")
            L.FogEnd = Value and (Fluent.Options["FogEndSlider"] and Fluent.Options["FogEndSlider"].Value or 500) or 100000
            L.FogStart = Value and 50 or 100000
        end)
        Notify("Fog", "Fog " .. (Value and "enabled" or "disabled"), "Info", nil, 2)
    end,
})

FogSection:AddSlider("FogEndSlider", {
    Title = "Fog End Distance [Slider]",
    Min = 50,
    Max = 5000,
    Default = 500,
    Rounding = 0,
    LeftIcons = "minus",
    RightIcons = "plus",
    Callback = function(Value)
        pcall(function()
            if Fluent.Options["FogEnabledToggle"] and Fluent.Options["FogEnabledToggle"].Value then
                game:GetService("Lighting").FogEnd = Value
            end
        end)
    end,
})

FogSection:AddColorpicker("FogColorPicker", {
    Title = "Fog Color [Colorpicker]",
    Default = Color3.fromRGB(190, 190, 190),
    Callback = function(Value)
        pcall(function()
            game:GetService("Lighting").FogColor = Value
        end)
    end,
})

FogSection:AddSpace({ Height = 6 })
SecShowcase:AddSpace({ Height = 15 })

local SecRuntimeMethods = Tabs.Combat:AddSection(":SetTitle / :SetDesc / :Destroy", "solar/magic-stick-3-bold")
SecRuntimeMethods:AddSpace({ Height = 10 })

SecRuntimeMethods:AddParagraph({
    Title = "Runtime Element Mutation [Paragraph]",
    Content = "Most elements expose three shared runtime methods:\n• <b>:SetTitle(str)</b> — Replace the element title label without recreating it.\n• <b>:SetDesc(str)</b> — Replace the description / subtext.\n• <b>:Destroy()</b> — Remove the element from the UI completely and clean up its internals.\n\nThe live buttons below demonstrate each method on the toggle and paragraph elements shown here.",
})

SecRuntimeMethods:AddSpace({ Height = 6 })

local mutateToggle = SecRuntimeMethods:AddToggle("MutateToggle", {
    Title = "I can be renamed [Toggle]",
    Description = "Original description — click the buttons below to change me",
    Default = false,
    Callback = function(Value)
        Notify("Toggle", "State → " .. (Value and "ON" or "OFF"), "Info", nil, 2)
    end,
})

SecRuntimeMethods:AddSpace({ Height = 6 })

local mutateParagraph = SecRuntimeMethods:AddParagraph({
    Title = "Dynamic Paragraph [Paragraph]",
    Content = "This content can be replaced at runtime using :SetDesc(). The title can also be swapped with :SetTitle().",
})

SecRuntimeMethods:AddSpace({ Height = 8 })

local setTitleRow = SecRuntimeMethods:AddGroup({ Columns = 2, Gap = 8 })
local setTitleColA = setTitleRow:AddElement()
local setTitleColB = setTitleRow:AddElement()

local titleCycle = { "Renamed Title A", "Renamed Title B", "Back to Default" }
local titleIdx = 0
setTitleColA:AddButton({
    Title = "Cycle :SetTitle() [Button]",
    Description = " ",
    Callback = function()
        titleIdx = (titleIdx % #titleCycle) + 1
        mutateToggle:SetTitle(titleCycle[titleIdx])
        Notify(":SetTitle", "Title → " .. titleCycle[titleIdx], "Info", nil, 2)
    end,
})

local descCycle = { "Description updated once!", "Changed a second time!", "Original description — click the buttons below to change me" }
local descIdx = 0
setTitleColB:AddButton({
    Title = "Cycle :SetDesc() [Button]",
    Description = " ",
    Callback = function()
        descIdx = (descIdx % #descCycle) + 1
        mutateToggle:SetDesc(descCycle[descIdx])
        mutateParagraph:SetDesc("Content updated at runtime:\n" .. descCycle[descIdx])
        Notify(":SetDesc", "Desc updated", "Info", nil, 2)
    end,
})

SecRuntimeMethods:AddSpace({ Height = 8 })

local destroyRow = SecRuntimeMethods:AddGroup({ Columns = 2, Gap = 8 })
local destroyColA = destroyRow:AddElement()
local destroyColB = destroyRow:AddElement()

local tempElement = nil
destroyColA:AddButton({
    Title = "Spawn Temp Element [Button]",
    Description = " ",
    Callback = function()
        if tempElement then
            Notify(":Destroy", "Already spawned — destroy it first", "Warning", nil, 2)
            return
        end
        tempElement = SecRuntimeMethods:AddToggle("TempDestroyToggle_" .. tostring(math.random(1, 99999)), {
            Title = "I will be destroyed [Toggle]",
            Description = "Click Destroy Element to remove me",
            Default = false,
            Callback = function(v)
                Notify("Temp Toggle", "State → " .. (v and "ON" or "OFF"), "Info", nil, 2)
            end,
        })
        Notify(":Destroy", "Temp element spawned!", "Success", nil, 2)
    end,
})

destroyColB:AddButton({
    Title = "Destroy Element [Button]",
    Description = " ",
    Callback = function()
        if not tempElement then
            Notify(":Destroy", "Spawn an element first", "Warning", nil, 2)
            return
        end
        tempElement:Destroy()
        tempElement = nil
        Notify(":Destroy", "Element destroyed!", "Success", nil, 2)
    end,
})

SecRuntimeMethods:AddSpace({ Height = 15 })

local SecColorFormats = Tabs.Combat:AddSection("Color Formats — Hex / RGB / HSV", "solar/palette-bold")
SecColorFormats:AddSpace({ Height = 10 })

SecColorFormats:AddParagraph({
    Title = "Color Format Showcase [Paragraph]",
    Content = "FluentPro colorpickers return a <b>Color3</b> value. You can decompose it into any format:\n• <b>Hex</b> — color:ToHex()\n• <b>RGB</b> — color.R * 255, color.G * 255, color.B * 255\n• <b>HSV</b> — Color3.toHSV(color) → H, S, V\n\nThe picker below fires a callback every time you change the color. The Paragraph above it updates live with all three representations.",
})

SecColorFormats:AddSpace({ Height = 6 })

local colorReadout = SecColorFormats:AddParagraph({
    Title = "Live Color Readout",
    Content = "Pick a color below to see Hex, RGB, and HSV values appear here.",
})

SecColorFormats:AddColorpicker("ColorFormatPicker", {
    Title = "Pick Any Color [Colorpicker]",
    Default = Color3.fromHSV(0.6, 0.8, 1),
    Callback = function(c)
        local r = math.round(c.R * 255)
        local g = math.round(c.G * 255)
        local b = math.round(c.B * 255)
        local h, s, v = Color3.toHSV(c)
        local hex = c:ToHex()
        colorReadout:SetDesc(
            "<b>Hex</b>   #" .. hex:upper() ..
            "\n<b>RGB</b>  " .. r .. ", " .. g .. ", " .. b ..
            "\n<b>HSV</b>  H:" .. math.round(h * 360) .. "°  S:" .. math.round(s * 100) .. "%  V:" .. math.round(v * 100) .. "%"
        )
        pcall(function()
            game:GetService("Lighting").OutdoorAmbient = c
        end)
    end,
})

SecColorFormats:AddSpace({ Height = 8 })

SecColorFormats:AddParagraph({
    Title = "HSV Colorpicker Access [Paragraph]",
    Content = "After creating a colorpicker, you can read its live HSV components directly from the returned element object:\n    local picker = sec:AddColorpicker(\"Flag\", { ... })\n    print(picker.Hue)  -- 0–1 hue\n    print(picker.Sat)  -- 0–1 saturation\n    print(picker.Vib)  -- 0–1 brightness\n\nThese update every time the user moves the HSV canvas.",
})

local hsvReadPicker = SecColorFormats:AddColorpicker("HsvReadPicker", {
    Title = "HSV Component Reader [Colorpicker]",
    Default = Color3.fromHSV(0.0, 1, 1),
    Callback = function(_) end,
})

SecColorFormats:AddButton({
    Title = "Read HSV Fields [Button]",
    Description = "Reads picker.Hue / .Sat / .Vib from the colorpicker above",
    Icon = "solar/eye-bold",
    Callback = function()
        local h = hsvReadPicker.Hue or 0
        local s = hsvReadPicker.Sat or 0
        local v = hsvReadPicker.Vib or 0
        Notify(
            "HSV Fields",
            string.format("H: %.3f  S: %.3f  V: %.3f", h, s, v),
            "Info",
            nil,
            4
        )
    end,
})

SecColorFormats:AddSpace({ Height = 15 })

local SecNotifications = Tabs.Combat:AddSection("Notification Showcase", "solar/bell-bold")
SecNotifications:AddSpace({ Height = 10 })

SecNotifications:AddParagraph({
    Title = "All Notification Types [Paragraph]",
    Content = "Test every Notify type. FluentPro supports Success, Error, Warning, and Info styles with optional icon, title, content, sub-content and duration.",
})

SecNotifications:AddSpace({ Height = 6 })

local NRow1 = SecNotifications:AddGroup({ Columns = 2, Gap = 8 })
local NR1a = NRow1:AddElement()
local NR1b = NRow1:AddElement()

NR1a:AddButton({
    Title = "Success [Button]",
    Description = " ",
    Callback = function()
        Notify("Notification", "This is a Success notification!", "Success", nil, 4)
    end,
})

NR1b:AddButton({
    Title = "Error [Button]",
    Description = " ",
    Callback = function()
        Notify("Notification", "This is an Error notification!", "Error", nil, 4)
    end,
})

local NRow2 = SecNotifications:AddGroup({ Columns = 2, Gap = 8 })
local NR2a = NRow2:AddElement()
local NR2b = NRow2:AddElement()

NR2a:AddButton({
    Title = "Warning [Button]",
    Description = " ",
    Callback = function()
        Notify("Notification", "This is a Warning notification!", "Warning", nil, 4)
    end,
})

NR2b:AddButton({
    Title = "Info [Button]",
    Description = " ",
    Callback = function()
        Notify("Notification", "This is an Info notification!", "Info", nil, 4)
    end,
})

SecNotifications:AddSpace({ Height = 8 })

SecNotifications:AddButton({
    Title = "Custom Notification [Button]",
    Description = "Uses Fluent:Notify{} directly with SubContent, Image and Duration",
    Icon = "solar/star-bold",
    Callback = function()
        Fluent:Notify({
            Title = "FluentPro",
            Content = "Custom notification with Solar icon and SubContent!",
            SubContent = "Duration: 6 seconds",
            Image = "solar/star-bold",
            Duration = 6,
        })
    end,
})

SecNotifications:AddSpace({ Height = 15 })

local SecHVGroup = Tabs.Combat:AddSection("HGroup & VGroup [Layout]", "solar/widget-2-bold")
SecHVGroup:AddSpace({ Height = 8 })

SecHVGroup:AddParagraph({
    Title = "HGroup & VGroup [Paragraph]",
    Content = "HGroup creates a horizontal row container. Call :VGroup() on it to add equal-width columns. Each VGroup is a full element container — any element method works inside it.\n\nColumns split width equally and auto-recalculate when new VGroups are added.",
})

SecHVGroup:AddSpace({ Height = 6 })

local DemoHGroup = SecHVGroup:HGroup({ Gap = 8 })
local DemoLeft = DemoHGroup:VGroup({ Gap = 6 })
local DemoRight = DemoHGroup:VGroup({ Gap = 6 })

DemoLeft:Button({
    Title = "Attack [Button]",
    Description = "Enable aimbot",
    Callback = function()
        Notify("HGroup", "Left column button clicked", "Success", nil, 2)
    end,
})
DemoLeft:Toggle("AimbotToggle", {
    Title = "Aimbot [Toggle]",
    Default = false,
    Callback = function(v)
        Notify("HGroup", "Aimbot " .. (v and "on" or "off"), v and "Success" or "Info", nil, 2)
    end,
})
DemoLeft:Slider("AimbotFOVSlider", {
    Title = "FOV [Slider]",
    Min = 10,
    Max = 180,
    Default = 60,
    Rounding = 0,
    Callback = function(v) end,
})

DemoRight:Button({
    Title = "Teleport [Button]",
    Description = "Tp to player",
    Callback = function()
        Notify("HGroup", "Right column button clicked", "Info", nil, 2)
    end,
})
DemoRight:Toggle("SpeedHackHGroupToggle", {
    Title = "Speed Hack [Toggle]",
    Default = false,
    Callback = function(v)
        Notify("HGroup", "Speed hack " .. (v and "on" or "off"), v and "Success" or "Info", nil, 2)
    end,
})
DemoRight:Slider("SpeedSliderHGroup", {
    Title = "Speed [Slider]",
    Min = 0,
    Max = 250,
    Default = 16,
    Rounding = 0,
    LeftIcons = "walking",
    RightIcons = "zap",
    Callback = function(v) end,
})

SecHVGroup:AddSpace({ Height = 6 })

SecHVGroup:AddParagraph({
    Title = "3-Column HGroup [Paragraph]",
    Content = "You can add more than 2 VGroups. Each call to :VGroup() recalculates all column widths equally.",
})

SecHVGroup:AddSpace({ Height = 6 })

local Demo3HGroup = SecHVGroup:HGroup({ Gap = 6 })
local D3a = Demo3HGroup:VGroup({ Gap = 6 })
local D3b = Demo3HGroup:VGroup({ Gap = 6 })
local D3c = Demo3HGroup:VGroup({ Gap = 6 })

D3a:Button({ Title = "Col A [Button]", Description = " ", Callback = function() Notify("3-Col", "Column A", "Info", nil, 2) end })
D3b:Button({ Title = "Col B [Button]", Description = " ", Callback = function() Notify("3-Col", "Column B", "Info", nil, 2) end })
D3c:Button({ Title = "Col C [Button]", Description = " ", Callback = function() Notify("3-Col", "Column C", "Info", nil, 2) end })

SecHVGroup:AddSpace({ Height = 6 })

Notify("GoonWares", "loaded successfully", "Success", nil, 4)

task.delay(0.5, function()
    Window:SelectTab(5)
end)