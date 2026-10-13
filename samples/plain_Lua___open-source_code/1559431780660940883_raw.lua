-- ═══════════════════════════════════════════════════════════
--  WAVELI  HUB
--  Modern minimalist UI · 4 themes (B&W, Red, Blue, Pink)
--  All original mechanics preserved
-- ═══════════════════════════════════════════════════════════

-- ============================================================================
-- INTRO SEQUENCE
-- ============================================================================
task.spawn(function()
    local TweenService = game:GetService("TweenService")
    local CoreGui      = game:GetService("CoreGui")
    local SoundService = game:GetService("SoundService")

    local SONG_ID        = "rbxassetid://126107591945718"
    local SONG_VOL       = 0.7
    local INTRO_DURATION = 3.2
    local BLINK_INTERVAL = 0.15

    local blur = Instance.new("BlurEffect")
    blur.Size   = 56
    blur.Parent = game:GetService("Lighting")

    local introGui = Instance.new("ScreenGui")
    introGui.Name            = "WaveliIntro"
    introGui.ResetOnSpawn    = false
    introGui.IgnoreGuiInset  = true
    introGui.ZIndexBehavior  = Enum.ZIndexBehavior.Global
    introGui.Parent          = CoreGui

    local overlay = Instance.new("Frame", introGui)
    overlay.Size = UDim2.new(1,0,1,0)
    overlay.BackgroundColor3 = Color3.fromRGB(0,0,0)
    overlay.BackgroundTransparency = 0.55
    overlay.BorderSizePixel = 0
    overlay.ZIndex = 100

    local tag = Instance.new("TextLabel", introGui)
    tag.Size                   = UDim2.new(0, 520, 0, 94)
    tag.Position               = UDim2.new(0.5, -260, 0.5, -56)
    tag.BackgroundTransparency = 1
    tag.Text                   = ".gg/wavelix"
    tag.Font                   = Enum.Font.GothamBlack
    tag.TextSize               = 52
    tag.TextColor3             = Color3.fromRGB(255, 255, 255)
    tag.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
    tag.TextStrokeTransparency = 0.7
    tag.TextXAlignment         = Enum.TextXAlignment.Center
    tag.TextTransparency       = 0
    tag.ZIndex                 = 110

    local line = Instance.new("Frame", introGui)
    line.Size = UDim2.new(0, 340, 0, 1)
    line.Position = UDim2.new(0.5, -170, 0.5, 36)
    line.BackgroundColor3 = Color3.fromRGB(210, 210, 225)
    line.BackgroundTransparency = 0.2
    line.BorderSizePixel = 0
    line.ZIndex = 110

    local sub = Instance.new("TextLabel", introGui)
    sub.Size                   = UDim2.new(0, 520, 0, 30)
    sub.Position               = UDim2.new(0.5, -260, 0.5, 42)
    sub.BackgroundTransparency = 1
    sub.Text                   = "H  U  B"
    sub.Font                   = Enum.Font.GothamBold
    sub.TextSize               = 18
    sub.TextColor3             = Color3.fromRGB(175, 175, 198)
    sub.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
    sub.TextStrokeTransparency = 0.5
    sub.TextXAlignment         = Enum.TextXAlignment.Center
    sub.TextTransparency       = 0
    sub.ZIndex                 = 110

    local snd = Instance.new("Sound")
    snd.SoundId            = SONG_ID
    snd.Volume             = SONG_VOL
    snd.Looped             = false
    snd.RollOffMode        = Enum.RollOffMode.InverseTapered
    snd.RollOffMinDistance = 10000
    snd.RollOffMaxDistance = 10000
    snd.TimePosition       = 34
    snd.Parent             = SoundService
    if not snd.IsLoaded then
        local loaded = false
        task.spawn(function() snd.Loaded:Wait(); loaded = true end)
        local t = 0
        while not loaded and t < 0.5 do task.wait(0.05); t = t + 0.05 end
    end
    pcall(function() snd:Play() end)

    local blinkActive = true
    local visible     = true
    task.spawn(function()
        while blinkActive do
            task.wait(BLINK_INTERVAL)
            visible = not visible
            tag.TextTransparency  = visible and 0 or 1
            sub.TextTransparency  = visible and 0 or 0.5
            line.BackgroundTransparency = visible and 0.4 or 0.85
        end
    end)

    task.wait(INTRO_DURATION)

    blinkActive = false
    local fadeInfo = TweenInfo.new(0.6, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
    tag.TextTransparency = 0
    TweenService:Create(tag,     fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(sub,     fadeInfo, {TextTransparency = 1}):Play()
    TweenService:Create(line,    fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(overlay, fadeInfo, {BackgroundTransparency = 1}):Play()
    TweenService:Create(snd,     TweenInfo.new(0.6), {Volume = 0}):Play()
    TweenService:Create(blur,    fadeInfo, {Size = 0}):Play()
    task.wait(0.7)

    pcall(function() snd:Stop(); snd:Destroy() end)
    pcall(function() blur:Destroy() end)
    pcall(function() introGui:Destroy() end)

    local pg = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    local hubGui = pg:FindFirstChild("WaveliHubGUI")
    if hubGui then
        local m = hubGui:FindFirstChild("Main")
        if m then m.Visible = true end
        for _, child in ipairs(hubGui:GetChildren()) do
            if child:IsA("Frame") and child.Name ~= "Main" and child.ZIndex == 2 then
                child.Visible = true
            end
        end
    end
end)

-- ============================================================================
-- WAVELI  HUB MAIN
-- ============================================================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local ContentProvider = game:GetService("ContentProvider")
local LP = Players.LocalPlayer
local State = {
        normalSpeed = 60, carrySpeed = 30,
        speedToggled = false, autoBatToggled = false,
        hittingCooldown = false, infJumpEnabled = false,
        antiRagdollEnabled = false, fpsBoostEnabled = false,
        guiVisible = true,
        isStealing = false, stealStartTime = nil, lastStealTick = 0, lastKnownHealth = 100,
        autoLeftEnabled = false, autoRightEnabled = false,
        autoLeftPhase = 1, autoRightPhase = 1,
        medusaLastUsed = 0, medusaDebounce = false, medusaCounterEnabled = false,
        dropBrainrotActive = false,
        countdownEnabled = true,
        autoPlayEnabled = false, autoPlayWaypoint = 1,
        autoPlayWaiting = false, autoPlayWaitingCountdown = false,
        _tpInProgress = false, detectedBaseSide = nil,
        lastMoveDir = Vector3.new(0,0,0), unwalkEnabled = false,
        customFontEnabled = false,
        batCounterEnabled = false, batCounterLastUsed = 0, _lastHealthBC = 100,
        stretchedResEnabled = false,
        hopPower = 35, hopCooldown = 0.08, lastHopTime = 0,
        laggerModeEnabled = false, laggerSpeed = 15,
        animEnabled = false,
        _autoBatLastHP = 100, _autoBatLastSwing = 0,
        currentTab = "Speed",
        jumpMode = "Single",
        floatRiseSpeed = 30, floatFallSpeed = 50, floatStopMode = "TP Down",
        batCounterFollow = true,
        aimbotHitMode = "Auto Swing",
        menuOpacity = 100, menuSize = 100, speedModeSize = 100,
        noCamCollisionEnabled = false,
        ultraModeEnabled = false,
        floatEnabled = false, floatHeight = 9.5,
        currentTheme = 4, -- 1=B&W, 2=Red, 3=Blue, 4=Pink
        currentBg = 1,    -- 1=Dark Wreath, 2=Blue Bloom, 3=Pink Bloom, 4=Dark Waves, 5=Topo Lines
        mobBtnVisible = true,
        mobBtnLocked  = false,
}

-- AUTO BAT (Cursed Hub) — constants
local AUTO_BAT_SPEED       = 58
local AUTO_BAT_VERT_SPEED  = 52
local AUTO_BAT_DIST        = -2.8
local AUTO_BAT_HEIGHT      = 4.75
local AUTO_BAT_V_OFF       = 1
local AUTO_BAT_TURN_SPEED  = 285
local AUTO_BAT_MAX_TURN_RATE = 28
local _autoBatEquippedThisRun = false
local _autoBatTargetRoot  = nil
local _autoBatLastScan    = 0

local Keys = {
        autoBat = Enum.KeyCode.E, speed = Enum.KeyCode.Q,
        guiHide = Enum.KeyCode.U,
        autoLeft = Enum.KeyCode.L, autoRight = Enum.KeyCode.R,
        dropBrainrot = Enum.KeyCode.H,
        autoPlay = Enum.KeyCode.P,
        laggerMode = Enum.KeyCode.B,
        tpDown = Enum.KeyCode.T,
}

local Steal = {
        AutoStealEnabled = false, StealRadius = 8, StealDuration = 0.19,
        Data = {}, plotCache = {}, plotCacheTime = {},
        cachedPrompts = {}, promptCacheTime = 0,
}

-- ── Magik Auto Grab (100 stud, 1.30s delay — @magik.z) ─────────────────────
local MagikGrab = {
    Enabled    = false,
    Delay      = 1.30,
    ScanRadius = 150,
    isStealing = false,
}
local _magikThread = nil
local _magikGrabTick  -- forward declaration
-- ──────────────────────────────────────────────────────────────────────────────

local Bypass = {Power = 10000, Depth = 296, Key = Enum.KeyCode.F}

local MOVE_KEYS = {
        [Enum.KeyCode.W]=true,[Enum.KeyCode.A]=true,
        [Enum.KeyCode.S]=true,[Enum.KeyCode.D]=true,
        [Enum.KeyCode.Up]=true,[Enum.KeyCode.Left]=true,
        [Enum.KeyCode.Down]=true,[Enum.KeyCode.Right]=true,
}

local PLOT_CACHE_DURATION = 2
local PROMPT_CACHE_REFRESH = 0.15
local STEAL_COOLDOWN = 0.05
local AUTO_START_DELAY = 0.7
local DROP_ASCEND_DURATION = 0.2
local DROP_ASCEND_SPEED = 150
local MEDUSA_COOLDOWN = 25

local SlapList = {
        {1, "Bat"}, {2, "Slap"}, {3, "Iron Slap"}, {4, "Gold Slap"},
        {5, "Diamond Slap"}, {6, "Emerald Slap"}, {7, "Ruby Slap"},
        {8, "Dark Matter Slap"}, {9, "Flame Slap"}, {10, "Nuclear Slap"},
        {11, "Galaxy Slap"}, {12, "Glitched Slap"}
}

local POS = {
        L1 = Vector3.new(-476.48,-6.28,92.73), L2 = Vector3.new(-483.12,-4.95,94.80),
        R1 = Vector3.new(-476.16,-6.52,25.62), R2 = Vector3.new(-483.04,-5.09,23.14),
}

local RIGHT_STEP_3 = Vector3.new(-466.78, -7.10, 40.83)
local LEFT_STEP_3  = Vector3.new(-465.7, -7.0, 83.2)

local AP_RIGHT_WP = {
        Vector3.new(-473.04,-6.99,29.71), Vector3.new(-483.57,-5.10,18.74),
        Vector3.new(-475.00,-6.99,26.43), Vector3.new(-474.67,-6.94,105.48),
}
local AP_LEFT_WP = {
        Vector3.new(-472.49,-7.00,90.62), Vector3.new(-484.62,-5.10,100.37),
        Vector3.new(-475.08,-7.00,93.29), Vector3.new(-474.22,-6.96,16.18),
}

local Conns = {
        autoSteal = nil, antiRag = nil, autoPlay = nil,
        autoLeft = nil, autoRight = nil,
        anchor = {}, progress = nil,
}

local h, hrp, speedLbl, _dcLbl
local setAutoPlay, setAutoLeft, setAutoRight
local setInstaGrab, setAutoBat, setInfJump, setAntiRag, setFps, setMedusaCounter
local setUnwalkToggle
local setLaggerMode, setTryhardAnim
local setupMedusaCounter, stopMedusaCounter, startAntiRagdoll, stopAntiRagdoll
local applyFPSBoost, startAutoSteal, stopAutoSteal
local startAutoLeft, stopAutoLeft, startAutoRight, stopAutoRight
local stopAutoPlay, saveConfig
local scheduleAutoSave
local toggleAutoPlay
local setCustomFont
local setBatCounter, setVisualStretch, setNoCamColl, setAntiLag, setUltraMode, setStretchedRes
local applyStretchedRes
local applyVisualStretch, removeVisualStretch, applyNoCamCollision, applyAntiLag, applyUltraMode
local resetBaseSide, getBaseSide, runDropBrainrot
local getBat, tryHitBat, performBatSwing
local enableAutoBat, disableAutoBat
local showHeadCountdown
local enableCustomFont, disableCustomFont
local startTryhardAnim, stopTryhardAnim
local saveOriginalAnims, applyAnimPack, restoreOriginalAnims
local modeValLbl, normalBox, carryBox, saveBtn
local hopPowerBox, hopCooldownBox
local autoBatKeyBtn, speedKeyBtn
local autoLeftKeyBtn, autoRightKeyBtn
local guiHideKeyBtn
local dropBrainrotKeyBtn
local laggerModeKeyBtn, laggerSpeedBox
local pbFrame, radiusFrame, progressPct, progressFill, progressRadLbl, radValBtn

-- ============================================================================
-- THEME SYSTEM (4 themes)
-- ============================================================================
local Themes = {
        -- 1: Black & White
        {
                name = "Mono",
                accent       = Color3.fromRGB(235, 235, 240),
                accentDim    = Color3.fromRGB(180, 180, 196),
                accentStrong = Color3.fromRGB(255, 255, 255),
                accentDark   = Color3.fromRGB(30, 30, 38),
        },
        -- 2: Black & Red
        {
                name = "Crimson",
                accent       = Color3.fromRGB(225, 60, 75),
                accentDim    = Color3.fromRGB(160, 50, 60),
                accentStrong = Color3.fromRGB(255, 80, 95),
                accentDark   = Color3.fromRGB(60, 18, 22),
        },
        -- 3: Black & Blue
        {
                name = "Azure",
                accent       = Color3.fromRGB(70, 130, 240),
                accentDim    = Color3.fromRGB(55, 95, 175),
                accentStrong = Color3.fromRGB(95, 155, 255),
                accentDark   = Color3.fromRGB(20, 30, 60),
        },
        -- 4: Black & Pink
        {
                name = "Rose",
                accent       = Color3.fromRGB(245, 100, 165),
                accentDim    = Color3.fromRGB(180, 75, 125),
                accentStrong = Color3.fromRGB(255, 130, 190),
                accentDark   = Color3.fromRGB(55, 20, 38),
        },
}

-- Base palette (dark, theme-agnostic)
local C_BG       = Color3.fromRGB(7, 7, 9)
local C_PANEL    = Color3.fromRGB(12, 12, 15)
local C_PANEL_2  = Color3.fromRGB(17, 17, 21)
local C_ROW      = Color3.fromRGB(15, 15, 19)
local C_ROW_HOV  = Color3.fromRGB(23, 23, 29)
local C_BORDER   = Color3.fromRGB(30, 30, 38)
local C_BORDER_HI= Color3.fromRGB(54, 54, 68)
local C_HEADER   = Color3.fromRGB(5, 5, 7)
local C_TAB_ACT  = Color3.fromRGB(20, 20, 26)
local C_TEXT     = Color3.fromRGB(238, 238, 245)
local C_TEXT_DIM = Color3.fromRGB(140, 140, 156)
local C_TEXT_MUTE= Color3.fromRGB(65, 65, 80)
local C_WHITE    = Color3.fromRGB(255, 255, 255)
local C_OFF_BG   = Color3.fromRGB(19, 19, 24)
local C_KEY_BG   = Color3.fromRGB(12, 12, 16)
local C_DANGER   = Color3.fromRGB(220, 70, 80)

-- Theme accessor (always returns current theme colors)
local function T()
        return Themes[State.currentTheme] or Themes[1]
end

-- Themed elements registry (for live theme switching)
local ThemedElements = {
        -- {element=, prop=, type="accent"/"accentStrong"/etc}
}
local function regTheme(element, prop, kind)
        table.insert(ThemedElements, {el=element, prop=prop, kind=kind})
end
local function applyTheme()
        local t = T()
        for _, e in ipairs(ThemedElements) do
                if e.el and e.el.Parent then
                        local col = t[e.kind] or t.accent
                        pcall(function() e.el[e.prop] = col end)
                end
        end
end

local LOGO_ID = "rbxassetid://107000024285887"
task.spawn(function() pcall(function() ContentProvider:PreloadAsync({LOGO_ID}) end) end)

local savedAnimate

local function startUnwalk()
        if State.unwalkEnabled then return end
        State.unwalkEnabled = true
        local c = LP.Character
        if not c then return end
        local hum = c:FindFirstChildOfClass("Humanoid")
        if hum then
                for _, t in ipairs(hum:GetPlayingAnimationTracks()) do
                        t:Stop()
                end
        end
        local anim = c:FindFirstChild("Animate")
        if anim then
                savedAnimate = anim:Clone()
                anim:Destroy()
        end
end

local function stopUnwalk()
        if not State.unwalkEnabled then return end
        State.unwalkEnabled = false
        local c = LP.Character
        if c and savedAnimate then
                savedAnimate.Parent = c
                savedAnimate.Disabled = false
                savedAnimate = nil
        end
end

local Camera = workspace.CurrentCamera

-- Clean up old GUIs
for _, name in pairs({"VyseSlottedGUI", "KyzenHubGUI", "AdaptHubGUI", "WaveliHubGUI"}) do
        local old = game:GetService("CoreGui"):FindFirstChild(name)
        if old then old:Destroy() end
        local oldPg = LP:FindFirstChild("PlayerGui") and LP.PlayerGui:FindFirstChild(name)
        if oldPg then oldPg:Destroy() end
end

local viewportSize = Camera.ViewportSize
local IS_MOBILE = UIS.TouchEnabled and not UIS.KeyboardEnabled

-- Draggable helper
local function makeDraggable(frame, linkedFrames)
        linkedFrames = linkedFrames or {}
        local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
        local linkedStart = {}
        frame.InputBegan:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
                        dragging = true; dragStart = inp.Position; startPos = frame.Position
                        linkedStart = {}
                        for i, lf in ipairs(linkedFrames) do
                                if lf then linkedStart[i] = lf.Position end
                        end
                        inp.Changed:Connect(function() if inp.UserInputState == Enum.UserInputState.End then dragging = false; if saveConfig then pcall(saveConfig) end end end)
                end
        end)
        frame.InputChanged:Connect(function(inp)
                if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then dragInput = inp end
        end)
        UIS.InputChanged:Connect(function(inp)
                if inp == dragInput and dragging then
                        local dx = inp.Position.X - dragStart.X
                        local dy = inp.Position.Y - dragStart.Y
                        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset+dx, startPos.Y.Scale, startPos.Y.Offset+dy)
                        for i, lf in ipairs(linkedFrames) do
                                if lf and linkedStart[i] then
                                        lf.Position = UDim2.new(linkedStart[i].X.Scale, linkedStart[i].X.Offset+dx, linkedStart[i].Y.Scale, linkedStart[i].Y.Offset+dy)
                                end
                        end
                end
        end)
end

-- ============================================================================
-- GALAXY / FLOAT MECHANIC (VectorForce)
-- ============================================================================
local _galaxyVF = nil
local _galaxyAtt = nil
local _spaceHeld = false
local _lastHopTime = 0

local function _setupGalaxyForce()
    pcall(function()
        local c = LP.Character; if not c then return end
        local h = c:FindFirstChild("HumanoidRootPart"); if not h then return end
        if _galaxyVF then _galaxyVF:Destroy() end
        if _galaxyAtt then _galaxyAtt:Destroy() end
        _galaxyAtt = Instance.new("Attachment"); _galaxyAtt.Parent = h
        _galaxyVF = Instance.new("VectorForce")
        _galaxyVF.Attachment0 = _galaxyAtt
        _galaxyVF.ApplyAtCenterOfMass = true
        _galaxyVF.RelativeTo = Enum.ActuatorRelativeTo.World
        _galaxyVF.Force = Vector3.new(0,0,0)
        _galaxyVF.Parent = h
    end)
end

local function _updateGalaxyForce()
    if not State.floatEnabled or not _galaxyVF then return end
    local c = LP.Character; if not c then return end
    local mass = 0
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") then mass = mass + p:GetMass() end
    end
    local gravPct = State.floatRiseSpeed
    local tg = 196.2 * (gravPct / 100)
    _galaxyVF.Force = Vector3.new(0, mass * (196.2 - tg) * 0.95, 0)
end

local function _doHop()
    pcall(function()
        local c = LP.Character; if not c then return end
        local h = c:FindFirstChild("HumanoidRootPart")
        local hum = c:FindFirstChildOfClass("Humanoid")
        if not h or not hum then return end
        if tick() - _lastHopTime < 0.08 then return end
        _lastHopTime = tick()
        if hum.FloorMaterial == Enum.Material.Air then
            h.AssemblyLinearVelocity = Vector3.new(
                h.AssemblyLinearVelocity.X,
                State.floatFallSpeed,
                h.AssemblyLinearVelocity.Z
            )
        end
    end)
end

RunService.Heartbeat:Connect(function()
    if _spaceHeld and State.floatEnabled then _doHop() end
    _updateGalaxyForce()
end)

UIS.InputBegan:Connect(function(i, gp)
    if not gp and i.KeyCode == Enum.KeyCode.Space then _spaceHeld = true end
end)
UIS.InputEnded:Connect(function(i)
    if i.KeyCode == Enum.KeyCode.Space then _spaceHeld = false end
end)

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    if State.floatEnabled then _setupGalaxyForce() end
end)

local function startFloat()
    State.floatEnabled = true
    _setupGalaxyForce()
end
local function stopFloat()
    State.floatEnabled = false
    if _galaxyVF then _galaxyVF:Destroy(); _galaxyVF = nil end
    if _galaxyAtt then _galaxyAtt:Destroy(); _galaxyAtt = nil end
end

local function runTPDown()
    pcall(function()
        local c = LP.Character; if not c then return end
        local hrp = c:FindFirstChild("HumanoidRootPart"); if not hrp then return end
        local hum = c:FindFirstChildOfClass("Humanoid"); if not hum then return end
        local rp = RaycastParams.new()
        rp.FilterDescendantsInstances = {c}
        rp.FilterType = Enum.RaycastFilterType.Exclude
        local hit = workspace:Raycast(hrp.Position, Vector3.new(0, -500, 0), rp)
        if hit then
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            local hh = hum.HipHeight or 2
            local hy = hrp.Size.Y / 2
            hrp.CFrame = CFrame.new(hit.Position.X, hit.Position.Y + hh + hy + 0.1, hit.Position.Z)
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
    end)
end

-- ============================================================================
-- PRE-GUI CONFIG LOAD  (Cursed Hub pattern)
-- Inject saved keybinds into Keys{} BEFORE the GUI builds so every button
-- is created with the correct label on first render.
-- ============================================================================
local _waveliSavedCfg = nil

local function _waveliLoadConfigKeys()
    if not (isfile and readfile) then return end
    local raw
    pcall(function()
        if isfile("WaveliConfig.json") then raw = readfile("WaveliConfig.json") end
    end)
    if not raw or raw == "" then return end
    local ok, cfg = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok or type(cfg) ~= "table" then return end
    _waveliSavedCfg = cfg

    -- lk: handles both new {kb=name} table AND old flat string
    local function lk(keysName, cfgVal)
        pcall(function()
            local name
            if type(cfgVal) == "table" then name = cfgVal.kb
            elseif type(cfgVal) == "string" then name = cfgVal end
            if not name then return end
            local kc
            pcall(function() kc = Enum.KeyCode[name] end)
            if not kc then
                for _, item in ipairs(Enum.KeyCode:GetEnumItems()) do
                    if item.Name == name then kc = item; break end
                end
            end
            if kc then Keys[keysName] = kc end
        end)
    end
    -- Also restore Bypass key early
    pcall(function()
        if cfg.bypassKey and type(cfg.bypassKey) == "string" then
            local bkc; pcall(function() bkc = Enum.KeyCode[cfg.bypassKey] end)
            if bkc then Bypass.Key = bkc end
        end
    end)

    lk("autoBat",      cfg.autoBatKey)
    lk("speed",        cfg.speedKey)
    lk("autoLeft",     cfg.autoLeftKey)
    lk("autoRight",    cfg.autoRightKey)
    lk("autoPlay",     cfg.autoPlayKey)
    lk("dropBrainrot", cfg.dropBrainrotKey)
    lk("guiHide",      cfg.guiHideKey)
    lk("laggerMode",   cfg.laggerKey)
    lk("tpDown",       cfg.tpDownKey)
end
_waveliLoadConfigKeys()   -- run NOW — before GUI is built

-- ============================================================================
-- MAIN UI
-- ============================================================================
;(function()

local W = IS_MOBILE and 290 or 320
local H = IS_MOBILE and 470 or 480
local HEADER_H  = 52
local TABBAR_H  = 32
local FOOTER_H  = 24
local CONTENT_H = H - HEADER_H - TABBAR_H - FOOTER_H

local gui = Instance.new("ScreenGui")
gui.Name = "WaveliHubGUI"
gui.ResetOnSpawn = false
gui.DisplayOrder = 10
gui.IgnoreGuiInset = true
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = LP:WaitForChild("PlayerGui")

local rootScale = Instance.new("UIScale")
rootScale.Scale = IS_MOBILE and 1.15 or 1.18
rootScale.Parent = gui

-- Shadow under main panel
local shadow = Instance.new("Frame", gui)
shadow.Name = "Shadow"
shadow.Size = UDim2.new(0, W+10, 0, H+10)
shadow.Position = UDim2.new(0, 18, 0, 18)
shadow.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
shadow.BackgroundTransparency = 0.55
shadow.BorderSizePixel = 0
shadow.Visible = false
shadow.ZIndex = 2
Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 16)

-- Main panel
local main = Instance.new("Frame", gui)
main.Name = "Main"
main.Size = UDim2.new(0, W, 0, H)
main.Position = UDim2.new(0, 22, 0, 22)
main.BackgroundColor3 = C_BG
main.BorderSizePixel = 0
main.Active = true
main.ClipsDescendants = true
main.Visible = false
main.ZIndex = 3
Instance.new("UICorner", main).CornerRadius = UDim.new(0, 16)

-- ── Background canvas ─────────────────────────────────────────────────────
local bgCanvas = Instance.new("Frame", main)
bgCanvas.Name = "BgCanvas"
bgCanvas.Size = UDim2.new(1, 0, 1, 0)
bgCanvas.BackgroundColor3 = Color3.fromRGB(6, 6, 8)
bgCanvas.BackgroundTransparency = 0
bgCanvas.BorderSizePixel = 0
bgCanvas.ZIndex = 3
bgCanvas.ClipsDescendants = false

local function clearBgCanvas()
    for _, ch in ipairs(bgCanvas:GetChildren()) do ch:Destroy() end
end

local function drawWreathPattern(col, alpha)
    math.randomseed(42)
    local function mw(cx,cy,oR,bR,n,a,j)
        j=j or 0
        for i=1,n do
            local ang=(i/n)*math.pi*2
            local b=Instance.new("Frame",bgCanvas)
            b.Size=UDim2.new(0,bR*2,0,bR*2)
            b.Position=UDim2.new(0,cx+math.cos(ang)*oR+(math.random()-.5)*j-bR,
                                    0,cy+math.sin(ang)*oR+(math.random()-.5)*j-bR)
            b.BackgroundColor3=col; b.BackgroundTransparency=a
            b.BorderSizePixel=0; b.ZIndex=4
            Instance.new("UICorner",b).CornerRadius=UDim.new(1,0)
        end
        local iR,iN=oR*.52,math.floor(n*.7)
        for i=1,iN do
            local ang=(i/iN)*math.pi*2+.3
            local br=bR*.72
            local b=Instance.new("Frame",bgCanvas)
            b.Size=UDim2.new(0,br*2,0,br*2)
            b.Position=UDim2.new(0,cx+math.cos(ang)*iR+(math.random()-.5)*j-br,
                                    0,cy+math.sin(ang)*iR+(math.random()-.5)*j-br)
            b.BackgroundColor3=col; b.BackgroundTransparency=a+.08
            b.BorderSizePixel=0; b.ZIndex=4
            Instance.new("UICorner",b).CornerRadius=UDim.new(1,0)
        end
    end
    mw(-18, 88,52,22,10,alpha,8); mw(258,108,40,17, 9,alpha,7)
    mw( 32,272,58,24,10,alpha,9); mw(232,308,38,16, 9,alpha+.01,7)
    mw( 68,415,52,22,10,alpha,8); mw(288,450,44,19, 9,alpha,7)
