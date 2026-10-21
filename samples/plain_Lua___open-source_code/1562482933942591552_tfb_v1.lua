local WindUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Footagesus/WindUI/main/dist/main.lua"))()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local CoreGui = game:GetService("CoreGui")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local HttpService = game:GetService("HttpService")
local SoundService = game:GetService("SoundService")
local TeleportService = game:GetService("TeleportService")
local Debris = game:GetService("Debris")
local player = Players.LocalPlayer
local PlayerGui = player:WaitForChild("PlayerGui")

local syncingUI = false
local function round01(v) return math.floor(v * 10 + 0.5) / 10 end

getgenv()._lastEnabledFeature = nil

getgenv().BallReach = { enabled = false, reach = 4.1, heightLevel = "High", aimBias = 0.7, airOnly = true }
local c = getgenv().BallReach

local HEIGHT_STUDS = { ["Low"] = 8.0, ["High"] = 10.5, ["Extra High"] = 14.5 }
local GRAVITY = 55
local BALL_FLOOR = 5.473

local function vyForLevel(level)
    local apex = HEIGHT_STUDS[level] or HEIGHT_STUDS["High"]
    return math.sqrt(2 * GRAVITY * apex)
end

getgenv().SneakyKickWalkSpeed = 23
getgenv().SneakyState = {}
local STATE = getgenv().SneakyState
STATE.reachActive = false

getgenv().AutoJuggleV1 = { enabled = false, reach = 4.1 }
getgenv().PokersConfig = { enabled = false, forceSpeed = 16 }
getgenv().JuvsReachConfig = { Enabled = false, Range = 4.1, LastKick = 0 }
getgenv().MeasureLagEnabled = false

getgenv().NevoReachConfig = { reach = 4.1, enabled = false }

getgenv().RainbowFlickConfig = { enabled = false, reachScale = 4.1 }
getgenv().ShowRainbowFlickEnabled = false

getgenv().NeroConfig = { enabled = false, curveEnabled = false, curveMultiplier = 1.0, curveInvert = false }
getgenv().NeroGUI = { visible = false }

getgenv().AutoSave = { enabled = false }
getgenv().VelocityConfig = { enabled = false, multiplier = 1.0 }

getgenv().PerformanceConfig = {
    minimalRender = false, noShadows = false, overcast = false, bareFx = false,
    fullPerformance = false, disableTextures = false, removeGrass = false,
    disableAtmosphere = false, disableSounds = false, clearParticles = false,
    disableWater = false, lowFog = false, disableDecals = false,
    freezeAnimations = false, networkOptimize = false,
    fpsCapEnabled = false, fpsCapValue = 240,
}
local perf = getgenv().PerformanceConfig

local BallCache = { field = nil, ball = nil, lastCheck = 0 }
local function getBallCached()
    local now = os.clock()
    if now - BallCache.lastCheck > 0.35 then
        BallCache.lastCheck = now
        local f = Workspace:FindFirstChild("FootballField")
        BallCache.field = f
        BallCache.ball = f and f:FindFirstChild("SoccerBall")
    end
    return BallCache.ball
end
local function invalidateBallCache()
    BallCache.lastCheck = 0; BallCache.field = nil; BallCache.ball = nil
end

local Perf = {}
local origLighting = {
    GlobalShadows = Lighting.GlobalShadows, Ambient = Lighting.Ambient,
    OutdoorAmbient = Lighting.OutdoorAmbient, Brightness = Lighting.Brightness,
    ClockTime = Lighting.ClockTime, FogEnd = Lighting.FogEnd, FogStart = Lighting.FogStart,
    GeographicLatitude = Lighting.GeographicLatitude,
    ExposureCompensation = Lighting.ExposureCompensation,
    EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
    EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
}
local origQuality = Enum.QualityLevel.Level21
pcall(function() origQuality = settings().Rendering.QualityLevel end)

local origPostFxState = {}
for _, v in ipairs(Lighting:GetChildren()) do
    if v:IsA("PostEffect") or v:IsA("Atmosphere") then origPostFxState[v] = v.Enabled end
end

function Perf.applyNoShadows(on) Lighting.GlobalShadows = not on end

function Perf.applyOvercast(on)
    if on then
        Lighting.Ambient = Color3.fromRGB(90, 90, 95)
        Lighting.OutdoorAmbient = Color3.fromRGB(90, 90, 95)
        Lighting.Brightness = 1
        Lighting.ClockTime = 14
        Lighting.GeographicLatitude = 0
        Lighting.FogEnd = 500; Lighting.FogStart = 100
        Lighting.EnvironmentDiffuseScale = 0
        Lighting.EnvironmentSpecularScale = 0
        pcall(function() Lighting.ExposureCompensation = -0.5 end)
        for _, v in ipairs(Lighting:GetChildren()) do
            if v:IsA("Atmosphere") then v.Density = 0.6; v.Haze = 5; v.Glare = 0 end
        end
    else
        Lighting.Ambient = origLighting.Ambient
        Lighting.OutdoorAmbient = origLighting.OutdoorAmbient
        Lighting.Brightness = origLighting.Brightness
        Lighting.ClockTime = origLighting.ClockTime
        Lighting.GeographicLatitude = origLighting.GeographicLatitude
        Lighting.FogEnd = origLighting.FogEnd
        Lighting.FogStart = origLighting.FogStart
        Lighting.EnvironmentDiffuseScale = origLighting.EnvironmentDiffuseScale
        Lighting.EnvironmentSpecularScale = origLighting.EnvironmentSpecularScale
        pcall(function() Lighting.ExposureCompensation = origLighting.ExposureCompensation end)
    end
end

local FX_CLASSES = { ParticleEmitter=true, Trail=true, Beam=true, Fire=true, Smoke=true, Sparkles=true, Highlight=true, BillboardGui=true }

function Perf.applyBareFx(on)
    if on then
        for _, v in ipairs(Workspace:GetDescendants()) do
            if FX_CLASSES[v.ClassName] then
                if v:GetAttribute("_tfbfxSaved") == nil then v:SetAttribute("_tfbfxSaved", v.Enabled and 1 or 0) end
                v.Enabled = false
            end
        end
    else
        for _, v in ipairs(Workspace:GetDescendants()) do
            local saved = v:GetAttribute("_tfbfxSaved")
            if saved ~= nil then
                pcall(function() v.Enabled = saved == 1 end)
                v:SetAttribute("_tfbfxSaved", nil)
            end
        end
    end
end

function Perf.applyMinimalRender(on)
    if on then
        pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
        for _, v in ipairs(Lighting:GetChildren()) do if v:IsA("PostEffect") then v.Enabled = false end end
    else
        pcall(function() settings().Rendering.QualityLevel = origQuality end)
        for obj, state in pairs(origPostFxState) do
            if obj and obj.Parent then pcall(function() obj.Enabled = state end) end
        end
    end
end

function Perf.applyDisableTextures(on)
    if on then
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and v.Material ~= Enum.Material.SmoothPlastic then
                if v:GetAttribute("_texSavedMat") == nil then v:SetAttribute("_texSavedMat", v.Material.Name) end
                v.Material = Enum.Material.SmoothPlastic
            end
        end
    else
        for _, v in ipairs(Workspace:GetDescendants()) do
            local saved = v:GetAttribute("_texSavedMat")
            if saved then
                pcall(function() v.Material = Enum.Material[saved] end)
                v:SetAttribute("_texSavedMat", nil)
            end
        end
    end
end

function Perf.applyRemoveGrass(on)
    if on then
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and (v.Name:lower():find("grass") or v.Material == Enum.Material.Grass) then
                if v:GetAttribute("_grassHidden") == nil then
                    v:SetAttribute("_grassHidden", v.Transparency)
                    v.Transparency = 1
                end
            end
        end
    else
        for _, v in ipairs(Workspace:GetDescendants()) do
            local saved = v:GetAttribute("_grassHidden")
            if saved then v.Transparency = saved; v:SetAttribute("_grassHidden", nil) end
        end
    end
end

function Perf.applyDisableAtmosphere(on)
    for _, v in ipairs(Lighting:GetChildren()) do
        if v:IsA("Atmosphere") then v.Enabled = not on end
    end
    if on then
        Lighting.FogEnd = 100000; Lighting.FogStart = 100000
    else
        Lighting.FogEnd = origLighting.FogEnd; Lighting.FogStart = origLighting.FogStart
    end
end

function Perf.applyDisableSounds(on)
    if on then
        SoundService.AmbientReverb = Enum.ReverbType.NoReverb
        for _, v in ipairs(SoundService:GetDescendants()) do
            if v:IsA("Sound") then
                if v:GetAttribute("_sndSaved") == nil then v:SetAttribute("_sndSaved", v.Volume) end
                v.Volume = 0
            end
        end
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("Sound") then
                if v:GetAttribute("_sndSaved") == nil then v:SetAttribute("_sndSaved", v.Volume) end
                v.Volume = 0
            end
        end
    else
        for _, v in ipairs(SoundService:GetDescendants()) do
            local saved = v:GetAttribute("_sndSaved")
            if saved then v.Volume = saved; v:SetAttribute("_sndSaved", nil) end
        end
        for _, v in ipairs(Workspace:GetDescendants()) do
            local saved = v:GetAttribute("_sndSaved")
            if saved then v.Volume = saved; v:SetAttribute("_sndSaved", nil) end
        end
    end
end

function Perf.applyClearParticles(on)
    if on then
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Smoke") or v:IsA("Fire") or v:IsA("Sparkles") then
                if v:GetAttribute("_partSaved") == nil then v:SetAttribute("_partSaved", v.Enabled and 1 or 0) end
                v.Enabled = false
            end
        end
    else
        for _, v in ipairs(Workspace:GetDescendants()) do
            local saved = v:GetAttribute("_partSaved")
            if saved then v.Enabled = saved == 1; v:SetAttribute("_partSaved", nil) end
        end
    end
end

function Perf.applyDisableWater(on)
    pcall(function()
        Workspace.Terrain.WaterWaveSize = on and 0 or 0.15
        Workspace.Terrain.WaterWaveSpeed = on and 0 or 10
        Workspace.Terrain.WaterReflectance = on and 0 or 1
        Workspace.Terrain.WaterTransparency = on and 1 or 1
    end)
end

function Perf.applyLowFog(on)
    if on then
        Lighting.FogEnd = 150; Lighting.FogStart = 50
    else
        Lighting.FogEnd = origLighting.FogEnd; Lighting.FogStart = origLighting.FogStart
    end
end

function Perf.applyDisableDecals(on)
    if on then
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("Decal") or v:IsA("Texture") then
                if v:GetAttribute("_decSaved") == nil then v:SetAttribute("_decSaved", v.Transparency) end
                v.Transparency = 1
            end
        end
    else
        for _, v in ipairs(Workspace:GetDescendants()) do
            local saved = v:GetAttribute("_decSaved")
            if saved then v.Transparency = saved; v:SetAttribute("_decSaved", nil) end
        end
    end
end

function Perf.applyFreezeAnimations(on)
    for _, p in ipairs(Players:GetPlayers()) do
        local char = p.Character
        if char then
            local anim = char:FindFirstChildOfClass("Animator")
            if anim then
                if on then
                    if not anim:GetAttribute("_frozen") then
                        anim:SetAttribute("_frozen", true)
                        for _, t in ipairs(anim:GetPlayingAnimationTracks()) do
                            pcall(function() t:Stop() end)
                        end
                    end
                else
                    anim:SetAttribute("_frozen", nil)
                end
            end
        end
    end
end

function Perf.applyNetworkOptimize(on)
    pcall(function()
        if on then settings().Network.IncomingReplicationLag = 0.25
        else settings().Network.IncomingReplicationLag = 0 end
    end)
end

function Perf.applyFpsCap(on, value)
    if setfpscap then pcall(function() setfpscap(on and value or 60) end) end
end

function Perf.applyFullPerformance(on)
    if on then
        Perf.applyNoShadows(true); Perf.applyOvercast(true); Perf.applyBareFx(true); Perf.applyMinimalRender(true)
        Perf.applyDisableTextures(true); Perf.applyRemoveGrass(true); Perf.applyDisableAtmosphere(true)
        Perf.applyDisableSounds(true); Perf.applyClearParticles(true); Perf.applyDisableWater(true)
        Perf.applyLowFog(true); Perf.applyDisableDecals(true); Perf.applyFreezeAnimations(true)
        Perf.applyNetworkOptimize(true)
        if setfpscap then pcall(function() setfpscap(9999) end) end
    else
        Perf.applyNoShadows(perf.noShadows); Perf.applyOvercast(perf.overcast)
        Perf.applyBareFx(perf.bareFx); Perf.applyMinimalRender(perf.minimalRender)
        Perf.applyDisableTextures(perf.disableTextures); Perf.applyRemoveGrass(perf.removeGrass)
        Perf.applyDisableAtmosphere(perf.disableAtmosphere); Perf.applyDisableSounds(perf.disableSounds)
        Perf.applyClearParticles(perf.clearParticles); Perf.applyDisableWater(perf.disableWater)
        Perf.applyLowFog(perf.lowFog); Perf.applyDisableDecals(perf.disableDecals)
        Perf.applyFreezeAnimations(perf.freezeAnimations); Perf.applyNetworkOptimize(perf.networkOptimize)
        Perf.applyFpsCap(perf.fpsCapEnabled, perf.fpsCapValue)
    end
end

if perf.fullPerformance then
    Perf.applyFullPerformance(true)
else
    if perf.noShadows then Perf.applyNoShadows(true) end
    if perf.overcast then Perf.applyOvercast(true) end
    if perf.bareFx then Perf.applyBareFx(true) end
    if perf.minimalRender then Perf.applyMinimalRender(true) end
    if perf.disableTextures then Perf.applyDisableTextures(true) end
    if perf.removeGrass then Perf.applyRemoveGrass(true) end
    if perf.disableAtmosphere then Perf.applyDisableAtmosphere(true) end
    if perf.disableSounds then Perf.applyDisableSounds(true) end
    if perf.clearParticles then Perf.applyClearParticles(true) end
    if perf.disableWater then Perf.applyDisableWater(true) end
    if perf.lowFog then Perf.applyLowFog(true) end
    if perf.disableDecals then Perf.applyDisableDecals(true) end
    if perf.freezeAnimations then Perf.applyFreezeAnimations(true) end
    if perf.networkOptimize then Perf.applyNetworkOptimize(true) end
    if perf.fpsCapEnabled then Perf.applyFpsCap(true, perf.fpsCapValue) end
end

