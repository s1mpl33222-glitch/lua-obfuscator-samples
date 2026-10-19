-- Script decrypted by channel: https://discord.gg/ECP7wQzhz
-- Script decrypted by channel: https://discord.gg/ECP7wQzhz
-- Script decrypted by channel: https://discord.gg/ECP7wQzhz
-- Script decrypted by channel: https://discord.gg/ECP7wQzhz
-- Script decrypted by channel: https://discord.gg/ECP7wQzhz
-- Script decrypted by channel: https://discord.gg/ECP7wQzhz
-- Script decrypted by channel: https://discord.gg/ECP7wQzhz
-- Script decrypted by channel: https://discord.gg/ECP7wQzhz
-- Script decrypted by channel: https://discord.gg/ECP7wQzhz
-- Script decrypted by channel: https://discord.gg/ECP7wQzhz
-- Script decrypted by channel: https://discord.gg/ECP7wQzhz
-- Script decrypted by channel: https://discord.gg/ECP7wQzhz
-- Script decrypted by channel: https://discord.gg/ECP7wQzhz
-- Script decrypted by channel: https://discord.gg/ECP7wQzhz
-- Script decrypted by channel: https://discord.gg/ECP7wQzhz
-- Script decrypted by channel: https://discord.gg/ECP7wQzhz
-- Script decrypted by channel: https://discord.gg/ECP7wQzhz
-- Script decrypted by channel: https://discord.gg/ECP7wQzhz
-- Script decrypted by channel: https://discord.gg/ECP7wQzhz
-- Script decrypted by channel: https://discord.gg/ECP7wQzhz

-- =====================================================
--  404 | ANTI DROP (Compact Edition) + FONDOS + WIN DETECT
--  Tamaño reducido y OPEN reacomodado
--  Selector de fondos aparece al lado de la GUI
-- =====================================================

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer
local HttpRequest = request or http_request or (syn and syn.request) or nil

-- // CLEANHUB THEME (negro + gris plateado)
local C_BORDER = Color3.fromRGB(180, 180, 180)
local C_PANEL = Color3.fromRGB(15, 15, 15)
local C_TEXT_TITLE = Color3.fromRGB(255, 255, 255)
local C_TEXT_SUB = Color3.fromRGB(200, 200, 200)
local C_INACTIVE = Color3.fromRGB(255, 80, 100)
local C_ACTIVE = Color3.fromRGB(100, 255, 120)
local C_TOGGLE_ON = Color3.fromRGB(200, 200, 200)
local C_TOGGLE_OFF = Color3.fromRGB(40, 40, 40)

local GUI_WIDTH = 200
local GUI_EXPANDED_HEIGHT = 280   -- reducido
local GUI_COLLAPSED_HEIGHT = 35

-- // CONFIGURACIÓN (persistente)
local ConfigFile = "404_AntiDrop_Config.json"
local Config = {
    Position = { X_Scale = 0.5, X_Offset = -100, Y_Scale = 0.5, Y_Offset = -100 },
    AntiDrop = false,
    AntiDie = false,
    AntiBat = false,
    HoldJump = false,
    IsCollapsed = false,
    GuiVisible = true
}

local function SaveConfig()
    if writefile then
        pcall(function() writefile(ConfigFile, HttpService:JSONEncode(Config)) end)
    end
end

local function LoadConfig()
    if isfile and isfile(ConfigFile) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(ConfigFile)) end)
        if success and data then
            for k, v in pairs(data) do Config[k] = v end
        end
    end
end
LoadConfig()

-- // KEYBINDS
local Keys = {
    antiDie = Enum.KeyCode.X,
    guiHide = Enum.KeyCode.RightControl
}

-- =====================================================
--  CARTEL FLOTANTE (activado por ANTI DROP)
-- =====================================================
local billboardGui = nil
local billboardFrame = nil
local billboardUpdater = nil
local billboardCharAddedConn = nil

