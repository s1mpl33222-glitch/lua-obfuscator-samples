-- === MASTER MENU (DETECCIÓN DE EQUIPAMIENTO PASS / SHOOT EN MANO + FUERZA FIX) ===
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

-- Variables de Estado
local ScriptActivo = true
local HitboxActiva = true
local PotenciaExtraActiva = true
local AutoPateoActivo = false
local TeleportSpeedActivo = false

local FuerzaAdicional = 300
local RangoHitbox = 25
local VelocidadDeseada = 30

local VisualHitboxPart = nil

-- Eliminar GUI previa
pcall(function()
    if LocalPlayer.PlayerGui:FindFirstChild("ZuaZuaMasterPassShootFixToolEquipped") then
        LocalPlayer.PlayerGui.ZuaZuaMasterPassShootFixToolEquipped:Destroy()
    end
end)

-- Actualizar o crear la esfera visual
local function actualizarVisualHitbox()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    if HitboxActiva and ScriptActivo then
        if not VisualHitboxPart or not VisualHitboxPart.Parent then
            VisualHitboxPart = Instance.new("Part")
            VisualHitboxPart.Name = "ZuaZuaHitboxVisual"
            VisualHitboxPart.Shape = Enum.PartType.Ball
            VisualHitboxPart.Material = Enum.Material.ForceField
            VisualHitboxPart.Color = Color3.fromRGB(0, 170, 255)
            VisualHitboxPart.Transparency = 0.65
            VisualHitboxPart.CanCollide = false
            VisualHitboxPart.Anchored = false
            VisualHitboxPart.Massless = true
            
            local weld = Instance.new("Weld")
            weld.Part0 = root
            weld.Part1 = VisualHitboxPart
            weld.C0 = CFrame.new(0, 0, 0)
            weld.Parent = VisualHitboxPart
            
            VisualHitboxPart.Parent = char
        end
        VisualHitboxPart.Size = Vector3.new(RangoHitbox * 2, RangoHitbox * 2, RangoHitbox * 2)
    else
        if VisualHitboxPart then
            VisualHitboxPart:Destroy()
            VisualHitboxPart = nil
        end
    end
end