do
    if getgenv()._AimbotCleanup then pcall(getgenv()._AimbotCleanup) end
    local Players = game:GetService("Players")
    local RunService = game:GetService("RunService")
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local LocalPlayer = Players.LocalPlayer

    getgenv().AimbotConfig = getgenv().AimbotConfig or {
        enabled = false, autoDetect = true, curveEnabled = false, curveFlip = false, antiPost = false,
        topCornerEnabled = true, selectedGoal = "B", lastDetected = "B",
    }
    local cfg = getgenv().AimbotConfig
    getgenv().AimbotSync = function(state) cfg.enabled = state end

    local GoalPositions = {
        A = Vector3.new(-313.13, 10, 92.876),
        B = Vector3.new(-115.936, 10, 92.876),
    }

    local GRAVITY = 55
    local GOAL_CENTER_Z = 92.876
    local POST_LEFT_Z = 78.036
    local POST_RIGHT_Z = 107.715
    local POST_RADIUS = 1.825
    local CROSSBAR_Y = 18
    local SPIN_DIVISOR = 45
    local INSET = 5.0
    local TOP_CORNER_Y = 16.0
    local MAX_Y_VEL = 40
    local MAX_SPIN = 14
    local SIM_DT = 0.008
    local SIM_MAX_T = 4.5
    local MIN_HSPEED_FRAC = 0.70

    local function detectEnemyGoal(ballPos, origVel)
        if origVel and math.abs(origVel.X) > 1.5 then
            return (origVel.X < 0) and "A" or "B"
        end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local lx = hrp.CFrame.LookVector.X
            if math.abs(lx) > 0.05 then
                return (lx < 0) and "A" or "B"
            end
        end
        return (ballPos.X < -214) and "B" or "A"
    end

    local function simulateCrossing(ballPos, vx0, vy0, vz0, rotY, goalX)
        local angRate = rotY / -SPIN_DIVISOR
        local px, py, pz = ballPos.X, ballPos.Y, ballPos.Z
        local vx, vz, vy = vx0, vz0, vy0
        local sign = (goalX >= ballPos.X) and 1 or -1
        local t = 0
        local prevX, prevY, prevZ = px, py, pz
        while t < SIM_MAX_T do
            local da = angRate * SIM_DT
            local c, s = math.cos(da), math.sin(da)
            vx, vz = vx * c - vz * s, vx * s + vz * c
            prevX, prevY, prevZ = px, py, pz
            px = px + vx * SIM_DT
            pz = pz + vz * SIM_DT
            py = py + vy * SIM_DT - 0.5 * GRAVITY * SIM_DT * SIM_DT
            vy = vy - GRAVITY * SIM_DT
            if (sign > 0 and px >= goalX) or (sign < 0 and px <= goalX) then
                local denom = (px - prevX)
                local f = denom ~= 0 and (goalX - prevX) / denom or 0
                f = math.clamp(f, 0, 1)
                local crossY = prevY + (py - prevY) * f
                local crossZ = prevZ + (pz - prevZ) * f
                return crossY, crossZ, (t + f * SIM_DT)
            end
            if py < 0 then return nil end
            t = t + SIM_DT
        end
        return nil
    end

    local function rotateXZ(x, z, a)
        local c, s = math.cos(a), math.sin(a)
        return x * c - z * s, x * s + z * c
    end

    local function bestCurl(ballPos, goalX, targetZ, totalSpeed, outwardSign)
        local hMinSpeed = totalSpeed * MIN_HSPEED_FRAC
        local maxVyBySpeed = math.sqrt(math.max(totalSpeed * totalSpeed - hMinSpeed * hMinSpeed, 0))
        local maxVy = math.min(MAX_Y_VEL, maxVyBySpeed)
        local dx = goalX - ballPos.X
        local dz = targetZ - ballPos.Z
        local baseAng = math.atan2(dz, dx)
        local best, bestScore = nil, math.huge
        local targetY = cfg.topCornerEnabled and TOP_CORNER_Y or 2.0
        local aimOffsets = { 0.15, 0.25, 0.35, 0.45, 0.55, 0.65 }
        local spins = { 7, 9, 11, 12.5, 14 }
        for _, off in ipairs(aimOffsets) do
            local launchAng = baseAng - outwardSign * off
            local ux = math.cos(launchAng)
            local uz = math.sin(launchAng)
            for _, spinMag in ipairs(spins) do
                local rotY = -outwardSign * spinMag
                local vySteps = 70
                for i = 0, vySteps do
                    local vy = (i / vySteps) * maxVy
                    local vh = math.sqrt(math.max(totalSpeed * totalSpeed - vy * vy, 0))
                    local cy, cz = simulateCrossing(ballPos, ux * vh, vy, uz * vh, rotY, goalX)
                    if cy then
                        local insideZ = (cz > POST_LEFT_Z + POST_RADIUS) and (cz < POST_RIGHT_Z - POST_RADIUS)
                        local underBar = cy < (CROSSBAR_Y - POST_RADIUS)
                        local landErr = math.abs(cy - targetY) * 1.4 + math.abs(cz - targetZ)
                        if insideZ and underBar and landErr < 5 then
                            local bendReward = -(off * 30 + spinMag * 2)
                            local score = landErr + bendReward
                            if cy < targetY then score = score + (targetY - cy) * 1.4 end
                            if score < bestScore then
                                bestScore = score
                                best = { vx = ux * vh, vy = vy, vz = uz * vh, rotY = rotY }
                            end
                        end
                    end
                end
            end
        end
        return best, bestScore
    end

    local function bestStraight(ballPos, goalX, targetZ, totalSpeed)
        local hMinSpeed = totalSpeed * MIN_HSPEED_FRAC
        local maxVy = math.min(MAX_Y_VEL, math.sqrt(math.max(totalSpeed^2 - hMinSpeed^2, 0)))
        local dx, dz = goalX - ballPos.X, targetZ - ballPos.Z
        local m = math.sqrt(dx*dx + dz*dz)
        if m < 1e-6 then return nil, math.huge end
        local ux, uz = dx/m, dz/m
        local best, bestErr = nil, math.huge
        local targetY = cfg.topCornerEnabled and TOP_CORNER_Y or 2.0
        for i = 0, 150 do
            local vy = (i/150) * maxVy
            local vh = math.sqrt(math.max(totalSpeed^2 - vy^2, 0))
            local cy, cz = simulateCrossing(ballPos, ux*vh, vy, uz*vh, 0, goalX)
            if cy then
                local insideZ = (cz > POST_LEFT_Z + POST_RADIUS) and (cz < POST_RIGHT_Z - POST_RADIUS)
                local underBar = cy < (CROSSBAR_Y - POST_RADIUS)
                local err = math.abs(cy - targetY) * 1.4 + math.abs(cz - targetZ)
                if not insideZ then err = err + 60 end
                if not underBar then err = err + 60 end
                if cy < targetY then err = err + (targetY - cy) * 1.4 end
                if err < bestErr then
                    bestErr = err
                    best = { vx=ux*vh, vy=vy, vz=uz*vh, rotY=0 }
                end
            end
        end
        return best, bestErr
    end

    local function redirectVelocity(ballPos, origVel)
        local goalKey = cfg.selectedGoal
        if cfg.autoDetect then
            goalKey = detectEnemyGoal(ballPos, origVel)
            cfg.lastDetected = goalKey
            cfg.selectedGoal = goalKey
        end
        local goalPos = GoalPositions[goalKey]
        if not goalPos then return origVel, Vector3.new(0, 0, 0) end
        local goalX = goalPos.X
        local totalSpeed = math.sqrt(origVel.X ^ 2 + origVel.Y ^ 2 + origVel.Z ^ 2)
        if totalSpeed < 5 then return origVel, Vector3.new(0, 0, 0) end
        local approxDist = math.abs(goalX - ballPos.X) + 1
        local dynInset = INSET
        if approxDist < 60 then dynInset = INSET + (60 - approxDist) * 0.04 end
        dynInset = math.clamp(dynInset, INSET, 8.0)
        local rightZ = POST_RIGHT_Z - dynInset
        local leftZ = POST_LEFT_Z + dynInset
        local farIsRight = math.abs(ballPos.Z - POST_RIGHT_Z) >= math.abs(ballPos.Z - POST_LEFT_Z)
        local targetZ = farIsRight and rightZ or leftZ
        local outwardSign = (targetZ > GOAL_CENTER_Z) and 1 or -1
        if cfg.curveFlip then outwardSign = -outwardSign end
        local chosen, chosenErr = nil, math.huge
        if cfg.curveEnabled then
            chosen, chosenErr = bestCurl(ballPos, goalX, targetZ, totalSpeed, outwardSign)
            if not chosen then
                local altZ = farIsRight and leftZ or rightZ
                local altOut = (altZ > GOAL_CENTER_Z) and 1 or -1
                if cfg.curveFlip then altOut = -altOut end
                chosen, chosenErr = bestCurl(ballPos, goalX, altZ, totalSpeed, altOut)
            end
            if not chosen then
                chosen, chosenErr = bestStraight(ballPos, goalX, targetZ, totalSpeed)
            end
        else
            chosen, chosenErr = bestStraight(ballPos, goalX, targetZ, totalSpeed)
            if not chosen or chosenErr > 14 then
                local altZ = farIsRight and leftZ or rightZ
                local b, e = bestStraight(ballPos, goalX, altZ, totalSpeed)
                if b and e < chosenErr then chosen, chosenErr = b, e end
            end
        end
        if not chosen then
            local dx, dz = goalX - ballPos.X, targetZ - ballPos.Z
            local m = math.sqrt(dx*dx + dz*dz)
            local vy = math.min(MAX_Y_VEL, totalSpeed * 0.45)
            local vh = math.sqrt(math.max(totalSpeed^2 - vy^2, 0))
            return Vector3.new(dx/m*vh, vy, dz/m*vh), Vector3.new(0, 0, 0)
        end
        local vy = chosen.vy
        if (ballPos.Y > 13) and (math.abs(origVel.Y) > 8) then vy = math.min(vy, 30) end
        return Vector3.new(chosen.vx, vy, chosen.vz), Vector3.new(0, chosen.rotY, 0)
    end

    task.spawn(function()
        local hooked = false
        while not hooked do
            for _, v in pairs(getgc(true)) do
                if typeof(v) == "function" and islclosure(v) then
                    local ok, info = pcall(debug.getinfo, v)
                    if ok and info.name == "ballHitsGoalFrame" then
                        hooked = true
                        local old
                        old = hookfunction(v, newcclosure(function(...)
                            if cfg.antiPost then
                                local pos = select(1, ...)
                                local vel = select(2, ...)
                                return false, pos, { X = vel.X, Y = vel.Y, Z = vel.Z }, ""
                            end
                            return old(...)
                        end))
                        break
                    end
                end
            end
            task.wait(1)
        end
    end)

    local localPlayerIsKicking = false

    local function hookLocal()
        local char = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local handler = char:WaitForChild("BallHandler", 10)
        if not handler then return end
        local env = getsenv(handler)
        if not env or not env.startAnimation then return end
        local origStartAnimation = env.startAnimation
        env.startAnimation = function(pos, vel, rot, offset, lag)
            if cfg.enabled and localPlayerIsKicking then
                vel, rot = redirectVelocity(pos, vel)
            end
            localPlayerIsKicking = false
            return origStartAnimation(pos, vel, rot, offset, lag)
        end
    end

    local function hookRemote()
        local kickBall = ReplicatedStorage:WaitForChild("KickBall", 10)
        local old
        old = hookmetamethod(game, "__namecall", function(self, ...)
            if getnamecallmethod() == "FireServer" and self == kickBall then
                localPlayerIsKicking = true
                if cfg.enabled then
                    local args = {...}
                    if #args >= 3 and typeof(args[1]) == "Vector3" and typeof(args[2]) == "Vector3" then
                        args[2], args[3] = redirectVelocity(args[1], args[2])
                        return old(self, unpack(args))
                    end
                end
            end
            return old(self, ...)
        end)
    end

    pcall(hookLocal)
    pcall(hookRemote)
    LocalPlayer.CharacterAdded:Connect(function() task.wait(2) pcall(hookLocal) end)

    getgenv()._AimbotCleanup = function()
        cfg.enabled = false
    end
end

