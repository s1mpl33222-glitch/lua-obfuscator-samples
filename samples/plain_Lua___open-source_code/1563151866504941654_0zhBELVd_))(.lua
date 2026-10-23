-- Cookies Hub (Kukirin Life)  [KEYLESS]
-- RightShift: show/hide (changeable) | X button or _G.CookiesHubKL.Unload(): unload
-- Console: _G.CookiesHubKL.Set("AutoQuests", true)
--
-- Verified live against [🎃] Kukirin Life [Testing] (placeId 122840796290491):
--  - Cash/XP/Level are player attributes; quests pay Cash and are claimed by index.
--  - Rides are A-Chassis VehicleSeat vehicles (workspace.Rides["Ride_"..name]).
--  - The money farm auto-claims completed quests (verified +Cash) and, optionally, auto-rides
--    with a held wheelie to progress the wheelie/distance quests that feed it.

local RS = game:GetService("ReplicatedStorage")
if not (workspace:FindFirstChild("Rides") and RS:FindFirstChild("Scooters") and RS:FindFirstChild("Remotes")) then
    warn("[CookiesHub] This script only works in Kukirin Life!")
    return
end

if _G.CookiesHubKL and _G.CookiesHubKL.Unload then pcall(_G.CookiesHubKL.Unload) end

local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")
local Lighting     = game:GetService("Lighting")
local UIS          = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService  = game:GetService("HttpService")
local VirtualUser  = game:GetService("VirtualUser")
local Stats        = game:GetService("Stats")
local lp           = Players.LocalPlayer
local guiParent    = game:GetService("CoreGui")
if gethui then
    local ok, hui = pcall(gethui)
    if ok and typeof(hui) == "Instance" then guiParent = hui end
end

local MB1, TOUCH, MOVE = Enum.UserInputType.MouseButton1, Enum.UserInputType.Touch, Enum.UserInputType.MouseMovement

local Hub = { conns = {} }
_G.CookiesHubKL = Hub

local function bind(c) table.insert(Hub.conns, c) return c end

local function new(class, props)
    local inst = Instance.new(class)
    local parent = props.Parent
    props.Parent = nil
    for k, v in pairs(props) do inst[k] = v end
    inst.Parent = parent
    return inst
end

local function corner(p, r) return new("UICorner", { CornerRadius = UDim.new(0, r or 6), Parent = p }) end
local function tween(inst, props)
    TweenService:Create(inst, TweenInfo.new(0.15, Enum.EasingStyle.Quint, Enum.EasingDirection.Out), props):Play()
end

local function getHum() local c = lp.Character return c and c:FindFirstChildOfClass("Humanoid") end
local function getRoot() local c = lp.Character return c and c:FindFirstChild("HumanoidRootPart") end

----------------------------------------------------------------------
-- Remotes (nested under ReplicatedStorage.Remotes — look up by name)
----------------------------------------------------------------------
local Remotes = RS.Remotes
local function remote(name)
    for _, r in ipairs(Remotes:GetDescendants()) do
        if r.Name == name and (r:IsA("RemoteEvent") or r:IsA("RemoteFunction")) then return r end
    end
end
local GetQuests, ClaimQuest = remote("GetQuests"), remote("ClaimQuest")
local ClaimAchievement, ClaimAchievementReward = remote("ClaimAchievement"), remote("ClaimAchievementReward")
local GetDailyRewards, ClaimDailyReward = remote("GetDailyRewards"), remote("ClaimDailyReward")
local SpawnRide, GoToDealership = remote("SpawnRide"), remote("GoToDealership")
local GetRides, BuyRide = remote("GetRides"), remote("BuyRide")
local RiderArmEvent, PoliceMode = remote("RiderArmEvent"), remote("PoliceMode")
local FoodDelivery = Remotes:FindFirstChild("FoodDelivery")
local RainFolder = Remotes:FindFirstChild("MoneyRain") -- money rain events are announced as attributes on it

local function data(name)
    local ok, mod = pcall(function() return require(RS.Datas[name]) end)
    return ok and type(mod) == "table" and mod or nil
end
local AchievementConfig, RideSpecs = data("AchievementConfig"), data("RideSpecs")

----------------------------------------------------------------------
-- Settings
----------------------------------------------------------------------
local h0 = getHum()
local Defaults = {
    WalkSpeed  = h0 and h0.WalkSpeed or 16,
    JumpHeight = h0 and h0.JumpHeight or 7.2,
    HipHeight  = h0 and h0.HipHeight or 2,
    FOV        = workspace.CurrentCamera.FieldOfView,
}

local Settings = {
    -- Farm
    AutoQuests = false,
    AutoAchievements = false,
    AutoDaily = false,
    AutoDelivery = false,
    AutoBuyRide = false,
    MoneyRain = false,
    AutoWheelie = false,
    QuestHelpers = true,
    WheelieAngle = 35,
    RideSpeedBoost = 0,
    QuickRide = "",
    AntiPolice = false,
    -- Visuals / ESP
    PlayerESP = false,
    RideESP = false,
    PoliceESP = false,
    CustomerESP = false,
    DropESP = false,
    ESPNames = true,
    ESPDistance = true,
    ESPBoxes = true,
    ESPMaxDistance = 0,
    ESPPlayerColor = 350,
    ESPRideColor = 160,
    Fullbright = false,
    -- Player
    WalkSpeed = Defaults.WalkSpeed,
    JumpHeight = Defaults.JumpHeight,
    HipHeight = Defaults.HipHeight,
    InfJump = false,
    Noclip = false,
    Fly = false,
    FlySpeed = 60,
    FOV = Defaults.FOV,
    -- Interface
    UITransparency = 0,
    ShowProfile = true,
    ShowFPS = true,
    ShowPing = true,
    ToggleKey = "RightShift",
    -- Utility / performance
    AntiAFK = true,
    QuickInteract = false,
    HidePlayers = false,
    BlackScreen = false,
    FPSCap = 60,
    AntiLag = false,
    -- Config
    AutoLoad = false,
}

local touched = {}
local TOUCH_KEYS = { WalkSpeed = true, JumpHeight = true, HipHeight = true, FOV = true, FPSCap = true }
local appliers, refreshers = {}, {}

local function setSetting(key, value)
    Settings[key] = value
    if TOUCH_KEYS[key] then touched[key] = true end
    local apply = appliers[key]
    if apply then apply(value) end
end

----------------------------------------------------------------------
-- Rides and teleporting
-- A ride is several physics assemblies (body + each wheel) held together by joints, so it's
-- always moved as a whole model: moving one assembly leaves the rest behind and tears the bike
-- apart. The map streams in around you, so a destination is requested before moving there.
----------------------------------------------------------------------
local function myRide() return workspace.Rides:FindFirstChild("Ride_" .. lp.Name) end
local function myDriveSeat() local r = myRide() return r and r:FindFirstChild("DriveSeat", true) end
local function seated(seat) local h = getHum() return h and seat and h.SeatPart == seat end

-- Ask for the area around pos to load, waiting at most a few seconds (it's a server request)
local function streamAround(pos)
    local done = false
    task.spawn(function()
        pcall(function() lp:RequestStreamAroundAsync(pos, 5) end)
        done = true
    end)
    local started = os.clock()
    while not done and os.clock() - started < 3 do task.wait(0.1) end
end

local groundParams = RaycastParams.new()
groundParams.FilterType = Enum.RaycastFilterType.Exclude
local function groundBelow(pos, depth)
    groundParams.FilterDescendantsInstances = { workspace.Rides, lp.Character, workspace:FindFirstChild("POIs") }
    return workspace:Raycast(pos, Vector3.new(0, -(depth or 12), 0), groundParams)
end

-- How far the seat sits above the ground, so a moved ride lands on its wheels
local function seatHeight(seat)
    local g = groundBelow(seat.Position, 20)
    return g and seat.Position.Y - g.Position.Y or 3
end

-- Move your whole ride so its seat is upright at seatPos, keeping your heading, and stop it dead
local function placeRide(seatPos)
    local ride, seat = myRide(), myDriveSeat()
    if not (ride and seat) then return end
    local look = seat.CFrame.LookVector
    local target = CFrame.new(seatPos) * CFrame.Angles(0, math.atan2(-look.X, -look.Z), 0)
    ride:PivotTo(target * (seat.CFrame:Inverse() * ride:GetPivot()))
    for _, d in ipairs(ride:GetDescendants()) do
        if d:IsA("BasePart") then
            d.AssemblyLinearVelocity = Vector3.zero
            d.AssemblyAngularVelocity = Vector3.zero
        end
    end
end

-- Teleport to a spot on the ground; takes your ride along if you're on it
local function teleport(pos)
    streamAround(pos)
    -- land on the real ground under the spot (some markers float well above it, e.g. Skatepark)
    local ground = groundBelow(pos + Vector3.new(0, 40, 0), 200)
    if ground then pos = ground.Position end
    local seat = myDriveSeat()
    if seat and seated(seat) then
        placeRide(pos + Vector3.new(0, seatHeight(seat), 0))
        return
    end
    local root = getRoot()
    if not root then return end
    root.CFrame = CFrame.new(pos + Vector3.new(0, 3, 0))
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
end

local function placePosition(inst)
    if not inst then return end
    if inst:IsA("BasePart") then return inst.Position end
    if inst:IsA("Model") then local ok, cf = pcall(function() return inst:GetPivot() end) if ok then return cf.Position end end
    local part = inst:FindFirstChildWhichIsA("BasePart", true)
    return part and part.Position
end

----------------------------------------------------------------------
-- Money farm
--  - Auto quests: claims finished quests (Cash). Verified.
--  - Auto achievements: claims every tier you've reached + the milestone bonus. Verified.
--  - Auto daily: claims the daily reward when it's ready. Verified (+$1,000 on day 1).
--  - Auto delivery: food delivery job, ~$110 a minute. Verified.
--  - Auto buy: buys the fastest ride you can afford that beats yours. Verified (refused when broke).
--  - Money rain: collects drops during a money rain event (event only; couldn't be tested live).
--  - Auto wheelie ride: below.
----------------------------------------------------------------------
local Session = {
    startedAt = os.clock(),
    startCash = tonumber(lp:GetAttribute("Cash")) or 0,
    quests = 0,
    achievements = 0,
    daily = 0,
    deliveries = 0,
    deliveryCash = 0,
    ridesBought = 0,
}

-- Latest quest list, shared with the quest helpers of the wheelie farm
local quests = {}
local function questNeeds(id)
    for _, q in ipairs(quests) do
        if q.Id == id and (q.NextAt or 0) <= os.time() and (q.Progress or 0) < (q.Target or 0) then return true end
    end
    return false
end

-- Auto quests (claimed by index; the server checks Progress >= Target and the NextAt cooldown)
task.spawn(function()
    while not Hub.unloaded do
        if GetQuests and (Settings.AutoQuests or (Settings.AutoWheelie and Settings.QuestHelpers)) then
            local ok, list = pcall(function() return GetQuests:InvokeServer() end)
            if ok and type(list) == "table" then
                quests = list
                for i, q in ipairs(Settings.AutoQuests and ClaimQuest and list or {}) do
                    local ready = (q.NextAt or 0) <= os.time() and (q.Progress or 0) >= (q.Target or math.huge)
                    if ready then
                        local okc, claimed = pcall(function() return ClaimQuest:InvokeServer(i) end)
                        if okc and claimed then Session.quests += 1 task.wait(0.4) end
                    end
                end
            end
        end
        task.wait(5)
    end
end)

-- Auto achievements: each claim takes one tier, and the server refuses once you haven't reached
-- the next one; enough tiers in total also unlock a milestone bonus
local function claimAll(claim)
    for _ = 1, 20 do
        local ok, claimed = pcall(claim)
        if not (ok and claimed) then return end
        Session.achievements += 1
        task.wait(0.3)
    end
end
task.spawn(function()
    while not Hub.unloaded do
        if Settings.AutoAchievements and ClaimAchievement and AchievementConfig then
            for _, a in ipairs(AchievementConfig.Achievements or {}) do
                claimAll(function() return ClaimAchievement:InvokeServer(a.Id) end)
            end
            if ClaimAchievementReward then claimAll(function() return ClaimAchievementReward:InvokeServer() end) end
        end
        task.wait(30)
    end
end)

-- Auto daily reward
task.spawn(function()
    while not Hub.unloaded do
        if Settings.AutoDaily and GetDailyRewards and ClaimDailyReward then
            local ok, d = pcall(function() return GetDailyRewards:InvokeServer() end)
            if ok and type(d) == "table" and (d.NextAt or 0) <= os.time() then
                local okc, claimed = pcall(function() return ClaimDailyReward:InvokeServer() end)
                if okc and claimed then Session.daily += 1 end
            end
        end
        task.wait(60)
    end
end)

-- Auto buy: the fastest ride you can afford that's faster than every ride you own
-- (Robux-only and event rides aren't sold for Cash)
local function topSpeed(name) local s = RideSpecs and RideSpecs[name] return s and s.TopSpeed or 0 end
task.spawn(function()
    while not Hub.unloaded do
        if Settings.AutoBuyRide and GetRides and BuyRide then
            local ok, rides = pcall(function() return GetRides:InvokeServer() end)
            if ok and type(rides) == "table" then
                local best, cash, pick = 0, tonumber(lp:GetAttribute("Cash")) or 0, nil
                for _, r in ipairs(rides) do if r.Owned then best = math.max(best, topSpeed(r.Name)) end end
                for _, r in ipairs(rides) do
                    local price = tonumber(r.Price) or 0
                    if not r.Owned and not r.RobuxOnly and not r.Event and price > 0 and price <= cash
                        and topSpeed(r.Name) > best and (not pick or topSpeed(r.Name) > topSpeed(pick.Name)) then
                        pick = r
                    end
                end
                if pick then
                    local okb, bought = pcall(function() return BuyRide:InvokeServer(pick.Name) end)
                    if okb and bought then Session.ridesBought += 1 end
                end
            end
        end
        task.wait(20)
    end
end)

-- Money rain: drops spawn around you while an event runs and are picked up within a few studs,
-- so step off the ride and hop onto each one. Other farms pause meanwhile.
local function raining()
    if not RainFolder or RainFolder:GetAttribute("Id") == nil then return false end
    local started, duration = RainFolder:GetAttribute("StartedAt"), RainFolder:GetAttribute("Duration")
    return started ~= nil and duration ~= nil and workspace:GetServerTimeNow() < started + duration + 8
end
local collectingRain = false
task.spawn(function()
    while not Hub.unloaded do
        collectingRain = Settings.MoneyRain and raining()
        if collectingRain then
            local hum, root = getHum(), getRoot()
            if hum and hum.SeatPart then hum.Sit = false end
            local drops = workspace:FindFirstChild("MoneyRain")
            local nearest, nearestD
            for _, d in ipairs(root and drops and drops:GetChildren() or {}) do
                if d:IsA("BasePart") and d.Transparency < 1 then
                    local dist = (d.Position - root.Position).Magnitude
                    if not nearestD or dist < nearestD then nearest, nearestD = d, dist end
                end
            end
            if nearest then root.CFrame = CFrame.new(nearest.Position + Vector3.new(0, 2, 0)) end
            task.wait(0.12)
        else
            task.wait(1)
        end
    end
end)

-- Auto delivery: take an order at the delivery NPC, go to the customer and hand it over. The
-- server only accepts it once the trip would have taken (~30 s), then the next order takes ~30 s.
local DELIVERY_NPC = Vector3.new(1424.7, 58.6, -607.8)
local deliveryStatus = ""
task.spawn(function()
    while not Hub.unloaded do
        if Settings.AutoDelivery and FoodDelivery and not collectingRain then
            local target = lp:GetAttribute("DeliveryTarget")
            if typeof(target) ~= "Vector3" then
                teleport(DELIVERY_NPC)
                task.wait(0.6)
                local ok, started, msg = pcall(function() return FoodDelivery.Start:InvokeServer() end)
                if ok and started then
                    deliveryStatus = "Picked up an order"
                else
                    deliveryStatus = tostring(msg or "Waiting for the next order")
                    task.wait(3)
                end
            else
                teleport(target + Vector3.new(0, 0, 4))
                deliveryStatus = "Waiting for the customer..."
                local giveUp = os.clock() + 75
                while Settings.AutoDelivery and lp:GetAttribute("DeliveryTarget") == target and os.clock() < giveUp do
                    local ok, done, pay, _, tip = pcall(function() return FoodDelivery.Deliver:InvokeServer() end)
                    if ok and done then
                        local earned = (tonumber(pay) or 0) + (tonumber(tip) or 0)
                        Session.deliveries += 1
                        Session.deliveryCash += earned
                        deliveryStatus = "Delivered: +$" .. earned
                        break
                    end
                    task.wait(1.5)
                end
            end
        else
            deliveryStatus = ""
        end
        task.wait(0.5)
    end
end)

-- Auto wheelie ride
-- Drives the bike only through the game's own controls, never fake key presses (a fake Shift
-- toggles Shift Lock and jerks your camera around):
--  * Values.Wheelie switches the wheelie script's wheelie mode on. (The wheelie button does that
--    too, but it forces full throttle while held, which is what looped the bike over.)
--  * The Drive script's VirtualInput event takes gamepad-style analog throttle (R2), brake (L2)
--    and steering (left stick), so throttle is eased smoothly instead of switched on and off.
-- You can't steer in a wheelie (the front wheel is in the air), so it holds a straight wheelie and
-- at the edge of the area slides the whole bike back across it without touching its speed or
-- pose, and the wheelie just carries on. Verified: 42 s continuous at 34° (±0), no bails.
local FARM_SPOT = Vector3.new(1100, 56.4, -1500) -- open ground, nothing within ~360 studs
local farmAnchor, farmRadius = FARM_SPOT, 260

local function chassis()
    local aci = lp:FindFirstChild("PlayerGui") and lp.PlayerGui:FindFirstChild("A-Chassis Interface")
    local values = aci and aci:FindFirstChild("Values")
    local drive = aci and aci:FindFirstChild("Drive")
    local input = drive and drive:FindFirstChild("VirtualInput")
    if values and values:FindFirstChild("Wheelie") and input then return values, input end
end

-- Send an analog pad value, only when it changes (the interface is rebuilt each time you sit)
local sent, sentTo = {}, nil
local function pad(input, keyCode, value)
    if sentTo ~= input then sent, sentTo = {}, input end
    value = math.floor(value * 50 + 0.5) / 50
    if sent[keyCode] == value then return end
    sent[keyCode] = value
    input:Fire({
        KeyCode = keyCode, UserInputType = Enum.UserInputType.Gamepad1, UserInputState = Enum.UserInputState.Change,
        Position = keyCode == Enum.KeyCode.Thumbstick1 and Vector3.new(value, 0, 0) or Vector3.new(0, 0, value),
    })
end

local function releaseRide()
    local values, input = chassis()
    if not values then return end
    pad(input, Enum.KeyCode.ButtonR2, 0)
    pad(input, Enum.KeyCode.ButtonL2, 0)
    pad(input, Enum.KeyCode.Thumbstick1, 0)
    values.Wheelie.Value = false
end

-- Nearest obstacle around a ground point, checked low enough to catch curbs
local function clearRadius(ground)
    groundBelow(ground) -- refreshes the filter
    local nearest = 400
    for a = 0, 71 do
        local ang = a / 72 * math.pi * 2
        local dir = Vector3.new(math.cos(ang), 0, math.sin(ang)) * 400
        for _, h in ipairs({ 1.2, 3, 6 }) do
            local from = ground + Vector3.new(0, h, 0)
            local hit = workspace:Raycast(from, dir, groundParams)
            if hit then nearest = math.min(nearest, (hit.Position - from).Magnitude) end
        end
    end
    return nearest
end

-- idle → place (moved onto the area, settling) → launch (building speed) → wheelie
local phase, phaseAt = "idle", 0
local function setPhase(p) phase, phaseAt = p, os.clock() end

-- Quest helpers: ride one-handed / in Hard police mode only while a quest still needs it
-- (Hard mode time counts even with nobody chasing you, and nobody does out at the wheelie area)
local oneHandByHelper, policeBefore, armToggledAt = false, nil, 0
local function setOneHand(on)
    local seat = myDriveSeat()
    if not (seat and RiderArmEvent) or os.clock() - armToggledAt < 1.5 then return end
    if (seat:GetAttribute("OneHanderActive") == true) ~= on then
        armToggledAt = os.clock()
        RiderArmEvent:FireServer() -- toggles one-handed riding
    end
end
local function questHelpers()
    local wheelieing = Settings.AutoWheelie and phase == "wheelie"
    if Settings.QuestHelpers and wheelieing and questNeeds("OneHandWheelie") then
        oneHandByHelper = true
        setOneHand(true)
    elseif oneHandByHelper then
        local seat = myDriveSeat()
        if seat and seat:GetAttribute("OneHanderActive") == true then setOneHand(false) else oneHandByHelper = false end
    end
    if not PoliceMode then return end
    local mode = lp:GetAttribute("PoliceMode") or "None"
    if Settings.QuestHelpers and wheelieing and questNeeds("HardPoliceTime") then
        if policeBefore == nil then policeBefore = mode end
        if mode ~= "Hard" then PoliceMode:FireServer("Hard") end
        return
    end
    local want = Settings.AntiPolice and "None" or policeBefore -- back to what you had before
    policeBefore = nil
    if want and mode ~= want then PoliceMode:FireServer(want) end
end

-- Keep you on the bike (re-mount after a bail) and start each run on the wheelie area. Pauses
-- while delivering or collecting money rain, since those move you around.
local respawnedAt, respawning = 0, false
local function respawnRide()
    if not SpawnRide or respawning or os.clock() - respawnedAt < 6 then return end
    respawnedAt, respawning = os.clock(), true
    local template = myRide() and myRide():GetAttribute("TemplateName") or "ScooterG2"
    -- never wait on the server here: if it doesn't answer, the farm loop would hang with it
    task.spawn(function()
        pcall(function() SpawnRide:InvokeServer(template) end)
        respawning = false
    end)
end

-- A bike can stop responding (the game takes over its physics, and then it can't be moved or
-- driven). If it hasn't moved and isn't earning wheelie time for a while, bring a fresh one. One
-- that's frozen mid-wheelie but still counting wheelie time is left alone: that still pays.
local stuckSince, lastCheckPos, lastWheelieTime
local function stuck(seat)
    local wt = tonumber(lp:GetAttribute("WheelieTime")) or 0
    local still = lastCheckPos and (seat.Position - lastCheckPos).Magnitude < 0.5
    local earning = lastWheelieTime and wt > lastWheelieTime
    lastCheckPos, lastWheelieTime = seat.Position, wt
    if still and not earning then
        stuckSince = stuckSince or os.clock()
        return os.clock() - stuckSince > 8
    end
    stuckSince = nil
    return false
end

task.spawn(function()
    while not Hub.unloaded do
        local seat, hum = myDriveSeat(), getHum()
        local farming = Settings.AutoWheelie and not Settings.AutoDelivery and not collectingRain
        if farming and hum and not seat then
            -- no ride, or it was left so far behind it streamed out: bring one back
            respawnRide()
            setPhase("idle")
        elseif farming and seat and hum then
            if hum.SeatPart ~= seat then
                setPhase("idle")
                local root = getRoot()
                if root then root.CFrame = seat.CFrame + Vector3.new(0, 1.5, 0) end
                task.wait(0.4)
                pcall(function() seat:Sit(hum) end)
            elseif phase == "idle" then
                streamAround(farmAnchor)
                placeRide(farmAnchor + Vector3.new(0, seatHeight(seat), 0))
                setPhase("place")
            elseif phase ~= "place" and stuck(seat) then
                stuckSince = nil
                respawnRide()
                setPhase("idle")
            end
        elseif phase ~= "idle" then
            setPhase("idle")
            releaseRide()
        end
        questHelpers()
        task.wait(0.3)
    end
end)

local lastPitch, pitchRate = 0, 0
bind(RunService.Heartbeat:Connect(function(dt)
    if phase == "idle" then return end
    local seat = myDriveSeat()
    local values, input = chassis()
    if not (seat and seated(seat) and values) then return end
    local t = os.clock() - phaseAt
    if phase == "place" then -- let it settle on its wheels after the move
        pad(input, Enum.KeyCode.ButtonR2, 0)
        if t > 1 then setPhase("launch") end
        return
    end
    pad(input, Enum.KeyCode.Thumbstick1, 0.25) -- keeps the line steady
    if phase == "launch" then -- build speed first: popping it from a standstill loops it over
        values.Wheelie.Value = false
        pad(input, Enum.KeyCode.ButtonR2, 0.7)
        pad(input, Enum.KeyCode.ButtonL2, 0)
        if t > 1.5 then lastPitch, pitchRate = 0, 0 setPhase("wheelie") end
        return
    end
    -- Hold the angle (measured against the ground under you) with smooth throttle and brake
    if not values.Wheelie.Value then values.Wheelie.Value = true end
    local g = groundBelow(seat.Position)
    local pitch = math.deg(math.asin(math.clamp(seat.CFrame.LookVector:Dot(g and g.Normal or Vector3.yAxis), -1, 1)))
    pitchRate = pitchRate * 0.7 + (pitch - lastPitch) / math.max(dt, 1 / 120) * 0.3
    lastPitch = pitch
    local u = math.clamp(0.45 + 0.04 * (Settings.WheelieAngle - pitch) - 0.012 * pitchRate, -1, 1)
    pad(input, Enum.KeyCode.ButtonR2, math.max(u, 0))
    pad(input, Enum.KeyCode.ButtonL2, math.max(-u, 0))
    -- At the edge of the area, slide the whole bike back across it (speed and pose untouched)
    local centre = Vector3.new(farmAnchor.X, 0, farmAnchor.Z)
    local pos = Vector3.new(seat.Position.X, 0, seat.Position.Z)
    local vel = seat.AssemblyLinearVelocity
    local flatVel = Vector3.new(vel.X, 0, vel.Z)
    if (pos - centre).Magnitude > farmRadius and flatVel.Magnitude > 5 and (pos - centre):Dot(flatVel) > 0 then
        local back = centre - flatVel.Unit * (farmRadius - 20)
        myRide():PivotTo(myRide():GetPivot() + (back - pos))
    end
end))

-- Speed boost: extra forward push while you throttle (not during the wheelie farm, it holds its own speed)
bind(RunService.Heartbeat:Connect(function(dt)
    if Settings.RideSpeedBoost <= 0 or Settings.AutoWheelie then return end
    local seat = myDriveSeat()
    if seat and seated(seat) and (UIS:IsKeyDown(Enum.KeyCode.W) or UIS:IsKeyDown(Enum.KeyCode.Up)) then
        local look = seat.CFrame.LookVector
        local flat = Vector3.new(look.X, 0, look.Z)
        if flat.Magnitude > 0.1 then
            local root = seat.AssemblyRootPart or seat
            root.AssemblyLinearVelocity += flat.Unit * Settings.RideSpeedBoost * dt
        end
    end
end))

----------------------------------------------------------------------
-- ESP: players and their rides, through walls
----------------------------------------------------------------------
local espFolder = Instance.new("Folder")
espFolder.Name = "CookiesHubESP"
local espTags = {}

local function espTag(target, adornee)
    local tag = espTags[target]
    if not tag then
        local gui = new("BillboardGui", {
            Adornee = adornee, AlwaysOnTop = true, Size = UDim2.fromOffset(200, 34),
            StudsOffset = Vector3.new(0, 3, 0), Parent = espFolder,
        })
        local label = new("TextLabel", {
            Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, Font = Enum.Font.GothamBold, TextSize = 13,
            TextStrokeTransparency = 0.4, Parent = gui,
        })
        local highlight = new("Highlight", {
            Adornee = target, FillTransparency = 0.75,
            DepthMode = Enum.HighlightDepthMode.AlwaysOnTop, Parent = espFolder,
        })
        tag = { gui = gui, label = label, highlight = highlight }
        espTags[target] = tag
    end
    tag.seen = true
    return tag
end

local function clearEsp(keep)
    for target, tag in pairs(espTags) do
        if not (keep and tag.seen and target.Parent) then
            tag.gui:Destroy()
            tag.highlight:Destroy()
            espTags[target] = nil
        end
        tag.seen = false
    end
end

local function paintTag(tag, color, name, dist)
    local text = Settings.ESPNames and name or ""
    if Settings.ESPDistance then
        text = (text == "" and "" or text .. "  ") .. string.format("[%dm]", dist // 1)
    end
    tag.label.Text = text
    tag.label.TextColor3 = color
    tag.highlight.FillColor = color
    tag.highlight.OutlineColor = color
    tag.highlight.Enabled = Settings.ESPBoxes
end

task.spawn(function()
    while not Hub.unloaded do
        local root = getRoot()
        if root and (Settings.PlayerESP or Settings.RideESP or Settings.PoliceESP or Settings.CustomerESP or Settings.DropESP) then
            espFolder.Parent = guiParent
            local maxD = Settings.ESPMaxDistance
            local playerColor = Color3.fromHSV(Settings.ESPPlayerColor / 360, 0.85, 1)
            local rideColor = Color3.fromHSV(Settings.ESPRideColor / 360, 0.85, 1)
            if Settings.PlayerESP then
                for _, p in ipairs(Players:GetPlayers()) do
                    local head = p ~= lp and p.Character and p.Character:FindFirstChild("Head")
                    local dist = head and (head.Position - root.Position).Magnitude
                    if head and (maxD == 0 or dist <= maxD) then
                        paintTag(espTag(p.Character, head), playerColor, p.DisplayName, dist)
                    end
                end
            end
            if Settings.RideESP then
                for _, r in ipairs(workspace.Rides:GetChildren()) do
                    local ownerId = r:GetAttribute("OwnerUserId")
                    local body = ownerId and ownerId ~= lp.UserId and r:FindFirstChild("DriveSeat", true)
                    local dist = body and (body.Position - root.Position).Magnitude
                    if body and (maxD == 0 or dist <= maxD) then
                        local ownerName = r.Name:gsub("^Ride_", "")
                        paintTag(espTag(r, body), rideColor,
                            string.format("%s's %s", ownerName, tostring(r:GetAttribute("TemplateName") or "ride")), dist)
                    end
                end
            end
            local function mark(target, adornee, color, name)
                local dist = (adornee.Position - root.Position).Magnitude
                if maxD == 0 or dist <= maxD then paintTag(espTag(target, adornee), color, name, dist) end
            end
            if Settings.PoliceESP then
                local police = workspace:FindFirstChild("PoliceNPCs")
                for _, car in ipairs(police and police:GetChildren() or {}) do
                    local body = car:FindFirstChild("DriveSeat", true) or car:FindFirstChildWhichIsA("BasePart", true)
                    if body then mark(car, body, Color3.fromRGB(70, 140, 255), "Police") end
                end
            end
            if Settings.CustomerESP then
                local customer = workspace:FindFirstChild("DeliveryCustomer")
                local hrp = customer and customer:FindFirstChild("HumanoidRootPart")
                if hrp then mark(customer, hrp, Color3.fromRGB(255, 205, 40), "Delivery customer") end
            end
            if Settings.DropESP then
                local drops = workspace:FindFirstChild("MoneyRain")
                for _, d in ipairs(drops and drops:GetChildren() or {}) do
                    if d:IsA("BasePart") and d.Transparency < 1 then mark(d, d, Color3.fromRGB(90, 220, 110), "$") end
                end
            end
            clearEsp(true)
        else
            clearEsp(false)
        end
        task.wait(0.3)
    end
end)

----------------------------------------------------------------------
-- Movement
----------------------------------------------------------------------
local noclipSaved = {}
appliers.Noclip = function(on)
    if on then return end
    for part in pairs(noclipSaved) do if part.Parent then part.CanCollide = true end end
    noclipSaved = {}
end
appliers.Fly = function(on) if not on then local h = getHum() if h then h.PlatformStand = false end end end
appliers.FOV = function(v) workspace.CurrentCamera.FieldOfView = v end

bind(RunService.Stepped:Connect(function()
    if not Settings.Noclip then return end
    local c = lp.Character
    if not c then return end
    for _, p in ipairs(c:GetDescendants()) do
        if p:IsA("BasePart") and p.CanCollide then
            noclipSaved[p] = true
            p.CanCollide = false
        end
    end
end))

bind(UIS.JumpRequest:Connect(function()
    if not Settings.InfJump then return end
    local h = getHum()
    if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
end))

local function flyDirection(h)
    local cf = workspace.CurrentCamera.CFrame
    local dir = Vector3.zero
    local K = Enum.KeyCode
    if UIS:IsKeyDown(K.W) then dir += cf.LookVector end
    if UIS:IsKeyDown(K.S) then dir -= cf.LookVector end
    if UIS:IsKeyDown(K.D) then dir += cf.RightVector end
    if UIS:IsKeyDown(K.A) then dir -= cf.RightVector end
    if dir.Magnitude == 0 then dir = h.MoveDirection end
    if UIS:IsKeyDown(K.Space) then dir += Vector3.yAxis end
    if UIS:IsKeyDown(K.LeftControl) then dir -= Vector3.yAxis end
    return dir.Magnitude > 0 and dir.Unit or Vector3.zero
end

bind(RunService.Heartbeat:Connect(function()
    local h, root = getHum(), getRoot()
    if not (h and root) then return end
    if touched.WalkSpeed then h.WalkSpeed = Settings.WalkSpeed end
    if touched.JumpHeight then h.UseJumpPower = false; h.JumpHeight = Settings.JumpHeight end
    if touched.HipHeight then h.HipHeight = Settings.HipHeight end
    if Settings.Fly then
        h.PlatformStand = true
        root.AssemblyLinearVelocity = flyDirection(h) * Settings.FlySpeed
    end
end))

bind(RunService.RenderStepped:Connect(function()
    if touched.FOV then workspace.CurrentCamera.FieldOfView = Settings.FOV end
end))

local tpTool
local function giveTeleportTool()
    if tpTool and tpTool.Parent then return end
    tpTool = new("Tool", { Name = "Click Teleport", RequiresHandle = false, CanBeDropped = false, Parent = lp:WaitForChild("Backpack") })
    tpTool.Activated:Connect(function()
        local root = getRoot()
        if not root then return end
        local hit = lp:GetMouse().Hit
        if hit then root.CFrame = CFrame.new(hit.Position + Vector3.new(0, 3, 0)) * root.CFrame.Rotation end
    end)
end

----------------------------------------------------------------------
-- Misc / performance
----------------------------------------------------------------------
bind(lp.Idled:Connect(function()
    if not Settings.AntiAFK then return end
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end)
end))

local promptSaved = {}
local function quickPrompt(p)
    if not p:IsA("ProximityPrompt") then return end
    if promptSaved[p] == nil then promptSaved[p] = p.HoldDuration end
    p.HoldDuration = 0
end
appliers.QuickInteract = function(on)
    if on then
        for _, d in ipairs(workspace:GetDescendants()) do quickPrompt(d) end
    else
        for p, v in pairs(promptSaved) do if p.Parent then p.HoldDuration = v end end
        promptSaved = {}
    end
end
bind(workspace.DescendantAdded:Connect(function(d)
    if Settings.QuickInteract then quickPrompt(d) end
end))

local hiddenParts = {}
appliers.HidePlayers = function(on)
    if on then return end
    for part in pairs(hiddenParts) do if part.Parent then part.LocalTransparencyModifier = 0 end end
    hiddenParts = {}
end
task.spawn(function()
    while not Hub.unloaded do
        if Settings.HidePlayers then
            for _, p in ipairs(Players:GetPlayers()) do
                if p ~= lp and p.Character then
                    for _, d in ipairs(p.Character:GetDescendants()) do
                        if d:IsA("BasePart") or d:IsA("Decal") then
                            hiddenParts[d] = true
                            d.LocalTransparencyModifier = 1
                        end
                    end
                end
            end
        end
        task.wait(0.5)
    end
end)

appliers.BlackScreen = function(on) RunService:Set3dRenderingEnabled(not on) end
appliers.FPSCap = function(v) if setfpscap then setfpscap(v) end end

local LAG_FX = { ParticleEmitter = true, Trail = true, Smoke = true, Fire = true, Sparkles = true, Beam = true }
local lagFx, lagShadows = {}, nil
local function killFx(d)
    if LAG_FX[d.ClassName] and d.Enabled then lagFx[d] = true; d.Enabled = false end
end
appliers.AntiLag = function(on)
    if on then
        if lagShadows == nil then lagShadows = Lighting.GlobalShadows end
        Lighting.GlobalShadows = false
        for _, d in ipairs(workspace:GetDescendants()) do killFx(d) end
    else
        if lagShadows ~= nil then Lighting.GlobalShadows = lagShadows; lagShadows = nil end
        for d in pairs(lagFx) do if d.Parent then d.Enabled = true end end
        lagFx = {}
    end
end
bind(workspace.DescendantAdded:Connect(function(d)
    if Settings.AntiLag then killFx(d) end
end))

----------------------------------------------------------------------
-- Fullbright
----------------------------------------------------------------------
local fbSaved
appliers.Fullbright = function(on)
    if on then
        fbSaved = fbSaved or {
            Brightness = Lighting.Brightness, ClockTime = Lighting.ClockTime, FogEnd = Lighting.FogEnd,
            GlobalShadows = Lighting.GlobalShadows, Ambient = Lighting.Ambient, OutdoorAmbient = Lighting.OutdoorAmbient,
        }
    elseif fbSaved then
        Lighting.Brightness, Lighting.ClockTime, Lighting.FogEnd = fbSaved.Brightness, fbSaved.ClockTime, fbSaved.FogEnd
        Lighting.GlobalShadows, Lighting.Ambient, Lighting.OutdoorAmbient = fbSaved.GlobalShadows, fbSaved.Ambient, fbSaved.OutdoorAmbient
        fbSaved = nil
    end
end
bind(RunService.Heartbeat:Connect(function()
    if not Settings.Fullbright then return end
    Lighting.Brightness = 2
    Lighting.ClockTime = 14
    Lighting.FogEnd = 1e9
    Lighting.GlobalShadows = false
    Lighting.Ambient = Color3.new(1, 1, 1)
    Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
end))

----------------------------------------------------------------------
-- Theme (purple)
----------------------------------------------------------------------
local function rgb(r, g, b) return Color3.fromRGB(r, g, b) end
local Theme = {
    Bg = rgb(18, 12, 28), Panel = rgb(29, 19, 43), Row = rgb(40, 27, 58),
    Off = rgb(78, 55, 105), Accent = rgb(174, 92, 255), Text = rgb(244, 236, 255), Sub = rgb(174, 153, 198),
}

local function paint(inst, prop, role) inst[prop] = Theme[role] return inst end

----------------------------------------------------------------------
-- Tags (profile / FPS / ping)
----------------------------------------------------------------------
local tagGui = new("ScreenGui", { Name = "CookiesHubTags", ResetOnSpawn = false, DisplayOrder = 997, Parent = guiParent })
local tagHolder = new("Frame", {
    AnchorPoint = Vector2.new(1, 0), Position = UDim2.new(1, -12, 0, 52), Size = UDim2.fromOffset(220, 0),
    AutomaticSize = Enum.AutomaticSize.Y, BackgroundTransparency = 1, Parent = tagGui,
})
new("UIListLayout", { Padding = UDim.new(0, 4), HorizontalAlignment = Enum.HorizontalAlignment.Right, SortOrder = Enum.SortOrder.LayoutOrder, Parent = tagHolder })

local function makeTag(order)
    local l = new("TextLabel", {
        Size = UDim2.fromOffset(0, 22), AutomaticSize = Enum.AutomaticSize.X, Font = Enum.Font.GothamBold, TextSize = 12,
        LayoutOrder = order, BackgroundTransparency = 0.15, Parent = tagHolder,
    })
    paint(l, "BackgroundColor3", "Panel")
    paint(l, "TextColor3", "Text")
    corner(l, 6)
    new("UIPadding", { PaddingLeft = UDim.new(0, 8), PaddingRight = UDim.new(0, 8), Parent = l })
    return l
end
local profileTag, fpsTag, pingTag = makeTag(1), makeTag(2), makeTag(3)
profileTag.Text = "@" .. lp.Name

local frames = 0
bind(RunService.RenderStepped:Connect(function() frames += 1 end))
task.spawn(function()
    while not Hub.unloaded do
        profileTag.Visible = Settings.ShowProfile
        fpsTag.Visible = Settings.ShowFPS
        pingTag.Visible = Settings.ShowPing
        fpsTag.Text = "FPS " .. frames * 2
        frames = 0
        local ok, ping = pcall(function() return Stats.Network.ServerStatsItem["Data Ping"]:GetValue() end)
        if not ok then ping = lp:GetNetworkPing() * 1000 end
        pingTag.Text = "Ping " .. math.floor(ping) .. " ms"
        task.wait(0.5)
    end
end)

----------------------------------------------------------------------
-- UI framework
----------------------------------------------------------------------
local ui = new("ScreenGui", { Name = "CookiesHubUI", ResetOnSpawn = false, ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 999, Parent = guiParent })

local WIN_W, WIN_H = 560, 460
local win = new("Frame", {
    Size = UDim2.fromOffset(WIN_W, WIN_H), Position = UDim2.new(0.5, -WIN_W / 2, 0.5, -WIN_H / 2),
    BorderSizePixel = 0, ClipsDescendants = true, Parent = ui,
})
paint(win, "BackgroundColor3", "Bg")
corner(win, 10)
paint(new("UIStroke", { Transparency = 0.55, Parent = win }), "Color", "Accent")

local top = new("Frame", { Size = UDim2.new(1, 0, 0, 40), BackgroundTransparency = 1, Parent = win })
paint(new("Frame", { Size = UDim2.fromOffset(4, 16), Position = UDim2.fromOffset(14, 12), BorderSizePixel = 0, Parent = top }), "BackgroundColor3", "Accent")
paint(new("TextLabel", {
    Text = "COOKIES HUB  |  KUKIRIN LIFE", Font = Enum.Font.GothamBlack, TextSize = 14,
    BackgroundTransparency = 1, Position = UDim2.fromOffset(26, 0), Size = UDim2.new(0, 320, 1, 0),
    TextXAlignment = Enum.TextXAlignment.Left, Parent = top,
}), "TextColor3", "Text")
local keyHint = paint(new("TextLabel", {
    Font = Enum.Font.Gotham, TextSize = 11, BackgroundTransparency = 1,
    Position = UDim2.new(1, -200, 0, 0), Size = UDim2.new(0, 126, 1, 0),
    TextXAlignment = Enum.TextXAlignment.Right, Parent = top,
}), "TextColor3", "Sub")

local function topButton(text, x, role)
    local b = new("TextButton", {
        Text = text, Font = Enum.Font.GothamBold, TextSize = 16, AutoButtonColor = false,
        Size = UDim2.fromOffset(26, 26), Position = UDim2.new(1, x, 0, 7), Parent = top,
    })
    paint(b, "BackgroundColor3", role)
    paint(b, "TextColor3", "Text")
    corner(b, 6)
    return b
end
local minBtn   = topButton("–", -64, "Row")
local closeBtn = topButton("×", -34, "Accent")

local body = new("Frame", { Position = UDim2.fromOffset(0, 40), Size = UDim2.new(1, 0, 1, -40), BackgroundTransparency = 1, Parent = win })
local sidebar = new("Frame", { Position = UDim2.fromOffset(10, 0), Size = UDim2.new(0, 124, 1, -10), BorderSizePixel = 0, Parent = body })
paint(sidebar, "BackgroundColor3", "Panel")
corner(sidebar, 8)
new("UIListLayout", { Padding = UDim.new(0, 3), SortOrder = Enum.SortOrder.LayoutOrder, Parent = sidebar })
new("UIPadding", { PaddingTop = UDim.new(0, 6), PaddingLeft = UDim.new(0, 6), PaddingRight = UDim.new(0, 6), Parent = sidebar })
local pages = new("Frame", { Position = UDim2.fromOffset(144, 0), Size = UDim2.new(1, -154, 1, -10), BackgroundTransparency = 1, Parent = body })

local tabs, sideOrder, currentTab, rowFrames = {}, 0, nil, {}

local function selectTab(sel)
    currentTab = sel
    for _, t in ipairs(tabs) do
        local on = t == sel
        t.page.Visible = on
        tween(t.btn, { BackgroundColor3 = on and Theme.Accent or Theme.Panel })
        t.btn.TextColor3 = on and Theme.Text or Theme.Sub
    end
end

local function SideHeader(text)
    sideOrder += 1
    paint(new("TextLabel", {
        Text = text, Font = Enum.Font.GothamBold, TextSize = 10, BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20), TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Bottom, LayoutOrder = sideOrder, Parent = sidebar,
    }), "TextColor3", "Sub")
end

local function Tab(name)
    sideOrder += 1
    local btn = new("TextButton", {
        Text = name, Font = Enum.Font.GothamBold, TextSize = 13, AutoButtonColor = false,
        Size = UDim2.new(1, 0, 0, 28), BackgroundColor3 = Theme.Panel, TextColor3 = Theme.Sub, LayoutOrder = sideOrder, Parent = sidebar,
    })
    corner(btn, 6)
    local page = new("ScrollingFrame", {
        Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1, BorderSizePixel = 0, ScrollBarThickness = 3,
        CanvasSize = UDim2.new(), AutomaticCanvasSize = Enum.AutomaticSize.Y, Visible = false, Parent = pages,
    })
    paint(page, "ScrollBarImageColor3", "Accent")
    new("UIListLayout", { Padding = UDim.new(0, 6), SortOrder = Enum.SortOrder.LayoutOrder, Parent = page })
    new("UIPadding", { PaddingRight = UDim.new(0, 8), PaddingBottom = UDim.new(0, 6), Parent = page })
    local t = { btn = btn, page = page, order = 0 }
    btn.MouseButton1Click:Connect(function() selectTab(t) end)
    table.insert(tabs, t)
    return t
end

local function row(t, h)
    t.order += 1
    local r = new("Frame", { Size = UDim2.new(1, 0, 0, h or 34), BorderSizePixel = 0, LayoutOrder = t.order, Parent = t.page })
    paint(r, "BackgroundColor3", "Row")
    corner(r, 6)
    new("UIStroke", { Color = Color3.new(1, 1, 1), Transparency = 0.94, Parent = r })
    table.insert(rowFrames, r)
    return r
end

local function rowLabel(r, text)
    return paint(new("TextLabel", {
        Text = text, Font = Enum.Font.GothamMedium, TextSize = 13, BackgroundTransparency = 1,
        Position = UDim2.fromOffset(12, 0), Size = UDim2.new(1, -24, 0, 34), TextXAlignment = Enum.TextXAlignment.Left, Parent = r,
    }), "TextColor3", "Text")
end

local function Section(t, text)
    t.order += 1
    paint(new("TextLabel", {
        Text = text:upper(), Font = Enum.Font.GothamBold, TextSize = 11, BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20), TextXAlignment = Enum.TextXAlignment.Left, TextYAlignment = Enum.TextYAlignment.Bottom,
        LayoutOrder = t.order, Parent = t.page,
    }), "TextColor3", "Accent")
