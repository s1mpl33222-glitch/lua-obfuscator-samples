---- leaked by .gg/source
-- Zenith: Aimbot Bypass (motor unico) | Bat Aimbot = Cloud Normal | UI Obsidian

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

-- Intro e musica removidos para acelerar a inicializacao e reduzir downloads em segundo plano.
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
AIMBOT_BYPASS_SPEED = 58
local State = {
    bypassBatEnabled = false,
    bypassBatSpeed = AIMBOT_BYPASS_SPEED,
    batAimbotEnabled = false,
    batAimbotSpeed = 62,
}
CONFIG_FILE = "ZenithHub_" .. tostring(LP.UserId) .. ".json"
BAT_V2_HIT_DIST = 4.5
_isDraggingButton = false

backgroundIndex = 1
backgroundImages = {"89893709727544", "102523158896370", "73222021729894", "84682831265683"}
MVPUI = {effects = true, animated = {}, cards = {}, tweens = {}, backgroundRevision = 0}
useVenixCarryEngine = false

backgroundImageTransparency = 0.15
backgroundMode = "Background 1"
backgroundSelectorLabel = nil
miniBackgroundImage = nil
floatingButtonScale = 0.77
mobileButtonStyle = "Normal"
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
        local n = tonumber(string.match(tostring(mode), "^Background%s+(%d+)$")) or backgroundIndex
        backgroundIndex = _clamp(_floor(n), 1, #backgroundImages)
        backgroundMode = "Background " .. backgroundIndex
    end
    MVPUI.backgroundRevision = MVPUI.backgroundRevision + 1
    local revision = MVPUI.backgroundRevision
    if main then
        main.BackgroundColor3 = Color3.fromRGB(9, 12, 16)
        main.BackgroundTransparency = 0
        local bg = main:FindFirstChild("BackgroundImage")
        local overlay = main:FindFirstChild("BackgroundIncoming")
        if overlay then overlay:Destroy() end
        if MVPUI.backgroundTween then MVPUI.backgroundTween:Cancel() end
        if bg then
            local asset = "rbxassetid://" .. backgroundImages[backgroundIndex]
            local opacity = backgroundMode == "None" and 1 or backgroundImageTransparency
            if backgroundMode == "None" or not MVPUI.effects or bg.Image == asset then
                bg.Image = asset
                bg.ImageTransparency = opacity
            else
                local incoming = bg:Clone()
                incoming.Name = "BackgroundIncoming"
                incoming.Image = asset
                incoming.ImageTransparency = 1
                incoming.ZIndex = 1
                incoming.Parent = main
                MVPUI.backgroundTween = TS:Create(incoming, TweenInfo.new(0.28, Enum.EasingStyle.Quad), {ImageTransparency = opacity})
                MVPUI.backgroundTween.Completed:Connect(function()
                    if revision == MVPUI.backgroundRevision and bg.Parent then
                        bg.Image = asset
                        bg.ImageTransparency = opacity
                    end
                    if incoming.Parent then incoming:Destroy() end
                end)
                MVPUI.backgroundTween:Play()
            end
        end
    end
    if MVPUI.art and MVPUI.art.Parent then
        MVPUI.art.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
        MVPUI.art.Visible = backgroundMode ~= "None"
    end
    if miniBackgroundImage then miniBackgroundImage.Visible = false end
    if backgroundSelectorLabel then backgroundSelectorLabel.Text = backgroundMode end
    if _G.__MVPPingLaggerRefreshBackground then pcall(_G.__MVPPingLaggerRefreshBackground) end
    for i, card in ipairs(MVPUI.cards) do
        if card.Parent then
            local stroke = card:FindFirstChildOfClass("UIStroke")
            if stroke then stroke.Transparency = backgroundMode ~= "None" and i == backgroundIndex and 0 or 0.72 end
            local badge = card:FindFirstChild("Selected")
            if badge then badge.Visible = backgroundMode ~= "None" and i == backgroundIndex end
        end
    end
end

local COLOR_THEMES = {
    ["Orange"] = Color3.fromRGB(150, 80, 255),
    ["Gray"] = Color3.fromRGB(170, 170, 170),
}

RIVAL_TITLE_THEMES = {
    ["Orange"] = { top = Color3.fromRGB(240, 230, 255), bottom = Color3.fromRGB(150, 80, 255) },
    ["Blue"]  = { top = Color3.fromRGB(60, 130, 255),  bottom = Color3.fromRGB(210, 220, 235) },
    ["Red"]   = { top = Color3.fromRGB(255, 70, 70),   bottom = Color3.fromRGB(215, 215, 215) },
    ["Green"] = { top = Color3.fromRGB(50, 220, 110),  bottom = Color3.fromRGB(200, 240, 210) },
    ["Black"] = { top = Color3.fromRGB(35, 35, 40),    bottom = Color3.fromRGB(115, 115, 125) },
    ["Gray"]  = { top = Color3.fromRGB(200, 200, 200), bottom = Color3.fromRGB(120, 120, 130) },
}
currentRivalTitleTheme = "Orange"
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

currentColorTheme = "Orange"
selectedColor = COLOR_THEMES["Orange"]

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
        progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
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

        pbFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end

    if MVPUI.speedStroke and MVPUI.speedStroke.Parent then MVPUI.speedStroke.Color = color end
    if MVPUI.discordLabel and MVPUI.discordLabel.Parent then MVPUI.discordLabel.TextColor3 = color end

    if _uicStroke then _uicStroke.Color = color end
    if _uicAvatarStroke then _uicAvatarStroke.Color = color end
    if _uicHandle then _uicHandle.TextColor3 = Color3.fromRGB(186, 140, 255) end
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
        local active = tab:GetAttribute("ZenithTabActive") == true
        local pill = tab:FindFirstChild("ActivePill")
        if pill then pill.BackgroundColor3 = color end
        local stroke = tab:FindFirstChild("TabStroke")
        if stroke then stroke.Color = color; stroke.Transparency = active and 0.42 or 1 end
        tab.BackgroundColor3 = color
        tab.BackgroundTransparency = active and 0 or 1
        tab.TextColor3 = active and Color3.fromRGB(22, 8, 40) or Color3.fromRGB(208, 190, 238)
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

VX7A = {
    index = 0, mod = nil, loading = false, busy = false, pending = nil, label = nil,
    labels = {"OFF", "ALIEN", "OUTFIT", "OUTFIT 2", "OUTFIT 3", "OUTFIT 4", "OUTFIT 5", "OUTFIT 6", "OUTFIT 7", "NEW SKIN"},
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
label = "OUTFIT 7",
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
loadstring(game:HttpGet("https://raw.githubusercontent.com/Argian-dotcom/Jdkffkfo/refs/heads/main/Coding"))()
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
batAimbotEnabled = false
CLOUD_BAT_AIMBOT_SPEED = 62
dropMode = 1
antiLagEnabled = false
removeAccessoriesEnabled = false
stretchEnabled = false
stretchFOV = 120
uiLocked = false
mobileButtonsLocked = false
uiScaleValue = 90
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
    if useVenixCarryEngine and MVPVenixCarry and MVPVenixCarry:isRunning() then return MVPVenixCarry:getActiveSpeed() end
    if laggerCarryToggled then return LAGGER_CARRY_SPEED
    elseif laggerToggled then return LAGGER_SPEED
    elseif speedMode then return CS
    else return NS end
end

function getSpeedModeName()
    if useVenixCarryEngine and MVPVenixCarry and MVPVenixCarry.softStealEnabled and MVPVenixCarry.softStealLatched then return "AUTO CARRY" end
    if laggerToggled or laggerCarryToggled then return "LAGGER"
    elseif speedMode then return "CARRY"
    else return "NORMAL" end
end

local _s2VelState = {root = nil, v = _V3zero}
local _velChecked = setmetatable({}, {__mode = "k"})
local _hookedVelParts = {}
local _velocityHook = _G.__MVPVelocityHook or {hooked = false, roots = setmetatable({}, {__mode = "k"})}
_G.__MVPVelocityHook = _velocityHook
local function _hookVelHRP(root)
    if not root then return end
    _s2VelState.root = root
    _velChecked[root] = true
    _velocityHook.roots[root] = true
    if _velocityHook.hooked then return end
    if type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function"
        or type(newcclosure) ~= "function" or type(checkcaller) ~= "function" then return end
    pcall(function()
        local mt = getrawmetatable(root)
        if not mt then return end
        local oldIndex = rawget(mt, "__index")
        if type(oldIndex) ~= "function" and type(oldIndex) ~= "table" then return end
        local function original(obj, key)
            if type(oldIndex) == "function" then return oldIndex(obj, key) end
            return oldIndex[key]
        end
        setreadonly(mt, false)
        mt.__index = newcclosure(function(obj, key)
            if not checkcaller() and _velocityHook.roots[obj]
                and (key == "AssemblyLinearVelocity" or key == "Velocity") then
                local real = original(obj, key)
                if real and real.Magnitude > 20 then return real.Unit * 20 end
                return real
            end
            return original(obj, key)
        end)
        setreadonly(mt, true)
        _velocityHook.hooked = true
    end)
end
local function _setupVelChecked(character)
    _velocityHook.roots = setmetatable({}, {__mode = "k"})
    _velChecked = setmetatable({}, {__mode = "k"})
    if not character then _s2VelState.root = nil; return nil end
    local root = character:WaitForChild("HumanoidRootPart", 5)
    if root then _s2VelState.root = root; _velChecked[root] = true; _velocityHook.roots[root] = true end
    return root
end
if LP.Character then _hookVelHRP(_setupVelChecked(LP.Character)) end
local function _isRagdollState(hum)
    if not hum then return true end
    local state = hum:GetState()
    return hum.PlatformStand or state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Ragdoll or state == Enum.HumanoidStateType.FallingDown
end
local function _applyVelocitySpeed(direction, speed, root)
    if not root or not root.Parent then return end
    if autoBatEnabled or batAimbotEnabled or TPBatState.enabled or (_G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2()) then return end
    if type(speed) ~= "number" or speed ~= speed or speed <= 0 or speed == math.huge then return end
    local y = root.AssemblyLinearVelocity.Y
    if direction and direction.Magnitude > 0.05 then
        pcall(function() root:SetNetworkOwner(LP) end)
        local unit = direction.Unit
        root.AssemblyLinearVelocity = _V3new(unit.X * speed, y, unit.Z * speed)
    else
        root.AssemblyLinearVelocity = _V3new(0, y, 0)
    end
    _G.__RivalHubLiveSpeed = {t = os.clock(), v = speed}
end
function getAutoPathSpeed()
    if laggerCarryToggled or laggerToggled then return LAGGER_SPEED end
    return NS
end

        MVPVenixCarry = {
            normalSpeed = NS,
            carrySpeed = CS,
            laggerSpeed = LAGGER_SPEED,
            laggerCarrySpeed = LAGGER_CARRY_SPEED,
            speedToggled = false,
            laggerMode = 0,
            softStealEnabled = false,
            softStealRadius = 10,
            softStealSpeed = 30,
            softStealLatched = false,
            _isCarrying = false,
            _lastCarryCheck = 0,
            _lvBoost = nil,
            _lvAtt = nil,
            _blockedTime = 0,
            _maxForce = 2200,
            _freeForce = 500,
            _heartbeatConn = nil,
            _softStealScanner = nil,
            _softStealAnimals = {},
            _softStealScanning = false,
            _state = nil,
            _dropInProgress = false,
            _batAimbotToggled = false,
            _rayParams = nil,
            _rayFilter = nil,
            _rayFilterTime = 0,
            isCarrying = function(self)
                local now = _tick()
                if now - (self._lastCarryCheck or 0) < 0.1 then
                    return self._isCarrying
                end
                self._lastCarryCheck = now
                local character = LP.Character
                if not character then
                    self._isCarrying = false
                    return false
                end
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                local walkSpeed = humanoid and humanoid.WalkSpeed or 16
                local isCarrying = walkSpeed < 25 and walkSpeed > 0
                local ok, result = pcall(function()
                    return LP:GetAttribute("Stealing")
                end)
                ok = ok and result == true
                local isEnabled = false
                if ok then
                    isEnabled = true
                end
                local ok2, result2 = pcall(function()
                    return character:GetAttribute("Stealing")
                end)
                if ok2 and result2 == true then
                    isEnabled = true
                end
                if not isEnabled then
                    for _, name in ipairs({
                        "Carrying",
                        "IsCarrying",
                        "Grabbed",
                        "Holding",
                        "StealHold",
                        "HasGrab",
                    }) do
                        local instance = character:FindFirstChild(name)
                        if instance then
                            if
                                instance:IsA("BoolValue") and instance.Value
                                or instance:IsA("ObjectValue") and instance.Value
                                or instance:IsA("StringValue") and instance.Value ~= ""
                            then
                                isEnabled = true
                                break
                            end
                        end
                    end
                end
                self._isCarrying = isCarrying or isEnabled
                return self._isCarrying
            end,
            getActiveSpeed = function(self)
                if self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled) then
                    return self.normalSpeed
                end
                if self.softStealEnabled then
                    local _, distance = self:getNearestSoftStealAnimal(self.softStealRadius)
                    if distance and distance <= self.softStealRadius then
                        self.softStealLatched = true
                        return self.softStealSpeed
                    end
                    if self.softStealLatched and self:isCarrying() then
                        return self.softStealSpeed
                    end
                    self.softStealLatched = false
                end
                if self.laggerMode == 1 then
                    return self.laggerSpeed
                end
                if self.laggerMode == 2 then
                    return self.laggerCarrySpeed
                end
                if self.speedToggled then
                    return self.carrySpeed
                end
                return self.normalSpeed
            end,
            getStatus = function(self)
                if not (self._state and (self._state.autoLeftEnabled or self._state.autoRightEnabled)) then
                    if self.softStealEnabled then
                        local _, distance = self:getNearestSoftStealAnimal(self.softStealRadius)
                        if
                            distance and distance <= self.softStealRadius
                            or self.softStealLatched and self:isCarrying()
                        then
                            return "AUTO CARRY", self.softStealSpeed
                        end
                    end
                    if self.laggerMode == 1 then
                        return "LAGGER", self.laggerSpeed
                    end
                    if self.laggerMode == 2 then
                        return "LAGGER CARRY", self.laggerCarrySpeed
                    end
                    if self.speedToggled then
                        return "CARRY", self.carrySpeed
                    end
                    return "NORMAL", self.normalSpeed
                end
                return "NORMAL", self.normalSpeed
            end,
        }
        do
            local function destroyLV()
                if MVPVenixCarry._lvBoost and MVPVenixCarry._lvBoost.Parent then
                    pcall(function()
                        MVPVenixCarry._lvBoost:Destroy()
                    end)
                end
                if MVPVenixCarry._lvAtt and MVPVenixCarry._lvAtt.Parent then
                    pcall(function()
                        MVPVenixCarry._lvAtt:Destroy()
                    end)
                end
                MVPVenixCarry._lvBoost = nil
                MVPVenixCarry._lvAtt = nil
            end
            local function setupLV(parent)
                if MVPVenixCarry._lvBoost and MVPVenixCarry._lvBoost.Parent == parent then
                    return
                end
                destroyLV()
                local attachment = Instance.new("Attachment")
                attachment.Parent = parent
                local linearVelocity = Instance.new("LinearVelocity")
                linearVelocity.Name = "MVPCarryBoost"
                attachment.Name = "MVPCarryAttachment"
                linearVelocity.Attachment0 = attachment
                linearVelocity.VelocityConstraintMode = Enum.VelocityConstraintMode.Plane
                linearVelocity.PrimaryTangentAxis = _V3new(1, 0, 0)
                linearVelocity.SecondaryTangentAxis = _V3new(0, 0, 1)
                linearVelocity.MaxForce = MVPVenixCarry._maxForce
                linearVelocity.PlaneVelocity = Vector2.zero
                linearVelocity.RelativeTo = Enum.ActuatorRelativeTo.World
                linearVelocity.Parent = parent
                MVPVenixCarry._lvAtt = attachment
                MVPVenixCarry._lvBoost = linearVelocity
                pcall(function()
                    parent:SetNetworkOwner(LP)
                end)
            end
            MVPVenixCarry.scanSoftStealAnimals = function(self)
                self._softStealAnimals = {}
                local plots = Workspace:FindFirstChild("Plots")
                if not plots then
                    return
                end
                for _, child in ipairs(plots:GetChildren()) do
                    if child:IsA("Model") then
                        local animalPodiums = child:FindFirstChild("AnimalPodiums")
                        if animalPodiums then
                            for _, child2 in ipairs(animalPodiums:GetChildren()) do
                                if child2:IsA("Model") then
                                    local base = child2:FindFirstChild("Base")
                                    base = base and base:FindFirstChild("Spawn")
                                    if base then
                                        table.insert(self._softStealAnimals, {
                                            plot = child.Name,
                                            slot = child2.Name,
                                            worldPosition = base.Position,
                                            uid = child.Name .. "_" .. child2.Name,
                                        })
                                    end
                                end
                            end
                        end
                    end
                end
            end
            MVPVenixCarry.startSoftStealScanner = function(callback)
                if callback._softStealScanner then
                    return
                end
                callback._softStealScanning = true
                callback:scanSoftStealAnimals()
                local accumulator = 0
                callback._softStealScanner = RunService.Heartbeat:Connect(function(dt)
                    accumulator = accumulator + dt
                    if accumulator < 0.2 then return end
                    accumulator = 0
                    if not callback._softStealScanning then
                        return
                    end
                    callback:scanSoftStealAnimals()
                end)
            end
            MVPVenixCarry.stopSoftStealScanner = function(self)
                self._softStealScanning = false
                if self._softStealScanner then
                    self._softStealScanner:Disconnect()
                    self._softStealScanner = nil
                end
            end
            MVPVenixCarry.getNearestSoftStealAnimal = function(self, radius)
                local character = LP.Character
                if character then
                    character = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso")
                end
                if not character then
                    return nil, _huge
                end
                local softStealAnimals = self._softStealAnimals
                local position = character.Position
                local bestDistance = _huge
                local animals = nil
                for i = 1, #softStealAnimals do
                    local rootPart = softStealAnimals[i]
                    if rootPart.worldPosition then
                        local dx = position.X - rootPart.worldPosition.X
                        local dy = position.Y - rootPart.worldPosition.Y
                        local dz = position.Z - rootPart.worldPosition.Z
                        local distance = _sqrt(dx * dx + dy * dy + dz * dz)
                        if distance < bestDistance then
                            bestDistance = distance
                            animals = rootPart
                        end
                    end
                end
                if radius and bestDistance > radius then
                    return nil, bestDistance
                end
                return animals, bestDistance
            end
            MVPVenixCarry.updateMovement = function(self, deltaTime)
                local character = LP.Character
                if not character then
                    return
                end
                local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if not humanoidRootPart or not humanoid or humanoid.Health <= 0 then
                    return
                end
                local speed = self:getActiveSpeed()
                local moveDirection = humanoid.MoveDirection
                local moving = moveDirection.Magnitude > 0.1
                local unit = nil
                if moving then
                    if not self._rayParams then
                        self._rayParams = _RayParams_new()
                        self._rayParams.FilterType = Enum.RaycastFilterType.Exclude
                        self._rayFilter = {}
                        self._rayFilterTime = 0
                    end
                    local now = _tick()
                    if now - self._rayFilterTime > 1 then
                        self._rayFilterTime = now
                        local rayFilter = self._rayFilter
                        while #rayFilter > 0 do
                            rayFilter[#rayFilter] = nil
                        end
                        rayFilter[1] = character
                        local plist = _GetPlayersCached()
                        for i = 1, #plist do
                            local p = plist[i]
                            if p.Character then
                                rayFilter[#rayFilter + 1] = p.Character
                            end
                        end
                        self._rayParams.FilterDescendantsInstances = rayFilter
                    else
                        local rayFilter = self._rayFilter
                        local found = false
                        for i = 1, #rayFilter do
                            if rayFilter[i] == character then
                                found = true
                                break
                            end
                        end
                        if not found then
                            rayFilter[1] = character
                            self._rayParams.FilterDescendantsInstances = rayFilter
                        end
                    end
                    local unit2 = _V3new(moveDirection.X, 0, moveDirection.Z).Unit
                    local rayParams = self._rayParams
                    local hit =
                        Workspace:Raycast(humanoidRootPart.Position + _V3new(0, 1, 0), unit2 * 2.5, rayParams)
                    local canCollide = hit and hit.Instance and hit.Instance.CanCollide
                    unit = nil
                    if canCollide then
                        local nf = _V3new(hit.Normal.X, 0, hit.Normal.Z)
                        unit = nil
                        if nf.Magnitude > 0.7 then
                            unit = nf.Unit
                        end
                    end
                end
                local hVelocity =
                    _V3new(humanoidRootPart.AssemblyLinearVelocity.X, 0, humanoidRootPart.AssemblyLinearVelocity.Z)
                local blocked = unit ~= nil or moving and hVelocity.Magnitude < 2
                if blocked then
                    for _, child in ipairs(character:GetChildren()) do
                        if child:IsA("Model") then
                            for _, descendant in ipairs(child:GetDescendants()) do
                                if descendant:IsA("BasePart") and descendant.CanCollide then
                                    descendant.CanCollide = false
                                end
                            end
                        end
                    end
                    for _, name in ipairs({
                        "Carrying",
                        "IsCarrying",
                        "Grabbed",
                        "Holding",
                        "StealHold",
                        "HasGrab",
                    }) do
                        local instance = character:FindFirstChild(name)
                        if
                            instance
                            and instance:IsA("ObjectValue")
                            and instance.Value
                            and instance.Value:IsA("Model")
                        then
                            for _, descendant in ipairs(instance.Value:GetDescendants()) do
                                if descendant:IsA("BasePart") and descendant.CanCollide then
                                    descendant.CanCollide = false
                                end
                            end
                        end
                    end
                end
                local state = humanoid:GetState()
                if
                    not (
                        state == Enum.HumanoidStateType.Physics
                        or state == Enum.HumanoidStateType.Ragdoll
                        or state == Enum.HumanoidStateType.FallingDown
                        or self._dropInProgress
                        or self._batAimbotToggled
                    )
                then
                    if not MVPVenixCarry._lvBoost or MVPVenixCarry._lvBoost.Parent ~= humanoidRootPart then
                        setupLV(humanoidRootPart)
                    end
                    local lvBoost = MVPVenixCarry._lvBoost
                    if lvBoost then
                        if not lvBoost.Enabled then
                            lvBoost.Enabled = true
                        end
                        if 0.1 < moveDirection.Magnitude then
                            local unit2 = _V3new(moveDirection.X, 0, moveDirection.Z).Unit
                            if unit then
                                local wanted = unit2 * speed
                                local along = wanted - unit * wanted:Dot(unit)
                                if along.Magnitude < 0.5 then
                                    lvBoost.PlaneVelocity = Vector2.zero
                                else
                                    lvBoost.PlaneVelocity = Vector2.new(along.X, along.Z)
                                end
                            else
                                lvBoost.PlaneVelocity = Vector2.new(unit2.X * speed, unit2.Z * speed)
                            end
                        else
                            lvBoost.PlaneVelocity = Vector2.zero
                        end
                        if blocked then
                            self._blockedTime = self._blockedTime + (deltaTime or 0.016)
                        else
                            self._blockedTime = 0
                        end
                        if self._blockedTime > 0.35 then
                            if lvBoost.MaxForce ~= self._freeForce then
                                lvBoost.MaxForce = self._freeForce
                            end
                        elseif lvBoost.MaxForce ~= self._maxForce then
                            lvBoost.MaxForce = self._maxForce
                        end
                    end
                elseif MVPVenixCarry._lvBoost then
                    MVPVenixCarry._lvBoost.PlaneVelocity = Vector2.zero
                    if MVPVenixCarry._lvBoost.Enabled then
                        MVPVenixCarry._lvBoost.Enabled = false
                    end
                end
            end
            MVPVenixCarry.start = function(deltaTime236)
                if deltaTime236._heartbeatConn then
                    return
                end
                deltaTime236._heartbeatConn = RunService.Heartbeat:Connect(function(deltaTime)
                    if _mySession ~= _G.RivalHubSession then deltaTime236:stop(); return end
                    deltaTime236.normalSpeed = NS
                    deltaTime236.carrySpeed = CS
                    deltaTime236.laggerSpeed = LAGGER_SPEED
                    deltaTime236.laggerCarrySpeed = LAGGER_CARRY_SPEED
                    deltaTime236.speedToggled = speedMode
                    deltaTime236.laggerMode = laggerCarryToggled and 2 or (laggerToggled and 1 or 0)
                    deltaTime236._state = {autoLeftEnabled = autoLeftEnabled, autoRightEnabled = autoRightEnabled}
                    deltaTime236._dropInProgress = dropActive or _G.IsDropping or autoLeftEnabled or autoRightEnabled
                    deltaTime236._batAimbotToggled = autoBatEnabled or batAimbotEnabled or TPBatState.enabled
                        or (_G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2())
                    deltaTime236:updateMovement(deltaTime)
                end)
                if deltaTime236.softStealEnabled then
                    deltaTime236:startSoftStealScanner()
                end
                print("[CarrySystem] Activado")
            end
            MVPVenixCarry.stop = function(self)
                if self._heartbeatConn then
                    self._heartbeatConn:Disconnect()
                    self._heartbeatConn = nil
                end
                self:stopSoftStealScanner()
                destroyLV()
                self.softStealLatched = false
                print("[CarrySystem] Desactivado")
            end
        end
    MVPVenixCarry.setNormalSpeed = function(self, value)
        self.normalSpeed = _clamp(value, 1, 500)
    end
    MVPVenixCarry.setCarrySpeed = function(self, value)
        self.carrySpeed = _clamp(value, 1, 500)
    end
    MVPVenixCarry.setLaggerSpeed = function(self, value)
        self.laggerSpeed = _clamp(value, 0.1, 500)
    end
    MVPVenixCarry.setLaggerCarrySpeed = function(self, value)
        self.laggerCarrySpeed = _clamp(value, 0.1, 500)
    end
    MVPVenixCarry.setSoftStealSpeed = function(self, value)
        self.softStealSpeed = _clamp(value, 1, 500)
    end
    MVPVenixCarry.setSoftStealRadius = function(self, value)
        self.softStealRadius = _clamp(value, 1, 200)
    end
    MVPVenixCarry.toggleCarryMode = function(self)
        self.speedToggled = not self.speedToggled
    end
    MVPVenixCarry.setLaggerMode = function(self, mode)
        if mode == 0 then
            self.laggerMode = 0
        elseif mode == 1 then
            self.laggerMode = 1
        elseif mode == 2 then
            self.laggerMode = 2
        end
    end
    MVPVenixCarry.toggleLaggerMode = function(self)
        if self.laggerMode == 0 then
            self.laggerMode = 1
        elseif self.laggerMode == 1 then
            self.laggerMode = 2
        else
            self.laggerMode = 0
        end
    end
    MVPVenixCarry.setSoftStealEnabled = function(self, softStealEnabled)
        self.softStealEnabled = softStealEnabled
        if softStealEnabled then
            self:startSoftStealScanner()
        else
            self:stopSoftStealScanner()
            self.softStealLatched = false
        end
    end
    MVPVenixCarry.toggleSoftSteal = function(self)
        self:setSoftStealEnabled(not self.softStealEnabled)
    end
    MVPVenixCarry.isRunning = function(self)
        return self._heartbeatConn ~= nil
    end
    MVPVenixCarry.getCurrentSpeed = function(self)
        return self:getActiveSpeed()
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
    BatAimbot    = {kb = Enum.KeyCode.T, gp = nil},
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
    BatAimbot    = {kb = DEFAULT_KB.BatAimbot.kb, gp = DEFAULT_KB.BatAimbot.gp},
}

_isResetting = false
_lastSavedJSON = nil
_isLoading = false

CONFIG = {
    AUTO_STEAL_ENABLED = false,
    STEAL_RANGE = 61,
    HOLD_MIN = 0.05,
    HOLD_MAX = 0.15,
    ENTRY_DELAY = 0.1,
    COOLDOWN = 0.2,
    PRIME_RANGE = 60,
}

local plots = workspace:FindFirstChild("Plots")
local stealConnection = nil

local Steal = {
    AutoStealEnabled = false,
    StealRadius = CONFIG.STEAL_RANGE,
    StealDuration = 1.3,
    StealDelay = 0.25,
    Data = {}
}

local isStealing = false
local autoStealMode = "75"
local autoStealVariant = 1
local autoStealGeneration = 0
autoStealStartedAt = 0
autoStealLastActivity = _tick()
autoStealSupervisorConn = nil
local AUTO_STEAL_VARIANT_NAMES = {"75", "80", "85", "90", "V3", "Semi"}
local function setAutoStealMode(mode)
    autoStealVariant = 1
    if mode == "V2" then mode = "80" elseif mode == "V1" then mode = "75" end
    for i, name in ipairs(AUTO_STEAL_VARIANT_NAMES) do
        if name == tostring(mode) then autoStealVariant = i; break end
    end
    autoStealMode = AUTO_STEAL_VARIANT_NAMES[autoStealVariant]
end
local function getAutoStealDuration()
    local factors = {0.75, 0.80, 0.85, 0.90, 1, 1}
    return Steal.StealDuration * factors[autoStealVariant]
end
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
    if isStealing or not prompt or not prompt.Parent then return end
    for old in pairs(Steal.Data) do if not old.Parent then Steal.Data[old] = nil end end
    local data = Steal.Data[prompt]
    if not data then
        data = {hold = {}, trigger = {}, ready = true}
        Steal.Data[prompt] = data
        pcall(function()
            if type(getconnections) ~= "function" then return end
            for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                if c.Function then table.insert(data.hold, c.Function) end
            end
            for _, c in ipairs(getconnections(prompt.Triggered)) do
                if c.Function then table.insert(data.trigger, c.Function) end
            end
        end)
    end
    if not data.ready then return end
    local generation = autoStealGeneration
    data.ready = false
    isStealing = true
    autoStealStartedAt = _tick()
    autoStealLastActivity = autoStealStartedAt
    local function active()
        return generation == autoStealGeneration and isStealing and Steal.AutoStealEnabled
            and _mySession == _G.RivalHubSession
    end
    local function distance()
        if not prompt.Parent or not prompt.Parent.Parent then return nil end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not root or not hum or hum.Health <= 0 then return nil end
        local parent = prompt.Parent
        local part = parent:IsA("BasePart") and parent or parent.Parent
        if not part or not part:IsA("BasePart") then return nil end
        return (root.Position - part.Position).Magnitude
    end
    local function valid()
        if not active() then return false end
        local d = distance()
        return d ~= nil and d <= Steal.StealRadius
    end
    task.spawn(function()
        local success, err = pcall(function()
            updateStealProgress(0, "STEALING")
            for _, fn in ipairs(data.hold) do task.spawn(fn) end
            local started = _tick()
            local duration = Steal.StealDuration
            local stopTime = getAutoStealDuration()
            while valid() and _tick() - started < stopTime do
                updateStealProgress((_tick() - started) / duration, "STEALING")
                task.wait()
            end
            if not valid() then return end
            local stopProgress = _clamp(stopTime / duration, 0, 1)
            updateStealProgress(stopProgress, "APPROACH")
            local deadline = _tick() + math.max(2.99 - stopTime - math.max(duration - stopTime, 0), 0.05)
            while valid() do
                local d = distance()
                if d and d <= 9 then break end
                if _tick() >= deadline then return end
                task.wait()
            end
            if not valid() then return end
            local fillStart = _tick()
            local fillDuration = math.max(duration - stopTime, 0.05)
            while valid() do
                local fp = _clamp((_tick() - fillStart) / fillDuration, 0, 1)
                updateStealProgress(stopProgress + fp * (1 - stopProgress), "STEALING")
                if fp >= 1 then break end
                task.wait()
            end
            if not valid() then return end
            for _, fn in ipairs(data.trigger) do task.spawn(fn) end
            local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
            if remote and remote:IsA("RemoteEvent") and podName then pcall(function() remote:FireServer(podName) end) end
            if #data.trigger == 0 then
                if type(fireproximityprompt) == "function" then pcall(fireproximityprompt, prompt)
                else pcall(function() prompt:InputHoldBegin(); prompt:InputHoldEnd() end) end
            end
            updateStealProgress(1, "COMPLETE")
            task.wait(0.12)
        end)
        data.ready = true
        if generation == autoStealGeneration then
            isStealing = false
            autoStealStartedAt = 0
            autoStealLastActivity = _tick()
            updateStealProgress(0, "READY")
        end
        if not success then warn("[Zenith Auto Steal] " .. tostring(err)) end
    end)
end
function startAutoSteal()
    Steal.StealRadius = autoStealVariant == 6 and 10 or CONFIG.STEAL_RANGE
    Steal.AutoStealEnabled = true
    CONFIG.AUTO_STEAL_ENABLED = true
    autoStealLastActivity = _tick()

    if stealConnection and not stealConnection.Connected then
        stealConnection = nil
    end
    if stealConnection then return true end

    stealConnection = RunService.Heartbeat:Connect(function()
        if _mySession ~= _G.RivalHubSession then
            stopAutoSteal()
            return
        end
        if not CONFIG.AUTO_STEAL_ENABLED then return end

        if not Steal.AutoStealEnabled then
            Steal.AutoStealEnabled = true
        end

        if isStealing then
            if autoStealStartedAt > 0 and (_tick() - autoStealStartedAt) > 6 then
                autoStealGeneration = autoStealGeneration + 1
                isStealing = false
                autoStealStartedAt = 0
                for _, data in pairs(Steal.Data) do
                    data.ready = true
                end
                updateStealProgress(0, "READY")
            end
            return
        end

        local p, name = findNearestPrompt()
        if p then
            autoStealLastActivity = _tick()
            executeSteal(p, name)
        end
    end)
    return true
end

function stopAutoSteal()
    autoStealGeneration = autoStealGeneration + 1
    if stealConnection then
        pcall(function() stealConnection:Disconnect() end)
        stealConnection = nil
    end
    isStealing = false
    autoStealStartedAt = 0
    autoStealLastActivity = _tick()
    Steal.AutoStealEnabled = false
    CONFIG.AUTO_STEAL_ENABLED = false
    for _, data in pairs(Steal.Data) do data.ready = true end
    updateStealProgress(0, "READY")
end

if autoStealSupervisorConn then
    pcall(function() autoStealSupervisorConn:Disconnect() end)
end
autoStealSupervisorElapsed = 0
do
    autoStealSupervisorConn = RunService.Heartbeat:Connect(function(dt)
        if _mySession ~= _G.RivalHubSession then
            if autoStealSupervisorConn then
                pcall(function() autoStealSupervisorConn:Disconnect() end)
                autoStealSupervisorConn = nil
            end
            return
        end

        autoStealSupervisorElapsed = autoStealSupervisorElapsed + dt
        if autoStealSupervisorElapsed < 0.5 then return end
        autoStealSupervisorElapsed = 0

        if CONFIG.AUTO_STEAL_ENABLED then
            local alive = stealConnection and stealConnection.Connected
            if not alive or not Steal.AutoStealEnabled then
                pcall(startAutoSteal)
            elseif isStealing and autoStealStartedAt > 0 and (_tick() - autoStealStartedAt) > 6 then
                autoStealGeneration = autoStealGeneration + 1
                isStealing = false
                autoStealStartedAt = 0
                for _, data in pairs(Steal.Data) do
                    data.ready = true
                end
                updateStealProgress(0, "READY")
            end
        end
    end)
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
stealHudHead = nil
stealHudDots = nil
stealHud = {value = 0, state = "READY", statsText = "-- FPS  ·  PING: -- MS"}
speedLabel = nil
modeValLbl = nil
normalBox, carryBox, laggerBox, lagger2Box, radInput, batSpeedBox, uiScaleBox = nil, nil, nil, nil, nil, nil, nil
modeSelectBtn, dropModeBtnRef = nil, nil
autoBatSetVisual, autoLeftSetVisual, autoRightSetVisual, setBatCounterVisual, setMedusaVisual, batAimbotSetVisual, batAimbotSpeedBox, setCloudTransparentVisual, setCloudRainbowVisual, setCloudNoSoundVisual = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
setAntiRagVisual, setUnwalkVisual, setAntiLagVisual, setLockUIVisual, setInstaGrab = nil, nil, nil, nil, nil
infJumpSetVisual = nil
infJumpModeBtn = nil
autoStealModeBtn = nil
setAntiDieVisual = nil
setAntiBatVisual = nil
setAntiFlingVisual = nil
setESPVIsual = nil
setESPLineVisual = nil
mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight, mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2, mobSetBatV2, mobSetBatAimbot, mobSetInstaReset = nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil
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
    state = state or "READY"
    stealHud.value, stealHud.state = value, state
    if progressFill then
        progressFill.Size = UDim2.new(value, 0, 1, 0)
        progressFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    end
    if stealHudHead then stealHudHead.Position = UDim2.fromOffset(80 + value * 196 - 5, 26) end
    if stealHudDots then
        local lit = _floor(value * #stealHudDots + 0.5)
        for i, d in ipairs(stealHudDots) do
            if i <= lit then
                d.BackgroundColor3 = Color3.fromRGB(186, 140, 255); d.BackgroundTransparency = 0.1
            else
                d.BackgroundColor3 = Color3.fromRGB(118, 78, 178); d.BackgroundTransparency = 0.55
            end
        end
    end
    if progressPct then progressPct.Text = _floor(value * 100 + 0.5) .. "%" end
    if progressStatus then
        progressStatus.Text = state == "APPROACH" and "GET CLOSER" or state
        progressStatus.TextColor3 = (state == "READY" or state == "CANCELLED")
            and Color3.fromRGB(172, 152, 205) or Color3.fromRGB(186, 140, 255)
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

local AntiBat = { Connection = nil }
local ANTIBAT_RANGE = 4000

function stopAntiBat()
    antiBatEnabled = false
    if AntiBat.Connection then
        AntiBat.Connection:Disconnect()
        AntiBat.Connection = nil
    end
    -- Desactivar source autobat del anti-die cuando se apaga el anti bate
    if _G.__CrystalAntiDieSource then
        pcall(_G.__CrystalAntiDieSource, "autobat", false)
    end
    -- Restaurar estados normales si el anti-die manual no está activo
    pcall(function()
        if _antiDieSources and not _antiDieSources.toggle then
            local char = LP and LP.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, true)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, true)
                hum.BreakJointsOnDeath = true
            end
        end
    end)
end

function startAntiBat()
    stopAntiBat()
    antiBatEnabled = true
    -- Activar anti-die automáticamente cuando anti bate está prendido
    if _G.__CrystalAntiDieSource then
        pcall(_G.__CrystalAntiDieSource, "autobat", true)
    end

    AntiBat.Connection = RunService.Heartbeat:Connect(function()
        if not antiBatEnabled then return end
        local character = LP.Character
        if not character then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
        -- Proteger health antes de aplicar velocidades para evitar reset
        local hum = character:FindFirstChildOfClass("Humanoid")
        if hum then
            if hum.Health <= 0 then
                pcall(function()
                    hum.Health = hum.MaxHealth or 100
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                end)
                return
            end
            pcall(function()
                hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                hum.BreakJointsOnDeath = false
            end)
        end
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
        -- Verificar health después de aplicar velocidades
        if hum and hum.Parent and hum.Health <= 0 then
            pcall(function()
                hum.Health = hum.MaxHealth or 100
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end)
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
    if autoBatEnabled or batAimbotEnabled then return true end
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
    for _, name in ipairs({"ZenithHubSpeedIndicator", "DiscordText", "ZenithHubTag"}) do
        local old = head:FindFirstChild(name)
        if old then old:Destroy() end
    end
    speedLabel = nil
    local bb = Instance.new("BillboardGui", head)
    bb.Name = "ZenithHubSpeedIndicator"
    bb.Size = UDim2.fromOffset(136, 28)
    bb.StudsOffset = Vector3.new(0, 3.5, 0)
    bb.AlwaysOnTop = true
    bb.LightInfluence = 0
    bb.MaxDistance = 0
    bb.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    local card = Instance.new("Frame", bb)
    card.Name = "SpeedCard"
    card.Size = UDim2.fromScale(1, 1)
    card.BackgroundColor3 = Color3.fromRGB(10, 14, 19)
    card.BackgroundTransparency = 0.2
    card.BorderSizePixel = 0
    Instance.new("UICorner", card).CornerRadius = UDim.new(0, 8)
    local border = Instance.new("UIStroke", card)
    border.Color = getThemeColor()
    border.Transparency = 0.62
    border.Thickness = 1
    MVPUI.speedStroke = border
    speedLabel = Instance.new("TextLabel", card)
    speedLabel.Name = "SpeedLabel"
    speedLabel.Size = UDim2.new(1, -12, 1, 0)
    speedLabel.Position = UDim2.fromOffset(6, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = string.format("VELOCIDAD: %.1f", getActiveMoveSpeed())
    speedLabel.TextColor3 = Color3.fromRGB(248, 245, 235)
    speedLabel.TextStrokeColor3 = Color3.fromRGB(15, 13, 13)
    speedLabel.TextStrokeTransparency = 0.4
    speedLabel.Font = Enum.Font.GothamMedium
    speedLabel.TextSize = 11
    speedLabel.TextXAlignment = Enum.TextXAlignment.Center
    speedLabel.ZIndex = 3
    local tag = Instance.new("BillboardGui", head)
    tag.Name = "ZenithHubTag"
    tag.Size = UDim2.fromOffset(210, 24)
    tag.StudsOffset = Vector3.new(0, 5.1, 0)
    tag.AlwaysOnTop = true
    tag.LightInfluence = 0
    tag.MaxDistance = 0
    local text = Instance.new("TextLabel", tag)
    text.Size = UDim2.fromScale(1, 1)
    text.BackgroundTransparency = 1
    text.Text = "ZENITH HUB ON TOP"
    text.TextColor3 = getThemeColor()
    text.TextStrokeColor3 = Color3.fromRGB(5, 7, 10)
    text.TextStrokeTransparency = 0.2
    text.Font = Enum.Font.GothamBold
    text.TextSize = 15
    MVPUI.discordLabel = text

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
    if mobSetLagger1 then mobSetLagger1(laggerToggled) end
    if mobSetLagger2 then mobSetLagger2(laggerCarryToggled) end
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
-- =====================================================================
-- AIMBOT BYPASS (motor unico, LinearVelocity)
-- O motor antigo de Aimbot Bypass do Zenith foi REMOVIDO por completo.
-- Speed padrao: 58.
-- Os helpers findBat/findNearestEnemy/swingBat abaixo sao usados pelo
-- Bat Aimbot (Cloud Normal) logo depois deste bloco.
-- =====================================================================
local _batSwingLocked = false
local _batNextSwingAt = 0

local function findBat()
    local char = LP.Character
    if not char then return nil end
    local equipped = char:FindFirstChildOfClass("Tool")
    if equipped then
        local name = equipped.Name:lower()
        if name:find("bat") or name:find("slap") then
            return equipped
        end
    end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, tool in ipairs(backpack:GetChildren()) do
            if tool:IsA("Tool") then
                local name = tool.Name:lower()
                if name:find("bat") or name:find("slap") then
                    return tool
                end
            end
        end
    end
    return nil
end

local function findNearestEnemy(myRoot)
    local nearest, nearestDist = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LP and player.Character then
            local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
            local targetHum = player.Character:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHum and targetHum.Health > 0 then
                local dist = (targetRoot.Position - myRoot.Position).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = player
                end
            end
        end
    end
    return nearest, nearestDist
end

local function swingBat()
    local now = tick()
    if _batSwingLocked or now < _batNextSwingAt then return end
    _batSwingLocked = true
    _batNextSwingAt = now + 0.08
    pcall(function()
        local char = LP.Character
        if not char then return end
        local bat = findBat()
        if not bat then return end
        if bat.Parent ~= char then
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum then hum:EquipTool(bat) end
        end
        bat:Activate()
        local remote = bat:FindFirstChildWhichIsA("RemoteEvent")
        if remote then remote:FireServer() end
    end)
    task.delay(0.08, function()
        _batSwingLocked = false
    end)
end

-- ---------- Aimbot Bypass (motor) ----------
local AimbotBypass = {}
local bypassState = {
    enabled = false,
    connection = nil,
    autoSwing = true,
    predCache = {},
    moverName = "Zenith_AimbotBypass_LV",
    attachmentName = "Zenith_AimbotBypass_Att",
    minForce = 1000000,
    maxForce = 50000000,
}

local function bypassGetParts()
    local char = LP.Character
    if not char then return nil, nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return nil, nil end
    return hrp, hum
end

local function bypassGetBat()
    local char = LP.Character
    if not char then return nil end
    for _, child in ipairs(char:GetChildren()) do
        if child:IsA("Tool") then
            local n = string.lower(child.Name)
            if string.find(n, "bat", 1, true) or string.find(n, "slap", 1, true) then return child end
        end
    end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    if backpack then
        for _, child in ipairs(backpack:GetChildren()) do
            if child:IsA("Tool") then
                local n = string.lower(child.Name)
                if string.find(n, "bat", 1, true) or string.find(n, "slap", 1, true) then return child end
            end
        end
    end
    return nil
end

local function bypassNearestTarget(fromPos)
    local bestDist, bestHRP = math.huge, nil
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            local char = plr.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hrp and hum and hum.Health > 0 then
                local dist = (hrp.Position - fromPos).Magnitude
                if dist < bestDist then bestDist, bestHRP = dist, hrp end
            end
        end
    end
    return bestHRP
end

local function bypassClearMover(hrp)
    if not hrp then return end
    local lv = hrp:FindFirstChild(bypassState.moverName)
    local att = hrp:FindFirstChild(bypassState.attachmentName)
    if lv and lv:IsA("LinearVelocity") then lv:Destroy() end
    if att and att:IsA("Attachment") then att:Destroy() end
end

local function bypassEnsureMover(hrp, speed)
    local att = hrp:FindFirstChild(bypassState.attachmentName)
    if not att or not att:IsA("Attachment") then
        if att then att:Destroy() end
        att = Instance.new("Attachment")
        att.Name = bypassState.attachmentName
        att.Parent = hrp
    end
    local lv = hrp:FindFirstChild(bypassState.moverName)
    if not lv or not lv:IsA("LinearVelocity") then
        if lv then lv:Destroy() end
        lv = Instance.new("LinearVelocity")
        lv.Name = bypassState.moverName
        lv.Attachment0 = att
        lv.RelativeTo = Enum.ActuatorRelativeTo.World
        lv.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
        lv.ForceLimitsEnabled = true
        lv.ForceLimitMode = Enum.ForceLimitMode.PerAxis
        lv.VectorVelocity = Vector3.zero
        lv.Parent = hrp
    else
        lv.Attachment0 = att
    end
    local force = math.clamp(hrp.AssemblyMass * math.max(speed * 220, 6000), bypassState.minForce, bypassState.maxForce)
    lv.MaxAxesForce = Vector3.new(force, force, force)
    lv.Enabled = true
    return lv
end

local function bypassApplyMove(hrp, desiredVel, speed, dt)
    local lv = bypassEnsureMover(hrp, speed)
    local alpha = 1 - math.exp(-math.max(dt, 0) * 26)
    lv.VectorVelocity = lv.VectorVelocity:Lerp(desiredVel, alpha)
end

local function bypassResetMotion()
    local hrp, hum = bypassGetParts()
    if hrp then
        bypassClearMover(hrp)
        hrp.Anchored = false
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
        local look = hrp.CFrame.LookVector
        local flat = Vector3.new(look.X, 0, look.Z)
        if flat.Magnitude > 0.01 then flat = flat.Unit else flat = Vector3.new(0, 0, -1) end
        hrp.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + flat)
    end
    if hum then
        hum.AutoRotate = true
        hum.PlatformStand = false
        pcall(function() hum:Move(Vector3.zero, false) end)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.Running) end)
    end
