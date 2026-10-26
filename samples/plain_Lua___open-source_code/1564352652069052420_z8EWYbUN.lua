-- 392 GUI - Key: 392
-- Tecla V para abrir/cerrar

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local Camera = workspace.CurrentCamera
local LocalPlayer = Players.LocalPlayer

-- Variables
local Settings = {
    Aimbot = false,
    SilentAim = false,
    SilentAimV2 = false,
    ESP = {
        Skeleton = false,
        Box = false,
        Line = false,
        Health = false,
        Chams = false,
        Name = false,
        Armor = false
    },
    Noclip = false,
    Fly = false,
    FlySpeed = 50,
    Speed = false,
    SpeedValue = 100,
    GodMode = false
}

local ESPObjects = {}
local CurrentTab = "Aim"
local AimbotTarget = nil
local RightMouseDown = false
local NoclipConnection = nil
local FlyConnection = nil
local SpeedConnection = nil
local GodModeConnection = nil

-- Crear GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "392_GUI"
ScreenGui.Parent = game.CoreGui

-- ========== KEY SYSTEM ==========
local KeyFrame = Instance.new("Frame")
KeyFrame.Size = UDim2.new(0, 350, 0, 250)
KeyFrame.Position = UDim2.new(0.5, -175, 0.5, -125)
KeyFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
KeyFrame.BorderSizePixel = 0
KeyFrame.Parent = ScreenGui

local KeyCorner = Instance.new("UICorner")
KeyCorner.CornerRadius = UDim.new(0, 15)
KeyCorner.Parent = KeyFrame

-- Sombra
local KeyShadow = Instance.new("ImageLabel")
KeyShadow.AnchorPoint = Vector2.new(0.5, 0.5)
KeyShadow.BackgroundTransparency = 1
KeyShadow.Position = UDim2.new(0.5, 0, 0.5, 0)
KeyShadow.Size = UDim2.new(1, 40, 1, 40)
KeyShadow.Image = "rbxassetid://1316045217"
KeyShadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
KeyShadow.ImageTransparency = 0.5
KeyShadow.ScaleType = Enum.ScaleType.Slice
KeyShadow.SliceCenter = Rect.new(10, 10, 118, 118)
KeyShadow.Parent = KeyFrame

-- Título
local KeyTitle = Instance.new("TextLabel")
KeyTitle.Size = UDim2.new(1, 0, 0, 50)
KeyTitle.BackgroundTransparency = 1
KeyTitle.Text = "392 AUTH"
KeyTitle.TextColor3 = Color3.fromRGB(255, 0, 0)
KeyTitle.TextSize = 32
KeyTitle.Font = Enum.Font.GothamBlack
KeyTitle.Parent = KeyFrame

-- Subtítulo
local KeySubtitle = Instance.new("TextLabel")
KeySubtitle.Size = UDim2.new(1, 0, 0, 30)
KeySubtitle.Position = UDim2.new(0, 0, 0, 45)
KeySubtitle.BackgroundTransparency = 1
KeySubtitle.Text = "Ingresa la key para continuar"
KeySubtitle.TextColor3 = Color3.fromRGB(150, 150, 150)
KeySubtitle.TextSize = 14
KeySubtitle.Font = Enum.Font.Gotham
KeySubtitle.Parent = KeyFrame

-- Input Box
local InputFrame = Instance.new("Frame")
InputFrame.Size = UDim2.new(0.8, 0, 0, 45)
InputFrame.Position = UDim2.new(0.1, 0, 0, 90)
InputFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
InputFrame.BorderSizePixel = 0
InputFrame.Parent = KeyFrame

local InputCorner = Instance.new("UICorner")
InputCorner.CornerRadius = UDim.new(0, 10)
InputCorner.Parent = InputFrame

local KeyInput = Instance.new("TextBox")
KeyInput.Size = UDim2.new(1, -20, 1, 0)
KeyInput.Position = UDim2.new(0, 10, 0, 0)
KeyInput.BackgroundTransparency = 1
KeyInput.Text = ""
KeyInput.PlaceholderText = "Ingresa la key aquí..."
KeyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
KeyInput.PlaceholderColor3 = Color3.fromRGB(100, 100, 100)
KeyInput.TextSize = 16
KeyInput.Font = Enum.Font.Gotham
KeyInput.ClearTextOnFocus = false
KeyInput.Parent = InputFrame

-- Botón Verificar
local VerifyButton = Instance.new("TextButton")
VerifyButton.Size = UDim2.new(0.8, 0, 0, 40)
VerifyButton.Position = UDim2.new(0.1, 0, 0, 150)
VerifyButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
VerifyButton.Text = "VERIFICAR"
VerifyButton.TextColor3 = Color3.fromRGB(255, 255, 255)
VerifyButton.TextSize = 16
VerifyButton.Font = Enum.Font.GothamBold
VerifyButton.Parent = KeyFrame

local VerifyCorner = Instance.new("UICorner")
VerifyCorner.CornerRadius = UDim.new(0, 10)
VerifyCorner.Parent = VerifyButton

