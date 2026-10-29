--[[ 
    NEYMAR HUB BR 🇧🇷 - TCS GOLD EDITION
    Key Oficial de Acesso: key1100
    Fix Definitivo: Pulo Forçado Removido do Auto Dive 🧤
--]]

if not game:IsLoaded() then game.Loaded:Wait() end

-- Limpa interfaces antigas presas
pcall(function()
    if getgenv().NeymarWindow then
        getgenv().NeymarWindow:Destroy()
    end
end)

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "👑 NEYMAR HUB GOLD 👑",
   LoadingTitle = "👑 NEYMAR HUB GOLD 👑",
   LoadingSubtitle = "O Rei do Futebol Clássico!",
   Theme = "Amber",
   DisableRayfieldPrompts = false,
   DisableBuildWarnings = true,
   ConfigurationSaving = { Enabled = false },
   KeySystem = true,
   KeySettings = {
      Title = "🔑 NEYMAR HUB - SEGURANÇA",
      Subtitle = "Digite a Key oficial para acessar",
      Note = "digitei a key", 
      FileName = "NeymarKeyReset_" .. tostring(math.random(1000, 9999)),
      SaveKey = false,
      GrabKeyFromSite = false,
      Key = {"key1100"}
   }
})

getgenv().NeymarWindow = Window

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Stats = game:GetService("Stats")

local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Variáveis das Funções do Hub
local autoDive = false
local predictEnabled = false
local CustomSpeedEnabled = false
local CustomSpeed = 16
local InfJump = false

-- Variáveis do Reach do Goleiro
local reachGKEnabled = false
local raioReachGKValue = 15

-- Variáveis do Reach de Linha
local reachLinhaEnabled = false
local raioReachLinhaValue = 12

-- Variável Visual Geral do Reach
local visualReachEnabled = false

local lastDive = 0
local lastButton = nil
local lastTime = 0
local kickCooldownEnd = 0
local gkButtons = {}
local tenhobola = false

local COOLDOWN = 0.245
local KICK_COOLDOWN = 2.0
local MIN_VELOCITY = 12
local MAX_VELOCITY = 120
local CONTROL_DISTANCE = 8
local CONTROL_VELOCITY = 25
local LOOKAHEAD = 0.35
local MAX_DIVE_DISTANCE = 18
local MIN_DIVE_DISTANCE = 1
local SIDE_MIN = 1.8
local HIGH_HEIGHT = 4.0

local GK_NAMES = {
    "High Dive Left", "High Dive Right", "Dive Left", "Dive Right",
    "High Catch", "Low Catch", "Front Dive", "Reflex"
}

-- Esfera Visual do Reach
local indicadorVisual = Instance.new("Part")
indicadorVisual.Name = "IndicadorReachVisual"
indicadorVisual.Shape = Enum.PartType.Ball
indicadorVisual.Material = Enum.Material.ForceField
indicadorVisual.Color = Color3.fromRGB(0, 255, 255)
indicadorVisual.CanCollide = false
indicadorVisual.Anchored = true
indicadorVisual.Transparency = 1
indicadorVisual.Parent = Workspace

local function getCharacter()
    local character = LocalPlayer.Character
    if not character then return nil, nil, nil end
    return character, character:FindFirstChildOfClass("Humanoid"), character:FindFirstChild("HumanoidRootPart")
end

local function obterParteGoleiro(char)
    return char:FindFirstChild("Right Arm") 
        or char:FindFirstChild("RightHand") 
        or char:FindFirstChild("Left Arm") 
        or char:FindFirstChild("LeftHand") 
        or char:FindFirstChild("UpperTorso")
        or char:FindFirstChild("HumanoidRootPart")
end

local function obterParteLinha(char)
    return char:FindFirstChild("RightFoot") 
        or char:FindFirstChild("Right Leg") 
        or char:FindFirstChild("LeftFoot") 
        or char:FindFirstChild("Left Leg") 
        or char:FindFirstChild("HumanoidRootPart")
end

