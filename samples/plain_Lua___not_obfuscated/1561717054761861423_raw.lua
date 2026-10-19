--[[ 
    REFALL - BLADE BALL ULTIMATE (GOD-SPEED ZERO-LAG SUPER SPAM ENGINE)
    Engine: NeverLose UI + Dedicated High-Priority Worker Threads + Zero-Lag Mutex Pipeline + Slashes of Fury Suppression
]]

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local StatsService = game:GetService("Stats")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

-- // [ CONFIGURATION & STATE ] // --
local Config = {
    AutoParry = true,
    TriggerBot = false,
    ManualSpam = false,
    SuperSpam = false,
    SuperSpamClicks = 25,
    SuperSpamBurstCount = 10,
    HumanizeSpam = true,
    StealthSpectatorBypass = true,
    RandomizeAccuracyEnabled = false,
    SoccerMode = false,
    AutoJumpEnabled = false,
    AnimationFix = true, 
    AntiLag = false,
    Accuracy = 40,
    SpamRate = 500,
    CurveModeName = "CAM",
    ShowStats = true
}

-- Global System Namespace
local System = {
    __properties = {
        __curve_mode = 1
    },
    __config = {
        __detections = {
            __phantom = false,
            __slashesOfFury = true
        }
    },
    player = {},
    curve = {}
}

local activeConnections = {}

-- Ball velocity tracker mock module for stats
local ball_velocity = {
    start = function() print("[ReFall] Ball Stats Tracking Started") end,
    stop = function() print("[ReFall] Ball Stats Tracking Stopped") end
}

-- Safe Dynamic Workspace Fetchers
local function GetAliveFolder()
    local ws = workspace
    return ws and ws:FindFirstChild("Alive") or nil
end

local function GetBallsFolder()
    local ws = workspace
    return ws and ws:FindFirstChild("Balls") or nil
end

-- Auto_Parry table wrapper with robust validation
local Auto_Parry = {}
Auto_Parry.Get_Ball = function()
    local ballsFolder = GetBallsFolder()
    if not ballsFolder then return nil end
    local success, balls = pcall(function() return ballsFolder:GetChildren() end)
    if not success or not balls then return nil end
    
    for i = 1, #balls do
        local ball = balls[i]
        if ball and ball.Parent and ball:GetAttribute("realBall") then
            return ball
        end
    end
    return balls[1]
end

-- // [ SAFE GROUND-STATE AUTO-JUMP LOOP WORKER ] // --
task.spawn(function()
    while true do
        task.wait(0.1)
        pcall(function()
            if Config.AutoJumpEnabled then
                local char = LocalPlayer.Character
                local hum = char and char:FindFirstChildOfClass("Humanoid")
                if hum then
                    local state = hum:GetState()
                    if state == Enum.HumanoidStateType.Running or state == Enum.HumanoidStateType.RunningNoPhysics or state == Enum.HumanoidStateType.Landed then
                        hum:ChangeState(Enum.HumanoidStateType.Jumping)
                    end
                end
            end
        end)
    end
end)

-- // [ ADVANCED REAL-TIME PING & JITTER CALIBRATION ENGINE ] // --
task.spawn(function()
    local pingSamples = {}
    while true do
        task.wait(1.0)
        pcall(function()
            if Config.RandomizeAccuracyEnabled then
                local success, currentPing = pcall(function()
                    return StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()
                end)
                
                if success and currentPing then
                    table.insert(pingSamples, 1, currentPing)
                    if #pingSamples > 5 then table.remove(pingSamples, 6) end
                    
                    local jitterSum = 0
                    for i = 2, #pingSamples do
                        jitterSum = jitterSum + math.abs(pingSamples[i] - pingSamples[i-1])
                    end
                    local averageJitter = #pingSamples > 1 and (jitterSum / (#pingSamples - 1)) or 0
                    
                    local baseCalculatedAccuracy = 30 + (currentPing * 0.25) + (averageJitter * 1.5)
                    local microFluctuation = (math.random() - 0.5) * 4.5
                    
                    Config.Accuracy = math.clamp(math.floor(baseCalculatedAccuracy + microFluctuation + 0.5), 15, 92)
                end
            end
        end)
    end
end)

-- // [ OPTIMIZED ISOLATED ANTI-LAG ENGINE ] // --
local antiLagConnection
local function ToggleAntiLag(state)
    Config.AntiLag = state
    if state then
        pcall(function()
            settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
            local descendants = workspace:GetDescendants()
            for i = 1, #descendants do
                local v = descendants[i]
                if v and (v.ClassName == "Part" or v.ClassName == "MeshPart") then
                    v.Material = Enum.Material.SmoothPlastic
                    v.Reflectance = 0
                end
            end
        end)
        antiLagConnection = RunService.Heartbeat:Connect(function()
            if not Config.AntiLag then return end
            RunService.Stepped:Wait()
        end)
        table.insert(activeConnections, antiLagConnection)
    else
        if antiLagConnection then
            pcall(function() antiLagConnection:Disconnect() end)
            antiLagConnection = nil
        end
    end
end

