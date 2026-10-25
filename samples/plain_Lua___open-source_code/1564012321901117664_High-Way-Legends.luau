local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua"))()

-- ================= 1 - SERVICES & REMOTES =================

local Players         = game:GetService("Players")
local RS              = game:GetService("ReplicatedStorage")
local RunService      = game:GetService("RunService")
local UIS             = game:GetService("UserInputService")
local VU              = game:GetService("VirtualUser")
local TS              = game:GetService("TeleportService")
local Lighting        = game:GetService("Lighting")

local LP              = Players.LocalPlayer
local Remotes         = RS:WaitForChild("Remotes")
local RemoteFuncs     = RS:WaitForChild("RemoteFunctions")
local DailyRewards    = RS:WaitForChild("DailyRewards")
local PlaytimeRewards = RS:WaitForChild("PlaytimeRewards")

local HitCar          = Remotes:WaitForChild("HitCar")
local RedeemCode     = RemoteFuncs:WaitForChild("RedeemCode")

-- ================= 2 - CONSTANTS =================

local VERSION         = "v7.0 final"
local TOGGLE_KEY      = Enum.KeyCode.K
local SPEED_GATE      = 40
local PAYOUT_PER_CAR  = 37
local TRAFFIC_NAME    = "TrafficHitbox"
local AFK_SCAN_RADIUS = 300
local CLUSTER_RADIUS  = 150
local MIN_CYCLE_PAUSE = 30
local MAX_CYCLE_PAUSE = 240

local CODES = { "200klikes", "1millionmembers", "8mfavorites" }

local CLUSTERS = {
    Vector3.new( 476, 10, -31253 ),
    Vector3.new(1269, 10,  21133 ),
    Vector3.new( 473, 10, -29647 ),
    Vector3.new(1268, 10,  21361 ),
    Vector3.new(2176, 10,   7589 ),
    Vector3.new(1275, 10,  20805 ),
    Vector3.new(1904, 10,  16079 ),
    Vector3.new(1206, 10,  23189 ),
}

local PAINT_PRESETS = {
    { name = "Midnight Emerald", primary = Color3.fromRGB( 12,  72,  52), secondary = Color3.fromRGB(18,18,22),    rim = Color3.fromRGB(212,175, 92), caliper = Color3.fromRGB(212,175, 92), interior = Color3.fromRGB(14,14,16) },
    { name = "Royal Crimson",    primary = Color3.fromRGB(114,  12,  28), secondary = Color3.fromRGB(12,12,14),    rim = Color3.fromRGB(212,175, 92), caliper = Color3.fromRGB(212,175, 92), interior = Color3.fromRGB(16,12,12) },
    { name = "Sapphire Ice",     primary = Color3.fromRGB( 18,  52, 120), secondary = Color3.fromRGB(12,14,20),    rim = Color3.fromRGB(200,210,230), caliper = Color3.fromRGB(240,240,245), interior = Color3.fromRGB(12,13,18) },
    { name = "Obsidian",         primary = Color3.fromRGB( 16,  16,  18), secondary = Color3.fromRGB(10,10,12),    rim = Color3.fromRGB(196,196,200), caliper = Color3.fromRGB(255, 60, 60), interior = Color3.fromRGB(14,14,14) },
    { name = "Pearl White",      primary = Color3.fromRGB(235, 238, 240), secondary = Color3.fromRGB(200,205,215), rim = Color3.fromRGB( 90, 90,  95), caliper = Color3.fromRGB( 60, 60,  65), interior = Color3.fromRGB(30,30,34) },
    { name = "Sunset Blaze",     primary = Color3.fromRGB(255, 120,  30), secondary = Color3.fromRGB(30,20,15),    rim = Color3.fromRGB(20,20,22),    caliper = Color3.fromRGB(255,200, 60), interior = Color3.fromRGB(18,14,10) },
}

local LANDMARKS = {
    { "Dealership",      Vector3.new(1897, 25, 22456) },
    { "Garage",          Vector3.new(1751, 17, 22509) },
    { "Race Spawns",     Vector3.new(1273,  9, 22962) },
    { "Race Finish",     Vector3.new(1232, 29,  2596) },
    { "City Center",     Vector3.new(2190, 153, 22421) },
    { "Spawn Rest Area", Vector3.new(1356,  7, 22848) },
    { "Tunnel 1",        Vector3.new( 971, 22, -9330) },
    { "Tunnel 3",        Vector3.new(2182, 24,  7925) },
    { "End Tunnel",     Vector3.new( 542,  6, -31279) },
    { "Bridge 1",        Vector3.new(2143, 60, 13612) },
    { "Bridge 3",        Vector3.new( 491, 60, -28409) },
}

-- ================= 3 - STATE =================

local S = {
    farm = false, hbX = 80, hbY = 30, hbZ = 120, radius = 300,
    cooldown = 2, autoCd = 2, smartFire = true, frontOnly = false,
    burst = false, adaptive = true, visual = false,

    afk = false, dwell = 2.5, pause = 90,

    orbit = false, orbitSpeed = 500, orbitRadius = 8,

    esp = false, espRadius = 300, espSpeed = false, playerEsp = false,
    fpsBoost = false, fullbright = false,

    boost = false, boostAccel = 60, boostCap = 220,
    rainbow = false, rainbowRate = 0.5,

    autoDaily = false, autoQuests = false, autoCodes = false,

    noclip = false, infJump = false, walkSpeed = 16, jumpPower = 50,
    clickTp = false, smoothTp = false, antiAfk = true,

    hornSpam = false, exhaustSpam = false, boostSounds = false,

    hits = 0, fires = 0, sessionEarn = 0, lastPayout = 0, lastPayoutAt = 0,
}

local traffic   = {}
local pending   = {}
local seenAt    = {}
local lastFire  = {}
local effCd     = {}
local burstDone = {}
local origSize  = {}
local origColor = {}
local origTrans = {}
local visBox    = {}
local espLabels = {}
local waypointList = {}
local payoutLog  = {}
local afkVisited = {}
local afkIndex   = 1
local afkPhase   = "idle"
local afkPauseUntil = 0
local afkCycleMoney = 0
local afkCycleStart = 0
local rescanning   = false
local lightingSaved = nil
local orbitAnchor  = nil
local afkOrbit     = false

-- ================= 4 - UTILITIES =================

