-- Deobfuscated & Cleaned by sxz team
local Players = game:GetService("Players")
local ProximityPromptService = game:GetService("ProximityPromptService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local targetParent = (gethui and gethui()) or PlayerGui

-- Limpa a interface antiga se já existir no jogo
if targetParent:FindFirstChild("ZisterHubGui") then
    targetParent.ZisterHubGui:Destroy()
end

local AntiHitEnabled = false
local IsTeleporting = false
local TeleportPoints = {
    Vector3.new(500.62, 241.28, -366.64),
    Vector3.new(504.45, 155.80, -366.35),
    Vector3.new(508.30, 70.28, -366.03),
    Vector3.new(513.86, 70.28, -366.25),
    Vector3.new(519.43, 70.28, -366.47),
    Vector3.new(524.32, 70.28, -366.59),
    Vector3.new(529.22, 70.28, -366.71),
    Vector3.new(538.01, 70.28, -365.55),
    Vector3.new(546.80, 70.28, -364.40)
}

-- Criando a ScreenGui principal
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ZisterHubGui"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Global
screenGui.DisplayOrder = 1000
screenGui.Parent = targetParent

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 240, 0, 125)
mainFrame.Position = UDim2.new(0.5, -120, 0.5, -62)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
mainFrame.BackgroundTransparency = 0.6
mainFrame.BorderSizePixel = 0
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.Parent = screenGui

local uiScale = Instance.new("UIScale")
uiScale.Scale = 1.0
uiScale.Parent = mainFrame

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 10)
uiCorner.Parent = mainFrame

local uiStroke = Instance.new("UIStroke")
uiStroke.Color = Color3.fromRGB(138, 43, 226)
uiStroke.Thickness = 1.5
uiStroke.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "TitleLabel"
titleLabel.Size = UDim2.new(1, -45, 0, 35)
titleLabel.Position = UDim2.new(0, 12, 0, 2)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "KS RUB"
titleLabel.TextColor3 = Color3.fromRGB(220, 180, 255)
titleLabel.TextSize = 16
titleLabel.Font = Enum.Font.GothamBold
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = mainFrame

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -28, 0, 6)
closeBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
closeBtn.Text = "-"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.Parent = mainFrame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 6)
closeCorner.Parent = closeBtn

local tabMainBtn = Instance.new("TextButton")
tabMainBtn.Size = UDim2.new(0.5, -12, 0, 22)
tabMainBtn.Position = UDim2.new(0, 8, 0, 38)
tabMainBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
tabMainBtn.Text = "Main"
tabMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
tabMainBtn.TextSize = 12
tabMainBtn.Font = Enum.Font.GothamBold
tabMainBtn.Parent = mainFrame

local tabMainCorner = Instance.new("UICorner")
tabMainCorner.CornerRadius = UDim.new(0, 5)
tabMainCorner.Parent = tabMainBtn

local tabMiscBtn = Instance.new("TextButton")
tabMiscBtn.Size = UDim2.new(0.5, -12, 0, 22)
tabMiscBtn.Position = UDim2.new(0.5, 4, 0, 38)
tabMiscBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
tabMiscBtn.Text = "Misc"
tabMiscBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
tabMiscBtn.TextSize = 12
tabMiscBtn.Font = Enum.Font.GothamSemibold
tabMiscBtn.Parent = mainFrame

local tabMiscCorner = Instance.new("UICorner")
tabMiscCorner.CornerRadius = UDim.new(0, 5)
tabMiscCorner.Parent = tabMiscBtn

local mainTabContainer = Instance.new("Frame")
mainTabContainer.Size = UDim2.new(1, 0, 1, -68)
mainTabContainer.Position = UDim2.new(0, 0, 0, 66)
mainTabContainer.BackgroundTransparency = 1
mainTabContainer.Visible = true
mainTabContainer.Parent = mainFrame

