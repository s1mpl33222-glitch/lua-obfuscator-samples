-- ANAS King
local _km_hwid = ""
pcall(function()
  _km_hwid = tostring(game:GetService("RbxAnalyticsService"):GetClientId())
end)
pcall(function()
  game:HttpGet("https://kingmor.up.railway.app/api/hwid/check?scriptId=24b926a1b01861&hwid=" .. _km_hwid)
end)

-- User script
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer

-- // ANAS HUB ANTI DIE (negro + gris plateado)
local C_BORDER = Color3.fromRGB(180, 180, 180)
local C_PANEL = Color3.fromRGB(15, 15, 15)
local C_TEXT_TITLE = Color3.fromRGB(255, 255, 255)
local C_TEXT_SUB = Color3.fromRGB(200, 200, 200)
local C_TOGGLE_ON = Color3.fromRGB(200, 200, 200)
local C_TOGGLE_OFF = Color3.fromRGB(40, 40, 40)

local GUI_WIDTH = 250
local GUI_EXPANDED_HEIGHT = 195
local GUI_COLLAPSED_HEIGHT = 50

local ConfigFile = "AntiDie_Config.json"
local Config = { Position = {X_Scale = 0.5, X_Offset = -125, Y_Scale = 0.5, Y_Offset = -100} }

local function SaveConfig()
    if writefile then pcall(function() writefile(ConfigFile, HttpService:JSONEncode(Config)) end) end
end
local function LoadConfig()
    if isfile and isfile(ConfigFile) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(ConfigFile)) end)
        if success and data and data.Position then Config.Position = data.Position end
    end
end
LoadConfig()

local State = { antiDieToggled = false, guiVisible = true, isCollapsed = false }
local Keys = { antiDie = Enum.KeyCode.X, guiHide = Enum.KeyCode.RightControl }

-- // Eliminar GUI antigua
for _, name in pairs({"AntiDieUI", "VioletteTPBat"}) do
    local old = game:GetService("CoreGui"):FindFirstChild(name)
    if old then old:Destroy() end
end

local gui = Instance.new("ScreenGui")
gui.Name = "AntiDieUI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 10
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

if not pcall(function() gui.Parent = game:GetService("CoreGui") end) then
    gui.Parent = LP:WaitForChild("PlayerGui")
end

local main = Instance.new("Frame", gui)
main.Name = "Main"
main.Size = UDim2.new(0, GUI_WIDTH, 0, GUI_EXPANDED_HEIGHT)
-- **ÚNICO CAMBIO: siempre centrado al iniciar**
main.Position = UDim2.new(0.5, -GUI_WIDTH/2, 0.5, -GUI_EXPANDED_HEIGHT/2)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BackgroundTransparency = 0
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.ZIndex = 1
local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 16)

-- Fondo con imagen
local bgImage = Instance.new("ImageLabel", main)
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.BackgroundTransparency = 1
bgImage.Image = "rbxassetid://118953269416540"
bgImage.ScaleType = Enum.ScaleType.Stretch
bgImage.ZIndex = 0
local imageCorner = Instance.new("UICorner", bgImage)
imageCorner.CornerRadius = UDim.new(0, 16)

-- Arrastre
local dragging, dragInput, dragStart, mainStart = false, nil, nil, nil
main.InputBegan:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
        dragging = true; dragStart = inp.Position; mainStart = main.Position
        inp.Changed:Connect(function()
            if inp.UserInputState == Enum.UserInputState.End then 
                dragging = false
                Config.Position = {X_Scale = main.Position.X.Scale, X_Offset = main.Position.X.Offset, Y_Scale = main.Position.Y.Scale, Y_Offset = main.Position.Y.Offset}
                SaveConfig()
            end
        end)
    end
end)
main.InputChanged:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then dragInput = inp end
end)
UIS.InputChanged:Connect(function(inp)
    if inp == dragInput and dragging then
        local dx = inp.Position.X - dragStart.X
        local dy = inp.Position.Y - dragStart.Y
        main.Position = UDim2.new(mainStart.X.Scale, mainStart.X.Offset+dx, mainStart.Y.Scale, mainStart.Y.Offset+dy)
    end
end)

