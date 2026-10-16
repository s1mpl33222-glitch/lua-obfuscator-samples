-- ============================================================
-- VOID HUB - GALAXY LITE (corrigido - galáxia respeita formato)
-- ============================================================
print("[VoidHub] Iniciando...")

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local PPS = game:GetService("ProximityPromptService")

local plr = Players.LocalPlayer
local pg = plr:WaitForChild("PlayerGui", 30)

local old = pg:FindFirstChild("VoidHub")
if old then old:Destroy() end

print("[VoidHub] Criando GUI...")

-- CORES
local COR_TEXTO = Color3.fromRGB(255, 230, 255)
local COR_ROSA = Color3.fromRGB(255, 80, 200)
local COR_CIANO = Color3.fromRGB(80, 220, 255)
local COR_ROXA = Color3.fromRGB(180, 90, 255)
local COR_FUNDO_BTN = Color3.fromRGB(25, 5, 50)
local COR_FUNDO_OFF = Color3.fromRGB(60, 30, 110)
local COR_FUNDO_ON = Color3.fromRGB(255, 80, 200)

-- CONFIG
local COOLDOWN = 0.3
local ZONA_SEGURA = Vector3.new(541.5, 70.7, -368.4)

-- GUI
local gui = Instance.new("ScreenGui")
gui.Name = "VoidHub"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.DisplayOrder = 999999
gui.Parent = pg

-- ============================================================
-- FUNÇÃO GALÁXIA CORRIGIDA
-- ============================================================
local function aplicarGalaxia(frame, raioCanto)
    frame.BackgroundColor3 = Color3.fromRGB(5, 2, 15)
    frame.ClipsDescendants = true
    
    -- Container da nebulosa que vai ser cortado no formato do frame
    local container = Instance.new("Frame")
    container.Name = "ContainerGalaxia"
    container.Size = UDim2.new(1, 0, 1, 0)
    container.Position = UDim2.new(0, 0, 0, 0)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.ClipsDescendants = true
    container.ZIndex = frame.ZIndex
    container.Parent = frame
    
    -- Aplica o MESMO UICorner do frame pra cortar certinho
    local cornerContainer = Instance.new("UICorner")
    cornerContainer.CornerRadius = raioCanto or UDim.new(0, 8)
    cornerContainer.Parent = container
    
    -- Nebulosa dentro do container
    local nebulosa = Instance.new("Frame")
    nebulosa.Size = UDim2.new(1, 0, 1, 0)
    nebulosa.BackgroundColor3 = Color3.fromRGB(60, 20, 120)
    nebulosa.BackgroundTransparency = 0.4
    nebulosa.BorderSizePixel = 0
    nebulosa.ZIndex = frame.ZIndex
    nebulosa.Parent = container
    
    local nebulaGrad = Instance.new("UIGradient")
    nebulaGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(120, 20, 200)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 50, 150)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 100, 255)),
    })
    nebulaGrad.Rotation = 45
    nebulaGrad.Parent = nebulosa
    
    -- Estrelas
    for i = 1, 15 do
        local estrela = Instance.new("Frame")
        local tam = math.random(1, 3)
        estrela.Size = UDim2.new(0, tam, 0, tam)
        estrela.Position = UDim2.new(math.random(), 0, math.random(), 0)
        estrela.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        estrela.BackgroundTransparency = math.random() * 0.5
        estrela.BorderSizePixel = 0
        estrela.ZIndex = frame.ZIndex + 1
        estrela.Parent = container
        Instance.new("UICorner", estrela).CornerRadius = UDim.new(1, 0)
    end
    
    -- Planetas
    local planetas = {
        {cor = Color3.fromRGB(200, 100, 50), tam = 8, x = 0.1, y = 0.7},
        {cor = Color3.fromRGB(255, 180, 80), tam = 10, x = 0.85, y = 0.2},
        {cor = Color3.fromRGB(100, 150, 255), tam = 6, x = 0.75, y = 0.75},
    }
    
    for _, p in ipairs(planetas) do
        local planeta = Instance.new("Frame")
        planeta.Size = UDim2.new(0, p.tam, 0, p.tam)
        planeta.Position = UDim2.new(p.x, 0, p.y, 0)
        planeta.BackgroundColor3 = p.cor
        planeta.BorderSizePixel = 0
        planeta.ZIndex = frame.ZIndex + 1
        planeta.Parent = container
        Instance.new("UICorner", planeta).CornerRadius = UDim.new(1, 0)
    end
