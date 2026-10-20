-- ===== GlideStab (Techs) =====
-- ===== GlideStab Assist (Techs) =====


-- ===== Inject Anims UI & logic (drop into the `if Library then` block, after CustomAnimLeftGroup is created) =====



-- Watcher: detect the START of the target anim (instant trigger) and run the assist once per star


-- Auto backstab (Obsidian Example.lua UI)
-- Place as LocalScript (StarterGui or StarterPlayerScripts)
-- Uses Obsidian Example API (CreateWindow, AddTab, AddToggle, AddInput, AddDropdown, Options, Toggles).
-- If HttpGet is blocked: download Library.lua and addons into a ModuleScript and require them instead.



local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Player = Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")

-- CONFIG (same as original)
local DEFAULT_PROXIMITY = 8
local DEFAULT_DURATION = 0.7
local BEHIND_DISTANCE = 1.7
local CHECK_INTERVAL = 0.12
local COOLDOWN = 5
local LERP_SPEED = 0.37
local DELAY_BEFORE_STAB = 0.08
local BACKSTAB_TYPE = "lerp" -- default
-- PREDICTION CONFIG / STATE
local PREDICTION_STRENGTH = 0.6  -- 0 = no prediction, 1 = "strong" (tweak to taste)
local PREDICTION_TIME = 0.12     -- seconds to predict ahead (uses velocity * time)
-- techs config / state
local glidestabEnabled = false
local glidestabLastTime = 0
local GLIDESTAB_COOLDOWN = 3        -- 3 seconds cooldown after firing
local GLIDESTAB_BESIDE_TIMEOUT = 1  -- wait up to 1 second to become "beside" killer
local GLIDESTAB_DURATION = 0.4    -- look+dagger time
local GLIDESTAB_CHECK_RATE = 0.06
local TARGET_ANIM_ID = "89448354637442" -- animation id to watch for
-- new: aiming mode for techs ("Character" or "Camera")
local aimingMode = "Character" -- default
-- Add these vars near the other GLIDESTAB vars at top
local glidestabAssistEnabled = false
local GLIDESTAB_ASSIST_DURATION = 0.5
local GLIDESTAB_ASSIST_CHECK_RATE = 0.03
local glidestabAssistPrevPlaying = false
-- new: glide stab type for Techs ("Legit" or "Teleport")
local GLIDESTAB_TYPE = "Legit" -- "Legit" = existing behavior, "Teleport" = teleport-behind-for-duration
-- custom anims
local injectAnimsEnabled = false
local TwoTimeModulePath
pcall(function()
    TwoTimeModulePath = ReplicatedStorage:WaitForChild("Assets", 1)
        and ReplicatedStorage.Assets:FindFirstChild("Survivors")
        and ReplicatedStorage.Assets.Survivors:FindFirstChild("TwoTime")
        and ReplicatedStorage.Assets.Survivors.TwoTime:FindFirstChild("Config")
end)
local animKeys = {
    "CrouchStart",
    "CrouchIdle",
    "CrouchWalk",
    "CrouchRun",
    "Stab",
    "LungeStart",
    "LungeLoop",
    "LungeEnd",
    "Ritual",
}
-- store the user's inputs
local TwoTimeAnimInputs = {}
-- continuous tracker for killers: keeps recent pos, look and estimated velocity
local killerTrack = {}  -- keyed by HumanoidRootPart instance; values: {pos, look, vel, t, prevLook}
-- hitbox expander config
local ForsakenReachEnabled = false
local NearestDist = 120

Player.CharacterAdded:Connect(function(NewCharacter)
    Character = NewCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
end)

local RNG = Random.new()

local AttackAnimations = {
    'rbxassetid://86545133269813', --dagger
    'rbxassetid://89448354637442' -- crouch stab
}

-- Core helpers (unchanged logic)
local function getCharacter()
    return LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
end

local function getDaggerButton()
    local pg = LocalPlayer:FindFirstChild("PlayerGui")
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
    local cd = btn:FindFirstChild("CooldownTime")
        or btn:FindFirstChild("Cooldown")
        or btn:FindFirstChildWhichIsA("NumberValue")
        or btn:FindFirstChildWhichIsA("StringValue")
    if cd then return cd end
    local lbl = btn:FindFirstChild("CooldownLabel") or btn:FindFirstChild("Timer") or btn:FindFirstChild("CD")
    if lbl then return lbl end
    return nil
end

local function readCooldownValue(cdObj)
    if not cdObj then return nil end
    if cdObj and cdObj:IsA("NumberValue") then
        return cdObj.Value
    end
    if cdObj and cdObj:IsA("StringValue") then
        return tonumber(cdObj.Value)
    end
    if cdObj and (cdObj:IsA("TextLabel") or cdObj:IsA("TextBox")) then
        return tonumber(cdObj.Text)
    end
    if cdObj.Value ~= nil then
        if type(cdObj.Value) == "number" then return cdObj.Value end
        if type(cdObj.Value) == "string" then return tonumber(cdObj.Value) end
    end
    if cdObj.Text ~= nil then
        return tonumber(cdObj.Text)
    end
    return nil
end

local function getKillersFolder()
    local playersFolder = Workspace:FindFirstChild("Players")
    if not playersFolder then return nil end
    return playersFolder:FindFirstChild("Killers")
end

local function isValidKillerModel(model)
    if not model then return false end
    local hrp = model:FindFirstChild("HumanoidRootPart")
    local humanoid = model:FindFirstChildWhichIsA("Humanoid")
    return hrp and humanoid and humanoid.Health and humanoid.Health > 0
end

local function tryActivateButton(btn)
    if not btn then return false end
    pcall(function()
        if btn.Activate then btn:Activate() end
    end)

    local ok, conns = pcall(function()
        if type(getconnections) == "function" and btn.MouseButton1Click then
            return getconnections(btn.MouseButton1Click)
        end
        return nil
    end)

    if ok and conns then
        for _, conn in ipairs(conns) do
            pcall(function()
                if conn.Function then
                    conn.Function()
                elseif conn.func then
                    conn.func()
                elseif conn.Fire then
                    conn.Fire()
                end
            end)
        end
    end

    pcall(function()
        if btn.Activated then
            btn.Activated:Fire()
        end
    end)

    return true
end

