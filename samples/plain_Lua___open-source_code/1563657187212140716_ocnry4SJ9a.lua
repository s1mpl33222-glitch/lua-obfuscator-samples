-- VERSION SEGURA PREPARADA
-- Conserva la interfaz y funciones del archivo original.
-- No se agregaron rastreo dirigido de TARGET_ID/TARGET_USER, envío a Discord
-- mediante webhook ni ejecución de scripts externos desconocidos.
-- Nota: el archivo original puede depender de APIs del ejecutor de Roblox;
-- revisa el código y úsalo únicamente donde tengas autorización.

--============================================================
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

local ORANGE_NEON_LIGHT = Color3.fromRGB(255, 215, 130)
local ORANGE_NEON_MID   = Color3.fromRGB(255, 130, 20)
local ORANGE_NEON_DEEP  = Color3.fromRGB(210, 70, 0)
local ORANGE_BORDER     = Color3.fromRGB(255, 180, 60)
local SILVER_GLOW       = Color3.fromRGB(240, 245, 255)
local SILVER_BRIGHT     = Color3.fromRGB(225, 232, 242)

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
    ColorSequenceKeypoint.new(0.48, Color3.fromRGB(12,5,0)),
    ColorSequenceKeypoint.new(0.52, Color3.fromRGB(26,12,2)),
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
topLine.BackgroundColor3 = ORANGE_NEON_MID
topLine.BackgroundTransparency = 0.18
topLine.BorderSizePixel = 0
topLine.Parent = center

local topGrad = Instance.new("UIGradient", topLine)
topGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(0,0,0)),
    ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,240,220)),
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

local symbolGlow = makeCenterText("SymbolGlow", "Clean and y/out is good", 88, Enum.Font.GothamBlack, ORANGE_NEON_MID, 9)
local symbolStroke = Instance.new("UIStroke", symbolGlow)
symbolStroke.Color = ORANGE_NEON_DEEP
symbolStroke.Thickness = 10
symbolStroke.Transparency = 1

local symbol = makeCenterText("Symbol", "Clean and y/out is good", 82, Enum.Font.GothamBlack, Color3.fromRGB(255,248,240), 11)
local symbolScale = Instance.new("UIScale", symbol)
symbolScale.Scale = 0.72

local noGlow = makeCenterText("NoGlow", "NO!", 102, Enum.Font.GothamBlack, ORANGE_NEON_MID, 12)
local noStroke = Instance.new("UIStroke", noGlow)
noStroke.Color = ORANGE_NEON_DEEP
noStroke.Thickness = 9
noStroke.Transparency = 1

local noText = makeCenterText("NoText", "NO!", 96, Enum.Font.GothamBlack, Color3.fromRGB(255,250,245), 13)
noText.Rotation = -2

local noScale = Instance.new("UIScale", noText)
noScale.Scale = 1.22

local sureGlow = makeCenterText("SureGlow", "RIVAL HUB", 90, Enum.Font.GothamBlack, ORANGE_NEON_MID, 14)
local sureStroke = Instance.new("UIStroke", sureGlow)
sureStroke.Color = ORANGE_NEON_DEEP
sureStroke.Thickness = 10
sureStroke.Transparency = 1

local sure = makeCenterText("Sure", "RIVAL HUB", 86, Enum.Font.GothamBlack, Color3.fromRGB(255,255,255), 16)
sure.Position = UDim2.new(0.5,0,0.46,24)
sureGlow.Position = UDim2.new(0.5,0,0.46,24)

local sureGrad = Instance.new("UIGradient", sure)
sureGrad.Rotation = 0
sureGrad.Offset = Vector2.new(-0.72,0)
sureGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0.00, Color3.fromRGB(210,70,0)),
    ColorSequenceKeypoint.new(0.28, Color3.fromRGB(255,180,90)),
    ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255,255,255)),
    ColorSequenceKeypoint.new(0.72, Color3.fromRGB(255,180,90)),
    ColorSequenceKeypoint.new(1.00, Color3.fromRGB(200,60,0))
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
link.TextColor3 = ORANGE_NEON_LIGHT
link.TextTransparency = 1
link.TextStrokeColor3 = Color3.fromRGB(0,0,0)
link.TextStrokeTransparency = 1
link.ZIndex = 16
link.Parent = center

local under = Instance.new("Frame")
under.AnchorPoint = Vector2.new(0.5,0.5)
under.Position = UDim2.new(0.5,0,0.62,13)
under.Size = UDim2.fromOffset(0,2)
under.BackgroundColor3 = ORANGE_NEON_MID
under.BackgroundTransparency = 0.10
under.BorderSizePixel = 0
under.ZIndex = 15
under.Parent = center

local underGrad = Instance.new("UIGradient", under)
underGrad.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,Color3.fromRGB(18,7,0)),
    ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,240,220)),
    ColorSequenceKeypoint.new(1,Color3.fromRGB(18,7,0))
})

local glitchLeft = Instance.new("Frame")
glitchLeft.AnchorPoint = Vector2.new(1,0.5)
glitchLeft.Position = UDim2.new(0.5,-5,0.5,0)
glitchLeft.Size = UDim2.fromOffset(0,2)
glitchLeft.BackgroundColor3 = ORANGE_NEON_MID
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
    ORANGE_NEON_MID,
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
skipLabel.TextColor3 = ORANGE_NEON_LIGHT
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
flash.BackgroundColor3 = ORANGE_NEON_MID
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
skipButton.BackgroundColor3 = Color3.fromRGB(10,4,0)
skipButton.BackgroundTransparency = 0.15
skipButton.BorderSizePixel = 0
skipButton.AutoButtonColor = false
skipButton.Text = "SKIP"
skipButton.Font = Enum.Font.GothamBold
skipButton.TextSize = 14
skipButton.TextColor3 = Color3.fromRGB(255,240,220)
skipButton.ZIndex = 60
skipButton.Parent = intro
Instance.new("UICorner", skipButton).CornerRadius = UDim.new(0,8)

local skipStroke = Instance.new("UIStroke", skipButton)
skipStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
skipStroke.Color = ORANGE_NEON_MID
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
    "118241258424065",
    "137090941888778",
    "106638406471484",
    "126843729942853",
    "132235750206658",
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

_bgAssetCache = _bgAssetCache or {}
_bgAssetPending = _bgAssetPending or {}
_bgAssetOk = _bgAssetOk or {}

-- Comprueba de verdad si una imagen carga (descarga + decodificacion)
function _bgLoads(url)
    local good = false
    local img = Instance.new("ImageLabel")
    img.Image = url
    pcall(function()
        game:GetService("ContentProvider"):PreloadAsync({img}, function(_, status)
            if status == Enum.AssetFetchStatus.Success then good = true end
        end)
    end)
    local t = 0
    while not img.IsLoaded and t < 8 do task.wait(0.1); t = t + 0.1 end
    local loaded = img.IsLoaded
    pcall(function() img:Destroy() end)
    return good and loaded
end

-- Descarga la miniatura real del asset (sirve para Decals e imagenes) y la carga desde un archivo local
function _bgHttpGet(url)
    local ok, res = pcall(function() return game:HttpGet(url) end)
    if ok and type(res) == "string" and #res > 0 then return res end
    local req = (syn and syn.request) or (http and http.request) or http_request or request
    if req then
        local ok2, r = pcall(req, {Url = url, Method = "GET"})
        if ok2 and r and (r.Success or r.StatusCode == 200) and type(r.Body) == "string" and #r.Body > 0 then
            return r.Body
        end
    end
    return nil
end

function _bgDownloadThumb(id)
    local getAsset = getcustomasset or getsynasset
    if not (writefile and getAsset) then return nil end
    local HttpService = game:GetService("HttpService")
    local imageUrl
    for attempt = 1, 4 do
        local body = _bgHttpGet("https://thumbnails.roblox.com/v1/assets?assetIds=" .. id .. "&returnPolicy=PlaceHolder&size=420x420&format=Png&isCircular=false")
        if body then
            local okJ, data = pcall(function() return HttpService:JSONDecode(body) end)
            local item = okJ and data and data.data and data.data[1]
            if item and item.imageUrl and item.imageUrl ~= "" and item.state == "Completed" then
                imageUrl = item.imageUrl
                break
            end
        end
        task.wait(1)
    end
    if not imageUrl then return nil end
    local bytes = _bgHttpGet(imageUrl)
    if not bytes or #bytes < 100 then return nil end
    local path = "RivalHub_bg_" .. id .. ".png"
    local okW = pcall(writefile, path, bytes)
    if not okW then return nil end
    local okA, asset = pcall(getAsset, path)
    if okA and asset and asset ~= "" then return asset end
    return nil
end

function _bgAsset(id)
    if id == nil then return "" end
    id = tostring(id)
    local raw = "rbxassetid://" .. id
    local cached = _bgAssetCache[id]
    if cached then return cached end
    if not _bgAssetPending[id] then
        _bgAssetPending[id] = true
        task.spawn(function()
            local candidates = {}

            -- 1) GetObjects: si el ID es un Decal/Texture saca la imagen real
            local ok, objs = pcall(function() return game:GetObjects(raw) end)
            if ok and type(objs) == "table" and objs[1] then
                local item = objs[1]
                local found
                local function pick(o)
                    if o:IsA("Decal") or o:IsA("Texture") then return o.Texture end
                    if o:IsA("ImageLabel") or o:IsA("ImageButton") then return o.Image end
                    return nil
                end
                found = pick(item)
                if not found or found == "" then
                    for _, d in ipairs(item:GetDescendants()) do
                        local t = pick(d)
                        if t and t ~= "" then found = t; break end
                    end
                end
                if found and found ~= "" then table.insert(candidates, found) end
                for _, o in ipairs(objs) do pcall(function() o:Destroy() end) end
            end

            -- 2) Respaldo: consulta a assetdelivery (Decal -> id de la imagen real)
            if #candidates == 0 then
                pcall(function()
                    local body = game:HttpGet("https://assetdelivery.roblox.com/v2/assetId/" .. id)
                    local data = game:GetService("HttpService"):JSONDecode(body)
                    local loc = data and data.locations and data.locations[1] and data.locations[1].location
                    if data and data.assetTypeId == 13 and loc then
                        local xml = game:HttpGet(loc)
                        local texId = xml:match("rbxassetid://(%d+)") or xml:match("asset/%?id=(%d+)") or xml:match("id=(%d+)")
                        if texId then table.insert(candidates, "rbxassetid://" .. texId) end
                    end
                end)
            end

            -- 3) El ID tal cual + formas alternativas de cargar el mismo ID
            table.insert(candidates, raw)
            table.insert(candidates, "rbxthumb://type=Asset&id=" .. id .. "&w=420&h=420")
            table.insert(candidates, "http://www.roblox.com/asset/?id=" .. id)

            -- Se queda con el primero que de verdad carga
            local resolved, loadedOk = raw, false
            for attempt = 1, 2 do
                for _, c in ipairs(candidates) do
                    if _bgLoads(c) then resolved = c; loadedOk = true; break end
                end
                if loadedOk then break end
                task.wait(1)
            end
            -- Ultimo recurso: bajar la miniatura real y cargarla como archivo local
            if not loadedOk then
                local okD, custom = pcall(_bgDownloadThumb, id)
                if okD and custom then resolved = custom; loadedOk = true end
            end
            if not loadedOk then
                warn("[RivalHub] La imagen de fondo " .. id .. " no carga (privada, sin aprobar o no es una imagen).")
            end

            _bgAssetCache[id] = resolved
            _bgAssetOk[id] = loadedOk
            _bgAssetPending[id] = nil
            if applyBackgroundMode then pcall(applyBackgroundMode, backgroundMode) end
        end)
    end
    return raw
end

function applyBackgroundMode(mode)
    if mode == "None" or #backgroundImages == 0 then
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
        local _curBgId = tostring(backgroundImages[backgroundIndex])
        main.BackgroundTransparency = (backgroundMode == "None") and 0 or 1
        local bgImage = main:FindFirstChild("BackgroundImage")
        if bgImage then
            bgImage.Image = _bgAsset(backgroundImages[backgroundIndex])
            bgImage.ImageTransparency = backgroundMode == "None" and 1 or backgroundImageTransparency
        end
    end
    if miniBackgroundImage then
        miniBackgroundImage.Image = _bgAsset(backgroundImages[backgroundIndex])
        miniBackgroundImage.ImageTransparency = backgroundMode == "None" and 1 or math.clamp(backgroundImageTransparency + 0.25, 0, 1)
    end
    if backgroundSelectorLabel then backgroundSelectorLabel.Text = backgroundMode end
end

task.spawn(function()
    for i = 1, #backgroundImages do
        pcall(_bgAsset, backgroundImages[i])
    end
end)

local COLOR_THEMES = {
    ["Gray"] = Color3.fromRGB(170, 170, 170),
}

RIVAL_TITLE_THEMES = {
    ["Orange"] = { color = Color3.fromRGB(255, 130, 20),  stroke = nil },
    ["White"]  = { color = Color3.fromRGB(255, 255, 255), stroke = nil },
    ["Black"]  = { color = Color3.fromRGB(0, 0, 0),       stroke = Color3.fromRGB(255, 255, 255) },
    ["Silver"] = { color = Color3.fromRGB(192, 197, 206), stroke = nil },
}
currentRivalTitleTheme = "White"
scriptLogoRef = nil
rivalTitleSelectorLabel = nil

function applyRivalTitleTheme(themeName, noSave)
    local t = RIVAL_TITLE_THEMES[themeName]
    if not t then return end
    currentRivalTitleTheme = themeName
    if scriptLogoRef and scriptLogoRef.Parent then
        local old = scriptLogoRef:FindFirstChildOfClass("UIGradient")
        if old then old:Destroy() end
        scriptLogoRef.TextColor3 = t.color
        if t.stroke then
            scriptLogoRef.TextStrokeColor3 = t.stroke
            scriptLogoRef.TextStrokeTransparency = 0.35
        else
            scriptLogoRef.TextStrokeTransparency = 1
        end
    end
    if rivalTitleSelectorLabel then
        rivalTitleSelectorLabel.Text = themeName
    end
    if not noSave and saveAllSettings then pcall(saveAllSettings) end
end

currentColorTheme = "Gray"
selectedColor = COLOR_THEMES["Gray"]

