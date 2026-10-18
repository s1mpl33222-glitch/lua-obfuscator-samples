-- ══════════════════════════════════════════════════════════════
-- MultiUI | MEGA COMBO ♟️ | v3.6 | Auto-Execute
-- Orden: Oso → Medusa → BlackBomb → Buscador
-- + Música Canción 7 (se apaga al quitar la intro)
-- ══════════════════════════════════════════════════════════════

local MY_ID    = "MultiUI_MegaCombo"
local MY_FLAG  = "MultiUI_MegaCombo_Running"
local MY_INTRO = "BigAmateuzIntro_MegaCombo"

if getgenv and getgenv()[MY_FLAG] then
    warn("[MultiUI] Ya está en ejecución. Abortando duplicado.")
    return
end
if getgenv then getgenv()[MY_FLAG] = true end

repeat task.wait() until game:IsLoaded()

local Players      = game:GetService("Players")
local UIS          = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local RunService   = game:GetService("RunService")
local HttpService  = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")

local player = Players.LocalPlayer

local CONFIG = {
    SaveFile      = "MultiUI_MegaCombo_Positions.json",
    ComboCooldown = 0,
    DragThreshold = 6,
}

local ZOMBIE_SOUND_CANDIDATES = {
    "rbxassetid://1837852376",
    "rbxassetid://9046675791",
    "rbxassetid://6895126048",
    "rbxassetid://6042053626",
    "rbxassetid://3360230045",
}

-- ── CANCIÓN 7 (del Crossbow) ──
local COMBO_SONG_URL  = "https://files.catbox.moe/iyw1cb.mp3"
local COMBO_SONG_FILE = "ZenoDuelSong_7.mp3"
local COMBO_SONG_VOL  = 0.5

local comboMusicCache = nil
local currentComboMusic = nil

local function stopComboMusic()
    if currentComboMusic then
        pcall(function() currentComboMusic:Stop() end)
        pcall(function() currentComboMusic:Destroy() end)
        currentComboMusic = nil
    end
end

local function resolveComboSongId()
    if comboMusicCache then return comboMusicCache end
    local ok, id = pcall(function()
        if not (writefile and isfile and getcustomasset) then return nil end
        local has = false
        pcall(function() has = isfile(COMBO_SONG_FILE) end)
        if not has then
            pcall(function()
                local data = game:HttpGet(COMBO_SONG_URL)
                if data and #data > 0 then writefile(COMBO_SONG_FILE, data) end
            end)
        end
        local sid = nil
        pcall(function()
            if isfile(COMBO_SONG_FILE) then
                sid = getcustomasset(COMBO_SONG_FILE)
            end
        end)
        return sid
    end)
    if ok and id then comboMusicCache = id end
    return comboMusicCache
end

local function playComboMusic()
    task.spawn(function()
        stopComboMusic()
        local soundId = resolveComboSongId()
        if not soundId then return end
        local s = Instance.new("Sound")
        s.Name = "MegaComboSong"
        s.SoundId = soundId
        s.Volume = COMBO_SONG_VOL
        s.Looped = false
        s.TimePosition = 0
        s.Parent = SoundService
        currentComboMusic = s
        pcall(function() s:Play() end)
        s.Ended:Connect(function()
            if currentComboMusic == s then currentComboMusic = nil end
            pcall(function() s:Destroy() end)
        end)
    end)
end

-- Solo borra SU propia instancia previa
pcall(function()
    local old = game.CoreGui:FindFirstChild(MY_ID)
    if old then old:Destroy() end
    local oldI = game.CoreGui:FindFirstChild(MY_INTRO)
    if oldI then oldI:Destroy() end
end)

-- ── POSICIONES ──
local DefaultPositions = {
    Combo = { X = 0, Y = 0, Size = 110 },
}

local Positions = {}

pcall(function()
    if isfile and isfile(CONFIG.SaveFile) then
        local data = HttpService:JSONDecode(readfile(CONFIG.SaveFile))
        for k, v in pairs(data) do
            if type(v) == "table" then
                Positions[k] = Positions[k] or {}
                for k2, v2 in pairs(v) do
                    Positions[k][k2] = v2
                end
            end
        end
    end
end)