end

local function bypassUpdate(dt)
    if not bypassState.enabled then return end
    if _mySession ~= _G.RivalHubSession then AimbotBypass.Stop(); return end
    local hrp, hum = bypassGetParts()
    if not hrp or not hum then bypassClearMover(hrp) return end
    local target = bypassNearestTarget(hrp.Position)
    if not target then
        hum.AutoRotate = true
        hrp.AssemblyAngularVelocity = Vector3.zero
        bypassClearMover(hrp)
        return
    end
    local speed = math.clamp(tonumber(AIMBOT_BYPASS_SPEED) or 58, 1, 500)
    local now = tick()
    local cache = bypassState.predCache[target]
    local predictedVel = Vector3.zero
    if not cache then
        bypassState.predCache[target] = { pos = target.Position, time = now, vel = Vector3.zero }
    else
        local dtPred = math.clamp(now - cache.time, 1/120, 0.25)
        local rawVel = (target.Position - cache.pos) / dtPred
        if rawVel.Magnitude > 80 then rawVel = rawVel.Unit * 80 end
        cache.vel = cache.vel:Lerp(rawVel, 0.25)
        cache.pos = target.Position
        cache.time = now
        predictedVel = cache.vel
    end
    local lookAhead = math.clamp(predictedVel.Magnitude / 130, 0.05, 0.12)
    local aimPoint = target.Position + predictedVel * lookAhead + Vector3.new(0, 1, 0)
    hum.AutoRotate = false
    local toTarget = aimPoint - hrp.Position
    local flatDir = Vector3.new(toTarget.X, 0, toTarget.Z)
    if toTarget.Magnitude > 0.01 and flatDir.Magnitude > 0.01 then
        local yawDelta = (math.deg(math.atan2(-flatDir.X, -flatDir.Z)) - hrp.Orientation.Y + 180) % 360 - 180
        local pitchDelta = (math.deg(math.atan2(toTarget.Y, flatDir.Magnitude)) - hrp.Orientation.X + 180) % 360 - 180
        local yawForce = math.clamp(math.rad(yawDelta) * 285, -28, 28)
        local pitchForce = math.clamp(math.rad(pitchDelta) * 285, -28, 28)
        local right = Vector3.new(math.cos(math.rad(hrp.Orientation.Y)), 0, -math.sin(math.rad(hrp.Orientation.Y)))
        hrp.AssemblyAngularVelocity = Vector3.new(0, yawForce, 0) + right * pitchForce
    else
        hrp.AssemblyAngularVelocity = Vector3.zero
    end
    local moveVec = (aimPoint + Vector3.new(0, 4.75, 0) - hrp.Position)
    local flatMove = Vector3.new(moveVec.X, 0, moveVec.Z)
    local horizontal = flatMove.Magnitude > 0.1 and flatMove.Unit * speed or Vector3.zero
    local vertical = math.abs(moveVec.Y) > 0.1 and Vector3.new(0, math.sign(moveVec.Y) * 52, 0) or Vector3.new(0, -2, 0)
    bypassApplyMove(hrp, horizontal + vertical, speed, dt)
    if flatMove.Magnitude > 0.5 then hum:Move(flatMove.Unit, false) end
    if bypassState.autoSwing then
        local bat = bypassGetBat()
        if bat and bat.Parent == LP.Character then pcall(function() bat:Activate() end) end
    end
end

function AimbotBypass.Start()
    if bypassState.enabled then AimbotBypass.Stop() end
    bypassState.enabled = true
    bypassState.autoSwing = true
    bypassState.predCache = {}
    local _, hum = bypassGetParts()
    if hum then
        local bat = bypassGetBat()
        if bat and bat.Parent ~= LP.Character then pcall(function() hum:EquipTool(bat) end) end
    end
    bypassClearMover(select(1, bypassGetParts()))
    bypassState.connection = RunService.RenderStepped:Connect(bypassUpdate)
    print("[Aimbot Bypass] ✅ ATIVADO")
end

function AimbotBypass.Stop()
    if not bypassState.enabled and not bypassState.connection then return end
    bypassState.enabled = false
    if bypassState.connection then bypassState.connection:Disconnect(); bypassState.connection = nil end
    bypassResetMotion()
    bypassState.predCache = {}
    print("[Aimbot Bypass] ❌ DESATIVADO")
end

function AimbotBypass.IsEnabled() return bypassState.enabled end
function AimbotBypass.SetSpeed(normal)
    if normal then AIMBOT_BYPASS_SPEED = math.clamp(tonumber(normal) or 58, 1, 500) end
end
function AimbotBypass.SetAutoSwing(active) bypassState.autoSwing = active == true end

_G.__ZenithAimbotBypass = AimbotBypass
_G.__ZenithAimbotBypassState = AimbotBypass

    startAimbotAdapt = function()
        if AimbotBypass.IsEnabled() then return end
        State.bypassBatEnabled = true
        _suppressBodyLock()
        AimbotBypass.Start()
    end
    stopAimbotAdapt = function()
        local wasEnabled = AimbotBypass.IsEnabled()
        State.bypassBatEnabled = false
        AimbotBypass.Stop()
        if wasEnabled then _unsuppressBodyLock(true) end
    end
    disableAutoBat = function()
        autoBatEnabled = false
        stopAimbotAdapt()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
        if saveAllSettings then pcall(saveAllSettings) end
    end
    enableAutoBat = function()
        if batAimbotEnabled and disableBatAimbot then disableBatAimbot() end
        if _G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2() then
            _G.__RivalHubStopBatV2()
            if mobSetBatV2 then mobSetBatV2(false) end
        end
        if autoLeftEnabled then autoLeftEnabled = false; stopAutoLeft() end
        if autoRightEnabled then autoRightEnabled = false; stopAutoRight() end
        autoBatEnabled = true
        startAimbotAdapt()
        if autoBatSetVisual then autoBatSetVisual(true) end
        if mobSetAutoBat then mobSetAutoBat(true) end
        if saveAllSettings then pcall(saveAllSettings) end
    end

    -- ================= BAT AIMBOT (Aimbot Normal, integrado ao Zenith) =================
    -- Comportamento copiado do modo "Normal" integrado ao Zenith: gruda ACIMA do alvo (+3.6),
    -- velocidade com Lerp 0.85, predicao 0.13 + look*0.25, swing com distancia <= 5.5.
    local cloudBatConn = nil
    local cloudBatPrevAutoRotate = nil
    local function stopBatAimbotCloud()
        if cloudBatConn then cloudBatConn:Disconnect(); cloudBatConn = nil end
        local char = LP.Character
        if char then
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if root then root.AssemblyAngularVelocity = Vector3.zero end
            if hum then hum.AutoRotate = cloudBatPrevAutoRotate == nil and true or cloudBatPrevAutoRotate end
        end
        cloudBatPrevAutoRotate = nil
    end
    local function startBatAimbotCloud()
        stopBatAimbotCloud()
        local char0 = LP.Character
        local hum0 = char0 and char0:FindFirstChildOfClass("Humanoid")
        if hum0 then cloudBatPrevAutoRotate = hum0.AutoRotate; hum0.AutoRotate = false end
        cloudBatConn = RunService.RenderStepped:Connect(function()
            if _mySession ~= _G.RivalHubSession then if disableBatAimbot then disableBatAimbot() end; return end
            if not batAimbotEnabled then return end
            local char = LP.Character
            if not char then return end
            local root = char:FindFirstChild("HumanoidRootPart")
            local hum = char:FindFirstChildOfClass("Humanoid")
            if not root or not hum or hum.Health <= 0 then return end
            hum.AutoRotate = false
            if not char:FindFirstChildOfClass("Tool") then
                local bat = findBat()
                if bat and bat.Parent ~= char then pcall(function() hum:EquipTool(bat) end) end
            end
            local target = findNearestEnemy(root)
            if not target or not target.Character then return end
            local targetRoot = target.Character:FindFirstChild("HumanoidRootPart")
            local targetHum = target.Character:FindFirstChildOfClass("Humanoid")
            if not targetRoot or not targetHum or targetHum.Health <= 0 then return end
            local aimSpd = math.clamp(tonumber(CLOUD_BAT_AIMBOT_SPEED) or 62, 1, 200)
            if State then State.batAimbotSpeed = aimSpd end
            local targetVel = targetRoot.AssemblyLinearVelocity or Vector3.zero
            local myPos = root.Position
            local targetPos = targetRoot.Position
            local look = targetRoot.CFrame and targetRoot.CFrame.LookVector or Vector3.new(0, 0, -1)
            local predictPos = targetPos + targetVel * 0.13 + look * 0.25
            local direction = predictPos - myPos
            local flatDir = Vector3.new(direction.X, 0, direction.Z)
            flatDir = flatDir.Magnitude > 0.1 and flatDir.Unit or Vector3.new(0, 0, -1)
            local yOff = (targetPos.Y + 3.6) - myPos.Y
            local yVel = yOff * 18 + targetVel.Y * 0.75
            if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 12) end
            yVel = math.clamp(yVel, -75, 115)
            local desiredVel = Vector3.new(flatDir.X * aimSpd, yVel, flatDir.Z * aimSpd)
            root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.85)
            pcall(function() hum.WalkSpeed = aimSpd end)
            local predictTime = math.clamp(targetVel.Magnitude / 140, 0.04, 0.18)
            local predictedPos = targetPos + targetVel * predictTime
            if (predictedPos - myPos).Magnitude > 0.15 then
                local goalCF = CFrame.lookAt(myPos, predictedPos)
                local diffCF = root.CFrame:Inverse() * goalCF
                local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
                rx = math.clamp(rx, -2.4, 2.4); ry = math.clamp(ry, -2.4, 2.4); rz = math.clamp(rz, -2.4, 2.4)
                root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 40, ry * 40, rz * 40))
            end
            if (targetPos - myPos).Magnitude <= 5.5 then swingBat() end
        end)
        print("[Bat Aimbot] ✅ ACTIVADO (Zenith Normal)")
    end
    disableBatAimbot = function()
        local was = batAimbotEnabled
        batAimbotEnabled = false
        if State then State.batAimbotEnabled = false end
        stopBatAimbotCloud()
        if was then _unsuppressBodyLock(true) end
        if batAimbotSetVisual then batAimbotSetVisual(false) end
        if mobSetBatAimbot then mobSetBatAimbot(false) end
        if saveAllSettings then pcall(saveAllSettings) end
        print("[Bat Aimbot] ❌ DESACTIVADO")
    end
    enableBatAimbot = function()
        if autoBatEnabled and disableAutoBat then disableAutoBat() end
        if _G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2() then
            _G.__RivalHubStopBatV2()
            if mobSetBatV2 then mobSetBatV2(false) end
        end
        if autoLeftEnabled then autoLeftEnabled = false; stopAutoLeft() end
        if autoRightEnabled then autoRightEnabled = false; stopAutoRight() end
        batAimbotEnabled = true
        if State then State.batAimbotEnabled = true end
        _suppressBodyLock()
        startBatAimbotCloud()
        if batAimbotSetVisual then batAimbotSetVisual(true) end
        if mobSetBatAimbot then mobSetBatAimbot(true) end
        if saveAllSettings then pcall(saveAllSettings) end
    end
    _G.__ZenithBatAimbotCloud = { enable = function() enableBatAimbot() end, disable = function() disableBatAimbot() end }
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

local batCounterDebounce = false

function findBatForCounter()
    local character = LP.Character
    if not character then return nil end
    local backpack = LP:FindFirstChildOfClass("Backpack")
    for _, name in ipairs(BAT_COUNTER_SLAP_LIST) do
        local tool = character:FindFirstChild(name) or (backpack and backpack:FindFirstChild(name))
        if tool and tool:IsA("Tool") then return tool end
    end
    for _, container in ipairs({character, backpack}) do
        if container then
            for _, tool in ipairs(container:GetChildren()) do
                if tool:IsA("Tool") then
                    local name = tool.Name:lower()
                    if name:find("bat") or name:find("slap") then return tool end
                end
            end
        end
    end
    return nil
end

function swingBatForCounter(bat, character)
    if not bat or not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if bat.Parent ~= character and humanoid then
        pcall(function() humanoid:EquipTool(bat) end)
        task.wait(0.05)
    end
    local remote = bat:FindFirstChildWhichIsA("RemoteEvent", true)
    if remote then
        pcall(function() remote:FireServer() end)
        task.wait(0.12)
        pcall(function() remote:FireServer() end)
    else
        pcall(function() bat:Activate() end)
        task.wait(0.12)
        pcall(function() bat:Activate() end)
    end
