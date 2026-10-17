-- Script Gk Reach - Rayfield UI
-- Criador: Gk
-- Key: Gk01

-- ========== KEY SYSTEM ==========
local KEY_CORRETA = "Gk01"
local keyAceita = false

-- Criar tela de key
local keyGui = Instance.new("ScreenGui")
keyGui.Name = "GkKeySystem"
keyGui.ResetOnSpawn = false
keyGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1, 0, 1, 0)
bg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
bg.BackgroundTransparency = 0.5
bg.Parent = keyGui

local keyFrame = Instance.new("Frame")
keyFrame.Size = UDim2.new(0, 320, 0, 220)
keyFrame.Position = UDim2.new(0.5, -160, 0.5, -110)
keyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
keyFrame.BorderSizePixel = 0
keyFrame.Parent = keyGui

local kc = Instance.new("UICorner")
kc.CornerRadius = UDim.new(0, 12)
kc.Parent = keyFrame

local ks = Instance.new("UIStroke")
ks.Color = Color3.fromRGB(255, 255, 255)
ks.Thickness = 2
ks.Parent = keyFrame

local keyTitle = Instance.new("TextLabel")
keyTitle.Size = UDim2.new(1, 0, 0, 45)
keyTitle.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
keyTitle.Text = "🔐 Gk Reach - Key"
keyTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
keyTitle.Font = Enum.Font.GothamBold
keyTitle.TextSize = 16
keyTitle.Parent = keyFrame

local ktc = Instance.new("UICorner")
ktc.CornerRadius = UDim.new(0, 12)
ktc.Parent = keyTitle

local keyInfo = Instance.new("TextLabel")
keyInfo.Size = UDim2.new(1, 0, 0, 25)
keyInfo.Position = UDim2.new(0, 0, 0, 55)
keyInfo.BackgroundTransparency = 1
keyInfo.Text = "Digite a Key para acessar"
keyInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
keyInfo.Font = Enum.Font.Gotham
keyInfo.TextSize = 13
keyInfo.Parent = keyFrame

local keyBox = Instance.new("TextBox")
keyBox.Size = UDim2.new(0.85, 0, 0, 40)
keyBox.Position = UDim2.new(0.075, 0, 0, 90)
keyBox.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
keyBox.PlaceholderText = "Digite a Key..."
keyBox.Text = ""
keyBox.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBox.Font = Enum.Font.GothamBold
keyBox.TextSize = 14
keyBox.Parent = keyFrame

local kbc = Instance.new("UICorner")
kbc.CornerRadius = UDim.new(0, 8)
kbc.Parent = keyBox

local keyBtn = Instance.new("TextButton")
keyBtn.Size = UDim2.new(0.85, 0, 0, 40)
keyBtn.Position = UDim2.new(0.075, 0, 0, 145)
keyBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 0)
keyBtn.Text = "CONFIRMAR"
keyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
keyBtn.Font = Enum.Font.GothamBlack
keyBtn.TextSize = 14
keyBtn.Parent = keyFrame

local kbc2 = Instance.new("UICorner")
kbc2.CornerRadius = UDim.new(0, 8)
kbc2.Parent = keyBtn

local keyErr = Instance.new("TextLabel")
keyErr.Size = UDim2.new(1, 0, 0, 20)
keyErr.Position = UDim2.new(0, 0, 0, 195)
keyErr.BackgroundTransparency = 1
keyErr.Text = ""
keyErr.TextColor3 = Color3.fromRGB(255, 50, 50)
keyErr.Font = Enum.Font.GothamBold
keyErr.TextSize = 12
keyErr.Parent = keyFrame

local function checarKey()
    if keyBox.Text == KEY_CORRETA then
        keyAceita = true
        keyBtn.Text = "✅ KEY CORRETA!"
        keyBtn.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
        task.wait(0.5)
        keyGui:Destroy()
        print("✅ Key correta! Carregando Gk Reach...")
    else
        keyErr.Text = "❌ Key incorreta!"
        keyBox.Text = ""
    end
end

keyBtn.MouseButton1Click:Connect(checarKey)
keyBox.FocusLost:Connect(function(enter)
    if enter then checarKey() end
end)

-- Aguardar key
repeat task.wait(0.1) until keyAceita

-- ========== RAYFIELD UI ==========
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Gk Reach",
    Icon = 0,
    LoadingTitle = "Gk Reach",
    LoadingSubtitle = "by Gk",
    Theme = "Default",
    ToggleUIKeybind = Enum.KeyCode.RightControl,
    ConfigurationSaving = {
        Enabled = false,
        FolderName = nil,
        FileName = "GkReach"
    },
    KeySystem = false
})

-- ========== SERVIÇOS ==========
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local player = Players.LocalPlayer

-- ========== CONFIG ==========
local CONFIG = {
    reach = 10,
    showReachSphere = true,
    autoSecondTouch = true,
    scanCooldown = 1.5,
    ballNames = {
        "TPS", "ESA", "MRS", "PRS", "MPS", "SSS", "AIFA", "RBZ",
        "RSF", "VEF", "SAML", "VEF"
    }
}