do
    getgenv().AutoGKV2Config = { enabled = false }
    getgenv().AutoGroundSaveConfig = { enabled = false }
    getgenv().AutoGKConfig = { enabled = false, diveSpeed = 26, jumpReact = 0.4, saveReact = 1.7 }
    local gkc = getgenv().AutoGKConfig

    getgenv().TouchReachConfig = {
        enabled = false, reach = 4.1, spoofTarget = 3.9, antiCancel = true, protectBall = true,
        instantSteal = true, naturalSpoof = true, blockDeny = true, visualizer = false,
    }
    local cfg = getgenv().TouchReachConfig
    cfg.reach = 4.1
    cfg.spoofTarget = 3.9

    local newcclosure_fn = newcclosure or function(f) return f end
    local checkcaller_fn = checkcaller
    local getrawmetatable_fn = getrawmetatable
    local setreadonly_fn = setreadonly
    local getgc_fn = getgc
    local islclosure_fn = islclosure
    local getnamecallmethod_fn = getnamecallmethod
    local getconnections_fn = getconnections
    local hookfunction_fn = hookfunction

    if getgenv()._UR_Connections then
        for _, cc in pairs(getgenv()._UR_Connections) do pcall(function() cc:Disconnect() end) end
    end
    getgenv()._UR_Connections = {}
    local conns = getgenv()._UR_Connections
    getgenv()._UR_LoopID = (getgenv()._UR_LoopID or 0) + 1
    local currentLoopID = getgenv()._UR_LoopID

    local GOAL_A_X, GOAL_B_X = -313.13, -115.936
    local Z_MIN, Z_MAX = 78.036, 107.715
    local GOAL_CENTER_Z = (Z_MIN + Z_MAX) / 2
    local GRAVITY = 55
    local GROUND_Y = 5.473
    local BOUNCE_DAMP_Y = 0.55
    local CROSSBAR_Y = 18
    local SIM_DT = 0.005
    local MAX_STEPS = 2000
    local THREAT_WINDOW = 7.5
    local GOAL_OFFSET = -0.5
    local Z_SAVE_MIN = Z_MIN - 2.6
    local Z_SAVE_MAX = Z_MAX + 2.6
    local Y_SAVE_MAX = CROSSBAR_Y + 0.6
    local STAND_REACH_Y = GROUND_Y + 5.5
    local GK_Settings = { AntiPhase = false }
    local smoothVelocity = Vector3.zero
    local getcallingscript = getcallingscript or function() return nil end

    pcall(function()
        local oldTick
        oldTick = hookfunction(tick, function(...)
            if GK_Settings.AntiPhase then
                local caller = getcallingscript()
                if caller and caller.Name == "BallHandler" then return oldTick(...) * 0.6 end
                local ok, src = pcall(debug.info, 2, "s")
                if ok and src and string.find(src, "BallHandler") then return oldTick(...) * 0.6 end
            end
            return oldTick(...)
        end)
    end)

    local function SimulateExactGamePhysics(ballPos, ballVel, ballRotVel, goalLineX)
        if math.abs(ballVel.X) < 0.2 then return nil end
        if (ballVel.X < 0) ~= (goalLineX < ballPos.X) then return nil end
        local totalTime, bounces = 0, 0
        local flightTime = 0
        local sPx, sPy, sPz = ballPos.X, ballPos.Y, ballPos.Z
        local sVx, sVy, sVz = ballVel.X, ballVel.Y, ballVel.Z
        local curveFactor = ballRotVel.Y / -45
        local prevX = sPx
        local trajectory = {}
        table.insert(trajectory, {x=sPx, y=sPy, z=sPz, t=0, vy=sVy, b=0})
        local crossedGoal = false
        for _ = 1, MAX_STEPS do
            flightTime = flightTime + SIM_DT
            totalTime = totalTime + SIM_DT
            local angle = curveFactor * flightTime
            local curVx = sVx * math.cos(angle) - sVz * math.sin(angle)
            local curVz = sVx * math.sin(angle) + sVz * math.cos(angle)
            local npx = sPx + sVx * flightTime + 0.5 * (curVx - sVx) * flightTime
            local npy = sPy + sVy * flightTime - 0.5 * GRAVITY * (flightTime^2)
            local npz = sPz + sVz * flightTime + 0.5 * (curVz - sVz) * flightTime
            local nvy = sVy - GRAVITY * flightTime
            table.insert(trajectory, {x=npx, y=npy, z=npz, t=totalTime, vy=nvy, b=bounces})
            if (prevX <= goalLineX and npx >= goalLineX) or (prevX >= goalLineX and npx <= goalLineX) then
                crossedGoal = true
                break
            end
            if npy < GROUND_Y then
                bounces = bounces + 1
                local dampXZ = math.abs(nvy) < 10 and 0.99 or 0.80
                sVx, sVz = curVx * dampXZ, curVz * dampXZ
                sVy = math.abs(nvy) * BOUNCE_DAMP_Y
                sPx, sPy, sPz = npx, GROUND_Y, npz
                local rotImpact = (Vector3.new(0, 1, 0)):Cross(Vector3.new(curVx, 0, curVz).Unit).Unit * (math.sqrt(curVx^2 + curVz^2) * 0.8 / 1.5)
                curveFactor = (rotImpact.Y + (curveFactor * -45 * 0.8)) / -45
                flightTime = 0
                npx, npy, npz = sPx, sPy, sPz
            end
            prevX = npx
            if (curVx^2 + nvy^2 + curVz^2) < 0.09 or totalTime > THREAT_WINDOW then break end
        end
        return crossedGoal and trajectory or nil
    end

    local function GetStateAtX(trajectory, targetX)
        if not trajectory or #trajectory == 0 then return nil end
        local prev = trajectory[1]
        for i = 2, #trajectory do
            local cur = trajectory[i]
            if (prev.x <= targetX and cur.x >= targetX) or (prev.x >= targetX and cur.x <= targetX) then
                local frac = math.abs(targetX - prev.x) / math.max(math.abs(cur.x - prev.x), 0.0001)
                return {
                    x = targetX,
                    y = math.max(prev.y + (cur.y - prev.y) * frac, GROUND_Y),
                    z = prev.z + (cur.z - prev.z) * frac,
                    t = prev.t + (cur.t - prev.t) * frac,
                    vy = prev.vy + (cur.vy - prev.vy) * frac,
                    b = cur.b
                }
            end
            prev = cur
        end
        return nil
    end

    local function GetBall() return getBallCached() end
    local function lerpV3(a, b, t) return a + (b - a) * t end

    RunService.Heartbeat:Connect(function()
        if not getgenv().AutoGKConfig.enabled and not getgenv().AutoGroundSaveConfig.enabled then return end
        local char = player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local ball = GetBall()
        if not hrp or not hum then
            if hrp and hrp:FindFirstChild("GK_V") then
                hrp.GK_V.Enabled = false; hrp.GK_R.Enabled = false; hum.AutoRotate = true
            end
            return
        end
        if not hrp:FindFirstChild("GK_V") then
            local att = Instance.new("Attachment", hrp); att.Name = "GK_A"
            local lvI = Instance.new("LinearVelocity", hrp); lvI.Name = "GK_V"; lvI.Attachment0 = att
            lvI.VelocityConstraintMode = Enum.VelocityConstraintMode.Vector; lvI.ForceLimitMode = Enum.ForceLimitMode.PerAxis
            local aoI = Instance.new("AlignOrientation", hrp); aoI.Name = "GK_R"; aoI.Attachment0 = att
            aoI.Mode = Enum.OrientationAlignmentMode.OneAttachment; aoI.MaxTorque = math.huge; aoI.Responsiveness = 40
        end
        local lv, ao = hrp.GK_V, hrp.GK_R
        if not ball then lv.Enabled = false; ao.Enabled = false; hum.AutoRotate = true; return end
        local rawGoalX = (math.abs(hrp.Position.X - GOAL_A_X) < math.abs(hrp.Position.X - GOAL_B_X)) and GOAL_A_X or GOAL_B_X
        local dir = (rawGoalX < -200) and 1 or -1
        local goalX = rawGoalX + (GOAL_OFFSET * dir)
        local ballPos = ball.Position
        local vel = ball.AssemblyLinearVelocity
        local rotVel = ball.AssemblyAngularVelocity
        local isShotOnTarget, timeToGoal = false, 999
        local targetZ, predY = GOAL_CENTER_Z, GROUND_Y
        local targetX = goalX + dir * 0.5
        local ballHeading = ((rawGoalX == GOAL_A_X) and vel.X < 0) or ((rawGoalX == GOAL_B_X) and vel.X > 0)
        local ballBehind = (dir == 1 and ballPos.X < hrp.Position.X) or (dir == -1 and ballPos.X > hrp.Position.X)
        local trajectory = nil
        if ballHeading and not ballBehind then trajectory = SimulateExactGamePhysics(ballPos, vel, rotVel, rawGoalX) end
        local goalState = trajectory and GetStateAtX(trajectory, rawGoalX) or nil
        if goalState and goalState.t < THREAT_WINDOW then
            timeToGoal = goalState.t
            if goalState.z >= Z_SAVE_MIN and goalState.z <= Z_SAVE_MAX and goalState.y <= Y_SAVE_MAX then
                isShotOnTarget = true; targetZ = goalState.z; predY = goalState.y
            end
        end
        local saveReact = math.clamp(tonumber(getgenv().AutoGKConfig.saveReact) or 1.7, 0.50, 3.00)
        local isActivelySaving = isShotOnTarget and timeToGoal <= saveReact
        if not isActivelySaving then
            lv.Enabled = false; ao.Enabled = false; hum.AutoRotate = true; smoothVelocity = Vector3.zero; return
        end
        local st = hum:GetState()
        local onGround = st ~= Enum.HumanoidStateType.Jumping and st ~= Enum.HumanoidStateType.Freefall
        local jumpReact = math.clamp(tonumber(getgenv().AutoGKConfig.jumpReact) or 0.4, 0.10, 1.00)
        if onGround and getgenv().AutoGKConfig.enabled and predY >= STAND_REACH_Y and timeToGoal <= jumpReact then
            hum.Jump = true
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
        local canGroundSave = getgenv().AutoGroundSaveConfig.enabled and onGround
        local canDive = getgenv().AutoGKConfig.enabled and not onGround
        if not canGroundSave and not canDive then
            lv.Enabled = false; ao.Enabled = false; hum.AutoRotate = true; smoothVelocity = Vector3.zero; return
        end
        if canGroundSave then hum.WalkSpeed = 23 end
        lv.Enabled = true; ao.Enabled = true; hum.AutoRotate = false
        lv.MaxAxesForce = Vector3.new(5000000, 0, 5000000)
        local lungeVec = Vector3.new(targetX, hrp.Position.Y, targetZ) - hrp.Position
        local desiredVel = Vector3.zero
        if lungeVec.Magnitude > 0.05 then
            desiredVel = lungeVec * 40
            local diveLimit = math.clamp(tonumber(getgenv().AutoGKConfig.diveSpeed) or 26, 10, 60)
            if desiredVel.Magnitude > diveLimit then desiredVel = desiredVel.Unit * diveLimit end
        end
        smoothVelocity = lerpV3(smoothVelocity, desiredVel, 1.0)
        lv.VectorVelocity = smoothVelocity
        local lookDir = Vector3.new(ballPos.X, hrp.Position.Y, ballPos.Z) - hrp.Position
        if lookDir.Magnitude > 0.1 then ao.CFrame = CFrame.lookAt(hrp.Position, hrp.Position + lookDir.Unit * 10) end
    end)

    local state = {
        FAKE_DIST = 3.2, cachedBall = nil, ballAlive = false, partMode = {}, limbPriority = {},
        kickBallRemote = nil, blockedRemotes = {}, cacheDirty = true, lastCharModel = nil,
    }
    local BANISH_VEC = Vector3.new(0, 9e8, 0)
    local HITBOXES = {
        ["UpperTorso"] = 0.4, ["RightFoot"] = 0.3, ["LeftFoot"] = 0.3,
        ["RightLowerLeg"] = 0.2, ["LeftLowerLeg"] = 0.2, ["RightUpperLeg"] = 0.2,
        ["LeftUpperLeg"] = 0.2, ["HumanoidRootPart"] = 0.1, ["Torso"] = 0.4,
        ["Right Leg"] = 0.3, ["Left Leg"] = 0.3,
    }
    local BALL_NAMES = { "SoccerBall", "Ball", "Football" }
    local SAFE_REMOTE_NAMES = {
        ["KickBall"] = true, ["DropBallEvent"] = true, ["RemoveBallEvent"] = true,
        ["BallPositionEvent"] = true, ["KickBallEvent"] = true, ["MeasureLag"] = true,
        ["MeasureLagEvent"] = true, ["GoalEvent"] = true, ["NearGoalEvent"] = true,
    }

    local function findBall()
        local field = Workspace:FindFirstChild("FootballField")
        if field then
            for _, name in ipairs(BALL_NAMES) do
                local b = field:FindFirstChild(name)
                if b then
                    if b:IsA("BasePart") then return b end
                    if b:IsA("Model") then return b.PrimaryPart or b:FindFirstChildWhichIsA("BasePart") end
                end
            end
        end
        for _, name in ipairs(BALL_NAMES) do
            local b = Workspace:FindFirstChild(name)
            if b then
                if b:IsA("BasePart") then return b end
                if b:IsA("Model") then return b.PrimaryPart or b:FindFirstChildWhichIsA("BasePart") end
            end
        end
        return nil
    end

    local function validateBall()
        if not state.cachedBall then return false end
        local ok, result = pcall(function() return state.cachedBall:IsDescendantOf(game) end)
        return ok and result == true
    end

    local function refreshCache()
        if validateBall() then state.ballAlive = true
        else
            state.cachedBall = findBall()
            state.ballAlive = (state.cachedBall ~= nil)
        end
        if not state.kickBallRemote then
            local r = ReplicatedStorage:FindFirstChild("KickBall")
            if r and (r:IsA("RemoteEvent") or r:IsA("RemoteFunction")) then state.kickBallRemote = r end
        end
        local char = player.Character
        if char ~= state.lastCharModel then
            state.lastCharModel = char
            for k in pairs(state.partMode) do state.partMode[k] = nil end
            for k in pairs(state.limbPriority) do state.limbPriority[k] = nil end
            if char then
                for name, prio in pairs(HITBOXES) do
                    local part = char:FindFirstChild(name)
                    if part and part:IsA("BasePart") then state.partMode[part] = 1; state.limbPriority[part] = prio end
                end
            end
            for _, p in pairs(Players:GetPlayers()) do
                if p ~= player and p.Character then
                    local hrp = p.Character:FindFirstChild("HumanoidRootPart")
                    if hrp and hrp:IsA("BasePart") then state.partMode[hrp] = 2 end
                end
            end
        end
        state.cacheDirty = false
    end

    local hbTimer = 0
    table.insert(conns, RunService.Heartbeat:Connect(function(dt)
        if state.ballAlive then
            if not validateBall() then state.ballAlive = false; state.cacheDirty = true end
        end
        hbTimer = hbTimer + dt
        if state.cacheDirty and hbTimer >= 0.3 then hbTimer = 0; pcall(refreshCache)
        elseif hbTimer >= 3 then hbTimer = 0; state.cacheDirty = true end
    end))

    local function onBallChildAdded(child)
        for _, name in ipairs(BALL_NAMES) do
            if child.Name == name then
                if child:IsA("BasePart") then state.cachedBall = child; state.ballAlive = true; return
                elseif child:IsA("Model") then
                    state.cachedBall = child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")
                    state.ballAlive = (state.cachedBall ~= nil); return
                end
            end
        end
    end

    task.spawn(function()
        local field = Workspace:FindFirstChild("FootballField")
        if not field then field = Workspace:WaitForChild("FootballField", 30) end
        if field then
            table.insert(conns, field.ChildAdded:Connect(function(child) onBallChildAdded(child) end))
            for _, name in ipairs(BALL_NAMES) do
                local b = field:FindFirstChild(name)
                if b then
                    if b:IsA("BasePart") then state.cachedBall = b; state.ballAlive = true
                    elseif b:IsA("Model") then
                        state.cachedBall = b.PrimaryPart or b:FindFirstChildWhichIsA("BasePart")
                        state.ballAlive = (state.cachedBall ~= nil)
                    end
                    break
                end
            end
        end
    end)

    table.insert(conns, Workspace.ChildAdded:Connect(function(child)
        for _, name in ipairs(BALL_NAMES) do
            if child.Name == name then onBallChildAdded(child); return end
        end
        if child.Name == "FootballField" then
            state.cacheDirty = true
            task.spawn(function()
                table.insert(conns, child.ChildAdded:Connect(function(cc) onBallChildAdded(cc) end))
            end)
        end
    end))

    table.insert(conns, Players.PlayerAdded:Connect(function() state.cacheDirty = true end))
    table.insert(conns, Players.PlayerRemoving:Connect(function() state.cacheDirty = true end))

    task.spawn(function()
        while task.wait(2) do
            if getgenv()._UR_LoopID ~= currentLoopID then break end
            local ping = 0
            pcall(function() ping = player:GetNetworkPing() end)
            local base = math.clamp(3.50 - (ping * 1.5), 2.80, 3.50)
            state.FAKE_DIST = base
        end
    end)

    local cancelBlockCount = 0
    local DENIED_SUBSTRINGS = { "denied", "cancel", "blocked", "reject", "refuse", "failed" }
    local DENIED_EVENT_NAMES = {
        "KickBallDeniedEvent","KickBallDenied","KickDenied","TouchDenied","KickCancel","CancelKick","KickBlocked","BallDenied","KickFailed","OnKickDenied","KickCancelled","KickRefused","DenyKick","RejectKick","KickRejected","BallTouchDenied","TouchCancelled","TouchBlocked","OnDenyKick","ServerDenyKick","CancelTouch",
    }

    local function nameIsDenied(name)
        local lower = name:lower()
        for _, s in ipairs(DENIED_SUBSTRINGS) do if lower:find(s, 1, true) then return true end end
        for _, exact in ipairs(DENIED_EVENT_NAMES) do if name == exact then return true end end
        return false
    end

    local function blockDeniedEvent(ev)
        if not ev or not ev:IsA("RemoteEvent") then return end
        if state.blockedRemotes[ev] then return end
        state.blockedRemotes[ev] = true
        if getconnections_fn then
            pcall(function()
                for _, cc in pairs(getconnections_fn(ev.OnClientEvent)) do pcall(function() cc:Disable() end) end
            end)
        end
    end

    local function blockAllDeniedEvents()
        for _, child in pairs(ReplicatedStorage:GetChildren()) do
            if not SAFE_REMOTE_NAMES[child.Name] and child:IsA("RemoteEvent") and nameIsDenied(child.Name) then blockDeniedEvent(child) end
        end
    end

    task.delay(1, function() if getgenv()._UR_LoopID == currentLoopID then pcall(blockAllDeniedEvents) end end)
    task.delay(5, function() if getgenv()._UR_LoopID == currentLoopID then pcall(blockAllDeniedEvents) end end)

    table.insert(conns, ReplicatedStorage.ChildAdded:Connect(function(child)
        if not (cfg.enabled and cfg.blockDeny) then return end
        if not SAFE_REMOTE_NAMES[child.Name] and child:IsA("RemoteEvent") and nameIsDenied(child.Name) then
            task.defer(function() pcall(blockDeniedEvent, child) end)
        end
    end))

    if not getgenv()._V22MetaHooked then
        local hookOK = false
        pcall(function()
            if not getrawmetatable_fn or not setreadonly_fn then return end
            local mt = getrawmetatable_fn(game)
            local oldIndex = mt.__index
            local oldNamecall = mt.__namecall
            setreadonly_fn(mt, false)
            mt.__index = newcclosure_fn(function(self, key)
                if key ~= "Position" then return oldIndex(self, key) end
                if not cfg.enabled then return oldIndex(self, key) end
                if checkcaller_fn and checkcaller_fn() then return oldIndex(self, key) end
                if not state.ballAlive then return oldIndex(self, key) end
                local mode = state.partMode[self]
                if not mode then return oldIndex(self, key) end
                if mode == 2 then return BANISH_VEC end
                local ok, result = pcall(function()
                    local realPos = oldIndex(self, "Position")
                    local ball = state.cachedBall
                    if not ball then return realPos end
                    local ballPos = oldIndex(ball, "Position")
                    if not ballPos then return realPos end
                    local dX = ballPos.X - realPos.X
                    local dY = ballPos.Y - realPos.Y
                    local dZ = ballPos.Z - realPos.Z
                    local distSq = dX * dX + dY * dY + dZ * dZ
                    local fakeDist = state.FAKE_DIST
                    if distSq <= fakeDist * fakeDist then return realPos end
                    local reachDist = cfg.reach
                    if distSq > reachDist * reachDist then return realPos end
                    local dist = math.sqrt(distSq)
                    if dist < 0.01 then return realPos end
                    local priorityOffset = state.limbPriority[self] or 0
                    local targetSpoofDist = math.max(0.5, fakeDist - priorityOffset)
                    local invDist = 1 / dist
                    return Vector3.new(
                        ballPos.X - dX * invDist * targetSpoofDist,
                        ballPos.Y - dY * invDist * targetSpoofDist,
                        ballPos.Z - dZ * invDist * targetSpoofDist
                    )
                end)
                return ok and result or oldIndex(self, key)
            end)
            mt.__namecall = newcclosure_fn(function(self, ...)
                if not getnamecallmethod_fn then return oldNamecall(self, ...) end
                local method = getnamecallmethod_fn()
                if cfg.enabled and state.kickBallRemote and self == state.kickBallRemote and method == "FireServer" then
                    local args = { ... }
                    if type(args[4]) == "number" then args[4] = state.FAKE_DIST end
                    return oldNamecall(self, table.unpack(args))
                end
                if cfg.enabled and cfg.blockDeny and (method == "FireServer" or method == "InvokeServer") then
                    local t = typeof(self)
                    if t == "Instance" then
                        local isSafe, isDenied = false, false
                        pcall(function()
                            isSafe = SAFE_REMOTE_NAMES[self.Name] or false
                            if not isSafe then isDenied = nameIsDenied(self.Name) end
                        end)
                        if not isSafe and isDenied then cancelBlockCount = cancelBlockCount + 1; return end
                    end
                end
                return oldNamecall(self, ...)
            end)
            setreadonly_fn(mt, true)
            hookOK = true
        end)
        if hookOK then getgenv()._V22MetaHooked = true end
    end

    local hookedFuncs = {}
    local GC_HOOK_NAMES = {
        ["getClosestPlayerName"] = "closest",
        ["onBallPositionEvent"] = "ballpos",
        ["onKickDenied"] = "cancel",
        ["showCancelled"] = "cancel",
        ["cancelKick"] = "cancel",
        ["onKickCancelled"] = "cancel",
        ["kickDenied"] = "cancel",
        ["kickCancelled"] = "cancel",
        ["kickBlocked"] = "cancel",
        ["handleDenied"] = "cancel",
        ["handleCancel"] = "cancel",
    }

    local function tryHookFunctions()
        if not getgc_fn or not islclosure_fn or not hookfunction_fn then return end
        local ok, list = pcall(getgc_fn, true)
        if not ok then return end
        for _, v in pairs(list) do
            if type(v) == "function" and islclosure_fn(v) and not hookedFuncs[v] then
                local funcName = nil
                pcall(function()
                    local info = debug.getinfo(v)
                    if info then pcall(function() funcName = info.name end) end
                end)
                if funcName then
                    local hookType = GC_HOOK_NAMES[funcName]
                    if hookType == "closest" then
                        local orig
                        local hOK, hOrig = pcall(hookfunction_fn, v, newcclosure_fn(function(...)
                            if cfg.enabled and cfg.blockDeny then return player.Name end
                            return orig(...)
                        end))
                        if hOK and hOrig then orig = hOrig; hookedFuncs[v] = true end
                    elseif hookType == "ballpos" then
                        local orig
                        local hOK, hOrig = pcall(hookfunction_fn, v, newcclosure_fn(function(lag, names, positions, ...)
                            if cfg.enabled and cfg.blockDeny and type(names) == "table" and type(positions) == "table" then
                                for i, name in pairs(names) do if name ~= player.Name then positions[i] = BANISH_VEC end end
                            end
                            return orig(lag, names, positions, ...)
                        end))
                        if hOK and hOrig then orig = hOrig; hookedFuncs[v] = true end
                    elseif hookType == "cancel" then
                        local orig
                        local hOK, hOrig = pcall(hookfunction_fn, v, newcclosure_fn(function(...)
                            if cfg.enabled and cfg.blockDeny then cancelBlockCount = cancelBlockCount + 1; return end
                            return orig(...)
                        end))
                        if hOK and hOrig then orig = hOrig; hookedFuncs[v] = true end
                    end
                end
            end
        end
    end

    task.spawn(function() tryHookFunctions(); task.wait(2); tryHookFunctions() end)

    getgenv()._AutoGKV2Cleanup = function()
        getgenv().AutoGKV2Config.enabled = false
        getgenv().AutoGroundSaveConfig.enabled = false
        getgenv().AutoGKConfig.enabled = false
        cfg.enabled = false
        local charNode = player.Character
        if charNode then
            local hrp = charNode:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, n in ipairs({"GK_V","GK_R","GK_A"}) do
                    local v = hrp:FindFirstChild(n); if v then v:Destroy() end
                end
            end
            local hum = charNode:FindFirstChildOfClass("Humanoid")
            if hum then hum.AutoRotate = true end
        end
    end
