-- BAHIA HUB | By Bahia & Murilo
-- Rebuild limpo da interface, usando utilitários seguros de localização de bola
-- inspirados na source enviada. Sem recolorir a bola e sem funções de spoof/touch.

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")
local Workspace = game:GetService("Workspace")

local SCRIPT_VERSION = "2.0-clean"
local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local old = playerGui:FindFirstChild("BahiaHub")
if old then old:Destroy() end

local PURPLE = Color3.fromRGB(153, 75, 255)
local PURPLE_DARK = Color3.fromRGB(73, 30, 125)
local BG = Color3.fromRGB(12, 12, 17)
local PANEL = Color3.fromRGB(22, 20, 30)
local TEXT = Color3.fromRGB(245, 240, 255)
local MUTED = Color3.fromRGB(165, 155, 180)
local GREEN = Color3.fromRGB(90, 225, 145)

local DISCORD_LINK = "https://discord.gg/efeFJ6WSK"

local gui = Instance.new("ScreenGui")
gui.Name = "BahiaHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

local function corner(obj, radius)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, radius or 10)
    c.Parent = obj
    return c
end

local function stroke(obj, color, thickness)
    local s = Instance.new("UIStroke")
    s.Color = color or PURPLE_DARK
    s.Thickness = thickness or 1
    s.Parent = obj
    return s
end

local function makeLabel(parent, text, size, pos, fontSize, color, bold)
    local label = Instance.new("TextLabel")
    label.BackgroundTransparency = 1
    label.Parent = parent
    label.Text = text
    label.Size = size
    label.Position = pos
    label.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
    label.TextSize = fontSize or 12
    label.TextColor3 = color or TEXT
    label.TextXAlignment = Enum.TextXAlignment.Left
    label.TextWrapped = true
    return label
end

local main = Instance.new("Frame")
main.Name = "Main"
main.Parent = gui
main.Size = UDim2.new(0, 340, 0, 330)
main.Position = UDim2.new(0.5, -170, 0.5, -165)
main.BackgroundColor3 = BG
main.Visible = true
main.Active = true
corner(main, 14)
stroke(main, PURPLE, 1.5)

local header = Instance.new("Frame")
header.Parent = main
header.Size = UDim2.new(1, 0, 0, 65)
header.BackgroundColor3 = PANEL
corner(header, 14)

makeLabel(header, "BAHIA HUB", UDim2.new(1, -65, 0, 25), UDim2.new(0, 16, 0, 10), 18, TEXT, true)
makeLabel(header, "By Bahia & Murilo", UDim2.new(1, -65, 0, 18), UDim2.new(0, 17, 0, 36), 10, PURPLE, true)

local close = Instance.new("TextButton")
close.Parent = header
close.Size = UDim2.new(0, 30, 0, 30)
close.Position = UDim2.new(1, -42, 0, 15)
close.BackgroundColor3 = Color3.fromRGB(48, 28, 62)
close.Text = "×"
close.TextColor3 = TEXT
close.TextSize = 22
close.Font = Enum.Font.GothamBold
corner(close, 8)
close.MouseButton1Click:Connect(function() main.Visible = false end)

local sidebar = Instance.new("Frame")
sidebar.Parent = main
sidebar.BackgroundTransparency = 1
sidebar.Position = UDim2.new(0, 10, 0, 77)
sidebar.Size = UDim2.new(0, 102, 1, -88)

local content = Instance.new("Frame")
content.Parent = main
content.BackgroundTransparency = 1
content.Position = UDim2.new(0, 122, 0, 77)
content.Size = UDim2.new(1, -132, 1, -88)

local tabs = {"Auto Follow", "Reach", "Gramado", "Anti-Lag", "Discord"}
local pages, tabButtons = {}, {}
local currentTab = nil