-- Mensaje de estado
local StatusLabel = Instance.new("TextLabel")
StatusLabel.Size = UDim2.new(1, 0, 0, 30)
StatusLabel.Position = UDim2.new(0, 0, 0, 200)
StatusLabel.BackgroundTransparency = 1
StatusLabel.Text = ""
StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
StatusLabel.TextSize = 14
StatusLabel.Font = Enum.Font.Gotham
StatusLabel.Parent = KeyFrame

-- ========== GUI PRINCIPAL (OCULTO AL INICIO) ==========
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Size = UDim2.new(0, 500, 0, 400)
MainFrame.Position = UDim2.new(0.5, -250, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
MainFrame.BorderSizePixel = 0
MainFrame.Visible = false
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 15)
UICorner.Parent = MainFrame

-- Sombra
local Shadow = Instance.new("ImageLabel")
Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
Shadow.BackgroundTransparency = 1
Shadow.Position = UDim2.new(0.5, 0, 0.5, 0)
Shadow.Size = UDim2.new(1, 40, 1, 40)
Shadow.Image = "rbxassetid://1316045217"
Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
Shadow.ImageTransparency = 0.5
Shadow.ScaleType = Enum.ScaleType.Slice
Shadow.SliceCenter = Rect.new(10, 10, 118, 118)
Shadow.Parent = MainFrame

-- Barra lateral
local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 110, 1, 0)
Sidebar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 15)
SidebarCorner.Parent = Sidebar

-- Título 392
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 50)
Title.BackgroundTransparency = 1
Title.Text = "392"
Title.TextColor3 = Color3.fromRGB(255, 0, 0)
Title.TextSize = 32
Title.Font = Enum.Font.GothamBlack
Title.Parent = Sidebar

-- Botones
local AimButton = Instance.new("TextButton")
AimButton.Size = UDim2.new(0.9, 0, 0, 30)
AimButton.Position = UDim2.new(0.05, 0, 0, 55)
AimButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
AimButton.Text = "Aim"
AimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
AimButton.TextSize = 13
AimButton.Font = Enum.Font.GothamBold
AimButton.Parent = Sidebar

local AimCorner = Instance.new("UICorner")
AimCorner.CornerRadius = UDim.new(0, 8)
AimCorner.Parent = AimButton

local ESPButton = Instance.new("TextButton")
ESPButton.Size = UDim2.new(0.9, 0, 0, 30)
ESPButton.Position = UDim2.new(0.05, 0, 0, 90)
ESPButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ESPButton.Text = "ESP"
ESPButton.TextColor3 = Color3.fromRGB(200, 200, 200)
ESPButton.TextSize = 13
ESPButton.Font = Enum.Font.GothamBold
ESPButton.Parent = Sidebar

local ESPCorner = Instance.new("UICorner")
ESPCorner.CornerRadius = UDim.new(0, 8)
ESPCorner.Parent = ESPButton

local OthersButton = Instance.new("TextButton")
OthersButton.Size = UDim2.new(0.9, 0, 0, 30)
OthersButton.Position = UDim2.new(0.05, 0, 0, 125)
OthersButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
OthersButton.Text = "Otras"
OthersButton.TextColor3 = Color3.fromRGB(200, 200, 200)
OthersButton.TextSize = 13
OthersButton.Font = Enum.Font.GothamBold
OthersButton.Parent = Sidebar

local OthersCorner = Instance.new("UICorner")
OthersCorner.CornerRadius = UDim.new(0, 8)
OthersCorner.Parent = OthersButton

local ConfigButton = Instance.new("TextButton")
ConfigButton.Size = UDim2.new(0.9, 0, 0, 30)
ConfigButton.Position = UDim2.new(0.05, 0, 0, 160)
ConfigButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ConfigButton.Text = "Config"
ConfigButton.TextColor3 = Color3.fromRGB(200, 200, 200)
ConfigButton.TextSize = 13
ConfigButton.Font = Enum.Font.GothamBold
ConfigButton.Parent = Sidebar

local ConfigCorner = Instance.new("UICorner")
ConfigCorner.CornerRadius = UDim.new(0, 8)
ConfigCorner.Parent = ConfigButton

-- Discord
local DiscordButton = Instance.new("TextButton")
DiscordButton.Size = UDim2.new(0.9, 0, 0, 30)
DiscordButton.Position = UDim2.new(0.05, 0, 1, -40)
DiscordButton.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
DiscordButton.Text = "Discord"
DiscordButton.TextColor3 = Color3.fromRGB(255, 255, 255)
DiscordButton.TextSize = 12
DiscordButton.Font = Enum.Font.GothamBold
DiscordButton.Parent = Sidebar

local DiscordCorner = Instance.new("UICorner")
DiscordCorner.CornerRadius = UDim.new(0, 8)
DiscordCorner.Parent = DiscordButton

-- Panel de contenido
local ContentPanel = Instance.new("Frame")
ContentPanel.Size = UDim2.new(1, -120, 1, -20)
ContentPanel.Position = UDim2.new(0, 115, 0, 10)
ContentPanel.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
ContentPanel.BorderSizePixel = 0
ContentPanel.Parent = MainFrame