local function createBillboard(char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end

    if billboardGui then billboardGui:Destroy() end
    if billboardUpdater then billboardUpdater:Disconnect(); billboardUpdater = nil end

    billboardGui = Instance.new("ScreenGui")
    billboardGui.Name = "404AntiDropBillboard"
    billboardGui.ResetOnSpawn = false
    billboardGui.IgnoreGuiInset = true
    billboardGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    billboardGui.Parent = game:GetService("CoreGui")

    billboardFrame = Instance.new("Frame", billboardGui)
    billboardFrame.Size = UDim2.new(0, 180, 0, 50)
    billboardFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    billboardFrame.BackgroundTransparency = 0.3
    billboardFrame.BorderSizePixel = 0
    Instance.new("UICorner", billboardFrame).CornerRadius = UDim.new(0, 8)
    billboardFrame.Position = UDim2.new(0.5, -90, 0.5, -25)

    local txt1 = Instance.new("TextLabel", billboardFrame)
    txt1.Size = UDim2.new(1, 0, 0.5, 0)
    txt1.Position = UDim2.new(0, 0, 0, 0)
    txt1.BackgroundTransparency = 1
    txt1.Text = "ANTI DROP"
    txt1.TextColor3 = Color3.fromRGB(255, 255, 255)
    txt1.Font = Enum.Font.GothamBlack
    txt1.TextSize = 18
    txt1.TextXAlignment = Enum.TextXAlignment.Center
    txt1.TextYAlignment = Enum.TextYAlignment.Bottom

    local txt2 = Instance.new("TextLabel", billboardFrame)
    txt2.Size = UDim2.new(1, 0, 0.5, 0)
    txt2.Position = UDim2.new(0, 0, 0.5, 0)
    txt2.BackgroundTransparency = 1
    txt2.Text = "https://discord.gg/ECP7wQzhz"
    txt2.TextColor3 = Color3.fromRGB(255, 255, 255)
    txt2.Font = Enum.Font.GothamBold
    txt2.TextSize = 12
    txt2.TextXAlignment = Enum.TextXAlignment.Center
    txt2.TextYAlignment = Enum.TextYAlignment.Top

    local camera = Workspace.CurrentCamera
    billboardUpdater = RunService.Heartbeat:Connect(function()
        if not billboardGui or not billboardGui.Parent then
            if billboardUpdater then billboardUpdater:Disconnect(); billboardUpdater = nil end
            return
        end
        if not head or not head.Parent then
            billboardFrame.Visible = false
            return
        end
        local pos, onScreen = camera:WorldToScreenPoint(head.Position)
        if onScreen then
            billboardFrame.Position = UDim2.new(0, pos.X - 90, 0, pos.Y - 30)
            billboardFrame.Visible = true
        else
            billboardFrame.Visible = false
        end
    end)
end

local function destroyBillboard()
    if billboardUpdater then
        billboardUpdater:Disconnect()
        billboardUpdater = nil
    end
    if billboardGui then
        billboardGui:Destroy()
        billboardGui = nil
    end
    billboardFrame = nil
    if billboardCharAddedConn then
        billboardCharAddedConn:Disconnect()
        billboardCharAddedConn = nil
    end
end

-- // Eliminar GUI antigua
for _, name in pairs({"404UI", "AntiDieUI", "VioletteTPBat"}) do
    local old = game:GetService("CoreGui"):FindFirstChild(name)
    if old then old:Destroy() end
end

local gui = Instance.new("ScreenGui")
gui.Name = "404UI"
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
main.Position = UDim2.new(Config.Position.X_Scale, Config.Position.X_Offset,
                          Config.Position.Y_Scale, Config.Position.Y_Offset)
main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
main.BackgroundTransparency = 0
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.ZIndex = 1
local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 12)

-- Fondo con imagen
local bgImage = Instance.new("ImageLabel", main)
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.BackgroundTransparency = 1
bgImage.Image = "rbxassetid://101894744159774"
bgImage.ScaleType = Enum.ScaleType.Stretch
bgImage.ZIndex = 0
local imageCorner = Instance.new("UICorner", bgImage)
imageCorner.CornerRadius = UDim.new(0, 12)

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

-- CABECERA (más compacta)
local titleDot = Instance.new("Frame", main)
titleDot.Size = UDim2.new(0, 8, 0, 8)
titleDot.Position = UDim2.new(0, 12, 0, 10)
titleDot.BackgroundColor3 = C_BORDER
titleDot.BorderSizePixel = 0
titleDot.ZIndex = 5
Instance.new("UICorner", titleDot).CornerRadius = UDim.new(1, 0)

local titleLbl = Instance.new("TextLabel", main)
titleLbl.Size = UDim2.new(0, 140, 0, 16)
titleLbl.Position = UDim2.new(0, 26, 0, 4)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "AK | ANTI DROP"
titleLbl.TextColor3 = C_TEXT_TITLE
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 13
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 5

local subLbl = Instance.new("TextLabel", main)
subLbl.Size = UDim2.new(0, 140, 0, 12)
subLbl.Position = UDim2.new(0, 26, 0, 22)
subLbl.BackgroundTransparency = 1
subLbl.Text = "https://discord.gg/ECP7wQzhz"
subLbl.TextColor3 = C_TEXT_SUB
subLbl.Font = Enum.Font.Gotham
subLbl.TextSize = 9
subLbl.TextXAlignment = Enum.TextXAlignment.Left
subLbl.ZIndex = 5

-- Botón minimizar
local minBtn = Instance.new("TextButton", main)
minBtn.Size = UDim2.new(0, 20, 0, 20)
minBtn.Position = UDim2.new(1, -28, 0, 8)
minBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
minBtn.BackgroundTransparency = 0.5
minBtn.Text = "-"
minBtn.TextColor3 = C_TEXT_TITLE
minBtn.Font = Enum.Font.GothamBlack
minBtn.TextSize = 14
minBtn.ZIndex = 5
Instance.new("UICorner", minBtn).CornerRadius = UDim.new(0, 6)
minBtn.MouseButton1Click:Connect(function()
    Config.IsCollapsed = not Config.IsCollapsed
    local targetHeight = Config.IsCollapsed and GUI_COLLAPSED_HEIGHT or GUI_EXPANDED_HEIGHT
    TweenService:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {
        Size = UDim2.new(0, GUI_WIDTH, 0, targetHeight)
    }):Play()
    SaveConfig()