end

local function drawWavesPattern()
    local waveData = {
        {x=-60,y= 30,w=180,h=60,r=30,t=0.3},{x= 80,y= 10,w=220,h=50,r=25,t=0.4},
        {x=-40,y=120,w=160,h=70,r=35,t=0.3},{x=130,y= 90,w=200,h=55,r=28,t=0.35},
        {x= 20,y=210,w=240,h=65,r=32,t=0.3},{x=-30,y=300,w=180,h=60,r=30,t=0.4},
        {x=110,y=270,w=210,h=55,r=27,t=0.35},{x= 50,y=380,w=230,h=70,r=33,t=0.3},
        {x=-20,y=450,w=200,h=60,r=30,t=0.4},{x=150,y=400,w=180,h=50,r=25,t=0.35},
    }
    for _,d in ipairs(waveData) do
        local f=Instance.new("Frame",bgCanvas)
        f.Size=UDim2.new(0,d.w,0,d.h); f.Position=UDim2.new(0,d.x,0,d.y)
        f.BackgroundColor3=Color3.fromRGB(0,0,0); f.BackgroundTransparency=d.t
        f.BorderSizePixel=0; f.ZIndex=4
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,d.r)
        local f2=Instance.new("Frame",bgCanvas)
        f2.Size=UDim2.new(0,d.w-30,0,d.h-20); f2.Position=UDim2.new(0,d.x+15,0,d.y+10)
        f2.BackgroundColor3=Color3.fromRGB(0,0,0); f2.BackgroundTransparency=d.t+.2
        f2.BorderSizePixel=0; f2.ZIndex=4
        Instance.new("UICorner",f2).CornerRadius=UDim.new(0,d.r-5>0 and d.r-5 or 5)
    end
end

local function drawTopoPattern()
    local rings = {
        {cx=60,cy=100,w=120,h=80},{cx=60,cy=100,w=90,h=60},{cx=60,cy=100,w=60,h=40},{cx=60,cy=100,w=30,h=20},
        {cx=230,cy=80,w=100,h=70},{cx=230,cy=80,w=70,h=50},{cx=230,cy=80,w=40,h=28},
        {cx=100,cy=280,w=140,h=90},{cx=100,cy=280,w=110,h=68},{cx=100,cy=280,w=80,h=48},
        {cx=100,cy=280,w=50,h=30},{cx=100,cy=280,w=22,h=14},
        {cx=240,cy=240,w=110,h=75},{cx=240,cy=240,w=80,h=55},{cx=240,cy=240,w=50,h=35},
        {cx=50,cy=420,w=130,h=85},{cx=50,cy=420,w=100,h=62},{cx=50,cy=420,w=70,h=42},{cx=50,cy=420,w=40,h=24},
        {cx=260,cy=390,w=120,h=78},{cx=260,cy=390,w=90,h=56},{cx=260,cy=390,w=60,h=36},
    }
    for _,r in ipairs(rings) do
        local f=Instance.new("Frame",bgCanvas)
        f.Size=UDim2.new(0,r.w,0,r.h); f.Position=UDim2.new(0,r.cx-r.w/2,0,r.cy-r.h/2)
        f.BackgroundTransparency=1; f.BorderSizePixel=0; f.ZIndex=4
        local st=Instance.new("UIStroke",f)
        st.Color=Color3.fromRGB(255,255,255); st.Thickness=1; st.Transparency=0.65
        Instance.new("UICorner",f).CornerRadius=UDim.new(0,math.floor(r.h/2))
    end
end

local BgStyles = {
    { name="Dark Wreath",  bg=Color3.fromRGB(6,6,8) },
    { name="Blue Bloom",   bg=Color3.fromRGB(93,112,175) },
    { name="Pink Bloom",   bg=Color3.fromRGB(218,130,185) },
    { name="Dark Waves",   bg=Color3.fromRGB(18,18,18) },
    { name="Topo Lines",   bg=Color3.fromRGB(0,0,0) },
}

local bgBtns = {}
local function setBackground(idx)
    State.currentBg = idx
    if scheduleAutoSave then scheduleAutoSave() end
    clearBgCanvas()
    local style = BgStyles[idx]
    bgCanvas.BackgroundColor3 = style.bg
    if idx == 1 then drawWreathPattern(Color3.fromRGB(255,255,255), 0.12)
    elseif idx == 2 then drawWreathPattern(Color3.fromRGB(255,255,255), 0.08)
    elseif idx == 3 then drawWreathPattern(Color3.fromRGB(255,255,255), 0.08)
    elseif idx == 4 then drawWavesPattern()
    elseif idx == 5 then drawTopoPattern()
    end
    for i, btn in ipairs(bgBtns) do
        if btn and btn.Parent then
            btn.BackgroundColor3 = (i==idx) and Color3.fromRGB(255,105,180) or Color3.fromRGB(25,25,30)
            btn.TextColor3 = (i==idx) and Color3.fromRGB(255,255,255) or Color3.fromRGB(160,160,170)
        end
    end
end

setBackground(State.currentBg or 1)

-- ── Thin pink top accent bar ───────────────────────────────────────────────
local topBar = Instance.new("Frame", main)
topBar.Size = UDim2.new(1, 0, 0, 3)
topBar.Position = UDim2.new(0, 0, 0, 0)
topBar.BackgroundColor3 = T().accent
topBar.BorderSizePixel = 0
topBar.ZIndex = 20
regTheme(topBar, "BackgroundColor3", "accent")

-- ── HEADER ─────────────────────────────────────────────────────────────────
local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, HEADER_H)
header.Position = UDim2.new(0, 0, 0, 3)
header.BackgroundTransparency = 1
header.BorderSizePixel = 0
header.ZIndex = 10

-- Logo icon (small colored diamond)
local logoIcon = Instance.new("Frame", header)
logoIcon.Size = UDim2.new(0, 22, 0, 22)
logoIcon.Position = UDim2.new(0, 12, 0.5, -11)
logoIcon.BackgroundColor3 = T().accent
logoIcon.BorderSizePixel = 0
logoIcon.ZIndex = 11
Instance.new("UICorner", logoIcon).CornerRadius = UDim.new(0, 6)
regTheme(logoIcon, "BackgroundColor3", "accent")
local logoInner = Instance.new("Frame", logoIcon)
logoInner.Size = UDim2.new(0, 10, 0, 10)
logoInner.Position = UDim2.new(0.5, -5, 0.5, -5)
logoInner.BackgroundColor3 = Color3.fromRGB(255,255,255)
logoInner.BackgroundTransparency = 0.3
logoInner.BorderSizePixel = 0
logoInner.ZIndex = 12
Instance.new("UICorner", logoInner).CornerRadius = UDim.new(0, 3)

-- Title "WAVELI HUB"
local titleLbl = Instance.new("TextLabel", header)
titleLbl.Size = UDim2.new(0, 130, 0, 18)
titleLbl.Position = UDim2.new(0, 40, 0, 8)
titleLbl.BackgroundTransparency = 1
titleLbl.RichText = true
titleLbl.TextColor3 = Color3.fromRGB(240, 240, 240)
titleLbl.Font = Enum.Font.GothamBlack
titleLbl.TextSize = 15
titleLbl.TextXAlignment = Enum.TextXAlignment.Left
titleLbl.ZIndex = 11
local function _updateTitleLbl()
    local acc = T().accent
    local r = math.round(acc.R * 255)
    local g = math.round(acc.G * 255)
    local b = math.round(acc.B * 255)
    titleLbl.Text = string.format('WAVELI <font color="rgb(%d,%d,%d)">HUB</font>', r, g, b)
end
_updateTitleLbl()
table.insert(ThemedElements, {el=titleLbl, custom=function() _updateTitleLbl() end})

-- Subtitle ".gg/wavelix"
local subLbl = Instance.new("TextLabel", header)
subLbl.Size = UDim2.new(0, 130, 0, 13)
subLbl.Position = UDim2.new(0, 40, 0, 28)
subLbl.BackgroundTransparency = 1
subLbl.Text = ".gg/wavelix"
subLbl.TextColor3 = C_TEXT_MUTE
subLbl.Font = Enum.Font.Gotham
subLbl.TextSize = 10
subLbl.TextXAlignment = Enum.TextXAlignment.Left
subLbl.ZIndex = 11

-- Theme button "Rose"
local themeBtn = Instance.new("TextButton", header)
themeBtn.Size = UDim2.new(0, 50, 0, 22)
themeBtn.Position = UDim2.new(1, -88, 0.5, -11)
themeBtn.BackgroundColor3 = Color3.fromRGB(18, 14, 20)
themeBtn.BorderSizePixel = 0
themeBtn.Text = T().name
themeBtn.TextColor3 = T().accent
themeBtn.Font = Enum.Font.GothamBold
themeBtn.TextSize = 10
themeBtn.AutoButtonColor = false
themeBtn.ZIndex = 12
Instance.new("UICorner", themeBtn).CornerRadius = UDim.new(0, 11)
local themeStroke = Instance.new("UIStroke", themeBtn)
themeStroke.Color = T().accent
themeStroke.Thickness = 1
themeStroke.Transparency = 0.3
regTheme(themeBtn, "TextColor3", "accent")
regTheme(themeStroke, "Color", "accent")
themeBtn.MouseButton1Click:Connect(function()
    State.currentTheme = (State.currentTheme % #Themes) + 1
    themeBtn.Text = T().name
    applyTheme()
    if scheduleAutoSave then scheduleAutoSave() end
end)

local function makeHeaderBtn(txt, xOff, txtSize)
    local b = Instance.new("TextButton", header)
    b.Size = UDim2.new(0, 24, 0, 22)
    b.Position = UDim2.new(1, -xOff - 24, 0.5, -11)
    b.BackgroundColor3 = Color3.fromRGB(18, 14, 20)
    b.BorderSizePixel = 0
    b.Text = txt; b.TextColor3 = C_TEXT_DIM
    b.Font = Enum.Font.GothamBold; b.TextSize = txtSize or 13
    b.AutoButtonColor = false; b.ZIndex = 12
    Instance.new("UICorner", b).CornerRadius = UDim.new(0, 11)
    local s = Instance.new("UIStroke", b); s.Color = C_BORDER; s.Thickness = 1; s.Transparency = 0.4
    b.MouseEnter:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3=Color3.fromRGB(30,22,36), TextColor3=T().accent}):Play()
        TweenService:Create(s, TweenInfo.new(0.12), {Color=T().accent, Transparency=0.1}):Play()
    end)
    b.MouseLeave:Connect(function()
        TweenService:Create(b, TweenInfo.new(0.12), {BackgroundColor3=Color3.fromRGB(18,14,20), TextColor3=C_TEXT_DIM}):Play()
        TweenService:Create(s, TweenInfo.new(0.12), {Color=C_BORDER, Transparency=0.4}):Play()
    end)
    return b
end

local minBtn   = makeHeaderBtn("—", 36, 13)
local closeBtn = makeHeaderBtn("×", 8, 16)

makeDraggable(main, {shadow})

-- ── TAB BAR ────────────────────────────────────────────────────────────────
local tabBar = Instance.new("Frame", main)
tabBar.Size = UDim2.new(1, 0, 0, TABBAR_H)
tabBar.Position = UDim2.new(0, 0, 0, HEADER_H + 3)
tabBar.BackgroundColor3 = Color3.fromRGB(10, 8, 12)
tabBar.BorderSizePixel = 0
tabBar.ZIndex = 10

local tabDivider = Instance.new("Frame", tabBar)
tabDivider.Size = UDim2.new(1, 0, 0, 1)
tabDivider.Position = UDim2.new(0, 0, 1, -1)
tabDivider.BackgroundColor3 = C_BORDER
tabDivider.BackgroundTransparency = 0.5
tabDivider.BorderSizePixel = 0
tabDivider.ZIndex = 11

local TABS = {"Speed", "Steal", "Bat", "Jump", "Visual", "Config"}
local tabBtns = {}
local tabScrolls = {}
local activeTab = 1
local tabW = math.floor(W / #TABS)

-- Create scroll frames for each tab
for i = 1, #TABS do
    local sc = Instance.new("ScrollingFrame", main)
    sc.Name = "TabScroll_"..TABS[i]
    sc.Size = UDim2.new(1, 0, 0, CONTENT_H)
    sc.Position = UDim2.new(0, 0, 0, HEADER_H + 3 + TABBAR_H)
    sc.BackgroundTransparency = 1
    sc.BorderSizePixel = 0
    sc.ScrollBarThickness = 5
    sc.ScrollBarImageColor3 = T().accent
    sc.ScrollBarImageTransparency = 0.35
    sc.AutomaticCanvasSize = Enum.AutomaticSize.Y
    sc.CanvasSize = UDim2.new(0, 0, 0, 0)
    sc.ZIndex = 4
    sc.Visible = (i == 1)
    regTheme(sc, "ScrollBarImageColor3", "accent")

    local layout = Instance.new("UIListLayout", sc)
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 3)

    local pad = Instance.new("UIPadding", sc)
    pad.PaddingLeft = UDim.new(0, 10)
    pad.PaddingRight = UDim.new(0, 10)
    pad.PaddingTop = UDim.new(0, 10)
    pad.PaddingBottom = UDim.new(0, 14)

    tabScrolls[i] = sc
end

-- Tab buttons
for i, name in ipairs(TABS) do
    local btn = Instance.new("TextButton", tabBar)
    btn.Size = UDim2.new(0, tabW, 1, 0)
    btn.Position = UDim2.new(0, (i-1)*tabW, 0, 0)
    btn.BackgroundTransparency = 1
    btn.BorderSizePixel = 0
    btn.Text = name
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 10
    btn.TextColor3 = (i==1) and Color3.fromRGB(235,235,245) or Color3.fromRGB(110,110,130)
    btn.AutoButtonColor = false
    btn.ZIndex = 12

    -- Active underline
    local underline = Instance.new("Frame", btn)
    underline.Size = UDim2.new(0.7, 0, 0, 2)
    underline.Position = UDim2.new(0.15, 0, 1, -2)
    underline.BackgroundColor3 = T().accent
    underline.BorderSizePixel = 0
    underline.ZIndex = 13
    underline.Visible = (i==1)
    regTheme(underline, "BackgroundColor3", "accent")
    tabBtns[i] = {btn=btn, line=underline}

    local idx = i
    btn.MouseButton1Click:Connect(function()
        if activeTab == idx then return end
        -- hide old
        tabScrolls[activeTab].Visible = false
        tabBtns[activeTab].btn.TextColor3 = Color3.fromRGB(110,110,130)
        tabBtns[activeTab].line.Visible = false
        -- show new
        activeTab = idx
        tabScrolls[activeTab].Visible = true
        tabBtns[activeTab].btn.TextColor3 = Color3.fromRGB(235,235,245)
        tabBtns[activeTab].line.Visible = true
    end)
end

-- ── FOOTER ─────────────────────────────────────────────────────────────────
local footer = Instance.new("Frame", main)
footer.Size = UDim2.new(1, 0, 0, FOOTER_H)
footer.Position = UDim2.new(0, 0, 1, -FOOTER_H)
footer.BackgroundColor3 = Color3.fromRGB(10, 8, 12)
footer.BorderSizePixel = 0
footer.ZIndex = 10

local footerDiv = Instance.new("Frame", footer)
footerDiv.Size = UDim2.new(1, 0, 0, 1)
footerDiv.Position = UDim2.new(0, 0, 0, 0)
footerDiv.BackgroundColor3 = C_BORDER
footerDiv.BackgroundTransparency = 0.5
footerDiv.BorderSizePixel = 0
footerDiv.ZIndex = 11

local footerLeft = Instance.new("TextLabel", footer)
footerLeft.Size = UDim2.new(0.6, 0, 1, 0)
footerLeft.Position = UDim2.new(0, 12, 0, 0)
footerLeft.BackgroundTransparency = 1
footerLeft.Text = "v2.5 \226\128\162 WAVELI HUB"
footerLeft.TextColor3 = Color3.fromRGB(100, 90, 110)
footerLeft.Font = Enum.Font.GothamBold
footerLeft.TextSize = 9
footerLeft.TextXAlignment = Enum.TextXAlignment.Left
footerLeft.ZIndex = 11

local footerRight = Instance.new("TextLabel", footer)
footerRight.Size = UDim2.new(0.4, -12, 1, 0)
footerRight.Position = UDim2.new(0.6, 0, 0, 0)
footerRight.BackgroundTransparency = 1
footerRight.Text = "\226\151\143 connected"
footerRight.TextColor3 = Color3.fromRGB(80, 200, 110)
footerRight.Font = Enum.Font.GothamBold
footerRight.TextSize = 9
footerRight.TextXAlignment = Enum.TextXAlignment.Right
footerRight.ZIndex = 11

-- ============================================================================
-- UI FACTORIES (each takes parent scroll `sc` as first parameter)
-- ============================================================================
local ROW_H   = IS_MOBILE and 46 or 44  -- 2-line rows
local ROW_H1  = IS_MOBILE and 36 or 32  -- 1-line compact rows

local loCounters = {}
local function LO(sc)
    loCounters[sc] = (loCounters[sc] or 0) + 1
    return loCounters[sc]
end

local function makeGap(sc, px)
    local f = Instance.new("Frame", sc)
    f.Size = UDim2.new(1, 0, 0, px or 4)
    f.BackgroundTransparency = 1; f.BorderSizePixel = 0; f.LayoutOrder = LO(sc)
end

local function makeSectionLabel(sc, text)
    local row = Instance.new("Frame", sc)
    row.Size = UDim2.new(1, 0, 0, 22)
    row.BackgroundTransparency = 1
    row.LayoutOrder = LO(sc)

    local bar = Instance.new("Frame", row)
    bar.Size = UDim2.new(0, 3, 0, 13)
    bar.Position = UDim2.new(0, 0, 0.5, -6)
    bar.BackgroundColor3 = T().accent
    bar.BorderSizePixel = 0
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    regTheme(bar, "BackgroundColor3", "accent")

    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(1, -10, 1, 0)
    lbl.Position = UDim2.new(0, 10, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text:upper()
    lbl.TextColor3 = T().accent
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 10
    lbl.TextXAlignment = Enum.TextXAlignment.Left
    regTheme(lbl, "TextColor3", "accent")
end

local function styleRowBase(row)
    row.BackgroundColor3 = C_ROW; row.BorderSizePixel = 0
    Instance.new("UICorner", row).CornerRadius = UDim.new(0, 10)
    local stroke = Instance.new("UIStroke", row)
    stroke.Color = C_BORDER; stroke.Thickness = 1; stroke.Transparency = 0.6
    return stroke
end

-- 2-line row labels helper (title + subtitle)
local function makeRowLabels(row, title, subtitle)
    local lbl = Instance.new("TextLabel", row)
    lbl.Size = UDim2.new(0, 160, 0, 18)
    lbl.Position = UDim2.new(0, 12, 0, 7)
    lbl.BackgroundTransparency = 1
    lbl.Text = title; lbl.TextColor3 = C_TEXT
    lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 12
    lbl.TextXAlignment = Enum.TextXAlignment.Left

    local sub = Instance.new("TextLabel", row)
    sub.Size = UDim2.new(0, 160, 0, 13)
    sub.Position = UDim2.new(0, 12, 0, 26)
    sub.BackgroundTransparency = 1
    sub.Text = subtitle or ""; sub.TextColor3 = Color3.fromRGB(100, 95, 115)
    sub.Font = Enum.Font.Gotham; sub.TextSize = 9
    sub.TextXAlignment = Enum.TextXAlignment.Left
end

local function makeInputRow(sc, label, subtitle, default, onChange)
    local row = Instance.new("Frame", sc)
    row.Size = UDim2.new(1, 0, 0, ROW_H); row.LayoutOrder = LO(sc)
    local stroke = styleRowBase(row)
    makeRowLabels(row, label, subtitle)
    local boxW, boxH = 60, 22
    local box = Instance.new("TextBox", row)
    box.Size = UDim2.new(0, boxW, 0, boxH)
    box.Position = UDim2.new(1, -boxW-8, 0.5, -boxH/2)
    box.BackgroundColor3 = C_KEY_BG; box.BorderSizePixel = 0
    box.Text = tostring(default); box.TextColor3 = T().accent
    box.Font = Enum.Font.GothamBold; box.TextSize = 12
    box.ClearTextOnFocus = false
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
    local bs = Instance.new("UIStroke", box); bs.Color = C_BORDER; bs.Thickness = 1
    regTheme(box, "TextColor3", "accent")
    box.Focused:Connect(function() TweenService:Create(bs,TweenInfo.new(0.15),{Color=T().accent}):Play() end)
    box.FocusLost:Connect(function()
        TweenService:Create(bs,TweenInfo.new(0.15),{Color=C_BORDER}):Play()
        if onChange then
            local n = tonumber(box.Text)
            if n then onChange(box.Text); if scheduleAutoSave then scheduleAutoSave() end
            else box.Text = tostring(default) end
        end
    end)
    row.MouseEnter:Connect(function() TweenService:Create(row,TweenInfo.new(0.12),{BackgroundColor3=C_ROW_HOV}):Play() end)
    row.MouseLeave:Connect(function() TweenService:Create(row,TweenInfo.new(0.12),{BackgroundColor3=C_ROW}):Play() end)
    return box
end

local function makeStatusRow(sc, label, subtitle, valTxt)
    local row = Instance.new("Frame", sc)
    row.Size = UDim2.new(1, 0, 0, ROW_H); row.LayoutOrder = LO(sc)
    styleRowBase(row)
    makeRowLabels(row, label, subtitle)
    local val = Instance.new("TextLabel", row)
    val.Size = UDim2.new(0, 80, 1, 0); val.Position = UDim2.new(1,-88,0,0)
    val.BackgroundTransparency = 1; val.Text = valTxt; val.TextColor3 = T().accent
    val.Font = Enum.Font.GothamBlack; val.TextSize = 11
    val.TextXAlignment = Enum.TextXAlignment.Right
    regTheme(val, "TextColor3", "accent")
    return val
end

local function makeKeybindRow(sc, label, subtitle, currentKey, onChanged)
    local row = Instance.new("Frame", sc)
    row.Size = UDim2.new(1, 0, 0, ROW_H); row.LayoutOrder = LO(sc)
    local stroke = styleRowBase(row)
    makeRowLabels(row, label, subtitle)
    local btnW, btnH = 50, 22
    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(0, btnW, 0, btnH)
    btn.Position = UDim2.new(1, -btnW-8, 0.5, -btnH/2)
    btn.BackgroundColor3 = C_KEY_BG; btn.BorderSizePixel = 0
    btn.Text = currentKey.Name; btn.TextColor3 = T().accent
    btn.Font = Enum.Font.GothamBold; btn.TextSize = 10
    btn.AutoButtonColor = false
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local bs = Instance.new("UIStroke", btn); bs.Color = C_BORDER; bs.Thickness = 1
    regTheme(btn, "TextColor3", "accent")
    row.MouseEnter:Connect(function() TweenService:Create(row,TweenInfo.new(0.12),{BackgroundColor3=C_ROW_HOV}):Play() end)
    row.MouseLeave:Connect(function() TweenService:Create(row,TweenInfo.new(0.12),{BackgroundColor3=C_ROW}):Play() end)
    local listening = false; local listenConn
    local function stopListen(key)
        listening = false
        if listenConn then listenConn:Disconnect(); listenConn = nil end
        TweenService:Create(bs,TweenInfo.new(0.12),{Color=C_BORDER}):Play()
        if key then btn.Text = key.Name; if onChanged then onChanged(key) end
            if scheduleAutoSave then scheduleAutoSave() end end
    end
    btn.MouseButton1Click:Connect(function()
        if listening then stopListen(nil); return end
        listening = true; btn.Text = "..."
        TweenService:Create(bs,TweenInfo.new(0.12),{Color=T().accent}):Play()
        listenConn = UIS.InputBegan:Connect(function(inp)
            if not listening then return end
            if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
            if inp.KeyCode == Enum.KeyCode.Escape then stopListen(nil); return end
            stopListen(inp.KeyCode)
        end)
    end)
    return btn
end

local function makeToggleRow(sc, label, subtitle, defaultKey, defaultOn, onToggle, onKeyChanged)
    local row = Instance.new("Frame", sc)
    row.Size = UDim2.new(1, 0, 0, ROW_H); row.LayoutOrder = LO(sc)
    local stroke = styleRowBase(row)
    makeRowLabels(row, label, subtitle)
    local pillW, pillH, dotSize = 36, 20, 14
    local keyBtn = nil
    if defaultKey then
        local kw, kh = 44, 20
        keyBtn = Instance.new("TextButton", row)
        keyBtn.Size = UDim2.new(0, kw, 0, kh)
        keyBtn.Position = UDim2.new(1, -kw-pillW-18, 0.5, -kh/2)
        keyBtn.BackgroundColor3 = C_KEY_BG; keyBtn.BorderSizePixel = 0
        keyBtn.Text = defaultKey.Name; keyBtn.TextColor3 = T().accent
        keyBtn.Font = Enum.Font.GothamBold; keyBtn.TextSize = 9
        keyBtn.AutoButtonColor = false; keyBtn.ZIndex = 6
        Instance.new("UICorner", keyBtn).CornerRadius = UDim.new(0, 8)
        local ks = Instance.new("UIStroke", keyBtn); ks.Color = C_BORDER; ks.Thickness = 1
        regTheme(keyBtn, "TextColor3", "accent")
        local kListening = false; local kConn
        local function kStop(key)
            kListening = false
            if kConn then kConn:Disconnect(); kConn = nil end
            TweenService:Create(ks,TweenInfo.new(0.12),{Color=C_BORDER}):Play()
            if key then keyBtn.Text = key.Name; if onKeyChanged then onKeyChanged(key) end
                if scheduleAutoSave then scheduleAutoSave() end end
        end
        keyBtn.MouseButton1Click:Connect(function()
            if kListening then kStop(nil); return end
            kListening = true; keyBtn.Text = "..."
            TweenService:Create(ks,TweenInfo.new(0.12),{Color=T().accent}):Play()
            kConn = UIS.InputBegan:Connect(function(inp)
                if not kListening then return end
                if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
                if inp.KeyCode == Enum.KeyCode.Escape then kStop(nil); return end
                kStop(inp.KeyCode)
            end)
        end)
    end
    local pillBg = Instance.new("Frame", row)
    pillBg.Size = UDim2.new(0, pillW, 0, pillH)
    pillBg.Position = UDim2.new(1, -pillW-10, 0.5, -pillH/2)
    pillBg.BackgroundColor3 = defaultOn and T().accent or C_OFF_BG
    pillBg.BorderSizePixel = 0; pillBg.ZIndex = 5
    Instance.new("UICorner", pillBg).CornerRadius = UDim.new(1, 0)
    local pStroke = Instance.new("UIStroke", pillBg)
    pStroke.Color = defaultOn and T().accent or C_BORDER; pStroke.Thickness = 1
    local dot = Instance.new("Frame", pillBg)
    dot.Size = UDim2.new(0, dotSize, 0, dotSize)
    dot.Position = defaultOn and UDim2.new(1,-dotSize-3,0.5,-dotSize/2) or UDim2.new(0,3,0.5,-dotSize/2)
    dot.BackgroundColor3 = defaultOn and C_BG or C_TEXT_MUTE
    dot.BorderSizePixel = 0; dot.ZIndex = 6
    Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)
    local isOn = defaultOn or false
    local function setV(on)
        isOn = on
        local theme = T()
        TweenService:Create(pillBg,TweenInfo.new(0.22),{BackgroundColor3=on and theme.accent or C_OFF_BG}):Play()
        TweenService:Create(pStroke,TweenInfo.new(0.22),{Color=on and theme.accent or C_BORDER}):Play()
        TweenService:Create(dot,TweenInfo.new(0.25,Enum.EasingStyle.Back,Enum.EasingDirection.Out),{
            Position=on and UDim2.new(1,-dotSize-3,0.5,-dotSize/2) or UDim2.new(0,3,0.5,-dotSize/2),
            BackgroundColor3=on and C_BG or C_TEXT_MUTE,
        }):Play()
        TweenService:Create(stroke,TweenInfo.new(0.22),{Color=on and theme.accent or C_BORDER, Transparency=on and 0.3 or 0.6}):Play()
    end
    table.insert(ThemedElements,{el=pillBg, kind="accent", custom=function(e) if isOn then e.BackgroundColor3=T().accent end end})
    table.insert(ThemedElements,{el=pStroke, kind="accent", custom=function(e) if isOn then e.Color=T().accent end end})
    local clk = Instance.new("TextButton", row)
    clk.Size = UDim2.new(1,0,1,0); clk.BackgroundTransparency = 1; clk.Text = ""
    clk.AutoButtonColor = false; clk.ZIndex = 4
    clk.MouseButton1Click:Connect(function()
        isOn = not isOn; setV(isOn); if onToggle then pcall(onToggle, isOn) end
        if scheduleAutoSave then scheduleAutoSave() end
    end)
    if keyBtn then keyBtn.ZIndex = 7 end
    clk.MouseEnter:Connect(function() TweenService:Create(row,TweenInfo.new(0.12),{BackgroundColor3=C_ROW_HOV}):Play() end)
    clk.MouseLeave:Connect(function() TweenService:Create(row,TweenInfo.new(0.12),{BackgroundColor3=C_ROW}):Play() end)
    return setV, keyBtn