function getThemeColor() return selectedColor end
ESP_ORANGE = Color3.fromRGB(255, 130, 20)

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

    if pbFrame then
        local border = pbFrame:FindFirstChild("OuterStroke")
        if border then border.Color = Color3.fromRGB(255, 180, 60) end
        local fpsNeon = pbFrame:FindFirstChild("FPSNeon", true)
        if fpsNeon then fpsNeon.TextColor3 = color end
        local pingNeon = pbFrame:FindFirstChild("PingNeon", true)
        if pingNeon then pingNeon.TextColor3 = color end
        local divider = pbFrame:FindFirstChild("Divider", true)
        if divider and divider:IsA("Frame") then divider.BackgroundColor3 = color end

        pbFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        pbFrame.BackgroundTransparency = 0
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
                    local orange = Color3.fromRGB(255, 140, 30)
                    local silver = Color3.fromRGB(240, 245, 255)
                    child.TextColor3 = orange
                    local grad = child:FindFirstChildOfClass("UIGradient")
                    if grad then
                        grad.Color = ColorSequence.new({
                            ColorSequenceKeypoint.new(0.00, orange),
                            ColorSequenceKeypoint.new(0.30, silver),
                            ColorSequenceKeypoint.new(0.50, orange),
                            ColorSequenceKeypoint.new(0.70, silver),
                            ColorSequenceKeypoint.new(1.00, orange),
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
        if stroke then
            stroke.Color = Color3.fromRGB(255, 150, 40)
            stroke.Transparency = 0.05
        end
        local rim = miniBtn:FindFirstChild("Rim")
        if rim then
            local rimStroke = rim:FindFirstChildOfClass("UIStroke")
            if rimStroke then
                rimStroke.Color = Color3.fromRGB(255, 150, 40)
                rimStroke.Transparency = 0.05
            end
        end
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
    do
        local headForFace = char:FindFirstChild("Head")
        local f = headForFace and headForFace:FindFirstChild("face")
        if f then
            local otr = f:GetAttribute("RivalHubOriginalFaceTransparency")
            if otr ~= nil then
                pcall(function() f.Transparency = otr end)
                f:SetAttribute("RivalHubOriginalFaceTransparency", nil)
            end
        end
    end
    for _, child in ipairs(char:GetChildren()) do
        if child.Name:sub(1, #TAG) == TAG
        or child.Name == "AuFfitAccessory"
        or child.Name == "BubbleSkinChanger_Hair"
        or child.Name == "BubbleSkinChanger_Hat"
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
    { bubbleShirt = 11416036966, bubblePants = 5842013905, bubbleHair = 86475919719501, bubbleHat = 121789170766733, korbloxHeadless = true, label = "Outfit 6", headlessKorblox = false },
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
local function addBubbleHair(char, assetId, accName)
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
    hair.Name = accName or "BubbleSkinChanger_Hair"
    for _, part in ipairs(hair:GetDescendants()) do
        if part:IsA("BasePart") then part.Anchored = false; part.CanCollide = false; part.Massless = true; part.LocalTransparencyModifier = 0 end
    end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    local ok = pcall(function() if humanoid then humanoid:AddAccessory(hair) else hair.Parent = char end end)
    if not ok then pcall(function() hair:Destroy() end) end
    if ok then
        task.wait()
        if hair.Parent ~= char then pcall(function() hair.Parent = char end) end
        local handle = hair:FindFirstChild("Handle")
        if handle and handle:IsA("BasePart") and handle.Parent and not handle:FindFirstChildWhichIsA("Weld") and not handle:FindFirstChildWhichIsA("WeldConstraint") then
            pcall(function()
                local att = handle:FindFirstChildWhichIsA("Attachment")
                local target = att and char:FindFirstChild(att.Name, true)
                local weld = Instance.new("Weld")
                weld.Name = "AccessoryWeld"
                if target and target:IsA("Attachment") then
                    weld.Part0 = target.Parent
                    weld.C0 = target.CFrame
                    weld.C1 = att.CFrame
                else
                    weld.Part0 = head
                    weld.C0 = CFrame.new(0, head.Size.Y / 2, 0) * hair.AttachmentPoint:Inverse()
                end
                weld.Part1 = handle
                weld.Parent = handle
            end)
        end
    end
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

function applyBubbleKorbloxHeadless(char)
    if not char then return end
    local targetPart = char:FindFirstChild("RightUpperLeg")
    if targetPart then
        local old = char:FindFirstChild("Korblox_RightLeg")
        if old then old:Destroy() end
        for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
            local limb = char:FindFirstChild(partName)
            if limb and limb:IsA("BasePart") then
                if limb:GetAttribute("RivalHubOutfitOriginalTransparency") == nil then
                    limb:SetAttribute("RivalHubOutfitOriginalTransparency", limb.Transparency)
                end
                limb.Transparency = 1
            end
        end
        local success, objects = pcall(function() return game:GetObjects("rbxassetid://139607718") end)
        if success and objects and #objects > 0 then
            local assetModel = objects[1]
            assetModel.Name = "Korblox_RightLeg"
            local mainMesh = assetModel:IsA("BasePart") and assetModel or assetModel:FindFirstChildWhichIsA("BasePart", true)
            if mainMesh then
                mainMesh.CanCollide = false
                mainMesh.CFrame = targetPart.CFrame
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = targetPart
                weld.Part1 = mainMesh
                weld.Parent = mainMesh
                assetModel.Parent = char
            end
        end
    end
    local head = char:FindFirstChild("Head")
    if head and head:IsA("BasePart") then
        if head:GetAttribute("RivalHubOutfitOriginalTransparency") == nil then
            head:SetAttribute("RivalHubOutfitOriginalTransparency", head.Transparency)
            head:SetAttribute("RivalHubOutfitOriginalLocalTransparency", head.LocalTransparencyModifier)
        end
        head.Transparency = 1
        head.LocalTransparencyModifier = 1
        local face = head:FindFirstChild("face")
        if face and face:IsA("Decal") then
            if face:GetAttribute("RivalHubOriginalFaceTransparency") == nil then
                face:SetAttribute("RivalHubOriginalFaceTransparency", face.Transparency)
            end
            face.Transparency = 1
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
        if cfg.bubbleHat then addBubbleHair(char, cfg.bubbleHat, "BubbleSkinChanger_Hat") end
        if cfg.korbloxHeadless then pcall(applyBubbleKorbloxHeadless, char) end
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
--  Infinite Jump
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
    Float        = {kb = Enum.KeyCode.B, gp = nil},
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
    Float        = {kb = DEFAULT_KB.Float.kb, gp = DEFAULT_KB.Float.gp},
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
mobSetFloat = nil
autoCarryEnabled = false
autoCarryMode = "On Pick Up"
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

--=========================================================
--  updateStealProgress
--=========================================================
function updateStealProgress(value, state)
    value = _clamp(tonumber(value) or 0, 0, 1)
    state = state or (value > 0 and "STEALING" or "READY")

    if progressTween then pcall(function() progressTween:Cancel() end) end
    if progressFill then
        local target = UDim2.new(value, 0, 1, 0)
        progressTween = TS:Create(progressFill, TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Size = target})
        progressTween:Play()
        if state == "CANCELLED" then
            progressFill.BackgroundColor3 = Color3.fromRGB(200, 150, 110)
        else
            progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
    if progressPct then progressPct.Text = _floor(value * 100 + 0.5) .. "%" end
    if progressStatus then
        progressStatus.Text = state
        if state == "STEALING" then
            progressStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
        elseif state == "COMPLETE" then
            progressStatus.TextColor3 = Color3.fromRGB(255, 255, 255)
        elseif state == "CANCELLED" then
            progressStatus.TextColor3 = Color3.fromRGB(200, 140, 80)
        else
            progressStatus.TextColor3 = Color3.fromRGB(230, 238, 248)
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

--=========================================================
--  FLOAT (portado de Lust Hub)
--=========================================================
do
    local old = rawget(_G, "__RivalHubFloat")
    if type(old) == "table" then
        local wasOn = old.running == true or old.conn ~= nil
        old.running = false
        old.cycleToken = (old.cycleToken or 0) + 1
        if old.thread then pcall(task.cancel, old.thread); old.thread = nil end
        if old.conn then pcall(function() old.conn:Disconnect() end); old.conn = nil end
        if wasOn and type(old.groundTP) == "function" then pcall(old.groundTP) end
    end
end

_G.__RivalHubFloat = {
    RISE = 17, RATE = 55, CYCLE = 2.5, PAUSE = 0.5, SAMPLE = 0.08, PIT_MARGIN = 15,
    conn = nil, thread = nil, running = false, locked = false,
    targetY = nil, baseY = nil, baseGround = nil,
    safeValid = false, safeX = 0, safeZ = 0, safeY = 0,
    cycleToken = 0, _params = nil,
}

function _G.__RivalHubFloat.getHRP()
    local c = LP.Character
    if not c then return nil, nil end
    return c:FindFirstChild("HumanoidRootPart"), c:FindFirstChildOfClass("Humanoid")
end

function _G.__RivalHubFloat.arm()
    if _G.__CrystalAntiDieSource then pcall(_G.__CrystalAntiDieSource, "float", true) end
end
function _G.__RivalHubFloat.release()
    if _G.__CrystalAntiDieSource then pcall(_G.__CrystalAntiDieSource, "float", false) end
end

function _G.__RivalHubFloat.findGround(char, hrp)
    local FLOAT = _G.__RivalHubFloat
    local params = FLOAT._params
    if not params then
        params = RaycastParams.new()
        params.FilterType = Enum.RaycastFilterType.Exclude
        params.IgnoreWater = true
        pcall(function() params.RespectCanCollide = true end)
        FLOAT._params = params
    end
    local filter = { char }
    local plist = _GetPlayersCached()
    for i = 1, #plist do
        local plr = plist[i]
        if plr ~= LP and plr.Character then filter[#filter + 1] = plr.Character end
    end
    local half = hrp.Size.Y * 0.5
    if half <= 0 then half = 1 end
    local origin = hrp.Position
    local startY = origin.Y - half - 0.1
    for _ = 1, 6 do
        params.FilterDescendantsInstances = filter
        local res = Workspace:Raycast(Vector3.new(origin.X, startY, origin.Z), Vector3.new(0, -1000, 0), params)
        if not res then return nil, half end
        local part = res.Instance
        if part and part:IsA("BasePart") and part.CanCollide then
            local model = part:FindFirstAncestorOfClass("Model")
            if not (model and model:FindFirstChildOfClass("Humanoid")) then
                return res.Position.Y, half
            end
        end
        if part then filter[#filter + 1] = part end
        startY = res.Position.Y - 0.05
    end
    return nil, half
end

function _G.__RivalHubFloat.isSafeGround(g)
    local FLOAT = _G.__RivalHubFloat
    if not g then return false end
    if FLOAT.baseGround and g < FLOAT.baseGround - FLOAT.PIT_MARGIN then return false end
    return true
end

function _G.__RivalHubFloat.groundTP()
    local FLOAT = _G.__RivalHubFloat
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end

    local pos = hrp.Position
    local x, z = pos.X, pos.Z
    local groundY, half
    pcall(function() groundY, half = FLOAT.findGround(char, hrp) end)

    local relocated = false
    if not FLOAT.isSafeGround(groundY) and FLOAT.safeValid then
        x, z, groundY = FLOAT.safeX, FLOAT.safeZ, FLOAT.safeY
        relocated = true
    end

    local targetY
    if groundY then
        half = half or math.max(hrp.Size.Y * 0.5, 1)
        local off = half * 3
        if hum.RigType ~= Enum.HumanoidRigType.R6 then
            off = half + (hum.HipHeight or (half * 2))
        end
        if off ~= off or off < 1 or off > 12 then off = half * 3 end
        targetY = groundY + off + 0.15
    elseif FLOAT.baseY then
        targetY = FLOAT.baseY
    end

    if targetY and targetY == targetY and targetY > -400 then
        pcall(function()
            if not relocated and pos.Y - targetY < 0.5 then
                hrp.AssemblyLinearVelocity = Vector3.zero
                return
            end
            hrp.CFrame = CFrame.new(x, targetY, z) * hrp.CFrame.Rotation
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
    end
end

function _G.__RivalHubFloat.startLoop()
    local FLOAT = _G.__RivalHubFloat
    if FLOAT.conn then return end
    FLOAT.locked = false
    FLOAT.targetY = nil

    local char0 = LP.Character
    local root0 = char0 and char0:FindFirstChild("HumanoidRootPart")
    local hum0 = char0 and char0:FindFirstChildOfClass("Humanoid")
    if hum0 then
        pcall(function() hum0:ChangeState(Enum.HumanoidStateType.Freefall) end)
    end

    FLOAT.safeValid = false
    FLOAT.baseGround = nil
    if char0 and root0 then
        local ok, g = pcall(FLOAT.findGround, char0, root0)
        if ok and g then
            FLOAT.baseGround = g
            FLOAT.safeX, FLOAT.safeZ, FLOAT.safeY = root0.Position.X, root0.Position.Z, g
            FLOAT.safeValid = true
        end
    end

    local cChar, cRoot, cHum = nil, nil, nil
    local sampleT = 0
    FLOAT.conn = RunService.Heartbeat:Connect(function(dt)
        local char = LP.Character
        if char ~= cChar or not cRoot or not cRoot.Parent then
            cChar = char
            cRoot = char and char:FindFirstChild("HumanoidRootPart") or nil
            cHum  = char and char:FindFirstChildOfClass("Humanoid") or nil
        end
        if not cRoot or not cHum or cHum.Health <= 0 then return end

        local cf  = cRoot.CFrame
        local pos = cf.Position
        local vel = cRoot.AssemblyLinearVelocity

        sampleT = sampleT + dt
        if sampleT >= FLOAT.SAMPLE then
            sampleT = 0
            local ok, g = pcall(FLOAT.findGround, cChar, cRoot)
            if ok and FLOAT.isSafeGround(g) then
                FLOAT.safeX, FLOAT.safeZ, FLOAT.safeY = pos.X, pos.Z, g
                FLOAT.safeValid = true
            elseif ok and FLOAT.safeValid then
                pos = Vector3.new(FLOAT.safeX, pos.Y, FLOAT.safeZ)
                vel = Vector3.new(0, vel.Y, 0)
            end
        end

        if not FLOAT.targetY then
            FLOAT.baseY   = pos.Y
            FLOAT.targetY = pos.Y + FLOAT.RISE
        end
        local y = FLOAT.targetY
        if not FLOAT.locked then
            y = math.min(pos.Y + FLOAT.RATE * dt, FLOAT.targetY)
            if y >= FLOAT.targetY then FLOAT.locked = true end
        end
        cRoot.CFrame = CFrame.new(pos.X, y, pos.Z) * cf.Rotation
        cRoot.AssemblyLinearVelocity = Vector3.new(vel.X, 0, vel.Z)
    end)
end

function _G.__RivalHubFloat.stopLoop(tpDown)
    local FLOAT = _G.__RivalHubFloat
    if FLOAT.conn then
        pcall(function() FLOAT.conn:Disconnect() end)
        FLOAT.conn = nil
    end
    if tpDown then pcall(FLOAT.groundTP) end
end

function _G.__RivalHubFloat.waitGrounded(timeout)
    local FLOAT = _G.__RivalHubFloat
    local deadline = os.clock() + (timeout or 3)
    while os.clock() < deadline do
        if not FLOAT.running then return end
        local hrp, hum = FLOAT.getHRP()
        if not hrp or not hum then return end
        if hum.Health <= 0 then return end
        if hum.FloorMaterial ~= Enum.Material.Air then
            task.wait(FLOAT.PAUSE)
            return
        end
        RunService.Heartbeat:Wait()
    end
end

function _G.__RivalHubFloat.spawnCycle()
    local FLOAT = _G.__RivalHubFloat
    if FLOAT.thread then pcall(task.cancel, FLOAT.thread); FLOAT.thread = nil end
    FLOAT.cycleToken = FLOAT.cycleToken + 1
    local token = FLOAT.cycleToken
    FLOAT.thread = task.spawn(function()
        while FLOAT.running and FLOAT.cycleToken == token do
            task.wait(FLOAT.CYCLE)
            if not FLOAT.running or FLOAT.cycleToken ~= token then break end
            FLOAT.stopLoop(true)
            FLOAT.waitGrounded(3)
            if not FLOAT.running or FLOAT.cycleToken ~= token then break end
            FLOAT.startLoop()
        end
    end)
end

function _G.__RivalHubFloat.enable()
    local FLOAT = _G.__RivalHubFloat
    if FLOAT.running then return end
    FLOAT.running = true
    FLOAT.arm()
    FLOAT.startLoop()
    FLOAT.spawnCycle()
end

function _G.__RivalHubFloat.disable()
    local FLOAT = _G.__RivalHubFloat
    if not FLOAT.running then return end
    FLOAT.running = false
    FLOAT.cycleToken = FLOAT.cycleToken + 1
    if FLOAT.thread then pcall(task.cancel, FLOAT.thread); FLOAT.thread = nil end
    FLOAT.stopLoop(true)
    FLOAT.safeValid = false
    FLOAT.baseGround = nil
    FLOAT.release()
end

function _G.__RivalHubFloatToggle()
    local F = _G.__RivalHubFloat
    if F.running then F.disable() else F.enable() end
    if _G.__RivalHubFloatSetVisual then pcall(_G.__RivalHubFloatSetVisual, F.running) end
    if mobSetFloat then pcall(mobSetFloat, F.running) end
end

function _G.__RivalHubFloatIsRunning()
    return _G.__RivalHubFloat.running == true
end

--=========================================================
--  AUTO CARRY (portado de Lust Hub: On Pick Up + Soft Steal)
--=========================================================
do
    local old = rawget(_G, "__RivalHubAutoCarryStop")
    if type(old) == "function" then pcall(old) end

    _G._VynxAutoSpeedRange = tonumber(_G._VynxAutoSpeedRange) or 12
    local state = { active = false, previous = nil, graceUntil = 0, conn = nil }
    local soft  = { spots = {}, nextScan = 0, latched = false, held = false, armed = true }

    local function getFamily()
        if laggerToggled or laggerCarryToggled then return "lagger" end
        return "normal"
    end
    local function getCarry()
        return (speedMode == true) or (laggerCarryToggled == true)
    end
    local function setFamilyCarry(family, carry)
        carry = carry == true
        if family == "lagger" then
            laggerCarryToggled = carry
            laggerToggled      = not carry
            speedMode          = false
        else
            laggerToggled      = false
            laggerCarryToggled = false
            speedMode          = carry
        end
    end
    local function refresh()
        if refreshSpeedModeLabel then pcall(refreshSpeedModeLabel) end
        if mobSetCarry then pcall(mobSetCarry, speedMode == true) end
        if mobSetLagger1 then pcall(mobSetLagger1, laggerToggled == true) end
        if mobSetLagger2 then pcall(mobSetLagger2, laggerCarryToggled == true) end
        if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end
    end

    local function isWeaponName(value)
        local n = tostring(value or ""):lower()
        return n:find("bat") or n:find("slap") or n:find("medusa")
            or n:find("head") or n:find("stone")
    end

    local function isCarrying(character)
        if not character then return false end
        if LP:GetAttribute("Stealing") == true
            or LP:GetAttribute("AntiKick") == true
            or character:GetAttribute("Stealing") == true then
            return true
        end
        for _, entry in ipairs({ "Carrying","IsCarrying","Grabbed","Holding","StealHold","HasGrab" }) do
            local inst = character:FindFirstChild(entry, true)
            if inst and (
                (inst:IsA("BoolValue")    and inst.Value)
                or (inst:IsA("ObjectValue") and inst.Value)
                or (inst:IsA("StringValue") and inst.Value ~= "")
            ) then return true end
        end
        for _, child in ipairs(character:GetChildren()) do
            local n = child.Name:lower()
            if child:IsA("Tool") and not isWeaponName(n) then return true end
            local bp = child:IsA("Model") and child:FindFirstChildWhichIsA("BasePart", true)
            local hit
            if bp then
                hit = n:find("brainrot") or n:find("animal") or n:find("carry")
                   or n:find("grab")     or n:find("steal")  or n:find("hold")
            else
                hit = bp
            end
            if hit then return true end
        end
        return false
    end

    local function enable()
        if state.active then
            state.graceUntil = tick() + 0.75
            return
        end
        state.previous   = { family = getFamily(), carry = getCarry() }
        state.active     = true
        state.graceUntil = tick() + 0.75
        setFamilyCarry(getFamily(), true)
        refresh()
    end

    local function restore()
        if not state.active then return end
        local previous = state.previous
        state.active   = false
        state.previous = nil
        if previous then setFamilyCarry(previous.family, previous.carry) end
        refresh()
    end

    local function softEnable()
        if not state.active then
            state.previous = { family = getFamily(), carry = getCarry() }
            state.active   = true
        end
        state.graceUntil = tick() + 0.75
        setFamilyCarry(getFamily(), true)
        refresh()
    end

    local function scanSpots()
        local spots = {}
        local plots = workspace:FindFirstChild("Plots")
        if not plots then soft.spots = spots; return end
        for _, child in ipairs(plots:GetChildren()) do
            local sign = child:FindFirstChild("PlotSign")
            sign = sign and sign:FindFirstChild("YourBase")
            if not (sign and sign:IsA("BillboardGui") and sign.Enabled == true) then
                local pods = child:FindFirstChild("AnimalPodiums")
                if pods then
                    for _, pod in ipairs(pods:GetChildren()) do
                        local base = pod:FindFirstChild("Base")
                        base = base and base:FindFirstChild("Spawn")
                        if base then spots[#spots + 1] = base.Position end
                    end
                end
            end
        end
        soft.spots = spots
    end

    local function nearStealSpot(character)
        local root = character and character:FindFirstChild("HumanoidRootPart")
        if not root then return false end
        local range = tonumber(_G._VynxAutoSpeedRange) or 15
        local target = _G._VantaStealTargetPos or _G._RaVeStealTargetPos
        if typeof(target) == "Vector3" and (root.Position - target).Magnitude <= range then
            return true
        end
        local now = tick()
        if soft.nextScan <= now then
            soft.nextScan = now + 0.5
            scanSpots()
        end
        for _, spot in ipairs(soft.spots) do
            if (root.Position - spot).Magnitude <= range then return true end
        end
        return false
    end

    local function startAutoCarry()
        if state.conn then state.conn:Disconnect() end
        state.conn = RunService.RenderStepped:Connect(function()
            if not autoCarryEnabled then
                restore(); return
            end
            local character = LP.Character
            local humanoid  = character and character:FindFirstChildOfClass("Humanoid")
            if not character or not humanoid or humanoid.Health <= 0 then
                restore(); return
            end

            if autoCarryMode == "Soft Steal" then
                local near     = nearStealSpot(character)
                local carrying = isCarrying(character)
                local away     = not near

                if away then soft.armed = true end
                if away or getCarry() ~= true then soft.latched = false end

                if near and soft.armed and not soft.latched then
                    soft.latched = true
                    soft.held    = false
                    softEnable()
                end

                if state.active then
                    if carrying then
                        soft.held = true
                        state.graceUntil = tick() + 0.75
                    elseif soft.held then
                        soft.held    = false
                        soft.latched = false
                        soft.armed   = false
                        restore()
                    else
                        local away2 = not near
                        if away2 then away2 = tick() > state.graceUntil end
                        if away2 then
                            soft.latched = false
                            restore()
                        end
                    end
                end
                return
            end

            if isCarrying(character) then
                enable()
            elseif state.active then
                restore()
            end
        end)
    end

    local function stopAutoCarry()
        if state.conn then
            state.conn:Disconnect()
            state.conn = nil
        end
        soft.latched = false
        soft.held    = false
        soft.armed   = true
        restore()
    end

    local charConn = LP.CharacterAdded:Connect(function()
        soft.latched = false
        soft.held    = false
        soft.armed   = true
    end)

    _G.__RivalHubAutoCarryStop = function()
        stopAutoCarry()
        pcall(function() charConn:Disconnect() end)
    end
    _G.__RivalHubAutoCarryRestore = restore
    startAutoCarry()
end

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
_antiDieSources = { toggle = false, autobat = false, float = false }

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
    _antiDieSetEnabled(manual or _antiDieSources.autobat or _antiDieSources.float)
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
--  Anti Bat
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
    local c = ESP_ORANGE
    return c, c
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
    nameLabel.TextColor3 = ESP_ORANGE
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
                esp.NameLabel.TextColor3 = ESP_ORANGE
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
                esp.NameLabel.TextColor3 = ESP_ORANGE
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
    _espLineFrame.BackgroundColor3 = ESP_ORANGE
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
            _espLineFrame.BackgroundColor3 = ESP_ORANGE
            _espLineFrame.Visible = true
        end)
        if not ok and _espLineFrame then
            pcall(function() _espLineFrame.Visible = false end)
        end
    end)
end

ENEMY_SPEED_COLOR = Color3.fromRGB(255, 130, 20)

function _enemySpeedDrop(player)
    local old = enemySpeedLabels[player]
    enemySpeedLabels[player] = nil
    if old then
        pcall(function()
            local bb = old.Parent
            if bb then bb:Destroy() else old:Destroy() end
        end)
    end
end

function updateEnemySpeedLabels()
    local players = _GetPlayersCached()
    for i = 1, #players do
        local player = players[i]
        if player ~= LP then
            local ok = pcall(function()
                local char = player.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                local head = char and char:FindFirstChild("Head")
                if hrp and hum and head and hum.Health > 0 then
                    local label = enemySpeedLabels[player]
                    if label and not (label.Parent and label.Parent.Parent == head) then
                        _enemySpeedDrop(player)
                        label = nil
                    end
                    if not label then
                        local bb = Instance.new("BillboardGui")
                        bb.Name = "EnemySpeedGui"
                        bb.Size = UDim2.new(0, 100, 0, 25)
                        bb.StudsOffset = _V3new(0, 3.2, 0)
                        bb.AlwaysOnTop = true
                        bb.MaxDistance = math.huge
                        bb.ResetOnSpawn = false
                        bb.Adornee = head
                        bb.Parent = head
                        local tl = Instance.new("TextLabel", bb)
                        tl.Size = UDim2.new(1, 0, 1, 0)
                        tl.BackgroundTransparency = 1
                        tl.TextColor3 = ENEMY_SPEED_COLOR
                        tl.Font = Enum.Font.GothamBlack
                        tl.TextScaled = true
                        tl.TextStrokeTransparency = 0
                        tl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                        enemySpeedLabels[player] = tl
                        label = tl
                    end
                    local v = hrp.AssemblyLinearVelocity
                    label.Text = string.format("%.1f", _sqrt(v.X*v.X + v.Z*v.Z))
                    if label.TextColor3 ~= ENEMY_SPEED_COLOR then label.TextColor3 = ENEMY_SPEED_COLOR end
                else
                    _enemySpeedDrop(player)
                end
            end)
            if not ok then _enemySpeedDrop(player) end
        end
    end
    for player in pairs(enemySpeedLabels) do
        if not player.Parent then _enemySpeedDrop(player) end
    end
end

function startEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect() end
    enemySpeedConn = RunService.Heartbeat:Connect(updateEnemySpeedLabels)
end

function stopEnemySpeed()
    if enemySpeedConn then enemySpeedConn:Disconnect(); enemySpeedConn = nil end
    for player in pairs(enemySpeedLabels) do _enemySpeedDrop(player) end
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

--=========================================================
--  setupSpeedIndicator
--=========================================================
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
    speedLabel.TextColor3 = Color3.fromRGB(255, 140, 30)
    speedLabel.Font = Enum.Font.GothamBlack
    speedLabel.TextSize = 22
    speedLabel.TextXAlignment = Enum.TextXAlignment.Center
    speedLabel.TextYAlignment = Enum.TextYAlignment.Center
    speedLabel.TextStrokeTransparency = 0
    speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    local slStroke = Instance.new("UIStroke", speedLabel)
    slStroke.Color = Color3.fromRGB(255, 200, 100)
    slStroke.Thickness = 1.8
    slStroke.Transparency = 0.05
    applyShimmerToText(speedLabel, 0.9, Color3.fromRGB(255, 140, 30))

    local dbb = Instance.new("BillboardGui", head)
    dbb.Name = "DiscordText"
    dbb.Size = UDim2.fromOffset(200, 24)
    dbb.StudsOffset = Vector3.new(0, 4.4, 0)
    dbb.AlwaysOnTop = true
    dbb.LightInfluence = 0
    dbb.MaxDistance = 0

    local dLabel = Instance.new("TextLabel", dbb)
    dLabel.Name = "DiscordLabel"
    dLabel.Size = UDim2.new(1, 0, 1, 0)
    dLabel.BackgroundTransparency = 1
    dLabel.Text = "discord.gg/rivalhub"
    dLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    dLabel.Font = Enum.Font.GothamBlack
    dLabel.TextSize = 16
    dLabel.TextXAlignment = Enum.TextXAlignment.Center
    dLabel.TextYAlignment = Enum.TextYAlignment.Center
    dLabel.TextStrokeTransparency = 0
    dLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    local dStroke = Instance.new("UIStroke", dLabel)
    dStroke.Color = Color3.fromRGB(255, 130, 20)
    dStroke.Thickness = 1.4
    dStroke.Transparency = 0.1
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


-- ============================================================
-- BYPASS BAT
-- ============================================================
local ADAPT_BP_ANG = "_AdaptBP_AngV"
local ADAPT_BP_ATT = "_AdaptBP_Att"
local ADAPT_BP_CLEAN = {
    "LockBAV", "LockAngVel", "LockBodyAtt", "BatLock", "LockBAVAtt",
    "AutoBatAtt", "AutoBatAV", "AntiBatDet", "AntiAim", "VelocityLock",
}
local ADAPT_BP_SWING_RANGE = 12

local adaptBP = {
    equipped = false,
    target = nil,
    intendedVelocity = Vector3.zero,
    angularVelocity = nil,
    attachment = nil,
    respawnConn = nil,
}
_G.__RivalHubBubbleAimbotState = adaptBP

local function adaptBPClean(root)
    if not root then return end
    pcall(function()
        for _, n in ipairs(ADAPT_BP_CLEAN) do
            local c = root:FindFirstChild(n)
            if c then c:Destroy() end
        end
        for _, child in ipairs(root:GetChildren()) do
            if child.Name ~= ADAPT_BP_ANG and child.Name ~= ADAPT_BP_ATT then
                local ln = child.Name:lower()
                if ln:find("lockb") or ln:find("lockangv") or ln:find("batlock")
                   or ln:find("antiaim") or ln:find("velocitylock") then
                    child:Destroy()
                end
            end
        end
    end)
end

local function adaptBPEnsureAngular(parent)
    pcall(function()
        local a = parent:FindFirstChild(ADAPT_BP_ANG); if a then a:Destroy() end
        local b = parent:FindFirstChild(ADAPT_BP_ATT); if b then b:Destroy() end
    end)
    local att = Instance.new("Attachment")
    att.Name = ADAPT_BP_ATT
    att.Parent = parent
    local angV = Instance.new("AngularVelocity")
    angV.Name = ADAPT_BP_ANG
    angV.Attachment0 = att
    angV.RelativeTo = Enum.ActuatorRelativeTo.World
    angV.MaxTorque = math.huge
    angV.AngularVelocity = Vector3.zero
    angV.Parent = parent
    adaptBP.attachment = att
    adaptBP.angularVelocity = angV
end

local function adaptBPRemoveAngular()
    pcall(function()
        if adaptBP.angularVelocity and adaptBP.angularVelocity.Parent then adaptBP.angularVelocity:Destroy() end
    end)
    pcall(function()
        if adaptBP.attachment and adaptBP.attachment.Parent then adaptBP.attachment:Destroy() end
    end)
    adaptBP.angularVelocity = nil
    adaptBP.attachment = nil
end

local function adaptBPFindBat()
    local char = LP.Character
    if not char then return nil end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            local n = child.Name:lower()
            if n:find("bat") or n:find("slap") then return child end
        end
    end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") then
                local n = child.Name:lower()
                if n:find("bat") or n:find("slap") then return child end
            end
        end
    end
    return nil
end

local function adaptBPNearest(fromRoot)
    local best, bestDist = nil, math.huge
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP and plr.Character then
            local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local d = (hrp.Position - fromRoot.Position).Magnitude
                if d < bestDist then bestDist = d; best = hrp end
            end
        end
    end
    return best, bestDist
end

startCircleCombat = function()
    if circleConnection then return end
    adaptBP.equipped = false
    adaptBP.target = nil
    adaptBP.intendedVelocity = Vector3.zero

    local c0 = LP.Character
    local r0 = c0 and c0:FindFirstChild("HumanoidRootPart")
    if r0 then
        adaptBPClean(r0)
        adaptBPEnsureAngular(r0)
    end

    circleConnection = RunService.Heartbeat:Connect(function()
        if not State.bypassBatEnabled then return end
        local char = LP.Character
        local humanoid = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root or not humanoid or humanoid.Health <= 0 then return end

        adaptBPClean(root)
        if not adaptBP.angularVelocity or not adaptBP.angularVelocity.Parent then
            adaptBPEnsureAngular(root)
        end

        if not adaptBP.equipped then
            adaptBP.equipped = true
            if not char:FindFirstChildOfClass("Tool") then
                local b = adaptBPFindBat()
                if b then pcall(function() humanoid:EquipTool(b) end) end
            end
        end

        local target, dist = adaptBPNearest(root)
        if not target then
            adaptBP.target = nil
            humanoid.AutoRotate = true
            if adaptBP.angularVelocity then adaptBP.angularVelocity.AngularVelocity = Vector3.zero end
            return
        end
        adaptBP.target = target

        local aimPos = target.Position
            + target.CFrame.LookVector * (target.Velocity.Magnitude < 0.1 and 1.5 or 5)
        local delta = aimPos - root.Position
        local flat = Vector3.new(delta.X, 0, delta.Z)
        humanoid.AutoRotate = false

        if delta.Magnitude > 0.01 and flat.Magnitude > 0.01 then
            local curY = root.Orientation.Y
            local yawD = (math.deg(math.atan2(-flat.X, -flat.Z)) - curY + 180) % 360 - 180
            local curX = root.Orientation.X
            local pitchD = (math.deg(math.atan2(delta.Y, flat.Magnitude)) - curX + 180) % 360 - 180
            local rotY = math.clamp(math.rad(yawD) * 40, -28, 28)
            local rotX = math.clamp(math.rad(pitchD) * 40, -28, 28)
            local yawR = math.rad(root.Orientation.Y)
            local fwd = Vector3.new(math.cos(yawR), 0, -math.sin(yawR))
            adaptBP.angularVelocity.AngularVelocity = Vector3.new(0, rotY, 0) + fwd * rotX
        else
            adaptBP.angularVelocity.AngularVelocity = Vector3.zero
        end

        local spd = tonumber(State.bypassBatSpeed) or tonumber(BYPASS_AIMBOT_SPEED) or 58
        if spd ~= spd or spd <= 0 or spd == math.huge then spd = 58 end

        adaptBP.intendedVelocity =
            (flat.Magnitude > 0.1 and flat.Unit * spd or Vector3.zero)
            + (math.abs(delta.Y) > 0.8
                and Vector3.new(0, math.sign(delta.Y) * spd, 0)
                or Vector3.new(0, -2, 0))
        root.Velocity = adaptBP.intendedVelocity

        if flat.Magnitude > 0.5 then
            pcall(function() humanoid:Move(flat.Unit, false) end)
        end

        if dist <= ADAPT_BP_SWING_RANGE then
            local bat = char:FindFirstChildOfClass("Tool")
            if bat and isBatTool and isBatTool(bat) then
                pcall(function()
                    bat:Activate()
                    local re = bat:FindFirstChildWhichIsA("RemoteEvent")
                    if re then re:FireServer() end
                end)
            end
        end
    end)

    circleSafetyConn = RunService.RenderStepped:Connect(function()
        if not State.bypassBatEnabled then return end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        local v = root.Velocity
        if math.abs(v.X) > 350 or math.abs(v.Z) > 350 then
            root.Velocity = adaptBP.intendedVelocity
        end
        adaptBPClean(root)
    end)

    if not adaptBP.respawnConn then
        adaptBP.respawnConn = LP.CharacterAdded:Connect(function(character)
            task.wait(0.5)
            adaptBP.equipped = false
            adaptBP.target = nil
            if State.bypassBatEnabled then
                local root = character:WaitForChild("HumanoidRootPart", 5)
                if root then
                    adaptBPClean(root)
                    adaptBPEnsureAngular(root)
                end
            end
        end)
    end
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
    adaptBP.equipped = false
    adaptBP.target = nil

    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if root then
        pcall(function() root.Velocity = root.Velocity * 0.3 end)
    end
    if hum then hum.AutoRotate = true end
    if adaptBP.angularVelocity then
        pcall(function() adaptBP.angularVelocity.AngularVelocity = Vector3.zero end)
    end
    adaptBPRemoveAngular()
    if root then
        local a = root:FindFirstChild(ADAPT_BP_ANG); if a then a:Destroy() end
        local at = root:FindFirstChild(ADAPT_BP_ATT); if at then at:Destroy() end
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

-- ===== MEDUSA SKINS (portado de GROK GOOD DUELS) =====
do
    _G.RivalMedusaSkinAssets = {
        Skull = {
            mesh = "rbxassetid://2050312704", tex = "rbxassetid://2050313393",
            scale = Vector3.new(1, 1, 1),
            c0 = CFrame.new(0, 0.65, -0.4) * CFrame.Angles(math.rad(330), 0, 0),
        },
        GoldenDesertEagle = {
            mesh = "rbxassetid://430251413", tex = "rbxassetid://435840335",
            scale = Vector3.new(0.01, 0.01, 0.01),
            c0 = CFrame.new(0, 0, -0.8) * CFrame.Angles(math.rad(330), math.rad(180), 0),
        },
    }
    _G.RivalMedusaSkin = _G.RivalMedusaSkin or "Default"

    local function isMedusaTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local n = tool.Name:lower()
        return (n:find("medusa") or n:find("stone") or n:find("head")) and true or false
    end

    local function clearReplica(tool)
        local handle = tool and tool:FindFirstChild("Handle")
        if not handle then return end
        local rep = handle:FindFirstChild("RivalMedusaReplica")
        if rep then pcall(function() rep:Destroy() end) end
        -- restaurar visibilidad original
        for _, d in ipairs(tool:GetDescendants()) do
            if d:GetAttribute("RivalMedusaHidden") ~= nil then
                local orig = d:GetAttribute("RivalMedusaHidden")
                pcall(function() d.Transparency = orig end)
                pcall(function() d:SetAttribute("RivalMedusaHidden", nil) end)
            end
        end
    end

    local function hideOriginal(tool)
        for _, d in ipairs(tool:GetDescendants()) do
            if (d:IsA("BasePart") or d:IsA("Decal") or d:IsA("Texture"))
                and not d:FindFirstAncestor("RivalMedusaReplica")
                and not d:FindFirstAncestor("ShelMedusaBombSkin") then
                pcall(function()
                    if d:GetAttribute("RivalMedusaHidden") == nil then
                        d:SetAttribute("RivalMedusaHidden", d.Transparency)
                    end
                    d.Transparency = 1
                end)
            end
        end
    end

    local function buildReplica(tool, key)
        local data = _G.RivalMedusaSkinAssets[key]
        local handle = tool:FindFirstChild("Handle")
        if not data or not handle then return end
        local cur = handle:FindFirstChild("RivalMedusaReplica")
        if cur and cur:GetAttribute("SkinKey") == key then
            hideOriginal(tool) -- mantener oculto el original
            for _, d in ipairs(cur:GetDescendants()) do
                if d:IsA("BasePart") then
                    if d.Transparency ~= 0 then d.Transparency = 0 end
                    if d.LocalTransparencyModifier ~= 0 then d.LocalTransparencyModifier = 0 end
                end
            end
            return
        end
        clearReplica(tool)
        hideOriginal(tool)
        local m = Instance.new("Model")
        m.Name = "RivalMedusaReplica"
        m:SetAttribute("SkinKey", key)
        local p = Instance.new("Part")
        p.Name = "MainPart"
        p.CanCollide = false; p.CanQuery = false; p.CanTouch = false
        p.Massless = true; p.Anchored = false
        p.Size = Vector3.new(1, 1, 1)
        p.Transparency = 0
        p.Parent = m
        local mesh = Instance.new("SpecialMesh")
        mesh.MeshType = Enum.MeshType.FileMesh
        mesh.MeshId = data.mesh
        mesh.TextureId = data.tex
        mesh.Scale = data.scale
        mesh.Parent = p
        local w = Instance.new("Motor6D")
        w.Part0 = handle
        w.Part1 = p
        w.C0 = data.c0
        w.Parent = p
        m.Parent = handle
    end

    function _G.RivalApplyMedusaSkin()
        local sk = _G.RivalMedusaSkin or "Default"
        local containers = {}
        if LP.Character then table.insert(containers, LP.Character) end
        local bp = LP:FindFirstChildOfClass("Backpack")
        if bp then table.insert(containers, bp) end
        for _, container in ipairs(containers) do
            for _, tool in ipairs(container:GetChildren()) do
                if isMedusaTool(tool) then
                    if sk == "Default" then
                        clearReplica(tool)
                    else
                        buildReplica(tool, sk)
                    end
                end
            end
        end
    end

    function _G.RivalSetMedusaSkin(choice)
        if choice ~= "Default" and not _G.RivalMedusaSkinAssets[choice] then choice = "Default" end
        _G.RivalMedusaSkin = choice
        pcall(_G.RivalApplyMedusaSkin)
        if _G.ShelMedusaSkin and _G.ShelMedusaSkin.apply then
            pcall(_G.ShelMedusaSkin.apply)   -- quita / pone la bomba (Default)
        end
        if choice ~= "Default" then pcall(_G.RivalApplyMedusaSkin) end
    end

    -- reaplicar cuando aparece/equipa la medusa o respawnea el personaje
    task.spawn(function()
        while true do
            if (_G.RivalMedusaSkin or "Default") ~= "Default" then
                pcall(_G.RivalApplyMedusaSkin)
            end
            task.wait(0.6)
        end
    end)
    LP.CharacterAdded:Connect(function()
        task.wait(0.8)
        pcall(_G.RivalApplyMedusaSkin)
    end)
end
-- ===== FIN MEDUSA SKINS =====

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
--  paintFloatingBtn
--=========================================================
function paintFloatingBtn(btnFrame, active)
    if not btnFrame then return end
    local bg     = btnFrame:FindFirstChild("BtnGrad")
    local label  = btnFrame:FindFirstChild("TextLabel")
    local stroke = btnFrame:FindFirstChildOfClass("UIStroke")

    -- ORANGE ECLIPSE (estado ACTIVO) - mismo color que el boton CARRY SPEED
    local ECLIPSE_CORONA = Color3.fromRGB(255, 240, 200)
    local ECLIPSE_SUN    = Color3.fromRGB(255, 190, 70)
    local ECLIPSE_RING   = Color3.fromRGB(255, 150, 40)
    local ECLIPSE_AMBER  = Color3.fromRGB(230, 110, 20)
    local ECLIPSE_SHADOW = Color3.fromRGB(60, 30, 5)
    local ECLIPSE_DEEP   = Color3.fromRGB(15, 8, 0)
    local ECLIPSE_BORDER = Color3.fromRGB(255, 170, 50)

    local SILVER_BRIGHT_LIGHT = Color3.fromRGB(255, 255, 255)
    local SILVER_BRIGHT_MID   = Color3.fromRGB(225, 232, 242)
    local SILVER_BRIGHT_DARK  = Color3.fromRGB(180, 190, 205)
    local SILVER_BRIGHT_BORDER = Color3.fromRGB(255, 255, 255)

    if bg then
        bg.Rotation = 90
        if active then
            bg.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, ECLIPSE_CORONA),
                ColorSequenceKeypoint.new(0.18, ECLIPSE_SUN),
                ColorSequenceKeypoint.new(0.35, ECLIPSE_RING),
                ColorSequenceKeypoint.new(0.50, ECLIPSE_AMBER),
                ColorSequenceKeypoint.new(0.68, ECLIPSE_SHADOW),
                ColorSequenceKeypoint.new(0.85, ECLIPSE_DEEP),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0)),
            })
        else
            bg.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, SILVER_BRIGHT_LIGHT),
                ColorSequenceKeypoint.new(0.45, SILVER_BRIGHT_MID),
                ColorSequenceKeypoint.new(1.00, SILVER_BRIGHT_DARK),
            })
        end
    end

    btnFrame.BackgroundColor3 = active and ECLIPSE_AMBER or SILVER_BRIGHT_MID

    if label then
        label.Font = Enum.Font.GothamBlack
        if active then
            label.TextColor3 = Color3.fromRGB(255, 245, 220)
        else
            label.TextColor3 = Color3.fromRGB(35, 38, 48)
        end
        local ls = label:FindFirstChildOfClass("UIStroke")
        if not ls then
            ls = Instance.new("UIStroke", label)
        end
        if active then
            -- igual que Carry Speed: sin contorno en el texto
            ls.Thickness = 1.2
            ls.Color = ECLIPSE_DEEP
            ls.Transparency = 1
        else
            ls.Thickness = 1.2
            ls.Color = SILVER_BRIGHT_DARK
            ls.Transparency = 0.15
        end
    end

    if stroke then
        if active then
            stroke.Color        = ECLIPSE_BORDER
            stroke.Thickness    = 2
            stroke.Transparency = 0.05
        else
            stroke.Color        = SILVER_BRIGHT_BORDER
            stroke.Thickness    = 1.6
            stroke.Transparency = 0.05
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
    if _G.__RivalHubFloat and _G.__RivalHubFloat.running then pcall(_G.__RivalHubFloat.disable) end
    if _G.__RivalHubAutoCarryStop then pcall(_G.__RivalHubAutoCarryStop) end
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
        medusaSkin = _G.RivalMedusaSkin or "Default",
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
        floatKey = {kb = KB.Float.kb and KB.Float.kb.Name, gp = KB.Float.gp and KB.Float.gp.Name},
        bodyLockEnabled = bodyLockEnabled, bodyLockRange = bodyLockRange,
        autoCarryEnabled = autoCarryEnabled == true, autoCarryMode = autoCarryMode,
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
        batVersion = (_G.__RivalHubBatVersion == "v3") and "v3" or "v2",
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
    _G.__RivalHubBatVersion = (data.batVersion == "v3") and "v3" or "v2"
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
    if type(data.medusaSkin) == "string" and _G.RivalSetMedusaSkin then
        _G.RivalSetMedusaSkin(data.medusaSkin)
        if _G.RivalMedusaSkinRefreshUI then pcall(_G.RivalMedusaSkinRefreshUI) end
    end
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
    lk(KB.Float, data.floatKey)
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
    if data.autoCarryEnabled ~= nil then autoCarryEnabled = data.autoCarryEnabled == true end
    if data.autoCarryMode == "On Pick Up" or data.autoCarryMode == "Soft Steal" then autoCarryMode = data.autoCarryMode end
    if _G.__RivalHubAutoCarryRefresh then pcall(_G.__RivalHubAutoCarryRefresh) end
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

    backgroundIndex = _clamp(num(data.backgroundIndex, 1), 1, math.max(#backgroundImages, 1))
    backgroundImageTransparency = _clamp(num(data.backgroundImageTransparency, 0), 0, 1)

    if data.backgroundMode == "None" or #backgroundImages == 0 then
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

    floatingButtonScale = _clamp(num(data.floatingButtonScale, 1), 0.05, 1)

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
    if _G.__RivalHubFloat and _G.__RivalHubFloat.running then _G.__RivalHubFloat.disable() end
    safeSet(_G.__RivalHubFloatSetVisual, false)
    safeSet(mobSetFloat, false)
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
        _G.__RivalHubBatVersion = "v2"
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
        autoCarryEnabled = false; autoCarryMode = "On Pick Up"
        if _G.__RivalHubAutoCarryRestore then pcall(_G.__RivalHubAutoCarryRestore) end
        if _G.__RivalHubAutoCarryRefresh then pcall(_G.__RivalHubAutoCarryRefresh) end
        backgroundIndex = 1; backgroundImageTransparency = 0; backgroundMode = "Background 1"
        floatingButtonScale = 1
        currentAnimPack = "Off"; stopAnimPack()
        currentOutfitIndex = 1
        pcall(VX7A.stop)
        currentColorTheme = "Gray"; selectedColor = COLOR_THEMES["Gray"]
        currentRivalTitleTheme = "White"
        applyRivalTitleTheme("White")
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
    local BTN_W, BTN_H = 80, 48
    local GAP = 8
    local orderMap = { DropBR = 0, AutoLeft = 1, AutoBat = 2, AutoRight = 3, TpDown = 4, Carry = 5, Lagger1 = 6, Lagger2 = 7, BatV2 = 8, Float = 9 }
    local order = orderMap[btnName] or 0
    local row = _floor(order / 2)
    local col = order % 2
    return col * (BTN_W + GAP), row * (BTN_H + GAP + 10)
end

--=========================================================
--  TP BAT motor
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

    scriptLogoRef = displayNameLbl
    pcall(applyRivalTitleTheme, currentRivalTitleTheme, true)

    local bgImage = Instance.new("ImageLabel", main)
    bgImage.Name = "BackgroundImage"
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.Position = UDim2.new(0, 0, 0, 0)
    bgImage.BackgroundTransparency = 1
    bgImage.Image = _bgAsset(backgroundImages[backgroundIndex])
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
        miniScale.Scale = 130 / 360
    end
    miniBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    miniBtn.BackgroundTransparency = 0
    miniBtn.BorderSizePixel = 0
    miniBtn.Text = ""
    miniBtn.AutoButtonColor = false
    miniBtn.ZIndex = 21
    miniBtn.Visible = false
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 28)

    -- Fuente Vabedo (embebida)
    local VABEDO_B64 = "AAEAAAAPAIAAAwBwRkZUTaS5O00AAFWEAAAAHEdERUYAKQCIAABQVAAAACZHUE9TNuVEZgAAUKwAAATYR1NVQrj/uP4AAFB8AAAAME9TLzKEYok2AAABeAAAAGBjbWFwzJGg2QAAA2AAAAFCZ2FzcP//AAMAAFBMAAAACGdseWbvAXEtAAAFbAAARyxoZWFkK6a/AgAAAPwAAAA2aGhlYQdCAvQAAAE0AAAAJGhtdHjL5gfzAAAB2AAAAYhsb2Nhhj91iAAABKQAAADGbWF4cAC5AYgAAAFYAAAAIG5hbWU1WPmSAABMmAAAAspwb3N0CXkJYwAAT2QAAADmAAEAAAABAADvVy5PXw889QALBAAAAAAA5HW9uAAAAADkdr4X/+j+7gOzA0gAAAAIAAIAAAAAAAAAAQAAA0j+7gBcA6v/6P/4A7MAAQAAAAAAAAAAAAAAAAAAAGIAAQAAAGIBSgARADoAAgACAAAAAQABAAAAQAAAAAIAAQAEAhkBkAAFAAACmQLMAAAAjwKZAswAAAHrADMBCQAAAgAFAwAAAAAAAAAAAAEAAAAAAAAAAAAAAAB3ZXAgAIAAIAB+AwD/AABcA0gBEgAAAAEAAAAAAgMC4gAAACAAAgMTACwAAAAAAVUAAAEeAAABKAAiAigAKgOrAAwCFgAIAtb/+QKwAA8BHgAqAR4AFwEeAAAB+QAjAkMAKAFqACcCJAAqARoAKgHjAAYCLAAfATkAEwIp//sCKP/9ArEAEwIiABYCMAAXAiD/9gJbABcCjgAJARoAKgFqACcB1gAGAdsAEgHUAA4B5QAWAxUACwJRAAYCnAAbAiAACgKdABoCRwAhAfsAIAJnAAICrAAeASgAIgHmAAACjwAaAjcAJQNZAAwCqAAOAksADQJrABwCwwAIAmIAFAISAA4CLv/9Aq4AEAJoAAoDHgAJAloAAwJgAAUCRgANAR0AGwHjAAYBHf/6AjoAJwIkACoBXf/9AtMAGgK3ACUB8gAaAqsAGgIhABwBeQAhAowAGQJyABsBLAAhATn/6AJTACcBJAAdAzYAIgJIACYCPwAgAp0AIAK8ABkCLgAlAgYAFwGpAB8CcQAgAjQAGwLLAB4CGQAUAkcAFwISABQBLQATAPsAJQEuAAMCGgAoAAAAAwAAAAMAAAAcAAEAAAAAADwAAwABAAAAHAAEACAAAAAEAAQAAQAAAH7//wAAACD////jAAEAAAAAAAABBgAAAQAAAAAAAAABAgAAAAIAAAAAAAAAAAAAAAAAAAABAAADBAUGBwgJCgsMDQ4PEBESExQVFhcYGRobHB0eHyAhIiMkJSYnKCkqKywtLi8wMTIzNDU2Nzg5Ojs8PT4/QEFCQ0RFRkdISUpLTE1OT1BRUlNUVVZXWFlaW1xdXl9gYQAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAABtgG2AbYBtgICAg4C2gNuBDAE0AUABTwFdAYUBmgGnAbGBuwHJgd4B64IGAiACOoJbgnMChIKfArkCvAK/AtCC5IL1gwyDOINUA3ADg4OaA7kDzIPnhAQEEYQkhESEWIR8hJkEqwTCBNuE+gUUhScFQwVXhX0FnYW0BdEF4gXwhgGGGQYkBjGGSQZlBncGkgaphsGG3wb6Bw4HJAdBh1AHbgeHB5qHtAfKB9yH9QgLCCGIOIhRiGwIhQiaCLAIvojVCOWAAAAEQAs/yAC5wLgAAMABwASADUAQgBNAGYAdQCAAKEAugDbAQMBGgEkAT0BSQAAEyEVIREhFSE2IgYVFBYzMjY1NCUyFjMyNTQjIgcGIyInJiMiBhQXHgEzMjc2MzIWFxYzMjc2JyIVFBYzMjY1NCcuAQcyFhUUBiMiNTQ2JjQmIyIGBwYVFBYzMjY1NCcmJyY1NDYzMic0NjMyFhcWFRQGIyInJjc0JiMiBhUUMzI2FyIuATU0NzY3NjMyHgUXFh0BFAcGIyInJiMiFRQ3FAYjIiYnJjU0NzYzMhcWFxYUBwYVFBcWJRQWFRQHBiMiJicuATQ3PgE3NjMyFhQHBhUUMzIVFAcGEzIWMzI3NjMyFhUUBw4EIyImIyIGIyInLgE1NDYyFhcWMzI3NiUyNjMyFhcWFRQHBhUUBiIvATQ2PwE2FjQmIyIGFBYzMgcUBiMiJicmNTQ2NzYzMhYVFAcGFRQWMzInNCYjIgYVFBYzMjYsArv9RQK7/UXGEA4MCAkOAX8GCwcYIgkMDCAZBwgDCxECAwsNBQQEDAYGAwQMDwcGxi0fGxkhBgYnBgkMDQgUCj8OChApCAoeGw8aGA4LCBYMCowfIBo1CQgvISQUF24QDA0RHgoSbRARBAIGNh4TCA0IBgQCAgEBDwgEDgMDFhnsIBMVIAMKFw0EDQkFFBESHCEa/fcEDAwJBhQDAg4FBg4QEgENGhYZHRINDCYHFAYMAwMOCA0BAQMDCBAMByYKBhkECw0LHxMWCgMGEQYGCAFWDC8PFBYLCksrFRQNDQIBDg1jGAsNFxAMC3wbEhY7CwcmHg0OFyAtGQkTJCARCAoUDwgLFQLgVf196HAQCQcMDwkHBy02QgcGAwIWGgsaFBUaCxIcGhZLOx4sJB0TDRAUKREKCxQbCxQNEg0XDA4KHiUPCwoDAQkIAQoO/CQtHBUVFyYzGx8fDRgbDyYcNx4oIRoIFgoGBg0MFg0aBQYKDSIHBCcwNCcYDhwcF1oJOBQLIBUJCRQJDxcbCgctBysFFQsKEwkGXxocJBwIBxgWCAkTFQoHEBABSCgxLR0UCgUMKhQaCgcCDQtZFQ0VDhU2DhY1DRQcHBM3Gg8YCRILCx18HQwNUxQUFBwQIw4RJxcODx05DQYeFygYDgoIA1cIDxYJBw0SAAAAAgAiABEBCALkAB0AMQAAEzYzMhcWFxYVFAcGBwYHBiMiJyYnJjU0NzY3Njc2AzY7ARYXFhUUBiMiJyYnJicmNTR2DRwWDC4TBgcSGxM7GgIfDhIEBQUFDQcUDhAQFgwrGBQ0JA8NDg8RBAIC3QcFE00XLzQkXTImCAIREiQqX0wlIxwPFA79wQYBEA0dIC4FBRATDggKKP//ACoBmgH/AvUQJwAKAQoAABAGAAoAAAACAAz/+QOzAqEAigCTAAABNjMyFxYdATAVFBYzMjc2NzY3Njc2MzIXFh0BDgEVFB4DFxYXFhcVFAcGBwYHBhUUFxYXFhcUFhUUBwYHDgIHBgcGIyInJicmNTQjIgcOASMiJyYnJjU0NjU0LgUvASY1NDc2NzY3Njc2MzY1NCYvASY1NDc+ATc2NzYzMj4CNzY3NgMUMzI2NTQiBgH0CBAUDhgpGBsLGQsKFRgKCBEUDhcBAgIHCBMKCgoPAQkSJCdIMSAKCg8BAQsSJAo7LgsqIR4fFxERCAQdFCEsPCAXEQ8JBAUBBQQLChMJByYMBwoJGxYTFCpKGBEHJgsFGBgWExQrFyMOFgQKFRgrFxYvLDACnQQIEC0IAhIaEScMDRATAwQIDy4ICRgDBQYGBAsGBwsUFAYWDRsMDQQDIB0WBwsUFAEFARIQGwwDCg8PORoYDQwYCRJKKzswDQsZCRIVJwEDBAQEBgUKBQQXHg4TCwgHCggCAgEqECMJBRcdEBEJEgkIAgIQDiIEDRAS/rkVIRMQHQAAAAABAAj/pgIGAwIAZgAAEzYzMhcWFx4EFxYXFhcVFBcVFAcGBwYHBhUUFxYXFhcWFRQHBgcGBw4CBwYHBiMiJyYnLgQnJicmNTQ3NjMyFxYXFjMyNzY1NCcmJyYnJicmNTQ3Njc+Azc2NzY3NvEIEhAGHgwBAgIECAguIx8FARwbQR8PI147KyILBAgOJiQmHBsTCQ4kCQkTCQwDAgIDCBIPJSMgBQgQDSkfDwsJHRIUCA5LKx0YGRwdGToJHwwOAwMKBQwIAv4EAwspBQ0GBgQCChsYJAQBAwIfERAIAwkSGSonFyAZIgkXIBUiIyEOCyI3DhQEAQkKFAsgDxQNBQwoJCEMCA0SDgMDDxEUEA0TJRQYFCUsKSsoIiIFDQcWERATCgkGAAAAAAX/+f/JAswC7wAUAC8AVABnAIQAABMmIyIHBhUUFxYzMjc2NzY3NTQnJic2MzIXFhcWFRQHBgcGBwYHBiMiJicmNTQ3NgU2MzIXFh0BBgcGBwYHBgcGIyInJicmNTQ3Njc2NzY3Njc2NzYTJiIHBgcGFRQXFjMyNzY3NjU0JzYzMhcWFxYXFhUUBw4BIyInJicmJyY1NDc2NzadDQkjEggIERoQDBEGBQIICTAMEB4dIhYWCAUlJBIOFBAVJkIJAjgcAWoIERQOFwM/IURAIyohHh8WERIIBD8jDSUbVB0aCgsTGJkPKBASBgIQDxkMCBMGEFYVBwYXMiUpDAQBBWQ+EAQmJycKBRkWEhECrQUlExIVDhkJCwwLGQwRDg1EAwwQHR4eEw4LMzEUEAwKQjASBU47H0QECA8uCCxdL4mBLjkaGA0NFwkSK2c3IE0lbSonDA8OEv4VDxASGxICHRMSBAkIFiIjhgQECSMnLxATDQRDXgEEHh0hEgwUTkIXFQAAAAADAA//zwKmAvcAFAApAHEAACUmIyIHBh0BFhcWMzI3Njc2NTQnJhMmIyIHBgcGFRQXFhczMjc2NTQnJic2MzIXFhcWFxYXFhUUBhQXFjMyNzYzMhcWFxUUBwYdARcHBgcGKwIiBwYjIicmJyYnJjU0NzY3Njc2NzY1NCcmJyY1NDc2AV0MDh8XFgMlEgwcExQHAgwNDQ8GCw8YEhESEx8HOhEFDg5nDyEsFg8iKB4hCQdAHQYHDSgWBwkODAILDAELCxUTKSUbMCtSGhAUSkA9FxEDBw8QIiwICQwNAQExMfsFGhklCDEQCBMUIhABFxUXAXoFBwogHyIlFRcBPRYNIRobjgQHBA8RKi4sIA8mbEQLAg4ICwscCBIxMx4mRw8PCgkFDAMJHx4rHSURECEZGiEsEBQYHC0sGAQQSjo6AAEAKgGaAPUC9QAcAAATNjMyFxYXFhQHBgcGBwYjIicmJyY1NDc2NzY3NnQMGBUIKhEFBhEXEjMMDRoMEAUEBAULBxESAu8GBA87D04dSCcdBgENDxsYUEMVHRQLDg8AAAEAF/+jAR4DBQAlAAATNjMyFxYVFAcGFRQXFhcWFxYXFhUUBwYjIicmJyY1NDc2NzY3NqgSDCIPCSEpAgUODR8dBQUaGCYoIDAbHAYFEQkYJAL9CCMQIihnfEkDJi0tKTw6FBETJx0bIC1bXWcxLixNKlx3AAAAAAEAAP+jAQcDBQAjAAAXBiMiJyY1NDc2NTQnJicmJyYnJjU0NjMyFx4BFRQHBgcGBwZ2EgwiDwkgKQIGDA0fHQUFMiYoIDE2BgMVFgkkVQgjECIrZHxJAyYyKCk8OhQREyc4IC60ajEuGl9jI3cAAAABACMBRAHXAvIAcQAAEzYyFxYXFhUUMzI2NzYzMhceARcWFxYdAQYHBgcGFRQeARcWFzAVFAcGBwYHBgcGIyInJicmIyIOAgcGBwYHIgYjIicmJyYnJjU0NzY3NjU0LgMnJicmJyY9ATQ3Njc2OwEyFxYzMjc2NzY3Njc29AggBh8KBAkDFQkFCwYOByAEBwQEAiQNFiUFCQQKAQMDBgQPCwcKBBcaChAWBQIFBQoFDhAGEwEGAgcICBAMAwkHBg0UAgYGDgYPDgkEBgQFBBImBwcdHgQHBAEBAwkFCwgC7gQDCyoQFigGAQECARQFCQ0LCQIfFwkHDAcDCA4HFA4FCAsQCAcKCAICFAcVHQQGCwUNCAMCAQIBCwkGDRMQERARHAQCAwQCBgMIDwwIDgsDCwwNBRcJChsIBRMPCQoHAAEAKABsAhwCPgA1AAABNjMWFxYXFhcWFxYXFhcWFRQHBgcOAQcGBwYjIicmJyYnJicmJyYnJjU0NzYzMjc2NzY1NDYBHgYWGgwMBAUTChAWISQPEA0OERZOFhgPFiYpCgcTDQ0SIh0SDwsHKQwuJAcIEC4SAjwCAg8OJDAWDAYJBggQEh8aGB0KDQgQESEvMS0UDwQGBAQJBxUNDi8UBgEBCRlTFSIAAAEAJ/98AUIBBQAhAAA3JjU0NzYzMhcWFRQHBgcGBwYjIicmNTQ3NjU0JyYnJicmLAUvLTkzKCsGByEjDh4eDw4JBgUdBQ8aBAt1DAkoKikoKzoKHh1BRQ8iCwkRDxkZDzEaBQsTAwgAAQAqAN0B+wGbABkAAAEWFRQHBgcGIyIuAScuAScmNTQ3NjMyNjMyAe0OCwsUI0UmWGwKHR4JByYKLBmsLVsBfBEgGhgaDRUKEwEFEBQQCy8UBhMAAQAqAAkA8QDMABYAADc2MzIXFhUUBw4BBwYjIicmJyY1NDc2cgkVHQ03BAckFRIYGw0WDg0XFcgEBx08EAsWJAgGBwsWFBscIh4AAAEABv/5Ad0CoQAjAAABNjMyFxYdAQYHBgcGBw4BIyInJicmNTQ3Njc2NzY3Njc2NzYBiwgRFA4XAz8hREAjLDwgFxERCAQ/Iw0lG1QdGgoLExgCnQQIDy4ILF0viYEuOzANDBgJEitnNyBNJW0qJwwPDhIAAgAf/+ECEgLTABUANAAAASYnJiMiBwYHBhUUFxYzMjc2NTQnJgM2MzIXHgEXFhUUBwYHBgcGIyInJicmNTQ3Njc2NzYBSAkIBg8YDxMKFQ8QGyoZGgIE2zJJHSFEdBcLBQ8rLTE4PE4/PRIGCgoQCxASAakJBAMMDxMnLCMVFykrLQUSFwEQKwkVilQsPiIlW05SIihBPWwlOVVRUywaGRsAAAABABP/2QEZAsQAIQAAEzYzMhcWFRQHBhUUFxYUBwYHBiMiJy4BJzQnJjU0NzY3No8NDzUcHRATDwkHCSEfIxURIhwBFA8fERoZAr8FJiUtIEBJOjNnRUYVIxoZCRNeYY9TPhsrQSYbGwAAAAAB//v/1gIsAvQASgAAEzYzMhcWFxYXFhUUBwYdARYXFhcWFxYXFRQHBgcwIyIGIyInJicmJyY1NDc2NzY3Njc2NTQjIgcGKwEiIycmJyY1NzQ9ATY3Njc24A8bRDkfGxkOESEkAw4OHiMMCgIeIDAEAQUBImBNMTUeHBASLTIQEwQBKRAoJQ0GAgICJRgWAQQfHiY6AvAEGxAfHSYxLkRQVB4GFhMUFBkRDx0IMR4gBwELCQoNHhwoIh0hNDseIxwDDTYODQEEGBYkAwICBhwwLh0rAAH//f/WAicC2wBIAAABNjsBFhcWFRQHBhUUFxYVFAcGBwYjIicmNTQ3NjIXFjMyNzY3NjU0JyYnJicmJyY1NDc2NzY3NjU0JiMiBwYjIjU0NzY3Njc2AUEYERMpDjQcGjBFIzRQGTs9KKoVCRQqLQ0LChcPDhMaQSUOCgwQEgkeKxMSJCEOGRYTLD4iZCgXKQLZAgEIGU00PDoaJD9aRzQ1UBAFBRZLHAkEBgYCBA8OERYQFwoGBQQMEhgaEgkOExQTGxkeBQUrLSsXNRIIDQABABP/7gK0Au0ARwAAATYzMhcWFRQHBgcGBwYVFBcWMzI3Njc2NzY3NjMyFxYXFhcWFRQHBgcGBwYHBiMiJyYnJicmIyIHBiMiJyY1NDc2NzY3Njc2AWwWBigZGQkHIUQ6Ex0PGhAPGQ4GCxIVFhceIR0WHwcLAwowMyEaExAYEhAPIB8WGCAXKxQcWSQOCRR0KBQ5Ex0C5wYeHSwaEg4mTIEqICQRCQUKGgsyTBkWIh8fKxAbGgwLIScpLiQODAoJHx4LCwcEPBcfEyBDsDwlZRQhAAEAFv/fAhwC8wBbAAABNjMyFxYXMBUUFxUUBwYHBgcGBwYVFBcWFxYzMjc2MzIXFhcWFxYXFhUUBwYHBgcGIyInLgE1NDcyNjc2Nz4BNzY3NjU0JyYnIyIjJyIHBiMiJyYnJjU0NzY3NgEwFSVFFU8IASQMMkwnJg0PAwsjAQ4VFxkMCRQYEBIMCgECCRtIOT9FLgUSJzIxAQkHGAoHGANVFxMPDRsDAQICFT01FhUQGA0ICBU9QALwAwcWPQYBAgIrEgYJDg8OExUUCQkfBgEDAwUIERQdGAsQIDUYTDYpFxkCBzgcLQwDAQQCAgQBEBcTFhMPDQUBCggKEC8dXF4eTygqAAAAAAIAFwACAicC/gARAD0AAAEmIyIHBhUUFxYXFjMyNzY1NAM2MzIXFhQHBhUUFxYXFhcWFxYVFAcGBwYHBiMiJyYnJic1NDc2NzY3Njc2AUoUICcbHRIQHgsKGBgoUQ0NIxYLDQsIBw8QIUgaHRETLj9oEBVwOR4TFwEZDB8XFRMdLwFEFB0dKBwZFggDEhs3KQHOAxkLLCojGRYQEA0OEikiJjgnRlAuPw4CQiU2QS0ROEEjWEcoJB0vAAAAAf/2/+oCHwMDACwAABM2NzYzHgEXFhUUBwYHBgcGBw4BBwYHIyInJjU0NzY3NjU0JyYnJicmNTQ3Np1IKjpNMCYUHwsLHUYfFggGEhoOHAlBFwUBAyMTGhdLORwaISEC4BcFBwIKEx0/ISEgMHReQlhINhQMAkoWFRsJX3NCHiUYFQsHFBIiIxweAAADABf/rQJGAuwADgAdAEkAACUmIyIHBhUUFjMyNzY1NAMmIyIHBhUUFjMyNzY1NDc2MzIXHgEXFhcVFAcGFRQXFhcWFRQHBgciJyY1NDc2NTQnJjU0NzY3Njc2AUsMEhUKJiQaEQ0pIxMPHR4lLB8gGCYZBg0nHhIoDAgCGhYfFwYIWmiCZDo8CAcRDwoSLC5dW9sGBxYwHCQHEzIrAXwIGyEnIyoVIDAxtQIKByQXDycOJUA0HR9BLBcgFWhUYwI6PGYgNiQpMTwwJikVJyIiJSQAAAIACf/SAnADBwAPAEYAAAEmIyIHBhUUFxYXMzI2NTQDNjMyFxYXFhcWFxYVFAcGBwYHBgcGIyInJicmNTQ3Njc2OwIyNzY1NCcmJyYnLgE1NDc2NzYBbRYPKB4eFRQiCCg0qwwYNhgvaCkXGQ4YDwwKESgmP2c6IQ0YDg8BBQsNHw4aGRIlFhg7TTcwOAINQD8CFAkbHiYdGBgBOicwAQMDCg9DHB0fK0pBKXBWJjwoJhAcBwwVFhYHAhEEBQgQJBwPEAwPGxhsPhUQalVVAP//ACoACQDxAnAQJwARAAABpBAGABEAAP//ACf/fAFCAnAQJwARAAABpBAGAA8AAAABAAYAPwHIAjoALQAAATY7ARYXFhUwFQYdAQYHBgcGBwYVFBcWFxYVFAcGIyInJicmJyYnJjU0NzY3NgFFFRUKHw4eAQMZFzYmEBUDCkJqBxhIKz8dTj0YFg8MCxZRpgIyCAELFiQCAQIGIRwaDAgQFRUKCiEZKj0QDTMmEigfExIfGhwZGDArXgAAAAIAEgCMAc8CHAAeADUAABM2MzIXFhcWFRQHDgEjIicmIyIPASInIyY1NDc2NzYHMjc2OwEyFxYXFhUUBwYHBiMiJyY1NMweOkYeIxETCA4qNSsPEEA9DTwKBQghDBExLkcBm4ccAgcLBQsGDCTDIAJEJxgCFAgLCxQWGxIQGxIBAQECAQQiDxMbGRjvBQQHAwsHDRUQMRMCKhsZJwAAAAABAA4APwHQAjoALQAANwYrASYnJjUwNTQ1NzY3Njc2NzY1NCcmJyY1NDc2MzIXFhcWFxYXFhUUBwYHBpEXEwoeDx4BAxkXNiYQFQMKQmoIGEcrPxFaOhoYDgwLFlGmSAkBDBYkBQIBAiIcGgwIEBUVCgohGSo8EA4yJgovHRUUHRocGhguLF4AAgAWABgB1gMTAC0APgAAEzYzMhcWFxYVFAcGBwYHBgcGIyI1NDc2NzY9ASYnJiMiBwYHBiMiJyY9ATY3NhM2MzIXFhUUBwYjIicmNDc22hYZMyVQHQgBAgkFJRgZHDE/LxgLCQIPEBgXFR0dKRwSEiAGSTxWDBAqGh8JGUYwFwwLEQMOBQwYTBY4LAgOFw9HLyIlLSMyGxIPEQgYDg4MERomDBM0CkVGOf2zAw4PJBQTNR8POhEaAAIAC/8ZAwQChQARAHwAAAEmIyIHBhUUFxYzMjc2NzY1NAM2OwEWFxYXFhUUBwYHBiMiJyIuAiMnJicmLwEmKwEiBiMiJyY1NDc2NzY3Njc2MzIXFhUUBwYVFBcWMzI3Njc2NTQnJiMiBwYHBhUUFxYXFhcWFxYVFAcGBwYjIicmJyYnJicmPQE2NzYBlgoREgoMCwoSCwcOBQM6EzclUCRrLSFjNy0DCBwlAQYGBAEDAgIFAggGAgkPQhMhHSUCBBEOFyo4FRojEh4HBwULEg8RJQkBUBsiP0aPOhM9RoJEFRoJBhUWIBUkIxsdJicZPitUBEBkAQcJCgwRDw0MBAcJBwoWAYUEAgogYUVHioJHBwElBgYGAgICBQEEBB4gKDIEEhkhHBcqEAYJECcZIiMVEAoUDiRtBRV1JgshRJAzJEVGUxMLCQsUDQ0bFRYKBgYHEhMUMT9/kBVxZJcAAAACAAb/wwJQAvMAFQBJAAABJiMiBwYVFBcWMzI3Njc2NTQnJicmAzYzMhcWFxYXFhcWFRQHBiMwIyInIy4BJyYnJiMiBwYHBiMiJicmNTQ3Njc2NzY3PgE3NgFMEg4mFgoKGCgaFw4DBAQEDA4sDRciGi4bHA0TJB8eGicFAgICICgXFRUVHiQ5JRIcGSAyBwIcJhAOCwYLDUQcGwHPCCUPJCIXNhoODxEbHBAMDxIBIwQNF0ZIhL1mWBwrHhoBAyQwLhESMB0JDSggEAMkSGMzLz4rJytuFBUAAAAAAwAb/8sCjwMIAA8AIQBNAAAlJiMiBwYVFBcWMzI3NjU0AyYjIgcGFRQXFjMyNzY1NCcmJzYzMhcWFxYVFAcGFRQXHgIVFAcGBwYHBiMiJyY1NDc2NzY1NCcmNTQ3NgF4EBMlFg8dERoRCisaDxkTDisXFh4vEwkBA5YlIlo/QBUFJxMmHCIkCBdOTrFVKEoiHxAPAgENBC03+wkiFhYnFAsFFjIrAV8MCBk7JBUVKxAPCwMu0wYqK0QXBildLQUPGRMeQigXI1YsKxoLJR86KWZhJgYVIm4oFEUtNQAAAAABAAr/0AIQAuwANAAAEzYzMhcWFxYVFAcGIyInJiMiBwYVFBcWMzI3NjMyFxYdAQYHBgcGIyInJicmJyY1NDc2Nzb9Hg4/NDQXChwXKxMHBhREGxYwHDEaCQseGQk7BCsqSBwxJRFPOzkXCAgXQ0EC5gYnJz8eFSkZFAEBKiQvUioYAQEEEz8JMCgnFAcFF0hGayY7OCp5WlgAAAACABr/mgKXAvQAEwA7AAABJiMiBwYVFBcWOwE+ATc2NTQnJgM2MzIXFhcWFxYVFAcGBwYHBgcGByInJicmNTQ3NjU0JyY1NDc2NzYBfxYWOxMWChk2CSxGCgUGEc8QEkFYXSEgKSkFCyUqQVAuMGNQJyYTDAYKEw0cGzIwAdgLREldORAwBEw4IQsSHFgBNwMvMiYmam45FhY+OUBBTxMUAg4OJRg1JjtQNjhmQTA7KSkeHQABACH/2wI3AwcAVgAAATYyFxYVFAcGBwYHBgcGFRQXFjMyNzYzMhcWFRQHBgcGBwYHBhUUFxYzMjcyNjM3MhcWFRQHBgcGBwYHBgcGIyInJic0Jj0BNDc2NTQnJjU0NzY3Njc2AVEZQhd0IBIRDzCLGQUHDTIUHhYdEwQPHg8iMBQWBAEZDioWNQgOAwQMECEkFRcWMl8IC0kYBD0pKgQBFQsQDgoTPCc+RAMEAwMQUDMgEgYFAgg7DwcNDiAIBwQMGicWDAsPDg8SAggaDggEAQEIEScpJBUJCQYMBgkLAiUlOwEFAggWczctME5GJSIULxwTEhMAAAEAIAAtAfQDBAAzAAATNjMyFxYXFhUUBwYHBgcGFRQXFhcWFRQHBgcGBwYHBgcGIyInJjU0NzY1NCcmNTQ3Njc28hgGYkglDQgNCxcMLW8QESJDEhMsKxAPCwkHFTYwJiYDBAcGBhZcNgMCAiYSGxAWGRoXCwUJEzgZCgoIDzAbFRYcGxcWMCYOLikmUBoiJDM/LjQsLhhTJRQAAAEAAv+/AlQC4QBJAAABNjMyFxYXFhUUBwYHBgcGBwYHBhUUFxYXFjMyNzQ+ATQ1NCcmJyY1NDc2NzY7ARYXFhcWFRQHBgcGBwYjIicmJyYnJjU0NzY3NgEEIC8tGTotKwoJEBMlT0hPGRkJCiEiKEsMAQEmEwYFCxEOR0UKGQMGCxwJCgUEChQxBwYarH1LTAIOUUQC2QgGDSsqLhgLCgUGAQUlKTAyOBkfJxYXOQIGBAMBGiURCwgMEQsLAw8CAQIKGjsiLzhHUBgvAgVDMmdpdgYgfVZHAAEAHv+wAoYC2ABOAAABNjMyFxYXFhUUBwYdARQHBgcGBwYjIicmJyYnJiMiBwYdARQeARUUBwYjIicmNTQ3NjU0JyY1NDc+ATMyFxYXFhcWFxYzMjc2NzY3Njc2AgAIEhgSKBIIBQYEBQwLDQwPMCotGRQdAwweFxwBAQkbSEQaDwIDCggECzYgEg0YExQRFBUWHRQTGgwMBgQJFQLUBAgTQB5NPDI+RyRqCw8PDgUFMDQTDwIBFBkxDxAfEAImFUA8IUUoNEYyVEM7JyIPLzYHCh8fOj4UFAoOGho0Khs4AAAAAAEAIgAOAQYC1QAjAAATNjMyFxYVFAcGFRQXFhUUBwYjIicmJyY1NDc2NTQnJjU0NzZtEBcYEEoMEwIIGBkoIR8eDQcHCAgLAw4CzQgIJJY7RmgyBiBAIC4aHBUVIhImLC41OTs1UiUVD00AAAEAAP+uAcYC5QAwAAABNjMyFxYXFhUUBwYVFAcGBwYHBgcGIyInLgEnJjU0NzY3Njc+ATc2NTQnJjU0Nz4BASkSDSkZLQ0CDgUFBA8MGhkgOTg1MBouDw8dH0AwChIiCAoLFgsIKgLgBRwufxIXI3M1VkglICAaGhkPGxgQMB0hGSwdHwMFAgQgFxouKj12KCMfFiwAAAAAAQAa/6cCggL1AFwAABM2MzIWFxYVFAcGFRQXFhcWMzI3Njc2NzY3NjMyFxYVFAcGBwYVFBcWFxYVFAcGBwYjIicmJyYjIgcGBwYdARQWFRYVFAcGBwYrASInNCY1MDU0NzY1NCcmNTQ3Nl4UFRswCwYHDQMFDg8TGREWCgsRDiE4MCkYEjYdCAgLEjM+AgcVFBwKCCJLVyULDhEKCQECAQEJHEIDWAkBDAQYDyALAuwJIBoNHhspQh0OCRcLDBQZNjUmHyE4IhogNUUmEBEiIRkmOEQyAhIiFxYCCEdSBggSERMJAwcBOhwmBgcSN3wBBwIKHbswEDV6Sys8IQ8AAAEAJf+9AjgC4QA3AAATNjMwMzIWMxYXFhUUBwYVFBcWMzI3NjIXFhUUBwYHBgcGBwYjMCciKwEmJyY1NDc2NTQnJjQ3NmwTDQYCBQEdED4LEg4ZQxkeJTgYOh0THCJDPjNhDQMDAghUFwUHBwgJCRIC1woBAg0ugTJCXycoGjQGBgscQisdEwgJBgQMFgEDUBQ1R0I/QD02PWoWLgAAAAABAAz/vwNSAtkAZgAAATYzMhcWFRQHBhUUFxYXFhUUBwYHBiMiJyY1NDcwNzQnJiMiBwYHDgEHBisBJiMwIyYnJicuAScmIyIHBhUUFxYVFAcGBwYjIicmNTQ3Njc2NzY3Njc2MzIXFhcWFxYzMjc2NzY3NgJ7GBc5GxgFBAoJGBoFCxkaGiciMgQCGA0RIhEJCg0gGRYJAgIBBh4ODgQEEBQKExkPGAEDBgcPISwZFjEVHgUHBAUKCh4dHBMTNDcVFhMXGBYWGycXHALOCzgzXi8/MDQwLSk9QCQPDxoQEB0uWSEVFioTCh0PIi4sDAoBAxYVMzQqDQcPGCwXCCoYHg8RDyQMHEIlVnUfLktQJSMbGgkYWiUSEBQVMkYbIQABAA7/2wKOAvgAUAAAATYzMhcWFRQHBhUUFxYXFhUUBwYjIicmJyYnJicmIyIHBhUUFxYVFAcGIyImNTQ3Njc2NzY9Ajc2MzIXFhcWFxYXFhcWMzI3NjU0JjU0NzYB5RMVOx0OBQYVDgIBSxYiIxQTFxM0MREpHwYKHAwNFh0qJzQBAxQcBAUKHjgqKhgKCRIQDAsWDQ0REBUeBQ4C7gpDHi8TSUwJK4ZdGwUTaScLCwsXE0lFIksEDCQYKSkQFRkdOCsNBA9OaxogTRNyFkIqGRgVR0MXFgsHDhIiGnIsFRQzAAACAA0AAgI7AuQAEAAtAAABJiMiBwYVFBczMjc2NzY1NAM2MzIXFhcWFxYVFAcGBwYHIyInJicmNTQ3Njc2AYscNhwbK0wGIhweDQeyFgQ1PTswKBYfAg1NTG0OVkghEjoJI10pAcg4GStWbgYcHjEVFScBNAIbGjAqLkRZBCaTY2IGSCEofJk+JHo+GQAAAAACABz/3wJaAugAEAA8AAABJiMiBwYVFBcWMzI3NjU0Jic2MzIXFhcWFxYVFAcGBwYHBgcGBwYHBgcGIyInJicmNTQ3NjU0JyY1NDc2AVESDBsaISsTFiQbGh7SGjMuFVRFRiQtGBgsLkk6HBkOCwMFGBgrFxgtDgYICBAQGyECKgUXHCo3FQobGiceLMAGBAsjJDA6RzUxMh4iEw8QDhsUOU0aGwsXLhUaE0A9QklZVjI0ISUAAAAAAgAI/4gCuQLCABoARAAAASYjIgcGBwYHBhUUFxYXFjMyNz4BNTQnJicmJTYzMhcWFxYXFh0BBgcGFRQXFhUUBgcGIyInJiMiBwYjIicmJyY1NDc2AZMYJBcPLBsbCwUFDiYnNSMgKjgGCh4a/udQYyAwXzEvLTIDHiIXFyAYCQgWJzQrGCQwNhcQLj2DJScB2QsFECMkNBYKCxZEJSYQFGQwFhQcJiGsTQoVKCZeaHEPMCcpIhYzMRgdLAcDIS0MEAMJOn2xW1NYAAAAAgAU/7ICQgL/ABUAVAAAASYjIgcGBwYVFBcWFxYzMjc2NTQnJic2MzIXFhcWFRQHBgcGFRQXFhcWFxUUBwYjIicmIyIHBgcGBwYHIgYrASInJicmNTQ3NjU0JyYnJjU0NzY3NgFOEhAfGhsJBCEMBgoUIhArExE+IgVZQDEdHQ4OIxssGAcHAhkYLRYyOhAJCRwVGBgXGQEEAgYkHRYGBwUGBwEVEiYfMUcCHggUFR0PCicbCQECDB40HRUR4wIpHzM0NycoKTowHCc4IQ4QGwgtIB8ZHQMKHyIREQEBHRQXGjAbREQnQiwDZk8eMSUeExwAAAEADv++AgIC+ABIAAATNjMyFxYXFhcwFRYdARQHBgcGBwYVFBcWFxYXFhUUBwYHBgcGIyInJicmNTQ3NjMyFxYXFjMyNzY1NCcmJyYnJicmNTQ3Njc26RYvIxIyHSAEARscPx4PIlxHHiALBAgPJCMlMVBCKykeHwUIEBEkHRAKChsUEggMSycfHBUbHBk4OgLxBwUOISUnAgICBigVFgkFChYgNTMmHiArDB0pGiwsKhEXEhIwMiUQCg8VEgUDFBIcEhIYLxggHSs5MzcyLCkqAAAAAf/9ACgCKQL/AC4AABM2NzYzMhcWFxYVFAcGBwYHDgEHBgcGBwYHBgcGIyInLgE0NzY1NCcmJyYnJjU0TUQ8OXZGCQwRQRISNCoXFAoFEwIFAgMPDQsMESEjDhQRIycNJnQLAgLMIAoJAQEJI0YlFBMRDRMSHCmtRmAGCRMQBAYaCyIiQoJBQBwJDzAuCgMuAAAAAAEAEP/wAo8C1ABOAAABNjMyFxYXFhUUBwYVFBcWFx4DFRYVFAcGIyciKwEmIyIHBiMiJyYnJicmJyY1NDc2NzY3NjMyFxYXFhUUBwYVFBcWFxYzMjc2NzY3NgIRCgcIDygTDQUIDgMDAQIBAQIsIigDAwIHMhYgRiomBBg+Li8TFxUGGAgUFg0VGBQNHhEUBgYYCgUGDjIvLAYEFRMC0gIECyQWLxI0RkBNSBURBgsHBQEaBEApHwEFGA8CCi8vRk6xPA5IMxAVFgYKBg0iKEonLSoZMhgLAQJHQ3RYLyoAAQAK/8gCVALNADcAABM2MzIXFhcWEhcWMzI3PgI3PgE3NjMyFxYVFAcGBwYHBgcGIyInJicuCScmJzU0RRMXKSIVGQwiBRMZFxAECggDDBofEhQzGRYmMw0TCw8TJ1NFKRYZBAYFBwMJAwwEEARABALDCiUaNRn+5gYVFQaEjw00MxEJJR8kMFl/LEFGXSxTQSZ2EhwWGA4YChwLJwmTMgxNAAABAAn/3QMJAvQAZAAAADYzMhcWFxYVFAcGBwYHFAcGBwYHBgcGIyInJicmJyYnLgEnJicmJyYjIgcGBwYHBisBJicmJyYnJicuAScmNTQ2MzIXFhcWFBcWMzI3Njc2NzY7ARYXFjMyNzY3Njc2NzY3NjcCpAIFEhYfEAcZGAMFBQQCAwcQDyUTFA8OCwsGDQQKAgcFEg0KEQ4VHg8QBgYNDCAIXRwJBQkPDSUEGQcJOC4dEDIWBggPJBgSFAcGCQsYBRwjDRgODAwICA8PBwkVDA0C8gIMDysPHCtXVhMfQAI7HyFlMC4SCggGCwYWBxcFEQwuFhINChQVMCwRDwVoJjBFODFOCTsSGxoxPgoeSBOODiQSFDMkExoIYiYNDhocU1EVGxEMBAAAAAABAAP/7gJGAvQAWQAANyInJj0BNjc2NTQnJicmJyY1NDc2NzY3NjMyFxYXFhcWFxYXFhcWMzI3Njc2NzY3Njc2MzIXFhcWFRQHBgcGFRQWHQEWFxYXFhcWFRQHBiMiJyYnLgEjIgcGmB0TEgMzGwIEEhQkVAQEEhARERkSERoXFxINBQkCBAwQFBgSEAUHCg8QDRgPEBkbFwsHQC4PDgEBDgwiIA0MHhwuJRYWEhEiGiEQFyEREB8JKFozIgISFSElMHQ0EQsQFRMGBwUJFRYdGB4qBgsMEBQQDRIqOh0ZCwYRDhoREDNyUSQiGAEGAgcZGxgoKBkZGikcGxESLS4iLj8AAAEABf/DAlYC5AA7AAATNjsBFhcWFxYXFjMyNzY3NjMyHQEGBwYHBgcGFRQXFB4BFRQHBgcGIyInLgEnJicmJyYnJic1NDc2NzZCEhANJRYWIR4ZFhwlNyYeHBk1AQkGHzQOEAIBAQUOJCEkFREaGgwNHxlTNBITAQMEExAC3AgCERIxLxUTQC0UEz0IEhYQQWsxOEYoKAwWCwITGTonJAsQQEVORziFUiYnGg0VDBAVEgAAAAEADf/jAjAC+wBPAAABNjMyFxYXFhcWFxUUBwYHDgIHBgcGBwYVFBcWMzI3NjMyFxYVFAcGBwYjIicmJyYnLgE9ATY3Njc2NzY3NjU0JyYjIgcGIyImNTQ3Njc2AP8FIHIYJBoVEA0CDg0mAQscDTQYIggIGxYKDCotFh8ZGCYXFhc6LE1xHiIXDhIIKCsvJxYeCwQmCQkOKCMSKUY/HBwvAvoBBwoRDh4WIg8jJCEvAQ8lEkUbIxITECMQCQoMGRgkLiMVBgYDBQUGFgwuEgc1QUYuJyAsGgkPKQkDDQtEMT4dDQQGAAABABv/ZAEkA0gAKwAAEzYzMhcWFxYVFAcGBwYVFBcWFxYXFhcWFRQHBisBJicmJyYnLgE1NDc2NzaiGxMfFBAICS0rCgoCCRYGGhkCBCAiKgg8Ig0DAwMDEgYNJCMDPwkOCw4REB4vLyMlyCoobFMXMzYJDgcoHB0EPhkpLKvWkD4yGDIoKAAAAQAG//kB3QKhACMAABMWFxYXFhcWFxYXFhcWFRQHBgcGIyImJyYnJicmJzU0NzYzMlgLGBUKBxwdVB4jDSM+BAkPERchPCwjQEYeQAMYDhMRAp0EEhANBywqbSlJIDdmLBIJGQsNMDsugY0rXyoILRAIAAAB//r/ZAEDA0gAKwAAFwYjIicmJyY1NDc2NzY1NCcmJyYnJicmNTQ3NjsBFhcWFxYXHgEVFAcGBwZ8GxMfFA8ICi0rCgkCCRUGGhsBAyAiKgg8IgwDBAMDEgYNJCOTCQ4KDxIPHi8vIyHMKihxThczOQYKCygcHQQ+Fiw/mNaQPjIYMigoAAAAAQAnAWoCEwLoAD0AAAEiDgEjIicmJyYnJicmJyYjIgcGBwYHDgEHBiMiBiMiJyYnJjU0NzY3Njc2MzIXFhcWFxYXFhcUFhUXFAcGAcoDCQgEGhsZDAgBAgMEDRMkEAsXDQ4JCA4QEhQCCgMHEQ4DATkgDiMXGyksKRIPFUIlBwcFAQEGEwFtAgEMCxMMKyQKDA0SAwcREiIfFggJAQsKDQMIGVkzHkQRFR4NFR5hNw4PGgUIAgMHCyEAAAABACr/RAH7AAEAGgAABRYVFAcGBwYjIi4BJyYnJicmNTQ3NjMyNjMyAe0OCwsUIUcmVnEHGhIQCAcmDCoZrC1bHhEgGhgaDRQKEgEECgkSEAwuFAcSAAAAAf/9AWoBYQLpACEAAAEiDgEjIicmJy4CNTQ3NjMyFxYXFhcWFxYXFBYVFxQHBgEYAwkIBBobGQwRYTcaHCcrKhIPFUIlBwcFAQEGEwFtAgEMCxMZe1ohHBQWHw0VHmE3Dg8aBQgCAwcLIQAAAgAa/9ACrgInABQAPgAAASYjIgcGBwYHBhUUFx4BMzI3NjU0JzYzMhcWFxYXFhUUBwYHBgcGIyInJiMiBwYHBgcGIyInJicmNTQ3Njc2AZsZGQUKGxcYBgUHDTAcLSEfaSEXMkQ9IR4ODQkKFxgeDAgHORwZIhMVIjINIiNBMjMPBhQkWlsBaAoCCBQVFhIRGA8bHiIiKEDQBREQHBozMWhRJykaHAUDDAYKDhgjBg4uLkwbHDI5XE1NAAACACX/4gKYAt8AEwBLAAABJicjIgcGFBcWFzMyNzY3Njc1NAE2MzIXFhcWFxYzMjc2MzIXFhcWFxYVFAcGBwYHBiMiJyYnJicmJyY1NDc2NTQuATUmNTQ3Njc2AZwQHAoiJSklDR8PEhEcExUB/swQAiccFRUMGBQnHhsrHiITKSQjCAEZGCkzIic3HSpHKzkWQBcHCQgBAQQKDBYUAVoKAiEmXhkKAgkPHSAcCS8BmAIgGj4oFhMHCQoTOzo/BBAzRUI1QxUYBgoBAgYUQhEvN09OEwMMFgtBR0MYHxcVAAEAGv/YAdkCFwAtAAABNjMyFxYXFhUUBwYHBgcGBwYVFBcWFxYXFhUUBwYHBiMiJyYnJicmNTQ3Njc2AUMPCicXHhEQIhg+Mh8aEQ0tHEhHFQ4gGh8uMC0qOi4rEQcFHp46AhQDCg4aGSIvGBIGBA0LFxMZMhkRBgYYERIbIBkMEQ0RMy9FHyshGXxQHAAAAAIAGv/SAoYCsQAVAEkAAAEmIyIHDgEVFBcWMzI3Njc2NzY1NCYTNjIXFhcWFRQHBhUUFxYVFAcGIyInJiMiBwYjIiYrAS4BJyY1NDc2NzY3Njc2NzY3Njc2AV4RCQsPKDIZGiUgHhMOEAQCJHkVIhIsFQkJCAoIKRIYFykxGR48RSsBBgIKO1gVCgURMjVEHS02GBoXGREUAV0FBQxEJCkZGhYOFhkTEgMcMgFTCAgUVCQ9PkA6LTYyNRU5EwkMDxwhAQNANhc1HBxNQ0coEhIYExUlJhEUAAIAHP/DAggCQwARAD8AAAEmIyIHBgcGFRQXFjMyNzY1NCc2MzIXFhUUBwYHBgcGBwYVFBcWOwEyNjMyFxYVFAcGIyInJicmNTQ3Njc2NzYBWQ0UIBscCQIXFx8zIQ5aIgtNMjEWEx4cPysSEQ0NIwYfOAwZDA0kJzlbZlIlGEIVGyYPMwGyBxUWJAgJHBkXMRYaMp0GNDJJLywoGxkhFREPEhgJCQwODxUnHR5EN0cxO2NaHBkjCiMAAAAAAQAh/8IBbAMKAD8AABM2MzIXFhcWFRQHBgcGBwYHBhUUFxYXFhcWFxYVFAcGBwYVFBcWFRQHBgcGIyInJicmJyYnJjU0NzY3Njc2NzbSChAlHh8PCQcJChQbKQgjHw0KBCozBQctGQ0MDg0NDR4cGyIcGw4PDQYGCQcMAgwUEyInAwgCEhMcExITCg0FCgkPBxYsJRUIAwECAQkJCRkwGxkYGxpBPRwgGxoWFRwbNz14LCM0JicfPxdWJyUZHQAAAgAZ/u4CagILABEATwAAASYjIgcGFRQXFjMyNzY3NjU0JzYzMhcWFxYXFhUUBwYHBgcGBwYHBgcGIyInJicmNTQ3Njc2NzY3NjU0JyYjIgcGIyInJicmNTQ3Njc2NzYBfxUVIyQmFhchGx4bDwhzGCwzGDInKBMZAgQLEQkKEA4gKkhJPBwUHRASCwgMAkBrMRIUDCEPPCwWQSQmGRUkJUAhIzIBNg0hIywfFhcWFB8VES3hBwoRJScvPFo0DRk1SC81JB4fJhcYBgoUFxgQDgsDAQUHNBUPEw4JBQQVFjQtNEpFSDIaERgAAAABABv/0AJYAucASgAAEzYzMhcWFxYXFhcWFxYXFhcWFxYVFAYVFBcWFRQHBiMiJyYnJicmJyYjIgcGFRQXFhUUBwYHBiMiJyY1NDc2NTQnJjU0NzY3Njc2dxABJR8KCQwPDRMSExQwVSchEQ4CEQoeISw8JRAHCAEEHQsMCwsYAQMLERwdH0QcDQcHDw0KCQsIFRMC5QIiDBEZKCITEQYHBAYYFSEcNxYOGzxQLiMwHiE0GRkdJE4SCAgQJRIFIygjGCIQETsZNDBCQDxAUUA6OBUVDggODAACACH/3QEKAtEAFgA1AAATNjMyFxYXFhUUBwYHBiMiJyYnJjU0NgM2MzIXFhcWFxYVFAcGBwYjIicmJyYnJic0JjUwNTSHDRggExEJCwoLDRscIBcZBgEcGAoCCTglEQ8JFwYPKRgYIBobCgUKCgIBAsoHDQ0RFA8QExUKFRMVHwMIFSz+5wIOCgoJETNsLydeJhYfIDQdTU8lAQYCCFsAAv/o/xIBEwLkABYAOwAAEzYzMhcWFx4BFRQHBgcGIyInJjU0NzYDNjMyFxYXFhUUBwYHBgcGIyInJj0BNjc2NzY3NTQ2NTQnJjU0iREMEg8RDRIIBwsUFSwuECEXGBMGFzggJg8UBgkMCTktNS8eHwEfIQYIAgEJCgLfBQcJDxYYFh8NGQgICRErJB8g/t4CCAodLXo1KkeCXCkfGRonChhBSBIbLQwDCAEdPkUnVQABACf/mwJFAuUAUgAAEzYzMhcWFxYVFAcGFRQXHgEyNzY3Njc2NzMyFxYVFAcGFRQXFhUUBwYHBgcGIyInLgEjIgYVFBcWFRQHDgEiJyYnJjU0NzY3NjU0JyY1NDc2NzZyEBUnGhYODQkMAwUgLhQSEA0XDRoKHBoZEhMlIQMEERATEBEpOyAiFRocBQUJDjg4FCMPDgEBBwUGBQsJEBQC3AkeGTMwOCsmMhMMDBseEhIzLhcLAhcXHxUvMBokPTkbCwsTGBcKCVAtHCIbDBYZCRMPGRwLEygmVSMLQUxEITA5PBw8HhYSFgAAAAEAHf/nAQgC4wAmAAATNjsBFhcWFRQHBhUUFxYVFAcGIyInJicmJyY1NDY9AjQmNTQ3Nm0HEQkmHCkGBxMJFhotFhsoEA8CAwESGRQC4AMDJjWTMjhAJkJMJx80Fh0MFCQfEhhJAiEOOyk+lCxBJhwAAAAAAQAi/+MDEAH6AFIAAAE2MzIXFhcWFxQWHQEUBgcGBwYjIicmJyYnJicmIyIHBgcOASMiJyYnJicmJyYjIgcGBwYHBgcGIyImJyYnJjU0NzY3NjMyFxYzMjc2MzIXFjMyAiwrJ0gkFAcJAQEIDxAWGRMcDgkBAQUEEA4RGxARBwgwKBIQEgYGAwMKEyYYExYFAQQDDA8SGTILCgoHAwkkIisRJSEPEBUWGxQWGRolAecTNx8yOmgCEgUVNSoeIBASHBE4LREQDAsWFzQxNgkMEhNBRRIoExZOJBIMDQ8yIh9QODgfFC8jIREPBwcFBgAAAQAm//ECKgIuAEEAAAE2MzIXFhcWFxYXFhcWFRQHBiMiJyYnJicmJyYnJiMiBwYVFBcWFRQHBgcGIyInJicmJyY1NDc2NzY3Njc2NzY3NgF5AwopFiERCgUFBgIPCBkZKhIKEgUHAQEHBhEYGDgUBQEBBQQQGyInHB4KBAUFMBgUHC8eShkEFAcGAi0BDREpFhseRR9gNRo0JyUHCxQdOT8cGhEWRhkWHQsJHCARDhAbHyE0GFBYLmQtFgYIBAIQBgEEAgIAAAACACD/uwIiAe0AGAAzAAABJiMiBwYVFBcWFxYzMjc2NzA1NDc1NCcmJzYzMhcWFxYVFAcGBwYrASYnJicmNTQ3Njc2AU0SESsYIgILLA4VJB4dAwEPELUaGGNVZBwICBZGRVkQiUMYBQcJESIkATAIHSg+AxA3EwceHS8IAgICJBsdwgYsNW4eLi8eWzg3BIs1GSI9QiE5JCUAAAACACD/DQKBAicADgBDAAABNCYjIgcGFRQXFjMyNzYDNjIXFhcWFxYXFhUUBwYHBgcGBwYVFAcGBwYjIicmNTQ3NjU0LgE1JjU0NzY3Njc2NzY3NgHBOC82IyU0ExsyLSRJFi4WSSQSFBYEAjlDikcUBwsKCgkIGTM+JhkIBwEBAwUGFCBNKRkPKjUBDSk0ICIwPhkKKiQBPQUFD0okP0UaGANZP0srFRkHGBUJBhsXCiQ1Jj0eTTUqAw8eD0pOOhMYGCkGBAQDDhMAAAACABn/JQKaAggAEAA7AAABJicjIgcGFRQXFjMyNzY1NCc2MzIXFhcWFRQHBh0CFAcGBwYjIicmJy4BIyInJicmPQE0NjU2NzY3NgHHFzUJRiEICBk/LCEirhgqKVRWFE0XFAUDDRMuKBgbGRo0R1E2NR0eAQUcJD9AASYpA0YTFRYSNyEiLhzvBxUWCSSGPGRcSCQgJB4UDhkUFjI1HBsbMzU+CAIGAT48SDY3AAAAAAEAJf/XAh0CJwAvAAABNjMyFxYXFhUUBwYHBgcGBwYHBgcGBwYHBiMiJyYnJicmJyY1NDc2NzYzMhcWMzIBUiQUDBlNGAkkERQZKzgSIRQQDQYNDRkJDh4cHwwGBQMHBQYROwkPEUcGEhQCHgkFFDkXEzYqFAYIAQELESokdDMZGAoEFxojEF5OOjkcKRhCFwQGAQABABf/oAHnAjcAQgAAATYzMhcWFxYVFAcGIyInJiMiBw4BFRQXFhcWFxYXFhcWFxYUBwYHBiMiJyY1NDMyFjMyNTQnJicmJyYnJjU0NzY3NgEgFRQ0JSgQCwYPHw8jGxoZEhkgDQoTFyEsFBEdGQ0LCxk1TlJVPCwhLXwWEygqVjQNDgsLEhtKRgI0AxQVJxsaFAwbCAcHCioXExIPBggBAwkIGxcZFEYUMiExNikiHCImHiQlLxwJChEUGSIlNzQxAAAAAQAf/7cBpAKxADgAABM2MhcWFxYXFhcWFxYXFhUUBwYHBhUUFxYXFhcWFRQHBgcGByMiJy4BJyYnJj0BNDY1Njc2NzY3NoYSJAoOBgYFCBUXKyEQDCBJDygXFlMjEBAbGSofIw1OMyAYBAMNCwECDQ0KCBIUAqgJBwgMDR8zHB0QDg4KFh4NIg0lOiwiIwsEDw4eHSUhFA8BOCJUYVo1NBMIAgUBHEA8HBcTFgAAAAABACD/2QJZAe0APwAAEzYzMhcWFRQHFA4BFRQWFxYzMjc2NzU0NjU0JyY1NDc+ATMyFxYXFhcWFRQHBiMiJyYjIgcGIyInJicmJyY1NGYYEjEZCgEBARYZDh0eDh0HAQMDBAkuHioUFQQIEAsVGCgNCiUdLC0lIikeLyI4FgUB4gspDhEVCQ8jEwU9PhUMCxUzCAMJARsjKg4RDB8iHyBGfEkxHicYGwIDDAoPFjNTmSgSaQABABv/zAIcAf8AOwAAEzYzMhcWFxYXFhcWFxYzMjc2NzY3Njc2NzY3NjMyFxYXFhUUBwYHBgcGIyInJicmJyYnJic0JjUnNDc2ZwwNHRoZDgcCAgQFDBQlEAwYDg4KBgsHDxAYBAwJDxADATwiDiMZHikvKhIQBVYhDQcFAQEGFQH8AxEQHRBAMRMXDhoFChoZMiQaEgoMAQEPEBIEDiKEUChhGyEuEx4Js0EkEioHDQQDCw8yAAAAAQAe/8MCogIDAEMAAAE2OwEWFxYXFhUUBwYHBiMiJyYjIgcGIyInJicmJyYnJjU0NzYzMhcWFxYXFhcWMzI3NjMyFxYXFhceATMyNzY1NDc2AjYMGQkVDhQDBAgHGSQ/IDUtIBQmKxIqJCMWCiUiBARDDRMZDQ8GCAQNGBkRExkTKQ8MEgUICAoeDyAPBgICAfATAg8UHSZykUA6JTYREAgKHh43HHRqGBEaVRwGCQoRFyNrLjBBNgUHBwwdICdOIlc4FBAAAAABABT/5gIDAhAASQAAEz4BMzIXFhcWFxYXFjMyNzY3Njc2MzIXFhUUBwYHBgcVFBcWFRQHBiMiJyYnJiMiBwYHBgcGByMiJjU0NzY9ATQmNSYnJicmNTQbCTYjGBgWCQgFBhESHCESBggLIhkYFw0iHRsGCQEhEiQSDQ8QHiAdIQ8ODRMUDQoRBhgeDg4BAgcGHjUB0xkkDAsSESY8FBgeCyg9FA8JFiYhMTEQFxkNJU4vGCoRCQgOPDsJCBkaCwgCIhoQLS8NBgIFASEODCxJJw4AAAEAF/8eAigCAABEAAATNjc2MzIXFhcWFxYXFhcwMzIXMzI3NjU0JyY1NDc2MzIXFhcVFAcGBwYHBgcGKwEmJyY1NDc2NzY3NjU0JyYnJicmNTQ1FAsNGhcYIRATEhQTEiEFAQIBHhARAgUIEykXExwDIRUQERINHzVQDDEbHAgFHxcKCREUQVMSDgHmEQQFCxAcIU1SIB0FARYXKQMYKxAcEicQFzgSLm1HTFw1JR81AxgZJxkQCigcFRIZIBwhTGYmIhoqAAAAAQAU/+0B+AIhADgAAAE2MzIXFhcWFRQHBgcGBxQXFjsBNjMyFxYVFAcGBwYHBiMiJyY1NDc2NzY3NjU0JyYnJicmNTQ3NgETMTImEysSBysiDUoCDxAbCDwLDAoMJxgdIGNnPCYJMwICWFoDBAcOQDgRDj5MAhcKBg4pDxpCKCAJPTQbDg4GCgwXLxsRBQUDBAQVJQQEDlpdBQcPFwoaBQUVFBIwHCUAAQAT/0cBKQM9ADwAABM2MzIWFxYVFAcGFRQXFhUUBgcGFRQXFhcWFxYVFAcGIyInJicmNTQ3NjU0JyY1NDc2NzY0JyY1NDc2Nza1CgsZJggJIhIHBwwaHRkVCw4gERgbMDYiJAgDCQQgGRMLBAILDRoVIicDOwIUEhYJG00xJhUxPBohHh0lFhEvKjdERioVHBseISM8FQkLTyEPJz81FBIzGxEIPi8wLDo3KhsfAAABACX/tgDYAvAAJwAAEzY7ARYXFhUUBwYVFBcWFRQHBiMiJyYnJicmNTA1NDY9ATQmNTQ3NmEIDAYdFR8EBg8HERQiERQeDQkDAwEOExEC7AQDKjuePTVLJERUJyU3GR8NFiYaHBlQMw4rByxKlDVGKSAAAAEAA/9HARkDPQA+AAAXBiMiJicmNTQ3NjU0JyY1NDc2NzY1NCcmJyYnJjU0NzYzMhcWFxYVFAcGFRQXFhUUBwYHBhUUFxYVFAcGBwZ3CgsXKAgJIhIHBwYHGR0ZFQsOIBEYGzA1IyUHAwkEIBkTCQUDCw0aFCMotwIWERYIG00xJhUxPBohDxEcJRURLyo3REYqFRwbHiIjOxUJC08hDig/NRQSMxYVDBwfLzAsOjcoHCAAAAEAKABkAfIBeQAtAAATNjMyFxYzMjYzMhcWFRQHBgcGDwEiIzAjIicmJy4CJyYrAiInJicmNTQ3Nq4MDxwYLSodNBIcEwwNESAiIwMDAQUpLwUmCBQLAwkWGQ4fDQ8HBjQrAXUEITouIxYeHxolFhgEARoDFQQKBgEEBQYMCg4qNSwAAAAAFAD2AAEAAAAAAAAAFwAwAAEAAAAAAAEABgBWAAEAAAAAAAIABwBtAAEAAAAAAAMAGACnAAEAAAAAAAQABgDOAAEAAAAAAAUAEAD3AAEAAAAAAAYABgEWAAEAAAAAAAkAEgFDAAEAAAAAAAoAFAGAAAEAAAAAAAwAFAG/AAMAAQQJAAAALgAAAAMAAQQJAAEADABIAAMAAQQJAAIADgBdAAMAAQQJAAMAMAB1AAMAAQQJAAQADADAAAMAAQQJAAUAIADVAAMAAQQJAAYADAEIAAMAAQQJAAkAJAEdAAMAAQQJAAoAKAFWAAMAAQQJAAwAKAGVAEMAbwBwAHkAcgBpAGcAaAB0ACAAKABjACkAIAAyADAAMgA1ACwAIAB3AGUAcAAAQ29weXJpZ2h0IChjKSAyMDI1LCB3ZXAAAFYAYQBiAGUAZABvAABWYWJlZG8AAFIAZQBnAHUAbABhAHIAAFJlZ3VsYXIAAHcAZQBwACAAOgAgAFYAYQBiAGUAZABvACAAOgAgADEANwAtADYALQAyADAAMgA1AAB3ZXAgOiBWYWJlZG8gOiAxNy02LTIwMjUAAFYAYQBiAGUAZABvAABWYWJlZG8AAFYAZQByAHMAaQBvAG4AIAAwADAAMQAuADAAMAAwACAAAFZlcnNpb24gMDAxLjAwMCAAAFYAYQBiAGUAZABvAABWYWJlZG8AAFcAYQBoAHkAdQAgAEUAawBhACAAUAByAGEAcwBlAHQAeQBhAABXYWh5dSBFa2EgUHJhc2V0eWEAAGgAdAB0AHAAcwA6AC8ALwB3AGUAcABmAG8AbgB0AC4AYwBvAG0ALwAAaHR0cHM6Ly93ZXBmb250LmNvbS8AAGgAdAB0AHAAcwA6AC8ALwB3AGUAcABmAG8AbgB0AC4AYwBvAG0ALwAAaHR0cHM6Ly93ZW5mb250LmNvbS8AAAAAAgAAAAAAAP+0ADMAAAAAAAAAAAAAAAAAAAAAAAAAAABiAAAAAQACAAMABAAFAAYABwAIAAkACgALAAwADQAOAA8AEAARABIAEwAUABUAFgAXABgAGQAaABsAHAAdAB4AHwAgACEAIgAjACQAJQAmACcAKAApACoAKwAsAC0ALgAvADAAMQAyADMANAA1ADYANwA4ADkAOgA7ADwAPQA+AD8AQABBAEIAQwBEAEUARgBHAEgASQBKAEsATABNAE4ATwBQAFEAUgBTAFQAVQBWAFcAWABZAFoAWwBcAF0AXgBfAGAAYQAAAAAAAf//AAIAAQAAAAwAAAAWAB4AAgABAAMAYQABAAQAAAACAAAAAQAAAAEAAAAAAAEAAAAKACwALgACREZMVAAObGF0bgAYAAQAAAAA//8AAAAEAAAAAP//AAAAAAAAAAEAAAAKADAAPgACREZMVAAObGF0bgAaAAQAAAAA//8AAQAAAAQAAAAA//8AAQAAAAFrZXJuAAgAAAABAAAAAQAEAAIAAAAGABIANADKAQYBSAN6AAEAGgAEAAAAAgAOABQAAQAS/zkAAQA//zkAAQACABIAPwABAH4ABAAAAAoAHgAoADIAPABGAFAAWgBkAGoAdAACAA//hQAR/5IAAgAP/1AAEf9JAAIAD/9NABH/aAACAA//bAAR/3EAAgAP/58AEf+qAAIAD//iABH/6QACAA//rwAR/8MAAQAP/+IAAgAP/wcAEf8YAAIAD//RABH/zwABAAoAGgApADMANwA5ADoAPABJAFUAWQABADAABAAAAAQAEgASABwAJgACACT/pgAt/1AAAgAF/9sACv/bAAIABf8DAAr/AwABAAQABQAKACQALwABADYABAAAAAQAEgAYACIALAABABr/6QACABX/zQAa/5YAAgAV/9oAGv+eAAIAF/+nABn/5wABAAQAEwAXABkAGgABAhIABAAAAA4AJgA8AFYAoACyAMgA3gDkAPYBQAGCAZABrgH4AAUAVv/zAFn/wQBa/+YAW//xAFz/yQAGAFb/1gBY//MAWf/LAFr/3wBb/9sAXP+4ABIARP+hAEb/ugBH/4QASP+8AEr/pwBQ/9QAUf/NAFL/zABT/8cAVP+lAFX/zwBW/9QAWP/XAFn/0QBa/9UAW/+/AFz/zgBd/6MABABW/9IAWf/lAFv/7wBc/8QABQBW//oAWf+1AFr/7gBb//MAXP+TAAUARP/EAEb/5wBH/6IASv/LAFT/yAABAFb/9AAEAFb/8gBZ/+8AW//tAFz/wwASAET/cgBG/3oAR/9cAEj/egBK/3YAUP+DAFH/gwBS/4MAU/9/AFT/dgBV/4gAVv9qAFj/gwBZ/3sAWv9/AFv/fgBc/3UAXf9gABAARP+/AEb/zQBH/68ASP/TAEr/wwBM//MAUP/iAFH/6QBS/9gAU//eAFT/wgBV//UAVv/hAFj/6QBa//MAXf/aAAMARP/1AEf/6gBd//AABwBI//MAVv/dAFj/6QBZ/9EAWv/dAFv/5gBc/8sAEgBE/8IARv/HAEf/tABI/8UASv/DAFD/0gBR/9cAUv/NAFP/0QBU/8MAVf/dAFb/wgBY/9MAWf/XAFr/1ABb/+QAXP/bAF3/xgAGAFb/4wBY//AAWf/LAFr/3gBb//EAXP/GAAEADgAmACgAKQAuAC8AMwA1ADYANwA5ADoAOwA8AD0AAQD+AAQAAAANACQAOgBEAFYAXAByAJQAngCoALYA1ADiAOwABQA3/8kAOf/sADr/6AA7//MAPP/UAAIAN//gADz/7QAEADf/zAA7/+8APP/uAD3/7wABACr/8AAFACT/qwAt/1gAMP/QADH/7gA0/+cACAAq/70AMv/sADf/ZwA4//UAOf+FADr/hwA7/9wAPP84AAIALf/gADf/7wACACT/1AAt/0oAAwA3/8cAO//uADz/6QAHACT/nQAm/9oAKv/jAC3/ZQAw/8MAMf/oADT/uAADACT/0QAt/5wAMP/vAAIAJP/1AC3/3wAEACT/0AAt/68AMP/oADT/8QABAA0AJAAlACcAKAApAC8AMgAzADQANwA5ADoAPAAAAAEAAAAA28y/fQAAAADkdb24AAAAAOR2vhc="
    local function loadVabedoFont()
        local getAsset = getcustomasset or getsynasset
        if type(writefile) ~= "function" or type(getAsset) ~= "function" then return nil end
        local ttfName, jsonName = "RivalHub_Vabedo.ttf", "RivalHub_Vabedo.json"
        local okAll, result = pcall(function()
            local need = true
            if type(isfile) == "function" then
                local okF, has = pcall(isfile, ttfName)
                if okF and has then need = false end
            end
            if need then
                local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
                local map = {}
                for i = 1, #chars do map[chars:sub(i, i)] = i - 1 end
                local out, n = {}, 0
                local buf, bits = 0, 0
                for i = 1, #VABEDO_B64 do
                    local v = map[VABEDO_B64:sub(i, i)]
                    if v then
                        buf = buf * 64 + v
                        bits = bits + 6
                        if bits >= 8 then
                            bits = bits - 8
                            local byte = math.floor(buf / (2 ^ bits))
                            buf = buf - byte * (2 ^ bits)
                            n = n + 1
                            out[n] = string.char(byte)
                        end
                    end
                end
                local raw = {}
                for i = 1, n, 4096 do raw[#raw + 1] = table.concat(out, "", i, math.min(i + 4095, n)) end
                writefile(ttfName, table.concat(raw))
            end
            local fam = game:GetService("HttpService"):JSONEncode({
                name = "Vabedo",
                faces = {{ name = "Regular", weight = 400, style = "normal", assetId = getAsset(ttfName) }}
            })
            writefile(jsonName, fam)
            return Font.new(getAsset(jsonName), Enum.FontWeight.Regular, Enum.FontStyle.Normal)
        end)
        if okAll then return result end
        return nil
    end

    local miniTitle = Instance.new("TextLabel", miniBtn)
    miniTitle.Name = "RivalHubTitle"
    miniTitle.Size = UDim2.new(0.8, 0, 0.7, 0)
    miniTitle.AnchorPoint = Vector2.new(0.5, 0.5)
    miniTitle.Position = UDim2.new(0.5, 0, 0.5, 0)
    miniTitle.BackgroundTransparency = 1
    miniTitle.Text = "RIVAL HUB"
    miniTitle.Font = Enum.Font.GothamBlack
    miniTitle.TextScaled = true
    miniTitle.TextWrapped = false
    miniTitle.TextSize = 44
    do
        local miniTitleLimit = Instance.new("UITextSizeConstraint", miniTitle)
        miniTitleLimit.MaxTextSize = 38
        miniTitleLimit.MinTextSize = 8
    end
    miniTitle.TextColor3 = Color3.fromRGB(255, 130, 20)
    miniTitle.TextXAlignment = Enum.TextXAlignment.Center
    miniTitle.TextYAlignment = Enum.TextYAlignment.Center
    miniTitle.ZIndex = 23
    do
        local vabedo = loadVabedoFont()
        if vabedo then pcall(function() miniTitle.FontFace = vabedo end) end
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
        return sv, row
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

    local function mkToggleSelector(page, txt, cb, options, getKey, onSelect)
        local sv, row = mkToggle(page, txt, cb)
        local n = #options

        local arrow = Instance.new("TextButton", row)
        arrow.Name = "SelectorArrow"
        arrow.Size = UDim2.new(0, 32, 0, 26)
        arrow.AnchorPoint = Vector2.new(1, 0.5)
        arrow.Position = UDim2.new(1, -66, 0.5, 0)
        arrow.BackgroundColor3 = Color3.fromRGB(18, 18, 24)
        arrow.BackgroundTransparency = 0.1
        arrow.BorderSizePixel = 0
        arrow.Text = "▼"
        arrow.Font = Enum.Font.GothamBlack
        arrow.TextSize = 11
        arrow.AutoButtonColor = false
        arrow.ZIndex = 14
        Instance.new("UICorner", arrow).CornerRadius = UDim.new(0, 8)
        local arrowStroke = Instance.new("UIStroke", arrow)
        arrowStroke.Thickness = 1.2
        arrowStroke.Transparency = 0.25

        local dd = Instance.new("Frame", page)
        dd.Name = "SelectorOptions"
        dd.Size = UDim2.new(1, -4, 0, 0)
        dd.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        dd.BackgroundTransparency = 0
        dd.BorderSizePixel = 0
        dd.LayoutOrder = getNextOrder(page)
        dd.Visible = false
        dd.ClipsDescendants = true
        dd.ZIndex = 7
        Instance.new("UICorner", dd).CornerRadius = UDim.new(0, 11)
        local ddStroke = Instance.new("UIStroke", dd)
        ddStroke.Thickness = 1.2
        ddStroke.Transparency = 0.35

        local slider = Instance.new("Frame", dd)
        slider.Size = UDim2.new(1 / n, -6, 1, -8)
        slider.BackgroundTransparency = 0.05
        slider.BorderSizePixel = 0
        slider.ZIndex = 8
        Instance.new("UICorner", slider).CornerRadius = UDim.new(0, 9)
        local sliderGrad = Instance.new("UIGradient", slider)
        sliderGrad.Rotation = 90
        sliderGrad.Color = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0))
        local sliderStroke = Instance.new("UIStroke", slider)
        sliderStroke.Thickness = 1
        sliderStroke.Transparency = 0.2

        local labels = {}
        local function selIndex()
            local cur = getKey()
            for i, o in ipairs(options) do
                if o[1] == cur then return i end
            end
            return 1
        end

        local function paint(animate)
            local th = Color3.fromRGB(255, 150, 40)
            local selTxt = Color3.fromRGB(255, 170, 50)
            local idx = selIndex()
            local pos = UDim2.new((idx - 1) / n, 3, 0, 4)
            slider.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
            sliderStroke.Color = Color3.fromRGB(0, 0, 0)
            sliderStroke.Transparency = 1
            ddStroke.Color = Color3.fromRGB(0, 0, 0)
            ddStroke.Transparency = 1
            arrowStroke.Color = getThemeColor()
            arrow.TextColor3 = getThemeColor()
            if animate then
                TS:Create(slider, TweenInfo.new(0.18, Enum.EasingStyle.Quad), { Position = pos }):Play()
            else
                slider.Position = pos
            end
            for i, l in ipairs(labels) do
                if i == idx then
                    l.TextColor3 = selTxt
                    l.TextTransparency = 0
                    l.TextStrokeTransparency = 1
                else
                    l.TextColor3 = Color3.fromRGB(130, 75, 20)
                    l.TextTransparency = 0
                    l.TextStrokeTransparency = 1
                end
            end
        end

        for i, o in ipairs(options) do
            local lbl = Instance.new("TextLabel", dd)
            lbl.Size = UDim2.new(1 / n, 0, 1, 0)
            lbl.Position = UDim2.new((i - 1) / n, 0, 0, 0)
            lbl.BackgroundTransparency = 1
            lbl.Text = string.upper(tostring(o[2]))
            lbl.Font = Enum.Font.GothamBlack
            lbl.TextSize = 12
            lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            lbl.ZIndex = 9
            labels[i] = lbl
            local b = Instance.new("TextButton", dd)
            b.Size = UDim2.new(1 / n, 0, 1, 0)
            b.Position = UDim2.new((i - 1) / n, 0, 0, 0)
            b.BackgroundTransparency = 1
            b.Text = ""
            b.AutoButtonColor = false
            b.ZIndex = 11
            b.Activated:Connect(function()
                pcall(onSelect, o[1])
                paint(true)
                task.defer(function() pcall(saveAllSettings) end)
            end)
        end
        paint(false)

        local open, tw = false, nil
        arrow.Activated:Connect(function()
            open = not open
            if tw then tw:Cancel() end
            if open then
                paint(false)
                dd.Visible = true
                arrow.Text = "▲"
                arrowStroke.Transparency = 0
                tw = TS:Create(dd, TweenInfo.new(0.24, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), { Size = UDim2.new(1, -4, 0, 40) })
                tw:Play()
            else
                arrow.Text = "▼"
                arrowStroke.Transparency = 0.25
                tw = TS:Create(dd, TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.In), { Size = UDim2.new(1, -4, 0, 0) })
                tw.Completed:Connect(function() if not open then dd.Visible = false end end)
                tw:Play()
            end
        end)

        return sv, function() paint(false) end
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
        btn.Size = UDim2.new(0, 80, 0, 60)
        btn.Position = UDim2.new(1, -88, 0.5, -30)
        btn.BackgroundColor3 = INP
        btn.BackgroundTransparency = 0.5
        btn.BorderSizePixel = 0
        local function getLabel() return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None" end
        btn.Text = getLabel()
        btn.TextColor3 = WHITE
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 11
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
        local row = mkRow(page, 60)
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

    mkSect(speedPage, "Float")
    _G.__RivalHubFloatSetVisual = mkToggle(speedPage, "Float", function(on)
        if on then _G.__RivalHubFloat.enable() else _G.__RivalHubFloat.disable() end
        if mobSetFloat then mobSetFloat(on) end
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
        local choice = (antiRagdollMode == "v1" or antiRagdollMode == "v2") and antiRagdollMode or "v2"
        local sv, refresh = mkToggleSelector(combatPage, "Anti Ragdoll",
            function(on)
                if on then setAntiRagdollMode(choice) else setAntiRagdollMode("off") end
            end,
            { { "v1", "V1" }, { "v2", "V2" } },
            function() return choice end,
            function(key)
                choice = key
                if antiRagdollMode ~= "off" then setAntiRagdollMode(key) end
            end)
        _G.updateAntiRagdollUI = function(mode)
            if mode == "v1" or mode == "v2" then choice = mode end
            sv(mode == "v1" or mode == "v2")
            refresh()
        end
        _G.updateAntiRagdollUI(antiRagdollMode)
        setAntiRagVisual = function(on)
            if not on then setAntiRagdollMode("off") end
        end
    end

    mkSect(combatPage, "Bat")
    do
        local sv, refresh = mkToggleSelector(combatPage, "Bat",
            function(on)
                if on then
                    if _G.__RivalHubStartBatV2 then pcall(_G.__RivalHubStartBatV2) end
                else
                    if _G.__RivalHubStopBatV2 then pcall(_G.__RivalHubStopBatV2) end
                end
                if mobSetBatV2 then pcall(mobSetBatV2, on) end
            end,
            { { "v2", "Bat V2" }, { "v3", "Bat V3" } },
            function() return (_G.__RivalHubBatVersion == "v3") and "v3" or "v2" end,
            function(key)
                if _G.__RivalHubSetBatVersion then
                    _G.__RivalHubSetBatVersion(key)
                else
                    _G.__RivalHubBatVersion = key
                end
            end)
        _G.__RivalHubBatSetVisual = sv
        _G.updateBatVersionUI = function(ver) refresh() end
        sv(_G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2() or false)
        refresh()
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

    do
        local sv, refresh = mkToggleSelector(combatPage, "Auto Carry",
            function(on)
                autoCarryEnabled = on
                if not on and _G.__RivalHubAutoCarryRestore then pcall(_G.__RivalHubAutoCarryRestore) end
            end,
            { { "On Pick Up", "On Pick Up" }, { "Soft Steal", "Soft Steal" } },
            function() return autoCarryMode end,
            function(key) autoCarryMode = key end)
        sv(autoCarryEnabled == true)
        _G.__RivalHubAutoCarrySetVisual = sv
        _G.__RivalHubAutoCarryRefresh = function() sv(autoCarryEnabled == true); refresh() end
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

    local configPage = contentPages["Config"]

    mkSect(configPage, "Automation")

    do
        local sv, refresh = mkToggleSelector(configPage, "Auto Steal",
            function(on)
                CONFIG.AUTO_STEAL_ENABLED = on == true
                if on then pcall(startAutoSteal) else stopAutoSteal() end
                updateProgressBarVisibility()
                pcall(saveAllSettings, true)
            end,
            { { "V1", "V1" }, { "V2", "V2" } },
            function() return autoStealMode == "V2" and "V2" or "V1" end,
            function(key)
                autoStealMode = key
                if CONFIG.AUTO_STEAL_ENABLED then stopAutoSteal(); startAutoSteal() end
                pcall(saveAllSettings, true)
            end)
        setInstaGrab = sv
        autoStealModeBtn = setmetatable({}, { __newindex = function(_, k) if k == "Text" then refresh() end end })
        _G._rivalHubStealModeSetter = function() refresh() end
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
    addKeybindRow(keyPage, "Float", KB.Float)

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

    rhLockSetB = mkToggle(visualPage, "Lock UI", function(on) toggleLockUI(on); mobileButtonsLocked = on end)
    setLockUIVisual = function(v)
        if rhLockSetB then rhLockSetB(v) end
    end
    if uiLocked then setLockUIVisual(true) end
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
        rhButtonScaleBox = mkBox(row, _floor(floatingButtonScale * 100), 50, 56, function(v)
            local val = _clamp(v, 50, 200)
            floatingButtonScale = val / 100
            applyFloatingButtonScale()
            saveAllSettings()
        end)
        setSmallButtonsVisual = function()
            if rhButtonScaleBox then rhButtonScaleBox.Text = tostring(_floor(floatingButtonScale * 100 + 0.5)) end
        end
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

    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Medusa Skin")
        local SKINS = {
            {id = "Default",           text = "Default"},
            {id = "Skull",             text = "Skull"},
            {id = "GoldenDesertEagle", text = "Golden Eagle"},
        }
        local function curIndex()
            local cur = _G.RivalMedusaSkin or "Default"
            for i, sk in ipairs(SKINS) do if sk.id == cur then return i end end
            return 1
        end
        local medusaLabel
        medusaLabel = mkSelector(row, SKINS[curIndex()].text, {}, function(direction, updateLabel)
            local idx = curIndex() + direction
            if idx < 1 then idx = #SKINS end
            if idx > #SKINS then idx = 1 end
            if _G.RivalSetMedusaSkin then _G.RivalSetMedusaSkin(SKINS[idx].id) end
            updateLabel(SKINS[idx].text)
        end)
        medusaLabel.Size = UDim2.new(0, 96, 0, 26)
        medusaLabel.Position = UDim2.new(0.5, -48, 0.5, -13)
        _G.RivalMedusaSkinRefreshUI = function()
            medusaLabel.Text = SKINS[curIndex()].text
        end
    end

    mkSect(visualPage, "Effects")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Title Color")
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

        local RIVAL_THEME_LIST = { "Orange", "White", "Black", "Silver" }
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

    do
        local setBrHeldVisual = mkToggle(visualPage, "Brainrot Transparente (Mano)", function(on)
            if _G.RHBrainrotTransparency then _G.RHBrainrotTransparency.SetHeld(on) end
        end)
        local setBrBaseVisual = mkToggle(visualPage, "Brainrot Transparente (Base)", function(on)
            if _G.RHBrainrotTransparency then _G.RHBrainrotTransparency.SetBase(on) end
        end)
        setBrHeldVisual(true)
        setBrBaseVisual(true)
    end

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
    local BAR_W, BAR_H = 280, 26
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
    pbStroke.Color = Color3.fromRGB(255, 180, 60)
    pbStroke.Thickness = 1.4
    pbStroke.Transparency = 0.15

    local hudTitle = Instance.new("TextLabel", pbFrame)
    hudTitle.Name = "AutoStealTitle"
    hudTitle.Size = UDim2.new(0, 76, 1, 0)
    hudTitle.Position = UDim2.new(0, 10, 0, 0)
    hudTitle.BackgroundTransparency = 1
    hudTitle.Text = "AUTO STEAL"
    hudTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    hudTitle.TextStrokeTransparency = 0.4
    hudTitle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    hudTitle.Font = Enum.Font.GothamBlack
    hudTitle.TextSize = 11
    hudTitle.TextXAlignment = Enum.TextXAlignment.Left
    hudTitle.ZIndex = 504

    progressStatus = Instance.new("TextLabel", pbFrame)
    progressStatus.Name = "StealProgressStatus"
    progressStatus.Size = UDim2.new(0, 62, 1, 0)
    progressStatus.Position = UDim2.new(0, 88, 0, 0)
    progressStatus.BackgroundTransparency = 1
    progressStatus.Text = "READY"
    progressStatus.TextColor3 = Color3.fromRGB(230, 238, 248)
    progressStatus.Font = Enum.Font.GothamBold
    progressStatus.TextSize = 10
    progressStatus.TextXAlignment = Enum.TextXAlignment.Left
    progressStatus.TextStrokeTransparency = 0.4
    progressStatus.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    progressStatus.ZIndex = 504

    infoLabel = Instance.new("TextLabel", pbFrame)
    infoLabel.Name = "PerformanceStats"
    infoLabel.Size = UDim2.new(0, 80, 1, 0)
    infoLabel.Position = UDim2.new(1, -90, 0, 0)
    infoLabel.BackgroundTransparency = 1
    infoLabel.Text = "FPS --  MS --"
    infoLabel.TextColor3 = Color3.fromRGB(150, 158, 172)
    infoLabel.Font = Enum.Font.GothamMedium
    infoLabel.TextSize = 9
    infoLabel.TextXAlignment = Enum.TextXAlignment.Right
    infoLabel.TextStrokeTransparency = 0.4
    infoLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    infoLabel.ZIndex = 504

    local stealTrack = Instance.new("Frame", pbFrame)
    stealTrack.Name = "StealProgressTrack"
    stealTrack.Size = UDim2.new(1, 0, 1, 0)
    stealTrack.Position = UDim2.new(0, 0, 0, 0)
    stealTrack.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    stealTrack.BackgroundTransparency = 0
    stealTrack.BorderSizePixel = 0
    stealTrack.ZIndex = 501
    Instance.new("UICorner", stealTrack).CornerRadius = UDim.new(0, 10)

    progressFill = Instance.new("Frame", stealTrack)
    progressFill.Name = "StealProgressFill"
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    progressFill.BackgroundTransparency = 0
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 502
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 10)

    local fillGrad = Instance.new("UIGradient", progressFill)
    fillGrad.Rotation = 90
    fillGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 190, 70)),
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 150, 40)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(230, 110, 20)),
    })

    local fillStroke = Instance.new("UIStroke", progressFill)
    fillStroke.Name = "FillStroke"
    fillStroke.Color = Color3.fromRGB(255, 170, 50)
    fillStroke.Thickness = 1
    fillStroke.Transparency = 0.1

    progressPct = Instance.new("TextLabel", stealTrack)
    progressPct.Name = "StealProgressPercent"
    progressPct.Size = UDim2.new(0, 40, 1, 0)
    progressPct.Position = UDim2.new(0, 150, 0, 0)
    progressPct.BackgroundTransparency = 1
    progressPct.Text = "0%"
    progressPct.TextColor3 = Color3.fromRGB(245, 248, 252)
    progressPct.Font = Enum.Font.GothamBold
    progressPct.TextSize = 9
    progressPct.TextXAlignment = Enum.TextXAlignment.Left
    progressPct.TextStrokeTransparency = 0.4
    progressPct.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    progressPct.ZIndex = 504

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

    -- ============================================================
    -- BAT V3: logica del bat aimbot de MVP
    -- ============================================================
    local V3 = {
        enabled = false, conn = nil,
        cfg = {
            FOLLOW_SPEED = 55, ACTIVATE_DISTANCE = 13, MIN_FOLLOW_DISTANCE = 1,
            PREDICTION_TIME = 0.22, PREDICT_AHEAD = 3, MAX_VELOCITY_CHANGE = 150,
            VELOCITY_SMOOTHING = 0.2, MAX_HORIZONTAL_VELOCITY = 80,
            SERVER_TICKRATE = 1/60, MIN_PING_COMPENSATION = 0.03, MAX_PING_COMPENSATION = 0.25,
            ACCELERATION_PREDICTION_WEIGHT = 0.3, DIRECTION_CHANGE_DETECTION_TIME = 0.12,
            QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5, GRAVITY = 196.2, AIR_CONTROL_FACTOR = 0.8,
            MIN_AIRBORNE_TIME = 0.08, SWING_COOLDOWN = 0.08,
        },
        st = {
            targetPlayer = nil, lastTargetPos = nil,
            targetVelocity = Vector3.zero, smoothedVelocity = Vector3.zero,
            velocityHistory = {}, accelerationHistory = {}, aerialVelocityHistory = {},
            verticalVelocityHistory = {}, previousDirection = nil,
            lastDirectionChangeTime = 0, airborneTime = 0, lastYVelocity = 0,
            lastActivationTime = 0, currentPing = 0.1, realPingMs = 0,
            previousAutoRotate = nil, previousHumanoid = nil,
            swingLocked = false, nextSwingAt = 0,
        },
    }

    function V3.avg(list)
        if #list == 0 then return Vector3.zero end
        local sum = Vector3.zero
        for _, v in ipairs(list) do sum = sum + v end
        return sum / #list
    end

    function V3.push(list, value, maxSize)
        table.insert(list, value)
        if #list > maxSize then table.remove(list, 1) end
    end

    function V3.reset()
        local s = V3.st
        s.targetPlayer = nil; s.lastTargetPos = nil
        s.targetVelocity = Vector3.zero; s.smoothedVelocity = Vector3.zero
        s.velocityHistory = {}; s.accelerationHistory = {}
        s.aerialVelocityHistory = {}; s.verticalVelocityHistory = {}
        s.previousDirection = nil; s.airborneTime = 0; s.lastYVelocity = 0
    end

    function V3.findBat()
        local char = LP.Character
        if not char then return nil end
        local equipped = char:FindFirstChildOfClass("Tool")
        if equipped then
            local n = equipped.Name:lower()
            if n:find("bat") or n:find("slap") then return equipped end
        end
        local bp = LP:FindFirstChildOfClass("Backpack")
        if bp then
            for _, tool in ipairs(bp:GetChildren()) do
                if tool:IsA("Tool") then
                    local n = tool.Name:lower()
                    if n:find("bat") or n:find("slap") then return tool end
                end
            end
        end
        return nil
    end

    function V3.nearest(myRoot)
        local nearest, nearestDist = nil, math.huge
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LP and player.Character then
                local tr = player.Character:FindFirstChild("HumanoidRootPart")
                local th = player.Character:FindFirstChildOfClass("Humanoid")
                if tr and th and th.Health > 0 then
                    local d = (tr.Position - myRoot.Position).Magnitude
                    if d < nearestDist then nearestDist = d; nearest = player end
                end
            end
        end
        return nearest, nearestDist
    end

    function V3.face(myRoot, direction)
        if direction.Magnitude < 0.01 then return end
        local cross = myRoot.CFrame.LookVector:Cross(direction.Unit)
        local angle = math.asin(math.clamp(cross.Magnitude, -1, 1))
        myRoot.AssemblyAngularVelocity = cross.Magnitude > 0.01
            and cross.Unit * angle * 80
            or Vector3.zero
    end

    function V3.updatePing()
        local ok, ping = pcall(function()
            return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
        end)
        if ok and type(ping) == "number" then V3.st.realPingMs = math.floor(ping) end
        V3.st.currentPing = math.clamp(V3.st.realPingMs / 1000, V3.cfg.MIN_PING_COMPENSATION, V3.cfg.MAX_PING_COMPENSATION)
    end

    function V3.swing()
        local s, cfg = V3.st, V3.cfg
        local now = tick()
        if s.swingLocked or now < s.nextSwingAt then return end
        s.swingLocked = true
        s.nextSwingAt = now + cfg.SWING_COOLDOWN
        pcall(function()
            local char = LP.Character
            if not char then return end
            local bat = V3.findBat()
            if not bat then return end
            if bat.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum:EquipTool(bat) end
            end
            bat:Activate()
            local remote = bat:FindFirstChildWhichIsA("RemoteEvent")
            if remote then remote:FireServer() end
        end)
        task.delay(cfg.SWING_COOLDOWN, function() s.swingLocked = false end)
    end

    function V3.loop(dt)
        local s, cfg = V3.st, V3.cfg
        local spd = tonumber(State and State.bypassBatSpeed) or tonumber(BYPASS_AIMBOT_SPEED) or 55
        if spd ~= spd or spd <= 0 or spd == math.huge then spd = 55 end
        cfg.FOLLOW_SPEED = spd
        if not V3.enabled then return end

        local char = LP.Character
        if not char then return end
        local myRoot = char:FindFirstChild("HumanoidRootPart")
        local myHum = char:FindFirstChildOfClass("Humanoid")
        if not myRoot or not myHum or myHum.Health <= 0 then return end

        myHum.AutoRotate = false

        if not char:FindFirstChildOfClass("Tool") then
            local bat = V3.findBat()
            if bat and bat.Parent ~= char then
                pcall(function() myHum:EquipTool(bat) end)
            end
        end

        local target = V3.nearest(myRoot)
        if not target or not target.Character then V3.reset(); return end
        local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
        local targetHum = target.Character:FindFirstChildOfClass("Humanoid")
        if not targetRoot or not targetHum or targetHum.Health <= 0 then V3.reset(); return end

        if s.targetPlayer ~= target then V3.reset() end
        s.targetPlayer = target

        V3.updatePing()

        local targetPos = targetRoot.Position
        local dtc = math.max(dt, 1/240)

        if s.lastTargetPos then
            local instantVel = (targetPos - s.lastTargetPos) / dtc
            local accel = instantVel - s.targetVelocity
            if accel.Magnitude > cfg.MAX_VELOCITY_CHANGE then
                instantVel = s.targetVelocity + accel.Unit * cfg.MAX_VELOCITY_CHANGE
            end
            local hv = Vector3.new(instantVel.X, 0, instantVel.Z)
            if hv.Magnitude > cfg.MAX_HORIZONTAL_VELOCITY then
                hv = hv.Unit * cfg.MAX_HORIZONTAL_VELOCITY
                instantVel = Vector3.new(hv.X, instantVel.Y, hv.Z)
            end
            V3.push(s.accelerationHistory, (instantVel - s.targetVelocity) / dtc, 4)
            V3.push(s.velocityHistory, instantVel, 8)
            V3.push(s.verticalVelocityHistory, instantVel.Y, 5)
            s.targetVelocity = instantVel
            s.smoothedVelocity = s.smoothedVelocity:Lerp(instantVel, cfg.VELOCITY_SMOOTHING)
        end
        s.lastTargetPos = targetPos

        local isAirborne = targetHum.FloorMaterial == Enum.Material.Air
        s.airborneTime = isAirborne and (s.airborneTime + dtc) or 0
        if isAirborne and s.airborneTime >= cfg.MIN_AIRBORNE_TIME then
            V3.push(s.aerialVelocityHistory, s.targetVelocity, 6)
        elseif not isAirborne then
            s.aerialVelocityHistory = {}
        end

        local smoothedVel = s.smoothedVelocity
        if isAirborne and #s.aerialVelocityHistory > 0 then
            local avgAerial = V3.avg(s.aerialVelocityHistory)
            smoothedVel = Vector3.new(avgAerial.X, s.targetVelocity.Y, avgAerial.Z) * cfg.AIR_CONTROL_FACTOR
        end

        local isQuickTurn = false
        local htv = Vector3.new(s.targetVelocity.X, 0, s.targetVelocity.Z)
        if htv.Magnitude > 5 then
            local newDir = htv.Unit
            if s.previousDirection and s.previousDirection:Dot(newDir) < 0.5 then
                isQuickTurn = (tick() - s.lastDirectionChangeTime) < cfg.DIRECTION_CHANGE_DETECTION_TIME
                s.lastDirectionChangeTime = tick()
            end
            s.previousDirection = newDir
        end

        local serverDelay = s.currentPing + cfg.SERVER_TICKRATE
        local adjustedDelay = isQuickTurn and (serverDelay * cfg.QUICK_DIRECTION_CHANGE_MULTIPLIER) or serverDelay

        local avgAccel = V3.avg(s.accelerationHistory)
        local accelContribution = avgAccel * cfg.ACCELERATION_PREDICTION_WEIGHT * (adjustedDelay * adjustedDelay * 0.5)
        local predictedPos = targetPos + smoothedVel * adjustedDelay + accelContribution

        local predictionTime = cfg.PREDICTION_TIME * 1.1
        if isAirborne then
            predictedPos = predictedPos + smoothedVel * predictionTime
                + Vector3.new(0, -0.5 * cfg.GRAVITY * predictionTime * predictionTime, 0)
        else
            predictedPos = predictedPos + smoothedVel * predictionTime
        end

        local hs = Vector3.new(smoothedVel.X, 0, smoothedVel.Z)
        if hs.Magnitude > 1 then
            predictedPos = predictedPos + hs.Unit * cfg.PREDICT_AHEAD
        end

        local direction = predictedPos - myRoot.Position
        V3.face(myRoot, direction)

        if (targetPos - myRoot.Position).Magnitude <= cfg.ACTIVATE_DISTANCE then
            if tick() - s.lastActivationTime >= 0.3 then
                V3.swing()
                s.lastActivationTime = tick()
            end
        end

        if direction.Magnitude > cfg.MIN_FOLLOW_DISTANCE then
            myRoot.AssemblyLinearVelocity = direction.Unit * cfg.FOLLOW_SPEED
        else
            local cv = myRoot.AssemblyLinearVelocity
            myRoot.AssemblyLinearVelocity = Vector3.new(0, cv.Y * 0.5, 0)
        end
    end

    function V3.start()
        if V3.enabled then return end
        V3.enabled = true
        if _suppressBodyLock then pcall(_suppressBodyLock) end
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum then
            V3.st.previousHumanoid = hum
            V3.st.previousAutoRotate = hum.AutoRotate
            hum.AutoRotate = false
        end
        V3.reset()
        V3.st.lastActivationTime = 0
        V3.conn = RunService.RenderStepped:Connect(function(dt)
            if _mySession ~= _G.RivalHubSession then
                if _G.__RivalHubStopBatV2 then pcall(_G.__RivalHubStopBatV2) end
                return
            end
            pcall(V3.loop, dt)
        end)
    end

    function V3.stop()
        if not V3.enabled then return end
        V3.enabled = false
        if V3.conn then V3.conn:Disconnect(); V3.conn = nil end
        local char = LP.Character
        if char then
            local myRoot = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if myRoot then
                myRoot.AssemblyLinearVelocity = Vector3.zero
                myRoot.AssemblyAngularVelocity = Vector3.zero
            end
            local prev = V3.st.previousHumanoid
            if prev and prev.Parent then
                prev.AutoRotate = V3.st.previousAutoRotate == nil and true or V3.st.previousAutoRotate
            elseif hum then
                hum.AutoRotate = true
            end
        end
        V3.st.previousHumanoid = nil
        V3.st.previousAutoRotate = nil
        V3.reset()
        if _unsuppressBodyLock then pcall(_unsuppressBodyLock, true) end
    end

    -- ============================================================
    -- SELECTOR V2 / V3 (el boton flotante usa la version elegida)
    -- ============================================================
    _G.__RivalHubBatVersion = (_G.__RivalHubBatVersion == "v3") and "v3" or "v2"
    local BatCtl = {}

    function BatCtl.isOn()
        return V2.enabled == true or V3.enabled == true
    end

    function BatCtl.stop()
        if V3.enabled then V3.stop() end
        stopBatV2()
    end

    function BatCtl.start()
        if V3.enabled then V3.stop() end
        if V2.enabled then stopBatV2() end
        if _G.__RivalHubBatVersion == "v3" then
            V3.start()
        else
            startBatV2()
        end
    end

    function BatCtl.setVersion(ver)
        ver = (ver == "v3") and "v3" or "v2"
        local wasOn = BatCtl.isOn()
        if wasOn then BatCtl.stop() end
        _G.__RivalHubBatVersion = ver
        if _G.updateBatVersionUI then pcall(_G.updateBatVersionUI, ver) end
        if _G.__RivalHubRefreshBatLabel then pcall(_G.__RivalHubRefreshBatLabel) end
        if wasOn then BatCtl.start() end
        if saveAllSettings then pcall(saveAllSettings) end
    end

    _G.__RivalHubStartBatV2 = BatCtl.start
    _G.__RivalHubStopBatV2  = BatCtl.stop
    _G.__RivalHubIsBatV2    = BatCtl.isOn
    _G.__RivalHubSetBatVersion = BatCtl.setVersion

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

    local BTN_W, BTN_H = 80, 48
    local buttons = {}
    local buttonNames = {"DropBR", "AutoLeft", "AutoBat", "AutoRight", "TpDown", "Carry", "Lagger1", "Lagger2", "BatV2", "Float"}
    local buttonTexts = {"DROP\nBR", "AUTO\nLEFT", "BYPASS\nBAT", "AUTO\nRIGHT", "TP\nDOWN", "CARRY\nSPEED", "LAGGER\nNORMAL", "LAGGER\nCARRY", "BAT\nV2", "FLOAT"}

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
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 255, 255)),
            ColorSequenceKeypoint.new(0.45, Color3.fromRGB(225, 232, 242)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(180, 190, 205)),
        })

        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(255, 255, 255)
        stroke.Thickness = 1.6
        stroke.Transparency = 0.05
        stroke.Name = "NormalStroke"

        local label = Instance.new("TextLabel", btn)
        label.Name = "TextLabel"
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = Color3.fromRGB(35, 38, 48)
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
                    laggerCarryToggled = false; laggerToggled = false; setActive(false)
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
                if _G.__RivalHubBatSetVisual then pcall(_G.__RivalHubBatSetVisual, _G.__RivalHubIsBatV2() == true) end
            end
        end
        if name == "Float" then
            callback = function(setActive)
                if _G.__RivalHubFloatToggle then _G.__RivalHubFloatToggle() end
                setActive(_G.__RivalHubFloatIsRunning and _G.__RivalHubFloatIsRunning() or false)
            end
        end
        local setActive = createButton(name, text, i-1, true, callback)
        if name == "Float" then mobSetFloat = setActive end
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

    _G.__RivalHubRefreshBatLabel = function()
        local b = buttons.BatV2
        if b and b.label then
            b.label.Text = (_G.__RivalHubBatVersion == "v3") and "BAT\nV3" or "BAT\nV2"
        end
    end
    pcall(_G.__RivalHubRefreshBatLabel)

    if buttons.AutoBat and buttons.AutoBat.setActive then buttons.AutoBat.setActive(autoBatEnabled) end
    if buttons.AutoLeft and buttons.AutoLeft.setActive then buttons.AutoLeft.setActive(autoLeftEnabled) end
    if buttons.AutoRight and buttons.AutoRight.setActive then buttons.AutoRight.setActive(autoRightEnabled) end
    if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(speedMode) end
    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(laggerToggled) end
    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(laggerCarryToggled) end
    if buttons.BatV2 and buttons.BatV2.setActive then
        buttons.BatV2.setActive(_G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2() or false)
    end
    if buttons.Float and buttons.Float.setActive then
        buttons.Float.setActive(_G.__RivalHubFloatIsRunning and _G.__RivalHubFloatIsRunning() or false)
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
    if setSmallButtonsVisual then setSmallButtonsVisual() end

    if uiLocked and setLockUIVisual then setLockUIVisual(true) end

    if _G.updateBatVersionUI then pcall(_G.updateBatVersionUI, _G.__RivalHubBatVersion or "v2") end
    if _G.__RivalHubRefreshBatLabel then pcall(_G.__RivalHubRefreshBatLabel) end

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
        autoLeftEnabledReleased = not autoLeftEnabled
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
    if kbMatch(KB.Float, kc) then
        if _G.__RivalHubFloatToggle then _G.__RivalHubFloatToggle() end
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
        completeBorder.Color = ESP_ORANGE or Color3.fromRGB(255, 130, 20)
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
        lineFill.BackgroundColor3 = ESP_ORANGE or Color3.fromRGB(255, 130, 20)
        lineFill.BorderSizePixel = 0
        lineFill.ZIndex = 7
        Instance.new("UICorner", lineFill).CornerRadius = UDim.new(1, 0)

        local label = Instance.new("TextLabel", strip)
        label.Name = "EnterLabel"
        label.Size = UDim2.new(1, -32, 1, -16)
        label.Position = UDim2.fromOffset(16, 8)
        label.BackgroundTransparency = 1
        label.Text = "DON'T ENTER"
        label.TextColor3 = ESP_ORANGE or Color3.fromRGB(255, 130, 20) -- mismo color que la linea ESP
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
        local function abortIf()
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
        if abortIf() then return end

        local revealTime = 1.9
        local elapsed = 0
        while elapsed < revealTime do
            lineFill.Size = UDim2.new(math.clamp(elapsed / revealTime, 0, 1), 0, 1, 0)
            elapsed = elapsed + task.wait()
            if abortIf() then return end
        end
        lineFill.Size = UDim2.new(1, 0, 1, 0)
        completeBorder.Transparency = 0
        label.Text = "ENTER"
        label.TextTransparency = 1
        TS:Create(label, TweenInfo.new(0.18), {TextTransparency = 0}):Play()
        task.wait(0.3)
        if abortIf() then return end
        TS:Create(scale, TweenInfo.new(0.38, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Scale = 1.35}):Play()
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
-- Clean Hub: KATANA + SONIDO DE LA KATANA
-- ============================================================
do
    local CleanKatanaPlayers = game:GetService("Players")
    local CleanKatanaLP = CleanKatanaPlayers.LocalPlayer
    local CLEAN_SLASH_SOUND = "rbxassetid://111808555599832"
    local cleanKatanaController

    local function createKatanaSkinController()
        local katanaPlayersService = game:GetService("Players")
        local katanaInsertService = game:GetService("InsertService")
        local katanaLighting = game:GetService("Lighting")
        local katanaReplicatedStorage = game:GetService("ReplicatedStorage")
        local katanaPlayer = katanaPlayersService.LocalPlayer
        local katanaColors = {
            red = Color3.new(0.784314, 0, 0),
            red2 = Color3.new(1, 0, 0.392157),
            gold = Color3.new(1, 0.843137, 0),
        }
        local katanaState = {
            Skin = "KATANA",
            SkinOrder = {"KATANA", "NONE"},
            LastBat = nil,
            LastAppliedSkin = nil,
            OriginalKatanaTemplate = nil,
            ExactTemplates = {},
            ExactTemplateSearched = {},
            ExactAssetIds = {KATANA = ""},
            Original = {},
        }
        local function findBat()
            local character = katanaPlayer.Character
            if character then
                local bat = character:FindFirstChild("Bat")
                if bat and bat:IsA("Tool") then return bat end
            end
            local backpack = katanaPlayer:FindFirstChildOfClass("Backpack")
            if backpack then
                local bat = backpack:FindFirstChild("Bat")
                if bat and bat:IsA("Tool") then return bat end
            end
            backpack = katanaPlayer:FindFirstChildOfClass("Backpack")
            for _, container in ipairs({katanaPlayer.Character, backpack}) do
                if container then
                    for _, tool in ipairs(container:GetChildren()) do
                        if tool:IsA("Tool") and tool.Name:lower():find("bat", 1, true) then return tool end
                    end
                end
            end
            return nil
        end
        local function configureVisualPart(part)
            if not part or not part:IsA("BasePart") then return end
            part.Anchored = false
            part.CanCollide = false
            part.CanTouch = false
            part.CanQuery = false
            part.Massless = true
        end
        local function weldToHandle(part1, part0)
            if not part1 or not part0 or not part1:IsA("BasePart") or not part0:IsA("BasePart") then return end
            configureVisualPart(part1)
            local wc = Instance.new("WeldConstraint")
            wc.Name = "FlowerSkin_AssetWeld"
            wc.Part0 = part0
            wc.Part1 = part1
            wc.Parent = part1
        end
        local function cacheOriginalBatState(batTool)
            if not batTool then return end
            local handle = batTool:FindFirstChild("Handle")
            local slash = batTool:FindFirstChild("Slash")
            katanaState.Original[batTool] = katanaState.Original[batTool] or {}
            local o = katanaState.Original[batTool]
            if handle and handle:IsA("BasePart") and not o.Handle then
                o.Handle = {Transparency = handle.Transparency, LocalTransparencyModifier = handle.LocalTransparencyModifier, CastShadow = handle.CastShadow}
            end
            if slash and slash:IsA("Sound") and not o.SlashSoundId then o.SlashSoundId = slash.SoundId end
        end
        local function captureOriginalKatanaTemplate()
            if katanaState.OriginalKatanaTemplate then return end
            local function scanContainer(container)
                if not container then return end
                local bat = container:FindFirstChild("Bat")
                if not bat then return end
                local f = bat:FindFirstChild("FlowerSkin_KatanaRealistic")
                f = f and f:FindFirstChild("FlowerSkin_AssetKatana")
                if f then katanaState.OriginalKatanaTemplate = f:Clone() end
            end
            scanContainer(katanaPlayer:FindFirstChildOfClass("Backpack"))
            scanContainer(katanaPlayer.Character)
        end
        local function setBatHandleHidden(batTool, hidden)
            local handle523 = batTool and batTool:FindFirstChild("Handle")
            if not handle523 or not handle523:IsA("BasePart") then return end
            cacheOriginalBatState(batTool)
            if hidden then
                handle523.LocalTransparencyModifier = 1
                handle523.Transparency = 1
                handle523.CastShadow = false
            else
                local h = katanaState.Original[batTool] and katanaState.Original[batTool].Handle
                handle523.LocalTransparencyModifier = h and h.LocalTransparencyModifier or 0
                handle523.Transparency = h and h.Transparency or 0
                handle523.CastShadow = h and h.CastShadow
                if handle523.CastShadow == nil then handle523.CastShadow = true end
            end
        end
        local function setBatSlashSound(batTool, soundId)
            cacheOriginalBatState(batTool)
            local slash = batTool and batTool:FindFirstChild("Slash")
            if slash and slash:IsA("Sound") then
                if not soundId then
                    soundId = katanaState.Original[batTool] and katanaState.Original[batTool].SlashSoundId or slash.SoundId
                end
                slash.SoundId = soundId
            end
        end
        local function restoreOriginalBatVisual(batTool)
            if not batTool then return end
            local f = batTool:FindFirstChild("FlowerSkin_KatanaRealistic")
            if f then f:Destroy() end
            local fa = batTool:FindFirstChild("FlowerSkin_AssetKatana")
            if fa then fa:Destroy() end
            setBatHandleHidden(batTool, false)
            setBatSlashSound(batTool, nil)
        end
        local function addKatanaRedEffects(parent)
            if not parent or not parent:IsA("BasePart") then return end
            local old = parent:FindFirstChild("FictionHubSpeedIndicator")
            if old then old:Destroy() end
            local topAtt = Instance.new("Attachment")
            topAtt.Name = "FlowerSkin_ExtraRedVFX"
            topAtt.Position = Vector3.new(0, parent.Size.Y * 0.5, 0)
            topAtt.Parent = parent
            local botAtt = Instance.new("Attachment")
            botAtt.Name = "FlowerSkin_ExtraRedVFX_End"
            botAtt.Position = Vector3.new(0, -parent.Size.Y * 0.5, 0)
            botAtt.Parent = parent
            local trail = Instance.new("Trail")
            trail.Name = "FlowerSkin_ExtraRedVFX"
            trail.Attachment0 = topAtt
            trail.Attachment1 = botAtt
            trail.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, katanaColors.red2),
                ColorSequenceKeypoint.new(1, Color3.new(0.54902, 0, 0)),
            })
            trail.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.35),
                NumberSequenceKeypoint.new(1, 1),
            })
            trail.Lifetime = 0.18
            trail.LightEmission = 0.55
            trail.Parent = parent
            local pe = Instance.new("ParticleEmitter")
            pe.Name = "FlowerSkin_ExtraRedVFX"
            pe.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.new(0.784314, 0, 0)),
                ColorSequenceKeypoint.new(1, katanaColors.red2),
            })
            pe.LightEmission = 0.55
            pe.Rate = 14
            pe.Lifetime = NumberRange.new(0.3, 0.45)
            pe.Speed = NumberRange.new(0.2, 0.7)
            pe.SpreadAngle = Vector2.new(12, 12)
            pe.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.08),
                NumberSequenceKeypoint.new(1, 0),
            })
            pe.Texture = "rbxasset://textures/particles/sparkles_main.dds"
            pe.Parent = parent
        end
        local function createKatanaPart(parent, name, size, cfOffset, color, material)
            local part = Instance.new("Part")
            part.Name = name
            part.Size = size
            part.Color = color
            part.Material = material or Enum.Material.Neon
            part.TopSurface = Enum.SurfaceType.Smooth
            part.BottomSurface = Enum.SurfaceType.Smooth
            configureVisualPart(part)
            part.Parent = parent
            return part, cfOffset or CFrame.identity
        end
        local katanaCandidateNames = {KATANA = {"FlowerSkin_AssetKatana", "Katana", "FlowerSkin_KatanaRealistic"}}
        local function isScriptInstance(instance)
            return instance:IsA("Script") or instance:IsA("LocalScript") or instance:IsA("ModuleScript")
        end
        local function removeScripts(root)
            if not root then return end
            if isScriptInstance(root) then root:Destroy(); return end
            for _, d in ipairs(root:GetDescendants()) do
                if isScriptInstance(d) then d:Destroy() end
            end
        end
        local function hasBasePart(candidate)
            if not candidate then return false end
            if candidate:IsA("BasePart") then return true end
            return candidate:FindFirstChildWhichIsA("BasePart", true) ~= nil
        end
        local function isGeneratedSkin(candidate)
            local ok, result = pcall(function() return candidate:GetAttribute("CursedBatSkinsGenerated") end)
            return ok and result == true
        end
        local function validateSkinCandidate(candidate)
            if not candidate or isGeneratedSkin(candidate) then return nil end
            if candidate:IsA("Model") or candidate:IsA("Tool") or candidate:IsA("Accessory") or candidate:IsA("BasePart") then
                if hasBasePart(candidate) then return candidate end
            end
            return nil
        end
        local function findNamedSkinCandidate(root, candidateNames)
            if not root then return nil end
            for _, entry in ipairs(candidateNames) do
                if root.Name ~= entry then continue end
                local c = validateSkinCandidate(root)
                if c then return c end
            end
            for _, cn in ipairs(candidateNames) do
                local inst = root:FindFirstChild(cn, true)
                local v = validateSkinCandidate(inst)
                if v then return v end
            end
            return nil
        end
        local function normalizeAssetId(assetId)
            local n = tostring(assetId or ""):gsub("%s+", "")
            if n == "" then return nil end
            if n:match("^rbxassetid://") or n:match("^rbxasset://") then return n end
            if n:match("^%d+$") then return "rbxassetid://" .. n end
            return n
        end
        local function loadAssetSkinTemplate(skinName)
            local uri = normalizeAssetId(katanaState.ExactAssetIds[skinName])
            if not uri then return nil end
            local loaded = {}
            pcall(function() loaded = game:GetObjects(uri) end)
            if #loaded == 0 then
                local m = tostring(uri):match("(%d+)")
                if m then pcall(function() table.insert(loaded, katanaInsertService:LoadAsset(tonumber(m))) end) end
            end
            local names = katanaCandidateNames[skinName] or {}
            for _, entry in ipairs(loaded) do
                local c = findNamedSkinCandidate(entry, names) or validateSkinCandidate(entry)
                if c then
                    local clone = c:Clone()
                    removeScripts(clone)
                    return clone
                end
            end
            return nil
        end
        local function findExistingSkinTemplate(skinName)
            local names = katanaCandidateNames[skinName]
            if not names then return nil end
            local roots = {katanaPlayer.Character, katanaPlayer:FindFirstChildOfClass("Backpack"), katanaReplicatedStorage, katanaLighting, workspace}
            for _, entry in ipairs(roots) do
                local c = findNamedSkinCandidate(entry, names)
                if c then
                    local clone = c:Clone()
                    removeScripts(clone)
                    return clone
                end
            end
            return nil
        end
        local function getSkinTemplate(skinName)
            if skinName == "KATANA" and katanaState.OriginalKatanaTemplate then return katanaState.OriginalKatanaTemplate end
            if katanaState.ExactTemplates[skinName] then return katanaState.ExactTemplates[skinName] end
            if katanaState.ExactTemplateSearched[skinName] then return nil end
            katanaState.ExactTemplateSearched[skinName] = true
            local t = loadAssetSkinTemplate(skinName) or findExistingSkinTemplate(skinName)
            if t then katanaState.ExactTemplates[skinName] = t end
            return t
        end
        local normalizeSkinModel
        normalizeSkinModel = function(source, parent)
            if source:IsA("Model") then source.Name = "FlowerSkin_AssetKatana"; source.Parent = parent; return source end
            if source:IsA("BasePart") then
                local m = Instance.new("Model")
                m.Name = "FlowerSkin_AssetKatana"
                m.Parent = parent
                source.Parent = m
                return m
            end
            if source:IsA("Tool") or source:IsA("Folder") then
                local f = source:FindFirstChild("FlowerSkin_AssetKatana") or source:FindFirstChildWhichIsA("Model") or source:FindFirstChildWhichIsA("BasePart")
                if f and f.Parent == source then
                    f.Parent = nil
                    source:Destroy()
                    return normalizeSkinModel(f, parent)
                end
                local m = Instance.new("Model")
                m.Name = "FlowerSkin_AssetKatana"
                m.Parent = parent
                for _, c in ipairs(source:GetChildren()) do
                    if not isScriptInstance(c) then c.Parent = m end
                end
                source:Destroy()
                return m
            end
            return nil
        end
        local function applyExactSkinTemplate(batTool, skinName)
            local handle = batTool and batTool:FindFirstChild("Handle")
            if not handle or not handle:IsA("BasePart") then return false end
            local template = getSkinTemplate(skinName)
            if not template then return false end
            local folder = Instance.new("Folder")
            folder.Name = "FlowerSkin_KatanaRealistic"
            folder.Parent = batTool
            local skinModel = normalizeSkinModel(template:Clone(), folder)
            if not skinModel or not hasBasePart(skinModel) then folder:Destroy(); return false end
            removeScripts(skinModel)
            pcall(function() skinModel:SetAttribute("CursedBatSkinsExactMesh", true) end)
            local firstPart
            for _, d in ipairs(skinModel:GetDescendants()) do
                if d:IsA("BasePart") then
                    firstPart = firstPart or d
                    configureVisualPart(d)
                end
            end
            if not firstPart then folder:Destroy(); return false end
            if skinModel:IsA("Model") then
                skinModel.PrimaryPart = skinModel.PrimaryPart or firstPart
                pcall(function() skinModel:PivotTo(handle.CFrame) end)
            end
            for _, d in ipairs(skinModel:GetDescendants()) do
                if d:IsA("BasePart") then weldToHandle(d, handle) end
            end
            local weaponPart = skinModel:FindFirstChild("SharpParts", true) or skinModel:FindFirstChild("WeaponPart", true) or skinModel:FindFirstChild("Handle", true) or firstPart
            if weaponPart and not weaponPart:FindFirstChild("FlowerSkin_ExtraRedVFX") then addKatanaRedEffects(weaponPart) end
            return true
        end
        local function createProceduralKatana(batTool, skinName)
            local handle = batTool and batTool:FindFirstChild("Handle")
            if not handle or not handle:IsA("BasePart") then return nil end
            local folder = Instance.new("Folder")
            folder.Name = "FlowerSkin_KatanaRealistic"
            folder.Parent = batTool
            local model = Instance.new("Model")
            model.Name = "FlowerSkin_AssetKatana"
            model:SetAttribute("CursedBatSkinsGenerated", true)
            model.Parent = folder
            local created = {}
            local function createPart(name, size, cfOffset, color, material)
                local p, off = createKatanaPart(model, name, size, cfOffset, color, material)
                p.CFrame = handle.CFrame * off
                weldToHandle(p, handle)
                table.insert(created, p)
                return p
            end
            if skinName == "KATANA" then
                createPart("Handle2", Vector3.new(0.22, 1, 0.22), CFrame.new(0, -0.48, 0), Color3.new(0.176471, 0.176471, 0.045), Enum.Material.Metal)
                local sp = createPart("SharpParts", Vector3.new(0.18, 2.4, 0.12), CFrame.new(0, 1.05, 0), katanaColors.red2, Enum.Material.Neon)
                createPart("WeaponPart", Vector3.new(0.3, 2.7, 0.08), CFrame.new(0.08, 1.15, 0), katanaColors.red, Enum.Material.Neon)
                createPart("GoldAccent", Vector3.new(0.5, 0.12, 0.08), CFrame.new(0, -0.28, 0), katanaColors.gold, Enum.Material.Neon)
                addKatanaRedEffects(sp)
            end
            model.PrimaryPart = created[1]
            return model
        end
        local slashSoundIds = {KATANA = "rbxassetid://111808555599832"}
        return {
            State = katanaState,
            ApplySkin = function(skinName)
                captureOriginalKatanaTemplate()
                local lastBat = findBat()
                if not lastBat then
                    katanaState.LastBat = nil
                    katanaState.LastAppliedSkin = nil
                    return false
                end
                cacheOriginalBatState(lastBat)
                restoreOriginalBatVisual(lastBat)
                if skinName == "NONE" then
                    katanaState.LastBat = lastBat
                    katanaState.LastAppliedSkin = skinName
                    return true
                end
                setBatHandleHidden(lastBat, true)
                setBatSlashSound(lastBat, slashSoundIds[skinName])
                if not applyExactSkinTemplate(lastBat, skinName) then createProceduralKatana(lastBat, skinName) end
                local handle = lastBat:FindFirstChild("Handle")
                if handle then
                    local fire = handle:FindFirstChildOfClass("Fire") or handle:FindFirstChild("Fire")
                    if fire and fire:IsA("Fire") then
                        fire.Enabled = true
                        fire.Color = katanaColors.red
                        fire.SecondaryColor = katanaColors.red2
                    end
                end
                katanaState.LastBat = lastBat
                katanaState.LastAppliedSkin = skinName
                return true
            end,
            SetExactAssetId = function(assetId)
                katanaState.ExactAssetIds.KATANA = tostring(assetId or "")
                katanaState.ExactTemplateSearched.KATANA = nil
                katanaState.ExactTemplates.KATANA = nil
            end,
        }
    end
    cleanKatanaController = createKatanaSkinController()
    _G.CursedBatKatana = cleanKatanaController
    _G.CleanKatana = {controller = cleanKatanaController, slashSound = CLEAN_SLASH_SOUND}

    task.spawn(function()
        while true do
            pcall(function()
                local char = CleanKatanaLP.Character
                local backpack = CleanKatanaLP:FindFirstChildOfClass("Backpack")
                local bat = nil
                for _, container in ipairs({char, backpack}) do
                    if container and not bat then
                        local b = container:FindFirstChild("Bat")
                        if b and b:IsA("Tool") then bat = b end
                    end
                end
                if not bat then
                    for _, container in ipairs({char, backpack}) do
                        if container and not bat then
                            for _, tool in ipairs(container:GetChildren()) do
                                if tool:IsA("Tool") and tool.Name:lower():find("bat", 1, true) then
                                    bat = tool
                                    break
                                end
                            end
                        end
                    end
                end
                if bat then
                    local st = cleanKatanaController.State
                    if bat ~= st.LastBat or st.LastAppliedSkin ~= "KATANA" then cleanKatanaController.ApplySkin("KATANA") end
                    local slash = bat:FindFirstChild("Slash")
                    if slash and slash:IsA("Sound") and slash.SoundId ~= CLEAN_SLASH_SOUND then slash.SoundId = CLEAN_SLASH_SOUND end
                end
            end)
            task.wait(0.5)
        end
    end)
