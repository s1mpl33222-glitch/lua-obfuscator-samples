-- // YGHT HUB [Arena FPS] - Versão Definitiva com Player Mods, Configs AntiAFK, AutoFarm, AimHeadShot Gigante Invisível & Radar
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- // 1. TELA DE CARREGAMENTO ESTILIZADA (BASEADA NO DESIGN HTML NEON)
local LoadScreen = Instance.new("ScreenGui")
LoadScreen.Name = "YGHT_Loading"
pcall(function() LoadScreen.Parent = CoreGui end)
if not LoadScreen.Parent then LoadScreen.Parent = LocalPlayer:WaitForChild("PlayerGui") end
LoadScreen.IgnoreGuiInset = true

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(1, 0, 1, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(5, 2, 10)
MainFrame.Parent = LoadScreen

local GlowGradient = Instance.new("UIGradient")
GlowGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(20, 5, 40)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(3, 2, 5))
})
GlowGradient.Rotation = 45
GlowGradient.Parent = MainFrame

local HubContainer = Instance.new("Frame")
HubContainer.Size = UDim2.new(0, 420, 0, 260)
HubContainer.Position = UDim2.new(0.5, -210, 0.5, -130)
HubContainer.BackgroundColor3 = Color3.fromRGB(15, 5, 29)
HubContainer.BackgroundTransparency = 0.35
HubContainer.BorderSizePixel = 0
HubContainer.Parent = MainFrame

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 16)
UICorner.Parent = HubContainer

local UIStroke = Instance.new("UIStroke")
UIStroke.Color = Color3.fromRGB(187, 0, 255)
UIStroke.Transparency = 0.7
UIStroke.Thickness = 1.5
UIStroke.Parent = HubContainer

-- Top Bar (Tag Online)
local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, -50, 0, 30)
TopBar.Position = UDim2.new(0, 25, 0, 20)
TopBar.BackgroundTransparency = 1
TopBar.Parent = HubContainer

local StatusTag = Instance.new("Frame")
StatusTag.Size = UDim2.new(0, 85, 0, 24)
StatusTag.Position = UDim2.new(1, -85, 0, 0)
StatusTag.BackgroundColor3 = Color3.fromRGB(187, 0, 255)
StatusTag.BackgroundTransparency = 0.9
StatusTag.BorderSizePixel = 0
StatusTag.Parent = TopBar

local TagCorner = Instance.new("UICorner")
TagCorner.CornerRadius = UDim.new(1, 0)
TagCorner.Parent = StatusTag

local TagStroke = Instance.new("UIStroke")
TagStroke.Color = Color3.fromRGB(187, 0, 255)
TagStroke.Transparency = 0.6
TagStroke.Parent = StatusTag

local StatusDot = Instance.new("Frame")
StatusDot.Size = UDim2.new(0, 8, 0, 8)
StatusDot.Position = UDim2.new(0, 10, 0.5, -4)
StatusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 136)
StatusDot.BorderSizePixel = 0
StatusDot.Parent = StatusTag

local DotCorner = Instance.new("UICorner")
DotCorner.CornerRadius = UDim.new(1, 0)
DotCorner.Parent = StatusDot

local OnlineText = Instance.new("TextLabel")
OnlineText.Size = UDim2.new(1, -20, 1, 0)
OnlineText.Position = UDim2.new(0, 20, 0, 0)
OnlineText.BackgroundTransparency = 1
OnlineText.Font = Enum.Font.GothamBold
OnlineText.Text = "ONLINE"
OnlineText.TextColor3 = Color3.fromRGB(233, 213, 255)
OnlineText.TextSize = 10
OnlineText.Parent = StatusTag

-- Título Principal com Ícone Real
local TitleIcon = Instance.new("ImageLabel")
TitleIcon.Size = UDim2.new(0, 24, 0, 24)
TitleIcon.Position = UDim2.new(0, 45, 0, 63)
TitleIcon.BackgroundTransparency = 1
TitleIcon.Image = "rbxassetid://6034292275"
TitleIcon.ImageColor3 = Color3.fromRGB(240, 171, 252)
TitleIcon.Parent = HubContainer

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.Position = UDim2.new(0, 25, 0, 55)
Title.BackgroundTransparency = 1
Title.Font = Enum.Font.GothamBold
Title.Text = "YGHT HUB"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 26
Title.Parent = HubContainer

local SubTitle = Instance.new("TextLabel")
SubTitle.Size = UDim2.new(1, 0, 0, 20)
SubTitle.Position = UDim2.new(0, 0, 0, 95)
SubTitle.BackgroundTransparency = 1
SubTitle.Font = Enum.Font.GothamMedium
SubTitle.Text = "SISTEMA DE CARREGAMENTO V2"
SubTitle.TextColor3 = Color3.fromRGB(168, 85, 247)
SubTitle.TextSize = 12
SubTitle.Parent = HubContainer

-- Info de Progresso & Porcentagem
local ProgressInfo = Instance.new("Frame")
ProgressInfo.Size = UDim2.new(1, -60, 0, 25)
ProgressInfo.Position = UDim2.new(0, 30, 0, 135)
ProgressInfo.BackgroundTransparency = 1
ProgressInfo.Parent = HubContainer