local ContentCorner = Instance.new("UICorner")
ContentCorner.CornerRadius = UDim.new(0, 12)
ContentCorner.Parent = ContentPanel

-- Función crear toggle
local function CreateToggle(parent, text, callback)
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Size = UDim2.new(0.95, 0, 0, 40)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    ToggleFrame.BorderSizePixel = 0
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 10)
    ToggleCorner.Parent = ToggleFrame
    
    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(0.65, 0, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.TextSize = 13
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Position = UDim2.new(0.05, 0, 0, 0)
    Label.Parent = ToggleFrame
    
    local SwitchFrame = Instance.new("Frame")
    SwitchFrame.Size = UDim2.new(0, 45, 0, 24)
    SwitchFrame.Position = UDim2.new(1, -55, 0.5, -12)
    SwitchFrame.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SwitchFrame.BorderSizePixel = 0
    SwitchFrame.Parent = ToggleFrame
    
    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = SwitchFrame
    
    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0, 20, 0, 20)
    Circle.Position = UDim2.new(0, 2, 0.5, -10)
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.BorderSizePixel = 0
    Circle.Parent = SwitchFrame
    
    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle
    
    local enabled = false
    
    local function Toggle()
        enabled = not enabled
        if enabled then
            TweenService:Create(SwitchFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(0, 150, 255)}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 23, 0.5, -10)}):Play()
        else
            TweenService:Create(SwitchFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
            TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 2, 0.5, -10)}):Play()
        end
        callback(enabled)
    end
    
    local ClickArea = Instance.new("TextButton")
    ClickArea.Size = UDim2.new(1, 0, 1, 0)
    ClickArea.BackgroundTransparency = 1
    ClickArea.Text = ""
    ClickArea.Parent = ToggleFrame
    ClickArea.MouseButton1Click:Connect(Toggle)
    
    return ToggleFrame
end

-- Panel AIM
local AimPanel = Instance.new("ScrollingFrame")
AimPanel.Name = "AimPanel"
AimPanel.Size = UDim2.new(1, 0, 1, 0)
AimPanel.BackgroundTransparency = 1
AimPanel.ScrollBarThickness = 4
AimPanel.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
AimPanel.Visible = true
AimPanel.CanvasSize = UDim2.new(0, 0, 0, 300)
AimPanel.Parent = ContentPanel

local AimList = Instance.new("UIListLayout")
AimList.Padding = UDim.new(0, 8)
AimList.Parent = AimPanel

local AimTitle = Instance.new("TextLabel")
AimTitle.Size = UDim2.new(0.95, 0, 0, 25)
AimTitle.BackgroundTransparency = 1
AimTitle.Text = "AIMBOT SETTINGS"
AimTitle.TextColor3 = Color3.fromRGB(255, 0, 0)
AimTitle.TextSize = 16
AimTitle.Font = Enum.Font.GothamBold
AimTitle.Parent = AimPanel

CreateToggle(AimPanel, "Aimbot (Mantener Click Derecho)", function(enabled)
    Settings.Aimbot = enabled
end).Parent = AimPanel

CreateToggle(AimPanel, "Silent Aim (Hitbox 100%)", function(enabled)
    Settings.SilentAim = enabled
end).Parent = AimPanel

CreateToggle(AimPanel, "Silent Aim V2 (Hitbox 150%)", function(enabled)
    Settings.SilentAimV2 = enabled
end).Parent = AimPanel

-- Panel ESP
local ESPPanel = Instance.new("ScrollingFrame")
ESPPanel.Name = "ESPPanel"
ESPPanel.Size = UDim2.new(1, 0, 1, 0)
ESPPanel.BackgroundTransparency = 1
ESPPanel.ScrollBarThickness = 4
ESPPanel.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
ESPPanel.Visible = false
ESPPanel.CanvasSize = UDim2.new(0, 0, 0, 450)
ESPPanel.Parent = ContentPanel

local ESPList = Instance.new("UIListLayout")
ESPList.Padding = UDim.new(0, 8)
ESPList.Parent = ESPPanel

local ESPTitle = Instance.new("TextLabel")
ESPTitle.Size = UDim2.new(0.95, 0, 0, 25)
ESPTitle.BackgroundTransparency = 1
ESPTitle.Text = "ESP SETTINGS"
ESPTitle.TextColor3 = Color3.fromRGB(255, 0, 0)
ESPTitle.TextSize = 16
ESPTitle.Font = Enum.Font.GothamBold
ESPTitle.Parent = ESPPanel

CreateToggle(ESPPanel, "Skeleton (Blanco)", function(enabled)
    Settings.ESP.Skeleton = enabled
end).Parent = ESPPanel

CreateToggle(ESPPanel, "Box (Blanco)", function(enabled)
    Settings.ESP.Box = enabled
end).Parent = ESPPanel

CreateToggle(ESPPanel, "Line (Blanca)", function(enabled)
    Settings.ESP.Line = enabled
end).Parent = ESPPanel

CreateToggle(ESPPanel, "Health (Verde)", function(enabled)
    Settings.ESP.Health = enabled
end).Parent = ESPPanel

CreateToggle(ESPPanel, "Name (Nombre)", function(enabled)
    Settings.ESP.Name = enabled
end).Parent = ESPPanel

