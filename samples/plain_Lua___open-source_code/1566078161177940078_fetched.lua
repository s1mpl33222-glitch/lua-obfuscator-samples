--========================================================--
--                  T21 SYSTEM (FLOATING)
--   Smooth chase    No teleport    Noclip    Auto repeat
--========================================================--

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")

local player = Players.LocalPlayer

--========================================================--
-- MASTER HANDLER CONFIG (Main Handler Override)
--========================================================--
local masterHandlers = {
    ["queenrosee172"] = true,
}

--========================================================--
-- USER-SPECIFIC CUSTOMIZATION CONFIG
--========================================================--
local customConfigs = {
    ["craken696"] = { prefix = "Android", title = "Android System" },
    ["MKU48U"] = { prefix = "Ceo", title = "Ceo System" },
    ["MCT48T"] = { prefix = "Drake", title = "Drake System" },
    ["miso_matchapuri"] = { prefix = "Nama", title = "Nama System" },
    ["treezeekk"] = { prefix = "Smart", title = "Smsart System" },
    ["roblox_user_4058510147"] = { prefix = "Rose", title = "Rose System" },
    ["aly_jxhn"] = { prefix = "Aly", title = "Aly System" },
    ["thegoatdangerr"] = { prefix = "Idc", title = "Idc System" },
    ["queenrosee172"] = { prefix = "Queen", title = "Queen System" },
    ["fanling_1711"] = { prefix = "Fan", title = "Fan System" },
    ["bons_vx"] = { prefix = "Akira", title = "Akira System" },
    ["karma20376"] = { prefix = "Deku", title = "Deku System" },
    ["SoCutebleh_049"] = { prefix = "Maya", title = "Maya System" },
    ["NXE_BHATI4"] = { prefix = "Bhati", title = "Bhati System" },
    ["driantuffblud"] = { prefix = "Drian", title = "Drian System" },
}

local defaultConfig = { prefix = "T21", title = "T21 SYSTEM" }
local userConfig = customConfigs[player.Name] or defaultConfig

local SCRIPT_PREFIX = userConfig.prefix 
local SCRIPT_TITLE = userConfig.title

--========================================================--
-- USERNAME CHECK (Guard Clause)
--========================================================--
local allowedUsers = {
    ["craken696"] = true,
    ["MKU48U"] = true,
    ["MCT48T"] = true,
    ["miso_matchapuri"] = true,
    ["queenrosee172"] = true,
    ["treezeekk"] = true,
    ["roblox_user_4058510147"] = true,
    ["aly_jxhn"] = true,
    ["thegoatdangerr"] = true,
    ["fanling_1711"] = true,
    ["bons_vx"] = true,
    ["karma20376"] = true,
    ["SoCutebleh_049"] = true,
    ["NXE_BHATI4"] = true,
    ["driantuffblud"] = true,
}

if not allowedUsers[player.Name] then
    return
end

--========================================================--
-- CHAT SYSTEM SETUP (Safe Execution)
--========================================================--
local TextChatService = game:GetService("TextChatService")
local isLegacyChat = TextChatService.ChatVersion == Enum.ChatVersion.LegacyChatService

local function chat(msg)
    pcall(function()
        if isLegacyChat then
            local replicatedChat = ReplicatedStorage:FindFirstChild("DefaultChatSystemChatEvents")
            if replicatedChat then
                local sayMessageRequest = replicatedChat:FindFirstChild("SayMessageRequest")
                if sayMessageRequest then
                    sayMessageRequest:FireServer(msg, "All")
                end
            end
        else
            local channels = TextChatService:FindFirstChild("TextChannels")
            if channels then
                local general = channels:FindFirstChild("RBXGeneral")
                if general then
                    general:SendAsync(msg)
                end
            end
        end
    end)
end

local parentPlayer = player
local followConnection = nil

-- States
local mode = "idle"
local attackTarget = nil
local panicMode = false
local scriptActive = true 

-- Settings
local FLOAT_HEIGHT = 0
local MOVE_STEP = 1000000
local HITBOX_SIZE = 100
local BLOCK_ENABLED = false
local PREDICT_ENABLED = true
local PREDICT_FACTOR = 0.4
local loopKillTargetName = nil

-- Auto Combat Settings
local m1Active = false
local m2Active = true
local COMBAT_COOLDOWN = 0

-- Destroy Settings
local destroyTarget = nil
local DESTROY_RADIUS = 20
local DESTROY_SPEED = 0.1
local destroyMode = false

-- Orbit settings for destroy mode
local ORBIT_RADIUS = 14
local ORBIT_SPEED = 6
local orbitAngle = 0
local savedOrbitSpeed = ORBIT_SPEED

-- Internal
local lastCommand = nil
local immunePlayers = {}

