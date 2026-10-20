-- Modern Roblox UI Framework (Fixed Text Scaling & Loadstring Support)

--added ts to avoid discord removal video
if not game:GetService("StarterGui") or not setclipboard then return end

game:GetService("StarterGui"):SetCore("SendNotification", {
	Title = "discord.gg/7WYxm2DEkn",
	Text = "New Link (Copied)",
	Duration = 10
})

setclipboard("https://discord.gg/pfrhSU5jwN")

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")

-- Cleanup Existing Instances
if CoreGui:FindFirstChild("GhostGui") then
    CoreGui:FindFirstChild("GhostGui"):Destroy()
end

-- Safe Helper function for Text Scaling using UITextSizeConstraint
local function ApplyTextScaling(textObject, minSize, maxSize)
    local minVal = math.floor(tonumber(minSize) or 8)
    local maxVal = math.floor(tonumber(maxSize) or 14)

    textObject.TextScaled = true

    local constraint = Instance.new("UITextSizeConstraint")
    constraint.MinTextSize = minVal
    constraint.MaxTextSize = maxVal
    constraint.Parent = textObject

    return constraint
end

-- ScreenGui Setup
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "GhostGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = CoreGui

-- Notification Container
local NotificationHolder = Instance.new("Frame")
NotificationHolder.Name = "NotificationHolder"
NotificationHolder.Size = UDim2.new(0, 260, 1, 0)
NotificationHolder.Position = UDim2.new(0.5, -130, 0, 20)
NotificationHolder.BackgroundTransparency = 1
NotificationHolder.Parent = ScreenGui

local NotifLayout = Instance.new("UIListLayout")
NotifLayout.Parent = NotificationHolder
NotifLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifLayout.Padding = UDim.new(0, 8)
NotifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Main Container Frame
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 240, 0, 40)
MainFrame.Position = UDim2.new(0.5, -120, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.Parent = ScreenGui

local MainScale = Instance.new("UIScale")
MainScale.Scale = 1
MainScale.Parent = MainFrame

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 8)
MainCorner.Parent = MainFrame

-- Title
local TitleLabel = Instance.new("TextLabel")
TitleLabel.Name = "Title"
TitleLabel.Size = UDim2.new(1, -120, 1, 0)
TitleLabel.Position = UDim2.new(0, 12, 0, 0)
TitleLabel.BackgroundTransparency = 1
TitleLabel.Text = "Ghost UI"
TitleLabel.Font = Enum.Font.GothamBold
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
TitleLabel.Parent = MainFrame
ApplyTextScaling(TitleLabel, 10, 14)

-- Collapse/Expand Content Button
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "Toggle"
ToggleBtn.Size = UDim2.new(0, 30, 0, 30)
ToggleBtn.Position = UDim2.new(1, -35, 0, 5)
ToggleBtn.BackgroundTransparency = 1
ToggleBtn.Text = "v"
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextColor3 = Color3.fromRGB(180, 180, 180)
ToggleBtn.Parent = MainFrame
ApplyTextScaling(ToggleBtn, 10, 14)

-- Credit Buttons Tracking
local creditButtons = {}
local MAX_CREDIT_BUTTONS = 4

-- Scrolling Container
local MAX_CONTAINER_HEIGHT = 280

local Container = Instance.new("ScrollingFrame")
Container.Name = "ContentsFrame"
Container.Size = UDim2.new(1, 0, 0, 0)
Container.Position = UDim2.new(0, 0, 1, 5)
Container.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
Container.BorderSizePixel = 0
Container.ClipsDescendants = true
Container.Visible = true
Container.ScrollBarThickness = 4
Container.ScrollBarImageColor3 = Color3.fromRGB(0, 170, 255)
Container.CanvasSize = UDim2.new(0, 0, 0, 0)
Container.Parent = MainFrame

local ContainerCorner = Instance.new("UICorner")
ContainerCorner.CornerRadius = UDim.new(0, 8)
ContainerCorner.Parent = Container

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = Container
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 6)