end

do
    local cfg = getgenv().AutoSave
    local ballPos = Vector3.new(-311, 6, 92)
    local kickDir = Vector3.new(50, 5, 0)
    task.spawn(function()
        while true do
            if cfg.enabled then
                local KickBall = ReplicatedStorage:FindFirstChild("KickBall")
                if KickBall then
                    local field = Workspace:FindFirstChild("FootballField")
                    local ball = field and field:FindFirstChild("SoccerBall")
                    if ball then
                        ball.CFrame = CFrame.new(ballPos)
                        pcall(function() KickBall:FireServer(ballPos, kickDir, Vector3.new(0,0,0), 3, "djhtelkds") end)
                    end
                end
            end
            task.wait()
        end
    end)
end

do
    local cfg = getgenv().VelocityConfig
    local humanoid, root
    local baseWalkSpeed = 16
    local _weAreWriting = false
    local function setupCharacter(char)
        humanoid = char:WaitForChild("Humanoid")
        root = char:WaitForChild("HumanoidRootPart")
        baseWalkSpeed = humanoid.WalkSpeed
    end
    if player.Character then setupCharacter(player.Character) end
    player.CharacterAdded:Connect(setupCharacter)
    if not getgenv()._AccelBypassHooked2 then
        getgenv()._AccelBypassHooked2 = true
        local oldNewIndex
        oldNewIndex = hookmetamethod(game, "__newindex", newcclosure(function(self, key, value)
            if key == "WalkSpeed" and self == humanoid then
                if _weAreWriting then return oldNewIndex(self, key, value) end
                baseWalkSpeed = value
                if cfg.enabled then return oldNewIndex(self, key, value * cfg.multiplier) end
                return oldNewIndex(self, key, value)
            end
            return oldNewIndex(self, key, value)
        end))
        local oldIndex
        oldIndex = hookmetamethod(game, "__index", newcclosure(function(self, key)
            if key == "WalkSpeed" and self == humanoid then
                if _weAreWriting then return oldIndex(self, key) end
                if cfg.enabled then return baseWalkSpeed end
            end
            return oldIndex(self, key)
        end))
    end
    pcall(function() RunService:UnbindFromRenderStep("AccelerationBypass") end)
    RunService:BindToRenderStep("AccelerationBypass", Enum.RenderPriority.Camera.Value + 1, function()
        if not cfg.enabled or not humanoid then return end
        _weAreWriting = true
        local target = baseWalkSpeed * cfg.multiplier
        if math.abs(humanoid.WalkSpeed - target) > 0.01 then humanoid.WalkSpeed = target end
        _weAreWriting = false
    end)
end

getgenv().TeleportBallToPlayer = function()
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    local ReachDistance = 790
    local field = Workspace:FindFirstChild("FootballField")
    if not field then return end
    local soccerBall = field:FindFirstChild("SoccerBall")
    if not soccerBall then return end
    local distance = (hrp.Position - soccerBall.Position).Magnitude
    if distance > ReachDistance then return end
    local offset = hrp.CFrame.LookVector * 2
    local newPos = hrp.Position + offset
    soccerBall.CFrame = CFrame.new(newPos, newPos + hrp.CFrame.LookVector)
end

local function isAirborne()
    local char = player.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum then return false end
    if hum.FloorMaterial == Enum.Material.Air then return true end
    local s = hum:GetState()
    return s == Enum.HumanoidStateType.Freefall or s == Enum.HumanoidStateType.Jumping
end

local cachedFieldForJuggle, cachedBallForJuggle, lastCacheCheckJuggle = nil, nil, 0
local function getBallDirect()
    local now = os.clock()
    if now - lastCacheCheckJuggle > 0.3 then
        lastCacheCheckJuggle = now
        cachedFieldForJuggle = Workspace:FindFirstChild("FootballField")
        cachedBallForJuggle = cachedFieldForJuggle and cachedFieldForJuggle:FindFirstChild("SoccerBall")
        if not cachedBallForJuggle then cachedBallForJuggle = Workspace:FindFirstChild("SoccerBall") end
    end
    return cachedBallForJuggle
end

local function SneakyComputeSpoof(realPos)
    STATE.reachActive = false
    if not c.enabled then return realPos end
    if c.airOnly and not isAirborne() then return realPos end
    local char = player.Character
    if not char then return realPos end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return realPos end
    local field = Workspace:FindFirstChild("FootballField")
    local ball = field and field:FindFirstChild("SoccerBall")
    if not ball or not ball:IsA("BasePart") then return realPos end
    local ballPos = ball.Position
    if ballPos.Y < BALL_FLOOR - 1 then return realPos end
    local dist = (ballPos - realPos).Magnitude
    if dist <= 0 or dist > c.reach then return realPos end
    local flat = Vector3.new(ballPos.X - realPos.X, 0, ballPos.Z - realPos.Z)
    local look = hrp.CFrame.LookVector
    local flatLook = Vector3.new(look.X, 0, look.Z)
    local contactDir
    if flat.Magnitude > 0.05 then contactDir = flat.Unit
    elseif flatLook.Magnitude > 0.05 then contactDir = flatLook.Unit
    else contactDir = Vector3.new(0, 0, 1) end
    if flatLook.Magnitude > 0.05 then
        flatLook = flatLook.Unit
        if (contactDir.X * flatLook.X + contactDir.Z * flatLook.Z) < -0.1 then return realPos end
    end
    local dir = contactDir
    if flatLook.Magnitude > 0.05 then
        local bias = math.clamp(c.aimBias or 0.7, 0, 1)
        local mixed = Vector3.new((1 - bias) * contactDir.X + bias * flatLook.X, 0, (1 - bias) * contactDir.Z + bias * flatLook.Z)
        if mixed.Magnitude > 0.01 then dir = mixed.Unit end
    end
    local targetVy = math.clamp(vyForLevel(c.heightLevel), 0, 40)
    local U = flatLook
    if U.Magnitude < 0.5 then U = dir end
    local cosTheta = math.clamp(dir.X * U.X + dir.Z * U.Z, -1, 1)
    local merges = cosTheta >= 0.93969
    local bv = ball.Velocity
    local horiz = math.sqrt(bv.X * bv.X + bv.Z * bv.Z)
    local needed = targetVy * (merges and 1.49 or 1.05)
    local baseWanted = math.clamp(needed - horiz, 40, 80)
    getgenv().SneakyKickWalkSpeed = 19 + (baseWanted - 40) / 10
    local power = math.min(baseWanted + horiz, 85)
    if power < 1 then power = 1 end
    local q = math.clamp(targetVy / power, 0, 0.999)
    local s
    if merges then
        local lo, hi = 0.0, 0.999
        for _ = 1, 30 do
            local mid = (lo + hi) * 0.5
            local c_val = math.sqrt(math.max(1 - mid * mid, 0))
            if (mid / math.sqrt(2 + 2 * cosTheta * c_val)) < q then lo = mid else hi = mid end
        end
        s = (lo + hi) * 0.5
    else
        s = q
    end
    local cosP = math.sqrt(math.max(1 - s * s, 0))
    local launchDir = Vector3.new(dir.X * cosP, s, dir.Z * cosP)
    local k = 1.8
    local spoofTorso = (ballPos - launchDir * k) - Vector3.new(0, 1.3, 0)
    if (ballPos - spoofTorso).Magnitude > 3.9 then spoofTorso = (ballPos - launchDir * 1.2) - Vector3.new(0, 1.3, 0) end
    STATE.reachActive = true
    return spoofTorso
end

do
    local oldIndex, hooked = nil, false
    local function shouldSpoofPulse(part)
        if not part or not part:IsA("BasePart") then return false end
        local name = part.Name
        if name == "Torso" or name == "UpperTorso" or name == "LowerTorso" or name == "HumanoidRootPart" or name == "Head" then return true end
        if name:find("Leg") or name:find("Foot") or name:find("Hand") or name:find("Arm") then return true end
        return false
    end
    local function rainbowFlickOverride(part, realPos)
        local rf = getgenv().RainbowFlickConfig
        if not rf.enabled then return nil end
        local ball = getBallDirect()
        if not ball then return nil end
        local ok, ballPos = pcall(function() return ball.Position end)
        if not ok or not ballPos then return nil end
        local dx = ballPos.X - realPos.X
        local dy = ballPos.Y - realPos.Y
        local dz = ballPos.Z - realPos.Z
        local magnitude = math.sqrt(dx*dx + dy*dy + dz*dz)
        local maxReachThreshold = rf.reachScale * 1.25
        if magnitude > maxReachThreshold or magnitude <= 0.1 then return nil end
        return Vector3.new(ballPos.X, ballPos.Y - 3, ballPos.Z)
    end
    local function groundShotsOverride(part, realPos)
        if not getgenv().JuvsReachConfig.Enabled then return nil end
        local ball = getBallDirect()
        if not ball then return nil end
        local ballPos = ball.Position
        local dx = ballPos.X - realPos.X
        local dz = ballPos.Z - realPos.Z
        local magnitude = math.sqrt(dx*dx + (ballPos.Y - realPos.Y)^2 + dz*dz)
        if magnitude > getgenv().JuvsReachConfig.Range or magnitude <= 0.6 then return nil end
        local flatMag = math.sqrt(dx*dx + dz*dz)
        if flatMag <= 0.6 then return nil end
        local flatX, flatZ = dx/flatMag, dz/flatMag
        local standoff = 0.55
        local newFlat = flatMag
        if flatMag > standoff then newFlat = flatMag - (flatMag - standoff) * 0.45 end
        local targetX = ballPos.X - flatX * newFlat
        local targetZ = ballPos.Z - flatZ * newFlat
        return Vector3.new(targetX, realPos.Y, targetZ)
    end
    local function juggleOverride(part, realPos)
        if not getgenv().AutoJuggleV1.enabled then return nil end
        local charNode = player.Character
        if not charNode then return nil end
        local ball = getBallDirect()
        if not ball then return nil end
        local ballPos = ball.Position
        local dx = ballPos.X - realPos.X
        local dy = ballPos.Y - realPos.Y
        local dz = ballPos.Z - realPos.Z
        local mag = math.sqrt(dx*dx + dy*dy + dz*dz)
        if mag > getgenv().AutoJuggleV1.reach or mag <= 0.01 then return nil end
        local rootPart = charNode:FindFirstChild("HumanoidRootPart")
        local hum = charNode:FindFirstChildOfClass("Humanoid")
        if not (rootPart and hum) then return nil end
        local rawMove = hum.MoveDirection
        local moveDirection = Vector3.new(rawMove.X, 0, rawMove.Z)
        local moveLen = moveDirection.Magnitude
        local isMoving = moveLen > 0.05
        local lookVector = rootPart.CFrame.LookVector
        local lookDirX, lookDirZ = lookVector.X, lookVector.Z
        local lookLen = math.sqrt(lookDirX*lookDirX + lookDirZ*lookDirZ)
        if lookLen > 0 then lookDirX, lookDirZ = lookDirX / lookLen, lookDirZ / lookLen
        else lookDirX, lookDirZ = 0, 1 end
        local alignment = isMoving and ((moveDirection.X / moveLen) * lookDirX + (moveDirection.Z / moveLen) * lookDirZ) or 0
        local speedFactor = isMoving and math.clamp(moveLen, 1.2, 2.5) or 1
        local dynamicModifier = 1.1 + (alignment * 0.45) * speedFactor
        return Vector3.new(
            ballPos.X - (dx/math.max(mag,0.01))*(0.18*dynamicModifier),
            realPos.Y,
            ballPos.Z - (dz/math.max(mag,0.01))*(0.18*dynamicModifier)
        )
    end
    local function installHook()
        if hooked then return end
        local success = pcall(function()
            oldIndex = hookmetamethod(game, "__index", function(self, key)
                if key ~= "Position" and key ~= "WalkSpeed" then return oldIndex(self, key) end
                if key == "WalkSpeed" then
                    if STATE.reachActive then
                        local ok, isHum = pcall(function() return player.Character and self == player.Character:FindFirstChildOfClass("Humanoid") end)
                        if ok and isHum then return getgenv().SneakyKickWalkSpeed or 23 end
                    end
                    if getgenv().PokersConfig.enabled then
                        local ok, isHum = pcall(function() return player.Character and self == player.Character:FindFirstChildOfClass("Humanoid") end)
                        if ok and isHum then return getgenv().PokersConfig.forceSpeed end
                    end
                    return oldIndex(self, key)
                end
                local charNode = player.Character
                if not charNode or self.Parent ~= charNode then return oldIndex(self, key) end
                if not shouldSpoofPulse(self) then return oldIndex(self, key) end
                local name = self.Name
                local isTorso = (name == "UpperTorso" or name == "LowerTorso" or name == "HumanoidRootPart" or name == "Head")
                local realPos = oldIndex(self, key)
                local lastFeature = getgenv()._lastEnabledFeature

                if lastFeature == "juggle" and isTorso then
                    local r = juggleOverride(self, realPos); if r then return r end
                elseif lastFeature == "groundShots" and isTorso then
                    local r = groundShotsOverride(self, realPos); if r then return r end
                elseif lastFeature == "rainbowFlick" then
                    local r = rainbowFlickOverride(self, realPos); if r then return r end
                elseif lastFeature == "sneaky" and isTorso then
                    local r = SneakyComputeSpoof(realPos); if r and r ~= realPos then return r end
                else
                    if isTorso and c.enabled then
                        local r = SneakyComputeSpoof(realPos); if r and r ~= realPos then return r end
                    else STATE.reachActive = false end
                    local r = rainbowFlickOverride(self, realPos); if r then return r end
                    if isTorso then r = groundShotsOverride(self, realPos); if r then return r end end
                    if isTorso then r = juggleOverride(self, realPos); if r then return r end end
                end
                return realPos
            end)
        end)
        if success and oldIndex then hooked = true end
    end
    task.spawn(function() task.wait(1) installHook() end)
    player.CharacterAdded:Connect(function() task.wait(1.5) installHook() end)
    getgenv()._SneakyCleanup = function()
        STATE.reachActive = false
        if oldIndex then
            pcall(function()
                local mt = getrawmetatable(game)
                if mt then setreadonly(mt, false); mt.__index = oldIndex; setreadonly(mt, true) end
            end)
        end
        hooked = false
    end
    getgenv()._ReachCleanup = function() getgenv().RainbowFlickConfig.enabled = false; getgenv().ShowRainbowFlickEnabled = false end
end

