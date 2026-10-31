-- Oxyo Hub (Blade Ball) rebuilt on BobloUI
-- UI layer replaced with BobloUI 0.11.5-beta.1; feature logic preserved.

local BobloUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/bobloscript/BobloUI/main/dist/BobloUI.min.lua"))
if type(BobloUI) ~= "function" then
    return warn("[Oxyo Hub] BobloUI failed to load: executor returned a compile error or no HTTP access")
end
BobloUI = BobloUI()
if type(BobloUI) ~= "table" then
    return warn("[Oxyo Hub] BobloUI loaded but did not return the library")
end

-- Stop any previous run of this hub before building a new one.
if getgenv().OXYO_CONNECTIONS then
    pcall(function() getgenv().OXYO_CONNECTIONS:disconnect_all() end)
end
if getgenv().OXYO_AICOROUTINE then
    pcall(task.cancel, getgenv().OXYO_AICOROUTINE)
    getgenv().OXYO_AICOROUTINE = nil
end
for _, leftover in ipairs(workspace:GetChildren()) do
    if leftover.Name == "OxyoViz" or leftover.Name == "OxyoMusic" then
        leftover:Destroy()
    end
end

local Connections = setmetatable({
    disconnect = function(self, connection)
        if not self[connection] then
            return
        end

        self[connection]:Disconnect()
        self[connection] = nil
    end,
    disconnect_all = function(self)
        for _, value in self do
            if typeof(value) == "function" then
                continue
            end

            value:Disconnect()
        end
    end
}, {})
getgenv().OXYO_CONNECTIONS = Connections

local Cleanup -- forward declaration, assigned at the bottom of the script

local UI = BobloUI:CreateWindow({
    Id = "OxyoHub",
    Title = "Oxyo Hub",
    Icon = "sword",
    ConfigFolder = "OxyoHub",
    AutoLoad = true,
    RestoreButton = {
        Icon = "sword",
        Size = Vector2.new(38, 38),
    },
    OnUnload = function()
        if Cleanup then
            Cleanup()
        end
    end,
})

-- Brand theme: dark green in the spirit of the original hub
UI:RegisterTheme("Oxyo", {
    Canvas = Color3.fromHex("#060D08"),
    Background = Color3.fromHex("#0A140C"),
    Sidebar = Color3.fromHex("#0C1A0E"),
    Surface = Color3.fromHex("#102012"),
    SurfaceRaised = Color3.fromHex("#152817"),
    SurfaceInset = Color3.fromHex("#081209"),
    SurfaceSecondary = Color3.fromRGB(18, 33, 20),
    SurfaceHover = Color3.fromRGB(24, 45, 26),
    SurfaceActive = Color3.fromRGB(29, 53, 31),
    Control = Color3.fromRGB(22, 44, 24),
    ControlHover = Color3.fromRGB(28, 54, 30),
    ControlPressed = Color3.fromRGB(34, 64, 36),
    ControlInset = Color3.fromRGB(11, 22, 12),
    BorderSubtle = Color3.fromRGB(28, 48, 30),
    Border = Color3.fromRGB(42, 74, 44),
    BorderStrong = Color3.fromRGB(58, 99, 60),
    Text = Color3.fromRGB(232, 245, 233),
    TextSecondary = Color3.fromRGB(156, 201, 160),
    TextTertiary = Color3.fromRGB(107, 147, 112),
    TextDisabled = Color3.fromRGB(74, 107, 78),
    Accent = Color3.fromRGB(79, 191, 88),
    Success = Color3.fromRGB(76, 201, 76),
    Warning = Color3.fromRGB(224, 184, 76),
    Error = Color3.fromRGB(224, 85, 85),
    Info = Color3.fromRGB(85, 168, 224),
    Scrim = Color3.fromRGB(0, 0, 0),
    ScrimTransparency = 0.5,
})

-- Apply the brand theme unless the player saved their own default theme
do
    local savedDefault = UI.GetDefaultTheme and UI:GetDefaultTheme() or nil
    if not savedDefault or savedDefault == "Dark" or savedDefault == "Light" then
        UI:SetTheme("Oxyo")
    end
end

repeat task.wait() until game:IsLoaded()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TweenService = game:GetService("TweenService")
local Debris = game:GetService("Debris")
local GuiService = game:GetService("GuiService")
local ContextActionService = game:GetService("ContextActionService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local Alive = Workspace:FindFirstChild("Alive")
Aerodynamic = false
AeroTime = tick()
AeroDynamicDetected = false
AeroDynamicTime = tick()
LastInput = UserInputService:GetLastInputType()
MouseLoc = nil
GrabParry = nil
Remotes = {}
ParryRemotes = {}
OriginalMetas = {}
Parries = 0
AnimStorage = {}
CurrentAnim = nil
AnimTrack = nil

Parried = false
LobbyParried = false
Previous_Velocity = {}
PeakVel = 0
Randomized_ParryAccuracy = false
Singularity_Detection = false
Infinity_Detection = false
CooldownProtection = false
Death_Slash_Detection = false
Speed_Divisor_Multiplier = 1.0
DeathSlashDetection = false
Infinity_Ball = false
ParryCD = LocalPlayer.PlayerGui.Hotbar.Block.UIGradient
LobbyParryType = "Keypress"
AutoParryType = "Keypress"
TriggerbotType = "Keypress"
AutoSpamType = "Keypress"
SpamMode = "Legit"
Curve_Time = tick()
Current_Anim_Track = nil
Has_Parried_Once = false
Previous_Positions = {}
Lerp_Radians = 0
Last_Warp_Time = tick()
AntiPhantomEnabled = false
Phantom = false
Ball_Distance = 30
Speed_Multiplier = 50
Turn_Radius = 10
Jump_Chance = 50
Double_Jump_Chance = 20
Can_Jump = false
Is_Spamming = false
Last_Spam_End_Time = 0
Music = nil
SelectedSong = "EEYUH!"
MusicVolume = 5
PredictedPositions = {}
MaxPredictions = 5
LastJumpTime = 0
JumpCooldown = 2
Spam_End_Time = 0
KorbloxConnection = nil
IsAutoSpamming = false
Check_Refresh = nil
AntiAFKConnection = nil
PingHistory = {}
MaxPingHistory = 3
ClashStartTime = 0
ClashEndTime = 0
OriginalFaceTexture = nil
HeadDecalConnection = nil
LastAnimTime = 0
SpamCoroutine = nil
LastSpamTime = 0
SpamDelay = 0.05
LastClickTime = 0
HighPingCompensation = false
Tornado_Time = 0
Use_Ability = ReplicatedStorage.Remotes.AbilityButtonPress
Parry_Requirements = 0
wasBackwards = {}
KeypressAutoCurve = false
SelectedParryType = "Camera"
SelectedTriggerParryType = "Camera"
KeypressCurveMethod = "Smooth"
currentToTween = nil
currentBackTween = nil
HighPingProtection = false
TriggerHighPingProtection = false
TriggerSingularity_Detection = false
TriggerInfinity_Detection = false
TriggerDeathSlash_Detection = false
AutoPostParry = false
PostParryTarget = nil
PostParryVelocityHistory = {}
PostParryScheduled = {}
BallSenderTracking = {}
selectedTarget = nil
cameraLockConn = nil
displayToChar = {}
Closest_Entity = nil
soundOptions = {
    ["EEYUH!"] = "rbxassetid://16190782181",
    ["Skibidi Toilet"] = "rbxassetid://122353792844213",
    ["DEKUD"] = "rbxassetid://124760595693133",
    ["Everybody Wants To Rule The World"] = "rbxassetid://87209527034670",
    ["CHWYKU"] = "rbxassetid://80796352391107",
    ["ULTCHILL FUNK"] = "rbxassetid://103283136727523",
    ["VEM VEM CHILL FUNK"] = "rbxassetid://70870883948497",
    ["Rat Dance Remake"] = "rbxassetid://133496635668044",
    ["tobreak"] = "rbxassetid://111557295232821",
    ["Rise to the Horizon"] = "rbxassetid://72573266268313",
    ["Echoes of the Candy Kingdom"] = "rbxassetid://103040477333590",
    ["Speed"] = "rbxassetid://125550253895893",
    ["Lo-fi Chill A"] = "rbxassetid://9043887091",
    ["Lo-fi Ambient"] = "rbxassetid://129775776987523",
    ["Tears in the Rain"] = "rbxassetid://129710845038263"
}

function Update_Ping()
    local currentPing = game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue()
    table.insert(PingHistory, 1, currentPing)
    if #PingHistory > MaxPingHistory then
        table.remove(PingHistory, #PingHistory)
    end
end
function GetAveragePing()
    if #PingHistory == 0 then return 0 end
    local sum = 0
    for _, ping in ipairs(PingHistory) do
        sum = sum + ping
    end
    return sum / #PingHistory
end
function IsValidRemoteArgs(args)
    return #args == 7 and
           type(args[2]) == "string" and
           type(args[3]) == "number" and
           typeof(args[4]) == "CFrame" and
           type(args[5]) == "table" and
           type(args[6]) == "table" and
           type(args[7]) == "boolean"
end
local Is_Supported_Test = typeof(hookmetamethod) == "function"
local oldIndex
if Is_Supported_Test then
    oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
        if (key == "FireServer" and self:IsA("RemoteEvent")) or (key == "InvokeServer" and self:IsA("RemoteFunction")) then
            return function(_, ...)
                local args = {...}
                if IsValidRemoteArgs(args) then
                    if not ParryRemotes[self] then
                        ParryRemotes[self] = args
                    end
                end
                return oldIndex(self, key)(_, unpack(args))
            end
        end
        return oldIndex(self, key)
    end))
end
for _, anim in pairs(ReplicatedStorage.Misc.Emotes:GetChildren()) do
    if anim:IsA("Animation") and anim:GetAttribute("EmoteName") then
        AnimStorage[anim:GetAttribute("EmoteName")] = anim
    end
end
local AutoParry = {}
AutoParry.Previous_Positions = {}
AutoParry.Velocity_History = {}
AutoParry.Dot_Histories = {}
AutoParry.Previous_Speeds = {}
AutoParry.Distance_History = {}
AutoParry.Previous_Velocities = {}
AutoParry.ParryAnim = function(useGrabParryOnly)
    local ParryAnim
    if useGrabParryOnly then
        ParryAnim = Instance.new("Animation")
        ParryAnim.AnimationId = "rbxassetid://14909890816"
    else
        ParryAnim = ReplicatedStorage.Shared.SwordAPI.Collection.Default:FindFirstChild("GrabParry")
        if not ParryAnim then
            ParryAnim = Instance.new("Animation")
            ParryAnim.AnimationId = "rbxassetid://14909890816"
        end
    end
    local CurrentSword = LocalPlayer.Character:GetAttribute("CurrentlyEquippedSword")
    if not CurrentSword then return end
    local SwordData = ReplicatedStorage.Shared.ReplicatedInstances.Swords.GetSword:Invoke(CurrentSword)
    if not SwordData or not SwordData['AnimationType'] then return end
    for _, obj in pairs(ReplicatedStorage.Shared.SwordAPI.Collection:GetChildren()) do
        if obj.Name == SwordData['AnimationType'] then
            if useGrabParryOnly and obj:FindFirstChild("GrabParry") then
                ParryAnim = obj:FindFirstChild("GrabParry")
            elseif not useGrabParryOnly then
                ParryAnim = obj:FindFirstChild("GrabParry") or obj:FindFirstChild("Grab")
            end
        end
    end
    if not ParryAnim then
        ParryAnim = Instance.new("Animation")
        ParryAnim.AnimationId = "rbxassetid://14909890816"
    end
    Current_Anim_Track = LocalPlayer.Character.Humanoid.Animator:LoadAnimation(ParryAnim)
    if Current_Anim_Track then
        Current_Anim_Track.Priority = Enum.AnimationPriority.Action
        Current_Anim_Track:Play()
    end
end
AutoParry.PlayAnim = function(animName)
    local Anims = AnimStorage[animName]
    if not Anims then return false end
    local Animator = LocalPlayer.Character.Humanoid.Animator
    if AnimTrack and AnimTrack:IsA("AnimationTrack") then
        AnimTrack:Stop()
    end
    AnimTrack = Animator:LoadAnimation(Anims)
    if AnimTrack and AnimTrack:IsA("AnimationTrack") then
        AnimTrack:Play()
    end
    CurrentAnim = animName
end
AutoParry.GetBalls = function()
    local Balls = {}
    for _, instance in pairs(Workspace.Balls:GetChildren()) do
        if instance:GetAttribute("realBall") then
            instance.CanCollide = false
            table.insert(Balls, instance)
        end
    end
    return Balls
end
AutoParry.GetBall = function()
    for _, instance in pairs(Workspace.Balls:GetChildren()) do
        if instance:GetAttribute("realBall") then
            instance.CanCollide = false
            return instance
        end
    end
end
AutoParry.GetLobbyBalls = function()
    local LobbyBalls = {}
    for _, instance in pairs(Workspace.TrainingBalls:GetChildren()) do
        if instance:IsA("BasePart") and instance:GetAttribute("realBall") then
            instance.CanCollide = false
            table.insert(LobbyBalls, instance)
        end
    end
    return LobbyBalls
end
AutoParry.Linear_Interpolation = function(a, b, time_volume)
    return a + (b - a) * time_volume