local StatusText = Instance.new("TextLabel")
StatusText.Size = UDim2.new(0.7, 0, 1, 0)
StatusText.BackgroundTransparency = 1
StatusText.Font = Enum.Font.Gotham
StatusText.Text = "A iniciar..."
StatusText.TextColor3 = Color3.fromRGB(192, 132, 252)
StatusText.TextSize = 12
StatusText.TextXAlignment = Enum.TextXAlignment.Left
StatusText.Parent = ProgressInfo

local PercentageText = Instance.new("TextLabel")
PercentageText.Size = UDim2.new(0.3, 0, 1, 0)
PercentageText.Position = UDim2.new(0.7, 0, 0, 0)
PercentageText.BackgroundTransparency = 1
PercentageText.Font = Enum.Font.GothamBold
PercentageText.Text = "0%"
PercentageText.TextColor3 = Color3.fromRGB(240, 171, 252)
PercentageText.TextSize = 16
PercentageText.TextXAlignment = Enum.TextXAlignment.Right
PercentageText.Parent = ProgressInfo

-- Barra de Progresso Estilizada
local BarBackground = Instance.new("Frame")
BarBackground.Size = UDim2.new(1, -60, 0, 12)
BarBackground.Position = UDim2.new(0, 30, 0, 170)
BarBackground.BackgroundColor3 = Color3.fromRGB(20, 5, 35)
BarBackground.BorderSizePixel = 0
BarBackground.Parent = HubContainer

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1, 0)
BarCorner.Parent = BarBackground

local BarStroke = Instance.new("UIStroke")
BarStroke.Color = Color3.fromRGB(168, 85, 247)
BarStroke.Transparency = 0.7
BarStroke.Parent = BarBackground

local BarFill = Instance.new("Frame")
BarFill.Size = UDim2.new(0, 0, 1, 0)
BarFill.BackgroundColor3 = Color3.fromRGB(192, 132, 252)
BarFill.BorderSizePixel = 0
BarFill.Parent = BarBackground

local FillGradient = Instance.new("UIGradient")
FillGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(126, 34, 206)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(240, 171, 252))
})
FillGradient.Parent = BarFill

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1, 0)
FillCorner.Parent = BarFill

-- Rodapé com Ícones Reais
local HubFooter = Instance.new("Frame")
HubFooter.Size = UDim2.new(1, 0, 0, 20)
HubFooter.Position = UDim2.new(0, 0, 0, 215)
HubFooter.BackgroundTransparency = 1
HubFooter.Parent = HubContainer

local LockIcon = Instance.new("ImageLabel")
LockIcon.Size = UDim2.new(0, 14, 0, 14)
LockIcon.Position = UDim2.new(0.25, -15, 0, 3)
LockIcon.BackgroundTransparency = 1
LockIcon.Image = "rbxassetid://6023426915"
LockIcon.ImageColor3 = Color3.fromRGB(126, 34, 206)
LockIcon.Parent = HubFooter

local FooterText1 = Instance.new("TextLabel")
FooterText1.Size = UDim2.new(0, 80, 1, 0)
FooterText1.Position = UDim2.new(0.25, 5, 0, 0)
FooterText1.BackgroundTransparency = 1
FooterText1.Font = Enum.Font.Gotham
FooterText1.Text = "Protegido"
FooterText1.TextColor3 = Color3.fromRGB(126, 34, 206)
FooterText1.TextSize = 11
FooterText1.TextXAlignment = Enum.TextXAlignment.Left
FooterText1.Parent = HubFooter

local ChipIcon = Instance.new("ImageLabel")
ChipIcon.Size = UDim2.new(0, 14, 0, 14)
ChipIcon.Position = UDim2.new(0.65, -15, 0, 3)
ChipIcon.BackgroundTransparency = 1
ChipIcon.Image = "rbxassetid://6023426861"
ChipIcon.ImageColor3 = Color3.fromRGB(126, 34, 206)
ChipIcon.Parent = HubFooter

local FooterText2 = Instance.new("TextLabel")
FooterText2.Size = UDim2.new(0, 90, 1, 0)
FooterText2.Position = UDim2.new(0.65, 5, 0, 0)
FooterText2.BackgroundTransparency = 1
FooterText2.Font = Enum.Font.Gotham
FooterText2.Text = "System Ready"
FooterText2.TextColor3 = Color3.fromRGB(126, 34, 206)
FooterText2.TextSize = 11
FooterText2.TextXAlignment = Enum.TextXAlignment.Left
FooterText2.Parent = HubFooter

local loadStages = {
    {pct = 20, msg = "A carregar módulos..."},
    {pct = 50, msg = "A conectar ao servidor..."},
    {pct = 80, msg = "A verificar licença..."},
    {pct = 95, msg = "A otimizar ambiente..."},
    {pct = 100, msg = "Concluído com Sucesso!"}
}

