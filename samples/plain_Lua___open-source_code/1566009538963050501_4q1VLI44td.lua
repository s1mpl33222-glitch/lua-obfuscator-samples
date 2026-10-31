--[[
    YASSIN ON TOP v8.0.5
    Steal / Combat / Mobile hub
    Steal Mode removed (locked V2) · Bat Bypass UI removed
]]

skipIntroEnabled = false
-- Cleanup old GUIs
pcall(function()
    local cleanupNames = {"RaptureDuel", "RaptureDuel_New", "RaptureDuelMobilePanel", "InstaResetButton", "BatBypassButton"}
    local function removeOldGui(container)
        if not container then return end
        for _, child in ipairs(container:GetChildren()) do
            if child:IsA("ScreenGui") and (child.Name:lower():find("rapture") or child.Name:lower():find("autosteal") or child.Name:lower():find("stealbar")) then
                pcall(function() child:Destroy() end)
            end
        end
        for _, name in ipairs(cleanupNames) do
            local oldGui = container:FindFirstChild(name)
            if oldGui then pcall(function() oldGui:Destroy() end) end
        end
    end
    removeOldGui(game:GetService("CoreGui"))
    removeOldGui(game:GetService("Players").LocalPlayer:FindFirstChild("PlayerGui"))
end)
_G.RaptureDuelRunning = false
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

-- Spin / Auto Spin: Auto Spin activates while an animal/tool is being carried.
local spinEnabled = false -- manual Spin toggle
local autoSpinEnabled = false
local spinSpeed = 35
local spinConnection = nil
local autoSpinActive = false
local function isHoldingAnimal()
    local character = LP.Character
    if not character then return false end

    -- 1) Steal / carry flags (most reliable in this game)
    local okS, stealing = pcall(function() return LP:GetAttribute("Stealing") end)
    if okS and stealing then return true end
    local okS2, stealing2 = pcall(function() return character:GetAttribute("Stealing") end)
    if okS2 and stealing2 then return true end
    if type(isStealing) == "boolean" and isStealing then return true end

    local attrNames = {
        "IsCarrying", "Carrying", "CarriedAnimal", "HeldAnimal", "HoldingAnimal",
        "HasAnimal", "HasBrainrot", "HoldingBrainrot", "Steal", "Stealing",
        "CurrentlyStealing", "CarryingAnimal", "Carry"
    }
    for _, name in ipairs(attrNames) do
        local ok, value = pcall(function() return character:GetAttribute(name) end)
        if ok and value and value ~= false and value ~= 0 and value ~= "" then return true end
        local okP, pval = pcall(function() return LP:GetAttribute(name) end)
        if okP and pval and pval ~= false and pval ~= 0 and pval ~= "" then return true end
        local child = character:FindFirstChild(name)
        if child then
            if child:IsA("BoolValue") and child.Value then return true end
            if child:IsA("ObjectValue") and child.Value ~= nil then return true end
            if child:IsA("StringValue") and child.Value ~= "" then return true end
            if child:IsA("NumberValue") and child.Value ~= 0 then return true end
        end
    end

    -- 2) Any carried tool that is NOT combat gear (bat/slap/sword/gun)
    for _, obj in ipairs(character:GetChildren()) do
        if obj:IsA("Tool") then
            local n = obj.Name:lower()
            local isWeapon = n:find("bat") or n:find("slap") or n:find("sword")
                or n:find("gun") or n:find("knife") or n:find("blade")
            if not isWeapon then
                -- animal / brainrot / pet / generic held item during steal
                if n:find("animal") or n:find("pet") or n:find("carry")
                    or n:find("brainrot") or n:find("steal") or n:find("hold")
                    or n:find("package") or n:find("item") then
                    return true
                end
                -- if tool has Handle and is equipped while Stealing progressed, treat as hold
                if obj:FindFirstChild("Handle") and (okS and stealing or okS2 and stealing2) then
                    return true
                end
            end
        end
    end

    -- 3) Model/part welded to character (carried animal body)
    for _, obj in ipairs(character:GetChildren()) do
        local n = obj.Name:lower()
        if (obj:IsA("Model") or obj:IsA("BasePart") or obj:IsA("Folder")) then
            if n:find("carried") or n:find("held") or n:find("animal")
                or n:find("brainrot") or n:find("pet") or n:find("steal") then
                return true
            end
        end
    end

    -- 4) WeldConstraint / Motor6D to external animal under character
    for _, d in ipairs(character:GetDescendants()) do
        if d:IsA("Weld") or d:IsA("WeldConstraint") or d:IsA("Motor6D") then
            local p0 = d.Part0 or d.Part1
            local p1 = d.Part1 or d.Part0
            for _, p in ipairs({p0, p1}) do
                if p and p:IsA("BasePart") and not p:IsDescendantOf(character) then
                    local pn = p.Name:lower()
                    local mn = p.Parent and p.Parent.Name:lower() or ""
                    if pn:find("animal") or mn:find("animal") or pn:find("brain")
                        or mn:find("brain") or mn:find("pet") then
                        return true
                    end
                end
            end
        end
    end

    return false
end

-- Movement systems run independently; no shared coordinator/arbitration.

local function stopSpin()
    if spinConnection then spinConnection:Disconnect(); spinConnection = nil end
    autoSpinActive = false
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if root then pcall(function() root.AssemblyAngularVelocity = Vector3.new(0, 0, 0) end) end
    if humanoid and _spinSavedAutoRotate ~= nil then
        pcall(function() humanoid.AutoRotate = _spinSavedAutoRotate end)
        _spinSavedAutoRotate = nil
    end
end

local _spinSavedAutoRotate = nil
local function startSpin()
    if spinConnection then spinConnection:Disconnect(); spinConnection = nil end
    -- RenderStepped + CFrame rotation: works with Shift Lock (AngularVelocity alone gets cancelled)
    spinConnection = RunService.RenderStepped:Connect(function(dt)
        if not (spinEnabled or autoSpinEnabled) then
            autoSpinActive = false
            return
        end
        local holding = isHoldingAnimal()
        local shouldSpin = spinEnabled or (autoSpinEnabled and holding)
        autoSpinActive = autoSpinEnabled and holding
        local character = LP.Character
        local root = character and character:FindFirstChild("HumanoidRootPart")
        local hum = character and character:FindFirstChildOfClass("Humanoid")
        if not shouldSpin then
            -- restore AutoRotate when spin is inactive.
            if hum and _spinSavedAutoRotate ~= nil then
                hum.AutoRotate = _spinSavedAutoRotate
                _spinSavedAutoRotate = nil
            end
            return
        end
        if not root or not root:IsA("BasePart") then return end
        dt = typeof(dt) == "number" and dt or 0.016
        if dt <= 0 or dt > 0.1 then dt = 0.016 end
        local spd = tonumber(spinSpeed) or 35
        -- rad/s scaled from spinSpeed (35 ~ strong spin)
        local yaw = math.rad(spd * 14) * dt
        pcall(function()
            if hum then
                if _spinSavedAutoRotate == nil then
                    _spinSavedAutoRotate = hum.AutoRotate
                end
                hum.AutoRotate = false
            end
            -- CFrame spin (survives Shift Lock)
            root.CFrame = root.CFrame * CFrame.Angles(0, yaw, 0)
            -- keep angular vel as support
            local av = root.AssemblyAngularVelocity
            root.AssemblyAngularVelocity = Vector3.new(av.X, spd * 1.15, av.Z)
        end)
    end)
end

-- keep spin loop alive across respawn
LP.CharacterAdded:Connect(function()
    task.wait(0.35)
    if spinEnabled or autoSpinEnabled then startSpin() end
end)

-- also re-check as soon as Stealing attribute flips on
pcall(function()
    LP:GetAttributeChangedSignal("Stealing"):Connect(function()
        if autoSpinEnabled and not spinConnection then startSpin() end
    end)
end)

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
BAT_AIMBOT_SPEED = 58 -- Vx7 APPROACH_SPEED
_isDraggingButton = false

local PASTEL_PINK  = Color3.fromRGB(184, 82, 255) -- blue accent
local NEON_PINK    = Color3.fromRGB(184, 61, 255) -- blue accent
local BLACK_BG     = Color3.fromRGB(0, 0, 0)
local BLACK_STROKE = Color3.fromRGB(0, 0, 0)
local INACTIVE_BG  = Color3.fromRGB(0, 0, 0)
local INACTIVE_TXT = Color3.fromRGB(255, 255, 255)
local ACTIVE_TXT   = Color3.fromRGB(255, 255, 255)
local GRAY_TRACK   = Color3.fromRGB(120, 120, 130)

local BTN_STROKE_THICKNESS = 2
local BTN_STROKE_TRANSPARENCY = 0
local BTN_BG_DARK = Color3.fromRGB(0, 0, 0)

aimbotMode = "V2"
selectedAimbotMode = "V2"
activeAimbotMode = "V2" -- runtime mode used by the active Auto Bat engine
autoBatSource = "key" -- key, combat, mobile-normal, or mobile-bypass
bypassAutoBatMobileEnabled = false
bypassAutoBatMobileSetVisual = nil
aimbotModeSetVisual = nil
antiRagSetVisual = nil

customSoundsEnabled     = false
setCustomSoundsVisual   = nil

batBypassEnabled = false
batBypassSetVisual = nil
batBypassFloatingButton = nil
batBypassFloatingPos = nil

antiDieEnabled = false

-- ANTI BAT — logic transferred from AmbitiousTest.lua
-- Preserve Yassin UI/state hooks; keep the source AntiBat pulse/restoration logic.
if type(_G.AmbitiousAntiBat) == "table" and type(_G.AmbitiousAntiBat.setEnabled) == "function" then
    pcall(function() _G.AmbitiousAntiBat.setEnabled(false) end)
end
if _G.__YASSIN_VX7_AB_CONN then
    pcall(function() _G.__YASSIN_VX7_AB_CONN:Disconnect() end)
    _G.__YASSIN_VX7_AB_CONN = nil
end

antiBatEnabled = false
_G.AmbitiousAntiBatEnabled = _G.AmbitiousAntiBatEnabled == true

local AntiBatConn = nil
local ANTIBAT_RANGE = 4000

local function stopAntiBat()
    if AntiBatConn then
        pcall(function() AntiBatConn:Disconnect() end)
        AntiBatConn = nil
    end
    _G.__YASSIN_VX7_AB_CONN = nil
    _G._AmbitiousAntiBatDesiredXZ = nil
    _G._AmbitiousAntiBatSpiking = false
end

local function startAntiBat()
    stopAntiBat()
    AntiBatConn = RunService.Heartbeat:Connect(function()
        if not _G.AmbitiousAntiBatEnabled then return end
        local char = LP.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if not root or not root.Parent then return end

        -- Clean Anti Bat logic: briefly jitter horizontal velocity, then restore it.
        local originalVelocity = root.Velocity
        local originalXZ = Vector3.new(originalVelocity.X, 0, originalVelocity.Z)
        _G._AmbitiousAntiBatSpiking = true
        root.Velocity = Vector3.new(
            math.random(-ANTIBAT_RANGE, ANTIBAT_RANGE),
            originalVelocity.Y,
            math.random(-ANTIBAT_RANGE, ANTIBAT_RANGE)
        )

        RunService.RenderStepped:Wait()

        if root and root.Parent then
            -- Preserve Yassin's existing movement coordination when it publishes a desired X/Z.
            local desiredXZ = _G._AmbitiousAntiBatDesiredXZ
            if typeof(desiredXZ) == "Vector3" then
                root.Velocity = Vector3.new(desiredXZ.X, root.Velocity.Y, desiredXZ.Z)
            else
                root.Velocity = Vector3.new(originalXZ.X, root.Velocity.Y, originalXZ.Z)
            end
        end
        _G._AmbitiousAntiBatSpiking = false
    end)
    _G.__YASSIN_VX7_AB_CONN = AntiBatConn
end

local function _abStep(_, fn)
    pcall(fn)
end

_G.AmbitiousAntiBat = {
    setEnabled = function(on)
        on = on and true or false
        antiBatEnabled = on
        _G.AmbitiousAntiBatEnabled = on
        if on then
            _abStep("startAntiBat", startAntiBat)
        else
            _abStep("stopAntiBat", stopAntiBat)
        end
    end,
    isEnabled = function() return _G.AmbitiousAntiBatEnabled == true end,
}

task.spawn(function()
    while true do
        task.wait(0.5)
        if _G.AmbitiousAntiBatEnabled then
            if not AntiBatConn then _abStep("watchdog:start", startAntiBat) end
        elseif AntiBatConn then
            _abStep("watchdog:stop", stopAntiBat)
        end
    end
end)

LP.CharacterAdded:Connect(function(char)
    if _G._AmbitiousWaitCharReady then _G._AmbitiousWaitCharReady(char, 10) end
    if _G.AmbitiousAntiBatEnabled then
        startAntiBat()
    else
        stopAntiBat()
    end
end)

-- Anti Bat ENEMY HEAD TAG (forced on — never shows on local player)
local ANTI_BAT_TAG_NAME = "YassinAntiBatHeadTag"
local ANTI_BAT_ATTR = "YassinAntiBat"

local function _destroyAntiBatTagOnChar(char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if head then
        local old = head:FindFirstChild(ANTI_BAT_TAG_NAME)
        if old then pcall(function() old:Destroy() end) end
    end
    local old2 = char:FindFirstChild(ANTI_BAT_TAG_NAME)
    if old2 then pcall(function() old2:Destroy() end) end
end

local function _createEnemyAntiBatTag(char)
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local existing = head:FindFirstChild(ANTI_BAT_TAG_NAME)
    if existing and existing:IsA("BillboardGui") then return existing end
    _destroyAntiBatTagOnChar(char)
    local bb = Instance.new("BillboardGui")
    bb.Name = ANTI_BAT_TAG_NAME
    bb.Adornee = head
    bb.Size = UDim2.new(0, 120, 0, 36)
    bb.StudsOffset = Vector3.new(0, 3.15, 0)
    bb.AlwaysOnTop = true
    bb.MaxDistance = math.huge
    bb.AlwaysOnTop = true
    bb.Parent = head

    local box = Instance.new("Frame")
    box.Name = "Box"
    box.Size = UDim2.new(1, 0, 1, 0)
    box.BackgroundColor3 = Color3.fromRGB(20, 8, 28)
    box.BackgroundTransparency = 0.15
    box.BorderSizePixel = 0
    box.Parent = bb
    Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)
    local stroke = Instance.new("UIStroke", box)
    stroke.Color = Color3.fromRGB(184, 82, 255)
    stroke.Thickness = 2
    stroke.Transparency = 0.1

    local lbl = Instance.new("TextLabel")
    lbl.Name = "Label"
    lbl.Size = UDim2.new(1, -6, 1, -4)
    lbl.Position = UDim2.new(0, 3, 0, 2)
    lbl.BackgroundTransparency = 1
    lbl.Text = "ANTI BAT"
    lbl.TextColor3 = Color3.fromRGB(255, 120, 255)
    lbl.Font = Enum.Font.GothamBlack
    lbl.TextSize = 14
    lbl.TextStrokeTransparency = 0.3
    lbl.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    lbl.Parent = box
    return bb
end

-- NEVER put the tag on local player (visual only). Attribute still broadcasts to others.
local function _clearLocalAntiBatTag()
    local char = LP.Character
    if char then _destroyAntiBatTagOnChar(char) end
end

-- Publish Anti Bat state so other clients see ON/OFF instantly at any distance
local function _publishAntiBatAttr(on)
    local char = LP.Character
    if not char then return end
    pcall(function()
        if on then
            char:SetAttribute(ANTI_BAT_ATTR, true)
            char:SetAttribute("AmbitiousAntiBat", true)
            char:SetAttribute("AntiBatEnabled", true)
        else
            char:SetAttribute(ANTI_BAT_ATTR, nil)
            char:SetAttribute("AmbitiousAntiBat", nil)
            char:SetAttribute("AntiBatEnabled", nil)
            char:SetAttribute("AntiBat", nil)
        end
    end)
end

-- Evidence tracker per other player (velocity spoof pattern)
-- Vx7 / similar anti-bat: brief huge random XZ velocity spikes then restore.
local _abEvidence = {} -- [userId] = { score, lastSpike, lastSeen, samples }
local _abTagByUser = {} -- [userId] = BillboardGui

local function _clearEnemy(uid, char)
    local bb = _abTagByUser[uid]
    if bb then pcall(function() bb:Destroy() end) end
    _abTagByUser[uid] = nil
    if char then _destroyAntiBatTagOnChar(char) end
end

local function _readHorizSpeed(root)
    local ok, v = pcall(function() return root.AssemblyLinearVelocity end)
    if not ok or not v then
        ok, v = pcall(function() return root.Velocity end)
    end
    if not ok or not v then return 0 end
    return math.sqrt(v.X * v.X + v.Z * v.Z)
end

local function _enemyHasAttrFlag(char)
    local on = false
    pcall(function()
        if char:GetAttribute(ANTI_BAT_ATTR) == true then on = true end
        if char:GetAttribute("AmbitiousAntiBat") == true then on = true end
        if char:GetAttribute("AntiBat") == true then on = true end
        if char:GetAttribute("AntiBatEnabled") == true then on = true end
    end)
    return on
end

local function _sampleEnemy(plr)
    if not plr or plr == LP then return end
    local uid = plr.UserId
    local char = plr.Character
    if not char or not char.Parent then
        _clearEnemy(uid, nil)
        _abEvidence[uid] = nil
        return
    end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then
        _clearEnemy(uid, char)
        return
    end

    local ev = _abEvidence[uid]
    -- Reset evidence only when this player gets a new character; keep a confirmed
    -- head tag stable through distance changes and ordinary movement states.
    if ev and ev.char ~= char then
        _clearEnemy(uid, nil)
        ev = nil
    end
    if not ev then
        ev = {
            char = char,
            confirmed = false,
            score = 0,
            lastSpike = 0,
            lastPos = root.Position,
            lastT = os.clock(),
            lastHSpeed = 0,
            hardSpikes = 0,
            pulsePairs = 0, -- spike then drop = classic anti-bat
            windowStart = os.clock(),
        }
        _abEvidence[uid] = ev
    end

    local now = os.clock()
    local dt = math.clamp(now - (ev.lastT or now), 0.02, 0.35)
    ev.lastT = now

    -- Reset sparse window every 3s so old spikes expire
    if (now - (ev.windowStart or now)) > 3 then
        ev.windowStart = now
        ev.hardSpikes = 0
        ev.pulsePairs = 0
        ev.score = math.max((ev.score or 0) * 0.25, 0)
    end

    -- Skip unreliable states (knockback / ragdoll / freefall look like "spikes")
    local stOk, st = pcall(function() return hum:GetState() end)
    local state = stOk and st or nil
    local ignoreState = state == Enum.HumanoidStateType.Ragdoll
        or state == Enum.HumanoidStateType.FallingDown
        or state == Enum.HumanoidStateType.Physics
        or state == Enum.HumanoidStateType.Jumping
        or state == Enum.HumanoidStateType.Freefall
        or state == Enum.HumanoidStateType.GettingUp
    if hum.PlatformStand or ignoreState then
        ev.score = math.max((ev.score or 0) - 1.2, 0)
        ev.lastPos = root.Position
        ev.lastHSpeed = _readHorizSpeed(root)
        -- Do not keep a stale tag just because this player was detected earlier.
        -- Only retain it briefly when there is fresh anti-bat evidence.
        local freshEvidence = (now - (ev.lastSpike or 0)) < 2.0
        if ev.confirmed and freshEvidence then
            local bb = _createEnemyAntiBatTag(char)
            _abTagByUser[uid] = bb
        else
            ev.confirmed = false
            _clearEnemy(uid, char)
        end
        return
    end

    local attrOn = _enemyHasAttrFlag(char)
    local hSpeed = _readHorizSpeed(root)
    local walk = tonumber(hum.WalkSpeed) or 16
    -- Legitimate combat/speed scripts often sit 30–70. Anti-bat pulse is extreme + brief.
    local pos = root.Position
    local dist = (Vector3.new(pos.X, 0, pos.Z) - Vector3.new(ev.lastPos.X, 0, ev.lastPos.Z)).Magnitude
    local instSpeed = dist / dt
    ev.lastPos = pos

    local prev = tonumber(ev.lastHSpeed) or 0
    ev.lastHSpeed = hSpeed

    -- HARD spike only: very high horizontal, typical of velocity spoof frames
    -- (soft 75–120 was causing false positives with carry/lagger/knockback)
    local hardVel = hSpeed >= 220
    local hardInst = instSpeed >= 200
    local megaVel = hSpeed >= 500 -- unmistakable spoof frame

    -- Pulse pair: was very high last sample, now dropped hard (restore frame)
    local pulsePair = false
    if prev >= 180 and hSpeed <= math.max(walk * 2.2, 50) and (prev - hSpeed) >= 120 then
        pulsePair = true
    end
    if prev >= 180 and instSpeed <= math.max(walk * 2.5, 55) and hSpeed <= math.max(walk * 2.2, 50) then
        pulsePair = true
    end

    if attrOn then
        ev.score = math.min(ev.score + 4, 15)
        ev.lastSpike = now
        ev.hardSpikes = (ev.hardSpikes or 0) + 1
        ev.pulsePairs = (ev.pulsePairs or 0) + 1
    elseif megaVel then
        ev.score = math.min(ev.score + 3, 15)
        ev.lastSpike = now
        ev.hardSpikes = (ev.hardSpikes or 0) + 1
    elseif hardVel or hardInst then
        ev.score = math.min(ev.score + 1.5, 15)
        ev.lastSpike = now
        ev.hardSpikes = (ev.hardSpikes or 0) + 1
    elseif pulsePair then
        ev.score = math.min(ev.score + 2.5, 15)
        ev.lastSpike = now
        ev.pulsePairs = (ev.pulsePairs or 0) + 1
    else
        -- calm movement / normal speed scripts → decay fast
        ev.score = math.max(ev.score - 1.1, 0)
    end

    -- Attribute = instant ON/OFF at any distance (Yassin + compatible scripts).
    -- Velocity evidence = fallback for scripts that do not publish attributes.
    local recent = (now - (ev.lastSpike or 0)) < 2.0
    if recent then
        ev.lastConfirmTime = now
    end

    local active = false
    if attrOn then
        -- Instant ON from any distance
        active = true
        ev.confirmed = true
        ev.lastConfirmTime = now
        ev.fromAttr = true
    elseif ev.fromAttr then
        -- Was attribute-based and attribute is now OFF → Instant OFF any distance
        active = false
        ev.confirmed = false
        ev.fromAttr = false
    elseif recent and (ev.hardSpikes or 0) >= 3 and (ev.pulsePairs or 0) >= 1 and (ev.score or 0) >= 7 then
        active = true
        ev.fromAttr = false
    elseif recent and (ev.hardSpikes or 0) >= 5 and (ev.score or 0) >= 9 then
        active = true
        ev.fromAttr = false
    elseif ev.confirmed and not ev.fromAttr then
        -- Velocity-only sticky: keep while far; clear quickly when close and quiet
        local inRange = true
        pcall(function()
            local myRoot = LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
            if myRoot and root then
                inRange = (root.Position - myRoot.Position).Magnitude < 280
            end
        end)
        if not inRange then
            active = true
        else
            local last = ev.lastConfirmTime or ev.lastSpike or 0
            active = (now - last) < 3.0
        end
    end

    if active then
        ev.confirmed = true
        local bb = _createEnemyAntiBatTag(char)
        if bb then
            pcall(function()
                bb.MaxDistance = math.huge
                bb.AlwaysOnTop = true
            end)
        end
        _abTagByUser[uid] = bb
    else
        ev.confirmed = false
        ev.fromAttr = false
        _clearEnemy(uid, char)
    end
end

-- Anti Bat detector runner: the detector functions above were defined but never
-- called, so no enemy head tag could appear. Sample every other player continuously.
_G.__YASSIN_ANTIBAT_DETECTOR_GEN = (_G.__YASSIN_ANTIBAT_DETECTOR_GEN or 0) + 1
local _antiBatDetectorGen = _G.__YASSIN_ANTIBAT_DETECTOR_GEN
task.spawn(function()
    while _antiBatDetectorGen == _G.__YASSIN_ANTIBAT_DETECTOR_GEN do
        for _, enemy in ipairs(Players:GetPlayers()) do
            if enemy ~= LP then
                pcall(_sampleEnemy, enemy)
            end
        end
        task.wait(0.05)
    end
end)

Players.PlayerRemoving:Connect(function(plr)
    if plr then
        _clearEnemy(plr.UserId, plr.Character)
        _abEvidence[plr.UserId] = nil
    end
end)

LP.CharacterAdded:Connect(function()
    task.defer(function()
        task.wait(0.3)
        pcall(_clearLocalAntiBatTag)
        if antiBatEnabled or _G.AmbitiousAntiBatEnabled then
            pcall(_publishAntiBatAttr, true)
        else
            pcall(_publishAntiBatAttr, false)
        end
    end)
end)

local function setAntiBatEnabled(enabled)

    antiBatEnabled = enabled == true
    _G.AmbitiousAntiBatEnabled = antiBatEnabled
    if antiBatEnabled then
        _abStep("startAntiBat", startAntiBat)
        _publishAntiBatAttr(true)
    else
        _abStep("stopAntiBat", stopAntiBat)
        _publishAntiBatAttr(false)
    end
    -- Never show tag on local head (others still read the attribute)
    pcall(_clearLocalAntiBatTag)
    if markSettingsDirty then pcall(markSettingsDirty) end
end

_G.AmbitiousAntiBat = {
    setEnabled = function(on) setAntiBatEnabled(on) end,
    isEnabled = function() return antiBatEnabled == true end,
}


setAntiDieVisual = nil

_G.RaptureToolAssets = {}

stealMode = "V2"
local STEAL_MODE_LOCKED = "V2"
V2_STOP_PERCENT = 70
NORMAL_STOP_PERCENT = 90

local BACKGROUND_IMAGE_ID = "99641252781891"
backgroundImageTransparency = 0
savedUiStyle = nil
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
    -- Custom Sounds removed
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

-- AntiBat/Speed coordination is published by the active speed writer below,
-- matching Ambitious: publish intended X/Z, and do not overwrite an AntiBat pulse.
jumpEnabled = false
laggerToggled = false
laggerCarryToggled = false
medusaCounterEnabled = false
batCounterEnabled = false
autoLeftEnabled = false
autoRightEnabled = false
autoBatEnabled = false
dropMode = 1
removeAccessoriesEnabled = false
stretchEnabled = false
stretchFOV = 120
stretchValue = 0.7
uiLocked = true
uiScaleValue = 74
progressBarScaleValue = 80
autoStealBarHidden = false
espEnabled = false
antiLagEnabled = false
ragdollTimerEnabled = false -- removed feature

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
batBypassFloatingPos = nil
instaResetFloatingPos = nil
instaResetFloatingButton = nil

currentAnimPack = "Off"
tryardHeartbeatConn = nil
useCarrySystem = false
lastMoveDir = _V3zero

-- # MEDUSA WATCHER
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

_G._RaptureRCD = {conn=nil, charConn=nil, endTime=0, seconds=2.6}
ragdollCountdownLabel = nil
ragdollCountdownEnabled = false
function hookRagdollCountdown(char) end

-- # ANTI DIE
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
    -- Soft recovery only. FallingDown is normal jump/land — do NOT fight it every frame
    -- (that spam ChangeState + felt like random self-reset).
    if _antiDie.config.ragdollProtection then
        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics
            or state == Enum.HumanoidStateType.Ragdoll
            or state == Enum.HumanoidStateType.Dead then
            local last = _antiDie._lastRagFix or 0
            if (_tick() - last) >= 0.22 then
                _antiDie._lastRagFix = _tick()
                pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
                _antiDie.SuperHeal(hum)
                if root then pcall(function() root.AssemblyAngularVelocity = Vector3.zero end) end
            end
        end
    end
    if hum.Health <= 0 then
        _antiDie.SuperHeal(hum)
        pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        -- Do not hard-zero velocity / teleport every tick — only soft nudge once
        if root and not _antiDie._deathNudge then
            _antiDie._deathNudge = true
            pcall(function()
                root.CFrame = CFrame.new(root.Position + Vector3.new(0, 2, 0))
            end)
            task.delay(0.5, function() _antiDie._deathNudge = false end)
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
    if hum.Health > 0 then return end
    local last = _antiDie._lastRevive or 0
    if (_tick() - last) < 0.35 then return end
    _antiDie._lastRevive = _tick()
    _antiDie.SuperHeal(hum)
    pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
    -- Soft revive: heal + get up only. No velocity wipe (that felt like random reset).
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
        if hum.Health <= 0 then
            _antiDie.AutoRevive()
        elseif hum.Health <= _antiDie.config.healthThreshold then
            _antiDie.SuperHeal(hum)
        elseif hum.Health < (hum.MaxHealth or 100) then
            -- throttle full top-up so we don't fight the server every frame
            local last = _antiDie.lastHealTime or 0
            if (_tick() - last) >= 0.15 then _antiDie.SuperHeal(hum) end
        end
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

-- # CUSTOM SOUNDS
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
            -- Feature removed: always keep disabled
            enabled = false
            for tool in pairs(tracked) do teardown(tool) end
            for _, c in pairs(pendingHandle) do pcall(function() c:Disconnect() end) end
            table.clear(pendingHandle)
            for container in pairs(watchers) do unwatch(container) end
        end,
        isEnabled = function() return false end,
    }
end

-- Infinite Jump (PC + Mobile touch + Gamepad)
local InfiniteJump = {
    enabled = false, jumpPower = 50, minVelocity = 30, mode = "HOLD", -- Forced: Hold mode is always enabled; no manual mode option.

    jumpConn = nil, heartbeatConn = nil, inputBeganConn = nil, inputEndedConn = nil,
    touchGuiConn = nil, touchButtonConns = {}, holdPressed = false,
}
local function applyJump(root)
    if not root then return end
    local char = LP.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    pcall(function() root.Velocity = _V3new(root.Velocity.X, InfiniteJump.jumpPower, root.Velocity.Z) end)
end
local function onJumpRequest()
    if not InfiniteJump.enabled or _G._AmbitiousTPDownJumpLocked then return end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then applyJump(root) end
end
local function onHeartbeat()
    if not InfiniteJump.enabled or InfiniteJump.mode ~= "HOLD" or not InfiniteJump.holdPressed then return end
    if _G._AmbitiousTPDownJumpLocked then return end
    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root and root.Parent and root.Velocity.Y < InfiniteJump.minVelocity then applyJump(root) end
end
local function clearTouchButtonConnections()
    for _, conn in ipairs(InfiniteJump.touchButtonConns) do pcall(function() conn:Disconnect() end) end
    table.clear(InfiniteJump.touchButtonConns)
end
local function bindTouchJumpButton()
    clearTouchButtonConnections()
    if not InfiniteJump.enabled then return end
    local pg = LP:FindFirstChildOfClass("PlayerGui")
    local touchGui = pg and pg:FindFirstChild("TouchGui")
    local frame = touchGui and touchGui:FindFirstChild("TouchControlFrame", true)
    local jumpButton = frame and frame:FindFirstChild("JumpButton", true)
    if jumpButton and jumpButton:IsA("GuiButton") then
        table.insert(InfiniteJump.touchButtonConns, jumpButton.InputBegan:Connect(function(input)
            if InfiniteJump.mode == "HOLD" and (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1) then
                InfiniteJump.holdPressed = true
            end
        end))
        table.insert(InfiniteJump.touchButtonConns, jumpButton.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                InfiniteJump.holdPressed = false
            end
        end))
    end
end
function InfiniteJump.start()
    InfiniteJump.mode = "HOLD" -- Never allow a saved or external mode to disable Hold.
    if InfiniteJump.enabled then bindTouchJumpButton(); return end
    InfiniteJump.enabled = true
    InfiniteJump.jumpConn = UIS.JumpRequest:Connect(onJumpRequest)
    InfiniteJump.heartbeatConn = RunService.Heartbeat:Connect(onHeartbeat)
    InfiniteJump.inputBeganConn = UIS.InputBegan:Connect(function(input, processed)
        if UIS:GetFocusedTextBox() then return end
        local isJumpKey = input.KeyCode == Enum.KeyCode.Space
        local isGamepadJump = input.KeyCode == Enum.KeyCode.ButtonA
        if processed and not isGamepadJump then return end
        if InfiniteJump.mode == "HOLD" and (isJumpKey or isGamepadJump) then InfiniteJump.holdPressed = true end
    end)
    InfiniteJump.inputEndedConn = UIS.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then InfiniteJump.holdPressed = false end
    end)
    local pg = LP:FindFirstChildOfClass("PlayerGui")
    if pg then
        InfiniteJump.touchGuiConn = pg.ChildAdded:Connect(function(child)
            if child.Name == "TouchGui" then task.defer(bindTouchJumpButton) end
        end)
    end
    bindTouchJumpButton()
end
function InfiniteJump.stop()
    InfiniteJump.enabled = false
    InfiniteJump.holdPressed = false
    for _, key in ipairs({"jumpConn", "heartbeatConn", "inputBeganConn", "inputEndedConn", "touchGuiConn"}) do
        local conn = InfiniteJump[key]
        if conn then pcall(function() conn:Disconnect() end); InfiniteJump[key] = nil end
    end
    clearTouchButtonConnections()
end

function getActiveMoveSpeed()
    local v
    if laggerCarryToggled then
        v = LAGGER_CARRY_SPEED
    elseif laggerToggled then
        v = LAGGER_SPEED
    elseif speedMode then
        v = CS
    else
        v = NS
    end
    v = tonumber(v)
    if not v or v ~= v then -- nil / NaN
        v = 16
    end
    -- Match UI boxes (1..500). Soft floor so 0 doesn't freeze the player mid-run.
    if v < 0 then v = 0 end
    if v > 500 then v = 500 end
    return v
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
            -- Drop intentionally uses a short vertical velocity burst. Do not mask
            -- the character's velocity while Drop is active.
            if not checkcaller() and _velChecked[self] and not dropActive
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
    speed = tonumber(speed) or 16
    if speed ~= speed or speed < 0 then speed = 16 end
    if speed > 500 then speed = 500 end
    -- No movement intent: clear the published target so AntiBat restores
    -- the velocity captured for this pulse instead of replaying stale speed.
    if not dir then
        -- No movement intent: do not leave a stale target for AntiBat to restore.
        _G._AmbitiousAntiBatDesiredXZ = nil
        return
    end
    local flat = Vector3.new(dir.X, 0, dir.Z)
    local flatMagnitude = flat.Magnitude
    if flatMagnitude <= 0.05 then
        _G._AmbitiousAntiBatDesiredXZ = nil
        return
    end
    local unit = flat.Unit
    if unit.X ~= unit.X then
            return
    end
    local desiredXZ = _V3new(unit.X * speed, 0, unit.Z * speed)
    -- Ambitious coordination: publish the speed system's intended X/Z so
    if _G._AmbitiousZigZagFalling then
        _G._AmbitiousAntiBatDesiredXZ = nil
    else
        _G._AmbitiousAntiBatDesiredXZ = desiredXZ
    end
    local cur = hrp.AssemblyLinearVelocity
    if cur.X ~= cur.X then cur = _V3zero end
    -- Keep the chaotic AntiBat pulse alive for its frame; otherwise apply speed.
    if not _G._AmbitiousAntiBatSpiking and not _G._AmbitiousZigZagFalling then
        local y = cur.Y
        hrp.AssemblyLinearVelocity = _V3new(desiredXZ.X, y, desiredXZ.Z)
    end
    _G.__RaptureLiveSpeed = { t = os.clock(), v = speed }
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
    InstaReset   = {kb = Enum.KeyCode.H, gp = nil},
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
    InstaReset   = {kb = DEFAULT_KB.InstaReset.kb, gp = DEFAULT_KB.InstaReset.gp},
}

_isResetting = false
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
normalBox, carryBox, laggerBox, lagger2Box, radInput, batSpeedBox, uiScaleBox, progressBarScaleBox, spinSpeedBox = nil, nil, nil, nil, nil, nil, nil, nil, nil
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
mobileButtonsHidden = false
mobileButtonStyle = "Square" -- Square, Rounded, Circle
setMobileButtonsHiddenVisual = nil
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
    if type(entry) ~= "table" or not kc then return false end
    -- A binding is active only on the device slot it was assigned to.
    return (entry.kb ~= nil and entry.kb == kc)
        or (entry.gp ~= nil and entry.gp == kc)
end

function resetProgressBar()
    if progressPct then progressPct.Text = "0%" end
    if progressFill then progressFill.Size = UDim2.new(0, 0, 1, 0) end
end