end
AutoParry.IsCurved = function(ball)
    if not ball then return false, false end
    local Zoomies = ball:FindFirstChild('zoomies')
    if not Zoomies then return false, false end
    local Velocity = Zoomies.VectorVelocity
    local Speed = Velocity.Magnitude
    if Speed < 60 then return false, false end
    if not AutoParry.Velocity_History[ball] or #AutoParry.Velocity_History[ball] < 2 then
        return false, false
    end
    if not AutoParry.Dot_Histories[ball] or #AutoParry.Dot_Histories[ball] < 2 then
        return false, false
    end
    local Ball_Direction = Velocity.Unit
    local Direction = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
    local Dot = Direction:Dot(Ball_Direction)
    local Speed_Threshold = math.min(Speed / 100, 40)
    local Angle_Threshold = 40 * math.max(Dot, 0)
    local Distance = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
    local baseDotThreshold = 0.15
    if Speed > 600 then
        baseDotThreshold = -0.1
    elseif Speed > 400 then
        baseDotThreshold = 0.0
    elseif Speed > 200 then
        baseDotThreshold = 0.1
    end
    local Dot_Threshold = baseDotThreshold - (GetAveragePing() / 2000) - math.min(Speed / 4000, 0.1)
    local Reach_Time = Distance / Speed - (GetAveragePing() / 1000)
    local Ball_Distance_Threshold = 15 - math.min(Distance / 1000, 15) + Speed_Threshold
    local Clamped_Dot = math.clamp(Dot, -1, 1)
    local Radians = math.asin(math.abs(Clamped_Dot))
    Lerp_Radians = AutoParry.Linear_Interpolation(Lerp_Radians, Radians, 0.8)
    if Speed > 100 and Reach_Time > GetAveragePing() / 10 then
        Ball_Distance_Threshold = math.max(Ball_Distance_Threshold - 15, 15)
    end
    if Lerp_Radians < 0.018 then
        Last_Warp_Time = tick()
    end
    if (tick() - Last_Warp_Time) < (Reach_Time / 1.5) then
        return true, false
    end
    if (tick() - Curve_Time) < (Reach_Time / 1.5) then
        return true, false
    end
    local backwardsCurveDetected = false
    local backwardsAngleThreshold = 60
    if Speed > 600 then
        backwardsAngleThreshold = 50
    elseif Speed > 400 then
        backwardsAngleThreshold = 55
    else
        backwardsAngleThreshold = 65
    end
    local playerPos = LocalPlayer.Character.PrimaryPart.Position
    local ballPos = ball.Position
    local horizDirection = Vector3.new(playerPos.X - ballPos.X, 0, playerPos.Z - ballPos.Z)
    if horizDirection.Magnitude > 0 then
        horizDirection = horizDirection.Unit
    end
    local awayFromPlayer = -horizDirection
    local horizBallDir = Vector3.new(Ball_Direction.X, 0, Ball_Direction.Z)
    if horizBallDir.Magnitude > 0 then
        horizBallDir = horizBallDir.Unit
        local backwardsAngle = math.deg(math.acos(math.clamp(awayFromPlayer:Dot(horizBallDir), -1, 1)))
        if backwardsAngle < backwardsAngleThreshold and Distance > 30 then
            backwardsCurveDetected = true
        end
    end
    local directionChanged = false
    local changeThreshold = 0.80
    if Speed > 600 then
        changeThreshold = 0.75
    elseif Speed > 400 then
        changeThreshold = 0.78
    end
    if AutoParry.Velocity_History[ball] and #AutoParry.Velocity_History[ball] >= 4 then
        local prevVel = AutoParry.Velocity_History[ball][#AutoParry.Velocity_History[ball] - 1]
        if prevVel.Magnitude > 100 and Speed > 100 then
            local prevDir = prevVel.Unit
            local currDir = Ball_Direction
            local dotChange = prevDir:Dot(currDir)
            if dotChange < changeThreshold then
                directionChanged = true
            end
        end
    end
    local dotVariance = 0
    local significantVariance = false
    if AutoParry.Dot_Histories[ball] and #AutoParry.Dot_Histories[ball] >= 5 then
        local hist = AutoParry.Dot_Histories[ball]
        for i = 2, #hist do
            dotVariance = dotVariance + math.abs(hist[i] - hist[i-1])
        end
        dotVariance = dotVariance / (#hist - 1)
        local varianceThreshold = 0.08
        if Speed > 600 then
            varianceThreshold = 0.10
        elseif Speed > 400 then
            varianceThreshold = 0.09
        end
        if dotVariance > varianceThreshold then
            significantVariance = true
        end
    end
    local curveConditions = 0
    if Dot < Dot_Threshold then curveConditions = curveConditions + 1 end
    if backwardsCurveDetected then curveConditions = curveConditions + 3 end
    if directionChanged then curveConditions = curveConditions + 1 end
    if significantVariance then curveConditions = curveConditions + 1 end
    local curved = curveConditions >= 3 or backwardsCurveDetected
    return curved, backwardsCurveDetected
end
AutoParry.Closest_Player = function()
    if selectedTarget then
        return selectedTarget
    end
    local Max_Distance = math.huge
    local Found_Entity = nil

    for _, Entity in pairs(workspace.Alive:GetChildren()) do
        if tostring(Entity) ~= tostring(LocalPlayer) then
            if Entity.PrimaryPart then
                local Distance = LocalPlayer:DistanceFromCharacter(Entity.PrimaryPart.Position)
                if Distance < Max_Distance then
                    Max_Distance = Distance
                    Found_Entity = Entity
                end
            end
        end
    end

    Closest_Entity = Found_Entity
    return Found_Entity
end
AutoParry.Get_Entity_Properties = function()
    AutoParry.Closest_Player()
    if not Closest_Entity then
        return false
    end
    local Entity_Velocity = Closest_Entity.PrimaryPart.Velocity
    local Entity_Direction = (LocalPlayer.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Unit
    local Entity_Distance = (LocalPlayer.Character.PrimaryPart.Position - Closest_Entity.PrimaryPart.Position).Magnitude
    return {
        Velocity = Entity_Velocity,
        Direction = Entity_Direction,
        Distance = Entity_Distance
    }
end
local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
AutoParry.Parry_Data = function(Parry_Type)
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return nil end
    local Events = {}
    local Camera = workspace.CurrentCamera
    local Vector2_Mouse_Location

    if LastInput == Enum.UserInputType.MouseButton1 or (Enum.UserInputType.MouseButton2 or LastInput == Enum.UserInputType.Keyboard) then
        local Mouse_Location = UserInputService:GetMouseLocation()
        Vector2_Mouse_Location = {Mouse_Location.X, Mouse_Location.Y}
    else
        Vector2_Mouse_Location = {Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2}
    end

    if isMobile then
        Vector2_Mouse_Location = {Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2}
    end

    local Players_Screen_Positions = {}
    for _, v in pairs(workspace.Alive:GetChildren()) do
        if v ~= LocalPlayer.Character then
            local worldPos = v.PrimaryPart.Position
            local screenPos, isOnScreen = Camera:WorldToScreenPoint(worldPos)

            if isOnScreen then
                Players_Screen_Positions[v] = Vector2.new(screenPos.X, screenPos.Y)
            end

            Events[tostring(v)] = screenPos
        end
    end

    if Parry_Type == 'Camera' then
        return {0, Camera.CFrame, Events, Vector2_Mouse_Location}
    end

    if Parry_Type == 'Backwards' then
        local Backwards_Direction = Camera.CFrame.LookVector * -10000
        Backwards_Direction = Vector3.new(Backwards_Direction.X, 0, Backwards_Direction.Z)
        return {0, CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Backwards_Direction), Events, Vector2_Mouse_Location}
    end
    if Parry_Type == 'Straight' then
        local Aimed_Player = nil
        local Closest_Distance = math.huge
        local Mouse_Vector = Vector2.new(Vector2_Mouse_Location[1], Vector2_Mouse_Location[2])

        for _, v in pairs(workspace.Alive:GetChildren()) do
            if v ~= LocalPlayer.Character then
                local worldPos = v.PrimaryPart.Position
                local screenPos, isOnScreen = Camera:WorldToScreenPoint(worldPos)

                if isOnScreen then
                    local playerScreenPos = Vector2.new(screenPos.X, screenPos.Y)
                    local distance = (Mouse_Vector - playerScreenPos).Magnitude

                    if distance < Closest_Distance then
                        Closest_Distance = distance
                        Aimed_Player = v
                    end
                end
            end
        end

        if Aimed_Player then
            return {0, CFrame.new(LocalPlayer.Character.PrimaryPart.Position, Aimed_Player.PrimaryPart.Position), Events, Vector2_Mouse_Location}
        else
            return {0, CFrame.new(LocalPlayer.Character.PrimaryPart.Position, Closest_Entity.PrimaryPart.Position), Events, Vector2_Mouse_Location}
        end
    end

    if Parry_Type == 'Random' then
        local dirs = {"Backwards", "Left", "Right", "High"}
        local d = dirs[math.random(1, #dirs)]
        local v
        if d == "Backwards" then
            v = Camera.CFrame.LookVector * -10000
            v = Vector3.new(v.X, 0, v.Z)
        elseif d == "Left" then
            v = -Camera.CFrame.RightVector * 10000
        elseif d == "Right" then
            v = Camera.CFrame.RightVector * 10000
        elseif d == "High" then
            v = Camera.CFrame.UpVector * 10000
        end
        v = v + Vector3.new(math.random(-500, 500), math.random(-500, 500), math.random(-500, 500))
        return {0, CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + v), Events, Vector2_Mouse_Location}
    end

    if Parry_Type == 'High' then
        local High_Direction = Camera.CFrame.UpVector * 10000
        return {0, CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + High_Direction), Events, Vector2_Mouse_Location}
    end

    if Parry_Type == 'Left' then
        local Left_Direction = Camera.CFrame.RightVector * 10000
        return {0, CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position - Left_Direction), Events, Vector2_Mouse_Location}
    end

    if Parry_Type == 'Right' then
        local Right_Direction = Camera.CFrame.RightVector * 10000
        return {0, CFrame.new(Camera.CFrame.Position, Camera.CFrame.Position + Right_Direction), Events, Vector2_Mouse_Location}
    end
end
AutoParry.Parry = function(parryType)
    local parryData = AutoParry.Parry_Data(parryType)
    if not parryData then return end
    local hasRemotes = false
    for remote, originalArgs in pairs(ParryRemotes) do
        hasRemotes = true
        local modifiedArgs = {originalArgs[1], originalArgs[2], 0, parryData[2], parryData[3], parryData[4]}
        if remote:IsA("RemoteEvent") then
            remote:FireServer(unpack(modifiedArgs))
        elseif remote:IsA("RemoteFunction") then
            remote:InvokeServer(unpack(modifiedArgs))
        end
    end
    if not hasRemotes then
        mouse1click()
    end
    if Parries > 7 then return end
    Parries += 1
    task.delay(0.5, function() if Parries > 0 then Parries -= 1 end end)
end
AutoParry.PerformRemoteParry = function(parryType)
    local parryData = AutoParry.Parry_Data(parryType)
    if not parryData then return end
    for remote, originalArgs in pairs(ParryRemotes) do
        local modifiedArgs = {originalArgs[1], originalArgs[2], 0, parryData[2], parryData[3], parryData[4]}
        if remote:IsA("RemoteEvent") then
            remote:FireServer(unpack(modifiedArgs))
        elseif remote:IsA("RemoteFunction") then
            remote:InvokeServer(unpack(modifiedArgs))
        end
    end
end
AutoParry.Lerp = function(a, b, t)
    return a + (b - a) * t
end
AutoParry.ClosestPlayer = function()
    local maxDist = math.huge
    local closest = nil
    for _, entity in pairs(Alive:GetChildren()) do
        if tostring(entity) ~= tostring(LocalPlayer) then
            local dist = LocalPlayer:DistanceFromCharacter(entity.PrimaryPart.Position)
            if dist < maxDist then
                maxDist = dist
                closest = entity
            end
        end
    end
    return closest
end
function GetNumNearby()
    local count = 0
    for _, p in pairs(Alive:GetChildren()) do
        if p.Name ~= LocalPlayer.Name and (p.PrimaryPart.Position - LocalPlayer.Character.PrimaryPart.Position).Magnitude < 50 then
            count = count + 1
        end
    end
    return count
end
AutoParry.GetEntityProps = function()
    local closest = AutoParry.ClosestPlayer()
    if not closest then return false end
    local vel = closest.PrimaryPart.Velocity
    local dir = (LocalPlayer.Character.PrimaryPart.Position - closest.PrimaryPart.Position).Unit
    local dist = (LocalPlayer.Character.PrimaryPart.Position - closest.PrimaryPart.Position).Magnitude
    return {Velocity = vel, Direction = dir, Distance = dist, Position = closest.PrimaryPart.Position}
end
AutoParry.GetBallProps = function()
    local ball = AutoParry.GetBall()
    if not ball then return false end
    local zoomies = ball:FindFirstChild('zoomies')
    if not zoomies then return false end
    local vel = zoomies.VectorVelocity
    local dir = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
    local dist = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
    local dot = dir:Dot(vel.Unit)
    local speed = vel.Magnitude
    return {Speed = speed, Velocity = vel, Direction = dir, Distance = dist, Dot = dot}
end
AutoParry.SpamService = function()
    local ball = AutoParry.GetBall()
    if not ball then return 0 end
    local closest = AutoParry.ClosestPlayer()
    if not closest then return 0 end
    local zoomies = ball:FindFirstChild('zoomies')
    if not zoomies then return 0 end
    local vel = zoomies.VectorVelocity
    local speed = vel.Magnitude
    local dot = AutoParry.GetBallProps().Dot
    local averagePing = GetAveragePing()
    local PingAdjustment = averagePing / 10
    if HighPingCompensation and averagePing > 150 then
        PingAdjustment = PingAdjustment * 1.5
    end
    local compensation = 0
    if AutoParryType == "Keypress" and AutoSpamType == "Keypress" then
        compensation = 15
    end
    local Maximum_Spam_Distance = PingAdjustment + math.min(speed / 4, 200) + compensation
    local entityProps = AutoParry.GetEntityProps()
    local ballProps = AutoParry.GetBallProps()
    if not entityProps or not ballProps then return 0 end
    if entityProps.Distance > Maximum_Spam_Distance or ballProps.Distance > Maximum_Spam_Distance or LocalPlayer:DistanceFromCharacter(closest.PrimaryPart.Position) > Maximum_Spam_Distance then return 0 end
    local Maximum_Speed = 5 - math.min(speed / 5, 5)
    local Maximum_Dot = math.clamp(dot, -1, 0) * Maximum_Speed
    local Spam_Accuracy = Maximum_Spam_Distance - Maximum_Dot
    return Spam_Accuracy
end
AutoParry.IsCooldownActive = function(uigradient)
    return uigradient.Offset.Y <= 0.27
end
AutoParry.TryParryOrCooldown = function()
    if AutoParry.IsCooldownActive(ParryCD) then
        game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("PlrInput"):FireServer("UseAbility")
        return true
    end
    return false
end
function BlockMovement(actionName, inputState, inputObject)
    return Enum.ContextActionResult.Sink
end
function SetupAntiPhantom()
    if Connections["anti_phantom"] then return end
    Connections["anti_phantom"] = RunService.PreSimulation:Connect(function()
        if Phantom and LocalPlayer.Character:GetAttribute('Parrying') then
            ContextActionService:BindAction('BlockPlayerMovement', BlockMovement, false, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.UserInputType.Touch)
            LocalPlayer.Character.Humanoid.WalkSpeed = 36
            local ball = AutoParry.GetBall()
            if ball then
                LocalPlayer.Character.Humanoid:MoveTo(ball.Position)
            end
            task.spawn(function()
                repeat
                    LocalPlayer.Character.Humanoid.WalkSpeed = 36
                    task.wait()
                until not Phantom
            end)
            if ball then
                ball:GetAttributeChangedSignal('target'):Once(function()
                    ContextActionService:UnbindAction('BlockPlayerMovement')
                    Phantom = false
                    LocalPlayer.Character.Humanoid:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position)
                    LocalPlayer.Character.Humanoid.WalkSpeed = 10
                    task.delay(3, function()
                        LocalPlayer.Character.Humanoid.WalkSpeed = 36
                    end)
                end)
            end
        end
    end)