CreateToggle(ESPPanel, "Armor (Chaleco)", function(enabled)
    Settings.ESP.Armor = enabled
end).Parent = ESPPanel

CreateToggle(ESPPanel, "Chams (Ver a traves)", function(enabled)
    Settings.ESP.Chams = enabled
end).Parent = ESPPanel

-- Panel OTRAS
local OthersPanel = Instance.new("ScrollingFrame")
OthersPanel.Name = "OthersPanel"
OthersPanel.Size = UDim2.new(1, 0, 1, 0)
OthersPanel.BackgroundTransparency = 1
OthersPanel.ScrollBarThickness = 4
OthersPanel.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
OthersPanel.Visible = false
OthersPanel.CanvasSize = UDim2.new(0, 0, 0, 450)
OthersPanel.Parent = ContentPanel

local OthersList = Instance.new("UIListLayout")
OthersList.Padding = UDim.new(0, 8)
OthersList.Parent = OthersPanel

local OthersTitle = Instance.new("TextLabel")
OthersTitle.Size = UDim2.new(0.95, 0, 0, 25)
OthersTitle.BackgroundTransparency = 1
OthersTitle.Text = "OTRAS FUNCIONES"
OthersTitle.TextColor3 = Color3.fromRGB(255, 0, 0)
OthersTitle.TextSize = 16
OthersTitle.Font = Enum.Font.GothamBold
OthersTitle.Parent = OthersPanel

CreateToggle(OthersPanel, "Noclip (Atravesar Paredes)", function(enabled)
    Settings.Noclip = enabled
end).Parent = OthersPanel

CreateToggle(OthersPanel, "Fly (Volar)", function(enabled)
    Settings.Fly = enabled
end).Parent = OthersPanel

CreateToggle(OthersPanel, "Speed (Correr Rapido)", function(enabled)
    Settings.Speed = enabled
end).Parent = OthersPanel

-- GOD MODE TOGGLE
CreateToggle(OthersPanel, "God Mode (Invencible)", function(enabled)
    Settings.GodMode = enabled
end).Parent = OthersPanel

-- Info
local FlyInfo = Instance.new("TextLabel")
FlyInfo.Size = UDim2.new(0.95, 0, 0, 60)
FlyInfo.BackgroundTransparency = 1
FlyInfo.Text = "Controles Fly:\nWASD + Espacio/Shift\nSpeed: Activo automaticamente\nGod Mode: No recibes daño de ningún tipo"
FlyInfo.TextColor3 = Color3.fromRGB(150, 150, 150)
FlyInfo.TextSize = 11
FlyInfo.Font = Enum.Font.Gotham
FlyInfo.TextWrapped = true
FlyInfo.Parent = OthersPanel

-- Panel Config
local ConfigPanel = Instance.new("ScrollingFrame")
ConfigPanel.Name = "ConfigPanel"
ConfigPanel.Size = UDim2.new(1, 0, 1, 0)
ConfigPanel.BackgroundTransparency = 1
ConfigPanel.ScrollBarThickness = 4
ConfigPanel.ScrollBarImageColor3 = Color3.fromRGB(255, 0, 0)
ConfigPanel.Visible = false
ConfigPanel.CanvasSize = UDim2.new(0, 0, 0, 200)
ConfigPanel.Parent = ContentPanel

local ConfigList = Instance.new("UIListLayout")
ConfigList.Padding = UDim.new(0, 8)
ConfigList.Parent = ConfigPanel

local ConfigTitle = Instance.new("TextLabel")
ConfigTitle.Size = UDim2.new(0.95, 0, 0, 25)
ConfigTitle.BackgroundTransparency = 1
ConfigTitle.Text = "CONFIGURATION"
ConfigTitle.TextColor3 = Color3.fromRGB(255, 0, 0)
ConfigTitle.TextSize = 16
ConfigTitle.Font = Enum.Font.GothamBold
ConfigTitle.Parent = ConfigPanel

local InfoLabel = Instance.new("TextLabel")
InfoLabel.Size = UDim2.new(0.95, 0, 0, 100)
InfoLabel.BackgroundTransparency = 1
InfoLabel.Text = "392 Script Premium\nCreado por Venice\n\nTecla V: Abrir/Cerrar GUI\nKey: 392\n\nGod Mode: Eres inmune a todo daño"
InfoLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
InfoLabel.TextSize = 12
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.TextWrapped = true
InfoLabel.Parent = ConfigPanel

-- Función cambiar tab
local function SwitchTab(tab)
    CurrentTab = tab
    AimPanel.Visible = false
    ESPPanel.Visible = false
    OthersPanel.Visible = false
    ConfigPanel.Visible = false
    
    AimButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    AimButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    ESPButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ESPButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    OthersButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    OthersButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    ConfigButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ConfigButton.TextColor3 = Color3.fromRGB(200, 200, 200)
    
    if tab == "Aim" then
        AimPanel.Visible = true
        AimButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        AimButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    elseif tab == "ESP" then
        ESPPanel.Visible = true
        ESPButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        ESPButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    elseif tab == "Otras" then
        OthersPanel.Visible = true
        OthersButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        OthersButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        ConfigPanel.Visible = true
        ConfigButton.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
        ConfigButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    end
