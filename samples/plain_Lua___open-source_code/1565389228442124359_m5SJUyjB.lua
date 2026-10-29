local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local player  = Players.LocalPlayer
local camera  = workspace.CurrentCamera

local torsoName  = "Head"
local maxRadius  = 30
local OFFSET_X   = 0
local OFFSET_Y   = 0.1
local OFFSET_Z   = 1.5
local RAND_Y_MIN = -1
local RAND_Y_MAX = 0.1

local FOV_RADIUS = 150

local DEBUG = false
local function log(msg)   if DEBUG then print("[AimArm] " .. tostring(msg)) end end
local function warn_(msg) if DEBUG then warn("[AimArm] "  .. tostring(msg)) end end

-- ══════════════════════════════════════════
--               SHARED STATE
-- ══════════════════════════════════════════
local scriptEnabled    = true
local randomizeY       = false
local useFOV           = true
local pvpOnly          = true   -- skip non-pvp players when true
local currentESPTarget = nil
local lockedTarget     = nil

-- NEW MODE STATE
local currentMode      = 1      -- 1 = Aim Arm, 2 = Giant HRP
local excludeFriends   = true   -- Toggle to ignore friends in Giant mode
local originalSizes    = {}     -- Stores original HRP sizes for restoration

-- Prediction state
local predVelocity   = Vector3.zero
local prevTargetPos  = nil
local prevTargetTime = nil
local lastTargetRef  = nil
local PRED_MULTS     = {0, 0.5, 1.0, 1.5, 2.0}
local predMultIdx    = 3
local PRED_MULT      = PRED_MULTS[predMultIdx]

-- Max radius presets
local RADIUS_PRESETS = {10, 20, 30, 50, 75, 100}
local radiusIdx      = 3   -- default = 30 (matches original maxRadius)

-- Exposed so toggle can restore/disable constraints mid-loop
local _char          = nil
local _torso         = nil
local _rightArm      = nil
local _rightShoulder = nil
local _rope          = nil

-- ══════════════════════════════════════════
--               PVP HELPERS
-- ══════════════════════════════════════════
local function getPvpState(targetPart)
    if not targetPart or not targetPart.Parent then return nil end
    local charModel = targetPart.Parent

    local targetPlayer = Players:GetPlayerFromCharacter(charModel)
    if not targetPlayer then return nil end

    local valuesFolder = targetPlayer:FindFirstChild("Values")
    if not valuesFolder then return false end
    local pvpVal = valuesFolder:FindFirstChild("Pvp")
    if not pvpVal then return false end
    return pvpVal.Value == true
end

local function pvpColor(state)
    if state == true  then return Color3.fromRGB(80,  255, 120) end
    if state == false then return Color3.fromRGB(255, 60,  60)  end
    return Color3.fromRGB(255, 220, 60)
end

-- ══════════════════════════════════════════
--               GUI
-- ══════════════════════════════════════════
local screenGui = Instance.new("ScreenGui")
screenGui.Name           = "AimArmHUD"
screenGui.ResetOnSpawn   = false
screenGui.IgnoreGuiInset = true
screenGui.Parent         = game.CoreGui

-- Height increased to fit the 2 new buttons
local frame = Instance.new("Frame")
frame.Size             = UDim2.new(0, 220, 0, 423) 
frame.Position         = UDim2.new(0, 16, 0.5, -30)
frame.BackgroundColor3 = Color3.fromRGB(10, 10, 15)
frame.BorderSizePixel  = 0
frame.Parent           = screenGui

local function uiCorner(parent, r)
    local c = Instance.new("UICorner")
    c.CornerRadius = UDim.new(0, r or 8)
    c.Parent = parent
end
uiCorner(frame)

local accent = Instance.new("Frame")
accent.Size             = UDim2.new(0, 3, 1, 0)
accent.BackgroundColor3 = Color3.fromRGB(255, 60, 60)
accent.BorderSizePixel  = 0
accent.Parent           = frame
uiCorner(accent)

local title = Instance.new("TextLabel")
title.Size                   = UDim2.new(1, -12, 0, 20)
title.Position               = UDim2.new(0, 12, 0, 8)
title.BackgroundTransparency = 1
title.Text                   = "AIM ARM / GIANT"
title.TextColor3             = Color3.fromRGB(255, 60, 60)
title.TextXAlignment         = Enum.TextXAlignment.Left
title.Font                   = Enum.Font.GothamBold
title.TextSize               = 11
title.Parent                 = frame