end
local VirtualInputManager = game:GetService("VirtualInputManager")
local isMobileDevice = UserInputService.TouchEnabled and not UserInputService.MouseEnabled

function SimulateParry()
    if isMobileDevice then
        mouse1click()
    else
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, true, game, 0)
        task.wait()
        VirtualInputManager:SendMouseButtonEvent(0, 0, 0, false, game, 0)
    end
end

function KeypressAPC(parryType)
    if not LocalPlayer.Character or not LocalPlayer.Character.PrimaryPart then return end
    local parryData = AutoParry.Parry_Data(parryType)
    if not parryData then return end
    local cam = workspace.CurrentCamera
    local orig = cam.CFrame
    local randomAngle = CFrame.Angles(math.rad(math.random(-5,5)), math.rad(math.random(-5,5)), math.rad(math.random(-2,2)))
    local target = parryData[2] * randomAngle
    local startTime = tick()
    local duration = 0.11 + math.random(-10,10)/1000
    local conn
    conn = RunService.Heartbeat:Connect(function()
        local elapsed = tick() - startTime
        if elapsed >= duration then
            conn:Disconnect()
            SimulateParry()
            task.wait(0.25 + math.random(-30,30)/1000)
            local backStart = tick()
            local backDuration = 0.14
            local backConn
            backConn = RunService.Heartbeat:Connect(function()
                local backElapsed = tick() - backStart
                if backElapsed >= backDuration then
                    backConn:Disconnect()
                    return
                end
                local backAlpha = backElapsed / backDuration
                backAlpha = 1 - (1 - backAlpha)^2
                cam.CFrame = target:Lerp(orig, backAlpha)
            end)
            return
        end
        local alpha = elapsed / duration
        alpha = alpha^2
        cam.CFrame = orig:Lerp(target, alpha)
    end)
end

Connections["deathball_event"] = ReplicatedStorage.Remotes.DeathBall.OnClientEvent:Connect(function(value)
    DeathSlashDetection = value
end)
Connections["infinityball_event"] = ReplicatedStorage.Remotes.InfinityBall.OnClientEvent:Connect(function(a, b)
    Infinity_Ball = b
end)
Connections["phantom_event"] = ReplicatedStorage.Remotes.Phantom.OnClientEvent:Connect(function(a, b)
    if b.Name == tostring(LocalPlayer) then
        Phantom = true
    else
        Phantom = false
    end
end)
LastParry = 0
VizEnabled = false
function GetCharacter()
    return LocalPlayer and LocalPlayer.Character
end
function GetPrimaryPart()
    local char = GetCharacter()
    return char and char.PrimaryPart
end
function CalcVizRadius()
    local ball = AutoParry.GetBall()
    if ball then
        local vel = ball.Velocity.Magnitude
        local radius = math.clamp((vel / 2.4) + 10, 15, 50)
        return radius
    end
    return 15
end
Viz = Instance.new("Part")
Viz.Name = "OxyoViz"
Viz.Shape = Enum.PartType.Ball
Viz.Anchored = true
Viz.CanCollide = false
Viz.Material = Enum.Material.ForceField
Viz.Transparency = 0.5
Viz.Parent = Workspace
Viz.Size = Vector3.new(0, 0, 0)
TargetColor = Color3.new(0,1,0)
CurrentColor = Color3.new(0,1,0)
LerpSpeed = 0.1
function ToggleViz(state)
    VizEnabled = state
    if not state then Viz.Size = Vector3.new(0, 0, 0) end
end
Connections["viz_render"] = RunService.RenderStepped:Connect(function()
    if not VizEnabled then return end
    local primaryPart = GetPrimaryPart()
    local ball = AutoParry.GetBall()
    if primaryPart and ball then
        local radius = CalcVizRadius()
        Viz.Size = Vector3.new(radius, radius, radius)
        Viz.CFrame = primaryPart.CFrame
        if IsAutoSpamming then
            TargetColor = Color3.new(1,0,0)
        else
            TargetColor = Color3.new(0,1,0)
        end
        CurrentColor = CurrentColor:Lerp(TargetColor, LerpSpeed)
        Viz.Color = CurrentColor
    else
        Viz.Size = Vector3.new(0, 0, 0)
    end
end)
Runtime = Workspace.Runtime
LastElapsed_Parry_Time = 0
Parry_Rate = 5
Min_Parry_Delay = 1 / Parry_Rate
AutoSpamCoroutine = nil
SpectateEnabled = false
task.defer(function()
    Connections["spectate_render"] = RunService.RenderStepped:Connect(function()
        if SpectateEnabled then
            local self = AutoParry.GetBall()
            if not self then return end
            Workspace.CurrentCamera.CFrame = Workspace.CurrentCamera.CFrame:Lerp(CFrame.new(Workspace.CurrentCamera.CFrame.Position, self.Position), 1.5)
        end
    end)
end)
OriginalLighting = {}
function Optimize(state)
    if state then
        local light = game:GetService("Lighting")
        OriginalLighting = {
            GlobalShadows = light.GlobalShadows,
            FogEnd = light.FogEnd,
            Brightness = light.Brightness,
            OutdoorAmbient = light.OutdoorAmbient,
            EnvDiffuseScale = light.EnvironmentDiffuseScale,
            EnvSpecularScale = light.EnvironmentSpecularScale,
            ShadowSoftness = light.ShadowSoftness
        }
        light.GlobalShadows = false
        light.FogEnd = 100000
        light.Brightness = 1
        light.OutdoorAmbient = Color3.fromRGB(128, 128, 128)
        light.EnvironmentDiffuseScale = 0
        light.EnvironmentSpecularScale = 0
        light.ShadowSoftness = 1
        if Workspace:FindFirstChildOfClass("Terrain") then
            local terrain = Workspace:FindFirstChildOfClass("Terrain")
            terrain.WaterWaveSize = 0
            terrain.WaterWaveSpeed = 0
            terrain.WaterReflectance = 0
            terrain.WaterTransparency = 1
        end
        for _, obj in pairs(game:GetDescendants()) do
            if obj:IsA("Explosion") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") or obj:IsA("Trail") or obj:IsA("ParticleEmitter") or obj:IsA("Beam") then
                obj:Destroy()
            elseif obj:IsA("Texture") or obj:IsA("Decal") or obj:IsA("SurfaceAppearance") then
                obj:Destroy()
            elseif obj:IsA("BlurEffect") or obj:IsA("SunRaysEffect") or obj:IsA("ColorCorrectionEffect") or obj:IsA("BloomEffect") or obj:IsA("DepthOfFieldEffect") then
                obj:Destroy()
            end
        end
    else
        local light = game:GetService("Lighting")
        for setting, value in pairs(OriginalLighting) do
            pcall(function() light[setting] = value end)
        end
    end
end

-- ============================================================
-- UI
-- ============================================================

parriedBalls = {}

MainTab = UI:AddTab({Id = "main", Title = "Main", Icon = "swords"})
MiscTab = UI:AddTab({Id = "misc", Title = "Misc", Icon = "settings-2"})
AITab = UI:AddTab({Id = "aiplay", Title = "AI Play", Icon = "bot"})
AutoFarmTab = UI:AddTab({Id = "autofarm", Title = "Auto Farm", Icon = "repeat"})

parryTypeOptions = Is_Supported_Test and {"Remote", "Keypress"} or {"Keypress"}
parryTypeDefault = Is_Supported_Test and "Remote" or "Keypress"
curveTypeOptions = {"Backwards", "Camera", "High", "Left", "Random", "Right", "Straight"}

-- ================= Main / Lobby AP =================
LobbySection = MainTab:AddSection({
    Title = "Lobby AP",
    Description = "Auto parry for the lobby game",
    Icon = "building-2",
})
LobbyAPToggle = LobbySection:AddToggle({
    Id = "LobbyAP",
    Title = "Lobby AP",
    Description = "Auto parry for the lobby game",
    Default = false,
    Callback = function(v)
        local LastLobbyParry = 0
        if v then
            for _, ball in pairs(AutoParry.GetLobbyBalls()) do
                Connections["lobby_parried_" .. tostring(ball)] = ball:GetAttributeChangedSignal('target'):Connect(function()
                    parriedBalls[ball] = false
                end)
            end
            Connections["lobby_ball_added"] = Workspace.TrainingBalls.ChildAdded:Connect(function(newBall)
                if newBall:IsA("BasePart") and newBall:GetAttribute("realBall") then
                    Connections["lobby_parried_" .. tostring(newBall)] = newBall:GetAttributeChangedSignal('target'):Connect(function()
                        parriedBalls[newBall] = false
                    end)
                end
            end)
            Connections["lobby_ball_removed"] = Workspace.TrainingBalls.ChildRemoved:Connect(function(removedBall)
                local key = "lobby_parried_" .. tostring(removedBall)
                if Connections[key] then
                    Connections[key]:Disconnect()
                    Connections[key] = nil
                end
                parriedBalls[removedBall] = nil
            end)
            Connections["lobbyAutoParry"] = RunService.PreSimulation:Connect(function()
                local balls = AutoParry.GetLobbyBalls()
                for _, ball in pairs(balls) do
                    if not ball then
                        ContextActionService:UnbindAction('BlockPlayerMovement')
                        repeat RunService.Heartbeat:Wait() balls = AutoParry.GetLobbyBalls() until balls
                        return
                    end
                    local zoomies = ball:FindFirstChild("zoomies")
                    if not zoomies then
                        ContextActionService:UnbindAction('BlockPlayerMovement')
                        return
                    end
                    ball:GetAttributeChangedSignal('target'):Once(function() Parried = false end)
                    if Parried then continue end
                    local ballTarget = ball:GetAttribute('target')
                    local velocity = zoomies.VectorVelocity
                    local distance = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
                    local speed = velocity.Magnitude
                    local averagePing = GetAveragePing()
                    local useAbility = false
                    local cappedSpeedDifference = math.min(math.max(speed - 9.5, 0), 820)
                    local speedDivisorBase = 2.4 + cappedSpeedDifference * 0.002
                    local adjustedPing = averagePing / 10
                    if HighPingCompensation and averagePing > 150 then
                        adjustedPing = adjustedPing * 1.5
                    end
                    local speedDivisor = speedDivisorBase * Speed_Divisor_Multiplier
                    local parryAccuracy = adjustedPing + math.max(speed / speedDivisor, 9.5)
                    if ballTarget == tostring(LocalPlayer) then
                        local minParryDelay = 0.15 + (averagePing / 1000)
                        local Elapsed_Parry_Time = os.clock()
                        local timeView = (Elapsed_Parry_Time - LastLobbyParry)
                        if timeView < minParryDelay then continue end
                        if distance <= parryAccuracy then
                            if LobbyParryType == "Remote" then
                                if Is_Supported_Test and next(ParryRemotes) then
                                    AutoParry.Parry(SelectedParryType)
                                else
                                    SimulateParry()
                                end
                            else
                                SimulateParry()
                            end
                            parriedBalls[ball] = true
                            task.delay(1, function()
                                parriedBalls[ball] = false
                            end)
                            LastLobbyParry = Elapsed_Parry_Time
                        end
                    end
                end
            end)
        elseif Connections["lobbyAutoParry"] then
            Connections["lobbyAutoParry"]:Disconnect()
            Connections["lobbyAutoParry"] = nil
            for key, conn in pairs(Connections) do
                if key:find("lobby_parried_") or key == "lobby_ball_added" or key == "lobby_ball_removed" then
                    conn:Disconnect()
                    Connections[key] = nil
                end
            end
            parriedBalls = {}
        end
    end,
})
LobbyAPToggle:AddKeybind({
    Id = "LobbyAPKey",
    Title = "Lobby AP keybind",
    Mode = "Toggle",
    Mobile = true,
    MobileText = "Lobby AP",
})
LobbySection:AddDropdown({
    Id = "LobbyParryType",
    Title = "Parry Type",
    Options = parryTypeOptions,
    Default = parryTypeDefault,
    Callback = function(v)
        LobbyParryType = v
    end,
})