end

AimButton.MouseButton1Click:Connect(function() SwitchTab("Aim") end)
ESPButton.MouseButton1Click:Connect(function() SwitchTab("ESP") end)
OthersButton.MouseButton1Click:Connect(function() SwitchTab("Otras") end)
ConfigButton.MouseButton1Click:Connect(function() SwitchTab("Config") end)

-- Discord link
DiscordButton.MouseButton1Click:Connect(function()
    setclipboard("https://discord.gg/q8nKyTbJk")
    DiscordButton.Text = "Link Copiado!"
    wait(2)
    DiscordButton.Text = "Discord"
end)

-- ========== VERIFICACIÓN DE KEY ==========
local function VerifyKey()
    local enteredKey = KeyInput.Text
    if enteredKey == "392" then
        StatusLabel.Text = "Key correcta! Cargando..."
        StatusLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
        wait(1)
        KeyFrame:Destroy()
        MainFrame.Visible = true
    else
        StatusLabel.Text = "Key incorrecta! Intenta de nuevo"
        StatusLabel.TextColor3 = Color3.fromRGB(255, 0, 0)
        KeyInput.Text = ""
    end
end

VerifyButton.MouseButton1Click:Connect(VerifyKey)
KeyInput.FocusLost:Connect(function(enterPressed)
    if enterPressed then
        VerifyKey()
    end
end)

-- Toggle GUI con tecla V (CORREGIDO - Abre y Cierra)
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.V then
        -- No toggle si aún está la pantalla de key
        if KeyFrame and KeyFrame.Parent then return end
        
        -- Toggle: Si está visible la oculta, si está oculta la muestra
        MainFrame.Visible = not MainFrame.Visible
    end
end)

-- Arrastrable
local dragging = false
local dragStart, startPos

local dragArea = Instance.new("Frame")
dragArea.Size = UDim2.new(1, 0, 0, 50)
dragArea.BackgroundTransparency = 1
dragArea.Parent = MainFrame

dragArea.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

dragArea.InputChanged:Connect(function(input)
    if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = false
    end
end)

-- ========== FUNCIONES DEL SCRIPT ==========

-- Detectar clic derecho
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton2 then
        RightMouseDown = true
    end
end)

UserInputService.InputEnded:Connect(function(input, gameProcessed)
    if not gameProcessed and input.UserInputType == Enum.UserInputType.MouseButton2 then
        RightMouseDown = false
        AimbotTarget = nil
    end
end)