task.spawn(function()
    local progress = 0
    while progress < 100 do
        progress = progress + math.random(1, 3)
        if progress > 100 then progress = 100 end

        BarFill.Size = UDim2.new(progress / 100, 0, 1, 0)
        PercentageText.Text = progress .. "%"

        for _, step in ipairs(loadStages) do
            if progress <= step.pct then
                StatusText.Text = step.msg
                break
            end
        end

        if progress == 100 then
            StatusText.TextColor3 = Color3.fromRGB(0, 255, 136)
            StatusText.Text = "Concluído com Sucesso!"
        end

        task.wait(0.04)
    end

    local tweenInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(MainFrame, tweenInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(HubContainer, tweenInfo, {BackgroundTransparency = 1}):Play()
    task.wait(0.6)
    LoadScreen:Destroy()
end)

task.wait(5.2)

-- // 2. CONFIGURAÇÕES & ESTADO DOS MÓDULOS
local AimbotSettings = {
    Enabled = false,
    AimLock = false,
    AimHeadShot = false, -- Nova função HeadShot Gigante Invisível
    TargetPart = "Head",
    AimTarget = "Players & Bots",
    TeamCheck = true,
    AliveCheck = true,
    WallCheck = true,
    FOVColor = Color3.fromRGB(138, 43, 226),
    FOVThickness = 1.5,
    Radius = 150,
    Visible = false,
    Smoothing = 3
}

local PlayerSettings = {
    WalkSpeed = 16,
    JumpPower = 50,
    Gravity = workspace.Gravity,
    Noclip = false
}

local ConfigSettings = {
    AntiAFK = false
}

local FarmSettings = {
    AutoFarmBot = false,
    AutoFarmPlayer = false,
    AutoFarmAll = false
}

local ESP_Settings = {
    Enabled = false,
    TeamCheck = false,
    BoxColor = Color3.fromRGB(255, 255, 255),
    LineColor = Color3.fromRGB(255, 255, 255),
    TextColor = Color3.fromRGB(255, 255, 255),
    HealthColor = Color3.fromRGB(0, 255, 0),
    RadarEnabled = false
}

local FOVCircle = Drawing.new("Circle")
FOVCircle.Color = AimbotSettings.FOVColor
FOVCircle.Thickness = AimbotSettings.FOVThickness
FOVCircle.Radius = AimbotSettings.Radius
FOVCircle.Visible = AimbotSettings.Visible
FOVCircle.Filled = false
FOVCircle.NumSides = 64

local ESP_Storage = {}

-- // 3. RADAR FLUTUANTE COMPACTO E ARRASTÁVEL
local RadarGui = Instance.new("ScreenGui")
RadarGui.Name = "YGHT_RadarGui"
pcall(function() RadarGui.Parent = CoreGui end)
if not RadarGui.Parent then RadarGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end
RadarGui.IgnoreGuiInset = true
RadarGui.Enabled = false

local RadarCard = Instance.new("Frame")
RadarCard.Size = UDim2.new(0, 230, 0, 75)
RadarCard.Position = UDim2.new(0.5, -115, 0.1, 0)
RadarCard.BackgroundColor3 = Color3.fromRGB(12, 3, 22)
RadarCard.BackgroundTransparency = 0.2
RadarCard.BorderSizePixel = 0
RadarCard.Parent = RadarGui

local RadarCorner = Instance.new("UICorner")
RadarCorner.CornerRadius = UDim.new(0, 10)
RadarCorner.Parent = RadarCard

local RadarStroke = Instance.new("UIStroke")
RadarStroke.Color = Color3.fromRGB(187, 0, 255)
RadarStroke.Transparency = 0.5
RadarStroke.Thickness = 1
RadarStroke.Parent = RadarCard

local RadarHeader = Instance.new("Frame")
RadarHeader.Size = UDim2.new(1, -16, 0, 22)
RadarHeader.Position = UDim2.new(0, 8, 0, 6)
RadarHeader.BackgroundTransparency = 1
RadarHeader.Parent = RadarCard

local RadarBrand = Instance.new("TextLabel")
RadarBrand.Size = UDim2.new(0.6, 0, 1, 0)
RadarBrand.BackgroundTransparency = 1
RadarBrand.Font = Enum.Font.GothamBold
RadarBrand.Text = "📡 RADAR"
RadarBrand.TextColor3 = Color3.fromRGB(255, 255, 255)
RadarBrand.TextSize = 11
RadarBrand.TextXAlignment = Enum.TextXAlignment.Left
RadarBrand.Parent = RadarHeader

local ROnlineText = Instance.new("TextLabel")
ROnlineText.Size = UDim2.new(0.4, 0, 1, 0)
ROnlineText.Position = UDim2.new(0.6, 0, 0, 0)
ROnlineText.BackgroundTransparency = 1
ROnlineText.Font = Enum.Font.GothamBold
ROnlineText.Text = "• ONLINE"
ROnlineText.TextColor3 = Color3.fromRGB(0, 255, 136)
ROnlineText.TextSize = 9
ROnlineText.TextXAlignment = Enum.TextXAlignment.Right
ROnlineText.Parent = RadarHeader

local TargetItemBox = Instance.new("Frame")
TargetItemBox.Size = UDim2.new(1, -16, 0, 32)
TargetItemBox.Position = UDim2.new(0, 8, 0, 33)
TargetItemBox.BackgroundColor3 = Color3.fromRGB(25, 8, 40)
TargetItemBox.BackgroundTransparency = 0.4
TargetItemBox.BorderSizePixel = 0
TargetItemBox.Parent = RadarCard

local TBoxCorner = Instance.new("UICorner")
TBoxCorner.CornerRadius = UDim.new(0, 6)
TBoxCorner.Parent = TargetItemBox

local TBoxStroke = Instance.new("UIStroke")
TBoxStroke.Color = Color3.fromRGB(168, 85, 247)
TBoxStroke.Transparency = 0.7
TBoxStroke.Parent = TargetItemBox

local WarningIcon = Instance.new("ImageLabel")
WarningIcon.Size = UDim2.new(0, 16, 0, 16)
WarningIcon.Position = UDim2.new(0, 8, 0.5, -8)
WarningIcon.BackgroundTransparency = 1
WarningIcon.Image = "rbxassetid://6031071836"
WarningIcon.ImageColor3 = Color3.fromRGB(255, 51, 102)
WarningIcon.Visible = false
WarningIcon.Parent = TargetItemBox

local TargetLabel = Instance.new("TextLabel")
TargetLabel.Size = UDim2.new(1, 0, 1, 0)
TargetLabel.Position = UDim2.new(0, 0, 0, 0)
TargetLabel.BackgroundTransparency = 1
TargetLabel.Font = Enum.Font.GothamBold
TargetLabel.Text = "[ Vazio ]"
TargetLabel.TextColor3 = Color3.fromRGB(240, 171, 252)
TargetLabel.TextSize = 11
TargetLabel.Parent = TargetItemBox

-- Sistema de Arrastar o Radar
local dragging, dragInput, dragStart, startPos
RadarCard.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = RadarCard.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
RadarCard.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        RadarCard.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- // 4. CARREGAMENTO DA WINDUI
local success, WindUI = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/main.lua"))()
end)

