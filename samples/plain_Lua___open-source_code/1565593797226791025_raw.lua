-- ====================================================================
-- MTW HUB - Versão Rayfield
-- ====================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

-- Rayfield
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Configurações de Estado
local AutoFollowEnabled = false
local ReachEnabled = false
local ReachDistance = 3.5

local TargetCenter = Vector3.new(0, -28.94, 0)
local CenterTolerance = 3.5
local CachedBall = nil
local FollowStopDistance = 1.6

local function UpdateCharacter(newChar)
    Character = newChar
    Humanoid = newChar:WaitForChild("Humanoid")
    RootPart = newChar:WaitForChild("HumanoidRootPart")
end
LocalPlayer.CharacterAdded:Connect(UpdateCharacter)

-- ====================================================================
-- DETECTOR DA BOLA TPS
-- ====================================================================
local function GetValidBall()
    if CachedBall and CachedBall.Parent and CachedBall.Name == "TPS" then
        local isAtCenter = (CachedBall.Position - TargetCenter).Magnitude <= CenterTolerance
        if not isAtCenter then return CachedBall end
    end

    for _, obj in ipairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") and obj.Name == "TPS" then
            local size = obj.Size
            local isCorrectSize = (size.X >= 1.0 and size.X <= 4.0)
            local isAtCenter = (obj.Position - TargetCenter).Magnitude <= CenterTolerance
            if isCorrectSize and not isAtCenter then
                CachedBall = obj
                return obj
            end
        end
    end
    return nil
end

-- ====================================================================
-- INTERCEPTADOR ANTI-BUG
-- ====================================================================
local rawnamecall
rawnamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    local args = {...}

    if not checkcaller() and self == Humanoid and (method == "MoveTo" or method == "moveTo") then
        local targetPos = args[1]
        if typeof(targetPos) == "Vector3" then
            if (targetPos - TargetCenter).Magnitude <= CenterTolerance or targetPos == Vector3.zero then
                return nil
            end
        end
    end

    return rawnamecall(self, ...)
end)

-- ====================================================================
-- LOOPS AUTO FOLLOW E REACH
-- ====================================================================
local function IsManualInputActive()
    return UserInputService:IsKeyDown(Enum.KeyCode.W) or 
           UserInputService:IsKeyDown(Enum.KeyCode.A) or 
           UserInputService:IsKeyDown(Enum.KeyCode.S) or 
           UserInputService:IsKeyDown(Enum.KeyCode.D)
end

RunService.PreRender:Connect(function()
    if not RootPart or not RootPart.Parent or not Humanoid then return end
    local ball = GetValidBall()

    if AutoFollowEnabled and not IsManualInputActive() and ball then
        local targetPos = ball.Position

        if (targetPos - TargetCenter).Magnitude > CenterTolerance then
            local delta = targetPos - RootPart.Position
            local moveDirection = Vector3.new(delta.X, 0, delta.Z)

            if moveDirection.Magnitude > FollowStopDistance then
                Humanoid:Move(moveDirection.Unit, false)
                RootPart.CFrame = CFrame.new(RootPart.Position, Vector3.new(targetPos.X, RootPart.Position.Y, targetPos.Z))
            else
                Humanoid:Move(Vector3.zero, false)
            end
        else
            Humanoid:Move(Vector3.zero, false)
        end
    end

    if ReachEnabled and ball then
        local distance = (ball.Position - RootPart.Position).Magnitude
        local reachStuds = ReachDistance * 4.2

        if distance <= reachStuds then
            firetouchinterest(RootPart, ball, 0)
            firetouchinterest(RootPart, ball, 1)
            
            local leftFoot = Character:FindFirstChild("Left Foot") or Character:FindFirstChild("Left Leg")
            local rightFoot = Character:FindFirstChild("Right Foot") or Character:FindFirstChild("Right Leg")
            
            if leftFoot then
                firetouchinterest(leftFoot, ball, 0)
                firetouchinterest(leftFoot, ball, 1)
            end
            if rightFoot then
                firetouchinterest(rightFoot, ball, 0)
                firetouchinterest(rightFoot, ball, 1)
            end
        end
    end
end)

-- ====================================================================
-- RAYFIELD UI - MTW HUB
-- ====================================================================
local Window = Rayfield:CreateWindow({
    Name = "MTW HUB",
    Icon = 0,
    LoadingTitle = "MTW HUB",
    LoadingSubtitle = "by @provermos",
    Theme = "Dark",
    DisableRayfieldPrompts = false,
    DisableBuildWarnings = false,
    ConfigurationSaving = {
        Enabled = false,
        FolderName = "MTWHub",
        FileName = "Config"
    },
    Discord = {
        Enabled = false,
        Invite = "",
        RememberJoins = true
    },
    KeySystem = false
})

-- ====================================================================
-- ABA: AUTO FOLLOW
-- ====================================================================
local TabFollow = Window:CreateTab("Auto Follow", 4483362458)