local UIPadding = Instance.new("UIPadding")
UIPadding.Parent = Container
UIPadding.PaddingTop = UDim.new(0, 6)
UIPadding.PaddingBottom = UDim.new(0, 6)
UIPadding.PaddingLeft = UDim.new(0, 8)
UIPadding.PaddingRight = UDim.new(0, 10)

-- Auto Resizing Container Height
local function UpdateContainerSize()
    local contentHeight = UIListLayout.AbsoluteContentSize.Y + 12
    Container.CanvasSize = UDim2.new(0, 0, 0, contentHeight)
    
    local targetHeight = math.min(contentHeight, MAX_CONTAINER_HEIGHT)
    if Container.Visible then
        TweenService:Create(Container, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, 0, 0, targetHeight)
        }):Play()
    end
end
UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(UpdateContainerSize)

-- Toggle Menu Animation
local isExpanded = false
ToggleBtn.MouseButton1Click:Connect(function()
    isExpanded = not isExpanded
    ToggleBtn.Text = isExpanded and "^" or "v"
    
    if isExpanded then
        Container.Visible = true
        UpdateContainerSize()
    else
        local tween = TweenService:Create(Container, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            Size = UDim2.new(1, 0, 0, 0)
        })
        tween:Play()
        tween.Completed:Connect(function()
            if not isExpanded then Container.Visible = false end
        end)
    end
end)

-- Draggable Toggle Button & Effect
local OpenCloseBtn = Instance.new("ImageButton")
OpenCloseBtn.Name = "OpenCloseToggleButton"
OpenCloseBtn.Size = UDim2.new(0, 48, 0, 48)
OpenCloseBtn.Position = UDim2.new(0.85, 0, 0.8, 0)
OpenCloseBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
OpenCloseBtn.Active = true
OpenCloseBtn.Draggable = true
OpenCloseBtn.ScaleType = Enum.ScaleType.Fit
OpenCloseBtn.AnchorPoint = Vector2.new(0.5, 0.5)
OpenCloseBtn.Parent = ScreenGui

local OpenCloseCorner = Instance.new("UICorner")
OpenCloseCorner.CornerRadius = UDim.new(1, 0)
OpenCloseCorner.Parent = OpenCloseBtn

local OpenCloseStroke = Instance.new("UIStroke")
OpenCloseStroke.Color = Color3.fromRGB(0, 170, 255)
OpenCloseStroke.Thickness = 1.5
OpenCloseStroke.Parent = OpenCloseBtn

local OpenCloseText = Instance.new("TextLabel")
OpenCloseText.Name = "Label"
OpenCloseText.Size = UDim2.new(1, 0, 1, 0)
OpenCloseText.BackgroundTransparency = 1
OpenCloseText.Text = "UI"
OpenCloseText.Font = Enum.Font.GothamBold
OpenCloseText.TextColor3 = Color3.fromRGB(0, 170, 255)
OpenCloseText.Parent = OpenCloseBtn
ApplyTextScaling(OpenCloseText, 10, 14)

local function TriggerBlackHoleEffect(pos)
    local BH = Instance.new("Frame")
    BH.Name = "BlackHoleEffect"
    BH.Size = UDim2.new(0, 0, 0, 0)
    BH.Position = pos
    BH.AnchorPoint = Vector2.new(0.5, 0.5)
    BH.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    BH.BorderSizePixel = 0
    BH.ZIndex = 10
    BH.Parent = ScreenGui

    local BHCorner = Instance.new("UICorner")
    BHCorner.CornerRadius = UDim.new(1, 0)
    BHCorner.Parent = BH

    local BHStroke = Instance.new("UIStroke")
    BHStroke.Color = Color3.fromRGB(0, 170, 255)
    BHStroke.Thickness = 3
    BHStroke.Transparency = 0
    BHStroke.Parent = BH

    local expand = TweenService:Create(BH, TweenInfo.new(0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(0, 75, 0, 75) })
    local contract = TweenService:Create(BH, TweenInfo.new(0.25, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Size = UDim2.new(0, 0, 0, 0) })
    local strokeFade = TweenService:Create(BHStroke, TweenInfo.new(0.25), { Transparency = 1 })

    expand:Play()
    expand.Completed:Connect(function() contract:Play() strokeFade:Play() end)
    contract.Completed:Connect(function() BH:Destroy() end)