end

local function makeSelectorRow(sc, label, subtitle, options, defaultIdx, onChanged)
    local row = Instance.new("Frame", sc)
    row.Size = UDim2.new(1, 0, 0, ROW_H); row.LayoutOrder = LO(sc)
    styleRowBase(row)
    makeRowLabels(row, label, subtitle)
    local btnW = IS_MOBILE and 58 or 62
    local totalW = #options * btnW + (#options-1)*4
    local selected = defaultIdx or 1
    local btns2 = {}
    local function updateVisual()
        local theme = T()
        for i2, b in ipairs(btns2) do
            if i2 == selected then
                b.BackgroundColor3 = theme.accent; b.TextColor3 = C_BG
            else
                b.BackgroundColor3 = Color3.fromRGB(28,28,34); b.TextColor3 = C_TEXT_DIM
            end
        end
    end
    for i2, opt in ipairs(options) do
        local b = Instance.new("TextButton", row)
        b.Size = UDim2.new(0, btnW, 0, IS_MOBILE and 24 or 22)
        b.Position = UDim2.new(1,-(totalW+8)+(i2-1)*(btnW+4),0.5,IS_MOBILE and -12 or -11)
        b.BackgroundColor3 = C_ROW_HOV; b.BorderSizePixel = 0
        b.Text = opt; b.TextColor3 = C_TEXT_DIM
        b.Font = Enum.Font.GothamBold; b.TextSize = 9; b.ZIndex = 6
        b.AutoButtonColor = false
        Instance.new("UICorner",b).CornerRadius = UDim.new(0,8)
        btns2[i2] = b
        b.MouseButton1Click:Connect(function()
            selected = i2; updateVisual()
            if onChanged then onChanged(i2, opt) end
            if scheduleAutoSave then scheduleAutoSave() end
        end)
    end
    table.insert(ThemedElements,{el=row,kind="accent",custom=function() updateVisual() end})
    updateVisual()
    return function(idx) selected=idx; updateVisual() end
end

local function makeOpenPanelRow(sc, label, subtitle, openFn, closeFn)
    local row = Instance.new("Frame", sc)
    row.Size = UDim2.new(1, 0, 0, ROW_H); row.LayoutOrder = LO(sc)
    local stroke = styleRowBase(row)
    makeRowLabels(row, label, subtitle)
    local OW, OH = 72, 22
    local openBtn = Instance.new("TextButton", row)
    openBtn.Size = UDim2.new(0, OW, 0, OH)
    openBtn.Position = UDim2.new(1,-(OW+8),0.5,-OH/2)
    openBtn.BackgroundColor3 = Color3.fromRGB(22,18,28); openBtn.BorderSizePixel = 0
    openBtn.Text = "OPEN \226\155\186"; openBtn.TextColor3 = T().accent
    openBtn.Font = Enum.Font.GothamBold; openBtn.TextSize = 9; openBtn.ZIndex = 7
    openBtn.AutoButtonColor = false
    Instance.new("UICorner", openBtn).CornerRadius = UDim.new(0, 8)
    local obSt = Instance.new("UIStroke", openBtn)
    obSt.Color = T().accent; obSt.Thickness = 1; obSt.Transparency = 0.4
    regTheme(openBtn, "TextColor3", "accent")
    regTheme(obSt, "Color", "accent")
    openBtn.MouseEnter:Connect(function()
        TweenService:Create(openBtn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(36,28,46)}):Play()
        TweenService:Create(obSt,TweenInfo.new(0.12),{Transparency=0}):Play()
    end)
    openBtn.MouseLeave:Connect(function()
        TweenService:Create(openBtn,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(22,18,28)}):Play()
        TweenService:Create(obSt,TweenInfo.new(0.12),{Transparency=0.4}):Play()
    end)
    row.MouseEnter:Connect(function() TweenService:Create(row,TweenInfo.new(0.12),{BackgroundColor3=C_ROW_HOV}):Play() end)
    row.MouseLeave:Connect(function() TweenService:Create(row,TweenInfo.new(0.12),{BackgroundColor3=C_ROW}):Play() end)
    local panelOpen = false
    openBtn.MouseButton1Click:Connect(function()
        if panelOpen then
            if closeFn then closeFn() end
            task.delay(0.22,function() openBtn.Text="OPEN \226\155\186" end)
            panelOpen = false
        else
            if openFn then openFn() end
            openBtn.Text = "CLOSE \195\151"; panelOpen = true
        end
    end)
    return openBtn
end

-- Override applyTheme
applyTheme = function()
    local t = T()
    for _, e in ipairs(ThemedElements) do
        if e.custom then
            pcall(function() e.custom(e.el) end)
        elseif e.el and e.el.Parent and e.prop then
            local col = t[e.kind] or t.accent
            pcall(function() e.el[e.prop] = col end)
        end
    end
end

table.insert(ThemedElements,{el=nil,custom=function()
    local t = T()
    if _dcLbl and _dcLbl.Parent then pcall(function() _dcLbl.TextColor3 = t.accent end) end
    if speedLbl and speedLbl.Parent then pcall(function() speedLbl.TextColor3 = t.accent end) end
end})

-- ============================================================================
-- FLOATING PANELS (unchanged logic — parented to gui)
-- ============================================================================
local _vbPanel, _vbShadow, _vbHidePanel, _vbPowerDisp, _vbKeyBtn
local _vlPanel, _vlShadow, _vlHidePanel
local _batPanel, _batShadow, _batHidePanel

-- WAVELI BYPASS FLOATING PANEL
do
    local PW = IS_MOBILE and 262 or 272
    local PH = IS_MOBILE and 346 or 356

    local function _fmtPow(val)
        local s=tostring(math.floor(val)); local r,c="",0
        for i=#s,1,-1 do if c>0 and c%3==0 then r=","..r end; r=s:sub(i,i)..r; c=c+1 end
        return r
    end

    local function _buildBomb(depth)
        local main2,spam={},{{}}; local z=spam[1]
        for _=1,depth do local t={}; table.insert(z,t); z=t end
        local mx=math.floor(Bypass.Power/(depth+2))
        for _=1,mx do table.insert(main2,spam) end
        return main2
    end

    _vbShadow = Instance.new("Frame", gui)
    _vbShadow.Size = UDim2.new(0, PW+8, 0, PH+8)
    _vbShadow.Position = UDim2.new(0.5, -(PW/2+4), 0.5, -(PH/2+4))
    _vbShadow.BackgroundColor3 = Color3.fromRGB(0,0,0)
    _vbShadow.BackgroundTransparency = 0.5
    _vbShadow.BorderSizePixel = 0; _vbShadow.ZIndex = 38; _vbShadow.Visible = false
    Instance.new("UICorner", _vbShadow).CornerRadius = UDim.new(0, 12)

    _vbPanel = Instance.new("Frame", gui)
    _vbPanel.Name = "WaveliBypassPanel"
    _vbPanel.Size = UDim2.new(0, PW, 0, PH)
    _vbPanel.Position = UDim2.new(0.5, -PW/2, 0.5, -PH/2)
    _vbPanel.BackgroundColor3 = Color3.fromRGB(10, 10, 12)
    _vbPanel.BorderSizePixel = 0; _vbPanel.Active = true
    _vbPanel.ClipsDescendants = true; _vbPanel.Visible = false; _vbPanel.ZIndex = 39
    Instance.new("UICorner", _vbPanel).CornerRadius = UDim.new(0, 12)
    local vbSt = Instance.new("UIStroke", _vbPanel)
    vbSt.Color = T().accent; vbSt.Thickness = 1; vbSt.Transparency = 0.4
    regTheme(vbSt, "Color", "accent")

    do
        local dragging, ds, sp = false, nil, nil
        _vbPanel.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                dragging=true; ds=i.Position; sp=_vbPanel.Position
                i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end)
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                local d=i.Position-ds
                local np=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
                _vbPanel.Position=np; _vbShadow.Position=UDim2.new(np.X.Scale,np.X.Offset-4,np.Y.Scale,np.Y.Offset-4)
            end
        end)
    end

    local vbHdr=Instance.new("Frame",_vbPanel); vbHdr.Size=UDim2.new(1,0,0,36); vbHdr.BackgroundTransparency=1; vbHdr.ZIndex=41
    local vbTitle=Instance.new("TextLabel",vbHdr); vbTitle.Size=UDim2.new(1,-8,1,0); vbTitle.Position=UDim2.new(0,12,0,0)
    vbTitle.BackgroundTransparency=1; vbTitle.Text="WAVELI \xC2\xB7 BYPASS"; vbTitle.TextColor3=T().accent
    vbTitle.Font=Enum.Font.GothamBlack; vbTitle.TextSize=IS_MOBILE and 13 or 12; vbTitle.TextXAlignment=Enum.TextXAlignment.Left; vbTitle.ZIndex=42
    regTheme(vbTitle,"TextColor3","accent")
    local vbSep=Instance.new("Frame",_vbPanel); vbSep.Size=UDim2.new(1,-16,0,1); vbSep.Position=UDim2.new(0,8,0,36)
    vbSep.BackgroundColor3=T().accent; vbSep.BackgroundTransparency=0.7; vbSep.BorderSizePixel=0; vbSep.ZIndex=41
    regTheme(vbSep,"BackgroundColor3","accent")

    local pRow=Instance.new("Frame",_vbPanel); pRow.Size=UDim2.new(1,-16,0,40); pRow.Position=UDim2.new(0,8,0,46)
    pRow.BackgroundColor3=Color3.fromRGB(22,22,28); pRow.BorderSizePixel=0; pRow.ZIndex=41
    Instance.new("UICorner",pRow).CornerRadius=UDim.new(0,10); Instance.new("UIStroke",pRow).Color=C_BORDER
    local pLbl=Instance.new("TextLabel",pRow); pLbl.Size=UDim2.new(0.5,0,1,0); pLbl.Position=UDim2.new(0,12,0,0)
    pLbl.BackgroundTransparency=1; pLbl.Text="Power"; pLbl.Font=Enum.Font.GothamMedium; pLbl.TextSize=IS_MOBILE and 12 or 11
    pLbl.TextColor3=Color3.fromRGB(180,180,180); pLbl.TextXAlignment=Enum.TextXAlignment.Left; pLbl.ZIndex=42
    _vbPowerDisp=Instance.new("TextLabel",pRow); _vbPowerDisp.Size=UDim2.new(0.46,0,1,0); _vbPowerDisp.Position=UDim2.new(0.5,0,0,0)
    _vbPowerDisp.BackgroundTransparency=1; _vbPowerDisp.Text=_fmtPow(Bypass.Power)
    _vbPowerDisp.Font=Enum.Font.GothamBold; _vbPowerDisp.TextSize=IS_MOBILE and 13 or 12
    _vbPowerDisp.TextColor3=T().accent; _vbPowerDisp.TextXAlignment=Enum.TextXAlignment.Right; _vbPowerDisp.ZIndex=42
    regTheme(_vbPowerDisp,"TextColor3","accent")

    local qRow=Instance.new("Frame",_vbPanel); qRow.Size=UDim2.new(1,-16,0,54); qRow.Position=UDim2.new(0,8,0,94)
    qRow.BackgroundColor3=Color3.fromRGB(22,22,28); qRow.BorderSizePixel=0; qRow.ZIndex=41
    Instance.new("UICorner",qRow).CornerRadius=UDim.new(0,10); Instance.new("UIStroke",qRow).Color=C_BORDER
    local qSect=Instance.new("TextLabel",qRow); qSect.Size=UDim2.new(1,0,0,14); qSect.Position=UDim2.new(0,12,0,4)
    qSect.BackgroundTransparency=1; qSect.Text="Quick Power"; qSect.Font=Enum.Font.GothamMedium; qSect.TextSize=9
    qSect.TextColor3=Color3.fromRGB(120,120,140); qSect.TextXAlignment=Enum.TextXAlignment.Left; qSect.ZIndex=42
    local quickPows={{l="10K",v=10000},{l="25K",v=25000},{l="50K",v=50000},{l="97K",v=97000}}
    local qBtnW=math.floor((PW-16-8-3*4)/4)
    for i2,entry in ipairs(quickPows) do
        local qb=Instance.new("TextButton",qRow)
        qb.Size=UDim2.new(0,qBtnW,0,24); qb.Position=UDim2.new(0,8+(i2-1)*(qBtnW+4),0,22)
        qb.BackgroundColor3=Color3.fromRGB(28,28,36); qb.BorderSizePixel=0
        qb.Text=entry.l; qb.TextColor3=Color3.fromRGB(210,210,220)
        qb.Font=Enum.Font.GothamBold; qb.TextSize=IS_MOBILE and 11 or 10; qb.ZIndex=43
        qb.AutoButtonColor=false; Instance.new("UICorner",qb).CornerRadius=UDim.new(0,7)
        local qbSt=Instance.new("UIStroke",qb); qbSt.Color=C_BORDER; qbSt.Thickness=1; qbSt.Transparency=0.5
        local cap=entry.v
        qb.MouseButton1Click:Connect(function()
            Bypass.Power=cap; if _vbPowerDisp then _vbPowerDisp.Text=_fmtPow(cap) end
            TweenService:Create(qb,TweenInfo.new(0.1),{BackgroundColor3=T().accent}):Play()
            task.delay(0.3,function() TweenService:Create(qb,TweenInfo.new(0.15),{BackgroundColor3=Color3.fromRGB(28,28,36)}):Play() end)
            if scheduleAutoSave then scheduleAutoSave() end
        end)
        qb.MouseEnter:Connect(function() TweenService:Create(qb,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(36,36,46)}):Play() end)
        qb.MouseLeave:Connect(function() TweenService:Create(qb,TweenInfo.new(0.12),{BackgroundColor3=Color3.fromRGB(28,28,36)}):Play() end)
    end

    local cRow=Instance.new("Frame",_vbPanel); cRow.Size=UDim2.new(1,-16,0,48); cRow.Position=UDim2.new(0,8,0,156)
    cRow.BackgroundColor3=Color3.fromRGB(22,22,28); cRow.BorderSizePixel=0; cRow.ZIndex=41
    Instance.new("UICorner",cRow).CornerRadius=UDim.new(0,10); Instance.new("UIStroke",cRow).Color=C_BORDER
    local cSect=Instance.new("TextLabel",cRow); cSect.Size=UDim2.new(1,0,0,14); cSect.Position=UDim2.new(0,12,0,4)
    cSect.BackgroundTransparency=1; cSect.Text="Custom Power"; cSect.Font=Enum.Font.GothamMedium; cSect.TextSize=9
    cSect.TextColor3=Color3.fromRGB(120,120,140); cSect.TextXAlignment=Enum.TextXAlignment.Left; cSect.ZIndex=42
    local cBox=Instance.new("TextBox",cRow); cBox.Size=UDim2.new(1,-80,0,24); cBox.Position=UDim2.new(0,8,0,20)
    cBox.BackgroundColor3=Color3.fromRGB(16,16,22); cBox.BorderSizePixel=0
    cBox.Text=""; cBox.PlaceholderText="np. 50000"; cBox.Font=Enum.Font.GothamMedium; cBox.TextSize=IS_MOBILE and 12 or 11
    cBox.TextColor3=Color3.fromRGB(220,220,228); cBox.PlaceholderColor3=Color3.fromRGB(90,90,110)
    cBox.ClearTextOnFocus=false; cBox.ZIndex=43
    Instance.new("UICorner",cBox).CornerRadius=UDim.new(0,7)
    local cBoxSt=Instance.new("UIStroke",cBox); cBoxSt.Color=C_BORDER; cBoxSt.Thickness=1; cBoxSt.Transparency=0.5
    local cSetBtn=Instance.new("TextButton",cRow); cSetBtn.Size=UDim2.new(0,58,0,24); cSetBtn.Position=UDim2.new(1,-66,0,20)
    cSetBtn.BackgroundColor3=T().accent; cSetBtn.BorderSizePixel=0; cSetBtn.Text="SET"
    cSetBtn.Font=Enum.Font.GothamBold; cSetBtn.TextSize=IS_MOBILE and 12 or 11; cSetBtn.TextColor3=Color3.fromRGB(255,255,255)
    cSetBtn.AutoButtonColor=false; cSetBtn.ZIndex=43; Instance.new("UICorner",cSetBtn).CornerRadius=UDim.new(0,7)
    regTheme(cSetBtn,"BackgroundColor3","accent")
    cSetBtn.MouseButton1Click:Connect(function()
        local raw=cBox.Text:gsub(",",""):gsub("%s",""); local num=tonumber(raw)
        if num and num>0 then
            num=math.floor(num); Bypass.Power=num
            if _vbPowerDisp then _vbPowerDisp.Text=_fmtPow(num) end; cBox.Text=""
            TweenService:Create(cSetBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(60,220,110)}):Play()
            task.delay(0.35,function() TweenService:Create(cSetBtn,TweenInfo.new(0.2),{BackgroundColor3=T().accent}):Play() end)
            if scheduleAutoSave then scheduleAutoSave() end
        else
            TweenService:Create(cSetBtn,TweenInfo.new(0.08),{BackgroundColor3=Color3.fromRGB(200,60,60)}):Play()
            task.delay(0.35,function() TweenService:Create(cSetBtn,TweenInfo.new(0.2),{BackgroundColor3=T().accent}):Play() end)
        end
    end)

    local sRow=Instance.new("Frame",_vbPanel); sRow.Size=UDim2.new(1,-16,0,40); sRow.Position=UDim2.new(0,8,0,212)
    sRow.BackgroundColor3=Color3.fromRGB(22,22,28); sRow.BorderSizePixel=0; sRow.ZIndex=41
    Instance.new("UICorner",sRow).CornerRadius=UDim.new(0,10); Instance.new("UIStroke",sRow).Color=C_BORDER
    local sBtn=Instance.new("TextButton",sRow); sBtn.Size=UDim2.new(1,-16,1,-12); sBtn.Position=UDim2.new(0,8,0,6)
    sBtn.BackgroundTransparency=1; sBtn.BorderSizePixel=0; sBtn.Text="\226\172\164  DEACTIVATED"
    sBtn.Font=Enum.Font.GothamBlack; sBtn.TextSize=IS_MOBILE and 13 or 12; sBtn.TextColor3=Color3.fromRGB(120,120,140)
    sBtn.AutoButtonColor=false; sBtn.ZIndex=42

    local kRow=Instance.new("Frame",_vbPanel); kRow.Size=UDim2.new(1,-16,0,48); kRow.Position=UDim2.new(0,8,0,260)
    kRow.BackgroundColor3=Color3.fromRGB(22,22,28); kRow.BorderSizePixel=0; kRow.ZIndex=41
    Instance.new("UICorner",kRow).CornerRadius=UDim.new(0,10); Instance.new("UIStroke",kRow).Color=C_BORDER
    local kLbl=Instance.new("TextLabel",kRow); kLbl.Size=UDim2.new(0.55,0,0.55,0); kLbl.Position=UDim2.new(0,12,0,6)
    kLbl.BackgroundTransparency=1; kLbl.Font=Enum.Font.GothamBold; kLbl.TextSize=IS_MOBILE and 12 or 11
    kLbl.TextColor3=Color3.fromRGB(180,180,180); kLbl.TextXAlignment=Enum.TextXAlignment.Left; kLbl.Text="Toggle Key:"; kLbl.ZIndex=42
    local kHint=Instance.new("TextLabel",kRow); kHint.Size=UDim2.new(0.55,0,0,12); kHint.Position=UDim2.new(0,12,1,-15)
    kHint.BackgroundTransparency=1; kHint.Font=Enum.Font.Gotham; kHint.TextSize=9
    kHint.TextColor3=Color3.fromRGB(100,100,125); kHint.TextXAlignment=Enum.TextXAlignment.Left; kHint.Text="click to change"; kHint.ZIndex=42
    _vbKeyBtn=Instance.new("TextButton",kRow); _vbKeyBtn.Size=UDim2.new(0,52,0,30); _vbKeyBtn.Position=UDim2.new(1,-62,0.5,-15)
    _vbKeyBtn.BackgroundColor3=Color3.fromRGB(28,28,36); _vbKeyBtn.BorderSizePixel=0; _vbKeyBtn.Text=Bypass.Key.Name
    _vbKeyBtn.Font=Enum.Font.GothamBold; _vbKeyBtn.TextSize=IS_MOBILE and 13 or 12; _vbKeyBtn.TextColor3=T().accent; _vbKeyBtn.AutoButtonColor=false; _vbKeyBtn.ZIndex=42
    Instance.new("UICorner",_vbKeyBtn).CornerRadius=UDim.new(0,8)
    local vbkSt=Instance.new("UIStroke",_vbKeyBtn); vbkSt.Thickness=1; vbkSt.Color=T().accent; vbkSt.Transparency=0.5
    regTheme(_vbKeyBtn,"TextColor3","accent"); regTheme(vbkSt,"Color","accent")
    local vbFoot=Instance.new("TextLabel",_vbPanel); vbFoot.Size=UDim2.new(1,0,0,12); vbFoot.Position=UDim2.new(0,0,1,-14)
    vbFoot.BackgroundTransparency=1; vbFoot.Text="waveli hub"; vbFoot.TextColor3=Color3.fromRGB(70,70,82); vbFoot.Font=Enum.Font.Gotham; vbFoot.TextSize=8; vbFoot.TextXAlignment=Enum.TextXAlignment.Center; vbFoot.ZIndex=42

    _vbHidePanel = function()
        TweenService:Create(_vbPanel,TweenInfo.new(0.15,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{
            Position=_vbPanel.Position+UDim2.new(0,0,0,-8), BackgroundTransparency=1
        }):Play()
        task.delay(0.17,function()
            _vbPanel.Visible=false; _vbShadow.Visible=false
            _vbPanel.BackgroundTransparency=0; _vbPanel.Position=_vbPanel.Position+UDim2.new(0,0,0,8)
        end)
    end

    local bypassActive = false; local preBuiltBomb = nil
    local function setBypassState(on)
        bypassActive = on
        if on then sBtn.Text="\226\172\164  ACTIVATED"; sBtn.TextColor3=Color3.fromRGB(80,220,120)
        else sBtn.Text="\226\172\164  DEACTIVATED"; sBtn.TextColor3=Color3.fromRGB(120,120,140) end
    end
    local function bypassToggle()
        if bypassActive then setBypassState(false); preBuiltBomb=nil
        else
            setBypassState(true)
            pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge) end)
            preBuiltBomb=_buildBomb(Bypass.Depth)
            task.spawn(function()
                while bypassActive do
                    if preBuiltBomb then pcall(function() game.RobloxReplicatedStorage.SetPlayerBlockList:FireServer(preBuiltBomb) end) end
                    task.wait(0.125)
                end
            end)
        end
    end
    sBtn.MouseButton1Click:Connect(bypassToggle)
    do
        local bListening=false
        local function startL() bListening=true; _vbKeyBtn.Text="..."; _vbKeyBtn.TextColor3=Color3.fromRGB(255,220,50); vbkSt.Color=Color3.fromRGB(255,220,50); vbkSt.Transparency=0; kHint.Text="press any key..." end
        local function stopL(nk)
            bListening=false
            if nk then Bypass.Key=nk; _vbKeyBtn.Text=nk.Name; if scheduleAutoSave then scheduleAutoSave() end end
            _vbKeyBtn.TextColor3=T().accent; vbkSt.Color=T().accent; vbkSt.Transparency=0.5; kHint.Text="click to change"
        end
        _vbKeyBtn.MouseButton1Click:Connect(function() if bListening then stopL(nil) else startL() end end)
        UIS.InputBegan:Connect(function(i,gp)
            if bListening and i.UserInputType==Enum.UserInputType.Keyboard then
                if i.KeyCode==Enum.KeyCode.Escape then stopL(nil) else stopL(i.KeyCode) end; return
            end
            if not gp and i.UserInputType==Enum.UserInputType.Keyboard and i.KeyCode==Bypass.Key then bypassToggle() end
        end)
    end
end