-- Loop Attack Routine Control State
local attackLoopActive = false

-- Assigners & Controllers
local assigners = {
    ["queenrosee172"] = true,
}
assigners[player.Name] = true

local function isController(plr)
    return allowedUsers[plr.Name] or assigners[plr.Name] or masterHandlers[plr.Name] or plr == parentPlayer
end

--========================================================--
-- PLAYER FIND
--========================================================--
local function findPlayerByFuzzy(str)
    str = str:lower()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.DisplayName:lower():find(str) or plr.Name:lower():find(str) then
            return plr
        end
    end
    return nil
end

--========================================================--
-- NOCLIP
--========================================================--
RunService.Stepped:Connect(function()
    if not scriptActive then return end
    local char = player.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end
end)

--========================================================--
-- HITBOX CONTROL
--========================================================--
local function updateHitboxes()
    if not scriptActive then return end
    for _, plr in ipairs(Players:GetPlayers()) do
        local char = plr.Character
        if char and char:FindFirstChild("HumanoidRootPart") then
            if plr ~= parentPlayer and not immunePlayers[plr] and not assigners[plr.Name] then
                char.HumanoidRootPart.Size = Vector3.new(HITBOX_SIZE, HITBOX_SIZE, HITBOX_SIZE)
            else
                char.HumanoidRootPart.Size = Vector3.new(1, 4, 1)
            end
        end
    end
end

--========================================================--
-- SMOOTH MOVE
--========================================================--
local function smoothMove(hrp, targetPos)
    if not scriptActive then return end
    local dir = targetPos - hrp.Position
    local mag = dir.Magnitude
    if mag < 0.001 then return end
    dir = dir.Unit
    local step = math.min(MOVE_STEP, mag)
    local newPos = hrp.Position + dir * step
    newPos = Vector3.new(newPos.X, targetPos.Y, newPos.Z)
    hrp.CFrame = CFrame.new(newPos)
end

--========================================================--
-- PREDICTION
--========================================================--
local function getPredictedPosition(hrp, targetHRP)
    if not PREDICT_ENABLED then
        return targetHRP.Position
    end
    
    local distance = (hrp.Position - targetHRP.Position).Magnitude
    if distance <= 20 then
        local velocity = Vector3.new(targetHRP.Velocity.X, 0, targetHRP.Velocity.Z)
        return targetHRP.Position + (velocity * PREDICT_FACTOR)
    else
        return targetHRP.Position
    end
end

--========================================================--
-- DESTROY FUNCTION
--========================================================--
local function getTargetPosition(target)
    if target and target.Character then
        local hrp = target.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            return hrp.Position
        end
    end
    return nil
end

local function destroyTargetPlayer(dt)
    if not scriptActive or not destroyTarget then return end
    local char = player.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    local pos = getTargetPosition(destroyTarget)
    if not hrp or not pos then return end

    orbitAngle = orbitAngle + (ORBIT_SPEED * dt)
    local offset = Vector3.new(math.cos(orbitAngle) * ORBIT_RADIUS, FLOAT_HEIGHT, math.sin(orbitAngle) * ORBIT_RADIUS)
    smoothMove(hrp, pos + offset)
end

--========================================================--
-- AUTO M1 / M2 / BLOCK LOOPS
--========================================================--
task.spawn(function()
    while true do
        if scriptActive and m1Active then
            pcall(function()
                ReplicatedStorage.CombatRemote:FireServer("M1")
            end)
        end
        task.wait(COMBAT_COOLDOWN)
    end
end)

task.spawn(function()
    while true do
        if scriptActive and m2Active then
            pcall(function()
                ReplicatedStorage.CombatRemote:FireServer("M2")
            end)
        end
        task.wait(COMBAT_COOLDOWN)
    end
end)

task.spawn(function()
    while true do
        if scriptActive and BLOCK_ENABLED then
            ReplicatedStorage.CombatRemote:FireServer("Block")
            task.wait(0)
            ReplicatedStorage.CombatRemote:FireServer("Block")
        end
        task.wait(0)
    end
end)

