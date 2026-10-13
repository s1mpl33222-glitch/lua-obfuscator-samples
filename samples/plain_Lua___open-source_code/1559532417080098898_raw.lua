local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local Workspace = game:GetService("Workspace")
local LP = Players.LocalPlayer

-- // Estilo Clean (colores)
local UI_COLORS = {
    Background = Color3.fromRGB(0, 0, 0),
    BackgroundDark = Color3.fromRGB(5, 5, 5),
    BackgroundMedium = Color3.fromRGB(15, 15, 15),
    BackgroundInput = Color3.fromRGB(200, 200, 200),
    BackgroundButton = Color3.fromRGB(20, 20, 20),
    BackgroundButtonLight = Color3.fromRGB(30, 30, 30),
    TextPrimary = Color3.fromRGB(255, 255, 255),
    TextSecondary = Color3.fromRGB(200, 200, 200),
    TextAccent = Color3.fromRGB(0, 255, 100),
    StrokeDefault = Color3.fromRGB(80, 80, 80),
    StrokeDark = Color3.fromRGB(70, 70, 70),
    StrokeInput = Color3.fromRGB(120, 120, 120),
    Accent = Color3.fromRGB(0, 200, 80),
    EnabledColor = Color3.fromRGB(0, 255, 100),
    InactiveColor = Color3.fromRGB(255, 80, 100),
    ToggleOn = Color3.fromRGB(200, 200, 200),
    ToggleOff = Color3.fromRGB(40, 40, 40),
    ActiveBorder = Color3.fromRGB(180, 180, 180),
    SilverGray = Color3.fromRGB(180, 180, 180),
    Black = Color3.fromRGB(0, 0, 0),
    ShadowGray = Color3.fromRGB(100, 100, 100),
}

-- // Configuración del Bypass
local Config = {
    Enabled = false,
    PowerValue = 97000,
    Mode = "PC",
    ToggleKey = Enum.KeyCode.V,
    BackgroundVisible = true,
    BackgroundStyle = 1,
    WindowSizeIndex = 5,
    IsVisible = true,
    UILocked = false,
    Position = {X_Scale = 0.5, X_Offset = -125, Y_Scale = 0.5, Y_Offset = -100}
}

-- // Variables del Bypass
local DEPTH = 296
local SPAM_DELAY = 0.12
local running = false
local bomb = nil
local spamThread = nil
local startedAt = 0

-- // 10 tamaños de ventana
local WINDOW_SIZES = {
    { Size = UDim2.new(0, 220, 0, 180) },
    { Size = UDim2.new(0, 230, 0, 205) },
    { Size = UDim2.new(0, 250, 0, 210) },
    { Size = UDim2.new(0, 260, 0, 235) },
    { Size = UDim2.new(0, 280, 0, 240) },
    { Size = UDim2.new(0, 290, 0, 265) },
    { Size = UDim2.new(0, 310, 0, 270) },
    { Size = UDim2.new(0, 320, 0, 295) },
    { Size = UDim2.new(0, 260, 0, 235) },
    { Size = UDim2.new(0, 230, 0, 205) },
}

-- // Imágenes de fondo (solo la 3)
local BG_IMAGES = {
    "rbxassetid://86916180687040",
}

-- // Guardar/Cargar
local ConfigFile = "SpeedBypass_Config.json"
local function SaveConfig()
    if writefile then
        local data = {
            Position = {X_Scale = Config.Position.X_Scale, X_Offset = Config.Position.X_Offset, Y_Scale = Config.Position.Y_Scale, Y_Offset = Config.Position.Y_Offset},
            PowerValue = Config.PowerValue,
            Mode = Config.Mode,
            ToggleKey = Config.ToggleKey.Name,
            BackgroundVisible = Config.BackgroundVisible,
            BackgroundStyle = Config.BackgroundStyle,
            WindowSizeIndex = Config.WindowSizeIndex,
            UILocked = Config.UILocked,
        }
        pcall(function() writefile(ConfigFile, HttpService:JSONEncode(data)) end)
    end