-- WAVELI LAGGER FLOATING PANEL
do
    local PW = IS_MOBILE and 240 or 250
    local PH = IS_MOBILE and 188 or 198
    local lagOn=false; local _lagThread=nil; local _lagWait=UIS.TouchEnabled and 5.8 or 0.25
    local _lagStatusLbl, _lagPill, _lagDot

    local function _bombLag(amt)
        local main2,spam={},{{}}; local z=spam[1]
        for i=1,amt do local t={}; table.insert(z,t); z=t end
        local max=math.min(499999/(amt+2),1500)
        for i=1,max do table.insert(main2,spam) end
        pcall(function() game:GetService("RobloxReplicatedStorage").SetPlayerBlockList:FireServer(main2) end)
    end

    local function _setLagOn(on)
        lagOn=on
        if on then
            if not _lagThread then
                _lagThread=task.spawn(function()
                    while lagOn do
                        pcall(function() game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge) end)
                        _bombLag(270); task.wait(_lagWait)
                    end; _lagThread=nil
                end)
            end
        else if _lagThread then task.cancel(_lagThread); _lagThread=nil end end
        if _lagStatusLbl then _lagStatusLbl.Text=on and "ACTIVE" or "INACTIVE"; _lagStatusLbl.TextColor3=on and T().accent or Color3.fromRGB(100,100,120) end
        if _lagPill and _lagDot then
            TweenService:Create(_lagPill,TweenInfo.new(0.2),{BackgroundColor3=on and T().accent or Color3.fromRGB(28,28,36)}):Play()
            TweenService:Create(_lagDot,TweenInfo.new(0.22,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,4,0.5,-8),BackgroundColor3=on and Color3.fromRGB(255,255,255) or Color3.fromRGB(60,60,70)}):Play()
        end
    end

    _vlShadow=Instance.new("Frame",gui); _vlShadow.Size=UDim2.new(0,PW+8,0,PH+8); _vlShadow.Position=UDim2.new(0.5,-(PW/2+4),0.5,-(PH/2+4))
    _vlShadow.BackgroundColor3=Color3.fromRGB(0,0,0); _vlShadow.BackgroundTransparency=0.5; _vlShadow.BorderSizePixel=0; _vlShadow.ZIndex=38; _vlShadow.Visible=false
    Instance.new("UICorner",_vlShadow).CornerRadius=UDim.new(0,12)

    _vlPanel=Instance.new("Frame",gui); _vlPanel.Name="WaveliLaggerPanel"; _vlPanel.Size=UDim2.new(0,PW,0,PH); _vlPanel.Position=UDim2.new(0.5,-PW/2,0.5,-PH/2)
    _vlPanel.BackgroundColor3=Color3.fromRGB(10,10,12); _vlPanel.BorderSizePixel=0; _vlPanel.Active=true; _vlPanel.ClipsDescendants=true; _vlPanel.Visible=false; _vlPanel.ZIndex=39
    Instance.new("UICorner",_vlPanel).CornerRadius=UDim.new(0,12)
    local vlSt=Instance.new("UIStroke",_vlPanel); vlSt.Color=T().accent; vlSt.Thickness=1; vlSt.Transparency=0.4; regTheme(vlSt,"Color","accent")

    do
        local dragging,ds,sp=false,nil,nil
        _vlPanel.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                dragging=true; ds=i.Position; sp=_vlPanel.Position
                i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end)
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                local d=i.Position-ds; local np=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
                _vlPanel.Position=np; _vlShadow.Position=UDim2.new(np.X.Scale,np.X.Offset-4,np.Y.Scale,np.Y.Offset-4)
            end
        end)
    end

    local vlHdr=Instance.new("Frame",_vlPanel); vlHdr.Size=UDim2.new(1,0,0,36); vlHdr.BackgroundTransparency=1; vlHdr.ZIndex=41
    local vlTitle=Instance.new("TextLabel",vlHdr); vlTitle.Size=UDim2.new(1,-36,1,0); vlTitle.Position=UDim2.new(0,12,0,0)
    vlTitle.BackgroundTransparency=1; vlTitle.Text="WAVELI \xC2\xB7 LAGGER"; vlTitle.Font=Enum.Font.GothamBlack; vlTitle.TextSize=IS_MOBILE and 13 or 12
    vlTitle.TextXAlignment=Enum.TextXAlignment.Left; vlTitle.ZIndex=42; vlTitle.TextColor3=T().accent; regTheme(vlTitle,"TextColor3","accent")
    local vlSep=Instance.new("Frame",_vlPanel); vlSep.Size=UDim2.new(1,-16,0,1); vlSep.Position=UDim2.new(0,8,0,36)
    vlSep.BackgroundColor3=T().accent; vlSep.BackgroundTransparency=0.7; vlSep.BorderSizePixel=0; vlSep.ZIndex=41; regTheme(vlSep,"BackgroundColor3","accent")

    local tRow=Instance.new("Frame",_vlPanel); tRow.Size=UDim2.new(1,-16,0,52); tRow.Position=UDim2.new(0,8,0,46)
    tRow.BackgroundColor3=Color3.fromRGB(22,22,28); tRow.BorderSizePixel=0; tRow.ZIndex=41
    Instance.new("UICorner",tRow).CornerRadius=UDim.new(0,10); local tSt=Instance.new("UIStroke",tRow); tSt.Color=C_BORDER; tSt.Thickness=1; tSt.Transparency=0.5
    local tLbl=Instance.new("TextLabel",tRow); tLbl.Size=UDim2.new(0.55,0,0,18); tLbl.Position=UDim2.new(0,12,0,8)
    tLbl.BackgroundTransparency=1; tLbl.Text="Lagger"; tLbl.Font=Enum.Font.GothamBold; tLbl.TextSize=IS_MOBILE and 13 or 12
    tLbl.TextColor3=Color3.fromRGB(220,220,228); tLbl.TextXAlignment=Enum.TextXAlignment.Left; tLbl.ZIndex=42
    _lagStatusLbl=Instance.new("TextLabel",tRow); _lagStatusLbl.Size=UDim2.new(0.55,0,0,14); _lagStatusLbl.Position=UDim2.new(0,12,0,28)
    _lagStatusLbl.BackgroundTransparency=1; _lagStatusLbl.Text="INACTIVE"; _lagStatusLbl.Font=Enum.Font.Gotham; _lagStatusLbl.TextSize=9
    _lagStatusLbl.TextColor3=Color3.fromRGB(100,100,120); _lagStatusLbl.TextXAlignment=Enum.TextXAlignment.Left; _lagStatusLbl.ZIndex=42
    _lagPill=Instance.new("TextButton",tRow); _lagPill.Size=UDim2.new(0,44,0,24); _lagPill.Position=UDim2.new(1,-54,0.5,-12)
    _lagPill.BackgroundColor3=Color3.fromRGB(28,28,36); _lagPill.Text=""; _lagPill.AutoButtonColor=false; _lagPill.ZIndex=42
    Instance.new("UICorner",_lagPill).CornerRadius=UDim.new(1,0); Instance.new("UIStroke",_lagPill).Color=C_BORDER
    _lagDot=Instance.new("Frame",_lagPill); _lagDot.Size=UDim2.new(0,16,0,16); _lagDot.Position=UDim2.new(0,4,0.5,-8)
    _lagDot.BackgroundColor3=Color3.fromRGB(60,60,70); _lagDot.BorderSizePixel=0; Instance.new("UICorner",_lagDot).CornerRadius=UDim.new(1,0)
    _lagPill.MouseButton1Click:Connect(function() _setLagOn(not lagOn) end)

    local kRow=Instance.new("Frame",_vlPanel); kRow.Size=UDim2.new(1,-16,0,48); kRow.Position=UDim2.new(0,8,0,106)
    kRow.BackgroundColor3=Color3.fromRGB(22,22,28); kRow.BorderSizePixel=0; kRow.ZIndex=41
    Instance.new("UICorner",kRow).CornerRadius=UDim.new(0,10); local kSt2=Instance.new("UIStroke",kRow); kSt2.Color=C_BORDER; kSt2.Thickness=1; kSt2.Transparency=0.5
    local kLbl=Instance.new("TextLabel",kRow); kLbl.Size=UDim2.new(0.55,0,0.55,0); kLbl.Position=UDim2.new(0,12,0,6)
    kLbl.BackgroundTransparency=1; kLbl.Font=Enum.Font.GothamBold; kLbl.TextSize=IS_MOBILE and 12 or 11
    kLbl.TextColor3=Color3.fromRGB(180,180,180); kLbl.TextXAlignment=Enum.TextXAlignment.Left; kLbl.Text="Keybind:"; kLbl.ZIndex=42
    local hintLbl=Instance.new("TextLabel",kRow); hintLbl.Size=UDim2.new(0.55,0,0,12); hintLbl.Position=UDim2.new(0,12,1,-15)
    hintLbl.BackgroundTransparency=1; hintLbl.Font=Enum.Font.Gotham; hintLbl.TextSize=9
    hintLbl.TextColor3=Color3.fromRGB(100,100,125); hintLbl.TextXAlignment=Enum.TextXAlignment.Left; hintLbl.Text="click to change"; hintLbl.ZIndex=42
    local kBtn=Instance.new("TextButton",kRow); kBtn.Size=UDim2.new(0,52,0,30); kBtn.Position=UDim2.new(1,-62,0.5,-15)
    kBtn.BackgroundColor3=Color3.fromRGB(28,28,36); kBtn.BorderSizePixel=0; kBtn.Text="V"; kBtn.Font=Enum.Font.GothamBold; kBtn.TextSize=IS_MOBILE and 13 or 12
    kBtn.TextColor3=T().accent; kBtn.AutoButtonColor=false; kBtn.ZIndex=42; Instance.new("UICorner",kBtn).CornerRadius=UDim.new(0,8)
    local kStroke=Instance.new("UIStroke",kBtn); kStroke.Thickness=1; kStroke.Color=T().accent; kStroke.Transparency=0.5
    regTheme(kBtn,"TextColor3","accent"); regTheme(kStroke,"Color","accent")

    local vlFoot=Instance.new("TextLabel",_vlPanel); vlFoot.Size=UDim2.new(1,0,0,12); vlFoot.Position=UDim2.new(0,0,1,-14)
    vlFoot.BackgroundTransparency=1; vlFoot.Text="waveli hub"; vlFoot.TextColor3=Color3.fromRGB(70,70,82); vlFoot.Font=Enum.Font.Gotham; vlFoot.TextSize=8; vlFoot.TextXAlignment=Enum.TextXAlignment.Center; vlFoot.ZIndex=42

    _vlHidePanel=function()
        TweenService:Create(_vlPanel,TweenInfo.new(0.15,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position=_vlPanel.Position+UDim2.new(0,0,0,-8),BackgroundTransparency=1}):Play()
        task.delay(0.17,function() _vlPanel.Visible=false; _vlShadow.Visible=false; _vlPanel.BackgroundTransparency=0; _vlPanel.Position=_vlPanel.Position+UDim2.new(0,0,0,8) end)
    end
    do
        local bound=Enum.KeyCode.V; local listening=false
        local function startL() listening=true; kBtn.Text="..."; kBtn.TextColor3=Color3.fromRGB(255,220,50); kStroke.Color=Color3.fromRGB(255,220,50); kStroke.Transparency=0; hintLbl.Text="press any key..." end
        local function stopL(nk) listening=false; if nk then bound=nk; kBtn.Text=nk.Name end; kBtn.TextColor3=T().accent; kStroke.Color=T().accent; kStroke.Transparency=0.5; hintLbl.Text="click to change" end
        kBtn.MouseButton1Click:Connect(function() if listening then stopL(nil) else startL() end end)
        UIS.InputBegan:Connect(function(i,gp)
            if listening and i.UserInputType==Enum.UserInputType.Keyboard then if i.KeyCode==Enum.KeyCode.Escape then stopL(nil) else stopL(i.KeyCode) end; return end
            if not gp and i.KeyCode==bound then _setLagOn(not lagOn) end
        end)
    end
end

-- AUTO BAT DESYNC FLOATING PANEL
do
    local PW = IS_MOBILE and 244 or 254
    local PH = IS_MOBILE and 204 or 214
    local _batEnabled=false; local _batHitCD=false
    local _batPill2, _batDot2, _batStatusLbl2

    local function _batGetTool()
        local char=LP.Character; if not char then return nil end
        local t=char:FindFirstChild("Bat"); if t then return t end
        local bp=LP:FindFirstChild("Backpack"); if bp then t=bp:FindFirstChild("Bat"); if t then t.Parent=char; return t end end
        return nil
    end
    local function _batHit()
        if _batHitCD then return end; _batHitCD=true
        pcall(function() local bat=_batGetTool(); if bat then bat:Activate(); local ev=bat:FindFirstChildWhichIsA("RemoteEvent"); if ev then ev:FireServer() end end end)
        task.delay(0.08,function() _batHitCD=false end)
    end
    local function _batClosest()
        if not hrp then return nil end; local cp,cd=nil,math.huge
        for _,p in pairs(Players:GetPlayers()) do
            if p~=LP and p.Character then local tr=p.Character:FindFirstChild("HumanoidRootPart"); if tr then local d=(hrp.Position-tr.Position).Magnitude; if d<cd then cd=d; cp=p end end end
        end; return cp
    end
    RunService.Heartbeat:Connect(function()
        if not (_batEnabled and h and hrp) then return end
        local target=_batClosest()
        if target and target.Character then
            local tr=target.Character:FindFirstChild("HumanoidRootPart")
            if tr then
                if sethiddenproperty then pcall(function() sethiddenproperty(hrp,"PhysicsRepRootPart",tr) end) end
                local tPos=tr.Position+Vector3.new(0,0.9,0)
                if (hrp.Position-tPos).Magnitude>8 then hrp.CFrame=CFrame.new(tPos) end
                local cam=workspace.CurrentCamera; cam.CFrame=CFrame.new(cam.CFrame.Position,tr.Position)
                _batHit()
            end
        end
    end)

    local function _batSetOn(on)
        _batEnabled=on
        if _batPill2 then TweenService:Create(_batPill2,TweenInfo.new(0.22,Enum.EasingStyle.Quad),{BackgroundColor3=on and T().accent or Color3.fromRGB(28,28,36)}):Play() end
        if _batDot2 then TweenService:Create(_batDot2,TweenInfo.new(0.22,Enum.EasingStyle.Back),{Position=on and UDim2.new(1,-20,0.5,-8) or UDim2.new(0,4,0.5,-8)}):Play() end
        if _batStatusLbl2 then _batStatusLbl2.Text=on and "ACTIVE" or "INACTIVE"; _batStatusLbl2.TextColor3=on and T().accent or Color3.fromRGB(100,100,120) end
    end

    _batShadow=Instance.new("Frame",gui); _batShadow.Size=UDim2.new(0,PW+8,0,PH+8); _batShadow.Position=UDim2.new(0.5,-(PW/2+4),0.5,-(PH/2+4))
    _batShadow.BackgroundColor3=Color3.fromRGB(0,0,0); _batShadow.BackgroundTransparency=0.5; _batShadow.BorderSizePixel=0; _batShadow.ZIndex=38; _batShadow.Visible=false
    Instance.new("UICorner",_batShadow).CornerRadius=UDim.new(0,12)
    _batPanel=Instance.new("Frame",gui); _batPanel.Name="AutoBatDesyncPanel"; _batPanel.Size=UDim2.new(0,PW,0,PH); _batPanel.Position=UDim2.new(0.5,-PW/2,0.5,-PH/2)
    _batPanel.BackgroundColor3=Color3.fromRGB(10,10,12); _batPanel.BorderSizePixel=0; _batPanel.Active=true; _batPanel.ClipsDescendants=true; _batPanel.Visible=false; _batPanel.ZIndex=39
    Instance.new("UICorner",_batPanel).CornerRadius=UDim.new(0,12)
    local batSt=Instance.new("UIStroke",_batPanel); batSt.Color=T().accent; batSt.Thickness=1; batSt.Transparency=0.4; regTheme(batSt,"Color","accent")

    do
        local dragging,ds,sp=false,nil,nil
        _batPanel.InputBegan:Connect(function(i)
            if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
                dragging=true; ds=i.Position; sp=_batPanel.Position
                i.Changed:Connect(function() if i.UserInputState==Enum.UserInputState.End then dragging=false end end)
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch) then
                local d=i.Position-ds; local np=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)
                _batPanel.Position=np; _batShadow.Position=UDim2.new(np.X.Scale,np.X.Offset-4,np.Y.Scale,np.Y.Offset-4)
            end
        end)
    end

    local batHdr=Instance.new("Frame",_batPanel); batHdr.Size=UDim2.new(1,0,0,36); batHdr.BackgroundTransparency=1; batHdr.ZIndex=41
    local batTitle=Instance.new("TextLabel",batHdr); batTitle.Size=UDim2.new(1,-36,1,0); batTitle.Position=UDim2.new(0,12,0,0)
    batTitle.BackgroundTransparency=1; batTitle.Font=Enum.Font.GothamBlack; batTitle.TextSize=IS_MOBILE and 13 or 12
    batTitle.TextXAlignment=Enum.TextXAlignment.Left; batTitle.ZIndex=42; batTitle.Text="WAVELI \xC2\xB7 DESYNC COUNTER"; batTitle.TextColor3=T().accent; regTheme(batTitle,"TextColor3","accent")
    local batSep=Instance.new("Frame",_batPanel); batSep.Size=UDim2.new(1,-16,0,1); batSep.Position=UDim2.new(0,8,0,36)
    batSep.BackgroundColor3=T().accent; batSep.BackgroundTransparency=0.7; batSep.BorderSizePixel=0; batSep.ZIndex=41; regTheme(batSep,"BackgroundColor3","accent")

    local tRow=Instance.new("Frame",_batPanel); tRow.Size=UDim2.new(1,-16,0,52); tRow.Position=UDim2.new(0,8,0,46)
    tRow.BackgroundColor3=Color3.fromRGB(22,22,28); tRow.BorderSizePixel=0; tRow.ZIndex=41
    Instance.new("UICorner",tRow).CornerRadius=UDim.new(0,10); local tSt=Instance.new("UIStroke",tRow); tSt.Color=C_BORDER; tSt.Thickness=1; tSt.Transparency=0.5
    local tLbl=Instance.new("TextLabel",tRow); tLbl.Size=UDim2.new(0.55,0,0,18); tLbl.Position=UDim2.new(0,12,0,8)
    tLbl.BackgroundTransparency=1; tLbl.Text="Desync Counter"; tLbl.Font=Enum.Font.GothamBold; tLbl.TextSize=IS_MOBILE and 13 or 12
    tLbl.TextColor3=Color3.fromRGB(220,220,228); tLbl.TextXAlignment=Enum.TextXAlignment.Left; tLbl.ZIndex=42
    _batStatusLbl2=Instance.new("TextLabel",tRow); _batStatusLbl2.Size=UDim2.new(0.55,0,0,14); _batStatusLbl2.Position=UDim2.new(0,12,0,28)
    _batStatusLbl2.BackgroundTransparency=1; _batStatusLbl2.Text="INACTIVE"; _batStatusLbl2.Font=Enum.Font.Gotham; _batStatusLbl2.TextSize=9
    _batStatusLbl2.TextColor3=Color3.fromRGB(100,100,120); _batStatusLbl2.TextXAlignment=Enum.TextXAlignment.Left; _batStatusLbl2.ZIndex=42
    _batPill2=Instance.new("TextButton",tRow); _batPill2.Size=UDim2.new(0,44,0,24); _batPill2.Position=UDim2.new(1,-54,0.5,-12)
    _batPill2.BackgroundColor3=Color3.fromRGB(28,28,36); _batPill2.Text=""; _batPill2.AutoButtonColor=false; _batPill2.ZIndex=42
    Instance.new("UICorner",_batPill2).CornerRadius=UDim.new(1,0); Instance.new("UIStroke",_batPill2).Color=C_BORDER
    _batDot2=Instance.new("Frame",_batPill2); _batDot2.Size=UDim2.new(0,16,0,16); _batDot2.Position=UDim2.new(0,4,0.5,-8)
    _batDot2.BackgroundColor3=Color3.fromRGB(60,60,70); _batDot2.BorderSizePixel=0; Instance.new("UICorner",_batDot2).CornerRadius=UDim.new(1,0)
    _batPill2.MouseButton1Click:Connect(function() _batSetOn(not _batEnabled) end)

    local kRow=Instance.new("Frame",_batPanel); kRow.Size=UDim2.new(1,-16,0,48); kRow.Position=UDim2.new(0,8,0,106)
    kRow.BackgroundColor3=Color3.fromRGB(22,22,28); kRow.BorderSizePixel=0; kRow.ZIndex=41
    Instance.new("UICorner",kRow).CornerRadius=UDim.new(0,10); local kSt=Instance.new("UIStroke",kRow); kSt.Color=C_BORDER; kSt.Thickness=1; kSt.Transparency=0.5
    local kLbl=Instance.new("TextLabel",kRow); kLbl.Size=UDim2.new(0.55,0,0.55,0); kLbl.Position=UDim2.new(0,12,0,6)
    kLbl.BackgroundTransparency=1; kLbl.Font=Enum.Font.GothamBold; kLbl.TextSize=IS_MOBILE and 12 or 11
    kLbl.TextColor3=Color3.fromRGB(180,180,180); kLbl.TextXAlignment=Enum.TextXAlignment.Left; kLbl.Text="Keybind:"; kLbl.ZIndex=42
    local hintLbl=Instance.new("TextLabel",kRow); hintLbl.Size=UDim2.new(0.55,0,0,12); hintLbl.Position=UDim2.new(0,12,1,-15)
    hintLbl.BackgroundTransparency=1; hintLbl.Font=Enum.Font.Gotham; hintLbl.TextSize=9
    hintLbl.TextColor3=Color3.fromRGB(100,100,125); hintLbl.TextXAlignment=Enum.TextXAlignment.Left; hintLbl.Text="click to change"; hintLbl.ZIndex=42
    local kBtn=Instance.new("TextButton",kRow); kBtn.Size=UDim2.new(0,52,0,30); kBtn.Position=UDim2.new(1,-62,0.5,-15)
    kBtn.BackgroundColor3=Color3.fromRGB(28,28,36); kBtn.BorderSizePixel=0; kBtn.Text="B"; kBtn.Font=Enum.Font.GothamBold; kBtn.TextSize=IS_MOBILE and 13 or 12
    kBtn.TextColor3=T().accent; kBtn.AutoButtonColor=false; kBtn.ZIndex=42; Instance.new("UICorner",kBtn).CornerRadius=UDim.new(0,8)
    local kStroke=Instance.new("UIStroke",kBtn); kStroke.Thickness=1; kStroke.Color=T().accent; kStroke.Transparency=0.5
    regTheme(kBtn,"TextColor3","accent"); regTheme(kStroke,"Color","accent")

    local batFoot=Instance.new("TextLabel",_batPanel); batFoot.Size=UDim2.new(1,0,0,12); batFoot.Position=UDim2.new(0,0,1,-14)
    batFoot.BackgroundTransparency=1; batFoot.Text="waveli hub"; batFoot.TextColor3=Color3.fromRGB(70,70,82); batFoot.Font=Enum.Font.Gotham; batFoot.TextSize=8; batFoot.TextXAlignment=Enum.TextXAlignment.Center; batFoot.ZIndex=42

    _batHidePanel=function()
        TweenService:Create(_batPanel,TweenInfo.new(0.15,Enum.EasingStyle.Quint,Enum.EasingDirection.Out),{Position=_batPanel.Position+UDim2.new(0,0,0,-8),BackgroundTransparency=1}):Play()
        task.delay(0.17,function() _batPanel.Visible=false; _batShadow.Visible=false; _batPanel.BackgroundTransparency=0; _batPanel.Position=_batPanel.Position+UDim2.new(0,0,0,8) end)
    end
    do
        local _batBound=Enum.KeyCode.B; local listening=false
        local function startL() listening=true; kBtn.Text="..."; kBtn.TextColor3=Color3.fromRGB(255,220,50); kStroke.Color=Color3.fromRGB(255,220,50); kStroke.Transparency=0; hintLbl.Text="press any key..." end
        local function stopL(nk) listening=false; if nk then _batBound=nk; kBtn.Text=nk.Name end; kBtn.TextColor3=T().accent; kStroke.Color=T().accent; kStroke.Transparency=0.5; hintLbl.Text="click to change" end
        kBtn.MouseButton1Click:Connect(function() if listening then stopL(nil) else startL() end end)
        UIS.InputBegan:Connect(function(i,gp)
            if listening and i.UserInputType==Enum.UserInputType.Keyboard then if i.KeyCode==Enum.KeyCode.Escape then stopL(nil) else stopL(i.KeyCode) end; return end
            if not gp and i.KeyCode==_batBound then _batSetOn(not _batEnabled) end
        end)
    end
end

-- ============================================================================
-- TAB CONTENT BUILDING
-- ============================================================================

-- ── TAB 1: SPEED ────────────────────────────────────────────────────────────
do
    local sc = tabScrolls[1]
    makeSectionLabel(sc, "Speed Settings")
    normalBox = makeInputRow(sc,"Normal Speed","Walk movement speed",State.normalSpeed,function(v)
        local n=tonumber(v); if n and n>0 and n<=500 then State.normalSpeed=n end
    end)
    carryBox = makeInputRow(sc,"Carry Speed","Speed while carrying item",State.carrySpeed,function(v)
        local n=tonumber(v); if n and n>0 and n<=500 then State.carrySpeed=n end
    end)
    laggerSpeedBox = makeInputRow(sc,"Lagger Speed","Speed in lagger mode",State.laggerSpeed,function(v)
        local n=tonumber(v); if n and n>0 and n<=500 then State.laggerSpeed=n end
    end)
    speedKeyBtn = makeKeybindRow(sc,"Speed Toggle Key","Press to toggle speed mode",Keys.speed,function(k) Keys.speed=k end)
    setLaggerMode, laggerModeKeyBtn = makeToggleRow(sc,"Lagger Mode","Lag-based movement style",Keys.laggerMode,false,
        function(on)
            State.laggerModeEnabled=on
            if on and modeValLbl then modeValLbl.Text="Lagger" end
            if not on and modeValLbl then modeValLbl.Text=State.speedToggled and "Carry" or "Normal" end
        end, function(k) Keys.laggerMode=k end)
    modeValLbl = makeStatusRow(sc,"Current Mode","Active speed category","Normal")
end

-- ── TAB 2: STEAL ────────────────────────────────────────────────────────────
do
    local sc = tabScrolls[2]
    makeSectionLabel(sc, "Auto Steal")
    local stealDurationBox
    makeToggleRow(sc,"Auto Grab","Automatically grab nearby orbs",nil,false,function(on)
        MagikGrab.Enabled=on
        if on then
            if not _magikThread then
                _magikThread=task.spawn(function()
                    while MagikGrab.Enabled do
                        if not MagikGrab.isStealing then if _magikGrabTick then _magikGrabTick() end end
                        task.wait(0.1)
                    end; _magikThread=nil
                end)
            end
        else MagikGrab.isStealing=false; if _magikThread then task.cancel(_magikThread); _magikThread=nil end end
    end)
    grabRadiusBox = makeInputRow(sc,"Steal Radius","Detection range in studs",MagikGrab.ScanRadius,function(v)
        local n=tonumber(v); if n and n>=5 and n<=500 then MagikGrab.ScanRadius=math.floor(n) end
    end)
    makeGap(sc, 6)
    makeSectionLabel(sc, "Tools")
    makeOpenPanelRow(sc,"Waveli Bypass","Block list power injection",
        function() if _vbPanel then _vbPanel.Visible=true; _vbShadow.Visible=true; _vbPanel.BackgroundTransparency=1; local op=_vbPanel.Position+UDim2.new(0,0,0,10); _vbPanel.Position=op; TweenService:Create(_vbPanel,TweenInfo.new(0.22,Enum.EasingStyle.Quint),{BackgroundTransparency=0,Position=op+UDim2.new(0,0,0,-10)}):Play() end end,
        function() if _vbHidePanel then _vbHidePanel() end end)
    makeOpenPanelRow(sc,"Waveli Lagger","Network lag tool",
        function() if _vlPanel then _vlPanel.Visible=true; _vlShadow.Visible=true; _vlPanel.BackgroundTransparency=1; local op=_vlPanel.Position+UDim2.new(0,0,0,10); _vlPanel.Position=op; TweenService:Create(_vlPanel,TweenInfo.new(0.22,Enum.EasingStyle.Quint),{BackgroundTransparency=0,Position=op+UDim2.new(0,0,0,-10)}):Play() end end,
        function() if _vlHidePanel then _vlHidePanel() end end)
end

-- ── TAB 3: BAT ──────────────────────────────────────────────────────────────
do
    local sc = tabScrolls[3]
    makeSectionLabel(sc, "Combat")
    setAutoBat, autoBatKeyBtn = makeToggleRow(sc,"Bat Aimbot","Auto-aim and swing bat",Keys.autoBat,false,
        function(on) if on then enableAutoBat() else disableAutoBat() end end, function(k) Keys.autoBat=k end)
    makeSelectorRow(sc,"Hit Mode","Auto Swing or manual control",{"Auto Swing","No Swing"},1,function(idx,opt) State.aimbotHitMode=opt end)
    setBatCounter = makeToggleRow(sc,"Counter Bat","Counter incoming bat hits",nil,false,
        function(on) State.batCounterEnabled=on end)
    makeSelectorRow(sc,"CB Mode","Follow mode for counter bat",{"Follow","No Follow"},1,function(idx,opt) State.batCounterFollow=(opt=="Follow") end)
    setMedusaCounter = makeToggleRow(sc,"Medusa Counter","Counter medusa attacks",nil,false,
        function(on) State.medusaCounterEnabled=on; if on then setupMedusaCounter(LP.Character) else stopMedusaCounter() end end)
    makeGap(sc, 6)
    makeSectionLabel(sc, "Desync")
    makeOpenPanelRow(sc,"Desync Counter","Advanced bat desync panel",
        function() if _batPanel then _batPanel.Visible=true; _batShadow.Visible=true; _batPanel.BackgroundTransparency=1; local op=_batPanel.Position+UDim2.new(0,0,0,10); _batPanel.Position=op; TweenService:Create(_batPanel,TweenInfo.new(0.22,Enum.EasingStyle.Quint),{BackgroundTransparency=0,Position=op+UDim2.new(0,0,0,-10)}):Play() end end,
        function() if _batHidePanel then _batHidePanel() end end)
end

