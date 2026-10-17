
if _G.primas then return end
_G.primas = true

setfpscap(9999)
repeat task.wait() until game:IsLoaded()

cloneref = cloneref or function(x) return x end

local ReplicatedStorage = cloneref(game:GetService("ReplicatedStorage"))
local UserInputService = cloneref(game:GetService("UserInputService"))
local HttpService = cloneref(game:GetService("HttpService"))
local RunService = cloneref(game:GetService("RunService"))
local Players = cloneref(game:GetService("Players"))
local Debris = cloneref(game:GetService("Debris"))
local Stats = cloneref(game:GetService("Stats"))
local LocalPlayer = Players.LocalPlayer

-- ========================================
-- CONFIG (persisted to disk)
-- ========================================
_G.config = {
    accuracy = nil,
    spam_threshold = nil,
    curve_keybind = nil,
    manual_notify = nil,
    curve_notify = nil,
    curve_method = '',
    anti_phantom = nil,
    anti_cooldown = nil,
    skin_changer = nil,
    manual_spam = nil,
    ability_esp = nil,
    auto_parry = nil,
    ball_debug = nil,
    auto_spam = nil,
    triggerbot_notify = nil,
    thunder_dash_no_cooldown = nil,
    ping_fix = nil,
    names = '',
    avatar_changer = nil,
    avatar_name = '',
    random_target = nil,
}

if not isfolder("angeli/configs") then
    makefolder("angeli/configs")
end
local CONFIG_PATH = "angeli/configs/blade_ball.json"

local function save_cfg()
    writefile(CONFIG_PATH, HttpService:JSONEncode(_G.config))
end

local function load_cfg()
    if isfile(CONFIG_PATH) then
        _G.config = HttpService:JSONDecode(readfile(CONFIG_PATH))
    end
end

load_cfg()

-- Auto-save loop (every 1s while script is loaded)
task.spawn(function()
    repeat
        save_cfg()
        task.wait(1)
    until not _G.primas
end)

-- ========================================
-- UI (Fluent library)
-- ========================================
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local Window = Fluent:CreateWindow({
    Title = "angeli",
    SubTitle = "",
    TabWidth = 100,
    Size = UDim2.fromOffset(440, 315),
    Acrylic = false,
    Theme = "Darker",
    MinimizeKey = Enum.KeyCode.LeftControl,
})

local MainTab = Window:AddTab({ Title = "main", Icon = "shield" })
local VisualTab = Window:AddTab({ Title = "visual", Icon = "eye" })


-- ========================================
-- BALL HELPER STATE
-- ========================================
local Connections = {}
local BallHelper = {}
BallHelper.ball = {
    properties = {
        aerodynamic_time = tick(),
        last_warping = tick(),
        lerp_radians = 0,
        curving = tick(),
    }
}

local CurrentAnimTrack -- unused remnant, kept for compatibility
local CurrentTarget    -- the random/selected target for parry direction

-- ========================================
-- REMOTE DETECTION (scrieie remote)
--
-- Uses the remote/token pipeline from scrieie instead of the old
-- old remote capture system.
-- ========================================
local replicated_storage = ReplicatedStorage

local _token
if getgc and debug and debug.info and debug.getupvalues then
    for _, Function in getgc(true) do
        if type(Function) ~= "function" or not debug.info(Function, "s"):find("PRY", 1, true) then
            continue
        end

        for _, value in debug.getupvalues(Function) do
            if type(value) == "function" then
                _token = value
                break
            end
        end

        if _token then
            break
        end
    end
end