end
local function LoadConfig()
    if isfile and isfile(ConfigFile) then
        local success, data = pcall(function() return HttpService:JSONDecode(readfile(ConfigFile)) end)
        if success and data then
            if data.Position then Config.Position = data.Position end
            if data.PowerValue then Config.PowerValue = data.PowerValue end
            if data.Mode then Config.Mode = data.Mode end
            if data.ToggleKey then Config.ToggleKey = Enum.KeyCode[data.ToggleKey] or Enum.KeyCode.V end
            if data.BackgroundVisible ~= nil then Config.BackgroundVisible = data.BackgroundVisible end
            if data.BackgroundStyle then Config.BackgroundStyle = data.BackgroundStyle end
            if data.WindowSizeIndex then Config.WindowSizeIndex = data.WindowSizeIndex end
            if data.UILocked ~= nil then Config.UILocked = data.UILocked end
        end
    end
end
LoadConfig()

-- // Funciones del Bypass
local function buildBomb(power)
    local maintable = {}
    local spammedtable = {}
    table.insert(spammedtable, {})
    local z = spammedtable[1]
    for i = 1, DEPTH do
        local tableins = {}
        table.insert(z, tableins)
        z = tableins
    end
    local maxRep = math.floor(power / (DEPTH + 2))
    for i = 1, maxRep do
        table.insert(maintable, spammedtable)
    end
    return maintable
end

local function stopBypass()
    running = false
    if spamThread then
        task.cancel(spamThread)
        spamThread = nil
    end
    bomb = nil
end

local function startBypass(power)
    stopBypass()
    running = true
    bomb = buildBomb(power)
    spamThread = task.spawn(function()
        while running do
            if bomb then
                pcall(function()
                    game.RobloxReplicatedStorage.SetPlayerBlockList:FireServer(bomb)
                end)
            end
            task.wait(SPAM_DELAY)
        end
    end)
end

-- // Eliminar GUI antigua
for _, name in pairs({"AntiDieUI", "SpeedBypassUI"}) do
    local old = game:GetService("CoreGui"):FindFirstChild(name)
    if old then old:Destroy() end
end

-- // Crear GUI
local gui = Instance.new("ScreenGui")
gui.Name = "SpeedBypassUI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 10
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = game:GetService("CoreGui")

local main = Instance.new("Frame", gui)
main.Name = "Main"
main.Size = WINDOW_SIZES[Config.WindowSizeIndex].Size
main.Position = UDim2.new(Config.Position.X_Scale or 0.5, Config.Position.X_Offset or -125, Config.Position.Y_Scale or 0.5, Config.Position.Y_Offset or -100)
main.BackgroundColor3 = UI_COLORS.Background
main.BackgroundTransparency = 0
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.ZIndex = 1
local mainCorner = Instance.new("UICorner", main)
mainCorner.CornerRadius = UDim.new(0, 16)
local mainStroke = Instance.new("UIStroke", main)
mainStroke.Color = UI_COLORS.StrokeDefault
mainStroke.Thickness = 1.5

-- Fondo con imagen (solo la 3)
local bgImage = Instance.new("ImageLabel", main)
bgImage.Size = UDim2.new(1, 0, 1, 0)
bgImage.BackgroundTransparency = 1
bgImage.Image = BG_IMAGES[1]
bgImage.ScaleType = Enum.ScaleType.Stretch
bgImage.ZIndex = 0
local bgCorner = Instance.new("UICorner", bgImage)
bgCorner.CornerRadius = UDim.new(0, 16)

-- Arrastre (controlado por UILocked)
local dragging, dragInput, dragStart, mainStart = false, nil, nil, nil
main.InputBegan:Connect(function(inp)
    if Config.UILocked then return end
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
    if Config.UILocked then return end
    if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then dragInput = inp end
end)
UIS.InputChanged:Connect(function(inp)
    if Config.UILocked then return end
    if inp == dragInput and dragging then
        local dx = inp.Position.X - dragStart.X
        local dy = inp.Position.Y - dragStart.Y
        main.Position = UDim2.new(mainStart.X.Scale, mainStart.X.Offset+dx, mainStart.Y.Scale, mainStart.Y.Offset+dy)
    end
end)