-- TP DOWN — Ambitious ground detection + NORMAL / SLOW FALL / ZIGZAG
do
    local TP_DOWN_FALLBACK_Y = -7.00
    local TP_DOWN_MAX_DISTANCE = 4000
    local TP_DOWN_MAX_STEPS = 12
    local EXCLUDE_FILTER = (function()
        local ok, v = pcall(function() return Enum.RaycastFilterType.Exclude end)
        if ok and v then return v end
        local ok2, v2 = pcall(function() return Enum.RaycastFilterType.Blacklist end)
        if ok2 then return v2 end
        return nil
    end)()

    local function standOffset(hum, hrp)
        local half = 1
        pcall(function() half = hrp.Size.Y * 0.5 end)
        if half <= 0 then half = 1 end
        local off = half * 3
        pcall(function()
            if hum and hum.RigType == Enum.HumanoidRigType.R6 then
                off = half * 3
            elseif hum then
                off = half + (hum.HipHeight or (half * 2))
            end
        end)
        -- Same sanity clamp as Ambitious: protects against invalid HipHeight
        -- values that could otherwise send the player to an impossible Y.
        if off ~= off or off < 1 or off > 12 then off = half * 3 end
        return off + 0.15
    end

    local function rayDown(fromY, x, z, filter)
        local params = RaycastParams.new()
        params.FilterDescendantsInstances = filter
        if EXCLUDE_FILTER then params.FilterType = EXCLUDE_FILTER end
        params.IgnoreWater = true
        pcall(function() params.RespectCanCollide = true end)
        local res
        pcall(function()
            res = Workspace:Raycast(Vector3.new(x, fromY, z), Vector3.new(0, -TP_DOWN_MAX_DISTANCE, 0), params)
        end)
        return res
    end

    -- Returns target Y, real ground Y and vertical distance, matching Ambitious.
    function _G.AmbitiousGetGroundTPY(char, hrp, hum)
        char = char or LP.Character
        if not char then return nil end
        hrp = hrp or char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil end
        hum = hum or char:FindFirstChildOfClass("Humanoid")

        local filter = {char}
        pcall(function()
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    table.insert(filter, plr.Character)
                end
            end
        end)

        local origin = hrp.Position
        local halfY = 1
        pcall(function() halfY = hrp.Size.Y * 0.5 end)
        local startY = origin.Y - halfY - 0.1
        local groundY = nil

        for _ = 1, TP_DOWN_MAX_STEPS do
            local res = rayDown(startY, origin.X, origin.Z, filter)
            if not res then break end
            local part = res.Instance
            local skip = false
            if part then
                pcall(function()
                    if part:IsA("BasePart") and part.CanCollide == false then skip = true end
                    local model = part:FindFirstAncestorOfClass("Model")
                    if model and model:FindFirstChildOfClass("Humanoid") then skip = true end
                end)
            else
                skip = true
            end
            if skip then
                if part then table.insert(filter, part) end
                startY = res.Position.Y - 0.05
            else
                groundY = res.Position.Y
                break
            end
        end

        if not groundY then return nil end
        local targetY = groundY + standOffset(hum, hrp)
        return targetY, groundY, (origin.Y - groundY)
    end

    function _G.AmbitiousResolveTPDownY(char, hrp, hum)
        local ok, y = pcall(_G.AmbitiousGetGroundTPY, char, hrp, hum)
        if ok and type(y) == "number" then return y, true end
        return TP_DOWN_FALLBACK_Y, false
    end
end

-- The TP Down method selector was removed from the UI; use normal TP Down.
_G._AmbitiousTPDownMethod = "NORMAL"
tpDownMethodSetVisual = nil
setAutoTPDownVisual = nil
autoTPHeightBox = nil
_G._AmbitiousZigZagSide = _G._AmbitiousZigZagSide or 1
_G._AmbitiousSlowFallActive = false
_G._AmbitiousZigZagFalling = false
_G._AmbitiousTPDownJumpLocked = false


-- Ambitious slow-fall engine. It uses the same proxy entry point if one exists;
function _G.AmbitiousSlowFallDown(targetY, zig)
    if _G._AmbitiousSlowFallActive then return end
    _G._AmbitiousSlowFallActive = true
    _G._AmbitiousTPDownJumpLocked = true

    local zigVec = nil
    _G._AmbitiousZigZagFalling = false
    if zig then
        _G._AmbitiousZigZagSide = (_G._AmbitiousZigZagSide == -1) and 1 or -1
        local ch = LP.Character
        local hr = ch and ch:FindFirstChild("HumanoidRootPart")
        if hr then
            local rv = hr.CFrame.RightVector
            local flat = Vector3.new(rv.X, 0, rv.Z)
            if flat.Magnitude > 0.001 then
                local spd = (type(getActiveMoveSpeed) == "function" and getActiveMoveSpeed()) or 16
                zigVec = flat.Unit * spd * _G._AmbitiousZigZagSide
                _G._AmbitiousZigZagFalling = true
            end
        end
    end

    task.spawn(function()
        local POWER = zigVec and 50 or 115
        local deadline = os.clock() + 6
        local landed = false
        while os.clock() < deadline do
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hrp or not hum or hum.Health <= 0 then break end
            if hum.FloorMaterial ~= Enum.Material.Air then landed = true break end

            local proxy = _G._jumpEnsureProxy and _G._jumpEnsureProxy() or nil
            local part = proxy or hrp
            local v = part.Velocity
            if zigVec then
                part.Velocity = Vector3.new(zigVec.X, -POWER, zigVec.Z)
            else
                part.Velocity = Vector3.new(v.X, -POWER, v.Z)
            end
            RunService.Heartbeat:Wait()
        end

        if not landed then
            local char = LP.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            local proxy = _G._jumpEnsureProxy and _G._jumpEnsureProxy() or nil
            if proxy then
                local v = proxy.Velocity
                pcall(function() proxy.Velocity = Vector3.new(v.X, 0, v.Z) end)
            elseif hrp then
                local v = hrp.Velocity
                pcall(function() hrp.Velocity = Vector3.new(v.X, 0, v.Z) end)
            end
        end
        _G._AmbitiousSlowFallActive = false
        _G._AmbitiousZigZagFalling = false

        local groundDeadline = os.clock() + 8
        while os.clock() < groundDeadline do
            local c2 = LP.Character
            local h2 = c2 and c2:FindFirstChildOfClass("Humanoid")
            if not h2 or h2.Health <= 0 then break end
            if h2.FloorMaterial ~= Enum.Material.Air then break end
            RunService.Heartbeat:Wait()
        end
        _G._AmbitiousTPDownJumpLocked = false
    end)
end

-- Ambitious Auto TP Down state (off by default; enabled only by its toggle).
autoTPEnabled = false
autoTPHeight = 20
autoTPConn = nil
autoTPLastRun = 0

local function doTpDown(forceNormal, resolvedTargetY)
    pcall(function()
        local character = LP.Character
        if not character then return end
        local hrp = character:FindFirstChild("HumanoidRootPart")
        local hum = character:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 then return end

        local targetY = resolvedTargetY
        if type(targetY) ~= "number" then
            targetY = _G.AmbitiousResolveTPDownY(character, hrp, hum)
        end
        local mode = forceNormal and "NORMAL" or (_G._AmbitiousTPDownMethod or "NORMAL")
        if mode == "SLOW" or mode == "ZIGZAG" then
            if _G.AmbitiousSlowFallDown then
                _G.AmbitiousSlowFallDown(targetY, mode == "ZIGZAG")
            end
            return
        end

        hrp.CFrame = CFrame.new(hrp.Position.X, targetY, hrp.Position.Z)
            * CFrame.Angles(0, select(2, hrp.CFrame:ToEulerAnglesYXZ()), 0)
        hrp.AssemblyLinearVelocity = Vector3.zero
        _G._AmbitiousTPDownJumpLocked = true
        task.spawn(function()
            local groundDeadline = os.clock() + 8
            while os.clock() < groundDeadline do
                local c2 = LP.Character
                local h2 = c2 and c2:FindFirstChildOfClass("Humanoid")
                if not h2 or h2.Health <= 0 then break end
                if h2.FloorMaterial ~= Enum.Material.Air then break end
                RunService.Heartbeat:Wait()
            end
            _G._AmbitiousTPDownJumpLocked = false
        end)
    end)
end

-- Compatibility entry point matching Ambitious; forceNormal skips the chosen fall mode.
function _G.AmbitiousRunTPDown(forceNormal)
    if forceNormal then
        local previous = _G._AmbitiousTPDownMethod
        _G._AmbitiousTPDownMethod = "NORMAL"
        pcall(doTpDown, true)
        _G._AmbitiousTPDownMethod = previous
    else
        pcall(doTpDown)
    end
end

-- Automatic half of Ambitious TP Down: checks airborne state/height at 10 Hz.
function _G._YassinAutoTPDownStep(force)
    local char = LP.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum then return end
    if not force then
        if hum.FloorMaterial ~= Enum.Material.Air then return end
        if hrp.Position.Y < autoTPHeight then return end
    end
    local targetY = _G.AmbitiousResolveTPDownY(char, hrp, hum)
    if not force and (hrp.Position.Y - targetY) < 0.75 then return end
    doTpDown(false, targetY)
end

function stopAutoTPDown()
    autoTPEnabled = false
    if autoTPConn then
        pcall(function() autoTPConn:Disconnect() end)
        autoTPConn = nil
    end
    if setAutoTPDownVisual then pcall(setAutoTPDownVisual, false) end
end

function startAutoTPDown()
    if autoTPConn then pcall(function() autoTPConn:Disconnect() end); autoTPConn = nil end
    autoTPEnabled = true
    autoTPLastRun = 0
    autoTPConn = RunService.Heartbeat:Connect(function()
        if not autoTPEnabled then
            if autoTPConn then pcall(function() autoTPConn:Disconnect() end); autoTPConn = nil end
            return
        end
        local now = tick()
        if now - autoTPLastRun < 0.1 then return end
        autoTPLastRun = now
        pcall(_G._YassinAutoTPDownStep, false)
    end)
    if setAutoTPDownVisual then pcall(setAutoTPDownVisual, true) end
end

function toggleAutoTPDown(on)
    if on == true then startAutoTPDown() else stopAutoTPDown() end
    if markSettingsDirty then markSettingsDirty() end
end

-- Auto TP Down runs independently of Aimbot and other combat actions.
local INTRO_DURATION = 5 -- visual title duration
local INTRO = {
    enabled = true,
    look = false,
    music = 1,
    matchEnabled = false,
    matchMusic = 1,
    animeUrl = "",
    animeAsset = "",
    OPTIONS = {},
    stopPreview = nil,
    stopPlayback = nil,
    getSongName = nil,
    preview = nil,
    play = nil,
    playMatch = nil,
    stopMatch = nil,
    getMatchSongName = nil,
}

(function()
    local SoundService = game:GetService("SoundService")

    local INTRO_MUSIC_OPTIONS = {
        {name="RyzenxHub Intro", url="https://project--86964ab4-117d-44b0-9478-4dc13565dcc9-dev.lovable.app/__l5e/assets-v1/62bda52a-420e-4b45-98e6-c3c2f5798ec7/RyzenxHub_IntroSong_10.mp3", file="RyzenxHub_IntroSong_10.mp3", startTime=0},
        {name="Song 2", url="https://files.catbox.moe/2a7jyx.mp3", file="bizarreIntroSong_2.mp3"},
        {name="Song 3", url="https://files.catbox.moe/rcgr9f.mp3", file="bizarreIntroSong_3.mp3"},
        {name="Song 4", url="https://litter.catbox.moe/m493detpu1asdmin.mp3", file="bizarreIntroSong_4_new.mp3", startTime=51},
        {name="Song 5", url="https://files.catbox.moe/6eigoh.mp3", file="bizarreIntroSong_5.mp3"},
        {name="Song 6", url="https://litter.catbox.moe/c7opcv.mp3", file="bizarreIntroSong_6_pupsies.mp3", startTime=6},
        {name="Song 7", url="https://files.catbox.moe/iyw1cb.mp3", file="bizarreIntroSong_7.mp3"},
        {name="Song 8", assetId="rbxassetid://76650356472656", startTime=3, volume=1},
        {name="Song 9", url="https://files.catbox.moe/mzvrir.mp3", file="bizarreIntroSong_1.mp3"},
        {name="Song 10", url="https://litter.catbox.moe/xkew3553w380fzfb.mp3", file="bizarreIntroSong_10.mp3", startTime=29},
    }

    local introPreviewSound = nil
    local introPlaybackSound = nil
    local introPreviewToken = 0
    local introPlaybackToken = 0
    local introSongCache = {}
    local introSongDownloading = {}

    local function stopIntroPreview()
        introPreviewToken = introPreviewToken + 1
        if introPreviewSound then
            pcall(function() introPreviewSound:Stop() end)
            pcall(function() introPreviewSound:Destroy() end)
            introPreviewSound = nil
        end
    end

    local function stopIntroPlayback()
        introPlaybackToken = introPlaybackToken + 1
        if introPlaybackSound then
            pcall(function() introPlaybackSound:Stop() end)
            pcall(function() introPlaybackSound:Destroy() end)
            introPlaybackSound = nil
        end
    end

    local function getIntroSongName()
        local opt = INTRO_MUSIC_OPTIONS[INTRO.music]
        return opt and opt.name or "No Songs Added"
    end

    local function _safeNotify(msg)
        print("[bizarre] " .. tostring(msg))
    end

    local function _httpGetBody(url)
        if not url or url == "" then return nil end
        local body = nil
        local function tryReq(fn)
            if body and #body > 1000 then return end
            pcall(function()
                local res = fn()
                if type(res) == "string" and #res > 1000 then
                    body = res
                elseif type(res) == "table" then
                    local b = res.Body or res.body or res.Data or res.data
                    if type(b) == "string" and #b > 1000 then body = b end
                end
            end)
        end
        tryReq(function()
            if request then return request({Url = url, Method = "GET"}) end
        end)
        tryReq(function()
            if http_request then return http_request({Url = url, Method = "GET"}) end
        end)
        tryReq(function()
            if syn and syn.request then return syn.request({Url = url, Method = "GET"}) end
        end)
        tryReq(function()
            if fluxus and fluxus.request then return fluxus.request({Url = url, Method = "GET"}) end
        end)
        tryReq(function()
            return game:HttpGet(url)
        end)
        tryReq(function()
            return game:HttpGetAsync(url)
        end)
        return body
    end

    local function cacheIntroSong(option, allowDownload)
        if option and option.assetId then return option.assetId end
        if not option or not option.url or option.url == "" then return nil end
        if not getcustomasset then return nil end
        local fileName = option.file or ("bizarreIntroSong_" .. tostring(option.name or "song") .. ".mp3")
        local function loadExisting()
            if introSongCache[fileName] then return introSongCache[fileName] end
            local hasFile = false
            pcall(function() hasFile = isfile and isfile(fileName) end)
            if hasFile then
                local ok = pcall(function() introSongCache[fileName] = getcustomasset(fileName) end)
                if ok and introSongCache[fileName] then return introSongCache[fileName] end
            end
            return nil
        end
        local cached = loadExisting()
        if cached then return cached end
        if allowDownload == false then return nil end
        if introSongDownloading[fileName] then
            local waitStart = tick()
            while introSongDownloading[fileName] and tick() - waitStart < 20 do task.wait(0.05) end
            cached = loadExisting()
            if cached then return cached end
        end
        introSongDownloading[fileName] = true
        local urls = { option.url }
        if option.url:find("litter.catbox.moe", 1, true) then
            table.insert(urls, (option.url:gsub("litter%.catbox%.moe", "files.catbox.moe")))
        elseif option.url:find("files.catbox.moe", 1, true) then
            table.insert(urls, (option.url:gsub("files%.catbox%.moe", "litter.catbox.moe")))
        end
        for attempt = 1, 3 do
            for _, u in ipairs(urls) do
                local data = _httpGetBody(u)
                if data and #data > 1000 and writefile then
                    local wok = pcall(function()
                        writefile(fileName, data)
                        introSongCache[fileName] = getcustomasset(fileName)
                    end)
                    if wok and introSongCache[fileName] then
                        introSongDownloading[fileName] = nil
                        return introSongCache[fileName]
                    end
                end
            end
            task.wait(0.25 * attempt)
        end
        introSongDownloading[fileName] = nil
        return loadExisting()
    end

    local function preloadIntroSongs()
        task.spawn(function()
            cacheIntroSong(INTRO_MUSIC_OPTIONS[INTRO.music], true)
            for _, option in ipairs(INTRO_MUSIC_OPTIONS) do
                if option ~= INTRO_MUSIC_OPTIONS[INTRO.music] then
                    cacheIntroSong(option, true)
                    task.wait(0.05)
                end
            end
        end)
    end

    local function makeIntroSoundFromId(soundId, name, parent)
        if not soundId then return nil end
        local sound = Instance.new("Sound")
        sound.Name = name or "bizarreIntroMusic"
        sound.Volume = 0.65
        sound.Looped = false
        sound.SoundId = soundId
        sound.Parent = parent or SoundService
        return sound
    end

    local function createIntroSound(option, fileName, parent, allowDownload)
        if not option then return nil end
        local soundId = cacheIntroSong(option, allowDownload)
        if not soundId then return nil end
        local sound = makeIntroSoundFromId(soundId, fileName, parent)
        if sound and option.volume then sound.Volume = option.volume end
        return sound
    end

    local function previewIntroMusic(index)
        stopIntroPreview()
        stopIntroPlayback()
        if not INTRO_MUSIC_OPTIONS[index] then _safeNotify("ADD SONG LINKS"); return end
        local token = introPreviewToken
        task.spawn(function()
            local option = INTRO_MUSIC_OPTIONS[index]
            local sound = createIntroSound(option, "bizarreIntroPreview_" .. tostring(token), SoundService, true)
            if token ~= introPreviewToken then if sound then sound:Destroy() end; return end
            introPreviewSound = sound
            if not sound then _safeNotify("SONG LOADING..."); return end
            local loadStart = tick()
            while sound and not sound.IsLoaded and tick() - loadStart < 15 do task.wait(0.05) end
            if sound and sound.Volume < 0.1 then sound.Volume = 0.65 end
            sound.TimePosition = tonumber(option.startTime) or 0
            pcall(function() sound:Play() end)
            task.delay(15, function() if token == introPreviewToken then stopIntroPreview() end end)
        end)
    end

    local function playIntroMusic()
        stopIntroPreview()
        stopIntroPlayback()
        if not INTRO.enabled then return end
        local option = INTRO_MUSIC_OPTIONS[INTRO.music]
        if not option then return end
        local token = introPlaybackToken
        task.spawn(function()
            local sound = createIntroSound(option, "bizarreIntroMusic_" .. tostring(token), SoundService, true)
            if token ~= introPlaybackToken then if sound then pcall(function() sound:Destroy() end) end; return end
            introPlaybackSound = sound
            if not sound then return end
            pcall(function() sound.Looped = false end)
            -- Start playback immediately; Roblox queues it until the audio is ready.
            if token ~= introPlaybackToken then
                pcall(function() sound:Destroy() end)
                return
            end
            if sound and sound.Volume < 0.1 then sound.Volume = 0.65 end
            pcall(function() sound:Play() end)
            -- Keep the selected song playing for exactly 17 seconds, then stop it.
            task.delay(17, function()
                if introPlaybackToken == token and introPlaybackSound == sound then
                    pcall(function() sound:Stop() end)
                    pcall(function() sound:Destroy() end)
                    introPlaybackSound = nil
                end
            end)
            local loadStart = tick()
            while sound and not sound.IsLoaded and tick() - loadStart < 18 do task.wait(0.05) end
            if token ~= introPlaybackToken then
                pcall(function() sound:Destroy() end)
                return
            end
            if sound and sound.IsLoaded then
                pcall(function() sound.TimePosition = tonumber(option.startTime) or 0 end)
            end
            if INTRO._matchSound then pcall(function() INTRO._matchSound:Pause() end) end
        end)
    end

    local function playIntroAnimation()
        local RunService = game:GetService("RunService")
        local TS = game:GetService("TweenService")
        local pgui = LP:WaitForChild("PlayerGui", 10)
        local TextService = game:GetService("TextService")

        for _, n in ipairs({"bizarreIntro", "AceDuelsIntro", "NoxyIntro"}) do
            pcall(function() local o = CoreGui:FindFirstChild(n); if o then o:Destroy() end end)
            pcall(function() if pgui then local o = pgui:FindFirstChild(n); if o then o:Destroy() end end end)
        end

        -- Keep the script/UI active while the intro animation plays over the game.
        -- The intro is visual only; it must not pause feature logic or hide the main UI.
        _G._YassinIntroActive = false
        pcall(function()
            if main then main.Visible = true end
            if miniBtn then miniBtn.Visible = false end
            if gui then gui.Enabled = true end
        end)

        playIntroMusic()

        task.spawn(function()
            local introGui = Instance.new("ScreenGui")
            introGui.Name = "bizarreIntro"
            introGui.IgnoreGuiInset = true
            introGui.DisplayOrder = 9999
            introGui.ResetOnSpawn = false
            pcall(function() if pgui then introGui.Parent = pgui end end)
            if not introGui.Parent then pcall(function() introGui.Parent = CoreGui end) end

            local introActive = true
            local introStartedAt = tick()

            local function finishIntro()
                if not introActive then return end
                introActive = false
                -- Keep intro music playing after the visual title disappears.
                if INTRO.matchEnabled then
                    if INTRO._matchSound then
                        pcall(function() INTRO._matchSound:Resume() end)
                    else
                        INTRO.playMatch()
                    end
                end
                pcall(function() introGui:Destroy() end)
                _G._YassinIntroActive = false
                -- Single instant reveal — never call showGui slide here.
                pcall(function()
                    if gui then gui.Enabled = true end
                    if miniBtn then miniBtn.Visible = false end
                    if main then
                        local p = main.Position
                        if p.X.Scale == 0 and p.X.Offset < -50 then
                            main.Position = UDim2.new(0, 20, 0, 2)
                        end
                        main.Visible = true
                        if type(_yassinClampOnScreen) == "function" then
                            pcall(_yassinClampOnScreen, main, 0, 20, 0, 2)
                        end
                    end
                end)
            end
            -- The intro stays visible until the selected song ends; this is only a safety fallback.
            task.delay(5, finishIntro)

            local dark = Instance.new("Frame", introGui)
            dark.Size = UDim2.new(1, 0, 1, 0)
            dark.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
            dark.BackgroundTransparency = 0.18
            dark.BorderSizePixel = 0
            dark.ZIndex = 1

            local vignette = Instance.new("Frame", introGui)
            vignette.Size = UDim2.new(1, 0, 1, 0)
            vignette.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
            vignette.BackgroundTransparency = 0.45
            vignette.BorderSizePixel = 0
            vignette.ZIndex = 2
            local vigGrad = Instance.new("UIGradient", vignette)
            vigGrad.Rotation = 90
            vigGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.15),
                NumberSequenceKeypoint.new(0.35, 0.85),
                NumberSequenceKeypoint.new(0.65, 0.85),
                NumberSequenceKeypoint.new(1, 0.15),
            })

            local barTop = Instance.new("Frame", introGui)
            barTop.Size = UDim2.new(1, 0, 0, 0)
            barTop.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
            barTop.BackgroundTransparency = 0.25
            barTop.BorderSizePixel = 0
            barTop.ZIndex = 70

            local barBot = Instance.new("Frame", introGui)
            barBot.AnchorPoint = Vector2.new(0, 1)
            barBot.Position = UDim2.new(0, 0, 1, 0)
            barBot.Size = UDim2.new(1, 0, 0, 0)
            barBot.BackgroundColor3 = Color3.fromRGB(5, 5, 5)
            barBot.BackgroundTransparency = 0.25
            barBot.BorderSizePixel = 0
            barBot.ZIndex = 70

            local rift = Instance.new("Frame", introGui)
            rift.AnchorPoint = Vector2.new(0.5, 0.5)
            rift.Position = UDim2.new(0.5, 0, 0.5, 0)
            rift.Size = UDim2.new(0, 2, 0, 0)
            rift.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            rift.BorderSizePixel = 0
            rift.ZIndex = 20
            local riftGrad = Instance.new("UIGradient", rift)
            riftGrad.Rotation = 90
            riftGrad.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 1),
                NumberSequenceKeypoint.new(0.5, 0),
                NumberSequenceKeypoint.new(1, 1),
            })

            local glow = Instance.new("Frame", introGui)
            glow.AnchorPoint = Vector2.new(0.5, 0.5)
            glow.Position = UDim2.new(0.5, 0, 0.5, 0)
            glow.Size = UDim2.new(0, 8, 0, 0)
            glow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            glow.BackgroundTransparency = 0.75
            glow.BorderSizePixel = 0
            glow.ZIndex = 19

            local skipBtn = Instance.new("TextButton", introGui)
            skipBtn.Name = "SkipIntro"
            skipBtn.AnchorPoint = Vector2.new(1, 0)
            skipBtn.Position = UDim2.new(1, -22, 0, 22)
            skipBtn.Size = UDim2.new(0, 104, 0, 34)
            skipBtn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            skipBtn.BackgroundTransparency = 1
            skipBtn.BorderSizePixel = 0
            skipBtn.Text = "SKIP INTRO"
            skipBtn.TextColor3 = Color3.fromRGB(5, 5, 5)
            skipBtn.TextTransparency = 1
            skipBtn.TextSize = 11
            skipBtn.Font = Enum.Font.GothamBlack
            skipBtn.AutoButtonColor = false
            skipBtn.ZIndex = 80
            Instance.new("UICorner", skipBtn).CornerRadius = UDim.new(0, 10)
            local skipStroke = Instance.new("UIStroke", skipBtn)
            skipStroke.Color = Color3.fromRGB(255, 255, 255)
            skipStroke.Thickness = 1
            skipStroke.Transparency = 1
            skipBtn.MouseButton1Click:Connect(finishIntro)

            local sparks = {}
            for i = 1, 18 do
                local spark = Instance.new("Frame", introGui)
                spark.AnchorPoint = Vector2.new(0.5, 0.5)
                spark.Size = UDim2.new(0, math.random(2, 4), 0, math.random(8, 22))
                spark.Position = UDim2.new(0.5, 0, 0.5, 0)
                spark.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
                spark.BackgroundTransparency = 1
                spark.BorderSizePixel = 0
                spark.Rotation = math.random(0, 360)
                spark.ZIndex = 18
                Instance.new("UICorner", spark).CornerRadius = UDim.new(1, 0)
                sparks[i] = spark
            end

            -- Full-screen fire: animated orange/red flame streaks rise behind the centered title.
            local fireLayer = Instance.new("Frame", introGui)
            fireLayer.Name = "YassinFullScreenFire"
            fireLayer.Size = UDim2.new(1, 0, 1, 0)
            fireLayer.BackgroundTransparency = 1
            fireLayer.BorderSizePixel = 0
            fireLayer.ZIndex = 24
            local fireAlive = true
            local fireBits = {}
            for i = 1, 110 do
                local flame = Instance.new("Frame", fireLayer)
                flame.AnchorPoint = Vector2.new(0.5, 0.5)
                flame.BorderSizePixel = 0
                flame.BackgroundColor3 = (i % 3 == 0) and Color3.fromRGB(255, 35, 15) or Color3.fromRGB(255, 115, 12)
                flame.BackgroundTransparency = 0.18 + math.random() * 0.32
                flame.Size = UDim2.new(0, math.random(8, 24), 0, math.random(45, 145))
                flame.Position = UDim2.new(math.random(), 0, math.random(), math.random(-80, 80))
                flame.Rotation = math.random(-22, 22)
                flame.ZIndex = 24
                Instance.new("UICorner", flame).CornerRadius = UDim.new(1, 0)
                local flameGradient = Instance.new("UIGradient", flame)
                flameGradient.Rotation = 90
                flameGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 245, 105)),
                    ColorSequenceKeypoint.new(0.38, Color3.fromRGB(255, 112, 10)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(205, 0, 15)),
                })
                flameGradient.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0.05),
                    NumberSequenceKeypoint.new(0.68, 0.18),
                    NumberSequenceKeypoint.new(1, 1),
                })
                fireBits[#fireBits + 1] = flame
            end
            task.spawn(function()
                while fireLayer.Parent and introActive and fireAlive do
                    for _, flame in ipairs(fireBits) do
                        if not (fireLayer.Parent and introActive and fireAlive) then break end
                        if flame.Parent then
                            flame.Position = UDim2.new(math.random(), math.random(-12, 12), math.random(75, 125) / 100, math.random(-80, 80))
                            flame.Size = UDim2.new(0, math.random(8, 24), 0, math.random(45, 145))
                            flame.BackgroundTransparency = 0.15 + math.random() * 0.35
                            flame.Rotation = math.random(-24, 24)
                            TS:Create(flame, TweenInfo.new(0.75 + math.random() * 0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                                Position = UDim2.new(flame.Position.X.Scale, flame.Position.X.Offset, math.random(15, 65) / 100, math.random(-30, 30)),
                                BackgroundTransparency = 1,
                                Rotation = flame.Rotation + math.random(-20, 20),
                            }):Play()
                        end
                    end
                    task.wait(0.42)
                end
            end)

            local charArt = Instance.new("ImageLabel", introGui)
            charArt.AnchorPoint = Vector2.new(0.5, 1)
            charArt.Position = UDim2.new(0.5, 0, 1, 70)
            charArt.Size = UDim2.new(0, 420, 0, 560)
            charArt.BackgroundTransparency = 1
            charArt.BorderSizePixel = 0
            charArt.ImageTransparency = 1
            charArt.ScaleType = Enum.ScaleType.Fit
            charArt.ZIndex = 12
            pcall(function()
                if getcustomasset and isfile and isfile("bizarreIntroAnime.png") then
                    charArt.Image = getcustomasset("bizarreIntroAnime.png")
                elseif getcustomasset and writefile and game.HttpGet and INTRO.animeUrl and INTRO.animeUrl ~= "" then
                    local data = game:HttpGet(INTRO.animeUrl)
                    if data and #data > 0 then
                        writefile("bizarreIntroAnime.png", data)
                        charArt.Image = getcustomasset("bizarreIntroAnime.png")
                    end
                elseif INTRO.animeAsset and INTRO.animeAsset ~= "" then
                    charArt.Image = INTRO.animeAsset
                end
            end)
            local charFade = Instance.new("UIGradient", charArt)
            charFade.Rotation = 90
            charFade.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.05),
                NumberSequenceKeypoint.new(0.62, 0.22),
                NumberSequenceKeypoint.new(1, 0.92),
            })
            task.spawn(function()
                local t0 = tick()
                while charArt.Parent and introActive do
                    local t = tick() - t0
                    local bob = math.sin(t * 1.35) * 10
                    local sway = math.sin(t * 0.85) * 4
                    charArt.Position = UDim2.new(0.5, sway, 1, 10 + bob)
                    charArt.Rotation = math.sin(t * 0.7) * 1.6
                    task.wait(0.03)
                end
            end)

            local stage = Instance.new("Frame", introGui)
            stage.AnchorPoint = Vector2.new(0.5, 0.5)
            stage.Position = UDim2.new(0.5, 0, 0.5, 0)
            stage.Size = UDim2.new(0, 720, 0, 220)
            stage.BackgroundTransparency = 1
            stage.ZIndex = 40

            local halo = Instance.new("Frame", stage)
            halo.AnchorPoint = Vector2.new(0.5, 0.5)
            halo.Position = UDim2.new(0.5, 0, 0, 62)
            halo.Size = UDim2.new(0, 220, 0, 90)
            halo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            halo.BackgroundTransparency = 1
            halo.BorderSizePixel = 0
            halo.ZIndex = 43
            Instance.new("UICorner", halo).CornerRadius = UDim.new(1, 0)

            local logo = Instance.new("TextLabel", stage)
            logo.AnchorPoint = Vector2.new(0.5, 0.5)
            logo.Position = UDim2.new(0.5, 0, 0, 110)
            logo.Size = UDim2.new(0, 520, 0, 86)
            logo.BackgroundTransparency = 1
            logo.BorderSizePixel = 0
            logo.Text = "yassin on top"
            logo.Font = Enum.Font.GothamBlack
            logo.TextSize = 48
            logo.TextScaled = true
            logo.TextXAlignment = Enum.TextXAlignment.Center
            logo.TextYAlignment = Enum.TextYAlignment.Center
            local logoTextLimit = Instance.new("UITextSizeConstraint", logo)
            logoTextLimit.MinTextSize = 22
            logoTextLimit.MaxTextSize = 48
            logo.TextColor3 = getThemeColor()
            logo.TextStrokeTransparency = 0.25
            logo.TextStrokeColor3 = Color3.fromRGB(40, 10, 60)
            logo.TextTransparency = 0
            logo.Rotation = -14
            logo.ZIndex = 44
            local logoSweep = Instance.new("UIGradient", logo)
            logoSweep.Rotation = 20
            logoSweep.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 185)),
                ColorSequenceKeypoint.new(0.42, Color3.fromRGB(255, 80, 185)),
                ColorSequenceKeypoint.new(0.50, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(0.58, Color3.fromRGB(255, 80, 185)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 80, 185)),
            })
            logoSweep.Offset = Vector2.new(-1, 0)
            task.spawn(function()
                local off = -1
                while logo.Parent and introActive do
                    off = off + 0.018
                    if off > 1 then off = -1 end
                    logoSweep.Offset = Vector2.new(off, 0)
                    task.wait(0.02)
                end
            end)

            local duels = Instance.new("TextLabel", stage)
            duels.Size = UDim2.new(1, 0, 0, 36)
            duels.Position = UDim2.new(0, 0, 0, 122)
            duels.BackgroundTransparency = 1
            duels.Text = ""
            duels.TextColor3 = Color3.fromRGB(255, 255, 255)
            duels.Font = Enum.Font.GothamBold
            duels.TextSize = 22
            duels.TextTransparency = 1
            duels.ZIndex = 44

            local line = Instance.new("Frame", stage)
            line.AnchorPoint = Vector2.new(0.5, 0.5)
            line.Position = UDim2.new(0.5, 0, 0, 116)
            line.Size = UDim2.new(0, 0, 0, 1)
            line.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            line.BackgroundTransparency = 1
            line.BorderSizePixel = 0
            line.ZIndex = 43

            local sub = Instance.new("TextLabel", stage)
            sub.Size = UDim2.new(1, 0, 0, 22)
            sub.Position = UDim2.new(0, 0, 0, 164)
            sub.BackgroundTransparency = 1
            sub.Text = ""
            sub.Visible = false
            sub.TextColor3 = Color3.fromRGB(255, 80, 185)
            sub.Font = Enum.Font.GothamMedium
            sub.TextSize = 16
            sub.TextTransparency = 1
            sub.ZIndex = 44

            -- Intro subtitle: isolated effects; all layers die with introGui.
            local subtitleExiting = false
            local subtitle = Instance.new("TextLabel", stage)
            subtitle.Name = "IntroGlitchSubtitle"
            subtitle.Size = UDim2.new(1, 0, 0, 24)
            subtitle.Position = UDim2.new(0, 0, 0, 194)
            subtitle.BackgroundTransparency = 1
            subtitle.Text = ""
            subtitle.Visible = false
            subtitle.TextColor3 = Color3.fromRGB(255, 255, 255)
            subtitle.TextStrokeColor3 = Color3.fromRGB(5, 5, 5)
            subtitle.TextStrokeTransparency = 0.65
            subtitle.Font = Enum.Font.GothamMedium
            subtitle.TextSize = 16
            subtitle.TextScaled = true
            subtitle.TextXAlignment = Enum.TextXAlignment.Center
            subtitle.TextTransparency = 1
            subtitle.Visible = false
            subtitle.ZIndex = 47
            local subtitleLimit = Instance.new("UITextSizeConstraint", subtitle)
            subtitleLimit.MinTextSize = 10
            subtitleLimit.MaxTextSize = 16

            local chromaLayers = {}
            for i, color in ipairs({Color3.fromRGB(255, 255, 255), Color3.fromRGB(255, 80, 185)}) do
                local layer = subtitle:Clone()
                layer.Name = "IntroGlitchChroma" .. i
                layer.TextColor3 = color
                layer.TextStrokeTransparency = 1
                layer.ZIndex = 46
                layer.Parent = stage
                chromaLayers[i] = layer
            end
            -- Thin clipped text bands create local horizontal tears, not screen flashes.
            local glitchBands = {}
            for i, top in ipairs({5, 14}) do
                local clip = Instance.new("Frame", stage)
                clip.Name = "IntroGlitchBand" .. i
                clip.Position = UDim2.new(0, 0, 0, 194 + top)
                clip.Size = UDim2.new(1, 0, 0, 3)
                clip.BackgroundTransparency = 1
                clip.BorderSizePixel = 0
                clip.ClipsDescendants = true
                clip.Visible = false
                clip.ZIndex = 48
                local fragment = subtitle:Clone()
                fragment.Position = UDim2.new(0, 0, 0, -top)
                fragment.TextColor3 = chromaLayers[i].TextColor3
                fragment.TextStrokeTransparency = 1
                fragment.ZIndex = 49
                fragment.Parent = clip
                glitchBands[i] = {clip = clip, text = fragment, top = top}
            end

            local function subtitleIsActive()
                return introActive and not subtitleExiting and introGui.Parent ~= nil and subtitle.Parent ~= nil
            end

            -- INTRO_SUBTITLE_SCHEDULER_BEGIN
            local function scheduleIntroSubtitle(creditTween, isActive, showSubtitle)
                local completedConnection
                completedConnection = creditTween.Completed:Connect(function(playbackState)
                    if completedConnection then completedConnection:Disconnect() end
                    if playbackState ~= Enum.PlaybackState.Completed or not isActive() then return end
                    task.delay(2, function()
                        if isActive() then showSubtitle() end
                    end)
                end)
            end
            -- INTRO_SUBTITLE_SCHEDULER_END

            local function playSubtitleGlitch()
                if not subtitleIsActive() then return end
                subtitle.Visible = true
                for _, layer in ipairs(chromaLayers) do layer.Visible = true end
                for _, band in ipairs(glitchBands) do
                    band.clip.Visible = true
                    band.text.Visible = true
                end
                local steps = {
                    {x = -4, split = 3, alpha = 0.38, tear = 7, duration = 0.055},
                    {x = 3, split = -2, alpha = 0.14, tear = -6, duration = 0.065},
                    {x = 0, split = 1, alpha = 0.06, tear = 0, duration = 0.10},
                    {x = -2, split = 3, alpha = 0.26, tear = 5, duration = 0.045},
                    {x = 2, split = -2, alpha = 0.10, tear = -4, duration = 0.055},
                    {x = 0, split = 1, alpha = 0.02, tear = 0, duration = 0.12},
                    {x = 1, split = 2, alpha = 0.12, tear = 3, duration = 0.045},
                    {x = 0, split = 0, alpha = 0, tear = 0, duration = 0.10},
                }
                for _, step in ipairs(steps) do
                    if not subtitleIsActive() then return end
                    subtitle.Position = UDim2.new(0, step.x, 0, 194)
                    subtitle.TextTransparency = step.alpha
                    for i, layer in ipairs(chromaLayers) do
                        local direction = i == 1 and -1 or 1
                        layer.Position = UDim2.new(0, step.x + step.split * direction, 0, 194)
                        layer.TextTransparency = math.min(1, 0.70 + step.alpha)
                    end
                    for i, band in ipairs(glitchBands) do
                        band.clip.Visible = step.tear ~= 0
                        band.text.Position = UDim2.new(0, step.tear * (i == 1 and 1 or -1), 0, -band.top)
                        band.text.TextTransparency = 0.42
                    end
                    task.wait(step.duration)
                end
                if not subtitleIsActive() then return end
                subtitle.Position = UDim2.new(0, 0, 0, 194)
                subtitle.TextTransparency = 0
                for _, layer in ipairs(chromaLayers) do layer.Visible = false end
                for _, band in ipairs(glitchBands) do band.clip.Visible = false end
                -- No idle flicker: the message remains readable until the normal exit.
            end

            local flash = Instance.new("Frame", introGui)
            flash.Size = UDim2.new(1, 0, 1, 0)
            flash.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            flash.BackgroundTransparency = 1
            flash.BorderSizePixel = 0
            flash.ZIndex = 90

            TS:Create(dark, TweenInfo.new(0.45), {BackgroundTransparency = 0.62}):Play()
            TS:Create(vignette, TweenInfo.new(0.5), {BackgroundTransparency = 0.7}):Play()
            task.wait(0.28)
            if not introActive then return end

            for _, spark in ipairs(sparks) do
                local ang = math.rad(math.random(0, 360))
                local dist = 80 + math.random() * 220
                TS:Create(spark, TweenInfo.new(0.55, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Position = UDim2.new(0.5, math.cos(ang) * dist, 0.5, math.sin(ang) * dist),
                    BackgroundTransparency = 0.15,
                    Rotation = spark.Rotation + 80,
                }):Play()
                task.delay(0.35, function()
                    if spark.Parent then
                        TS:Create(spark, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
                    end
                end)
            end

            task.wait(0.18)
            if not introActive then return end
            TS:Create(charArt, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                ImageTransparency = 0.22,
                Position = UDim2.new(0.5, 0, 1, 10),
            }):Play()
            TS:Create(logo, TweenInfo.new(0.62, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
                Position = UDim2.new(0.5, 0, 0, 110),
                Size = UDim2.new(0, 600, 0, 94),
                TextTransparency = 0,
                Rotation = 0,
            }):Play()
            task.delay(0.62, function()
                if not introActive or not logo.Parent then return end
                TS:Create(logo, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                    Size = UDim2.new(0, 580, 0, 90),
                }):Play()
            end)

            task.wait(0.48)
            if not introActive then return end
            TS:Create(line, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 280, 0, 1),
                BackgroundTransparency = 0.05,
            }):Play()
            TS:Create(duels, TweenInfo.new(0.4), {TextTransparency = 0}):Play()
            local creditTween = TS:Create(sub, TweenInfo.new(0.45), {TextTransparency = 0.08})
            scheduleIntroSubtitle(creditTween, subtitleIsActive, playSubtitleGlitch)
            creditTween:Play()
            TS:Create(skipBtn, TweenInfo.new(0.3), {BackgroundTransparency = 0.08, TextTransparency = 0}):Play()
            TS:Create(skipStroke, TweenInfo.new(0.3), {Transparency = 0.12}):Play()
            -- rift/glow/halo stay hidden

            local shakeConn
            local shakeExiting = false
            do
                local smooth = 0
                local st = 0
                local lastHit = 0
                shakeConn = RunService.RenderStepped:Connect(function(dt)
                    if not introActive or shakeExiting then
                        if shakeConn then pcall(function() shakeConn:Disconnect() end) end
                        return
                    end
                    st = st + dt
                    local loud = 0
                    pcall(function()
                        if introPlaybackSound and introPlaybackSound.Parent and introPlaybackSound.IsPlaying then
                            loud = introPlaybackSound.PlaybackLoudness
                        end
                    end)
                    local target = math.clamp(loud / 280, 0, 1)
                    smooth = smooth + (target - smooth) * math.clamp(dt * 18, 0, 1)
                    local amp = 0.8 + smooth * 7
                    local ox = math.noise(st * 24, 0.7) * amp
                    local oy = math.noise(1.4, st * 26) * amp
                    local pulse = 580 + math.floor(smooth * 28 + 0.5)
                    local pulseH = 90 + math.floor(smooth * 6 + 0.5)
                    logo.Position = UDim2.new(0.5, ox, 0, 110 + oy)
                    logo.Size = UDim2.new(0, pulse, 0, pulseH)
                    line.BackgroundTransparency = 0.05
                end)
            end

            do
                -- Keep the fire/title visible for exactly five seconds, independent of song length.
                local elapsed = tick() - introStartedAt
                task.wait(math.max(0, 5 - elapsed))
            end
            if not introActive then return end
            fireAlive = false
            subtitleExiting = true
            for _, layer in ipairs(chromaLayers) do layer.Visible = false end
            for _, band in ipairs(glitchBands) do band.clip.Visible = false end
            TS:Create(subtitle, TweenInfo.new(0.28), {TextTransparency = 1}):Play()
            shakeExiting = true
            if shakeConn then pcall(function() shakeConn:Disconnect() end) end

            -- no flash overlay
            TS:Create(charArt, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
                ImageTransparency = 1,
                Position = UDim2.new(0.5, 0, 1, 80),
            }):Play()
            TS:Create(logo, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                Size = UDim2.new(0, 620, 0, 98),
            }):Play()
            task.delay(0.16, function()
                if not logo.Parent then return end
                TS:Create(logo, TweenInfo.new(0.42, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
                    Position = UDim2.new(0.5, 0, 0, 110),
                    Size = UDim2.new(0, 12, 0, 4),
                    TextTransparency = 1,
                    Rotation = 12,
                }):Play()
            end)
            TS:Create(duels, TweenInfo.new(0.32), {TextTransparency = 1}):Play()
            TS:Create(sub, TweenInfo.new(0.28), {TextTransparency = 1}):Play()
            TS:Create(line, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Size = UDim2.new(0, 0, 0, 1),
                BackgroundTransparency = 1,
            }):Play()
            TS:Create(skipBtn, TweenInfo.new(0.2), {BackgroundTransparency = 1, TextTransparency = 1}):Play()
            TS:Create(skipStroke, TweenInfo.new(0.2), {Transparency = 1}):Play()
            TS:Create(dark, TweenInfo.new(0.7), {BackgroundTransparency = 1}):Play()
            TS:Create(vignette, TweenInfo.new(0.55), {BackgroundTransparency = 1}):Play()
            TS:Create(fireLayer, TweenInfo.new(0.65), {BackgroundTransparency = 1}):Play()
            task.wait(0.75)
            finishIntro()
        end)
    end

    INTRO.OPTIONS = INTRO_MUSIC_OPTIONS
    INTRO.stopPreview = stopIntroPreview
    INTRO.stopPlayback = stopIntroPlayback
    INTRO.getSongName = getIntroSongName
    INTRO.preview = previewIntroMusic
    INTRO.play = playIntroAnimation
    INTRO._matchToken = 0

    INTRO.stopMatch = function()
        INTRO._matchToken = (INTRO._matchToken or 0) + 1
        if INTRO._matchSound then
            pcall(function() INTRO._matchSound:Stop() end)
            pcall(function() INTRO._matchSound:Destroy() end)
            INTRO._matchSound = nil
        end
        pcall(function()
            if _G.bizarreMatchUI and _G.bizarreMatchUI.refresh then _G.bizarreMatchUI.refresh() end
        end)
    end

    INTRO.MATCH_OPTIONS = {
        {name="Yo Voy Voy", url="https://litter.catbox.moe/xkew3553w380fzfb.mp3", file="bizarreIntroSong_10.mp3"},
        {name="Tryhard", assetId="rbxassetid://77142753938657", volume=0.7},
        {name="Tryhard BR 1", assetId="rbxassetid://135750430892149", volume=0.7},
        {name="STRINGS FUNK", url="https://litter.catbox.moe/rvi4fpjia6bgvzi3.mp3", file="MiseryMatchSong_4.mp3"},
        {name="CUIDA DO PET", url="https://litter.catbox.moe/dw8fcc21n2cjtr20.mp3", file="MiseryMatchSong_5.mp3"},
        {name="Ultra Maligna", url="https://litter.catbox.moe/e3bu4b0q7hxx1i1k.mp3", file="MiseryMatchSong_6.mp3"},
        {name="Tryhard BR 2", url="https://litter.catbox.moe/0fq7y2kjpxn7wc6b.mp3", file="MiseryMatchSong_7.mp3"},
    }

    INTRO.getMatchSongName = function()
        local opt = INTRO.MATCH_OPTIONS[INTRO.matchMusic]
        return opt and opt.name or "No Song"
    end

    INTRO.playMatch = function()
        INTRO.stopMatch()
        if not INTRO.matchEnabled then return end
        local option = INTRO.MATCH_OPTIONS[INTRO.matchMusic]
        if not option then return end
        local token = INTRO._matchToken
        task.spawn(function()
            local sound = createIntroSound(option, "MiseryMatchMusic_" .. tostring(token), SoundService, true)
            if token ~= INTRO._matchToken then
                if sound then pcall(function() sound:Destroy() end) end
                return
            end
            INTRO._matchSound = sound
            if not sound then return end
            sound.Looped = false
            sound.Volume = option.volume or 0.65
            local loadStart = tick()
            while sound and not sound.IsLoaded and tick() - loadStart < 15 do task.wait(0.05) end
            if token ~= INTRO._matchToken then return end
            sound.TimePosition = 0
            pcall(function() sound:Play() end)
            pcall(function()
                sound.Ended:Connect(function()
                    if token == INTRO._matchToken and INTRO.matchEnabled and INTRO._matchSound == sound then
                        sound.TimePosition = 0
                        pcall(function() sound:Play() end)
                    end
                end)
            end)
            pcall(function()
                if _G.bizarreMatchUI and _G.bizarreMatchUI.refresh then _G.bizarreMatchUI.refresh() end
            end)
        end)
    end

    preloadIntroSongs()
