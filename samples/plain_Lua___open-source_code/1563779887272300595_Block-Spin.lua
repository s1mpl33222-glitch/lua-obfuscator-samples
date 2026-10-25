-- BLOCK SPIN CHRISS DEV SERVICIOS
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local CoreGui = game:GetService("CoreGui")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer


local Character = LocalPlayer.Character
if not Character then
    LocalPlayer.CharacterAdded:Wait()
    Character = LocalPlayer.Character
end

LocalPlayer.CharacterAdded:Connect(function(newChar)
    Character = newChar
end)

local Camera = workspace.CurrentCamera

-- FOV CIRCLE (GUI)
local fovGui = Instance.new("ScreenGui")
local fovFrame = Instance.new("Frame")
local fovCorner = Instance.new("UICorner")
local fovStroke = Instance.new("UIStroke")

fovGui.Name = "ChrissFov"
fovGui.ResetOnSpawn = false

pcall(function() fovGui.Parent = game:GetService("CoreGui") end)
if not fovGui.Parent then
    fovGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
end

fovFrame.Name = "FovCircle"
fovFrame.Parent = fovGui
fovFrame.BackgroundTransparency = 1
fovFrame.AnchorPoint = Vector2.new(0.5, 0.5)
fovFrame.Position = UDim2.new(0.5, 0, 0.5, 0) 
fovFrame.Size = UDim2.fromOffset(200, 200)
fovFrame.Visible = false

fovCorner.CornerRadius = UDim.new(1, 0)
fovCorner.Parent = fovFrame

fovStroke.Parent = fovFrame
fovStroke.Thickness = 1.5
fovStroke.Color = Color3.fromRGB(255, 255, 255)

local Config = {
    -- Cheats
    SpeedValue = 16, 
    SpeedEnabled = false, 
    SpinBot = false,      
    SpinSpeed = 30,       
    HideName = false,     
    
    -- Combat
    AimbotEnabled = false,
    silentAimEnabled = false,
    FOVEnabled = false, 
    FOVRadius = 100,
    WallCheck = true,
    TargetPart = "HumanoidRootPart",
    NoRecoil = false, --  NUEVO
    
    -- Visuals
    Fullbright = false,
    ESPBox = false, 
    ESPName = false, 
    ESPDist = false, 
    ESPHealth = false, 
    Traces = false,
    ESPGun = false, 
    ESPGunDist = false,
    DroppedItemESP = false, 
    
    -- Supervivencia y Automatización 
    AutoBlood = false,
    AutoSkipCrate = false,
    AutoMinigame = false,
    AutoPickup = false,
    
    -- Misc
    LockUI = false
}


-- TEMAS
local Theme = {
    Main = Color3.fromRGB(160, 80, 255), 
    Combat = Color3.fromRGB(160, 80, 255),
    Visuals = Color3.fromRGB(160, 80, 255),
    Misc = Color3.fromRGB(160, 80, 255)
}
 
-- UI DRAG
local function MakeSmoothDrag(frame, dragHandle)
    local dragging = false
    local dragInput, dragStart, startPos
    local targetPos = frame.Position

    dragHandle.InputBegan:Connect(function(input)
        if Config.LockUI then return end 

        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = frame.Position
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    dragHandle.InputChanged:Connect(function(input)
        if not Config.LockUI and dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            dragInput = input
        end
    end)

    RunService.RenderStepped:Connect(function()
        if dragging and dragInput and not Config.LockUI then
            local delta = dragInput.Position - dragStart
            targetPos = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
        frame.Position = frame.Position:Lerp(targetPos, 0.15)
    end)
end

-- MAIN GUI
local ScreenGui;
local success, err = pcall(function()
    ScreenGui = game:GetService("CoreGui"):FindFirstChild("RobloxGui"):FindFirstChild("Modules") 
        and Instance.new("ScreenGui", game:GetService("CoreGui"):FindFirstChild("RobloxGui"))
        or Instance.new("ScreenGui", game:GetService("CoreGui"))
end)
if not success or not ScreenGui then
    ScreenGui = Instance.new("ScreenGui", LocalPlayer:WaitForChild("PlayerGui"))
end
ScreenGui.Name = "ViceCityV2"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

-- VARIABLES DE ESTADO MENU
local Pages = {}
local TabButtons = {}
local isTweening = false
local ActivePage = "Main" -- Guarda la última pestaña abierta

-- MENU PRINCIPAL DISEÑO 
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 10, 0, 10) 
MainFrame.Position = UDim2.new(0.5, -230, 0.5, -135)
MainFrame.BackgroundColor3 = Color3.fromRGB(14, 15, 18)
MainFrame.BackgroundTransparency = 1
MainFrame.BorderSizePixel = 0
MainFrame.ClipsDescendants = true 
MainFrame.Visible = false 
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Theme.Main
MainStroke.Thickness = 1.6
MainStroke.Transparency = 1 
MainStroke.Parent = MainFrame

-- TOP BAR
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, 0, 0, 42)
TopBar.BackgroundColor3 = Color3.fromRGB(20, 22, 26)
TopBar.BorderSizePixel = 0
TopBar.Parent = MainFrame

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 14)
TopCorner.Parent = TopBar

local TopFix = Instance.new("Frame")
TopFix.Size = UDim2.new(1, 0, 0, 12)
TopFix.Position = UDim2.new(0, 0, 1, -12)
TopFix.BackgroundColor3 = Color3.fromRGB(20, 22, 26)
TopFix.BorderSizePixel = 0
TopFix.Parent = TopBar

-- TITULO ANIMADO (PREMIUM)
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, -50, 1, 0)
Title.Position = UDim2.new(0, 16, 0, 0)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 13.5
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.BackgroundTransparency = 1
Title.RichText = true
Title.Parent = TopBar

-- LOGICA TITULO MULTICOLOR
RunService.RenderStepped:Connect(function()
    local t = tick() * 3
    
    -- Efecto Dorado Brillante 
    local goldG = math.floor(215 + math.sin(t) * 40)
    local goldHex = string.format("#FF%02X00", goldG)
    
    -- Efecto Morado suave 
    local bcR = math.floor(160 + math.sin(t * 0.5) * 20)
    local bcG = math.floor(80 + math.sin(t * 0.5) * 20)
    local bcHex = string.format("#%02X%02XFF", bcR, bcG)

    Title.Text = string.format('<b><font color="%s">BLOCK SPIN</font> <font color="%s">PREMIUN</font></b>', bcHex, goldHex)
end)

-- CLOSE BOTON
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 32, 0, 32)
CloseBtn.Position = UDim2.new(1, -38, 0, 5)
CloseBtn.Text = "×" 
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 24
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Parent = TopBar

MakeSmoothDrag(MainFrame, TopBar)

-- TAB PANEL
local TabPanel = Instance.new("Frame")
TabPanel.Size = UDim2.new(0, 110, 1, -42)
TabPanel.Position = UDim2.new(0, 0, 0, 42)
TabPanel.BackgroundColor3 = Color3.fromRGB(17, 18, 22)
TabPanel.BorderSizePixel = 0
TabPanel.Parent = MainFrame

local TabCorner = Instance.new("UICorner")
TabCorner.CornerRadius = UDim.new(0, 14)
TabCorner.Parent = TabPanel

local TabFixLeft = Instance.new("Frame")
TabFixLeft.Size = UDim2.new(1, 0, 0, 15)
TabFixLeft.Position = UDim2.new(0, 0, 0, 0)
TabFixLeft.BackgroundColor3 = Color3.fromRGB(17, 18, 22)
TabFixLeft.BorderSizePixel = 0
TabFixLeft.ZIndex = 2
TabFixLeft.Parent = TabPanel

local TabList = Instance.new("UIListLayout")
TabList.Padding = UDim.new(0, 4)
TabList.Parent = TabPanel

local TabPadding = Instance.new("UIPadding")
TabPadding.PaddingTop = UDim.new(0, 10)
TabPadding.Parent = TabPanel

local PageContainer = Instance.new("Frame")
PageContainer.Size = UDim2.new(1, -110, 1, -42)
PageContainer.Position = UDim2.new(0, 110, 0, 42)
PageContainer.BackgroundTransparency = 1
PageContainer.Parent = MainFrame

-- BOTON FLOTANTE
local OpenBtnFrame = Instance.new("Frame")
OpenBtnFrame.Name = "OpenBtnFrame"
OpenBtnFrame.Size = UDim2.new(0, 56, 0, 56) 
OpenBtnFrame.Position = UDim2.new(0.03, 0, 0.5, -28) 
OpenBtnFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 26)
OpenBtnFrame.Visible = true -- ARRANCA VISIBLE
OpenBtnFrame.ClipsDescendants = true
OpenBtnFrame.Parent = ScreenGui

