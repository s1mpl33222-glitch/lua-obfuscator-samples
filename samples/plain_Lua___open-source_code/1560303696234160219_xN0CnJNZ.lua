-- [[ BROOKHAVEN PROP KILLER GUI - FINAL EDITION ]] --
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local TextService = game:GetService("TextService")
local LocalPlayer = Players.LocalPlayer

-- Eliminar UI anterior si existía para evitar duplicados
if LocalPlayer.PlayerGui:FindFirstChild("BrookhavenPropUI") then
    LocalPlayer.PlayerGui.BrookhavenPropUI:Destroy()
end

-- ScreenGui Principal
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BrookhavenPropUI"
ScreenGui.Parent = LocalPlayer.PlayerGui
ScreenGui.ResetOnSpawn = false

-- Marco Principal (Negro con bordes rojos curvos)
local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 340, 0, 230)
MainFrame.Position = UDim2.new(0.5, -170, 0.5, -115)
MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 14)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(255, 30, 30)
MainStroke.Thickness = 2.5
MainStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
MainStroke.Parent = MainFrame

-- Fondo con Partículas Suspendidas
local ParticlesFolder = Instance.new("Folder")
ParticlesFolder.Name = "Particles"
ParticlesFolder.Parent = MainFrame

for i = 1, 15 do
    local dot = Instance.new("Frame")
    dot.Name = "Particle"..i
    local size = math.random(2, 4)
    dot.Size = UDim2.new(0, size, 0, size)
    dot.Position = UDim2.new(math.random(), 0, math.random(), 0)
    dot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    dot.BackgroundTransparency = 0.5
    dot.BorderSizePixel = 0
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dot
    
    dot.Parent = ParticlesFolder
    
    task.spawn(function()
        while dot and dot.Parent do
            local speed = math.random(3, 6)
            local targetY = dot.Position.Y.Scale - 0.25
            if targetY < 0 then targetY = 1 end
            dot:TweenPosition(UDim2.new(dot.Position.X.Scale, 0, targetY, 0), Enum.EasingDirection.InOut, Enum.EasingStyle.Linear, speed, true)
            task.wait(speed)
        end
    end)
end

-- ============ FUNCIÓN: TÍTULO ANIMADO (ESTILO OLA LETRA A LETRA) ============
local function createAnimatedTitle(parent, text, sizeUDim2, positionUDim2, zIndex)
    zIndex = zIndex or 5
    local container = Instance.new("Frame")
    container.Name = "AnimatedTitle"
    container.Size = sizeUDim2
    container.Position = positionUDim2
    container.BackgroundTransparency = 1
    container.ClipsDescendants = false
    container.ZIndex = zIndex
    container.Parent = parent

    local labels = {}
    local cursorX = 0
    local font = Enum.Font.GothamBold
    local textSize = 14

    for i = 1, #text do
        local char = text:sub(i, i)
        local bounds = TextService:GetTextSize(char, textSize, font, Vector2.new(200, 50))

        local letter = Instance.new("TextLabel")
        letter.Name = "Letter"..i
        letter.AnchorPoint = Vector2.new(0, 0.5)
        letter.Size = UDim2.new(0, bounds.X + 1, 0, bounds.Y)
        letter.Position = UDim2.new(0, cursorX, 0.5, 0)
        letter.BackgroundTransparency = 1
        letter.Text = char
        letter.Font = font
        letter.TextSize = textSize
        letter.TextColor3 = Color3.fromRGB(255, 30, 30)
        letter.TextStrokeTransparency = 0.5
        letter.TextStrokeColor3 = Color3.fromRGB(150, 0, 0)
        letter.ZIndex = zIndex
        letter.Parent = container

        table.insert(labels, letter)
        cursorX = cursorX + bounds.X
    end

    task.spawn(function()
        local t = 0
        while container and container.Parent do
            t = t + 0.035
            for i, letter in ipairs(labels) do
                local phase = i * 0.45
                -- Paleta de tonos rojos / fuego sincronizada
                local hueOffset = math.sin(t * 0.4 + i * 0.12) * 0.07
                local hue = (0.0 + hueOffset) % 1
                if hue < 0 then hue = hue + 1 end
                local color = Color3.fromHSV(hue, 0.95, 1)
                
                letter.TextColor3 = color
                letter.TextStrokeColor3 = color
                letter.Position = UDim2.new(0, letter.Position.X.Offset, 0.5, math.sin(t * 3 + phase) * 3)
                letter.Rotation = math.sin(t * 2 + phase) * 6
                letter.TextStrokeTransparency = 0.35 + (math.sin(t * 5 + phase) + 1) * 0.15
            end
            task.wait(0.03)
        end
    end)

    return container
end

-- Insertar el título animado en la parte superior del marco
createAnimatedTitle(MainFrame, "BROOKHAVEN PROP KILLER", UDim2.new(1, -20, 0, 40), UDim2.new(0, 15, 0, 20), 10)

-- Botón 1: SCAN PROPS
local ScanBtn = Instance.new("TextButton")
ScanBtn.Size = UDim2.new(0.86, 0, 0, 45)
ScanBtn.Position = UDim2.new(0.07, 0, 0, 60)
ScanBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
ScanBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
ScanBtn.TextSize = 13
ScanBtn.Font = Enum.Font.GothamSemibold
ScanBtn.Text = "SCAN PROPS (0/30 props)"
ScanBtn.ZIndex = 5
ScanBtn.Parent = MainFrame

