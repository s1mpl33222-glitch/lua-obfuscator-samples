-- =======================================================
-- MONITE HUB BY ALVESCRIPT - Módulo de Combate (Parte 1/3)
-- =======================================================

local CombatModule = {}

-- Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

-- Configurações Globais
local AimbotSettings = {
    Enabled = false,
    FOVSize = 100,
    MaxFOV = 300,
    MinFOV = 10,
    MaxDistance = 1000,                               -- Limite de 1000 Studs
    FOVColorNoTarget = Color3.fromRGB(255, 60, 60),
    FOVColorTarget = Color3.fromRGB(60, 255, 120),
    LockPart = "Head"
}

local BulletSettings = {
    Speed = 1000,
    MinSpeed = 100,
    MaxSpeed = 5000
}

local ShiftLockEnabled = false
local NoSpreadEnabled = false

local PartNamesMap = {
    Head = "Cabeça",
    HumanoidRootPart = "Tronco (Centro)",
    Torso = "Peito",
    UpperTorso = "Peito Superior",
    LowerTorso = "Quadril",
    ["Right UpperArm"] = "Braço Dir.",
    ["Left UpperArm"] = "Braço Esq.",
    ["Right UpperLeg"] = "Perna Dir.",
    ["Left UpperLeg"] = "Perna Esq."
}

-- Criar Círculo de FOV (usando Drawing API)
local FOVCircle = nil
if typeof(Drawing) ~= "nil" then
    FOVCircle = Drawing.new("Circle")
    FOVCircle.Thickness = 1.8
    FOVCircle.NumSides = 64
    FOVCircle.Radius = AimbotSettings.FOVSize
    FOVCircle.Filled = false
    FOVCircle.Visible = false
    FOVCircle.Color = AimbotSettings.FOVColorNoTarget
end

-- Criar Bolinha Central do Shift Lock
local ShiftLockDotOutline = nil
local ShiftLockDot = nil

if typeof(Drawing) ~= "nil" then
    ShiftLockDotOutline = Drawing.new("Circle")
    ShiftLockDotOutline.Radius = 7
    ShiftLockDotOutline.Thickness = 1.5
    ShiftLockDotOutline.NumSides = 32
    ShiftLockDotOutline.Filled = true
    ShiftLockDotOutline.Color = Color3.fromRGB(0, 0, 0)
    ShiftLockDotOutline.Visible = false

    ShiftLockDot = Drawing.new("Circle")
    ShiftLockDot.Radius = 5.5
    ShiftLockDot.Thickness = 1
    ShiftLockDot.NumSides = 32
    ShiftLockDot.Filled = true
    ShiftLockDot.Color = Color3.fromRGB(255, 255, 255)
    ShiftLockDot.Visible = false
end

-- Checagem se o jogador está vivo e consciente (não morto / não derrubado)
local function isAliveAndValid(player)
    if not player or player == LocalPlayer or not player.Character then return false end
    
    local char = player.Character
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return false end

    if humanoid:GetState() == Enum.HumanoidStateType.Physics or humanoid:GetState() == Enum.HumanoidStateType.Dead then
        return false
    end

    if char:FindFirstChild("KO") or char:FindFirstChild("Knocked") or char:FindFirstChild("Downed") or char:FindFirstChild("IsDowned") then
        return false
    end

    if char:getAttribute("IsDowned") == true or char:getAttribute("Knocked") == true then
        return false
    end

    return true
end

-- Checagem de Parede (Wall Check)
local function isVisible(targetPart)
    if not targetPart or not targetPart.Parent then return false end
    local character = LocalPlayer.Character
    if not character then return false end
    
    local origin = Camera.CFrame.Position
    local destination = targetPart.Position
    local direction = (destination - origin)
    
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.FilterDescendantsInstances = {character, targetPart.Parent}
    raycastParams.IgnoreWater = true

    local result = Workspace:Raycast(origin, direction, raycastParams)
    return result == nil
end