local OpenBtnCorner = Instance.new("UICorner")
OpenBtnCorner.CornerRadius = UDim.new(1, 0)
OpenBtnCorner.Parent = OpenBtnFrame

local OpenStroke = Instance.new("UIStroke")
OpenStroke.Color = Theme.Main
OpenStroke.Thickness = 1.8
OpenStroke.Parent = OpenBtnFrame

local OpenBtn = Instance.new("ImageButton")
OpenBtn.Name = "OpenButton"
OpenBtn.Size = UDim2.new(1, -6, 1, -6)
OpenBtn.Position = UDim2.new(0, 3, 0, 3)
OpenBtn.Image = "rbxassetid://122763495406604"
OpenBtn.BackgroundTransparency = 1
OpenBtn.AutoButtonColor = true
OpenBtn.Active = true
OpenBtn.Parent = OpenBtnFrame

local ImageCorner = Instance.new("UICorner")
ImageCorner.CornerRadius = UDim.new(1, 0)
ImageCorner.Parent = OpenBtn

MakeSmoothDrag(OpenBtnFrame, OpenBtn)

RunService.RenderStepped:Connect(function(dt)
    if OpenBtnFrame.Visible then
        OpenBtn.Rotation = OpenBtn.Rotation + (dt * 120)
    end
end)

-- LOGICA CERRAR MENU
CloseBtn.MouseButton1Click:Connect(function()
    if isTweening then return end
    isTweening = true
    
    local closeInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    
    local mainClose = TweenService:Create(MainFrame, closeInfo, {
        Size = UDim2.new(0, 430, 0, 250),
        BackgroundTransparency = 1
    })
    
    local strokeClose = TweenService:Create(MainStroke, closeInfo, {
        Transparency = 1
    })
    
    pcall(function()
        TweenService:Create(TopBar, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
        TweenService:Create(Title, TweenInfo.new(0.15), {TextTransparency = 1}):Play()
        TweenService:Create(CloseBtn, TweenInfo.new(0.15), {TextTransparency = 1}):Play()
        TweenService:Create(TabPanel, TweenInfo.new(0.15), {BackgroundTransparency = 1}):Play()
        
        
        for _, btn in pairs(TabButtons) do
            TweenService:Create(btn, TweenInfo.new(0.15), {TextTransparency = 1}):Play()
        end
    end)
    
    mainClose:Play()
    strokeClose:Play()
    
    mainClose.Completed:Connect(function()
        MainFrame.Visible = false
        for _, p in pairs(Pages) do p.Visible = false end -- Apagamos para resetear estado visual
        
        OpenBtnFrame.Visible = true
        OpenBtnFrame.Size = UDim2.new(0, 56, 0, 56)
        OpenBtn.Size = UDim2.new(0, 0, 0, 0)
        
        local openAnim = TweenService:Create(OpenBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Size = UDim2.new(1, -6, 1, -6)
        })
        openAnim:Play()
        openAnim.Completed:Connect(function() isTweening = false end)
    end)
end)

-- LOGICA ABRIR MENU
OpenBtn.MouseButton1Click:Connect(function()
    if isTweening then return end
    isTweening = true
    
    local hideTween = TweenService:Create(OpenBtn, TweenInfo.new(0.2, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0)
    })
    hideTween:Play()
    
    hideTween.Completed:Connect(function()
        OpenBtnFrame.Visible = false
        
        MainFrame.BackgroundTransparency = 0
        MainStroke.Transparency = 0
        pcall(function()
            TopBar.BackgroundTransparency = 0
            Title.TextTransparency = 0
            CloseBtn.TextTransparency = 0
            TabPanel.BackgroundTransparency = 0
            for _, btn in pairs(TabButtons) do
                TweenService:Create(btn, TweenInfo.new(0.1), {TextTransparency = 0}):Play()
            end
        end)
        
    
        if Pages[ActivePage] then
            Pages[ActivePage].Visible = true
        end
        
        MainFrame.Size = UDim2.new(0, 10, 0, 10) 
        MainFrame.BackgroundTransparency = 1
        MainStroke.Transparency = 1
        MainFrame.Visible = true
        
        local openInfo = TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        
        local mainOpen = TweenService:Create(MainFrame, openInfo, {
            Size = UDim2.new(0, 460, 0, 270),
            BackgroundTransparency = 0
        })
        
        local strokeOpen = TweenService:Create(MainStroke, openInfo, {
            Transparency = 0
        })
        
        mainOpen:Play()
        strokeOpen:Play()
        mainOpen.Completed:Connect(function() isTweening = false end)
    end)
end)

-- UI TABS
local function CreateTab(name, sectionColor)
    local TabBtn = Instance.new("TextButton")
    TabBtn.Size = UDim2.new(1, 0, 0, 32)
    TabBtn.Text = name:upper()
    TabBtn.Font = Enum.Font.GothamBold
    TabBtn.TextSize = 11
    TabBtn.TextColor3 = Color3.fromRGB(100, 105, 115)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Parent = TabPanel

    local Page = Instance.new("ScrollingFrame")
    Page.Size = UDim2.new(1, 0, 1, 0)
    Page.BackgroundTransparency = 1
    Page.Visible = false
    Page.CanvasSize = UDim2.new(0, 0, 0, 0)
    Page.ScrollBarThickness = 3
    Page.ScrollBarImageColor3 = sectionColor
    Page.Parent = PageContainer

    local PageList = Instance.new("UIListLayout")
    PageList.Padding = UDim.new(0, 6)
    PageList.HorizontalAlignment = Enum.HorizontalAlignment.Center
    PageList.SortOrder = Enum.SortOrder.LayoutOrder
    PageList.Parent = Page

    local PagePad = Instance.new("UIPadding")
    PagePad.PaddingTop = UDim.new(0, 10)
    PagePad.PaddingBottom = UDim.new(0, 10)
    PagePad.Parent = Page
    
    PageList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Page.CanvasSize = UDim2.new(0, 0, 0, PageList.AbsoluteContentSize.Y + 20)
    end)

    TabBtn.MouseButton1Click:Connect(function()
        ActivePage = name -- Guarda tu posición actual
        for n, p in pairs(Pages) do p.Visible = false end
        for btnName, btnObj in pairs(TabButtons) do 
            TweenService:Create(btnObj, TweenInfo.new(0.2), {TextColor3 = Color3.fromRGB(100, 105, 115)}):Play()
        end
        Page.Visible = true
        TweenService:Create(MainStroke, TweenInfo.new(0.25), {Color = sectionColor}):Play()
        TweenService:Create(TabBtn, TweenInfo.new(0.2), {TextColor3 = sectionColor}):Play()
    end)

    Pages[name] = Page
    TabButtons[name] = TabBtn
    return Page
end

-- UI TOGGLE
local function AddToggle(page, text, configKey, sectionColor)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(0.92, 0, 0, 38)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 26)
    ToggleFrame.BorderSizePixel = 0
    ToggleFrame.Parent = page

    local tc = Instance.new("UICorner")
    tc.CornerRadius = UDim.new(0, 6)
    tc.Parent = ToggleFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.7, 0, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12.5
    Label.TextColor3 = Color3.fromRGB(220, 225, 235)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = ToggleFrame

    local OuterSwitch = Instance.new("TextButton")
    OuterSwitch.Size = UDim2.new(0, 38, 0, 20)
    OuterSwitch.Position = UDim2.new(1, -50, 0.5, -10)
    OuterSwitch.BackgroundColor3 = Config[configKey] and sectionColor or Color3.fromRGB(45, 48, 58)
    OuterSwitch.Text = ""
    OuterSwitch.Parent = ToggleFrame
    
    local osc = Instance.new("UICorner")
    osc.CornerRadius = UDim.new(1, 0)
    osc.Parent = OuterSwitch

    local InnerCircle = Instance.new("Frame")
    InnerCircle.Size = UDim2.new(0, 14, 0, 14)
    InnerCircle.Position = Config[configKey] and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
    InnerCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    InnerCircle.BorderSizePixel = 0
    InnerCircle.Parent = OuterSwitch

    local icc = Instance.new("UICorner")
    icc.CornerRadius = UDim.new(1, 0)
    icc.Parent = InnerCircle

    OuterSwitch.MouseButton1Click:Connect(function()
        Config[configKey] = not Config[configKey]
        TweenService:Create(OuterSwitch, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {BackgroundColor3 = Config[configKey] and sectionColor or Color3.fromRGB(45, 48, 58)}):Play()
        TweenService:Create(InnerCircle, TweenInfo.new(0.25, Enum.EasingStyle.Back), {Position = Config[configKey] and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)}):Play()
    end)
