--[[fmwm.1.ZmZhLTk0YjlmNmM0LWUzODUtNDMyYy04MDU5LTZlYTQxZGMzMTU5NS0wYmEyMmJhMXw5NGI5ZjZjNC1lMzg1LTQzMmMtODA1OS02ZWE0MWRjMzE1OTV8MDkwY2QxYmQ4MmVkYzQxN2Y2MWRhNmZiZWRkYTlhM2F8MTc5MTUxMTA3Nw.0c7c24e96ba9]]
-- thin prelude
pcall(function()
  -- prelude
  pcall(function() if _G._FAULMOR_DIAG then print('DIAG: PRELUDE_START') end end)
  local _lO0lO = ""
  local _lI1lI = "a7905c59-8e98-481f-85e2-04cde95a454c"
  local _lOo0O = nil
  local _l1i1l = nil
  local _l0IiI = "free"
  local _l1oO0 = nil
  local _lI0o1 = 144
  local _l0l0l = "Delta"
  local _lI1i1 = false
  local function _fm_hb_env()
    local ok, e = pcall(function() return type(getgenv) == 'function' and getgenv() end)
    if ok and type(e) == 'table' then return e end
    local ok2, e2 = pcall(function() return type(getfenv) == 'function' and getfenv(0) end)
    if ok2 and type(e2) == 'table' then return e2 end
    return _G
  end
  do
    local env=nil do local gg=nil local ok,g=pcall(function() return type(getgenv) == 'function' and getgenv() end) if ok and type(g)=='table' then gg=g end local function tr(l) if type(getfenv) == 'function' then local ok2,e=pcall(getfenv,l) if ok2 and type(e)=='table' then return e end end end env=tr(2) or tr(3) or gg or tr(1) or tr(0) or _G end
    if type(env) == 'table' then
      env.LRM_ScriptKey = _lO0lO
      env.LRM_HWID = _lI1lI
      env.LRM_LinkedDiscordID = _lOo0O
      env.LRM_LinkedDiscordName = _l1i1l
      env.LRM_KeyType = _l0IiI
      env.LRM_KeyExpiresAt = _l1oO0
      env.LRM_TotalExecutions = _lI0o1
      env.LRM_Executor = _l0l0l
      env.LRM_IsPremium = _lI1i1
      local _spawn = (type(task) == 'table' and type(task.spawn) == 'function' and task.spawn) or (type(coroutine) == 'table' and type(coroutine.create) == 'function' and type(coroutine.resume) == 'function' and function(f) local co=coroutine.create(f); pcall(coroutine.resume, co) end)
      local _wait = (type(task) == 'table' and type(task.wait) == 'function' and task.wait) or (type(wait) == 'function' and wait)
      local _unpack = (type(table) == 'table' and type(table.unpack) == 'function' and table.unpack) or (type(unpack) == 'function' and unpack)
      if _spawn then env.LRM_Spawn = _spawn end
      if _wait then env.LRM_Wait = _wait end
      if _unpack then env.LRM_Unpack = _unpack end
    end
  end
  -- session
  local _FM_SESS = { t = "st.1.fa4c9062-162f-47da-83e3-1cfe6d7b85d8.94b9f6c4-e385-432c-8059-6ea41dc31595.090cd1bd82edc417f61da6fbedda9a3a.0.1791511077.1791511377.1.ee7af447c64628d4.d0840e4510bf550641dbb70c189f40eb9c157e741ac3b4d71a319d8351aa712b", e = 1791511377, u = "https://faulmor.site/api/public/session/refresh", h = _lI1lI }
  local _fm_spawn = (type(task) == 'table' and type(task.spawn) == 'function' and task.spawn) or (type(coroutine) == 'table' and type(coroutine.create) == 'function' and type(coroutine.resume) == 'function' and function(f) local co=coroutine.create(f); pcall(coroutine.resume, co) end)
  local _fm_wait = (type(task) == 'table' and type(task.wait) == 'function' and task.wait) or (type(wait) == 'function' and wait)
  if _fm_spawn and _fm_wait then
    pcall(function() if _G._FAULMOR_DIAG then print('DIAG: PHASE=PRELUDE_INIT _fm_spawn=' .. type(_fm_spawn) .. ' _fm_wait=' .. type(_fm_wait)) end end)
    pcall(_fm_spawn, function()
    local hs; local ok, svc = pcall(function() return type(game) == 'table' and type(game.GetService) == 'function' and game:GetService('HttpService') end); if ok and svc then hs = svc end
    if not hs then return end
    while true do
      local now = os.time()
      local left = _FM_SESS.e - now
      if left <= 30 then
        local body = '{"token":"' .. _FM_SESS.t .. '","hwid":"' .. _FM_SESS.h .. '","script_key":"' .. _lO0lO .. '"}'
        local ok2, resp = pcall(hs.PostAsync, hs, _FM_SESS.u, body, 2, 'application/json')
        if ok2 and type(resp) == 'string' then
          local nt = resp:match('"token"%s*:%s*"([^"]+)"')
          local ne = tonumber(resp:match('"exp"%s*:%s*(%d+)'))
          if nt and ne then _FM_SESS.t = nt; _FM_SESS.e = ne end
        end
        _fm_wait(15)
      else
        _fm_wait(math.max(5, left - 30))
      end
    end
  end)
  end
  do local _e=_fm_hb_env(); if type(_e)=='table' then local _old=_e["__fmbh"]; if type(_old)=='table' then _old.enabled=false end; _e["__fmbh"]=nil end end
  -- end prelude

end)
--[[
    RAPTURE DUEL - Script completo v8.0.5
    CAMBIOS v8.0.5:
    - ❌ Steal Mode eliminado (siempre V2 bloqueado)
    - ✅ Barra de Steal con imagen de fondo 109443898978389
    - ✅ Fondo negro INVISIBLE
    - ✅ Sin Discord en la barra de steal
    - ✅ FPS + MS grandes (TextSize 22)
    - ✅ Barra gris + rosa neón
]]

skipIntroEnabled = true
if _G.RaptureDuelRunning then return end
_G.RaptureDuelRunning = true

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TS = game:GetService("TweenService")
local Lighting = game:GetService("Lighting")
local HS = game:GetService("HttpService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local CoreGui = game:GetService("CoreGui")
local SoundService = game:GetService("SoundService")
local LP = Players.LocalPlayer
local camera = workspace.CurrentCamera

local _tick     = tick
local _clamp    = math.clamp
local _floor    = math.floor
local _abs      = math.abs
local _huge     = math.huge
local _sqrt     = math.sqrt
local _V3new    = Vector3.new
local _V3zero   = Vector3.zero
local _CFnew    = CFrame.new
local _CFlookAt = CFrame.lookAt

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
CONFIG_FILE = "RaptureDuel.json"
_isDraggingButton = false

local PASTEL_PINK  = Color3.fromRGB(255, 170, 220)
local NEON_PINK    = Color3.fromRGB(255, 20, 147)
local BLACK_BG     = Color3.fromRGB(0, 0, 0)
local BLACK_STROKE = Color3.fromRGB(0, 0, 0)
local INACTIVE_BG  = Color3.fromRGB(0, 0, 0)
local INACTIVE_TXT = Color3.fromRGB(255, 255, 255)
local ACTIVE_TXT   = Color3.fromRGB(255, 255, 255)
local GRAY_TRACK   = Color3.fromRGB(120, 120, 130)

local BTN_STROKE_THICKNESS = 2
local BTN_STROKE_TRANSPARENCY = 0
local BTN_BG_DARK = Color3.fromRGB(0, 0, 0)

aimbotMode = "V1"
aimbotModeSetVisual = nil
antiRagSetVisual = nil

customSoundsEnabled     = false
setCustomSoundsVisual   = nil

batBypassEnabled = batBypassEnabled or false
batBypassSetVisual = nil
batBypassFloatingButton = nil
batBypassFloatingPos = nil

antiDieEnabled = antiDieEnabled or false
antiFlingEnabled = antiFlingEnabled or false
setAntiDieVisual = nil
setAntiFlingVisual = nil

_G.RaptureToolAssets = {}

stealMode = "V2"
local STEAL_MODE_LOCKED = "V2"
V2_STOP_PERCENT = 70
NORMAL_STOP_PERCENT = 90

backgroundIndex = 1
backgroundImages = {
    "99136015050161",
    "73857705647948", "86237559415852", "81474116937197",
    "86668822094069", "108384375206363", "86791880986403", "126414648469223",
    "77785523954153", "122815453745063", "77581705786454",
    "86508089972764", "99747773532595", "139362780018712",
    "81570223894096", "94047991986188", "118783198922289",
    "101833990704596", "109527418380162",
}

backgroundImageTransparency = 0
floatingButtonScale = 1
progressBarScale = 1
_floatingUIScales = {}

titleLbl = nil
miniBtn = nil
bestScripLabel = nil
raptureLinkLabel = nil
skipIntroToggleSet = nil

local PRINTED_SOUND_PACKS = {
    V1 = {
        toggle = { "rbxassetid://6042053626", "rbxassetid://3398620867", "rbxassetid://255881176", "rbxassetid://12222208" },
        tab    = { "rbxassetid://3398620867", "rbxassetid://6042053626", "rbxassetid://12222200" },
        pitch = 1, volume = 2,
    },
    V2 = {
        toggle = { "rbxassetid://9113822143", "rbxassetid://6895079853", "rbxassetid://12222208" },
        tab    = { "rbxassetid://9113821597", "rbxassetid://6895079733", "rbxassetid://12222200" },
        pitch = 1.15, volume = 1.6,
    },
}
currentSoundPack = "V1"
local _soundCache = {}

local function getMenuSound(idList)
    local key = table.concat(idList, "|")
    local cached = _soundCache[key]
    if cached and cached.Parent then return cached end
    for _, id in ipairs(idList) do
        local ok, sound = pcall(function()
            local s = Instance.new("Sound")
            s.Name = "RaptureMenuSound"
            s.SoundId = id
            s.Parent = SoundService
            pcall(function() task.wait() end)
            return s
        end)
        if ok and sound then
            if sound.IsLoaded then _soundCache[key] = sound return sound end
            pcall(function() sound:Destroy() end)
        end
    end
    return nil
end

local function playMenuSound(kind)
    pcall(function()
        local pack = PRINTED_SOUND_PACKS[currentSoundPack] or PRINTED_SOUND_PACKS.V1
        local sound = getMenuSound(kind == "tab" and pack.tab or pack.toggle)
        if not sound then return end
        local clone = sound:Clone()
        clone.Volume = pack.volume or 1.5
        local pitch = pack.pitch or 1
        if kind == "tab" then pitch = pitch * 0.94 end
        clone.PlaybackSpeed = pitch
        clone.Parent = SoundService
        clone:Play()
        task.delay(3, function() pcall(function() clone:Destroy() end) end)
    end)
end

function getThemeColor() return PASTEL_PINK end

local _lastThemeUpdate = 0
local _lastThemeColor = nil

_G._RaptureDynamicSliders = _G._RaptureDynamicSliders or {}

function _RaptureApplyThemeToSliders()
    for _, entry in ipairs(_G._RaptureDynamicSliders) do
        if entry and entry.applyThemeColor then
            pcall(entry.applyThemeColor, PASTEL_PINK)
        end
    end
end

function updateAllUIThemeColors(color)
    color = color or PASTEL_PINK
    local now = _tick()
    if color == _lastThemeColor and now - _lastThemeUpdate < 0.05 then return end
    _lastThemeUpdate = now
    _lastThemeColor = color

    if progressFill then progressFill.BackgroundColor3 = NEON_PINK end
    if pbFrame then
        local border = pbFrame:FindFirstChildOfClass("UIStroke")
        if border then border.Color = BLACK_STROKE end
    end

    if speedLabel then speedLabel.TextColor3 = color end
    if bestScripLabel then bestScripLabel.TextColor3 = color end
    if raptureLinkLabel then raptureLinkLabel.TextColor3 = color end

    local char = LP.Character
    if char then
        local head = char:FindFirstChild("Head")
        if head then
            local bb = head:FindFirstChild("RaptureDuelSpeedIndicator")
            if bb then
                for _, child in ipairs(bb:GetChildren()) do
                    if child:IsA("TextLabel") or child:IsA("TextButton") then
                        child.TextColor3 = color
                    end
                end
            end
        end
    end

    if titleLbl then titleLbl.TextColor3 = color end
    if miniBtn then miniBtn.TextColor3 = color end

    for plr, billboard in pairs(espBillboardCache) do
        if billboard and billboard.Parent then
            local container = billboard:FindFirstChild("Frame")
            if container then
                local nameLbl = container:FindFirstChild("TextLabel")
                if nameLbl then nameLbl.TextColor3 = color end
            end
        end
    end

    if tpBatFloatingButton then
        paintFloatingBtn(tpBatFloatingButton:FindFirstChild("Frame"), batDesyncTpEnabled)
    end

    if batBypassFloatingButton then
        paintFloatingBtn(batBypassFloatingButton:FindFirstChild("Frame"), batBypassEnabled)
    end

    for _, tab in ipairs(tabButtons or {}) do
        if tab:GetAttribute("IsActiveTab") then
            tab.TextColor3 = ACTIVE_TXT
            tab.BackgroundColor3 = color
        end
    end

    if MobilePanel then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        if container then
            local btnContainer = container:FindFirstChild("ButtonsContainer")
            if btnContainer then
                for _, btn in ipairs(btnContainer:GetChildren()) do
                    if btn:IsA("TextButton") and btn:FindFirstChild("BtnGrad") then
                        paintFloatingBtn(btn, btn:GetAttribute("MobActive") == true)
                    end
                end
            end
        end
    end

    if lockBtn then lockBtn.TextColor3 = color end
end

speedMode = false
antiRagdollEnabled = false
antiRagdollVersion = "v1"
jumpEnabled = false
laggerToggled = false
laggerCarryToggled = false
medusaCounterEnabled = false
batCounterEnabled = false
autoLeftEnabled = false
autoRightEnabled = false
autoBatEnabled = false
dropMode = 2
removeAccessoriesEnabled = false
stretchEnabled = false
stretchFOV = 120
stretchValue = 0.7
uiLocked = true
uiScaleValue = 66
progressBarScaleValue = 55
espEnabled = false
antiLagEnabled = false
ragdollTimerEnabled = false

local espHighlightCache = {}
local espBillboardCache = {}
local espTracerCache = {}
local espGlowCache = {}
local espConn = nil

antiLagDescConn = nil
_antiLagStored = {}

savedProgressBarPos = nil
savedButtonPositions = {}
savedMobilePanelPos = nil
tpBatFloatingPos = nil
batBypassFloatingPos = nil
instaResetFloatingPos = nil
instaResetFloatingButton = nil

currentAnimPack = "Off"
tryardHeartbeatConn = nil
useCarrySystem = false
lastMoveDir = _V3zero

-- ============================================================
-- MEDUSA WATCHER
-- ============================================================
local function getMedusaHitTime() return _G._RaptureMedusaHitTime or 0 end
local function isMedusaHit() return (_tick() - getMedusaHitTime()) < 4 end
local function setMedusaHitTime() _G._RaptureMedusaHitTime = _tick() end

do
    local _medusaWatcherConns = {}
    local function _clearMedusaWatcher()
        for _, c in ipairs(_medusaWatcherConns) do pcall(function() c:Disconnect() end) end
        _medusaWatcherConns = {}
    end
    local function _hookPart(part)
        if not part:IsA("BasePart") then return end
        local c = part:GetPropertyChangedSignal("Anchored"):Connect(function()
            if part.Anchored and part.Transparency == 1 then setMedusaHitTime() end
        end)
        table.insert(_medusaWatcherConns, c)
    end
    local function _attachMedusaWatcher(char)
        _clearMedusaWatcher()
        _G._RaptureMedusaHitTime = 0
        if not char then return end
        for _, part in ipairs(char:GetDescendants()) do _hookPart(part) end
        table.insert(_medusaWatcherConns, char.DescendantAdded:Connect(function(part) _hookPart(part) end))
    end
    if LP.Character then _attachMedusaWatcher(LP.Character) end
    LP.CharacterAdded:Connect(function(char) waitForCharReady(char, 10); _attachMedusaWatcher(char) end)
end

-- ============================================================
-- RAGDOLL COUNTDOWN
-- ============================================================
_G._RaptureRCD = _G._RaptureRCD or {conn=nil, charConn=nil, endTime=0, seconds=2.6}
ragdollCountdownLabel = nil
ragdollCountdownEnabled = false

function hookRagdollCountdown(char)
    if _G._RaptureRCD.conn then pcall(function() _G._RaptureRCD.conn:Disconnect() end); _G._RaptureRCD.conn = nil end
    if _G._RaptureRCD.charConn then pcall(function() _G._RaptureRCD.charConn:Disconnect() end); _G._RaptureRCD.charConn = nil end
    if not ragdollCountdownEnabled then return end
    local hum = char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 4)
    if not hum then return end
    local function beginCountdown()
        local duration = isMedusaHit() and 3.6 or _G._RaptureRCD.seconds
        _G._RaptureRCD.endTime = _tick() + duration
        if ragdollCountdownLabel then ragdollCountdownLabel.Visible = true end
    end
    local function isRagdollStateForCountdown()
        local st = hum:GetState()
        return hum.PlatformStand or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll
    end
    _G._RaptureRCD.charConn = hum.StateChanged:Connect(function(_, newState)
        if newState == Enum.HumanoidStateType.Physics or newState == Enum.HumanoidStateType.Ragdoll then beginCountdown() end
    end)
    _G._RaptureRCD.conn = RunService.RenderStepped:Connect(function()
        if not ragdollCountdownEnabled then
            if _G._RaptureRCD.conn then pcall(function() _G._RaptureRCD.conn:Disconnect() end); _G._RaptureRCD.conn = nil end
            if ragdollCountdownLabel then ragdollCountdownLabel.Visible = false; ragdollCountdownLabel.Text = "" end
            return
        end
        if not ragdollCountdownLabel or not ragdollCountdownLabel.Parent then return end
        if isRagdollStateForCountdown() and _G._RaptureRCD.endTime < _tick() then beginCountdown() end
        local left = math.max(0, _G._RaptureRCD.endTime - _tick())
        if left > 0 then
            ragdollCountdownLabel.Visible = true
            ragdollCountdownLabel.Text = string.format("RAGDOLL %.1f", left)
            ragdollCountdownLabel.TextColor3 = left <= 1 and Color3.fromRGB(255, 230, 90) or getThemeColor()
        else
            ragdollCountdownLabel.Visible = false
            ragdollCountdownLabel.Text = ""
        end
    end)
end

-- ============================================================
-- ANTI FLING
-- ============================================================
local _antiFlingState = { connection = nil, threshold = 80, spinThreshold = 40 }
local _ANTI_FLING_DRIVE_GRACE = 0.3

local function _afHubSpeedLive()
    local live = _G.__RaptureLiveSpeed
    if type(live) ~= "table" then return false end
    local stamp, speed = tonumber(live.t), tonumber(live.v)
    if not stamp or not speed or speed <= 0 then return false end
    return (os.clock() - stamp) <= _ANTI_FLING_DRIVE_GRACE
end

local function _afOwnMoverActive()
    if autoBatEnabled then return true end
    if autoLeftEnabled or autoRightEnabled then return true end
    if _G._RaptureBatBypass and _G._RaptureBatBypass.enabled then return true end
    if batDesyncTpEnabled then return true end
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

-- ============================================================
-- ANTI DIE
-- ============================================================
_antiDieEnabled = false
_antiDieStopped = false
_antiDieSources = { toggle = false }