-- // [ REMOTE UNPATCHED CAPTURE ] // --
local captured = { remote = nil, hash = nil, kt = nil, tf = nil, animModuleFunc = nil }
local lastParryTick = 0
local parriedThisTurn = false
local lastBallVelocity = Vector3.zero

task.spawn(function()
    pcall(function()
        local getupvals = debug.getupvalues or getupvalues
        local pry_fn
        local gc = getgc(true)
        for i = 1, #gc do
            local fn = gc[i]
            if type(fn) == "function" then
                local s = debug.info(fn, "s")
                if s and s:find("SwordsController") and s:find("PRY") then
                    local ups = getupvals(fn)
                    if typeof(ups[1]) == "Instance" and ups[1]:IsA("RemoteEvent") and
                       typeof(ups[2]) == "Instance" and ups[2]:IsA("RemoteEvent") and
                       type(ups[3]) == "table" then
                        pry_fn = fn
                        for _, upval in pairs(ups) do
                            if type(upval) == "function" then
                                local src = debug.info(upval, "s")
                                if src and (src:find("Anim") or src:find("Play") or src:find("Swing")) then
                                    captured.animModuleFunc = upval
                                end
                            end
                        end
                        break
                    end
                end
            end
        end

        if not pry_fn then return end

        local ups = getupvals(pry_fn)
        local re1, re2 = ups[1], ups[2]
        
        local function applyHook(re)
            local mt = getrawmetatable(re)
            setreadonly(mt, false)
            local old = rawget(mt, "__index")
            mt.__index = newcclosure(function(self, key)
                if key == "FireServer" then
                    return function(_, ...)
                        local args = {...}
                        if #args == 8 and not captured.remote then
                            captured.remote = self
                            captured.hash = args[1]
                            captured.kt = ups[3]
                            captured.tf = ups[4]
                            print("[ReFall] God-Speed Spam Pipeline Armed!")
                        end
                        return old(self, key)(self, ...)
                    end
                end
                return old(self, key)
            end)
            setreadonly(mt, true)
        end
        
        applyHook(re1)
        applyHook(re2)
    end)
end)

-- // [ SYSTEM: OPTIMIZED GET CLOSEST TO CURSOR ] // --
System.player.get_closest_to_cursor = function()
    local aliveFolder = GetAliveFolder()
    if not aliveFolder then return nil end

    local player_char = LocalPlayer.Character
    if not player_char or not player_char.PrimaryPart then return nil end

    local mouse_location = UserInputService:GetMouseLocation()
    if not mouse_location then return nil end

    local camera = workspace.CurrentCamera
    if not camera then return nil end

    local ray = camera:ViewportPointToRay(mouse_location.X, mouse_location.Y)
    local ray_dir = ray.Direction
    local camera_pos = camera.CFrame.Position
    
    local best_score = -math.huge
    local best_player = nil
    local children = aliveFolder:GetChildren()

    for i = 1, #children do
        local player = children[i]
        if player and player ~= player_char and player.ClassName == "Model" then
            local hrp = player.PrimaryPart or player:FindFirstChild("HumanoidRootPart")
            if hrp then
                local hrp_pos = hrp.Position
                local dx, dy, dz = hrp_pos.X - camera_pos.X, hrp_pos.Y - camera_pos.Y, hrp_pos.Z - camera_pos.Z
                local distance_sq = dx*dx + dy*dy + dz*dz
                
                if distance_sq < 250000 then
                    local inv_dist = 1 / math.sqrt(distance_sq)
                    local dir_x, dir_y, dir_z = dx * inv_dist, dy * inv_dist, dz * inv_dist
                    local dot = ray_dir.X * dir_x + ray_dir.Y * dir_y + ray_dir.Z * dir_z
                    
                    if dot > 0.2 then
                        local distance_factor = 1 - (1 / inv_dist) / 500
                        local score = (dot * 0.6) + (distance_factor * 0.4)
                        
                        if score > best_score then
                            best_score = score
                            best_player = player
                        end
                    end
                end
            end
        end
    end
    
    return best_player
end