-- State
local enabled = false
local directbehind = false
local daggerenabled = false
local lastTrigger = 0
local rangeMode = "Around"
local aimRefCount = 0
local aimingEnabled = true
-- prediction state
local predictionEnabled = false

-- Misc state


local function setAutoRotateForCurrentCharacter(enabledValue)
    local char = LocalPlayer.Character
    if not char then return end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if hum then
        pcall(function() hum.AutoRotate = enabledValue end)
    end
end

LocalPlayer.CharacterAdded:Connect(function(char)
    aimRefCount = 0
    local hum = char:WaitForChild("Humanoid", 5)
    if hum then pcall(function() hum.AutoRotate = true end) end
end)

-- ===================== Continuous killer tracker =====================
-- Samples killer HRP position and look every Heartbeat and computes velocity (pos delta / dt).
-- This provides a live velocity/look history for the prediction math to use while aiming.
RunService.Heartbeat:Connect(function(dt)
    local killersFolder = getKillersFolder()
    if not killersFolder then return end
    local now = os.clock()
    for _, killer in pairs(killersFolder:GetChildren()) do
        local khrp = killer:FindFirstChild("HumanoidRootPart")
        if khrp then
            local state = killerTrack[khrp]
            local pos = khrp.Position
            local look = khrp.CFrame.LookVector
            if state and state.t and state.pos then
                local dtSample = now - state.t
                if dtSample > 0 then
                    local vel = (pos - state.pos) / dtSample
                    -- keep a smoothed velocity to reduce jitter (simple lerp smoothing)
                    local smoothVel = state.vel and (state.vel:Lerp(vel, math.clamp(dtSample*10, 0, 1))) or vel
                    killerTrack[khrp] = { pos = pos, look = look, vel = smoothVel, t = now, prevLook = state.look }
                else
                    killerTrack[khrp] = { pos = pos, look = look, vel = Vector3.new(0,0,0), t = now, prevLook = state and state.look or look }
                end
            else
                killerTrack[khrp] = { pos = pos, look = look, vel = Vector3.new(0,0,0), t = now, prevLook = look }
            end
        end
    end
end)
-- =====================================================================