_antiDie = {
    enabled = false, loop = nil, healthConn = nil, charConn = nil,
    lastHealTime = 0, invincibleUntil = 0,
    config = {
        healthThreshold = 50, invincibilityFrames = 0.75,
        fallDamageProtection = false, ragdollProtection = true, autoRevive = true,
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
end

function _antiDie.PreventDamage(root, hum)
    if not hum then return end
    if hum.Health < (hum.MaxHealth or 100) then _antiDie.SuperHeal(hum) end
    if _tick() < _antiDie.invincibleUntil then
        if hum.Health < (hum.MaxHealth or 100) then hum.Health = hum.MaxHealth or 100 end
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
            if root then pcall(function() root.AssemblyAngularVelocity = Vector3.zero end) end
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
end

function _antiDieSetEnabled(enabled)
    enabled = enabled == true
    if enabled then _antiDie.StartEngine() else _antiDie.StopEngine() end
end

_G.AntiDie = {
    start = function() _antiDieStopped = false; _antiDieSetEnabled(true) end,
    stop = function() _antiDieSetEnabled(false) end,
}

-- ============================================================
-- CUSTOM SOUNDS
-- ============================================================
do
    local SOUNDS = {
        Bat    = { id = "rbxassetid://5713085119", skip = 0.2 },
        Medusa = { id = "rbxassetid://3102797479", doublePlay = true, delay = 0.5 },
    }
    local function ctMatchItem(inst)
        if not (inst:IsA("Tool") or inst:IsA("Model")) then return nil end
        local n = inst.Name:lower()
        if n:find("bat") or n:find("slap") then return { key = "Bat" } end
        if n:find("medusa") then return { key = "Medusa" } end
        return nil
    end
    local hooked = setmetatable({}, { __mode = "k" })
    local enabled = false
    local tracked = setmetatable({}, { __mode = "k" })
    local watchers = setmetatable({}, { __mode = "k" })
    local pendingHandle = setmetatable({}, { __mode = "k" })
    local teardown
    local function playCustom(entry)
        local cs = entry.sound
        if not cs or not cs.Parent then return end
        local d = entry.data
        if entry.timer then pcall(task.cancel, entry.timer); entry.timer = nil end
        pcall(function() cs:Stop(); cs.TimePosition = d.skip or 0; cs.Volume = 1; cs:Play() end)
        if d.doublePlay and d.delay then
            entry.timer = task.delay(d.delay, function()
                entry.timer = nil
                if not enabled then return end
                if cs and cs.Parent then
                    pcall(function() cs:Stop(); cs.TimePosition = d.skip or 0; cs.Volume = 1; cs:Play() end)
                end
            end)
        end
    end
    local function hookSound(entry, snd)
        if not snd:IsA("Sound") then return end
        if snd.Name == "CustomSound" then return end
        if hooked[snd] then return end
        if entry.muted[snd] ~= nil then return end
        entry.muted[snd] = snd.Volume
        hooked[snd] = true
        local function trigger()
            if not enabled then return end
            if snd.Playing or snd.TimePosition > 0 then
                pcall(function() snd.Volume = 0; snd:Stop() end)
                playCustom(entry)
            end
        end
        local c1 = snd:GetPropertyChangedSignal("Playing"):Connect(trigger)
        local c2 = snd:GetPropertyChangedSignal("TimePosition"):Connect(trigger)
        table.insert(entry.conns, c1)
        table.insert(entry.conns, c2)
        local c3
        c3 = snd.AncestryChanged:Connect(function(_, parent)
            if parent then return end
            pcall(function() c1:Disconnect() end)
            pcall(function() c2:Disconnect() end)
            pcall(function() c3:Disconnect() end)
            hooked[snd] = nil
            entry.muted[snd] = nil
            if entry.timer then pcall(task.cancel, entry.timer); entry.timer = nil end
        end)
        table.insert(entry.conns, c3)
        if snd.Playing then trigger() end
    end
    local function setupTool(tool)
        if tracked[tool] then return end
        local item = ctMatchItem(tool)
        if not item then return end
        local data = SOUNDS[item.key]
        if not data then return end
        local handle = tool:FindFirstChild("Handle")
        if not handle then
            if pendingHandle[tool] then return end
            local c
            c = tool.ChildAdded:Connect(function(child)
                if child.Name == "Handle" then
                    pcall(function() c:Disconnect() end)
                    pendingHandle[tool] = nil
                    if enabled then setupTool(tool) end
                end
            end)
            pendingHandle[tool] = c
            return
        end
        local old = handle:FindFirstChild("CustomSound")
        if old then pcall(function() old:Destroy() end) end
        local cs = Instance.new("Sound")
        cs.Name        = "CustomSound"
        cs.SoundId     = data.id
        cs.Volume      = 1
        cs.Looped      = false
        cs.RollOffMode = Enum.RollOffMode.Inverse
        cs.MaxDistance = 1000
        cs.MinDistance = 1000
        cs.Parent      = handle
        local entry = { sound = cs, data = data, conns = {}, muted = {} }
        tracked[tool] = entry
        for _, d in ipairs(tool:GetDescendants()) do hookSound(entry, d) end
        table.insert(entry.conns, tool.DescendantAdded:Connect(function(d)
            if tracked[tool] then hookSound(entry, d) end
        end))
        table.insert(entry.conns, tool.AncestryChanged:Connect(function(_, parent)
            if not parent then teardown(tool) end
        end))
    end
    function teardown(tool)
        local entry = tracked[tool]
        if not entry then return end
        if entry.timer then pcall(task.cancel, entry.timer); entry.timer = nil end
        for _, conn in ipairs(entry.conns) do pcall(function() conn:Disconnect() end) end
        if entry.sound then pcall(function() entry.sound:Destroy() end) end
        for snd, vol in pairs(entry.muted) do
            hooked[snd] = nil
            if snd and snd.Parent then pcall(function() snd.Volume = vol end) end
        end
        tracked[tool] = nil
    end
    local function tryRegister(inst)
        if not enabled then return end
        if inst:IsA("Tool") and ctMatchItem(inst) then setupTool(inst) end
    end
    local function unwatch(container)
        local conns = watchers[container]
        if not conns then return end
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
        watchers[container] = nil
    end
    local function watch(container)
        if not container or watchers[container] then return end
        watchers[container] = { container.ChildAdded:Connect(tryRegister) }
        for _, child in ipairs(container:GetChildren()) do tryRegister(child) end
    end
    local function watchAll()
        watch(LP:FindFirstChildOfClass("Backpack"))
        watch(LP.Character)
    end
    LP.ChildAdded:Connect(function(child)
        if enabled and child:IsA("Backpack") then watch(child) end
    end)
    LP.CharacterAdded:Connect(function(char)
        for tool in pairs(tracked) do teardown(tool) end
        for _, c in pairs(pendingHandle) do pcall(function() c:Disconnect() end) end
        table.clear(pendingHandle)
        for container in pairs(watchers) do unwatch(container) end
        if not enabled then return end
        watch(char)
        task.defer(function() if enabled then watchAll() end end)
    end)
    _G.RaptureCustomSounds = {
        setEnabled = function(on)
            on = on and true or false
            enabled = on
            if on then watchAll()
            else
                for tool in pairs(tracked) do teardown(tool) end
                for _, c in pairs(pendingHandle) do pcall(function() c:Disconnect() end) end
                table.clear(pendingHandle)
                for container in pairs(watchers) do unwatch(container) end
            end
            if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
        end,
        isEnabled = function() return enabled end,
    }
end

-- ============================================================
-- Infinite Jump
-- ============================================================
local InfiniteJump = { enabled = false, jumpPower = 55, minVelocity = 30, jumpConn = nil, heartbeatConn = nil }
local function applyJump(root)
    if not root then return end
    pcall(function() root.Velocity = _V3new(root.Velocity.X, InfiniteJump.jumpPower, root.Velocity.Z) end)
end
local function onJumpRequest()
    if not InfiniteJump.enabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if root then applyJump(root) end
end
local function onHeartbeat()
    if not InfiniteJump.enabled then return end
    local char = LP.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local jumpHeld = UIS:IsKeyDown(Enum.KeyCode.Space) or (hum.Jump == true)
    if jumpHeld and root.Velocity.Y < InfiniteJump.minVelocity then applyJump(root) end
end
local function connectEvents()
    if InfiniteJump.jumpConn then InfiniteJump.jumpConn:Disconnect() end
    if InfiniteJump.heartbeatConn then InfiniteJump.heartbeatConn:Disconnect() end
    InfiniteJump.jumpConn = UIS.JumpRequest:Connect(onJumpRequest)
    InfiniteJump.heartbeatConn = RunService.Heartbeat:Connect(onHeartbeat)
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
end
InfiniteJump.start()

function getActiveMoveSpeed()
    if laggerCarryToggled then return LAGGER_CARRY_SPEED
    elseif laggerToggled then return LAGGER_SPEED
    elseif speedMode then return CS
    else return NS end
end

local _velChecked = {}
local _hookedVelParts = {}
local function _setupVelChecked(char)
    _velChecked = {}
    if not char then return end
    local hrp = char:WaitForChild("HumanoidRootPart", 5)
    if hrp then _velChecked[hrp] = true end
    return hrp
end

local _hookVelSupported = nil
local function _hookVelHRP(hrp)
    if not hrp or _hookedVelParts[hrp] then return end
    if _hookVelSupported == false then return end
    if _hookVelSupported == nil then
        _hookVelSupported = (type(getrawmetatable) == "function") and (type(setreadonly) == "function")
            and (type(newcclosure) == "function") and (type(checkcaller) == "function")
    end
    if not _hookVelSupported then return end
    _hookedVelParts[hrp] = true
    local ok = pcall(function()
        local mt = getrawmetatable(hrp)
        if not mt then return end
        setreadonly(mt, false)
        local originalVelIndex = rawget(mt, "__index")
        mt.__index = newcclosure(function(self, key)
            if not checkcaller() and _velChecked[self]
               and (key == "AssemblyLinearVelocity" or key == "Velocity") then
                local real
                if type(originalVelIndex) == "function" then real = originalVelIndex(self, key)
                elseif type(originalVelIndex) == "table" then real = originalVelIndex[key] end
                if real and real.Magnitude > 20 then return real.Unit * 20 end
                return real
            end
            if type(originalVelIndex) == "function" then return originalVelIndex(self, key)
            elseif type(originalVelIndex) == "table" then return originalVelIndex[key] end
        end)
        setreadonly(mt, true)
    end)
    if not ok then _hookVelSupported = false end
end

if LP.Character then
    local _hrp0 = _setupVelChecked(LP.Character)
    _hookVelHRP(_hrp0)
end

local function _isRagdollState(hum)
    if not hum then return true end
    local st = hum:GetState()
    return hum.PlatformStand or st == Enum.HumanoidStateType.Physics
        or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
end

local function _applyVelocitySpeed(dir, speed, hrp)
    if not hrp or not hrp.Parent then return end
    if autoBatEnabled then return end
    if _G._RaptureBatBypass and _G._RaptureBatBypass.enabled then return end
    if dir and dir.Magnitude > 0.05 then
        pcall(function() if hrp.SetNetworkOwner then hrp:SetNetworkOwner(LP) end end)
        local unit = dir.Unit
        local vy = hrp.AssemblyLinearVelocity.Y
        hrp.AssemblyLinearVelocity = _V3new(unit.X * speed, vy, unit.Z * speed)
        _G.__RaptureLiveSpeed = { t = os.clock(), v = speed }
    else
        local vy = hrp.AssemblyLinearVelocity.Y
        hrp.AssemblyLinearVelocity = _V3new(0, vy, 0)
    end
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
    TPBat        = {kb = Enum.KeyCode.V, gp = nil},
    InstaReset   = {kb = Enum.KeyCode.H, gp = nil},
    BatBypass    = {kb = Enum.KeyCode.B, gp = nil},
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
    TPBat        = {kb = DEFAULT_KB.TPBat.kb, gp = DEFAULT_KB.TPBat.gp},
    InstaReset   = {kb = DEFAULT_KB.InstaReset.kb, gp = DEFAULT_KB.InstaReset.gp},
    BatBypass    = {kb = DEFAULT_KB.BatBypass.kb, gp = DEFAULT_KB.BatBypass.gp},
}

_isResetting = false
_lastSavedJSON = nil
_isLoading = false
CONFIG = { AUTO_STEAL_ENABLED = false, STEAL_RANGE = 61 }
local Steal = { AutoStealEnabled = false, StealRadius = CONFIG.STEAL_RANGE, StealDuration = 1.3, Data = {} }
local isStealing = false
local autoGrabSetDelayRadius = 9
local stealConnection = nil

local _plotsCache = nil
local _plotsCacheTime = 0
local function getPlotsRoot()
    local now = _tick()
    if _plotsCache and now - _plotsCacheTime < 2 and _plotsCache.Parent then return _plotsCache end
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
        if yb and yb:IsA("BillboardGui") then return yb.Enabled == true end
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
    if not Steal.AutoStealEnabled then return end
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
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
    if progressPct then progressPct.Text = "0%" end
    local pauseRatio = V2_STOP_PERCENT / 100
    task.spawn(function()
        for _, f in ipairs(data.hold) do task.spawn(f) end
        local startTime = _tick()
        local duration = Steal.StealDuration
        local stopTime = duration * pauseRatio
        local promptFired = false
        local phase = 1
        local phase2Start = 0
        local phase2Timeout = math.max(2.99 - stopTime - math.max(duration - stopTime, 0), 0.05)
        while isStealing and Steal.AutoStealEnabled and phase == 1 do
            local elapsed = _tick() - startTime
            if elapsed >= stopTime then phase = 2; phase2Start = _tick(); break end
            local progress = _clamp(elapsed / duration, 0, pauseRatio)
            if progressFill then progressFill.Size = UDim2.new(progress, 0, 1, 0) end
            if progressPct then progressPct.Text = _floor(progress * 100) .. "%" end
            if not prompt.Parent or not prompt.Parent.Parent then break end
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp and (hrp.Position - prompt.Parent.Parent.Position).Magnitude > Steal.StealRadius then break end
            task.wait()
        end
        if phase == 2 then
            if progressFill then progressFill.Size = UDim2.new(pauseRatio, 0, 1, 0) end
            if progressPct then progressPct.Text = _floor(pauseRatio * 100) .. "%" end
        end
        while isStealing and Steal.AutoStealEnabled and phase == 2 do
            if _tick() - phase2Start >= phase2Timeout then
                if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                if progressPct then progressPct.Text = "0%" end
                data.ready = true; isStealing = false
                task.wait()
                local newPrompt, newName = findNearestPrompt()
                if newPrompt then executeSteal(newPrompt, newName) end
                return
            end
            if not prompt.Parent or not prompt.Parent.Parent then
                isStealing = false
                if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                if progressPct then progressPct.Text = "0%" end
                data.ready = true
                return
            end
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local dist = (hrp.Position - prompt.Parent.Parent.Position).Magnitude
                if dist <= autoGrabSetDelayRadius then phase = 3; break
                elseif dist > Steal.StealRadius then
                    isStealing = false
                    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
                    if progressPct then progressPct.Text = "0%" end
                    data.ready = true
                    return
                end
            end
            task.wait()
        end
        if isStealing and Steal.AutoStealEnabled and phase == 3 then
            local fillStart = _tick()
            local fillDuration = math.max(duration - stopTime, 0.05)
            while true do
                local fp = _clamp((_tick() - fillStart) / fillDuration, 0, 1)
                local totalProgress = pauseRatio + fp * (1 - pauseRatio)
                if fp >= 1 then totalProgress = 1 end
                if progressFill then progressFill.Size = UDim2.new(totalProgress, 0, 1, 0) end
                if progressPct then progressPct.Text = _floor(totalProgress * 100) .. "%" end
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
        if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
        if progressPct then progressPct.Text = "0%" end
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
    stealConnection = RunService.Heartbeat:Connect(function()
        if not Steal.AutoStealEnabled or isStealing then return end
        local p, n = findNearestPrompt()
        if p then executeSteal(p, n) end
    end)
    return true
end

function stopAutoSteal()
    if stealConnection then stealConnection:Disconnect(); stealConnection = nil end
    isStealing = false
    Steal.AutoStealEnabled = false
    CONFIG.AUTO_STEAL_ENABLED = false
    if progressFill then TS:Create(progressFill, TweenInfo.new(0.2), { Size = UDim2.new(0, 0, 1, 0) }):Play() end
    if progressPct then progressPct.Text = "0%" end
end

medusaDebounce = false
medusaLastUsed = 0
dropActive = false
lastDropTime = 0
origFOV = nil
fovEnabled = false
fovValue = 70
customFovConn = nil
setFovVisual = nil
fovSliderSet = nil

_anyKeyListening = false
_aimbotConn = nil
_prevAutoRotate = nil
tpBatConn = nil
tpBatPrevAutoRotate = nil
tpBatHitCD = false
TP_BAT_SWING_CD = 0.08
tpBatFloatingButton = nil
enemySpeedConn = nil
movementLoop = nil
steppedConn = nil
alConn = nil
arConn = nil
infJumpConn = nil
stretchConn = nil
stretchFovConn = nil
medusaResetConns = {}
dropConnections = {}
enemySpeedLabels = {}
Conns = {autoSteal = nil, batCounter = nil, anchor = {}, progress = nil, autoLeft = nil, autoRight = nil, medusaAuto = nil, noPlayerCol = nil}
keyButtonRefs = {}
progressFill = nil
progressPct = nil
pbFrame = nil
speedLabel = nil
normalBox, carryBox, laggerBox, lagger2Box, radInput, batSpeedBox, uiScaleBox, progressBarScaleBox = nil, nil, nil, nil, nil, nil, nil, nil
stretchValueBox = nil
medusaRadiusBox = nil
medusaDelayBox = nil
setJumpToggleState = nil
autoBatSetVisual, autoLeftSetVisual, autoRightSetVisual, setBatCounterVisual, setMedusaVisual = nil, nil, nil, nil, nil
setAutoMedusaVisual, setRagdollTimerVisual = nil, nil
setAntiRagVisual, setJumpVisual, setLockUIVisual, setInstaGrab = nil, nil, nil, nil
setESPVisual, setAntiLagVisual = nil, nil
mobSetAutoBat, mobSetAutoLeft, mobSetAutoRight, mobSetDropBR, mobSetTpDown, mobSetCarry, mobSetLagger1, mobSetLagger2 = nil, nil, nil, nil, nil, nil, nil, nil
main, gui = nil, nil
MobilePanel = nil
instaResetFloatingButton = nil
batBypassFloatingButton = nil
showGui = nil
hideGui = nil
mainUIScale = nil
pbScale = nil
tabButtons = {}
contentPages = {}
currentTab = "Speed"
lockBtn = nil
fpsLabel = nil
msLabel = nil
ragdollCountdownLabel = nil

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
    return kc and (entry.kb == kc or (entry.gp and kc == entry.gp))
end

function resetProgressBar()
    if progressPct then progressPct.Text = "0%" end
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
end

local function doTpDown()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        if not root then return end
        root.CFrame = _CFnew(root.Position.X, -7, root.Position.Z) * CFrame.Angles(0, select(2, root.CFrame:ToEulerAnglesYXZ()), 0)
        root.Velocity = _V3zero
    end)
end

function saveSkipIntroSetting() end
function setSkipIntro(enabled) skipIntroEnabled = true; saveAllSettings() end

-- ============================================================
-- ANTI RAGDOLL V1/V2
-- ============================================================
local AntiRagdollV1 = {}
AntiRagdollV1.__index = AntiRagdollV1
local BOOST_SPEED = 400
local AR_DEFAULT_SPEED = 16
local stateV1 = { active = false, isBoosting = false, cachedChar = nil, ragdollConnections = {} }

local function disconnectAllV1()
    for _, conn in ipairs(stateV1.ragdollConnections) do pcall(function() conn:Disconnect() end) end
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
    pcall(function() LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end)
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
    if hum.Health > 0 then hum:ChangeState(Enum.HumanoidStateType.Running) end
    root.Anchored = false
end

local function heartbeatLoopV1()
    while stateV1.active do
        task.wait()
        if isRagdolledV1() then forceExitRagdollV1()
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
    if not cacheCharacterV1() then return end
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
end

function AntiRagdollV1.stop()
    stateV1.active = false
    if stateV1.isBoosting and stateV1.cachedChar and stateV1.cachedChar.humanoid then
        stateV1.cachedChar.humanoid.WalkSpeed = AR_DEFAULT_SPEED
    end
    stateV1.isBoosting = false
    disconnectAllV1()
    stateV1.cachedChar = nil
end

function AntiRagdollV1.isRunning() return stateV1.active end

local AntiRagdollV2 = { Enabled = false, Connection = nil, ResetCooldown = 0 }

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

function setAntiRagdollEnabled(enabled)
    antiRagdollEnabled = enabled
    if enabled then
        if antiRagdollVersion == "v1" then AntiRagdollV1.start()
        elseif antiRagdollVersion == "v2" then startAntiRagdollV2() end
    else
        if AntiRagdollV1.isRunning() then AntiRagdollV1.stop() end
        if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
    end
    saveAllSettings()
end

function setAntiRagdollVersion(version)
    antiRagdollVersion = version
    if antiRagdollEnabled then
        if AntiRagdollV1.isRunning() then AntiRagdollV1.stop() end
        if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
        if version == "v1" then AntiRagdollV1.start()
        elseif version == "v2" then startAntiRagdollV2() end
    end
    saveAllSettings()
end

-- ============================================================
-- MEDUSA COUNTER
-- ============================================================
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
        if part:IsA("BasePart") then table.insert(Conns.anchor, onAnchorChanged(part)) end
    end
    table.insert(Conns.anchor, char.DescendantAdded:Connect(function(part)
        if part:IsA("BasePart") then table.insert(Conns.anchor, onAnchorChanged(part)) end
    end))
end

function stopMedusaCounter()
    for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end
    Conns.anchor = {}
end

-- ============================================================
-- ESP
-- ============================================================
local function espCreateGlow(plr)
    local old = workspace:FindFirstChild("RaptureESPGlow_" .. tostring(plr.UserId))
    if old then old:Destroy() end
    local glow = Instance.new("Part")
    glow.Name = "RaptureESPGlow_" .. tostring(plr.UserId)
    glow.Shape = Enum.PartType.Ball
    glow.Size = Vector3.new(0.65, 0.65, 0.65)
    glow.Anchored = true
    glow.CanCollide = false
    glow.CanTouch = false
    glow.CanQuery = false
    glow.CastShadow = false
    glow.Material = Enum.Material.SmoothPlastic
    glow.Color = getThemeColor()
    glow.Transparency = 0.05
    glow.CFrame = CFrame.new(0, -10000, 0)
    glow.Parent = workspace
    local light = Instance.new("PointLight", glow)
    light.Color = getThemeColor()
    light.Brightness = 2.5
    light.Range = 9
    light.Shadows = false
    return glow
end

local function espCreateBox(char)
    if not char then return end
    local old = char:FindFirstChild("RaptureESPBox")
    if old then old:Destroy() end
    local h = Instance.new("Highlight")
    h.Name = "RaptureESPBox"
    h.Adornee = char
    h.FillColor = getThemeColor()
    h.OutlineColor = Color3.fromRGB(0, 0, 0)
    h.FillTransparency = 0.7
    h.OutlineTransparency = 0.1
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Parent = char
    return h
end

local function espCreateBillboard(plr, char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local old = head:FindFirstChild("RaptureESPAvatar")
    if old then old:Destroy() end
    local bb = Instance.new("BillboardGui")
    bb.Name = "RaptureESPAvatar"
    bb.Size = UDim2.new(0, 80, 0, 60)
    bb.StudsOffset = Vector3.new(0, 2.5, 0)
    bb.AlwaysOnTop = true
    bb.Parent = head
    local container = Instance.new("Frame", bb)
    container.Size = UDim2.new(1, 0, 1, 0)
    container.BackgroundTransparency = 1
    local name = Instance.new("TextLabel", container)
    name.Size = UDim2.new(1, 0, 0, 20)
    name.Position = UDim2.new(0, 0, 0, 0)
    name.BackgroundTransparency = 1
    name.Text = plr.DisplayName or plr.Name
    name.TextColor3 = getThemeColor()
    name.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    name.TextStrokeTransparency = 0.3
    name.Font = Enum.Font.GothamBold
    name.TextSize = 12
    return bb
end

function startESP()
    if espConn then return end
    espEnabled = true
    local function setupPlayer(plr)
        if plr == LP then return end
        if espHighlightCache[plr] then return end
        local char = plr.Character
        if char then
            espBillboardCache[plr] = espCreateBillboard(plr, char)
            espHighlightCache[plr] = espCreateBox(char)
        end
        espGlowCache[plr] = espCreateGlow(plr)
    end
    local function removePlayer(plr)
        if espBillboardCache[plr] then pcall(function() espBillboardCache[plr]:Destroy() end); espBillboardCache[plr] = nil end
        if espHighlightCache[plr] then pcall(function() espHighlightCache[plr]:Destroy() end); espHighlightCache[plr] = nil end
        if espGlowCache[plr] then pcall(function() espGlowCache[plr]:Destroy() end); espGlowCache[plr] = nil end
    end
    for _, plr in ipairs(Players:GetPlayers()) do setupPlayer(plr) end
    Conns.espAdded = Players.PlayerAdded:Connect(setupPlayer)
    Conns.espRemoving = Players.PlayerRemoving:Connect(removePlayer)
    Conns.espCharAdded = {}
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LP then
            table.insert(Conns.espCharAdded, plr.CharacterAdded:Connect(function(char)
                task.wait(0.3)
                if espEnabled then
                    if espBillboardCache[plr] then pcall(function() espBillboardCache[plr]:Destroy() end) end
                    if espHighlightCache[plr] then pcall(function() espHighlightCache[plr]:Destroy() end) end
                    espBillboardCache[plr] = espCreateBillboard(plr, char)
                    espHighlightCache[plr] = espCreateBox(char)
                end
            end))
        end
    end
    espConn = RunService.RenderStepped:Connect(function()
        if not espEnabled then return end
        local accent = getThemeColor()
        for plr, glow in pairs(espGlowCache) do
            if glow and glow.Parent then
                local char = plr.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    glow.Color = accent
                    glow.CFrame = CFrame.new(hrp.Position - Vector3.new(0, (hrp.Size.Y * 0.5) + 2.35, 0))
                    local light = glow:FindFirstChildOfClass("PointLight")
                    if light then light.Color = accent end
                else
                    glow.CFrame = CFrame.new(0, -10000, 0)
                end
            end
        end
        for plr, hl in pairs(espHighlightCache) do
            if hl and hl.Parent then hl.FillColor = accent end
        end
        for plr, billboard in pairs(espBillboardCache) do
            if billboard and billboard.Parent then
                local container = billboard:FindFirstChild("Frame")
                if container then
                    local nameLbl = container:FindFirstChild("TextLabel")
                    if nameLbl then nameLbl.TextColor3 = accent end
                end
            end
        end
    end)
end

function stopESP()
    espEnabled = false
    if espConn then espConn:Disconnect(); espConn = nil end
    if Conns.espAdded then Conns.espAdded:Disconnect(); Conns.espAdded = nil end
    if Conns.espRemoving then Conns.espRemoving:Disconnect(); Conns.espRemoving = nil end
    if Conns.espCharAdded then
        for _, c in ipairs(Conns.espCharAdded) do pcall(function() c:Disconnect() end) end
        Conns.espCharAdded = {}
    end
    for plr in pairs(espBillboardCache) do pcall(function() espBillboardCache[plr]:Destroy() end) end
    for plr in pairs(espHighlightCache) do pcall(function() espHighlightCache[plr]:Destroy() end) end
    for plr in pairs(espGlowCache) do pcall(function() espGlowCache[plr]:Destroy() end) end
    espBillboardCache = {}
    espHighlightCache = {}
    espGlowCache = {}
end

-- ============================================================
-- ANTI LAG
-- ============================================================
_antiLagStored = {
    lighting = {},
    qualityLevel = nil,
    meshDetail = nil,
    terrainWater = nil,
    technology = nil,
}

local function applyAntiLagDerender(obj)
    pcall(function()
        if obj:GetAttribute("_AmbitiousHubSky") ~= nil then return end
        if obj:IsA("Sky") or obj:IsA("Atmosphere") or obj:IsA("Clouds") then return end
        if obj:IsA("Accessory") or obj:IsA("Hat") then
            local char = LP.Character
            if char and obj:IsDescendantOf(char) then return end
            obj:Destroy()
        elseif obj:IsA("BasePart") then
            obj.Material      = Enum.Material.Plastic
            obj.Reflectance   = 0
            obj.CastShadow    = false
            obj.TopSurface    = Enum.SurfaceType.Smooth
            obj.BottomSurface = Enum.SurfaceType.Smooth
            obj.FrontSurface  = Enum.SurfaceType.Smooth
            obj.BackSurface   = Enum.SurfaceType.Smooth
            obj.LeftSurface   = Enum.SurfaceType.Smooth
            obj.RightSurface  = Enum.SurfaceType.Smooth
            for _, child in ipairs(obj:GetChildren()) do
                if child:IsA("Decal") or child:IsA("Texture") then
                    child.Transparency = 0.5
                end
            end
        elseif obj:IsA("Decal") or obj:IsA("Texture") then
            obj.Transparency = 0.5
        elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
            or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
            obj.Enabled = false
        elseif obj:IsA("PointLight") or obj:IsA("SpotLight")
            or obj:IsA("SurfaceLight") then
            obj.Enabled = false
        elseif obj:IsA("SelectionBox") and obj.Name ~= "AmbitiousHubESP" then
            pcall(function() obj:Destroy() end)
        end
    end)
end

function enableAntiLag()
    antiLagEnabled           = true
    removeAccessoriesEnabled = true

    _antiLagStored.lighting = {
        Brightness          = Lighting.Brightness,
        ClockTime           = Lighting.ClockTime,
        OutdoorAmbient      = Lighting.OutdoorAmbient,
        Ambient             = Lighting.Ambient,
        GlobalShadows       = Lighting.GlobalShadows,
        FogEnd              = Lighting.FogEnd,
        FogStart            = Lighting.FogStart,
        EnvironmentDiffuseScale  = Lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
        ShadowSoftness      = Lighting.ShadowSoftness,
        ExposureCompensation = Lighting.ExposureCompensation,
        Technology          = Lighting.Technology,
    }
    _antiLagStored.qualityLevel = settings().Rendering.QualityLevel
    _antiLagStored.meshDetail   = settings().Rendering.MeshPartDetailLevel
    _antiLagStored.technology   = Lighting.Technology

    pcall(function()
        settings().Rendering.QualityLevel        = 1
        settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Disabled
    end)

    Lighting.GlobalShadows            = false
    Lighting.FogEnd                   = 1e10
    Lighting.FogStart                 = 0
    Lighting.Brightness               = 1
    Lighting.EnvironmentDiffuseScale  = 0
    Lighting.EnvironmentSpecularScale = 0
    Lighting.ShadowSoftness           = 0
    Lighting.ExposureCompensation     = 0
    pcall(function() Lighting.Technology = Enum.Technology.Compatibility end)

    for _, e in pairs(Lighting:GetChildren()) do
        pcall(function()
            if e:GetAttribute("_AmbitiousVivid") then return end
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect")
            or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect")
            or e:IsA("DepthOfFieldEffect") or e:IsA("BrightnessEffect")
            or e:IsA("DitheringEffect") then
                if not e:GetAttribute("_RaptureOrigEnabled") then
                    e:SetAttribute("_RaptureOrigEnabled", e.Enabled)
                end
                e.Enabled = false
            end
        end)
    end

    for _, obj in ipairs(workspace:GetDescendants()) do
        applyAntiLagDerender(obj)
    end

    for _, descendant in pairs(workspace:GetDescendants()) do
        pcall(function()
            if descendant:IsA("ParticleEmitter") then
                descendant.Enabled = false
            elseif descendant:IsA("Decal") then
                descendant.Transparency = 1
            elseif descendant:IsA("BasePart") then
                local char = LP.Character
                if char and descendant:IsDescendantOf(char) then return end
                descendant.Material      = Enum.Material.Plastic
                descendant.Reflectance   = 0
                descendant.CastShadow    = false
                descendant.TopSurface    = Enum.SurfaceType.Smooth
                descendant.BottomSurface = Enum.SurfaceType.Smooth
                descendant.FrontSurface  = Enum.SurfaceType.Smooth
                descendant.BackSurface   = Enum.SurfaceType.Smooth
                descendant.LeftSurface   = Enum.SurfaceType.Smooth
                descendant.RightSurface  = Enum.SurfaceType.Smooth
            end
        end)
    end

    pcall(function()
        _antiLagStored.terrainWater = {
            WaveSize     = workspace.Terrain.WaterWaveSize,
            WaveSpeed    = workspace.Terrain.WaterWaveSpeed,
            Reflectance  = workspace.Terrain.WaterReflectance,
            Transparency = workspace.Terrain.WaterTransparency,
            Decoration   = workspace.Terrain.Decoration,
        }
        workspace.Terrain.WaterWaveSize     = 0
        workspace.Terrain.WaterWaveSpeed    = 0
        workspace.Terrain.WaterReflectance  = 0
        workspace.Terrain.WaterTransparency = 0
        workspace.Terrain.Decoration        = false
    end)

    if antiLagDescConn then antiLagDescConn:Disconnect() end
    antiLagDescConn = workspace.DescendantAdded:Connect(function(obj)
        if obj:GetAttribute("_AmbitiousHubSky") then return end
        if obj:IsA("Sky") or obj:IsA("Atmosphere") or obj:IsA("Clouds") then return end
        if removeAccessoriesEnabled then applyAntiLagDerender(obj) end
    end)
end

function disableAntiLag()
    antiLagEnabled           = false
    removeAccessoriesEnabled = false
    if antiLagDescConn then
        antiLagDescConn:Disconnect()
        antiLagDescConn = nil
    end

    pcall(function()
        if _antiLagStored.qualityLevel then
            settings().Rendering.QualityLevel = _antiLagStored.qualityLevel
        end
        if _antiLagStored.meshDetail then
            settings().Rendering.MeshPartDetailLevel = _antiLagStored.meshDetail
        end
    end)

    pcall(function()
        local L = _antiLagStored.lighting
        if L then
            if L.Brightness ~= nil then Lighting.Brightness = L.Brightness end
            if L.ClockTime ~= nil then Lighting.ClockTime = L.ClockTime end
            if L.OutdoorAmbient ~= nil then Lighting.OutdoorAmbient = L.OutdoorAmbient end
            if L.Ambient ~= nil then Lighting.Ambient = L.Ambient end
            if L.GlobalShadows ~= nil then Lighting.GlobalShadows = L.GlobalShadows end
            if L.FogEnd ~= nil then Lighting.FogEnd = L.FogEnd end
            if L.FogStart ~= nil then Lighting.FogStart = L.FogStart end
            if L.EnvironmentDiffuseScale ~= nil then Lighting.EnvironmentDiffuseScale = L.EnvironmentDiffuseScale end
            if L.EnvironmentSpecularScale ~= nil then Lighting.EnvironmentSpecularScale = L.EnvironmentSpecularScale end
            if L.ShadowSoftness ~= nil then Lighting.ShadowSoftness = L.ShadowSoftness end
            if L.ExposureCompensation ~= nil then Lighting.ExposureCompensation = L.ExposureCompensation end
        end
        if _antiLagStored.technology then
            pcall(function() Lighting.Technology = _antiLagStored.technology end)
        end
    end)

    pcall(function()
        for _, e in pairs(Lighting:GetChildren()) do
            if e:IsA("BlurEffect") or e:IsA("SunRaysEffect")
            or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect")
            or e:IsA("DepthOfFieldEffect") or e:IsA("BrightnessEffect")
            or e:IsA("DitheringEffect") then
                local orig = e:GetAttribute("_RaptureOrigEnabled")
                if orig ~= nil then
                    e.Enabled = orig
                    e:SetAttribute("_RaptureOrigEnabled", nil)
                end
            end
        end
    end)

    pcall(function()
        local W = _antiLagStored.terrainWater
        if W then
            if W.WaveSize ~= nil then workspace.Terrain.WaterWaveSize = W.WaveSize end
            if W.WaveSpeed ~= nil then workspace.Terrain.WaterWaveSpeed = W.WaveSpeed end
            if W.Reflectance ~= nil then workspace.Terrain.WaterReflectance = W.Reflectance end
            if W.Transparency ~= nil then workspace.Terrain.WaterTransparency = W.Transparency end
            if W.Decoration ~= nil then workspace.Terrain.Decoration = W.Decoration end
        end
    end)

    pcall(function()
        for _, part in pairs(workspace:GetDescendants()) do
            if part:IsA("BasePart") then
                local char = LP.Character
                if char and part:IsDescendantOf(char) then continue end
            elseif part:IsA("ParticleEmitter") then
            elseif part:IsA("PointLight") or part:IsA("SpotLight")
                or part:IsA("SurfaceLight") then
                pcall(function() part.Enabled = true end)
            end
        end
    end)

    _antiLagStored = {
        lighting = {},
        qualityLevel = nil,
        meshDetail = nil,
        terrainWater = nil,
        technology = nil,
    }
end

-- ============================================================
-- SPEED INDICATOR
-- ============================================================
function setupSpeedIndicator(char)
    local head = char:WaitForChild("Head", 5)
    if not head then return end
    local oldBB = head:FindFirstChild("RaptureDuelSpeedIndicator")
    if oldBB then oldBB:Destroy() end

    local bb = Instance.new("BillboardGui", head)
    bb.Name = "RaptureDuelSpeedIndicator"
    bb.Size = UDim2.new(0, 220, 0, 140)
    bb.StudsOffset = _V3new(0, 3.6, 0)
    bb.AlwaysOnTop = true

    raptureLinkLabel = Instance.new("TextLabel", bb)
    raptureLinkLabel.Name = "RaptureLinkLabel"
    raptureLinkLabel.Size = UDim2.new(1, 0, 0, 30)
    raptureLinkLabel.Position = UDim2.new(0, 0, 0, 0)
    raptureLinkLabel.BackgroundTransparency = 1
    raptureLinkLabel.Text = ".gg/raptureduel"
    raptureLinkLabel.TextColor3 = getThemeColor()
    raptureLinkLabel.Font = Enum.Font.GothamBlack
    raptureLinkLabel.TextSize = 28
    raptureLinkLabel.TextStrokeTransparency = 0
    raptureLinkLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    raptureLinkLabel.TextXAlignment = Enum.TextXAlignment.Center
    raptureLinkLabel.ZIndex = 5

    bestScripLabel = Instance.new("TextLabel", bb)
    bestScripLabel.Name = "BestScripLabel"
    bestScripLabel.Size = UDim2.new(1, 0, 0, 22)
    bestScripLabel.Position = UDim2.new(0, 0, 0, 34)
    bestScripLabel.BackgroundTransparency = 1
    bestScripLabel.Text = "Best Script Free"
    bestScripLabel.TextColor3 = getThemeColor()
    bestScripLabel.Font = Enum.Font.GothamBold
    bestScripLabel.TextSize = 18
    bestScripLabel.TextStrokeTransparency = 0
    bestScripLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    bestScripLabel.TextXAlignment = Enum.TextXAlignment.Center
    bestScripLabel.ZIndex = 5

    speedLabel = Instance.new("TextLabel", bb)
    speedLabel.Name = "SpeedLabel"
    speedLabel.Size = UDim2.new(1, 0, 0, 28)
    speedLabel.Position = UDim2.new(0, 0, 0, 60)
    speedLabel.BackgroundTransparency = 1
    speedLabel.Text = "Speed: " .. string.format("%.1f", getActiveMoveSpeed())
    speedLabel.TextColor3 = getThemeColor()
    speedLabel.Font = Enum.Font.GothamBold
    speedLabel.TextSize = 22
    speedLabel.TextStrokeTransparency = 0
    speedLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    speedLabel.ZIndex = 5

    ragdollCountdownLabel = Instance.new("TextLabel", bb)
    ragdollCountdownLabel.Name = "RagdollCountdown"
    ragdollCountdownLabel.Size = UDim2.new(1, 0, 0, 26)
    ragdollCountdownLabel.Position = UDim2.new(0, 0, 0, 96)
    ragdollCountdownLabel.BackgroundTransparency = 1
    ragdollCountdownLabel.Text = ""
    ragdollCountdownLabel.Visible = false
    ragdollCountdownLabel.TextColor3 = getThemeColor()
    ragdollCountdownLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    ragdollCountdownLabel.TextStrokeTransparency = 0
    ragdollCountdownLabel.Font = Enum.Font.GothamBlack
    ragdollCountdownLabel.TextSize = 22
    ragdollCountdownLabel.TextXAlignment = Enum.TextXAlignment.Center
    ragdollCountdownLabel.ZIndex = 10
    ragdollCountdownLabel.Parent = bb
end

local unwalkSavedAnimate = nil
unwalkEnabled = false

function startUnwalk()
    local c = LP.Character
    if not c then return end
    local hum = c:FindFirstChildOfClass("Humanoid")
    if hum then
        for _, t in ipairs(hum:GetPlayingAnimationTracks()) do pcall(function() t:Stop() end) end
    end
    local anim = c:FindFirstChild("Animate")
    if anim then unwalkSavedAnimate = anim:Clone(); anim:Destroy() end
end

function stopUnwalk()
    local c = LP.Character
    if c then
        local existing = c:FindFirstChild("Animate")
        if not existing then
            local src = game:GetService("StarterPlayer"):FindFirstChildOfClass("StarterCharacterScripts")
            local starterAnim = src and src:FindFirstChild("Animate")
            if starterAnim then starterAnim:Clone().Parent = c
            elseif unwalkSavedAnimate then unwalkSavedAnimate:Clone().Parent = c end
        end
    end
    unwalkSavedAnimate = nil
end

function refreshSpeedModeLabel()
    if setCarryModeVisual then setCarryModeVisual(speedMode) end
    if setLaggerModeVisual then setLaggerModeVisual(laggerToggled) end
    if setLaggerCarryVisual then setLaggerCarryVisual(laggerCarryToggled) end
end

function resetMovementState()
    refreshSpeedModeLabel()
    if mobSetCarry then mobSetCarry(speedMode) end
    if mobSetLagger1 then mobSetLagger1(laggerToggled) end
    if mobSetLagger2 then mobSetLagger2(laggerCarryToggled) end
end

function toggleCarryMode()
    if speedMode then speedMode = false
    else speedMode = true; laggerToggled = false; laggerCarryToggled = false end
    resetMovementState()
    saveAllSettings()
end

function toggleLaggerMode()
    if laggerToggled then laggerToggled = false
    else laggerToggled = true; speedMode = false; laggerCarryToggled = false end
    resetMovementState()
    saveAllSettings()
end

function toggleLaggerCarryMode()
    if laggerCarryToggled then laggerCarryToggled = false
    else laggerCarryToggled = true; speedMode = false; laggerToggled = false end
    resetMovementState()
    saveAllSettings()
end

function toggleLaggerCycle()
    if speedMode then
        speedMode = false; laggerToggled = true; laggerCarryToggled = false
    elseif laggerToggled then
        speedMode = false; laggerToggled = false; laggerCarryToggled = true
    else
        speedMode = true; laggerToggled = false; laggerCarryToggled = false
    end
    resetMovementState()
    saveAllSettings()
end

-- ============================================================
-- AUTO LEFT / RIGHT
-- ============================================================
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
end

function startAutoLeft()
    if autoRightEnabled then
        autoRightEnabled = false; stopAutoRight()
        if autoRightSetVisual then autoRightSetVisual(false) end
        if mobSetAutoRight then mobSetAutoRight(false) end
    end
    disableAllAimbots()
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
end

function startAutoRight()
    if autoLeftEnabled then
        autoLeftEnabled = false; stopAutoLeft()
        if autoLeftSetVisual then autoLeftSetVisual(false) end
        if mobSetAutoLeft then mobSetAutoLeft(false) end
    end
    disableAllAimbots()
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

-- ============================================================
-- AIMBOT V1
-- ============================================================
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

function stopAimbotAdapt()
    if _aimbotConn then pcall(function() _aimbotConn:Disconnect() end); _aimbotConn = nil end
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
end

function startAimbotAdapt()
    if _aimbotConn then return end
    local hum0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if hum0 then
        if _prevAutoRotate == nil then _prevAutoRotate = hum0.AutoRotate end
        hum0.AutoRotate = false
    end
    _aimbotConn = RunService.RenderStepped:Connect(function()
        if not autoBatEnabled then return end
        local char = LP.Character
        if not char then return end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not root or not hum then return end
        if not char:FindFirstChildOfClass("Tool") then
            local bat = findBat()
            if bat then pcall(function() hum:EquipTool(bat) end) end
        end
        local target = getClosestTarget()
        if not target then return end
        local myPos = root.Position
        local targetPos = target.Position
        local targetVel = target.AssemblyLinearVelocity
        local speedMult, predictAmount, heightOffset
        if aimbotMode == "V2" then
            speedMult = BAT_AIMBOT_SPEED * 1.05
            predictAmount = 0.22
            heightOffset = 3.2
        else
            speedMult = BAT_AIMBOT_SPEED
            predictAmount = 0.14
            heightOffset = 3.7
        end
        local predictPos = targetPos + targetVel * predictAmount
        predictPos = predictPos + target.CFrame.LookVector * 0.3
        local direction = predictPos - myPos
        local flatDir = _V3new(direction.X, 0, direction.Z)
        if flatDir.Magnitude > 0 then flatDir = flatDir.Unit else flatDir = _V3new(0,0,0) end
        local desiredHeight = targetPos.Y + heightOffset
        local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
        if hum.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 13) end
        yVel = _clamp(yVel, -70, 110)
        local desiredVel = _V3new(flatDir.X * speedMult, yVel, flatDir.Z * speedMult)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
        local speed3 = targetVel.Magnitude
        local predictTime = _clamp(speed3 / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        local toPredict = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            local goalCF = _CFlookAt(myPos, predictedPos)
            local diffCF = root.CFrame:Inverse() * goalCF
            local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
            rx = _clamp(rx, -2.5, 2.5); ry = _clamp(ry, -2.5, 2.5); rz = _clamp(rz, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(_V3new(rx * 42, ry * 42, rz * 42))
        end
        local distToTarget = (root.Position - target.Position).Magnitude
        if distToTarget <= 8 then trySwing() end
    end)
end

function disableAutoBat()
    autoBatEnabled = false
    if autoBatSetVisual then autoBatSetVisual(false) end
    if mobSetAutoBat then mobSetAutoBat(false) end
    stopAimbotAdapt()
    if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
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
    if batDesyncTpEnabled then toggleBatDesyncTp() end
    if _G._RaptureBatBypass and _G._RaptureBatBypass.enabled then _G.RaptureStopBatBypass() end
    autoBatEnabled = true
    if autoBatSetVisual then autoBatSetVisual(true) end
    if mobSetAutoBat then mobSetAutoBat(true) end
    startAimbotAdapt()
    if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
end

-- ============================================================
-- TP BAT
-- ============================================================
batDesyncTpEnabled = false
batDesyncTpConn    = nil
batDesyncTpSetVisual = nil
local _tpBatUnwalkForced = false
local _tpBatHitCooldown = false
local _tpBatMaxRange    = 100
local _tpBatAntiDieThread = nil
local _tpBatLagThread     = nil
local _tpBatLagChain      = nil
local _tpBatLagPayload    = nil

local TP_LAG_KBPS     = 12000
local TP_LAG_INTERVAL = 0.15
local TP_LAG_DEPTH    = 12
local TP_LAG_REPS     = 800

local function tpBatStartAntiDie()
    if _tpBatAntiDieThread then return end
    _tpBatAntiDieThread = task.spawn(function()
        while batDesyncTpEnabled do
            pcall(function()
                local char = LP.Character
                if not char then task.wait(0.1) return end
                local hum  = char:FindFirstChildOfClass("Humanoid")
                local root = char:FindFirstChild("HumanoidRootPart")
                if hum then
                    if hum.Health <= 0 then hum.Health = hum.MaxHealth end
                    if hum.PlatformStand then hum.PlatformStand = false end
                    if hum.Sit then hum.Sit = false end
                    local st = hum:GetState()
                    if st == Enum.HumanoidStateType.Physics
                       or st == Enum.HumanoidStateType.Ragdoll
                       or st == Enum.HumanoidStateType.FallingDown then
                        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                        hum:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end
                if root and sethiddenproperty then
                    pcall(sethiddenproperty, root, "PhysicsRepRootPart", nil)
                end
                if char then
                    for _, p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") then p.CanCollide = false end
                    end
                end
            end)
            task.wait(0.05)
        end
        _tpBatAntiDieThread = nil
    end)
end

local function tpBatStopAntiDie()
    if _tpBatAntiDieThread then
        pcall(task.cancel, _tpBatAntiDieThread)
        _tpBatAntiDieThread = nil
    end
end

local function tpBatBuildLagChain()
    if _tpBatLagChain then return _tpBatLagChain end
    local root = {}
    local cur = root
    for _ = 1, TP_LAG_DEPTH do
        local n = {}
        cur[1] = n
        cur = n
    end
    _tpBatLagChain = root
    return root
end

local function tpBatBuildLagPayload()
    if _tpBatLagPayload then return _tpBatLagPayload end
    local chain = tpBatBuildLagChain()
    local payload = table.create(TP_LAG_REPS)
    for i = 1, TP_LAG_REPS do payload[i] = chain end
    _tpBatLagPayload = payload
    return payload
end

local function tpBatSetKBPS(v)
    pcall(function()
        game:GetService("NetworkClient"):SetOutgoingKBPSLimit(v)
    end)
end

local function tpBatFireLagPayload()
    pcall(function()
        local rrs = game:GetService("RobloxReplicatedStorage")
        if rrs and rrs:FindFirstChild("SetPlayerBlockList") then
            rrs.SetPlayerBlockList:FireServer(tpBatBuildLagPayload())
        end
    end)
end

local function tpBatStartLagger()
    if _tpBatLagThread then return end
    _tpBatLagThread = task.spawn(function()
        task.wait(0.05)
        while batDesyncTpEnabled do
            tpBatSetKBPS(TP_LAG_KBPS)
            tpBatFireLagPayload()
            task.wait(TP_LAG_INTERVAL)
        end
        tpBatSetKBPS(0)
        _tpBatLagThread = nil
    end)
end

local function tpBatStopLagger()
    if _tpBatLagThread then
        pcall(task.cancel, _tpBatLagThread)
        _tpBatLagThread = nil
    end
    tpBatSetKBPS(0)
end

local function tpBatGetBat()
    local character = LP.Character
    if not character then return nil end
    for _, tool in ipairs(character:GetChildren()) do
        if tool:IsA("Tool") then
            local name = tool.Name:lower()
            if name:find("bat") or name:find("slap") then return tool end
        end
    end
    local backpack = LP:FindFirstChild("Backpack")
    if not backpack then return nil end
    for _, tool in ipairs(backpack:GetChildren()) do
        if tool:IsA("Tool") then
            local name = tool.Name:lower()
            if name:find("bat") or name:find("slap") then
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then pcall(function() humanoid:EquipTool(tool) end) end
                return tool
            end
        end
    end
    return nil
end

local function tpBatHit()
    if _tpBatHitCooldown then return end
    _tpBatHitCooldown = true
    pcall(function()
        local bat = tpBatGetBat()
        if not bat then return end
        bat:Activate()
        local remote = bat:FindFirstChildWhichIsA("RemoteEvent")
        if remote then remote:FireServer() end
    end)
    task.delay(0.08, function() _tpBatHitCooldown = false end)
end

local function tpBatClosestPlayer(root)
    local closest, distance = nil, math.huge
    for _, player in ipairs(Players:GetPlayers()) do
        local character  = player ~= LP and player.Character
        local targetRoot = character and character:FindFirstChild("HumanoidRootPart")
        local humanoid   = character and character:FindFirstChildOfClass("Humanoid")
        if targetRoot and humanoid and humanoid.Health > 0 then
            local candidateDistance = (root.Position - targetRoot.Position).Magnitude
            if candidateDistance < distance then
                closest, distance = player, candidateDistance
            end
        end
    end
    return closest, distance
end

local function tpBatNetworkOwnerTeleport(root, targetRoot)
    pcall(function() if root.SetNetworkOwner then root:SetNetworkOwner(nil) end end)
    task.wait()
    local targetPosition = targetRoot.Position + _V3new(0, 0.9, 0)
    root.CFrame = _CFnew(targetPosition)
    root.AssemblyLinearVelocity = targetRoot.AssemblyLinearVelocity
    pcall(function() if root.SetNetworkOwner then root:SetNetworkOwner(LP) end end)
end

local function tpBatUpdate()
    if not batDesyncTpEnabled then return end
    local character = LP.Character
    local root      = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid  = character and character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid then return end
    local animator = humanoid:FindFirstChildOfClass("Animator")
    if animator then
        pcall(function()
            for _, track in ipairs(animator:GetPlayingAnimationTracks()) do track:Stop() end
        end)
    end
    local bat = tpBatGetBat()
    if bat and bat.Parent ~= character then
        pcall(function() humanoid:EquipTool(bat) end)
    end
    local target, distance = tpBatClosestPlayer(root)
    if not target or distance > _tpBatMaxRange then return end
    local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
    if not targetRoot then return end
    tpBatNetworkOwnerTeleport(root, targetRoot)
    local camera = workspace.CurrentCamera
    if camera then
        camera.CFrame = _CFnew(camera.CFrame.Position, targetRoot.Position)
    end
    tpBatHit()
    pcall(function()
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then part.CanCollide = false end
        end
    end)
end

function startBatDesyncTp()
    if batDesyncTpConn then
        batDesyncTpConn:Disconnect()
        batDesyncTpConn = nil
    end
    batDesyncTpEnabled = true
    _tpBatHitCooldown  = false
    if not unwalkEnabled then
        startUnwalk()
        unwalkEnabled = true
        _tpBatUnwalkForced = true
        if setUnwalkVisual then setUnwalkVisual(true) end
    end
    batDesyncTpConn = RunService.Heartbeat:Connect(tpBatUpdate)
    tpBatStartAntiDie()
    tpBatStartLagger()
    if batDesyncTpSetVisual then batDesyncTpSetVisual(true) end
    if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
end

function stopBatDesyncTp()
    batDesyncTpEnabled = false
    if batDesyncTpConn then
        batDesyncTpConn:Disconnect()
        batDesyncTpConn = nil
    end
    _tpBatHitCooldown = false
    tpBatStopAntiDie()
    tpBatStopLagger()
    local char = LP.Character
    local meRoot = char and char:FindFirstChild("HumanoidRootPart")
    if meRoot and meRoot.Parent then
        pcall(function()
            if meRoot.SetNetworkOwner then meRoot:SetNetworkOwner(LP) end
        end)
    end
    if _tpBatUnwalkForced then
        stopUnwalk()
        unwalkEnabled = false
        _tpBatUnwalkForced = false
        if setUnwalkVisual then setUnwalkVisual(false) end
    end
    if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
    if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
end

function toggleBatDesyncTp()
    if batDesyncTpEnabled then
        stopBatDesyncTp()
    else
        disableAllAimbots()
        if autoLeftEnabled then
            autoLeftEnabled = false; stopAutoLeft()
            if autoLeftSetVisual then autoLeftSetVisual(false) end
            if mobSetAutoLeft then mobSetAutoLeft(false) end
        end
        if autoRightEnabled then
            autoRightEnabled = false; stopAutoRight()
            if autoRightSetVisual then autoRightSetVisual(false) end
            if mobSetAutoRight then mobSetAutoRight(false) end
        end
        startBatDesyncTp()
    end
    if batDesyncTpSetVisual then batDesyncTpSetVisual(batDesyncTpEnabled) end
    saveAllSettings()
end

LP.CharacterAdded:Connect(function(char)
    task.wait(0.15)
    if batDesyncTpEnabled and not batDesyncTpConn then
        startBatDesyncTp()
    end
end)

-- ============================================================
-- BAT BYPASS
-- ============================================================
_G._RaptureBatBypass = _G._RaptureBatBypass or {
    enabled = false, conn = nil, safetyConn = nil, target = nil, equipped = false,
    intendedVelocity = Vector3.zero, attachment = nil, angularVelocity = nil,
    speed = 58, swingRange = 12,
}

local BAT_BYPASS_ANG = "_RaptureBypassAngV"
local BAT_BYPASS_ATT = "_RaptureBypassAtt"
local BAT_BYPASS_CLEAN = {
    "LockBAV","LockAngVel","LockBodyAtt","BatLock","LockBAVAtt",
    "AutoBatAtt","AutoBatAV","AntiBatDet","AntiAim","VelocityLock"
}

local function _batBypassCleanMovers(root)
    if not root then return end
    pcall(function()
        for _, n in ipairs(BAT_BYPASS_CLEAN) do
            local c = root:FindFirstChild(n)
            if c then c:Destroy() end
        end
    end)
end

local function _batBypassEnsureAngular(root)
    if not root then return end
    local B = _G._RaptureBatBypass
    pcall(function()
        local a = root:FindFirstChild(BAT_BYPASS_ANG); if a then a:Destroy() end
        local b = root:FindFirstChild(BAT_BYPASS_ATT); if b then b:Destroy() end
    end)
    local att = Instance.new("Attachment")
    att.Name = BAT_BYPASS_ATT
    att.Parent = root
    local angV = Instance.new("AngularVelocity")
    angV.Name = BAT_BYPASS_ANG
    angV.Attachment0 = att
    angV.RelativeTo = Enum.ActuatorRelativeTo.World
    angV.MaxTorque = math.huge
    angV.AngularVelocity = Vector3.zero
    angV.Parent = root
    B.attachment = att
    B.angularVelocity = angV
end

local function _batBypassRemoveAngular()
    local B = _G._RaptureBatBypass
    pcall(function() if B.angularVelocity and B.angularVelocity.Parent then B.angularVelocity:Destroy() end end)
    pcall(function() if B.attachment and B.attachment.Parent then B.attachment:Destroy() end end)
    B.angularVelocity = nil
    B.attachment = nil
end

local function _batBypassPickTarget(root)
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

local function _batBypassGetBat(char)
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

function _G.RaptureStopBatBypass(keepVisual)
    local B = _G._RaptureBatBypass
    B.enabled = false
    B.equipped = false
    B.target = nil
    if B.conn then B.conn:Disconnect(); B.conn = nil end
    if B.safetyConn then B.safetyConn:Disconnect(); B.safetyConn = nil end
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then pcall(function() root.Velocity = root.Velocity * 0.3 end) end
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if hum then hum.AutoRotate = true end
    if B.angularVelocity then pcall(function() B.angularVelocity.AngularVelocity = Vector3.zero end) end
    _batBypassRemoveAngular()
    if keepVisual ~= false then
        batBypassEnabled = false
        if batBypassSetVisual then batBypassSetVisual(false) end
        if batBypassFloatingButton then paintFloatingBtn(batBypassFloatingButton:FindFirstChild("Frame"), false) end
        if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
    end
end

function _G.RaptureStartBatBypass()
    local B = _G._RaptureBatBypass
    _G.RaptureStopBatBypass(false)
    B.enabled = true
    B.equipped = false
    B.target = nil
    B.intendedVelocity = Vector3.zero
    B.speed = BAT_AIMBOT_SPEED or 58
    local c = LP.Character
    local root = c and c:FindFirstChild("HumanoidRootPart")
    if root then
        _batBypassCleanMovers(root)
        _batBypassEnsureAngular(root)
    end
    B.conn = RunService.Heartbeat:Connect(function()
        if not B.enabled then return end
        local char = LP.Character
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp or not hum or hum.Health <= 0 then return end
        _batBypassCleanMovers(hrp)
        if not B.angularVelocity or not B.angularVelocity.Parent then _batBypassEnsureAngular(hrp) end
        if not B.equipped then
            B.equipped = true
            if not char:FindFirstChildOfClass("Tool") then
                local bat = _batBypassGetBat(char)
                if bat then pcall(function() hum:EquipTool(bat) end) end
            end
        end
        local target, dist = _batBypassPickTarget(hrp)
        if not target then
            B.target = nil
            hum.AutoRotate = true
            if B.angularVelocity then B.angularVelocity.AngularVelocity = Vector3.zero end
            return
        end
        B.target = target
        local aimPos = target.Position + target.CFrame.LookVector * (target.Velocity.Magnitude < 0.1 and 1.5 or 5)
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
            B.angularVelocity.AngularVelocity = Vector3.new(0, rotY, 0) + fwd * rotX
        else
            B.angularVelocity.AngularVelocity = Vector3.zero
        end
        local spd = tonumber(B.speed) or 58
        B.intendedVelocity = (flat.Magnitude > 0.1 and flat.Unit * spd or Vector3.zero)
            + (math.abs(delta.Y) > 0.8 and Vector3.new(0, math.sign(delta.Y) * spd, 0) or Vector3.new(0, -2, 0))
        hrp.AssemblyLinearVelocity = B.intendedVelocity
        hrp.Velocity = B.intendedVelocity
        if flat.Magnitude > 0.3 then pcall(function() hum:Move(flat.Unit, false) end)
        else pcall(function() hum:Move(Vector3.zero, false) end) end
        if dist <= B.swingRange then
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
    B.safetyConn = RunService.RenderStepped:Connect(function()
        if not B.enabled then return end
        local char = LP.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end
        if B.target and B.target.Parent then
            local delta = B.target.Position - hrp.Position
            local flat = Vector3.new(delta.X, 0, delta.Z)
            if flat.Magnitude > 0.3 then pcall(function() hum:Move(flat.Unit, false) end) end
            if math.abs(hrp.AssemblyLinearVelocity.X - B.intendedVelocity.X) > 30
               or math.abs(hrp.AssemblyLinearVelocity.Z - B.intendedVelocity.Z) > 30 then
                hrp.AssemblyLinearVelocity = B.intendedVelocity
            end
        end
        local v = hrp.Velocity
        if math.abs(v.X) > 350 or math.abs(v.Z) > 350 then hrp.Velocity = B.intendedVelocity end
        _batBypassCleanMovers(hrp)
    end)
    batBypassEnabled = true
    if batBypassSetVisual then batBypassSetVisual(true) end
    if batBypassFloatingButton then paintFloatingBtn(batBypassFloatingButton:FindFirstChild("Frame"), true) end
    if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
end

function _G.RaptureToggleBatBypass()
    if _G._RaptureBatBypass.enabled then
        _G.RaptureStopBatBypass()
    else
        disableAllAimbots()
        if autoLeftEnabled then
            autoLeftEnabled = false; stopAutoLeft()
            if autoLeftSetVisual then autoLeftSetVisual(false) end
            if mobSetAutoLeft then mobSetAutoLeft(false) end
        end
        if autoRightEnabled then
            autoRightEnabled = false; stopAutoRight()
            if autoRightSetVisual then autoRightSetVisual(false) end
            if mobSetAutoRight then mobSetAutoRight(false) end
        end
        _G.RaptureStartBatBypass()
    end
    saveAllSettings()
end

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if _G._RaptureBatBypass.enabled then
        _G._RaptureBatBypass.equipped = false
        _G._RaptureBatBypass.target = nil
        local hrp = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            _batBypassCleanMovers(hrp)
            _batBypassEnsureAngular(hrp)
        end
    end
end)

-- ============================================================
-- HELPERS
-- ============================================================
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
    if Conns.batCounter then Conns.batCounter:Disconnect(); Conns.batCounter = nil end
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
            task.spawn(function()
                task.wait(0.15)
                local bat = findBatForCounter()
                if bat then swingBatForCounter(bat, character) end
                task.wait(0.3)
                batCounterDebounce = false
            end)
        end
    end)
end

-- ============================================================
-- DROP BRAINROT
-- ============================================================
local DROP_ASCEND_DURATION = 0.22
local DROP_ASCEND_SPEED = 160
local _dropConn = nil

function stopDropBrainrot()
    dropActive = false
    if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
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
    dropActive = true
    if dropBrainrotSetVisual then dropBrainrotSetVisual(true) end
    if mobSetDropBR then mobSetDropBR(true) end
    local t0 = _tick()
    if _dropConn then _dropConn:Disconnect() end
    _dropConn = RunService.Heartbeat:Connect(function()
        local c = LP.Character
        local r = c and c:FindFirstChild("HumanoidRootPart")
        if not r then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            dropActive = false
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        if not dropActive then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        if _tick() - t0 >= DROP_ASCEND_DURATION then
            if _dropConn then _dropConn:Disconnect(); _dropConn = nil end
            pcall(function()
                local rp = RaycastParams.new()
                rp.FilterDescendantsInstances = {c}
                rp.FilterType = Enum.RaycastFilterType.Exclude
                local rr = workspace:Raycast(r.Position, _V3new(0, -3000, 0), rp)
                if rr then
                    local hum2 = c:FindFirstChildOfClass("Humanoid")
                    local off = ((hum2 and hum2.HipHeight) or 2) + (r.Size.Y / 2)
                    r.CFrame = _CFnew(r.Position.X, rr.Position.Y + off, r.Position.Z)
                    r.AssemblyLinearVelocity = _V3zero
                    r.AssemblyAngularVelocity = _V3zero
                end
                if hum2 and hum2.Health > 0 then hum2:ChangeState(Enum.HumanoidStateType.Running) end
            end)
            dropActive = false
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if mobSetDropBR then mobSetDropBR(false) end
            return
        end
        local lv = r.AssemblyLinearVelocity
        r.AssemblyLinearVelocity = _V3new(lv.X, DROP_ASCEND_SPEED, lv.Z)
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

-- ============================================================
-- FOV / STRETCH
-- ============================================================
CUSTOM_FOV_BIND = "RaptureDuelCustomFOV"

function enableCustomFov()
    local cam = workspace.CurrentCamera
    if cam and origFOV == nil then origFOV = cam.FieldOfView end
    fovEnabled = true
    if cam then
        pcall(function() cam.FieldOfViewMode = Enum.FieldOfViewMode.Diagonal end)
        pcall(function() cam.FieldOfView = fovValue end)
    end
    if customFovConn then customFovConn:Disconnect(); customFovConn = nil end
    pcall(function() RunService:UnbindFromRenderStep(CUSTOM_FOV_BIND) end)
    local prio = 200
    pcall(function() prio = Enum.RenderPriority.Camera.Value + 10 end)
    local ok = pcall(function()
        RunService:BindToRenderStep(CUSTOM_FOV_BIND, prio, function()
            if not fovEnabled then return end
            local c = workspace.CurrentCamera
            if c and c.FieldOfView ~= fovValue then c.FieldOfView = fovValue end
        end)
    end)
    if not ok then
        customFovConn = RunService.RenderStepped:Connect(function()
            if not fovEnabled then
                if customFovConn then customFovConn:Disconnect(); customFovConn = nil end
                return
            end
            local c = workspace.CurrentCamera
            if c then c.FieldOfView = fovValue end
        end)
    end
end

function disableCustomFov()
    fovEnabled = false
    pcall(function() RunService:UnbindFromRenderStep(CUSTOM_FOV_BIND) end)
    if customFovConn then customFovConn:Disconnect(); customFovConn = nil end
    local cam = workspace.CurrentCamera
    if cam then
        pcall(function() cam.FieldOfViewMode = Enum.FieldOfViewMode.Vertical end)
        pcall(function() cam.FieldOfView = origFOV or 70 end)
    end
end

function enableStretch()
    if stretchConn then return end
    stretchEnabled = true
    local cam = workspace.CurrentCamera
    if not cam then return end
    origFOV = cam.FieldOfView or 70
    local val = tonumber(stretchValue) or 0.7
    stretchConn = RunService.RenderStepped:Connect(function()
        if not stretchEnabled then
            stretchConn:Disconnect(); stretchConn = nil; return
        end
        local c = workspace.CurrentCamera
        if c then c.CFrame = c.CFrame * _CFnew(0,0,0,1,0,0,0,val,0,0,0,1) end
    end)
end

function disableStretch()
    stretchEnabled = false
    if stretchConn then stretchConn:Disconnect(); stretchConn = nil end
    local cam = workspace.CurrentCamera
    if cam then pcall(function() cam.FieldOfView = origFOV or 70 end) end
end

-- ============================================================
-- PINTAR BOTONES FLOTANTES
-- ============================================================
function paintFloatingBtn(btnFrame, active)
    if not btnFrame then return end
    local bg = btnFrame:FindFirstChild("BtnGrad")
    local label = btnFrame:FindFirstChild("TextLabel")
    local stroke = btnFrame:FindFirstChildOfClass("UIStroke")

    if active then
        btnFrame.BackgroundColor3 = PASTEL_PINK
        if bg then
            bg.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, PASTEL_PINK:Lerp(Color3.new(1,1,1), 0.55)),
                ColorSequenceKeypoint.new(0.45, PASTEL_PINK),
                ColorSequenceKeypoint.new(1.00, PASTEL_PINK:Lerp(Color3.new(0,0,0), 0.35)),
            })
        end
        if label then label.TextColor3 = Color3.fromRGB(0, 0, 0) end
        if stroke then
            stroke.Color = PASTEL_PINK
            stroke.Thickness = BTN_STROKE_THICKNESS
            stroke.Transparency = BTN_STROKE_TRANSPARENCY
        end
    else
        btnFrame.BackgroundColor3 = BTN_BG_DARK
        if bg then
            bg.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0.00, Color3.fromRGB(45, 45, 45)),
                ColorSequenceKeypoint.new(0.45, Color3.fromRGB(20, 20, 20)),
                ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0)),
            })
        end
        if label then label.TextColor3 = PASTEL_PINK end
        if stroke then
            stroke.Color = Color3.fromRGB(0, 0, 0)
            stroke.Thickness = BTN_STROKE_THICKNESS
            stroke.Transparency = BTN_STROKE_TRANSPARENCY
        end
    end