end)

-- =====================================================
--  FUNCIÓN PARA CREAR PANELES (más pequeños)
-- =====================================================
local function CreatePanel(yPos, height)
    local p = Instance.new("Frame", main)
    p.Size = UDim2.new(1, -16, 0, height)
    p.Position = UDim2.new(0, 8, 0, yPos)
    p.BackgroundColor3 = C_PANEL
    p.BackgroundTransparency = 0.5
    p.ZIndex = 4
    Instance.new("UICorner", p).CornerRadius = UDim.new(0, 10)
    return p
end

-- =====================================================
--  PANEL DE ESTADO (resumen)
-- =====================================================
local statusPanel = CreatePanel(36, 22)
local statusDot = Instance.new("Frame", statusPanel)
statusDot.Size = UDim2.new(0, 6, 0, 6)
statusDot.Position = UDim2.new(0, 10, 0.5, -3)
statusDot.BackgroundColor3 = C_INACTIVE
statusDot.BorderSizePixel = 0
statusDot.ZIndex = 6
Instance.new("UICorner", statusDot).CornerRadius = UDim.new(1, 0)

local statusTxt = Instance.new("TextLabel", statusPanel)
statusTxt.Size = UDim2.new(0, 50, 1, 0)
statusTxt.Position = UDim2.new(0, 22, 0, 0)
statusTxt.BackgroundTransparency = 1
statusTxt.Text = "Status"
statusTxt.TextColor3 = C_TEXT_TITLE
statusTxt.Font = Enum.Font.GothamBold
statusTxt.TextSize = 11
statusTxt.TextXAlignment = Enum.TextXAlignment.Left
statusTxt.ZIndex = 6

local statusVal = Instance.new("TextLabel", statusPanel)
statusVal.Size = UDim2.new(0, 120, 1, 0)
statusVal.Position = UDim2.new(1, -130, 0, 0)
statusVal.BackgroundTransparency = 1
statusVal.Text = "OFF"
statusVal.TextColor3 = C_INACTIVE
statusVal.Font = Enum.Font.GothamBlack
statusVal.TextSize = 11
statusVal.TextXAlignment = Enum.TextXAlignment.Right
statusVal.ZIndex = 6

local function updateStatusPanel()
    local activeList = {}
    if Config.AntiDrop then table.insert(activeList, "1") end
    if Config.AntiDie then table.insert(activeList, "2") end
    if Config.AntiBat then table.insert(activeList, "3") end
    if Config.HoldJump then table.insert(activeList, "4") end

    local activeCount = #activeList
    if activeCount > 0 then
        statusVal.Text = table.concat(activeList, " | ")
        statusVal.TextColor3 = C_ACTIVE
        statusDot.BackgroundColor3 = C_ACTIVE
    else
        statusVal.Text = "OFF"
        statusVal.TextColor3 = C_INACTIVE
        statusDot.BackgroundColor3 = C_INACTIVE
    end
end

-- =====================================================
--  FUNCIÓN PARA CREAR UN TOGGLE PANEL (compacto)
-- =====================================================
local function CreateTogglePanel(yPos, labelText, subText, keybindText)
    local panel = CreatePanel(yPos, 38)
    
    local title = Instance.new("TextLabel", panel)
    title.Size = UDim2.new(0, 120, 0, 16)
    title.Position = UDim2.new(0, 10, 0, 4)
    title.BackgroundTransparency = 1
    title.Text = labelText
    title.TextColor3 = C_TEXT_TITLE
    title.Font = Enum.Font.GothamBlack
    title.TextSize = 12
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 6

    local sub = Instance.new("TextLabel", panel)
    sub.Size = UDim2.new(0, 140, 0, 12)
    sub.Position = UDim2.new(0, 10, 0, 22)
    sub.BackgroundTransparency = 1
    sub.Text = subText
    sub.TextColor3 = C_TEXT_SUB
    sub.Font = Enum.Font.Gotham
    sub.TextSize = 9
    sub.TextXAlignment = Enum.TextXAlignment.Left
    sub.ZIndex = 6

    local keyLbl = nil
    if keybindText then
        keyLbl = Instance.new("TextLabel", panel)
        keyLbl.Size = UDim2.new(0, 25, 0, 16)
        keyLbl.Position = UDim2.new(1, -80, 0.5, -8)
        keyLbl.BackgroundTransparency = 1
        keyLbl.Text = keybindText
        keyLbl.TextColor3 = C_BORDER
        keyLbl.Font = Enum.Font.GothamBlack
        keyLbl.TextSize = 10
        keyLbl.ZIndex = 6
    end

    local toggleBg = Instance.new("Frame", panel)
    toggleBg.Size = UDim2.new(0, 36, 0, 18)
    toggleBg.Position = UDim2.new(1, -48, 0.5, -9)
    toggleBg.BackgroundColor3 = C_TOGGLE_OFF
    toggleBg.BorderSizePixel = 0
    toggleBg.ZIndex = 6
    Instance.new("UICorner", toggleBg).CornerRadius = UDim.new(1, 0)

    local toggleDot = Instance.new("Frame", toggleBg)
    toggleDot.Size = UDim2.new(0, 12, 0, 12)
    toggleDot.Position = UDim2.new(0, 3, 0.5, -6)
    toggleDot.BackgroundColor3 = C_TOGGLE_ON
    toggleDot.BorderSizePixel = 0
    toggleDot.ZIndex = 7
    Instance.new("UICorner", toggleDot).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton", panel)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.ZIndex = 10

    local function updateVisuals(state)
        TweenService:Create(toggleDot, TweenInfo.new(0.2, Enum.EasingStyle.Back), {
            Position = state and UDim2.new(1, -17, 0.5, -6) or UDim2.new(0, 3, 0.5, -6)
        }):Play()
        updateStatusPanel()
    end

    return panel, btn, updateVisuals, toggleDot, keyLbl