local function _tokenize(_remote_uid)
    if type(_token) ~= "function" or type(_remote_uid) ~= "string" then
        return nil
    end

    local time = tostring(math.floor(workspace:GetServerTimeNow() * 100))
    local key = _token(_remote_uid, "TIME")
    if type(key) ~= "string" or #key == 0 then
        return nil
    end

    local characters = table.create(#time)
    for index = 1, #time do
        characters[index] = string.char(bit32.bxor(
            (string.byte(time, index) + index) % 256,
            string.byte(key, (index - 1) % #key + 1)
        ))
    end

    return table.concat(characters)
end

local _reverted = {}
local _original = {}

local function _is_valid(args)
    return #args == 8
        and type(args[2]) == "string"
        and type(args[3]) == "string"
        and type(args[4]) == "number"
        and typeof(args[5]) == "CFrame"
        and type(args[6]) == "table"
        and type(args[7]) == "table"
        and type(args[8]) == "boolean"
end

local function _hook(remote)
    if _reverted[remote] then
        return
    end

    local meta = getrawmetatable(remote)
    if not meta or _original[meta] then
        return
    end

    _original[meta] = true
    setreadonly(meta, false)

    local oldIndex = meta.__index
    meta.__index = function(self, key)
        if (key == "FireServer" and self:IsA("RemoteEvent"))
            or (key == "InvokeServer" and self:IsA("RemoteFunction")) then
            return function(_, ...)
                local arguments = { ... }
                if _is_valid(arguments) and not _reverted[self] then
                    _reverted[self] = arguments
                end
                return oldIndex(self, key)(_, table.unpack(arguments))
            end
        end
        return oldIndex(self, key)
    end

    setreadonly(meta, true)
end

if getrawmetatable and setreadonly then
    for _, remote in ipairs(replicated_storage:GetDescendants()) do
        if remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction") then
            _hook(remote)
        end
    end
end

task.wait(1)

local function getScrieieRemote()
    for remote, originalArgs in pairs(_reverted) do
        if remote and remote.Parent and remote:IsA("RemoteEvent") and type(originalArgs) == "table" then
            return remote, originalArgs
        end
    end
end

-- ========================================
-- TARGET SELECTION
-- ========================================
local recentlyPickedTargets = {}

local function pick_random_target()
    local livingPlayers = {}
    for _, char in workspace.Alive:GetChildren() do
        if char.Name ~= LocalPlayer.Name and char.PrimaryPart then
            table.insert(livingPlayers, char)
        end
    end
    
    if #livingPlayers == 0 then
        CurrentTarget = nil
        return
    end
    
    if #livingPlayers == 1 then
        CurrentTarget = livingPlayers[1]
        return
    end
    
    -- Build a candidate pool excluding recently picked targets
    local candidates = {}
    for _, char in livingPlayers do
        if not recentlyPickedTargets[char.Name] then
            table.insert(candidates, char)
        end
    end
    
    -- If we've picked everyone recently, reset and exclude only the current
    if #candidates == 0 then
        recentlyPickedTargets = {}
        for _, char in livingPlayers do
            if not CurrentTarget or char.Name ~= CurrentTarget.Name then
                table.insert(candidates, char)
            end
        end
        if #candidates == 0 then
            candidates = livingPlayers
        end
    end
    
    local picked = candidates[math.random(1, #candidates)]
    recentlyPickedTargets[picked.Name] = true
    CurrentTarget = picked
end

-- Re-pick random target whenever a ball is added or its target changes
workspace.Balls.ChildAdded:Connect(function(ball)
    if _G.config.random_target then
        pick_random_target()
    end
end)

workspace.Balls.ChildAdded:Connect(function(ball)
    task.spawn(function()
        if not ball:GetAttribute("realBall") then
            local zoomies = ball:WaitForChild("zoomies", 3)
            if not zoomies then return end
        end
        ball:GetAttributeChangedSignal("target"):Connect(function()
            if _G.config.random_target then
                pick_random_target()
            end
        end)
    end)
end)

for _, ball in workspace.Balls:GetChildren() do
    task.spawn(function()
        ball:GetAttributeChangedSignal("target"):Connect(function()
            if _G.config.random_target then
                pick_random_target()
            end
        end)
    end)
end

-- ========================================
-- IDLE BYPASS (prevents being kicked for AFK)
-- ========================================
local function linear_predict(a, b, t)
    return a + (b - a) * t
end


-- ========================================
-- BALL HELPER FUNCTIONS
-- ========================================
function BallHelper.get_ball()
    for _, ball in workspace.Balls:GetChildren() do
        if ball:GetAttribute("realBall") then
            return ball
        end
    end
end

function BallHelper.get_balls()
    local balls = {}
    for _, ball in workspace.Balls:GetChildren() do
        if ball:GetAttribute("realBall") then
            table.insert(balls, ball)
        end
    end
    return balls
end

local function select_target_by_mouse()
    local livingPlayers = {}
    for _, char in workspace.Alive:GetChildren() do
        if char.Name ~= LocalPlayer.Name and char.PrimaryPart then
            table.insert(livingPlayers, char)
        end
    end
    
    local camera = workspace.CurrentCamera
    local mousePos = UserInputService:GetMouseLocation()
    local ray = camera:ScreenPointToRay(mousePos.X, mousePos.Y)
    local rayDir = ray.Direction
    
    local bestTarget
    local bestDot = -math.huge
    for _, char in livingPlayers do
        local toChar = (char.PrimaryPart.Position - camera.CFrame.Position).Unit
        local dot = rayDir:Dot(toChar)
        if dot > bestDot then
            bestDot = dot
            bestTarget = char
        end
    end
    
    CurrentTarget = bestTarget
    return bestTarget
end

function BallHelper.closest_player_by_mouse()
    if _G.config.random_target then
        if not CurrentTarget then
            pick_random_target()
        end
        return CurrentTarget
    end
    return select_target_by_mouse()
end

-- ========================================
-- CURVE CFRAME (different parry directions)
-- ========================================
function BallHelper.getCurveCFrame()
    local camera = workspace.CurrentCamera
    local hrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not hrp then return camera.CFrame end
    
    local method = _G.config.curve_method
    local target = CurrentTarget
    local targetPos = (target and target.PrimaryPart and target.PrimaryPart.Position)
        or (hrp.Position + camera.CFrame.LookVector * 1000)
    local toTarget = (targetPos - hrp.Position).Unit
    
    if method == "dot" then
        return CFrame.lookAt(hrp.Position, targetPos + Vector3.new(0, 1.75, 0))
    elseif method == "backwards" then
        return CFrame.new(hrp.Position, hrp.Position + (-toTarget) * 1000)
    elseif method == "slow" then
        return CFrame.new(hrp.Position, hrp.Position + Vector3.new(0, -350, 0))
    elseif method == "random" then
        return CFrame.new(hrp.Position, targetPos + Vector3.new(
            math.random(-1000, 1000),
            math.random(-350, 1000),
            math.random(-1000, 1000)
        ))
    else
        return camera.CFrame
    end
end

-- ========================================
-- PARRY EXECUTION
-- ========================================
local parryActive = false
local parryCount = 0
function BallHelper.parry()
    if not _G.config.random_target then
        select_target_by_mouse()
    end

    local curveCFrame = BallHelper.getCurveCFrame()

    local mouseLoc
    if _G.config.random_target and CurrentTarget and CurrentTarget.PrimaryPart then
        local viewportPt = workspace.CurrentCamera:WorldToViewportPoint(CurrentTarget.PrimaryPart.Position)
        mouseLoc = { viewportPt.X, viewportPt.Y }
    else
        local mp = UserInputService:GetMouseLocation()
        mouseLoc = { mp.X, mp.Y }
    end

    local screenPositions = {}
    for _, char in workspace.Alive:GetChildren() do
        if char.PrimaryPart then
            local ok, screenPt = pcall(function()
                return workspace.CurrentCamera:WorldToScreenPoint(char.PrimaryPart.Position)
            end)
            if ok then
                screenPositions[char.Name] = screenPt
            end
        end
    end

    -- Use the remote selected by scrieie's remote pipeline.
    local parryRemote, originalArgs = getScrieieRemote()
    if not parryRemote or not originalArgs then
        warn("[parry] scrieie remote is not ready")
        return
    end

    local token = _tokenize(originalArgs[2])
    if not token then
        warn("[parry] could not generate the scrieie token")
        return
    end

    parryRemote:FireServer(
        originalArgs[1],
        originalArgs[2],
        token,
        0.5,
        curveCFrame,
        screenPositions,
        mouseLoc,
        false
    )

    if parryCount > 7 then return false end
    parryCount += 1
    task.delay(0.5, function() if parryCount > 0 then parryCount -= 1 end end)
end

-- ========================================
-- CURVE DETECTION
-- ========================================
function BallHelper.ball_curved()
    local props = BallHelper.ball.properties
    local ball = BallHelper.get_ball()
    if not ball then return false end
    
    local zoomies = ball:FindFirstChild("zoomies")
    if not zoomies then return false end
    
    local velocity = zoomies.VectorVelocity
    local velUnit = velocity.Unit
    local toMe = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
    local dotProduct = toMe:Dot(velUnit)
    local speed = velocity.Magnitude
    local speedFactor = math.min(speed / 100, 40)
    local accelDir = (velUnit - velocity).Unit
    local crossDot = toMe:Dot(accelDir)
    local dotDifference = dotProduct - crossDot
    local distance = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
    local pingMs = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    local pingThreshold = 0.5 - (pingMs / 1000)
    local timeToImpact = distance / speed - (pingMs / 1000)
    local minDistance = 15 - math.min(distance / 1000, 15) + speedFactor
    local clampedDot = math.clamp(dotProduct, -1, 1)
    local angleRad = math.rad(math.asin(clampedDot))
    
    props.lerp_radians = linear_predict(props.lerp_radians, angleRad, 0.8)
    
    if speed > 100 and timeToImpact > pingMs / 10 then
        minDistance = math.max(minDistance - 15, 15)
    end
    
    if distance < minDistance then return false end
    if dotDifference < pingThreshold then return true end
    
    if props.lerp_radians < 0.018 then
        props.last_warping = tick()
    end
    
    if (tick() - props.last_warping) < (timeToImpact / 1.5) then return true end
    if (tick() - props.curving) < (timeToImpact / 1.5) then return true end
    
    return dotProduct < pingThreshold
end

function BallHelper.get_ball_properties(_)
    local ball = BallHelper.get_ball()
    if not ball then return end
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return end
    
    local zeroVel = Vector3.zero
    local toMe = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
    local distance = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
    local dot = toMe:Dot(zeroVel.Unit)
    return { Velocity = zeroVel, Direction = toMe, Distance = distance, Dot = dot }
end

function BallHelper.players_properties()
    local target = CurrentTarget
    if not target or not target.PrimaryPart 
        or not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then
        return false
    end
    
    local velocity = target.PrimaryPart.Velocity
    local direction = (LocalPlayer.Character.PrimaryPart.Position - target.PrimaryPart.Position).Unit
    local distance = (LocalPlayer.Character.PrimaryPart.Position - target.PrimaryPart.Position).Magnitude
    return { velocity = velocity, direction = direction, distance = distance }
end

local spamAccuracy = 0
function BallHelper.perfom_spam(args)
    local props = BallHelper.ball.properties
    local ball = BallHelper.get_ball()
    local target = CurrentTarget
    
    if not ball then return false end
    if not target or not target.PrimaryPart then return false end
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return end
    
    local velocity = ball.AssemblyLinearVelocity
    local speed = velocity.Magnitude
    local toMe = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
    local dot = toMe:Dot(velocity.Unit)
    local targetPos = target.PrimaryPart.Position
    local targetDist = LocalPlayer:DistanceFromCharacter(targetPos)
    local maxDist = args.Ping + math.min(speed / 6, 95)
    
    if args.Entity_Properties.distance > maxDist then return spamAccuracy end
    if args.Ball_Properties.Distance > maxDist then return spamAccuracy end
    if targetDist > maxDist then return spamAccuracy end
    
    local maxSpeedClamp = 5 - math.min(speed / 5, 5)
    local maxDot = math.clamp(dot, -1, 0) * maxSpeedClamp
    spamAccuracy = maxDist - maxDot
    return spamAccuracy
end

-- ========================================
-- ABILITY ESP (player name + ability over head)
-- ========================================
local PlayerESPLabels = {}

local function qolPlayerNameVisibility()
    local function createBillboardGui(player)
        local character = player.Character
        while (not character) or (not character.Parent) do
            task.wait()
            character = player.Character
        end
        
        local head = character:WaitForChild("Head")
        local billboard = Instance.new("BillboardGui")
        billboard.Adornee = head
        billboard.Size = UDim2.new(0, 200, 0, 50)
        billboard.StudsOffset = Vector3.new(0, 3, 0)
        billboard.AlwaysOnTop = true
        billboard.Parent = head
        
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(1, 0, 1, 0)
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextSize = 10
        label.TextWrapped = false
        label.BackgroundTransparency = 1
        label.TextXAlignment = Enum.TextXAlignment.Center
        label.TextYAlignment = Enum.TextYAlignment.Center
        label.Parent = billboard
        
        PlayerESPLabels[player] = label
        
        local humanoid = character:FindFirstChild("Humanoid")
        if humanoid then
            humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
        end
        
        local hbConn
        hbConn = RunService.Heartbeat:Connect(function()
            if not (character and character.Parent) then
                hbConn:Disconnect()
                billboard:Destroy()
                PlayerESPLabels[player] = nil
                return
            end
            
            if _G.config.ability_esp then
                label.Visible = true
                local ability = player:GetAttribute("EquippedAbility")
                if ability then
                    label.Text = player.DisplayName .. " [" .. ability .. "]"
                else
                    label.Text = player.DisplayName
                end
            else
                label.Visible = false
            end
        end)
    end
    
    for _, player in Players:GetPlayers() do
        if player ~= LocalPlayer then
            player.CharacterAdded:Connect(function()
                createBillboardGui(player)
            end)
            createBillboardGui(player)
        end
    end
    
    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function()
            createBillboardGui(player)
        end)
    end)
end

qolPlayerNameVisibility()

-- ========== SKIN CHANGER ==========
local swordInstancesInstance = ReplicatedStorage:WaitForChild("Shared",9e9):WaitForChild("ReplicatedInstances",9e9):WaitForChild("Swords",9e9)

local SKIN_LAST_EQUIPPED_CONFIG_KEY = "Skin.LastEquippedSword"
local AUTO_CONFIG_FILE = "LeviHubX/auto_config.json"

local function readLeviHubAutoConfig()
        local data = {}
        pcall(function()
            if isfile and isfile(AUTO_CONFIG_FILE) then
                local decoded = HttpService:JSONDecode(readfile(AUTO_CONFIG_FILE))
                if type(decoded) == "table" then
                    data = decoded
                end
            end
        end)
        return data
end

local function writeLeviHubAutoConfig(data)
        pcall(function()
            if isfolder and makefolder and not isfolder("LeviHubX") then
                makefolder("LeviHubX")
            end
            if writefile then
                writefile(AUTO_CONFIG_FILE, HttpService:JSONEncode(data or {}))
            end
        end)
end

local function loadLastEquippedSword()
        local data = readLeviHubAutoConfig()
        local saved = data[SKIN_LAST_EQUIPPED_CONFIG_KEY]
        return type(saved) == "string" and saved or ""
end

getgenv().saveLastEquippedSword = function(swordName)
        if type(swordName) ~= "string" or swordName == "" then return end
        local data = readLeviHubAutoConfig()
        data[SKIN_LAST_EQUIPPED_CONFIG_KEY] = swordName
        writeLeviHubAutoConfig(data)
end

do
        local savedLastSword = loadLastEquippedSword()
        getgenv().skinChanger = getgenv().skinChanger or savedLastSword ~= ""
        getgenv().swordModel = type(getgenv().swordModel) == "string" and getgenv().swordModel ~= "" and getgenv().swordModel or savedLastSword
        getgenv().swordAnimations = type(getgenv().swordAnimations) == "string" and getgenv().swordAnimations ~= "" and getgenv().swordAnimations or savedLastSword
        getgenv().swordFX = type(getgenv().swordFX) == "string" and getgenv().swordFX ~= "" and getgenv().swordFX or savedLastSword
end

task.spawn(function()
        local rs = game:GetService("ReplicatedStorage")
        local swordInstancesInstance = rs:WaitForChild("Shared", 9e9):WaitForChild("ReplicatedInstances", 9e9):WaitForChild("Swords", 9e9)
        local swordInstances = require(swordInstancesInstance)

        local swordsController
        task.spawn(function()
            while task.wait(0.25) and not swordsController do
                local ok, conns = pcall(getconnections, rs.Remotes.FireSwordInfo.OnClientEvent)
                if ok and conns then
                    for _, v in ipairs(conns) do
                        if v.Function and islclosure and islclosure(v.Function) then
                            local ok2, up = pcall(getupvalues, v.Function)
                            if ok2 and #up == 1 and type(up[1]) == "table" then
                                swordsController = up[1]
                                break
                            end
                        end
                    end
                end
            end
        end)

        local function getSlashName(swordName)
            local ok, sln = pcall(function() return swordInstances:GetSword(swordName) end)
            return (ok and sln and sln.SlashName) or "SlashEffect"
        end

        local function refreshSlashName()
            local fxName = getgenv().swordFX ~= "" and getgenv().swordFX or getgenv().swordModel
            if fxName ~= "" then
                getgenv().slashName = getSlashName(fxName)
            else
                getgenv().slashName = "SlashEffect"
            end
        end
        refreshSlashName()

        local function setSword()
            if not getgenv().skinChanger then return end
            if not LocalPlayer.Character then return end
            pcall(function()
                local f = rawget(swordInstances, "EquipSwordTo")
                if type(f) == "function" then
                    local ups = getupvalues(f)
                    for i = 1, #ups do
                        if type(ups[i]) == "boolean" then
                            setupvalue(f, i, false)
                            break
                        end
                    end
                end
            end)
            pcall(function()
                swordInstances:EquipSwordTo(LocalPlayer.Character, getgenv().swordModel)
            end)
            task.spawn(function()
                local attempts = 0
                while not swordsController and attempts < 20 do
                    task.wait(0.5); attempts = attempts + 1
                end
                if not swordsController then return end
                pcall(function()
                    if swordsController.SetSword then
                        swordsController:SetSword(getgenv().swordAnimations ~= "" and getgenv().swordAnimations or getgenv().swordModel)
                    end
                end)
                pcall(function()
                    local targetSword = getgenv().swordFX ~= "" and getgenv().swordFX or getgenv().swordModel
                    if rs.Remotes:FindFirstChild("FireSwordInfo") then
                        rs.Remotes.FireSwordInfo:FireServer(targetSword)
                    end
                    if swordsController.currentSword ~= nil then
                        pcall(function() swordsController.currentSword = targetSword end)
                    end
                    if swordsController.SwordFX ~= nil then
                        pcall(function() swordsController.SwordFX = targetSword end)
                    end
                end)
            end)
        end

        local hookedFuncs = {}
        task.spawn(function()
            local remotesToHook = {"ParrySuccessAll", "ParryAttempt", "ParrySuccess", "PlaySound", "PlayVisuals"}
            while task.wait(1) do
                for _, remoteName in ipairs(remotesToHook) do
                    local remote = rs.Remotes:FindFirstChild(remoteName)
                    if remote and remote:IsA("RemoteEvent") then
                        local ok, conns = pcall(getconnections, remote.OnClientEvent)
                        if ok and type(conns) == "table" then
                            for _, v in ipairs(conns) do
                                local func = v.Function
                                if func and not hookedFuncs[func] then
                                    hookedFuncs[func] = true
                                    v:Disable()
                                    local targetFunc = func
                                    local ourFunc
                                    ourFunc = function(...)
                                        local args = { ... }

                                        local isLocal = false
                                        for _, arg in ipairs(args) do
                                            if tostring(arg) == LocalPlayer.Name or (typeof(arg) == "Instance" and (arg == LocalPlayer.Character or arg == LocalPlayer)) then
                                                isLocal = true
                                                break
                                            end
                                        end

                                        if isLocal and getgenv().skinChanger then
                                            local fxSword = getgenv().swordFX ~= "" and getgenv().swordFX or getgenv().swordModel
                                            refreshSlashName()

                                            local swordFound = false
                                            local slashFound = false

                                            for i, arg in ipairs(args) do
                                                if type(arg) == "string" then
                                                    if fxSword ~= "" and not slashFound and (arg:match("Slash") or arg == "Default" or arg:match("Effect")) then
                                                        args[i] = getgenv().slashName
                                                        slashFound = true
                                                    elseif fxSword ~= "" and not swordFound then
                                                        local isSword = false
                                                        pcall(function()
                                                            if rs.Shared.ReplicatedInstances.Swords:FindFirstChild(arg) then
                                                                isSword = true
                                                            end
                                                        end)
                                                        if isSword or arg == LocalPlayer:GetAttribute("CurrentlyEquippedSword") then
                                                            args[i] = fxSword
                                                            swordFound = true
                                                        end
                                                    end
                                                end
                                            end

                                            if fxSword ~= "" and not slashFound and type(args[1]) == "string" then
                                                args[1] = getgenv().slashName
                                            end
                                            if fxSword ~= "" and not swordFound and type(args[3]) == "string" then
                                                args[3] = fxSword
                                            end
                                        end
                                        if setthreadidentity then pcall(setthreadidentity, 2) end
                                        pcall(targetFunc, unpack(args))
                                    end
                                    hookedFuncs[ourFunc] = true
                                    remote.OnClientEvent:Connect(ourFunc)
                                end
                            end
                        end
                    end
                end
            end
        end)

        getgenv().updateSword = function()
            refreshSlashName()
            if getgenv().skinChanger and getgenv().swordModel ~= "" and getgenv().saveLastEquippedSword then
            getgenv().saveLastEquippedSword(getgenv().swordModel)
            end
            setSword()
        end

        task.spawn(function()
            while task.wait(1) do
                if getgenv().skinChanger and getgenv().swordModel ~= "" then
                    local char = LocalPlayer.Character
                    if char then
                        if LocalPlayer:GetAttribute("CurrentlyEquippedSword") ~= getgenv().swordModel then
                            setSword()
                        end
                        if not char:FindFirstChild(getgenv().swordModel) then
                            setSword()
                        end
                        for _, v in pairs(char:GetChildren()) do
                            if v:IsA("Model") and v.Name ~= getgenv().swordModel then
                                v:Destroy()
                            end
                            task.wait()
                        end
                    end
                end
            end
        end)

        LocalPlayer.CharacterAdded:Connect(function()
            if getgenv().skinChanger then
                getgenv().skinChanger = false
                if getgenv().setSkinChangerToggleUI then getgenv().setSkinChangerToggleUI(false) end
                task.wait(2)
                getgenv().skinChanger = true
                if getgenv().setSkinChangerToggleUI then getgenv().setSkinChangerToggleUI(true) end
                task.wait(0.5)
                pcall(function() getgenv().updateSword() end)
            end
        end)
end)

getgenv().skinChanger=false; getgenv().skinChangerEnabled=false
getgenv().swordModel=""; getgenv().swordAnimations=""; getgenv().swordFX=""
getgenv().slashName="SlashEffect"
getgenv().saveLastEquippedSword=getgenv().saveLastEquippedSword or function() end


-- ========================================
-- ANTI PHANTOM
-- ========================================
local antiPhantomActive = false

MainTab:AddToggle("Toggle", {
    Title = "anti phantom",
    Default = _G.config.anti_phantom or false,
    Callback = function(enabled)
        _G.config.anti_phantom = enabled
        if enabled then
            Connections.anti_phantom = workspace.Runtime.ChildAdded:Connect(function(part)
                local character = LocalPlayer.Character
                if not character then return end
                if not (part.Name:lower() == "maxtransmission" or part.Name == "transmissionpart") then return end
                
                local weld = part:FindFirstChildWhichIsA("WeldConstraint")
                if not weld then return end
                
                for _, ball in workspace.Balls:GetChildren() do
                    if not ball:FindFirstChild("zoomies") then continue end
                    if antiPhantomActive then continue end
                    
                    antiPhantomActive = true
                    local cancelled = false
                    
                    task.spawn(function()
                        local startTime = tick()
                        while tick() - startTime < 1 and ball.Parent and not cancelled do
                            task.wait()
                            cloneref(game:GetService("TweenService")):Create(
                                character.HumanoidRootPart,
                                TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out),
                                { CFrame = ball.CFrame * CFrame.new(0, 0, -3) }
                            ):Play()
                        end
                        antiPhantomActive = false
                    end)
                    
                    ball:GetAttributeChangedSignal("target"):Once(function()
                        cancelled = true
                        antiPhantomActive = false
                    end)
                end
            end)
        else
            if Connections.anti_phantom then
                Connections.anti_phantom:Disconnect()
                Connections.anti_phantom = nil
            end
            antiPhantomActive = false
        end
    end
})


-- ========================================
-- AUTO PARRY
-- ========================================
_G.config.curve_method = "camera"
local accuracyMultiplier = 0.5

local AccuracyMap = {
    ["200"] = 2.582979797979786,
    ["140"] = 1.800000000000000,
    ["100"] = 1.284999999999994,
    ["90"]  = 1.1552020202020148,
    ["80"]  = 1.0254040404040357,
    ["65"]  = 0.8307070707070668,
}

MainTab:AddToggle("Toggle", {
    Title = "auto parry",
    Default = _G.config.auto_parry or false,
    Callback = function(enabled)
        _G.config.auto_parry = enabled
        if enabled then
            Connections.auto_parry = RunService.PreSimulation:Connect(function()
                if _G.triggerbot then return end
                if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return end
                
                local props = BallHelper.ball.properties
                local realBall = BallHelper.get_ball()
                local allBalls = BallHelper.get_balls()
                
                for _, ball in allBalls do
                    if not ball then return end
                    
                    local zoomies = ball:FindFirstChild("zoomies")
                    if not zoomies then return end
                    
                    ball:GetAttributeChangedSignal("target"):Once(function()
                        parryActive = false
                        if _G.config.random_target then
                            pick_random_target()
                        end
                    end)
                    
                    if parryActive then return end
                    
                    local ballTarget = ball:GetAttribute("target")
                    local realBallTarget = realBall:GetAttribute("target")
                    local velocity = zoomies.VectorVelocity
                    local distance = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
                    local pingMs = Stats.Network.ServerStatsItem["Data Ping"]:GetValue() / 10
                    local pingBase = math.clamp(pingMs / 10, 5, 17)
                    local rawSpeed = velocity.Magnitude
                    local speedAdjusted = math.min(math.max(rawSpeed - 9.5, 0), 650)
                    local speedCoefficient = 2.4 + speedAdjusted * 0.002
                    local accuracyFactor = accuracyMultiplier
                    local scaledAg = speedCoefficient * accuracyMultiplier
                    local targetDistance = pingBase + math.max(rawSpeed / scaledAg, 9.5)
                    local isCurving = BallHelper.ball_curved()
                    
                    if ball:FindFirstChild("AeroDynamicSlashVFX") then
                        Debris:AddItem(ball.AeroDynamicSlashVFX, 0)
                        props.aerodynamic_time = tick()
                    end
                    
                    if workspace.Runtime:FindFirstChild("Tornado") then
                        local tornadoTime = workspace.Runtime.Tornado:GetAttribute("TornadoTime") or 1
                        if (tick() - props.aerodynamic_time) < tornadoTime + 0.314159 then
                            return
                        end
                    end
                    
                    if realBallTarget == LocalPlayer.Name and isCurving then return end
                    
                    if ballTarget == LocalPlayer.Name and distance <= targetDistance and accuracyFactor * 0.8 then
                        BallHelper.parry(_G.config.curve_method)
                        parryActive = true
                    end
                    
                    local startTime = tick()
                    repeat
                        RunService.PreSimulation:Wait()
                    until (tick() - startTime) >= 1 or not parryActive
                    parryActive = false
                end
            end)
        else
            if Connections.auto_parry then
                Connections.auto_parry:Disconnect()
                Connections.auto_parry = nil
            end
        end
    end
})

-- ========================================
-- CHAIN PARRY
-- ========================================
ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(_, parrier)
    if parrier.Parent and parrier.Parent ~= LocalPlayer.Character then
        if parrier.Parent.Parent ~= workspace.Alive then return end
    end
    
    local ball = BallHelper.get_ball()
    if not ball then return end
    if not CurrentTarget or not CurrentTarget.PrimaryPart then return end
    
    local distToTarget = (LocalPlayer.Character.PrimaryPart.Position - CurrentTarget.PrimaryPart.Position).Magnitude
    local distToBall = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
    local toBall = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
    local dot = toBall:Dot(ball.AssemblyLinearVelocity.Unit)
    local isCurving = BallHelper.ball_curved()
    
    if distToTarget < 15 and distToBall < 15 and dot > -0.25 then
        if isCurving then
            BallHelper.parry(_G.config.curve_method)
        end
    end
    
    if not CurrentAnimTrack then return end
    CurrentAnimTrack:Stop()
end)

ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
    if LocalPlayer.Character.Parent ~= workspace.Alive then return end
    if not CurrentAnimTrack then return end
    CurrentAnimTrack:Stop()