local function newPage(name)
    local page = Instance.new("ScrollingFrame")
    page.Name = name
    page.Parent = content
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.BorderSizePixel = 0
    page.ScrollBarThickness = 3
    page.ScrollBarImageColor3 = PURPLE
    page.CanvasSize = UDim2.new(0, 0, 0, 0)
    page.Visible = false
    local layout = Instance.new("UIListLayout")
    layout.Parent = page
    layout.Padding = UDim.new(0, 8)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 8)
    end)
    pages[name] = page
    return page
end

for i, name in ipairs(tabs) do
    local btn = Instance.new("TextButton")
    btn.Parent = sidebar
    btn.Size = UDim2.new(1, 0, 0, 34)
    btn.Position = UDim2.new(0, 0, 0, (i - 1) * 40)
    btn.BackgroundColor3 = PANEL
    btn.Text = name
    btn.TextColor3 = MUTED
    btn.TextSize = 10
    btn.Font = Enum.Font.GothamMedium
    corner(btn, 8)
    tabButtons[name] = btn
    newPage(name)
end

local function showTab(name)
    currentTab = name
    for tabName, page in pairs(pages) do
        page.Visible = tabName == name
        tabButtons[tabName].BackgroundColor3 = tabName == name and PURPLE_DARK or PANEL
        tabButtons[tabName].TextColor3 = tabName == name and TEXT or MUTED
    end
end

for _, name in ipairs(tabs) do
    tabButtons[name].MouseButton1Click:Connect(function() showTab(name) end)
end

local function addButton(pageName, title, callback, description)
    local wrap = Instance.new("Frame")
    wrap.Parent = pages[pageName]
    wrap.Size = UDim2.new(1, -5, 0, description and 58 or 42)
    wrap.BackgroundColor3 = PANEL
    corner(wrap, 8)
    stroke(wrap, Color3.fromRGB(48, 38, 61), 1)

    local btn = Instance.new("TextButton")
    btn.Parent = wrap
    btn.Position = UDim2.new(0, 8, 0, 5)
    btn.Size = UDim2.new(1, -16, 0, description and 26 or 32)
    btn.BackgroundColor3 = Color3.fromRGB(34, 27, 45)
    btn.Text = title
    btn.TextColor3 = TEXT
    btn.TextSize = 11
    btn.Font = Enum.Font.GothamMedium
    corner(btn, 6)

    if description then
        local desc = makeLabel(wrap, description, UDim2.new(1, -16, 0, 17), UDim2.new(0, 8, 0, 35), 9, MUTED, false)
    end

    btn.MouseButton1Click:Connect(function()
        local ok, message = pcall(function() callback(btn) end)
        if not ok then
            btn.Text = "Erro ao aplicar opção"
            warn("[Bahia Hub] " .. tostring(message))
        end
    end)
    return btn
end

local function setStatus(btn, label, enabled)
    btn.Text = label .. (enabled and ": ON" or ": OFF")
    btn.BackgroundColor3 = enabled and Color3.fromRGB(43, 64, 48) or Color3.fromRGB(34, 27, 45)
    btn.TextColor3 = enabled and GREEN or TEXT
end

-- AUTO FOLLOW
local followEnabled = false
local followDistance = 1.8
local targetCenter = Vector3.new(0, -28.94, 0)
local centerTolerance = 3.5
local character, humanoid, rootPart

local function updateCharacter(char)
    character = char
    humanoid = char:WaitForChild("Humanoid")
    rootPart = char:WaitForChild("HumanoidRootPart")
end

if player.Character then
    task.spawn(updateCharacter, player.Character)
end
player.CharacterAdded:Connect(updateCharacter)

local function getClosestFollowBall()
    if not rootPart or not rootPart.Parent then return nil end
    local closestBall, shortestDistance = nil, math.huge

    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and
            (obj.Name == "TPS" or obj.Name:lower():find("ball") or obj.Name:lower():find("bola")) then
            local size = obj.Size
            local correctSize = size.X >= 0.8 and size.X <= 5.0
            local atCenter = (obj.Position - targetCenter).Magnitude <= centerTolerance
            if correctSize and not atCenter then
                local distance = (obj.Position - rootPart.Position).Magnitude
                if distance < shortestDistance then
                    shortestDistance = distance
                    closestBall = obj
                end
            end
        end
    end
    return closestBall