-- Aimbot
local function GetClosestPlayerToMouse()
    local closestPlayer = nil
    local shortestDistance = math.huge
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
            
            if onScreen then
                local mousePos = UserInputService:GetMouseLocation()
                local distance = (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude
                
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end
    
    return closestPlayer
end

-- Silent Aim
local function UpdateHitboxes()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
            local head = player.Character:FindFirstChild("Head")
            
            if hrp then
                if Settings.SilentAim then
                    hrp.Size = Vector3.new(100, 100, 100)
                    hrp.Transparency = 0.9
                    hrp.CanCollide = false
                elseif Settings.SilentAimV2 then
                    hrp.Size = Vector3.new(150, 150, 150)
                    hrp.Transparency = 0.95
                    hrp.CanCollide = false
                else
                    hrp.Size = Vector3.new(2, 2, 1)
                    hrp.Transparency = 1
                    hrp.CanCollide = true
                end
            end
            
            if head then
                if Settings.SilentAim then
                    head.Size = Vector3.new(20, 20, 20)
                    head.Transparency = 0.9
                elseif Settings.SilentAimV2 then
                    head.Size = Vector3.new(30, 30, 30)
                    head.Transparency = 0.95
                else
                    head.Size = Vector3.new(2, 1, 1)
                    head.Transparency = 0
                end
            end
        end
    end
end

-- ESP Functions
local function CreateESPObject(player)
    if ESPObjects[player] then return end
    
    ESPObjects[player] = {
        Skeleton = {},
        Box = nil,
        BoxOutline = nil,
        Line = nil,
        HealthBar = nil,
        HealthBarBg = nil,
        Name = nil,
        Armor = nil,
        ArmorBg = nil,
        Chams = {}
    }
    
    for i = 1, 10 do
        local line = Drawing.new("Line")
        line.Visible = false
        line.Thickness = 1.5
        line.Color = Color3.fromRGB(255, 255, 255)
        line.Transparency = 1
        table.insert(ESPObjects[player].Skeleton, line)
    end
    
    ESPObjects[player].Box = Drawing.new("Square")
    ESPObjects[player].Box.Thickness = 2
    ESPObjects[player].Box.Color = Color3.fromRGB(255, 255, 255)
    ESPObjects[player].Box.Filled = false
    ESPObjects[player].Box.Visible = false
    
    ESPObjects[player].BoxOutline = Drawing.new("Square")
    ESPObjects[player].BoxOutline.Thickness = 4
    ESPObjects[player].BoxOutline.Color = Color3.fromRGB(0, 0, 0)
    ESPObjects[player].BoxOutline.Filled = false
    ESPObjects[player].BoxOutline.Visible = false
    
    ESPObjects[player].Line = Drawing.new("Line")
    ESPObjects[player].Line.Thickness = 1.5
    ESPObjects[player].Line.Color = Color3.fromRGB(255, 255, 255)
    ESPObjects[player].Line.Visible = false
    
    ESPObjects[player].HealthBarBg = Drawing.new("Square")
    ESPObjects[player].HealthBarBg.Thickness = 1
    ESPObjects[player].HealthBarBg.Color = Color3.fromRGB(0, 0, 0)
    ESPObjects[player].HealthBarBg.Filled = true
    ESPObjects[player].HealthBarBg.Visible = false
    
    ESPObjects[player].HealthBar = Drawing.new("Square")
    ESPObjects[player].HealthBar.Thickness = 1
    ESPObjects[player].HealthBar.Color = Color3.fromRGB(0, 255, 0)
    ESPObjects[player].HealthBar.Filled = true
    ESPObjects[player].HealthBar.Visible = false
    
    ESPObjects[player].Name = Drawing.new("Text")
    ESPObjects[player].Name.Size = 14
    ESPObjects[player].Name.Center = true
    ESPObjects[player].Name.Outline = true
    ESPObjects[player].Name.Color = Color3.fromRGB(255, 255, 255)
    ESPObjects[player].Name.Visible = false
    
    ESPObjects[player].ArmorBg = Drawing.new("Square")
    ESPObjects[player].ArmorBg.Thickness = 1
    ESPObjects[player].ArmorBg.Color = Color3.fromRGB(0, 0, 0)
    ESPObjects[player].ArmorBg.Filled = true
    ESPObjects[player].ArmorBg.Visible = false
    
    ESPObjects[player].Armor = Drawing.new("Square")
    ESPObjects[player].Armor.Thickness = 1
    ESPObjects[player].Armor.Color = Color3.fromRGB(0, 100, 255)
    ESPObjects[player].Armor.Filled = true
    ESPObjects[player].Armor.Visible = false
    
    if player.Character then
        for _, part in ipairs(player.Character:GetDescendants()) do
            if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                local cham = Instance.new("BoxHandleAdornment")
                cham.Name = "392Chams"
                cham.Size = part.Size + Vector3.new(0.1, 0.1, 0.1)
                cham.AlwaysOnTop = true
                cham.ZIndex = 5
                cham.Adornee = part
                cham.Color3 = Color3.fromRGB(255, 0, 0)
                cham.Transparency = 0.5
                cham.Parent = part
                table.insert(ESPObjects[player].Chams, cham)
            end
        end
    end
end

-- Update ESP
local function UpdateESP()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("Head") then
            CreateESPObject(player)
            local objects = ESPObjects[player]
            local character = player.Character
            local humanoid = character.Humanoid
            local hrp = character:FindFirstChild("HumanoidRootPart")
            local head = character.Head
            
            if not hrp then 
                objects.Box.Visible = false
                objects.BoxOutline.Visible = false
                objects.Line.Visible = false
                for _, line in ipairs(objects.Skeleton) do
                    line.Visible = false
                end
                objects.HealthBar.Visible = false
                objects.HealthBarBg.Visible = false
                objects.Name.Visible = false
                objects.Armor.Visible = false
                objects.ArmorBg.Visible = false
                continue 
            end
            
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            
            if not onScreen then
                objects.Box.Visible = false
                objects.BoxOutline.Visible = false
                objects.Line.Visible = false
                for _, line in ipairs(objects.Skeleton) do
                    line.Visible = false
                end
                objects.HealthBar.Visible = false
                objects.HealthBarBg.Visible = false
                objects.Name.Visible = false
                objects.Armor.Visible = false
                objects.ArmorBg.Visible = false
                continue
            end
            
            local headPos = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
            local legPos = Camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))
            local height = math.abs(headPos.Y - legPos.Y)
            local width = height / 2.5
            
            if Settings.ESP.Skeleton then
                local torso = character:FindFirstChild("UpperTorso") or character:FindFirstChild("Torso")
                local lowerTorso = character:FindFirstChild("LowerTorso") or torso
                
                local joints = {
                    {head, torso},
                    {torso, lowerTorso},
                    {torso, character:FindFirstChild("LeftUpperArm")},
                    {character:FindFirstChild("LeftUpperArm"), character:FindFirstChild("LeftLowerArm")},
                    {torso, character:FindFirstChild("RightUpperArm")},
                    {character:FindFirstChild("RightUpperArm"), character:FindFirstChild("RightLowerArm")},
                    {lowerTorso, character:FindFirstChild("LeftUpperLeg")},
                    {character:FindFirstChild("LeftUpperLeg"), character:FindFirstChild("LeftLowerLeg")},
                    {lowerTorso, character:FindFirstChild("RightUpperLeg")},
                    {character:FindFirstChild("RightUpperLeg"), character:FindFirstChild("RightLowerLeg")}
                }
                
                for i, joint in ipairs(joints) do
                    if joint[1] and joint[2] and objects.Skeleton[i] then
                        local p1 = Camera:WorldToViewportPoint(joint[1].Position)
                        local p2 = Camera:WorldToViewportPoint(joint[2].Position)
                        objects.Skeleton[i].From = Vector2.new(p1.X, p1.Y)
                        objects.Skeleton[i].To = Vector2.new(p2.X, p2.Y)
                        objects.Skeleton[i].Visible = true
                        objects.Skeleton[i].Color = Color3.fromRGB(255, 255, 255)
                    elseif objects.Skeleton[i] then
                        objects.Skeleton[i].Visible = false
                    end
                end
            else
                for _, line in ipairs(objects.Skeleton) do
                    line.Visible = false
                end
            end
            
            if Settings.ESP.Box then
                objects.BoxOutline.Size = Vector2.new(width + 2, height + 2)
                objects.BoxOutline.Position = Vector2.new(pos.X - width/2 - 1, headPos.Y - 1)
                objects.BoxOutline.Visible = true
                
                objects.Box.Size = Vector2.new(width, height)
                objects.Box.Position = Vector2.new(pos.X - width/2, headPos.Y)
                objects.Box.Visible = true
                objects.Box.Color = Color3.fromRGB(255, 255, 255)
            else
                objects.Box.Visible = false
                objects.BoxOutline.Visible = false
            end
            
            if Settings.ESP.Line then
                local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y)
                objects.Line.From = screenCenter
                objects.Line.To = Vector2.new(pos.X, pos.Y)
                objects.Line.Visible = true
                objects.Line.Color = Color3.fromRGB(255, 255, 255)
            else
                objects.Line.Visible = false
            end
            
            if Settings.ESP.Health then
                local healthPercent = math.clamp(humanoid.Health / humanoid.MaxHealth, 0, 1)
                local barHeight = height
                local barWidth = 4
                
                objects.HealthBarBg.Size = Vector2.new(barWidth + 2, barHeight + 2)
                objects.HealthBarBg.Position = Vector2.new(pos.X - width/2 - 12, headPos.Y - 1)
                objects.HealthBarBg.Visible = true
                
                local healthHeight = barHeight * healthPercent
                objects.HealthBar.Size = Vector2.new(barWidth, healthHeight)
                objects.HealthBar.Position = Vector2.new(pos.X - width/2 - 11, headPos.Y + barHeight - healthHeight)
                objects.HealthBar.Color = Color3.fromRGB(0, 255, 0)
                objects.HealthBar.Visible = true
            else
                objects.HealthBar.Visible = false
                objects.HealthBarBg.Visible = false
            end
            
            if Settings.ESP.Name then
                objects.Name.Text = player.Name
                objects.Name.Position = Vector2.new(pos.X, legPos.Y + 5)
                objects.Name.Visible = true
                objects.Name.Color = Color3.fromRGB(255, 255, 255)
            else
                objects.Name.Visible = false
            end
            
            if Settings.ESP.Armor then
                local armorValue = 100
                if humanoid:FindFirstChild("Armor") then
                    armorValue = humanoid.Armor.Value
                end
                local armorPercent = math.clamp(armorValue / 100, 0, 1)
                local barHeight = height * 0.8
                local barWidth = 4
                
                objects.ArmorBg.Size = Vector2.new(barWidth + 2, barHeight + 2)
                objects.ArmorBg.Position = Vector2.new(pos.X + width/2 + 6, headPos.Y + (height - barHeight)/2 - 1)
                objects.ArmorBg.Visible = true
                
                local armorHeight = barHeight * armorPercent
                objects.Armor.Size = Vector2.new(barWidth, armorHeight)
                objects.Armor.Position = Vector2.new(pos.X + width/2 + 7, headPos.Y + (height - barHeight)/2 + barHeight - armorHeight)
                objects.Armor.Color = Color3.fromRGB(0, 100, 255)
                objects.Armor.Visible = true
            else
                objects.Armor.Visible = false
                objects.ArmorBg.Visible = false
            end
            
            if Settings.ESP.Chams then
                for _, cham in ipairs(objects.Chams) do
                    cham.Visible = true
                end
            else
                for _, cham in ipairs(objects.Chams) do
                    cham.Visible = false
                end
            end
        end
    end