end)

workspace.Balls.ChildRemoved:Connect(function(_)
    parryCount = 0
    parryActive = false
    CurrentTarget = nil
    recentlyPickedTargets = {}
    if Connections.target_change then
        Connections.target_change:Disconnect()
        Connections.target_change = nil
    end
end)

ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(_, parrier)
    local myHrp = LocalPlayer.Character.PrimaryPart
    local ball = BallHelper.get_ball()
    if not ball then return end
    
    local zoomies = ball:FindFirstChild("zoomies")
    if not zoomies then return end
    
    local speed = zoomies.VectorVelocity.Magnitude
    local distance = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
    local velocity = zoomies.VectorVelocity
    local velUnit = velocity.Unit
    local toMe = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
    toMe:Dot(velUnit)
    
    local pingMs = Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
    local speedFactor = math.min(speed / 100, 40)
    local timeToImpact = distance / speed - (pingMs / 1000)
    local isFast = speed > 100
    local minDistance = 15 - math.min(distance / 1000, 15) + speedFactor
    
    if isFast and timeToImpact > pingMs / 10 then
        minDistance = math.max(minDistance - 15, 15)
    end
    
    if parrier ~= myHrp and distance > minDistance then
        BallHelper.ball.properties.curving = tick()
    end
end)

-- ========================================
-- ACCURACY DROPDOWN
-- ========================================
local savedAcc = tostring(_G.config.accuracy or 100)
if not AccuracyMap[savedAcc] then savedAcc = "100" end
accuracyMultiplier = AccuracyMap[savedAcc]

