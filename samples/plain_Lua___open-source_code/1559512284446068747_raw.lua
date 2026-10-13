local RS     = game:GetService("ReplicatedStorage")
local RunSvc = game:GetService("RunService")

local SurfRunSim = require(RS:WaitForChild("SurfRunSim", 10))
local SurfRunMod = RS:WaitForChild("SurfRun", 10)
local Inputs     = SurfRunMod:WaitForChild("Inputs", 10)
local Config     = require(SurfRunMod).Config

local ReactTime = 0.65
local CoinTime  = 0.55
local Cushion   = 6
local ActCd     = 0.16
local CenterCd  = 1.0
local CoinCd    = 0.22
local InvulnPad = 9999

local live       = nil
local lastActT   = 0
local lastCenter = 0
local lastCoinT  = 0
local running    = false

local _origCrash = SurfRunSim.crash
SurfRunSim.crash = function(self, text, item)
    if self then self.invulnerableUntil = (self.t or 0) + InvulnPad end
end

local _origStep = SurfRunSim.step
SurfRunSim.step = function(state)
    if state == live then
        state.invulnerableUntil = state.t + InvulnPad
    end
    _origStep(state)
    if state == live and state.crashed then
        state.crashed = false
        state.invulnerableUntil = state.t + InvulnPad
    end
end

local _origNew = SurfRunSim.new
SurfRunSim.new = function(seed, opts)
    local s    = _origNew(seed, opts)
    live       = s
    running    = true
    lastActT   = 0
    lastCenter = 0
    lastCoinT  = 0
    s.invulnerableUntil = InvulnPad
    print("[AutoPlay v2] Run started — god-mode")
    return s
end

local function currentSpeed()
    if not live then return 42 end
    local t   = live.t
    local s   = Config.StartSpeed + (Config.SpeedRamp or 0.35) * t
    return math.min(s, Config.MaxSpeed)
end

local function fire(action)
    if not live then return end
    live.crashed = false
    SurfRunSim.input(live, action)
    pcall(function() Inputs:FireServer(action) end)
    lastActT = live.t
    print(string.format("[AutoPlay] >> %-6s  z=%-5dm  coins=%d",
        action:upper(), math.floor(live.z), live.coins))
end

local function timeToZ(z)
    local spd = currentSpeed()
    return spd > 0 and (z - live.z) / spd or math.huge
end

local function nearestThreat(lane)
    if not live then return nil end
    local pz = live.z
    local best, bestT = nil, math.huge
    for _, chunk in pairs(live.chunks) do
        for _, obs in ipairs(chunk) do
            if not obs.gone and obs.kind ~= "coin" and obs.lane == lane then
                local dist = obs.z - pz
                local tti  = timeToZ(obs.z)
                if dist > -Cushion and tti < ReactTime and tti < bestT then
                    best, bestT = obs, tti
                end
            end
        end
    end
    return best, bestT
end

local function nearestCoin(lane)
    if not live then return nil end
    local pz = live.z
    local best, bestT = nil, math.huge
    for _, chunk in pairs(live.chunks) do
        for _, obs in ipairs(chunk) do
            if not obs.gone and obs.kind == "coin" and obs.lane == lane then
                local tti = timeToZ(obs.z)
                if obs.z > pz - 2 and tti < CoinTime and tti < bestT then
                    best, bestT = obs, tti
                end
            end
        end
    end
    return best
end

local function bestSafeLane(excludeLane)
    local order = excludeLane == 2
        and {1, 3}
        or  {2, (excludeLane == 1 and 3 or 1)}
    for _, l in ipairs(order) do
        if not nearestThreat(l) then return l end
    end
    return nil
end

local function highInLane(lane)
    if not live then return false end
    local pz = live.z
    for _, chunk in pairs(live.chunks) do
        for _, obs in ipairs(chunk) do
            if not obs.gone and obs.kind == "high" and obs.lane == lane then
                local tti = timeToZ(obs.z)
                if obs.z > pz - Cushion and tti < ReactTime then return true end
            end
        end
    end
    return false
end

local function bestCoinLane(currentLane)
    if not live then return nil end
    local pz      = live.z
    local window  = currentSpeed() * CoinTime
    local scores  = {0, 0, 0}
    for _, chunk in pairs(live.chunks) do
        for _, obs in ipairs(chunk) do
            if not obs.gone and obs.kind == "coin" then
                local dist = obs.z - pz
                if dist > -2 and dist < window then
                    scores[obs.lane] = scores[obs.lane] + 1
                end
            end
        end
    end
    for l = 1, 3 do
        if nearestThreat(l) then scores[l] = -999 end
    end
    local bestL, bestS = currentLane, scores[currentLane]
    for l = 1, 3 do
        if scores[l] > bestS then bestL, bestS = l, scores[l] end
    end
    if bestL == currentLane or scores[bestL] <= scores[currentLane] then return nil end
    return bestL
end

RunSvc.Heartbeat:Connect(function()
    if not live or not running then return end

    if live.crashed then
        live.crashed = false
        live.invulnerableUntil = live.t + InvulnPad
    end

    local t = live.t
    if t - lastActT < ActCd then return end

    local lane        = live.lane
    local threat, tti = nearestThreat(lane)

    if threat then
        local kind = threat.kind

        if kind == "low" then
            if not live.airborne then fire("jump") end

        elseif kind == "high" then
            if not live.airborne and not live.rolling then
                local safeL = bestSafeLane(lane)
                if safeL and not highInLane(safeL) then
                    fire(safeL > lane and "right" or "left")
                else
                    fire("roll")
                end
            elseif live.airborne then
                local safeL = bestSafeLane(lane)
                if safeL then fire(safeL > lane and "right" or "left") end
            end

        elseif kind == "train" then
            local safeL = bestSafeLane(lane)
            if safeL then
                fire(safeL > lane and "right" or "left")
            elseif threat.ramp and not live.airborne then
                fire("jump")
            elseif not live.airborne then
                fire("jump")
            end

        else
            local safeL = bestSafeLane(lane)
            if safeL then fire(safeL > lane and "right" or "left") end
        end
        return
    end

    if t - lastCoinT > CoinCd then
        local coinLane = bestCoinLane(lane)
        if coinLane then
            fire(coinLane > lane and "right" or "left")
            lastCoinT = t
            return
        end
    end

    if lane ~= 2 and t - lastCenter > CenterCd then
        if not nearestThreat(2) and not nearestCoin(lane) then
            fire(lane > 2 and "left" or "right")
            lastCenter = t
        end
    end
end)

print([[
[AutoPlay] Loaded!
]])