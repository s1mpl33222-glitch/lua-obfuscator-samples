-- Electric Wing Kaitun By BBG's Art
local env = (getgenv and getgenv()) or _G
env.PF_Gen = (env.PF_Gen or 0) + 1
local GEN = env.PF_Gen
local function Running() return env.PF_Gen == GEN end

repeat task.wait() until game:IsLoaded() and game:GetService("Players").LocalPlayer

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local RS = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

-- Config
local BUY_POS = Vector3.new(-16924.388671875, 11.139923095703125, 433.4230041503906)
local TWEEN_SPEED = 275
local BOAT_SPEED = 250
local BOAT_BOOST_HEIGHT = 300
local BOAT_CLIMB_SPEED = 250
local BOAT_BOOST_TIME = 8
local BoostUntil = 0
local PIRANHA_RANGE = 1500
local FAST_ATTACK_MODE = "2"
local BoatFindRange = 5000
local BOAT_REBOARD_RANGE = 150
local TS_SKIP_RADIUS = 200
local TS_DANGER = 220
local TS_DODGE_Y = 300
local SailArriveDist = 40
local CruiseWP_A = CFrame.new(-44541.7617, 30.0003204, -1244.8584)
local CruiseWP_B = CFrame.new(-90000, 30.0003204, -1244.8584)

-- Remotes
local Remote = RS:FindFirstChild("Remotes")
local CommF = Remote and Remote:WaitForChild("CommF_", 10)

local AbandonedBoats = setmetatable({}, { __mode = "k" })
local Fighting = false

local function Parts()
    local char = LocalPlayer.Character
    if not char then return nil, nil, nil end
    return char, char:FindFirstChild("HumanoidRootPart"), char:FindFirstChildOfClass("Humanoid")
end

local function IsAlive()
    local _, hrp, hum = Parts()
    return hrp ~= nil and hum ~= nil and hum.Health > 0
end

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    pcall(function()
        VirtualUser:Button2Down(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
        task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0, 0), workspace.CurrentCamera.CFrame)
    end)
end)

-- Simulation Radius
task.spawn(function()
    while Running() do
        pcall(function()
            if type(sethiddenproperty) == "function" then
                sethiddenproperty(LocalPlayer, "SimulationRadius", math.huge)
            else
                LocalPlayer.SimulationRadius = math.huge
            end
        end)
        task.wait(1)
    end
end)

local function NoClip()
    local char = LocalPlayer.Character
    if not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then p.CanCollide = false end
    end
end

-- Tween
local function MoveTo(getGoal, stopCheck, timeout)
    local t0 = os.clock()
    timeout = timeout or 60
    while Running() and os.clock() - t0 < timeout do
        local _, hrp, hum = Parts()
        if not hrp or not hum or hum.Health <= 0 then return false end
        if stopCheck and stopCheck() then return false end
        local goal = getGoal()
        if not goal then return false end
        local delta = goal.Position - hrp.Position
        local dist = delta.Magnitude
        if dist <= 2 then
            hrp.CFrame = goal
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
            return true
        end
        local dt = RunService.Heartbeat:Wait() or (1 / 60)
        local _, hrp2 = Parts()
        if not hrp2 then return false end
        local step = math.min(dist, TWEEN_SPEED * dt)
        hrp2.CFrame = CFrame.new(hrp2.Position + delta.Unit * step) * (hrp2.CFrame - hrp2.CFrame.Position)
        hrp2.AssemblyLinearVelocity = Vector3.zero
        hrp2.AssemblyAngularVelocity = Vector3.zero
        NoClip()
    end
    return false
end

-- Seat
local function Unseat()
    for _ = 1, 3 do
        local char, hrp, hum = Parts()
        if not hum or (not hum.Sit and hum.SeatPart == nil) then return true end
        pcall(function()
            local seat = hum.SeatPart
            if seat and seat.Parent then
                local Weld = seat:FindFirstChild("SeatWeld")
                local p1 = Weld and Weld.Part1
                if Weld and ((not p1) or (p1:IsA("BasePart") and p1:IsDescendantOf(char))) then
                    Weld:Destroy()
                end
            end
            hum.Sit = false
            hum.PlatformStand = false
        end)
        if hrp then
            pcall(function() hrp.CFrame = hrp.CFrame + Vector3.new(0, 10, 0) end)
        end
        local s = os.clock()
        while os.clock() - s < 2 do
            local _, _, h2 = Parts()
            if not h2 or (not h2.Sit and h2.SeatPart == nil) then return true end
            pcall(function() h2.Sit = false end)
            task.wait(0.2)
        end
    end
    return false