end

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
        if not batCounterEnabled or batCounterDebounce then return end
        local character = LP.Character
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then return end
        local state = humanoid:GetState()
        if state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.FallingDown then
            batCounterDebounce = true
            task.spawn(function()
                local ok, bat = pcall(findBatForCounter)
                if ok and bat then pcall(swingBatForCounter, bat, character) end
                task.wait(0.5)
                batCounterDebounce = false
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

function MVPUI.new(class, parent, props)
    local object = Instance.new(class)
    -- Uma propriedade inválida não deve interromper a construção da UI inteira.
    for key, value in pairs(props or {}) do
        local ok, err = pcall(function() object[key] = value end)
        if not ok then
            warn("[Zenith UI] Propriedade ignorada: " .. tostring(class) .. "." .. tostring(key) .. " - " .. tostring(err))
        end
    end
    object.Parent = parent
    return object
end
function MVPUI.round(object, radius)
    local corner = object:FindFirstChildOfClass("UICorner") or Instance.new("UICorner", object)
    corner.CornerRadius = UDim.new(0, radius or 12)
    return corner
end
function MVPUI.stroke(object, color, transparency, thickness)
    return MVPUI.new("UIStroke", object, {Color = color, Transparency = transparency or 0,
        Thickness = thickness or 1, ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
end
function MVPUI.text(parent, text, position, size, fontSize, color, z)
    return MVPUI.new("TextLabel", parent, {Text = text, Position = position, Size = size,
        BackgroundTransparency = 1, TextColor3 = color or Color3.fromRGB(245, 241, 235),
        Font = Enum.Font.GothamMedium, TextSize = fontSize or 12, ZIndex = z or 8,
        TextXAlignment = Enum.TextXAlignment.Left, TextTruncate = Enum.TextTruncate.AtEnd})
end
function MVPUI.pumpkin(parent, position, size, z)
    local root = MVPUI.new("Frame", parent, {Name = "Pumpkin", Size = UDim2.fromOffset(size, size),
        Position = position, BackgroundTransparency = 1, ZIndex = z, Active = false})
    local function part(x, y, w, h, color, radius, rotation)
        local object = MVPUI.new("Frame", root, {Size = UDim2.fromScale(w, h), Position = UDim2.fromScale(x, y),
            BackgroundColor3 = color, BorderSizePixel = 0, Rotation = rotation or 0, ZIndex = z + 1})
        MVPUI.round(object, radius)
        return object
    end
    part(0.42, 0.02, 0.12, 0.23, Color3.fromRGB(112, 125, 65), 3, 16)
    part(0.04, 0.22, 0.92, 0.68, Color3.fromRGB(164, 64, 24), size)
    part(0.09, 0.20, 0.52, 0.70, Color3.fromRGB(246, 115, 37), size)
    part(0.40, 0.20, 0.51, 0.70, Color3.fromRGB(222, 88, 27), size)
    local lobe = part(0.29, 0.17, 0.43, 0.75, Color3.fromRGB(255, 156, 63), size)
    MVPUI.new("UIGradient", lobe, {Rotation = 90, Color = ColorSequence.new(
        Color3.fromRGB(255, 212, 130), Color3.fromRGB(218, 96, 32))})
    part(0.24, 0.38, 0.16, 0.12, Color3.fromRGB(33, 20, 17), 2, -20)
    part(0.61, 0.38, 0.16, 0.12, Color3.fromRGB(33, 20, 17), 2, 20)
    part(0.33, 0.65, 0.35, 0.10, Color3.fromRGB(44, 24, 17), 3)
    part(0.43, 0.62, 0.06, 0.08, Color3.fromRGB(255, 173, 80), 1)
    part(0.55, 0.68, 0.06, 0.08, Color3.fromRGB(255, 173, 80), 1)
    return root
end
function MVPUI.web(parent, position, size, z)
    local root = MVPUI.new("Frame", parent, {Name = "Web", Position = position,
        Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1, ZIndex = z})
    local function line(x1, y1, x2, y2)
        local dx, dy = x2 - x1, y2 - y1
        MVPUI.new("Frame", root, {Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy), 1),
            Position = UDim2.fromOffset((x1 + x2) / 2, (y1 + y2) / 2), AnchorPoint = Vector2.new(0.5, 0.5),
            Rotation = math.deg(math.atan2(dy, dx)), BackgroundColor3 = Color3.fromRGB(220, 174, 128),
            BackgroundTransparency = 0.84, BorderSizePixel = 0, ZIndex = z})
    end
    for i = 0, 4 do
        local a = math.pi * i / 8
        line(0, 0, math.cos(a) * size, math.sin(a) * size)
    end
    for ring = 1, 3 do
        local r = size * ring / 3
        for i = 0, 3 do
            local a, b = math.pi * i / 8, math.pi * (i + 1) / 8
            line(math.cos(a) * r, math.sin(a) * r, math.cos(b) * r, math.sin(b) * r)
        end
    end
    return root
end
function MVPUI.sectionIcon(parent, name, position, size, color, z)
    local root = MVPUI.new("Frame", parent, {Name = "SectionIcon", Position = position,
        Size = UDim2.fromOffset(size, size), BackgroundTransparency = 1, ZIndex = z})
    local function line(x1, y1, x2, y2, thickness)
        local dx, dy = x2 - x1, y2 - y1
        local ink = MVPUI.new("Frame", root, {Name = "IconInk", AnchorPoint = Vector2.new(0.5, 0.5),
            Position = UDim2.fromScale((x1 + x2) / 2, (y1 + y2) / 2),
            Size = UDim2.fromOffset(math.sqrt(dx * dx + dy * dy) * size, thickness or 1.6),
            BackgroundColor3 = color, BorderSizePixel = 0, Rotation = math.deg(math.atan2(dy, dx)), ZIndex = z})
        MVPUI.round(ink, 2)
    end
    local function box(x, y, w, h, radius, solid)
        local object = MVPUI.new("Frame", root, {Name = "IconInk", Position = UDim2.fromScale(x, y),
            Size = UDim2.fromScale(w, h), BackgroundColor3 = color, BackgroundTransparency = solid and 0 or 1,
            BorderSizePixel = 0, ZIndex = z})
        MVPUI.round(object, radius)
        if not solid then MVPUI.stroke(object, color, 0, 1.4) end
        return object
    end
    if name == "Speed" then
        line(0.18, 0.22, 0.44, 0.5); line(0.44, 0.5, 0.18, 0.78)
        line(0.52, 0.22, 0.79, 0.5); line(0.79, 0.5, 0.52, 0.78)
    elseif name == "Custom" then
        line(0.5, 0.1, 0.83, 0.24); line(0.83, 0.24, 0.78, 0.62)
        line(0.78, 0.62, 0.5, 0.88); line(0.5, 0.88, 0.22, 0.62)
        line(0.22, 0.62, 0.17, 0.24); line(0.17, 0.24, 0.5, 0.1)
        line(0.36, 0.47, 0.47, 0.58); line(0.47, 0.58, 0.66, 0.37)
    elseif name == "Visual" then
        box(0.15, 0.15, 0.27, 0.27, 2, false)
        box(0.58, 0.15, 0.27, 0.27, 2, true)
        box(0.15, 0.58, 0.27, 0.27, 2, true)
        box(0.58, 0.58, 0.27, 0.27, 2, false)
    elseif name == "Settings" then
        line(0.5, 0.13, 0.82, 0.3); line(0.82, 0.3, 0.82, 0.77)
        line(0.82, 0.77, 0.18, 0.77); line(0.18, 0.77, 0.18, 0.3)
        line(0.18, 0.3, 0.5, 0.13); line(0.18, 0.3, 0.82, 0.3)
        line(0.5, 0.39, 0.5, 0.67); line(0.37, 0.54, 0.5, 0.67); line(0.63, 0.54, 0.5, 0.67)
    elseif name == "Keybinds" then
        box(0.08, 0.22, 0.84, 0.56, 3, false)
        box(0.2, 0.37, 0.12, 0.12, 1, true)
        box(0.44, 0.37, 0.12, 0.12, 1, true)
        box(0.68, 0.37, 0.12, 0.12, 1, true)
        line(0.29, 0.64, 0.71, 0.64)
    end
    return root
end
function MVPUI.colorSectionIcon(root, color)
    if not root then return end
    for _, object in ipairs(root:GetDescendants()) do
        if object:IsA("Frame") and object.Name == "IconInk" then object.BackgroundColor3 = color end
        if object:IsA("UIStroke") then object.Color = color end
    end
end

function MVPUI.fit()
    if not mainUIScale or not main or not main.Parent then return end
    local cam = Workspace.CurrentCamera
    if not cam then return end
    local viewport = cam.ViewportSize
    local width = 350
    local scale = math.max(0.25, math.min(uiScaleValue / 100, (viewport.X - 24) / width, (viewport.Y - 24) / 460))
    local height = math.min(540, math.floor((viewport.Y - 24) / scale))
    mainUIScale.Scale = scale
    MVPUI.width, MVPUI.height = width, height
    main.Size = UDim2.fromOffset(width, height)
    local size = Vector2.new(width * mainUIScale.Scale, height * mainUIScale.Scale)
    local point = main.AbsolutePosition
    main.Position = UDim2.fromOffset(_clamp(point.X, 8, math.max(8, viewport.X - size.X - 8)),
        _clamp(point.Y, 8, math.max(8, viewport.Y - size.Y - 8)))
    if pbFrame and pbFrame.Parent and MVPUI.hudScale then
        local compact = viewport.X < 600 or viewport.X < viewport.Y * 1.18
        local right = main.Position.X.Offset + size.X + 14
        local room = viewport.X - right - 12
        local hudScale = compact and math.min(1, (viewport.X - 24) / 344) or math.clamp(room / 344, 0.65, 1)
        MVPUI.hudScale.Scale = hudScale
        local hudWidth, hudHeight = 344 * hudScale, 68 * hudScale
        if not savedProgressBarPos then
            if compact then
                pbFrame.Position = UDim2.fromOffset((viewport.X - hudWidth) / 2,
                    math.min(viewport.Y - hudHeight - 12, main.Position.Y.Offset + size.Y + 14))
            else
                pbFrame.Position = UDim2.fromOffset(viewport.X - hudWidth - 12, 16)
            end
        else
            local p = pbFrame.AbsolutePosition
            pbFrame.Position = UDim2.fromOffset(math.clamp(p.X, 6, math.max(6, viewport.X - hudWidth - 6)),
                math.clamp(p.Y, 6, math.max(6, viewport.Y - hudHeight - 6)))
        end
    end
end
function MVPUI.effectsLoop(root)
    local state = MVPUI
    if state.effectConn then state.effectConn:Disconnect() end
    local accumulator, elapsed = 0, 0
    local connection
    connection = RunService.Heartbeat:Connect(function(dt)
        if not root.Parent or _mySession ~= _G.RivalHubSession then
            connection:Disconnect()
            if state.effectConn == connection then state.effectConn = nil end
            return
        end
        accumulator = accumulator + dt
        elapsed = elapsed + dt
        if accumulator < 1 / 24 then return end
        accumulator = 0
        local panel = root:FindFirstChild("Main")
        if not state.effects or not panel or not panel.Visible then return end
        for i, item in ipairs(state.animated) do
            if item.object.Parent then
                item.object.Position = item.position + UDim2.fromOffset(math.sin(elapsed * 0.6 + i) * (item.x or 0),
                    math.sin(elapsed * 1.1 + i) * (item.y or 4))
                if item.rotate then item.object.Rotation = math.sin(elapsed * 0.7 + i) * item.rotate end
            end
        end
        if state.titleGradient and state.titleGradient.Parent then
            state.titleGradient.Offset = Vector2.new(math.sin(elapsed * 0.45) * 0.28, 0)
        end
    end)
    state.effectConn = connection
    root.Destroying:Connect(function()
        connection:Disconnect()
        if state.effectConn == connection then state.effectConn = nil end
        for _, tween in pairs(state.tweens) do pcall(function() tween:Cancel() end) end
        if state.backgroundTween then pcall(function() state.backgroundTween:Cancel() end) end
        state.animated, state.cards, state.tweens = {}, {}, {}
    end)
end

function paintFloatingBtn(button, active)
    if not button or not button.Parent then return end
    local accentColor = Color3.fromRGB(190, 112, 255)
    button.BackgroundColor3 = active and Color3.fromRGB(93, 35, 170) or Color3.fromRGB(15, 10, 27)
    local gradient = button:FindFirstChild("BtnGrad")
    if gradient then
        gradient.Color = active
            and ColorSequence.new(Color3.fromRGB(177, 77, 255), Color3.fromRGB(73, 25, 145))
            or ColorSequence.new(Color3.fromRGB(45, 27, 75), Color3.fromRGB(12, 9, 23))
    end
    local stroke = button:FindFirstChildOfClass("UIStroke")
    if stroke then
        stroke.Color = active and Color3.fromRGB(221, 170, 255) or Color3.fromRGB(126, 67, 194)
        stroke.Thickness = active and 2 or 1.25
        stroke.Transparency = active and 0.02 or 0.18
    end
    local textColor = active and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(224, 207, 255)
    local label = button:FindFirstChild("TextLabel")
    if label then
        label.TextColor3 = textColor
    end
    local status = button:FindFirstChild("Status")
    if status then
        status.Text = active and "ON" or "OFF"
        status.TextColor3 = active and Color3.fromRGB(232, 200, 255) or Color3.fromRGB(167, 137, 198)
    end
    local dot = button:FindFirstChild("StatusDot")
    if dot then
        dot.BackgroundColor3 = active and Color3.fromRGB(224, 170, 255) or Color3.fromRGB(89, 52, 125)
    end
    local edge = button:FindFirstChild("AccentEdge")
    if edge then
        edge.BackgroundColor3 = accentColor
        edge.BackgroundTransparency = active and 0.15 or 0.8
    end
end

function applyMobileButtonStyle()
    local circle = (mobileButtonStyle == "Circle")
    if MobilePanel then
        for _, btn in ipairs(MobilePanel:GetChildren()) do
            if btn:IsA("TextButton") then
                local corner = btn:FindFirstChildOfClass("UICorner")
                if corner then corner.CornerRadius = UDim.new(0, circle and 44 or 11) end
                btn.Size = UDim2.fromOffset(88, circle and 88 or 76)
            end
        end
    end
end

function applyFloatingButtonScale()
    for _, uiScale in ipairs(_floatingUIScales) do
        if uiScale and uiScale.Parent then
            uiScale.Scale = floatingButtonScale
            local button = uiScale.Parent
            if button:IsA("GuiObject") and Workspace.CurrentCamera then
                local viewport = Workspace.CurrentCamera.ViewportSize
                local size = 64 * floatingButtonScale
                button.Position = UDim2.fromOffset(_clamp(button.Position.X.Offset, 6, math.max(6, viewport.X - size - 6)),
                    _clamp(button.Position.Y.Offset, 6, math.max(6, viewport.Y - size - 6)))
            end
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

_G.__RivalHubSpeedEngine = _G.__RivalHubSpeedEngine or {}
do
    local function blocked(hum)
        return not hum or hum.Health <= 0 or _isRagdollState(hum) or autoBatEnabled or batAimbotEnabled
            or autoLeftEnabled or autoRightEnabled or dropActive or _G.IsDropping
            or TPBatState.enabled or (_G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2())
    end
    local function applyNow()
        local char = LP.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root or blocked(hum) then lastMoveDir = _V3zero; return end
        if useVenixCarryEngine then return end
        if _s2VelState.root ~= root then _hookVelHRP(_setupVelChecked(char)) end
        local direction = hum.MoveDirection
        if direction.Magnitude > 0 then lastMoveDir = direction
        else
            direction = nil
            if lastMoveDir.Magnitude > 0 then
                for key in pairs(MOVE_KEYS) do
                    if UIS:IsKeyDown(key) then direction = lastMoveDir; break end
                end
            end
        end
        _applyVelocitySpeed(direction, getActiveMoveSpeed(), root)
    end
    local function stop()
        if _G.__RivalHubSpeedEngine.conn then _G.__RivalHubSpeedEngine.conn:Disconnect(); _G.__RivalHubSpeedEngine.conn = nil end
        MVPVenixCarry:stop()
        lastMoveDir = _V3zero
    end
    local function start()
        stop()
        if useVenixCarryEngine then MVPVenixCarry:start() end
        _G.__RivalHubSpeedEngine.conn = RunService.RenderStepped:Connect(function()
            if _mySession ~= _G.RivalHubSession then stop(); return end
            applyNow()
        end)
    end
    _G.__RivalHubRefreshSpeedEngine = start
    _G.__RivalHubStopSpeedEngine = stop
    _G.__RivalHubApplySpeedNow = applyNow
    pcall(start)
    LP.CharacterRemoving:Connect(function() stop(); _s2VelState.root = nil end)
    LP.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if _mySession ~= _G.RivalHubSession then return end
        _hookVelHRP(_setupVelChecked(char))
        start()
    end)