-- CABECERA
local titleBar = Instance.new("Frame", main)
titleBar.Size = UDim2.new(1, 0, 0, 35)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = UI_COLORS.BackgroundDark
titleBar.BackgroundTransparency = 0.5
titleBar.ZIndex = 2
local titleBarCorner = Instance.new("UICorner", titleBar)
titleBarCorner.CornerRadius = UDim.new(0, 4)

local titleDot = Instance.new("Frame", titleBar)
titleDot.Size = UDim2.new(0, 10, 0, 10)
titleDot.Position = UDim2.new(0, 12, 0, 12)
titleDot.BackgroundColor3 = UI_COLORS.TextAccent
titleDot.BorderSizePixel = 0
titleDot.ZIndex = 5
Instance.new("UICorner", titleDot).CornerRadius = UDim.new(1, 0)

local titleLbl = Instance.new("TextLabel", titleBar)
titleLbl.Size = UDim2.new(1, -130, 1, 0)
titleLbl.Position = UDim2.new(0, 30, 0, 0)
titleLbl.BackgroundTransparency = 1
titleLbl.Text = "y/out Speed Bypass"
titleLbl.TextColor3 = UI_COLORS.TextPrimary
titleLbl.Font = Enum.Font.GothamBold
titleLbl.TextSize = 14
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 5

local subLbl = Instance.new("TextLabel", titleBar)
subLbl.Size = UDim2.new(1, -130, 1, 0)
subLbl.Position = UDim2.new(0, 30, 0, 18)
subLbl.BackgroundTransparency = 1
subLbl.Text = "discord.gg/yout"
subLbl.TextColor3 = UI_COLORS.TextSecondary
subLbl.Font = Enum.Font.Gotham
subLbl.TextSize = 10
subLbl.TextXAlignment = Enum.TextXAlignment.Left
subLbl.ZIndex = 5

-- Función auxiliar para crear botones de cabecera (excepto el candado)
local function createTitleButton(text, xPos, onClick)
    local btn = Instance.new("TextButton", titleBar)
    btn.Size = UDim2.new(0, 24, 0, 24)
    btn.Position = UDim2.new(1, xPos, 0, 6)
    btn.BackgroundColor3 = UI_COLORS.BackgroundButtonLight
    btn.BackgroundTransparency = 0.78
    btn.Text = text
    btn.TextColor3 = UI_COLORS.TextPrimary
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 16
    btn.ZIndex = 5
    btn.Active = true
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    local stroke = Instance.new("UIStroke", btn)
    stroke.Color = UI_COLORS.StrokeDark
    stroke.Thickness = 1
    btn.MouseButton1Click:Connect(onClick)
    return btn
end

-- Botón de bloqueo (creado manualmente para control directo)
local lockBtn = Instance.new("TextButton", titleBar)
lockBtn.Size = UDim2.new(0, 24, 0, 24)
lockBtn.Position = UDim2.new(1, -110, 0, 6)
lockBtn.BackgroundColor3 = UI_COLORS.BackgroundButtonLight
lockBtn.BackgroundTransparency = 0.78
lockBtn.Text = Config.UILocked and "🔒" or "🔓"
lockBtn.TextColor3 = UI_COLORS.TextPrimary
lockBtn.Font = Enum.Font.GothamBold
lockBtn.TextSize = 16
lockBtn.ZIndex = 5
lockBtn.Active = true
Instance.new("UICorner", lockBtn).CornerRadius = UDim.new(0, 6)
local strokeLock = Instance.new("UIStroke", lockBtn)
strokeLock.Color = UI_COLORS.StrokeDark
strokeLock.Thickness = 1