end)()


-- Intro is started after the UI is built in the boot sequence at the bottom.
-- Starting it here hid the script forever when layout was saved off-screen during hideGui.

function saveSkipIntroSetting() if markSettingsDirty then markSettingsDirty() end end
function setSkipIntro(enabled)
    if INTRO then INTRO.look = (enabled == true) end
    skipIntroEnabled = (enabled == true)
    if markSettingsDirty then markSettingsDirty() end
end

-- ANTI RAGDOLL — complete V1 + V2 system transferred from AmbitiousTest.
-- AntiBat's pulse logic is untouched; recovery velocity writes defer to AntiBat/Speed.
local AntiRagdollV2 = { Enabled = false, Connection = nil, ResetCooldown = 0 }
local antiRagdollConn = nil

-- antiRagdollMode su _G per non consumare local slot: "V1" o "V2"
_G._AmbitiousAntiRagdollMode = _G._AmbitiousAntiRagdollMode or "V1"

-- ===== ANTI RAGDOLL V2 =====
_G._AmbitiousARV2 = _G._AmbitiousARV2 or {conn = nil, cached = {}}
do
  local _arv2 = _G._AmbitiousARV2
  local _camera = workspace.CurrentCamera

  local function _arv2Cache()
    local char = LP.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root then return false end
    _arv2.cached = {character = char, humanoid = hum, root = root}
    _camera.CameraSubject = hum
    return true
  end

  local function _arv2IsRagdolled()
    local hum = _arv2.cached.humanoid
    if not hum then return false end
    local st = hum:GetState()
    if st == Enum.HumanoidStateType.Physics
    or st == Enum.HumanoidStateType.Ragdoll
    or st == Enum.HumanoidStateType.FallingDown then return true end
    local et = LP:GetAttribute("RagdollEndTime")
    if et then
      if (et - workspace:GetServerTimeNow()) > 0 then return true end
    end
    return false
  end

  local function _arv2RemoveConstraints()
    local char = _arv2.cached.character
    if not char then return end
    for _, v in ipairs(char:GetDescendants()) do
      if v:IsA("BallSocketConstraint") or
         (v:IsA("Attachment") and v.Name:find("RagdollAttachment")) then
        pcall(function() v:Destroy() end)
      end
    end
  end

  local function _arv2ForceExit()
    local hum = _arv2.cached.humanoid
    local root = _arv2.cached.root
    if not hum or not root then return end
    pcall(function() LP:SetAttribute("RagdollEndTime", workspace:GetServerTimeNow()) end)
    if hum.Health > 0 then hum:ChangeState(Enum.HumanoidStateType.Running) end
    root.Anchored = false
    -- Do not overwrite the source AntiBat pulse or Speed's intended X/Z velocity.
    local desiredXZ = _G._AmbitiousAntiBatDesiredXZ
    local antiBatPulse = (_G._AmbitiousAntiBatSpiking == true)
    if antiBatPulse then
      -- Leave the live AntiBat pulse untouched; its own loop restores X/Z.
    elseif typeof(desiredXZ) == "Vector3" then
      local current = root.AssemblyLinearVelocity
      root.AssemblyLinearVelocity = Vector3.new(desiredXZ.X, current.Y, desiredXZ.Z)
    else
      root.AssemblyLinearVelocity = Vector3.zero
    end
    root.AssemblyAngularVelocity = Vector3.zero
    root.CFrame = CFrame.new(root.Position) * CFrame.Angles(0, math.rad(root.Orientation.Y), 0)
    if _camera.CameraSubject ~= hum then _camera.CameraSubject = hum end
  end

  function _G._AmbitiousStartARV2()
    if _arv2.conn then return end
    if not _arv2Cache() then return end
    _arv2.conn = RunService.RenderStepped:Connect(function()
      if not _arv2.cached.humanoid or not _arv2.cached.humanoid.Parent then return end
      if _arv2IsRagdolled() then
        _arv2RemoveConstraints()
        _arv2ForceExit()
      end
    end)
  end

  function _G._AmbitiousStopARV2()
    if _arv2.conn then
      _arv2.conn:Disconnect()
      _arv2.conn = nil
    end
    _arv2.cached = {}
  end

  function _G._AmbitiousRestartARV2()
    _G._AmbitiousStopARV2()
    task.wait(0.5)
    if antiRagdollEnabled and _G._AmbitiousAntiRagdollMode == "V2" then
      _arv2Cache()
      _G._AmbitiousStartARV2()
    end
  end
end
-- ===== FINE ANTI RAGDOLL V2 =====