end

function applyFloatingButtonScale()
    for _, uiScale in ipairs(_floatingUIScales) do
        if uiScale and uiScale.Parent then uiScale.Scale = floatingButtonScale end
    end
end

local function drag(f)
    local dn, ds, sp, di = false, nil, nil, nil
    local endConn = nil
    local function stopDrag()
        dn = false; di = nil
        if endConn then endConn:Disconnect(); endConn = nil end
    end
    f.InputBegan:Connect(function(i)
        if uiLocked then return end
        if _isDraggingButton then return end
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
            dn = true; ds = i.Position; sp = f.Position
            if endConn then endConn:Disconnect() end
            endConn = i.Changed:Connect(function()
                if i.UserInputState == Enum.UserInputState.End then stopDrag() end
            end)
        end
    end)
    f.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then stopDrag() end
    end)
    UIS.InputEnded:Connect(function(i)
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then stopDrag() end
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
                        if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
                    end
                end
            end
        end
    end)
    movementLoop = RunService.Heartbeat:Connect(function()
        local char2 = LP.Character
        if not char2 then return end
        local hum = char2:FindFirstChildOfClass("Humanoid")
        local hrp = char2:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp then return end
        if not autoBatEnabled and not autoLeftEnabled and not autoRightEnabled
           and not batDesyncTpEnabled
           and not (_G._RaptureBatBypass and _G._RaptureBatBypass.enabled) then
            if _isRagdollState(hum) then
                lastMoveDir = _V3zero
            else
                local md = hum.MoveDirection
                local spd = getActiveMoveSpeed()
                local dir = nil
                if md.Magnitude > 0 then
                    lastMoveDir = md
                    dir = md
                elseif lastMoveDir.Magnitude > 0 then
                    for key in pairs(MOVE_KEYS) do
                        if UIS:IsKeyDown(key) then dir = lastMoveDir; break end
                    end
                end
                _applyVelocitySpeed(dir, spd, hrp)
            end
        end
        if speedLabel then
            speedLabel.Text = "Speed: " .. string.format("%.1f", getActiveMoveSpeed())
        end
    end)
    setupSpeedIndicator(char)
    startEnemySpeed()