local function isBall(object)
    if not object or not object:IsA("BasePart") or object.Anchored then return false end
    local character = LocalPlayer.Character
    if character and object:IsDescendantOf(character) then return false end
    local model = object:FindFirstAncestorOfClass("Model")
    if model and model:FindFirstChildOfClass("Humanoid") then return false end
    local name = object.Name:lower()
    if name == "tps" or name == "ball" or name == "bola" or name == "football" then
        local size = object.Size
        if size.X >= 0.5 and size.X <= 8 then return true end
    end
    return false
end

local function getBall()
    local _, _, root = getCharacter()
    if not root then return nil end
    local closestBall = nil
    local closestDistance = math.huge
    for _, object in ipairs(Workspace:GetDescendants()) do
        if isBall(object) then
            local distance = (object.Position - root.Position).Magnitude
            if distance < closestDistance then
                closestDistance = distance
                closestBall = object
            end
        end
    end
    return closestBall
end

local function markKick() kickCooldownEnd = tick() + KICK_COOLDOWN end

local function hookTool(tool)
    if not tool or not tool:IsA("Tool") then return end
    local name = tool.Name:lower()
    if name:find("kick") or name:find("shoot") or name:find("ball") or name:find("glove") or name:find("chute") or name:find("luva") then
        pcall(function() tool.Activated:Connect(markKick) end)
        pcall(function() tool.Unequipped:Connect(markKick) end)
        pcall(function() tool.Equipped:Connect(markKick) end)
    end
end

local function hookAllTools(container)
    if not container then return end
    for _, object in ipairs(container:GetChildren()) do hookTool(object) end
    container.ChildAdded:Connect(function(child) task.wait(0.1) hookTool(child) end)
end

hookAllTools(LocalPlayer:FindFirstChild("Backpack"))
LocalPlayer.CharacterAdded:Connect(function(character)
    task.wait(1)
    hookAllTools(LocalPlayer:FindFirstChild("Backpack"))
end)

local function scanButtons()
    gkButtons = {}
    local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
    if not playerGui then return end
    for _, object in ipairs(playerGui:GetDescendants()) do
        if object:IsA("TextButton") or object:IsA("ImageButton") then
            local text = ""
            pcall(function() text = object.Text end)
            for _, buttonName in ipairs(GK_NAMES) do
                if text:lower() == buttonName:lower() then
                    table.insert(gkButtons, { Button = object, Text = text, Name = object.Name })
                    break
                end
            end
        end
    end
end

local function findButton(text)
    for _, info in ipairs(gkButtons) do
        if info.Text:lower() == text:lower() then return info.Button end
    end
    return nil
end

local function clickButton(button)
    if not button then return false end
    pcall(function() firesignal(button.Activated) end)
    pcall(function() firesignal(button.MouseButton1Click) end)
    pcall(function() firesignal(button.MouseButton1Down) end)
    pcall(function() firesignal(button.MouseButton1Up) end)
    pcall(function() firesignal(button.TouchTap) end)
    return true
end

local function checkBallControl()
    local ball = getBall()
    local _, _, root = getCharacter()
    if not ball or not root then tenhobola = false return end
    local distance = (ball.Position - root.Position).Magnitude
    local velocity = ball.AssemblyLinearVelocity.Magnitude
    tenhobola = (distance < CONTROL_DISTANCE and velocity < CONTROL_VELOCITY)
end