end

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

    local frameCount, lastStats, statAccumulator = 0, _tick(), 0
    movementLoop = RunService.RenderStepped:Connect(function(dt)
        frameCount = frameCount + 1
        statAccumulator = statAccumulator + dt
        if statAccumulator >= 0.5 then
            local now = _tick()
            local fps = _floor(frameCount / math.max(now - lastStats, 0.01) + 0.5)
            frameCount, statAccumulator, lastStats = 0, 0, now
            local ping
            pcall(function() ping = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue() end)
            if type(ping) ~= "number" then pcall(function() ping = LP:GetNetworkPing() * 1000 end) end
            local pingText = type(ping) == "number" and tostring(_floor(ping + 0.5)) or "--"
            stealHud.statsText = tostring(fps) .. " FPS  ·  PING: " .. pingText .. " MS"
            if stealHud.stats and stealHud.stats.Parent then stealHud.stats.Text = stealHud.statsText end
            if stealHud.mode and stealHud.mode.Parent then stealHud.mode.Text = autoStealMode end
            if MVPUI.footerStats and MVPUI.footerStats.Parent then MVPUI.footerStats.Text = stealHud.statsText end
        end
        local char2 = LP.Character
        if not char2 then return end
        local hum = char2:FindFirstChildOfClass("Humanoid")
        local hrp = char2:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        if not autoBatEnabled and not batAimbotEnabled and not autoLeftEnabled and not autoRightEnabled then
            if _isRagdollState(hum) then
                lastMoveDir = _V3zero
            else
                local md = hum.MoveDirection
                if md.Magnitude > 0 then
                    lastMoveDir = md
                end
            end
        end
        if speedLabel and speedLabel.Parent then
            local displaySpeed = getActiveMoveSpeed()
            speedLabel.Text = string.format("VELOCIDAD: %.1f", displaySpeed)
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
    if batAimbotEnabled and disableBatAimbot then disableBatAimbot() end
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
        unwalkEnabled = unwalkEnabled,
        laggerToggled = laggerToggled, laggerCarryToggled = laggerCarryToggled,
        carryMode = speedMode, aimbotBypassSpeedCfg = AIMBOT_BYPASS_SPEED,
        batAimbot = batAimbotEnabled, batAimbotNormalSpeed = CLOUD_BAT_AIMBOT_SPEED,
        cloudBatCustom = _G.ZenithCloudBatCustomKey or "off", cloudMedusaCustom = _G.ZenithCloudMedusaCustomKey or "off",
        cloudTransparent = _G.ZenithCloudTransparent == true, cloudRainbow = _G.ZenithCloudRainbow == true, cloudBatNoSound = _G.ZenithCloudBatNoSound == true,
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
        batAimbotKey = {kb = KB.BatAimbot.kb and KB.BatAimbot.kb.Name, gp = KB.BatAimbot.gp and KB.BatAimbot.gp.Name},
        tpFloorKey = {kb = KB.TPFloor.kb and KB.TPFloor.kb.Name, gp = KB.TPFloor.gp and KB.TPFloor.gp.Name},
        guiHideKey = {kb = KB.GuiHide.kb and KB.GuiHide.kb.Name, gp = KB.GuiHide.gp and KB.GuiHide.gp.Name},
        carryToggleKey = {kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name, gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name},
        laggerModeKey = {kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name, gp = KB.LaggerMode.gp and KB.LaggerMode.gp.Name},
        batV2Key = {kb = KB.BatV2.kb and KB.BatV2.kb.Name, gp = KB.BatV2.gp and KB.BatV2.gp.Name},
        bodyLockEnabled = bodyLockEnabled, bodyLockRange = bodyLockRange,
        progressBarPos = savedProgressBarPos, lockUI = uiLocked,
        backgroundIndex = backgroundIndex,
        backgroundImageTransparency = backgroundImageTransparency,
        backgroundMode = backgroundMode, floatingButtonScale = floatingButtonScale, mobileButtonStyle = mobileButtonStyle,
        outfitIndex = currentOutfitIndex, vx7AvatarIndex = VX7A.index, themeColor = currentColorTheme,
        rivalTitleTheme = currentRivalTitleTheme,
        infiniteJumpEnabled = InfiniteJump.enabled == true,
        infiniteJumpMode = InfiniteJump.mode == "manual" and "manual" or "hold",
        autoStealMode = autoStealMode,
        useVenixCarryEngine = useVenixCarryEngine,
        softCarry = MVPVenixCarry.softStealEnabled,
        softCarrySpeed = MVPVenixCarry.softStealSpeed,
        softCarryRadius = MVPVenixCarry.softStealRadius,
        uiEffects = MVPUI.effects,
        mobileButtonsLocked = mobileButtonsLocked,
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
        local legacyPaths = {"MVP.json"}

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
    batAimbotEnabled = boolOr(data.batAimbot, false)
    CLOUD_BAT_AIMBOT_SPEED = math.clamp(num(data.batAimbotNormalSpeed, CLOUD_BAT_AIMBOT_SPEED), 1, 200)
    _G.ZenithCloudBatCustomKey = tostring(data.cloudBatCustom or _G.ZenithCloudBatCustomKey or "off")
    _G.ZenithCloudMedusaCustomKey = tostring(data.cloudMedusaCustom or _G.ZenithCloudMedusaCustomKey or "off")
    _G.ZenithCloudTransparent = boolOr(data.cloudTransparent, _G.ZenithCloudTransparent == true)
    _G.ZenithCloudRainbow = boolOr(data.cloudRainbow, _G.ZenithCloudRainbow == true)
    _G.ZenithCloudBatNoSound = boolOr(data.cloudBatNoSound, _G.ZenithCloudBatNoSound == true)
    autoLeftEnabled = boolOr(data.autoLeft, false)
    autoRightEnabled = boolOr(data.autoRight, false)
    setAutoStealMode(data.autoStealMode or "75")
    useVenixCarryEngine = boolOr(data.useVenixCarryEngine, false)
    MVPVenixCarry.softStealSpeed = _clamp(num(data.softCarrySpeed, 30), 1, 500)
    MVPVenixCarry.softStealRadius = _clamp(num(data.softCarryRadius, 10), 1, 200)
    MVPVenixCarry:setSoftStealEnabled(boolOr(data.softCarry, false))
    MVPUI.effects = boolOr(data.uiEffects, true)
    mobileButtonsLocked = boolOr(data.mobileButtonsLocked, false)
    if data.mobileButtonStyle == "Circle" or data.mobileButtonStyle == "Normal" then mobileButtonStyle = data.mobileButtonStyle end
    if _G.__RivalHubRefreshSpeedEngine then pcall(_G.__RivalHubRefreshSpeedEngine) end
    InfiniteJump.mode = data.infiniteJumpMode == "manual" and "manual" or "hold"
    InfiniteJump.enabled = boolOr(data.infiniteJumpEnabled, false)
    medusaCounterEnabled = boolOr(data.medusaCounter, false)
    batCounterEnabled = boolOr(data.batCounter, false)
    unwalkEnabled = boolOr(data.unwalkEnabled, boolOr(data.unwalk, false))
    antiLagEnabled = boolOr(data.antiLag, false)
    laggerToggled = boolOr(data.laggerToggled, false)
    speedMode = boolOr(data.carryMode, false)
    laggerCarryToggled = boolOr(data.laggerCarryToggled, false)
    uiScaleValue = _clamp(num(data.uiScale, 90), 50, 150)
    if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
    if pbScale then pbScale.Scale = uiScaleValue / 100 end
    espEnabled = boolOr(data.espEnabled, false)
    espLineEnabled = boolOr(data.espLineEnabled, false)
    if espEnabled then pcall(toggleESP, true) else pcall(toggleESP, false) end

    vividGraphicsEnabled = boolOr(data.vividGraphics, false)
    hideButtonsEnabled = boolOr(data.hideButtons, false)

    TPBatState.enabled = false

    currentColorTheme = COLOR_THEMES[data.themeColor] and data.themeColor or "Orange"
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
        e.kb = d.kb and Enum.KeyCode[d.kb] or nil
        e.gp = d.gp and Enum.KeyCode[d.gp] or nil
    end
    lk(KB.DropBrainrot, data.dropBrainrotKey)
    lk(KB.AutoLeft, data.autoLeftKey)
    lk(KB.AutoRight, data.autoRightKey)
    lk(KB.AutoBat, data.autoBatKey)
    lk(KB.BatAimbot, data.batAimbotKey)
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
    AIMBOT_BYPASS_SPEED = math.clamp(num(data.aimbotBypassSpeedCfg, num(data.emberBypassSpeed, num(data.batAimbotSpeed, AIMBOT_BYPASS_SPEED))), 1, 500)
    if State then State.bypassBatSpeed = AIMBOT_BYPASS_SPEED end

    backgroundIndex = _clamp(_floor(num(data.backgroundIndex, 1)), 1, #backgroundImages)
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

    floatingButtonScale = 0.77

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
    if batSpeedBox then batSpeedBox.Text = tostring(AIMBOT_BYPASS_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    local function safeSet(fn, val) if fn then fn(val) end end
    safeSet(autoBatSetVisual, false)
    safeSet(batAimbotSetVisual, false)
    if batAimbotSpeedBox then batAimbotSpeedBox.Text = tostring(CLOUD_BAT_AIMBOT_SPEED) end
    safeSet(autoLeftSetVisual, false)
    safeSet(autoRightSetVisual, false)
    safeSet(setBatCounterVisual, false)
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
    if autoStealModeBtn then autoStealModeBtn.Text = autoStealMode end
    if MVPUI.motorLabel then MVPUI.motorLabel.Text = "Direct" end
    if MVPUI.carrySetter then MVPUI.carrySetter(false) end
    if MVPUI.effectsSetter then MVPUI.effectsSetter(MVPUI.effects) end
    if MVPUI.lockButtonsSetter then MVPUI.lockButtonsSetter(false) end
    applyBackgroundMode(backgroundMode)
    if _G.__RivalHubRefreshSpeedEngine then pcall(_G.__RivalHubRefreshSpeedEngine) end
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
    currentColorTheme = "Orange"
    selectedColor = COLOR_THEMES["Orange"]
    updateAllUIThemeColors(selectedColor)
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
        pbFrame.Position = UDim2.new(1, -362, 0, 18)
        savedProgressBarPos = nil
    end
    savedMobilePanelPos = nil
    if MVPUI.fit then MVPUI.fit() end
end

function resetToFactoryDefaults()
    _isResetting = true
    local ok, err = pcall(function()
        stopAutoSteal()
        stopBatCounter()
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
        CONFIG.STEAL_RANGE = 61
        CONFIG.HOLD_MIN = 0.05
        CONFIG.HOLD_MAX = 0.15
        CONFIG.ENTRY_DELAY = 0.1
        CONFIG.COOLDOWN = 0.2
        CONFIG.PRIME_RANGE = 60
        speedMode = false; laggerToggled = false; laggerCarryToggled = false
        antiRagdollMode = "off"; antiDieEnabled = false
        antiBatEnabled = false
        antiFlingEnabled = false
        medusaCounterEnabled = false; batCounterEnabled = false
        autoBatEnabled = false; batAimbotEnabled = false; CLOUD_BAT_AIMBOT_SPEED = 62; _G.ZenithCloudBatCustomKey = "off"; _G.ZenithCloudMedusaCustomKey = "off"; _G.ZenithCloudTransparent = false; _G.ZenithCloudRainbow = false; _G.ZenithCloudBatNoSound = false; autoLeftEnabled = false; autoRightEnabled = false
        unwalkEnabled = false; antiLagEnabled = false
        uiLocked = false; mobileButtonsLocked = false
        CONFIG.AUTO_STEAL_ENABLED = false
        setAutoStealMode("75")
        useVenixCarryEngine = false
        MVPVenixCarry:stop()
        MVPVenixCarry.softStealEnabled = false
        MVPVenixCarry.softStealSpeed = 30
        MVPVenixCarry.softStealRadius = 10
        MVPUI.effects = true
        if _G._rivalHubStealModeSetter then pcall(_G._rivalHubStealModeSetter, "V1") end
        AIMBOT_BYPASS_SPEED = 58
        if State then State.bypassBatSpeed = AIMBOT_BYPASS_SPEED end
        dropMode = 1; stretchEnabled = false; stretchFOV = 120
        uiScaleValue = 90
        if MVPUI.fit then MVPUI.fit() end
        if pbScale then pbScale.Scale = 1 end
        espEnabled = false; espLineEnabled = false; vividGraphicsEnabled = false; hideButtonsEnabled = false
        bodyLockEnabled = false; bodyLockRange = 20
        backgroundIndex = 1; backgroundImageTransparency = 0.15; backgroundMode = "Background 1"
        floatingButtonScale = 0.77
        currentAnimPack = "Off"; stopAnimPack()
        currentOutfitIndex = 1
        pcall(VX7A.stop)
        currentColorTheme = "Orange"; selectedColor = COLOR_THEMES["Orange"]
        currentRivalTitleTheme = "Orange"
        applyRivalTitleTheme("Orange")
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

function getDefaultButtonPosition(name)
    -- Grade igual a do Prime: 3 colunas x 4 linhas colada na direita e
    -- centralizada na vertical. Mapa = (coluna, linha) de cada botao.
    local map = {InstaReset = {1, 1}, DropBR = {2, 1}, AutoLeft = {3, 1},
        BatV2 = {1, 2}, BatAimbot = {2, 2}, AutoRight = {3, 2},
        TpDown = {2, 3}, Carry = {3, 3},
        AutoBat = {1, 4}, Lagger2 = {2, 4}, Lagger1 = {3, 4}}
    local slot = map[name] or {1, 3}
    local cam = Workspace.CurrentCamera
    local size = cam and cam.ViewportSize or Vector2.new(844, 390)
    local W, H = 88 * floatingButtonScale, 76 * floatingButtonScale
    local GAP_X, GAP_Y, MARGIN_R = 8, 14, 12
    local totalW = W * 3 + GAP_X * 2
    local totalH = H * 4 + GAP_Y * 3
    local x = size.X - (totalW + MARGIN_R) + (slot[1] - 1) * (W + GAP_X)
    local y = size.Y / 2 - totalH / 2 + (slot[2] - 1) * (H + GAP_Y)
    return x, y
end

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
    local _antiDieCooldown = false
    table.insert(TPBatState.antiDieConnections,
        humanoid:GetPropertyChangedSignal("Health"):Connect(function()
            if _antiDieCooldown then return end
            if TPBatState.enabled and humanoid.Parent and humanoid.Health <= 0 then
                _antiDieCooldown = true
                task.defer(function()
                    pcall(function()
                        if humanoid and humanoid.Parent then
                            humanoid.Health = humanoid.MaxHealth
                            humanoid:ChangeState(Enum.HumanoidStateType.Running)
                        end
                    end)
                    task.wait(0.5)
                    _antiDieCooldown = false
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
        local ev = bat:FindFirstChildWhichIsA("RemoteEvent", true)
        if ev then pcall(function() ev:FireServer() end) end
    end)
    task.delay(0.05, function()
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

    -- TP suave con Lerp + zerear velocidad en cada frame para no salir volando
    local targetPos = targetRoot.Position + Vector3.new(0, 0.9, 0)
    if closestDistance > 5 then
        root.CFrame = CFrame.new(targetPos, targetRoot.Position)
    elseif closestDistance > 2 then
        root.CFrame = CFrame.new(root.Position:Lerp(targetPos, 0.35), targetRoot.Position)
    end

    pcall(function()
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end)

    local cam = workspace.CurrentCamera
    if cam then
        cam.CFrame = CFrame.new(cam.CFrame.Position, targetRoot.Position + Vector3.new(0, 0.5, 0))
    end

    tpBatSwing()
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


local _MVPPingLaggerScreen = nil
function openMVPPingLagger()
    if _MVPPingLaggerScreen and _MVPPingLaggerScreen.Parent then
        local existingMain = _MVPPingLaggerScreen:FindFirstChild("MainFrame")
        if existingMain then existingMain.Visible = true end
        return _MVPPingLaggerScreen
    end
    -- Galaxy Ping Lagger integrado en MVP
    -- PC + Controller keybind | Customizable | Auto-save | Auto Brainrot Detection | Modos LOW/MED/HIGH

    local UserInputService = game:GetService("UserInputService")
    local TweenService     = game:GetService("TweenService")
    local HttpService      = game:GetService("HttpService")
    local Players          = game:GetService("Players")
    local RunService       = game:GetService("RunService")

    local plr              = Players.LocalPlayer
    local plrGui           = plr:WaitForChild("PlayerGui")

    -- ══════════════════════════════════════════════════════════════════════
    -- CONFIG & SAVE
    -- ══════════════════════════════════════════════════════════════════════
    local CONFIG_FILE = "MVPPingLagger_Config.json"

    local DEFAULT_CFG = {
        power         = 100000,
        interval      = 0.125,
        keybindKb     = "F",
        keybindGp     = "ButtonR2",
        autoBrainrot  = true,
        mode          = "LOW",
    }

    local MODES = {
        LOW  = { power = 100000, interval = 0.125  },
        MED  = { power = 100000, interval = 0.12   },
        HIGH = { power = 100000, interval = 0.0125 },
    }

    local cfg = {
        power         = DEFAULT_CFG.power,
        interval      = DEFAULT_CFG.interval,
        keybindKb     = DEFAULT_CFG.keybindKb,
        keybindGp     = DEFAULT_CFG.keybindGp,
        autoBrainrot  = DEFAULT_CFG.autoBrainrot,
        mode          = DEFAULT_CFG.mode,
    }

    local function resolveKb(name)
        if not name or name == "" or name == "None" then return nil end
        local ok, val = pcall(function() return Enum.KeyCode[name] end)
        return (ok and val) or nil
    end

    local function saveConfig()
        local ok, encoded = pcall(function() return HttpService:JSONEncode(cfg) end)
        if ok and encoded and writefile then
            pcall(writefile, CONFIG_FILE, encoded)
        end
    end

    local function loadConfig()
        if not (isfile and readfile and isfile(CONFIG_FILE)) then return end
        local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
        if not ok or type(data) ~= "table" then return end

        cfg.power         = tonumber(data.power) or DEFAULT_CFG.power
        cfg.interval      = tonumber(data.interval) or DEFAULT_CFG.interval
        cfg.keybindKb     = type(data.keybindKb) == "string" and data.keybindKb or DEFAULT_CFG.keybindKb
        cfg.keybindGp     = type(data.keybindGp) == "string" and data.keybindGp or DEFAULT_CFG.keybindGp
        cfg.autoBrainrot  = type(data.autoBrainrot) == "boolean" and data.autoBrainrot or DEFAULT_CFG.autoBrainrot
        cfg.mode          = type(data.mode) == "string" and MODES[data.mode] and data.mode or DEFAULT_CFG.mode

        local m = MODES[cfg.mode]
        if m then
            cfg.power    = m.power
            cfg.interval = m.interval
        end
    end

    loadConfig()

    local active            = false
    local listeningFor      = nil
    local remote            = nil
    local brainrotMode      = false
    local lastBrainrotState = false
    local manualOverride    = false

    -- ══════════════════════════════════════════════════════════════════════
    -- COLOURS (transparente, igual que el MVP)
    -- ══════════════════════════════════════════════════════════════════════
    local C = {
        bg      = Color3.fromRGB(5,   5,   5),
        panel   = Color3.fromRGB(9,   9,   9),
        card    = Color3.fromRGB(16, 16, 16),
        purple1 = Color3.fromRGB(35, 35, 35),
        purple2 = Color3.fromRGB(65, 65, 65),
        purple3 = Color3.fromRGB(225,225,225),
        glow    = Color3.fromRGB(85, 85, 85),
        white   = Color3.fromRGB(245,245,245),
        dim     = Color3.fromRGB(150,150,150),
        green   = Color3.fromRGB(100,255, 160),
        yellow  = Color3.fromRGB(255, 220, 60),
        red     = Color3.fromRGB(255,100, 120),
        waiting = Color3.fromRGB(255, 190,  50),
        inputBg = Color3.fromRGB(12, 12, 12),
        discord = Color3.fromRGB(120, 160, 255),
    }

    local T = {
        bg      = 0.72,
        panel   = 0.72,
        card    = 0.72,
        header  = 0.72,
        inputBg = 0.72,
    }

    local MODE_TEXT_COLORS = {
        LOW  = Color3.fromRGB(80, 230, 120),
        MED  = Color3.fromRGB(255, 210, 60),
        HIGH = Color3.fromRGB(255, 80, 100),
    }

    -- ══════════════════════════════════════════════════════════════════════
    -- DESTROY OLD GUI
    -- ══════════════════════════════════════════════════════════════════════
    for _, kid in pairs(plrGui:GetChildren()) do
        if kid.Name == "MVPPingLaggerGui" then kid:Destroy() end
    end

    local screen = Instance.new("ScreenGui")
    screen.Name         = "MVPPingLaggerGui"
    screen.ResetOnSpawn = false
    screen.DisplayOrder = 15
    screen.Parent       = plrGui

    -- ══════════════════════════════════════════════════════════════════════
    -- HELPERS
    -- ══════════════════════════════════════════════════════════════════════
    local function applyGradient(parent, c1, c2, rotation)
        local g = Instance.new("UIGradient", parent)
        g.Color    = ColorSequence.new({ ColorSequenceKeypoint.new(0,c1), ColorSequenceKeypoint.new(1,c2) })
        g.Rotation = rotation or 135
        return g
    end

    local function tw(obj, props, t)
        TweenService:Create(obj,
            TweenInfo.new(t or 0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
            props):Play()
    end

    local function makeDraggable(frame)
        local dragging, dragStart, startPos
        frame.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1
            or i.UserInputType == Enum.UserInputType.Touch then
                dragging  = true
                dragStart = i.Position
                startPos  = frame.Position
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        frame.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement
                          or i.UserInputType == Enum.UserInputType.Touch) then
                local d = i.Position - dragStart
                frame.Position = UDim2.new(
                    startPos.X.Scale, startPos.X.Offset + d.X,
                    startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)
    end

    local function isGamepad(kc)
        local n = kc.Name
        return n:sub(1,6)=="Button" or n:sub(1,10)=="Thumbstick"
            or n:sub(1,4)=="DPad" or n=="ButtonSelect" or n=="ButtonStart"
    end

    local BLACKLISTED = {
        [Enum.KeyCode.Escape]      = true,
        [Enum.KeyCode.LeftControl] = true,
        [Enum.KeyCode.Unknown]     = true,
    }

    -- ══════════════════════════════════════════════════════════════════════
    -- MAIN WINDOW
    -- ══════════════════════════════════════════════════════════════════════
    local MAIN_W, MAIN_H = 210, 130

    local mainFrame = Instance.new("Frame")
    mainFrame.Name             = "MainFrame"
    mainFrame.Size             = UDim2.new(0, MAIN_W, 0, MAIN_H)
    mainFrame.Position         = UDim2.new(0.5, -MAIN_W/2, 0.5, -MAIN_H/2)
    mainFrame.BackgroundColor3 = C.bg
    mainFrame.BackgroundTransparency = T.bg
    mainFrame.BorderSizePixel  = 0
    mainFrame.Active           = true
    mainFrame.ClipsDescendants = false
    mainFrame.Parent           = screen
    Instance.new("UICorner", mainFrame).CornerRadius = UDim.new(0, 12)
    applyGradient(mainFrame, C.bg, Color3.fromRGB(12,12,12), 160)

    local mainStroke = Instance.new("UIStroke", mainFrame)
    mainStroke.Color        = C.purple1
    mainStroke.Thickness    = 1.5
    mainStroke.Transparency = 0.35

    makeDraggable(mainFrame)

    -- Header
    local header = Instance.new("Frame", mainFrame)
    header.Size             = UDim2.new(1,0,0,32)
    header.BackgroundColor3 = C.purple1
    header.BackgroundTransparency = T.header
    header.BorderSizePixel  = 0
    header.ZIndex           = 2
    Instance.new("UICorner", header).CornerRadius = UDim.new(0,12)
    applyGradient(header, C.purple1, C.purple2, 135)

    local headerFill = Instance.new("Frame", mainFrame)
    headerFill.Size             = UDim2.new(1,0,0,8)
    headerFill.Position         = UDim2.new(0,0,0,24)
    headerFill.BackgroundColor3 = C.purple1
    headerFill.BackgroundTransparency = T.header
    headerFill.BorderSizePixel  = 0
    headerFill.ZIndex           = 2
    applyGradient(headerFill, C.purple1, C.purple2, 135)

    local titleLbl = Instance.new("TextLabel", header)
    titleLbl.Size               = UDim2.new(1,-70,1,0)
    titleLbl.Position           = UDim2.new(0,10,0,0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text               = "ZENITH PING LAGGER"
    titleLbl.TextColor3         = C.white
    titleLbl.Font               = Enum.Font.GothamBlack
    titleLbl.TextSize           = 9
    titleLbl.TextXAlignment     = Enum.TextXAlignment.Left
    titleLbl.ZIndex             = 3

    -- Status pill
    local statusPill = Instance.new("Frame", header)
    statusPill.Size             = UDim2.new(0,40,0,16)
    statusPill.Position         = UDim2.new(1,-82,0.5,-8)
    statusPill.BackgroundColor3 = Color3.fromRGB(24,24,24)
    statusPill.BackgroundTransparency = 0.15
    statusPill.BorderSizePixel  = 0
    statusPill.ZIndex           = 3
    Instance.new("UICorner", statusPill).CornerRadius = UDim.new(1,0)

    local statusLbl = Instance.new("TextLabel", statusPill)
    statusLbl.Size              = UDim2.new(1,0,1,0)
    statusLbl.BackgroundTransparency = 1
    statusLbl.Text              = "OFF"
    statusLbl.TextColor3        = C.red
    statusLbl.Font              = Enum.Font.GothamBlack
    statusLbl.TextSize          = 8
    statusLbl.ZIndex            = 4

    -- Settings emoji button
    local settingsEmojiBtn = Instance.new("TextButton", header)
    settingsEmojiBtn.Size             = UDim2.new(0,24,0,24)
    settingsEmojiBtn.Position         = UDim2.new(1,-28,0.5,-12)
    settingsEmojiBtn.BackgroundColor3 = Color3.fromRGB(24,24,24)
    settingsEmojiBtn.BackgroundTransparency = 0.15
    settingsEmojiBtn.BorderSizePixel  = 0
    settingsEmojiBtn.AutoButtonColor  = false
    settingsEmojiBtn.Text             = "⚙️"
    settingsEmojiBtn.TextColor3       = C.white
    settingsEmojiBtn.Font             = Enum.Font.GothamBlack
    settingsEmojiBtn.TextSize         = 14
    settingsEmojiBtn.ZIndex           = 23
    Instance.new("UICorner", settingsEmojiBtn).CornerRadius = UDim.new(0,6)
    settingsEmojiBtn.MouseEnter:Connect(function()
        tw(settingsEmojiBtn,{BackgroundColor3=C.purple1},0.1)
    end)
    settingsEmojiBtn.MouseLeave:Connect(function()
        tw(settingsEmojiBtn,{BackgroundColor3=Color3.fromRGB(24,24,24)},0.1)
    end)

    -- Activate button
    local activateBtn = Instance.new("TextButton", mainFrame)
    activateBtn.Size             = UDim2.new(1,-16,0,28)
    activateBtn.Position         = UDim2.new(0,8,0,38)
    activateBtn.BackgroundColor3 = C.card
    activateBtn.BackgroundTransparency = T.card
    activateBtn.BorderSizePixel  = 0
    activateBtn.AutoButtonColor  = false
    activateBtn.Text             = ""
    activateBtn.ZIndex           = 3
    Instance.new("UICorner", activateBtn).CornerRadius = UDim.new(0,8)
    local activateGrad = applyGradient(activateBtn, C.purple1, C.purple2, 135)

    local activateStroke = Instance.new("UIStroke", activateBtn)
    activateStroke.Color        = C.purple3
    activateStroke.Thickness    = 1.2
    activateStroke.Transparency = 0.4

    local activateLbl = Instance.new("TextLabel", activateBtn)
    activateLbl.Size            = UDim2.new(1,0,1,0)
    activateLbl.BackgroundTransparency = 1
    activateLbl.Text            = "ACTIVATE"
    activateLbl.TextColor3      = C.white
    activateLbl.Font            = Enum.Font.GothamBlack
    activateLbl.TextSize        = 11
    activateLbl.ZIndex          = 5

    -- ══════════════════════════════════════════════════════════════════════
    -- MODE (LOW / MED / HIGH)
    -- ══════════════════════════════════════════════════════════════════════
    local modeRow = Instance.new("Frame", mainFrame)
    modeRow.Size             = UDim2.new(1,-16,0,22)
    modeRow.Position         = UDim2.new(0,8,0,72)
    modeRow.BackgroundColor3 = C.card
    modeRow.BackgroundTransparency = T.card
    modeRow.BorderSizePixel  = 0
    modeRow.ZIndex           = 3
    Instance.new("UICorner", modeRow).CornerRadius = UDim.new(0,7)
    local modeRowStroke = Instance.new("UIStroke", modeRow)
    modeRowStroke.Color = C.glow
    modeRowStroke.Thickness = 1
    modeRowStroke.Transparency = 0.5

    local modeButtons = {}
    local modeList = {"LOW", "MED", "HIGH"}
    local modeBtnW = (MAIN_W - 16 - 8) / 3

    local function refreshModeButtons()
        for name, btn in pairs(modeButtons) do
            if cfg.mode == name then
                btn.TextColor3 = MODE_TEXT_COLORS[name]
            else
                btn.TextColor3 = C.dim
            end
        end
    end

    for i, name in ipairs(modeList) do
        local btn = Instance.new("TextButton", modeRow)
        btn.Size             = UDim2.new(0, modeBtnW - 4, 0, 18)
        btn.Position         = UDim2.new(0, 4 + (i-1) * (modeBtnW - 4) + (i-1) * 2, 0.5, -9)
        btn.BackgroundColor3 = Color3.fromRGB(20,20,20)
        btn.BackgroundTransparency = 0.4
        btn.BorderSizePixel  = 0
        btn.AutoButtonColor  = false
        btn.Text             = name
        btn.TextColor3       = C.dim
        btn.Font             = Enum.Font.GothamBold
        btn.TextSize         = 9
        btn.ZIndex           = 4
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0,5)

        btn.MouseButton1Click:Connect(function()
            cfg.mode = name
            local m = MODES[name]
            if m then
                cfg.power    = m.power
                cfg.interval = m.interval
            end
            refreshModeButtons()
            saveConfig()
        end)

        modeButtons[name] = btn
    end

    refreshModeButtons()

    -- ══════════════════════════════════════════════════════════════════════
    -- DISCORD LINK
    -- ══════════════════════════════════════════════════════════════════════
    local discordLbl = Instance.new("TextLabel", mainFrame)
    discordLbl.Size             = UDim2.new(1,-16,0,18)
    discordLbl.Position         = UDim2.new(0,8,0,100)
    discordLbl.BackgroundTransparency = 1
    discordLbl.Text             = "ZENITH HUB ON TOP"
    discordLbl.TextColor3       = C.discord
    discordLbl.Font             = Enum.Font.GothamBold
    discordLbl.TextSize         = 9
    discordLbl.ZIndex           = 3

    -- ══════════════════════════════════════════════════════════════════════
    -- SETTINGS PANEL
    -- ══════════════════════════════════════════════════════════════════════
    local SET_W, SET_H = 220, 340

    local settingsFrame = Instance.new("Frame")
    settingsFrame.Name             = "SettingsPanel"
    settingsFrame.Size             = UDim2.new(0,SET_W,0,SET_H)
    settingsFrame.Position         = UDim2.new(0.5,-SET_W/2,0.5,60)
    settingsFrame.BackgroundColor3 = C.panel
    settingsFrame.BackgroundTransparency = T.panel
    settingsFrame.BorderSizePixel  = 0
    settingsFrame.Active           = true
    settingsFrame.ClipsDescendants = true
    settingsFrame.Visible          = false
    settingsFrame.ZIndex           = 20
    settingsFrame.Parent           = screen
    Instance.new("UICorner", settingsFrame).CornerRadius = UDim.new(0,12)
    applyGradient(settingsFrame, C.panel, Color3.fromRGB(10,10,10), 160)

    local setStroke = Instance.new("UIStroke", settingsFrame)
    setStroke.Color        = C.glow
    setStroke.Thickness    = 1.4
    setStroke.Transparency = 0.3

    makeDraggable(settingsFrame)

    local setHeader = Instance.new("Frame", settingsFrame)
    setHeader.Size             = UDim2.new(1,0,0,32)
    setHeader.BackgroundColor3 = C.glow
    setHeader.BackgroundTransparency = T.header
    setHeader.BorderSizePixel  = 0
    setHeader.ZIndex           = 21
    Instance.new("UICorner", setHeader).CornerRadius = UDim.new(0,12)
    applyGradient(setHeader, C.glow, C.purple1, 135)

    local setHeaderFill = Instance.new("Frame", settingsFrame)
    setHeaderFill.Size             = UDim2.new(1,0,0,8)
    setHeaderFill.Position         = UDim2.new(0,0,0,24)
    setHeaderFill.BackgroundColor3 = C.glow
    setHeaderFill.BackgroundTransparency = T.header
    setHeaderFill.BorderSizePixel  = 0
    setHeaderFill.ZIndex           = 21
    applyGradient(setHeaderFill, C.glow, C.purple1, 135)

    local setTitle = Instance.new("TextLabel", setHeader)
    setTitle.Size               = UDim2.new(1,-80,1,0)
    setTitle.Position           = UDim2.new(0,10,0,0)
    setTitle.BackgroundTransparency = 1
    setTitle.Text               = "Settings"
    setTitle.TextColor3         = C.white
    setTitle.Font               = Enum.Font.GothamBlack
    setTitle.TextSize           = 11
    setTitle.TextXAlignment     = Enum.TextXAlignment.Left
    setTitle.ZIndex             = 22

    local setCloseBtn = Instance.new("TextButton", setHeader)
    setCloseBtn.Size             = UDim2.new(0,24,0,24)
    setCloseBtn.Position         = UDim2.new(1,-28,0.5,-12)
    setCloseBtn.BackgroundColor3 = Color3.fromRGB(24,24,24)
    setCloseBtn.BackgroundTransparency = 0.15
    setCloseBtn.BorderSizePixel  = 0
    setCloseBtn.AutoButtonColor  = false
    setCloseBtn.Text             = "X"
    setCloseBtn.TextColor3       = C.white
    setCloseBtn.Font             = Enum.Font.GothamBlack
    setCloseBtn.TextSize         = 11
    setCloseBtn.ZIndex           = 23
    Instance.new("UICorner", setCloseBtn).CornerRadius = UDim.new(0,6)
    setCloseBtn.MouseEnter:Connect(function() tw(setCloseBtn,{BackgroundColor3=C.red},0.1) end)
    setCloseBtn.MouseLeave:Connect(function() tw(setCloseBtn,{BackgroundColor3=Color3.fromRGB(24,24,24)},0.1) end)

    local function mkInputRow(yPos, labelText, getValue, onConfirm)
        local row = Instance.new("Frame", settingsFrame)
        row.Size             = UDim2.new(1,-16,0,34)
        row.Position         = UDim2.new(0,8,0,yPos)
        row.BackgroundColor3 = C.card
        row.BackgroundTransparency = T.card
        row.BorderSizePixel  = 0
        row.ZIndex           = 21
        Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)
        local rs = Instance.new("UIStroke",row); rs.Color=C.glow; rs.Thickness=1; rs.Transparency=0.6

        local lbl = Instance.new("TextLabel", row)
        lbl.Size               = UDim2.new(0.45,0,1,0)
        lbl.Position           = UDim2.new(0,10,0,0)
        lbl.BackgroundTransparency = 1
        lbl.Text               = labelText
        lbl.TextColor3         = C.white
        lbl.Font               = Enum.Font.GothamBold
        lbl.TextSize           = 10
        lbl.TextXAlignment     = Enum.TextXAlignment.Left
        lbl.ZIndex             = 22

        local box = Instance.new("TextBox", row)
        box.Size               = UDim2.new(0,64,0,24)
        box.Position           = UDim2.new(1,-72,0.5,-12)
        box.BackgroundColor3   = C.inputBg
        box.BackgroundTransparency = T.inputBg
        box.BorderSizePixel    = 0
        box.Text               = tostring(getValue())
        box.TextColor3         = C.purple3
        box.Font               = Enum.Font.GothamBold
        box.TextSize           = 11
        box.ClearTextOnFocus   = false
        box.ZIndex             = 23
        Instance.new("UICorner", box).CornerRadius = UDim.new(0,6)

        local bs = Instance.new("UIStroke",box); bs.Color=C.glow; bs.Thickness=1; bs.Transparency=0.5

        box.Focused:Connect(function()   tw(bs,{Color=C.purple2,Transparency=0},0.12) end)
        box.FocusLost:Connect(function()
            tw(bs,{Color=C.glow,Transparency=0.5},0.12)
            local n = tonumber(box.Text)
            if n then
                onConfirm(n)
                box.Text = tostring(getValue())
                saveConfig()
            else
                box.Text = tostring(getValue())
            end
        end)

        return box
    end

    local kbBindBtn, gpBindBtn

    local function updateKbLabels()
        if kbBindBtn then
            if listeningFor == "kb" then
                kbBindBtn.Text       = "Press a key..."
                kbBindBtn.TextColor3 = C.waiting
            else
                kbBindBtn.Text       = cfg.keybindKb ~= "" and cfg.keybindKb or "None"
                kbBindBtn.TextColor3 = C.purple3
            end
        end
        if gpBindBtn then
            if listeningFor == "gp" then
                gpBindBtn.Text       = "Press a button..."
                gpBindBtn.TextColor3 = C.waiting
            else
                gpBindBtn.Text       = cfg.keybindGp ~= "" and cfg.keybindGp or "None"
                gpBindBtn.TextColor3 = C.purple3
            end
        end
    end

    local function mkKeybindRow(yPos, labelText, which)
        local row = Instance.new("Frame", settingsFrame)
        row.Size             = UDim2.new(1,-16,0,34)
        row.Position         = UDim2.new(0,8,0,yPos)
        row.BackgroundColor3 = C.card
        row.BackgroundTransparency = T.card
        row.BorderSizePixel  = 0
        row.ZIndex           = 21
        Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)
        local rs = Instance.new("UIStroke",row); rs.Color=C.glow; rs.Thickness=1; rs.Transparency=0.6

        local lbl = Instance.new("TextLabel", row)
        lbl.Size               = UDim2.new(0.4,0,1,0)
        lbl.Position           = UDim2.new(0,10,0,0)
        lbl.BackgroundTransparency = 1
        lbl.Text               = labelText
        lbl.TextColor3         = C.white
        lbl.Font               = Enum.Font.GothamBold
        lbl.TextSize           = 10
        lbl.TextXAlignment     = Enum.TextXAlignment.Left
        lbl.ZIndex             = 22

        local bindBtn = Instance.new("TextButton", row)
        bindBtn.Size             = UDim2.new(0,72,0,24)
        bindBtn.Position         = UDim2.new(1,-88,0.5,-12)
        bindBtn.BackgroundColor3 = C.inputBg
        bindBtn.BackgroundTransparency = T.inputBg
        bindBtn.BorderSizePixel  = 0
        bindBtn.AutoButtonColor  = false
        bindBtn.Font             = Enum.Font.GothamBold
        bindBtn.TextSize         = 9
        bindBtn.TextColor3       = C.purple3
        bindBtn.ZIndex           = 23
        bindBtn.Text             = which == "kb" and cfg.keybindKb or cfg.keybindGp
        Instance.new("UICorner", bindBtn).CornerRadius = UDim.new(0,6)

        local bStr = Instance.new("UIStroke",bindBtn); bStr.Color=C.glow; bStr.Thickness=1; bStr.Transparency=0.5
        bindBtn.MouseEnter:Connect(function() tw(bStr,{Color=C.purple2,Transparency=0},0.1) end)
        bindBtn.MouseLeave:Connect(function() tw(bStr,{Color=C.glow,Transparency=0.5},0.1) end)

        bindBtn.MouseButton1Click:Connect(function()
            listeningFor = (listeningFor == which) and nil or which
            updateKbLabels()
        end)

        local clearBtn = Instance.new("TextButton", row)
        clearBtn.Size             = UDim2.new(0,24,0,24)
        clearBtn.Position         = UDim2.new(1,-28,0.5,-12)
        clearBtn.BackgroundColor3 = Color3.fromRGB(30,15,15)
        clearBtn.BackgroundTransparency = T.inputBg
        clearBtn.BorderSizePixel  = 0
        clearBtn.AutoButtonColor  = false
        clearBtn.Text             = "X"
        clearBtn.TextColor3       = C.red
        clearBtn.Font             = Enum.Font.GothamBlack
        clearBtn.TextSize         = 10
        clearBtn.ZIndex           = 23
        Instance.new("UICorner", clearBtn).CornerRadius = UDim.new(0,6)
        local cStr = Instance.new("UIStroke",clearBtn); cStr.Color=C.red; cStr.Thickness=1; cStr.Transparency=0.5
        clearBtn.MouseEnter:Connect(function() tw(cStr,{Transparency=0},0.1) end)
        clearBtn.MouseLeave:Connect(function() tw(cStr,{Transparency=0.5},0.1) end)

        clearBtn.MouseButton1Click:Connect(function()
            if listeningFor == which then listeningFor = nil end
            if which == "kb" then cfg.keybindKb = "None" else cfg.keybindGp = "None" end
            updateKbLabels()
            saveConfig()
        end)

        if which == "kb" then kbBindBtn = bindBtn end
        if which == "gp" then gpBindBtn = bindBtn end

        return bindBtn
    end

    local autoBrainrotBtn

    local function createBrainrotRow(yPos)
        local row = Instance.new("Frame", settingsFrame)
        row.Size             = UDim2.new(1,-16,0,34)
        row.Position         = UDim2.new(0,8,0,yPos)
        row.BackgroundColor3 = C.card
        row.BackgroundTransparency = T.card
        row.BorderSizePixel  = 0
        row.ZIndex           = 21
        Instance.new("UICorner", row).CornerRadius = UDim.new(0,8)
        local rs = Instance.new("UIStroke",row); rs.Color=C.glow; rs.Thickness=1; rs.Transparency=0.6

        local lbl = Instance.new("TextLabel", row)
        lbl.Size               = UDim2.new(0.7,0,1,0)
        lbl.Position           = UDim2.new(0,10,0,0)
        lbl.BackgroundTransparency = 1
        lbl.Text               = "Auto Brainrot"
        lbl.TextColor3         = C.white
        lbl.Font               = Enum.Font.GothamBold
        lbl.TextSize           = 10
        lbl.TextXAlignment     = Enum.TextXAlignment.Left
        lbl.ZIndex             = 22

        local toggleBtn = Instance.new("TextButton", row)
        toggleBtn.Size             = UDim2.new(0,50,0,24)
        toggleBtn.Position         = UDim2.new(1,-58,0.5,-12)
        toggleBtn.BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(60,20,20)
        toggleBtn.BorderSizePixel  = 0
        toggleBtn.AutoButtonColor  = false
        toggleBtn.Text             = cfg.autoBrainrot and "ON" or "OFF"
        toggleBtn.TextColor3       = C.white
        toggleBtn.Font             = Enum.Font.GothamBlack
        toggleBtn.TextSize         = 9
        toggleBtn.ZIndex           = 23
        Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)

        local tStr = Instance.new("UIStroke", toggleBtn)
        tStr.Color = C.glow; tStr.Thickness = 1; tStr.Transparency = 0.5

        toggleBtn.MouseButton1Click:Connect(function()
            cfg.autoBrainrot = not cfg.autoBrainrot
            toggleBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
            tw(toggleBtn, {BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(60,20,20)}, 0.15)
            saveConfig()
        end)

        autoBrainrotBtn = toggleBtn
        return toggleBtn
    end

    local Y = 36
    local GAP = 6

    local powerBox = mkInputRow(Y, "Power", function() return cfg.power end, function(v)
        cfg.power = math.max(1, v)
    end)
    Y = Y + 34 + GAP

    local intervalBox = mkInputRow(Y, "Delay (secs)", function() return cfg.interval end, function(v)
        cfg.interval = math.max(0.001, v)
    end)
    Y = Y + 34 + GAP

    createBrainrotRow(Y)
    Y = Y + 34 + GAP

    local div = Instance.new("Frame", settingsFrame)
    div.Size             = UDim2.new(1,-16,0,1)
    div.Position         = UDim2.new(0,8,0,Y)
    div.BackgroundColor3 = C.glow
    div.BorderSizePixel  = 0
    div.BackgroundTransparency = 0.5
    div.ZIndex           = 21
    Y = Y + 8

    local kbSectLbl = Instance.new("TextLabel", settingsFrame)
    kbSectLbl.Size               = UDim2.new(1,-16,0,16)
    kbSectLbl.Position           = UDim2.new(0,8,0,Y)
    kbSectLbl.BackgroundTransparency = 1
    kbSectLbl.Text               = "KEYBINDS"
    kbSectLbl.TextColor3         = C.dim
    kbSectLbl.Font               = Enum.Font.GothamBold
    kbSectLbl.TextSize           = 8
    kbSectLbl.TextXAlignment     = Enum.TextXAlignment.Left
    kbSectLbl.ZIndex             = 21
    Y = Y + 16

    mkKeybindRow(Y, "Keyboard",   "kb"); Y = Y + 34 + GAP
    mkKeybindRow(Y, "Controller", "gp"); Y = Y + 34 + GAP

    local resetBtn = Instance.new("TextButton", settingsFrame)
    resetBtn.Size             = UDim2.new(1,-16,0,26)
    resetBtn.Position         = UDim2.new(0,8,0,Y)
    resetBtn.BackgroundColor3 = C.glow
    resetBtn.BorderSizePixel  = 0
    resetBtn.AutoButtonColor  = false
    resetBtn.Text             = "Reset Defaults"
    resetBtn.TextColor3       = C.white
    resetBtn.Font             = Enum.Font.GothamBold
    resetBtn.TextSize         = 10
    resetBtn.ZIndex           = 21
    Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0,7)
    applyGradient(resetBtn, C.glow, C.purple1, 135)
    resetBtn.MouseEnter:Connect(function() tw(resetBtn,{BackgroundColor3=C.purple1},0.1) end)
    resetBtn.MouseLeave:Connect(function() tw(resetBtn,{BackgroundColor3=C.glow},0.1) end)

    -- ══════════════════════════════════════════════════════════════════════
    -- RESET CONFIRM DIALOG
    -- ══════════════════════════════════════════════════════════════════════
    local confirmBackdrop = Instance.new("Frame")
    confirmBackdrop.Name                   = "ConfirmBackdrop"
    confirmBackdrop.Size                   = UDim2.new(1,0,1,0)
    confirmBackdrop.BackgroundColor3       = Color3.fromRGB(0,0,0)
    confirmBackdrop.BackgroundTransparency = 0.45
    confirmBackdrop.BorderSizePixel        = 0
    confirmBackdrop.Visible                = false
    confirmBackdrop.ZIndex                 = 50
    confirmBackdrop.Parent                 = screen

    local confirmBox = Instance.new("Frame", confirmBackdrop)
    confirmBox.Size             = UDim2.new(0,210,0,120)
    confirmBox.Position         = UDim2.new(0.5,-105,0.5,-60)
    confirmBox.BackgroundColor3 = C.panel
    confirmBox.BackgroundTransparency = T.panel
    confirmBox.BorderSizePixel  = 0
    confirmBox.ZIndex           = 51
    Instance.new("UICorner", confirmBox).CornerRadius = UDim.new(0,10)
    applyGradient(confirmBox, C.panel, Color3.fromRGB(10,10,10), 160)

    local cStroke = Instance.new("UIStroke", confirmBox)
    cStroke.Color = C.purple1; cStroke.Thickness = 1.3; cStroke.Transparency = 0.3

    local confirmLbl = Instance.new("TextLabel", confirmBox)
    confirmLbl.Size               = UDim2.new(1,-16,0,58)
    confirmLbl.Position           = UDim2.new(0,8,0,8)
    confirmLbl.BackgroundTransparency = 1
    confirmLbl.Text               = "Reset all settings to defaults?"
    confirmLbl.TextWrapped        = true
    confirmLbl.TextColor3         = C.white
    confirmLbl.Font               = Enum.Font.GothamBold
    confirmLbl.TextSize           = 11
    confirmLbl.ZIndex             = 52

    local confirmYes = Instance.new("TextButton", confirmBox)
    confirmYes.Size             = UDim2.new(0,92,0,30)
    confirmYes.Position         = UDim2.new(0,8,1,-38)
    confirmYes.BackgroundColor3 = C.glow
    confirmYes.BorderSizePixel  = 0
    confirmYes.AutoButtonColor  = false
    confirmYes.Text             = "Confirm"
    confirmYes.TextColor3       = C.white
    confirmYes.Font             = Enum.Font.GothamBlack
    confirmYes.TextSize         = 11
    confirmYes.ZIndex           = 52
    Instance.new("UICorner", confirmYes).CornerRadius = UDim.new(0,7)
    applyGradient(confirmYes, C.glow, C.purple1, 135)

    local confirmNo = Instance.new("TextButton", confirmBox)
    confirmNo.Size             = UDim2.new(0,92,0,30)
    confirmNo.Position         = UDim2.new(1,-100,1,-38)
    confirmNo.BackgroundColor3 = C.card
    confirmNo.BorderSizePixel  = 0
    confirmNo.AutoButtonColor  = false
    confirmNo.Text             = "Cancel"
    confirmNo.TextColor3       = C.dim
    confirmNo.Font             = Enum.Font.GothamBold
    confirmNo.TextSize         = 11
    confirmNo.ZIndex           = 52
    Instance.new("UICorner", confirmNo).CornerRadius = UDim.new(0,7)

    confirmYes.MouseEnter:Connect(function() tw(confirmYes,{BackgroundColor3=C.purple1},0.1) end)
    confirmYes.MouseLeave:Connect(function() tw(confirmYes,{BackgroundColor3=C.glow},0.1) end)
    confirmNo.MouseEnter:Connect(function()  tw(confirmNo,{TextColor3=C.white},0.1) end)
    confirmNo.MouseLeave:Connect(function()  tw(confirmNo,{TextColor3=C.dim},0.1) end)

    local function hideConfirm() confirmBackdrop.Visible = false end

    confirmNo.MouseButton1Click:Connect(hideConfirm)

    confirmYes.MouseButton1Click:Connect(function()
        cfg.power        = DEFAULT_CFG.power
        cfg.interval     = DEFAULT_CFG.interval
        cfg.keybindKb    = DEFAULT_CFG.keybindKb
        cfg.keybindGp    = DEFAULT_CFG.keybindGp
        cfg.autoBrainrot = DEFAULT_CFG.autoBrainrot
        cfg.mode         = DEFAULT_CFG.mode

        local m = MODES[cfg.mode]
        if m then
            cfg.power    = m.power
            cfg.interval = m.interval
        end

        powerBox.Text    = tostring(cfg.power)
        intervalBox.Text = tostring(cfg.interval)
        updateKbLabels()

        if autoBrainrotBtn then
            autoBrainrotBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
            tw(autoBrainrotBtn, {BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(60,20,20)}, 0.15)
        end

        refreshModeButtons()
        saveConfig()
        hideConfirm()
    end)

    resetBtn.MouseButton1Click:Connect(function()
        confirmLbl.Text = "Reset all settings to defaults?"
        confirmBackdrop.Visible = true
    end)

    -- ══════════════════════════════════════════════════════════════════════
    -- SETTINGS OPEN / CLOSE
    -- ══════════════════════════════════════════════════════════════════════
    local settingsOpen = false

    local function openSettings()
        settingsOpen          = true
        settingsFrame.Visible = true
        settingsFrame.Size    = UDim2.new(0,SET_W,0,0)
        tw(settingsFrame, {Size=UDim2.new(0,SET_W,0,SET_H)}, 0.2)
        tw(settingsEmojiBtn, {BackgroundColor3=C.purple1}, 0.12)
        powerBox.Text    = tostring(cfg.power)
        intervalBox.Text = tostring(cfg.interval)
        updateKbLabels()
        if autoBrainrotBtn then
            autoBrainrotBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
            autoBrainrotBtn.BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(60,20,20)
        end
    end

    local function closeSettings()
        settingsOpen = false
        listeningFor = nil
        updateKbLabels()
        tw(settingsFrame, {Size=UDim2.new(0,SET_W,0,0)}, 0.16)
        task.delay(0.18, function() settingsFrame.Visible = false end)
        tw(settingsEmojiBtn, {BackgroundColor3=Color3.fromRGB(24,24,24)}, 0.12)
        hideConfirm()
    end

    settingsEmojiBtn.MouseButton1Click:Connect(function()
        if settingsOpen then closeSettings() else openSettings() end
    end)
    setCloseBtn.MouseButton1Click:Connect(closeSettings)

    -- ══════════════════════════════════════════════════════════════════════
    -- PING LAGGER LOGIC
    -- ══════════════════════════════════════════════════════════════════════
    local function findRemote()
        local rrs = game:FindFirstChild("RobloxReplicatedStorage")
        if not rrs then return nil end
        local remote
        for _, name in ipairs({"SetPlayerBlockList","UpdatePlayerBlockList","SetBlockList","UpdateBlockList"}) do
            local r = rrs:FindFirstChild(name)
            if r and r:IsA("RemoteEvent") then remote = r break end
        end
        if not remote then
            for _, c in ipairs(rrs:GetChildren()) do
                if c:IsA("RemoteEvent") and c.Name:find("Block") then remote = c break end
            end
        end
        return remote
    end

    remote = findRemote()

    local function buildPayload(power)
        local main = {}
        local nested = {{}}
        local current = nested[1]
        for _ = 1, 186 do
            local n = {}
            table.insert(current, n)
            current = n
        end
        local maxRep = math.min(math.floor(power / 188), 10000)
        for _ = 1, maxRep do
            table.insert(main, nested)
        end
        return main
    end

    local function runPingLoop()
        local delay = cfg.interval
        while active and remote do
            local payload = buildPayload(cfg.power)
            local ok = pcall(function() remote:FireServer(payload) end)
            if not ok then
                delay = math.min(delay * 1.5, 0.5)
            else
                delay = math.max(delay * 0.995, 0.05)
            end
            task.wait(delay)
        end
    end

    local function flipLag(state, isManual)
        active = state

        if isManual then
            if brainrotMode then
                manualOverride = not state
            else
                manualOverride = false
            end
        end

        if active then
            if not remote then
                remote = findRemote()
                if not remote then
                    active = false
                    flipLag(false)
                    return
                end
            end
            activateGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0,C.purple2),
                ColorSequenceKeypoint.new(1,C.purple3),
            })
            activateLbl.Text            = "ACTIVATED"
            activateStroke.Color        = C.white
            activateStroke.Transparency = 0
            statusLbl.Text              = "ON"
            statusLbl.TextColor3        = C.green
            tw(statusPill, {BackgroundColor3=Color3.fromRGB(10,40,20)}, 0.2)
            mainStroke.Color            = C.green
            mainStroke.Transparency     = 0.1
            task.spawn(runPingLoop)
        else
            activateGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0,C.purple1),
                ColorSequenceKeypoint.new(1,C.purple2),
            })
            activateLbl.Text            = "ACTIVATE"
            activateStroke.Color        = C.purple3
            activateStroke.Transparency = 0.4
            statusLbl.Text              = "OFF"
            statusLbl.TextColor3        = C.red
            tw(statusPill, {BackgroundColor3=Color3.fromRGB(24,24,24)}, 0.2)
            mainStroke.Color            = C.purple1
            mainStroke.Transparency     = 0.35
        end
    end

    activateBtn.MouseButton1Click:Connect(function()
        flipLag(not active, true)
    end)
    activateBtn.MouseEnter:Connect(function()
        if not active then tw(activateBtn,{BackgroundColor3=Color3.fromRGB(55,55,55)},0.1) end
    end)
    activateBtn.MouseLeave:Connect(function()
        if not active then tw(activateBtn,{BackgroundColor3=C.card},0.1) end
    end)

    -- ══════════════════════════════════════════════════════════════════════
    -- AUTO BRAINROT DETECTION
    -- ══════════════════════════════════════════════════════════════════════
    RunService.Heartbeat:Connect(function()
        if not cfg.autoBrainrot then
            if brainrotMode then
                brainrotMode = false
                lastBrainrotState = false
            end
            return
        end

        local char = plr.Character
        if not char then return end
        local hum = char:FindFirstChild("Humanoid")
        if not hum then return end

        local hasBrainrot = hum.WalkSpeed < 25

        if hasBrainrot and not lastBrainrotState then
            brainrotMode = true
            lastBrainrotState = true
            manualOverride = false
            flipLag(true)
        elseif not hasBrainrot and lastBrainrotState then
            brainrotMode = false
            lastBrainrotState = false
            manualOverride = false
            flipLag(false)
        end
    end)

    -- ══════════════════════════════════════════════════════════════════════
    -- INPUT HANDLER
    -- ══════════════════════════════════════════════════════════════════════
    UserInputService.InputBegan:Connect(function(input, processed)
        local kc  = input.KeyCode
        if kc == Enum.KeyCode.Unknown then return end

        local isGp = isGamepad(kc)
        local isKb = input.UserInputType == Enum.UserInputType.Keyboard

        if listeningFor then
            if kc == Enum.KeyCode.Escape then
                listeningFor = nil
                updateKbLabels()
                return
            end
            if listeningFor == "kb" and isKb and not BLACKLISTED[kc] then
                cfg.keybindKb = kc.Name
                listeningFor  = nil
                updateKbLabels()
                saveConfig()
                return
            end
            if listeningFor == "gp" and isGp then
                cfg.keybindGp = kc.Name
                listeningFor  = nil
                updateKbLabels()
                saveConfig()
                return
            end
            return
        end

        if processed then return end

        if kc == Enum.KeyCode.LeftControl then
            mainFrame.Visible = not mainFrame.Visible
            if not mainFrame.Visible then closeSettings() end
            return
        end

        local kbEnum = resolveKb(cfg.keybindKb)
        local gpEnum = resolveKb(cfg.keybindGp)

        if (kbEnum and kc == kbEnum and isKb)
        or (gpEnum and kc == gpEnum and isGp) then
            flipLag(not active, true)
        end
    end)

    -- Hook para que el MVP pueda refrescar el fondo si lo necesita
    _G.__MVPPingLaggerRefreshBackground = function()
        if mainFrame and mainFrame.Parent then
            mainFrame.BackgroundTransparency = T.bg
        end
    end

    updateKbLabels()
    _MVPPingLaggerScreen = screen
    return screen