end

function toggleLockUI(state)
    if state == nil then uiLocked = not uiLocked else uiLocked = state end
    if setLockUIVisual then setLockUIVisual(uiLocked) end
    if lockBtn then lockBtn.Text = uiLocked and "🔒" or "🔓" end
    saveAllSettings()
end

function disableAllAimbots()
    if autoBatEnabled then
        disableAutoBat()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
    end
    if batDesyncTpEnabled then stopBatDesyncTp() end
    if _G._RaptureBatBypass and _G._RaptureBatBypass.enabled then _G.RaptureStopBatBypass() end
end

function stopAllBackgroundTasks()
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    stopEnemySpeed()
    if stretchEnabled then disableStretch() end
    if AntiRagdollV1.isRunning() then AntiRagdollV1.stop() end
    if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
    if antiFlingEnabled then stopAntiFling() end
    if antiDieEnabled then _antiDie.StopEngine() end
    stopBatCounter()
    stopMedusaCounter()
    stopAutoSteal()
    disableAutoBat()
    if batDesyncTpEnabled then stopBatDesyncTp() end
    if _G._RaptureBatBypass and _G._RaptureBatBypass.enabled then _G.RaptureStopBatBypass() end
    stopAutoLeft()
    stopAutoRight()
    if unwalkEnabled and not _tpBatUnwalkForced then stopUnwalk() end
    if antiLagEnabled then disableAntiLag() end
    if dropActive then stopDropBrainrot() end
    if espEnabled then stopESP() end
    dropActive = false
    alPhase = 1
    arPhase = 1
    lastDropTime = 0
    medusaDebounce = false
    medusaLastUsed = 0
end

-- ============================================================
-- SAVE / LOAD
-- ============================================================
function buildConfigTable()
    local config = {
        normalSpeed = NS, carrySpeed = CS,
        laggerSpeed1 = LAGGER_SPEED, laggerSpeed2 = LAGGER_CARRY_SPEED,
        stealRadius = CONFIG.STEAL_RANGE,
        antiRagdollEnabled = antiRagdollEnabled,
        antiRagdollVersion = antiRagdollVersion,
        antiFlingEnabled = antiFlingEnabled,
        antiDieEnabled = antiDieEnabled,
        autoSteal = CONFIG.AUTO_STEAL_ENABLED,
        medusaCounter = medusaCounterEnabled,
        batCounter = batCounterEnabled,
        ragdollCountdown = ragdollCountdownEnabled,
        laggerToggled = laggerToggled,
        laggerCarryToggled = laggerCarryToggled,
        carryMode = speedMode,
        batAimbotSpeed = BAT_AIMBOT_SPEED,
        aimbotMode = aimbotMode,
        dropMode = 2,
        stretchEnabled = stretchEnabled, stretchFOV = stretchFOV, stretchValue = stretchValue,
        fovEnabled = fovEnabled, fovValue = fovValue,
        uiScale = uiScaleValue, progressBarScale = progressBarScaleValue,
        tpBatEnabled = batDesyncTpEnabled,
        batBypassEnabled = batBypassEnabled,
        espEnabled = espEnabled, antiLag = antiLagEnabled,
        customSounds     = customSoundsEnabled,
        minecraftBatSkinEnabled = minecraftBatSkinEnabled,
        minecraftBatSkinColorMode = minecraftBatSkinColorMode,
        mobileButtonPositions = savedButtonPositions,
        dropBrainrotKey = {kb = KB.DropBrainrot.kb and KB.DropBrainrot.kb.Name, gp = KB.DropBrainrot.gp and KB.DropBrainrot.gp.Name},
        autoLeftKey = {kb = KB.AutoLeft.kb and KB.AutoLeft.kb.Name, gp = KB.AutoLeft.gp and KB.AutoLeft.gp.Name},
        autoRightKey = {kb = KB.AutoRight.kb and KB.AutoRight.kb.Name, gp = KB.AutoRight.gp and KB.AutoRight.gp.Name},
        autoBatKey = {kb = KB.AutoBat.kb and KB.AutoBat.kb.Name, gp = KB.AutoBat.gp and KB.AutoBat.gp.Name},
        tpFloorKey = {kb = KB.TPFloor.kb and KB.TPFloor.kb.Name, gp = KB.TPFloor.gp and KB.TPFloor.gp.Name},
        carryToggleKey = {kb = KB.CarryToggle.kb and KB.CarryToggle.kb.Name, gp = KB.CarryToggle.gp and KB.CarryToggle.gp.Name},
        laggerModeKey = {kb = KB.LaggerMode.kb and KB.LaggerMode.kb.Name, gp = KB.LaggerMode.gp and KB.LaggerMode.gp.Name},
        tpBatKey = {kb = KB.TPBat.kb and KB.TPBat.kb.Name, gp = KB.TPBat.gp and KB.TPBat.gp.Name},
        instaResetKey = {kb = KB.InstaReset.kb and KB.InstaReset.kb.Name, gp = KB.InstaReset.gp and KB.InstaReset.gp.Name},
        batBypassKey = {kb = KB.BatBypass.kb and KB.BatBypass.kb.Name, gp = KB.BatBypass.gp and KB.BatBypass.gp.Name},
        tpBatFloatingPos = tpBatFloatingPos,
        batBypassFloatingPos = batBypassFloatingPos,
        instaResetFloatingPos = instaResetFloatingPos,
        progressBarPos = savedProgressBarPos, lockUI = uiLocked,
        backgroundIndex = backgroundIndex,
        backgroundImageTransparency = backgroundImageTransparency,
        floatingButtonScale = floatingButtonScale,
        skipIntro = true,
    }
    if pbFrame then
        config.progressBarPos = {
            XScale = pbFrame.Position.X.Scale, XOffset = pbFrame.Position.X.Offset,
            YScale = pbFrame.Position.Y.Scale, YOffset = pbFrame.Position.Y.Offset
        }
    end
    return config
end

function saveAllSettings()
    if _isResetting then return true end
    local config = buildConfigTable()
    local json = HS:JSONEncode(config)
    if json == _lastSavedJSON then return true end
    local success, err = pcall(function() writefile(CONFIG_FILE, json) end)
    if success then _lastSavedJSON = json end
    return success
end

function saveAmbitiousConfig() saveAllSettings() end