local function makeLabel(y)
    local lbl = Instance.new("TextLabel")
    lbl.Size                   = UDim2.new(1, -12, 0, 16)
    lbl.Position               = UDim2.new(0, 12, 0, y)
    lbl.BackgroundTransparency = 1
    lbl.TextColor3             = Color3.fromRGB(200, 200, 200)
    lbl.TextXAlignment         = Enum.TextXAlignment.Left
    lbl.Font                   = Enum.Font.Gotham
    lbl.TextSize               = 11
    lbl.Parent                 = frame
    return lbl
end

local lblStatus  = makeLabel(32)
local lblTarget  = makeLabel(52)
local lblDist    = makeLabel(72)
local lblRagdoll = makeLabel(92)
local lblFrames  = makeLabel(112)
local lblLock    = makeLabel(132)
local lblPing    = makeLabel(152)
local lblPred    = makeLabel(172)
local lblPvpInfo = makeLabel(192)

local function makeToggleBtn(y)
    local btn = Instance.new("TextButton")
    btn.Size             = UDim2.new(1, -20, 0, 22)
    btn.Position         = UDim2.new(0, 10, 0, y)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    btn.BorderSizePixel  = 0
    btn.Font             = Enum.Font.GothamBold
    btn.TextSize         = 11
    btn.AutoButtonColor  = false
    btn.Parent           = frame
    uiCorner(btn, 6)

    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 0.1
    stroke.Parent    = btn

    btn.MouseEnter:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(45, 45, 60) end)
    btn.MouseLeave:Connect(function() btn.BackgroundColor3 = Color3.fromRGB(30, 30, 40) end)

    return btn, stroke
end

-- Shifted buttons down to make room for the 2 new ones
local toggleModeBtn,    toggleModeStroke    = makeToggleBtn(212)
local toggleFriendsBtn, toggleFriendsStroke = makeToggleBtn(239)
local togglePvpBtn,     togglePvpStroke     = makeToggleBtn(266)
local toggleFOVBtn,     toggleFOVStroke     = makeToggleBtn(293)
local toggleYBtn,       toggleYStroke       = makeToggleBtn(320)
local toggleRadiusBtn,  toggleRadiusStroke  = makeToggleBtn(347)
local toggleEnBtn,      toggleEnStroke      = makeToggleBtn(374)

local hintLbl = Instance.new("TextLabel")
hintLbl.Size                   = UDim2.new(1, -12, 0, 14)
hintLbl.Position               = UDim2.new(0, 12, 0, 401)
hintLbl.BackgroundTransparency = 1
hintLbl.Text                   = "F4·fr F5·mode F6·tog F7·y F8·pred F9·fov F10·pvp F11·rad MW·lock"
hintLbl.TextColor3             = Color3.fromRGB(70, 70, 90)
hintLbl.TextXAlignment         = Enum.TextXAlignment.Left
hintLbl.Font                   = Enum.Font.Gotham
hintLbl.TextSize               = 9
hintLbl.Parent                 = frame

-- ══════════════════════════════════════════
--               ESP
-- ══════════════════════════════════════════
local espBall = Instance.new("Frame")
espBall.Size             = UDim2.new(0, 10, 0, 10)
espBall.AnchorPoint      = Vector2.new(0.5, 0.5)
espBall.BackgroundColor3 = Color3.fromRGB(200, 200, 200)
espBall.BorderSizePixel  = 0
espBall.Visible          = false
espBall.ZIndex           = 10
espBall.Parent           = screenGui
uiCorner(espBall, 5)

local espBallStroke = Instance.new("UIStroke")
espBallStroke.Color     = Color3.fromRGB(0, 0, 0)
espBallStroke.Thickness = 1.2
espBallStroke.Parent    = espBall

local espName = Instance.new("TextLabel")
espName.Size                   = UDim2.new(0, 140, 0, 14)
espName.AnchorPoint            = Vector2.new(0.5, 1)
espName.BackgroundTransparency = 1
espName.TextColor3             = Color3.fromRGB(255, 60, 60)
espName.Font                   = Enum.Font.GothamBold
espName.TextSize               = 10
espName.Visible                = false
espName.ZIndex                 = 10
espName.Parent                 = screenGui