end

local function Note(t, text)
    t.order += 1
    return paint(new("TextLabel", {
        Text = text, Font = Enum.Font.Gotham, TextSize = 11, BackgroundTransparency = 1, TextWrapped = true,
        Size = UDim2.new(1, 0, 0, 28), TextXAlignment = Enum.TextXAlignment.Left, LayoutOrder = t.order, Parent = t.page,
    }), "TextColor3", "Sub")
end

local function Toggle(t, text, key)
    local r = row(t)
    rowLabel(r, text)
    local sw = new("Frame", { Size = UDim2.fromOffset(38, 20), Position = UDim2.new(1, -50, 0.5, -10), BackgroundColor3 = Theme.Off, Parent = r })
    corner(sw, 10)
    local knob = new("Frame", { Size = UDim2.fromOffset(16, 16), Position = UDim2.fromOffset(2, 2), BackgroundColor3 = Color3.new(1, 1, 1), Parent = sw })
    corner(knob, 8)
    local hit = new("TextButton", { Text = "", BackgroundTransparency = 1, Size = UDim2.fromScale(1, 1), Parent = r })
    local function render()
        local on = Settings[key]
        tween(sw, { BackgroundColor3 = on and Theme.Accent or Theme.Off })
        tween(knob, { Position = on and UDim2.fromOffset(20, 2) or UDim2.fromOffset(2, 2) })
    end
    hit.MouseButton1Click:Connect(function() setSetting(key, not Settings[key]) render() end)
    render()
    table.insert(refreshers, render)