MainTab:AddDropdown("DropdownAccuracy", {
    Title = "accuracy",
    Values = { "200", "140", "100", "90", "80", "65" },
    Multi = false,
    Default = savedAcc,
    Callback = function(value)
        task.spawn(function()
            local mult = AccuracyMap[value]
            if mult then
                accuracyMultiplier = mult
                _G.config.accuracy = tonumber(value)
            end
        end)
    end
})

-- ========================================
-- RANDOM TARGET
-- ========================================
MainTab:AddToggle("Toggle", {
    Title = "random target",
    Default = _G.config.random_target or false,
    Callback = function(enabled)
        task.spawn(function()
            _G.config.random_target = enabled
            CurrentTarget = nil
            recentlyPickedTargets = {}
            if enabled then
                pick_random_target()
            end
        end)
    end
})

-- ========================================
-- CURVE METHOD DROPDOWN + HOTKEYS
-- ========================================
local curveMethodDropdown = MainTab:AddDropdown("Dropdown", {
    Title = "curve method",
    Values = { "camera", "dot", "backwards", "slow", "random" },
    Multi = false,
    Default = _G.config.curve_method or "camera",
    Callback = function(value)
        task.spawn(function()
            _G.config.curve_method = value
        end)
    end
})

local CurveHotkeys = {
    [Enum.KeyCode.One]   = "camera",
    [Enum.KeyCode.Two]   = "dot",
    [Enum.KeyCode.Three] = "backwards",
    [Enum.KeyCode.Four]  = "slow",
    [Enum.KeyCode.Five]  = "random",
}