for key, def in pairs(DefaultPositions) do
    Positions[key] = Positions[key] or {}
    for k2, v2 in pairs(def) do
        if Positions[key][k2] == nil then
            Positions[key][k2] = v2
        end
    end
end

local function SavePositions()
    pcall(function()
        if writefile then
            writefile(CONFIG.SaveFile, HttpService:JSONEncode(Positions))
        end
    end)
end

-- ══════════════════════════════════════════════════════════════
-- INTRO
-- ══════════════════════════════════════════════════════════════
local IntroGui = Instance.new("ScreenGui")
IntroGui.Name = MY_INTRO
IntroGui.ResetOnSpawn = false
IntroGui.IgnoreGuiInset = true
IntroGui.DisplayOrder = 999999

local okI = pcall(function() IntroGui.Parent = game.CoreGui end)
if not okI or not IntroGui.Parent then
    IntroGui.Parent = player:WaitForChild("PlayerGui")
end

local ZombieSound = Instance.new("Sound")
ZombieSound.Name = "ZombieByeBye"
ZombieSound.Volume = 2
ZombieSound.Parent = IntroGui

local introDestroyed = false

local function TryPlaySound(index)
    if introDestroyed then return end
    if index > #ZOMBIE_SOUND_CANDIDATES then return end
    ZombieSound.SoundId = ZOMBIE_SOUND_CANDIDATES[index]
    local loaded = false
    local conn
    conn = ZombieSound.Loaded:Connect(function()
        loaded = true
        if conn then conn:Disconnect() end
    end)
    task.spawn(function() pcall(function() ZombieSound:Play() end) end)
    task.delay(0.8, function()
        if conn then conn:Disconnect() end
        if not loaded then TryPlaySound(index + 1) end
    end)
end
TryPlaySound(1)

local TapCatcher = Instance.new("TextButton")
TapCatcher.Size = UDim2.new(1, 0, 1, 0)
TapCatcher.BackgroundTransparency = 1
TapCatcher.Text = ""
TapCatcher.BorderSizePixel = 0
TapCatcher.AutoButtonColor = false
TapCatcher.Active = true
TapCatcher.Parent = IntroGui

local Holder = Instance.new("Frame")
Holder.Size = UDim2.new(0, 0, 0, 0)
Holder.Position = UDim2.new(0.5, 0, 0.5, 0)
Holder.AnchorPoint = Vector2.new(0.5, 0.5)
Holder.BackgroundTransparency = 1
Holder.Parent = IntroGui

local function MakeLabel(text, sizeX, sizeY, posY, textSize, rot)
    local L = Instance.new("TextLabel")
    L.Size = UDim2.new(0, sizeX, 0, sizeY)
    L.Position = UDim2.new(0.5, 0, 0, posY)
    L.AnchorPoint = Vector2.new(0.5, 0.5)
    L.BackgroundTransparency = 1
    L.Text = text
    L.TextColor3 = Color3.fromRGB(255, 255, 255)
    L.Font = Enum.Font.GothamBlack
    L.TextSize = textSize
    L.TextTransparency = 1
    L.Parent = Holder

    local S = Instance.new("UIStroke")
    S.Parent = L
    S.Color = Color3.fromRGB(0, 0, 0)
    S.Thickness = 4
    S.Transparency = 1

    local G = Instance.new("UIGradient")
    G.Parent = L
    G.Rotation = rot
    return L, S
end

local BigLabel, BigStroke = MakeLabel("BIG", 600, 120, -70, 110, 45)
BigLabel.UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,    Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.35, Color3.fromRGB(120, 0, 0)),
    ColorSequenceKeypoint.new(0.6,  Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(0.85, Color3.fromRGB(180, 0, 0)),
    ColorSequenceKeypoint.new(1,    Color3.fromRGB(255, 40, 40)),
})

local AmateuzLabel, AmateuzStroke = MakeLabel("AMATEUZ", 800, 150, 60, 130, -45)
AmateuzLabel.UIGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0,   Color3.fromRGB(0, 0, 0)),
    ColorSequenceKeypoint.new(0.3, Color3.fromRGB(255, 0, 0)),
    ColorSequenceKeypoint.new(0.55,Color3.fromRGB(80, 0, 0)),
    ColorSequenceKeypoint.new(0.8, Color3.fromRGB(255, 30, 30)),
    ColorSequenceKeypoint.new(1,   Color3.fromRGB(0, 0, 0)),
})