end

local function Slider(t, text, key, min, max, step, fmt)
    local r = row(t, 50)
    rowLabel(r, text)
    local value = paint(new("TextLabel", {
        Font = Enum.Font.GothamBold, TextSize = 12, BackgroundTransparency = 1,
        Position = UDim2.new(1, -112, 0, 0), Size = UDim2.fromOffset(100, 34), TextXAlignment = Enum.TextXAlignment.Right, Parent = r,
    }), "TextColor3", "Sub")
    local bar = paint(new("Frame", { Size = UDim2.new(1, -24, 0, 6), Position = UDim2.fromOffset(12, 34), BorderSizePixel = 0, Parent = r }), "BackgroundColor3", "Off")
    corner(bar, 3)
    local fill = paint(new("Frame", { Size = UDim2.fromScale(0, 1), BorderSizePixel = 0, Parent = bar }), "BackgroundColor3", "Accent")
    corner(fill, 3)
    local hit = new("TextButton", { Text = "", BackgroundTransparency = 1, Size = UDim2.new(1, 0, 0, 22), Position = UDim2.new(0, 0, 0.5, -11), Parent = bar })
    local function render()
        local v = Settings[key]
        fill.Size = UDim2.fromScale(math.clamp((v - min) / (max - min), 0, 1), 1)
        value.Text = fmt(v)
    end
    local dragging = false
    local function update(x)
        local a = math.clamp((x - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        setSetting(key, math.clamp(math.floor((min + a * (max - min)) / step + 0.5) * step, min, max))
        render()
    end
    hit.InputBegan:Connect(function(i)
        if i.UserInputType == MB1 or i.UserInputType == TOUCH then dragging = true; update(i.Position.X) end
    end)
    bind(UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == MOVE or i.UserInputType == TOUCH) then update(i.Position.X) end
    end))
    bind(UIS.InputEnded:Connect(function(i)
        if i.UserInputType == MB1 or i.UserInputType == TOUCH then dragging = false end
    end))
    render()
    table.insert(refreshers, render)