-- ===== ANTI RAGDOLL V1 (Ambitious — full original, old system removed) =====
local function _arv1ResetCharacter(char)
    local hum = char:FindFirstChildOfClass("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not hum or not root or hum.Health <= 0 then return end
    pcall(function()
        hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        hum:ChangeState(Enum.HumanoidStateType.Running)
        -- Coordinate recovery with Speed and AntiBat: never erase an active
        -- AntiBat pulse; otherwise restore the speed module's published X/Z.
        local desiredXZ = _G._AmbitiousAntiBatDesiredXZ
        local antiBatPulse = (_G._AmbitiousAntiBatSpiking == true)
        local currentVelocity = root.AssemblyLinearVelocity
        if antiBatPulse then
            -- AntiBat owns this frame; its pulse loop restores velocity.
        elseif typeof(desiredXZ) == "Vector3" then
            root.AssemblyLinearVelocity = Vector3.new(desiredXZ.X, currentVelocity.Y, desiredXZ.Z)
        else
            root.AssemblyLinearVelocity = Vector3.zero
        end
        root.RotVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
        hum.PlatformStand = false
        hum.Sit = false
        hum.AutoRotate = true
        hum.JumpPower = hum.JumpPower > 0 and hum.JumpPower or 50
        hum.WalkSpeed = hum.WalkSpeed > 0 and hum.WalkSpeed or 16
        for _, obj in ipairs(char:GetDescendants()) do
            if obj:IsA("Motor6D") then
                obj.Enabled = true
            elseif obj:IsA("Constraint") or obj:IsA("BallSocketConstraint") or obj:IsA("HingeConstraint") then
                obj.Enabled = true
            elseif obj:IsA("BasePart") then
                obj.CanCollide = true
                -- All connected character parts share the assembly velocity.
                obj.AssemblyAngularVelocity = Vector3.zero
            end
        end
        workspace.CurrentCamera.CameraSubject = hum
        local ps = LP:FindFirstChild("PlayerScripts")
        local PM = ps and ps:FindFirstChild("PlayerModule")
        if PM then
            local CM = PM:FindFirstChild("ControlModule")
            if CM then
                local ok, mod = pcall(require, CM)
                if ok and mod and mod.Enable then pcall(mod.Enable, mod) end
            end
        end
    end)
end

local function _startAntiRagdollV1()
    if antiRagdollConn then return end
    AntiRagdollV2.Enabled = true
    local trackedCharacter = nil
    local lastSafeCFrame = nil
    antiRagdollConn = RunService.Heartbeat:Connect(function()
        if not antiRagdollEnabled then return end
        -- Drop owns vertical movement briefly; Anti-Ragdoll's 60-stud/s clamp
        -- and recovery-state logic would otherwise overwrite VX7's 155 burst.
        if dropActive then return end
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local root = char:FindFirstChild("HumanoidRootPart")
        if not hum or not root or hum.Health <= 0 then return end

        -- Reset the saved recovery point after respawn; remember only grounded positions.
        if trackedCharacter ~= char then
            trackedCharacter = char
            lastSafeCFrame = nil
        end
        pcall(function()
            if hum.FloorMaterial ~= Enum.Material.Air
                and root.Position.Y > workspace.FallenPartsDestroyHeight + 50 then
                lastSafeCFrame = root.CFrame
            end
        end)

        -- Coordinate Anti-Ragdoll's safety clamp with Speed and AntiBat.
        pcall(function()
            local vel = root.AssemblyLinearVelocity
            local desiredXZ = _G._AmbitiousAntiBatDesiredXZ
            local antiBatPulse = (_G._AmbitiousAntiBatSpiking == true)
            local preserveHorizontal = antiBatPulse or typeof(desiredXZ) == "Vector3"
            local horizontal = Vector3.new(vel.X, 0, vel.Z)
            local maxHorizontal = 55
            local maxUp = 60
            local maxDown = 90
            local changed = false
            if not preserveHorizontal and horizontal.Magnitude > maxHorizontal then
                horizontal = horizontal.Unit * maxHorizontal
                changed = true
            end
            local y = vel.Y
            if y > maxUp then y = maxUp; changed = true end
            if y < -maxDown then y = -maxDown; changed = true end
            if changed then
                local x, z = vel.X, vel.Z
                if not preserveHorizontal then x, z = horizontal.X, horizontal.Z end
                root.AssemblyLinearVelocity = Vector3.new(x, y, z)
            end
        end)

        -- If launched below the map, recover position without cancelling an
        -- active Speed target or AntiBat pulse.
        pcall(function()
            if lastSafeCFrame and root.Position.Y < workspace.FallenPartsDestroyHeight + 20 then
                root.CFrame = lastSafeCFrame + Vector3.new(0, 3, 0)
                local current = root.AssemblyLinearVelocity
                local desiredXZ = _G._AmbitiousAntiBatDesiredXZ
                local antiBatPulse = (_G._AmbitiousAntiBatSpiking == true)
                if not antiBatPulse and typeof(desiredXZ) == "Vector3" then
                    root.AssemblyLinearVelocity = Vector3.new(desiredXZ.X, 0, desiredXZ.Z)
                elseif not antiBatPulse then
                    root.AssemblyLinearVelocity = Vector3.zero
                else
                    root.AssemblyLinearVelocity = Vector3.new(current.X, 0, current.Z)
                end
                root.AssemblyAngularVelocity = Vector3.zero
                hum:ChangeState(Enum.HumanoidStateType.GettingUp)
            end
        end)

        local state = hum:GetState()
        if state == Enum.HumanoidStateType.Physics or
           state == Enum.HumanoidStateType.Ragdoll or
           state == Enum.HumanoidStateType.FallingDown or
           state == Enum.HumanoidStateType.Dead or
           hum.PlatformStand == true or
           hum.Sit == true then
            _arv1ResetCharacter(char)
        end
    end)
    AntiRagdollV2.Connection = antiRagdollConn
end
-- ===== FINE ANTI RAGDOLL V1 (Ambitious) =====

local function startAntiRagdoll()
    antiRagdollEnabled = true
    antiRagdollVersion = "v1"
    _G._AmbitiousAntiRagdollMode = "V1"
    -- Always V1 only (Ambitious full) — strip any previous custom recovery
    if antiRagdollConn then
        pcall(function() antiRagdollConn:Disconnect() end)
        antiRagdollConn = nil
    end
    if _G._AmbitiousStopARV2 then pcall(_G._AmbitiousStopARV2) end
    _startAntiRagdollV1()
end

local function stopAntiRagdoll()
    antiRagdollEnabled = false
    if antiRagdollConn then
        pcall(function() antiRagdollConn:Disconnect() end)
        antiRagdollConn = nil
    end
    if _G._AmbitiousStopARV2 then pcall(_G._AmbitiousStopARV2) end
    AntiRagdollV2.Connection = nil
    AntiRagdollV2.Enabled = false
end

local function setAntiRagdoll(on)
    antiRagdollEnabled = on and true or false
    if antiRagdollEnabled then
        startAntiRagdoll()
    else
        stopAntiRagdoll()
    end
end

function startAntiRagdollV2()
    -- Force Ambitious V1 path only (user requested full V1)
    _G._AmbitiousAntiRagdollMode = "V1"
    antiRagdollVersion = "v1"
    startAntiRagdoll()
end
function stopAntiRagdollV2() stopAntiRagdoll() end
function AntiRagdollV2.start() if antiRagdollEnabled then startAntiRagdoll() end end
function AntiRagdollV2.stop() stopAntiRagdoll() end
function AntiRagdollV2.isRunning()
    local connected = false
    if antiRagdollConn then pcall(function() connected = antiRagdollConn.Connected == true end) end
    return connected == true
end

function setAntiRagdollEnabled(enabled)
    antiRagdollEnabled = enabled == true
    if antiRagdollEnabled then startAntiRagdoll() else stopAntiRagdoll() end
    if markSettingsDirty then pcall(markSettingsDirty) end
end

function setAntiRagdollVersion(version)
    local v = tostring(version or "v1"):lower()
    if v ~= "v2" then v = "v1" end
    antiRagdollVersion = v
    _G._AmbitiousAntiRagdollMode = v:upper()
    if antiRagdollEnabled then
        stopAntiRagdoll()
        antiRagdollEnabled = true
        startAntiRagdoll()
    end
    if markSettingsDirty then pcall(markSettingsDirty) end
end


-- # MEDUSA COUNTER
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

-- # ESP
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

-- # ANTI LAG
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

-- # SPEED INDICATOR
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
    raptureLinkLabel.Text = "Yassin On Top"
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
    bestScripLabel.Text = "discord.gg/dm3SeVRU5X"
    bestScripLabel.TextColor3 = getThemeColor()
    bestScripLabel.Font = Enum.Font.GothamBold
    bestScripLabel.TextSize = 14
    bestScripLabel.TextScaled = false
    bestScripLabel.TextWrapped = false
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

    end

local unwalkSavedAnimate = nil
unwalkEnabled = false
playerAnimEnabled = false
playerAnimMode = "Unwalk"

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

-- Clear any cached movement direction when switching modes so the previous
-- mode cannot keep applying stale velocity for an extra frame.
local function clearCachedMoveDirection()
    lastMoveDir = _V3zero
    _G.__RaptureLiveSpeed = nil
end

function toggleCarryMode()
    if speedMode then speedMode = false
    else speedMode = true; laggerToggled = false; laggerCarryToggled = false end
    clearCachedMoveDirection()
    resetMovementState()
    markSettingsDirty()
end

function toggleLaggerMode()
    if laggerToggled then laggerToggled = false
    else laggerToggled = true; speedMode = false; laggerCarryToggled = false end
    clearCachedMoveDirection()
    resetMovementState()
    markSettingsDirty()
end

function toggleLaggerCarryMode()
    if laggerCarryToggled then laggerCarryToggled = false
    else laggerCarryToggled = true; speedMode = false; laggerToggled = false end
    clearCachedMoveDirection()
    resetMovementState()
    markSettingsDirty()
end

function toggleLaggerCycle()
    -- Stay inside Lagger modes only (never auto-return to Normal speed).
    if speedMode then
        -- Carry → Lagger
        speedMode = false
        laggerToggled = true
        laggerCarryToggled = false
    elseif laggerToggled then
        -- Lagger → Lagger Carry
        speedMode = false
        laggerToggled = false
        laggerCarryToggled = true
    elseif laggerCarryToggled then
        -- Lagger Carry → Lagger (keep lagger family; do NOT go Normal)
        speedMode = false
        laggerToggled = true
        laggerCarryToggled = false
    else
        -- Off / Normal → Lagger
        speedMode = false
        laggerToggled = true
        laggerCarryToggled = false
    end
    clearCachedMoveDirection()
    resetMovementState()
    refreshSpeedModeLabel()
    markSettingsDirty()
end

-- # AUTO LEFT / RIGHT
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
                -- Auto Left is a one-shot action; persist its completed/off state.
                if markSettingsDirty then markSettingsDirty() end
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

-- # AIMBOT V1
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

local _lastContinuousBatSwing = 0
local _continuousBatSwingInterval = 0.04 -- VX7 HIT_COOLDOWN
-- Bat-only auto-hit shared by Normal and Bypass.
local _autoBatHasEquippedBat = false
local _autoBatInitialEquipPending = false
local _autoBatManualToolOverride = false
local _autoBatAttackConn = nil
local _autoBatToolCharacter = nil
local _autoBatToolWatchCharacter = nil
local _autoBatToolWatchConnections = {}
local _autoBatToolWatchBackpack = nil

local function _isBatOrSlapTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    local n = tostring(tool.Name or ""):lower()
    return n:find("bat", 1, true) ~= nil or n:find("slap", 1, true) ~= nil
end

local function _disconnectAutoBatToolWatch()
    for _, connection in ipairs(_autoBatToolWatchConnections) do
        pcall(function() connection:Disconnect() end)
    end
    table.clear(_autoBatToolWatchConnections)
    _autoBatToolWatchCharacter = nil
    _autoBatToolWatchBackpack = nil
end

local function _updateAutoBatToolState(character, humanoid)
    character = character or LP.Character
    if not character then return false end
    humanoid = humanoid or character:FindFirstChildOfClass("Humanoid")

    -- Character replacement (respawn) gets exactly one fresh initial equip attempt.
    if _autoBatToolCharacter ~= character then
        _autoBatToolCharacter = character
        _autoBatHasEquippedBat = false
        _autoBatInitialEquipPending = true
        _autoBatManualToolOverride = false
    end

    local equipped = character:FindFirstChildOfClass("Tool")
    if _isBatOrSlapTool(equipped) then
        _autoBatHasEquippedBat = true
        _autoBatInitialEquipPending = false
        _autoBatManualToolOverride = false
        return true
    end

    -- Consume the initial request BEFORE calling EquipTool. The old version left
    if _autoBatInitialEquipPending and not _autoBatManualToolOverride then
        _autoBatInitialEquipPending = false
        local bat = findBat()
        if bat and humanoid and humanoid.Health > 0 then
            pcall(function() humanoid:EquipTool(bat) end)
        end
        return false
    end

    -- Only an actually equipped non-bat tool establishes a manual override.
    -- A short nil-tool gap while Roblox swaps hotbar tools must not latch the state.
    if equipped and equipped:IsA("Tool") then
        _autoBatManualToolOverride = true
        _autoBatHasEquippedBat = false
    end
    -- When the user equips a bat again, the first branch above clears the override.
    return false
end

local function _watchAutoBatToolState(character)
    if not character or _autoBatToolWatchCharacter == character then return end
    _disconnectAutoBatToolWatch()
    _autoBatToolWatchCharacter = character

    local function scheduleRefresh()
        task.defer(function()
            if not autoBatEnabled or LP.Character ~= character then return end
            _updateAutoBatToolState(character, character:FindFirstChildOfClass("Humanoid"))
        end)
    end

    table.insert(_autoBatToolWatchConnections, character.ChildAdded:Connect(function(child)
        if child:IsA("Tool") then scheduleRefresh() end
    end))
    table.insert(_autoBatToolWatchConnections, character.ChildRemoved:Connect(function(child)
        if child:IsA("Tool") then scheduleRefresh() end
    end))

    local backpack = LP:FindFirstChildOfClass("Backpack")
    if backpack then
        _autoBatToolWatchBackpack = backpack
        table.insert(_autoBatToolWatchConnections, backpack.ChildAdded:Connect(function(child)
            if child:IsA("Tool") then scheduleRefresh() end
        end))
        table.insert(_autoBatToolWatchConnections, backpack.ChildRemoved:Connect(function(child)
            if child:IsA("Tool") then scheduleRefresh() end
        end))
    end
end

function trySwing()
    pcall(function()
        local char = LP.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local currentTool = char:FindFirstChildOfClass("Tool")

        -- Never auto-activate Medusa or any other non-bat tool. Equip the bat
        -- first, then only send activation to the bat/slap tool.
        if not _isBatOrSlapTool(currentTool) then
            _updateAutoBatToolState(char, hum)
            currentTool = char:FindFirstChildOfClass("Tool")
        end
        if not _isBatOrSlapTool(currentTool) then return end

        local now = tick()
        if now - _lastContinuousBatSwing >= _continuousBatSwingInterval then
            _lastContinuousBatSwing = now
            pcall(function() currentTool:Activate() end)
            pcall(function()
                local ev = currentTool:FindFirstChildWhichIsA("RemoteEvent", true)
                if ev then ev:FireServer() end
            end)
        end
    end)
end


-- Source CleanHub speed bridge: preserve this script's existing speed-mode controls.
_G.AceAntiBypassAimbotSpeed = _G.AceAntiBypassAimbotSpeed or 60
_G.AceAntiBypassLaggerAimbotSpeed = _G.AceAntiBypassLaggerAimbotSpeed or 40
_G.AceGetAntiBypassAimbotSpeed = function()
    if laggerToggled or laggerCarryToggled then
        return tonumber(_G.AceAntiBypassLaggerAimbotSpeed) or 40
    end
    return tonumber(_G.AceAntiBypassAimbotSpeed) or 60
end

-- BAT BYPASS — Persecución autónoma con predicción de ping
-- (Reemplaza el módulo Anti Bypass anterior. Antes BAT V2.)

local BAT_V2_SPEED           = 55
local BAT_V2_HIT_DIST        = 13
local BAT_V2_LEAD_STUDS      = 3
local BAT_V2_BODY_LOCK_RANGE = 60

local SnowVS = _G.SnowVS or {}
_G.SnowVS = SnowVS

SnowVS.BatBypass = SnowVS.BatBypass or {}
-- Alias legado para no romper referencias externas existentes
SnowVS.AimbotBypassV2 = SnowVS.BatBypass

local BB = SnowVS.BatBypass
-- Replace any previously running legacy bypass connection before adopting this source module.
if BB.Connection then pcall(function() BB.Connection:Disconnect() end) end
BB.Connection = nil
BB.Enabled = false

BB.Enabled    = BB.Enabled    or false
BB.Connection = BB.Connection or nil

BB.Z = BB.Z or {
    targetPlayer          = nil,
    lastTargetPos         = nil,
    targetVelocity        = Vector3.zero,
    smoothedVelocity      = Vector3.zero,
    velocityHistory       = {},
    accelerationHistory   = {},
    aerialVelocityHistory = {},
    previousDirection     = nil,
    lastDirectionChangeTime = 0,
    airborneTime          = 0,
    lastActivationTime    = 0,
    currentPing           = 0.1,
    realPingMs            = 0,
}

BB.ZCFG = BB.ZCFG or {
    FOLLOW_SPEED                    = BAT_V2_SPEED,
    ACTIVATE_DISTANCE               = BAT_V2_HIT_DIST,
    MIN_FOLLOW_DISTANCE             = 1,
    PREDICTION_TIME                 = 0.22,
    PREDICT_AHEAD                   = BAT_V2_LEAD_STUDS,
    MAX_VELOCITY_CHANGE             = 150,
    VELOCITY_SMOOTHING              = 0.2,
    MAX_HORIZONTAL_VELOCITY         = 80,
    SERVER_TICKRATE                 = 1 / 60,
    MIN_PING_COMPENSATION           = 0.03,
    MAX_PING_COMPENSATION           = 0.25,
    ACCELERATION_PREDICTION_WEIGHT  = 0.3,
    DIRECTION_CHANGE_DETECTION_TIME = 0.12,
    QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
    GRAVITY                         = 196.2,
    AIR_CONTROL_FACTOR              = 0.8,
    MIN_AIRBORNE_TIME               = 0.08,
}

local function bbAverageVector(history)
    if #history == 0 then return Vector3.zero end
    local total = Vector3.zero
    for _, v in ipairs(history) do total += v end
    return total / #history
end

local function bbPushHistory(history, value, maximum)
    table.insert(history, value)
    if #history > maximum then table.remove(history, 1) end
end

function BB.FindBat()
    local char = LP.Character
    if not char then return nil end
    local equipped = char:FindFirstChildOfClass("Tool")
    if equipped then
        local n = equipped.Name:lower()
        if n:find("bat", 1, true) or n:find("slap", 1, true) then
            return equipped
        end
    end
    local bp = LP:FindFirstChildOfClass("Backpack")
    if bp then
        for _, tool in ipairs(bp:GetChildren()) do
            if tool:IsA("Tool") then
                local n = tool.Name:lower()
                if n:find("bat", 1, true) or n:find("slap", 1, true) then
                    return tool
                end
            end
        end
    end
    return nil
end

local function bbResetTarget()
    local Z = BB.Z
    Z.targetPlayer          = nil
    Z.lastTargetPos         = nil
    Z.targetVelocity        = Vector3.zero
    Z.smoothedVelocity      = Vector3.zero
    Z.velocityHistory       = {}
    Z.accelerationHistory   = {}
    Z.aerialVelocityHistory = {}
    Z.previousDirection     = nil
    Z.airborneTime          = 0
end

local function bbNearestTarget(root)
    local nearest, nearestDistance = nil, math.huge
    for _, candidate in ipairs(Players:GetPlayers()) do
        if candidate ~= LP and candidate.Character then
            local targetRoot     = candidate.Character:FindFirstChild("HumanoidRootPart")
            local targetHumanoid = candidate.Character:FindFirstChildOfClass("Humanoid")
            if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
                local distance = (root.Position - targetRoot.Position).Magnitude
                if distance < nearestDistance then
                    nearest, nearestDistance = candidate, distance
                end
            end
        end
    end
    return nearest
end

local function bbRotateRoot(root, direction)
    if direction.Magnitude < 0.01 then return end
    local axis  = root.CFrame.LookVector:Cross(direction.Unit)
    local angle = math.asin(math.clamp(axis.Magnitude, -1, 1))
    root.AssemblyAngularVelocity = axis.Magnitude > 0.01
        and axis.Unit * angle * 80
        or  Vector3.zero
end

local function bbSamplePing()
    local ok, value = pcall(function()
        return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
    end)
    local Z = BB.Z
    if ok and type(value) == "number" then Z.realPingMs = math.floor(value) end
    Z.currentPing = math.clamp(
        Z.realPingMs / 1000,
        BB.ZCFG.MIN_PING_COMPENSATION,
        BB.ZCFG.MAX_PING_COMPENSATION
    )
end

BB.PingLoopStarted = BB.PingLoopStarted or false
if not BB.PingLoopStarted then
    BB.PingLoopStarted = true
    task.spawn(function()
        while true do
            pcall(bbSamplePing)
            task.wait(0.5)
        end
    end)
end

-- Stubs para compatibilidad con la API antigua (Body Lock ya no se usa aparte)
function BB.StartBodyLock() end
function BB.StopBodyLock()  end

function BB.Stop()
    local Z = BB.Z
    BB.Enabled = false
    if BB.Connection then
        BB.Connection:Disconnect()
        BB.Connection = nil
    end
    local char     = LP.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local root     = char and char:FindFirstChild("HumanoidRootPart")
    if humanoid then humanoid.AutoRotate = true end
    if root     then root.AssemblyAngularVelocity = Vector3.zero end
    bbResetTarget()
    Z.lastActivationTime = 0
end

function BB.Start()
    if BB.Connection then return end

    local char = LP.Character
    local humanoid = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then return end

    BB.Enabled = true
    humanoid.AutoRotate = false

    -- Shared bat-only logic prioritizes equipping the bat while Aimbot is on;
    -- other tools are never automatically activated.
    pcall(function() _updateAutoBatToolState(char, humanoid) end)

    -- VX7 Normal Aimbot movement/rotation ported into Yassin's existing Bypass
    -- controller. Keep the existing Yassin toggle, tool-selection and hit gate.
    local pred = {}
    local moverName = "VX7AimbotMoveVelocity"
    local attachmentName = "VX7AimbotMoveAttachment"

    local function clearMover(part)
        part = part or (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"))
        if not part then return end
        for _, name in ipairs({moverName, attachmentName}) do
            local obj = part:FindFirstChild(name)
            if obj then pcall(function() obj:Destroy() end) end
        end
    end

    local function applyMove(part, velocity, speed, dt)
        local attachment = part:FindFirstChild(attachmentName)
        if attachment and not attachment:IsA("Attachment") then
            attachment:Destroy()
            attachment = nil
        end
        if not attachment then
            attachment = Instance.new("Attachment")
            attachment.Name = attachmentName
            attachment.Parent = part
        end

        local mover = part:FindFirstChild(moverName)
        if not mover or not mover:IsA("LinearVelocity") then
            if mover then mover:Destroy() end
            mover = Instance.new("LinearVelocity")
            mover.Name = moverName
            mover.Attachment0 = attachment
            mover.RelativeTo = Enum.ActuatorRelativeTo.World
            mover.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector
            mover.ForceLimitsEnabled = true
            mover.ForceLimitMode = Enum.ForceLimitMode.PerAxis
            mover.VectorVelocity = Vector3.zero
            mover.Parent = part
        else
            mover.Attachment0 = attachment
        end
        -- Softer force: extreme MaxAxesForce was fighting physics and felt like random reset
        local force = math.clamp(part.AssemblyMass * math.max(speed * 120, 4000), 50000, 2500000)
        mover.MaxAxesForce = Vector3.new(force, force * 0.55, force)
        mover.Enabled = true
        local alpha = 1 - math.exp(-math.max(dt or (1/60), 0) * 26)
        mover.VectorVelocity = mover.VectorVelocity:Lerp(velocity, alpha)
    end

    BB.Connection = RunService.RenderStepped:Connect(function(dt)
        if not BB.Enabled then BB.Stop(); return end
        local character = LP.Character
        local currentRoot = character and character:FindFirstChild("HumanoidRootPart")
        local currentHumanoid = character and character:FindFirstChildOfClass("Humanoid")
        if not character or not currentRoot or not currentHumanoid or currentHumanoid.Health <= 0 then
            return
        end
        root, humanoid = currentRoot, currentHumanoid
        humanoid.AutoRotate = false

        -- Initial bat equip only; after a manual tool switch, respect the choice.
        pcall(function() _updateAutoBatToolState(character, humanoid) end)

        local targetPlayer = bbNearestTarget(root)
        local targetChar = targetPlayer and targetPlayer.Character
        local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
        local targetHumanoid = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
        if not targetRoot or not targetHumanoid or targetHumanoid.Health <= 0 then
            -- Soft hold — hard zero + destroy mover every frame felt like a self-reset
            local av = root.AssemblyAngularVelocity
            root.AssemblyAngularVelocity = av * 0.35
            local mover = root:FindFirstChild("VX7AimbotMoveVelocity")
            if mover and mover:IsA("LinearVelocity") then
                mover.VectorVelocity = mover.VectorVelocity * 0.4
            end
            return
        end

        local now = tick()
        local record = pred[targetRoot]
        local targetVelocity = Vector3.zero
        if not record then
            pred[targetRoot] = {pos = targetRoot.Position, time = now, vel = Vector3.zero}
            record = pred[targetRoot]
        else
            local elapsed = math.clamp(now - record.time, 1/120, 0.25)
            local rawVelocity = (targetRoot.Position - record.pos) / elapsed
            if rawVelocity.Magnitude > 80 then rawVelocity = rawVelocity.Unit * 80 end
            record.vel = record.vel:Lerp(rawVelocity, 0.25)
            record.pos = targetRoot.Position
            record.time = now
            targetVelocity = record.vel
        end

        local predicted = targetRoot.Position
            + targetVelocity * math.clamp(targetVelocity.Magnitude / 130, 0.05, 0.12)
            + Vector3.new(0, 1, 0)
        local direction = predicted - root.Position
        local flatDirection = Vector3.new(direction.X, 0, direction.Z)

        -- Yaw only: pitch angular velocity was tipping the character into Physics/ragdoll → random reset feel
        if flatDirection.Magnitude > 0.01 then
            local yawDelta = (math.deg(math.atan2(-flatDirection.X, -flatDirection.Z))
                - root.Orientation.Y + 180) % 360 - 180
            local yawVelocity = math.clamp(math.rad(yawDelta) * 220, -22, 22)
            root.AssemblyAngularVelocity = Vector3.new(0, yawVelocity, 0)
        else
            root.AssemblyAngularVelocity = root.AssemblyAngularVelocity * 0.4
        end

        local moveOffset = predicted + direction * 1.6 + Vector3.new(0, 2.2, 0) - root.Position
        local horizontal = Vector3.new(moveOffset.X, 0, moveOffset.Z)
        local speed = 58
        if _G.AceGetAntiBypassAimbotSpeed then
            local ok, value = pcall(_G.AceGetAntiBypassAimbotSpeed)
            if ok and tonumber(value) then speed = tonumber(value) end
        end
        speed = math.clamp(tonumber(speed) or 58, 1, 120)
        local horizontalVelocity = horizontal.Magnitude > 0.1 and horizontal.Unit * speed or Vector3.zero
        -- Soft vertical — *52 launch was flinging into void / AR recovery
        local yOff = moveOffset.Y
        local ySpd = 0
        if math.abs(yOff) > 1.5 then
            ySpd = math.clamp(yOff * 6.5, -28, 32)
        else
            ySpd = -2
        end
        local verticalVelocity = Vector3.new(0, ySpd, 0)
        applyMove(root, horizontalVelocity + verticalVelocity, speed, dt)
        if horizontal.Magnitude > 0.5 then
            humanoid:Move(horizontal.Unit, false)
        end
    end)
end

function BB.Toggle()
    if BB.Enabled then BB.Stop() else BB.Start() end
end

local function _clearLegacyBypassMover(root)
    root = root or (LP.Character and LP.Character:FindFirstChild("HumanoidRootPart"))
    if not root then return end
    for _, moverName in ipairs({"VX7AimbotMoveVelocity", "VX7AimbotMoveAttachment"}) do
        local oldMover = root:FindFirstChild(moverName)
        if oldMover then pcall(function() oldMover:Destroy() end) end
    end
end

-- Keyboard follows AimPot Mode; mobile buttons remain fixed and independent.
-- V2/Bypass uses full VX7 Bat Aimbot constants (tbl31) from printed Vx7 source.
local function _resolveAutoBatMode(source, requestedMode)
    if source == "mobile-bypass" then return "V2" end
    if source == "mobile-normal" then return "V1" end
    return normalizeAimbotMode and normalizeAimbotMode(requestedMode) or ((tostring(requestedMode or "V1"):lower() == "v2" or tostring(requestedMode or ""):lower() == "bypass") and "V2" or "V1")
end

function stopAimbotAdapt()
    if _autoBatAttackConn then pcall(function() _autoBatAttackConn:Disconnect() end); _autoBatAttackConn = nil end
    pcall(function() if BB then BB.Stop() end end)
    if _aimbotConn then pcall(function() _aimbotConn:Disconnect() end); _aimbotConn = nil end
    if _G._RaptureAimExtraConn then pcall(function() _G._RaptureAimExtraConn:Disconnect() end); _G._RaptureAimExtraConn = nil end
    local character = LP.Character
    local root = character and character:FindFirstChild("HumanoidRootPart")
    local humanoid = character and character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        -- Restore Shift-Lock's normal character rotation reliably, including rapid
        -- Aimbot off/on toggles where the previous run may have left AutoRotate=false.
        local shiftLocked = false
        pcall(function()
            shiftLocked = UIS.MouseBehavior == Enum.MouseBehavior.LockCenter
        end)
        if shiftLocked and not spinEnabled and not autoSpinEnabled then
            humanoid.AutoRotate = true
        elseif _prevAutoRotate ~= nil then
            humanoid.AutoRotate = _prevAutoRotate
        end
        if humanoid.PlatformStand then humanoid.PlatformStand = false end
    end
    if root then
        pcall(function() _clearLegacyBypassMover(root) end)
        -- Soft damp only — hard zero fights TP / speed and causes desync
        local av = root.AssemblyAngularVelocity
        if av.X == av.X then root.AssemblyAngularVelocity = av * 0.2 end
    end
    _prevAutoRotate = nil
    lastMoveDir = _V3zero
    pcall(function() if BB then BB.Stop() end end)
end

function startAimbotAdapt()
    if _aimbotConn then return end
    local humanoid0 = LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
    if humanoid0 then
        if _prevAutoRotate == nil then
            local shiftLocked = false
            pcall(function()
                shiftLocked = UIS.MouseBehavior == Enum.MouseBehavior.LockCenter
            end)
            -- If a previous rapid toggle left AutoRotate off, use the correct
            -- Shift-Lock baseline instead of saving the stale false value again.
            if shiftLocked and not spinEnabled and not autoSpinEnabled then
                _prevAutoRotate = true
            else
                _prevAutoRotate = humanoid0.AutoRotate
            end
        end
        -- Normal (V1): AutoRotate off like Clean. Bypass (V2): controlled inside Vx7 update.
        humanoid0.AutoRotate = (activeAimbotMode == "V2")
    end

    pcall(function()
        if type(_clearLegacyBypassMover) == "function" then _clearLegacyBypassMover() end
    end)

        -- BYPASS (V2) = CleanHub source Bat Bypass controller
    -- Old custom VX7 bypass movement implementation removed.
        if activeAimbotMode == "V2" then
        -- Bypass uses its own target/movement controller and shared bat-only hit logic;
        -- the bat is auto-equipped only on startup, not after manual tool switches.
        if _autoBatAttackConn then pcall(function() _autoBatAttackConn:Disconnect() end) end
        _autoBatAttackConn = RunService.Heartbeat:Connect(function()
            if not autoBatEnabled or activeAimbotMode ~= "V2" then return end
            local character = LP.Character
            if not character then return end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local root = character:FindFirstChild("HumanoidRootPart")
            if not humanoid or not root or humanoid.Health <= 0 then return end

            _updateAutoBatToolState(character, humanoid)
            local target = getClosestTarget()
            if not target or not target.Parent then return end
            local targetCharacter = target.Parent
            local targetHumanoid = targetCharacter and targetCharacter:FindFirstChildOfClass("Humanoid")
            if targetHumanoid and targetHumanoid.Health > 0 then
                local distance = (root.Position - target.Position).Magnitude
                if distance <= 11 then trySwing() end
            end
        end)
        pcall(function()
            if BB.ZCFG then
                BB.ZCFG.FOLLOW_SPEED = _G.AceGetAntiBypassAimbotSpeed()
            end
            BB.Start()
            _aimbotConn = BB.Connection
        end)
        return
    end

        -- NORMAL (V1) = ordinary Clean aimbot (unchanged)
        if humanoid0 then humanoid0.AutoRotate = false end
    _aimbotConn = RunService.RenderStepped:Connect(function(dt)
        if not autoBatEnabled or activeAimbotMode == "V2" then return end
        if autoTPEnabled or _G._AmbitiousTPDownJumpLocked then return end
        local character = LP.Character
        if not character then return end
        local root = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not root or not humanoid then return end

        pcall(function()
            if type(_clearLegacyBypassMover) == "function" then _clearLegacyBypassMover(root) end
        end)

        -- Keep Normal tracking active. Bat is equipped once at startup; later
        -- manual tool changes are respected and hits remain bat-only.
        _updateAutoBatToolState(character, humanoid)

        local target = getClosestTarget()
        if not target then return end
        local targetVel = target.AssemblyLinearVelocity
        local myPos = root.Position
        local targetPos = target.Position
        local predictPos = targetPos + targetVel * 0.14
        predictPos = predictPos + target.CFrame.LookVector * 0.3
        local dir = predictPos - myPos
        local flatDir = _V3new(dir.X, 0, dir.Z)
        if flatDir.Magnitude > 0 then flatDir = flatDir.Unit else flatDir = _V3new(0, 0, 0) end
        local desiredHeight = targetPos.Y + 3.7
        local yVel = (desiredHeight - myPos.Y) * 12 + targetVel.Y * 0.45
        if humanoid.FloorMaterial ~= Enum.Material.Air then yVel = math.max(yVel, 4) end
        yVel = _clamp(yVel, -40, 48)
        local desiredVel = _V3new(flatDir.X * BAT_AIMBOT_SPEED, yVel, flatDir.Z * BAT_AIMBOT_SPEED)
        root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)
        local speed3 = targetVel.Magnitude
        local predictTime = _clamp(speed3 / 150, 0.05, 0.2)
        local predictedPos = targetPos + targetVel * predictTime
        local toPredict = predictedPos - myPos
        if toPredict.Magnitude > 0.1 then
            -- Yaw-only: full XYZ angular was causing random physics resets while aiming
            local goalCF = _CFlookAt(myPos, _V3new(predictedPos.X, myPos.Y, predictedPos.Z))
            local diffCF = root.CFrame:Inverse() * goalCF
            local _, ry, _ = diffCF:ToEulerAnglesXYZ()
            ry = _clamp(ry, -2.5, 2.5)
            root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(_V3new(0, ry * 42, 0))
        end
        local distToTarget = (root.Position - target.Position).Magnitude
        if distToTarget <= 11 then trySwing() end
        if distToTarget <= 6 then trySwing() end
    end)
end

function disableAutoBat()
    autoBatEnabled = false
    if markSettingsDirty then pcall(markSettingsDirty) end
    -- Only clear the active source visual — do not force coordination across buttons
    if autoBatSource == "key" or autoBatSource == "combat" then
        if autoBatSetVisual then pcall(autoBatSetVisual, false) end
    elseif autoBatSource == "mobile-normal" then
        if mobSetAutoBat then pcall(mobSetAutoBat, false) end
    elseif autoBatSource == "mobile-bypass" then
        bypassAutoBatMobileEnabled = false
        if bypassAutoBatMobileSetVisual then pcall(bypassAutoBatMobileSetVisual, false) end
    else
        if autoBatSetVisual then pcall(autoBatSetVisual, false) end
        if mobSetAutoBat then pcall(mobSetAutoBat, false) end
        if bypassAutoBatMobileSetVisual then pcall(bypassAutoBatMobileSetVisual, false) end
        bypassAutoBatMobileEnabled = false
    end
    stopAimbotAdapt()
end


-- Shift-Lock recovery: some combat/movement paths can leave AutoRotate disabled
if not _G._YassinShiftLockRecovery then
    _G._YassinShiftLockRecovery = true
    task.spawn(function()
        while true do
            task.wait(0.12)
            local ok, locked = pcall(function()
                return UIS.MouseBehavior == Enum.MouseBehavior.LockCenter
            end)
            if ok and locked and not autoBatEnabled
                and not spinEnabled and not autoSpinEnabled then
                local character = LP.Character
                local humanoid = character and character:FindFirstChildOfClass("Humanoid")
                local root = character and character:FindFirstChild("HumanoidRootPart")
                if humanoid and humanoid.Health > 0 then
                    pcall(function() humanoid.AutoRotate = true end)
                end
                -- Clear only excessive leftover spin after rotation features stop.
                if root and root.Parent then
                    pcall(function()
                        local av = root.AssemblyAngularVelocity
                        if av.Magnitude > 18 then
                            root.AssemblyAngularVelocity = Vector3.zero
                        end
                    end)
                end
            end
        end
    end)
end


-- Keep Auto Bat alive if the RenderStepped connection is dropped without a full respawn.
if not _G._YassinAimbotRecovery then
    _G._YassinAimbotRecovery = true
    task.spawn(function()
        while true do
            task.wait(0.5)
            if autoBatEnabled and not _aimbotConn then
                pcall(startAimbotAdapt)
            end
        end
    end)
end

local function normalizeAimbotMode(m)
    m = tostring(m or aimbotMode or _G.aimbotMode or selectedAimbotMode or "V1"):lower()
    if m == "bypass" or m == "v2" then return "V2" end
    return "V1"
end

function enableAutoBat(modeOverride)
    local wasAutoBatEnabled = autoBatEnabled == true
    if not wasAutoBatEnabled then
        _autoBatHasEquippedBat = false
        _autoBatInitialEquipPending = true
        _autoBatManualToolOverride = false
    end
    -- TP Down and Aimbot are independent: enabling Aimbot does not stop Auto TP Down.
    activeAimbotMode = _resolveAutoBatMode(autoBatSource, modeOverride or activeAimbotMode or aimbotMode)
    aimbotMode = normalizeAimbotMode(aimbotMode)
    selectedAimbotMode = aimbotMode
    _G.aimbotMode = aimbotMode
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
    pcall(function()
        if _G._RaptureBatBypass and _G._RaptureBatBypass.enabled then _G.RaptureStopBatBypass() end
    end)
    autoBatEnabled = true
    if markSettingsDirty then pcall(markSettingsDirty) end
    -- Bind tool-change events so manually returning to the bat resumes the hit
    -- controller without waiting for a later polling frame.
    local toolCharacter = LP.Character
    if toolCharacter then
        _watchAutoBatToolState(toolCharacter)
        local toolHumanoid = toolCharacter:FindFirstChildOfClass("Humanoid")
        pcall(_updateAutoBatToolState, toolCharacter, toolHumanoid)
    end
    -- Independent visuals per source (no cross-button coordination)
    if autoBatSource == "key" or autoBatSource == "combat" then
        if autoBatSetVisual then pcall(autoBatSetVisual, true) end
    elseif autoBatSource == "mobile-normal" then
        if mobSetAutoBat then pcall(mobSetAutoBat, true) end
    elseif autoBatSource == "mobile-bypass" then
        bypassAutoBatMobileEnabled = true
        if bypassAutoBatMobileSetVisual then pcall(bypassAutoBatMobileSetVisual, true) end
    end
    pcall(stopAimbotAdapt)
    pcall(startAimbotAdapt)
    task.defer(function()
        if autoBatEnabled and not _aimbotConn then
            pcall(startAimbotAdapt)
        end
    end)
end

-- Unified input routing: keyboard follows AimPot Mode; mobile buttons force their own mode.
-- Vision's original per-frame Bypass loop is used only by V2; Normal V1 remains unchanged.
local function toggleAutoBatFromInput(source, requestedMode)
    if source ~= "key" and source ~= "mobile-normal" and source ~= "mobile-bypass" and source ~= "combat" then
        return false
    end
    -- Independent: each button only toggles itself. No coordination between Normal and Bypass.
    if autoBatEnabled == true and autoBatSource == source then
        disableAutoBat()
        autoBatSource = source
    else
        -- Turn previous engine off without clearing the other button's identity rules
        if autoBatEnabled then
            local prev = autoBatSource
            autoBatEnabled = false
            stopAimbotAdapt()
            if prev == "key" or prev == "combat" then
                if autoBatSetVisual then pcall(autoBatSetVisual, false) end
            elseif prev == "mobile-normal" then
                if mobSetAutoBat then pcall(mobSetAutoBat, false) end
            elseif prev == "mobile-bypass" then
                bypassAutoBatMobileEnabled = false
                if bypassAutoBatMobileSetVisual then pcall(bypassAutoBatMobileSetVisual, false) end
            end
        end
        autoBatSource = source
        activeAimbotMode = _resolveAutoBatMode(source, requestedMode)
        enableAutoBat(activeAimbotMode)
    end
    if markSettingsDirty then pcall(markSettingsDirty) end
    return true
end

-- V2/Bypass uses the VX7-style controller; V1/Normal stays on the original path.

-- # HELPERS
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
                return t
            end
        end
        -- Some slap/bat variants have custom names and are not in the fixed list.
        for _, t in ipairs(bp:GetChildren()) do
            if t:IsA("Tool") then
                local n = tostring(t.Name or ""):lower()
                if n:find("bat", 1, true) or n:find("slap", 1, true) then
                    return t
                end
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

-- DROP BRAINROT — restored from the supplied VX7 source
-- Drop Mode: 1 = Jump, 2 = Stand
local DROP_ASCEND_DURATION = 0.18
local DROP_ASCEND_SPEED = 155
local _dropConn = nil
local _dropStandActive = false
local _dropToken = 0

local function publishDropVelocity(velocity)
    if typeof(velocity) ~= "Vector3" then return end
    _G.spoofedVelocity = velocity
    if type(_G._vxSyncSpoof) == "function" then
        pcall(_G._vxSyncSpoof, velocity)
    elseif type(Config) == "table" and type(Config._vxSyncSpoof) == "function" then
        pcall(Config._vxSyncSpoof, velocity)
    end
end

local function syncDropVisual(on)
    if dropBrainrotSetVisual then pcall(dropBrainrotSetVisual, on == true) end
    if mobSetDropBR then pcall(mobSetDropBR, on == true) end
end

function stopDropBrainrot()
    _dropToken += 1
    dropActive = false
    _dropStandActive = false

    if _dropConn then
        pcall(function() _dropConn:Disconnect() end)
        _dropConn = nil
    end

    for _, item in ipairs(dropConnections or {}) do
        if type(item) == "thread" then
            pcall(task.cancel, item)
        elseif typeof(item) == "RBXScriptConnection" then
            pcall(function() item:Disconnect() end)
        end
    end
    dropConnections = {}

    local char = LP.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        pcall(function()
            local velocity = root.AssemblyLinearVelocity
            root.AssemblyLinearVelocity = Vector3.new(velocity.X, 0, velocity.Z)
            root.AssemblyAngularVelocity = Vector3.zero
        end)
    end

    syncDropVisual(false)
end

function runDropBrainrot()
    if dropActive then return false end
    local character = LP.Character
    if not character then return false end
    local root = character:FindFirstChild("HumanoidRootPart")
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not root or not humanoid or humanoid.Health <= 0 then return false end

    -- VX7 disables its bat-aim controller before applying Drop. In this script the
    if autoBatEnabled and type(disableAutoBat) == "function" then
        pcall(disableAutoBat)
    else
        if type(stopAimbotAdapt) == "function" then pcall(stopAimbotAdapt) end
    end
    if _G._RaptureBatBypass and _G._RaptureBatBypass.enabled and type(_G.RaptureStopBatBypass) == "function" then
        pcall(_G.RaptureStopBatBypass)
    end
    if autoLeftEnabled then
        autoLeftEnabled = false
        if autoLeftSetVisual then pcall(autoLeftSetVisual, false) end
        if mobSetAutoLeft then pcall(mobSetAutoLeft, false) end
        pcall(stopAutoLeft)
    end
    if autoRightEnabled then
        autoRightEnabled = false
        if autoRightSetVisual then pcall(autoRightSetVisual, false) end
        if mobSetAutoRight then pcall(mobSetAutoRight, false) end
        pcall(stopAutoRight)
    end

    -- Match VX7's original Drop behavior: Jump rises at 155, then snaps back to the floor;
    -- Stand performs VX7's short velocity burst and collision suppression.
    if _dropConn then
        pcall(function() _dropConn:Disconnect() end)
        _dropConn = nil
    end
    for _, item in ipairs(dropConnections or {}) do
        if typeof(item) == "RBXScriptConnection" then
            pcall(function() item:Disconnect() end)
        elseif type(item) == "thread" then
            pcall(coroutine.close, item)
        end
    end
    dropConnections = {}

    dropActive = true
    _dropToken += 1
    local token = _dropToken
    syncDropVisual(true)

    local function finish()
        if token ~= _dropToken then return end
        if _dropConn then
            pcall(function() _dropConn:Disconnect() end)
            _dropConn = nil
        end
        for _, item in ipairs(dropConnections or {}) do
            if typeof(item) == "RBXScriptConnection" then
                pcall(function() item:Disconnect() end)
            elseif type(item) == "thread" then
                pcall(coroutine.close, item)
            end
        end
        dropConnections = {}
        dropActive = false
        _dropStandActive = false
        -- Ensure the old Auto Bat mover cannot remain attached after Drop finishes.
        if not autoBatEnabled and type(stopAimbotAdapt) == "function" then pcall(stopAimbotAdapt) end
        syncDropVisual(false)
    end

    dropMode = 1 -- Enforce Jump on every activation.
    if false then -- Stand mode intentionally disabled; Jump is permanent.
        _dropStandActive = true
        local function disableOtherPlayerCollision()
            for _, player in ipairs(Players:GetPlayers()) do
                if player ~= LP and player.Character then
                    for _, part in ipairs(player.Character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end
        end
        local steppedConn = RunService.Stepped:Connect(function()
            if token ~= _dropToken or not _dropStandActive then return end
            disableOtherPlayerCollision()
        end)
        table.insert(dropConnections, steppedConn)

        local standThread
        standThread = coroutine.create(function()
            while token == _dropToken and _dropStandActive do
                RunService.Heartbeat:Wait()
                local currentCharacter = LP.Character
                local currentRoot = currentCharacter and currentCharacter:FindFirstChild("HumanoidRootPart")
                if not currentRoot then break end
                local oldVelocity = currentRoot.Velocity
                currentRoot.Velocity = oldVelocity * 10000 + Vector3.new(0, 10000, 0)
                RunService.RenderStepped:Wait()
                if currentRoot and currentRoot.Parent then currentRoot.Velocity = oldVelocity end
                RunService.Stepped:Wait()
                if currentRoot and currentRoot.Parent then currentRoot.Velocity = oldVelocity + Vector3.new(0, 0.1, 0) end
            end
        end)
        table.insert(dropConnections, standThread)
        coroutine.resume(standThread)
        task.delay(0.1, finish)
        return true
    end

    _G.__VX7DropToken = (_G.__VX7DropToken or 0) + 1
    local vx7Token = _G.__VX7DropToken
    local rayParams = _G.__VX7DropRayParams
    if not rayParams then
        rayParams = RaycastParams.new()
        rayParams.FilterType = Enum.RaycastFilterType.Exclude
        rayParams.RespectCanCollide = true
        _G.__VX7DropRayParams = rayParams
    end
    rayParams.FilterDescendantsInstances = { character }
    local groundHit = workspace:Raycast(
        root.Position + Vector3.new(0, 0.35, 0),
        Vector3.new(0, -2000, 0),
        rayParams
    )
    -- VX7's Jump must start even if the floor ray is unavailable for a frame.
    -- Keep the hit as a landing reference when available, but do not abort the jump.
    local rotation = root.CFrame.Rotation
    local startX, startY, startZ, startTime = root.Position.X, root.Position.Y, root.Position.Z, tick()
    root.AssemblyLinearVelocity = Vector3.new(
        root.AssemblyLinearVelocity.X,
        155,
        root.AssemblyLinearVelocity.Z
    )
    local spoofed = _G.spoofedVelocity
    publishDropVelocity(Vector3.new(
        typeof(spoofed) == "Vector3" and spoofed.X or root.AssemblyLinearVelocity.X,
        155,
        typeof(spoofed) == "Vector3" and spoofed.Z or root.AssemblyLinearVelocity.Z
    ))
    _dropConn = RunService.Heartbeat:Connect(function()
        local currentCharacter = LP.Character
        local currentRoot = currentCharacter and currentCharacter:FindFirstChild("HumanoidRootPart")
        local currentHumanoid = currentCharacter and currentCharacter:FindFirstChildOfClass("Humanoid")
        if token ~= _dropToken or vx7Token ~= _G.__VX7DropToken or not currentRoot or not currentHumanoid or currentHumanoid.Health <= 0 then
            finish()
            return
        end

        rayParams.FilterDescendantsInstances = { currentCharacter }
        local ceilingHit = workspace:Raycast(currentRoot.Position, Vector3.new(0, 1, 0), rayParams)
        if ceilingHit then
            if _dropConn then pcall(function() _dropConn:Disconnect() end); _dropConn = nil end
            currentRoot.CFrame = CFrame.new(
                currentRoot.Position.X,
                ceilingHit.Position.Y - currentRoot.Size.Y * 0.5 - 0.05,
                currentRoot.Position.Z
            ) * rotation
            currentRoot.AssemblyLinearVelocity = Vector3.zero
            currentRoot.AssemblyAngularVelocity = Vector3.zero
            publishDropVelocity(Vector3.zero)
            finish()
            return
        end

        if tick() - startTime >= 0.18 then
            if _dropConn then pcall(function() _dropConn:Disconnect() end); _dropConn = nil end
            local floorHit = workspace:Raycast(
                currentRoot.Position + Vector3.new(0, 0.35, 0),
                Vector3.new(0, -2000, 0),
                rayParams
            ) or groundHit
            if floorHit then
                local offset = currentHumanoid.HipHeight + currentRoot.Size.Y * 0.5 + 0.2
                currentRoot.CFrame = CFrame.new(startX, floorHit.Position.Y + offset, startZ) * rotation
            else
                -- Fallback to VX7's captured starting height if the floor cannot be raycast.
                currentRoot.CFrame = CFrame.new(startX, startY, startZ) * rotation
            end
            currentRoot.AssemblyLinearVelocity = Vector3.zero
            currentRoot.AssemblyAngularVelocity = Vector3.zero
            publishDropVelocity(Vector3.zero)
            finish()
            return
        end

        currentRoot.AssemblyLinearVelocity = Vector3.new(
            currentRoot.AssemblyLinearVelocity.X,
            155,
            currentRoot.AssemblyLinearVelocity.Z
        )
        local spoofed = _G.spoofedVelocity
        if typeof(spoofed) == "Vector3" then
            publishDropVelocity(Vector3.new(spoofed.X, currentRoot.AssemblyLinearVelocity.Y, spoofed.Z))
        end
    end)
    return true
end

function setDropBrainrot(on)
    if on then
        if autoLeftEnabled then pcall(stopAutoLeft) end
        if autoRightEnabled then pcall(stopAutoRight) end
        if not dropActive then
            local ok, started = pcall(runDropBrainrot)
            if not ok or not started then
                syncDropVisual(false)
                return false
            end
        end
    else
        pcall(stopDropBrainrot)
    end
    syncDropVisual(on and dropActive)
    markSettingsDirty()
    return dropActive
end

function executeDropWithToggle(setVisual)
    if dropActive then return end
    if type(setVisual) == "function" then pcall(setVisual, true) end
    setDropBrainrot(true)
end

-- # FOV / STRETCH
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

-- # PINTAR BOTONES FLOTANTES
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
    local moved = false
    local function stopDrag()
        if dn and moved then
            _lastLayoutEditTime = _tick()
            markSettingsDirty()
            -- Save the final dragged position immediately as well as through
            -- the debounced autosave, so quick script closes do not lose it.
            task.defer(function()
                task.wait(0.05)
                pcall(function()
                    if type(saveConfig) == "function" then saveConfig() end
                end)
            end)
        end
        dn = false; di = nil; moved = false
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
            moved = true
        end
    end)
end

function setupMovementAndIndicators(char)
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end
    local ccAcc = 0
    steppedConn = RunService.Heartbeat:Connect(function(dt)
        ccAcc = ccAcc + dt
        if ccAcc < 0.12 then return end
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
    local speedSig = RunService.PreSimulation or RunService.Heartbeat
    local _spdLabelAcc = 0
    movementLoop = speedSig:Connect(function(dt)
        local char2 = LP.Character
        if not char2 or not char2.Parent then return end
        local hum = char2:FindFirstChildOfClass("Humanoid")
        local hrp = char2:FindFirstChild("HumanoidRootPart")
        if not hum or not hrp or not hrp.Parent then return end
        if hum.Health <= 0 then return end
        local md = hum.MoveDirection
        if md.X ~= md.X or md.Z ~= md.Z then md = _V3zero end
        local mdMagnitude = md.Magnitude
        local spd = getActiveMoveSpeed()
        local dir = nil
        if mdMagnitude > 0.05 then
            lastMoveDir = md
            dir = md
        elseif lastMoveDir.Magnitude > 0.05 then
            -- Keep last direction only while a move key is still held (PC).
            -- On mobile, MoveDirection is the source of truth (handled above).
            local keyHeld = false
            pcall(function()
                for key in pairs(MOVE_KEYS) do
                    if UIS:IsKeyDown(key) then keyHeld = true; break end
                end
            end)
            if keyHeld then
                dir = lastMoveDir
            else
                lastMoveDir = _V3zero
            end
        end
        if dir and dir.Magnitude > 0.05 then
            pcall(_applyVelocitySpeed, dir, spd, hrp)
        else
            _G._AmbitiousAntiBatDesiredXZ = nil
        end
        _spdLabelAcc = _spdLabelAcc + (typeof(dt) == "number" and dt or 0.016)
        if speedLabel and speedLabel.Parent and _spdLabelAcc >= 0.12 then
            _spdLabelAcc = 0
            speedLabel.Text = "Speed: " .. string.format("%.1f", spd)
        end
    end)
    setupSpeedIndicator(char)
    startEnemySpeed()
end

-- If the speed loop dies without a full respawn, bring it back.
if not _G._YassinSpeedRecovery then
    _G._YassinSpeedRecovery = true
    task.spawn(function()
        while true do
            task.wait(0.75)
            local c = LP.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            local r = c and c:FindFirstChild("HumanoidRootPart")
            if c and h and r and h.Health > 0 then
                local dead = (not movementLoop)
                if not dead then
                    local ok, connected = pcall(function() return movementLoop.Connected end)
                    dead = not ok or not connected
                end
                if dead then
                    pcall(setupMovementAndIndicators, c)
                end
            end
        end
    end)
end

function toggleLockUI(state)
    if state == nil then uiLocked = not uiLocked else uiLocked = state end
    if not uiLocked then _lastLayoutEditTime = 0 end
    if setLockUIVisual then setLockUIVisual(uiLocked) end
    markSettingsDirty()
end

function disableAllAimbots()
    if autoBatEnabled then
        disableAutoBat()
        if autoBatSetVisual then autoBatSetVisual(false) end
        if mobSetAutoBat then mobSetAutoBat(false) end
    end
    if _G._RaptureBatBypass and _G._RaptureBatBypass.enabled then _G.RaptureStopBatBypass() end
end

function stopAllBackgroundTasks()
    if movementLoop then movementLoop:Disconnect(); movementLoop = nil end
    if steppedConn then steppedConn:Disconnect(); steppedConn = nil end
    stopEnemySpeed()
    if stretchEnabled then disableStretch() end
    if AntiRagdollV2.isRunning() then AntiRagdollV2.stop() end
    if AntiRagdollV2.Enabled then stopAntiRagdollV2() end
    if antiDieEnabled then _antiDie.StopEngine() end
    stopBatCounter()
    stopMedusaCounter()
    stopAutoSteal()
    disableAutoBat()
    if _G._RaptureBatBypass and _G._RaptureBatBypass.enabled then _G.RaptureStopBatBypass() end
    stopAutoLeft()
    stopAutoRight()
    if unwalkEnabled then stopUnwalk() end
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

-- SAVE SYSTEM (Rapture-style: simple writefile/readfile, all executors)
-- Works on Delta / Android / iPhone / PC when FS APIs exist.
STATE_FILE = "Yassin_OnTop_Config.json"
KEYBINDS_FILE = "Yassin_OnTop_Keybinds.json"

local function _yassinFs()
    local function pick(name)
        local sources = {}
        pcall(function() if type(getgenv) == "function" then table.insert(sources, getgenv()) end end)
        pcall(function() table.insert(sources, _G) end)
        pcall(function() if type(syn) == "table" then table.insert(sources, syn) end end)
        pcall(function() if type(fluxus) == "table" then table.insert(sources, fluxus) end end)
        pcall(function() if type(getrenv) == "function" then table.insert(sources, getrenv()) end end)
        pcall(function() if type(getfenv) == "function" then table.insert(sources, getfenv(0)) end end)
        pcall(function() if type(shared) == "table" then table.insert(sources, shared) end end)
        for _, src in ipairs(sources) do
            if type(src) == "table" then
                local ok, v = pcall(function() return src[name] end)
                if ok and type(v) == "function" then return v end
            end
        end
        if name == "writefile" then
            local ok, v = pcall(function() return writefile end)
            if ok and type(v) == "function" then return v end
        elseif name == "readfile" then
            local ok, v = pcall(function() return readfile end)
            if ok and type(v) == "function" then return v end
        elseif name == "isfile" then
            local ok, v = pcall(function() return isfile end)
            if ok and type(v) == "function" then return v end
        elseif name == "delfile" then
            local ok, v = pcall(function() return delfile end)
            if ok and type(v) == "function" then return v end
        elseif name == "makefolder" then
            local ok, v = pcall(function() return makefolder end)
            if ok and type(v) == "function" then return v end
        elseif name == "isfolder" then
            local ok, v = pcall(function() return isfolder end)
            if ok and type(v) == "function" then return v end
        end
        return nil
    end
    local isfile_ = pick("isfile")
    local readfile_ = pick("readfile")
    local writefile_ = pick("writefile")
    local delfile_ = pick("delfile")
    local makefolder_ = pick("makefolder")
    local isfolder_ = pick("isfolder")
    if not isfile_ and readfile_ then
        isfile_ = function(path)
            local ok, data = pcall(readfile_, path)
            return ok and type(data) == "string" and #data > 0
        end
    end
    return {
        isfile = isfile_,
        readfile = readfile_,
        writefile = writefile_,
        delfile = delfile_,
        makefolder = makefolder_,
        isfolder = isfolder_,
        canSave = type(writefile_) == "function",
        canLoad = type(readfile_) == "function",
    }
end

local function _yassinEnsureFolders(fs)
    if type(fs.makefolder) ~= "function" then return end
    for _, folder in ipairs({ "Yassin", "workspace" }) do
        pcall(function()
            if type(fs.isfolder) ~= "function" or not fs.isfolder(folder) then
                fs.makefolder(folder)
            end
        end)
    end
end

local _YASSIN_STATE_PATHS = {
    "Yassin_OnTop_Config.json",
    "Yassin/Yassin_OnTop_Config.json",
    "workspace/Yassin_OnTop_Config.json",
    "yassin_config.json",
}
local _YASSIN_KEYBIND_PATHS = {
    "Yassin_OnTop_Keybinds.json",
    "Yassin/Yassin_OnTop_Keybinds.json",
    "workspace/Yassin_OnTop_Keybinds.json",
}


_settingsDirty = false
_isLoading = _isLoading or false
_isResetting = _isResetting or false

local function _safePosition(guiObject)
    if not guiObject or not guiObject.Parent then return nil end
    local p = guiObject.Position
    local s = guiObject.Size
    local absPos = guiObject.AbsolutePosition
    local absSize = guiObject.AbsoluteSize
    return {
        XScale = p.X.Scale, XOffset = p.X.Offset,
        YScale = p.Y.Scale, YOffset = p.Y.Offset,
        SizeXScale = s.X.Scale, SizeXOffset = s.X.Offset,
        SizeYScale = s.Y.Scale, SizeYOffset = s.Y.Offset,
        AbsX = absPos.X, AbsY = absPos.Y,
        AbsW = absSize.X, AbsH = absSize.Y,
    }
end

local function _applyExactLayout(guiObject, data, defSx, defOx, defSy, defOy)
    if not guiObject or type(data) ~= "table" then return end
    local xs = tonumber(data.XScale)
    local ys = tonumber(data.YScale)
    if xs ~= nil and ys ~= nil then
        guiObject.Position = UDim2.new(xs, tonumber(data.XOffset) or 0, ys, tonumber(data.YOffset) or 0)
    elseif tonumber(data.AbsX) and tonumber(data.AbsY) then
        guiObject.Position = UDim2.fromOffset(math.floor(data.AbsX + 0.5), math.floor(data.AbsY + 0.5))
    elseif defSx ~= nil then
        guiObject.Position = UDim2.new(defSx, defOx or 0, defSy or 0, defOy or 0)
    end
    local sxs = tonumber(data.SizeXScale)
    local sys = tonumber(data.SizeYScale)
    if sxs ~= nil and sys ~= nil then
        guiObject.Size = UDim2.new(sxs, tonumber(data.SizeXOffset) or 0, sys, tonumber(data.SizeYOffset) or 0)
    elseif tonumber(data.AbsW) and tonumber(data.AbsH) and data.AbsW > 4 and data.AbsH > 4 then
        guiObject.Size = UDim2.fromOffset(math.floor(data.AbsW + 0.5), math.floor(data.AbsH + 0.5))
    end
end


local function snapshotLivePositions()
    if main and main.Parent then
        if main.Visible ~= false then
            local pos = _safePosition(main)
            if pos and not (pos.XScale == 0 and (pos.XOffset or 0) < -50) then
                _G._RaptureSavedMainPos = pos
            end
        end
        local style = {
            mainBackgroundColor = {main.BackgroundColor3.R, main.BackgroundColor3.G, main.BackgroundColor3.B},
            mainBackgroundTransparency = main.BackgroundTransparency,
            mainSizeXScale = main.Size.X.Scale, mainSizeXOffset = main.Size.X.Offset,
            mainSizeYScale = main.Size.Y.Scale, mainSizeYOffset = main.Size.Y.Offset,
        }
        local bg = main:FindFirstChild("BackgroundImage")
        if bg and bg:IsA("ImageLabel") then
            style.backgroundImage = bg.Image
            style.backgroundColor = {bg.BackgroundColor3.R, bg.BackgroundColor3.G, bg.BackgroundColor3.B}
            style.backgroundTransparency = bg.BackgroundTransparency
            style.imageTransparency = bg.ImageTransparency
            style.scaleType = bg.ScaleType.Name
        end
        local corner = main:FindFirstChildOfClass("UICorner")
        if corner then style.cornerRadius = corner.CornerRadius.Offset end
        local stroke = main:FindFirstChildOfClass("UIStroke")
        if stroke then
            style.mainStrokeColor = {stroke.Color.R, stroke.Color.G, stroke.Color.B}
            style.mainStrokeThickness = stroke.Thickness
            style.mainStrokeTransparency = stroke.Transparency
        end
        style.mainUIScale = mainUIScale and mainUIScale.Scale or nil
        savedUiStyle = style
    end
    if pbFrame and pbFrame.Parent then
        savedProgressBarPos = _safePosition(pbFrame)
        savedProgressBarPos.Scale = pbScale and pbScale.Scale or (progressBarScaleValue / 100)
        savedProgressBarPos.SizeXScale = pbFrame.Size.X.Scale
        savedProgressBarPos.SizeXOffset = pbFrame.Size.X.Offset
        savedProgressBarPos.SizeYScale = pbFrame.Size.Y.Scale
        savedProgressBarPos.SizeYOffset = pbFrame.Size.Y.Offset
    end
    if miniBtn and miniBtn.Parent then
        _G._RaptureSavedMiniPos = _safePosition(miniBtn)
        if _G._RaptureSavedMiniPos then
            _G._RaptureSavedMiniPos.SizeXScale = miniBtn.Size.X.Scale
            _G._RaptureSavedMiniPos.SizeXOffset = miniBtn.Size.X.Offset
            _G._RaptureSavedMiniPos.SizeYScale = miniBtn.Size.Y.Scale
            _G._RaptureSavedMiniPos.SizeYOffset = miniBtn.Size.Y.Offset
        end
    end
    if MobilePanel and MobilePanel.Parent then
        local container = MobilePanel:FindFirstChild("FloatingPanel")
        if container then
            savedMobilePanelPos = _safePosition(container)
            if savedMobilePanelPos then
                savedMobilePanelPos.SizeXScale = container.Size.X.Scale
                savedMobilePanelPos.SizeXOffset = container.Size.X.Offset
                savedMobilePanelPos.SizeYScale = container.Size.Y.Scale
                savedMobilePanelPos.SizeYOffset = container.Size.Y.Offset
            end
            local bc = container:FindFirstChild("ButtonsContainer")
            if bc then
                savedButtonPositions = type(savedButtonPositions) == "table" and savedButtonPositions or {}
                for _, btn in ipairs(bc:GetChildren()) do
                    if btn:IsA("GuiObject") then
                        savedButtonPositions[btn.Name] = {
                            X = btn.Position.X.Offset,
                            Y = btn.Position.Y.Offset,
                            XScale = btn.Position.X.Scale,
                            YScale = btn.Position.Y.Scale,
                            -- Preserve per-button dimensions too, including changes made in edit mode.
                            WidthScale = btn.Size.X.Scale,
                            WidthOffset = btn.Size.X.Offset,
                            HeightScale = btn.Size.Y.Scale,
                            HeightOffset = btn.Size.Y.Offset,
                        }
                    end
                end
            end
        end
    end
end

local function _safeClamp(guiObject, fx, ox, fy, oy)
    if not guiObject or not guiObject.Parent then return end
    local cam = workspace.CurrentCamera
    local viewport = (cam and cam.ViewportSize) or Vector2.new(1280, 720)
    local size = guiObject.AbsoluteSize
    local w = (size and size.X > 0) and size.X or 120
    local h = (size and size.Y > 0) and size.Y or 40
    local pos = guiObject.AbsolutePosition
    local x = pos and pos.X or 20
    local y = pos and pos.Y or 20
    if x < -w * 0.5 or y < -h * 0.5 or x > viewport.X - 20 or y > viewport.Y - 20 then
        guiObject.Position = UDim2.new(fx or 0, ox or 20, fy or 0, oy or 20)
        pos = guiObject.AbsolutePosition
        x, y = pos and pos.X or 20, pos and pos.Y or 20
    end
    local nx = math.clamp(x, 4, math.max(4, viewport.X - math.min(w, viewport.X - 8)))
    local ny = math.clamp(y, 4, math.max(4, viewport.Y - math.min(h, viewport.Y - 8)))
    if math.abs(nx - x) > 1 or math.abs(ny - y) > 1 then
        guiObject.Position = UDim2.new(0, math.floor(nx), 0, math.floor(ny))
    end
end

function applySavedLayout()
    local function restore(guiObject, data, fx, ox, fy, oy)
        if not guiObject then return end
        if type(data) == "table" then
            _applyExactLayout(guiObject, data, fx, ox, fy, oy)
        elseif fx ~= nil then
            guiObject.Position = UDim2.new(fx, ox or 0, fy or 0, oy or 0)
        end
    end
    restore(main, _G._RaptureSavedMainPos, 0, 20, 0, 2)
    if main and type(_G._RaptureSavedMainPos) == "table" then
        local p = _G._RaptureSavedMainPos
        if tonumber(p.SizeXScale) and tonumber(p.SizeYScale) then
            main.Size = UDim2.new(p.SizeXScale, p.SizeXOffset or 0, p.SizeYScale, p.SizeYOffset or 0)
        end
    end
    restore(miniBtn, _G._RaptureSavedMiniPos, 0, 12, 0, 58)
    if miniBtn and type(_G._RaptureSavedMiniPos) == "table" then
        local p = _G._RaptureSavedMiniPos
        if tonumber(p.SizeXScale) and tonumber(p.SizeYScale) then
            miniBtn.Size = UDim2.new(p.SizeXScale, p.SizeXOffset or 0, p.SizeYScale, p.SizeYOffset or 0)
        end
    end
    restore(pbFrame, savedProgressBarPos, 0.5, -280, 1, -110)
    if pbFrame and type(savedProgressBarPos) == "table" then
        if tonumber(savedProgressBarPos.SizeXScale) and tonumber(savedProgressBarPos.SizeXOffset)
            and tonumber(savedProgressBarPos.SizeYScale) and tonumber(savedProgressBarPos.SizeYOffset) then
            pbFrame.Size = UDim2.new(savedProgressBarPos.SizeXScale, savedProgressBarPos.SizeXOffset,
                savedProgressBarPos.SizeYScale, savedProgressBarPos.SizeYOffset)
        end
        if pbScale and tonumber(savedProgressBarPos.Scale) then pbScale.Scale = math.clamp(savedProgressBarPos.Scale, 0.3, 1.5) end
    end
    local container = MobilePanel and MobilePanel:FindFirstChild("FloatingPanel")
    restore(container, savedMobilePanelPos, 1, -140, 0.5, -120)
    if container and type(savedMobilePanelPos) == "table" then
        local p = savedMobilePanelPos
        if tonumber(p.SizeXScale) and tonumber(p.SizeXOffset) and tonumber(p.SizeYScale) and tonumber(p.SizeYOffset) then
            container.Size = UDim2.new(p.SizeXScale, p.SizeXOffset, p.SizeYScale, p.SizeYOffset)
        end
    end
    if mainUIScale and type(savedUiStyle) == "table" and tonumber(savedUiStyle.mainUIScale) then
        mainUIScale.Scale = math.clamp(tonumber(savedUiStyle.mainUIScale), 0.3, 2)
    end
    local bc = container and container:FindFirstChild("ButtonsContainer")
    if bc and type(savedButtonPositions) == "table" then
        for _, btn in ipairs(bc:GetChildren()) do
            local p = savedButtonPositions[btn.Name]
            if p and btn:IsA("GuiObject") then
                local lay = {
                    XScale = tonumber(p.XScale) or 0,
                    XOffset = tonumber(p.XOffset) or tonumber(p.X) or btn.Position.X.Offset,
                    YScale = tonumber(p.YScale) or 0,
                    YOffset = tonumber(p.YOffset) or tonumber(p.Y) or btn.Position.Y.Offset,
                    SizeXScale = tonumber(p.SizeXScale) or tonumber(p.WidthScale),
                    SizeXOffset = tonumber(p.SizeXOffset) or tonumber(p.WidthOffset),
                    SizeYScale = tonumber(p.SizeYScale) or tonumber(p.HeightScale),
                    SizeYOffset = tonumber(p.SizeYOffset) or tonumber(p.HeightOffset),
                    AbsX = tonumber(p.AbsX), AbsY = tonumber(p.AbsY),
                    AbsW = tonumber(p.AbsW), AbsH = tonumber(p.AbsH),
                }
                _applyExactLayout(btn, lay, 0, btn.Position.X.Offset, 0, btn.Position.Y.Offset)
            end
        end
    end
end

local function collectYassinConfig()
    pcall(snapshotLivePositions)
    local skip = (INTRO and INTRO.look == true) or (skipIntroEnabled == true)
    local kbOut = {}
    if type(KB) == "table" then
        for name, entry in pairs(KB) do
            if type(entry) == "table" then
                kbOut[name] = {
                    kb = entry.kb and entry.kb.Name or nil,
                    gp = entry.gp and entry.gp.Name or nil,
                }
            end
        end
    end
    local jumpPower, jumpMode = 50, "HOLD"
    pcall(function()
        if InfiniteJump then
            jumpPower = tonumber(InfiniteJump.jumpPower) or 50
            jumpMode = InfiniteJump.mode or "HOLD"
        end
    end)
    return {
        NS = tonumber(NS) or 60,
        CS = tonumber(CS) or 28,
        LAGGER_SPEED = tonumber(LAGGER_SPEED) or 21,
        LAGGER_CARRY_SPEED = tonumber(LAGGER_CARRY_SPEED) or 24.5,
        BAT_AIMBOT_SPEED = tonumber(BAT_AIMBOT_SPEED) or 58,
        spinSpeed = tonumber(spinSpeed) or 35,
        speedMode = speedMode == true,
        laggerToggled = laggerToggled == true,
        laggerCarryToggled = laggerCarryToggled == true,
        antiRagdollEnabled = antiRagdollEnabled == true,
        antiRagdollVersion = "v1",
        antiBatEnabled = antiBatEnabled == true,
        antiDieEnabled = antiDieEnabled == true,
        spinEnabled = spinEnabled == true,
        autoSpinEnabled = autoSpinEnabled == true,
        medusaCounterEnabled = medusaCounterEnabled == true,
        batCounterEnabled = batCounterEnabled == true,
        autoLeftEnabled = autoLeftEnabled == true,
        autoRightEnabled = autoRightEnabled == true,
        autoBatEnabled = autoBatEnabled == true,
        unwalkEnabled = unwalkEnabled == true,
        playerAnimEnabled = playerAnimEnabled == true,
        playerAnimMode = tostring(playerAnimMode or "Unwalk"),
        jumpEnabled = jumpEnabled == true,
        jumpPower = jumpPower,
        jumpMode = jumpMode,
        espEnabled = espEnabled == true,
        antiLagEnabled = antiLagEnabled == true,
        stretchEnabled = stretchEnabled == true,
        stretchValue = tonumber(stretchValue) or 0.7,
        stretchFOV = tonumber(stretchFOV) or 120,
        currentSoundPack = tostring(currentSoundPack or "V1"),
        minecraftBatSkinEnabled = minecraftBatSkinEnabled == true,
        minecraftBatSkinColorMode = tostring(minecraftBatSkinColorMode or "Default"),
        autoGrabSetDelayRadius = tonumber(autoGrabSetDelayRadius) or 9,
        stealDuration = (Steal and tonumber(Steal.StealDuration)) or 1.3,
        fovEnabled = fovEnabled == true,
        fovValue = tonumber(fovValue) or 70,
        customSoundsEnabled = customSoundsEnabled == true,
        removeAccessoriesEnabled = removeAccessoriesEnabled == true,
        ragdollCountdownEnabled = ragdollCountdownEnabled == true,
        MEDUSA_COOLDOWN = tonumber(MEDUSA_COOLDOWN) or 25,
        V2_STOP_PERCENT = tonumber(V2_STOP_PERCENT) or 70,
        NORMAL_STOP_PERCENT = tonumber(NORMAL_STOP_PERCENT) or 90,
        backgroundImageTransparency = tonumber(backgroundImageTransparency) or 0,
        uiLocked = uiLocked == true,
        mobileButtonsHidden = mobileButtonsHidden == true,
        mobileButtonStyle = tostring(mobileButtonStyle or "Square"),
        autoStealBarHidden = autoStealBarHidden == true,
        uiScaleValue = tonumber(uiScaleValue) or 74,
        progressBarScaleValue = tonumber(progressBarScaleValue) or 80,
        floatingButtonScale = tonumber(floatingButtonScale) or 1,
        aimbotMode = tostring(aimbotMode or "V2"),
        selectedAimbotMode = tostring(selectedAimbotMode or aimbotMode or "V2"),
        autoBatRuntimeMode = tostring(activeAimbotMode or aimbotMode or "V2"),
        autoBatSource = tostring(autoBatSource or "key"),
        bypassAutoBatMobileEnabled = bypassAutoBatMobileEnabled == true,
        stealRange = (CONFIG and tonumber(CONFIG.STEAL_RANGE)) or 61,
        autoStealEnabled = (CONFIG and CONFIG.AUTO_STEAL_ENABLED) == true,
        stealMode = tostring(stealMode or "V2"),
        dropMode = 1, -- Locked: always save Jump.
        skipIntro = skip,
        lookSkipIntro = skip,
        mainGuiPos = _G._RaptureSavedMainPos,
        miniBtnPos = _G._RaptureSavedMiniPos,
        progressBarPos = savedProgressBarPos,
        mobilePanelPos = savedMobilePanelPos,
        mobileButtonPositions = savedButtonPositions,
        uiStyle = savedUiStyle,
        keybinds = kbOut,
    }
end

local function collectYassinKeybinds()
    local kbOut = {}
    if type(KB) == "table" then
        for name, entry in pairs(KB) do
            if type(entry) == "table" then
                kbOut[name] = {
                    kb = entry.kb and entry.kb.Name or nil,
                    gp = entry.gp and entry.gp.Name or nil,
                }
            end
        end
    end
    return kbOut
end

local function applyYassinConfig(data)
    if type(data) ~= "table" then return false end
    _isLoading = true
    local function num(v, d)
        local n = tonumber(v)
        return n or d
    end
    NS = num(data.NS, NS)
    CS = num(data.CS, CS)
    LAGGER_SPEED = num(data.LAGGER_SPEED, LAGGER_SPEED)
    LAGGER_CARRY_SPEED = num(data.LAGGER_CARRY_SPEED, LAGGER_CARRY_SPEED)
    BAT_AIMBOT_SPEED = num(data.BAT_AIMBOT_SPEED, BAT_AIMBOT_SPEED)
    spinSpeed = num(data.spinSpeed, spinSpeed)
    speedMode = data.speedMode == true
    laggerToggled = data.laggerToggled == true
    laggerCarryToggled = data.laggerCarryToggled == true
    antiRagdollEnabled = data.antiRagdollEnabled == true
    antiRagdollVersion = "v1"
    antiBatEnabled = data.antiBatEnabled == true
    spinEnabled = data.spinEnabled == true
    autoSpinEnabled = data.autoSpinEnabled == true
    antiDieEnabled = spinEnabled or autoSpinEnabled
    medusaCounterEnabled = data.medusaCounterEnabled == true
    batCounterEnabled = data.batCounterEnabled == true
    autoLeftEnabled = data.autoLeftEnabled == true
    autoRightEnabled = data.autoRightEnabled == true
    autoBatEnabled = data.autoBatEnabled == true
    unwalkEnabled = data.unwalkEnabled == true
    jumpEnabled = data.jumpEnabled == true
    espEnabled = data.espEnabled == true
    antiLagEnabled = data.antiLagEnabled == true
    stretchEnabled = data.stretchEnabled == true
    stretchValue = num(data.stretchValue, stretchValue)
    stretchFOV = num(data.stretchFOV, stretchFOV or 120)
    if data.currentSoundPack ~= nil then currentSoundPack = tostring(data.currentSoundPack) end
    if data.minecraftBatSkinEnabled ~= nil then minecraftBatSkinEnabled = data.minecraftBatSkinEnabled == true end
    if data.minecraftBatSkinColorMode ~= nil then minecraftBatSkinColorMode = tostring(data.minecraftBatSkinColorMode) end
    autoGrabSetDelayRadius = num(data.autoGrabSetDelayRadius, autoGrabSetDelayRadius or 9)
    if Steal then Steal.StealDuration = num(data.stealDuration, Steal.StealDuration or 1.3) end
    fovEnabled = data.fovEnabled == true
    fovValue = num(data.fovValue, fovValue)
    uiLocked = data.uiLocked == true
    mobileButtonsHidden = data.mobileButtonsHidden == true
    if data.mobileButtonStyle == "Square" or data.mobileButtonStyle == "Rounded" or data.mobileButtonStyle == "Circle" then mobileButtonStyle = data.mobileButtonStyle end
    if data.autoStealBarHidden ~= nil then autoStealBarHidden = data.autoStealBarHidden == true end
    uiScaleValue = num(data.uiScaleValue, uiScaleValue)
    progressBarScaleValue = num(data.progressBarScaleValue, progressBarScaleValue)
    floatingButtonScale = num(data.floatingButtonScale, floatingButtonScale)
    aimbotMode = data.aimbotMode or data.selectedAimbotMode or aimbotMode or "V2"
    selectedAimbotMode = aimbotMode
    activeAimbotMode = normalizeAimbotMode(data.autoBatRuntimeMode or aimbotMode)
    autoBatSource = tostring(data.autoBatSource or "key")
    bypassAutoBatMobileEnabled = data.bypassAutoBatMobileEnabled == true
    if CONFIG then
        CONFIG.STEAL_RANGE = num(data.stealRange, CONFIG.STEAL_RANGE or 61)
        CONFIG.AUTO_STEAL_ENABLED = data.autoStealEnabled == true
    end
    if Steal then Steal.StealRadius = (CONFIG and CONFIG.STEAL_RANGE) or 61 end
    local skip = (data.lookSkipIntro == true) or (data.skipIntro == true)
    skipIntroEnabled = skip
    if INTRO then INTRO.look = skip end
    if type(data.mainGuiPos) == "table" then _G._RaptureSavedMainPos = data.mainGuiPos end
    if type(data.miniBtnPos) == "table" then
        _G._RaptureSavedMiniPos = data.miniBtnPos
        -- The reopen button is created before saved settings are loaded, so
        -- explicitly apply its stored position now instead of leaving it at default.
        pcall(function()
            if miniBtn and miniBtn.Parent then
                local pos = data.miniBtnPos
                miniBtn.Position = UDim2.new(
                    tonumber(pos.XScale) or 0, tonumber(pos.XOffset) or 10,
                    tonumber(pos.YScale) or 0, tonumber(pos.YOffset) or 50
                )
                if tonumber(pos.SizeXScale) and tonumber(pos.SizeXOffset)
                    and tonumber(pos.SizeYScale) and tonumber(pos.SizeYOffset) then
                    miniBtn.Size = UDim2.new(pos.SizeXScale, pos.SizeXOffset, pos.SizeYScale, pos.SizeYOffset)
                end
            end
        end)
    end
    if type(data.progressBarPos) == "table" then savedProgressBarPos = data.progressBarPos end
    if type(data.mobilePanelPos) == "table" then savedMobilePanelPos = data.mobilePanelPos end
    if type(data.mobileButtonPositions) == "table" then savedButtonPositions = data.mobileButtonPositions end
    if type(data.uiStyle) == "table" then
        savedUiStyle = data.uiStyle
        if mainUIScale and tonumber(savedUiStyle.mainUIScale) then
            mainUIScale.Scale = math.clamp(tonumber(savedUiStyle.mainUIScale), 0.3, 2)
        end
    end
    if data.stealMode ~= nil then stealMode = tostring(data.stealMode) end
    if data.dropMode ~= nil then
        dropMode = 1 -- Locked: always use Jump; ignore saved mode values.
        if dropModeSetVisual then pcall(dropModeSetVisual) end
    end
    if data.playerAnimMode ~= nil then playerAnimMode = tostring(data.playerAnimMode) end
    if data.customSoundsEnabled ~= nil then customSoundsEnabled = data.customSoundsEnabled == true end
    if data.removeAccessoriesEnabled ~= nil then removeAccessoriesEnabled = data.removeAccessoriesEnabled == true end
    if data.ragdollCountdownEnabled ~= nil then ragdollCountdownEnabled = data.ragdollCountdownEnabled == true end
    if data.playerAnimEnabled ~= nil then playerAnimEnabled = data.playerAnimEnabled == true end
    if data.MEDUSA_COOLDOWN ~= nil then MEDUSA_COOLDOWN = num(data.MEDUSA_COOLDOWN, MEDUSA_COOLDOWN) end
    if data.V2_STOP_PERCENT ~= nil then V2_STOP_PERCENT = num(data.V2_STOP_PERCENT, V2_STOP_PERCENT) end
    if data.NORMAL_STOP_PERCENT ~= nil then NORMAL_STOP_PERCENT = num(data.NORMAL_STOP_PERCENT, NORMAL_STOP_PERCENT) end
    if data.backgroundImageTransparency ~= nil then backgroundImageTransparency = num(data.backgroundImageTransparency, backgroundImageTransparency) end
    -- TP Down controls are removed from the UI. Ignore obsolete saved values.
    _G._AmbitiousTPDownMethod = "NORMAL"
    autoTPEnabled = false
    autoTPHeight = 20
    pcall(stopAutoTPDown)
    pcall(function()
        if InfiniteJump then
            if data.jumpPower ~= nil then InfiniteJump.jumpPower = num(data.jumpPower, InfiniteJump.jumpPower or 50) end
            if type(data.jumpMode) == "string" then InfiniteJump.mode = data.jumpMode end
        end
    end)
    -- Key Panel (keybinds)
    local kbData = data.keybinds
    if type(kbData) == "table" and type(KB) == "table" then
        for name, entry in pairs(kbData) do
            if type(entry) == "table" and type(KB[name]) == "table" then
                if type(entry.kb) == "string" and Enum.KeyCode[entry.kb] then
                    KB[name].kb = Enum.KeyCode[entry.kb]
                elseif entry.kb == nil then
                    KB[name].kb = nil
                end
                if type(entry.gp) == "string" and Enum.KeyCode[entry.gp] then
                    KB[name].gp = Enum.KeyCode[entry.gp]
                elseif entry.gp == nil then
                    KB[name].gp = nil
                end
            end
        end
    end
    -- Refresh Key Panel button labels after load
    pcall(function()
        if type(keyButtonRefs) == "table" then
            for _, ref in ipairs(keyButtonRefs) do
                if ref and ref.btn and ref.entry then
                    local e = ref.entry
                    local label = (e.gp and e.gp.Name) or (e.kb and e.kb.Name) or "None"
                    ref.btn.Text = label
                end
            end
        end
    end)
    if type(setAntiBatEnabled) == "function" then pcall(setAntiBatEnabled, antiBatEnabled) end
    _isLoading = false
    return true
end

function saveConfig()
    if _isResetting then return false end
    if _G._YassinSuppressSave then return false end
    pcall(snapshotLivePositions)
    local payload, encoded
    local encOk = pcall(function()
        payload = collectYassinConfig()
        encoded = HS:JSONEncode(payload)
    end)
    if not encOk or type(encoded) ~= "string" or #encoded < 2 then
        return false
    end

    -- Memory first (survives re-execute on Delta if process stays alive)
    pcall(function()
        local env = (type(getgenv) == "function" and getgenv()) or _G
        env.YassinOnTopCFG = encoded
        env.YassinOnTopCFG_Table = payload
        env._YassinOnTop_SavedConfig = payload
        env._YassinOnTop_SavedConfigJson = encoded
    end)
    pcall(function()
        _G.YassinOnTopCFG = encoded
        _G.YassinOnTopCFG_Table = payload
        _G._YassinOnTop_SavedConfig = payload
        _G._YassinOnTop_SavedConfigJson = encoded
    end)
    pcall(function()
        if type(shared) == "table" then
            shared.YassinOnTopCFG = encoded
            shared._YassinOnTop_SavedConfig = payload
        end
    end)

    -- Delta mobile: resolve writefile / makefolder from every known place
    local wf, mf, isf
    pcall(function() wf = writefile end)
    pcall(function() mf = makefolder end)
    pcall(function() isf = isfolder end)
    pcall(function() if not wf and type(getgenv) == "function" then wf = getgenv().writefile end end)
    pcall(function() if not wf and type(syn) == "table" then wf = syn.writefile end end)
    pcall(function() if not wf then wf = _G.writefile end end)
    pcall(function() if not mf and type(getgenv) == "function" then mf = getgenv().makefolder end end)
    pcall(function() if not isf and type(getgenv) == "function" then isf = getgenv().isfolder end end)

    if type(mf) == "function" then
        pcall(function()
            if type(isf) ~= "function" or not isf("Yassin") then mf("Yassin") end
        end)
    end

    local diskOk = false
    local hasDiskWriter = type(wf) == "function"
    if hasDiskWriter then
        -- Write one canonical file only. Writing several aliases in sequence could
        -- leave different copies stale when an executor rejects some paths.
        local paths = {
            STATE_FILE,
            "Yassin_OnTop_Config.json",
            "YassinOnTop.json",
            "Yassin/Yassin_OnTop_Config.json",
            "Yassin/YassinOnTop.json",
        }
        local seen = {}
        local rf
        pcall(function() rf = readfile end)
        pcall(function() if not rf and type(getgenv) == "function" then rf = getgenv().readfile end end)
        pcall(function() if not rf and type(syn) == "table" then rf = syn.readfile end end)
        pcall(function() if not rf then rf = _G.readfile end end)
        for _, p in ipairs(paths) do
            if type(p) == "string" and p ~= "" and not seen[p] then
                seen[p] = true
                local writeOk = pcall(wf, p, encoded)
                if writeOk then
                    local verified = true
                    if type(rf) == "function" then
                        local readOk, body = pcall(rf, p)
                        verified = readOk and type(body) == "string" and body == encoded
                    end
                    if verified then
                        diskOk = true
                        STATE_FILE = p
                        break
                    end
                end
            end
        end
        -- Keep a separate keybind file for older versions, but the primary JSON
        -- already contains keybinds and remains the source of truth.
        local kb
        pcall(function() kb = HS:JSONEncode(collectYassinKeybinds()) end)
        if type(kb) == "string" then
            local kp = (type(STATE_FILE) == "string" and STATE_FILE:find("/") and "Yassin/Yassin_OnTop_Keybinds.json") or "Yassin_OnTop_Keybinds.json"
            pcall(wf, kp, kb)
        end
    end

    _G._YassinLastSaveOk = diskOk
    _G._YassinLastSaveAt = os.clock()
    -- Memory fallback is useful only when the executor exposes no filesystem API.
    _G._YassinMemorySaveOk = type(_G.YassinOnTopCFG) == "string" and #_G.YassinOnTopCFG > 1
    return diskOk == true or (not hasDiskWriter and _G._YassinMemorySaveOk == true)
end

function persistRuntimeState()
    return saveConfig()
end

function restoreRuntimeState()
    local function decode(body)
        if type(body) ~= "string" or #body < 3 then return nil end
        local ok, data = pcall(function() return HS:JSONDecode(body) end)
        if ok and type(data) == "table" then return data end
        return nil
    end

    local rf
    pcall(function() rf = readfile end)
    pcall(function() if not rf and type(getgenv) == "function" then rf = getgenv().readfile end end)
    pcall(function() if not rf and type(syn) == "table" then rf = syn.readfile end end)
    pcall(function() if not rf then rf = _G.readfile end end)

    local data = nil
    if type(rf) == "function" then
        local paths = {
            "YassinOnTop.json",
            "Yassin_OnTop_Config.json",
            "Yassin/YassinOnTop.json",
            "Yassin/Yassin_OnTop_Config.json",
            "workspace/Yassin_OnTop_Config.json",
            "yassin_config.json",
        }
        for _, p in ipairs(paths) do
            local ok, body = pcall(rf, p)
            if ok then
                data = decode(body)
                if data then
                    STATE_FILE = p
                    break
                end
            end
        end
    end

    if not data then
        pcall(function()
            local env = (type(getgenv) == "function" and getgenv()) or _G
            if type(env.YassinOnTopCFG_Table) == "table" then
                data = env.YassinOnTopCFG_Table
            elseif type(env.YassinOnTopCFG) == "string" then
                data = decode(env.YassinOnTopCFG)
            elseif type(env._YassinOnTop_SavedConfig) == "table" then
                data = env._YassinOnTop_SavedConfig
            elseif type(env._YassinOnTop_SavedConfigJson) == "string" then
                data = decode(env._YassinOnTop_SavedConfigJson)
            end
        end)
    end
    if not data then
        pcall(function()
            if type(_G.YassinOnTopCFG_Table) == "table" then data = _G.YassinOnTopCFG_Table
            elseif type(_G.YassinOnTopCFG) == "string" then data = decode(_G.YassinOnTopCFG)
            elseif type(_G._YassinOnTop_SavedConfig) == "table" then data = _G._YassinOnTop_SavedConfig end
        end)
    end
    if not data then
        pcall(function()
            if type(shared) == "table" then
                if type(shared._YassinOnTop_SavedConfig) == "table" then data = shared._YassinOnTop_SavedConfig
                elseif type(shared.YassinOnTopCFG) == "string" then data = decode(shared.YassinOnTopCFG) end
            end
        end)
    end

    if not data then return false end

    if type(rf) == "function" then
        pcall(function()
            for _, p in ipairs({ "YassinOnTop_Keybinds.json", "Yassin/YassinOnTop_Keybinds.json", "Yassin_OnTop_Keybinds.json" }) do
                local ok, body = pcall(rf, p)
                if ok then
                    local kb = decode(body)
                    if type(kb) == "table" then data.keybinds = kb; break end
                end
            end
        end)
    end

    return applyYassinConfig(data) == true
end

function loadConfig()
    return restoreRuntimeState()
end

-- Event-driven autosave: only save after a real settings/layout change.
-- A short debounce combines rapid edits into one complete snapshot.
local _settingsSaveVersion = 0
function markSettingsDirty()
    if _isResetting or _G._YassinSuppressSave or _isLoading then return end
    _settingsDirty = true
    _settingsSaveVersion = _settingsSaveVersion + 1
    local version = _settingsSaveVersion

    task.delay(0.2, function()
        if version ~= _settingsSaveVersion then return end
        if _isResetting or _G._YassinSuppressSave or _isLoading or not _settingsDirty then return end

        -- Always capture latest Absolute positions/sizes right before writing
        pcall(function()
            if type(snapshotLivePositions) == "function" then snapshotLivePositions() end
        end)

        -- Try the save once, then make a small number of event-triggered retries
        -- if the executor's file API is temporarily unavailable. Never poll forever.
        local delays = { 0, 0.5, 1.2 }
        for attempt, waitTime in ipairs(delays) do
            if waitTime > 0 then task.wait(waitTime) end
            if version ~= _settingsSaveVersion then return end
            if _isResetting or _G._YassinSuppressSave or _isLoading then return end

            local ok, saved = pcall(function() return saveConfig() end)
            if ok and saved == true then
                _settingsDirty = false
                return
            end
        end
        -- Leave dirty=true so the next user edit triggers another save attempt.
    end)
end


function clearConfigFile()
    local fs = _yassinFs()
    if fs.delfile then
        pcall(fs.delfile, STATE_FILE)
        pcall(fs.delfile, KEYBINDS_FILE)
    elseif fs.writefile then
        pcall(fs.writefile, STATE_FILE, "")
        pcall(fs.writefile, KEYBINDS_FILE, "")
    end
end


function applyLoadedFeatureStates()
    -- Start/stop REAL engines from saved flags, then sync visuals.
    -- Visual setters (mkToggle sv) only move the pill — they do NOT run the callback.
    local function call(fn, ...)
        if type(fn) == "function" then pcall(fn, ...) end
    end
    local wasLoading = _isLoading
    _isLoading = true
    _G._YassinSuppressSave = true

    -- --- Engines ---
    if CONFIG and CONFIG.AUTO_STEAL_ENABLED then
        call(startAutoSteal)
    else
        call(stopAutoSteal)
    end

    if autoLeftEnabled then call(startAutoLeft) else call(stopAutoLeft) end
    if autoRightEnabled then call(startAutoRight) else call(stopAutoRight) end

    autoTPEnabled = false
    call(stopAutoTPDown)

    if autoBatEnabled then
        call(enableAutoBat)
    else
        call(disableAutoBat)
    end

    if antiRagdollEnabled then
        call(startAntiRagdoll)
    else
        call(stopAntiRagdoll, true)
    end

    if antiBatEnabled then
        call(setAntiBatEnabled, true)
    else
        call(setAntiBatEnabled, false)
    end

    if antiDieEnabled then
        if _antiDie then call(_antiDie.StartEngine) end
    else
        if _antiDie then call(_antiDie.StopEngine) end
    end

    if jumpEnabled then
        if InfiniteJump then call(InfiniteJump.start) end
    else
        if InfiniteJump then call(InfiniteJump.stop) end
    end

    if medusaCounterEnabled then
        if LP.Character then call(setupMedusaCounter, LP.Character) end
    else
        call(stopMedusaCounter)
    end

    if batCounterEnabled then call(startBatCounter) else call(stopBatCounter) end
    if espEnabled then call(startESP) else call(stopESP) end
    if antiLagEnabled then call(enableAntiLag) else call(disableAntiLag) end
    if fovEnabled then call(enableCustomFov) else call(disableCustomFov) end

    if stretchEnabled then
        call(enableStretch)
        if _G.stretchToggleSetter then call(_G.stretchToggleSetter, true) end
    else
        call(disableStretch)
        if _G.stretchToggleSetter then call(_G.stretchToggleSetter, false) end
    end

    if playerAnimEnabled or unwalkEnabled then
        if _G._YassinRefreshPlayerAnimAfterLoad then
            call(_G._YassinRefreshPlayerAnimAfterLoad)
        else
            call(startUnwalk)
        end
    else
        call(stopUnwalk)
    end

    if spinEnabled or autoSpinEnabled then call(startSpin) else call(stopSpin) end

    -- Speed modes (carry / lagger) — visual + state only; movement loop reads flags live
    if type(refreshSpeedModeLabel) == "function" then call(refreshSpeedModeLabel) end
    if type(setCarryModeVisual) == "function" then
        call(setCarryModeVisual, speedMode == true and not laggerToggled and not laggerCarryToggled)
    end
    if type(mobSetCarry) == "function" then
        call(mobSetCarry, speedMode == true and not laggerToggled and not laggerCarryToggled)
    end
    if type(mobSetLagger1) == "function" then call(mobSetLagger1, laggerToggled == true) end
    if type(mobSetLagger2) == "function" then call(mobSetLagger2, laggerCarryToggled == true) end

    -- --- Visuals only (do not start engines) ---
    if autoBatSetVisual then call(autoBatSetVisual, autoBatEnabled == true and (autoBatSource == "key" or autoBatSource == "combat")) end
    if autoLeftSetVisual then call(autoLeftSetVisual, autoLeftEnabled == true) end
    if autoRightSetVisual then call(autoRightSetVisual, autoRightEnabled == true) end
    if setAntiRagVisual then call(setAntiRagVisual, antiRagdollEnabled == true) end
    if setAntiBatVisual then call(setAntiBatVisual, antiBatEnabled == true) end
    if setAntiDieVisual then call(setAntiDieVisual, antiDieEnabled == true) end
    if setMedusaVisual then call(setMedusaVisual, medusaCounterEnabled == true) end
    if setBatCounterVisual then call(setBatCounterVisual, batCounterEnabled == true) end
    if setJumpVisual then call(setJumpVisual, jumpEnabled == true) end
    if setInstaGrab then call(setInstaGrab, (CONFIG and CONFIG.AUTO_STEAL_ENABLED) == true) end
    if setMobileButtonsHiddenVisual then call(setMobileButtonsHiddenVisual, mobileButtonsHidden == true) end
    if setLockUIVisual then call(setLockUIVisual, uiLocked == true) end
    if aimbotModeSetVisual then call(aimbotModeSetVisual, aimbotMode == "V2" and "Bypass" or "Normal") end
    if setESPVisual then call(setESPVisual, espEnabled == true) end
    if setAntiLagVisual then call(setAntiLagVisual, antiLagEnabled == true) end
    if setFovVisual then call(setFovVisual, fovEnabled == true) end
    if setSpinToggleVisual then call(setSpinToggleVisual, spinEnabled == true) end
    if setAutoSpinToggleVisual then call(setAutoSpinToggleVisual, autoSpinEnabled == true) end
    call(updateProgressBarVisibility)

    _isLoading = false
    _G._YassinSuppressSave = false
end

function resetToFactoryDefaults()
    _isResetting = true
    pcall(clearConfigFile)
    _settingsDirty = false
    _lastLayoutEditTime = 0
    local ok, err = pcall(function()
        -- Clear runtime flags first, then stop connections/effects.
        autoBatEnabled = false; autoLeftEnabled = false; autoRightEnabled = false
        pcall(stopAutoTPDown)
        autoTPEnabled = false
        autoTPHeight = 20
        CONFIG.AUTO_STEAL_ENABLED = false
        if Steal then Steal.AutoStealEnabled = false end
        pcall(stopAllBackgroundTasks)
        pcall(stopSpin)
        pcall(function() setAntiRagdollEnabled(false) end)
        pcall(function() setAntiBatEnabled(false) end)
        pcall(function() if _antiDie then _antiDie.StopEngine() end end)
        pcall(disableCustomFov)
        pcall(stopAutoSteal)
        pcall(stopAutoLeft)
        pcall(stopAutoRight)
        pcall(disableAutoBat)
        pcall(stopBatCounter)
        pcall(stopMedusaCounter)
        pcall(stopESP)
        pcall(disableAntiLag)
        pcall(stopUnwalk)
        pcall(stopDropBrainrot)
        pcall(function() if InfiniteJump then InfiniteJump.stop() end end)
        pcall(function() if AntiRagdollV2 then AntiRagdollV2.stop() end end)
        pcall(stopAntiRagdollV2)
        pcall(function() if _antiDie then _antiDie.StopEngine() end end)
        NS = 60; CS = 29; LAGGER_SPEED = 15; LAGGER_CARRY_SPEED = 24.5
        if INTRO then INTRO.look = false end
        skipIntroEnabled = false
        if skipIntroToggleSet then pcall(skipIntroToggleSet, false) end
        CONFIG.STEAL_RANGE = 61
        if Steal then Steal.StealRadius = CONFIG.STEAL_RANGE end
        stealMode = "V2"
        speedMode = false; laggerToggled = false; laggerCarryToggled = false
        autoBatEnabled = false; autoLeftEnabled = false; autoRightEnabled = false
        dropActive = false; unwalkEnabled = false
        antiRagdollEnabled = false; antiRagdollVersion = "v1"
        pcall(function() if setAntiRagVisual then setAntiRagVisual(false) end end)
        antiDieEnabled = false
        spinEnabled = false; autoSpinEnabled = false; spinSpeed = 35
        if spinSpeedBox then spinSpeedBox.Text = tostring(spinSpeed) end
        pcall(stopSpin)
        medusaCounterEnabled = false; batCounterEnabled = false; ragdollCountdownEnabled = false
        autoBatEnabled = false; autoLeftEnabled = false; autoRightEnabled = false
        jumpEnabled = false
        if InfiniteJump then pcall(function() InfiniteJump.stop() end); InfiniteJump.jumpPower = 50; InfiniteJump.mode = "HOLD" end
        _G._AmbitiousTPDownMethod = "NORMAL"
        _G._AmbitiousTPDownJumpLocked = false
        _G._AmbitiousSlowFallActive = false
        _G._AmbitiousZigZagFalling = false
        if setJumpVisual then pcall(setJumpVisual, false) end
        unwalkEnabled = false; uiLocked = true
        CONFIG.AUTO_STEAL_ENABLED = false
        if Steal then Steal.AutoStealEnabled = false end
        BAT_AIMBOT_SPEED = 58
        aimbotMode = "V2"
        selectedAimbotMode = "V2"
        activeAimbotMode = "V2"
        autoBatSource = "key"
        bypassAutoBatMobileEnabled = false
        _G.aimbotMode = "V2"
        customSoundsEnabled = false
        batBypassEnabled = false
        setAntiBatEnabled(false)
        minecraftBatSkinEnabled = false
        minecraftBatSkinColorMode = "Default"
        if _G._RaptureBatBypass and _G._RaptureBatBypass.enabled then _G.RaptureStopBatBypass() end
        if deactivateAllBatSkins then pcall(deactivateAllBatSkins) end
        stretchEnabled = false; stretchValue = 0.7; fovValue = 70
        uiScaleValue = 74; progressBarScaleValue = 80; autoStealBarHidden = false
        progressBarScale = 1
        V2_STOP_PERCENT = 70; NORMAL_STOP_PERCENT = 90
        MEDUSA_COOLDOWN = 25; autoGrabSetDelayRadius = 9
        if Steal then Steal.StealDuration = 1.3 end
        dropMode = 1
        if dropModeSetVisual then pcall(dropModeSetVisual) end
        floatingButtonScale = 1
        espEnabled = false; antiLagEnabled = false
        for key, val in pairs(DEFAULT_KB) do
            if KB[key] then KB[key].kb = val.kb; KB[key].gp = val.gp end
        end
        savedButtonPositions = {}
        -- Factory reset clears saved layout snapshots and restores feature defaults.
        savedMobilePanelPos = nil
        savedProgressBarPos = nil
        batBypassFloatingPos = nil
        instaResetFloatingPos = nil
        _G._RaptureSavedMiniPos = nil
        mobileButtonsHidden = false
        mobileButtonStyle = "Square"
        if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
            local bcStyle = MobilePanel.FloatingPanel:FindFirstChild("ButtonsContainer")
            if bcStyle then
                for _, button in ipairs(bcStyle:GetChildren()) do
                    if button:IsA("TextButton") then
                        local c = button:FindFirstChildOfClass("UICorner"); if c then c.CornerRadius = UDim.new(0, 0) end
                        local img = button:FindFirstChild("ButtonImage"); local ic = img and img:FindFirstChildOfClass("UICorner"); if ic then ic.CornerRadius = UDim.new(0, 0) end
                    end
                end
            end
        end
        removeAccessoriesEnabled = false
        playerAnimEnabled = false
        playerAnimMode = "Unwalk"
        useCarrySystem = false
        currentAnimPack = "Off"
        currentSoundPack = "V1"
        fovEnabled = false
        fovValue = 70
        stretchFOV = 120
        floatingButtonScale = 1
        backgroundImageTransparency = 0
        if setMobileButtonsHiddenVisual then pcall(setMobileButtonsHiddenVisual, false) end
        if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
            local bc = MobilePanel.FloatingPanel:FindFirstChild("ButtonsContainer")
            if bc then bc.Visible = true end
        end
        savedProgressBarPos = nil
        _G._RaptureSavedMainPos = nil
        savedUiStyle = nil
        savedMobilePanelPos = nil
        batBypassFloatingPos = nil
        instaResetFloatingPos = nil
        if main then
            main.Position = UDim2.new(0, 20, 0, 2)
            main.Size = UDim2.new(0, 350, 0, 500)
            main.BackgroundColor3 = Color3.fromRGB(10, 12, 20)
            main.BackgroundTransparency = 1
            local bg = main:FindFirstChild("BackgroundImage")
            if bg and bg:IsA("ImageLabel") then
                bg.Image = "rbxassetid://" .. BACKGROUND_IMAGE_ID
                bg.BackgroundColor3 = Color3.fromRGB(10, 12, 20)
                bg.BackgroundTransparency = 0
                bg.ImageTransparency = 0
            end
            local corner = main:FindFirstChildOfClass("UICorner")
            if corner then corner.CornerRadius = UDim.new(0, 18) end
        end
        -- Reset main UI scale
        if mainUIScale then mainUIScale.Scale = uiScaleValue / 100 end
        if pbScale then pbScale.Scale = progressBarScaleValue / 100 end
        updateProgressBarVisibility()
        applyFloatingButtonScale()
        -- Reset all movable UI elements to first-run positions.
        if main then main.Position = UDim2.new(0, 20, 0, 2) end
        if miniBtn then miniBtn.Position = UDim2.new(0, 12, 0, 58) end
        if pbFrame then
            pbFrame.Position = UDim2.new(0.5, -280, 1, -110)
        end
        if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
            MobilePanel.FloatingPanel.Position = UDim2.new(1, -140, 0.5, -120)
        end
        -- Reset mobile floating buttons to default grid
        if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
            local container = MobilePanel:FindFirstChild("FloatingPanel")
            local bc = container:FindFirstChild("ButtonsContainer")
            if bc then
                for _, btn in ipairs(bc:GetChildren()) do
                    if btn:IsA("TextButton") and btn.Name then
                        local defX, defY = getDefaultButtonPosition(btn.Name)
                        btn.Position = UDim2.new(0, defX, 0, defY)
                        btn:SetAttribute("MobActive", false)
                        paintFloatingBtn(btn, false)
                    end
                end
            end
        end
        -- Update scale boxes if open
        if uiScaleBox then uiScaleBox.Text = tostring(uiScaleValue) end
        if progressBarScaleBox then progressBarScaleBox.Text = tostring(progressBarScaleValue) end
        if normalBox then normalBox.Text = tostring(NS) end
        if carryBox then carryBox.Text = tostring(CS) end
        if spinSpeedBox then spinSpeedBox.Text = tostring(spinSpeed) end
        if laggerBox then laggerBox.Text = tostring(LAGGER_SPEED) end
        if lagger2Box then lagger2Box.Text = tostring(LAGGER_CARRY_SPEED) end
        if radInput then radInput.Text = tostring(CONFIG.STEAL_RANGE) end
        if batSpeedBox then batSpeedBox.Text = tostring(BAT_AIMBOT_SPEED) end
        if setLockUIVisual then setLockUIVisual(true) end
        task.defer(function()
            if setAntiRagVisual then setAntiRagVisual(false) end
            if setInstaGrab then setInstaGrab(false) end
            if dropBrainrotSetVisual then dropBrainrotSetVisual(false) end
            if setBatCounterVisual then setBatCounterVisual(false) end
            if setMedusaVisual then setMedusaVisual(false) end
            if autoLeftSetVisual then autoLeftSetVisual(false) end
            if autoRightSetVisual then autoRightSetVisual(false) end
            if autoBatSetVisual then autoBatSetVisual(false) end
                    if batBypassSetVisual then batBypassSetVisual(false) end
            if setESPVisual then setESPVisual(false) end
            if setAntiLagVisual then setAntiLagVisual(false) end
            if setFovVisual then setFovVisual(false) end
            if setAntiDieVisual then pcall(setAntiDieVisual, false) end
            if setJumpVisual then pcall(setJumpVisual, false) end
            if setAntiBatVisual then pcall(setAntiBatVisual, false) end
            if setMobileButtonsHiddenVisual then pcall(setMobileButtonsHiddenVisual, false) end
            if setSpinToggleVisual then pcall(setSpinToggleVisual, false) end
            if setAutoSpinToggleVisual then pcall(setAutoSpinToggleVisual, false) end
            if _G.stretchToggleSetter then pcall(_G.stretchToggleSetter, false) end
            if aimbotModeSetVisual then aimbotModeSetVisual((aimbotMode == "V2") and "Bypass" or "Normal") end
            refreshSpeedModeLabel()
        end)
        updateAllUIThemeColors(PASTEL_PINK)
        _RaptureApplyThemeToSliders()
                _settingsDirty = false
        -- Keep the next snapshot aligned with factory layout instead of stale saved offsets.
        _G._RaptureSavedMainPos = { XScale = 0, XOffset = 20, YScale = 0, YOffset = 2 }
        _G._RaptureSavedMiniPos = { XScale = 0, XOffset = 12, YScale = 0, YOffset = 58 }
        savedProgressBarPos = { XScale = 0.5, XOffset = -280, YScale = 1, YOffset = -110 }
        savedMobilePanelPos = { XScale = 1, XOffset = -140, YScale = 0.5, YOffset = -120 }
    end)
    _isResetting = false
    if not ok then warn("Factory reset error: " .. tostring(err)) end
    if ok then
        uiLocked = true
        if setLockUIVisual then pcall(setLockUIVisual, true) end
        _settingsDirty = false
        -- Persist the reset baseline.
        local savedOk, savedResult = pcall(persistRuntimeState)
        if not savedOk or savedResult ~= true then
            warn("Factory defaults applied, but automatic config save failed")
        end
    end
    return ok
end

function updateProgressBarVisibility()
    if pbFrame then pbFrame.Visible = not (autoStealBarHidden == true) end
end

function getDefaultButtonPosition(btnName)
    -- Clean 2-column grid on the RIGHT (user layout)
    local BTN = 52
    local GAP = 8
    local map = {
        InstaReset = {c = 0.5, r = 0},
        AutoRight  = {c = 0,   r = 1},
        AutoLeft   = {c = 1,   r = 1},
        DropBR     = {c = 0,   r = 2},
        TpDown     = {c = 1,   r = 2},
        Carry      = {c = 0,   r = 3},
        AutoBat    = {c = 1,   r = 3},
        Lagger1    = {c = 0,   r = 4},
        Lagger2    = {c = 1,   r = 4},
        AntiBat    = {c = 0,   r = 5},
        BypassAutoBat = {c = 1, r = 5},
    }
    local e = map[btnName] or {c = 0, r = 0}
    local x = (e.c == 0.5) and ((BTN + GAP) * 0.5) or (e.c * (BTN + GAP))
    local y = e.r * (BTN + GAP)
    return x, y
end

-- # ENEMY SPEED LABELS
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

-- INSTANT RESET — core logic adapted from AmbitiousTest
do
    if not _G.InstaResetLoaded then
        _G.InstaResetLoaded = true
        _G._AmbitiousInstantResetBusy = false
        _G._AmbitiousResetGaveUp = false
        _G.AmbitiousInstantResetVersion = math.clamp(tonumber(_G.AmbitiousInstantResetVersion) or 1, 1, 2)
        _G._AmbitiousResetCamConn = nil
        _G._AmbitiousResetCamSaved = nil

        local resetCooldown = false
        local resetThread = nil
        local lastResetRequest = 0

        local function resetV1()
            _G._AmbitiousResetGaveUp = false
            local character = LP.Character
            if not character then _G._AmbitiousResetGaveUp = true; return end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if not humanoid then _G._AmbitiousResetGaveUp = true; return end
            local originalHipHeight = humanoid.HipHeight
            local attempts, done = 0, false
            while character and character.Parent and humanoid and humanoid.Health > 0
                and LP.Character == character and attempts < 40 do
                pcall(function()
                    humanoid.HipHeight = 1e30
                    humanoid.AutoRotate = true
                    for _, part in ipairs(character:GetChildren()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end)
                if not character.Parent or humanoid.Health <= 0 or LP.Character ~= character then
                    done = true; break
                end
                attempts = attempts + 1
                task.wait(0.05)
            end
            if not done and character and character.Parent and humanoid and humanoid.Health > 0 then
                pcall(function() humanoid.Health = 0 end)
                task.wait(0.1)
                if not character.Parent or humanoid.Health <= 0 then done = true end
            end
            if not done then
                _G._AmbitiousResetGaveUp = true
                if character and character.Parent and humanoid then
                    pcall(function()
                        humanoid.HipHeight = originalHipHeight
                        for _, part in ipairs(character:GetChildren()) do
                            if part:IsA("BasePart") then part.CanCollide = true end
                        end
                    end)
                end
            end
        end

        local function resetV2()
            _G._AmbitiousResetGaveUp = false
            local character = LP.Character
            if not character then _G._AmbitiousResetGaveUp = true; return end
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            local root = character:FindFirstChild("HumanoidRootPart")
            if not humanoid or not root then _G._AmbitiousResetGaveUp = true; return end
            local savedPlatform, savedBreak = humanoid.PlatformStand, humanoid.BreakJointsOnDeath
            local BURST, WINDOW, FLING = 500, 0.3, 1e9
            local function applyFling(hum, r)
                hum.BreakJointsOnDeath = true
                hum.PlatformStand = true
                hum:ChangeState(Enum.HumanoidStateType.Physics)
                r.AssemblyAngularVelocity = Vector3.zero
                r.AssemblyLinearVelocity = Vector3.new(0, FLING, 0)
            end
            local function attempt()
                local ch = LP.Character
                if ch ~= character or not character.Parent then return false end
                local hum = ch:FindFirstChildOfClass("Humanoid")
                if not hum or hum.Health <= 0 then return false end
                local r = ch:FindFirstChild("HumanoidRootPart")
                if r then pcall(applyFling, hum, r) end
                return true
            end
            local t0 = os.clock()
            for _ = 1, BURST do if not attempt() then return end end
            while os.clock() - t0 < WINDOW do
                RunService.Heartbeat:Wait()
                if not attempt() then return end
            end
            if not character.Parent or LP.Character ~= character or humanoid.Health <= 0 then return end
            _G._AmbitiousResetGaveUp = true
            pcall(function()
                humanoid.PlatformStand = savedPlatform
                humanoid.BreakJointsOnDeath = savedBreak
                humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
                root.AssemblyLinearVelocity = Vector3.zero
            end)
        end

        local function doInstantReset()
            if (tonumber(_G.AmbitiousInstantResetVersion) or 1) == 2 then resetV2() else resetV1() end
        end

        local function lockResetCamera()
            local cam = workspace.CurrentCamera
            if not cam then return end
            if _G._AmbitiousResetCamConn then pcall(function() _G._AmbitiousResetCamConn:Disconnect() end) end
            _G._AmbitiousResetCamSaved = { cframe = cam.CFrame, type = cam.CameraType, subject = cam.CameraSubject }
            cam.CameraType = Enum.CameraType.Scriptable
            _G._AmbitiousResetCamConn = RunService.RenderStepped:Connect(function()
                local current = workspace.CurrentCamera
                local saved = _G._AmbitiousResetCamSaved
                if current and saved then
                    if current.CameraType ~= Enum.CameraType.Scriptable then current.CameraType = Enum.CameraType.Scriptable end
                    current.CFrame = saved.cframe
                end
            end)
        end

        local function unlockResetCamera()
            if _G._AmbitiousResetCamConn then
                pcall(function() _G._AmbitiousResetCamConn:Disconnect() end)
                _G._AmbitiousResetCamConn = nil
            end
            local saved = _G._AmbitiousResetCamSaved
            _G._AmbitiousResetCamSaved = nil
            if not saved then return end
            local cam = workspace.CurrentCamera
            if not cam then return end
            pcall(function()
                local char = LP.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                cam.CameraType = saved.type == Enum.CameraType.Scriptable and Enum.CameraType.Custom or saved.type
                cam.CameraSubject = hum or saved.subject
            end)
        end

        local function instaReset()
            local now = os.clock()
            if resetCooldown or _G._AmbitiousInstantResetBusy or now - lastResetRequest < 0.75 then return end
            lastResetRequest = now
            resetCooldown = true
            _G._AmbitiousInstantResetBusy = true
            local oldCharacter = LP.Character
            local wasAntiDie = antiDieEnabled == true
            -- Suspend Anti Die temporarily so it cannot undo the reset; restore it after respawn.
            if wasAntiDie then
                pcall(function() if _antiDie and type(_antiDie.StopEngine) == "function" then _antiDie.StopEngine() end end)
            end
            pcall(lockResetCamera)
            resetThread = task.spawn(function()
                pcall(doInstantReset)
                local deadline = tick() + 25
                while tick() < deadline do
                    if _G._AmbitiousResetGaveUp then break end
                    local ch = LP.Character
                    if ch and ch.Parent and ch ~= oldCharacter then
                        local hum = ch:FindFirstChildOfClass("Humanoid")
                        local hrp = ch:FindFirstChild("HumanoidRootPart")
                        if hum and hrp and hum.Health > 0 then break end
                    end
                    task.wait(0.05)
                end
                pcall(unlockResetCamera)
                if wasAntiDie then
                    local deadlineAnti = tick() + 20
                    while tick() < deadlineAnti do
                        local ch = LP.Character
                        local hum = ch and ch:FindFirstChildOfClass("Humanoid")
                        if ch and ch.Parent and hum and hum.Health > 0 then break end
                        task.wait(0.1)
                    end
                    pcall(function()
                        if _antiDie and type(_antiDie.StartEngine) == "function" then _antiDie.StartEngine() end
                    end)
                    antiDieEnabled = true
                    _antiDieEnabled = true
                    if setAntiDieVisual then pcall(setAntiDieVisual, true) end
                end
                _G._AmbitiousInstantResetBusy = false
                resetCooldown = false
                resetThread = nil
            end)
        end

        LP.CharacterAdded:Connect(function()
            -- The reset worker owns camera unlock and Anti Die restoration after the new character is ready.
            -- Do not cancel that worker on CharacterAdded.
        end)
        _G.AmbitiousInstantReset = instaReset
        _G.InstaReset = { Trigger = instaReset }
    end
end

-- # MINECRAFT BAT SKIN
minecraftBatSkinEnabled = false
minecraftBatSkinColorMode = "Default"

local MinecraftBatSkin = (function()
    local MB_ASSET_ID = "rbxassetid://18566246244"
    local MB_POS_OFFSET = _CFnew(-0.02, -0.52, -0.2)
    local MB_ROT_OFFSET = CFrame.Angles(math.rad(45), math.rad(0), math.rad(5))
    local MB_SCALE = 2

    local MB_COLORS = {
        ["Default"] = nil,
        ["Abyss Purple"] = Color3.fromRGB(108, 22, 150),
        ["Venom Purple"] = Color3.fromRGB(184, 61, 255),
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

-- # BAT SKIN PICKER
function openBatSkinPicker()
    -- Bat Skin removed
end


function buildGui()
    local ROW_BG = Color3.fromRGB(0, 0, 0)
    local WHITE = Color3.fromRGB(255, 255, 255)
    local INP = Color3.fromRGB(10, 10, 10)
    local TAB_INACT = Color3.fromRGB(235, 235, 245)
    local GUI_W, GUI_H = 350, 500

    local old = CoreGui:FindFirstChild("RaptureDuel_New")
    if old then old:Destroy() end
    local pg = LP:FindFirstChild("PlayerGui")
    if pg then local o = pg:FindFirstChild("RaptureDuel_New"); if o then o:Destroy() end end
    -- Clean reopen layer too (mobile + PC)
    for _, host in ipairs({CoreGui, pg}) do
        if host then
            local m = host:FindFirstChild("YassinReopenGui")
            if m then pcall(function() m:Destroy() end) end
        end
    end

    gui = Instance.new("ScreenGui")
    gui.Name = "RaptureDuel_New"
    gui.ResetOnSpawn = false
    gui.DisplayOrder = 9999
    gui.IgnoreGuiInset = true
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(gui) end end)
    local guiOk = pcall(function() gui.Parent = CoreGui end)
    if not guiOk then gui.Parent = LP:WaitForChild("PlayerGui") end

    main = Instance.new("Frame", gui)
    main.Size = UDim2.new(0, GUI_W, 0, GUI_H)
    do
        local mp = _G._RaptureSavedMainPos
        if mp then
            main.Position = UDim2.new(mp.XScale or 0, mp.XOffset or 20, mp.YScale or 0, mp.YOffset or 2)
        else
            main.Position = UDim2.new(0, 20, 0, 2)
        end
    end
    main.BackgroundColor3 = Color3.fromRGB(10, 12, 20)
    main.BackgroundTransparency = 1
    main.BorderSizePixel = 0
    main.ClipsDescendants = true
    Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)

    local bgImage = Instance.new("ImageLabel", main)
    bgImage.Name = "BackgroundImage"
    bgImage.Size = UDim2.new(1, 0, 1, 0)
    bgImage.Position = UDim2.new(0, 0, 0, 0)
    bgImage.BackgroundColor3 = Color3.fromRGB(10, 12, 20)
    bgImage.BackgroundTransparency = 0
    bgImage.Image = "rbxassetid://" .. BACKGROUND_IMAGE_ID
    bgImage.ImageTransparency = backgroundImageTransparency
    bgImage.ScaleType = Enum.ScaleType.Crop
    bgImage.ZIndex = 0
    bgImage.ClipsDescendants = true
    Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 18)

    -- YASSIN ON TOP branding at the top of the script background
    local brandShadow = Instance.new("TextLabel", main)
    brandShadow.Name = "YassinOnTopShadow"
    brandShadow.AnchorPoint = Vector2.new(0.5, 0)
    brandShadow.Position = UDim2.new(0.5, 3, 0, 8)
    brandShadow.Size = UDim2.new(1, -20, 0, 48)
    brandShadow.BackgroundTransparency = 1
    brandShadow.Text = "YASSIN ON TOP"
    brandShadow.Font = Enum.Font.Fantasy
    brandShadow.TextSize = 34
    brandShadow.TextColor3 = Color3.fromRGB(0, 0, 0)
    brandShadow.TextTransparency = 0.2
    brandShadow.TextStrokeTransparency = 1
    brandShadow.TextXAlignment = Enum.TextXAlignment.Center
    brandShadow.TextYAlignment = Enum.TextYAlignment.Center
    brandShadow.ZIndex = 10

    local brandLabel = Instance.new("TextLabel", main)
    brandLabel.Name = "YassinOnTopTitle"
    brandLabel.AnchorPoint = Vector2.new(0.5, 0)
    brandLabel.Position = UDim2.new(0.5, 0, 0, 5)
    brandLabel.Size = UDim2.new(1, -20, 0, 48)
    brandLabel.BackgroundTransparency = 1
    brandLabel.Text = "YASSIN ON TOP"
    brandLabel.Font = Enum.Font.Fantasy
    brandLabel.TextSize = 34
    brandLabel.TextColor3 = Color3.fromRGB(184, 116, 255)
    brandLabel.TextStrokeColor3 = Color3.fromRGB(5, 20, 45)
    brandLabel.TextStrokeTransparency = 0.25
    brandLabel.TextXAlignment = Enum.TextXAlignment.Center
    brandLabel.TextYAlignment = Enum.TextYAlignment.Center
    brandLabel.ZIndex = 11
    local brandGradient = Instance.new("UIGradient")
    brandGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(184, 99, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(235, 250, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(184, 63, 255))
    })
    brandGradient.Parent = brandLabel

    mainUIScale = Instance.new("UIScale", main)
    -- Keep the existing desktop scale unchanged; use a responsive multiplier only
    -- on touch devices so the complete menu fits better on phone screens.
    local function getYassinResponsiveScale()
        local base = math.clamp((tonumber(uiScaleValue) or 74) / 100, 0.5, 1.5)
        local cam = workspace.CurrentCamera
        local viewport = cam and cam.ViewportSize or Vector2.new(1280, 720)
        if UIS.TouchEnabled then
            local fit = math.clamp(math.min(viewport.X / 430, viewport.Y / 760), 0.62, 1)
            return base * fit
        end
        return base
    end
    local function refreshYassinResponsiveScale()
        if mainUIScale then mainUIScale.Scale = getYassinResponsiveScale() end
    end
    refreshYassinResponsiveScale()
    pcall(function()
        local cam = workspace.CurrentCamera
        if cam then
            cam:GetPropertyChangedSignal("ViewportSize"):Connect(refreshYassinResponsiveScale)
        end
        workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
            local nextCam = workspace.CurrentCamera
            if nextCam then
                nextCam:GetPropertyChangedSignal("ViewportSize"):Connect(refreshYassinResponsiveScale)
            end
            refreshYassinResponsiveScale()
        end)
    end)

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
    titleLbl.TextSize = 24
    titleLbl.TextXAlignment = Enum.TextXAlignment.Left
    titleLbl.ZIndex = 21

    lockBtn = nil

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
    closeBtn.Activated:Connect(function() hideGui() end)

    -- Separate top-layer ScreenGui so the reopen button is never buried under
    -- the mobile floating panel / touch controls (PC was fine; mobile was not).
    local miniGui = Instance.new("ScreenGui")
    miniGui.Name = "YassinReopenGui"
    miniGui.ResetOnSpawn = false
    miniGui.IgnoreGuiInset = true
    miniGui.DisplayOrder = 100000
    miniGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function()
        if syn and syn.protect_gui then syn.protect_gui(miniGui) end
    end)
    local miniParentOk = pcall(function() miniGui.Parent = CoreGui end)
    if not miniParentOk then
        pcall(function() miniGui.Parent = LP:WaitForChild("PlayerGui") end)
    end
    if not miniGui.Parent then
        miniGui.Parent = gui -- last resort
    end

    miniBtn = Instance.new("TextButton", miniGui)
    miniBtn.Name = "YassinReopenButton"
    miniBtn.AnchorPoint = Vector2.new(0, 0)
    miniBtn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    miniBtn.BackgroundTransparency = 0.05
    miniBtn.BorderSizePixel = 0
    miniBtn.Text = "yassin"
    miniBtn.TextColor3 = getThemeColor()
    miniBtn.Font = Enum.Font.GothamBlack
    miniBtn.TextSize = 16
    miniBtn.ZIndex = 10
    miniBtn.Visible = false
    miniBtn.AutoButtonColor = true
    miniBtn.Active = true
    miniBtn.Selectable = true
    miniBtn.Modal = false
    pcall(function() miniBtn.Interactable = true end)
    Instance.new("UICorner", miniBtn).CornerRadius = UDim.new(0, 10)
    local miniStroke = Instance.new("UIStroke", miniBtn)
    miniStroke.Color = getThemeColor()
    miniStroke.Thickness = 1.5
    miniStroke.Transparency = 0.15

    local function applyMiniButtonLayout(useSavedPosition)
        local camera = workspace.CurrentCamera
        local viewport = camera and camera.ViewportSize or Vector2.new(800, 600)
        local touchDevice = UIS.TouchEnabled == true
        -- Bigger hit target on phones so it is easy to tap like PC click.
        local width = touchDevice and 120 or 110
        local height = touchDevice and 48 or 36
        miniBtn.Size = UDim2.new(0, width, 0, height)
        miniBtn.Text = "yassin"
        miniBtn.TextSize = touchDevice and 16 or 15

        local saved = useSavedPosition and _G._RaptureSavedMiniPos or nil
        -- Default: top-left, below typical mobile safe / notch area.
        local defaultX, defaultY = 10, touchDevice and 70 or 50
        local x = defaultX
        local y = defaultY
        if saved then
            x = (saved.XScale or 0) * viewport.X + (saved.XOffset or defaultX)
            y = (saved.YScale or 0) * viewport.Y + (saved.YOffset or defaultY)
        end
        x = math.clamp(x, 6, math.max(6, viewport.X - width - 6))
        y = math.clamp(y, 6, math.max(6, viewport.Y - height - 6))
        miniBtn.Position = UDim2.new(0, math.floor(x), 0, math.floor(y))
        if miniGui then miniGui.Enabled = true end
    end
    applyMiniButtonLayout(true)

    local function _openFromMini()
        pcall(function()
            if type(showGui) == "function" then showGui() end
        end)
    end
    -- PC + mobile: the reopen button follows the same Look/Lock rule as the GUI.
    -- When Lock is OFF it can be dragged; when Lock is ON it only opens the menu.
    local miniDragActive = false
    local miniDragMoved = false
    local miniDragStart = nil
    local miniStartPos = nil
    local miniDragInput = nil
    local miniDragEndConn = nil
    local suppressMiniClick = false
    local function endMiniDrag()
        if miniDragActive and miniDragMoved then
            suppressMiniClick = true
            -- Save the exact final position immediately and persist it with the rest
            -- of the configuration, so reopening/re-executing keeps this location.
            _G._RaptureSavedMiniPos = _safePosition(miniBtn)
            -- Position is included in the unified one-second config snapshot.
            pcall(function()
                if type(markSettingsDirty) == "function" then markSettingsDirty() end
            end)
            task.delay(0.15, function() suppressMiniClick = false end)
        end
        miniDragActive = false
        miniDragMoved = false
        miniDragInput = nil
        if miniDragEndConn then miniDragEndConn:Disconnect(); miniDragEndConn = nil end
    end
    miniBtn.InputBegan:Connect(function(input)
        if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
        if uiLocked then return end
        miniDragActive = true
        miniDragMoved = false
        miniDragStart = input.Position
        miniStartPos = miniBtn.Position
        if miniDragEndConn then miniDragEndConn:Disconnect() end
        miniDragEndConn = input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then endMiniDrag() end
        end)
    end)
    miniBtn.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            miniDragInput = input
        end
    end)
    UIS.InputChanged:Connect(function(input)
        if not miniDragActive or uiLocked or not miniDragStart or not miniStartPos then return end
        if input ~= miniDragInput then return end
        local dx = input.Position.X - miniDragStart.X
        local dy = input.Position.Y - miniDragStart.Y
        if math.abs(dx) + math.abs(dy) > 3 then miniDragMoved = true end
        if miniDragMoved then
            local camera = workspace.CurrentCamera
            local viewport = camera and camera.ViewportSize or Vector2.new(800, 600)
            local width, height = miniBtn.AbsoluteSize.X, miniBtn.AbsoluteSize.Y
            local x = math.clamp(miniStartPos.X.Offset + dx, 6, math.max(6, viewport.X - width - 6))
            local y = math.clamp(miniStartPos.Y.Offset + dy, 6, math.max(6, viewport.Y - height - 6))
            miniBtn.Position = UDim2.new(0, math.floor(x), 0, math.floor(y))
        end
    end)
    UIS.InputEnded:Connect(function(input)
        if miniDragActive and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then endMiniDrag() end
    end)
    miniBtn.Activated:Connect(function()
        if suppressMiniClick or miniDragMoved then return end
        _openFromMini()
    end)

    -- Keep the restore button reachable when the player rotates the phone or resizes the window.
    local miniCameraConnection
    local function watchMiniViewport()
        if miniCameraConnection then miniCameraConnection:Disconnect(); miniCameraConnection = nil end
        local camera = workspace.CurrentCamera
        if camera then
            miniCameraConnection = camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
                if miniBtn and miniBtn.Parent then
                    applyMiniButtonLayout(false)
                    if markSettingsDirty then pcall(markSettingsDirty) end
                end
            end)
        end
    end
    watchMiniViewport()
    workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(watchMiniViewport)
    -- Re-clamp main GUI when rotating phone / resizing window (PC ↔ mobile).
    pcall(function()
        local cam = workspace.CurrentCamera
        if cam then
            cam:GetPropertyChangedSignal("ViewportSize"):Connect(function()
                if main and main.Visible then
                    pcall(_yassinClampOnScreen, main, 0, 20, 0, 2)
                    if type(_refreshMainOriginalPos) == "function" then
                        -- defined later in same block; use direct update
                    end
                    if main and main.Visible then
                        local p = main.Position
                        if not (p.X.Scale == 0 and p.X.Offset < -50) then
                            mainOriginalPos = p
                        end
                    end
                end
                if miniBtn and miniBtn.Visible then
                    pcall(function()
                        if type(applyMiniButtonLayout) == "function" then applyMiniButtonLayout(false) end
                    end)
                end
            end)
        end
    end)

    local slideTween = nil
    local mainOriginalPos = main.Position

    local function _refreshMainOriginalPos()
        if main and main.Visible then
            local p = main.Position
            -- Never treat the off-screen hide slot as the "open" position.
            if not (p.X.Scale == 0 and p.X.Offset < -50) then
                mainOriginalPos = p
                -- Keep the saved config in sync with the position used when reopening.
                _G._RaptureSavedMainPos = {
                    XScale = p.X.Scale, XOffset = p.X.Offset,
                    YScale = p.Y.Scale, YOffset = p.Y.Offset,
                }
            end
        end
    end
    _refreshMainOriginalPos()

    showGui = function(opts)
        if slideTween then pcall(function() slideTween:Cancel() end) end
        if not main then return end
        -- During intro, only allow instant placement; never animate.
        if _G._YassinIntroActive and not (type(opts) == "table" and opts.instant) then
            return
        end
        if gui then gui.Enabled = true end
        if miniBtn then miniBtn.Visible = false end
        local openPos = mainOriginalPos
        -- The local open position is captured while buildGui runs, before saved
        -- settings are loaded. Prefer the persisted position when one exists.
        local savedMainPos = _G._RaptureSavedMainPos
        if type(savedMainPos) == "table" then
            openPos = UDim2.new(
                tonumber(savedMainPos.XScale) or 0, tonumber(savedMainPos.XOffset) or 20,
                tonumber(savedMainPos.YScale) or 0, tonumber(savedMainPos.YOffset) or 2
            )
            mainOriginalPos = openPos
        end
        if type(openPos) ~= "userdata" and type(openPos) ~= "table" then
            openPos = UDim2.new(0, 20, 0, 2)
        end
        if openPos.X.Scale == 0 and openPos.X.Offset < -50 then
            openPos = UDim2.new(0, 20, 0, 2)
        end
        local wasHidden = (main.Visible == false)
        local forceInstant = type(opts) == "table" and opts.instant == true
        main.Visible = true
        if forceInstant or not wasHidden then
            -- Already visible (e.g. after intro) or forced: snap, no slide flash.
            main.Position = openPos
            pcall(_yassinClampOnScreen, main, 0, 20, 0, 2)
            _refreshMainOriginalPos()
            return
        end
        -- Reopen from mini button: slide in once.
        main.Position = UDim2.new(0, -GUI_W - 20, 0, openPos.Y.Offset)
        slideTween = TS:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = openPos})
        slideTween:Play()
        pcall(function()
            slideTween.Completed:Connect(function()
                if main then
                    _yassinClampOnScreen(main, 0, 20, 0, 2)
                    _refreshMainOriginalPos()
                end
            end)
        end)
    end

    hideGui = function()
        if not main or not main.Visible then return end
        -- Capture the actual open position BEFORE the close animation moves the panel off-screen.
        _refreshMainOriginalPos()
        pcall(function()
            if type(snapshotLivePositions) == "function" then snapshotLivePositions() end
            if type(markSettingsDirty) == "function" then markSettingsDirty() end
        end)
        if slideTween then pcall(function() slideTween:Cancel() end) end
        local openPosition = mainOriginalPos or main.Position
        local targetPos = UDim2.new(0, -GUI_W - 20, 0, openPosition.Y.Offset)
        slideTween = TS:Create(main, TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {Position = targetPos})
        slideTween:Play()
        slideTween.Completed:Connect(function()
            if main then main.Visible = false end
            if miniBtn then
                miniBtn.Visible = true
                miniBtn.Text = "yassin"
                miniBtn.Active = true
                pcall(function() miniBtn.Interactable = true end)
                -- Force on-screen + above everything (mobile fix).
                pcall(function()
                    if type(applyMiniButtonLayout) == "function" then
                        applyMiniButtonLayout(true)
                    end
                end)
                -- Ensure host ScreenGui is enabled
                local host = miniBtn.Parent
                if host and host:IsA("ScreenGui") then
                    host.Enabled = true
                    host.DisplayOrder = 100000
                end
            end
            if markSettingsDirty then pcall(markSettingsDirty) end
            slideTween = nil
        end)
    end

    local TAB_H = 42
    local tabBar = Instance.new("Frame", main)
    tabBar.Name = "TopTabBar"
    tabBar.Size = UDim2.new(1, -16, 0, TAB_H)
    tabBar.Position = UDim2.new(0, 8, 0, 48) -- move tab strip higher on the main panel
    tabBar.BackgroundTransparency = 1
    tabBar.BorderSizePixel = 0
    tabBar.ZIndex = 20

    local tabLayout = Instance.new("UIListLayout", tabBar)
    tabLayout.FillDirection = Enum.FillDirection.Horizontal
    tabLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    tabLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    tabLayout.Padding = UDim.new(0, 6)
    tabLayout.SortOrder = Enum.SortOrder.LayoutOrder

    local tabContent = Instance.new("Frame", main)
    tabContent.Name = "TabContent"
    tabContent.Size = UDim2.new(1, -20, 1, -134 - TAB_H - 16)
    tabContent.Position = UDim2.new(0, 10, 0, 134)
    tabContent.BackgroundTransparency = 1
    tabContent.ClipsDescendants = true
    tabContent.ZIndex = 5

    local tabs = {"Speed", "Combat", "Visual", "Settings", "Keybinds"}
    local tabButtonsLocal = {}
    local contentPagesLocal = {}

    for i, name in ipairs(tabs) do
        local btn = Instance.new("TextButton", tabBar)
        btn.Size = UDim2.new(0, 60, 0, 30)
        btn.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
        btn.BackgroundTransparency = 0.15
        btn.BorderSizePixel = 0
        btn.Text = name
        btn.TextColor3 = TAB_INACT
        btn.Font = Enum.Font.GothamBlack
        btn.TextSize = 13
        btn.TextWrapped = true
        btn.AutoButtonColor = false
        btn.ZIndex = 21
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
        l.Size = UDim2.new(0.62, 0, 1, 0)
        l.Position = UDim2.new(0, 12, 0, 0)
        l.BackgroundTransparency = 1
        l.Text = txt
        l.TextColor3 = Color3.fromRGB(255, 255, 255)
        l.Font = Enum.Font.GothamBlack
        l.TextSize = 16
        l.TextXAlignment = Enum.TextXAlignment.Left
        l.TextTruncate = Enum.TextTruncate.AtEnd
        l.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
        l.TextStrokeTransparency = 0
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
        -- Softer mobile-friendly toggle row: rounded corners and a subtle neutral outline.
        row.BackgroundTransparency = 0.08
        row.BorderSizePixel = 0
        local rowCorner = row:FindFirstChildOfClass("UICorner") or Instance.new("UICorner")
        rowCorner.CornerRadius = UDim.new(0, 10)
        rowCorner.Parent = row
        local rowStroke = row:FindFirstChildOfClass("UIStroke") or Instance.new("UIStroke")
        rowStroke.Color = Color3.fromRGB(63, 41, 88)
        rowStroke.Thickness = 1
        rowStroke.Transparency = 0.58
        rowStroke.Parent = row
        local toggleLabel = mkLabel(row, txt)
        toggleLabel.Position = UDim2.new(0, 40, 0, 0)
        toggleLabel.Size = UDim2.new(0.5, -24, 1, 0)
        toggleLabel.ZIndex = 11
        local pill, dot = mkPill(row, 10)
        local on = false
        local function sv(s) on = s; animPill(pill, dot, s) end
        local clk = Instance.new("TextButton", pill)
        clk.Size = UDim2.new(1,0,1,0)
        clk.BackgroundTransparency = 1
        clk.Text = ""
        clk.AutoButtonColor = false
        clk.Active = true
        clk.Selectable = true
        clk.ZIndex = 10
        clk.MouseButton1Click:Connect(function()
            on = not on
            sv(on)
            pcall(cb, on)
            markSettingsDirty()
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
        tb.TextColor3 = Color3.fromRGB(255, 255, 255)
        tb.Font = Enum.Font.GothamBlack
        tb.TextSize = 14
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
                markSettingsDirty()
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
            setValue(v); updateLabel(); markSettingsDirty()
        end)
        plusBtn.MouseButton1Click:Connect(function()
            local v = getValue() + step
            if v > maxV then v = maxV end
            setValue(v); updateLabel(); markSettingsDirty()
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
        lbl.TextSize = 14
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
                markSettingsDirty()
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
                -- VX7-style binding capture: keep keyboard and gamepad bindings
                -- separate, and release duplicate assignments on the same device.
                local capturedKey = inp.KeyCode
                local capturedDevice = isGp and "gp" or "kb"
                for _, other in pairs(KB) do
                    if other ~= kbEntry and other[capturedDevice] == capturedKey then
                        other[capturedDevice] = nil
                    end
                end
                if isGp then
                    kbEntry.gp = capturedKey
                    kbEntry.kb = nil
                else
                    kbEntry.kb = capturedKey
                    kbEntry.gp = nil
                end
                li = false; _anyKeyListening = false
                if lc then lc:Disconnect(); lc = nil end
                pv = capturedKey.Name
                btn.Text = pv
                -- Update every small key button immediately after a rebind.
                for _, ref in ipairs(keyButtonRefs) do
                    if ref and ref.btn and ref.entry then
                        ref.btn.Text = (ref.entry.gp and ref.entry.gp.Name)
                            or (ref.entry.kb and ref.entry.kb.Name) or "None"
                    end
                end
                markSettingsDirty()
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

    do local row = mkRow(speedPage); mkLabel(row, "Normal Speed"); normalBox = mkBox(row, NS, 50, 60, function(v) if v > 0 and v <= 500 then NS = v; markSettingsDirty() end end) end
    do local row = mkRow(speedPage); mkLabel(row, "Carry Speed"); carryBox = mkBox(row, CS, 50, 60, function(v) if v > 0 and v <= 500 then CS = v; markSettingsDirty() end end) end
    do local row = mkRow(speedPage); mkLabel(row, "Lagger"); laggerBox = mkBox(row, LAGGER_SPEED, 50, 60, function(v) if v > 0 and v <= 500 then LAGGER_SPEED = v; markSettingsDirty() end end) end
    do local row = mkRow(speedPage); mkLabel(row, "Lagger Carry"); lagger2Box = mkBox(row, LAGGER_CARRY_SPEED, 50, 60, function(v) if v > 0 and v <= 500 then LAGGER_CARRY_SPEED = v; markSettingsDirty() end end) end

    -- Anti Bat toggle placed directly under the speed controls in the main Speed tab.
    setAntiBatVisual = mkToggle(speedPage, "Anti Bat", function(on)
        setAntiBatEnabled(on == true)
        markSettingsDirty()
    end)

    -- Spin controls intentionally placed at the very bottom of the Speed list.
    -- Anti Die is automatic: it follows either Spin toggle and is not shown as a separate UI option.
    local function syncSpinAntiDie()
        local shouldEnableAntiDie = (spinEnabled == true) or (autoSpinEnabled == true)
        if shouldEnableAntiDie then
            if not (_antiDie and _antiDie.enabled) then pcall(function() _antiDie.StartEngine() end) end
            antiDieEnabled = true
            _antiDieEnabled = true
        else
            if _antiDie and _antiDie.enabled then pcall(function() _antiDie.StopEngine() end) end
            antiDieEnabled = false
            _antiDieEnabled = false
        end
    end

    setSpinToggleVisual = mkToggle(speedPage, "Spin", function(on)
        spinEnabled = (on == true)
        if spinEnabled or autoSpinEnabled then startSpin() else stopSpin() end
        syncSpinAntiDie()
        markSettingsDirty()
    end)
    if setSpinToggleVisual then setSpinToggleVisual(spinEnabled) end
    setAutoSpinToggleVisual = mkToggle(speedPage, "Auto Spin", function(on)
        autoSpinEnabled = (on == true)
        if spinEnabled or autoSpinEnabled then startSpin() else stopSpin() end
        syncSpinAntiDie()
        markSettingsDirty()
    end)
    if setAutoSpinToggleVisual then setAutoSpinToggleVisual(autoSpinEnabled) end
    do
        local row = mkRow(speedPage)
        mkLabel(row, "Spin Speed")
        spinSpeedBox = mkBox(row, spinSpeed, 60, 60, function(v)
            if v and v >= 1 and v <= 200 then
                spinSpeed = _floor(v + 0.5)
                markSettingsDirty()
            end
        end)
    end

    -- Anti Die runs automatically with Spin or Auto Spin; no separate toggle is displayed.
    setAntiDieVisual = nil
    antiDieEnabled = (spinEnabled == true) or (autoSpinEnabled == true)
    if antiDieEnabled then pcall(function() _antiDie.StartEngine() end)
    else pcall(function() _antiDie.StopEngine() end) end

    local combatPage = contentPages["Combat"]

    setJumpVisual = mkToggle(combatPage, "Infinite Jump", function(on)
        jumpEnabled = (on == true)
        if jumpEnabled then InfiniteJump.start() else InfiniteJump.stop() end
        markSettingsDirty()
    end)
    if setJumpVisual then setJumpVisual(jumpEnabled == true) end

    setBatCounterVisual = mkToggle(combatPage, "Bat Counter", function(on)
        batCounterEnabled = on
        if on then startBatCounter() else stopBatCounter() end
        markSettingsDirty()
    end)

    setMedusaVisual = mkToggle(combatPage, "Medusa Counter", function(on)
        medusaCounterEnabled = on
        if on then if LP.Character then setupMedusaCounter(LP.Character) end
        else stopMedusaCounter() end
        markSettingsDirty()
    end)


    setAntiRagVisual = mkToggle(combatPage, "Anti Ragdoll", function(on)
        setAntiRagdollEnabled(on)
    end)

    setInstaGrab = mkToggle(combatPage, "Auto Steal", function(on)
        CONFIG.AUTO_STEAL_ENABLED = (on == true)
        if on then pcall(startAutoSteal) else stopAutoSteal() end
        updateProgressBarVisibility()
        markSettingsDirty()
    end)

    do local row = mkRow(combatPage); mkLabel(row, "Steal Radius"); radInput = mkBox(row, CONFIG.STEAL_RANGE, 50, 60, function(v) if v and v >= 5 and v <= 300 then CONFIG.STEAL_RANGE = _floor(v+0.5); Steal.StealRadius = CONFIG.STEAL_RANGE; markSettingsDirty() end end) end

    autoBatSetVisual = mkToggle(combatPage, "Bat Aimbot", function(on)
        -- The Combat toggle is standard Normal; AimPot Mode is reserved for the keyboard key.
        if on then
            if autoBatEnabled then disableAutoBat() end
            autoBatSource = "combat"
            enableAutoBat("V1")
        else
            disableAutoBat()
            autoBatSource = "combat"
        end
        if mobSetAutoBat then mobSetAutoBat(false) end
        if bypassAutoBatMobileSetVisual then bypassAutoBatMobileSetVisual(false) end
        bypassAutoBatMobileEnabled = false
        markSettingsDirty()
    end)

    -- AimPot Mode (Key) controls only the keyboard Auto Bat keybind.
    local function setAutoBatInputMode(value)
        local newMode = normalizeAimbotMode((value == "Bypass") and "V2" or "V1")
        aimbotMode = newMode
        selectedAimbotMode = newMode
        _G.aimbotMode = newMode
        if autoBatEnabled and autoBatSource == "key" then
            activeAimbotMode = newMode
            pcall(disableAutoBat)
            pcall(enableAutoBat, newMode)
        end
        markSettingsDirty()
    end
    aimbotModeSetVisual = mkCollapsibleSlider(combatPage, "Aimbot Mode (Key)", {"Normal", "Bypass"},
        function()
            local mode = tostring(aimbotMode or _G.aimbotMode or "V2"):lower()
            return (mode == "bypass" or mode == "v2") and "Bypass" or "Normal"
        end,
        setAutoBatInputMode)
    aimbotModeRefresh = function()
        if aimbotModeSetVisual then
            pcall(aimbotModeSetVisual, (tostring(aimbotMode or "V2"):lower() == "v2" or tostring(aimbotMode or ""):lower() == "bypass") and "Bypass" or "Normal")
        end
    end
    if tostring(aimbotMode or "V2"):lower() == "bypass" then aimbotMode = "V2" end
    if tostring(aimbotMode or "V2"):lower() == "normal" then aimbotMode = "V1" end
    selectedAimbotMode = aimbotMode
    _G.aimbotMode = aimbotMode

    do local row = mkRow(combatPage); mkLabel(row, "Bat Aimbot Speed"); batSpeedBox = mkBox(row, BAT_AIMBOT_SPEED, 50, 60, function(v) if v > 0 and v <= 200 then BAT_AIMBOT_SPEED = v; markSettingsDirty() end end) end
    -- Bat Bypass UI removed
    batBypassSetVisual = nil

    dropBrainrotSetVisual = mkToggle(combatPage, "Drop Brainrot", function(on)
        setDropBrainrot(on)
    end)

    -- Drop Mode selector removed: Drop is permanently locked to Jump.
    dropMode = 1
    dropModeSetVisual = nil

    autoLeftSetVisual = mkToggle(combatPage, "Auto Left", function(on)
        autoLeftEnabled = on
        if on then startAutoLeft() else stopAutoLeft() end
        if mobSetAutoLeft then mobSetAutoLeft(on) end
        markSettingsDirty()
    end)

    autoRightSetVisual = mkToggle(combatPage, "Auto Right", function(on)
        autoRightEnabled = on
        if on then startAutoRight() else stopAutoRight() end
        if mobSetAutoRight then mobSetAutoRight(on) end
        markSettingsDirty()
    end)

    local visualPage = contentPages["Visual"]

    setESPVisual = mkToggle(visualPage, "ESP Players", function(on)
        if on then startESP() else stopESP() end
        markSettingsDirty()
    end)

    setAntiLagVisual = mkToggle(visualPage, "Anti Lag", function(on)
        if on then enableAntiLag() else disableAntiLag() end
        markSettingsDirty()
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
            markSettingsDirty()
        end
        local stretchClk = Instance.new("TextButton", stretchPill)
        stretchClk.Size = UDim2.new(1,0,1,0)
        stretchClk.BackgroundTransparency = 1
        stretchClk.Text = ""
        stretchClk.ZIndex = 10
        stretchClk.MouseButton1Click:Connect(function() setStretch(not stretchOn) end)
        _G.stretchToggleSetter = setStretch
    end
    do local row = mkRow(visualPage); mkLabel(row, "Stretch Value"); stretchValueBox = mkBox(row, stretchValue, 50, 60, function(v) if v and v >= 0.3 and v <= 1.5 then stretchValue = v; if stretchEnabled then disableStretch(); enableStretch() end; markSettingsDirty() end end) end

    setFovVisual = mkToggle(visualPage, "FOV", function(on)
        if on then enableCustomFov() else disableCustomFov() end
        markSettingsDirty()
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
                markSettingsDirty()
            end
        end)
        fovSliderSet = function(val) if fovBox then fovBox.Text = tostring(val) end end
    end


    -- VX7 Player Anim pack selector, integrated at the bottom of Yassin's Visual tab.
    local playerAnimModes, playerAnimPacks =
{
		"Unwalk",
		"TRYHARD",
		"Amazon Unboxed",
		"Zombie",
		"Ninja",
		"Knight",
		"Elder",
		"Levitate",
		"Astronaut",
		"Pirate",
		"Toy",
		"Vampire",
		"Werewolf",
		"Rthro",
		"Stylish",
		"Adidas Sports",
		"Adidas Community",
		"Adidas Aura",
		"Wicked Popular",
		"Mage",
		"Catwalk Glam",
		"Wicked Dancing Through Life",
		"Superhero",
		"No Boundaries",
		"NFL",
		"Robot",
		"Bubbly",
		"Cartoon",
	}, {
		TRYHARD = { 133806214992291, 94970088341563, 707897309, 707861613, 116936326516985, 116936326516985 },
		["Amazon Unboxed"] = {
			98281136301627,
			98281136301627,
			90478085024465,
			134824450619865,
			121454505477205,
			94788218468396,
			121145883950231,
			105962919001086,
			129126268464847,
		},
		Zombie = { 616158929, 616158929, 616168032, 616163682, 616161997, 616157476, 616156119 },
		Ninja = { 656117400, 656117400, 656121766, 656118852, 656117878, 656115606, 656114359 },
		Knight = { 657595757, 657595757, 657552124, 657564596, 658409194, 657600338, 658360781 },
		Elder = { 845397899, 845397899, 845403856, 845386501, 845398858, 845397673, 845392038 },
		Levitate = { 616006778, 616006778, 616013216, 616013216, 616008936, 616005863, 616003713 },
		Astronaut = { 891621366, 891621366, 891636393, 891636393, 891627522, 891617961, 891609353 },
		Pirate = { 750781874, 750781874, 750785693, 750783738, 750782230, 750780242, 750779899 },
		Toy = { 782841498, 782841498, 782843345, 782842708, 782847020, 782846423, 782843869 },
		Vampire = { 1083445855, 1083445855, 1083473930, 1083462077, 1083455352, 1083443587, 1083439238 },
		Werewolf = { 1083195517, 1083195517, 1083178339, 1083216690, 1083218792, 1083189019, 1083182000 },
		Rthro = { 2510196951, 2510196951, 2510202577, 2510198475, 2510197830, 2510195892, 2510192778 },
		Stylish = { 616136790, 616136790, 616146177, 616140816, 616139451, 616134815, 616133594 },
		["Adidas Sports"] = {
			18537376492,
			18537371272,
			18537392113,
			18537384940,
			18537380791,
			18537367238,
			18537387180,
			18537389531,
			18537363391,
		},
		["Adidas Community"] = {
			122257458498464,
			102357151005774,
			122150855457006,
			82598234841035,
			75290611992385,
			98600215928904,
			109346520324160,
			133308483266208,
			88763136693023,
		},
		["Adidas Aura"] = {
			110211186840347,
			114191137265065,
			83842218823011,
			118320322718866,
			109996626521204,
			95603166884636,
			94922130551805,
			134530128383903,
			97824616490448,
		},
		["Wicked Popular"] = {
			118832222982049,
			76049494037641,
			92072849924640,
			72301599441680,
			104325245285198,
			121152442762481,
			113199415118199,
			99384245425157,
			131326830509784,
		},
		Mage = {
			10921144709,
			10921145797,
			10921152678,
			10921148209,
			10921149743,
			10921148939,
			10921151661,
			10921150788,
			10921143404,
		},
		["Catwalk Glam"] = {
			133806214992291,
			94970088341563,
			109168724482748,
			81024476153754,
			116936326516985,
			92294537340807,
			98854111361360,
			134591743181628,
			119377220967554,
		},
		["Wicked Dancing Through Life"] = {
			92849173543269,
			132238900951109,
			73718308412641,
			135515454877967,
			78508480717326,
			78147885297412,
			129183123083281,
			110657013921774,
			129447497744818,
		},
		Superhero = {
			10921288909,
			10921290167,
			10921298616,
			10921291831,
			10921294559,
			10921293373,
			10921297391,
			10921295495,
			10921286911,
		},
		["No Boundaries"] = {
			18747067405,
			18747063918,
			18747074203,
			18747070484,
			18747069148,
			18747062535,
			18747071682,
			18747073181,
			18747060903,
		},
		NFL = {
			92080889861410,
			74451233229259,
			110358958299415,
			117333533048078,
			119846112151352,
			129773241032,
			79090109939093,
			132697394189921,
			134630013742019,
		},
		Robot = { 616088211, 616089559, 616095330, 616091570, 616090535, 616087089, 616094091, 616092998, 616086039 },
		Bubbly = { 910004836, 910009958, 910034870, 910025107, 910016857, 910001910, 910030921, 910028158, 909997997 },
		Cartoon = { 742637544, 742638445, 742640026, 742638842, 742637942, 742637151, 742639812, 742639220, 742636889 },
	}

    local playerAnimOriginals = setmetatable({}, {__mode = "k"})
    local playerAnimSlots = {
        {"idle1", "idle", "Animation1"},
        {"idle2", "idle", "Animation2"},
        {"walk", "walk", "WalkAnim"},
        {"run", "run", "RunAnim"},
        {"jump", "jump", "JumpAnim"},
        {"fall", "fall", "FallAnim"},
        {"climb", "climb", "ClimbAnim"},
        {"swim", "swim", "Swim"},
        {"swimidle", "swimidle", "SwimIdle"},
    }

    local function getPlayerAnimObjects(character)
        local animate = character and character:FindFirstChild("Animate")
        if not animate then return nil, nil end
        local objects = {}
        for _, slot in ipairs(playerAnimSlots) do
            local folder = animate:FindFirstChild(slot[2])
            local obj = folder and folder:FindFirstChild(slot[3])
            objects[slot[1]] = obj
        end
        return animate, objects
    end

    local function restorePlayerAnimPack()
        local character = LP.Character
        if not character then return end
        local animate, objects = getPlayerAnimObjects(character)
        local saved = playerAnimOriginals[character]
        if saved and objects then
            for _, slot in ipairs(playerAnimSlots) do
                local obj = objects[slot[1]]
                if obj and saved[slot[1]] then
                    pcall(function() obj.AnimationId = saved[slot[1]] end)
                end
            end
        end
    end

    local function applyPlayerAnimPack(mode)
        local character = LP.Character
        if not character then return end
        if mode == "Unwalk" then
            pcall(startUnwalk)
            return
        end
        pcall(stopUnwalk)
        local animate, objects = getPlayerAnimObjects(character)
        if not animate or not objects then return end
        if not playerAnimOriginals[character] then
            local originals = {}
            for _, slot in ipairs(playerAnimSlots) do
                local obj = objects[slot[1]]
                if obj then originals[slot[1]] = obj.AnimationId end
            end
            playerAnimOriginals[character] = originals
        end
        local pack = playerAnimPacks[mode]
        if not pack then
            restorePlayerAnimPack()
            return
        end
        for i, slot in ipairs(playerAnimSlots) do
            local obj = objects[slot[1]]
            local assetId = pack[i]
            if obj and assetId then
                pcall(function() obj.AnimationId = "rbxassetid://" .. tostring(assetId) end)
            end
        end
        local hum = character:FindFirstChildOfClass("Humanoid")
        if hum then
            pcall(function()
                for _, track in ipairs(hum:GetPlayingAnimationTracks()) do track:Stop(0) end
            end)
        end
    end

    local function setPlayerAnimMode(mode)
        playerAnimMode = mode
        if playerAnimEnabled then
            if mode == "Unwalk" then
                pcall(startUnwalk)
            else
                pcall(stopUnwalk)
                pcall(applyPlayerAnimPack, mode)
            end
        end
        markSettingsDirty()
    end

    local playerAnimToggleVisual = mkToggle(visualPage, "Player Anim", function(on)
        playerAnimEnabled = (on == true)
        if playerAnimEnabled then
            pcall(applyPlayerAnimPack, playerAnimMode)
        else
            pcall(stopUnwalk)
            pcall(restorePlayerAnimPack)
        end
        markSettingsDirty()
    end)
    if playerAnimToggleVisual then playerAnimToggleVisual(playerAnimEnabled) end

    -- Shared restore hook lets file/config loads reapply any saved VX7 pack after the GUI exists.
    _G._YassinRefreshPlayerAnimAfterLoad = function()
        local validMode = playerAnimMode == "Unwalk" or playerAnimPacks[playerAnimMode] ~= nil
        if not validMode then playerAnimMode = "Unwalk" end
        if playerAnimToggleVisual then pcall(playerAnimToggleVisual, playerAnimEnabled) end
        if _G._YassinRefreshPlayerAnimMode then pcall(_G._YassinRefreshPlayerAnimMode) end
        if playerAnimEnabled then
            pcall(applyPlayerAnimPack, playerAnimMode)
        else
            pcall(stopUnwalk)
            pcall(restorePlayerAnimPack)
        end
        if type(markSettingsDirty) == "function" and not _isLoading then
            -- Do not rewrite settings just because they were restored.
        end
    end

    do
        local row = mkRow(visualPage, 40)
        mkLabel(row, "Player Anim Mode")
        local modeFrame = Instance.new("Frame", row)
        modeFrame.Size = UDim2.new(0, 166, 0, 28)
        modeFrame.Position = UDim2.new(1, -176, 0.5, -14)
        modeFrame.BackgroundColor3 = Color3.fromRGB(65, 65, 70)
        modeFrame.BackgroundTransparency = 0.18
        modeFrame.BorderSizePixel = 0
        Instance.new("UICorner", modeFrame).CornerRadius = UDim.new(0, 9)
        local modeStroke = Instance.new("UIStroke", modeFrame)
        modeStroke.Color = Color3.fromRGB(145, 145, 150)
        modeStroke.Transparency = 0.45
        modeStroke.Thickness = 1

        local leftArrow = Instance.new("TextButton", modeFrame)
        leftArrow.Size = UDim2.fromOffset(30, 28)
        leftArrow.BackgroundTransparency = 1
        leftArrow.Text = "<"
        leftArrow.TextColor3 = Color3.fromRGB(210, 210, 215)
        leftArrow.Font = Enum.Font.GothamBold
        leftArrow.TextSize = 14
        leftArrow.ZIndex = 8

        local modeText = Instance.new("TextLabel", modeFrame)
        modeText.Size = UDim2.new(1, -60, 1, 0)
        modeText.Position = UDim2.new(0, 30, 0, 0)
        modeText.BackgroundTransparency = 1
        modeText.TextColor3 = Color3.fromRGB(245, 245, 245)
        modeText.Font = Enum.Font.GothamBold
        modeText.TextSize = 9
        modeText.TextTruncate = Enum.TextTruncate.AtEnd
        modeText.ZIndex = 8

        local rightArrow = Instance.new("TextButton", modeFrame)
        rightArrow.Size = UDim2.fromOffset(30, 28)
        rightArrow.Position = UDim2.new(1, -30, 0, 0)
        rightArrow.BackgroundTransparency = 1
        rightArrow.Text = ">"
        rightArrow.TextColor3 = Color3.fromRGB(210, 210, 215)
        rightArrow.Font = Enum.Font.GothamBold
        rightArrow.TextSize = 14
        rightArrow.ZIndex = 8

        local modeIndex = 1
        for i, mode in ipairs(playerAnimModes) do
            if mode == playerAnimMode then modeIndex = i break end
        end
        local function refreshPlayerAnimMode()
            playerAnimMode = playerAnimModes[modeIndex]
            modeText.Text = playerAnimMode
        end
        _G._YassinRefreshPlayerAnimMode = function()
            for i, mode in ipairs(playerAnimModes) do
                if mode == playerAnimMode then modeIndex = i break end
            end
            modeText.Text = playerAnimMode
        end
        local function stepPlayerAnimMode(delta)
            modeIndex = (modeIndex - 1 + delta) % #playerAnimModes + 1
            refreshPlayerAnimMode()
            setPlayerAnimMode(playerAnimMode)
        end
        leftArrow.MouseButton1Click:Connect(function() stepPlayerAnimMode(-1) end)
        rightArrow.MouseButton1Click:Connect(function() stepPlayerAnimMode(1) end)
        refreshPlayerAnimMode()
    end

    LP.CharacterAdded:Connect(function()
        task.wait(0.5)
        if playerAnimEnabled then pcall(applyPlayerAnimPack, playerAnimMode) end
    end)

    local configPage = contentPages["Settings"]

    uiScaleBox = mkStepRow(configPage, "UI Scale",
        function() return uiScaleValue end,
        function(v)
            uiScaleValue = v
            if mainUIScale then
                local cam = workspace.CurrentCamera
                local viewport = cam and cam.ViewportSize or Vector2.new(1280, 720)
                local fit = UIS.TouchEnabled and math.clamp(math.min(viewport.X / 430, viewport.Y / 760), 0.62, 1) or 1
                mainUIScale.Scale = (v / 100) * fit
            end
            if markSettingsDirty then markSettingsDirty() end
        end, 50, 150, 1)

    progressBarScaleBox = mkStepRow(configPage, "Progress Bar Scale",
        function() return progressBarScaleValue end,
        function(v)
            progressBarScaleValue = v
            if pbScale then pbScale.Scale = v / 100 end
            if markSettingsDirty then markSettingsDirty() end
        end, 30, 150, 1)

    mkStepRow(configPage, "Button Scale",
        function() return _floor(floatingButtonScale * 100) end,
        function(v)
            floatingButtonScale = v / 100
            applyFloatingButtonScale()
            if markSettingsDirty then markSettingsDirty() end
        end, 50, 200, 1)

    do
        local styleNames = {"Square", "Rounded", "Circle"}
        local styleRow = mkRow(configPage, 42)
        -- Keep the label and selector in separate, non-overlapping regions on narrow screens.
        local styleLabel = Instance.new("TextLabel", styleRow)
        styleLabel.Size = UDim2.new(1, -132, 1, 0)
        styleLabel.Position = UDim2.new(0, 10, 0, 0)
        styleLabel.BackgroundTransparency = 1
        styleLabel.Text = "Mobile Button Style"
        styleLabel.TextColor3 = WHITE
        styleLabel.Font = Enum.Font.GothamBold
        styleLabel.TextSize = 12
        styleLabel.TextXAlignment = Enum.TextXAlignment.Left
        styleLabel.TextTruncate = Enum.TextTruncate.AtEnd
        styleLabel.ZIndex = 8
        local styleFrame = Instance.new("Frame", styleRow)
        styleFrame.Size = UDim2.new(0, 116, 0, 28)
        styleFrame.AnchorPoint = Vector2.new(1, 0.5)
        styleFrame.Position = UDim2.new(1, -8, 0.5, 0)
        styleFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 40)
        styleFrame.BackgroundTransparency = 0.1
        styleFrame.BorderSizePixel = 0
        styleFrame.ZIndex = 8
        Instance.new("UICorner", styleFrame).CornerRadius = UDim.new(0, 8)
        local left = Instance.new("TextButton", styleFrame)
        left.Size = UDim2.fromOffset(24, 28); left.BackgroundTransparency = 1
        left.Text = "<"; left.TextColor3 = WHITE; left.Font = Enum.Font.GothamBold; left.TextSize = 13; left.ZIndex = 9
        local value = Instance.new("TextLabel", styleFrame)
        value.Size = UDim2.new(1, -48, 1, 0); value.Position = UDim2.new(0, 24, 0, 0)
        value.BackgroundTransparency = 1; value.TextColor3 = WHITE; value.Font = Enum.Font.GothamBold; value.TextSize = 11; value.TextTruncate = Enum.TextTruncate.AtEnd; value.ZIndex = 9
        local right = Instance.new("TextButton", styleFrame)
        right.Size = UDim2.fromOffset(24, 28); right.Position = UDim2.new(1, -24, 0, 0)
        right.BackgroundTransparency = 1; right.Text = ">"; right.TextColor3 = WHITE; right.Font = Enum.Font.GothamBold; right.TextSize = 14; right.ZIndex = 9
        local styleIndex = 1
        for i, name in ipairs(styleNames) do if name == mobileButtonStyle then styleIndex = i end end
        local function refreshStyle()
            mobileButtonStyle = styleNames[styleIndex]
            value.Text = mobileButtonStyle
            local radius = mobileButtonStyle == "Circle" and UDim.new(1, 0) or (mobileButtonStyle == "Rounded" and UDim.new(0, 12) or UDim.new(0, 0))
            if MobilePanel then
                local floating = MobilePanel:FindFirstChild("FloatingPanel")
                local buttonsContainer = floating and floating:FindFirstChild("ButtonsContainer")
                if buttonsContainer then
                    for _, button in ipairs(buttonsContainer:GetChildren()) do
                        if button:IsA("TextButton") then
                            local corner = button:FindFirstChildOfClass("UICorner")
                            if corner then corner.CornerRadius = radius end
                            local img = button:FindFirstChild("ButtonImage")
                            local imgCorner = img and img:FindFirstChildOfClass("UICorner")
                            if imgCorner then imgCorner.CornerRadius = radius end
                        end
                    end
                end
            end
            markSettingsDirty()
        end
        left.MouseButton1Click:Connect(function() styleIndex = (styleIndex - 2) % #styleNames + 1; refreshStyle() end)
        right.MouseButton1Click:Connect(function() styleIndex = styleIndex % #styleNames + 1; refreshStyle() end)
        refreshStyle()
    end

    local hideAutoStealBarVisual = mkToggle(configPage, "Hide Auto Steal Bar", function(on)
        autoStealBarHidden = (on == true)
        updateProgressBarVisibility()
        markSettingsDirty()
    end)
    if hideAutoStealBarVisual then hideAutoStealBarVisual(autoStealBarHidden == true) end

    setLockUIVisual = mkToggle(configPage, "Lock", function(on)
        toggleLockUI(on == true)
    end)
    if setLockUIVisual then setLockUIVisual(uiLocked) end

    -- Skip Intro: visible Settings toggle; ON bypasses the intro, OFF plays it normally.
    skipIntroToggleSet = mkToggle(configPage, "Skip Intro", function(on)
        setSkipIntro(on == true)
        if on and INTRO and INTRO.stop then pcall(INTRO.stop) end
    end)
    if skipIntroToggleSet then skipIntroToggleSet(skipIntroEnabled == true) end

    setMobileButtonsHiddenVisual = mkToggle(configPage, "Hide Mobile Buttons", function(on)
        mobileButtonsHidden = (on == true)
        if MobilePanel then
            local floatingPanel = MobilePanel:FindFirstChild("FloatingPanel")
            local buttonsContainer = floatingPanel and floatingPanel:FindFirstChild("ButtonsContainer")
            if buttonsContainer then
                buttonsContainer.Visible = not mobileButtonsHidden
            end
        end
        markSettingsDirty()
    end)
    if setMobileButtonsHiddenVisual then setMobileButtonsHiddenVisual(mobileButtonsHidden) end

    do
        local row = mkRow(configPage, 40)
        local resetBtn = Instance.new("TextButton", row)
        resetBtn.Size = UDim2.new(1, -8, 0.85, 0)
        resetBtn.Position = UDim2.new(0, 4, 0.07, 0)
        resetBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
        resetBtn.BackgroundTransparency = 0.3
        resetBtn.BorderSizePixel = 0
        resetBtn.Text = "Reset Settings"
        resetBtn.TextColor3 = WHITE
        resetBtn.Font = Enum.Font.GothamBold
        resetBtn.TextSize = 13
        resetBtn.ZIndex = 8
        Instance.new("UICorner", resetBtn).CornerRadius = UDim.new(0, 10)
        local resetState, resetDebounce = 0, false
        resetBtn.MouseButton1Click:Connect(function()
            if resetDebounce then return end
            if resetState == 0 then
                resetState = 1
                resetBtn.Text = "CONFIRM RESET?"
                task.delay(2.5, function()
                    if resetBtn and resetBtn.Parent and resetState == 1 then
                        resetState = 0
                        resetBtn.Text = "Reset Settings"
                    end
                end)
            elseif resetState == 1 then
                resetDebounce = true
                resetBtn.Text = "RESETTING..."
                local callOk, resetOk = pcall(resetToFactoryDefaults)
                local resetSuccess = callOk and resetOk == true
                if not resetSuccess then warn("Factory reset did not complete successfully") end
                task.delay(0.8, function()
                    if resetBtn and resetBtn.Parent then
                        resetBtn.Text = resetSuccess and "DONE" or "RESET FAILED"
                    end
                end)
                task.delay(1.8, function()
                    if resetBtn and resetBtn.Parent then
                        resetBtn.Text = "Reset Settings"
                        resetDebounce = false
                        resetState = 0
                    end
                end)
            end
        end)
    end

    local keyPage = contentPages["Keybinds"]
    addKeybindRow(keyPage, "Carry Mode", KB.CarryToggle)
    addKeybindRow(keyPage, "Lagger Mode", KB.LaggerMode)
    addKeybindRow(keyPage, "Auto Left", KB.AutoLeft)
    addKeybindRow(keyPage, "Auto Right", KB.AutoRight)
    addKeybindRow(keyPage, "Auto Bat", KB.AutoBat)
    addKeybindRow(keyPage, "Insta Reset", KB.InstaReset)
    -- Bat Bypass keybind removed
    addKeybindRow(keyPage, "TP Down", KB.TPFloor)
    addKeybindRow(keyPage, "Drop Brainrot", KB.DropBrainrot)
    addKeybindRow(keyPage, "Hide GUI", KB.GuiHide)

    -- ========== NEW AUTO STEAL BAR ==========
    pbFrame = Instance.new("Frame", gui)
    pbFrame.Name = "AutoStealBar"
    pbFrame.Size = UDim2.new(0, 560, 0, 86)
    pbFrame.Position = UDim2.new(0.5, -280, 1, -118)
    pbFrame.BackgroundColor3 = Color3.fromRGB(10, 12, 20)
    pbFrame.BackgroundTransparency = 0
    pbFrame.BorderSizePixel = 0
    pbFrame.Active = true
    pbFrame.ClipsDescendants = true
    pbFrame.Visible = not (autoStealBarHidden == true)
    pbFrame.ZIndex = 100
    pbScale = Instance.new("UIScale", pbFrame)
    pbScale.Scale = progressBarScaleValue / 100
    if savedProgressBarPos then
        pbFrame.Position = UDim2.new(savedProgressBarPos.XScale or 0.5, savedProgressBarPos.XOffset or -280, savedProgressBarPos.YScale or 1, savedProgressBarPos.YOffset or -110)
    end
    Instance.new("UICorner", pbFrame).CornerRadius = UDim.new(0, 14)

    -- One full background image for the new bar.
    local barBackground = Instance.new("ImageLabel", pbFrame)
    barBackground.Name = "AutoStealBackgroundImage"
    barBackground.Size = UDim2.new(1, 0, 1, 0)
    barBackground.Position = UDim2.new(0, 0, 0, 0)
    barBackground.BackgroundTransparency = 1
    barBackground.Image = "rbxassetid://" .. BACKGROUND_IMAGE_ID
    barBackground.ImageTransparency = 0
    barBackground.ScaleType = Enum.ScaleType.Crop
    barBackground.ZIndex = 101
    barBackground.Active = false
    barBackground.Selectable = false
    Instance.new("UICorner", barBackground).CornerRadius = UDim.new(0, 14)

    -- Dark readability layer over the image.
    local barShade = Instance.new("Frame", pbFrame)
    barShade.Name = "AutoStealReadabilityShade"
    barShade.Size = UDim2.new(1, 0, 1, 0)
    barShade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    barShade.BackgroundTransparency = 0.45
    barShade.BorderSizePixel = 0
    barShade.ZIndex = 102

    local barStroke = Instance.new("UIStroke", pbFrame)
    barStroke.Color = NEON_PINK
    barStroke.Thickness = 2
    barStroke.Transparency = 0.05

    local barTitle = Instance.new("TextLabel", pbFrame)
    barTitle.Name = "AutoStealTitle"
    barTitle.Size = UDim2.new(0, 220, 0, 16)
    barTitle.Position = UDim2.new(0, 16, 0, 3)
    barTitle.BackgroundTransparency = 1
    barTitle.Text = "AUTO STEAL"
    barTitle.Visible = true
    barTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    barTitle.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    barTitle.TextStrokeTransparency = 0
    barTitle.Font = Enum.Font.GothamBlack
    barTitle.TextSize = 20
    barTitle.TextXAlignment = Enum.TextXAlignment.Left
    barTitle.ZIndex = 104

    fpsLabel = Instance.new("TextLabel", pbFrame)
    fpsLabel.Name = "FPSLabel"
    fpsLabel.Size = UDim2.new(0, 150, 0, 20)
    fpsLabel.Position = UDim2.new(0, 16, 0, 22)
    fpsLabel.BackgroundTransparency = 1
    fpsLabel.Text = "FPS: --"
    fpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    fpsLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    fpsLabel.TextStrokeTransparency = 0
    fpsLabel.Font = Enum.Font.GothamBold
    fpsLabel.TextSize = 20
    fpsLabel.TextXAlignment = Enum.TextXAlignment.Left
    fpsLabel.ZIndex = 104

    msLabel = Instance.new("TextLabel", pbFrame)
    msLabel.Name = "PingLabel"
    msLabel.Size = UDim2.new(0, 150, 0, 20)
    msLabel.Position = UDim2.new(0, 160, 0, 22)
    msLabel.BackgroundTransparency = 1
    msLabel.Text = "PING: --"
    msLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    msLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    msLabel.TextStrokeTransparency = 0
    msLabel.Font = Enum.Font.GothamBold
    msLabel.TextSize = 20
    msLabel.TextXAlignment = Enum.TextXAlignment.Left
    msLabel.ZIndex = 104

    progressPct = Instance.new("TextLabel", pbFrame)
    progressPct.Name = "ProgressPercent"
    progressPct.Size = UDim2.new(0, 80, 0, 20)
    progressPct.Position = UDim2.new(1, -96, 0, 22)
    progressPct.BackgroundTransparency = 1
    progressPct.Text = "0%"
    progressPct.TextColor3 = Color3.fromRGB(255, 255, 255)
    progressPct.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    progressPct.TextStrokeTransparency = 0
    progressPct.Font = Enum.Font.GothamBlack
    progressPct.TextSize = 20
    progressPct.TextXAlignment = Enum.TextXAlignment.Right
    progressPct.ZIndex = 104

    local progressRow = Instance.new("Frame", pbFrame)
    progressRow.Name = "ProgressTrack"
    progressRow.Size = UDim2.new(1, -32, 0, 18)
    progressRow.Position = UDim2.new(0, 16, 1, -28)
    progressRow.BackgroundColor3 = Color3.fromRGB(25, 31, 48)
    progressRow.BackgroundTransparency = 0.12
    progressRow.BorderSizePixel = 0
    progressRow.ClipsDescendants = true
    progressRow.ZIndex = 103
    Instance.new("UICorner", progressRow).CornerRadius = UDim.new(0, 8)

    progressFill = Instance.new("Frame", progressRow)
    progressFill.Name = "ProgressFill"
    progressFill.Size = UDim2.new(0, 0, 1, 0)
    progressFill.BackgroundColor3 = NEON_PINK
    progressFill.BorderSizePixel = 0
    progressFill.ZIndex = 105
    Instance.new("UICorner", progressFill).CornerRadius = UDim.new(0, 8)
    local progressGradient = Instance.new("UIGradient", progressFill)
    progressGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(184, 72, 255)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(184, 96, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(158, 47, 220)),
    })

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
            if msLabel then msLabel.Text = string.format("PING: %d", _floor(ping + 0.5)) end
            task.wait(0.5)
        end
    end)
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
            if msLabel then msLabel.Text = string.format("PING: %d", _floor(ping + 0.5)) end
            task.wait(0.5)
        end
    end)
    drag(main)