-- ================= Main / Auto Parry =================
AutoParrySection = MainTab:AddSection({
    Title = "Auto Parry",
    Description = "Automatically parries for you",
    Icon = "shield",
})
AutoParryToggle = AutoParrySection:AddToggle({
    Id = "AutoParry",
    Title = "Auto Parry",
    Description = "Automatically parries for you",
    Default = false,
    Callback = function(v)
        if v then
            if AutoPostParry or UI.State:Get("AutoPostParry") then
                Connections["autoPostParry_deathMonitor"] = Alive.ChildRemoved:Connect(function(removedCharacter)
                    if not AutoPostParry then return end
                    if not PostParryTarget or PostParryTarget == "" then return end
                    if removedCharacter.Name ~= PostParryTarget then return end
                    if PostParryScheduled[removedCharacter.Name] then return end
                    local hadHighSpeed = false
                    for ball, speeds in pairs(PostParryVelocityHistory) do
                        for _, speed in ipairs(speeds) do
                            if speed >= 800 then
                                hadHighSpeed = true
                                break
                            end
                        end
                        if hadHighSpeed then break end
                    end
                    if hadHighSpeed then
                        PostParryScheduled[removedCharacter.Name] = true
                        local randomDelay = (math.random(150, 180) / 1000)
                        task.delay(randomDelay, function()
                            SimulateParry()
                            PostParryScheduled[removedCharacter.Name] = nil
                        end)
                    end
                    PostParryTarget = nil
                    PostParryVelocityHistory = {}
                end)
            end
            Connections["autoParry"] = RunService.PreSimulation:Connect(function()
                local oneBall = AutoParry.GetBall()
                local balls = AutoParry.GetBalls()
                for _, ball in pairs(balls) do
                    if not ball then
                        ContextActionService:UnbindAction('BlockPlayerMovement')
                        repeat RunService.Heartbeat:Wait() balls = AutoParry.GetBalls() until balls
                        return
                    end
                    local zoomies = ball:FindFirstChild('zoomies')
                    if not zoomies then
                        ContextActionService:UnbindAction('BlockPlayerMovement')
                        return
                    end
                    ball:GetAttributeChangedSignal('target'):Once(function() Parried = false end)
                    if Parried then continue end
                    local ballTarget = ball:GetAttribute('target')
                    local oneTarget = oneBall:GetAttribute('target')
                    local velocity = zoomies.VectorVelocity
                    if not AutoParry.Velocity_History[ball] then AutoParry.Velocity_History[ball] = {} end
                    table.insert(AutoParry.Velocity_History[ball], velocity)
                    if #AutoParry.Velocity_History[ball] > 5 then table.remove(AutoParry.Velocity_History[ball], 1) end
                    local Direction = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
                    local Ball_Direction = velocity.Unit
                    local Dot = Direction:Dot(Ball_Direction)
                    if not AutoParry.Dot_Histories[ball] then AutoParry.Dot_Histories[ball] = {} end
                    table.insert(AutoParry.Dot_Histories[ball], Dot)
                    if #AutoParry.Dot_Histories[ball] > 5 then table.remove(AutoParry.Dot_Histories[ball], 1) end
                    local pingedValued = game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue()
                    local time = pingedValued / 2000
                    local playerVel = LocalPlayer.Character.PrimaryPart.Velocity
                    local Ball_Position = ball.Position
                    local Ball_Future_Position = Ball_Position + velocity * time
                    local Player_Future_Position = LocalPlayer.Character.PrimaryPart.Position + playerVel * time
                    local distance = (Player_Future_Position - Ball_Future_Position).Magnitude
                    local speed = velocity.Magnitude
                    if AutoPostParry then
                        if not PostParryVelocityHistory[ball] then PostParryVelocityHistory[ball] = {} end
                        table.insert(PostParryVelocityHistory[ball], speed)
                        if #PostParryVelocityHistory[ball] > 15 then table.remove(PostParryVelocityHistory[ball], 1) end
                        if ballTarget and ballTarget ~= "" and ballTarget ~= tostring(LocalPlayer) then
                            PostParryTarget = ballTarget
                        elseif ballTarget == tostring(LocalPlayer) and PostParryTarget and PostParryTarget ~= "" then
                        end
                    end
                    local curved, backwardsDetected = AutoParry.IsCurved(ball)
                    if backwardsDetected then
                        wasBackwards[ball] = true
                    end
                    local tornado = Runtime:FindFirstChild('Tornado')
                    if ball:FindFirstChild('AeroDynamicSlashVFX') then
                        Debris:AddItem(ball.AeroDynamicSlashVFX, 0)
                        Tornado_Time = tick()
                    end
                    if tornado then
                        local elapsedTornado = (tick() - Tornado_Time)
                        local tornadoDuration = (tornado:GetAttribute('TornadoTime') or 1) + 0.314159
                        if elapsedTornado < tornadoDuration then continue end
                    end
                    local singularityCape = LocalPlayer.Character.PrimaryPart:FindFirstChild('SingularityCape')
                    local Predicted_Direction = (Player_Future_Position - Ball_Future_Position).Unit
                    local Predicted_Dot = Predicted_Direction:Dot(velocity.Unit)
                    if oneTarget == tostring(LocalPlayer) and Predicted_Dot < -0.3 then continue end
                    if Singularity_Detection and singularityCape then continue end
                    local hotbar = LocalPlayer:FindFirstChild('PlayerGui') and LocalPlayer.PlayerGui:FindFirstChild('Hotbar')
                    local character = LocalPlayer.Character
                    local abilities = character and character:FindFirstChild('Abilities')
                    local durationUI = hotbar and hotbar:FindFirstChild('Ability') and hotbar.Ability:FindFirstChild('Duration') and hotbar.Ability.Duration.Visible
                    local infinityAbility = abilities and abilities:FindFirstChild('Infinity')
                    local infinity = infinityAbility and infinityAbility.Enabled
                    local usingInfinity = durationUI and infinity and Infinity_Ball
                    if Infinity_Detection and usingInfinity then continue end
                    local timeholeAbility = abilities and abilities:FindFirstChild('Time Hole')
                    local timehole = timeholeAbility and timeholeAbility.Enabled
                    if durationUI and timehole then continue end
                    if AntiPhantomEnabled and Phantom and LocalPlayer.Character:GetAttribute('Parrying') then
                        ContextActionService:BindAction('BlockPlayerMovement', BlockMovement, false, Enum.KeyCode.W, Enum.KeyCode.A, Enum.KeyCode.S, Enum.KeyCode.D, Enum.UserInputType.Touch)
                        LocalPlayer.Character.Humanoid.WalkSpeed = 36
                        LocalPlayer.Character.Humanoid:MoveTo(ball.Position)
                        task.spawn(function()
                            repeat
                                if LocalPlayer.Character.Humanoid.WalkSpeed ~= 36 then
                                    LocalPlayer.Character.Humanoid.WalkSpeed = 36
                                end
                                task.wait()
                            until not Phantom
                        end)
                        ball:GetAttributeChangedSignal('target'):Once(function()
                            ContextActionService:UnbindAction('BlockPlayerMovement')
                            Phantom = false
                            LocalPlayer.Character.Humanoid:MoveTo(LocalPlayer.Character.HumanoidRootPart.Position)
                            LocalPlayer.Character.Humanoid.WalkSpeed = 10
                            task.delay(3, function()
                                LocalPlayer.Character.Humanoid.WalkSpeed = 36
                            end)
                        end)
                    end
                    local entityProps = AutoParry.GetEntityProps()
                    local distance_to_opponent = entityProps and entityProps.Distance or 50
                    local cappedSpeedDifference = math.min(math.max(speed - 9.5, 0), 820)
                    local speedDivisorBase = 2.4 + cappedSpeedDifference * 0.002
                    local adjustedPing = pingedValued / 10
                    if HighPingCompensation and pingedValued > 150 then
                        adjustedPing = adjustedPing * 1.5
                    end
                    local speedDivisor = speedDivisorBase * Speed_Divisor_Multiplier
                    local parryAccuracy = adjustedPing + math.max(speed / speedDivisor, 9.5)
                    if curved and backwardsDetected then
                        local distanceReduction = 55
                        if speed > 700 then
                            distanceReduction = 85
                        elseif speed > 600 then
                            distanceReduction = 75
                        elseif speed > 500 then
                            distanceReduction = 68
                        elseif speed > 400 then
                            distanceReduction = 62
                        end
                        parryAccuracy = parryAccuracy - distanceReduction
                    elseif curved then
                        local distanceReduction = 38
                        if speed > 700 then
                            distanceReduction = 58
                        elseif speed > 600 then
                            distanceReduction = 52
                        elseif speed > 500 then
                            distanceReduction = 46
                        elseif speed > 400 then
                            distanceReduction = 42
                        end
                        parryAccuracy = parryAccuracy - distanceReduction
                    end
                    local speedFactor = 0.8 + math.min(speed / 2000, 1.0)
                    local distFactor = 1 + (30 - math.min(distance_to_opponent, 30)) / 30 * 0.8
                    local factor = speedFactor * distFactor
                    parryAccuracy = adjustedPing + math.max((speed / speedDivisor) * factor, 9.5)
                    local parryCD = LocalPlayer.PlayerGui:FindFirstChild('Hotbar'):FindFirstChild('Block').UIGradient
                    local abilityCD = LocalPlayer.PlayerGui:FindFirstChild('Hotbar'):FindFirstChild('Ability').UIGradient
                    if ballTarget == tostring(LocalPlayer) and distance <= parryAccuracy and Phantom then
                        if AutoParryType == "Keypress" then
                            KeypressAPC(SelectedParryType)
                        else
                            SimulateParry()
                        end
                        Parries += 1
                        task.delay(0.5, function() if Parries > 0 then Parries -= 1 end end)
                        Parried = true
                    end
                    if ballTarget == tostring(LocalPlayer) and distance <= parryAccuracy and not Phantom then
                        if Death_Slash_Detection and DeathSlashDetection then continue end
                        local parryTime = os.clock()
                        local timeView = (parryTime - LastParry)
                        if timeView > 0.5 then AutoParry.ParryAnim(false) end
                        local averagePing = GetAveragePing()
                        local useAbility = false
                        if HighPingProtection and averagePing > 130 then
                            useAbility = true
                            Use_Ability:Fire()
                        end
                        if not useAbility then
                            if AutoParryType == "Remote" then
                                if Is_Supported_Test and next(ParryRemotes) then
                                    AutoParry.Parry(SelectedParryType)
                                else
                                    if AutoParryType == "Keypress" then
                                        KeypressAPC(SelectedParryType)
                                    else
                                        SimulateParry()
                                    end
                                    Parries += 1
                                    task.delay(0.5, function() if Parries > 0 then Parries -= 1 end end)
                                end
                            else
                                if AutoParryType == "Keypress" then
                                    KeypressAPC(SelectedParryType)
                                else
                                    SimulateParry()
                                end
                                Parries += 1
                                task.delay(0.5, function() if Parries > 0 then Parries -= 1 end end)
                            end
                        end
                        LastParry = parryTime
                        Parried = true
                        wasBackwards[ball] = false
                        local lastParrys = tick()
                        repeat RunService.PreSimulation:Wait() until (tick() - lastParrys) >= 1 or not Parried
                        Parried = false
                    end
                end
            end)
        elseif Connections["autoParry"] then
            Connections["autoParry"]:Disconnect()
            Connections["autoParry"] = nil
            if Connections["autoPostParry_deathMonitor"] then
                Connections["autoPostParry_deathMonitor"]:Disconnect()
                Connections["autoPostParry_deathMonitor"] = nil
            end
            PostParryTarget = nil
            PostParryVelocityHistory = {}
            PostParryScheduled = {}
        end
    end,
})
AutoParryToggle:AddKeybind({
    Id = "AutoParryKey",
    Title = "Auto Parry keybind",
    Mode = "Toggle",
    Mobile = true,
    MobileText = "Auto Parry",
})
AutoParrySection:AddDropdown({
    Id = "AutoParryType",
    Title = "Parry Type",
    Options = parryTypeOptions,
    Default = parryTypeDefault,
    Callback = function(v)
        AutoParryType = v
    end,
})
AutoParrySection:AddDropdown({
    Id = "ParryDirection",
    Title = "Curve Type",
    Options = curveTypeOptions,
    Default = "Camera",
    Callback = function(v)
        SelectedParryType = v
    end,
})
AutoParrySection:AddDivider({Text = "Detection"})
AutoParrySection:AddToggle({
    Id = "RandomizedParryAccuracy",
    Title = "Randomized Parry Accuracy",
    Style = "Checkbox",
    Callback = function(v)
        Randomized_ParryAccuracy = v
    end,
})
AutoParrySection:AddSlider({
    Id = "ParryAccuracy",
    Title = "Parry Accuracy",
    Min = 1,
    Max = 100,
    Default = 100,
    Step = 1,
    Suffix = "%",
    Callback = function(v)
        Speed_Divisor_Multiplier = 0.7 + ((v - 1) / 99) * 0.35
    end,
})
AutoParrySection:AddToggle({
    Id = "HighPingCompensation",
    Title = "High Ping Compensation",
    Style = "Checkbox",
    Callback = function(v)
        HighPingCompensation = v
    end,
})
AutoParrySection:AddToggle({
    Id = "AutoPostParry",
    Title = "Auto Pre-Click",
    Style = "Checkbox",
    Callback = function(v)
        AutoPostParry = v
        if v then
            Connections["autoPostParry_continuousCheck"] = RunService.Heartbeat:Connect(function()
                if not AutoPostParry then return end
                if not PostParryTarget or PostParryTarget == "" then return end
                if PostParryScheduled[PostParryTarget] then return end
                local targetChar = Alive:FindFirstChild(PostParryTarget)
                if not targetChar then
                    local hadHighSpeed = false
                    for ball, speeds in pairs(PostParryVelocityHistory) do
                        for _, speed in ipairs(speeds) do
                            if speed >= 800 then
                                hadHighSpeed = true
                                break
                            end
                        end
                        if hadHighSpeed then break end
                    end
                    if hadHighSpeed then
                        PostParryScheduled[PostParryTarget] = true
                        local randomDelay = (math.random(120, 140) / 1000)
                        task.delay(randomDelay, function()
                            SimulateParry()
                            PostParryScheduled[PostParryTarget] = nil
                        end)
                    end
                    PostParryTarget = nil
                    PostParryVelocityHistory = {}
                end
            end)
        else
            if Connections["autoPostParry_continuousCheck"] then
                Connections["autoPostParry_continuousCheck"]:Disconnect()
                Connections["autoPostParry_continuousCheck"] = nil
            end
            PostParryTarget = nil
            PostParryVelocityHistory = {}
            PostParryScheduled = {}
            BallSenderTracking = {}
        end
    end,
})
AutoParrySection:AddToggle({
    Id = "SingularityDetection",
    Title = "Singularity Detection",
    Style = "Checkbox",
    Callback = function(v)
        Singularity_Detection = v
    end,
})
AutoParrySection:AddToggle({
    Id = "InfinityDetection",
    Title = "Infinity Detection",
    Style = "Checkbox",
    Callback = function(v)
        Infinity_Detection = v
    end,
})
AutoParrySection:AddToggle({
    Id = "CooldownProtection",
    Title = "Cooldown Protection",
    Style = "Checkbox",
    Callback = function(v)
        CooldownProtection = v
    end,
})
AutoParrySection:AddToggle({
    Id = "HighPingProtection",
    Title = "High Ping Protection",
    Style = "Checkbox",
    Callback = function(v)
        HighPingProtection = v
    end,
})
AutoParrySection:AddToggle({
    Id = "DeathSlashDetection",
    Title = "Death Slash Detection",
    Style = "Checkbox",
    Callback = function(v)
        Death_Slash_Detection = v
    end,
})
AutoParrySection:AddToggle({
    Id = "AntiPhantom",
    Title = "Anti Phantom",
    Style = "Checkbox",
    Callback = function(v)
        AntiPhantomEnabled = v
        if v then
            SetupAntiPhantom()
        else
            if Connections["anti_phantom"] then
                Connections["anti_phantom"]:Disconnect()
                Connections["anti_phantom"] = nil
            end
        end
    end,
})

