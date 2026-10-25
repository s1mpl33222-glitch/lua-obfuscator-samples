-- // ====================================================== //
-- // N E X U S O N E  🟣  |  Spin Practice Script v2.3
-- // ====================================================== //

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- Limpiar interfaz anterior si existe
if CoreGui:FindFirstChild("NexusOneUI") then
    CoreGui.NexusOneUI:Destroy()
end

-- 1. CREACIÓN DEL GUI PRINCIPAL
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "NexusOneUI"
ScreenGui.Parent = CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainFrame"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 22)
MainFrame.BorderColor3 = Color3.fromRGB(138, 43, 226)
MainFrame.BorderSizePixel = 2
MainFrame.Position = UDim2.new(0.5, -160, 0.4, -190)
MainFrame.Size = UDim2.new(0, 320, 0, 410)
MainFrame.Visible = true
MainFrame.Draggable = true
MainFrame.Active = true

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

-- Título
local Title = Instance.new("TextLabel")
Title.Parent = MainFrame
Title.BackgroundColor3 = Color3.fromRGB(106, 13, 173)
Title.Size = UDim2.new(1, 0, 0, 45)
Title.Font = Enum.Font.GothamBold
Title.Text = "🟣 NexusOne | Spin Practice"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 10)
TitleCorner.Parent = Title

-- 2. BOTÓN FLOTANTE ESTILO NEÓN (EXACTO AL DE TU IMAGEN CON EL NOMBRE NexusOne)
local FloatingBtn = Instance.new("TextButton")
FloatingBtn.Name = "NexusFloatingButton"
FloatingBtn.Parent = ScreenGui
FloatingBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 15) -- Fondo oscuro interno
FloatingBtn.BorderColor3 = Color3.fromRGB(0, 255, 127)
FloatingBtn.BorderSizePixel = 2
FloatingBtn.Position = UDim2.new(0, 20, 0.4, 0)
FloatingBtn.Size = UDim2.new(0, 120, 0, 55) -- Tamaño tipo círculo/tarjeta compacta
FloatingBtn.Font = Enum.Font.GothamBold
FloatingBtn.Text = "NexusOne"
FloatingBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FloatingBtn.TextSize = 13
FloatingBtn.Draggable = true

-- Bordes redondeados idénticos a la referencia
local FloatCorner = Instance.new("UICorner")
FloatCorner.CornerRadius = UDim.new(0, 14)
FloatCorner.Parent = FloatingBtn

-- Borde exterior / Trazo brillante de neón de colores
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 3
UIStroke.Parent = FloatingBtn

local StrokeGradient = Instance.new("UIGradient")
StrokeGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.0, Color3.fromRGB(138, 43, 226)), -- Morado
    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 220, 255)), -- Cian neón
    ColorSequenceKeypoint.new(1.0, Color3.fromRGB(255, 20, 147))  -- Rosado brillante
})
StrokeGradient.Parent = UIStroke

local menuOpen = true
local function toggleMenu()
    menuOpen = not menuOpen
    MainFrame.Visible = menuOpen
    if menuOpen then
        FloatingBtn.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
    else
        FloatingBtn.BackgroundColor3 = Color3.fromRGB(40, 10, 15) -- Tono rojizo sutil al cerrar
    end
end

FloatingBtn.MouseButton1Click:Connect(toggleMenu)

-- Atajo de teclado: RightShift para abrir/cerrar
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        toggleMenu()
    end
end)

-- Contenedor de Opciones
local Container = Instance.new("ScrollingFrame")
Container.Parent = MainFrame
Container.BackgroundTransparency = 1
Container.Position = UDim2.new(0, 10, 0, 55)
Container.Size = UDim2.new(1, -20, 1, -65)
Container.CanvasSize = UDim2.new(0, 0, 1.2, 0)
Container.ScrollBarThickness = 4

local UIList = Instance.new("UIListLayout")
UIList.Parent = Container
UIList.SortOrder = Enum.SortOrder.LayoutOrder
UIList.Padding = UDim.new(0, 10)