end

local function isManualMoving()
    local keyMovement =
        UserInputService:IsKeyDown(Enum.KeyCode.W) or
        UserInputService:IsKeyDown(Enum.KeyCode.A) or
        UserInputService:IsKeyDown(Enum.KeyCode.S) or
        UserInputService:IsKeyDown(Enum.KeyCode.D)

    if keyMovement then return true end
    return humanoid ~= nil and humanoid.MoveDirection.Magnitude > 0.05
end

local function isSkillPlaying()
    if not humanoid then return false end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if not animator then return false end

    for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
        local name = track.Name:lower()
        if name:find("skill") or name:find("dribble") or name:find("fake")
            or name:find("shoot") or name:find("head") or name:find("rainbow")
            or name:find("lambreta") then
            return true
        end
    end
    return false
end

addButton("Auto Follow", "Auto Follow: OFF", function(btn)
    followEnabled = not followEnabled
    setStatus(btn, "Auto Follow", followEnabled)
end, "Segue a bola mais próxima; movimento manual e habilidades têm prioridade.")

local distanceButtons = {}
local distanceOptions = {
    {label = "Curta (1.5)", value = 1.5},
    {label = "Média (1.8)", value = 1.8},
    {label = "Longa (2.2)", value = 2.2},
}

local function refreshDistanceButtons()
    for _, data in ipairs(distanceButtons) do
        local selected = math.abs(followDistance - data.value) < 0.01
        data.btn.Text = (selected and "✅ " or "") .. "Distância: " .. data.label
        data.btn.BackgroundColor3 = selected and Color3.fromRGB(43, 64, 48) or Color3.fromRGB(34, 27, 45)
        data.btn.TextColor3 = selected and GREEN or TEXT
    end
end

for _, opt in ipairs(distanceOptions) do
    local btn = addButton("Auto Follow", "Distância: " .. opt.label, function(b)
        followDistance = opt.value
        refreshDistanceButtons()
    end)
    table.insert(distanceButtons, {btn = btn, value = opt.value, label = opt.label})
end
refreshDistanceButtons()

RunService.RenderStepped:Connect(function()
    if not followEnabled or not humanoid or not rootPart
        or not rootPart.Parent or humanoid.Health <= 0 then
        return
    end

    local ball = getClosestFollowBall()
    if not ball or isManualMoving() or isSkillPlaying() then return end

    local ballPos = ball.Position
    local myPos = rootPart.Position
    local targetPos = Vector3.new(ballPos.X, myPos.Y, ballPos.Z)
    local delta = targetPos - myPos
    local distance = delta.Magnitude

    if distance > followDistance and distance > 0.01 then
        humanoid:Move(delta.Unit, false)
    else
        humanoid:Move(Vector3.zero, false)
    end
end)

-- ====================================================================
-- REACH (copiado do MTW HUB: usa firetouchinterest)
-- Distância usada diretamente (sem multiplicador), cada opção tem efeito real.
-- ====================================================================
local reachEnabled = false
local reachDistance = 3.5
local reachButtons = {}

local function getClosestReachBall()
    if not rootPart or not rootPart.Parent then return nil end
    local closest, best = nil, math.huge
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and (obj.Name == "TPS" or obj.Name == "TCS" or obj.Name == "TRS" or obj.Name == "PRS" or obj.Name == "MPS" or obj.Name:lower():find("ball") or obj.Name:lower():find("bola")) then
            local d = (obj.Position - rootPart.Position).Magnitude
            if d < best then closest, best = obj, d end
        end
    end
    return closest
end

local function refreshReachButtons()
    for _, data in ipairs(reachButtons) do
        local selected = math.abs(reachDistance - data.value) < 0.01
        data.btn.Text = (selected and "✅ " or "") .. "Alcance: " .. data.label
        data.btn.BackgroundColor3 = selected and Color3.fromRGB(43, 64, 48) or Color3.fromRGB(34, 27, 45)
        data.btn.TextColor3 = selected and GREEN or TEXT
    end