if not success or not WindUI then
    success, WindUI = pcall(function()
        return loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()
    end)
end

if not success or not WindUI then
    warn("[YGHT HUB]: Erro crítico ao carregar a WindUI.")
    return
end

local Window = WindUI:CreateWindow({
    Title = "YGHT HUB",
    Tag = "Arena FPS | Elite",
    Icon = "crosshair",
    Author = "YGHT Development",
    Folder = "YGHTHubMobile",
    Size = UDim2.fromOffset(480, 360),
    Transparent = false,
    Theme = "Dark",
    SideBarWidth = 140,
    HasOutline = true
})

local TabAimbot = Window:Tab({ Title = "Aimbot & Combat", Icon = "target" })
local TabVisuals = Window:Tab({ Title = "Visuals (ESP)", Icon = "eye" })
local TabPlayer = Window:Tab({ Title = "Player", Icon = "user" })
local TabConfig = Window:Tab({ Title = "Configuração", Icon = "settings" })
local TabFarm = Window:Tab({ Title = "Farm", Icon = "zap" })

local function Notify(title, content)
    pcall(function()
        WindUI:Notify({ Title = title, Content = content, Duration = 2.5 })
    end)
end

-- // ABA AIMBOT
TabAimbot:Section({ Title = "Módulos de Combate & Mira" })

TabAimbot:Toggle({
    Title = "Ativar Aimbot",
    Desc = "Rastreamento inteligente de alvos condicionado ao campo de visão ativo.",
    Value = false,
    Callback = function(state)
        AimbotSettings.Enabled = state
        Notify("Aimbot", state and "Módulo ativado." or "Módulo desativado.")
    end
})

TabAimbot:Toggle({
    Title = "AimLock Headshot Forçado",
    Desc = "Travamento rígido na cabeça (requer FOV ativo).",
    Value = false,
    Callback = function(state)
        AimbotSettings.AimLock = state
        if state then AimbotSettings.TargetPart = "Head" end
        Notify("AimLock", state and "Aimlock ativado." or "Aimlock desativado.")
    end
})

TabAimbot:Toggle({
    Title = "AimHeadShot (Cabeça Gigante Invisível)",
    Desc = "Alarga a cabeça dos alvos no FOV, remove highlights e deixa-a invisível.",
    Value = false,
    Callback = function(state)
        AimbotSettings.AimHeadShot = state
        Notify("AimHeadShot", state and "Cabeças expandidas e ocultadas ativadas." or "Modo desativado.")
    end
})

TabAimbot:Toggle({
    Title = "TeamCheck",
    Desc = "Ignora aliados.",
    Value = true,
    Callback = function(state) AimbotSettings.TeamCheck = state end
})

TabAimbot:Toggle({
    Title = "WallCheck",
    Desc = "Filtra alvos atrás de paredes.",
    Value = true,
    Callback = function(state) AimbotSettings.WallCheck = state end
})