end

function createMobilePanel()
    local panel = Instance.new("ScreenGui")
    panel.Name = "RaptureDuelMobilePanel"
    panel.ResetOnSpawn = false
    panel.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = CoreGui end) then panel.Parent = LP:WaitForChild("PlayerGui") end
    local BTN_W, BTN_H = 52, 52
    local GAP = 8
    local COLUMNS = 2
    local ROWS = 6
    local PANEL_W = BTN_W * COLUMNS + GAP
    local PANEL_H = BTN_H * ROWS + GAP * (ROWS - 1)
    local container = Instance.new("Frame", panel)
    container.Name = "FloatingPanel"
    container.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
    container.Position = UDim2.new(1, -PANEL_W - 16, 0.5, -math.floor(PANEL_H / 2))
    if savedMobilePanelPos then
        container.Position = UDim2.new(savedMobilePanelPos.XScale or 1, savedMobilePanelPos.XOffset or (-PANEL_W - 16), savedMobilePanelPos.YScale or 0.5, savedMobilePanelPos.YOffset or -math.floor(PANEL_H / 2))
    end
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
    btnContainer.Visible = not mobileButtonsHidden
    local buttons = {}
    local buttonNames = {"InstaReset", "AutoRight", "AutoLeft", "DropBR", "TpDown", "Carry", "AutoBat", "Lagger1", "Lagger2", "AntiBat", "BypassAutoBat"}
    local buttonTexts = {"INSTA\nRESET", "AUTO\nRIGHT", "AUTO\nLEFT", "DROP\nBR", "TP\nDOWN", "CARRY\nSPD", "AUTO\nBAT", "LAGGER\nCARRY", "LAGGER", "ANTI\nBAT", "BYPASS\nAUTO BAT"}
    for i, name in ipairs(buttonNames) do
        local text = buttonTexts[i]
        local btn = Instance.new("TextButton", btnContainer)
        btn.Name = name
        btn.Size = UDim2.new(0, BTN_W, 0, BTN_H)
        btn.BackgroundColor3 = BTN_BG_DARK
        btn.BorderSizePixel = 0
        btn.Text = ""
        btn.AutoButtonColor = false
        btn.ClipsDescendants = true
        btn.ZIndex = 10
        local savedPos = savedButtonPositions[name]
        if savedPos and (savedPos.X ~= nil or savedPos.Y ~= nil) then
            btn.Position = UDim2.new(0, savedPos.X or 0, 0, savedPos.Y or 0)
        else
            local defX, defY = getDefaultButtonPosition(name)
            btn.Position = UDim2.new(0, defX, 0, defY)
        end
        local buttonCornerRadius = mobileButtonStyle == "Circle" and UDim.new(1, 0) or (mobileButtonStyle == "Rounded" and UDim.new(0, 12) or UDim.new(0, 0))
        Instance.new("UICorner", btn).CornerRadius = buttonCornerRadius
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

        local buttonImage = Instance.new("ImageLabel", btn)
        buttonImage.Name = "ButtonImage"
        buttonImage.BackgroundTransparency = 1
        buttonImage.Image = "rbxassetid://" .. BACKGROUND_IMAGE_ID
        buttonImage.ImageTransparency = 0.12
        buttonImage.ScaleType = Enum.ScaleType.Crop
        buttonImage.Size = UDim2.new(1, 0, 1, 0)
        buttonImage.Position = UDim2.new(0, 0, 0, 0)
        buttonImage.ZIndex = 10
        buttonImage.ClipsDescendants = true
        Instance.new("UICorner", buttonImage).CornerRadius = buttonCornerRadius
        buttonImage.Active = false
        buttonImage.Selectable = false

        local label = Instance.new("TextLabel", btn)
        label.Size = UDim2.new(1, -4, 0, 20)
        label.Position = UDim2.new(0, 2, 1, -21)
        label.BackgroundTransparency = 1
        label.Text = text
        label.TextColor3 = PASTEL_PINK
        label.Font = Enum.Font.GothamBlack
        label.TextSize = 10
        label.TextWrapped = true
        label.ZIndex = 12
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
                if not uiLocked and movedDistance >= 12 then
                    hasMoved = true
                    btn.Position = UDim2.new(0, startPos.X.Offset + delta.X, 0, startPos.Y.Offset + delta.Y)
                end
            end
        end)
        btn.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
                if dragging then
                    if movedDistance < 12 then
                        if name == "DropBR" then
                            setActive(true)
                            setDropBrainrot(true)
                            task.delay(0.3, function() setActive(false) end)
                        elseif name == "AutoLeft" then
                            autoLeftEnabled = not autoLeftEnabled
                            setActive(autoLeftEnabled)
                            if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
                            if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
                            markSettingsDirty()
                        elseif name == "AutoBat" then
                            -- Mobile button always forces Normal (V1), independent of AimPot Mode (Key).
                            toggleAutoBatFromInput("mobile-normal", "V1")
                            setActive(autoBatEnabled == true and autoBatSource == "mobile-normal")
                            if buttons.BypassAutoBat and buttons.BypassAutoBat.setActive then buttons.BypassAutoBat.setActive(false) end
                        elseif name == "BypassAutoBat" then
                            -- Mobile Bypass button always forces V2, independent of AimPot Mode (Key).
                            toggleAutoBatFromInput("mobile-bypass", "V2")
                            if buttons.AutoBat and buttons.AutoBat.setActive then buttons.AutoBat.setActive(false) end
                            setActive(autoBatEnabled == true and autoBatSource == "mobile-bypass")
                        elseif name == "AutoRight" then
                            autoRightEnabled = not autoRightEnabled
                            setActive(autoRightEnabled)
                            if autoRightEnabled then startAutoRight() else stopAutoRight() end
                            if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
                            markSettingsDirty()
                        elseif name == "TpDown" then
                            -- Manual TP Down takes control from the automatic heartbeat loop.
                            if autoTPEnabled then stopAutoTPDown() end
                            doTpDown()
                            setActive(true)
                            task.delay(0.2, function() setActive(false) end)
                        elseif name == "Carry" then
                            if not speedMode then
                                speedMode = true; laggerToggled = false; laggerCarryToggled = false
                                setActive(true)
                                if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                                if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                            else
                                speedMode = false; setActive(false)
                            end
                            resetMovementState()
                            markSettingsDirty()
                        elseif name == "Lagger1" then
                            if not laggerToggled then
                                laggerToggled = true; speedMode = false; laggerCarryToggled = false
                                setActive(true)
                                if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(false) end
                                if buttons.Lagger2 and buttons.Lagger2.setActive then buttons.Lagger2.setActive(false) end
                            else
                                laggerToggled = false; setActive(false)
                            end
                            resetMovementState()
                            markSettingsDirty()
                        elseif name == "Lagger2" then
                            if not laggerCarryToggled then
                                laggerCarryToggled = true; speedMode = false; laggerToggled = false
                                setActive(true)
                                if buttons.Carry and buttons.Carry.setActive then buttons.Carry.setActive(false) end
                                if buttons.Lagger1 and buttons.Lagger1.setActive then buttons.Lagger1.setActive(false) end
                            else
                                laggerCarryToggled = false; setActive(false)
                            end
                            resetMovementState()
                            markSettingsDirty()
                        elseif name == "AntiBat" then
                            setAntiBatEnabled(not antiBatEnabled)
                            setActive(antiBatEnabled)
                        elseif name == "InstaReset" then
                            if _G.InstaReset and _G.InstaReset.Trigger then _G.InstaReset.Trigger() end
                            setActive(true)
                            task.delay(0.2, function() setActive(false) end)
                        end
                    elseif not uiLocked and hasMoved then
                        savedButtonPositions[name] = {
                            X = btn.Position.X.Offset, Y = btn.Position.Y.Offset,
                            XScale = btn.Position.X.Scale, YScale = btn.Position.Y.Scale,
                            WidthScale = btn.Size.X.Scale, WidthOffset = btn.Size.X.Offset,
                            HeightScale = btn.Size.Y.Scale, HeightOffset = btn.Size.Y.Offset,
                        }
                        _lastLayoutEditTime = _tick()
                        markSettingsDirty()
                        -- Immediately persist the full mobile-button layout after a drag.
                        pcall(function()
                            if type(snapshotLivePositions) == "function" then snapshotLivePositions() end
                            if type(saveConfig) == "function" then saveConfig() end
                        end)
                    end
                    dragging = false; hasMoved = false
                    dragStart = nil; startPos = nil; movedDistance = 0
                    _isDraggingButton = false
                end
            end
        end)
        -- Mobile: touch can end outside the button — still finish drag + save
        UIS.InputEnded:Connect(function(input)
            if not dragging then return end
            if input.UserInputType ~= Enum.UserInputType.MouseButton1 and input.UserInputType ~= Enum.UserInputType.Touch then return end
            if not uiLocked and hasMoved then
                savedButtonPositions[name] = {
                    X = btn.Position.X.Offset, Y = btn.Position.Y.Offset,
                    XScale = btn.Position.X.Scale, YScale = btn.Position.Y.Scale,
                    WidthScale = btn.Size.X.Scale, WidthOffset = btn.Size.X.Offset,
                    HeightScale = btn.Size.Y.Scale, HeightOffset = btn.Size.Y.Offset,
                }
                _lastLayoutEditTime = _tick()
                markSettingsDirty()
                -- Touch may end outside the button; persist this final position too.
                pcall(function()
                    if type(snapshotLivePositions) == "function" then snapshotLivePositions() end
                    if type(saveConfig) == "function" then saveConfig() end
                end)
            end
            dragging = false; hasMoved = false
            dragStart = nil; startPos = nil; movedDistance = 0
            _isDraggingButton = false
        end)
        buttons[name] = {btn = btn, setActive = setActive, label = label}
        if name == "AutoBat" then mobSetAutoBat = setActive end
        if name == "BypassAutoBat" then bypassAutoBatMobileSetVisual = setActive end
        if name == "AutoLeft" then mobSetAutoLeft = setActive end
        if name == "AutoRight" then mobSetAutoRight = setActive end
        if name == "DropBR" then mobSetDropBR = setActive end
        if name == "TpDown" then mobSetTpDown = setActive end
        if name == "Carry" then mobSetCarry = setActive end
        if name == "Lagger1" then mobSetLagger1 = setActive end
        if name == "Lagger2" then mobSetLagger2 = setActive end
        if name == "AntiBat" then setActive(antiBatEnabled) end
    end
    -- Restore the mobile button visuals from settings loaded before panel creation.
    if buttons.AutoBat then buttons.AutoBat.setActive(autoBatEnabled == true and autoBatSource == "mobile-normal") end
    if buttons.BypassAutoBat then buttons.BypassAutoBat.setActive(autoBatEnabled == true and autoBatSource == "mobile-bypass") end
    if buttons.AutoLeft then buttons.AutoLeft.setActive(autoLeftEnabled == true) end
    if buttons.AutoRight then buttons.AutoRight.setActive(autoRightEnabled == true) end
    if buttons.Carry then
        buttons.Carry.setActive(speedMode == true and not laggerToggled and not laggerCarryToggled)
    end
    if buttons.Lagger1 then buttons.Lagger1.setActive(laggerToggled == true) end
    if buttons.Lagger2 then buttons.Lagger2.setActive(laggerCarryToggled == true) end
    if buttons.AntiBat then buttons.AntiBat.setActive(antiBatEnabled == true) end
    return panel