-- Movement behind killer (updated to use killerTrack for prediction)
local function activateForKiller(killerModel, duration)
    if not killerModel then return end
    local char = getCharacter()
    local humanoid = char and char:FindFirstChildWhichIsA("Humanoid")
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local khrp = killerModel and killerModel:FindFirstChild("HumanoidRootPart")
    if not humanoid or not hrp or not khrp then return end

    -- Only touch AutoRotate/aim refcount when aiming is enabled.
    local didAim = false
    if aimingEnabled then
        aimRefCount = aimRefCount + 1
        didAim = true
        if aimRefCount == 1 then
            pcall(function() humanoid.AutoRotate = false end)
        end
    end

    local function finishAiming()
        if didAim then
            aimRefCount = math.max(0, aimRefCount - 1)
            if aimRefCount == 0 then
                setAutoRotateForCurrentCharacter(true)
            end
        end
    end

    -- If aiming is disabled, do nothing (no movement/rotation). Keep symmetry by scheduling cleanup.
    if not aimingEnabled then
        task.delay(duration or DEFAULT_DURATION, finishAiming)
        return
    end

    local function computeDesiredCFrame()
        local kCFrame = khrp.CFrame
        -- base behind position
        local behindPos = kCFrame.Position - (kCFrame.LookVector.Unit * BEHIND_DISTANCE)
        behindPos = Vector3.new(behindPos.X, kCFrame.Position.Y, behindPos.Z)

        -- if prediction is off, return normal CFrame
        if not predictionEnabled then
            return CFrame.new(behindPos, behindPos + kCFrame.LookVector.Unit)
        end

        -- Only make prediction adjustments for lerp/teleport
        if BACKSTAB_TYPE ~= "lerp" and BACKSTAB_TYPE ~= "teleport" then
            return CFrame.new(behindPos, behindPos + kCFrame.LookVector.Unit)
        end

        -- Use tracked velocity (smoothed) if available, otherwise fallback to instance Velocity
        local tracked = killerTrack[khrp]
        local vel = Vector3.new(0,0,0)
        if tracked and tracked.vel then
            vel = tracked.vel
        else
            pcall(function()
                vel = khrp.Velocity or Vector3.new(0,0,0)
            end)
        end
        local horizVel = Vector3.new(vel.X, 0, vel.Z) -- ignore vertical velocity

        -- predicted displacement from velocity (forward/back + lateral)
        local predictedMove = horizVel * (PREDICTION_TIME or 0.12) * (PREDICTION_STRENGTH or 0.6)

        local forward = kCFrame.LookVector
        local right = kCFrame.RightVector

        -- project predictedMove into forward and right components
        local forwardComp = forward * (predictedMove:Dot(forward))
        local lateralComp = right * (predictedMove:Dot(right))

        -- rotation change based "turn" estimation (captures turning-left/turning-right)
        local turnComp = Vector3.new(0,0,0)
        if tracked and tracked.prevLook then
            local prevLook = tracked.prevLook
            local deltaLook = forward - prevLook
            -- use projection of delta onto right vector as turning sign & magnitude
            local turnAmount = deltaLook:Dot(right)
            -- scale turning effect: multiplier tuned to be noticeable; user controls global strength
            local TURN_FACTOR = 3.0
            turnComp = right * (turnAmount * TURN_FACTOR * (PREDICTION_STRENGTH or 0.6))
        end

        -- combine offsets
        local predictedOffset = forwardComp + lateralComp + turnComp

        -- apply predicted offset to the behind position
        local finalPos = behindPos + Vector3.new(predictedOffset.X, 0, predictedOffset.Z)

        -- return CFrame facing same direction as killer
        return CFrame.new(finalPos, finalPos + kCFrame.LookVector.Unit)
    end

    if hrp.Anchored then hrp.Anchored = false end

    if BACKSTAB_TYPE == "lerp" then
        local goalCFrame = computeDesiredCFrame()
        local tweenInfo = TweenInfo.new(0.12, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local ok, tween = pcall(function() return TweenService:Create(hrp, tweenInfo, {CFrame = goalCFrame}) end)
        if ok and tween then pcall(function() tween:Play() end) else pcall(function() hrp.CFrame = goalCFrame end) end

        local t0 = os.clock()
        local conn
        conn = RunService.Heartbeat:Connect(function()
            if not conn then return end
            if os.clock() - t0 >= (duration or DEFAULT_DURATION) then
                conn:Disconnect()
                conn = nil
                finishAiming()
                return
            end
            if not khrp or not hrp then return end
            local desiredCFrame = computeDesiredCFrame()
            hrp.CFrame = hrp.CFrame:Lerp(desiredCFrame, LERP_SPEED)
        end)

    elseif BACKSTAB_TYPE == "teleport" then
        local goalCFrame = computeDesiredCFrame()
        pcall(function() hrp.CFrame = goalCFrame end)

        local t0 = os.clock()
        local conn
        conn = RunService.Heartbeat:Connect(function()
            if not conn then return end
            if os.clock() - t0 >= (duration or DEFAULT_DURATION) then
                conn:Disconnect()
                conn = nil
                finishAiming()
                return
            end
            if not khrp or not hrp then return end
            local desiredCFrame = computeDesiredCFrame()
            pcall(function() hrp.CFrame = desiredCFrame end)
        end)

    elseif BACKSTAB_TYPE == "just auto stab (if its on)" then
        local t0 = os.clock()
        local conn
        conn = RunService.Heartbeat:Connect(function()
            if not conn then return end
            if os.clock() - t0 >= (duration or DEFAULT_DURATION) then
                conn:Disconnect()
                conn = nil
                finishAiming()
                return
            end
            if not khrp or not hrp then return end
            local lookVec = khrp.CFrame.LookVector
            local curPos = hrp.Position
            local targetCFrame = CFrame.new(curPos, curPos + lookVec)
            pcall(function() hrp.CFrame = targetCFrame end)
        end)
    end
end

local function isPlayingTargetAnim(char)
    if not char then return false end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if not hum then return false end
    local ok, tracks = pcall(function() return hum:GetPlayingAnimationTracks() end)
    if not ok or not tracks then return false end
    for _, track in ipairs(tracks) do
        local anim = track.Animation
        if anim and anim.AnimationId then
            local digits = tostring(anim.AnimationId):match("%d+")
            if digits and tostring(digits) == tostring(TARGET_ANIM_ID) then
                return true
            end
        end
    end
    return false
end

-- "Beside" test: within range and roughly to the side of the killer (using right vector dot)
local function isBesideKiller(hrp, khrp, range)
    if not hrp or not khrp then return false end
    local rel = hrp.Position - khrp.Position
    local dist = Vector3.new(rel.X, 0, rel.Z).Magnitude
    if dist > range then return false end
    if rel.Magnitude <= 0 then return false end
    local unitRel = rel.Unit
    local sideDot = math.abs(unitRel:Dot(khrp.CFrame.RightVector))
    -- threshold tuned so player must be roughly to side; adjust (0.6) if needed
    return sideDot >= 0.9
end


-- Helper: pick a candidate killer for the assist (prefer one you're already to the side of)
local function findCandidateKillerForAssist(killersFolder, hrp, range)
    if not killersFolder or not hrp then return nil end
    local nearest, nearestDist = nil, math.huge
    for _, k in pairs(killersFolder:GetChildren()) do
        if isValidKillerModel(k) then
            local khrp = k:FindFirstChild("HumanoidRootPart")
            if khrp then
                local dist = (khrp.Position - hrp.Position).Magnitude
                if dist <= range then
                    if isBesideKiller(hrp, khrp, range) then
                        -- prefer someone you're already at the side of
                        return k
                    end
                    if dist < nearestDist then
                        nearest = k
                        nearestDist = dist
                    end
                end
            end
        end
    end
    return nearest
end

-- Core assist action: look at the *side* of the killer for the configured duration
-- Core assist action: look at the *side* of the killer for the configured duration
-- Replace doGlidestabAssist with this continuous-updating version
local function doGlidestabAssist(killerModel)
    if not killerModel then return end
    local char = getCharacter()
    local hrp = char and char:FindFirstChild("HumanoidRootPart")
    local humanoid = char and char:FindFirstChildWhichIsA("Humanoid")
    local khrp = killerModel and killerModel:FindFirstChild("HumanoidRootPart")
    if not hrp or not humanoid or not khrp then return end

    local SIDE_LOOK_DIST = 6
    local useMode = (typeof(aimingMode) == "string" and aimingMode) or "Character"
    local cam = workspace.CurrentCamera
    local prevCamCFrame = nil
    if useMode == "Camera" and cam then
        prevCamCFrame = cam.CFrame
    end

    -- manage AutoRotate / aim refcount only when rotating the character
    local didAim = false
    if aimingEnabled and useMode == "Character" then
        aimRefCount = aimRefCount + 1
        didAim = true
        if aimRefCount == 1 then
            pcall(function() humanoid.AutoRotate = false end)
        end
    end

    local function restoreAndReturn()
        if didAim then
            aimRefCount = math.max(0, aimRefCount - 1)
            if aimRefCount == 0 then
                setAutoRotateForCurrentCharacter(true)
            end
        end
        if useMode == "Camera" and prevCamCFrame and workspace.CurrentCamera then
            pcall(function() workspace.CurrentCamera.CFrame = prevCamCFrame end)
        end
        return
    end

    -- if already beside before starting, restore and stop immediately
    if isBesideKiller(hrp, khrp, DEFAULT_PROXIMITY) then
        restoreAndReturn()
        return
    end

    local t0 = os.clock()
    local duration = GLIDESTAB_ASSIST_DURATION or 0.5
    local tickRate = GLIDESTAB_ASSIST_CHECK_RATE or 0.03

    while os.clock() - t0 < duration do
        if not hrp or not khrp then break end

        -- STOP IMMEDIATELY if we become beside the killer
        if isBesideKiller(hrp, khrp, DEFAULT_PROXIMITY) then
            restoreAndReturn()
            return
        end

        -- Recompute which side we're on relative to the killer every tick
        local rel = hrp.Position - khrp.Position
        local sideDot = rel:Dot(khrp.CFrame.RightVector)
        local sideSign = (sideDot >= 0) and 1 or -1

        -- Optionally use prediction from killerTrack if enabled (falls back to current pos)
        local predictedPos = khrp.Position
        if predictionEnabled then
            local tracked = killerTrack[khrp]
            if tracked and tracked.vel then
                -- only use horizontal component for prediction
                local horizVel = Vector3.new(tracked.vel.X, 0, tracked.vel.Z)
                predictedPos = predictedPos + horizVel * (PREDICTION_TIME or 0.12) * (PREDICTION_STRENGTH or 0.6)
            end
        end

        -- recompute side point each tick so we follow the killer
        local sidePoint = predictedPos + (khrp.CFrame.RightVector * sideSign * SIDE_LOOK_DIST)

        if useMode == "Character" then
            pcall(function()
                local curPos = hrp.Position
                local targetCF = CFrame.new(curPos, sidePoint)
                hrp.CFrame = CFrame.new(targetCF.Position, targetCF.Position + targetCF.LookVector)
            end)
        else
            if cam then
                pcall(function()
                    local camPos = cam.CFrame.Position
                    cam.CFrame = CFrame.new(camPos, sidePoint)
                end)
            end
        end

        task.wait(tickRate)
    end

    -- cleanup if we exit normally
    if didAim then
        aimRefCount = math.max(0, aimRefCount - 1)
        if aimRefCount == 0 then
            setAutoRotateForCurrentCharacter(true)
        end
    end
    if useMode == "Camera" and prevCamCFrame and workspace.CurrentCamera then
        pcall(function() workspace.CurrentCamera.CFrame = prevCamCFrame end)
    end
end


local function isPlayerCharacter(model)
    if not model or not model:IsA("Model") then
        return false
    end
    -- quick sanity: must have a Humanoid (filters out many non-character models)
    if not model:FindFirstChildWhichIsA("Humanoid") then
        return false
    end
    -- this returns a Player object if the model is a player's character
    return Players:GetPlayerFromCharacter(model) ~= nil
end

-- ==== Obsidian UI (Example.lua API) ====
local success, Library = pcall(function()
    local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
    return loadstring(game:HttpGet(repo .. "Library.lua"))()
end)


local Tabs

local ThemeManager, SaveManager
if success and Library then
    pcall(function()
        local repo = "https://raw.githubusercontent.com/deividcomsono/Obsidian/main/"
        ThemeManager = loadstring(game:HttpGet(repo .. "addons/ThemeManager.lua"))()
        SaveManager = loadstring(game:HttpGet(repo .. "addons/SaveManager.lua"))()
    end)
else
    warn("Obsidian library failed to load. If HttpGet is blocked, require a local copy of Library.lua and addons instead.")
end

-- If Library loaded, build UI using Example.lua patterns
local Options, Toggles, Window
local ui_refs = {}

if Library then
    -- optional recommended settings from Example.lua
    Library.ForceCheckbox = false
    Library.ShowToggleFrameInKeybinds = true

    Window = Library:CreateWindow({
        Title = "Auto backstab",
        Footer = "v3",
        Icon = 95816097006870,
        NotifySide = "Right",
        ShowCustomCursor = true,
    })

    Tabs = {
        Main = Window:AddTab("Main", "sword"),
        Prediction = Window:AddTab("Prediction", "wrench"),
        Techs = Window:AddTab("Techs", "wrench"),
        CustomAnim = Window:AddTab("Custom Anims", "user"),
        Misc = Window:AddTab("Misc", "swords"),
       	["UI Settings"] = Window:AddTab("Settings", "settings"),
    }

    local LeftGroup = Tabs.Main:AddLeftGroupbox("autobackstab")
    local RightGroup = Tabs.Main:AddRightGroupbox("more things")
    local PredictionLeftGroup = Tabs.Prediction:AddLeftGroupbox("prediction")
    local PredictionRightGroup = Tabs.Prediction:AddRightGroupbox("more things")
    local TechLeftGroup = Tabs.Techs:AddLeftGroupbox("Techs")
    local TechRightGroup = Tabs.Techs:AddRightGroupbox("a")
    local CustomAnimLeftGroup = Tabs.CustomAnim:AddLeftGroupbox("Stuff")
    local CustomAnimRightGroup = Tabs.CustomAnim:AddRightGroupbox("more things")
    local MiscLeftGroup = Tabs.Misc:AddLeftGroupbox("misc")
    local MiscRightGroup = Tabs.Misc:AddRightGroupbox("more things")

    -- Toggle: Auto Backstab
    LeftGroup:AddToggle("AutoBackstab", {
        Text = "Auto Backstab",
        Tooltip = "Enable/disable the auto backstab watcher",
        Default = false,
        Callback = function(Value)
            enabled = Value
        end,
    })

    -- Input: Range (N)
    LeftGroup:AddInput("RangeInput", {
        Text = "Range (N)",
        Default = tostring(DEFAULT_PROXIMITY),
        Numeric = true,
        ClearTextOnFocus = false,
        Placeholder = tostring(DEFAULT_PROXIMITY),
        Callback = function(Value)
            -- Options.RangeInput.Value will also be updated by the library; keep a local copy if needed
        end,
    })

    -- Dropdown: Range Mode
    LeftGroup:AddDropdown("RangeMode", {
        Values = { "Around", "Behind" },
        Default = 1,
        Multi = false,
        Text = "Range Mode",
        Tooltip = "Choose detection mode",
        Callback = function(Value)
            rangeMode = Value
        end,
    })

    LeftGroup:AddToggle("DirectBehind", {
        Text = "stricter behind check",
        Tooltip = "behind mode will be stricter, means u have to be directly behind killer for it to backstab",
        Default = false,
        Callback = function(Value)
            directbehind = Value
        end,
    })

    LeftGroup:AddInput("BehindDistance", {
        Text = "Behind Distance",
        Tooltip = "how much studs u go behind killer when auto backstabbing",
        Default = BEHIND_DISTANCE,
        Numeric = true,
        ClearTextOnFocus = false,
        Placeholder = "put studs",
        Callback = function(Value)
            BEHIND_DISTANCE = Value
        end,
    })

    -- Toggle: Auto dagger / stab
    LeftGroup:AddToggle("AutoDagger", {
        Text = "Auto stab",
        Default = false,
        Callback = function(Value)
            daggerenabled = Value
        end,
    })

    -- Backstab type dropdown
    RightGroup:AddDropdown("BackstabType", {
        Values = { "lerp", "teleport", "just auto stab (if its on)" },
        Default = 1,
        Multi = false,
        Text = "Backstab type",
        Callback = function(Value)
            BACKSTAB_TYPE = Value
        end,
    })

    RightGroup:AddInput("LerpSpeed", {
        Text = "lerp speed",
        Default = 0.37,
        Numeric = true,
        ClearTextOnFocus = false,
        Placeholder = 0.37,
        Callback = function(Value)
            LERP_SPEED = Value
        end,
    })

    RightGroup:AddToggle("Aiming", {
        Text = "Aiming",
        Tooltip = "If off, backstab logic will NOT rotate or move your character (applies to all backstab types).",
        Default = true,
        Callback = function(Value)
            aimingEnabled = Value
        end,
    })

    RightGroup:AddInput("DelayStab", {
        Text = "Delay Before Dagger",
        Default = 0.08,
        Numeric = true,
        ClearTextOnFocus = false,
        Placeholder = 0.08,
        Callback = function(Value)
            DELAY_BEFORE_STAB = Value
        end,
    })

    -- Prediction UI (put this where you build the rest of the UI, e.g. under Tabs.Prediction)
    PredictionLeftGroup:AddToggle("EnablePrediction", {
        Text = "Enable Prediction",
        Tooltip = "Predict killer movement (left/right/forward). Applies to lerp and teleport.",
        Default = false,
        Callback = function(Value)
            predictionEnabled = Value
        end,
    })

    PredictionLeftGroup:AddInput("PredictionStrength", {
        Text = "Prediction Strength",
        Tooltip = "How strong prediction is (0 = off, 1 = default). Tweak to taste.",
        Default = tostring(PREDICTION_STRENGTH),
        Numeric = true,
        ClearTextOnFocus = false,
        Callback = function(Value)
            PREDICTION_STRENGTH = tonumber(Value) or PREDICTION_STRENGTH
        end,
    })

    PredictionLeftGroup:AddInput("PredictionTime", {
        Text = "Prediction Time (s)",
        Tooltip = "How far ahead (seconds) to use velocity for prediction.",
        Default = tostring(PREDICTION_TIME),
        Numeric = true,
        ClearTextOnFocus = false,
        Callback = function(Value)
            PREDICTION_TIME = tonumber(Value) or PREDICTION_TIME
        end,
    })

    TechLeftGroup:AddLabel("Glide stab")

    TechLeftGroup:AddToggle("GlideStab", {
        Text = "GlideStab",
        Tooltip = "search on yt",
        Default = false,
        Callback = function(Value)
            glidestabEnabled = Value
        end,
    })

    -- Add UI toggle (place after AimingMode dropdown)
    TechLeftGroup:AddToggle("GlideStabAssist", {
        Text = "aim at killers side",
        Tooltip = "aims at killer's side when crouch stabbing",
        Default = false,
        Callback = function(Value)
            glidestabAssistEnabled = Value
       end,
    })

    -- Tech: GlideStab Type dropdown
    TechLeftGroup:AddDropdown("GlideStabType", {
        Values = { "Legit", "Teleport" },
        Default = 1,
        Multi = false,
        Text = "Type",
        Tooltip = "Legit = normal glidestab. Teleport = when beside killer, teleport BEHIND_DISTANCE studs behind them for the duration.",
        Callback = function(Value)
            GLIDESTAB_TYPE = Value
        end,
    })

    TechLeftGroup:AddDropdown("AimingMode", {
        Values = { "Character", "Camera" },
        Default = 1,
        Multi = false,
        Text = "Aiming Mode (only for glidestab)",
        Tooltip = "Character = rotate your character. Camera = rotate the camera to look at the killer.",
        Callback = function(Value)
            aimingMode = Value
        end,
    })

    CustomAnimLeftGroup:AddLabel("Inject Anims before a round starts")

    -- helper: try to require the module safely (returns ok, module)
    local function tryRequireTwoTime()
        if not TwoTimeModulePath then
            -- try to find it lazily (in case it wasn't present at startup)
            local okPath, found = pcall(function()
                return ReplicatedStorage:FindFirstChild("Assets")
                    and ReplicatedStorage.Assets:FindFirstChild("Survivors")
                    and ReplicatedStorage.Assets.Survivors:FindFirstChild("TwoTime")
                    and ReplicatedStorage.Assets.Survivors.TwoTime:FindFirstChild("Config")
            end)
            if okPath and found then
                TwoTimeModulePath = found
            end
        end
        if not TwoTimeModulePath then
            return false, "module not found"
        end
        local ok, mod = pcall(function() return require(TwoTimeModulePath) end)
        if not ok then
            return false, mod
        end
        if type(mod) ~= "table" then
            return false, "module not a table"
        end
        return true, mod
    end

    -- prefill textboxes with current module values when possible
    local initialModuleAnims = {}
    do
        local ok, modOrErr = tryRequireTwoTime()
        if ok and modOrErr and type(modOrErr.Animations) == "table" then
            for _, k in ipairs(animKeys) do
                initialModuleAnims[k] = tostring(modOrErr.Animations[k] or "")
            end
        else
            for _, k in ipairs(animKeys) do initialModuleAnims[k] = "" end
        end
    end

    -- create inputs (unique keys)
    for _, key in ipairs(animKeys) do
        local optionKey = "TwoTimeAnim_" .. key
        CustomAnimLeftGroup:AddInput(optionKey, {
            Text = key,
            Default = initialModuleAnims[key] or "",
            Numeric = false,
            ClearTextOnFocus = false,
            Placeholder = "rbxassetid://12345678901234  (or numeric id)",
            Callback = function(Value)
                TwoTimeAnimInputs[key] = tostring(Value or "")
            end,
        })

        -- if the library exposes Options, wire OnChanged to keep local copy updated
        if ui_refs and ui_refs.Options and ui_refs.Options[optionKey] then
            ui_refs.Options[optionKey]:OnChanged(function()
            TwoTimeAnimInputs[key] = tostring(ui_refs.Options[optionKey].Value or "")
            end)
        else
            -- initialize local table from Default
            TwoTimeAnimInputs[key] = initialModuleAnims[key] or ""
        end
    end

    -- helper: apply textbox values into module.Animations (only non-empty inputs overwrite)
    local function applyAnimInputsToModule(mod)
        mod = mod or {}
        mod.Animations = mod.Animations or {}
        for _, k in ipairs(animKeys) do
            local v = TwoTimeAnimInputs[k]
            if v ~= nil and tostring(v) ~= "" then
                mod.Animations[k] = tostring(v)
            end
        end
    end

    -- background "constant require" loop (runs while toggle enabled)
    local function startInjectLoop()
        task.spawn(function()
            while injectAnimsEnabled do
                local ok, modOrErr = tryRequireTwoTime()
                if ok then
                    -- apply user inputs
                    pcall(function() applyAnimInputsToModule(modOrErr) end)
                end
                -- frequency: 1 second. change to smaller number if you truly want faster re-require.
                task.wait(1)
            end
        end)
    end

    -- restore the saved initial module animation IDs
    local function restoreOriginalAnimsInModule()
        local ok, modOrErr = tryRequireTwoTime()
        if not ok then
            return false, modOrErr
        end

        pcall(function()
            modOrErr.Animations = modOrErr.Animations or {}
            for _, k in ipairs(animKeys) do
                local orig = initialModuleAnims[k]
                if orig ~= nil and tostring(orig) ~= "" then
                    modOrErr.Animations[k] = tostring(orig)
                else
                    -- remove the key if original was empty so module falls back to its default
                    modOrErr.Animations[k] = nil
                end
            end
        end)

        return true
    end

    -- Toggle to enable continuous inject behavior
    CustomAnimLeftGroup:AddToggle("InjectAnimsToggle", {
        Text = "Inject Anims",
        Tooltip = "When ON: periodically requires TwoTime.Config and injects the animation IDs you typed above.",
        Default = false,
        Callback = function(Value)
            injectAnimsEnabled = Value
            if Value then
                startInjectLoop()
            else
                -- restore original anims when turned off
                local ok, err = restoreOriginalAnimsInModule()
                local StarterGui = game:GetService("StarterGui")
                if ok then
                    StarterGui:SetCore("SendNotification", {
                        Title = "Inject Anims",
                        Text = "Restored original TwoTime animation IDs.",
                        Duration = 3
                    })
                else
                    StarterGui:SetCore("SendNotification", {
                        Title = "Inject Anims",
                        Text = "Failed to restore original IDs: " .. tostring(err),
                        Duration = 3
                    })
                end
            end
        end,
    })

    MiscLeftGroup:AddButton("c00lgui (custom stamina and esp)", function()
        loadstring(game:HttpGet("https://rawscripts.net/raw/Forsaken-c00lgui-v15-ESP-EDITABLE-STAMINA-41624"))()
    end)

    -- Toggle: Auto Backstab

    -- Expose Options & Toggles for runtime access (library puts them in global)
    Options = Library.Options
    Toggles = Library.Toggles

    -- Ensure local variables reflect initial UI state
    if Toggles and Toggles.AutoBackstab then enabled = Toggles.AutoBackstab.Value end
    if Toggles and Toggles.AutoDagger then daggerenabled = Toggles.AutoDagger.Value end
    if Options and Options.RangeInput then
        local v = tonumber(Options.RangeInput.Value) or DEFAULT_PROXIMITY
        -- nothing to store; watcher will read Options.RangeInput.Value directly
    end

    -- Wiring: prefer :OnChanged where available (recommended by Example.lua)
    if Toggles and Toggles.AutoBackstab then
        Toggles.AutoBackstab:OnChanged(function()
            enabled = Toggles.AutoBackstab.Value
        end)
    end
    if Toggles and Toggles.AutoDagger then
        Toggles.AutoDagger:OnChanged(function()
            daggerenabled = Toggles.AutoDagger.Value
        end)
    end
    if Options and Options.RangeInput then
        Options.RangeInput:OnChanged(function()
            -- keep rangeMode reading from Options.RangeInput.Value in watcher
        end)
    end
    if Options and Options.RangeMode then
        -- Note: AddDropdown created an Options entry for the dropdown; the callback already updates rangeMode
        Options.RangeMode:OnChanged(function()
            rangeMode = Options.RangeMode.Value
        end)
    end
    if Options and Options.LerpSpeed then
        -- Note: AddDropdown created an Options entry for the dropdown; the callback already updates rangeMode
        Options.LerpSpeed:OnChanged(function()
            LERP_SPEED = Options.LerpSpeed.Value
        end)
    end
    if Options and Options.BehindDistance then
        -- Note: AddDropdown created an Options entry for the dropdown; the callback already updates rangeMode
        Options.BehindDistance:OnChanged(function()
            BEHIND_DISTANCE = Options.BehindDistance.Value
        end)
    end
    if Options and Options.BackstabType then
        Options.BackstabType:OnChanged(function()
            BACKSTAB_TYPE = Options.BackstabType.Value
            if BACKSTAB_TYPE == "Lerp" then
                Options.LerpSpeed.Visible = true
            else
                Options.LerpSpeed.Visible = false
            end
        end)
    end


    -- Wire up Options if the library exposed them later (keeps behavior consistent with the rest of UI code)
    if Options and Options.PredictionStrength then
        Options.PredictionStrength:OnChanged(function()
            PREDICTION_STRENGTH = Options.PredictionStrength.Value
        end)
    end
    if Options and Options.PredictionTime then
        Options.PredictionTime:OnChanged(function()
            PREDICTION_TIME = Options.PredictionTime.Value
        end)
    end
    if Toggles and Toggles.EnablePrediction then
        Toggles.EnablePrediction:OnChanged(function()
            predictionEnabled = Toggles.EnablePrediction.Value
        end)
    end

    -- store refs for external access/debugging
    ui_refs.Library = Library
    ui_refs.Window = Window
    ui_refs.Options = Options
    ui_refs.Toggles = Toggles
end

local MenuGroup = Tabs["UI Settings"]:AddLeftGroupbox("Setting", "wrench")

MenuGroup:AddToggle("KeybindMenuOpen", {
	Default = Library.KeybindFrame.Visible,
	Text = "Open Keybind Menu",
	Callback = function(value)
		Library.KeybindFrame.Visible = value
	end,
})
MenuGroup:AddToggle("ShowCustomCursor", {
	Text = "Custom Cursor",
	Default = true,
	Callback = function(Value)
		Library.ShowCustomCursor = Value
	end,
})
MenuGroup:AddDropdown("NotificationSide", {
	Values = { "Left", "Right" },
	Default = "Right",
	Text = "Notification Side",
	Callback = function(Value)
		Library:SetNotifySide(Value)
	end,
})
MenuGroup:AddDropdown("DPIDropdown", {
	Values = { "50%", "75%", "100%", "125%", "150%", "175%", "200%" },
	Default = "100%",

	Text = "DPI Scale",

	Callback = function(Value)
		Value = Value:gsub("%%", "")
		local DPI = tonumber(Value)

		Library:SetDPIScale(DPI)
	end,
})
MenuGroup:AddDivider()
MenuGroup:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", { Default = "RightShift", NoUI = true, Text = "Menu keybind" })

MenuGroup:AddButton("unload script", function()
	Library:Unload()
end)

-- Fallback minimal UI if Library missing (keeps script usable)

-- Expose refs globally (compat)
_G.AutoBackstabUI = _G.AutoBackstabUI or {}
_G.AutoBackstabUI.refs = ui_refs

-- misc shit

-- ==================== Main watcher (unchanged) ====================
task.spawn(function()
    while true do
        task.wait(CHECK_INTERVAL)
        if not enabled then
            -- skip
        else
            local range = DEFAULT_PROXIMITY
            -- read from Obsidian Options if available
            if ui_refs.Options and ui_refs.Options.RangeInput and ui_refs.Options.RangeInput.Value ~= nil then
                range = tonumber(ui_refs.Options.RangeInput.Value) or DEFAULT_PROXIMITY
            end
            local daggerbtn = getDaggerButton()
            local duration = DEFAULT_DURATION
            local killersFolder = getKillersFolder()
            if not killersFolder then
                -- skip
            else
                local char = getCharacter()
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    for _, killer in pairs(killersFolder:GetChildren()) do
                        if isValidKillerModel(killer) then
                            local khrp = killer:FindFirstChild("HumanoidRootPart")
                            if khrp then
                                local dist = (khrp.Position - hrp.Position).Magnitude

                                local shouldTrigger = false
                                if rangeMode == "Around" then
                                    if dist <= range then
                                        shouldTrigger = true
                                    end
                                else -- "Behind" mode
                                    local relative = hrp.Position - khrp.Position
                                    local forwardDot = relative:Dot(khrp.CFrame.LookVector)        -- projection distance along killer forward
                                    local behindDist = -forwardDot                                -- positive when player is behind
                                    local angleDot = 0
                                    if relative.Magnitude > 0 then
                                        angleDot = (relative.Unit):Dot(khrp.CFrame.LookVector)    -- normalized dot: -1 = directly behind
                                    end

                                    -- thresholds (tweak these to taste)
                                    local permissiveThreshold = 0.3       -- original loose threshold (keeps old behaviour)
                                    local strictAngleThreshold = -0.85    -- strict: must be roughly within ~30° behind (dot <= -0.85)

                                    local passesDotCheck = false
                                    if directbehind then
                                        -- strict: use normalized dot (angle) so user must be nearly directly behind
                                        if angleDot <= strictAngleThreshold then
                                            passesDotCheck = true
                                        end
                                    else
                                        -- permissive: keep legacy behavior
                                        if forwardDot < permissiveThreshold then
                                            passesDotCheck = true
                                        end
                                    end

                                    if passesDotCheck and behindDist <= range and dist <= range then
                                        if isPlayerCharacter(killer) then
                                            shouldTrigger = true
                                        end
                                    end
                                end

                                if shouldTrigger then
                                    if os.clock() - lastTrigger >= COOLDOWN then
                                        lastTrigger = os.clock()
                                        
                                        local cooldowndagger = getDaggerCooldown()
                                        local cdNum = readCooldownValue(cooldowndagger)
                                        
                                        if cdNum and cdNum > 0.1 then
                                            -- still cooling down; skip this killer
                                        else
                                            task.spawn(function()
                                                activateForKiller(killer, duration)
                                                if daggerenabled then
                                                    task.wait(DELAY_BEFORE_STAB)
                                                    tryActivateButton(daggerbtn)
                                                end
                                            end)
                                        end
                                    end
                                    break
                                end
                            end
                        end
                    end
                end
            end
        end
    end
end)



-- techs watcher
-- techs watcher (GlideStab) — updated to support GLIDESTAB_TYPE ("Legit" or "Teleport")
task.spawn(function()
    while true do
        task.wait(GLIDESTAB_CHECK_RATE or 0.06)

        if not glidestabEnabled then
            continue
        end

        -- cooldown guard (uses your existing timestamp)
        if glidestabLastTime and (os.clock() - glidestabLastTime) < (GLIDESTAB_COOLDOWN or 3) then
            continue
        end

        local char = getCharacter()
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local humanoid = char and char:FindFirstChildWhichIsA("Humanoid")
        if not hrp or not humanoid then
            continue
        end

        -- only run when player is playing the configured glide/stab anim
        if not isPlayingTargetAnim(char) then
            continue
        end

        local killersFolder = getKillersFolder()
        if not killersFolder then
            continue
        end

        -- read detection range from UI if present, else default
        local range = DEFAULT_PROXIMITY
        if ui_refs and ui_refs.Options and ui_refs.Options.RangeInput and ui_refs.Options.RangeInput.Value then
            range = tonumber(ui_refs.Options.RangeInput.Value) or range
        end

        -- find a candidate killer using the same approach you already use:
        local candidate = nil
        for _, killer in pairs(killersFolder:GetChildren()) do
            if isValidKillerModel(killer) then
                local khrp = killer:FindFirstChild("HumanoidRootPart")
                if khrp then
                    local dist = (khrp.Position - hrp.Position).Magnitude
                    if dist <= range then
                        -- wait briefly until we become beside (or timeout)
                        local t0 = os.clock()
                        local foundBeside = false
                        while os.clock() - t0 < (GLIDESTAB_BESIDE_TIMEOUT or 1) do
                            if isBesideKiller(hrp, khrp, range) then
                                foundBeside = true
                                break
                            end
                            task.wait(0.05)
                        end
                        if foundBeside then
                            candidate = killer
                            break
                        end
                    end
                end
            end
        end

        if not candidate then
            continue
        end

        local khrp = candidate:FindFirstChild("HumanoidRootPart")
        if not khrp then
            continue
        end

        -- prepare for the sequence
        local daggerbtn = getDaggerButton()
        local tstart = os.clock()

        -- backup autorotate / camera state so we can restore later
        local prevAutoRotate = nil
        pcall(function() prevAutoRotate = humanoid.AutoRotate end)

        local useMode = (typeof(aimingMode) == "string" and aimingMode) or "Character"
        local cam = workspace.CurrentCamera
        local prevCamCFrame = nil
        if useMode == "Camera" and cam then
            prevCamCFrame = cam.CFrame
        end

        -- mark cooldown timestamp immediately (prevents re-entry)
        glidestabLastTime = os.clock()

        local duration = GLIDESTAB_DURATION or 0.4

        if GLIDESTAB_TYPE == "Teleport" then
            -- Teleport mode: repeatedly teleport you BEHIND_DISTANCE studs behind the killer for duration
            local endTime = os.clock() + duration
            while os.clock() < endTime do
                -- safety checks
                if not hrp or not khrp then break end

                -- ensure we're still beside (so teleport only occurs while beside)

                -- compute behind position and preserve player's Y to avoid vertical snap
                local lookVec = (khrp.CFrame and khrp.CFrame.LookVector) and khrp.CFrame.LookVector.Unit or (khrp.Position - hrp.Position).Unit
                local behindDistance = (BEHIND_DISTANCE and tonumber(BEHIND_DISTANCE)) or 1.7
                local behindPos = khrp.Position - (lookVec * behindDistance)
                local targetPos = Vector3.new(behindPos.X, hrp.Position.Y, behindPos.Z)

                -- face same forward as killer (so you remain behind them)
                local goalCF = CFrame.new(targetPos, targetPos + lookVec)

                pcall(function()
                    hrp.CFrame = goalCF
                end)

                -- attempt dagger each tick (uses your helper)
                pcall(function()
                    tryActivateButton(daggerbtn)
                end)

                task.wait(0.03) -- teleport tick (adjust if desired)
            end

        else
            -- "Legit" (existing) mode: rotate / camera-look + dagger attempts
            local endTime = os.clock() + duration

            -- disable autorotate only when rotating the character (matches doGlidestabAssist pattern)
            if useMode == "Character" then
                pcall(function() humanoid.AutoRotate = false end)
            end

            while os.clock() < endTime do
                if not hrp or not khrp then break end

                -- stop early if we somehow lost the beside condition
                if not isBesideKiller(hrp, khrp, range) then
                    break
                end

                if useMode == "Character" then
                    pcall(function()
                        local curPos = hrp.Position
                        local targetCF = CFrame.new(curPos, khrp.Position)
                        hrp.CFrame = CFrame.new(targetCF.Position, targetCF.Position + targetCF.LookVector)
                    end)
                else
                    if cam and khrp then
                        pcall(function()
                            local camPos = cam.CFrame.Position
                            cam.CFrame = CFrame.new(camPos, khrp.Position)
                        end)
                    end
                end

                -- attempt dagger
                pcall(function()
                    tryActivateButton(daggerbtn)
                end)

                task.wait(0.06)
            end
        end

        -- restore autorotate / camera state
        if useMode == "Character" then
            pcall(function()
                if humanoid then
                    if prevAutoRotate ~= nil then
                        humanoid.AutoRotate = prevAutoRotate
                    else
                        humanoid.AutoRotate = true
                    end
                end
            end)
        else
            if prevCamCFrame and workspace.CurrentCamera then
                pcall(function()
                    workspace.CurrentCamera.CFrame = prevCamCFrame
                end)
            end
        end

        -- tiny safety wait to avoid immediate re-trigger loops
        task.wait(0.03)
    end
end)

task.spawn(function()
    while true do
        task.wait(GLIDESTAB_ASSIST_CHECK_RATE or 0.03)

        if not glidestabAssistEnabled then
            glidestabAssistPrevPlaying = false
            continue
        end

        local char = getCharacter()
        local humanoid = char and char:FindFirstChildWhichIsA("Humanoid")
        if not char or not humanoid then
            glidestabAssistPrevPlaying = false
            continue
        end

        local playing = isPlayingTargetAnim(char)
        -- trigger when it goes from not-playing -> playing
        if playing and not glidestabAssistPrevPlaying then
            local killersFolder = getKillersFolder()
            if killersFolder then
                local hrp = char:FindFirstChild("HumanoidRootPart")
                local candidate = nil

                -- try calling the helper without a range argument (if it's optional)
                local ok, result = pcall(findCandidateKillerForAssist, killersFolder, hrp)
                if ok and result then
                    candidate = result
                else
                    -- fallback: try with a very large range so range check effectively never blocks
                    ok, result = pcall(findCandidateKillerForAssist, killersFolder, hrp, math.huge)
                    if ok and result then
                        candidate = result
                    else
                        -- final fallback: pick the first valid killer model found in the folder
                        for _, k in ipairs(killersFolder:GetChildren()) do
                            if k and k:IsA("Model") then
                                local khrp = k:FindFirstChild("HumanoidRootPart") or k:FindFirstChild("UpperTorso") or k:FindFirstChild("Torso")
                                local khum = k:FindFirstChildWhichIsA("Humanoid")
                                if khrp and khum and (khum.Health == nil or khum.Health > 0) then
                                    candidate = k
                                    break
                                end
                            end
                        end
                    end
                end

                if candidate then
                    task.spawn(function()
                        pcall(function() doGlidestabAssist(candidate) end)
                    end)
                end
            end
        end

        glidestabAssistPrevPlaying = playing
    end
end)

Library.ToggleKeybind = Options.MenuKeybind
ThemeManager:SetLibrary(Library)
SaveManager:SetLibrary(Library)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
ThemeManager:SetFolder("autobackstab")
SaveManager:SetFolder("autobackshot/games")
SaveManager:SetSubFolder("Forsaken")
SaveManager:BuildConfigSection(Tabs["UI Settings"])
ThemeManager:ApplyToTab(Tabs["UI Settings"])
SaveManager:LoadAutoloadConfig() 