local espPvpTag = Instance.new("TextLabel")
espPvpTag.Size                   = UDim2.new(0, 80, 0, 12)
espPvpTag.AnchorPoint            = Vector2.new(0.5, 0)
espPvpTag.BackgroundTransparency = 1
espPvpTag.Font                   = Enum.Font.GothamBold
espPvpTag.TextSize               = 9
espPvpTag.Visible                = false
espPvpTag.ZIndex                 = 10
espPvpTag.Parent                 = screenGui

local lockRing = Instance.new("Frame")
lockRing.Size                   = UDim2.new(0, 22, 0, 22)
lockRing.AnchorPoint            = Vector2.new(0.5, 0.5)
lockRing.BackgroundTransparency = 1
lockRing.BorderSizePixel        = 0
lockRing.Visible                = false
lockRing.ZIndex                 = 11
lockRing.Parent                 = screenGui
uiCorner(lockRing, 11)

local lockRingStroke = Instance.new("UIStroke")
lockRingStroke.Color     = Color3.fromRGB(255, 220, 0)
lockRingStroke.Thickness = 2
lockRingStroke.Parent    = lockRing

local fovCircle = Instance.new("Frame")
fovCircle.Size                   = UDim2.new(0, FOV_RADIUS * 2, 0, FOV_RADIUS * 2)
fovCircle.AnchorPoint            = Vector2.new(0.5, 0.5)
fovCircle.BackgroundTransparency = 1
fovCircle.BorderSizePixel        = 0
fovCircle.Visible                = false
fovCircle.ZIndex                 = 9
fovCircle.Parent                 = screenGui
uiCorner(fovCircle, FOV_RADIUS)

local fovStroke = Instance.new("UIStroke")
fovStroke.Thickness    = 1
fovStroke.Transparency = 0.35
fovStroke.Parent       = fovCircle

-- ══════════════════════════════════════════
--           CONSTRAINT HELPERS
-- ══════════════════════════════════════════
local function disableArmConstraints(char, torso)
    local rightShoulder = torso:WaitForChild("Right Shoulder", 5)
    if rightShoulder then rightShoulder.Enabled = false else warn_("Right Shoulder not found") end

    local constraintsFolder = char:WaitForChild("Constraints", 5)
    local rope = constraintsFolder and constraintsFolder:FindFirstChild("Right Arm Rope")
    if rope then rope.Enabled = false else warn_("Right Arm Rope not found") end

    return rightShoulder, rope
end

local function restoreArmConstraints(char, rightShoulder, rope)
    if rightShoulder then
        local isRagdoll = char:FindFirstChild("IsRagdoll")
        rightShoulder.Enabled = not (isRagdoll and isRagdoll.Value)
    end
    if rope then rope.Enabled = true end
end

-- ══════════════════════════════════════════
--           GIANT MODE HELPERS
-- ══════════════════════════════════════════
local function storeOriginalSize(plr)
    local char = plr.Character
    if char then
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp and not originalSizes[plr.UserId] then
            originalSizes[plr.UserId] = hrp.Size
        end
    end
end

local function applyGiantMode()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr == player then continue end
        if excludeFriends and player:IsFriendsWith(plr.UserId) then continue end
        
        local char = plr.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                storeOriginalSize(plr)
                local targetSize = Vector3.new(maxRadius, maxRadius, maxRadius)
                if hrp.Size ~= targetSize then
                    hrp.Size = targetSize
                    hrp.Transparency = 0.5
                end
            end
        end
    end
end

local function restoreGiantMode()
    for _, plr in ipairs(Players:GetPlayers()) do
        local char = plr.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and originalSizes[plr.UserId] then
                hrp.Size = originalSizes[plr.UserId]
            end
        end
    end
end

-- ══════════════════════════════════════════
--           REFRESH HELPERS
-- ══════════════════════════════════════════
local function refreshLockLabel()
    if lockedTarget and lockedTarget.Parent then
        lblLock.Text       = "LOCK:    " .. lockedTarget.Parent.Name
        lblLock.TextColor3 = Color3.fromRGB(255, 220, 0)
    else
        lblLock.Text       = "LOCK:    none"
        lblLock.TextColor3 = Color3.fromRGB(200, 200, 200)
    end
end