end

function createBatBypassFloatingButton()
    return nil -- Bat Bypass removed
end
function createInstaResetFloatingButton()
    -- Integrated into mobile panel (same size as other buttons)
    return nil
end
local function __dead_createInstaResetFloatingButton()
    local panel = Instance.new("ScreenGui")
    panel.Name = "InstaResetButton"
    panel.ResetOnSpawn = false
    panel.DisplayOrder = 23
    pcall(function() if syn and syn.protect_gui then syn.protect_gui(panel) end end)
    if not pcall(function() panel.Parent = CoreGui end) then panel.Parent = LP:WaitForChild("PlayerGui") end
    local btnFrame = Instance.new("Frame", panel)
    btnFrame.Size = UDim2.new(0, 52, 0, 52)
    btnFrame.Name = "Frame"
    -- Same size as other floating buttons; sits at end of top row
    btnFrame.Position = UDim2.new(1, -52 - 14, 0, 70 + 8 * (52 + 6))
    btnFrame.BackgroundColor3 = BTN_BG_DARK
    btnFrame.BorderSizePixel = 0
    btnFrame.ClipsDescendants = true
    btnFrame.ZIndex = 20
    Instance.new("UICorner", btnFrame).CornerRadius = UDim.new(0, 22)
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
    local resetBackground = Instance.new("ImageLabel", btnFrame)
    resetBackground.Name = "ResetButtonBackgroundImage"
    resetBackground.Size = UDim2.new(1, 0, 1, 0)
    resetBackground.Position = UDim2.new(0, 0, 0, 0)
    resetBackground.BackgroundTransparency = 1
    resetBackground.Image = "rbxassetid://" .. BACKGROUND_IMAGE_ID
    resetBackground.ImageTransparency = 0.12
    resetBackground.ScaleType = Enum.ScaleType.Crop
    resetBackground.ZIndex = 20
    resetBackground.Active = false
    resetBackground.Selectable = false
    Instance.new("UICorner", resetBackground).CornerRadius = UDim.new(0, 22)

    local label = Instance.new("TextLabel", btnFrame)
    label.Size = UDim2.new(1, -4, 0, 20)
    label.Position = UDim2.new(0, 2, 1, -21)
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
                markSettingsDirty()
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
    if spinSpeedBox then spinSpeedBox.Text = tostring(spinSpeed) end
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
    if _G._RaptureSavedMainPos and main then
        local mp = _G._RaptureSavedMainPos
        main.Position = UDim2.new(mp.XScale or 0, mp.XOffset or 20, mp.YScale or 0, mp.YOffset or 2)
    end
    if savedProgressBarPos and pbFrame then
        pbFrame.Position = UDim2.new(savedProgressBarPos.XScale or 0.5, savedProgressBarPos.XOffset or -280, savedProgressBarPos.YScale or 1, savedProgressBarPos.YOffset or -110)
    end
    local bgImg = main and main:FindFirstChild("BackgroundImage")
    if main and type(savedUiStyle) == "table" then
        local st = savedUiStyle
        local function rgb(v, fallback)
            if type(v) == "table" and #v >= 3 then
                return Color3.new(tonumber(v[1]) or fallback.R, tonumber(v[2]) or fallback.G, tonumber(v[3]) or fallback.B)
            end
            return fallback
        end
        main.BackgroundColor3 = rgb(st.mainBackgroundColor, main.BackgroundColor3)
        if tonumber(st.mainBackgroundTransparency) then main.BackgroundTransparency = math.clamp(st.mainBackgroundTransparency, 0, 1) end
        if tonumber(st.mainSizeXOffset) and tonumber(st.mainSizeYOffset) then
            main.Size = UDim2.new(tonumber(st.mainSizeXScale) or 0, st.mainSizeXOffset, tonumber(st.mainSizeYScale) or 0, st.mainSizeYOffset)
        end
        local corner = main:FindFirstChildOfClass("UICorner")
        if corner and tonumber(st.cornerRadius) then corner.CornerRadius = UDim.new(0, math.max(0, st.cornerRadius)) end
        if bgImg and bgImg:IsA("ImageLabel") then
            if type(st.backgroundImage) == "string" and st.backgroundImage ~= "" then bgImg.Image = st.backgroundImage end
            bgImg.BackgroundColor3 = rgb(st.backgroundColor, bgImg.BackgroundColor3)
            if tonumber(st.backgroundTransparency) then bgImg.BackgroundTransparency = math.clamp(st.backgroundTransparency, 0, 1) end
            if tonumber(st.imageTransparency) then bgImg.ImageTransparency = math.clamp(st.imageTransparency, 0, 1) end
            if type(st.scaleType) == "string" and Enum.ScaleType[st.scaleType] then bgImg.ScaleType = Enum.ScaleType[st.scaleType] end
        end
        local stroke = main:FindFirstChildOfClass("UIStroke")
        if stroke then
            stroke.Color = rgb(st.mainStrokeColor, stroke.Color)
            if tonumber(st.mainStrokeThickness) then stroke.Thickness = math.max(0, st.mainStrokeThickness) end
            if tonumber(st.mainStrokeTransparency) then stroke.Transparency = math.clamp(st.mainStrokeTransparency, 0, 1) end
        end
    end
    if bgImg then
        if not (type(savedUiStyle) == "table" and type(savedUiStyle.backgroundImage) == "string" and savedUiStyle.backgroundImage ~= "") then
            bgImg.Image = "rbxassetid://" .. BACKGROUND_IMAGE_ID
        end
        if not (type(savedUiStyle) == "table" and tonumber(savedUiStyle.imageTransparency)) then
            bgImg.ImageTransparency = backgroundImageTransparency
        end
    end
    -- Reapply saved scale values after configuration loading. On touch devices
    -- the main UI uses a fit multiplier; desktop keeps the selected scale as-is.
    if mainUIScale then
        local cam = workspace.CurrentCamera
        local viewport = cam and cam.ViewportSize or Vector2.new(1280, 720)
        local fit = UIS.TouchEnabled and math.clamp(math.min(viewport.X / 430, viewport.Y / 760), 0.62, 1) or 1
        mainUIScale.Scale = math.clamp((tonumber(uiScaleValue) or 74) / 100, 0.5, 1.5) * fit
    end
    if pbScale then pbScale.Scale = math.clamp((tonumber(progressBarScaleValue) or 80) / 100, 0.3, 1.5) end
    applyFloatingButtonScale()
    if setMobileButtonsHiddenVisual then setMobileButtonsHiddenVisual(mobileButtonsHidden) end
    if MobilePanel and MobilePanel:FindFirstChild("FloatingPanel") then
        local bc = MobilePanel.FloatingPanel:FindFirstChild("ButtonsContainer")
        if bc then bc.Visible = not mobileButtonsHidden end
    end
    if uiLocked and setLockUIVisual then setLockUIVisual(true) end
    -- Restore the Speed-tab toggles visually as well as in runtime state.
    if setAntiBatVisual then pcall(setAntiBatVisual, antiBatEnabled == true) end
    if setSpinToggleVisual then pcall(setSpinToggleVisual, spinEnabled == true) end
    if setAutoSpinToggleVisual then pcall(setAutoSpinToggleVisual, autoSpinEnabled == true) end
    if setAntiDieVisual then pcall(setAntiDieVisual, antiDieEnabled == true) end
    if spinSpeedBox then spinSpeedBox.Text = tostring(spinSpeed) end
    startSpin()
    antiRagdollVersion = "v1"
    if antiRagdollEnabled then
        if setAntiRagVisual then setAntiRagVisual(true) end
        AntiRagdollV2.start()
    end
    antiDieEnabled = (spinEnabled == true) or (autoSpinEnabled == true)
    if antiDieEnabled then _antiDie.StartEngine() else _antiDie.StopEngine() end
    if CONFIG.AUTO_STEAL_ENABLED and setInstaGrab then setInstaGrab(true); pcall(startAutoSteal) end
    if medusaCounterEnabled and setMedusaVisual then setMedusaVisual(true); if LP.Character then setupMedusaCounter(LP.Character) end end
    if batCounterEnabled and setBatCounterVisual then setBatCounterVisual(true); startBatCounter() end
    if espEnabled and setESPVisual then setESPVisual(true); startESP() end
    if antiLagEnabled and setAntiLagVisual then setAntiLagVisual(true); enableAntiLag() end
    if stretchEnabled and _G.stretchToggleSetter then _G.stretchToggleSetter(true) end
    if setFovVisual then setFovVisual(fovEnabled) end
    if fovSliderSet then fovSliderSet(fovValue) end
    if batBypassEnabled then
        if batBypassSetVisual then batBypassSetVisual(true) end
        if not _G._RaptureBatBypass.enabled then _G.RaptureStartBatBypass() end
    end
    if aimbotModeSetVisual then aimbotModeSetVisual((aimbotMode == "V2") and "Bypass" or "Normal") end
    antiRagdollVersion = "v1"
    minecraftBatSkinEnabled = false
    startEnemySpeed()
    toggleLockUI(uiLocked)
    -- Final pass: re-apply layout after every control/box has been bound.