end

-- TOGGLE
local toggle = Instance.new("Frame")
toggle.Size = UDim2.new(0, 160, 0, 36)
toggle.Position = UDim2.new(0.5, -80, 0.5, -120)
toggle.Active = true
toggle.Parent = gui
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0, 18)

-- Aplica galáxia com o MESMO raio do toggle (18)
aplicarGalaxia(toggle, UDim.new(0, 18))

local tStroke = Instance.new("UIStroke")
tStroke.Thickness = 2
tStroke.Color = COR_ROSA
tStroke.Parent = toggle

local icon = Instance.new("TextLabel")
icon.Size = UDim2.new(0, 24, 0, 24)
icon.Position = UDim2.new(0, 8, 0.5, -12)
icon.BackgroundTransparency = 1
icon.Text = "⚡"
icon.Font = Enum.Font.GothamBold
icon.TextSize = 16
icon.TextColor3 = COR_TEXTO
icon.ZIndex = 10
icon.Parent = toggle

local btnAbrir = Instance.new("TextButton")
btnAbrir.Size = UDim2.new(1, -80, 1, 0)
btnAbrir.Position = UDim2.new(0, 32, 0, 0)
btnAbrir.BackgroundTransparency = 1
btnAbrir.Text = "Void Hub"
btnAbrir.Font = Enum.Font.GothamBold
btnAbrir.TextSize = 14
btnAbrir.TextColor3 = COR_TEXTO
btnAbrir.TextXAlignment = Enum.TextXAlignment.Left
btnAbrir.ZIndex = 10
btnAbrir.Parent = toggle

local dragBtn = Instance.new("TextButton")
dragBtn.Size = UDim2.new(0, 28, 0, 28)
dragBtn.Position = UDim2.new(1, -34, 0.5, -14)
dragBtn.BackgroundColor3 = Color3.fromRGB(80, 30, 150)
dragBtn.TextColor3 = COR_TEXTO
dragBtn.Text = "≡"
dragBtn.Font = Enum.Font.GothamBold
dragBtn.TextSize = 18
dragBtn.ZIndex = 10
dragBtn.Parent = toggle
Instance.new("UICorner", dragBtn).CornerRadius = UDim.new(1, 0)

-- DRAG
local dragAtual, dragStartPos, dragStartMouse, dragAtivo = nil, nil, nil, false

local function ativarDrag(frame, input)
    dragAtual = frame
    dragStartMouse = input.Position
    dragStartPos = frame.Position
    dragAtivo = true
end

UIS.InputChanged:Connect(function(input)
    if not dragAtivo or not dragAtual or not dragStartPos or not dragStartMouse then return end
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseMovement then
        local delta = input.Position - dragStartMouse
        dragAtual.Position = UDim2.new(
            dragStartPos.X.Scale, dragStartPos.X.Offset + delta.X,
            dragStartPos.Y.Scale, dragStartPos.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragAtual = nil
        dragStartPos = nil
        dragStartMouse = nil
        dragAtivo = false
    end
end)

dragBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        ativarDrag(toggle, input)
    end
end)

-- MENU
local menu = Instance.new("Frame")
menu.Size = UDim2.new(0, 240, 0, 220)
menu.Position = UDim2.new(0.5, -120, 0.5, -60)
menu.Visible = false
menu.Active = true
menu.Parent = gui
Instance.new("UICorner", menu).CornerRadius = UDim.new(0, 14)

-- Aplica galáxia com o raio do menu (14)
aplicarGalaxia(menu, UDim.new(0, 14))

local mStroke = Instance.new("UIStroke")
mStroke.Thickness = 2
mStroke.Color = COR_CIANO
mStroke.Parent = menu