lockBtn.MouseButton1Click:Connect(function()
    Config.UILocked = not Config.UILocked
    lockBtn.Text = Config.UILocked and "🔒" or "🔓"
    SaveConfig()
end)

-- Botones minimizar, reducir tamaño, aumentar tamaño
local minBtn = createTitleButton("_", -32, function()
    Config.IsVisible = not Config.IsVisible
    main.Size = Config.IsVisible and WINDOW_SIZES[Config.WindowSizeIndex].Size or UDim2.new(0, WINDOW_SIZES[Config.WindowSizeIndex].Size.X.Offset, 0, 35)
end)

local resizeDownBtn = createTitleButton("-", -58, function()
    if Config.WindowSizeIndex > 1 then Config.WindowSizeIndex = Config.WindowSizeIndex - 1
    else Config.WindowSizeIndex = #WINDOW_SIZES end
    main.Size = WINDOW_SIZES[Config.WindowSizeIndex].Size
    if not Config.IsVisible then main.Size = UDim2.new(0, main.Size.X.Offset, 0, 35) end
    SaveConfig()
end)

local resizeUpBtn = createTitleButton("+", -84, function()
    if Config.WindowSizeIndex < #WINDOW_SIZES then Config.WindowSizeIndex = Config.WindowSizeIndex + 1
    else Config.WindowSizeIndex = 1 end
    main.Size = WINDOW_SIZES[Config.WindowSizeIndex].Size
    if not Config.IsVisible then main.Size = UDim2.new(0, main.Size.X.Offset, 0, 35) end
    SaveConfig()
end)

-- CONTENIDO
local contentFrame = Instance.new("Frame", main)
contentFrame.Name = "Content"
contentFrame.Position = UDim2.new(0, 12, 0, 42)
contentFrame.Size = UDim2.new(1, -24, 1, -49)
contentFrame.BackgroundTransparency = 1
contentFrame.ZIndex = 3

local contentLayout = Instance.new("UIListLayout", contentFrame)
contentLayout.Padding = UDim.new(0, 6)
contentLayout.SortOrder = Enum.SortOrder.LayoutOrder

local function createPanel(height)
    local p = Instance.new("Frame", contentFrame)
    p.Size = UDim2.new(1, 0, 0, height)
    p.BackgroundColor3 = UI_COLORS.BackgroundMedium
    p.BackgroundTransparency = 0.7
    p.ZIndex = 4
    Instance.new("UICorner", p).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", p)
    stroke.Color = UI_COLORS.StrokeDark
    stroke.Thickness = 1
    return p
end

-- ===== PANELES =====
-- 1. Status (centrado)
local statusPanel = createPanel(40)
local statusBtn = Instance.new("TextButton", statusPanel)
statusBtn.Size = UDim2.new(0.6, 0, 0.6, 0)
statusBtn.Position = UDim2.new(0.2, 0, 0.2, 0)
statusBtn.BackgroundColor3 = UI_COLORS.BackgroundButton
statusBtn.BackgroundTransparency = 0.5
statusBtn.Text = "INACTIVE"
statusBtn.TextColor3 = UI_COLORS.TextSecondary
statusBtn.Font = Enum.Font.GothamBold
statusBtn.TextSize = 12
statusBtn.ZIndex = 5
Instance.new("UICorner", statusBtn).CornerRadius = UDim.new(0, 6)
local statusStroke = Instance.new("UIStroke", statusBtn)
statusStroke.Color = UI_COLORS.StrokeDark
statusStroke.Thickness = 1

-- 2. Background Toggle
local bgTogglePanel = createPanel(36)
local bgToggleLabel = Instance.new("TextLabel", bgTogglePanel)
bgToggleLabel.Size = UDim2.new(0.45, 0, 1, 0)
bgToggleLabel.Position = UDim2.new(0, 8, 0, 0)
bgToggleLabel.BackgroundTransparency = 1
bgToggleLabel.Text = "Background:"
bgToggleLabel.TextColor3 = UI_COLORS.TextSecondary
bgToggleLabel.Font = Enum.Font.Gotham
bgToggleLabel.TextSize = 11
bgToggleLabel.TextXAlignment = Enum.TextXAlignment.Left
bgToggleLabel.ZIndex = 5