end

local guiVisible = true
local isAnimating = false
local originalPos = MainFrame.Position

MainFrame:GetPropertyChangedSignal("Position"):Connect(function()
    if guiVisible and not isAnimating then originalPos = MainFrame.Position end
end)

local function SetGuiVisibility(visible)
    if isAnimating then return end
    isAnimating = true
    guiVisible = visible

    OpenCloseText.TextColor3 = guiVisible and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(150, 150, 150)
    OpenCloseStroke.Color = guiVisible and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(80, 80, 80)

    local targetBtnPos = OpenCloseBtn.Position
    TriggerBlackHoleEffect(targetBtnPos)

    if not guiVisible then
        originalPos = MainFrame.Position
        local shrinkTween = TweenService:Create(MainScale, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), { Scale = 0 })
        local moveTween = TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.In), { Position = targetBtnPos, Rotation = 90 })

        shrinkTween:Play()
        moveTween:Play()
        moveTween.Completed:Connect(function()
            MainFrame.Visible = false
            MainFrame.Rotation = 0
            isAnimating = false
        end)
    else
        MainFrame.Position = targetBtnPos
        MainFrame.Rotation = -90
        MainScale.Scale = 0
        MainFrame.Visible = true

        local growTween = TweenService:Create(MainScale, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 })
        local moveTween = TweenService:Create(MainFrame, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Position = originalPos, Rotation = 0 })

        growTween:Play()
        moveTween:Play()
        growTween.Completed:Connect(function() isAnimating = false end)
    end
end

OpenCloseBtn.MouseButton1Click:Connect(function()
    SetGuiVisibility(not guiVisible)
end)

----------------------------------------------------
-- UI BUILDER MODULE TABLE
----------------------------------------------------
local Library = {}
local RegisteredElements = {}

function Library:SetTitle(newTitle)
    TitleLabel.Text = tostring(newTitle)
end

function Library:SetToggleButton(options)
    options = options or {}
    local mode = options.Mode or (options.Image and "Image" or "Text")
    
    if mode == "Image" and options.Image then
        OpenCloseText.Visible = false
        OpenCloseBtn.Image = typeof(options.Image) == "number" and ("rbxassetid://" .. tostring(options.Image)) or options.Image
    else
        OpenCloseBtn.Image = ""
        OpenCloseText.Visible = true
        OpenCloseText.Text = options.Text or options.Name or "UI"
    end

    if options.Size then OpenCloseBtn.Size = options.Size end
    if options.Position then OpenCloseBtn.Position = options.Position end
end

-- 1. AddTitleEditor
function Library:AddTitleEditor(options)
    options = options or {}
    options.Name = options.Name or "Menu Title"
    options.Placeholder = options.Placeholder or "Type new menu name..."
    
    local Frame = Instance.new("Frame")
    Frame.Name = "TitleEditor_" .. options.Name
    Frame.Size = UDim2.new(1, 0, 0, 34)
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    Frame.Parent = Container

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(0.45, -10, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = options.Name
    Label.Font = Enum.Font.GothamMedium
    Label.TextColor3 = Color3.fromRGB(240, 240, 240)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    ApplyTextScaling(Label, 8, 12)

    local Input = Instance.new("TextBox")
    Input.Name = "Input"
    Input.Size = UDim2.new(0.55, -10, 0, 22)
    Input.Position = UDim2.new(0.45, 0, 0.5, -11)
    Input.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    Input.Text = TitleLabel.Text
    Input.PlaceholderText = options.Placeholder
    Input.Font = Enum.Font.Gotham
    Input.TextColor3 = Color3.fromRGB(255, 255, 255)
    Input.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
    Input.Parent = Frame
    ApplyTextScaling(Input, 8, 11)

    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 4)
    InputCorner.Parent = Input

    local conn = Input.FocusLost:Connect(function()
        if Input.Text ~= "" then Library:SetTitle(Input.Text) end
    end)

    local Element = {Instance = Frame}
    function Element:Set(newOptions)
        if newOptions and newOptions.Title then
            Library:SetTitle(newOptions.Title)
            Input.Text = newOptions.Title
        end
    end
    function Element:Delete()
        conn:Disconnect()
        Frame:Destroy()
        UpdateContainerSize()
    end
    return Element