function loadAllSettings()
    if not isfile or not isfile(CONFIG_FILE) then return false end
    local success, data = pcall(function() return HS:JSONDecode(readfile(CONFIG_FILE)) end)
    if not success or not data then return false end
    _isLoading = true
    NS = data.normalSpeed or NS
    CS = data.carrySpeed or CS
    LAGGER_SPEED = data.laggerSpeed1 or LAGGER_SPEED
    LAGGER_CARRY_SPEED = data.laggerSpeed2 or LAGGER_CARRY_SPEED
    CONFIG.STEAL_RANGE = data.stealRadius or CONFIG.STEAL_RANGE
    stealMode = "V2"
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    uiLocked = data.lockUI or true
    antiRagdollEnabled = data.antiRagdollEnabled or false
    if data.antiRagdollVersion then
        antiRagdollVersion = data.antiRagdollVersion
        if antiRagdollVersion ~= "v2" then antiRagdollVersion = "v1" end
    else antiRagdollVersion = "v1" end
    antiFlingEnabled = data.antiFlingEnabled or false
    antiDieEnabled = data.antiDieEnabled or false
    CONFIG.AUTO_STEAL_ENABLED = data.autoSteal or false
    medusaCounterEnabled = data.medusaCounter or false
    batCounterEnabled = data.batCounter or false
    ragdollCountdownEnabled = data.ragdollCountdown or false
    laggerToggled = data.laggerToggled or false
    speedMode = data.carryMode or false
    laggerCarryToggled = data.laggerCarryToggled or false
    espEnabled = data.espEnabled or false
    antiLagEnabled = data.antiLag or false
    if data.aimbotMode then
        aimbotMode = data.aimbotMode
        if aimbotMode ~= "V2" then aimbotMode = "V1" end
    else aimbotMode = "V1" end
    customSoundsEnabled     = data.customSounds == true
    batBypassEnabled        = data.batBypassEnabled == true
    minecraftBatSkinEnabled = data.minecraftBatSkinEnabled == true
    minecraftBatSkinColorMode = data.minecraftBatSkinColorMode or "Default"
    uiScaleValue = data.uiScale or uiScaleValue
    progressBarScaleValue = data.progressBarScale or progressBarScaleValue
    if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
    if pbScale then pbScale.Scale = progressBarScaleValue / 100 end
    local tpBatStateLoaded = data.tpBatEnabled or false
    if tpBatStateLoaded then
        task.defer(function()
            startBatDesyncTp()
            if batDesyncTpSetVisual then batDesyncTpSetVisual(true) end
        end)
    else
        if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
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
    lk(KB.CarryToggle, data.carryToggleKey)
    lk(KB.LaggerMode, data.laggerModeKey)
    lk(KB.TPBat, data.tpBatKey)
    lk(KB.InstaReset, data.instaResetKey)
    lk(KB.BatBypass, data.batBypassKey)
    if data.mobileButtonPositions then savedButtonPositions = data.mobileButtonPositions end
    if data.mobilePanelPos then savedMobilePanelPos = data.mobilePanelPos end
    if data.tpBatFloatingPos then tpBatFloatingPos = data.tpBatFloatingPos end
    if data.batBypassFloatingPos then batBypassFloatingPos = data.batBypassFloatingPos end
    if data.instaResetFloatingPos then instaResetFloatingPos = data.instaResetFloatingPos end
    if data.progressBarPos then savedProgressBarPos = data.progressBarPos end
    stretchEnabled = data.stretchEnabled or false
    stretchValue = data.stretchValue or 0.7
    fovValue = data.fovValue or 70
    fovEnabled = data.fovEnabled or false
    if fovSliderSet then fovSliderSet(fovValue) end
    if fovEnabled then enableCustomFov() end
    if setFovVisual then setFovVisual(fovEnabled) end
    stretchFOV = data.stretchFOV or 120
    BAT_AIMBOT_SPEED = data.batAimbotSpeed or BAT_AIMBOT_SPEED
    backgroundIndex = data.backgroundIndex or 1
    if backgroundIndex < 1 or backgroundIndex > #backgroundImages then backgroundIndex = 1 end
    backgroundImageTransparency = data.backgroundImageTransparency or 0
    floatingButtonScale = data.floatingButtonScale or floatingButtonScale
    autoBatEnabled = false
    autoLeftEnabled = false
    autoRightEnabled = false
    refreshSpeedModeLabel()
    _lastSavedJSON = HS:JSONEncode(buildConfigTable())
    _isLoading = false
    return true
end

function resetToFactoryDefaults()
    _isResetting = true
    local ok, err = pcall(function()
        stopAllBackgroundTasks()
        NS = 60; CS = 29; LAGGER_SPEED = 15; LAGGER_CARRY_SPEED = 24.5
        CONFIG.STEAL_RANGE = 61
        stealMode = "V2"
        speedMode = false; laggerToggled = false; laggerCarryToggled = false
        antiRagdollEnabled = false; antiRagdollVersion = "v1"
        antiFlingEnabled = false; antiDieEnabled = false
        medusaCounterEnabled = false; batCounterEnabled = false; ragdollCountdownEnabled = false
        autoBatEnabled = false; autoLeftEnabled = false; autoRightEnabled = false
        unwalkEnabled = false; uiLocked = true
        CONFIG.AUTO_STEAL_ENABLED = false
        BAT_AIMBOT_SPEED = 58
        aimbotMode = "V1"
        customSoundsEnabled = false
        batBypassEnabled = false
        minecraftBatSkinEnabled = false
        minecraftBatSkinColorMode = "Default"
        if _G._RaptureBatBypass and _G._RaptureBatBypass.enabled then _G.RaptureStopBatBypass() end
        if deactivateAllBatSkins then pcall(deactivateAllBatSkins) end
        stretchEnabled = false; stretchValue = 0.7; fovValue = 70
        uiScaleValue = 66; progressBarScaleValue = 55
        backgroundIndex = 1; floatingButtonScale = 1
        espEnabled = false; antiLagEnabled = false
        for key, val in pairs(DEFAULT_KB) do
            if KB[key] then KB[key].kb = val.kb; KB[key].gp = val.gp end
        end
        if isfile and isfile(CONFIG_FILE) then pcall(delfile, CONFIG_FILE) end
        savedButtonPositions = {}
        if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
            local container = MobilePanel:FindFirstChild("FloatingPanel")
            if container:FindFirstChild("ButtonsContainer") then
                for _, btn in ipairs(container.ButtonsContainer:GetChildren()) do
                    if btn:IsA("TextButton") and btn.Name then
                        local defX, defY = getDefaultButtonPosition(btn.Name)
                        btn.Position = UDim2.new(0, defX, 0, defY)
                    end
                end
            end
        end
        task.defer(function()
            if setAntiRagVisual then setAntiRagVisual(false) end
            if setInstaGrab then setInstaGrab(false) end
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if setBatCounterVisual then setBatCounterVisual(false) end
            if setMedusaVisual then setMedusaVisual(false) end
            if setRagdollTimerVisual then setRagdollTimerVisual(false) end
            if autoLeftSetVisual then autoLeftSetVisual(false) end
            if autoRightSetVisual then autoRightSetVisual(false) end
            if autoBatSetVisual then autoBatSetVisual(false) end
            if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
            if batBypassSetVisual then batBypassSetVisual(false) end
            if setESPVisual then setESPVisual(false) end
            if setAntiLagVisual then setAntiLagVisual(false) end
            if setFovVisual then setFovVisual(false) end
            if setAntiDieVisual then setAntiDieVisual(false) end
            if setAntiFlingVisual then setAntiFlingVisual(false) end
            if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
            if aimbotModeSetVisual then aimbotModeSetVisual("V1") end
            if antiRagSetVisual then antiRagSetVisual("V1") end
            if _G.RaptureCustomSounds then _G.RaptureCustomSounds.setEnabled(false) end
            refreshSpeedModeLabel()
        end)
        updateAllUIThemeColors(PASTEL_PINK)
        _RaptureApplyThemeToSliders()
        _lastSavedJSON = nil
        saveAllSettings()
    end)
    _isResetting = false
    return ok
end

function updateProgressBarVisibility()
    if pbFrame then pbFrame.Visible = true end
end

function getDefaultButtonPosition(btnName)
    local BTN_W, BTN_H = 60, 60
    local GAP = 8
    local orderMap = {
        DropBR = 0, AutoLeft = 1, AutoBat = 2, AutoRight = 3,
        TpDown = 4, Carry = 5, Lagger1 = 6, Lagger2 = 7
    }
    local order = orderMap[btnName] or 0
    local row = _floor(order / 2)
    local col = order % 2
    return -(col + 1) * (BTN_W + GAP) - 10, row * (BTN_H + GAP + 10)
end

-- ============================================================
-- ENEMY SPEED LABELS
-- ============================================================
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

-- ============================================================
-- INSTA RESET
-- ============================================================
do
    if not _G.InstaResetLoaded then
        _G.InstaResetLoaded = true
        local resetCooldown = false
        local resetThread = nil
        local _lastInstaResetRequest = 0
        local function instaResetFast()
            if resetCooldown then return end
            resetCooldown = true
            local character = LP.Character
            if not character then resetCooldown = false return end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then resetCooldown = false return end
            resetThread = task.spawn(function()
                local attempts = 0
                while character and character.Parent and humanoid and humanoid.Health > 0 and attempts < 40 do
                    if LP.Character ~= character then break end
                    pcall(function()
                        humanoid.HipHeight = 1e30
                        humanoid.AutoRotate = true
                        local rootPart = character:FindFirstChild("HumanoidRootPart")
                        if rootPart then rootPart.CanCollide = false end
                    end)
                    if not character or not character.Parent or humanoid.Health <= 0 then break end
                    attempts = attempts + 1
                    task.wait(0.05)
                end
                if character and character.Parent and humanoid and humanoid.Health > 0 then
                    pcall(function() humanoid.Health = 0 end)
                end
                resetCooldown = false
                resetThread = nil
            end)
        end
        local function instaReset()
            local now = os.clock()
            if now - _lastInstaResetRequest < 0.75 then return end
            _lastInstaResetRequest = now
            instaResetFast()
        end
        LP.CharacterAdded:Connect(function()
            if resetThread then pcall(task.cancel, resetThread); resetThread = nil end
            resetCooldown = false
        end)
        _G.InstaReset = { Trigger = instaReset }
    end
end

-- ============================================================
-- MINECRAFT BAT SKIN
-- ============================================================
minecraftBatSkinEnabled = false
minecraftBatSkinColorMode = "Default"

local MinecraftBatSkin = (function()
    local MB_ASSET_ID = "rbxassetid://18566246244"
    local MB_POS_OFFSET = _CFnew(-0.02, -0.52, -0.2)
    local MB_ROT_OFFSET = CFrame.Angles(math.rad(45), math.rad(0), math.rad(5))
    local MB_SCALE = 2

    local MB_COLORS = {
        ["Default"] = nil,
        ["Abyss Blue"] = Color3.fromRGB(0, 40, 150),
        ["Venom Green"] = Color3.fromRGB(20, 255, 50),
        ["Royal Gold"] = Color3.fromRGB(255, 200, 0),
        ["Velvet Rose"] = Color3.fromRGB(220, 20, 100),
        ["Crimson Night"] = Color3.fromRGB(90, 0, 20),
        ["RGB"] = "RGB",
    }

    local State = { enabled = false, colorMode = "Default", cachedVisualPart = nil, rgbConnection = nil }

    local okLoad, objects = pcall(function() return game:GetObjects(MB_ASSET_ID) end)
    if okLoad and objects and #objects > 0 then
        local model = objects[1]
        State.cachedVisualPart = model:IsA("BasePart") and model or model:FindFirstChildWhichIsA("BasePart", true)
    end

    local function mbSetColor(visual, color)
        if not visual or not color then return end
        visual.Color = color
        if visual:IsA("UnionOperation") then
            pcall(function() visual.UsePartColor = true end)
        end
        local sm = visual:FindFirstChildWhichIsA("SpecialMesh")
        if sm then sm.VertexColor = Vector3.new(color.R, color.G, color.B) end
    end

    local function mbFindBat()
        local char = LP.Character
        if char then
            local t = char:FindFirstChild("Bat")
            if t and t:IsA("Tool") then return t end
        end
        local bp = LP:FindFirstChildOfClass("Backpack")
        if bp then
            local t = bp:FindFirstChild("Bat")
            if t and t:IsA("Tool") then return t end
        end
        return nil
    end

    local function mbRemoveVisual(tool)
        if not tool then return end
        local old = tool:FindFirstChild("CustomUnionVisual")
        if old then pcall(function() old:Destroy() end) end
        local handle = tool:FindFirstChild("Handle")
        if handle then
            handle.Transparency = 0
            for _, child in ipairs(handle:GetChildren()) do
                if child:IsA("SpecialMesh") or child:IsA("Mesh") or child:IsA("Decal") then
                    pcall(function() child.Transparency = 0 end)
                end
            end
        end
    end

    local function mbApplyVisual(tool)
        if not tool or tool.Name ~= "Bat" or not State.cachedVisualPart then return end
        local handle = tool:WaitForChild("Handle", 2)
        if not handle then return end
        local oldVisual = tool:FindFirstChild("CustomUnionVisual")
        if oldVisual then oldVisual:Destroy() end
        handle.Transparency = 1
        for _, child in ipairs(handle:GetChildren()) do
            if child:IsA("SpecialMesh") or child:IsA("Mesh") or child:IsA("Decal") then
                pcall(function() child.Transparency = 1 end)
            end
        end
        local newVisual = State.cachedVisualPart:Clone()
        newVisual.Name = "CustomUnionVisual"
        newVisual.CanCollide = false; newVisual.Massless = true; newVisual.Anchored = false
        local tempModel = Instance.new("Model")
        newVisual.Parent = tempModel
        tempModel.PrimaryPart = newVisual
        pcall(function() tempModel:ScaleTo(MB_SCALE) end)
        newVisual.Parent = nil
        tempModel:Destroy()
        if State.colorMode == "RGB" then
            mbSetColor(newVisual, Color3.fromHSV(tick() % 3 / 3, 1, 1))
        elseif MB_COLORS[State.colorMode] then
            mbSetColor(newVisual, MB_COLORS[State.colorMode])
        end
        for _, child in ipairs(newVisual:GetChildren()) do
            if child:IsA("Weld") or child:IsA("WeldConstraint") then child:Destroy() end
        end
        newVisual.CFrame = handle.CFrame * MB_POS_OFFSET * MB_ROT_OFFSET
        newVisual.Parent = tool
        local weld = Instance.new("WeldConstraint")
        weld.Part0 = handle; weld.Part1 = newVisual; weld.Parent = newVisual
    end

    local function mbStartRGB()
        if State.rgbConnection then return end
        State.rgbConnection = RunService.RenderStepped:Connect(function()
            if not State.enabled or State.colorMode ~= "RGB" then return end
            local tool = mbFindBat()
            if not tool then return end
            local visual = tool:FindFirstChild("CustomUnionVisual")
            if visual then mbSetColor(visual, Color3.fromHSV(tick() % 3 / 3, 1, 1)) end
        end)
    end

    local function mbStopRGB()
        if State.rgbConnection then
            State.rgbConnection:Disconnect(); State.rgbConnection = nil
        end
    end

    return {
        State = State, Colors = MB_COLORS,
        FindBat = mbFindBat,
        Apply = function()
            if not State.enabled then return end
            local tool = mbFindBat()
            if tool then mbApplyVisual(tool) end
            if State.colorMode == "RGB" then mbStartRGB() end
        end,
        Remove = function()
            mbStopRGB()
            local char = LP.Character
            if char then
                local t = char:FindFirstChild("Bat")
                if t then mbRemoveVisual(t) end
            end
            local bp = LP:FindFirstChildOfClass("Backpack")
            if bp then
                local t = bp:FindFirstChild("Bat")
                if t then mbRemoveVisual(t) end
            end
        end,
        SetColorMode = function(mode)
            State.colorMode = mode
            if not State.enabled then return end
            if mode == "RGB" then mbStartRGB() else mbStopRGB() end
            local tool = mbFindBat()
            if tool then mbApplyVisual(tool) end
        end,
    }
end)()

task.spawn(function()
    while true do
        if minecraftBatSkinEnabled then
            MinecraftBatSkin.State.enabled = true
            local tool = MinecraftBatSkin.FindBat()
            if tool and not tool:FindFirstChild("CustomUnionVisual") then
                pcall(MinecraftBatSkin.Apply)
            end
        else
            MinecraftBatSkin.State.enabled = false
        end
        task.wait(0.5)
    end
end)

function deactivateAllBatSkins()
    minecraftBatSkinEnabled = false
    MinecraftBatSkin.State.enabled = false
    pcall(MinecraftBatSkin.Remove)
end