local shadowFrame = Instance.new("Frame", bgTogglePanel)
shadowFrame.Size = UDim2.new(0.35, 0, 0.7, 0)
shadowFrame.Position = UDim2.new(0.55, 0, 0.15, 0)
shadowFrame.BackgroundColor3 = UI_COLORS.ShadowGray
shadowFrame.BackgroundTransparency = 0.3
shadowFrame.ZIndex = 4
Instance.new("UICorner", shadowFrame).CornerRadius = UDim.new(0, 5)

local bgToggleBtn = Instance.new("TextButton", bgTogglePanel)
bgToggleBtn.Size = UDim2.new(0.35, 0, 0.7, 0)
bgToggleBtn.Position = UDim2.new(0.55, -2, 0.15, 2)
bgToggleBtn.BackgroundColor3 = UI_COLORS.SilverGray
bgToggleBtn.BackgroundTransparency = 0.2
bgToggleBtn.Text = Config.BackgroundVisible and "ON" or "OFF"
bgToggleBtn.TextColor3 = UI_COLORS.Black
bgToggleBtn.Font = Enum.Font.GothamBold
bgToggleBtn.TextSize = 11
bgToggleBtn.ZIndex = 5
Instance.new("UICorner", bgToggleBtn).CornerRadius = UDim.new(0, 5)
local bgToggleStroke = Instance.new("UIStroke", bgToggleBtn)
bgToggleStroke.Color = UI_COLORS.SilverGray
bgToggleStroke.Thickness = 1.5

-- 3. Mode (PC y Mobile)
local modePanel = createPanel(52)
local modeLabel = Instance.new("TextLabel", modePanel)
modeLabel.Size = UDim2.new(1, 0, 0.25, 0)
modeLabel.Position = UDim2.new(0, 8, 0, 2)
modeLabel.BackgroundTransparency = 1
modeLabel.Text = "Mode:"
modeLabel.TextColor3 = UI_COLORS.TextSecondary
modeLabel.Font = Enum.Font.Gotham
modeLabel.TextSize = 11
modeLabel.TextXAlignment = Enum.TextXAlignment.Left
modeLabel.ZIndex = 5

local pcBtn = Instance.new("TextButton", modePanel)
pcBtn.Size = UDim2.new(0.4, 0, 0.3, 0)
pcBtn.Position = UDim2.new(0.3, 0, 0.3, 0)
pcBtn.BackgroundColor3 = UI_COLORS.BackgroundButton
pcBtn.BackgroundTransparency = 0.5
pcBtn.Text = "PC"
pcBtn.TextColor3 = UI_COLORS.TextSecondary
pcBtn.Font = Enum.Font.GothamBold
pcBtn.TextSize = 11
pcBtn.ZIndex = 5
Instance.new("UICorner", pcBtn).CornerRadius = UDim.new(0, 5)
local pcStroke = Instance.new("UIStroke", pcBtn)
pcStroke.Color = UI_COLORS.StrokeDark
pcStroke.Thickness = 1

local mobileBtn = Instance.new("TextButton", modePanel)
mobileBtn.Size = UDim2.new(0.4, 0, 0.3, 0)
mobileBtn.Position = UDim2.new(0.3, 0, 0.65, 0)
mobileBtn.BackgroundColor3 = UI_COLORS.BackgroundButton
mobileBtn.BackgroundTransparency = 0.5
mobileBtn.Text = "Mobile"
mobileBtn.TextColor3 = UI_COLORS.TextSecondary
mobileBtn.Font = Enum.Font.GothamBold
mobileBtn.TextSize = 11
mobileBtn.ZIndex = 5
Instance.new("UICorner", mobileBtn).CornerRadius = UDim.new(0, 5)
local mobileStroke = Instance.new("UIStroke", mobileBtn)
mobileStroke.Color = UI_COLORS.StrokeDark
mobileStroke.Thickness = 1