do
    local LOCAL_NAME = player.Name
    local nevoCfg = getgenv().NevoReachConfig
    local SPOOF = 3.85
    local PRIORITY = true

    local torso = nil
    local ball = nil
    local touching = false
    local oldTouch, oldClosest = nil, nil
    local hookedTouch, hookedClosest = nil, nil

    local F = {
        hook = hookfunction or hookfunc,
        gc = getgc,
        isL = islclosure or is_l_closure,
        meta = getrawmetatable,
        ro = setreadonly or function(t, b)
            if b then (make_readonly or function() end)(t) else (make_writeable or function() end)(t) end
        end,
        nc = newcclosure or function(f) return f end,
        check = checkcaller or function() return false end,
        info = debug and debug.getinfo,
    }

    local function getTorso(char)
        char = char or player.Character
        if not char then return nil end
        return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
    end

    local function refreshTorso()
        if not (torso and torso.Parent) then torso = getTorso() end
        return torso
    end

    player.CharacterAdded:Connect(function(char)
        task.wait(0.2); torso = getTorso(char); hookedTouch, hookedClosest = nil, nil
    end)

    if player.Character then torso = getTorso(player.Character) end

    task.spawn(function()
        local field = Workspace:WaitForChild("FootballField", 9e9)
        ball = field:FindFirstChild("SoccerBall")
        field.ChildAdded:Connect(function(cc) if cc.Name == "SoccerBall" then ball = cc end end)
        field.ChildRemoved:Connect(function(cc) if cc == ball then ball = nil end end)
    end)

    local function ballAlive() return ball and ball.Parent end
    local function fname(f) local ok, info = pcall(F.info, f); return ok and info and info.name or nil end

    local function install()
        if not (F.gc and F.hook and F.isL and F.info) then return end
        local needT = not hookedTouch
        local needC = not hookedClosest
        if not (needT or needC) then return end
        for _, v in pairs(F.gc(true)) do
            if not (needT or needC) then break end
            if type(v) == "function" and F.isL(v) then
                if needT and fname(v) == "touchDetect" then
                    local old = F.hook(v, F.nc(function(...)
                        refreshTorso(); touching = true
                        local ok, ret = pcall(oldTouch, ...); touching = false
                        if ok then return ret end
                    end))
                    oldTouch = old; hookedTouch = v; needT = false
                elseif needC and fname(v) == "getClosestPlayerName" then
                    local old = F.hook(v, F.nc(function(...)
                        if PRIORITY and nevoCfg.enabled and ballAlive() then return LOCAL_NAME end
                        return oldClosest(...)
                    end))
                    oldClosest = old; hookedClosest = v; needC = false
                end
            end
        end
    end

    task.spawn(function()
        while task.wait(1.2) do
            if not (hookedTouch and hookedClosest) then pcall(install) end
        end
    end)

    if F.meta and F.ro then
        local mt = F.meta(game)
        local oldIndex = mt.__index
        F.ro(mt, false)
        mt.__index = F.nc(function(obj, key)
            if nevoCfg.enabled and not F.check() and touching and key == "Position" and typeof(obj) == "Instance" and obj == torso and ball then
                local real = oldIndex(obj, key)
                local parent = oldIndex(ball, "Parent")
                if not parent then return real end
                local bpos = oldIndex(ball, "Position")
                local diff = real - bpos
                local dist = diff.Magnitude
                local REACH = nevoCfg.reach
                if dist <= SPOOF or dist > REACH or dist < 0.01 then return real end
                return bpos + (diff / dist) * SPOOF
            end
            return oldIndex(obj, key)
        end)
        F.ro(mt, true)
    end
end

do
    local client = player

    local _aimbotLagThrottle = 0
    local _aimbotLagInterval = 0.016

    local function getBall()
        local field = Workspace:FindFirstChild("FootballField")
        return field and field:FindFirstChild("SoccerBall")
    end
    local antiPhaseConn, reachConn, legitConn

    local function startAntiPhase()
        if antiPhaseConn then return end
        antiPhaseConn = RunService.PostSimulation:Connect(function()
            local char = client.Character
            local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("LowerTorso"))
            local ball = getBall()
            if not root or not ball then return end
            ball.CanCollide = true; root.CanCollide = true
            if (ball.Position - root.Position).Magnitude < 4 then ball.AssemblyAngularVelocity = Vector3.new(0, 0, 0) end
        end)
    end

    local radius = 0.72
    local lerpAlpha = 1.2
    local COOLDOWN = 0.055
    local OWNERSHIP_COOLDOWN = 0.13
    local RELEASE_TIME = 0.008
    local SPIKE = 12.0
    local GRACE = 0.55
    local SPEED_CHANGE_GUARD = 3.5
    local lastBallSpeed, lastTouch, lastFire, lastOwnership, prevSpeed = 0, 0, 0, 0, 0

    local _kickThrottle = 0
    local _kickInterval = 0.016

    local function releaseOwnership(b)
        task.delay(RELEASE_TIME, function()
            pcall(function() if b and b.Parent then b:SetNetworkOwner(nil) end end)
        end)
    end

    local function kickBall()
        local now = tick()
        if now - _kickThrottle < _kickInterval then return end
        _kickThrottle = now
        local ball = getBall()
        local char = client.Character
        if not ball or not char then return end
        local head = char:FindFirstChild("Head")
        local lowerTorso = char:FindFirstChild("LowerTorso")
        local mouse = client:GetMouse()
        if not head or not lowerTorso then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if not hum or hum.Health <= 0 then return end
        local ballVel = ball.AssemblyLinearVelocity
        local speed = ballVel.Magnitude
        if speed - lastBallSpeed > SPIKE then lastTouch = now end
        lastBallSpeed = speed
        if now - lastTouch < GRACE then return end
        local speedDelta = math.abs(speed - prevSpeed); prevSpeed = speed
        if speedDelta > SPEED_CHANGE_GUARD then return end
        if now - lastFire < COOLDOWN then return end
        if now - lastOwnership < OWNERSHIP_COOLDOWN then return end
        if (ball.Position - lowerTorso.Position).Magnitude > radius then return end
        lastFire = now; lastOwnership = now
        local forward = lowerTorso.CFrame.LookVector
        local toBall = (ball.Position - lowerTorso.Position).Unit
        local dotFront = forward:Dot(toBall)
        local mousePos = mouse.Hit.Position
        local verticalAbove = ball.Position.Y - head.Position.Y
        local feetPos = lowerTorso.Position + Vector3.new(0, -1, 0)
        ball:SetNetworkOwner(client)
        if verticalAbove >= 0.4 then
            local controlPoint = head.Position + Vector3.new(0, 1.5, 0)
            local toTarget = (controlPoint - ball.Position)
            ball.AssemblyLinearVelocity = (toTarget * 10 * lerpAlpha) * 0.8
            releaseOwnership(ball); return
        end
        if math.abs(dotFront) >= 0.85 and ball.Position.Y <= feetPos.Y + 0.1 then
            local dirVec = (dotFront < 0) and -forward or forward
            local target = feetPos + dirVec
            local toTarget = (target - ball.Position)
            ball.AssemblyLinearVelocity = toTarget * 18
            local dir = (mousePos - lowerTorso.Position).Unit
            ball.AssemblyLinearVelocity = dir * 9.5
            releaseOwnership(ball); return
        end
        local controlPoint = lowerTorso.Position + forward * 1.5 + Vector3.new(0, -1, 0)
        local toTarget = (controlPoint - ball.Position)
        ball.AssemblyLinearVelocity = (toTarget * 10 * lerpAlpha) * 0.8
        releaseOwnership(ball)
    end

    local legitRadius = 1
    local legitLerpAlpha = 1.6
    local _legitThrottle = 0
    local _legitInterval = 0.016

    local function isBallInRadius()
        local ball = getBall()
        if not ball or not client.Character then return false end
        local lowerTorso = client.Character:FindFirstChild("LowerTorso")
        if not lowerTorso then return false end
        return (ball.Position - lowerTorso.Position).Magnitude <= legitRadius
    end
    local function legitKickBall()
        local now = tick()
        if now - _legitThrottle < _legitInterval then return end
        _legitThrottle = now
        local ball = getBall()
        if not isBallInRadius() or not ball then return end
        local char = client.Character
        if not char then return end
        local head = char:FindFirstChild("Head")
        local lowerTorso = char:FindFirstChild("LowerTorso")
        local mouse = client:GetMouse()
        if not head or not lowerTorso then return end
        local forward = lowerTorso.CFrame.LookVector
        local toBall = (ball.Position - lowerTorso.Position).Unit
        local dotFront = forward:Dot(toBall)
        local mousePos = mouse.Hit.Position
        local verticalAbove = ball.Position.Y - head.Position.Y
        local feetPos = lowerTorso.Position + Vector3.new(0, -1, 0)
        if verticalAbove >= 0.4 then
            local controlPoint = head.Position + Vector3.new(0, 1.5, 0)
            local newPosition = ball.Position:Lerp(controlPoint, legitLerpAlpha)
            ball.CFrame = CFrame.new(newPosition); ball.AssemblyLinearVelocity *= 0.8; return
        end
        if math.abs(dotFront) >= 0.85 and ball.Position.Y <= feetPos.Y + 0.1 then
            local dirVec = (dotFront < 0) and -forward or forward
            ball.CFrame = CFrame.new(feetPos + dirVec)
            local dir = (mousePos - lowerTorso.Position).Unit
            local bv = Instance.new("BodyVelocity")
            bv.Velocity = dir * 9.5; bv.MaxForce = Vector3.new(3000, 3000, 3000); bv.Parent = ball
            Debris:AddItem(bv, 0.1); return
        end
        local controlPoint = lowerTorso.Position + forward * 1.5 + Vector3.new(0, -1, 0)
        local newPosition = ball.Position:Lerp(controlPoint, legitLerpAlpha)
        ball.CFrame = CFrame.new(newPosition, newPosition + forward); ball.AssemblyLinearVelocity *= 0.8
    end
    local function startReach()
        if reachConn then return end
        reachConn = RunService.Heartbeat:Connect(function()
            local now = tick()
            if now - _kickThrottle >= _kickInterval then pcall(kickBall) end
        end)
    end
    local function startLegit()
        if legitConn then return end
        legitConn = RunService.Heartbeat:Connect(function()
            local now = tick()
            if now - _legitThrottle >= _legitInterval then pcall(legitKickBall) end
        end)
    end
    local function stopAll()
        if antiPhaseConn then antiPhaseConn:Disconnect() antiPhaseConn = nil end
        if reachConn then reachConn:Disconnect() reachConn = nil end
        if legitConn then legitConn:Disconnect() legitConn = nil end
    end
    getgenv()._AntiPhaseSet = function(value)
        if value then startAntiPhase(); startReach(); startLegit() else stopAll() end
    end
end

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local m = ""
    pcall(function() m = getnamecallmethod() or "" end)
    if getgenv().MeasureLagEnabled and (m == "FireServer" or m == "InvokeServer") then
        local ok, n = pcall(function() return self.Name end)
        if ok and (n == "MeasureLagEvent" or n == "MeasureLag") then return end
    end
    return oldNamecall(self, ...)
end)

task.spawn(function()
    for _ = 1, 5 do
        if ReplicatedStorage:FindFirstChild("KickBall") then break end
        ReplicatedStorage:WaitForChild("KickBall", 10)
    end
end)

WindUI:AddTheme({
    Name = "Glitched Gradient",
    Accent = Color3.fromHex("#7B3FF2"),
    Background = Color3.fromHex("#12061f"),
    Outline = Color3.fromHex("#4169E1"),
    Text = Color3.fromHex("#ffffff"),
    Placeholder = Color3.fromHex("#b19cd9"),
    Button = Color3.fromHex("#FF69B4"),
    Icon = Color3.fromHex("#8B5CF6"),
})

WindUI:AddTheme({
    Name = "Halloween Mode",
    Accent = Color3.fromHex("#FF6600"),
    Background = Color3.fromHex("#1a0800"),
    Outline = Color3.fromHex("#FF8800"),
    Text = Color3.fromHex("#FFB366"),
    Placeholder = Color3.fromHex("#CC5500"),
    Button = Color3.fromHex("#FF7700"),
    Icon = Color3.fromHex("#FF8800"),
})

WindUI:AddTheme({
    Name = "Ocean Blue",
    Accent = Color3.fromHex("#0077FF"),
    Background = Color3.fromHex("#03060f"),
    Outline = Color3.fromHex("#0055CC"),
    Text = Color3.fromHex("#cce8ff"),
    Placeholder = Color3.fromHex("#4499cc"),
    Button = Color3.fromHex("#0066EE"),
    Icon = Color3.fromHex("#3399FF"),
})

WindUI:AddTheme({
    Name = "Crimson Red",
    Accent = Color3.fromHex("#CC0000"),
    Background = Color3.fromHex("#0f0000"),
    Outline = Color3.fromHex("#990000"),
    Text = Color3.fromHex("#ffcccc"),
    Placeholder = Color3.fromHex("#882222"),
    Button = Color3.fromHex("#BB0000"),
    Icon = Color3.fromHex("#FF3333"),
})

WindUI:AddTheme({
    Name = "Emerald Green",
    Accent = Color3.fromHex("#00AA44"),
    Background = Color3.fromHex("#000f04"),
    Outline = Color3.fromHex("#008833"),
    Text = Color3.fromHex("#ccffdd"),
    Placeholder = Color3.fromHex("#226644"),
    Button = Color3.fromHex("#009933"),
    Icon = Color3.fromHex("#00CC55"),
})

WindUI:AddTheme({
    Name = "Midnight Gold",
    Accent = Color3.fromHex("#FFB800"),
    Background = Color3.fromHex("#0d0900"),
    Outline = Color3.fromHex("#CC9200"),
    Text = Color3.fromHex("#fff0cc"),
    Placeholder = Color3.fromHex("#997722"),
    Button = Color3.fromHex("#DDAA00"),
    Icon = Color3.fromHex("#FFD000"),
})

WindUI:AddTheme({
    Name = "Cyber Pink",
    Accent = Color3.fromHex("#FF1493"),
    Background = Color3.fromHex("#0f000a"),
    Outline = Color3.fromHex("#CC0077"),
    Text = Color3.fromHex("#ffccee"),
    Placeholder = Color3.fromHex("#882255"),
    Button = Color3.fromHex("#EE1188"),
    Icon = Color3.fromHex("#FF44AA"),
})

WindUI:AddTheme({
    Name = "Arctic White",
    Accent = Color3.fromHex("#5599FF"),
    Background = Color3.fromHex("#0a0e18"),
    Outline = Color3.fromHex("#778899"),
    Text = Color3.fromHex("#eef2ff"),
    Placeholder = Color3.fromHex("#8899bb"),
    Button = Color3.fromHex("#4477EE"),
    Icon = Color3.fromHex("#99bbff"),
})

WindUI:AddTheme({
    Name = "Void Purple",
    Accent = Color3.fromHex("#8800FF"),
    Background = Color3.fromHex("#070010"),
    Outline = Color3.fromHex("#6600CC"),
    Text = Color3.fromHex("#eeccff"),
    Placeholder = Color3.fromHex("#553377"),
    Button = Color3.fromHex("#7700EE"),
    Icon = Color3.fromHex("#AA44FF"),
})

local Window = WindUI:CreateWindow({
    Title = "Kaze Studios",
    Author = "",
    Icon = "zap",
    Theme = "Glitched Gradient",
    Acrylic = true,
    Transparent = true,
    Size = UDim2.fromOffset(680, 460),
    MinSize = Vector2.new(560, 350),
    MaxSize = Vector2.new(850, 560),
    ToggleKey = Enum.KeyCode.RightShift,
    Resizable = true,
    AutoScale = true,
    NewElements = true,
    BackgroundImageTransparency = 0.65,
    HideSearchBar = false,
    ScrollBarEnabled = false,
    SideBarWidth = 200,
    Topbar = { Height = 44, ButtonsType = "Default" },
    OpenButton = {
        Title = "Kaze Studios",
        Icon = "zap",
        CornerRadius = UDim.new(1, 0),
        StrokeThickness = 3,
        Enabled = true,
        Draggable = true,
        OnlyMobile = false,
        Scale = 1,
        Color = ColorSequence.new(Color3.fromHex("#7B3FF2"), Color3.fromHex("#FF69B4")),
    },
    User = { Enabled = false },
    Config = {
        Enabled = false,
        AutoSave = false,
        Folder = nil,
    },
})

local currentKey = Enum.KeyCode.RightShift

local ScriptsTab = Window:Tab({ Title = "Scripts", Icon = "code" })
local SkillsTab = Window:Tab({ Title = "Skills", Icon = "star" })
local AimbotTab = Window:Tab({ Title = "Aimbot", Icon = "crosshair" })
local VisualsTab = Window:Tab({ Title = "Visuals", Icon = "eye" })
local PerformanceTab = Window:Tab({ Title = "Performance", Icon = "gauge" })
local FunTab = Window:Tab({ Title = "Fun", Icon = "smile" })
local ReachTab = Window:Tab({ Title = "Reach", Icon = "move" })
local ScreenTogglesTab = Window:Tab({ Title = "Screen Toggles", Icon = "smartphone" })
local BindsTab = Window:Tab({ Title = "Keybinds", Icon = "keyboard" })
local ThemeTab = Window:Tab({ Title = "Settings", Icon = "settings" })

local btnAutoSneaky, btnJuggleV1, btnGroundShots, btnPokers, btnRainbowFlick
local btnNero, btnAimbot, btnTPBall, btnAutoGK

local function refreshButtonStyle(btn, on)
    if on then
        btn.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    else
        btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
        btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    end
end

local function setFeaturePriority(feature) getgenv()._lastEnabledFeature = feature end
local function clearFeaturePriority(feature)
    if getgenv()._lastEnabledFeature == feature then getgenv()._lastEnabledFeature = nil end
end
local function restoreWalkSpeed()
    local char = player.Character
    if not char then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum.WalkSpeed = 23 end