local lastSetCurveMethod
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if not _G.config.curve_keybind then return end
    
    local newMethod = CurveHotkeys[input.KeyCode]
    if not newMethod then return end
    
    if _G.config.curve_method == newMethod then
        if _G.config.curve_notify then
            Fluent:Notify({ Title = "curve method", Content = "already " .. newMethod, Duration = 3 })
        end
        return
    end
    
    _G.config.curve_method = newMethod
    curveMethodDropdown:SetValue(newMethod)
    lastSetCurveMethod = newMethod
    
    if _G.config.curve_notify then
        Fluent:Notify({ Title = "curve method", Content = newMethod, Duration = 3 })
    end
end)

MainTab:AddToggle("Toggle", {
    Title = "hotkey curve",
    Default = _G.config.curve_keybind or false,
    Callback = function(enabled)
        task.spawn(function()
            _G.config.curve_keybind = enabled
        end)
    end
})

MainTab:AddToggle("Toggle", {
    Title = "hotkey notify",
    Default = _G.config.curve_notify or false,
    Callback = function(enabled)
        task.spawn(function()
            _G.config.curve_notify = enabled
        end)
    end
})

-- ========================================
-- THUNDER DASH 0 COOLDOWN (Fallen)
-- ========================================
local thunderDashAbility
local thunderDashOriginalCooldown
local thunderDashOriginalReduction
local thunderDashLoopToken = 0