-- ============================================================
-- BAT SKIN PICKER
-- ============================================================
function openBatSkinPicker()
    pcall(function()
        local old = CoreGui:FindFirstChild("RaptureBatSkinPicker")
        if old then old:Destroy() end
        local pg = LP:FindFirstChild("PlayerGui")
        if pg then local o = pg:FindFirstChild("RaptureBatSkinPicker"); if o then o:Destroy() end end
    end)

    local viewer = Instance.new("ScreenGui")
    viewer.Name = "RaptureBatSkinPicker"
    viewer.ResetOnSpawn = false
    viewer.IgnoreGuiInset = true
    viewer.DisplayOrder = 401
    if not pcall(function() viewer.Parent = CoreGui end) then viewer.Parent = LP:WaitForChild("PlayerGui") end

    local function closeViewer()
        if viewer then pcall(function() viewer:Destroy() end) end
    end

    local dim = Instance.new("TextButton", viewer)
    dim.Size = UDim2.new(1, 0, 1, 0)
    dim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    dim.BackgroundTransparency = 0.45
    dim.Text = ""
    dim.AutoButtonColor = false
    dim.ZIndex = 1
    dim.Activated:Connect(closeViewer)

    local frame = Instance.new("Frame", viewer)
    frame.Size = UDim2.new(0, 400, 0, 520)
    frame.Position = UDim2.new(0.5, -200, 0.5, -260)
    frame.BackgroundColor3 = Color3.fromRGB(12, 10, 16)
    frame.BorderSizePixel = 0
    frame.ZIndex = 2
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
    local st = Instance.new("UIStroke", frame)
    st.Color = Color3.fromRGB(60, 50, 75)
    st.Thickness = 1.8

    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, -60, 0, 30)
    title.Position = UDim2.new(0, 12, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = "MINECRAFT BAT SKIN"
    title.TextColor3 = Color3.fromRGB(255, 255, 255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 3

    local close = Instance.new("TextButton", frame)
    close.Size = UDim2.new(0, 28, 0, 28)
    close.Position = UDim2.new(1, -34, 0, 8)
    close.BackgroundColor3 = Color3.fromRGB(28, 26, 36)
    close.BorderSizePixel = 0
    close.Text = "X"
    close.TextColor3 = Color3.fromRGB(255, 255, 255)
    close.Font = Enum.Font.GothamBlack
    close.TextSize = 14
    close.ZIndex = 4
    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)
    close.Activated:Connect(closeViewer)

    local scroll = Instance.new("ScrollingFrame", frame)
    scroll.Size = UDim2.new(1, -16, 1, -52)
    scroll.Position = UDim2.new(0, 8, 0, 44)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 5
    scroll.ScrollBarImageColor3 = PASTEL_PINK
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ZIndex = 3

    local listLayout = Instance.new("UIListLayout", scroll)
    listLayout.Padding = UDim.new(0, 8)
    listLayout.SortOrder = Enum.SortOrder.LayoutOrder
    listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

    local orderCounter = 0
    local function nextOrder()
        orderCounter = orderCounter + 1
        return orderCounter
    end

    local mcColorOptions = {
        { name = "Default", color = Color3.fromRGB(180, 180, 190) },
        { name = "Abyss Blue", color = Color3.fromRGB(0, 40, 150) },
        { name = "Venom Green", color = Color3.fromRGB(20, 255, 50) },
        { name = "Royal Gold", color = Color3.fromRGB(255, 200, 0) },
        { name = "Velvet Rose", color = Color3.fromRGB(220, 20, 100) },
        { name = "Crimson Night", color = Color3.fromRGB(90, 0, 20) },
        { name = "RGB", color = Color3.fromRGB(255, 0, 255) },
    }

    local mcButtons = {}
    local function refreshMcButtons()
        for name, btn in pairs(mcButtons) do
            local isActive = minecraftBatSkinEnabled and (minecraftBatSkinColorMode == name)
            local bst = btn:FindFirstChildOfClass("UIStroke")
            if isActive then
                btn.BackgroundColor3 = PASTEL_PINK
                if bst then bst.Color = PASTEL_PINK; bst.Transparency = 0 end
                btn.TextColor3 = Color3.fromRGB(0, 0, 0)
            else
                btn.BackgroundColor3 = Color3.fromRGB(20, 18, 26)
                if bst then bst.Color = Color3.fromRGB(60, 50, 75); bst.Transparency = 0.4 end
                btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            end
        end
    end

    for _, opt in ipairs(mcColorOptions) do
        local btn = Instance.new("TextButton", scroll)
        btn.Size = UDim2.new(1, -8, 0, 34)
        btn.BackgroundColor3 = Color3.fromRGB(20, 18, 26)
        btn.BorderSizePixel = 0
        btn.Text = "  " .. opt.name
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 12
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.AutoButtonColor = false
        btn.LayoutOrder = nextOrder()
        btn.ZIndex = 4
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local bst = Instance.new("UIStroke", btn)
        bst.Color = Color3.fromRGB(60, 50, 75)
        bst.Thickness = 1.4
        bst.Transparency = 0.4
        local colorDot = Instance.new("Frame", btn)
        colorDot.Size = UDim2.new(0, 16, 0, 16)
        colorDot.Position = UDim2.new(1, -26, 0.5, -8)
        colorDot.BackgroundColor3 = opt.color
        colorDot.BorderSizePixel = 0
        colorDot.ZIndex = 5
        Instance.new("UICorner", colorDot).CornerRadius = UDim.new(1, 0)
        mcButtons[opt.name] = btn
        btn.Activated:Connect(function()
            deactivateAllBatSkins()
            minecraftBatSkinEnabled = true
            minecraftBatSkinColorMode = opt.name
            MinecraftBatSkin.State.enabled = true
            MinecraftBatSkin.SetColorMode(opt.name)
            MinecraftBatSkin.Apply()
            refreshMcButtons()
            pcall(saveAllSettings)
            task.delay(0.15, closeViewer)
        end)
    end

    local sep2 = Instance.new("Frame", scroll)
    sep2.Size = UDim2.new(1, -20, 0, 1)
    sep2.BackgroundColor3 = Color3.fromRGB(60, 50, 75)
    sep2.BorderSizePixel = 0
    sep2.LayoutOrder = nextOrder()
    sep2.ZIndex = 4

    local noneBtn = Instance.new("TextButton", scroll)
    noneBtn.Size = UDim2.new(1, -8, 0, 34)
    noneBtn.BackgroundColor3 = Color3.fromRGB(40, 10, 20)
    noneBtn.BorderSizePixel = 0
    noneBtn.Text = "  Desactivar skin"
    noneBtn.TextColor3 = Color3.fromRGB(255, 180, 200)
    noneBtn.Font = Enum.Font.GothamBold
    noneBtn.TextSize = 12
    noneBtn.TextXAlignment = Enum.TextXAlignment.Left
    noneBtn.AutoButtonColor = false
    noneBtn.LayoutOrder = nextOrder()
    noneBtn.ZIndex = 4
    Instance.new("UICorner", noneBtn).CornerRadius = UDim.new(0, 8)
    local nst = Instance.new("UIStroke", noneBtn)
    nst.Color = Color3.fromRGB(120, 40, 70)
    nst.Thickness = 1.4
    nst.Transparency = 0.3
    noneBtn.Activated:Connect(function()
        deactivateAllBatSkins()
        refreshMcButtons()
        pcall(saveAllSettings)
        task.delay(0.15, closeViewer)
    end)

    refreshMcButtons()
end

-- ============================================================
-- BUILD GUI
-- ============================================================
function buildGui()
    local ROW_BG = Color3.fromRGB(0, 0, 0)
    local WHITE = Color3.fromRGB(255, 255, 255)
    local INP = Color3.fromRGB(10, 10, 10)
    local TAB_INACT = Color3.fromRGB(235, 235, 245)
    local GUI_W, GUI_H = 360, 520

    local old = CoreGui:FindFirstChild("RaptureDuel")
    if old then old:Destroy() end
    local pg = LP:FindFirstChild("PlayerGui")
    if pg then local o = pg:FindFirstChild("RaptureDuel"); if o then o:Destroy() end end

    gui = Instance.new("ScreenGui")
    gui.Name = "RaptureDuel"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 10
    gui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    local guiOk = pcall(function() gui.Parent = CoreGui end)
    if not guiOk then gui.Parent = LP:WaitForChild("PlayerGui") end

    main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, GUI_W, 0, GUI_H)
    main.Position = UDim2.new(0, 20, 0, 2)
    main.BackgroundColor3 = Color3.fromRGB(12, 10, 16)
    main.BackgroundTransparency = 1
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)

    local bgImage = Instance.new("ImageLabel", main)
    bgImage.Name = "BackgroundImage"
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.Position = UDim2.new(0, 0, 0, 0)
    bgImage.BackgroundColor3 = Color3.fromRGB(12, 10, 16)
    bgImage.BackgroundTransparency = 0
    bgImage.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
    bgImage.ImageTransparency = backgroundImageTransparency
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ZIndex = 0
    bgImage.ClipsDescendants = true
    Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 18)

    local topImage = Instance.new("ImageLabel", main)
    topImage.Name = "TopImage"
    topImage.Size = UDim2.new(0, 380, 0, 95)
    topImage.Position = UDim2.new(0.5, -190, 0, -10)
    topImage.BackgroundTransparency = 1
    topImage.Image = "rbxassetid://99633112120425"
    topImage.ScaleType = Enum.ScaleType.Fit
    topImage.ZIndex = 15
    topImage.Parent = main

    mainUIScale = Instance.new("UIScale", main)
    mainUIScale.Scale = uiScaleValue / 100

    local titleFrame = Instance.new("Frame", main)
    titleFrame.Size = UDim2.new(1, -140, 0, 40)
    titleFrame.Position = UDim2.new(0, 30, 0, 84)
    titleFrame.BackgroundTransparency = 1
    titleFrame.ZIndex = 20

    titleLbl = Instance.new("TextLabel", titleFrame)
    titleLbl.Size = UDim2.new(1, 0, 1, 0)
    titleLbl.BackgroundTransparency = 1
    titleLbl.Text = ""
    titleLbl.TextColor3 = getThemeColor()
    titleLbl.Font = Enum.Font.GothamBlack
    titleLbl.TextSize = 20
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 21

    local lockBtnFrame = Instance.new("TextButton", main)
    lockBtnFrame.Size = UDim2.new(0, 32, 0, 32)
    lockBtnFrame.Position = UDim2.new(1, -80, 0, 88)
    lockBtnFrame.BackgroundColor3 = Color3.fromRGB(30,30,35)
    lockBtnFrame.BackgroundTransparency = 0.6
    lockBtnFrame.BorderSizePixel = 0
    lockBtnFrame.Text = uiLocked and "🔒" or "🔓"
    lockBtnFrame.TextColor3 = getThemeColor()
    lockBtnFrame.Font = Enum.Font.GothamBold
    lockBtnFrame.TextSize = 18
    lockBtnFrame.AutoButtonColor = false
    lockBtnFrame.ZIndex = 200
    Instance.new("UICorner", lockBtnFrame).CornerRadius = UDim.new(0, 8)
    lockBtnFrame.MouseButton1Click:Connect(function() toggleLockUI() end)
    lockBtn = lockBtnFrame

    local closeBtn = Instance.new("TextButton", main)
    closeBtn.Size = UDim2.new(0, 32, 0, 32)
    closeBtn.Position = UDim2.new(1, -42, 0, 88)
    closeBtn.BackgroundColor3 = Color3.fromRGB(30,30,35)
    closeBtn.BackgroundTransparency = 0.6
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "−"
    closeBtn.TextColor3 = WHITE
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 26
    closeBtn.AutoButtonColor = false
    closeBtn.ZIndex = 200
    Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
    closeBtn.MouseButton1Click:Connect(function() hideGui() end)

    miniBtn = Instance.new("TextButton", gui)
    miniBtn.Size = UDim2.new(0, 170, 0, 52)
    miniBtn.Position = UDim2.new(0, 16, 0, 58)
    miniBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    miniBtn.BackgroundTransparency = 0
    miniBtn.BorderSizePixel = 0
    miniBtn.Text = ""
    miniBtn.TextColor3 = PASTEL_PINK
    miniBtn.Font = Enum.Font.GothamBlack
    miniBtn.TextSize = 16
    miniBtn.ZIndex = 20
    miniBtn.Visible = false
    miniBtn.AutoButtonColor = false
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(1, 0)
    local miniStroke = Instance.new("UIStroke", miniBtn)
    miniStroke.Color = PASTEL_PINK
    miniStroke.Thickness = BTN_STROKE_THICKNESS
    miniStroke.Transparency = BTN_STROKE_TRANSPARENCY

    local miniImg = Instance.new("ImageLabel", miniBtn)
    miniImg.Name = "MiniImage"
    miniImg.AnchorPoint = Vector2.new(0.5, 0.5)
    miniImg.Size = UDim2.new(0, 120, 0, 120)
    miniImg.Position = UDim2.new(0.5, 0, 0.5, 0)
    miniImg.BackgroundTransparency = 1
    miniImg.Image = "rbxassetid://99633112120425"
    miniImg.ScaleType = Enum.ScaleType.Fit
    miniImg.ZIndex = 21
    miniImg.Parent = miniBtn

    miniBtn.MouseButton1Click:Connect(function() showGui() end)

    local slideTween = nil
    local mainOriginalPos = main.Position

    showGui = function()
        if slideTween then slideTween:Cancel() end
        if not main then return end
        main.Visible = true
        miniBtn.Visible = false
        main.Position = UDim2.new(0, -GUI_W - 20, 0, 2)
        slideTween = TS:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = mainOriginalPos})
        slideTween:Play()
    end

    hideGui = function()
        if slideTween then slideTween:Cancel() end
        if not main or not main.Visible then return end
        local targetPos = UDim2.new(0, -GUI_W - 20, 0, 2)
        slideTween = TS:Create(main, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos})
        slideTween:Play()
        slideTween.Completed:Connect(function()
            main.Visible = false
            miniBtn.Visible = true
            slideTween = nil
        end)
    end

    local TAB_W = 80
    local tabBar = Instance.new("Frame", main)
    tabBar.Name = "SideTabBar"
    tabBar.Size = UDim2.new(0, TAB_W, 0, 280)
    tabBar.Position = UDim2.new(1, -TAB_W - 8, 0, 134)
    tabBar.BackgroundTransparency = 1
    tabBar.BorderSizePixel = 0
    tabBar.ZIndex = 10

    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Vertical
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    tabLayout.Padding = UDim.new(0, 10)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local tabContent = Instance.new("Frame", main)
    tabContent.Name = "TabContent"
    tabContent.Size = UDim2.new(1, -TAB_W - 20, 1, -139)
    tabContent.Position = UDim2.new(0, 10, 0, 134)
    tabContent.BackgroundTransparency = 1
    tabContent.ClipsDescendants = true
    tabContent.ZIndex = 5

    local tabs = {"Speed", "Combat", "Visual", "Config", "Keybinds"}
    local tabButtonsLocal = {}
    local contentPagesLocal = {}

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton", tabBar)
        btn.Size = UDim2.new(1, -10, 0, 36)
        btn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        btn.BackgroundTransparency = 0.15
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = TAB_INACT
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 11
        btn.TextWrapped = true
        btn.AutoButtonColor = false
        btn.ZIndex = 11
        btn.LayoutOrder = i
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
        btn:SetAttribute("IsActiveTab", i == 1)
        if i == 1 then
            btn.BackgroundColor3 = getThemeColor()
            btn.TextColor3 = ACTIVE_TXT
            btn.BackgroundTransparency = 0
        end
        local page = Instance.new("ScrollingFrame", tabContent)
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundTransparency = 1
        page.BorderSizePixel = 0
        page.ClipsDescendants = true
        page.ScrollBarThickness = 3
        page.ScrollBarImageColor3 = getThemeColor()
        page.ScrollBarImageTransparency = 0.3
        page.CanvasSize = UDim2.new(0, 0, 0, 0)
        page.AutomaticCanvasSize = Enum.AutomaticSize.Y
        page.ScrollingDirection = Enum.ScrollingDirection.Y
        page.ZIndex = 6
        page.Visible = (i == 1)
        local layout = Instance.new("UIListLayout", page)
        layout.SortOrder = Enum.SortOrder.LayoutOrder
        layout.Padding = UDim.new(0, 10)
        layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        local padding = Instance.new("UIPadding", page)
        padding.PaddingLeft = UDim.new(0, 2)
        padding.PaddingRight = UDim.new(0, 2)
        padding.PaddingTop = UDim.new(0, 4)
        padding.PaddingBottom = UDim.new(0, 20)
        contentPagesLocal[name] = page
        btn.MouseButton1Click:Connect(function()
            playMenuSound("tab")
            for _, pg2 in pairs(contentPagesLocal) do pg2.Visible = false end
            page.Visible = true
            for _, b in ipairs(tabButtonsLocal) do
                b.TextColor3 = TAB_INACT
                b.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
                b:SetAttribute("IsActiveTab", false)
            end
            btn.TextColor3 = ACTIVE_TXT
            btn.BackgroundColor3 = getThemeColor()
            btn:SetAttribute("IsActiveTab", true)
        end)
        table.insert(tabButtonsLocal, btn)
    end
    tabButtons = tabButtonsLocal
    contentPages = contentPagesLocal

    local pageCounters = {}
    local function getNextOrder(page)
        if not pageCounters[page] then pageCounters[page] = 0 end
        pageCounters[page] = pageCounters[page] + 1
        return pageCounters[page]
    end

    local function mkRow(page, h)
        local f = Instance.new("Frame", page)
        f.Size = UDim2.new(1, -4, 0, h or 40)
        f.BackgroundColor3 = ROW_BG
        f.BackgroundTransparency = 0.05
        f.BorderSizePixel = 0
        f.LayoutOrder = getNextOrder(page)
        f.ZIndex = 7
        Instance.new("UICorner", f).CornerRadius = UDim.new(0, 10)
        local st = Instance.new("UIStroke", f)
        st.Color = BLACK_STROKE
        st.Thickness = BTN_STROKE_THICKNESS
        st.Transparency = 0.2
        return f
    end

    local function mkLabel(row, txt)
        local l = Instance.new("TextLabel", row)
        l.Size = UDim2.new(0.6, 0, 1, 0)
        l.Position = UDim2.new(0, 12, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = WHITE
        l.Font = Enum.Font.GothamBold
        l.TextSize = 12
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextTruncate = Enum.TextTruncate.AtEnd
        l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        l.TextStrokeTransparency = 0.5
        l.ZIndex = 8
        return l
    end

    local function mkPill(row, offset)
        local pill = Instance.new("Frame", row)
        pill.Name = "Track"
        pill.Size = UDim2.new(0, 46, 0, 22)
        pill.AnchorPoint = Vector2.new(1, 0.5)
        pill.Position = UDim2.new(1, -(offset or 10), 0.5, 0)
        pill.BackgroundColor3 = INACTIVE_BG
        pill.BackgroundTransparency = 0
        pill.BorderSizePixel = 0
        pill.ZIndex = 8
        Instance.new("UICorner", pill).CornerRadius = UDim.new(1, 0)
        local stroke = Instance.new("UIStroke", pill)
        stroke.Color = BLACK_STROKE
        stroke.Thickness = BTN_STROKE_THICKNESS
        stroke.Transparency = BTN_STROKE_TRANSPARENCY
        local dot = Instance.new("Frame", pill)
        dot.Name = "Knob"
        dot.Size = UDim2.new(0, 16, 0, 16)
        dot.Position = UDim2.new(0, 3, 0.5, -8)
        dot.BackgroundColor3 = INACTIVE_TXT
        dot.BorderSizePixel = 0
        dot.ZIndex = 9
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
        return pill, dot
    end

    local function animPill(pill, dot, on)
        local stroke = pill:FindFirstChildOfClass("UIStroke")
        local info = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TS:Create(dot, info, {
            Position = on and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8),
            BackgroundColor3 = on and Color3.fromRGB(255,255,255) or INACTIVE_TXT,
        }):Play()
        TS:Create(pill, info, {
            BackgroundColor3 = on and PASTEL_PINK or INACTIVE_BG,
            BackgroundTransparency = 0,
        }):Play()
        if stroke then
            TS:Create(stroke, info, {
                Color = on and PASTEL_PINK or BLACK_STROKE,
                Transparency = on and 0.1 or 0.3,
                Thickness = BTN_STROKE_THICKNESS,
            }):Play()
        end
    end

    local function mkToggle(page, txt, cb)
        local row = mkRow(page, 40)
        mkLabel(row, txt)
        local pill, dot = mkPill(row, 10)
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
            task.defer(saveAllSettings)
        end)
        return sv
    end

    local function mkBox(parent, default, w, xOff, cb)
        local tb = Instance.new("TextBox", parent)
        local bw = w or 50
        local xo = math.max(xOff or 56, bw + 12)
        tb.Size = UDim2.new(0, bw, 0, 24)
        tb.Position = UDim2.new(1, -xo, 0.5, -12)
        tb.BackgroundColor3 = INP
        tb.BackgroundTransparency = 0.3
        tb.BorderSizePixel = 0
        tb.Text = tostring(default)
        tb.TextColor3 = WHITE
        tb.Font = Enum.Font.GothamBold
        tb.TextSize = 11
        tb.ClearTextOnFocus = false
        tb.ZIndex = 8
        Instance.new("UICorner", tb).CornerRadius = UDim.new(0, 8)
        local bs = Instance.new("UIStroke", tb)
        bs.Color = BLACK_STROKE
        bs.Thickness = BTN_STROKE_THICKNESS
        bs.Transparency = 0.3
        tb.FocusLost:Connect(function()
            if cb then
                local n = tonumber(tb.Text)
                if n then cb(n) else tb.Text = tostring(default) end
                task.defer(saveAllSettings)
            end
        end)
        return tb
    end

    local function mkStepRow(page, label, getValue, setValue, minV, maxV, step)
        local row = mkRow(page, 40)
        mkLabel(row, label)
        local valLabel = Instance.new("TextLabel", row)
        valLabel.Size = UDim2.new(0, 46, 0, 24)
        valLabel.Position = UDim2.new(1, -120, 0.5, -12)
        valLabel.BackgroundColor3 = INP
        valLabel.BackgroundTransparency = 0.3
        valLabel.BorderSizePixel = 0
        valLabel.Text = tostring(getValue())
        valLabel.TextColor3 = WHITE
        valLabel.Font = Enum.Font.GothamBold
        valLabel.TextSize = 11
        valLabel.ZIndex = 8
        Instance.new("UICorner", valLabel).CornerRadius = UDim.new(0, 8)
        local minusBtn = Instance.new("TextButton", row)
        minusBtn.Size = UDim2.new(0, 26, 0, 24)
        minusBtn.Position = UDim2.new(1, -152, 0.5, -12)
        minusBtn.BackgroundColor3 = INP
        minusBtn.BackgroundTransparency = 0.3
        minusBtn.BorderSizePixel = 0
        minusBtn.Text = "−"
        minusBtn.TextColor3 = WHITE
        minusBtn.Font = Enum.Font.GothamBlack
        minusBtn.TextSize = 16
        minusBtn.ZIndex = 8
        Instance.new("UICorner", minusBtn).CornerRadius = UDim.new(0, 8)
        local plusBtn = Instance.new("TextButton", row)
        plusBtn.Size = UDim2.new(0, 26, 0, 24)
        plusBtn.Position = UDim2.new(1, -70, 0.5, -12)
        plusBtn.BackgroundColor3 = INP
        plusBtn.BackgroundTransparency = 0.3
        plusBtn.BorderSizePixel = 0
        plusBtn.Text = "+"
        plusBtn.TextColor3 = WHITE
        plusBtn.Font = Enum.Font.GothamBlack
        plusBtn.TextSize = 16
        plusBtn.ZIndex = 8
        Instance.new("UICorner", plusBtn).CornerRadius = UDim.new(0, 8)
        local function updateLabel() valLabel.Text = tostring(getValue()) end
        minusBtn.MouseButton1Click:Connect(function()
            local v = getValue() - step
            if v < minV then v = minV end
            setValue(v); updateLabel(); saveAllSettings()
        end)
        plusBtn.MouseButton1Click:Connect(function()
            local v = getValue() + step
            if v > maxV then v = maxV end
            setValue(v); updateLabel(); saveAllSettings()
        end)
        return valLabel
    end

    local function mkCollapsibleSlider(page, label, options, getValue, setValue, opts)
        opts = opts or {}
        local wrapper = Instance.new("Frame", page)
        wrapper.Size = UDim2.new(1, -4, 0, 40)
        wrapper.BackgroundTransparency = 1
        wrapper.LayoutOrder = getNextOrder(page)
        wrapper.ClipsDescendants = false
        wrapper.ZIndex = 7
        local row = Instance.new("Frame", wrapper)
        row.Size = UDim2.new(1, 0, 0, 40)
        row.Position = UDim2.new(0, 0, 0, 0)
        row.BackgroundColor3 = ROW_BG
        row.BackgroundTransparency = 0.05
        row.BorderSizePixel = 0
        row.ZIndex = 8
        Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
        local rowStroke = Instance.new("UIStroke", row)
        rowStroke.Color = BLACK_STROKE
        rowStroke.Thickness = BTN_STROKE_THICKNESS
        rowStroke.Transparency = 0.2
        local lbl = Instance.new("TextLabel", row)
        lbl.Size = UDim2.new(1, -100, 1, 0)
        lbl.Position = UDim2.new(0, 12, 0, 0)
        lbl.BackgroundTransparency = 1
        lbl.Text = label
        lbl.TextColor3 = WHITE
        lbl.Font = Enum.Font.GothamBold
        lbl.TextSize = 12
        lbl.TextXAlignment = Enum.TextXAlignment.Left
        lbl.TextTruncate = Enum.TextTruncate.AtEnd
        lbl.ZIndex = 9
        local currentValueLbl = Instance.new("TextLabel", row)
        currentValueLbl.Size = UDim2.new(0, 60, 1, 0)
        currentValueLbl.Position = UDim2.new(1, -96, 0, 0)
        currentValueLbl.BackgroundTransparency = 1
        currentValueLbl.Text = tostring(getValue())
        currentValueLbl.TextColor3 = PASTEL_PINK
        currentValueLbl.Font = Enum.Font.GothamBold
        currentValueLbl.TextSize = 11
        currentValueLbl.TextXAlignment = Enum.TextXAlignment.Right
        currentValueLbl.ZIndex = 9
        local arrowBtn = Instance.new("TextButton", row)
        arrowBtn.Name = "Arrow"
        arrowBtn.Size = UDim2.new(0, 30, 0, 30)
        arrowBtn.Position = UDim2.new(1, -36, 0.5, -15)
        arrowBtn.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        arrowBtn.BackgroundTransparency = 0.25
        arrowBtn.BorderSizePixel = 0
        arrowBtn.Text = "▲"
        arrowBtn.TextColor3 = WHITE
        arrowBtn.Font = Enum.Font.GothamBold
        arrowBtn.TextSize = 14
        arrowBtn.AutoButtonColor = false
        arrowBtn.ZIndex = 10
        Instance.new("UICorner", arrowBtn).CornerRadius = UDim.new(0, 8)
        local arrowStroke = Instance.new("UIStroke", arrowBtn)
        arrowStroke.Color = PASTEL_PINK
        arrowStroke.Thickness = BTN_STROKE_THICKNESS
        arrowStroke.Transparency = 0.35
        local holder = Instance.new("Frame", wrapper)
        holder.Size = UDim2.new(1, 0, 0, 0)
        holder.Position = UDim2.new(0, 0, 0, 42)
        holder.BackgroundTransparency = 1
        holder.ClipsDescendants = true
        holder.ZIndex = 7
        holder.Visible = false
        local sliderRow = Instance.new("Frame", holder)
        sliderRow.Size = UDim2.new(1, 0, 0, 42)
        sliderRow.Position = UDim2.new(0, 0, 0, 0)
        sliderRow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        sliderRow.BackgroundTransparency = 0.15
        sliderRow.BorderSizePixel = 0
        sliderRow.ZIndex = 8
        Instance.new("UICorner", sliderRow).CornerRadius = UDim.new(0, 10)
        local sliderBg = Instance.new("Frame", sliderRow)
        sliderBg.Size = UDim2.new(1, -16, 1, -8)
        sliderBg.Position = UDim2.new(0, 8, 0, 4)
        sliderBg.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        sliderBg.BackgroundTransparency = 0.2
        sliderBg.BorderSizePixel = 0
        sliderBg.ClipsDescendants = true
        sliderBg.ZIndex = 9
        Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(0, 14)
        local sliderBgStroke = Instance.new("UIStroke", sliderBg)
        sliderBgStroke.Color = BLACK_STROKE
        sliderBgStroke.Thickness = BTN_STROKE_THICKNESS
        sliderBgStroke.Transparency = 0.32
        local optionBtns = {}
        local optionTexts = {}
        local segW = 1 / #options
        for i, opt in ipairs(options) do
            local optBtn = Instance.new("TextButton", sliderBg)
            optBtn.Name = "Opt_" .. tostring(i)
            optBtn.AnchorPoint = Vector2.new(0.5, 0.5)
            optBtn.Size = UDim2.new(segW, -4, 1, -8)
            optBtn.Position = UDim2.new(segW * (i - 0.5), 0, 0.5, 0)
            optBtn.BackgroundColor3 = INACTIVE_BG
            optBtn.BackgroundTransparency = 0
            optBtn.BorderSizePixel = 0
            optBtn.Text = ""
            optBtn.AutoButtonColor = false
            optBtn.ZIndex = 10
            Instance.new("UICorner", optBtn).CornerRadius = UDim.new(0, 13)
            local optStroke = Instance.new("UIStroke", optBtn)
            optStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            optStroke.Color = BLACK_STROKE
            optStroke.Thickness = BTN_STROKE_THICKNESS
            optStroke.Transparency = 0.6
            optStroke.Parent = optBtn
            local optLbl = Instance.new("TextLabel", optBtn)
            optLbl.AnchorPoint = Vector2.new(0.5, 0.5)
            optLbl.Size = UDim2.new(1, 0, 1, 0)
            optLbl.Position = UDim2.new(0.5, 0, 0.5, 0)
            optLbl.BackgroundTransparency = 1
            optLbl.Text = opt
            optLbl.TextColor3 = INACTIVE_TXT
            optLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
            optLbl.TextStrokeTransparency = 0.4
            optLbl.TextSize = 11
            optLbl.Font = Enum.Font.GothamBlack
            optLbl.TextXAlignment = Enum.TextXAlignment.Center
            optLbl.ZIndex = 11
            optLbl.Parent = optBtn
            optionBtns[i] = optBtn
            optionTexts[i] = optLbl
            optBtn.MouseButton1Click:Connect(function()
                setValue(opt)
                for j, btn in ipairs(optionBtns) do
                    local sel = (j == i)
                    TS:Create(btn, TweenInfo.new(0.18), {
                        BackgroundColor3 = sel and PASTEL_PINK or INACTIVE_BG,
                    }):Play()
                    local st = btn:FindFirstChildOfClass("UIStroke")
                    if st then
                        TS:Create(st, TweenInfo.new(0.18), {
                            Color = sel and PASTEL_PINK or BLACK_STROKE,
                            Transparency = sel and 0.1 or 0.6,
                            Thickness = BTN_STROKE_THICKNESS,
                        }):Play()
                    end
                    TS:Create(optionTexts[j], TweenInfo.new(0.14), {
                        TextColor3 = INACTIVE_TXT,
                    }):Play()
                end
                currentValueLbl.Text = tostring(opt)
                task.defer(saveAllSettings)
            end)
        end
        local function applyVisual(mode)
            local idx = 1
            for i, opt in ipairs(options) do
                if opt == mode then idx = i break end
            end
            for j, btn in ipairs(optionBtns) do
                local sel = (j == idx)
                btn.BackgroundColor3 = sel and PASTEL_PINK or INACTIVE_BG
                local st = btn:FindFirstChildOfClass("UIStroke")
                if st then
                    st.Color = sel and PASTEL_PINK or BLACK_STROKE
                    st.Transparency = sel and 0.1 or 0.6
                    st.Thickness = BTN_STROKE_THICKNESS
                end
                optionTexts[j].TextColor3 = INACTIVE_TXT
            end
            currentValueLbl.Text = tostring(mode)
        end
        local function applyThemeColor(newColor)
            local idx = 1
            for i, opt in ipairs(options) do
                if opt == getValue() then idx = i break end
            end
            for j, btn in ipairs(optionBtns) do
                if j == idx then btn.BackgroundColor3 = newColor end
            end
            arrowStroke.Color = newColor
            sliderBgStroke.Color = newColor
            currentValueLbl.TextColor3 = newColor
        end
        table.insert(_G._RaptureDynamicSliders, { applyThemeColor = applyThemeColor })
        local expanded = false
        arrowBtn.MouseButton1Click:Connect(function()
            expanded = not expanded
            if expanded then
                holder.Visible = true
                TS:Create(holder, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(1, 0, 0, 42) }):Play()
                TS:Create(wrapper, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { Size = UDim2.new(1, -4, 0, 84) }):Play()
                TS:Create(arrowBtn, TweenInfo.new(0.2), {Rotation = 180}):Play()
            else
                TS:Create(holder, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Size = UDim2.new(1, 0, 0, 0) }):Play()
                TS:Create(wrapper, TweenInfo.new(0.22, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Size = UDim2.new(1, -4, 0, 40) }):Play()
                TS:Create(arrowBtn, TweenInfo.new(0.2), {Rotation = 0}):Play()
                task.delay(0.22, function() if not expanded then holder.Visible = false end end)
            end
        end)
        applyVisual(getValue())
        return applyVisual, currentValueLbl, optionBtns, optionTexts
    end

    local function mkKeyButton(parent, kbEntry)
        local btn = Instance.new("TextButton", parent)
        btn.Size = UDim2.new(0, 70, 0, 24)
        btn.Position = UDim2.new(1, -78, 0.5, -12)
        btn.BackgroundColor3 = INP
        btn.BackgroundTransparency = 0.3
        btn.BorderSizePixel = 0
        local function getLabel() return (kbEntry.gp and kbEntry.gp.Name) or (kbEntry.kb and kbEntry.kb.Name) or "None" end
        btn.Text = getLabel()
        btn.TextColor3 = WHITE
        btn.Font = Enum.Font.GothamBold
        btn.TextSize = 10
        btn.ZIndex = 8
        btn.AutoButtonColor = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
        local li = false; local lc; local pv = btn.Text; local listenStart = 0
        btn.Activated:Connect(function()
            if li then li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; return end
            pv = btn.Text; li = true; _anyKeyListening = true; listenStart = _tick(); btn.Text = "..."
            lc = UIS.InputBegan:Connect(function(inp)
                if not li then return end
                if inp.KeyCode == Enum.KeyCode.Escape then li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end; btn.Text = pv; return end
                local isGp = isGamepadInput(inp)
                if isGp and _tick()-listenStart < 0.15 then return end
                if not isBindableInput(inp) then return end
                btn.Text = inp.KeyCode.Name; pv = inp.KeyCode.Name
                li = false; _anyKeyListening = false; if lc then lc:Disconnect(); lc = nil end
                if isGp then kbEntry.gp = inp.KeyCode; kbEntry.kb = nil else kbEntry.kb = inp.KeyCode; kbEntry.gp = nil end
                task.defer(saveAllSettings)
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
    do local row = mkRow(speedPage); mkLabel(row, "Normal Speed"); normalBox = mkBox(row, NS, 50, 60, function(v) if v > 0 and v <= 500 then NS = v end end) end
    do local row = mkRow(speedPage); mkLabel(row, "Carry Speed"); carryBox = mkBox(row, CS, 50, 60, function(v) if v > 0 and v <= 500 then CS = v end end) end
    do local row = mkRow(speedPage); mkLabel(row, "Lagger Carry"); laggerBox = mkBox(row, LAGGER_SPEED, 50, 60, function(v) if v > 0 and v <= 500 then LAGGER_SPEED = v end end) end
    do local row = mkRow(speedPage); mkLabel(row, "Lagger"); lagger2Box = mkBox(row, LAGGER_CARRY_SPEED, 50, 60, function(v) if v > 0 and v <= 500 then LAGGER_CARRY_SPEED = v end end) end

    local combatPage = contentPages["Combat"]

    setBatCounterVisual = mkToggle(combatPage, "Bat Counter", function(on)
        batCounterEnabled = on
        if on then startBatCounter() else stopBatCounter() end
        task.defer(saveAllSettings)
    end)

    setMedusaVisual = mkToggle(combatPage, "Medusa Counter", function(on)
        medusaCounterEnabled = on
        if on then if LP.Character then setupMedusaCounter(LP.Character) end
        else stopMedusaCounter() end
        task.defer(saveAllSettings)
    end)

    setRagdollTimerVisual = mkToggle(combatPage, "Ragdoll Countdown", function(on)
        ragdollCountdownEnabled = on
        if on then hookRagdollCountdown(LP.Character)
        else
            if _G._RaptureRCD.conn then pcall(function() _G._RaptureRCD.conn:Disconnect() end); _G._RaptureRCD.conn = nil end
            if _G._RaptureRCD.charConn then pcall(function() _G._RaptureRCD.charConn:Disconnect() end); _G._RaptureRCD.charConn = nil end
            if ragdollCountdownLabel then
                ragdollCountdownLabel.Visible = false
                ragdollCountdownLabel.Text = ""
            end
        end
        task.defer(saveAllSettings)
    end)

    setAntiDieVisual = mkToggle(combatPage, "Anti Die", function(on)
        antiDieEnabled = on
        if on then _antiDie.StartEngine() else _antiDie.StopEngine() end
        task.defer(saveAllSettings)
    end)

    setAntiFlingVisual = mkToggle(combatPage, "Anti Fling", function(on)
        antiFlingEnabled = on
        if on then startAntiFling() else stopAntiFling() end
        task.defer(saveAllSettings)
    end)

    setAntiRagVisual = mkToggle(combatPage, "Anti Ragdoll", function(on) setAntiRagdollEnabled(on) end)

    antiRagSetVisual = mkCollapsibleSlider(combatPage, "Anti Ragdoll Version", {"V1", "V2"},
        function() return antiRagdollVersion == "v1" and "V1" or "V2" end,
        function(v)
            local newV = (v == "V2") and "v2" or "v1"
            setAntiRagdollVersion(newV)
            if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
        end)

    setInstaGrab = mkToggle(combatPage, "Auto Steal", function(on)
        CONFIG.AUTO_STEAL_ENABLED = on
        if on then pcall(startAutoSteal) else stopAutoSteal() end
        updateProgressBarVisibility()
    end)

    do local row = mkRow(combatPage); mkLabel(row, "Steal Radius"); radInput = mkBox(row, CONFIG.STEAL_RANGE, 50, 60, function(v) if v and v >= 5 and v <= 300 then CONFIG.STEAL_RANGE = _floor(v+0.5); Steal.StealRadius = CONFIG.STEAL_RANGE; saveAllSettings() end end) end

    autoBatSetVisual = mkToggle(combatPage, "Bat Aimbot", function(on)
        if on then enableAutoBat() else disableAutoBat() end
        if mobSetAutoBat then mobSetAutoBat(on) end
        task.defer(saveAllSettings)
    end)

    local aimbotModeRefresh
    aimbotModeRefresh = mkCollapsibleSlider(combatPage, "Bat Aimbot Mode", {"V1", "V2"},
        function() return aimbotMode end,
        function(v)
            if v ~= "V2" then v = "V1" end
            aimbotMode = v
            selectedAimbotMode = v
            if _G.RaptureRefreshAimbotVisual then _G.RaptureRefreshAimbotVisual() end
            if saveAmbitiousConfig then pcall(saveAmbitiousConfig) end
        end)
    aimbotModeSetVisual = aimbotModeRefresh

    do local row = mkRow(combatPage); mkLabel(row, "Bat Aimbot Speed"); batSpeedBox = mkBox(row, BAT_AIMBOT_SPEED, 50, 60, function(v) if v > 0 and v <= 200 then BAT_AIMBOT_SPEED = v end end) end

    batBypassSetVisual = mkToggle(combatPage, "Bat Bypass", function(on)
        if on then
            if not _G._RaptureBatBypass.enabled then _G.RaptureStartBatBypass() end
        else
            if _G._RaptureBatBypass.enabled then _G.RaptureStopBatBypass() end
        end
        task.defer(saveAllSettings)
    end)

    batDesyncTpSetVisual = mkToggle(combatPage, "TP BAT", function(on)
        if on then if not batDesyncTpEnabled then toggleBatDesyncTp() end
        else if batDesyncTpEnabled then toggleBatDesyncTp() end end
        task.defer(saveAllSettings)
    end)

    dropBrainrotSetVisual = mkToggle(combatPage, "Drop Brainrot", function(on)
        if on then executeDropWithToggle(function(v) dropBrainrotSetVisual(v); if mobSetDropBR then mobSetDropBR(v) end end) end
    end)

    autoLeftSetVisual = mkToggle(combatPage, "Auto Left", function(on)
        autoLeftEnabled = on
        if on then startAutoLeft() else stopAutoLeft() end
        if mobSetAutoLeft then mobSetAutoLeft(on) end
        task.defer(saveAllSettings)
    end)

    autoRightSetVisual = mkToggle(combatPage, "Auto Right", function(on)
        autoRightEnabled = on
        if on then startAutoRight() else stopAutoRight() end
        if mobSetAutoRight then mobSetAutoRight(on) end
        task.defer(saveAllSettings)
    end)

    local visualPage = contentPages["Visual"]

    setESPVisual = mkToggle(visualPage, "ESP Players", function(on)
        if on then startESP() else stopESP() end
        task.defer(saveAllSettings)
    end)

    setAntiLagVisual = mkToggle(visualPage, "Anti Lag", function(on)
        if on then enableAntiLag() else disableAntiLag() end
        task.defer(saveAllSettings)
    end)

    do
        local row = mkRow(visualPage, 40)
        mkLabel(row, "Stretch Rez")
        local stretchPill, stretchDot = mkPill(row, 10)
        local stretchOn = false
        local function setStretch(s)
            stretchOn = s
            animPill(stretchPill, stretchDot, s)
            if s then enableStretch() else disableStretch() end
            stretchEnabled = s
            task.defer(saveAllSettings)
        end
        local stretchClk = Instance.new("TextButton", stretchPill)
        stretchClk.Size = UDim2.new(1,0,1,0)
        stretchClk.BackgroundTransparency = 1
        stretchClk.Text = ""
        stretchClk.ZIndex = 10
        stretchClk.MouseButton1Click:Connect(function() setStretch(not stretchOn) end)
        _G.stretchToggleSetter = setStretch
    end
    do local row = mkRow(visualPage); mkLabel(row, "Stretch Value"); stretchValueBox = mkBox(row, stretchValue, 50, 60, function(v) if v and v >= 0.3 and v <= 1.5 then stretchValue = v; if stretchEnabled then disableStretch(); enableStretch() end; saveAllSettings() end end) end

    setFovVisual = mkToggle(visualPage, "FOV", function(on)
        if on then enableCustomFov() else disableCustomFov() end
        task.defer(saveAllSettings)
    end)
    if setFovVisual then setFovVisual(fovEnabled) end
    do
        local row = mkRow(visualPage)
        mkLabel(row, "FOV Value")
        local fovBox = mkBox(row, fovValue, 50, 60, function(v)
            if v and v >= 20 and v <= 120 then
                fovValue = _floor(v + 0.5)
                if not fovEnabled then enableCustomFov(); if setFovVisual then setFovVisual(true) end end
                local cam = workspace.CurrentCamera
                if cam then pcall(function() cam.FieldOfView = fovValue end) end
                saveAllSettings()
            end
        end)
        fovSliderSet = function(val) if fovBox then fovBox.Text = tostring(val) end end
    end

    do
        local row = mkRow(visualPage, 40)
        mkLabel(row, "Bat Skin")
        local pill, dot = mkPill(row, 10)
        animPill(pill, dot, false)
        dot.Visible = false
        local openLbl = Instance.new("TextLabel", pill)
        openLbl.Name = "OpenLabel"
        openLbl.Size = UDim2.new(1, 0, 1, 0)
        openLbl.BackgroundTransparency = 1
        openLbl.Text = "OPEN"
        openLbl.TextColor3 = PASTEL_PINK
        openLbl.Font = Enum.Font.GothamBlack
        openLbl.TextSize = 9
        openLbl.TextXAlignment = Enum.TextXAlignment.Center
        openLbl.ZIndex = 11
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1, 0, 1, 0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.ZIndex = 12
        clk.MouseButton1Click:Connect(function() openBatSkinPicker() end)
    end

    local customSoundsSetVisual = mkToggle(visualPage, "Custom Sounds", function(on)
        customSoundsEnabled = on
        if _G.RaptureCustomSounds then _G.RaptureCustomSounds.setEnabled(on) end
        task.defer(saveAllSettings)
    end)
    setCustomSoundsVisual = customSoundsSetVisual

    local configPage = contentPages["Config"]

    uiScaleBox = mkStepRow(configPage, "UI Scale",
        function() return uiScaleValue end,
        function(v)
            uiScaleValue = v
            if mainUIScale then mainUIScale.Scale = v / 100 end
        end, 50, 150, 1)

    progressBarScaleBox = mkStepRow(configPage, "Progress Bar Scale",
        function() return progressBarScaleValue end,
        function(v)
            progressBarScaleValue = v
            if pbScale then pbScale.Scale = v / 100 end
        end, 30, 150, 1)

    mkStepRow(configPage, "Button Scale",
        function() return _floor(floatingButtonScale * 100) end,
        function(v)
            floatingButtonScale = v / 100
            applyFloatingButtonScale()
        end, 50, 200, 1)

    do
        local row = mkRow(configPage, 44)
        mkLabel(row, "Background Image")
        local btn = Instance.new("TextButton", row)
        btn.Size = UDim2.new(0, 80, 0, 24)
        btn.Position = UDim2.new(1, -92, 0.5, -12)
        btn.BackgroundColor3 = Color3.fromRGB(18, 14, 24)
        btn.BackgroundTransparency = 0.3
        btn.BorderSizePixel = 0
        btn.Text = "PICK"
        btn.TextColor3 = getThemeColor()
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 10
        btn.ZIndex = 8
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 12)
        btn.Activated:Connect(function() openImagePicker() end)
    end

    do
        local row = mkRow(configPage, 40)
        local delBtn = Instance.new("TextButton", row)
        delBtn.Size = UDim2.new(1, -8, 0.85, 0)
        delBtn.Position = UDim2.new(0, 4, 0.07, 0)
        delBtn.BackgroundColor3 = Color3.fromRGB(30,30,35)
        delBtn.BackgroundTransparency = 0.3
        delBtn.BorderSizePixel = 0
        delBtn.Text = "DELETE CONFIG"
        delBtn.TextColor3 = WHITE
        delBtn.Font = Enum.Font.GothamBold
        delBtn.TextSize = 12
        delBtn.ZIndex = 8
        Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 10)
        local deleteState = 0
        local delDebounce = false
        delBtn.MouseButton1Click:Connect(function()
            if delDebounce then return end
            if deleteState == 0 then
                deleteState = 1
                delBtn.Text = "CONFIRM?"
                task.delay(2, function()
                    if delBtn and delBtn.Parent and deleteState == 1 then
                        deleteState = 0
                        delBtn.Text = "DELETE CONFIG"
                    end
                end)
            elseif deleteState == 1 then
                delDebounce = true
                pcall(resetToFactoryDefaults)
                task.defer(function()
                    if setAntiRagVisual then setAntiRagVisual(false) end
                    if setInstaGrab then setInstaGrab(false) end
                    if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
                    if setBatCounterVisual then setBatCounterVisual(false) end
                    if setMedusaVisual then setMedusaVisual(false) end
                    if setRagdollTimerVisual then setRagdollTimerVisual(false) end
                    if autoLeftSetVisual then autoLeftSetVisual(false) end
                    if autoRightSetVisual then autoRightSetVisual(false) end
                    if autoBatSetVisual then autoBatSetVisual(false) end
                    if batDesyncTpSetVisual then batDesyncTpSetVisual(false) end
                    if batBypassSetVisual then batBypassSetVisual(false) end
                    if setESPVisual then setESPVisual(false) end
                    if setAntiLagVisual then setAntiLagVisual(false) end
                    if setFovVisual then setFovVisual(false) end
                    if setAntiDieVisual then setAntiDieVisual(false) end
                    if setAntiFlingVisual then setAntiFlingVisual(false) end
                    if _G.stretchToggleSetter then _G.stretchToggleSetter(false) end
                    if aimbotModeSetVisual then aimbotModeSetVisual("V1") end
                    if antiRagSetVisual then antiRagSetVisual("V1") end
                    if customSoundsSetVisual then customSoundsSetVisual(false) end
                    refreshSpeedModeLabel()
                end)
                delBtn.Text = "DELETED"
                task.delay(1.5, function() if delBtn and delBtn.Parent then delBtn.Text = "DELETE CONFIG"; delDebounce = false; deleteState = 0 end end)
            end
        end)
    end

    local keyPage = contentPages["Keybinds"]
    addKeybindRow(keyPage, "Carry Mode", KB.CarryToggle)
    addKeybindRow(keyPage, "Lagger Mode", KB.LaggerMode)
    addKeybindRow(keyPage, "Auto Left", KB.AutoLeft)
    addKeybindRow(keyPage, "Auto Right", KB.AutoRight)
    addKeybindRow(keyPage, "Auto Bat", KB.AutoBat)
    addKeybindRow(keyPage, "TP BAT", KB.TPBat)
    addKeybindRow(keyPage, "Insta Reset", KB.InstaReset)
    addKeybindRow(keyPage, "Bat Bypass", KB.BatBypass)
    addKeybindRow(keyPage, "TP Down", KB.TPFloor)
    addKeybindRow(keyPage, "Drop Brainrot", KB.DropBrainrot)
    addKeybindRow(keyPage, "Hide GUI", KB.GuiHide)

    -- ========== BARRA DE STEAL (CON IMAGEN) ==========
    pbFrame = Instance.new("Frame", gui)
    pbFrame.Size = UDim2.new(0, 480, 0, 76)
    pbFrame.Position = UDim2.new(0.5, -240, 1, -90)
    pbFrame.BackgroundTransparency = 1
    pbFrame.BorderSizePixel = 0
    pbFrame.Active = true
    pbFrame.ClipsDescendants = true
    pbFrame.Visible = true
    pbFrame.ZIndex = 10
    pbScale = Instance.new("UIScale", pbFrame)
    pbScale.Scale = progressBarScaleValue / 100
    if savedProgressBarPos then
        pbFrame.Position = UDim2.new(savedProgressBarPos.XScale or 0.5, savedProgressBarPos.XOffset or -240, savedProgressBarPos.YScale or 1, savedProgressBarPos.YOffset or -90)
    end
    Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 16)

    local pbBgImage = Instance.new("ImageLabel", pbFrame)
    pbBgImage.Name = "StealBarBg"
    pbBgImage.Size = UDim2.new(1, 0, 1, 0)
    pbBgImage.Position = UDim2.new(0, 0, 0, 0)
    pbBgImage.BackgroundTransparency = 1
    pbBgImage.Image = "rbxassetid://109443898978389"
    pbBgImage.ScaleType = Enum.ScaleType.Crop
    pbBgImage.ZIndex = 1
    Instance.new("UICorner", pbBgImage).CornerRadius = UDim.new(0, 16)

    local border = Instance.new("UIStroke", pbFrame)
    border.Color = BLACK_STROKE
    border.Thickness = BTN_STROKE_THICKNESS
    border.Transparency = 0.3

    local pctRow = Instance.new("Frame", pbFrame)
    pctRow.Size = UDim2.new(1, 0, 0, 26)
    pctRow.Position = UDim2.new(0, 0, 0, 4)
    pctRow.BackgroundTransparency = 1
    pctRow.ZIndex = 12
    progressPct = Instance.new("TextLabel", pctRow)
    progressPct.Size = UDim2.new(1, -28, 1, 0)
    progressPct.Position = UDim2.new(0, 14, 0, 0)
    progressPct.BackgroundTransparency = 1
    progressPct.Text = "0%"
    progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
    progressPct.Font = Enum.Font.GothamBlack
    progressPct.TextSize = 22
    progressPct.TextXAlignment = Enum.TextXAlignment.Right
    progressPct.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    progressPct.TextStrokeTransparency = 0.2
    progressPct.ZIndex = 13

    local infoRow = Instance.new("Frame", pbFrame)
    infoRow.Size = UDim2.new(1, 0, 0, 26)
    infoRow.Position = UDim2.new(0, 0, 0, 24)
    infoRow.BackgroundTransparency = 1
    infoRow.ZIndex = 12
    fpsLabel = Instance.new("TextLabel", infoRow)
    fpsLabel.Size = UDim2.new(0, 130, 1, 0)
    fpsLabel.Position = UDim2.new(0, 14, 0, 0)
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.Text = "FPS: --"
    fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    fpsLabel.Font = Enum.Font.GothamBlack
    fpsLabel.TextSize = 22
    fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
    fpsLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    fpsLabel.TextStrokeTransparency = 0.2
    fpsLabel.ZIndex = 13
    msLabel = Instance.new("TextLabel", infoRow)
    msLabel.Size = UDim2.new(0, 130, 1, 0)
    msLabel.Position = UDim2.new(0, 14 + 130 + 12, 0, 0)
    msLabel.BackgroundTransparency = 1
    msLabel.Text = "MS: --"
    msLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    msLabel.Font = Enum.Font.GothamBlack
    msLabel.TextSize = 22
    msLabel.TextXAlignment = Enum.TextXAlignment.Left
    msLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    msLabel.TextStrokeTransparency = 0.2
    msLabel.ZIndex = 13

    local progressRow = Instance.new("Frame", pbFrame)
    progressRow.Size = UDim2.new(1, -20, 0, 14)
    progressRow.Position = UDim2.new(0, 10, 0, 56)
    progressRow.BackgroundTransparency = 1
    progressRow.ZIndex = 11
    local fillRegion = Instance.new("Frame", progressRow)
    fillRegion.Size = UDim2.new(1, 0, 1, 0)
    fillRegion.BackgroundColor3 = GRAY_TRACK
    fillRegion.BackgroundTransparency = 0
    fillRegion.BorderSizePixel = 0
    fillRegion.ClipsDescendants = true
    fillRegion.ZIndex = 12
    Instance.new("UICorner", fillRegion).CornerRadius = UDim.new(0, 10)
    local frStroke = Instance.new("UIStroke", fillRegion)
    frStroke.Color = Color3.fromRGB(0, 0, 0)
    frStroke.Thickness = BTN_STROKE_THICKNESS
    frStroke.Transparency = 0
    frStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    progressFill = Instance.new("Frame", fillRegion)
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.Position = UDim2.new(0, 0, 0, 0)
    progressFill.BackgroundColor3 = NEON_PINK
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 13
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 10)
    local glowGrad = Instance.new("UIGradient", progressFill)
    glowGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 105, 180)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 182, 193)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 105, 180)),
    })
    glowGrad.Rotation = 90

    drag(pbFrame)
    task.spawn(function()
        local lastFrame = _tick()
        local fpsSamples = {}
        local fpsAvg = 60
        RunService.RenderStepped:Connect(function()
            local now = _tick()
            local dt = now - lastFrame
            lastFrame = now
            if dt > 0 then
                table.insert(fpsSamples, 1 / dt)
                if #fpsSamples > 30 then table.remove(fpsSamples, 1) end
                local sum = 0
                for _, v in ipairs(fpsSamples) do sum = sum + v end
                fpsAvg = sum / #fpsSamples
            end
        end)
        while true do
            local ping = 0
            pcall(function() ping = LP:GetNetworkPing() * 1000 end)
            if fpsLabel then fpsLabel.Text = string.format("FPS: %d", _floor(fpsAvg + 0.5)) end
            if msLabel then msLabel.Text = string.format("MS: %d", _floor(ping + 0.5)) end
            task.wait(0.5)
        end
    end)
    drag(main)