-- 🧤 LÓGICA DE ANÁLISE SEM PULO FORÇADO
local function analyze()
    if tenhobola then return nil end
    local ball = getBall()
    local _, _, root = getCharacter()
    if not ball or not root then return nil end

    local velocity = ball.AssemblyLinearVelocity
    local velocityMagnitude = velocity.Magnitude
    local distance = (ball.Position - root.Position).Magnitude

    if distance > MAX_DIVE_DISTANCE or distance < MIN_DIVE_DISTANCE then return nil end
    if velocityMagnitude < MIN_VELOCITY or velocityMagnitude > MAX_VELOCITY then return nil end

    local cameraRight = Camera.CFrame.RightVector
    local right = Vector3.new(cameraRight.X, 0, cameraRight.Z).Unit

    local time = math.min(distance / velocityMagnitude, LOOKAHEAD)
    local futurePosition = ball.Position + (velocity * time)
    local referenceHeight = math.max(ball.Position.Y - root.Position.Y, futurePosition.Y - root.Position.Y)
    local isHigh = referenceHeight > HIGH_HEIGHT

    local delta = futurePosition - root.Position
    local side = delta:Dot(right)
    local absoluteSide = math.abs(side)
    local sideName = side < 0 and "Left" or "Right"

    local diveName = nil

    if distance < 5 and velocityMagnitude > 40 then
        diveName = "Reflex"
    elseif absoluteSide < SIDE_MIN then
        if isHigh then
            diveName = "High Catch"
        else
            diveName = "Front Dive"
        end
    else
        if isHigh then
            diveName = "High Dive " .. sideName
        else
            diveName = "Dive " .. sideName
        end
    end

    return { name = diveName }
end

local function executeDive()
    local info = analyze()
    if not info or not info.name then return end
    local button = findButton(info.name)
    if not button then return end
    if button == lastButton and tick() - lastTime < 0.195 then return end
    
    -- Dispara puramente o clique do botão de defesa do jogo
    clickButton(button)
    
    lastButton = button
    lastTime = tick()
end

scanButtons()

-- 🔮 BALL PREDICT REALISTA SETUP
local predictFolder = Instance.new("Folder")
predictFolder.Name = "NeymarPredictFolder"
predictFolder.Parent = Workspace

local targetSphere = Instance.new("Part")
targetSphere.Name = "PredictTarget"
targetSphere.Shape = Enum.PartType.Ball
targetSphere.Size = Vector3.new(1.8, 1.8, 1.8)
targetSphere.Material = Enum.Material.Neon
targetSphere.Color = Color3.fromRGB(255, 215, 0)
targetSphere.Anchored = true
targetSphere.CanCollide = false
targetSphere.Transparency = 1
targetSphere.Parent = predictFolder

local beamSegments = {}
local MAX_SEGMENTS = 12

for i = 1, MAX_SEGMENTS do
    local p0 = Instance.new("Part")
    p0.Size = Vector3.new(0.1, 0.1, 0.1)
    p0.Transparency = 1
    p0.Anchored = true
    p0.CanCollide = false
    p0.Parent = predictFolder

    local p1 = Instance.new("Part")
    p1.Size = Vector3.new(0.1, 0.1, 0.1)
    p1.Transparency = 1
    p1.Anchored = true
    p1.CanCollide = false
    p1.Parent = predictFolder

    local attA = Instance.new("Attachment", p0)
    local attB = Instance.new("Attachment", p1)

    local beam = Instance.new("Beam")
    beam.Width0 = 0.35
    beam.Width1 = 0.25
    beam.Color = ColorSequence.new(Color3.fromRGB(255, 215, 0))
    beam.FaceCamera = true
    beam.Attachment0 = attA
    beam.Attachment1 = attB
    beam.Enabled = false
    beam.Parent = predictFolder

    table.insert(beamSegments, {Beam = beam, Part0 = p0, Part1 = p1})
end

local function resetPredictDisplay()
    targetSphere.Transparency = 1
    for _, seg in ipairs(beamSegments) do
        seg.Beam.Enabled = false
    end
end