end

-- 2. AddButton
function Library:AddButton(options)
    options = options or {}
    options.Name = options.Name or "Button"
    options.Callback = options.Callback or function() end

    local Button = Instance.new("TextButton")
    Button.Name = "Button_" .. options.Name
    Button.Size = UDim2.new(1, 0, 0, 32)
    Button.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    Button.Text = options.Name
    Button.Font = Enum.Font.GothamMedium
    Button.TextColor3 = Color3.fromRGB(240, 240, 240)
    Button.AutoButtonColor = true
    Button.Parent = Container
    ApplyTextScaling(Button, 8, 12)

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Button

    local conn = Button.MouseButton1Click:Connect(function() options.Callback() end)

    local Element = {Instance = Button}
    function Element:Set(newOptions)
        newOptions = newOptions or {}
        if newOptions.Name then options.Name = newOptions.Name; Button.Text = newOptions.Name end
        if newOptions.Callback then options.Callback = newOptions.Callback end
    end
    function Element:Delete()
        conn:Disconnect()
        Button:Destroy()
        UpdateContainerSize()
    end
    return Element
end

-- 3. AddToggle
function Library:AddToggle(options)
    options = options or {}
    options.Name = options.Name or "Toggle"
    options.Value = options.Value or options.Default or false
    options.Callback = options.Callback or function() end

    local Frame = Instance.new("Frame")
    Frame.Name = "Toggle_" .. options.Name
    Frame.Size = UDim2.new(1, 0, 0, 32)
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    Frame.Parent = Container

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = options.Name
    Label.Font = Enum.Font.GothamMedium
    Label.TextColor3 = Color3.fromRGB(240, 240, 240)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    ApplyTextScaling(Label, 8, 12)

    local ToggleBox = Instance.new("TextButton")
    ToggleBox.Name = "Box"
    ToggleBox.Size = UDim2.new(0, 20, 0, 20)
    ToggleBox.Position = UDim2.new(1, -26, 0.5, -10)
    ToggleBox.BackgroundColor3 = options.Value and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 50, 60)
    ToggleBox.Text = ""
    ToggleBox.Parent = Frame

    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 4)
    BoxCorner.Parent = ToggleBox

    local conn = ToggleBox.MouseButton1Click:Connect(function()
        options.Value = not options.Value
        TweenService:Create(ToggleBox, TweenInfo.new(0.15), { BackgroundColor3 = options.Value and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 50, 60) }):Play()
        options.Callback(options.Value)
    end)

    local Element = {Instance = Frame, Options = options}
    RegisteredElements[options.Name] = Element

    function Element:Set(newOptions)
        newOptions = newOptions or {}
        if newOptions.Name then options.Name = newOptions.Name; Label.Text = newOptions.Name end
        if newOptions.Value ~= nil then
            options.Value = newOptions.Value
            ToggleBox.BackgroundColor3 = options.Value and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(50, 50, 60)
            options.Callback(options.Value)
        end
        if newOptions.Callback then options.Callback = newOptions.Callback end
    end
    function Element:Delete()
        conn:Disconnect()
        RegisteredElements[options.Name] = nil
        Frame:Destroy()
        UpdateContainerSize()
    end
    return Element
end