-- Função para obter o inimigo mais próximo (com limite de 1000 Studs)
local function getClosestPlayerInFOV()
    local closestPlayer = nil
    local shortestDistance = AimbotSettings.FOVSize
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    if not myRoot then return nil end

    for _, player in ipairs(Players:GetPlayers()) do
        if isAliveAndValid(player) then
            local enemyRoot = player.Character:FindFirstChild("HumanoidRootPart")
            if enemyRoot then
                local distFromMe = (myRoot.Position - enemyRoot.Position).Magnitude
                
                if distFromMe <= AimbotSettings.MaxDistance then
                    local targetPart = player.Character:FindFirstChild(AimbotSettings.LockPart) or player.Character:FindFirstChild("Head")

                    if targetPart then
                        local screenPos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)

                        if onScreen then
                            local distance = (center - Vector2.new(screenPos.X, screenPos.Y)).Magnitude

                            if distance <= shortestDistance and isVisible(targetPart) then
                                shortestDistance = distance
                                closestPlayer = player
                            end
                        end
                    end
                end
            end
        end
    end

    return closestPlayer
end

-- Hook para No Spread & Bullet Speed
local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local args = {...}
    local method = getnamecallmethod()

    if not checkcaller() and (method == "FireServer" or method == "InvokeServer") then
        for _, arg in ipairs(args) do
            if type(arg) == "table" then
                if NoSpreadEnabled then
                    if rawget(arg, "Spread") then rawset(arg, "Spread", 0) end
                    if rawget(arg, "Inaccuracy") then rawset(arg, "Inaccuracy", 0) end
                    if rawget(arg, "Recoil") then rawset(arg, "Recoil", 0) end
                end
                
                if rawget(arg, "Speed") then rawset(arg, "Speed", BulletSettings.Speed) end
                if rawget(arg, "Velocity") then rawset(arg, "Velocity", BulletSettings.Speed) end
                if rawget(arg, "BulletSpeed") then rawset(arg, "BulletSpeed", BulletSettings.Speed) end
            end
        end
    end

    return oldNamecall(self, ...)
end)

-- Loop Principal ultra rápido em 120 FPS
local renderConnection = nil
local function startCombatLoop()
    if renderConnection then renderConnection:Disconnect() end

    renderConnection = RunService.RenderStepped:Connect(function(deltaTime)
        local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

        if FOVCircle then
            FOVCircle.Position = center
            FOVCircle.Radius = AimbotSettings.FOVSize
            FOVCircle.Visible = AimbotSettings.Enabled
        end

        if ShiftLockDot and ShiftLockDotOutline then
            ShiftLockDotOutline.Position = center
            ShiftLockDotOutline.Visible = ShiftLockEnabled

            ShiftLockDot.Position = center
            ShiftLockDot.Visible = ShiftLockEnabled
        end

        -- Aimbot Corrigido (Usando CFrame.lookAt sem tirar o personagem da visão)
        if AimbotSettings.Enabled then
            local targetPlayer = getClosestPlayerInFOV()

            if targetPlayer and targetPlayer.Character then
                local targetPart = targetPlayer.Character:FindFirstChild(AimbotSettings.LockPart) or targetPlayer.Character:FindFirstChild("Head")

                if targetPart then
                    if FOVCircle then FOVCircle.Color = AimbotSettings.FOVColorTarget end
                    Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, targetPart.Position)
                end
            else
                if FOVCircle then FOVCircle.Color = AimbotSettings.FOVColorNoTarget end
            end
        end

        -- Shift Lock Ultra Fluido
        if ShiftLockEnabled and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            local rootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if humanoid and rootPart then
                humanoid.AutoRotate = false
                local cameraLook = Camera.CFrame.LookVector
                local targetCFrame = CFrame.new(rootPart.Position, rootPart.Position + Vector3.new(cameraLook.X, 0, cameraLook.Z))
                
                rootPart.CFrame = rootPart.CFrame:Lerp(targetCFrame, math.clamp(deltaTime * 120, 0.7, 1))
            end
        end
    end)
end

startCombatLoop()
-- =======================================================
-- MONITE HUB BY ALVESCRIPT - Módulo de Combate (Parte 2/3)
-- =======================================================