end

-- UI SLIDER
local function AddSlider(page, text, min, max, default, configKey, sectionColor)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Size = UDim2.new(0.92, 0, 0, 48)
    SliderFrame.BackgroundColor3 = Color3.fromRGB(20, 22, 26)
    SliderFrame.BorderSizePixel = 0
    SliderFrame.Parent = page
    
    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(0, 6)
    sc.Parent = SliderFrame

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.6, 0, 0, 22)
    Label.Position = UDim2.new(0, 12, 0, 4)
    Label.Text = text
    Label.Font = Enum.Font.Gotham
    Label.TextSize = 12
    Label.TextColor3 = Color3.fromRGB(220, 225, 235)
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.BackgroundTransparency = 1
    Label.Parent = SliderFrame

    local ValLabel = Instance.new("TextLabel")
    ValLabel.Size = UDim2.new(0.3, 0, 0, 22)
    ValLabel.Position = UDim2.new(1, -48, 0, 4)
    ValLabel.Text = tostring(default)
    ValLabel.Font = Enum.Font.GothamBold
    ValLabel.TextSize = 12
    ValLabel.TextColor3 = sectionColor
    ValLabel.TextXAlignment = Enum.TextXAlignment.Right
    ValLabel.BackgroundTransparency = 1
    ValLabel.Parent = SliderFrame

    local SlideBar = Instance.new("TextButton")
    SlideBar.Size = UDim2.new(1, -24, 0, 5)
    SlideBar.Position = UDim2.new(0, 12, 0.72, -2)
    SlideBar.BackgroundColor3 = Color3.fromRGB(45, 48, 58)
    SlideBar.Text = ""
    SlideBar.Parent = SliderFrame
    
    local sbc = Instance.new("UICorner")
    sbc.CornerRadius = UDim.new(1, 0)
    sbc.Parent = SlideBar

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default - min)/(max - min), 0, 1, 0)
    Fill.BackgroundColor3 = sectionColor
    Fill.BorderSizePixel = 0
    Fill.Parent = SlideBar
    
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(1, 0)
    fc.Parent = Fill

    local function UpdateSlider(input)
        local percentage = math.clamp((input.Position.X - SlideBar.AbsolutePosition.X) / SlideBar.AbsoluteSize.X, 0, 1)
        TweenService:Create(Fill, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {Size = UDim2.new(percentage, 0, 1, 0)}):Play()
        local value = math.floor(min + (percentage * (max - min)))
        ValLabel.Text = tostring(value)
        Config[configKey] = value
    end

    local sliding = false
    SlideBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = true
            UpdateSlider(input)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if sliding and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            UpdateSlider(input)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            sliding = false
        end
    end)
end

-- UI BUTTON
local function AddButton(page, text, sectionColor)
    local Button = Instance.new("TextButton")
    Button.Size = UDim2.new(0.92, 0, 0, 36)
    Button.BackgroundColor3 = Color3.fromRGB(24, 27, 34)
    Button.Text = text
    Button.Font = Enum.Font.GothamBold
    Button.TextSize = 12
    Button.TextColor3 = sectionColor
    Button.Parent = page
    
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 6)
    bc.Parent = Button
    
    Button.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(34, 38, 48)}):Play()
        end
    end)
    Button.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            TweenService:Create(Button, TweenInfo.new(0.1), {BackgroundColor3 = Color3.fromRGB(24, 27, 34)}):Play()
        end
    end)
return Button
end


-- CREACION CATEGORIAS
local TabMain = CreateTab("Main", Theme.Main)
local TabCheats = CreateTab("Player Cheats", Theme.Main) 
local TabCombat = CreateTab("Combat", Theme.Combat)
local TabVisuals = CreateTab("Visuals", Theme.Visuals)
local TabMisc = CreateTab("Misc", Theme.Misc)

-- SELECCIONAR MAIN POR DEFECTO PARA EL INICIO (PERO OCULTO)
if TabButtons["Main"] then TabButtons["Main"].TextColor3 = Theme.Main end

-- MAIN PERFIL
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Stats = game:GetService("Stats")

local ProfileCard = Instance.new("Frame")
ProfileCard.Size = UDim2.new(0.94, 0, 0, 70)
ProfileCard.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
ProfileCard.BorderSizePixel = 0
ProfileCard.Parent = TabMain

local pc_corner = Instance.new("UICorner")
pc_corner.CornerRadius = UDim.new(0, 10)
pc_corner.Parent = ProfileCard

local pc_stroke = Instance.new("UIStroke")
pc_stroke.Color = Color3.fromRGB(45, 50, 62)
pc_stroke.Thickness = 1.2
pc_stroke.Parent = ProfileCard

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(0, 48, 0, 48)
AvatarImage.Position = UDim2.new(0, 12, 0, 11)
AvatarImage.BackgroundColor3 = Color3.fromRGB(28, 31, 38)
AvatarImage.Parent = ProfileCard

local avatar_corner = Instance.new("UICorner")
avatar_corner.CornerRadius = UDim.new(1, 0)
avatar_corner.Parent = AvatarImage

task.spawn(function()
    local content, isReady = Players:GetUserThumbnailAsync(
        LocalPlayer.UserId, 
        Enum.ThumbnailType.HeadShot, 
        Enum.ThumbnailSize.Size100x100
    )
    if isReady then AvatarImage.Image = content end
end)

local UserNameLabel = Instance.new("TextLabel")
UserNameLabel.Size = UDim2.new(1, -75, 0, 20)
UserNameLabel.Position = UDim2.new(0, 68, 0, 15)
UserNameLabel.Text = "@" .. LocalPlayer.Name
UserNameLabel.Font = Enum.Font.GothamBold
UserNameLabel.TextSize = 13
UserNameLabel.TextColor3 = Theme.Main
UserNameLabel.TextXAlignment = Enum.TextXAlignment.Left
UserNameLabel.BackgroundTransparency = 1
UserNameLabel.Parent = ProfileCard

local AccountAgeLabel = Instance.new("TextLabel")
AccountAgeLabel.Size = UDim2.new(1, -75, 0, 18)
AccountAgeLabel.Position = UDim2.new(0, 68, 0, 35)
AccountAgeLabel.Text = "📅 Cuenta: " .. tostring(LocalPlayer.AccountAge) .. " días"
AccountAgeLabel.Font = Enum.Font.Gotham
AccountAgeLabel.TextSize = 11
AccountAgeLabel.TextColor3 = Color3.fromRGB(170, 175, 185)
AccountAgeLabel.TextXAlignment = Enum.TextXAlignment.Left
AccountAgeLabel.BackgroundTransparency = 1
AccountAgeLabel.Parent = ProfileCard

-- MAIN RENDIMIENTO
local PerfCard = Instance.new("Frame")
PerfCard.Size = UDim2.new(0.94, 0, 0, 60)
PerfCard.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
PerfCard.BorderSizePixel = 0
PerfCard.Parent = TabMain

local perf_corner = Instance.new("UICorner")
perf_corner.CornerRadius = UDim.new(0, 10)
perf_corner.Parent = PerfCard

local perf_stroke = Instance.new("UIStroke")
perf_stroke.Color = Color3.fromRGB(45, 50, 62)
perf_stroke.Thickness = 1.2
perf_stroke.Parent = PerfCard

local PerfTitle = Instance.new("TextLabel")
PerfTitle.Size = UDim2.new(1, -20, 0, 18)
PerfTitle.Position = UDim2.new(0, 12, 0, 8)
PerfTitle.Text = "ESTADO Y RENDIMIENTO ⚡"
PerfTitle.Font = Enum.Font.GothamBold
PerfTitle.TextSize = 11
PerfTitle.TextColor3 = Color3.fromRGB(220, 225, 235)
PerfTitle.TextXAlignment = Enum.TextXAlignment.Left
PerfTitle.BackgroundTransparency = 1
PerfTitle.Parent = PerfCard

local StatsLabel = Instance.new("TextLabel")
StatsLabel.Size = UDim2.new(1, -20, 0, 22)
StatsLabel.Position = UDim2.new(0, 12, 0, 28)
StatsLabel.Text = "FPS: -- | Ping: -- ms | Status: 🟢 ACTIVO"
StatsLabel.Font = Enum.Font.Gotham
StatsLabel.TextSize = 11
StatsLabel.TextColor3 = Color3.fromRGB(50, 255, 140)
StatsLabel.TextXAlignment = Enum.TextXAlignment.Left
StatsLabel.BackgroundTransparency = 1
StatsLabel.Parent = PerfCard