end

function openImagePicker()
    pcall(function()
        local old = CoreGui:FindFirstChild("RaptureImagePicker")
        if old then old:Destroy() end
        local pg = LP:FindFirstChild("PlayerGui")
        if pg then local o = pg:FindFirstChild("RaptureImagePicker"); if o then o:Destroy() end end
    end)
    local viewer = Instance.new("ScreenGui")
    viewer.Name = "RaptureImagePicker"
    viewer.ResetOnSpawn = false
    viewer.IgnoreGuiInset = true
    viewer.DisplayOrder = 400
    if not pcall(function() viewer.Parent = CoreGui end) then viewer.Parent = LP:WaitForChild("PlayerGui") end
    local dim = Instance.new("TextButton", viewer)
    dim.Size = UDim2.new(1, 0, 1, 0)
    dim.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    dim.BackgroundTransparency = 0.45
    dim.Text = ""
    dim.AutoButtonColor = false
    dim.ZIndex = 1
    dim.Activated:Connect(function() viewer:Destroy() end)
    local frame = Instance.new("Frame", viewer)
    frame.Size = UDim2.new(0, 420, 0, 380)
    frame.Position = UDim2.new(0.5, -210, 0.5, -190)
    frame.BackgroundColor3 = Color3.fromRGB(12, 10, 16)
    frame.BorderSizePixel = 0
    frame.ZIndex = 2
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)
    local st = Instance.new("UIStroke", frame)
    st.Color = Color3.fromRGB(60,50,75)
    st.Thickness = 1.8
    local title = Instance.new("TextLabel", frame)
    title.Size = UDim2.new(1, -48, 0, 30)
    title.Position = UDim2.new(0, 12, 0, 8)
    title.BackgroundTransparency = 1
    title.Text = "BACKGROUND IMAGE"
    title.TextColor3 = Color3.fromRGB(255,255,255)
    title.Font = Enum.Font.GothamBold
    title.TextSize = 14
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.ZIndex = 3
    local close = Instance.new("TextButton", frame)
    close.Size = UDim2.new(0, 28, 0, 28)
    close.Position = UDim2.new(1, -34, 0, 8)
    close.BackgroundColor3 = Color3.fromRGB(28,26,36)
    close.BorderSizePixel = 0
    close.Text = "X"
    close.TextColor3 = Color3.fromRGB(255,255,255)
    close.Font = Enum.Font.GothamBlack
    close.TextSize = 14
    close.ZIndex = 4
    Instance.new("UICorner", close).CornerRadius = UDim.new(0, 8)
    close.Activated:Connect(function() viewer:Destroy() end)
    local scroll = Instance.new("ScrollingFrame", frame)
    scroll.Size = UDim2.new(1, -16, 1, -52)
    scroll.Position = UDim2.new(0, 8, 0, 44)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 5
    scroll.ScrollBarImageColor3 = getThemeColor()
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
    scroll.ZIndex = 3
    local grid = Instance.new("UIGridLayout", scroll)
    grid.CellSize = UDim2.new(0, 120, 0, 80)
    grid.CellPadding = UDim2.new(0, 8, 0, 8)
    grid.SortOrder = Enum.SortOrder.LayoutOrder
    for i, id in ipairs(backgroundImages) do
        local thumb = Instance.new("TextButton", scroll)
        thumb.Size = UDim2.new(0, 120, 0, 80)
        thumb.BackgroundColor3 = Color3.fromRGB(20, 18, 26)
        thumb.BorderSizePixel = 0
        thumb.Text = ""
        thumb.LayoutOrder = i
        thumb.ZIndex = 4
        Instance.new("UICorner", thumb).CornerRadius = UDim.new(0, 8)
        local thumbSt = Instance.new("UIStroke", thumb)
        thumbSt.Color = (backgroundIndex == i) and getThemeColor() or Color3.fromRGB(60, 50, 75)
        thumbSt.Thickness = (backgroundIndex == i) and 2 or 1
        thumbSt.Transparency = (backgroundIndex == i) and 0 or 0.4
        local img = Instance.new("ImageLabel", thumb)
        img.Size = UDim2.new(1, -8, 1, -8)
        img.Position = UDim2.new(0, 4, 0, 4)
        img.BackgroundTransparency = 1
        img.Image = "rbxassetid://" .. id
        img.ScaleType = Enum.ScaleType.Crop
        img.ZIndex = 5
        Instance.new("UICorner", img).CornerRadius = UDim.new(0, 6)
        thumb.Activated:Connect(function()
            viewer:Destroy()
            task.defer(function()
                pcall(function()
                    backgroundIndex = i
                    saveAllSettings()
                    local bgImg = main and main:FindFirstChild("BackgroundImage")
                    if bgImg then
                        bgImg.Image = "rbxassetid://" .. id
                        bgImg.ImageTransparency = backgroundImageTransparency
                    end
                end)
            end)
        end)
    end