-- 1. INTERFAZ GRÁFICA
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "ZuaZuaMasterPassShootFixToolEquipped"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 230, 0, 310)
MainFrame.Position = UDim2.new(0.05, 0, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(0.75, 0, 0, 30)
Title.Position = UDim2.new(0.05, 0, 0, 5)
Title.BackgroundTransparency = 1
Title.Text = "⚽ Master Menu 💙"
Title.TextColor3 = Color3.fromRGB(0, 170, 255)
Title.TextSize = 13
Title.Font = Enum.Font.SourceSansBold
Title.TextXAlignment = Enum.TextXAlignment.Left
Title.Parent = MainFrame

-- Botón X (Cerrar)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.SourceSansBold
CloseBtn.Parent = MainFrame

CloseBtn.MouseButton1Click:Connect(function()
    ScriptActivo = false
    if VisualHitboxPart then VisualHitboxPart:Destroy() end
    ScreenGui:Destroy()
end)

-- Botón Hitbox Visual ON/OFF
local ToggleHitboxBtn = Instance.new("TextButton")
ToggleHitboxBtn.Size = UDim2.new(0.9, 0, 0, 25)
ToggleHitboxBtn.Position = UDim2.new(0.05, 0, 0.12, 0)
ToggleHitboxBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
ToggleHitboxBtn.Text = "Hitbox Azul: ON"
ToggleHitboxBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleHitboxBtn.Font = Enum.Font.SourceSansBold
ToggleHitboxBtn.Parent = MainFrame

ToggleHitboxBtn.MouseButton1Click:Connect(function()
    HitboxActiva = not HitboxActiva
    if HitboxActiva then
        ToggleHitboxBtn.Text = "Hitbox Azul: ON"
        ToggleHitboxBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    else
        ToggleHitboxBtn.Text = "Hitbox Azul: OFF"
        ToggleHitboxBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    end
    actualizarVisualHitbox()
end)

-- Botón Súper Potencia ON/OFF
local TogglePowerBtn = Instance.new("TextButton")
TogglePowerBtn.Size = UDim2.new(0.9, 0, 0, 25)
TogglePowerBtn.Position = UDim2.new(0.05, 0, 0.22, 0)
TogglePowerBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
TogglePowerBtn.Text = "Súper Potencia: ON"
TogglePowerBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
TogglePowerBtn.Font = Enum.Font.SourceSansBold
TogglePowerBtn.Parent = MainFrame

TogglePowerBtn.MouseButton1Click:Connect(function()
    PotenciaExtraActiva = not PotenciaExtraActiva
    if PotenciaExtraActiva then
        TogglePowerBtn.Text = "Súper Potencia: ON"
        TogglePowerBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    else
        TogglePowerBtn.Text = "Súper Potencia: OFF"
        TogglePowerBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    end
end)

-- Botón Auto Pateo ON/OFF
local ToggleAutoBtn = Instance.new("TextButton")
ToggleAutoBtn.Size = UDim2.new(0.9, 0, 0, 25)
ToggleAutoBtn.Position = UDim2.new(0.05, 0, 0.32, 0)
ToggleAutoBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
ToggleAutoBtn.Text = "Auto Pateo (Auto): OFF"
ToggleAutoBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleAutoBtn.Font = Enum.Font.SourceSansBold
ToggleAutoBtn.Parent = MainFrame

ToggleAutoBtn.MouseButton1Click:Connect(function()
    AutoPateoActivo = not AutoPateoActivo
    if AutoPateoActivo then
        ToggleAutoBtn.Text = "Auto Pateo (Auto): ON"
        ToggleAutoBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    else
        ToggleAutoBtn.Text = "Auto Pateo (Auto): OFF"
        ToggleAutoBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    end
end)

-- Botón Speed Teleport ON/OFF
local ToggleSpeedBtn = Instance.new("TextButton")
ToggleSpeedBtn.Size = UDim2.new(0.9, 0, 0, 25)
ToggleSpeedBtn.Position = UDim2.new(0.05, 0, 0.42, 0)
ToggleSpeedBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
ToggleSpeedBtn.Text = "Speed Teleport: OFF"
ToggleSpeedBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleSpeedBtn.Font = Enum.Font.SourceSansBold
ToggleSpeedBtn.Parent = MainFrame

ToggleSpeedBtn.MouseButton1Click:Connect(function()
    TeleportSpeedActivo = not TeleportSpeedActivo
    if TeleportSpeedActivo then
        ToggleSpeedBtn.Text = "Speed Teleport: ON"
        ToggleSpeedBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    else
        ToggleSpeedBtn.Text = "Speed Teleport: OFF"
        ToggleSpeedBtn.BackgroundColor3 = Color3.fromRGB(180, 50, 50)
    end
end)

-- TextBoxes
local PowerLabel = Instance.new("TextLabel")
PowerLabel.Size = UDim2.new(0.45, 0, 0, 22)
PowerLabel.Position = UDim2.new(0.05, 0, 0.54, 0)
PowerLabel.BackgroundTransparency = 1
PowerLabel.Text = "Fuerza Tiro:"
PowerLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
PowerLabel.TextSize = 13
PowerLabel.Font = Enum.Font.SourceSans
PowerLabel.TextXAlignment = Enum.TextXAlignment.Left
PowerLabel.Parent = MainFrame

local PowerInput = Instance.new("TextBox")
PowerInput.Size = UDim2.new(0.42, 0, 0, 22)
PowerInput.Position = UDim2.new(0.5, 0, 0.54, 0)
PowerInput.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
PowerInput.Text = tostring(FuerzaAdicional)
PowerInput.TextColor3 = Color3.fromRGB(0, 255, 150)
PowerInput.Font = Enum.Font.SourceSansBold
PowerInput.ClearTextOnFocus = false
PowerInput.Parent = MainFrame

local function actualizarFuerzaInput()
    local num = tonumber(PowerInput.Text)
    if num then 
        FuerzaAdicional = num 
    end
end

PowerInput:GetPropertyChangedSignal("Text"):Connect(actualizarFuerzaInput)
PowerInput.FocusLost:Connect(function()
    actualizarFuerzaInput()
    PowerInput.Text = tostring(FuerzaAdicional)
end)

local HitboxLabel = Instance.new("TextLabel")
HitboxLabel.Size = UDim2.new(0.45, 0, 0, 22)
HitboxLabel.Position = UDim2.new(0.05, 0, 0.66, 0)
HitboxLabel.BackgroundTransparency = 1
HitboxLabel.Text = "Rango Hitbox:"
HitboxLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
HitboxLabel.TextSize = 13
HitboxLabel.Font = Enum.Font.SourceSans
HitboxLabel.TextXAlignment = Enum.TextXAlignment.Left
HitboxLabel.Parent = MainFrame

local HitboxInput = Instance.new("TextBox")
HitboxInput.Size = UDim2.new(0.42, 0, 0, 22)
HitboxInput.Position = UDim2.new(0.5, 0, 0.66, 0)
HitboxInput.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
HitboxInput.Text = tostring(RangoHitbox)
HitboxInput.TextColor3 = Color3.fromRGB(0, 255, 150)
HitboxInput.Font = Enum.Font.SourceSansBold
HitboxInput.ClearTextOnFocus = false
HitboxInput.Parent = MainFrame

local function actualizarHitboxInput()
    local num = tonumber(HitboxInput.Text)
    if num then 
        RangoHitbox = num 
        actualizarVisualHitbox()
    end
end

HitboxInput:GetPropertyChangedSignal("Text"):Connect(actualizarHitboxInput)
HitboxInput.FocusLost:Connect(function()
    actualizarHitboxInput()
    HitboxInput.Text = tostring(RangoHitbox)
end)

local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Size = UDim2.new(0.45, 0, 0, 22)
SpeedLabel.Position = UDim2.new(0.05, 0, 0.78, 0)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "Speed TP:"
SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedLabel.TextSize = 13
SpeedLabel.Font = Enum.Font.SourceSans
SpeedLabel.TextXAlignment = Enum.TextXAlignment.Left
SpeedLabel.Parent = MainFrame

local SpeedInput = Instance.new("TextBox")
SpeedInput.Size = UDim2.new(0.42, 0, 0, 22)
SpeedInput.Position = UDim2.new(0.5, 0, 0.78, 0)
SpeedInput.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
SpeedInput.Text = tostring(VelocidadDeseada)
SpeedInput.TextColor3 = Color3.fromRGB(0, 255, 150)
SpeedInput.Font = Enum.Font.SourceSansBold
SpeedInput.ClearTextOnFocus = false
SpeedInput.Parent = MainFrame

SpeedInput:GetPropertyChangedSignal("Text"):Connect(function()
    local num = tonumber(SpeedInput.Text)
    if num then VelocidadDeseada = num end
end)
SpeedInput.FocusLost:Connect(function()
    local num = tonumber(SpeedInput.Text)
    if num then VelocidadDeseada = num else SpeedInput.Text = tostring(VelocidadDeseada) end
end)

-- 2. LÓGICA DE TIRO Y DISPARO
local function aplicarDisparo(pelota)
    local char = LocalPlayer.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end

    if ReplicatedStorage:FindFirstChild("ChangeOwner") then
        ReplicatedStorage.ChangeOwner:FireServer(pelota)
    end

    local fuerzaAplicar = PotenciaExtraActiva and FuerzaAdicional or 100

    task.defer(function()
        for _, v in pairs(pelota:GetChildren()) do
            if v:IsA("BodyVelocity") or v:IsA("BodyForce") then v:Destroy() end
        end

        pelota.AssemblyLinearVelocity = Vector3.zero
        pelota.AssemblyAngularVelocity = Vector3.zero

        local bv = Instance.new("BodyVelocity")
        bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        bv.Velocity = root.CFrame.lookVector * fuerzaAplicar
        bv.Parent = pelota
        game:GetService("Debris"):AddItem(bv, 0.15)
    end)
end

local function patearEnRangoManual()
    if not ScriptActivo then return end
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local root = char.HumanoidRootPart

    local limiteDeteccion = HitboxActiva and RangoHitbox or 6

    for _, obj in pairs(Workspace:GetChildren()) do
        if obj.Name == "TPS" and obj:IsA("BasePart") then
            local distancia = (obj.Position - root.Position).Magnitude
            if distancia <= limiteDeteccion then
                aplicarDisparo(obj)
            end
        end
    end
end

-- Comprobar si el jugador tiene equipado Pass o Shoot
local function tieneHerramientaPaseOTiroEquipada()
    local char = LocalPlayer.Character
    if not char then return false end

    for _, item in pairs(char:GetChildren()) do
        if item:IsA("Tool") then
            local nombre = string.lower(item.Name)
            if string.find(nombre, "pass") or string.find(nombre, "shoot") or string.find(nombre, "gk") then
                return true
            end
        end
    end

    if char:FindFirstChild("EquippedTool") or char:FindFirstChild("Action") then
        return true
    end

    return false
end

-- Escuchar clics/toques ÚNICAMENTE si tiene Pass o Shoot equipado
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        if tieneHerramientaPaseOTiroEquipada() then
            patearEnRangoManual()
        end
    end
end)

local function setupCharacter(char)
    char:WaitForChild("HumanoidRootPart", 5)
    task.wait(0.5)
    actualizarVisualHitbox()
end

if LocalPlayer.Character then setupCharacter(LocalPlayer.Character) end
LocalPlayer.CharacterAdded:Connect(setupCharacter)

-- 3. BUCLE AUTO PATEO
task.spawn(function()
    while ScriptActivo do
        task.wait(0.05)
        if AutoPateoActivo then
            patearEnRangoManual()
            task.wait(0.15)
        end
    end
end)

-- 4. BUCLE SPEED TP
task.spawn(function()
    while ScriptActivo do
        task.wait(0.03)
        if TeleportSpeedActivo then
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                
                if hum and root and hum.MoveDirection.Magnitude > 0 then
                    local diferenciaSpeed = math.max(0, VelocidadDeseada - 20)
                    local pasoPorFrame = (diferenciaSpeed / 20) * 0.9
                    
                    if pasoPorFrame > 0 then
                        root.CFrame = root.CFrame + (hum.MoveDirection * pasoPorFrame)
                    end
                end
            end
        end
    end
end)