local lastUpdate = tick()
local frameCount = 0
RunService.RenderStepped:Connect(function()
    frameCount = frameCount + 1
    if tick() - lastUpdate >= 1 then
        local fps = frameCount
        frameCount = 0
        lastUpdate = tick()
        local ping = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue())
        StatsLabel.Text = "FPS: " .. tostring(fps) .. "  |  Ping: " .. tostring(ping) .. "ms  |  Status: 🟢 ACTIVO"
    end
end)

-- MAIN SOCIALES
local SocialCard = Instance.new("Frame")
SocialCard.Size = UDim2.new(0.94, 0, 0, 110)
SocialCard.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
SocialCard.BorderSizePixel = 0
SocialCard.Parent = TabMain

local sc_corner = Instance.new("UICorner")
sc_corner.CornerRadius = UDim.new(0, 10)
sc_corner.Parent = SocialCard

local sc_stroke = Instance.new("UIStroke")
sc_stroke.Color = Color3.fromRGB(45, 50, 62)
sc_stroke.Thickness = 1.2
sc_stroke.Parent = SocialCard

local SocialTitle = Instance.new("TextLabel")
SocialTitle.Size = UDim2.new(1, -20, 0, 20)
SocialTitle.Position = UDim2.new(0, 12, 0, 8)
SocialTitle.Text = "REDES OFICIALES 🌐"
SocialTitle.Font = Enum.Font.GothamBold
SocialTitle.TextSize = 11
SocialTitle.TextColor3 = Color3.fromRGB(220, 225, 235)
SocialTitle.TextXAlignment = Enum.TextXAlignment.Left
SocialTitle.BackgroundTransparency = 1
SocialTitle.Parent = SocialCard

local WhatsAppBtn = Instance.new("TextButton")
WhatsAppBtn.Size = UDim2.new(1, -24, 0, 32)
WhatsAppBtn.Position = UDim2.new(0, 12, 0, 32)
WhatsAppBtn.BackgroundColor3 = Color3.fromRGB(26, 30, 38)
WhatsAppBtn.Text = "📲 CANAL DE WHATSAPP (COPIAR)"
WhatsAppBtn.Font = Enum.Font.GothamBold
WhatsAppBtn.TextSize = 10.5
WhatsAppBtn.TextColor3 = Theme.Main
WhatsAppBtn.Parent = SocialCard

local wbc = Instance.new("UICorner")
wbc.CornerRadius = UDim.new(0, 6)
wbc.Parent = WhatsAppBtn

WhatsAppBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/sjArbp5b85")
    WhatsAppBtn.Text = "¡LINK COPIADO! ✅"
    task.wait(2)
    WhatsAppBtn.Text = "📲 CANAL DE WHATSAPP (COPIAR)"
end)

local TikTokBtn = Instance.new("TextButton")
TikTokBtn.Size = UDim2.new(1, -24, 0, 32)
TikTokBtn.Position = UDim2.new(0, 12, 0, 68)
TikTokBtn.BackgroundColor3 = Color3.fromRGB(26, 30, 38)
TikTokBtn.Text = "🎵 TIKTOK OFICIAL (COPIAR)"
TikTokBtn.Font = Enum.Font.GothamBold
TikTokBtn.TextSize = 10.5
TikTokBtn.TextColor3 = Theme.Main
TikTokBtn.Parent = SocialCard

local tkc = Instance.new("UICorner")
tkc.CornerRadius = UDim.new(0, 6)
tkc.Parent = TikTokBtn

TikTokBtn.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/sjArbp5b85")
    TikTokBtn.Text = "¡USUARIO COPIADO! ✅"
    task.wait(2)
    TikTokBtn.Text = "🎵 TIKTOK OFICIAL (COPIAR)"
end)

-- MAIN NOVEDADES
local NewsCard = Instance.new("Frame")
NewsCard.Size = UDim2.new(0.94, 0, 0, 75)
NewsCard.BackgroundColor3 = Color3.fromRGB(18, 20, 24)
NewsCard.BorderSizePixel = 0
NewsCard.Parent = TabMain

local news_corner = Instance.new("UICorner")
news_corner.CornerRadius = UDim.new(0, 10)
news_corner.Parent = NewsCard

local news_stroke = Instance.new("UIStroke")
news_stroke.Color = Color3.fromRGB(45, 50, 62)
news_stroke.Thickness = 1.2
news_stroke.Parent = NewsCard

local NewsTitle = Instance.new("TextLabel")
NewsTitle.Size = UDim2.new(1, -20, 0, 18)
NewsTitle.Position = UDim2.new(0, 12, 0, 8)
NewsTitle.Text = "NOVEDADES V1.0📢"
NewsTitle.Font = Enum.Font.GothamBold
NewsTitle.TextSize = 11
NewsTitle.TextColor3 = Color3.fromRGB(220, 225, 235)
NewsTitle.TextXAlignment = Enum.TextXAlignment.Left
NewsTitle.BackgroundTransparency = 1
NewsTitle.Parent = NewsCard

local NewsBody = Instance.new("TextLabel")
NewsBody.Size = UDim2.new(1, -24, 0, 42)
NewsBody.Position = UDim2.new(0, 12, 0, 28)
NewsBody.Text = "• GRACIAS POR USAR CS SOTF AIM\n•SKN ACTUALIZACIÓN \n•XZ"
NewsBody.Font = Enum.Font.Gotham
NewsBody.TextSize = 10
NewsBody.TextColor3 = Color3.fromRGB(160, 165, 175)
NewsBody.TextXAlignment = Enum.TextXAlignment.Left
NewsBody.TextYAlignment = Enum.TextYAlignment.Top
NewsBody.BackgroundTransparency = 1
NewsBody.Parent = NewsCard

-- FUNCIONES CHEATS & AUTOMATIZACIÓN
AddToggle(TabCheats, "Speed Hack", "SpeedEnabled", Theme.Main)
AddSlider(TabCheats, "Speed Power", 16, 300, 16, "SpeedValue", Theme.Main)
AddToggle(TabCheats, "Hide Name", "HideName", Theme.Main)

--  BOTONES DE  AUTOMATIZACIÓN
AddToggle(TabCheats, "Auto Blood Bag", "AutoBlood", Theme.Main)
AddToggle(TabCheats, "Auto Skip Crate ", "AutoSkipCrate", Theme.Main)
AddToggle(TabCheats, "Auto Minigame", "AutoMinigame", Theme.Main)
AddToggle(TabCheats, "Auto Pickup Items", "AutoPickup", Theme.Main)

-- COMBAT
AddToggle(TabCombat, "Aimbot", "AimbotEnabled", Theme.Combat)
AddSlider(TabCombat, "FOV Radio", 30, 300, 100, "FOVRadius", Theme.Combat)
AddToggle(TabCombat, "Show FOV Anillo", "FOVEnabled", Theme.Combat)
AddToggle(TabCombat, "Silent Aim", "silentAimEnabled", Theme.Combat)
AddToggle(TabCombat, "No Recoil", "NoRecoil", Theme.Combat) 


--  LÓGICA DE COMBATE: AIMBOT, FOV Y SILENT AIM 

-- LOGICA WALL CHECK 
local function VerificarParedVisibilidad(objetivoParte)
    if not Config.WallCheck then return true end 
    
    local origen = Camera.CFrame.Position
    local destino = objetivoParte.Position
    local raycastParams = RaycastParams.new()
    
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character, objetivoParte.Parent}

    local resultado = workspace:Raycast(origen, destino - origen, raycastParams)
    return resultado == nil 
end

-- 2. BÚSQUEDA DE OBJETIVO (Apunta solo al Torso/Pecho)
local function ObtenerEnemigoMasCercano()
    local objetivoCercano = nil
    local distanciaMinima = Config.FOVRadius
    local centroPantalla = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, jugador in ipairs(Players:GetPlayers()) do
        if jugador ~= LocalPlayer and jugador.Character and jugador.Character:FindFirstChild("Humanoid") and jugador.Character.Humanoid.Health > 0 then
            
            -- 🔥 OBJETIVO AL PECHO (UpperTorso o Torso)
            local parteObjetivo = jugador.Character:FindFirstChild("UpperTorso") or jugador.Character:FindFirstChild("Torso")
            
            if parteObjetivo then
                local vector2, enPantalla = Camera:WorldToViewportPoint(parteObjetivo.Position)
                
                if enPantalla then
                    local distancia = (Vector2.new(vector2.X, vector2.Y) - centroPantalla).Magnitude
                    
                    if distancia < distanciaMinima and VerificarParedVisibilidad(parteObjetivo) then
                        distanciaMinima = distancia
                        objetivoCercano = parteObjetivo
                        Config.CurrentTarget = jugador -- Guardamos el jugador en Config
                    end
                end
            end
        end
    end
    
    if not objetivoCercano then Config.CurrentTarget = nil end
    return objetivoCercano