local function refreshModeBtn()
    if currentMode == 1 then
        toggleModeBtn.Text       = "MODE:  AIM ARM  [F5]"
        toggleModeBtn.TextColor3 = Color3.fromRGB(80, 200, 255)
        toggleModeStroke.Color   = Color3.fromRGB(80, 200, 255)
    else
        toggleModeBtn.Text       = "MODE:  GIANT HRP  [F5]"
        toggleModeBtn.TextColor3 = Color3.fromRGB(255, 100, 255)
        toggleModeStroke.Color   = Color3.fromRGB(255, 100, 255)
    end
end

local function refreshFriendsBtn()
    if excludeFriends then
        toggleFriendsBtn.Text       = "EXCL FRIENDS:  ON  [F4]"
        toggleFriendsBtn.TextColor3 = Color3.fromRGB(80, 255, 120)
        toggleFriendsStroke.Color   = Color3.fromRGB(80, 255, 120)
    else
        toggleFriendsBtn.Text       = "EXCL FRIENDS:  OFF  [F4]"
        toggleFriendsBtn.TextColor3 = Color3.fromRGB(255, 120, 60)
        toggleFriendsStroke.Color   = Color3.fromRGB(255, 120, 60)
    end
end

local function refreshYBtn()
    if randomizeY then
        toggleYBtn.Text       = "Y OFFSET:  RANDOM  [F7]"
        toggleYBtn.TextColor3 = Color3.fromRGB(255, 200, 60)
        toggleYStroke.Color   = Color3.fromRGB(255, 200, 60)
    else
        toggleYBtn.Text       = "Y OFFSET:  FIXED  [F7]"
        toggleYBtn.TextColor3 = Color3.fromRGB(80, 200, 255)
        toggleYStroke.Color   = Color3.fromRGB(80, 200, 255)
    end
end

local function refreshEnBtn()
    if scriptEnabled then
        toggleEnBtn.Text       = "SCRIPT:  ENABLED  [F6]"
        toggleEnBtn.TextColor3 = Color3.fromRGB(80, 255, 120)
        toggleEnStroke.Color   = Color3.fromRGB(80, 255, 120)
    else
        toggleEnBtn.Text       = "SCRIPT:  DISABLED  [F6]"
        toggleEnBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
        toggleEnStroke.Color   = Color3.fromRGB(255, 80, 80)
    end
end

local function refreshFOVBtn()
    if useFOV then
        toggleFOVBtn.Text       = string.format("FOV TARGET:  ON  [%dpx]  [F9]", FOV_RADIUS)
        toggleFOVBtn.TextColor3 = Color3.fromRGB(180, 100, 255)
        toggleFOVStroke.Color   = Color3.fromRGB(180, 100, 255)
    else
        toggleFOVBtn.Text       = "FOV TARGET:  OFF  (world)  [F9]"
        toggleFOVBtn.TextColor3 = Color3.fromRGB(120, 120, 140)
        toggleFOVStroke.Color   = Color3.fromRGB(120, 120, 140)
        fovCircle.Visible       = false
    end
end

local function refreshPvpBtn()
    if pvpOnly then
        togglePvpBtn.Text       = "PVP FILTER:  ON  (pvp only)  [F10]"
        togglePvpBtn.TextColor3 = Color3.fromRGB(80, 255, 120)
        togglePvpStroke.Color   = Color3.fromRGB(80, 255, 120)
    else
        togglePvpBtn.Text       = "PVP FILTER:  OFF  (all)  [F10]"
        togglePvpBtn.TextColor3 = Color3.fromRGB(255, 120, 60)
        togglePvpStroke.Color   = Color3.fromRGB(255, 120, 60)
    end
end

local function refreshPredLabel()
    local mult = PRED_MULTS[predMultIdx]
    if mult == 0 then
        lblPred.Text       = "PRED MULT:  OFF  [F8]"
        lblPred.TextColor3 = Color3.fromRGB(120, 120, 140)
    else
        lblPred.Text       = string.format("PRED MULT:  %.1fx  [F8]", mult)
        lblPred.TextColor3 = Color3.fromRGB(255, 180, 60)
    end
end

local function refreshRadiusBtn()
    toggleRadiusBtn.Text       = string.format("MAX RADIUS:  %d studs  [F11]", maxRadius)
    toggleRadiusBtn.TextColor3 = Color3.fromRGB(80, 200, 255)
    toggleRadiusStroke.Color   = Color3.fromRGB(80, 200, 255)