-- ── TAB 4: JUMP ─────────────────────────────────────────────────────────────
do
    local sc = tabScrolls[4]
    makeSectionLabel(sc, "Movement")
    setInfJump = makeToggleRow(sc,"Infinite Jump","Jump without landing",nil,false,
        function(on)
            State.infJumpEnabled=on
            if on then if State.jumpMode=="Hold" then _gjSetup() end
            else if _gjVF then _gjVF:Destroy(); _gjVF=nil end; if _gjAtt then _gjAtt:Destroy(); _gjAtt=nil end end
        end)
    makeSelectorRow(sc,"Jump Mode","Single tap or hold to jump",{"Single","Hold"},1,function(idx,opt)
        State.jumpMode=opt
        if opt=="Single" then if _gjVF then _gjVF:Destroy(); _gjVF=nil end; if _gjAtt then _gjAtt:Destroy(); _gjAtt=nil end
        elseif opt=="Hold" and State.infJumpEnabled then _gjSetup() end
    end)
    setAntiRag = makeToggleRow(sc,"Anti Ragdoll","Prevent ragdoll state",nil,false,
        function(on) State.antiRagdollEnabled=on; if on then startAntiRagdoll() else stopAntiRagdoll() end end)
    setUnwalkToggle = makeToggleRow(sc,"Unwalk","Disable walking movement",nil,false,
        function(on) if on then startUnwalk() else stopUnwalk() end end)
    setTryhardAnim = makeToggleRow(sc,"Tryhard Anim","Enable try-hard animations",nil,false,
        function(on) State.animEnabled=on; if on then startTryhardAnim() else stopTryhardAnim() end end)
    do
        local tpDownKeyBtn; local setTPDown
        setTPDown, tpDownKeyBtn = makeToggleRow(sc,"TP Down","Teleport downward",Keys.tpDown,false,
            function(on)
                if on then task.spawn(function() runTPDown(); task.wait(0.05); if setTPDown then setTPDown(false) end end) end
            end, function(k) Keys.tpDown=k end)
    end
end

-- ── TAB 5: VISUAL ───────────────────────────────────────────────────────────
do
    local sc = tabScrolls[5]
    makeSectionLabel(sc, "Visual")
    setFps = makeToggleRow(sc,"FPS Boost","Improve frame rate",nil,false,
        function(on) State.fpsBoostEnabled=on; if on then pcall(applyFPSBoost) end end)
    setAntiLag = makeToggleRow(sc,"Anti Lag","Reduce lag effects",nil,false,
        function(on) State.antiLagEnabled=on; if on then applyAntiLag() end end)
    setUltraMode = makeToggleRow(sc,"Ultra Mode","Maximum performance mode",nil,false,
        function(on) State.ultraModeEnabled=on; applyUltraMode(on) end)
    setStretchedRes = makeToggleRow(sc,"Stretched Res","Stretched resolution display",nil,false,
        function(on) State.stretchedResEnabled=on; applyStretchedRes(on) end)
    setNoCamColl = makeToggleRow(sc,"No Cam Collision","Camera passes through walls",nil,false,
        function(on) State.noCamCollisionEnabled=on; applyNoCamCollision(on) end)
    makeGap(sc, 6)
    makeSectionLabel(sc, "Background")
    local bgNames={"Wreath","Blue","Pink","Waves","Lines"}
    local rows={{1,2},{3,4},{5}}
    for _,rowIdxs in ipairs(rows) do
        local rowFrame=Instance.new("Frame",sc)
        rowFrame.Size=UDim2.new(1,0,0,ROW_H1); rowFrame.BackgroundTransparency=1; rowFrame.LayoutOrder=LO(sc); rowFrame.ZIndex=10
        local rowLayout=Instance.new("UIListLayout",rowFrame); rowLayout.FillDirection=Enum.FillDirection.Horizontal; rowLayout.Padding=UDim.new(0,6); rowLayout.HorizontalAlignment=Enum.HorizontalAlignment.Center
        local rowPad=Instance.new("UIPadding",rowFrame); rowPad.PaddingLeft=UDim.new(0,0); rowPad.PaddingRight=UDim.new(0,0)
        for _,bIdx in ipairs(rowIdxs) do
            local btn=Instance.new("TextButton",rowFrame)
            btn.Size=UDim2.new(0,118,0,ROW_H1-6)
            btn.BackgroundColor3=(State.currentBg==bIdx) and Color3.fromRGB(255,105,180) or Color3.fromRGB(25,25,30)
            btn.BorderSizePixel=0; btn.Text=bgNames[bIdx]; btn.Font=Enum.Font.GothamBold; btn.TextSize=11
            btn.TextColor3=(State.currentBg==bIdx) and Color3.fromRGB(255,255,255) or Color3.fromRGB(160,160,170)
            btn.AutoButtonColor=false; btn.ZIndex=10
            Instance.new("UICorner",btn).CornerRadius=UDim.new(0,8)
            bgBtns[bIdx]=btn
            local capturedIdx=bIdx
            btn.MouseButton1Click:Connect(function() setBackground(capturedIdx) end)
            btn.MouseEnter:Connect(function() if State.currentBg~=capturedIdx then btn.BackgroundColor3=Color3.fromRGB(38,38,46) end end)
            btn.MouseLeave:Connect(function() if State.currentBg~=capturedIdx then btn.BackgroundColor3=Color3.fromRGB(25,25,30) end end)
        end
    end
end

-- ── TAB 6: CONFIG ───────────────────────────────────────────────────────────
do
    local sc = tabScrolls[6]
    makeSectionLabel(sc, "Auto Play")
    setAutoPlay, _ = makeToggleRow(sc,"Auto Play","Automatic play mode",Keys.autoPlay,false,
        function(on) toggleAutoPlay(on) end, function(k) Keys.autoPlay=k end)
    setAutoLeft, autoLeftKeyBtn = makeToggleRow(sc,"Auto Left","Auto move to left side",Keys.autoLeft,false,
        function(on) State.autoLeftEnabled=on; if on then startAutoLeft() else stopAutoLeft() end end, function(k) Keys.autoLeft=k end)
    setAutoRight, autoRightKeyBtn = makeToggleRow(sc,"Auto Right","Auto move to right side",Keys.autoRight,false,
        function(on) State.autoRightEnabled=on; if on then startAutoRight() else stopAutoRight() end end, function(k) Keys.autoRight=k end)
    dropBrainrotKeyBtn = makeKeybindRow(sc,"Drop Brainrot Key","Key to drop brainrot item",Keys.dropBrainrot,function(k) Keys.dropBrainrot=k end)
    makeGap(sc, 6)
    makeSectionLabel(sc, "Interface")
    guiHideKeyBtn = makeKeybindRow(sc,"Hide / Show GUI","Toggle GUI visibility",Keys.guiHide,function(k) Keys.guiHide=k end)
    setCustomFont = makeToggleRow(sc,"Custom Font","Use custom font style",nil,false,
        function(on) State.customFontEnabled=on; if on then enableCustomFont() else disableCustomFont() end end)
    do
        local _asThread=nil; local _asEnabled=true; local _asStatusLbl
        local function _startAutoSave()
            if _asThread then return end
            _asThread=task.spawn(function()
                while _asEnabled do
                    task.wait(5)
                    if _asEnabled and saveConfig then
                        pcall(saveConfig)
                        if _asStatusLbl then
                            _asStatusLbl.Text="Saved \226\156\147"
                            TweenService:Create(_asStatusLbl,TweenInfo.new(0.3),{TextColor3=Color3.fromRGB(80,200,120)}):Play()
                            task.delay(2.5,function()
                                if _asStatusLbl and _asEnabled then _asStatusLbl.Text="every 5s"; TweenService:Create(_asStatusLbl,TweenInfo.new(0.3),{TextColor3=C_TEXT_DIM}):Play() end
                            end)
                        end
                    end
                end; _asThread=nil
            end)
        end
        local function _stopAutoSave() _asEnabled=false; if _asThread then task.cancel(_asThread); _asThread=nil end end
        makeToggleRow(sc,"Auto Save","Save config automatically",nil,true,function(on)
            _asEnabled=on
            if on then _startAutoSave(); if _asStatusLbl then _asStatusLbl.Text="every 5s" end
            else _stopAutoSave(); if _asStatusLbl then _asStatusLbl.Text="disabled" end end
        end)
        _asStatusLbl = makeStatusRow(sc,"Save Status","Current save interval","every 5s")
        _startAutoSave()
    end
    makeGap(sc, 6)
    makeSectionLabel(sc, "Mobile Buttons")
    makeToggleRow(sc,"Show Buttons","Show mobile control buttons",nil,true,function(on)
        State.mobBtnVisible=on
        local pg=LP.PlayerGui; local mg=pg and pg:FindFirstChild("WaveliMobileButtons"); local cont=mg and mg:FindFirstChild("MobContainer")
        if cont then cont.Visible=on end; if scheduleAutoSave then scheduleAutoSave() end
    end)
    makeToggleRow(sc,"Lock Position","Lock mobile button positions",nil,false,function(on)
        State.mobBtnLocked=on; if scheduleAutoSave then scheduleAutoSave() end
    end)
    makeGap(sc, 6)
    makeSectionLabel(sc, "Theme")
    do
        local row=Instance.new("Frame",sc); row.Size=UDim2.new(1,0,0,IS_MOBILE and 44 or 40); row.LayoutOrder=LO(sc)
        styleRowBase(row)
        local lbl=Instance.new("TextLabel",row); lbl.Size=UDim2.new(0,80,1,0); lbl.Position=UDim2.new(0,12,0,0)
        lbl.BackgroundTransparency=1; lbl.Text="Color"; lbl.TextColor3=C_TEXT; lbl.Font=Enum.Font.GothamMedium; lbl.TextSize=12; lbl.TextXAlignment=Enum.TextXAlignment.Left
        local sw=IS_MOBILE and 34 or 30; local sh=IS_MOBILE and 22 or 18; local tw2=#Themes*sw+(#Themes-1)*4
        local swatches={}
        local function refreshSwatches()
            for i2,b in ipairs(swatches) do
                local s=b:FindFirstChildOfClass("UIStroke")
                if i2==State.currentTheme then s.Transparency=0; s.Thickness=2 else s.Transparency=0.5; s.Thickness=1 end
            end
        end
        for i2,theme in ipairs(Themes) do
            local b=Instance.new("TextButton",row)
            b.Size=UDim2.new(0,sw,0,sh); b.Position=UDim2.new(1,-(tw2+10)+(i2-1)*(sw+4),0.5,-sh/2)
            b.BackgroundColor3=theme.accent; b.BorderSizePixel=0; b.Text=""; b.AutoButtonColor=false; b.ZIndex=6
            Instance.new("UICorner",b).CornerRadius=UDim.new(0,8)
            local s2=Instance.new("UIStroke",b); s2.Color=Color3.fromRGB(255,255,255); s2.Thickness=1; s2.Transparency=0.5
            swatches[i2]=b
            b.MouseButton1Click:Connect(function() State.currentTheme=i2; applyTheme(); refreshSwatches(); if scheduleAutoSave then scheduleAutoSave() end end)
        end
        refreshSwatches()
        table.insert(ThemedElements,{el=row,custom=refreshSwatches})
    end
    makeGap(sc, 4)
    local saveRow=Instance.new("Frame",sc); saveRow.Size=UDim2.new(1,0,0,ROW_H1); saveRow.LayoutOrder=LO(sc)
    styleRowBase(saveRow)
    saveBtn=Instance.new("TextButton",saveRow); saveBtn.Size=UDim2.new(1,-20,1,-10); saveBtn.Position=UDim2.new(0,10,0,5)
    saveBtn.BackgroundColor3=T().accent; saveBtn.BorderSizePixel=0; saveBtn.Text="SAVE CONFIG"
    saveBtn.Font=Enum.Font.GothamBlack; saveBtn.TextSize=12; saveBtn.TextColor3=Color3.fromRGB(255,255,255)
    saveBtn.AutoButtonColor=false; saveBtn.ZIndex=5
    Instance.new("UICorner",saveBtn).CornerRadius=UDim.new(0,8)
    regTheme(saveBtn,"BackgroundColor3","accent")
    saveBtn.MouseButton1Click:Connect(function()
        if saveConfig then
            pcall(saveConfig)
            TweenService:Create(saveBtn,TweenInfo.new(0.1),{BackgroundColor3=Color3.fromRGB(60,200,100)}):Play()
            task.delay(0.6,function() TweenService:Create(saveBtn,TweenInfo.new(0.2),{BackgroundColor3=T().accent}):Play() end)
        end
    end)
    -- Hop power box
    makeGap(sc, 4)
    hopPowerBox = makeInputRow(sc,"Hop Power","Force applied on jump",20,function(v)
        local n=tonumber(v); if n and n>0 and n<=200 then State.hopPower=n end
    end)
end

-- ============================================================================
-- MINIMIZED PILL
-- ============================================================================
local mini = Instance.new("TextButton", gui)
mini.Name = "Mini"
mini.Size = UDim2.new(0, IS_MOBILE and 110 or 100, 0, IS_MOBILE and 34 or 30)
mini.Position = UDim2.new(0.5, IS_MOBILE and -55 or -50, 0, 10)
mini.BackgroundColor3 = C_PANEL
mini.BorderSizePixel = 0
mini.Text = ""
mini.AutoButtonColor = false
mini.Visible = false
mini.ZIndex = 30
Instance.new("UICorner", mini).CornerRadius = UDim.new(0, 20)
local miniStroke = Instance.new("UIStroke", mini)
miniStroke.Color = T().accent; miniStroke.Thickness = 1; miniStroke.Transparency = 0.4
regTheme(miniStroke, "Color", "accent")

local miniDot = Instance.new("Frame", mini)
miniDot.Size = UDim2.new(0,6,0,6); miniDot.Position = UDim2.new(0,10,0.5,-3)
miniDot.BackgroundColor3 = T().accent; miniDot.BorderSizePixel = 0; miniDot.ZIndex = 31
Instance.new("UICorner", miniDot).CornerRadius = UDim.new(1,0)
regTheme(miniDot, "BackgroundColor3", "accent")

local miniTxt = Instance.new("TextLabel", mini)
miniTxt.Size = UDim2.new(1,-24,1,0); miniTxt.Position = UDim2.new(0,22,0,0)
miniTxt.BackgroundTransparency = 1; miniTxt.Text = ".gg/wavelix"; miniTxt.TextColor3 = T().accent
miniTxt.Font = Enum.Font.GothamBlack; miniTxt.TextSize = IS_MOBILE and 11 or 10
miniTxt.TextXAlignment = Enum.TextXAlignment.Left; miniTxt.ZIndex = 31
regTheme(miniTxt, "TextColor3", "accent")

mini.MouseEnter:Connect(function() TweenService:Create(miniStroke,TweenInfo.new(0.12),{Transparency=0.1}):Play() end)
mini.MouseLeave:Connect(function() TweenService:Create(miniStroke,TweenInfo.new(0.12),{Transparency=0.4}):Play() end)
makeDraggable(mini)

local function showMain()
    State.guiVisible=true; main.Visible=true; shadow.Visible=true; mini.Visible=false
end
local function hideMain()
    State.guiVisible=false; main.Visible=false; shadow.Visible=false
    if pbFrame then pbFrame.Visible=false end; mini.Visible=true
end
mini.MouseButton1Click:Connect(showMain)
minBtn.MouseButton1Click:Connect(hideMain)

local function toggleGuiVis()
    State.guiVisible = not State.guiVisible
    if main then main.Visible=State.guiVisible end
    if shadow then shadow.Visible=State.guiVisible end
    if mini then mini.Visible=not State.guiVisible end
end

closeBtn.MouseButton1Click:Connect(function()
    pcall(stopAutoSteal)
    if Conns.antiRag then Conns.antiRag:Disconnect() end
    if Conns.autoPlay then Conns.autoPlay:Disconnect() end
    if Conns.autoLeft then Conns.autoLeft:Disconnect() end
    if Conns.autoRight then Conns.autoRight:Disconnect() end
    for _,c in pairs(Conns.anchor) do c:Disconnect() end
    gui:Destroy()
end)

-- ============================================================================
-- STEAL PROGRESS BAR
-- ============================================================================
pbFrame = Instance.new("Frame", gui)
pbFrame.Name = "ProgressBar"
pbFrame.Size = UDim2.new(0, IS_MOBILE and 240 or 280, 0, 48)
pbFrame.Position = UDim2.new(0.5, -140, 1, -88)
pbFrame.BackgroundColor3 = Color3.fromRGB(11,11,16)
pbFrame.BackgroundTransparency = 0.05
pbFrame.BorderSizePixel = 0
pbFrame.Active = true
pbFrame.ZIndex = 25
pbFrame.ClipsDescendants = false
Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 12)
local pbStroke = Instance.new("UIStroke", pbFrame)
pbStroke.Color = T().accent; pbStroke.Thickness = 1.5; pbStroke.Transparency = 0.55
regTheme(pbStroke,"Color","accent")
makeDraggable(pbFrame)

local pbTopBar = Instance.new("Frame", pbFrame)
pbTopBar.Size = UDim2.new(1,0,0,2); pbTopBar.Position = UDim2.new(0,0,0,0)
pbTopBar.BackgroundColor3 = T().accent; pbTopBar.BackgroundTransparency = 0.4; pbTopBar.BorderSizePixel = 0; pbTopBar.ZIndex = 26
Instance.new("UICorner", pbTopBar).CornerRadius = UDim.new(0,12)
regTheme(pbTopBar,"BackgroundColor3","accent")

progressPct = Instance.new("TextLabel", pbFrame)
progressPct.Size = UDim2.new(0,52,0,22); progressPct.Position = UDim2.new(0,12,0,6)
progressPct.BackgroundTransparency = 1; progressPct.Text = "0%"
progressPct.TextColor3 = Color3.fromRGB(235,235,245); progressPct.Font = Enum.Font.GothamBlack
progressPct.TextSize = 13; progressPct.TextXAlignment = Enum.TextXAlignment.Left; progressPct.ZIndex = 26

progressRadLbl = Instance.new("TextLabel", pbFrame)
progressRadLbl.Size = UDim2.new(0,110,0,22); progressRadLbl.Position = UDim2.new(1,-122,0,6)
progressRadLbl.BackgroundTransparency = 1; progressRadLbl.Text = "Radius: "..Steal.StealRadius
progressRadLbl.TextColor3 = T().accent; progressRadLbl.Font = Enum.Font.GothamBold
progressRadLbl.TextSize = 11; progressRadLbl.TextXAlignment = Enum.TextXAlignment.Right; progressRadLbl.ZIndex = 26
regTheme(progressRadLbl,"TextColor3","accent")

local progressBg = Instance.new("Frame", pbFrame)
progressBg.Size = UDim2.new(1,-24,0,6); progressBg.Position = UDim2.new(0,12,0,34)
progressBg.BackgroundColor3 = Color3.fromRGB(30,30,42); progressBg.BorderSizePixel = 0; progressBg.ZIndex = 26
Instance.new("UICorner", progressBg).CornerRadius = UDim.new(1,0)

progressFill = Instance.new("Frame", progressBg)
progressFill.Size = UDim2.new(0,0,1,0); progressFill.BackgroundColor3 = T().accent
progressFill.BorderSizePixel = 0; progressFill.ZIndex = 27
Instance.new("UICorner", progressFill).CornerRadius = UDim.new(1,0)
regTheme(progressFill,"BackgroundColor3","accent")

local origToggleGui = toggleGuiVis
toggleGuiVis = function() origToggleGui() end

pbFrame.Visible = true

_G._VynxGrabBox = grabRadiusBox

applyTheme()

end)()


-- ============================================================================
-- ALL MECHANICS (unchanged from original)
-- ============================================================================
;(function()

local detectedBaseSideConfirmed = false

local function getPlotPosition(plot)
        if not plot then return nil end
        if plot.PrimaryPart then return plot.PrimaryPart.Position end
        local sign = plot:FindFirstChild("PlotSign")
        if sign then local p = sign:IsA("BasePart") and sign or sign:FindFirstChildWhichIsA("BasePart"); if p then return p.Position end end
        local sum, count = Vector3.zero, 0
        for _, obj in plot:GetDescendants() do if obj:IsA("BasePart") then sum += obj.Position; count += 1 end end
        return count > 0 and (sum/count) or nil
end

local function findMyPlot()
        local plots = workspace:FindFirstChild("Plots"); if not plots then return nil end
        local name = LP.DisplayName or LP.Name
        local nameLower = name:lower()
        for _, plot in plots:GetChildren() do
                local sign = plot:FindFirstChild("PlotSign"); if not sign then continue end
                local yb = sign:FindFirstChild("YourBase")
                if yb and yb:IsA("BillboardGui") and yb.Enabled then return plot end
                local sg = sign:FindFirstChild("SurfaceGui"); if not sg then continue end
                local fr = sg:FindFirstChild("Frame"); if not fr then continue end
                local lbl2 = fr:FindFirstChild("TextLabel")
                if lbl2 and typeof(lbl2.Text) == "string" and lbl2.Text ~= "" then
                        local t = lbl2.Text:lower()
                        if t:find(nameLower, 1, true) and t:find("'s base", 1, true) then return plot end
                end
        end
        return nil
end

local function getSideByPlayerPos()
        local char = LP.Character; if not char then return nil end
        local root = char:FindFirstChild("HumanoidRootPart"); if not root then return nil end
        local pos = root.Position
        local dR = (pos - RIGHT_STEP_3).Magnitude
        local dL = (pos - LEFT_STEP_3).Magnitude
        if math.abs(dR - dL) > 10 then
                return dR < dL and "right" or "left"
        end
        return nil
end

getBaseSide = function()
        if State.detectedBaseSide and detectedBaseSideConfirmed then
                return State.detectedBaseSide
        end
        local myPlot
        for _ = 1, 30 do
                myPlot = findMyPlot()
                if myPlot then break end
                task.wait(1)
        end
        if myPlot then
                local bp = getPlotPosition(myPlot)
                if bp then
                        local side = (bp - RIGHT_STEP_3).Magnitude < (bp - LEFT_STEP_3).Magnitude and "right" or "left"
                        State.detectedBaseSide = side
                        detectedBaseSideConfirmed = true
                        return side
                end
        end
        local posSide = getSideByPlayerPos()
        if posSide then
                State.detectedBaseSide = posSide
                return posSide
        end
        return State.detectedBaseSide or "left"
end

resetBaseSide = function()
        State.detectedBaseSide = nil
        detectedBaseSideConfirmed = false
end

-- TRYHARD ANIM PACK
local Anims_K7 = {
        idle1    = "rbxassetid://133806214992291",
        idle2    = "rbxassetid://94970088341563",
        walk     = "rbxassetid://707897309",
        run      = "rbxassetid://707861613",
        jump     = "rbxassetid://116936326516985",
        fall     = "rbxassetid://116936326516985",
        climb    = "rbxassetid://116936326516985",
        swim     = "rbxassetid://116936326516985",
        swimidle = "rbxassetid://116936326516985",
}
local _animHeartbeatConn = nil
local _originalAnims = nil

local function _isPackAnim(id)
        if not id then return false end
        for _, v in pairs(Anims_K7) do if v == id then return true end end
        return false
end

saveOriginalAnims = function(char)
        local animate = char:FindFirstChild("Animate")
        if not animate then return end
        local function g(obj) return obj and obj.AnimationId or nil end
        local ids = {
                idle1    = g(animate.idle     and animate.idle.Animation1),
                idle2    = g(animate.idle     and animate.idle.Animation2),
                walk     = g(animate.walk     and animate.walk.WalkAnim),
                run      = g(animate.run      and animate.run.RunAnim),
                jump     = g(animate.jump     and animate.jump.JumpAnim),
                fall     = g(animate.fall     and animate.fall.FallAnim),
                climb    = g(animate.climb    and animate.climb.ClimbAnim),
                swim     = g(animate.swim     and animate.swim.Swim),
                swimidle = g(animate.swimidle and animate.swimidle.SwimIdle),
        }
        if not _isPackAnim(ids.walk) then _originalAnims = ids end
end

applyAnimPack = function(char)
        local animate = char:FindFirstChild("Animate")
        if not animate then return end
        local function s(obj, id) if obj then obj.AnimationId = id end end
        s(animate.idle     and animate.idle.Animation1,     Anims_K7.idle1)
        s(animate.idle     and animate.idle.Animation2,     Anims_K7.idle2)
        s(animate.walk     and animate.walk.WalkAnim,       Anims_K7.walk)
        s(animate.run      and animate.run.RunAnim,         Anims_K7.run)
        s(animate.jump     and animate.jump.JumpAnim,       Anims_K7.jump)
        s(animate.fall     and animate.fall.FallAnim,       Anims_K7.fall)
        s(animate.climb    and animate.climb.ClimbAnim,     Anims_K7.climb)
        s(animate.swim     and animate.swim.Swim,           Anims_K7.swim)
        s(animate.swimidle and animate.swimidle.SwimIdle,   Anims_K7.swimidle)
end

restoreOriginalAnims = function(char)
        if not _originalAnims then return end
        local animate = char:FindFirstChild("Animate")
        if not animate then return end
        local function s(obj, id) if obj and id then obj.AnimationId = id end end
        s(animate.idle     and animate.idle.Animation1,     _originalAnims.idle1)
        s(animate.idle     and animate.idle.Animation2,     _originalAnims.idle2)
        s(animate.walk     and animate.walk.WalkAnim,       _originalAnims.walk)
        s(animate.run      and animate.run.RunAnim,         _originalAnims.run)
        s(animate.jump     and animate.jump.JumpAnim,       _originalAnims.jump)
        s(animate.fall     and animate.fall.FallAnim,       _originalAnims.fall)
        s(animate.climb    and animate.climb.ClimbAnim,     _originalAnims.climb)
        s(animate.swim     and animate.swim.Swim,           _originalAnims.swim)
        s(animate.swimidle and animate.swimidle.SwimIdle,   _originalAnims.swimidle)
        local hum2 = char:FindFirstChildOfClass("Humanoid")
        if hum2 then
                for _, track in ipairs(hum2:GetPlayingAnimationTracks()) do track:Stop(0) end
                hum2:ChangeState(Enum.HumanoidStateType.Running)
        end
end

startTryhardAnim = function()
        if _animHeartbeatConn then _animHeartbeatConn:Disconnect(); _animHeartbeatConn = nil end
        local char = LP.Character
        if char then
                saveOriginalAnims(char)
                applyAnimPack(char)
                local hum2 = char:FindFirstChildOfClass("Humanoid")
                if hum2 then
                        for _, track in ipairs(hum2:GetPlayingAnimationTracks()) do track:Stop(0) end
                        hum2:ChangeState(Enum.HumanoidStateType.Running)
                end
        end
        _animHeartbeatConn = RunService.Heartbeat:Connect(function()
                if not State.animEnabled then return end
                local c = LP.Character
                if c then applyAnimPack(c) end
        end)
end

stopTryhardAnim = function()
        if _animHeartbeatConn then _animHeartbeatConn:Disconnect(); _animHeartbeatConn = nil end
        local char = LP.Character
        if char then restoreOriginalAnims(char) end
end

local function isCountdownNum(text) local n = tonumber(text); return n and n >= 1 and n <= 5 end
local function getTimerLabel()
        local ok, lbl2 = pcall(function()
                return LP.PlayerGui:FindFirstChild("DuelsMachineTopFrame")
                        and LP.PlayerGui.DuelsMachineTopFrame:FindFirstChild("DuelsMachineTopFrame")
                        and LP.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame:FindFirstChild("Timer")
                        and LP.PlayerGui.DuelsMachineTopFrame.DuelsMachineTopFrame.Timer:FindFirstChild("Label")
        end)
        return ok and lbl2 or nil
end
local function isInCountdown() local lbl2 = getTimerLabel(); return lbl2 and isCountdownNum(lbl2.Text) end

stopAutoPlay = function()
        State.autoPlayEnabled = false; State.autoPlayWaypoint = 1; State.autoPlayWaiting = false; State.autoPlayWaitingCountdown = false
        if Conns.autoPlay then Conns.autoPlay:Disconnect(); Conns.autoPlay = nil end
        local char = LP.Character
        if char then
                local root = char:FindFirstChild("HumanoidRootPart"); local hum2 = char:FindFirstChildOfClass("Humanoid")
                if root then root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0) end
                if hum2 then hum2:Move(Vector3.zero, false) end
        end
        if setAutoPlay then setAutoPlay(false) end
end