local function safe(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then warn("[HL Hub] " .. tostring(err)) end
    return ok
end

local function notify(title, content, icon)
    safe(function() WindUI:Notify({ Title = title, Content = content, Duration = 3, Icon = icon or "info" }) end)
end

local function comma(n)
    n = math.floor(n)
    local s = tostring(math.abs(n))
    local sign = n < 0 and "-" or ""
    while true do
        local s2, k = s:gsub("^(-?%d+)(%d%d%d)", "%1,%2")
        if k == 0 then break end
        s = s2
    end
    return sign .. s
end

local function hrp()
    local c = LP.Character
    return c and c:FindFirstChild("HumanoidRootPart")
end

local function humanoid()
    local c = LP.Character
    return c and c:FindFirstChildOfClass("Humanoid")
end

local function ownedCar()
    local cc = LP:FindFirstChild("CurrentCar")
    return cc and cc.Value
end

local function seatedInOwnedCar()
    local h = humanoid()
    local car = ownedCar()
    return (h and h.SeatPart and car) and h.SeatPart:IsDescendantOf(car) or false
end

local function currentSpeed()
    local p = hrp()
    return p and p.AssemblyLinearVelocity.Magnitude or 0
end

local function flatCarLook()
    local h = humanoid()
    local seat = h and h.SeatPart
    if not seat then return nil end
    local lv = seat.CFrame.LookVector
    local flat = Vector3.new(lv.X, 0, lv.Z)
    return flat.Magnitude > 0.05 and flat.Unit or nil
end

local function connect(sig, fn)
    if typeof(STATE) == "table" and STATE.connect then return STATE.connect(sig, fn) end
    return sig:Connect(fn)
end

local function alive()
    if typeof(STATE) ~= "table" or STATE.alive == nil then return true end
    return STATE.alive()
end

-- ================= 5 - TRAFFIC REGISTRY =================

local function registerTraffic(o)
    if o:IsA("BasePart") and o.Name == TRAFFIC_NAME then
        if traffic[o] == nil then pending[#pending + 1] = o end
    end
end

for _, o in ipairs(workspace:GetDescendants()) do
    if o:IsA("BasePart") and o.Name == TRAFFIC_NAME then traffic[o] = true end
end
connect(workspace.DescendantAdded, registerTraffic)

local function releaseTraffic(o)
    traffic[o]    = nil
    seenAt[o]      = nil
    lastFire[o]    = nil
    effCd[o]       = nil
    burstDone[o]   = nil
    origSize[o]    = nil
    origColor[o]   = nil
    origTrans[o]   = nil
    afkVisited[o]  = nil
    local l = espLabels[o]
    if l then
        if l.Parent then l.Parent:Destroy() end
        espLabels[o] = nil
    end
    local b = visBox[o]
    if b then
        b:Destroy()
        visBox[o] = nil
    end
end

-- ================= 6 - ECONOMY WATCHER =================

do
    local money = LP:WaitForChild("leaderstats"):WaitForChild("Money")
    S.lastM = money.Value
    connect(money:GetPropertyChangedSignal("Value"), function()
        local d = money.Value - S.lastM
        S.lastM = money.Value
        if d > 0 then
            S.sessionEarn += d
            S.lastPayout = d
            S.lastPayoutAt = os.clock()
            payoutLog[#payoutLog + 1] = { t = os.clock(), d = d }
            if #payoutLog > 400 then table.remove(payoutLog, 1) end
        end
    end)
end

local function ratePerMinute()
    local now = os.clock()
    while #payoutLog > 0 and now - payoutLog[1].t > 60 do table.remove(payoutLog, 1) end
    local sum = 0
    for _, e in ipairs(payoutLog) do sum += e.d end
    return sum
end

-- ================= 7 - HITBOX EXPANSION (clean) =================
-- Expand ONCE on entering radius, restore FULLY on leaving.
-- Visuals are SelectionBox outlines - the part itself is never painted,
-- never made visible, never left half-restored.

local function addVisBox(o)
    if visBox[o] then return end
    local ok, box = pcall(function()
        local b = Instance.new("SelectionBox")
        b.Adornee = o
        b.Color3 = Color3.fromRGB(255, 60, 60)
        b.Transparency = 0.35
        b.LineThickness = 0.02
        b.Parent = game:GetService("CoreGui")
        return b
    end)
    if ok then visBox[o] = box end
end

local function removeVisBox(o)
    local b = visBox[o]
    if b then
        b:Destroy()
        visBox[o] = nil
    end
end

local function expandHitbox(o)
    if origSize[o] then return end
    origSize[o]  = o.Size
    origColor[o] = o.Color
    origTrans[o] = o.Transparency
    o.Size = Vector3.new(S.hbX, S.hbY, S.hbZ)
    o.CanCollide = false
    o.Transparency = 1
    if S.visual then addVisBox(o) end
end

local function restoreHitbox(o)
    if not origSize[o] then return end
    o.Size         = origSize[o]
    o.Color        = origColor[o]
    o.Transparency = origTrans[o]
    origSize[o], origColor[o], origTrans[o] = nil, nil, nil
    removeVisBox(o)
end

local function restoreAllHitboxes()
    for o in pairs(origSize) do
        if o.Parent then
            o.Size         = origSize[o]
            o.Color        = origColor[o]
            o.Transparency = origTrans[o]
        end
        origSize[o], origColor[o], origTrans[o] = nil, nil, nil
        removeVisBox(o)
    end
end

-- ================= 8 - CLEANUP =================

local function clearTrafficEsp()
    for o in pairs(espLabels) do
        local l = espLabels[o]
        if l and l.Parent then l.Parent:Destroy() end
        espLabels[o] = nil
    end
end

local function clearPlayerEsp()
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr.Character then
            local tag = plr.Character:FindFirstChild("HL_PlayerESP")
            if tag then tag:Destroy() end
        end
    end
end

local function applyLighting()
    if (S.fpsBoost or S.fullbright) and not lightingSaved then
        lightingSaved = {
            shadows    = Lighting.GlobalShadows,
            brightness = Lighting.Brightness,
            ambient    = Lighting.Ambient,
            outdoor    = Lighting.OutdoorAmbient,
            clock      = Lighting.ClockTime,
            fog        = Lighting.FogEnd,
        }
    end
    if S.fpsBoost then
        safe(function()
            Lighting.GlobalShadows = false
            for _, e in ipairs(Lighting:GetChildren()) do
                if e:IsA("PostEffect") then e.Enabled = false end
            end
        end)
    end
    if S.fullbright then
        safe(function()
            Lighting.Brightness = 2.5
            Lighting.Ambient = Color3.new(1, 1, 1)
            Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
            Lighting.ClockTime = 14
            Lighting.FogEnd = 100000
            Lighting.GlobalShadows = false
        end)
    elseif lightingSaved then
        safe(function()
            Lighting.GlobalShadows = lightingSaved.shadows
            Lighting.Brightness = lightingSaved.brightness
            Lighting.Ambient = lightingSaved.ambient
            Lighting.OutdoorAmbient = lightingSaved.outdoor
            Lighting.ClockTime = lightingSaved.clock
            Lighting.FogEnd = lightingSaved.fog
        end)
        lightingSaved = nil
    end
end

local function stopOrbit()
    orbitAnchor = nil
    local h = humanoid()
    local seat = h and h.SeatPart
    if seat then seat.AssemblyLinearVelocity = Vector3.zero end
end

local function restoreAll()
    restoreAllHitboxes()
    clearTrafficEsp()
    clearPlayerEsp()
    S.fpsBoost, S.fullbright = false, false
    applyLighting()
    stopOrbit()
end

-- ================= 9 - HEARTBEAT BUS =================

local frameTasks = {}
local function onFrame(fn)
    frameTasks[#frameTasks + 1] = fn
end

connect(RunService.Heartbeat, function(dt)
    for _, fn in ipairs(frameTasks) do fn(dt) end
end)

-- ================= 10 - CAR BOOST + HITBOX FARM =================

onFrame(function(dt)
    if S.boost then
        local h = humanoid()
        local seat = h and h.SeatPart
        if seat then
            local lv = seat.CFrame.LookVector
            local flat = Vector3.new(lv.X, 0, lv.Z)
            if flat.Magnitude > 0.05 then
                flat = flat.Unit
                local vel = seat.AssemblyLinearVelocity
                if vel:Dot(flat) > 0 and vel.Magnitude < S.boostCap then
                    seat.AssemblyLinearVelocity = vel + flat * (S.boostAccel * dt)
                end
            end
        end
    end

    if not S.farm then return end
    local p = hrp()
    if not p then return end

    local inCar   = seatedInOwnedCar()
    local canFire = inCar and (not S.smartFire or currentSpeed() >= SPEED_GATE)
    local look    = (S.frontOnly and inCar) and flatCarLook() or nil
    local now     = os.clock()
    local pos     = p.Position
    local baseCd  = S.adaptive and S.autoCd or S.cooldown

    for o in pairs(traffic) do
        if o.Parent == nil then
            releaseTraffic(o)
        else
            local off = o.Position - pos
            local d = off.Magnitude
            if d <= S.radius then
                expandHitbox(o)
                if not seenAt[o] then seenAt[o] = now end

                if canFire then
                    local allowed = true
                    if look then allowed = (off / d):Dot(look) > 0.2 end
                    if allowed and (now - (lastFire[o] or 0)) >= (effCd[o] or baseCd) then
                        lastFire[o] = now
                        S.hits += 1
                        S.fires += 1
                        if S.burst and not burstDone[o] then
                            burstDone[o] = true
                            safe(function() HitCar:FireServer(o) end)
                            safe(function() HitCar:FireServer(o) end)
                        end
                        safe(function() HitCar:FireServer(o) end)
                    end
                end
            else
                restoreHitbox(o)
            end
        end
    end
end)

-- ================= 11 - ORBIT SPEED SPOOF =================
-- Genuine circular velocity around an anchor: the server reads real
-- physics speed, the car never leaves the spot. Safety re-pin keeps
-- the car locked if physics tries to fling it.

onFrame(function()
    if not (S.orbit or afkOrbit) then
        if orbitAnchor then stopOrbit() end
        return
    end
    local h = humanoid()
    local seat = h and h.SeatPart
    local car = ownedCar()
    if not (seat and car and seatedInOwnedCar()) then
        if orbitAnchor then stopOrbit() end
        return
    end

    local p = car:GetPivot().Position
    if not orbitAnchor then orbitAnchor = p end

    -- safety: if something flung the car, snap it back
    local drift = (p - orbitAnchor).Magnitude
    if drift > 60 then
        car:PivotTo(CFrame.new(orbitAnchor))
        return
    end

    local flat = Vector3.new(orbitAnchor.X - p.X, 0, orbitAnchor.Z - p.Z)
    local r = flat.Magnitude
    if r < 0.5 then return end

    local tangent = Vector3.new(-flat.Z, 0, flat.X).Unit
    local radial = Vector3.zero
    if r > S.orbitRadius then
        radial = (flat / r) * math.min((r - S.orbitRadius) * 8, 200)
    end
    local vel = tangent * S.orbitSpeed + radial
    seat.AssemblyLinearVelocity = Vector3.new(vel.X, seat.AssemblyLinearVelocity.Y, vel.Z)
end)

-- ================= 12 - AFK CLUSTER FARM =================
-- Tours every cluster, orbits at real speed during dwell so every
-- unique-car fire passes the gate, rides out the dedup window, repeats.

task.spawn(function()
    while alive() do
        if S.afk then
            local car = ownedCar()
            if not (car and seatedInOwnedCar()) then
                afkPhase = "waiting"
                afkOrbit = false
            elseif afkPhase == "paused" then
                if os.clock() >= afkPauseUntil then
                    afkPhase = "running"
                    afkIndex = 1
                    afkVisited = {}
                    afkCycleStart = LP.leaderstats.Money.Value
                end
            else
                afkPhase = "running"
                local cluster = CLUSTERS[afkIndex]
                if cluster then
                    car:PivotTo(CFrame.new(cluster + Vector3.new(0, 2.5, 0)))
                    orbitAnchor = nil
                    afkOrbit = true
                    local t0 = os.clock()
                    while os.clock() - t0 < S.dwell and S.afk and alive() do
                        local pos = car:GetPivot().Position
                        for o in pairs(traffic) do
                            if o.Parent and not afkVisited[o]
                                and (o.Position - pos).Magnitude <= AFK_SCAN_RADIUS then
                                afkVisited[o] = true
                                S.hits += 1
                                S.fires += 1
                                safe(function() HitCar:FireServer(o) end)
                            end
                        end
                        task.wait(0.1)
                    end
                    afkIndex += 1
                else
                    afkOrbit = false
                    stopOrbit()
                    local earned = LP.leaderstats.Money.Value - afkCycleStart
                    local n = 0
                    for _ in pairs(afkVisited) do n += 1 end
                    afkCycleMoney = earned
                    notify("AFK cycle complete",
                        string.format("+$%s from %d unique cars", comma(earned), n), "banknote")
                    afkPhase = "paused"
                    afkPauseUntil = os.clock() + S.pause
                end
            end
        elseif afkPhase ~= "idle" then
            afkPhase = "idle"
            afkOrbit = false
            stopOrbit()
        end
        task.wait(0.4)
    end
end)

-- ================= 13 - ESP =================

task.spawn(function()
    while alive() do
        local me = hrp()
        local myPos = me and me.Position

        if S.esp and myPos then
            for o in pairs(traffic) do
                if o.Parent == nil then
                    releaseTraffic(o)
                else
                    local d = (o.Position - myPos).Magnitude
                    if d <= S.espRadius then
                        local l = espLabels[o]
                        if not l or l.Parent == nil then
                            local bg = Instance.new("BillboardGui")
                            bg.Size = UDim2.new(0, 130, 0, 26)
                            bg.StudsOffset = Vector3.new(0, 4, 0)
                            bg.AlwaysOnTop = true
                            bg.Parent = o
                            l = Instance.new("TextLabel")
                            l.Size = UDim2.new(1, 0, 1, 0)
                            l.BackgroundTransparency = 1
                            l.TextStrokeTransparency = 0.3
                            l.TextSize = 13
                            l.Font = Enum.Font.GothamBold
                            l.Parent = bg
                            espLabels[o] = l
                        end
                        if seenAt[o] and (os.clock() - seenAt[o]) < 3 then
                            l.TextColor3 = Color3.new(1, 1, 1)
                            l.Text = "NEW - " .. math.floor(d) .. "m"
                        else
                            local t = math.clamp(d / S.espRadius, 0, 1)
                            l.TextColor3 = Color3.fromRGB(255 * t, 255 * (1 - t), 60)
                            local text = math.floor(d) .. "m"
                            if S.espSpeed then
                                local v = math.floor(o.AssemblyLinearVelocity.Magnitude * 3.6)
                                if v > 5 then text = text .. " - " .. v .. "km/h" end
                            end
                            l.Text = text
                        end
                    else
                        local l = espLabels[o]
                        if l then
                            if l.Parent then l.Parent:Destroy() end
                            espLabels[o] = nil
                        end
                    end
                end
            end
        else
            clearTrafficEsp()
        end

        if S.playerEsp and myPos then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local c = plr.Character
                    local h = c:FindFirstChildOfClass("Humanoid")
                    local root = c:FindFirstChild("HumanoidRootPart")
                    if h and root and h.Health > 0 then
                        local tag = c:FindFirstChild("HL_PlayerESP")
                        if not tag then
                            tag = Instance.new("BillboardGui")
                            tag.Name = "HL_PlayerESP"
                            tag.Size = UDim2.new(0, 170, 0, 28)
                            tag.StudsOffset = Vector3.new(0, 3.2, 0)
                            tag.AlwaysOnTop = true
                            tag.Parent = c
                            local tl = Instance.new("TextLabel")
                            tl.Size = UDim2.new(1, 0, 1, 0)
                            tl.BackgroundTransparency = 1
                            tl.TextColor3 = Color3.fromRGB(90, 170, 255)
                            tl.TextStrokeTransparency = 0.3
                            tl.TextSize = 13
                            tl.Font = Enum.Font.GothamBold
                            tl.Parent = tag
                        end
                        local hp = math.floor(h.Health / math.max(h.MaxHealth, 1) * 100)
                        tag.TextLabel.Text = plr.Name .. " - " .. hp .. "% - "
                            .. math.floor((root.Position - myPos).Magnitude) .. "m"
                    end
                end
            end
        else
            clearPlayerEsp()
        end

        task.wait(0.2)
    end
end)

-- ================= 14 - VEHICLE FX =================

task.spawn(function()
    while alive() do
        if S.rainbow and seatedInOwnedCar() then
            local hue = (os.clock() * 0.4) % 1
            safe(function() Remotes.ChangeColor:FireServer("Primary", Color3.fromHSV(hue, 0.75, 1)) end)
            safe(function() Remotes.ChangeColor:FireServer("Rim", Color3.fromHSV((hue + 0.33) % 1, 0.65, 0.95)) end)
        end
        task.wait(math.max(S.rainbowRate, 0.2))
    end
end)

task.spawn(function()
    while alive() do
        if seatedInOwnedCar() then
            local h = humanoid()
            local seat = h and h.SeatPart
            if S.hornSpam and seat then
                safe(function() Remotes.HornEvent:FireServer(true) end)
                task.wait(0.1)
                safe(function() Remotes.HornEvent:FireServer(false) end)
            end
            if S.exhaustSpam then
                safe(function() Remotes.ExhaustHandler:FireServer("Flames", true) end)
                task.wait(0.2)
                safe(function() Remotes.ExhaustHandler:FireServer("Flames", false) end)
            end
            if S.boostSounds and seat then
                safe(function() Remotes.BoostSounds:FireServer(seat, "play", {}) end)
            end
        end
        task.wait(0.5)
    end
end)

-- ================= 15 - REWARDS =================

local claimedThisSession = {}

local function claimQuests()
    local n = 0
    for _, folder in ipairs(LP:GetChildren()) do
        if folder:IsA("Folder") and folder.Name:find("Quests") then
            local remote = folder.Name:lower():find("weekly")
                and Remotes.ClaimWeeklyReward or Remotes.ClaimDailyReward
            for _, quest in ipairs(folder:GetChildren()) do
                local prog = quest:FindFirstChild("Progress")
                local goal = quest:FindFirstChild("Goal")
                local done = quest:FindFirstChild("Claimed")
                if prog and goal and prog.Value >= goal.Value
                    and not (done and done.Value)
                    and not claimedThisSession[quest.Name] then
                    claimedThisSession[quest.Name] = true
                    safe(function() remote:FireServer(quest.Name) end)
                    n += 1
                end
            end
        end
    end
    return n
end

local function claimEverything()
    safe(function() DailyRewards.Claim:InvokeServer() end)
    safe(function() PlaytimeRewards.Claim:InvokeServer() end)
    for tier = 1, 7 do safe(function() PlaytimeRewards.Claim:InvokeServer(tier) end) end
    local quests = claimQuests()
    for _, c in ipairs(CODES) do safe(function() RedeemCode:InvokeServer(c) end) end
    return quests
end

task.spawn(function()
    while alive() do
        if S.autoDaily then
            safe(function() DailyRewards.Claim:InvokeServer() end)
            safe(function() PlaytimeRewards.Claim:InvokeServer() end)
            for tier = 1, 7 do safe(function() PlaytimeRewards.Claim:InvokeServer(tier) end) end
        end
        if S.autoQuests then claimQuests() end
        if S.autoCodes then
            for _, c in ipairs(CODES) do safe(function() RedeemCode:InvokeServer(c) end) end
        end
        task.wait(20)
    end
end)

-- ================= 16 - MOVEMENT =================

connect(RunService.Stepped, function()
    if S.noclip then
        local c = LP.Character
        if c then
            for _, part in ipairs(c:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = false end
            end
        end
    end
end)

connect(UIS.JumpRequest, function()
    if S.infJump then
        local h = humanoid()
        if h then h:ChangeState(Enum.HumanoidStateType.Jumping) end
    end
end)

connect(LP.CharacterAdded, function(c)
    task.wait(0.5)
    local h = c:FindFirstChildOfClass("Humanoid")
    if h then
        if S.walkSpeed ~= 16 then h.WalkSpeed = S.walkSpeed end
        if S.jumpPower ~= 50 then h.JumpPower = S.jumpPower end
    end
end)

task.spawn(function()
    while alive() do
        local h = humanoid()
        if h then
            if S.walkSpeed ~= 16 then h.WalkSpeed = S.walkSpeed end
            if S.jumpPower ~= 50 then h.JumpPower = S.jumpPower end
        end
        task.wait(0.5)
    end
end)

-- ================= 17 - TELEPORT =================

local function doTP(pos)
    local p = hrp()
    if not p then return end
    local target = CFrame.new(pos + Vector3.new(0, 6, 0))
    local car = seatedInOwnedCar() and ownedCar()

    if car then
        local start = car:GetPivot()
        if S.smoothTp then
            for i = 1, 10 do
                car:PivotTo(start:Lerp(target, i / 10))
                task.wait(0.03)
            end
        else
            car:PivotTo(target)
        end
    else
        local start = p.CFrame
        if S.smoothTp then
            for i = 1, 10 do
                p.CFrame = start:Lerp(target, i / 10)
                task.wait(0.03)
            end
        else
            p.CFrame = target
        end
    end
end

connect(UIS.InputBegan, function(input, processed)
    if processed or not S.clickTp then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1
        and UIS:IsKeyDown(Enum.KeyCode.LeftControl) then
        local hit = LP:GetMouse().Hit
        if hit then doTP(hit.Position) end
    end
end)

-- ================= 18 - ANTI-AFK =================

connect(LP.Idled, function()
    if S.antiAfk then
        VU:CaptureController()
        VU:ClickButton2(Vector2.new())
    end
end)

-- ================= 19 - TELEMETRY =================

local statsPara, afkPara, clusterPara

task.spawn(function()
    local lastFires = 0
    local adaptTick = 0
    local pruneTick = 0

    while alive() do
        for i = #pending, 1, -1 do
            traffic[pending[i]] = true
            pending[i] = nil
        end

        pruneTick += 1
        if pruneTick >= 5 then
            pruneTick = 0
            for o in pairs(traffic) do
                if o.Parent == nil then releaseTraffic(o) end
            end
        end

        local rate = ratePerMinute()

        -- adaptive cooldown: only tunes while genuinely moving,
        -- clamped to a sane band so the farm never goes dead
        adaptTick += 1
        if adaptTick >= 5 then
            adaptTick = 0
            if S.adaptive and S.farm and seatedInOwnedCar()
                and currentSpeed() >= SPEED_GATE then
                if rate < 300 and S.autoCd < 4 then
                    S.autoCd = math.min(4, S.autoCd + 0.5)
                elseif rate > 2500 and S.autoCd > 0.8 then
                    S.autoCd = math.max(0.8, S.autoCd - 0.4)
                end
            end
        end

        local firesPerSec = S.fires - lastFires
        lastFires = S.fires

        if statsPara then
            safe(function()
                statsPara:SetTitle("Live Stats")
                statsPara:SetDesc(table.concat({
                    string.format("Money  $%s   |   $%s/min",
                        comma(LP.leaderstats.Money.Value), comma(rate)),
                    string.format("Session  +$%s   |   last hit $%s",
                        comma(S.sessionEarn), comma(S.lastPayout)),
                    string.format("Fires  %d/s (%d total)  |  speed %d  |  %s",
                        firesPerSec, S.fires, currentSpeed(),
                        seatedInOwnedCar() and "in car" or "on foot"),
                }, "\n"))
            end)
        end

        if afkPara and S.afk then
            local statusText
            if afkPhase == "running" then
                statusText = string.format("Visiting cluster %d/%d", math.min(afkIndex, #CLUSTERS), #CLUSTERS)
            elseif afkPhase == "paused" then
                statusText = string.format("Dedup cooldown - %ds left",
                    math.max(0, math.ceil(afkPauseUntil - os.clock())))
            elseif afkPhase == "waiting" then
                statusText = "Sit in your car to begin"
            else
                statusText = "Starting..."
            end
            safe(function()
                afkPara:SetTitle("AFK Farm")
                afkPara:SetDesc(statusText
                    .. string.format("\nLast cycle  +$%s", comma(afkCycleMoney)))
            end)
        end

        task.wait(1)
    end
end)

-- ================= 20 - UI CONSTRUCTION =================

pcall(function() WindUI:SetParent(game:GetService("CoreGui")) end)
pcall(function() WindUI:SetNotificationLower(true) end)

local Window = WindUI:CreateWindow({
    Title       = "Highway Legends Hub",
    Icon        = "rocket",
    Author      = VERSION,
    Folder      = "HighwayLegendsHub",
    Size        = UDim2.fromOffset(600, 540),
    Theme       = "Dark",
    Transparent = true,
    ToggleKey   = TOGGLE_KEY,
    AutoScale   = true,
    SideBarWidth = 190,
    HideSearchBar = true,
    NewElements = true,
    Background  = WindUI:Gradient({
        ["0"]   = { Color = Color3.fromHex("#0b1020"), Transparency = 0.02 },
        ["100"] = { Color = Color3.fromHex("#131a36"), Transparency = 0.06 },
    }, { Rotation = 90 }),
    User = { Enabled = true, Anonymous = true },
})

local ui = {}

local function sect(tab, title)
    local ok, s = pcall(function() return tab:Section({ Title = title, Opened = true }) end)
    return (ok and s) and s or tab
end

-- ------ TAB: FARM ------

local TabFarm = Window:Tab({ Title = "Farm", Icon = "zap", IconColor = Color3.fromHex("#ffd23f") })
local FM = sect(TabFarm, "One-Click")

FM:Toggle({
    Title = "FULL AUTO",
    Desc = "Everything money-related in one switch: farm + orbit + anti-AFK. Sit in your car, park near traffic, flip this, walk away.",
    Icon = "rocket",
    Value = false, Flag = "master_auto",
    Callback = function(v)
        S.farm  = v
        S.orbit = v
        S.antiAfk = v
        S.autoCd = S.cooldown
        if not v then
            restoreAllHitboxes()
            stopOrbit()
        end
        notify("Full Auto", v and "Engaged - go AFK" or "Disabled", "rocket")
    end,
})

local FS = sect(TabFarm, "Hitbox Farm")

statsPara = FS:Paragraph({ Title = "Live Stats", Desc = "warming up..." })

FS:Toggle({
    Title = "Hitbox Farm", Desc = "Fire HitCar on traffic in radius",
    Icon = "zap", Value = false, Flag = "farm_master",
    Callback = function(v)
        S.farm = v
        S.autoCd = S.cooldown
        if not v then restoreAllHitboxes() end
    end,
})
FS:Toggle({
    Title = "Smart Fire", Desc = "Only fire above 40 speed (the server's rule)",
    Value = true, Flag = "farm_smart", Callback = function(v) S.smartFire = v end,
})
FS:Toggle({
    Title = "Front Only", Desc = "Skip cars behind you",
    Value = false, Flag = "farm_front", Callback = function(v) S.frontOnly = v end,
})
FS:Toggle({
    Title = "New-car Burst", Desc = "Triple-fire freshly spotted cars",
    Value = false, Flag = "farm_burst", Callback = function(v) S.burst = v end,
})
FS:Toggle({
    Title = "Adaptive Cooldown", Desc = "Auto-tunes fire rate while driving (0.8-4s band)",
    Value = true, Flag = "farm_adaptive", Callback = function(v) S.adaptive = v end,
})

local FT = sect(TabFarm, "Tuning")

FT:Slider({ Title = "Width X",  Value = { Min = 20, Max = 600, Default = 100 }, Flag = "hb_x", Callback = function(v) S.hbX = v end })
FT:Slider({ Title = "Height Y", Value = { Min = 10, Max = 200, Default = 45 }, Flag = "hb_y", Callback = function(v) S.hbY = v end })
FT:Slider({ Title = "Length Z", Value = { Min = 20, Max = 800, Default = 150 }, Flag = "hb_z", Callback = function(v) S.hbZ = v end })
ui.radius   = FT:Slider({ Title = "Detection Radius", Value = { Min = 40, Max = 900, Default = 300 }, Flag = "hb_radius", Callback = function(v) S.radius = v end })
ui.cooldown = FT:Slider({ Title = "Re-hit Cooldown (s)", Desc = "Per car, lower = more calls",
    Value = { Min = 1, Max = 8, Default = 2 }, Flag = "hb_cd", Callback = function(v) S.cooldown, S.autoCd = v, v end })
FT:Toggle({ Title = "Hitbox Visual", Desc = "Wireframe outlines on expanded hitboxes",
    Value = false, Flag = "hb_vis", Callback = function(v)
        S.visual = v
        if v then
            for o in pairs(origSize) do addVisBox(o) end
        else
            for o in pairs(visBox) do removeVisBox(o) end
        end
    end })

FS:Dropdown({
    Title = "Profile",
    Values = { "Safe", "Balanced", "Insane" },
    Value = "Balanced",
    Callback = function(sel)
        local presets = {
            Safe     = { radius = 150, cd = 4, burst = false },
            Balanced = { radius = 300, cd = 2, burst = false },
            Insane   = { radius = 500, cd = 1, burst = true  },
        }
        local p = presets[sel]
        if p then
            S.radius, S.cooldown, S.autoCd, S.burst = p.radius, p.cd, p.cd, p.burst
            safe(function() ui.radius:Set(p.radius) end)
            safe(function() ui.cooldown:Set(p.cd) end)
            notify("Profile", sel .. " applied", "zap")
        end
    end,
})

local FO = sect(TabFarm, "Speed Spoof - fast standing still")

FO:Toggle({
    Title = "Orbit Speed Spoof",
    Desc = "Spin your car in a tight circle at real speed. Server sees genuine velocity, you never leave the spot.",
    Icon = "orbit",
    Value = false, Flag = "spoof_orbit",
    Callback = function(v)
        S.orbit = v
        if not v then stopOrbit() end
    end,
})
ui.orbitSpeed = FO:Slider({ Title = "Spoof Speed", Desc = "studs/s the server sees",
    Value = { Min = 40, Max = 800, Default = 500 }, Flag = "spoof_speed",
    Callback = function(v) S.orbitSpeed = v end })
FO:Slider({ Title = "Circle Radius", Desc = "How wide the spin is - smaller = more still",
    Value = { Min = 3, Max = 30, Default = 8 }, Flag = "spoof_radius",
    Callback = function(v) S.orbitRadius = v end })

-- ------ TAB: AFK ------

local TabAfk = Window:Tab({ Title = "AFK", Icon = "moon", IconColor = Color3.fromHex("#a78bfa") })
local AS = sect(TabAfk, "Cluster Farm - zero input")

afkPara = AS:Paragraph({ Title = "AFK Farm", Desc = "idle" })

AS:Toggle({
    Title = "AFK Cluster Farm",
    Desc = "Sit in your car. The hub tours every traffic cluster, orbits at full speed during each stop, pays once per car, waits out the cooldown, repeats forever.",
    Icon = "moon", Value = false, Flag = "afk_master",
    Callback = function(v) S.afk = v end,
})
AS:Slider({ Title = "Dwell per cluster (s)", Value = { Min = 1, Max = 8, Default = 2.5, Step = 0.5 },
    Flag = "afk_dwell", Callback = function(v) S.dwell = v end })
AS:Slider({ Title = "Pause between cycles (s)", Desc = "Roughly the server's dedup window - 90s is safe",
    Value = { Min = MIN_CYCLE_PAUSE, Max = MAX_CYCLE_PAUSE, Default = 90 },
    Flag = "afk_pause", Callback = function(v) S.pause = v end })

AS:Button({
    Title = "Teleport to Densest Cluster", Icon = "map-pin",
    Callback = function()
        local car = ownedCar()
        if car then
            car:PivotTo(CFrame.new(CLUSTERS[1] + Vector3.new(0, 2.5, 0)))
            notify("AFK", "Dropped at the EndTunnel mega-cluster", "map-pin")
        end
    end,
})

local AR = sect(TabAfk, "Cluster Map")

local function describeClusters()
    local lines = {}
    for i, c in ipairs(CLUSTERS) do
        lines[i] = string.format("#%d  %d, %d, %d", i, c.X, c.Y, c.Z)
    end
    return table.concat(lines, "\n")
end

clusterPara = AR:Paragraph({ Title = "Clusters", Desc = describeClusters() })

AR:Button({
    Title = "Rescan Clusters", Desc = "Re-map traffic density after respawns", Icon = "scan",
    Callback = function()
        if rescanning then return end
        rescanning = true
        notify("Rescan", "Scanning traffic density...", "scan")
        task.spawn(function()
            local all = {}
            for o in pairs(traffic) do
                if o.Parent and o.Position.Y > -50 then all[#all + 1] = o end
            end
            local used, found = {}, {}
            for _ = 1, 8 do
                local best, bestCount = nil, 2
                local checked = 0
                for _, a in ipairs(all) do
                    if not used[a] then
                        local count = 0
                        for _, b in ipairs(all) do
                            if not used[b] and (b.Position - a.Position).Magnitude <= CLUSTER_RADIUS then
                                count += 1
                            end
                        end
                        if count > bestCount then bestCount, best = count, a end
                        checked += 1
                        if checked % 100 == 0 then task.wait() end
                    end
                end
                if not best then break end
                local sum, n = Vector3.zero, 0
                for _, b in ipairs(all) do
                    if not used[b] and (b.Position - best.Position).Magnitude <= CLUSTER_RADIUS then
                        used[b] = true
                        sum += b.Position
                        n += 1
                    end
                end
                found[#found + 1] = sum / n
                task.wait()
            end
            if #found > 0 and alive() then
                CLUSTERS = found
                afkIndex = math.min(afkIndex, #CLUSTERS)
                safe(function()
                    clusterPara:SetTitle("Clusters")
                    clusterPara:SetDesc(describeClusters())
                end)
                notify("Rescan", #found .. " clusters mapped", "scan")
            end
            rescanning = false
        end)
    end,
})

-- ------ TAB: VISUALS ------

local TabVis = Window:Tab({ Title = "Visuals", Icon = "eye", IconColor = Color3.fromHex("#7dd87d") })
local VS = sect(TabVis, "ESP")

VS:Toggle({ Title = "Traffic ESP", Desc = "Distance-colored tags, white = fresh money",
    Value = false, Flag = "esp_traffic", Callback = function(v) S.esp = v end })
VS:Slider({ Title = "ESP Radius", Value = { Min = 50, Max = 600, Default = 300 }, Flag = "esp_radius",
    Callback = function(v) S.espRadius = v end })
VS:Toggle({ Title = "Traffic Speed on Tags", Value = false, Flag = "esp_speed",
    Callback = function(v) S.espSpeed = v end })
VS:Toggle({ Title = "Player ESP", Desc = "Name, HP, distance", Value = false, Flag = "esp_player",
    Callback = function(v) S.playerEsp = v end })

local VG = sect(TabVis, "Client Graphics")

VG:Toggle({ Title = "FPS Boost", Desc = "Shadows and post-effects off", Value = false, Flag = "gfx_fps",
    Callback = function(v) S.fpsBoost = v; applyLighting() end })
VG:Toggle({ Title = "Fullbright", Desc = "Daylight at midnight", Value = false, Flag = "gfx_bright",
    Callback = function(v) S.fullbright = v; applyLighting() end })

-- ------ TAB: REWARDS ------

local TabRew = Window:Tab({ Title = "Rewards", Icon = "gift", IconColor = Color3.fromHex("#ff9b54") })
local RA = sect(TabRew, "Automation")

RA:Toggle({ Title = "Auto Daily + Playtime", Value = false, Flag = "rw_daily", Callback = function(v) S.autoDaily = v end })
RA:Toggle({ Title = "Auto Quest Claims", Value = false, Flag = "rw_quests", Callback = function(v) S.autoQuests = v end })
RA:Toggle({ Title = "Auto Code Redeem", Value = false, Flag = "rw_codes", Callback = function(v) S.autoCodes = v end })

local RM = sect(TabRew, "Manual")

RM:Button({
    Title = "Claim Everything Now", Icon = "check",
    Callback = function()
        local quests = claimEverything()
        notify("Rewards", "All claims fired - " .. quests .. " quests", "check")
    end,
})
RM:Button({
    Title = "Redeem All Codes", Icon = "ticket",
    Callback = function()
        for _, c in ipairs(CODES) do safe(function() RedeemCode:InvokeServer(c) end) end
        notify("Codes", "Redeemed", "ticket")
    end,
})

-- ------ TAB: TELEPORT ------

local TabTP = Window:Tab({ Title = "Teleport", Icon = "map-pin", IconColor = Color3.fromHex("#a78bfa") })
local TL = sect(TabTP, "Landmarks")

for _, spot in ipairs(LANDMARKS) do
    TL:Button({ Title = spot[1], Callback = function() doTP(spot[2]) end })
end

local TW = sect(TabTP, "Waypoints")

local wpDrop = nil
local function rebuildWpDropdown()
    if wpDrop then safe(function() wpDrop:Destroy() end) end
    local names = {}
    for _, w in ipairs(waypointList) do names[#names + 1] = w.name end
    if #names == 0 then names[1] = "(none saved)" end
    wpDrop = TW:Dropdown({
        Title = "Go to Waypoint",
        Values = names,
        AllowNone = true,
        Callback = function(sel)
            for _, w in ipairs(waypointList) do
                if w.name == sel then doTP(w.pos) end
            end
        end,
    })
end

TW:Button({
    Title = "Save Waypoint Here", Icon = "map-pin-plus",
    Callback = function()
        local p = hrp()
        if p then
            local name = "WP" .. (#waypointList + 1)
            waypointList[#waypointList + 1] = { name = name, pos = p.Position }
            rebuildWpDropdown()
            notify("Waypoint", name .. " saved", "map-pin")
        end
    end,
})
rebuildWpDropdown()

TW:Toggle({ Title = "Smooth Teleport", Desc = "Glide instead of blink", Value = false, Flag = "tp_smooth",
    Callback = function(v) S.smoothTp = v end })
TW:Toggle({ Title = "Ctrl + Click Teleport", Value = false, Flag = "tp_click",
    Callback = function(v) S.clickTp = v end })

-- ------ TAB: VEHICLE ------

local TabCar = Window:Tab({ Title = "Vehicle", Icon = "car", IconColor = Color3.fromHex("#4ade80") })
local CV = sect(TabCar, "Speed")

CV:Toggle({ Title = "Car Speed Boost", Desc = "Extra forward thrust while driving", Value = false, Flag = "car_boost",
    Callback = function(v) S.boost = v end })
CV:Slider({ Title = "Boost Power", Desc = "Acceleration studs/s2", Value = { Min = 10, Max = 250, Default = 60 },
    Flag = "car_power", Callback = function(v) S.boostAccel = v end })
CV:Slider({ Title = "Boost Speed Cap", Value = { Min = 80, Max = 400, Default = 220 }, Flag = "car_cap",
    Callback = function(v) S.boostCap = v end })

local CP = sect(TabCar, "Paint - curated presets")

for _, preset in ipairs(PAINT_PRESETS) do
    CP:Button({
        Title = preset.name,
        Callback = function()
            task.spawn(function()
                safe(function() Remotes.ChangeColor:FireServer("Primary",   preset.primary) end)
                task.wait(0.25)
                safe(function() Remotes.ChangeColor:FireServer("Secondary", preset.secondary) end)
                task.wait(0.25)
                safe(function() Remotes.ChangeColor:FireServer("Rim",       preset.rim) end)
                task.wait(0.25)
                safe(function() Remotes.ChangeColor:FireServer("Caliper",   preset.caliper) end)
                task.wait(0.25)
                safe(function() Remotes.ChangeColor:FireServer("Interior",  preset.interior) end)
            end)
            notify("Paint", preset.name .. " applied", "paintbrush")
        end,
    })
end

CP:Toggle({ Title = "Rainbow Paint", Desc = "Body cycles hue, rims follow 120 degrees behind",
    Value = false, Flag = "paint_rainbow", Callback = function(v) S.rainbow = v end })
CP:Slider({ Title = "Rainbow Rate", Desc = "Seconds per color", Value = { Min = 0.2, Max = 2, Default = 0.5, Step = 0.1 },
    Flag = "paint_rate", Callback = function(v) S.rainbowRate = v end })

local CF = sect(TabCar, "Plates & FX")

CF:Input({
    Title = "License Plate", Placeholder = "7 characters max",
    Callback = function(v)
        if v and #v > 0 then
            safe(function() Remotes.LicensePlateText:FireServer(v:sub(1, 7)) end)
            notify("Plate", v:sub(1, 7), "hash")
        end
    end,
})
CF:Toggle({ Title = "Horn Spam", Value = false, Flag = "fx_horn", Callback = function(v) S.hornSpam = v end })
CF:Toggle({ Title = "Exhaust Spam", Value = false, Flag = "fx_exhaust", Callback = function(v) S.exhaustSpam = v end })
CF:Toggle({ Title = "Boost Sounds", Value = false, Flag = "fx_boost", Callback = function(v) S.boostSounds = v end })
CF:Button({ Title = "Toggle Headlights", Callback = function() safe(function() Remotes.LightEvent:FireServer("Headlights") end) end })
CF:Button({ Title = "Toggle Hazards",    Callback = function() safe(function() Remotes.LightEvent:FireServer("Hazards") end) end })
CF:Button({ Title = "Exhaust Flames ON",  Callback = function() safe(function() Remotes.ExhaustHandler:FireServer("Flames", true) end) end })
CF:Button({ Title = "Exhaust Flames OFF", Callback = function() safe(function() Remotes.ExhaustHandler:FireServer("Flames", false) end) end })

-- ------ TAB: MISC ------

local TabMisc = Window:Tab({ Title = "Misc", Icon = "ellipsis", IconColor = Color3.fromHex("#94a3b8") })
local MM = sect(TabMisc, "Movement")

MM:Toggle({ Title = "Noclip", Value = false, Flag = "mv_noclip", Callback = function(v) S.noclip = v end })
MM:Toggle({ Title = "Infinite Jump", Value = false, Flag = "mv_jump", Callback = function(v) S.infJump = v end })
MM:Slider({ Title = "Walk Speed", Value = { Min = 16, Max = 200, Default = 16 }, Flag = "mv_speed",
    Callback = function(v)
        S.walkSpeed = v
        local h = humanoid()
        if h then h.WalkSpeed = v end
    end })
MM:Slider({ Title = "Jump Power", Value = { Min = 50, Max = 200, Default = 50 }, Flag = "mv_jp",
    Callback = function(v)
        S.jumpPower = v
        local h = humanoid()
        if h then h.JumpPower = v end
    end })

local MU = sect(TabMisc, "Utility")

MU:Toggle({ Title = "Anti-AFK", Desc = "Silent, keeps you connected forever", Value = true, Flag = "ut_afk",
    Callback = function(v) S.antiAfk = v end })
MU:Button({
    Title = "Restore Everything", Desc = "Undo hitboxes, ESP, lighting, orbit", Icon = "rotate-ccw",
    Callback = function()
        restoreAll()
        notify("Restored", "World returned to vanilla", "rotate-ccw")
    end,
})
MU:Button({ Title = "Rejoin Server", Icon = "refresh-cw", Callback = function() TS:Teleport(game.PlaceId, LP) end })

TabMisc:Paragraph({
    Title = "Hotkeys & Info",
    Desc = "K - toggle menu\nCtrl+Click - teleport (enable in Teleport tab)\nFULL AUTO on Farm tab is all you need.\nSettings save between sessions.",
})

-- ================= 21 - BOOTSTRAP =================

if typeof(STATE) == "table" and STATE.onCleanup then
    STATE.onCleanup(restoreAll)
end

notify("Highway Legends Hub", VERSION .. " loaded - press K", "rocket")
local n = 0
for _ in pairs(traffic) do n += 1 end
print("[HL Hub " .. VERSION .. "] Loaded - " .. n .. " traffic cars indexed")