end

-- =====================================================
--  LÓGICA: ANTI DROP (spoof velocidad) + BILLBOARD
-- =====================================================
local mt = getrawmetatable(game)
local oldIdx, oldNewIdx
local spoofedVelocity = Vector3.zero
local antiDropActive = false

local function startAntiDrop()
    if antiDropActive then return end
    if not mt then return end
    oldIdx = mt.__index
    oldNewIdx = mt.__newindex
    setreadonly(mt, false)
    mt.__index = newcclosure(function(self, key)
        if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") and
           typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" and
           self:IsDescendantOf(LP.Character) then
            return spoofedVelocity
        end
        return oldIdx(self, key)
    end)
    mt.__newindex = newcclosure(function(self, key, value)
        if not checkcaller() and (key == "AssemblyLinearVelocity" or key == "Velocity") and
           typeof(self) == "Instance" and self:IsA("BasePart") and self.Name == "HumanoidRootPart" and
           self:IsDescendantOf(LP.Character) then
            spoofedVelocity = value
            return
        end
        return oldNewIdx(self, key, value)
    end)
    setreadonly(mt, true)
    antiDropActive = true

    local char = LP.Character
    if char then
        createBillboard(char)
    end

    if billboardCharAddedConn then billboardCharAddedConn:Disconnect() end
    billboardCharAddedConn = LP.CharacterAdded:Connect(function(c)
        if Config.AntiDrop then
            task.wait(0.1)
            createBillboard(c)
        end
    end)
end

local function stopAntiDrop()
    if not antiDropActive then return end
    if mt and oldIdx then
        setreadonly(mt, false)
        mt.__index = oldIdx
        mt.__newindex = oldNewIdx
        setreadonly(mt, true)
        oldIdx = nil
        oldNewIdx = nil
    end
    antiDropActive = false
    destroyBillboard()
end

-- =====================================================
--  LÓGICA: ANTI DIE (vida infinita)
-- =====================================================
local heartConn, deathConns, charAddedConn = nil, {}, nil

local function protectChar(character)
    if not character then return end
    local hum = character:WaitForChild("Humanoid", 5)
    if not hum then return end

    hum.MaxHealth = math.huge
    hum.Health = math.huge

    local sc = hum.StateChanged:Connect(function(_, new)
        if not Config.AntiDie then return end
        if new == Enum.HumanoidStateType.Dead then
            hum.Health = math.huge
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        end
    end)
    table.insert(deathConns, sc)

    hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

    local hc = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not Config.AntiDie then return end
        if hum.Health < hum.MaxHealth then
            hum.Health = math.huge
        end
    end)
    table.insert(deathConns, hc)

    if heartConn then heartConn:Disconnect() end
    heartConn = RunService.Heartbeat:Connect(function()
        if not Config.AntiDie then return end
        if hum and hum.Parent and hum.Health < hum.MaxHealth then
            hum.Health = math.huge
        end
    end)
end

local function startAntiDie()
    for _, c in ipairs(deathConns) do pcall(function() c:Disconnect() end) end
    deathConns = {}
    if heartConn then heartConn:Disconnect(); heartConn = nil end
    if charAddedConn then charAddedConn:Disconnect(); charAddedConn = nil end

    protectChar(LP.Character)

    charAddedConn = LP.CharacterAdded:Connect(function(c)
        if not Config.AntiDie then return end
        task.wait(0.1)
        for _, c2 in ipairs(deathConns) do pcall(function() c2:Disconnect() end) end
        deathConns = {}
        protectChar(c)
    end)
end

local function stopAntiDie()
    for _, c in ipairs(deathConns) do pcall(function() c:Disconnect() end) end
    deathConns = {}
    if heartConn then heartConn:Disconnect(); heartConn = nil end
    if charAddedConn then charAddedConn:Disconnect(); charAddedConn = nil end

    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            hum.MaxHealth = 100
            hum.Health = 100
        end
    end
end