end

local function SetAutoSneaky(state, force)
    state = state and true or false
    if c.enabled == state and not force then return end
    c.enabled = state
    if not state then STATE.reachActive = false; clearFeaturePriority("sneaky"); restoreWalkSpeed()
    else setFeaturePriority("sneaky") end
    if btnAutoSneaky then refreshButtonStyle(btnAutoSneaky, state); btnAutoSneaky.Text = state and "Sneaky: ON" or "Sneaky: OFF" end
    if AutoSneakyToggleUI and not syncingUI then syncingUI = true; pcall(function() AutoSneakyToggleUI:Set(state) end); syncingUI = false end
end

local function SetJuggleV1(state, force)
    state = state and true or false
    if getgenv().AutoJuggleV1.enabled == state and not force then return end
    getgenv().AutoJuggleV1.enabled = state
    if not state then clearFeaturePriority("juggle") else setFeaturePriority("juggle") end
    if btnJuggleV1 then refreshButtonStyle(btnJuggleV1, state); btnJuggleV1.Text = state and "Juggle: ON" or "Juggle: OFF" end
    if JuggleV1ToggleUI and not syncingUI then syncingUI = true; pcall(function() JuggleV1ToggleUI:Set(state) end); syncingUI = false end
end

local function SetGroundShots(state, force)
    state = state and true or false
    if getgenv().JuvsReachConfig.Enabled == state and not force then return end
    getgenv().JuvsReachConfig.Enabled = state
    if not state then clearFeaturePriority("groundShots") else setFeaturePriority("groundShots") end
    if btnGroundShots then refreshButtonStyle(btnGroundShots, state); btnGroundShots.Text = state and "Ground Shots: ON" or "Ground Shots: OFF" end
    if GroundShotsToggleUI and not syncingUI then syncingUI = true; pcall(function() GroundShotsToggleUI:Set(state) end); syncingUI = false end
end

local function SetPokers(state, force)
    state = state and true or false
    if getgenv().PokersConfig.enabled == state and not force then return end
    getgenv().PokersConfig.enabled = state
    if state and refreshNoclip then refreshNoclip() elseif clearNoclip then clearNoclip() end
    if btnPokers then refreshButtonStyle(btnPokers, state); btnPokers.Text = state and "Pokers: ON" or "Pokers: OFF" end
    if PokersToggleUI and not syncingUI then syncingUI = true; pcall(function() PokersToggleUI:Set(state) end); syncingUI = false end
end

local function SetAutoGK(state, force)
    state = state and true or false
    if getgenv().AutoGKConfig.enabled == state and not force then return end
    getgenv().AutoGKConfig.enabled = state
    if not state then
        local charNode = player.Character
        if charNode then
            local hrp = charNode:FindFirstChild("HumanoidRootPart")
            if hrp then
                local v = hrp:FindFirstChild("GK_V"); local r = hrp:FindFirstChild("GK_R")
                if v then v.Enabled = false end
                if r then r.Enabled = false end
            end
            local hum = charNode:FindFirstChildOfClass("Humanoid")
            if hum then hum.AutoRotate = true end
        end
    end
    if btnAutoGK then refreshButtonStyle(btnAutoGK, state); btnAutoGK.Text = state and "Auto GK: ON" or "Auto GK: OFF" end
    if AutoGKToggleUI and not syncingUI then syncingUI = true; pcall(function() AutoGKToggleUI:Set(state) end); syncingUI = false end
end

local function SetRainbowFlick(state, force)
    state = state and true or false
    if getgenv().RainbowFlickConfig.enabled == state and not force then return end
    getgenv().RainbowFlickConfig.enabled = state
    if not state then clearFeaturePriority("rainbowFlick") else setFeaturePriority("rainbowFlick") end
    if btnRainbowFlick then refreshButtonStyle(btnRainbowFlick, state); btnRainbowFlick.Text = state and "Rainbow Flick: ON" or "Rainbow Flick: OFF" end
    if RainbowFlickToggleUI and not syncingUI then syncingUI = true; pcall(function() RainbowFlickToggleUI:Set(state) end); syncingUI = false end
end

local function SetAimbot(state, force)
    state = state and true or false
    if getgenv().AimbotConfig.enabled == state and not force then return end
    getgenv().AimbotConfig.enabled = state
    if getgenv().AimbotSync then pcall(getgenv().AimbotSync, state) end
    if btnAimbot then refreshButtonStyle(btnAimbot, state); btnAimbot.Text = state and "Aimbot: ON" or "Aimbot: OFF" end
    if AimbotToggleUI and not syncingUI then syncingUI = true; pcall(function() AimbotToggleUI:Set(state) end); syncingUI = false end
end

local function SetNero(state, force)
    state = state and true or false
    if getgenv().NeroConfig.enabled == state and not force then return end
    getgenv().NeroConfig.enabled = state
    if not state then
        if getgenv()._NeroStateCleanup then pcall(getgenv()._NeroStateCleanup) end
    end
    if btnNero then refreshButtonStyle(btnNero, state); btnNero.Text = state and "Nero: ON" or "Nero: OFF" end
    if NeroToggleUI and not syncingUI then syncingUI = true; pcall(function() NeroToggleUI:Set(state) end); syncingUI = false end
end

local AutoSneakyToggleUI, JuggleV1ToggleUI, GroundShotsToggleUI, PokersToggleUI
local RainbowFlickToggleUI, NeroToggleUI, AimbotToggleUI, AutoGKToggleUI

PerformanceTab:Section({ Title = "Render Performance" })
PerformanceTab:Toggle({ Title = "Minimal Render", Value = perf.minimalRender, Callback = function(v) perf.minimalRender = v; Perf.applyMinimalRender(v) end })
PerformanceTab:Toggle({ Title = "No Shadows", Value = perf.noShadows, Callback = function(v) perf.noShadows = v; Perf.applyNoShadows(v) end })
PerformanceTab:Toggle({ Title = "Overcast Lighting", Value = perf.overcast, Callback = function(v) perf.overcast = v; Perf.applyOvercast(v) end })
PerformanceTab:Toggle({ Title = "Disable Atmosphere", Value = perf.disableAtmosphere, Callback = function(v) perf.disableAtmosphere = v; Perf.applyDisableAtmosphere(v) end })
PerformanceTab:Toggle({ Title = "Low Fog", Value = perf.lowFog, Callback = function(v) perf.lowFog = v; Perf.applyLowFog(v) end })

PerformanceTab:Section({ Title = "Asset Performance" })
PerformanceTab:Toggle({ Title = "Disable Textures", Value = perf.disableTextures, Callback = function(v) perf.disableTextures = v; Perf.applyDisableTextures(v) end })
PerformanceTab:Toggle({ Title = "Remove Grass", Value = perf.removeGrass, Callback = function(v) perf.removeGrass = v; Perf.applyRemoveGrass(v) end })
PerformanceTab:Toggle({ Title = "Disable Decals", Value = perf.disableDecals, Callback = function(v) perf.disableDecals = v; Perf.applyDisableDecals(v) end })
PerformanceTab:Toggle({ Title = "Bare FX (All Effects Off)", Value = perf.bareFx, Callback = function(v) perf.bareFx = v; Perf.applyBareFx(v) end })
PerformanceTab:Toggle({ Title = "Clear Particles", Value = perf.clearParticles, Callback = function(v) perf.clearParticles = v; Perf.applyClearParticles(v) end })
PerformanceTab:Toggle({ Title = "Disable Water Physics", Value = perf.disableWater, Callback = function(v) perf.disableWater = v; Perf.applyDisableWater(v) end })

PerformanceTab:Section({ Title = "System Performance" })
PerformanceTab:Toggle({ Title = "Disable Sounds", Value = perf.disableSounds, Callback = function(v) perf.disableSounds = v; Perf.applyDisableSounds(v) end })
PerformanceTab:Toggle({ Title = "Freeze Animations", Value = perf.freezeAnimations, Callback = function(v) perf.freezeAnimations = v; Perf.applyFreezeAnimations(v) end })
PerformanceTab:Toggle({ Title = "Network Optimize", Value = perf.networkOptimize, Callback = function(v) perf.networkOptimize = v; Perf.applyNetworkOptimize(v) end })

PerformanceTab:Section({ Title = "FPS Control" })
PerformanceTab:Toggle({ Title = "Enable FPS Cap", Value = perf.fpsCapEnabled, Callback = function(v) perf.fpsCapEnabled = v; Perf.applyFpsCap(v, perf.fpsCapValue) end })
PerformanceTab:Slider({ Title = "FPS Cap", Value = { Min = 30, Max = 240, Default = perf.fpsCapValue }, Step = 0.1, Callback = function(v) local n = math.floor(v + 0.5); perf.fpsCapValue = n; if perf.fpsCapEnabled then Perf.applyFpsCap(true, n) end end })

PerformanceTab:Section({ Title = "Master" })
PerformanceTab:Toggle({ Title = "Full Performance Mode", Value = perf.fullPerformance, Callback = function(v) perf.fullPerformance = v; Perf.applyFullPerformance(v) end })

ScriptsTab:Section({ Title = "Ground Shots" })
GroundShotsToggleUI = ScriptsTab:Toggle({
    Title = "Ground Shots Toggle", Value = false,
    Callback = function(Value) if syncingUI then return end; SetGroundShots(Value) end,
})
ScriptsTab:Slider({ Title = "Ground Shots Range", Value = { Min = 4.1, Max = 8, Default = 4.1 }, Step = 0.1, Callback = function(v) getgenv().JuvsReachConfig.Range = round01(v) end })

ScriptsTab:Section({ Title = "Rainbow Flick" })
RainbowFlickToggleUI = ScriptsTab:Toggle({
    Title = "Rainbow Flick", Value = false,
    Callback = function(Value) if syncingUI then return end; SetRainbowFlick(Value) end,
})
ScriptsTab:Slider({ Title = "Rainbow Flick Scale", Value = { Min = 4.1, Max = 10, Default = 4.1 }, Step = 0.1, Callback = function(v) getgenv().RainbowFlickConfig.reachScale = round01(v) end })

ScriptsTab:Section({ Title = "Auto GK" })
AutoGKToggleUI = ScriptsTab:Toggle({
    Title = "Enable Auto GK", Value = false,
    Callback = function(Value) if syncingUI then return end; SetAutoGK(Value) end,
})
ScriptsTab:Slider({ Title = "Dive Speed", Value = { Min = 10, Max = 60, Default = 26 }, Step = 0.1, Callback = function(v) getgenv().AutoGKConfig.diveSpeed = round01(v) end })
ScriptsTab:Slider({ Title = "Jump React", Value = { Min = 0.10, Max = 1.00, Default = 0.40 }, Step = 0.1, Callback = function(v) getgenv().AutoGKConfig.jumpReact = round01(v) end })
ScriptsTab:Slider({ Title = "Save React", Value = { Min = 0.50, Max = 3.00, Default = 1.70 }, Step = 0.1, Callback = function(v) getgenv().AutoGKConfig.saveReact = round01(v) end })
ScriptsTab:Toggle({ Title = "Auto Ground Save", Value = false, Callback = function(Value) getgenv().AutoGroundSaveConfig.enabled = Value end })
ScriptsTab:Toggle({ Title = "Block Deny Events", Value = true, Callback = function(Value) getgenv().TouchReachConfig.blockDeny = Value end })
ScriptsTab:Toggle({ Title = "Touch Reach", Value = false, Callback = function(Value) getgenv().TouchReachConfig.enabled = Value end })
ScriptsTab:Slider({ Title = "Touch Reach Range", Value = { Min = 4.1, Max = 10.0, Default = 4.1 }, Step = 0.1, Callback = function(v) getgenv().TouchReachConfig.reach = round01(v) end })