end

-- 3 LOGICA FOV & AIMBOT MAIN 
RunService.RenderStepped:Connect(function()
    if not Camera or not workspace.CurrentCamera then
        Camera = workspace.CurrentCamera
        return
    end
    
    if Config.FOVEnabled then
        fovFrame.Visible = true
        fovFrame.Size = UDim2.fromOffset(Config.FOVRadius * 2, Config.FOVRadius * 2)
    else
        fovFrame.Visible = false
    end
    
    if Config.AimbotEnabled or Config.FOVEnabled or Config.SilentAim then
        local objetivo = ObtenerEnemigoMasCercano()
        
        if objetivo then
            fovStroke.Color = Color3.fromRGB(0, 255, 0) -- VERDE
            
            if Config.AimbotEnabled then
                local currentPos = Camera.CFrame.Position
                local targetCFrame = CFrame.new(currentPos, objetivo.Position)
                Camera.CFrame = Camera.CFrame:Lerp(targetCFrame, 1.0)
            end
        else
            fovStroke.Color = Color3.fromRGB(255, 0, 0) -- ROJO
        end
    end
end)





-- SILENT AIMBOT SISTEMA INSANO bórralo agrega el de chino 

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

local aimTarget = nil
local positionHistory = {}
local HISTORY_SIZE = 10
local MAX_JUMP_VEL = 150
local _hookBusy = false



local SendRemote
pcall(function()
    SendRemote = ReplicatedStorage:WaitForChild("Remotes", 5):WaitForChild("Send", 5)
end)

local function getPing()
    local gui   = LocalPlayer:FindFirstChild("PlayerGui")
    local stats = gui and gui:FindFirstChild("NetworkStats")
    local label = stats and stats:FindFirstChild("PingLabel")
    if not label then return 0.2 end
    local num = tonumber(tostring(label.Text):match("%d+"))
    if not num then return 0.2 end
    local ping = num / 1000
    return (ping < 0 or ping > 2) and 0.2 or ping
end

RunService.Heartbeat:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            local hum  = player.Character:FindFirstChild("Humanoid")
            if root and hum and hum.Health > 0 then
                positionHistory[player] = positionHistory[player] or {}
                table.insert(positionHistory[player], { time = os.clock(), pos = root.Position })
                if #positionHistory[player] > HISTORY_SIZE then
                    table.remove(positionHistory[player], 1)
                end
            else
                positionHistory[player] = nil
            end
        end
    end
end)

Players.PlayerRemoving:Connect(function(p) positionHistory[p] = nil end)

local function calcVelocity(player)
    local h = positionHistory[player]
    if not h or #h < 2 then return Vector3.new() end
    local sum, tw = Vector3.new(), 0
    for i = 2, #h do
        local dt = h[i].time - h[i-1].time
        if dt > 0 then
            local raw = (h[i].pos - h[i-1].pos) / dt
            local c = Vector3.new(math.clamp(raw.X,-120,120), math.clamp(raw.Y,-150,150), math.clamp(raw.Z,-120,120))
            sum = sum + c * i; tw = tw + i
        end
    end
    if tw == 0 then return Vector3.new() end
    local avg = sum / tw
    if avg.Y > MAX_JUMP_VEL then return Vector3.new(avg.X*1.15, math.clamp(avg.Y*0.85,0,400), avg.Z*1.15) end
    return avg
end

local function predictPos(part)
    if not part then return Vector3.zero end
    local player   = Players:GetPlayerFromCharacter(part.Parent)
    local velocity = (player and calcVelocity(player)) or Vector3.zero
    local ping     = math.clamp(getPing(), 0.06, 0.35)
    local hSpeed   = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
    local mult = hSpeed>60 and 1.50 or hSpeed>50 and 1.42 or hSpeed>35 and 1.32 or hSpeed>20 and 1.22 or hSpeed>10 and 1.15 or 1.05
    if ping > 0.15 then mult = mult * 0.93 end
    local hor  = Vector3.new(velocity.X,0,velocity.Z) * ping * mult
    local vert = Vector3.new(0, math.clamp(velocity.Y*ping*0.30,-4,4), 0)
    local jb   = Vector3.new(0, velocity.Y>20 and 0.50 or velocity.Y>15 and 0.35 or 0, 0)
    local ho   = part.Name=="HumanoidRootPart" and Vector3.new(0, hSpeed>30 and 0.14 or hSpeed>22 and 0.10 or 0.05, 0) or Vector3.zero
    return part.Position + hor + vert + jb + ho
end

local function isBehindWall(origin, target)
    if not origin or not target then return false end
    local dir = target - origin
    if dir.Magnitude < 1 then return false end
    local result = workspace:Raycast(origin, dir, RaycastParams.new())
    if not result then return false end
    local inst = result.Instance
    local mc = LocalPlayer.Character
    local ac = aimTarget and aimTarget.Character
    return inst and not ((mc and inst:IsDescendantOf(mc)) or (ac and inst:IsDescendantOf(ac)))
end

local function getClosestSA()
    local best, bestDist = nil, fovRadius
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local head = player.Character:FindFirstChild("Head")
            local hum  = player.Character:FindFirstChild("Humanoid")
            local root = player.Character:FindFirstChild("HumanoidRootPart")
            if head and hum and hum.Health > 0 and root then
                local pos, visible = Camera:WorldToViewportPoint(head.Position)
                if visible then
                    local dist = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if dist <= fovRadius and dist < bestDist then
                        bestDist = dist; best = player
                    end
                end
            end
        end
    end
    return best
end


-- Hook
local originalFireServer
task.spawn(function()
    if SendRemote and SendRemote.FireServer then
        pcall(function()
            originalFireServer = hookfunction(SendRemote.FireServer, function(self, ...)
                if self ~= SendRemote or _hookBusy then return originalFireServer(self, ...) end
                _hookBusy = true
                local args = { ... }
                if silentAimEnabled and args[2] == "shoot_gun" and aimTarget then
                    local root = aimTarget.Character and aimTarget.Character:FindFirstChild("HumanoidRootPart")
local hum  = aimTarget.Character and aimTarget.Character:FindFirstChild("Humanoid")
if root and hum then
    local aimPos = predictPos(root)                        local myHead    = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head")
                        local originPos = myHead and myHead.Position or nil
                        local function isShotgun()
                            local char = LocalPlayer.Character
                            if not char then return false end
                            for _, tool in ipairs(char:GetChildren()) do
                                if tool:IsA("Tool") then
                                    local ammo = tool:GetAttribute("AmmoType")
                                    if ammo == "shotgun" or ammo == "shootgun" then return true end
                                end
                            end
                            return false
                        end
                        if isShotgun() then
                            args[4] = CFrame.new(originPos, aimPos)
                            local pellets = {}
                            for i = 1, 6 do
                                local sp = Vector3.new(math.random(-2,2)*0.03, math.random(-2,2)*0.03, math.random(-2,2)*0.03)
                                table.insert(pellets, { [1] = { Instance=root, Normal=Vector3.new(0,1,0), Position=aimPos+sp }})
                            end
                            args[5] = pellets
                        else
                            local wb = isBehindWall(originPos, aimPos)
                            args[4] = wb and CFrame.new(math.huge,math.huge,math.huge) or CFrame.new(originPos, aimPos)
                            args[5] = { [1] = { [1] = { Instance=root, Normal=Vector3.new(0,1,0), Position=aimPos }}}
                        end
                    end
                end
                local res = originalFireServer(self, table.unpack(args))
                _hookBusy = false
                return res
            end)
        end)
    end
end)

-- Actualizar objetivo del Silent Aim
RunService.RenderStepped:Connect(function()
    if silentAimEnabled then
        aimTarget = Config.CurrentTarget
    else
        aimTarget = nil
    end
end)







                