local miscTabContainer = Instance.new("Frame")
miscTabContainer.Size = UDim2.new(1, 0, 1, -68)
miscTabContainer.Position = UDim2.new(0, 0, 0, 66)
miscTabContainer.BackgroundTransparency = 1
miscTabContainer.Visible = false
miscTabContainer.Parent = mainFrame

-- Sistema de abas
tabMainBtn.MouseButton1Click:Connect(function()
    mainTabContainer.Visible = true
    miscTabContainer.Visible = false
    tabMainBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    tabMainBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabMainBtn.Font = Enum.Font.GothamBold
    tabMiscBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    tabMiscBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
    tabMiscBtn.Font = Enum.Font.GothamSemibold
end)

tabMiscBtn.MouseButton1Click:Connect(function()
    mainTabContainer.Visible = false
    miscTabContainer.Visible = true
    tabMiscBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    tabMiscBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    tabMiscBtn.Font = Enum.Font.GothamBold
    tabMainBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    tabMainBtn.TextColor3 = Color3.fromRGB(180, 180, 200)
    tabMainBtn.Font = Enum.Font.GothamSemibold
end)

-- Minimizador do Hub
local isMinimized = false
local FULL_SIZE = mainFrame.Size
local MINI_SIZE = UDim2.new(0, 240, 0, 40)

closeBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        mainFrame.Size = MINI_SIZE
        tabMainBtn.Visible = false
        tabMiscBtn.Visible = false
        mainTabContainer.Visible = false
        miscTabContainer.Visible = false
        closeBtn.Text = "+"
    else
        mainFrame.Size = FULL_SIZE
        tabMainBtn.Visible = true
        tabMiscBtn.Visible = true
        local onMisc = tabMiscBtn.BackgroundColor3 == Color3.fromRGB(138, 43, 226)
        mainTabContainer.Visible = not onMisc
        miscTabContainer.Visible = onMisc
        closeBtn.Text = "-"
    end
end)

-- Botões das Abas
local antiHitBtn = Instance.new("TextButton")
antiHitBtn.Name = "AntiHitBtn"
antiHitBtn.Size = UDim2.new(1, -20, 0, 32)
antiHitBtn.Position = UDim2.new(0, 10, 0, 8)
antiHitBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
antiHitBtn.BackgroundTransparency = 0.2
antiHitBtn.Text = "Anti-Hit: OFF"
antiHitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
antiHitBtn.TextSize = 12
antiHitBtn.Font = Enum.Font.GothamSemibold
antiHitBtn.Parent = mainTabContainer

local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 6)
btnCorner.Parent = antiHitBtn

local scaleBtn = Instance.new("TextButton")
scaleBtn.Name = "ScaleBtn"
scaleBtn.Size = UDim2.new(1, -20, 0, 32)
scaleBtn.Position = UDim2.new(0, 10, 0, 8)
scaleBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
scaleBtn.BackgroundTransparency = 0.2
scaleBtn.Text = "GUI Scale: 1.0x"
scaleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
scaleBtn.TextSize = 12
scaleBtn.Font = Enum.Font.GothamSemibold
scaleBtn.Parent = miscTabContainer

local scaleBtnCorner = Instance.new("UICorner")
scaleBtnCorner.CornerRadius = UDim.new(0, 6)
scaleBtnCorner.Parent = scaleBtn

local scales = {0.8, 1.0, 1.2, 1.4}
local scaleIndex = 2
scaleBtn.MouseButton1Click:Connect(function()
    scaleIndex = scaleIndex + 1
    if scaleIndex > #scales then scaleIndex = 1 end
    local currentScale = scales[scaleIndex]
    uiScale.Scale = currentScale
    scaleBtn.Text = "GUI Scale: " .. currentScale .. "x"
end)

