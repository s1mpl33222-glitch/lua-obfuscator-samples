local Players = game:GetService("Players")
local Player = Players.LocalPlayer
local RunService = game:GetService("RunService")

local targetParent = (gethui and gethui()) or Player:WaitForChild("PlayerGui")

if targetParent:FindFirstChild("MultiBallReachGui") then
    targetParent.MultiBallReachGui:Destroy()
end

-- Interfaz de Usuario
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MultiBallReachGui"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = targetParent

local MainFrame = Instance.new("Frame")
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
MainFrame.Position = UDim2.new(0.05, 0, 0.15, 0)
MainFrame.Size = UDim2.new(0, 230, 0, 270)
MainFrame.Active = true
MainFrame.Draggable = true

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 0, 0.02, 0)
Title.Size = UDim2.new(1, 0, 0, 25)
Title.Font = Enum.Font.SourceSansBold
Title.Text = "⚽ Multi-Ball Reach"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 18

-- Botón Hitbox Toggle
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Parent = MainFrame
ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleBtn.Position = UDim2.new(0.08, 0, 0.12, 0)
ToggleBtn.Size = UDim2.new(0.84, 0, 0, 26)
ToggleBtn.Font = Enum.Font.SourceSansBold
ToggleBtn.Text = "Hitbox (100): OFF"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 13
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

-- Botón Loop TP Pelota
local TpLoopBtn = Instance.new("TextButton")
TpLoopBtn.Parent = MainFrame
TpLoopBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
TpLoopBtn.Position = UDim2.new(0.08, 0, 0.24, 0)
TpLoopBtn.Size = UDim2.new(0.84, 0, 0, 26)
TpLoopBtn.Font = Enum.Font.SourceSansBold
TpLoopBtn.Text = "🔄 Loop TP Pelota: OFF"
TpLoopBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TpLoopBtn.TextSize = 13
Instance.new("UICorner", TpLoopBtn).CornerRadius = UDim.new(0, 6)

-- Botón TP 1 Clic
local TpOnceBtn = Instance.new("TextButton")
TpOnceBtn.Parent = MainFrame
TpOnceBtn.BackgroundColor3 = Color3.fromRGB(0, 160, 150)
TpOnceBtn.Position = UDim2.new(0.08, 0, 0.36, 0)
TpOnceBtn.Size = UDim2.new(0.84, 0, 0, 26)
TpOnceBtn.Font = Enum.Font.SourceSansBold
TpOnceBtn.Text = "⚡ TP 1 Clic (Pelota)"
TpOnceBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TpOnceBtn.TextSize = 13
Instance.new("UICorner", TpOnceBtn).CornerRadius = UDim.new(0, 6)

-- Selector de Jugadores (Multiselección)
local TargetBtn = Instance.new("TextButton")
TargetBtn.Parent = MainFrame
TargetBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
TargetBtn.Position = UDim2.new(0.08, 0, 0.48, 0)
TargetBtn.Size = UDim2.new(0.84, 0, 0, 26)
TargetBtn.Font = Enum.Font.SourceSansBold
TargetBtn.Text = "Seleccionar Targets (0) ▼"
TargetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TargetBtn.TextSize = 12
Instance.new("UICorner", TargetBtn).CornerRadius = UDim.new(0, 6)

local DropdownFrame = Instance.new("ScrollingFrame")
DropdownFrame.Parent = MainFrame
DropdownFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 28)
DropdownFrame.Position = UDim2.new(0.08, 0, 0.58, 0)
DropdownFrame.Size = UDim2.new(0.84, 0, 0, 100)
DropdownFrame.Visible = false
DropdownFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
DropdownFrame.ScrollBarThickness = 4
DropdownFrame.ZIndex = 5
Instance.new("UICorner", DropdownFrame).CornerRadius = UDim.new(0, 6)

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Parent = DropdownFrame
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder

-- Botones Fling
local FlingTargetBtn = Instance.new("TextButton")
FlingTargetBtn.Parent = MainFrame
FlingTargetBtn.BackgroundColor3 = Color3.fromRGB(180, 70, 200)
FlingTargetBtn.Position = UDim2.new(0.08, 0, 0.60, 0)
FlingTargetBtn.Size = UDim2.new(0.84, 0, 0, 26)
FlingTargetBtn.Font = Enum.Font.SourceSansBold
FlingTargetBtn.Text = "🌀 Fling Seleccionados"
FlingTargetBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingTargetBtn.TextSize = 12
Instance.new("UICorner", FlingTargetBtn).CornerRadius = UDim.new(0, 6)