TabAimbot:Slider({
    Title = "Smoothing",
    Step = 1,
    Value = { Min = 1, Max = 20, Default = 3 },
    Callback = function(val) AimbotSettings.Smoothing = tonumber(val) or 3 end
})

TabAimbot:Section({ Title = "Personalização FOV" })
TabAimbot:Toggle({
    Title = "Expandir Círculo FOV",
    Value = false,
    Callback = function(state)
        AimbotSettings.Visible = state
        FOVCircle.Visible = state
    end
})
TabAimbot:Slider({
    Title = "Raio do FOV",
    Step = 1,
    Value = { Min = 1, Max = 1000, Default = 150 },
    Callback = function(val)
        local num = tonumber(val)
        if num then AimbotSettings.Radius = num; FOVCircle.Radius = num end
    end
})

-- // ABA VISUALS
TabVisuals:Section({ Title = "ESP Box & Radar" })
TabVisuals:Toggle({
    Title = "Ativar ESP Box",
    Value = false,
    Callback = function(state) ESP_Settings.Enabled = state end
})
TabVisuals:Toggle({
    Title = "TeamCheck do ESP",
    Value = false,
    Callback = function(state) ESP_Settings.TeamCheck = state end
})
TabVisuals:Toggle({
    Title = "Ativar Radar de Proximidade",
    Value = false,
    Callback = function(state)
        ESP_Settings.RadarEnabled = state
        RadarGui.Enabled = state
    end
})

-- // ABA PLAYER
TabPlayer:Section({ Title = "Modificações do Jogador" })
TabPlayer:Slider({
    Title = "WalkSpeed",
    Step = 1,
    Value = { Min = 16, Max = 200, Default = 16 },
    Callback = function(val) PlayerSettings.WalkSpeed = tonumber(val) or 16 end
})
TabPlayer:Slider({
    Title = "JumpPower",
    Step = 1,
    Value = { Min = 50, Max = 300, Default = 50 },
    Callback = function(val) PlayerSettings.JumpPower = tonumber(val) or 50 end
})
TabPlayer:Slider({
    Title = "Gravity",
    Step = 10,
    Value = { Min = 0, Max = 196.2, Default = 196.2 },
    Callback = function(val) PlayerSettings.Gravity = tonumber(val) or 196.2 end
})
TabPlayer:Toggle({
    Title = "Noclip",
    Desc = "Atravessa paredes e objetos.",
    Value = false,
    Callback = function(state) PlayerSettings.Noclip = state end
})

-- // ABA CONFIGURAÇÃO
TabConfig:Section({ Title = "Configurações do Sistema" })
TabConfig:Toggle({
    Title = "Anti-AFK",
    Desc = "Previne desconexão por inatividade.",
    Value = false,
    Callback = function(state) ConfigSettings.AntiAFK = state end
})

-- // ABA FARM
TabFarm:Section({ Title = "Autofarm Automatizado" })
TabFarm:Toggle({
    Title = "AutofarmBot",
    Desc = "Teleporta para trás dos bots e atira automaticamente.",
    Value = false,
    Callback = function(state) FarmSettings.AutoFarmBot = state end
})
TabFarm:Toggle({
    Title = "AutoFarmPlayer",
    Desc = "Teleporta para trás dos players e atira automaticamente.",
    Value = false,
    Callback = function(state) FarmSettings.AutoFarmPlayer = state end
})
TabFarm:Toggle({
    Title = "AutofarmAll",
    Desc = "Teleporta para trás de qualquer alvo e atira automaticamente.",
    Value = false,
    Callback = function(state) FarmSettings.AutoFarmAll = state end
})

-- // 5. FUNÇÕES DE SUPORTE
local function IsVisible(TargetHead)
    if not AimbotSettings.WallCheck then return true end
    local Origin = Camera.CFrame.Position
    local Direction = TargetHead.Position - Origin
    local RaycastParamsExcl = RaycastParams.new()
    RaycastParamsExcl.FilterType = Enum.RaycastFilterType.Exclude
    RaycastParamsExcl.FilterDescendantsInstances = {LocalPlayer.Character, Camera}
    RaycastParamsExcl.IgnoreWater = true
    local RaycastResult = workspace:Raycast(Origin, Direction, RaycastParamsExcl)
    if not RaycastResult then return true end
    if RaycastResult.Instance:IsDescendantOf(TargetHead.Parent) then return true end
    return false
end