-- ================= Main / Triggerbot =================
TriggerbotSection = MainTab:AddSection({
    Title = "Triggerbot",
    Description = "Parries instantly when targeted",
    Icon = "zap",
})
isTriggerbotEnabled = false
triggerParriedBalls = {}
TriggerbotToggle = TriggerbotSection:AddToggle({
    Id = "Triggerbot",
    Title = "Triggerbot",
    Description = "Parries instantly when targeted",
    Default = false,
    Callback = function(v)
        isTriggerbotEnabled = v
        if v then
            if UI.State:Get("TriggerAutoPostParry") then
                Connections["triggerbot_postParry_deathMonitor"] = Alive.ChildRemoved:Connect(function(removedCharacter)
                    if not UI.State:Get("TriggerAutoPostParry") then return end
                    if not PostParryTarget or PostParryTarget == "" then return end
                    if removedCharacter.Name ~= PostParryTarget then return end
                    if PostParryScheduled[removedCharacter.Name] then return end
                    local hadHighSpeed = false
                    for ball, speeds in pairs(PostParryVelocityHistory) do
                        for _, speed in ipairs(speeds) do
                            if speed >= 800 then
                                hadHighSpeed = true
                                break
                            end
                        end
                        if hadHighSpeed then break end
                    end
                    if hadHighSpeed then
                        PostParryScheduled[removedCharacter.Name] = true
                        local randomDelay = (math.random(150, 180) / 1000)
                        task.delay(randomDelay, function()
                            SimulateParry()
                            PostParryScheduled[removedCharacter.Name] = nil
                        end)
                    end
                    PostParryTarget = nil
                    PostParryVelocityHistory = {}
                end)
            end
            Connections["triggerbot_monitor"] = RunService.PreSimulation:Connect(function()
                if not isTriggerbotEnabled then return end
                local ball = AutoParry.GetBall()
                if not ball then return end
                local ballTarget = ball:GetAttribute('target')
                local zoomies = ball:FindFirstChild('zoomies')
                if zoomies and UI.State:Get("TriggerAutoPostParry") then
                    local velocity = zoomies.VectorVelocity
                    local speed = velocity.Magnitude
                    if not PostParryVelocityHistory[ball] then PostParryVelocityHistory[ball] = {} end
                    table.insert(PostParryVelocityHistory[ball], speed)
                    if #PostParryVelocityHistory[ball] > 15 then table.remove(PostParryVelocityHistory[ball], 1) end
                    if ballTarget and ballTarget ~= "" and ballTarget ~= tostring(LocalPlayer) then
                        PostParryTarget = ballTarget
                    end
                end
                if ballTarget ~= tostring(LocalPlayer) then
                    triggerParriedBalls[ball] = nil
                    return
                end
                if triggerParriedBalls[ball] then return end
                local hotbar = LocalPlayer:FindFirstChild('PlayerGui') and LocalPlayer.PlayerGui:FindFirstChild('Hotbar')
                local character = LocalPlayer.Character
                if not character or not character.PrimaryPart then return end
                local abilities = character:FindFirstChild('Abilities')
                local durationUI = hotbar and hotbar:FindFirstChild('Ability') and hotbar.Ability:FindFirstChild('Duration') and hotbar.Ability.Duration.Visible
                local infinityAbility = abilities and abilities:FindFirstChild('Infinity')
                local infinity = infinityAbility and infinityAbility.Enabled
                local usingInfinity = durationUI and infinity and Infinity_Ball
                if TriggerInfinity_Detection and usingInfinity then return end
                local singularityCape = character.PrimaryPart:FindFirstChild('SingularityCape')
                if TriggerSingularity_Detection and singularityCape then return end
                if TriggerDeathSlash_Detection and DeathSlashDetection then return end
                if not zoomies then return end
                local velocity = zoomies.VectorVelocity
                local speed = velocity.Magnitude
                local pingedValued = game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue()
                local time = pingedValued / 2000
                local playerVel = character.PrimaryPart.Velocity
                local Ball_Position = ball.Position
                local Ball_Future_Position = Ball_Position + velocity * time
                local Player_Future_Position = character.PrimaryPart.Position + playerVel * time
                local distance = (Player_Future_Position - Ball_Future_Position).Magnitude
                local cappedSpeedDifference = math.min(math.max(speed - 9.5, 0), 820)
                local speedDivisorBase = 2.4 + cappedSpeedDifference * 0.002
                local adjustedPing = pingedValued / 10
                if HighPingCompensation and pingedValued > 150 then
                    adjustedPing = adjustedPing * 1.5
                end
                local speedDivisor = speedDivisorBase * Speed_Divisor_Multiplier
                local parryAccuracy = adjustedPing + math.max(speed / speedDivisor, 9.5)
                if distance > parryAccuracy then return end
                AutoParry.ParryAnim(false)
                local averagePing = GetAveragePing()
                local useAbility = false
                local abilityCD = hotbar and hotbar:FindFirstChild('Ability') and hotbar.Ability.UIGradient
                if TriggerHighPingProtection and averagePing > 130 then
                    if abilityCD and abilityCD.Offset.Y == 0.5 and (abilities["Raging Deflection"].Enabled or abilities["Rapture"].Enabled) then
                        useAbility = true
                        Use_Ability:Fire()
                    end
                end
                if not useAbility then
                    if TriggerbotType == "Remote" then
                        if Is_Supported_Test and next(ParryRemotes) then
                            AutoParry.PerformRemoteParry(SelectedTriggerParryType)
                        else
                            SimulateParry()
                            Parries += 1
                            task.delay(0.5, function() if Parries > 0 then Parries -= 1 end end)
                        end
                    else
                        if TriggerbotType == "Keypress" and KeypressAutoCurve then
                            KeypressAPC(SelectedTriggerParryType)
                        else
                            SimulateParry()
                        end
                        Parries += 1
                        task.delay(0.5, function() if Parries > 0 then Parries -= 1 end end)
                    end
                end
                triggerParriedBalls[ball] = true
            end)
            local prevUsingInfinityTB = nil
            Connections["triggerbot_infinity_watch"] = RunService.PreSimulation:Connect(function()
                if not isTriggerbotEnabled then return end
                local hotbarW = LocalPlayer:FindFirstChild('PlayerGui') and LocalPlayer.PlayerGui:FindFirstChild('Hotbar')
                local characterW = LocalPlayer.Character
                local abilitiesW = characterW and characterW:FindFirstChild('Abilities')
                local durationUIW = hotbarW and hotbarW:FindFirstChild('Ability') and hotbarW.Ability:FindFirstChild('Duration') and hotbarW.Ability.Duration.Visible
                local infinityAbilityW = abilitiesW and abilitiesW:FindFirstChild('Infinity')
                local infinityW = infinityAbilityW and infinityAbilityW.Enabled
                local usingInfinityW = durationUIW and infinityW and Infinity_Ball
                if prevUsingInfinityTB == nil then
                    prevUsingInfinityTB = usingInfinityW
                    return
                end
                if TriggerInfinity_Detection and prevUsingInfinityTB and not usingInfinityW then
                    local targetedBall
                    for _, b in pairs(AutoParry.GetBalls()) do
                        if b:GetAttribute('target') == tostring(LocalPlayer) then
                            targetedBall = b
                            break
                        end
                    end
                    if targetedBall then
                        local singularityCapeW = LocalPlayer.Character.PrimaryPart:FindFirstChild('SingularityCape')
                        if TriggerSingularity_Detection and singularityCapeW then
                            prevUsingInfinityTB = usingInfinityW
                            return
                        end
                        if TriggerDeathSlash_Detection and DeathSlashDetection and durationUIW then
                            prevUsingInfinityTB = usingInfinityW
                            return
                        end
                        AutoParry.ParryAnim(false)
                        local averagePing = GetAveragePing()
                        local useAbility = false
                        local abilityCDW = hotbarW and hotbarW:FindFirstChild('Ability') and hotbarW.Ability.UIGradient
                        if TriggerHighPingProtection and averagePing > 130 then
                            if abilityCDW and abilityCDW.Offset.Y == 0.5 and (abilitiesW["Raging Deflection"].Enabled or abilitiesW["Rapture"].Enabled) then
                                useAbility = true
                                Use_Ability:Fire()
                            end
                        end
                        if not useAbility then
                            if TriggerbotType == "Remote" then
                                if Is_Supported_Test then
                                    AutoParry.PerformRemoteParry(SelectedTriggerParryType)
                                    AutoParry.PerformRemoteParry(SelectedTriggerParryType)
                                else
                                    SimulateParry()
                                    SimulateParry()
                                    Parries += 2
                                    task.delay(0.5, function() if Parries > 0 then Parries -= 2 end end)
                                end
                            else
                                SimulateParry()
                                SimulateParry()
                                Parries += 2
                                task.delay(0.5, function() if Parries > 0 then Parries -= 2 end end)
                            end
                        end
                    end
                end
                prevUsingInfinityTB = usingInfinityW
            end)
        else
            for key, connection in pairs(Connections) do
                if key:match("^triggerbot_") then
                    connection:Disconnect()
                    Connections[key] = nil
                end
            end
            PostParryTarget = nil
            PostParryVelocityHistory = {}
            PostParryScheduled = {}
        end
    end,
})
TriggerbotToggle:AddKeybind({
    Id = "TriggerbotKey",
    Title = "Triggerbot keybind",
    Mode = "Toggle",
    Mobile = true,
    MobileText = "Triggerbot",
})
TriggerbotSection:AddDropdown({
    Id = "TriggerbotType",
    Title = "Parry Type",
    Options = parryTypeOptions,
    Default = parryTypeDefault,
    Callback = function(v)
        TriggerbotType = v
    end,
})
TriggerbotSection:AddDropdown({
    Id = "TriggerParryDirection",
    Title = "Curve Type",
    Options = curveTypeOptions,
    Default = "Camera",
    Callback = function(v)
        SelectedTriggerParryType = v
    end,
})
TriggerbotSection:AddDivider({Text = "Detection"})
TriggerbotSection:AddToggle({
    Id = "TriggerHighPingProtection",
    Title = "High Ping Protection",
    Style = "Checkbox",
    Callback = function(v)
        TriggerHighPingProtection = v
    end,
})
TriggerbotSection:AddToggle({
    Id = "TriggerAutoPostParry",
    Title = "Auto Pre-Click",
    Style = "Checkbox",
    Callback = function(v)
        if v then
            if isTriggerbotEnabled then
                Connections["triggerbot_postParry_deathMonitor"] = Alive.ChildRemoved:Connect(function(removedCharacter)
                    if not UI.State:Get("TriggerAutoPostParry") then return end
                    if not PostParryTarget or PostParryTarget == "" then return end
                    if removedCharacter.Name ~= PostParryTarget then return end
                    if PostParryScheduled[removedCharacter.Name] then return end
                    local hadHighSpeed = false
                    for ball, speeds in pairs(PostParryVelocityHistory) do
                        for _, speed in ipairs(speeds) do
                            if speed >= 800 then
                                hadHighSpeed = true
                                break
                            end
                        end
                        if hadHighSpeed then break end
                    end
                    if hadHighSpeed then
                        PostParryScheduled[removedCharacter.Name] = true
                        local randomDelay = (math.random(130, 160) / 1000)
                        task.delay(randomDelay, function()
                            SimulateParry()
                            PostParryScheduled[removedCharacter.Name] = nil
                        end)
                    end
                    PostParryTarget = nil
                    PostParryVelocityHistory = {}
                end)
            end
            Connections["triggerbot_postParry_continuousCheck"] = RunService.Heartbeat:Connect(function()
                if not UI.State:Get("TriggerAutoPostParry") then return end
                if not PostParryTarget or PostParryTarget == "" then return end
                if PostParryScheduled[PostParryTarget] then return end
                local targetChar = Alive:FindFirstChild(PostParryTarget)
                if not targetChar then
                    local hadHighSpeed = false
                    for ball, speeds in pairs(PostParryVelocityHistory) do
                        for _, speed in ipairs(speeds) do
                            if speed >= 800 then
                                hadHighSpeed = true
                                break
                            end
                        end
                        if hadHighSpeed then break end
                    end
                    if hadHighSpeed then
                        PostParryScheduled[PostParryTarget] = true
                        local randomDelay = (math.random(120, 140) / 1000)
                        task.delay(randomDelay, function()
                            SimulateParry()
                            PostParryScheduled[PostParryTarget] = nil
                        end)
                    end
                    PostParryTarget = nil
                    PostParryVelocityHistory = {}
                end
            end)
        else
            if Connections["triggerbot_postParry_deathMonitor"] then
                Connections["triggerbot_postParry_deathMonitor"]:Disconnect()
                Connections["triggerbot_postParry_deathMonitor"] = nil
            end
            if Connections["triggerbot_postParry_continuousCheck"] then
                Connections["triggerbot_postParry_continuousCheck"]:Disconnect()
                Connections["triggerbot_postParry_continuousCheck"] = nil
            end
            PostParryTarget = nil
            PostParryVelocityHistory = {}
            PostParryScheduled = {}
        end
    end,
})
TriggerbotSection:AddToggle({
    Id = "TriggerSingularityDetection",
    Title = "Singularity Detection",
    Style = "Checkbox",
    Callback = function(v)
        TriggerSingularity_Detection = v
    end,
})
TriggerbotSection:AddToggle({
    Id = "TriggerInfinityDetection",
    Title = "Infinity Detection",
    Style = "Checkbox",
    Callback = function(v)
        TriggerInfinity_Detection = v
    end,
})
TriggerbotSection:AddToggle({
    Id = "TriggerDeathSlashDetection",
    Title = "Death Slash Detection",
    Style = "Checkbox",
    Callback = function(v)
        TriggerDeathSlash_Detection = v
    end,
})