-- 4. AddSlider
function Library:AddSlider(options)
    options = options or {}
    options.Name = options.Name or "Slider"
    options.Min = options.Min or 0
    options.Max = options.Max or 100
    options.Value = options.Value or options.Default or options.Min
    options.Callback = options.Callback or function() end

    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = "Slider_" .. options.Name
    SliderFrame.Size = UDim2.new(1, 0, 0, 45)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    SliderFrame.Parent = Container

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = SliderFrame

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, -20, 0, 20)
    Label.Position = UDim2.new(0, 10, 0, 4)
    Label.BackgroundTransparency = 1
    Label.Text = options.Name .. ": " .. tostring(options.Value)
    Label.Font = Enum.Font.GothamMedium
    Label.TextColor3 = Color3.fromRGB(240, 240, 240)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = SliderFrame
    ApplyTextScaling(Label, 8, 12)

    local Bar = Instance.new("Frame")
    Bar.Name = "Bar"
    Bar.Size = UDim2.new(1, -20, 0, 6)
    Bar.Position = UDim2.new(0, 10, 0, 28)
    Bar.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
    Bar.BorderSizePixel = 0
    Bar.Parent = SliderFrame

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(0, 3)
    BarCorner.Parent = Bar

    local Fill = Instance.new("Frame")
    Fill.Name = "Fill"
    Fill.Size = UDim2.new((options.Value - options.Min) / (options.Max - options.Min), 0, 1, 0)
    Fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Fill.BorderSizePixel = 0
    Fill.Parent = Bar

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(0, 3)
    FillCorner.Parent = Fill

    local isSliding = false
    local function UpdateInput(input)
        local deltaX = math.clamp((input.Position.X - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)
        options.Value = math.floor(options.Min + (options.Max - options.Min) * deltaX)
        TweenService:Create(Fill, TweenInfo.new(0.08), {Size = UDim2.new(deltaX, 0, 1, 0)}):Play()
        Label.Text = options.Name .. ": " .. tostring(options.Value)
        options.Callback(options.Value)
    end

    local c1 = Bar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliding = true
            UpdateInput(input)
        end
    end)
    local c2 = UserInputService.InputChanged:Connect(function(input)
        if isSliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateInput(input)
        end
    end)
    local c3 = UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isSliding = false
        end
    end)

    local Element = {Instance = SliderFrame, Options = options}
    RegisteredElements[options.Name] = Element

    function Element:Set(newOptions)
        newOptions = newOptions or {}
        if newOptions.Min then options.Min = newOptions.Min end
        if newOptions.Max then options.Max = newOptions.Max end
        if newOptions.Name then options.Name = newOptions.Name end
        if newOptions.Value ~= nil then
            options.Value = math.clamp(newOptions.Value, options.Min, options.Max)
            local scale = (options.Value - options.Min) / (options.Max - options.Min)
            Fill.Size = UDim2.new(scale, 0, 1, 0)
            options.Callback(options.Value)
        end
        Label.Text = options.Name .. ": " .. tostring(options.Value)
        if newOptions.Callback then options.Callback = newOptions.Callback end
    end
    function Element:Delete()
        c1:Disconnect(); c2:Disconnect(); c3:Disconnect()
        RegisteredElements[options.Name] = nil
        SliderFrame:Destroy()
        UpdateContainerSize()
    end
    return Element
end

-- 5. AddTextbox
function Library:AddTextbox(options)
    options = options or {}
    options.Name = options.Name or "TextBox"
    options.Placeholder = options.Placeholder or "Type here..."
    options.Value = options.Value or options.Default or ""
    options.Callback = options.Callback or function() end

    local Frame = Instance.new("Frame")
    Frame.Name = "TextBox_" .. options.Name
    Frame.Size = UDim2.new(1, 0, 0, 34)
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    Frame.Parent = Container

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(0.45, -10, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = options.Name
    Label.Font = Enum.Font.GothamMedium
    Label.TextColor3 = Color3.fromRGB(240, 240, 240)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Frame
    ApplyTextScaling(Label, 8, 12)

    local Input = Instance.new("TextBox")
    Input.Name = "Input"
    Input.Size = UDim2.new(0.55, -10, 0, 22)
    Input.Position = UDim2.new(0.45, 0, 0.5, -11)
    Input.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    Input.Text = options.Value
    Input.PlaceholderText = options.Placeholder
    Input.Font = Enum.Font.Gotham
    Input.TextColor3 = Color3.fromRGB(255, 255, 255)
    Input.PlaceholderColor3 = Color3.fromRGB(120, 120, 130)
    Input.Parent = Frame
    ApplyTextScaling(Input, 8, 11)

    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 4)
    InputCorner.Parent = Input

    local conn = Input.FocusLost:Connect(function(enterPressed)
        options.Value = Input.Text
        options.Callback(options.Value, enterPressed)
    end)

    local Element = {Instance = Frame, Options = options}
    RegisteredElements[options.Name] = Element

    function Element:Set(newOptions)
        newOptions = newOptions or {}
        if newOptions.Name then options.Name = newOptions.Name; Label.Text = newOptions.Name end
        if newOptions.Placeholder then options.Placeholder = newOptions.Placeholder; Input.PlaceholderText = newOptions.Placeholder end
        if newOptions.Value ~= nil then
            options.Value = newOptions.Value
            Input.Text = tostring(newOptions.Value)
            options.Callback(options.Value, false)
        end
        if newOptions.Callback then options.Callback = newOptions.Callback end
    end
    function Element:Delete()
        conn:Disconnect()
        RegisteredElements[options.Name] = nil
        Frame:Destroy()
        UpdateContainerSize()
    end
    return Element