local function GetClosestTarget()
    local Target = nil
    local ShortestDistance = AimbotSettings.Radius
    local MousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local activePartName = AimbotSettings.AimLock and "Head" or AimbotSettings.TargetPart

    if AimbotSettings.AimTarget == "Apenas Players" or AimbotSettings.AimTarget == "Players & Bots" then
        for _, Player in pairs(Players:GetPlayers()) do
            if Player ~= LocalPlayer then
                if not AimbotSettings.TeamCheck or Player.Team ~= LocalPlayer.Team then
                    if Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild(activePartName) then
                        local Humanoid = Player.Character:FindFirstChildOfClass("Humanoid")
                        if not AimbotSettings.AliveCheck or (Humanoid and Humanoid.Health > 0) then
                            local TargetHead = Player.Character[activePartName]
                            if IsVisible(TargetHead) then
                                local ScreenPos, IsOnScreen = Camera:WorldToViewportPoint(TargetHead.Position)
                                if IsOnScreen then
                                    local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                                    if Distance < ShortestDistance then
                                        ShortestDistance = Distance
                                        Target = TargetHead
                                    end
                                end
                            end
                        end
                    end
                end
            end
        end
    end

    if AimbotSettings.AimTarget == "Apenas Bots" or AimbotSettings.AimTarget == "Players & Bots" then
        for _, v in pairs(workspace:GetDescendants()) do
            if v:IsA("Model") and v ~= LocalPlayer.Character and not Players:GetPlayerFromCharacter(v) then
                local Humanoid = v:FindFirstChildOfClass("Humanoid")
                local TargetHead = v:FindFirstChild(activePartName) or v:FindFirstChild("Head") or v:FindFirstChild("HumanoidRootPart")
                if Humanoid and Humanoid.Health > 0 and TargetHead then
                    if IsVisible(TargetHead) then
                        local ScreenPos, IsOnScreen = Camera:WorldToViewportPoint(TargetHead.Position)
                        if IsOnScreen then
                            local Distance = (Vector2.new(ScreenPos.X, ScreenPos.Y) - MousePos).Magnitude
                            if Distance < ShortestDistance then
                                ShortestDistance = Distance
                                Target = TargetHead
                            end
                        end
                    end
                end
            end
        end
    end
    return Target
end