-- 4. Keybind
local keyPanel = createPanel(32)
local keyLabel = Instance.new("TextLabel", keyPanel)
keyLabel.Size = UDim2.new(0.4, 0, 1, 0)
keyLabel.Position = UDim2.new(0, 8, 0, 0)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "Keybind:"
keyLabel.TextColor3 = UI_COLORS.TextSecondary
keyLabel.Font = Enum.Font.Gotham
keyLabel.TextSize = 11
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.ZIndex = 5

local keyBtn = Instance.new("TextButton", keyPanel)
keyBtn.Size = UDim2.new(0.3, 0, 0.7, 0)
keyBtn.Position = UDim2.new(0.42, 0, 0.15, 0)
keyBtn.BackgroundColor3 = UI_COLORS.BackgroundButton
keyBtn.BackgroundTransparency = 0.5
keyBtn.Text = Config.ToggleKey.Name
keyBtn.TextColor3 = UI_COLORS.TextPrimary
keyBtn.Font = Enum.Font.GothamBold
keyBtn.TextSize = 11
keyBtn.ZIndex = 5
Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 5)
local keyStroke = Instance.new("UIStroke", keyBtn)
keyStroke.Color = UI_COLORS.StrokeDark
keyStroke.Thickness = 1

-- 5. Power
local powerPanel = createPanel(36)
local powerLabel = Instance.new("TextLabel", powerPanel)
powerLabel.Size = UDim2.new(0.35, 0, 1, 0)
powerLabel.Position = UDim2.new(0, 8, 0, 0)
powerLabel.BackgroundTransparency = 1
powerLabel.Text = "Power:"
powerLabel.TextColor3 = UI_COLORS.TextSecondary
powerLabel.Font = Enum.Font.Gotham
powerLabel.TextSize = 11
powerLabel.TextXAlignment = Enum.TextXAlignment.Left
powerLabel.ZIndex = 5

local powerInput = Instance.new("TextBox", powerPanel)
powerInput.Size = UDim2.new(0.5, 0, 0.7, 0)
powerInput.Position = UDim2.new(0.42, 0, 0.15, 0)
powerInput.BackgroundColor3 = UI_COLORS.SilverGray
powerInput.BackgroundTransparency = 0.3
powerInput.Text = tostring(Config.PowerValue)
powerInput.TextColor3 = UI_COLORS.Black
powerInput.Font = Enum.Font.GothamBold
powerInput.TextSize = 12
powerInput.ZIndex = 5
Instance.new("UICorner", powerInput).CornerRadius = UDim.new(0, 4)
local powerStroke = Instance.new("UIStroke", powerInput)
powerStroke.Color = UI_COLORS.StrokeInput
powerStroke.Thickness = 1