-- ================= Misc =================
VisualizerSection = MiscTab:AddSection({Title = "Visualizer", Description = "Visualizes the parry range", Icon = "circle-dot"})
VisualizerToggle = VisualizerSection:AddToggle({
    Id = "Visualizer",
    Title = "Visualizer",
    Description = "Visualizes the parry range",
    Default = false,
    Callback = function(v)
        ToggleViz(v)
    end,
})
VisualizerToggle:AddKeybind({Id = "VisualizerKey", Title = "Visualizer keybind", Mode = "Toggle", Mobile = true, MobileText = "Visualizer"})

AntiLagSection = MiscTab:AddSection({Title = "Anti-Lag", Description = "Reduces lag by optimizing graphics", Icon = "gauge"})
AntiLagSection:AddToggle({
    Id = "LagReducer",
    Title = "Anti-Lag",
    Description = "Reduces lag by optimizing graphics",
    Default = false,
    Callback = function(v)
        Optimize(v)
    end,
})

NoRenderSection = MiscTab:AddSection({Title = "No Render", Description = "Disables rendering of certain effects", Icon = "image-off"})
NoRenderSection:AddToggle({
    Id = "NoRender",
    Title = "No Render",
    Description = "Disables rendering of certain effects",
    Default = false,
    Callback = function(value)
        LocalPlayer.PlayerScripts.EffectScripts.ClientFX.Disabled = value
        if value then
            Connections['NoRender'] = Workspace.Runtime.ChildAdded:Connect(function(value)
                Debris:AddItem(value, 0)
            end)
        else
            if Connections['NoRender'] then
                Connections['NoRender']:Disconnect()
                Connections['NoRender'] = nil
            end
        end
    end,
})

AbilityESPSection = MiscTab:AddSection({Title = "Ability ESP", Description = "Shows opponents abilities", Icon = "eye"})
Billboard_Labels = {}
ConnectionsTable = {}
AbilityESPSection:AddToggle({
    Id = "AbilityESP",
    Title = "Ability ESP",
    Description = "Shows opponents abilities",
    Default = false,
    Callback = function(state)
        if state then
            local function updateLabel(player)
                local text = Billboard_Labels[player]
                if text and player.Character then
                    local ability = player:GetAttribute("EquippedAbility")
                    if ability then
                        text.Text = player.DisplayName .. " [" .. ability .. "]"
                    else
                        text.Text = player.DisplayName .. " [ In Lobby ]"
                    end
                    text.Parent.Enabled = true
                end
            end
            local function createLabel(player)
                if player == LocalPlayer then return end
                local char = player.Character or player.CharacterAdded:Wait()
                local head = char:WaitForChild("Head")
                local label = Instance.new("BillboardGui")
                label.Name = "AbilityESP"
                label.Parent = head
                label.Adornee = head
                label.Size = UDim2.new(0, 220, 0, 60)
                label.StudsOffset = Vector3.new(0, 3, 0)
                label.AlwaysOnTop = true
                local text = Instance.new("TextLabel")
                text.Parent = label
                text.BackgroundTransparency = 1
                text.Size = UDim2.new(1, 0, 1, 0)
                text.TextColor3 = Color3.new(1, 1, 1)
                text.TextSize = 18
                text.Font = Enum.Font.GothamBold
                Billboard_Labels[player] = text
                updateLabel(player)
                local abilityConn = player:GetAttributeChangedSignal("EquippedAbility"):Connect(function()
                    updateLabel(player)
                end)
                table.insert(ConnectionsTable, abilityConn)
            end
            for _, player in pairs(Players:GetPlayers()) do
                createLabel(player)
                local charConn = player.CharacterAdded:Connect(function()
                    createLabel(player)
                end)
                table.insert(ConnectionsTable, charConn)
            end
            local playerAddedConn = Players.PlayerAdded:Connect(function(player)
                createLabel(player)
                local charConn = player.CharacterAdded:Connect(function()
                    createLabel(player)
                end)
                table.insert(ConnectionsTable, charConn)
            end)
            table.insert(ConnectionsTable, playerAddedConn)
        else
            for _, conn in pairs(ConnectionsTable) do
                if conn.Connected then
                    conn:Disconnect()
                end
            end
            ConnectionsTable = {}
            for player, text in pairs(Billboard_Labels) do
                if text and text.Parent then
                    text.Parent:Destroy()
                end
            end
            Billboard_Labels = {}
        end
    end,
})

SkySection = MiscTab:AddSection({Title = "Sky Settings", Description = "Lets you change the sky to your liking", Icon = "cloud"})
SkySection:AddDropdown({
    Id = "SkyBoxOptions",
    Title = "Sky Box Options",
    Options = {"None", "Space Wave", "Space Wave2", "Turquoise Wave", "Dark Night", "Bright Pink", "White Galaxy"},
    Default = "None",
    Callback = function(value)
        local Sky = game.Lighting:FindFirstChildOfClass("Sky") or Instance.new("Sky", game.Lighting)
        if value == "None" then
            for _, prop in pairs({"SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp"}) do
                Sky[prop] = ""
            end
            game.Lighting.GlobalShadows = true
        else
            local SkyboxLoader = loadstring(game:HttpGet("https://raw.githubusercontent.com/Forexium/eclipse/main/Skyboxes.lua", true))()
            local skyboxData = SkyboxLoader[value]
            for index, prop in next, {"SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp"} do
                Sky[prop] = "rbxassetid://" .. skyboxData[index]
            end
            game.Lighting.GlobalShadows = false
        end
    end,
})

LightingSection = MiscTab:AddSection({Title = "Lighting Settings", Description = "Tweak the lighting to your liking", Icon = "sun"})
LightingSection:AddToggle({
    Id = "FullBright",
    Title = "Full Bright",
    Style = "Checkbox",
    Default = false,
    Callback = function(value)
        if value then
            game.Lighting.GlobalShadows = false
            game.Lighting.Ambient = Color3.new(1, 1, 1)
        else
            game.Lighting.GlobalShadows = true
            game.Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
        end
    end,
})
LightingSection:AddToggle({
    Id = "CustomLighting",
    Title = "Custom Lighting",
    Style = "Checkbox",
    Default = false,
    Callback = function(value)
        if value then
            game.Lighting.Ambient = Color3.new(1, 1, 1)
            game.Lighting.Brightness = 2
        else
            game.Lighting.Ambient = Color3.new(0.5, 0.5, 0.5)
            game.Lighting.Brightness = 1
        end
    end,
})
LightingSection:AddSlider({
    Id = "TimeOfDay",
    Title = "Time of Day",
    Min = 0,
    Max = 24,
    Default = 12,
    Step = 1,
    Suffix = "h",
    Callback = function(value)
        game.Lighting.ClockTime = value
    end,
})

function ClearHead(char)
    local head = char:WaitForChild("Head")
    head.Transparency = 1
    for _, child in pairs(head:GetChildren()) do
        if child:IsA("Decal") then
            child:Destroy()
        end
    end
end
function ClearHeadless(char)
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 0
        if OriginalFaceTexture then
            local face = Instance.new("Decal")
            face.Name = "face"
            face.Texture = OriginalFaceTexture
            face.Parent = head
        end
    end
end
function Korbloxify(char)
    if char:FindFirstChild("KorbloxLeg") then return end
    local rightLeg = char:WaitForChild("Right Leg")
    rightLeg.Transparency = 1
    rightLeg.CanCollide = false
    local korbloxLeg = Instance.new("Part")
    korbloxLeg.Name = "KorbloxLeg"
    korbloxLeg.Size = rightLeg.Size
    korbloxLeg.Anchored = true
    korbloxLeg.CanCollide = false
    korbloxLeg.Parent = char
    local mesh = Instance.new("SpecialMesh")
    mesh.MeshId = "http://www.roblox.com/asset/?id=12917863813"
    mesh.TextureId = "http://roblox.com/asset/?id=12917863954"
    mesh.Scale = Vector3.new(1.5, 1.5, 1.5)
    mesh.Parent = korbloxLeg
    task.delay(0, function()
        if char and char.Parent then
            KorbloxConnection = RunService.RenderStepped:Connect(function()
                if rightLeg and korbloxLeg then
                    korbloxLeg.CFrame = rightLeg.CFrame * CFrame.Angles(0, math.rad(180), 0) * CFrame.new(0, 0.5, 0)
                else
                    KorbloxConnection:Disconnect()
                    KorbloxConnection = nil
                end
            end)
        end
    end)
end
function ClearKorblox(char)
    if KorbloxConnection then
        KorbloxConnection:Disconnect()
        KorbloxConnection = nil
    end
    local korbloxLeg = char:FindFirstChild("KorbloxLeg")
    if korbloxLeg then
        korbloxLeg:Destroy()
    end
    local rightLeg = char:FindFirstChild("Right Leg")
    if rightLeg then
        rightLeg.Transparency = 0
        rightLeg.CanCollide = true
    end
end
function EnsureModifications()
    local char = LocalPlayer.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if head then
        head.Transparency = 1
        for _, child in pairs(head:GetChildren()) do
            if child:IsA("Decal") then
                child:Destroy()
            end
        end
    end
    local rightLeg = char:FindFirstChild("Right Leg")
    if rightLeg then
        rightLeg.Transparency = 1
        rightLeg.CanCollide = false
    end
    if not char:FindFirstChild("KorbloxLeg") then
        Korbloxify(char)
    end
end

KorbloxSection = MiscTab:AddSection({Title = "Korblox & Headless", Description = "Enable Korblox & Headless", Icon = "bone"})
KorbloxSection:AddToggle({
    Id = "KorbloxHeadless",
    Title = "Korblox & Headless",
    Description = "Enable Korblox & Headless",
    Default = false,
    Callback = function(value)
        local character = LocalPlayer.Character
        if not character then return end
        if value then
            local head = character:FindFirstChild("Head")
            if head then
                local face = head:FindFirstChild("face")
                if face and face:IsA("Decal") then
                    OriginalFaceTexture = face.Texture
                end
            end
            ClearHead(character)
            if HeadDecalConnection then HeadDecalConnection:Disconnect() end
            HeadDecalConnection = head.ChildAdded:Connect(function(child)
                if child:IsA("Decal") then
                    child:Destroy()
                end
            end)
            Korbloxify(character)
            if not Check_Refresh then
                Check_Refresh = RunService.Heartbeat:Connect(EnsureModifications)
            end
        else
            if HeadDecalConnection then
                HeadDecalConnection:Disconnect()
                HeadDecalConnection = nil
            end
            ClearHeadless(character)
            ClearKorblox(character)
            if Check_Refresh then
                Check_Refresh:Disconnect()
                Check_Refresh = nil
            end
            OriginalFaceTexture = nil
        end
    end,
})

songList = {}
for name in pairs(soundOptions) do
    table.insert(songList, name)
end
MusicSection = MiscTab:AddSection({Title = "Music Player", Description = "Play music in game", Icon = "music"})
MusicSection:AddToggle({
    Id = "EnableMusic",
    Title = "Enable Music",
    Style = "Checkbox",
    Default = false,
    Callback = function(v)
        if v then
            if not Music then
                Music = Instance.new("Sound")
                Music.Name = "OxyoMusic"
                Music.Parent = Workspace
                Music.Looped = true
            end
            Music.SoundId = soundOptions[SelectedSong]
            Music.Volume = MusicVolume
            Music:Play()
        else
            if Music then
                Music:Stop()
            end
        end
    end,
})
MusicSection:AddSlider({
    Id = "MusicVolume",
    Title = "Volume",
    Min = 1,
    Max = 10,
    Default = 5,
    Step = 1,
    Callback = function(value)
        MusicVolume = value
        if Music then
            Music.Volume = value
        end
    end,
})
MusicSection:AddDropdown({
    Id = "SongChoice",
    Title = "Song Choice",
    Options = songList,
    Default = "EEYUH!",
    Callback = function(value)
        SelectedSong = value
        if Music then
            Music.SoundId = soundOptions[value]
            Music:Play()
        end
    end,
})

-- ================= Misc / Ball Info overlays =================
mainLocalPlayer = Players.LocalPlayer
speedGui = Instance.new("ScreenGui")
speedGui.Name = "OxyoBallStats"
speedGui.Parent = mainLocalPlayer.PlayerGui
speedGui.ResetOnSpawn = false