local FollowSection = TabFollow:CreateSection("Auto Follow")

TabFollow:CreateToggle({
    Name = "Ativar Auto Follow",
    CurrentValue = false,
    Flag = "AutoFollowToggle",
    Callback = function(Value)
        AutoFollowEnabled = Value
        if not Value and Humanoid then
            Humanoid:Move(Vector3.zero, false)
        end
    end,
})

TabFollow:CreateButton({
    Name = "Mostrar/Ocultar Botão Flutuante",
    Callback = function()
        if FloatButton then
            FloatButton.Visible = not FloatButton.Visible
        end
    end,
})

-- ====================================================================
-- ABA: REACH
-- ====================================================================
local TabReach = Window:CreateTab("Reach", 4483362458)

local ReachSection = TabReach:CreateSection("Reach")

TabReach:CreateToggle({
    Name = "Ativar Reach",
    CurrentValue = false,
    Flag = "ReachToggle",
    Callback = function(Value)
        ReachEnabled = Value
    end,
})

TabReach:CreateSlider({
    Name = "Distância do Reach",
    Range = {1, 10},
    Increment = 0.5,
    Suffix = "m",
    CurrentValue = 3.5,
    Flag = "ReachSlider",
    Callback = function(Value)
        ReachDistance = Value
    end,
})

-- ====================================================================
-- ABA: BOLA
-- ====================================================================
local TabBall = Window:CreateTab("Bola", 4483362458)

local BallSection = TabBall:CreateSection("Cores da Bola")

TabBall:CreateButton({
    Name = "🔴 Vermelho Neon",
    Callback = function()
        local ball = GetValidBall()
        if ball then 
            ball.Color = Color3.fromRGB(255, 40, 40)
            ball.Material = Enum.Material.Neon
        end
    end,
})

TabBall:CreateButton({
    Name = "🔵 Azul Cyan",
    Callback = function()
        local ball = GetValidBall()
        if ball then 
            ball.Color = Color3.fromRGB(0, 230, 255)
            ball.Material = Enum.Material.Neon
        end
    end,
})

TabBall:CreateButton({
    Name = "🟢 Verde Neon",
    Callback = function()
        local ball = GetValidBall()
        if ball then 
            ball.Color = Color3.fromRGB(50, 255, 50)
            ball.Material = Enum.Material.Neon
        end
    end,
})

TabBall:CreateButton({
    Name = "🟡 Amarelo Neon",
    Callback = function()
        local ball = GetValidBall()
        if ball then 
            ball.Color = Color3.fromRGB(255, 230, 30)
            ball.Material = Enum.Material.Neon
        end
    end,
})

TabBall:CreateButton({
    Name = "🟣 Roxo Neon",
    Callback = function()
        local ball = GetValidBall()
        if ball then 
            ball.Color = Color3.fromRGB(170, 50, 255)
            ball.Material = Enum.Material.Neon
        end
    end,
})

TabBall:CreateButton({
    Name = "⚪ Branco Puro",
    Callback = function()
        local ball = GetValidBall()
        if ball then 
            ball.Color = Color3.fromRGB(255, 255, 255)
            ball.Material = Enum.Material.Neon
        end
    end,
})

TabBall:CreateButton({
    Name = "⬛ Preto",
    Callback = function()
        local ball = GetValidBall()
        if ball then 
            ball.Color = Color3.fromRGB(15, 15, 15)
            ball.Material = Enum.Material.SmoothPlastic
        end
    end,
})

TabBall:CreateButton({
    Name = "💎 Ciano Neon",
    Callback = function()
        local ball = GetValidBall()
        if ball then 
            ball.Color = Color3.fromRGB(0, 255, 255)
            ball.Material = Enum.Material.Neon
        end
    end,
})

TabBall:CreateButton({
    Name = "💗 Rosa Neon",
    Callback = function()
        local ball = GetValidBall()
        if ball then 
            ball.Color = Color3.fromRGB(255, 80, 200)
            ball.Material = Enum.Material.Neon
        end
    end,
})

TabBall:CreateButton({
    Name = "🥇 Dourado",
    Callback = function()
        local ball = GetValidBall()
        if ball then 
            ball.Color = Color3.fromRGB(255, 215, 0)
            ball.Material = Enum.Material.Neon
        end
    end,
})

local BallEffectSection = TabBall:CreateSection("Efeitos")

TabBall:CreateToggle({
    Name = "Efeito Fogo",
    CurrentValue = false,
    Flag = "FireToggle",
    Callback = function(Value)
        local ball = GetValidBall()
        if ball then
            local fire = ball:FindFirstChildOfClass("Fire")
            if Value then
                if not fire then
                    local newFire = Instance.new("Fire")
                    newFire.Size = 6
                    newFire.Parent = ball
                end
            else
                if fire then fire:Destroy() end
            end
        end
    end,
})