-- // Actualizar estado visual general
local function updateUIState()
    local enabled = Config.Enabled
    statusBtn.Text = enabled and "ACTIVE" or "INACTIVE"
    statusBtn.TextColor3 = enabled and UI_COLORS.EnabledColor or UI_COLORS.TextSecondary
    mainStroke.Color = enabled and UI_COLORS.ActiveBorder or UI_COLORS.StrokeDefault

    -- Modo PC/Mobile
    if Config.Mode == "PC" then
        pcBtn.BackgroundColor3 = UI_COLORS.SilverGray
        pcBtn.BackgroundTransparency = 0.3
        pcBtn.TextColor3 = UI_COLORS.Black
        pcStroke.Color = UI_COLORS.SilverGray
        mobileBtn.BackgroundColor3 = UI_COLORS.BackgroundButton
        mobileBtn.BackgroundTransparency = 0.5
        mobileBtn.TextColor3 = UI_COLORS.TextSecondary
        mobileStroke.Color = UI_COLORS.StrokeDark
    else
        mobileBtn.BackgroundColor3 = UI_COLORS.SilverGray
        mobileBtn.BackgroundTransparency = 0.3
        mobileBtn.TextColor3 = UI_COLORS.Black
        mobileStroke.Color = UI_COLORS.SilverGray
        pcBtn.BackgroundColor3 = UI_COLORS.BackgroundButton
        pcBtn.BackgroundTransparency = 0.5
        pcBtn.TextColor3 = UI_COLORS.TextSecondary
        pcStroke.Color = UI_COLORS.StrokeDark
    end

    -- Background toggle
    if Config.BackgroundVisible then
        bgToggleBtn.BackgroundColor3 = UI_COLORS.SilverGray
        bgToggleBtn.BackgroundTransparency = 0.15
        bgToggleStroke.Color = UI_COLORS.SilverGray
        bgToggleBtn.TextColor3 = UI_COLORS.Black
    else
        bgToggleBtn.BackgroundColor3 = UI_COLORS.BackgroundButtonLight
        bgToggleBtn.BackgroundTransparency = 0.4
        bgToggleStroke.Color = UI_COLORS.StrokeDark
        bgToggleBtn.TextColor3 = UI_COLORS.TextSecondary
    end
    bgToggleBtn.Text = Config.BackgroundVisible and "ON" or "OFF"
    bgImage.Visible = Config.BackgroundVisible
end

-- // Eventos (todos funcionan siempre, sin bloqueo)
statusBtn.MouseButton1Click:Connect(function()
    Config.Enabled = not Config.Enabled
    updateUIState()
    if Config.Enabled then
        startedAt = os.clock()
        startBypass(Config.PowerValue)
    else
        stopBypass()
    end
    SaveConfig()
end)

powerInput.FocusLost:Connect(function()
    local val = tonumber(powerInput.Text)
    if val then
        Config.PowerValue = math.clamp(math.floor(val + 0.5), 1, 999999)
        powerInput.Text = tostring(Config.PowerValue)
        if Config.Enabled then startBypass(Config.PowerValue) end
        SaveConfig()
    else
        powerInput.Text = tostring(Config.PowerValue)
    end
end)

mobileBtn.MouseButton1Click:Connect(function()
    Config.Mode = "Mobile"
    Config.PowerValue = 65000
    powerInput.Text = "65000"
    if Config.Enabled then startBypass(Config.PowerValue) end
    updateUIState()
    SaveConfig()
end)

pcBtn.MouseButton1Click:Connect(function()
    Config.Mode = "PC"
    Config.PowerValue = 97000
    powerInput.Text = "97000"
    if Config.Enabled then startBypass(Config.PowerValue) end
    updateUIState()
    SaveConfig()
end)

keyBtn.MouseButton1Click:Connect(function()
    keyBtn.Text = "..."
    keyBtn.TextColor3 = Color3.fromRGB(255, 200, 100)
    local conn
    conn = UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.Keyboard then
            Config.ToggleKey = input.KeyCode
            keyBtn.Text = input.KeyCode.Name
            keyBtn.TextColor3 = UI_COLORS.TextPrimary
            conn:Disconnect()
            SaveConfig()
        end
    end)
end)

bgToggleBtn.MouseButton1Click:Connect(function()
    Config.BackgroundVisible = not Config.BackgroundVisible
    updateUIState()
    SaveConfig()
end)

-- // Keybind global
UIS.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if input.KeyCode == Config.ToggleKey then
            Config.Enabled = not Config.Enabled
            updateUIState()
            if Config.Enabled then
                startedAt = os.clock()
                startBypass(Config.PowerValue)
            else
                stopBypass()
            end
            SaveConfig()
        elseif input.KeyCode == Enum.KeyCode.RightControl then
            Config.IsVisible = not Config.IsVisible
            main.Size = Config.IsVisible and WINDOW_SIZES[Config.WindowSizeIndex].Size or UDim2.new(0, WINDOW_SIZES[Config.WindowSizeIndex].Size.X.Offset, 0, 35)
        end
    end
end)

-- Inicializar
updateUIState()
if Config.Enabled then
    startBypass(Config.PowerValue)
end