end

-- 6. AddDropdown
function Library:AddDropdown(options)
    options = options or {}
    options.Name = options.Name or "Dropdown"
    options.Options = options.Options or {}
    options.Value = options.Value or options.Default or (options.Options[1] or "")
    options.Callback = options.Callback or function() end

    local DropdownFrame = Instance.new("Frame")
    DropdownFrame.Name = "Dropdown_" .. options.Name
    DropdownFrame.Size = UDim2.new(1, 0, 0, 34)
    DropdownFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    DropdownFrame.ClipsDescendants = true
    DropdownFrame.Parent = Container

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = DropdownFrame

    local MainButton = Instance.new("TextButton")
    MainButton.Name = "MainButton"
    MainButton.Size = UDim2.new(1, 0, 0, 34)
    MainButton.BackgroundTransparency = 1
    MainButton.Text = ""
    MainButton.Parent = DropdownFrame

    local Label = Instance.new("TextLabel")
    Label.Name = "Label"
    Label.Size = UDim2.new(1, -30, 0, 34)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = options.Name .. ": " .. tostring(options.Value)
    Label.Font = Enum.Font.GothamMedium
    Label.TextColor3 = Color3.fromRGB(240, 240, 240)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = MainButton
    ApplyTextScaling(Label, 8, 12)

    local Arrow = Instance.new("TextLabel")
    Arrow.Name = "Arrow"
    Arrow.Size = UDim2.new(0, 20, 0, 34)
    Arrow.Position = UDim2.new(1, -25, 0, 0)
    Arrow.BackgroundTransparency = 1
    Arrow.Text = "v"
    Arrow.Font = Enum.Font.GothamBold
    Arrow.TextColor3 = Color3.fromRGB(180, 180, 180)
    Arrow.Parent = MainButton
    ApplyTextScaling(Arrow, 8, 12)

    local OptionContainer = Instance.new("Frame")
    OptionContainer.Name = "OptionsList"
    OptionContainer.Size = UDim2.new(1, -16, 0, 0)
    OptionContainer.Position = UDim2.new(0, 8, 0, 34)
    OptionContainer.BackgroundTransparency = 1
    OptionContainer.Parent = DropdownFrame

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 4)
    ListLayout.Parent = OptionContainer

    local open = false
    local function ToggleDropdown()
        open = not open
        Arrow.Text = open and "^" or "v"
        local optionsHeight = ListLayout.AbsoluteContentSize.Y
        local targetFrameHeight = open and (38 + optionsHeight) or 34

        TweenService:Create(DropdownFrame, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, targetFrameHeight) }):Play()
        task.delay(0.05, UpdateContainerSize)
    end

    local conn = MainButton.MouseButton1Click:Connect(ToggleDropdown)

    local function BuildOptions()
        for _, child in ipairs(OptionContainer:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        for _, opt in ipairs(options.Options) do
            local OptBtn = Instance.new("TextButton")
            OptBtn.Name = "Option_" .. tostring(opt)
            OptBtn.Size = UDim2.new(1, 0, 0, 24)
            OptBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
            OptBtn.Text = opt
            OptBtn.Font = Enum.Font.Gotham
            OptBtn.TextColor3 = Color3.fromRGB(200, 200, 200)
            OptBtn.Parent = OptionContainer
            ApplyTextScaling(OptBtn, 8, 11)

            local OptCorner = Instance.new("UICorner")
            OptCorner.CornerRadius = UDim.new(0, 4)
            OptCorner.Parent = OptBtn

            OptBtn.MouseButton1Click:Connect(function()
                options.Value = opt
                Label.Text = options.Name .. ": " .. options.Value
                ToggleDropdown()
                options.Callback(options.Value)
            end)
        end
    end
    BuildOptions()

    local Element = {Instance = DropdownFrame, Options = options}
    RegisteredElements[options.Name] = Element

    function Element:Set(newOptions)
        newOptions = newOptions or {}
        if newOptions.Name then options.Name = newOptions.Name end
        if newOptions.Options then options.Options = newOptions.Options; BuildOptions() end
        if newOptions.Value then options.Value = newOptions.Value; options.Callback(options.Value) end
        Label.Text = options.Name .. ": " .. tostring(options.Value)
        if newOptions.Callback then options.Callback = newOptions.Callback end
    end
    function Element:Delete()
        conn:Disconnect()
        RegisteredElements[options.Name] = nil
        DropdownFrame:Destroy()
        UpdateContainerSize()
    end
    return Element
end

-- 7. AddLabelBox
function Library:AddLabelBox(options)
    options = options or {}
    options.Name = options.Name or "Information"
    options.Description = options.Description or ""

    local Frame = Instance.new("Frame")
    Frame.Name = "LabelBox_" .. options.Name
    Frame.Size = UDim2.new(1, 0, 0, 50)
    Frame.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    Frame.Parent = Container

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = Frame

    local TitleText = Instance.new("TextLabel")
    TitleText.Name = "Title"
    TitleText.Size = UDim2.new(1, -20, 0, 18)
    TitleText.Position = UDim2.new(0, 10, 0, 6)
    TitleText.BackgroundTransparency = 1
    TitleText.Text = options.Name
    TitleText.Font = Enum.Font.GothamBold
    TitleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleText.TextXAlignment = Enum.TextXAlignment.Left
    TitleText.Parent = Frame
    ApplyTextScaling(TitleText, 8, 12)

    local DescText = Instance.new("TextLabel")
    DescText.Name = "Description"
    DescText.Size = UDim2.new(1, -20, 0, 22)
    DescText.Position = UDim2.new(0, 10, 0, 24)
    DescText.BackgroundTransparency = 1
    DescText.Text = options.Description
    DescText.Font = Enum.Font.Gotham
    DescText.TextColor3 = Color3.fromRGB(160, 160, 170)
    DescText.TextXAlignment = Enum.TextXAlignment.Left
    DescText.TextWrapped = true
    DescText.Parent = Frame
    ApplyTextScaling(DescText, 8, 10)

    local Element = {Instance = Frame}
    function Element:Set(newOptions)
        newOptions = newOptions or {}
        if newOptions.Name then options.Name = newOptions.Name; TitleText.Text = newOptions.Name end
        if newOptions.Description then options.Description = newOptions.Description; DescText.Text = newOptions.Description end
    end
    function Element:Delete()
        Frame:Destroy()
        UpdateContainerSize()
    end
    return Element
end

-- 8. AddCreditButton
function Library:AddCreditButton(options)
    if #creditButtons >= MAX_CREDIT_BUTTONS then return nil end
    options = options or {}
    options.Image = options.Image or options.Value or ""
    options.Callback = options.Callback or function() end

    local count = #creditButtons + 1
    options.Name = "CreditBtn_" .. tostring(count)

    local CreditBtn = Instance.new("ImageButton")
    CreditBtn.Name = options.Name
    CreditBtn.Size = UDim2.new(0, 24, 0, 24)
    CreditBtn.Position = UDim2.new(1, -35 - (count * 28), 0, 8)
    CreditBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
    CreditBtn.Image = typeof(options.Image) == "number" and ("rbxassetid://" .. tostring(options.Image)) or options.Image
    CreditBtn.ScaleType = Enum.ScaleType.Fit
    CreditBtn.Parent = MainFrame

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = CreditBtn

    local conn = CreditBtn.MouseButton1Click:Connect(function() options.Callback() end)
    table.insert(creditButtons, CreditBtn)

    local Element = {Instance = CreditBtn}
    function Element:Set(newOptions)
        newOptions = newOptions or {}
        if newOptions.Image then 
            options.Image = newOptions.Image
            CreditBtn.Image = typeof(options.Image) == "number" and ("rbxassetid://" .. tostring(options.Image)) or options.Image 
        end
        if newOptions.Callback then options.Callback = newOptions.Callback end
    end
    function Element:Delete()
        conn:Disconnect()
        local idx = table.find(creditButtons, CreditBtn)
        if idx then table.remove(creditButtons, idx) end
        CreditBtn:Destroy()
        for i, btn in ipairs(creditButtons) do btn.Position = UDim2.new(1, -35 - (i * 28), 0, 8) end
    end
    return Element
end

-- 9. SendNotification
function Library:SendNotification(options)
    options = options or {}
    options.Title = options.Title or options.Name or "Notification"
    options.Message = options.Message or options.Description or ""
    options.Duration = options.Duration or 5

    local NotifFrame = Instance.new("Frame")
    NotifFrame.Name = "Notification_" .. options.Title
    NotifFrame.Size = UDim2.new(1, 0, 0, 52)
    NotifFrame.BackgroundColor3 = Color3.fromRGB(28, 28, 35)
    NotifFrame.BackgroundTransparency = 1
    NotifFrame.Parent = NotificationHolder

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = NotifFrame

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(0, 170, 255)
    Stroke.Thickness = 1
    Stroke.Transparency = 1
    Stroke.Parent = NotifFrame

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "Title"
    TitleLabel.Size = UDim2.new(1, -16, 0, 18)
    TitleLabel.Position = UDim2.new(0, 10, 0, 6)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = options.Title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.TextTransparency = 1
    TitleLabel.Parent = NotifFrame
    ApplyTextScaling(TitleLabel, 8, 12)

    local MsgLabel = Instance.new("TextLabel")
    MsgLabel.Name = "Message"
    MsgLabel.Size = UDim2.new(1, -16, 0, 20)
    MsgLabel.Position = UDim2.new(0, 10, 0, 24)
    MsgLabel.BackgroundTransparency = 1
    MsgLabel.Text = options.Message
    MsgLabel.Font = Enum.Font.Gotham
    MsgLabel.TextColor3 = Color3.fromRGB(180, 180, 190)
    MsgLabel.TextXAlignment = Enum.TextXAlignment.Left
    MsgLabel.TextWrapped = true
    MsgLabel.TextTransparency = 1
    MsgLabel.Parent = NotifFrame
    ApplyTextScaling(MsgLabel, 8, 10)

    TweenService:Create(NotifFrame, TweenInfo.new(0.25), {BackgroundTransparency = 0}):Play()
    TweenService:Create(Stroke, TweenInfo.new(0.25), {Transparency = 0.6}):Play()
    TweenService:Create(TitleLabel, TweenInfo.new(0.25), {TextTransparency = 0}):Play()
    TweenService:Create(MsgLabel, TweenInfo.new(0.25), {TextTransparency = 0}):Play()

    local dismissThread = task.delay(options.Duration, function()
        if NotifFrame and NotifFrame.Parent then
            TweenService:Create(NotifFrame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play()
            TweenService:Create(Stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
            TweenService:Create(TitleLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            TweenService:Create(MsgLabel, TweenInfo.new(0.3), {TextTransparency = 1}):Play()
            task.wait(0.3)
            NotifFrame:Destroy()
        end
    end)

    local Element = {Instance = NotifFrame}
    function Element:Delete()
        if dismissThread then task.cancel(dismissThread) end
        if NotifFrame then NotifFrame:Destroy() end
    end
    return Element
end

return Library