local function ensureThunderDashAbility()
    if thunderDashAbility then
        return true
    end

    local shared = ReplicatedStorage:FindFirstChild("Shared")
    local abilities = shared and shared:FindFirstChild("Abilities")
    local abilityModule = abilities and abilities:FindFirstChild("Thunder Dash")
    if not abilityModule then
        return false
    end

    local ok, result = pcall(require, abilityModule)
    if not ok or not result then
        return false
    end

    thunderDashAbility = result
    thunderDashOriginalCooldown = result.cooldown
    thunderDashOriginalReduction = result.cooldownReductionPerUpgrade
    return true
end

local function applyThunderDashNoCooldown()
    if not ensureThunderDashAbility() then
        return false
    end

    local ok = pcall(function()
        thunderDashAbility.cooldown = 0
        thunderDashAbility.cooldownReductionPerUpgrade = 0
    end)
    return ok
end

local function restoreThunderDashCooldown()
    if not thunderDashAbility then
        return
    end

    pcall(function()
        thunderDashAbility.cooldown = thunderDashOriginalCooldown
        thunderDashAbility.cooldownReductionPerUpgrade = thunderDashOriginalReduction
    end)
end

local function startThunderDashNoCooldown()
    thunderDashLoopToken += 1
    local token = thunderDashLoopToken

    applyThunderDashNoCooldown()
    task.spawn(function()
        while thunderDashLoopToken == token do
            applyThunderDashNoCooldown()
            task.wait(0.5)
        end
    end)