-- LOOPS DE EXECUÇÃO
RunService.RenderStepped:Connect(function()
    checkBallControl()
    
    -- Auto Dive Sem Pulo
    if autoDive and not tenhobola and tick() >= kickCooldownEnd and tick() - lastDive >= COOLDOWN then
        local info = analyze()
        if info then
            lastDive = tick()
            task.spawn(executeDive)
        end
    end

    -- Visual e Lógica do Reach (GK e Linha)
    local char, _, root = getCharacter()
    if char and root then
        if visualReachEnabled and (reachGKEnabled or reachLinhaEnabled) then
            local raioAtivo = reachGKEnabled and raioReachGKValue or raioReachLinhaValue
            indicadorVisual.Size = Vector3.new(raioAtivo * 2, raioAtivo * 2, raioAtivo * 2)
            indicadorVisual.Position = root.Position
            indicadorVisual.Transparency = 0.75
        else
            indicadorVisual.Transparency = 1
        end

        if reachGKEnabled then
            local parteDefesa = obterParteGoleiro(char)
            local ball = getBall()
            if parteDefesa and ball then
                local distancia = (ball.Position - root.Position).Magnitude
                if distancia <= raioReachGKValue then
                    if firetouchinterest then
                        firetouchinterest(parteDefesa, ball, 0)
                        firetouchinterest(parteDefesa, ball, 1)
                    end
                end
            end
        end

        if reachLinhaEnabled then
            local parteLinha = obterParteLinha(char)
            local ball = getBall()
            if parteLinha and ball then
                local distancia = (ball.Position - root.Position).Magnitude
                if distancia <= raioReachLinhaValue then
                    if firetouchinterest then
                        firetouchinterest(parteLinha, ball, 0)
                        firetouchinterest(parteLinha, ball, 1)
                    end
                end
            end
        end
    else
        indicadorVisual.Transparency = 1
    end

    -- Predict
    if predictEnabled then
        local ball = getBall()
        if ball and ball.AssemblyLinearVelocity.Magnitude > 3 then
            local currentPos = ball.Position
            local currentVel = ball.AssemblyLinearVelocity
            local gravity = Vector3.new(0, -Workspace.Gravity, 0)

            local totalTime = 1.4
            local stepTime = totalTime / MAX_SEGMENTS
            local simPos = currentPos
            local simVel = currentVel

            for i = 1, MAX_SEGMENTS do
                local nextPos = simPos + (simVel * stepTime) + (0.5 * gravity * (stepTime ^ 2))
                local nextVel = simVel + (gravity * stepTime)

                local raycastResult = Workspace:Raycast(simPos, nextPos - simPos)
                if raycastResult then
                    nextPos = raycastResult.Position
                    beamSegments[i].Part0.Position = simPos
                    beamSegments[i].Part1.Position = nextPos
                    beamSegments[i].Beam.Enabled = true

                    for j = i + 1, MAX_SEGMENTS do
                        beamSegments[j].Beam.Enabled = false
                    end

                    targetSphere.Position = nextPos
                    targetSphere.Transparency = 0.2
                    break
                else
                    beamSegments[i].Part0.Position = simPos
                    beamSegments[i].Part1.Position = nextPos
                    beamSegments[i].Beam.Enabled = true
                end

                simPos = nextPos
                simVel = nextVel

                if i == MAX_SEGMENTS then
                    targetSphere.Position = nextPos
                    targetSphere.Transparency = 0.2
                end
            end
        else
            resetPredictDisplay()
        end
    else
        resetPredictDisplay()
    end

    if CustomSpeedEnabled and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local humanoid = LocalPlayer.Character.Humanoid
        local hrp = LocalPlayer.Character.HumanoidRootPart
        if humanoid.MoveDirection.Magnitude > 0 then
            hrp.CFrame = hrp.CFrame + (humanoid.MoveDirection * (CustomSpeed / 100))
        end
    end
end)

UserInputService.JumpRequest:Connect(function()
    if InfJump and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.Velocity = Vector3.new(LocalPlayer.Character.HumanoidRootPart.Velocity.X, 45, LocalPlayer.Character.HumanoidRootPart.Velocity.Z)
    end
end)

-- 🏠 ABA 1: TELA INICIAL
local HomeTab = Window:CreateTab("🏠 Início", 4483362458)
HomeTab:CreateSection("👑 NEYMAR HUB - GOLD EDITION 👑")
HomeTab:CreateParagraph({
    Title = "👑 BEM-VINDO AO NEYMAR HUB!",
    Content = "──────────────────────────\n⚡ O Script definitivo de Futebol Clássico (TCS)!\n⚽ Auto Dive 100% Limpo (Sem Pulos), Predict & Reach.\n──────────────────────────"
})