-- Creador de Botones Toggle seguros
local function createToggle(name, callback)
    local btn = Instance.new("TextButton")
    btn.Parent = Container
    btn.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
    btn.BorderColor3 = Color3.fromRGB(90, 45, 150)
    btn.Size = UDim2.new(1, 0, 0, 40)
    btn.Font = Enum.Font.GothamSemibold
    btn.Text = name .. " : [OFF]"
    btn.TextColor3 = Color3.fromRGB(180, 180, 180)
    btn.TextSize = 13

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 6)
    Corner.Parent = btn

    local enabled = false
    btn.MouseButton1Click:Connect(function()
        enabled = not enabled
        if enabled then
            btn.Text = name .. " : [ON]"
            btn.TextColor3 = Color3.fromRGB(0, 255, 127)
            btn.BorderColor3 = Color3.fromRGB(0, 255, 127)
        else
            btn.Text = name .. " : [OFF]"
            btn.TextColor3 = Color3.fromRGB(180, 180, 180)
            btn.BorderColor3 = Color3.fromRGB(90, 45, 150)
        end
        pcall(function()
            callback(enabled)
        end)
    end)
    return btn
end

-- Variables de Estado
local aimActive = false
local hitboxActive = false
local espActive = false
local wallSpeedActive = false

-- 3. FUNCIONES DEL SCRIPT

-- A) Aim Assist Inteligente (Anti-Paredes con Raycast seguro)
createToggle("Aim Assist (Anti-Paredes)", function(state)
    aimActive = state
end)

local function isVisible(targetPart)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Head") then return false end
    local origin = LocalPlayer.Character.Head.Position
    local raycastParams = RaycastParams.new()
    raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
    raycastParams.FilterDescendantsInstances = {LocalPlayer.Character}
    raycastParams.IgnoreWater = true
    
    local result = workspace:Raycast(origin, targetPart.Position - origin, raycastParams)
    if result then
        if result.Instance:IsDescendantOf(targetPart.Parent) then
            return true
        end
    end
    return false
end

local function getClosestVisiblePlayer()
    local closest = nil
    local maxDistance = 400
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = player.Character.HumanoidRootPart
            local pos, onScreen = Camera:WorldToViewportPoint(hrp.Position)
            if onScreen and isVisible(hrp) then
                local mousePos = UserInputService:GetMouseLocation()
                local dist = (Vector2.new(pos.X, pos.Y) - mousePos).Magnitude
                if dist < maxDistance then
                    maxDistance = dist
                    closest = player.Character
                end
            end
        end
    end
    return closest
end

RunService.RenderStepped:Connect(function()
    if aimActive then
        pcall(function()
            local target = getClosestVisiblePlayer()
            if target and target:FindFirstChild("HumanoidRootPart") then
                Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.HumanoidRootPart.Position), 0.2)
            end
        end)
    end
end)

-- B) Hitbox Gigante (14x14)
createToggle("Hitbox Gigante (14x14)", function(state)
    hitboxActive = state
end)

RunService.Stepped:Connect(function()
    if hitboxActive then
        pcall(function()
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                    local hrp = player.Character.HumanoidRootPart
                    hrp.Size = Vector3.new(14, 14, 14)
                    hrp.Transparency = 0.55
                    hrp.BrickColor = BrickColor.new("Magenta")
                    hrp.Material = Enum.Material.Neon
                    hrp.CanCollide = false
                end
            end
        end)
    end
end)

-- C) ESP de Jugadores
createToggle("ESP Jugadores (Nexus ESP)", function(state)
    espActive = state
end)

RunService.RenderStepped:Connect(function()
    for _, player in ipairs(Players:GetPlayers()) do
        pcall(function()
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                local head = player.Character.Head
                local bill = head:FindFirstChild("NexusESP_Tag")
                if espActive then
                    if not bill then
                        bill = Instance.new("BillboardGui")
                        bill.Name = "NexusESP_Tag"
                        bill.Size = UDim2.new(0, 130, 0, 45)
                        bill.AlwaysOnTop = true
                        bill.Adornee = head
                        
                        local txt = Instance.new("TextLabel")
                        txt.Name = "Txt"
                        txt.Size = UDim2.new(1, 0, 1, 0)
                        txt.BackgroundTransparency = 1
                        txt.TextColor3 = Color3.fromRGB(218, 112, 214)
                        txt.TextStrokeTransparency = 0
                        txt.TextSize = 13
                        txt.Font = Enum.Font.GothamBold
                        txt.Parent = bill
                        bill.Parent = head
                    end
                    bill.Txt.Text = player.Name .. "\n[🟣 NexusOne]"
                else
                    if bill then
                        bill:Destroy()
                    end
                end
            end
        end)
    end
end)

-- D) Wall Speed & Noclip
createToggle("Wall Speed & Noclip", function(state)
    wallSpeedActive = state
end)

RunService.Stepped:Connect(function()
    if wallSpeedActive then
        pcall(function()
            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                LocalPlayer.Character.Humanoid.WalkSpeed = 28
                for _, part in ipairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    end
end)