TweenService:Create(BigLabel, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
TweenService:Create(AmateuzLabel, TweenInfo.new(0.6), {TextTransparency = 0}):Play()
TweenService:Create(BigStroke, TweenInfo.new(0.6), {Transparency = 0}):Play()
TweenService:Create(AmateuzStroke, TweenInfo.new(0.6), {Transparency = 0}):Play()

local Hint = Instance.new("TextLabel")
Hint.Size = UDim2.new(0, 300, 0, 20)
Hint.Position = UDim2.new(0.5, 0, 0, 170)
Hint.AnchorPoint = Vector2.new(0.5, 0.5)
Hint.BackgroundTransparency = 1
Hint.Text = "toca la pantalla para quitar"
Hint.TextColor3 = Color3.fromRGB(255, 80, 80)
Hint.Font = Enum.Font.Gotham
Hint.TextSize = 13
Hint.TextTransparency = 1
Hint.Parent = Holder
TweenService:Create(Hint, TweenInfo.new(0.6), {TextTransparency = 0.3}):Play()

local floatConn = RunService.RenderStepped:Connect(function()
    local t = os.clock()
    BigLabel.Position = UDim2.new(0.5, 0, 0, -70 + math.sin(t * 2) * 6)
    AmateuzLabel.Position = UDim2.new(0.5, 0, 0, 60 + math.sin(t * 2 + math.pi) * 6)
end)

local introDestroyedFlag = false
local function KillIntro()
    if introDestroyedFlag then return end
    introDestroyedFlag = true
    introDestroyed = true
    if floatConn then floatConn:Disconnect() end
    pcall(function() if ZombieSound.Playing then ZombieSound:Stop() end end)
    -- 🔇 Detener la música del combo al quitar la intro
    stopComboMusic()
    local fo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    TweenService:Create(BigLabel, fo, {TextTransparency = 1}):Play()
    TweenService:Create(AmateuzLabel, fo, {TextTransparency = 1}):Play()
    TweenService:Create(BigStroke, fo, {Transparency = 1}):Play()
    TweenService:Create(AmateuzStroke, fo, {Transparency = 1}):Play()
    TweenService:Create(Hint, fo, {TextTransparency = 1}):Play()
    task.delay(0.6, function() pcall(function() IntroGui:Destroy() end) end)
end
TapCatcher.MouseButton1Click:Connect(KillIntro)
task.delay(5, KillIntro)

-- 🎵 Música al ejecutar el script
playComboMusic()

-- ══════════════════════════════════════════════════════════════
-- KEYWORDS
-- ══════════════════════════════════════════════════════════════
local Keywords = {
    Medusa     = {"medusa"},
    BlackBomb  = {"blackhole bomb", "black hole bomb", "blackholebomb", "black hole"},
    Oso        = {
        "gummy bear", "gummybear", "gummy",
        "jelly bear", "jellybear", "jelly",
        "oso de goma", "oso de gelatina", "oso",
        "teddy", "bear", "gominola", "gomita", "gelatina"
    },
    Buscador   = {
        "buscador de calor", "buscadordecalor",
        "heat seeker", "heatseeker", "heat-seeker",
        "buscador", "homing", "homing missile",
        "misil teledirigido", "teledirigido",
        "seeker", "cohete buscador"
    },
}

-- ══════════════════════════════════════════════════════════════
-- GUI PRINCIPAL
-- ══════════════════════════════════════════════════════════════
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = MY_ID
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true

local okG = pcall(function() ScreenGui.Parent = game.CoreGui end)
if not okG or not ScreenGui.Parent then
    ScreenGui.Parent = player:WaitForChild("PlayerGui")
end

-- ── PANEL SUPERIOR ──
local Panel = Instance.new("Frame")
Panel.Size = UDim2.new(0, 170, 0, 30)
Panel.Position = UDim2.new(0.5, 0, 0, 20)
Panel.AnchorPoint = Vector2.new(0.5, 0)
Panel.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Panel.BorderSizePixel = 0
Panel.Active = true
Panel.Parent = ScreenGui
Instance.new("UICorner", Panel).CornerRadius = UDim.new(0, 8)

local PS = Instance.new("UIStroke", Panel)
PS.Color = Color3.fromRGB(255, 0, 0)
PS.Thickness = 1

local LockBtn = Instance.new("TextButton")
LockBtn.Size = UDim2.new(0, 80, 1, -8)
LockBtn.Position = UDim2.new(0, 4, 0, 4)
LockBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
LockBtn.Text = "OFF"
LockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
LockBtn.Font = Enum.Font.GothamBold
LockBtn.TextSize = 12
LockBtn.BorderSizePixel = 0
LockBtn.Parent = Panel
Instance.new("UICorner", LockBtn).CornerRadius = UDim.new(0, 6)

local MinusBtn = Instance.new("TextButton")
MinusBtn.Size = UDim2.new(0, 30, 1, -8)
MinusBtn.Position = UDim2.new(0, 88, 0, 4)
MinusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MinusBtn.Text = "-"
MinusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinusBtn.Font = Enum.Font.GothamBold
MinusBtn.TextSize = 16
MinusBtn.BorderSizePixel = 0
MinusBtn.Parent = Panel
Instance.new("UICorner", MinusBtn).CornerRadius = UDim.new(0, 6)

local PlusBtn = Instance.new("TextButton")
PlusBtn.Size = UDim2.new(0, 30, 1, -8)
PlusBtn.Position = UDim2.new(0, 120, 0, 4)
PlusBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
PlusBtn.Text = "+"
PlusBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
PlusBtn.Font = Enum.Font.GothamBold
PlusBtn.TextSize = 16
PlusBtn.BorderSizePixel = 0
PlusBtn.Parent = Panel
Instance.new("UICorner", PlusBtn).CornerRadius = UDim.new(0, 6)

-- ── FÁBRICA DE BOTONES ──
local Locked = true

local function MakeCircle(text, key, strokeColor)
    local pos = Positions[key]
    local B = Instance.new("TextButton")
    B.Size = UDim2.new(0, pos.Size, 0, pos.Size)
    B.Position = UDim2.new(0.5, pos.X, 0.5, pos.Y)
    B.AnchorPoint = Vector2.new(0.5, 0.5)
    B.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    B.Text = text
    B.TextColor3 = Color3.fromRGB(255, 255, 255)
    B.Font = Enum.Font.GothamBold
    B.TextScaled = true
    B.TextWrapped = true
    B.BorderSizePixel = 0
    B.Active = true
    B.Parent = ScreenGui

    local C = Instance.new("UICorner", B)
    C.CornerRadius = UDim.new(1, 0)

    local S = Instance.new("UIStroke", B)
    S.Color = strokeColor or Color3.fromRGB(255, 0, 0)
    S.Thickness = 2
    S.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

    local P = Instance.new("UIPadding", B)
    P.PaddingTop = UDim.new(0, 12)
    P.PaddingBottom = UDim.new(0, 12)
    P.PaddingLeft = UDim.new(0, 8)
    P.PaddingRight = UDim.new(0, 8)

    return B, S
end

local ComboBtn, ComboStroke = MakeCircle("MEGA\nCOMBO\n♟️", "Combo", Color3.fromRGB(255, 60, 0))

-- ══════════════════════════════════════════════════════════════
-- FUNCIONES DE HERRAMIENTAS
-- ══════════════════════════════════════════════════════════════
local function FindTool(keywordTable)
    local char = player.Character or player.CharacterAdded:Wait()
    local backpack = player:WaitForChild("Backpack", 5)
    if not backpack then return nil end
    for _, container in ipairs({backpack, char}) do
        for _, v in pairs(container:GetChildren()) do
            if v:IsA("Tool") then
                local n = string.lower(v.Name)
                for _, word in pairs(keywordTable) do
                    if string.find(n, word, 1, true) then
                        return v, char
                    end
                end
            end
        end
    end
    return nil
end

local function UseTool(keywordTable)
    local tool, char = FindTool(keywordTable)
    if not tool then return false end
    local humanoid = char:FindFirstChildOfClass("Humanoid")
    if not humanoid then return false end
    pcall(function() humanoid:EquipTool(tool) end)
    task.wait(0.05)
    pcall(function() tool:Activate() end)
    pcall(function()
        local remote = tool:FindFirstChildWhichIsA("RemoteEvent")
        if remote then remote:FireServer() end
    end)
    return true
end

-- ══════════════════════════════════════════════════════════════
-- MEGA COMBO
-- ══════════════════════════════════════════════════════════════
local COMBO_COOLDOWN = CONFIG.ComboCooldown
local comboRunning = false
local lastCombo = 0

local function RunCombo()
    if comboRunning then return end
    if os.clock() - lastCombo < COMBO_COOLDOWN then return end
    comboRunning = true
    lastCombo = os.clock()

    ComboStroke.Color = Color3.fromRGB(255, 200, 0)

    -- Orden: Oso → Medusa → BlackBomb → Buscador
    if UseTool(Keywords.Oso) then task.wait(0.25) end
    if UseTool(Keywords.Medusa) then task.wait(0.25) end
    if UseTool(Keywords.BlackBomb) then task.wait(0.25) end
    UseTool(Keywords.Buscador)
    task.wait(0.2)

    ComboStroke.Color = Color3.fromRGB(255, 60, 0)
    comboRunning = false
end

-- ── LOCK ON/OFF ──
LockBtn.MouseButton1Click:Connect(function()
    Locked = not Locked
    if Locked then
        LockBtn.Text = "OFF"
        LockBtn.BackgroundColor3 = Color3.fromRGB(150, 30, 30)
    else
        LockBtn.Text = "ON"
        LockBtn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    end
end)

local function ApplySizeDelta(delta)
    local cur = Positions.Combo.Size or 110
    local newSize = math.clamp(cur + delta, 50, 250)
    Positions.Combo.Size = newSize
    ComboBtn.Size = UDim2.new(0, newSize, 0, newSize)
    SavePositions()
end

MinusBtn.MouseButton1Click:Connect(function() if Locked then return end; ApplySizeDelta(-10) end)
PlusBtn.MouseButton1Click:Connect(function() if Locked then return end; ApplySizeDelta(10) end)

-- ══════════════════════════════════════════════════════════════
-- DRAG + CLICK
-- ══════════════════════════════════════════════════════════════
local DRAG_THRESHOLD = CONFIG.DragThreshold

local function AttachButton(Btn, key, onClick)
    local dragging, moved = false, false
    local dragStart, startPos

    Btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            if Locked then
                if onClick then onClick() end
                return
            end
            dragging = true
            moved = false
            dragStart = input.Position
            startPos = Btn.Position
        end
    end)

    UIS.InputChanged:Connect(function(input)
        if not dragging or Locked then return end
        if input.UserInputType == Enum.UserInputType.MouseMovement
            or input.UserInputType == Enum.UserInputType.Touch then
            local delta = input.Position - dragStart
            if math.abs(delta.X) > DRAG_THRESHOLD or math.abs(delta.Y) > DRAG_THRESHOLD then
                moved = true
            end
            if moved then
                Btn.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + delta.X,
                    startPos.Y.Scale, startPos.Y.Offset + delta.Y
                )
            end
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1
            or input.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                dragging = false
                if moved then
                    Positions[key].X = Btn.Position.X.Offset
                    Positions[key].Y = Btn.Position.Y.Offset
                    Positions[key].Size = Btn.Size.X.Offset
                    SavePositions()
                else
                    if onClick then onClick() end
                end
            end
        end
    end)
end

AttachButton(ComboBtn, "Combo", function() RunCombo() end)

-- ══════════════════════════════════════════════════════════════
-- DRAG PANEL
-- ══════════════════════════════════════════════════════════════
local pd = false
local ps, psp

Panel.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        pd = true
        ps = input.Position
        psp = Panel.Position
    end
end)

UIS.InputChanged:Connect(function(input)
    if not pd then return end
    if input.UserInputType == Enum.UserInputType.MouseMovement
        or input.UserInputType == Enum.UserInputType.Touch then
        local delta = input.Position - ps
        Panel.Position = UDim2.new(
            psp.X.Scale, psp.X.Offset + delta.X,
            psp.Y.Scale, psp.Y.Offset + delta.Y
        )
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1
        or input.UserInputType == Enum.UserInputType.Touch then
        pd = false
    end
end)

-- ══════════════════════════════════════════════════════════════
-- LIMPIEZA
-- ══════════════════════════════════════════════════════════════
Players.PlayerRemoving:Connect(function(p)
    if p == player then
        SavePositions()
        stopComboMusic()
        if getgenv then getgenv()[MY_FLAG] = nil end
    end
end)