local function startAutoPlayMovement()
        if Conns.autoPlay then Conns.autoPlay:Disconnect() end
        State.autoPlayWaypoint = 1; State.autoPlayWaiting = false
        Conns.autoPlay = RunService.Heartbeat:Connect(function()
                if not State.autoPlayEnabled then return end
                local char = LP.Character; if not char then return end
                local root = char:FindFirstChild("HumanoidRootPart"); local hum2 = char:FindFirstChildOfClass("Humanoid")
                if not root or not hum2 then return end
                local wps = State.autoPlaySide == "right" and AP_RIGHT_WP or AP_LEFT_WP
                if State.autoPlayWaypoint > #wps then stopAutoPlay(); return end
                if State.autoPlayWaiting then root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0); return end
                local tp = wps[State.autoPlayWaypoint]
                local txz = Vector3.new(tp.X, 0, tp.Z); local cxz = Vector3.new(root.Position.X, 0, root.Position.Z)
                local dist = (txz - cxz).Magnitude
                local spd = State.autoPlayWaypoint > 2 and State.carrySpeed or State.normalSpeed
                if dist > 3 then
                        local md = (txz - cxz).Unit
                        root.AssemblyLinearVelocity = Vector3.new(md.X*spd, root.AssemblyLinearVelocity.Y, md.Z*spd)
                else
                        if State.autoPlayWaypoint == 2 then
                                root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0); State.autoPlayWaiting = true
                                task.spawn(function() task.wait(0.25); if State.autoPlayEnabled then State.autoPlayWaiting = false; State.autoPlayWaypoint = 3 end end)
                        elseif State.autoPlayWaypoint == #wps then
                                root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0); stopAutoPlay()
                        else State.autoPlayWaypoint += 1 end
                end
        end)
end

toggleAutoPlay = function(on)
        if not on then stopAutoPlay(); return end
        State.autoPlayEnabled = true
        task.spawn(function()
                local side = getBaseSide(); State.autoPlaySide = (side == "right") and "left" or "right"
                if not State.autoPlayEnabled then return end
                if isInCountdown() then
                        local lbl2 = getTimerLabel()
                        if lbl2 then
                                local conn2; conn2 = lbl2:GetPropertyChangedSignal("Text"):Connect(function()
                                        if isCountdownNum(lbl2.Text) and tonumber(lbl2.Text) == 1 then
                                                conn2:Disconnect(); task.wait(AUTO_START_DELAY)
                                                if State.autoPlayEnabled then startAutoPlayMovement() end
                                        end
                                end)
                        else startAutoPlayMovement() end
                else startAutoPlayMovement() end
        end)
end

local function findMedusa()
        local char = LP.Character; if not char then return nil end
        for _, tool in ipairs(char:GetChildren()) do
                if tool:IsA("Tool") then local tn = tool.Name:lower()
                        if tn:find("medusa") or tn:find("head") or tn:find("stone") then return tool end
                end
        end
        local bp2 = LP:FindFirstChild("Backpack")
        if bp2 then for _, tool in ipairs(bp2:GetChildren()) do
                if tool:IsA("Tool") then local tn = tool.Name:lower()
                        if tn:find("medusa") or tn:find("head") or tn:find("stone") then return tool end
                end
        end end
        return nil
end

local function useMedusaCounter()
        if State.medusaDebounce then return end
        if tick() - State.medusaLastUsed < MEDUSA_COOLDOWN then return end
        local char = LP.Character; if not char then return end
        State.medusaDebounce = true
        local med = findMedusa(); if not med then State.medusaDebounce = false; return end
        if med.Parent ~= char then local hum2 = char:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:EquipTool(med) end end
        pcall(function() med:Activate() end)
        pcall(function()
                local ev = med:FindFirstChildWhichIsA("RemoteEvent")
                if ev then ev:FireServer() end
        end)
        State.medusaLastUsed = tick(); State.medusaDebounce = false
end

local function onAnchorChanged(part)
        return part:GetPropertyChangedSignal("Anchored"):Connect(function()
                if not State.medusaCounterEnabled then return end
                if not part.Anchored then return end
                local char = LP.Character
                if not char then return end
                local root = char:FindFirstChild("HumanoidRootPart")
                local fullPetrify = root and root.Anchored
                local stoneOverlay = part.Transparency >= 0.9
                if fullPetrify or stoneOverlay then
                        useMedusaCounter()
                end
        end)
end
setupMedusaCounter = function(char)
        stopMedusaCounter(); if not char then return end
        for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then table.insert(Conns.anchor, onAnchorChanged(part)) end
        end
        table.insert(Conns.anchor, char.DescendantAdded:Connect(function(part)
                if part:IsA("BasePart") then table.insert(Conns.anchor, onAnchorChanged(part)) end
        end))
end
stopMedusaCounter = function()
        for _, c in pairs(Conns.anchor) do pcall(function() c:Disconnect() end) end; Conns.anchor = {}
end

runDropBrainrot = function()
        if State.dropBrainrotActive then return end
        State.dropBrainrotActive = true

        local _dropConns = {}
        task.spawn(function()
                -- Wyłącz kolizje innych graczy
                local colConn = RunService.Stepped:Connect(function()
                        if not State.dropBrainrotActive then return end
                        for _, p in ipairs(Players:GetPlayers()) do
                                if p ~= LP and p.Character then
                                        for _, part in ipairs(p.Character:GetChildren()) do
                                                if part:IsA("BasePart") then part.CanCollide = false end
                                        end
                                end
                        end
                end)
                table.insert(_dropConns, colConn)

                -- Główna pętla fling
                local flingLoop = RunService.Heartbeat:Connect(function()
                        if not State.dropBrainrotActive then return end
                        local c    = LP.Character
                        local root = c and c:FindFirstChild("HumanoidRootPart")
                        if not root then return end
                        local vel = root.Velocity
                        root.Velocity = vel * 10000 + Vector3.new(0, 10000, 0)
                        RunService.RenderStepped:Wait()
                        if root and root.Parent then root.Velocity = vel end
                        RunService.Stepped:Wait()
                        if root and root.Parent then root.Velocity = vel + Vector3.new(0, 0.1, 0) end
                end)
                table.insert(_dropConns, flingLoop)

                task.wait(0.15)
                State.dropBrainrotActive = false
                for _, c in ipairs(_dropConns) do pcall(function() c:Disconnect() end) end
        end)
end

local function faceSouth()
        pcall(function()
                local char = LP.Character; if not char then return end
                local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
                root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0,0,0)
                local cam = workspace.CurrentCamera
                if cam then local pos = root.Position; cam.CFrame = CFrame.new(pos.X, pos.Y+5, pos.Z-12) * CFrame.Angles(math.rad(-15),0,0) end
        end)
end
local function faceNorth()
        pcall(function()
                local char = LP.Character; if not char then return end
                local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
                root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(180), 0)
                local cam = workspace.CurrentCamera
                if cam then local pos = root.Position; cam.CFrame = CFrame.new(pos.X, pos.Y+2, pos.Z+12) * CFrame.Angles(0, math.rad(180), 0) end
        end)
end

startAutoLeft = function()
        if Conns.autoLeft then Conns.autoLeft:Disconnect() end; State.autoLeftPhase = 1
        Conns.autoLeft = RunService.Heartbeat:Connect(function()
                if not State.autoLeftEnabled then return end
                local char = LP.Character; if not char then return end
                local root = char:FindFirstChild("HumanoidRootPart"); local hum2 = char:FindFirstChildOfClass("Humanoid")
                if not root or not hum2 then return end
                local st = hum2:GetState()
                if hum2.PlatformStand or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
                        hum2:Move(Vector3.zero, false); return
                end
                local spd = State.laggerModeEnabled and State.laggerSpeed or State.normalSpeed
                if State.autoLeftPhase == 1 then
                        local tgt = Vector3.new(POS.L1.X, root.Position.Y, POS.L1.Z)
                        if (tgt - root.Position).Magnitude < 1 then
                                State.autoLeftPhase = 2
                                local d = POS.L2 - root.Position; local mv = Vector3.new(d.X, 0, d.Z).Unit
                                hum2:Move(mv, false); root.AssemblyLinearVelocity = Vector3.new(mv.X*spd, root.AssemblyLinearVelocity.Y, mv.Z*spd); return
                        end
                        local d = POS.L1 - root.Position; local mv = Vector3.new(d.X, 0, d.Z).Unit
                        hum2:Move(mv, false); root.AssemblyLinearVelocity = Vector3.new(mv.X*spd, root.AssemblyLinearVelocity.Y, mv.Z*spd)
                elseif State.autoLeftPhase == 2 then
                        local tgt = Vector3.new(POS.L2.X, root.Position.Y, POS.L2.Z)
                        if (tgt - root.Position).Magnitude < 1 then
                                hum2:Move(Vector3.zero, false); root.AssemblyLinearVelocity = Vector3.zero
                                State.autoLeftEnabled = false; if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft = nil end
                                State.autoLeftPhase = 1; if setAutoLeft then setAutoLeft(false) end; return
                        end
                        local d = POS.L2 - root.Position; local mv = Vector3.new(d.X, 0, d.Z).Unit
                        hum2:Move(mv, false); root.AssemblyLinearVelocity = Vector3.new(mv.X*spd, root.AssemblyLinearVelocity.Y, mv.Z*spd)
                end
        end)
end
stopAutoLeft = function()
        if Conns.autoLeft then Conns.autoLeft:Disconnect(); Conns.autoLeft = nil end; State.autoLeftPhase = 1
        local char = LP.Character; if char then local hum2 = char:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero, false) end end
        if setAutoLeft then setAutoLeft(false) end
end
startAutoRight = function()
        if Conns.autoRight then Conns.autoRight:Disconnect() end; State.autoRightPhase = 1
        Conns.autoRight = RunService.Heartbeat:Connect(function()
                if not State.autoRightEnabled then return end
                local char = LP.Character; if not char then return end
                local root = char:FindFirstChild("HumanoidRootPart"); local hum2 = char:FindFirstChildOfClass("Humanoid")
                if not root or not hum2 then return end
                local st = hum2:GetState()
                if hum2.PlatformStand or st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
                        hum2:Move(Vector3.zero, false); return
                end
                local spd = State.laggerModeEnabled and State.laggerSpeed or State.normalSpeed
                if State.autoRightPhase == 1 then
                        local tgt = Vector3.new(POS.R1.X, root.Position.Y, POS.R1.Z)
                        if (tgt - root.Position).Magnitude < 1 then
                                State.autoRightPhase = 2
                                local d = POS.R2 - root.Position; local mv = Vector3.new(d.X, 0, d.Z).Unit
                                hum2:Move(mv, false); root.AssemblyLinearVelocity = Vector3.new(mv.X*spd, root.AssemblyLinearVelocity.Y, mv.Z*spd); return
                        end
                        local d = POS.R1 - root.Position; local mv = Vector3.new(d.X, 0, d.Z).Unit
                        hum2:Move(mv, false); root.AssemblyLinearVelocity = Vector3.new(mv.X*spd, root.AssemblyLinearVelocity.Y, mv.Z*spd)
                elseif State.autoRightPhase == 2 then
                        local tgt = Vector3.new(POS.R2.X, root.Position.Y, POS.R2.Z)
                        if (tgt - root.Position).Magnitude < 1 then
                                hum2:Move(Vector3.zero, false); root.AssemblyLinearVelocity = Vector3.zero
                                State.autoRightEnabled = false; if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight = nil end
                                State.autoRightPhase = 1; if setAutoRight then setAutoRight(false) end; return
                        end
                        local d = POS.R2 - root.Position; local mv = Vector3.new(d.X, 0, d.Z).Unit
                        hum2:Move(mv, false); root.AssemblyLinearVelocity = Vector3.new(mv.X*spd, root.AssemblyLinearVelocity.Y, mv.Z*spd)
                end
        end)
end
stopAutoRight = function()
        if Conns.autoRight then Conns.autoRight:Disconnect(); Conns.autoRight = nil end; State.autoRightPhase = 1
        local char = LP.Character; if char then local hum2 = char:FindFirstChildOfClass("Humanoid"); if hum2 then hum2:Move(Vector3.zero, false) end end
        if setAutoRight then setAutoRight(false) end
end

startAntiRagdoll = function()
        if Conns.antiRag then return end
        Conns.antiRag = RunService.Heartbeat:Connect(function()
                local char = LP.Character; if not char then return end
                local hum2 = char:FindFirstChildOfClass("Humanoid"); local root = char:FindFirstChild("HumanoidRootPart")
                if hum2 then
                        local st = hum2:GetState()
                        if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
                                hum2:ChangeState(Enum.HumanoidStateType.Running); workspace.CurrentCamera.CameraSubject = hum2
                                pcall(function() local pm = LP.PlayerScripts:FindFirstChild("PlayerModule"); if pm then require(pm:FindFirstChild("ControlModule")):Enable() end end)
                                if root then root.Velocity = Vector3.new(0,0,0); root.RotVelocity = Vector3.new(0,0,0) end
                        end
                end
                for _, obj in ipairs(char:GetDescendants()) do if obj:IsA("Motor6D") and not obj.Enabled then obj.Enabled = true end end
        end)
end
stopAntiRagdoll = function()
        if Conns.antiRag then Conns.antiRag:Disconnect(); Conns.antiRag = nil end
end

applyFPSBoost = function()
        pcall(function() setfpscap(999999999) end)
        local function processObj(v)
                pcall(function()
                        if v:IsA("Model") then v.LevelOfDetail = Enum.ModelLevelOfDetail.Disabled; v.ModelStreamingMode = Enum.ModelStreamingMode.Nonatomic
                        elseif v:IsA("MeshPart") then v.CastShadow = false; v.DoubleSided = false; v.RenderFidelity = Enum.RenderFidelity.Performance
                        elseif v:IsA("BasePart") then v.CastShadow = false; v.Material = Enum.Material.Plastic; v.Reflectance = 0
                        elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1
                        elseif v:IsA("SpecialMesh") then v.TextureId = ""
                        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") or v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then v.Enabled = false
                        elseif v:IsA("Explosion") then v.BlastPressure = 1; v.BlastRadius = 1
                        elseif v:IsA("SurfaceAppearance") or v:IsA("MaterialVariant") then v:Destroy()
                        elseif v:IsA("Attachment") then v.Visible = false end
                end)
        end
        for _, v in pairs(workspace:GetDescendants()) do processObj(v) end
        pcall(function()
                local lighting = game:GetService("Lighting")
                for _, v in pairs(lighting:GetDescendants()) do
                        pcall(function()
                                if v:IsA("Sky") or v:IsA("Atmosphere") or v:IsA("BloomEffect") or v:IsA("BlurEffect") or v:IsA("SunRaysEffect") or v:IsA("DepthOfFieldEffect") or v:IsA("Clouds") or v:IsA("PostEffect") or v:IsA("ColorCorrectionEffect") then v:Destroy() end
                        end)
                end
                pcall(function() sethiddenproperty(lighting, "Technology", Enum.Technology.Legacy) end)
                lighting.GlobalShadows = false; lighting.FogEnd = 9e9; lighting.Brightness = 0
                local terrain = workspace:FindFirstChildOfClass("Terrain")
                if terrain then
                        pcall(function() sethiddenproperty(terrain, "Decoration", false) end)
                        terrain.WaterReflectance = 0; terrain.WaterTransparency = 0.7; terrain.WaterWaveSize = 0; terrain.WaterWaveSpeed = 0
                end
        end)
        workspace.DescendantAdded:Connect(function(v) if State.fpsBoostEnabled then task.spawn(processObj, v) end end)
end

-- ============================================================================
-- AUTO STEAL  (zzzz hub semi-instant steal engine)
-- discord.gg/rNvAU6cjVB — integrated into Waveli Hub
-- ============================================================================
local _SCFG = {
    AUTO_STEAL_ENABLED = false,   -- synced with Steal.AutoStealEnabled
    HOLD_MIN    = 1.3,
    HOLD_MAX    = 2.6,            -- synced with Steal.StealDuration via setters
    ENTRY_DELAY = 0.3,
    COOLDOWN    = 0.05,
    STEAL_RANGE = 10,             -- synced with Steal.StealRadius via setters
    PRIME_RANGE = 80,
}

-- Keep Steal.StealRadius / StealDuration bridged into _SCFG at runtime
_SCFG.STEAL_RANGE = Steal.StealRadius
_SCFG.HOLD_MAX    = Steal.StealDuration

local _RS = {
    Players = Players, ReplicatedStorage = ReplicatedStorage,
    RunService = RunService, UserInputService = UIS,
    TweenService = TweenService, LocalPlayer = LP,
}

-- Synchronizer remote setup
local _syncOk, _syncPackages, _syncDatas = pcall(function()
    return ReplicatedStorage:WaitForChild("Packages", 5),
           ReplicatedStorage:WaitForChild("Datas", 5)
end)

local _AnimalsData = {}
if _syncOk and _syncPackages and _syncDatas then
    pcall(function()
        local ad = _syncDatas:FindFirstChild("Animals")
        if ad then _AnimalsData = require(ad) end
    end)
end

local _plots = workspace:FindFirstChild("Plots")

local _syncRemotes = {}
pcall(function()
    local folder = _syncPackages:WaitForChild("Synchronizer", 5)
    if folder then
        _syncRemotes.channelFolder = folder:WaitForChild("Channel", 5)
        _syncRemotes.routeRemote   = folder:WaitForChild("CommunicationRoute", 5)
        _syncRemotes.requestData   = folder:FindFirstChild("RequestData")
    end
end)

local _plotAnimalSync = { caches = {}, connections = {} }

local function _splitSyncPath(path)
    if typeof(path) == "table" then return path end
    local out = {}
    for part in string.gmatch(tostring(path), "[^%.]+") do
        table.insert(out, tonumber(part) or part)
    end
    return out
end

local function _resolveSyncPath(path, root)
    local current, parent, key = root, nil, nil
    for _, part in ipairs(_splitSyncPath(path)) do
        parent = current; key = part
        current = current and current[part] or nil
    end
    return current, parent, key
end

local function _applyPlotSyncDiff(channelName, packet)
    local cache = _plotAnimalSync.caches[channelName]
    if typeof(cache) ~= "table" then return end
    local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
    local current, parent, key = _resolveSyncPath(path, cache)
    if     action == "Changed"          then if parent then parent[key] = a end
    elseif action == "ArrayInsert"      then if current then table.insert(current, b, a) end
    elseif action == "ArrayRemoved"     then if current then table.remove(current, b) end
    elseif action == "DictionaryInsert" then if current then current[b] = a end
    elseif action == "DictionaryRemoved"then if current then current[b] = nil end
    end
end

local function _attachPlotChannel(remote)
    if _plotAnimalSync.connections[remote] then return end
    if not _plots then return end
    local channelName = tostring(remote.Name)
    if not _plots:FindFirstChild(channelName) then return end
    if _syncRemotes.requestData and _plotAnimalSync.caches[channelName] == nil then
        local ok, data = pcall(function() return _syncRemotes.requestData:InvokeServer(channelName) end)
        _plotAnimalSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
    elseif _plotAnimalSync.caches[channelName] == nil then
        _plotAnimalSync.caches[channelName] = {}
    end
    _plotAnimalSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
        for _, packet in ipairs(queue) do _applyPlotSyncDiff(channelName, packet) end
    end)
end

local function _detachPlotChannel(channelName)
    for remote, conn in pairs(_plotAnimalSync.connections) do
        if tostring(remote.Name) == tostring(channelName) then
            conn:Disconnect()
            _plotAnimalSync.connections[remote] = nil
            _plotAnimalSync.caches[tostring(channelName)] = nil
            break
        end
    end
end

if _syncRemotes.channelFolder then
    for _, child in ipairs(_syncRemotes.channelFolder:GetChildren()) do
        if child:IsA("RemoteEvent") then _attachPlotChannel(child) end
    end
    _syncRemotes.channelFolder.ChildAdded:Connect(function(child)
        if child:IsA("RemoteEvent") then _attachPlotChannel(child) end
    end)
end
if _syncRemotes.routeRemote then
    _syncRemotes.routeRemote.OnClientEvent:Connect(function(actions)
        for _, action in ipairs(actions) do
            local kind, channelName = action[1], tostring(action[2])
            if not (_plots and _plots:FindFirstChild(channelName)) then continue end
            if kind == "ListenerAdded" then
                local r = _syncRemotes.channelFolder and _syncRemotes.channelFolder:FindFirstChild(channelName)
                if r and r:IsA("RemoteEvent") then _attachPlotChannel(r) end
            elseif kind == "ListenerRemoved" then
                _detachPlotChannel(channelName)
            end
        end
    end)
end

local function _getPlotChannelData(plotName)
    return _plotAnimalSync.caches[plotName]
end

local _allAnimalsCache = {}
local _PromptMemoryCache = {}
local _InternalStealCache = {}
local _stealConnection = nil

local StealState = {
    active = false, startTime = 0, phase = "idle",
    label = "", lastResult = "", lastResultTime = 0,
    totalSteals = 0, failedSteals = 0,
}

-- Spiral visualisation
local _SpiralVis = { cubes = {}, connection = nil, targetPosition = nil, rotationAngle = 0 }

local function _createSpiralCubes(endPos)
    for _, c in ipairs(_SpiralVis.cubes) do
        if c and c.part and c.part.Parent then c.part:Destroy() end
    end
    _SpiralVis.cubes = {}
    if not endPos then return end
    local char = LP.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    local startPos = char.HumanoidRootPart.Position
    local numCubes = 30
    local spiralRadius = 2.5
    local cubeFolder = Instance.new("Folder")
    cubeFolder.Name = "SpiralCubes"
    cubeFolder.Parent = workspace
    local dir = (endPos - startPos).Unit
    local dist = (endPos - startPos).Magnitude
    for i = 1, numCubes do
        local cube = Instance.new("Part")
        cube.Shape = Enum.PartType.Block
        cube.Size = Vector3.new(0.3, 0.3, 0.3)
        cube.Material = Enum.Material.Neon
        cube.Color = Color3.fromRGB(0, 210, 255)
        cube.CanCollide = false
        cube.CFrame = CFrame.new(startPos)
        cube.Parent = cubeFolder
        table.insert(_SpiralVis.cubes, { part=cube, index=i, totalCubes=numCubes,
            startPos=startPos, endPos=endPos, direction=dir, distance=dist })
    end
    _SpiralVis.targetPosition = endPos
    if _SpiralVis.connection then _SpiralVis.connection:Disconnect() end
    _SpiralVis.connection = RunService.RenderStepped:Connect(function(dt)
        _SpiralVis.rotationAngle = _SpiralVis.rotationAngle + dt * 5
        local c2 = LP.Character
        local hrp2 = c2 and c2:FindFirstChild("HumanoidRootPart")
        if not hrp2 then return end
        local sp2 = hrp2.Position
        local ep2 = _SpiralVis.targetPosition
        if not ep2 then return end
        local dv = ep2 - sp2
        local d2 = dv.Magnitude
        if d2 <= 0.01 then return end
        local dd = dv.Unit
        local p1 = Vector3.new(-dd.Z, 0, dd.X)
        if p1.Magnitude < 0.01 then p1 = Vector3.new(1, 0, 0) end
        p1 = p1.Unit
        local p2 = dd:Cross(p1)
        if p2.Magnitude > 0 then p2 = p2.Unit end
        for _, cd in ipairs(_SpiralVis.cubes) do
            local cp = cd.part
            if not cp or not cp.Parent then continue end
            local prog = cd.index / cd.totalCubes
            local posOnPath = sp2 + dd * (d2 * prog)
            local ang = (prog * math.pi * 4) + _SpiralVis.rotationAngle
            local offset = p1 * math.cos(ang) * spiralRadius + p2 * math.sin(ang) * spiralRadius
            cp.Position = posOnPath + offset
        end
    end)
end

local function _clearSpiralCubes()
    if _SpiralVis.connection then _SpiralVis.connection:Disconnect(); _SpiralVis.connection = nil end
    for _, c in ipairs(_SpiralVis.cubes) do
        if c and c.part and c.part.Parent then c.part:Destroy() end
    end
    _SpiralVis.cubes = {}
    _SpiralVis.targetPosition = nil
end

local function _getPlotOwner(plot)
    local sign = plot:FindFirstChild("PlotSign")
    local frame = sign and sign:FindFirstChild("SurfaceGui") and sign.SurfaceGui:FindFirstChild("Frame")
    local label = frame and frame:FindFirstChild("TextLabel")
    if not label or label.Text == "Empty Base" then return nil end
    return label.Text:gsub("'s [Bb]ase$", ""):gsub("%s+$", "")
end

local function _isMyBaseAnimal(animalData)
    if not animalData or not animalData.plot or not _plots then return false end
    local plot = _plots:FindFirstChild(animalData.plot)
    if not plot then return false end
    return _getPlotOwner(plot) == LP.DisplayName
end

local function _findPromptForAnimal(animalData)
    if not animalData then return nil end
    local cached = _PromptMemoryCache[animalData.uid]
    if cached and cached.Parent then return cached end
    if not _plots then return nil end
    local plot = _plots:FindFirstChild(animalData.plot)
    if not plot then return nil end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    local podium = podiums:FindFirstChild(animalData.slot)
    if not podium then return nil end
    local base = podium:FindFirstChild("Base")
    if not base then return nil end
    local spawn = base:FindFirstChild("Spawn")
    if not spawn then return nil end
    local attach = spawn:FindFirstChild("PromptAttachment")
    if not attach then return nil end
    for _, p in ipairs(attach:GetChildren()) do
        if p:IsA("ProximityPrompt") then
            _PromptMemoryCache[animalData.uid] = p
            return p
        end
    end
    return nil
end

local function _getAnimalPosition(animalData)
    if not _plots then return nil end
    local plot = _plots:FindFirstChild(animalData.plot)
    if not plot then return nil end
    local podiums = plot:FindFirstChild("AnimalPodiums")
    if not podiums then return nil end
    local podium = podiums:FindFirstChild(animalData.slot)
    if not podium then return nil end
    return podium:GetPivot().Position
end

local function _distToAnimal(animalData)
    local char = LP.Character
    if not char then return math.huge end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
    if not hrp then return math.huge end
    local pos = _getAnimalPosition(animalData)
    if not pos then return math.huge end
    return (hrp.Position - pos).Magnitude
end

local function _pickClosest()
    local char = LP.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
    if not hrp then return nil end
    local best, bestDist = nil, math.huge
    for _, animalData in ipairs(_allAnimalsCache) do
        if _isMyBaseAnimal(animalData) then continue end
        local pos = _getAnimalPosition(animalData)
        if not pos then continue end
        local dist = (hrp.Position - pos).Magnitude
        if dist > _SCFG.PRIME_RANGE then continue end
        if dist < bestDist then bestDist = dist; best = animalData end
    end
    return best
end