end

local function setStatus(active)
    lblStatus.Text       = "STATUS: " .. (active and "ACTIVE" or "INACTIVE")
    lblStatus.TextColor3 = active and Color3.fromRGB(80, 255, 120) or Color3.fromRGB(255, 80, 80)
end

local function updateGUI(target, dist, ragdoll, frames)
    lblTarget.Text  = "TARGET:  " .. (target or "none")
    lblDist.Text    = "DIST:    " .. (dist and string.format("%.1f studs", dist) or "—")
    lblRagdoll.Text = "RAGDOLL: " .. (ragdoll and "YES" or "NO")
    lblFrames.Text  = "FRAMES:  " .. tostring(frames)
end

refreshModeBtn()
refreshFriendsBtn()
refreshYBtn()
refreshEnBtn()
refreshFOVBtn()
refreshPvpBtn()
refreshPredLabel()
refreshRadiusBtn()
refreshLockLabel()
setStatus(false)
updateGUI(nil, nil, false, 0)
lblPing.Text     = "PING:    — ms"
lblPvpInfo.Text  = "PVP:     —"

-- ══════════════════════════════════════════
--           TOGGLE ACTIONS
-- ══════════════════════════════════════════
local function doToggleY()
    randomizeY = not randomizeY
    refreshYBtn()
end

local function doUnlock()
    lockedTarget = nil
    refreshLockLabel()
    log("lock released")
end

local function doToggleEnabled()
    scriptEnabled = not scriptEnabled
    refreshEnBtn()

    if not scriptEnabled then
        if _char and _rightArm then
            _rightArm.Anchored = false
            restoreArmConstraints(_char, _rightShoulder, _rope)
        end
        setStatus(false)
        espBall.Visible   = false
        espName.Visible   = false
        espPvpTag.Visible = false
        lockRing.Visible  = false
        fovCircle.Visible = false
        currentESPTarget  = nil
        doUnlock()
        restoreGiantMode() -- Restore sizes when disabled
    else
        if _char and _torso and _rightArm then
            if currentMode == 1 then
                _rightShoulder, _rope = disableArmConstraints(_char, _torso)
                _rightArm.Anchored   = true
            end
        end
    end
end

local function doToggleFOV()
    useFOV = not useFOV
    refreshFOVBtn()
end

local function doTogglePvpOnly()
    pvpOnly = not pvpOnly
    refreshPvpBtn()
    log("pvpOnly: " .. tostring(pvpOnly))
end