end

local function stopThunderDashNoCooldown()
    thunderDashLoopToken += 1
    restoreThunderDashCooldown()
end

MainTab:AddToggle("Toggle", {
    Title = "Thunder Dash 0 Cooldown",
    Default = _G.config.thunder_dash_no_cooldown or false,
    Callback = function(enabled)
        _G.config.thunder_dash_no_cooldown = enabled
        if enabled then
            startThunderDashNoCooldown()
        else
            stopThunderDashNoCooldown()
        end
    end
})


-- ========================================
-- TRIGGERBOT
-- ========================================
local triggerActive = false
local function Trigger(ball)
    if triggerActive then return end
    triggerActive = true
    BallHelper.parry()
    
    ball:GetAttributeChangedSignal("target"):Once(function()
        triggerActive = false
    end)
    
    local startTime = tick()
    task.spawn(function()
        repeat
            RunService.PreSimulation:Wait()
        until (tick() - startTime >= 1 or not triggerActive)
        triggerActive = false
    end)
end

MainTab:AddKeybind("", {
    Title = "triggerbot",
    Mode = "Toggle",
    Default = "T",
    Callback = function(enabled)
        _G.triggerbot = enabled
        if enabled then
            Fluent:Notify({ Title = "triggerbot", Content = "on", Duration = 2 })
            Connections.triggerbot = RunService.PreSimulation:Connect(function()
                local ball = BallHelper.get_ball()
                if not ball then return end
                local target = ball:GetAttribute("target")
                if target == LocalPlayer.Name then
                    Trigger(ball)
                end
            end)
        else
            Fluent:Notify({ Title = "triggerbot", Content = "off", Duration = 2 })
            if Connections.triggerbot then
                Connections.triggerbot:Disconnect()
                Connections.triggerbot = nil
            end
        end
    end
})

-- ========================================
-- AUTO SPAM
-- ========================================
local statsService = game:GetService("Stats")
local lastAutoParryFire = 0

MainTab:AddToggle("Toggle", {
    Title = "auto spam",
    Default = _G.config.auto_spam or false,
    Callback = function(enabled)
        _G.config.auto_spam = enabled
        if enabled then
            Connections.auto_spam = RunService.PreSimulation:Connect(function()
                local ball = BallHelper.get_ball()
                if not ball then return end
                
                local zoomies = ball:FindFirstChild("zoomies")
                if not zoomies then return end
                
                local target = CurrentTarget
                if not target or not target.PrimaryPart then return end
                
                local targetPos = target.PrimaryPart.Position
                if not targetPos then return end
                
                local pingMs = statsService.Network.ServerStatsItem["Data Ping"]:GetValue()
                local fireDelay = pingMs / 1000
                
                local pingClamped = math.clamp(pingMs / 10, 1, 16)
                local ballTarget = ball:GetAttribute("target")
                local ballProps = BallHelper:get_ball_properties()
                local playerProps = BallHelper:players_properties()
                local maxAccuracy = BallHelper.perfom_spam({
                    Ball_Properties = ballProps,
                    Entity_Properties = playerProps,
                    Ping = pingClamped,
                })
                
                local targetDist = LocalPlayer:DistanceFromCharacter(targetPos)
                local toBall = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
                local velUnit = zoomies.VectorVelocity.Unit
                toBall:Dot(velUnit)
                local ballDist = LocalPlayer:DistanceFromCharacter(ball.Position)
                
                if not ballTarget then return end
                if targetDist > maxAccuracy or ballDist > maxAccuracy then return end
                
                local pulsed = LocalPlayer.Character:GetAttribute("Pulsed")
                if pulsed then return end
                
                if ballTarget == LocalPlayer.Name and targetDist > 30 and ballDist > 30 then return end
                
                local threshold = _G.config.spam_threshold
                
                if ballDist <= maxAccuracy and parryCount > threshold then
                    if tick() - lastAutoParryFire >= fireDelay then
                        lastAutoParryFire = tick()
                        BallHelper.parry()
                    end
                end
            end)
        else
            if Connections.auto_spam then
                Connections.auto_spam:Disconnect()
                Connections.auto_spam = nil
            end
        end
    end
})

MainTab:AddSlider("Slider", {
    Title = "threshold",
    Description = "",
    Default = _G.config.spam_threshold or 3,
    Min = 1,
    Max = 3,
    Rounding = 1,
    Callback = function(value)
        task.spawn(function()
            _G.config.spam_threshold = tonumber(value)
        end)
    end
})

-- ========================================
-- MANUAL SPAM
-- ========================================
UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.E then
        _G.manual_spam = not _G.manual_spam
    end
end)