end

-- Sit Logic
local SNAP_RANGE = 150

local function BoardSeat(seat, timeout)
    local t0 = os.clock()
    timeout = timeout or 20
    while Running() and IsAlive() and os.clock() - t0 < timeout do
        if not seat or not seat.Parent then return false end
        local _, hrp, hum = Parts()
        if hum.SeatPart == seat then return true end
        if hum.SeatPart ~= nil then
            Unseat()
            task.wait(0.1)
        end

        local dist = (seat.Position - hrp.Position).Magnitude
        if dist > SNAP_RANGE then
            -- Logic #1
            MoveTo(function()
                if seat and seat.Parent then return seat.CFrame end
                return nil
            end, function()
                local _, h2, hm = Parts()
                if not h2 or not seat or not seat.Parent then return true end
                return hm.SeatPart ~= nil or (seat.Position - h2.Position).Magnitude <= SNAP_RANGE
            end, 30)
        else
            -- Logic #2
            local s0 = os.clock()
            while Running() and IsAlive() and seat.Parent and os.clock() - s0 < 1.5 do
                local _, h3, hm3 = Parts()
                if not h3 then break end
                if hm3.SeatPart == seat then return true end
                h3.CFrame = seat.CFrame
                h3.AssemblyLinearVelocity = Vector3.zero
                h3.AssemblyAngularVelocity = Vector3.zero
                NoClip()
                RunService.Heartbeat:Wait()
            end
        end
    end
    local _, _, hum = Parts()
    return hum ~= nil and hum.SeatPart == seat
end

-- Boat
local function BoatOwnerMatch(boat)
    local Owner = boat and boat:FindFirstChild("Owner")
    if not Owner then return false end
    if Owner.Value == LocalPlayer then return true end
    if tostring(Owner.Value) == LocalPlayer.Name then return true end
    return false
end

local function IsBoatDead(boat)
    if not boat then return false end
    local Humanoid = boat:FindFirstChild("Humanoid")
    if Humanoid then
        if Humanoid:IsA("ValueBase") then
            local ok, v = pcall(function() return Humanoid.Value end)
            if ok and v ~= nil then return v <= 0 end
        elseif Humanoid:IsA("Humanoid") then
            return Humanoid.Health <= 0
        end
    end
    local Health = boat:FindFirstChild("Health")
    if Health and Health:IsA("ValueBase") then
        local ok2, v2 = pcall(function() return Health.Value end)
        if ok2 and v2 ~= nil then return v2 <= 0 end
    end
    return false
end

local function GetOwnBoat(maxRange)
    maxRange = maxRange or BoatFindRange
    local boats = workspace:FindFirstChild("Boats")
    if not boats then return nil, nil end
    local _, hrp = Parts()
    if not hrp then return nil, nil end
    for _, boat in ipairs(boats:GetChildren()) do
        if BoatOwnerMatch(boat) and not AbandonedBoats[boat] and not IsBoatDead(boat) then
            local seat = boat:FindFirstChild("VehicleSeat")
            if seat and seat.Position.Y >= 0 then
                if (seat.Position - hrp.Position).Magnitude <= maxRange then
                    return boat, seat
                end
            end
        end
    end
    return nil, nil
end

local function BoatBroken(boat, seat)
    local reason
    if not boat or not boat.Parent then reason = "boat removed"
    elseif not seat or not seat.Parent then reason = "seat removed"
    elseif IsBoatDead(boat) then reason = "boat health <= 0"
    elseif seat.Position.Y < 0 then reason = "seat Y < 0 (" .. tostring(seat.Position.Y) .. ")" end
    if reason then
        if reason ~= env.PF_LastReason then
            env.PF_LastReason = reason
            warn("[PiranhaFarm] boat broken -> " .. reason)
        end
        return true
    end
    env.PF_LastReason = nil
    return false
end