end
-- ============================================================

-- ============================================================
-- shel.Vs: SKIN DE LA MEDUSA (BOMBA PIXELADA)
-- ============================================================
do
    local SkinPlayers = game:GetService("Players")
    local SkinLP = SkinPlayers.LocalPlayer

    local function isMedusaSkinTool(obj)
        if not obj or not obj:IsA("Tool") then return false end
        local n = obj.Name:lower()
        return n:find("medusa", 1, true) ~= nil or n:find("head", 1, true) ~= nil or n:find("stone", 1, true) ~= nil
    end

    local function removeBombSkin(tool)
        local f = tool:FindFirstChild("ShelMedusaBombSkin")
        if f then f:Destroy() end
        if tool:GetAttribute("ShelMedusaBombSkin") then
            tool:SetAttribute("ShelMedusaBombSkin", nil)
            for _, obj in ipairs(tool:GetDescendants()) do
                if obj:IsA("BasePart") then obj.LocalTransparencyModifier = 0 end
            end
        end
    end

    local function applyMedusaSkin(tool)
        if not isMedusaSkinTool(tool) then return end
        -- La bomba es la skin "Default"; con Skull / Golden Eagle se quita
        if (_G.RivalMedusaSkin or "Default") ~= "Default" then
            removeBombSkin(tool)
            return
        end
        if tool:GetAttribute("ShelMedusaBombSkin") and tool:FindFirstChild("ShelMedusaBombSkin") then return end
        local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart", true)
        if not handle or not handle:IsA("BasePart") then return end
        tool:SetAttribute("ShelMedusaBombSkin", true)

        -- solo se oculta lo visual; los sonidos de la medusa NO se tocan
        for _, obj in ipairs(tool:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.LocalTransparencyModifier = 1
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

        if not tool:GetAttribute("ShelMedusaDescHook") then
            tool:SetAttribute("ShelMedusaDescHook", true)
            tool.DescendantAdded:Connect(function(obj)
                if (_G.RivalMedusaSkin or "Default") ~= "Default" then return end
                if obj:FindFirstAncestor("ShelMedusaBombSkin") then return end
                if obj:IsA("BasePart") then obj.LocalTransparencyModifier = 1 end
            end)
        end
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

    _G.ShelMedusaSkin = {apply = scanSkinTools}
end
-- ============================================================

-- ============================================================
-- BRAINROT TRANSPARENTE (en la mano y en tu base) - efecto tipo rayos X (transparente + resaltado visible a traves de paredes)
-- ============================================================
do
    local LPl = game:GetService("Players").LocalPlayer
    local ALPHA_HELD = 0.85
    local ALPHA_BASE = 0.7
    local ATTR = "RHBrOrigT"
    local state = {held = true, base = true, heldDirty = false, baseDirty = false}

    local BODY = {
        Head=1, Torso=1, UpperTorso=1, LowerTorso=1, HumanoidRootPart=1,
        ["Left Arm"]=1, ["Right Arm"]=1, ["Left Leg"]=1, ["Right Leg"]=1,
        LeftUpperArm=1, LeftLowerArm=1, LeftHand=1, RightUpperArm=1, RightLowerArm=1, RightHand=1,
        LeftUpperLeg=1, LeftLowerLeg=1, LeftFoot=1, RightUpperLeg=1, RightLowerLeg=1, RightFoot=1,
    }

    -- La medusa (y sus skins) nunca se vuelve transparente
    local function isMedusaPiece(inst)
        local cur = inst
        while cur and cur ~= workspace and cur ~= game do
            if cur.Name == "RivalMedusaReplica" or cur.Name == "ShelMedusaBombSkin"
                or cur.Name:lower():find("medusa", 1, true) then
                return true
            end
            if cur:IsA("Tool") then
                local n = cur.Name:lower()
                if n:find("medusa", 1, true) or n:find("stone", 1, true) or n:find("head", 1, true) then
                    return true
                end
            end
            cur = cur.Parent
        end
        return false
    end

    local function setT(inst, on, alpha)
        if inst:IsA("BasePart") or inst:IsA("Decal") or inst:IsA("Texture") then
            local o = inst:GetAttribute(ATTR)
            if isMedusaPiece(inst) then
                -- si ya quedo transparente antes, se restaura y no se vuelve a tocar
                if o ~= nil then
                    inst.Transparency = o
                    inst:SetAttribute(ATTR, nil)
                end
                return
            end
            if on then
                if o == nil then o = inst.Transparency; inst:SetAttribute(ATTR, o) end
                local want = math.max(o, alpha)
                if inst.Transparency ~= want then inst.Transparency = want end
            elseif o ~= nil then
                inst.Transparency = o
                inst:SetAttribute(ATTR, nil)
            end
        end
    end

    -- Xray INVISIBLE: no aplica ningun resaltado de color, solo transparencia.
    local function setXray(root, on)
        local hl = root:FindFirstChild("RHBrXray")
        if on then
            if not hl then
                hl = Instance.new("Highlight")
                hl.Name = "RHBrXray"
                hl.Adornee = root
                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                hl.FillColor = Color3.fromRGB(255, 130, 20)
                hl.FillTransparency = 1      -- invisible
                hl.OutlineColor = Color3.fromRGB(255, 215, 130)
                hl.OutlineTransparency = 1   -- invisible
                hl.Parent = root
            else
                hl.FillTransparency = 1
                hl.OutlineTransparency = 1
            end
        elseif hl then
            hl:Destroy()
        end
    end

    local function applyTree(root, on, alpha)
        setT(root, on, alpha)
        for _, d in ipairs(root:GetDescendants()) do setT(d, on, alpha) end
        setXray(root, on)
    end

    local function topOf(part, char)
        local top = part
        local m = part:FindFirstAncestorOfClass("Model")
        while m and m ~= workspace and m ~= char and not m:IsDescendantOf(char) do
            top = m
            m = m.Parent and m.Parent:FindFirstAncestorOfClass("Model")
        end
        return top
    end

    local function heldTargets(char)
        local list, seen = {}, {}
        local function add(o) if o and not seen[o] then seen[o] = true; list[#list+1] = o end end

        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("Model") then
                add(child)
            elseif child:IsA("BasePart") and not BODY[child.Name] then
                add(child)
            end
        end

        local root = char:FindFirstChild("HumanoidRootPart")
        if root then
            local ok, connected = pcall(function() return root:GetConnectedParts(true) end)
            if ok and connected then
                for _, p in ipairs(connected) do
                    if not p:IsDescendantOf(char) then add(topOf(p, char)) end
                end
            end
        end
        return list
    end

    local function myPlot()
        local plots = workspace:FindFirstChild("Plots")
        if not plots then return nil end
        for _, plot in ipairs(plots:GetChildren()) do
            local sign = plot:FindFirstChild("PlotSign")
            local yb = sign and sign:FindFirstChild("YourBase")
            if yb and yb:IsA("BillboardGui") and yb.Enabled then return plot end
        end
        return nil
    end

    local lastHeld = {}
    local function processHeld(on)
        local char = LPl.Character
        if not char then return end
        local targets = heldTargets(char)
        for _, o in ipairs(targets) do
            applyTree(o, on, ALPHA_HELD)
            lastHeld[o] = true
        end
        local current = {}
        for _, o in ipairs(targets) do current[o] = true end
        for o in pairs(lastHeld) do
            if not current[o] then
                if o.Parent then applyTree(o, false, ALPHA_HELD) end
                lastHeld[o] = nil
            end
        end
    end

    local lastBase = {}
    local printed = {}
    local function baseTargets()
        local list, seen = {}, {}
        local function add(o) if o and not seen[o] then seen[o] = true; list[#list+1] = o end end
        local plot = myPlot()
        local pods = plot and plot:FindFirstChild("AnimalPodiums")
        if not pods then return list end

        local function isContainer(inst)
            return inst == workspace or inst == plot or inst == pods or inst.Parent == pods
                or inst:IsA("Folder")
        end

        for _, pod in ipairs(pods:GetChildren()) do
            local podBase = pod:FindFirstChild("Base")
            for _, c in ipairs(pod:GetChildren()) do
                if c ~= podBase and c:IsA("Model") and not c:FindFirstChildOfClass("Humanoid") then add(c) end
            end
            local spawnPart = podBase and podBase:FindFirstChild("Spawn")
            if spawnPart and spawnPart:IsA("BasePart") then
                local ok, parts = pcall(function()
                    return workspace:GetPartBoundsInRadius(spawnPart.Position + Vector3.new(0, 3, 0), 6)
                end)
                if ok and parts then
                    for _, part in ipairs(parts) do
                        if not part:IsDescendantOf(LPl.Character or workspace) or not LPl.Character then
                            local top = nil
                            local cur = part.Parent
                            while cur and not isContainer(cur) do
                                if cur:IsA("Model") then top = cur end
                                cur = cur.Parent
                            end
                            if top and top ~= pod and top ~= podBase and not top:IsAncestorOf(podBase)
                               and not top:FindFirstChild("Spawn", true)
                               and not top:FindFirstChildOfClass("Humanoid")
                               and not top:IsDescendantOf(podBase)
                               and not (LPl.Character and top:IsDescendantOf(LPl.Character)) then
                                add(top)
                            end
                        end
                    end
                end
            end
        end
        return list
    end

    local function processBase(on)
        local targets = baseTargets()
        local current = {}
        for _, o in ipairs(targets) do
            current[o] = true
            applyTree(o, on, ALPHA_BASE)
            lastBase[o] = true
            if on and not printed[o] then
                printed[o] = true
                pcall(function() print("[Rival Hub] Brainrot base transparente:", o:GetFullName()) end)
            end
        end
        for o in pairs(lastBase) do
            if not current[o] then
                if o.Parent then applyTree(o, false, ALPHA_BASE) end
                lastBase[o] = nil
            end
        end
    end

    _G.RHBrainrotTransparency = {
        SetHeld = function(v) state.held = v and true or false; state.heldDirty = true end,
        SetBase = function(v) state.base = v and true or false; state.baseDirty = true end,
    }

    task.spawn(function()
        while true do
            pcall(function()
                if state.held or state.heldDirty then processHeld(state.held); state.heldDirty = false end
            end)
            task.wait(0.1)
        end
    end)
    task.spawn(function()
        while true do
            pcall(function()
                if state.base or state.baseDirty then processBase(state.base); state.baseDirty = false end
            end)
            task.wait(0.4)
        end
    end)
end
-- ============================================================