ScriptsTab:Section({ Title = "Rank Bypass" })
do
    getgenv().RankBypass = { enabled = false }
    local rbCfg = getgenv().RankBypass
    local placeIDs = {
        ["procup"]=138792551842718,["junior"]=16452693191,["pro"]=16452698027,["elite"]=16876418704,
        ["cup"]=16453243555,["futsal"]=16452721151,["street"]=105531756926941,["2vs2"]=130754361889730,
        ["1vs1"]=18738477182,["quest"]=81844361462023,["academy"]=16452695324,
    }
    local rbOptions, sortedKeys = {}, {}
    for name in pairs(placeIDs) do table.insert(rbOptions, name); table.insert(sortedKeys, name) end
    table.sort(rbOptions); table.sort(sortedKeys, function(a, b) return #a > #b end)
    local function rbTeleport(id)
        task.spawn(function()
            for _ = 1, 15 do pcall(function() TeleportService:Teleport(id, player) end); task.wait(0.2) end
        end)
    end
    ScriptsTab:Toggle({ Title = "Rank Bypass Portals", Value = rbCfg.enabled, Callback = function(Value) rbCfg.enabled = Value end })
    ScriptsTab:Dropdown({ Title = "Select Rank", Values = rbOptions, Value = rbOptions[1], Callback = function(Value) if not rbCfg.enabled then return end local id = placeIDs[Value]; if id then rbTeleport(id) end end })
    local function getPlaceID(portalName)
        if type(portalName) ~= "string" then return nil end
        local name = portalName:lower():gsub("portal",""):gsub("%s+",""):gsub("_","")
        for _, key in ipairs(sortedKeys) do if name:find(key, 1, true) then return placeIDs[key] end end
        return nil
    end
    local rbDebounce = false
    local function onTouch(portal, hit)
        if not rbCfg.enabled or rbDebounce then return end
        if not hit or not hit.Parent or hit.Parent ~= player.Character then return end
        local id = getPlaceID(portal.Name)
        if not id and portal.Parent then id = getPlaceID(portal.Parent.Name) end
        if id then rbDebounce = true; rbTeleport(id); task.delay(3.2, function() rbDebounce = false end) end
    end
    local function hookPortal(portal)
        if portal:IsA("BasePart") then portal.Touched:Connect(function(hit) onTouch(portal, hit) end) end
    end
    local lobby = Workspace:FindFirstChild("Lobby")
    local portals = lobby and lobby:FindFirstChild("Portals")
    if portals then
        for _, v in ipairs(portals:GetDescendants()) do hookPortal(v) end
        portals.DescendantAdded:Connect(hookPortal)
    else
        for _, v in ipairs(Workspace:GetDescendants()) do
            if v:IsA("BasePart") and (v.Name:lower():find("portal") or getPlaceID(v.Name)) then hookPortal(v) end
        end
    end
end

SkillsTab:Section({ Title = "Sneaky" })
AutoSneakyToggleUI = SkillsTab:Toggle({
    Title = "Sneaky", Value = false,
    Callback = function(Value) if syncingUI then return end; SetAutoSneaky(Value) end,
})
SkillsTab:Slider({ Title = "Sneaky Reach", Value = { Min = 4.1, Max = 9, Default = 4.1 }, Step = 0.1, Callback = function(v) c.reach = round01(v) end })

SkillsTab:Section({ Title = "Auto Juggle" })
JuggleV1ToggleUI = SkillsTab:Toggle({
    Title = "Auto Juggle", Value = false,
    Callback = function(Value) if syncingUI then return end; SetJuggleV1(Value) end,
})
SkillsTab:Slider({ Title = "Auto Juggle Reach", Value = { Min = 4.1, Max = 9, Default = 4.1 }, Step = 0.1, Callback = function(v) getgenv().AutoJuggleV1.reach = round01(v) end })

SkillsTab:Section({ Title = "Pokers" })
PokersToggleUI = SkillsTab:Toggle({
    Title = "Pokers", Value = false,
    Callback = function(Value) if syncingUI then return end; SetPokers(Value) end,
})

SkillsTab:Section({ Title = "Nero" })
NeroToggleUI = SkillsTab:Toggle({
    Title = "Nero", Value = false,
    Callback = function(Value) if syncingUI then return end; SetNero(Value) end,
})
SkillsTab:Toggle({
    Title = "Nero Curve",
    Value = false,
    Callback = function(Value) getgenv().NeroConfig.curveEnabled = Value end,
})
SkillsTab:Slider({
    Title = "Nero Curve Multiplier",
    Value = { Min = 1.0, Max = 2.5, Default = 1.0 },
    Step = 0.1,
    Callback = function(v) getgenv().NeroConfig.curveMultiplier = round01(v) end,
})
SkillsTab:Toggle({
    Title = "Nero Curve Invert",
    Value = false,
    Callback = function(Value) getgenv().NeroConfig.curveInvert = Value end,
})

SkillsTab:Section({ Title = "Header" })
getgenv().HeaderConfig = { enabled = false, radius = 5 }
local headerCfg = getgenv().HeaderConfig
local headerLastKick = 0
local HEADER_COOLDOWN = 0.35
local headerHeartbeat = nil

local function safeAutoHeader()
    local now = tick()
    if now - headerLastKick < HEADER_COOLDOWN then return end
    local char = player.Character
    if not char then return end
    local head = char:FindFirstChild("Head")
    if not head then return end
    local hum = char:FindFirstChildOfClass("Humanoid")
    if not hum or hum.Health <= 0 then return end
    local field = Workspace:FindFirstChild("FootballField")
    local ball = field and field:FindFirstChild("SoccerBall")
    if not ball then return end
    local dist = (ball.Position - head.Position).Magnitude
    if dist > headerCfg.radius then return end
    if ball.Position.Y < head.Position.Y - 1.5 then return end
    local kickBallRemote = ReplicatedStorage:FindFirstChild("KickBall")
    if not kickBallRemote then return end
    local mouse = player:GetMouse()
    local direction = (mouse.Hit.Position - head.Position)
    local flatDist = math.sqrt(direction.X^2 + direction.Z^2)
    if flatDist < 0.1 then return end
    direction = direction.Unit
    local headerVel = direction * 38 + Vector3.new(0, 8, 0)
    headerLastKick = now
    pcall(function()
        kickBallRemote:FireServer(ball.Position, headerVel, Vector3.new(0, 0, 0), 3.9, "header")
    end)
end

local HeaderToggleUI
HeaderToggleUI = SkillsTab:Toggle({
    Title = "Header", Value = false,
    Callback = function(Value)
        headerCfg.enabled = Value
        if Value then
            if headerHeartbeat then headerHeartbeat:Disconnect() end
            headerHeartbeat = RunService.Heartbeat:Connect(function()
                if headerCfg.enabled then pcall(safeAutoHeader) end
            end)
        else
            if headerHeartbeat then headerHeartbeat:Disconnect(); headerHeartbeat = nil end
        end
    end,
})
SkillsTab:Slider({ Title = "Header Radius", Value = { Min = 3, Max = 10, Default = 5 }, Step = 0.5, Callback = function(v) headerCfg.radius = v end })

AimbotTab:Section({ Title = "Aimbot" })
AimbotToggleUI = AimbotTab:Toggle({
    Title = "Enable Aimbot", Value = false,
    Callback = function(Value) if syncingUI then return end; SetAimbot(Value) end,
})
local ClosestGoalToggleUI
ClosestGoalToggleUI = AimbotTab:Toggle({ Title = "Auto Detect Enemy Goal", Value = true, Callback = function(Value) getgenv().AimbotConfig.autoDetect = Value end })
AimbotTab:Dropdown({
    Title = "Goal Target", Values = {"Goal A", "Goal B"}, Value = "Goal A",
    Callback = function(Value)
        local key = Value:gsub("^Goal%s+", "")
        getgenv().AimbotConfig.selectedGoal = key
        getgenv().AimbotConfig.autoDetect = false
        if ClosestGoalToggleUI then pcall(function() ClosestGoalToggleUI:Set(false) end) end
    end,
})
AimbotTab:Toggle({ Title = "Curve Shot", Value = false, Callback = function(Value) getgenv().AimbotConfig.curveEnabled = Value end })
AimbotTab:Toggle({ Title = "Curve Flip", Value = false, Callback = function(Value) getgenv().AimbotConfig.curveFlip = Value end })
AimbotTab:Toggle({ Title = "Top Corner", Value = true, Callback = function(Value) getgenv().AimbotConfig.topCornerEnabled = Value end })
AimbotTab:Toggle({ Title = "Anti Post", Value = false, Callback = function(Value) getgenv().AimbotConfig.antiPost = Value end })

local trajectoryEnabled = false
local trajectoryRainbow = false
local trajHue = 0
local trajFolder = Workspace:FindFirstChild("NamelessTrajFolder") or Instance.new("Folder", Workspace)
trajFolder.Name = "NamelessTrajFolder"
local trajPool = {}
local trajActive = 0

getgenv()._trajColorSetting = "Red"
local TRAJ_COLORS = {
    Red = Color3.fromRGB(255, 60, 60),
    Orange = Color3.fromRGB(255, 140, 0),
    Yellow = Color3.fromRGB(255, 240, 60),
    Green = Color3.fromRGB(60, 255, 60),
    Purple = Color3.fromRGB(180, 60, 255),
    Pink = Color3.fromRGB(255, 105, 180),
    White = Color3.fromRGB(255, 255, 255),
}

local function acquireTrajPart()
    trajActive = trajActive + 1
    local p = trajPool[trajActive]
    if not p then
        p = Instance.new("Part")
        p.Anchored = true
        p.CanCollide = false
        p.CanQuery = false
        p.CanTouch = false
        p.CastShadow = false
        p.Material = Enum.Material.Neon
        p.Color = Color3.fromRGB(255, 60, 60)
        p.Parent = trajFolder
        trajPool[trajActive] = p
    end
    p.Transparency = 0
    return p
end

local function releaseTrajExtras()
    for i = trajActive + 1, #trajPool do
        local p = trajPool[i]
        if p.Transparency ~= 1 then p.Transparency = 1 end
    end
end

local trajRayParams = RaycastParams.new()
trajRayParams.FilterType = Enum.RaycastFilterType.Exclude

local function updateTrajectory()
    if not trajectoryEnabled then
        if trajActive > 0 then trajActive = 0; releaseTrajExtras() end
        return
    end
    trajActive = 0
    local ball = getBallDirect()
    if not ball or not ball:IsA("BasePart") then releaseTrajExtras(); return end
    local current_velocity = ball.AssemblyLinearVelocity
    if not current_velocity or current_velocity.Magnitude < 3 then releaseTrajExtras(); return end
    local current_pos = ball.Position
    local gravity = Workspace.Gravity
    local time_step = 0.07
    local max_points = 25
    local last_pos = current_pos
    trajRayParams.FilterDescendantsInstances = {ball, player.Character, trajFolder}
    local baseColor = TRAJ_COLORS[getgenv()._trajColorSetting] or TRAJ_COLORS.Red
    local useRainbow = trajectoryRainbow or getgenv()._trajColorSetting == "Rainbow"
    for i = 1, max_points do
        local next_pos = current_pos + (current_velocity * time_step) + (0.5 * Vector3.new(0, -gravity, 0) * (time_step * time_step))
        local cast_result = Workspace:Raycast(last_pos, next_pos - last_pos, trajRayParams)
        if cast_result then
            next_pos = cast_result.Position
            local dot_val = current_velocity:Dot(cast_result.Normal)
            current_velocity = (current_velocity - (2 * dot_val * cast_result.Normal)) * 0.50
            current_pos = next_pos
        else
            current_velocity = current_velocity + Vector3.new(0, -gravity, 0) * time_step
            current_pos = next_pos
        end
        local dist = (next_pos - last_pos).Magnitude
        if dist > 0.05 then
            local p = acquireTrajPart()
            p.Size = Vector3.new(0.60, 0.60, dist)
            p.CFrame = CFrame.lookAt(last_pos:Lerp(next_pos, 0.5), next_pos)
            if useRainbow then p.Color = Color3.fromHSV((trajHue + i * 0.035) % 1, 0.85, 1)
            else p.Color = baseColor end
            p.Transparency = math.clamp(0.60 + ((i / max_points) * 0.40), 0, 1)
        end
        last_pos = next_pos
    end
    releaseTrajExtras()
end

local _trajTimer = 0
RunService.Heartbeat:Connect(function(dt)
    if trajectoryRainbow then trajHue = (trajHue + dt * 0.35) % 1 end
    _trajTimer = _trajTimer + dt
    if _trajTimer >= 0.05 then
        _trajTimer = 0
        updateTrajectory()
    end
end)

local pitchTarget = Workspace:FindFirstChild("Pitch", true) or Workspace:FindFirstChild("Field", true) or Workspace:FindFirstChild("Grass", true)
local rainbowConnection = nil
local originalPitchColors = {}
local cachedPitchParts = nil

local function collectPitchParts()
    if not pitchTarget then return {} end
    local targets = {pitchTarget}
    for _, child in pairs(pitchTarget:GetDescendants()) do table.insert(targets, child) end
    return targets
end

local function applyColorToPitch(color, revert)
    if not pitchTarget then return end
    if not cachedPitchParts then cachedPitchParts = collectPitchParts() end
    for _, child in ipairs(cachedPitchParts) do
        if child:IsA("BasePart") then
            local lName = child.Name:lower()
            if not (lName:match("goal") or lName:match("net") or lName:match("post") or lName:match("line")) then
                if revert then
                    if originalPitchColors[child] then child.Color = originalPitchColors[child] end
                else
                    if not originalPitchColors[child] then originalPitchColors[child] = child.Color end
                    child.Color = color
                end
            end
        end
    end
end

local noCollides = {}
local currentPokerBall = nil

local function clearNoclip()
    for _, nc in ipairs(noCollides) do if nc and nc.Parent then pcall(function() nc:Destroy() end) end end
    noCollides = {}
end
getgenv()._clearNoclip = clearNoclip

local function buildNoclip(chr, ball)
    clearNoclip()
    if not chr or not ball then return end
    for _, d in ipairs(chr:GetDescendants()) do
        if d:IsA("BasePart") then
            local ncc = Instance.new("NoCollisionConstraint")
            ncc.Part0 = d; ncc.Part1 = ball; ncc.Parent = d
            table.insert(noCollides, ncc)
        end
    end
end

function refreshNoclip()
    if not getgenv().PokersConfig.enabled then clearNoclip(); currentPokerBall = nil; return end
    local chr = player.Character
    if not chr then return end
    local ball = getBallDirect()
    if not ball then clearNoclip(); currentPokerBall = nil; return end
    if ball ~= currentPokerBall then currentPokerBall = ball; buildNoclip(chr, ball) end
end
getgenv()._refreshNoclip = refreshNoclip

RunService.Heartbeat:Connect(function()
    if getgenv().PokersConfig.enabled then
        local hum = player.Character and player.Character:FindFirstChildOfClass("Humanoid")
        if hum and hum.WalkSpeed ~= getgenv().PokersConfig.forceSpeed then hum.WalkSpeed = getgenv().PokersConfig.forceSpeed end
        if not currentPokerBall or not currentPokerBall.Parent then refreshNoclip() end
    else
        if #noCollides > 0 then clearNoclip() end
    end
end)

VisualsTab:Section({ Title = "Ball Visuals" })
VisualsTab:Toggle({ Title = "Ball Trajectory", Value = false, Callback = function(value) trajectoryEnabled = value end })
VisualsTab:Toggle({ Title = "Rainbow Mode (Trajectory)", Value = false, Callback = function(value) trajectoryRainbow = value end })
VisualsTab:Dropdown({ Title = "Trajectory Color", Values = {"Red","Orange","Yellow","Green","Purple","Pink","White","Rainbow"}, Value = getgenv()._trajColorSetting or "Red", Callback = function(opt) getgenv()._trajColorSetting = opt end })

VisualsTab:Section({ Title = "Pitch Settings" })
VisualsTab:Dropdown({
    Title = "Pitch Changer",
    Values = {"Default","Red","Orange","Yellow","Green","Purple","Pink","Rainbow"},
    Value = "Default",
    Callback = function(option)
        if rainbowConnection then rainbowConnection:Disconnect() rainbowConnection = nil end
        if option == "Default" then applyColorToPitch(nil, true)
        elseif option == "Rainbow" then
            local hue = 0
            rainbowConnection = RunService.RenderStepped:Connect(function(dt)
                hue = (hue + dt * 0.1) % 1
                applyColorToPitch(Color3.fromHSV(hue, 0.8, 1), false)
            end)
        else
            local colors = { Red=Color3.fromRGB(220,40,40), Orange=Color3.fromRGB(255,125,0), Yellow=Color3.fromRGB(255,230,50),
                Green=Color3.fromRGB(40,220,40), Purple=Color3.fromRGB(140,40,220), Pink=Color3.fromRGB(255,105,180) }
            if colors[option] then applyColorToPitch(colors[option], false) end
        end
    end,
})

VisualsTab:Section({ Title = "World Settings" })
VisualsTab:Input({ Title = "Set Hour", Placeholder = "12", Value = "12", Callback = function(text) local n = tonumber(text) if n then Lighting.ClockTime = math.clamp(n, 0, 24) end end })

ReachTab:Section({ Title = "Reach" })
ReachTab:Toggle({ Title = "Enable Reach", Value = getgenv().NevoReachConfig.enabled, Callback = function(Value) getgenv().NevoReachConfig.enabled = Value end })
ReachTab:Slider({ Title = "Reach", Value = { Min = 4.1, Max = 15, Default = getgenv().NevoReachConfig.reach }, Step = 0.1, Callback = function(v) getgenv().NevoReachConfig.reach = round01(v) end })

ReachTab:Section({ Title = "Anti Phase" })
ReachTab:Toggle({ Title = "Anti Phase", Value = false, Callback = function(Value) if getgenv()._AntiPhaseSet then getgenv()._AntiPhaseSet(Value) end end })

FunTab:Section({ Title = "Grind Saves" })
FunTab:Toggle({ Title = "Enable Grind Saves", Value = false, Callback = function(v) getgenv().AutoSave.enabled = v end })

FunTab:Section({ Title = "Velocity" })
FunTab:Toggle({ Title = "Enable Velocity", Value = false, Callback = function(v) getgenv().VelocityConfig.enabled = v end })
FunTab:Slider({ Title = "Velocity Multiplier", Value = { Min = 1.0, Max = 3.0, Default = 1.0 }, Step = 0.1, Callback = function(v) getgenv().VelocityConfig.multiplier = round01(v) end })

FunTab:Section({ Title = "TP Ball" })
FunTab:Button({ Title = "Teleport Ball To Player", Callback = function() pcall(function() getgenv().TeleportBallToPlayer() end) end })

do
    local NERO_GRAVITY      = 55
    local NERO_GROUND_Y     = 5.473
    local NERO_FLOOR_BUF    = 6.2
    local NERO_GOAL_X_A     = -313.13
    local NERO_GOAL_X_B     = -115.936
    local NERO_POST_L_Z     = 78.036
    local NERO_POST_R_Z     = 107.715
    local NERO_BAR_Y        = 18
    local NERO_FRAME_R      = 1.825
    local NERO_BALL_R       = 1.0
    local NERO_CLEAR        = NERO_FRAME_R + NERO_BALL_R + 0.6
    local NERO_CENTER_Z     = (NERO_POST_L_Z + NERO_POST_R_Z) / 2
    local NERO_CHIP_APEX    = 16
    local NERO_CHIP_VY_MAX  = 34
    local NERO_CHIP_MIN     = 52
    local NERO_CHIP_MAX     = 62
    local NERO_WALL_DIST    = 10
    local NERO_KICK_POWER   = 85
    local NERO_AIRBORNE_MIN = NERO_GROUND_Y + 1.5

    local neroState = false
    local neroChipTime = 0
    local neroOverrideArmed, neroOverrideVel, neroOverrideRot = false, nil, nil
    local neroOverrideTime, NERO_OVERRIDE_TTL = 0, 0.4

    local function neroClearOverride() neroOverrideArmed, neroOverrideVel, neroOverrideRot = false, nil, nil end
    local function neroArmOverride(vel, rot)
        neroOverrideVel, neroOverrideRot = vel, rot or Vector3.new(0,0,0)
        neroOverrideArmed, neroOverrideTime = true, tick()
    end

    local function neroIsNearWall(pos)
        if pos.Y > 12 then return false end
        if math.abs(pos.Z - 23.443) < NERO_WALL_DIST or math.abs(pos.Z - 161.748) < NERO_WALL_DIST then
            return true
        end
        local dX1 = math.abs(pos.X - NERO_GOAL_X_A)
        local dX2 = math.abs(pos.X - NERO_GOAL_X_B)
        if (dX1 < NERO_WALL_DIST or dX2 < NERO_WALL_DIST) and not (pos.Z >= 70 and pos.Z <= 114) then
            return true
        end
        return false
    end

    local function neroChipVy(ballY)
        local rise = math.max(NERO_CHIP_APEX - ballY, 1)
        return math.min(math.sqrt(2 * NERO_GRAVITY * rise), NERO_CHIP_VY_MAX)
    end

    local function neroSimGoal(pos, vel, goalX)
        local x0, y0, z0 = pos.X, pos.Y, pos.Z
        local vx, vy, vz = vel.X, vel.Y, vel.Z
        local dt = 0.004
        local px = x0
        for i = 1, 700 do
            local t = i * dt
            local x = x0 + vx * t
            local y = y0 + vy * t - 0.5 * NERO_GRAVITY * t * t
            local z = z0 + vz * t
            if t > 0.06 and y < NERO_FLOOR_BUF then return false end
            if math.abs(x - goalX) < 4 and z >= NERO_POST_L_Z - 2 and z <= NERO_POST_R_Z + 2 then
                local dbar = math.sqrt((x - goalX)^2 + (y - NERO_BAR_Y)^2)
                if dbar < NERO_FRAME_R + NERO_BALL_R then return false end
            end
            if math.abs(x - goalX) < 4 and y >= -1.5 and y <= 19.5 then
                local dL = math.sqrt((x - goalX)^2 + (z - NERO_POST_L_Z)^2)
                local dR = math.sqrt((x - goalX)^2 + (z - NERO_POST_R_Z)^2)
                if dL < NERO_FRAME_R + NERO_BALL_R or dR < NERO_FRAME_R + NERO_BALL_R then return false end
            end
            local crossed = (goalX < -200 and x <= goalX and px > goalX)
                         or (goalX > -200 and x >= goalX and px < goalX)
            if crossed then
                return (z >= NERO_POST_L_Z + NERO_CLEAR and z <= NERO_POST_R_Z - NERO_CLEAR
                    and y >= NERO_BALL_R and y <= NERO_BAR_Y - NERO_CLEAR)
            end
            px = x
        end
        return false
    end

    local function neroSolveShot(ballPos, targetX, targetZ, targetY, power)
        local flat = Vector3.new(targetX - ballPos.X, 0, targetZ - ballPos.Z)
        local D = flat.Magnitude
        if D < 1 then return nil end
        local flatDir = flat.Unit
        local h, g = targetY - ballPos.Y, NERO_GRAVITY
        local P2 = power * power
        local A  = 0.25 * g * g
        local B  = h * g - P2
        local C  = h * h + D * D
        local disc = B * B - 4 * A * C
        if disc < 0 then return nil end
        local sq = math.sqrt(disc)
        local candidates = { (-B + sq) / (2 * A), (-B - sq) / (2 * A) }
        table.sort(candidates)
        for _, u in ipairs(candidates) do
            if u > 0.01 then
                local t = math.sqrt(u)
                if t < 4 then
                    local vh = D / t
                    if vh <= power then
                        local vy2 = P2 - vh * vh
                        if vy2 >= 0 then
                            local vy = math.sqrt(vy2)
                            local ycheck = ballPos.Y + vy * t - 0.5 * g * u
                            if math.abs(ycheck - targetY) < 1.0 then
                                return flatDir * vh + Vector3.new(0, vy, 0)
                            end
                        end
                    end
                end
            end
        end
        return nil
    end

    local function neroApplyCurve(ballPos, vel, rot)
        if not (vel and getgenv().NeroConfig.curveEnabled) then return vel, rot end
        local cm = math.clamp(getgenv().NeroConfig.curveMultiplier or 1.0, 1.0, 2.5)
        local outwardSign = (ballPos.Z > NERO_CENTER_Z) and 1 or -1
        if getgenv().NeroConfig.curveInvert then outwardSign = -outwardSign end
        local horizSpeed = math.sqrt(vel.X^2 + vel.Z^2)
        if horizSpeed > 0.01 then
            local currentAng = math.atan2(vel.Z, vel.X)
            local newAng = currentAng - outwardSign * 0.15 * cm
            vel = Vector3.new(math.cos(newAng) * horizSpeed, vel.Y, math.sin(newAng) * horizSpeed)
        end
        rot = Vector3.new(0, -outwardSign * 9 * cm, 0)
        return vel, rot
    end

    local function neroComputeShot(ballPos)
        local dA = math.abs(ballPos.X - NERO_GOAL_X_A)
        local dB = math.abs(ballPos.X - NERO_GOAL_X_B)
        local goalX = dA < dB and NERO_GOAL_X_A or NERO_GOAL_X_B
        local aimX  = goalX + (goalX < -200 and -3 or 3)

        for _, tY in ipairs({14, 13, 12, 11, 10, 9, 8}) do
            for _, zOff in ipairs({0, 4, -4, 6, -6, 2, -2}) do
                local tZ = math.clamp(NERO_CENTER_Z + zOff,
                    NERO_POST_L_Z + NERO_CLEAR + 1, NERO_POST_R_Z - NERO_CLEAR - 1)
                local vel = neroSolveShot(ballPos, aimX, tZ, tY, NERO_KICK_POWER)
                if vel and neroSimGoal(ballPos, vel, goalX) then
                    return vel, Vector3.new(0, 0, 0)
                end
            end
        end
        for _, tY in ipairs({13, 11, 9, 7}) do
            for _, zOff in ipairs({0, 3, -3, 5, -5}) do
                local tZ = math.clamp(NERO_CENTER_Z + zOff,
                    NERO_POST_L_Z + NERO_CLEAR + 1, NERO_POST_R_Z - NERO_CLEAR - 1)
                for _, pow in ipairs({80, 75, 70, 65, 60, 55, 50}) do
                    local vel = neroSolveShot(ballPos, aimX, tZ, tY, pow)
                    if vel and neroSimGoal(ballPos, vel, goalX) then
                        return vel, Vector3.new(0, 0, 0)
                    end
                end
            end
        end
        local flat = Vector3.new(aimX - ballPos.X, 0, NERO_CENTER_Z - ballPos.Z)
        local D = math.max(flat.Magnitude, 1)
        local flatDir = flat.Magnitude > 0.01 and flat.Unit or Vector3.new(goalX < -200 and -1 or 1, 0, 0)
        local t = math.clamp(D / 75, 0.3, 1.5)
        local vy = (9 - ballPos.Y + 0.5 * NERO_GRAVITY * t * t) / t
        return flatDir * (D / t) + Vector3.new(0, vy, 0), Vector3.new(0, 0, 0)
    end

    RunService.Heartbeat:Connect(function()
        if neroState and (tick() - neroChipTime > 0.5) then
            local ball = workspace:FindFirstChild("SoccerBall", true)
            if ball and ball:IsA("BasePart") and ball.Position.Y <= NERO_GROUND_Y + 0.4 then
                neroState = false
            end
        end
    end)

    local neroStartAnimation
    pcall(function()
        for _, v in pairs(getgc()) do
            if type(v) == "function" and islclosure(v) then
                local ok, info = pcall(debug.getinfo, v)
                if ok and info and info.name == "startAnimation" then
                    neroStartAnimation = v; break
                end
            end
        end
    end)

    local neroOldStartAnimation
    if neroStartAnimation then
        pcall(function()
            neroOldStartAnimation = hookfunction(neroStartAnimation, function(a,b,cc,d,e)
                if neroOverrideArmed and (tick() - neroOverrideTime) <= NERO_OVERRIDE_TTL then
                    b = neroOverrideVel
                    cc = neroOverrideRot or Vector3.new(0,0,0)
                    neroClearOverride()
                elseif neroOverrideArmed then
                    neroClearOverride()
                end
                return neroOldStartAnimation(a,b,cc,d,e)
            end)
        end)
    end

    pcall(function()
        local old
        old = hookmetamethod(game, "__namecall", function(self, ...)
            if getgenv().NeroConfig.enabled and neroStartAnimation
                and typeof(self) == "Instance" and self.Name == "KickBall"
                and getnamecallmethod() == "FireServer" then
                local args = {...}
                local ballPos, origVel = args[1], args[2]
                if typeof(ballPos) == "Vector3" and typeof(origVel) == "Vector3" then
                    if ballPos.Y > NERO_AIRBORNE_MIN and not neroIsNearWall(ballPos) then
                        local sv, sr = neroComputeShot(ballPos)
                        sv, sr = neroApplyCurve(ballPos, sv, sr)
                        args[2], args[3] = sv, sr
                        neroArmOverride(sv, sr)
                        return old(self, unpack(args))
                    end
                    if neroIsNearWall(ballPos) and not neroState then
                        local flat = Vector3.new(origVel.X, 0, origVel.Z)
                        local spd = flat.Magnitude
                        flat = spd > 0.01 and flat.Unit or Vector3.new(1, 0, 0)
                        spd = math.clamp(spd, NERO_CHIP_MIN, NERO_CHIP_MAX)
                        args[2] = flat * spd + Vector3.new(0, neroChipVy(ballPos.Y), 0)
                        args[3] = Vector3.new(0, 0, 0)
                        neroArmOverride(args[2], args[3])
                        neroState, neroChipTime = true, tick()
                        task.delay(4, function() if neroState then neroState = false end end)
                        return old(self, unpack(args))
                    elseif neroState then
                        local sv, sr = neroComputeShot(ballPos)
                        sv, sr = neroApplyCurve(ballPos, sv, sr)
                        args[2], args[3] = sv, sr
                        neroArmOverride(sv, sr)
                        neroState = false
                        return old(self, unpack(args))
                    end
                end
            end
            return old(self, ...)
        end)
    end)
end

local MobileGui = Instance.new("ScreenGui")
MobileGui.Name = "KazeMobileButtons"
MobileGui.ResetOnSpawn = false
MobileGui.DisplayOrder = 999999999
MobileGui.IgnoreGuiInset = true
pcall(function() MobileGui.Parent = CoreGui end)
if not MobileGui.Parent then MobileGui.Parent = PlayerGui end

local function makeDraggable(gui)
    local dragging, dragInput, mousePos, framePos
    gui.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true; mousePos = input.Position; framePos = gui.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    gui.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - mousePos
            gui.Position = UDim2.new(framePos.X.Scale, framePos.X.Offset + delta.X, framePos.Y.Scale, framePos.Y.Offset + delta.Y)
        end
    end)