local manualSpamKeybind = MainTab:AddKeybind("Keybind", {
    Title = "manual spam",
    Mode = "Toggle",
    Default = _G.config.manual_spam or "E",
    Callback = function(enabled)
        if enabled then
            local statsSvc = game:GetService("Stats")
            local lastParryTick = 0
            
            Connections.manual_spam = RunService.PreSimulation:Connect(function()
                local ping = statsSvc.Network.ServerStatsItem["Data Ping"]:GetValue()
                local delay = ping / 1000
                
                if tick() - lastParryTick >= delay then
                    lastParryTick = tick()
                    BallHelper.parry()
                end
            end)
            
            if _G.config.manual_notify then
                Fluent:Notify({ Title = "manual spam", Content = "on", Duration = 2 })
            end
        else
            if Connections.manual_spam then
                Connections.manual_spam:Disconnect()
                Connections.manual_spam = nil
            end
            if _G.config.manual_notify then
                Fluent:Notify({ Title = "manual spam", Content = "off", Duration = 2 })
            end
        end
    end
})

manualSpamKeybind:OnChanged(function(value)
    _G.config.manual_spam = value
end)

MainTab:AddToggle("Toggle", {
    Title = "manual notify",
    Default = _G.config.manual_notify or false,
    Callback = function(enabled)
        _G.config.manual_notify = enabled
    end
})

-- ========================================
-- VISUAL TAB - SWORD CHANGER (TOP)
-- Source: paid_lastesap (1).txt
-- Order: Sword Changer -> Sword Name -> Save Last Equipped Sword
-- ========================================
local skinChangerToggle
local savedSwordForUI = loadLastEquippedSword()
if getgenv().swordModel == "" and savedSwordForUI ~= "" then
    getgenv().swordModel = savedSwordForUI
    getgenv().swordAnimations = savedSwordForUI
    getgenv().swordFX = savedSwordForUI
end

skinChangerToggle = VisualTab:AddToggle("SkinChanger", {
    Title = "Sword Changer",
    Default = getgenv().skinChanger or false,
    Callback = function(value)
        getgenv().skinChanger = value
        getgenv().skinChangerEnabled = value
        _G.config.skin_changer = value
        task.spawn(function()
            if value and getgenv().swordModel ~= "" then
                if getgenv().updateSword then pcall(getgenv().updateSword) end
            end
        end)
    end
})

getgenv().setSkinChangerToggleUI = function(value)
    getgenv().skinChanger = value
    getgenv().skinChangerEnabled = value
    pcall(function()
        if skinChangerToggle and skinChangerToggle.Value ~= value then
            skinChangerToggle:SetValue(value)
        end
    end)
end

VisualTab:AddInput("SwordName", {
    Title = "Sword Name",
    Default = (getgenv().swordModel ~= "" and getgenv().swordModel) or loadLastEquippedSword(),
    Placeholder = "Enter sword name (e.g. DualPrince)...",
    Numeric = false,
    Finished = true,
    Callback = function(value)
        value = tostring(value or "")
        getgenv().swordModel = value
        getgenv().swordAnimations = value
        getgenv().swordFX = value
        _G.config.names = value
        if getgenv().skinChanger and value ~= "" and getgenv().updateSword then
            pcall(getgenv().updateSword)
        end
        if getgenv().autoLoadLastSword ~= false and getgenv().saveLastEquippedSword and value ~= "" then
            pcall(getgenv().saveLastEquippedSword, value)
        end
    end
})

VisualTab:AddToggle("SaveLastSword", {
    Title = "Save Last Equipped Sword",
    Default = true,
    Callback = function(value)
        getgenv().autoLoadLastSword = value
    end
})


-- ========================================
-- VISUAL TAB - ABILITY ESP
-- ========================================
VisualTab:AddToggle("Toggle", {
    Title = "ability esp",
    Default = _G.config.ability_esp or false,
    Callback = function(enabled)
        _G.config.ability_esp = enabled
        for _, label in pairs(PlayerESPLabels) do
            label.Visible = enabled
        end
    end
})

-- ========================================
-- BALL STATS
-- ========================================
local ballStatsGui
VisualTab:AddToggle("Toggle", {
    Title = "ball stats",
    Default = _G.config.ball_debug or false,
    Callback = function(enabled)
        _G.config.ball_debug = enabled
        if enabled then
            ballStatsGui = Instance.new("ScreenGui")
            ballStatsGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
            ballStatsGui.ResetOnSpawn = false
            
            local label = Instance.new("TextLabel")
            label.Parent = ballStatsGui
            label.Size = UDim2.new(0.2, 0, 0.05, 0)
            label.Position = UDim2.new(0.7, 0, 0.1, 0)
            label.TextSize = 26
            label.BackgroundTransparency = 1
            label.TextColor3 = Color3.new(1, 1, 1)
            label.Font = Enum.Font.Fantasy
            label.Text = "waiting..."
            
            local maxPerBall = {}
            
            Connections.ball_stats = RunService.Heartbeat:Connect(function()
                local balls = BallHelper.get_balls() or {}
                if #balls == 0 then
                    label.Text = "waiting..."
                    label.TextColor3 = Color3.new(1, 1, 1)
                    return
                end
                
                for ball in pairs(maxPerBall) do
                    if not table.find(balls, ball) then maxPerBall[ball] = nil end
                end
                
                local highestSpeed = 0
                local fastestBall
                for _, ball in ipairs(balls) do
                    local zoomies = ball:FindFirstChild("zoomies")
                    if zoomies then
                        local speed = zoomies.VectorVelocity.Magnitude
                        local prev = maxPerBall[ball] or 0
                        local new = math.max(prev, speed)
                        maxPerBall[ball] = new
                        if new > highestSpeed then
                            highestSpeed = new
                            fastestBall = ball
                        end
                    end
                end
                
                if fastestBall then
                    local speed = highestSpeed
                    local atLimit = speed >= 2200
                    local text = ("ball velocity: %.0f"):format(speed)
                    if atLimit then text = text .. " (LIMIT!)" end
                    label.Text = text
                    label.TextColor3 = atLimit and Color3.new(1, 0, 0) or Color3.new(1, 1, 1)
                else
                    label.Text = "waiting..."
                    label.TextColor3 = Color3.new(1, 1, 1)
                end
            end)
        else
            if Connections.ball_stats then
                Connections.ball_stats:Disconnect()
                Connections.ball_stats = nil
            end
            if ballStatsGui then
                ballStatsGui:Destroy()
                ballStatsGui = nil
            end
        end
    end
})