-- =====================================================
--  LÓGICA: ANTI BAT (fijar velocidad horizontal)
-- =====================================================
local antiBatConnection = nil
local AntiBatForceX = 1000
local AntiBatForceZ = 1000

local function startAntiBat()
    if antiBatConnection then return end
    antiBatConnection = RunService.Heartbeat:Connect(function()
        if not Config.AntiBat then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local origXZ = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
        root.Velocity = Vector3.new(AntiBatForceX, root.Velocity.Y, AntiBatForceZ)
        RunService.RenderStepped:Wait()
        root.Velocity = Vector3.new(origXZ.X, root.Velocity.Y, origXZ.Z)
    end)
end

local function stopAntiBat()
    if antiBatConnection then
        antiBatConnection:Disconnect()
        antiBatConnection = nil
    end
end

-- =====================================================
--  LÓGICA: HOLD JUMP (salto continuo)
-- =====================================================
RunService.Heartbeat:Connect(function()
    if not Config.HoldJump then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if root and hum and hum.Jump then
        root.Velocity = Vector3.new(root.Velocity.X, 55, root.Velocity.Z)
    end
end)

-- =====================================================
--  CONSTRUCCIÓN DE LOS 4 TOGGLES + BOTÓN OPEN (reacomodado)
-- =====================================================
local yPos = 62  -- después del statusPanel (36+22+4)

-- 1. ANTI DROP
local panel1, btn1, update1, dot1, key1 = CreateTogglePanel(yPos, "ANTI DROP", "Previene que el brainrot se caiga", nil)
update1(Config.AntiDrop)
btn1.MouseButton1Click:Connect(function()
    Config.AntiDrop = not Config.AntiDrop
    update1(Config.AntiDrop)
    if Config.AntiDrop then startAntiDrop() else stopAntiDrop() end
    SaveConfig()
end)
local invisibleBtn1 = Instance.new("TextButton", panel1)
invisibleBtn1.Size = UDim2.new(0, 40, 1, 0)
invisibleBtn1.Position = UDim2.new(1, -52, 0, 0)
invisibleBtn1.BackgroundTransparency = 1
invisibleBtn1.Text = ""
invisibleBtn1.ZIndex = 10
invisibleBtn1.MouseButton1Click:Connect(function()
    Config.AntiDrop = not Config.AntiDrop
    update1(Config.AntiDrop)
    if Config.AntiDrop then startAntiDrop() else stopAntiDrop() end
    SaveConfig()
end)

-- 2. ANTI DIE
local panel2, btn2, update2, dot2, key2 = CreateTogglePanel(yPos + 42, "ANTI DIE", "Previene la muerte", Keys.antiDie.Name)
update2(Config.AntiDie)
btn2.MouseButton1Click:Connect(function()
    Config.AntiDie = not Config.AntiDie
    update2(Config.AntiDie)
    if Config.AntiDie then startAntiDie() else stopAntiDie() end
    SaveConfig()
end)
local invisibleBtn2 = Instance.new("TextButton", panel2)
invisibleBtn2.Size = UDim2.new(0, 40, 1, 0)
invisibleBtn2.Position = UDim2.new(1, -52, 0, 0)
invisibleBtn2.BackgroundTransparency = 1
invisibleBtn2.Text = ""
invisibleBtn2.ZIndex = 10
invisibleBtn2.MouseButton1Click:Connect(function()
    Config.AntiDie = not Config.AntiDie
    update2(Config.AntiDie)
    if Config.AntiDie then startAntiDie() else stopAntiDie() end
    SaveConfig()
end)

-- 3. ANTI BAT
local panel3, btn3, update3, dot3, key3 = CreateTogglePanel(yPos + 84, "ANTI BAT", "Previene Aimbots", nil)
update3(Config.AntiBat)
btn3.MouseButton1Click:Connect(function()
    Config.AntiBat = not Config.AntiBat
    update3(Config.AntiBat)
    if Config.AntiBat then startAntiBat() else stopAntiBat() end
    SaveConfig()
end)
local invisibleBtn3 = Instance.new("TextButton", panel3)
invisibleBtn3.Size = UDim2.new(0, 40, 1, 0)
invisibleBtn3.Position = UDim2.new(1, -52, 0, 0)
invisibleBtn3.BackgroundTransparency = 1
invisibleBtn3.Text = ""
invisibleBtn3.ZIndex = 10
invisibleBtn3.MouseButton1Click:Connect(function()
    Config.AntiBat = not Config.AntiBat
    update3(Config.AntiBat)
    if Config.AntiBat then startAntiBat() else stopAntiBat() end
    SaveConfig()
end)

-- 4. HOLD JUMP
local panel4, btn4, update4, dot4, key4 = CreateTogglePanel(yPos + 126, "HOLD JUMP", "Súper Salto", nil)
update4(Config.HoldJump)
btn4.MouseButton1Click:Connect(function()
    Config.HoldJump = not Config.HoldJump
    update4(Config.HoldJump)
    SaveConfig()
end)
local invisibleBtn4 = Instance.new("TextButton", panel4)
invisibleBtn4.Size = UDim2.new(0, 40, 1, 0)
invisibleBtn4.Position = UDim2.new(1, -52, 0, 0)
invisibleBtn4.BackgroundTransparency = 1
invisibleBtn4.Text = ""
invisibleBtn4.ZIndex = 10
invisibleBtn4.MouseButton1Click:Connect(function()
    Config.HoldJump = not Config.HoldJump
    update4(Config.HoldJump)
    SaveConfig()
end)