local function WaitForOwnBoat(t)
    local s = os.clock()
    while Running() and os.clock() - s < t do
        local b, st = GetOwnBoat()
        if b and st then return b, st end
        task.wait(0.05)
    end
    return nil, nil
end

-- Boat NoClip
local NC_Boat, NC_Parts, NC_Conns = nil, {}, {}
local function StopBoatNoClip()
    for _, c in ipairs(NC_Conns) do pcall(function() c:Disconnect() end) end
    NC_Conns, NC_Parts, NC_Boat = {}, {}, nil
end
local function BoatNoClip(boat, force)
    if not boat or not boat.Parent then return end
    if NC_Boat == boat and not force then return end
    StopBoatNoClip()
    NC_Boat = boat
    for _, p in ipairs(boat:GetDescendants()) do
        if p:IsA("BasePart") then NC_Parts[#NC_Parts + 1] = p end
    end
    NC_Conns[#NC_Conns + 1] = boat.DescendantAdded:Connect(function(d)
        if d:IsA("BasePart") then NC_Parts[#NC_Parts + 1] = d end
    end)
    NC_Conns[#NC_Conns + 1] = RunService.Stepped:Connect(function()
        if not Running() or not boat.Parent then
            StopBoatNoClip()
            return
        end
        for i = #NC_Parts, 1, -1 do
            local p = NC_Parts[i]
            if p.Parent then
                if p.CanCollide then p.CanCollide = false end
            else
                table.remove(NC_Parts, i)
            end
        end
    end)
end

-- Destory Rocks
task.spawn(function()
    while Running() do
        pcall(function()
            local rocks = workspace:FindFirstChild("Rocks")
            if rocks then rocks:Destroy() end
        end)
        task.wait(0.5)
    end
end)

-- Helper
local function AbandonOwnBoats()
    local boats = workspace:FindFirstChild("Boats")
    if not boats then return end
    for _, boat in ipairs(boats:GetChildren()) do
        if BoatOwnerMatch(boat) then
            AbandonedBoats[boat] = true
        end
    end
end

-- Boat
local BOAT_NAME = "Guardian"

-- Location
local function GoBuyBoat()
    local _, _, hum = Parts()
    if hum and (hum.Sit or hum.SeatPart ~= nil) then Unseat() end

    AbandonOwnBoats()

    local ok = MoveTo(function() return CFrame.new(BUY_POS) end, nil, 90)
    if not ok then return nil, nil end
    if not CommF then return nil, nil end

    -- Buy Boat
    local function Buy()
        task.spawn(function()
            pcall(function() CommF:InvokeServer("BuyBoat", BOAT_NAME) end)
        end)
    end
    Buy()
    local t0 = os.clock()
    local lastBuy = os.clock()
    while Running() and IsAlive() and os.clock() - t0 < 10 do
        local b, st = GetOwnBoat()
        if b and st then
            BoatNoClip(b, true)
            return b, st
        end
        if os.clock() - lastBuy >= 1.5 then
            lastBuy = os.clock()
            Buy()
        end
        task.wait(0.03)
    end
    return nil, nil
end

-- Sailing
local CruiseToB = true
local CruiseCheckPos, CruiseCheckAt = nil, 0

local function SailStep(boat, seat)
    local _, hrp = Parts()
    if not hrp then return end
    local dt = RunService.Heartbeat:Wait() or (1 / 60)
    local pos = hrp.Position
    local target = CruiseToB and CruiseWP_B or CruiseWP_A
    local zone = target.Position
    local flat = Vector3.new(zone.X - pos.X, 0, zone.Z - pos.Z)
    local dist = flat.Magnitude
    if dist <= SailArriveDist then
        CruiseToB = not CruiseToB
        target = CruiseToB and CruiseWP_B or CruiseWP_A
        zone = target.Position
        flat = Vector3.new(zone.X - pos.X, 0, zone.Z - pos.Z)
        dist = flat.Magnitude
    end

    -- Logic #1
    if os.clock() - CruiseCheckAt >= 15 then
        if CruiseCheckPos and Vector3.new(pos.X - CruiseCheckPos.X, 0, pos.Z - CruiseCheckPos.Z).Magnitude < 200 then
            Unseat()
            task.wait(0.3)
            if seat.Parent then BoardSeat(seat, 10) end
            CruiseCheckPos = nil
        else
            CruiseCheckPos = pos
        end
        CruiseCheckAt = os.clock()
    end

    if dist < 0.5 then return end
    local np = pos + flat.Unit * math.min(dist, BOAT_SPEED * dt)
    if os.clock() < BoostUntil then
        -- Logic #2
        local y = pos.Y + math.clamp(BOAT_BOOST_HEIGHT - pos.Y, -BOAT_CLIMB_SPEED * dt, BOAT_CLIMB_SPEED * dt)
        pcall(function()
            hrp.CFrame = CFrame.lookAt(Vector3.new(np.X, y, np.Z),
                Vector3.new(np.X, y, np.Z - 1), Vector3.new(0, 1, 0))
            hrp.AssemblyLinearVelocity = Vector3.zero
        end)
    else
        -- Logic #3
        pcall(function()
            local vy = hrp.AssemblyLinearVelocity.Y
            hrp.CFrame = CFrame.new(np.X, pos.Y, np.Z) * (hrp.CFrame - hrp.CFrame.Position)
            hrp.AssemblyLinearVelocity = Vector3.new(0, vy, 0)
        end)
    end
end

-- Piranha
local function MobAlive(Mob)
    if not Mob or not Mob.Parent then return false end
    local Health = Mob:FindFirstChild("Health")
    if Health and Health:IsA("ValueBase") and Health.Value <= 0 then return false end
    local Humanoid = Mob:FindFirstChildOfClass("Humanoid")
    if Humanoid and Humanoid.Health <= 0 then return false end
    return (Health ~= nil and Health:IsA("ValueBase")) or (Humanoid ~= nil)
end

local function MobRoot(Mob)
    if not Mob then return nil end
    return Mob:FindFirstChild("HumanoidRootPart")
        or Mob:FindFirstChild("RootPart")
        or Mob.PrimaryPart
        or Mob:FindFirstChild("Head")
        or Mob:FindFirstChildWhichIsA("BasePart", true)
end

-- Terrorshark Skip
local function TerrorsharkNear(pos, radius)
    local Enemies = workspace:FindFirstChild("Enemies")
    if not Enemies then return nil end
    for _, Mob in ipairs(Enemies:GetChildren()) do
        if Mob.Name == "Terrorshark" and MobAlive(Mob) then
            local root = MobRoot(Mob)
            if root and (root.Position - pos).Magnitude <= radius then
                return Mob, root
            end
        end
    end
    return nil
end

local function FindPiranha(maxDist)
    local Enemies = workspace:FindFirstChild("Enemies")
    local _, hrp = Parts()
    if not Enemies or not hrp then return nil end
    local best, bestD = nil, maxDist or PIRANHA_RANGE
    for _, Mob in ipairs(Enemies:GetChildren()) do
        if Mob.Name == "Piranha" and MobAlive(Mob) then
            local root = MobRoot(Mob)
            if root and not TerrorsharkNear(root.Position, TS_SKIP_RADIUS) then
                local d = (root.Position - hrp.Position).Magnitude
                if d <= bestD then
                    best, bestD = Mob, d
                end
            end
        end
    end
    return best
end

-- Haki
local function HakiAuto()
    local char = LocalPlayer.Character
    if char and CommF and not char:FindFirstChild("HasBuso") then
        pcall(function() CommF:InvokeServer("Buso") end)
    end
end

-- Equip 
local function EquipSword()
    local char, _, hum = Parts()
    if not char or not hum then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if tool and tool.ToolTip == "Sword" then return end
    for _, v in ipairs(LocalPlayer.Backpack:GetChildren()) do
        if v:IsA("Tool") and v.ToolTip == "Sword" then
            hum:EquipTool(v)
            break
        end
    end
end

-- Fast Attack
local AttackNet, AttackRegisterAttack, AttackRegisterHit, AttackSeedRemote = nil, nil, nil, nil
local AttackObfuscatedRemote, AttackObfuscatedId = nil, nil
local AttackSeedCache, AttackSeedAt = nil, 0

local function Attack_Clone(inst)
    if typeof(cloneref) == "function" then return cloneref(inst) end
    return inst
end

local function Attack_CaptureRemote(R)
    if R and R:IsA("RemoteEvent") and R:GetAttribute("Id") then
        AttackObfuscatedRemote = R
        AttackObfuscatedId = R:GetAttribute("Id")
    end
end

do
    for _, name in ipairs({ "Util", "Common", "Remotes", "Assets", "FX" }) do
        local folder = RS:FindFirstChild(name)
        if folder then
            for _, child in ipairs(folder:GetChildren()) do Attack_CaptureRemote(child) end
            folder.ChildAdded:Connect(function(child) Attack_CaptureRemote(child) end)
        end
    end
end

local function Attack_EnsureRemotes()
    if not AttackNet then
        local modules = RS:FindFirstChild("Modules")
        AttackNet = modules and modules:FindFirstChild("Net")
    end
    if not AttackNet then return false end
    if not AttackRegisterAttack then
        AttackRegisterAttack = AttackNet:FindFirstChild("RE/RegisterAttack") or AttackNet:FindFirstChild("RegisterAttack")
    end
    if not AttackRegisterHit then
        AttackRegisterHit = AttackNet:FindFirstChild("RE/RegisterHit") or AttackNet:FindFirstChild("RegisterHit")
    end
    if not AttackSeedRemote then
        AttackSeedRemote = AttackNet:FindFirstChild("seed")
    end
    return AttackRegisterAttack ~= nil and AttackRegisterHit ~= nil
end

local function Attack_GetSeed()
    local now = os.clock()
    if AttackSeedCache and (now - AttackSeedAt) < 1 then return AttackSeedCache end
    if AttackSeedRemote then
        local ok, seed = pcall(function() return AttackSeedRemote:InvokeServer() end)
        if ok and seed then
            AttackSeedCache = seed
            AttackSeedAt = now
            return seed
        end
    end
    return AttackSeedCache or 1
end

-- Hit List
local function Attack_BuildHitList(origin)
    local hitList = {}
    local Enemies = workspace:FindFirstChild("Enemies")
    if not Enemies then return hitList end
    for _, model in ipairs(Enemies:GetChildren()) do
        if model.Name == "Piranha" then
            local root = model:FindFirstChild("HumanoidRootPart")
            local hum = model:FindFirstChild("Humanoid")
            if root and hum and hum.Health > 0 and (root.Position - origin).Magnitude <= 60 then
                for _, part in ipairs(model:GetChildren()) do
                    if part:IsA("BasePart") then
                        hitList[#hitList + 1] = { model, part }
                    end
                end
            end
        end
    end
    return hitList
end

local function Attack_Auto()
    local char, hrp, hum = Parts()
    if not char or not hrp or not hum or hum.Health <= 0 then return end
    local tool = char:FindFirstChildOfClass("Tool")
    if not tool then return end
    local WT = tool:GetAttribute("WeaponType")
    if WT ~= "Melee" and WT ~= "Sword" then return end
    if not Attack_EnsureRemotes() then return end
    local hitList = Attack_BuildHitList(hrp.Position)
    if #hitList == 0 then return end
    pcall(function()
        local okNet, netApi = pcall(function() return require(AttackNet) end)
        if okNet and netApi and netApi.RemoteEvent then
            pcall(netApi.RemoteEvent, netApi, "RegisterHit", true)
        end
        AttackRegisterAttack:FireServer()
        local primaryModel = hitList[1][1]
        local head = primaryModel and primaryModel:FindFirstChild("Head")
        if not head then return end
        if FAST_ATTACK_MODE == "1" then
            AttackRegisterHit:FireServer(head, hitList)
        else
            AttackRegisterHit:FireServer(head, hitList, {}, tostring(LocalPlayer.UserId):sub(2, 4) ..
                tostring(coroutine.running()):sub(11, 15))
        end
        if AttackObfuscatedRemote and AttackObfuscatedId then
            local key = math.floor(workspace:GetServerTimeNow() / 10 % 10) + 1
            local encName = string.gsub("RE/RegisterHit", ".", function(c)
                return string.char(bit32.bxor(string.byte(c), key))
            end)
            local encId = bit32.bxor(AttackObfuscatedId + 909090, Attack_GetSeed() * 2)
            Attack_Clone(AttackObfuscatedRemote):FireServer(encName, encId, head, hitList)
        end
    end)
end

-- Attack Loop
task.spawn(function()
    while Running() do
        if Fighting then
            pcall(Attack_Auto)
        end
        task.wait(0.05)
    end
end)

-- FightPiranha
local function FightPiranha(Mob)
    local _, _, hum = Parts()
    if hum and (hum.Sit or hum.SeatPart ~= nil) then Unseat() end
    Fighting = true
    local t0 = os.clock()
    while Running() and IsAlive() and MobAlive(Mob) and os.clock() - t0 < 120 do
        local root = MobRoot(Mob)
        local _, hrp = Parts()
        if not root or not hrp then break end

        -- Logic #1
        if TerrorsharkNear(hrp.Position, TS_DANGER) then
            Fighting = false
            local d0 = os.clock()
            while Running() and IsAlive() and os.clock() - d0 < 8 do
                local _, h = Parts()
                if not h then break end
                if not TerrorsharkNear(h.Position, TS_DANGER * 1.5) then break end
                local dt2 = RunService.Heartbeat:Wait() or (1 / 60)
                local up = Vector3.new(h.Position.X, math.max(h.Position.Y, TS_DODGE_Y), h.Position.Z)
                local dv = up - h.Position
                local dd = dv.Magnitude
                if dd > 1 then
                    h.CFrame = CFrame.new(h.Position + dv.Unit * math.min(dd, TWEEN_SPEED * dt2))
                end
                h.AssemblyLinearVelocity = Vector3.zero
                h.AssemblyAngularVelocity = Vector3.zero
                NoClip()
            end
            return
        end

        local goal = root.Position + Vector3.new(0, 40, 0)
        local delta = goal - hrp.Position
        local dist = delta.Magnitude
        local dt = RunService.Heartbeat:Wait() or (1 / 60)
        local _, hrp2 = Parts()
        if not hrp2 then break end
        if dist <= 3 then
            hrp2.CFrame = CFrame.new(goal)
        else
            hrp2.CFrame = CFrame.new(hrp2.Position + delta.Unit * math.min(dist, TWEEN_SPEED * dt))
        end
        hrp2.AssemblyLinearVelocity = Vector3.zero
        hrp2.AssemblyAngularVelocity = Vector3.zero
        NoClip()
        EquipSword()
        HakiAuto()
    end
    Fighting = false
end

-- Kill Piranha
local function ClearPiranhas(maxTime)
    local t0 = os.clock()
    while Running() and IsAlive() and os.clock() - t0 < (maxTime or 90) do
        local p = FindPiranha(PIRANHA_RANGE)
        if not p then break end
        FightPiranha(p)
        task.wait(0.1)
    end
    Fighting = false
end

-- Reset Logic
local function ResetCharacter()
    Fighting = false
    local oldChar, _, hum = Parts()
    pcall(function() if hum then hum.Health = 0 end end)
    pcall(function() if oldChar then oldChar:BreakJoints() end end)
    local t0 = os.clock()
    repeat
        task.wait(0.25)
        local c, h, hm = Parts()
    until (c and c ~= oldChar and h and hm and hm.Health > 0) or os.clock() - t0 > 20 or not Running()
    task.wait(1)
end

-- Main Cycle
local function Cycle()
    -- Logic #1
    while Running() and not IsAlive() do task.wait(0.3) end
    if not Running() then return end

    local justBought = false
    local boat, seat = GetOwnBoat(BOAT_REBOARD_RANGE)
    if not boat then
        boat, seat = GoBuyBoat()
        if not boat then
            task.wait(1)
            return
        end
        justBought = true
    end

    BoatNoClip(boat, true)

    if not BoardSeat(seat, 20) then
        return
    end

    -- Logic #2
    if justBought then
        BoostUntil = os.clock() + BOAT_BOOST_TIME
    end

    CruiseCheckPos, CruiseCheckAt = nil, os.clock()

    -- Logic #3
    while Running() do
        if not IsAlive() then return end

        if BoatBroken(boat, seat) then
            AbandonedBoats[boat] = true
            ClearPiranhas(90)
            ResetCharacter()
            return
        end

        local p = FindPiranha(PIRANHA_RANGE)
        if p then
            FightPiranha(p)
            if not IsAlive() then return end
            if BoatBroken(boat, seat) then
                -- Logic #4
            else
                local _, _, hum = Parts()
                if not hum or hum.SeatPart ~= seat then
                    if not BoardSeat(seat, 20) then return end
                end
                CruiseCheckPos, CruiseCheckAt = nil, os.clock()
            end
        else
            local _, _, hum = Parts()
            if hum and hum.SeatPart ~= seat then
                if not BoardSeat(seat, 15) then return end
            end
            HakiAuto()
            BoatNoClip(boat)
            SailStep(boat, seat)
        end
    end
end

-- UI
task.spawn(function()
    local okUI, errUI = pcall(function()
        local Players = game:GetService("Players")
        local UIS = game:GetService("UserInputService")
        local parent = (gethui and gethui()) or game:GetService("CoreGui")
        if not pcall(function() return parent.Name end) then
            parent = Players.LocalPlayer:WaitForChild("PlayerGui")
        end
        if parent:FindFirstChild("BBGGlassUI") then parent.BBGGlassUI:Destroy() end

        local gui = Instance.new("ScreenGui")
        gui.Name = "BBGGlassUI"
        gui.ResetOnSpawn = false
        gui.Parent = parent

        local function corner(o, r) local c = Instance.new("UICorner", o) c.CornerRadius = r return c end
        local function stroke(o, th, a, b, c)
            local s = Instance.new("UIStroke", o)
            s.Color = Color3.new(1, 1, 1)
            s.Thickness = th or 1
            s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
            local sg = Instance.new("UIGradient", s)
            sg.Rotation = 45
            sg.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, a or 0.15),
                NumberSequenceKeypoint.new(0.5, b or 0.85),
                NumberSequenceKeypoint.new(1, c or 0.4),
            })
            return s
        end
        local function gloss(o, r, z, strength)
            local f = Instance.new("Frame")
            f.Name = "Gloss"
            f.Size = UDim2.fromScale(1, 1)
            f.BackgroundColor3 = Color3.new(1, 1, 1)
            f.BorderSizePixel = 0
            f.ZIndex = z
            f.Parent = o
            corner(f, r)
            local g = Instance.new("UIGradient", f)
            g.Rotation = 90
            g.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, strength),
                NumberSequenceKeypoint.new(0.45, 0.96),
                NumberSequenceKeypoint.new(1, 1),
            })
            return f
        end

        -- Container
        local main = Instance.new("Frame")
        main.Name = "Main"
        main.AnchorPoint = Vector2.new(0.5, 0.5)
        main.Position = UDim2.fromScale(0.5, 0.5)
        main.Size = UDim2.fromOffset(230, 230)
        main.BackgroundTransparency = 1
        main.Parent = gui

        -- Scale
        local scale = Instance.new("UIScale", main)
        scale.Scale = 0.78

        -- Glass Layer
        local glass = Instance.new("Frame")
        glass.Name = "Glass"
        glass.Size = UDim2.fromScale(1, 1)
        glass.BackgroundColor3 = Color3.new(1, 1, 1)
        glass.BackgroundTransparency = 0.45
        glass.BorderSizePixel = 0
        glass.Active = true
        glass.ZIndex = 1
        glass.Parent = main
        corner(glass, UDim.new(0, 28))
        stroke(glass, 1.6, 0.05, 0.85, 0.35)

        local gg = Instance.new("UIGradient", glass)
        gg.Rotation = 60
        gg.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 155, 172)),
            ColorSequenceKeypoint.new(0.5, Color3.fromRGB(60, 63, 78)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(28, 30, 40)),
        })
        gg.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.3),
            NumberSequenceKeypoint.new(1, 0.55),
        })

        gloss(main, UDim.new(0, 28), 2, 0.8)

        -- Icon
        local logo = Instance.new("ImageLabel")
        logo.Name = "Logo"
        logo.AnchorPoint = Vector2.new(0.5, 0)
        logo.Position = UDim2.new(0.5, 0, 0, 16)
        logo.Size = UDim2.fromOffset(60, 60)
        logo.BackgroundColor3 = Color3.new(1, 1, 1)
        logo.BackgroundTransparency = 0.85
        logo.Image = "rbxassetid://104418583710842"
        logo.ScaleType = Enum.ScaleType.Crop
        logo.ZIndex = 5
        logo.Parent = main
        corner(logo, UDim.new(1, 0))
        stroke(logo, 2, 0.1, 0.6, 0.3)

        -- Subtitle
        local title = Instance.new("TextLabel")
        title.Name = "Title"
        title.BackgroundTransparency = 1
        title.Position = UDim2.new(0, 0, 0, 82)
        title.Size = UDim2.new(1, 0, 0, 26)
        title.Font = Enum.Font.GothamBold
        title.Text = "BBG Panel"
        title.TextSize = 20
        title.TextColor3 = Color3.new(1, 1, 1)
        title.ZIndex = 5
        title.Parent = main

        -- Status
        local box = Instance.new("Frame")
        box.Name = "StatBox"
        box.AnchorPoint = Vector2.new(0.5, 0)
        box.Position = UDim2.new(0.5, 0, 0, 120)
        box.Size = UDim2.fromOffset(156, 90)
        box.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
        box.BackgroundTransparency = 0.5
        box.BorderSizePixel = 0
        box.ZIndex = 5
        box.Parent = main
        corner(box, UDim.new(0, 18))
        stroke(box, 1.2, 0.2, 0.85, 0.5)
        gloss(box, UDim.new(0, 18), 5, 0.88)

        local value = Instance.new("TextLabel")
        value.Name = "Value"
        value.BackgroundTransparency = 1
        value.Position = UDim2.new(0, 0, 0, 10)
        value.Size = UDim2.new(1, 0, 0, 36)
        value.Font = Enum.Font.GothamBold
        value.Text = "0"
        value.TextSize = 28
        value.TextColor3 = Color3.new(1, 1, 1)
        value.ZIndex = 7
        value.Parent = box

        local label = Instance.new("TextLabel")
        label.Name = "Label"
        label.BackgroundTransparency = 1
        label.Position = UDim2.new(0, 0, 0, 52)
        label.Size = UDim2.new(1, 0, 0, 22)
        label.Font = Enum.Font.Gotham
        label.Text = "Electric Wings"
        label.TextSize = 13
        label.TextColor3 = Color3.fromRGB(220, 223, 233)
        label.ZIndex = 7
        label.Parent = box

        -- Draggable
        local dragging, dragStart, startPos
        glass.InputBegan:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
                dragging, dragStart, startPos = true, i.Position, main.Position
                i.Changed:Connect(function()
                    if i.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        UIS.InputChanged:Connect(function(i)
            if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
                local d = i.Position - dragStart
                main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
            end
        end)

        -- Electric Wing Counter
        local RS = game:GetService("ReplicatedStorage")
        local TweenService = game:GetService("TweenService")
        local ELECTRIC_WING_ID = "552"
        local REFRESH = 2

        local getAll
        local function getCount()
            local ok, count = pcall(function()
                if not getAll then
                    local net = RS:WaitForChild("Modules", 5):WaitForChild("Net", 5)
                    getAll = net:WaitForChild("RF/GetAllItemValues", 5)
                end
                local items = getAll:InvokeServer()
                if type(items) ~= "table" then return nil end
                local total = 0
                for _, item in ipairs(items) do
                    if type(item) == "table" and tostring(item.ItemId) == ELECTRIC_WING_ID
                        and tostring(item.Key) == "Quantity" then
                        total = tonumber(item.Value) or 0
                    end
                end
                return total
            end)
            if ok then return count end
            return nil
        end

        local last
        task.spawn(function()
            while gui.Parent and Running() do
                local c = getCount()
                if c ~= nil and c ~= last then
                    last = c
                    value.Text = tostring(c)
                    value.TextSize = 36
                    TweenService:Create(value, TweenInfo.new(0.25), {TextSize = 28}):Play()
                end
                task.wait(REFRESH)
            end
        end)

        -- Value Update
        _G.BBG_SetValue = function(v) value.Text = tostring(v) end

    end)
    if not okUI then warn("[PiranhaFarm UI] " .. tostring(errUI)) end
end)

task.spawn(function()
    while Running() do
        local ok, err = pcall(Cycle)
        if not ok then warn("[PiranhaFarm] " .. tostring(err)) end
        task.wait(0.5)
    end
end)

print("[PiranhaFarm] started")