end

function buildGui()
    local ROW_BG = Color3.fromRGB(48, 32, 70)
    local ROW_BORDER = Color3.fromRGB(174, 137, 220)
    local WHITE = Color3.fromRGB(240, 241, 245)
    local INP = Color3.fromRGB(70, 50, 94)
    local ACCENT = Color3.fromRGB(150, 80, 255)
    local ACCENT_ALT = Color3.fromRGB(186, 140, 255)
    local GUI_W, GUI_H = 360, 520

    for _, parent in ipairs({CoreGui, pgui}) do
        for _, name in ipairs({"ZenithHub", "ZenithHubMobilePanel", "ZenithHubSpeedIndicator", "ZenithHubBootErrors"}) do
            pcall(function() local old = parent:FindFirstChild(name); if old then old:Destroy() end end)
        end
    end

    gui = MVPUI.new("ScreenGui", nil, {
        Name = "ZenithHub",
        ResetOnSpawn = false,
        IgnoreGuiInset = true,
        DisplayOrder = 30,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    local ok = pcall(function() gui.Parent = CoreGui end)
    if not ok then gui.Parent = pgui end

    -- Painel Principal Compacto com Fundo e Fotos Bem Visíveis
    main = MVPUI.new("Frame", gui, {
        Name = "Main",
        Size = UDim2.fromOffset(GUI_W, GUI_H),
        Position = UDim2.fromOffset(80, 20),
        BackgroundColor3 = Color3.fromRGB(20, 10, 40),
        BackgroundTransparency = 0.12,
        BorderSizePixel = 0,
        ClipsDescendants = false,
        Active = true
    })
    MVPUI.round(main, 20)
    local border = MVPUI.stroke(main, ACCENT, 0.28, 1.2)
    border.Name = "MainBorder"
    local mainGlow = MVPUI.stroke(main, ACCENT, 0.9, 4)
    mainGlow.Name = "SoftGlow"
    mainUIScale = MVPUI.new("UIScale", main, {Scale = uiScaleValue / 100})
    local sheen = MVPUI.new("Frame", main, {Name = "WindowSheen", Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, ZIndex = 2})
    MVPUI.round(sheen, 20)
    MVPUI.new("UIGradient", sheen, {Rotation = 45, Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.94), NumberSequenceKeypoint.new(0.45, 1), NumberSequenceKeypoint.new(1, 0.97)})})

    -- Foto de Fundo Clara e Nítida
    local bg = MVPUI.new("ImageLabel", main, {
        Name = "BackgroundImage",
        Size = UDim2.fromScale(1, 1),
        Image = "rbxassetid://" .. backgroundImages[backgroundIndex],
        ImageTransparency = 0.15,
        BackgroundTransparency = 1,
        ScaleType = Enum.ScaleType.Crop,
        ZIndex = 0
    })
    MVPUI.round(bg, 20)

    -- Véu suave sem escurecer demais a imagem
    local veil = MVPUI.new("Frame", main, {
        Name = "BackgroundVeil",
        Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(24, 12, 46),
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        ZIndex = 1
    })
    MVPUI.round(veil, 20)
    MVPUI.new("UIGradient", veil, {Rotation = 90, Color = ColorSequence.new(Color3.fromRGB(0, 0, 0), Color3.fromRGB(0, 0, 0)),
        Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.32), NumberSequenceKeypoint.new(0.20, 0.46), NumberSequenceKeypoint.new(1, 0.62)})})

    -- Ambient line neon no topo
    local topLight = MVPUI.new("Frame", main, {
        Name = "TopLight",
        Position = UDim2.fromOffset(16, 0),
        Size = UDim2.new(1, -32, 0, 2),
        BackgroundColor3 = ACCENT,
        BorderSizePixel = 0,
        ZIndex = 4
    })
    MVPUI.new("UIGradient", topLight, {
        Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 1),
            NumberSequenceKeypoint.new(0.5, 0),
            NumberSequenceKeypoint.new(1, 1)
        })
    })

    -- ============================================================
    -- HEADER PRINCIPAL
    -- ============================================================
    local header = MVPUI.new("Frame", main, {
        Name = "ScriptHeader",
        Position = UDim2.fromOffset(10, 8),
        Size = UDim2.new(1, -20, 0, 36),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0),
        BackgroundTransparency = 0.42,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 5
    })
    MVPUI.round(header, 8)
    MVPUI.stroke(header, Color3.fromRGB(88, 28, 176), 0.5, 1)
    MVPUI.new("UIGradient", header, {Rotation = 0, Color = ColorSequence.new(Color3.fromRGB(30, 10, 58), Color3.fromRGB(22, 11, 44))})

    scriptLogoRef = MVPUI.text(header, "ZENITH", UDim2.fromOffset(10, 4), UDim2.fromOffset(80, 16), 15, WHITE, 6)
    scriptLogoRef.Font = Enum.Font.GothamBlack
    MVPUI.titleGradient = MVPUI.new("UIGradient", scriptLogoRef, {
        Rotation = 45,
        Color = ColorSequence.new(ACCENT, ACCENT_ALT)
    })

    local subLogo = MVPUI.text(header, "NIGHT EDITION", UDim2.fromOffset(10, 20), UDim2.fromOffset(80, 12), 8, Color3.fromRGB(172, 152, 205), 6)
    subLogo.Font = Enum.Font.GothamBold

    MVPUI.footerStats = MVPUI.text(header, "ONLINE", UDim2.new(1, -142, 0, 10), UDim2.fromOffset(70, 16), 9, ACCENT, 6)
    MVPUI.footerStats.TextXAlignment = Enum.TextXAlignment.Right
    MVPUI.footerStats.Font = Enum.Font.GothamBold

    -- Lua crescente (assinatura Night Hub) + linha do header
    local hMoon = MVPUI.new("Frame", header, {Size = UDim2.fromOffset(16, 16), Position = UDim2.fromOffset(96, 10),
        BackgroundColor3 = ACCENT, BorderSizePixel = 0, ZIndex = 6})
    MVPUI.round(hMoon, 8)
    local hMoonCut = MVPUI.new("Frame", header, {Size = UDim2.fromOffset(16, 16), Position = UDim2.fromOffset(101, 10),
        BackgroundColor3 = Color3.fromRGB(15, 6, 30), BorderSizePixel = 0, ZIndex = 7})
    MVPUI.round(hMoonCut, 8)
    local headerLine = MVPUI.new("Frame", header, {Size = UDim2.new(1, 0, 0, 1), Position = UDim2.new(0, 0, 1, -1),
        BackgroundColor3 = ACCENT, BorderSizePixel = 0, ZIndex = 8})
    MVPUI.new("UIGradient", headerLine, {Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(186, 140, 255)),
        ColorSequenceKeypoint.new(0.65, Color3.fromRGB(105, 40, 190)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))}),
        Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.7, 0.4), NumberSequenceKeypoint.new(1, 1)})})

    -- Botão Minimizar
    local minimizeBtn = MVPUI.new("TextButton", header, {
        Name = "ZenithMinimize",
        AnchorPoint = Vector2.new(1, 0),
        Size = UDim2.fromOffset(26, 26),
        Position = UDim2.new(1, -38, 0, 5),
        BackgroundColor3 = Color3.fromRGB(20, 8, 40),
        BackgroundTransparency = 0.45,
        BorderSizePixel = 0,
        Text = "-",
        TextColor3 = ACCENT,
        Font = Enum.Font.GothamBold,
        TextSize = 15,
        AutoButtonColor = false,
        ZIndex = 8
    })
    MVPUI.round(minimizeBtn, 9)

    local closeBtn = MVPUI.new("TextButton", header, {
        Name = "ZenithClose",
        AnchorPoint = Vector2.new(1, 0),
        Size = UDim2.fromOffset(26, 26),
        Position = UDim2.new(1, -6, 0, 5),
        BackgroundColor3 = Color3.fromRGB(20, 8, 40),
        BackgroundTransparency = 0.45,
        BorderSizePixel = 0,
        Text = "x",
        TextColor3 = ACCENT,
        Font = Enum.Font.GothamBold,
        TextSize = 14,
        AutoButtonColor = false,
        ZIndex = 8
    })
    MVPUI.round(closeBtn, 9)

    -- Botão Flutuante Restore
    local restoreChip = MVPUI.new("TextButton", gui, {
        Name = "ZenithRestoreChip",
        Size = UDim2.fromOffset(126, 28),
        Position = UDim2.new(0.5, -63, 0, 88),
        BackgroundColor3 = Color3.fromRGB(24, 11, 46),
        BorderSizePixel = 0,
        Text = "ZENITH",
        TextColor3 = Color3.fromRGB(186, 140, 255),
        Font = Enum.Font.GothamBlack,
        TextSize = 12,
        AutoButtonColor = false,
        Visible = false,
        ZIndex = 80
    })
    MVPUI.round(restoreChip, 10)
    MVPUI.stroke(restoreChip, ACCENT, 0.4, 1.2)
    drag(restoreChip)

    local function showGui()
        main.Visible = true
        restoreChip.Visible = false
    end
    local function hideGui()
        main.Visible = false
        restoreChip.Visible = true
    end
    showGui = showGui
    hideGui = hideGui
    local chipPressPos = nil
    restoreChip.InputBegan:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            chipPressPos = restoreChip.AbsolutePosition
        end
    end)
    restoreChip.Activated:Connect(function()
        if chipPressPos and (restoreChip.AbsolutePosition - chipPressPos).Magnitude > 8 then return end
        showGui()
    end)
    minimizeBtn.Activated:Connect(hideGui)
    closeBtn.Activated:Connect(hideGui)

    _G.__RivalHubMainOriginalPos = main.Position
    main:GetPropertyChangedSignal("Position"):Connect(function()
        _G.__RivalHubMainOriginalPos = main.Position
    end)
    drag(main, 46)

    -- ============================================================
    -- ABAS NO CANTO (SIDEBAR EXTERNA ACOPLADA NO CANTO ESQUERDO)
    -- ============================================================
    local sideTabBar = MVPUI.new("Frame", main, {
        Name = "SideTabBar",
        Size = UDim2.fromOffset(86, 426),
        Position = UDim2.fromOffset(10, 52),
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        ZIndex = 14
    })

    MVPUI.new("UIListLayout", sideTabBar, {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        Padding = UDim.new(0, 4),
        SortOrder = Enum.SortOrder.LayoutOrder
    })
    MVPUI.new("UIPadding", sideTabBar, {
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 6)
    })

    -- Subtítulo da Seção Ativa
    local pageHeading = MVPUI.text(main, "SPEED · MOVEMENT", UDim2.fromOffset(106, 48), UDim2.new(1, -120, 0, 18), 12, ACCENT, 7)
    pageHeading.Name = "SectionHeading"
    pageHeading.Font = Enum.Font.GothamBold

    -- Container do Conteúdo
    local tabContent = MVPUI.new("Frame", main, {
        Name = "Content",
        Size = UDim2.new(1, -112, 1, -114),
        Position = UDim2.fromOffset(102, 72),
        BackgroundTransparency = 1,
        ClipsDescendants = true,
        ZIndex = 6
    })

    -- Rodapé
    local footer = MVPUI.new("Frame", main, {
        Name = "Footer",
        Position = UDim2.new(0, 10, 1, -34),
        Size = UDim2.new(1, -20, 0, 26),
        BackgroundColor3 = Color3.fromRGB(24, 12, 46),
        BackgroundTransparency = 0.35,
        BorderSizePixel = 0,
        ZIndex = 8
    })
    MVPUI.round(footer, 6)
    MVPUI.stroke(footer, Color3.fromRGB(88, 28, 176), 0.6, 1)

    local avatar = MVPUI.new("ImageLabel", footer, {
        Position = UDim2.fromOffset(4, 4),
        Size = UDim2.fromOffset(18, 18),
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. LP.UserId .. "&w=150&h=150",
        BackgroundColor3 = INP,
        BorderSizePixel = 0,
        ZIndex = 9
    })
    MVPUI.round(avatar, 4)

    local userLabel = MVPUI.text(footer, LP.DisplayName or LP.Name, UDim2.fromOffset(28, 4), UDim2.new(0.5, -28, 1, -8), 9, WHITE, 9)
    userLabel.Font = Enum.Font.GothamBold

    local userHandle = MVPUI.text(footer, "@" .. LP.Name, UDim2.new(0.5, 0, 0, 4), UDim2.new(0.5, -8, 1, -8), 8, Color3.fromRGB(172, 152, 205), 9)
    userHandle.TextXAlignment = Enum.TextXAlignment.Right

    -- Definição das Abas no Canto
    local tabs = {"Speed", "Custom", "Visual", "Settings", "Keybinds"}
    local tabLabels = {"Speed", "Duel", "Visual", "Settings", "Keybinds"}
    local activeTabBtn = nil
    local headings = {"SPEED · MOVEMENT", "COMBAT · DUEL", "VISUAL · ESP", "SETTINGS · CONFIG", "KEYBINDS · ACCESS"}

    tabButtons = {}
    local contentPages = {}

    for i, name in ipairs(tabs) do
        local btn = MVPUI.new("TextButton", sideTabBar, {
            Name = name,
            Text = tabLabels[i],
            Size = UDim2.fromOffset(70, 30),
            BackgroundColor3 = ACCENT,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            TextColor3 = Color3.fromRGB(208, 190, 238),
            Font = Enum.Font.GothamBold,
            TextSize = 12,
            AutoButtonColor = false,
            ZIndex = 15,
            LayoutOrder = i
        })
        MVPUI.round(btn, 8)
        local btnStroke = MVPUI.stroke(btn, ACCENT, 1, 1)
        btnStroke.Name = "TabStroke"

        -- Indicador lateral neon na aba ativa
        local pill = MVPUI.new("Frame", btn, {
            Name = "ActivePill",
            AnchorPoint = Vector2.new(0, 0.5),
            Size = UDim2.fromOffset(3, 6),
            Position = UDim2.new(0, -6, 0.5, 0),
            BackgroundColor3 = ACCENT,
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ZIndex = 16
        })
        MVPUI.round(pill, 1)

        local page = MVPUI.new("ScrollingFrame", tabContent, {
            Name = name,
            Size = UDim2.fromScale(1, 1),
            BackgroundTransparency = 1,
            BorderSizePixel = 0,
            ScrollBarThickness = 3,
            ScrollBarImageColor3 = ACCENT,
            ScrollBarImageTransparency = 0.4,
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            CanvasSize = UDim2.new(),
            ScrollingDirection = Enum.ScrollingDirection.Y,
            ClipsDescendants = true,
            Visible = i == 1,
            ZIndex = 6
        })
        MVPUI.new("UIListLayout", page, {
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            HorizontalAlignment = Enum.HorizontalAlignment.Center
        })
        MVPUI.new("UIPadding", page, {
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 10),
            PaddingTop = UDim.new(0, 4),
            PaddingBottom = UDim.new(0, 16)
        })

        contentPages[name] = page
        table.insert(tabButtons, btn)

        local function select()
            activeTabBtn = btn
            pageHeading.Text = headings[i]
            for _, p in pairs(contentPages) do p.Visible = false end
            page.Visible = true
            page.Position = UDim2.fromOffset(0, 4)
            TS:Create(page, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = UDim2.fromOffset(0, 0)}):Play()

            for _, b in ipairs(tabButtons) do
                local on = (b == btn)
                b:SetAttribute("ZenithTabActive", on)
                TS:Create(b, TweenInfo.new(0.16), {
                    BackgroundTransparency = on and 0 or 1,
                    TextColor3 = on and Color3.fromRGB(22, 8, 40) or Color3.fromRGB(208, 190, 238)
                }):Play()
                local p = b:FindFirstChild("ActivePill")
                if p then
                    TS:Create(p, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {
                        BackgroundTransparency = on and 0 or 1,
                        Size = on and UDim2.fromOffset(3, 18) or UDim2.fromOffset(3, 6)
                    }):Play()
                end
            end
        end

        btn.Activated:Connect(select)
        btn.MouseEnter:Connect(function()
            if activeTabBtn ~= btn then
                TS:Create(btn, TweenInfo.new(0.1), {BackgroundTransparency = 0.85}):Play()
            end
        end)
        btn.MouseLeave:Connect(function()
            if activeTabBtn ~= btn then
                TS:Create(btn, TweenInfo.new(0.12), {BackgroundTransparency = 1}):Play()
            end
        end)
        if i == 1 then select() end
    end
    local pageCounters = {}
    local function getNextOrder(page)
        pageCounters[page] = (pageCounters[page] or 0) + 1
        return pageCounters[page]
    end
    local function mkSect(page, text)
        local row = MVPUI.new("Frame", page, {Name = "Section", Size = UDim2.new(1, -4, 0, 24), BackgroundTransparency = 1,
            LayoutOrder = getNextOrder(page), ZIndex = 7})
        local label = MVPUI.text(row, text:upper(), UDim2.fromOffset(2, 0), UDim2.new(1, -24, 1, 0),
            9, Color3.fromRGB(186, 140, 255), 8)
        label.Font = Enum.Font.GothamBlack
        local line = MVPUI.new("Frame", row, {Position = UDim2.fromOffset(2, 20), Size = UDim2.new(1, -16, 0, 1),
            BackgroundColor3 = getThemeColor(), BorderSizePixel = 0, ZIndex = 8})
        MVPUI.new("UIGradient", line, {Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(186, 140, 255)),
            ColorSequenceKeypoint.new(0.65, Color3.fromRGB(105, 40, 190)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))}),
            Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(0.7, 0.4), NumberSequenceKeypoint.new(1, 1)})})
        return row
    end
    local function mkRow(page, height)
        local row = MVPUI.new("Frame", page, {Name = "Control", Size = UDim2.new(1, -4, 0, math.max(height or 40, 40)),
            BackgroundColor3 = ROW_BG, BackgroundTransparency = 0.06, BorderSizePixel = 0,
            LayoutOrder = getNextOrder(page), ZIndex = 7})
        MVPUI.round(row, 12)
        MVPUI.new("UIGradient", row, {Rotation = 90, Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(106, 76, 145)),
        ColorSequenceKeypoint.new(0.55, Color3.fromRGB(75, 51, 108)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(49, 33, 72))})})
        local stroke = MVPUI.stroke(row, ROW_BORDER, 0.5, 1)
        MVPUI.new("UIGradient", stroke, {Rotation = 0, Color = ColorSequence.new(Color3.fromRGB(186, 140, 255), Color3.fromRGB(88, 28, 176))})
        local accentBar = MVPUI.new("Frame", row, {Name = "RowAccent", Size = UDim2.fromOffset(3, 18),
            Position = UDim2.new(0, 1, 0.5, -9), BackgroundColor3 = getThemeColor(), BackgroundTransparency = 0.4,
            BorderSizePixel = 0, ZIndex = 8})
        MVPUI.round(accentBar, 2)
        row.MouseEnter:Connect(function() TS:Create(stroke, TweenInfo.new(0.12), {Transparency = 0.12}):Play() end)
        row.MouseLeave:Connect(function() TS:Create(stroke, TweenInfo.new(0.12), {Transparency = 0.5}):Play() end)
        return row
    end
    local function mkLabel(row, text)
        return MVPUI.text(row, text, UDim2.fromOffset(14, 0), UDim2.new(0.48, -8, 1, 0), 12, WHITE, 8)
    end
    local function mkPill(row)
        local pill = MVPUI.new("Frame", row, {Name = "Track", Size = UDim2.fromOffset(56, 27),
            AnchorPoint = Vector2.new(1, 0.5), Position = UDim2.new(1, -13, 0.5, 0),
            BackgroundColor3 = Color3.fromRGB(44, 22, 82), BorderSizePixel = 0, ZIndex = 8})
        MVPUI.round(pill, 13)
        MVPUI.stroke(pill, ROW_BORDER, 0.57, 1)
        local state = MVPUI.text(pill, "OFF", UDim2.fromOffset(19, 0), UDim2.fromOffset(34, 27), 8,
            Color3.fromRGB(140, 147, 156), 9)
        state.Name = "State"
        state.TextXAlignment = Enum.TextXAlignment.Center
        local dot = MVPUI.new("Frame", pill, {Name = "Knob", AnchorPoint = Vector2.new(0.5, 0.5),
            Size = UDim2.fromOffset(15, 15), Position = UDim2.new(0, 12, 0.5, 0),
            BackgroundColor3 = Color3.fromRGB(172, 152, 205), BorderSizePixel = 0, ZIndex = 9})
        MVPUI.round(dot, 8)
        return pill, dot
    end
    local function animPill(pill, dot, on)
        TS:Create(pill, TweenInfo.new(0.16), {BackgroundColor3 = on and Color3.fromRGB(150, 80, 255) or Color3.fromRGB(44, 22, 82)}):Play()
        TS:Create(dot, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = on and UDim2.new(1, -12, 0.5, 0) or UDim2.new(0, 12, 0.5, 0), BackgroundColor3 = on and Color3.fromRGB(16, 6, 32) or Color3.fromRGB(172, 152, 205)}):Play()
        local state = pill:FindFirstChild("State")
        if state then state.Text = on and "ON" or "OFF"; state.TextColor3 = on and WHITE or Color3.fromRGB(172, 152, 205); state.Position = on and UDim2.fromOffset(2, 0) or UDim2.fromOffset(19, 0) end
        local stroke = pill:FindFirstChildOfClass("UIStroke")
        if stroke then stroke.Color = on and getThemeColor() or ROW_BORDER; stroke.Transparency = on and 0.28 or 0.57 end
    end
    local function mkToggle(page, text, callback)
        local row = mkRow(page, 46)
        local label = mkLabel(row, text)
        label.Size = UDim2.new(1, -86, 1, 0)
        local pill, dot = mkPill(row)
        local on = false
        local function set(value)
            on = value == true
            row:SetAttribute("MVPActive", on)
            animPill(pill, dot, on)
            row:FindFirstChildOfClass("UIStroke").Transparency = on and 0.25 or 0.5
        end
        local hit = MVPUI.new("TextButton", row, {Name = "ToggleHit", Size = UDim2.fromScale(1, 1), Text = "",
            BackgroundTransparency = 1, AutoButtonColor = false, ZIndex = 10})
        hit.Activated:Connect(function()
            local previous = on
            set(not on)
            local ok, err = pcall(callback, on)
            if not ok then set(previous); warn("[MVP] " .. text .. ": " .. tostring(err)) end
            task.defer(function() pcall(saveAllSettings) end)
        end)
        return set
    end
    local function mkSelector(row, default, options, callback)
        local frame = MVPUI.new("Frame", row, {Name = "Selector", Size = UDim2.fromOffset(146, 32),
            Position = UDim2.new(1, -156, 0.5, -16), BackgroundColor3 = INP, BorderSizePixel = 0, ZIndex = 8})
        MVPUI.round(frame, 8)
        MVPUI.stroke(frame, ROW_BORDER, 0.68, 1)
        MVPUI.new("UIGradient", frame, {Rotation = 90, Color = ColorSequence.new(Color3.fromRGB(64, 30, 116), Color3.fromRGB(24, 12, 46))})
        local label = MVPUI.text(frame, default, UDim2.fromOffset(30, 0), UDim2.fromOffset(86, 32), 10, WHITE, 9)
        label.Font = Enum.Font.GothamBold
        label.TextXAlignment = Enum.TextXAlignment.Center
        for i, direction in ipairs({-1, 1}) do
            local button = MVPUI.new("TextButton", frame, {Size = UDim2.fromOffset(29, 32),
                Position = UDim2.fromOffset(i == 1 and 0 or 117, 0), BackgroundColor3 = INP,
                BorderSizePixel = 0, Text = direction == -1 and "‹" or "›", TextSize = 21,
                Font = Enum.Font.GothamMedium, TextColor3 = getThemeColor(), AutoButtonColor = false, ZIndex = 9})
            MVPUI.round(button, 8)
            button.Activated:Connect(function()
                callback(direction, function(text) label.Text = text end)
                task.defer(function() pcall(saveAllSettings) end)
            end)
        end
        return label
    end
    local function mkBox(row, default, width, xoff, callback)
        local w = math.max(width or 56, 64)
        local box = MVPUI.new("TextBox", row, {Size = UDim2.fromOffset(w, 32),
            Position = UDim2.new(1, -math.max(xoff or 76, w + 12), 0.5, -16), Text = tostring(default),
            BackgroundColor3 = INP, BorderSizePixel = 0, Font = Enum.Font.GothamBold, TextSize = 13,
            TextColor3 = Color3.fromRGB(255, 255, 255), ClearTextOnFocus = false, ZIndex = 9})
        MVPUI.round(box, 8)
        MVPUI.new("UIGradient", box, {Rotation = 90, Color = ColorSequence.new(Color3.fromRGB(64, 30, 116), Color3.fromRGB(24, 12, 46))})
        local border = MVPUI.stroke(box, ROW_BORDER, 0.58, 1)
        local lastValid = tostring(default)
        box.Focused:Connect(function() border.Color = getThemeColor(); border.Transparency = 0.10 end)
        box.FocusLost:Connect(function()
            border.Color = ROW_BORDER; border.Transparency = 0.58
            local value = tonumber(box.Text)
            if value and value == value and math.abs(value) < math.huge then
                local ok = pcall(callback, value)
                if ok then lastValid = box.Text else box.Text = lastValid end
            else box.Text = lastValid end
            task.defer(function() pcall(saveAllSettings) end)
        end)
        return box
    end
    local function mkKeyButton(row, entry)
        local function name() return (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None" end
        local button = MVPUI.new("TextButton", row, {Size = UDim2.fromOffset(116, 32),
            Position = UDim2.new(1, -128, 0.5, -16), Text = name(), BackgroundColor3 = Color3.fromRGB(226, 216, 245),
            TextSize = 12, Font = Enum.Font.GothamBold, TextColor3 = Color3.fromRGB(45, 27, 65), BorderSizePixel = 0,
            AutoButtonColor = false, ZIndex = 9})
        MVPUI.round(button, 9)
        MVPUI.stroke(button, Color3.fromRGB(205, 174, 245), 0.08, 1.3)
        local connection, axisConnection, timeout, listening = nil, nil, nil, false
        local function stop()
            listening = false; _anyKeyListening = false
            if connection then connection:Disconnect(); connection = nil end
            if axisConnection then axisConnection:Disconnect(); axisConnection = nil end
            if timeout then pcall(task.cancel, timeout); timeout = nil end
            button.Text = name(); button.TextColor3 = Color3.fromRGB(45, 27, 65); button.BackgroundColor3 = Color3.fromRGB(226, 216, 245)
        end
        button.Activated:Connect(function()
            if listening then stop(); return end
            if _anyKeyListening then return end
            listening = true; _anyKeyListening = true
            button.Text = "Press a key"; button.TextColor3 = Color3.fromRGB(28, 20, 8); button.BackgroundColor3 = Color3.fromRGB(255, 220, 120)
            local started = _tick()
            local function accept(input)
                if not listening then return end
                if input.KeyCode == Enum.KeyCode.Escape then stop(); return end
                if not isBindableInput(input) then return end
                local controller = isGamepadInput(input)
                if controller and _tick() - started < 0.2 then return end
                if controller and (input.KeyCode == Enum.KeyCode.ButtonL2 or input.KeyCode == Enum.KeyCode.ButtonR2)
                    and input.Position.Z < 0.55 then return end
                if controller then entry.gp = input.KeyCode; entry.kb = nil
                else entry.kb = input.KeyCode; entry.gp = nil end
                stop(); pcall(saveAllSettings, true)
            end
            connection = UIS.InputBegan:Connect(accept)
            axisConnection = UIS.InputChanged:Connect(accept)
            timeout = task.delay(10, stop)
        end)
        table.insert(keyButtonRefs, {btn = button, entry = entry})
        return button
    end
    local function addKeybindRow(page, text, entry)
        local row = mkRow(page, 46)
        mkLabel(row, text)
        mkKeyButton(row, entry)
    end

    local speedPage = contentPages["Speed"]

    mkSect(speedPage, "Movement Speeds")
    do local row = mkRow(speedPage, 42); mkLabel(row, "Normal Speed"); normalBox = mkBox(row, NS, 50, 56, function(v) if v == v and v > 0 and v < math.huge then NS = v; if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end end end) end
    do local row = mkRow(speedPage, 42); mkLabel(row, "Carry Speed"); carryBox = mkBox(row, CS, 50, 56, function(v) if v == v and v > 0 and v < math.huge then CS = v; if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end end end) end
    do local row = mkRow(speedPage, 42); mkLabel(row, "Lagger Normal Speed"); laggerBox = mkBox(row, LAGGER_SPEED, 50, 56, function(v) if v == v and v > 0 and v < math.huge then LAGGER_SPEED = v; if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end end end) end
    do local row = mkRow(speedPage, 42); mkLabel(row, "Lagger Carry Speed"); lagger2Box = mkBox(row, LAGGER_CARRY_SPEED, 50, 56, function(v) if v == v and v > 0 and v < math.huge then LAGGER_CARRY_SPEED = v; if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end end end) end

    mkSect(speedPage, "Speed Engine")
    do
        local row = mkRow(speedPage, 46)
        mkLabel(row, "Speed Motor")
        MVPUI.motorLabel = mkSelector(row, useVenixCarryEngine and "Carry Boost" or "Direct", {"Direct", "Carry Boost"}, function(direction, update)
            useVenixCarryEngine = not useVenixCarryEngine
            update(useVenixCarryEngine and "Carry Boost" or "Direct")
            if _G.__RivalHubRefreshSpeedEngine then _G.__RivalHubRefreshSpeedEngine() end
        end)
    end
    MVPUI.carrySetter = mkToggle(speedPage, "Auto Carry", function(on)
        MVPVenixCarry:setSoftStealEnabled(on)
        if on then useVenixCarryEngine = true end
        if MVPUI.motorLabel then MVPUI.motorLabel.Text = useVenixCarryEngine and "Carry Boost" or "Direct" end
        if _G.__RivalHubRefreshSpeedEngine then _G.__RivalHubRefreshSpeedEngine() end
    end)
    do
        local row = mkRow(speedPage, 46); mkLabel(row, "Auto Carry Speed")
        MVPUI.carrySpeedBox = mkBox(row, MVPVenixCarry.softStealSpeed, 60, 72, function(v)
            MVPVenixCarry:setSoftStealSpeed(v); MVPUI.carrySpeedBox.Text = tostring(MVPVenixCarry.softStealSpeed)
        end)
    end
    do
        local row = mkRow(speedPage, 46); mkLabel(row, "Auto Carry Radius")
        MVPUI.carryRadiusBox = mkBox(row, MVPVenixCarry.softStealRadius, 60, 72, function(v)
            MVPVenixCarry:setSoftStealRadius(v); MVPUI.carryRadiusBox.Text = tostring(MVPVenixCarry.softStealRadius)
        end)
    end
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
        modeBtn.Size = UDim2.new(0, 100, 0, 32)
        modeBtn.Position = UDim2.new(1, -108, 0.5, -16)
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

    local combatPage = contentPages["Custom"]

    -- Zenith-exclusive combat banner: Halloween artwork + fight-themed title/icons.
    do
        local banner = MVPUI.new("Frame", combatPage, {Name = "ZenithCombatBanner", Size = UDim2.new(1, -4, 0, 78),
            BackgroundColor3 = Color3.fromRGB(18, 10, 28), BorderSizePixel = 0, LayoutOrder = 0, ClipsDescendants = true, ZIndex = 8})
        MVPUI.round(banner, 12)
        MVPUI.stroke(banner, Color3.fromRGB(172, 69, 255), 0.22, 1.5)
        local art = MVPUI.new("ImageLabel", banner, {Name = "CombatArtwork", Size = UDim2.fromScale(1, 1),
            Image = "rbxassetid://" .. backgroundImages[2], ImageTransparency = 0.18,
            BackgroundTransparency = 1, ScaleType = Enum.ScaleType.Crop, ZIndex = 8})
        MVPUI.round(art, 12)
        local shade = MVPUI.new("Frame", banner, {Name = "CombatShade", Size = UDim2.fromScale(1, 1),
            BackgroundColor3 = Color3.fromRGB(13, 11, 10), BackgroundTransparency = 0.20, BorderSizePixel = 0, ZIndex = 9})
        MVPUI.round(shade, 12)
        MVPUI.new("UIGradient", shade, {Rotation = 0, Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.04), NumberSequenceKeypoint.new(1, 0.34)})})
        local emblem = MVPUI.text(banner, "⚔", UDim2.fromOffset(12, 12), UDim2.fromOffset(42, 44), 30,
            Color3.fromRGB(186, 140, 255), 11)
        emblem.TextXAlignment = Enum.TextXAlignment.Center
        emblem.ZIndex = 11
        local headline = MVPUI.text(banner, "COMBAT", UDim2.fromOffset(61, 12), UDim2.new(1, -72, 0, 30), 20,
            Color3.fromRGB(255, 239, 255), 11)
        headline.Font = Enum.Font.GothamBlack
        headline.ZIndex = 11
        local tagline = MVPUI.text(banner, "FIGHT • COUNTER • DOMINATE", UDim2.fromOffset(63, 43), UDim2.new(1, -75, 0, 17), 8,
            Color3.fromRGB(172, 152, 205), 11)
        tagline.Font = Enum.Font.GothamBold
        tagline.ZIndex = 11
    end

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
        local row = mkRow(combatPage, 46)
        mkLabel(row, "Anti Ragdoll")
        local modes = {"off", "v1", "v2"}
        local label = mkSelector(row, antiRagdollMode:upper(), modes, function(direction, update)
            local index = antiRagdollMode == "v1" and 2 or (antiRagdollMode == "v2" and 3 or 1)
            index = (index - 1 + direction) % #modes + 1
            setAntiRagdollMode(modes[index])
            update(antiRagdollMode:upper())
        end)
        _G.updateAntiRagdollUI = function(mode) label.Text = mode:upper() end
        setAntiRagVisual = function(on) if not on then setAntiRagdollMode("off") end end
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
    autoBatSetVisual = mkToggle(combatPage, "Aimbot Bypass", function(on)
        if on then enableAutoBat() else disableAutoBat() end
        if mobSetAutoBat then mobSetAutoBat(on) end
        pcall(saveAllSettings, true)
    end)
    do local row = mkRow(combatPage, 42); mkLabel(row, "Aimbot Bypass Speed"); batSpeedBox = mkBox(row, AIMBOT_BYPASS_SPEED, 50, 56, function(v) if v == v and v > 0 and v < math.huge then AIMBOT_BYPASS_SPEED = math.clamp(v, 1, 500); State.bypassBatSpeed = AIMBOT_BYPASS_SPEED; saveAllSettings() end end) end
    batAimbotSetVisual = mkToggle(combatPage, "Bat Aimbot", function(on)
        if on then enableBatAimbot() else disableBatAimbot() end
        if mobSetBatAimbot then mobSetBatAimbot(on) end
        pcall(saveAllSettings, true)
    end)
    do local row = mkRow(combatPage, 42); mkLabel(row, "Bat Aimbot Speed"); batAimbotSpeedBox = mkBox(row, CLOUD_BAT_AIMBOT_SPEED, 50, 56, function(v) if v == v and v > 0 and v < math.huge then CLOUD_BAT_AIMBOT_SPEED = math.clamp(v, 1, 200); if State then State.batAimbotSpeed = CLOUD_BAT_AIMBOT_SPEED end; saveAllSettings() end end) end

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
    do
        local row = mkRow(visualPage, 95)
        row.BackgroundTransparency = 1
        local border = row:FindFirstChildOfClass("UIStroke"); if border then border:Destroy() end
        for i, asset in ipairs(backgroundImages) do
            local card = MVPUI.new("ImageButton", row, {Size = UDim2.new(1 / 3, -6, 1, 0),
                Position = UDim2.new((i - 1) / 3, (i - 1) * 3, 0, 0), Image = "rbxassetid://" .. asset,
                ScaleType = Enum.ScaleType.Crop, BackgroundColor3 = Color3.fromRGB(12, 16, 21),
                BorderSizePixel = 0, AutoButtonColor = false, ClipsDescendants = true, ZIndex = 8})
            MVPUI.round(card, 12)
            MVPUI.stroke(card, getThemeColor(), 0.72, 1.7)
            local scrim = MVPUI.new("Frame", card, {Size = UDim2.fromScale(1, 1), BackgroundColor3 = Color3.fromRGB(8, 12, 17), BackgroundTransparency = 0.95, BorderSizePixel = 0, ZIndex = 9})
            MVPUI.round(scrim, 12)
            local badge = MVPUI.new("Frame", card, {Name = "Selected", Size = UDim2.fromOffset(16, 16),
                Position = UDim2.new(1, -22, 0, 6), BackgroundColor3 = getThemeColor(), BorderSizePixel = 0,
                Visible = false, ZIndex = 10})
            MVPUI.round(badge, 6)
            local check = MVPUI.text(badge, "✓", UDim2.fromOffset(0, 0), UDim2.fromScale(1, 1), 11, WHITE, 11)
            check.TextXAlignment = Enum.TextXAlignment.Center
            local label = MVPUI.text(card, "SCENE 0" .. i,
                UDim2.new(0, 8, 1, -25), UDim2.new(1, -12, 0, 19), 9, WHITE, 10)
            label.Font = Enum.Font.GothamBold
            card.Activated:Connect(function() applyBackgroundMode("Background " .. i); pcall(saveAllSettings, true) end)
            MVPUI.cards[i] = card
        end
        applyBackgroundMode(backgroundMode)
    end
    setLockUIVisual = mkToggle(visualPage, "Lock UI", function(on) toggleLockUI(on) end)
    setHideButtonsVisual = mkToggle(visualPage, "Hide Button", function(on) toggleHideButtons(on) end)
    if setHideButtonsVisual then setHideButtonsVisual(hideButtonsEnabled) end

    MVPUI.lockButtonsSetter = mkToggle(visualPage, "Lock Mobile Buttons", function(on) mobileButtonsLocked = on end)
    do
        local row = mkRow(visualPage, 46)
        mkLabel(row, "Mobile Button Style")
        MVPUI.mobileStyleLabel = mkSelector(row, mobileButtonStyle == "Circle" and "Círculo" or "Normal", {"Normal", "Círculo"}, function(direction, update)
            mobileButtonStyle = (mobileButtonStyle == "Circle") and "Normal" or "Circle"
            update(mobileButtonStyle == "Circle" and "Círculo" or "Normal")
            applyMobileButtonStyle()
        end)
    end
    MVPUI.effectsSetter = mkToggle(visualPage, "Halloween Effects", function(on) MVPUI.effects = on end)

    -- Zenith Hub: selectors for local tool cosmetics (visual-only)
    mkSect(visualPage, "Sword / Medusa Skins")
    _G.ZenithCustomToolSoundsEnabled = _G.ZenithCustomToolSoundsEnabled ~= false
    mkToggle(visualPage, "Custom Sounds (Sword / Katana / Medusa)", function(on)
        _G.ZenithCustomToolSoundsEnabled = on
        if not on then
            -- Stop any custom sounds already playing when disabled.
            local lp = game:GetService("Players").LocalPlayer
            local function stopCustomSounds(container)
                if not container then return end
                for _, obj in ipairs(container:GetDescendants()) do
                    if obj:IsA("Sound") and obj.Name == "ShelCustomToolSound" then
                        pcall(function() obj:Stop() end)
                    elseif obj:IsA("Sound") then
                        pcall(function()
                            if obj:GetAttribute("ZenithOriginalSoundVolume") ~= nil then
                                obj.Volume = obj:GetAttribute("ZenithOriginalSoundVolume")
                            end
                        end)
                    end
                end
            end
            stopCustomSounds(lp.Character)
            stopCustomSounds(lp:FindFirstChildOfClass("Backpack"))
        end
        pcall(saveAllSettings, true)
    end)
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Sword Skin")
        local options = {"Default", "Sword", "Katana"}
        local current = _G.ZenithSwordSkinMode or "Katana"
        local function currentIndex()
            for i, v in ipairs(options) do if v == current then return i end end
            return 1
        end
        mkSelector(row, current, options, function(direction, updateLabel)
            local idx = currentIndex() + direction
            if idx < 1 then idx = #options elseif idx > #options then idx = 1 end
            current = options[idx]
            _G.ZenithSwordSkinMode = current
            if _G.ShelSwordVisual and _G.ShelSwordVisual.setMode then pcall(_G.ShelSwordVisual.setMode, current) end
            updateLabel(current)
            pcall(saveAllSettings, true)
        end)
    end
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Sword Color")
        local options = {"RGB", "Blue", "Green", "Purple", "Red", "Gold", "White"}
        local current = _G.ZenithSwordColorMode or "RGB"
        local function currentIndex()
            for i, v in ipairs(options) do if v == current then return i end end
            return 1
        end
        mkSelector(row, current, options, function(direction, updateLabel)
            local idx = currentIndex() + direction
            if idx < 1 then idx = #options elseif idx > #options then idx = 1 end
            current = options[idx]
            _G.ZenithSwordColorMode = current
            if _G.ShelSwordVisual and _G.ShelSwordVisual.setColor then pcall(_G.ShelSwordVisual.setColor, current) end
            updateLabel(current)
            pcall(saveAllSettings, true)
        end)
    end
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Medusa Skin")
        local options = {"Default", "Bomb", "Skull", "Golden Desert Eagle"}
        local current = _G.ZenithMedusaSkinMode or "Bomb"
        local function currentIndex()
            for i, v in ipairs(options) do if v == current then return i end end
            return 1
        end
        mkSelector(row, current, options, function(direction, updateLabel)
            local idx = currentIndex() + direction
            if idx < 1 then idx = #options elseif idx > #options then idx = 1 end
            current = options[idx]
            _G.ZenithMedusaSkinMode = current
            if _G.ShelMedusaSkin and _G.ShelMedusaSkin.setMode then pcall(_G.ShelMedusaSkin.setMode, current) end
            updateLabel(current)
            pcall(saveAllSettings, true)
        end)
    end
    mkSect(visualPage, "ZENITH • CUSTOMS")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Bat Custom • Zenith")
        local options = {"Off", "Scythe Bear", "Scythe White", "Black Hammer"}
        local keys = {Off = "off", ["Scythe Bear"] = "scythe_bear", ["Scythe White"] = "scythe_white", ["Black Hammer"] = "black_hammer"}
        local current = "Off"
        for name, key in pairs(keys) do if (_G.ZenithCloudBatCustomKey or "off") == key then current = name end end
        local function currentIndex()
            for i, v in ipairs(options) do if v == current then return i end end
            return 1
        end
        mkSelector(row, current, options, function(direction, updateLabel)
            local idx = currentIndex() + direction
            if idx < 1 then idx = #options elseif idx > #options then idx = 1 end
            current = options[idx]
            _G.ZenithCloudBatCustomKey = keys[current]
            if _G.ZenithCloudCustoms and _G.ZenithCloudCustoms.setBatCustom then pcall(_G.ZenithCloudCustoms.setBatCustom, keys[current]) end
            updateLabel(current)
            pcall(saveAllSettings, true)
        end)
    end
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "Medusa Custom (Cloud)")
        local options = {"Off", "Evil Skull", "Ominous Skull", "Skull Cone", "Kamehameha", "Fire Ball", "Rasengan"}
        local keys = {Off = "off", ["Evil Skull"] = "evil", ["Ominous Skull"] = "ominous", ["Skull Cone"] = "cone", Kamehameha = "kamehameha", ["Fire Ball"] = "fireball", Rasengan = "rasengan"}
        local current = "Off"
        for name, key in pairs(keys) do if (_G.ZenithCloudMedusaCustomKey or "off") == key then current = name end end
        local function currentIndex()
            for i, v in ipairs(options) do if v == current then return i end end
            return 1
        end
        mkSelector(row, current, options, function(direction, updateLabel)
            local idx = currentIndex() + direction
            if idx < 1 then idx = #options elseif idx > #options then idx = 1 end
            current = options[idx]
            _G.ZenithCloudMedusaCustomKey = keys[current]
            if _G.ZenithCloudCustoms and _G.ZenithCloudCustoms.setMedusaCustom then pcall(_G.ZenithCloudCustoms.setMedusaCustom, keys[current]) end
            updateLabel(current)
            pcall(saveAllSettings, true)
        end)
    end
    setCloudTransparentVisual = mkToggle(visualPage, "Bat/Medusa Transparent (Cloud)", function(on)
        _G.ZenithCloudTransparent = on
        if _G.ZenithCloudCustoms and _G.ZenithCloudCustoms.setTransparent then pcall(_G.ZenithCloudCustoms.setTransparent, on) end
        pcall(saveAllSettings, true)
    end)
    setCloudRainbowVisual = mkToggle(visualPage, "Bat/Medusa Rainbow (Cloud)", function(on)
        _G.ZenithCloudRainbow = on
        if _G.ZenithCloudCustoms and _G.ZenithCloudCustoms.setRainbow then pcall(_G.ZenithCloudCustoms.setRainbow, on) end
        pcall(saveAllSettings, true)
    end)
    setCloudNoSoundVisual = mkToggle(visualPage, "Bat Custom No Sound (Cloud)", function(on)
        _G.ZenithCloudBatNoSound = on
        if _G.ZenithCloudCustoms and _G.ZenithCloudCustoms.setNoSound then pcall(_G.ZenithCloudCustoms.setNoSound, on) end
        pcall(saveAllSettings, true)
    end)

    mkSect(visualPage, "Display")
    do
        local row = mkRow(visualPage, 42)
        mkLabel(row, "UI Scale")
        uiScaleBox = mkBox(row, uiScaleValue, 50, 56, function(v)
            local n = _clamp(_floor(v+0.5), 50, 150)
            uiScaleValue = n
            if MVPUI.fit then MVPUI.fit() end
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
        leftBtn.BackgroundTransparency = 0.10
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
        rightBtn.BackgroundTransparency = 0.10
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
        leftBtn.BackgroundTransparency = 0.10
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
        rightBtn.BackgroundTransparency = 0.10
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
        leftBtn.BackgroundTransparency = 0.10
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
        rightBtn.BackgroundTransparency = 0.10
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
        mkLabel(row, "Zenith Title Color")
        local container = Instance.new("Frame", row)
        container.Size = UDim2.new(0, 160, 1, 0)
        container.Position = UDim2.new(1, -168, 0, 0)
        container.BackgroundTransparency = 1
        container.ZIndex = 8
        local leftBtn = Instance.new("TextButton", container)
        leftBtn.Size = UDim2.new(0, 28, 0, 26)
        leftBtn.Position = UDim2.new(0, 0, 0.5, -13)
        leftBtn.BackgroundColor3 = INP
        leftBtn.BackgroundTransparency = 0.10
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
        rightBtn.BackgroundTransparency = 0.10
        rightBtn.BorderSizePixel = 0
        rightBtn.Text = ">"
        rightBtn.TextColor3 = WHITE
        rightBtn.Font = Enum.Font.GothamBold
        rightBtn.TextSize = 13
        rightBtn.AutoButtonColor = false
        rightBtn.ZIndex = 9
        Instance.new("UICorner", rightBtn).CornerRadius = UDim.new(0, 6)

        local RIVAL_THEME_LIST = { "Orange", "Blue", "Red", "Green", "Black", "Gray" }
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
        leftBtn.BackgroundTransparency = 0.10
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
        rightBtn.BackgroundTransparency = 0.10
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

    local configPage = contentPages["Settings"]

    mkSect(configPage, "Automation")

    -- Auto Grab tem um controle exclusivo Zenith: cartão de caça com faixa de status,
    -- separado do toggle padrão usado nas demais opções.
    do
        local row = MVPUI.new("Frame", configPage, {Name = "ZenithAutoGrabCard", Size = UDim2.new(1, -2, 0, 72),
            BackgroundColor3 = Color3.fromRGB(12, 8, 28), BorderSizePixel = 0, ZIndex = 8, LayoutOrder = 1})
        MVPUI.round(row, 16)
        MVPUI.stroke(row, Color3.fromRGB(190, 115, 255), 0.04, 2.2)
        local orangeGlow = MVPUI.new("Frame", row, {Name = "ZenithPurpleAccent", Size = UDim2.new(1, -18, 0, 2), Position = UDim2.new(0, 9, 1, -5), BackgroundColor3 = Color3.fromRGB(150, 80, 255), BorderSizePixel = 0, ZIndex = 11})
        MVPUI.round(orangeGlow, 2)
        MVPUI.new("UIGradient", row, {Rotation = 0, Color = ColorSequence.new(
            Color3.fromRGB(76, 25, 132), Color3.fromRGB(10, 8, 25))})
        local icon = MVPUI.text(row, "☠", UDim2.fromOffset(12, 12), UDim2.fromOffset(28, 30), 22,
            Color3.fromRGB(218, 177, 255), 10)
        icon.TextXAlignment = Enum.TextXAlignment.Center
        local label = MVPUI.text(row, "AUTO GRAB", UDim2.fromOffset(48, 10), UDim2.new(1, -145, 0, 22), 12,
            Color3.fromRGB(240, 230, 255), 10)
        label.Font = Enum.Font.GothamBlack
        local sub = MVPUI.text(row, "ZENITH • GRAB SYSTEM", UDim2.fromOffset(49, 36), UDim2.new(1, -145, 0, 15), 8,
            Color3.fromRGB(190, 174, 224), 10)
        sub.Font = Enum.Font.GothamMedium
        local toggle = MVPUI.new("TextButton", row, {Name = "GrabToggle", Size = UDim2.fromOffset(82, 32),
            Position = UDim2.new(1, -92, 0.5, -16), BackgroundColor3 = Color3.fromRGB(38, 19, 65),
            BorderSizePixel = 0, Text = "OFF", TextColor3 = Color3.fromRGB(220, 204, 245),
            Font = Enum.Font.GothamBlack, TextSize = 10, AutoButtonColor = false, ZIndex = 12})
        MVPUI.round(toggle, 11)
        local toggleStroke = MVPUI.stroke(toggle, Color3.fromRGB(159, 91, 220), 0.16, 1.4)
        local isOn = CONFIG.AUTO_STEAL_ENABLED == true
        local function setGrab(value)
            isOn = value == true
            toggle.Text = isOn and "✦ ACTIVE" or "○ OFF"
            TS:Create(toggle, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                BackgroundColor3 = isOn and Color3.fromRGB(143, 49, 226) or Color3.fromRGB(38, 19, 65),
                Size = isOn and UDim2.new(0, 86, 0, 34) or UDim2.new(0, 82, 0, 32)
            }):Play()
            toggle.TextColor3 = isOn and Color3.fromRGB(240, 230, 255) or Color3.fromRGB(220, 204, 245)
            toggleStroke.Color = isOn and Color3.fromRGB(208, 133, 255) or Color3.fromRGB(159, 91, 220)
            toggleStroke.Transparency = isOn and 0.05 or 0.35
            row:SetAttribute("ZenithGrabActive", isOn)
        end
        setInstaGrab = setGrab
        toggle.Activated:Connect(function()
            local nextValue = not isOn
            setGrab(nextValue)
            CONFIG.AUTO_STEAL_ENABLED = nextValue
            local ok, err = pcall(function()
                if nextValue then startAutoSteal() else stopAutoSteal() end
                updateProgressBarVisibility()
                pcall(saveAllSettings, true)
            end)
            if not ok then
                setGrab(not nextValue)
                CONFIG.AUTO_STEAL_ENABLED = not nextValue
                warn("[Zenith Auto Steal] " .. tostring(err))
            end
        end)
        local hit = MVPUI.new("TextButton", row, {Name = "GrabCardHit", Size = UDim2.new(1, -98, 1, 0),
            BackgroundTransparency = 1, Text = "", AutoButtonColor = false, ZIndex = 9})
        hit.Activated:Connect(function() toggle:Activate() end)
        setGrab(isOn)
    end
    do
        local row = mkRow(configPage, 46)
        mkLabel(row, "Grab Mode")
        autoStealModeBtn = mkSelector(row, autoStealMode, AUTO_STEAL_VARIANT_NAMES, function(direction, update)
            local index = (autoStealVariant - 1 + direction) % #AUTO_STEAL_VARIANT_NAMES + 1
            local enabled = CONFIG.AUTO_STEAL_ENABLED
            if enabled then stopAutoSteal() end
            setAutoStealMode(AUTO_STEAL_VARIANT_NAMES[index])
            update(autoStealMode)
            if enabled then startAutoSteal() end
        end)
    end

    do
        local row = mkRow(configPage, 42)
        mkLabel(row, "Steal Radius")
        radInput = mkBox(row, CONFIG.STEAL_RANGE, 50, 56, function(v)
            if v and v >= 5 and v <= 300 then
                CONFIG.STEAL_RANGE = _floor(v+0.5)
                Steal.StealRadius = autoStealVariant == 6 and 10 or CONFIG.STEAL_RANGE
                radInput.Text = tostring(CONFIG.STEAL_RANGE)
                saveAllSettings()
            end
        end)
    end

    -- Ping Lagger removido desta versão do Zenith Hub.

    -- Seção de música removida para evitar downloads e carregamento de áudio.

    mkSect(configPage, "Management")
    do
        local row = mkRow(configPage, 44)
        row.Size = UDim2.new(1, 0, 0, 44)
        local saveBtn = Instance.new("TextButton", row)
        saveBtn.Size = UDim2.new(1, -12, 0.8, 0)
        saveBtn.Position = UDim2.new(0, 6, 0.1, 0)
        saveBtn.BackgroundColor3 = Color3.fromRGB(27, 30, 33)
        saveBtn.BorderSizePixel = 0
        saveBtn.Text = "SAVE CONFIG"
        saveBtn.TextColor3 = Color3.fromRGB(240, 214, 175)
        saveBtn.Font = Enum.Font.GothamBold
        saveBtn.TextSize = 13
        saveBtn.AutoButtonColor = false
        saveBtn.ZIndex = 8
        Instance.new("UICorner", saveBtn).CornerRadius = UDim.new(0, 6)
        local saveStroke = Instance.new("UIStroke", saveBtn)
        saveStroke.Color = getThemeColor()
        saveStroke.Thickness = 1.5
        saveStroke.Transparency = 0.4
        saveBtn.MouseEnter:Connect(function()
            TS:Create(saveBtn, TweenInfo.new(0.15), {BackgroundColor3 = getThemeColor()}):Play()
            TS:Create(saveBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end)
        saveBtn.MouseLeave:Connect(function()
            TS:Create(saveBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(27, 30, 33)}):Play()
            TS:Create(saveBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(240, 214, 175)}):Play()
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
        resetPosBtn.BackgroundColor3 = Color3.fromRGB(27, 30, 33)
        resetPosBtn.BorderSizePixel = 0
        resetPosBtn.Text = "RESET POSITIONS"
        resetPosBtn.TextColor3 = Color3.fromRGB(240, 214, 175)
        resetPosBtn.Font = Enum.Font.GothamBold
        resetPosBtn.TextSize = 13
        resetPosBtn.AutoButtonColor = false
        resetPosBtn.ZIndex = 8
        Instance.new("UICorner", resetPosBtn).CornerRadius = UDim.new(0, 6)
        local resetStroke = Instance.new("UIStroke", resetPosBtn)
        resetStroke.Color = getThemeColor()
        resetStroke.Thickness = 1.5
        resetStroke.Transparency = 0.4
        resetPosBtn.MouseEnter:Connect(function()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {BackgroundColor3 = getThemeColor()}):Play()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end)
        resetPosBtn.MouseLeave:Connect(function()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(27, 30, 33)}):Play()
            TS:Create(resetPosBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(240, 214, 175)}):Play()
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
        delBtn.BackgroundColor3 = Color3.fromRGB(27, 30, 33)
        delBtn.BorderSizePixel = 0
        delBtn.Text = "RESET ALL SETTINGS"
        delBtn.TextColor3 = Color3.fromRGB(170, 30, 50)
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 13
        delBtn.AutoButtonColor = false
        delBtn.ZIndex = 8
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 6)
        local delStroke = Instance.new("UIStroke", delBtn)
        delStroke.Color = Color3.fromRGB(200, 60, 80)
        delStroke.Thickness = 1.5
        delStroke.Transparency = 0.4
        delBtn.MouseEnter:Connect(function()
            TS:Create(delBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(200, 50, 70)}):Play()
            TS:Create(delBtn, TweenInfo.new(0.15), {TextColor3 = Color3.fromRGB(255,255,255)}):Play()
        end)
        delBtn.MouseLeave:Connect(function()
            TS:Create(delBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(27, 30, 33)}):Play()
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
                        delBtn.BackgroundColor3 = Color3.fromRGB(27, 30, 33)
                        delBtn.TextColor3 = Color3.fromRGB(170, 30, 50)
                    end
                end)
            elseif deleteState == 1 then
                delDebounce = true
                local invoked, success = pcall(resetToFactoryDefaults)
                success = invoked and success
                delBtn.Text = success and "SETTINGS RESET" or "ERROR"
                delBtn.BackgroundColor3 = Color3.fromRGB(27, 30, 33)
                delBtn.TextColor3 = Color3.fromRGB(170, 30, 50)
                deleteState = 0
                task.delay(1.5, function()
                    if delBtn and delBtn.Parent then
                        delBtn.Text = originalDeleteText
                        delBtn.BackgroundColor3 = Color3.fromRGB(27, 30, 33)
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
    addKeybindRow(keyPage, "Aimbot Bypass", KB.AutoBat)
    addKeybindRow(keyPage, "Bat Aimbot", KB.BatAimbot)
    addKeybindRow(keyPage, "TP Bate", KB.BatV2)

    mkSect(keyPage, "Utility")
    addKeybindRow(keyPage, "Drop Brainrot", KB.DropBrainrot)
    addKeybindRow(keyPage, "TP Down", KB.TPFloor)
    addKeybindRow(keyPage, "Hide GUI", KB.GuiHide)

    local spacer = Instance.new("Frame", keyPage)
    spacer.Size = UDim2.new(1, 0, 0, 16)
    spacer.BackgroundTransparency = 1
    spacer.LayoutOrder = getNextOrder(keyPage)
    spacer.ZIndex = 7

    local ACCENT_CYAN = Color3.fromRGB(150, 80, 255)
    local NH_LIGHT = Color3.fromRGB(186, 140, 255)
    local NH_DARK = Color3.fromRGB(88, 28, 176)
    pbFrame = MVPUI.new("Frame", gui, {
        Name = "ZenithAutoStealHud",
        Size = UDim2.fromOffset(344, 68),
        Position = UDim2.new(1, -362, 0, 16),
        BackgroundColor3 = Color3.fromRGB(24, 11, 46),
        BorderSizePixel = 0,
        Active = true,
        ZIndex = 50
    })
    MVPUI.hudScale = MVPUI.new("UIScale", pbFrame, {Scale = 1})
    MVPUI.round(pbFrame, 18)
    local hudStroke = MVPUI.stroke(pbFrame, ACCENT_CYAN, 0.5, 1.3)
    hudStroke.Name = "OuterStroke"
    local hudGlow = MVPUI.stroke(pbFrame, ACCENT_CYAN, 0.88, 5)
    hudGlow.Name = "SoftGlow"
    local hudVeil = MVPUI.new("Frame", pbFrame, {Name = "HudVeil", Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(24, 11, 46), BorderSizePixel = 0, ZIndex = 50})
    MVPUI.round(hudVeil, 18)
    MVPUI.new("UIGradient", hudVeil, {Rotation = 90, Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.25), NumberSequenceKeypoint.new(1, 0.55)})})

    -- Header da barra
    local title = MVPUI.text(pbFrame, "AUTO STEAL", UDim2.fromOffset(80, 7), UDim2.fromOffset(110, 16), 12, NH_LIGHT, 53)
    title.Font = Enum.Font.GothamBlack

    local modePill = MVPUI.new("Frame", pbFrame, {
        Name = "ModeBadge",
        Size = UDim2.fromOffset(46, 16),
        Position = UDim2.new(1, -58, 1, -22),
        BackgroundColor3 = Color3.fromRGB(42, 20, 78),
        BorderSizePixel = 0,
        ZIndex = 52
    })
    MVPUI.round(modePill, 8)
    MVPUI.stroke(modePill, ACCENT_CYAN, 0.6, 1)

    stealHud.mode = MVPUI.text(modePill, autoStealMode, UDim2.fromScale(0, 0), UDim2.fromScale(1, 1), 8, ACCENT_CYAN, 53)
    stealHud.mode.Name = "StealMode"
    stealHud.mode.TextXAlignment = Enum.TextXAlignment.Center
    stealHud.mode.Font = Enum.Font.GothamBold

    progressStatus = MVPUI.text(pbFrame, stealHud.state, UDim2.new(1, -160, 0, 7), UDim2.fromOffset(80, 16), 9, Color3.fromRGB(172, 152, 205), 53)
    progressStatus.Name = "StealProgressStatus"
    progressStatus.TextXAlignment = Enum.TextXAlignment.Right
    progressStatus.Font = Enum.Font.GothamBold

    progressPct = MVPUI.text(pbFrame, "0%", UDim2.fromOffset(284, 20), UDim2.fromOffset(48, 16), 13, NH_LIGHT, 54)
    progressPct.Name = "StealProgressPercent"
    progressPct.Font = Enum.Font.GothamBold
    progressPct.TextXAlignment = Enum.TextXAlignment.Right

    -- Track horizontal moderno e fino
    local track = MVPUI.new("Frame", pbFrame, {
        Name = "StealProgressTrack",
        Size = UDim2.fromOffset(196, 6),
        Position = UDim2.fromOffset(80, 28),
        BackgroundColor3 = Color3.fromRGB(20, 10, 40),
        BackgroundTransparency = 0.3,
        BorderSizePixel = 0,
        ClipsDescendants = true,
        ZIndex = 51
    })
    MVPUI.round(track, 3)
    MVPUI.stroke(track, NH_DARK, 0.5, 1)

    progressFill = MVPUI.new("Frame", track, {
        Name = "StealProgressFill",
        Size = UDim2.new(stealHud.value, 0, 1, 0),
        BackgroundColor3 = ACCENT_CYAN,
        BorderSizePixel = 0,
        ZIndex = 52
    })
    MVPUI.round(progressFill, 3)
    MVPUI.new("UIGradient", progressFill, {
        Color = ColorSequence.new(ACCENT_CYAN, NH_LIGHT)
    })

    -- Foto redonda + anel orbital de pontos (estilo Night Hub)
    stealHudHead = MVPUI.new("Frame", pbFrame, {Name = "ProgressHead", Size = UDim2.fromOffset(11, 11),
        Position = UDim2.fromOffset(75, 26), BackgroundColor3 = NH_LIGHT, BorderSizePixel = 0, ZIndex = 53})
    MVPUI.round(stealHudHead, 6)
    MVPUI.stroke(stealHudHead, ACCENT_CYAN, 0.35, 1)
    local photoRing = MVPUI.new("Frame", pbFrame, {Name = "PhotoRing", Size = UDim2.fromOffset(48, 48),
        Position = UDim2.fromOffset(12, 10), BackgroundColor3 = Color3.fromRGB(42, 20, 78),
        BorderSizePixel = 0, ZIndex = 52})
    MVPUI.round(photoRing, 24)
    MVPUI.stroke(photoRing, NH_DARK, 0.3, 1)
    local photoImg = MVPUI.new("ImageLabel", photoRing, {Name = "HudPhoto", Size = UDim2.fromScale(1, 1),
        Image = "rbxthumb://type=AvatarHeadShot&id=" .. LP.UserId .. "&w=150&h=150", ImageTransparency = 0.05,
        BackgroundTransparency = 1, ZIndex = 52})
    MVPUI.round(photoImg, 24)
    stealHudDots = {}
    for i = 1, 26 do
        local d = MVPUI.new("Frame", pbFrame, {Name = "OrbitDot", Size = UDim2.fromOffset(4, 4),
            BackgroundColor3 = Color3.fromRGB(118, 78, 178), BackgroundTransparency = 0.55,
            BorderSizePixel = 0, ZIndex = 52})
        MVPUI.round(d, 2)
        stealHudDots[i] = d
    end
    task.spawn(function()
        local angle = 0
        local conn
        conn = RunService.RenderStepped:Connect(function(dt)
            if not pbFrame or not pbFrame.Parent then if conn then conn:Disconnect() end return end
            angle = angle + dt * ((stealHud.state == "STEALING") and 1.7 or 0.3)
            if stealHudDots then
                for i, d in ipairs(stealHudDots) do
                    local a = angle + (i - 1) * (math.pi * 2 / #stealHudDots)
                    d.Position = UDim2.fromOffset(36 + math.cos(a) * 31 - 2, 34 + math.sin(a) * 31 - 2)
                end
            end
        end)
    end)
    stealHud.stats = MVPUI.text(pbFrame, stealHud.statsText, UDim2.fromOffset(80, 44), UDim2.fromOffset(190, 12), 8, Color3.fromRGB(172, 152, 205), 53)
    stealHud.stats.Name = "StealStats"
    stealHud.stats.Font = Enum.Font.GothamBold
    updateStealProgress(stealHud.value, stealHud.state)
    drag(pbFrame)
    MVPUI.fit()
    do
        local viewConnection
        local function followCamera()
            if viewConnection then viewConnection:Disconnect() end
            local cam = Workspace.CurrentCamera
            if cam then viewConnection = cam:GetPropertyChangedSignal("ViewportSize"):Connect(MVPUI.fit) end
            MVPUI.fit()
        end
        local cameraConnection = Workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(followCamera)
        followCamera()
        gui.Destroying:Connect(function()
            cameraConnection:Disconnect()
            if viewConnection then viewConnection:Disconnect() end
        end)
    end
    MVPUI.effectsLoop(gui)
    task.spawn(function() pcall(function() game:GetService("ContentProvider"):PreloadAsync({bg}) end) end)
end

do
    
    local function findGlobalFunc(...)
        local sources = {}
        pcall(function() if getgenv then table.insert(sources, getgenv()) end end)
        pcall(function() table.insert(sources, _G) end)
        pcall(function() if getfenv then table.insert(sources, getfenv()) end end)
        for i = 1, select("#", ...) do
            local name = select(i, ...)
            for _, env in ipairs(sources) do
                if type(env) == "table" then
                    local ok, val = pcall(function() return env[name] end)
                    if ok and type(val) == "function" then return val end
                end
            end
        end
        return nil
    end

    local setHiddenProp = findGlobalFunc(
        "sethiddenproperty", "set_hidden_property",
        "sethiddenprop", "set_hidden_prop"
    )
    local function setHidden(instance, prop, value)
        if not instance then return false end
        if setHiddenProp then
            local ok = pcall(setHiddenProp, instance, prop, value)
            if ok then return true end
        end
        return false
    end

    local TP = {
        enabled   = false,
        conn      = nil,
        char      = nil,
        h         = nil,
        hrp       = nil,
        cooldown  = false,
        
        batSpeed     = 40,   
        currentVersion = "V1", 
        silentAim    = false,
    }

    local function isBatTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local n = string.lower(tool.Name)
        return n:find("bat", 1, true) ~= nil or n:find("slap", 1, true) ~= nil
    end

    local function getBat()
        local c = LP.Character or TP.char
        if not c then return nil end
        local hum = c:FindFirstChildOfClass("Humanoid")
        for _, ch in ipairs(c:GetChildren()) do
            if isBatTool(ch) then return ch end
        end
        local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
        if bp then
            for _, ch in ipairs(bp:GetChildren()) do
                if isBatTool(ch) then
                    if hum then
                        pcall(function() hum:EquipTool(ch) end)
                    else
                        pcall(function() ch.Parent = c end)
                    end
                    return ch
                end
            end
        end
        return nil
    end

    local function getHitDelay()
        local t = 0.12 - ((TP.batSpeed - 10) / 70) * 0.105
        return math.clamp(t, 0.015, 0.12)
    end

    local function tryHit()
        if TP.cooldown then return end
        TP.cooldown = true
        pcall(function()
            local bat = getBat()
            if not bat then return end
            pcall(function() bat:Activate() end)
            for _, d in ipairs(bat:GetDescendants()) do
                if d:IsA("RemoteEvent") then pcall(function() d:FireServer() end) end
            end
            local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
            if ev then pcall(function() ev:FireServer() end) end
        end)
        task.delay(getHitDelay(), function() TP.cooldown = false end)
    end

    local function getClosest()
        local myHrp = TP.hrp
        if not myHrp or not myHrp.Parent then
            local c = LP.Character
            myHrp = c and c:FindFirstChild("HumanoidRootPart")
            TP.hrp = myHrp
        end
        if not myHrp then return nil, math.huge end
        local best, bestDist = nil, math.huge
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LP and p.Character then
                local hum = p.Character:FindFirstChildOfClass("Humanoid")
                local tr  = p.Character:FindFirstChild("HumanoidRootPart")
                if hum and hum.Health > 0 and tr and tr.Parent then
                    local d = (myHrp.Position - tr.Position).Magnitude
                    if d < bestDist then bestDist = d; best = p end
                end
            end
        end
        return best, bestDist
    end

    local function setupChar(newChar)
        TP.char = newChar
        task.wait(0.1)
        TP.h   = newChar:WaitForChild("Humanoid", 5)
        TP.hrp = newChar:WaitForChild("HumanoidRootPart", 5)
    end

    local function stopBatV2()
        TP.enabled = false
        if TP.conn then TP.conn:Disconnect(); TP.conn = nil end
        TP.char = nil; TP.h = nil; TP.hrp = nil
        TP.cooldown = false
        if _unsuppressBodyLock then pcall(_unsuppressBodyLock, true) end
    end

    local function startBatV2()
        if autoBatEnabled then disableAutoBat() end
        stopBatV2()
        TP.enabled = true
        TP.char = LP.Character
        if TP.char then
            TP.h   = TP.char:FindFirstChildOfClass("Humanoid")
            TP.hrp = TP.char:FindFirstChild("HumanoidRootPart")
        end
        if _suppressBodyLock then pcall(_suppressBodyLock) end

        TP.conn = RunService.Heartbeat:Connect(function()
            if not TP.enabled then return end
            local c = LP.Character
            if not c then return end
            TP.char = c
            TP.hrp  = c:FindFirstChild("HumanoidRootPart")
            TP.h    = c:FindFirstChildOfClass("Humanoid")
            if not TP.hrp or not TP.h or TP.h.Health <= 0 then return end

            local target, dist = getClosest()
            if not target or not target.Character then return end
            local tr = target.Character:FindFirstChild("HumanoidRootPart")
            if not tr then return end

            setHidden(TP.hrp, "PhysicsRepRootPart", tr)

            local targetPos = tr.Position + Vector3.new(0, 0.9, 0)
            if dist > 4 then
                TP.hrp.CFrame = CFrame.new(targetPos, tr.Position)
            elseif dist > 1.5 then
                TP.hrp.CFrame = CFrame.new(TP.hrp.Position:Lerp(targetPos, 0.55), tr.Position)
            else
                TP.hrp.CFrame = CFrame.new(targetPos, tr.Position)
            end

            pcall(function() TP.hrp.AssemblyAngularVelocity = Vector3.zero end)

            local cam = workspace.CurrentCamera
            if not TP.silentAim and cam then
                cam.CFrame = CFrame.new(cam.CFrame.Position, tr.Position + Vector3.new(0, 0.5, 0))
            end

            if TP.currentVersion == "V1" then
                tryHit()
            end
        end)
    end

    _G.__RivalHubStartBatV2 = startBatV2
    _G.__RivalHubStopBatV2  = stopBatV2
    _G.__RivalHubIsBatV2    = function() return TP.enabled == true end
    _G.__RivalHubBatV2      = TP

    LP.CharacterAdded:Connect(function(newChar)
        task.wait(0.5)
        setupChar(newChar)
        if TP.enabled then
            startBatV2()
        end
    end)
    if LP.Character then task.spawn(function() setupChar(LP.Character) end) end
end

-- ============================================================
-- INSTANT RESET (portado do Frame Reset / UNPATCHED)
-- Sem remote e sem hook: forca o reset pela fisica do personagem
-- (HipHeight gigante + CanCollide desligado ate cair/resetar,
-- com Health = 0 de reserva). Nao da kick igual o do Green.
-- ============================================================
local RESET_MAX_DURATION = 0.05
local _frameResetCooldown = false
local _frameResetThread = nil
local _frameResetStop = false

function zenithStopReset()
    _frameResetStop = true
    if _frameResetThread then
        pcall(function() task.cancel(_frameResetThread) end)
        _frameResetThread = nil
    end
    _frameResetCooldown = false
    local character = LP.Character
    if character then
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            pcall(function()
                humanoid.HipHeight = 2
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then rootPart.CanCollide = true end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end)
        end
    end
end

function zenithInstaReset()
    if _frameResetCooldown then return end
    _frameResetCooldown = true
    _frameResetStop = false

    local character = LP.Character
    if not character then
        _frameResetCooldown = false
        return
    end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then
        _frameResetCooldown = false
        return
    end

    local resetSuccessful = false
    local isRespawning = false

    _frameResetThread = task.spawn(function()
        local attempts = 0
        local maxAttempts = 40
        local originalHipHeight = humanoid.HipHeight

        while character and character.Parent and humanoid and humanoid.Health > 0 and not isRespawning and not _frameResetStop do
            if LP.Character ~= character then
                isRespawning = true
                break
            end

            pcall(function()
                humanoid.HipHeight = 1e30
                humanoid.AutoRotate = true
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.CanCollide = false
                end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = false
                    end
                end
            end)

            if not character or not character.Parent or not humanoid or humanoid.Health <= 0 or LP.Character ~= character then
                resetSuccessful = true
                break
            end

            attempts = attempts + 1
            if attempts >= maxAttempts then
                break
            end

            task.wait(RESET_MAX_DURATION)
        end

        if not resetSuccessful then
            if character and character.Parent and humanoid and humanoid.Health > 0 and not isRespawning then
                pcall(function()
                    humanoid.Health = 0
                end)
                task.wait(0.1)
                if not character.Parent or humanoid.Health <= 0 then
                    resetSuccessful = true
                end
            end
        end

        if not resetSuccessful and character and character.Parent and humanoid then
            pcall(function()
                humanoid.HipHeight = originalHipHeight
                local rootPart = character:FindFirstChild("HumanoidRootPart")
                if rootPart then
                    rootPart.CanCollide = true
                end
                for _, part in ipairs(character:GetChildren()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end)
        end

        _frameResetCooldown = false
        _frameResetThread = nil
        _frameResetStop = false
    end)
end

function createMobilePanel()
    local panel = Instance.new("ScreenGui")
    panel.Name = "ZenithHubMobilePanel"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    panel.IgnoreGuiInset = true
    panel.DisplayOrder = 40
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    local okPanel = pcall(function() panel.Parent = game:GetService("CoreGui") end)
    if not okPanel then panel.Parent = LP:WaitForChild("PlayerGui") end

    local BTN_W, BTN_H = 88, 76
    local buttons = {}
    local buttonNames = {"DropBR", "AutoLeft", "AutoBat", "AutoRight", "TpDown", "Carry", "Lagger1", "Lagger2", "BatV2", "BatAimbot", "InstaReset"}
    local buttonTexts = {"DROP\nBRAINROT", "AUTO\nLEFT", "AIMBOT\nBYPASS", "AUTO\nRIGHT", "TP\nDOWN", "CARRY\nSPEED", "LAGGER\nNORMAL", "LAGGER\nCARRY", "TP\nBAT", "BAT\nAIMBOT", "INSTANT\nRESET"}

    local function createButton(name, text, order, isToggle, callback)
        local btn = MVPUI.new("TextButton", panel, {Name = name, Size = UDim2.fromOffset(BTN_W, BTN_H),
            BackgroundColor3 = Color3.fromRGB(255, 255, 255), BorderSizePixel = 0, Text = "",
            AutoButtonColor = false, Active = true, ZIndex = 10})
        local saved = savedButtonPositions[name]
        local x, y = getDefaultButtonPosition(name)
        btn.Position = UDim2.fromOffset(saved and tonumber(saved.X) or x, saved and tonumber(saved.Y) or y)
        MVPUI.round(btn, mobileButtonStyle == "Circle" and 44 or 11)
        MVPUI.new("UIGradient", btn, {Name = "BtnGrad", Rotation = 90,
            Color = ColorSequence.new(Color3.fromRGB(63, 35, 105), Color3.fromRGB(15, 10, 27))})
        MVPUI.stroke(btn, Color3.fromRGB(139, 74, 215), 0.16, 1.4)
        local dot = MVPUI.new("Frame", btn, {Name = "StatusDot", Size = UDim2.fromOffset(4, 4),
            Position = UDim2.new(1, -10, 0, 10), BackgroundColor3 = Color3.fromRGB(65, 72, 81), BorderSizePixel = 0, ZIndex = 11})
        MVPUI.round(dot, 2)
        local label = MVPUI.text(btn, text, UDim2.fromOffset(3, 7), UDim2.new(1, -6, 0, 48), 7,
            Color3.fromRGB(232, 216, 255), 11)
        label.Name = "TextLabel"
        label.Font = Enum.Font.GothamBlack
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextWrapped = true
        label.TextTruncate = Enum.TextTruncate.None
        label.TextScaled = true
        label.TextYAlignment = Enum.TextYAlignment.Center
        local status = MVPUI.text(btn, "OFF", UDim2.fromOffset(6, 58), UDim2.new(1, -12, 0, 8), 6,
            Color3.fromRGB(167, 137, 198), 11)
        status.Name = "Status"
        status.TextXAlignment = Enum.TextXAlignment.Center
        local scale = MVPUI.new("UIScale", btn, {Scale = floatingButtonScale})
        table.insert(_floatingUIScales, scale)
        local active = false
        local function setActive(value)
            active = value == true
            btn:SetAttribute("MobActive", active)
            paintFloatingBtn(btn, active)
        end
        local pointer, dragStart, origin, moved = nil, nil, nil, 0
        local function clampPosition(pos)
            local camera = Workspace.CurrentCamera
            if not camera then return pos end
            local viewport = camera.ViewportSize
            local width = BTN_W * floatingButtonScale
            local height = BTN_H * floatingButtonScale
            return UDim2.fromOffset(_clamp(pos.X.Offset, 6, math.max(6, viewport.X - width - 6)),
                _clamp(pos.Y.Offset, 6, math.max(6, viewport.Y - height - 6)))
        end
        local function finish(input)
            if not pointer then return end
            if pointer.UserInputType == Enum.UserInputType.Touch and input ~= pointer then return end
            if pointer.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
            pointer = nil
            MVPUI.activeInput = nil
            _isDraggingButton = false
            TS:Create(scale, TweenInfo.new(0.12), {Scale = floatingButtonScale}):Play()
            if moved < 8 then
                local ok, err = pcall(callback, setActive, active)
                if not ok then warn("[Zenith Mobile Button] " .. name .. ": " .. tostring(err)) end
            elseif not uiLocked and not mobileButtonsLocked then
                savedButtonPositions[name] = {X = btn.Position.X.Offset, Y = btn.Position.Y.Offset}
            end
            paintFloatingBtn(btn, active)
            pcall(saveAllSettings)
        end
        btn.InputBegan:Connect(function(input)
            if MVPUI.activeInput then return end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            pointer, dragStart, origin, moved = input, input.Position, btn.Position, 0
            MVPUI.activeInput = input
            _isDraggingButton = true
            TS:Create(scale, TweenInfo.new(0.09), {Scale = floatingButtonScale * 0.95}):Play()
        end)
        local moveConn = UIS.InputChanged:Connect(function(input)
            if not pointer then return end
            if pointer.UserInputType == Enum.UserInputType.Touch then
                if input ~= pointer then return end
            elseif input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            local delta = input.Position - dragStart
            moved = math.max(moved, delta.Magnitude)
            if moved >= 8 and not uiLocked and not mobileButtonsLocked then
                btn.Position = clampPosition(UDim2.fromOffset(origin.X.Offset + delta.X, origin.Y.Offset + delta.Y))
            end
        end)
        local endConn = UIS.InputEnded:Connect(finish)
        btn.InputEnded:Connect(finish)
        btn.Destroying:Connect(function()
            moveConn:Disconnect(); endConn:Disconnect()
            if pointer then MVPUI.activeInput = nil; _isDraggingButton = false end
        end)
        btn.Position = clampPosition(btn.Position)
        buttons[name] = {btn = btn, setActive = setActive, label = label, clampPosition = clampPosition}
        setActive(false)
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
                    laggerCarryToggled = false; setActive(false)
                end
                refreshSpeedModeLabel()
                if _G.__RivalHubApplySpeedNow then pcall(_G.__RivalHubApplySpeedNow) end
            end
        elseif name == "BatAimbot" then
            callback = function(setActive)
                if not batAimbotEnabled then enableBatAimbot() else disableBatAimbot() end
                setActive(batAimbotEnabled)
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
        elseif name == "InstaReset" then
            callback = function(setActive)
                setActive(true)
                pcall(zenithInstaReset)
                task.delay(0.3, function() setActive(false) end)
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
        if name == "BatAimbot" then mobSetBatAimbot = setActive end
        if name == "InstaReset" then mobSetInstaReset = setActive end
    end

    if buttons.AutoBat and buttons.AutoBat.setActive then buttons.AutoBat.setActive(autoBatEnabled) end
    if buttons.BatAimbot and buttons.BatAimbot.setActive then buttons.BatAimbot.setActive(batAimbotEnabled) end
    if buttons.AutoLeft and buttons.AutoLeft.setActive then buttons.AutoLeft.setActive(autoLeftEnabled) end
    if buttons.AutoRight and buttons.AutoRight.setActive then buttons.AutoRight.setActive(autoRightEnabled) end
    if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(speedMode) end
    if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(laggerToggled) end
    if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(laggerCarryToggled) end
    if buttons.BatV2 and buttons.BatV2.setActive then
        buttons.BatV2.setActive(_G.__RivalHubIsBatV2 and _G.__RivalHubIsBatV2() or false)
    end

    local viewportConn
    if Workspace.CurrentCamera then
        viewportConn = Workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
            for _, entry in pairs(buttons) do entry.btn.Position = entry.clampPosition(entry.btn.Position) end
        end)
    end
    panel.Destroying:Connect(function() if viewportConn then viewportConn:Disconnect() end end)
    return panel
end

function updateUIFromLoaded()
    task.wait()
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_CARRY_SPEED) end
    if batSpeedBox then batSpeedBox.Text = tostring(AIMBOT_BYPASS_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    if dropModeBtnRef then dropModeBtnRef.Text = dropMode == 1 and "Fling" or "Jump Drop" end
    if bodyLockRangeBox then bodyLockRangeBox.Text = tostring(bodyLockRange) end
    if infJumpModeBtn then infJumpModeBtn.Text = string.upper(InfiniteJump.mode == "manual" and "manual" or "hold") end
    if autoStealModeBtn then autoStealModeBtn.Text = autoStealMode end
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
    if MVPUI.fit then MVPUI.fit() end
    if MVPUI.motorLabel then MVPUI.motorLabel.Text = useVenixCarryEngine and "Carry Boost" or "Direct" end
    if MVPUI.carrySetter then MVPUI.carrySetter(MVPVenixCarry.softStealEnabled) end
    if MVPUI.carrySpeedBox then MVPUI.carrySpeedBox.Text = tostring(MVPVenixCarry.softStealSpeed) end
    if MVPUI.carryRadiusBox then MVPUI.carryRadiusBox.Text = tostring(MVPVenixCarry.softStealRadius) end
    if MVPUI.effectsSetter then MVPUI.effectsSetter(MVPUI.effects) end
    if MVPUI.lockButtonsSetter then MVPUI.lockButtonsSetter(mobileButtonsLocked) end
    if MVPUI.mobileStyleLabel then MVPUI.mobileStyleLabel.Text = mobileButtonStyle == "Circle" and "Círculo" or "Normal" end
    applyMobileButtonStyle()

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
    if autoBatEnabled then autoBatEnabled = false; enableAutoBat() end
    if batAimbotEnabled then batAimbotEnabled = false; enableBatAimbot() end
    if batAimbotSpeedBox then batAimbotSpeedBox.Text = tostring(CLOUD_BAT_AIMBOT_SPEED) end
    if _G.ZenithCloudCustoms and _G.ZenithCloudCustoms.applyAll then pcall(_G.ZenithCloudCustoms.applyAll) end
    if setCloudTransparentVisual then setCloudTransparentVisual(_G.ZenithCloudTransparent == true) end
    if setCloudRainbowVisual then setCloudRainbowVisual(_G.ZenithCloudRainbow == true) end
    if setCloudNoSoundVisual then setCloudNoSoundVisual(_G.ZenithCloudBatNoSound == true) end

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
    if mobSetBatAimbot then mobSetBatAimbot(batAimbotEnabled) end
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
                errGui.Name = "ZenithHubBootErrors"
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
                Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 0)
                local stroke = Instance.new("UIStroke", frame)
                stroke.Color = Color3.fromRGB(255, 80, 90)
                stroke.Thickness = 1.5

                local title = Instance.new("TextLabel", frame)
                title.Size = UDim2.new(1, -20, 0, 24)
                title.Position = UDim2.new(0, 10, 0, 8)
                title.BackgroundTransparency = 1
                title.Text = "⚠ MVP: " .. #_bootErrors .. " sección(es) fallaron"
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
                Instance.new("UICorner", copyBtn).CornerRadius = UDim.new(0, 0)
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
                Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 0)
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

                local resumeSteal = CONFIG.AUTO_STEAL_ENABLED
                stopAutoSteal()
                CONFIG.AUTO_STEAL_ENABLED = resumeSteal
                if stopAutoLeft then stopAutoLeft() end
                if stopAutoRight then stopAutoRight() end
                if stopBatCounter then stopBatCounter() end
                        if stopMedusaCounter then stopMedusaCounter() end
                if stopUnwalk then stopUnwalk() end
                if stopDropBrainrot then stopDropBrainrot() end
                local resumeBypass = autoBatEnabled
                if autoBatEnabled and disableAutoBat then disableAutoBat() end
                local resumeBatAimbot = batAimbotEnabled
                if batAimbotEnabled and disableBatAimbot then disableBatAimbot() end
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
                if resumeBypass then enableAutoBat() end
                if resumeBatAimbot then enableBatAimbot() end
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
    if kbMatch(KB.BatAimbot, kc) then
        if not batAimbotEnabled then enableBatAimbot() else disableBatAimbot() end
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
            main.Visible = not main.Visible
        end
        return
    end