-- // [ SYSTEM: ADVANCED HUMANIZED CURVE MODULE ] // --
System.curve.get_cframe = function()
    local camera = workspace.CurrentCamera
    if not camera then return CFrame.new() end

    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild('HumanoidRootPart')
    if not root then return camera.CFrame end

    local targetPart
    local closest = System.player.get_closest_to_cursor()
    if closest then
        local hrp = closest.PrimaryPart or closest:FindFirstChild('HumanoidRootPart')
        if hrp then targetPart = hrp end
    end

    local target_pos = targetPart
        and targetPart.Position
        or (root.Position + camera.CFrame.LookVector * 100)

    local curve_functions = {
        function() return camera.CFrame end,
        function()
            local direction = (target_pos - root.Position).Unit
            local random_offset, attempts = Vector3.zero, 0
            repeat
                random_offset = Vector3.new(math.random(-4000, 4000), math.random(-4000, 4000), math.random(-4000, 4000))
                local curve_direction = (target_pos + random_offset - root.Position).Unit
                local dot = direction:Dot(curve_direction)
                attempts = attempts + 1
            until dot < 0.95 or attempts > 10
            return CFrame.new(root.Position, target_pos + random_offset)
        end,
        function()
            local Mouse_Location = UserInputService:GetMouseLocation()
            local Mouse_Vector = Vector2.new(Mouse_Location.X, Mouse_Location.Y)
            local Aimed_Player, Closest_Distance = nil, math.huge
            local aliveFolder = GetAliveFolder()
            if not aliveFolder then return CFrame.new(root.Position, target_pos) end
            
            local aliveChildren = aliveFolder:GetChildren()
            for i = 1, #aliveChildren do
                local v = aliveChildren[i]
                if v and v ~= LocalPlayer.Character and v.PrimaryPart then
                    local screenPos, isOnScreen = camera:WorldToScreenPoint(v.PrimaryPart.Position)
                    if isOnScreen then
                        local dist = (Mouse_Vector - Vector2.new(screenPos.X, screenPos.Y)).Magnitude
                        if dist < Closest_Distance then
                            Closest_Distance = dist
                            Aimed_Player = v
                        end
                    end
                end
            end
            if Aimed_Player and Aimed_Player.PrimaryPart then 
                return CFrame.new(root.Position, Aimed_Player.PrimaryPart.Position) 
            else 
                return CFrame.new(root.Position, target_pos) 
            end
        end,
        function()
            local direction = (root.Position - target_pos).Unit
            local backwards_pos = root.Position + direction * 10000 + Vector3.new(0, 1000, 0)
            return CFrame.new(camera.CFrame.Position, backwards_pos)
        end,
        function() return CFrame.new(root.Position, target_pos + Vector3.new(0, -9e18, 0)) end,
        function() return CFrame.new(root.Position, target_pos + Vector3.new(0, 9e18, 0)) end,
        function()
            local left_pos = camera.CFrame.Position - camera.CFrame.RightVector * 10000
            return CFrame.new(camera.CFrame.Position, left_pos)
        end,
        function()
            local right_pos = camera.CFrame.Position + camera.CFrame.RightVector * 10000
            return CFrame.new(camera.CFrame.Position, right_pos)
        end,
        function()
            local candidates = {}
            local aliveFolder = GetAliveFolder()
            if aliveFolder then
                local aliveChildren = aliveFolder:GetChildren()
                for i = 1, #aliveChildren do
                    local v = aliveChildren[i]
                    if v and v ~= LocalPlayer.Character and v.PrimaryPart then
                        local _, isOnScreen = camera:WorldToScreenPoint(v.PrimaryPart.Position)
                        if isOnScreen then candidates[#candidates + 1] = v end
                    end
                end
            end
            if #candidates > 0 then
                local pick = candidates[math.random(1, #candidates)]
                return CFrame.new(root.Position, pick.PrimaryPart.Position)
            else
                return camera.CFrame
            end
        end,
    }

    local mode = System.__properties.__curve_mode
    local rawCF = curve_functions[mode] and curve_functions[mode]() or camera.CFrame
    
    if Config.StealthSpectatorBypass then
        return camera.CFrame:Lerp(rawCF, 0.45)
    end
    
    return rawCF
end

-- // [ MANUAL SPAM ANIMATION FIX ] // --
local lastAnimTick = 0
local function PlayManualSpamAnimation()
    if not Config.AnimationFix or not (Config.ManualSpam or Config.SuperSpam) then return end
    local now = tick()
    if now - lastAnimTick < 0.08 then return end
    lastAnimTick = now

    pcall(function()
        if captured.animModuleFunc then pcall(captured.animModuleFunc) return end
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local animator = hum and hum:FindFirstChildOfClass("Animator")
        if not hum or not animator then return end
        
        local sharedFolder = ReplicatedStorage:FindFirstChild("Shared")
        local swordApi = sharedFolder and sharedFolder:FindFirstChild("SwordAPI")
        if swordApi and swordApi:FindFirstChild("Collection") then
            local defaultAnim = swordApi.Collection:FindFirstChild("Default") and swordApi.Collection.Default:FindFirstChild("GrabParry")
            if defaultAnim then
                local tracks = animator:GetPlayingAnimationTracks()
                for i = 1, #tracks do
                    local track = tracks[i]
                    if track and (track.Name:find("Grab") or track.Name:find("Parry")) then track:Stop(0.01) end
                end
                local track = animator:LoadAnimation(defaultAnim)
                track.Priority = Enum.AnimationPriority.Action4
                track:Play(0.01, 1, 1)
            end
        end
    end)
end

-- // [ GET LIVE PING UTILITY ] // --
local function GetPingSeconds()
    local success, result = pcall(function() return StatsService.Network.ServerStatsItem["Data Ping"]:GetValue() end)
    return success and (result / 1000) or 0.1
end

-- // [ STEALTH SPECTATOR-BYPASS TELEMETRY GENERATOR ] // --
local function GetParryData()
    local camera = workspace.CurrentCamera
    local viewportSize = camera and camera.ViewportSize or Vector2.new(1920, 1080)
    
    local mouseJitterX = (math.random() - 0.5) * (Config.HumanizeSpam and 2.5 or 0)
    local mouseJitterY = (math.random() - 0.5) * (Config.HumanizeSpam and 2.5 or 0)
    local centerPos = { (viewportSize.X / 2) + mouseJitterX, (viewportSize.Y / 2) + mouseJitterY }
    
    local events = {}
    local aliveFolder = GetAliveFolder()
    if aliveFolder and camera then
        local aliveChildren = aliveFolder:GetChildren()
        for i = 1, #aliveChildren do
            local v = aliveChildren[i]
            if v and v ~= LocalPlayer.Character and v:FindFirstChild("HumanoidRootPart") then
                local screenPos, isOnScreen = camera:WorldToScreenPoint(v.HumanoidRootPart.Position)
                if isOnScreen then events[tostring(v)] = screenPos end
            end
        end
    end
    
    local bestTargetCF = System.curve.get_cframe()
    
    if Config.HumanizeSpam then
        local microPitch = math.rad((math.random() - 0.5) * 0.25)
        local microYaw = math.rad((math.random() - 0.5) * 0.25)
        bestTargetCF = bestTargetCF * CFrame.Angles(microPitch, microYaw, 0)
    end
    
    return bestTargetCF, events, centerPos
end

-- // [ SECURE PARRY EXECUTION ] // --
local function FireParryRemote(isManual)
    if not captured.remote then return end
    local key = captured.kt and (captured.kt[3] or (captured.kt[2] and captured.kt[2][3]))
    if not key or not captured.tf then return end
    
    local ok, transformed = pcall(captured.tf, key, "TIME")
    if not ok or not transformed then return end
    
    local successTime, serverTime = pcall(function() return workspace:GetServerTimeNow() end)
    local baseTime = successTime and serverTime or tick()
    
    if Config.HumanizeSpam then
        baseTime = baseTime + ((math.random() - 0.5) * 0.0012)
    end
    
    local timeStr = tostring(math.floor(baseTime * 100))
    local chars = {}
    for i = 1, #timeStr do
        local ki = (i - 1) % #transformed + 1
        chars[i] = string.char(bit32.bxor((timeStr:byte(i) + i) % 256, transformed:byte(ki)))
    end
    
    local camCF, events, mousePos = GetParryData()
    pcall(function()
        captured.remote:FireServer(captured.hash, key, table.concat(chars), 0.025, camCF, events, mousePos, false)
    end)
    
    if isManual then task.spawn(PlayManualSpamAnimation) end
end

-- // [ COMBAT ENGINE WITH ZERO-LAG ABILITY SUPPRESSION ] // --
RunService.Heartbeat:Connect(function()
    if Config.ManualSpam or Config.SuperSpam or not captured.remote then return end
    
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        
        local humanoid = char:FindFirstChildOfClass("Humanoid")
        if not humanoid or humanoid.Health <= 0 then
            parriedThisTurn = true
            return
        end
        
        if System.__config.__detections.__slashesOfFury then
            local isFuryActive = false
            local animator = humanoid:FindFirstChildOfClass("Animator")
            if animator then
                local playingTracks = animator:GetPlayingAnimationTracks()
                for i = 1, #playingTracks do
                    local track = playingTracks[i]
                    if track and track.IsPlaying then
                        local animName = track.Name:lower()
                        local animId = tostring(track.Animation and track.Animation.AnimationId or ""):lower()
                        if animName:find("fury") or animName:find("slash") or animId:find("fury") or animId:find("slash") then
                            isFuryActive = true
                            break
                        end
                    end
                end
            end
            
            if not isFuryActive then
                local activeAbilityAttr = char:GetAttribute("ActiveAbility") or char:GetAttribute("ability") or char:GetAttribute("CurrentAbility") or ""
                local stringVal = tostring(activeAbilityAttr):lower()
                if stringVal:find("fury") or stringVal:find("slashes") or char:FindFirstChild("SlashesOfFury") or char:FindFirstChild("FuryActive") or char:FindFirstChild("FuryEffect") then
                    isFuryActive = true
                end
            end
            
            if isFuryActive then
                parriedThisTurn = true
                return
            end
        end
        
        local Ball = Auto_Parry.Get_Ball()
        if not Ball or not Ball.Parent or not char.PrimaryPart then return end
        
        local hrp = char.PrimaryPart
        local Zoomies = Ball:FindFirstChild("zoomies")
        local Velocity = Zoomies and Zoomies.VectorVelocity or Ball.AssemblyLinearVelocity
        local Speed = Velocity.Magnitude
        
        local ballTargetStr = tostring(Ball:GetAttribute("target") or Ball:GetAttribute("Target") or "")
        local localName = LocalPlayer.Name
        local isTargetingMe = (ballTargetStr == localName or ballTargetStr == char.Name)
        
        if Config.SoccerMode then 
            isTargetingMe = true 
        end
        
        local ballPos = Ball.Position
        local playerPos = hrp.Position
        local toPlayerVector = (playerPos - ballPos)
        local distanceToPlayer = toPlayerVector.Magnitude
        local closingSpeed = Velocity:Dot(toPlayerVector.Unit)
        
        local directionDot = lastBallVelocity.Unit:Dot(Velocity.Unit)
        lastBallVelocity = Velocity
        
        local attrNames = Ball:GetAttributes()
        local curveThreatMultiplier = 1.0
        local isBackCurveLoop = false
        
        if getgenv().BackCurveDetection and (directionDot < -0.05 or closingSpeed < 2 or attrNames["Curve"] or Ball:GetAttribute("Curve")) then
            isBackCurveLoop = true
            curveThreatMultiplier = 0.95
        elseif (getgenv().DeathSlashDetection and (attrNames["DeathSlash"] or Ball.Name:lower():find("death"))) then
            curveThreatMultiplier = 1.50
        elseif (getgenv().TimeHoleDetection and (attrNames["TimeHole"] or Ball:GetAttribute("TimeHole"))) then
            curveThreatMultiplier = 1.60
        elseif (getgenv().InfinityDetection and (attrNames["Infinity"] or Ball:GetAttribute("Infinity"))) then
            curveThreatMultiplier = 1.70
        elseif (getgenv().FractureDetection and (attrNames["Fracture"] or Ball:GetAttribute("Fracture"))) then
            curveThreatMultiplier = 1.40
        elseif (getgenv().AerodynamicSlashDetection and (attrNames["Aerodynamic"] or Ball:GetAttribute("Aerodynamic"))) then
            curveThreatMultiplier = 1.35
        end
        
        if isTargetingMe then
            if Config.TriggerBot then
                local now = tick()
                if not parriedThisTurn and (now - lastParryTick >= 0.25) then
                    parriedThisTurn = true
                    lastParryTick = now
                    FireParryRemote(false)
                    
                    local targetConnection
                    targetConnection = Ball:GetAttributeChangedSignal("target"):Connect(function()
                        if not Ball or not Ball.Parent then 
                            if targetConnection then targetConnection:Disconnect() end
                            return 
                        end
                        local newTarget = tostring(Ball:GetAttribute("target") or Ball:GetAttribute("Target") or "")
                        if newTarget ~= localName and (not LocalPlayer.Character or newTarget ~= LocalPlayer.Character.Name) then
                            task.delay(0.1, function() parriedThisTurn = false end)
                            if targetConnection then targetConnection:Disconnect() end
                        end
                    end)
                end
            elseif Config.AutoParry then
                if not parriedThisTurn then
                    local speedMag = math.max(Speed, 1)
                    local pingSec = GetPingSeconds()
                    local accuracyScale = math.clamp(Config.Accuracy, 1, 100) / 50
                    
                    local effectiveSpeed = math.max(speedMag, closingSpeed)
                    local latencyBuffer = effectiveSpeed * pingSec * 1.35
                    local baseThreshold = ((effectiveSpeed / 2.4) + latencyBuffer) * curveThreatMultiplier
                    local dynamicThreshold = math.clamp(baseThreshold * (1.6 - (accuracyScale * 0.6)), 18, 140)
                    
                    local allowParry = true
                    if isBackCurveLoop and closingSpeed < 0 then
                        allowParry = false
                    end
                    
                    local now = tick()
                    if allowParry and distanceToPlayer <= dynamicThreshold and (now - lastParryTick >= 0.25) then
                        parriedThisTurn = true
                        lastParryTick = now
                        FireParryRemote(false)
                        
                        local targetConnection
                        targetConnection = Ball:GetAttributeChangedSignal("target"):Connect(function()
                            if not Ball or not Ball.Parent then 
                                if targetConnection then targetConnection:Disconnect() end
                                return 
                            end
                            local newTarget = tostring(Ball:GetAttribute("target") or Ball:GetAttribute("Target") or "")
                            if newTarget ~= localName and (not LocalPlayer.Character or newTarget ~= LocalPlayer.Character.Name) then
                                task.delay(0.15, function() parriedThisTurn = false end)
                                if targetConnection then targetConnection:Disconnect() end
                            end
                        end)
                    end
                end
            end
        else
            parriedThisTurn = false
        end
    end)
end)

-- // [ STEALTH HUMANIZED MANUAL SPAM WORKER ] // --
task.spawn(function()
    while true do
        if Config.ManualSpam and not Config.SuperSpam and captured.remote then
            local targetCPS = math.clamp(Config.SpamRate, 60, 500)
            local baseDelay = 1 / targetCPS
            local jitter = Config.HumanizeSpam and ((math.random() - 0.5) * (baseDelay * 0.22)) or 0
            
            FireParryRemote(true)
            task.wait(math.max(0.001, baseDelay + jitter))
        else
            task.wait(0.05)
        end
    end
end)

-- // [ GOD-SPEED PARALLEL WORKER POOL FOR UNRIVALED SUPER SPAM ] // --
local WORKER_POOL_SIZE = 200
local workerThreads = table.create(WORKER_POOL_SIZE)
local taskQueue = {}

for i = 1, WORKER_POOL_SIZE do
    local thread
    thread = coroutine.create(function()
        while true do
            local batch = taskQueue[1]
            if batch then
                table.remove(taskQueue, 1)
                for b = 1, #batch do
                    pcall(batch[b])
                end
            else
                coroutine.yield()
            end
        end
    end)
    workerThreads[i] = thread
    coroutine.resume(thread)
end

local workerIndex = 1
local function DispatchGodSpeedBatch(batchFuncs)
    if #taskQueue > 150 then table.clear(taskQueue) end
    taskQueue[#taskQueue + 1] = batchFuncs
    
    local thread = workerThreads[workerIndex]
    if thread and coroutine.status(thread) == "suspended" then
        coroutine.resume(thread)
    end
    workerIndex = (workerIndex % WORKER_POOL_SIZE) + 1
end

RunService.RenderStepped:Connect(function()
    if Config.SuperSpam and captured.remote then
        local batches = math.clamp(math.floor(Config.SuperSpamClicks), 1, 35)
        local burstCount = math.clamp(math.floor(Config.SuperSpamBurstCount), 1, 15)
        
        local currentBatch = {}
        for i = 1, batches do
            for b = 1, burstCount do
                currentBatch[#currentBatch + 1] = function()
                    FireParryRemote(true)
                end
            end
        end
        
        if #currentBatch > 0 then
            DispatchGodSpeedBatch(currentBatch)
        end
        
        if Config.StealthSpectatorBypass and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
            pcall(function()
                local hrp = LocalPlayer.Character.HumanoidRootPart
                hrp.CFrame = hrp.CFrame * CFrame.new((math.random() - 0.5) * 0.02, 0, (math.random() - 0.5) * 0.02)
            end)
        end
    end
end)

-- // [ NEVERLOSE UI INITIALIZATION ] // --
local success, NeverLose = pcall(function()
    return loadstring(game:HttpGet("https://raw.githubusercontent.com/cchoan709-ui/Ccho-/refs/heads/main/neveri.txt"))()
end)

if not success or not NeverLose then
    warn("[ReFall] Failed to load UI Library.")
    return
end

local Window = NeverLose:CreateWindow({
    Logo = "rbxassetid://119436042723551",
    Name = "ReFall",
    Content = "https://discord.gg/nE32M9MqR",
    Size = NeverLose.Scales.Default,
    ConfigFolder = "ReFallConfigs",
    Keybind = "RightControl"
})

local Watermark = Window:Watermark()
Window:AddTabLabel('BLADE BALL')

local pingBlock = Watermark:AddBlock("chart-four-vertical-bars", "0MS")
local uiToggleBlock = Watermark:AddBlock("cube-vertexes", "ReFall")

uiToggleBlock:Input(function() Window:ToggleInterface() end)

task.spawn(function()
    while true do 
        task.wait(1)
        pcall(function()
            local ping = StatsService.Network.ServerStatsItem["Data Ping"]:GetValue()
            pingBlock:SetText(tostring(math.floor(ping)) .. 'MS')
        end)
    end
end)

local BlatantTab = Window:AddTab({ Icon = 'crosshairs', Name = "Combat" })
local CombatSection = BlatantTab:AddSection({ Name = "AUTOMATION" })
local SpamSection = BlatantTab:AddSection({ Name = "SPAM & TRIGGER", Position = 'right' })

CombatSection:AddLabel('Auto Parry'):AddToggle({
    Default = Config.AutoParry,
    Flag = "AutoParryToggle",
    Callback = function(value) Config.AutoParry = value parriedThisTurn = false end
})

CombatSection:AddLabel('Soccer Mode'):AddToggle({
    Default = Config.SoccerMode,
    Flag = "SoccerModeToggle",
    Callback = function(value) Config.SoccerMode = value end
})

CombatSection:AddLabel('Parry Accuracy'):AddSlider({
    Min = 0, Max = 100, Type = "%", Default = 40,
    Flag = "AccuracySlider",
    Callback = function(value) Config.Accuracy = value end
})

CombatSection:AddLabel('Randomize Accuracy'):AddToggle({
    Default = Config.RandomizeAccuracyEnabled,
    Flag = "RandomizeAccuracyToggle",
    Callback = function(value) 
        Config.RandomizeAccuracyEnabled = value 
    end
})

CombatSection:AddLabel('Curve Mode'):AddDropdown({
    Values = {"Cam", "Random Offset", "Aimed Player", "Back", "Down (Slow)", "Up (High)", "Left", "Right", "Random Target"},
    Default = "Cam",
    Flag = "CurveModeDropdown",
    Callback = function(value)
        local mapping = {
            ["Cam"] = 1, ["Random Offset"] = 2, ["Aimed Player"] = 3, ["Back"] = 4,
            ["Down (Slow)"] = 5, ["Up (High)"] = 6, ["Left"] = 7, ["Right"] = 8, ["Random Target"] = 9
        }
        System.__properties.__curve_mode = mapping[value] or 1
    end
})

CombatSection:AddLabel('Triggerbot (Instant Target)'):AddToggle({
    Default = Config.TriggerBot,
    Flag = "TriggerBotToggle",
    Callback = function(value) Config.TriggerBot = value parriedThisTurn = false end
})

-- // [ DETECTIONS TAB ] // --
local DetectionsTab = Window:AddTab({ Icon = 'shield', Name = "Detections" })
local DetectionSection = DetectionsTab:AddSection({ Name = "ABILITY DETECTIONS" })

DetectionSection:AddLabel("Slashes of Fury Detection"):AddToggle({
    Default = true,
    Flag = "SlashesOfFuryDetection",
    Callback = function(value) 
        System.__config.__detections.__slashesOfFury = value 
    end
})

DetectionSection:AddLabel("Back-Curve Detection"):AddToggle({
    Default = true,
    Flag = "BackCurveDetection",
    Callback = function(value) getgenv().BackCurveDetection = value end
})

DetectionSection:AddLabel("Infinity Detection"):AddToggle({
    Default = false,
    Flag = "InfinityDetection",
    Callback = function(value) getgenv().InfinityDetection = value end
})

DetectionSection:AddLabel("Death Slash Detection"):AddToggle({
    Default = false,
    Flag = "DeathSlashDetection",
    Callback = function(value) getgenv().DeathSlashDetection = value end
})

DetectionSection:AddLabel("Time Hole Detection"):AddToggle({
    Default = false,
    Flag = "TimeHoleDetection",
    Callback = function(value) getgenv().TimeHoleDetection = value end
})

DetectionSection:AddLabel("Fracture Detection"):AddToggle({
    Default = false,
    Flag = "FractureDetection",
    Callback = function(value) getgenv().FractureDetection = value end
})

DetectionSection:AddLabel("Aerodynamic Slash Detection"):AddToggle({
    Default = false,
    Flag = "AerodynamicSlashDetection",
    Callback = function(value) getgenv().AerodynamicSlashDetection = value end
})

-- // [ MISC TAB ] // --
local MiscTab = Window:AddTab({ Icon = 'settings', Name = "Misc" })

local MiscSection = MiscTab:AddSection({ Name = "STATS" })
MiscSection:AddLabel('Ball Stats'):AddToggle({
    Default = false,
    Flag = "BallStats",
    Callback = function(state)
        if state then ball_velocity.start() else ball_velocity.stop() end
    end
})

local MovementSection = MiscTab:AddSection({ Name = "MOVEMENT", Position = "right" })
MovementSection:AddLabel('Auto Jump'):AddToggle({
    Default = Config.AutoJumpEnabled,
    Flag = "AutoJumpToggle",
    Callback = function(state)
        Config.AutoJumpEnabled = state
    end
})

local PerfSection = MiscTab:AddSection({ Name = "PERFORMANCE", Position = "right" })
PerfSection:AddLabel('Anti-Lag Engine'):AddToggle({
    Default = Config.AntiLag,
    Flag = "AntiLagToggle",
    Callback = function(state) ToggleAntiLag(state) end
})

local FOVSection = MiscTab:AddSection({ Name = "FOV", Position = "right" })
local FOVLabel = FOVSection:AddLabel("FOV")
FOVLabel:ToolTip("Changes Camera POV")
FOVLabel:AddToggle({
    Default = false,
    Flag = "FOV",
    Callback = function(value)
        getgenv().CameraEnabled = value
        local camera = workspace.CurrentCamera
        if not camera then return end

        if value then
            getgenv().CameraFOV = getgenv().CameraFOV or 70
            camera.FieldOfView = getgenv().CameraFOV
            if not getgenv().FOVLoop then
                getgenv().FOVLoop = RunService.RenderStepped:Connect(function()
                    if getgenv().CameraEnabled and workspace.CurrentCamera then
                        workspace.CurrentCamera.FieldOfView = getgenv().CameraFOV
                    end
                end)
            end
        else
            camera.FieldOfView = 70
            if getgenv().FOVLoop then
                getgenv().FOVLoop:Disconnect()
                getgenv().FOVLoop = nil
            end
        end
    end
})

-- // [ FLOATING MANUAL SPAM & SUPER SPAM & TRIGGERBOT BUTTONS SETUP ] // --
local MobileGui = Instance.new("ScreenGui", CoreGui)
MobileGui.Name = "ReFallFloatingGui"
MobileGui.ResetOnSpawn = false
MobileGui.IgnoreGuiInset = true

local SpamButton = Instance.new("TextButton", MobileGui)
SpamButton.Size = UDim2.new(0, 120, 0, 40)
SpamButton.Position = UDim2.new(0.8, -60, 0.60, -20)
SpamButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SpamButton.Text = "SPAM: OFF"
SpamButton.TextColor3 = Color3.fromRGB(255, 100, 100)
SpamButton.Font = Enum.Font.GothamBold
SpamButton.TextSize = 13
SpamButton.Active = true
SpamButton.Draggable = true
SpamButton.Visible = true

Instance.new("UICorner", SpamButton).CornerRadius = UDim.new(0, 10)
local stroke1 = Instance.new("UIStroke", SpamButton)
stroke1.Color = Color3.fromRGB(255, 120, 0)
stroke1.Thickness = 2

SpamButton.MouseButton1Click:Connect(function()
    Config.ManualSpam = not Config.ManualSpam
    if Config.ManualSpam then
        Config.SuperSpam = false
        SpamButton.Text = "SPAM: ON"
        SpamButton.TextColor3 = Color3.fromRGB(100, 255, 100)
        SpamButton.BackgroundColor3 = Color3.fromRGB(50, 20, 20)
    else
        SpamButton.Text = "SPAM: OFF"
        SpamButton.TextColor3 = Color3.fromRGB(255, 100, 100)
        SpamButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    end
end)

local SuperSpamButton = Instance.new("TextButton", MobileGui)
SuperSpamButton.Size = UDim2.new(0, 120, 0, 40)
SuperSpamButton.Position = UDim2.new(0.8, -60, 0.68, -20)
SuperSpamButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
SuperSpamButton.Text = "SUPER SPAM: OFF"
SuperSpamButton.TextColor3 = Color3.fromRGB(255, 100, 100)
SuperSpamButton.Font = Enum.Font.GothamBold
SuperSpamButton.TextSize = 11
SuperSpamButton.Active = true
SuperSpamButton.Draggable = true
SuperSpamButton.Visible = true

Instance.new("UICorner", SuperSpamButton).CornerRadius = UDim.new(0, 10)
local strokeSuper = Instance.new("UIStroke", SuperSpamButton)
strokeSuper.Color = Color3.fromRGB(255, 0, 120)
strokeSuper.Thickness = 2

SuperSpamButton.MouseButton1Click:Connect(function()
    Config.SuperSpam = not Config.SuperSpam
    if Config.SuperSpam then
        Config.ManualSpam = false
        SuperSpamButton.Text = "SUPER SPAM: ON"
        SuperSpamButton.TextColor3 = Color3.fromRGB(100, 255, 100)
        SuperSpamButton.BackgroundColor3 = Color3.fromRGB(50, 20, 50)
    else
        SuperSpamButton.Text = "SUPER SPAM: OFF"
        SuperSpamButton.TextColor3 = Color3.fromRGB(255, 100, 100)
        SuperSpamButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    end
end)

local TriggerButton = Instance.new("TextButton", MobileGui)
TriggerButton.Size = UDim2.new(0, 120, 0, 40)
TriggerButton.Position = UDim2.new(0.8, -60, 0.76, -20)
TriggerButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
TriggerButton.Text = "TRIGGER: OFF"
TriggerButton.TextColor3 = Color3.fromRGB(255, 100, 100)
TriggerButton.Font = Enum.Font.GothamBold
TriggerButton.TextSize = 13
TriggerButton.Active = true
TriggerButton.Draggable = true
TriggerButton.Visible = true

Instance.new("UICorner", TriggerButton).CornerRadius = UDim.new(0, 10)
local stroke2 = Instance.new("UIStroke", TriggerButton)
stroke2.Color = Color3.fromRGB(120, 100, 255)
stroke2.Thickness = 2

TriggerButton.MouseButton1Click:Connect(function()
    Config.TriggerBot = not Config.TriggerBot
    parriedThisTurn = false
    if Config.TriggerBot then
        TriggerButton.Text = "TRIGGER: ON"
        TriggerButton.TextColor3 = Color3.fromRGB(100, 255, 100)
        TriggerButton.BackgroundColor3 = Color3.fromRGB(20, 20, 50)
    else
        TriggerButton.Text = "TRIGGER: OFF"
        TriggerButton.TextColor3 = Color3.fromRGB(255, 100, 100)
        TriggerButton.BackgroundColor3 = Color3.fromRGB(30, 30, 40)
    end
end)

SpamSection:AddLabel('Show Manual Spam Button'):AddToggle({
    Default = true,
    Flag = "ShowManualSpamButtonToggle",
    Callback = function(value) 
        SpamButton.Visible = value 
    end
})

SpamSection:AddLabel('Show Super Spam Button'):AddToggle({
    Default = true,
    Flag = "ShowSuperSpamButtonToggle",
    Callback = function(value) 
        SuperSpamButton.Visible = value
    end
})

SpamSection:AddLabel('Show Trigger Button'):AddToggle({
    Default = true,
    Flag = "ShowTriggerButtonToggle",
    Callback = function(value) TriggerButton.Visible = value end
})

SpamSection:AddLabel('Spectator Stealth Bypass'):AddToggle({
    Default = Config.StealthSpectatorBypass,
    Flag = "StealthBypassToggle",
    Callback = function(value) Config.StealthSpectatorBypass = value end
})

SpamSection:AddLabel('Humanize Telemetry Noise'):AddToggle({
    Default = Config.HumanizeSpam,
    Flag = "HumanizeSpamToggle",
    Callback = function(value) Config.HumanizeSpam = value end
})

SpamSection:AddLabel('Animation Fix'):AddToggle({
    Default = Config.AnimationFix,
    Flag = "AnimationFixToggle",
    Callback = function(value) Config.AnimationFix = value end
})

SpamSection:AddLabel('Spam Rate (CPS)'):AddSlider({
    Min = 60, Max = 500, Type = " CPS", Default = 300,
    Flag = "SpamRateSlider",
    Callback = function(value) Config.SpamRate = value end
})

SpamSection:AddLabel('Super Spam Clicks'):AddSlider({
    Min = 1, Max = 35, Type = "x", Default = 25,
    Flag = "SuperSpamClicksSlider",
    Callback = function(value) Config.SuperSpamClicks = value end
})

SpamSection:AddLabel('Super Spam Burst Clicks'):AddSlider({
    Min = 1, Max = 15, Type = "x", Default = 10,
    Flag = "SuperSpamBurstSlider",
    Callback = function(value) Config.SuperSpamBurstCount = value end
})

print("[ReFall] God-Speed Spam Pipeline Loaded Successfully.")