local function hideNativeName(character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None end
end

local function isTeammate(character, isPlayer)
    if not ESP_Settings.TeamCheck then return false end
    if isPlayer then
        local player = Players:GetPlayerFromCharacter(character)
        if player and player.Team and LocalPlayer.Team and player.Team == LocalPlayer.Team then return true end
    end
    return false
end

local function CreateESP(character, isPlayer)
    if ESP_Storage[character] then return end
    hideNativeName(character)
    local Drawings = {
        Line = Drawing.new("Line"),
        Box = Drawing.new("Square"),
        NameText = Drawing.new("Text"),
        HealthText = Drawing.new("Text")
    }
    Drawings.Line.Visible = false; Drawings.Line.Thickness = 1.5; Drawings.Line.Transparency = 1
    Drawings.Box.Visible = false; Drawings.Box.Thickness = 1.5; Drawings.Box.Filled = false; Drawings.Box.Transparency = 1
    Drawings.NameText.Visible = false; Drawings.NameText.Size = 14; Drawings.NameText.Font = Drawing.Fonts.Plex; Drawings.NameText.Outline = true
    Drawings.HealthText.Visible = false; Drawings.HealthText.Size = 13; Drawings.HealthText.Font = Drawing.Fonts.Plex; Drawings.HealthText.Center = true; Drawings.HealthText.Outline = true

    ESP_Storage[character] = { Character = character, IsPlayer = isPlayer, Drawings = Drawings, Highlight = nil, OriginalHeadSize = nil }
end

local function RemoveESP(character)
    if ESP_Storage[character] then
        for _, drawing in pairs(ESP_Storage[character].Drawings) do pcall(function() drawing:Remove() end) end
        if ESP_Storage[character].Highlight then pcall(function() ESP_Storage[character].Highlight:Destroy() end) end
        ESP_Storage[character] = nil
    end
end

local function setupPlayer(player)
    if player == LocalPlayer then return end
    player.CharacterAdded:Connect(function(char) task.wait(1); CreateESP(char, true) end)
    if player.Character then CreateESP(player.Character, true) end
end

Players.PlayerAdded:Connect(setupPlayer)
for _, player in ipairs(Players:GetPlayers()) do setupPlayer(player) end
Players.PlayerRemoving:Connect(function(player) if player.Character then RemoveESP(player.Character) end end)

Workspace.DescendantAdded:Connect(function(obj)
    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
        if not Players:GetPlayerFromCharacter(obj) and obj ~= LocalPlayer.Character then task.wait(1); CreateESP(obj, false) end
    end
end)
Workspace.DescendantRemoving:Connect(function(obj) if ESP_Storage[obj] then RemoveESP(obj) end end)

for _, obj in ipairs(Workspace:GetDescendants()) do
    if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
        if not Players:GetPlayerFromCharacter(obj) and obj ~= LocalPlayer.Character then CreateESP(obj, false) end
    end
end

-- // ANTI-AFK CONEXÃO
LocalPlayer.Idled:Connect(function()
    if ConfigSettings.AntiAFK then
        VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    end
end)

-- // LOOP PRINCIPAL DE RENDERIZAÇÃO & MECÂNICAS
RunService.RenderStepped:Connect(function()
    if Camera then
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
        FOVCircle.Visible = AimbotSettings.Visible
    end

    -- 1. MODIFICAÇÕES DE PLAYER (WalkSpeed, Jump, Gravity, Noclip)
    local char = LocalPlayer.Character
    if char and char:FindFirstChild("Humanoid") and char:FindFirstChild("HumanoidRootPart") then
        local humanoid = char.Humanoid
        humanoid.WalkSpeed = PlayerSettings.WalkSpeed
        humanoid.JumpPower = PlayerSettings.JumpPower
        workspace.Gravity = PlayerSettings.Gravity

        if PlayerSettings.Noclip then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end

    -- 2. AIMBOT & AIMLOCK
    if AimbotSettings.Visible and (AimbotSettings.Enabled or AimbotSettings.AimLock) then
        local TargetPart = GetClosestTarget()
        if TargetPart then
            local TargetCFrame = CFrame.new(Camera.CFrame.Position, TargetPart.Position)
            if AimbotSettings.AimLock then
                Camera.CFrame = TargetCFrame
            elseif AimbotSettings.Enabled then
                Camera.CFrame = Camera.CFrame:Lerp(TargetCFrame, 1 / math.clamp(AimbotSettings.Smoothing, 1, 20))
            end
        end
    end

    -- 3. AUTOFARM AUTOMATIZADO (Teleporte atrás do alvo e simulação de tiro)
    if FarmSettings.AutoFarmBot or FarmSettings.AutoFarmPlayer or FarmSettings.AutoFarmAll then
        if char and char:FindFirstChild("HumanoidRootPart") then
            local myRoot = char.HumanoidRootPart
            local bestTargetRoot = nil
            local minDst = math.huge

            for c, data in pairs(ESP_Storage) do
                local rootPart = c:FindFirstChild("HumanoidRootPart")
                local hum = c:FindFirstChild("Humanoid")
                if rootPart and hum and hum.Health > 0 and not isTeammate(c, data.IsPlayer) then
                    local isBot = not data.IsPlayer
                    local isPlr = data.IsPlayer

                    local shouldFarm = false
                    if FarmSettings.AutoFarmAll then shouldFarm = true
                    elseif FarmSettings.AutoFarmBot and isBot then shouldFarm = true
                    elseif FarmSettings.AutoFarmPlayer and isPlr then shouldFarm = true end

                    if shouldFarm then
                        local dst = (rootPart.Position - myRoot.Position).Magnitude
                        if dst < minDst then
                            minDst = dst
                            bestTargetRoot = rootPart
                        end
                    end
                end
            end

            if bestTargetRoot then
                -- Posiciona logo atrás do alvo (3 studs para trás)
                myRoot.CFrame = bestTargetRoot.CFrame * CFrame.new(0, 0, 3)
                pcall(function()
                    VirtualUser:Button1Down(Vector2.new(0,0))
                    task.wait(0.05)
                    VirtualUser:Button1Up(Vector2.new(0,0))
                end)
            end
        end
    end

    -- Varredura de novos objetos/bots
    for _, obj in ipairs(Workspace:GetChildren()) do
        if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
            if not Players:GetPlayerFromCharacter(obj) and obj ~= LocalPlayer.Character then
                if not ESP_Storage[obj] then CreateESP(obj, false) else hideNativeName(obj) end
            end
        end
    end

    -- 4. RADAR DE PROXIMIDADE & HIGHLIGHT DE PERIGO
    local closestCharacter = nil
    local closestDist = math.huge
    local closestName = nil

    if ESP_Settings.RadarEnabled and char and char:FindFirstChild("HumanoidRootPart") then
        local myRoot = char.HumanoidRootPart
        for c, data in pairs(ESP_Storage) do
            local rootPart = c:FindFirstChild("HumanoidRootPart")
            local humanoid = c:FindFirstChild("Humanoid")
            if rootPart and humanoid and humanoid.Health > 0 and not isTeammate(c, data.IsPlayer) then
                local dist = math.floor((rootPart.Position - myRoot.Position).Magnitude)
                if dist < closestDist then
                    closestDist = dist
                    closestCharacter = c
                    closestName = data.IsPlayer and Players:GetPlayerFromCharacter(c).Name or c.Name
                end
            end
        end

        if closestName then
            TargetLabel.Text = string.format("[%s | metros %d]", closestName, closestDist)
            if closestDist <= 12 then
                TargetItemBox.BackgroundColor3 = Color3.fromRGB(45, 8, 25)
                TBoxStroke.Color = Color3.fromRGB(255, 51, 102)
                TargetLabel.TextColor3 = Color3.fromRGB(255, 51, 102)
                TargetLabel.Position = UDim2.new(0, 10, 0, 0)
                WarningIcon.Visible = true
            else
                TargetItemBox.BackgroundColor3 = Color3.fromRGB(25, 8, 40)
                TBoxStroke.Color = Color3.fromRGB(168, 85, 247)
                TargetLabel.TextColor3 = Color3.fromRGB(240, 171, 252)
                TargetLabel.Position = UDim2.new(0, 0, 0, 0)
                WarningIcon.Visible = false
            end
        else
            TargetLabel.Text = "[ Nenhum Alvo ]"
            TargetItemBox.BackgroundColor3 = Color3.fromRGB(25, 8, 40)
            TBoxStroke.Color = Color3.fromRGB(168, 85, 247)
            TargetLabel.TextColor3 = Color3.fromRGB(240, 171, 252)
            TargetLabel.Position = UDim2.new(0, 0, 0, 0)
            WarningIcon.Visible = false
        end
    else
        TargetLabel.Text = "[ Vazio ]"
        WarningIcon.Visible = false
        TargetLabel.Position = UDim2.new(0, 0, 0, 0)
    end

    -- 5. AIMHEADSHOT / ESP BOX & HIGHLIGHT MANAGEMENT
    for c, data in pairs(ESP_Storage) do
        local rootPart = c:FindFirstChild("HumanoidRootPart")
        local humanoid = c:FindFirstChild("Humanoid")
        local head = c:FindFirstChild("Head")

        -- Lógica da Função AimHeadShot (Cabeça Gigante, Invisível e Sem Highlight)
        if head then
            if not data.OriginalHeadSize then
                data.OriginalHeadSize = head.Size
            end

            local inRangeFOV = false
            if AimbotSettings.AimHeadShot and head then
                local screenPos, onScr = Camera:WorldToViewportPoint(head.Position)
                local mousePos = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
                if onScr and (Vector2.new(screenPos.X, screenPos.Y) - mousePos).Magnitude <= AimbotSettings.Radius then
                    inRangeFOV = true
                end
            end

            if AimbotSettings.AimHeadShot and inRangeFOV and humanoid and humanoid.Health > 0 and not isTeammate(c, data.IsPlayer) then
                head.Size = Vector3.new(12, 12, 12) -- Cabeça bem larga e gigante
                head.Transparency = 1 -- Totalmente invisível
                head.CanCollide = false
            else
                head.Size = data.OriginalHeadSize
                head.Transparency = 0
            end
        end

        -- Gerenciamento de Highlight do Radar (Perigo)
        local isDangerTarget = ESP_Settings.RadarEnabled and (c == closestCharacter) and (closestDist <= 12) and not AimbotSettings.AimHeadShot
        if isDangerTarget then
            if not data.Highlight or data.Highlight.Parent ~= c then
                if data.Highlight then data.Highlight:Destroy() end
                local Highlight = Instance.new("Highlight")
                Highlight.Name = "YGHT_Danger_Highlight"
                Highlight.FillColor = Color3.fromRGB(255, 0, 0)
                Highlight.FillTransparency = 0
                Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
                Highlight.OutlineTransparency = 0
                Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                Highlight.Parent = c
                data.Highlight = Highlight
            else
                data.Highlight.FillColor = Color3.fromRGB(255, 0, 0)
                data.Highlight.FillTransparency = 0
            end
        else
            if data.Highlight then
                data.Highlight:Destroy()
                data.Highlight = nil
            end
        end

        -- Renderização do ESP Box
        local renderActive = ESP_Settings.Enabled and rootPart and humanoid and head and humanoid.Health > 0 and not isTeammate(c, data.IsPlayer)
        if renderActive then
            local vector, onScreen = Camera:WorldToViewportPoint(rootPart.Position)
            if onScreen then
                local headVector = Camera:WorldToViewportPoint(head.Position + Vector3.new(0, 1.2, 0))
                local legVector = Camera:WorldToViewportPoint(rootPart.Position - Vector3.new(0, 4.0, 0))
                
                local boxHeight = math.abs(headVector.Y - legVector.Y)
                local boxWidth = boxHeight / 1.3

                data.Drawings.Box.Color = ESP_Settings.BoxColor
                data.Drawings.Box.Size = Vector2.new(boxWidth, boxHeight)
                data.Drawings.Box.Position = Vector2.new(vector.X - boxWidth / 2, headVector.Y)
                data.Drawings.Box.Visible = true

                data.Drawings.Line.Color = ESP_Settings.LineColor
                data.Drawings.Line.From = Vector2.new(Camera.ViewportSize.X / 2, 0)
                data.Drawings.Line.To = Vector2.new(vector.X, headVector.Y)
                data.Drawings.Line.Visible = true

                local distance = math.floor((Camera.CFrame.Position - rootPart.Position).Magnitude)
                local displayName = data.IsPlayer and Players:GetPlayerFromCharacter(c).Name or c.Name
                data.Drawings.NameText.Color = ESP_Settings.TextColor
                data.Drawings.NameText.Text = string.format("%s [%dm]", displayName, distance)
                data.Drawings.NameText.Position = Vector2.new(vector.X + (boxWidth / 2) + 6, headVector.Y)
                data.Drawings.NameText.Visible = true

                data.Drawings.HealthText.Color = ESP_Settings.HealthColor
                data.Drawings.HealthText.Text = string.format("HP: %d/%d", math.floor(humanoid.Health), math.floor(humanoid.MaxHealth))
                data.Drawings.HealthText.Position = Vector2.new(vector.X, legVector.Y + 4)
                data.Drawings.HealthText.Visible = true
                
                continue
            end
        end

        for _, drawing in pairs(data.Drawings) do drawing.Visible = false end
    end
end)

print("[YGHT HUB]: Carregado com Sucesso!")