-- VISUALS Y MISC TABS
AddToggle(TabVisuals, "Fullbright ", "Fullbright", Theme.Visuals)
AddToggle(TabVisuals, "ESP Box", "ESPBox", Theme.Visuals)
AddToggle(TabVisuals, "ESP Name", "ESPName", Theme.Visuals)
AddToggle(TabVisuals, "ESP Distancia", "ESPDist", Theme.Visuals)
AddToggle(TabVisuals, "ESP Health", "ESPHealth", Theme.Visuals)
AddToggle(TabVisuals, "Traces", "Traces", Theme.Visuals)
AddToggle(TabVisuals, "ESP Gun", "ESPGun", Theme.Visuals)
AddToggle(TabVisuals, "ESP Gun Distancia", "ESPGunDist", Theme.Visuals)
AddToggle(TabVisuals, "Dropped Items ESP", "DroppedItemESP", Theme.Visuals) --  BOTÓN NUEVO

local BtnServerHop = AddButton(TabMisc, "Server Hop 🌐", Theme.Misc)
local BtnRejoin = AddButton(TabMisc, "Rejoin Server 🔄", Theme.Misc)
AddToggle(TabMisc, "Bloquear Menú🌪️", "LockUI", Theme.Misc)

-- LOGICA SERVER HOP
BtnServerHop.MouseButton1Click:Connect(function()
    BtnServerHop.Text = "Buscando servidor... 🔍"
    local TeleportService = game:GetService("TeleportService")
    local HttpService = game:GetService("HttpService")
    local PlaceId = game.PlaceId
    
    local success, result = pcall(function()
        return HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
    end)
    
    if success and result and result.data then
        local targetServer
        for _, server in ipairs(result.data) do
            if server.playing < server.maxPlayers and server.id ~= game.JobId then
                targetServer = server.id
                break
            end
        end
        
        if targetServer then
            TeleportService:TeleportToPlaceInstance(PlaceId, targetServer, LocalPlayer)
        else
            BtnServerHop.Text = "No hay otros servers ❌"
            task.wait(2)
            BtnServerHop.Text = "Server Hop 🌐"
        end
    else
        BtnServerHop.Text = "Error al buscar ❌"
        task.wait(2)
        BtnServerHop.Text = "Server Hop 🌐"
    end
end)

-- LOGICA REJOIN
BtnRejoin.MouseButton1Click:Connect(function()
    BtnRejoin.Text = "Reconectando... 🔄"
    local TeleportService = game:GetService("TeleportService")
    
    if #Players:GetPlayers() <= 1 then
        TeleportService:Teleport(game.PlaceId, LocalPlayer)
    else
        TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
    end
end)




--  SISTEMA ESP 

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Items = ReplicatedStorage:WaitForChild("Items", 8)
local DroppedItems = workspace:FindFirstChild("DroppedItems")


local RarityColors = {
    Common    = Color3.fromRGB(255, 255, 255),
    Uncommon  = Color3.fromRGB(99, 255, 52),
    Rare      = Color3.fromRGB(51, 170, 255),
    Epic      = Color3.fromRGB(237, 44, 255),
    Legendary = Color3.fromRGB(255, 150, 0),
    Omega     = Color3.fromRGB(255, 20, 51),
}

local WeaponRegistry = {}
local PlayerBillboards = {}
local inventoryWatchers = {}

--  B DATOS de las  IMÁGENES 
local function getItemKey(tool)
    local handle      = tool:FindFirstChild("Handle")
    local displayName = tool:GetAttribute("DisplayName") or tool.Name
    local itemId      = tool:GetAttribute("ItemId") or tool:GetAttribute("Id") or tool.Name
    local rarity      = tool:GetAttribute("RarityName") or "Common"

    if handle then
        local mesh = handle:FindFirstChildOfClass("SpecialMesh")
        if mesh and mesh.MeshId ~= "" then
            return mesh.MeshId .. (mesh.TextureId or "") .. "_RARITY_" .. rarity
        end
        if handle:IsA("MeshPart") and handle.MeshId ~= "" then
            return handle.MeshId .. (handle.TextureID or "") .. "_RARITY_" .. rarity
        end
    end

    if itemId and itemId ~= "" and itemId ~= tool.Name then
        return "ITEMID_" .. itemId .. "_RARITY_" .. rarity
    end
    return "NAME_" .. displayName .. "_" .. tool.Name .. "_RARITY_" .. rarity
end

local function registerItems(folder)
    if not folder then return end
    for _, tool in ipairs(folder:GetChildren()) do
        if tool:IsA("Tool") then
            local rarity  = tool:GetAttribute("RarityName") or "Common"
            local imageId = tool:GetAttribute("ImageId") or "rbxassetid://7072725737"
            WeaponRegistry[getItemKey(tool)] = { 
                ToolName = tool.Name,
                Rarity = rarity, 
                ImageId = imageId, 
                Color = RarityColors[rarity] or Color3.new(1,1,1) 
            }
        end
    end
end

if Items then
    for _, folderName in ipairs({"gun", "melee", "throwable", "consumable", "farming", "misc", "rod", "fish"}) do
        registerItems(Items:FindFirstChild(folderName))
    end
end

local function getWeaponInfo(tool)
    if not tool or not tool:IsA("Tool") then return nil end
    return WeaponRegistry[getItemKey(tool)]
end

--   INVENTARIO BI 
local function updateInventoryBillboard(player)
    if player == LocalPlayer then return end
    local char = player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if PlayerBillboards[player] then 
        PlayerBillboards[player]:Destroy() 
        PlayerBillboards[player] = nil
    end

    local gui = Instance.new("BillboardGui")
    gui.Name = "InvESP"
    gui.Adornee = root
    gui.Size = UDim2.new(0, 90, 0, 20)
    gui.StudsOffset = Vector3.new(0, -5, 0)
    gui.AlwaysOnTop = true
    gui.Enabled = Config.ESPGun == true 
    gui.Parent = char

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Horizontal
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.Padding = UDim.new(0, 5)
    layout.Parent = gui

    local tools = {}
    for _, bagName in ipairs({"Backpack", "StarterGear", "StarterPack"}) do
        local bag = player:FindFirstChild(bagName)
        if bag then
            for _, t in ipairs(bag:GetChildren()) do
                if t:IsA("Tool") and t.Name ~= "Fists" then table.insert(tools, t) end
            end
        end
    end
    for _, t in ipairs(char:GetChildren()) do
        if t:IsA("Tool") and t.Name ~= "Fists" then table.insert(tools, t) end
    end

    for _, tool in ipairs(tools) do
        local info = getWeaponInfo(tool)
        if info then
            local img = Instance.new("ImageLabel")
            img.Size = UDim2.new(0, 20, 0, 20)
            img.BackgroundTransparency = 0.1
            img.Image = info.ImageId
            img.BackgroundColor3 = Color3.fromRGB(20, 22, 26)
            Instance.new("UICorner", img).CornerRadius = UDim.new(0, 5)
            
            local stroke = Instance.new("UIStroke", img)
            stroke.Color = info.Color
            stroke.Thickness = 1.5
            img.Parent = gui
        end
    end
    PlayerBillboards[player] = gui
end

local function watchInventory(player)
    if inventoryWatchers[player] then return end
    local conns = {}
    local function refresh() task.defer(updateInventoryBillboard, player) end

    local backpack = player:FindFirstChild("Backpack")
    if backpack then
        table.insert(conns, backpack.ChildAdded:Connect(refresh))
        table.insert(conns, backpack.ChildRemoved:Connect(refresh))
    end
    local char = player.Character
    if char then
        table.insert(conns, char.ChildAdded:Connect(function(c) if c:IsA("Tool") then refresh() end end))
        table.insert(conns, char.ChildRemoved:Connect(function(c) if c:IsA("Tool") then refresh() end end))
    end
    inventoryWatchers[player] = conns
end

--  MOTOR DE ESP Y DROPS 
local ESPGui = Instance.new("ScreenGui")
ESPGui.Name = "BulletConflictESP"
ESPGui.IgnoreGuiInset = true
ESPGui.ResetOnSpawn = false
pcall(function() ESPGui.Parent = game:GetService("CoreGui") end)
if not ESPGui.Parent then ESPGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

local espCache = {}
local dropDrawings = {}

local function CreateUIElement(class, properties)
    local element = Instance.new(class)
    for k, v in pairs(properties) do element[k] = v end
    return element
end