local FlingAllBtn = Instance.new("TextButton")
FlingAllBtn.Parent = MainFrame
FlingAllBtn.BackgroundColor3 = Color3.fromRGB(150, 50, 200)
FlingAllBtn.Position = UDim2.new(0.08, 0, 0.72, 0)
FlingAllBtn.Size = UDim2.new(0.84, 0, 0, 26)
FlingAllBtn.Font = Enum.Font.SourceSansBold
FlingAllBtn.Text = "🌀 Skid Fling All"
FlingAllBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FlingAllBtn.TextSize = 12
Instance.new("UICorner", FlingAllBtn).CornerRadius = UDim.new(0, 6)

-- Variables de Estado
local active = false
local tpLoopActive = false
local selectedPlayers = {} -- Tabla de jugadores seleccionados
local rangeX, rangeY, rangeZ = 100, 100, 100

-- Actualizar Lista del Dropdown con Multiselección
local function updateDropdown()
    for _, child in pairs(DropdownFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    
    local count = 0
    local selectedCount = 0
    
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= Player then
            count = count + 1
            local btn = Instance.new("TextButton")
            btn.Parent = DropdownFrame
            btn.Size = UDim2.new(1, 0, 0, 22)
            
            -- Verificar si el jugador está seleccionado para marcarlo en verde
            local isSelected = selectedPlayers[plr] ~= nil
            if isSelected then
                btn.BackgroundColor3 = Color3.fromRGB(40, 180, 70) -- Verde
                selectedCount = selectedCount + 1
            else
                btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45) -- Oscuro
            end
            
            btn.Font = Enum.Font.SourceSans
            btn.Text = (isSelected and "✓ " or "") .. plr.DisplayName .. " (@" .. plr.Name .. ")"
            btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            btn.TextSize = 11
            btn.ZIndex = 6
            
            btn.MouseButton1Click:Connect(function()
                if selectedPlayers[plr] then
                    selectedPlayers[plr] = nil
                else
                    selectedPlayers[plr] = plr
                end
                updateDropdown()
            end)
        end
    end
    
    TargetBtn.Text = "Seleccionar Targets (" .. selectedCount .. ") ▼"
    DropdownFrame.CanvasSize = UDim2.new(0, 0, 0, count * 22)
end

TargetBtn.MouseButton1Click:Connect(function()
    DropdownFrame.Visible = not DropdownFrame.Visible
    if DropdownFrame.Visible then
        updateDropdown()
    end
end)

Players.PlayerAdded:Connect(updateDropdown)
Players.PlayerRemoving:Connect(function(plr)
    if selectedPlayers[plr] then
        selectedPlayers[plr] = nil
    end
    updateDropdown()
end)

-- Buscar Pelotas en el mapa
local function obtenerTodasLasPelotas()
    local pelotas = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("BasePart") then
            local esDeJugador = obj:FindFirstAncestorOfClass("Model") and obj:FindFirstAncestorOfClass("Model"):FindFirstChildOfClass("Humanoid")
            if not esDeJugador then
                local name = obj.Name:lower()
                if name:find("ball") or name:find("balon") or name:find("pelota") or name:find("football") or name:find("soccer") then
                    table.insert(pelotas, obj)
                end
            end
        end
    end
    return pelotas
end

local function getPelotaCercana(root)
    local pelotas = obtenerTodasLasPelotas()
    local pelotaCercana = nil
    local menorDistancia = math.huge

    for _, ball in pairs(pelotas) do
        local dist = (root.Position - ball.Position).Magnitude
        if dist < menorDistancia then
            menorDistancia = dist
            pelotaCercana = ball
        end
    end
    return pelotaCercana
end

-- Posicionamiento basado en la dirección de la Mirada/Cámara
local function posicionarAtrasDePelota(root, ball)
    local cam = workspace.CurrentCamera
    local lookVector = cam.CFrame.LookVector
    lookVector = Vector3.new(lookVector.X, 0, lookVector.Z).Unit
    
    local targetPosition = ball.Position - (lookVector * 3.5) + Vector3.new(0, 0.5, 0)
    root.CFrame = CFrame.new(targetPosition, targetPosition + lookVector)