end

-- Rapture Bat Bypass API (disabled)
_G.RaptureStopBatBypass = function() batBypassEnabled = false end
_G.RaptureStartBatBypass = function() batBypassEnabled = false end
_G.RaptureToggleBatBypass = function() batBypassEnabled = false; return false end
_G._RaptureBatBypass = { enabled = false }

-- Initialize interface, then restore saved runtime state when available.
_G._RaptureSavedMainPos = nil
_G._RaptureSavedMiniPos = nil
savedButtonPositions = {}
savedMobilePanelPos = nil
savedProgressBarPos = nil
savedUiStyle = nil
batBypassFloatingPos = nil
instaResetFloatingPos = nil
buildGui()
local _settingsLoadedAtBoot = false
local _loadOk, _loadResult = pcall(restoreRuntimeState)
_settingsLoadedAtBoot = (_loadOk and _loadResult == true)
if _settingsLoadedAtBoot then
    pcall(updateUIFromLoaded)
    pcall(applyLoadedFeatureStates)
    -- Apply persisted mobile button positions/sizes only after config restoration.
    task.defer(function()
        task.wait(0.2)
        if type(applySavedLayout) == "function" then pcall(applySavedLayout) end
    end)
else
    -- First run: ALL features OFF, UI locked, default layout only.
    local _resetOk, _resetResult = pcall(resetToFactoryDefaults)
    if not _resetOk or _resetResult ~= true then
        warn("First-run defaults could not be fully applied")
        -- Hard safety: force every feature flag off even if reset failed mid-way.
        antiRagdollEnabled = false
        antiBatEnabled = false
        antiDieEnabled = false
        spinEnabled = false
        autoSpinEnabled = false
        medusaCounterEnabled = false
        batCounterEnabled = false
        autoLeftEnabled = false
        autoRightEnabled = false
        autoBatEnabled = false
        jumpEnabled = false
        unwalkEnabled = false
        espEnabled = false
        antiLagEnabled = false
        stretchEnabled = false
        fovEnabled = false
        speedMode = false
        laggerToggled = false
        laggerCarryToggled = false
        if CONFIG then CONFIG.AUTO_STEAL_ENABLED = false end
        if Steal then Steal.AutoStealEnabled = false end
        uiLocked = true
        skipIntroEnabled = false
    else
        pcall(persistRuntimeState)
    end