speedLabel = Instance.new("TextLabel")
speedLabel.Name = "Speed"
speedLabel.Size = UDim2.new(0, 200, 0, 50)
speedLabel.Position = UDim2.new(1, -210, 0, 10)
speedLabel.AnchorPoint = Vector2.new(1, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.TextColor3 = Color3.new(1, 1, 1)
speedLabel.TextSize = 20
speedLabel.Font = Enum.Font.GothamBlack
speedLabel.TextXAlignment = Enum.TextXAlignment.Right
speedLabel.TextYAlignment = Enum.TextYAlignment.Top
speedLabel.Text = ""
speedLabel.Parent = speedGui

lobbySpeedGui = Instance.new("ScreenGui")
lobbySpeedGui.Name = "OxyoLobbyStats"
lobbySpeedGui.Parent = mainLocalPlayer.PlayerGui
lobbySpeedGui.ResetOnSpawn = false

lobbySpeedLabel = Instance.new("TextLabel")
lobbySpeedLabel.Name = "LobbySpeed"
lobbySpeedLabel.Size = UDim2.new(0, 200, 0, 50)
lobbySpeedLabel.Position = UDim2.new(1, -210, 0, 60)
lobbySpeedLabel.AnchorPoint = Vector2.new(1, 0)
lobbySpeedLabel.BackgroundTransparency = 1
lobbySpeedLabel.TextColor3 = Color3.new(1, 1, 1)
lobbySpeedLabel.TextSize = 20
lobbySpeedLabel.Font = Enum.Font.GothamBlack
lobbySpeedLabel.TextXAlignment = Enum.TextXAlignment.Right
lobbySpeedLabel.TextYAlignment = Enum.TextYAlignment.Top
lobbySpeedLabel.Text = ""
lobbySpeedLabel.Parent = lobbySpeedGui

curveGui = Instance.new("ScreenGui")
curveGui.Name = "OxyoCurveStats"
curveGui.Parent = mainLocalPlayer.PlayerGui
curveGui.ResetOnSpawn = false

curveLabel = Instance.new("TextLabel")
curveLabel.Name = "Curve"
curveLabel.Size = UDim2.new(0, 200, 0, 50)
curveLabel.Position = UDim2.new(1, -210, 0, 70)
curveLabel.AnchorPoint = Vector2.new(1, 0)
curveLabel.BackgroundTransparency = 1
curveLabel.TextColor3 = Color3.new(1, 1, 1)
curveLabel.TextSize = 20
curveLabel.Font = Enum.Font.GothamBlack
curveLabel.TextXAlignment = Enum.TextXAlignment.Right
curveLabel.TextYAlignment = Enum.TextYAlignment.Top
curveLabel.Text = ""
curveLabel.Parent = curveGui

function GetLobbyBall()
    for _, instance in pairs(Workspace.TrainingBalls:GetChildren()) do
        if instance:IsA("BasePart") and instance:GetAttribute("realBall") then
            instance.CanCollide = false
            return instance
        end
    end
    return nil
end

BallInfoSection = MiscTab:AddSection({Title = "Ball Info", Description = "Shows info about the ball like speed", Icon = "activity"})
BallInfoSection:AddToggle({
    Id = "BallSpeedStats",
    Title = "Ball Speed Stats",
    Style = "Checkbox",
    Default = false,
    Callback = function(v)
        if not v then
            if speedGui.Parent then
                speedLabel.Text = ""
            end
        end
    end,
})
BallInfoSection:AddToggle({
    Id = "LobbyBallSpeedStats",
    Title = "Lobby Ball Speed Stats",
    Style = "Checkbox",
    Default = false,
    Callback = function(v)
        if not v then
            if lobbySpeedGui.Parent then
                lobbySpeedLabel.Text = ""
            end
        end
    end,
})
BallInfoSection:AddToggle({
    Id = "BallCurveInfo",
    Title = "Ball Curve Info",
    Style = "Checkbox",
    Default = false,
    Callback = function(v)
        if not v then
            if curveGui.Parent then
                curveLabel.Text = ""
            end
        end
    end,
})

Connections["ballinfo_render"] = RunService.RenderStepped:Connect(function()
    local ingameVelocity = UI.State:Get("BallSpeedStats")
    local lobbyVelocity = UI.State:Get("LobbyBallSpeedStats")
    local curveInfo = UI.State:Get("BallCurveInfo")
    if ingameVelocity then
        local ball = AutoParry.GetBall()
        if ball then
            local velocity = ball.Velocity.Magnitude
            if velocity > PeakVel then
                PeakVel = velocity
            end
            speedLabel.Text = "ball velocity: " .. tostring(math.floor(velocity)) .. "\npeak velocity: " .. tostring(math.floor(PeakVel))
        else
            speedLabel.Text = "ball velocity: undefined\npeak velocity: undefined"
            PeakVel = 0
        end
    else
        speedLabel.Text = ""
    end
    if lobbyVelocity then
        local lobbyBall = GetLobbyBall()
        if lobbyBall then
            local velocity = lobbyBall.Velocity.Magnitude
            lobbySpeedLabel.Text = "L BALL velocity: " .. tostring(math.floor(velocity))
        else
            lobbySpeedLabel.Text = "L BALL velocity: undefined"
        end
        lobbySpeedLabel.Position = ingameVelocity and UDim2.new(1, -210, 0, 60) or UDim2.new(1, -210, 0, 10)
    else
        lobbySpeedLabel.Text = ""
    end
    if curveInfo then
        local ball = AutoParry.GetBall()
        if ball then
            local curved = AutoParry.IsCurved(ball)
            curveLabel.Text = "curved: " .. (curved and "yes" or "no")
        else
            curveLabel.Text = "curved: undefined"
        end
        local posY = 10
        if ingameVelocity then posY = posY + 50 end
        if lobbyVelocity then posY = posY + 50 end
        curveLabel.Position = UDim2.new(1, -210, 0, posY)
    else
        curveLabel.Text = ""
    end
end)

Connections["overlay_charadded"] = mainLocalPlayer.CharacterAdded:Connect(function()
    if speedGui.Parent then
        speedGui:Destroy()
    end
    speedGui = Instance.new("ScreenGui")
    speedGui.Name = "OxyoBallStats"
    speedGui.Parent = mainLocalPlayer.PlayerGui
    speedGui.ResetOnSpawn = false
    speedLabel = Instance.new("TextLabel")
    speedLabel.Name = "Speed"
    speedLabel.Size = UDim2.new(0, 200, 0, 50)
    speedLabel.Position = UDim2.new(1, -210, 0, 10)
    speedLabel.AnchorPoint = Vector2.new(1, 0)
    speedLabel.BackgroundTransparency = 1
    speedLabel.TextColor3 = Color3.new(1, 1, 1)
    speedLabel.TextSize = 20
    speedLabel.Font = Enum.Font.GothamBlack
    speedLabel.TextXAlignment = Enum.TextXAlignment.Right
    speedLabel.TextYAlignment = Enum.TextYAlignment.Top
    speedLabel.Text = UI.State:Get("BallSpeedStats") and "ball velocity: N/A\npeak velocity: N/A" or ""
    speedLabel.Parent = speedGui
    if lobbySpeedGui.Parent then
        lobbySpeedGui:Destroy()
    end
    lobbySpeedGui = Instance.new("ScreenGui")
    lobbySpeedGui.Name = "OxyoLobbyStats"
    lobbySpeedGui.Parent = mainLocalPlayer.PlayerGui
    lobbySpeedGui.ResetOnSpawn = false
    lobbySpeedLabel = Instance.new("TextLabel")
    lobbySpeedLabel.Name = "LobbySpeed"
    lobbySpeedLabel.Size = UDim2.new(0, 200, 0, 50)
    lobbySpeedLabel.Position = UDim2.new(1, -210, 0, 60)
    lobbySpeedLabel.AnchorPoint = Vector2.new(1, 0)
    lobbySpeedLabel.BackgroundTransparency = 1
    lobbySpeedLabel.TextColor3 = Color3.new(1, 1, 1)
    lobbySpeedLabel.TextSize = 20
    lobbySpeedLabel.Font = Enum.Font.GothamBlack
    lobbySpeedLabel.TextXAlignment = Enum.TextXAlignment.Right
    lobbySpeedLabel.TextYAlignment = Enum.TextYAlignment.Top
    lobbySpeedLabel.Text = UI.State:Get("LobbyBallSpeedStats") and "lobby ball velocity: N/A" or ""
    lobbySpeedLabel.Parent = lobbySpeedGui
    if curveGui.Parent then
        curveGui:Destroy()
    end
    curveGui = Instance.new("ScreenGui")
    curveGui.Name = "OxyoCurveStats"
    curveGui.Parent = mainLocalPlayer.PlayerGui
    curveGui.ResetOnSpawn = false
    curveLabel = Instance.new("TextLabel")
    curveLabel.Name = "Curve"
    curveLabel.Size = UDim2.new(0, 200, 0, 50)
    curveLabel.Position = UDim2.new(1, -210, 0, 70)
    curveLabel.AnchorPoint = Vector2.new(1, 0)
    curveLabel.BackgroundTransparency = 1
    curveLabel.TextColor3 = Color3.new(1, 1, 1)
    curveLabel.TextSize = 20
    curveLabel.Font = Enum.Font.GothamBlack
    curveLabel.TextXAlignment = Enum.TextXAlignment.Right
    curveLabel.TextYAlignment = Enum.TextYAlignment.Top
    curveLabel.Text = UI.State:Get("BallCurveInfo") and "Curved: N/A" or ""
    curveLabel.Parent = curveGui
end)

-- ================= Misc / Gravity & FOV =================
GravitySection = MiscTab:AddSection({Title = "Gravity", Description = "Little Fun Gravity Slider", Icon = "arrow-down"})
GravitySection:AddSlider({
    Id = "CustomGravity",
    Title = "Custom Gravity",
    Min = 0,
    Max = 500,
    Default = 196.2,
    Step = 0.1,
    Callback = function(value)
        Workspace.Gravity = value
    end,
})

FOVSection = MiscTab:AddSection({Title = "Field Of View", Description = "Change camera FOV", Icon = "camera"})
FOVSection:AddSlider({
    Id = "FieldOfViewValue",
    Title = "FOV Value",
    Min = 70,
    Max = 120,
    Default = 70,
    Step = 1,
    Callback = function(value)
        local camera = Workspace.CurrentCamera
        if camera then
            camera.FieldOfView = value
        end
    end,
})
Connections["fov_charadded"] = LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.1)
    local camera = Workspace.CurrentCamera
    if camera then
        camera.FieldOfView = UI.State:Get("FieldOfViewValue") or 70
    end
end)

-- ================= AI Play =================
AIPlaying = false
AICoroutine = nil
AILastPos = Vector3.new(0, 0, 0)
AIStuckTimer = 0
AIPathTime = 0
AICurvePoint = nil
AILastUpdate = 0
AILastDoubleJumpTime = 0
AIJumpAnimation = nil
AIFeintTimer = 0
AIFeintActive = false
AIFeintCooldown = 0
AIDidJump = false
AILastJumpTime = 0

function IsStuck(currentPos)
    if (currentPos - AILastPos).Magnitude < 1 then
        AIStuckTimer = AIStuckTimer + 1
    else
        AIStuckTimer = 0
    end
    AILastPos = currentPos
    return AIStuckTimer > 5
end

function MoveToPos(character, targetPos)
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local primaryPart = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart
    if not humanoid or not primaryPart then return end
    humanoid:MoveTo(targetPos)
end

function SmoothLerp(start, finish, alpha)
    return start + (finish - start) * alpha
end

function BezierCurve(start, middle, finish, alpha)
    local point1 = SmoothLerp(start, middle, alpha)
    local point2 = SmoothLerp(middle, finish, alpha)
    return SmoothLerp(point1, point2, alpha)
end

function CalculateCurvePoint(start, finish)
    local midpoint = (start + finish) * 0.5
    local delta = start - finish

    if delta.Magnitude < 5 then
        return finish
    end

    local angle = math.atan2(delta.Z, delta.X)
    local curveDistance = delta.Magnitude * 0.7

    local option1X = math.cos(angle + math.pi / 2)
    local option1Z = math.sin(angle + math.pi / 2)
    local option1 = midpoint + Vector3.new(option1X, 0, option1Z) * curveDistance

    local option2X = math.cos(angle - math.pi / 2)
    local option2Z = math.sin(angle - math.pi / 2)
    local option2 = midpoint + Vector3.new(option2X, 0, option2Z) * curveDistance

    local direction = start - midpoint

    if (option1 - midpoint):Dot(direction) < 0 then
        return option1
    else
        return option2
    end
end

function GetCurvedPath(start, finish, deltaTime)
    AIPathTime = AIPathTime + deltaTime
    local progress = math.clamp(AIPathTime / 0.9, 0, 1)

    if progress >= 1 then
        local gap = (start - finish).Magnitude
        if gap >= 10 then
            AIPathTime = 0
        end
        AICurvePoint = nil
        return finish
    end

    if not AICurvePoint then
        AICurvePoint = CalculateCurvePoint(start, finish)
    end

    return BezierCurve(start, AICurvePoint, finish, progress)
end

function CheckPercentage(threshold)
    local elapsed = tick() - AILastUpdate
    if elapsed < 0.3 then
        return false
    end

    local roll = math.random(100)
    AILastUpdate = tick()

    return threshold >= roll
end

function FindMapFloor()
    local floor = Workspace:FindFirstChild("FLOOR")

    if not floor then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("MeshPart") or obj:IsA("BasePart") then
                local dimensions = obj.Size
                if dimensions.X > 50 and dimensions.Z > 50 and obj.Position.Y < 5 then
                    return obj
                end
            end
        end
    end

    return floor
end

function LoadJumpAnimation(character)
    if AIJumpAnimation then
        AIJumpAnimation:Destroy()
        AIJumpAnimation = nil
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or not humanoid.Animator then return end

    local animAsset = ReplicatedStorage.Assets.Tutorial.Animations.DoubleJump
    AIJumpAnimation = humanoid.Animator:LoadAnimation(animAsset)
end

function GetPing()
    local success, ping = pcall(function()
        return game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue()
    end)
    return success and ping or 50
end