end

function createMobilePanel()
    local panel = Instance.new("ScreenGui")
    panel.Name = "RaptureDuelMobilePanel"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = CoreGui end) then panel.Parent = LP:WaitForChild("PlayerGui") end
    local BTN_W, BTN_H = 60, 60
    local GAP = 8
    local COLUMNS = 2
    local ROWS = 4
    local PANEL_W = BTN_W * COLUMNS + GAP * (COLUMNS - 1)
    local PANEL_H = BTN_H * ROWS + (GAP + 10) * (ROWS - 1)
    local container = Instance.new("Frame", panel)
    container.Name = "FloatingPanel"
    container.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
    container.Position = UDim2.new(1, -PANEL_W - 15, 0, 70)
    container.BackgroundTransparency = 1
    container.BorderSizePixel = 0
    container.Active = false
    container.ClipsDescendants = false
    local containerScale = Instance.new("UIScale", container)
    containerScale.Scale = floatingButtonScale
    table.insert(_floatingUIScales, containerScale)
    local btnContainer = Instance.new("Frame", container)
    btnContainer.Name = "ButtonsContainer"
    btnContainer.Size = UDim2.new(1, 0, 1, 0)
    btnContainer.BackgroundTransparency = 1
    local buttons = {}
    local buttonNames = {"DropBR", "AutoLeft", "AutoBat", "AutoRight", "TpDown", "Carry", "Lagger1", "Lagger2"}
    local buttonTexts = {"DROP\nBR", "AUTO\nLEFT", "BAT\nAIMBOT", "AUTO\nRIGHT", "TP\nDOWN", "CARRY\nSPD", "LAGGER\nCARRY", "LAGGER"}
    for i, name in ipairs(buttonNames) do
        local text = buttonTexts[i]
        local btn = Instance.new("TextButton", btnContainer)
        btn.Name = name
        btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        btn.BackgroundColor3 = BTN_BG_DARK
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
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 18)
        local bgGrad = Instance.new("UIGradient", btn)
        bgGrad.Name = "BtnGrad"
        bgGrad.Rotation = 90
        bgGrad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0.00, Color3.fromRGB(45, 45, 45)),
            ColorSequenceKeypoint.new(0.45, Color3.fromRGB(20, 20, 20)),
            ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0)),
        })
        local stroke = Instance.new("UIStroke", btn)
        stroke.Color = Color3.fromRGB(0, 0, 0)
        stroke.Thickness = BTN_STROKE_THICKNESS
        stroke.Transparency = BTN_STROKE_TRANSPARENCY
        local label = Instance.new("TextLabel", btn)
        label.Size = UDim2.new(1, 0, 1, 0)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = PASTEL_PINK
        label.Font = Enum.Font.GothamBlack
        label.TextSize = 10
        label.TextWrapped = true
        label.ZIndex = 11
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
        btn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                dragging = true; hasMoved = false; movedDistance = 0
                dragStart = input.Position; startPos = btn.Position
                _isDraggingButton = true
            end
        end)
        btn.InputChanged:Connect(function(input)
            if not dragging then return end
            if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
                local delta = input.Position - dragStart
                movedDistance = delta.Magnitude
                if not uiLocked then
                    hasMoved = true
                    btn.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
                end
            end
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    if movedDistance < 3 then
                        if name == "DropBR" then
                            if not autoBatEnabled then
                                setActive(true)
                                executeDropWithToggle(function(v) if dropBrainrotSetVisual then dropBrainrotSetVisual(v) end end)
                                task.delay(0.3, function() setActive(false) end)
                            end
                        elseif name == "AutoLeft" then
                            autoLeftEnabled = not autoLeftEnabled
                            setActive(autoLeftEnabled)
                            if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
                            if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
                        elseif name == "AutoBat" then
                            if not autoBatEnabled then enableAutoBat() else disableAutoBat() end
                            setActive(autoBatEnabled)
                        elseif name == "AutoRight" then
                            autoRightEnabled = not autoRightEnabled
                            setActive(autoRightEnabled)
                            if autoRightEnabled then startAutoRight() else stopAutoRight() end
                            if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
                        elseif name == "TpDown" then
                            doTpDown()
                            setActive(true)
                            task.delay(0.2, function() setActive(false) end)
                        elseif name == "Carry" then
                            if not speedMode then
                                speedMode = true; laggerToggled = false; laggerCarryToggled = false
                                setActive(true)
                                if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                                if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                            else speedMode = false; setActive(false) end
                            refreshSpeedModeLabel()
                        elseif name == "Lagger1" then
                            if not laggerToggled then
                                laggerToggled = true; speedMode = false; laggerCarryToggled = false
                                setActive(true)
                                if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(false) end
                                if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                            else laggerToggled = false; setActive(false) end
                            refreshSpeedModeLabel()
                        elseif name == "Lagger2" then
                            if not laggerCarryToggled then
                                laggerCarryToggled = true; speedMode = false; laggerToggled = false
                                setActive(true)
                                if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(false) end
                                if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                            else laggerCarryToggled = false; setActive(false) end
                            refreshSpeedModeLabel()
                        end
                    elseif not uiLocked and hasMoved then
                        savedButtonPositions[name] = { X = btn.Position.X.Offset, Y = btn.Position.Y.Offset }
                        task.defer(saveAllSettings)
                    end
                    dragging = false; hasMoved = false
                    dragStart = nil; startPos = nil; movedDistance = 0
                    _isDraggingButton = false
                end
            end
        end)
        buttons[name] = {btn = btn, setActive = setActive, label = label}
        if name == "AutoBat" then mobSetAutoBat = setActive end
        if name == "AutoLeft" then mobSetAutoLeft = setActive end
        if name == "AutoRight" then mobSetAutoRight = setActive end
        if name == "DropBR" then mobSetDropBR = setActive end
        if name == "TpDown" then mobSetTpDown = setActive end
        if name == "Carry" then mobSetCarry = setActive end
        if name == "Lagger1" then mobSetLagger1 = setActive end
        if name == "Lagger2" then mobSetLagger2 = setActive end
    end
    return panel
end

function createTpBatFloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "TpBatButton"
    panel.ResetOnSpawn = false
    panel.DisplayOrder = 21
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = CoreGui end) then panel.Parent = LP:WaitForChild("PlayerGui") end
    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    btnFrame.Name = "Frame"
    btnFrame.Position = tpBatFloatingPos and UDim2.new(tpBatFloatingPos.XScale or 0.5, tpBatFloatingPos.XOffset or 20, tpBatFloatingPos.YScale or 0, tpBatFloatingPos.YOffset or 10) or UDim2.new(0.5, 20, 0, 10)
    btnFrame.BackgroundColor3 = BTN_BG_DARK
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 18)
    local bgGrad = Instance.new("UIGradient", btnFrame)
    bgGrad.Name = "BtnGrad"
    bgGrad.Rotation = 90
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(45, 45, 45)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(20, 20, 20)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0)),
    })
    local stroke = Instance.new("UIStroke", btnFrame)
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Thickness = BTN_STROKE_THICKNESS
    stroke.Transparency = BTN_STROKE_TRANSPARENCY
    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "TP\nBAT"
    label.TextColor3 = PASTEL_PINK
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 10
    label.TextWrapped = true
    label.ZIndex = 21
    local uiScale = Instance.new("UIScale", btnFrame)
    uiScale.Scale = floatingButtonScale
    table.insert(_floatingUIScales, uiScale)
    local dragging, hasMoved, dragStart, startPos
    btnFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true; hasMoved = false; dragStart = inp.Position; startPos = btnFrame.Position
        end
    end)
    btnFrame.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - dragStart
            if delta.Magnitude > 5 then hasMoved = true end
            if hasMoved and not uiLocked then
                btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    btnFrame.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                if not hasMoved then
                    toggleBatDesyncTp()
                    paintFloatingBtn(btnFrame, batDesyncTpEnabled)
                elseif not uiLocked and hasMoved then
                    tpBatFloatingPos = { XScale = btnFrame.Position.X.Scale, XOffset = btnFrame.Position.X.Offset, YScale = btnFrame.Position.Y.Scale, YOffset = btnFrame.Position.Y.Offset }
                    task.defer(saveAllSettings)
                end
                dragging = false; hasMoved = false
            end
        end
    end)
    tpBatFloatingButton = panel
    return panel
end

function createBatBypassFloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "BatBypassButton"
    panel.ResetOnSpawn = false
    panel.DisplayOrder = 22
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = CoreGui end) then panel.Parent = LP:WaitForChild("PlayerGui") end
    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    btnFrame.Name = "Frame"
    btnFrame.Position = batBypassFloatingPos and UDim2.new(batBypassFloatingPos.XScale or 0.5, batBypassFloatingPos.XOffset or 60, batBypassFloatingPos.YScale or 0, batBypassFloatingPos.YOffset or 10) or UDim2.new(0.5, 60, 0, 10)
    btnFrame.BackgroundColor3 = BTN_BG_DARK
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 18)
    local bgGrad = Instance.new("UIGradient", btnFrame)
    bgGrad.Name = "BtnGrad"
    bgGrad.Rotation = 90
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(45, 45, 45)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(20, 20, 20)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0)),
    })
    local stroke = Instance.new("UIStroke", btnFrame)
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Thickness = BTN_STROKE_THICKNESS
    stroke.Transparency = BTN_STROKE_TRANSPARENCY
    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "BAT\nBYPASS"
    label.TextColor3 = PASTEL_PINK
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 10
    label.TextWrapped = true
    label.ZIndex = 21
    local uiScale = Instance.new("UIScale", btnFrame)
    uiScale.Scale = floatingButtonScale
    table.insert(_floatingUIScales, uiScale)
    local dragging, hasMoved, dragStart, startPos
    btnFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true; hasMoved = false; dragStart = inp.Position; startPos = btnFrame.Position
        end
    end)
    btnFrame.InputChanged:Connect(function(inp)
        if not dragging then return end
        if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
            local delta = inp.Position - dragStart
            if delta.Magnitude > 5 then hasMoved = true end
            if hasMoved and not uiLocked then
                btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
            end
        end
    end)
    btnFrame.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            if dragging then
                if not hasMoved then
                    _G.RaptureToggleBatBypass()
                    paintFloatingBtn(btnFrame, _G._RaptureBatBypass.enabled)
                elseif not uiLocked and hasMoved then
                    batBypassFloatingPos = { XScale = btnFrame.Position.X.Scale, XOffset = btnFrame.Position.X.Offset, YScale = btnFrame.Position.Y.Scale, YOffset = btnFrame.Position.Y.Offset }
                    task.defer(saveAllSettings)
                end
                dragging = false; hasMoved = false
            end
        end
    end)
    batBypassFloatingButton = panel
    return panel
end

function createInstaResetFloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "InstaResetButton"
    panel.ResetOnSpawn = false
    panel.DisplayOrder = 23
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = CoreGui end) then panel.Parent = LP:WaitForChild("PlayerGui") end
    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 60, 0, 60)
    btnFrame.Name = "Frame"
    btnFrame.Position = instaResetFloatingPos and UDim2.new(instaResetFloatingPos.XScale or 0.5, instaResetFloatingPos.XOffset or 100, instaResetFloatingPos.YScale or 0, instaResetFloatingPos.YOffset or 10) or UDim2.new(0.5, 100, 0, 10)
    btnFrame.BackgroundColor3 = BTN_BG_DARK
    btnFrame.BorderSizePixel = 0
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 18)
    local bgGrad = Instance.new("UIGradient", btnFrame)
    bgGrad.Name = "BtnGrad"
    bgGrad.Rotation = 90
    bgGrad.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(45, 45, 45)),
        ColorSequenceKeypoint.new(0.45, Color3.fromRGB(20, 20, 20)),
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(0, 0, 0)),
    })
    local stroke = Instance.new("UIStroke", btnFrame)
    stroke.Color = Color3.fromRGB(0, 0, 0)
    stroke.Thickness = BTN_STROKE_THICKNESS
    stroke.Transparency = BTN_STROKE_TRANSPARENCY
    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "INSTA\nRESET"
    label.TextColor3 = PASTEL_PINK
    label.Font = Enum.Font.GothamBlack
    label.TextSize = 10
    label.TextWrapped = true
    label.ZIndex = 21
    local uiScale = Instance.new("UIScale", btnFrame)
    uiScale.Scale = floatingButtonScale
    table.insert(_floatingUIScales, uiScale)
    local dragging, hasMoved, dragStart, startPos, activeInput
    btnFrame.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            activeInput = inp
            dragging = true; hasMoved = false; dragStart = inp.Position; startPos = btnFrame.Position
        end
    end)
    UIS.InputChanged:Connect(function(inp)
        if not dragging or not activeInput then return end
        local isTouchMove = activeInput.UserInputType == Enum.UserInputType.Touch and inp == activeInput
        local isMouseMove = activeInput.UserInputType == Enum.UserInputType.MouseButton1 and inp.UserInputType == Enum.UserInputType.MouseMovement
        if not isTouchMove and not isMouseMove then return end
        local delta = inp.Position - dragStart
        if delta.Magnitude > 12 then hasMoved = true end
        if hasMoved and not uiLocked then
            btnFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UIS.InputEnded:Connect(function(inp)
        if inp ~= activeInput then return end
        if inp.UserInputType ~= Enum.UserInputType.MouseButton1 and inp.UserInputType ~= Enum.UserInputType.Touch then return end
        if dragging then
            if not hasMoved then
                if _G.InstaReset and _G.InstaReset.Trigger then _G.InstaReset.Trigger() end
            elseif not uiLocked and hasMoved then
                instaResetFloatingPos = { XScale = btnFrame.Position.X.Scale, XOffset = btnFrame.Position.X.Offset, YScale = btnFrame.Position.Y.Scale, YOffset = btnFrame.Position.Y.Offset }
                task.defer(saveAllSettings)
            end
            dragging = false; hasMoved = false; activeInput = nil
        end
    end)
    instaResetFloatingButton = panel
    return panel
end

function updateUIFromLoaded()
    task.wait()
    if normalBox then normalBox.Text = tostring(NS) end
    if carryBox then carryBox.Text = tostring(CS) end
    if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
    if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end
    if lagger2Box then lagger2Box.Text = tostring(LAGGER_CARRY_SPEED) end
    if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
    if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
    if progressBarScaleBox then progressBarScaleBox.Text = tostring(progressBarScaleValue) end
    if stretchValueBox then stretchValueBox.Text = tostring(stretchValue) end
    refreshSpeedModeLabel()
    for _, ref in ipairs(keyButtonRefs) do
        local entry = ref.entry
        local label = (entry.gp and entry.gp.Name) or (entry.kb and entry.kb.Name) or "None"
        ref.btn.Text = label
    end
    if savedProgressBarPos and pbFrame then
        pbFrame.Position = UDim2.new(savedProgressBarPos.XScale or 0.5, savedProgressBarPos.XOffset or -240, savedProgressBarPos.YScale or 1, savedProgressBarPos.YOffset or -90)
    end
    local bgImg = main and main:FindFirstChild("BackgroundImage")
    if bgImg then
        bgImg.Image = "rbxassetid://" .. backgroundImages[backgroundIndex]
        bgImg.ImageTransparency = backgroundImageTransparency
    end
    applyFloatingButtonScale()
    if uiLocked and setLockUIVisual then setLockUIVisual(true) end
    if antiRagdollEnabled then
        if setAntiRagVisual then setAntiRagVisual(true) end
        if antiRagdollVersion == "v1" then AntiRagdollV1.start()
        elseif antiRagdollVersion == "v2" then startAntiRagdollV2() end
    end
    if antiDieEnabled then
        if setAntiDieVisual then setAntiDieVisual(true) end
        _antiDie.StartEngine()
    end
    if antiFlingEnabled then
        if setAntiFlingVisual then setAntiFlingVisual(true) end
        startAntiFling()
    end
    if CONFIG.AUTO_STEAL_ENABLED and setInstaGrab then setInstaGrab(true); pcall(startAutoSteal) end
    if medusaCounterEnabled and setMedusaVisual then setMedusaVisual(true); if LP.Character then setupMedusaCounter(LP.Character) end end
    if batCounterEnabled and setBatCounterVisual then setBatCounterVisual(true); startBatCounter() end
    if ragdollCountdownEnabled and setRagdollTimerVisual then setRagdollTimerVisual(true); hookRagdollCountdown(LP.Character) end
    if espEnabled and setESPVisual then setESPVisual(true); startESP() end
    if antiLagEnabled and setAntiLagVisual then setAntiLagVisual(true); enableAntiLag() end
    if stretchEnabled and _G.stretchToggleSetter then _G.stretchToggleSetter(true) end
    if setFovVisual then setFovVisual(fovEnabled) end
    if fovSliderSet then fovSliderSet(fovValue) end
    if batDesyncTpEnabled then
        if batDesyncTpSetVisual then batDesyncTpSetVisual(true) end
        if not batDesyncTpConn then startBatDesyncTp() end
    end
    if batBypassEnabled then
        if batBypassSetVisual then batBypassSetVisual(true) end
        if not _G._RaptureBatBypass.enabled then _G.RaptureStartBatBypass() end
    end
    if aimbotModeSetVisual then aimbotModeSetVisual(aimbotMode) end
    if antiRagSetVisual then antiRagSetVisual(antiRagdollVersion == "v1" and "V1" or "V2") end
    if customSoundsEnabled and _G.RaptureCustomSounds then _G.RaptureCustomSounds.setEnabled(true) end
    if minecraftBatSkinEnabled then
        MinecraftBatSkin.State.enabled = true
        MinecraftBatSkin.SetColorMode(minecraftBatSkinColorMode)
        task.defer(function() pcall(MinecraftBatSkin.Apply) end)
    else
        MinecraftBatSkin.State.enabled = false
        task.defer(function() pcall(MinecraftBatSkin.Remove) end)
    end
    startEnemySpeed()
    toggleLockUI(uiLocked)
end

buildGui()
if loadAllSettings() then updateUIFromLoaded() end

task.defer(function()
    task.wait(0.15)
    if _RaptureApplyThemeToSliders then _RaptureApplyThemeToSliders() end
    for _, entry in ipairs(_G._RaptureDynamicSliders) do
        pcall(function() entry.applyThemeColor(PASTEL_PINK) end)
    end
end)

speedMode = false
laggerToggled = false
laggerCarryToggled = false
refreshSpeedModeLabel()

MobilePanel = createMobilePanel()
tpBatFloatingButton = createTpBatFloatingButton()
batBypassFloatingButton = createBatBypassFloatingButton()
instaResetFloatingButton = createInstaResetFloatingButton()

if LP.Character then
    task.wait(0.1)
    if waitForCharReady(LP.Character, 5) then setupMovementAndIndicators(LP.Character) end
end

LP.CharacterAdded:Connect(function(char)
    if stealConnection then stealConnection:Disconnect(); stealConnection = nil end
    isStealing = false
    stopAutoLeft()
    stopAutoRight()
    stopBatCounter()
    stopMedusaCounter()
    if not _tpBatUnwalkForced then stopUnwalk() end
    stopDropBrainrot()
    if autoBatEnabled then disableAutoBat() end
    if batDesyncTpEnabled then stopBatDesyncTp() end
    if _G._RaptureBatBypass and _G._RaptureBatBypass.enabled then _G.RaptureStopBatBypass() end
    task.wait(0.5)
    if not char.Parent then return end
    _hookedVelParts = {}
    _setupVelChecked(char)
    setupMovementAndIndicators(char)
    if antiRagdollEnabled then
        if antiRagdollVersion == "v1" then AntiRagdollV1.start()
        elseif antiRagdollVersion == "v2" then startAntiRagdollV2() end
    end
    if antiDieEnabled then _antiDie.StartEngine() end
    if antiFlingEnabled then startAntiFling() end
    if CONFIG.AUTO_STEAL_ENABLED then pcall(startAutoSteal) end
    if batDesyncTpEnabled then task.defer(startBatDesyncTp) end
    if medusaCounterEnabled then setupMedusaCounter(char) end
    if batCounterEnabled then startBatCounter() end
    if espEnabled then stopESP(); task.wait(0.2); startESP() end
    if ragdollCountdownEnabled then hookRagdollCountdown(char) end
    if unwalkEnabled and not _tpBatUnwalkForced then startUnwalk() end
    if minecraftBatSkinEnabled then
        task.wait(0.6)
        pcall(MinecraftBatSkin.Apply)
    end
    refreshSpeedModeLabel()
end)

local lastLaggerToggle = 0
local LAGGER_COOLDOWN = 0.3

UIS.InputBegan:Connect(function(input, gpe)
    if _anyKeyListening then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if gpe or UIS:GetFocusedTextBox() then return end
    elseif not isGamepadInput(input) then return end
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
    if kbMatch(KB.InstaReset, kc) then
        if _G.InstaReset and _G.InstaReset.Trigger then _G.InstaReset.Trigger() end
        return
    end
    if kbMatch(KB.BatBypass, kc) then
        _G.RaptureToggleBatBypass()
        if batBypassSetVisual then batBypassSetVisual(_G._RaptureBatBypass.enabled) end
        return
    end
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
    if kbMatch(KB.TPBat, kc) then
        toggleBatDesyncTp()
        if batDesyncTpSetVisual then batDesyncTpSetVisual(batDesyncTpEnabled) end
        return
    end
    if kbMatch(KB.GuiHide, kc) then
        if main then
            if main.Visible then hideGui() else showGui() end
        end
        return
    end
end)

task.defer(function()
    task.wait(0.1)
    _RaptureApplyThemeToSliders()
end)

print("===========================================")
print("  RAPTURE DUEL CARGADO v8.0.5")
print("  ❌ Steal Mode eliminado (siempre V2)")
print("  ✅ Barra de Steal con imagen de fondo")
print("  ✅ Fondo negro invisible")
print("  ✅ Sin Discord en la barra de steal")
print("  ✅ FPS + MS grandes (TextSize 22)")
print("  ✅ Barra gris + rosa neón")
print("===========================================")