-- 🛡️ ABA 2: PAREDÃO GK
local GKTab = Window:CreateTab("🛡️ Paredão GK", 4483362458)
GKTab:CreateSection("🧤 Defesa Automática de Elite")
GKTab:CreateToggle({
   Name = "🔥 Ativar Auto Dive (Paredão)",
   CurrentValue = false,
   Flag = "AutoDiveToggle",
   Callback = function(Value)
      autoDive = Value
      if Value then
          Rayfield:Notify({ Title = "🛡️ AUTO DIVE ATIVADO!", Content = "Goleiro acionando botões de defesa sem pulo automático!", Duration = 3 })
      end
   end,
})

-- 🎯 ABA 3: REACH (GK & LINHA)
local ReachTab = Window:CreateTab("🎯 Reach", 4483362458)

ReachTab:CreateSection("🧤 Reach de Goleiro (Luvas)")
ReachTab:CreateToggle({
   Name = "🎯 Ativar Reach do Goleiro",
   CurrentValue = false,
   Flag = "ReachGKToggle",
   Callback = function(Value) reachGKEnabled = Value end,
})
ReachTab:CreateSlider({
   Name = "Raio Reach GK (Studs)",
   Range = {5, 30},
   Increment = 1,
   Suffix = " Studs",
   CurrentValue = 15,
   Flag = "ReachGKSlider",
   Callback = function(Value) raioReachGKValue = Value end,
})

ReachTab:CreateSection("⚽ Reach de Jogador de Linha (Pés)")
ReachTab:CreateToggle({
   Name = "🎯 Ativar Reach de Linha",
   CurrentValue = false,
   Flag = "ReachLinhaToggle",
   Callback = function(Value) reachLinhaEnabled = Value end,
})
ReachTab:CreateSlider({
   Name = "Raio Reach Linha (Studs)",
   Range = {5, 30},
   Increment = 1,
   Suffix = " Studs",
   CurrentValue = 12,
   Flag = "ReachLinhaSlider",
   Callback = function(Value) raioReachLinhaValue = Value end,
})

ReachTab:CreateSection("👁️ Configurações Visuais")
ReachTab:CreateToggle({
   Name = "👁️ Ver Esfera de Alcance",
   CurrentValue = false,
   Flag = "VisualReachToggle",
   Callback = function(Value) visualReachEnabled = Value end,
})

-- 🔮 ABA 4: BALL PREDICT REALISTA
local PredictTab = Window:CreateTab("🔮 Predict", 4483362458)
PredictTab:CreateSection("⚽ Trajetória Curvada da Bola")
PredictTab:CreateToggle({
   Name = "🔮 Ativar Ball Predict Realista",
   CurrentValue = false,
   Flag = "PredictToggle",
   Callback = function(Value) predictEnabled = Value end,
})

-- 🏃 ABA 5: ATLETA
local PlayerTab = Window:CreateTab("🏃 Atleta", 4483362458)
PlayerTab:CreateSection("⚡ Velocidade & Pulo")
PlayerTab:CreateToggle({
   Name = "🏃 Super Velocidade",
   CurrentValue = false,
   Flag = "SpeedToggle",
   Callback = function(Value) CustomSpeedEnabled = Value end,
})
PlayerTab:CreateSlider({
   Name = "Nível da Velocidade",
   Range = {16, 45},
   Increment = 1,
   Suffix = " Speed",
   CurrentValue = 16,
   Flag = "SpeedTCS",
   Callback = function(Value) CustomSpeed = Value end,
})
PlayerTab:CreateToggle({
   Name = "🚀 Pulo Infinito",
   CurrentValue = false,
   Flag = "InfJumpTCS",
   Callback = function(Value) InfJump = Value end,
})

Rayfield:Notify({
   Title = "👑 NEYMAR HUB GOLD 👑",
   Content = "Script carregado com sucesso!",
   Duration = 5
})
