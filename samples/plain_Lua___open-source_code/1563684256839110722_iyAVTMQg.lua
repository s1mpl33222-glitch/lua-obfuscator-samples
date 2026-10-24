-- Services
local playersService   = game:GetService("Players")
local runService       = game:GetService("RunService")
local workspaceService = game:GetService("Workspace")

local clientPlayer = playersService.LocalPlayer

local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

local Window = WindUI:CreateWindow({
    Title            = "V1PRSTAB",
    Icon             = "sparkle",
    Author           = "Maintained by Viper",
    Folder           = "GlovSakenScript",
    Size             = UDim2.fromOffset(350, 350),
    Transparent      = false,
    Theme            = "Dark",
    Resizable        = false,
    SideBarWidth     = 150,
    HideSearchBar    = true,
    ScrollBarEnabled = false,
})
Window:SetToggleKey(Enum.KeyCode.K)
WindUI:SetFont("rbxasset://fonts/families/AccanthisADFStd.json")

Window:EditOpenButton({
    Title           = "V1PRSTAB",
    Icon            = "sparkle",
    CornerRadius    = UDim.new(0, 16),
    StrokeThickness = 0,
    Color           = ColorSequence.new(Color3.fromHex("000000"), Color3.fromHex("000000")),
    OnlyMobile      = true,
    Enabled         = true,
    Draggable       = true,
})

local BackstabTab     = Window:Tab({ Title = "Backstab", Icon = "sword" })
local SettingsSection = BackstabTab:Section({ Title = "Settings", Opened = true })

----------------------------------------------------------------
-- CONSTANTS (sourced directly from TwoTime Behavior + Config)
----------------------------------------------------------------

-- Both backstab angle thresholds are 70 degrees (Config: DaggerBackstabThreshold
-- and DaggerLookDirectionAngle). Precompute cosine for dot-product comparisons.
local BACKSTAB_THRESHOLD_COS  = math.cos(math.rad(70))   -- ≈ 0.342

-- Server windup delay before hitbox + lunge activate (Behavior: task.delay(0.3, ...))
local SERVER_WINDUP            = 0.30   -- seconds

-- Hitbox active window (Behavior: v_u_48 = crouching and 0.415 or 0.25)
local HITBOX_TIME_UNCROUCHED   = 0.25   -- seconds
-- local HITBOX_TIME_CROUCHED  = 0.415  -- (reference only)

----------------------------------------------------------------
-- USER-TUNABLE CONFIG
----------------------------------------------------------------

-- Detection range. At 60 studs/s the lunge covers ~15 studs in 0.25s,
-- so 4-12 studs is ideal for the tech.
local DEFAULT_PROXIMITY   = 8

-- Seconds from dagger button fire to rotation flip.
-- Formula: SERVER_WINDUP (0.30s) + your_ping_in_seconds
-- Default assumes ~80ms average Roblox ping → 0.30 + 0.08 = 0.38s
-- Raise if backstabs are not registering. Lower if Two Time overshoots.
local DASH_FLIP_DELAY     = 0.38

-- How long to hold the rotation lock (should match hitbox window).
-- 0.25s = uncrouched hitbox time (standard Dash-Stab Tech case).
local LUNGE_HOLD_DURATION = HITBOX_TIME_UNCROUCHED   -- 0.25s