end

-- Teleport 1 clic
TpOnceBtn.MouseButton1Click:Connect(function()
    local char = Player.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
    if not root then return end

    local ball = getPelotaCercana(root)
    if ball then
        posicionarAtrasDePelota(root, ball)
    end
end)

-- Loop TP Toggle
TpLoopBtn.MouseButton1Click:Connect(function()
    tpLoopActive = not tpLoopActive
    TpLoopBtn.Text = tpLoopActive and "🔄 Loop TP Pelota: ON" or "🔄 Loop TP Pelota: OFF"
    TpLoopBtn.BackgroundColor3 = tpLoopActive and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(0, 120, 215)
end)

-- Loop de TP Seguido
RunService.Heartbeat:Connect(function()
    if tpLoopActive then
        local char = Player.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
            if root then
                local ball = getPelotaCercana(root)
                if ball then
                    posicionarAtrasDePelota(root, ball)
                end
            end
        end
    end
end)

-- FUNCIONALIDAD SKIDFLING ORIGINAL EXACTA
local Message = function(_Title, _Text, Time)
    game:GetService("StarterGui"):SetCore("SendNotification", {Title = _Title, Text = _Text, Duration = Time})
end

local SkidFling = function(TargetPlayer)
    local Character = Player.Character
    local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
    local RootPart = Humanoid and Humanoid.RootPart

    local TCharacter = TargetPlayer.Character
    local THumanoid
    local TRootPart
    local THead
    local Accessory
    local Handle

    if TCharacter:FindFirstChildOfClass("Humanoid") then
        THumanoid = TCharacter:FindFirstChildOfClass("Humanoid")
    end
    if THumanoid and THumanoid.RootPart then
        TRootPart = THumanoid.RootPart
    end
    if TCharacter:FindFirstChild("Head") then
        THead = TCharacter.Head
    end
    if TCharacter:FindFirstChildOfClass("Accessory") then
        Accessory = TCharacter:FindFirstChildOfClass("Accessory")
    end
    if Accessory and Accessory:FindFirstChild("Handle") then
        Handle = Accessory.Handle
    end

    if Character and Humanoid and RootPart then
        if RootPart.Velocity.Magnitude < 50 then
            getgenv().OldPos = RootPart.CFrame
        end
        if THumanoid and THumanoid.Sit then
            return Message("Error Occurred", "Targeting is sitting", 5)
        end
        if THead then
            workspace.CurrentCamera.CameraSubject = THead
        elseif not THead and Handle then
            workspace.CurrentCamera.CameraSubject = Handle
        elseif THumanoid and TRootPart then
            workspace.CurrentCamera.CameraSubject = THumanoid
        end
        if not TCharacter:FindFirstChildWhichIsA("BasePart") then
            return
        end
        
        local FPos = function(BasePart, Pos, Ang)
            RootPart.CFrame = CFrame.new(BasePart.Position) * Pos * Ang
            Character:SetPrimaryPartCFrame(CFrame.new(BasePart.Position) * Pos * Ang)
            RootPart.Velocity = Vector3.new(9e7, 9e7 * 10, 9e7)
            RootPart.RotVelocity = Vector3.new(9e8, 9e8, 9e8)
        end
        
        local SFBasePart = function(BasePart)
            local TimeToWait = 2
            local Time = tick()
            local Angle = 0

            repeat
                if RootPart and THumanoid then
                    if BasePart.Velocity.Magnitude < 50 then
                        Angle = Angle + 100

                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle),0 ,0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(2.25, 1.5, -2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(-2.25, -1.5, 2.25) + THumanoid.MoveDirection * BasePart.Velocity.Magnitude / 1.25, CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0) + THumanoid.MoveDirection,CFrame.Angles(math.rad(Angle), 0, 0))
                        task.wait()
                    else
                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, -THumanoid.WalkSpeed), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, THumanoid.WalkSpeed), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()
                        
                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, -TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, 1.5, TRootPart.Velocity.Magnitude / 1.25), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(math.rad(90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5 ,0), CFrame.Angles(math.rad(-90), 0, 0))
                        task.wait()

                        FPos(BasePart, CFrame.new(0, -1.5, 0), CFrame.Angles(0, 0, 0))
                        task.wait()
                    end
                else
                    break
                end
            until BasePart.Velocity.Magnitude > 500 or BasePart.Parent ~= TargetPlayer.Character or TargetPlayer.Parent ~= Players or not TargetPlayer.Character == TCharacter or THumanoid.Sit or Humanoid.Health <= 0 or tick() > Time + TimeToWait
        end
        
        getgenv().FPDH = workspace.FallenPartsDestroyHeight
        workspace.FallenPartsDestroyHeight = 0/0
        
        local BV = Instance.new("BodyVelocity")
        BV.Name = "EpixVel"
        BV.Parent = RootPart
        BV.Velocity = Vector3.new(9e8, 9e8, 9e8)
        BV.MaxForce = Vector3.new(1/0, 1/0, 1/0)
        
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, false)
        
        if TRootPart and THead then
            if (TRootPart.CFrame.p - THead.CFrame.p).Magnitude > 5 then
                SFBasePart(THead)
            else
                SFBasePart(TRootPart)
            end
        elseif TRootPart and not THead then
            SFBasePart(TRootPart)
        elseif not TRootPart and THead then
            SFBasePart(THead)
        elseif not TRootPart and not THead and Accessory and Handle then
            SFBasePart(Handle)
        else
            return Message("Error Occurred", "Target is missing everything", 5)
        end
        
        BV:Destroy()
        Humanoid:SetStateEnabled(Enum.HumanoidStateType.Seated, true)
        workspace.CurrentCamera.CameraSubject = Humanoid
        
        repeat
            RootPart.CFrame = getgenv().OldPos * CFrame.new(0, .5, 0)
            Character:SetPrimaryPartCFrame(getgenv().OldPos * CFrame.new(0, .5, 0))
            Humanoid:ChangeState("GettingUp")
            table.foreach(Character:GetChildren(), function(_, x)
                if x:IsA("BasePart") then
                    x.Velocity, x.RotVelocity = Vector3.new(), Vector3.new()
                end
            end)
            task.wait()
        until (RootPart.Position - getgenv().OldPos.p).Magnitude < 25
        workspace.FallenPartsDestroyHeight = getgenv().FPDH
    else
        return Message("Error Occurred", "Random error", 5)
    end