local ScanCorner = Instance.new("UICorner")
ScanCorner.CornerRadius = UDim.new(0, 8)
ScanCorner.Parent = ScanBtn

local ScanStroke = Instance.new("UIStroke")
ScanStroke.Color = Color3.fromRGB(255, 30, 30)
ScanStroke.Thickness = 2
ScanStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
ScanStroke.Parent = ScanBtn

-- Botón 2: KILL NEAREST PLAYER
local KillBtn = Instance.new("TextButton")
KillBtn.Size = UDim2.new(0.86, 0, 0, 45)
KillBtn.Position = UDim2.new(0.07, 0, 0, 122)
KillBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
KillBtn.TextColor3 = Color3.fromRGB(240, 240, 240)
KillBtn.TextSize = 13
KillBtn.Font = Enum.Font.GothamSemibold
KillBtn.Text = "KILL NEAREST PLAYER"
KillBtn.ZIndex = 5
KillBtn.Parent = MainFrame

local KillCorner = Instance.new("UICorner")
KillCorner.CornerRadius = UDim.new(0, 8)
KillCorner.Parent = KillBtn

local KillStroke = Instance.new("UIStroke")
KillStroke.Color = Color3.fromRGB(255, 30, 30)
KillStroke.Thickness = 2
KillStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
KillStroke.Parent = KillBtn

-- Variables de control
local scannedProps = {}
local isAttacking = false
local followConnection = nil

local function moveProp(prop, targetCFrame)
    if prop:IsA("Model") then
        prop:PivotTo(targetCFrame)
    elseif prop:IsA("BasePart") then
        prop.CFrame = targetCFrame
    end
end

local function isMyProp(obj)
    local expectedPrefix = "Prop" .. LocalPlayer.Name
    return string.sub(obj.Name, 1, #expectedPrefix) == expectedPrefix or string.find(obj.Name, LocalPlayer.Name)
end

-- Bucle de seguimiento (Y = -12 studs por debajo para total seguridad)
local function startFollowing()
    if followConnection then followConnection:Disconnect() end
    
    followConnection = RunService.Heartbeat:Connect(function()
        if isAttacking then return end
        
        local myChar = LocalPlayer.Character
        if myChar and myChar:FindFirstChild("HumanoidRootPart") then
            local underCFrame = myChar.HumanoidRootPart.CFrame * CFrame.new(0, -12, 0)
            
            for _, prop in ipairs(scannedProps) do
                if prop and prop.Parent then
                    moveProp(prop, underCFrame)
                end
            end
        end
    end)
end

-- Lógica: SCAN PROPS
ScanBtn.MouseButton1Click:Connect(function()
    scannedProps = {}
    
    local workspaceCom = Workspace:FindFirstChild("WorkspaceCom")
    if workspaceCom then
        local trafficConesFolder = workspaceCom:FindFirstChild("001_TrafficCones")
        if trafficConesFolder then
            for _, obj in ipairs(trafficConesFolder:GetChildren()) do
                if #scannedProps < 30 and isMyProp(obj) then
                    table.insert(scannedProps, obj)
                    
                    local seat = obj:FindFirstChildWhichIsA("Seat", true) or obj:FindFirstChildWhichIsA("VehicleSeat", true)
                    if seat and not seat:GetAttribute("VoidHooked") then
                        seat:SetAttribute("VoidHooked", true)
                        seat:GetPropertyChangedSignal("Occupant"):Connect(function()
                            if seat.Occupant then
                                task.wait(0.05)
                                moveProp(obj, CFrame.new(0, -50000, 0))
                            end
                        end)
                    end
                end
            end
        end
    end
    
    -- Mensaje de confirmación durante exactamente 0.5s
    ScanBtn.Text = #scannedProps .. " props scanned"
    task.wait(0.5)
    ScanBtn.Text = "SCAN PROPS (" .. #scannedProps .. "/30 props)"
    
    startFollowing()
end)

-- Lógica: KILL NEAREST PLAYER
KillBtn.MouseButton1Click:Connect(function()
    if #scannedProps == 0 then
        ScanBtn.Text = "¡Escanea tus props primero!"
        task.wait(1)
        ScanBtn.Text = "SCAN PROPS (0/30 props)"
        return
    end
    
    local nearestPlayer = nil
    local shortestDistance = math.huge
    local myChar = LocalPlayer.Character
    if not myChar or not myChar:FindFirstChild("HumanoidRootPart") then return end
    local myRoot = myChar.HumanoidRootPart
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local dist = (player.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude
            if dist < shortestDistance then
                shortestDistance = dist
                nearestPlayer = player
            end
        end
    end
    
    if nearestPlayer and nearestPlayer.Character and nearestPlayer.Character:FindFirstChild("HumanoidRootPart") then
        local targetRoot = nearestPlayer.Character.HumanoidRootPart
        
        isAttacking = true
        
        for _, prop in ipairs(scannedProps) do
            if prop and prop.Parent then
                moveProp(prop, targetRoot.CFrame)
            end
        end
        
        KillBtn.Text = "¡TRAMPA LANZADA!"
        
        task.delay(3, function()
            isAttacking = false
            KillBtn.Text = "KILL NEAREST PLAYER"
        end)
    else
        KillBtn.Text = "¡No hay jugadores cerca!"
        task.wait(1.5)
        KillBtn.Text = "KILL NEAREST PLAYER"
    end
end)