-- ========== VARIÁVEIS ==========
local balls = {}
local lastRefresh = 0
local reachSphere
local ballSet = {}

for _, n in ipairs(CONFIG.ballNames) do
    ballSet[n] = true
end

-- ========== REFRESH BALLS ==========
local function refreshBalls(force)
    if not force and tick() - lastRefresh < CONFIG.scanCooldown then return end
    lastRefresh = tick()
    table.clear(balls)
    for _, v in ipairs(Workspace:GetDescendants()) do
        if v:IsA("BasePart") and ballSet[v.Name] then
            balls[#balls + 1] = v
        end
    end
end

-- ========== PARTES DO CORPO ==========
local function getValidParts(char)
    local parts = {}
    for _, v in ipairs(char:GetChildren()) do
        if v:IsA("BasePart") and v.Name ~= "HumanoidRootPart" then
            parts[#parts + 1] = v
        end
    end
    return parts
end

-- ========== REACH SPHERE ==========
local function updateReachSphere()
    if not CONFIG.showReachSphere then
        if reachSphere then reachSphere:Destroy() end
        reachSphere = nil
        return
    end
    if not reachSphere then
        reachSphere = Instance.new("Part")
        reachSphere.Name = "GkReachSphere"
        reachSphere.Shape = Enum.PartType.Ball
        reachSphere.Anchored = true
        reachSphere.CanCollide = false
        reachSphere.Transparency = 0.8
        reachSphere.Material = Enum.Material.ForceField
        reachSphere.Color = Color3.fromRGB(255, 255, 255)
        reachSphere.Parent = Workspace
        RunService.RenderStepped:Connect(function()
            local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                reachSphere.Position = hrp.Position
            end
        end)
    end
    reachSphere.Size = Vector3.new(CONFIG.reach * 2, CONFIG.reach * 2, CONFIG.reach * 2)
end

-- ========== AUTO TOUCH ==========
local function processTouch()
    local char = player.Character
    if not char then return end
    for _, part in ipairs(getValidParts(char)) do
        for _, ball in ipairs(balls) do
            if ball and ball.Parent then
                if (ball.Position - part.Position).Magnitude <= CONFIG.reach then
                    pcall(function()
                        firetouchinterest(ball, part, 0)
                        firetouchinterest(ball, part, 1)
                    end)
                end
            end
        end
    end
end

-- ========== LOOPS ==========
RunService.RenderStepped:Connect(function()
    if CONFIG.autoSecondTouch then
        processTouch()
    end
end)

task.spawn(function()
    while true do
        refreshBalls(false)
        task.wait(CONFIG.scanCooldown)
    end
end)

-- ========== GUI RAYFIELD ==========
local Tab = Window:CreateTab("Reach", 4483362458)

local Section = Tab:CreateSection("Configurações")

local ToggleReach = Tab:CreateToggle({
    Name = "Ativar Reach",
    CurrentValue = true,
    Flag = "ReachToggle",
    Callback = function(value)
        CONFIG.autoSecondTouch = value
        if value then
            updateReachSphere()
        else
            if reachSphere then
                reachSphere.Transparency = 1
            end
        end
    end
})

local ToggleSphere = Tab:CreateToggle({
    Name = "Mostrar Esfera do Reach",
    CurrentValue = true,
    Flag = "SphereToggle",
    Callback = function(value)
        CONFIG.showReachSphere = value
        updateReachSphere()
    end
})

local SliderReach = Tab:CreateSlider({
    Name = "Alcance do Reach",
    Range = {1, 50},
    Increment = 1,
    Suffix = " studs",
    CurrentValue = 10,
    Flag = "ReachSlider",
    Callback = function(value)
        CONFIG.reach = value
        updateReachSphere()
    end
})

local Section2 = Tab:CreateSection("Controles Rápidos")

local ButtonMenos = Tab:CreateButton({
    Name = "➖ Diminuir Reach",
    Callback = function()
        CONFIG.reach = math.max(1, CONFIG.reach - 1)
        updateReachSphere()
        Rayfield:Notify({
            Title = "Gk Reach",
            Content = "Reach: " .. CONFIG.reach,
            Duration = 2,
            Image = 4483362458
        })
    end
})

local ButtonMais = Tab:CreateButton({
    Name = "➕ Aumentar Reach",
    Callback = function()
        CONFIG.reach = CONFIG.reach + 1
        updateReachSphere()
        Rayfield:Notify({
            Title = "Gk Reach",
            Content = "Reach: " .. CONFIG.reach,
            Duration = 2,
            Image = 4483362458
        })
    end
})

-- ========== INIT ==========
refreshBalls(true)
updateReachSphere()

Rayfield:Notify({
    Title = "Gk Reach",
    Content = "✅ Script carregado com sucesso!",
    Duration = 3,
    Image = 4483362458
})

print("✅ Gk Reach carregado!")
print("🎯 Criador: Gk")
print("🔑 Key: Gk01")