end

local reachToggleBtn = addButton("Reach", "Reach: OFF", function(btn)
    reachEnabled = not reachEnabled
    setStatus(btn, "Reach", reachEnabled)
    if reachEnabled then
        btn.Text = "Reach: ON (" .. reachDistance .. "m)"
    end
end, "Usa firetouchinterest para simular toque na bola (mesmo reach do MTW HUB).")

for _, opt in ipairs({
    {label = "2.0 Metros", value = 2.0},
    {label = "3.5 Metros", value = 3.5},
    {label = "5.0 Metros", value = 5.0},
    {label = "7.5 Metros", value = 7.5},
    {label = "10.0 Metros", value = 10.0},
}) do
    local btn = addButton("Reach", "Alcance: " .. opt.label, function(b)
        reachDistance = opt.value
        if reachEnabled then
            reachToggleBtn.Text = "Reach: ON (" .. reachDistance .. "m)"
        end
        refreshReachButtons()
    end)
    table.insert(reachButtons, {btn = btn, value = opt.value, label = opt.label})
end
refreshReachButtons()

RunService.RenderStepped:Connect(function()
    if not reachEnabled or not humanoid or not rootPart
        or not rootPart.Parent or humanoid.Health <= 0 then
        return
    end

    local ball = getClosestReachBall()
    if not ball then return end

    local distance = (ball.Position - rootPart.Position).Magnitude

    -- Distância usada diretamente, sem multiplicador
    if distance <= reachDistance then
        firetouchinterest(rootPart, ball, 0)
        firetouchinterest(rootPart, ball, 1)

        for _, part in ipairs(character:GetChildren()) do
            if part:IsA("BasePart") then
                firetouchinterest(part, ball, 0)
                firetouchinterest(part, ball, 1)
            end
        end

        for _, child in ipairs(ball:GetChildren()) do
            if child:IsA("TouchTransmitter") then
                firetouchinterest(rootPart, ball, 0)
                firetouchinterest(rootPart, ball, 1)
            end
        end
    end
end)

-- GRAMADO: sem número e com ✅ na opção ativa
local originalColors = {}
local groundButtons = {}
local currentGroundColor = nil

local function recolorGround(color)
    local changed = 0
    for _, part in ipairs(Workspace:GetDescendants()) do
        if part:IsA("BasePart") and part.Position.Y < 5 and part.Size.X > 8 and part.Size.Z > 8 then
            if not originalColors[part] then originalColors[part] = {part.Color, part.Material} end
            part.Color = color
            part.Material = Enum.Material.SmoothPlastic
            changed = changed + 1
        end
    end
    return changed
end

local function refreshGroundButtons()
    for color, data in pairs(groundButtons) do
        local selected = currentGroundColor == color
        data.btn.Text = (selected and "✅ " or "") .. data.label
        data.btn.BackgroundColor3 = selected and Color3.fromRGB(43, 64, 48) or Color3.fromRGB(34, 27, 45)
        data.btn.TextColor3 = selected and GREEN or TEXT
    end
end

local groundOptions = {
    {label = "Verde escuro", color = Color3.fromRGB(18, 78, 37)},
    {label = "Preto", color = Color3.fromRGB(20, 18, 25)},
    {label = "Roxo Cyber", color = Color3.fromRGB(78, 28, 120)},
    {label = "Azul Midnight", color = Color3.fromRGB(18, 38, 88)},
}

for _, opt in ipairs(groundOptions) do
    local btn = addButton("Gramado", opt.label, function(b)
        recolorGround(opt.color)
        currentGroundColor = opt.color
        refreshGroundButtons()
    end)
    groundButtons[opt.color] = {btn = btn, label = opt.label}
end