function CombatModule.BuildTab(parentContainer)
    local mainFrame = parentContainer.Parent
    if mainFrame then
        local categoryContainer = mainFrame:FindFirstChild("CategoryContainer")
        if categoryContainer then
            if not categoryContainer:FindFirstChildOfClass("UIListLayout") then
                local listLayout = Instance.new("UIListLayout")
                listLayout.Parent = categoryContainer
                listLayout.SortOrder = Enum.SortOrder.LayoutOrder
                listLayout.Padding = UDim.new(0, 4)

                local padding = Instance.new("UIPadding")
                padding.Parent = categoryContainer
                padding.PaddingTop = UDim.new(0, 6)
                padding.PaddingLeft = UDim.new(0, 6)
                padding.PaddingRight = UDim.new(0, 6)
            end

            if not categoryContainer:FindFirstChild("CombateTabBtn") then
                local TabBtn = Instance.new("TextButton")
                TabBtn.Name = "CombateTabBtn"
                TabBtn.Parent = categoryContainer
                TabBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 240)
                TabBtn.BorderSizePixel = 0
                TabBtn.Size = UDim2.new(1, 0, 0, 30)
                TabBtn.Font = Enum.Font.GothamBold
                TabBtn.Text = "Combate"
                TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
                TabBtn.TextSize = 12
                TabBtn.LayoutOrder = 1

                local BtnCorner = Instance.new("UICorner")
                BtnCorner.CornerRadius = UDim.new(0, 6)
                BtnCorner.Parent = TabBtn

                TabBtn.MouseButton1Click:Connect(function()
                    for _, btn in ipairs(categoryContainer:GetChildren()) do
                        if btn:IsA("TextButton") then
                            btn.BackgroundColor3 = Color3.fromRGB(45, 50, 60)
                        end
                    end
                    TabBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 240)

                    CombatModule.BuildTab(parentContainer)
                end)
            end
        end
    end

    for _, child in ipairs(parentContainer:GetChildren()) do
        if child:IsA("GuiObject") then
            child:Destroy()
        end
    end

    local ScrollFrame = Instance.new("ScrollingFrame")
    ScrollFrame.Name = "CombatScroll"
    ScrollFrame.Parent = parentContainer
    ScrollFrame.BackgroundTransparency = 1
    ScrollFrame.Size = UDim2.new(1, 0, 1, 0)
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, 440)
    ScrollFrame.ScrollBarThickness = 4
    ScrollFrame.ScrollBarImageColor3 = Color3.fromRGB(100, 105, 120)

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = ScrollFrame
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 8)

    local UIPadding = Instance.new("UIPadding")
    UIPadding.Parent = ScrollFrame
    UIPadding.PaddingTop = UDim.new(0, 10)
    UIPadding.PaddingLeft = UDim.new(0, 10)
    UIPadding.PaddingRight = UDim.new(0, 10)

    -- 1. Botão Aimbot
    local ToggleFrame = Instance.new("Frame")
    ToggleFrame.Name = "AimbotToggleFrame"
    ToggleFrame.Parent = ScrollFrame
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(35, 38, 45)
    ToggleFrame.Size = UDim2.new(1, 0, 0, 42)

    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(0, 8)
    ToggleCorner.Parent = ToggleFrame

    local ToggleLabel = Instance.new("TextLabel")
    ToggleLabel.Parent = ToggleFrame
    ToggleLabel.BackgroundTransparency = 1
    ToggleLabel.Position = UDim2.new(0, 12, 0, 0)
    ToggleLabel.Size = UDim2.new(0.6, 0, 1, 0)
    ToggleLabel.Font = Enum.Font.GothamBold
    ToggleLabel.Text = "Aimbot (1000m)"
    ToggleLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
    ToggleLabel.TextSize = 13
    ToggleLabel.TextXAlignment = Enum.TextXAlignment.Left

    local SwitchBG = Instance.new("TextButton")
    SwitchBG.Name = "SwitchBG"
    SwitchBG.Parent = ToggleFrame
    SwitchBG.BackgroundColor3 = AimbotSettings.Enabled and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(70, 75, 88)
    SwitchBG.Position = UDim2.new(1, -55, 0.5, -12)
    SwitchBG.Size = UDim2.new(0, 44, 0, 24)
    SwitchBG.Text = ""
    SwitchBG.AutoButtonColor = false

    local SwitchCorner = Instance.new("UICorner")
    SwitchCorner.CornerRadius = UDim.new(1, 0)
    SwitchCorner.Parent = SwitchBG

    local Circle = Instance.new("Frame")
    Circle.Name = "Circle"
    Circle.Parent = SwitchBG
    Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Circle.Position = AimbotSettings.Enabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    Circle.Size = UDim2.new(0, 18, 0, 18)

    local CircleCorner = Instance.new("UICorner")
    CircleCorner.CornerRadius = UDim.new(1, 0)
    CircleCorner.Parent = Circle

    SwitchBG.MouseButton1Click:Connect(function()
        AimbotSettings.Enabled = not AimbotSettings.Enabled
        
        local targetPos = AimbotSettings.Enabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        local targetColor = AimbotSettings.Enabled and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(70, 75, 88)

        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(SwitchBG, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()

        if FOVCircle then
            FOVCircle.Visible = AimbotSettings.Enabled
        end
    end)

    -- 2. Slider FOV (Max 300)
    local SliderFrame = Instance.new("Frame")
    SliderFrame.Name = "FOVSliderFrame"
    SliderFrame.Parent = ScrollFrame
    SliderFrame.BackgroundColor3 = Color3.fromRGB(35, 38, 45)
    SliderFrame.Size = UDim2.new(1, 0, 0, 52)

    local SliderCorner = Instance.new("UICorner")
    SliderCorner.CornerRadius = UDim.new(0, 8)
    SliderCorner.Parent = SliderFrame

    local SliderTitle = Instance.new("TextLabel")
    SliderTitle.Parent = SliderFrame
    SliderTitle.BackgroundTransparency = 1
    SliderTitle.Position = UDim2.new(0, 12, 0, 6)
    SliderTitle.Size = UDim2.new(0, 150, 0, 18)
    SliderTitle.Font = Enum.Font.GothamBold
    SliderTitle.Text = "Tamanho do FOV"
    SliderTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
    SliderTitle.TextSize = 12
    SliderTitle.TextXAlignment = Enum.TextXAlignment.Left

    local ValueLabel = Instance.new("TextLabel")
    ValueLabel.Parent = SliderFrame
    ValueLabel.BackgroundTransparency = 1
    ValueLabel.Position = UDim2.new(1, -60, 0, 6)
    ValueLabel.Size = UDim2.new(0, 48, 0, 18)
    ValueLabel.Font = Enum.Font.GothamBold
    ValueLabel.Text = tostring(math.floor(AimbotSettings.FOVSize))
    ValueLabel.TextColor3 = Color3.fromRGB(200, 205, 215)
    ValueLabel.TextSize = 12
    ValueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local SliderBar = Instance.new("Frame")
    SliderBar.Name = "SliderBar"
    SliderBar.Parent = SliderFrame
    SliderBar.BackgroundColor3 = Color3.fromRGB(60, 65, 75)
    SliderBar.Position = UDim2.new(0, 12, 0, 32)
    SliderBar.Size = UDim2.new(1, -24, 0, 6)

    local BarCorner = Instance.new("UICorner")
    BarCorner.CornerRadius = UDim.new(1, 0)
    BarCorner.Parent = SliderBar

    local SliderFill = Instance.new("Frame")
    SliderFill.Name = "SliderFill"
    SliderFill.Parent = SliderBar
    SliderFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    SliderFill.Size = UDim2.new((AimbotSettings.FOVSize - AimbotSettings.MinFOV) / (AimbotSettings.MaxFOV - AimbotSettings.MinFOV), 0, 1, 0)

    local FillCorner = Instance.new("UICorner")
    FillCorner.CornerRadius = UDim.new(1, 0)
    FillCorner.Parent = SliderFill

    local dragging = false
    local function updateSlider(input)
        local barPos = SliderBar.AbsolutePosition.X
        local barWidth = SliderBar.AbsoluteSize.X
        local percent = math.clamp((input.Position.X - barPos) / barWidth, 0, 1)
        local value = math.floor(AimbotSettings.MinFOV + percent * (AimbotSettings.MaxFOV - AimbotSettings.MinFOV))

        AimbotSettings.FOVSize = value
        ValueLabel.Text = tostring(value)
        SliderFill.Size = UDim2.new(percent, 0, 1, 0)

        if FOVCircle then FOVCircle.Radius = value end
    end

    SliderBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            updateSlider(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = false
        end
    end)

    -- 3. Shift Lock Toggle
    local ShiftFrame = Instance.new("Frame")
    ShiftFrame.Name = "ShiftLockToggleFrame"
    ShiftFrame.Parent = ScrollFrame
    ShiftFrame.BackgroundColor3 = Color3.fromRGB(35, 38, 45)
    ShiftFrame.Size = UDim2.new(1, 0, 0, 42)

    local ShiftCorner = Instance.new("UICorner")
    ShiftCorner.CornerRadius = UDim.new(0, 8)
    ShiftCorner.Parent = ShiftFrame

    local ShiftLabel = Instance.new("TextLabel")
    ShiftLabel.Parent = ShiftFrame
    ShiftLabel.BackgroundTransparency = 1
    ShiftLabel.Position = UDim2.new(0, 12, 0, 0)
    ShiftLabel.Size = UDim2.new(0.6, 0, 1, 0)
    ShiftLabel.Font = Enum.Font.GothamBold
    ShiftLabel.Text = "Shift Lock"
    ShiftLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
    ShiftLabel.TextSize = 13
    ShiftLabel.TextXAlignment = Enum.TextXAlignment.Left

    local ShiftSwitchBG = Instance.new("TextButton")
    ShiftSwitchBG.Name = "ShiftSwitchBG"
    ShiftSwitchBG.Parent = ShiftFrame
    ShiftSwitchBG.BackgroundColor3 = ShiftLockEnabled and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(70, 75, 88)
    ShiftSwitchBG.Position = UDim2.new(1, -55, 0.5, -12)
    ShiftSwitchBG.Size = UDim2.new(0, 44, 0, 24)
    ShiftSwitchBG.Text = ""
    ShiftSwitchBG.AutoButtonColor = false

    local ShiftSwitchCorner = Instance.new("UICorner")
    ShiftSwitchCorner.CornerRadius = UDim.new(1, 0)
    ShiftSwitchCorner.Parent = ShiftSwitchBG

    local ShiftCircle = Instance.new("Frame")
    ShiftCircle.Name = "ShiftCircle"
    ShiftCircle.Parent = ShiftSwitchBG
    ShiftCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ShiftCircle.Position = ShiftLockEnabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    ShiftCircle.Size = UDim2.new(0, 18, 0, 18)

    local ShiftCircleCorner = Instance.new("UICorner")
    ShiftCircleCorner.CornerRadius = UDim.new(1, 0)
    ShiftCircleCorner.Parent = ShiftCircle

    ShiftSwitchBG.MouseButton1Click:Connect(function()
        ShiftLockEnabled = not ShiftLockEnabled
        
        local targetPos = ShiftLockEnabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        local targetColor = ShiftLockEnabled and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(70, 75, 88)

        TweenService:Create(ShiftCircle, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(ShiftSwitchBG, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()

        if ShiftLockDot and ShiftLockDotOutline then
            ShiftLockDotOutline.Visible = ShiftLockEnabled
            ShiftLockDot.Visible = ShiftLockEnabled
        end

        if not ShiftLockEnabled and LocalPlayer.Character then
            local humanoid = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
            if humanoid then humanoid.AutoRotate = true end
        end
    end)
-- =======================================================
-- MONITE HUB BY ALVESCRIPT - Módulo de Combate (Parte 3/3)
-- =======================================================

    -- 4. No Bullet Spread Toggle
    local SpreadFrame = Instance.new("Frame")
    SpreadFrame.Name = "NoSpreadToggleFrame"
    SpreadFrame.Parent = ScrollFrame
    SpreadFrame.BackgroundColor3 = Color3.fromRGB(35, 38, 45)
    SpreadFrame.Size = UDim2.new(1, 0, 0, 42)

    local SpreadCorner = Instance.new("UICorner")
    SpreadCorner.CornerRadius = UDim.new(0, 8)
    SpreadCorner.Parent = SpreadFrame

    local SpreadLabel = Instance.new("TextLabel")
    SpreadLabel.Parent = SpreadFrame
    SpreadLabel.BackgroundTransparency = 1
    SpreadLabel.Position = UDim2.new(0, 12, 0, 0)
    SpreadLabel.Size = UDim2.new(0.6, 0, 1, 0)
    SpreadLabel.Font = Enum.Font.GothamBold
    SpreadLabel.Text = "No Bullet Spread"
    SpreadLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
    SpreadLabel.TextSize = 13
    SpreadLabel.TextXAlignment = Enum.TextXAlignment.Left

    local SpreadSwitchBG = Instance.new("TextButton")
    SpreadSwitchBG.Name = "SpreadSwitchBG"
    SpreadSwitchBG.Parent = SpreadFrame
    SpreadSwitchBG.BackgroundColor3 = NoSpreadEnabled and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(70, 75, 88)
    SpreadSwitchBG.Position = UDim2.new(1, -55, 0.5, -12)
    SpreadSwitchBG.Size = UDim2.new(0, 44, 0, 24)
    SpreadSwitchBG.Text = ""
    SpreadSwitchBG.AutoButtonColor = false

    local SpreadSwitchCorner = Instance.new("UICorner")
    SpreadSwitchCorner.CornerRadius = UDim.new(1, 0)
    SpreadSwitchCorner.Parent = SpreadSwitchBG

    local SpreadCircle = Instance.new("Frame")
    SpreadCircle.Name = "SpreadCircle"
    SpreadCircle.Parent = SpreadSwitchBG
    SpreadCircle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SpreadCircle.Position = NoSpreadEnabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
    SpreadCircle.Size = UDim2.new(0, 18, 0, 18)

    local SpreadCircleCorner = Instance.new("UICorner")
    SpreadCircleCorner.CornerRadius = UDim.new(1, 0)
    SpreadCircleCorner.Parent = SpreadCircle

    SpreadSwitchBG.MouseButton1Click:Connect(function()
        NoSpreadEnabled = not NoSpreadEnabled
        
        local targetPos = NoSpreadEnabled and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
        local targetColor = NoSpreadEnabled and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(70, 75, 88)

        TweenService:Create(SpreadCircle, TweenInfo.new(0.2), {Position = targetPos}):Play()
        TweenService:Create(SpreadSwitchBG, TweenInfo.new(0.2), {BackgroundColor3 = targetColor}):Play()
    end)

    -- 5. Botão Alvo do Aimbot
    local PartSelectorFrame = Instance.new("Frame")
    PartSelectorFrame.Name = "PartSelectorFrame"
    PartSelectorFrame.Parent = ScrollFrame
    PartSelectorFrame.BackgroundColor3 = Color3.fromRGB(35, 38, 45)
    PartSelectorFrame.Size = UDim2.new(1, 0, 0, 42)

    local PartCorner = Instance.new("UICorner")
    PartCorner.CornerRadius = UDim.new(0, 8)
    PartCorner.Parent = PartSelectorFrame

    local PartLabel = Instance.new("TextLabel")
    PartLabel.Parent = PartSelectorFrame
    PartLabel.BackgroundTransparency = 1
    PartLabel.Position = UDim2.new(0, 12, 0, 0)
    PartLabel.Size = UDim2.new(0.5, 0, 1, 0)
    PartLabel.Font = Enum.Font.GothamBold
    PartLabel.Text = "Alvo do Aimbot"
    PartLabel.TextColor3 = Color3.fromRGB(240, 240, 245)
    PartLabel.TextSize = 13
    PartLabel.TextXAlignment = Enum.TextXAlignment.Left

    local OpenUIBtn = Instance.new("TextButton")
    OpenUIBtn.Name = "OpenUIBtn"
    OpenUIBtn.Parent = PartSelectorFrame
    OpenUIBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 240)
    OpenUIBtn.Position = UDim2.new(1, -115, 0.5, -13)
    OpenUIBtn.Size = UDim2.new(0, 105, 0, 26)
    OpenUIBtn.Font = Enum.Font.GothamBold
    OpenUIBtn.Text = PartNamesMap[AimbotSettings.LockPart] or "Cabeça"
    OpenUIBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpenUIBtn.TextSize = 11

    local OpenUICorner = Instance.new("UICorner")
    OpenUICorner.CornerRadius = UDim.new(0, 6)
    OpenUICorner.Parent = OpenUIBtn

    -- 6. Slider Velocidade da Bala
    local BulletSliderFrame = Instance.new("Frame")
    BulletSliderFrame.Name = "BulletSliderFrame"
    BulletSliderFrame.Parent = ScrollFrame
    BulletSliderFrame.BackgroundColor3 = Color3.fromRGB(35, 38, 45)
    BulletSliderFrame.Size = UDim2.new(1, 0, 0, 52)

    local BulletCorner = Instance.new("UICorner")
    BulletCorner.CornerRadius = UDim.new(0, 8)
    BulletCorner.Parent = BulletSliderFrame

    local BulletTitle = Instance.new("TextLabel")
    BulletTitle.Parent = BulletSliderFrame
    BulletTitle.BackgroundTransparency = 1
    BulletTitle.Position = UDim2.new(0, 12, 0, 6)
    BulletTitle.Size = UDim2.new(0, 150, 0, 18)
    BulletTitle.Font = Enum.Font.GothamBold
    BulletTitle.Text = "Velocidade da Bala"
    BulletTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
    BulletTitle.TextSize = 12
    BulletTitle.TextXAlignment = Enum.TextXAlignment.Left

    local BulletValueLabel = Instance.new("TextLabel")
    BulletValueLabel.Parent = BulletSliderFrame
    BulletValueLabel.BackgroundTransparency = 1
    BulletValueLabel.Position = UDim2.new(1, -60, 0, 6)
    BulletValueLabel.Size = UDim2.new(0, 48, 0, 18)
    BulletValueLabel.Font = Enum.Font.GothamBold
    BulletValueLabel.Text = tostring(math.floor(BulletSettings.Speed))
    BulletValueLabel.TextColor3 = Color3.fromRGB(200, 205, 215)
    BulletValueLabel.TextSize = 12
    BulletValueLabel.TextXAlignment = Enum.TextXAlignment.Right

    local BulletBar = Instance.new("Frame")
    BulletBar.Name = "BulletBar"
    BulletBar.Parent = BulletSliderFrame
    BulletBar.BackgroundColor3 = Color3.fromRGB(60, 65, 75)
    BulletBar.Position = UDim2.new(0, 12, 0, 32)
    BulletBar.Size = UDim2.new(1, -24, 0, 6)

    local BulletBarCorner = Instance.new("UICorner")
    BulletBarCorner.CornerRadius = UDim.new(1, 0)
    BulletBarCorner.Parent = BulletBar

    local BulletFill = Instance.new("Frame")
    BulletFill.Name = "BulletFill"
    BulletFill.Parent = BulletBar
    BulletFill.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    BulletFill.Size = UDim2.new((BulletSettings.Speed - BulletSettings.MinSpeed) / (BulletSettings.MaxSpeed - BulletSettings.MinSpeed), 0, 1, 0)

    local BulletFillCorner = Instance.new("UICorner")
    BulletFillCorner.CornerRadius = UDim.new(1, 0)
    BulletFillCorner.Parent = BulletFill

    local draggingBullet = false
    local function updateBulletSlider(input)
        local barPos = BulletBar.AbsolutePosition.X
        local barWidth = BulletBar.AbsoluteSize.X
        local percent = math.clamp((input.Position.X - barPos) / barWidth, 0, 1)
        local value = math.floor(BulletSettings.MinSpeed + percent * (BulletSettings.MaxSpeed - BulletSettings.MinSpeed))

        BulletSettings.Speed = value
        BulletValueLabel.Text = tostring(value)
        BulletFill.Size = UDim2.new(percent, 0, 1, 0)
    end

    BulletBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingBullet = true
            updateBulletSlider(input)
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if draggingBullet and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateBulletSlider(input)
        end
    end)

    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingBullet = false
        end
    end)

    -- Popup UI de Seleção de Parte do Corpo
    local mainFrameObj = parentContainer.Parent
    if mainFrameObj:FindFirstChild("BodyPartPopupUI") then
        mainFrameObj.BodyPartPopupUI:Destroy()
    end

    local PopupFrame = Instance.new("Frame")
    PopupFrame.Name = "BodyPartPopupUI"
    PopupFrame.Parent = mainFrameObj
    PopupFrame.BackgroundColor3 = Color3.fromRGB(28, 30, 36)
    PopupFrame.BorderSizePixel = 0
    PopupFrame.Position = UDim2.new(0.5, -110, 0.5, -110)
    PopupFrame.Size = UDim2.new(0, 220, 0, 220)
    PopupFrame.Visible = false
    PopupFrame.ZIndex = 50

    local PopupCorner = Instance.new("UICorner")
    PopupCorner.CornerRadius = UDim.new(0, 10)
    PopupCorner.Parent = PopupFrame

    local PopupStroke = Instance.new("UIStroke")
    PopupStroke.Parent = PopupFrame
    PopupStroke.Color = Color3.fromRGB(0, 140, 240)
    PopupStroke.Thickness = 1.5

    local PopupTitle = Instance.new("TextLabel")
    PopupTitle.Parent = PopupFrame
    PopupTitle.BackgroundTransparency = 1
    PopupTitle.Position = UDim2.new(0, 12, 0, 4)
    PopupTitle.Size = UDim2.new(1, -45, 0, 26)
    PopupTitle.Font = Enum.Font.GothamBold
    PopupTitle.Text = "Escolha a Parte"
    PopupTitle.TextColor3 = Color3.fromRGB(240, 240, 245)
    PopupTitle.TextSize = 12
    PopupTitle.TextXAlignment = Enum.TextXAlignment.Left
    PopupTitle.ZIndex = 51

    local ClosePopupBtn = Instance.new("TextButton")
    ClosePopupBtn.Name = "ClosePopupBtn"
    ClosePopupBtn.Parent = PopupFrame
    ClosePopupBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    ClosePopupBtn.Position = UDim2.new(1, -28, 0, 6)
    ClosePopupBtn.Size = UDim2.new(0, 22, 0, 22)
    ClosePopupBtn.Font = Enum.Font.GothamBold
    ClosePopupBtn.Text = "X"
    ClosePopupBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ClosePopupBtn.TextSize = 12
    ClosePopupBtn.ZIndex = 51

    local ClosePopupCorner = Instance.new("UICorner")
    ClosePopupCorner.CornerRadius = UDim.new(0, 5)
    ClosePopupCorner.Parent = ClosePopupBtn

    local PopupScroll = Instance.new("ScrollingFrame")
    PopupScroll.Parent = PopupFrame
    PopupScroll.BackgroundTransparency = 1
    PopupScroll.Position = UDim2.new(0, 8, 0, 34)
    PopupScroll.Size = UDim2.new(1, -16, 1, -40)
    PopupScroll.CanvasSize = UDim2.new(0, 0, 0, 220)
    PopupScroll.ScrollBarThickness = 3
    PopupScroll.ScrollBarImageColor3 = Color3.fromRGB(100, 105, 120)
    PopupScroll.ZIndex = 51

    local PopupLayout = Instance.new("UIListLayout")
    PopupLayout.Parent = PopupScroll
    PopupLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PopupLayout.Padding = UDim.new(0, 5)

    local BodyPartsList = {
        {Name = "Cabeça", Part = "Head"},
        {Name = "Tronco / Centro", Part = "HumanoidRootPart"},
        {Name = "Peito", Part = "UpperTorso"},
        {Name = "Quadril", Part = "LowerTorso"},
        {Name = "Braço Direito", Part = "Right UpperArm"},
        {Name = "Braço Esquerdo", Part = "Left UpperArm"},
        {Name = "Perna Direita", Part = "Right UpperLeg"},
        {Name = "Perna Esquerda", Part = "Left UpperLeg"}
    }

    for idx, item in ipairs(BodyPartsList) do
        local OptionBtn = Instance.new("TextButton")
        OptionBtn.Name = "PartBtn_" .. item.Part
        OptionBtn.Parent = PopupScroll
        OptionBtn.BackgroundColor3 = (AimbotSettings.LockPart == item.Part) and Color3.fromRGB(0, 140, 240) or Color3.fromRGB(42, 46, 56)
        OptionBtn.Size = UDim2.new(1, -4, 0, 26)
        OptionBtn.Font = Enum.Font.GothamBold
        OptionBtn.Text = item.Name
        OptionBtn.TextColor3 = Color3.fromRGB(240, 240, 245)
        OptionBtn.TextSize = 11
        OptionBtn.ZIndex = 52

        local OptionCorner = Instance.new("UICorner")
        OptionCorner.CornerRadius = UDim.new(0, 5)
        OptionCorner.Parent = OptionBtn

        OptionBtn.MouseButton1Click:Connect(function()
            AimbotSettings.LockPart = item.Part
            OpenUIBtn.Text = item.Name

            for _, child in ipairs(PopupScroll:GetChildren()) do
                if child:IsA("TextButton") then
                    child.BackgroundColor3 = Color3.fromRGB(42, 46, 56)
                end
            end
            OptionBtn.BackgroundColor3 = Color3.fromRGB(0, 140, 240)
            PopupFrame.Visible = false
        end)
    end

    OpenUIBtn.MouseButton1Click:Connect(function()
        PopupFrame.Visible = not PopupFrame.Visible
    end)

    ClosePopupBtn.MouseButton1Click:Connect(function()
        PopupFrame.Visible = false
    end)
end

return CombatModule