end

-- Noclip
local function UpdateNoclip()
    if Settings.Noclip then
        if not NoclipConnection then
            NoclipConnection = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        end
    else
        if NoclipConnection then
            NoclipConnection:Disconnect()
            NoclipConnection = nil
            if LocalPlayer.Character then
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end
    end
end

-- Fly
local FlyBodyGyro = nil
local FlyBodyVelocity = nil

local function UpdateFly()
    if Settings.Fly then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LocalPlayer.Character.HumanoidRootPart
            
            if not FlyBodyGyro then
                FlyBodyGyro = Instance.new("BodyGyro")
                FlyBodyGyro.P = 9e4
                FlyBodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
                FlyBodyGyro.CFrame = hrp.CFrame
                FlyBodyGyro.Parent = hrp
            end
            
            if not FlyBodyVelocity then
                FlyBodyVelocity = Instance.new("BodyVelocity")
                FlyBodyVelocity.Velocity = Vector3.new(0, 0, 0)
                FlyBodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
                FlyBodyVelocity.Parent = hrp
            end
            
            if not FlyConnection then
                FlyConnection = RunService.RenderStepped:Connect(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and FlyBodyGyro and FlyBodyVelocity then
                        local hrp = LocalPlayer.Character.HumanoidRootPart
                        local camera = workspace.CurrentCamera
                        
                        local moveDirection = Vector3.new(0, 0, 0)
                        
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
                            moveDirection = moveDirection + camera.CFrame.LookVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
                            moveDirection = moveDirection - camera.CFrame.LookVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
                            moveDirection = moveDirection - camera.CFrame.RightVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
                            moveDirection = moveDirection + camera.CFrame.RightVector
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
                            moveDirection = moveDirection + Vector3.new(0, 1, 0)
                        end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
                            moveDirection = moveDirection - Vector3.new(0, 1, 0)
                        end
                        
                        if moveDirection.Magnitude > 0 then
                            moveDirection = moveDirection.Unit * Settings.FlySpeed
                        end
                        
                        FlyBodyVelocity.Velocity = moveDirection
                        FlyBodyGyro.CFrame = camera.CFrame
                    end
                end)
            end
        end
    else
        if FlyConnection then
            FlyConnection:Disconnect()
            FlyConnection = nil
        end
        if FlyBodyGyro then
            FlyBodyGyro:Destroy()
            FlyBodyGyro = nil
        end
        if FlyBodyVelocity then
            FlyBodyVelocity:Destroy()
            FlyBodyVelocity = nil
        end
    end