local mTitleBar = Instance.new("Frame")
mTitleBar.Size = UDim2.new(1, -20, 0, 32)
mTitleBar.Position = UDim2.new(0, 10, 0, 8)
mTitleBar.BackgroundColor3 = Color3.fromRGB(50, 10, 100)
mTitleBar.BackgroundTransparency = 0.4
mTitleBar.BorderSizePixel = 0
mTitleBar.Active = false
mTitleBar.ZIndex = 5
mTitleBar.Parent = menu
Instance.new("UICorner", mTitleBar).CornerRadius = UDim.new(0, 8)

local mTitle = Instance.new("TextLabel")
mTitle.Size = UDim2.new(1, -10, 1, 0)
mTitle.Position = UDim2.new(0, 8, 0, 0)
mTitle.BackgroundTransparency = 1
mTitle.Text = "✦ Opções ✦"
mTitle.Font = Enum.Font.GothamBold
mTitle.TextSize = 14
mTitle.TextColor3 = COR_TEXTO
mTitle.TextXAlignment = Enum.TextXAlignment.Left
mTitle.ZIndex = 6
mTitle.Parent = mTitleBar

mTitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        ativarDrag(menu, input)
    end
end)

local scroll = Instance.new("ScrollingFrame")
scroll.Size = UDim2.new(1, -10, 1, -50)
scroll.Position = UDim2.new(0, 5, 0, 44)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = COR_ROSA
scroll.CanvasSize = UDim2.new(0, 0, 0, 180)
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
scroll.ZIndex = 5
scroll.Parent = menu

local layout = Instance.new("UIListLayout")
layout.Padding = UDim.new(0, 6)
layout.Parent = scroll

local padding = Instance.new("UIPadding")
padding.PaddingTop = UDim.new(0, 4)
padding.PaddingLeft = UDim.new(0, 5)
padding.PaddingRight = UDim.new(0, 5)
padding.Parent = scroll

scroll.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.Touch
    or input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragAtivo = false
        dragAtual = nil
    end
end)