local function doCyclePred()
    predMultIdx = (predMultIdx % #PRED_MULTS) + 1
    PRED_MULT   = PRED_MULTS[predMultIdx]
    refreshPredLabel()
end

local function doCycleRadius()
    radiusIdx = (radiusIdx % #RADIUS_PRESETS) + 1
    maxRadius = RADIUS_PRESETS[radiusIdx]
    refreshRadiusBtn()
    log("maxRadius: " .. maxRadius)
end

local function doToggleMode()
    currentMode = currentMode == 1 and 2 or 1
    refreshModeBtn()
    
    if scriptEnabled and _char and _rightArm then
        if currentMode == 1 then
            restoreGiantMode()
            _rightShoulder, _rope = disableArmConstraints(_char, _torso)
            _rightArm.Anchored = true
        else
            _rightArm.Anchored = false
            restoreArmConstraints(_char, _rightShoulder, _rope)
        end
    end
    log("mode: " .. currentMode)
end

local function doToggleFriends()
    excludeFriends = not excludeFriends
    refreshFriendsBtn()
    log("excludeFriends: " .. tostring(excludeFriends))
end

local function doLockOnNearest()
    if currentESPTarget and currentESPTarget.Parent then
        if pvpOnly then
            local state = getPvpState(currentESPTarget)
            if state == false then
                log("refused lock — target not PVP")
                return
            end
        end
        lockedTarget = currentESPTarget
        refreshLockLabel()
        log("locked onto: " .. lockedTarget.Parent.Name)
    else
        log("no target to lock onto")
    end
end

toggleModeBtn.MouseButton1Click:Connect(doToggleMode)
toggleFriendsBtn.MouseButton1Click:Connect(doToggleFriends)
togglePvpBtn.MouseButton1Click:Connect(doTogglePvpOnly)
toggleFOVBtn.MouseButton1Click:Connect(doToggleFOV)
toggleYBtn.MouseButton1Click:Connect(doToggleY)
toggleRadiusBtn.MouseButton1Click:Connect(doCycleRadius)
toggleEnBtn.MouseButton1Click:Connect(doToggleEnabled)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if      input.KeyCode == Enum.KeyCode.F4  then doToggleFriends()
    elseif  input.KeyCode == Enum.KeyCode.F5  then doToggleMode()
    elseif  input.KeyCode == Enum.KeyCode.F6  then doToggleEnabled()
    elseif  input.KeyCode == Enum.KeyCode.F7  then doToggleY()
    elseif  input.KeyCode == Enum.KeyCode.F8  then doCyclePred()
    elseif  input.KeyCode == Enum.KeyCode.F9  then doToggleFOV()
    elseif  input.KeyCode == Enum.KeyCode.F10 then doTogglePvpOnly()
    elseif  input.KeyCode == Enum.KeyCode.F11 then doCycleRadius()
    elseif  input.UserInputType == Enum.UserInputType.MouseButton3 then
        if lockedTarget and lockedTarget.Parent then doUnlock() else doLockOnNearest() end
    end
end)

-- ══════════════════════════════════════════
--               CORE LOGIC
-- ══════════════════════════════════════════
local function getCharParts()
    local char     = player.Character or player.CharacterAdded:Wait()
    local torso    = char:WaitForChild("Torso",     10)
    local rightArm = char:WaitForChild("Right Arm", 10)
    return char, torso, rightArm
end

local function getTargetContainers()
    local containers = {}
    if workspace:FindFirstChild("Characters") then table.insert(containers, workspace.Characters) end
    if workspace:FindFirstChild("Dummies")    then table.insert(containers, workspace.Dummies)    end
    return containers
end

local function isTargetAlive(targetPart)
    if not targetPart or not targetPart.Parent then return false end
    local hum = targetPart.Parent:FindFirstChildOfClass("Humanoid")
    return not (hum and hum.Health <= 0)
end

local function getScreenCenter()
    local vp = camera.ViewportSize
    return Vector2.new(vp.X / 2, vp.Y / 2)
end

local function findNearestTarget(torso)
    local closest, closestMetric = nil, math.huge
    local center = getScreenCenter()

    for _, container in ipairs(getTargetContainers()) do
        for _, otherChar in pairs(container:GetChildren()) do
            if otherChar == player.Character then continue end
            if not otherChar:FindFirstChild(torsoName) then continue end

            local t    = otherChar[torsoName]
            local dist = (t.Position - torso.Position).Magnitude
            if dist > maxRadius then continue end

            if pvpOnly then
                local state = getPvpState(t)
                if state == false then continue end
            end

            local metric
            if useFOV then
                local screenPos, onScreen = camera:WorldToViewportPoint(t.Position)
                if not onScreen then continue end
                local screenDist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                if screenDist > FOV_RADIUS then continue end
                metric = screenDist
            else
                metric = dist
            end

            if metric < closestMetric then
                closestMetric = metric
                closest       = t
            end
        end
    end

    local closestDist = closest and (closest.Position - torso.Position).Magnitude or nil
    return closest, closestDist
end

local function resolveTarget(torso)
    if lockedTarget then
        if isTargetAlive(lockedTarget) then
            if pvpOnly then
                local state = getPvpState(lockedTarget)
                if state == false then
                    log("locked target disabled PVP, releasing")
                    doUnlock()
                    return findNearestTarget(torso)
                end
            end
            return lockedTarget, (lockedTarget.Position - torso.Position).Magnitude
        else
            log("locked target died, releasing")
            doUnlock()
        end
    end
    return findNearestTarget(torso)
end

local function updateESP(hasTarget)
    local displayTarget = currentESPTarget
    if not displayTarget or not displayTarget.Parent or not scriptEnabled then
        espBall.Visible   = false
        espName.Visible   = false
        espPvpTag.Visible = false
        lockRing.Visible  = false
        fovCircle.Visible = false
        return
    end

    local pos, onScreen = camera:WorldToViewportPoint(
        displayTarget.Position + Vector3.new(0, 0.6, 0)
    )
    if not onScreen then
        espBall.Visible   = false
        espName.Visible   = false
        espPvpTag.Visible = false
        lockRing.Visible  = false
        fovCircle.Visible = false
        return
    end

    local pvpState = getPvpState(displayTarget)
    local col      = pvpColor(pvpState)

    espBall.Position        = UDim2.new(0, pos.X, 0, pos.Y)
    espBall.BackgroundColor3 = col
    espBall.Visible         = true

    espName.Position   = UDim2.new(0, pos.X, 0, pos.Y - 12)
    espName.Text       = displayTarget.Parent.Name
    espName.TextColor3 = col
    espName.Visible    = true

    espPvpTag.Position = UDim2.new(0, pos.X, 0, pos.Y + 8)
    if pvpState == true then
        espPvpTag.Text       = "[PVP]"
        espPvpTag.TextColor3 = Color3.fromRGB(80, 255, 120)
    elseif pvpState == false then
        espPvpTag.Text       = "[NO PVP]"
        espPvpTag.TextColor3 = Color3.fromRGB(255, 60, 60)
    else
        espPvpTag.Text       = "[NPC]"
        espPvpTag.TextColor3 = Color3.fromRGB(255, 220, 60)
    end
    espPvpTag.Visible = true

    if lockedTarget and lockedTarget == displayTarget then
        lockRing.Position = UDim2.new(0, pos.X, 0, pos.Y)
        lockRing.Visible  = true
    else
        lockRing.Visible  = false
    end

    if useFOV then
        local center = getScreenCenter()
        fovCircle.Position = UDim2.new(0, center.X, 0, center.Y)
        fovCircle.Visible  = true
        fovStroke.Color    = hasTarget
            and Color3.fromRGB(80, 255, 120)
            or  Color3.fromRGB(255, 60, 60)
    else
        fovCircle.Visible = false
    end

    if pvpState == true then
        lblPvpInfo.Text       = "PVP:     ON"
        lblPvpInfo.TextColor3 = Color3.fromRGB(80, 255, 120)
    elseif pvpState == false then
        lblPvpInfo.Text       = "PVP:     OFF"
        lblPvpInfo.TextColor3 = Color3.fromRGB(255, 60, 60)
    else
        lblPvpInfo.Text       = "PVP:     NPC"
        lblPvpInfo.TextColor3 = Color3.fromRGB(255, 220, 60)
    end
end

-- ── Main aim loop ────────────────────────────────────────────
local function startAimLoop()
    local char, torso, rightArm = getCharParts()
    if not char or not torso or not rightArm then
        warn_("startAimLoop: missing parts, aborting")
        return
    end

    _char     = char
    _torso    = torso
    _rightArm = rightArm

    local rightShoulder, rope
    if scriptEnabled and currentMode == 1 then
        rightShoulder, rope = disableArmConstraints(char, torso)
        rightArm.Anchored   = true
    end
    _rightShoulder = rightShoulder
    _rope          = rope

    predVelocity   = Vector3.zero
    prevTargetPos  = nil
    prevTargetTime = nil
    lastTargetRef  = nil

    local shouldStop   = false
    local frameCount   = 0
    local lastName     = nil
    local isRagdollVal = char:FindFirstChild("IsRagdoll")

    local ragdollConn = isRagdollVal and isRagdollVal.Changed:Connect(function(v)
        if v == true then shouldStop = true end
    end)

    local removedConn = char.AncestryChanged:Connect(function()
        if not char:IsDescendantOf(workspace) then shouldStop = true end
    end)

    while not shouldStop do
        frameCount += 1

        if scriptEnabled then
            setStatus(true)
            
            if currentMode == 1 then
                -- Ensure arm is in aim mode
                if not _rightArm.Anchored then
                    _rightShoulder, _rope = disableArmConstraints(_char, _torso)
                    _rightArm.Anchored = true
                end

                local target, dist = resolveTarget(torso)
                currentESPTarget   = target

                if target then
                    if target.Parent.Name ~= lastName then
                        lastName = target.Parent.Name
                        log("target: " .. lastName)
                    end

                    local now = tick()
                    if target ~= lastTargetRef then
                        lastTargetRef  = target
                        prevTargetPos  = target.Position
                        prevTargetTime = now
                        predVelocity   = Vector3.zero
                    else
                        local dt = now - (prevTargetTime or now)
                        if dt > 0.001 then
                            predVelocity   = (target.Position - (prevTargetPos or target.Position)) / dt
                            prevTargetPos  = target.Position
                            prevTargetTime = now
                        end
                    end

                    local pingRTT    = player:GetNetworkPing()
                    local predOffset = predVelocity * (pingRTT * 0.5 * PRED_MULT)

                    local yOff = randomizeY
                        and (RAND_Y_MIN + math.random() * (RAND_Y_MAX - RAND_Y_MIN))
                        or OFFSET_Y

                    _rightArm.CFrame = (target.CFrame * CFrame.new(OFFSET_X, yOff, OFFSET_Z)) + predOffset

                    local pingMS = math.round(pingRTT * 1000)
                    lblPing.Text = string.format("PING:    %d ms  |  SPD: %.1f", pingMS, predVelocity.Magnitude)
                    lblPing.TextColor3 =
                        pingMS < 80  and Color3.fromRGB(80, 255, 120) or
                        pingMS < 150 and Color3.fromRGB(255, 180, 60) or
                                         Color3.fromRGB(255, 60, 60)
                else
                    if lastName then log("target lost") end
                    lastName      = nil
                    dist          = nil
                    predVelocity  = Vector3.zero
                    lastTargetRef = nil
                    lblPing.Text       = "PING:    — ms  |  PRED: off"
                    lblPing.TextColor3 = Color3.fromRGB(200, 200, 200)
                    lblPvpInfo.Text    = "PVP:     —"
                    lblPvpInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            else
                -- Giant Mode
                if _rightArm.Anchored then
                    _rightArm.Anchored = false
                    restoreArmConstraints(_char, _rightShoulder, _rope)
                end
                
                applyGiantMode()
                
                local target, dist = findNearestTarget(torso)
                currentESPTarget = target
                
                if target then
                    if target.Parent.Name ~= lastName then
                        lastName = target.Parent.Name
                    end
                    local pingRTT = player:GetNetworkPing()
                    local pingMS = math.round(pingRTT * 1000)
                    lblPing.Text = string.format("PING:    %d ms", pingMS)
                    lblPing.TextColor3 =
                        pingMS < 80  and Color3.fromRGB(80, 255, 120) or
                        pingMS < 150 and Color3.fromRGB(255, 180, 60) or
                                         Color3.fromRGB(255, 60, 60)
                else
                    if lastName then log("target lost") end
                    lastName = nil
                    dist = nil
                    lblPing.Text = "PING:    — ms"
                    lblPing.TextColor3 = Color3.fromRGB(200, 200, 200)
                    lblPvpInfo.Text = "PVP:     —"
                    lblPvpInfo.TextColor3 = Color3.fromRGB(200, 200, 200)
                end
            end

            updateGUI(lastName, currentESPTarget and (currentESPTarget.Position - torso.Position).Magnitude or nil, isRagdollVal and isRagdollVal.Value or false, frameCount)
        else
            setStatus(false)
            currentESPTarget = nil
        end

        refreshLockLabel()
        updateESP(currentESPTarget ~= nil)

        RunService.RenderStepped:Wait()
    end

    if ragdollConn then ragdollConn:Disconnect() end
    removedConn:Disconnect()
    rightArm.Anchored = false
    restoreArmConstraints(char, rightShoulder, rope)
    setStatus(false)
    currentESPTarget  = nil
    espBall.Visible   = false
    espName.Visible   = false
    espPvpTag.Visible = false
    lockRing.Visible  = false
    fovCircle.Visible = false
    doUnlock()
    updateGUI(nil, nil, true, frameCount)
    restoreGiantMode()

    _char = nil _torso = nil _rightArm = nil
    _rightShoulder = nil _rope = nil

    if isRagdollVal and char:IsDescendantOf(workspace) then
        local resumeConn
        resumeConn = isRagdollVal.Changed:Connect(function(v)
            if v == false then
                resumeConn:Disconnect()
                startAimLoop()
            end
        end)
    end
end

-- ══════════════════════════════════════════
--               INIT
-- ══════════════════════════════════════════
player.CharacterAdded:Connect(function()
    task.wait(2)
    startAimLoop()
end)

if player.Character then
    startAimLoop()
end

log("init: script loaded")