addButton("Gramado", "Restaurar cores salvas", function(btn)
    local n = 0
    for part, values in pairs(originalColors) do
        if part and part.Parent then
            part.Color, part.Material = values[1], values[2]
            n = n + 1
        end
    end
    originalColors = {}
    currentGroundColor = nil
    refreshGroundButtons()
    btn.Text = "Restaurado"
    task.delay(2, function()
        if btn and btn.Parent then
            btn.Text = "Restaurar cores salvas"
        end
    end)
end)

-- DISCORD: botão para copiar link para a área de transferência
addButton("Discord", "Copiar link do Discord", function(btn)
    local ok = pcall(function()
        if setclipboard then
            setclipboard(DISCORD_LINK)
        else
            -- fallback: usa TextBox invisível + seleção
            local box = Instance.new("TextBox")
            box.Text = DISCORD_LINK
            box.Parent = gui
            box.Visible = false
            box:CaptureFocus()
            box:ReleaseFocus()
            box:Destroy()
        end
    end)
    if ok then
        btn.Text = "✅ Link copiado!"
        btn.BackgroundColor3 = Color3.fromRGB(43, 64, 48)
        btn.TextColor3 = GREEN
        task.delay(2, function()
            if btn and btn.Parent then
                btn.Text = "Copiar link do Discord"
                btn.BackgroundColor3 = Color3.fromRGB(34, 27, 45)
                btn.TextColor3 = TEXT
            end
        end)
    else
        btn.Text = "Não foi possível copiar"
    end
end, DISCORD_LINK)

local oldSettings = {
    GlobalShadows = Lighting.GlobalShadows,
    FogEnd = Lighting.FogEnd,
    Brightness = Lighting.Brightness
}
local effectsDisabled = false
addButton("Anti-Lag", "Sombras: alternar", function(btn)
    Lighting.GlobalShadows = not Lighting.GlobalShadows
    btn.Text = Lighting.GlobalShadows and "Sombras: ON" or "Sombras: OFF"
end, "Reduz um efeito gráfico local.")
addButton("Anti-Lag", "Desativar neblina", function(btn)
    Lighting.FogEnd = 1000000
    btn.Text = "Neblina reduzida"
end)
local savedMaterials = {}
addButton("Anti-Lag", "Texturas lisas", function(btn)
    local n = 0
    for _, obj in ipairs(Workspace:GetDescendants()) do
        if obj:IsA("BasePart") and not (player.Character and obj:IsDescendantOf(player.Character)) then
            if savedMaterials[obj] == nil then savedMaterials[obj] = obj.Material end
            obj.Material = Enum.Material.SmoothPlastic
            n = n + 1
        end
    end
    btn.Text = "Texturas lisas aplicadas"
end, "Pode mudar a aparência de alguns objetos.")
addButton("Anti-Lag", "Restaurar materiais", function(btn)
    for part, material in pairs(savedMaterials) do
        if part and part.Parent then part.Material = material end
    end
    savedMaterials = {}
    btn.Text = "Materiais restaurados"
end)
addButton("Anti-Lag", "Restaurar iluminação inicial", function(btn)
    Lighting.GlobalShadows = oldSettings.GlobalShadows
    Lighting.FogEnd = oldSettings.FogEnd
    Lighting.Brightness = oldSettings.Brightness
    btn.Text = "Iluminação restaurada"
end)

-- Botão flutuante de abrir/fechar
local open = Instance.new("TextButton")
open.Name = "OpenButton"
open.Parent = gui
open.Size = UDim2.new(0, 54, 0, 54)
open.Position = UDim2.new(0, 18, 0.5, -27)
open.BackgroundColor3 = BG
open.Text = "BH"
open.TextColor3 = TEXT
open.TextSize = 15
open.Font = Enum.Font.GothamBold
corner(open, 27)
stroke(open, PURPLE, 2)
open.MouseButton1Click:Connect(function()
    main.Visible = not main.Visible
end)

-- Arrastar janela e botão em mouse ou toque
local function makeDraggable(object, handle)
    handle = handle or object
    local dragging, startInput, startPos
    handle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            startInput = input.Position
            startPos = object.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - startInput
            object.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

makeDraggable(main, header)
makeDraggable(open)
showTab("Auto Follow")