TabBall:CreateButton({
    Name = "🌟 Sparkles",
    Callback = function()
        local ball = GetValidBall()
        if ball then
            local s = Instance.new("Sparkles")
            s.SparkleColor = Color3.fromRGB(255, 255, 255)
            s.Parent = ball
        end
    end,
})

TabBall:CreateButton({
    Name = "🧹 Limpar Efeitos",
    Callback = function()
        local ball = GetValidBall()
        if ball then
            for _, child in pairs(ball:GetChildren()) do
                if child:IsA("Fire") or child:IsA("Sparkles") or child:IsA("Smoke") then
                    child:Destroy()
                end
            end
            ball.Material = Enum.Material.SmoothPlastic
        end
    end,
})

-- ====================================================================
-- ABA: GRAMADO
-- ====================================================================
local TabGrass = Window:CreateTab("Gramado", 4483362458)

local GrassSection = TabGrass:CreateSection("Cores do Gramado")

TabGrass:CreateButton({
    Name = "🟢 Verde Dark",
    Callback = function()
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and (part.Name:lower():find("grass") or part.Name:lower():find("pitch") or part.Name:lower():find("campo")) then
                part.Color = Color3.fromRGB(15, 60, 25)
            end
        end
    end,
})

TabGrass:CreateButton({
    Name = "⚫ Preto/Cinza",
    Callback = function()
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and (part.Name:lower():find("grass") or part.Name:lower():find("pitch") or part.Name:lower():find("campo")) then
                part.Color = Color3.fromRGB(20, 20, 24)
            end
        end
    end,
})

TabGrass:CreateButton({
    Name = "🔴 Vermelho",
    Callback = function()
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and (part.Name:lower():find("grass") or part.Name:lower():find("pitch") or part.Name:lower():find("campo")) then
                part.Color = Color3.fromRGB(180, 30, 30)
            end
        end
    end,
})

TabGrass:CreateButton({
    Name = "🔵 Azul",
    Callback = function()
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and (part.Name:lower():find("grass") or part.Name:lower():find("pitch") or part.Name:lower():find("campo")) then
                part.Color = Color3.fromRGB(30, 100, 200)
            end
        end
    end,
})

TabGrass:CreateButton({
    Name = "🟡 Amarelo",
    Callback = function()
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and (part.Name:lower():find("grass") or part.Name:lower():find("pitch") or part.Name:lower():find("campo")) then
                part.Color = Color3.fromRGB(220, 200, 20)
            end
        end
    end,
})

TabGrass:CreateButton({
    Name = "💗 Rosa",
    Callback = function()
        for _, part in ipairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") and (part.Name:lower():find("grass") or part.Name:lower():find("pitch") or part.Name:lower():find("campo")) then
                part.Color = Color3.fromRGB(220, 50, 140)
            end
        end
    end,
})

-- ====================================================================
-- BOTÃO FLUTUANTE FOLLOW
-- ====================================================================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MTWHubGui"
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

local FloatButton = Instance.new("TextButton")
local FloatCorner = Instance.new("UICorner")
local FloatStroke = Instance.new("UIStroke")

FloatButton.Name = "AutoBallFloatBtn"
FloatButton.Parent = ScreenGui
FloatButton.BackgroundColor3 = Color3.fromRGB(15, 15, 18)
FloatButton.Position = UDim2.new(0.85, 0, 0.2, 0)
FloatButton.Size = UDim2.new(0, 110, 0, 38)
FloatButton.Font = Enum.Font.GothamBold
FloatButton.Text = "FOLLOW: OFF"
FloatButton.TextColor3 = Color3.fromRGB(220, 60, 60)
FloatButton.TextSize = 12

FloatCorner.CornerRadius = UDim.new(0, 8)
FloatCorner.Parent = FloatButton

FloatStroke.Color = Color3.fromRGB(220, 60, 60)
FloatStroke.Thickness = 1.5
FloatStroke.Parent = FloatButton

-- Arrastar
local dragging, dragInput, dragStart, startPos
FloatButton.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = FloatButton.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

FloatButton.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        FloatButton.Position = UDim2.new(
            startPos.X.Scale, startPos.X.Offset + delta.X,
            startPos.Y.Scale, startPos.Y.Offset + delta.Y
        )
    end
end)

FloatButton.MouseButton1Click:Connect(function()
    AutoFollowEnabled = not AutoFollowEnabled
    if AutoFollowEnabled then
        FloatButton.Text = "FOLLOW: ON"
        FloatButton.TextColor3 = Color3.fromRGB(60, 220, 100)
        FloatStroke.Color = Color3.fromRGB(60, 220, 100)
    else
        FloatButton.Text = "FOLLOW: OFF"
        FloatButton.TextColor3 = Color3.fromRGB(220, 60, 60)
        FloatStroke.Color = Color3.fromRGB(220, 60, 60)
        if Humanoid then Humanoid:Move(Vector3.zero, false) end
    end
end)

-- Notificação
Rayfield:Notify({
    Title = "MTW HUB",
    Content = "Script carregado com sucesso!",
    Duration = 3,
    Image = 4483362458,
})