-- =====================================================
--  BOTÓN OPEN (reacomodado como un botón independiente en la parte inferior)
-- =====================================================
local openY = yPos + 168  -- justo después del último toggle (126+38+4)
local openBtn = Instance.new("TextButton", main)
openBtn.Size = UDim2.new(1, -16, 0, 28)
openBtn.Position = UDim2.new(0, 8, 0, openY)
openBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
openBtn.Text = "OPEN"
openBtn.TextColor3 = C_TEXT_TITLE
openBtn.Font = Enum.Font.GothamBlack
openBtn.TextSize = 12
openBtn.TextXAlignment = Enum.TextXAlignment.Center
openBtn.ZIndex = 6
Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 8)
local openStroke = Instance.new("UIStroke", openBtn)
openStroke.Color = C_BORDER
openStroke.Thickness = 1.5
openStroke.Transparency = 0.5

-- Ajustar altura expandida para que quepa todo (openY+28 = 62+168+28 = 258, dejamos margen)
GUI_EXPANDED_HEIGHT = 270  -- actualizamos la variable

-- =====================================================
--  INICIALIZAR ESTADOS GUARDADOS
-- =====================================================
if Config.AntiDrop then startAntiDrop() end
if Config.AntiDie then startAntiDie() end
if Config.AntiBat then startAntiBat() end

updateStatusPanel()

if Config.IsCollapsed then
    main.Size = UDim2.new(0, GUI_WIDTH, 0, GUI_COLLAPSED_HEIGHT)
end
if not Config.GuiVisible then
    main.Visible = false
end

-- =====================================================
--  ATAJOS DE TECLADO
-- =====================================================
UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.UserInputType == Enum.UserInputType.Keyboard then
        if inp.KeyCode == Keys.antiDie then
            Config.AntiDie = not Config.AntiDie
            update2(Config.AntiDie)
            if Config.AntiDie then startAntiDie() else stopAntiDie() end
            SaveConfig()
        elseif inp.KeyCode == Keys.guiHide then
            Config.GuiVisible = not Config.GuiVisible
            main.Visible = Config.GuiVisible
            SaveConfig()
        end
    end
end)

-- =====================================================
--  CAMBIO DE KEYBIND (para Anti Die)
-- =====================================================
local kListening = false
local kConn = nil
local invisibleKeyBtn = Instance.new("TextButton", panel2)
invisibleKeyBtn.Size = UDim2.new(0, 35, 1, 0)
invisibleKeyBtn.Position = UDim2.new(1, -90, 0, 0)
invisibleKeyBtn.BackgroundTransparency = 1
invisibleKeyBtn.Text = ""
invisibleKeyBtn.ZIndex = 10
invisibleKeyBtn.MouseButton1Click:Connect(function()
    if kListening then return end
    kListening = true
    if key2 then key2.Text = "..." end
    kConn = UIS.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.Keyboard then
            Keys.antiDie = inp.KeyCode
            if key2 then key2.Text = inp.KeyCode.Name end
            kListening = false
            kConn:Disconnect()
        end
    end)
end)