local function _buildStealCallbacks(prompt)
    if _InternalStealCache[prompt] then return end
    local data = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }
    local ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan)
    if ok1 and type(conns1) == "table" then
        for _, conn in ipairs(conns1) do
            if type(conn.Function) == "function" then
                table.insert(data.holdCallbacks, conn.Function)
            end
        end
    end
    local ok2, conns2 = pcall(getconnections, prompt.Triggered)
    if ok2 and type(conns2) == "table" then
        for _, conn in ipairs(conns2) do
            if type(conn.Function) == "function" then
                table.insert(data.triggerCallbacks, conn.Function)
            end
        end
    end
    if (#data.holdCallbacks > 0) or (#data.triggerCallbacks > 0) then
        _InternalStealCache[prompt] = data
    end
end

local function _executeStealAsync(prompt, animalData)
    local data = _InternalStealCache[prompt]
    if not data or not data.ready then return false end
    data.ready = false
    local label = animalData.name or "Animal"
    StealState.active = true
    StealState.startTime = tick()
    StealState.phase = "holding"
    StealState.label = label
    local animalPos = _getAnimalPosition(animalData)
    if animalPos then _createSpiralCubes(animalPos) end
    task.spawn(function()
        for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
        task.wait(_SCFG.HOLD_MIN)
        StealState.phase = "waitingRange"
        local alreadyInRange = _distToAnimal(animalData) <= _SCFG.STEAL_RANGE
        local fired = false
        while true do
            local elapsed = tick() - StealState.startTime
            if elapsed > _SCFG.HOLD_MAX then break end
            if not prompt.Parent then break end
            if _distToAnimal(animalData) <= _SCFG.STEAL_RANGE then
                if not alreadyInRange then task.wait(_SCFG.ENTRY_DELAY) end
                for _, fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
                fired = true
                break
            end
            task.wait()
        end
        if fired then
            StealState.totalSteals = StealState.totalSteals + 1
            StealState.lastResult = "Stole " .. label
            if showHeadCountdown then task.spawn(showHeadCountdown, 3) end
        else
            StealState.failedSteals = StealState.failedSteals + 1
            StealState.lastResult = "Missed window: " .. label
        end
        StealState.active = false
        StealState.phase = "idle"
        StealState.lastResultTime = tick()
        _clearSpiralCubes()
        task.wait(_SCFG.COOLDOWN)
        data.ready = true
    end)
    return true
end

local function _attemptSteal(prompt, animalData)
    if not prompt or not prompt.Parent then return false end
    _buildStealCallbacks(prompt)
    if not _InternalStealCache[prompt] then return false end
    return _executeStealAsync(prompt, animalData)
end

local function _scanAllPlots()
    if not _plots then return 0 end
    local newCache = {}
    for _, plot in ipairs(_plots:GetChildren()) do
        local cache = _getPlotChannelData(plot.Name)
        if not cache then continue end
        local animalList = cache.AnimalList
        if typeof(animalList) ~= "table" then continue end
        for slot, animalData in pairs(animalList) do
            if type(animalData) == "table" then
                local animalName = animalData.Index
                local animalInfo = _AnimalsData[animalName]
                if not animalInfo then continue end
                table.insert(newCache, {
                    name = animalInfo.DisplayName or animalName,
                    plot = plot.Name,
                    slot = tostring(slot),
                    uid  = plot.Name .. "_" .. tostring(slot),
                })
            end
        end
    end
    _allAnimalsCache = newCache
    return #_allAnimalsCache
end

-- Public API: startAutoSteal / stopAutoSteal (assigned to forward-decl'd upvalues)
startAutoSteal = function()
    if _stealConnection then return end
    Steal.AutoStealEnabled = true
    _SCFG.AUTO_STEAL_ENABLED = true
    _stealConnection = RunService.Heartbeat:Connect(function()
        if not _SCFG.AUTO_STEAL_ENABLED then return end
        if StealState.active then return end
        local target = _pickClosest()
        if not target then return end
        local prompt = _PromptMemoryCache[target.uid]
        if not prompt or not prompt.Parent then
            prompt = _findPromptForAnimal(target)
        end
        if prompt then _attemptSteal(prompt, target) end
    end)
end
stopAutoSteal = function()
    if _stealConnection then _stealConnection:Disconnect(); _stealConnection = nil end
    Steal.AutoStealEnabled = false
    _SCFG.AUTO_STEAL_ENABLED = false
    _clearSpiralCubes()
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
    if progressPct then progressPct.Text = "0%" end
end

-- Update Waveli progress bar using StealState from the new engine
RunService.Heartbeat:Connect(function()
    if not progressFill or not progressPct then return end
    if StealState.active then
        local prog = math.clamp((tick() - StealState.startTime) / _SCFG.HOLD_MAX, 0, 1)
        progressFill.Size = UDim2.new(prog, 0, 1, 0)
        progressPct.Text  = math.floor(prog * 100) .. "%"
    end
end)

-- Periodic plot scan (every 5 s, Cursed Hub style)
task.spawn(function()
    _scanAllPlots()
    while task.wait(5) do _scanAllPlots() end
end)

-- ============================================================================
-- MAGIK AUTO GRAB ENGINE  (ported from @magik.z, discord.gg/rNvAU6cjVB)
-- 150-stud scan radius · 1.30s hold simulation · skips own plot
-- ============================================================================
local function _magikIsMyPlot(plot)
    if not plot then return false end
    local sign = plot:FindFirstChild("PlotSign")
    if sign then
        local yourBase = sign:FindFirstChild("YourBase")
        if yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled then
            return true
        end
    end
    return false
end

local function _magikGetRoot()
    local char = LP.Character
    return char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso"))
end

local function _magikIsValidPrompt(prompt)
    if not prompt or not prompt.Parent or not prompt.Enabled then return false end
    local state      = prompt:GetAttribute("State")
    local actionText = prompt.ActionText
    return state == "Steal" or state == "Grab" or actionText == "Steal" or actionText == "Grab"
end

local function _magikGetNearest()
    local root = _magikGetRoot()
    if not root then return nil end
    local nearestPrompt = nil
    local minDist = MagikGrab.ScanRadius
    local plots = workspace:FindFirstChild("Plots")
    if not plots then return nil end
    for _, plot in ipairs(plots:GetChildren()) do
        if _magikIsMyPlot(plot) then continue end
        local podiums = plot:FindFirstChild("AnimalPodiums")
        if not podiums then continue end
        for _, podium in ipairs(podiums:GetChildren()) do
            local base    = podium:FindFirstChild("Base")
            local spPoint = base and base:FindFirstChild("Spawn")
            local attach  = spPoint and spPoint:FindFirstChild("PromptAttachment")
            if attach then
                for _, child in ipairs(attach:GetChildren()) do
                    if child:IsA("ProximityPrompt") and _magikIsValidPrompt(child) then
                        local dist = (root.Position - child.Parent.WorldPosition).Magnitude
                        if dist < minDist then
                            minDist = dist
                            nearestPrompt = child
                        end
                    end
                end
            end
        end
    end
    return nearestPrompt
end

local function _magikFireConnections(prompt, signalName)
    local ok, conns = pcall(getconnections, prompt[signalName])
    if not ok or type(conns) ~= "table" then return end
    for _, conn in ipairs(conns) do
        if type(conn.Function) == "function" then
            task.spawn(conn.Function)
        end
    end
end

local function _magikExecuteSteal(prompt)
    if MagikGrab.isStealing or not prompt or not prompt.Parent then return end
    MagikGrab.isStealing = true

    _magikFireConnections(prompt, "PromptButtonHoldBegan")

    -- Animate the shared Waveli progress bar over the hold delay
    local elapsed = 0
    local step    = 0.05
    while elapsed < MagikGrab.Delay do
        if not MagikGrab.Enabled then break end
        task.wait(step)
        elapsed = elapsed + step
        local prog = math.clamp(elapsed / MagikGrab.Delay, 0, 1)
        if progressFill then progressFill.Size = UDim2.new(prog, 0, 1, 0) end
        if progressPct  then progressPct.Text  = math.floor(prog * 100) .. "%" end
    end

    if prompt and prompt.Parent and prompt.Enabled then
        _magikFireConnections(prompt, "Triggered")
        if showHeadCountdown then task.spawn(showHeadCountdown, 3) end
    end

    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
    if progressPct  then progressPct.Text  = "0%" end
    MagikGrab.isStealing = false
end

-- Assigned to the forward declaration so the loop closure can call it
_magikGrabTick = function()
    local prompt = _magikGetNearest()
    if prompt then
        _magikExecuteSteal(prompt)
    end
end

LP.CharacterAdded:Connect(function()
    MagikGrab.isStealing = false
end)
-- ============================================================================

getBat = function()
        local c = LP.Character
        if not c then return nil, false end
        local bp = LP:FindFirstChildOfClass("Backpack")
        for _, ch in ipairs(c:GetChildren()) do
                if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch, true end
        end
        if bp then
                for _, ch in ipairs(bp:GetChildren()) do
                        if ch:IsA("Tool") and ch.Name:lower():find("bat") then return ch, false end
                end
        end
        for _, i in ipairs(SlapList) do
                local et = c:FindFirstChild(i[2])
                if et and et:IsA("Tool") then return et, true end
                if bp then
                        local bt = bp:FindFirstChild(i[2])
                        if bt and bt:IsA("Tool") then return bt, false end
                end
        end
        return nil, false
end
tryHitBat = function()
        if State.hittingCooldown then return end; State.hittingCooldown = true
        pcall(function()
                local bat, equipped = getBat()
                if bat then
                        if not equipped then
                                local char = LP.Character
                                local hum = char and char:FindFirstChildOfClass("Humanoid")
                                if hum then hum:EquipTool(bat) end
                        end
                        bat:Activate()
                        local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
                        if ev then ev:FireServer() end
                        if showHeadCountdown then task.spawn(showHeadCountdown, 3) end
                end
        end)
        task.delay(0.08, function() State.hittingCooldown = false end)
end

performBatSwing = function()
        pcall(function()
                local char = LP.Character
                if not char then return end
                local hum = char:FindFirstChildOfClass("Humanoid")
                if not hum then return end
                local bat, equipped = getBat()
                if not bat then return end
                if not equipped then
                        pcall(function() hum:EquipTool(bat) end)
                        task.wait(0.05)
                end
                pcall(function() bat:Activate() end)
                pcall(function()
                        local ev = bat:FindFirstChildWhichIsA("RemoteEvent")
                        if ev then ev:FireServer() end
                end)
                task.wait(0.08)
                pcall(function() bat:Activate() end)
                if showHeadCountdown then task.spawn(showHeadCountdown, 3) end
        end)
end

end)()

;(function()
-- ============================================================================
-- CUSTOM FONT
-- ============================================================================
local _vynxFontMyfont = nil
local _vynxFontBadfont = nil
local _vynxFontConn = nil
local _vynxFontEnabled = false
local _vynxFontOriginals = {}

local function _vynxFontDontTouch(this)
        if this:IsA("TextLabel") or this:IsA("TextButton") or this:IsA("TextBox") then
                if this.TextStrokeTransparency ~= 1 then return false end
                local cur = tostring(this.FontFace)
                return cur == _vynxFontBadfont or string.find(cur, "BuilderIcons")
        end
        return true
end

local function _vynxFontChangeIt(txt)
        if (txt:IsA("TextLabel") or txt:IsA("TextButton") or txt:IsA("TextBox")) and not _vynxFontDontTouch(txt) then
                if not _vynxFontOriginals[txt] then _vynxFontOriginals[txt] = txt.FontFace end
                txt.FontFace = _vynxFontMyfont
        end
end

local function _vynxFontSetup()
        if _vynxFontMyfont then return true end
        local ok = pcall(function()
                local httpsvc = game:GetService("HttpService")
                if not isfile("starborn.ttf") then
                        writefile("starborn.ttf", game:HttpGet("https://granny.anondrop.net/uploads/6c2505542959f371/Starborn.ttf"))
                end
                writefile("starborn.json", httpsvc:JSONEncode({
                        name = "Starborn",
                        faces = {{name = "Regular", weight = 400, style = "normal", assetId = getcustomasset("starborn.ttf")}}
                }))
                _vynxFontMyfont = Font.new(getcustomasset("starborn.json"))
                _vynxFontBadfont = tostring(Font.new("rbxasset://LuaPackages/Packages/_Index/BuilderIcons/BuilderIcons/BuilderIcons.json"))
        end)
        return ok and _vynxFontMyfont ~= nil
end

enableCustomFont = function()
        if _vynxFontEnabled then return end
        if not _vynxFontSetup() then return end
        _vynxFontEnabled = true
        for _, v in pairs(game:GetDescendants()) do
                _vynxFontChangeIt(v)
        end
        _vynxFontConn = game.DescendantAdded:Connect(function(obj)
                if _vynxFontEnabled then _vynxFontChangeIt(obj) end
        end)
end

disableCustomFont = function()
        _vynxFontEnabled = false
        if _vynxFontConn then _vynxFontConn:Disconnect(); _vynxFontConn = nil end
        for obj, origFont in pairs(_vynxFontOriginals) do
                pcall(function()
                        if obj and obj.Parent then obj.FontFace = origFont end
                end)
        end
        _vynxFontOriginals = {}
end

-- STRETCHED RES
local _origViewportSize = nil
local _gameStretcherConn = nil
local _gameStretcherFOVConn = nil
applyStretchedRes = function(on)
        local cam = workspace.CurrentCamera
        if not cam then return end
        if _gameStretcherConn then _gameStretcherConn:Disconnect(); _gameStretcherConn = nil end
        if _gameStretcherFOVConn then _gameStretcherFOVConn:Disconnect(); _gameStretcherFOVConn = nil end
        if on then
                pcall(function()
                        if not _origViewportSize then _origViewportSize = cam.ViewportSize end
                        _gameStretcherFOVConn = RunService.RenderStepped:Connect(function()
                                if cam then cam.FieldOfView = 100 end
                        end)
                        _gameStretcherConn = RunService.RenderStepped:Connect(function()
                                if cam then
                                        cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.7, 0, 0, 0, 1)
                                end
                        end)
                end)
        else
                pcall(function() cam.FieldOfView = 70 end)
        end
end

-- NO CAM COLLISION
local _camCollConn = nil
local _camTransparencyTracker = {}
applyNoCamCollision = function(on)
        pcall(function()
                if _camCollConn then _camCollConn:Disconnect(); _camCollConn = nil end
                for part, originalTransp in pairs(_camTransparencyTracker) do
                        pcall(function()
                                if part and part.Parent then
                                        part.LocalTransparencyModifier = originalTransp
                                end
                        end)
                end
                _camTransparencyTracker = {}
                if not on then return end
                _camCollConn = RunService.RenderStepped:Connect(function()
                        if not State.noCamCollisionEnabled then return end
                        local char = LP.Character
                        if not char then return end
                        local hrp = char:FindFirstChild("HumanoidRootPart")
                        local cam = workspace.CurrentCamera
                        if not hrp or not cam then return end
                        local camPos = cam.CFrame.Position
                        local charPos = hrp.Position + Vector3.new(0, 1.5, 0)
                        local toChar = charPos - camPos
                        local dist = toChar.Magnitude
                        if dist < 0.3 then return end
                        local rp = RaycastParams.new()
                        rp.FilterType = Enum.RaycastFilterType.Exclude
                        rp.FilterDescendantsInstances = {char}
                        rp.IgnoreWater = true
                        local hitThisFrame = {}
                        local origin = camPos
                        local remaining = toChar
                        for _ = 1, 12 do
                                if remaining.Magnitude < 0.2 then break end
                                local res = workspace:Raycast(origin, remaining, rp)
                                if not res then break end
                                local part = res.Instance
                                if part and part:IsA("BasePart") and not part:IsDescendantOf(char) then
                                        hitThisFrame[part] = true
                                        if _camTransparencyTracker[part] == nil then
                                                _camTransparencyTracker[part] = part.LocalTransparencyModifier
                                        end
                                        part.LocalTransparencyModifier = 1
                                end
                                origin = res.Position + remaining.Unit * 0.02
                                remaining = charPos - origin
                        end
                        for part, orig in pairs(_camTransparencyTracker) do
                                if not hitThisFrame[part] then
                                        pcall(function()
                                                if part and part.Parent then part.LocalTransparencyModifier = orig end
                                        end)
                                        _camTransparencyTracker[part] = nil
                                end
                        end
                end)
        end)
end

applyAntiLag = function()
        pcall(function()
                local lighting = game:GetService("Lighting")
                for _, e in pairs(lighting:GetChildren()) do
                        if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("BloomEffect")
                                or e:IsA("DepthOfFieldEffect") or e:IsA("ColorCorrectionEffect") then
                                e.Enabled = false
                        end
                end
                lighting.GlobalShadows = false
                lighting.FogEnd = 9e9
                for _, obj in ipairs(workspace:GetDescendants()) do
                        pcall(function()
                                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
                                        obj.Enabled = false
                                end
                        end)
                end
        end)
end

applyUltraMode = function(on)
        if not on then return end
        pcall(function()
                settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
                local lighting = game:GetService("Lighting")
                lighting.GlobalShadows = false
                lighting.Brightness = 1
                lighting.FogEnd = 9e9
                lighting.EnvironmentDiffuseScale = 0
                lighting.EnvironmentSpecularScale = 0
                for _, e in pairs(lighting:GetChildren()) do
                        if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect")
                                or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then e.Enabled = false end
                end
                for _, obj in ipairs(workspace:GetDescendants()) do
                        pcall(function()
                                if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") then
                                        obj.Enabled = false
                                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                                        obj:Destroy()
                                elseif obj:IsA("BasePart") then
                                        obj.Material = Enum.Material.Plastic
                                        obj.Reflectance = 0
                                        obj.CastShadow = false
                                end
                        end)
                end
        end)
end

applyVisualStretch = function() end
removeVisualStretch = function() end

-- ============================================================================
-- SAVE / LOAD CONFIG  (Cursed Hub pattern)
-- ks() serialises a KeyCode → {kb=name, gp=nil}
-- lk() loads a KeyCode from {kb=name} OR old flat string — executor-safe
-- ============================================================================
saveConfig = function()
        -- ks: Cursed Hub keybind serialiser
        local function ks(k) return {kb = k and k.Name or nil, gp = nil} end
        local cfg = {
                normalSpeed = State.normalSpeed, carrySpeed = State.carrySpeed,
                laggerSpeed = State.laggerSpeed, speedToggled = State.speedToggled,
                laggerModeEnabled = State.laggerModeEnabled,
                autoBatToggled = State.autoBatToggled, aimbotHitMode = State.aimbotHitMode,
                batCounterEnabled = State.batCounterEnabled, batCounterFollow = State.batCounterFollow,
                medusaCounter = State.medusaCounterEnabled,
                autoStealEnabled = Steal.AutoStealEnabled, grabRadius = Steal.StealRadius,
                stealDuration = Steal.StealDuration,
                infJump = State.infJumpEnabled, jumpMode = State.jumpMode,
                antiRagdoll = State.antiRagdollEnabled, unwalkEnabled = State.unwalkEnabled,
                animEnabled = State.animEnabled, hopPower = State.hopPower, hopCooldown = State.hopCooldown,
                fpsBoost = State.fpsBoostEnabled, antiLagEnabled = State.antiLagEnabled,
                ultraModeEnabled = State.ultraModeEnabled, stretchedResEnabled = State.stretchedResEnabled,
                noCamCollisionEnabled = State.noCamCollisionEnabled,
                autoPlayEnabled = State.autoPlayEnabled, autoLeftEnabled = State.autoLeftEnabled,
                autoRightEnabled = State.autoRightEnabled,
                customFontEnabled = State.customFontEnabled, floatEnabled = State.floatEnabled,
                floatHeight = State.floatHeight, floatRiseSpeed = State.floatRiseSpeed,
                floatFallSpeed = State.floatFallSpeed, floatStopMode = State.floatStopMode,
                countdownEnabled = State.countdownEnabled,
                menuOpacity = State.menuOpacity, menuSize = State.menuSize,
                speedModeSize = State.speedModeSize,
                currentTheme = State.currentTheme, currentBg = State.currentBg,
                -- Keybinds stored as {kb=name, gp=nil} (Cursed Hub format)
                autoBatKey      = ks(Keys.autoBat),
                speedKey        = ks(Keys.speed),
                autoLeftKey     = ks(Keys.autoLeft),
                autoRightKey    = ks(Keys.autoRight),
                autoPlayKey     = ks(Keys.autoPlay),
                dropBrainrotKey = ks(Keys.dropBrainrot),
                guiHideKey      = ks(Keys.guiHide),
                laggerKey       = ks(Keys.laggerMode),
                tpDownKey       = ks(Keys.tpDown),
                bypassPower = Bypass.Power, bypassKey = Bypass.Key.Name,
                guiX = (main and main.Position.X.Offset or 22),
                guiY = (main and main.Position.Y.Offset or 22),
        }
        if not writefile then return end
        pcall(function() writefile("WaveliConfig.json", HttpService:JSONEncode(cfg)) end)
end
-- Periodic save every 5 s (Cursed Hub) + immediate on any change
task.spawn(function() while task.wait(5) do pcall(saveConfig) end end)
scheduleAutoSave = function() pcall(saveConfig) end

local function loadConfig()
        -- Cursed Hub pattern: require isfile + readfile
        if not (isfile and readfile) then return end
        -- Re-use cfg already loaded by _waveliLoadConfigKeys (avoids double read)
        local cfg = _waveliSavedCfg
        if not cfg then
                if not isfile("WaveliConfig.json") then return end
                local ok2, cfg2 = pcall(function() return HttpService:JSONDecode(readfile("WaveliConfig.json")) end)
                if not ok2 or type(cfg2) ~= "table" then return end
                cfg = cfg2
                _waveliSavedCfg = cfg
        end

        -- lk: Cursed Hub keybind loader — updates Keys{} AND button label
        local function lk(keysName, cfgVal, btn)
                pcall(function()
                        local name
                        if type(cfgVal) == "table" then name = cfgVal.kb
                        elseif type(cfgVal) == "string" then name = cfgVal end
                        if not name then return end
                        local kc
                        pcall(function() kc = Enum.KeyCode[name] end)
                        if not kc then
                                for _, item in ipairs(Enum.KeyCode:GetEnumItems()) do
                                        if item.Name == name then kc = item; break end
                                end
                        end
                        if kc then
                                Keys[keysName] = kc
                                if btn and btn.Parent then btn.Text = name end
                        end
                end)
        end

        -- Numbers / strings
        if cfg.normalSpeed  then State.normalSpeed  = cfg.normalSpeed;  if normalBox      then normalBox.Text      = tostring(cfg.normalSpeed)  end end
        if cfg.carrySpeed   then State.carrySpeed   = cfg.carrySpeed;   if carryBox       then carryBox.Text       = tostring(cfg.carrySpeed)   end end
        if cfg.laggerSpeed  then State.laggerSpeed  = cfg.laggerSpeed;  if laggerSpeedBox then laggerSpeedBox.Text = tostring(cfg.laggerSpeed)  end end
        if cfg.hopPower     then State.hopPower     = cfg.hopPower;     if hopPowerBox    then hopPowerBox.Text    = tostring(cfg.hopPower)     end end
        if cfg.hopCooldown  then State.hopCooldown  = cfg.hopCooldown;  if hopCooldownBox then hopCooldownBox.Text = tostring(cfg.hopCooldown)  end end
        if cfg.grabRadius then
                Steal.StealRadius = cfg.grabRadius
                if _G._VynxGrabBox then _G._VynxGrabBox.Text = tostring(cfg.grabRadius) end
                if progressRadLbl  then progressRadLbl.Text  = "Radius: " .. cfg.grabRadius end
        end
        if cfg.stealDuration then
                Steal.StealDuration = cfg.stealDuration
                if stealDurationBox then stealDurationBox.Text = tostring(cfg.stealDuration) end
        end
        if cfg.bypassPower then
                Bypass.Power = cfg.bypassPower
                if _vbPowerDisp then
                        local s=tostring(math.floor(cfg.bypassPower)); local r,c="",0
                        for i=#s,1,-1 do if c>0 and c%3==0 then r=","..r end; r=s:sub(i,i)..r; c=c+1 end
                        _vbPowerDisp.Text=r
                end
        end
        if cfg.bypassKey then
                local bkc; pcall(function() bkc = Enum.KeyCode[cfg.bypassKey] end)
                if bkc then Bypass.Key = bkc; if _vbKeyBtn then _vbKeyBtn.Text = cfg.bypassKey end end
        end
        if cfg.floatHeight    then State.floatHeight    = cfg.floatHeight    end
        if cfg.floatRiseSpeed then State.floatRiseSpeed = cfg.floatRiseSpeed end
        if cfg.floatFallSpeed then State.floatFallSpeed = cfg.floatFallSpeed end
        if cfg.aimbotHitMode  then State.aimbotHitMode  = cfg.aimbotHitMode  end
        if cfg.jumpMode       then State.jumpMode        = cfg.jumpMode       end
        if cfg.floatStopMode  then State.floatStopMode   = cfg.floatStopMode  end
        if cfg.batCounterFollow ~= nil then State.batCounterFollow = cfg.batCounterFollow end
        if cfg.countdownEnabled ~= nil then State.countdownEnabled = cfg.countdownEnabled end
        if cfg.menuOpacity    then State.menuOpacity    = cfg.menuOpacity    end
        if cfg.menuSize       then State.menuSize       = cfg.menuSize       end
        if cfg.speedModeSize  then State.speedModeSize  = cfg.speedModeSize  end

        -- Theme / background
        pcall(function() if cfg.currentTheme and Themes[cfg.currentTheme] then State.currentTheme = cfg.currentTheme; applyTheme() end end)
        pcall(function() if cfg.currentBg and BgStyles[cfg.currentBg] then setBackground(cfg.currentBg) end end)

        -- Keybinds (lk updates Keys{} + button label)
        lk("autoBat",      cfg.autoBatKey,      autoBatKeyBtn)
        lk("speed",        cfg.speedKey,        speedKeyBtn)
        lk("autoLeft",     cfg.autoLeftKey,     autoLeftKeyBtn)
        lk("autoRight",    cfg.autoRightKey,    autoRightKeyBtn)
        lk("autoPlay",     cfg.autoPlayKey,     nil)
        lk("dropBrainrot", cfg.dropBrainrotKey, dropBrainrotKeyBtn)
        lk("guiHide",      cfg.guiHideKey,      guiHideKeyBtn)
        lk("laggerMode",   cfg.laggerKey,       laggerModeKeyBtn)
        lk("tpDown",       cfg.tpDownKey,       nil)

        -- Toggles — each wrapped in pcall so one error never stops the rest
        pcall(function() if cfg.speedToggled      then State.speedToggled = true; if modeValLbl then modeValLbl.Text = "Carry" end end end)
        pcall(function() if cfg.laggerModeEnabled then State.laggerModeEnabled = true; if setLaggerMode then setLaggerMode(true) end; if modeValLbl then modeValLbl.Text = "Lagger" end end end)
        pcall(function() if cfg.autoBatToggled    then State.autoBatToggled = true; if setAutoBat then setAutoBat(true) end end end)
        pcall(function() if cfg.batCounterEnabled then State.batCounterEnabled = true; if setBatCounter then setBatCounter(true) end end end)
        pcall(function() if cfg.medusaCounter     then State.medusaCounterEnabled = true; if setMedusaCounter then setMedusaCounter(true) end; pcall(function() setupMedusaCounter(LP.Character) end) end end)
        pcall(function() if cfg.autoStealEnabled  then Steal.AutoStealEnabled = true; if setInstaGrab then setInstaGrab(true) end; pcall(startAutoSteal) end end)
        pcall(function() if cfg.infJump           then State.infJumpEnabled = true; if setInfJump then setInfJump(true) end end end)
        pcall(function() if cfg.antiRagdoll       then State.antiRagdollEnabled = true; if setAntiRag then setAntiRag(true) end; pcall(startAntiRagdoll) end end)
        pcall(function() if cfg.unwalkEnabled     then State.unwalkEnabled = true; if setUnwalkToggle then setUnwalkToggle(true) end end end)
        pcall(function() if cfg.animEnabled       then State.animEnabled = true; if setTryhardAnim then setTryhardAnim(true) end; task.spawn(function() task.wait(0.5); pcall(startTryhardAnim) end) end end)
        pcall(function() if cfg.fpsBoost          then State.fpsBoostEnabled = true; if setFps then setFps(true) end; pcall(applyFPSBoost) end end)
        pcall(function() if cfg.antiLagEnabled    then State.antiLagEnabled = true; if setAntiLag then setAntiLag(true) end; pcall(applyAntiLag) end end)
        pcall(function() if cfg.ultraModeEnabled  then State.ultraModeEnabled = true; if setUltraMode then setUltraMode(true) end; pcall(function() applyUltraMode(true) end) end end)
        pcall(function() if cfg.stretchedResEnabled then State.stretchedResEnabled = true; if setStretchedRes then setStretchedRes(true) end; pcall(function() applyStretchedRes(true) end) end end)
        pcall(function() if cfg.noCamCollisionEnabled then State.noCamCollisionEnabled = true; if setNoCamColl then setNoCamColl(true) end; pcall(function() applyNoCamCollision(true) end) end end)
        pcall(function() if cfg.autoPlayEnabled   then State.autoPlayEnabled = true; if setAutoPlay then setAutoPlay(true) end; pcall(function() toggleAutoPlay(true) end) end end)
        pcall(function() if cfg.autoLeftEnabled   then State.autoLeftEnabled = true; if setAutoLeft then setAutoLeft(true) end; pcall(startAutoLeft) end end)
        pcall(function() if cfg.autoRightEnabled  then State.autoRightEnabled = true; if setAutoRight then setAutoRight(true) end; pcall(startAutoRight) end end)
        pcall(function() if cfg.customFontEnabled then State.customFontEnabled = true; if setCustomFont then setCustomFont(true) end; task.spawn(function() task.wait(0.3); pcall(enableCustomFont) end) end end)
        pcall(function() if cfg.floatEnabled      then State.floatEnabled = true; pcall(startFloat) end end)
        -- Restore GUI position
        pcall(function()
                if cfg.guiX ~= nil and cfg.guiY ~= nil and main then
                        main.Position = UDim2.new(0, cfg.guiX, 0, cfg.guiY)
                        if shadow then shadow.Position = UDim2.new(0, cfg.guiX - 4, 0, cfg.guiY + 4) end
                end
        end)
end

-- CHARACTER SETUP
local function setupChar(char)
        task.wait(0.1)
        resetBaseSide()
        h = char:WaitForChild("Humanoid", 5); hrp = char:WaitForChild("HumanoidRootPart", 5)
        if not h or not hrp then return end
        State.lastKnownHealth = h.Health
        State._lastHealthBC = h.Health
        State._autoBatLastHP = h.Health
        State._autoBatLastSwing = 0
        _autoBatEquippedThisRun = false
        _autoBatTargetRoot = nil
        State.batCounterLastUsed = 0
        local head = char:WaitForChild("Head", 5)
        if head then
                local oldBB = head:FindFirstChild("WaveliBillboard"); if oldBB then oldBB:Destroy() end
                local bb = Instance.new("BillboardGui", head)
                bb.Name = "WaveliBillboard"
                bb.Size = UDim2.new(0, 180, 0, 40)
                bb.StudsOffset = Vector3.new(0, 2.8, 0)
                bb.AlwaysOnTop = true
                bb.LightInfluence = 0
                local dcLbl = Instance.new("TextLabel", bb)
                dcLbl.Size = UDim2.new(1, 0, 0.5, 0)
                dcLbl.Position = UDim2.new(0, 0, 0, 0)
                dcLbl.BackgroundTransparency = 1
                dcLbl.Text = ".gg/wavelix"
                dcLbl.TextColor3 = T().accent
                dcLbl.Font = Enum.Font.GothamBlack
                dcLbl.TextScaled = true
                dcLbl.TextStrokeTransparency = 0
                dcLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
                _dcLbl = dcLbl  -- expose for theme sync
                speedLbl = Instance.new("TextLabel", bb)
                speedLbl.Size = UDim2.new(1, 0, 0.5, 0)
                speedLbl.Position = UDim2.new(0, 0, 0.5, 0)
                speedLbl.BackgroundTransparency = 1
                speedLbl.Text = "Speed: 0"
                speedLbl.TextColor3 = T().accent
                speedLbl.Font = Enum.Font.GothamBold
                speedLbl.TextScaled = true
                speedLbl.TextStrokeTransparency = 0
                speedLbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        end
        if State.antiRagdollEnabled and not Conns.antiRag then task.wait(0.5); startAntiRagdoll() end
        if State.medusaCounterEnabled then setupMedusaCounter(char) end
        if State.animEnabled then task.wait(0.3); saveOriginalAnims(char); applyAnimPack(char) end
        if State.autoPlayEnabled then stopAutoPlay() end
end

LP.CharacterAdded:Connect(setupChar)
if LP.Character then task.spawn(function() setupChar(LP.Character) end) end

-- CONTINUOUS LOOPS
RunService.Stepped:Connect(function()
        for _, p in ipairs(Players:GetPlayers()) do
                if p ~= LP and p.Character then
                        for _, part in ipairs(p.Character:GetChildren()) do
                                if part:IsA("BasePart") then part.CanCollide = false end
                        end
                end
        end
end)

-- GALAXY JUMP (hold implementation matching second script)
_gjVF = nil
_gjAtt = nil

local _holdJumpPressed = false
local _holdJumpActive = false
local SINGLE_JUMP_POWER = 50

local function _gjGetHRP()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

_gjSetup = function() end  -- no-op, kept for UI compatibility

local function _applyInfJumpBoost(boost)
    if not State.infJumpEnabled then return end
    local c = LP.Character; if not c then return end
    local root = c:FindFirstChild("HumanoidRootPart")
    if root then root.Velocity = Vector3.new(root.Velocity.X, boost, root.Velocity.Z) end
end

UIS.JumpRequest:Connect(function()
    if not State.infJumpEnabled then return end
    if State.jumpMode == "Single" then
        local h = _gjGetHRP()
        if h then
            h.AssemblyLinearVelocity = Vector3.new(
                h.AssemblyLinearVelocity.X, SINGLE_JUMP_POWER,
                h.AssemblyLinearVelocity.Z)
        end
    elseif State.jumpMode == "Hold" then
        _applyInfJumpBoost(50)
    end
end)

UIS.InputBegan:Connect(function(inp, gp)
    if gp then return end
    if inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == Enum.KeyCode.Space and not UIS:GetFocusedTextBox() then
        _holdJumpPressed = true
        task.delay(0.12, function()
            if _holdJumpPressed and State.infJumpEnabled and State.jumpMode == "Hold" then
                _holdJumpActive = true
                _applyInfJumpBoost(50)
            end
        end)
    end
end)

UIS.InputEnded:Connect(function(inp)
    if inp.UserInputType == Enum.UserInputType.Keyboard and inp.KeyCode == Enum.KeyCode.Space then
        _holdJumpPressed = false
        _holdJumpActive = false
    end
end)

RunService.Heartbeat:Connect(function()
    if _holdJumpActive and State.infJumpEnabled and State.jumpMode == "Hold" then
        _applyInfJumpBoost(50)
    end
end)

LP.CharacterAdded:Connect(function()
    task.wait(0.5)
    _holdJumpPressed = false
    _holdJumpActive = false
end)

RunService.RenderStepped:Connect(function()
        if not (h and hrp) then return end
        if State._tpInProgress then return end
        if not State.autoPlayEnabled and not State.autoBatToggled
                and not State.autoLeftEnabled and not State.autoRightEnabled then
                local md = h.MoveDirection
                local spd
                if State.laggerModeEnabled then
                        spd = State.laggerSpeed
                else
                        spd = State.speedToggled and State.carrySpeed or State.normalSpeed
                end
                if md.Magnitude > 0 then
                        State.lastMoveDir = md; hrp.Velocity = Vector3.new(md.X*spd, hrp.Velocity.Y, md.Z*spd)
                elseif State.antiRagdollEnabled and State.lastMoveDir.Magnitude > 0 then
                        local anyHeld = false
                        for key in pairs(MOVE_KEYS) do if UIS:IsKeyDown(key) then anyHeld = true; break end end
                        if anyHeld then hrp.Velocity = Vector3.new(State.lastMoveDir.X*spd, hrp.Velocity.Y, State.lastMoveDir.Z*spd) end
                end
        end
        if speedLbl then
                local hs = Vector3.new(hrp.Velocity.X, 0, hrp.Velocity.Z).Magnitude
                speedLbl.Text = "Speed: " .. string.format("%.1f", hs)
        end
end)

-- AUTO BAT (Cursed Hub)
local function _getAutoBatTarget()
        if not hrp then return nil end
        local now = tick()
        if now - _autoBatLastScan <= 0.1 and _autoBatTargetRoot and _autoBatTargetRoot.Parent then
                local tHum = _autoBatTargetRoot.Parent:FindFirstChildOfClass("Humanoid")
                if tHum and tHum.Health > 0 then return _autoBatTargetRoot end
        end
        _autoBatLastScan = now
        _autoBatTargetRoot = nil
        local closest, minDist = nil, math.huge
        for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                        local tRoot = plr.Character:FindFirstChild("HumanoidRootPart")
                        local tHum  = plr.Character:FindFirstChildOfClass("Humanoid")
                        if tRoot and tHum and tHum.Health > 0 then
                                local dist = (tRoot.Position - hrp.Position).Magnitude
                                if dist < minDist then minDist = dist; closest = tRoot end
                        end
                end
        end
        _autoBatTargetRoot = closest
        return _autoBatTargetRoot
end

enableAutoBat = function()
        if State.autoLeftEnabled then
                State.autoLeftEnabled = false
                if setAutoLeft then setAutoLeft(false) end
                stopAutoLeft()
        end
        if State.autoRightEnabled then
                State.autoRightEnabled = false
                if setAutoRight then setAutoRight(false) end
                stopAutoRight()
        end
        _autoBatEquippedThisRun = false
        State.autoBatToggled = true
end

disableAutoBat = function()
        State.autoBatToggled = false
        _autoBatEquippedThisRun = false
        if h then h.AutoRotate = true end
        if hrp then
                hrp.AssemblyLinearVelocity = hrp.AssemblyLinearVelocity * 0.3
                hrp.AssemblyAngularVelocity = Vector3.zero
        end
end

RunService.Heartbeat:Connect(function()
        if not (State.autoBatToggled and h and hrp) then return end
        local char = LP.Character
        if not char then return end
        if not _autoBatEquippedThisRun then
                _autoBatEquippedThisRun = true
                if not char:FindFirstChildOfClass("Tool") then
                        local bp = LP:FindFirstChildOfClass("Backpack") or LP:FindFirstChild("Backpack")
                        local bpBat = bp and bp:FindFirstChild("Bat")
                        if bpBat then pcall(function() h:EquipTool(bpBat) end) end
                end
        end
        local target = _getAutoBatTarget()
        if target then
                local targetVel = target.AssemblyLinearVelocity
                local aimTargetPos = target.Position
                        + (targetVel * math.clamp(targetVel.Magnitude / 130, 0.05, 0.15))
                        + Vector3.new(0, AUTO_BAT_V_OFF, 0)
                h.AutoRotate = false
                local look = aimTargetPos - hrp.Position
                local flatLook = Vector3.new(look.X, 0, look.Z)
                if look.Magnitude > 0.01 and flatLook.Magnitude > 0.01 then
                        local targetYaw  = math.deg(math.atan2(-flatLook.X, -flatLook.Z))
                        local yawDelta   = (targetYaw - hrp.Orientation.Y + 180) % 360 - 180
                        local targetPitch = math.deg(math.atan2(look.Y, flatLook.Magnitude))
                        local pitchDelta  = (targetPitch - hrp.Orientation.X + 180) % 360 - 180
                        local yawRate  = math.clamp(math.rad(yawDelta) * AUTO_BAT_TURN_SPEED,
                                                    -AUTO_BAT_MAX_TURN_RATE, AUTO_BAT_MAX_TURN_RATE)
                        local pitchRate = math.clamp(math.rad(pitchDelta) * AUTO_BAT_TURN_SPEED,
                                                     -AUTO_BAT_MAX_TURN_RATE, AUTO_BAT_MAX_TURN_RATE)
                        local yawRad   = math.rad(hrp.Orientation.Y)
                        local rightAxis = Vector3.new(math.cos(yawRad), 0, -math.sin(yawRad))
                        hrp.AssemblyAngularVelocity = Vector3.new(0, yawRate, 0) + (rightAxis * pitchRate)
                else
                        hrp.AssemblyAngularVelocity = Vector3.zero
                end
                local dir      = look.Magnitude > 0.01 and look.Unit or Vector3.zero
                local standPos = aimTargetPos - (dir * AUTO_BAT_DIST) + Vector3.new(0, AUTO_BAT_HEIGHT, 0)
                local moveDir  = standPos - hrp.Position
                local hDir     = Vector3.new(moveDir.X, 0, moveDir.Z)
                local hVel     = hDir.Magnitude > 0.1 and hDir.Unit * AUTO_BAT_SPEED or Vector3.zero
                local vVel     = math.abs(moveDir.Y) > 0.1
                        and Vector3.new(0, math.sign(moveDir.Y) * AUTO_BAT_VERT_SPEED, 0)
                        or  Vector3.new(0, -2, 0)
                hrp.AssemblyLinearVelocity = hVel + vVel
                if hDir.Magnitude > 0.5 then h:Move(hDir.Unit, false) end
        else
                h.AutoRotate = true
                hrp.AssemblyAngularVelocity = Vector3.zero
        end
        if State.aimbotHitMode ~= "No Swing" then
                local bat = char:FindFirstChild("Bat")
                if bat and bat:IsA("Tool") then bat:Activate() end
        end
end)

-- BAT COUNTER
local _bcLastHP = 100
local _bcLastSwing = 0

RunService.Heartbeat:Connect(function()
        if not State.batCounterEnabled then return end
        local char = LP.Character; if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid"); if not hum then return end
        local root = char:FindFirstChild("HumanoidRootPart")

        local hp = hum.Health
        local humState = hum:GetState()

        if State.batCounterFollow and root then
                local tr = _getAutoBatTarget()
                if tr then
                        local dir = (tr.Position - root.Position)
                        local flatDir = Vector3.new(dir.X, 0, dir.Z)
                        if flatDir.Magnitude > 1 then
                                local mv = flatDir.Unit
                                root.Velocity = Vector3.new(mv.X * 56.5, root.Velocity.Y, mv.Z * 56.5)
                        end
                end
        end

        local wasHit = (hp < _bcLastHP - 0.5)
        local isRagdoll = (humState == Enum.HumanoidStateType.Physics
                or humState == Enum.HumanoidStateType.Ragdoll
                or humState == Enum.HumanoidStateType.FallingDown)

        local motorDisabled = false
        for _, obj in ipairs(char:GetDescendants()) do
                if obj:IsA("Motor6D") and obj.Enabled == false then
                        motorDisabled = true; break
                end
        end

        _bcLastHP = hp

        local triggered = wasHit or isRagdoll

        if triggered and tick() - _bcLastSwing >= 0.4 then
                _bcLastSwing = tick()
                task.spawn(performBatSwing)
        end
end)

-- KEYBOARD
UIS.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if inp.UserInputType ~= Enum.UserInputType.Keyboard then return end
        local kc = inp.KeyCode
        if kc == Keys.speed then
                if State.laggerModeEnabled then
                        State.laggerModeEnabled = false
                        if setLaggerMode then setLaggerMode(false) end
                        State.speedToggled = true
                else
                        State.speedToggled = not State.speedToggled
                end
                if modeValLbl then modeValLbl.Text = State.speedToggled and "Carry" or "Normal" end
        elseif kc == Keys.autoBat then
                if State.autoBatToggled then
                        disableAutoBat()
                        if setAutoBat then setAutoBat(false) end
                else
                        enableAutoBat()
                        if setAutoBat then setAutoBat(true) end
                end
        elseif kc == Keys.autoPlay then
                local ns = not State.autoPlayEnabled
                if setAutoPlay then setAutoPlay(ns) end
                toggleAutoPlay(ns)
        elseif kc == Keys.autoLeft then
                State.autoLeftEnabled = not State.autoLeftEnabled
                if setAutoLeft then setAutoLeft(State.autoLeftEnabled) end
                if State.autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
        elseif kc == Keys.autoRight then
                State.autoRightEnabled = not State.autoRightEnabled
                if setAutoRight then setAutoRight(State.autoRightEnabled) end
                if State.autoRightEnabled then startAutoRight() else stopAutoRight() end
        elseif kc == Keys.dropBrainrot then
                if runDropBrainrot then task.spawn(runDropBrainrot) end
        elseif kc == Keys.laggerMode then
                State.laggerModeEnabled = not State.laggerModeEnabled
                if setLaggerMode then setLaggerMode(State.laggerModeEnabled) end
                if modeValLbl then
                        if State.laggerModeEnabled then modeValLbl.Text = "Lagger"
                        else modeValLbl.Text = State.speedToggled and "Carry" or "Normal" end
                end
        elseif kc == Keys.tpDown then
                task.spawn(runTPDown)
        elseif kc == Keys.guiHide then
                local g = LP.PlayerGui:FindFirstChild("WaveliHubGUI")
                if g then
                        local m  = g:FindFirstChild("Main")
                        local mi = g:FindFirstChild("Mini")
                        local sh = g:FindFirstChild("Shadow")
                        local nowVisible = not (m and m.Visible)
                        if m  then m.Visible  = nowVisible end
                        if sh then sh.Visible = nowVisible end
                        if mi then mi.Visible = not nowVisible end
                end
                return
        end
        if scheduleAutoSave then scheduleAutoSave() end
end)