local function AddESP(player)
    if player == LocalPlayer or espCache[player] then return end
    local cache = {}
    espCache[player] = cache

    cache.Highlight = CreateUIElement("Highlight", { FillTransparency = 0.5, FillColor = Color3.fromRGB(255, 50, 50), OutlineColor = Color3.fromRGB(255, 0, 0), OutlineTransparency = 0, DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Parent = ESPGui, Enabled = false })
    cache.Box = CreateUIElement("Frame", { BackgroundTransparency = 1, Visible = false, Parent = ESPGui })
    local boxStroke = Instance.new("UIStroke", cache.Box); boxStroke.Color = Color3.fromRGB(255, 0, 0); boxStroke.Thickness = 1.5
    cache.NameText = CreateUIElement("TextLabel", { BackgroundTransparency = 1, Visible = false, Font = Enum.Font.GothamBold, TextSize = 12, TextColor3 = Color3.fromRGB(255, 255, 255), Parent = ESPGui })
    Instance.new("UIStroke", cache.NameText).Thickness = 1.2
    cache.DistText = CreateUIElement("TextLabel", { BackgroundTransparency = 1, Visible = false, Font = Enum.Font.Gotham, TextSize = 11, TextColor3 = Color3.fromRGB(220, 220, 220), Parent = ESPGui })
    Instance.new("UIStroke", cache.DistText).Thickness = 1.2
    cache.HealthBg = CreateUIElement("Frame", { BackgroundColor3 = Color3.fromRGB(0, 0, 0), BorderSizePixel = 0, Visible = false, Parent = ESPGui })
    cache.HealthFill = CreateUIElement("Frame", { BackgroundColor3 = Color3.fromRGB(0, 255, 0), BorderSizePixel = 0, Visible = false, Parent = cache.HealthBg })
    cache.Trace = CreateUIElement("Frame", { BackgroundColor3 = Color3.fromRGB(255, 0, 0), BorderSizePixel = 0, AnchorPoint = Vector2.new(0.5, 0.5), Visible = false, Parent = ESPGui })
    
    player.CharacterAdded:Connect(function() 
        task.wait(0.5)
        updateInventoryBillboard(player)
        watchInventory(player)
    end)
    
    if player.Character then
        updateInventoryBillboard(player)
        watchInventory(player)
    end
end

local function RemoveESP(player)
    if espCache[player] then
        for _, el in pairs(espCache[player]) do if el then el:Destroy() end end
        espCache[player] = nil
    end
    if inventoryWatchers[player] then
        for _, c in ipairs(inventoryWatchers[player]) do pcall(function() c:Disconnect() end) end
        inventoryWatchers[player] = nil
    end
    if PlayerBillboards[player] then
        PlayerBillboards[player]:Destroy()
        PlayerBillboards[player] = nil
    end
end

Players.PlayerAdded:Connect(AddESP)
Players.PlayerRemoving:Connect(RemoveESP)
for _, p in pairs(Players:GetPlayers()) do AddESP(p) end

RunService.RenderStepped:Connect(function()
    local camera = workspace.CurrentCamera
    if not camera then return end
    local screenBottomCenter = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)

    -- ESP JUGADORES
    for player, cache in pairs(espCache) do
        local character = player.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local rootPart = character and character:FindFirstChild("HumanoidRootPart")
        local head = character and character:FindFirstChild("Head")

        if not character or not humanoid or humanoid.Health <= 0 or not rootPart or not head then
            cache.Highlight.Enabled = false; cache.Box.Visible = false; cache.NameText.Visible = false
            cache.DistText.Visible = false; cache.HealthBg.Visible = false; cache.Trace.Visible = false
            if PlayerBillboards[player] then PlayerBillboards[player].Enabled = false end
            continue
        end

        --  INVENTORY ESP CON EL TOGGLE 
        if PlayerBillboards[player] then
            PlayerBillboards[player].Enabled = Config.ESPGun == true
        end

        local rootPos, onScreen = camera:WorldToViewportPoint(rootPart.Position)
        if onScreen then
            local distance = (camera.CFrame.Position - rootPart.Position).Magnitude
            local topPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.8, 0))
            local bottomPos = camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 2.5, 0))
            local boxHeight = math.abs(topPos.Y - bottomPos.Y)
            local boxWidth = boxHeight * 0.55

            cache.Highlight.Adornee = character
            cache.Highlight.Enabled = Config.ESPBox


                       -- CONTORNO (Highlight)
            cache.Highlight.Adornee = character
            cache.Highlight.Enabled = Config.ESPBox
            cache.Highlight.FillTransparency = 0 --  relleno
            cache.Highlight.OutlineTransparency = 0 -- contorno 

           -- ESP BOX 
            cache.Box.Visible = false
                

               --ESP NAME

            if Config.ESPName then
                cache.NameText.Text = player.Name
                cache.NameText.Size = UDim2.new(0, boxWidth, 0, 15)
                cache.NameText.Position = UDim2.new(0, rootPos.X - (boxWidth / 2), 0, topPos.Y - 18)
                cache.NameText.Visible = true
            else cache.NameText.Visible = false end


             -- ESP DISTANCIA 

            local yOffset = bottomPos.Y + 4
            if Config.ESPDist then
                cache.DistText.Text = string.format("[%d m]", math.floor(distance))
                cache.DistText.Size = UDim2.new(0, boxWidth, 0, 15)
                cache.DistText.Position = UDim2.new(0, rootPos.X - (boxWidth / 2), 0, yOffset)
                cache.DistText.Visible = true
            else cache.DistText.Visible = false end



           --  ESP HELTH

            if Config.ESPHealth then
                local hpPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                cache.HealthBg.Size = UDim2.new(0, 3, 0, boxHeight)
                cache.HealthBg.Position = UDim2.new(0, rootPos.X - (boxWidth / 2) - 6, 0, topPos.Y)
                cache.HealthFill.Size = UDim2.new(1, 0, hpPercent, 0)
                cache.HealthFill.Position = UDim2.new(0, 0, 1 - hpPercent, 0)
                cache.HealthFill.BackgroundColor3 = Color3.fromHSV((hpPercent * 120) / 360, 1, 1)
                cache.HealthBg.Visible = true; cache.HealthFill.Visible = true
            else cache.HealthBg.Visible = false end



      --LÓGICA TRACES 


            if Config.Traces then
                local targetPos = Vector2.new(rootPos.X, bottomPos.Y)
                local dist = (targetPos - screenBottomCenter).Magnitude
                cache.Trace.Size = UDim2.new(0, dist, 0, 1)
                cache.Trace.Position = UDim2.new(0, (screenBottomCenter.X + targetPos.X) / 2, 0, (screenBottomCenter.Y + targetPos.Y) / 2)
                cache.Trace.Rotation = math.deg(math.atan2(targetPos.Y - screenBottomCenter.Y, targetPos.X - screenBottomCenter.X))
                cache.Trace.Visible = true
            else cache.Trace.Visible = false end
        else
            cache.Highlight.Enabled = false; cache.Box.Visible = false; cache.NameText.Visible = false
            cache.DistText.Visible = false; cache.HealthBg.Visible = false; cache.Trace.Visible = false
        end
    end


    --  ESP DROPS 
    
    --  LIMPIEZA
    for model, data in pairs(dropDrawings) do
        if not model or not model.Parent or model.Parent ~= DroppedItems then
            if data.txt then data.txt:Remove() end
            dropDrawings[model] = nil
        else
            data.txt.Visible = false 
        end
    end

    
    if not Config.DroppedItemESP or not DroppedItems then return end

    --  esp los objetos  en el suelo
    for _, model in ipairs(DroppedItems:GetChildren()) do
        if model:IsA("Model") and model:FindFirstChild("PickUpZone") then
            local data = dropDrawings[model]
            if not data then
                data = { txt = Drawing.new("Text") }
                data.txt.Center = true; data.txt.Outline = true; data.txt.Size = 14; data.txt.Font = 2
                dropDrawings[model] = data
            end
            
            local pos, vis = camera:WorldToViewportPoint(model.PickUpZone.Position)
            if vis then
                local wName = model.Name
                local rarity = "Common"
                
                -- rareza 
                for key, info in pairs(WeaponRegistry) do
                    if info.ToolName == wName or key:find(wName) then
                        rarity = info.Rarity
                        break
                    end
                end
                
                data.txt.Color = RarityColors[rarity] or Color3.new(1,1,1)
                local amt = model:GetAttribute("Amount") or 1
                data.txt.Text = model.Name .. (amt > 1 and " ["..amt.."]" or "")
                data.txt.Position = Vector2.new(pos.X, pos.Y)
                data.txt.Visible = true -- On
            end
        end
    end
end)

        

            


                    
    
        
    

    
                            
                

                
-- LOGICA BYPASS
-- NO AY🥵,

-- LOGICA SPEED HACK no terminada 