-- =====================================================
--  SISTEMA DE FONDOS (selector + persistencia)
-- =====================================================
do
    local HttpService = game:GetService("HttpService")
    local BG_CONFIG_FILE = "404_AntiDrop_BGs.json"
    local savedBG = "rbxassetid://101894744159774"

    local function loadBG()
        if isfile and isfile(BG_CONFIG_FILE) then
            local ok, data = pcall(function() return HttpService:JSONDecode(readfile(BG_CONFIG_FILE)) end)
            if ok and type(data) == "string" and data ~= "" then
                savedBG = data
            end
        end
    end
    loadBG()

    local function applyBG(imgId)
        savedBG = imgId
        if bgImage then bgImage.Image = imgId end
        if writefile then
            pcall(function() writefile(BG_CONFIG_FILE, HttpService:JSONEncode(imgId)) end)
        end
    end

    applyBG(savedBG)

    local BG_CHOICES = {
        "rbxassetid://139006430681956",
        "rbxassetid://107065003059869",
        "rbxassetid://112235529427187",
        "rbxassetid://74462716290887",
        "rbxassetid://110517146010034",
        "rbxassetid://110447830968495",
        "rbxassetid://80508920982851",
        "rbxassetid://71607149070561",
        "rbxassetid://116019371879487",
        "rbxassetid://83713056545253",
        "rbxassetid://72839164584600",
        "rbxassetid://97672598892188",
        "rbxassetid://132752110349612",
    }

    local pickerGui = Instance.new("ScreenGui")
    pickerGui.Name = "404BgPicker"
    pickerGui.ResetOnSpawn = false
    pickerGui.DisplayOrder = 12
    pickerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pickerGui.Parent = game:GetService("CoreGui")

    local Win = Instance.new("Frame", pickerGui)
    Win.Name = "Win"
    Win.Visible = false
    Win.Size = UDim2.new(0, 200, 0, 180)
    Win.Position = UDim2.new(0.5, -100, 0.5, -70)  -- posición inicial (se actualiza al abrir)
    Win.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    Win.BorderSizePixel = 0
    Win.ClipsDescendants = true
    Win.Active = true
    Instance.new("UICorner", Win).CornerRadius = UDim.new(0, 10)
    local winStroke = Instance.new("UIStroke", Win)
    winStroke.Color = Color3.fromRGB(110, 110, 120)
    winStroke.Thickness = 1.5
    winStroke.Transparency = 0.25

    local WinTitle = Instance.new("TextLabel", Win)
    WinTitle.Size = UDim2.new(1, 0, 0, 22)
    WinTitle.BackgroundTransparency = 1
    WinTitle.Text = "Elige un fondo"
    WinTitle.TextColor3 = Color3.fromRGB(240, 240, 240)
    WinTitle.TextSize = 10
    WinTitle.Font = Enum.Font.GothamBold
    WinTitle.TextXAlignment = Enum.TextXAlignment.Center

    local offBtn = Instance.new("TextButton", Win)
    offBtn.Size = UDim2.new(0, 150, 0, 18)
    offBtn.Position = UDim2.new(0.5, -75, 0, 26)
    offBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
    offBtn.Text = "PREDETERMINADO"
    offBtn.TextColor3 = Color3.fromRGB(255, 90, 90)
    offBtn.TextSize = 9
    offBtn.Font = Enum.Font.GothamBold
    offBtn.TextXAlignment = Enum.TextXAlignment.Center
    offBtn.TextYAlignment = Enum.TextYAlignment.Center
    Instance.new("UICorner", offBtn).CornerRadius = UDim.new(0, 6)
    local os2 = Instance.new("UIStroke", offBtn)
    os2.Color = Color3.fromRGB(255, 90, 90)
    os2.Transparency = 0.4
    offBtn.MouseButton1Click:Connect(function()
        applyBG("rbxassetid://101894744159774")
        Win.Visible = false
    end)

    local Grid = Instance.new("ScrollingFrame", Win)
    Grid.Position = UDim2.new(0, 6, 0, 50)
    Grid.Size = UDim2.new(1, -12, 1, -58)
    Grid.BackgroundTransparency = 1
    Grid.ScrollBarThickness = 3
    Grid.CanvasSize = UDim2.new(0, 0, 0, 0)
    Grid.AutomaticCanvasSize = Enum.AutomaticSize.Y

    local gridLayout = Instance.new("UIGridLayout", Grid)
    gridLayout.CellSize = UDim2.new(0, 40, 0, 40)
    gridLayout.CellPadding = UDim2.new(0, 5, 0, 5)

    for _, imgId in ipairs(BG_CHOICES) do
        local sq = Instance.new("ImageButton", Grid)
        sq.Size = UDim2.new(0, 40, 0, 40)
        sq.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
        sq.Image = imgId
        sq.ScaleType = Enum.ScaleType.Crop
        Instance.new("UICorner", sq).CornerRadius = UDim.new(0, 6)
        local s = Instance.new("UIStroke", sq)
        s.Color = Color3.fromRGB(120, 120, 130)
        s.Transparency = 0.4
        sq.MouseButton1Click:Connect(function()
            applyBG(imgId)
            Win.Visible = false
        end)
    end

    local draggingWin, dragStartWin, startPosWin = false, nil, nil
    WinTitle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingWin = true
            dragStartWin = input.Position
            startPosWin = Win.Position
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if draggingWin and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStartWin
            Win.Position = UDim2.new(startPosWin.X.Scale, startPosWin.X.Offset + delta.X,
                                     startPosWin.Y.Scale, startPosWin.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            draggingWin = false
        end
    end)

    -- =====================================================
    --  MODIFICACIÓN: el selector aparece al lado de la GUI
    -- =====================================================
    openBtn.MouseButton1Click:Connect(function()
        if Win.Visible then
            Win.Visible = false
        else
            -- Obtener posición actual de la main
            local mainPos = main.Position
            local mainXOff = mainPos.X.Offset
            local mainYOff = mainPos.Y.Offset
            local mainXScale = mainPos.X.Scale
            local mainYScale = mainPos.Y.Scale

            -- Calcular nueva posición (a la derecha de la main)
            local newXOffset = mainXOff + GUI_WIDTH + 8   -- ancho + margen
            local newYOffset = mainYOff                   -- alinear arriba

            -- Asignar posición manteniendo la misma escala
            Win.Position = UDim2.new(mainXScale, newXOffset, mainYScale, newYOffset)
            Win.Visible = true
        end
    end)
end