end)

do 
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

end

do
    local SwordPlayers = game:GetService("Players")
    local SwordLP = SwordPlayers.LocalPlayer

    -- Ambitious-style local cosmetic assets
    local SWORD_MESH = "rbxassetid://8827558932"
    local SWORD_TEXTURE = "rbxassetid://8827558969"
    local KATANA_MESH = "rbxassetid://13528902482"
    local KATANA_TEXTURE = "rbxassetid://13528902373"

    local function isBatTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local name = tool.Name:lower()
        return name:find("bat", 1, true) ~= nil or name:find("slap", 1, true) ~= nil
    end

    _G.ZenithSwordSkinMode = _G.ZenithSwordSkinMode or "Katana"
    local function applySwordVisual(tool)
        if not isBatTool(tool) then return end
        local handle = tool:FindFirstChild("Handle")
        if not handle then return end

        local oldReplica = handle:FindFirstChild("ShelSwordReplica")
        if oldReplica then oldReplica:Destroy() end
        if _G.ZenithSwordSkinMode == "Default" then
            pcall(function() handle.Transparency = 0 end)
            return
        end

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
        local mode = _G.ZenithSwordSkinMode
        if mode == "Sword" then
            mesh.MeshId = SWORD_MESH
            mesh.TextureId = SWORD_TEXTURE
            mesh.Scale = Vector3.new(0.2, 0.2, 0.2)
            part.CFrame = handle.CFrame * (CFrame.new(-0.05, -0.1, -0.12) * CFrame.Angles(math.rad(90), math.rad(180), math.rad(300)))
            part.Material = Enum.Material.SmoothPlastic
            part.Color = Color3.fromRGB(255, 255, 255)
        else
            mesh.MeshId = KATANA_MESH
            mesh.TextureId = KATANA_TEXTURE
            mesh.Scale = Vector3.new(1.4, 1.4, 1.4)
            part.CFrame = handle.CFrame * (CFrame.new(0, 0.6, 0) * CFrame.Angles(math.rad(270), math.rad(180), math.rad(180)))
            part.Material = Enum.Material.SmoothPlastic
            part.Color = Color3.fromRGB(255, 255, 255)
        end
        mesh.Parent = part
        local colorMode = _G.ZenithSwordColorMode or "RGB"
        local colors = {Blue=Color3.fromRGB(55,155,255), Green=Color3.fromRGB(65,255,125), Purple=Color3.fromRGB(190,85,255), Red=Color3.fromRGB(255,65,75), Gold=Color3.fromRGB(255,195,45), White=Color3.fromRGB(255,255,255)}
        if colorMode == "RGB" then
            part.Material = Enum.Material.Neon
            task.spawn(function()
                while part.Parent do
                    local c = Color3.fromHSV((os.clock() * 0.22) % 1, 0.9, 1)
                    part.Color = c
                    pcall(function() mesh.VertexColor = Vector3.new(c.R, c.G, c.B) end)
                    task.wait(0.06)
                end
            end)
        else
            local c = colors[colorMode] or Color3.fromRGB(255,255,255)
            part.Color = c
            part.Material = Enum.Material.Neon
            pcall(function() mesh.VertexColor = Vector3.new(c.R, c.G, c.B) end)
        end

        model.PrimaryPart = part
        model.Parent = handle
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = handle
        weld.Part1 = part
        weld.Parent = part

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

    _G.ShelSwordVisual = {
        apply = scanSwordTools,
        setMode = function(mode)
            if mode == "Default" or mode == "Sword" or mode == "Katana" then
                _G.ZenithSwordSkinMode = mode
            else
                _G.ZenithSwordSkinMode = "Default"
            end
            scanSwordTools()
        end,
        setColor = function(colorMode)
            _G.ZenithSwordColorMode = colorMode
            scanSwordTools()
        end,
        mesh = KATANA_MESH,
        texture = KATANA_TEXTURE,
        rainbow = true,
    }