--========================================================--
-- MOVE DOWN TO THE VOID QUICKLY
--========================================================--
local function moveToVoidQuickly()
    if not scriptActive then return end
    local localChar = player.Character or player.CharacterAdded:Wait()
    local rootPart = localChar:WaitForChild("HumanoidRootPart", 5)
    if not rootPart then return end

    if localChar:FindFirstChild("VoidRunning") then
        localChar.VoidRunning:Destroy()
    end

    local marker = Instance.new("BoolValue")
    marker.Name = "VoidRunning"
    marker.Parent = localChar

    for _, part in ipairs(localChar:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    local fallSpeed = 2000
    local connection

    connection = RunService.RenderStepped:Connect(function(deltaTime)
        if not scriptActive or not localChar or not localChar.Parent or not rootPart.Parent or not marker.Parent then
            if connection then connection:Disconnect() end
            return
        end

        localChar:PivotTo(localChar:GetPivot() - Vector3.new(0, fallSpeed * deltaTime, 0))
        rootPart.AssemblyLinearVelocity = Vector3.new(0, -fallSpeed, 0)

        if rootPart.Position.Y < -500 then
            if connection then connection:Disconnect() end
            marker:Destroy()
        end
    end)

    task.wait(0.6)
end

--========================================================--
-- STOP FOLLOWING
--========================================================--
local function stopFollowing()
    if followConnection then followConnection:Disconnect() end
    followConnection = nil
    mode = "stop"
    attackTarget = nil
    destroyTarget = nil
    loopKillTargetName = nil
    attackLoopActive = false
    ORBIT_SPEED = savedOrbitSpeed
end

--========================================================--
-- KILL SCRIPT FUNCTION
--========================================================--
local function killScript()
    scriptActive = false
    stopFollowing()
    m1Active = false
    m2Active = false
    BLOCK_ENABLED = false
    chat(SCRIPT_PREFIX .. " Script killed by Master Handler.")
end

--========================================================--
-- FOLLOW LOOP
--========================================================--
local lastTick = tick()
local function startFollowing()
    if not scriptActive then return end
    if followConnection then followConnection:Disconnect() end
    
    followConnection = RunService.Heartbeat:Connect(function()
        if not scriptActive then
            if followConnection then followConnection:Disconnect() end
            return
        end

        local now = tick()
        local dt = now - lastTick
        lastTick = now

        if panicMode then return end
        local char = player.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        updateHitboxes()

        if mode == "destroy" and destroyTarget then
            destroyTargetPlayer(dt)
            task.wait(DESTROY_SPEED)
            return
        end

        if mode == "attack" and attackTarget then
            local tChar = attackTarget.Character
            if tChar and tChar:FindFirstChild("HumanoidRootPart") then
                local predicted = getPredictedPosition(hrp, tChar.HumanoidRootPart)
                local pos = predicted + Vector3.new(0, FLOAT_HEIGHT, 0)
                smoothMove(hrp, pos)
            end
            return
        end

        if mode == "idle" and parentPlayer.Character then
            local pHRP = parentPlayer.Character:FindFirstChild("HumanoidRootPart")
            if pHRP then
                smoothMove(hrp, pHRP.Position + Vector3.new(0, FLOAT_HEIGHT, 8))
            end
        end
    end)
end

--========================================================--
-- UPDATED ATTACK LOOP ROUTINE
--========================================================--
local function runCustomAttackLoop(target)
    if attackLoopActive then return end
    attackLoopActive = true
    attackTarget = target
    mode = "attack"

    -- 1. Reset ONLY ONCE when starting the attack command
    local char = player.Character
    if char and char:FindFirstChild("Humanoid") then
        char.Humanoid.Health = 0
    end

    -- 2. Wait to respawn, then move down into the void once
    player.CharacterAdded:Wait()
    task.wait(0)
    moveToVoidQuickly()

    -- 3. Repeat loop: Run attack mode immediately -> wait 3 sec -> temporarily stop -> run void -> rerun attack mode
    task.spawn(function()
        while scriptActive and attackLoopActive and attackTarget do
            -- Run the prefix attack mode immediately
            startFollowing()
            
            -- Wait for 3 seconds
            local elapsed = 0
            while elapsed < 0.5 and scriptActive and attackLoopActive and attackTarget do
                task.wait(0.1)
                elapsed = elapsed + 0.1
            end

            if not scriptActive or not attackLoopActive then break end

            -- Temporarily stop the prefix attack mode
            if followConnection then followConnection:Disconnect() end

            -- Run the void movement quickly
            moveToVoidQuickly()
        end
    end)
end

--========================================================--
-- COMMAND HANDLER
--========================================================--
local function runCommand(cmd)
    if not scriptActive then return end
    lastCommand = cmd

    if cmd.type == "idle" then
        attackLoopActive = false
        mode = "idle"
        startFollowing()

    elseif cmd.type == "attack" then
        runCustomAttackLoop(cmd.target)

    elseif cmd.type == "destroy" then
        attackLoopActive = false
        local target = cmd.target
        savedOrbitSpeed = ORBIT_SPEED
        ORBIT_SPEED = 16
        mode = "destroy"
        destroyTarget = target
        startFollowing()

    elseif cmd.type == "stop" then
        stopFollowing()

    elseif cmd.type == "height" then
        FLOAT_HEIGHT = cmd.val

    elseif cmd.type == "immune" then
        immunePlayers[cmd.target] = true

    elseif cmd.type == "unimmune" then
        immunePlayers[cmd.target] = nil

    elseif cmd.type == "block" then
        BLOCK_ENABLED = cmd.val

    elseif cmd.type == "reset" then
        attackLoopActive = false
        local char = player.Character
        if char and char:FindFirstChild("Humanoid") then
            char.Humanoid.Health = 0
        end

    elseif cmd.type == "predict" then
        PREDICT_ENABLED = cmd.val

    elseif cmd.type == "loopkill" then
        runCustomAttackLoop(cmd.target)

    elseif cmd.type == "unloopkill" then
        stopFollowing()
    end
end

--========================================================--
-- CHAT LISTENER
--========================================================--
local function onChat(plr, msg)
    local m = msg:lower()
    local prefix = SCRIPT_PREFIX:lower()

    if m:sub(1, #prefix + 1) ~= prefix .. " " then
        return
    end

    if not isController(plr) and plr ~= parentPlayer then return end

    if m == prefix .. " kill" and masterHandlers[plr.Name] then
        killScript()
        return
    end

    if not scriptActive then return end

    if assigners[plr.Name] or allowedUsers[plr.Name] or masterHandlers[plr.Name] then
        local controlPattern = "^" .. prefix .. "%s+(.-)%s+controll$"
        local t = m:match(controlPattern)
        if t then
            local found = findPlayerByFuzzy(t)
            if found then
                parentPlayer = found
            end
            return
        end
    end

    if m == prefix .. " idle" then runCommand({type = "idle"}) end
    if m == prefix .. " stop" then runCommand({type = "stop"}) end

    local attackPattern = "^" .. prefix .. "%s+attack%s+(.+)$"
    local a = m:match(attackPattern)
    if a then
        local found = findPlayerByFuzzy(a)
        if found then 
            task.spawn(function()
                runCommand({type = "attack", target = found})
            end)
        end
    end

    local heightPattern = "^" .. prefix .. "%s+height%s+([%-%d]+)$"
    local h = m:match(heightPattern)
    if h then runCommand({type = "height", val = tonumber(h)}) end

    local immunePattern = "^" .. prefix .. "%s+immune%s+(.+)$"
    local im = m:match(immunePattern)
    if im then
        local found = findPlayerByFuzzy(im)
        if found then runCommand({type = "immune", target = found}) end
    end

    local unimmunePattern = "^" .. prefix .. "%s+unimmune%s+(.+)$"
    local uim = m:match(unimmunePattern)
    if uim then
        local found = findPlayerByFuzzy(uim)
        if found then runCommand({type = "unimmune", target = found}) end
    end

    if m == prefix .. " block on" then runCommand({type = "block", val = true}) end
    if m == prefix .. " block off" then runCommand({type = "block", val = false}) end

    if m == prefix .. " m1 on" then m1Active = true end
    if m == prefix .. " m1 off" then m1Active = false end
    if m == prefix .. " m2 on" then m2Active = true end
    if m == prefix .. " m2 off" then m2Active = false end

    if m == prefix .. " reset" then
        runCommand({type = "reset"})
    end

    if m == prefix .. " predict on" then runCommand({type = "predict", val = true}) end
    if m == prefix .. " predict off" then runCommand({type = "predict", val = false}) end

    local loopKillPattern = "^" .. prefix .. "%s+loopkill%s+(.+)$"
    local lk = m:match(loopKillPattern)
    if lk then
        local found = findPlayerByFuzzy(lk)
        if found then runCommand({type = "loopkill", target = found}) end
    end
    if m == prefix .. " unloopkill" then runCommand({type = "unloopkill"}) end

    local destroyPattern = "^" .. prefix .. "%s+destroy%s+(.+)$"
    local d = m:match(destroyPattern)
    if d then
        local found = findPlayerByFuzzy(d)
        if found then 
            task.spawn(function()
                runCommand({type = "destroy", val = true, target = found})
            end)
        end
    end

    local destroyRadiusPattern = "^" .. prefix .. "%s+destroyradius%s+(%d+)$"
    local dr = m:match(destroyRadiusPattern)
    if dr then
        DESTROY_RADIUS = tonumber(dr)
    end

    local destroySpeedPattern = "^" .. prefix .. "%s+destroyspeed%s+(%d+)$"
    local ds = m:match(destroySpeedPattern)
    if ds then
        DESTROY_SPEED = tonumber(ds) / 100
    end

    if m == prefix .. " destroy off" then
        stopFollowing()
    end
end

for _, p in ipairs(Players:GetPlayers()) do
    p.Chatted:Connect(function(msg) onChat(p, msg) end)
end
Players.PlayerAdded:Connect(function(p)
    p.Chatted:Connect(function(msg) onChat(p, msg) end)
end)