end

-- Eventos Fling
FlingTargetBtn.MouseButton1Click:Connect(function()
    local targets = {}
    for _, plr in pairs(selectedPlayers) do
        table.insert(targets, plr)
    end
    
    if #targets == 0 then
        Message("Error Occurred", "Selecciona al menos un jugador", 3)
        return
    end
    
    FlingTargetBtn.Text = "🌀 Flinging (" .. #targets .. ")..."
    task.spawn(function()
        for _, target in ipairs(targets) do
            if target and target.Parent == Players and target.UserId ~= 1414978355 then
                SkidFling(target)
            end
        end
        FlingTargetBtn.Text = "🌀 Fling Seleccionados"
    end)
end)

FlingAllBtn.MouseButton1Click:Connect(function()
    FlingAllBtn.Text = "🌀 Flinging All..."
    task.spawn(function()
        for _, x in pairs(Players:GetPlayers()) do
            if x ~= Player and x.UserId ~= 1414978355 then
                SkidFling(x)
            end
        end
        FlingAllBtn.Text = "🌀 Skid Fling All"
    end)
end)

-- Bucle de Hitbox Optimizada
task.spawn(function()
    while true do
        if active then
            local char = Player.Character
            if char then
                local root = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso")
                if root then
                    local ball = getPelotaCercana(root)
                    if ball then
                        local diffX = math.abs(root.Position.X - ball.Position.X)
                        local diffY = math.abs(root.Position.Y - ball.Position.Y)
                        local diffZ = math.abs(root.Position.Z - ball.Position.Z)

                        if diffX <= rangeX and diffY <= rangeY and diffZ <= rangeZ then
                            firetouchinterest(root, ball, 0)
                            firetouchinterest(root, ball, 1)
                        end
                    end
                end
            end
        end
        task.wait(0.1)
    end
end)

ToggleBtn.MouseButton1Click:Connect(function()
    active = not active
    ToggleBtn.Text = active and "Hitbox (100): ON" or "Hitbox (100): OFF"
    ToggleBtn.BackgroundColor3 = active and Color3.fromRGB(50, 200, 50) or Color3.fromRGB(200, 50, 50)
end)