end

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
        local originalVolumes = setmetatable({}, {__mode = "k"})

        local function hookSound(sound)
            if not sound:IsA("Sound") or sound.Name == "ShelCustomToolSound" or hookedSounds[sound] then return end
            hookedSounds[sound] = true
            originalVolumes[sound] = sound.Volume
            pcall(function() sound:SetAttribute("ZenithOriginalSoundVolume", sound.Volume) end)
            local triggering = false
            local function trigger()
                if not sound.Parent then return end
                if _G.ZenithCustomToolSoundsEnabled == false then
                    -- Desligado = som original do taco/medusa, sem substituir nem mutar.
                    pcall(function()
                        sound.Volume = originalVolumes[sound] or 1
                    end)
                    return
                end
                if triggering then return end
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

do
    local SkinPlayers = game:GetService("Players")
    local SkinLP = SkinPlayers.LocalPlayer

    local function isMedusaSkinTool(obj)
        if not obj or not obj:IsA("Tool") then return false end
        local n = obj.Name:lower()
        return n:find("medusa", 1, true) ~= nil or n:find("head", 1, true) ~= nil
            or n:find("stone", 1, true) ~= nil
    end

    _G.ZenithMedusaSkinMode = _G.ZenithMedusaSkinMode or "Bomb"
    local function clearMedusaSkin(tool)
        if not tool then return end
        local folder = tool:FindFirstChild("ShelMedusaBombSkin")
        if folder then folder:Destroy() end
        tool:SetAttribute("ShelMedusaBombSkin", nil)
        for _, obj in ipairs(tool:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name ~= "BombBody" and obj.Name ~= "BombBand" and obj.Name ~= "BombCore" and obj.Name ~= "BombCap" and obj.Name ~= "BombFuse" and obj.Name ~= "BombSpark" then
                pcall(function() obj.LocalTransparencyModifier = 0 end)
            end
        end
    end
    local function applyMedusaSkin(tool)
        if not isMedusaSkinTool(tool) then return end
        if _G.ZenithMedusaSkinMode == "Default" then
            clearMedusaSkin(tool)
            return
        end
        if tool:GetAttribute("ShelMedusaBombSkin") then clearMedusaSkin(tool) end
        local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart", true)
        if not handle or not handle:IsA("BasePart") then return end
        tool:SetAttribute("ShelMedusaBombSkin", true)

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

        local selected = _G.ZenithMedusaSkinMode
        if selected == "Skull" or selected == "Golden Desert Eagle" then
            local replica = Instance.new("Model")
            replica.Name = "AmbitiousMedusaReplica"
            replica.Parent = bomb
            local part = Instance.new("Part")
            part.Name = "MainPart"; part.Size = Vector3.new(1,1,1); part.Transparency = 0
            part.CanCollide = false; part.CanTouch = false; part.CanQuery = false; part.Massless = true; part.Anchored = false; part.Parent = replica
            local mesh = Instance.new("SpecialMesh")
            mesh.MeshType = Enum.MeshType.FileMesh
            if selected == "Skull" then
                mesh.MeshId = "rbxassetid://2050312704"; mesh.TextureId = "rbxassetid://2050313393"
                mesh.Scale = Vector3.new(1,1,1)
                part.CFrame = handle.CFrame * (CFrame.new(0,0.65,-0.4) * CFrame.Angles(math.rad(330),0,0))
            else
                mesh.MeshId = "rbxassetid://430251413"; mesh.TextureId = "rbxassetid://435840335"
                mesh.Scale = Vector3.new(0.01,0.01,0.01)
                part.CFrame = handle.CFrame * (CFrame.new(0,0,-0.8) * CFrame.Angles(math.rad(330),math.rad(180),0))
            end
            mesh.Parent = part
            local weld = Instance.new("WeldConstraint"); weld.Part0 = handle; weld.Part1 = part; weld.Parent = part
        else
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
        end

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
        setMode = function(mode)
            local valid = {Default=true, Bomb=true, Skull=true, ["Golden Desert Eagle"]=true}
            _G.ZenithMedusaSkinMode = valid[mode] and mode or "Default"
            local backpack = SkinLP:FindFirstChildOfClass("Backpack")
            for _, container in ipairs({backpack, SkinLP.Character}) do
                if container then
                    for _, tool in ipairs(container:GetChildren()) do
                        if isMedusaSkinTool(tool) then
                            if _G.ZenithMedusaSkinMode == "Default" then clearMedusaSkin(tool) else applyMedusaSkin(tool) end
                        end
                    end
                end
            end
        end,
    }