-- Overlay / Barra de carregamento
local teleportOverlay = Instance.new("Frame")
teleportOverlay.Name = "TeleportOverlay"
teleportOverlay.Size = UDim2.fromScale(1, 1)
teleportOverlay.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
teleportOverlay.BackgroundTransparency = 1
teleportOverlay.Visible = false
teleportOverlay.ZIndex = 5000
teleportOverlay.Parent = screenGui

local loadingText = Instance.new("TextLabel")
loadingText.AnchorPoint = Vector2.new(0.5, 0)
loadingText.Position = UDim2.new(0.5, 0, 0.52, 10)
loadingText.Size = UDim2.fromOffset(300, 30)
loadingText.BackgroundTransparency = 1
loadingText.Text = "anti hit almost loaded"
loadingText.TextColor3 = Color3.fromRGB(200, 160, 240)
loadingText.Font = Enum.Font.GothamBold
loadingText.TextSize = 15
loadingText.ZIndex = 5001
loadingText.Parent = teleportOverlay

local loadingBarBg = Instance.new("Frame")
loadingBarBg.AnchorPoint = Vector2.new(0.5, 0)
loadingBarBg.Position = UDim2.new(0.5, 0, 0.58, 10)
loadingBarBg.Size = UDim2.fromOffset(220, 4)
loadingBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
loadingBarBg.BorderSizePixel = 0
loadingBarBg.ZIndex = 5001
loadingBarBg.Parent = teleportOverlay

local barBgCorner = Instance.new("UICorner")
barBgCorner.CornerRadius = UDim.new(1, 0)
barBgCorner.Parent = loadingBarBg

local loadingBarFill = Instance.new("Frame")
loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
loadingBarFill.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
loadingBarFill.BorderSizePixel = 0
loadingBarFill.ZIndex = 5002
loadingBarFill.Parent = loadingBarBg

local barFillCorner = Instance.new("UICorner")
barFillCorner.CornerRadius = UDim.new(1, 0)
barFillCorner.Parent = loadingBarFill

-- Função de Teletransporte Otimizada (0.05s)
local function TeleportRoute(Character)
    if not AntiHitEnabled or not Character or not Character.Parent then return end
    
    teleportOverlay.Visible = true
    teleportOverlay.BackgroundTransparency = 0
    loadingBarFill.Size = UDim2.new(0, 0, 1, 0)
    loadingText.Text = "anti hit almost loaded"
    
    local totalPoints = #TeleportPoints

    for Index, Position in ipairs(TeleportPoints) do
        if not AntiHitEnabled then
            teleportOverlay.Visible = false
            return
        end
        
        local progress = Index / totalPoints

        TweenService:Create(
            loadingBarFill,
            TweenInfo.new(0.05),
            {Size = UDim2.new(progress, 0, 1, 0)}
        ):Play()

        Character:PivotTo(CFrame.new(Position))
        
        if Index == totalPoints then
            loadingText.Text = "anti hit loaded!"
        end
        
        task.wait(0.05)
    end
    
    local fadeOut = TweenService:Create(
        teleportOverlay,
        TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
        {BackgroundTransparency = 1}
    )

    fadeOut:Play()
    fadeOut.Completed:Wait()
    teleportOverlay.Visible = false
end

-- Ativadores e Conexões
antiHitBtn.MouseButton1Click:Connect(function()
    AntiHitEnabled = not AntiHitEnabled
    if AntiHitEnabled then
        antiHitBtn.Text = "Anti-Hit: ON"
        antiHitBtn.BackgroundColor3 = Color3.fromRGB(138, 43, 226)
    else
        antiHitBtn.Text = "Anti-Hit: OFF"
        antiHitBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 42)
    end
end)

ProximityPromptService.PromptTriggered:Connect(function(Prompt, TriggeredPlayer)
    if TriggeredPlayer ~= LocalPlayer then return end
    if not AntiHitEnabled or IsTeleporting then return end
    
    local Character = LocalPlayer.Character
    if not Character then return end
    
    IsTeleporting = true
    TeleportRoute(Character)
    IsTeleporting = false
end)