function GetClosestPlayerDistance(rootPart)
    local closestDist = math.huge
    for _, player in pairs(game.Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character and player.Character.PrimaryPart then
            local distance = (rootPart.Position - player.Character.PrimaryPart.Position).Magnitude
            if distance < closestDist then
                closestDist = distance
            end
        end
    end
    return closestDist
end

function IsInDangerZone(rootPart)
    local minDistance = GetClosestPlayerDistance(rootPart)
    return minDistance < 15
end

function CalculateTargetPosition(ball, rootPart)
    local floor = FindMapFloor()
    if not floor or not ball then
        return nil
    end

    local zoomies = ball:FindFirstChild('zoomies')
    local ballVelocity = zoomies and zoomies.VectorVelocity or ball.Velocity
    local ballSpeed = ballVelocity.Magnitude

    local awayDirection = (rootPart.Position - ball.Position).Unit

    local baseGap = 35
    local speedBonus = 0

    local minPlayerDist = GetClosestPlayerDistance(rootPart)
    local safetyBonus = 0
    if minPlayerDist < 20 then
        safetyBonus = (20 - minPlayerDist) * 2
    end

    if AIFeintActive then
        if ballSpeed > 700 then
            speedBonus = -50
        elseif ballSpeed > 500 then
            speedBonus = -35
        elseif ballSpeed > 300 then
            speedBonus = -20
        else
            speedBonus = -12
        end
    else
        if ballSpeed >= 800 then
            speedBonus = 120
        elseif ballSpeed >= 700 then
            speedBonus = 95
        elseif ballSpeed >= 600 then
            speedBonus = 75
        elseif ballSpeed >= 500 then
            speedBonus = 55
        elseif ballSpeed >= 400 then
            speedBonus = 40
        elseif ballSpeed >= 300 then
            speedBonus = 28
        elseif ballSpeed >= 200 then
            speedBonus = 18
        else
            speedBonus = 10
        end
    end

    local totalGap = baseGap + speedBonus + safetyBonus
    local retreatVector = awayDirection * totalGap

    local timeValue = os.time() / 1.4
    local xWave = math.sin(timeValue) * 30
    local zWave = math.cos(timeValue) * 30

    local movement = Vector3.new(xWave, 0, zWave)
    local destination = floor.Position + retreatVector + movement

    local bounds = floor.Size
    local xLimit = bounds.X / 2 - 8
    local zLimit = bounds.Z / 2 - 8

    local finalX = math.clamp(destination.X, floor.Position.X - xLimit, floor.Position.X + xLimit)
    local finalZ = math.clamp(destination.Z, floor.Position.Z - zLimit, floor.Position.Z + zLimit)

    return Vector3.new(finalX, floor.Position.Y + 5, finalZ)
end

function ExecuteDoubleJump(character)
    local currentTime = tick()

    if currentTime - AILastJumpTime > 2 then
        return
    end

    if currentTime - AILastDoubleJumpTime < 2 then
        return
    end

    if not CheckPercentage(Double_Jump_Chance) then
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if humanoid.FloorMaterial ~= Enum.Material.Air and humanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
        return
    end

    AILastDoubleJumpTime = currentTime

    local ping = GetPing()
    local animDelay = math.clamp(ping / 1000 * 0.5, 0.02, 0.08)

    local force = math.huge
    local boost = Instance.new("BodyVelocity")
    boost.MaxForce = Vector3.new(force, force, force)
    boost.Velocity = Vector3.new(0, 80, 0)
    boost.Parent = character.HumanoidRootPart

    game:GetService("Debris"):AddItem(boost, 0.001)
    ReplicatedStorage.Remotes.DoubleJump:FireServer()

    task.delay(animDelay, function()
        if not character or not character:FindFirstChild("Humanoid") then return end

        local currentHumanoid = character:FindFirstChild("Humanoid")

        if currentHumanoid.FloorMaterial ~= Enum.Material.Air or
           currentHumanoid:GetState() ~= Enum.HumanoidStateType.Freefall then
            return
        end

        if not AIJumpAnimation then
            LoadJumpAnimation(character)
        end

        if AIJumpAnimation then
            AIJumpAnimation:Play()
        end
    end)
end

function PerformJump(character)
    if not Can_Jump then
        return
    end

    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    if humanoid.FloorMaterial ~= Enum.Material.Air then
        if not CheckPercentage(Jump_Chance) then
            return
        end

        AILastJumpTime = tick()
        humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
    else
        if humanoid:GetState() == Enum.HumanoidStateType.Freefall then
            ExecuteDoubleJump(character)
        end
    end
end

function UpdateFeintBehavior()
    local currentTime = tick()

    if AIFeintCooldown > currentTime then
        return
    end

    if AIFeintActive then
        if currentTime - AIFeintTimer > math.random(150, 350) / 100 then
            AIFeintActive = false
            AIFeintCooldown = currentTime + math.random(10, 18)
        end
    else
        if math.random(100) <= 12 then
            AIFeintActive = true
            AIFeintTimer = currentTime
        end
    end
end

AIMethods = {
    BallChaser = function(character)
        if IsAutoSpamming or (ClashEndTime > 0 and tick() - ClashEndTime < 2.5) then
            return
        end

        local rootPart = character:FindFirstChild("HumanoidRootPart") or character.PrimaryPart
        if not rootPart then return end

        if UI.State:Get("StopWhenClash") and IsInDangerZone(rootPart) then
            MoveToPos(character, rootPart.Position)
            return
        end

        if not AIJumpAnimation then
            LoadJumpAnimation(character)
        end

        if IsStuck(rootPart.Position) and Can_Jump then
            local humanoid = character:FindFirstChildOfClass("Humanoid")
            if humanoid then
                humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
            end
        end

        local ball = AutoParry.GetBall()
        if ball then
            UpdateFeintBehavior()

            local targetSpot = CalculateTargetPosition(ball, rootPart)

            if not targetSpot then
                return
            end

            local smoothPath = GetCurvedPath(rootPart.Position, targetSpot, 0.1)
            MoveToPos(character, smoothPath)
            PerformJump(character)
        else
            local randomWander = rootPart.Position + Vector3.new(math.random(-12, 12), 0, math.random(-12, 12))
            MoveToPos(character, randomWander)
        end
    end
}

function RunAI()
    while AIPlaying do
        local char = LocalPlayer.Character
        if char then
            AIMethods["BallChaser"](char)
        end
        task.wait(0.1)
    end
end

Connections["ai_charadded"] = LocalPlayer.CharacterAdded:Connect(function(char)
    task.wait(0.5)
    if AIPlaying then
        AIJumpAnimation = nil
        AILastDoubleJumpTime = 0
        AILastJumpTime = 0
        LoadJumpAnimation(char)
    end
end)

AISection = AITab:AddSection({Title = "AI Play", Description = "Good for legit, auto plays for you", Icon = "bot"})
AIPlayToggle = AISection:AddToggle({
    Id = "AIPlay",
    Title = "AI Play",
    Description = "Good for legit, auto plays for you",
    Default = false,
    Callback = function(v)
        AIPlaying = v
        if AIPlaying then
            if AICoroutine then task.cancel(AICoroutine) end
            AICoroutine = task.spawn(RunAI)
            getgenv().OXYO_AICOROUTINE = AICoroutine
        elseif AICoroutine then
            task.cancel(AICoroutine)
            AICoroutine = nil
            getgenv().OXYO_AICOROUTINE = nil
        end
    end,
})
AIPlayToggle:AddKeybind({Id = "AIPlayKey", Title = "AI Play keybind", Mode = "Toggle", Mobile = true, MobileText = "AI Play"})
AISection:AddToggle({
    Id = "StopWhenClash",
    Title = "Stop When Clash Incoming",
    Style = "Checkbox",
    Callback = function(v) end,
})
AISection:AddToggle({
    Id = "AutoVote",
    Title = "Auto Vote",
    Style = "Checkbox",
    Callback = function(v)
        if v then
            task.spawn(function()
                while UI.State:Get("AutoVote") do
                    local ohString1 = "FFA"
                    game:GetService("ReplicatedStorage").Packages._Index["sleitnick_net@0.1.0"].net["RE/UpdateVotes"]:FireServer(ohString1)
                    task.wait(1)
                end
            end)
        end
    end,
})

function Enable_ANTIAFK()
    local GC = getconnections or get_signal_cons
    if GC then
        for i,v in pairs(GC(Players.LocalPlayer.Idled)) do
            if v["Disable"] then
                v["Disable"](v)
            elseif v["Disconnect"] then
                v["Disconnect"](v)
            end
        end
    else
        local VirtualUser = cloneref(game:GetService("VirtualUser"))
        AntiAFKConnection = Players.LocalPlayer.Idled:Connect(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end
end

function Disable_ANTIAFK()
    if AntiAFKConnection then
        AntiAFKConnection:Disconnect()
        AntiAFKConnection = nil
    end
end

AISection:AddToggle({
    Id = "AntiAFK",
    Title = "Anti AFK",
    Style = "Checkbox",
    Callback = function(v)
        if v then
            Enable_ANTIAFK()
        else
            Disable_ANTIAFK()
        end
    end,
})
AISection:AddToggle({
    Id = "EnableJumping",
    Title = "Enable Jumping",
    Style = "Checkbox",
    Callback = function(v)
        Can_Jump = v
    end,
})
AISection:AddDivider({Text = "Tuning"})
AISection:AddSlider({
    Id = "DistanceFromBall",
    Title = "Distance from Ball",
    Min = 10,
    Max = 50,
    Default = 30,
    Step = 1,
    Suffix = " studs",
    Callback = function(v)
        Ball_Distance = v
    end,
})
AISection:AddSlider({
    Id = "Speed_Multiplier",
    Title = "Speed Multiplier",
    Min = 0,
    Max = 100,
    Default = 50,
    Step = 1,
    Callback = function(v)
        Speed_Multiplier = v
    end,
})
AISection:AddSlider({
    Id = "Transversing",
    Title = "Transversing",
    Min = 0,
    Max = 50,
    Default = 10,
    Step = 1,
    Callback = function(v)
        Turn_Radius = v
    end,
})
AISection:AddSlider({
    Id = "JumpChance",
    Title = "Jump Chance",
    Min = 0,
    Max = 100,
    Default = 50,
    Step = 1,
    Suffix = "%",
    Callback = function(v)
        Jump_Chance = v
    end,
})
AISection:AddSlider({
    Id = "DoubleJumpChance",
    Title = "Double Jump Chance",
    Min = 0,
    Max = 100,
    Default = 20,
    Step = 1,
    Suffix = "%",
    Callback = function(v)
        Double_Jump_Chance = v
    end,
})

-- ================= Auto Farm =================
AutoFarmSection = AutoFarmTab:AddSection({Title = "Auto Ranked Queue", Description = "Automatically queues ranked for you", Icon = "trophy"})
AutoFarmSection:AddToggle({
    Id = "AutoRankedQueue",
    Title = "Auto Ranked Queue",
    Description = "Automatically queues ranked for you",
    Default = false,
    Callback = function(v)
        if v then
            if game.PlaceId == 14915220621 or game.PlaceId == 14732610803 then
                local args = {
                    "Ranked",
                    "FFA",
                    "Normal",
                    "Auto"
                }
                game:GetService("ReplicatedStorage"):WaitForChild("Remotes"):WaitForChild("JoinQueue"):FireServer(unpack(args))
            else
                print("PlaceId Doesn't Match ")
            end
        end
    end,
})

-- ============================================================
-- Global runtime handlers
-- ============================================================

Connections["parry_success_all"] = ReplicatedStorage.Remotes.ParrySuccessAll.OnClientEvent:Connect(function(_, root)
    if root.Parent and root.Parent ~= LocalPlayer.Character then
        if root.Parent.Parent ~= Workspace.Alive then
            return
        end
        local ball = AutoParry.GetBall()
        if not ball then return end
        local zoomies = ball:FindFirstChild('zoomies')
        if not zoomies then return end
        local Speed = zoomies.VectorVelocity.Magnitude
        local Distance = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Magnitude
        local Velocity = zoomies.VectorVelocity
        local Ball_Direction = Velocity.Unit
        local Direction = (LocalPlayer.Character.PrimaryPart.Position - ball.Position).Unit
        local Dot = Direction:Dot(Ball_Direction)
        local Speed_Threshold = math.min(Speed / 100, 40)
        local Angle_Threshold = 40 * math.max(Dot, 0)
        local Ping = game:GetService('Stats').Network.ServerStatsItem['Data Ping']:GetValue()
        local Reach_Time = Distance / Speed - (Ping / 1000)
        local Enough_Speed = Speed > 100
        local Ball_Distance_Threshold = 15 - math.min(Distance / 1000, 15) - Angle_Threshold + Speed_Threshold
        if Enough_Speed and Reach_Time > Ping / 10 then
            Ball_Distance_Threshold = math.max(Ball_Distance_Threshold - 15, 15)
        end
        if root ~= LocalPlayer.Character.PrimaryPart and Distance > Ball_Distance_Threshold then
            Curve_Time = tick()
        end
    end
    AutoParry.ClosestPlayer()
    local ball = AutoParry.GetBall()
    if not ball or not GrabParry then return end
    GrabParry:Stop()
end)

Connections["parry_success"] = ReplicatedStorage.Remotes.ParrySuccess.OnClientEvent:Connect(function()
    if LocalPlayer.Character.Parent ~= Workspace.Alive then return end
    if not GrabParry then return end
    GrabParry:Stop()
end)

Connections["runtime_childadded"] = Runtime.ChildAdded:Connect(function(value)
    if value.Name == 'Tornado' then
        AeroTime = tick()
        Aerodynamic = true
    end
end)

Connections["balls_childadded"] = Workspace.Balls.ChildAdded:Connect(function(ball)
    Parried = false
    LobbyParried = false
    wasBackwards[ball] = false
    PredictedPositions = {}
    if UI.State:Get("AutoSpam") then
        Connections["spam_target_" .. tostring(ball)] = ball:GetAttributeChangedSignal('target'):Connect(function()
            local target = ball:GetAttribute('target')
            if target ~= tostring(LocalPlayer) then
                IsAutoSpamming = false
            end
        end)
    end
end)

Connections["balls_childremoved"] = Workspace.Balls.ChildRemoved:Connect(function(child)
    Parries = 0
    Parried = false
    LobbyParried = false
    PredictedPositions = {}
    BallSenderTracking[child] = nil
    local key = "spam_target_" .. tostring(child)
    if Connections[key] then
        Connections[key]:Disconnect()
        Connections[key] = nil
    end
    if AutoParry.Previous_Positions then
        AutoParry.Previous_Positions[child] = nil
    end
    if AutoParry.Velocity_History then
        AutoParry.Velocity_History[child] = nil
    end
    if AutoParry.Dot_Histories then
        AutoParry.Dot_Histories[child] = nil
    end
    if AutoParry.Previous_Speeds then
        AutoParry.Previous_Speeds[child] = nil
    end
    if AutoParry.Distance_History then
        AutoParry.Distance_History[child] = nil
    end
    if AutoParry.Previous_Velocities then
        AutoParry.Previous_Velocities[child] = nil
    end
    wasBackwards[child] = nil
end)

Connections["ping_heartbeat"] = RunService.Heartbeat:Connect(function()
    Update_Ping()
end)

-- ============================================================
-- Unload / cleanup
-- ============================================================

Cleanup = function()
    Connections:disconnect_all()
    if AICoroutine then
        pcall(task.cancel, AICoroutine)
        AICoroutine = nil
    end
    getgenv().OXYO_AICOROUTINE = nil
    if Music then
        pcall(function()
            Music:Stop()
            Music:Destroy()
        end)
        Music = nil
    end
    ToggleViz(false)
    if Viz then
        Viz:Destroy()
    end
    if KorbloxConnection then
        KorbloxConnection:Disconnect()
        KorbloxConnection = nil
    end
    if HeadDecalConnection then
        HeadDecalConnection:Disconnect()
        HeadDecalConnection = nil
    end
    if Check_Refresh then
        Check_Refresh:Disconnect()
        Check_Refresh = nil
    end
    Disable_ANTIAFK()
    if next(OriginalLighting) then
        Optimize(false)
    end
    pcall(function()
        ContextActionService:UnbindAction('BlockPlayerMovement')
    end)
    pcall(function()
        LocalPlayer.PlayerScripts.EffectScripts.ClientFX.Disabled = false
    end)
    if speedGui then speedGui:Destroy() end
    if lobbySpeedGui then lobbySpeedGui:Destroy() end
    if curveGui then curveGui:Destroy() end
end