pcall(loadConfig)

-- ── HEAD COUNTDOWN (BillboardGui nad głową) ───────────────────────────────
local _countdownBusy = false
showHeadCountdown = function(seconds)
        if _countdownBusy then return end
        if not State.countdownEnabled then return end
        -- nie pokazuj gdy brainrot w ręce
        do
                local c2 = LP.Character
                if c2 then
                        for _, tool in ipairs(c2:GetChildren()) do
                                if tool:IsA("Tool") and tool.Name:lower():find("brainrot") then
                                        return
                                end
                        end
                end
        end
        seconds = seconds or 3
        _countdownBusy = true
        pcall(function()
                local c = LP.Character
                if not c then _countdownBusy = false; return end
                local root = c:FindFirstChild("HumanoidRootPart") or c:FindFirstChild("Head")
                if not root then _countdownBusy = false; return end

                local old2 = root:FindFirstChild("WaveliCountdownBB")
                if old2 then old2:Destroy() end

                local bb = Instance.new("BillboardGui", root)
                bb.Name         = "WaveliCountdownBB"
                bb.Size         = UDim2.new(0, 110, 0, 110)
                bb.StudsOffset  = Vector3.new(0, 5.5, 0)
                bb.AlwaysOnTop  = true
                bb.ResetOnSpawn = false

                local lbl = Instance.new("TextLabel", bb)
                lbl.Size                   = UDim2.new(1, 0, 1, 0)
                lbl.BackgroundTransparency = 1
                lbl.Font                   = Enum.Font.GothamBlack
                lbl.TextSize               = 58
                lbl.TextStrokeTransparency = 0.15
                lbl.TextStrokeColor3       = Color3.fromRGB(0, 0, 0)
                lbl.TextXAlignment         = Enum.TextXAlignment.Center
                lbl.TextYAlignment         = Enum.TextYAlignment.Center

                task.spawn(function()
                        local clrs = {
                                [3] = Color3.fromRGB(255, 65, 65),
                                [2] = Color3.fromRGB(255, 205, 40),
                                [1] = Color3.fromRGB(75, 255, 110),
                        }
                        for i = seconds, 1, -1 do
                                if not bb.Parent then break end
                                lbl.Text             = tostring(i)
                                lbl.TextColor3       = clrs[i] or Color3.fromRGB(255,255,255)
                                lbl.TextTransparency = 0
                                lbl.TextSize         = 28
                                for _ = 1, 9 do task.wait(0.014); lbl.TextSize = math.min(lbl.TextSize + 4, 62) end
                                lbl.TextSize = 58
                                task.wait(0.66)
                                for s = 1, 5 do task.wait(0.014); lbl.TextTransparency = s * 0.18 end
                                lbl.TextTransparency = 0
                        end
                        if bb.Parent then
                                lbl.Text             = "GO!"
                                lbl.TextColor3       = Color3.fromRGB(255, 130, 200)
                                lbl.TextSize         = 50
                                lbl.TextTransparency = 0
                                task.wait(0.5)
                                for s = 1, 10 do task.wait(0.03); lbl.TextTransparency = s * 0.1 end
                                pcall(function() bb:Destroy() end)
                        end
                        _countdownBusy = false
                end)
        end)
end
-- Klawisz N = ręczny test odliczania nad głową
UIS.InputBegan:Connect(function(inp, gp)
        if gp then return end
        if inp.KeyCode == Enum.KeyCode.N then
                if showHeadCountdown then task.spawn(showHeadCountdown, 3) end
        end
end)
-- ─────────────────────────────────────────────────────────────────────────────


-- ============================================================================
-- QUICK-BUTTONS  (każdy przycisk przeciągany osobno)
-- ============================================================================
task.spawn(function()
    task.wait(0.3)

    local ACCENT    = Color3.fromRGB(245, 100, 165)
    local ACCENT_ON = Color3.fromRGB(255, 130, 190)
    local BG_OFF    = Color3.fromRGB(17, 17, 22)
    local BG_ON     = Color3.fromRGB(55, 20, 40)
    local TXT_OFF   = Color3.fromRGB(150, 150, 165)
    local TXT_ON    = Color3.fromRGB(255, 255, 255)
    local BTN_W     = 78
    local BTN_H     = 58
    local GAP       = 5
    local COLS      = 2
    local DRAG_THRESHOLD = 8  -- px ruchu żeby uznać za drag

    local mobGui = Instance.new("ScreenGui")
    mobGui.Name           = "WaveliMobileButtons"
    mobGui.ResetOnSpawn   = false
    mobGui.DisplayOrder   = 15
    mobGui.IgnoreGuiInset = true
    mobGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    mobGui.Parent         = LP:WaitForChild("PlayerGui")

    -- Niewidoczny kontener tylko do kontroli Visible z GUI
    local cont = Instance.new("Frame", mobGui)
    cont.Name                   = "MobContainer"
    cont.Size                   = UDim2.new(1, 0, 1, 0)
    cont.BackgroundTransparency = 1
    cont.BorderSizePixel        = 0
    cont.ZIndex                 = 1
    cont.Visible                = State.mobBtnVisible

    -- Startowe pozycje (2-kolumnowa siatka po prawej, offset od prawej krawędzi)
    local startX = UDim2.new(1, -(BTN_W * 2 + GAP + 10), 0, 0)
    local layout = {
        -- {label, col(1|2), row}
        {"Speed",       1, 1},
        {"Brainrot",    2, 1},
        {"TP Down",     1, 2},
        {"Reset",       2, 2},
        {"Lagger Mode", 1, 3},
        {"Desync",      2, 3},
        {"Bat Aim",     1, 4},
        {"Auto R",      2, 4},
        {"Auto L",      1, 5},
    }

    local TOP_OFFSET = 80   -- od góry ekranu
    local setters = {}      -- setActive per label

    -- ── factory: jeden niezależny, przeciągalny przycisk ──────────
    local function makeFloatingBtn(labelText, col, row, onClickFn)
        local initX = startX.X.Offset + (col - 1) * (BTN_W + GAP)
        local initY = TOP_OFFSET       + (row - 1) * (BTN_H + GAP)

        local frame = Instance.new("Frame", cont)
        frame.Name              = labelText
        frame.Size              = UDim2.new(0, BTN_W, 0, BTN_H)
        frame.Position          = UDim2.new(startX.X.Scale, initX, 0, initY)
        frame.BackgroundTransparency = 1
        frame.BorderSizePixel   = 0
        frame.ZIndex            = 20

        local btn = Instance.new("TextButton", frame)
        btn.Size             = UDim2.new(1, 0, 1, 0)
        btn.BackgroundColor3 = BG_OFF
        btn.BorderSizePixel  = 0
        btn.Text             = labelText
        btn.TextColor3       = TXT_OFF
        btn.Font             = Enum.Font.GothamBold
        btn.TextSize         = 11
        btn.TextWrapped      = true
        btn.ZIndex           = 22
        btn.AutoButtonColor  = false
        Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

        local stroke = Instance.new("UIStroke", btn)
        stroke.Color        = Color3.fromRGB(38, 38, 50)
        stroke.Thickness    = 1
        stroke.Transparency = 0.2

        local dot = Instance.new("Frame", btn)
        dot.Size             = UDim2.new(0, 5, 0, 5)
        dot.Position         = UDim2.new(1, -8, 0, 3)
        dot.BackgroundColor3 = Color3.fromRGB(60, 60, 72)
        dot.BorderSizePixel  = 0
        dot.ZIndex           = 23
        Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

        local function setActive(v)
            btn.BackgroundColor3 = v and BG_ON  or BG_OFF
            btn.TextColor3       = v and TXT_ON or TXT_OFF
            stroke.Color         = v and ACCENT  or Color3.fromRGB(38, 38, 50)
            dot.BackgroundColor3 = v and ACCENT_ON or Color3.fromRGB(60, 60, 72)
        end

        -- ── drag per przycisk (threshold-based) ──────────────────
        local _pressing   = false
        local _dragStart  = nil
        local _startPos   = nil
        local _wasDragged = false

        btn.InputBegan:Connect(function(inp)
            if inp.UserInputType ~= Enum.UserInputType.MouseButton1
            and inp.UserInputType ~= Enum.UserInputType.Touch then return end
            _pressing   = true
            _wasDragged = false
            _dragStart  = inp.Position
            _startPos   = frame.Position
            inp.Changed:Connect(function()
                if inp.UserInputState == Enum.UserInputState.End then
                    _pressing = false
                end
            end)
        end)

        UIS.InputChanged:Connect(function(inp)
            if not _pressing then return end
            if inp.UserInputType ~= Enum.UserInputType.MouseMovement
            and inp.UserInputType ~= Enum.UserInputType.Touch then return end
            if State.mobBtnLocked then return end
            local dx = inp.Position.X - _dragStart.X
            local dy = inp.Position.Y - _dragStart.Y
            if not _wasDragged and (math.abs(dx) > DRAG_THRESHOLD or math.abs(dy) > DRAG_THRESHOLD) then
                _wasDragged = true
            end
            if _wasDragged then
                frame.Position = UDim2.new(
                    _startPos.X.Scale, _startPos.X.Offset + dx,
                    _startPos.Y.Scale, _startPos.Y.Offset + dy
                )
            end
        end)

        btn.MouseButton1Click:Connect(function()
            if _wasDragged then return end  -- kliknięcie tylko gdy brak drag
            onClickFn()
        end)
        -- ──────────────────────────────────────────────────────────

        return setActive
    end
    -- ─────────────────────────────────────────────────────────────

    -- Tworzymy wszystkie przyciski
    for _, def in ipairs(layout) do
        local lbl, col, row = def[1], def[2], def[3]
        local clickFn

        if lbl == "Speed" then
            clickFn = function()
                if State.laggerModeEnabled then
                    State.laggerModeEnabled = false
                    if setLaggerMode then setLaggerMode(false) end
                end
                State.speedToggled = not State.speedToggled
                if modeValLbl then modeValLbl.Text = State.speedToggled and "Carry" or "Normal" end
                if scheduleAutoSave then scheduleAutoSave() end
            end
        elseif lbl == "Brainrot" then
            clickFn = function()
                if runDropBrainrot then task.spawn(runDropBrainrot) end
            end
        elseif lbl == "TP Down" then
            clickFn = function() task.spawn(runTPDown) end
        elseif lbl == "Lagger Mode" then
            clickFn = function()
                State.laggerModeEnabled = not State.laggerModeEnabled
                if setLaggerMode then setLaggerMode(State.laggerModeEnabled) end
                if modeValLbl then
                    modeValLbl.Text = State.laggerModeEnabled and "Lagger"
                        or (State.speedToggled and "Carry" or "Normal")
                end
                if scheduleAutoSave then scheduleAutoSave() end
            end
        elseif lbl == "Desync" then
            clickFn = function()
                State.medusaCounterEnabled = not State.medusaCounterEnabled
                if setMedusaCounter then setMedusaCounter(State.medusaCounterEnabled) end
                if scheduleAutoSave then scheduleAutoSave() end
            end
        elseif lbl == "Bat Aim" then
            clickFn = function()
                if State.autoBatToggled then
                    disableAutoBat()
                    if setAutoBat then setAutoBat(false) end
                else
                    enableAutoBat()
                    if setAutoBat then setAutoBat(true) end
                end
                if scheduleAutoSave then scheduleAutoSave() end
            end
        elseif lbl == "Auto R" then
            clickFn = function()
                State.autoRightEnabled = not State.autoRightEnabled
                if setAutoRight then setAutoRight(State.autoRightEnabled) end
                if State.autoRightEnabled then startAutoRight() else stopAutoRight() end
                if scheduleAutoSave then scheduleAutoSave() end
            end
        elseif lbl == "Auto L" then
            clickFn = function()
                State.autoLeftEnabled = not State.autoLeftEnabled
                if setAutoLeft then setAutoLeft(State.autoLeftEnabled) end
                if State.autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
                if scheduleAutoSave then scheduleAutoSave() end
            end
        else
            clickFn = function() end
        end

        setters[lbl] = makeFloatingBtn(lbl, col, row, clickFn)
    end

    -- Synchronizacja stanu (co klatkę)
    RunService.Heartbeat:Connect(function()
        pcall(function()
            cont.Visible = State.mobBtnVisible
            if setters["Speed"]       then setters["Speed"](State.speedToggled and not State.laggerModeEnabled) end
            if setters["Lagger Mode"] then setters["Lagger Mode"](State.laggerModeEnabled) end
            if setters["Desync"]      then setters["Desync"](State.medusaCounterEnabled) end
            if setters["Bat Aim"]     then setters["Bat Aim"](State.autoBatToggled) end
            if setters["Auto R"]      then setters["Auto R"](State.autoRightEnabled) end
            if setters["Auto L"]      then setters["Auto L"](State.autoLeftEnabled) end
        end)
    end)
end)
-- ─────────────────────────────────────────────────────────────────────────────

print("[Waveli  Hub Loaded]")

end)()