end

-- Speed
local function UpdateSpeed()
    if Settings.Speed then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character.Humanoid
            humanoid.WalkSpeed = Settings.SpeedValue
            
            if not SpeedConnection then
                SpeedConnection = RunService.RenderStepped:Connect(function()
                    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and Settings.Speed then
                        local humanoid = LocalPlayer.Character.Humanoid
                        local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        
                        if hrp then
                            local moveDirection = humanoid.MoveDirection
                            if moveDirection.Magnitude > 0 then
                                hrp.Velocity = moveDirection * Settings.SpeedValue
                            end
                        end
                    end
                end)
            end
        end
    else
        if SpeedConnection then
            SpeedConnection:Disconnect()
            SpeedConnection = nil
        end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            LocalPlayer.Character.Humanoid.WalkSpeed = 16
        end
    end
end

-- GOD MODE FUNCTION
local function UpdateGodMode()
    if Settings.GodMode then
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character.Humanoid
            
            -- Set max health to very high
            humanoid.MaxHealth = math.huge
            humanoid.Health = math.huge
            
            -- Connect to health changed to prevent damage
            if not GodModeConnection then
                GodModeConnection = humanoid.HealthChanged:Connect(function()
                    if Settings.GodMode then
                        humanoid.Health = humanoid.MaxHealth
                    end
                end)
            end
            
            -- Also prevent death
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end
    else
        if GodModeConnection then
            GodModeConnection:Disconnect()
            GodModeConnection = nil
        end
        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local humanoid = LocalPlayer.Character.Humanoid
            humanoid.MaxHealth = 100
            humanoid.Health = 100
            humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        end
    end
end

-- Cleanup
Players.PlayerRemoving:Connect(function(player)
    if ESPObjects[player] then
        for _, line in ipairs(ESPObjects[player].Skeleton) do
            line:Remove()
        end
        if ESPObjects[player].Box then ESPObjects[player].Box:Remove() end
        if ESPObjects[player].BoxOutline then ESPObjects[player].BoxOutline:Remove() end
        if ESPObjects[player].Line then ESPObjects[player].Line:Remove() end
        if ESPObjects[player].HealthBar then ESPObjects[player].HealthBar:Remove() end
        if ESPObjects[player].HealthBarBg then ESPObjects[player].HealthBarBg:Remove() end
        if ESPObjects[player].Name then ESPObjects[player].Name:Remove() end
        if ESPObjects[player].Armor then ESPObjects[player].Armor:Remove() end
        if ESPObjects[player].ArmorBg then ESPObjects[player].ArmorBg:Remove() end
        for _, cham in ipairs(ESPObjects[player].Chams) do
            cham:Destroy()
        end
        ESPObjects[player] = nil
    end
end)

-- Main Loop
RunService.RenderStepped:Connect(function()
    if Settings.Aimbot and RightMouseDown then
        if not AimbotTarget then
            AimbotTarget = GetClosestPlayerToMouse()
        end
        
        if AimbotTarget and AimbotTarget.Character and AimbotTarget.Character:FindFirstChild("Head") then
            local targetHead = AimbotTarget.Character.Head
            Camera.CFrame = CFrame.new(Camera.CFrame.Position, targetHead.Position)
        else
            AimbotTarget = nil
        end
    else
        AimbotTarget = nil
    end
    
    UpdateHitboxes()
    UpdateESP()
    UpdateNoclip()
    UpdateFly()
    UpdateSpeed()
    UpdateGodMode()
end)

for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        CreateESPObject(player)
    end
end

print("392 GUI - Ingresa la key: 392")