end

local function Cycle(t, text, key, options)
    local r = row(t)
    rowLabel(r, text)
    local b = new("TextButton", {
        Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false,
        Size = UDim2.fromOffset(110, 22), Position = UDim2.new(1, -120, 0.5, -11), Parent = r,
    })
    paint(b, "BackgroundColor3", "Off")
    paint(b, "TextColor3", "Text")
    corner(b, 6)
    local function render() b.Text = tostring(Settings[key]) end
    b.MouseButton1Click:Connect(function()
        local idx = table.find(options, Settings[key]) or 0
        setSetting(key, options[idx % #options + 1])
        render()
    end)
    render()
    table.insert(refreshers, render)
end

local capturingKey = false
local function Keybind(t, text, key)
    local r = row(t)
    rowLabel(r, text)
    local b = new("TextButton", {
        Font = Enum.Font.GothamBold, TextSize = 12, AutoButtonColor = false,
        Size = UDim2.fromOffset(110, 22), Position = UDim2.new(1, -120, 0.5, -11), Parent = r,
    })
    paint(b, "BackgroundColor3", "Off")
    paint(b, "TextColor3", "Text")
    corner(b, 6)
    local listening = false
    local function render() b.Text = listening and "Press a new button" or tostring(Settings[key]) end
    b.MouseButton1Click:Connect(function() listening = not listening; capturingKey = listening; render() end)
    bind(UIS.InputBegan:Connect(function(i)
        if not listening or i.UserInputType ~= Enum.UserInputType.Keyboard then return end
        listening = false
        setSetting(key, i.KeyCode.Name)
        render()
        task.defer(function() capturingKey = false end)
    end))
    render()
    table.insert(refreshers, render)
end

local function Button(t, text, role, cb)
    t.order += 1
    local b = new("TextButton", {
        Text = text, Font = Enum.Font.GothamBold, TextSize = 13, AutoButtonColor = true,
        Size = UDim2.new(1, 0, 0, 34), LayoutOrder = t.order, Parent = t.page,
    })
    paint(b, "BackgroundColor3", role)
    paint(b, "TextColor3", "Text")
    corner(b, 6)
    b.MouseButton1Click:Connect(cb)
end

local function repaint()
    for _, r in ipairs(refreshers) do r() end
    if currentTab then selectTab(currentTab) end
end

function Hub.Set(key, value)
    if Settings[key] == nil or type(Settings[key]) ~= type(value) then return end
    setSetting(key, value)
    repaint()
end

appliers.UITransparency = function(v)
    win.BackgroundTransparency = v
    sidebar.BackgroundTransparency = v
    for _, r in ipairs(rowFrames) do r.BackgroundTransparency = v end
end
appliers.ToggleKey = function(v) keyHint.Text = v .. " to hide" end
appliers.ToggleKey(Settings.ToggleKey)

local pct   = function(v) return string.format("%d%%", math.floor(v * 100 + 0.5)) end
local int   = function(v) return tostring(math.floor(v + 0.5)) end
local one   = function(v) return string.format("%.1f", v) end
local deg   = function(v) return math.floor(v + 0.5) .. "°" end
local studs = function(v) return v == 0 and "Unlimited" or (math.floor(v) .. " st") end

----------------------------------------------------------------------
-- Config
----------------------------------------------------------------------
local CFG_DIR, CFG_FILE = "CookiesHub", "CookiesHub/KukirinLife.json"
local canFiles = writefile ~= nil and readfile ~= nil and isfile ~= nil

local function applyConfigTable(tbl)
    for k, v in pairs(tbl) do
        if Settings[k] ~= nil and type(Settings[k]) == type(v) then setSetting(k, v) end
    end
    repaint()
end
local function saveConfig()
    if not canFiles then return false end
    if makefolder and isfolder and not isfolder(CFG_DIR) then makefolder(CFG_DIR) end
    writefile(CFG_FILE, HttpService:JSONEncode(Settings))
    return true
end
local function loadConfig()
    if not (canFiles and isfile(CFG_FILE)) then return false end
    local ok, tbl = pcall(HttpService.JSONDecode, HttpService, readfile(CFG_FILE))
    if not ok or type(tbl) ~= "table" then return false end
    applyConfigTable(tbl)
    return true
end

local function commas(n)
    local s = tostring(math.floor(n))
    local sign, digits = s:match("^(-?)(%d+)$")
    if not digits then return s end
    return sign .. digits:reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
end

----------------------------------------------------------------------
-- Pages
----------------------------------------------------------------------
SideHeader("MAIN")
local farmTab = Tab("Farm")
Section(farmTab, "Rewards")
Toggle(farmTab, "Auto claim quests", "AutoQuests")
Toggle(farmTab, "Auto claim achievements", "AutoAchievements")
Toggle(farmTab, "Auto daily reward", "AutoDaily")
Note(farmTab, "Claims finished quests, every achievement tier you've reached, and the daily reward.")
Section(farmTab, "Delivery")
Toggle(farmTab, "Auto delivery", "AutoDelivery")
Note(farmTab, "Takes food orders and delivers them (~$110 each, about one a minute). The wheelie farm pauses meanwhile.")
local deliveryNote = Note(farmTab, "")
Section(farmTab, "Wheelie")
Toggle(farmTab, "Auto wheelie ride", "AutoWheelie")
Note(farmTab, "Takes your ride to the wheelie area and holds a steady wheelie there. Bikes can't steer in a wheelie, so it rides straight and loops back across the area at its edge.")
Toggle(farmTab, "Quest helpers", "QuestHelpers")
Note(farmTab, "While wheelie-ing: rides one-handed for the one-hand quest and in Hard police mode for the police-time quest, only while those quests need it.")
Slider(farmTab, "Wheelie angle", "WheelieAngle", 20, 60, 1, deg)
local areaNote
local function useArea(ground, clear)
    farmAnchor, farmRadius = ground, math.min(260, clear - 60)
    if phase ~= "idle" then setPhase("idle") end -- restart the run on the new area
end
Button(farmTab, "Set wheelie area here", "Row", function()
    local seat = myDriveSeat()
    local from = (seat and seated(seat) and seat.Position) or (getRoot() and getRoot().Position)
    local g = from and groundBelow(from, 30)
    if not g then areaNote.Text = "Stand on the ground first." return end
    local clear = clearRadius(g.Position)
    if clear < 140 then
        areaNote.Text = string.format("Too cramped here (only %d studs clear) — pick a more open spot.", clear)
        return
    end
    useArea(g.Position, clear)
    areaNote.Text = string.format("Wheelie area set here (%d studs clear).", clear)
end)
Button(farmTab, "Use default wheelie area", "Row", function()
    useArea(FARM_SPOT, 320)
    areaNote.Text = "Using the default area (open field south of town)."
end)
areaNote = Note(farmTab, "Default area: open field south of town. To use your own, stand somewhere wide open and set it.")
Section(farmTab, "Rides & events")
Toggle(farmTab, "Auto buy faster rides", "AutoBuyRide")
Note(farmTab, "Buys the fastest ride you can afford that beats every ride you own (spends Cash).")
Toggle(farmTab, "Collect money rain", "MoneyRain")
Note(farmTab, "During a money rain event, steps off and grabs the drops; other farms pause meanwhile. (Event only.)")
Section(farmTab, "Session")
local statsCash = Note(farmTab, "")
local statsMore = Note(farmTab, "")
task.spawn(function()
    while not Hub.unloaded do
        local cash = tonumber(lp:GetAttribute("Cash")) or 0
        local elapsed = os.clock() - Session.startedAt
        local earned = cash - Session.startCash
        statsCash.Text = string.format("Cash $%s  ·  +$%s this session  ·  $%s/hour",
            commas(cash), commas(earned), commas(earned / math.max(elapsed, 1) * 3600))
        statsMore.Text = string.format("Level %s  ·  Quests %d  ·  Achievements %d  ·  Dailies %d  ·  Deliveries %d (+$%s)  ·  Rides bought %d",
            tostring(lp:GetAttribute("Level") or "?"), Session.quests, Session.achievements, Session.daily,
            Session.deliveries, commas(Session.deliveryCash), Session.ridesBought)
        deliveryNote.Text = Settings.AutoDelivery and deliveryStatus or ""
        task.wait(1)
    end
end)

local rideTab = Tab("Ride")
Section(rideTab, "Spawn")
-- ride templates from ReplicatedStorage.Scooters (built synchronously — no server call here, so
-- the rest of the UI always finishes building). Display name = template name minus the "Scooter" prefix.
local rideDisplays, rideNameByDisplay = {}, {}
for _, s in ipairs(RS.Scooters:GetChildren()) do
    local disp = (s.Name:gsub("^Scooter", ""))
    table.insert(rideDisplays, disp)
    rideNameByDisplay[disp] = s.Name
end
table.sort(rideDisplays)
if #rideDisplays == 0 then rideDisplays = { "G2" }; rideNameByDisplay["G2"] = "ScooterG2" end
if Settings.QuickRide == "" or not rideNameByDisplay[Settings.QuickRide] then Settings.QuickRide = rideDisplays[1] end
Cycle(rideTab, "Ride", "QuickRide", rideDisplays)
Button(rideTab, "Spawn selected ride", "Row", function()
    local name = rideNameByDisplay[Settings.QuickRide]
    if SpawnRide and name then pcall(function() SpawnRide:InvokeServer(name) end) end
end)
Button(rideTab, "Respawn current ride", "Row", function()
    if SpawnRide then pcall(function() SpawnRide:InvokeServer(myRide() and myRide():GetAttribute("TemplateName")) end) end
end)
Button(rideTab, "Sit on my ride", "Row", function()
    local seat, hum = myDriveSeat(), getHum()
    if seat and hum then
        local root = getRoot()
        if root then root.CFrame = seat.CFrame + Vector3.new(0, 1.5, 0) end
        task.wait(0.3)
        pcall(function() seat:Sit(hum) end)
    end
end)
if GoToDealership then
    Button(rideTab, "Go to dealership", "Row", function() pcall(function() GoToDealership:InvokeServer() end) end)
end
Section(rideTab, "Riding")
Slider(rideTab, "Speed boost", "RideSpeedBoost", 0, 300, 10, function(v) return v == 0 and "Off" or (math.floor(v) .. " st/s²") end)
Note(rideTab, "Extra push while you hold W / Up.")
Section(rideTab, "Police")
Toggle(rideTab, "Anti police", "AntiPolice")
Note(rideTab, "Keeps police mode on \"No Police\" (the quest helper may switch it to Hard briefly for the police quest).")

local teleportTab = Tab("Teleport")
Section(teleportTab, "Places")
-- The map streams in, so workspace.POIs only holds the spots near you; these are their real positions
local PLACES = {
    { "Dealership", Vector3.new(1313, 59.3, 28) },
    { "Halloween", Vector3.new(1265, 59.3, -6) },
    { "Tuning", Vector3.new(1409, 59.3, -57) },
    { "Delivery", Vector3.new(1420, 74.3, -597) },
    { "Skatepark", Vector3.new(2038, 124.6, 730) },
}
local listed = {}
for _, place in ipairs(PLACES) do
    listed[place[1]] = true
    Button(teleportTab, place[1], "Row", function() teleport(place[2]) end)
end
Button(teleportTab, "Wheelie area", "Row", function() teleport(farmAnchor) end)
-- any other spot the game has added (event spots etc.) that's loaded right now
local POI_FOLDER = workspace:FindFirstChild("POIs")
for _, poi in ipairs(POI_FOLDER and POI_FOLDER:GetChildren() or {}) do
    if not listed[poi.Name] then
        Button(teleportTab, poi.Name, "Row", function()
            local pos = poi.Parent and placePosition(poi)
            if pos then teleport(pos) end
        end)
    end
end
Note(teleportTab, "Teleports you (and your ride if you're on it) to the spot.")

local visualsTab = Tab("Visuals")
Section(visualsTab, "ESP")
Toggle(visualsTab, "Player ESP", "PlayerESP")
Toggle(visualsTab, "Ride ESP", "RideESP")
Toggle(visualsTab, "Police ESP", "PoliceESP")
Toggle(visualsTab, "Delivery customer ESP", "CustomerESP")
Toggle(visualsTab, "Money drop ESP", "DropESP")
Note(visualsTab, "Through walls. Ride ESP shows other players' scooters.")
Toggle(visualsTab, "Names", "ESPNames")
Toggle(visualsTab, "Distance", "ESPDistance")
Toggle(visualsTab, "Boxes", "ESPBoxes")
Slider(visualsTab, "Max distance", "ESPMaxDistance", 0, 3000, 50, studs)
Slider(visualsTab, "Player colour", "ESPPlayerColor", 0, 360, 5, deg)
Slider(visualsTab, "Ride colour", "ESPRideColor", 0, 360, 5, deg)
Section(visualsTab, "World")
Toggle(visualsTab, "Fullbright", "Fullbright")

local playerTab = Tab("Player")
Section(playerTab, "Movement")
Slider(playerTab, "WalkSpeed", "WalkSpeed", 0, 200, 1, int)
Slider(playerTab, "Jump height", "JumpHeight", 0, 100, 0.5, one)
Slider(playerTab, "Hip height", "HipHeight", 0, 20, 0.1, one)
Toggle(playerTab, "Infinite jump", "InfJump")
Toggle(playerTab, "Noclip", "Noclip")
Toggle(playerTab, "Fly", "Fly")
Slider(playerTab, "Fly speed", "FlySpeed", 10, 300, 5, int)
Note(playerTab, "Fly: WASD + Space up / Ctrl down. Use off the bike.")
Section(playerTab, "Camera")
Slider(playerTab, "FOV", "FOV", 30, 120, 1, deg)
Section(playerTab, "Tools")
Button(playerTab, "Give teleport tool", "Row", giveTeleportTool)

SideHeader("SETTINGS")
local uiTab = Tab("Interface")
Section(uiTab, "Look")
Slider(uiTab, "Transparency", "UITransparency", 0, 0.6, 0.05, pct)
Section(uiTab, "Tags")
Toggle(uiTab, "Show profile tag", "ShowProfile")
Toggle(uiTab, "Show FPS tag", "ShowFPS")
Toggle(uiTab, "Show ping tag", "ShowPing")
Section(uiTab, "Keybind")
Keybind(uiTab, "Toggle UI key", "ToggleKey")

local perfTab = Tab("Performance")
Section(perfTab, "Utility")
Toggle(perfTab, "Anti AFK", "AntiAFK")
Toggle(perfTab, "Quick interact", "QuickInteract")
Toggle(perfTab, "Hide players", "HidePlayers")
Section(perfTab, "Performance")
Toggle(perfTab, "Reduce CPU (black screen)", "BlackScreen")
if setfpscap then
    Slider(perfTab, "FPS cap", "FPSCap", 15, 240, 5, int)
else
    Note(perfTab, "FPS cap isn't supported by this executor.")
end
Toggle(perfTab, "Anti lag", "AntiLag")

local cfgTab = Tab("Config")
Section(cfgTab, "Config")
local status
if canFiles then
    Toggle(cfgTab, "Auto-load on execute", "AutoLoad")
    Button(cfgTab, "Save config", "Row", function() status.Text = saveConfig() and "Saved." or "Save failed." end)
    Button(cfgTab, "Load config", "Row", function() status.Text = loadConfig() and "Loaded." or "No saved config found." end)
else
    Note(cfgTab, "This executor can't save files; use Export instead.")
end
Button(cfgTab, "Export to clipboard", "Row", function()
    if setclipboard then setclipboard(HttpService:JSONEncode(Settings)); status.Text = "Copied to clipboard." else status.Text = "Clipboard not supported." end
end)
status = Note(cfgTab, "")
Section(cfgTab, "Script")
Button(cfgTab, "Unload", "Accent", function() Hub.Unload() end)

selectTab(farmTab)

-- Drag
do
    local dragging, dragStart, startPos
    top.InputBegan:Connect(function(i)
        if i.UserInputType == MB1 or i.UserInputType == TOUCH then
            dragging, dragStart, startPos = true, i.Position, win.Position
        end
    end)
    bind(UIS.InputChanged:Connect(function(i)
        if dragging and (i.UserInputType == MOVE or i.UserInputType == TOUCH) then
            local d = i.Position - dragStart
            win.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
        end
    end))
    bind(UIS.InputEnded:Connect(function(i)
        if i.UserInputType == MB1 or i.UserInputType == TOUCH then dragging = false end
    end))
end

local minimized = false
minBtn.MouseButton1Click:Connect(function()
    minimized = not minimized
    body.Visible = not minimized
    tween(win, { Size = UDim2.fromOffset(WIN_W, minimized and 40 or WIN_H) })
end)
closeBtn.MouseButton1Click:Connect(function() Hub.Unload() end)

bind(UIS.InputBegan:Connect(function(i, processed)
    if processed or capturingKey then return end
    local ok, key = pcall(function() return Enum.KeyCode[Settings.ToggleKey] end)
    if ok and i.KeyCode == key then ui.Enabled = not ui.Enabled end
end))

----------------------------------------------------------------------
-- Unload
----------------------------------------------------------------------
function Hub.Unload()
    if Hub.unloaded then return end
    Hub.unloaded = true
    if phase ~= "idle" then releaseRide() end
    -- undo what the quest helpers switched on
    local seat = myDriveSeat()
    if oneHandByHelper and seat and seat:GetAttribute("OneHanderActive") == true and RiderArmEvent then RiderArmEvent:FireServer() end
    if policeBefore and PoliceMode then PoliceMode:FireServer(policeBefore) end
    for _, c in ipairs(Hub.conns) do pcall(function() c:Disconnect() end) end
    local h = getHum()
    if h then
        if touched.WalkSpeed then h.WalkSpeed = Defaults.WalkSpeed end
        if touched.JumpHeight then h.JumpHeight = Defaults.JumpHeight end
        if touched.HipHeight then h.HipHeight = Defaults.HipHeight end
        if Settings.Fly then h.PlatformStand = false end
    end
    if touched.FOV then workspace.CurrentCamera.FieldOfView = Defaults.FOV end
    appliers.Noclip(false)
    appliers.QuickInteract(false)
    appliers.HidePlayers(false)
    appliers.AntiLag(false)
    appliers.Fullbright(false)
    if Settings.BlackScreen then RunService:Set3dRenderingEnabled(true) end
    if touched.FPSCap and setfpscap then setfpscap(60) end
    espFolder:Destroy()
    if tpTool then tpTool:Destroy() end
    ui:Destroy()
    tagGui:Destroy()
    if _G.CookiesHubKL == Hub then _G.CookiesHubKL = nil end
    print("[CookiesHub] Unloaded.")
end

if canFiles and isfile(CFG_FILE) then
    local ok, tbl = pcall(HttpService.JSONDecode, HttpService, readfile(CFG_FILE))
    if ok and type(tbl) == "table" and tbl.AutoLoad then applyConfigTable(tbl) end
end

print("[CookiesHub] Kukirin Life loaded. Press " .. Settings.ToggleKey .. " to hide.")