end

local function createMobileButton(name, parent)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 110, 0, 46)
    btn.Position = UDim2.new(0.5, -55, 0.5, 0)
    btn.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    btn.TextColor3 = Color3.fromRGB(230, 230, 230)
    btn.Font = Enum.Font.GothamMedium
    btn.TextSize = 14
    btn.Text = name .. ": OFF"
    btn.TextStrokeTransparency = 1
    btn.TextScaled = false
    btn.TextWrapped = false
    btn.ClipsDescendants = false
    btn.Visible = false
    btn.Active = true
    btn.AutoButtonColor = false
    btn.BorderSizePixel = 0
    btn.Parent = parent
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)
    local tc = Instance.new("UITextSizeConstraint", btn)
    tc.MaxTextSize = 14; tc.MinTextSize = 9
    makeDraggable(btn)
    return btn
end

btnAutoSneaky = createMobileButton("Sneaky", MobileGui)
btnJuggleV1 = createMobileButton("Juggle", MobileGui)
btnGroundShots = createMobileButton("Ground Shots", MobileGui)
btnPokers = createMobileButton("Pokers", MobileGui)
btnRainbowFlick = createMobileButton("Rainbow Flick", MobileGui)
btnNero = createMobileButton("Nero", MobileGui)
btnAimbot = createMobileButton("Aimbot", MobileGui)
btnTPBall = createMobileButton("TP Ball", MobileGui)
btnAutoGK = createMobileButton("Auto GK", MobileGui)

btnAutoSneaky.Position = UDim2.new(0.5, -115, 0.85, 0)
btnJuggleV1.Position = UDim2.new(0.5, -115, 0.78, 0)
btnPokers.Position = UDim2.new(0.5, -115, 0.71, 0)
btnAutoGK.Position = UDim2.new(0.5, 5, 0.71, 0)
btnRainbowFlick.Position = UDim2.new(0.5, 5, 0.64, 0)
btnNero.Position = UDim2.new(0.5, -115, 0.57, 0)
btnAimbot.Position = UDim2.new(0.5, -115, 0.50, 0)
btnTPBall.Position = UDim2.new(0.5, -115, 0.64, 0)
btnGroundShots.Position = UDim2.new(0.5, 5, 0.78, 0)

btnAutoSneaky.MouseButton1Click:Connect(function() SetAutoSneaky(not c.enabled) end)
btnJuggleV1.MouseButton1Click:Connect(function() SetJuggleV1(not getgenv().AutoJuggleV1.enabled) end)
btnGroundShots.MouseButton1Click:Connect(function() SetGroundShots(not getgenv().JuvsReachConfig.Enabled) end)
btnPokers.MouseButton1Click:Connect(function() SetPokers(not getgenv().PokersConfig.enabled) end)
btnAutoGK.MouseButton1Click:Connect(function() SetAutoGK(not getgenv().AutoGKConfig.enabled) end)
btnRainbowFlick.MouseButton1Click:Connect(function() SetRainbowFlick(not getgenv().RainbowFlickConfig.enabled) end)
btnAimbot.MouseButton1Click:Connect(function() SetAimbot(not getgenv().AimbotConfig.enabled) end)
btnNero.MouseButton1Click:Connect(function() SetNero(not getgenv().NeroConfig.enabled) end)
btnTPBall.MouseButton1Click:Connect(function() pcall(function() getgenv().TeleportBallToPlayer() end) end)

ScreenTogglesTab:Section({ Title = "On-Screen Buttons" })
ScreenTogglesTab:Toggle({ Title = "Show Sneaky Button", Value = false, Callback = function(Value) btnAutoSneaky.Visible = Value end })
ScreenTogglesTab:Toggle({ Title = "Show Juggle Button", Value = false, Callback = function(Value) btnJuggleV1.Visible = Value end })
ScreenTogglesTab:Toggle({ Title = "Show Ground Shots Button", Value = false, Callback = function(Value) btnGroundShots.Visible = Value end })
ScreenTogglesTab:Toggle({ Title = "Show Pokers Button", Value = false, Callback = function(Value) btnPokers.Visible = Value end })
ScreenTogglesTab:Toggle({ Title = "Show Auto GK Button", Value = false, Callback = function(Value) btnAutoGK.Visible = Value end })
ScreenTogglesTab:Toggle({ Title = "Show Rainbow Flick Button", Value = false, Callback = function(Value) btnRainbowFlick.Visible = Value end })
ScreenTogglesTab:Toggle({ Title = "Show Nero Button", Value = false, Callback = function(Value) btnNero.Visible = Value end })
ScreenTogglesTab:Toggle({ Title = "Show Aimbot Button", Value = false, Callback = function(Value) btnAimbot.Visible = Value end })
ScreenTogglesTab:Toggle({ Title = "Show TP Ball Button", Value = false, Callback = function(Value) btnTPBall.Visible = Value end })

BindsTab:Section({ Title = "Feature Keybinds" })
BindsTab:Keybind({ Title = "Toggle Sneaky", Value = Enum.KeyCode.Z, Callback = function() SetAutoSneaky(not c.enabled) end })
BindsTab:Keybind({ Title = "Toggle Auto Juggle", Value = Enum.KeyCode.R, Callback = function() SetJuggleV1(not getgenv().AutoJuggleV1.enabled) end })
BindsTab:Keybind({ Title = "Toggle Ground Shots", Value = Enum.KeyCode.C, Callback = function() SetGroundShots(not getgenv().JuvsReachConfig.Enabled) end })
BindsTab:Keybind({ Title = "Toggle Pokers", Value = Enum.KeyCode.V, Callback = function() SetPokers(not getgenv().PokersConfig.enabled) end })
BindsTab:Keybind({ Title = "Toggle Auto GK", Value = Enum.KeyCode.G, Callback = function() SetAutoGK(not getgenv().AutoGKConfig.enabled) end })
BindsTab:Keybind({ Title = "Toggle Rainbow Flick", Value = Enum.KeyCode.F, Callback = function() SetRainbowFlick(not getgenv().RainbowFlickConfig.enabled) end })
BindsTab:Keybind({ Title = "Toggle Nero", Value = Enum.KeyCode.N, Callback = function() SetNero(not getgenv().NeroConfig.enabled) end })
BindsTab:Keybind({ Title = "TP Ball", Value = Enum.KeyCode.T, Callback = function() pcall(function() getgenv().TeleportBallToPlayer() end) end })
BindsTab:Keybind({ Title = "Toggle Aimbot", Value = Enum.KeyCode.X, Callback = function() SetAimbot(not getgenv().AimbotConfig.enabled) end })

ThemeTab:Section({ Title = "Theme" })
ThemeTab:Dropdown({
    Title = "Theme",
    Values = {
        "Glitched Gradient", "Halloween Mode",
        "Ocean Blue", "Crimson Red", "Emerald Green",
        "Midnight Gold", "Cyber Pink", "Arctic White", "Void Purple",
        "Dark", "Light", "Nord", "Github", "Rose", "Serika"
    },
    Value = "Glitched Gradient",
    Callback = function(selected)
        pcall(function() WindUI:SetTheme(selected) end)
    end,
})
ThemeTab:Toggle({ Title = "Acrylic", Value = false, Callback = function(state) pcall(function() WindUI:ToggleAcrylic(state) end) end })
ThemeTab:Toggle({ Title = "Transparent", Value = false, Callback = function(state) pcall(function() Window:ToggleTransparency(state) end) end })
ThemeTab:Section({ Title = "Toggle Key" })
ThemeTab:Keybind({
    Title = "Toggle UI Key",
    Value = currentKey,
    Callback = function(v)
        currentKey = (typeof(v) == "EnumItem") and v or Enum.KeyCode[v]
        pcall(function() Window:SetToggleKey(currentKey) end)
    end,
})
UserInputService.InputBegan:Connect(function(input)
    if input.KeyCode == currentKey then pcall(function() Window:Toggle() end) end
end)

task.spawn(function()
    task.wait(1)
    pcall(function() WindUI:Notify({ Title = "Kaze Studios", Content = "Welcome to Kaze Studios!" }) end)
end)