-- CRIADORES
local function criarToggle(texto)
    local linhaBtn = Instance.new("TextButton")
    linhaBtn.Size = UDim2.new(1, -10, 0, 36)
    linhaBtn.BackgroundColor3 = COR_FUNDO_BTN
    linhaBtn.BackgroundTransparency = 0.2
    linhaBtn.BorderSizePixel = 0
    linhaBtn.Text = ""
    linhaBtn.Active = true
    linhaBtn.ZIndex = 6
    linhaBtn.Parent = scroll
    Instance.new("UICorner", linhaBtn).CornerRadius = UDim.new(0, 8)
    
    local strokeLinha = Instance.new("UIStroke")
    strokeLinha.Thickness = 1
    strokeLinha.Color = COR_ROXA
    strokeLinha.Transparency = 0.5
    strokeLinha.Parent = linhaBtn

    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(1, -50, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = texto
    lbl.Font = Enum.Font.GothamMedium
    lbl.TextSize = 13
    lbl.TextColor3 = COR_TEXTO
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    lbl.ZIndex = 7
    lbl.Parent = linhaBtn

    local tgInd = Instance.new("Frame")
    tgInd.Size = UDim2.new(0, 32, 0, 16)
    tgInd.Position = UDim2.new(1, -42, 0.5, -8)
    tgInd.BackgroundColor3 = COR_FUNDO_OFF
    tgInd.BorderSizePixel = 0
    tgInd.ZIndex = 7
    tgInd.Parent = linhaBtn
    Instance.new("UICorner", tgInd).CornerRadius = UDim.new(1, 0)

    local knob = Instance.new("Frame")
    knob.Size = UDim2.new(0, 12, 0, 12)
    knob.Position = UDim2.new(0, 2, 0.5, -6)
    knob.BackgroundColor3 = COR_TEXTO
    knob.BorderSizePixel = 0
    knob.ZIndex = 8
    knob.Parent = tgInd
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

    return linhaBtn, tgInd, knob
end

local linhaGoUp, tgUpBG, knobUp = criarToggle("Go up")
local linhaCD, tgCDBG, knobCD = criarToggle("Anti-CD")
local linhaAntiHit, tgAntiHitBG, knobAntiHit = criarToggle("🛡️ Anti-Hit")

print("[VoidHub] Menu OK")

-- ESTADO
local hum, root, char
local goUpAtivo = false
local antiAtivo = false
local antiHitAtivo = false
local processando = false
local plataforma = nil
local origPrompts = {}

local function upVisual()
    if goUpAtivo then
        tgUpBG.BackgroundColor3 = COR_FUNDO_ON
        knobUp.Position = UDim2.new(1, -14, 0.5, -6)
    else
        tgUpBG.BackgroundColor3 = COR_FUNDO_OFF
        knobUp.Position = UDim2.new(0, 2, 0.5, -6)
    end
end

local function cdVisual()
    if antiAtivo then
        tgCDBG.BackgroundColor3 = COR_FUNDO_ON
        knobCD.Position = UDim2.new(1, -14, 0.5, -6)
    else
        tgCDBG.BackgroundColor3 = COR_FUNDO_OFF
        knobCD.Position = UDim2.new(0, 2, 0.5, -6)
    end
end

local function antiHitVisual()
    if antiHitAtivo then
        tgAntiHitBG.BackgroundColor3 = COR_FUNDO_ON
        knobAntiHit.Position = UDim2.new(1, -14, 0.5, -6)
    else
        tgAntiHitBG.BackgroundColor3 = COR_FUNDO_OFF
        knobAntiHit.Position = UDim2.new(0, 2, 0.5, -6)
    end
end

local function teleportTo(pos)
    local c = plr.Character
    if not c then return false end
    local r = c:FindFirstChild("HumanoidRootPart")
    if not r then return false end
    if r.Anchored then r.Anchored = false end
    local rot = r.CFrame - r.CFrame.Position
    local target = CFrame.new(pos) * rot
    pcall(function() c:PivotTo(target) end)
    pcall(function() r.CFrame = target end)
    pcall(function() r.Position = pos end)
    pcall(function()
        r.AssemblyLinearVelocity = Vector3.zero
        r.AssemblyAngularVelocity = Vector3.zero
    end)
    return true
end

local function holdPosition(pos, seconds)
    local c = plr.Character
    if not c then return end
    local r = c:FindFirstChild("HumanoidRootPart")
    if not r then return end
    local rot = r.CFrame - r.CFrame.Position
    local target = CFrame.new(pos) * rot
    local endTime = tick() + seconds
    local conn
    conn = RunService.Heartbeat:Connect(function()
        if tick() >= endTime then
            if conn then conn:Disconnect() end
            return
        end
        if r and r.Parent then
            r.CFrame = target
            r.AssemblyLinearVelocity = Vector3.zero
            r.AssemblyAngularVelocity = Vector3.zero
        end
    end)
    task.wait(seconds)
    if conn then conn:Disconnect() end
end

local function doReturn()
    if processando then return end
    processando = true
    local c = plr.Character
    if not c then processando = false return end
    local r = c:FindFirstChild("HumanoidRootPart")
    if not r then processando = false return end
    local posOriginal = r.Position
    teleportTo(ZONA_SEGURA)
    holdPosition(ZONA_SEGURA, COOLDOWN)
    teleportTo(posOriginal)
    task.wait(0.1)
    processando = false
end

linhaGoUp.MouseButton1Click:Connect(function()
    goUpAtivo = not goUpAtivo
    upVisual()
    if not goUpAtivo then
        if plataforma then plataforma:Destroy(); plataforma = nil end
        return
    end
    if not hum or not root or hum.Health <= 0 then return end
    local pos = root.Position
    plataforma = Instance.new("Part")
    plataforma.Anchored = true
    plataforma.Size = Vector3.new(8, 1, 8)
    plataforma.Transparency = 0.4
    plataforma.Color = Color3.fromRGB(80, 160, 255)
    plataforma.Material = Enum.Material.Neon
    plataforma.CanCollide = true
    plataforma.CanTouch = false
    plataforma.CanQuery = false
    plataforma.Position = Vector3.new(pos.X, pos.Y + 28, pos.Z)
    plataforma.Parent = Workspace
    task.spawn(function()
        while goUpAtivo and root and plataforma do
            local y = root.Position.Y
            local alvoY = plataforma.Position.Y + 3
            if y >= alvoY - 1 then
                root.CFrame = CFrame.new(plataforma.Position.X, alvoY, plataforma.Position.Z)
                root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
                root.Anchored = true
                break
            end
            root.CFrame = CFrame.new(root.Position.X, math.min(y + 4, alvoY - 1), root.Position.Z)
            RunService.Heartbeat:Wait()
        end
        while goUpAtivo and root and plataforma do
            root.CFrame = CFrame.new(plataforma.Position.X, plataforma.Position.Y + 3, plataforma.Position.Z)
            root.AssemblyLinearVelocity = Vector3.new(0, 0, 0)
            RunService.Heartbeat:Wait()
        end
        if root then root.Anchored = false end
    end)
end)

linhaCD.MouseButton1Click:Connect(function()
    antiAtivo = not antiAtivo
    cdVisual()
    if antiAtivo then
        for _, obj in ipairs(Workspace:GetDescendants()) do
            if obj:IsA("ProximityPrompt") then
                if not origPrompts[obj] then origPrompts[obj] = obj.HoldDuration end
                obj.HoldDuration = 0
            end
        end
    else
        for obj, h in pairs(origPrompts) do
            pcall(function() if obj and obj.Parent then obj.HoldDuration = h end end)
        end
        origPrompts = {}
    end
end)

linhaAntiHit.MouseButton1Click:Connect(function()
    antiHitAtivo = not antiHitAtivo
    antiHitVisual()
    if antiHitAtivo then
        linhaAntiHit.Text = "🛡️ Anti-Hit (ON)"
        print("[VoidHub] Anti-Hit ON")
    else
        linhaAntiHit.Text = "🛡️ Anti-Hit"
        print("[VoidHub] Anti-Hit OFF")
    end
end)

PPS.PromptTriggered:Connect(function(prompt, who)
    if not antiHitAtivo or who ~= plr or processando then return end
    task.spawn(doReturn)
end)

local menuAberto = false
btnAbrir.MouseButton1Click:Connect(function()
    menuAberto = not menuAberto
    menu.Visible = menuAberto
end)

local function createTitle(c)
    local head = c:FindFirstChild("Head")
    if not head then return end
    local o = head:FindFirstChild("Void_Title")
    if o then o:Destroy() end
    local bill = Instance.new("BillboardGui")
    bill.Name = "Void_Title"
    bill.AlwaysOnTop = true
    bill.LightInfluence = 0
    bill.MaxDistance = 500
    bill.StudsOffset = Vector3.new(0, 2.5, 0)
    bill.Size = UDim2.new(0, 150, 0, 22)
    bill.Parent = head
    local lbl = Instance.new("TextLabel")
    lbl.BackgroundTransparency = 1
    lbl.Size = UDim2.new(1, 0, 1, 0)
    lbl.Text = "by: victorsilvaxs💭"
    lbl.TextScaled = true
    lbl.Font = Enum.Font.GothamBold
    lbl.TextColor3 = Color3.fromRGB(0, 0, 0)
    lbl.Parent = bill
    
    local st = Instance.new("UIStroke")
    st.Thickness = 1.5
    st.Color = Color3.fromRGB(255, 255, 255)
    st.Transparency = 0.3
    st.Parent = lbl
end

local function bind(c)
    char = c
    hum = c:WaitForChild("Humanoid", 10)
    root = c:WaitForChild("HumanoidRootPart", 10)
    goUpAtivo = false
    upVisual()
    if plataforma then plataforma:Destroy(); plataforma = nil end
    task.delay(0.3, function()
        if char == c then createTitle(c) end
    end)
end

plr.CharacterAdded:Connect(function(c)
    task.wait(0.5)
    bind(c)
end)

if plr.Character then
    bind(plr.Character)
end

Workspace.DescendantAdded:Connect(function(obj)
    if antiAtivo and obj:IsA("ProximityPrompt") then
        if not origPrompts[obj] then origPrompts[obj] = obj.HoldDuration end
        obj.HoldDuration = 0
    end
end)

print("[VoidHub] ✅ Carregado!")