end


-- =====================================================================
-- CLOUD HUB PORT -> Zenith: Bat Custom (espadas/foices), Medusa Custom,
-- Bat+Medusa Transparent e Rainbow. Catalogos/IDs/grips/sons copiados
-- da source importada. A "Minecraft diamond sword" usa os MESMOS
-- mesh/texture do modo "Sword" que o Zenith ja tinha, por isso nao foi
-- duplicada aqui. Visual apenas local (cosmetico).
-- =====================================================================
do
    if _G.__ZenithCloudCustomsLoaded then return end
    _G.__ZenithCloudCustomsLoaded = true
    local CloudPlayers = game:GetService("Players")
    local CloudLP = CloudPlayers.LocalPlayer
    local CloudRun = game:GetService("RunService")
    if not CloudLP then return end

    local BAT_CUSTOMS = {
        scythe_bear  = {name = "Scythe with Bear", id = 110490360258502, grip = CFrame.new(0, -0.05, -1.35) * CFrame.Angles(math.rad(20), math.rad(90), math.rad(0)), swingSound = 93468677306378},
        scythe_white = {name = "Scythe White", id = 103142722866846, grip = CFrame.new(0, -0.05, -1.35) * CFrame.Angles(math.rad(-12), math.rad(-88), math.rad(325)), swingSound = 83288683119028},
        black_hammer = {name = "Black Hammer", id = 114452163024876, grip = CFrame.Angles(math.rad(-87), math.rad(170), 0), swingSound = 85272437084466},
    }
    local MEDUSA_CUSTOMS = {
        evil        = {name = "Evil Skull", id = 7855324601, grip = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(180), 0)},
        ominous     = {name = "Ominous Skull", id = 11983700343, grip = CFrame.new(0, 0, 0), swingSound = 129030117458818, soundCooldown = 25},
        cone        = {name = "Skull Cone", id = 88582363429320, grip = CFrame.new(0, 0, 0) * CFrame.Angles(0, math.rad(180), 0)},
        kamehameha  = {name = "Kamehameha", id = 134121959707227, grip = CFrame.new(0, 0, 0), swingSound = 138517216516736, soundCooldown = 25},
        fireball    = {name = "Fire Ball", id = 83021250, grip = CFrame.new(0, 0, 0), swingSound = 90228815682492, soundCooldown = 25},
        rasengan    = {name = "Rasengan", id = 131058442581341, grip = CFrame.new(0, 0, 0), swingSound = 125531138027447, soundCooldown = 25},
    }

    local templates = {}   -- key -> Model pronto (ou false se falhou)
    local visuals = setmetatable({}, {__mode = "k"})    -- tool -> Model visual
    local visualKey = setmetatable({}, {__mode = "k"})  -- tool -> key aplicada
    local originals = setmetatable({}, {__mode = "k"})  -- part -> {T=, L=, C=, Tex=}
    local hooked = setmetatable({}, {__mode = "k"})
    local lastMedusaSoundAt = 0

    local function isBatTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local n = tool.Name:lower()
        return n:find("bat", 1, true) ~= nil or n:find("slap", 1, true) ~= nil
    end
    local function isMedusaTool(tool)
        if not tool or not tool:IsA("Tool") then return false end
        local n = tool.Name:lower()
        return n:find("medusa", 1, true) ~= nil or n:find("head", 1, true) ~= nil or n:find("stone", 1, true) ~= nil
    end
    local function collectTools()
        local bats, meds, seen = {}, {}, {}
        local containers = {CloudLP.Character, CloudLP:FindFirstChildOfClass("Backpack")}
        local folder = workspace:FindFirstChild(CloudLP.Name)
        if folder then table.insert(containers, folder) end
        for _, container in ipairs(containers) do
            if container then
                for _, child in ipairs(container:GetChildren()) do
                    if child:IsA("Tool") and not seen[child] then
                        seen[child] = true
                        if isBatTool(child) then table.insert(bats, child)
                        elseif isMedusaTool(child) then table.insert(meds, child) end
                    end
                end
            end
        end
        return bats, meds
    end
    local function rememberPart(part)
        if originals[part] == nil then
            originals[part] = {T = part.Transparency, L = part.LocalTransparencyModifier, C = part.Color,
                Tex = (part:IsA("MeshPart") and part.TextureID) or nil}
        end
    end
    local function restorePart(part)
        local old = originals[part]
        if old and part and part.Parent then
            pcall(function()
                part.Transparency = old.T; part.LocalTransparencyModifier = old.L; part.Color = old.C
                if old.Tex ~= nil and part:IsA("MeshPart") then part.TextureID = old.Tex end
            end)
        end
        originals[part] = nil
    end
    local function resolveTemplate(kind, key, entry)
        local cacheKey = kind .. ":" .. key
        if templates[cacheKey] ~= nil then return templates[cacheKey] or nil end
        local root = nil
        pcall(function()
            if game.GetObjects then
                local objs = game:GetObjects("rbxassetid://" .. tostring(entry.id))
                if objs and objs[1] then root = objs[1] end
            end
        end)
        if not root then
            pcall(function()
                root = game:GetService("InsertService"):LoadAsset(entry.id)
            end)
        end
        if not root then templates[cacheKey] = false; return nil end
        local parts = {}
        if root:IsA("BasePart") then table.insert(parts, root) end
        for _, d in ipairs(root:GetDescendants()) do
            if d:IsA("BasePart") then table.insert(parts, d) end
        end
        if #parts == 0 then templates[cacheKey] = false; return nil end
        local primary = root:FindFirstChild("Handle", true)
        if not (primary and primary:IsA("BasePart")) then primary = parts[1] end
        local model = Instance.new("Model")
        model.Name = "_ZenithCloudCustomTemplate"
        local primaryCFrame = primary.CFrame
        for _, part in ipairs(parts) do
            local rel = primaryCFrame:ToObjectSpace(part.CFrame)
            part.Parent = model
            part.CFrame = rel
            part.Anchored = false; part.CanCollide = false; part.CanTouch = false; part.CanQuery = false
            part.Massless = true; part.CastShadow = false
            if part ~= primary then
                local weld = Instance.new("WeldConstraint")
                weld.Part0 = primary; weld.Part1 = part; weld.Parent = part
            end
        end
        for _, d in ipairs(model:GetDescendants()) do
            if d:IsA("Script") or d:IsA("LocalScript") then d:Destroy() end
        end
        model.PrimaryPart = primary
        templates[cacheKey] = model
        return model
    end
    local function clearVisual(tool)
        local vis = visuals[tool]
        if vis and vis.Parent then vis:Destroy() end
        visuals[tool] = nil; visualKey[tool] = nil
        if tool then
            for _, d in ipairs(tool:GetDescendants()) do
                if d:IsA("BasePart") then restorePart(d) end
            end
            local handle = tool:FindFirstChild("Handle")
            if handle then restorePart(handle) end
        end
    end
    local function playSwing(tool, entry, isMedusa)
        if not entry or not entry.swingSound then return end
        if not isMedusa and _G.ZenithCloudBatNoSound then return end
        local now = os.clock()
        if isMedusa and entry.soundCooldown and (now - lastMedusaSoundAt) < entry.soundCooldown then return end
        local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart", true)
        if not handle then return end
        local sound = handle:FindFirstChild("_ZenithCloudCustomSwingSound")
        if not sound then
            sound = Instance.new("Sound")
            sound.Name = "_ZenithCloudCustomSwingSound"; sound.Volume = 1; sound.Looped = false
            sound.Parent = handle
        end
        sound.SoundId = "rbxassetid://" .. tostring(entry.swingSound)
        pcall(function() sound:Stop(); sound.TimePosition = 0; sound:Play() end)
        if isMedusa then lastMedusaSoundAt = now end
    end
    local function hookSwing(tool, kind)
        if hooked[tool] then return end
        hooked[tool] = true
        tool.Activated:Connect(function()
            if kind == "bat" then
                local entry = BAT_CUSTOMS[_G.ZenithCloudBatCustomKey or "off"]
                if entry and visuals[tool] then playSwing(tool, entry, false) end
            else
                local entry = MEDUSA_CUSTOMS[_G.ZenithCloudMedusaCustomKey or "off"]
                if entry and visuals[tool] then playSwing(tool, entry, true) end
            end
        end)
    end
    local function applyCustom(tool, kind, key, entry)
        if not tool or not entry then return end
        if visuals[tool] and visualKey[tool] == key and visuals[tool].Parent then return end
        clearVisual(tool)
        local template = resolveTemplate(kind, key, entry)
        if not template then return end
        local handle = tool:FindFirstChild("Handle") or tool:FindFirstChildWhichIsA("BasePart", true)
        if not handle or not handle:IsA("BasePart") then return end
        for _, d in ipairs(tool:GetDescendants()) do
            if d:IsA("BasePart") then rememberPart(d); pcall(function() d.LocalTransparencyModifier = 1 end) end
        end
        rememberPart(handle); pcall(function() handle.Transparency = 1 end)
        local vis = template:Clone()
        vis.Name = "_ZenithCloudCustomVisual"
        vis.Parent = tool
        local primary = vis.PrimaryPart or vis:FindFirstChildWhichIsA("BasePart", true)
        if primary then
            local rels = {}
            for _, p in ipairs(vis:GetDescendants()) do
                if p:IsA("BasePart") then rels[p] = primary.CFrame:ToObjectSpace(p.CFrame) end
            end
            primary.CFrame = handle.CFrame * entry.grip
            for p, rel in pairs(rels) do if p ~= primary then p.CFrame = primary.CFrame * rel end end
            local weld = Instance.new("WeldConstraint")
            weld.Part0 = handle; weld.Part1 = primary; weld.Parent = primary
        end
        visuals[tool] = vis; visualKey[tool] = key
        hookSwing(tool, kind)
    end
    local rainbowConn, rainbowHue = nil, 0
    local function paintRainbow(tool, color)
        if not tool then return end
        local hl = tool:FindFirstChild("_ZenithCloudRainbowHL")
        if not hl then
            hl = Instance.new("Highlight")
            hl.Name = "_ZenithCloudRainbowHL"; hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            hl.FillTransparency = 0.4; hl.OutlineTransparency = 0.15; hl.Parent = tool
        end
        pcall(function() hl.FillColor = color; hl.OutlineColor = color end)
        for _, d in ipairs(tool:GetDescendants()) do
            if d:IsA("BasePart") and not d:IsDescendantOf(visuals[tool]) then
                rememberPart(d)
                pcall(function()
                    if d:IsA("MeshPart") and d.TextureID ~= "" then d.TextureID = "" end
                    d.Color = color
                end)
            end
        end
    end
    local function applyAll()
        local bats, meds = collectTools()
        local batKey = _G.ZenithCloudBatCustomKey or "off"
        local batEntry = BAT_CUSTOMS[batKey]
        for _, tool in ipairs(bats) do
            if batEntry then applyCustom(tool, "bat", batKey, batEntry) else clearVisual(tool) end
        end
        local medKey = _G.ZenithCloudMedusaCustomKey or "off"
        local medEntry = MEDUSA_CUSTOMS[medKey]
        for _, tool in ipairs(meds) do
            if medEntry then applyCustom(tool, "medusa", medKey, medEntry) else clearVisual(tool) end
        end
        -- se um custom esta ativo, garante que a tool original continua escondida
        -- (restaurar Transparent/Rainbow nao pode trazer o bat/medusa original de volta)
        for _, list in ipairs({bats, meds}) do
            for _, tool in ipairs(list) do
                local vis = visuals[tool]
                if vis and vis.Parent then
                    local handle = tool:FindFirstChild("Handle")
                    if handle then pcall(function() handle.Transparency = 1 end) end
                    for _, d in ipairs(tool:GetDescendants()) do
                        if d:IsA("BasePart") and not d:IsDescendantOf(vis) then
                            pcall(function() d.LocalTransparencyModifier = 1 end)
                        end
                    end
                end
            end
        end
        if _G.ZenithCloudTransparent then
            for _, list in ipairs({bats, meds}) do
                for _, tool in ipairs(list) do
                    for _, d in ipairs(tool:GetDescendants()) do
                        if (d:IsA("BasePart") or d:IsA("Decal") or d:IsA("Texture")) and not (visuals[tool] and d:IsDescendantOf(visuals[tool])) then
                            if d:IsA("BasePart") then rememberPart(d) end
                            pcall(function() d.Transparency = math.max(d.Transparency, 0.65) end)
                        end
                    end
                end
            end
        end
    end
    local api = {}
    api.setBatCustom = function(key)
        _G.ZenithCloudBatCustomKey = BAT_CUSTOMS[key] and key or "off"
        if BAT_CUSTOMS[key] then
            _G.ZenithSwordSkinMode = "Default"
            if _G.ShelSwordVisual and _G.ShelSwordVisual.setMode then pcall(_G.ShelSwordVisual.setMode, "Default") end
            templates["bat:" .. key] = nil
        end
        applyAll()
    end
    api.setMedusaCustom = function(key)
        _G.ZenithCloudMedusaCustomKey = MEDUSA_CUSTOMS[key] and key or "off"
        if MEDUSA_CUSTOMS[key] then
            _G.ZenithMedusaSkinMode = "Default"
            if _G.ShelMedusaSkin and _G.ShelMedusaSkin.setMode then pcall(_G.ShelMedusaSkin.setMode, "Default") end
            templates["medusa:" .. key] = nil
        end
        applyAll()
    end
    api.setTransparent = function(on)
        _G.ZenithCloudTransparent = on == true
        if not _G.ZenithCloudTransparent then
            local bats, meds = collectTools()
            for _, list in ipairs({bats, meds}) do
                for _, tool in ipairs(list) do
                    for _, d in ipairs(tool:GetDescendants()) do
                        if d:IsA("BasePart") then restorePart(d) end
                    end
                end
            end
        end
        applyAll()
    end
    api.setRainbow = function(on)
        _G.ZenithCloudRainbow = on == true
        if rainbowConn then rainbowConn:Disconnect(); rainbowConn = nil end
        if _G.ZenithCloudRainbow then
            rainbowConn = CloudRun.Heartbeat:Connect(function(dt)
                rainbowHue = (rainbowHue + (dt or 0.016) * 0.45) % 1
                local color = Color3.fromHSV(rainbowHue, 1, 1)
                local bats, meds = collectTools()
                for _, tool in ipairs(bats) do paintRainbow(tool, color) end
                for _, tool in ipairs(meds) do paintRainbow(tool, color) end
            end)
        else
            local bats, meds = collectTools()
            for _, list in ipairs({bats, meds}) do
                for _, tool in ipairs(list) do
                    local hl = tool:FindFirstChild("_ZenithCloudRainbowHL")
                    if hl then hl:Destroy() end
                    for _, d in ipairs(tool:GetDescendants()) do
                        if d:IsA("BasePart") then restorePart(d) end
                    end
                end
            end
            applyAll()
        end
    end
    api.setNoSound = function(on) _G.ZenithCloudBatNoSound = on == true end
    api.applyAll = function()
        applyAll()
        if _G.ZenithCloudRainbow then api.setRainbow(true) end
    end
    _G.ZenithCloudCustoms = api

    CloudLP.CharacterAdded:Connect(function()
        task.wait(0.5); applyAll()
        if _G.ZenithCloudRainbow then api.setRainbow(true) end
    end)
    task.spawn(function()
        while true do
            pcall(applyAll)
            task.wait(0.5)
        end
    end)
    applyAll()
    if _G.ZenithCloudRainbow then api.setRainbow(true) end
end

