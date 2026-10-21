-- ============================================================
-- INTRO RIVAL HUB (se ejecuta primero; Rival Hub carga al terminar o al tocar SKIP)
-- ============================================================
do
local TweenService = game:GetService("TweenService")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local HOLD_TO_SKIP = 1
local INTRO_DURATION = 6.35
local SONG_URL = "https://files.catbox.moe/4inuat.mp3"
local SONG_FILE = "M4LWARE_Intro_Song1.mp3"

pcall(function()
    local old = CoreGui:FindFirstChild("M4LWARE_Intro")
    if old then old:Destroy() end
end)

pcall(function()
    local pg = Players.LocalPlayer and Players.LocalPlayer:FindFirstChild("PlayerGui")
    local old = pg and pg:FindFirstChild("M4LWARE_Intro")
    if old then old:Destroy() end
end)

local intro = Instance.new("ScreenGui")
intro.Name = "M4LWARE_Intro"
intro.IgnoreGuiInset = true
intro.ResetOnSpawn = false
intro.DisplayOrder = 999999
intro.ZIndexBehavior = Enum.ZIndexBehavior.Global

if not pcall(function()
    intro.Parent = CoreGui
end) or not intro.Parent then
    intro.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
end

local bg = Instance.new("Frame")
bg.Size = UDim2.fromScale(1,1)
bg.BackgroundColor3 = Color3.fromRGB(0,0,0)
bg.BorderSizePixel = 0
bg.Parent = intro

local bgGrad = Instance.new("UIGradient", bg)
bgGrad.Rotation = 90
bgGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0,0,0)),
    ColorSequenceKeypoint.new(0.48, Color3.fromRGB(2,7,12)),
    ColorSequenceKeypoint.new(0.52, Color3.fromRGB(3,12,24)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0,0,0))
})

local center = Instance.new("Frame")
center.AnchorPoint = Vector2.new(0.5,0.5)
center.Position = UDim2.fromScale(0.5,0.5)
center.Size = UDim2.new(0.88,0,0,240)
center.BackgroundTransparency = 1
center.Parent = intro

local centerLimit = Instance.new("UISizeConstraint", center)
centerLimit.MaxSize = Vector2.new(760,260)
centerLimit.MinSize = Vector2.new(280,200)

local topLine = Instance.new("Frame")
topLine.AnchorPoint = Vector2.new(0.5,0.5)
topLine.Position = UDim2.new(0.5,0,0.18,0)
topLine.Size = UDim2.fromOffset(0,1)
topLine.BackgroundColor3 = Color3.fromRGB(45,120,255)
topLine.BackgroundTransparency = 0.18
topLine.BorderSizePixel = 0
topLine.Parent = center

local topGrad = Instance.new("UIGradient", topLine)
topGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(0,0,0)),
    ColorSequenceKeypoint.new(0.5,Color3.fromRGB(235,242,255)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(0,0,0))
})

local function makeCenterText(name, text, sizeY, font, color, z)
    local t = Instance.new("TextLabel")
    t.Name = name
    t.AnchorPoint = Vector2.new(0.5,0.5)
    t.Position = UDim2.fromScale(0.5,0.49)
    t.Size = UDim2.new(0.92,0,0,sizeY)
    t.BackgroundTransparency = 1
    t.Text = text
    t.Font = font
    t.TextScaled = true
    t.TextColor3 = color
    t.TextTransparency = 1
    t.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    t.TextStrokeTransparency = 1
    t.ZIndex = z or 10
    t.Parent = center
    return t
end

local symbolGlow = makeCenterText("SymbolGlow", "Clean is good?", 88, Enum.Font.GothamBlack, Color3.fromRGB(35,105,255), 9)
local symbolStroke = Instance.new("UIStroke", symbolGlow)
symbolStroke.Color = Color3.fromRGB(20,82,210)
symbolStroke.Thickness = 10
symbolStroke.Transparency = 1

local symbol = makeCenterText("Symbol", "Clean is good?", 82, Enum.Font.GothamBlack, Color3.fromRGB(245,248,255), 11)
local symbolScale = Instance.new("UIScale", symbol)
symbolScale.Scale = 0.72

local noGlow = makeCenterText("NoGlow", "NO!", 102, Enum.Font.GothamBlack, Color3.fromRGB(25,92,235), 12)
local noStroke = Instance.new("UIStroke", noGlow)
noStroke.Color = Color3.fromRGB(20,80,205)
noStroke.Thickness = 9
noStroke.Transparency = 1

local noText = makeCenterText("NoText", "NO!", 96, Enum.Font.GothamBlack, Color3.fromRGB(248,250,255), 13)
noText.Rotation = -2

local noScale = Instance.new("UIScale", noText)
noScale.Scale = 1.22

local sureGlow = makeCenterText("SureGlow", "RIVAL HUB", 90, Enum.Font.GothamBlack, Color3.fromRGB(35,105,255), 14)
local sureStroke = Instance.new("UIStroke", sureGlow)
sureStroke.Color = Color3.fromRGB(20,85,220)
sureStroke.Thickness = 10
sureStroke.Transparency = 1

local sure = makeCenterText("Sure", "RIVAL HUB", 86, Enum.Font.GothamBlack, Color3.fromRGB(255,255,255), 16)
sure.Position = UDim2.new(0.5,0,0.46,24)
sureGlow.Position = UDim2.new(0.5,0,0.46,24)

local sureGrad = Instance.new("UIGradient", sure)
sureGrad.Rotation = 0
sureGrad.Offset = Vector2.new(-0.72,0)
sureGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(20,75,190)),
    ColorSequenceKeypoint.new(0.28, Color3.fromRGB(155,190,255)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(0.72, Color3.fromRGB(150,185,255)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(15,65,175))
})

local sureScale = Instance.new("UIScale", sure)
sureScale.Scale = 0.90

local link = Instance.new("TextLabel")
link.AnchorPoint = Vector2.new(0.5,0.5)
link.Position = UDim2.new(0.5,0,0.71,18)
link.Size = UDim2.new(0.72,0,0,28)
link.BackgroundTransparency = 1
link.Text = ".gg/rivalhub"
link.Font = Enum.Font.GothamMedium
link.TextScaled = true
link.TextColor3 = Color3.fromRGB(175,205,255)
link.TextTransparency = 1
link.TextStrokeColor3 = Color3.fromRGB(0,0,0)
link.TextStrokeTransparency = 1
link.ZIndex = 16
link.Parent = center

local under = Instance.new("Frame")
under.AnchorPoint = Vector2.new(0.5,0.5)
under.Position = UDim2.new(0.5,0,0.62,13)
under.Size = UDim2.fromOffset(0,2)
under.BackgroundColor3 = Color3.fromRGB(45,120,255)
under.BackgroundTransparency = 0.10
under.BorderSizePixel = 0
under.ZIndex = 15
under.Parent = center

local underGrad = Instance.new("UIGradient", under)
underGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(0,7,18)),
    ColorSequenceKeypoint.new(0.5,Color3.fromRGB(235,242,255)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(0,7,18))
})

local glitchLeft = Instance.new("Frame")
glitchLeft.AnchorPoint = Vector2.new(1,0.5)
glitchLeft.Position = UDim2.new(0.5,-5,0.5,0)
glitchLeft.Size = UDim2.fromOffset(0,2)
glitchLeft.BackgroundColor3 = Color3.fromRGB(35,105,255)
glitchLeft.BorderSizePixel = 0
glitchLeft.BackgroundTransparency = 0.08
glitchLeft.ZIndex = 7
glitchLeft.Parent = intro

local glitchRight = glitchLeft:Clone()
glitchRight.AnchorPoint = Vector2.new(0,0.5)
glitchRight.Position = UDim2.new(0.5,5,0.5,0)
glitchRight.Parent = intro

local glitchLayer = Instance.new("Frame")
glitchLayer.Size = UDim2.fromScale(1,1)
glitchLayer.BackgroundTransparency = 1
glitchLayer.BorderSizePixel = 0
glitchLayer.ZIndex = 8
glitchLayer.Parent = intro

local glitchColors = {
    Color3.fromRGB(35,105,255),
    Color3.fromRGB(255,255,255),
    Color3.fromRGB(0,0,0)
}

task.spawn(function()
    while glitchLayer.Parent do
        task.wait(math.random(7,18)/100)
        for _ = 1, math.random(1,4) do
            local slice = Instance.new("Frame")
            slice.BorderSizePixel = 0
            slice.BackgroundColor3 = glitchColors[math.random(1,#glitchColors)]
            slice.BackgroundTransparency = math.random(5,45)/100
            slice.Size = UDim2.new(math.random(12,72)/100,0,0,math.random(1,4))
            slice.Position = UDim2.new(math.random(0,88)/100,0,math.random(18,82)/100,0)
            slice.ZIndex = 8
            slice.Parent = glitchLayer
            task.delay(math.random(3,10)/100,function()
                if slice then slice:Destroy() end
            end)
        end
    end
end)

local skipLabel = Instance.new("TextLabel")
skipLabel.AnchorPoint = Vector2.new(0.5,1)
skipLabel.Position = UDim2.new(0.5,0,0.965,0)
skipLabel.Size = UDim2.fromOffset(270,24)
skipLabel.BackgroundTransparency = 1
skipLabel.Text = ""
skipLabel.Font = Enum.Font.GothamMedium
skipLabel.TextSize = 12
skipLabel.TextColor3 = Color3.fromRGB(180,195,230)
skipLabel.TextTransparency = 0.12
skipLabel.Visible = false
skipLabel.ZIndex = 50
skipLabel.Parent = intro

local overlay = Instance.new("Frame")
overlay.Size = UDim2.fromScale(1,1)
overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
overlay.BackgroundTransparency = 1
overlay.BorderSizePixel = 0
overlay.ZIndex = 100
overlay.Parent = intro

local flash = Instance.new("Frame")
flash.Size = UDim2.fromScale(1,1)
flash.BackgroundColor3 = Color3.fromRGB(45,120,255)
flash.BackgroundTransparency = 1
flash.BorderSizePixel = 0
flash.ZIndex = 40
flash.Parent = intro

local sound = Instance.new("Sound")
sound.Name = "M4LWAREIntroMusic"
sound.Volume = 0.68
sound.Looped = false
sound.Parent = SoundService

task.spawn(function()
    pcall(function()
        local asset = getcustomasset or getsynasset
        if type(asset) ~= "function" or type(writefile) ~= "function" then return end
        local exists = false
        if type(isfile) == "function" then
            local ok, value = pcall(isfile, SONG_FILE)
            exists = ok and value == true
        end
        if not exists then
            local ok, body = pcall(function()
                return game:HttpGet(SONG_URL)
            end)
            if not ok or type(body) ~= "string" or #body == 0 then return end
            if not pcall(writefile, SONG_FILE, body) then return end
        end
        local ok, id = pcall(asset, SONG_FILE)
        if ok and id and sound.Parent then
            sound.SoundId = id
            sound:Play()
        end
    end)
end)

local finished = false
local introDone = false
local heldInput = nil
local holdStarted = nil
local holdGeneration = 0
local connections = {}
local startTime = os.clock()

local function cleanup()
    for _, c in ipairs(connections) do
        pcall(function()
            c:Disconnect()
        end)
    end
    pcall(function()
        sound:Stop()
        sound:Destroy()
    end)
    pcall(function()
        intro:Destroy()
    end)
    introDone = true
end

local function finishIntro(fast)
    if finished then return end
    finished = true
    holdGeneration += 1
    local d = fast and 0.14 or 0.34
    pcall(function()
        TweenService:Create(
            overlay,
            TweenInfo.new(d,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
            {BackgroundTransparency = 0}
        ):Play()
    end)
    pcall(function()
        TweenService:Create(
            sound,
            TweenInfo.new(d,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),
            {Volume = 0}
        ):Play()
    end)
    task.delay(d + 0.04, cleanup)
end

local skipButton = Instance.new("TextButton")
skipButton.Name = "SkipButton"
skipButton.AnchorPoint = Vector2.new(1,0)
skipButton.Position = UDim2.new(1,-16,0,18)
skipButton.Size = UDim2.fromOffset(88,38)
skipButton.BackgroundColor3 = Color3.fromRGB(4,10,18)
skipButton.BackgroundTransparency = 0.15
skipButton.BorderSizePixel = 0
skipButton.AutoButtonColor = false
skipButton.Text = "SKIP"
skipButton.Font = Enum.Font.GothamBold
skipButton.TextSize = 14
skipButton.TextColor3 = Color3.fromRGB(235,242,255)
skipButton.ZIndex = 60
skipButton.Parent = intro
Instance.new("UICorner", skipButton).CornerRadius = UDim.new(0,8)

local skipStroke = Instance.new("UIStroke", skipButton)
skipStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
skipStroke.Color = Color3.fromRGB(45,120,255)
skipStroke.Thickness = 1.5
skipStroke.Transparency = 0.2

table.insert(connections, skipButton.Activated:Connect(function()
    finishIntro(true)
end))

table.insert(connections, UserInputService.InputBegan:Connect(function(input)
    if finished then return end
    local kind = input.UserInputType
    if kind ~= Enum.UserInputType.Touch and kind ~= Enum.UserInputType.MouseButton1 then return end
    heldInput = input
    holdStarted = os.clock()
    holdGeneration += 1
    local gen = holdGeneration
    task.delay(HOLD_TO_SKIP,function()
        if finished or heldInput ~= input or gen ~= holdGeneration then return end
        finishIntro(true)
    end)
end))

table.insert(connections, UserInputService.InputEnded:Connect(function(input)
    if heldInput == input then
        heldInput = nil
        holdStarted = nil
        holdGeneration += 1
        skipLabel.Visible = false
        skipLabel.Text = ""
    end
end))

table.insert(connections, game:GetService("RunService").RenderStepped:Connect(function()
    if finished then return end
    if heldInput and holdStarted then
        local left = math.max(0,HOLD_TO_SKIP-(os.clock()-holdStarted))
        skipLabel.Visible = true
        skipLabel.Text = string.format("HOLD TO SKIP  %.1fs",left)
    else
        skipLabel.Visible = false
    end
end))

task.spawn(function()
    TweenService:Create(topLine,TweenInfo.new(0.42,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=UDim2.new(0.46,0,0,1)}):Play()
    TweenService:Create(glitchLeft,TweenInfo.new(0.38,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=UDim2.new(0.31,0,0,2)}):Play()
    TweenService:Create(glitchRight,TweenInfo.new(0.38,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=UDim2.new(0.31,0,0,2)}):Play()

    task.wait(0.34)
    if finished then return end

    TweenService:Create(symbolGlow,TweenInfo.new(0.18),{TextTransparency=0.45}):Play()
    TweenService:Create(symbolStroke,TweenInfo.new(0.18),{Transparency=0.76}):Play()
    TweenService:Create(symbol,TweenInfo.new(0.32,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{TextTransparency=0,TextStrokeTransparency=0.38}):Play()
    TweenService:Create(symbolScale,TweenInfo.new(0.34,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()

    task.wait(0.28)
    if finished then return end

    symbol.Position = UDim2.new(0.5,-5,0.49,0)
    task.wait(0.045)
    symbol.Position = UDim2.new(0.5,6,0.49,0)
    task.wait(0.045)
    symbol.Position = UDim2.fromScale(0.5,0.49)

    task.wait(0.68)
    if finished then return end

    TweenService:Create(symbolGlow,TweenInfo.new(0.16),{TextTransparency=1}):Play()
    TweenService:Create(symbolStroke,TweenInfo.new(0.16),{Transparency=1}):Play()
    TweenService:Create(symbol,TweenInfo.new(0.16,Enum.EasingStyle.Quad,Enum.EasingDirection.In),{TextTransparency=1,TextStrokeTransparency=1}):Play()

    task.wait(0.12)
    if finished then return end

    noText.Position = UDim2.new(0.5,0,0.49,-8)
    noGlow.Position = noText.Position

    TweenService:Create(noGlow,TweenInfo.new(0.15),{TextTransparency=0.48}):Play()
    TweenService:Create(noStroke,TweenInfo.new(0.15),{Transparency=0.78}):Play()
    TweenService:Create(noText,TweenInfo.new(0.20,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{TextTransparency=0,TextStrokeTransparency=0.38}):Play()
    TweenService:Create(noScale,TweenInfo.new(0.20,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()
    TweenService:Create(flash,TweenInfo.new(0.07),{BackgroundTransparency=0.94}):Play()

    task.wait(0.07)
    TweenService:Create(flash,TweenInfo.new(0.20),{BackgroundTransparency=1}):Play()

    task.wait(0.72)
    if finished then return end

    TweenService:Create(noGlow,TweenInfo.new(0.15),{TextTransparency=1}):Play()
    TweenService:Create(noStroke,TweenInfo.new(0.15),{Transparency=1}):Play()
    TweenService:Create(noText,TweenInfo.new(0.16),{TextTransparency=1,TextStrokeTransparency=1}):Play()

    task.wait(0.18)
    if finished then return end

    sure.Position = UDim2.new(0.5,0,0.46,34)
    sureGlow.Position = sure.Position

    TweenService:Create(sureGlow,TweenInfo.new(0.42,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{TextTransparency=0.54,Position=UDim2.new(0.5,0,0.46,3)}):Play()
    TweenService:Create(sureStroke,TweenInfo.new(0.42),{Transparency=0.80}):Play()
    TweenService:Create(sure,TweenInfo.new(0.46,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{TextTransparency=0,TextStrokeTransparency=0.38,Position=UDim2.new(0.5,0,0.46,0)}):Play()
    TweenService:Create(sureScale,TweenInfo.new(0.46,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{Scale=1}):Play()
    TweenService:Create(under,TweenInfo.new(0.52,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Size=UDim2.new(0.54,0,0,2)}):Play()

    task.wait(0.18)
    if finished then return end

    TweenService:Create(link,TweenInfo.new(0.38,Enum.EasingStyle.Quad,Enum.EasingDirection.Out),{TextTransparency=0.04,TextStrokeTransparency=0.55,Position=UDim2.new(0.5,0,0.71,0)}):Play()
    TweenService:Create(sureGrad,TweenInfo.new(1.1,Enum.EasingStyle.Quart,Enum.EasingDirection.Out),{Offset=Vector2.new(0.72,0)}):Play()

    task.wait(0.26)
    if finished then return end

    sure.Position = UDim2.new(0.5,-3,0.46,0)
    sureGlow.Position = UDim2.new(0.5,4,0.46,0)

    task.wait(0.035)

    sure.Position = UDim2.new(0.5,3,0.46,0)
    sureGlow.Position = UDim2.new(0.5,-4,0.46,0)

    task.wait(0.035)

    sure.Position = UDim2.new(0.5,0,0.46,0)
    sureGlow.Position = UDim2.new(0.5,0,0.46,0)

    local remaining = math.max(0.65,INTRO_DURATION-(os.clock()-startTime)-0.38)
    task.wait(remaining)

    if not finished then
        finishIntro(false)
    end
end)

task.spawn(function()
    while not finished and os.clock()-startTime < INTRO_DURATION+0.8 do
        task.wait(0.1)
    end
    if not finished then
        finishIntro(false)
    end
end)

local waitStart = os.clock()
while not introDone and os.clock() - waitStart < INTRO_DURATION + 3 do
    task.wait(0.05)
end
end
-- ============================================================
-- FIN INTRO
-- ============================================================

if _G.RivalHubRunning then
    warn("[Rival Hub] Instancia previa detectada. Se recomienda rejoin si hay comportamiento errático.")
end
_G.RivalHubRunning = false
_G.__RivalHubMainOriginalPos = nil

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")

local LP = Players.LocalPlayer
if not LP then
    local _lpConn
    _lpConn = Players.PlayerAdded:Connect(function(p) LP = p end)
    local _t0 = tick()
    while not LP and tick() - _t0 < 15 do task.wait(0.1) end
    if _lpConn then _lpConn:Disconnect() end
end
if not LP then
    warn("[Rival Hub] LocalPlayer no disponible en 15s. Abortando.")
    return
end

local pgui = LP:WaitForChild("PlayerGui", 20)
if not pgui then
    warn("[Rival Hub] PlayerGui no cargó en 20s. Abortando.")
    return
end

local camera = Workspace.CurrentCamera

_G.RivalHubRunning = true
_G.RivalHubSession = (_G.RivalHubSession or 0) + 1
local _mySession = _G.RivalHubSession

local RIVALHUB_LANGUAGE = "en"

local RIVALHUB_TRANSLATIONS = {
    es = { ["RESET ALL SETTINGS"]="RESTABLECER TODO", ["SETTINGS RESET"]="AJUSTES RESTABLECIDOS", ["CONFIRM?"]="¿CONFIRMAR?", ["ERROR"]="ERROR", ["RESET"]="RESTABLECER", ["Keybinds"]="TECLAS", ["Carry Mode"]="MODO CARGAR", ["Lagger Mode"]="MODO LAG", ["Auto Left"]="AUTO IZQUIERDA", ["Auto Right"]="AUTO DERECHA", ["Auto Bat"]="AUTO BATE", ["TP Down"]="TP ABAJO", ["Drop Brainrot"]="SOLTAR BRAINROT", ["Hide GUI"]="OCULTAR MENÚ", ["Normal Speed"]="VELOCIDAD NORMAL", ["Carry Speed"]="VELOCIDAD CARGAR", ["Current Mode"]="MODO ACTUAL", ["ACTIVATE"]="ACTIVAR" },
    pt = { ["RESET ALL SETTINGS"]="REDEFINIR TUDO", ["SETTINGS RESET"]="CONFIGURAÇÕES REDEFINIDAS", ["CONFIRM?"]="CONFIRMAR?", ["ERROR"]="ERRO", ["RESET"]="REDEFINIR", ["Keybinds"]="TECLAS", ["Carry Mode"]="MODO CARREGAR", ["Auto Left"]="AUTO ESQUERDA", ["Auto Right"]="AUTO DIREITA", ["Hide GUI"]="OCULTAR MENU", ["Normal Speed"]="VELOCIDADE NORMAL", ["Carry Speed"]="VELOCIDADE CARREGAR", ["ACTIVATE"]="ATIVAR" },
    fr = { ["RESET ALL SETTINGS"]="RÉINITIALISER", ["SETTINGS RESET"]="PARAMÈTRES RÉINITIALISÉS", ["CONFIRM?"]="CONFIRMER ?", ["ERROR"]="ERREUR", ["RESET"]="RÉINITIALISER", ["Keybinds"]="RACCOURCIS", ["Carry Mode"]="MODE PORTER", ["Auto Left"]="AUTO GAUCHE", ["Auto Right"]="AUTO DROITE", ["Hide GUI"]="MASQUER LE MENU", ["Normal Speed"]="VITESSE NORMALE", ["Carry Speed"]="VITESSE PORTER", ["ACTIVATE"]="ACTIVER" },
    de = { ["RESET ALL SETTINGS"]="ALLES ZURÜCKSETZEN", ["SETTINGS RESET"]="EINSTELLUNGEN ZURÜCKGESETZT", ["CONFIRM?"]="BESTÄTIGEN?", ["ERROR"]="FEHLER", ["RESET"]="ZURÜCKSETZEN", ["Keybinds"]="TASTEN", ["Carry Mode"]="TRAGEMODUS", ["Auto Left"]="AUTO LINKS", ["Auto Right"]="AUTO RECHTS", ["Hide GUI"]="MENÜ AUSBLENDEN", ["Normal Speed"]="NORMALE GESCHWINDIGKEIT", ["Carry Speed"]="TRAGEGESCHWINDIGKEIT", ["ACTIVATE"]="AKTIVIEREN" },
}

local function localizeRivalHubInterface(root)
    local dictionary = RIVALHUB_TRANSLATIONS[RIVALHUB_LANGUAGE]
    if not dictionary or not root then return end
    for _, object in ipairs(root:GetDescendants()) do
        if object:IsA("TextLabel") or object:IsA("TextButton") then
            local source = object:GetAttribute("RivalHubSourceText") or object.Text
            object:SetAttribute("RivalHubSourceText", source)
            local translated = dictionary[source]
            if translated then object.Text = translated end
        end
    end
end

local function rivalHubTranslate(source)
    local dictionary = RIVALHUB_TRANSLATIONS[RIVALHUB_LANGUAGE]
    return (dictionary and dictionary[source]) or source
end

local _tick          = tick
local _clamp         = math.clamp
local _floor         = math.floor
local _abs           = math.abs
local _huge          = math.huge
local _sqrt          = math.sqrt
local _V3new         = Vector3.new
local _V3zero        = Vector3.zero
local _CFnew         = CFrame.new
local _CFlookAt      = CFrame.lookAt
local _RayParams_new = RaycastParams.new

local _GetPlayersCached
do
    local cache, cacheTime = nil, 0
    _GetPlayersCached = function()
        local now = _tick()
        if cache and now - cacheTime < 0.03 then return cache end
        cache = Players:GetPlayers()
        cacheTime = now
        return cache
    end
end

local function waitForCharReady(char, timeout)
    timeout = timeout or 5
    local deadline = _tick() + timeout
    while (not char) or (not char.Parent)
          or (not char:FindFirstChild("HumanoidRootPart"))
          or (not char:FindFirstChildOfClass("Humanoid")) do
        if _tick() > deadline then return false end
        task.wait(0.05)
    end
    return true
end

NS = 60
CS = 29
LAGGER_SPEED = 15
LAGGER_CARRY_SPEED = 24.5
MEDUSA_COOLDOWN = 25
BAT_AIMBOT_SPEED = 58
BYPASS_AIMBOT_SPEED = 60
local State = {
    bypassBatEnabled = false,
    bypassBatSpeed = BYPASS_AIMBOT_SPEED,
}
CONFIG_FILE = "RivalHub_" .. tostring(LP.UserId) .. ".json"
BAT_V2_HIT_DIST = 4.5
_isDraggingButton = false

backgroundIndex = 1
backgroundImages = {
    "129214453510848",
    "118435264006850",
    "77812202151238",
    "139964210583184",
}

backgroundImageTransparency = 0
backgroundMode = "Background 1"
backgroundSelectorLabel = nil
miniBackgroundImage = nil
floatingButtonScale = 1
_floatingUIScales = {}

TPBatState = TPBatState or {
    enabled = false,
    connection = nil,
    hitCooldown = false,
    antiDieConnections = {},
}
TPBatState.enabled = false

function applyBackgroundMode(mode)
    if mode == "None" then
        backgroundMode = "None"
    else
        local n = tonumber(string.match(tostring(mode), "^Background%s+(%d+)$"))
        if not n or n < 1 or n > #backgroundImages then
            n = backgroundIndex
        end
        backgroundIndex = _clamp(n, 1, #backgroundImages)
        backgroundMode = "Background " .. backgroundIndex
    end

    if main then
        main.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        main.BackgroundTransparency = backgroundMode == "None" and 0 or 1
        local bgImage = main:FindFirstChild("BackgroundImage")
        if bgImage then
            bgImage.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
            bgImage.ImageTransparency = backgroundMode == "None" and 1 or backgroundImageTransparency
        end
    end
    if miniBackgroundImage then
        miniBackgroundImage.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
        miniBackgroundImage.ImageTransparency = backgroundMode == "None" and 1 or math.clamp(backgroundImageTransparency + 0.25, 0, 1)
    end
    if backgroundSelectorLabel then backgroundSelectorLabel.Text = backgroundMode end
end

local COLOR_THEMES = {
    ["Gray"] = Color3.fromRGB(170, 170, 170),
}

RIVAL_TITLE_THEMES = {
    ["Blue"]  = { top = Color3.fromRGB(60, 130, 255),  bottom = Color3.fromRGB(210, 220, 235) },
    ["Red"]   = { top = Color3.fromRGB(255, 70, 70),   bottom = Color3.fromRGB(215, 215, 215) },
    ["Green"] = { top = Color3.fromRGB(50, 220, 110),  bottom = Color3.fromRGB(200, 240, 210) },
    ["Black"] = { top = Color3.fromRGB(35, 35, 40),    bottom = Color3.fromRGB(115, 115, 125) },
    ["Gray"]  = { top = Color3.fromRGB(200, 200, 200), bottom = Color3.fromRGB(120, 120, 130) },
}
currentRivalTitleTheme = "Blue"
scriptLogoRef = nil
rivalTitleSelectorLabel = nil

function applyRivalTitleTheme(themeName)
    local t = RIVAL_TITLE_THEMES[themeName]
    if not t then return end
    currentRivalTitleTheme = themeName
    if scriptLogoRef then
        local grad = scriptLogoRef:FindFirstChildOfClass("UIGradient")
        if grad then
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, t.top),
                ColorSequenceKeypoint.new(1, t.bottom),
            })
        end
    end
    if rivalTitleSelectorLabel then
        rivalTitleSelectorLabel.Text = themeName
    end
    if saveAllSettings then pcall(saveAllSettings) end
end

currentColorTheme = "Gray"
selectedColor = COLOR_THEMES["Gray"]

function getThemeColor() return selectedColor end

function rivalHubGradient(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.new(1,1,1), 0.55)),
        ColorSequenceKeypoint.new(0.45, c),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.new(0,0,0), 0.35)),
    })
end

function rivalHubGradientSoft(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.new(1,1,1), 0.75)),
        ColorSequenceKeypoint.new(0.50, c:Lerp(Color3.new(1,1,1), 0.25)),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.new(0,0,0), 0.15)),
    })
end

function rivalHubGradientDark(c)
    return ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, c:Lerp(Color3.fromRGB(0,0,0), 0.35)),
        ColorSequenceKeypoint.new(0.55, c:Lerp(Color3.fromRGB(0,0,0), 0.65)),
        ColorSequenceKeypoint.new(1.00, c:Lerp(Color3.fromRGB(0,0,0), 0.80)),
    })
end

function applyRivalHubGradientToLabel(label, c)
    if not label then return end
    local grad = label:FindFirstChildOfClass("UIGradient")
    if not grad then
        grad = Instance.new("UIGradient", label)
    end
    grad.Rotation = 0
    grad.Color = rivalHubGradient(c)
end

local _lastThemeUpdate = 0
local _lastThemeColor = nil

function applyColorTheme(themeName)
    local color = COLOR_THEMES[themeName]
    if not color then return end
    currentColorTheme = themeName
    selectedColor = color
    updateAllUIThemeColors(color)
    saveAllSettings()
end

_uicStroke = nil
_uicAvatarStroke = nil
_uicHandle = nil
_uicLine = nil

function updateAllUIThemeColors(color)
    local now = _tick()
    if color == _lastThemeColor and now - _lastThemeUpdate < 0.1 then return end
    _lastThemeUpdate = now
    _lastThemeColor = color

    if progressFill then
        progressFill.BackgroundColor3 = color
        local grad = progressFill:FindFirstChildOfClass("UIGradient")
        if grad then
            grad.Color = rivalHubGradient(color)
            grad.Rotation = 0
        end
    end
    if pbFrame then
        local border = pbFrame:FindFirstChild("OuterStroke")
        if border then border.Color = color end
        local fpsNeon = pbFrame:FindFirstChild("FPSNeon", true)
        if fpsNeon then fpsNeon.TextColor3 = color end
        local pingNeon = pbFrame:FindFirstChild("PingNeon", true)
        if pingNeon then pingNeon.TextColor3 = color end
        local divider = pbFrame:FindFirstChild("Divider", true)
        if divider and divider:IsA("Frame") then divider.BackgroundColor3 = color end

        pbFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    end

    if _uicStroke then _uicStroke.Color = color end
    if _uicAvatarStroke then _uicAvatarStroke.Color = color end
    if _uicHandle then _uicHandle.TextColor3 = color end
    if _uicLine then _uicLine.BackgroundColor3 = color end

    local function searchAndUpdateText(parent)
        for _, child in ipairs(parent:GetDescendants()) do
            if child:IsA("TextLabel") then
                if child.Name == "DiscordText" then
                    child.TextColor3 = color
                    local grad = child:FindFirstChildOfClass("UIGradient")
                    if grad then
                        grad.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0.00, color),
                            ColorSequenceKeypoint.new(0.30, Color3.fromRGB(200,200,200)),
                            ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
                            ColorSequenceKeypoint.new(0.70, Color3.fromRGB(200,200,200)),
                            ColorSequenceKeypoint.new(1.00, color),
                        })
                    end
                elseif child.Name == "SpeedLabel" then
                    local blue = Color3.fromRGB(85, 170, 255)
                    child.TextColor3 = blue
                    local grad = child:FindFirstChildOfClass("UIGradient")
                    if grad then
                        grad.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0.00, blue),
                            ColorSequenceKeypoint.new(0.30, blue:Lerp(Color3.new(0.15,0.15,0.15), 0.25)),
                            ColorSequenceKeypoint.new(0.50, blue:Lerp(Color3.new(1,1,1), 0.55)),
                            ColorSequenceKeypoint.new(0.70, blue:Lerp(Color3.new(0.15,0.15,0.15), 0.25)),
                            ColorSequenceKeypoint.new(1.00, blue),
                        })
                    end
                end
            end
            if child:IsA("UIStroke") then
                if child.Color == Color3.fromRGB(180, 180, 190) then child.Color = color end
            end
        end
    end
    if gui then searchAndUpdateText(gui) end
    for _, tab in ipairs(tabButtons or {}) do
        local isActive = tab:FindFirstChild("Underline") and tab.Underline.Visible
        if isActive then
            tab.TextColor3 = Color3.fromRGB(245, 245, 255)
            tab.BackgroundColor3 = color
            tab.BackgroundTransparency = 0.15
            local tg = tab:FindFirstChild("TabBgGrad")
            if tg then tg.Color = rivalHubGradient(color) end
        else
            tab.TextColor3 = Color3.fromRGB(150, 150, 165)
            tab.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
            tab.BackgroundTransparency = 1
        end
        local ul = tab:FindFirstChild("Underline")
        if ul then ul.BackgroundColor3 = color end
        local s = tab:FindFirstChild("TabStroke")
        if s then s.Color = color end
    end
    if _G.__RivalHubRefreshESPTheme then pcall(_G.__RivalHubRefreshESPTheme, color) end
    if main then
        local titleFrame = main:FindFirstChild("Frame")
        if titleFrame then
            for _, child in ipairs(titleFrame:GetDescendants()) do
                if child:IsA("UIStroke") and child.Color == Color3.fromRGB(180, 180, 190) then
                    child.Color = color
                end
            end
        end
    end
    if colorSelectorLabel then
        colorSelectorLabel.Text = currentColorTheme
        colorSelectorLabel.TextColor3 = color
    end

    if _G._rivalHubStealSlide then
        _G._rivalHubStealSlide.BackgroundColor3 = color
        local sg = _G._rivalHubStealSlide:FindFirstChildOfClass("UIGradient")
        if sg then sg.Color = rivalHubGradient(color) end
        local ss = _G._rivalHubStealSlide:FindFirstChildOfClass("UIStroke")
        if ss then ss.Color = color end
    end

    if miniBtn then
        local stroke = miniBtn:FindFirstChildOfClass("UIStroke")
        if stroke then stroke.Color = color end
    end

    if MobilePanel then
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") and btn:FindFirstChild("BtnGrad") then
                paintFloatingBtn(btn, btn:GetAttribute("MobActive") == true)
            end
        end
    end
end

local HOMERO_CFG = {
    body = { 10725826963, 86500008, 86500054, 86500036, 86500064, 86500078 },
    aplicarCuerpo = true,
    items = {
        { id = 103227700418, offset = _CFnew(0,0,0) },
        { id = 84952305140948,   offset = _CFnew(0,0,0) },
        { id = 122465238537030,  offset = _CFnew(0,0,0) },
    },
    shirt = nil,
    pants = "rbxassetid://78591690208112",
    skinColor = Color3.fromRGB(234,184,146),
    headColor = Color3.fromRGB(0,0,0),
}

local TAG = "LocalOutfit_"

local function loadObjects(id)
    local ok, res = pcall(function()
        return game:GetObjects("rbxassetid://" .. tostring(id))
    end)
    if ok and typeof(res) == "table" and #res > 0 then return res end
    ok, res = pcall(function()
        return game:GetService("InsertService"):LoadAsset(id)
    end)
    if ok and res then return { res } end
    return nil
end

local function collectParts(objs)
    local out = {}
    for _, o in ipairs(objs) do
        if o:IsA("BasePart") then out[#out + 1] = o end
        for _, d in ipairs(o:GetDescendants()) do
            if d:IsA("BasePart") then out[#out + 1] = d end
        end
    end
    return out
end

local function findAtt(char, name)
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("Attachment") and p.Name == name and p.Parent:IsA("BasePart") then
            return p
        end
    end
end

local function applyBody(char)
    local total = 0
    for _, id in ipairs(HOMERO_CFG.body) do
        local objs = loadObjects(id)
        if objs then
            for _, mp in ipairs(collectParts(objs)) do
                local orig = char:FindFirstChild(mp.Name)
                if orig and orig:IsA("BasePart") then
                    local c = mp:Clone()
                    c.Name = TAG .. "body_" .. mp.Name
                    c.CanCollide = false
                    c.Anchored = false
                    c.Massless = true
                    c.Size = orig.Size
                    c.CFrame = orig.CFrame
                    c.Parent = char
                    local w = Instance.new("WeldConstraint")
                    w.Part0 = orig
                    w.Part1 = c
                    w.Parent = c
                    if orig:GetAttribute("RivalHubOutfitOriginalTransparency") == nil then
                        orig:SetAttribute("RivalHubOutfitOriginalTransparency", orig.Transparency)
                    end
                    orig.Transparency = 1
                    total = total + 1
                end
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end
    return total
end

local function attachItem(char, entry)
    local objs = loadObjects(entry.id)
    if not objs then return false end

    local handle
    for _, p in ipairs(collectParts(objs)) do
        if p.Name == "Handle" then handle = p; break end
        if not handle then handle = p end
    end
    if not handle then
        for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        return false
    end

    local H = handle:Clone()
    for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end

    H.Name = TAG .. "item_" .. tostring(entry.id)
    H.CanCollide = false
    H.Anchored = false
    H.Massless = true

    local wrap = H:FindFirstChildWhichIsA("WrapLayer")
    local target, c0, c1

    if wrap then
        target = char:FindFirstChild("UpperTorso")
              or char:FindFirstChild("Torso")
              or char:FindFirstChild("HumanoidRootPart")
        c0 = entry.offset or _CFnew()
        c1 = _CFnew()
    else
        local hAtt = H:FindFirstChildOfClass("Attachment")
        local bAtt = hAtt and findAtt(char, hAtt.Name)
        if bAtt then
            target = bAtt.Parent
            c0 = bAtt.CFrame * (entry.offset or _CFnew())
            c1 = hAtt.CFrame
        else
            target = char:FindFirstChild("Head")
            c0 = entry.offset or _CFnew(0, 1.4, 0)
            c1 = _CFnew()
        end
    end

    if not target then H:Destroy(); return false end

    H.CFrame = target.CFrame * c0 * c1:Inverse()
    H.Parent = char

    local w = Instance.new("Weld")
    w.Part0 = target
    w.Part1 = H
    w.C0 = c0
    w.C1 = c1
    w.Parent = H
    return true
end

function applyHomeroOutfit(char)
    if not char then char = LP.Character end
    if not char then return end
    char:WaitForChild("Humanoid", 10)
    char:WaitForChild("Head", 10)
    task.wait(0.4)

    for _, d in ipairs(char:GetChildren()) do
        if d.Name:sub(1, #TAG) == TAG then pcall(function() d:Destroy() end) end
    end

    if HOMERO_CFG.skinColor then
        local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
        bc.HeadColor3 = HOMERO_CFG.headColor or HOMERO_CFG.skinColor
        bc.TorsoColor3 = HOMERO_CFG.skinColor
        bc.LeftArmColor3, bc.RightArmColor3 = HOMERO_CFG.skinColor, HOMERO_CFG.skinColor
        bc.LeftLegColor3, bc.RightLegColor3 = HOMERO_CFG.skinColor, HOMERO_CFG.skinColor
        bc.Parent = char
    end

    for _, a in ipairs(char:GetChildren()) do
        if a:IsA("Accessory") then
            local h = a:FindFirstChild("Handle")
            if h then h.Transparency = 1 end
        end
    end

    if HOMERO_CFG.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"
        s.ShirtTemplate = HOMERO_CFG.shirt
        s.Parent = char
    end
    if HOMERO_CFG.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"
        p.PantsTemplate = HOMERO_CFG.pants
        p.Parent = char
    end
    if HOMERO_CFG.aplicarCuerpo then applyBody(char) end
    for _, e in ipairs(HOMERO_CFG.items) do attachItem(char, e) end
end

local _originalAppearance = nil

local function captureOriginalAppearance(char)
    if not char or _originalAppearance then return end
    local data = {
        bodyColors = nil,
        shirt = nil,
        pants = nil,
        headMesh = nil,
        headTexture = nil,
    }
    local bc = char:FindFirstChildWhichIsA("BodyColors")
    if bc then
        data.bodyColors = {
            head = bc.HeadColor3,
            torso = bc.TorsoColor3,
            leftArm = bc.LeftArmColor3,
            rightArm = bc.RightArmColor3,
            leftLeg = bc.LeftLegColor3,
            rightLeg = bc.RightLegColor3,
        }
    end
    local sh = char:FindFirstChildWhichIsA("Shirt")
    if sh then data.shirt = sh.ShirtTemplate end
    local pa = char:FindFirstChildWhichIsA("Pants")
    if pa then data.pants = pa.PantsTemplate end
    local head = char:FindFirstChild("Head")
    if head then
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if sm and sm.MeshType == Enum.MeshType.FileMesh then
            data.headMesh = sm.MeshId
            data.headTexture = sm.TextureId
        end
    end
    _originalAppearance = data
end

local function clearPreviousOutfitAssets(char)
    if not char then return end
    for _, child in ipairs(char:GetChildren()) do
        if child.Name:sub(1, #TAG) == TAG
        or child.Name == "AuFfitAccessory"
        or child.Name == "BubbleSkinChanger_Hair"
        or child.Name == "Korblox_RightLeg" then
            pcall(function() child:Destroy() end)
        elseif child:IsA("CharacterMesh") and child.BodyPart == Enum.BodyPart.Head then
            pcall(function() child:Destroy() end)
        end
    end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            local originalTransparency = part:GetAttribute("RivalHubOutfitOriginalTransparency")
            if originalTransparency ~= nil then
                part.Transparency = originalTransparency
                part:SetAttribute("RivalHubOutfitOriginalTransparency", nil)
            end
            local originalLocalTransparency = part:GetAttribute("RivalHubOutfitOriginalLocalTransparency")
            if originalLocalTransparency ~= nil then
                part.LocalTransparencyModifier = originalLocalTransparency
                part:SetAttribute("RivalHubOutfitOriginalLocalTransparency", nil)
            end
        end
    end
    if _originalAppearance and _originalAppearance.bodyColors then
        local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
        local o = _originalAppearance.bodyColors
        bc.HeadColor3, bc.TorsoColor3 = o.head, o.torso
        bc.LeftArmColor3, bc.RightArmColor3 = o.leftArm, o.rightArm
        bc.LeftLegColor3, bc.RightLegColor3 = o.leftLeg, o.rightLeg
        bc.Parent = char
    end
    local head = char:FindFirstChild("Head")
    if head and head:IsA("MeshPart") and head:GetAttribute("RivalHubOutfitModifiedMeshPart") then
        pcall(function()
            head.MeshId = head:GetAttribute("RivalHubOutfitOriginalMeshId") or ""
            head.TextureID = head:GetAttribute("RivalHubOutfitOriginalTextureId") or ""
        end)
        head:SetAttribute("RivalHubOutfitModifiedMeshPart", nil)
        head:SetAttribute("RivalHubOutfitOriginalMeshId", nil)
        head:SetAttribute("RivalHubOutfitOriginalTextureId", nil)
    elseif head then
        local specialMesh = head:FindFirstChildWhichIsA("SpecialMesh")
        if specialMesh and specialMesh:GetAttribute("RivalHubOutfitCreatedMesh") then
            specialMesh:Destroy()
        elseif specialMesh and specialMesh:GetAttribute("RivalHubOutfitModifiedMesh") then
            specialMesh.MeshId = specialMesh:GetAttribute("RivalHubOutfitOriginalMeshId") or ""
            specialMesh.TextureId = specialMesh:GetAttribute("RivalHubOutfitOriginalTextureId") or ""
            specialMesh:SetAttribute("RivalHubOutfitModifiedMesh", nil)
            specialMesh:SetAttribute("RivalHubOutfitOriginalMeshId", nil)
            specialMesh:SetAttribute("RivalHubOutfitOriginalTextureId", nil)
        end
    end
end

local function applyNoOutfit(char)
    if not char then char = LP.Character end
    if not char then return end
    for _, d in ipairs(char:GetChildren()) do
        if d.Name:sub(1, #TAG) == TAG then pcall(function() d:Destroy() end) end
    end
    local oldAcc = char:FindFirstChild("AuFfitAccessory")
    if oldAcc then pcall(function() oldAcc:Destroy() end) end
    local oldKorblox = char:FindFirstChild("Korblox_RightLeg")
    if oldKorblox then pcall(function() oldKorblox:Destroy() end) end
    for _, d in ipairs(char:GetChildren()) do
        if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
            pcall(function() d:Destroy() end)
        end
    end
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 0
        head.CanCollide = true
        head.LocalTransparencyModifier = 0
        local face = head:FindFirstChild("face")
        if face then face.Transparency = 0 end
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if sm then
            if _originalAppearance and _originalAppearance.headMesh then
                sm.MeshId = _originalAppearance.headMesh
                sm.TextureId = _originalAppearance.headTexture or ""
            else
                pcall(function() sm:Destroy() end)
            end
        end
    end
    pcall(function()
        local neck = char:FindFirstChild("Neck")
        if neck then neck.Enabled = true end
    end)
    for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
        local limb = char:FindFirstChild(partName)
        if limb then limb.Transparency = 0 end
    end
    if _originalAppearance and _originalAppearance.bodyColors then
        local bc = char:FindFirstChildWhichIsA("BodyColors") or Instance.new("BodyColors")
        local o = _originalAppearance.bodyColors
        bc.HeadColor3 = o.head
        bc.TorsoColor3 = o.torso
        bc.LeftArmColor3 = o.leftArm
        bc.RightArmColor3 = o.rightArm
        bc.LeftLegColor3 = o.leftLeg
        bc.RightLegColor3 = o.rightLeg
        bc.Parent = char
    end
    if _originalAppearance and _originalAppearance.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.ShirtTemplate = _originalAppearance.shirt
        s.Parent = char
    end
    if _originalAppearance and _originalAppearance.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.PantsTemplate = _originalAppearance.pants
        p.Parent = char
    end
    for _, a in ipairs(char:GetChildren()) do
        if a:IsA("Accessory") then
            local h = a:FindFirstChild("Handle")
            if h then h.Transparency = 0 end
        end
    end
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Accessory") then
            for _, part in ipairs(item:GetDescendants()) do
                if part:IsA("BasePart") then
                    local original = part:GetAttribute("RivalHubOriginalTransparency")
                    if original ~= nil then part.Transparency = original; part:SetAttribute("RivalHubOriginalTransparency", nil) end
                    local originalLocal = part:GetAttribute("RivalHubOriginalLocalTransparency")
                    if originalLocal ~= nil then part.LocalTransparencyModifier = originalLocal; part:SetAttribute("RivalHubOriginalLocalTransparency", nil) end
                end
            end
        elseif item:IsA("Shirt") then
            local original = item:GetAttribute("RivalHubOriginalTemplate")
            if original ~= nil then item.ShirtTemplate = original; item:SetAttribute("RivalHubOriginalTemplate", nil) end
        elseif item:IsA("Pants") then
            local original = item:GetAttribute("RivalHubOriginalTemplate")
            if original ~= nil then item.PantsTemplate = original; item:SetAttribute("RivalHubOriginalTemplate", nil) end
        elseif item:IsA("ShirtGraphic") then
            local original = item:GetAttribute("RivalHubOriginalGraphic")
            if original ~= nil then item.Graphic = original; item:SetAttribute("RivalHubOriginalGraphic", nil) end
        end
    end
end

local OUTFITS = {
    { label = "OFF", customApply = applyNoOutfit },
    { accessory = 10159600649, offset = _V3new(0, 1, -0.2), shirt = "http://www.roblox.com/asset/?id=9683332638", pants = "http://www.roblox.com/asset/?id=93182020184041", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918 ", korblox = "none", label = "Outfit 1", headlessKorblox = true },
    { accessory = 1744060292, offset = _V3new(0, 1.3, -0.2), shirt = "http://www.roblox.com/asset/?id=9683332638", pants = "http://www.roblox.com/asset/?id=93182020184041", headMesh = "http://www.roblox.com/asset/?id=134079402", headTexture = "http://www.roblox.com/asset/?id=133940918 ", korblox = "none", label = "Outfit 2", headlessKorblox = true },
    { bubbleShirt = 18552805597, bubblePants = 5414143509, bubbleHair = 84008082880128, label = "Outfit 5", headlessKorblox = false },
}
local currentOutfitIndex = 1
local outfitSelectorLabel = nil

-- ===== VX7 Avatars (portado de VX7 Hub) =====
VX7A = {
    index = 0, mod = nil, loading = false, busy = false, pending = nil, label = nil,
    labels = {"OFF", "ALIEN", "OUTFIT", "OUTFIT 2", "OUTFIT 3", "OUTFIT 4", "OUTFIT 5", "OUTFIT 6", "RIVAL", "NEW SKIN"},
}
VX7A.src = [==[
local Players = game:GetService("Players")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local InsertService = game:GetService("InsertService")
local MarketplaceService = game:GetService("MarketplaceService")
local HttpService = game:GetService("HttpService")
local huiOk, huiResult = pcall(function() return gethui and gethui() end)
local CoreGui = huiOk and huiResult or game:GetService("CoreGui")
local LP = Players.LocalPlayer
local OUTFITS = {
{
id = 10997283529,
label = "ALIEN",
hideOriginal = false,
hideOriginalHead = true,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
items = {10997283529, 125085889448130},
},
{
label = "OUTFIT",
hideOriginal = false,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
items = {125157548394108, 123231522991173, 74827642361405},
},
{
label = "OUTFIT 2",
hideOriginal = false,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
scales = {HeightScale = 1, WidthScale = 0.85, DepthScale = 0.88, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.85},
face = 86109936998865,
faceMode = "decal",
items = {136644276218918, 132022106987543, 131740907052260},
},
{
label = "OUTFIT 3",
hideOriginal = false,
headless = true,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
scales = {HeightScale = 1, WidthScale = 0.82, DepthScale = 0.85, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.9},
layeredPuffiness = 0,
items = {119331031817124, 84952305140948},
},
{
label = "OUTFIT 4",
hideOriginal = false,
headless = true,
clearOriginalWearables = true,
bodyItems = {115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322},
scales = {HeightScale = 1, WidthScale = 0.82, DepthScale = 0.85, HeadScale = 0.95, BodyTypeScale = 1, ProportionScale = 0.9},
layeredPuffiness = 0,
items = {18902416696, 17739456422, 116750288839357, 12842417046, 122223069519702},
},
{
label = "OUTFIT 5",
hideOriginal = false,
clearOriginalWearables = true,
items = {13935333090, 16110951997, 10632503818},
},
{
label = "OUTFIT 6",
hideOriginal = false,
headless = true,
clearOriginalWearables = true,
items = {74891470, 4390891467, 91274263831244, 128424248603010, 91151766440767, 17044638424},
},
{
label = "RIVAL",
hideOriginal = false,
headless = true,
hideRightLeg = true,
localOnly = true,
clearOriginalWearables = true,
items = {76479271580913, 1402432199, 140627490971265, 128912609563885, 17449551560, 5796531729, 139607718},
},
{
label = "NEW SKIN",
localOnly = true,
preserveRig = true,
hideOriginal = false,
hideLeftLeg = true,
hideRightLeg = true,
clearOriginalWearables = true,
items = {70414871864071,14863917259,133498027006138,82277826177074},
accessorySlots = {[70414871864071]=Enum.AccessoryType.Waist,[14863917259]=Enum.AccessoryType.Neck,
[133498027006138]=Enum.AccessoryType.Shoulder,[82277826177074]=Enum.AccessoryType.Sweater},
},
}
local BODY_PART_NAMES = {
Head = true, UpperTorso = true, LowerTorso = true, Torso = true,
LeftUpperArm = true, LeftLowerArm = true, LeftHand = true,
RightUpperArm = true, RightLowerArm = true, RightHand = true,
LeftUpperLeg = true, LeftLowerLeg = true, LeftFoot = true,
RightUpperLeg = true, RightLowerLeg = true, RightFoot = true,
["Left Arm"] = true, ["Right Arm"] = true,
["Left Leg"] = true, ["Right Leg"] = true,
}
local PART_NAME_ALIASES = {
["Korblox-Deathspeaker-Right-Leg"] = "RightUpperLeg",
}
local state = {
enabled = false,
selected = 1,
visuals = {},
hidden = {},
wearableConn = nil,
headlessConn = nil,
headlessLoop = nil,
statsLoop = nil,
savedWalkSpeed = nil,
savedJumpPower = nil,
originalDescription = nil,
descriptionCharacter = nil,
connections = {},
}
local function currentCharacter()
local character = LP.Character or LP.CharacterAdded:Wait()
local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 8)
local root = character:FindFirstChild("HumanoidRootPart") or character:WaitForChild("HumanoidRootPart", 8)
return character, humanoid, root
end
local function restoreOriginalBody()
for object, saved in pairs(state.hidden) do
if object and object.Parent then
pcall(function()
if type(saved) == "table" and saved.basePart then
object.LocalTransparencyModifier = saved.localTransparency
object.Transparency = saved.transparency
elseif type(saved) == "table" and saved.properties then
for property, value in pairs(saved.properties) do object[property] = value end
elseif type(saved) == "table" and saved.property then
object[saved.property] = saved.value
elseif object:IsA("BasePart") then
object.LocalTransparencyModifier = saved
elseif object:IsA("Decal") or object:IsA("Texture") then
object.Transparency = saved
end
end)
end
end
state.hidden = {}
end
local stopHeadless
local enforceHeadless
local enforceStats
local function clearVisuals()
stopHeadless()
if state.wearableConn then
state.wearableConn:Disconnect()
state.wearableConn = nil
end
for _, object in ipairs(state.visuals) do
if object and object.Parent then pcall(function() object:Destroy() end) end
end
state.visuals = {}
restoreOriginalBody()
end
local function belongsToLocalVisual(object)
for _, visual in ipairs(state.visuals) do
if object == visual or object:IsDescendantOf(visual) then return true end
end
return false
end
local function hideOriginalBody(character)
restoreOriginalBody()
for _, object in ipairs(character:GetDescendants()) do
if not belongsToLocalVisual(object) then
if object:IsA("BasePart") then
state.hidden[object] = object.LocalTransparencyModifier
object.LocalTransparencyModifier = 1
elseif object:IsA("Decal") or object:IsA("Texture") then
state.hidden[object] = object.Transparency
object.Transparency = 1
end
end
end
end
local function hideOriginalHead(character)
local head = character:FindFirstChild("Head")
if not head or not head:IsA("BasePart") then return end
if state.hidden[head] == nil then
state.hidden[head] = {
basePart = true,
localTransparency = head.LocalTransparencyModifier,
transparency = head.Transparency,
}
elseif type(state.hidden[head]) ~= "table" then
state.hidden[head] = {
basePart = true,
localTransparency = state.hidden[head],
transparency = head.Transparency,
}
end
head.LocalTransparencyModifier = 1
head.Transparency = 1
for _, object in ipairs(head:GetDescendants()) do
if (object:IsA("Decal") or object:IsA("Texture")) and state.hidden[object] == nil then
state.hidden[object] = object.Transparency
object.Transparency = 1
end
end
end
local function hideLegSide(character, side)
local names = {side .. "UpperLeg", side .. "LowerLeg", side .. "Foot", side .. " Leg", side .. "Toe"}
for _, name in ipairs(names) do
local part = character:FindFirstChild(name)
if part and part:IsA("BasePart") then
if state.hidden[part] == nil then
state.hidden[part] = {
basePart = true,
localTransparency = part.LocalTransparencyModifier,
transparency = part.Transparency,
}
elseif type(state.hidden[part]) ~= "table" then
state.hidden[part] = {
basePart = true,
localTransparency = state.hidden[part],
transparency = part.Transparency,
}
end
part.LocalTransparencyModifier = 1
part.Transparency = 1
end
end
end
local function hideLeftLeg(character)
hideLegSide(character, "Left")
end
local function hideRightLeg(character)
hideLegSide(character, "Right")
end
stopHeadless = function()
if state.headlessConn then
pcall(state.headlessConn.Disconnect, state.headlessConn)
state.headlessConn = nil
end
if state.headlessLoop then
pcall(task.cancel, state.headlessLoop)
state.headlessLoop = nil
end
if state.statsLoop then
pcall(task.cancel, state.statsLoop)
state.statsLoop = nil
end
end
enforceHeadless = function(character, option)
stopHeadless()
if not option or not character or not (option.headless or option.hideLeftLeg or option.hideRightLeg) then return end
if option.headless then hideOriginalHead(character) end
if option.hideLeftLeg then hideLeftLeg(character) end
if option.hideRightLeg then hideRightLeg(character) end
state.headlessConn = character.ChildAdded:Connect(function(child)
if child:IsA("BasePart") and (option.hideLeftLeg or option.hideRightLeg) then
task.defer(function()
if state.enabled and LP.Character==character then
local active=OUTFITS[state.selected]
if active.hideLeftLeg then hideLeftLeg(character) end
if active.hideRightLeg then hideRightLeg(character) end end end) end
if child.Name == "Head" and child:IsA("BasePart") and OUTFITS[state.selected].headless then
task.defer(function()
if state.enabled and LP.Character == character and OUTFITS[state.selected].headless then
pcall(hideOriginalHead, character)
end
end)
end
end)
state.headlessLoop = task.spawn(function()
while state.enabled and LP.Character == character do
local opt = OUTFITS[state.selected]
if opt and opt.headless then
local head = character:FindFirstChild("Head")
if head and head:IsA("BasePart") and head.LocalTransparencyModifier < 1 then
pcall(hideOriginalHead, character)
end
end
if opt and opt.hideLeftLeg then
pcall(hideLeftLeg, character)
end
if opt and opt.hideRightLeg then
pcall(hideRightLeg, character)
end
task.wait(0.6)
end
end)
end
enforceStats = function(character)
if state.statsLoop then
pcall(task.cancel, state.statsLoop)
state.statsLoop = nil
end
state.statsLoop = task.spawn(function()
while state.enabled and LP.Character == character do
local humanoid = character:FindFirstChildOfClass("Humanoid")
if humanoid then
if state.savedWalkSpeed ~= nil and humanoid.WalkSpeed ~= state.savedWalkSpeed then
humanoid.WalkSpeed = state.savedWalkSpeed
end
if state.savedJumpPower ~= nil and humanoid.JumpPower ~= state.savedJumpPower then
humanoid.JumpPower = state.savedJumpPower
end
end
task.wait(0.4)
end
end)
end
local function hideOriginalWearables(character, watchForNew)
for _, child in ipairs(character:GetChildren()) do
if child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") then
if not child:GetAttribute("VX7LocalOnly") and state.hidden[child] == nil then
local property = child:IsA("Shirt") and "ShirtTemplate"
or child:IsA("Pants") and "PantsTemplate"
or "Graphic"
state.hidden[child] = {property = property, value = child[property]}
child[property] = ""
end
end
end
for _, child in ipairs(character:GetDescendants()) do
if (child:IsA("Accessory") or child:IsA("Accoutrement")) and not child:GetAttribute("VX7LocalOnly") then
local objects = child:GetDescendants()
if child:IsA("BasePart") then table.insert(objects, child) end
for _, object in ipairs(objects) do
if object:IsA("BasePart") then
local saved = state.hidden[object]
if saved == nil then
state.hidden[object] = {
basePart = true,
localTransparency = object.LocalTransparencyModifier,
transparency = object.Transparency,
}
elseif type(saved) ~= "table" then
state.hidden[object] = {
basePart = true,
localTransparency = saved,
transparency = object.Transparency,
}
end
object.LocalTransparencyModifier = 1
object.Transparency = 1
elseif (object:IsA("Decal") or object:IsA("Texture")) and state.hidden[object] == nil then
state.hidden[object] = object.Transparency
object.Transparency = 1
elseif (object:IsA("ParticleEmitter") or object:IsA("Trail") or object:IsA("Beam")) and state.hidden[object] == nil then
state.hidden[object] = {property = "Enabled", value = object.Enabled}
object.Enabled = false
end
end
end
end
if watchForNew and not state.wearableConn then
state.wearableConn = character.DescendantAdded:Connect(function(object)
if not state.enabled or not OUTFITS[state.selected].clearOriginalWearables then return end
if object:IsA("Accessory") or object:IsA("Accoutrement")
or object:FindFirstAncestorWhichIsA("Accessory")
or object:FindFirstAncestorWhichIsA("Accoutrement") then
task.defer(function()
if state.enabled and character.Parent then hideOriginalWearables(character, false) end
end)
end
end)
end
end
local function loadAssetObjects(assetId)
local insertOk, inserted = pcall(function() return InsertService:LoadAsset(assetId) end)
if insertOk and inserted then return {inserted}, "InsertService" end
local objectOk, objects = pcall(function() return game:GetObjects("rbxassetid://" .. assetId) end)
if objectOk and objects and #objects > 0 then return objects, "GetObjects" end
return nil, tostring(inserted or objects or "unknown loading error")
end
local faceTextureCache = {}
local function resolveFaceTexture(faceId)
if faceTextureCache[faceId] then return faceTextureCache[faceId] end
local objects = loadAssetObjects(faceId)
if objects then
local texture
for _, root in ipairs(objects) do
local candidates = {root}
for _, object in ipairs(root:GetDescendants()) do table.insert(candidates, object) end
for _, object in ipairs(candidates) do
if object:IsA("Decal") or object:IsA("Texture") then
texture = object.Texture
if texture and texture ~= "" then break end
end
end
pcall(function() root:Destroy() end)
if texture and texture ~= "" then break end
end
if texture and texture ~= "" then
faceTextureCache[faceId] = texture
return texture
end
end
return "rbxassetid://" .. tostring(faceId)
end
local function applyLocalFace(character, faceId)
local head = character:FindFirstChild("Head")
if not head then return false end
local face = head:FindFirstChild("face") or head:FindFirstChildWhichIsA("Decal")
if face and not face:IsA("Decal") then face = nil end
if face then
if state.hidden[face] == nil then
state.hidden[face] = {
properties = {Texture = face.Texture, Transparency = face.Transparency},
}
end
else
face = Instance.new("Decal")
face.Name = "face"
face.Face = Enum.NormalId.Front
face:SetAttribute("VX7LocalOnly", true)
face.Parent = head
table.insert(state.visuals, face)
end
face.Texture = resolveFaceTexture(faceId)
face.Transparency = 0
return true
end
local function applyLocalFaceStable(character, faceId)
pcall(applyLocalFace, character, faceId)
for _, delayTime in ipairs({0.2, 0.8}) do
task.delay(delayTime, function()
local option = OUTFITS[state.selected]
if state.enabled and LP.Character == character and option and option.face == faceId then
pcall(applyLocalFace, character, faceId)
end
end)
end
end
local function findCharacterAttachment(character, name)
for _, object in ipairs(character:GetDescendants()) do
if object:IsA("Attachment") and object.Name == name and not object:FindFirstAncestorWhichIsA("Accessory") then
return object
end
end
end
local function sanitizeVisual(container)
local objects = container:GetDescendants()
if container:IsA("BasePart") then table.insert(objects, container) end
for _, object in ipairs(objects) do
if object:IsA("LuaSourceContainer") then
object:Destroy()
elseif object:IsA("BasePart") then
object.Anchored = false
object.CanCollide = false
object.CanTouch = false
object.CanQuery = false
object.Massless = true
object.CastShadow = false
elseif object:IsA("JointInstance") and object.Name == "AccessoryWeld" then
object:Destroy()
end
end
end
local function weldPart(part, target)
local weld = Instance.new("WeldConstraint")
weld.Name = "VX7LocalVisualWeld"
weld.Part0 = target
weld.Part1 = part
weld.Parent = part
end
local function countStackedAccessories(character, attachmentName)
local count = 0
for _, visual in ipairs(state.visuals) do
if visual:IsA("Accessory") then
local h = visual:FindFirstChild("Handle") or visual:FindFirstChildWhichIsA("BasePart", true)
if h then
for _, child in ipairs(h:GetChildren()) do
if child:IsA("Attachment") and child.Name == attachmentName then
count = count + 1
break
end
end
end
end
end
return count
end
local function attachAccessoryLocal(accessory, character, rootPart, assetId)
local handle = accessory:FindFirstChild("Handle") or accessory:FindFirstChildWhichIsA("BasePart", true)
if not handle then return false end
sanitizeVisual(accessory)
accessory.Name = "VX7_LocalOutfit_" .. tostring(assetId)
accessory:SetAttribute("VX7AssetId", assetId)
accessory:SetAttribute("VX7LocalOnly", true)
local option=OUTFITS[state.selected]
local slot=option and option.accessorySlots and option.accessorySlots[assetId]
if slot then pcall(function() accessory.AccessoryType=slot end) end
accessory.Parent = character
local sourceAttachment
for _, child in ipairs(handle:GetChildren()) do
if child:IsA("Attachment") and findCharacterAttachment(character, child.Name) then
sourceAttachment = child
break
end
end
local targetAttachment = sourceAttachment and findCharacterAttachment(character, sourceAttachment.Name)
local targetPart = targetAttachment and targetAttachment.Parent
if targetAttachment and targetPart and targetPart:IsA("BasePart") then
handle.CFrame = targetAttachment.WorldCFrame * sourceAttachment.CFrame:Inverse()
local stacked = countStackedAccessories(character, sourceAttachment.Name)
if stacked > 0 then
handle.CFrame = handle.CFrame * CFrame.new(0, stacked * 0.15, 0)
end
else
targetPart = character:FindFirstChild("LowerTorso")
or character:FindFirstChild("Torso")
or rootPart
if not targetPart then accessory:Destroy(); return false end
handle.CFrame = rootPart.CFrame
end
weldPart(handle, targetPart)
table.insert(state.visuals, accessory)
return true
end
local function attachLooseVisual(rootObject, character, rootPart, assetId, textureId, targetPart)
local clone = rootObject:Clone()
sanitizeVisual(clone)
clone.Name = "VX7_LocalOutfit_" .. tostring(assetId)
clone:SetAttribute("VX7AssetId", assetId)
clone.Parent = character
local parts = {}
if clone:IsA("BasePart") then table.insert(parts, clone) end
for _, object in ipairs(clone:GetDescendants()) do
if object:IsA("BasePart") then table.insert(parts, object) end
end
if #parts == 0 then clone:Destroy(); return false end
local anchor = targetPart or rootPart
if textureId then
for _, part in ipairs(parts) do
if part:IsA("MeshPart") then
pcall(function() part.TextureID = "rbxassetid://" .. tostring(textureId) end)
end
end
end
local pivot = clone:IsA("Model") and clone:GetPivot() or parts[1].CFrame
for _, part in ipairs(parts) do
local offset = pivot:ToObjectSpace(part.CFrame)
part.CFrame = anchor.CFrame * offset
weldPart(part, anchor)
end
table.insert(state.visuals, clone)
return true
end
local function attachClassicClothingLocal(rootObject, character, assetId)
local candidates = {}
if rootObject:IsA("Shirt") or rootObject:IsA("Pants") or rootObject:IsA("ShirtGraphic") then
table.insert(candidates, rootObject)
end
for _, object in ipairs(rootObject:GetDescendants()) do
if object:IsA("Shirt") or object:IsA("Pants") or object:IsA("ShirtGraphic") then
table.insert(candidates, object)
end
end
local added = 0
for _, source in ipairs(candidates) do
for _, existing in ipairs(character:GetChildren()) do
if existing.ClassName == source.ClassName and not existing:GetAttribute("VX7LocalOnly") then
local property = existing:IsA("Shirt") and "ShirtTemplate"
or existing:IsA("Pants") and "PantsTemplate"
or "Graphic"
state.hidden[existing] = {property = property, value = existing[property]}
existing[property] = ""
end
end
local clone = source:Clone()
clone.Name = "VX7_LocalClothing_" .. tostring(assetId)
clone:SetAttribute("VX7AssetId", assetId)
clone:SetAttribute("VX7LocalOnly", true)
clone.Parent = character
table.insert(state.visuals, clone)
added = added + 1
end
return added
end
local function attachBodyPartsLocal(rootObject, character, assetId, textureId)
local holder = Instance.new("Model")
holder.Name = "VX7_LocalBody_" .. tostring(assetId)
holder:SetAttribute("VX7AssetId", assetId)
holder:SetAttribute("VX7LocalOnly", true)
holder.Parent = character
local bodyColors = rootObject:FindFirstChildOfClass("BodyColors")
local colorProperties = {
Head = "HeadColor", UpperTorso = "TorsoColor", LowerTorso = "TorsoColor", Torso = "TorsoColor",
LeftUpperArm = "LeftArmColor", LeftLowerArm = "LeftArmColor", LeftHand = "LeftArmColor", ["Left Arm"] = "LeftArmColor",
RightUpperArm = "RightArmColor", RightLowerArm = "RightArmColor", RightHand = "RightArmColor", ["Right Arm"] = "RightArmColor",
LeftUpperLeg = "LeftLegColor", LeftLowerLeg = "LeftLegColor", LeftFoot = "LeftLegColor", ["Left Leg"] = "LeftLegColor",
RightUpperLeg = "RightLegColor", RightLowerLeg = "RightLegColor", RightFoot = "RightLegColor", ["Right Leg"] = "RightLegColor",
}
local added = 0
local candidates = {}
if rootObject:IsA("BasePart") then table.insert(candidates, rootObject) end
for _, object in ipairs(rootObject:GetDescendants()) do
if object:IsA("BasePart") and not object:FindFirstAncestorWhichIsA("Accessory") then
table.insert(candidates, object)
end
end
for _, source in ipairs(candidates) do
local partName = source.Name
if BODY_PART_NAMES[partName] then
local target = character:FindFirstChild(partName)
if not target then
local alias = PART_NAME_ALIASES[partName]
if alias then target = character:FindFirstChild(alias) end
end
if target and target:IsA("BasePart") then
local clone = source:Clone()
for _, child in ipairs(clone:GetDescendants()) do
if child:IsA("JointInstance") or child:IsA("Constraint") or child:IsA("LuaSourceContainer") then
child:Destroy()
end
end
sanitizeVisual(clone)
clone.Name = source.Name
if clone:IsA("MeshPart") and textureId then
pcall(function() clone.TextureID = "rbxassetid://" .. tostring(textureId) end)
end
if bodyColors and colorProperties[source.Name] then
pcall(function() clone.Color = bodyColors[colorProperties[source.Name]].Color end)
end
clone.CFrame = target.CFrame
clone.Parent = holder
weldPart(clone, target)
added = added + 1
end
end
end
if added == 0 then holder:Destroy(); return 0 end
table.insert(state.visuals, holder)
return added
end
local assetInfoCache = {}
local ASSET_INFO_CACHE_FILE="RivalHubAvatarAssets.json"
pcall(function()
if isfile and readfile and isfile(ASSET_INFO_CACHE_FILE) then
local decoded=HttpService:JSONDecode(readfile(ASSET_INFO_CACHE_FILE))
if type(decoded)=="table" then for id,assetType in pairs(decoded) do
local numericId=tonumber(id);local numericType=tonumber(assetType)
if numericId and numericType then assetInfoCache[numericId]=numericType end end end end end)
local assetInfoSaveQueued=false
local function saveAssetInfoCache()
if assetInfoSaveQueued or not writefile then return end
assetInfoSaveQueued=true;task.delay(.4,function()
assetInfoSaveQueued=false;pcall(function()
local encoded={};for id,assetType in pairs(assetInfoCache) do encoded[tostring(id)]=assetType end
writefile(ASSET_INFO_CACHE_FILE,HttpService:JSONEncode(encoded)) end) end) end
local bodyPropertyByType = {
[17] = "Head", [27] = "Torso", [28] = "RightArm",
[29] = "LeftArm", [30] = "LeftLeg", [31] = "RightLeg", [79] = "Head",
}
local bodyPartAnchorNames = {
[17] = {"Head"}, [79] = {"Head"},
[27] = {"UpperTorso", "Torso"},
[28] = {"RightUpperArm", "Right Arm"},
[29] = {"LeftUpperArm", "Left Arm"},
[30] = {"LeftUpperLeg", "Left Leg"},
[31] = {"RightUpperLeg", "Right Leg"},
}
local accessoryTypeByAssetType = {
[8] = Enum.AccessoryType.Hat,
[41] = Enum.AccessoryType.Hair,
[42] = Enum.AccessoryType.Face,
[43] = Enum.AccessoryType.Neck,
[44] = Enum.AccessoryType.Shoulder,
[45] = Enum.AccessoryType.Front,
[46] = Enum.AccessoryType.Back,
[47] = Enum.AccessoryType.Waist,
[64] = Enum.AccessoryType.TShirt,
[65] = Enum.AccessoryType.Shirt,
[66] = Enum.AccessoryType.Pants,
[67] = Enum.AccessoryType.Jacket,
[68] = Enum.AccessoryType.Sweater,
[69] = Enum.AccessoryType.Shorts,
[70] = Enum.AccessoryType.LeftShoe,
[71] = Enum.AccessoryType.RightShoe,
[72] = Enum.AccessoryType.DressSkirt,
[76] = Enum.AccessoryType.Eyebrow,
[77] = Enum.AccessoryType.Eyelash,
}
local function getAssetTypeId(assetId)
if assetInfoCache[assetId] then return assetInfoCache[assetId] end
local ok, info = pcall(MarketplaceService.GetProductInfo, MarketplaceService, assetId, Enum.InfoType.Asset)
if ok and info and info.AssetTypeId then
assetInfoCache[assetId] = info.AssetTypeId
saveAssetInfoCache()
return info.AssetTypeId
end
end
local accessoryDescriptionProperties = {
"BackAccessory", "FaceAccessory", "FrontAccessory", "HairAccessory",
"HatAccessory", "NeckAccessory", "ShouldersAccessory", "WaistAccessory",
"TShirtAccessory", "ShirtAccessory", "PantsAccessory", "JacketAccessory",
"SweaterAccessory", "ShortsAccessory", "DressSkirtAccessory",
"EyebrowAccessory", "EyelashAccessory",
}
local function createDirectDescription(option, humanoid)
local directOutfitId = option.outfitId
local completeOutfitDescription
if directOutfitId then
local ok, outfitDescription = pcall(
Players.GetHumanoidDescriptionFromOutfitId,
Players,
directOutfitId
)
if not ok or not outfitDescription then return nil end
completeOutfitDescription = outfitDescription
if not option.items and not option.face and not option.head then return outfitDescription end
end
local source = completeOutfitDescription or state.originalDescription
if not source then
local ok, applied = pcall(function() return humanoid:GetAppliedDescription() end)
if not ok or not applied then return nil end
source = applied
end
local description = source:Clone()
if completeOutfitDescription then completeOutfitDescription:Destroy() end
if not directOutfitId then
description.Shirt = 0
description.Pants = 0
description.GraphicTShirt = 0
for _, property in ipairs(accessoryDescriptionProperties) do
pcall(function() description[property] = "" end)
end
pcall(function() description:SetAccessories({}, true) end)
end
local accessories = {}
if directOutfitId then
pcall(function() accessories = description:GetAccessories(true) end)
end
local allItems = {}
for _, id in ipairs(option.bodyItems or {}) do table.insert(allItems, id) end
for _, id in ipairs(option.items or {}) do table.insert(allItems, id) end
for _, id in ipairs(allItems) do
local assetTypeId = getAssetTypeId(id)
if not assetTypeId then description:Destroy(); return nil end
local bodyProperty = bodyPropertyByType[assetTypeId]
local accessoryType = accessoryTypeByAssetType[assetTypeId]
if bodyProperty then
description[bodyProperty] = id
elseif assetTypeId == 11 then
description.Shirt = id
elseif assetTypeId == 12 then
description.Pants = id
elseif assetTypeId == 1 then
description.GraphicTShirt = id
elseif assetTypeId == 18 then
description.Face = id
elseif accessoryType then
local accessory = {
AssetId = id,
AccessoryType = accessoryType,
Order = #accessories + 1,
}
if assetTypeId >= 64 and assetTypeId <= 72 then
accessory.IsLayered = true
accessory.Puffiness = option.layeredPuffiness or 0
end
table.insert(accessories, accessory)
else
description:Destroy()
return nil
end
end
if option.face then
local faceTypeId = getAssetTypeId(option.face)
local faceBodyProperty = faceTypeId and bodyPropertyByType[faceTypeId]
local faceAccessoryType = faceTypeId and accessoryTypeByAssetType[faceTypeId]
if option.faceMode == "decal" then
if faceTypeId == 18 then description.Face = option.face end
elseif faceBodyProperty then
description[faceBodyProperty] = option.face
elseif faceAccessoryType then
table.insert(accessories, {
AssetId = option.face,
AccessoryType = faceAccessoryType,
Order = #accessories + 1,
})
elseif faceTypeId == 18 then
description.Face = option.face
end
end
if option.head then description.Head = option.head end
for property, value in pairs(option.scales or {}) do
pcall(function() description[property] = value end)
end
if option.skinColor then
for _, property in ipairs({"HeadColor", "LeftArmColor", "RightArmColor", "LeftLegColor", "RightLegColor", "TorsoColor"}) do
description[property] = option.skinColor
end
end
if #accessories > 0 then
local ok = pcall(function() description:SetAccessories(accessories, true) end)
if not ok then description:Destroy(); return nil end
end
return description
end
local statusText
local function setStatus(text, good)
if not statusText or not statusText.Parent then return end
statusText.Text = text
statusText.TextColor3 = good and Color3.fromRGB(215, 255, 222) or Color3.fromRGB(190, 190, 198)
end
local function applyOutfit()
local character, humanoid, rootPart = currentCharacter()
if not character or not humanoid or not rootPart then setStatus("Character not found", false); return false end
if state.descriptionCharacter ~= character or not state.originalDescription then
state.descriptionCharacter = character
state.originalDescription = nil
local ok, applied = pcall(function() return humanoid:GetAppliedDescription() end)
if ok and applied then state.originalDescription = applied:Clone() end
end
clearVisuals()
setStatus("Loading local visual...", false)
local option = OUTFITS[state.selected]
local assetId = option.id or option.outfitId
state.skipDescriptionRestore=option.preserveRig==true
if option.forceBodyParts or option.localOnly then
setStatus("Local visual only (no rig change)...", false)
end
if (option.bodyItems or option.items or option.outfitId) and not option.forceBodyParts and not option.localOnly then
setStatus(option.outfitId and "Loading complete outfit..." or "Applying outfit and complexion...", false)
local description = createDirectDescription(option, humanoid)
if description then
local savedHead = character:FindFirstChild("Head")
local savedHealth = humanoid.Health
state.savedWalkSpeed = humanoid.WalkSpeed
state.savedJumpPower = humanoid.JumpPower
local savedCFrame = rootPart.CFrame
local savedVelocity = rootPart.AssemblyLinearVelocity
local ok = pcall(function() humanoid:ApplyDescription(description) end)
if not ok then ok = pcall(function() humanoid:ApplyDescriptionReset(description) end) end
description:Destroy()
if ok then
local currentHumanoid = character:FindFirstChildOfClass("Humanoid")
local currentRoot = character:FindFirstChild("HumanoidRootPart")
if currentHumanoid and savedHealth > 0 then
currentHumanoid.Health = math.min(savedHealth, currentHumanoid.MaxHealth)
end
if currentRoot then
currentRoot.CFrame = savedCFrame
currentRoot.AssemblyLinearVelocity = savedVelocity
currentRoot.AssemblyAngularVelocity = Vector3.zero
end
if option.face then
local faceTypeId = getAssetTypeId(option.face)
if option.faceMode == "decal" or not faceTypeId or faceTypeId == 18 then
applyLocalFaceStable(character, option.face)
end
end
state.enabled = true
enforceStats(character)
enforceHeadless(character, option)
if option.hideLeftLeg then hideLeftLeg(character) end
if option.hideRightLeg then hideRightLeg(character) end
if option.head and character:FindFirstChild("Head") == savedHead then
hideOriginalHead(character)
end
setStatus(option.label .. " applied - native avatar method", true)
return true
end
end
setStatus("Native apply failed; using visual fallback...", false)
end
local assetIds = {}
for _, id in ipairs(option.items or {}) do table.insert(assetIds, id) end
if option.head then table.insert(assetIds, option.head) end
if #assetIds == 0 and assetId and not option.outfitId then table.insert(assetIds, assetId) end
local fallbackFaceType = option.face and getAssetTypeId(option.face)
local faceIsAccessory = option.faceMode ~= "decal"
and fallbackFaceType
and accessoryTypeByAssetType[fallbackFaceType] ~= nil
if faceIsAccessory then table.insert(assetIds, option.face) end
local attached, expected = 0, 0
local lastError
expected = expected + (option.face and not faceIsAccessory and 1 or 0)
for _, currentAssetId in ipairs(assetIds) do
local objects, method = loadAssetObjects(currentAssetId)
if objects then
for _, loadedRoot in ipairs(objects) do
local rootAttached = false
local bodyPartsAttached = false
local classics = {}
if loadedRoot:IsA("Shirt") or loadedRoot:IsA("Pants") or loadedRoot:IsA("ShirtGraphic") then
table.insert(classics, loadedRoot)
end
for _, object in ipairs(loadedRoot:GetDescendants()) do
if object:IsA("Shirt") or object:IsA("Pants") or object:IsA("ShirtGraphic") then
table.insert(classics, object)
end
end
local accessories = {}
if loadedRoot:IsA("Accessory") then
table.insert(accessories, loadedRoot)
else
for _, object in ipairs(loadedRoot:GetDescendants()) do
if object:IsA("Accessory") then table.insert(accessories, object:Clone()) end
end
end
local assetTypeId = getAssetTypeId(currentAssetId)
local isBodyPartAsset = assetTypeId ~= nil and bodyPropertyByType[assetTypeId] ~= nil
local bodyCandidates = 0
local wantsBodyParts = not loadedRoot:IsA("Accessory")
and (option.hideOriginal or option.hideOriginalHead or currentAssetId == option.head or (option.forceBodyParts and isBodyPartAsset))
if wantsBodyParts then
local candidates = {}
if loadedRoot:IsA("BasePart") then table.insert(candidates, loadedRoot) end
for _, object in ipairs(loadedRoot:GetDescendants()) do
if object:IsA("BasePart") and not object:FindFirstAncestorWhichIsA("Accessory") then
table.insert(candidates, object)
end
end
for _, object in ipairs(candidates) do
if BODY_PART_NAMES[object.Name] or PART_NAME_ALIASES[object.Name] then bodyCandidates = bodyCandidates + 1 end
end
end
expected = expected + #classics + #accessories + bodyCandidates
if #accessories == 0 and #classics == 0 and bodyCandidates == 0 then expected = expected + 1 end
if #classics > 0 then
local ok, result = pcall(attachClassicClothingLocal, loadedRoot, character, currentAssetId)
if ok and result and result > 0 then attached = attached + result; rootAttached = true end
end
if wantsBodyParts and bodyCandidates > 0 then
local ok, result = pcall(attachBodyPartsLocal, loadedRoot, character, currentAssetId, option.headTexture)
if ok and result and result > 0 then
attached = attached + result
rootAttached = true
bodyPartsAttached = true
end
end
for _, accessory in ipairs(accessories) do
local ok, result = pcall(attachAccessoryLocal, accessory, character, rootPart, currentAssetId)
if ok and result then
attached = attached + 1
rootAttached = true
else
pcall(function() accessory:Destroy() end)
end
end
if not rootAttached and not bodyPartsAttached and #accessories == 0 and #classics == 0 then
local headAnchor = character:FindFirstChild("Head")
local anchor = rootPart
if currentAssetId == option.head then
anchor = headAnchor
elseif isBodyPartAsset then
local anchorNames = bodyPartAnchorNames[assetTypeId]
if anchorNames then
for _, name in ipairs(anchorNames) do
local target = character:FindFirstChild(name)
if target and target:IsA("BasePart") then anchor = target; break end
end
end
end
local ok, result = pcall(attachLooseVisual, loadedRoot, character, rootPart, currentAssetId, option.headTexture, anchor)
if ok and result then attached = attached + 1 end
end
if loadedRoot.Parent == nil and not table.find(state.visuals, loadedRoot) then
pcall(function() loadedRoot:Destroy() end)
end
end
else
lastError = method
end
end
local faceApplied = false
if option.face and not faceIsAccessory then
local ok, result = pcall(applyLocalFace, character, option.face)
faceApplied = ok and result == true
end
local headlessApplied = false
if option.headless then
enforceHeadless(character, option)
headlessApplied = true
end
local legApplied = false
if option.hideLeftLeg then
hideLeftLeg(character)
legApplied = true
end
if option.hideRightLeg then
hideRightLeg(character)
legApplied = true
end
local totalItems = expected
local loadedItems = attached + (faceApplied and 1 or 0)
state.enabled = attached > 0 or faceApplied or headlessApplied or legApplied
if state.enabled then
if option.preserveRig and (option.hideLeftLeg or option.hideRightLeg) then enforceHeadless(character,option) end
if option.hideOriginal then hideOriginalBody(character) end
if option.hideOriginalHead then hideOriginalHead(character) end
if option.head then hideOriginalHead(character) end
if option.clearOriginalWearables then hideOriginalWearables(character, true) end
setStatus(string.format("%s fallback - %d/%d items", option.label, loadedItems, totalItems), loadedItems == totalItems)
else
setStatus("Could not attach outfit - " .. tostring(lastError or "no 3D parts"), false)
end
return state.enabled
end
local function restoreOriginalDescription()
local description = state.originalDescription
local character = LP.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
if description and humanoid and character == state.descriptionCharacter and not state.skipDescriptionRestore then
local clone = description:Clone()
local ok = pcall(function() humanoid:ApplyDescription(clone) end)
if not ok then pcall(function() humanoid:ApplyDescriptionReset(clone) end) end
clone:Destroy()
end
if state.originalDescription then state.originalDescription:Destroy() end
state.originalDescription = nil
state.descriptionCharacter = nil
state.skipDescriptionRestore=false
end
local function removeOutfit()
state.enabled = false
clearVisuals()
restoreOriginalDescription()
setStatus("Local visual removed", true)
end
return {
outfits = OUTFITS,
apply = function(index)
state.selected = math.clamp(math.floor(tonumber(index) or 1), 1, #OUTFITS)
return applyOutfit()
end,
remove = removeOutfit,
description = function(index)
local character = LP.Character
local humanoid = character and character:FindFirstChildOfClass("Humanoid")
local option = OUTFITS[math.clamp(math.floor(tonumber(index) or 1), 1, #OUTFITS)]
if not humanoid or not option then return nil end
local strict = createDirectDescription(option, humanoid)
if strict then return strict end
local ok, applied = pcall(function() return humanoid:GetAppliedDescription() end)
if not ok or not applied then return nil end
local description = applied:Clone(); applied:Destroy()
description.Shirt=0; description.Pants=0; description.GraphicTShirt=0
for _,property in ipairs(accessoryDescriptionProperties) do pcall(function() description[property]="" end) end
pcall(function() description:SetAccessories({},true) end)
local accessories={}; local all={}
for _,id in ipairs(option.bodyItems or {}) do table.insert(all,id) end
for _,id in ipairs(option.items or {}) do table.insert(all,id) end
for _,id in ipairs(all) do
local assetTypeId=getAssetTypeId(id); local bodyProperty=assetTypeId and bodyPropertyByType[assetTypeId]; local accessoryType=assetTypeId and accessoryTypeByAssetType[assetTypeId]
if bodyProperty then description[bodyProperty]=id elseif assetTypeId==11 then description.Shirt=id elseif assetTypeId==12 then description.Pants=id elseif assetTypeId==1 then description.GraphicTShirt=id elseif assetTypeId==18 then description.Face=id elseif accessoryType then
table.insert(accessories,{AssetId=id,AccessoryType=accessoryType,Order=#accessories+1,IsLayered=assetTypeId>=64 and assetTypeId<=72,Puffiness=option.layeredPuffiness or 0}) end
end
if option.face then local faceType=getAssetTypeId(option.face); if faceType==18 then description.Face=option.face elseif faceType and bodyPropertyByType[faceType] then description[bodyPropertyByType[faceType]]=option.face elseif faceType and accessoryTypeByAssetType[faceType] then table.insert(accessories,{AssetId=option.face,AccessoryType=accessoryTypeByAssetType[faceType],Order=#accessories+1}) end end
if option.head then description.Head=option.head end
for property,value in pairs(option.scales or {}) do pcall(function() description[property]=value end) end
if #accessories>0 then pcall(function() description:SetAccessories(accessories,true) end) end
return description
end,
previewModel = function(index)
local option=OUTFITS[math.clamp(math.floor(tonumber(index) or 1),1,#OUTFITS)]; local character=LP.Character
if not option or not character then return nil end
local oldArchivable=character.Archivable; character.Archivable=true; local ok,clone=pcall(function() return character:Clone() end); character.Archivable=oldArchivable
if not ok or not clone then return nil end
for _,child in ipairs(clone:GetChildren()) do
if child:IsA("Accessory") or child:IsA("Accoutrement") or child:IsA("Shirt") or child:IsA("Pants") or child:IsA("ShirtGraphic") or child:IsA("CharacterMesh") or child:IsA("Tool") then child:Destroy() end
end
for _,object in ipairs(clone:GetDescendants()) do if object:IsA("LuaSourceContainer") then object:Destroy() elseif object:IsA("BasePart") then object.Transparency=object.Name=="HumanoidRootPart" and 1 or 0; object.LocalTransparencyModifier=0 end end
local root=clone:FindFirstChild("HumanoidRootPart") or clone:FindFirstChild("LowerTorso") or clone:FindFirstChild("Torso")
if not root then clone:Destroy(); return nil end
local savedVisuals,savedHidden,savedWearable=state.visuals,state.hidden,state.wearableConn; state.visuals={}; state.hidden={}; state.wearableConn=nil
local ids={}; for _,id in ipairs(option.bodyItems or {}) do table.insert(ids,id) end; for _,id in ipairs(option.items or {}) do table.insert(ids,id) end
if option.head then table.insert(ids,option.head) end; if option.face and option.faceMode~="decal" then table.insert(ids,option.face) end
for _,id in ipairs(ids) do
local objects=loadAssetObjects(id)
if objects then for _,loadedRoot in ipairs(objects) do
pcall(attachClassicClothingLocal,loadedRoot,clone,id)
local accessories={}; if loadedRoot:IsA("Accessory") then table.insert(accessories,loadedRoot) else for _,object in ipairs(loadedRoot:GetDescendants()) do if object:IsA("Accessory") then table.insert(accessories,object:Clone()) end end end
for _,accessory in ipairs(accessories) do pcall(attachAccessoryLocal,accessory,clone,root,id) end
local isBody=table.find(option.bodyItems or {},id)~=nil or id==option.head
if isBody then pcall(attachBodyPartsLocal,loadedRoot,clone,id,option.headTexture) end
if loadedRoot.Parent and not table.find(state.visuals,loadedRoot) then pcall(function() loadedRoot:Destroy() end) end
end end
end
state.visuals,state.hidden,state.wearableConn=savedVisuals,savedHidden,savedWearable
if option.face and option.faceMode=="decal" then local head=clone:FindFirstChild("Head"); if head then local face=head:FindFirstChild("face") or head:FindFirstChildWhichIsA("Decal"); if not face then face=Instance.new("Decal"); face.Name="face"; face.Face=Enum.NormalId.Front; face.Parent=head end; face.Texture=resolveFaceTexture(option.face); face.Transparency=0 end end
if option.headless or option.hideOriginalHead then local head=clone:FindFirstChild("Head"); if head then head.Transparency=1; for _,v in ipairs(head:GetDescendants()) do if v:IsA("Decal") or v:IsA("Texture") then v.Transparency=1 end end end end
if option.hideRightLeg then for _,name in ipairs({"RightUpperLeg","RightLowerLeg","RightFoot","Right Leg"}) do local part=clone:FindFirstChild(name); if part then part.Transparency=1 end end end
return clone
end,
cleanup = function()
state.enabled = false
clearVisuals()
restoreOriginalDescription()
end,
}
]==]

function VX7A.load()
    if VX7A.mod then return VX7A.mod end
    if VX7A.loading or type(loadstring) ~= "function" then return nil end
    VX7A.loading = true
    local ok, fn = pcall(loadstring, VX7A.src)
    if ok and type(fn) == "function" then
        local ok2, res = pcall(fn)
        if ok2 and type(res) == "table" then VX7A.mod = res end
    end
    VX7A.loading = false
    return VX7A.mod
end

function VX7A.setLabel()
    if VX7A.label and VX7A.label.Parent then
        VX7A.label.Text = VX7A.labels[VX7A.index + 1] or "OFF"
    end
end

function VX7A.stop()
    VX7A.pending = nil
    if VX7A.index ~= 0 then
        VX7A.index = 0
        local m = VX7A.mod
        if m and m.remove then pcall(m.remove) end
    end
    VX7A.setLabel()
end

function VX7A.apply(index)
    index = math.clamp(math.floor(tonumber(index) or 0), 0, #VX7A.labels - 1)
    if index == 0 then VX7A.stop() return end
    local m = VX7A.load()
    if not m or type(m.apply) ~= "function" then
        warn("[Rival Hub] No se pudo cargar el modulo de avatares VX7 (loadstring no disponible).")
        VX7A.setLabel()
        return
    end
    if VX7A.busy then VX7A.pending = index; VX7A.index = index; VX7A.setLabel() return end
    if currentOutfitIndex ~= 1 then
        currentOutfitIndex = 1
        pcall(function() applyOutfitByIndex(1) end)
        if outfitSelectorLabel then outfitSelectorLabel.Text = OUTFITS[1].label end
    end
    VX7A.index = index
    VX7A.setLabel()
    VX7A.busy = true
    task.spawn(function()
        pcall(m.apply, index)
        VX7A.busy = false
        local nxt = VX7A.pending
        VX7A.pending = nil
        if nxt and nxt ~= 0 and VX7A.index == nxt then VX7A.apply(nxt) end
    end)
end

pcall(function()
    LP.CharacterAdded:Connect(function()
        if _G.RivalHubSession ~= _mySession or VX7A.index == 0 then return end
        task.delay(1.5, function()
            if _G.RivalHubSession == _mySession and VX7A.index ~= 0 then VX7A.apply(VX7A.index) end
        end)
    end)
end)
-- ===== fin VX7 Avatars =====

local function loadObjectsStd(id)
    local ok, res = pcall(function() return game:GetObjects("rbxassetid://" .. tostring(id)) end)
    if ok and typeof(res) == "table" and #res > 0 then return res end
    ok, res = pcall(function() return game:GetService("InsertService"):LoadAsset(id) end)
    if ok and res then return {res} end
    return nil
end
local function resolveBubbleTemplate(id, className, propertyName)
    local fallback = "rbxassetid://" .. tostring(id)
    local ok, objects = pcall(function() return game:GetObjects(fallback) end)
    if ok and objects and objects[1] then
        local item = objects[1]
        local obj = item:IsA(className) and item or item:FindFirstChildWhichIsA(className, true)
        if obj and obj[propertyName] and obj[propertyName] ~= "" then fallback = obj[propertyName] end
        for _, v in ipairs(objects) do pcall(function() v:Destroy() end) end
    end
    return fallback
end
local function addBubbleHair(char, assetId)
    local head = char and char:FindFirstChild("Head")
    if not head then return false end
    local objects = loadObjectsStd(assetId)
    if not objects or not objects[1] then return false end
    local source = objects[1]
    local accessory = source:IsA("Accessory") and source or source:FindFirstChildWhichIsA("Accessory", true)
    if not accessory then
        for _, v in ipairs(objects) do pcall(function() v:Destroy() end) end
        return false
    end
    local hair = accessory:Clone()
    hair.Name = "BubbleSkinChanger_Hair"
    for _, part in ipairs(hair:GetDescendants()) do
        if part:IsA("BasePart") then part.Anchored = false; part.CanCollide = false; part.Massless = true; part.LocalTransparencyModifier = 0 end
    end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local ok = pcall(function() if humanoid then humanoid:AddAccessory(hair) else hair.Parent = char end end)
    if not ok then pcall(function() hair:Destroy() end) end
    for _, v in ipairs(objects) do pcall(function() v:Destroy() end) end
    return ok
end
local function applyHeadlessKorblox(char)
    if not char then return end
    pcall(function() LP.CharacterAvatarType = Enum.AvatarType.R6 end)
    local head = char:FindFirstChild("Head")
    if head then
        if head:GetAttribute("RivalHubOutfitOriginalTransparency") == nil then
            head:SetAttribute("RivalHubOutfitOriginalTransparency", head.Transparency)
            head:SetAttribute("RivalHubOutfitOriginalLocalTransparency", head.LocalTransparencyModifier)
        end
        head.Transparency = 1
        head.CanCollide = false
        head.LocalTransparencyModifier = 1
        local face = head:FindFirstChild("face")
        if face then face.Transparency = 1 end
    end
    pcall(function()
        local neck = char:FindFirstChild("Neck")
        if neck then neck.Enabled = false end
    end)
    for _, v in pairs(char:GetChildren()) do
        if v:IsA("Accessory") then
            local w = v:FindFirstChildWhichIsA("Weld") or v:FindFirstChildWhichIsA("WeldConstraint") or v:FindFirstChildWhichIsA("Motor6D")
            if w then
                local p0, p1 = w.Part0, w.Part1
                if (p0 and p0.Name == "Head") or (p1 and p1.Name == "Head") then
                    for _, part in ipairs(v:GetDescendants()) do
                        if part:IsA("BasePart") then
                            if part:GetAttribute("RivalHubOutfitOriginalTransparency") == nil then
                                part:SetAttribute("RivalHubOutfitOriginalTransparency", part.Transparency)
                                part:SetAttribute("RivalHubOutfitOriginalLocalTransparency", part.LocalTransparencyModifier)
                            end
                            part.Transparency = 1
                            part.LocalTransparencyModifier = 1
                        end
                    end
                end
            end
        end
    end
    local rightLegConfig = { id = "rbxassetid://139607718", targetBodyPart = "RightUpperLeg", partsToHide = {"RightUpperLeg", "RightLowerLeg", "RightFoot"}, scale = _V3new(1, 1, 1), offset = _CFnew(0, 0, 0) }
    local targetPart = char:FindFirstChild(rightLegConfig.targetBodyPart)
    if targetPart then
        local oldAsset = char:FindFirstChild("Korblox_RightLeg")
        if oldAsset then oldAsset:Destroy() end
        for _, partName in ipairs(rightLegConfig.partsToHide) do
            local limb = char:FindFirstChild(partName)
            if limb and limb:IsA("BasePart") then
                if limb:GetAttribute("RivalHubOutfitOriginalTransparency") == nil then
                    limb:SetAttribute("RivalHubOutfitOriginalTransparency", limb.Transparency)
                end
                limb.Transparency = 1
            end
        end
        local success, objects = pcall(function() return game:GetObjects(rightLegConfig.id) end)
        if success and objects and #objects > 0 then
            local assetModel = objects[1]
            assetModel.Name = "Korblox_RightLeg"
            local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
            if mainMesh then
                mainMesh.Size = mainMesh.Size * rightLegConfig.scale
                mainMesh.CanCollide = false
                mainMesh.CFrame = targetPart.CFrame * rightLegConfig.offset
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = targetPart
                weld.Part1 = mainMesh
                weld.Parent = mainMesh
                assetModel.Parent = char
            end
        end
    end
end

function applyOutfitByIndex(index)
    local cfg = OUTFITS[index]
    if not cfg then return end
    local char = LP.Character
    if not char then return end
    clearPreviousOutfitAssets(char)
    for _, item in ipairs(char:GetChildren()) do
        if item:IsA("Accessory") and item.Name:sub(1, #TAG) ~= TAG then
            for _, part in ipairs(item:GetDescendants()) do
                if part:IsA("BasePart") then
                    if part:GetAttribute("RivalHubOriginalTransparency") == nil then
                        part:SetAttribute("RivalHubOriginalTransparency", part.Transparency)
                        part:SetAttribute("RivalHubOriginalLocalTransparency", part.LocalTransparencyModifier)
                    end
                    part.Transparency = 1
                    part.LocalTransparencyModifier = 1
                end
            end
        elseif item:IsA("Shirt") then
            if item:GetAttribute("RivalHubOriginalTemplate") == nil then item:SetAttribute("RivalHubOriginalTemplate", item.ShirtTemplate) end
            item.ShirtTemplate = ""
        elseif item:IsA("Pants") then
            if item:GetAttribute("RivalHubOriginalTemplate") == nil then item:SetAttribute("RivalHubOriginalTemplate", item.PantsTemplate) end
            item.PantsTemplate = ""
        elseif item:IsA("ShirtGraphic") then
            if item:GetAttribute("RivalHubOriginalGraphic") == nil then item:SetAttribute("RivalHubOriginalGraphic", item.Graphic) end
            item.Graphic = ""
        end
    end

    if cfg.customApply then
        cfg.customApply(char)
        if outfitSelectorLabel then outfitSelectorLabel.Text = cfg.label end
        return
    end
    if cfg.bubbleShirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "BubbleSkinChanger_Shirt"
        s.ShirtTemplate = resolveBubbleTemplate(cfg.bubbleShirt, "Shirt", "ShirtTemplate")
        s.Parent = char
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "BubbleSkinChanger_Pants"
        p.PantsTemplate = resolveBubbleTemplate(cfg.bubblePants, "Pants", "PantsTemplate")
        p.Parent = char
        addBubbleHair(char, cfg.bubbleHair)
        if outfitSelectorLabel then outfitSelectorLabel.Text = cfg.label end
        return
    end
    char:WaitForChild("Head", 5)
    local head = char:FindFirstChild("Head")
    if not head then return end
    for _, d in ipairs(char:GetChildren()) do
        if d:IsA("CharacterMesh") and d.BodyPart == Enum.BodyPart.Head then
            pcall(function() d:Destroy() end)
        end
    end
    local done = false
    if head:IsA("MeshPart") then
        done = pcall(function()
            if not head:GetAttribute("RivalHubOutfitModifiedMeshPart") then
                head:SetAttribute("RivalHubOutfitOriginalMeshId", head.MeshId)
                head:SetAttribute("RivalHubOutfitOriginalTextureId", head.TextureID)
                head:SetAttribute("RivalHubOutfitModifiedMeshPart", true)
            end
            head.MeshId = cfg.headMesh
            head.TextureID = cfg.headTexture or ""
        end)
    end
    if not done then
        local sm = head:FindFirstChildWhichIsA("SpecialMesh")
        if not sm then
            sm = Instance.new("SpecialMesh")
            sm:SetAttribute("RivalHubOutfitCreatedMesh", true)
        elseif not sm:GetAttribute("RivalHubOutfitModifiedMesh") then
            sm:SetAttribute("RivalHubOutfitOriginalMeshId", sm.MeshId)
            sm:SetAttribute("RivalHubOutfitOriginalTextureId", sm.TextureId)
            sm:SetAttribute("RivalHubOutfitModifiedMesh", true)
        end
        sm.Parent = head
        sm.MeshType = Enum.MeshType.FileMesh
        sm.MeshId = cfg.headMesh
        sm.TextureId = cfg.headTexture or ""
    end
    if cfg.shirt then
        local s = char:FindFirstChildWhichIsA("Shirt") or Instance.new("Shirt")
        s.Name = "Shirt"
        s.ShirtTemplate = cfg.shirt
        s.Parent = char
    end
    if cfg.pants then
        local p = char:FindFirstChildWhichIsA("Pants") or Instance.new("Pants")
        p.Name = "Pants"
        p.PantsTemplate = cfg.pants
        p.Parent = char
    end
    local old = char:FindFirstChild("AuFfitAccessory")
    if old then old:Destroy() end
    if cfg.accessory and head then
        local objs = loadObjectsStd(cfg.accessory)
        if objs then
            local handle
            for _, o in ipairs(objs) do
                if o:IsA("BasePart") then handle = o; break end
                local f = o:FindFirstChildWhichIsA("BasePart", true)
                if f then handle = f; break end
            end
            if handle then
                local h = handle:Clone()
                h.Name = "AuFfitAccessory"
                h.CanCollide = false
                h.Anchored = false
                h.Massless = true
                h.Parent = char
                local weld = Instance.new("Weld")
                weld.Part0 = head
                weld.Part1 = h
                weld.C0 = _CFnew(cfg.offset)
                weld.Parent = h
            end
            for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
        end
    end
    if cfg.headlessKorblox then
        applyHeadlessKorblox(char)
    else
        if char then
            local head2 = char:FindFirstChild("Head")
            if head2 then
                head2.Transparency = 0
                head2.CanCollide = true
                head2.LocalTransparencyModifier = 0
                local face2 = head2:FindFirstChild("face")
                if face2 then face2.Transparency = 0 end
            end
            pcall(function()
                local neck = char:FindFirstChild("Neck")
                if neck then neck.Enabled = true end
            end)
            for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
                local limb = char:FindFirstChild(partName)
                if limb then limb.Transparency = 0 end
            end
            local oldKorblox = char:FindFirstChild("Korblox_RightLeg")
            if oldKorblox then oldKorblox:Destroy() end
        end
    end
    if outfitSelectorLabel then outfitSelectorLabel.Text = cfg.label end
end


speedMode = false
antiRagdollMode = "off"
antiDieEnabled = false
antiBatEnabled = false
antiFlingEnabled = false
jumpEnabled = false
laggerToggled = false
laggerCarryToggled = false
medusaCounterEnabled = false
batCounterEnabled = false
unwalkEnabled = false
autoLeftEnabled = false
autoRightEnabled = false
autoBatEnabled = false
dropMode = 1
antiLagEnabled = false
removeAccessoriesEnabled = false
stretchEnabled = false
stretchFOV = 120
uiLocked = false
mobileButtonsLocked = false
uiScaleValue = 78
espEnabled = false
espLineEnabled = false

vividGraphicsEnabled = false
_vividEffects = {}
setVividVisual = nil

hideButtonsEnabled = false
setHideButtonsVisual = nil

bodyLockEnabled = false
bodyLockRange = 20
bodyLockRangeBox = nil
_bodyLockConn = nil
_blSuppressCount = 0
_blWasEnabled = false
_blRestoreTimer = nil
_blSmoothRestore = false

savedProgressBarPos = nil
savedButtonPositions = {}
savedMobilePanelPos = nil

neonWeatherEnabled = false
skyTheme = "Off"
skySelectorLabel = nil
_originalLighting = nil
setNeonWeatherVisual = nil

currentAnimPack = "Off"
originalTryardAnims = nil
tryardHeartbeatConn = nil
animSelectorLabel = nil

lastMoveDir = _V3zero

local CoreGui = game:GetService("CoreGui")

--=========================================================
--  Infinite Jump (lógica portada de Clean Anti Bat)
--  PreSimulation + IsKeyDown(Space/ButtonA) + hum.Jump
--=========================================================
local InfiniteJump = {
    enabled = false,
    mode = "hold",
    jumpPower = 55,
    minVelocity = 35,
    fallClamp = -120,
    jumpConn = nil,
    heartbeatConn = nil,
    presimConn = nil,
}

local function applyInfJumpBoost(root)
    if not root then return end
    local velocity = root.AssemblyLinearVelocity
    if velocity.Y < InfiniteJump.minVelocity then
        root.AssemblyLinearVelocity = _V3new(velocity.X, InfiniteJump.jumpPower, velocity.Z)
    end
    if velocity.Y < InfiniteJump.fallClamp then
        root.AssemblyLinearVelocity = _V3new(velocity.X, InfiniteJump.fallClamp, velocity.Z)
    end
end

local function onJumpRequest()
    if not InfiniteJump.enabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then
        pcall(function()
            root.AssemblyLinearVelocity = _V3new(
                root.AssemblyLinearVelocity.X,
                InfiniteJump.jumpPower,
                root.AssemblyLinearVelocity.Z
            )
        end)
    end
end

local function onPreSimulation()
    if not InfiniteJump.enabled then return end
    if InfiniteJump.mode ~= "hold" then return end
    local char = LP.Character
    if not char then return end
    local hum  = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return end

    local held = UIS:IsKeyDown(Enum.KeyCode.Space)
        or UIS:IsKeyDown(Enum.KeyCode.ButtonA)
        or (hum.Jump == true)

    if held then
        applyInfJumpBoost(root)
    else
        local v = root.AssemblyLinearVelocity
        if v.Y < InfiniteJump.fallClamp then
            root.AssemblyLinearVelocity = _V3new(v.X, InfiniteJump.fallClamp, v.Z)
        end
    end
end

local function connectEvents()
    if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect() end
    if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect() end
    if InfiniteJump.presimConn then InfiniteJump.presimConn:Disconnect() end
    InfiniteJump.jumpConn = UIS.JumpRequest:Connect(onJumpRequest)
    InfiniteJump.presimConn = RunService.PreSimulation:Connect(onPreSimulation)
end

function InfiniteJump.start()
    if InfiniteJump.enabled then return end
    InfiniteJump.enabled = true
    connectEvents()
end

function InfiniteJump.stop()
    InfiniteJump.enabled = false
    if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect(); InfiniteJump.jumpConn = nil end
    if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect(); InfiniteJump.heartbeatConn = nil end
    if InfiniteJump.presimConn then InfiniteJump.presimConn:Disconnect(); InfiniteJump.presimConn = nil end
end

function InfiniteJump.setJumpPower(power)
    power = tonumber(power) or 55
    InfiniteJump.jumpPower = _clamp(power, 10, 200)
end

function InfiniteJump.setMode(mode)
    InfiniteJump.mode = mode == "manual" and "manual" or "hold"
end

function InfiniteJump.isRunning() return InfiniteJump.enabled == true end

InfiniteJump.stop()

function getActiveMoveSpeed()
    if laggerCarryToggled then return LAGGER_CARRY_SPEED
    elseif laggerToggled then return LAGGER_SPEED
    elseif speedMode then return CS
    else return NS end
end

function getSpeedModeName()
    if laggerToggled or laggerCarryToggled then return "LAGGER"
    elseif speedMode then return "CARRY"
    else return "NORMAL" end
end

local _s2VelState = _G.__RivalHubSpeedHookState
if type(_s2VelState) ~= "table" then
    _s2VelState = {
        hooked = false,
        velChecked = setmetatable({}, { __mode = "k" }),
        root = nil,
        v = _V3zero,
    }
    _G.__RivalHubSpeedHookState = _s2VelState
end
local _velChecked = _s2VelState.velChecked
local _hookedVelParts = {}

local _hookVelSupported = nil
local function _hookVelHRP(hrp)
    if not hrp then return end
    _s2VelState.root = hrp
    _velChecked[hrp] = true
    if _s2VelState.hooked then return end
    if type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function"
       or type(newcclosure) ~= "function" or type(checkcaller) ~= "function" then
        return
    end
    local ok = pcall(function()
        local mt = getrawmetatable(game)
        if not mt then return end

        setreadonly(mt, false)

        local originalIndex = rawget(mt, "__index")
        local originalNewIndex = rawget(mt, "__newindex")

        local function isOurRoot(t, k)
            local tk = tostring(k)
            if tk ~= "AssemblyLinearVelocity" and tk ~= "Velocity" then return false end
            if typeof(t) ~= "Instance" or not t:IsA("BasePart") then return false end
            local tn = t.Name
            if tn ~= "HumanoidRootPart" and tn ~= "Torso" and tn ~= "UpperTorso" then return false end
            local char = LP.Character
            return char ~= nil and t:IsDescendantOf(char)
        end

        if type(originalIndex) == "function" or type(originalIndex) == "table" then
            local replacementIndex = newcclosure(function(self, key)
                if not checkcaller() then
                    local good, mine = pcall(isOurRoot, self, key)
                    if good and mine then return _s2VelState.v end
                end
                if type(originalIndex) == "function" then
                    return originalIndex(self, key)
                else
                    return originalIndex[key]
                end
            end)
            mt.__index = replacementIndex
        end

        if type(originalNewIndex) == "function" then
            local replacementNewIndex = newcclosure(function(self, key, value)
                if not checkcaller() then
                    local good, mine = pcall(isOurRoot, self, key)
                    if good and mine then
                        _s2VelState.v = value
                        return
                    end
                end
                return originalNewIndex(self, key, value)
            end)
            mt.__newindex = replacementNewIndex
        end

        setreadonly(mt, true)
        _s2VelState.hooked = true
    end)
    if not ok then _s2VelState.hooked = false end
end

local function _setupVelChecked(char)
    _velChecked = setmetatable({}, { __mode = "k" })
    _s2VelState.velChecked = _velChecked
    if not char then _s2VelState.root = nil; return nil end
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if hrp then
        _s2VelState.root = hrp
        _velChecked[hrp] = true
    end
    return hrp
end

if LP.Character then
    local _hrp0 = _setupVelChecked(LP.Character)
    _hookVelHRP(_hrp0)
end

local function _isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand
        or st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll
        or st == Enum.HumanoidStateType.FallingDown
end

local function _applyVelocitySpeed(dir, speed, hrp)
    if not hrp or not hrp.Parent then return end
    if autoBatEnabled then return end
    if type(speed) ~= "number" or speed ~= speed or speed <= 0 or speed == math.huge then return end

    local verticalVelocity = hrp.AssemblyLinearVelocity.Y
    if _G._ZurichHub_MovementBlocked == true or _G._CrystalHub_MovementBlocked == true then
        hrp.AssemblyLinearVelocity = _V3new(0, math.min(verticalVelocity, 0), 0)
        return
    end

    if dir and dir.Magnitude > 0.05 then
        pcall(function()
            if hrp.SetNetworkOwner then hrp:SetNetworkOwner(LP) end
        end)
        local unit = dir.Unit
        hrp.AssemblyLinearVelocity = _V3new(unit.X * speed, verticalVelocity, unit.Z * speed)
        local visibleSpeed = math.min(speed, 20)
        _s2VelState.v = _V3new(unit.X * visibleSpeed, verticalVelocity, unit.Z * visibleSpeed)
        _G.__RivalHubLiveSpeed = { t = os.clock(), v = speed }
    else
        _s2VelState.v = _V3new(0, verticalVelocity, 0)
        hrp.AssemblyLinearVelocity = _V3new(0, verticalVelocity, 0)
    end
end

function getAutoPathSpeed()
    if laggerCarryToggled or laggerToggled then return LAGGER_SPEED end
    return NS
end

ANIM_PACKS = {
    ["Zombie"] = { idle1="rbxassetid://616158929", idle2="rbxassetid://616160636", walk="rbxassetid://616168032", run="rbxassetid://616163682", jump="rbxassetid://616161997", fall="rbxassetid://616157476", climb="rbxassetid://616156119", swim="rbxassetid://616165109", swimidle="rbxassetid://616166655" },
    ["Ninja"] = { idle1="rbxassetid://656117400", idle2="rbxassetid://656117400", walk="rbxassetid://656121766", run="rbxassetid://656118852", jump="rbxassetid://656117878", fall="rbxassetid://656115606", climb="rbxassetid://656114359", swim="rbxassetid://656117400", swimidle="rbxassetid://656117400" },
    ["Knight"] = { idle1="rbxassetid://657595757", idle2="rbxassetid://657595757", walk="rbxassetid://657552124", run="rbxassetid://657564596", jump="rbxassetid://658409194", fall="rbxassetid://657600338", climb="rbxassetid://658360781", swim="rbxassetid://657595757", swimidle="rbxassetid://657595757" },
    ["Elder"] = { idle1="rbxassetid://845397899", idle2="rbxassetid://845397899", walk="rbxassetid://845403856", run="rbxassetid://845386501", jump="rbxassetid://845398858", fall="rbxassetid://845397673", climb="rbxassetid://845392038", swim="rbxassetid://845397899", swimidle="rbxassetid://845397899" },
    ["Levitate"] = { idle1="rbxassetid://616006778", idle2="rbxassetid://616006778", walk="rbxassetid://616013216", run="rbxassetid://616013216", jump="rbxassetid://616008936", fall="rbxassetid://616005863", climb="rbxassetid://616003713", swim="rbxassetid://616006778", swimidle="rbxassetid://616006778" },
    ["Astronaut"] = { idle1="rbxassetid://891621366", idle2="rbxassetid://891621366", walk="rbxassetid://891636393", run="rbxassetid://891636393", jump="rbxassetid://891627522", fall="rbxassetid://891617961", climb="rbxassetid://891609353", swim="rbxassetid://891621366", swimidle="rbxassetid://891621366" },
    ["Pirate"] = { idle1="rbxassetid://750781874", idle2="rbxassetid://750781874", walk="rbxassetid://750785693", run="rbxassetid://750783738", jump="rbxassetid://750782230", fall="rbxassetid://750780242", climb="rbxassetid://750779899", swim="rbxassetid://750781874", swimidle="rbxassetid://750781874" },
    ["Toy"] = { idle1="rbxassetid://782841498", idle2="rbxassetid://782841498", walk="rbxassetid://782843345", run="rbxassetid://782842708", jump="rbxassetid://782847020", fall="rbxassetid://782846423", climb="rbxassetid://782843869", swim="rbxassetid://782841498", swimidle="rbxassetid://782841498" },
    ["Vampire"] = { idle1="rbxassetid://1083445855", idle2="rbxassetid://1083445855", walk="rbxassetid://1083473930", run="rbxassetid://1083462077", jump="rbxassetid://1083455352", fall="rbxassetid://1083443587", climb="rbxassetid://1083439238", swim="rbxassetid://1083445855", swimidle="rbxassetid://1083445855" },
    ["Werewolf"] = { idle1="rbxassetid://1083195517", idle2="rbxassetid://1083195517", walk="rbxassetid://1083178339", run="rbxassetid://1083216690", jump="rbxassetid://1083218792", fall="rbxassetid://1083189019", climb="rbxassetid://1083182000", swim="rbxassetid://1083195517", swimidle="rbxassetid://1083195517" },
    ["Rthro"] = { idle1="rbxassetid://2510196951", idle2="rbxassetid://2510196951", walk="rbxassetid://2510202577", run="rbxassetid://2510198475", jump="rbxassetid://2510197830", fall="rbxassetid://2510195892", climb="rbxassetid://2510192778", swim="rbxassetid://2510196951", swimidle="rbxassetid://2510196951" },
    ["Stylish"] = { idle1="rbxassetid://616136790", idle2="rbxassetid://616136790", walk="rbxassetid://616146177", run="rbxassetid://616140816", jump="rbxassetid://616139451", fall="rbxassetid://616134815", climb="rbxassetid://616133594", swim="rbxassetid://616136790", swimidle="rbxassetid://616136790" },
}

ANIM_PACK_ORDER = {{"Off", "Off"}, {"Zombie", "Zombie"}, {"Ninja", "Ninja"}, {"Knight", "Knight"}, {"Elder", "Elder"}, {"Levitate", "Levitate"}, {"Astronaut", "Astronaut"}, {"Pirate", "Pirate"}, {"Toy", "Toy"}, {"Vampire", "Vampire"}, {"Werewolf", "Werewolf"}, {"Rthro", "Rthro"}, {"Stylish", "Stylish"}}

local function isPackAnim(id)
    for _, pack in pairs(ANIM_PACKS) do
        for _, v in pairs(pack) do
            if v == id then return true end
        end
    end
    return false
end

local function saveOriginalAnims(char)
    local animate = char:FindFirstChild("Animate")
    if not animate then return end
    local function g(obj) return obj and obj.AnimationId or nil end
    local ids = {
        idle1 = g(animate.idle and animate.idle.Animation1),
        idle2 = g(animate.idle and animate.idle.Animation2),
        walk  = g(animate.walk and animate.walk.WalkAnim),
        run   = g(animate.run  and animate.run.RunAnim),
        jump  = g(animate.jump and animate.jump.JumpAnim),
        fall  = g(animate.fall and animate.fall.FallAnim),
        climb = g(animate.climb and animate.climb.ClimbAnim),
        swim  = g(animate.swim and animate.swim.Swim),
        swimidle = g(animate.swimidle and animate.swimidle.SwimIdle),
    }
    if not isPackAnim(ids.walk) then originalTryardAnims = ids end
end

local function applyAnimPack(packName)
    currentAnimPack = packName
    if animSelectorLabel then animSelectorLabel.Text = packName end
    if packName == "Off" then
        if originalTryardAnims and LP.Character then
            local animate = LP.Character:FindFirstChild("Animate")
            if animate then
                local function s(obj,id) if obj then obj.AnimationId = id end end
                s(animate.idle and animate.idle.Animation1, originalTryardAnims.idle1)
                s(animate.idle and animate.idle.Animation2, originalTryardAnims.idle2)
                s(animate.walk and animate.walk.WalkAnim, originalTryardAnims.walk)
                s(animate.run  and animate.run.RunAnim,   originalTryardAnims.run)
                s(animate.jump and animate.jump.JumpAnim, originalTryardAnims.jump)
                s(animate.fall and animate.fall.FallAnim, originalTryardAnims.fall)
                s(animate.climb and animate.climb.ClimbAnim, originalTryardAnims.climb)
                s(animate.swim and animate.swim.Swim, originalTryardAnims.swim)
                s(animate.swimidle and animate.swimidle.SwimIdle, originalTryardAnims.swimidle)
            end
        end
        if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect(); tryardHeartbeatConn = nil end
        return
    end
    local pack = ANIM_PACKS[packName]
    if not pack then return end
    if tryardHeartbeatConn then tryardHeartbeatConn:Disconnect() end
    tryardHeartbeatConn = RunService.Heartbeat:Connect(function()
        local c = LP.Character
        if not c then return end
        local animate = c:FindFirstChild("Animate")
        if not animate then return end
        local function s(obj,id) if obj then obj.AnimationId = id end end
        s(animate.idle and animate.idle.Animation1, pack.idle1)
        s(animate.idle and animate.idle.Animation2, pack.idle2)
        s(animate.walk and animate.walk.WalkAnim, pack.walk)
        s(animate.run  and animate.run.RunAnim,   pack.run)
        s(animate.jump and animate.jump.JumpAnim, pack.jump)
        s(animate.fall and animate.fall.FallAnim, pack.fall)
        s(animate.climb and animate.climb.ClimbAnim, pack.climb)
        s(animate.swim and animate.swim.Swim, pack.swim)
        s(animate.swimidle and animate.swimidle.SwimIdle, pack.swimidle)
    end)
end

local function startAnimPack(packName)
    local char = LP.Character
    if char then
        saveOriginalAnims(char)
        applyAnimPack(packName)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            for _, track in ipairs(hum:GetPlayingAnimationTracks()) do track:Stop(0) end
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end
    else
        applyAnimPack(packName)
    end
    currentAnimPack = packName
end

local function stopAnimPack()
    currentAnimPack = "Off"
    if animSelectorLabel then animSelectorLabel.Text = "Off" end
    applyAnimPack("Off")
end

DEFAULT_KB = {
    DropBrainrot = {kb = Enum.KeyCode.X, gp = nil},
    AutoLeft     = {kb = Enum.KeyCode.Z, gp = nil},
    AutoRight    = {kb = Enum.KeyCode.C, gp = nil},
    AutoBat      = {kb = Enum.KeyCode.E, gp = nil},
    TPFloor      = {kb = Enum.KeyCode.F, gp = nil},
    GuiHide      = {kb = Enum.KeyCode.LeftControl, gp = nil},
    CarryToggle  = {kb = Enum.KeyCode.Q, gp = nil},
    LaggerMode   = {kb = Enum.KeyCode.R, gp = nil},
    BatV2        = {kb = Enum.KeyCode.V, gp = nil},
}

KB = {
    DropBrainrot = {kb = DEFAULT_KB.DropBrainrot.kb, gp = DEFAULT_KB.DropBrainrot.gp},
    AutoLeft     = {kb = DEFAULT_KB.AutoLeft.kb, gp = DEFAULT_KB.AutoLeft.gp},
    AutoRight    = {kb = DEFAULT_KB.AutoRight.kb, gp = DEFAULT_KB.AutoRight.gp},
    AutoBat      = {kb = DEFAULT_KB.AutoBat.kb, gp = DEFAULT_KB.AutoBat.gp},
    TPFloor      = {kb = DEFAULT_KB.TPFloor.kb, gp = DEFAULT_KB.TPFloor.gp},
    GuiHide      = {kb = DEFAULT_KB.GuiHide.kb, gp = DEFAULT_KB.GuiHide.gp},
    CarryToggle  = {kb = DEFAULT_KB.CarryToggle.kb, gp = DEFAULT_KB.CarryToggle.gp},
    LaggerMode   = {kb = DEFAULT_KB.LaggerMode.kb, gp = DEFAULT_KB.LaggerMode.gp},
    BatV2        = {kb = DEFAULT_KB.BatV2.kb, gp = DEFAULT_KB.BatV2.gp},
}

_isResetting = false
_lastSavedJSON = nil
_isLoading = false

CONFIG = {
    AUTO_STEAL_ENABLED = false,
    STEAL_RANGE = 65,
    HOLD_MIN = 0.05,
    HOLD_MAX = 0.15,
    ENTRY_DELAY = 0.1,
    COOLDOWN = 0.2,
    PRIME_RANGE = 60,
}

local plots = workspace:WaitForChild("Plots")
local stealConnection = nil

local Steal = {
    AutoStealEnabled = false,
    StealRadius = CONFIG.STEAL_RANGE,
    StealDuration = 1.3,
    StealDelay = 0.25,
    Data = {}
}

local isStealing = false
local autoStealMode = "V1"
local autoGrabSetDelayRadius = 9
local autoGrabStopTime = 0.96
local autoGrabStopEnabled = true

local _plotsCache = nil
local _plotsCacheTime = 0
local function getPlotsRoot()
    local now = _tick()
    if _plotsCache and now - _plotsCacheTime < 2 and _plotsCache.Parent then
        return _plotsCache
    end
    _plotsCache = workspace:FindFirstChild("Plots")
    _plotsCacheTime = now
    return _plotsCache
end

local function isMyPlotByName(plotName)
    local plotsRoot = getPlotsRoot()
    if not plotsRoot then return false end
    local plot = plotsRoot:FindFirstChild(plotName)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yb = sign:FindFirstChild("YourBase")
        if yb and yb:IsA("BillboardGui") then
            return yb.Enabled == true
        end
    end
    return false
end

local function findNearestPrompt()
    local char = LP.Character
    if not char then return nil, nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil, nil end
    local plotsRoot = getPlotsRoot()
    if not plotsRoot then return nil, nil end
    local nearestPrompt, nearestDist, nearestName = nil, _huge, nil
    local rpos = root.Position
    for _, plot in ipairs(plotsRoot:GetChildren()) do
        if isMyPlotByName(plot.Name) then continue end
        local pods = plot:FindFirstChild("AnimalPodiums")
        if not pods then continue end
        for _, pod in ipairs(pods:GetChildren()) do
            pcall(function()
                local base = pod:FindFirstChild("Base")
                local spawn = base and base:FindFirstChild("Spawn")
                if spawn then
                    local sp = spawn.Position
                    local dx = sp.X - rpos.X
                    local dy = sp.Y - rpos.Y
                    local dz = sp.Z - rpos.Z
                    local dist = _sqrt(dx*dx + dy*dy + dz*dz)
                    if dist < nearestDist and dist <= Steal.StealRadius then
                        local att = spawn:FindFirstChild("PromptAttachment")
                        if att then
                            for _, child in ipairs(att:GetChildren()) do
                                if child:IsA("ProximityPrompt") and child.ActionText and child.ActionText:find("Steal") then
                                    nearestPrompt = child
                                    nearestDist = dist
                                    nearestName = pod.Name
                                    break
                                end
                            end
                        end
                    end
                end
            end)
        end
    end
    return nearestPrompt, nearestName
end

local function executeSteal(prompt, podName)
    if isStealing then return end

    if math.random(30) == 1 then
        for p in pairs(Steal.Data) do
            if not p.Parent then Steal.Data[p] = nil end
        end
    end

    if not Steal.Data[prompt] then
        Steal.Data[prompt] = { hold = {}, trigger = {}, ready = true }
        pcall(function()
            if getconnections then
                for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                    if c.Function then table.insert(Steal.Data[prompt].hold, c.Function) end
                end
                for _, c in ipairs(getconnections(prompt.Triggered)) do
                    if c.Function then table.insert(Steal.Data[prompt].trigger, c.Function) end
                end
            end
        end)
    end

    local data = Steal.Data[prompt]
    if not data.ready then return end
    data.ready = false
    isStealing = true

    updateStealProgress(0, "STEALING")

    task.spawn(function()
        for _, f in ipairs(data.hold) do task.spawn(f) end

        local startTime = _tick()
        local duration = Steal.StealDuration
        local promptFired = false

        if autoGrabStopEnabled then
            while isStealing and Steal.AutoStealEnabled do
                local elapsed = _tick() - startTime
                if elapsed >= autoGrabStopTime then break end
                local progress = _clamp(elapsed / duration, 0, 1)
                updateStealProgress(progress, "STEALING")
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then
                    break
                end
                task.wait()
            end

            local stopProgress = _clamp(autoGrabStopTime / duration, 0, 1)
            updateStealProgress(stopProgress, "STEALING")

            local phase2Timeout = math.max(2.99 - autoGrabStopTime - math.max(duration - autoGrabStopTime, 0), 0.05)
            local phase2Start = _tick()

            while isStealing and Steal.AutoStealEnabled do
                if _tick() - phase2Start >= phase2Timeout then
                    updateStealProgress(0, "CANCELLED")
                    data.ready = true
                    isStealing = false
                    task.wait()
                    local newPrompt, newName = findNearestPrompt()
                    if newPrompt then executeSteal(newPrompt, newName) end
                    return
                end
                if not prompt.Parent or not prompt.Parent.Parent then
                    isStealing = false
                    updateStealProgress(0, "CANCELLED")
                    data.ready = true
                    return
                end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local dist = (hrp.Position - prompt.Parent.Parent.Position).Magnitude
                    if dist <= autoGrabSetDelayRadius then
                        break
                    elseif dist > Steal.StealRadius then
                        isStealing = false
                        updateStealProgress(0, "CANCELLED")
                        data.ready = true
                        return
                    end
                end
                task.wait()
            end

            if isStealing and Steal.AutoStealEnabled then
                local fillStart = _tick()
                local fillDuration = math.max(duration - autoGrabStopTime, 0.05)
                while true do
                    local fp = _clamp((_tick() - fillStart) / fillDuration, 0, 1)
                    local totalProgress = stopProgress + fp * (1 - stopProgress)
                    updateStealProgress(totalProgress, "STEALING")
                    if fp >= 1 and not promptFired then
                        promptFired = true
                        pcall(function()
                            for _, f in ipairs(data.trigger) do task.spawn(f) end
                            local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                            if remote and podName then remote:FireServer(podName) end
                            if prompt then prompt:Fire() end
                        end)
                        break
                    end
                    task.wait()
                end
            end
        else
            while isStealing and Steal.AutoStealEnabled do
                local elapsed = _tick() - startTime
                local progress = _clamp(elapsed / duration, 0, 1)
                updateStealProgress(progress, "STEALING")
                if not prompt.Parent or not prompt.Parent.Parent then break end
                local char = LP.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then break end
                if elapsed >= duration and not promptFired then
                    promptFired = true
                    pcall(function()
                        for _, f in ipairs(data.trigger) do task.spawn(f) end
                        local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
                        if remote and podName then remote:FireServer(podName) end
                        if prompt then prompt:Fire() end
                    end)
                    break
                end
                task.wait()
            end
        end

        updateStealProgress(0, "READY")
        data.ready = true
        isStealing = false
    end)
end

function startAutoSteal()
    if stealConnection then
        local connected = false
        pcall(function() connected = stealConnection.Connected == true end)
        if connected then
            Steal.StealRadius = CONFIG.STEAL_RANGE
            Steal.AutoStealEnabled = true
            CONFIG.AUTO_STEAL_ENABLED = true
            return true
        end
        pcall(function() stealConnection:Disconnect() end)
        stealConnection = nil
    end
    Steal.StealRadius = CONFIG.STEAL_RANGE
    Steal.AutoStealEnabled = true
    CONFIG.AUTO_STEAL_ENABLED = true
    local v2Accumulator = 0
    stealConnection = RunService.Heartbeat:Connect(function(dt)
        if not Steal.AutoStealEnabled or isStealing then return end
        if autoStealMode == "V2" then
            v2Accumulator = v2Accumulator + (dt or 0)
            if v2Accumulator < 0.25 then return end
            v2Accumulator = 0
        end
        local p, n = findNearestPrompt()
        if p then executeSteal(p, n) end
    end)
    return true
end

function stopAutoSteal()
    if stealConnection then
        stealConnection:Disconnect()
        stealConnection = nil
    end
    isStealing = false
    Steal.AutoStealEnabled = false
    CONFIG.AUTO_STEAL_ENABLED = false
    updateStealProgress(0, "READY")
end

medusaDebounce = false
medusaLastUsed = 0
dropActive = false
lastDropTime = 0
lastMoveDir = _V3new(0,0,0)
origFOV = nil
fovEnabled = false
fovValue = 70
customFovConn = nil

_anyKeyListening = false
_aimbotConn = nil
_prevAutoRotate = nil
tpBatConn = nil
tpBatPrevAutoRotate = nil
tpBatHitCD = false
TP_BAT_SWING_CD = 0.08

enemySpeedConn = nil
movementLoop = nil
steppedConn = nil
alConn = nil
arConn = nil
infJumpConn = nil
stretchConn = nil
stretchFovConn = nil
antiLagDescConn = nil
medusaResetConns = {}
dropConnections = {}
enemySpeedLabels = {}
Conns = {autoSteal = nil, batCounter = nil, anchor = {}, progress = nil, autoLeft = nil, autoRight = nil}
keyButtonRefs = {}
progressFill = nil
progressPct = nil
progressStatus = nil
progressTween = nil
pbFrame = nil
speedLabel = nil
modeValLbl = nil
normalBox, carryBox, laggerBox, lagger2Box, radInput, batSpeedBox, uiScaleBox = nil, nil, nil, nil, nil, nil, nil
modeSelectBtn, dropModeBtnRef = nil, nil
autoBatSetVisual, autoLeftSetVisual, autoRightSetVisual, setBatCounterVisual, setMedusaVisual = nil, nil, nil, nil, nil
setAntiRagVisual, setUnwalkVisual, setAntiLagVisual, setLockUIVisual, setInstaGrab = nil, nil, nil, nil, nil
infJumpSetVisual = nil
infJumpModeBtn = nil
autoStealModeBtn = nil
setAntiDieVisual = nil
setAntiBatVisual = nil
setAntiFlingVisual = nil
setESPVIsual = nil
setESPLineVisual = nil
mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight, mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2, mobSetBatV2 = nil, nil, nil, nil, nil, nil, nil, nil, nil
miniBtn, main, gui = nil, nil, nil
MobilePanel = nil
showGui = nil
hideGui = nil
mainUIScale = nil
animSelectorLabel = nil
pbScale = nil
tabButtons = nil
colorSelectorLabel = nil

GAMEPAD_KEYS = {
    [Enum.KeyCode.ButtonA] = true, [Enum.KeyCode.ButtonB] = true,
    [Enum.KeyCode.ButtonX] = true, [Enum.KeyCode.ButtonY] = true,
    [Enum.KeyCode.ButtonL1] = true, [Enum.KeyCode.ButtonR1] = true,
    [Enum.KeyCode.ButtonL2] = true, [Enum.KeyCode.ButtonR2] = true,
    [Enum.KeyCode.ButtonL3] = true, [Enum.KeyCode.ButtonR3] = true,
    [Enum.KeyCode.ButtonStart] = true, [Enum.KeyCode.ButtonSelect] = true,
    [Enum.KeyCode.DPadUp] = true, [Enum.KeyCode.DPadDown] = true,
    [Enum.KeyCode.DPadLeft] = true, [Enum.KeyCode.DPadRight] = true,
}

MOVE_KEYS = {
    [Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true,
    [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
    [Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true,
    [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true,
}

BAT_COUNTER_SLAP_LIST = {
    "Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap",
    "Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap",
    "Nuclear Slap", "Galaxy Slap", "Glitched Slap"
}

AP = {
    L1 = _V3new(-476.48, -6.28, 92.73),
    L2 = _V3new(-483.12, -4.95, 94.80),
    L_FACE = _V3new(-482.25, -4.96, 92.09),
    R1 = _V3new(-476.16, -6.52, 25.62),
    R2 = _V3new(-483.06, -5.03, 25.48),
    R_FACE = _V3new(-482.06, -6.93, 35.47),
}

function isGamepadInput(inp)
    return inp and inp.UserInputType and inp.UserInputType.Name:match("^Gamepad") ~= nil
end

function isBindableInput(inp)
    if not inp or inp.KeyCode == Enum.KeyCode.Unknown then return false end
    if inp.UserInputType == Enum.UserInputType.Keyboard then return true end
    return isGamepadInput(inp) and GAMEPAD_KEYS[inp.KeyCode] == true
end

function kbMatch(entry, kc)
    return kc and (kc == entry.kb or (entry.gp and kc == entry.gp))
end

function updateStealProgress(value, state)
    value = _clamp(tonumber(value) or 0, 0, 1)
    state = state or (value > 0 and "STEALING" or "READY")

    if progressTween then pcall(function() progressTween:Cancel() end) end
    if progressFill then
        local target = UDim2.new(value, 0, 1, 0)
        progressTween = TS:Create(progressFill, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = target})
        progressTween:Play()
        if state == "STEALING" then
            progressFill.BackgroundColor3 = Color3.fromRGB(0, 110, 255)
        elseif state == "COMPLETE" then
            progressFill.BackgroundColor3 = Color3.fromRGB(220, 230, 240)
        elseif state == "CANCELLED" then
            progressFill.BackgroundColor3 = Color3.fromRGB(105, 110, 125)
        else
            progressFill.BackgroundColor3 = Color3.fromRGB(0, 110, 255)
        end
    end
    if progressPct then progressPct.Text = _floor(value * 100 + 0.5) .. "%" end
    if progressStatus then
        progressStatus.Text = state
        if state == "STEALING" then
            progressStatus.TextColor3 = Color3.fromRGB(90, 160, 255)
        elseif state == "COMPLETE" then
            progressStatus.TextColor3 = Color3.fromRGB(220, 230, 240)
        elseif state == "CANCELLED" then
            progressStatus.TextColor3 = Color3.fromRGB(165, 170, 185)
        else
            progressStatus.TextColor3 = Color3.fromRGB(190, 200, 215)
        end
    end
end

function resetProgressBar()
    updateStealProgress(0, "READY")
end

local function doTpDown()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local _, yaw = root.CFrame:ToEulerAnglesYXZ()
        root.CFrame = _CFnew(root.Position.X, -7, root.Position.Z) * CFrame.Angles(0, yaw, 0)
        root.AssemblyLinearVelocity = _V3zero
        root.AssemblyAngularVelocity = _V3zero
    end)
end

_G._VynxRunTPDown = doTpDown
_G._VynxTPDownIsAutoOn = function() return false end

local AntiRagdollV1 = {}
AntiRagdollV1.__index = AntiRagdollV1

local BOOST_SPEED = 400
local AR_DEFAULT_SPEED = 16

local stateV1 = {
    active = false,
    isBoosting = false,
    cachedChar = nil,
    ragdollConnections = {},
}

local function disconnectAllV1()
    for _, conn in ipairs(stateV1.ragdollConnections) do
        pcall(function() conn:Disconnect() end)
    end
    stateV1.ragdollConnections = {}
end

local function cacheCharacterV1()
    local char = LP.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return false end
    stateV1.cachedChar = { character = char, humanoid = hum, root = root }
    return true
end

local function isRagdolledV1()
    if not stateV1.cachedChar or not stateV1.cachedChar.humanoid then return false end
    local hum = stateV1.cachedChar.humanoid
    local st = hum:GetState()
    local ragdollStates = {
        [Enum.HumanoidStateType.Physics] = true,
        [Enum.HumanoidStateType.Ragdoll] = true,
        [Enum.HumanoidStateType.FallingDown] = true,
    }
    return ragdollStates[st] or false
end

local function forceExitRagdollV1()
    if not stateV1.cachedChar or not stateV1.cachedChar.humanoid or not stateV1.cachedChar.root then return end
    local hum = stateV1.cachedChar.humanoid
    local root = stateV1.cachedChar.root
    pcall(function()
        LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow())
    end)
    for _, descendant in ipairs(stateV1.cachedChar.character:GetDescendants()) do
        if descendant:IsA("BallSocketConstraint") or
           (descendant:IsA("Attachment") and descendant.Name:find("RagdollAttachment")) then
            descendant:Destroy()
        end
    end
    if not stateV1.isBoosting then
        stateV1.isBoosting = true
        hum.WalkSpeed = BOOST_SPEED
    end
    if hum.Health > 0 then
        hum:ChangeState(Enum.HumanoidStateType.Running)
    end
    root.Anchored = false
end

local function heartbeatLoopV1()
    while stateV1.active do
        task.wait()
        if isRagdolledV1() then
            forceExitRagdollV1()
        elseif stateV1.isBoosting and not isRagdolledV1() then
            stateV1.isBoosting = false
            if stateV1.cachedChar and stateV1.cachedChar.humanoid then
                stateV1.cachedChar.humanoid.WalkSpeed = AR_DEFAULT_SPEED
            end
        end
    end
end

function AntiRagdollV1.start()
    if stateV1.active then return end
    AntiRagdollV1.stop()
    if not cacheCharacterV1() then
        warn("[AntiRagdollV1] No se pudo cachear el personaje")
        return
    end
    stateV1.active = true
    stateV1.isBoosting = false
    local camConn = RunService.RenderStepped:Connect(function()
        local cam = workspace.CurrentCamera
        if cam and stateV1.cachedChar and stateV1.cachedChar.humanoid then
            cam.CameraSubject = stateV1.cachedChar.humanoid
        end
    end)
    table.insert(stateV1.ragdollConnections, camConn)
    local respawnConn = LP.CharacterAdded:Connect(function()
        stateV1.isBoosting = false
        task.wait(0.5)
        cacheCharacterV1()
    end)
    table.insert(stateV1.ragdollConnections, respawnConn)
    task.spawn(heartbeatLoopV1)
    print("[AntiRagdollV1] Activado")
end

function AntiRagdollV1.stop()
    stateV1.active = false
    if stateV1.isBoosting and stateV1.cachedChar and stateV1.cachedChar.humanoid then
        stateV1.cachedChar.humanoid.WalkSpeed = AR_DEFAULT_SPEED
    end
    stateV1.isBoosting = false
    disconnectAllV1()
    stateV1.cachedChar = nil
    print("[AntiRagdollV1] Desactivado")
end

function AntiRagdollV1.isRunning() return stateV1.active end

local AntiRagdollV2 = {
    Enabled = false,
    Connection = nil,
    ResetCooldown = 0,
}

local function startAntiRagdollV2()
    if AntiRagdollV2.Connection then return end
    AntiRagdollV2.Enabled = true
    AntiRagdollV2.Connection = RunService.Heartbeat:Connect(function()
        if not AntiRagdollV2.Enabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root then return end
        if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return end
        local state = hum:GetState()
        local now = _tick()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown then
            if now - AntiRagdollV2.ResetCooldown > 0.15 then
                AntiRagdollV2.ResetCooldown = now
                pcall(function()
                    if hum:GetState() == Enum.HumanoidStateType.GettingUp then return end
                    if hum.Health <= 0 or hum:GetState() == Enum.HumanoidStateType.Dead then return end
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    root.Velocity = _V3zero
                    root.RotVelocity = _V3zero
                    root.AssemblyLinearVelocity = _V3zero
                    root.AssemblyAngularVelocity = _V3zero
                    for _, obj in ipairs(char:GetDescendants()) do
                        if obj:IsA("Motor6D") then obj.Enabled = true end
                        if obj:IsA("Constraint") then obj.Enabled = true end
                    end
                    workspace.CurrentCamera.CameraSubject = hum
                    local PM = LP.PlayerScripts:FindFirstChild("PlayerModule")
                    if PM then
                        local CM = require(PM:FindFirstChild("ControlModule"))
                        if CM then CM:Enable() end
                    end
                    hum.AutoRotate = true
                    hum.PlatformStand = false
                    hum.Sit = false
                end)
            end
        end
    end)
end

local function stopAntiRagdollV2()
    AntiRagdollV2.Enabled = false
    if AntiRagdollV2.Connection then
        AntiRagdollV2.Connection:Disconnect()
        AntiRagdollV2.Connection = nil
    end
    AntiRagdollV2.ResetCooldown = 0
end

function setAntiRagdollMode(mode)
    if AntiRagdollV1.isRunning() then AntiRagdollV1.stop() end
    if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
    antiRagdollMode = mode
    if mode == "v1" then AntiRagdollV1.start()
    elseif mode == "v2" then startAntiRagdollV2() end
    if _G.updateAntiRagdollUI then _G.updateAntiRagdollUI(mode) end
    saveAllSettings()
end

_antiDieEnabled = false
_antiDieStopped = false
_antiDieSources = { toggle = false, autobat = false }

_antiDie = {
    enabled = false, loop = nil, healthConn = nil, charConn = nil,
    lastHealTime = 0, invincibleUntil = 0,
    config = {
        healthThreshold = 50,
        invincibilityFrames = 0.75,
        fallDamageProtection = false,
        ragdollProtection = true,
        autoRevive = true,
    },
}

function _antiDie.SuperHeal(hum)
    if not hum or not hum.Parent then return end
    local maxHealth = hum.MaxHealth or 100
    if maxHealth <= 0 or maxHealth == math.huge then maxHealth = 100 end
    pcall(function()
        hum.Health = maxHealth
        if hum.MaxHealth < maxHealth then hum.MaxHealth = maxHealth end
    end)
    _antiDie.invincibleUntil = _tick() + _antiDie.config.invincibilityFrames
    _antiDie.lastHealTime = _tick()
    pcall(function()
        local char = hum.Parent
        if not char then return end
        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("NumberValue") then
                local name = child.Name:lower()
                if name:find("health") or name:find("hp") or name:find("life") then
                    child.Value = maxHealth
                end
            end
            if child:IsA("BoolValue") and child.Name:lower():find("dead") then
                child.Value = false
            end
        end
    end)
end

function _antiDie.PreventDamage(root, hum)
    if not hum then return end
    if hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
    if _tick() < _antiDie.invincibleUntil then
        if hum.Health < (hum.MaxHealth or 100) then
            hum.Health = hum.MaxHealth or 100
        end
    end
    if _antiDie.config.ragdollProtection then
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown or
           state == Enum.HumanoidStateType.Dead then
            pcall(function()
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                hum:ChangeState(Enum.HumanoidStateType.Running)
            end)
            _antiDie.SuperHeal(hum)
            if root then
                pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
            end
        end
    end
    if hum.Health <= 0 then
        _antiDie.SuperHeal(hum)
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
        if root then
            pcall(function()
                root.CFrame = CFrame.new(root.Position + Vector3.new(0, 2, 0))
                root.AssemblyLinearVelocity = Vector3.zero
            end)
        end
    end
end

function _antiDie.AutoRevive()
    if not _antiDie.config.autoRevive then return end
    local char = LP.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum then return end
    if hum.Health <= 0 then
        _antiDie.SuperHeal(hum)
        pcall(function()
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
        if root then
            pcall(function()
                root.CFrame = CFrame.new(root.Position + Vector3.new(0, 3, 0))
                root.AssemblyLinearVelocity = Vector3.zero
            end)
        end
    end
end

function _antiDie.AttachHealth(char)
    if _antiDie.healthConn then _antiDie.healthConn:Disconnect(); _antiDie.healthConn = nil end
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then hum = char and char:WaitForChild("Humanoid", 3) end
    if not hum then return end
    _antiDie.healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
        if not _antiDie.enabled then return end
        if hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
        if hum.Health <= 0 then _antiDie.AutoRevive() end
    end)
    if hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
end

function _antiDie.StartEngine()
    if _antiDie.enabled and _antiDie.loop then return end
    _antiDie.enabled = true
    _antiDieEnabled = true
    antiDieEnabled = true
    if _antiDie.loop then _antiDie.loop:Disconnect(); _antiDie.loop = nil end
    if _antiDie.healthConn then _antiDie.healthConn:Disconnect(); _antiDie.healthConn = nil end
    _antiDie.loop = RunService.Heartbeat:Connect(function()
        if not _antiDie.enabled then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum then return end
        if hum.Health <= 0 then _antiDie.AutoRevive()
        elseif hum.Health <= _antiDie.config.healthThreshold then _antiDie.SuperHeal(hum)
        elseif hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
        _antiDie.PreventDamage(root, hum)
    end)
    if LP.Character then _antiDie.AttachHealth(LP.Character) end
    if _antiDie.charConn then _antiDie.charConn:Disconnect(); _antiDie.charConn = nil end
    _antiDie.charConn = LP.CharacterAdded:Connect(function(char)
        if not _antiDie.enabled then return end
        task.wait(0.05)
        _antiDie.AttachHealth(char)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then _antiDie.SuperHeal(hum) end
    end)
end

function _antiDie.StopEngine()
    _antiDie.enabled = false
    _antiDieEnabled = false
    antiDieEnabled = false
    if _antiDie.loop then _antiDie.loop:Disconnect(); _antiDie.loop = nil end
    if _antiDie.healthConn then _antiDie.healthConn:Disconnect(); _antiDie.healthConn = nil end
    if _antiDie.charConn then _antiDie.charConn:Disconnect(); _antiDie.charConn = nil end
    pcall(function()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hum then return end
        hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
        hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
        hum.BreakJointsOnDeath = true
        if hum.MaxHealth == math.huge or hum.MaxHealth <= 0 then
            hum.MaxHealth = 100
            hum.Health = math.min(hum.Health, 100)
        end
    end)
end

function _antiDieSetEnabled(enabled)
    enabled = enabled == true
    if enabled == _antiDieEnabled then return end
    if enabled then
        _antiDie.StartEngine()
    else
        _antiDie.StopEngine()
    end
end

function _antiDieRefresh()
    if _antiDieStopped then return end
    local manual = _antiDieSources.toggle
    _antiDieSetEnabled(manual or _antiDieSources.autobat)
end

_G.__CrystalAntiDieSource = function(source, enabled)
    if _antiDieStopped or _antiDieSources[source] == nil then return end
    _antiDieSources[source] = enabled == true
    _antiDieRefresh()
end

_G.__CrystalAntiDieSet = function(enabled)
    _G.__CrystalAntiDieSource("autobat", enabled)
end

_G.__CrystalAntiDieIsEnabled = function() return _antiDieEnabled end
_G.__CrystalAntiDieStop = function()
    _antiDieStopped = true
    _antiDieSources.toggle = false
    _antiDieSources.autobat = false
    _antiDieSetEnabled(false)
end

function activateOnCharacter(char)
    if not _antiDieEnabled then return end
    _antiDie.AttachHealth(char)
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then _antiDie.SuperHeal(hum) end
end

AntiDieModule = {
    enabled = false,
    start = function()
        AntiDieModule.enabled = true
        antiDieEnabled = true
        _antiDieStopped = false
        _G.__CrystalAntiDieSource("toggle", true)
    end,
    stop = function()
        AntiDieModule.enabled = false
        antiDieEnabled = false
        _G.__CrystalAntiDieSource("toggle", false)
    end,
}
_G.AntiDie = AntiDieModule

--=========================================================
--  Anti Bat (lógica portada de Clean Anti Bat)
--=========================================================
local AntiBat = { Connection = nil }
local ANTIBAT_RANGE = 4000

function stopAntiBat()
    antiBatEnabled = false
    if AntiBat.Connection then
        AntiBat.Connection:Disconnect()
        AntiBat.Connection = nil
    end
end

function startAntiBat()
    stopAntiBat()
    antiBatEnabled = true

    AntiBat.Connection = RunService.Heartbeat:Connect(function()
        if not antiBatEnabled then return end
        local character = LP.Character
        if not character then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local v = hrp.Velocity
        hrp.Velocity = Vector3.new(
            math.random(-ANTIBAT_RANGE, ANTIBAT_RANGE),
            v.Y,
            math.random(-ANTIBAT_RANGE, ANTIBAT_RANGE)
        )
        RunService.RenderStepped:Wait()
        if hrp and hrp.Parent then
            hrp.Velocity = v
        end
    end)
end

LP.CharacterAdded:Connect(function()
    task.wait(0.3)
    if antiBatEnabled then startAntiBat() end
end)

setAntiFlingVisual = nil

local _antiFlingState = {
    connection    = nil,
    threshold     = 80,
    spinThreshold = 40,
}
local _ANTI_FLING_DRIVE_GRACE = 0.3

local function _afHubSpeedLive()
    local live = _G.__RivalHubLiveSpeed
    if type(live) ~= "table" then return false end
    local stamp, speed = tonumber(live.t), tonumber(live.v)
    if not stamp or not speed or speed <= 0 then return false end
    return (os.clock() - stamp) <= _ANTI_FLING_DRIVE_GRACE
end

local function _afOwnMoverActive()
    if autoBatEnabled then return true end
    if autoLeftEnabled or autoRightEnabled then return true end
    return false
end

function startAntiFling()
    if _antiFlingState.connection then return end
    antiFlingEnabled = true
    _antiFlingState.connection = RunService.Heartbeat:Connect(function()
        if not antiFlingEnabled then return end
        local character = LP.Character
        if not character then return end
        local root = character:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid and (humanoid.Health <= 0 or humanoid.SeatPart) then return end

        if dropActive or _G.IsDropping then return end
        if _afOwnMoverActive() then return end
        if _afHubSpeedLive() then return end

        local velocity = root.AssemblyLinearVelocity
        local flat = Vector3.new(velocity.X, 0, velocity.Z)

        if flat.Magnitude > _antiFlingState.threshold then
            pcall(function()
                root.AssemblyLinearVelocity = Vector3.new(0, velocity.Y, 0)
                root.AssemblyAngularVelocity = Vector3.zero
            end)
            return
        end
        if root.AssemblyAngularVelocity.Magnitude > _antiFlingState.spinThreshold then
            pcall(function() root.AssemblyAngularVelocity = Vector3.zero end)
        end
    end)
end

function stopAntiFling()
    antiFlingEnabled = false
    if _antiFlingState.connection then
        _antiFlingState.connection:Disconnect()
        _antiFlingState.connection = nil
    end
end

LP.CharacterAdded:Connect(function()
    task.wait(0.3)
    if antiFlingEnabled then startAntiFling() end
end)

local espEnabled = espEnabled or false
local espActivePlayers = {}
local espLoopConn = nil
local Camera = workspace.CurrentCamera
local GUI2_ESP_COLOR = Color3.fromRGB(139, 72, 246)
local GUI2_ESP_TEXT_STROKE = Color3.fromRGB(48, 16, 92)

local function getESPThemeColors(accent)
    local c = getThemeColor() or accent or Color3.fromRGB(245, 245, 250)
    return c, Color3.fromRGB(0, 0, 0)
end

local function createESP()
    local currentFill, currentLine = getESPThemeColors()
    local esp = {
        Tracer = Drawing and Drawing.new("Line") or nil,
        Highlight = Instance.new("Highlight"),
        Lines = {},
    }
    if esp.Tracer then
        esp.Tracer.Color = currentLine
        esp.Tracer.Thickness = 3
        esp.Tracer.Transparency = 1
        esp.Tracer.ZIndex = 2
    end

    esp.Highlight.Name = "RivalHubESP_Highlight"
    esp.Highlight.FillColor = currentFill
    esp.Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
    esp.Highlight.FillTransparency = 0.12
    esp.Highlight.OutlineTransparency = 0.18
    esp.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    local parentGui
    local ok, robGui = pcall(function() return game:GetService("CoreGui"):FindFirstChild("RobloxGui") end)
    if ok and robGui then parentGui = robGui else parentGui = LP:FindFirstChildOfClass("PlayerGui") end
    if not parentGui then parentGui = game:GetService("CoreGui") end
    pcall(function() esp.Highlight.Parent = parentGui end)

    local nameBillboard = Instance.new("BillboardGui")
    nameBillboard.Name = "RivalHubESP_Name"
    nameBillboard.Size = UDim2.new(0, 170, 0, 28)
    nameBillboard.StudsOffset = Vector3.new(0, 1.3, 0)
    nameBillboard.AlwaysOnTop = true
    nameBillboard.Parent = parentGui

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(0, 170, 0, 28)
    nameLabel.AnchorPoint = Vector2.new(0.5, 0)
    nameLabel.Position = UDim2.new(0.5, 0, 0, 2)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = ""
    nameLabel.TextColor3 = getThemeColor()
    nameLabel.TextSize = 15
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextXAlignment = Enum.TextXAlignment.Center
    nameLabel.TextYAlignment = Enum.TextYAlignment.Center
    nameLabel.ZIndex = 5
    nameLabel.Parent = nameBillboard

    local nameOutline = Instance.new("UIStroke")
    nameOutline.Color = Color3.fromRGB(0, 0, 0)
    nameOutline.Thickness = 2.2
    nameOutline.Transparency = 0.12
    nameOutline.Parent = nameLabel

    if Drawing then
        for i = 1, 14 do
            local line = Drawing.new("Line")
            line.Color = currentLine
            line.Thickness = 2
            line.Transparency = 1
            line.ZIndex = 3
            table.insert(esp.Lines, line)
        end
    end

    esp.NameTag = nameBillboard
    esp.NameLabel = nameLabel
    esp.NameOutline = nameOutline
    return esp
end

_G.__RivalHubRefreshESPTheme = function(accent, outlineColor)
    local fillColor, lineColor = getESPThemeColors(accent)
    for _, data in pairs(espActivePlayers) do
        if type(data) == "table" and data.esp then
            local esp = data.esp
            if esp.Tracer then pcall(function() esp.Tracer.Color = lineColor end) end
            if esp.Highlight then
                esp.Highlight.FillColor = fillColor
                esp.Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
            end
            if esp.NameLabel then
                esp.NameLabel.TextColor3 = getThemeColor()
                esp.NameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            end
            if esp.NameOutline then esp.NameOutline.Color = Color3.fromRGB(0, 0, 0) end
            for _, line in ipairs(esp.Lines or {}) do pcall(function() line.Color = lineColor end) end
        end
    end
end

local function removeESP(plr)
    local data = espActivePlayers[plr]
    if data then
        if data.esp.Tracer then pcall(function() data.esp.Tracer:Remove() end) end
        if data.esp.Highlight then pcall(function() data.esp.Highlight:Destroy() end) end
        if data.esp.NameTag then pcall(function() data.esp.NameTag:Destroy() end) end
        for _, line in ipairs(data.esp.Lines) do
            pcall(function() line:Remove() end)
        end
        espActivePlayers[plr] = nil
    end
end

local function updateESP(plr, esp)
    if not espEnabled then
        if esp.Tracer then esp.Tracer.Visible = false end
        esp.Highlight.Enabled = false
        for _, line in ipairs(esp.Lines) do line.Visible = false end
        if esp.NameTag then esp.NameTag.Enabled = false end
        return
    end

    local character = plr.Character
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    local trackPart = character and (
        character:FindFirstChild("HumanoidRootPart")
        or character.PrimaryPart
        or character:FindFirstChild("UpperTorso")
        or character:FindFirstChild("Torso")
        or character:FindFirstChild("Head")
    )

    if character and trackPart and (not hum or hum.Health > 0) then
        esp.Highlight.Adornee = character
        esp.Highlight.Enabled = espEnabled
        if esp.Tracer then esp.Tracer.Visible = false end
        for _, line in ipairs(esp.Lines) do line.Visible = false end

        if esp.NameTag and esp.NameLabel then
            pcall(function()
                esp.NameTag.Adornee = trackPart
                esp.NameTag.Enabled = espEnabled
                esp.NameLabel.Text = plr.Name or plr.DisplayName or ""
                esp.NameLabel.TextColor3 = getThemeColor()
            end)
        end
    else
        if esp.Tracer then esp.Tracer.Visible = false end
        esp.Highlight.Enabled = false
        esp.Highlight.Adornee = nil
        for _, line in ipairs(esp.Lines) do line.Visible = false end
        if esp.NameTag then esp.NameTag.Enabled = false end
    end
end

local function createESPForPlayer(plr)
    if plr == LP then return end
    if espActivePlayers[plr] and espActivePlayers[plr].esp then
        if espActivePlayers[plr].esp.NameTag then
            pcall(function() espActivePlayers[plr].esp.NameTag.Enabled = espEnabled end)
        end
        return
    end
    removeESP(plr)
    local esp = createESP()
    espActivePlayers[plr] = { esp = esp }
end

local espJoinConn, espLeaveConn
local function enableESP()
    if espEnabled then return end
    espEnabled = true
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LP then task.spawn(function() createESPForPlayer(plr) end) end
    end
    local espAccumulator = 0
    if espLoopConn then espLoopConn:Disconnect() end
    espLoopConn = RunService.Heartbeat:Connect(function(dt)
        espAccumulator = espAccumulator + (dt or 0)
        if espAccumulator < 0.15 then return end
        espAccumulator = 0
        for plr, data in pairs(espActivePlayers) do
            if typeof(plr) == "Instance" and plr:IsA("Player") and data and data.esp then
                pcall(function() updateESP(plr, data.esp) end)
            end
        end
    end)
    espJoinConn = Players.PlayerAdded:Connect(function(plr)
        if not espEnabled or plr == LP then return end
        task.wait(0.3)
        createESPForPlayer(plr)
    end)
    espLeaveConn = Players.PlayerRemoving:Connect(function(plr) removeESP(plr) end)
end

local function disableESP()
    espEnabled = false
    if espLoopConn then espLoopConn:Disconnect(); espLoopConn = nil end
    if espJoinConn then pcall(function() espJoinConn:Disconnect() end); espJoinConn = nil end
    if espLeaveConn then pcall(function() espLeaveConn:Disconnect() end); espLeaveConn = nil end
    for plr in pairs(espActivePlayers) do
        if typeof(plr) == "Instance" and plr:IsA("Player") and plr ~= LP then removeESP(plr) end
    end
end

function toggleESP(on)
    if on then enableESP() else disableESP() end
    if setESPVIsual then setESPVIsual(on) end
end

local _espLineGui = nil
local _espLineFrame = nil
local _espLineOutline = nil
local _espLineConn = nil
local _espLineState = { scanElapsed = math.huge, targetRoot = nil }

local function ensureESPLineGui()
    if _espLineGui and _espLineGui.Parent then return end
    _espLineGui = Instance.new("ScreenGui")
    _espLineGui.Name = "RivalHubESPLine"
    _espLineGui.IgnoreGuiInset = true
    _espLineGui.ResetOnSpawn = false
    _espLineGui.DisplayOrder = 1000
    _espLineGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local okP = pcall(function() _espLineGui.Parent = game:GetService("CoreGui") end)
    if not okP then _espLineGui.Parent = LP:WaitForChild("PlayerGui") end

    _espLineFrame = Instance.new("Frame")
    _espLineFrame.Name = "ESPLine"
    _espLineFrame.AnchorPoint = Vector2.new(0.5, 0.5)
    _espLineFrame.BorderSizePixel = 0
    _espLineFrame.Active = false
    _espLineFrame.Visible = false
    _espLineFrame.BackgroundColor3 = getThemeColor()
    _espLineFrame.ZIndex = 1
    _espLineFrame.Parent = _espLineGui

    _espLineOutline = Instance.new("UIStroke", _espLineFrame)
    _espLineOutline.Color = Color3.fromRGB(255, 255, 255)
    _espLineOutline.Thickness = 0.7
    _espLineOutline.Transparency = 0.45
end

function stopESPLine()
    espLineEnabled = false
    if _espLineConn then _espLineConn:Disconnect(); _espLineConn = nil end
    if _espLineFrame then _espLineFrame.Visible = false end
    _espLineState.targetRoot = nil
    _espLineState.scanElapsed = math.huge
    if _espLineGui and _espLineGui.Parent then
        pcall(function() _espLineGui:Destroy() end)
    end
    _espLineGui = nil
    _espLineFrame = nil
    _espLineOutline = nil
end

function startESPLine()
    espLineEnabled = true
    ensureESPLineGui()
    if _espLineConn then _espLineConn:Disconnect() end
    _espLineState.scanElapsed = math.huge
    _espLineState.targetRoot = nil

    _espLineConn = RunService.RenderStepped:Connect(function(dt)
        if not espLineEnabled then
            if _espLineFrame then _espLineFrame.Visible = false end
            return
        end
        local ok = pcall(function()
            local activeCamera = workspace.CurrentCamera
            local myChar = LP.Character
            local myRoot = myChar and (myChar:FindFirstChild("LowerTorso") or myChar:FindFirstChild("HumanoidRootPart") or myChar:FindFirstChild("Torso"))
            if not activeCamera or not myRoot then
                if _espLineFrame then _espLineFrame.Visible = false end
                return
            end

            local myPosition = myRoot.Position
            _espLineState.scanElapsed = _espLineState.scanElapsed + (dt or 0)
            local cachedRoot = _espLineState.targetRoot
            local cachedCharacter = cachedRoot and cachedRoot.Parent
            local cachedHumanoid = cachedCharacter and cachedCharacter:FindFirstChildOfClass("Humanoid")
            local cachedValid = cachedRoot and cachedRoot.Parent and (not cachedHumanoid or cachedHumanoid.Health > 0)
            if _espLineState.scanElapsed >= 0.12 or not cachedValid then
                _espLineState.scanElapsed = 0
                local closestRoot, closestDistanceSq = nil, math.huge
                for _, otherPlayer in ipairs(Players:GetPlayers()) do
                    if otherPlayer ~= LP then
                        local character = otherPlayer.Character
                        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                        local root = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("LowerTorso") or character:FindFirstChild("Torso"))
                        if root and root:IsA("BasePart") and (not humanoid or humanoid.Health > 0) then
                            local delta = root.Position - myPosition
                            local distanceSq = delta:Dot(delta)
                            if distanceSq < closestDistanceSq then
                                closestRoot, closestDistanceSq = root, distanceSq
                            end
                        end
                    end
                end
                _espLineState.targetRoot = closestRoot
            end

            local closestRoot = _espLineState.targetRoot
            if not closestRoot or not closestRoot.Parent then
                if _espLineFrame then _espLineFrame.Visible = false end
                return
            end
            local closestPosition = closestRoot.Position

            local from = activeCamera:WorldToViewportPoint(myPosition - Vector3.new(0, myRoot.Size.Y * 0.35, 0))
            local to, targetOnScreen = activeCamera:WorldToViewportPoint(closestPosition)
            local viewport = activeCamera.ViewportSize
            local fromPoint = Vector2.new(from.X, from.Y)
            local targetPoint = Vector2.new(to.X, to.Y)

            if not targetOnScreen or to.Z <= 0 then
                local center = viewport * 0.5
                local direction = targetPoint - center
                if to.Z <= 0 then direction = -direction end
                if direction.Magnitude < 0.001 then direction = Vector2.new(0, -1) end
                local limit = Vector2.new(math.max(8, center.X - 8), math.max(8, center.Y - 8))
                local scaleX = limit.X / math.max(math.abs(direction.X), 0.001)
                local scaleY = limit.Y / math.max(math.abs(direction.Y), 0.001)
                targetPoint = center + direction * math.min(scaleX, scaleY)
            end

            if from.Z <= 0 or fromPoint.X < 0 or fromPoint.X > viewport.X or fromPoint.Y < 0 or fromPoint.Y > viewport.Y then
                fromPoint = Vector2.new(viewport.X * 0.5, viewport.Y - 8)
            end

            local delta = targetPoint - fromPoint
            local midpoint = (fromPoint + targetPoint) * 0.5
            _espLineFrame.Position = UDim2.fromOffset(midpoint.X, midpoint.Y)
            _espLineFrame.Size = UDim2.fromOffset(math.max(delta.Magnitude, 1), 2)
            _espLineFrame.Rotation = math.deg(math.atan2(delta.Y, delta.X))
            _espLineFrame.BackgroundColor3 = getThemeColor()
            _espLineFrame.Visible = true
        end)
        if not ok and _espLineFrame then
            pcall(function() _espLineFrame.Visible = false end)
        end
    end)
end

local _enemySpeedAcc = 0
function updateEnemySpeedLabels()
    _enemySpeedAcc = _enemySpeedAcc + 1
    if _enemySpeedAcc < 6 then return end
    _enemySpeedAcc = 0
    local color = getThemeColor()
    local players = _GetPlayersCached()
    for i = 1, #players do
        local player = players[i]
        if player ~= LP then
            local char = player.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local v = hrp.AssemblyLinearVelocity
                local speed = _sqrt(v.X*v.X + v.Z*v.Z)
                local label = enemySpeedLabels[player]
                if not label then
                    local head = char:FindFirstChild("Head")
                    if head then
                        local bb = Instance.new("BillboardGui")
                        bb.Size = UDim2.new(0, 100, 0, 25)
                        bb.StudsOffset = _V3new(0, 5.5, 0)
                        bb.AlwaysOnTop = true
                        bb.Name = "EnemySpeedGui"
                        bb.Parent = head
                        local tl = Instance.new("TextLabel", bb)
                        tl.Size = UDim2.new(1, 0, 1, 0)
                        tl.BackgroundTransparency = 1
                        tl.TextColor3 = color
                        tl.Font = Enum.Font.GothamBold
                        tl.TextScaled = true
                        tl.TextStrokeTransparency = 0
                        tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        enemySpeedLabels[player] = tl
                        label = tl
                    end
                elseif label.Parent and label.Parent.Parent ~= char then
                    local head = char:FindFirstChild("Head")
                    if head then label.Parent.Parent = head end
                end
                if label then
                    label.Text = string.format("%.1f", speed)
                    if label.TextColor3 ~= color then label.TextColor3 = color end
                end
            else
                local label = enemySpeedLabels[player]
                if label and label.Parent and label.Parent.Parent then label.Parent.Parent = nil end
                enemySpeedLabels[player] = nil
            end
        end
    end
end

function startEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect() end
    enemySpeedConn = RunService.Heartbeat:Connect(updateEnemySpeedLabels)
end

function stopEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect(); enemySpeedConn = nil end
end

local function getClosestTargetBody()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local rpos = root.Position
    local closest, minDist = nil, _huge
    local plist = _GetPlayersCached()
    for i = 1, #plist do
        local plr = plist[i]
        if plr ~= LP then
            local c = plr.Character
            if c then
                local tRoot = c:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local dx = tRoot.Position.X - rpos.X
                        local dy = tRoot.Position.Y - rpos.Y
                        local dz = tRoot.Position.Z - rpos.Z
                        local d = dx*dx + dy*dy + dz*dz
                        if d < minDist then minDist = d; closest = tRoot end
                    end
                end
            end
        end
    end
    return closest
end

local function _bodyLockTick()
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local target = getClosestTargetBody()
    if not target then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    local dist = (target.Position - root.Position).Magnitude
    if dist > bodyLockRange then
        if not hum.AutoRotate then hum.AutoRotate = true end
        return
    end
    if hum.AutoRotate then hum.AutoRotate = false end
    local targetVel = target.AssemblyLinearVelocity
    local speed3 = targetVel.Magnitude
    local predictTime = _clamp(speed3 / 80, 0.08, 0.35)
    local predictedPos = target.Position + targetVel * predictTime
    local targetHead = target.Parent and target.Parent:FindFirstChild("Head")
    local targetHeight = targetHead and targetHead.Position.Y or target.Position.Y
    local myHeight = root.Position.Y + (hum.HipHeight or 0)
    local heightDiff = targetHeight - myHeight
    local verticalCorrection = _clamp(heightDiff * 0.15, -1.5, 1.5)
    local flatTarget = _V3new(predictedPos.X, root.Position.Y + verticalCorrection, predictedPos.Z)
    local toPredict = flatTarget - root.Position
    if toPredict.Magnitude > 0.1 then
        local goalCF = _CFlookAt(root.Position, flatTarget)
        local diffCF = root.CFrame:Inverse() * goalCF
        local _, ry, _ = diffCF:ToEulerAnglesXYZ()
        ry = _clamp(ry, -2.5, 2.5)
        root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(_V3new(0, ry * 42, 0))
    end
end

function startBodyLock()
    if _bodyLockConn then _bodyLockConn:Disconnect() end
    local acc = 0
    _bodyLockConn = RunService.Heartbeat:Connect(function(dt)
        if not bodyLockEnabled then return end
        if _blSuppressCount > 0 then return end
        acc = acc + dt
        if acc < 0.033 then return end
        acc = 0
        _bodyLockTick()
    end)
end

function stopBodyLock()
    if _bodyLockConn then
        _bodyLockConn:Disconnect()
        _bodyLockConn = nil
    end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        root.AssemblyAngularVelocity = _V3zero
        root.AssemblyLinearVelocity = _V3new(root.AssemblyLinearVelocity.X, -0.1, root.AssemblyLinearVelocity.Z)
    end
    local hum2 = c and c:FindFirstChildOfClass("Humanoid")
    if hum2 then hum2.AutoRotate = true end
end

function _suppressBodyLock()
    _blSuppressCount = _blSuppressCount + 1
    if _blSuppressCount == 1 and bodyLockEnabled then
        _blWasEnabled = true
        stopBodyLock()
        if bodyLockSetVisual then bodyLockSetVisual(false) end
        if _blRestoreTimer then
            task.cancel(_blRestoreTimer)
            _blRestoreTimer = nil
        end
        _blSmoothRestore = false
    end
end

function _unsuppressBodyLock(delayed)
    if _blSuppressCount > 0 then
        _blSuppressCount = _blSuppressCount - 1
    end
    if _blSuppressCount == 0 and _blWasEnabled then
        _blWasEnabled = false
        if _blRestoreTimer then
            pcall(task.cancel, _blRestoreTimer)
            _blRestoreTimer = nil
        end
        local function restore()
            _blRestoreTimer = nil
            if bodyLockEnabled then
                _blSmoothRestore = true
                startBodyLock()
                if bodyLockSetVisual then bodyLockSetVisual(true) end
                task.delay(0.5, function() _blSmoothRestore = false end)
            end
        end
        if delayed then
            _blRestoreTimer = task.delay(1, restore)
        else
            restore()
        end
    end
end

function setupSpeedIndicator(char)
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    local oldBB = head:FindFirstChild("RivalHubSpeedIndicator")
    if oldBB then oldBB:Destroy() end
    local oldDiscord = head:FindFirstChild("DiscordText")
    if oldDiscord then oldDiscord:Destroy() end

    local bb = Instance.new("BillboardGui", head)
    bb.Name = "RivalHubSpeedIndicator"
    bb.Size = UDim2.fromOffset(200, 30)
    bb.StudsOffset = Vector3.new(0, 3.2, 0)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.MaxDistance = 0

    speedLabel = Instance.new("TextLabel", bb)
    speedLabel.Name = "SpeedLabel"
    speedLabel.Size = UDim2.new(1, 0, 1, 0)
    speedLabel.Position = UDim2.new(0, 0, 0, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "0.0  -  " .. getSpeedModeName()
    speedLabel.TextColor3 = Color3.fromRGB(85, 170, 255)
    speedLabel.Font = Enum.Font.GothamBlack
    speedLabel.TextSize = 22
    speedLabel.TextXAlignment = Enum.TextXAlignment.Center
    speedLabel.TextYAlignment = Enum.TextYAlignment.Center
    speedLabel.TextStrokeTransparency = 0
    speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    local slStroke = Instance.new("UIStroke", speedLabel)
    slStroke.Color = Color3.fromRGB(0, 0, 0)
    slStroke.Thickness = 1.5
    slStroke.Transparency = 0.2
    applyShimmerToText(speedLabel, 0.9, Color3.fromRGB(85, 170, 255))
end

local unwalkSavedAnimate = nil

function startUnwalk()
    local c = LP.Character
    if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop() end) end
    end
    local anim = c:FindFirstChild("Animate")
    if anim then
        unwalkSavedAnimate = anim:Clone()
        anim:Destroy()
    end
end

function stopUnwalk()
    local c = LP.Character
    if c then
        local existing = c:FindFirstChild("Animate")
        if not existing then
            local src = game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts")
            local starterAnim = src and src:FindFirstChild("Animate")
            if starterAnim then
                starterAnim:Clone().Parent = c
            elseif unwalkSavedAnimate then
                unwalkSavedAnimate:Clone().Parent = c
            end
        end
    end
    unwalkSavedAnimate = nil
end

function refreshSpeedModeLabel()
    if modeValLbl then
        if laggerCarryToggled then modeValLbl.Text = "Lagger Carry"
        elseif laggerToggled then modeValLbl.Text = "Lagger Normal"
        elseif speedMode then modeValLbl.Text = "Carry"
        else modeValLbl.Text = "Normal" end
    end
    if setCarryModeVisual then setCarryModeVisual(speedMode) end
    if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
    if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
end

function resetMovementState()
    refreshSpeedModeLabel()
    if mobSetCarry then mobSetCarry(speedMode) end
    if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
    if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
end

function toggleCarryMode()
    if laggerToggled or laggerCarryToggled then
        laggerToggled = false; laggerCarryToggled = false; speedMode = true
    else speedMode = not speedMode end
    resetMovementState()
    if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end
end

function toggleLaggerMode()
    if laggerCarryToggled then laggerCarryToggled = false end
    speedMode = false; laggerToggled = not laggerToggled
    resetMovementState()
    if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end
end
function toggleLaggerCarryMode()
    if laggerToggled then laggerToggled = false end
    speedMode = false; laggerCarryToggled = not laggerCarryToggled
    resetMovementState()
    if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end
end

function toggleLaggerCycle()
    if speedMode then
        speedMode = false
        laggerToggled = true
        laggerCarryToggled = false
    elseif laggerToggled then
        speedMode = false
        laggerToggled = false
        laggerCarryToggled = true
    else
        speedMode = true
        laggerToggled = false
        laggerCarryToggled = false
    end
    resetMovementState()
    if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end
end

function stopAutoLeft()
    if alConn then alConn:Disconnect(); alConn = nil end
    alPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(_V3zero, false) end
    end
    if autoLeftSetVisual then autoLeftSetVisual(false) end
    if mobSetAutoLeft then mobSetAutoLeft(false) end
    _unsuppressBodyLock(true)
end

function startAutoLeft()
    if autoRightEnabled then
        autoRightEnabled = false
        stopAutoRight()
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobSetAutoRight then mobSetAutoRight(false) end
    end
    disableAllAimbots()
    _suppressBodyLock()
    if alConn then alConn:Disconnect() end
    alPhase = 1
    alConn = RunService.Heartbeat:Connect(function()
        if not autoLeftEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if alPhase == 1 then
            local tgt = _V3new(AP.L1.X, root.Position.Y, AP.L1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                alPhase = 2
                local d = AP.L2 - root.Position
                local mv = _V3new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.L1 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif alPhase == 2 then
            local tgt = _V3new(AP.L2.X, root.Position.Y, AP.L2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(_V3zero, false)
                root.AssemblyLinearVelocity = _V3zero
                autoLeftEnabled = false
                if alConn then alConn:Disconnect(); alConn = nil end
                alPhase = 1
                if autoLeftSetVisual then autoLeftSetVisual(false) end
                if mobSetAutoLeft then mobSetAutoLeft(false) end
                _unsuppressBodyLock(true)
                local facePos = _V3new(AP.L_FACE.X, root.Position.Y, AP.L_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = _CFnew(root.Position, facePos)
                end
                return
            end
            local d = AP.L2 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

function stopAutoRight()
    if arConn then arConn:Disconnect(); arConn = nil end
    arPhase = 1
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum:Move(_V3zero, false) end
    end
    if autoRightSetVisual then autoRightSetVisual(false) end
    if mobSetAutoRight then mobSetAutoRight(false) end
    _unsuppressBodyLock(true)
end

function startAutoRight()
    if autoLeftEnabled then
        autoLeftEnabled = false
        stopAutoLeft()
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobSetAutoLeft then mobSetAutoLeft(false) end
    end
    disableAllAimbots()
    _suppressBodyLock()
    if arConn then arConn:Disconnect() end
    arPhase = 1
    arConn = RunService.Heartbeat:Connect(function()
        if not autoRightEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        local spd = NS
        if arPhase == 1 then
            local tgt = _V3new(AP.R1.X, root.Position.Y, AP.R1.Z)
            if (tgt - root.Position).Magnitude < 1 then
                arPhase = 2
                local d = AP.R2 - root.Position
                local mv = _V3new(d.X, 0, d.Z).Unit
                hum:Move(mv, false)
                root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
                return
            end
            local d = AP.R1 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        elseif arPhase == 2 then
            local tgt = _V3new(AP.R2.X, root.Position.Y, AP.R2.Z)
            if (tgt - root.Position).Magnitude < 1 then
                hum:Move(_V3zero, false)
                root.AssemblyLinearVelocity = _V3zero
                autoRightEnabled = false
                if arConn then arConn:Disconnect(); arConn = nil end
                arPhase = 1
                if autoRightSetVisual then autoRightSetVisual(false) end
                if mobSetAutoRight then mobSetAutoRight(false) end
                _unsuppressBodyLock(true)
                local facePos = _V3new(AP.R_FACE.X, root.Position.Y, AP.R_FACE.Z)
                if (facePos - root.Position).Magnitude > 0.01 then
                    root.CFrame = _CFnew(root.Position, facePos)
                end
                return
            end
            local d = AP.R2 - root.Position
            local mv = _V3new(d.X, 0, d.Z).Unit
            hum:Move(mv, false)
            root.AssemblyLinearVelocity = _V3new(mv.X * spd, root.AssemblyLinearVelocity.Y, mv.Z * spd)
        end
    end)
end

function getClosestTarget()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local rpos = root.Position
    local closest, minDist = nil, _huge
    local plist = _GetPlayersCached()
    for i = 1, #plist do
        local plr = plist[i]
        if plr ~= LP then
            local c = plr.Character
            if c then
                local tRoot = c:FindFirstChild("HumanoidRootPart")
                if tRoot then
                    local hum = c:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        local dx = tRoot.Position.X - rpos.X
                        local dy = tRoot.Position.Y - rpos.Y
                        local dz = tRoot.Position.Z - rpos.Z
                        local d = dx*dx + dy*dy + dz*dz
                        if d < minDist then minDist = d; closest = tRoot end
                    end
                end
            end
        end
    end
    return closest
end

function trySwing()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local currentTool = char:FindFirstChildOfClass("Tool")
        if currentTool and not isBatTool(currentTool) then return end
        local bat = findBat()
        if bat then
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(bat) end) end
            end
            pcall(function() bat:Activate() end)
        end
    end)
end

do
local ACTIVATE_DISTANCE = 13
local MIN_FOLLOW_DISTANCE = 1
local PREDICTION_TIME = 0.22
local PREDICT_AHEAD = 3
local JUMP_SPEED_BOOST = 1.5
local JUMP_THRESHOLD = 8
local ACTIVATION_DELAY = 0.2
local AIRBORNE_THRESHOLD = 0.15
local FLOAT_Y_THRESHOLD = 3
local FALLING_THRESHOLD = -8
local RISING_THRESHOLD = 8
local VERTICAL_OFFSET_MULTIPLIER = 0.15
local JUMPBOOST_Y_THRESHOLD = 35
local EXTREME_JUMPBOOST_THRESHOLD = 50
local JUMPBOOST_SUSTAINED_TIME = 0.15
local MAX_VELOCITY_CHANGE = 150
local VELOCITY_SMOOTHING = 0.2
local MAX_HORIZONTAL_VELOCITY = 80
local ERRATIC_MOVEMENT_THRESHOLD = 3
local SERVER_TICKRATE = 1/60
local PING_SAMPLE_SIZE = 10
local MIN_PING_COMPENSATION = 0.03
local MAX_PING_COMPENSATION = 0.25
local ACCELERATION_PREDICTION_WEIGHT = 0.3
local DIRECTION_CHANGE_DETECTION_TIME = 0.12
local QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5
local GRAVITY = 196.2
local AIR_CONTROL_FACTOR = 0.8
local AERIAL_VELOCITY_DECAY = 0.95
local AERIAL_DIRECTION_CHANGE_WEIGHT = 0.6
local MIN_AIRBORNE_TIME = 0.08
local AERIAL_SMOOTHING = 0.15
local STRAFE_DETECTION_THRESHOLD = 0.7
local HIGH_JUMP_THRESHOLD = 20
local FALLING_SPEED_THRESHOLD = -15
local GRAVITY_PREDICTION_WEIGHT = 1.0
local MULTI_JUMP_DETECTION_WINDOW = 0.2
local UPWARD_VELOCITY_RESET_THRESHOLD = 10
local VERTICAL_POSITION_LEAD = 2.5
local FALLING_VERTICAL_LEAD = 3.5

local predictionSphere = nil
local targetPlayer = nil
local lastTargetPos = nil
local targetVelocity = Vector3.new(0, 0, 0)
local smoothedVelocity = Vector3.new(0, 0, 0)
local velocityHistory = {}
local MAX_HISTORY = 8
local airborneTime = 0
local lastActivationTime = 0
local highYVelocityTime = 0
local pingHistory = {}
local currentPing = 0.1
local accelerationHistory = {}
local MAX_ACCEL_HISTORY = 4
local lastDirectionChangeTime = 0
local previousDirection = nil
local wasAirborne = false
local aerialVelocityHistory = {}
local MAX_AERIAL_HISTORY = 6
local aerialSmoothVelocity = Vector3.new(0, 0, 0)
local lastYVelocity = 0
local peakHeight = 0
local groundHeight = 0
local lastJumpTime = 0
local isMultiJumping = false
local verticalVelocityHistory = {}
local MAX_VERTICAL_HISTORY = 5

local function getNearestPlayer()
    local char = LP.Character
    if not char then return nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return nil end
    local myPos = root.Position
    local nearestDist = math.huge
    local nearestPlayer = nil
    local MAX_TARGET_DISTANCE = 250
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LP and p.Character then
            local otherRoot = p.Character:FindFirstChild("HumanoidRootPart")
            local otherHum = p.Character:FindFirstChildOfClass("Humanoid")
            if otherRoot and otherHum and otherHum.Health > 0 then
                local dist = (myPos - otherRoot.Position).Magnitude
                if dist <= MAX_TARGET_DISTANCE and dist < nearestDist then
                    nearestDist = dist
                    nearestPlayer = p
                end
            end
        end
    end
    return nearestPlayer
end

local function getAverageVelocity()
    if #velocityHistory == 0 then return Vector3.new(0, 0, 0) end
    local sum = Vector3.new(0, 0, 0)
    for _, vel in ipairs(velocityHistory) do sum = sum + vel end
    return sum / #velocityHistory
end

local function getAverageAcceleration()
    if #accelerationHistory == 0 then return Vector3.new(0, 0, 0) end
    local sum = Vector3.new(0, 0, 0)
    for _, a in ipairs(accelerationHistory) do sum = sum + a end
    return sum / #accelerationHistory
end

local function getAverageAerialVelocity()
    if #aerialVelocityHistory == 0 then return Vector3.new(0, 0, 0) end
    local sum = Vector3.new(0, 0, 0)
    for _, vel in ipairs(aerialVelocityHistory) do
        sum = sum + Vector3.new(vel.X, 0, vel.Z)
    end
    return sum / #aerialVelocityHistory
end

local function getAverageVerticalVelocity()
    if #verticalVelocityHistory == 0 then return 0 end
    local sum = 0
    for _, y in ipairs(verticalVelocityHistory) do sum = sum + y end
    return sum / #verticalVelocityHistory
end

local function detectMultiJump(currentYVel, wasRising)
    local t = tick()
    if lastYVelocity < -5 and currentYVel > UPWARD_VELOCITY_RESET_THRESHOLD then
        if t - lastJumpTime < MULTI_JUMP_DETECTION_WINDOW then return true end
        lastJumpTime = t
        return true
    end
    return false
end

local function isFallingFromHeight(currentPos, yVel)
    return (currentPos.Y - groundHeight > HIGH_JUMP_THRESHOLD) and yVel < FALLING_SPEED_THRESHOLD
end

local function isAerialStrafing()
    if #aerialVelocityHistory < 3 then return false end
    local dc = 0
    for i = 2, #aerialVelocityHistory do
        local v1 = Vector3.new(aerialVelocityHistory[i-1].X, 0, aerialVelocityHistory[i-1].Z)
        local v2 = Vector3.new(aerialVelocityHistory[i].X, 0, aerialVelocityHistory[i].Z)
        if v1.Magnitude > 3 and v2.Magnitude > 3 then
            if v1.Unit:Dot(v2.Unit) < STRAFE_DETECTION_THRESHOLD then
                dc = dc + 1
            end
        end
    end
    return dc >= 2
end

local function detectDirectionChange(currentVel)
    local horizontal = Vector3.new(currentVel.X, 0, currentVel.Z)
    if horizontal.Magnitude < 5 then return false end
    if previousDirection then
        local dot = previousDirection:Dot(horizontal.Unit)
        if dot < 0.5 then
            local t = tick()
            if t - lastDirectionChangeTime < DIRECTION_CHANGE_DETECTION_TIME then
                previousDirection = horizontal.Unit
                lastDirectionChangeTime = t
                return true
            end
            lastDirectionChangeTime = t
        end
    end
    previousDirection = horizontal.Unit
    return false
end

local function isErraticMovement()
    if #velocityHistory < 3 then return false end
    local changes = 0
    for i = 2, #velocityHistory do
        local v1 = Vector3.new(velocityHistory[i-1].X, 0, velocityHistory[i-1].Z)
        local v2 = Vector3.new(velocityHistory[i].X, 0, velocityHistory[i].Z)
        if v1.Magnitude > 5 and v2.Magnitude > 5 then
            if v1.Unit:Dot(v2.Unit) < 0.3 then changes = changes + 1 end
        end
    end
    return changes >= ERRATIC_MOVEMENT_THRESHOLD
end

local function isInfiniteJumping()
    if #velocityHistory < 3 then return false end
    local yc = 0
    for i = 2, #velocityHistory do
        if math.abs(velocityHistory[i].Y - velocityHistory[i-1].Y) > 15 then
            yc = yc + 1
        end
    end
    return yc >= 2
end

local function isJumpBoostCheat()
    return math.abs(targetVelocity.Y) > JUMPBOOST_Y_THRESHOLD and highYVelocityTime > JUMPBOOST_SUSTAINED_TIME
end

local function isExtremeJumpBoost()
    return math.abs(targetVelocity.Y) > EXTREME_JUMPBOOST_THRESHOLD
end

local function isFloating()
    return airborneTime > AIRBORNE_THRESHOLD and math.abs(targetVelocity.Y) > FLOAT_Y_THRESHOLD
end

local function checkAirborne(targetRoot)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {targetPlayer.Character, LP.Character}
    local rayResult = workspace:Raycast(targetRoot.Position, Vector3.new(0, -100, 0), params)
    if rayResult then
        groundHeight = rayResult.Position.Y
        return false
    end
    return true
end

local function clampVelocityChange(newVel, oldVel, maxChange)
    local delta = newVel - oldVel
    if delta.Magnitude > maxChange then
        return oldVel + (delta.Unit * maxChange)
    end
    return newVel
end

local function smoothVelocity(current, target, alpha)
    return current:Lerp(target, alpha)
end

local function predictAerialPosition(currentPos, velocity, dt, isStrafing, isFastFalling, isMultiJump)
    local horizVel = Vector3.new(velocity.X, 0, velocity.Z)
    local vertVel = velocity.Y

    if isStrafing then
        local avgAerial = getAverageAerialVelocity()
        horizVel = Vector3.new(avgAerial.X, 0, avgAerial.Z) * AIR_CONTROL_FACTOR
    else
        horizVel = horizVel * AIR_CONTROL_FACTOR
    end

    horizVel = horizVel * AERIAL_VELOCITY_DECAY

    local gravityEffect = GRAVITY * GRAVITY_PREDICTION_WEIGHT
    if isMultiJump then
        gravityEffect = gravityEffect * 0.3
        vertVel = vertVel * 0.9
    end

    local verticalDisplacement
    if isFastFalling then
        verticalDisplacement = (vertVel * dt) - (0.5 * gravityEffect * 1.2 * dt * dt) - (FALLING_VERTICAL_LEAD * dt)
    else
        verticalDisplacement = (vertVel * dt) - (0.5 * gravityEffect * dt * dt)
    end

    if vertVel > RISING_THRESHOLD and not isMultiJump then
        verticalDisplacement = verticalDisplacement + (VERTICAL_POSITION_LEAD * dt)
    end

    return currentPos + horizVel * dt + Vector3.new(0, verticalDisplacement, 0)
end

local function predictServerPosition(currentPos, velocity, acceleration, ping, isQuickTurn, isAerial, isStrafing, isFastFalling, isMultiJump)
    local serverDelay = ping + SERVER_TICKRATE
    if isQuickTurn then serverDelay = serverDelay * QUICK_DIRECTION_CHANGE_MULTIPLIER end
    if isAerial then
        return predictAerialPosition(currentPos, velocity, serverDelay, isStrafing, isFastFalling, isMultiJump)
    end

    local predictedPos = currentPos + velocity * serverDelay
    if acceleration.Magnitude > 1 then
        predictedPos = predictedPos + (acceleration * ACCELERATION_PREDICTION_WEIGHT) * (serverDelay * serverDelay * 0.5)
    end
    return predictedPos
end

local SPHERE_SMOOTH_SPEED = 15

local function createPredictionSphere()
    if predictionSphere then predictionSphere:Destroy() end
    predictionSphere = Instance.new("Part")
    predictionSphere.Name = "PredictionSphere"
    predictionSphere.Shape = Enum.PartType.Ball
    predictionSphere.Size = Vector3.new(2, 2, 2)
    predictionSphere.Anchored = true
    predictionSphere.CanCollide = false
    predictionSphere.Material = Enum.Material.Neon
    predictionSphere.Color = Color3.fromRGB(100, 180, 255)
    predictionSphere.Transparency = 0.4
    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(100, 180, 255)
    light.Range = 8
    light.Brightness = 2
    light.Parent = predictionSphere
    predictionSphere.Parent = workspace
    return predictionSphere
end

local function updatePredictionSphere(targetPosition, dt)
    if not predictionSphere then return end
    local alpha = math.min(1, dt * SPHERE_SMOOTH_SPEED)
    predictionSphere.CFrame = predictionSphere.CFrame:Lerp(CFrame.new(targetPosition), alpha)
end

local function updateRotationAngular(lookDirection, rootPart)
    if not rootPart then return end
    if lookDirection.Magnitude < 0.01 then return end
    local currentLook = rootPart.CFrame.LookVector
    local targetDir = lookDirection.Unit
    local axis = currentLook:Cross(targetDir)
    local angle = math.asin(math.clamp(axis.Magnitude, -1, 1))
    if axis.Magnitude > 0.01 then
        local rotSpeed = 80
        rootPart.AssemblyAngularVelocity = axis.Unit * angle * rotSpeed
    else
        rootPart.AssemblyAngularVelocity = Vector3.zero
    end
end

local circleConnection = nil
local circleSafetyConn = nil

local function getRivalHubAimbotBat(char)
    local equipped = char and char:FindFirstChildOfClass("Tool")
    if equipped then
        local name = equipped.Name:lower()
        if name:find("bat", 1, true) or name:find("slap", 1, true) then return equipped end
    end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                if name:find("bat", 1, true) or name:find("slap", 1, true) then return tool end
            end
        end
    end
    return nil
end

local function getRivalHubRenderCFrame(root)
    if not root then return nil end
    local ok, rendered = pcall(root.GetRenderCFrame, root)
    return ok and rendered or root.CFrame
end

startCircleCombat = function()
    if circleConnection then return end
    local bubbleAimbot = _G.__RivalHubBubbleAimbotState or { nextSwingAt = 0, target = nil, intendedVelocity = Vector3.zero }
    _G.__RivalHubBubbleAimbotState = bubbleAimbot

    local function clearAngV()
        local c = LP.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        if r then
            local a = r:FindFirstChild("_RivalHub_AngV"); if a then a:Destroy() end
            local at = r:FindFirstChild("_RivalHub_Att"); if at then at:Destroy() end
        end
    end

    local function ensureAngV(r)
        if not r then return nil end
        local a = r:FindFirstChild("_RivalHub_AngV"); if a then a:Destroy() end
        local at = r:FindFirstChild("_RivalHub_Att"); if at then at:Destroy() end
        local att = Instance.new("Attachment")
        att.Name = "_RivalHub_Att"
        att.Parent = r
        local angV = Instance.new("AngularVelocity")
        angV.Name = "_RivalHub_AngV"
        angV.Attachment0 = att
        angV.RelativeTo = Enum.ActuatorRelativeTo.World
        angV.MaxTorque = math.huge
        angV.AngularVelocity = Vector3.zero
        angV.Parent = r
        return angV
    end

    circleConnection = RunService.RenderStepped:Connect(function()
        if not State.bypassBatEnabled then
            if circleConnection then circleConnection:Disconnect(); circleConnection = nil end
            if circleSafetyConn then circleSafetyConn:Disconnect(); circleSafetyConn = nil end
            clearAngV()
            return
        end

        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid or humanoid.Health <= 0 then
            clearAngV()
            return
        end
        humanoid.AutoRotate = false

        local angV = root:FindFirstChild("_RivalHub_AngV")
        if not angV or not angV.Parent then angV = ensureAngV(root) end

        local bat = getRivalHubAimbotBat(char)
        if bat and bat.Parent ~= char then
            pcall(humanoid.EquipTool, humanoid, bat)
        end
        if not bat then return end

        targetPlayer = getNearestPlayer()
        local targetRoot = targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
        local targetHum = targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid")
        if not targetRoot or not targetHum or targetHum.Health <= 0 then
            bubbleAimbot.target = nil
            if angV then angV.AngularVelocity = Vector3.zero end
            humanoid.AutoRotate = true
            return
        end

        bubbleAimbot.target = targetRoot
        local targetVel = targetRoot.AssemblyLinearVelocity or Vector3.zero
        local aimPos = targetRoot.Position + targetRoot.CFrame.LookVector * (targetVel.Magnitude < 0.1 and 1.5 or 5)
        local delta = aimPos - root.Position
        local horizontal = Vector3.new(delta.X, 0, delta.Z)
        local distance = delta.Magnitude

        local spd = tonumber(State.bypassBatSpeed) or tonumber(BYPASS_AIMBOT_SPEED) or 58
        if spd ~= spd or spd <= 0 or spd == math.huge then spd = 58 end

        if delta.Magnitude > 0.01 and horizontal.Magnitude > 0.01 and angV then
            local curY = root.Orientation.Y
            local yawD = (math.deg(math.atan2(-horizontal.X, -horizontal.Z)) - curY + 180) % 360 - 180
            local curX = root.Orientation.X
            local pitchD = (math.deg(math.atan2(delta.Y, horizontal.Magnitude)) - curX + 180) % 360 - 180
            local rotY = math.clamp(math.rad(yawD) * 40, -28, 28)
            local rotX = math.clamp(math.rad(pitchD) * 40, -28, 28)
            local yawR = math.rad(root.Orientation.Y)
            local fwd = Vector3.new(math.cos(yawR), 0, -math.sin(yawR))
            angV.AngularVelocity = Vector3.new(0, rotY, 0) + fwd * rotX
        elseif angV then
            angV.AngularVelocity = Vector3.zero
        end

        local unit = horizontal.Magnitude > 0.1 and horizontal.Unit or Vector3.zero
        local vertVel = math.clamp((aimPos.Y + 3.7 - root.Position.Y) * 19.5 + targetVel.Y * 0.8, -70, 110)
        if humanoid.FloorMaterial ~= Enum.Material.Air then
            vertVel = math.max(vertVel, 13)
        end

        local intended = Vector3.new(unit.X * spd, vertVel, unit.Z * spd)
        bubbleAimbot.intendedVelocity = intended
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(intended, 0.8)

        if horizontal.Magnitude > 0.3 then
            pcall(function() humanoid:Move(unit, false) end)
        else
            pcall(function() humanoid:Move(Vector3.zero, false) end)
        end

        if distance <= 12 then
            local now = tick()
            if now >= (bubbleAimbot.nextSwingAt or 0) then
                bubbleAimbot.nextSwingAt = now + 0.08
                pcall(bat.Activate, bat)
                local remote = bat:FindFirstChildWhichIsA("RemoteEvent")
                if remote then pcall(function() remote:FireServer() end) end
            end
        end
    end)

    circleSafetyConn = RunService.Heartbeat:Connect(function()
        if not State.bypassBatEnabled then
            if circleSafetyConn then circleSafetyConn:Disconnect(); circleSafetyConn = nil end
            return
        end
        local c = LP.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        if not r then return end
        local v = r.AssemblyLinearVelocity
        if math.abs(v.X) > 350 or math.abs(v.Z) > 350 then
            r.AssemblyLinearVelocity = bubbleAimbot.intendedVelocity or Vector3.zero
        end
    end)
end

stopCircleCombat = function()
    if circleConnection then
        circleConnection:Disconnect()
        circleConnection = nil
    end
    if circleSafetyConn then
        circleSafetyConn:Disconnect()
        circleSafetyConn = nil
    end
    do
        local c = LP.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        if r then
            local a = r:FindFirstChild("_RivalHub_AngV"); if a then a:Destroy() end
            local at = r:FindFirstChild("_RivalHub_Att"); if at then at:Destroy() end
        end
    end
    if predictionSphere then
        predictionSphere:Destroy()
        predictionSphere = nil
    end
    local char = LP.Character
    if char then
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.AutoRotate = true end
        local root = char:FindFirstChild("HumanoidRootPart")
        if root then root.AssemblyAngularVelocity = Vector3.zero end
    end
    targetPlayer = nil
    lastTargetPos = nil
    targetVelocity = Vector3.zero
    smoothedVelocity = Vector3.zero
    velocityHistory = {}
    accelerationHistory = {}
    aerialVelocityHistory = {}
    verticalVelocityHistory = {}
    aerialSmoothVelocity = Vector3.zero
    airborneTime = 0
    highYVelocityTime = 0
    previousDirection = nil
    wasAirborne = false
    lastYVelocity = 0
    peakHeight = 0
    isMultiJumping = false
    lastActivationTime = 0
    if _G.__RivalHubBubbleAimbotState then
        _G.__RivalHubBubbleAimbotState.target = nil
        _G.__RivalHubBubbleAimbotState.nextSwingAt = 0
    end
end

end

function stopAimbotAdapt()
    State.bypassBatEnabled = false
    if stopCircleCombat then pcall(stopCircleCombat) end
    _aimbotConn = nil
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if hum then
        hum.AutoRotate = (_prevAutoRotate == nil) and true or _prevAutoRotate
        hum.PlatformStand = false
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
    if root then
        root.AssemblyLinearVelocity = _V3new(0, -0.1, 0)
        root.AssemblyAngularVelocity = _V3zero
    end
    _prevAutoRotate = nil
    lastMoveDir = _V3zero
    _unsuppressBodyLock(true)
end

function startAimbotAdapt()
    State.bypassBatSpeed = tonumber(State.bypassBatSpeed) or tonumber(BYPASS_AIMBOT_SPEED) or 60
    State.bypassBatEnabled = true
    _suppressBodyLock()
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 and _prevAutoRotate == nil then _prevAutoRotate = hum0.AutoRotate end
    startCircleCombat()
end

function disableAutoBat()
    autoBatEnabled = false
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    stopAimbotAdapt()
end

function enableAutoBat()
    if autoLeftEnabled then
        autoLeftEnabled = false
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        stopAutoLeft()
    end
    if autoRightEnabled then
        autoRightEnabled = false
        if autoRightSetVisual then autoRightSetVisual(false) end
        stopAutoRight()
    end
    autoBatEnabled = true
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(true) end
    startAimbotAdapt()
end

function findBat()
    local char = LP.Character
    if not char then return nil end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local t = char:FindFirstChild(name)
        if t and t:IsA("Tool") then return t end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
            local t = bp:FindFirstChild(name)
            if t and t:IsA("Tool") then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then pcall(function() hum:EquipTool(t) end) end
                return t
            end
        end
    end
    for _, ch in ipairs(char:GetChildren()) do
        if ch:IsA("Tool") and (ch.Name:lower():find("bat") or ch.Name:lower():find("slap")) then
            return ch
        end
    end
    return nil
end

function isBatTool(tool)
    if not tool then return false end
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        if tool.Name == name then return true end
    end
    return tool.Name:lower():find("bat") or tool.Name:lower():find("slap")
end

function findBatForCounter()
    local char = LP.Character
    if not char then return nil end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local tool = char:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name))
        if tool then return tool end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
            return child
        end
    end
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") and (child.Name:lower():find("bat") or child.Name:lower():find("slap")) then
                return child
            end
        end
    end
    return nil
end

function swingBatForCounter(bat, character)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if bat.Parent ~= character and humanoid then
        pcall(function() humanoid:EquipTool(bat) end)
        task.wait(0.05)
    end
    local remote = bat:FindFirstChildOfClass("RemoteEvent") or bat:FindFirstChildOfClass("RemoteFunction")
    if remote and remote:IsA("RemoteEvent") then
        pcall(function() remote:FireServer() end)
        task.wait(0.1)
        pcall(function() remote:FireServer() end)
    else
        pcall(function() bat:Activate() end)
        task.wait(0.1)
        pcall(function() bat:Activate() end)
    end
end

batCounterDebounce = false

function stopBatCounter()
    if Conns.batCounter then
        Conns.batCounter:Disconnect()
        Conns.batCounter = nil
    end
    batCounterDebounce = false
end

function startBatCounter()
    if Conns.batCounter then return end
    Conns.batCounter = RunService.Heartbeat:Connect(function()
        if not batCounterEnabled then return end
        if batCounterDebounce then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown then
            batCounterDebounce = true
            _suppressBodyLock()
            task.spawn(function()
                task.wait(0.15)
                local bat = findBatForCounter()
                if bat then swingBatForCounter(bat, character) end
                task.wait(0.3)
                batCounterDebounce = false
                _unsuppressBodyLock(true)
            end)
        end
    end)
end

function findMedusa()
    local c = LP.Character
    if not c then return nil end
    for _, t in ipairs(c:GetChildren()) do
        if t:IsA("Tool") then
            local n = t.Name:lower()
            if n:find("medusa") or n:find("head") or n:find("stone") then return t end
        end
    end
    local bp = LP:FindFirstChild("Backpack")
    if bp then
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("medusa") or n:find("head") or n:find("stone") then return t end
            end
        end
    end
    return nil
end

function useMedusaCounter()
    if medusaDebounce then return end
    if _tick() - medusaLastUsed < MEDUSA_COOLDOWN then return end
    local c = LP.Character
    if not c then return end
    medusaDebounce = true
    local med = findMedusa()
    if not med then medusaDebounce = false; return end
    if med.Parent ~= c then
        local hum2 = c:FindFirstChildOfClass("Humanoid")
        if hum2 then hum2:EquipTool(med) end
    end
    pcall(function() med:Activate() end)
    medusaLastUsed = _tick()
    medusaDebounce = false
end

function onAnchorChanged(part)
    return part:GetPropertyChangedSignal("Anchored"):Connect(function()
        if medusaCounterEnabled and part.Anchored and part.Transparency == 1 then useMedusaCounter() end
    end)
end

function setupMedusaCounter(char)
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
    if not char or not medusaCounterEnabled then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            table.insert(Conns.anchor, onAnchorChanged(part))
        end
    end
    table.insert(Conns.anchor, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then
            table.insert(Conns.anchor, onAnchorChanged(part))
        end
    end))
end

function stopMedusaCounter()
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
end

local DROP_ASCEND_DURATION = 0.2
local DROP_ASCEND_SPEED = 150
local _dropConn = nil

function stopDropBrainrot()
    dropActive = false
    if _dropConn then
        _dropConn:Disconnect()
        _dropConn = nil
    end
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then pcall(t.Disconnect, t) end
    end
    dropConnections = {}
    local c = LP.Character
    if c then
        local root = c:FindFirstChild("HumanoidRootPart")
        if root then root.AssemblyLinearVelocity = _V3zero end
    end
    if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
    if mobSetDropBR then mobSetDropBR(false) end
end

function runDropBrainrot()
    if dropActive then return end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not root or not hum then return end
    if dropMode == 1 then
        local speedH = 0
        if root then
            local vel = root.AssemblyLinearVelocity
            speedH = _V3new(vel.X, 0, vel.Z).Magnitude
        end
        local cooldown = (speedH > 5) and 0.6 or 0.25
        if _tick() - lastDropTime < cooldown then return end
        lastDropTime = _tick()
        dropActive = true
        if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
        if mobSetDropBR then mobSetDropBR(true) end
        local wasAutoBat = false
        if autoBatEnabled then
            wasAutoBat = true
            disableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(false) end
            if mobSetAutoBat then mobSetAutoBat(false) end
        end
        local function finishDrop(threadRef)
            if threadRef and dropConnections then
                for i = #dropConnections, 1, -1 do
                    if dropConnections[i] == threadRef then
                        table.remove(dropConnections, i)
                        break
                    end
                end
            end
            dropActive = false
            local c = LP.Character
            if c then
                local r = c:FindFirstChild("HumanoidRootPart")
                local h = c:FindFirstChildOfClass("Humanoid")
                if r then
                    r.AssemblyLinearVelocity = _V3zero
                    r.AssemblyAngularVelocity = _V3zero
                    if r.Position.Y < -100 then
                        r.CFrame = _CFnew(r.Position.X, 5, r.Position.Z)
                    end
                    local rp = RaycastParams.new()
                    rp.FilterDescendantsInstances = {c}
                    rp.FilterType = Enum.RaycastFilterType.Exclude
                    local rr = workspace:Raycast(r.Position, _V3new(0, -2000, 0), rp)
                    if rr then
                        local off = (h and h.HipHeight or 2) + (r.Size.Y / 2)
                        r.CFrame = _CFnew(r.Position.X, rr.Position.Y + off, r.Position.Z)
                    end
                    if h and h.Health > 0 then h:ChangeState(Enum.HumanoidStateType.Running) end
                end
            end
            if wasAutoBat then
                enableAutoBat()
                if autoBatSetVisual then autoBatSetVisual(true) end
                if mobSetAutoBat then mobSetAutoBat(true) end
            end
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
        end
        local flingThread = nil
        flingThread = task.spawn(function()
            local startTime = _tick()
            while dropActive and (_tick() - startTime) < 0.25 do
                RunService.Heartbeat:Wait()
                local c = LP.Character
                local r = c and c:FindFirstChild("HumanoidRootPart")
                if not r then break end
                local vel = r.AssemblyLinearVelocity
                vel = _V3new(0, vel.Y, 0)
                r.AssemblyLinearVelocity = vel * 10000 + _V3new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if r and r.Parent then r.AssemblyLinearVelocity = vel end
                RunService.Stepped:Wait()
                if r and r.Parent then r.AssemblyLinearVelocity = vel + _V3new(0, 0.1, 0) end
            end
            finishDrop(flingThread)
        end)
        table.insert(dropConnections, flingThread)
        task.delay(0.35, function()
            if dropActive then finishDrop(flingThread) end
        end)
        return
    end

    if autoBatEnabled then
        autoBatEnabled = false
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
        if stopAimbotAdapt then stopAimbotAdapt() end
    end
    dropActive = true
    if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
    if mobSetDropBR then mobSetDropBR(false) end
    local t0 = _tick()
    if _dropConn then _dropConn:Disconnect() end
    _dropConn = RunService.Heartbeat:Connect(function()
        local r = char and char:FindFirstChild("HumanoidRootPart")
        if not r then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            dropActive = false
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        if _tick() - t0 >= DROP_ASCEND_DURATION then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            local rp = _RayParams_new()
            rp.FilterDescendantsInstances = {char}
            rp.FilterType = Enum.RaycastFilterType.Exclude
            local rr = workspace:Raycast(r.Position, _V3new(0, -2000, 0), rp)
            if rr then
                local hum2 = char:FindFirstChildOfClass("Humanoid")
                local off = ((hum2 and hum2.HipHeight) or 2) + (r.Size.Y / 2)
                r.CFrame = _CFnew(r.Position.X, rr.Position.Y + off, r.Position.Z)
                r.AssemblyLinearVelocity = _V3zero
            end
            dropActive = false
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        r.Velocity = _V3new(r.Velocity.X, DROP_ASCEND_SPEED, r.Velocity.Z)
    end)
end

function executeDropWithToggle(setVisual)
    if dropActive then return end
    task.spawn(function()
        if setVisual then setVisual(true) end
        runDropBrainrot()
        while dropActive do task.wait() end
        task.wait(0.1)
        if setVisual then setVisual(false) end
    end)
end

local _alSaved = setmetatable({}, { __mode = "k" })
local _alDetached = {}
local _alAnimators = setmetatable({}, { __mode = "k" })
local _alStoppedTracks = setmetatable({}, { __mode = "k" })
local _alGeneration = 0
local _alScanCancel = nil
local _alConns = {}
local _alLightOrig = nil
local _alRunning = false

local AL_LOW_FLAGS = {
    {"DFIntClusterSenderMaxJoinBandwidthBps", "2100000000"},
    {"DFIntClusterSenderMaxUpdateBandwidthBps", "2100000000"},
    {"DFIntServerFramesBetweenJoins", "1"},
    {"DFIntRaknetBandwidthInfluxHundredthsPercentageV2", "10000"},
    {"DFIntConnectionMTUSize", "1400"},
    {"FIntRakNetResendBufferArrayLength", "1024"},
    {"DFIntRakNetNakResendDelayMsMax", "1"},
    {"DFIntWaitOnUpdateNetworkLoopEndedMS", "100"},
    {"DFIntWaitOnRecvFromLoopEndedMS", "100"},
    {"DFIntLargePacketQueueSizeCutoffMB", "1000"},
    {"DFIntSendRakNetStatsInterval", "2147483647"},
    {"DFIntRakNetLoopMs", "1"},
    {"DFIntRakNetSelectTimeoutMs", "1"},
    {"DFIntNetworkClusterPacketCacheNumParallelTasks", "8"},
    {"DFIntReplicationDataCacheNumParallelTasks", "8"},
    {"DFIntMegaReplicatorNumParallelTasks", "16"},
    {"DFIntMaxProcessPacketsStepsPerCyclic", "512"},
    {"DFIntMaxProcessPacketsStepsAccumulated", "0"},
    {"DFIntMaxProcessPacketsJobScaling", "1000"},
    {"DFIntClientPacketMaxFrameMicroseconds", "200000"},
    {"DFIntClientPacketExcessMicroseconds", "10000"},
    {"DFIntClientPacketMinMicroseconds", "1"},
    {"DFIntClientPacketMaxDelayMs", "1"},
    {"DFIntMaxWaitTimeBeforeForcePacketProcessMS", "1"},
    {"DFIntMaxFrameBufferSize", "4"},
    {"DFIntBufferCompressionThreshold", "100"},
    {"DFIntOverrideISRReplicatorStepBandwidthBytes", "131072"},
    {"DFIntTaskSchedulerJobInitThreads", "8"},
    {"DFIntTaskSchedulerJobInGameThreads", "8"},
    {"FIntTaskSchedulerAutoThreadLimit", "16"},
    {"FIntTaskSchedulerAsyncTasksMinimumThreadCount", "4"},
    {"DFIntRuntimeConcurrency", "16"},
    {"FIntSimWorldTaskQueueParallelTasks", "20"},
    {"DFIntHttpBatchLimit", "256"},
    {"FIntHttpBatchLimit", "256"},
    {"DFIntHttpCurlConnectionCacheSize", "512"},
    {"FIntDefaultMeshCacheSizeMB", "512"},
    {"DFIntMemCacheMaxCapacityMB", "256"},
    {"DFIntNumAssetsMaxToPreload", "1"},
    {"DFFlagEnableSoundPreloading", "false"},
    {"FFlagSlimContentProvider", "true"},
    {"DFFlagDebugSkipMeshVoxelizer", "true"},
    {"DFFlagTextureQualityOverrideEnabled", "true"},
    {"DFIntTextureQualityOverride", "0"},
    {"FIntDebugTextureManagerSkipMips", "7"},
    {"DFIntDebugLimitMinTextureResolutionWhenSkipMips", "8"},
    {"FFlagTM2SkipMipsForUnstreamable2", "true"},
    {"DFFlagDoNotSkipMipsBasedOnSystemMemoryPS", "true"},
    {"FFlagRenderUseTextureManager224", "false"},
    {"DFIntDebugFRMQualityLevelOverride", "1"},
    {"DFFlagDebugPauseVoxelizer", "true"},
    {"FFlagFastGPULightCulling3", "true"},
    {"FIntRenderLocalLightFadeInMs", "0"},
    {"FIntRenderLocalLightUpdatesMax", "1"},
    {"FIntRenderShadowmapBias", "0"},
    {"FIntSSAOMipLevels", "0"},
    {"FIntDebugForceMSAASamples", "1"},
    {"FIntDebugFRMOptionalMSAALevelOverride", "0"},
    {"FIntRobloxGuiBlurIntensity", "0"},
    {"FIntFRMMinGrassDistance", "0"},
    {"FIntFRMMaxGrassDistance", "0"},
    {"DFFlagCoreScriptTelemetry2", "false"},
    {"DFFlagBrowserTrackerIdTelemetryEnabled", "false"},
    {"FFlagPerfDataOnTelemetryV2", "false"},
    {"FFlagSendRenderFidelityTelemetry2", "false"},
    {"FFlagEnableTelemetryServiceMemoryCPUInfo", "false"},
    {"DFIntTelemetryProfilerHundredthsPercentage", "0"},
    {"FIntTelemetryProfilerFrequency", "0"},
    {"FIntPerformanceTelemetryQueueProcessLimit", "0"},
    {"DFIntContentProviderPreloadHangTelemetryHundredthsPercentage", "0"},
}

local function _alApplyLowFlags()
    local env = (getgenv and getgenv()) or _G
    local setter = rawget(env, "setfflag") or rawget(_G, "set_fflag")
    local getter = rawget(env, "getfflag") or rawget(_G, "get_fflag")
    if type(setter) ~= "function" then return end
    for _, flag in ipairs(AL_LOW_FLAGS) do
        local canSet = true
        if type(getter) == "function" then
            local ok, current = pcall(getter, flag[1])
            canSet = ok and current ~= nil
        end
        if canSet then pcall(setter, flag[1], tostring(flag[2])) end
    end
end

local function _alSaveLighting()
    if _alLightOrig then return end
    _alLightOrig = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        Ambient = Lighting.Ambient,
        GlobalShadows = Lighting.GlobalShadows,
        EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
        FogStart = Lighting.FogStart,
        FogEnd = Lighting.FogEnd,
    }
end

local function _alApplyLowPermanentSettings()
    pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
    pcall(function()
        UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
    end)
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.EnvironmentDiffuseScale = 0.35
        Lighting.EnvironmentSpecularScale = 0.35
        Lighting.FogStart = 0
        Lighting.FogEnd = 1e10
        Lighting.Brightness = math.max(tonumber(Lighting.Brightness) or 2, 2.5)
        local amb = Lighting.Ambient
        local out = Lighting.OutdoorAmbient
        Lighting.Ambient = Color3.fromRGB(math.max(amb.R * 255, 145), math.max(amb.G * 255, 145), math.max(amb.B * 255, 145))
        Lighting.OutdoorAmbient = Color3.fromRGB(math.max(out.R * 255, 155), math.max(out.G * 255, 155), math.max(out.B * 255, 155))
    end)
    pcall(function()
        local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
        if atmosphere then
            atmosphere.Density = 0
            atmosphere.Glare = 0
            atmosphere.Haze = 0
        end
    end)
    pcall(function()
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        if terrain then
            terrain.Decoration = false
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            local clouds = terrain:FindFirstChildOfClass("Clouds")
            if clouds then clouds.Enabled = false end
        end
    end)
end

local function _alChange(object, property, value)
    pcall(function()
        local original = object[property]
        if original == value then return end
        object[property] = value
        local bucket = _alSaved[object]
        if not bucket then bucket = {}; _alSaved[object] = bucket end
        if not bucket[property] then bucket[property] = { value = original } end
    end)
end

local function _alIsProtectedVisual(object)
    local char = LP.Character
    if char and (object == char or object:IsDescendantOf(char)) then return true end
    if object:GetAttribute("_AdaptDuelsSky") == true then return true end
    local parent = object
    while parent and parent ~= workspace do
        if parent:IsA("LayerCollector") or parent:IsA("GuiObject") or parent:IsA("GuiBase2d") then
            return true
        end
        local name = parent.Name or ""
        if name:match("^Crystal") or name:match("^Eclipse") or name:match("^ESP_")
            or name:match("^BloodHounds") or name:match("^RivalHub") then
            return true
        end
        parent = parent.Parent
    end
    return false
end

function applyAntiLagDerender(obj)
    pcall(function()
        if not _alRunning then return end
        if _alIsProtectedVisual(obj) then return end

        if obj:IsA("Terrain") then
            _alChange(obj, "Decoration", false)
            _alChange(obj, "WaterWaveSize", 0)
            _alChange(obj, "WaterWaveSpeed", 0)
            _alChange(obj, "WaterReflectance", 0)
            _alChange(obj, "WaterTransparency", 1)
        end
        if obj:IsA("BasePart") then
            _alChange(obj, "Material", Enum.Material.Plastic)
            _alChange(obj, "MaterialVariant", "")
            _alChange(obj, "Reflectance", 0)
            _alChange(obj, "CastShadow", false)
            if obj:IsA("MeshPart") then
                _alChange(obj, "TextureID", "")
                _alChange(obj, "RenderFidelity", Enum.RenderFidelity.Performance)
                _alChange(obj, "DoubleSided", false)
            elseif obj:IsA("PartOperation") then
                _alChange(obj, "RenderFidelity", Enum.RenderFidelity.Performance)
            end
        elseif obj:IsA("SpecialMesh") then
            _alChange(obj, "TextureId", "")
        elseif obj:IsA("SurfaceAppearance") then
            _alDetached[obj] = true
            _alChange(obj, "Parent", nil)
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            _alChange(obj, "Transparency", 1)
            _alChange(obj, "Texture", "")
        elseif obj:IsA("ParticleEmitter") then
            _alChange(obj, "Enabled", false)
            _alChange(obj, "Rate", 0)
            pcall(function() obj:Clear() end)
        elseif obj:IsA("Trail") then
            _alChange(obj, "Enabled", false)
            pcall(function() obj:Clear() end)
        elseif obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke")
            or obj:IsA("Sparkles") or obj:IsA("Light") or obj:IsA("PostEffect")
            or obj:IsA("Clouds") then
            _alChange(obj, "Enabled", false)
        elseif obj:IsA("Atmosphere") then
            _alChange(obj, "Density", 0)
            _alChange(obj, "Haze", 0)
            _alChange(obj, "Glare", 0)
        elseif obj:IsA("Sky") then
            for _, face in ipairs({"SkyboxBk","SkyboxDn","SkyboxFt","SkyboxLf","SkyboxRt","SkyboxUp","SunTextureId","MoonTextureId"}) do
                _alChange(obj, face, "")
            end
            _alChange(obj, "StarCount", 0)
            _alChange(obj, "CelestialBodiesShown", false)
        elseif obj:IsA("Shirt") then
            _alChange(obj, "ShirtTemplate", "")
        elseif obj:IsA("Pants") then
            _alChange(obj, "PantsTemplate", "")
        elseif obj:IsA("ShirtGraphic") then
            _alChange(obj, "Graphic", "")
        elseif obj:IsA("Animator") then
            if not _alAnimators[obj] then
                local char = LP.Character
                if not (char and obj:IsDescendantOf(char)) then
                    _alAnimators[obj] = true
                    local token = _alGeneration
                    local ok, conn = pcall(function()
                        return obj.AnimationPlayed:Connect(function(track)
                            if not _alRunning or _alGeneration ~= token then return end
                            task.defer(function()
                                if _alRunning and _alGeneration == token then
                                    pcall(function() track:Stop(0) end)
                                end
                            end)
                        end)
                    end)
                    if ok then table.insert(_alConns, conn) end
                    pcall(function()
                        for _, track in ipairs(obj:GetPlayingAnimationTracks()) do
                            if track.IsPlaying then
                                _alStoppedTracks[track] = {
                                    animator = obj,
                                    time = track.TimePosition,
                                    speed = track.Speed,
                                }
                                track:Stop(0)
                            end
                        end
                    end)
                end
            end
        end
    end)
end

function enableAntiLag()
    if _alRunning then return end
    _alRunning = true
    antiLagEnabled = true
    _alGeneration = _alGeneration + 1
    local token = _alGeneration

    _alSaveLighting()
    _alApplyLowFlags()
    _alApplyLowPermanentSettings()

    for _, delaySeconds in ipairs({2, 6, 12, 20}) do
        task.delay(delaySeconds, function()
            if _alRunning and _alGeneration == token then
                _alApplyLowFlags()
            end
        end)
    end

    pcall(function() game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen() end)

    table.insert(_alConns, workspace.DescendantAdded:Connect(function(obj)
        task.defer(function()
            if _alRunning and _alGeneration == token then
                pcall(applyAntiLagDerender, obj)
            end
        end)
    end))
    table.insert(_alConns, Lighting.DescendantAdded:Connect(function(obj)
        task.defer(function()
            if _alRunning and _alGeneration == token then
                pcall(applyAntiLagDerender, obj)
            end
        end)
    end))

    local function walkBatched(roots, apply, shouldContinue)
        task.spawn(function()
            local pending = {}
            for _, root in ipairs(roots) do
                if root then
                    local ok, children = pcall(function() return root:GetChildren() end)
                    if ok then for _, c in ipairs(children) do table.insert(pending, c) end end
                end
            end
            while #pending > 0 and _alRunning and _alGeneration == token and shouldContinue() do
                local deadline = os.clock() + 0.0008
                while #pending > 0 and os.clock() < deadline do
                    local obj = table.remove(pending)
                    pcall(apply, obj)
                    local ok, children = pcall(function() return obj:GetChildren() end)
                    if ok then for _, c in ipairs(children) do table.insert(pending, c) end end
                end
                RunService.Heartbeat:Wait()
            end
        end)
    end

    walkBatched({workspace, Lighting}, applyAntiLagDerender, function()
        return _alRunning and _alGeneration == token
    end)
end

function disableAntiLag()
    if not _alRunning then
        antiLagEnabled = false
        return
    end
    _alRunning = false
    antiLagEnabled = false
    _alGeneration = _alGeneration + 1

    if _alScanCancel then pcall(_alScanCancel); _alScanCancel = nil end

    for _, conn in ipairs(_alConns) do pcall(function() conn:Disconnect() end) end
    _alConns = {}

    for object, properties in pairs(_alSaved) do
        for property, original in pairs(properties) do
            pcall(function() object[property] = original.value end)
        end
    end
    _alSaved = setmetatable({}, { __mode = "k" })
    _alDetached = {}
    _alAnimators = setmetatable({}, { __mode = "k" })

    for track, state in pairs(_alStoppedTracks) do
        pcall(function()
            if state.animator.Parent and not track.IsPlaying then
                track:Play(0, 1, state.speed)
                track.TimePosition = state.time
            end
        end)
    end
    _alStoppedTracks = setmetatable({}, { __mode = "k" })

    if _alLightOrig then
        pcall(function()
            Lighting.Brightness = _alLightOrig.Brightness
            Lighting.ClockTime = _alLightOrig.ClockTime
            Lighting.OutdoorAmbient = _alLightOrig.OutdoorAmbient
            Lighting.Ambient = _alLightOrig.Ambient
            Lighting.GlobalShadows = _alLightOrig.GlobalShadows
            Lighting.EnvironmentDiffuseScale = _alLightOrig.EnvironmentDiffuseScale
            Lighting.EnvironmentSpecularScale = _alLightOrig.EnvironmentSpecularScale
            Lighting.FogStart = _alLightOrig.FogStart
            Lighting.FogEnd = _alLightOrig.FogEnd
        end)
        _alLightOrig = nil
    end
end

function applyStretchFOV(val)
    local cam = workspace.CurrentCamera
    if cam then pcall(function() cam.FieldOfView = val end) end
end

function enableStretch()
    if stretchConn then return end
    stretchEnabled = true
    local cam = workspace.CurrentCamera
    if not cam then return end
    origFOV = cam.FieldOfView or 70
    applyStretchFOV(stretchFOV)
    stretchConn = RunService.RenderStepped:Connect(function()
        if not stretchEnabled then
            stretchConn:Disconnect()
            stretchConn = nil
            return
        end
        local c = workspace.CurrentCamera
        if c then c.CFrame = c.CFrame * _CFnew(0,0,0,1,0,0,0,0.7,0,0,0,1) end
    end)
    if stretchFovConn then stretchFovConn:Disconnect() end
    stretchFovConn = RunService.RenderStepped:Connect(function()
        if stretchEnabled then applyStretchFOV(stretchFOV)
        else stretchFovConn:Disconnect(); stretchFovConn = nil end
    end)
end

function disableStretch()
    stretchEnabled = false
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
    if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end
    local cam = workspace.CurrentCamera
    if cam then pcall(function() cam.FieldOfView = origFOV or 70 end) end
end

local function saveLightingState()
    if _originalLighting then return end
    _originalLighting = {
        Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime,
        OutdoorAmbient = Lighting.OutdoorAmbient, GlobalShadows = Lighting.GlobalShadows,
        FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart,
        FogColor = Lighting.FogColor, Ambient = Lighting.Ambient,
        ColorCorrection = nil, Bloom = nil,
    }
    for _, e in ipairs(Lighting:GetChildren()) do
        if e:IsA("ColorCorrectionEffect") then
            _originalLighting.ColorCorrection = { Enabled = e.Enabled, Brightness = e.Brightness, Contrast = e.Contrast, Saturation = e.Saturation, TintColor = e.TintColor }
        elseif e:IsA("BloomEffect") then
            _originalLighting.Bloom = { Enabled = e.Enabled, Intensity = e.Intensity, Size = e.Size, Threshold = e.Threshold }
        end
    end
end

local function restoreLightingState()
    if not _originalLighting then return end
    local old = _originalLighting
    Lighting.Brightness = old.Brightness
    Lighting.ClockTime = old.ClockTime
    Lighting.OutdoorAmbient = old.OutdoorAmbient
    Lighting.GlobalShadows = old.GlobalShadows
    Lighting.FogEnd = old.FogEnd
    Lighting.FogStart = old.FogStart
    Lighting.FogColor = old.FogColor
    Lighting.Ambient = old.Ambient
    if old.ColorCorrection then
        local cc = Lighting:FindFirstChildOfClass("ColorCorrectionEffect")
        if cc then
            cc.Enabled = old.ColorCorrection.Enabled; cc.Brightness = old.ColorCorrection.Brightness
            cc.Contrast = old.ColorCorrection.Contrast; cc.Saturation = old.ColorCorrection.Saturation
            cc.TintColor = old.ColorCorrection.TintColor
        end
    end
    if old.Bloom then
        local bloom = Lighting:FindFirstChildOfClass("BloomEffect")
        if bloom then
            bloom.Enabled = old.Bloom.Enabled; bloom.Intensity = old.Bloom.Intensity
            bloom.Size = old.Bloom.Size; bloom.Threshold = old.Bloom.Threshold
        end
    end
end

SKY_PRESETS_LIST = {"Off","Night","Aurora","Sunset","Galaxy","Cyber","Sakura","Pink Night","Blood Moon","Emerald Dawn","Volcanic","Arctic","Midnight Ocean","Vaporwave","Toxic","Solar Eclipse","Hellscape","Heaven","Storm","Sunrise","Deep Space","Lavender Dream","Inferno","Mint Sky"}

SKY_PRESETS = {
    ["Off"]={kind="off"},
    ["Night"]={clock=22,brightness=2,ambient={110,100,130},outAmb={120,110,140},sky={stars=4000,moon=18,sun=0,moonTex=true},atm={dens=0.45,color={120,60,180},decay={60,20,100},glare=0.5,haze=1.2}},
    ["Aurora"]={clock=14,brightness=3,ambient={150,120,150},outAmb={160,130,150},atm={dens=0.55,color={255,80,200},decay={255,20,150},glare=2.5,haze=3},clouds={cover=0.7,dens=0.7,color={255,240,250}}},
    ["Sunset"]={clock=17.2,brightness=2.5,ambient={170,120,100},outAmb={180,130,110},sky={stars=0,sun=25,moon=0},atm={dens=0.5,color={255,130,60},decay={255,80,30},glare=2,haze=2.5},clouds={cover=0.55,dens=0.55,color={255,200,140}}},
    ["Galaxy"]={clock=0,brightness=1.5,ambient={70,60,100},outAmb={80,70,110},sky={stars=10000,moon=30,sun=0},atm={dens=0.15,color={40,20,80},decay={20,10,50},glare=0.3,haze=0.5}},
    ["Cyber"]={clock=21,brightness=2.2,ambient={90,130,170},outAmb={100,140,180},sky={stars=2000,moon=12},atm={dens=0.4,color={0,200,255},decay={150,0,255},glare=2,haze=2},clouds={cover=0.4,dens=0.6,color={100,200,255}}},
    ["Sakura"]={clock=11,brightness=3.5,ambient={170,150,160},outAmb={180,160,170},sky={sun=8},atm={dens=0.3,color={255,200,220},decay={255,170,200},glare=1,haze=1.5},clouds={cover=0.6,dens=0.4,color={255,250,252}}},
    ["Pink Night"]={clock=23,brightness=2.2,ambient={120,60,110},outAmb={140,70,120},sky={stars=5000,moon=22,sun=0,moonTex=true},atm={dens=0.5,color={255,80,180},decay={140,30,100},glare=0.7,haze=1.4},clouds={cover=0.3,dens=0.5,color={180,90,150}}},
    ["Blood Moon"]={clock=22.5,brightness=1.6,ambient={130,40,40},outAmb={150,50,50},sky={stars=1500,moon=28,sun=0,moonTex=true},atm={dens=0.6,color={220,30,30},decay={120,10,10},glare=1.4,haze=2},clouds={cover=0.5,dens=0.7,color={120,30,30}}},
    ["Emerald Dawn"]={clock=6.5,brightness=2.8,ambient={130,170,140},outAmb={140,180,150},sky={sun=18,moon=0,stars=0},atm={dens=0.4,color={80,200,140},decay={40,150,90},glare=1.8,haze=2.2},clouds={cover=0.5,dens=0.5,color={200,255,220}}},
    ["Volcanic"]={clock=19,brightness=2,ambient={180,80,40},outAmb={200,90,50},sky={stars=200,sun=12,moon=0},atm={dens=0.75,color={255,60,0},decay={180,20,0},glare=3,haze=3.5},clouds={cover=0.8,dens=0.9,color={120,40,20}}},
    ["Arctic"]={clock=9,brightness=3.2,ambient={200,220,235},outAmb={210,230,245},sky={sun=10,stars=0,moon=0},atm={dens=0.3,color={180,220,255},decay={140,200,240},glare=1.5,haze=1.8},clouds={cover=0.7,dens=0.6,color={250,253,255}}},
    ["Midnight Ocean"]={clock=1.5,brightness=1.7,ambient={60,90,130},outAmb={70,100,140},sky={stars=6000,moon=24,sun=0,moonTex=true},atm={dens=0.5,color={20,60,140},decay={10,30,90},glare=0.6,haze=1.5}},
    ["Vaporwave"]={clock=19.5,brightness=2.4,ambient={180,120,200},outAmb={190,130,210},sky={stars=1000,moon=14},atm={dens=0.45,color={255,100,220},decay={120,60,255},glare=2.2,haze=2.4},clouds={cover=0.55,dens=0.55,color={200,150,255}}},
    ["Toxic"]={clock=13,brightness=2.5,ambient={140,180,80},outAmb={150,190,90},atm={dens=0.55,color={100,220,40},decay={60,150,20},glare=1.8,haze=2.6},clouds={cover=0.65,dens=0.7,color={180,255,120}}},
    ["Solar Eclipse"]={clock=12,brightness=0.9,ambient={50,40,60},outAmb={60,50,70},sky={stars=3500,sun=22,moon=0},atm={dens=0.5,color={255,140,40},decay={30,20,40},glare=2.8,haze=1.8}},
    ["Hellscape"]={clock=18,brightness=1.8,ambient={200,60,30},outAmb={220,70,40},sky={stars=100,sun=30,moon=0},atm={dens=0.85,color={255,30,0},decay={120,0,0},glare=3.5,haze=4},clouds={cover=0.95,dens=0.95,color={80,20,10}}},
    ["Heaven"]={clock=12,brightness=4,ambient={240,235,210},outAmb={250,245,220},sky={sun=16,moon=0,stars=0},atm={dens=0.25,color={255,250,220},decay={255,240,200},glare=3,haze=1.5},clouds={cover=0.85,dens=0.5,color={255,255,255}}},
    ["Storm"]={clock=15,brightness=1.4,ambient={90,90,110},outAmb={100,100,120},sky={stars=0,sun=6,moon=0},atm={dens=0.65,color={80,90,120},decay={40,50,80},glare=0.5,haze=3},clouds={cover=0.95,dens=0.95,color={60,65,80}}},
    ["Sunrise"]={clock=6.2,brightness=2.8,ambient={220,180,130},outAmb={230,190,140},sky={sun=22,stars=0,moon=0},atm={dens=0.45,color={255,180,100},decay={255,140,80},glare=2.4,haze=2.2},clouds={cover=0.4,dens=0.4,color={255,220,180}}},
    ["Deep Space"]={clock=0,brightness=1,ambient={30,25,50},outAmb={40,35,60},sky={stars=15000,moon=0,sun=0},atm={dens=0.08,color={15,5,40},decay={5,0,20},glare=0.2,haze=0.3}},
    ["Lavender Dream"]={clock=18.5,brightness=2.6,ambient={180,160,220},outAmb={190,170,230},sky={stars=800,moon=16,sun=0},atm={dens=0.4,color={200,160,255},decay={160,120,220},glare=1.4,haze=1.8},clouds={cover=0.55,dens=0.5,color={220,200,255}}},
    ["Inferno"]={clock=17.5,brightness=2.2,ambient={220,100,40},outAmb={235,110,50},sky={sun=26,moon=0,stars=0},atm={dens=0.6,color={255,90,20},decay={200,40,0},glare=3,haze=3.2},clouds={cover=0.7,dens=0.7,color={200,80,40}}},
    ["Mint Sky"]={clock=10,brightness=3.2,ambient={180,230,210},outAmb={190,240,220},sky={sun=10},atm={dens=0.32,color={150,255,210},decay={100,220,180},glare=1.6,haze=1.6},clouds={cover=0.55,dens=0.45,color={240,255,250}}},
}

local function _vC3(t) return Color3.fromRGB(t[1], t[2], t[3]) end

function _v4mpClearSky()
    for _, child in ipairs(Lighting:GetChildren()) do
        if child:GetAttribute("_AdaptDuelsSky") then
            pcall(function() child:Destroy() end)
        end
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if terrain then
        for _, child in ipairs(terrain:GetChildren()) do
            if child:GetAttribute("_AdaptDuelsSky") then
                pcall(function() child:Destroy() end)
            end
        end
    end
end

function applyCustomSky(mode)
    _v4mpClearSky()
    local preset = SKY_PRESETS[mode]
    if not preset or preset.kind == "off" then
        Lighting.ClockTime = 14
        Lighting.Brightness = 2
        Lighting.OutdoorAmbient = Color3.fromRGB(127,127,127)
        Lighting.Ambient = Color3.fromRGB(127,127,127)
        Lighting.FogEnd = 100000
        Lighting.GlobalShadows = true
        skyTheme = "Off"
        return
    end
    Lighting.FogStart = 0
    Lighting.FogEnd = 100000
    Lighting.FogColor = Color3.fromRGB(200,200,200)
    Lighting.ColorShift_Top = Color3.fromRGB(0,0,0)
    Lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0)
    Lighting.GlobalShadows = true
    Lighting.ClockTime = preset.clock or 14
    Lighting.Brightness = math.max(tonumber(preset.brightness) or 2, 2.5)
    if preset.outAmb then Lighting.OutdoorAmbient = _vC3(preset.outAmb) end
    if preset.ambient then Lighting.Ambient = _vC3(preset.ambient) end
    local amb = Lighting.Ambient
    local out = Lighting.OutdoorAmbient
    Lighting.Ambient = Color3.fromRGB(math.max(amb.R * 255, 135), math.max(amb.G * 255, 135), math.max(amb.B * 255, 135))
    Lighting.OutdoorAmbient = Color3.fromRGB(math.max(out.R * 255, 145), math.max(out.G * 255, 145), math.max(out.B * 255, 145))
    if preset.sky then
        local skyInst = Instance.new("Sky")
        skyInst:SetAttribute("_AdaptDuelsSky", true)
        if preset.sky.stars then skyInst.StarCount = preset.sky.stars end
        if preset.sky.moon then skyInst.MoonAngularSize = preset.sky.moon end
        if preset.sky.sun then skyInst.SunAngularSize = preset.sky.sun end
        if preset.sky.moonTex then skyInst.MoonTextureId = "rbxasset://sky/moon.jpg" end
        skyInst.Parent = Lighting
    end
    if preset.atm then
        local atm = Instance.new("Atmosphere")
        atm:SetAttribute("_AdaptDuelsSky", true)
        atm.Density = preset.atm.dens or 0.3
        atm.Color = _vC3(preset.atm.color)
        atm.Decay = _vC3(preset.atm.decay)
        atm.Glare = preset.atm.glare or 1
        atm.Haze = preset.atm.haze or 1
        atm.Parent = Lighting
    end
    local terrain = workspace:FindFirstChildOfClass("Terrain")
    if preset.clouds and terrain then
        local clouds = Instance.new("Clouds")
        clouds:SetAttribute("_AdaptDuelsSky", true)
        clouds.Cover = preset.clouds.cover or 0.5
        clouds.Density = preset.clouds.dens or 0.5
        clouds.Color = _vC3(preset.clouds.color)
        clouds.Parent = terrain
    end
    skyTheme = mode
end

function enableVividGraphics()
    if vividGraphicsEnabled and #_vividEffects > 0 then return end
    vividGraphicsEnabled = true
    for _, eff in ipairs(_vividEffects) do
        pcall(function() eff:Destroy() end)
    end
    _vividEffects = {}
    local color = Instance.new("ColorCorrectionEffect")
    color.Parent = Lighting
    color.Saturation = 0.6; color.Contrast = 0.4; color.Brightness = 0.05
    color.TintColor = Color3.fromRGB(255, 240, 220)
    table.insert(_vividEffects, color)
    local bloom = Instance.new("BloomEffect")
    bloom.Parent = Lighting
    bloom.Intensity = 0.8; bloom.Size = 24; bloom.Threshold = 1
    table.insert(_vividEffects, bloom)
    local atmosphere = Instance.new("Atmosphere")
    atmosphere.Parent = Lighting
    atmosphere.Density = 0.3; atmosphere.Offset = 0.25
    atmosphere.Color = Color3.fromRGB(199, 199, 255)
    atmosphere.Decay = Color3.fromRGB(106, 112, 125)
    atmosphere.Glare = 0.2; atmosphere.Haze = 1
    table.insert(_vividEffects, atmosphere)
    local sun = Instance.new("SunRaysEffect")
    sun.Parent = Lighting
    sun.Intensity = 0.2; sun.Spread = 0.8
    table.insert(_vividEffects, sun)
    local dof = Instance.new("DepthOfFieldEffect")
    dof.Parent = Lighting
    dof.FocusDistance = 25; dof.InFocusRadius = 10
    dof.NearIntensity = 0.2; dof.FarIntensity = 0.4
    table.insert(_vividEffects, dof)
    task.spawn(function()
        while vividGraphicsEnabled and color and color.Parent do
            color.Contrast = 0.35 + math.sin(tick() * 2) * 0.05
            task.wait(0.03)
        end
    end)
end

function disableVividGraphics()
    vividGraphicsEnabled = false
    for _, eff in ipairs(_vividEffects) do
        pcall(function() eff:Destroy() end)
    end
    _vividEffects = {}
end

function toggleVividGraphics(on)
    if on then enableVividGraphics() else disableVividGraphics() end
    saveAllSettings(true)
end

function applyHideButtons(state)
    hideButtonsEnabled = state
    if MobilePanel then
        for _, child in ipairs(MobilePanel:GetChildren()) do
            if child:IsA("TextButton") then
                child.Visible = not state
            end
        end
    end
end

function toggleHideButtons(on)
    applyHideButtons(on)
    if setHideButtonsVisual then setHideButtonsVisual(on) end
    saveAllSettings(true)
end

--=========================================================
--  paintFloatingBtn  (MODIFICADO: apagado = plateado)
--=========================================================
function paintFloatingBtn(btnFrame, active)
    if not btnFrame then return end
    local bg     = btnFrame:FindFirstChild("BtnGrad")
    local label  = btnFrame:FindFirstChild("TextLabel")
    local stroke = btnFrame:FindFirstChildOfClass("UIStroke")

    local STRONG_BLUE    = Color3.fromRGB(0, 105, 240)
    local SILVER_SOFT    = Color3.fromRGB(210, 220, 235)
    local SILVER_MID     = Color3.fromRGB(160, 175, 200)
    local BLUE_DEEP      = Color3.fromRGB(0, 80, 200)

    -- Plateado "apagado"
    local SILVER_LIGHT   = Color3.fromRGB(238, 241, 245)
    local SILVER_NORMAL  = Color3.fromRGB(200, 206, 216)
    local SILVER_DARK    = Color3.fromRGB(150, 158, 172)
    local SILVER_BORDER  = Color3.fromRGB(120, 128, 142)

    if bg then
        bg.Rotation = 90
        if active then
            bg.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, SILVER_SOFT),
                ColorSequenceKeypoint.new(0.35, SILVER_MID),
                ColorSequenceKeypoint.new(0.55, BLUE_DEEP),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(120, 150, 200)),
            })
        else
            -- Plateado completo (metalizado)
            bg.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, SILVER_LIGHT),
                ColorSequenceKeypoint.new(0.45, SILVER_NORMAL),
                ColorSequenceKeypoint.new(1.00, SILVER_DARK),
            })
        end
    end

    btnFrame.BackgroundColor3 = active and STRONG_BLUE or SILVER_NORMAL

    if label then
        label.Font = Enum.Font.GothamBlack
        if active then
            label.TextColor3 = Color3.fromRGB(245, 250, 255)
        else
            -- Texto oscuro para contrastar sobre plateado
            label.TextColor3 = Color3.fromRGB(40, 42, 52)
        end
    end

    if stroke then
        if active then
            stroke.Color        = SILVER_SOFT
            stroke.Thickness    = 1.5
            stroke.Transparency = 0.15
        else
            -- Borde plateado oscuro
            stroke.Color        = SILVER_BORDER
            stroke.Thickness    = 1.2
            stroke.Transparency = 0.25
        end
    end
end

function applyFloatingButtonScale()
    for _, uiScale in ipairs(_floatingUIScales) do
        if uiScale and uiScale.Parent then
            uiScale.Scale = floatingButtonScale
        end
    end
end

local function drag(f, dragZoneHeight)
    local dn, ds, sp, di = false, nil, nil, nil
    local endConn = nil
    local zone = dragZoneHeight or 99999
    local function stopDrag()
        local wasDragging = dn
        dn = false
        di = nil
        if endConn then
            endConn:Disconnect()
            endConn = nil
        end
        if wasDragging then task.defer(function() pcall(saveAllSettings) end) end
    end
    f.InputBegan:Connect(function(i)
        if uiLocked then return end
        if _isDraggingButton then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            local framePos = f.AbsolutePosition
            if i.Position.Y > framePos.Y + zone then return end
            dn = true; ds = i.Position; sp = f.Position
            if endConn then endConn:Disconnect() end
            endConn = i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then stopDrag() end
            end)
        end
    end)
    f.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            stopDrag()
        end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            stopDrag()
        end
    end)
    f.InputChanged:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch then di = i end
    end)
    UIS.InputChanged:Connect(function(i)
        if i == di and dn then
            if uiLocked then stopDrag(); return end
            if _isDraggingButton then return end
            if not ds or not sp then return end
            local nX = sp.X.Offset + (i.Position.X - ds.X)
            local nY = sp.Y.Offset + (i.Position.Y - ds.Y)
            f.Position = UDim2.new(sp.X.Scale, nX, sp.Y.Scale, nY)
        end
    end)
end

_G.__RivalHubSpeedEngine = _G.__RivalHubSpeedEngine or { started = false, conn = nil }
_G.__RivalHubSpeedEngine.signal = nil
do
    _G.__RivalHubSpeedEngine.signal = RunService.RenderStepped
end

local function _spd_isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand or st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
end

local function _spd_shouldUseStealSpeed(_isStealing)
    return speedMode == true
end

local function _spd_getSelectedBoostSpeed()
    if laggerToggled or laggerCarryToggled then return LAGGER_SPEED end
    return NS
end

local function _spd_getSelectedStealSpeed()
    if laggerCarryToggled then return LAGGER_CARRY_SPEED end
    if laggerToggled then return LAGGER_SPEED end
    return CS
end

local function _spd_getTargetSpeed(isStealing)
    if _spd_shouldUseStealSpeed(isStealing) then return _spd_getSelectedStealSpeed() end
    return _spd_getSelectedBoostSpeed()
end

local function _spd_resetMovement()
    lastMoveDir = _V3zero
    _s2VelState.v = _V3new(0, _s2VelState.v.Y or 0, 0)
end

local function _spd_stop()
    if _G.__RivalHubSpeedEngine.conn then
        _G.__RivalHubSpeedEngine.conn:Disconnect()
        _G.__RivalHubSpeedEngine.conn = nil
    end
    _spd_resetMovement()
end

local function _spd_start()
    _spd_stop()
    _G.__RivalHubSpeedEngine.started = true
    _G.__RivalHubSpeedEngine.acc = 0

    _G.__RivalHubSpeedEngine.conn = _G.__RivalHubSpeedEngine.signal:Connect(function(dt)
        _G.__RivalHubSpeedEngine.acc = (_G.__RivalHubSpeedEngine.acc or 0) + (dt or 0)
        if _G.__RivalHubSpeedEngine.acc < 0.016 then return end
        _G.__RivalHubSpeedEngine.acc = 0

        local character = LP.Character
        local humanoid = character and character:FindFirstChildOfClass("Humanoid")
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not humanoid or not root or humanoid.Health <= 0 then return end
        if autoBatEnabled
           or autoLeftEnabled or autoRightEnabled
           or dropActive or _G.IsDropping
           or (_G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2()) then
            _spd_resetMovement()
            return
        end
        if _spd_isRagdollState(humanoid) then
            lastMoveDir = _V3zero
            return
        end
        if _s2VelState.root ~= root or not _velChecked[root] then
            lastMoveDir = _V3zero
            _setupVelChecked(character)
            _hookVelHRP(root)
        end
        local direction
        if humanoid.MoveDirection.Magnitude > 0 then
            lastMoveDir = humanoid.MoveDirection
            direction = humanoid.MoveDirection
        elseif lastMoveDir.Magnitude > 0 then
            for key in pairs(MOVE_KEYS) do
                if UIS:IsKeyDown(key) then
                    direction = lastMoveDir
                    break
                end
            end
        end
        local selectedSpeed = _spd_getTargetSpeed(LP:GetAttribute("Stealing") == true)
        _applyVelocitySpeed(direction, tonumber(selectedSpeed) or 16, root)
    end)
end

local function _spd_applyNow()
    local character = LP.Character
    local hum = character and character:FindFirstChildOfClass("Humanoid")
    local root = character and character:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 or _spd_isRagdollState(hum) then return end
    local direction = hum.MoveDirection.Magnitude > 0.05 and hum.MoveDirection or nil
    _applyVelocitySpeed(direction, _spd_getTargetSpeed(LP:GetAttribute("Stealing") == true), root)
end

local function _spd_refresh()
    _spd_start()
end

_G.__RivalHubRefreshSpeedEngine = _spd_refresh
_G.__RivalHubStopSpeedEngine = _spd_stop
_G.__RivalHubApplySpeedNow = _spd_applyNow

pcall(_spd_start)

LP.CharacterAdded:Connect(function(character)
    task.wait(0.5)
    _spd_resetMovement()
    local root = character:WaitForChild("HumanoidRootPart", 5)
    if root then _setupVelChecked(character); _hookVelHRP(root) end
    _spd_start()
end)
LP.CharacterRemoving:Connect(function()
    _spd_stop()
    _s2VelState.root = nil
end)

function setupMovementAndIndicators(char)
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end

    local ccAcc = 0
    steppedConn = RunService.Heartbeat:Connect(function(dt)
        ccAcc = ccAcc + dt
        if ccAcc < 0.05 then return end
        ccAcc = 0
        local plist = _GetPlayersCached()
        for i = 1, #plist do
            local p = plist[i]
            if p ~= LP then
                local ch = p.Character
                if ch then
                    local parts = ch:GetChildren()
                    for j = 1, #parts do
                        local part = parts[j]
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end
    end)

    movementLoop = RunService.RenderStepped:Connect(function()
        local char2 = LP.Character
        if not char2 then return end
        local hum = char2:FindFirstChildOfClass("Humanoid")
        local hrp = char2:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled then
            if _isRagdollState(hum) then
                lastMoveDir = _V3zero
            else
                local md = hum.MoveDirection
                if md.Magnitude > 0 then
                    lastMoveDir = md
                end
            end
        end
        if speedLabel then
            local displaySpeed = getActiveMoveSpeed()
            speedLabel.Text = string.format("%.1f  -  %s", displaySpeed, getSpeedModeName())
        end
    end)
    setupSpeedIndicator(char)
    startEnemySpeed()
end

function toggleLockUI(state)
    if state == nil then uiLocked = not uiLocked else uiLocked = state end
    if setLockUIVisual then setLockUIVisual(uiLocked) end
end

function disableAllAimbots()
    if autoBatEnabled then
        disableAutoBat()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
    end
end

function stopAllBackgroundTasks()
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    stopEnemySpeed()
    if stretchEnabled then disableStretch() end
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
    if stretchFovConn then stretchFovConn:Disconnect(); stretchFovConn = nil end
    if AntiRagdollV1.isRunning() then AntiRagdollV1.stop() end
    if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
    if antiDieEnabled then AntiDieModule.stop() end
    if antiBatEnabled then stopAntiBat() end
    if antiFlingEnabled then stopAntiFling() end
    stopBatCounter()
    if stopBatCounterV2 then stopBatCounterV2() end
    stopMedusaCounter()
    stopAutoSteal()
    disableAutoBat()
    stopAutoLeft()
    stopAutoRight()
    if _G.__RivalHubStopBatV2 then pcall(_G.__RivalHubStopBatV2) end
    if TPBatState and TPBatState.enabled and tpBatSetEnabled then pcall(tpBatSetEnabled, false) end
    if unwalkEnabled then stopUnwalk() end
    if antiLagEnabled then disableAntiLag() end
    if espEnabled then toggleESP(false) end
    if espLineEnabled then stopESPLine() end
    if dropActive then stopDropBrainrot() end
    if bodyLockEnabled then stopBodyLock() end
    _blSuppressCount = 0
    _blWasEnabled = false
    if _blRestoreTimer then pcall(task.cancel, _blRestoreTimer); _blRestoreTimer = nil end
    if _bodyLockConn then _bodyLockConn:Disconnect(); _bodyLockConn = nil end
    for _, t in ipairs(dropConnections) do
        if type(t) == "thread" then pcall(task.cancel, t)
        elseif type(t) == "RBXScriptConnection" then pcall(t.Disconnect, t) end
    end
    dropConnections = {}
    dropActive = false
    alPhase = 1
    arPhase = 1
    lastDropTime = 0
    medusaDebounce = false
    medusaLastUsed = 0
    if _G.__RivalHubStopSpeedEngine then pcall(_G.__RivalHubStopSpeedEngine) end
end

local _rivalHubSaveState = {
    lastAt = 0,
    queued = false,
    writing = false,
    dirty = false,
    revision = 0,
    retryCount = 0,
}
local function resolveRivalHubFileApi()
    local env = (type(getgenv) == "function" and getgenv()) or _G
    local synApi = rawget(env, "syn") or rawget(_G, "syn")
    local readCandidates = {rawget(env, "readfile"), synApi and synApi.readfile, rawget(_G, "readfile")}
    local writeCandidates = {rawget(env, "writefile"), synApi and synApi.writefile, rawget(_G, "writefile")}
    local readFn, writeFn
    for _, fn in ipairs(readCandidates) do if type(fn) == "function" then readFn = fn; break end end
    for _, fn in ipairs(writeCandidates) do if type(fn) == "function" then writeFn = fn; break end end
    return readFn, writeFn
end

local function rivalHubFileExists(path)
    local readFn = resolveRivalHubFileApi()
    if not readFn then return false end
    local ok, data = pcall(readFn, path)
    return ok and type(data) == "string"
end

function buildConfigTable()
    local config = {
        normalSpeed = NS, carrySpeed = CS,
        laggerSpeed1 = LAGGER_SPEED, laggerSpeed2 = LAGGER_CARRY_SPEED,
        stealRadius = CONFIG.STEAL_RANGE,
        holdMin = CONFIG.HOLD_MIN, holdMax = CONFIG.HOLD_MAX, entryDelay = CONFIG.ENTRY_DELAY, cooldown = CONFIG.COOLDOWN, primeRange = CONFIG.PRIME_RANGE,
        antiRagdollMode = antiRagdollMode, antiDieEnabled = antiDieEnabled,
        antiBat = antiBatEnabled,
        antiFling = antiFlingEnabled,
        autoSteal = CONFIG.AUTO_STEAL_ENABLED,
        autoBat = autoBatEnabled, autoLeft = autoLeftEnabled, autoRight = autoRightEnabled,
        medusaCounter = medusaCounterEnabled, batCounter = batCounterEnabled,
        batCounterV2 = batCounterV2Enabled, unwalkEnabled = unwalkEnabled,
        laggerToggled = laggerToggled, laggerCarryToggled = laggerCarryToggled,
        carryMode = speedMode, batAimbotSpeed = BAT_AIMBOT_SPEED,
        dropMode = dropMode, stretchEnabled = stretchEnabled, stretchFOV = stretchFOV,
        uiScale = uiScaleValue, animPack = currentAnimPack,
        espEnabled = espEnabled,
        espLineEnabled = espLineEnabled,
        vividGraphics = vividGraphicsEnabled,
        hideButtons = hideButtonsEnabled,
        antiLag = antiLagEnabled,
        skyTheme = skyTheme, mobileButtonPositions = savedButtonPositions,
        dropBrainrotKey = {kb = KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name, gp = KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name},
        autoLeftKey = {kb = KB.AutoLeft.kb and KB.AutoLeft.kb.Name, gp = KB.AutoLeft.gp and KB.AutoLeft.gp.Name},
        autoRightKey = {kb = KB.AutoRight.kb and KB.AutoRight.kb.Name, gp = KB.AutoRight.gp and KB.AutoRight.gp.Name},
        autoBatKey = {kb = KB.AutoBat.kb and KB.AutoBat.kb.Name, gp = KB.AutoBat.gp and KB.AutoBat.gp.Name},
        tpFloorKey = {kb = KB.TPFloor.kb and KB.TPFloor.kb.Name, gp = KB.TPFloor.gp and KB.TPFloor.gp.Name},
        guiHideKey = {kb = KB.GuiHide.kb and KB.GuiHide.kb.Name, gp = KB.GuiHide.gp and KB.GuiHide.gp.Name},
        carryToggleKey = {kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name, gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name},
        laggerModeKey = {kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name, gp = KB.LaggerMode.gp and KB.LaggerMode.gp.Name},
        batV2Key = {kb = KB.BatV2.kb and KB.BatV2.kb.Name, gp = KB.BatV2.gp and KB.BatV2.gp.Name},
        bodyLockEnabled = bodyLockEnabled, bodyLockRange = bodyLockRange,
        progressBarPos = savedProgressBarPos, lockUI = uiLocked,
        backgroundIndex = backgroundIndex,
        backgroundImageTransparency = backgroundImageTransparency,
        backgroundMode = backgroundMode, floatingButtonScale = floatingButtonScale,
        outfitIndex = currentOutfitIndex, vx7AvatarIndex = VX7A.index, themeColor = currentColorTheme,
        rivalTitleTheme = currentRivalTitleTheme,
        infiniteJumpEnabled = InfiniteJump.enabled == true,
        infiniteJumpMode = InfiniteJump.mode == "manual" and "manual" or "hold",
        autoStealMode = autoStealMode == "V2" and "V2" or "V1",
        batV2 = _G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2() or false,
    }
    if main then
        local basePos = _G.__RivalHubMainOriginalPos or main.Position
        config.mainPosition = {
            XScale = basePos.X.Scale,
            XOffset = basePos.X.Offset,
            YScale = basePos.Y.Scale,
            YOffset = basePos.Y.Offset,
        }
    end
    if pbFrame then
        config.progressBarPos = {XScale = pbFrame.Position.X.Scale, XOffset = pbFrame.Position.X.Offset, YScale = pbFrame.Position.Y.Scale, YOffset = pbFrame.Position.Y.Offset}
    end
    if MobilePanel then
        config.mobilePanelPos = {XScale = 0, XOffset = 10, YScale = 0, YOffset = 0}
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") then
                savedButtonPositions[btn.Name] = {X = btn.Position.X.Offset, Y = btn.Position.Y.Offset}
            end
        end
        config.mobileButtonPositions = savedButtonPositions
    end
    return config
end

local function scheduleRivalHubSave(delaySeconds)
    if _rivalHubSaveState.queued then return end
    _rivalHubSaveState.queued = true
    task.delay(delaySeconds or 0.25, function()
        _rivalHubSaveState.queued = false
        if _G.RivalHubRunning and not _isResetting and not _isLoading then
            pcall(saveAllSettings, true)
        end
    end)
end

function saveAllSettings(force)
    if _isResetting or _isLoading then return true end

    local config = buildConfigTable()
    config.configVersion = 2
    config.userId = LP.UserId
    local encodedOk, canonicalJSON = pcall(function() return HS:JSONEncode(config) end)
    if not encodedOk then
        warn("[Rival Hub Save] Could not encode settings.")
        return false
    end
    if not force and canonicalJSON == _lastSavedJSON and not _rivalHubSaveState.dirty then
        return true
    end
    _rivalHubSaveState.dirty = true

    if _rivalHubSaveState.writing then
        scheduleRivalHubSave(0.25)
        return true
    end
    if not force and _tick() - _rivalHubSaveState.lastAt < 0.25 then
        scheduleRivalHubSave(0.25)
        return true
    end

    local readFn, writeFn = resolveRivalHubFileApi()
    if not readFn or not writeFn then
        warn("[Rival Hub Save] Executor file API is unavailable.")
        scheduleRivalHubSave(1)
        return false
    end

    _rivalHubSaveState.writing = true
    _rivalHubSaveState.revision = _rivalHubSaveState.revision + 1
    local writeConfig = config
    writeConfig.revision = _rivalHubSaveState.revision
    writeConfig.savedAt = os.time()
    local json = HS:JSONEncode(writeConfig)
    local ok = false

    for attempt = 1, 3 do
        local attemptOk = pcall(function()
            if rivalHubFileExists(CONFIG_FILE) then
                local previous = readFn(CONFIG_FILE)
                if type(previous) == "string" then writeFn(CONFIG_FILE .. ".backup", previous) end
            end
            writeFn(CONFIG_FILE, json)
            local readBack = readFn(CONFIG_FILE)
            if readBack ~= json then error("save verification failed") end
            HS:JSONDecode(readBack)
        end)
        if attemptOk then
            ok = true
            break
        end
        if attempt < 3 then task.wait(0.1 * attempt) end
    end

    _rivalHubSaveState.writing = false
    if ok then
        _rivalHubSaveState.lastAt = _tick()
        _rivalHubSaveState.retryCount = 0
        _lastSavedJSON = canonicalJSON
        _rivalHubSaveState.dirty = false
        local latestOk, latest = pcall(function()
            local latestConfig = buildConfigTable()
            latestConfig.configVersion = 2
            latestConfig.userId = LP.UserId
            return HS:JSONEncode(latestConfig)
        end)
        if not latestOk or latest ~= _lastSavedJSON then
            _rivalHubSaveState.dirty = true
            scheduleRivalHubSave(0.25)
        end
    else
        _rivalHubSaveState.retryCount = _rivalHubSaveState.retryCount + 1
        warn("[Rival Hub Save] Write or verification failed; will retry.")
        scheduleRivalHubSave(math.min(2, 0.5 * _rivalHubSaveState.retryCount))
    end
    return ok
end

task.spawn(function()
    task.wait(5)
    while _G.RivalHubRunning do
        task.wait(2)
        if gui and main and not _isLoading then pcall(saveAllSettings) end
    end
end)
pcall(function()
    game:BindToClose(function()
        pcall(saveAllSettings, true)
    end)
end)

do
    local readFn, writeFn = resolveRivalHubFileApi()
    if readFn and writeFn then
        local legacyPaths = {
            "Fresh_"       .. tostring(LP.UserId) .. ".json",
            "Rival_"       .. tostring(LP.UserId) .. ".json",
            "BloodHounds_" .. tostring(LP.UserId) .. ".json",
        }
        local okNew, _ = pcall(readFn, CONFIG_FILE)
        if not okNew then
            for _, oldPath in ipairs(legacyPaths) do
                local okOld, old = pcall(readFn, oldPath)
                if okOld and type(old) == "string" and #old > 0 then
                    pcall(writeFn, CONFIG_FILE, old)
                    warn("[Rival Hub] Config migrada de " .. oldPath .. " a " .. CONFIG_FILE)
                    break
                end
            end
        end
    end
end

function loadAllSettings()
    local readFn = resolveRivalHubFileApi()
    if not readFn or not rivalHubFileExists(CONFIG_FILE) then return false end
    local success, data = pcall(function() return HS:JSONDecode(readFn(CONFIG_FILE)) end)
    if not success or type(data) ~= "table" then return false end
    _isLoading = true

    local function num(v, fallback)
        local n = tonumber(v)
        if n == nil or n ~= n or n == math.huge or n == -math.huge then
            return fallback
        end
        return n
    end
    local function boolOr(v, fallback)
        if v == nil then return fallback end
        return v == true
    end

    NS                  = num(data.normalSpeed,       NS)
    CS                  = num(data.carrySpeed,        CS)
    LAGGER_SPEED        = num(data.laggerSpeed1,      LAGGER_SPEED)
    LAGGER_CARRY_SPEED  = num(data.laggerSpeed2,      LAGGER_CARRY_SPEED)
    CONFIG.STEAL_RANGE  = num(data.stealRadius,       CONFIG.STEAL_RANGE)
    CONFIG.HOLD_MIN     = num(data.holdMin,           CONFIG.HOLD_MIN)
    CONFIG.HOLD_MAX     = num(data.holdMax,           CONFIG.HOLD_MAX)
    CONFIG.ENTRY_DELAY  = num(data.entryDelay,        CONFIG.ENTRY_DELAY)
    CONFIG.COOLDOWN     = num(data.cooldown,          CONFIG.COOLDOWN)
    CONFIG.PRIME_RANGE  = num(data.primeRange,        CONFIG.PRIME_RANGE)

    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end

    if num(data.configVersion, 1) >= 2 and data.lockUI ~= nil then
        uiLocked = boolOr(data.lockUI, false)
    else
        uiLocked = false
    end
    mobileButtonsLocked = false

    if data.antiRagdollMode then
        antiRagdollMode = tostring(data.antiRagdollMode)
    else
        antiRagdollMode = data.antiRagdoll and "v2" or "off"
    end
    antiDieEnabled = boolOr(data.antiDieEnabled, false)
    antiBatEnabled = boolOr(data.antiBat, false)
    antiFlingEnabled = boolOr(data.antiFling, false)
    CONFIG.AUTO_STEAL_ENABLED = boolOr(data.autoSteal, false)
    autoBatEnabled = boolOr(data.autoBat, false)
    autoLeftEnabled = boolOr(data.autoLeft, false)
    autoRightEnabled = boolOr(data.autoRight, false)
    autoStealMode = data.autoStealMode == "V2" and "V2" or "V1"
    InfiniteJump.mode = data.infiniteJumpMode == "manual" and "manual" or "hold"
    InfiniteJump.enabled = boolOr(data.infiniteJumpEnabled, false)
    medusaCounterEnabled = boolOr(data.medusaCounter, false)
    batCounterEnabled = boolOr(data.batCounter, false)
    batCounterV2Enabled = boolOr(data.batCounterV2, false)
    unwalkEnabled = boolOr(data.unwalkEnabled, boolOr(data.unwalk, false))
    antiLagEnabled = boolOr(data.antiLag, false)
    laggerToggled = boolOr(data.laggerToggled, false)
    speedMode = boolOr(data.carryMode, false)
    laggerCarryToggled = boolOr(data.laggerCarryToggled, false)
    uiScaleValue = _clamp(num(data.uiScale, 78), 50, 150)
    if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
    if pbScale then pbScale.Scale = uiScaleValue / 100 end
    espEnabled = boolOr(data.espEnabled, false)
    espLineEnabled = boolOr(data.espLineEnabled, false)
    if espEnabled then pcall(toggleESP, true) else pcall(toggleESP, false) end

    vividGraphicsEnabled = boolOr(data.vividGraphics, false)
    hideButtonsEnabled = boolOr(data.hideButtons, false)

    -- TP Bat forzado off
    TPBatState.enabled = false

    currentColorTheme = COLOR_THEMES[data.themeColor] and data.themeColor or "Gray"
    selectedColor = COLOR_THEMES[currentColorTheme]
    task.defer(function() updateAllUIThemeColors(selectedColor) end)

    if data.rivalTitleTheme and RIVAL_TITLE_THEMES[data.rivalTitleTheme] then
        task.defer(function() applyRivalTitleTheme(data.rivalTitleTheme) end)
    end

    skyTheme = data.skyTheme or "Off"
    if skyTheme ~= "Off" then pcall(applyCustomSky, skyTheme) end
    if skySelectorLabel then skySelectorLabel.Text = skyTheme end
    if data.animPack and ANIM_PACKS[data.animPack] then
        pcall(startAnimPack, data.animPack)
    else
        currentAnimPack = "Off"
        stopAnimPack()
    end
    local function lk(e, d)
        if not d then return end
        if d.kb and Enum.KeyCode[d.kb] then e.kb = Enum.KeyCode[d.kb] end
        if d.gp and Enum.KeyCode[d.gp] then e.gp = Enum.KeyCode[d.gp] end
    end
    lk(KB.DropBrainrot, data.dropBrainrotKey)
    lk(KB.AutoLeft, data.autoLeftKey)
    lk(KB.AutoRight, data.autoRightKey)
    lk(KB.AutoBat, data.autoBatKey)
    lk(KB.TPFloor, data.tpFloorKey)
    lk(KB.GuiHide, data.guiHideKey)
    lk(KB.CarryToggle, data.carryToggleKey)
    lk(KB.LaggerMode, data.laggerModeKey)
    lk(KB.BatV2, data.batV2Key)
    if data.mobileButtonPositions then savedButtonPositions = data.mobileButtonPositions end
    if data.mobilePanelPos then savedMobilePanelPos = data.mobilePanelPos end
    if data.mainPosition and main and type(data.mainPosition) == "table" then
        main.Position = UDim2.new(
            num(data.mainPosition.XScale, 0),
            num(data.mainPosition.XOffset, 20),
            num(data.mainPosition.YScale, 0),
            num(data.mainPosition.YOffset, 2)
        )
    end
    if data.progressBarPos and type(data.progressBarPos) == "table" then
        savedProgressBarPos = data.progressBarPos
    end
    if data.bodyLockEnabled ~= nil then
        bodyLockEnabled = boolOr(data.bodyLockEnabled, false)
        if bodyLockEnabled then
            task.defer(function()
                if bodyLockSetVisual then bodyLockSetVisual(true) end
                startBodyLock()
            end)
        end
    end
    if data.bodyLockRange ~= nil then
        bodyLockRange = _clamp(num(data.bodyLockRange, 20), 5, 200)
        if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    end
    dropMode = num(data.dropMode, 1)
    stretchEnabled = boolOr(data.stretchEnabled, false)
    stretchFOV = num(data.stretchFOV, 120)
    BAT_AIMBOT_SPEED = num(data.batAimbotSpeed, BAT_AIMBOT_SPEED)
    BYPASS_AIMBOT_SPEED = BAT_AIMBOT_SPEED
    if State then State.bypassBatSpeed = BYPASS_AIMBOT_SPEED end

    backgroundIndex = _clamp(num(data.backgroundIndex, 1), 1, #backgroundImages)
    backgroundImageTransparency = _clamp(num(data.backgroundImageTransparency, 0), 0, 1)

    if data.backgroundMode == "None" then
        backgroundMode = "None"
    else
        local savedN = nil
        if type(data.backgroundMode) == "string" then
            savedN = tonumber(string.match(data.backgroundMode, "^Background%s+(%d+)$"))
        end
        if type(savedN) == "number" and savedN >= 1 and savedN <= #backgroundImages then
            backgroundIndex = savedN
        end
        backgroundMode = "Background " .. backgroundIndex
    end

    floatingButtonScale = _clamp(num(data.floatingButtonScale, 1), 0.5, 2)

    if type(data.outfitIndex) == "number"
       and type(OUTFITS) == "table"
       and #OUTFITS > 0
       and data.outfitIndex >= 1
       and data.outfitIndex <= #OUTFITS then
        currentOutfitIndex = data.outfitIndex
        task.defer(function()
            pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
            if outfitSelectorLabel and OUTFITS[currentOutfitIndex] then
                outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
            end
        end)
    end

    if type(data.vx7AvatarIndex) == "number"
       and data.vx7AvatarIndex >= 1
       and data.vx7AvatarIndex <= #VX7A.labels - 1 then
        local _vx7Saved = data.vx7AvatarIndex
        task.defer(function()
            task.wait(1.5)
            pcall(VX7A.apply, _vx7Saved)
        end)
    end

    if vividGraphicsEnabled then
        task.defer(function() pcall(enableVividGraphics) end)
    else
        task.defer(function() pcall(disableVividGraphics) end)
    end
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    refreshSpeedModeLabel()
    _lastSavedJSON = HS:JSONEncode(buildConfigTable())
    _isLoading = false

    if data.batV2 == true and _G.__RivalHubStartBatV2 then
        task.defer(function()
            pcall(_G.__RivalHubStartBatV2)
            if mobSetBatV2 then mobSetBatV2(true) end
        end)
    end

    return true
end

function forceResetUI()
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_CARRY_SPEED) end
    if batSpeedBox then batSpeedBox.Text = tostring(BYPASS_AIMBOT_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    local function safeSet(fn, val) if fn then fn(val) end end
    safeSet(autoBatSetVisual, false)
    safeSet(autoLeftSetVisual, false)
    safeSet(autoRightSetVisual, false)
    safeSet(setBatCounterVisual, false)
    safeSet(setBatCounterV2Visual, false)
    safeSet(setMedusaVisual, false)
    safeSet(setUnwalkVisual, false)
    safeSet(setAntiLagVisual, false)
    safeSet(setLockUIVisual, false)
    safeSet(setInstaGrab, false)
    safeSet(setESPVIsual, false)
    safeSet(setESPLineVisual, false)
    safeSet(setVividVisual, false)
    safeSet(setHideButtonsVisual, false)
    safeSet(bodyLockSetVisual, false)
    safeSet(setAntiDieVisual, false)
    safeSet(setAntiBatVisual, false)
    safeSet(setAntiFlingVisual, false)
    safeSet(setAntiRagVisual, false)
    safeSet(infJumpSetVisual, false)
    safeSet(mobSetBatV2, false)
    if _G.__RivalHubStopBatV2 then pcall(_G.__RivalHubStopBatV2) end
    disableVividGraphics()
    applyHideButtons(false)
    if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    safeSet(mobSetAutoBat, false)
    safeSet(mobSetAutoLeft, false)
    safeSet(mobSetAutoRight, false)
    safeSet(mobSetDropBR, false)
    safeSet(mobSetTpDown, false)
    safeSet(mobSetCarry, false)
    safeSet(mobSetLagger1, false)
    safeSet(mobSetLagger2, false)
    refreshSpeedModeLabel()
    updateProgressBarVisibility()
    disableAntiLag()
    if stopAntiBat then stopAntiBat() end
    if stopAntiFling then stopAntiFling() end
    if stopESPLine then stopESPLine() end
    skyTheme = "Off"
    pcall(applyCustomSky, "Off")
    if skySelectorLabel then skySelectorLabel.Text = "Off" end
    if antiDieEnabled then
        AntiDieModule.stop()
        antiDieEnabled = false
    end
    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end
    currentColorTheme = "Gray"
    selectedColor = COLOR_THEMES["Gray"]
    updateAllUIThemeColors(selectedColor)
    if miniBtn then
        local stroke = miniBtn:FindFirstChildOfClass("UIStroke")
        if stroke then stroke.Color = Color3.fromRGB(42, 43, 47) end
    end
    if MobilePanel then
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") then
                local label = btn:FindFirstChildOfClass("TextLabel")
                if label then
                    local isActive = btn.BackgroundColor3 == selectedColor
                    if not isActive then label.TextColor3 = selectedColor end
                end
            end
        end
    end
    saveAllSettings()
end

function resetFloatingPositions()
    if MobilePanel then
        savedButtonPositions = {}
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") and btn.Name then
                local defX, defY = getDefaultButtonPosition(btn.Name)
                btn.Position = UDim2.new(0, defX, 0, defY)
            end
        end
    end
    if pbFrame then
        pbFrame.Position = UDim2.new(0.5, -160, 0.80, 0)
        savedProgressBarPos = nil
    end
    savedMobilePanelPos = nil
end

function resetToFactoryDefaults()
    _isResetting = true
    local ok, err = pcall(function()
        stopAutoSteal()
        stopBatCounter()
        if stopBatCounterV2 then stopBatCounterV2() end
        stopMedusaCounter()
        if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
        if antiDieEnabled then AntiDieModule.stop() end
        if antiBatEnabled and stopAntiBat then stopAntiBat() end
        if antiFlingEnabled and stopAntiFling then stopAntiFling() end
        if _G.__RivalHubStopBatV2 then pcall(_G.__RivalHubStopBatV2) end
        stopUnwalk()
        InfiniteJump.stop()
        InfiniteJump.setMode("hold")
        disableAutoBat()
        stopBodyLock()
        if espEnabled then toggleESP(false) end
        if espLineEnabled and stopESPLine then stopESPLine() end
        if stretchEnabled then disableStretch() end
        if antiLagEnabled then disableAntiLag() end
        if vividGraphicsEnabled then disableVividGraphics() end
        if hideButtonsEnabled then applyHideButtons(false) end
        if dropActive then stopDropBrainrot() end
        skyTheme = "Off"
        pcall(applyCustomSky, "Off")
        if skySelectorLabel then skySelectorLabel.Text = "Off" end
        if antiDieEnabled then AntiDieModule.stop(); antiDieEnabled = false end
        NS = 60; CS = 29; LAGGER_SPEED = 15; LAGGER_CARRY_SPEED = 24.5
        CONFIG.STEAL_RANGE = 65
        CONFIG.HOLD_MIN = 0.05
        CONFIG.HOLD_MAX = 0.15
        CONFIG.ENTRY_DELAY = 0.1
        CONFIG.COOLDOWN = 0.2
        CONFIG.PRIME_RANGE = 60
        speedMode = false; laggerToggled = false; laggerCarryToggled = false
        antiRagdollMode = "off"; antiDieEnabled = false
        antiBatEnabled = false
        antiFlingEnabled = false
        medusaCounterEnabled = false; batCounterEnabled = false; batCounterV2Enabled = false
        autoBatEnabled = false; autoLeftEnabled = false; autoRightEnabled = false
        unwalkEnabled = false; antiLagEnabled = false
        uiLocked = false; mobileButtonsLocked = false
        CONFIG.AUTO_STEAL_ENABLED = false
        autoStealMode = "V1"
        if _G._rivalHubStealModeSetter then pcall(_G._rivalHubStealModeSetter, "V1") end
        BAT_AIMBOT_SPEED = 58
        BYPASS_AIMBOT_SPEED = BAT_AIMBOT_SPEED
        if State then State.bypassBatSpeed = BYPASS_AIMBOT_SPEED end
        dropMode = 1; stretchEnabled = false; stretchFOV = 120
        uiScaleValue = 78
        if mainUIScale then mainUIScale.Scale = 1 end
        if pbScale then pbScale.Scale = 1 end
        espEnabled = false; espLineEnabled = false; vividGraphicsEnabled = false; hideButtonsEnabled = false
        bodyLockEnabled = false; bodyLockRange = 20
        backgroundIndex = 1; backgroundImageTransparency = 0; backgroundMode = "Background 1"
        floatingButtonScale = 1
        currentAnimPack = "Off"; stopAnimPack()
        currentOutfitIndex = 1
        pcall(VX7A.stop)
        currentColorTheme = "Gray"; selectedColor = COLOR_THEMES["Gray"]
        currentRivalTitleTheme = "Blue"
        applyRivalTitleTheme("Blue")
        if main then main.Position = UDim2.new(0, 20, 0, 2); _G.__RivalHubMainOriginalPos = main.Position end
        for key, val in pairs(DEFAULT_KB) do
            if KB[key] then KB[key].kb = val.kb; KB[key].gp = val.gp end
        end
        resetFloatingPositions()
        forceResetUI()
        updateProgressBarVisibility()
        refreshSpeedModeLabel()
        _lastSavedJSON = nil
    end)
    _isResetting = false
    if not ok then warn("[resetToFactoryDefaults]", err) end
    if ok then saveAllSettings(true) end
    return ok
end

function updateProgressBarVisibility()
    if pbFrame then pbFrame.Visible = true end
end

function applyShimmerToText(obj, speed, baseColor)
    speed = speed or 0.8
    local color = baseColor or Color3.fromRGB(215, 215, 225)
    local grad = Instance.new("UIGradient", obj)
    grad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, color),
        ColorSequenceKeypoint.new(0.3, color:Lerp(Color3.new(0.15,0.15,0.15), 0.25)),
        ColorSequenceKeypoint.new(0.5, color:Lerp(Color3.new(1,1,1), 0.55)),
        ColorSequenceKeypoint.new(0.7, color:Lerp(Color3.new(0.15,0.15,0.15), 0.25)),
        ColorSequenceKeypoint.new(1, color),
    })
    grad.Rotation = 45
    grad.Offset = Vector2.new(0,0)
    task.spawn(function()
        local t = 0
        while grad and grad.Parent do
            t = t + 0.02
            grad.Offset = Vector2.new(math.sin(t * speed) * 0.4, 0)
            grad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, color),
                ColorSequenceKeypoint.new(0.30, color:Lerp(Color3.new(0.15,0.15,0.15), 0.25)),
                ColorSequenceKeypoint.new(0.50, color:Lerp(Color3.new(1,1,1), 0.55)),
                ColorSequenceKeypoint.new(0.70, color:Lerp(Color3.new(0.15,0.15,0.15), 0.25)),
                ColorSequenceKeypoint.new(1.00, color),
            })
            task.wait(0.04)
        end
    end)
    return grad
end

function getDefaultButtonPosition(btnName)
    local BTN_W, BTN_H = 56, 56
    local GAP = 8
    local orderMap = { DropBR = 0, AutoLeft = 1, AutoBat = 2, AutoRight = 3, TpDown = 4, Carry = 5, Lagger1 = 6, Lagger2 = 7, BatV2 = 8 }
    local order = orderMap[btnName] or 0
    local row = _floor(order / 2)
    local col = order % 2
    return col * (BTN_W + GAP), row * (BTN_H + GAP + 10)
end

--=========================================================
--  TP BAT motor (queda inactivo permanentemente)
--=========================================================
local function tpBatDisconnectAntiDie()
    for _, conn in ipairs(TPBatState.antiDieConnections) do
        pcall(function() conn:Disconnect() end)
    end
    TPBatState.antiDieConnections = {}
end

local function tpBatHookAntiDie(character)
    tpBatDisconnectAntiDie()
    if not TPBatState.enabled or not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end
    pcall(function()
        humanoid.BreakJointsOnDeath = false
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
        humanoid:SetStateEnabled(Enum.HumanoidStateType.Dying, false)
    end)
    table.insert(TPBatState.antiDieConnections,
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if TPBatState.enabled and humanoid.Parent and humanoid.Health <= 0 then
                pcall(function()
                    humanoid.Health = humanoid.MaxHealth
                    humanoid:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end
        end)
    )
end

local function tpBatFindBat()
    local character = LP.Character
    if not character then return nil end
    local function isBat(tool)
        if not tool:IsA("Tool") then return false end
        local name = tool.Name:lower()
        return name:find("bat") ~= nil or name:find("slap") ~= nil
    end
    for _, child in ipairs(character:GetChildren()) do
        if isBat(child) then return child end
    end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if not backpack then return nil end
    for _, child in ipairs(backpack:GetChildren()) do
        if isBat(child) then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                pcall(function() humanoid:EquipTool(child) end)
            end
            return child
        end
    end
    return nil
end

local function tpBatSwing()
    if TPBatState.hitCooldown then return end
    TPBatState.hitCooldown = true
    pcall(function()
        local bat = tpBatFindBat()
        if not bat then return end
        bat:Activate()
        local remote = bat:FindFirstChildWhichIsA("RemoteEvent")
        if remote then remote:FireServer() end
    end)
    task.delay(0.08, function()
        TPBatState.hitCooldown = false
    end)
end

local function tpBatTick()
    if not TPBatState.enabled then return end
    local character = LP.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then return end

    local animator = humanoid:FindFirstChildOfClass("Animator")
    if animator then
        pcall(function()
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
                track:Stop()
            end
        end)
    end

    local bat = tpBatFindBat()
    if bat and bat.Parent ~= character then
        pcall(function() humanoid:EquipTool(bat) end)
    end

    local closestPlayer, closestDistance = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = player.Character:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                local distance = (root.Position - targetRoot.Position).Magnitude
                if distance < closestDistance then
                    closestDistance = distance
                    closestPlayer = player
                end
            end
        end
    end

    if not closestPlayer or closestDistance > 100 then return end
    local targetRoot = closestPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end

    pcall(function()
        if root.SetNetworkOwner then root:SetNetworkOwner(nil) end
    end)
    if not TPBatState.enabled or root.Parent ~= character or not targetRoot.Parent then return end
    root.CFrame = CFrame.new(targetRoot.Position + Vector3.new(0, 0.9, 0))
    root.AssemblyLinearVelocity = targetRoot.AssemblyLinearVelocity
    pcall(function()
        if root.SetNetworkOwner then root:SetNetworkOwner(LP) end
    end)

    local cam = workspace.CurrentCamera
    if cam then
        cam.CFrame = CFrame.new(cam.CFrame.Position, targetRoot.Position)
    end

    tpBatSwing()

    pcall(function()
        for _, descendant in ipairs(character:GetDescendants()) do
            if descendant:IsA("BasePart") then
                descendant.CanCollide = false
            end
        end
    end)
end

function tpBatSetEnabled(value)
    TPBatState.enabled = value == true
    if TPBatState.enabled then
        tpBatHookAntiDie(LP.Character)
        if TPBatState.connection then
            TPBatState.connection:Disconnect()
            TPBatState.connection = nil
        end
        TPBatState.connection = RunService.Heartbeat:Connect(tpBatTick)
    else
        if TPBatState.connection then
            TPBatState.connection:Disconnect()
            TPBatState.connection = nil
        end
        tpBatDisconnectAntiDie()
        local character = LP.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if root then
            pcall(function()
                if root.SetNetworkOwner then root:SetNetworkOwner(LP) end
            end)
        end
    end
end

LP.CharacterAdded:Connect(function(character)
    if TPBatState.enabled then
        task.wait(0.1)
        tpBatHookAntiDie(character)
    end
end)
--=========================================================
--  FIN TP BAT
--=========================================================

function buildGui()
    local ROW_BG = Color3.fromRGB(10,10,10)
    local ROW_BORDER = Color3.fromRGB(50,50,50)
    local WHITE = Color3.fromRGB(255,255,255)
    local INP = Color3.fromRGB(15,15,15)
    local GUI_W, GUI_H = 330, 520

    local GUI_NAMES = {"RivalHub", "RivalHubMobilePanel", "RivalHubSpeedIndicator", "RivalHubBootErrors"}

    local _okCg, _coreGui = pcall(function() return game:GetService("CoreGui") end)
    local _pgOld = LP:FindFirstChild("PlayerGui")
    for _, n in ipairs(GUI_NAMES) do
        if _okCg and _coreGui then
            local okFind, oldCg = pcall(function() return _coreGui:FindFirstChild(n) end)
            if okFind and oldCg then pcall(function() oldCg:Destroy() end) end
        end
        if _pgOld then
            local okFind2, o = pcall(function() return _pgOld:FindFirstChild(n) end)
            if okFind2 and o then pcall(function() o:Destroy() end) end
        end
    end

    gui = Instance.new("ScreenGui")
    gui.Name = "RivalHub"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 10
    gui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    local guiOk = pcall(function() gui.Parent = game:GetService("CoreGui") end)
    if not guiOk then gui.Parent = LP:WaitForChild("PlayerGui") end

    main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, GUI_W, 0, GUI_H)
    main.Position = UDim2.new(0, 20, 0, 2)
    main.BackgroundColor3 = Color3.fromRGB(0,0,0)
    main.BackgroundTransparency = 1
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)

    local scriptHeader = Instance.new("Frame", main)
    scriptHeader.Name = "ScriptHeader"
    scriptHeader.Size = UDim2.new(1, -20, 0, 130)
    scriptHeader.Position = UDim2.new(0, 10, 0, 0)
    scriptHeader.BackgroundTransparency = 1
    scriptHeader.BorderSizePixel = 0
    scriptHeader.ZIndex = 8
    Instance.new("UICorner", scriptHeader).CornerRadius = UDim.new(0, 13)

    local avatarFrame = Instance.new("Frame", scriptHeader)
    avatarFrame.Size = UDim2.new(0, 82, 0, 82)
    avatarFrame.Position = UDim2.new(0, 12, 0.5, -41)
    avatarFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
    avatarFrame.BorderSizePixel = 0
    avatarFrame.ZIndex = 9
    Instance.new("UICorner", avatarFrame).CornerRadius = UDim.new(1, 0)

    local avatarImg = Instance.new("ImageLabel", avatarFrame)
    avatarImg.Size = UDim2.new(1, 2, 1, 2)
    avatarImg.Position = UDim2.new(0, -1, 0, -1)
    avatarImg.BackgroundTransparency = 1
    avatarImg.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LP.UserId .. "&w=150&h=150"
    avatarImg.ZIndex = 10
    Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(1, 0)

    local displayNameLbl = Instance.new("TextLabel", scriptHeader)
    displayNameLbl.Size = UDim2.new(0, 220, 0, 28)
    displayNameLbl.Position = UDim2.new(0, 106, 0, 32)
    displayNameLbl.BackgroundTransparency = 1
    displayNameLbl.Text = LP.DisplayName
    displayNameLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    displayNameLbl.Font = Enum.Font.GothamBold
    displayNameLbl.TextSize = 22
    displayNameLbl.TextXAlignment = Enum.TextXAlignment.Left
    displayNameLbl.ZIndex = 9

    local usernameLbl = Instance.new("TextLabel", scriptHeader)
    usernameLbl.Size = UDim2.new(0, 220, 0, 20)
    usernameLbl.Position = UDim2.new(0, 106, 0, 64)
    usernameLbl.BackgroundTransparency = 1
    usernameLbl.Text = "@" .. LP.Name
    usernameLbl.TextColor3 = Color3.fromRGB(170, 170, 180)
    usernameLbl.Font = Enum.Font.GothamMedium
    usernameLbl.TextSize = 15
    usernameLbl.TextXAlignment = Enum.TextXAlignment.Left
    usernameLbl.ZIndex = 9

    scriptLogoRef = nil

    local bgImage = Instance.new("ImageLabel", main)
    bgImage.Name = "BackgroundImage"
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.Position = UDim2.new(0, 0, 0, 0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
    bgImage.ImageTransparency = backgroundImageTransparency
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ZIndex = 0
    bgImage.ClipsDescendants = true
    Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 18)

    mainUIScale = Instance.new("UIScale", main)
    mainUIScale.Scale = uiScaleValue / 100

    local closeBtn = Instance.new("TextButton", main)
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -42, 0, 8)
    closeBtn.BackgroundColor3 = Color3.fromRGB(30,30,35)
    closeBtn.BackgroundTransparency = 1
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "-"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 30
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 200

    closeBtn.MouseEnter:Connect(function()
        TS:Create(closeBtn, TweenInfo.new(0.12), {TextColor3 = getThemeColor()}):Play()
    end)
    closeBtn.MouseLeave:Connect(function()
        TS:Create(closeBtn, TweenInfo.new(0.12), {TextColor3 = Color3.fromRGB(255, 255, 255)}):Play()
    end)

    miniBtn = Instance.new("TextButton", gui)
    miniBtn.Name = "MinimizedFrame"
    miniBtn.Size = UDim2.new(0, 360, 0, 96)
    miniBtn.Position = UDim2.new(0, 18, 0, 60)
    do
        local miniScale = Instance.new("UIScale", miniBtn)
        miniScale.Name = "MiniScale"
        miniScale.Scale = 160 / 360
    end
    miniBtn.BackgroundColor3 = Color3.fromRGB(22, 96, 196)
    miniBtn.BackgroundTransparency = 0
    miniBtn.BorderSizePixel = 0
    miniBtn.Text = ""
    miniBtn.AutoButtonColor = false
    miniBtn.ZIndex = 21
    miniBtn.Visible = false
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0.5, 0)
    do
        local mg = Instance.new("UIGradient", miniBtn)
        mg.Rotation = 90
        mg.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(30, 118, 220)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(14, 70, 165))
        })
    end

    local miniRim = Instance.new("Frame", miniBtn)
    miniRim.Name = "Rim"
    miniRim.Size = UDim2.new(1, 0, 1, 0)
    miniRim.BackgroundTransparency = 1
    miniRim.ZIndex = 26
    Instance.new("UICorner", miniRim).CornerRadius = UDim.new(0.5, 0)
    do
        local rs = Instance.new("UIStroke", miniRim)
        rs.Thickness = 3
        rs.Color = Color3.fromRGB(196, 204, 216)
        rs.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    end

    miniBackgroundImage = Instance.new("ImageLabel", miniBtn)
    miniBackgroundImage.Name = "RivalHubMiniBackground"
    miniBackgroundImage.Size = UDim2.new(1, 0, 1, 0)
    miniBackgroundImage.BackgroundTransparency = 1
    miniBackgroundImage.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
    miniBackgroundImage.ImageTransparency = 1
    miniBackgroundImage.Visible = false
    miniBackgroundImage.ZIndex = 21

    local function silverGrad(parent)
        local g = Instance.new("UIGradient", parent)
        g.Rotation = 90
        g.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.55, Color3.fromRGB(200, 208, 222)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 160, 180))
        })
        return g
    end

    local miniSlot = Instance.new("Frame", miniBtn)
    miniSlot.Size = UDim2.new(0, 10, 0, 48)
    miniSlot.Position = UDim2.new(0, 14, 0.5, -24)
    miniSlot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    miniSlot.BorderSizePixel = 0
    miniSlot.ZIndex = 22
    Instance.new("UICorner", miniSlot).CornerRadius = UDim.new(1, 0)
    silverGrad(miniSlot)

    local miniIcon = Instance.new("Frame", miniBtn)
    miniIcon.Size = UDim2.new(0, 84, 0, 64)
    miniIcon.Position = UDim2.new(0, 32, 0.5, -32)
    miniIcon.BackgroundColor3 = Color3.fromRGB(38, 110, 210)
    miniIcon.BackgroundTransparency = 0.25
    miniIcon.BorderSizePixel = 0
    miniIcon.ZIndex = 22
    Instance.new("UICorner", miniIcon).CornerRadius = UDim.new(0, 16)
    do
        local st = Instance.new("UIStroke", miniIcon)
        st.Thickness = 1.5
        st.Color = Color3.fromRGB(90, 160, 240)
        st.Transparency = 0.4
    end

    local miniIconLbl = Instance.new("TextLabel", miniIcon)
    miniIconLbl.Size = UDim2.new(1, 0, 1, 0)
    miniIconLbl.BackgroundTransparency = 1
    miniIconLbl.Text = "RIVAL"
    miniIconLbl.Font = Enum.Font.GothamBlack
    miniIconLbl.TextSize = 20
    miniIconLbl.TextColor3 = Color3.fromRGB(255, 255, 255)
    miniIconLbl.ZIndex = 23
    silverGrad(miniIconLbl)
    do
        local st = Instance.new("UIStroke", miniIconLbl)
        st.Thickness = 1.5
        st.Color = Color3.fromRGB(12, 40, 100)
    end

    local miniTitle = Instance.new("TextLabel", miniBtn)
    miniTitle.Size = UDim2.new(0, 150, 0, 28)
    miniTitle.Position = UDim2.new(0, 128, 0, 16)
    miniTitle.BackgroundTransparency = 1
    miniTitle.Text = "RIVAL HUB"
    miniTitle.Font = Enum.Font.GothamBlack
    miniTitle.TextSize = 22
    miniTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    miniTitle.TextXAlignment = Enum.TextXAlignment.Left
    miniTitle.ZIndex = 23
    silverGrad(miniTitle)
    do
        local st = Instance.new("UIStroke", miniTitle)
        st.Thickness = 1.5
        st.Color = Color3.fromRGB(12, 40, 100)
    end

    local miniLine = Instance.new("Frame", miniBtn)
    miniLine.Size = UDim2.new(0, 132, 0, 2)
    miniLine.Position = UDim2.new(0, 130, 0, 50)
    miniLine.BackgroundColor3 = Color3.fromRGB(16, 64, 150)
    miniLine.BorderSizePixel = 0
    miniLine.ZIndex = 23
    local miniLineHi = Instance.new("Frame", miniLine)
    miniLineHi.Size = UDim2.new(0, 34, 1, 0)
    miniLineHi.Position = UDim2.new(0, 46, 0, 0)
    miniLineHi.BackgroundColor3 = Color3.fromRGB(60, 160, 255)
    miniLineHi.BorderSizePixel = 0
    miniLineHi.ZIndex = 24

    local miniSub = Instance.new("TextLabel", miniBtn)
    miniSub.Size = UDim2.new(0, 140, 0, 20)
    miniSub.Position = UDim2.new(0, 130, 0, 58)
    miniSub.BackgroundTransparency = 1
    miniSub.Text = "TAP PARA ABRIR"
    miniSub.Font = Enum.Font.Gotham
    miniSub.TextSize = 13
    miniSub.TextColor3 = Color3.fromRGB(205, 218, 240)
    miniSub.TextXAlignment = Enum.TextXAlignment.Left
    miniSub.ZIndex = 23

    local miniEnter = Instance.new("Frame", miniBtn)
    miniEnter.Size = UDim2.new(0, 76, 0, 58)
    miniEnter.Position = UDim2.new(1, -96, 0.5, -29)
    miniEnter.BackgroundColor3 = Color3.fromRGB(40, 130, 235)
    miniEnter.BorderSizePixel = 0
    miniEnter.ZIndex = 22
    Instance.new("UICorner", miniEnter).CornerRadius = UDim.new(0, 18)
    do
        local eg = Instance.new("UIGradient", miniEnter)
        eg.Rotation = 90
        eg.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 160, 250)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(20, 90, 200))
        })
        local es = Instance.new("UIStroke", miniEnter)
        es.Thickness = 3
        es.Color = Color3.fromRGB(190, 205, 225)
    end
    local miniEnterLbl = Instance.new("TextLabel", miniEnter)
    miniEnterLbl.Size = UDim2.new(1, 0, 1, 0)
    miniEnterLbl.BackgroundTransparency = 1
    miniEnterLbl.Text = "ENTRAR"
    miniEnterLbl.Font = Enum.Font.GothamBlack
    miniEnterLbl.TextSize = 14
    miniEnterLbl.TextColor3 = Color3.fromRGB(10, 22, 56)
    miniEnterLbl.ZIndex = 23

    for _, p in ipairs({
        {UDim2.new(0, 22, 0, 12)}, {UDim2.new(0, 22, 1, -26)},
        {UDim2.new(1, -30, 0, 14)}, {UDim2.new(1, -30, 1, -28)}
    }) do
        local screw = Instance.new("Frame", miniBtn)
        screw.Size = UDim2.new(0, 14, 0, 14)
        screw.Position = p[1]
        screw.BackgroundColor3 = Color3.fromRGB(150, 158, 172)
        screw.BorderSizePixel = 0
        screw.ZIndex = 24
        Instance.new("UICorner", screw).CornerRadius = UDim.new(1, 0)
        local ss = Instance.new("UIStroke", screw)
        ss.Thickness = 1.5
        ss.Color = Color3.fromRGB(220, 226, 236)
    end

    local _mainAnimating = false
    local mainOriginalPos = main.Position
    _G.__RivalHubMainOriginalPos = mainOriginalPos
    main:GetPropertyChangedSignal("Position"):Connect(function()
        if not _mainAnimating then
            mainOriginalPos = main.Position
            _G.__RivalHubMainOriginalPos = mainOriginalPos
        end
    end)

    local animScale = Instance.new("UIScale", main)
    animScale.Scale = 1
    local _openTween, _closeTween = nil, nil

    showGui = function()
        if not main then return end
        if _openTween then _openTween:Cancel() end
        if _closeTween then _closeTween:Cancel() end
        _mainAnimating = true
        main.Visible = true
        miniBtn.Visible = false
        main.Position = UDim2.new(mainOriginalPos.X.Scale, mainOriginalPos.X.Offset - 60, mainOriginalPos.Y.Scale, mainOriginalPos.Y.Offset)
        animScale.Scale = 0.5
        local info = TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
        _openTween = TS:Create(main, info, {Position = mainOriginalPos})
        TS:Create(animScale, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        _openTween:Play()
        _openTween.Completed:Connect(function()
            _openTween = nil
            _mainAnimating = false
        end)
    end

    hideGui = function()
        if not main or not main.Visible then return end
        if _openTween then _openTween:Cancel() end
        if _closeTween then _closeTween:Cancel() end
        _mainAnimating = true
        local targetPos = UDim2.new(mainOriginalPos.X.Scale, mainOriginalPos.X.Offset - 60, mainOriginalPos.Y.Scale, mainOriginalPos.Y.Offset)
        local info = TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        _closeTween = TS:Create(main, info, {Position = targetPos})
        TS:Create(animScale, TweenInfo.new(0.28, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0.5}):Play()
        _closeTween:Play()
        _closeTween.Completed:Connect(function()
            main.Visible = false
            miniBtn.Visible = true
            _closeTween = nil
            _mainAnimating = false
        end)
    end

    closeBtn.MouseButton1Click:Connect(hideGui)
    miniBtn.MouseButton1Click:Connect(showGui)

    local tabBar = Instance.new("Frame", main)
    tabBar.Visible = false
    tabBar.Size = UDim2.new(1, -8, 0, 0)
    tabBar.Position = UDim2.new(0, 4, 0, 134)
    tabBar.BackgroundTransparency = 1
    tabBar.ZIndex = 10

    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Padding = UDim.new(0, 3)

    local tabContent = Instance.new("Frame", main)
    tabContent.Size = UDim2.new(1, 0, 1, -144)
    tabContent.Position = UDim2.new(0, 0, 0, 140)
    tabContent.BackgroundTransparency = 1
    tabContent.ClipsDescendants = true
    tabContent.ZIndex = 5

    local tabs = {"Speed", "Combat", "Visual", "Config", "Keybinds"}
    tabButtons = {}
    local contentPages = {}

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton", tabBar)
        btn.Size = UDim2.new(0, 62, 1, -6)
        btn.BackgroundColor3 = Color3.fromRGB(26, 26, 34)
        btn.BackgroundTransparency = 1
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = Color3.fromRGB(150, 150, 165)
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 14
        btn.AutoButtonColor = false
        btn.ZIndex = 11
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

        local tabBgGrad = Instance.new("UIGradient", btn)
        tabBgGrad.Name = "TabBgGrad"
        tabBgGrad.Color = rivalHubGradient(getThemeColor())
        tabBgGrad.Rotation = 0

        local tabStroke = Instance.new("UIStroke", btn)
        tabStroke.Name = "TabStroke"
        tabStroke.Color = getThemeColor()
        tabStroke.Thickness = 1.5
        tabStroke.Transparency = 1

        local underline = Instance.new("Frame", btn)
        underline.Name = "Underline"
        underline.Size = UDim2.new(0, 34, 0, 3)
        underline.Position = UDim2.new(0.5, 0, 1, -3)
        underline.AnchorPoint = Vector2.new(0.5, 0)
        underline.BackgroundColor3 = getThemeColor()
        underline.BorderSizePixel = 0
        underline.Visible = false
        underline.ZIndex = 12
        Instance.new("UICorner", underline).CornerRadius = UDim.new(1, 0)

        local page = Instance.new("ScrollingFrame", tabContent)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.Position = UDim2.new(0, 0, 0, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ClipsDescendants = true
        page.ScrollBarThickness = 2
        page.ScrollBarImageColor3 = getThemeColor()
        page.ScrollBarImageTransparency = 0.3
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.ZIndex = 6
        page.Visible = (i == 1)

        local layout = Instance.new("UIListLayout", page)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 6)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

        local padding = Instance.new("UIPadding", page)
        padding.PaddingLeft = UDim.new(0, 8)
        padding.PaddingRight = UDim.new(0, 8)
        padding.PaddingTop = UDim.new(0, 6)
        padding.PaddingBottom = UDim.new(0, 20)

        contentPages[name] = page

        btn.MouseButton1Click:Connect(function()
            for _, pg2 in pairs(contentPages) do pg2.Visible = false end
            page.Visible = true
            for _, b in ipairs(tabButtons) do
                local ul = b:FindFirstChild("Underline")
                if ul then ul.Visible = false end
                local bs = b:FindFirstChild("TabStroke")
                TS:Create(b, TweenInfo.new(0.2, Enum.EasingStyle.Quint), {
                    BackgroundTransparency = 1,
                    BackgroundColor3 = Color3.fromRGB(26, 26, 34),
                    TextColor3 = Color3.fromRGB(150, 150, 165)
                }):Play()
                if bs then TS:Create(bs, TweenInfo.new(0.2), {Transparency = 1}):Play() end
            end
            local ul = btn:FindFirstChild("Underline")
            if ul then ul.Visible = true end
            local bs = btn:FindFirstChild("TabStroke")
            TS:Create(btn, TweenInfo.new(0.22, Enum.EasingStyle.Quint), {
                BackgroundTransparency = 0.15,
                BackgroundColor3 = getThemeColor(),
                TextColor3 = Color3.fromRGB(245, 245, 255)
            }):Play()
            if bs then TS:Create(bs, TweenInfo.new(0.22), {Transparency = 0.3}):Play() end
        end)

        btn.MouseEnter:Connect(function()
            if btn:FindFirstChild("Underline") and btn.Underline.Visible then return end
            TS:Create(btn, TweenInfo.new(0.15), {
                BackgroundTransparency = 0.55,
                TextColor3 = Color3.fromRGB(215, 215, 230)
            }):Play()
        end)
        btn.MouseLeave:Connect(function()
            if btn:FindFirstChild("Underline") and btn.Underline.Visible then return end
            TS:Create(btn, TweenInfo.new(0.15), {
                BackgroundTransparency = 1,
                TextColor3 = Color3.fromRGB(150, 150, 165)
            }):Play()
        end)

        table.insert(tabButtons, btn)
    end

    if tabButtons[1] then
        local ul = tabButtons[1]:FindFirstChild("Underline")
        if ul then ul.Visible = true end
        tabButtons[1].BackgroundColor3 = getThemeColor()
        tabButtons[1].BackgroundTransparency = 0.15
        tabButtons[1].TextColor3 = Color3.fromRGB(245, 245, 255)
        local bs = tabButtons[1]:FindFirstChild("TabStroke")
        if bs then bs.Transparency = 0.3 end
    end

    local pageCounters = {}

    local function getNextOrder(page)
        if not pageCounters[page] then pageCounters[page] = 0 end
        pageCounters[page] = pageCounters[page] + 1
        return pageCounters[page]
    end

    local function mkSect(page, txt)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, 0, 0, 30)
        f.BackgroundTransparency = 1
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7

        local accent = Instance.new("Frame", f)
        accent.Name = "SectAccent"
        accent.Size = UDim2.new(0, 3, 0, 15)
        accent.Position = UDim2.new(0, 5, 0.5, -7)
        accent.AnchorPoint = Vector2.new(0, 0.5)
        accent.BackgroundColor3 = getThemeColor()
        accent.BorderSizePixel = 0
        accent.ZIndex = 8
        Instance.new("UICorner", accent).CornerRadius = UDim.new(1, 0)
        local accentGrad = Instance.new("UIGradient", accent)
        accentGrad.Color = rivalHubGradient(getThemeColor())
        accentGrad.Rotation = 90

        local l = Instance.new("TextLabel", f)
        l.Size = UDim2.new(0.5, -24, 1, 0)
        l.Position = UDim2.new(0, 14, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt:upper()
        l.TextColor3 = Color3.fromRGB(235, 235, 245)
        l.Font = Enum.Font.GothamBlack
        l.TextSize = 11
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        l.TextStrokeTransparency = 0.55
        l.ZIndex = 8

        local line = Instance.new("Frame", f)
        line.Name = "SectLine"
        line.Size = UDim2.new(0, 110, 0, 1)
        line.Position = UDim2.new(1, -6, 0.5, 0)
        line.AnchorPoint = Vector2.new(1, 0.5)
        line.BackgroundColor3 = getThemeColor()
        line.BorderSizePixel = 0
        line.ZIndex = 8
        local lineGrad = Instance.new("UIGradient", line)
        lineGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0.00, 0.45),
            NumberSequenceKeypoint.new(1.00, 1.00),
        })

        return f
    end

    local function mkRow(page, h)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, -4, 0, h or 42)
        f.BackgroundColor3 = ROW_BG
        f.BackgroundTransparency = 0.7
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 11)

        local rowGrad = Instance.new("UIGradient", f)
        rowGrad.Name = "RowGrad"
        rowGrad.Rotation = 90
        rowGrad.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0.00, 0.00),
            NumberSequenceKeypoint.new(1.00, 0.30),
        })

        local rowStroke = Instance.new("UIStroke", f)
        rowStroke.Color = ROW_BORDER
        rowStroke.Thickness = 1
        rowStroke.Transparency = 0.55

        f.MouseEnter:Connect(function()
            TS:Create(f, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(22,22,26)}):Play()
            TS:Create(rowStroke, TweenInfo.new(0.15), {Color = getThemeColor(), Transparency = 0.35}):Play()
        end)
        f.MouseLeave:Connect(function()
            TS:Create(f, TweenInfo.new(0.15), {BackgroundColor3 = ROW_BG}):Play()
            TS:Create(rowStroke, TweenInfo.new(0.15), {Color = ROW_BORDER, Transparency = 0.55}):Play()
        end)
        return f
    end

    local function mkLabel(row, txt)
        local l = Instance.new("TextLabel", row)
        l.Size = UDim2.new(0.55, 0, 1, 0)
        l.Position = UDim2.new(0, 12, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = Color3.fromRGB(240, 240, 250)
        l.Font = Enum.Font.GothamMedium
        l.TextSize = 13
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextTruncate = Enum.TextTruncate.AtEnd
        l.TextStrokeColor3 = Color3.fromRGB(0,0,0)
        l.TextStrokeTransparency = 0.5
        l.ZIndex = 8
        return l
    end

    local function mkPill(row, offset)
        local pill = Instance.new("Frame", row)
        pill.Name = "Track"
        pill.Size = UDim2.new(0, 36, 0, 18)
        pill.AnchorPoint = Vector2.new(1, 0.5)
        pill.Position = UDim2.new(1, -18, 0.5, 0)
        pill.BackgroundColor3 = Color3.fromRGB(45, 47, 58)
        pill.BorderSizePixel = 0
        pill.ZIndex = 8
        Instance.new("UICorner", pill).CornerRadius = UDim.new(0, 9)
        local trackStroke = Instance.new("UIStroke", pill)
        trackStroke.Name = "TrackStroke"
        trackStroke.Color = Color3.fromRGB(88, 90, 106)
        trackStroke.Thickness = 1
        trackStroke.Transparency = 0.2

        local dot = Instance.new("Frame", pill)
        dot.Name = "Knob"
        dot.Size = UDim2.new(0, 14, 0, 14)
        dot.AnchorPoint = Vector2.new(0.5, 0.5)
        dot.Position = UDim2.new(0, 9, 0.5, 0)
        dot.BackgroundColor3 = Color3.fromRGB(205, 207, 218)
        dot.BorderSizePixel = 0
        dot.ZIndex = 9
        Instance.new("UICorner", dot).CornerRadius = UDim.new(0, 4)
        local dotStroke = Instance.new("UIStroke", dot)
        dotStroke.Color = Color3.fromRGB(150, 152, 168)
        dotStroke.Thickness = 1
        dotStroke.Transparency = 0.15
        dotStroke.Name = "KnobStroke"
        return pill, dot
    end

    local function animPill(pill, dot, on)
        local dotStroke = dot:FindFirstChild("KnobStroke")
        local trackStroke = pill:FindFirstChild("TrackStroke")
        local fadeInfo = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local c = getThemeColor()
        TS:Create(pill, fadeInfo, {BackgroundColor3 = on and c or Color3.fromRGB(45,47,58)}):Play()
        TS:Create(dot, fadeInfo, {
            Position = on and UDim2.new(1, -9, 0.5, 0) or UDim2.new(0, 9, 0.5, 0),
            BackgroundColor3 = on and Color3.fromRGB(255,255,255) or Color3.fromRGB(205,207,218),
        }):Play()
        if trackStroke then TS:Create(trackStroke, fadeInfo, {Color = on and c or Color3.fromRGB(88,90,106)}):Play() end
        if dotStroke then TS:Create(dotStroke, fadeInfo, {Color = on and c or Color3.fromRGB(150,152,168)}):Play() end
    end

    local function mkToggle(page, txt, cb)
        local row = mkRow(page, 42)
        mkLabel(row, txt)
        local pill, dot = mkPill(row, 62)
        local on = false
        local function sv(s) on = s; animPill(pill, dot, s) end
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 10
        clk.MouseButton1Click:Connect(function()
            on = not on
            sv(on)
            pcall(cb, on)
            task.defer(function() pcall(saveAllSettings) end)
        end)
        return sv
    end

    local function mkSelector(parent, default, options, cb)
        local container = Instance.new("Frame", parent)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        local label = Instance.new("TextLabel", container)
        label.Size = UDim2.new(0, 80, 0, 26)
        label.Position = UDim2.new(0.5, -40, 0.5, -13)
        label.BackgroundTransparency = 1
        label.Text = default
        label.TextColor3 = WHITE
        label.Font = Enum.Font.GothamBold
        label.TextSize = 12
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local function updateLabel(newText) label.Text = newText end
        leftBtn.MouseButton1Click:Connect(function()
            if cb then cb(-1, updateLabel); task.defer(function() pcall(saveAllSettings) end) end
        end)
        rightBtn.MouseButton1Click:Connect(function()
            if cb then cb(1, updateLabel); task.defer(function() pcall(saveAllSettings) end) end
        end)
        return label
    end

    local function mkBox(parent, default, w, xOff, cb)
        local tb = Instance.new("TextBox", parent)
        local bw = w or 50
        local xo = math.max(xOff or 56, bw + 12)
        tb.Size = UDim2.new(0, bw, 0, 24)
        tb.Position = UDim2.new(1, -xo, 0.5, -12)
        tb.BackgroundColor3 = INP
        tb.BackgroundTransparency = 0.7
        tb.BorderSizePixel = 0
        tb.Text = tostring(default)
        tb.TextColor3 = WHITE
        tb.Font = Enum.Font.GothamMedium
        tb.TextSize = 11
        tb.ClearTextOnFocus = false
        tb.ZIndex = 8
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 6)
        local bs = Instance.new("UIStroke", tb)
        bs.Color = ROW_BORDER
        bs.Thickness = 1.2
        bs.Transparency = 0.25
        tb.Focused:Connect(function() TS:Create(bs, TweenInfo.new(0.12), {Color = getThemeColor(), Transparency = 0}):Play() end)
        tb.FocusLost:Connect(function()
            TS:Create(bs, TweenInfo.new(0.12), {Color = ROW_BORDER, Transparency = 0.25}):Play()
            if cb then
                local n = tonumber(tb.Text)
                if n then cb(n) else tb.Text = tostring(default) end
                task.defer(function() saveAllSettings() end)
            end
        end)
        return tb
    end

    local function mkKeyButton(parent, kbEntry)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 80, 0, 24)
        btn.Position = UDim2.new(1, -88, 0.5, -12)
        btn.BackgroundColor3 = INP
        btn.BackgroundTransparency = 0.5
        btn.BorderSizePixel = 0
        local function getLabel() return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None" end
        btn.Text = getLabel()
        btn.TextColor3 = WHITE
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 9
        btn.ZIndex = 8
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
        local bs = Instance.new("UIStroke", btn)
        bs.Color = ROW_BORDER
        bs.Thickness = 1
        local li = false; local lc; local pv = btn.Text; local listenStart = 0
        btn.Activated:Connect(function()
            if li then li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; btn.TextColor3 = WHITE; return end
            pv = btn.Text; li = true; _anyKeyListening = true; listenStart = _tick(); btn.Text = "..."; btn.TextColor3 = WHITE
            lc = UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode == Enum.KeyCode.Escape then li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; btn.TextColor3 = WHITE; return end
                local isGp = isGamepadInput(inp)
                if isGp and _tick()-listenStart < 0.15 then return end
                if not isBindableInput(inp) then return end
                btn.Text = inp.KeyCode.Name; pv = inp.KeyCode.Name; btn.TextColor3 = WHITE
                li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end
                if isGp then kbEntry.gp = inp.KeyCode; kbEntry.kb = nil else kbEntry.kb = inp.KeyCode; kbEntry.gp = nil end
                task.defer(function() saveAllSettings() end)
            end)
        end)
        table.insert(keyButtonRefs, {btn = btn, entry = kbEntry})
        return btn
    end

    local function addKeybindRow(page, labelText, kbEntry)
        local row = mkRow(page, 40)
        mkLabel(row, labelText)
        mkKeyButton(row, kbEntry)
    end

    local speedPage = contentPages["Speed"]

    mkSect(speedPage, "Movement Speeds")
    do local row = mkRow(speedPage, 42); mkLabel(row, "Normal Speed"); normalBox = mkBox(row, NS, 50, 56, function(v) if v == v and v > 0 and v < math.huge then NS = v; if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end end end) end
    do local row = mkRow(speedPage, 42); mkLabel(row, "Carry Speed"); carryBox = mkBox(row, CS, 50, 56, function(v) if v == v and v > 0 and v < math.huge then CS = v; if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end end end) end
    do local row = mkRow(speedPage, 42); mkLabel(row, "Lagger Normal Speed"); laggerBox = mkBox(row, LAGGER_SPEED, 50, 56, function(v) if v == v and v > 0 and v < math.huge then LAGGER_SPEED = v; if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end end end) end
    do local row = mkRow(speedPage, 42); mkLabel(row, "Lagger Carry Speed"); lagger2Box = mkBox(row, LAGGER_CARRY_SPEED, 50, 56, function(v) if v == v and v > 0 and v < math.huge then LAGGER_CARRY_SPEED = v; if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end end end) end

    mkSect(speedPage, "Active Mode")
    do
        local row = mkRow(speedPage, 42)
        mkLabel(row, "Current Mode")
        modeValLbl = Instance.new("TextLabel", row)
        modeValLbl.Size = UDim2.new(0, 110, 1, 0)
        modeValLbl.Position = UDim2.new(1, -118, 0, 0)
        modeValLbl.BackgroundTransparency = 1
        modeValLbl.Text = "Normal"
        modeValLbl.TextColor3 = WHITE
        modeValLbl.Font = Enum.Font.GothamBold
        modeValLbl.TextSize = 12
        modeValLbl.TextXAlignment = Enum.TextXAlignment.Right
        modeValLbl.ZIndex = 8
        local clk = Instance.new("TextButton", row)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 8
        clk.MouseButton1Click:Connect(function() toggleCarryMode() end)
    end

    mkSect(speedPage, "Auto Movement")
    autoLeftSetVisual = mkToggle(speedPage, "Auto Left", function(on)
        autoLeftEnabled = on
        if on then startAutoLeft() else stopAutoLeft() end
        if mobSetAutoLeft then mobSetAutoLeft(on) end
    end)
    autoRightSetVisual = mkToggle(speedPage, "Auto Right", function(on)
        autoRightEnabled = on
        if on then startAutoRight() else stopAutoRight() end
        if mobSetAutoRight then mobSetAutoRight(on) end
    end)

    mkSect(speedPage, "Infinite Jump")
    infJumpSetVisual = mkToggle(speedPage, "Infinite Jump", function(on)
        if on then InfiniteJump.start() else InfiniteJump.stop() end
    end)
    do
        local row = mkRow(speedPage, 42)
        mkLabel(row, "Jump Mode")
        local modeBtn = Instance.new("TextButton", row)
        modeBtn.Size = UDim2.new(0, 100, 1, 0)
        modeBtn.Position = UDim2.new(1, -108, 0, 0)
        modeBtn.BackgroundColor3 = INP
        modeBtn.BackgroundTransparency = 0.4
        modeBtn.BorderSizePixel = 0
        modeBtn.Text = "HOLD"
        modeBtn.TextColor3 = WHITE
        modeBtn.Font = Enum.Font.GothamBold
        modeBtn.TextSize = 11
        modeBtn.ZIndex = 8
        Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, 6)
        infJumpModeBtn = modeBtn
        modeBtn.Activated:Connect(function()
            local nextMode = InfiniteJump.mode == "hold" and "manual" or "hold"
            InfiniteJump.setMode(nextMode)
            modeBtn.Text = string.upper(nextMode)
            if InfiniteJump.enabled then InfiniteJump.stop(); InfiniteJump.start() end
            pcall(saveAllSettings, true)
        end)
    end

    local combatPage = contentPages["Combat"]

    mkSect(combatPage, "Defense")
    setAntiBatVisual = mkToggle(combatPage, "Anti Bat", function(on)
        if on then startAntiBat() else stopAntiBat() end
    end)
    setAntiFlingVisual = mkToggle(combatPage, "Anti Fling", function(on)
        antiFlingEnabled = on
        if on then startAntiFling() else stopAntiFling() end
        saveAllSettings()
    end)
    if setAntiFlingVisual then setAntiFlingVisual(antiFlingEnabled) end
    mkSect(combatPage, "Anti Ragdoll")
    do
        local row = mkRow(combatPage, 38)
        mkLabel(row, "Anti Ragdoll")
        local selectorBtn = Instance.new("TextButton", row)
        selectorBtn.Size = UDim2.new(0, 100, 1, 0)
        selectorBtn.Position = UDim2.new(1, -108, 0, 0)
        selectorBtn.BackgroundColor3 = Color3.fromRGB(12,12,12)
        selectorBtn.BackgroundTransparency = 0.7
        selectorBtn.BorderSizePixel = 0
        selectorBtn.Text = "Off ▼"
        selectorBtn.TextColor3 = Color3.fromRGB(255,255,255)
        selectorBtn.Font = Enum.Font.GothamBold
        selectorBtn.TextSize = 12
        selectorBtn.AutoButtonColor = false
        selectorBtn.ZIndex = 8
        Instance.new("UICorner", selectorBtn).CornerRadius = UDim.new(0, 6)
        local selStroke = Instance.new("UIStroke", selectorBtn)
        selStroke.Color = Color3.fromRGB(50,50,50)
        selStroke.Thickness = 1

        local dropdown = Instance.new("Frame", combatPage)
        dropdown.Size = UDim2.new(0, 100, 0, 90)
        dropdown.Position = UDim2.new(0, 0, 0, 0)
        dropdown.BackgroundColor3 = Color3.fromRGB(20,20,25)
        dropdown.BackgroundTransparency = 0.9
        dropdown.BorderSizePixel = 0
        dropdown.Visible = false
        dropdown.ZIndex = 20
        Instance.new("UICorner", dropdown).CornerRadius = UDim.new(0, 8)
        local dropStroke = Instance.new("UIStroke", dropdown)
        dropStroke.Color = Color3.fromRGB(50,50,50)
        dropStroke.Thickness = 1

        local options = {"Off", "V1", "V2"}
        local optionButtons = {}
        for i, opt in ipairs(options) do
            local btn = Instance.new("TextButton", dropdown)
            btn.Size = UDim2.new(1, 0, 0, 30)
            btn.Position = UDim2.new(0, 0, 0, (i-1)*30)
            btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
            btn.BackgroundTransparency = 0.5
            btn.BorderSizePixel = 0
            btn.Text = opt
            btn.TextColor3 = Color3.fromRGB(255,255,255)
            btn.Font = Enum.Font.GothamBold
            btn.TextSize = 12
            btn.ZIndex = 21
            btn.AutoButtonColor = false
            btn.MouseButton1Click:Connect(function()
                local mode = opt:lower()
                setAntiRagdollMode(mode)
                dropdown.Visible = false
            end)
            optionButtons[opt] = btn
        end

        selectorBtn.MouseButton1Click:Connect(function()
            if dropdown.Visible then
                dropdown.Visible = false
                return
            end
            local absPos = selectorBtn.AbsolutePosition
            local size = selectorBtn.AbsoluteSize
            dropdown.Position = UDim2.new(0, absPos.X, 0, absPos.Y + size.Y)
            dropdown.Visible = true
        end)

        UIS.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 then
                if dropdown.Visible then
                    local mousePos = input.Position
                    local absPos = dropdown.AbsolutePosition
                    local size = dropdown.AbsoluteSize
                    if not (mousePos.X >= absPos.X and mousePos.X <= absPos.X + size.X and
                            mousePos.Y >= absPos.Y and mousePos.Y <= absPos.Y + size.Y) then
                        dropdown.Visible = false
                    end
                end
            end
        end)

        local function updateAntiRagdollUI(mode)
            local label = mode:gsub("^%l", string.upper)
            if mode == "off" then label = "Off" end
            selectorBtn.Text = label .. " ▼"
            for opt, btn in pairs(optionButtons) do
                if opt:lower() == mode then
                    btn.BackgroundColor3 = getThemeColor()
                    btn.TextColor3 = Color3.fromRGB(0,0,0)
                else
                    btn.BackgroundColor3 = Color3.fromRGB(0,0,0)
                    btn.TextColor3 = Color3.fromRGB(255,255,255)
                end
            end
        end

        _G.updateAntiRagdollUI = updateAntiRagdollUI
        updateAntiRagdollUI(antiRagdollMode)
        setAntiRagVisual = function(on)
            if not on then setAntiRagdollMode("off") end
        end
    end

    setAntiDieVisual = mkToggle(combatPage, "Anti Die", function(on)
        antiDieEnabled = on
        if on then AntiDieModule.start() else AntiDieModule.stop() end
        saveAllSettings()
    end)
    if setAntiDieVisual then setAntiDieVisual(antiDieEnabled) end

    setUnwalkVisual = mkToggle(combatPage, "Unwalk", function(on)
        unwalkEnabled = on
        if on then startUnwalk() else stopUnwalk() end
    end)

    mkSect(combatPage, "Attack")
    autoBatSetVisual = mkToggle(combatPage, "Bypass Bat", function(on)
        if on then enableAutoBat() else disableAutoBat() end
        if mobSetAutoBat then mobSetAutoBat(on) end
        pcall(saveAllSettings, true)
    end)
    do local row = mkRow(combatPage, 42); mkLabel(row, "Bypass Speed"); batSpeedBox = mkBox(row, BYPASS_AIMBOT_SPEED, 50, 56, function(v) if v == v and v > 0 and v < math.huge then BAT_AIMBOT_SPEED = v; BYPASS_AIMBOT_SPEED = v; State.bypassBatSpeed = v; saveAllSettings() end end) end

    mkSect(combatPage, "Targeting")
    bodyLockSetVisual = mkToggle(combatPage, "Lock Enemy", function(on)
        bodyLockEnabled = on
        if on then
            if _blSuppressCount == 0 then startBodyLock() end
        else
            stopBodyLock()
        end
    end)
    do
        local row = mkRow(combatPage, 42)
        mkLabel(row, "Lock Enemy Range")
        bodyLockRangeBox = mkBox(row, bodyLockRange, 50, 56, function(v)
            if v and v > 0 then
                bodyLockRange = _clamp(_floor(v), 5, 200)
                if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
            end
        end)
    end

    mkSect(combatPage, "Counters")
    setBatCounterVisual = mkToggle(combatPage, "Bat Counter", function(on)
        batCounterEnabled = on
        if on then startBatCounter() else stopBatCounter() end
    end)
    setBatCounterV2Visual = mkToggle(combatPage, "Bat Counter V2", function(on)
        batCounterV2Enabled = on
        if on then startBatCounterV2() else stopBatCounterV2() end
    end)
    setMedusaVisual = mkToggle(combatPage, "Medusa Counter", function(on)
        medusaCounterEnabled = on
        if on then
            if LP.Character then setupMedusaCounter(LP.Character) else stopMedusaCounter() end
        else
            stopMedusaCounter()
        end
        if setMedusaVisual then setMedusaVisual(on) end
    end)

    mkSect(combatPage, "Drop")
    dropBrainrotSetVisual = mkToggle(combatPage, "Drop Brainrot", function(on)
        if on then
            executeDropWithToggle(function(v)
                dropBrainrotSetVisual(v)
                if mobSetDropBR then mobSetDropBR(v) end
            end)
        end
    end)
    setDropVisual = dropBrainrotSetVisual
    do
        local row = mkRow(combatPage, 42)
        mkLabel(row, "Drop Mode")
        dropModeBtnRef = mkSelector(row, dropMode == 1 and "Fling" or "Jump Drop", {"Fling", "Jump Drop"}, function(dir, update)
            if dropActive then stopDropBrainrot() end
            dropMode = dropMode == 1 and 2 or 1
            update(dropMode == 1 and "Fling" or "Jump Drop")
        end)
    end

    local visualPage = contentPages["Visual"]

    mkSect(visualPage, "Interface")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Background")

        local options = {"None"}
        for i = 1, #backgroundImages do
            table.insert(options, "Background " .. i)
        end

        local function currentOptionIndex()
            if backgroundMode == "None" then return 1 end
            local n = tonumber(string.match(backgroundMode, "^Background%s+(%d+)$")) or 1
            return _clamp(n + 1, 1, #options)
        end

        backgroundSelectorLabel = mkSelector(row, backgroundMode, options, function(direction, updateLabel)
            local idx = currentOptionIndex() + direction
            if idx < 1 then idx = #options end
            if idx > #options then idx = 1 end
            applyBackgroundMode(options[idx])
            updateLabel(backgroundMode)
        end)
        applyBackgroundMode(backgroundMode)
    end
    setLockUIVisual = mkToggle(visualPage, "Lock UI", function(on) toggleLockUI(on) end)
    setHideButtonsVisual = mkToggle(visualPage, "Hide Button", function(on) toggleHideButtons(on) end)
    if setHideButtonsVisual then setHideButtonsVisual(hideButtonsEnabled) end

    mkSect(visualPage, "Display")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "UI Scale")
        uiScaleBox = mkBox(row, uiScaleValue, 50, 56, function(v)
            local n = _clamp(_floor(v+0.5), 50, 150)
            uiScaleValue = n
            if mainUIScale then mainUIScale.Scale = n/100 end
            if pbScale then pbScale.Scale = n/100 end
        end)
    end
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Button Scale")
        local box = mkBox(row, _floor(floatingButtonScale * 100), 50, 56, function(v)
            local val = _clamp(v, 50, 200)
            floatingButtonScale = val / 100
            applyFloatingButtonScale()
            saveAllSettings()
        end)
    end

    mkSect(visualPage, "Character")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Anim Pack")
        local currentIndex = 1
        for i, entry in ipairs(ANIM_PACK_ORDER) do
            if entry[2] == currentAnimPack then currentIndex = i; break end
        end
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        animSelectorLabel = Instance.new("TextLabel", container)
        animSelectorLabel.Size = UDim2.new(0, 80, 0, 26)
        animSelectorLabel.Position = UDim2.new(0.5, -40, 0.5, -13)
        animSelectorLabel.BackgroundTransparency = 1
        animSelectorLabel.Text = ANIM_PACK_ORDER[currentIndex][2]
        animSelectorLabel.TextColor3 = WHITE
        animSelectorLabel.Font = Enum.Font.GothamBold
        animSelectorLabel.TextSize = 12
        animSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        animSelectorLabel.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local function updateAnimSelector(direction)
            local idx = 1
            for i, entry in ipairs(ANIM_PACK_ORDER) do
                if entry[2] == currentAnimPack then idx = i; break end
            end
            local newIdx = idx + direction
            if newIdx < 1 then newIdx = #ANIM_PACK_ORDER end
            if newIdx > #ANIM_PACK_ORDER then newIdx = 1 end
            local packName = ANIM_PACK_ORDER[newIdx][2]
            if packName == "Off" then stopAnimPack() else startAnimPack(packName) end
        end
        leftBtn.MouseButton1Click:Connect(function() updateAnimSelector(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateAnimSelector(1) end)
    end
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Outfit")
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        outfitSelectorLabel = Instance.new("TextLabel", container)
        outfitSelectorLabel.Size = UDim2.new(0, 80, 0, 26)
        outfitSelectorLabel.Position = UDim2.new(0.5, -40, 0.5, -13)
        outfitSelectorLabel.BackgroundTransparency = 1
        outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
        outfitSelectorLabel.TextColor3 = WHITE
        outfitSelectorLabel.Font = Enum.Font.GothamBold
        outfitSelectorLabel.TextSize = 12
        outfitSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        outfitSelectorLabel.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local function updateOutfit(direction)
            pcall(VX7A.stop)
            local newIdx = currentOutfitIndex + direction
            if newIdx < 1 then newIdx = #OUTFITS end
            if newIdx > #OUTFITS then newIdx = 1 end
            currentOutfitIndex = newIdx
            pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
            if outfitSelectorLabel then outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label end
            saveAllSettings()
        end
        leftBtn.MouseButton1Click:Connect(function() updateOutfit(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateOutfit(1) end)
    end

    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Best Avatars")
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        VX7A.label = Instance.new("TextLabel", container)
        VX7A.label.Size = UDim2.new(0, 80, 0, 26)
        VX7A.label.Position = UDim2.new(0.5, -40, 0.5, -13)
        VX7A.label.BackgroundTransparency = 1
        VX7A.label.Text = VX7A.labels[VX7A.index + 1] or "OFF"
        VX7A.label.TextColor3 = WHITE
        VX7A.label.Font = Enum.Font.GothamBold
        VX7A.label.TextSize = 12
        VX7A.label.TextXAlignment = Enum.TextXAlignment.Center
        VX7A.label.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local function stepVX7Avatar(direction)
            local pos = VX7A.index + 1 + direction
            if pos < 1 then pos = #VX7A.labels end
            if pos > #VX7A.labels then pos = 1 end
            VX7A.apply(pos - 1)
            task.defer(function() pcall(saveAllSettings) end)
        end
        leftBtn.MouseButton1Click:Connect(function() stepVX7Avatar(-1) end)
        rightBtn.MouseButton1Click:Connect(function() stepVX7Avatar(1) end)
    end

    mkSect(visualPage, "Effects")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "RIVAL Title Color")
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        rivalTitleSelectorLabel = Instance.new("TextLabel", container)
        rivalTitleSelectorLabel.Size = UDim2.new(0, 80, 0, 26)
        rivalTitleSelectorLabel.Position = UDim2.new(0.5, -40, 0.5, -13)
        rivalTitleSelectorLabel.BackgroundTransparency = 1
        rivalTitleSelectorLabel.Text = currentRivalTitleTheme
        rivalTitleSelectorLabel.TextColor3 = WHITE
        rivalTitleSelectorLabel.Font = Enum.Font.GothamBold
        rivalTitleSelectorLabel.TextSize = 12
        rivalTitleSelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        rivalTitleSelectorLabel.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)

        local RIVAL_THEME_LIST = { "Blue", "Red", "Green", "Black", "Gray" }
        local function cycleRivalTitle(dir)
            local idx = 1
            for i, name in ipairs(RIVAL_THEME_LIST) do
                if name == currentRivalTitleTheme then idx = i; break end
            end
            local newIdx = idx + dir
            if newIdx < 1 then newIdx = #RIVAL_THEME_LIST end
            if newIdx > #RIVAL_THEME_LIST then newIdx = 1 end
            applyRivalTitleTheme(RIVAL_THEME_LIST[newIdx])
        end
        leftBtn.MouseButton1Click:Connect(function() cycleRivalTitle(-1) end)
        rightBtn.MouseButton1Click:Connect(function() cycleRivalTitle(1) end)
    end
    setVividVisual = mkToggle(visualPage, "Vivid Graphics", function(on)
        toggleVividGraphics(on)
        if setVividVisual then setVividVisual(on) end
    end)
    if setVividVisual then setVividVisual(vividGraphicsEnabled) end
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Stretch Rez")
        local stretchPill, stretchDot = mkPill(row, 48)
        local stretchOn = false
        local function setStretch(s)
            stretchOn = s
            animPill(stretchPill, stretchDot, s)
            if s then enableStretch() else disableStretch() end
            stretchEnabled = s
        end
        local stretchClk = Instance.new("TextButton", stretchPill)
        stretchClk.Size = UDim2.new(1,0,1,0)
        stretchClk.BackgroundTransparency = 1
        stretchClk.Text = ""
        stretchClk.AutoButtonColor = false
        stretchClk.ZIndex = 10
        stretchClk.MouseButton1Click:Connect(function() setStretch(not stretchOn) end)
        _G.stretchToggleSetter = setStretch
    end
    setAntiLagVisual = mkToggle(visualPage, "Anti Lag", function(on)
        if on then enableAntiLag() else disableAntiLag() end
        antiLagEnabled = on == true
        pcall(saveAllSettings, true)
    end)
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Sky Theme")
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.7
        leftBtn.BorderSizePixel = 0
        leftBtn.Text = "<"
        leftBtn.TextColor3 = WHITE
        leftBtn.Font = Enum.Font.GothamBold
        leftBtn.TextSize = 13
        leftBtn.AutoButtonColor = false
        leftBtn.ZIndex = 9
        Instance.new("UICorner", leftBtn).CornerRadius = UDim.new(0, 6)
        skySelectorLabel = Instance.new("TextLabel", container)
        skySelectorLabel.Size = UDim2.new(0, 96, 0, 26)
        skySelectorLabel.Position = UDim2.new(0.5, -48, 0.5, -13)
        skySelectorLabel.BackgroundTransparency = 1
        skySelectorLabel.Text = skyTheme
        skySelectorLabel.TextColor3 = WHITE
        skySelectorLabel.Font = Enum.Font.GothamBold
        skySelectorLabel.TextSize = 11
        skySelectorLabel.TextXAlignment = Enum.TextXAlignment.Center
        skySelectorLabel.ZIndex = 9
        local rightBtn = Instance.new("TextButton", container)
        rightBtn.Size = UDim2.new(0, 28, 0, 26)
        rightBtn.Position = UDim2.new(1, -28, 0.5, -13)
        rightBtn.BackgroundColor3 = INP
        rightBtn.BackgroundTransparency = 0.7
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)
        local function updateSkySelector(direction)
            local idx = 1
            for i, name in ipairs(SKY_PRESETS_LIST) do
                if name == skyTheme then idx = i; break end
            end
            local newIdx = idx + direction
            if newIdx < 1 then newIdx = #SKY_PRESETS_LIST end
            if newIdx > #SKY_PRESETS_LIST then newIdx = 1 end
            local name = SKY_PRESETS_LIST[newIdx]
            skyTheme = name
            pcall(applyCustomSky, name)
            if skySelectorLabel then skySelectorLabel.Text = name end
            pcall(saveAllSettings, true)
        end
        leftBtn.MouseButton1Click:Connect(function() updateSkySelector(-1) end)
        rightBtn.MouseButton1Click:Connect(function() updateSkySelector(1) end)
    end

    mkSect(visualPage, "Overlays")
    setESPVIsual = mkToggle(visualPage, "Player ESP", function(on) toggleESP(on) end)
    setESPLineVisual = mkToggle(visualPage, "ESP Line", function(on)
        if on then startESPLine() else stopESPLine() end
    end)

    local configPage = contentPages["Config"]

    mkSect(configPage, "Automation")

    setInstaGrab = mkToggle(configPage, "Auto Steal", function(on)
        CONFIG.AUTO_STEAL_ENABLED = on == true
        if on then pcall(startAutoSteal) else stopAutoSteal() end
        updateProgressBarVisibility()
        pcall(saveAllSettings, true)
    end)
    do
        local row = mkRow(configPage, 42)
        mkLabel(row, "Auto Steal Mode")
        local modeBtn = Instance.new("TextButton", row)
        modeBtn.Size = UDim2.new(0, 100, 1, 0)
        modeBtn.Position = UDim2.new(1, -108, 0, 0)
        modeBtn.BackgroundColor3 = INP
        modeBtn.BackgroundTransparency = 0.4
        modeBtn.BorderSizePixel = 0
        modeBtn.Text = autoStealMode
        modeBtn.TextColor3 = WHITE
        modeBtn.Font = Enum.Font.GothamBold
        modeBtn.TextSize = 11
        modeBtn.ZIndex = 8
        Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, 6)
        autoStealModeBtn = modeBtn
        modeBtn.Activated:Connect(function()
            autoStealMode = autoStealMode == "V1" and "V2" or "V1"
            modeBtn.Text = autoStealMode
            if CONFIG.AUTO_STEAL_ENABLED then stopAutoSteal(); startAutoSteal() end
            pcall(saveAllSettings, true)
        end)
    end
    do
        local row = mkRow(configPage, 42)
        mkLabel(row, "Steal Radius")
        radInput = mkBox(row, CONFIG.STEAL_RANGE, 50, 56, function(v)
            if v and v >= 5 and v <= 300 then
                CONFIG.STEAL_RANGE = _floor(v+0.5)
                Steal.StealRadius = CONFIG.STEAL_RANGE
                radInput.Text = tostring(CONFIG.STEAL_RANGE)
                saveAllSettings()
            end
        end)
    end

    mkSect(configPage, "Management")
    do
        local row = mkRow(configPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local saveBtn = Instance.new("TextButton", row)
        saveBtn.Size = UDim2.new(1, -12, 0.8, 0)
        saveBtn.Position = UDim2.new(0, 6, 0.1, 0)
        saveBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
        saveBtn.BorderSizePixel = 0
        saveBtn.Text = "SAVE CONFIG"
        saveBtn.TextColor3 = Color3.fromRGB(20, 20, 25)
        saveBtn.Font = Enum.Font.GothamBold
        saveBtn.TextSize = 13
        saveBtn.AutoButtonColor = false
        saveBtn.ZIndex = 8
        Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 10)
        local saveStroke = Instance.new("UIStroke", saveBtn)
        saveStroke.Color = getThemeColor()
        saveStroke.Thickness = 1.5
        saveStroke.Transparency = 0.4
        saveBtn.MouseEnter:Connect(function()
            TS:Create(saveBtn, TweenInfo.new(0.15), {BackgroundColor3 = getThemeColor()}):Play()
            TS:Create(saveBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end)
        saveBtn.MouseLeave:Connect(function()
            TS:Create(saveBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(245, 245, 250)}):Play()
            TS:Create(saveBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(20, 20, 25)}):Play()
        end)
        saveBtn.MouseButton1Click:Connect(function()
            local ok = saveAllSettings(true)
            saveBtn.Text = ok and "SAVED" or "ERROR"
            task.delay(1.2, function()
                if saveBtn and saveBtn.Parent then saveBtn.Text = "SAVE CONFIG" end
            end)
        end)
    end
    do
        local row = mkRow(configPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local resetPosBtn = Instance.new("TextButton", row)
        resetPosBtn.Size = UDim2.new(1, -12, 0.8, 0)
        resetPosBtn.Position = UDim2.new(0, 6, 0.1, 0)
        resetPosBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
        resetPosBtn.BorderSizePixel = 0
        resetPosBtn.Text = "RESET POSITIONS"
        resetPosBtn.TextColor3 = Color3.fromRGB(20, 20, 25)
        resetPosBtn.Font = Enum.Font.GothamBold
        resetPosBtn.TextSize = 13
        resetPosBtn.AutoButtonColor = false
        resetPosBtn.ZIndex = 8
        Instance.new("UICorner", resetPosBtn).CornerRadius = UDim.new(0, 10)
        local resetStroke = Instance.new("UIStroke", resetPosBtn)
        resetStroke.Color = getThemeColor()
        resetStroke.Thickness = 1.5
        resetStroke.Transparency = 0.4
        resetPosBtn.MouseEnter:Connect(function()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {BackgroundColor3 = getThemeColor()}):Play()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end)
        resetPosBtn.MouseLeave:Connect(function()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(245, 245, 250)}):Play()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(20, 20, 25)}):Play()
        end)
        local resetDebounce = false
        resetPosBtn.MouseButton1Click:Connect(function()
            if resetDebounce then return end
            resetDebounce = true
            resetFloatingPositions()
            resetPosBtn.Text = "RESET"
            task.delay(1.2, function()
                if resetPosBtn and resetPosBtn.Parent then
                    resetPosBtn.Text = "RESET POSITIONS"
                    resetDebounce = false
                end
            end)
        end)
    end
    do
        local row = mkRow(configPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local delBtn = Instance.new("TextButton", row)
        delBtn.Size = UDim2.new(1, -12, 0.8, 0)
        delBtn.Position = UDim2.new(0, 6, 0.1, 0)
        delBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
        delBtn.BorderSizePixel = 0
        delBtn.Text = "RESET ALL SETTINGS"
        delBtn.TextColor3 = Color3.fromRGB(170, 30, 50)
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 13
        delBtn.AutoButtonColor = false
        delBtn.ZIndex = 8
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 10)
        local delStroke = Instance.new("UIStroke", delBtn)
        delStroke.Color = Color3.fromRGB(200, 60, 80)
        delStroke.Thickness = 1.5
        delStroke.Transparency = 0.4
        delBtn.MouseEnter:Connect(function()
            TS:Create(delBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 50, 70)}):Play()
            TS:Create(delBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end)
        delBtn.MouseLeave:Connect(function()
            TS:Create(delBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(245, 245, 250)}):Play()
            TS:Create(delBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(170, 30, 50)}):Play()
        end)
        local deleteState = 0
        local originalDeleteText = "RESET ALL SETTINGS"
        local delDebounce = false
        delBtn.MouseButton1Click:Connect(function()
            if delDebounce then return end
            if deleteState == 0 then
                deleteState = 1
                delBtn.Text = "CONFIRM?"
                delBtn.BackgroundColor3 = Color3.fromRGB(255, 220, 220)
                delBtn.TextColor3 = Color3.fromRGB(160, 0, 0)
                task.delay(2, function()
                    if delBtn and delBtn.Parent and deleteState == 1 then
                        deleteState = 0
                        delBtn.Text = originalDeleteText
                        delBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
                        delBtn.TextColor3 = Color3.fromRGB(170, 30, 50)
                    end
                end)
            elseif deleteState == 1 then
                delDebounce = true
                local invoked, success = pcall(resetToFactoryDefaults)
                success = invoked and success
                delBtn.Text = success and "SETTINGS RESET" or "ERROR"
                delBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
                delBtn.TextColor3 = Color3.fromRGB(170, 30, 50)
                deleteState = 0
                task.delay(1.5, function()
                    if delBtn and delBtn.Parent then
                        delBtn.Text = originalDeleteText
                        delBtn.BackgroundColor3 = Color3.fromRGB(245, 245, 250)
                        delBtn.TextColor3 = Color3.fromRGB(170, 30, 50)
                        delDebounce = false
                    end
                end)
            end
        end)
    end

    local keyPage = contentPages["Keybinds"]
    mkSect(keyPage, "Keybinds")
    mkSect(keyPage, "Movement")
    addKeybindRow(keyPage, "Carry Mode", KB.CarryToggle)
    addKeybindRow(keyPage, "Lagger Mode", KB.LaggerMode)
    addKeybindRow(keyPage, "Auto Left", KB.AutoLeft)
    addKeybindRow(keyPage, "Auto Right", KB.AutoRight)

    mkSect(keyPage, "Combat")
    addKeybindRow(keyPage, "Bypass Bat", KB.AutoBat)
    addKeybindRow(keyPage, "Bat V2", KB.BatV2)

    mkSect(keyPage, "Utility")
    addKeybindRow(keyPage, "Drop Brainrot", KB.DropBrainrot)
    addKeybindRow(keyPage, "TP Down", KB.TPFloor)
    addKeybindRow(keyPage, "Hide GUI", KB.GuiHide)

    local spacer = Instance.new("Frame", keyPage)
    spacer.Size = UDim2.new(1, 0, 0, 16)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder = getNextOrder(keyPage)
    spacer.ZIndex = 7

    do
        local masterPage = contentPages["Speed"]
        local orderedPages = {contentPages["Combat"], contentPages["Visual"], contentPages["Config"], contentPages["Keybinds"]}
        local nextOrder = 0
        for _, child in ipairs(masterPage:GetChildren()) do
            if child:IsA("GuiObject") then
                nextOrder = math.max(nextOrder, child.LayoutOrder or 0)
            end
        end
        for _, page in ipairs(orderedPages) do
            for _, child in ipairs(page:GetChildren()) do
                if child:IsA("GuiObject") then
                    nextOrder = nextOrder + 1
                    child.LayoutOrder = nextOrder
                    child.Parent = masterPage
                end
            end
            page:Destroy()
        end
        masterPage.Name = "AllOptions"
        masterPage.Visible = true
        contentPages["Combat"] = masterPage
        contentPages["Visual"] = masterPage
        contentPages["Config"] = masterPage
        contentPages["Keybinds"] = masterPage
    end

    pbFrame = Instance.new("Frame", gui)
    pbFrame.Name = "RivalHubAutoStealHud"
    local BAR_W, BAR_H = 280, 50
    pbFrame.Size = UDim2.new(0, BAR_W, 0, BAR_H)
    pbFrame.Position = UDim2.new(1, -BAR_W - 18, 0, 18)
    pbFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    pbFrame.BackgroundTransparency = 0
    pbFrame.BorderSizePixel = 0
    pbFrame.Active = true
    pbFrame.Visible = true
    pbFrame.ZIndex = 500
    Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 10)

    local pbStroke = Instance.new("UIStroke", pbFrame)
    pbStroke.Name = "OuterStroke"
    pbStroke.Color = Color3.fromRGB(180, 190, 205)
    pbStroke.Thickness = 1.2
    pbStroke.Transparency = 0.35

    local hudTitle = Instance.new("TextLabel", pbFrame)
    hudTitle.Name = "AutoStealTitle"
    hudTitle.Size = UDim2.new(0, 90, 0, 14)
    hudTitle.Position = UDim2.new(0, 10, 0, 4)
    hudTitle.BackgroundTransparency = 1
    hudTitle.Text = "AUTO STEAL"
    hudTitle.TextColor3 = Color3.fromRGB(90, 160, 255)
    hudTitle.Font = Enum.Font.GothamBlack
    hudTitle.TextSize = 11
    hudTitle.TextXAlignment = Enum.TextXAlignment.Left
    hudTitle.ZIndex = 502

    progressStatus = Instance.new("TextLabel", pbFrame)
    progressStatus.Name = "StealProgressStatus"
    progressStatus.Size = UDim2.new(0, 90, 0, 14)
    progressStatus.Position = UDim2.new(0, 100, 0, 4)
    progressStatus.BackgroundTransparency = 1
    progressStatus.Text = "READY"
    progressStatus.TextColor3 = Color3.fromRGB(190, 200, 215)
    progressStatus.Font = Enum.Font.GothamBold
    progressStatus.TextSize = 10
    progressStatus.TextXAlignment = Enum.TextXAlignment.Left
    progressStatus.ZIndex = 502

    infoLabel = Instance.new("TextLabel", pbFrame)
    infoLabel.Name = "PerformanceStats"
    infoLabel.Size = UDim2.new(1, -200, 0, 14)
    infoLabel.Position = UDim2.new(1, -85, 0, 4)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "FPS --  MS --"
    infoLabel.TextColor3 = Color3.fromRGB(150, 158, 172)
    infoLabel.Font = Enum.Font.GothamMedium
    infoLabel.TextSize = 9
    infoLabel.TextXAlignment = Enum.TextXAlignment.Right
    infoLabel.ZIndex = 502

    local stealTrack = Instance.new("Frame", pbFrame)
    stealTrack.Name = "StealProgressTrack"
    stealTrack.Size = UDim2.new(1, -20, 0, 14)
    stealTrack.Position = UDim2.new(0, 10, 1, -18)
    stealTrack.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    stealTrack.BackgroundTransparency = 0
    stealTrack.BorderSizePixel = 0
    stealTrack.ZIndex = 501
    Instance.new("UICorner", stealTrack).CornerRadius = UDim.new(0, 7)

    local trackStroke = Instance.new("UIStroke", stealTrack)
    trackStroke.Color = Color3.fromRGB(120, 130, 145)
    trackStroke.Thickness = 1
    trackStroke.Transparency = 0.3

    progressFill = Instance.new("Frame", stealTrack)
    progressFill.Name = "StealProgressFill"
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(0, 110, 255)
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 502
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 7)

    local fillGrad = Instance.new("UIGradient", progressFill)
    fillGrad.Rotation = 0
    fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 110, 255)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(80, 160, 255)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(220, 230, 240)),
    })

    local fillStroke = Instance.new("UIStroke", progressFill)
    fillStroke.Name = "FillStroke"
    fillStroke.Color = Color3.fromRGB(210, 218, 230)
    fillStroke.Thickness = 1
    fillStroke.Transparency = 0.2

    progressPct = Instance.new("TextLabel", stealTrack)
    progressPct.Name = "StealProgressPercent"
    progressPct.Size = UDim2.new(0, 46, 1, 0)
    progressPct.Position = UDim2.new(1, -50, 0, 0)
    progressPct.BackgroundTransparency = 1
    progressPct.Text = "0%"
    progressPct.TextColor3 = Color3.fromRGB(245, 248, 252)
    progressPct.Font = Enum.Font.GothamBold
    progressPct.TextSize = 9
    progressPct.TextXAlignment = Enum.TextXAlignment.Right
    progressPct.TextStrokeTransparency = 0.4
    progressPct.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    progressPct.ZIndex = 503

    updateStealProgress(0, "READY")

    task.spawn(function()
        local frames, fps, last = 0, 60, _tick()
        local fpsConn = RunService.RenderStepped:Connect(function() frames = frames + 1 end)
        while pbFrame and pbFrame.Parent do
            local now = _tick()
            local elapsed = now - last
            if elapsed > 0 then fps = _floor(frames / elapsed + 0.5) end
            frames, last = 0, now
            local ms = 0
            pcall(function()
                local p = LP:GetNetworkPing()
                if type(p) == "number" and p >= 0 then ms = _floor(p * 1000 + 0.5) end
            end)
            if infoLabel and infoLabel.Parent then infoLabel.Text = string.format("FPS %d  MS %d", fps, ms) end
            task.wait(0.5)
        end
        if fpsConn then fpsConn:Disconnect() end
    end)
    drag(pbFrame)

end

do
    local BAV2_ANG = "_GB_AngV"
    local BAV2_ATT = "_GB_Att"
    local BAV2_CLEAN = {
        "LockBAV","LockAngVel","LockBodyAtt","BatLock","LockBAVAtt",
        "AutoBatAtt","AutoBatAV","AntiBatDet","AntiAim","VelocityLock"
    }

    local V2 = {
        enabled = false,
        conn = nil,
        safetyConn = nil,
        target = nil,
        equipped = false,
        intendedVelocity = Vector3.zero,
        attachment = nil,
        angularVelocity = nil,
        speed = 58,
        swingRange = 12,
    }
    _G.__RivalHubBatV2 = V2

    local function cleanMovers(root)
        if not root then return end
        pcall(function()
            for _, n in ipairs(BAV2_CLEAN) do
                local c = root:FindFirstChild(n)
                if c then c:Destroy() end
            end
            for _, child in ipairs(root:GetChildren()) do
                if child.Name ~= BAV2_ANG and child.Name ~= BAV2_ATT then
                    local ln = child.Name:lower()
                    if ln:find("lockb") or ln:find("lockangv")
                       or ln:find("batlock") or ln:find("antiaim")
                       or ln:find("velocitylock") then
                        child:Destroy()
                    end
                end
            end
        end)
    end

    local function ensureAngular(root)
        if not root then return end
        pcall(function()
            local a = root:FindFirstChild(BAV2_ANG); if a then a:Destroy() end
            local b = root:FindFirstChild(BAV2_ATT); if b then b:Destroy() end
        end)
        local att = Instance.new("Attachment")
        att.Name = BAV2_ATT
        att.Parent = root
        local angV = Instance.new("AngularVelocity")
        angV.Name = BAV2_ANG
        angV.Attachment0 = att
        angV.RelativeTo = Enum.ActuatorRelativeTo.World
        angV.MaxTorque = math.huge
        angV.AngularVelocity = Vector3.zero
        angV.Parent = root
        V2.attachment = att
        V2.angularVelocity = angV
    end

    local function removeAngular()
        pcall(function() if V2.angularVelocity and V2.angularVelocity.Parent then V2.angularVelocity:Destroy() end end)
        pcall(function() if V2.attachment and V2.attachment.Parent then V2.attachment:Destroy() end end)
        V2.angularVelocity = nil
        V2.attachment = nil
    end

    local function pickTarget(root)
        local best, bestD = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                if hrp and hum and hum.Health > 0 then
                    local d = (hrp.Position - root.Position).Magnitude
                    if d < bestD then bestD = d; best = hrp end
                end
            end
        end
        return best, bestD
    end

    local function getBat(char)
        local eq = char and char:FindFirstChildOfClass("Tool")
        if eq then
            local n = eq.Name:lower()
            if n:find("bat") or n:find("slap") then return eq end
        end
        local bp = LP:FindFirstChildOfClass("Backpack")
        if bp then
            for _, t in ipairs(bp:GetChildren()) do
                if t:IsA("Tool") then
                    local n = t.Name:lower()
                    if n:find("bat") or n:find("slap") then return t end
                end
            end
        end
        return nil
    end

    local function stopBatV2()
        V2.enabled = false
        V2.equipped = false
        V2.target = nil
        if V2.conn then V2.conn:Disconnect(); V2.conn = nil end
        if V2.safetyConn then V2.safetyConn:Disconnect(); V2.safetyConn = nil end
        local c = LP.Character
        local root = c and c:FindFirstChild("HumanoidRootPart")
        if root then pcall(function() root.Velocity = root.Velocity * 0.3 end) end
        local hum = c and c:FindFirstChildOfClass("Humanoid")
        if hum then hum.AutoRotate = true end
        if V2.angularVelocity then
            pcall(function() V2.angularVelocity.AngularVelocity = Vector3.zero end)
        end
        removeAngular()
        if _unsuppressBodyLock then pcall(_unsuppressBodyLock, true) end
    end

    local function startBatV2()
        stopBatV2()
        V2.enabled = true
        V2.equipped = false
        V2.target = nil
        V2.intendedVelocity = Vector3.zero
        V2.speed = tonumber(State and State.bypassBatSpeed) or 58
        if _suppressBodyLock then pcall(_suppressBodyLock) end

        local c = LP.Character
        local root = c and c:FindFirstChild("HumanoidRootPart")
        if root then
            cleanMovers(root)
            ensureAngular(root)
        end

        V2.conn = RunService.Heartbeat:Connect(function()
            if not V2.enabled then return end
            local char = LP.Character
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp or not hum or hum.Health <= 0 then return end

            cleanMovers(hrp)
            if not V2.angularVelocity or not V2.angularVelocity.Parent then
                ensureAngular(hrp)
            end

            if not V2.equipped then
                V2.equipped = true
                if not char:FindFirstChildOfClass("Tool") then
                    local b = getBat(char)
                    if b then pcall(function() hum:EquipTool(b) end) end
                end
            end

            local target, dist = pickTarget(hrp)
            if not target then
                V2.target = nil
                hum.AutoRotate = true
                if V2.angularVelocity then
                    V2.angularVelocity.AngularVelocity = Vector3.zero
                end
                return
            end
            V2.target = target

            local aimPos = target.Position
                + target.CFrame.LookVector * (target.Velocity.Magnitude < 0.1 and 1.5 or 5)
            local delta = aimPos - hrp.Position
            local flat  = Vector3.new(delta.X, 0, delta.Z)
            hum.AutoRotate = false

            if delta.Magnitude > 0.01 and flat.Magnitude > 0.01 then
                local curY   = hrp.Orientation.Y
                local yawD   = (math.deg(math.atan2(-flat.X, -flat.Z)) - curY + 180) % 360 - 180
                local curX   = hrp.Orientation.X
                local pitchD = (math.deg(math.atan2(delta.Y, flat.Magnitude)) - curX + 180) % 360 - 180
                local rotY   = math.clamp(math.rad(yawD)   * 40, -28, 28)
                local rotX   = math.clamp(math.rad(pitchD) * 40, -28, 28)
                local yawR   = math.rad(hrp.Orientation.Y)
                local fwd    = Vector3.new(math.cos(yawR), 0, -math.sin(yawR))
                V2.angularVelocity.AngularVelocity = Vector3.new(0, rotY, 0) + fwd * rotX
            else
                V2.angularVelocity.AngularVelocity = Vector3.zero
            end

            local spd = tonumber(V2.speed) or 58
            V2.intendedVelocity =
                (flat.Magnitude > 0.1 and flat.Unit * spd or Vector3.zero)
                + (math.abs(delta.Y) > 0.8
                    and Vector3.new(0, math.sign(delta.Y) * spd, 0)
                    or  Vector3.new(0, -2, 0))
            hrp.AssemblyLinearVelocity = V2.intendedVelocity
            hrp.Velocity = V2.intendedVelocity

            if flat.Magnitude > 0.3 then
                pcall(function() hum:Move(flat.Unit, false) end)
            else
                pcall(function() hum:Move(Vector3.zero, false) end)
            end

            if dist <= V2.swingRange then
                local bat = char:FindFirstChildOfClass("Tool")
                if bat and (bat.Name:lower():find("bat") or bat.Name:lower():find("slap")) then
                    pcall(function()
                        bat:Activate()
                        local re = bat:FindFirstChildWhichIsA("RemoteEvent")
                        if re then re:FireServer() end
                    end)
                end
            end
        end)

        V2.safetyConn = RunService.RenderStepped:Connect(function()
            if not V2.enabled then return end
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum then return end

            if V2.target and V2.target.Parent then
                local delta = V2.target.Position - hrp.Position
                local flat = Vector3.new(delta.X, 0, delta.Z)
                if flat.Magnitude > 0.3 then
                    pcall(function() hum:Move(flat.Unit, false) end)
                end
                if math.abs(hrp.AssemblyLinearVelocity.X - V2.intendedVelocity.X) > 30
                   or math.abs(hrp.AssemblyLinearVelocity.Z - V2.intendedVelocity.Z) > 30 then
                    hrp.AssemblyLinearVelocity = V2.intendedVelocity
                end
            end

            local v = hrp.Velocity
            if math.abs(v.X) > 350 or math.abs(v.Z) > 350 then
                hrp.Velocity = V2.intendedVelocity
            end
            cleanMovers(hrp)
        end)
    end

    _G.__RivalHubStartBatV2 = startBatV2
    _G.__RivalHubStopBatV2  = stopBatV2
    _G.__RivalHubIsBatV2    = function() return V2.enabled == true end

    LP.CharacterAdded:Connect(function()
        task.wait(0.5)
        if V2.enabled then
            V2.equipped = false
            V2.target = nil
            local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if hrp then
                cleanMovers(hrp)
                ensureAngular(hrp)
            end
        end
    end)
end

function createMobilePanel()
    local panel = Instance.new("ScreenGui")
    panel.Name = "RivalHubMobilePanel"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end

    local BTN_W, BTN_H = 56, 56
    local buttons = {}
    local buttonNames = {"DropBR", "AutoLeft", "AutoBat", "AutoRight", "TpDown", "Carry", "Lagger1", "Lagger2", "BatV2"}
    local buttonTexts = {"DROP\nBR", "AUTO\nLEFT", "BYPASS\nBAT", "AUTO\nRIGHT", "TP\nDOWN", "CARRY\nSPD", "LAGGER\nNORMAL", "LAGGER\nCARRY", "BAT\nV2"}

    local function createButton(name, text, order, isToggle, callback)
        local btn = Instance.new("TextButton", panel)
        btn.Name = name
        btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        btn.BackgroundColor3 = Color3.fromRGB(10,10,10)
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ZIndex = 10

        local savedPos = savedButtonPositions[name]
        if savedPos then
            btn.Position = UDim2.new(0, savedPos.X or 0, 0, savedPos.Y or 0)
        else
            local defX, defY = getDefaultButtonPosition(name)
            btn.Position = UDim2.new(0, defX, 0, defY)
        end

        btn.BackgroundColor3 = Color3.fromRGB(255,255,255)
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)

        local bgGrad = Instance.new("UIGradient", btn)
        bgGrad.Name = "BtnGrad"
        bgGrad.Rotation = 90
        bgGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(252,252,253)),
            ColorSequenceKeypoint.new(0.45, Color3.fromRGB(233,233,236)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(168,168,176)),
        })

        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(120,120,128)
        stroke.Thickness = 1
        stroke.Transparency = 0.55
        stroke.Name = "NormalStroke"

        local label = Instance.new("TextLabel", btn)
        label.Name = "TextLabel"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(32,32,40)
        label.Font = Enum.Font.GothamBlack
        label.TextSize = 11
        label.TextWrapped = true
        label.ZIndex = 11

        local uiScale = Instance.new("UIScale", btn)
        uiScale.Scale = floatingButtonScale
        table.insert(_floatingUIScales, uiScale)

        local active = false
        local function setActive(state)
            active = state
            btn:SetAttribute("MobActive", state and true or false)
            paintFloatingBtn(btn, state)
        end
        setActive(false)

        local dragging = false
        local hasMoved = false
        local dragStart = nil
        local startPos = nil
        local movedDistance = 0

        local function onInputBegan(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; hasMoved = false; movedDistance = 0
                dragStart = input.Position; startPos = btn.Position
                _isDraggingButton = true
            end
        end

        local function onInputChanged(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                movedDistance = delta.Magnitude
                if not uiLocked then
                    hasMoved = true
                    btn.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
                end
            end
        end

        local function onInputEnded(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    if movedDistance < 12 then
                        if isToggle then
                            if callback then callback(setActive) end
                        else
                            if callback then callback(setActive, active) end
                        end
                    elseif not uiLocked and hasMoved then
                        savedButtonPositions[name] = {X = btn.Position.X.Offset, Y = btn.Position.Y.Offset}
                        task.defer(function() pcall(saveAllSettings) end)
                    end
                    dragging = false; hasMoved = false
                    dragStart = nil; startPos = nil; movedDistance = 0
                    _isDraggingButton = false
                end
            end
        end

        btn.InputBegan:Connect(onInputBegan)
        btn.InputChanged:Connect(onInputChanged)
        btn.InputEnded:Connect(onInputEnded)

        UIS.InputEnded:Connect(function(inp)
            if inp.UserInputType ~= Enum.UserInputType.Touch
               and inp.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
            if dragging then onInputEnded(inp) end
        end)

        buttons[name] = {btn = btn, setActive = setActive, label = label}
        return setActive
    end

    for i, name in ipairs(buttonNames) do
        local text = buttonTexts[i]
        local callback
        if name == "DropBR" then
            callback = function(setActive)
                if autoBatEnabled then return end
                setActive(true)
                executeDropWithToggle(function(v)
                    if dropBrainrotSetVisual then dropBrainrotSetVisual(v) end
                end)
                task.delay(0.3, function() setActive(false) end)
            end
        elseif name == "AutoLeft" then
            callback = function(setActive)
                autoLeftEnabled = not autoLeftEnabled
                setActive(autoLeftEnabled)
                if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
                if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
            end
        elseif name == "AutoBat" then
            callback = function(setActive)
                if not autoBatEnabled then enableAutoBat() else disableAutoBat() end
                setActive(autoBatEnabled)
            end
        elseif name == "AutoRight" then
            callback = function(setActive)
                autoRightEnabled = not autoRightEnabled
                setActive(autoRightEnabled)
                if autoRightEnabled then startAutoRight() else stopAutoRight() end
                if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
            end
        elseif name == "TpDown" then
            callback = function(setActive)
                doTpDown()
                setActive(true)
                task.delay(0.2, function() setActive(false) end)
            end
        elseif name == "Carry" then
            callback = function(setActive)
                if not speedMode then
                    speedMode = true; laggerToggled = false; laggerCarryToggled = false; setActive(true)
                    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                else
                    speedMode = false; setActive(false)
                end
                refreshSpeedModeLabel()
                if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end
            end
        elseif name == "Lagger1" then
            callback = function(setActive)
                if speedMode then speedMode = false; if mobSetCarry then mobSetCarry(false) end end
                if not laggerToggled then
                    laggerToggled = true; laggerCarryToggled = false; setActive(true)
                    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                else
                    laggerToggled = false; setActive(false)
                end
                refreshSpeedModeLabel()
                if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end
            end
        elseif name == "Lagger2" then
            callback = function(setActive)
                if speedMode then speedMode = false; if mobSetCarry then mobSetCarry(false) end end
                if not laggerCarryToggled then
                    laggerCarryToggled = true; laggerToggled = false; setActive(true)
                    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                else
                    laggerToggled = false; setActive(false)
                end
                refreshSpeedModeLabel()
                if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end
            end
        elseif name == "BatV2" then
            callback = function(setActive)
                if not _G.__RivalHubIsBatV2() then
                    _G.__RivalHubStartBatV2()
                    setActive(true)
                else
                    _G.__RivalHubStopBatV2()
                    setActive(false)
                end
            end
        end
        local setActive = createButton(name, text, i-1, true, callback)
        if name == "AutoBat" then mobSetAutoBat = setActive end
        if name == "AutoLeft" then mobSetAutoLeft = setActive end
        if name == "AutoRight" then mobSetAutoRight = setActive end
        if name == "DropBR" then mobSetDropBR = setActive end
        if name == "TpDown" then mobSetTpDown = setActive end
        if name == "Carry" then mobSetCarry = setActive end
        if name == "Lagger1" then mobSetLagger1 = setActive end
        if name == "Lagger2" then mobSetLagger2 = setActive end
        if name == "BatV2" then mobSetBatV2 = setActive end
    end

    if buttons.AutoBat and buttons.AutoBat.setActive then buttons.AutoBat.setActive(autoBatEnabled) end
    if buttons.AutoLeft and buttons.AutoLeft.setActive then buttons.AutoLeft.setActive(autoLeftEnabled) end
    if buttons.AutoRight and buttons.AutoRight.setActive then buttons.AutoRight.setActive(autoRightEnabled) end
    if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(speedMode) end
    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(laggerToggled) end
    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(laggerCarryToggled) end
    if buttons.BatV2 and buttons.BatV2.setActive then
        buttons.BatV2.setActive(_G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2() or false)
    end

    return panel
end

batCounterV2Enabled = false
batCounterV2Debounce = false
batCounterV2Conn = nil
batCounterV2HitCooldown = false
BAT_COUNTER_V2_SWING_CD = 0.08
setBatCounterV2Visual = nil

local _batCounterV2OriginalTpState = false
local _batCounterV2SuppressCount = 0
local _lastBatCounterV2Time = 0
local _batCounterV2Cooldown = 0.01

local function isPlayerRagdolled(player)
    if not player or not player.Character then return false end
    local hum = player.Character:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    local state = hum:GetState()
    return state == Enum.HumanoidStateType.Physics or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
end

local function hasAnimalEquipped(player)
    if not player or not player.Character then return false end
    for _, child in ipairs(player.Character:GetChildren()) do
        if child:IsA("Tool") then
            if child:FindFirstChild("Handle") or child.Name:find("Animal") or child.Name:find("Pet") then return true end
        end
    end
    return false
end

local function getAttackingPlayerWithAnimal()
    local myChar = LP.Character
    if not myChar then return nil end
    local myRoot = myChar:FindFirstChild("HumanoidRootPart")
    if not myRoot then return nil end
    local closest, minDist = nil, _huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            if not hasAnimalEquipped(plr) then continue end
            local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if tRoot and hum and hum.Health > 0 then
                local dist = (tRoot.Position - myRoot.Position).Magnitude
                if dist < 12 and dist < minDist then
                    minDist = dist; closest = plr
                end
            end
        end
    end
    return closest
end

local function getBatV2Counter()
    local char = LP.Character
    if not char then return nil end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            local name = child.Name:lower()
            if name:find("bat") or name:find("slap") or name:find("sword") or name:find("knife") then return child end
        end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, child in ipairs(bp:GetChildren()) do
            if child:IsA("Tool") then
                local name = child.Name:lower()
                if name:find("bat") or name:find("slap") or name:find("sword") or name:find("knife") then
                    child.Parent = char
                    return child
                end
            end
        end
    end
    if bp then
        for _, child in ipairs(bp:GetChildren()) do
            if child:IsA("Tool") then child.Parent = char; return child end
        end
    end
    return nil
end

local function tryHitBatCounterV2()
    if batCounterV2HitCooldown then return end
    batCounterV2HitCooldown = true
    pcall(function()
        local bat = getBatV2Counter()
        if bat then
            bat:Activate()
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then ev:FireServer() end
        end
    end)
    task.delay(BAT_COUNTER_V2_SWING_CD, function() batCounterV2HitCooldown = false end)
end

local function executeBatCounterV2()
    local now = _tick()
    if now - (_lastBatCounterV2Time or 0) < (_batCounterV2Cooldown or 0.01) then return end
    if batCounterV2Debounce then return end
    batCounterV2Debounce = true
    _lastBatCounterV2Time = now
    local attacker = getAttackingPlayerWithAnimal()
    if not attacker then batCounterV2Debounce = false; return end
    if isPlayerRagdolled(attacker) then batCounterV2Debounce = false; return end
    if not hasAnimalEquipped(attacker) then batCounterV2Debounce = false; return end
    local function doCounterHit()
        local char = LP.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        local attChar = attacker.Character
        if not attChar then return end
        local attRoot = attChar:FindFirstChild("HumanoidRootPart")
        if not attRoot then return end
        if not hasAnimalEquipped(attacker) then batCounterV2Debounce = false; return end
        if sethiddenproperty then sethiddenproperty(hrp, "PhysicsRepRootPart", attRoot) end
        local targetPos = attRoot.Position + _V3new(0, 0.9, 0)
        if (hrp.Position - targetPos).Magnitude > 8 then hrp.CFrame = _CFnew(targetPos) end
        tryHitBatCounterV2()
        task.delay(0.05, function() tryHitBatCounterV2() end)
        task.delay(0.1, function() tryHitBatCounterV2() end)
    end
    doCounterHit()
    task.delay(0.2, function()
        batCounterV2Debounce = false
    end)
end

function stopBatCounterV2()
    if batCounterV2Conn then
        batCounterV2Conn:Disconnect()
        batCounterV2Conn = nil
    end
    batCounterV2Debounce = false
    batCounterV2HitCooldown = false
end

function startBatCounterV2()
    if batCounterV2Conn then return end
    batCounterV2Conn = RunService.Heartbeat:Connect(function()
        if not batCounterV2Enabled then return end
        if batCounterV2Debounce then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then return end
        local state = humanoid:GetState()
        local isBeingAttacked = state == Enum.HumanoidStateType.Physics or
                               state == Enum.HumanoidStateType.Ragdoll or
                               state == Enum.HumanoidStateType.FallingDown or
                               state == Enum.HumanoidStateType.GettingUp or
                               state == Enum.HumanoidStateType.Stunned
        if isBeingAttacked then
            local attacker = getAttackingPlayerWithAnimal()
            if attacker then
                if not isPlayerRagdolled(attacker) then
                    if hasAnimalEquipped(attacker) then
                        executeBatCounterV2()
                    end
                end
            end
        end
    end)
end

function toggleBatCounterV2()
    batCounterV2Enabled = not batCounterV2Enabled
    if batCounterV2Enabled then startBatCounterV2() else stopBatCounterV2() end
    return batCounterV2Enabled
end

function updateUIFromLoaded()
    task.wait()
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_CARRY_SPEED) end
    if batSpeedBox then batSpeedBox.Text = tostring(BYPASS_AIMBOT_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    if infJumpModeBtn then infJumpModeBtn.Text = string.upper(InfiniteJump.mode == "manual" and "manual" or "hold") end
    if autoStealModeBtn then autoStealModeBtn.Text = autoStealMode == "V2" and "V2" or "V1" end
    refreshSpeedModeLabel()

    local savedInfJumpEnabled = InfiniteJump.enabled == true
    InfiniteJump.stop()
    if savedInfJumpEnabled then
        InfiniteJump.start()
        if infJumpSetVisual then infJumpSetVisual(true) end
    elseif infJumpSetVisual then
        infJumpSetVisual(false)
    end

    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end

    if savedProgressBarPos and pbFrame then
        pbFrame.Position = UDim2.new(savedProgressBarPos.XScale or 0.5, savedProgressBarPos.XOffset or -160, savedProgressBarPos.YScale or 0.80, savedProgressBarPos.YOffset or 0)
    end

    applyBackgroundMode(backgroundMode)
    applyFloatingButtonScale()

    if uiLocked and setLockUIVisual then setLockUIVisual(true) end

    if antiRagdollMode == "v1" or antiRagdollMode == "v2" then
        if _G.updateAntiRagdollUI then _G.updateAntiRagdollUI(antiRagdollMode) end
        setAntiRagdollMode(antiRagdollMode)
    else
        if _G.updateAntiRagdollUI then _G.updateAntiRagdollUI("off") end
    end

    if antiDieEnabled then
        if setAntiDieVisual then setAntiDieVisual(true) end
        AntiDieModule.start()
    else
        if setAntiDieVisual then setAntiDieVisual(false) end
    end

    if antiBatEnabled then
        if setAntiBatVisual then setAntiBatVisual(true) end
        startAntiBat()
    else
        if setAntiBatVisual then setAntiBatVisual(false) end
    end

    if antiFlingEnabled then
        if setAntiFlingVisual then setAntiFlingVisual(true) end
        startAntiFling()
    else
        if setAntiFlingVisual then setAntiFlingVisual(false) end
        stopAntiFling()
    end

    if CONFIG.AUTO_STEAL_ENABLED and setInstaGrab then setInstaGrab(true); pcall(startAutoSteal) end

    if medusaCounterEnabled then
        if setMedusaVisual then setMedusaVisual(true) end
        if LP.Character then setupMedusaCounter(LP.Character) end
    else
        if setMedusaVisual then setMedusaVisual(false) end
        stopMedusaCounter()
    end

    if batCounterEnabled and setBatCounterVisual then
        setBatCounterVisual(true)
        startBatCounter()
    end
    if batCounterV2Enabled and setBatCounterV2Visual then
        setBatCounterV2Visual(true)
        startBatCounterV2()
    end
    if unwalkEnabled and setUnwalkVisual then
        setUnwalkVisual(true)
        task.spawn(function() task.wait(0.5); startUnwalk() end)
    end
    if antiLagEnabled then
        if setAntiLagVisual then setAntiLagVisual(true) end
        enableAntiLag()
    else
        if setAntiLagVisual then setAntiLagVisual(false) end
        disableAntiLag()
    end
    if espEnabled then
        toggleESP(true)
        if setESPVIsual then setESPVIsual(true) end
    else
        toggleESP(false)
        if setESPVIsual then setESPVIsual(false) end
    end
    if espLineEnabled then
        if setESPLineVisual then setESPLineVisual(true) end
        startESPLine()
    else
        if setESPLineVisual then setESPLineVisual(false) end
        stopESPLine()
    end

    if vividGraphicsEnabled then
        enableVividGraphics()
        if setVividVisual then setVividVisual(true) end
    else
        disableVividGraphics()
        if setVividVisual then setVividVisual(false) end
    end

    if stretchEnabled then
        enableStretch()
        if _G.stretchToggleSetter then _G.stretchToggleSetter(true) end
    else
        if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
    end

    if mobSetAutoBat then mobSetAutoBat(autoBatEnabled) end
    if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
    if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled) end
    if mobSetLagger2 then mobSetLagger2(laggerCarryToggled) end
    if mobSetBatV2 then mobSetBatV2(_G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2() or false) end

    if bodyLockEnabled and bodyLockSetVisual then
        if _blSuppressCount == 0 then
            bodyLockSetVisual(true)
            startBodyLock()
        else
            bodyLockSetVisual(false)
        end
    end

    updateProgressBarVisibility()
    startEnemySpeed()

    toggleLockUI(uiLocked)

    pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
    if outfitSelectorLabel and OUTFITS[currentOutfitIndex] then
        outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
    end
end

local _bootErrors = {}

local function _bootSection(name, fn)
    print("[Rival Hub Boot] Iniciando:", name)
    local ok, err = pcall(fn)
    if not ok then
        print("[Rival Hub Boot] FALLÓ:", name, tostring(err))
        table.insert(_bootErrors, {name = name, err = tostring(err)})
        warn("[Rival Hub Boot] Error en '" .. name .. "': " .. tostring(err))
    else
        print("[Rival Hub Boot] OK:", name)
    end
    return ok
end

_bootSection("buildGui", function()
    buildGui()
end)

if gui and main then
    _bootSection("loadAllSettings", function()
        if loadAllSettings() then
            updateUIFromLoaded()
        end
    end)

    _bootSection("createMobilePanel", function()
        MobilePanel = createMobilePanel()
    end)

    if hideButtonsEnabled then
        _bootSection("applyHideButtons", function()
            applyHideButtons(true)
            if setHideButtonsVisual then setHideButtonsVisual(true) end
        end)
    end

    _bootSection("localizeRivalHubInterface", function()
        if gui then localizeRivalHubInterface(gui) end
        if MobilePanel then localizeRivalHubInterface(MobilePanel) end
    end)

    if LP.Character then
        task.spawn(function()
            task.wait(0.1)
            if waitForCharReady(LP.Character, 5) then
                pcall(function() captureOriginalAppearance(LP.Character) end)
                pcall(function() setupMovementAndIndicators(LP.Character) end)
                if currentAnimPack ~= "Off" then
                    pcall(function() startAnimPack(currentAnimPack) end)
                end
                pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
            end
        end)
    end

    if #_bootErrors > 0 then
        task.defer(function()
            pcall(function()
                local env = (getgenv and getgenv()) or _G
                local writeFn = env.writefile or (syn and syn.writefile)
                if type(writeFn) == "function" then
                    local log = "[Rival Hub Boot Errors] " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n"
                    for _, e in ipairs(_bootErrors) do
                        log = log .. e.name .. ": " .. e.err .. "\n"
                    end
                    pcall(writeFn, "RivalHub_boot_errors.txt", log)
                    warn("[Rival Hub] Errores escritos a RivalHub_boot_errors.txt")
                end
            end)
        end)

        task.defer(function()
            pcall(function()
                local errGui = Instance.new("ScreenGui")
                errGui.Name = "RivalHubBootErrors"
                errGui.ResetOnSpawn = false
                errGui.DisplayOrder = 999
                local okCg, cg = pcall(function() return game:GetService("CoreGui") end)
                if okCg and cg then
                    pcall(function() errGui.Parent = cg end)
                end
                if not errGui.Parent then errGui.Parent = LP:WaitForChild("PlayerGui") end

                local frame = Instance.new("Frame", errGui)
                frame.Size = UDim2.new(0, 460, 0, 60 + #_bootErrors * 22)
                frame.Position = UDim2.new(0, 10, 1, -80 - #_bootErrors * 22)
                frame.BackgroundColor3 = Color3.fromRGB(40, 10, 15)
                frame.BorderSizePixel = 0
                Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 10)
                local stroke = Instance.new("UIStroke", frame)
                stroke.Color = Color3.fromRGB(255, 80, 90)
                stroke.Thickness = 1.5

                local title = Instance.new("TextLabel", frame)
                title.Size = UDim2.new(1, -20, 0, 24)
                title.Position = UDim2.new(0, 10, 0, 8)
                title.BackgroundTransparency = 1
                title.Text = "⚠ Rival Hub: " .. #_bootErrors .. " sección(es) fallaron"
                title.TextColor3 = Color3.fromRGB(255, 100, 110)
                title.Font = Enum.Font.GothamBold
                title.TextSize = 13
                title.TextXAlignment = Enum.TextXAlignment.Left

                for i, e in ipairs(_bootErrors) do
                    local lbl = Instance.new("TextLabel", frame)
                    lbl.Size = UDim2.new(1, -20, 0, 18)
                    lbl.Position = UDim2.new(0, 10, 0, 34 + (i - 1) * 20)
                    lbl.BackgroundTransparency = 1
                    lbl.Text = "• " .. e.name .. ": " .. e.err:sub(1, 110)
                    lbl.TextColor3 = Color3.fromRGB(255, 180, 180)
                    lbl.Font = Enum.Font.Code
                    lbl.TextSize = 10
                    lbl.TextXAlignment = Enum.TextXAlignment.Left
                    lbl.TextTruncate = Enum.TextTruncate.AtEnd
                end

                local copyBtn = Instance.new("TextButton", frame)
                copyBtn.Size = UDim2.new(0, 100, 0, 22)
                copyBtn.Position = UDim2.new(0, 10, 1, -30)
                copyBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 30)
                copyBtn.Text = "COPIAR LOG"
                copyBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
                copyBtn.Font = Enum.Font.GothamBold
                copyBtn.TextSize = 11
                copyBtn.BorderSizePixel = 0
                Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 6)
                copyBtn.MouseButton1Click:Connect(function()
                    local buf = ""
                    for _, e in ipairs(_bootErrors) do
                        buf = buf .. e.name .. ": " .. e.err .. "\n"
                    end
                    pcall(function()
                        if setclipboard then setclipboard(buf) end
                    end)
                    copyBtn.Text = "¡COPIADO!"
                    task.delay(1.2, function() copyBtn.Text = "COPIAR LOG" end)
                end)

                local closeBtn = Instance.new("TextButton", frame)
                closeBtn.Size = UDim2.new(0, 60, 0, 22)
                closeBtn.Position = UDim2.new(1, -70, 1, -30)
                closeBtn.BackgroundColor3 = Color3.fromRGB(80, 20, 30)
                closeBtn.Text = "CERRAR"
                closeBtn.TextColor3 = Color3.fromRGB(255, 200, 200)
                closeBtn.Font = Enum.Font.GothamBold
                closeBtn.TextSize = 11
                closeBtn.BorderSizePixel = 0
                Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 6)
                closeBtn.MouseButton1Click:Connect(function()
                    pcall(function() errGui:Destroy() end)
                end)

                task.delay(60, function()
                    pcall(function() errGui:Destroy() end)
                end)
            end)
        end)
    end
else
    warn("[Rival Hub Boot] Fatal: buildGui falló. El script no puede continuar.")
end

if LP and LP.CharacterAdded then
    pcall(function()
        local _respawnQueue = 0
        LP.CharacterAdded:Connect(function(char)
            pcall(function()
                _respawnQueue = _respawnQueue + 1
                local myId = _respawnQueue

                if stealConnection then stealConnection:Disconnect(); stealConnection = nil end
                isStealing = false
                if stopAutoLeft then stopAutoLeft() end
                if stopAutoRight then stopAutoRight() end
                if stopBatCounter then stopBatCounter() end
                if stopBatCounterV2 then stopBatCounterV2() end
                if stopMedusaCounter then stopMedusaCounter() end
                if stopUnwalk then stopUnwalk() end
                if stopDropBrainrot then stopDropBrainrot() end
                if autoBatEnabled and disableAutoBat then disableAutoBat() end
                if bodyLockEnabled and stopBodyLock then stopBodyLock() end

                local deadline = _tick() + 5
                while (not char.Parent) or (not char:FindFirstChild("HumanoidRootPart")) or (not char:FindFirstChildOfClass("Humanoid")) do
                    if _tick() > deadline then return end
                    if myId ~= _respawnQueue then return end
                    task.wait(0.05)
                end

                _hookedVelParts = {}
                local _hrpRespawn = _setupVelChecked(char)
                _hookVelHRP(_hrpRespawn)

                if not _originalAppearance then task.defer(function() captureOriginalAppearance(char) end) end
                if setupMovementAndIndicators then setupMovementAndIndicators(char) end
                if antiRagdollMode == "v1" then
                    AntiRagdollV1.start()
                elseif antiRagdollMode == "v2" then
                    startAntiRagdollV2()
                end
                if antiBatEnabled then startAntiBat() end
                if antiFlingEnabled then startAntiFling() end
                if AntiDieModule.enabled then task.defer(function() activateOnCharacter(char) end) end
                if CONFIG.AUTO_STEAL_ENABLED then pcall(startAutoSteal) end
                if bodyLockEnabled and _blSuppressCount == 0 then startBodyLock() end

                if medusaCounterEnabled then
                    setupMedusaCounter(char)
                    if setMedusaVisual then setMedusaVisual(true) end
                else
                    stopMedusaCounter()
                    if setMedusaVisual then setMedusaVisual(false) end
                end

                if batCounterEnabled then startBatCounter() end
                if batCounterV2Enabled then startBatCounterV2() end
                if unwalkEnabled then startUnwalk() end
                if currentAnimPack ~= "Off" then task.wait(0.3); startAnimPack(currentAnimPack) end

                updateProgressBarVisibility()
                refreshSpeedModeLabel()

                pcall(function() applyOutfitByIndex(currentOutfitIndex) end)
                if outfitSelectorLabel and OUTFITS[currentOutfitIndex] then
                    outfitSelectorLabel.Text = OUTFITS[currentOutfitIndex].label
                end
            end)
        end)
    end)
end

local lastLaggerToggle = 0
local LAGGER_COOLDOWN = 0.3

UIS.InputBegan:Connect(function(input, gpe)
    if _anyKeyListening then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if gpe or UIS:GetFocusedTextBox() then return end
    elseif not isGamepadInput(input) then
        return
    end
    if not isBindableInput(input) then return end

    local kc = input.KeyCode
    if not kc then return end

    if kbMatch(KB.LaggerMode, kc) then
        if _tick() - lastLaggerToggle >= LAGGER_COOLDOWN then
            lastLaggerToggle = _tick()
            toggleLaggerCycle()
        end
        return
    end
    if kbMatch(KB.CarryToggle, kc) then toggleCarryMode(); return end
    if kbMatch(KB.DropBrainrot, kc) then
        if not dropActive then
            if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
            executeDropWithToggle(dropBrainrotSetVisual)
        end
        return
    end
    if kbMatch(KB.TPFloor, kc) then doTpDown(); return end
    if kbMatch(KB.AutoLeft, kc) then
        autoLeftEnabled = not autoLeftEnabled
        if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
        if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
        return
    end
    if kbMatch(KB.AutoRight, kc) then
        autoRightEnabled = not autoRightEnabled
        if autoRightEnabled then startAutoRight() else stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
        if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
        return
    end
    if kbMatch(KB.AutoBat, kc) then
        if not autoBatEnabled then
            enableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(true) end
            if mobSetAutoBat then mobSetAutoBat(true) end
        else
            disableAutoBat()
            if autoBatSetVisual then autoBatSetVisual(false) end
            if mobSetAutoBat then mobSetAutoBat(false) end
        end
        return
    end
    if kbMatch(KB.BatV2, kc) then
        if _G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2() then
            if _G.__RivalHubStopBatV2 then pcall(_G.__RivalHubStopBatV2) end
            if mobSetBatV2 then mobSetBatV2(false) end
        else
            if _G.__RivalHubStartBatV2 then pcall(_G.__RivalHubStartBatV2) end
            if mobSetBatV2 then mobSetBatV2(true) end
        end
        return
    end
    if kbMatch(KB.GuiHide, kc) then
        if main then
            if main.Visible then hideGui() else showGui() end
        end
        return
    end
end)

do
    local introGeneration = 0
    local wasHoldingBrainrot = false
    local activeIntroGui = nil

    local function isHoldingBrainrot()
        local char = LP and LP.Character
        if not char then return false end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum and tonumber(hum.WalkSpeed) and hum.WalkSpeed < 25 then return true end
        for _, child in ipairs(char:GetChildren()) do
            local name = tostring(child.Name or ""):lower()
            if (child:IsA("Tool") or child:IsA("Model")) and
               (name:find("brainrot", 1, true) or name:find("animal", 1, true) or
                name:find("carry", 1, true) or name:find("grab", 1, true) or
                name:find("steal", 1, true) or name:find("hold", 1, true)) then
                return true
            end
        end
        return false
    end

    local function playBrainrotIntro(myGeneration)
        if activeIntroGui then pcall(function() activeIntroGui:Destroy() end) end
        local playerGui = LP and (LP:FindFirstChildOfClass("PlayerGui") or LP:WaitForChild("PlayerGui", 5))
        if not playerGui or myGeneration ~= introGeneration or not isHoldingBrainrot() then return end

        local introGui = Instance.new("ScreenGui")
        introGui.Name = "BrainrotEnterIntro"
        introGui.ResetOnSpawn = false
        introGui.IgnoreGuiInset = true
        introGui.DisplayOrder = 1000000
        introGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        introGui.Parent = playerGui
        activeIntroGui = introGui

        local strip = Instance.new("Frame")
        strip.Name = "EnterStrip"
        strip.AnchorPoint = Vector2.new(0.5, 0.5)
        strip.Position = UDim2.new(0.5, 0, -0.18, 0)
        strip.Size = UDim2.fromOffset(280, 46)
        strip.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        strip.BorderSizePixel = 0
        strip.ClipsDescendants = false
        strip.ZIndex = 2
        strip.Parent = introGui
        Instance.new("UICorner", strip).CornerRadius = UDim.new(1, 0)

        local completeBorder = Instance.new("UIStroke", strip)
        completeBorder.Name = "CompleteLoadingBorder"
        completeBorder.Color = Color3.fromRGB(255, 255, 255)
        completeBorder.Thickness = 3
        completeBorder.Transparency = 1
        completeBorder.ZIndex = 6

        local scale = Instance.new("UIScale", strip)
        scale.Scale = 0.9
        local track = Instance.new("Frame", strip)
        track.Name = "LoadingTrack"
        track.AnchorPoint = Vector2.new(0.5, 1)
        track.Position = UDim2.new(0.5, 0, 1, -6)
        track.Size = UDim2.new(1, -26, 0, 3)
        track.BackgroundColor3 = Color3.fromRGB(75, 75, 75)
        track.BorderSizePixel = 0
        track.ClipsDescendants = true
        track.ZIndex = 6
        Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

        local lineFill = Instance.new("Frame", track)
        lineFill.Name = "LoadingLine"
        lineFill.Size = UDim2.new(0, 0, 1, 0)
        lineFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        lineFill.BorderSizePixel = 0
        lineFill.ZIndex = 7
        Instance.new("UICorner", lineFill).CornerRadius = UDim.new(1, 0)

        local label = Instance.new("TextLabel", strip)
        label.Name = "EnterLabel"
        label.Size = UDim2.new(1, -32, 1, -16)
        label.Position = UDim2.fromOffset(16, 8)
        label.BackgroundTransparency = 1
        label.Text = "DON'T ENTER"
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.Font = Enum.Font.GothamBlack
        label.TextScaled = true
        label.TextWrapped = true
        label.ZIndex = 5
        local limit = Instance.new("UITextSizeConstraint", label)
        limit.MinTextSize = 10
        limit.MaxTextSize = 16

        local function stillValid()
            return myGeneration == introGeneration and introGui.Parent ~= nil and isHoldingBrainrot()
        end
        local function abortIfReleased()
            if stillValid() then return false end
            if introGui.Parent then introGui:Destroy() end
            if activeIntroGui == introGui then activeIntroGui = nil end
            return true
        end

        local arrival = TS:Create(strip, TweenInfo.new(0.52, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
            Position = UDim2.fromScale(0.5, 0.12)
        })
        TS:Create(scale, TweenInfo.new(0.52, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
        arrival:Play()
        arrival.Completed:Wait()
        if abortIfReleased() then return end

        local revealTime = 1.9
        local elapsed = 0
        while elapsed < revealTime do
            lineFill.Size = UDim2.new(math.clamp(elapsed / revealTime, 0, 1), 0, 1, 0)
            elapsed = elapsed + task.wait()
            if abortIfReleased() then return end
        end
        lineFill.Size = UDim2.new(1, 0, 1, 0)
        completeBorder.Transparency = 0
        label.Text = "ENTER"
        label.TextTransparency = 1
        TS:Create(label, TweenInfo.new(0.18), {TextTransparency = 0}):Play()
        task.wait(0.3)
        if abortIfReleased() then return end
        TS:Create(scale, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingStyle.In), {Scale = 1.35}):Play()
        TS:Create(strip, TweenInfo.new(0.38), {BackgroundTransparency = 1}):Play()
        TS:Create(label, TweenInfo.new(0.25), {TextTransparency = 1}):Play()
        TS:Create(completeBorder, TweenInfo.new(0.25), {Transparency = 1}):Play()
        task.wait(0.4)
        if introGui.Parent then introGui:Destroy() end
        if activeIntroGui == introGui then activeIntroGui = nil end
    end

    task.spawn(function()
        while true do
            local holding = isHoldingBrainrot()
            if holding and not wasHoldingBrainrot then
                introGeneration = introGeneration + 1
                local thisGeneration = introGeneration
                task.spawn(function() playBrainrotIntro(thisGeneration) end)
            elseif not holding and wasHoldingBrainrot then
                introGeneration = introGeneration + 1
                if activeIntroGui then
                    pcall(function() activeIntroGui:Destroy() end)
                    activeIntroGui = nil
                end
            end
            wasHoldingBrainrot = holding
            task.wait(0.1)
        end
    end)
end

-- ============================================================
-- shel.Vs: VISUAL DE ESPADA NO BASTAO
-- Transferido do Moraes tlgd (somente a funcao visual da katana).
-- ============================================================
do
    local SwordPlayers = game:GetService("Players")
    local SwordLP = SwordPlayers.LocalPlayer

    local KATANA_MESH = "rbxassetid://13528902482"
    local KATANA_TEXTURE = "rbxassetid://13528902373"

    local function isBatTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local name = tool.Name:lower()
        return name:find("bat", 1, true) ~= nil or name:find("slap", 1, true) ~= nil
    end

    local function applySwordVisual(tool)
        if not isBatTool(tool) then return end
        local handle = tool:FindFirstChild("Handle")
        if not handle then return end

        local oldReplica = handle:FindFirstChild("ShelSwordReplica")
        if oldReplica then oldReplica:Destroy() end

        local model = Instance.new("Model")
        model.Name = "ShelSwordReplica"

        local part = Instance.new("Part")
        part.Name = "SwordPart"
        part.Size = Vector3.new(1, 1, 1)
        part.Transparency = 0
        part.CanCollide = false
        part.CanTouch = false
        part.CanQuery = false
        part.Massless = true
        part.Anchored = false
        part.Parent = model

        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = KATANA_MESH
        -- Sem textura: assim a lamina/espada em si fica colorida (arco-iris)
        mesh.TextureId = ""
        mesh.Scale = Vector3.new(1.4, 1.4, 1.4)
        mesh.Parent = part

        -- Espada colorida (arco-iris animado)
        part.Material = Enum.Material.Neon
        part.Color = Color3.fromHSV(0, 1, 1)
        part.Reflectance = 0.1
        mesh.VertexColor = Vector3.new(1, 1, 1)

        local glow = Instance.new("PointLight")
        glow.Name = "ShelSwordGlow"
        glow.Brightness = 3
        glow.Range = 12
        glow.Color = part.Color
        glow.Parent = part

        _G.ShelSwordRainbowParts = _G.ShelSwordRainbowParts or {}
        table.insert(_G.ShelSwordRainbowParts, { part = part, mesh = mesh, light = glow })

        model.PrimaryPart = part
        model.Parent = handle
        part.CFrame = handle.CFrame * (
            CFrame.new(0, 0.6, 0)
            * CFrame.Angles(math.rad(270), math.rad(180), math.rad(180))
        )

        local weld = Instance.new("WeldConstraint")
        weld.Part0 = handle
        weld.Part1 = part
        weld.Parent = part

        -- Esconde o bastao original e mostra somente a espada.
        pcall(function() handle.Transparency = 1 end)
    end

    local function watchContainer(container)
        if not container then return end

        for _, child in ipairs(container:GetChildren()) do
            if isBatTool(child) then
                task.defer(applySwordVisual, child)
            end
        end

        if not container:GetAttribute("ShelSwordVisualWatch") then
            container:SetAttribute("ShelSwordVisualWatch", true)
            container.ChildAdded:Connect(function(child)
                if not isBatTool(child) then return end
                task.wait()
                applySwordVisual(child)
            end)
        end
    end

    local function scanSwordTools()
        watchContainer(SwordLP:FindFirstChildOfClass("Backpack"))
        watchContainer(SwordLP.Character)
    end

    scanSwordTools()

    SwordLP.ChildAdded:Connect(function(child)
        if child:IsA("Backpack") then
            watchContainer(child)
        end
    end)

    SwordLP.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        watchContainer(character)
        scanSwordTools()
    end)

    task.spawn(function()
        while task.wait(1) do
            scanSwordTools()
        end
    end)

    -- Loop unico que anima as cores da espada
    if not _G.ShelSwordRainbowLoop then
        _G.ShelSwordRainbowLoop = true
        _G.ShelSwordRainbowSpeed = _G.ShelSwordRainbowSpeed or 0.35
        task.spawn(function()
            while task.wait(0.03) do
                local list = _G.ShelSwordRainbowParts
                if list then
                    local hue = (tick() * (_G.ShelSwordRainbowSpeed or 0.35)) % 1
                    local color = Color3.fromHSV(hue, 1, 1)
                    for i = #list, 1, -1 do
                        local entry = list[i]
                        if entry and entry.part and entry.part.Parent then
                            entry.part.Color = color
                            if entry.mesh then
                                entry.mesh.VertexColor = Vector3.new(color.R, color.G, color.B)
                            end
                            if entry.light then
                                entry.light.Color = color
                            end
                        else
                            table.remove(list, i)
                        end
                    end
                end
            end
        end)
    end

    _G.ShelSwordVisual = {
        apply = scanSwordTools,
        mesh = KATANA_MESH,
        texture = KATANA_TEXTURE,
        rainbow = true,
    }
end
-- ============================================================
-- FIM shel.Vs: VISUAL DE ESPADA NO BASTAO
-- ============================================================


-- ============================================================
-- shel.Vs: SONIDO DE LA ESPADA (TRANSFERIDO DEL MORAES TLGD)
-- Espada: rbxassetid://5713085119
-- ============================================================
do
    local SoundPlayers = game:GetService("Players")
    local SoundLP = SoundPlayers.LocalPlayer
    local SWORD_SOUND = "rbxassetid://5713085119"
    local hookedTools = setmetatable({}, {__mode = "k"})
    local customSounds = setmetatable({}, {__mode = "k"})

    local function isSwordTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local name = tool.Name:lower()
        return name:find("bat", 1, true) ~= nil or name:find("slap", 1, true) ~= nil
            or name:find("sword", 1, true) ~= nil or name:find("knife", 1, true) ~= nil
            or name:find("espada", 1, true) ~= nil
    end

    local function makeCustomSound(parent)
        local old = customSounds[parent]
        if old and old.Parent then
            old.SoundId = SWORD_SOUND
            return old
        end
        local sound = Instance.new("Sound")
        sound.Name = "ShelCustomToolSound"
        sound.SoundId = SWORD_SOUND
        sound.Volume = 1
        sound.Looped = false
        sound.Parent = parent
        customSounds[parent] = sound
        return sound
    end

    local function playCustomSound(parent)
        if not parent or not parent.Parent then return end
        local sound = makeCustomSound(parent)
        pcall(function()
            sound:Stop()
            sound.TimePosition = 0.2
            sound.Volume = 1
            sound:Play()
        end)
    end

    local function hookTool(tool)
        if not isSwordTool(tool) or hookedTools[tool] then return end
        hookedTools[tool] = true
        local hookedSounds = setmetatable({}, {__mode = "k"})

        local function hookSound(sound)
            if not sound:IsA("Sound") or sound.Name == "ShelCustomToolSound" or hookedSounds[sound] then return end
            hookedSounds[sound] = true
            local triggering = false
            local function trigger()
                if triggering or not sound.Parent then return end
                if sound.Playing or sound.TimePosition > 0 then
                    triggering = true
                    pcall(function()
                        sound.Volume = 0
                        sound:Stop()
                    end)
                    playCustomSound(sound.Parent)
                    triggering = false
                end
            end
            sound:GetPropertyChangedSignal("Playing"):Connect(trigger)
            sound:GetPropertyChangedSignal("TimePosition"):Connect(trigger)
        end

        for _, descendant in ipairs(tool:GetDescendants()) do
            hookSound(descendant)
        end
        tool.DescendantAdded:Connect(hookSound)
    end

    local function watchContainer(container)
        if not container then return end
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Tool") then task.defer(hookTool, child) end
        end
        if not container:GetAttribute("ShelToolSoundWatch") then
            container:SetAttribute("ShelToolSoundWatch", true)
            container.ChildAdded:Connect(function(child)
                if not child:IsA("Tool") then return end
                task.wait()
                hookTool(child)
            end)
        end
    end

    local function scanSoundTools()
        watchContainer(SoundLP:FindFirstChildOfClass("Backpack"))
        watchContainer(SoundLP.Character)
    end

    scanSoundTools()
    SoundLP.ChildAdded:Connect(function(child)
        if child:IsA("Backpack") then watchContainer(child) end
    end)
    SoundLP.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        watchContainer(character)
        scanSoundTools()
    end)
    task.spawn(function()
        while task.wait(1) do scanSoundTools() end
    end)

    _G.ShelSwordSound = {
        apply = scanSoundTools,
        SwordSound = SWORD_SOUND,
    }
end
-- ============================================================
-- FIM shel.Vs: SONIDO DE LA ESPADA
-- ============================================================

-- ============================================================
-- shel.Vs: SONIDO DE LA BOMBA (TRANSFERIDO DE shel_Vs_aimbot_modo_v4)
-- Bomba: rbxassetid://138186576 (se activa al usar la Medusa)
-- ============================================================
do
    local BombPlayers = game:GetService("Players")
    local BombLP = BombPlayers.LocalPlayer
    local BOMB_SOUND = "rbxassetid://138186576"
    local bombHooked = setmetatable({}, {__mode = "k"})

    local function isBombTool(obj)
        if not obj or not obj:IsA("Tool") then return false end
        local n = obj.Name:lower()
        return n:find("medusa", 1, true) ~= nil or n:find("head", 1, true) ~= nil
            or n:find("stone", 1, true) ~= nil
    end

    local function hookBombTool(tool)
        if not isBombTool(tool) or bombHooked[tool] then return end
        bombHooked[tool] = true

        -- Silenciar el sonido original de la medusa.
        local function muteOriginal(obj)
            if not obj:IsA("Sound") or obj.Name == "ShelBombSound" then return end
            pcall(function()
                obj.Volume = 0
                obj:Stop()
            end)
            obj:GetPropertyChangedSignal("Volume"):Connect(function()
                if obj.Parent and obj.Volume ~= 0 then obj.Volume = 0 end
            end)
        end
        for _, obj in ipairs(tool:GetDescendants()) do
            muteOriginal(obj)
        end
        tool.DescendantAdded:Connect(muteOriginal)

        local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart", true)
        local bombSound = Instance.new("Sound")
        bombSound.Name = "ShelBombSound"
        bombSound.SoundId = BOMB_SOUND
        bombSound.Volume = 1.0
        bombSound.PlaybackSpeed = 0.95
        bombSound.Looped = false
        bombSound.RollOffMaxDistance = 85
        bombSound.RollOffMinDistance = 8
        bombSound.Parent = handle or tool

        -- El sonido ocurre al usar/activar la medusa, no al equiparla.
        tool.Activated:Connect(function()
            pcall(function()
                if bombSound.IsPlaying then bombSound:Stop() end
                bombSound.TimePosition = 0
                bombSound:Play()
            end)
        end)
    end

    local function watchBombContainer(container)
        if not container then return end
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Tool") then task.defer(hookBombTool, child) end
        end
        if not container:GetAttribute("ShelBombSoundWatch") then
            container:SetAttribute("ShelBombSoundWatch", true)
            container.ChildAdded:Connect(function(child)
                if not child:IsA("Tool") then return end
                task.wait()
                hookBombTool(child)
            end)
        end
    end

    local function scanBombTools()
        watchBombContainer(BombLP:FindFirstChildOfClass("Backpack"))
        watchBombContainer(BombLP.Character)
    end

    scanBombTools()
    BombLP.ChildAdded:Connect(function(child)
        if child:IsA("Backpack") then watchBombContainer(child) end
    end)
    BombLP.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        watchBombContainer(character)
        scanBombTools()
    end)
    task.spawn(function()
        while task.wait(1) do scanBombTools() end
    end)

    _G.ShelBombSound = {
        apply = scanBombTools,
        BombSound = BOMB_SOUND,
    }
end
-- ============================================================
-- FIM shel.Vs: SONIDO DE LA BOMBA
-- ============================================================

-- ============================================================
-- shel.Vs: SKIN DE LA MEDUSA (BOMBA PIXELADA) (TRANSFERIDO DE shel_Vs_aimbot_modo_v4)
-- Reemplaza el visual de la medusa por una bomba negra/roja
-- ============================================================
do
    local SkinPlayers = game:GetService("Players")
    local SkinLP = SkinPlayers.LocalPlayer

    local function isMedusaSkinTool(obj)
        if not obj or not obj:IsA("Tool") then return false end
        local n = obj.Name:lower()
        return n:find("medusa", 1, true) ~= nil or n:find("head", 1, true) ~= nil
            or n:find("stone", 1, true) ~= nil
    end

    local function applyMedusaSkin(tool)
        if not isMedusaSkinTool(tool) then return end
        if tool:GetAttribute("ShelMedusaBombSkin") then return end
        local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart", true)
        if not handle or not handle:IsA("BasePart") then return end
        tool:SetAttribute("ShelMedusaBombSkin", true)

        -- Ocultar la medusa original (y silenciar sus sonidos, sin tocar el sonido de la bomba).
        for _, obj in ipairs(tool:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.LocalTransparencyModifier = 1
            elseif obj:IsA("Sound") and obj.Name ~= "ShelBombSound" then
                obj.Volume = 0
                obj:Stop()
            end
        end

        local bomb = Instance.new("Folder")
        bomb.Name = "ShelMedusaBombSkin"
        bomb.Parent = tool

        local function block(name, size, color, offset, shape, material)
            local part = Instance.new("Part")
            part.Name = name
            part.Size = size
            part.Shape = shape or Enum.PartType.Block
            part.Color = color
            part.Material = material or Enum.Material.SmoothPlastic
            part.CFrame = handle.CFrame * offset
            part.CanCollide = false
            part.CanTouch = false
            part.CanQuery = false
            part.CastShadow = false
            part.Massless = true
            part.Anchored = false
            part.Parent = bomb
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = handle
            weld.Part1 = part
            weld.Parent = part
            return part
        end

        local black = Color3.fromRGB(12, 12, 15)
        local darkRed = Color3.fromRGB(95, 8, 12)
        local red = Color3.fromRGB(225, 25, 32)
        local fuse = Color3.fromRGB(255, 150, 35)
        block("BombBody", Vector3.new(1.25, 1.25, 1.25), black, CFrame.new(0, 0, 0), Enum.PartType.Ball)
        block("BombBand", Vector3.new(1.32, 0.18, 1.32), darkRed, CFrame.new(0, 0.02, 0))
        block("BombCore", Vector3.new(0.72, 0.72, 0.72), red, CFrame.new(0, 0, -0.57), Enum.PartType.Ball, Enum.Material.Neon)
        block("BombCap", Vector3.new(0.42, 0.22, 0.42), darkRed, CFrame.new(0, 0.73, 0))
        block("BombFuse", Vector3.new(0.14, 0.48, 0.14), fuse, CFrame.new(0, 1.03, 0), Enum.PartType.Cylinder, Enum.Material.Neon)
        block("BombSpark", Vector3.new(0.24, 0.24, 0.24), Color3.fromRGB(255, 235, 100), CFrame.new(0, 1.34, 0), Enum.PartType.Ball, Enum.Material.Neon)

        -- Mantener oculta la medusa original si el juego le devuelve partes nuevas.
        tool.DescendantAdded:Connect(function(obj)
            if obj:IsDescendantOf(bomb) then return end
            if obj:IsA("BasePart") then
                obj.LocalTransparencyModifier = 1
            end
        end)
    end

    local function watchSkinContainer(container)
        if not container then return end
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("Tool") then task.defer(applyMedusaSkin, child) end
        end
        if not container:GetAttribute("ShelMedusaSkinWatch") then
            container:SetAttribute("ShelMedusaSkinWatch", true)
            container.ChildAdded:Connect(function(child)
                if not child:IsA("Tool") then return end
                task.wait()
                applyMedusaSkin(child)
            end)
        end
    end

    local function scanSkinTools()
        watchSkinContainer(SkinLP:FindFirstChildOfClass("Backpack"))
        watchSkinContainer(SkinLP.Character)
    end

    scanSkinTools()
    SkinLP.ChildAdded:Connect(function(child)
        if child:IsA("Backpack") then watchSkinContainer(child) end
    end)
    SkinLP.CharacterAdded:Connect(function(character)
        task.wait(0.5)
        watchSkinContainer(character)
        scanSkinTools()
    end)
    task.spawn(function()
        while task.wait(1) do scanSkinTools() end
    end)

    _G.ShelMedusaSkin = {
        apply = scanSkinTools,
    }
end
-- ============================================================
-- FIM shel.Vs: SKIN DE LA MEDUSA
-- ============================================================