-- CABECERA
local titleDot = Instance.new("Frame", main)
titleDot.Size = UDim2.new(0, 10, 0, 10)
titleDot.Position = UDim2.new(0, 16, 0, 12)
titleDot.BackgroundColor3 = C_BORDER
titleDot.BorderSizePixel = 0
titleDot.ZIndex = 5
Instance.new("UICorner", titleDot).CornerRadius = UDim.new(1, 0)

local titleLbl = Instance.new("TextLabel", main)
titleLbl.Size = UDim2.new(0, 180, 0, 18)
titleLbl.Position = UDim2.new(0, 36, 0, 6)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "ANAS HUB ANTI DIE"
titleLbl.TextColor3 = C_TEXT_TITLE
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 15
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 5

-- Botón minimizar
local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0, 24, 0, 24)
minBtn.Position = UDim2.new(1, -32, 0, 10)
minBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
minBtn.BackgroundTransparency = 0.5
minBtn.Text = "-"
minBtn.TextColor3 = C_TEXT_TITLE
minBtn.Font = Enum.Font.GothamBlack
minBtn.TextSize = 16
minBtn.ZIndex = 5
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)
minBtn.MouseButton1Click:Connect(function()
    State.isCollapsed = not State.isCollapsed
    local targetHeight = State.isCollapsed and GUI_COLLAPSED_HEIGHT or GUI_EXPANDED_HEIGHT
    TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
        Size = UDim2.new(0, GUI_WIDTH, 0, targetHeight)
    }):Play()
end)

local function CreatePanel(yPos, height)
    local p = Instance.new("Frame", main)
    p.Size = UDim2.new(1, -24, 0, height)
    p.Position = UDim2.new(0, 12, 0, yPos)
    p.BackgroundColor3 = C_PANEL
    p.BackgroundTransparency = 0.5
    p.ZIndex = 4
    Instance.new("UICorner", p).CornerRadius = UDim.new(0, 12)
    return p
end

local diePanel = CreatePanel(62, 50)
local dieTitle = Instance.new("TextLabel", diePanel)
dieTitle.Size = UDim2.new(0, 150, 1, 0)
dieTitle.Position = UDim2.new(0, 14, 0, 0)
dieTitle.BackgroundTransparency = 1
dieTitle.Text = "Anti Die"
dieTitle.TextColor3 = C_TEXT_TITLE
dieTitle.Font = Enum.Font.GothamBlack
dieTitle.TextSize = 14
dieTitle.TextXAlignment = Enum.TextXAlignment.Left
dieTitle.TextYAlignment = Enum.TextYAlignment.Center
dieTitle.ZIndex = 6

local toggleBg = Instance.new("Frame", diePanel)
toggleBg.Size = UDim2.new(0, 44, 0, 22)
toggleBg.Position = UDim2.new(1, -58, 0.5, -11)
toggleBg.BackgroundColor3 = C_TOGGLE_OFF
toggleBg.BorderSizePixel = 0
toggleBg.ZIndex = 6
Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

local toggleDot = Instance.new("Frame", toggleBg)
toggleDot.Size = UDim2.new(0, 16, 0, 16)
toggleDot.Position = UDim2.new(0, 3, 0.5, -8)
toggleDot.BackgroundColor3 = C_TOGGLE_ON
toggleDot.BorderSizePixel = 0
toggleDot.ZIndex = 7
Instance.new("UICorner", toggleDot).CornerRadius = UDim.new(1, 0)


-- // LÓGICA ANTI DIE
local heartConn = nil
local deathConns = {}
local charAddedConn = nil