-- Studs to push Two Time forward (along killer's LookVector) at the moment of flip.
-- Hitbox occupies 2.75–8.25 studs ahead of Two Time (offset=5.5, size=5.5 from Behavior).
-- This nudge places the killer toward the center of the hitbox rather than its edge.
-- Raise if backstabs still miss. Keep under 4.0 to avoid overshooting past the killer.
local DEPTH_OFFSET        = 2.0   -- studs

-- Aim-mode lerp speed and late-snap delay (Auto Backstab only)
local LERP_SPEED          = 0.37 * 1.6
local AIM_SNAP_DELAY      = 0.25

-- Loop and cooldown
local CHECK_INTERVAL      = 0.05
local COOLDOWN            = 5.0

-- State
local isRunning     = true
local enabled       = false
local daggerEnabled = false
local mode          = "Auto Backstab"
local baseProximity     = DEFAULT_PROXIMITY  -- set by user via slider, never touched by speed logic
local suppressCallback  = false              -- prevents SetValue from baking sprint bonus into baseProximity
local lastTrigger   = 0
local aimRefCount   = 0

-- Killer speed tracking
-- Threshold: 26.7 studs/s (killer sprint speed). Above this = sprinting killer,
-- so detection range is extended by +10 to catch them earlier.
local SPRINT_THRESHOLD   = 26.7
local RANGE_SPRINT_BONUS = 10
-- Per-killer sample table for velocity estimation: { pos=Vector3, t=number }
local killerSpeedCache   = {}
local killerSprintLatch  = {}  -- killer → time when sprint state last became true
local lastDisplayedRange = DEFAULT_PROXIMITY
local detectionRangeSlider = nil  -- set after UI builds

----------------------------------------------------------------
-- Helpers
----------------------------------------------------------------

local function getCharacter()
    return clientPlayer.Character or clientPlayer.CharacterAdded:Wait()
end

local function getDaggerButton()
    local pg = clientPlayer:FindFirstChild("PlayerGui")
    if not pg then return nil end
    local mainUI = pg:FindFirstChild("MainUI")
    if not mainUI then return nil end
    local container = mainUI:FindFirstChild("AbilityContainer")
    if not container then return nil end
    return container:FindFirstChild("Dagger")
end

local function getDaggerCooldown()
    local btn = getDaggerButton()
    if not btn then return nil end
    return btn:FindFirstChild("CooldownTime")
        or btn:FindFirstChild("Cooldown")
        or btn:FindFirstChildWhichIsA("NumberValue")
        or btn:FindFirstChildWhichIsA("StringValue")
        or btn:FindFirstChild("CooldownLabel")
        or btn:FindFirstChild("Timer")
        or btn:FindFirstChild("CD")
end

local function readCooldownValue(cdObj)
    if not cdObj then return nil end
    if cdObj:IsA("NumberValue") then return cdObj.Value end
    if cdObj:IsA("StringValue") then return tonumber(cdObj.Value) end
    if cdObj:IsA("TextLabel") or cdObj:IsA("TextBox") then return tonumber(cdObj.Text) end
    if type(cdObj.Value) == "number" then return cdObj.Value end
    if type(cdObj.Value) == "string" then return tonumber(cdObj.Value) end
    if cdObj.Text ~= nil then return tonumber(cdObj.Text) end
    return nil
end

local function getKillerSpeed(killer)
    local khrp = killer:FindFirstChild("HumanoidRootPart")
    if not khrp then return 0 end
    local now   = os.clock()
    local cache = killerSpeedCache[killer]
    local speed = 0
    if cache then
        local dt = now - cache.t
        if dt > 0 then
            -- Flat XZ speed only — matches how Roblox walkspeed is defined
            local dp = khrp.Position - cache.pos
            local dxz = Vector3.new(dp.X, 0, dp.Z)
            speed = dxz.Magnitude / dt
        end
    end
    killerSpeedCache[killer] = { pos = khrp.Position, t = now }
    return speed
end

local function getKillersFolder()
    local pf = workspaceService:FindFirstChild("Players")
    if not pf then return nil end
    return pf:FindFirstChild("Killers")
end

local function isValidKillerModel(model)
    if not model then return false end
    local hrp = model:FindFirstChild("HumanoidRootPart")
    local hum = model:FindFirstChildWhichIsA("Humanoid")
    return hrp and hum and hum.Health and hum.Health > 0
end

local function tryActivateButton(btn)
    if not btn then return false end
    pcall(function() if btn.Activate then btn:Activate() end end)
    local ok, conns = pcall(function()
        if type(getconnections) == "function" and btn.MouseButton1Click then
            return getconnections(btn.MouseButton1Click)
        end
        return nil
    end)
    if ok and conns then
        for _, conn in ipairs(conns) do
            pcall(function()
                if conn.Function then conn.Function()
                elseif conn.func then conn.func()
                elseif conn.Fire then conn.Fire() end
            end)
        end
    end
    pcall(function() if btn.Activated then btn.Activated:Fire() end end)
    return true
end

local function setAutoRotate(value)
    local char = clientPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if hum then pcall(function() hum.AutoRotate = value end) end
end

----------------------------------------------------------------
-- Auto Backstab — Aim mode
----------------------------------------------------------------
local function aimAtKiller(killerModel, duration)
    if not killerModel or not isRunning then return end
    local char = getCharacter()
    local hum  = char and char:FindFirstChildWhichIsA("Humanoid")
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local khrp = killerModel:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp or not khrp then return end

    aimRefCount += 1
    if aimRefCount == 1 then pcall(function() hum.AutoRotate = false end) end

    local function finish()
        aimRefCount = math.max(0, aimRefCount - 1)
        if aimRefCount == 0 then setAutoRotate(true) end
    end

    local t0 = os.clock()
    local conn
    conn = runService.Heartbeat:Connect(function()
        if not isRunning or os.clock() - t0 >= duration then
            conn:Disconnect(); finish(); return
        end
        if khrp and hrp then
            local tgt = Vector3.new(khrp.Position.X, hrp.Position.Y, khrp.Position.Z)
            hrp.CFrame = hrp.CFrame:Lerp(CFrame.new(hrp.Position, tgt), LERP_SPEED)
        end
    end)
end

----------------------------------------------------------------
-- Dash-Stab Tech
--
-- SERVER BACKSTAB CHECK (from decompiled Behavior script):
--
--   v58 = killerCFrame.LookVector
--   v63 = CFrame.new(twoTimeXZ + killerY) * twoTimeRotation
--           ↑ Two Time evaluated at killer's Y — vertical gap is IGNORED
--
--   v66 = deg(acos( (killerPos - twoTimePos).Unit : Dot(v58) ))
--         → "Backstab Angle": angle between the Two Time→Killer vector
--           and the killer's LookVector.
--         → v66 < 70° means Two Time is in the region BEHIND the killer.
--
--   v69 = deg(acos( twoTimeLookVector : Dot(v58) ))
--         → "Look Direction Angle": angle between Two Time's look and killer's look.
--         → v69 < 70° means Two Time faces roughly the SAME direction as killer.
--
--   BACKSTAB = v69 < 70 AND v66 < 70
--
-- HOW THE TECH ACHIEVES BOTH CONDITIONS:
--   1. Two Time faces TOWARD the killer (opposite to killer look) and lunges.
--      Lunge force: 60 studs/s uncrouched, 110 crouched (from Config).
--   2. The lunge carries Two Time through the killer and past them.
--      Two Time is now BEHIND the killer → v66 < 70° ✓
--   3. During the lunge, we flip Two Time to face the SAME direction as the killer.
--      Two Time's LookVector now matches killer's LookVector → v69 < 70° ✓
--   4. The hitbox (CFrameOffset = CFrame.new(0,0,-5.5), so 5.5 studs forward of
--      Two Time) sweeps through the space ahead of Two Time. Since Two Time is just
--      past the killer and both face the same direction, the hitbox catches the killer
--      in its 2.75–8.25 stud forward range as Two Time slides by.
--
-- TIMING:
--   0.000s  dagger fires (client → server)
--   +latency server receives call
--   +0.300s  server windup ends: hitbox spawns + lunge velocity applied
--   +0.300s to +0.550s  hitbox active (0.25s uncrouched window)
--   DASH_FLIP_DELAY ≈ 0.38s  flip begins on client
--   Heartbeat lock holds for LUNGE_HOLD_DURATION (0.25s) covering the hitbox window
----------------------------------------------------------------
local function performDashStabTech(killerModel)
    if not killerModel or not isRunning then return end
    local char = getCharacter()
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local khrp = killerModel:FindFirstChild("HumanoidRootPart")
    if not hrp or not khrp then return end

    -- Step 1: Kill AutoRotate and snap Two Time to face directly at the killer.
    --         This is the "W press" — the lunge will fire in this direction.
    --         Y is flattened to match the server's backstab check (which ignores Y).
    setAutoRotate(false)
    local aimTarget = Vector3.new(khrp.Position.X, hrp.Position.Y, khrp.Position.Z)
    hrp.CFrame = CFrame.lookAt(hrp.Position, aimTarget, Vector3.new(0, 1, 0))

    -- Step 2: Fire the dagger. Server starts the 0.3s windup clock.
    if daggerEnabled then
        tryActivateButton(getDaggerButton())
    end

    -- Step 3: Wait for server windup + network latency (DASH_FLIP_DELAY).
    --         After this point the lunge velocity should be active on the server,
    --         pushing Two Time toward the killer.
    task.wait(DASH_FLIP_DELAY)
    if not isRunning then setAutoRotate(true) return end

    -- Step 4: Rotation lock — every Heartbeat, force Two Time to face the SAME
    --         direction as the killer (matching killerCFrame.LookVector exactly).
    --         Position is completely untouched so the lunge moves Two Time freely.
    --
    --         upVector is pinned to (0,1,0) to prevent any roll from the lunge
    --         physics bleeding into the CFrame we set, which could skew v69 on server.
    local holdStart   = os.clock()
    local firstFrame  = true
    local holdConn
    holdConn = runService.Heartbeat:Connect(function()
        if not isRunning or os.clock() - holdStart >= LUNGE_HOLD_DURATION then
            holdConn:Disconnect()
            setAutoRotate(true)
            return
        end

        local khrp2 = killerModel:FindFirstChild("HumanoidRootPart")
        local char2 = getCharacter()
        local hrp2  = char2 and char2:FindFirstChild("HumanoidRootPart")
        if khrp2 and hrp2 then
            local look = khrp2.CFrame.LookVector

            -- On the very first frame of the lock, apply a forward nudge along the
            -- killer's LookVector so Two Time slides deeper past the killer.
            -- Hitbox center is 5.5 studs ahead; DEPTH_OFFSET moves the killer toward
            -- that center zone. Position is set at killer Y to keep the check flat.
            local nudgedPos = hrp2.Position
            if firstFrame then
                firstFrame = false
                nudgedPos = Vector3.new(
                    hrp2.Position.X + look.X * DEPTH_OFFSET,
                    hrp2.Position.Y,   -- preserve Y — server backstab check ignores it
                    hrp2.Position.Z + look.Z * DEPTH_OFFSET
                )
            end

            -- Lock rotation to killer's LookVector exactly (v69 ≈ 0° on server).
            -- upVector pinned to avoid roll from lunge physics skewing the angle.
            hrp2.CFrame = CFrame.lookAt(nudgedPos, nudgedPos + look, Vector3.new(0, 1, 0))
        end
    end)
end

----------------------------------------------------------------
-- Visual radius ring
-- A flat cylinder placed at each killer's feet shows the effectiveRange in real time.
-- Color shifts green → red as Two Time gets closer to the edge.
-- The ring is only visible to the local client (created in workspace.CurrentCamera
-- or simply parented to workspace — Roblox only replicates server-created parts).
----------------------------------------------------------------
local radiusParts = {}   -- killerModel → BasePart
local showRadius  = true  -- toggled from UI

local function getOrCreateRadiusPart(killer)
    if radiusParts[killer] then return radiusParts[killer] end
    local part = Instance.new("Part")
    part.Name          = "V1PRSTABRadius"
    part.Anchored      = true
    part.CanCollide    = false
    part.CanQuery      = false
    part.CanTouch      = false
    part.CastShadow    = false
    part.Shape         = Enum.PartType.Cylinder
    part.Material      = Enum.Material.Neon
    part.Transparency  = 0.65
    part.Color         = Color3.fromRGB(0, 200, 255)
    part.Size          = Vector3.new(0.15, 2, 2)   -- height=0.15 (flat disc), diameter set below
    part.Parent        = workspaceService
    radiusParts[killer] = part

    -- Clean up if the killer model is removed
    killer.AncestryChanged:Connect(function()
        if not killer:IsDescendantOf(workspaceService) then
            part:Destroy()
            radiusParts[killer] = nil
        end
    end)
    return part
end

local function destroyAllRadiusParts()
    for _, part in pairs(radiusParts) do
        pcall(function() part:Destroy() end)
    end
    radiusParts = {}
end

local function updateRadiusPart(killer, khrp, range, twoTimeInside)
    if not showRadius then
        -- If the toggle is off, destroy any existing ring for this killer
        local existing = radiusParts[killer]
        if existing then
            existing:Destroy()
            radiusParts[killer] = nil
        end
        return
    end

    local part = getOrCreateRadiusPart(killer)
    local diameter = range * 2

    -- Lay the cylinder flat on the XZ plane at the killer's foot level
    local footY = khrp.Position.Y - 3   -- approx foot height
    part.Size  = Vector3.new(0.15, diameter, diameter)
    part.CFrame = CFrame.new(khrp.Position.X, footY, khrp.Position.Z)
               * CFrame.Angles(0, 0, math.pi / 2)   -- rotate cylinder to lie flat

    -- Color: blue when Two Time is outside, shifts to red as they get closer
    if twoTimeInside then
        -- Inside the radius → bright red pulse to signal imminent trigger
        local t = os.clock()
        local pulse = 0.5 + 0.5 * math.sin(t * 8)   -- fast pulse
        part.Color = Color3.fromRGB(255, math.floor(pulse * 80), 0)
        part.Transparency = 0.3 + pulse * 0.2
    else
        -- Outside → cool blue, opacity scales with proximity
        part.Color = Color3.fromRGB(0, 180, 255)
        part.Transparency = 0.65
    end
end

----------------------------------------------------------------
-- Main detection loop
----------------------------------------------------------------
task.spawn(function()
    while isRunning do
        task.wait(CHECK_INTERVAL)
        if not enabled or not isRunning then continue end

        local killersFolder = getKillersFolder()
        if not killersFolder then continue end

        local char = getCharacter()
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        for _, killer in pairs(killersFolder:GetChildren()) do
            if not isValidKillerModel(killer) then continue end
            local khrp        = killer:FindFirstChild("HumanoidRootPart")
            local dist        = (khrp.Position - hrp.Position).Magnitude
            local killerSpeed = getKillerSpeed(killer)
            -- Sprint hysteresis: when the killer drops below the threshold, hold the
            -- bigger radius for 0.06s before shrinking back to walking range.
            -- This prevents the ring from flickering at the speed boundary.
            local nowClock = os.clock()
            if killerSpeed > SPRINT_THRESHOLD then
                killerSprintLatch[killer] = nowClock   -- refresh latch while sprinting
            end
            local latchAge   = killerSprintLatch[killer] and (nowClock - killerSprintLatch[killer]) or math.huge
            local isSprinting = killerSpeed > SPRINT_THRESHOLD or latchAge < 0.06

            local effectiveRange = baseProximity + (isSprinting and RANGE_SPRINT_BONUS or 0)

            -- Reflect the live effective range on the slider so the user can see
            -- whether the sprint bonus is active. Only call SetValue when it changes
            -- to avoid unnecessary UI churn every tick.
            if detectionRangeSlider and effectiveRange ~= lastDisplayedRange then
                lastDisplayedRange = effectiveRange
                suppressCallback = true
                pcall(function() detectionRangeSlider:SetValue(effectiveRange) end)
                suppressCallback = false
            end

            -- Update visual ring for this killer every tick
            local twoTimeInsideRing = dist <= effectiveRange
            updateRadiusPart(killer, khrp, effectiveRange, twoTimeInsideRing)

            if mode == "Auto Backstab" then
                -- Two Time must be BEHIND the killer.
                -- (killerPos - twoTimePos).Unit · killerLook > cos(70°)
                -- means the angle from Two Time to the killer aligns with killer's look,
                -- placing Two Time in the -LookVector (back) region.
                local toKiller = (khrp.Position - hrp.Position).Unit
                local dot      = toKiller:Dot(khrp.CFrame.LookVector)
                local shouldTrigger = dot > BACKSTAB_THRESHOLD_COS and dist <= effectiveRange

                if shouldTrigger and os.clock() - lastTrigger >= COOLDOWN then
                    local cdNum = readCooldownValue(getDaggerCooldown())
                    if not (cdNum and cdNum > 0.1) then
                        lastTrigger = os.clock()
                        task.spawn(function()
                            aimAtKiller(killer, 0.5)
                            if daggerEnabled then tryActivateButton(getDaggerButton()) end
                            if AIM_SNAP_DELAY > 0 then
                                task.wait(AIM_SNAP_DELAY)
                                if not isRunning then return end
                                local khrp2 = killer:FindFirstChild("HumanoidRootPart")
                                local char2 = getCharacter()
                                local hrp2  = char2 and char2:FindFirstChild("HumanoidRootPart")
                                if khrp2 and hrp2 then
                                    local tgt = Vector3.new(khrp2.Position.X, hrp2.Position.Y, khrp2.Position.Z)
                                    hrp2.CFrame = CFrame.lookAt(hrp2.Position, tgt, Vector3.new(0, 1, 0))
                                end
                            end
                        end)
                        break
                    end
                end

            elseif mode == "Dash-Stab Tech" then
                -- Two Time must be IN FRONT of the killer within detection range.
                -- (twoTimePos - killerPos).Unit · killerLook > cos(70°)
                -- means Two Time is within 70° of the killer's LookVector direction
                -- (ahead of the killer), which is geometrically required for the
                -- lunge to carry Two Time through to the back side.
                local toPlayer = (hrp.Position - khrp.Position).Unit
                local dot      = toPlayer:Dot(khrp.CFrame.LookVector)
                local inFront  = dot > BACKSTAB_THRESHOLD_COS and dist <= effectiveRange

                -- Crouch gate: Dash-Stab Tech auto-dagger only fires while Two Time
                -- is crouched. The server checks Rig:GetAttribute("Crouching") to decide
                -- whether to use the crouched lunge (force=110) vs uncrouched (force=60).
                -- Crouched lunge is both faster and hits harder, making the tech reliable.
                local twoTimeCrouching = false
                local ttChar = getCharacter()
                if ttChar then
                    twoTimeCrouching = ttChar:GetAttribute("Crouching") == true
                end

                if inFront and twoTimeCrouching and os.clock() - lastTrigger >= COOLDOWN then
                    local cdNum = readCooldownValue(getDaggerCooldown())
                    if not (cdNum and cdNum > 0.1) then
                        lastTrigger = os.clock()
                        task.spawn(function()
                            performDashStabTech(killer)
                        end)
                        break
                    end
                end
            end
        end
    end
end)

----------------------------------------------------------------
-- UI
----------------------------------------------------------------

SettingsSection:Toggle({
    Title    = "Enabled",
    Type     = "Checkbox",
    Default  = false,
    Callback = function(state) enabled = state end,
})

SettingsSection:Toggle({
    Title    = "Auto Use Dagger",
    Type     = "Checkbox",
    Default  = false,
    Callback = function(state) daggerEnabled = state end,
})

SettingsSection:Dropdown({
    Title    = "Mode",
    Values   = {"Auto Backstab", "Dash-Stab Tech"},
    Value    = "Auto Backstab",
    Callback = function(value) mode = value end,
})

detectionRangeSlider = SettingsSection:Slider({
    Title    = "Detection Range",
    Step     = 1,
    Value    = { Min = 1, Max = 32, Default = DEFAULT_PROXIMITY },
    Callback = function(value)
        if not suppressCallback then
            baseProximity = value
        end
    end,
})

-- Auto Backstab only
SettingsSection:Slider({
    Title    = "Aim Snap Delay (s)",
    Step     = 0.01,
    Value    = { Min = 0.00, Max = 0.40, Default = AIM_SNAP_DELAY },
    Callback = function(value) AIM_SNAP_DELAY = value end,
})

-- Dash-Stab Tech: how long after button fire to flip rotation.
-- SERVER_WINDUP = 0.30s. Add your ping in seconds.
-- Example: 100ms ping → set to 0.40. 150ms ping → set to 0.45.
SettingsSection:Slider({
    Title    = "Flip Delay (s)",
    Step     = 0.01,
    Value    = { Min = 0.28, Max = 0.65, Default = DASH_FLIP_DELAY },
    Callback = function(value) DASH_FLIP_DELAY = value end,
})

-- How long to hold the rotation lock. Should match hitbox window:
-- 0.25s = uncrouched (standard), 0.415s = crouched.
SettingsSection:Slider({
    Title    = "Lunge Hold (s)",
    Step     = 0.005,
    Value    = { Min = 0.10, Max = 0.50, Default = LUNGE_HOLD_DURATION },
    Callback = function(value) LUNGE_HOLD_DURATION = value end,
})

-- Studs to push Two Time forward into the killer at the moment of flip.
-- Hitbox center is 5.5 studs ahead of Two Time (from Behavior source).
-- A nudge of 2-3 studs puts the killer in the reliable center of the hitbox.
-- Raise if backstabs still miss. Keep under 4.0 to avoid overshooting.
SettingsSection:Slider({
    Title    = "Depth Offset (st)",
    Step     = 0.25,
    Value    = { Min = 0.0, Max = 5.0, Default = DEPTH_OFFSET },
    Callback = function(value) DEPTH_OFFSET = value end,
})

----------------------------------------------------------------
-- Noclip
----------------------------------------------------------------
local noclipEnabled    = false
local noclipConnection = nil

local function setNoclip(state)
    noclipEnabled = state
    if noclipEnabled then
        noclipConnection = runService.Stepped:Connect(function()
            local char = clientPlayer.Character
            if char then
                for _, part in ipairs(char:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        if noclipConnection then
            noclipConnection:Disconnect()
            noclipConnection = nil
        end
        local char = clientPlayer.Character
        if char then
            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

-- Also toggleable with N key
game:GetService("UserInputService").InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.N then
        setNoclip(not noclipEnabled)
    end
end)

SettingsSection:Toggle({
    Title    = "Noclip, Easier backstabs",
    Type     = "Checkbox",
    Default  = false,
    Callback = function(state)
        setNoclip(state)
    end,
})

SettingsSection:Toggle({
    Title    = "Show Radius Ring",
    Type     = "Checkbox",
    Default  = true,
    Callback = function(state)
        showRadius = state
        if not state then destroyAllRadiusParts() end
    end,
})

----------------------------------------------------------------
-- Interface Tab
----------------------------------------------------------------
local InterfaceTab = Window:Tab({ Title = "Interface", Icon = "scan" })
InterfaceTab:Section({ Title = "UI Functions", Opened = true })

InterfaceTab:Button({
    Title    = "Unload Script",
    Callback = function()
        isRunning = false
        enabled   = false
        setAutoRotate(true)
        Window:Destroy()
    end,
})

InterfaceTab:Button({
    Title    = "Close UI",
    Callback = function() Window:Destroy() end,
})