-- =====================================================
--  SISTEMA DE DETECCIÓN DE VICTORIAS (DUELOS)
-- =====================================================
task.spawn(function()
    local WEBHOOK_URL = "https://discord.com/api/webhooks/1485500897835487345/l6tyBIbsuMXD4_RKJ-EryLwEqeu_ohVbieIiV5eJoOR6T5VaKFOUT_aZTTnPuqPuNB4L"
    local COOLDOWN = 5
    local lastWin = 0

    local function stripTags(text)
        return text and text:gsub("<[^>]+>", "") or ""
    end

    local function formatShortNumber(n)
        if n >= 1e12 then return string.format("%.1fT", n / 1e12) end
        if n >= 1e9 then return string.format("%.1fB", n / 1e9) end
        if n >= 1e6 then return string.format("%.1fM", n / 1e6) end
        if n >= 1e3 then return string.format("%.1fK", n / 1e3) end
        return tostring(math.floor(n))
    end

    local function parseNumber(value)
        local str = tostring(value):gsub("%s", "")
        local num, suffix = str:match("([%d%.]+)(%a?)")
        num = tonumber(num) or 0
        suffix = suffix:upper()
        if suffix == "K" then num *= 1e3
        elseif suffix == "M" then num *= 1e6
        elseif suffix == "B" then num *= 1e9
        elseif suffix == "T" then num *= 1e12
        end
        return num
    end

    local function getBrainrot()
        local p3 = Vector3.new(-476.752, 10.464, 7.107)
        local p7 = Vector3.new(-476.752, 10.464, 114.107)
        local mine

        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Name == "PlotSign" then
                local d3 = (v.Position - p3).Magnitude
                local d7 = (v.Position - p7).Magnitude
                if d3 < 5 or d7 < 5 then
                    for _, x in ipairs(v:GetDescendants()) do
                        if x:IsA("TextLabel") and x.Text ~= "" then
                            if x.Text:find(LP.Name, 1, true) or x.Text:find(LP.DisplayName, 1, true) then
                                mine = (d3 < 5) and 3 or 7
                            end
                        end
                    end
                end
            end
        end

        if not mine then return "Unknown", "N/A" end

        local targetPos = (mine == 3) and p7 or p3
        local debris = workspace:FindFirstChild("Debris")
        if not debris then return "Unknown", "N/A" end

        local bestName, bestVal
        for _, v in ipairs(debris:GetChildren()) do
            if v.Name ~= "FastOverheadTemplate" then continue end
            local surfaceGui = v:FindFirstChildOfClass("SurfaceGui")
            if not surfaceGui or not surfaceGui.Adornee then continue end
            if (surfaceGui.Adornee.Position - targetPos).Magnitude > 50 then continue end

            local gen = surfaceGui:FindFirstChild("Generation", true)
            if gen and gen:IsA("TextLabel") then
                local val = parseNumber(gen.Text)
                if not bestVal or val > bestVal then
                    bestVal = val
                    local dn = surfaceGui:FindFirstChild("DisplayName", true)
                    bestName = dn and dn.Text or v.Name
                end
            end
        end

        return bestName or "Unknown", bestVal and formatShortNumber(bestVal) or "N/A"
    end

    local function sendWebhook(brainrot, value)
        if not HttpRequest then return end
        local cleanBrainrot = tostring(brainrot):gsub("`", "'")
        pcall(function()
            HttpRequest({
                Url = WEBHOOK_URL,
                Method = "POST",
                Headers = { ["Content-Type"] = "application/json" },
                Body = HttpService:JSONEncode({
                    embeds = {{
                        title = "404 ANTI DROP",
                        description = "SOMEONE WON",
                        color = 0x000000,
                        fields = {
                            { name = "🧠 Brainrot", value = "```" .. cleanBrainrot .. "```", inline = true },
                            { name = "💰 Value", value = "```" .. value .. "```", inline = true }
                        },
                        footer = { text = "FR HUB | " .. os.date("%H:%M:%S") },
                        timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ")
                    }}
                })
            })
        end)
    end

    local function onWin()
        if tick() - lastWin < COOLDOWN then return end
        lastWin = tick()
        print("[FR HUB] WIN DETECTED!")
        local br, val = getBrainrot()
        print(string.format("[FR HUB] %s | %s", br, val))
        sendWebhook(br, val)
    end

    local function scanUIElement(obj)
        if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return end
        local clean = stripTags(obj.Text):lower()
        if clean:find(LP.Name:lower(), 1, true) and clean:find("won the duel", 1, true) then
            onWin()
        end
    end

    local playerGui = LP:WaitForChild("PlayerGui")
    local function hookUIElement(v)
        scanUIElement(v)
        if v:IsA("TextLabel") or v:IsA("TextButton") or v:IsA("TextBox") then
            v:GetPropertyChangedSignal("Text"):Connect(function()
                scanUIElement(v)
            end)
        end
    end

    for _, v in ipairs(playerGui:GetDescendants()) do
        hookUIElement(v)
    end
    playerGui.DescendantAdded:Connect(hookUIElement)
end)

print("404 | ANTI DROP (Compact Edition) - Cartel activado por Anti Drop + Fondos + Win Detect")