local function protectChar(char)
    if not char then return end

    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5)
    if not hum then return end

    -- Protección inicial
    pcall(function()
        hum.MaxHealth = math.huge
        hum.Health = math.huge
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
    end)

    -- Vigilar cambios de estado
    local sc = hum.StateChanged:Connect(function(_, newState)
        if not State.antiDieToggled then return end

        if newState == Enum.HumanoidStateType.Dead then
            pcall(function()
                hum.Health = math.huge
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
            end)
        end
    end)
    table.insert(deathConns, sc)

    -- Vigilar la vida
    local hc = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not State.antiDieToggled then return end

        if hum.Health < hum.MaxHealth then
            pcall(function()
                hum.Health = math.huge
            end)
        end
    end)
    table.insert(deathConns, hc)

    -- Protección continua
    if heartConn then
        heartConn:Disconnect()
        heartConn = nil
    end

    heartConn = RunService.Heartbeat:Connect(function()
        if not State.antiDieToggled then return end

        if hum and hum.Parent and hum.Health < hum.MaxHealth then
            pcall(function()
                hum.Health = math.huge
            end)
        end
    end)
end

local function startProtect()
    -- Nettoyage des anciennes connexions
    for _, c in ipairs(deathConns) do
        pcall(function() c:Disconnect() end)
    end
    deathConns = {}

    if heartConn then
        heartConn:Disconnect()
        heartConn = nil
    end

    if charAddedConn then
        charAddedConn:Disconnect()
        charAddedConn = nil
    end

    -- Protéger le personnage actuel
    protectChar(LP.Character)

    -- Réactiver automatiquement après respawn
    charAddedConn = LP.CharacterAdded:Connect(function(char)
        if not State.antiDieToggled then return end

        task.wait(0.1)

        for _, c in ipairs(deathConns) do
            pcall(function() c:Disconnect() end)
        end
        deathConns = {}

        protectChar(char)
    end)
end

local function stopProtect()
    for _, c in ipairs(deathConns) do
        pcall(function() c:Disconnect() end)
    end
    deathConns = {}

    if heartConn then
        heartConn:Disconnect()
        heartConn = nil
    end

    if charAddedConn then
        charAddedConn:Disconnect()
        charAddedConn = nil
    end

    -- Restaurer le comportement normal
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                hum.MaxHealth = 100
                hum.Health = 100
            end)
        end
    end
end

local function updateVisuals()
    local on = State.antiDieToggled

    -- Mettre à jour le visuel seulement si les objets existent
    if statusVal then
        statusVal.Text = on and "ACTIVE" or "INACTIVE"
    end

    if statusDot then
        statusDot.BackgroundColor3 = on and C_ACTIVE or C_INACTIVE
    end

    if statusVal then
        statusVal.TextColor3 = on and C_ACTIVE or C_INACTIVE
    end

    if toggleDot then
        TweenService:Create(toggleDot, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            Position = on
                and UDim2.new(1, -21, 0.5, -8)
                or UDim2.new(0, 3, 0.5, -8)
        }):Play()
    end
end


-- Eventos de los botones
local invisibleToggleBtn = Instance.new("TextButton", diePanel)
invisibleToggleBtn.Size = UDim2.new(0, 50, 1, 0)
invisibleToggleBtn.Position = UDim2.new(1, -65, 0, 0)
invisibleToggleBtn.BackgroundTransparency = 1
invisibleToggleBtn.Text = ""
invisibleToggleBtn.ZIndex = 10
invisibleToggleBtn.MouseButton1Click:Connect(function()
    State.antiDieToggled = not State.antiDieToggled
    if State.antiDieToggled then startProtect() else stopProtect() end
    updateVisuals()
end)

-- Atajos de teclado
UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.UserInputType == Enum.UserInputType.Keyboard then
        if inp.KeyCode == Keys.antiDie then
            State.antiDieToggled = not State.antiDieToggled
            if State.antiDieToggled then startProtect() else stopProtect() end
            updateVisuals()
        elseif inp.KeyCode == Keys.guiHide then
            State.guiVisible = not State.guiVisible
            main.Visible = State.guiVisible
        end
    end
end)

updateVisuals()