--  SISTEMA DE VIDA Y AUTOMÁTICA ION 

local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- 1. FAKE NAME 
local FAKE_NAME = "CS / {MODS}"

local function ocultarNombreEnTexto(textoOriginal)
    if not Config.HideName or not textoOriginal then return textoOriginal end
    local realName = LocalPlayer.Name
    local displayName = LocalPlayer.DisplayName
    local modificado = textoOriginal:gsub(realName, FAKE_NAME)
    return modificado:gsub(displayName, FAKE_NAME)
end

local function aplicarFiltroGlobal(objeto)
    if objeto:IsA("TextLabel") or objeto:IsA("TextBox") or objeto:IsA("TextButton") then
        objeto.Text = ocultarNombreEnTexto(objeto.Text)
        objeto:GetPropertyChangedSignal("Text"):Connect(function()
            if Config.HideName then
                local nuevo = ocultarNombreEnTexto(objeto.Text)
                if objeto.Text ~= nuevo then objeto.Text = nuevo end
            end
        end)
    elseif objeto:IsA("BillboardGui") then
        for _, desc in ipairs(objeto:GetDescendants()) do
            if desc:IsA("TextLabel") or desc:IsA("TextBox") or desc:IsA("TextButton") then
                desc.Text = ocultarNombreEnTexto(desc.Text)
                desc:GetPropertyChangedSignal("Text"):Connect(function()
                    if Config.HideName then
                        local nuevo = ocultarNombreEnTexto(desc.Text)
                        if desc.Text ~= nuevo then desc.Text = nuevo end
                    end
                end)
            end
        end
    end
end

for _, guiObj in ipairs(game:GetDescendants()) do pcall(function() aplicarFiltroGlobal(guiObj) end) end
game.DescendantAdded:Connect(function(obj) pcall(function() aplicarFiltroGlobal(obj) end) end)

local function hideMyNameVisuals()
    if not Config.HideName then return end
    local character = LocalPlayer.Character
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
    
    for _,v in pairs(character:GetDescendants()) do
        if v:IsA("BillboardGui") then
            v.Enabled = false
            for _, label in ipairs(v:GetDescendants()) do
                if label:IsA("TextLabel") then label.Text = ocultarNombreEnTexto(label.Text) end
            end
        elseif v:IsA("Model") and (v.Name:find(LocalPlayer.Name) or v.Name:find("Car")) then
            if v.Name:find(LocalPlayer.Name) then v.Name = FAKE_NAME end
        end
    end
end
RunService.Heartbeat:Connect(hideMyNameVisuals)

--  NO RECOIL 
local function limpiarRecoil(tool)
    if not Config.NoRecoil then return end
    pcall(function()
        for _, v in ipairs(tool:GetDescendants()) do
            local nombre = v.Name:lower()
            if nombre:find("recoil") or nombre:find("shake") or nombre:find("kick") or nombre:find("spread") or nombre:find("bobble") then
                if v:IsA("NumberValue") or v:IsA("IntValue") then v.Value = 0
                elseif v:IsA("Vector3Value") then v.Value = Vector3.new(0, 0, 0)
                elseif v:IsA("Script") or v:IsA("LocalScript") then v.Disabled = true
                elseif v:IsA("ModuleScript") then pcall(function() require(v) end) end
            end
        end
        for attrName, _ in pairs(tool:GetAttributes()) do
            if attrName:lower():find("recoil") or attrName:lower():find("shake") or attrName:lower():find("spread") then
                tool:SetAttribute(attrName, 0)
            end
        end
    end)
end

RunService.RenderStepped:Connect(function()
    
        -- No Recoil 
    if Config.NoRecoil then
        pcall(function()
            local char = LocalPlayer.Character
            if char then
                for _, tool in ipairs(char:GetChildren()) do if tool:IsA("Tool") then limpiarRecoil(tool) end end
            end
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            if backpack then
                for _, tool in ipairs(backpack:GetChildren()) do if tool:IsA("Tool") then limpiarRecoil(tool) end end
            end
        end)
    end
end)

-- AUTO BLOOD BAG (50) INSTANTÁNEO
local function eliminarAnimacionesDeUso(char)
    local animator = char:FindFirstChildOfClass("Humanoid") and char.Humanoid:FindFirstChildOfClass("Animator")
    if animator then
        pcall(function()
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                local name = track.Name:lower()
                if name:find("ammo") or name:find("crate") or name:find("blood") or name:find("use") or name:find("heal") then
                    track:Stop(0)
                end
            end
        end)
    end
end

RunService.Stepped:Connect(function()
    if Config.AutoBlood or Config.AutoSkipCrate then
        if Character then eliminarAnimacionesDeUso(Character) end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if Config.AutoBlood and Character then
            local hum = Character:FindFirstChildOfClass("Humanoid")
            local backpack = LocalPlayer:FindFirstChild("Backpack")
            if hum and hum.Health > 0 and hum.Health < 50 and backpack then
                local bloodBag = backpack:FindFirstChild("Blood Bag") or Character:FindFirstChild("Blood Bag")
                if bloodBag then
                    if bloodBag.Parent == backpack then hum:EquipTool(bloodBag) end
                    local remote = bloodBag:FindFirstChildWhichIsA("RemoteEvent") or bloodBag:FindFirstChild("ServerControl") or bloodBag:FindFirstChild("Use")
                    if remote then pcall(function() remote:FireServer() end) end
                    pcall(function() bloodBag:Activate() end)
                    
                    eliminarAnimacionesDeUso(Character)
                    if VirtualUser then pcall(function() VirtualUser:Button1Down(Vector2.new(0,0)); task.wait(0.01); VirtualUser:Button1Up(Vector2.new(0,0)) end) end
                end
            end
        end
    end
end)

-- AUTO SKIP CRATE & AMMO
local CrateController
pcall(function() CrateController = require(ReplicatedStorage.Modules.Game.CrateSystem.Crate) end)

pcall(function()
    local UtilModule = require(ReplicatedStorage.Modules.Core.Util)
    if UtilModule.tween then
        local old_tween = UtilModule.tween
        UtilModule.tween = function(instance, tweenInfo, properties, ...)
            if Config.AutoSkipCrate and instance:IsA("NumberValue") and properties.Value == 1 then
                if tweenInfo.Time > 0 then
                    tweenInfo = TweenInfo.new(0, tweenInfo.EasingStyle, tweenInfo.EasingDirection)
                end
            end
            return old_tween(instance, tweenInfo, properties, ...)
        end
    end
end)

task.spawn(function()
    while task.wait(0.1) do
        if Config.AutoSkipCrate and CrateController then
            pcall(function()
                for _, crate in pairs(CrateController.class.objects) do
                    crate.states.open.set(true)
                    CrateController.skipping.set(true)
                end
            end)
        end
    end
end)

--  AUTO MINIGAME (ATM / FISHI
local SliderModule
pcall(function() SliderModule = require(ReplicatedStorage.Modules.Game.Minigames.SliderMinigame) end)

task.spawn(function()
    while task.wait(0.04) do
        if Config.AutoMinigame and SliderModule and SliderModule.enabled and SliderModule.enabled.get() then
            pcall(function()
                local current = SliderModule.needle_pos.get()
                local target = SliderModule.target_pos.get()
                if typeof(current) == "number" and typeof(target) == "number" then
                    local diff = target - current
                    SliderModule.needle_pos.set(current + diff * 0.12)
                    if math.abs(diff) < 0.025 then
                        task.wait(0.06)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                        task.wait(0.03)
                        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                        task.wait(0.35)
                    end
                end
            end)
        end
    end
end)

--  AUTO PICKUP
local Counter
pcall(function()
    for _, v in ipairs(getgc(true)) do
        if typeof(v) == "table" and rawget(v, "event") and rawget(v, "func") then Counter = v; break end
    end
end)

local function netGet(...)
    if not Counter or not Counter.func then return end
    Counter.func = (Counter.func or 0) + 1
    return ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Get"):InvokeServer(Counter.func, ...)
end

task.spawn(function()
    local DroppedItems = workspace:WaitForChild("DroppedItems")
    while task.wait(0.2) do
        if Config.AutoPickup and Character then
            local root = Character:FindFirstChild("HumanoidRootPart")
            if root then
                for _, item in ipairs(DroppedItems:GetChildren()) do
                    if item:IsA("Model") and item:FindFirstChild("PickUpZone") then
                        if (item:GetPivot().Position - root.Position).Magnitude < 50 then
                            pcall(netGet, "pickup_dropped_item", item)
                        end
                    end
                end
            end
        end
    end
end)