end

-- Absolute safety after boot: never leave engines running if their flag is off.
pcall(function()
    if not antiRagdollEnabled and type(stopAntiRagdoll) == "function" then stopAntiRagdoll(true) end
    if not antiBatEnabled and type(setAntiBatEnabled) == "function" then setAntiBatEnabled(false) end
    if not antiDieEnabled and _antiDie and type(_antiDie.StopEngine) == "function" then _antiDie.StopEngine() end
    if not autoBatEnabled and type(disableAutoBat) == "function" then disableAutoBat() end
    if not (spinEnabled or autoSpinEnabled) and type(stopSpin) == "function" then stopSpin() end
    if not espEnabled and type(stopESP) == "function" then stopESP() end
    if CONFIG and not CONFIG.AUTO_STEAL_ENABLED and type(stopAutoSteal) == "function" then stopAutoSteal() end
end)
_G._YassinIntroActive = false

-- Event-driven autosave persists the complete snapshot only after a setting/layout change.


task.defer(function()
    task.wait(0.15)
    if _RaptureApplyThemeToSliders then _RaptureApplyThemeToSliders() end
    for _, entry in ipairs(_G._RaptureDynamicSliders or {}) do
        pcall(function() entry.applyThemeColor(PASTEL_PINK) end)
    end
end)

refreshSpeedModeLabel()

MobilePanel = createMobilePanel()
if type(applySavedLayout) == "function" then pcall(applySavedLayout) end

-- Re-sync engines + visuals after mobile panel exists (fixes "shows ON but not running")
task.defer(function()
    task.wait(0.2)
    _isLoading = false
    _G._YassinSuppressSave = false
    if type(applyLoadedFeatureStates) == "function" then
        pcall(applyLoadedFeatureStates)
    end
    _isLoading = false
    _G._YassinSuppressSave = false
end)

-- Delta mobile: second load attempt after FS is fully ready
task.defer(function()
    task.wait(1.0)
    _isLoading = false
    _G._YassinSuppressSave = false
    if not _settingsLoadedAtBoot and type(restoreRuntimeState) == "function" then
        local ok, res = pcall(restoreRuntimeState)
        if ok and res == true then
            _settingsLoadedAtBoot = true
            pcall(function() if type(updateUIFromLoaded) == "function" then updateUIFromLoaded() end end)
            pcall(function() if type(applyLoadedFeatureStates) == "function" then applyLoadedFeatureStates() end end)
            pcall(function() if type(applySavedLayout) == "function" then applySavedLayout() end end)
        end
    end
end)

-- On respawn, re-start character-bound features that were saved ON
LP.CharacterAdded:Connect(function(char)
    task.defer(function()
        task.wait(0.35)
        if antiRagdollEnabled and type(startAntiRagdoll) == "function" then pcall(startAntiRagdoll) end
        if antiDieEnabled and _antiDie and type(_antiDie.StartEngine) == "function" then pcall(_antiDie.StartEngine) end
        if jumpEnabled and InfiniteJump and type(InfiniteJump.start) == "function" then pcall(InfiniteJump.start) end
        if medusaCounterEnabled and type(setupMedusaCounter) == "function" then pcall(setupMedusaCounter, char) end
        if batCounterEnabled and type(startBatCounter) == "function" then pcall(startBatCounter) end
        if autoBatEnabled and type(enableAutoBat) == "function" then pcall(enableAutoBat) end
        if (spinEnabled or autoSpinEnabled) and type(startSpin) == "function" then pcall(startSpin) end
        if playerAnimEnabled or unwalkEnabled then
            if _G._YassinRefreshPlayerAnimAfterLoad then pcall(_G._YassinRefreshPlayerAnimAfterLoad)
            elseif type(startUnwalk) == "function" then pcall(startUnwalk) end
        end
    end)
end)

-- Track layout AND size edits. The save snapshot reads live values at save time,
-- so a drag/resize is persisted as the final state rather than an earlier frame.
task.defer(function()
    local observed = setmetatable({}, {__mode = "k"})
    local observedScales = setmetatable({}, {__mode = "k"})
    local function watchLayout(obj)
        if not obj or not obj:IsA("GuiObject") or observed[obj] then return end
        observed[obj] = true
        local function changed()
            if not _isLoading and not _G._YassinSuppressSave then
                markSettingsDirty()
            end
        end
        obj:GetPropertyChangedSignal("Position"):Connect(changed)
        obj:GetPropertyChangedSignal("Size"):Connect(changed)
    end
    local function watchScale(obj)
        if not obj or not obj:IsA("UIScale") or observedScales[obj] then return end
        observedScales[obj] = true
        obj:GetPropertyChangedSignal("Scale"):Connect(function()
            if not _isLoading and not _G._YassinSuppressSave then markSettingsDirty() end
        end)
    end
    local function scan()
        watchLayout(main); watchLayout(miniBtn); watchLayout(pbFrame)
        watchScale(mainUIScale); watchScale(pbScale)
        for _, scale in ipairs(_floatingUIScales or {}) do watchScale(scale) end
        if MobilePanel then
            local panel = MobilePanel:FindFirstChild("FloatingPanel")
            watchLayout(panel)
            local buttons = panel and panel:FindFirstChild("ButtonsContainer")
            if buttons then
                for _, child in ipairs(buttons:GetChildren()) do watchLayout(child) end
                if not observed[buttons] then
                    observed[buttons] = true
                    buttons.ChildAdded:Connect(function(child)
                        task.defer(function() watchLayout(child) end)
                    end)
                end
            end
        end
    end
    scan()
    task.spawn(function()
        while task.wait(2) do scan() end
    end)
end)

task.defer(function()
    task.wait(0.15)
    if type(applySavedLayout) == "function" then pcall(applySavedLayout) end
end)

pcall(function()
    if main then
        local ox = main.Position.X.Offset
        local sx = main.Position.X.Scale
        if sx == 0 and ox < -50 then
            main.Position = UDim2.new(0, 20, 0, 2)
            _G._RaptureSavedMainPos = { XScale = 0, XOffset = 20, YScale = 0, YOffset = 2 }
        end
    end
    if miniBtn then miniBtn.Visible = false end
    if gui then gui.Enabled = true end
end)

task.defer(function()
    task.wait(0.12)
    -- Only restore layout positions; do not flash visibility here.
    pcall(function()
        if main and main.Position.X.Scale == 0 and main.Position.X.Offset < -50 then
            main.Position = UDim2.new(0, 20, 0, 2)
        end
        if miniBtn then miniBtn.Visible = false end
    end)

    local skip = (INTRO and INTRO.look == true) or (skipIntroEnabled == true)
    if skip then
        _G._YassinIntroActive = false
        if main then main.Visible = true end
        if type(showGui) == "function" then pcall(showGui, { instant = true }) end
    else
        -- Preserve and play the original intro, while keeping the main UI available.
        if main then main.Visible = true end
        if miniBtn then miniBtn.Visible = false end
        if type(showGui) == "function" then pcall(showGui, { instant = true }) end
        if INTRO and type(INTRO.play) == "function" then
            pcall(INTRO.play)
        end
    end
end)

if LP.Character then
    task.wait(0.1)
    if waitForCharReady(LP.Character, 5) then setupMovementAndIndicators(LP.Character) end
end

LP.CharacterAdded:Connect(function(char)
    -- Remember combat modes before cleanup (disableAutoBat clears the flag).
    local resumeAutoBat = autoBatEnabled == true
    local resumeAutoLeft = autoLeftEnabled == true
    local resumeAutoRight = autoRightEnabled == true
    local resumeSpin = (spinEnabled == true) or (autoSpinEnabled == true)

    if stealConnection then stealConnection:Disconnect(); stealConnection = nil end
    isStealing = false
    stopAutoLeft()
    stopAutoRight()
    stopBatCounter()
    stopMedusaCounter()
    stopUnwalk()
    stopDropBrainrot()
    if autoBatEnabled then
        -- stop the loop without wiping the user's preference permanently
        pcall(stopAimbotAdapt)
        autoBatEnabled = false
    end
    if _G._RaptureBatBypass and _G._RaptureBatBypass.enabled then _G.RaptureStopBatBypass() end
    task.wait(0.5)
    if not char.Parent then return end
    _hookedVelParts = {}
    _setupVelChecked(char)
    setupMovementAndIndicators(char)
    antiRagdollVersion = "v1"
    if antiRagdollEnabled then AntiRagdollV2.start() end
    if antiDieEnabled then _antiDie.StartEngine() end
    if CONFIG.AUTO_STEAL_ENABLED then pcall(startAutoSteal) end
    if medusaCounterEnabled then setupMedusaCounter(char) end
    if batCounterEnabled then startBatCounter() end
    if espEnabled then stopESP(); task.wait(0.2); startESP() end
    if unwalkEnabled then startUnwalk() end
    if resumeSpin then pcall(startSpin) end
    refreshSpeedModeLabel()

    -- Restore combat modes after character is ready
    task.defer(function()
        task.wait(0.35)
        if not char.Parent then return end
        if resumeAutoBat then
            pcall(enableAutoBat, activeAimbotMode)
            if autoBatSetVisual then
                pcall(autoBatSetVisual, autoBatSource == "key" or autoBatSource == "combat")
            end
            if mobSetAutoBat then
                pcall(mobSetAutoBat, autoBatSource == "mobile-normal")
            end
            if bypassAutoBatMobileSetVisual then
                pcall(bypassAutoBatMobileSetVisual, autoBatSource == "mobile-bypass")
            end
        elseif resumeAutoLeft then
            autoLeftEnabled = true
            pcall(startAutoLeft)
            if autoLeftSetVisual then pcall(autoLeftSetVisual, true) end
            if mobSetAutoLeft then pcall(mobSetAutoLeft, true) end
        elseif resumeAutoRight then
            autoRightEnabled = true
            pcall(startAutoRight)
            if autoRightSetVisual then pcall(autoRightSetVisual, true) end
            if mobSetAutoRight then pcall(mobSetAutoRight, true) end
        end
    end)
end)

-- Lagger Mode keyboard input should respond to every press, including rapid taps.
UIS.InputBegan:Connect(function(input, gpe)
    if _anyKeyListening then return end
    if input.UserInputType == Enum.UserInputType.Keyboard then
        if gpe or UIS:GetFocusedTextBox() then return end
    elseif not isGamepadInput(input) then return end
    if not isBindableInput(input) then return end
    local kc = input.KeyCode
    if not kc then return end
    if kbMatch(KB.LaggerMode, kc) then
        toggleLaggerCycle()
        return
    end
    if kbMatch(KB.CarryToggle, kc) then toggleCarryMode(); return end
    if kbMatch(KB.DropBrainrot, kc) then
        if not dropActive then setDropBrainrot(true) end
        return
    end
    if kbMatch(KB.TPFloor, kc) then
        -- Manual TP Down takes control from the automatic heartbeat loop.
        if autoTPEnabled then stopAutoTPDown() end
        doTpDown()
        return
    end
    if kbMatch(KB.InstaReset, kc) then
        if _G.InstaReset and _G.InstaReset.Trigger then _G.InstaReset.Trigger() end
        return
    end
    if kbMatch(KB.AutoLeft, kc) then
        autoLeftEnabled = not autoLeftEnabled
        if autoLeftEnabled then startAutoLeft() else stopAutoLeft() end
        if autoLeftSetVisual then autoLeftSetVisual(autoLeftEnabled) end
        if mobSetAutoLeft then mobSetAutoLeft(autoLeftEnabled) end
        markSettingsDirty()
        return
    end
    if kbMatch(KB.AutoRight, kc) then
        autoRightEnabled = not autoRightEnabled
        if autoRightEnabled then startAutoRight() else stopAutoRight() end
        if autoRightSetVisual then autoRightSetVisual(autoRightEnabled) end
        if mobSetAutoRight then mobSetAutoRight(autoRightEnabled) end
        markSettingsDirty()
        return
    end
    if kbMatch(KB.AutoBat, kc) then
        -- Keyboard-only: this keybind follows AimPot Mode (Key).
        -- Mobile Normal and Bypass buttons keep their fixed V1/V2 modes, regardless of this selector.
        toggleAutoBatFromInput("key", normalizeAimbotMode(aimbotMode))
        return
    end
    if kbMatch(KB.GuiHide, kc) then
        local t = os.clock()
        if (t - (_G._YassinLastGuiHide or 0)) < 0.25 then return end
        _G._YassinLastGuiHide = t
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

print("[YASSIN] v8.0.5 loaded")
