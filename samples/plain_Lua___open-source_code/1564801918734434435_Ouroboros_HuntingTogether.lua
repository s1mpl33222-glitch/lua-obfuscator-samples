-- Deobfuscated by @x2zu
-- DISCORD SERVER : https://discord.gg/bRSjbF89RC

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local SCRIPT_VERSION = "v0.14"
local GAME_NAME = "Hunting Together"
local GAME_KEY = "HuntingTogether"
local DISCORD_INVITE = "https://discord.gg/synapsex"

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local TeleportService = game:GetService("TeleportService")
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local CollectionService = game:GetService("CollectionService")

local LocalPlayer = Players.LocalPlayer

local unloaded = false
local connections = {}
local workers = {}
local Library

local Flags = {
    AutoFarm = false,
    FarmMobs = {},
    FarmDistance = 8,
    FarmPosition = "Front",
    FarmPriority = "Selection Order",
    Leveling = false,
    LevelQuests = true,
    LevelBosses = true,
    FarmOrder = {},
    AutoSkills = false,
    Skills = {},
    AutoPotions = false,
    Potions = {},
    HpPercent = 50,
    SpPercent = 30,
    AutoRewards = false,
    AutoGear = false,
    AutoCards = false,
    AutoStats = false,
    StatChoice = nil,
    AutoDrops = false,
    AutoBoxes = false,
    AutoRefine = false,
    RefineWeapons = {},
    RefineTarget = 4,
    RefineSafeOnly = true,
    RefineGoldReserve = 0,
    RefineProtect = false,
    RefineLucky = false,
    RefineDelay = 1,
    AutoSell = false,
    SellTrigger = "Bag Full %",
    SellBagPercent = 90,
    SellInterval = 120,
    SellKinds = {},
    SellKeep = {},
    SellKeepAmount = 0,
    SellKeepRefined = true,
    SellJunk = true,
    WalkSpeedEnabled = false,
    WalkSpeed = 32,
    InfJump = false,
    NoClip = false,
    InstantProximityPrompt = false,
    Fly = false,
    FlySpeed = 60,
    AutoReconnect = false,
    Disable3DRendering = false,
    FpsBoost = false,
}

local walkSpeedRestore = {}
local noclipRestore = {}
local promptRestore = {}
local fpsRestore = {}
local flyState = nil
local infJumpConn = nil
local noclipConn = nil
local promptConn = nil
local fpsConn = nil
local reconnectConn = nil
local reconnectFailedConn = nil
local reconnectToken = 0
local renderBacking = nil
local sprintConn = nil
local sprintRestore = nil

local Game = {
    target = nil,
    busy = false,
    lastTargetFire = 0,
    lastTravel = 0,
    levelPlan = nil,
    levelTravel = nil,
    levelStatus = "Idle",
    blockedZones = {},
    questWait = 0,
    travelIndex = 0,
    followConn = nil,
    skillIndex = 0,
    buffUsed = {},
    potionApplied = {},
    gearSetByUs = false,
}

local Shared = ReplicatedStorage:WaitForChild("Shared", 30)
local Remotes = ReplicatedStorage:WaitForChild("Remotes", 30)

local function loadData(name)
    local mod = Shared and Shared:FindFirstChild(name)
    if not mod then
        return nil
    end
    local ok, result = pcall(require, mod)
    return ok and result or nil
end

local ItemData = loadData("ItemData")
local BuildData = loadData("BuildData")
local GameConfig = loadData("GameConfig")
local GearUtil = loadData("GearUtil")
local GearData = loadData("GearData")
local RefineConfig = type(GearData) == "table" and type(GearData.Refine) == "table" and GearData.Refine or {}

local function fire(name, ...)
    local r = Remotes and Remotes:FindFirstChild(name)
    if r then
        r:FireServer(...)
        return true
    end
    return false
end

local function track(conn)
    if conn then
        table.insert(connections, conn)
    end
    return conn
end

local function getRoot()
    local character = LocalPlayer.Character
    if not character then
        return nil, nil
    end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    local root = character:FindFirstChild("HumanoidRootPart")
    if humanoid and humanoid.Health > 0 and root and root:IsA("BasePart") then
        return humanoid, root
    end
    return nil, nil
end

local function startWorker(key, interval, step)
    if workers[key] then
        return
    end
    workers[key] = true
    task.spawn(function()
        while workers[key] and not unloaded do
            local ok, err = pcall(step)
            if not ok then
                warn("[HuntingTogether] " .. key .. ": " .. tostring(err))
            end
            task.wait(interval)
        end
        workers[key] = nil
    end)
end

local function stopWorker(key)
    workers[key] = false
end

local function setWorker(key, enabled, interval, step)
    if enabled then
        startWorker(key, interval, step)
    else
        stopWorker(key)
    end
end

local function readJson(attr)
    local raw = LocalPlayer:GetAttribute(attr)
    if type(raw) ~= "string" or raw == "" then
        return nil
    end
    local ok, data = pcall(HttpService.JSONDecode, HttpService, raw)
    return ok and data or nil
end

local function itemDef(id)
    if type(ItemData) ~= "table" then
        return nil
    end
    local src = type(ItemData.Items) == "table" and ItemData.Items or ItemData
    local def = src[id]
    return type(def) == "table" and def or nil
end

local function mobName(model)
    local display = model:GetAttribute("DisplayName")
    return type(display) == "string" and display ~= "" and display or model.Name
end

local function mobAlive(model)
    return model ~= nil
        and model.Parent ~= nil
        and CollectionService:HasTag(model, "Monster")
        and (tonumber(model:GetAttribute("HP")) or 0) > 0
        and model.PrimaryPart ~= nil
end

local MobZones = {}
local MobInfo = {}

local function buildMobZones()
    local mapData, monsterData = loadData("MapData"), loadData("MonsterData")
    if type(mapData) ~= "table" or type(monsterData) ~= "table" then
        return
    end
    local monsters = type(monsterData.Monsters) == "table" and monsterData.Monsters or monsterData
    for zoneId, zone in pairs(mapData) do
        if type(zone) == "table" and type(zone.Spawns) == "table" then
            for _, spawn in pairs(zone.Spawns) do
                local def = type(spawn) == "table" and monsters[spawn.Id]
                local name = type(def) == "table" and def.Name
                if type(name) == "string" then
                    local order = tonumber(zone.Order) or 99
                    local info = MobInfo[name]
                    if not info or order < info.order then
                        MobInfo[name] = { order = order, level = zone.LevelText or "", zone = zone.DisplayName or zoneId }
                    end
                    MobZones[name] = MobZones[name] or {}
                    if not table.find(MobZones[name], zoneId) then
                        table.insert(MobZones[name], zoneId)
                    end
                end
            end
        end
    end
end

buildMobZones()

local function mobLabel(name)
    local info = MobInfo[name]
    if not info then
        return name
    end
    return ("%s | %s %s"):format(name, info.level, info.zone)
end

local function labelToName(label)
    return tostring(label):match("^(.-) | ") or tostring(label)
end

local function mobNames()
    local seen, names = {}, {}
    for name in pairs(MobZones) do
        seen[name] = true
        table.insert(names, name)
    end
    for _, model in ipairs(CollectionService:GetTagged("Monster")) do
        if model:IsA("Model") and model.Name ~= "TrainingDummy" then
            local name = mobName(model)
            if not seen[name] then
                seen[name] = true
                table.insert(names, name)
            end
        end
    end
    table.sort(names, function(a, b)
        local oa = MobInfo[a] and MobInfo[a].order or 999
        local ob = MobInfo[b] and MobInfo[b].order or 999
        if oa ~= ob then
            return oa < ob
        end
        return a < b
    end)
    local out = {}
    for _, name in ipairs(names) do
        table.insert(out, mobLabel(name))
    end
    return out
end

local function wantedMob(model)
    if model.Name == "TrainingDummy" then
        return false
    end
    if Flags.Leveling then
        local plan = Game.levelPlan
        return plan ~= nil and plan.mobIds[model:GetAttribute("MonsterId")] == true
    end
    if next(Flags.FarmMobs) == nil then
        return true
    end
    return Flags.FarmMobs[mobName(model)] == true
end

local function priorityRank(model)
    if Flags.Leveling then
        local plan = Game.levelPlan
        return plan and plan.prefer and model:GetAttribute("MonsterId") == plan.prefer and 0 or 1
    end
    local mode = Flags.FarmPriority
    if mode == "Selection Order" then
        return table.find(Flags.FarmOrder, mobName(model)) or #Flags.FarmOrder + 1
    elseif mode == "Highest Level" then
        return -(tonumber(model:GetAttribute("Level")) or 0)
    elseif mode == "Lowest Level" then
        return tonumber(model:GetAttribute("Level")) or 0
    elseif mode == "Lowest HP" then
        return tonumber(model:GetAttribute("HP")) or 0
    end
    return 0
end

local function findTarget(root)
    local best, bestRank, bestDist = nil, math.huge, math.huge
    for _, model in ipairs(CollectionService:GetTagged("Monster")) do
        if mobAlive(model) and wantedMob(model) then
            local rank = priorityRank(model)
            local dist = (model.PrimaryPart.Position - root.Position).Magnitude
            if rank < bestRank or (rank == bestRank and dist < bestDist) then
                best, bestRank, bestDist = model, rank, dist
            end
        end
    end
    local current = Game.target
    if mobAlive(current) and wantedMob(current) then
        if Flags.FarmPriority ~= "Selection Order" or not best or priorityRank(current) <= bestRank then
            return current
        end
    end
    return best
end

local function standNear(root, position, distance)
    local flat = Vector3.new(root.Position.X - position.X, 0, root.Position.Z - position.Z)
    local dir = flat.Magnitude > 0.1 and flat.Unit or Vector3.new(0, 0, 1)
    local spot = position + dir * distance
    root.CFrame = CFrame.lookAt(spot, Vector3.new(position.X, spot.Y, position.Z))
    root.AssemblyLinearVelocity = Vector3.zero
end

local function setCurrentTarget(model)
    local value = LocalPlayer:FindFirstChild("CurrentTarget")
    if value and value:IsA("ObjectValue") and value.Value ~= model then
        value.Value = model
    end
end

local function goalCFrame(target)
    local radius = tonumber(target:GetAttribute("Radius")) or 1.5
    local range = tonumber(LocalPlayer:GetAttribute("AttackRange")) or 3
    local distance = math.clamp(math.min(Flags.FarmDistance, range - 1), 2, 40) + radius
    local pivot = target.PrimaryPart.CFrame
    local pos = pivot.Position
    local look = Vector3.new(pivot.LookVector.X, 0, pivot.LookVector.Z)
    look = look.Magnitude > 0.1 and look.Unit or Vector3.new(0, 0, -1)
    local mode = Flags.FarmPosition
    local spot
    if mode == "Behind" then
        spot = pos - look * distance
    elseif mode == "Above" then
        spot = pos + Vector3.new(0, distance, 0)
    elseif mode == "Below" then
        spot = pos - Vector3.new(0, distance, 0)
    elseif mode == "Orbit" then
        local angle = os.clock() * 1.5
        spot = pos + Vector3.new(math.cos(angle), 0, math.sin(angle)) * distance
    else
        spot = pos + look * distance
    end
    local dir = pos - spot
    if dir.Magnitude < 0.05 then
        return CFrame.new(spot)
    end
    local flat = Vector3.new(dir.X, 0, dir.Z)
    local up = flat.Magnitude < 0.1 and Vector3.zAxis or Vector3.yAxis
    return CFrame.lookAt(spot, pos, up)
end

local function followStep(dt)
    if unloaded or not Flags.AutoFarm or Game.busy then
        return
    end
    local target = Game.target
    if not mobAlive(target) then
        return
    end
    local _, root = getRoot()
    if not root then
        return
    end
    local goal = goalCFrame(target)
    if (root.Position - goal.Position).Magnitude > 25 then
        root.CFrame = goal
    else
        root.CFrame = root.CFrame:Lerp(goal, math.clamp(dt * 12, 0, 1))
    end
    root.AssemblyLinearVelocity = Vector3.zero
    root.AssemblyAngularVelocity = Vector3.zero
end

local function zoneCenter(zoneId)
    local gates = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("Gates")
    if not gates then
        return nil
    end
    local gate = gates:FindFirstChild("Gate_" .. zoneId)
    if not gate then
        return nil
    end
    local pos = gate:GetPivot().Position
    local nextZ = nil
    for _, other in ipairs(gates:GetChildren()) do
        local z = other:GetPivot().Position.Z
        if z < pos.Z - 1 and (not nextZ or z > nextZ) then
            nextZ = z
        end
    end
    local centerZ = nextZ and (pos.Z + nextZ) / 2 or pos.Z - 100
    return Vector3.new(pos.X, pos.Y + 5, centerZ)
end

local function travelToWanted(root)
    if next(Flags.FarmMobs) == nil or os.clock() - Game.lastTravel < 6 then
        return
    end
    local zones = {}
    for _, name in ipairs(Flags.FarmOrder) do
        for _, zoneId in ipairs(MobZones[name] or {}) do
            if not table.find(zones, zoneId) then
                table.insert(zones, zoneId)
            end
        end
    end
    if #zones == 0 then
        return
    end
    Game.travelIndex = Game.travelIndex % #zones + 1
    local center = zoneCenter(zones[Game.travelIndex])
    if not center then
        return
    end
    Game.lastTravel = os.clock()
    pcall(function()
        LocalPlayer:RequestStreamAroundAsync(center, 5)
    end)
    root.CFrame = CFrame.new(center)
    root.AssemblyLinearVelocity = Vector3.zero
end

local NpcPositions = {}

local function cacheNpcs()
    local npcs = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("NPCs")
    if not npcs then
        return
    end
    for _, npc in ipairs(npcs:GetChildren()) do
        local ok, pivot = pcall(npc.GetPivot, npc)
        if ok then
            NpcPositions[npc.Name] = pivot.Position
        end
    end
end

local function npcOptions()
    cacheNpcs()
    local out = {}
    for name in pairs(NpcPositions) do
        table.insert(out, name)
    end
    table.sort(out)
    return out
end

local function zoneOptions()
    local out = { "Town" }
    local mapData = loadData("MapData")
    local list = {}
    if type(mapData) == "table" then
        for id, zone in pairs(mapData) do
            if type(zone) == "table" then
                table.insert(list, { id = id, order = tonumber(zone.Order) or 99, name = zone.DisplayName or id })
            end
        end
    end
    table.sort(list, function(a, b)
        return a.order < b.order
    end)
    for _, z in ipairs(list) do
        table.insert(out, ("%s [%s]"):format(z.name, z.id))
    end
    return out
end

local function townPosition()
    local map = workspace:FindFirstChild("Map")
    local warps = map and map:FindFirstChild("Warps")
    local warp = warps and warps:FindFirstChild("Warp_Town")
    return warp and warp:GetPivot().Position + Vector3.new(0, 5, 0) or nil
end

local function teleportTo(position)
    local _, root = getRoot()
    if not (root and position) then
        return false
    end
    pcall(function()
        LocalPlayer:RequestStreamAroundAsync(position, 5)
    end)
    root.CFrame = CFrame.new(position)
    root.AssemblyLinearVelocity = Vector3.zero
    return true
end

local function teleportZone(choice)
    if type(choice) ~= "string" then
        return false
    end
    if choice == "Town" then
        return teleportTo(townPosition())
    end
    local id = choice:match("%[(.-)%]$")
    return id ~= nil and teleportTo(zoneCenter(id))
end

local function teleportNpc(name)
    cacheNpcs()
    local pos = NpcPositions[name]
    if not pos then
        return false
    end
    return teleportTo(pos + Vector3.new(0, 3, 4))
end

local LevelZones = {}
local RepeatQuests = {}

local function buildLeveling()
    local mapData = loadData("MapData")
    if type(mapData) == "table" then
        for id, zone in pairs(mapData) do
            if type(zone) == "table" then
                local ids = {}
                for _, spawn in pairs(type(zone.Spawns) == "table" and zone.Spawns or {}) do
                    if type(spawn) == "table" and type(spawn.Id) == "string" then
                        table.insert(ids, spawn.Id)
                    end
                end
                table.insert(LevelZones, {
                    id = id,
                    order = tonumber(zone.Order) or 99,
                    minLevel = tonumber(tostring(zone.LevelText or ""):match("%d+")) or 1,
                    bossRoom = zone.BossRoom == true,
                    unlocks = zone.Unlocks,
                    boss = zone.Boss,
                    ids = ids,
                })
            end
        end
        table.sort(LevelZones, function(a, b)
            return a.order < b.order
        end)
    end
    local questData = loadData("QuestData")
    local quests = type(questData) == "table" and type(questData.Quests) == "table" and questData.Quests or {}
    for id, q in pairs(quests) do
        if type(q) == "table" and q.Repeat == true and q.Type == "kill" then
            table.insert(RepeatQuests, { id = id, level = tonumber(q.ReqLevel) or 1, target = q.Target, count = tonumber(q.Count) or 1 })
        end
    end
    table.sort(RepeatQuests, function(a, b)
        return a.level < b.level
    end)
end

buildLeveling()

local function zoneOfMob(monsterId)
    for _, z in ipairs(LevelZones) do
        if not z.bossRoom and table.find(z.ids, monsterId) then
            return z
        end
    end
    return nil
end

local function zoneBlocked(z)
    return (Game.blockedZones[z.id] or 0) > os.clock()
end

local function inZone(root, z)
    local center = zoneCenter(z.id)
    if not center then
        return false
    end
    return math.abs(root.Position.Z - center.Z) < 110 and math.abs(root.Position.X - center.X) < 200
end

local function activeQuest()
    local data = readJson("QuestsJson")
    local active = type(data) == "table" and type(data.Active) == "table" and data.Active or {}
    for id, progress in pairs(active) do
        for _, q in ipairs(RepeatQuests) do
            if q.id == id then
                return q, tonumber(progress) or 0
            end
        end
        return { id = id, other = true }, tonumber(progress) or 0
    end
    return nil, 0
end

local function bestQuest(level)
    local best = nil
    for _, q in ipairs(RepeatQuests) do
        local z = q.target and zoneOfMob(q.target)
        if q.level <= level and z and not zoneBlocked(z) then
            best = q
        end
    end
    return best
end

local function stepQuests(level)
    local quest, progress = activeQuest()
    if quest and not quest.other then
        if progress >= quest.count then
            fire("QuestAction", "claim", quest.id)
            Game.questWait = os.clock() + 2
            return
        end
        local z = zoneOfMob(quest.target)
        local best = bestQuest(level)
        if not z or zoneBlocked(z) or (best and best.level > quest.level) then
            fire("QuestAction", "abandon", quest.id)
            Game.questWait = os.clock() + 2
        end
        return
    end
    if quest then
        return
    end
    local best = bestQuest(level)
    if best then
        fire("QuestAction", "accept", best.id)
        Game.questWait = os.clock() + 2
    end
end

local function bossRoomFor(fieldId)
    for _, z in ipairs(LevelZones) do
        if z.bossRoom and z.unlocks == fieldId then
            return z
        end
    end
    return nil
end

local function planLeveling(level)
    local field = nil
    for _, z in ipairs(LevelZones) do
        if not z.bossRoom and z.minLevel <= level then
            if zoneBlocked(z) then
                local room = bossRoomFor(z.id)
                if Flags.LevelBosses and room and room.minLevel <= level and not zoneBlocked(room) then
                    return { zone = room, mobIds = { [room.boss] = true }, prefer = room.boss, boss = true }
                end
                break
            end
            field = z
        end
    end
    local quest, progress = activeQuest()
    if Flags.LevelQuests and quest and not quest.other and progress < quest.count then
        local qz = zoneOfMob(quest.target)
        if qz and not zoneBlocked(qz) then
            field = qz
        end
    end
    if not field then
        return nil
    end
    local ids = {}
    for _, id in ipairs(field.ids) do
        if not tostring(id):match("^boss_") then
            ids[id] = true
        end
    end
    local prefer = quest and not quest.other and quest.target or nil
    return { zone = field, mobIds = ids, prefer = prefer }
end

local function stepLeveling()
    local _, root = getRoot()
    if not root then
        return
    end
    local level = tonumber(LocalPlayer:GetAttribute("Level")) or 1
    if Flags.LevelQuests and os.clock() > Game.questWait then
        stepQuests(level)
    end
    local plan = planLeveling(level)
    Game.levelPlan = plan
    if not plan then
        Game.levelStatus = "No reachable zone"
        return
    end
    local quest, progress = activeQuest()
    local questText = quest and not quest.other and ("%s %d/%d"):format(quest.id, progress, quest.count) or "none"
    Game.levelStatus = ("Lv %d | %s%s | Quest %s"):format(level, plan.zone.id, plan.boss and " (boss)" or "", questText)
    if Game.busy then
        return
    end
    local pending = Game.levelTravel
    if pending and os.clock() - pending.at > 4 then
        Game.levelTravel = nil
        if pending.zone == plan.zone.id and not inZone(root, plan.zone) then
            Game.blockedZones[plan.zone.id] = os.clock() + 300
            Game.levelPlan = nil
            return
        end
    end
    if not Game.levelTravel and not inZone(root, plan.zone) then
        local center = zoneCenter(plan.zone.id)
        if center then
            Game.target = nil
            pcall(function()
                LocalPlayer:RequestStreamAroundAsync(center, 5)
            end)
            root.CFrame = CFrame.new(center)
            root.AssemblyLinearVelocity = Vector3.zero
            Game.levelTravel = { zone = plan.zone.id, at = os.clock() }
        end
    end
end

local function stepFarm()
    if Game.busy then
        return
    end
    local _, root = getRoot()
    if not root then
        return
    end
    local target = findTarget(root)
    if target ~= Game.target then
        Game.target = target
        Game.lastTargetFire = 0
    end
    if not target then
        if not Flags.Leveling then
            travelToWanted(root)
        end
        return
    end
    Game.travelIndex = 0
    setCurrentTarget(target)
    if os.clock() - Game.lastTargetFire > 1 then
        Game.lastTargetFire = os.clock()
        fire("SetTarget", target, false, true)
    end
end

local function learnedSkills()
    local out = {}
    local skills = readJson("SkillsJson")
    if type(skills) == "table" then
        for id, level in pairs(skills) do
            if type(id) == "string" and (tonumber(level) or 0) > 0 then
                table.insert(out, id)
            end
        end
    end
    table.sort(out)
    return out
end

local function selectedList(set)
    local out = {}
    for key, on in pairs(set) do
        if on then
            table.insert(out, key)
        end
    end
    table.sort(out)
    return out
end

local function stepSkills()
    local target = Game.target
    if not mobAlive(target) then
        return
    end
    local list = selectedList(Flags.Skills)
    if #list == 0 then
        return
    end
    Game.skillIndex = Game.skillIndex % #list + 1
    fire("UseSkill", list[Game.skillIndex], target)
end

local function potionOptions()
    local out = {}
    if type(ItemData) ~= "table" then
        return out
    end
    local src = type(ItemData.Items) == "table" and ItemData.Items or ItemData
    for id, def in pairs(src) do
        if type(def) == "table" and def.Kind == "usable" and (def.HealMin or def.SpPercent or def.Duration) then
            table.insert(out, id)
        end
    end
    table.sort(out)
    return out
end

local function stepPotions()
    local items = readJson("ItemsJson") or {}
    local hpPct, spPct = math.floor(Flags.HpPercent / 5) * 5, math.floor(Flags.SpPercent / 5) * 5
    for id in pairs(Flags.Potions) do
        local def = itemDef(id)
        local count = tonumber(items[id]) or 0
        if def and count > 0 then
            if def.HealMin then
                if LocalPlayer:GetAttribute("PotionHpNow") ~= id then
                    fire("SetPotionSlot", "hp", id)
                end
                if tonumber(LocalPlayer:GetAttribute("PotionHpPercent")) ~= hpPct then
                    fire("SetPotionAuto", "hp", hpPct)
                end
            elseif def.SpPercent then
                if LocalPlayer:GetAttribute("PotionSpNow") ~= id then
                    fire("SetPotionSlot", "sp", id)
                end
                if tonumber(LocalPlayer:GetAttribute("PotionSpPercent")) ~= spPct then
                    fire("SetPotionAuto", "sp", spPct)
                end
            elseif def.Duration then
                local last = Game.buffUsed[id]
                if not last or os.clock() - last > (tonumber(def.Duration) or 600) then
                    Game.buffUsed[id] = os.clock()
                    fire("UseItem", id)
                end
            end
        end
    end
end

local function stepRewards()
    local daily = readJson("DailyJson")
    if type(daily) == "table" and daily.CanClaim == true then
        fire("DailyClaim")
    end
    local rewards = readJson("RewardsJson")
    if type(rewards) ~= "table" then
        return
    end
    local online = rewards.Online
    if type(online) == "table" and (tonumber(LocalPlayer:GetAttribute("RewardsReady")) or 0) > 0 then
        local got = {}
        for _, v in ipairs(type(online.Got) == "table" and online.Got or {}) do
            got[tonumber(v) or v] = true
        end
        for i = 1, 12 do
            if not got[i] then
                fire("RewardAction", "online", i)
                task.wait(0.2)
            end
        end
    end
    local c8 = rewards.C8
    if type(c8) == "table" and c8.Can == true then
        fire("RewardAction", "c8", nil)
    end
    local month = rewards.Month
    if type(month) == "table" then
        local claimed = false
        for _, day in ipairs(type(month.Days) == "table" and month.Days or {}) do
            if tonumber(day) == tonumber(month.Today) then
                claimed = true
            end
        end
        if not claimed then
            fire("RewardAction", "month", nil)
        end
    end
end

local function stepGear()
    if LocalPlayer:GetAttribute("AutoEquip") ~= true then
        Game.gearSetByUs = true
        fire("SetAutoEquip", true)
    end
end

local function stepCards()
    fire("CardAction", "auto")
end

local function gearName(gid, gear)
    if GearUtil and type(GearUtil.Resolve) == "function" then
        local ok, def = pcall(GearUtil.Resolve, gid, gear)
        if ok and type(def) == "table" then
            return def.Name, def.Kind, def
        end
    end
    local entry = gear[gid]
    local def = type(entry) == "table" and itemDef(entry.Id)
    if def then
        return def.Name, def.Kind
    end
    return nil, nil
end

local function ownedWeapons()
    local out = {}
    local gear = readJson("GearJson") or {}
    local refine = readJson("RefineJson") or {}
    for gid in pairs(gear) do
        local name, kind = gearName(gid, gear)
        if kind == "weapon" then
            local _, _, def = gearName(gid, gear)
            table.insert(out, { gid = gid, name = name or gid, level = tonumber(refine[gid]) or 0, def = def })
        end
    end
    table.sort(out, function(a, b)
        return a.gid < b.gid
    end)
    return out
end

local function weaponLabel(w)
    return ("%s +%d [%s]"):format(w.name, w.level, w.gid)
end

local function weaponOptions()
    local out = {}
    for _, w in ipairs(ownedWeapons()) do
        table.insert(out, weaponLabel(w))
    end
    return out
end

local function refineMax()
    return tonumber(RefineConfig.Max) or 10
end

local function refineChance(level)
    local chances = RefineConfig.Chance
    return type(chances) == "table" and tonumber(chances[level + 1]) or 0
end

local function refineCost(w)
    if w.def and GearUtil and type(GearUtil.RefineCost) == "function" then
        local ok, cost = pcall(GearUtil.RefineCost, w.def, w.level + 1)
        if ok and tonumber(cost) then
            return tonumber(cost)
        end
    end
    return math.huge
end

local function refineAllowed(w)
    if w.level >= math.min(Flags.RefineTarget, refineMax()) then
        return false
    end
    if Flags.RefineSafeOnly and refineChance(w.level) < 100 then
        return false
    end
    local gold = tonumber(LocalPlayer:GetAttribute("Silver")) or 0
    return gold - refineCost(w) >= Flags.RefineGoldReserve
end

local function blacksmithPosition()
    local npcs = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("NPCs")
    local npc = npcs and npcs:FindFirstChild("blacksmith")
    return npc and npc:GetPivot().Position or nil
end

local RefineStatusLabel = nil

local function setRefineStatus(text)
    if RefineStatusLabel and Game.refineStatus ~= text then
        Game.refineStatus = text
        pcall(RefineStatusLabel.SetText, RefineStatusLabel, "Status: " .. text)
    end
end

local function stepRefine()
    local items = readJson("ItemsJson") or {}
    local stones = tonumber(items.refine_stone) or 0
    if next(Flags.RefineWeapons) == nil then
        setRefineStatus("No weapon selected")
        return
    end
    if stones <= 0 then
        setRefineStatus("No Refine Stones")
        return
    end
    local pick, blocked = nil, nil
    for _, w in ipairs(ownedWeapons()) do
        if Flags.RefineWeapons[w.gid] then
            if refineAllowed(w) then
                pick = w
                break
            end
            blocked = w
        end
    end
    if not pick then
        if blocked and blocked.level < Flags.RefineTarget then
            setRefineStatus(("Waiting: %s +%d (gold or chance limit)"):format(blocked.name, blocked.level))
        else
            setRefineStatus("Done: selected weapons reached target")
        end
        return
    end
    setRefineStatus(("Refining %s +%d -> +%d (%d%%, %d gold, %d stones)"):format(pick.name, pick.level, pick.level + 1, refineChance(pick.level), refineCost(pick), stones))
    local _, root = getRoot()
    local npcPos = blacksmithPosition()
    if not (root and npcPos) then
        return
    end
    Game.busy = true
    local back = root.CFrame
    if (root.Position - npcPos).Magnitude > 8 then
        standNear(root, npcPos, 4)
        task.wait(0.4)
    end
    if not unloaded and Flags.AutoRefine then
        local chance = refineChance(pick.level)
        local protect = Flags.RefineProtect and chance < 100 and pick.level + 1 >= (tonumber(RefineConfig.DowngradeFrom) or 5) and pick.level > 0 and (tonumber(items.protection_stone) or 0) > 0
        local lucky = Flags.RefineLucky and chance < 100 and (tonumber(items.lucky_stone) or 0) > 0
        fire("RefineWeapon", pick.gid, protect == true, lucky == true, true)
        task.wait(math.max(Flags.RefineDelay, 0.5))
    end
    if not Flags.AutoFarm then
        root.CFrame = back
    end
    Game.busy = false
end

local SellStatusLabel = nil

local function setSellStatus(text)
    if SellStatusLabel and Game.sellStatus ~= text then
        Game.sellStatus = text
        pcall(SellStatusLabel.SetText, SellStatusLabel, "Status: " .. text)
    end
end

local function sellKindOptions()
    local seen, out = {}, {}
    if type(ItemData) == "table" then
        local src = type(ItemData.Items) == "table" and ItemData.Items or ItemData
        for _, def in pairs(src) do
            if type(def) == "table" and type(def.Kind) == "string" and (tonumber(def.Sell) or 0) > 0 and not seen[def.Kind] then
                seen[def.Kind] = true
                table.insert(out, def.Kind)
            end
        end
    end
    table.sort(out)
    table.insert(out, "Gear")
    return out
end

local function sellItemOptions()
    local out = {}
    if type(ItemData) == "table" then
        local src = type(ItemData.Items) == "table" and ItemData.Items or ItemData
        for id, def in pairs(src) do
            if type(def) == "table" and def.Name and (tonumber(def.Sell) or 0) > 0 then
                table.insert(out, ("%s [%s]"):format(def.Name, id))
            end
        end
    end
    table.sort(out)
    return out
end

local function sellList()
    local items = readJson("ItemsJson") or {}
    local locks = readJson("LocksJson") or {}
    local refine = readJson("RefineJson") or {}
    local junkKeep = type(GameConfig) == "table" and type(GameConfig.JunkKeep) == "table" and GameConfig.JunkKeep or {}
    local equipped = {}
    local weapon = LocalPlayer:GetAttribute("WeaponId")
    if type(weapon) == "string" and weapon ~= "" then
        equipped[weapon] = 1
    end
    for _, v in pairs(readJson("EquipJson") or {}) do
        if type(v) == "string" and v ~= "" then
            equipped[v] = (equipped[v] or 0) + 1
        end
    end
    local list = {}
    for id, count in pairs(items) do
        local def = itemDef(id)
        if def and def.Name and type(count) == "number" and not locks[id] and (tonumber(def.Sell) or 0) > 0
            and Flags.SellKinds[def.Kind] and not Flags.SellKeep[id] and not junkKeep[id] then
            local amount = count - (equipped[id] or 0) - Flags.SellKeepAmount
            if amount > 0 then
                table.insert(list, { id, amount })
            end
        end
    end
    if Flags.SellKinds.Gear then
        local gear = readJson("GearJson") or {}
        for gid in pairs(gear) do
            local _, _, def = gearName(gid, gear)
            if def and not equipped[gid] and not locks[gid] and (tonumber(def.Sell) or 0) > 0
                and not (Flags.SellKeepRefined and (tonumber(refine[gid]) or 0) > 0) then
                table.insert(list, { gid, 1 })
            end
        end
    end
    return list
end

local function merchantPosition()
    local npcs = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("NPCs")
    if not npcs then
        return nil
    end
    for _, npc in ipairs(npcs:GetChildren()) do
        if npc:GetAttribute("NpcId") == "merchant" or npc.Name == "merchant" then
            return npc:GetPivot().Position
        end
    end
    return nil
end

local function sellDue()
    if Flags.SellTrigger == "Interval" then
        return os.clock() - (Game.lastSell or 0) >= Flags.SellInterval
    end
    local used = tonumber(LocalPlayer:GetAttribute("BagSlotsUsed")) or 0
    local max = tonumber(LocalPlayer:GetAttribute("BagSlotsMax")) or 0
    return max > 0 and used / max * 100 >= Flags.SellBagPercent
end

local function stepSell()
    local list = sellList()
    if #list == 0 and not Flags.SellJunk then
        setSellStatus("Nothing to sell")
        return
    end
    if not sellDue() then
        setSellStatus(("Waiting | Bag %s/%s"):format(tostring(LocalPlayer:GetAttribute("BagSlotsUsed") or "?"), tostring(LocalPlayer:GetAttribute("BagSlotsMax") or "?")))
        return
    end
    if Game.busy then
        return
    end
    local _, root = getRoot()
    local npcPos = merchantPosition()
    if not (root and npcPos) then
        setSellStatus("Merchant not found")
        return
    end
    Game.busy = true
    local back = root.CFrame
    if (root.Position - npcPos).Magnitude > 8 then
        pcall(function()
            LocalPlayer:RequestStreamAroundAsync(npcPos, 5)
        end)
        standNear(root, npcPos, 4)
        task.wait(0.4)
    end
    if not unloaded and Flags.AutoSell then
        local before = tonumber(LocalPlayer:GetAttribute("Silver")) or 0
        if #list > 0 then
            fire("ShopSellMany", list)
            task.wait(0.6)
        end
        if Flags.SellJunk and not unloaded and Flags.AutoSell then
            fire("ShopSellJunk")
            task.wait(0.6)
        end
        Game.lastSell = os.clock()
        local gained = (tonumber(LocalPlayer:GetAttribute("Silver")) or 0) - before
        setSellStatus(("Sold %d entries, +%d gold"):format(#list, gained))
    end
    if not Flags.AutoFarm then
        root.CFrame = back
    end
    Game.busy = false
end

local STAT_NAMES = { "STR", "AGI", "VIT", "INT", "DEX", "LUK" }

local function buildOptions()
    local out = {}
    local job = LocalPlayer:GetAttribute("Job")
    local jobs = type(BuildData) == "table" and BuildData.Jobs
    if type(jobs) == "table" and type(jobs[job]) == "table" then
        for id in pairs(jobs[job]) do
            table.insert(out, "Build: " .. tostring(id))
        end
        table.sort(out)
    end
    for _, stat in ipairs(STAT_NAMES) do
        table.insert(out, "Stat: " .. stat)
    end
    return out
end

local function stepStats()
    local choice = Flags.StatChoice
    if type(choice) ~= "string" then
        return
    end
    local build = choice:match("^Build: (.+)$")
    if build then
        if LocalPlayer:GetAttribute("AutoBuild") ~= build then
            fire("ApplyBuild", build, true)
        end
        return
    end
    local stat = choice:match("^Stat: (.+)$")
    if not stat then
        return
    end
    if (LocalPlayer:GetAttribute("AutoBuild") or "manual") ~= "manual" then
        fire("SetAutoBuild", "manual")
        return
    end
    if (tonumber(LocalPlayer:GetAttribute("StatPoints")) or 0) > 0 then
        fire("AllocateStat", stat)
    end
end

local function dropReady(part, now)
    local freeAt = tonumber(part:GetAttribute("FreeAt")) or 0
    local owner = tonumber(part:GetAttribute("OwnerUserId")) or 0
    return owner == 0 or owner == LocalPlayer.UserId or freeAt <= now
end

local function stepDrops()
    local _, root = getRoot()
    if not root then
        return
    end
    local now = workspace:GetServerTimeNow()
    for _, part in ipairs(CollectionService:GetTagged("Drop")) do
        if unloaded or not Flags.AutoDrops then
            break
        end
        if part:IsA("BasePart") and part.Parent and dropReady(part, now) then
            Game.busy = true
            root.CFrame = CFrame.new(part.Position + Vector3.new(0, 2.5, 0))
            root.AssemblyLinearVelocity = Vector3.zero
            task.wait(0.15)
            fire("PickupDrop")
            task.wait(0.3)
        end
    end
    Game.busy = false
end

local function boxPosition(box)
    if box:IsA("BasePart") then
        return box.Position
    end
    if box:IsA("Model") then
        return box:GetPivot().Position
    end
    return nil
end

local function stepBoxes()
    local _, root = getRoot()
    if not root then
        return
    end
    for _, box in ipairs(CollectionService:GetTagged("LootBox")) do
        if unloaded or not Flags.AutoBoxes then
            break
        end
        local pos = box.Parent and dropReady(box, workspace:GetServerTimeNow()) and boxPosition(box)
        if pos then
            Game.busy = true
            standNear(root, pos, 3)
            task.wait(0.2)
            fire("OpenLootBox", box)
            local prompt = box:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt and type(fireproximityprompt) == "function" then
                pcall(fireproximityprompt, prompt)
            end
            task.wait(0.6)
        end
    end
    Game.busy = false
end

local function applyWalkSpeed()
    local humanoid = select(1, getRoot())
    if not humanoid then
        return
    end
    if Flags.WalkSpeedEnabled then
        if walkSpeedRestore[humanoid] == nil then
            walkSpeedRestore[humanoid] = humanoid.WalkSpeed
        end
        humanoid.WalkSpeed = Flags.WalkSpeed
    elseif walkSpeedRestore[humanoid] ~= nil then
        humanoid.WalkSpeed = walkSpeedRestore[humanoid]
        walkSpeedRestore[humanoid] = nil
    end
end

local function setWalkSpeedEnabled(value)
    Flags.WalkSpeedEnabled = value == true
    applyWalkSpeed()
end

local function setWalkSpeed(value)
    Flags.WalkSpeed = tonumber(value) or Flags.WalkSpeed
    if Flags.WalkSpeedEnabled then
        applyWalkSpeed()
    end
end

local function setAlwaysSprint(value)
    Flags.AlwaysSprint = value == true
    if sprintConn then
        sprintConn:Disconnect()
        sprintConn = nil
    end
    if not Flags.AlwaysSprint then
        if sprintRestore ~= nil then
            LocalPlayer:SetAttribute("LumiSprintLock", sprintRestore)
            sprintRestore = nil
        end
        return
    end
    if sprintRestore == nil then
        sprintRestore = LocalPlayer:GetAttribute("LumiSprintLock") == true
    end
    LocalPlayer:SetAttribute("LumiSprintLock", true)
    sprintConn = track(LocalPlayer:GetAttributeChangedSignal("LumiSprintLock"):Connect(function()
        if Flags.AlwaysSprint and not unloaded and LocalPlayer:GetAttribute("LumiSprintLock") ~= true then
            LocalPlayer:SetAttribute("LumiSprintLock", true)
        end
    end))
end

local function setInfJump(value)
    Flags.InfJump = value == true
    if infJumpConn then
        infJumpConn:Disconnect()
        infJumpConn = nil
    end
    if not Flags.InfJump then
        return
    end
    infJumpConn = track(UserInputService.JumpRequest:Connect(function()
        if unloaded or not Flags.InfJump then
            return
        end
        local humanoid = select(1, getRoot())
        if humanoid then
            humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end))
end

local function setNoClip(value)
    Flags.NoClip = value == true
    if noclipConn then
        noclipConn:Disconnect()
        noclipConn = nil
    end
    if not Flags.NoClip then
        for part, canCollide in pairs(noclipRestore) do
            if part.Parent then
                part.CanCollide = canCollide
            end
        end
        table.clear(noclipRestore)
        return
    end
    noclipConn = track(RunService.Stepped:Connect(function()
        if unloaded or not Flags.NoClip then
            return
        end
        local character = LocalPlayer.Character
        if not character then
            return
        end
        for _, part in ipairs(character:GetDescendants()) do
            if part:IsA("BasePart") then
                if noclipRestore[part] == nil then
                    noclipRestore[part] = part.CanCollide
                end
                part.CanCollide = false
            end
        end
    end))
end

local function snapshotPrompt(prompt)
    if promptRestore[prompt] == nil then
        promptRestore[prompt] = {
            HoldDuration = prompt.HoldDuration,
            MaxActivationDistance = prompt.MaxActivationDistance,
            RequiresLineOfSight = prompt.RequiresLineOfSight,
        }
    end
    prompt.HoldDuration = 0
    prompt.MaxActivationDistance = 50
    prompt.RequiresLineOfSight = false
end

local function setInstantProximityPrompt(value)
    Flags.InstantProximityPrompt = value == true
    if promptConn then
        promptConn:Disconnect()
        promptConn = nil
    end
    if not Flags.InstantProximityPrompt then
        for prompt, prev in pairs(promptRestore) do
            if prompt.Parent then
                prompt.HoldDuration = prev.HoldDuration
                prompt.MaxActivationDistance = prev.MaxActivationDistance
                prompt.RequiresLineOfSight = prev.RequiresLineOfSight
            end
        end
        table.clear(promptRestore)
        return
    end
    for _, inst in ipairs(workspace:GetDescendants()) do
        if inst:IsA("ProximityPrompt") then
            snapshotPrompt(inst)
        end
    end
    promptConn = track(workspace.DescendantAdded:Connect(function(inst)
        if unloaded or not Flags.InstantProximityPrompt then
            return
        end
        if inst:IsA("ProximityPrompt") then
            snapshotPrompt(inst)
        end
    end))
end

local function stopFly()
    if flyState and flyState.conn then
        flyState.conn:Disconnect()
    end
    local humanoid = flyState and flyState.humanoid
    if humanoid and humanoid.Parent and flyState.platformStand ~= nil then
        humanoid.PlatformStand = flyState.platformStand
    end
    flyState = nil
end

local function setFly(value)
    Flags.Fly = value == true
    stopFly()
    if not Flags.Fly then
        return
    end
    local humanoid, root = getRoot()
    if not (humanoid and root) then
        return
    end
    flyState = {
        humanoid = humanoid,
        root = root,
        platformStand = humanoid.PlatformStand,
    }
    humanoid.PlatformStand = true
    flyState.conn = track(RunService.RenderStepped:Connect(function()
        if unloaded or not Flags.Fly then
            return
        end
        if UserInputService:GetFocusedTextBox() then
            return
        end
        local hum, hrp = getRoot()
        if not (hum and hrp) then
            return
        end
        local cam = workspace.CurrentCamera
        if not cam then
            return
        end
        local move = Vector3.zero
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then
            move += cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then
            move -= cam.CFrame.LookVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then
            move -= cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then
            move += cam.CFrame.RightVector
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
            move += Vector3.yAxis
        end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then
            move -= Vector3.yAxis
        end
        if move.Magnitude > 0 then
            hrp.AssemblyLinearVelocity = move.Unit * Flags.FlySpeed
        else
            hrp.AssemblyLinearVelocity = Vector3.zero
        end
        hum.PlatformStand = true
    end))
end

local function setFlySpeed(value)
    Flags.FlySpeed = tonumber(value) or Flags.FlySpeed
end

local function setAutoReconnect(value)
    Flags.AutoReconnect = value == true
    reconnectToken += 1
    if reconnectConn then
        reconnectConn:Disconnect()
        reconnectConn = nil
    end
    if reconnectFailedConn then
        reconnectFailedConn:Disconnect()
        reconnectFailedConn = nil
    end
    if not Flags.AutoReconnect then
        return
    end
    local attempt = 0
    local function tryReconnect(token)
        if unloaded or not Flags.AutoReconnect or reconnectToken ~= token then
            return
        end
        attempt += 1
        if attempt == 1 then
            pcall(function()
                TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
            end)
        elseif attempt == 2 then
            pcall(function()
                TeleportService:Teleport(game.PlaceId, LocalPlayer)
            end)
        else
            warn("[HuntingTogether] auto reconnect: attempts exhausted")
        end
    end
    reconnectConn = track(GuiService.ErrorMessageChanged:Connect(function(message)
        if unloaded or not Flags.AutoReconnect or attempt > 0 or message == "" then
            return
        end
        local token = reconnectToken
        task.delay(1.5, tryReconnect, token)
    end))
    reconnectFailedConn = track(TeleportService.TeleportInitFailed:Connect(function(player)
        if player ~= LocalPlayer or unloaded or not Flags.AutoReconnect or attempt == 0 then
            return
        end
        local token = reconnectToken
        task.delay(3, tryReconnect, token)
    end))
end

local function setDisable3D(value)
    Flags.Disable3DRendering = value == true
    if Flags.Disable3DRendering then
        pcall(function()
            RunService:Set3dRenderingEnabled(false)
        end)
        if not renderBacking then
            local gui = Instance.new("ScreenGui")
            gui.Name = "OuroborosRenderBacking"
            gui.IgnoreGuiInset = true
            gui.DisplayOrder = -100
            gui.ResetOnSpawn = false
            local frame = Instance.new("Frame")
            frame.BackgroundColor3 = Color3.new(0, 0, 0)
            frame.Size = UDim2.fromScale(1, 1)
            frame.BorderSizePixel = 0
            frame.Parent = gui
            gui.Parent = LocalPlayer:WaitForChild("PlayerGui")
            renderBacking = gui
        end
    else
        pcall(function()
            RunService:Set3dRenderingEnabled(true)
        end)
        if renderBacking then
            renderBacking:Destroy()
            renderBacking = nil
        end
    end
end

local function captureFps(inst)
    if fpsRestore[inst] ~= nil then
        return
    end
    local snap = {}
    if inst:IsA("ParticleEmitter") or inst:IsA("Trail") or inst:IsA("Beam") or inst:IsA("Fire") or inst:IsA("Smoke") or inst:IsA("Sparkles") then
        snap.Enabled = inst.Enabled
        inst.Enabled = false
    elseif inst:IsA("Explosion") then
        snap.Visible = inst.Visible
        inst.Visible = false
    end
    fpsRestore[inst] = snap
end


local function setFpsBoost(value)
    Flags.FpsBoost = value == true
    if fpsConn then
        fpsConn:Disconnect()
        fpsConn = nil
    end
    if not Flags.FpsBoost then
        for inst, snap in pairs(fpsRestore) do
            if typeof(inst) == "Instance" and inst.Parent then
                for key, prev in pairs(snap) do
                    pcall(function()
                        inst[key] = prev
                    end)
                end
            end
        end
        local light = fpsRestore.Lighting
        if light then
            Lighting.GlobalShadows = light.GlobalShadows
            Lighting.FogEnd = light.FogEnd
        end
        table.clear(fpsRestore)
        return
    end
    if fpsRestore.Lighting == nil then
        fpsRestore.Lighting = {
            GlobalShadows = Lighting.GlobalShadows,
            FogEnd = Lighting.FogEnd,
        }
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 1e6
    end
    for _, inst in ipairs(workspace:GetDescendants()) do
        captureFps(inst)
    end
    fpsConn = track(workspace.DescendantAdded:Connect(function(inst)
        if unloaded or not Flags.FpsBoost then
            return
        end
        captureFps(inst)
    end))
end

local AntiAfk = {
    Enabled = false,
    Disabled = {},
    Fallback = nil,
    Worker = nil,
}

function AntiAfk.disableIdled()
    if type(getconnections) == "function" then
        local ok, list = pcall(getconnections, LocalPlayer.Idled)
        if ok and type(list) == "table" then
            for _, conn in ipairs(list) do
                if type(conn) == "table" or typeof(conn) == "userdata" then
                    local disabled = pcall(function()
                        conn:Disable()
                    end)
                    if disabled and not table.find(AntiAfk.Disabled, conn) then
                        table.insert(AntiAfk.Disabled, conn)
                    end
                end
            end
            return
        end
    end
    if not AntiAfk.Fallback then
        AntiAfk.Fallback = track(LocalPlayer.Idled:Connect(function()
            if unloaded or not AntiAfk.Enabled then
                return
            end
            local sent = pcall(function()
                local vim = game:GetService("VirtualInputManager")
                vim:SendKeyEvent(true, Enum.KeyCode.Unknown, false, game)
                vim:SendKeyEvent(false, Enum.KeyCode.Unknown, false, game)
            end)
            if not sent then
                pcall(function()
                    local cam = workspace.CurrentCamera
                    VirtualUser:Button2Down(Vector2.zero, cam.CFrame)
                    task.wait(0.1)
                    VirtualUser:Button2Up(Vector2.zero, cam.CFrame)
                end)
            end
        end))
    end
end

function AntiAfk.restoreIdled()
    for _, conn in ipairs(AntiAfk.Disabled) do
        local ok, err = pcall(function()
            conn:Enable()
        end)
        if not ok then
            warn("[HuntingTogether] anti afk restore: " .. tostring(err))
        end
    end
    table.clear(AntiAfk.Disabled)
    if AntiAfk.Fallback then
        AntiAfk.Fallback:Disconnect()
        AntiAfk.Fallback = nil
    end
end

local function setAntiAfk(value)
    AntiAfk.Enabled = value == true
    if AntiAfk.Enabled then
        AntiAfk.disableIdled()
        if not AntiAfk.Worker then
            AntiAfk.Worker = task.spawn(function()
                while AntiAfk.Enabled and not unloaded do
                    task.wait(30)
                    if not AntiAfk.Enabled or unloaded then
                        break
                    end
                    AntiAfk.disableIdled()
                end
                AntiAfk.Worker = nil
            end)
        end
    else
        AntiAfk.restoreIdled()
    end
end

local function bindCharacter(character)
    task.defer(function()
        if unloaded then
            return
        end
        applyWalkSpeed()
        if Flags.Fly then
            setFly(true)
        end
    end)
    local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
    if humanoid then
        track(humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
            if Flags.WalkSpeedEnabled and not unloaded then
                if humanoid.WalkSpeed ~= Flags.WalkSpeed then
                    humanoid.WalkSpeed = Flags.WalkSpeed
                end
            end
        end))
    end
end

local WORKER_STEPS = {
    AutoFarm = { 0.15, stepFarm },
    AutoSkills = { 0.5, stepSkills },
    AutoPotions = { 2, stepPotions },
    AutoRewards = { 30, stepRewards },
    AutoGear = { 10, stepGear },
    AutoCards = { 30, stepCards },
    AutoStats = { 1, stepStats },
    AutoDrops = { 0.5, stepDrops },
    AutoBoxes = { 0.5, stepBoxes },
    AutoRefine = { 0.5, stepRefine },
    AutoSell = { 1, stepSell },
    Leveling = { 1, stepLeveling },
}

local function setFeature(key, value)
    Flags[key] = value == true
    local spec = WORKER_STEPS[key]
    if spec then
        setWorker(key, Flags[key], spec[1], spec[2])
    end
    if key == "Leveling" then
        Game.levelPlan = nil
        Game.levelTravel = nil
        Game.target = nil
        table.clear(Game.blockedZones)
        if not Flags.Leveling then
            Game.levelStatus = "Idle"
        end
    end
    if key == "AutoRefine" and not Flags.AutoRefine then
        setRefineStatus("Idle")
    end
    if key == "AutoSell" and not Flags.AutoSell then
        setSellStatus("Idle")
    end
    if key == "AutoFarm" then
        if Game.followConn then
            Game.followConn:Disconnect()
            Game.followConn = nil
        end
        if Flags.AutoFarm then
            Game.followConn = track(RunService.Heartbeat:Connect(followStep))
        else
            Game.target = nil
            pcall(setCurrentTarget, nil)
        end
    end
    if key == "AutoGear" and not Flags.AutoGear and Game.gearSetByUs then
        Game.gearSetByUs = false
        pcall(fire, "SetAutoEquip", false)
    end
end

local function stop()
    if unloaded then
        return
    end
    local ok, err = pcall(function()
        for key in pairs(WORKER_STEPS) do
            setFeature(key, false)
        end
        Game.busy = false
        setWalkSpeedEnabled(false)
        setInfJump(false)
        setAlwaysSprint(false)
        setNoClip(false)
        setInstantProximityPrompt(false)
        setFly(false)
        setAutoReconnect(false)
        setDisable3D(false)
        setFpsBoost(false)
        setAntiAfk(false)
    end)
    if not ok then
        warn("[HuntingTogether] cleanup: " .. tostring(err))
    end
    unloaded = true
    for _, conn in ipairs(connections) do
        pcall(function()
            conn:Disconnect()
        end)
    end
    table.clear(connections)
end

track(LocalPlayer.CharacterAdded:Connect(bindCharacter))
if LocalPlayer.Character then
    bindCharacter(LocalPlayer.Character)
end

-- UI modules are embedded below; no FlowAuth or GitHub module-loader is needed.
local function loadEmbeddedModule(source, chunkName)
    local compiler = loadstring
    if type(compiler) ~= "function" then
        error("loadstring is unavailable in this executor", 0)
    end
    local chunk, compileError = compiler(source, chunkName)
    if type(chunk) ~= "function" then
        error("failed to compile " .. chunkName .. ": " .. tostring(compileError), 0)
    end
    local ok, result = pcall(chunk)
    if not ok then
        error("failed to initialize " .. chunkName .. ": " .. tostring(result), 0)
    end
    if type(result) ~= "table" then
        error(chunkName .. " did not return a table", 0)
    end
    return result
end

Library = loadEmbeddedModule(
[===[local cloneref = (cloneref or clonereference or function(instance: any)
    return instance
end)
local CoreGui: CoreGui = cloneref(game:GetService("CoreGui"))
local GuiService: GuiService = cloneref(game:GetService("GuiService"))
local Players: Players = cloneref(game:GetService("Players"))
local RunService: RunService = cloneref(game:GetService("RunService"))
local SoundService: SoundService = cloneref(game:GetService("SoundService"))
local UserInputService: UserInputService = cloneref(game:GetService("UserInputService"))
local TextService: TextService = cloneref(game:GetService("TextService"))
local Teams: Teams = cloneref(game:GetService("Teams"))
local TweenService: TweenService = cloneref(game:GetService("TweenService"))

local getgenv = getgenv or function()
    return shared
end
local setclipboard = setclipboard or nil
local request = request or http_request or nil
local protectgui = protectgui or (syn and syn.protect_gui) or function() end
local gethui = gethui or function()
    return CoreGui
end

local LocalPlayer = Players.LocalPlayer or Players.PlayerAdded:Wait()
local Mouse = cloneref(LocalPlayer:GetMouse())

local Labels = {}
local Buttons = {}
local Toggles = {}
local Options = {}
local Tooltips = {}

local BaseURL = "https://raw.githubusercontent.com/joustingmatch/Ouroidian/refs/heads/main/"
local CustomImageManager = {}
local CustomImageManagerAssets = {
    TransparencyTexture = {
        RobloxId = 139785960036434,
        Path = "Obsidian/assets/TransparencyTexture.png",
        URL = BaseURL .. "assets/TransparencyTexture.png",

        Id = nil,
    },

    SaturationMap = {
        RobloxId = 4155801252,
        Path = "Obsidian/assets/SaturationMap.png",
        URL = BaseURL .. "assets/SaturationMap.png",

        Id = nil,
    },

    LoadingIcon = {
        RobloxId = 97544096941083,
        Path = "Obsidian/assets/LoadingIcon.png",
        URL = BaseURL .. "assets/LoadingIcon.png",

        Id = nil,
    },

    CheckIcon = {
        RobloxId = 97682394690683,
        Path = "Obsidian/assets/CheckIcon.png",
        URL = BaseURL .. "assets/CheckIcon.png",

        Id = nil,
    },

    DiscordIcon = {
        RobloxId = 0,
        Path = "Obsidian/assets/DiscordIcon.png",
        URL = BaseURL .. "assets/DiscordIcon.png",

        Id = nil,
    },
}
do
    local function RecursiveCreatePath(Path: string, IsFile: boolean?)
        if not isfolder or not makefolder then
            return
        end

        local Segments = Path:split("/")
        local TraversedPath = ""

        if IsFile then
            table.remove(Segments, #Segments)
        end

        for _, Segment in ipairs(Segments) do
            if not isfolder(TraversedPath .. Segment) then
                makefolder(TraversedPath .. Segment)
            end

            TraversedPath = TraversedPath .. Segment .. "/"
        end

        return TraversedPath
    end

    function CustomImageManager.AddAsset(
        AssetName: string,
        RobloxAssetId: number,
        URL: string,
        ForceRedownload: boolean?
    )
        if CustomImageManagerAssets[AssetName] ~= nil then
            error(string.format("Asset %q already exists", AssetName))
        end

        assert(typeof(RobloxAssetId) == "number", "RobloxAssetId must be a number")

        CustomImageManagerAssets[AssetName] = {
            RobloxId = RobloxAssetId,
            Path = string.format("Obsidian/custom_assets/%s", AssetName),
            URL = URL,

            Id = nil,
        }

        CustomImageManager.DownloadAsset(AssetName, ForceRedownload)
    end

    function CustomImageManager.GetAsset(AssetName: string)
        if not CustomImageManagerAssets[AssetName] then
            return nil
        end

        local AssetData = CustomImageManagerAssets[AssetName]
        if AssetData.Id then
            return AssetData.Id
        end

        local AssetID = string.format("rbxassetid://%s", AssetData.RobloxId)

        if getcustomasset then
            local Success, NewID = pcall(getcustomasset, AssetData.Path)

            if Success and NewID then
                AssetID = NewID
            end
        end

        AssetData.Id = AssetID
        return AssetID
    end

    function CustomImageManager.DownloadAsset(AssetName: string, ForceRedownload: boolean?)
        if not getcustomasset or not writefile or not isfile then
            return false, "missing functions"
        end

        local AssetData = CustomImageManagerAssets[AssetName]

        RecursiveCreatePath(AssetData.Path, true)

        if ForceRedownload ~= true and isfile(AssetData.Path) then
            return true, nil
        end

        local success, errorMessage = pcall(function()
            writefile(AssetData.Path, game:HttpGet(AssetData.URL))
        end)

        return success, errorMessage
    end

    for AssetName, _ in CustomImageManagerAssets do
        CustomImageManager.DownloadAsset(AssetName)
    end
end

local Library = {
    LocalPlayer = LocalPlayer,
    IsRobloxFocused = true,

    --// Device \\--
    DevicePlatform = nil,
    IsMobile = false,

    --// Obsidian Windows \\--
    ScreenGui = nil,
    Floats = nil,
    Overlay = nil,

    Window = nil,
    WindowContainer = nil,

    --// Search \\--
    SearchText = "",
    Searching = false,
    GlobalSearch = false,
    LastSearchTab = nil,

    --// Tabs \\--
    ActiveTab = nil,
    PreviousTab = nil,
    Tabs = {},
    TabButtons = {},

    --// Dependency Boxes \\--
    DependencyBoxes = {},

    --// Keybinds Frame \\--
    KeybindFrame = nil,
    KeybindContainer = nil,
    KeybindToggles = {},
    KeybindMenu = nil,

    --// Notifications \\--
    Notifications = {},
    NotifySide = "Right",
    NotifyTweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

    --// Dialogues \\--
    Dialogues = {},
    ActiveDialog = nil,

    --// Loading Window \\--
    ActiveLoading = nil,

    --// Context Menu \\--
    ContextMenus = {}, 

    --// Corners \\--
    Corners = {},
    SpecificCorners = {},

    --// Animations \\--
    TweenInfo = TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),

    TabTransitionInfo = TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    TabSwipeOffset = 26,
    TabSwipeFrom = "bottom",

    WindowAnimationInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    DropdownTransitionInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    KeyPickerTransitionInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    SettingsPopupTransitionInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quint, Enum.EasingDirection.Out),

    GroupboxTweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
    RotatingChevronTweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),

    Animations = {
        ToggleWindow = false,
        TabSwitch = false,
        Groupbox = false,
        Dropdown = false,
        KeyPicker = false,
        SettingsPopup = true
    },

    --// States \\--
    Toggled = false,
    Unloaded = false,

    --// Elements \\--
    Labels = Labels,
    Buttons = Buttons,
    Toggles = Toggles,
    Options = Options,

    --// Options \\--
    ToggleKeybind = Enum.KeyCode.RightControl,
    ShowToggleFrameInKeybinds = true,

    NotifyOnError = false,
    ForceCheckbox = false,

    CantDragForced = false,
    DraggableElements = {},

    --// Pop Out \\--
    PopOutSnapDistance = 80,
    PopOutDragThreshold = 8,
    PopOutHoldTime = 0.15,

    --// Signals \\--
    Signals = {},
    UnloadSignals = {},

    OriginalMinSize = Vector2.new(480, 360),
    MinSize = Vector2.new(480, 360),
    DPIScale = 1,
    CornerRadius = 4,

    --// Scheme \\--
    IsLightTheme = false,
    Scheme = {
        BackgroundColor = Color3.fromHex("151515"),
        MainColor = Color3.fromHex("1e1e1e"),
        AccentColor = Color3.fromHex("b7f34a"),
        OutlineColor = Color3.fromHex("303030"),
        FontColor = Color3.fromHex("f3f3ee"),
        Font = Font.fromEnum(Enum.Font.Code),

        RedColor = Color3.fromRGB(255, 50, 50),
        DestructiveColor = Color3.fromRGB(220, 38, 38),
        DarkColor = Color3.new(0, 0, 0),
        WhiteColor = Color3.new(1, 1, 1),

        BackgroundImage = ""
    },

    --// Registry \\--
    Registry = {},
    Scales = {},
    ScalesOffset = {},

    --// Mouse \\--
    OriginalMouseIconEnabled = UserInputService.MouseIconEnabled,
    ShowCursorBinding = string.sub(tostring({}), 10),

    --// Image Manager \\--
    ImageManager = CustomImageManager,

    --// Misc \\--
    Notify = nil, Toggle = nil -- we love luau lsp
}

if RunService:IsStudio() then
    if UserInputService.TouchEnabled and not UserInputService.MouseEnabled then
        Library.IsMobile = true
        Library.OriginalMinSize = Vector2.new(480, 240)
    else
        Library.IsMobile = false
        Library.OriginalMinSize = Vector2.new(480, 360)
    end
else
    pcall(function()
        Library.DevicePlatform = UserInputService:GetPlatform()
    end)

    Library.IsMobile = (Library.DevicePlatform == Enum.Platform.Android or Library.DevicePlatform == Enum.Platform.IOS)
    Library.OriginalMinSize = Library.IsMobile and Vector2.new(480, 240) or Vector2.new(480, 360)
end

local Templates = {
    --// UI \\--
    Frame = {
        BorderSizePixel = 0,
    },
    ImageLabel = {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
    },
    ImageButton = {
        AutoButtonColor = false,
        BorderSizePixel = 0,
    },
    ScrollingFrame = {
        BorderSizePixel = 0,
    },
    TextLabel = {
        BorderSizePixel = 0,
        FontFace = "Font",
        RichText = true,
        TextColor3 = "FontColor",
    },
    TextButton = {
        AutoButtonColor = false,
        BorderSizePixel = 0,
        FontFace = "Font",
        RichText = true,
        TextColor3 = "FontColor",
    },
    TextBox = {
        BorderSizePixel = 0,
        FontFace = "Font",
        PlaceholderColor3 = function()
            local H, S, V = Library.Scheme.FontColor:ToHSV()
            return Color3.fromHSV(H, S, V / 2)
        end,
        Text = "",
        TextColor3 = "FontColor",
    },
    UIListLayout = {
        SortOrder = Enum.SortOrder.LayoutOrder,
    },
    UIStroke = {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
    },

    --// Library \\--
    Window = {
        Title = "No Title",
        Subtitle = nil,
        Footer = "No Footer",

        Position = UDim2.fromOffset(6, 6),
        Size = UDim2.fromOffset(720, 600),
        IconSize = UDim2.fromOffset(30, 30),
        IslandIcon = nil,

        AutoShow = true,
        Center = true,
        Resizable = true,
        AlwaysOnTop = false,

        --// Window Snapping \\--
        Snapping = false,
        SnapDistance = 28,
        SnapMargin = 8,
        SnapAvoidCoreGui = true,

        SearchbarSize = UDim2.fromScale(1, 1),
        GlobalSearch = false,

        CornerRadius = 4,
        NotifySide = "Right",
    
        Font = Enum.Font.Code,
        ToggleKeybind = Enum.KeyCode.RightControl,

        ShowMobileButtons = true,
        MobileButtonsSide = "Left",

        UnlockMouseWhileOpen = true,

        EnableSidebarResize = false,
        EnableCompacting = true,
        DisableCompactingSnap = false,
        SidebarCompacted = true,
        SubTabWidth = 170,
        MinContainerWidth = 256,

        --// Snapping \\--
        MinSidebarWidth = 128,
        SidebarCompactWidth = 48,
        SidebarCollapseThreshold = 0.5,

        --// Dragging \\--
        CompactWidthActivation = 128,

        --// Background \\--
        BackgroundImage = "",

        --// Animations \\--
        Animations = {
            ToggleWindow = false,
            TabSwitch = false,
            Groupbox = false,
            Dropdown = false,
            KeyPicker = false,
            SettingsPopup = true,
        },

        TabTransitionTime = 0.22,
        TabSwipeOffset = 26,
        TabSwipeFrom = "bottom",
        TabButtonsStyle = {
            Gap = 0,
            Padding = 0,
            CornerRadius = 0,
            Indicator = false,
            IndicatorWidth = 2,
            IndicatorHeight = 20,
        },
    },
    Groupbox = {
        Side = 1,
        Name = "Groupbox",
        IconName = nil,
        Description = nil,
        Visible = true,
        Collapsed = false,
        DisableCollapsing = false,
        PopOut = true,
        MaxPopOutHeight = nil,
        PopOutWidth = nil,
    },
    Tabbox = {
        Side = 1,
        Name = nil,
        PopOut = true,
        MaxPopOutHeight = nil,
        PopOutWidth = nil,
    },
    Dialog = {
        Title = "Dialog",
        Description = "Description",
        AutoDismiss = true,
        OutsideClickDismiss = true,
        FooterButtons = {}
    },
    Loading = {
        Title = "mspaint",
        Icon = 95816097006870,
        IconSize = UDim2.fromOffset(30, 30),

        LoadingIcon = CustomImageManager.GetAsset("LoadingIcon"),
        LoadingIconColor = nil,
        LoadingIconTweenTime = 1,

        CurrentStep = 0,
        TotalSteps = 10,

        ShowSidebar = false,
        AutoResizeHeight = false,
        AlwaysOnTop = true,

        WindowWidth = 450,
        WindowHeight = 275,

        ContentWidth = 450,
        SidebarWidth = 250,
    },
    Toggle = {
        Text = "Toggle",
        Default = false,

        Callback = function() end,
        Changed = function() end,

        Risky = false,
        Disabled = false,
        Visible = true,
    },
    Input = {
        Text = "Input",
        Default = "",
        Finished = false,
        Numeric = false,
        ClearTextOnFocus = true,
        ClearTextOnBlur = false,
        Placeholder = "",
        AllowEmpty = true,
        EmptyReset = "---",

        Callback = function() end,
        Changed = function() end,
        VerifyValue = nil,

        Disabled = false,
        Visible = true,
    },
    Slider = {
        Text = "Slider",
        Default = 0,
        Min = 0,
        Max = 100,
        Rounding = 0,

        Prefix = "",
        Suffix = "",

        Callback = function() end,
        Changed = function() end,

        Disabled = false,
        Visible = true,

        AllowRightClickInput = true
    },
    Dropdown = {
        Values = {},
        DisabledValues = {},
        ValueImages = {},

        Multi = false,
        DragSelect = false,
        SelectAll = true,
        MaxVisibleDropdownItems = 8,
        KeepDisabledValuePosition = false,

        Callback = function() end,
        Changed = function() end,

        Disabled = false,
        Visible = true,
    },
    Viewport = {
        Object = nil,
        Camera = nil,
        Clone = true,
        AutoFocus = true,
        Interactive = false,
        Height = 200,
        Visible = true,
    },
    Image = {
        Image = "",
        Transparency = 0,
        BackgroundTransparency = 0,
        Color = Color3.new(1, 1, 1),
        RectOffset = Vector2.zero,
        RectSize = Vector2.zero,
        ScaleType = Enum.ScaleType.Fit,
        Height = 200,
        Visible = true,
    },
    Video = {
        Video = "",
        Looped = false,
        Playing = false,
        Volume = 1,
        Height = 200,
        Visible = true,
    },
    UIPassthrough = {
        Instance = nil,
        Height = 24,
        Visible = true,
    },

    --// Addons \\-
    SettingsPopup = {
        Width = 220,
        Tooltip = nil,
    },

    KeyPicker = {
        Text = "KeyPicker",

        Default = "None",
        DefaultModifiers = {},

        Blacklisted = {},
        BlacklistedModifiers = {},
        Whitelisted = {},
        WhitelistedModifiers = {},

        Mode = "Toggle",
        Modes = { "Always", "Toggle", "Hold" },
        SyncToggleState = false,

        Callback = function() end,
        ChangedCallback = function() end,
        Changed = function() end,
        Clicked = function() end,
    },
    ColorPicker = {
        Default = Color3.new(1, 1, 1),

        Resizable = true,

        Callback = function() end,
        Changed = function() end,
    },
}

local Places = {
    Bottom = { 0, 1 },
    Right = { 1, 0 },
}
local Sizes = {
    Left = { 0.5, 1 },
    Right = { 0.5, 1 },
}
local SideIndex = {
    left = 1,
    right = 2,
}

--// Scheme Functions \\--
local SchemeReplaceAlias = {
    RedColor = "Red",
    WhiteColor = "White",
    DarkColor = "Dark"
}

local SchemeAlias = {
    Red = "RedColor",
    White = "WhiteColor",
    Dark = "DarkColor"
}

local function GetSchemeValue(Index)
    if not Index then
        return nil
    end

    local ReplaceAliasIndex = SchemeReplaceAlias[Index]
    if ReplaceAliasIndex and Library.Scheme[ReplaceAliasIndex] ~= nil then
        Library.Scheme[Index] = Library.Scheme[ReplaceAliasIndex]
        Library.Scheme[ReplaceAliasIndex] = nil

        return Library.Scheme[Index]
    end

    local AliasIndex = SchemeAlias[Index]
    if AliasIndex and Library.Scheme[AliasIndex] ~= nil then
        warn(string.format("Scheme Value %q is deprecated, please use %q instead.", Index, AliasIndex))
        return Library.Scheme[AliasIndex]
    end

    return Library.Scheme[Index]
end

--// Basic Functions \\--
local function WaitForEvent(Event, Timeout, Condition)
    local Bindable = Instance.new("BindableEvent")
    local Connection = Event:Once(function(...)
        if not Condition or typeof(Condition) == "function" and Condition(...) then
            Bindable:Fire(true)
        else
            Bindable:Fire(false)
        end
    end)
    task.delay(Timeout, function()
        Connection:Disconnect()
        Bindable:Fire(false)
    end)

    local Result = Bindable.Event:Wait()
    Bindable:Destroy()

    return Result
end

local function IsMouseInput(Input: InputObject, IncludeM2: boolean?)
    return Input.UserInputType == Enum.UserInputType.MouseButton1
        or (IncludeM2 == true and Input.UserInputType == Enum.UserInputType.MouseButton2)
        or Input.UserInputType == Enum.UserInputType.Touch
end
local function IsClickInput(Input: InputObject, IncludeM2: boolean?)
    return IsMouseInput(Input, IncludeM2)
        and Input.UserInputState == Enum.UserInputState.Begin
        and Library.IsRobloxFocused
end
local function IsHoverInput(Input: InputObject)
    return (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)
        and Input.UserInputState == Enum.UserInputState.Change
end
local function IsDragInput(Input: InputObject, IncludeM2: boolean?)
    return IsMouseInput(Input, IncludeM2)
        and (Input.UserInputState == Enum.UserInputState.Begin or Input.UserInputState == Enum.UserInputState.Change)
        and Library.IsRobloxFocused
end
local function IsMouseClickInput(Input: InputObject)
    return Input.UserInputType == Enum.UserInputType.MouseButton1 or
        Input.UserInputType == Enum.UserInputType.MouseButton2 or
        Input.UserInputType == Enum.UserInputType.MouseButton3
end
local function IsMovementInput(Input: InputObject)
    return (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)
        and Library.IsRobloxFocused
end

local function GetTableSize(Table: { [any]: any })
    local Size = 0

    for _, _ in Table do
        Size += 1
    end

    return Size
end
local function IsSequentialArray(Table: { [any]: any })
    for Key in Table do
        if typeof(Key) ~= "number" or Key < 1 or Key % 1 ~= 0 then
            return false
        end
    end

    return true
end

local function StopTween(Tween: TweenBase, Destroy: boolean?)
    if not Tween then
        return
    end

    if Tween.PlaybackState == Enum.PlaybackState.Playing then
        Tween:Cancel()
    end

    if Destroy == true then
        pcall(Tween.Destroy, Tween)
    end
end

local function Trim(Text: string)
    return Text:match("^%s*(.-)%s*$")
end
local function Round(Value, Rounding)
    assert(Rounding >= 0, "Invalid rounding number.")

    if Rounding == 0 then
        return math.floor(Value)
    end

    return tonumber(string.format("%." .. Rounding .. "f", Value))
end

--// Fuzzy Search \\--
--// Whitespace and punctuation count as word boundaries (same set as the %s%p_ pattern) \\--
local BoundaryBytes = {}
for Byte = 0, 127 do
    if string.char(Byte):match("[%s%p_]") then
        BoundaryBytes[Byte] = true
    end
end

local function FuzzyScore(Text: string, Search: string): (boolean, number)
    if Search == "" then
        return true, 0
    end
    if Text == "" then
        return false, 0
    end

    --// Fast path: literal substring match (also the best possible score) \\--
    local ExactIdx = Text:find(Search, 1, true)
    if ExactIdx then
        local PrevChar = ExactIdx > 1 and Text:sub(ExactIdx - 1, ExactIdx - 1) or ""
        local AtBoundary = ExactIdx == 1 or PrevChar:match("[%s%p_]") ~= nil

        return true, 1e5 - ExactIdx + (AtBoundary and 500 or 0) + (Search:len() * 5)
    end

    --// Fallback: fuzzy, in-order, non-consecutive character matching \\--
    local TextLen, SearchLen = Text:len(), Search:len()
    if SearchLen > TextLen then
        return false, 0
    end

    local SearchIdx = 1
    local SearchByte = string.byte(Search, 1)
    local Score = 0
    local RunLength = 0
    local LastMatchIdx = 0

    for TextIdx = 1, TextLen do
        if SearchIdx > SearchLen then
            break
        end

        if string.byte(Text, TextIdx) == SearchByte then
            local PrevByte = TextIdx > 1 and string.byte(Text, TextIdx - 1) or nil
            local AtBoundary = PrevByte == nil or BoundaryBytes[PrevByte] == true

            RunLength = (LastMatchIdx == TextIdx - 1) and (RunLength + 1) or 1
            Score += 1 + (AtBoundary and 6 or 0) + math.min(RunLength - 1, 5) * 3

            LastMatchIdx = TextIdx
            SearchIdx += 1
            SearchByte = string.byte(Search, SearchIdx)
        end
    end

    if SearchIdx <= SearchLen then
        return false, 0 --// Not every Search character was found, in order
    end

    Score -= (LastMatchIdx - SearchLen) * 0.05 --// Slightly favour tighter matches
    return true, Score
end

local function NormalizeSearch(Search: string): string
    return (Search:gsub("%s+", ""))
end

local function TryFuzzyMatch(Text: any, Search: string): (boolean, number)
    if typeof(Text) ~= "string" or Text == "" then
        return false, 0
    end

    return FuzzyScore(Text:lower(), Search)
end

local function FuzzyMatchScore(Text: any, Search: string): number
    if typeof(Text) ~= "string" or Text == "" then
        return 0
    end

    local Normalized = NormalizeSearch(Text:lower())
    local Matched, Score = FuzzyScore(Normalized, Search)
    if not Matched then
        return 0
    end

    if Normalized == Search then
        Score += 1000
    end

    return Score
end

local function MatchesSearch(ElementInfo, Search: string, ForceMatch: boolean?): boolean
    if not ElementInfo then
        return false
    end
    if ForceMatch then
        return true
    end

    if TryFuzzyMatch(ElementInfo.Text, Search) then
        return true
    end
    if TryFuzzyMatch(ElementInfo.Tooltip, Search) then
        return true
    end
    if TryFuzzyMatch(ElementInfo.DisabledTooltip, Search) then
        return true
    end

    --// Optional: search inside Dropdown value lists, so e.g. searching a specific option name reveals the Dropdown that contains it \\--
    if typeof(ElementInfo.Values) == "table" then
        local Checked = 0
        for Key, Value in ElementInfo.Values do
            Checked += 1
            if Checked > 200 then
                break
            end

            if TryFuzzyMatch(Value, Search) or (typeof(Value) ~= "string" and TryFuzzyMatch(tostring(Value), Search)) then
                return true
            end
            if typeof(Key) == "string" and TryFuzzyMatch(Key, Search) then
                return true
            end
        end
    end

    return false
end

local function GetPlayers(ExcludeLocalPlayer: boolean?)
    local PlayerList = Players:GetPlayers()

    if ExcludeLocalPlayer then
        local Idx = table.find(PlayerList, LocalPlayer)
        if Idx then
            table.remove(PlayerList, Idx)
        end
    end

    table.sort(PlayerList, function(Player1, Player2)
        return Player1.Name:lower() < Player2.Name:lower()
    end)

    return PlayerList
end
local function GetTeams()
    local TeamList = Teams:GetTeams()

    table.sort(TeamList, function(Team1, Team2)
        return Team1.Name:lower() < Team2.Name:lower()
    end)

    return TeamList
end

function Library:UpdateDependencyBoxes()
    for _, Depbox in Library.DependencyBoxes do
        Depbox:Update(true)
    end

    if Library.Searching then
        Library:UpdateSearch(Library.SearchText)
    end
end

function Library:UpdateAddons(Parent)
    if not Parent or not Parent.Addons then
        return
    end

    for _, Addon in Parent.Addons do
        Addon:Update()
    end
end

--// Pop Out
function SyncPopOutVisibility(Box: any)
    if not Box.PopOutFloat then
        return
    end

    Box.PopOutFloat.Visible = Box.BoxHolder.Visible ~= false and Box.Visible ~= false
end

local function RegisterPopOutClone(Source: Instance, Clone: Instance)
    local SourceProps = Library.Registry[Source]
    if SourceProps then
        local CloneProps = {}
        for Property, Index in SourceProps do
            if Property ~= "FontFace" then
                CloneProps[Property] = Index
            end
        end
        if next(CloneProps) then
            Library.Registry[Clone] = CloneProps
        end

        local FontLabel = Clone:FindFirstChild("__IconFont")
        if FontLabel and FontLabel:IsA("TextLabel") and SourceProps.ImageColor3 then
            Library.Registry[FontLabel] = { TextColor3 = SourceProps.ImageColor3 }
        end
    end

    local SourceChildren = Source:GetChildren()
    local CloneChildren = Clone:GetChildren()
    for Index = 1, math.min(#SourceChildren, #CloneChildren) do
        RegisterPopOutClone(SourceChildren[Index], CloneChildren[Index])
    end
end

local function DimPopOutClone(Root: GuiObject)
    for _, Descendant in Root:QueryDescendants("TextLabel, TextButton, TextBox") do
        Descendant.TextTransparency = math.max(Descendant.TextTransparency, 0.45)
    end

    for _, Descendant in Root:QueryDescendants("ImageLabel, ImageButton") do
        Descendant.ImageTransparency = math.max(Descendant.ImageTransparency, 0.45)

        local FontLabel = Descendant:FindFirstChild("__IconFont")
        if FontLabel and FontLabel:IsA("TextLabel") then
            FontLabel.TextColor3 = Descendant.ImageColor3
            FontLabel.TextTransparency = math.max(FontLabel.TextTransparency, 0.45)
        end
    end

    for _, Descendant in Root:QueryDescendants("GuiButton") do
        Descendant.Active = false
        Descendant.AutoButtonColor = false
    end
end

local function IsScreenPointOutsideMain(Point: Vector2): boolean
    local MainFrame = Library.Window and Library.Window.MainFrame
    if not MainFrame or not Library.Toggled or not MainFrame.Visible then
        return true
    end

    return not Library:MouseIsOverFrame(MainFrame, Point)
end

local function GetTopFloatAt(Point: Vector2): GuiObject?
    local Best: GuiObject? = nil
    local BestOrder = -math.huge
    local Floats = Library.Floats

    for _, Surface in Library.DraggableElements do
        if not Surface or not Surface.Parent or not Surface.Visible then
            continue
        end
        if Floats and Surface.Parent ~= Floats then
            continue
        end
        if not Library:MouseIsOverFrame(Surface, Point) then
            continue
        end

        local SiblingIndex = tonumber(select(2, pcall(function() return Surface:GetSiblingIndex() end))) or 0
        local Order = Surface.ZIndex * 100000 + SiblingIndex
        if Order >= BestOrder then
            BestOrder = Order
            Best = Surface
        end
    end

    return Best
end

local function GetPopOutBodyMaxHeight(Box: any, Reserved: number): number
    local Float = Box.PopOutFloat
    local ScreenGui = Library.ScreenGui
    if not Float or not ScreenGui then
        return math.huge
    end

    local Gap = 12 * Library.DPIScale
    local MaxBottom = ScreenGui.AbsolutePosition.Y + ScreenGui.AbsoluteSize.Y - Gap
    local Available = math.min(MaxBottom - Float.AbsolutePosition.Y, ScreenGui.AbsoluteSize.Y * 0.9)
    local ScreenMax = math.max(0, Available / Library.DPIScale - Reserved)

    local CustomMax = Box.PopOutMaxHeight
    if typeof(CustomMax) == "number" then
        return math.min(ScreenMax, math.max(0, CustomMax))
    end

    return ScreenMax
end

--// Search
local MaxSearchResults = 50

local function StripRichText(Text: string): string
    --// Results are single-line rows, so collapse newlines and cap long label texts \\--
    local Stripped = Trim((Text:gsub("<[^>]+>", ""):gsub("%s+", " ")))
    if #Stripped > 60 then
        Stripped = Trim(Stripped:sub(1, 57)) .. "..."
    end

    return Stripped
end

--// Outer-to-inner list of containers that must be opened to reach a box \\--
local function GetBoxChain(Box)
    local Chain
    if Box.Type == "SubTab" then
        local Tabbox = Box.Tabbox
        Chain = if Tabbox.ParentBox then GetBoxChain(Tabbox.ParentBox) elseif Tabbox.Page then { Tabbox.Page } else {}
    else
        Chain = if Box.Page then { Box.Page } else {}
    end

    table.insert(Chain, Box)
    return Chain
end

local function IsBoxChainVisible(Chain): boolean
    for _, Step in Chain do
        if Step.Type == "Groupbox" and Step.Visible == false then
            return false
        elseif Step.Type == "SubTab" and Step.Tabbox.Visible == false then
            return false
        end
    end

    return true
end

local function CollectSearchResults(Search: string)
    local Results = {}

    local function AddElements(Elements, DependencyBoxes, Info, ContainerScore)
        for _, ElementInfo in Elements do
            if ElementInfo.Type == "Divider" then
                continue
            end

            local Candidates = { ElementInfo }
            if ElementInfo.SubButton then
                table.insert(Candidates, ElementInfo.SubButton)
            end

            for _, Candidate in Candidates do
                if Candidate.Visible == false or typeof(Candidate.Text) ~= "string" or Trim(Candidate.Text) == "" then
                    continue
                end

                --// Matching a container's name (tab, groupbox...) pulls in everything inside it, ranked below direct hits \\--
                local Score = FuzzyMatchScore(Candidate.Text, Search)
                if Score <= 0 then
                    if MatchesSearch(Candidate, Search) then
                        Score = 1
                    elseif ContainerScore > 0 then
                        Score = ContainerScore * 0.01
                    else
                        continue
                    end
                end

                table.insert(Results, {
                    Text = StripRichText(Candidate.Text),
                    Tab = Info.Tab,
                    Chain = Info.Chain,
                    Target = if Candidate == ElementInfo then ElementInfo.Holder else Candidate.Base,
                    Score = Score,
                    TabOrder = Info.Tab.Button and Info.Tab.Button.LayoutOrder or 0,
                    Order = #Results + 1,
                })
            end
        end

        for _, Depbox in DependencyBoxes do
            if Depbox.Visible then
                AddElements(Depbox.Elements, Depbox.DependencyBoxes, Info, ContainerScore)
            end
        end
    end

    local function ScanBox(Tab, Box, TabScore)
        local Chain = GetBoxChain(Box)
        if not IsBoxChainVisible(Chain) then
            return
        end

        local ContainerScore = TabScore
        for _, Step in Chain do
            ContainerScore = math.max(ContainerScore, FuzzyMatchScore(Step.Name, Search))
        end

        AddElements(Box.Elements, Box.DependencyBoxes, { Tab = Tab, Chain = Chain }, ContainerScore)
    end

    for _, Tab in Library.Tabs do
        if typeof(Tab) ~= "table" or Tab.Destroyed or (Tab.Button and not Tab.Button.Visible) then
            continue
        end

        local TabScore = math.max(FuzzyMatchScore(Tab.Name, Search), FuzzyMatchScore(Tab.Description, Search))

        for _, Groupbox in Tab.Groupboxes do
            ScanBox(Tab, Groupbox, TabScore)
        end

        for _, Tabbox in Tab.Tabboxes do
            for _, SubTab in Tabbox.Tabs do
                ScanBox(Tab, SubTab, TabScore)
            end
        end
    end

    table.sort(Results, function(A, B)
        if A.Score ~= B.Score then
            return A.Score > B.Score
        end
        if A.TabOrder ~= B.TabOrder then
            return A.TabOrder < B.TabOrder
        end
        return A.Order < B.Order
    end)

    for Index = #Results, MaxSearchResults + 1, -1 do
        Results[Index] = nil
    end

    return Results
end

--// Opens every container leading to a result, scrolls it into view and flashes it \\--
local function RevealSearchResult(Result)
    local Tab = Result.Tab
    if Library.ActiveTab ~= Tab then
        Tab:Show()
    end

    for _, Step in Result.Chain do
        if Step.IsSubTab then
            Step:Show()
        elseif Step.Type == "SubTab" then
            if Step.Tabbox.ActiveTab ~= Step then
                Step:Show()
            end
        elseif Step.Type == "Groupbox" and Step.Collapsed then
            Step:SetCollapsed(false)
        end
    end

    local Target = Result.Target
    if not Target or not Target.Parent then
        return
    end

    task.delay(0.05, function()
        if Library.Unloaded or not Target.Parent then
            return
        end

        local Side = Target.Parent
        while Side and not table.find(Tab.Sides, Side) do
            Side = Side.Parent
        end

        if Side then
            local Offset = Target.AbsolutePosition.Y - Side.AbsolutePosition.Y + Side.CanvasPosition.Y
            local Centered = Offset - (Side.AbsoluteSize.Y - Target.AbsoluteSize.Y) / 2
            local MaxScroll = math.max(0, Side.AbsoluteCanvasSize.Y - Side.AbsoluteWindowSize.Y)

            Side.CanvasPosition = Vector2.new(0, math.clamp(Centered, 0, MaxScroll))
        end

        local Flash = New("Frame", {
            BackgroundColor3 = "AccentColor",
            BackgroundTransparency = 0.7,
            Position = UDim2.fromOffset(Target.AbsolutePosition.X, Target.AbsolutePosition.Y),
            Size = UDim2.fromOffset(Target.AbsoluteSize.X, Target.AbsoluteSize.Y),
            Parent = Library.Overlay,
        })
        Library:RemoveFromRegistry(Flash)
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius / 2),
            Parent = Flash,
        })

        local Tween = TweenService:Create(Flash, TweenInfo.new(0.9, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
            BackgroundTransparency = 1,
        })
        Tween.Completed:Once(function()
            Flash:Destroy()
        end)
        Tween:Play()
    end)
end

local SearchUpdateMarker = nil

function Library:UpdateSearch(SearchText)
    Library.SearchText = SearchText

    if not Library.SearchResultsHandler then
        return
    end

    local Search = NormalizeSearch(SearchText:lower())
    if Search == "" then
        SearchUpdateMarker = nil
        Library.SearchResultsHandler({})
        return
    end

    --// Coalesce fast typing into one scan once the user pauses \\--
    local Marker = {}
    SearchUpdateMarker = Marker
    task.delay(0.08, function()
        if SearchUpdateMarker ~= Marker or Library.Unloaded then
            return
        end

        Library.SearchResultsHandler(CollectSearchResults(Search))
    end)
end

function Library:AddToRegistry(Instance, Properties)
    Library.Registry[Instance] = Properties
end

function Library:RemoveFromRegistry(Instance)
    Library.Registry[Instance] = nil
end

function Library:UpdateColorsUsingRegistry()
    for Instance, Properties in Library.Registry do
        for Property, Index in Properties do
            local SchemeValue = GetSchemeValue(Index)

            if SchemeValue or typeof(Index) == "function" then
                Instance[Property] = SchemeValue or Index()
            end
        end
    end
end

function Library:SetDPIScale(DPIScale: number)
    Library.DPIScale = DPIScale / 100
    Library.MinSize = Library.OriginalMinSize * Library.DPIScale

    for _, UIScale in Library.Scales do
        UIScale.Scale = Library.DPIScale - (tonumber(Library.ScalesOffset[UIScale]) or 0)
    end

    for _, Option in Options do
        if Option.Type == "Dropdown" then
            Option:RecalculateListSize()
            Option:RefreshPool()
        end
    end

    for _, Notification in Library.Notifications do
        Notification:Resize()
    end
end

function Library:GiveSignal(Connection: RBXScriptConnection | RBXScriptSignal)
    local ConnectionType = typeof(Connection)
    if Connection and (ConnectionType == "RBXScriptConnection" or ConnectionType == "RBXScriptSignal") then
        table.insert(Library.Signals, Connection)
    end

    return Connection
end

function IsValidCustomIcon(Icon: string)
    return typeof(Icon) == "string" and (Icon:match("^rbxasset://textures/") or Icon:match("roblox%.com/asset/%?id=") or Icon:match("rbxthumb://type="))
end

local function IsCustomAssetIcon(Icon: string, IncludeAssetId: boolean)
    return typeof(Icon) == "string" and (Icon:match("^content://") or (Icon:match("^rbxasset://%x+/") or Icon:match("^rbxasset://[^/]+/")) or (IncludeAssetId == true and Icon:match("^rbxassetid://")))
end

type Icon = {
    Url: string,
    Id: number,
    IconName: string,
    ImageRectOffset: Vector2,
    ImageRectSize: Vector2,
    FontFace: Font?,
    Text: string?,
}

type IconModule = {
    Icons: { string },
    GetAsset: (Name: string) -> Icon?,
    GetFontAsset: ((Name: string) -> { FontFace: Font, Text: string }?)?,
}

local FetchIcons = false
local Icons: IconModule | nil = nil

function Library:GetIcon(IconName: string)
    if not FetchIcons or not Icons then
        return
    end

    local Success, Icon = pcall(Icons.GetAsset, IconName)
    if not Success or not Icon then
        return
    end

    local FontSuccess, FontIcon = false, nil
    if Icons.GetFontAsset then
        FontSuccess, FontIcon = pcall(Icons.GetFontAsset, IconName)
    end

    if FontSuccess and FontIcon and FontIcon.FontFace and FontIcon.Text then
        local Merged = table.clone(Icon)
        Merged.FontFace = FontIcon.FontFace
        Merged.Text = FontIcon.Text

        return Merged
    end

    return Icon
end

function Library:GetCustomIcon(IconName: string): any
    if not IconName then
        return nil
    end

    if tonumber(IconName) then
        IconName = string.format("rbxassetid://%s", tostring(IconName))
    end

    if IsCustomAssetIcon(IconName, true) then
        return {
            Url = IconName,
            ImageRectOffset = Vector2.zero,
            ImageRectSize = Vector2.zero,
        }
    elseif IsValidCustomIcon(IconName) then
        return {
            Url = IconName,
            ImageRectOffset = Vector2.zero,
            ImageRectSize = Vector2.zero,
            Custom = true,
        }
    end

    local LucideIcon = Library:GetIcon(IconName)
    if LucideIcon then
        return LucideIcon
    end

    return nil
end

function Library:Validate(Table: { [string]: any }, Template: { [string]: any }): { [string]: any }
    if typeof(Table) ~= "table" then
        return Template
    end

    for k, v in Template do
        if typeof(k) == "number" then
            continue
        end

        if typeof(v) == "table" then
            Table[k] = Library:Validate(Table[k], v)
        elseif Table[k] == nil then
            Table[k] = v
        end
    end

    return Table
end

--// Creator Functions \\--
local function FillInstance(Table: { [string]: any }, Instance: GuiObject)
    local ThemeProperties = Library.Registry[Instance] or {}

    for key, value in Table do
        if key ~= "Text" then
            local SchemeValue = GetSchemeValue(value)

            if SchemeValue or typeof(value) == "function" then
                ThemeProperties[key] = value
                value = SchemeValue or value()
            else
                ThemeProperties[key] = nil
            end
        end

        Instance[key] = value
    end

    if GetTableSize(ThemeProperties) > 0 then
        Library.Registry[Instance] = ThemeProperties
    end
end

local function New(ClassName: string, Properties: { [string]: any }): any
    local Instance = Instance.new(ClassName)

    if Templates[ClassName] then
        FillInstance(Templates[ClassName], Instance)
    end
    FillInstance(Properties, Instance)

    if Properties["Parent"] and not Properties["ZIndex"] then
        pcall(function()
            Instance.ZIndex = Properties.Parent.ZIndex
        end)
    end

    return Instance
end

function Library:ApplyLucideIcon(ImageGui: any, Icon: any, Rotation: number?)
    if not ImageGui or not Icon then
        return
    end

    if not (ImageGui:IsA("ImageLabel") or ImageGui:IsA("ImageButton")) then
        return
    end

    ImageGui.Rotation = Rotation or ImageGui.Rotation

    local FontLabel = ImageGui:FindFirstChild("__IconFont")
    if Icon.FontFace and Icon.Text then
        if not FontLabel then
            FontLabel = New("TextLabel", {
                Name = "__IconFont",
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                RichText = false,
                TextScaled = false,
                TextXAlignment = Enum.TextXAlignment.Center,
                TextYAlignment = Enum.TextYAlignment.Center,
                Parent = ImageGui,
            })
            Library:RemoveFromRegistry(FontLabel)

            local SyncLabel = function()
                if not FontLabel.Parent then
                    return
                end

                FontLabel.TextColor3 = ImageGui.ImageColor3
                FontLabel.TextTransparency = ImageGui.ImageTransparency
            end

            local SyncTextSize = function()
                if not FontLabel.Parent then
                    return
                end

                local Absolute = ImageGui.AbsoluteSize
                local Side = math.min(Absolute.X, Absolute.Y) / Library.DPIScale
                FontLabel.TextSize = math.max(1, math.floor(Side + 0.5))
            end

            SyncLabel()
            SyncTextSize()

            ImageGui:GetPropertyChangedSignal("ImageColor3"):Connect(SyncLabel)
            ImageGui:GetPropertyChangedSignal("ImageTransparency"):Connect(SyncLabel)
            ImageGui:GetPropertyChangedSignal("AbsoluteSize"):Connect(SyncTextSize)
        else
            Library:RemoveFromRegistry(FontLabel)
        end

        FontLabel.FontFace = Icon.FontFace
        FontLabel.Text = Icon.Text
        FontLabel.TextScaled = false
        FontLabel.TextWrapped = false
        FontLabel.TextXAlignment = Enum.TextXAlignment.Center
        FontLabel.TextYAlignment = Enum.TextYAlignment.Center
        FontLabel.TextColor3 = ImageGui.ImageColor3
        FontLabel.TextTransparency = ImageGui.ImageTransparency

        local Absolute = ImageGui.AbsoluteSize
        local Side = math.min(Absolute.X, Absolute.Y) / Library.DPIScale
        if Side > 0 then
            FontLabel.TextSize = math.max(1, math.floor(Side + 0.5))
        else
            local OffsetSize = ImageGui.Size
            FontLabel.TextSize = math.max(1, math.floor(math.min(OffsetSize.X.Offset, OffsetSize.Y.Offset) + 0.5))
        end

        FontLabel.Visible = true
        ImageGui.ClipsDescendants = true
        ImageGui.Image = ""
        return
    end

    if FontLabel then
        Library:RemoveFromRegistry(FontLabel)
        FontLabel:Destroy()
    end

    ImageGui.Image = Icon.Url or ImageGui.Image
    ImageGui.ImageRectOffset = Icon.ImageRectOffset or ImageGui.ImageRectOffset
    ImageGui.ImageRectSize = Icon.ImageRectSize or ImageGui.ImageRectSize
end

--// Main Instances \\-
local function SafeParentUI(Instance: Instance, Parent: Instance | () -> Instance)
    local success, _error = pcall(function()
        if not Parent then
            Parent = CoreGui
        end

        local DestinationParent
        if typeof(Parent) == "function" then
            DestinationParent = Parent()
        else
            DestinationParent = Parent
        end

        Instance.Parent = DestinationParent
    end)

    if not (success and Instance.Parent) then
        Instance.Parent = Library.LocalPlayer:WaitForChild("PlayerGui", math.huge)
    end
end

local function ParentUI(UI: Instance, SkipHiddenUI: boolean?)
    if SkipHiddenUI then
        SafeParentUI(UI, CoreGui)
        return
    end

    pcall(protectgui, UI)
    SafeParentUI(UI, gethui)
end

local function SetAlwaysOnTop(Gui: ScreenGui, Enabled: boolean)
    if not Gui then
        return
    end

    pcall(function()
        if sethiddenproperty then
            sethiddenproperty(Gui, "OnTopOfCoreBlur", Enabled)
        elseif setscriptable then
            setscriptable(Gui, "OnTopOfCoreBlur", true)
            Gui.OnTopOfCoreBlur = Enabled
            setscriptable(Gui, "OnTopOfCoreBlur", false)
        end
    end)
end

local ScreenGui = New("ScreenGui", {
    Name = "Obsidian",
    DisplayOrder = 998,
    ResetOnSpawn = false,
    ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
ParentUI(ScreenGui)
Library.ScreenGui = ScreenGui

ScreenGui.DescendantRemoving:Connect(function(Instance)
    task.defer(function()
        if Instance.Parent and Instance:IsDescendantOf(ScreenGui) then
            return
        end

        Library:RemoveFromRegistry(Instance)
    end)
end)

local ModalElement = New("TextButton", {
    BackgroundTransparency = 1,
    Modal = false,
    Size = UDim2.fromScale(0, 0),
    AnchorPoint = Vector2.zero,
    Text = "",
    ZIndex = -999,
    Parent = ScreenGui,
})

--// Floats and Overlays
local Floats = New("Frame", {
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    ZIndex = 10,
    Active = false,
    Parent = ScreenGui,
})

local Overlay = New("Frame", {
    BackgroundTransparency = 1,
    Size = UDim2.fromScale(1, 1),
    ZIndex = 20,
    Active = false,
    Parent = ScreenGui,
})

Library.Floats = Floats
Library.Overlay = Overlay

local function RestoreMouseIcon()
    pcall(function()
        RunService:UnbindFromRenderStep(Library.ShowCursorBinding)
        RunService.RenderStepped:Wait()
    end)

    UserInputService.MouseIconEnabled = Library.OriginalMouseIconEnabled
end

--// Notification \\--
local NotificationArea
local NotifyOrder = {}
do
    NotificationArea = New("Frame", {
        AnchorPoint = Vector2.new(1, 0),
        BackgroundTransparency = 1,
        Position = UDim2.new(1, -6, 0, 6),
        Size = UDim2.new(0, 300, 1, -6),
        ZIndex = 200,
        Parent = ScreenGui,
    })
    table.insert(
        Library.Scales,
        New("UIScale", {
            Parent = NotificationArea,
        })
    )
end

--// Icons \\--
local CheckIcon, ArrowIcon, ResizeIcon, MoveIcon, PopOutIcon, CloseIcon, SettingsIcon
function Library:SetIconModule(module: IconModule)
    FetchIcons = true
    Icons = module

    CheckIcon = Library:GetIcon("check")
    ArrowIcon = Library:GetIcon("chevron-up")
    ResizeIcon = Library:GetIcon("move-diagonal-2")
    MoveIcon = Library:GetIcon("move")
    PopOutIcon = Library:GetIcon("square-arrow-down-left")
    CloseIcon = Library:GetIcon("x")
    SettingsIcon = Library:GetIcon("settings")
end

local OnlineFetchIcons, OnlineIcons = pcall(function()
    return (loadstring(
        game:HttpGet("https://raw.githubusercontent.com/notpoiu/Molto/refs/heads/main/source.lua")
    ) :: () -> IconModule)()
end)
do
    if OnlineFetchIcons and OnlineIcons then
        OnlineIcons.SetProvider("lucide")
        Library:SetIconModule(OnlineIcons)
    else
        OnlineFetchIcons, OnlineIcons = pcall(function()
            return (loadstring(
                game:HttpGet("https://raw.githubusercontent.com/notpoiu/lucide-roblox-direct/refs/heads/main/source.lua")
            ) :: () -> IconModule)()
        end)
        
        if OnlineFetchIcons and OnlineIcons then
            Library:SetIconModule(OnlineIcons)
        end
    end
end

--// Lib Functions \\--
--// Colors \\--
function Library:GetBetterColor(Color: Color3, Add: number): Color3
    Add = Add * (Library.IsLightTheme and -4 or 2)
    return Color3.fromRGB(
        math.clamp(Color.R * 255 + Add, 0, 255),
        math.clamp(Color.G * 255 + Add, 0, 255),
        math.clamp(Color.B * 255 + Add, 0, 255)
    )
end

function Library:GetLighterColor(Color: Color3): Color3
    local H, S, V = Color:ToHSV()
    return Color3.fromHSV(H, math.max(0, S - 0.1), math.min(1, V + 0.1))
end

function Library:GetDarkerColor(Color: Color3): Color3
    local H, S, V = Color:ToHSV()
    return Color3.fromHSV(H, S, V / 2)
end

function Library:GetKeyString(KeyCode: Enum.KeyCode)
    if KeyCode.EnumType == Enum.KeyCode and KeyCode.Value > 33 and KeyCode.Value < 127 then
        return string.char(KeyCode.Value)
    end

    return KeyCode.Name
end

function Library:GetTextBounds(Text: string, Font: Font, Size: number, Width: number?): (number, number)
    local Scale = Library.DPIScale
    local Params = Instance.new("GetTextBoundsParams")
    Params.Text = Text
    Params.RichText = true
    Params.Font = Font
    Params.Size = Size * Scale
    if Width then
        Params.Width = Width * Scale
    else
        Params.Width = workspace.CurrentCamera.ViewportSize.X - 32
    end

    local Bounds = TextService:GetTextBoundsAsync(Params)
    return math.ceil(Bounds.X / Scale), math.ceil(Bounds.Y / Scale)
end

function Library:MouseIsOverFrame(Frame: GuiObject, Mouse: Vector2): boolean
    local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize
    return Mouse.X >= AbsPos.X
        and Mouse.X <= AbsPos.X + AbsSize.X
        and Mouse.Y >= AbsPos.Y
        and Mouse.Y <= AbsPos.Y + AbsSize.Y
end

function Library:IsInsideFrame(ParentFrame: GuiObject, Frame: GuiObject)
    local GuiPos = Frame.AbsolutePosition
    local GuiSize = Frame.AbsoluteSize

    local FramePos = ParentFrame.AbsolutePosition
    local FrameSize = ParentFrame.AbsoluteSize

    return GuiPos.X >= FramePos.X
        and GuiPos.X + GuiSize.X <= FramePos.X + FrameSize.X
        and GuiPos.Y >= FramePos.Y
        and GuiPos.Y + GuiSize.Y <= FramePos.Y + FrameSize.Y
end

function Library:SafeCallback(Func: (...any) -> ...any, ...: any)
    if not (Func and typeof(Func) == "function") then
        return
    end

    local Result = table.pack(xpcall(Func, function(Error)
        task.defer(error, debug.traceback(Error, 2))
        if Library.NotifyOnError and Library.Notify then
            Library:Notify(Error)
        end

        return Error
    end, ...))

    if not Result[1] then
        return nil
    end

    return table.unpack(Result, 2, Result.n)
end

function GetOverlappingDraggable(UI: GuiObject, TargetPos: Vector2?)
    local Pos1 = TargetPos or UI.AbsolutePosition
    local Size1 = UI.AbsoluteSize

    for _, Other in ipairs(Library.DraggableElements) do
        if Other == UI or not Other.Visible or not Other.Parent then
            continue
        end

        local Pos2 = Other.AbsolutePosition
        local Size2 = Other.AbsoluteSize

        if Pos1.X < Pos2.X + Size2.X and
            Pos1.X + Size1.X > Pos2.X and
            Pos1.Y < Pos2.Y + Size2.Y and
            Pos1.Y + Size1.Y > Pos2.Y then
            return Other
        end
    end

    return nil
end

function GetNonOverlappingPosition(UI: GuiObject, StartPos: UDim2?)
    local ScreenSize = (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)) - Vector2.new(100, 100)
    local Start = StartPos and Vector2.new(StartPos.X.Offset, StartPos.Y.Offset) or Vector2.new(6, 6)
    local Padding = 6

    local CurrentX = Start.X
    local CurrentY = Start.Y

    local Size = UI.AbsoluteSize
    if Size.X == 0 and Size.Y == 0 then
        RunService.RenderStepped:Wait()
        Size = UI.AbsoluteSize
    end

    if Size.X == 0 then Size = Vector2.new(150, 40) end

    local MaxXInColumn = Size.X

    while true do
        local Obstacle = GetOverlappingDraggable(UI, Vector2.new(CurrentX, CurrentY))
        if not Obstacle then
            break
        end

        if Obstacle.AbsoluteSize.X > MaxXInColumn then
            MaxXInColumn = Obstacle.AbsoluteSize.X
        end

        local NextY = Obstacle.AbsolutePosition.Y + Obstacle.AbsoluteSize.Y + Padding
        if NextY + Size.Y > ScreenSize.Y - Padding then
            local NextX = CurrentX + MaxXInColumn + Padding

            if NextX + Size.X > ScreenSize.X - Padding then
                break
            end

            CurrentY = Start.Y
            CurrentX = NextX
            MaxXInColumn = Size.X
        else
            CurrentY = NextY
        end
    end

    return UDim2.fromOffset(CurrentX, CurrentY)
end

function PositionDraggable(UI: GuiObject, StartPos: UDim2?)
    UI.Position = GetNonOverlappingPosition(UI, StartPos)
end

--// Window Snapping \\--
local function GetCoreGuiInset(): (Vector2, Vector2)
    local Success, TopLeft, BottomRight = pcall(function()
        return GuiService:GetGuiInset()
    end)

    if Success and TopLeft and BottomRight then
        return TopLeft, BottomRight
    end

    return Vector2.zero, Vector2.zero
end

local function GetSnapEdges(ElemSize: Vector2, ViewportSize: Vector2, Margin: number, AvoidCoreGui: boolean)
    local SafeMin, SafeMax = Vector2.zero, ViewportSize

    if AvoidCoreGui then
        local TopLeftInset, BottomRightInset = GetCoreGuiInset()
        SafeMin = TopLeftInset
        SafeMax = ViewportSize - BottomRightInset
    end

    local TargetsX = {
        LeftEdge = SafeMin.X + Margin,
        Center = SafeMin.X + (SafeMax.X - SafeMin.X - ElemSize.X) / 2,
        RightEdge = SafeMax.X - ElemSize.X - Margin,
    }
    local TargetsY = {
        TopEdge = SafeMin.Y + Margin,
        Center = SafeMin.Y + (SafeMax.Y - SafeMin.Y - ElemSize.Y) / 2,
        BottomEdge = SafeMax.Y - ElemSize.Y - Margin,
    }

    return TargetsX, TargetsY
end

local function GetClosestSnapTarget(Value: number, Targets: { [string]: number }, Distance: number): (number?, string?)
    local ClosestName, ClosestValue, ClosestDist = nil, nil, Distance

    for Name, Target in Targets do
        local Dist = math.abs(Value - Target)
        if Dist <= ClosestDist then
            ClosestDist = Dist
            ClosestName = Name
            ClosestValue = Target
        end
    end

    return ClosestValue, ClosestName
end

local function GetSnapGuideOffset(Name: string, SnappedValue: number, ElemDimension: number): number
    if Name == "RightEdge" or Name == "BottomEdge" then
        return SnappedValue + ElemDimension
    elseif Name == "Center" then
        return SnappedValue + ElemDimension / 2
    end

    return SnappedValue -- LeftEdge / TopEdge
end

function Library:MakeDraggable(
    UI: GuiObject,
    DragFrame: GuiObject,
    IgnoreToggled: boolean?,
    IsMainWindow: boolean?,
    SnapConfig: { Enabled: boolean, Distance: number?, Margin: number?, AvoidCoreGui: boolean? }?
)
    local StartPos
    local FramePos
    local Dragging = false
    local Changed
    local InputBegan
    local InputChanged

    local SnapGuideX, SnapGuideY

    local function GetSnapGuides()
        if not SnapGuideX then
            SnapGuideX = New("Frame", {
                BackgroundColor3 = "AccentColor",
                BackgroundTransparency = 0.25,
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0.5, 0),
                Size = UDim2.new(0, 2, 1, 0),
                Visible = false,
                ZIndex = 10000,
                Parent = ScreenGui,
            })
        end

        if not SnapGuideY then
            SnapGuideY = New("Frame", {
                BackgroundColor3 = "AccentColor",
                BackgroundTransparency = 0.25,
                BorderSizePixel = 0,
                AnchorPoint = Vector2.new(0, 0.5),
                Size = UDim2.new(1, 0, 0, 2),
                Visible = false,
                ZIndex = 10000,
                Parent = ScreenGui,
            })
        end

        return SnapGuideX, SnapGuideY
    end

    local function HideSnapGuides()
        if SnapGuideX then
            SnapGuideX.Visible = false
        end
        if SnapGuideY then
            SnapGuideY.Visible = false
        end
    end

    InputBegan = DragFrame.InputBegan:Connect(function(Input: InputObject)
        if not IsClickInput(Input) or IsMainWindow and Library.CantDragForced then
            return
        end

        StartPos = Input.Position
        FramePos = UI.Position
        Dragging = true

        Changed = Input.Changed:Connect(function()
            if Input.UserInputState ~= Enum.UserInputState.End then
                return
            end

            Dragging = false
            HideSnapGuides()

            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end
        end)
    end)

    InputChanged = UserInputService.InputChanged:Connect(function(Input: InputObject)
        if
            (not IgnoreToggled and not Library.Toggled)
            or (IsMainWindow and Library.CantDragForced)
            or not (ScreenGui and ScreenGui.Parent)
        then
            Dragging = false
            HideSnapGuides()

            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end

            return
        end

        if Dragging and IsHoverInput(Input) then
            local Delta = Input.Position - StartPos
            local NewX = FramePos.X.Offset + Delta.X
            local NewY = FramePos.Y.Offset + Delta.Y

            if SnapConfig and SnapConfig.Enabled then
                local ViewportSize = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1920, 1080)
                local Distance = SnapConfig.Distance or 28
                local Margin = SnapConfig.Margin or 8

                local AbsX = FramePos.X.Scale * ViewportSize.X + NewX
                local AbsY = FramePos.Y.Scale * ViewportSize.Y + NewY

                local ElemSize = UI.AbsoluteSize
                local TargetsX, TargetsY = GetSnapEdges(ElemSize, ViewportSize, Margin, SnapConfig.AvoidCoreGui ~= false)
                local SnappedX, SnappedXName = GetClosestSnapTarget(AbsX, TargetsX, Distance)
                local SnappedY, SnappedYName = GetClosestSnapTarget(AbsY, TargetsY, Distance)

                if SnappedX then
                    NewX = SnappedX - FramePos.X.Scale * ViewportSize.X
                end
                if SnappedY then
                    NewY = SnappedY - FramePos.Y.Scale * ViewportSize.Y
                end

                local GuideX, GuideY = GetSnapGuides()
                GuideX.Visible = SnappedX ~= nil
                if SnappedX then
                    GuideX.Position = UDim2.fromOffset(GetSnapGuideOffset(SnappedXName, SnappedX, ElemSize.X), 0)
                end

                GuideY.Visible = SnappedY ~= nil
                if SnappedY then
                    GuideY.Position = UDim2.fromOffset(0, GetSnapGuideOffset(SnappedYName, SnappedY, ElemSize.Y))
                end
            end

            UI.Position = UDim2.new(FramePos.X.Scale, NewX, FramePos.Y.Scale, NewY)
        end
    end)

    Library:GiveSignal(InputChanged)
    Library:GiveSignal(InputBegan)

    UI.Destroying:Once(function()
        if InputChanged and InputChanged.Connected then
            InputChanged:Disconnect()
        end

        if InputBegan and InputBegan.Connected then
            InputBegan:Disconnect()
        end

        if Changed and Changed.Connected then
            Changed:Disconnect()
        end

        if SnapGuideX then
            SnapGuideX:Destroy()
        end
        if SnapGuideY then
            SnapGuideY:Destroy()
        end

        local IdxChanged = table.find(Library.Signals, InputChanged)
        if IdxChanged then
            table.remove(Library.Signals, IdxChanged)
        end

        local IdxBegan = table.find(Library.Signals, InputBegan)
        if IdxBegan then
            table.remove(Library.Signals, IdxBegan)
        end
    end)
end

function Library:MakeResizable(UI: GuiObject, DragFrame: GuiObject, Callback: () -> ()?)
    local StartPos
    local FrameSize
    local Dragging = false
    local Changed
    local InputBegan
    local InputChanged

    InputBegan = DragFrame.InputBegan:Connect(function(Input: InputObject)
        if not IsClickInput(Input) then
            return
        end

        StartPos = Input.Position
        FrameSize = UI.Size
        Dragging = true

        Changed = Input.Changed:Connect(function()
            if Input.UserInputState ~= Enum.UserInputState.End then
                return
            end

            Dragging = false
            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end
        end)
    end)

    InputChanged = UserInputService.InputChanged:Connect(function(Input: InputObject)
        if not UI.Visible or not (ScreenGui and ScreenGui.Parent) then
            Dragging = false
            if Changed and Changed.Connected then
                Changed:Disconnect()
                Changed = nil
            end

            return
        end

        if Dragging and IsHoverInput(Input) then
            local Delta = Input.Position - StartPos
            UI.Size = UDim2.new(
                FrameSize.X.Scale,
                math.clamp(FrameSize.X.Offset + Delta.X, Library.MinSize.X, math.huge),
                FrameSize.Y.Scale,
                math.clamp(FrameSize.Y.Offset + Delta.Y, Library.MinSize.Y, math.huge)
            )
            if Callback then
                Library:SafeCallback(Callback)
            end
        end
    end)

    Library:GiveSignal(InputChanged)
    Library:GiveSignal(InputBegan)

    UI.Destroying:Once(function()
        if InputChanged and InputChanged.Connected then
            InputChanged:Disconnect()
        end

        if InputBegan and InputBegan.Connected then
            InputBegan:Disconnect()
        end

        if Changed and Changed.Connected then
            Changed:Disconnect()
        end

        local IdxChanged = table.find(Library.Signals, InputChanged)
        if IdxChanged then
            table.remove(Library.Signals, IdxChanged)
        end

        local IdxBegan = table.find(Library.Signals, InputBegan)
        if IdxBegan then
            table.remove(Library.Signals, IdxBegan)
        end
    end)
end

function Library:MakeCover(Holder: GuiObject, Place: string)
    local Pos = Places[Place] or { 0, 0 }
    local Size = Sizes[Place] or { 1, 0.5 }

    local Cover = New("Frame", {
        AnchorPoint = Vector2.new(Pos[1], Pos[2]),
        BackgroundColor3 = Holder.BackgroundColor3,
        Position = UDim2.fromScale(Pos[1], Pos[2]),
        Size = UDim2.fromScale(Size[1], Size[2]),
        Parent = Holder,
    })

    return Cover
end

function Library:MakeLine(Frame: GuiObject, Info)
    local Line = New("Frame", {
        AnchorPoint = Info.AnchorPoint or Vector2.zero,
        BackgroundColor3 = "OutlineColor",
        LayoutOrder = Info.LayoutOrder or 0,
        Position = Info.Position,
        Size = Info.Size,
        ZIndex = Info.ZIndex or Frame.ZIndex,
        Parent = Frame,
    })

    return Line
end

function Library:AddOutline(Frame: GuiObject)
    local OutlineStroke = New("UIStroke", {
        Color = "OutlineColor",
        Thickness = 1,
        ZIndex = 2,
        Parent = Frame,
    })
    local ShadowStroke = New("UIStroke", {
        Color = "DarkColor",
        Thickness = 1.5,
        ZIndex = 1,
        Parent = Frame,
    })
    return OutlineStroke, ShadowStroke
end

function Library:AddBlank(Frame: GuiObject, Size: UDim2)
    return New("Frame", {
        BackgroundTransparency = 1,
        Size = Size or UDim2.fromScale(0, 0),
        Parent = Frame,
    })
end

--// Animations \\--
local TransparencyCache = {}
local ActiveTabTweens = setmetatable({}, { __mode = "k" })

function Library:PlayTabAnimation(Tab, Showing: boolean, OnComplete: (() -> ())?)
    if type(Tab) ~= "table" or not Tab.Container then
        if OnComplete then
            OnComplete()
        end

        return
    end

    local TabContainer = Tab.Container :: Frame
    local Existing = ActiveTabTweens[TabContainer]
    if Existing then
        StopTween(Existing, true)
        ActiveTabTweens[TabContainer] = nil
    end

    local BaseZIndex = TabContainer.ZIndex
    if not (Library.Animations and Library.Animations.TabSwitch) then
        TabContainer.Visible = Showing
        TabContainer.Position = UDim2.fromScale(0, 0)
        TabContainer.ZIndex = BaseZIndex

        if OnComplete then
            OnComplete()
        end

        return
    end

    if Showing then
        local TweenInfo = Library.TabTransitionInfo or TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local Offset = Library.TabSwipeOffset or 26
        local SwipeFrom = string.lower(Library.TabSwipeFrom or "bottom")
        local StartPosition
        local StartingPositions = {
            Left = UDim2.fromOffset(-Offset, 0),
            Right = UDim2.fromOffset(Offset, 0),
            Top = UDim2.fromOffset(0, -Offset),
            Bottom = UDim2.fromOffset(0, Offset),
        }

        if SwipeFrom == "auto" and Library.PreviousTab then
            local CurrentOrder = Tab.Button.LayoutOrder
            local PreviousOrder = Library.PreviousTab.Button.LayoutOrder
            if CurrentOrder and PreviousOrder then -- this may be unnecessary but oh well
                StartPosition = CurrentOrder > PreviousOrder and StartingPositions.Top or StartingPositions.Bottom -- bigger order means its under the current button
            else
                StartPosition = StartingPositions.Bottom
            end
        elseif SwipeFrom == "left" then
            StartPosition = StartingPositions.Left
        elseif SwipeFrom == "top" then
            StartPosition = StartingPositions.Top
        elseif SwipeFrom == "right" then
            StartPosition = StartingPositions.Right
        else -- bottom (Default)
            StartPosition = StartingPositions.Bottom
        end

        TabContainer.ZIndex = BaseZIndex + 1
        TabContainer.Position = StartPosition
        TabContainer.Visible = true

        local Tween = TweenService:Create(TabContainer, TweenInfo, {
            Position = UDim2.fromScale(0, 0)
        })

        ActiveTabTweens[TabContainer] = Tween
        Tween:Play()

        local Connection; Connection = Tween.Completed:Connect(function(PlaybackState)
            if Connection then
                Connection:Disconnect()
            end

            if ActiveTabTweens[TabContainer] == Tween then
                ActiveTabTweens[TabContainer] = nil
            end

            if PlaybackState == Enum.PlaybackState.Cancelled then
                return
            end

            TabContainer.ZIndex = BaseZIndex
            if OnComplete then
                OnComplete()
            end
        end)
    else
        TabContainer.Visible = false
        TabContainer.Position = UDim2.fromScale(0, 0)
        TabContainer.ZIndex = BaseZIndex

        if OnComplete then
            OnComplete()
        end
    end
end

--// Pop Out \\--
function Library:MakeBoxPopOut(Box: any, Options: {
    Enabled: boolean?,
    Header: GuiObject?,
    Children: (() -> { GuiObject })?,
    Before: (() -> ())?,
    After: (() -> ())?,
    MaxPopOutHeight: number?,
    PopOutWidth: number?,
})
    Box.PoppedOut = false
    Box.PopOutEnabled = Options.Enabled ~= false
    Box.PopOutFloat = nil
    Box.PopOutPlaceholder = nil
    Box.PopOutMaxHeight = if typeof(Options.MaxPopOutHeight) == "number" then Options.MaxPopOutHeight else nil
    Box.PopOutWidth = if typeof(Options.PopOutWidth) == "number" then Options.PopOutWidth else nil

    if not Box.PopOutEnabled then
        function Box:SetPoppedOut(_Value: boolean, _SetPoppedOut: UDim2) end
        function Box:TogglePoppedOut() end
        function Box:RefreshPopOutPlaceholder() end
        function Box:SetMaxPopOutHeight(_Height: number?) end
        function Box:SetPopOutWidth(_Width: number?) end
        return
    end

    local BoxHolder = Box.BoxHolder
    local Holder = Box.Holder
    local Header = Options.Header

    local Placeholder
    local PlaceholderHeader
    local Float
    local FloatScale

    local HandledChildren: { GuiObject } = {}
    local OriginalParents: { [GuiObject]: Instance? } = {}
    local OriginalLayoutOrders: { [GuiObject]: number } = {}

    local DragState: "Idle" | "Holding" | "Dragging" = "Idle"
    local DragInput: InputObject?
    local PressMouse: Vector2?

    local DragStartPos: UDim2?
    local DragChanged: RBXScriptConnection?
    local DragDidMove = false

    --// UI Handler
    local function GetPopOutWidth(): number
        if typeof(Box.PopOutWidth) == "number" then
            return math.max(50, math.floor(Box.PopOutWidth + 0.5))
        end

        if typeof(Box.PopOutDockedWidth) == "number" then
            return math.max(50, math.floor(Box.PopOutDockedWidth + 0.5))
        end

        local Width = Holder.AbsoluteSize.X / Library.DPIScale
        if Width < 50 then
            Width = 200
        end

        return math.max(50, math.floor(Width + 0.5))
    end

    local function ApplyPopOutWidth()
        if not (Box.PoppedOut and Float) then
            return
        end

        Float.Size = UDim2.fromOffset(GetPopOutWidth(), Float.Size.Y.Offset)
        if Box.Resize then
            Box:Resize()
        end
    end

    local function RaiseFloat()
        if not Float or not Floats then
            return
        end

        local MaxZ = Float.ZIndex
        for _, Child in Floats:GetChildren() do
            if Child:IsA("GuiObject") and Child ~= Float then
                MaxZ = math.max(MaxZ, Child.ZIndex)
            end
        end

        Float.ZIndex = MaxZ + 1
        if Float.Parent == Floats then
            Float.Parent = Overlay
        end
        Float.Parent = Floats
    end

    local function CreatePlaceholder()
        local Frame = New("Frame", {
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = "BackgroundColor",
            BackgroundTransparency = 0.12,
            ClipsDescendants = true,
            Size = UDim2.new(1, 0, 0, 0),
            Parent = BoxHolder,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius),
                Parent = Frame,
            })
        )
        Library:AddOutline(Frame)

        PlaceholderHeader = Header:Clone()
        PlaceholderHeader.Parent = Frame
        RegisterPopOutClone(Header, PlaceholderHeader)
        DimPopOutClone(PlaceholderHeader)

        if PopOutIcon then
            local PlaceholderDockIcon = New("ImageButton", {
                AutoButtonColor = false,
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundTransparency = 1,
                ImageColor3 = "WhiteColor",
                Position = UDim2.new(1, -8, 0.5, 0),
                Size = UDim2.fromOffset(22, 22),
                ZIndex = PlaceholderHeader.ZIndex + 1,
                Parent = Frame,
            })
            Library:ApplyLucideIcon(PlaceholderDockIcon, PopOutIcon)
            PlaceholderDockIcon.MouseButton1Click:Connect(function()
                Box:SetPoppedOut(false)
            end)
        end

        return Frame
    end

    function Box:RefreshPopOutPlaceholder()
        if not Box.PoppedOut or not Placeholder or not Header then
            return
        end

        if PlaceholderHeader then
            PlaceholderHeader:Destroy()
            PlaceholderHeader = nil
        end

        PlaceholderHeader = Header:Clone()
        PlaceholderHeader.Parent = Placeholder
        RegisterPopOutClone(Header, PlaceholderHeader)
        DimPopOutClone(PlaceholderHeader)
    end

    function Box:SetPoppedOut(Value: boolean, FloatPosition: UDim2?)
        if not Box.PopOutEnabled or Box.Destroyed then
            return
        end

        Value = Value == true
        if Box.PoppedOut == Value then
            if Value and FloatPosition and Float then
                Float.Position = FloatPosition
            end
            return
        end

        if Value then
            if Options.Before then
                Options.Before()
            end

            local BoxChildren = if Options.Children then Options.Children() else { Holder }
            HandledChildren = {}

            table.clear(OriginalParents)
            table.clear(OriginalLayoutOrders)

            for _, Child in BoxChildren do
                if not Child or not Child.Parent then
                    continue
                end

                table.insert(HandledChildren, Child)
                OriginalParents[Child] = Child.Parent
                OriginalLayoutOrders[Child] = Child.LayoutOrder
            end

            if #HandledChildren == 0 then
                return
            end

            local DockedWidth = Holder.AbsoluteSize.X / Library.DPIScale
            if DockedWidth < 50 then
                DockedWidth = 200
            end
            Box.PopOutDockedWidth = math.max(50, math.floor(DockedWidth + 0.5))

            local Width = GetPopOutWidth()

            local AbsolutePosition = Holder.AbsolutePosition
            Placeholder = CreatePlaceholder()
            Box.PopOutPlaceholder = Placeholder

            Float = New("Frame", {
                Active = true,
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Position = FloatPosition or UDim2.fromOffset(
                    AbsolutePosition.X / Library.DPIScale,
                    AbsolutePosition.Y / Library.DPIScale
                ),
                Size = UDim2.fromOffset(Width, 0),
                ZIndex = 1,
                Parent = Floats,
            })
            FloatScale = New("UIScale", {
                Parent = Float,
            })
            table.insert(Library.Scales, FloatScale)
            FloatScale.Scale = Library.DPIScale - (tonumber(Library.ScalesOffset[FloatScale]) or 0)

            New("UIListLayout", {
                Padding = UDim.new(0, 6),
                Parent = Float,
            })

            for _, Child in HandledChildren do
                Child.Parent = Float
            end

            if not table.find(Library.DraggableElements, Float) then
                table.insert(Library.DraggableElements, Float)
            end

            Box.PopOutFloat = Float
            Box.PoppedOut = true
            SyncPopOutVisibility(Box)
            RaiseFloat()

            Float:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
                Box:Resize()
            end)

            if Options.After then
                Options.After()
            end

            return
        end

        if Float then
            local DraggableIndex = table.find(Library.DraggableElements, Float)
            if DraggableIndex then
                table.remove(Library.DraggableElements, DraggableIndex)
            end
        end

        if FloatScale then
            local ScaleIndex = table.find(Library.Scales, FloatScale)
            if ScaleIndex then
                table.remove(Library.Scales, ScaleIndex)
            end

            FloatScale = nil
        end

        for _, Child in HandledChildren do
            if not Child or not Child.Parent then
                continue
            end

            Child.Parent = OriginalParents[Child] or BoxHolder
            Child.LayoutOrder = OriginalLayoutOrders[Child] or 0
        end

        if Placeholder then
            Placeholder:Destroy()
            Placeholder = nil
        end
        
        PlaceholderHeader = nil

        if Float then
            Float:Destroy()
            Float = nil
        end

        Box.PopOutFloat = nil
        Box.PopOutPlaceholder = nil
        Box.PopOutDockedWidth = nil
        Box.PoppedOut = false

        table.clear(HandledChildren)
        table.clear(OriginalParents)
        table.clear(OriginalLayoutOrders)

        if Options.After then
            Options.After()
        end
    end

    function Box:TogglePoppedOut()
        Box:SetPoppedOut(not Box.PoppedOut)
    end

    function Box:SetMaxPopOutHeight(Height: number?)
        if Height ~= nil then
            assert(typeof(Height) == "number", "Height must be a number or nil")
            assert(Height >= 0, "Height must be higher than 0")
        end

        Box.PopOutMaxHeight = Height
        if Box.PoppedOut and Box.Resize then
            Box:Resize()
        end
    end

    function Box:SetPopOutWidth(Width: number?)
        if Width ~= nil then
            assert(typeof(Width) == "number", "Width must be a number or nil")
            assert(Width >= 0, "Width must be higher than 0")
        end

        Box.PopOutWidth = Width
        ApplyPopOutWidth()
    end

    --// Drag Handler
    local function StopDrag()
        if DragState == "Idle" then
            return
        end

        local WasDragging = DragState == "Dragging"
        local DidMove = DragDidMove
        DragState = "Idle"
        DragInput = nil
        PressMouse = nil
        DragStartPos = nil
        DragDidMove = false

        if DragChanged and DragChanged.Connected then
            DragChanged:Disconnect()
            DragChanged = nil
        end

        if not WasDragging or not Box.PoppedOut or not Float then
            return
        end

        local FloatCenter = Float.AbsolutePosition + (Float.AbsoluteSize * 0.5)
        local NearPlaceholder = false
        if Library.Toggled and Placeholder and Placeholder.Parent then
            local PlaceholderCenter = Placeholder.AbsolutePosition + (Placeholder.AbsoluteSize * 0.5)
            NearPlaceholder = (FloatCenter - PlaceholderCenter).Magnitude <= Library.PopOutSnapDistance
        end

        if NearPlaceholder or (DidMove and not IsScreenPointOutsideMain(FloatCenter)) then
            Box:SetPoppedOut(false)
        end
    end

    local function BeginDrag(Input: InputObject)
        if DragState ~= "Idle" or Box.Destroyed or not (ScreenGui and ScreenGui.Parent) then
            return
        end

        local Point = Vector2.new(Input.Position.X, Input.Position.Y)
        local Top = GetTopFloatAt(Point)
        if Box.PoppedOut then
            if not Float or Top ~= Float then
                return
            end
        elseif Top ~= nil and not Header:IsDescendantOf(Top) then
            return
        end

        DragState = "Holding"
        DragInput = Input
        PressMouse = Vector2.new(Input.Position.X, Input.Position.Y)
        DragStartPos = nil
        DragDidMove = false

        if Box.PoppedOut and Float then
            RaiseFloat()
        end

        DragChanged = Input.Changed:Connect(function()
            if Input.UserInputState == Enum.UserInputState.End then
                StopDrag()
            end
        end)

        task.delay(Library.PopOutHoldTime, function()
            if (DragState :: any) ~= "Holding" or DragInput ~= Input then
                return
            end

            DragState = "Dragging"
            if Box.PoppedOut and Float then
                RaiseFloat()
                DragStartPos = Float.Position
            end
        end)
    end

    local function UpdateDrag(Input: InputObject)
        if DragState ~= "Dragging" or not PressMouse then
            return
        end
        if not (ScreenGui and ScreenGui.Parent) then
            StopDrag()
            return
        end

        local MousePosition = Vector2.new(Input.Position.X, Input.Position.Y)
        local Delta = MousePosition - PressMouse

        if not Box.PoppedOut then
            if Delta.Magnitude < Library.PopOutDragThreshold then
                return
            end

            Box:SetPoppedOut(true)
            if not Float then
                return
            end

            RaiseFloat()
            DragStartPos = Float.Position
            DragDidMove = true
        elseif Delta.Magnitude >= Library.PopOutDragThreshold then
            DragDidMove = true
        end

        if Float and DragStartPos then
            Float.Position = UDim2.new(
                DragStartPos.X.Scale,
                DragStartPos.X.Offset + Delta.X,
                DragStartPos.Y.Scale,
                DragStartPos.Y.Offset + Delta.Y
            )
        end
    end

    local function BindDragSource(Gui: GuiObject)
        Library:GiveSignal(Gui.InputBegan:Connect(function(Input: InputObject)
            if IsClickInput(Input) then
                BeginDrag(Input)
            end
        end))
    end

    BindDragSource(Header)
    for _, Descendant in Header:QueryDescendants("GuiObject:not(ImageButton)") do
        BindDragSource(Descendant)
    end

    Library:GiveSignal(Header.DescendantAdded:Connect(function(Descendant)
        if Descendant:IsA("GuiObject") and not Descendant:IsA("ImageButton") then
            BindDragSource(Descendant)
        end
    end))

    Library:GiveSignal(UserInputService.InputChanged:Connect(function(Input: InputObject)
        if IsHoverInput(Input) then
            UpdateDrag(Input)
        end
    end))
end

--// Deprecated \\--
function Library:MakeOutline(Frame: GuiObject, Corner: number?, ZIndex: number?)
    warn("Obsidian:MakeOutline is deprecated, please use Obsidian:AddOutline instead.")
    local Holder = New("Frame", {
        BackgroundColor3 = "DarkColor",
        Position = UDim2.fromOffset(-2, -2),
        Size = UDim2.new(1, 4, 1, 4),
        ZIndex = ZIndex,
        Parent = Frame,
    })

    local Outline = New("Frame", {
        BackgroundColor3 = "OutlineColor",
        Position = UDim2.fromOffset(1, 1),
        Size = UDim2.new(1, -2, 1, -2),
        ZIndex = ZIndex,
        Parent = Holder,
    })

    if Corner and Corner > 0 then
        New("UICorner", {
            CornerRadius = UDim.new(0, Corner + 1),
            Parent = Holder,
        })
        New("UICorner", {
            CornerRadius = UDim.new(0, Corner),
            Parent = Outline,
        })
    end

    return Holder, Outline
end

function Library:AddDraggableLabel(...)
    local Params = select(1, ...)
    local Text
    local Icon
    local IconPosition = "left"

    if typeof(Params) == "table" then
        Text = Params.Text
        Icon = Params.Icon
        IconPosition = Params.IconPosition or "left"
    elseif typeof(Params) == "string" then
        Text = Params
        Icon = select(2, ...)
        IconPosition = select(3, ...) or "left"
    end

    if typeof(IconPosition) ~= "string" then
        IconPosition = "left"
    end

    IconPosition = string.lower(IconPosition)
    assert(IconPosition == "left" or IconPosition == "right", "Icon Position needs to be either 'left' or 'right'.")

    local DraggableLabel = {
        Connections = {},
        Destroyed = false
    }

    local IconImage
    local Label = New("TextLabel", {
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundColor3 = "BackgroundColor",
        Size = UDim2.fromOffset(0, 0),
        Position = UDim2.fromOffset(6, 6),
        Text = Text,
        TextSize = 15,
        ZIndex = 1,
        Parent = Floats,
    })

    table.insert(
        Library.Corners,
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius),
            Parent = Label,
        })
    )

    local Padding = New("UIPadding", {
        PaddingBottom = UDim.new(0, 6),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 6),
        Parent = Label,
    })
    table.insert(
        Library.Scales,
        New("UIScale", {
            Parent = Label,
        })
    )

    Library:AddOutline(Label)
    Library:MakeDraggable(Label, Label, true)

    function DraggableLabel:SetText(Text: string)
        Label.Text = Text
    end

    function DraggableLabel:SetIcon(NewIcon: string)
        Icon = NewIcon

        local IsNotEmpty = Icon and Trim(tostring(Icon)) ~= ""
        if IsNotEmpty then
            local CustomIcon = Library:GetCustomIcon(Icon)
            assert(CustomIcon, "Icon must be a valid Roblox asset or a valid URL or a valid lucide icon.")

            IconImage = IconImage or New("ImageLabel", {
                BackgroundTransparency = 1,
                ImageColor3 = "FontColor",
                Size = UDim2.fromOffset(16, 16),
                ZIndex = 2,
                Parent = Label,
            })

            Library:ApplyLucideIcon(IconImage, CustomIcon)
        end

        if IconImage then IconImage.Visible = IsNotEmpty end
        DraggableLabel:SetIconPosition(IconPosition)
    end

    function DraggableLabel:SetIconPosition(NewPosition: string)
        IconPosition = string.lower(NewPosition)
        assert(IconPosition == "left" or IconPosition == "right", "Icon Position needs to be either 'left' or 'right'.")

        local IsNotEmpty = Icon and Trim(tostring(Icon)) ~= ""
        Padding.PaddingLeft = UDim.new(0, (IsNotEmpty and IconPosition == "left") and 34 or 12)
        Padding.PaddingRight = UDim.new(0, (IsNotEmpty and IconPosition == "right") and 34 or 12)

        if IconImage then
            if IconPosition == "left" then
                IconImage.AnchorPoint = Vector2.new(0, 0.5)
                IconImage.Position = UDim2.new(0, -22, 0.5, 0)
            else
                IconImage.AnchorPoint = Vector2.new(1, 0.5)
                IconImage.Position = UDim2.new(1, 22, 0.5, 0)
            end
        end
    end

    function DraggableLabel:SetVisible(Visible: boolean)
        Label.Visible = Visible
    end

    DraggableLabel:SetIcon(Icon)
    DraggableLabel.Label = Label

    if not table.find(Library.DraggableElements, Label) then
        table.insert(Library.DraggableElements, Label)
    end

    PositionDraggable(Label, Label.Position)

    function DraggableLabel:Destroy()
        DraggableLabel.Destroyed = true

        if DraggableLabel.Connections then
            for _, connection in DraggableLabel.Connections do
                connection:Disconnect()
            end
        end

        local ElemIdx = table.find(Library.DraggableElements, Label)
        if ElemIdx then
            table.remove(Library.DraggableElements, ElemIdx)
        end

        if Label then
            Label:Destroy()
        end
    end

    return DraggableLabel
end

function Library:AddDraggableButton(...)
    local Params = select(1, ...)

    local Text
    local Func
    local ExcludeScaling
    local ExcludeDragging

    if typeof(Params) == "table" then
        Text = Params.Text
        Func = Params.Callback or Params.Func
        ExcludeScaling = Params.ExcludeScaling
        ExcludeDragging = Params.ExcludeDragging
    elseif typeof(Params) == "string" then
        Text = Params
        Func = select(2, ...)
        ExcludeScaling = select(3, ...)
        ExcludeDragging = select(4, ...)
    end

    local DraggableButton = {
        Connections = {},
        Destroyed = false
    }

    local Button = New("TextButton", {
        BackgroundColor3 = "BackgroundColor",
        Position = UDim2.fromOffset(6, 6),
        TextSize = 16,
        ZIndex = 1,
        Parent = Floats,
    })
    table.insert(
        Library.Corners,
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius),
            Parent = Button,
        })
    )
    if not ExcludeScaling then
        table.insert(
            Library.Scales,
            New("UIScale", {
                Parent = Button,
            })
        )
    end
    Library:AddOutline(Button)

    local PressPosition
    Button.InputBegan:Connect(function(Input: InputObject)
        if IsMouseInput(Input) then
            PressPosition = Button.AbsolutePosition
        end
    end)
    Button.Activated:Connect(function()
        if PressPosition and (Button.AbsolutePosition - PressPosition).Magnitude > 10 then
            return
        end

        Library:SafeCallback(Func, DraggableButton)
    end)

    function DraggableButton:SetText(Text: string)
        local X, Y = Library:GetTextBounds(Text, Library.Scheme.Font, 16)

        Button.Text = Text
        Button.Size = UDim2.fromOffset(X * 2, Y * 2)
    end

    if not ExcludeDragging then
        Library:MakeDraggable(Button, Button, true)
    end
    DraggableButton:SetText(Text)
    DraggableButton.Button = Button

    if not table.find(Library.DraggableElements, Button) then
        table.insert(Library.DraggableElements, Button)
    end

    PositionDraggable(Button, Button.Position)

    function DraggableButton:Destroy()
        DraggableButton.Destroyed = true

        if DraggableButton.Connections then
            for _, connection in DraggableButton.Connections do
                connection:Disconnect()
            end
        end

        local ElemIdx = table.find(Library.DraggableElements, Button)
        if ElemIdx then
            table.remove(Library.DraggableElements, ElemIdx)
        end

        if Button then
            Button:Destroy()
        end
    end

    return DraggableButton
end

function Library:AddDraggableMenu(Name: string)
    local Holder = New("Frame", {
        AutomaticSize = Enum.AutomaticSize.XY,
        BackgroundColor3 = "BackgroundColor",
        Position = UDim2.fromOffset(6, 6),
        Size = UDim2.fromOffset(0, 0),
        ZIndex = 1,
        Parent = Floats,
    })
    table.insert(
        Library.Corners,
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius),
            Parent = Holder,
        })
    )
    table.insert(
        Library.Scales,
        New("UIScale", {
            Parent = Holder,
        })
    )
    Library:AddOutline(Holder)

    local DividerLine = Library:MakeLine(Holder, {
        Position = UDim2.fromOffset(0, 34),
        Size = UDim2.new(1, 0, 0, 1),
    })

    local Label = New("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 34),
        Text = Name,
        TextSize = 15,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Holder,
    })
    local LabelPadding = New("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        Parent = Label,
    })

    local Container = New("Frame", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 35),
        Size = UDim2.new(1, 0, 1, -35),
        Parent = Holder,
    })
    New("UIListLayout", {
        Padding = UDim.new(0, 7),
        Parent = Container,
    })
    New("UIPadding", {
        PaddingBottom = UDim.new(0, 7),
        PaddingLeft = UDim.new(0, 7),
        PaddingRight = UDim.new(0, 7),
        PaddingTop = UDim.new(0, 7),
        Parent = Container,
    })

    Library:MakeDraggable(Holder, Label, true)

    if not table.find(Library.DraggableElements, Holder) then
        table.insert(Library.DraggableElements, Holder)
    end

    PositionDraggable(Holder, Holder.Position)

    return Holder, Container, Label, DividerLine, LabelPadding
end

function Library:AddDraggableImageButton(...)
    local Params = select(1, ...)

    local Icon
    local IconSize
    local Func
    local ExcludeScaling
    local ExcludeDragging

    if typeof(Params) == "table" then
        Icon = Params.Icon
        IconSize = Params.IconSize or 24
        Func = Params.Callback or Params.Func
        ExcludeScaling = Params.ExcludeScaling
        ExcludeDragging = Params.ExcludeDragging
    elseif typeof(Params) == "string" or typeof(Params) == "number" then
        Icon = Params
        IconSize = select(2, ...)
        Func = select(3, ...)
        ExcludeScaling = select(4, ...)
        ExcludeDragging = select(5, ...)
    end

    local DraggableImageButton = {}

    local Button = New("TextButton", {
        BackgroundColor3 = "BackgroundColor",
        Position = UDim2.fromOffset(6, 6),
        Size = UDim2.fromOffset(IconSize + 12, IconSize + 12),
        Text = "",
        ZIndex = 1,
        Parent = Floats,
    })

    local IconImage = New("ImageLabel", {
        BackgroundTransparency = 1,
        AnchorPoint = Vector2.new(0.5, 0.5),
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(IconSize, IconSize),
        ImageColor3 = "FontColor",
        ZIndex = 2,
        Parent = Button,
    })

    table.insert(
        Library.Corners,
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius),
            Parent = Button,
        })
    )
    if not ExcludeScaling then
        table.insert(
            Library.Scales,
            New("UIScale", {
                Parent = Button,
            })
        )
    end
    Library:AddOutline(Button)

    local PressPosition
    Button.InputBegan:Connect(function(Input: InputObject)
        if IsMouseInput(Input) then
            PressPosition = Button.AbsolutePosition
        end
    end)
    Button.Activated:Connect(function()
        if PressPosition and (Button.AbsolutePosition - PressPosition).Magnitude > 10 then
            return
        end

        Library:SafeCallback(Func, DraggableImageButton)
    end)

    function DraggableImageButton:SetIcon(NewIcon: string)
        Icon = NewIcon or Icon

        local CustomIcon = Library:GetCustomIcon(Icon)
        assert(CustomIcon, "Icon must be a valid Roblox asset or a valid URL or a valid lucide icon.")

        Library:ApplyLucideIcon(IconImage, CustomIcon)
    end

    function DraggableImageButton:SetIconSize(NewSize: number)
        IconSize = NewSize
        IconImage.Size = UDim2.fromOffset(IconSize, IconSize)
        Button.Size = UDim2.fromOffset(IconSize + 12, IconSize + 12)
    end

    if not ExcludeDragging then
        Library:MakeDraggable(Button, Button, true)
    end
    DraggableImageButton:SetIcon(Icon)
    DraggableImageButton.Button = Button

    if not table.find(Library.DraggableElements, Button) then
        table.insert(Library.DraggableElements, Button)
    end

    PositionDraggable(Button, Button.Position)

    return DraggableImageButton
end

--// Watermark - Deprecated \\--
do
    local WatermarkLabel = Library:AddDraggableLabel("")
    WatermarkLabel:SetVisible(false)

    function Library:SetWatermark(Text: string)
        warn("Watermark is deprecated, please use Library:AddDraggableLabel instead.")
        WatermarkLabel:SetText(Text)
    end

    function Library:SetWatermarkVisibility(Visible: boolean)
        warn("Watermark is deprecated, please use Library:AddDraggableLabel instead.")
        WatermarkLabel:SetVisible(Visible)
    end
end

--// Context Menu \\--
local CurrentMenu
function Library:AddContextMenu(
    Holder: GuiObject,
    Size: UDim2 | () -> (),
    Offset: { [number]: number } | () -> {},
    List: number?,
    ActiveCallback: (Active: boolean) -> ()?,
    IgnoreCornerRadius: boolean?,
    SpecificCornersOnly: ("top" | "bottom" | "no_left" | "no_top_left")?, -- stupid way of doing this
    AnimationType: ("Dropdown" | "KeyPicker" | "SettingsPopup" | "none")?
)
    local Menu
    local HolderGui = Holder:FindFirstAncestorOfClass("ScreenGui")
    local ParentGui = Overlay
    if HolderGui and HolderGui ~= ScreenGui and Library.ActiveLoading and HolderGui == Library.ActiveLoading.ScreenGui then
        ParentGui = HolderGui
    end

    if List then
        Menu = New("ScrollingFrame", {
            AutomaticCanvasSize = Enum.AutomaticSize.None,
            AutomaticSize = List == 1 and Enum.AutomaticSize.Y or Enum.AutomaticSize.None,
            BackgroundColor3 = "BackgroundColor",
            BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
            CanvasSize = UDim2.fromOffset(0, 0),
            ScrollBarImageColor3 = "OutlineColor",
            ScrollBarThickness = List == 2 and 2 or 0,
            Size = typeof(Size) == "function" and Size() or Size,
            TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
            Visible = false,
            ZIndex = 1,
            Parent = ParentGui,
        })
    else
        Menu = New("Frame", {
            BackgroundColor3 = "BackgroundColor",
            Size = typeof(Size) == "function" and Size() or Size,
            Visible = false,
            ZIndex = 1,
            Parent = ParentGui,
        })
    end
    table.insert(
        Library.Scales,
        New("UIScale", {
            Parent = Menu,
        })
    )

    New("UIStroke", {
        Color = "OutlineColor",
        Parent = Menu,
    })

    local Corner;
    if IgnoreCornerRadius ~= true then
        if SpecificCornersOnly == "top" then
            Corner = New("UICorner", {
                TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
                TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
                BottomRightRadius = UDim.new(0, 0),
                BottomLeftRadius = UDim.new(0, 0),
                Parent = Menu,
            }); table.insert(Library.SpecificCorners, Corner)
        elseif SpecificCornersOnly == "bottom" then
            Corner = New("UICorner", {
                TopLeftRadius = UDim.new(0, 0),
                TopRightRadius = UDim.new(0, 0),
                BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
                BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Menu,
            }); table.insert(Library.SpecificCorners, Corner)
        elseif SpecificCornersOnly == "no_left" then
            Corner = New("UICorner", {
                TopLeftRadius = UDim.new(0, 0),
                TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
                BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
                BottomLeftRadius = UDim.new(0, 0),
                Parent = Menu,
            }); table.insert(Library.SpecificCorners, Corner)
        elseif SpecificCornersOnly == "no_top_left" then
            Corner = New("UICorner", {
                TopLeftRadius = UDim.new(0, 0),
                TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
                BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
                BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Menu,
            }); table.insert(Library.SpecificCorners, Corner)
        else
            Corner = New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Menu,
            }); table.insert(Library.Corners, Corner)
        end
    end

    local Table = {
        Connections = {},
        Destroyed = false,

        Active = false,
        ActiveCallback = ActiveCallback,

        Holder = Holder,
        Menu = Menu,
        Corner = Corner,

        List = nil,
        Signal = nil,

        Size = Size,
        AutoSizeY = List == 1,

        OpenCloseTween = nil,
        Animated = function()
            if not AnimationType or AnimationType == "none" then
                return false
            end

            if not (Library.Animations and Library.Animations[AnimationType] == true) then
                return false
            end

            return true, Library[string.format("%sTransitionInfo", AnimationType)] or TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        end
    }

    if List == 1 then
        Table.List = New("UIListLayout", {
            Parent = Menu,
        })
    end

    function Table:Open()
        if CurrentMenu == Table then
            return
        end

        -- Keep menus that contain this holder open (nested menus, e.g. a dropdown inside a settings popup) --
        local ParentMenu = CurrentMenu
        while ParentMenu and not Holder:IsDescendantOf(ParentMenu.Menu) do
            ParentMenu:Close()
            if CurrentMenu == ParentMenu then
                break
            end
            ParentMenu = CurrentMenu
        end

        Table.ParentMenu = ParentMenu
        CurrentMenu = Table
        Table.Active = true
        Menu.ZIndex = 1

        local TargetParent = if ParentGui == Overlay then Overlay else ParentGui
        Menu.Parent = nil
        Menu.Parent = TargetParent

        if typeof(Offset) == "function" then
            Menu.Position = UDim2.fromOffset(
                math.floor(Holder.AbsolutePosition.X + Offset()[1]),
                math.floor(Holder.AbsolutePosition.Y + Offset()[2])
            )
        else
            Menu.Position = UDim2.fromOffset(
                math.floor(Holder.AbsolutePosition.X + Offset[1]),
                math.floor(Holder.AbsolutePosition.Y + Offset[2])
            )
        end

        local TargetSize = typeof(Table.Size) == "function" and Table.Size() or Table.Size

        if typeof(ActiveCallback) == "function" then
            Library:SafeCallback(ActiveCallback, true)
        end

        if Table.OpenCloseTween then
            StopTween(Table.OpenCloseTween, true)
            Table.OpenCloseTween = nil
        end

        local IsAnimated, TweenInfo = Table.Animated()
        if IsAnimated == true then
            local OpenSize = TargetSize
            if Table.AutoSizeY then
                local FullHeight = Menu.AbsoluteSize.Y

                Menu.AutomaticSize = Enum.AutomaticSize.None
                OpenSize = UDim2.new(TargetSize.X.Scale, TargetSize.X.Offset, 0, FullHeight)
            end

            Menu.Size = UDim2.new(OpenSize.X.Scale, OpenSize.X.Offset, 0, 0)
            Menu.Visible = true

            local Tween = TweenService:Create(Menu, TweenInfo, { Size = OpenSize })
            Table.OpenCloseTween = Tween

            local Connection; Connection = Library:GiveSignal(Tween.Completed:Once(function()
                if Connection then
                    Connection:Disconnect()
                end

                if Table.OpenCloseTween == Tween then
                    StopTween(Table.OpenCloseTween, true)
                    Table.OpenCloseTween = nil

                    if Table.AutoSizeY then
                        Menu.AutomaticSize = Enum.AutomaticSize.Y
                    end
                end
            end))

            Tween:Play()
        else
            Menu.Size = TargetSize
            Menu.Visible = true
        end

        Table.Signal = Holder:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
            if typeof(Offset) == "function" then
                Menu.Position = UDim2.fromOffset(
                    math.floor(Holder.AbsolutePosition.X + Offset()[1]),
                    math.floor(Holder.AbsolutePosition.Y + Offset()[2])
                )
            else
                Menu.Position = UDim2.fromOffset(
                    math.floor(Holder.AbsolutePosition.X + Offset[1]),
                    math.floor(Holder.AbsolutePosition.Y + Offset[2])
                )
            end

            local HolderAllowed = Library:IsInsideFrame(Library.WindowContainer, Holder)
                or (Table.ParentMenu ~= nil and Library:IsInsideFrame(Table.ParentMenu.Menu, Holder))
            if not HolderAllowed then
                for _, Surface in Library.DraggableElements do
                    if not (Surface and Library:IsInsideFrame(Surface, Holder)) then
                        continue
                    end

                    HolderAllowed = true
                    break
                end
            end

            if not HolderAllowed and Table.Active then
                Table:Close()
            end
        end)
    end

    function Table:Close()
        if not Table.Active then
            return
        end

        -- Close any menus nested inside this one first --
        while CurrentMenu and CurrentMenu ~= Table do
            local Child = CurrentMenu
            Child:Close()
            if CurrentMenu == Child then
                break
            end
        end

        if CurrentMenu ~= Table then
            return
        end

        if Table.Signal then
            Table.Signal:Disconnect()
            Table.Signal = nil
        end

        Table.Active = false
        CurrentMenu = Table.ParentMenu
        Table.ParentMenu = nil

        if typeof(ActiveCallback) == "function" then
            Library:SafeCallback(ActiveCallback, false)
        end

        if Table.OpenCloseTween then
            StopTween(Table.OpenCloseTween, true)
            Table.OpenCloseTween = nil
        end

        local IsAnimated, TweenInfo = Table.Animated()
        if IsAnimated == true then
            if Table.AutoSizeY then
                Menu.AutomaticSize = Enum.AutomaticSize.None
            end

            local CurrentSize = Menu.Size
            local CollapsedSize = UDim2.new(CurrentSize.X.Scale, CurrentSize.X.Offset, 0, 0)

            local Tween = TweenService:Create(Menu, TweenInfo, { Size = CollapsedSize })
            Table.OpenCloseTween = Tween

            local Connection; Connection = Library:GiveSignal(Tween.Completed:Once(function(PlaybackState)
                if Connection then
                    Connection:Disconnect()
                end

                if Table.OpenCloseTween == Tween then
                    StopTween(Table.OpenCloseTween, true)
                    Table.OpenCloseTween = nil

                    Menu.Visible = false
                    if Table.AutoSizeY then
                        Menu.AutomaticSize = Enum.AutomaticSize.Y
                    end
                end
            end))

            Tween:Play()
        else
            Menu.Visible = false
        end
    end

    function Table:Toggle()
        if Table.Active then
            Table:Close()
        else
            Table:Open()
        end
    end

    function Table:SetSize(Size)
        Table.Size = Size
        Menu.Size = typeof(Size) == "function" and Size() or Size
    end

    function Table:Destroy()
        Table.Destroyed = true

        if Table.Connections then
            for _, Connection in Table.Connections do
                Connection:Disconnect()
            end
        end

        if Table.Active then
            Table:Close()
        end

        if Table.OpenCloseTween then
            StopTween(Table.OpenCloseTween, true)
            Table.OpenCloseTween = nil
        end

        local MenuIndex = table.find(Library.ContextMenus, Table)
        if MenuIndex then
            table.remove(Library.ContextMenus, MenuIndex)
        end

        if Menu then
            Menu:Destroy()
        end
    end

    table.insert(Library.ContextMenus, Table)
    return Table
end

Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input: InputObject)
    if Library.Unloaded then
        return
    end

    if IsClickInput(Input, true) then
        local Location = Input.Position

        while
            CurrentMenu
            and not (
                Library:MouseIsOverFrame(CurrentMenu.Menu, Location)
                or Library:MouseIsOverFrame(CurrentMenu.Holder, Location)
            )
        do
            local Menu = CurrentMenu
            Menu:Close()
            if CurrentMenu == Menu then
                break
            end
        end
    end
end))

--// Tooltip \\--
local TooltipLabel = New("TextLabel", {
    BackgroundColor3 = "BackgroundColor",
    TextSize = 14,
    TextWrapped = true,
    Visible = false,
    ZIndex = 30,
    Parent = ScreenGui,
})
New("UIPadding", {
    PaddingBottom = UDim.new(0, 2),
    PaddingLeft = UDim.new(0, 4),
    PaddingRight = UDim.new(0, 4),
    PaddingTop = UDim.new(0, 2),
    Parent = TooltipLabel,
})
table.insert(
    Library.Scales,
    New("UIScale", {
        Parent = TooltipLabel,
    })
)
New("UIStroke", {
    Color = "OutlineColor",
    Parent = TooltipLabel,
})
table.insert(
    Library.Corners,
    New("UICorner", {
        CornerRadius = UDim.new(0, Library.CornerRadius / 2),
        Parent = TooltipLabel,
    })
)

local TooltipMeasureId = 0
local LastTooltipText = ""
local LastTooltipMaxWidth = 0

local function UpdateTooltipSize(Force: boolean?)
    if Library.Unloaded or not TooltipLabel.Visible then
        return
    end

    local MaxWidth = math.max(
        40,
        (workspace.CurrentCamera.ViewportSize.X - TooltipLabel.AbsolutePosition.X - 8) / Library.DPIScale
    )

    if
        not Force
        and TooltipLabel.Text == LastTooltipText
        and math.abs(MaxWidth - LastTooltipMaxWidth) < 1
        and TooltipLabel.Size.X.Offset > 0
    then
        return
    end

    TooltipMeasureId += 1
    local MeasureId = TooltipMeasureId
    local Text = TooltipLabel.Text

    local X, Y = Library:GetTextBounds(Text, TooltipLabel.FontFace, TooltipLabel.TextSize, MaxWidth)
    if MeasureId ~= TooltipMeasureId or TooltipLabel.Text ~= Text then
        return
    end

    LastTooltipText = Text
    LastTooltipMaxWidth = MaxWidth
    TooltipLabel.Size = UDim2.fromOffset(X + 8, Y + 4)
end

TooltipLabel:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
    UpdateTooltipSize(false)
end)

local CurrentHoverInstance
function Library:AddTooltip(InfoStr: string, DisabledInfoStr: string, HoverInstance: GuiObject)
    local TooltipTable = {
        Disabled = false,
        Hovering = false,
        Signals = {},
    }

    local function IsBlockedByMenu()
        return CurrentMenu ~= nil
            and Library:MouseIsOverFrame(CurrentMenu.Menu, Mouse)
            and not HoverInstance:IsDescendantOf(CurrentMenu.Menu)
    end

    local function DoHover()
        if
            CurrentHoverInstance == HoverInstance
            or Library.ActiveDialog
            or IsBlockedByMenu()
            or (TooltipTable.Disabled and typeof(DisabledInfoStr) ~= "string")
            or (not TooltipTable.Disabled and typeof(InfoStr) ~= "string")
        then
            return
        end
        CurrentHoverInstance = HoverInstance

        local HolderGui = HoverInstance:FindFirstAncestorOfClass("ScreenGui")
        if HolderGui and HolderGui ~= ScreenGui and Library.ActiveLoading and HolderGui == Library.ActiveLoading.ScreenGui then
            TooltipLabel.Parent = HolderGui
        else
            TooltipLabel.Parent = ScreenGui
        end

        TooltipLabel.Text = TooltipTable.Disabled and DisabledInfoStr or InfoStr
        TooltipLabel.Position = UDim2.fromOffset(
            Mouse.X + 14,
            Mouse.Y + 12
        )
        TooltipLabel.Visible = true
        UpdateTooltipSize(true)

        while
            (Library.Toggled or Library.ActiveLoading)
            and not Library.ActiveDialog
            and Library:MouseIsOverFrame(HoverInstance, Mouse)
            and not IsBlockedByMenu()
        do
            TooltipLabel.Position = UDim2.fromOffset(
                Mouse.X + 14,
                Mouse.Y + 12
            )

            RunService.RenderStepped:Wait()
        end

        TooltipLabel.Visible = false
        CurrentHoverInstance = nil
    end

    local function GiveSignal(Connection: RBXScriptConnection | RBXScriptSignal)
        local ConnectionType = typeof(Connection)
        if Connection and (ConnectionType == "RBXScriptConnection" or ConnectionType == "RBXScriptSignal") then
            table.insert(TooltipTable.Signals, Connection)
        end

        return Connection
    end

    GiveSignal(HoverInstance.MouseEnter:Connect(DoHover))
    GiveSignal(HoverInstance.MouseMoved:Connect(DoHover))
    GiveSignal(HoverInstance.MouseLeave:Connect(function()
        if CurrentHoverInstance ~= HoverInstance then
            return
        end

        TooltipLabel.Visible = false
        CurrentHoverInstance = nil
    end))

    function TooltipTable:Destroy()
        for Index = #TooltipTable.Signals, 1, -1 do
            local Connection = table.remove(TooltipTable.Signals, Index)
            if Connection and Connection.Connected then
                Connection:Disconnect()
            end
        end

        if CurrentHoverInstance == HoverInstance then
            if TooltipLabel then
                TooltipLabel.Visible = false
            end

            CurrentHoverInstance = nil
        end
    end

    table.insert(Tooltips, TooltipLabel)
    return TooltipTable
end

function Library:OnUnload(Callback)
    table.insert(Library.UnloadSignals, Callback)
end

local BaseGroupbox -- forward declared; settings popups act as groupboxes
local BaseAddons = {}
do
    local Funcs = {}

    function Funcs:AddKeyPicker(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.KeyPicker)

        local ParentObj = self
        local ToggleLabel = ParentObj.TextLabel

        if ParentObj.Type == "Button" or ParentObj.Type == "SubButton" then
            assert(Info.Mode == "Press", "KeyPicker on Buttons can only be applied with the 'Press' mode.")

            ToggleLabel = ParentObj.Base
        end

        local KeyPicker = {
            Connections = {},

            Text = Info.Text,
            Value = Info.Default, -- Key
            Modifiers = Info.DefaultModifiers, -- Modifiers
            DisplayValue = Info.Default, -- Picker Text

            Blacklisted = Info.Blacklisted,
            BlacklistedModifiers = Info.BlacklistedModifiers,
            Whitelisted = Info.Whitelisted,
            WhitelistedModifiers = Info.WhitelistedModifiers,

            Toggled = false,
            Mode = Info.Mode,
            SyncToggleState = Info.SyncToggleState,

            NoUI = Info.NoUI == true,
            MenuVisible = Info.NoUI ~= true,

            Callback = Info.Callback,
            ChangedCallback = Info.ChangedCallback,
            Changed = Info.Changed,
            Clicked = Info.Clicked,

            Type = "KeyPicker",
            Idx = Idx,
        }

        if KeyPicker.Mode == "Press" then
            assert(ParentObj.Type == "Label" or ParentObj.Type == "Button" or ParentObj.Type == "SubButton", "KeyPicker with the mode 'Press' can be only applied on Labels and Buttons.")

            KeyPicker.SyncToggleState = false
            Info.Modes = { "Press" }
            Info.Mode = "Press"
        end

        if KeyPicker.SyncToggleState then
            Info.Modes = { "Toggle", "Hold" }

            if not table.find(Info.Modes, Info.Mode) then
                Info.Mode = "Toggle"
            end
        end

        local Picking = false
        local IsForButton = ParentObj.Type == "Button" or ParentObj.Type == "SubButton"

        -- Special Keys
        local SpecialKeys = {
            ["MB1"] = Enum.UserInputType.MouseButton1,
            ["MB2"] = Enum.UserInputType.MouseButton2,
            ["MB3"] = Enum.UserInputType.MouseButton3,
        }

        local SpecialKeysInput = {
            [Enum.UserInputType.MouseButton1] = "MB1",
            [Enum.UserInputType.MouseButton2] = "MB2",
            [Enum.UserInputType.MouseButton3] = "MB3",
        }

        -- Modifiers
        local Modifiers = {
            ["LAlt"] = Enum.KeyCode.LeftAlt,
            ["RAlt"] = Enum.KeyCode.RightAlt,

            ["LCtrl"] = Enum.KeyCode.LeftControl,
            ["RCtrl"] = Enum.KeyCode.RightControl,

            ["LShift"] = Enum.KeyCode.LeftShift,
            ["RShift"] = Enum.KeyCode.RightShift,

            ["Tab"] = Enum.KeyCode.Tab,
            ["CapsLock"] = Enum.KeyCode.CapsLock,
        }

        local ModifiersInput = {
            [Enum.KeyCode.LeftAlt] = "LAlt",
            [Enum.KeyCode.RightAlt] = "RAlt",

            [Enum.KeyCode.LeftControl] = "LCtrl",
            [Enum.KeyCode.RightControl] = "RCtrl",

            [Enum.KeyCode.LeftShift] = "LShift",
            [Enum.KeyCode.RightShift] = "RShift",

            [Enum.KeyCode.Tab] = "Tab",
            [Enum.KeyCode.CapsLock] = "CapsLock",
        }

        local IsModifierInput = function(Input)
            return Input.UserInputType == Enum.UserInputType.Keyboard and ModifiersInput[Input.KeyCode] ~= nil
        end

        local GetActiveModifiers = function()
            local ActiveModifiers = {}

            for Name, Input in Modifiers do
                if table.find(ActiveModifiers, Name) then
                    continue
                end
                if not UserInputService:IsKeyDown(Input) then
                    continue
                end

                table.insert(ActiveModifiers, Name)
            end

            return ActiveModifiers
        end

        local AreModifiersHeld = function(Required)
            if not (typeof(Required) == "table" and GetTableSize(Required) > 0) then
                return true
            end

            local ActiveModifiers = GetActiveModifiers()
            local Holding = true

            for _, Name in Required do
                if table.find(ActiveModifiers, Name) then
                    continue
                end

                Holding = false
                break
            end

            return Holding
        end

        local IsInputDown = function(Input)
            if not Input then
                return false
            end

            if SpecialKeysInput[Input.UserInputType] ~= nil then
                return UserInputService:IsMouseButtonPressed(Input.UserInputType)
                    and not UserInputService:GetFocusedTextBox()
            elseif Input.UserInputType == Enum.UserInputType.Keyboard then
                return UserInputService:IsKeyDown(Input.KeyCode) and not UserInputService:GetFocusedTextBox()
            else
                return false
            end
        end

        local ConvertToInputModifiers = function(CurrentModifiers)
            local InputModifiers = {}

            for _, name in CurrentModifiers do
                table.insert(InputModifiers, Modifiers[name])
            end

            return InputModifiers
        end

        local VerifyModifiers = function(CurrentModifiers)
            if typeof(CurrentModifiers) ~= "table" then
                return {}
            end

            local ValidModifiers = {}

            for _, name in CurrentModifiers do
                if not Modifiers[name] then
                    continue
                end

                table.insert(ValidModifiers, name)
            end

            return ValidModifiers
        end

        KeyPicker.Modifiers = VerifyModifiers(KeyPicker.Modifiers)

        local SlideOverflow = true
        local LastDisplayText = nil
        local MaxPickerWidth = 85
        local SlidingLabel

        local SlideForwardTween
        local SlideBackTween
        local HandleForwardTween = function(State)
            if State ~= Enum.PlaybackState.Completed then
                return
            end

            task.wait(1.5)
            if SlideBackTween then
                SlideBackTween:Play()
            end
        end

        local HandleBackTween = function(State)
            if State ~= Enum.PlaybackState.Completed then
                return
            end

            task.wait(1.5)
            if SlideForwardTween then
                SlideForwardTween:Play()
            end
        end

        local SlideForwardConn, SlideBackConn
        local CancelSlidingTweens = function()
            if SlideForwardConn then
                SlideForwardConn:Disconnect()
                SlideForwardConn = nil
            end

            if SlideBackConn then
                SlideBackConn:Disconnect()
                SlideBackConn = nil
            end

            if SlideForwardTween then
                StopTween(SlideForwardTween, true)
                SlideForwardTween = nil
            end

            if SlideBackTween then
                StopTween(SlideBackTween, true)
                SlideBackTween = nil
            end

            RunService.RenderStepped:Wait()
        end

        local Picker = New("TextButton", {
            BackgroundColor3 = "MainColor",
            Size = UDim2.fromOffset(18, 18),
            Text = (IsForButton and SlideOverflow) and "" or KeyPicker.Value,
            TextSize = 14,
            TextTransparency = 0.4,
            Parent = ToggleLabel,
        })

        if IsForButton and SlideOverflow then
            Picker.ClipsDescendants = true

            SlidingLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                Text = KeyPicker.Value,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Center,
                Parent = Picker,
            })
        end

        New("UIStroke", {
            Color = "OutlineColor",
            Parent = Picker,
        })

        local PickerCorner = New("UICorner", {
            TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            Parent = Picker,
        }); table.insert(Library.SpecificCorners, PickerCorner)

        local PickerHoverTween = nil

        local function ApplyPickerTextTransparency(Transparency: number)
            StopTween(PickerHoverTween)
            PickerHoverTween = nil

            Picker.TextTransparency = Transparency
            if SlidingLabel then
                SlidingLabel.TextTransparency = Transparency
            end
        end

        local function TweenPickerTextTransparency(Transparency: number)
            StopTween(PickerHoverTween)

            PickerHoverTween = TweenService:Create(Picker, Library.TweenInfo, {
                TextTransparency = Transparency,
            })
            PickerHoverTween:Play()

            if SlidingLabel then
                TweenService:Create(SlidingLabel, Library.TweenInfo, {
                    TextTransparency = Transparency,
                }):Play()
            end
        end

        table.insert(KeyPicker.Connections, Picker.MouseEnter:Connect(function()
            if ParentObj.Disabled then
                return
            end

            TweenPickerTextTransparency(0)
        end))

        table.insert(KeyPicker.Connections, Picker.MouseLeave:Connect(function()
            if ParentObj.Disabled then
                return
            end

            TweenPickerTextTransparency(0.4)
        end))

        if IsForButton then
            local Holder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 21),
                Parent = ToggleLabel.Parent,
            })

            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0, 9),
                Parent = Holder,
            })

            New("UIFlexItem", {
                FlexMode = Enum.UIFlexMode.Fill,
                Parent = ToggleLabel,
            })

            ToggleLabel.Parent = Holder
            Picker.Parent = Holder

            Picker.Size = UDim2.new(0, 18, 1, 0)
        end

        local KeybindsToggle = { Normal = KeyPicker.Mode ~= "Toggle" }
        do
            local Holder = New("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 16),
                Text = "",
                Visible = not Info.NoUI,
                Parent = Library.KeybindContainer,
            })

            local Label = New("TextLabel", {
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(0, 1),
                Text = "",
                TextSize = 14,
                TextTransparency = 0.5,
                Parent = Holder,
            })

            local Checkbox = New("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = "MainColor",
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.fromOffset(14, 14),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Parent = Holder,
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Checkbox,
                })
            )
            New("UIStroke", {
                Color = "OutlineColor",
                Parent = Checkbox,
            })

            local CheckImage = New("ImageLabel", {
                ImageColor3 = "FontColor",
                ImageTransparency = 1,
                Position = UDim2.fromOffset(2, 2),
                Size = UDim2.new(1, -4, 1, -4),
                Parent = Checkbox,
            })
            if CheckIcon then
                Library:ApplyLucideIcon(CheckImage, CheckIcon)
            end

            function KeybindsToggle:Display(State)
                Label.TextTransparency = State and 0 or 0.5
                CheckImage.ImageTransparency = State and 0 or 1
            end

            function KeybindsToggle:SetText(Text)
                Label.Text = Text
            end

            function KeybindsToggle:SetVisibility(Visibility)
                Holder.Visible = Visibility
            end

            function KeybindsToggle:SetNormal(Normal)
                KeybindsToggle.Normal = Normal

                Holder.Active = not Normal
                Label.Position = Normal and UDim2.fromOffset(0, 0) or UDim2.fromOffset(22, 0)
                Checkbox.Visible = not Normal
            end

            KeyPicker.DoClick = function(...) end --// make luau lsp shut up
            table.insert(KeyPicker.Connections, Holder.MouseButton1Click:Connect(function()
                if KeybindsToggle.Normal then
                    return
                end

                KeyPicker.Toggled = not KeyPicker.Toggled
                KeyPicker:DoClick()
                KeyPicker:Update()
            end))

            KeybindsToggle.Holder = Holder
            KeybindsToggle.Label = Label
            KeybindsToggle.Checkbox = Checkbox
            KeybindsToggle.Loaded = true
            table.insert(Library.KeybindToggles, KeybindsToggle)
        end

        local ModeButtons = {}
        local ModeCorners = {}
        local TotalModeButtons = GetTableSize(Info.Modes)
        local MenuCornersOnly = if TotalModeButtons == 1 then "no_left" else "no_top_left"

        local MenuTable
        MenuTable = Library:AddContextMenu(Picker, UDim2.fromOffset(62, 0), function()
            return { Picker.AbsoluteSize.X + 1.5, 0.5 }
        end, 1, function(Active: boolean)
            local Half = UDim.new(0, Library.CornerRadius / 2)
            local Zero = UDim.new(0, 0)

            PickerCorner.TopLeftRadius = Half
            PickerCorner.BottomLeftRadius = Half
            PickerCorner.TopRightRadius = Active and Zero or Half
            PickerCorner.BottomRightRadius = Active and Zero or Half

            local MenuCorner = MenuTable and MenuTable.Corner
            if MenuCorner then
                if MenuCornersOnly == "no_left" then
                    MenuCorner.TopLeftRadius = Zero
                    MenuCorner.BottomLeftRadius = Zero
                    MenuCorner.TopRightRadius = Half
                    MenuCorner.BottomRightRadius = Half
                else
                    MenuCorner.TopLeftRadius = Zero
                    MenuCorner.TopRightRadius = Half
                    MenuCorner.BottomRightRadius = Half
                    MenuCorner.BottomLeftRadius = Half
                end
            end

            for _, Entry in ModeCorners do
                local Corner = Entry.Corner
                if Entry.Style == "single" then
                    Corner.TopLeftRadius = Zero
                    Corner.BottomLeftRadius = Zero
                    Corner.TopRightRadius = Half
                    Corner.BottomRightRadius = Half
                elseif Entry.Style == "first" then
                    Corner.TopLeftRadius = Zero
                    Corner.TopRightRadius = Half
                    Corner.BottomLeftRadius = Zero
                    Corner.BottomRightRadius = Zero
                elseif Entry.Style == "last" then
                    Corner.TopLeftRadius = Zero
                    Corner.TopRightRadius = Zero
                    Corner.BottomLeftRadius = Half
                    Corner.BottomRightRadius = Half
                end
            end
        end, false, MenuCornersOnly, "KeyPicker")
        KeyPicker.Menu = MenuTable

        for Index, Mode in Info.Modes do
            local ModeButton = {}

            local Button = New("TextButton", {
                BackgroundColor3 = "MainColor",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, IsForButton and 21 or (TotalModeButtons == 1 and 18 or 19)),
                Text = Mode,
                TextSize = 14,
                TextTransparency = 0.5,
                Parent = MenuTable.Menu,
            })

            if Index == 1 and TotalModeButtons == 1 then
                local Corner = New("UICorner", {
                    TopLeftRadius = UDim.new(0, 0),
                    TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
                    BottomLeftRadius = UDim.new(0, 0),
                    BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Button,
                })
                table.insert(Library.SpecificCorners, Corner)
                table.insert(ModeCorners, { Corner = Corner, Style = "single" })
            elseif Index == 1 then
                local Corner = New("UICorner", {
                    TopLeftRadius = UDim.new(0, 0),
                    TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
                    BottomLeftRadius = UDim.new(0, 0),
                    BottomRightRadius = UDim.new(0, 0),
                    Parent = Button,
                })
                table.insert(Library.SpecificCorners, Corner)
                table.insert(ModeCorners, { Corner = Corner, Style = "first" })
            elseif Index == TotalModeButtons then
                local Corner = New("UICorner", {
                    TopLeftRadius = UDim.new(0, 0),
                    TopRightRadius = UDim.new(0, 0),
                    BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
                    BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Button,
                })
                table.insert(Library.SpecificCorners, Corner)
                table.insert(ModeCorners, { Corner = Corner, Style = "last" })
            end

            function ModeButton:Select()
                for _, Button in ModeButtons do
                    Button:Deselect()
                end

                KeyPicker.Mode = Mode

                Button.BackgroundTransparency = 0
                Button.TextTransparency = 0

                MenuTable:Close()
                if KeyPicker.Update then
                    KeyPicker:Update()
                end
            end

            function ModeButton:Deselect()
                KeyPicker.Mode = nil

                Button.BackgroundTransparency = 1
                Button.TextTransparency = 0.5
            end

            table.insert(KeyPicker.Connections, Button.MouseButton1Click:Connect(function()
                ModeButton:Select()
            end))

            table.insert(KeyPicker.Connections, Button.MouseEnter:Connect(function()
                if KeyPicker.Mode == Mode then
                    return
                end

                TweenService:Create(Button, Library.TweenInfo, {
                    BackgroundTransparency = 0.7,
                    TextTransparency = 0.1,
                }):Play()
            end))

            table.insert(KeyPicker.Connections, Button.MouseLeave:Connect(function()
                if KeyPicker.Mode == Mode then
                    return
                end

                TweenService:Create(Button, Library.TweenInfo, {
                    BackgroundTransparency = 1,
                    TextTransparency = 0.5,
                }):Play()
            end))

            if KeyPicker.Mode == Mode then
                ModeButton:Select()
            end

            ModeButtons[Mode] = ModeButton
        end

        local SetPickingState = function(State, SkipUpdate: boolean?)
            Picking = State
            Library.IsPicking = State

            if ParentObj then
                ParentObj.AnyKeyPickerPicking = Picking
            end

            if IsForButton then
                ToggleLabel.Visible = not Picking
                LastDisplayText = nil
                RunService.RenderStepped:Wait()
            end

            if SkipUpdate ~= true then
                (KeyPicker :: any):Update()
            end
        end

        function KeyPicker:Display(PickerText)
            if Library.Unloaded then
                return
            end

            local DisplayText = PickerText or KeyPicker.DisplayValue
            if IsForButton and SlideOverflow then
                local X, _Y = Library:GetTextBounds(
                    DisplayText,
                    Picker.FontFace,
                    Picker.TextSize,
                    10000
                )

                local OffsetScale = X + 9
                local TextChanged = LastDisplayText ~= DisplayText
                local LabelWidth

                SlidingLabel.Text = DisplayText
                LastDisplayText = DisplayText

                if Picking then
                    Picker.Size = UDim2.new(1, 0, 1, 0)
                    RunService.RenderStepped:Wait()
                    LabelWidth = Picker.AbsoluteSize.X

                    if LabelWidth <= 0 then
                        LabelWidth = MaxPickerWidth
                    end
                else
                    LabelWidth = math.min(OffsetScale, MaxPickerWidth)
                    Picker.Size = UDim2.new(0, LabelWidth, 1, 0)
                end

                if OffsetScale > LabelWidth then
                    SlidingLabel.TextXAlignment = Enum.TextXAlignment.Left
                    SlidingLabel.Size = UDim2.new(0, OffsetScale, 1, 0)

                    local OverflowDistance = OffsetScale - LabelWidth - 4.5
                    if OverflowDistance > 0 then
                        if TextChanged or not SlideForwardTween then
                            SlidingLabel.Position = UDim2.fromOffset(4.5, 0)
                            CancelSlidingTweens()

                            local Duration = math.max(OverflowDistance / 25, 0.35)
                            local TweenInfo = TweenInfo.new(
                                Duration,
                                Enum.EasingStyle.Linear,
                                Enum.EasingDirection.InOut
                            )

                            SlideForwardTween = TweenService:Create(SlidingLabel, TweenInfo, {
                                Position = UDim2.fromOffset(-OverflowDistance, 0),
                            })

                            SlideBackTween = TweenService:Create(SlidingLabel, TweenInfo, {
                                Position = UDim2.fromOffset(4.5, 0),
                            })

                            SlideForwardTween:Play()

                            if SlideForwardConn then
                                SlideForwardConn:Disconnect()
                            end

                            if SlideBackConn then
                                SlideBackConn:Disconnect()
                            end

                            SlideForwardConn = SlideForwardTween.Completed:Connect(HandleForwardTween)
                            SlideBackConn = SlideBackTween.Completed:Connect(HandleBackTween)
                        end
                    else
                        CancelSlidingTweens()

                        SlidingLabel.TextXAlignment = Enum.TextXAlignment.Center
                        SlidingLabel.Size = UDim2.new(1, 0, 1, 0)
                        SlidingLabel.Position = UDim2.new(0, 0, 0, 0)
                    end
                else
                    CancelSlidingTweens()

                    SlidingLabel.TextXAlignment = Enum.TextXAlignment.Center
                    SlidingLabel.Size = UDim2.new(1, 0, 1, 0)
                    SlidingLabel.Position = UDim2.new(0, 0, 0, 0)
                end
            else
                local X, Y = Library:GetTextBounds(
                    DisplayText,
                    Picker.FontFace,
                    Picker.TextSize,
                    ToggleLabel.AbsoluteSize.X / Library.DPIScale
                )
                Picker.Text = DisplayText
                Picker.Size = IsForButton and UDim2.new(0, X + 9, 1, 0) or UDim2.fromOffset((X + 9), (Y + 4))
            end
        end

        function KeyPicker:Update()
            local Disabled = ParentObj.Disabled == true

            if Disabled and Picking then
                SetPickingState(false, true)
            end

            KeyPicker:Display()

            Picker.Active = not Disabled
            ApplyPickerTextTransparency(Disabled and 0.8 or 0.4)

            if Disabled then
                if MenuTable.Active then
                    MenuTable:Close()
                end
            end

            if KeyPicker.Mode == "Toggle" and ParentObj.Type == "Toggle" and ParentObj.Disabled then
                KeybindsToggle:SetVisibility(false)
                return
            end

            local State = KeyPicker:GetState()
            local ShowToggle = Library.ShowToggleFrameInKeybinds and KeyPicker.Mode == "Toggle"

            if KeyPicker.SyncToggleState and ParentObj.Value ~= State then
                ParentObj:SetValue(State)
            end

            if Info.NoUI then
                return
            end

            if KeybindsToggle.Loaded then
                if ShowToggle then
                    KeybindsToggle:SetNormal(false)
                else
                    KeybindsToggle:SetNormal(true)
                end

                KeybindsToggle:SetText(("[%s] %s (%s)"):format(KeyPicker.DisplayValue, KeyPicker.Text, KeyPicker.Mode))
                KeybindsToggle:SetVisibility(KeyPicker.MenuVisible ~= false)
                KeybindsToggle:Display(State)
            end
        end

        function KeyPicker:GetState()
            if KeyPicker.Mode == "Always" then
                return true
            elseif KeyPicker.Mode == "Hold" then
                local Key = KeyPicker.Value
                if Key == "None" then
                    return false
                end

                if not AreModifiersHeld(KeyPicker.Modifiers) then
                    return false
                end

                if Picking then
                    return false
                end

                if SpecialKeys[Key] ~= nil then
                    if Library.Toggled then
                        return false
                    end

                    return UserInputService:IsMouseButtonPressed(SpecialKeys[Key])
                        and not UserInputService:GetFocusedTextBox()
                else
                    return UserInputService:IsKeyDown(Enum.KeyCode[Key] :: any) and not UserInputService:GetFocusedTextBox()
                end
            else
                return KeyPicker.Toggled
            end
        end

        function KeyPicker:OnChanged(Func)
            KeyPicker.Changed = Func
        end

        function KeyPicker:OnClick(Func)
            KeyPicker.Clicked = Func
        end

        function KeyPicker:DoClick()
            if Picking or ParentObj.Disabled then
                return
            end

            if KeyPicker.Mode == "Press" then
                if KeyPicker.Toggled and Info.WaitForCallback == true then
                    return
                end

                KeyPicker.Toggled = true
            end

            Library:SafeCallback(KeyPicker.Callback, KeyPicker.Toggled)
            Library:SafeCallback(KeyPicker.Clicked, KeyPicker.Toggled)

            if IsForButton then
                Library:SafeCallback(ParentObj.Func, KeyPicker.Toggled)
            end

            if Library.ToggleKeybind == KeyPicker and Library.Toggle then
                Library:Toggle()
            end

            if KeyPicker.Mode == "Press" then
                KeyPicker.Toggled = false
            end
        end

        function KeyPicker:RunChanged(IsKeyValid, KeyCode)
            if ParentObj.Disabled then
                return
            end

            if IsKeyValid == nil or KeyCode == nil then
                IsKeyValid, KeyCode = pcall(function()
                    if KeyPicker.Value == "None" then
                        return nil
                    end

                    if SpecialKeys[KeyPicker.Value] == nil then
                        return Enum.KeyCode[KeyPicker.Value]
                    end

                    return SpecialKeys[KeyPicker.Value]
                end)
            end

            local NewModifiers = ConvertToInputModifiers(KeyPicker.Modifiers)
            Library:SafeCallback(KeyPicker.ChangedCallback, KeyCode, NewModifiers)
            Library:SafeCallback(KeyPicker.Changed, KeyCode, NewModifiers)
        end

        function KeyPicker:SetValue(Data)
            local Key, Mode, Modifiers = Data[1], Data[2], Data[3]

            local IsKeyValid, KeyCode = pcall(function()
                if Key == "None" then
                    Key = nil
                    return nil
                end

                if SpecialKeys[Key] == nil then
                    return Enum.KeyCode[Key]
                end

                return SpecialKeys[Key]
            end)

            if Key == nil then
                KeyPicker.Value = "None"
            elseif IsKeyValid then
                KeyPicker.Value = Key
            else
                KeyPicker.Value = "Unknown"
            end

            KeyPicker.Modifiers =
                VerifyModifiers(if typeof(Modifiers) == "table" then Modifiers else KeyPicker.Modifiers)
            KeyPicker.DisplayValue = if GetTableSize(KeyPicker.Modifiers) > 0
                then (table.concat(KeyPicker.Modifiers, " + ") .. " + " .. KeyPicker.Value)
                else KeyPicker.Value

            if ModeButtons[Mode] then
                ModeButtons[Mode]:Select()
            end

            KeyPicker:Update()
            KeyPicker:RunChanged(IsKeyValid, KeyCode)
        end

        function KeyPicker:SetText(Text)
            KeyPicker.Text = Text
            KeybindsToggle:SetText(Text)
            KeyPicker:Update()

            local KeybindMenu = Library.KeybindMenu
            if KeybindMenu and KeybindMenu.SettingsOpen then
                KeybindMenu:RefreshSettings()
            end
        end

        function KeyPicker:SetMenuVisibility(Visible: boolean)
            assert(typeof(Visible) == "boolean", "Visible must be a boolean")

            KeyPicker.MenuVisible = Visible
            KeyPicker:Update()

            local KeybindMenu = Library.KeybindMenu
            if KeybindMenu and KeybindMenu.SettingsOpen then
                KeybindMenu:RefreshSettings()
            end
        end

        table.insert(KeyPicker.Connections, Picker.MouseButton1Click:Connect(function()
            if Picking or Library.IsPicking or ParentObj.Disabled then
                return
            end

            SetPickingState(true)

            if IsForButton and SlideOverflow then
                KeyPicker:Display("...")
            else
                Picker.Text = "..."
                Picker.Size = IsForButton and UDim2.new(0, 29, 1, 0) or UDim2.fromOffset(29, 18)
            end

            -- Wait for any input --
            local ActiveModifiers = {}
            local CurrentInput = nil

            local IsValidInput = function(InputObj)
                if InputObj.KeyCode == Enum.KeyCode.Escape then
                    return true
                end

                local IsMod = IsModifierInput(InputObj)
                local KeyName
                if SpecialKeysInput[InputObj.UserInputType] ~= nil then
                    KeyName = SpecialKeysInput[InputObj.UserInputType]
                elseif InputObj.UserInputType == Enum.UserInputType.Keyboard then
                    if IsMod then
                        KeyName = ModifiersInput[InputObj.KeyCode]
                    else
                        KeyName = InputObj.KeyCode.Name
                    end
                end

                if KeyName then
                    if IsMod then
                        if KeyPicker.WhitelistedModifiers and #KeyPicker.WhitelistedModifiers > 0 and not table.find(KeyPicker.WhitelistedModifiers, KeyName) then
                            return false
                        end

                        if KeyPicker.BlacklistedModifiers and table.find(KeyPicker.BlacklistedModifiers, KeyName) then
                            return false
                        end
                    else
                        if KeyPicker.Whitelisted and #KeyPicker.Whitelisted > 0 and not table.find(KeyPicker.Whitelisted, KeyName) then
                            return false
                        end

                        if KeyPicker.Blacklisted and table.find(KeyPicker.Blacklisted, KeyName) then
                            return false
                        end
                    end
                end

                return true
            end

            -- Wait for the first valid InputBegan --
            while true do
                local InputObj = UserInputService.InputBegan:Wait()
                if UserInputService:GetFocusedTextBox() ~= nil then
                    SetPickingState(false)
                    return
                end

                if IsValidInput(InputObj) then
                    CurrentInput = InputObj
                    break
                end
            end

            -- If it's a modifier key, we wait for either its release or another input --
            while IsModifierInput(CurrentInput) do
                if CurrentInput.KeyCode == Enum.KeyCode.Escape then
                    break
                end

                -- Display the current state including the current modifier key --
                local ModName = ModifiersInput[CurrentInput.KeyCode]
                if ModName then
                    local text = if #ActiveModifiers > 0 then table.concat(ActiveModifiers, " + ") .. " + " .. ModName .. " + ..." else ModName .. " + ..."
                    KeyPicker:Display(text)
                end

                local NextInput = nil
                local Released = false

                local BeganConn
                local EndedConn

                BeganConn = UserInputService.InputBegan:Connect(function(InputObj)
                    if UserInputService:GetFocusedTextBox() ~= nil then
                        return
                    end
                    if IsValidInput(InputObj) then
                        NextInput = InputObj
                    end
                end)

                EndedConn = UserInputService.InputEnded:Connect(function(InputObj)
                    if InputObj.KeyCode == CurrentInput.KeyCode then
                        Released = true
                    end
                end)

                repeat
                    task.wait()
                until Released or NextInput or UserInputService:GetFocusedTextBox() ~= nil or Library.Unloaded

                if BeganConn then BeganConn:Disconnect() end
                if EndedConn then EndedConn:Disconnect() end

                if UserInputService:GetFocusedTextBox() ~= nil or Library.Unloaded then
                    SetPickingState(false)
                    return
                end

                if Released then
                    break -- Use modifier key as bind
                elseif NextInput then
                    -- Add another modifier or continue to normal key
                    local OldModName = ModifiersInput[CurrentInput.KeyCode]
                    if OldModName and not table.find(ActiveModifiers, OldModName) then
                        ActiveModifiers[#ActiveModifiers + 1] = OldModName
                    end

                    CurrentInput = NextInput
                    if CurrentInput.KeyCode == Enum.KeyCode.Escape then
                        break
                    end
                end
            end

            local Key = "Unknown"
            if SpecialKeysInput[CurrentInput.UserInputType] ~= nil then
                Key = SpecialKeysInput[CurrentInput.UserInputType]
            elseif CurrentInput.UserInputType == Enum.UserInputType.Keyboard then
                Key = CurrentInput.KeyCode == Enum.KeyCode.Escape and "None" or CurrentInput.KeyCode.Name
            end

            ActiveModifiers = if CurrentInput.KeyCode == Enum.KeyCode.Escape or Key == "Unknown" then {} else ActiveModifiers

            KeyPicker.Toggled = if ParentObj.Type == "Toggle" then ParentObj.Value else false
            KeyPicker:SetValue({ Key, KeyPicker.Mode, ActiveModifiers })

            repeat
                task.wait()
            until not IsInputDown(CurrentInput) or UserInputService:GetFocusedTextBox()

            SetPickingState(false)
        end))

        table.insert(KeyPicker.Connections, Picker.MouseButton2Click:Connect(function()
            if ParentObj.Disabled then
                return
            end

            MenuTable:Toggle()
        end))

        table.insert(KeyPicker.Connections, UserInputService.InputBegan:Connect(function(Input: InputObject)
            if Library.Unloaded then
                return
            end

            local IsMouse = IsMouseClickInput(Input)
            if
                ParentObj.Disabled
                or KeyPicker.Mode == "Always"
                or KeyPicker.Value == "Unknown"
                or KeyPicker.Value == "None"
                or Picking
                or Library.IsPicking
                or UserInputService:GetFocusedTextBox()
                or (IsMouse and Library.Toggled)
            then
                return
            end

            local Key = KeyPicker.Value
            local HoldingModifiers = AreModifiersHeld(KeyPicker.Modifiers)
            local HoldingKey = false

            if
                Key
                and HoldingModifiers == true
                and (
                    SpecialKeysInput[Input.UserInputType] == Key
                    or (Input.UserInputType == Enum.UserInputType.Keyboard and Input.KeyCode.Name == Key)
                )
            then
                HoldingKey = true
            end

            if HoldingKey then
                if KeyPicker.Mode == "Toggle" then
                    KeyPicker.Toggled = not KeyPicker.Toggled
                    KeyPicker:DoClick()
                elseif KeyPicker.Mode == "Press" then
                    KeyPicker:DoClick()
                elseif KeyPicker.Mode == "Hold" then
                    InputChanged = Input.Changed:Connect(function()
                        if KeyPicker:GetState() then
                            return
                        end

                        KeyPicker:Update()
                        if InputChanged and InputChanged.Connected then
                            InputChanged:Disconnect()
                            InputChanged = nil
                        end
                    end)
                end

                KeyPicker:Update()
            end
        end))

        KeyPicker:Update()

        if not ParentObj.Addons then
            ParentObj.Addons = {}
        end

        table.insert(ParentObj.Addons, KeyPicker)

        KeyPicker.Default = KeyPicker.Value
        KeyPicker.DefaultModifiers = table.clone(KeyPicker.Modifiers or {})

        function KeyPicker:Destroy()
            KeyPicker.Destroyed = true

            if SlideForwardConn then
                SlideForwardConn:Disconnect()
                SlideForwardConn = nil
            end

            if SlideBackConn then
                SlideBackConn:Disconnect()
                SlideBackConn = nil
            end

            if KeyPicker.Connections then
                for _, Connection in KeyPicker.Connections do
                    Connection:Disconnect()
                end
            end

            if KeybindsToggle and KeybindsToggle.Loaded then
                if KeybindsToggle.Holder then
                    KeybindsToggle.Holder:Destroy()
                end
                local KTIdx = table.find(Library.KeybindToggles, KeybindsToggle)
                if KTIdx then
                    table.remove(Library.KeybindToggles, KTIdx)
                end
            end

            if MenuTable then
                MenuTable:Destroy()
            end

            if IsForButton and SlideOverflow then
                if SlideForwardTween then
                    SlideForwardTween:Destroy()
                end

                if SlideBackTween then
                    SlideBackTween:Destroy()
                end
            end

            if Picker then
                Picker:Destroy()
            end

            if ParentObj and ParentObj.Addons then
                local AddonIdx = table.find(ParentObj.Addons, KeyPicker)

                if AddonIdx then
                    table.remove(ParentObj.Addons, AddonIdx)
                end
            end

            Options[Idx] = nil

            local KeybindMenu = Library.KeybindMenu
            if KeybindMenu and KeybindMenu.SettingsOpen then
                KeybindMenu:RefreshSettings()
            end
        end

        Options[Idx] = KeyPicker

        local KeybindMenu = Library.KeybindMenu
        if KeybindMenu and KeybindMenu.SettingsOpen then
            KeybindMenu:RefreshSettings()
        end

        return self
    end

    local HueSequenceTable = {}
    for Hue = 0, 1, 0.1 do
        table.insert(HueSequenceTable, ColorSequenceKeypoint.new(Hue, Color3.fromHSV(Hue, 1, 1)))
    end
    function Funcs:AddColorPicker(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.ColorPicker)

        local ParentObj = self
        local ToggleLabel = ParentObj.TextLabel

        local ColorPicker = {
            Connections = {},
            Destroyed = false,

            Value = Info.Default,

            Transparency = Info.Transparency or 0,
            Title = Info.Title,

            Callback = Info.Callback,
            Changed = Info.Changed,

            Type = "ColorPicker",
        }
        ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = ColorPicker.Value:ToHSV()

        local Holder = New("TextButton", {
            BackgroundColor3 = ColorPicker.Value,
            Size = UDim2.fromOffset(18, 18),
            Text = "",
            Parent = ToggleLabel,
        })

        local HolderStroke = New("UIStroke", {
            Color = Library:GetDarkerColor(ColorPicker.Value),
            Parent = Holder,
        })

        local ColorPickerCorner = New("UICorner", {
            TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            Parent = Holder,
        }); table.insert(Library.SpecificCorners, ColorPickerCorner)

        local HolderTransparency = New("ImageLabel", {
            Image = CustomImageManager.GetAsset("TransparencyTexture"),
            ImageTransparency = (1 - ColorPicker.Transparency),
            ScaleType = Enum.ScaleType.Tile,
            Position = UDim2.new(0, -1, 0, -1),
            Size = UDim2.new(1, 2, 1, 2),
            TileSize = UDim2.fromOffset(9, 9),
            Parent = Holder,
        })

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = HolderTransparency,
            })
        )

        --// Color Menu \\--
        local MapSize = Library.IsMobile and 140 or 200
        local BarWidth = 16
        local MenuWidth = MapSize + BarWidth + 6 + 12
        if Info.Transparency then
            MenuWidth += BarWidth + 6
        end

        local ColorMenu
        local FooterCorner
        ColorMenu = Library:AddContextMenu(
            Holder,
            UDim2.fromOffset(MenuWidth, 0),
            function()
                return { 0.5, Holder.AbsoluteSize.Y + 1.5 }
            end,
            1, function(Active: boolean)
                local Half = UDim.new(0, Library.CornerRadius / 2)
                local Zero = UDim.new(0, 0)

                ColorPickerCorner.TopLeftRadius = Half
                ColorPickerCorner.TopRightRadius = Half
                ColorPickerCorner.BottomRightRadius = Active and Zero or Half
                ColorPickerCorner.BottomLeftRadius = Active and Zero or Half

                local MenuCorner = ColorMenu and ColorMenu.Corner
                if MenuCorner then
                    MenuCorner.TopLeftRadius = Zero
                    MenuCorner.TopRightRadius = Half
                    MenuCorner.BottomRightRadius = Half
                    MenuCorner.BottomLeftRadius = Half
                end

                if FooterCorner then
                    FooterCorner.TopLeftRadius = Zero
                    FooterCorner.TopRightRadius = Zero
                    FooterCorner.BottomLeftRadius = Half
                    FooterCorner.BottomRightRadius = Half
                end
            end, false, "no_top_left")
        ColorMenu.List.Padding = UDim.new(0, 0)
        ColorPicker.ColorMenu = ColorMenu

        --// Content Holder \\--
        local ContentHolder = New("Frame", {
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            Parent = ColorMenu.Menu,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, 8),
            Parent = ContentHolder,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 6),
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6),
            PaddingTop = UDim.new(0, 6),
            Parent = ContentHolder,
        })

        --// Footer \\--
        local FooterHeight = Library.IsMobile and 30 or 22

        local FooterBackground = New("Frame", {
            BackgroundColor3 = function()
                return Library:GetBetterColor(Library.Scheme.BackgroundColor, 4)
            end,
            Size = UDim2.new(1, 0, 0, FooterHeight),
            Parent = ColorMenu.Menu,
        })
        FooterCorner = New("UICorner", {
            TopLeftRadius = UDim.new(0, 0),
            TopRightRadius = UDim.new(0, 0),
            BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
            Parent = FooterBackground,
        })
        table.insert(Library.SpecificCorners, FooterCorner)
        Library:MakeLine(FooterBackground, {
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.new(1, 0, 0, 1),
        })

        local FooterBar = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Parent = FooterBackground,
        })
        New("UIPadding", {
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, Info.Resizable and (FooterHeight + 4) or 6),
            Parent = FooterBar,
        })

        local FooterInfoLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = "",
            TextSize = 14,
            TextTransparency = 0.5,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Center,
            Parent = FooterBar,
        })

        local function RefreshFooterInfo()
            FooterInfoLabel.Text = string.format(
                "#%s • %d, %d, %d",
                ColorPicker.Value:ToHex(),
                math.floor(ColorPicker.Value.R * 255),
                math.floor(ColorPicker.Value.G * 255),
                math.floor(ColorPicker.Value.B * 255)
            )
        end
        RefreshFooterInfo()

        if typeof(ColorPicker.Title) == "string" then
            New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 8),
                Text = ColorPicker.Title,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = ContentHolder,
            })
        end

        local ColorHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, MapSize),
            Parent = ContentHolder,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            Padding = UDim.new(0, 6),
            Parent = ColorHolder,
        })

        --// Sat Map
        local SatVipMap = New("ImageButton", {
            BackgroundColor3 = ColorPicker.Value,
            Image = CustomImageManager.GetAsset("SaturationMap"),
            Size = UDim2.fromOffset(MapSize, MapSize),
            Parent = ColorHolder,
        })

        local SatVibCursor = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = "WhiteColor",
            Size = UDim2.fromOffset(6, 6),
            Parent = SatVipMap,
        })
        New("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = SatVibCursor,
        })
        New("UIStroke", {
            Color = "DarkColor",
            Parent = SatVibCursor,
        })

        --// Hue
        local HueSelector = New("TextButton", {
            Size = UDim2.fromOffset(BarWidth, MapSize),
            Text = "",
            Parent = ColorHolder,
        })
        New("UIGradient", {
            Color = ColorSequence.new(HueSequenceTable),
            Rotation = 90,
            Parent = HueSelector,
        })

        local HueCursor = New("Frame", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = "WhiteColor",
            BorderColor3 = "DarkColor",
            BorderSizePixel = 1,
            Position = UDim2.fromScale(0.5, ColorPicker.Hue),
            Size = UDim2.new(1, 2, 0, 1),
            Parent = HueSelector,
        })

        --// Alpha
        local TransparencySelector, TransparencyColor, TransparencyCursor
        if Info.Transparency then
            TransparencySelector = New("ImageButton", {
                Image = CustomImageManager.GetAsset("TransparencyTexture"),
                ScaleType = Enum.ScaleType.Tile,
                Size = UDim2.fromOffset(BarWidth, MapSize),
                TileSize = UDim2.fromOffset(8, 8),
                Parent = ColorHolder,
            })

            TransparencyColor = New("Frame", {
                BackgroundColor3 = ColorPicker.Value,
                Size = UDim2.fromScale(1, 1),
                Parent = TransparencySelector,
            })
            New("UIGradient", {
                Rotation = 90,
                Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 0),
                    NumberSequenceKeypoint.new(1, 1),
                }),
                Parent = TransparencyColor,
            })

            TransparencyCursor = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                BackgroundColor3 = "WhiteColor",
                BorderColor3 = "DarkColor",
                BorderSizePixel = 1,
                Position = UDim2.fromScale(0.5, ColorPicker.Transparency),
                Size = UDim2.new(1, 2, 0, 1),
                Parent = TransparencySelector,
            })
        end

        --// Resizing \\--
        local ResizeGrabber
        if Info.Resizable then
            local BaseMapSize = 200
            local BaseBarWidth = BarWidth
            local BasePadding = 6
            local MinMapSize = 140

            ColorPicker.MapWidth = MapSize
            ColorPicker.MapHeight = MapSize

            local function GetBarWidth(MapWidth)
                return math.clamp(math.floor((MapWidth / BaseMapSize) * BaseBarWidth + 0.5), 12, 24)
            end

            local function GetContentWidth(MapWidth)
                local CurrentBarWidth = GetBarWidth(MapWidth)
                local Width = MapWidth + CurrentBarWidth + BasePadding
                if Info.Transparency then
                    Width += (CurrentBarWidth + BasePadding)
                end

                return Width + 12
            end

            local FixedVerticalOverhead = 6 + 6 + 8 + 20 + 8 + 20 + FooterHeight
            if typeof(ColorPicker.Title) == "string" then
                FixedVerticalOverhead += 8 + 8
            end

            local function ClampToViewport(NewWidth, NewHeight)
                local Camera = workspace.CurrentCamera
                if not Camera then
                    return NewWidth, NewHeight
                end

                local ViewportSize = Camera.ViewportSize
                local ScreenMargin = 12

                local MaxWidth = ViewportSize.X - ColorMenu.Menu.AbsolutePosition.X - ScreenMargin
                local MaxHeight = ViewportSize.Y - ColorMenu.Menu.AbsolutePosition.Y - ScreenMargin - FixedVerticalOverhead

                while NewWidth > MinMapSize and GetContentWidth(NewWidth) > MaxWidth do
                    NewWidth -= 4
                end

                if NewHeight > MaxHeight then
                    NewHeight = math.max(MinMapSize, math.floor(MaxHeight))
                end

                return NewWidth, NewHeight
            end

            local function UpdateColorMenuSize(NewWidth, NewHeight)
                NewWidth = math.max(MinMapSize, math.floor(NewWidth + 0.5))
                NewHeight = math.max(MinMapSize, math.floor(NewHeight + 0.5))
                NewWidth, NewHeight = ClampToViewport(NewWidth, NewHeight)

                if NewWidth == ColorPicker.MapWidth and NewHeight == ColorPicker.MapHeight then
                    return
                end

                local CurrentBarWidth = GetBarWidth(NewWidth)
                local CursorSize = math.clamp(math.floor((math.min(NewWidth, NewHeight) / BaseMapSize) * 6 + 0.5), 4, 10)

                ColorHolder.Size = UDim2.new(1, 0, 0, NewHeight)
                SatVipMap.Size = UDim2.fromOffset(NewWidth, NewHeight)
                SatVibCursor.Size = UDim2.fromOffset(CursorSize, CursorSize)
                HueSelector.Size = UDim2.new(0, CurrentBarWidth, 0, NewHeight)

                if TransparencySelector then
                    TransparencySelector.Size = UDim2.new(0, CurrentBarWidth, 0, NewHeight)
                end

                ColorPicker.MapWidth = NewWidth
                ColorPicker.MapHeight = NewHeight
                ColorMenu:SetSize(UDim2.new(0, GetContentWidth(NewWidth), 0, 0))
            end

            ResizeGrabber = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -Library.CornerRadius / 4, 0, 0),
                Size = UDim2.fromScale(1, 1),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Text = "",
                Parent = FooterBackground,
            })
            local ResizeGrabberIcon = New("ImageLabel", {
                ImageColor3 = "FontColor",
                ImageTransparency = 0.5,
                Position = UDim2.fromOffset(2, 2),
                Size = UDim2.new(1, -4, 1, -4),
                Parent = ResizeGrabber,
            })
            if ResizeIcon then
                Library:ApplyLucideIcon(ResizeGrabberIcon, ResizeIcon)
            end

            table.insert(ColorPicker.Connections, ResizeGrabber.InputBegan:Connect(function(Input: InputObject)
                Library.CantDragForced = true
                local StartMouse = Vector2.new(Mouse.X, Mouse.Y)
                local StartWidth = ColorPicker.MapWidth
                local StartHeight = ColorPicker.MapHeight

                while IsDragInput(Input) and not ColorPicker.Destroyed do
                    local Delta = Vector2.new(Mouse.X, Mouse.Y) - StartMouse
                    UpdateColorMenuSize(StartWidth + Delta.X, StartHeight + Delta.Y)

                    RunService.RenderStepped:Wait()
                end

                Library.CantDragForced = false
            end))
        end

        local InfoHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Parent = ContentHolder,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = UDim.new(0, 8),
            Parent = InfoHolder,
        })

        local HueBox = New("TextBox", {
            BackgroundColor3 = "MainColor",
            ClearTextOnFocus = false,
            Size = UDim2.fromScale(1, 1),
            Text = "#??????",
            TextSize = 14,
            Parent = InfoHolder,
        })

        local HueBoxStroke = New("UIStroke", {
            Color = "OutlineColor",
            Parent = HueBox,
        })

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = HueBox,
            })
        )

        local RgbBox = New("TextBox", {
            BackgroundColor3 = "MainColor",
            ClearTextOnFocus = false,
            Size = UDim2.fromScale(1, 1),
            Text = "?, ?, ?",
            TextSize = 14,
            Parent = InfoHolder,
        })

        local RgbBoxStroke = New("UIStroke", {
            Color = "OutlineColor",
            Parent = RgbBox,
        })

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = RgbBox,
            })
        )

        --// Context Menu \\--
        local ContextMenu
        ContextMenu = Library:AddContextMenu(Holder, UDim2.fromOffset(93, 0), function()
            return { Holder.AbsoluteSize.X + 1.5, 0.5 }
        end, 1, function(Active: boolean)
            local Half = UDim.new(0, Library.CornerRadius / 2)
            local Zero = UDim.new(0, 0)

            ColorPickerCorner.TopLeftRadius = Half
            ColorPickerCorner.BottomLeftRadius = Half
            ColorPickerCorner.TopRightRadius = Active and Zero or Half
            ColorPickerCorner.BottomRightRadius = Active and Zero or Half

            local MenuCorner = ContextMenu and ContextMenu.Corner
            if MenuCorner then
                MenuCorner.TopLeftRadius = Zero
                MenuCorner.TopRightRadius = Half
                MenuCorner.BottomRightRadius = Half
                MenuCorner.BottomLeftRadius = Half
            end
        end, false, "no_top_left")
        ColorPicker.ContextMenu = ContextMenu
        ContextMenu.List.Padding = UDim.new(0, 6)
        do
            local function CreateButton(Text, Func)
                local Button = New("TextButton", {
                    BackgroundColor3 = "MainColor",
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 21),
                    Text = Text,
                    TextSize = 14,
                    Parent = ContextMenu.Menu,
                })

                table.insert(ColorPicker.Connections, Button.MouseButton1Click:Connect(function()
                    Library:SafeCallback(Func)
                    ContextMenu:Close()
                end))

                table.insert(ColorPicker.Connections, Button.MouseEnter:Connect(function()
                    TweenService:Create(Button, Library.TweenInfo, {
                        BackgroundTransparency = 0.7,
                    }):Play()
                end))

                table.insert(ColorPicker.Connections, Button.MouseLeave:Connect(function()
                    TweenService:Create(Button, Library.TweenInfo, {
                        BackgroundTransparency = 1,
                    }):Play()
                end))
            end

            CreateButton("Copy color", function()
                Library.CopiedColor = { ColorPicker.Value, ColorPicker.Transparency }
            end)

            ColorPicker.SetValueRGB = function(...) end --// make luau lsp shut up
            CreateButton("Paste color", function()
                if not Library.CopiedColor then
                    return
                end

                ColorPicker:SetValueRGB(Library.CopiedColor[1], Library.CopiedColor[2])
            end)

            if setclipboard then
                CreateButton("Copy Hex", function()
                    setclipboard(tostring(ColorPicker.Value:ToHex()))
                end)

                CreateButton("Copy RGB", function()
                    setclipboard(table.concat({
                        math.floor(ColorPicker.Value.R * 255),
                        math.floor(ColorPicker.Value.G * 255),
                        math.floor(ColorPicker.Value.B * 255),
                    }, ", "))
                end)
            end
        end

        --// Copy/Paste Buttons \\--
        local ActionHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            Parent = ContentHolder,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = UDim.new(0, 8),
            Parent = ActionHolder,
        })

        local CopyColorButton = New("TextButton", {
            BackgroundColor3 = "MainColor",
            Size = UDim2.fromScale(1, 1),
            Text = "Copy color",
            TextSize = 14,
            Parent = ActionHolder,
        })
        New("UIStroke", {
            Color = "OutlineColor",
            Parent = CopyColorButton,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = CopyColorButton,
            })
        )

        local PasteColorButton = New("TextButton", {
            BackgroundColor3 = "MainColor",
            Size = UDim2.fromScale(1, 1),
            Text = "Paste color",
            TextSize = 14,
            Parent = ActionHolder,
        })
        New("UIStroke", {
            Color = "OutlineColor",
            Parent = PasteColorButton,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = PasteColorButton,
            })
        )

        local CopyColorOriginalText = CopyColorButton.Text
        local PasteColorOriginalText = PasteColorButton.Text
        local CopyColorResetId = 0
        local PasteColorResetId = 0

        table.insert(ColorPicker.Connections, CopyColorButton.MouseEnter:Connect(function()
            TweenService:Create(CopyColorButton, Library.TweenInfo, {
                BackgroundColor3 = Library:GetBetterColor(Library.Scheme.MainColor, 10),
            }):Play()
        end))

        table.insert(ColorPicker.Connections, CopyColorButton.MouseLeave:Connect(function()
            TweenService:Create(CopyColorButton, Library.TweenInfo, {
                BackgroundColor3 = Library.Scheme.MainColor,
            }):Play()
        end))

        table.insert(ColorPicker.Connections, PasteColorButton.MouseEnter:Connect(function()
            TweenService:Create(PasteColorButton, Library.TweenInfo, {
                BackgroundColor3 = Library:GetBetterColor(Library.Scheme.MainColor, 10),
            }):Play()
        end))

        table.insert(ColorPicker.Connections, PasteColorButton.MouseLeave:Connect(function()
            TweenService:Create(PasteColorButton, Library.TweenInfo, {
                BackgroundColor3 = Library.Scheme.MainColor,
            }):Play()
        end))

        table.insert(ColorPicker.Connections, CopyColorButton.MouseButton1Click:Connect(function()
            Library.CopiedColor = { ColorPicker.Value, ColorPicker.Transparency }

            CopyColorResetId += 1
            local ThisResetId = CopyColorResetId
            CopyColorButton.Text = "Copied color"

            task.delay(1, function()
                if ColorPicker.Destroyed or ThisResetId ~= CopyColorResetId then
                    return
                end

                CopyColorButton.Text = CopyColorOriginalText
            end)
        end))

        table.insert(ColorPicker.Connections, PasteColorButton.MouseButton1Click:Connect(function()
            PasteColorResetId += 1
            local ThisResetId = PasteColorResetId

            if not Library.CopiedColor then
                PasteColorButton.Text = "Nothing to paste"
            else
                ColorPicker:SetValueRGB(Library.CopiedColor[1], Library.CopiedColor[2])
                PasteColorButton.Text = "Pasted color"
            end

            task.delay(1, function()
                if ColorPicker.Destroyed or ThisResetId ~= PasteColorResetId then
                    return
                end

                PasteColorButton.Text = PasteColorOriginalText
            end)
        end))

        --// End \\--
        function ColorPicker:SetHSVFromRGB(Color)
            ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color:ToHSV()
        end

        function ColorPicker:Display()
            if Library.Unloaded then
                return
            end

            ColorPicker.Value = Color3.fromHSV(ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib)

            SatVipMap.BackgroundColor3 = Color3.fromHSV(ColorPicker.Hue, 1, 1)
            if TransparencyColor then
                TransparencyColor.BackgroundColor3 = ColorPicker.Value
            end

            SatVibCursor.Position = UDim2.fromScale(ColorPicker.Sat, 1 - ColorPicker.Vib)
            HueCursor.Position = UDim2.fromScale(0.5, ColorPicker.Hue)
            if TransparencyCursor then
                TransparencyCursor.Position = UDim2.fromScale(0.5, ColorPicker.Transparency)
            end

            HueBox.Text = "#" .. ColorPicker.Value:ToHex()
            RgbBox.Text = table.concat({
                math.floor(ColorPicker.Value.R * 255),
                math.floor(ColorPicker.Value.G * 255),
                math.floor(ColorPicker.Value.B * 255),
            }, ", ")

            RefreshFooterInfo()
        end

        local function ApplyHolderVisual(Disabled: boolean)
            Holder.Active = not Disabled
            HolderStroke.Transparency = Disabled and 0.5 or 0
            Holder.BackgroundTransparency = Disabled and 0.5 or 0

            if Disabled then
                Holder.BackgroundColor3 = ColorPicker.Value:Lerp(Library.Scheme.BackgroundColor, 0.5)
                HolderTransparency.ImageTransparency = math.clamp((1 - ColorPicker.Transparency) + 0.5, 0, 1)
            else
                Holder.BackgroundColor3 = ColorPicker.Value
                HolderStroke.Color = Library:GetDarkerColor(ColorPicker.Value)
                HolderTransparency.ImageTransparency = (1 - ColorPicker.Transparency)
            end
        end

        function ColorPicker:RunChanged()
            if ParentObj.Disabled then
                return
            end

            Library:SafeCallback(ColorPicker.Callback, ColorPicker.Value)
            Library:SafeCallback(ColorPicker.Changed, ColorPicker.Value)
        end

        function ColorPicker:Update()
            ColorPicker:Display()

            local Disabled = ParentObj.Disabled == true
            ApplyHolderVisual(Disabled)

            if Disabled then
                if ColorMenu.Active then
                    ColorMenu:Close()
                end

                if ContextMenu.Active then
                    ContextMenu:Close()
                end
            end

            ColorPicker:RunChanged()
        end

        function ColorPicker:OnChanged(Func)
            ColorPicker.Changed = Func
        end

        function ColorPicker:SetValue(HSV, Transparency)
            if typeof(HSV) == "Color3" then
                ColorPicker:SetValueRGB(HSV, Transparency)
                return
            end

            local Color = Color3.fromHSV(HSV[1], HSV[2], HSV[3])
            ColorPicker.Transparency = Info.Transparency and Transparency or 0
            ColorPicker:SetHSVFromRGB(Color)
            ColorPicker:Update()
        end

        function ColorPicker:SetValueRGB(Color, Transparency)
            ColorPicker.Transparency = Info.Transparency and Transparency or 0
            ColorPicker:SetHSVFromRGB(Color)
            ColorPicker:Update()
        end

        table.insert(ColorPicker.Connections, Holder.MouseButton1Click:Connect(function()
            if ParentObj.Disabled then
                return
            end

            ColorMenu:Toggle()
        end))

        table.insert(ColorPicker.Connections, Holder.MouseButton2Click:Connect(function()
            if ParentObj.Disabled then
                return
            end

            ContextMenu:Toggle()
        end))

        table.insert(ColorPicker.Connections, SatVipMap.InputBegan:Connect(function(Input: InputObject)
            while IsDragInput(Input) and not ColorPicker.Destroyed do
                local MinX = SatVipMap.AbsolutePosition.X
                local MaxX = MinX + SatVipMap.AbsoluteSize.X
                local LocationX = math.clamp(Mouse.X, MinX, MaxX)

                local MinY = SatVipMap.AbsolutePosition.Y
                local MaxY = MinY + SatVipMap.AbsoluteSize.Y
                local LocationY = math.clamp(Mouse.Y, MinY, MaxY)

                local OldSat = ColorPicker.Sat
                local OldVib = ColorPicker.Vib
                ColorPicker.Sat = (LocationX - MinX) / (MaxX - MinX)
                ColorPicker.Vib = 1 - ((LocationY - MinY) / (MaxY - MinY))

                if ColorPicker.Sat ~= OldSat or ColorPicker.Vib ~= OldVib then
                    ColorPicker:Update()
                end

                RunService.RenderStepped:Wait()
            end
        end))

        table.insert(ColorPicker.Connections, HueSelector.InputBegan:Connect(function(Input: InputObject)
            while IsDragInput(Input) and not ColorPicker.Destroyed do
                local Min = HueSelector.AbsolutePosition.Y
                local Max = Min + HueSelector.AbsoluteSize.Y
                local Location = math.clamp(Mouse.Y, Min, Max)

                local OldHue = ColorPicker.Hue
                ColorPicker.Hue = (Location - Min) / (Max - Min)

                if ColorPicker.Hue ~= OldHue then
                    ColorPicker:Update()
                end

                RunService.RenderStepped:Wait()
            end
        end))

        if TransparencySelector then
            table.insert(ColorPicker.Connections, TransparencySelector.InputBegan:Connect(function(Input: InputObject)
                while IsDragInput(Input) and not ColorPicker.Destroyed do
                    local Min = TransparencySelector.AbsolutePosition.Y
                    local Max = TransparencySelector.AbsolutePosition.Y + TransparencySelector.AbsoluteSize.Y
                    local Location = math.clamp(Mouse.Y, Min, Max)

                    local OldTransparency = ColorPicker.Transparency
                    ColorPicker.Transparency = (Location - Min) / (Max - Min)

                    if ColorPicker.Transparency ~= OldTransparency then
                        ColorPicker:Update()
                    end

                    RunService.RenderStepped:Wait()
                end
            end))
        end

        table.insert(ColorPicker.Connections, HueBox.FocusLost:Connect(function()
            local Success, Color = pcall(Color3.fromHex, HueBox.Text)
            if Success and typeof(Color) == "Color3" then
                ColorPicker.Hue, ColorPicker.Sat, ColorPicker.Vib = Color:ToHSV()
            end

            ColorPicker:Update()
        end))

        table.insert(ColorPicker.Connections, RgbBox.FocusLost:Connect(function()
            local R, G, B = RgbBox.Text:match("(%d+),%s*(%d+),%s*(%d+)")
            if R and G and B then
                ColorPicker:SetHSVFromRGB(Color3.fromRGB(R, G, B))
            end

            ColorPicker:Update()
        end))

        for _, BoxPair in {
            { HueBox, HueBoxStroke },
            { RgbBox, RgbBoxStroke }
        } do
            local TextBoxInstance, Stroke = BoxPair[1], BoxPair[2]

            table.insert(ColorPicker.Connections, TextBoxInstance.Focused:Connect(function()
                Library.Registry[Stroke].Color = "AccentColor"
                TweenService:Create(Stroke, Library.TweenInfo, {
                    Color = Library.Scheme.AccentColor,
                }):Play()
            end))

            table.insert(ColorPicker.Connections, TextBoxInstance.FocusLost:Connect(function()
                Library.Registry[Stroke].Color = "OutlineColor"
                TweenService:Create(Stroke, Library.TweenInfo, {
                    Color = Library.Scheme.OutlineColor,
                }):Play()
            end))
        end

        ColorPicker:Update()

        if not ParentObj.Addons then
            ParentObj.Addons = {}
        end

        table.insert(ParentObj.Addons, ColorPicker)

        ColorPicker.Default = ColorPicker.Value

        function ColorPicker:Destroy()
            ColorPicker.Destroyed = true

            if ColorPicker.Connections then
                for _, Connection in ColorPicker.Connections do
                    Connection:Disconnect()
                end
            end

            if ColorMenu then
                ColorMenu:Destroy()
            end

            if ResizeGrabber then
                ResizeGrabber:Destroy()
            end

            if ContextMenu then
                ContextMenu:Destroy()
            end

            if Holder then
                Holder:Destroy()
            end

            if ParentObj and ParentObj.Addons then
                local AddonIdx = table.find(ParentObj.Addons, ColorPicker)

                if AddonIdx then
                    table.remove(ParentObj.Addons, AddonIdx)
                end
            end

            Options[Idx] = nil
        end

        Options[Idx] = ColorPicker

        return self
    end

    function Funcs:AddSettingsPopup(Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info or {}, Templates.SettingsPopup)

        local ParentObj = self
        local ParentLabel = ParentObj.TextLabel
        assert(ParentLabel, "SettingsPopup can only be added to Toggles, Checkboxes and Labels.")

        local Groupbox = ParentObj.Parent

        local Gear = New("ImageButton", {
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            ImageColor3 = "FontColor",
            ImageTransparency = 0.5,
            LayoutOrder = -1,
            Size = UDim2.fromOffset(16, 16),
            Parent = ParentLabel,
        })
        if SettingsIcon then
            Library:ApplyLucideIcon(Gear, SettingsIcon)
        end

        local Popup = {
            Connections = {},
            Destroyed = false,

            Width = Info.Width,
            Height = 0,

            Tooltip = Info.Tooltip,
            TooltipTable = nil,

            Holder = Gear,
            Container = nil,
            Menu = nil,

            Tab = Groupbox and Groupbox.Tab,
            Visible = true,
            Elements = {},
            DependencyBoxes = {},

            Type = "SettingsPopup",
            Parent = ParentObj,
        }

        local Hovering = false
        local function UpdateGear()
            local Lit = Popup.Menu and Popup.Menu.Active or Hovering
            Gear.ImageTransparency = if ParentObj.Disabled then 0.8 elseif Lit then 0 else 0.5
        end

        local MenuTable = Library:AddContextMenu(Gear, function()
            return UDim2.fromOffset(Popup.Width, Popup.Height)
        end, function()
            -- Keep the popup on screen: shift it horizontally and flip it above the gear when needed --
            local Margin = 4
            local GearPos = Gear.AbsolutePosition
            local Bounds = Overlay.AbsoluteSize
            local PopupW = Popup.Width * Library.DPIScale
            local PopupH = Popup.Height * Library.DPIScale

            local X = -8
            if GearPos.X + X + PopupW > Bounds.X - Margin then
                X = Bounds.X - Margin - PopupW - GearPos.X
            end
            if GearPos.X + X < Margin then
                X = Margin - GearPos.X
            end

            local Y = Gear.AbsoluteSize.Y + 6
            if GearPos.Y + Y + PopupH > Bounds.Y - Margin and GearPos.Y - 6 - PopupH >= Margin then
                Y = -PopupH - 6
            end
            if GearPos.Y + Y + PopupH > Bounds.Y - Margin then
                Y = Bounds.Y - Margin - PopupH - GearPos.Y
            end

            return { X, Y }
        end, nil, function()
            UpdateGear()
        end, false, nil, "SettingsPopup")
        MenuTable.Menu.ClipsDescendants = true
        Popup.Menu = MenuTable

        local Container = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Parent = MenuTable.Menu,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 8),
            Parent = Container,
        })
        local List = New("UIListLayout", {
            Padding = UDim.new(0, 8),
            Parent = Container,
        })
        Popup.Container = Container

        function Popup:Resize()
            Popup.Height = math.ceil(List.AbsoluteContentSize.Y / Library.DPIScale) + 16

            if MenuTable.Active and not MenuTable.OpenCloseTween then
                MenuTable.Menu.Size = UDim2.fromOffset(Popup.Width, Popup.Height)
            end
        end

        function Popup:Update()
            if ParentObj.Disabled and MenuTable.Active then
                MenuTable:Close()
            end

            Gear.Active = not ParentObj.Disabled
            UpdateGear()
        end

        function Popup:Open()
            if ParentObj.Disabled then
                return
            end

            Popup:Resize()
            MenuTable:Open()
        end

        function Popup:Close()
            MenuTable:Close()
        end

        function Popup:SetWidth(Width: number)
            Popup.Width = Width
            Popup:Resize()
        end

        table.insert(Popup.Connections, List:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Popup:Resize()
        end))

        table.insert(Popup.Connections, Gear.MouseEnter:Connect(function()
            Hovering = true
            UpdateGear()
        end))
        table.insert(Popup.Connections, Gear.MouseLeave:Connect(function()
            Hovering = false
            UpdateGear()
        end))

        table.insert(Popup.Connections, Gear.MouseButton1Click:Connect(function()
            if MenuTable.Active then
                Popup:Close()
            else
                Popup:Open()
            end
        end))

        if typeof(Popup.Tooltip) == "string" then
            Popup.TooltipTable = Library:AddTooltip(Popup.Tooltip, nil, Gear)
        end

        setmetatable(Popup, BaseGroupbox)

        if not ParentObj.Addons then
            ParentObj.Addons = {}
        end
        table.insert(ParentObj.Addons, Popup)

        Popup:Update()
        Popup:Resize()

        function Popup:Destroy()
            Popup.Destroyed = true

            for _, Connection in Popup.Connections do
                Connection:Disconnect()
            end

            for Index = #Popup.Elements, 1, -1 do
                local Element = Popup.Elements[Index]
                if Element and Element.Destroy then
                    Element:Destroy()
                end
            end

            for _, SubDepbox in Popup.DependencyBoxes do
                if SubDepbox.Destroy then
                    SubDepbox:Destroy()
                end
            end

            if Popup.TooltipTable then
                Popup.TooltipTable:Destroy()
            end

            MenuTable:Destroy()
            Gear:Destroy()

            if ParentObj.Addons then
                local AddonIdx = table.find(ParentObj.Addons, Popup)
                if AddonIdx then
                    table.remove(ParentObj.Addons, AddonIdx)
                end
            end
        end

        return Popup
    end

    BaseAddons.__index = Funcs
    BaseAddons.__namecall = function(_, Key, ...)
        return Funcs[Key](...)
    end
end

BaseGroupbox = {}
do
    local Funcs = {}

    function Funcs:AddDivider(...)
        if self.Destroyed then return nil end

        local Params = select(1, ...)
        local Text
        local MarginTop = 0
        local MarginBottom = 0

        if typeof(Params) == "table" then
            Text = Params.Text
            MarginTop = Params.MarginTop or Params.Margin or 0
            MarginBottom = Params.MarginBottom or Params.Margin or 0
        elseif typeof(Params) == "string" then
            Text = Params
        end

        local Groupbox = self
        local Container = Groupbox.Container

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 6 + MarginTop + MarginBottom),
            Parent = Container,
        })

        local InnerHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingTop = UDim.new(0, MarginTop),
            PaddingBottom = UDim.new(0, MarginBottom),
            Parent = Holder,
        })

        if Text then
            local TextLabel = New("TextLabel", {
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                Text = Text,
                TextSize = 14,
                TextTransparency = 0.5,
                TextXAlignment = Enum.TextXAlignment.Center,
                Parent = InnerHolder,
            })

            local X, _ = Library:GetTextBounds(Text, TextLabel.FontFace, TextLabel.TextSize, TextLabel.AbsoluteSize.X / Library.DPIScale)
            local SizeX = X // 2 + 10

            New("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = "MainColor",
                BorderColor3 = "OutlineColor",
                BorderSizePixel = 1,
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.new(0.5, -SizeX, 0, 2),
                Parent = InnerHolder,
            })
            New("Frame", {
                AnchorPoint = Vector2.new(1, 0.5),
                BackgroundColor3 = "MainColor",
                BorderColor3 = "OutlineColor",
                BorderSizePixel = 1,
                Position = UDim2.fromScale(1, 0.5),
                Size = UDim2.new(0.5, -SizeX, 0, 2),
                Parent = InnerHolder,
            })
        else
            New("Frame", {
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundColor3 = "MainColor",
                BorderColor3 = "OutlineColor",
                BorderSizePixel = 1,
                Position = UDim2.fromScale(0, 0.5),
                Size = UDim2.new(1, 0, 0, 2),
                Parent = InnerHolder,
            })
        end

        Groupbox:Resize()

        local Divider = {
            Connections = {},
            Destroyed = false,

            Holder = Holder,
            Text = Text,
            MarginTop = MarginTop,
            MarginBottom = MarginBottom,
            Type = "Divider",

            Parent = Groupbox,
        }

        function Divider:SetVisible(Value)
            Holder.Visible = Value == true
            Groupbox:Resize()
        end

        function Divider:Destroy()
            Divider.Destroyed = true

            if Divider.Connections then
                for _, Connection in Divider.Connections do
                    Connection:Disconnect()
                end
            end

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Divider)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
        end

        table.insert(Groupbox.Elements, Divider)
        return Divider
    end

    function Funcs:AddLabel(...)
        if self.Destroyed then return nil end

        local Data = {}
        local Addons = {}

        local First = select(1, ...)
        local Second = select(2, ...)

        if typeof(First) == "table" or typeof(Second) == "table" then
            local Params = typeof(First) == "table" and First or Second

            Data.Text = Params.Text or ""
            Data.DoesWrap = Params.DoesWrap or false
            Data.Size = Params.Size or 14
            Data.Visible = if typeof(Params.Visible) == "boolean" then Params.Visible else true
            Data.Idx = typeof(Second) == "table" and First or nil
        else
            Data.Text = First or ""
            Data.DoesWrap = Second or false
            Data.Size = 14
            Data.Visible = true
            Data.Idx = select(3, ...) or nil
        end

        local Groupbox = self
        local Container = Groupbox.Container

        local Label = {
            Connections = {},
            Destroyed = false,

            Text = Data.Text,
            DoesWrap = Data.DoesWrap,

            Addons = Addons,

            Visible = Data.Visible,
            Type = "Label",

            Parent = Groupbox,
        }

        local TextLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            Text = Label.Text,
            TextSize = Data.Size,
            TextWrapped = Label.DoesWrap,
            TextXAlignment = Enum.TextXAlignment.Left,
            Visible = Label.Visible,
            Parent = Container,
        })

        function Label:Display()
            if not Label.DoesWrap then
                return
            end

            local Width = TextLabel.AbsoluteSize.X / Library.DPIScale
            if Width <= 0 then return end

            local _, Y = Library:GetTextBounds(Label.Text, TextLabel.FontFace, TextLabel.TextSize, Width)
            TextLabel.Size = UDim2.new(1, 0, 0, Y + 4)
        end

        function Label:SetVisible(Visible: boolean)
            Label.Visible = Visible

            TextLabel.Visible = Label.Visible
            Groupbox:Resize()
        end

        function Label:SetText(Text: string)
            Label.Text = Text
            TextLabel.Text = Text

            Label:Display()
            Groupbox:Resize()
        end

        if Label.DoesWrap then
            Label:Display()

            local Last = TextLabel.AbsoluteSize
            table.insert(Label.Connections, TextLabel:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
                if TextLabel.AbsoluteSize == Last then
                    return
                end

                Label:Display()
                Last = TextLabel.AbsoluteSize

                Groupbox:Resize()
            end))
        else
            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Right,
                Padding = UDim.new(0, 6),
                Parent = TextLabel,
            })
        end

        Groupbox:Resize()

        Label.TextLabel = TextLabel
        Label.Container = Container
        if not Data.DoesWrap then
            setmetatable(Label, BaseAddons)
        end

        Label.Holder = TextLabel
        table.insert(Groupbox.Elements, Label)

        if Data.Idx then
            Labels[Data.Idx] = Label
        else
            table.insert(Labels, Label)
        end

        function Label:Destroy()
            Label.Destroyed = true

            if Label.Connections then
                for _, Connection in Label.Connections do
                    Connection:Disconnect()
                end
            end

            if Label.Addons then
                for Index = #Label.Addons, 1, -1 do
                    local Addon = table.remove(Label.Addons, Index)
                    if Addon and Addon.Destroy then
                        Addon:Destroy()
                    end
                end
            end

            if TextLabel then
                TextLabel:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Label)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()

            if Data.Idx then
                Labels[Data.Idx] = nil
            else
                local LblIdx = table.find(Labels, Label)

                if LblIdx then
                    table.remove(Labels, LblIdx)
                end
            end
        end

        return Label
    end

    function Funcs:AddButton(...)
        if self.Destroyed then return nil end

        local function GetInfo(...)
            local Info = {}

            local First = select(1, ...)
            local Second = select(2, ...)

            if typeof(First) == "table" or typeof(Second) == "table" then
                local Params = typeof(First) == "table" and First or Second

                Info.Text = Params.Text or ""
                Info.Func = Params.Func or Params.Callback or function() end
                Info.DoubleClick = Params.DoubleClick
                Info.Icon = Params.Icon or Params.IconName

                Info.Tooltip = Params.Tooltip
                Info.DisabledTooltip = Params.DisabledTooltip

                Info.Risky = Params.Risky or false
                Info.Disabled = Params.Disabled or false
                Info.Visible = if typeof(Params.Visible) == "boolean" then Params.Visible else true
                Info.Idx = typeof(Second) == "table" and First or nil
            else
                Info.Text = First or ""
                Info.Func = Second or function() end
                Info.DoubleClick = false
                Info.Icon = nil

                Info.Tooltip = nil
                Info.DisabledTooltip = nil

                Info.Risky = false
                Info.Disabled = false
                Info.Visible = true
                Info.Idx = select(3, ...) or nil
            end

            return Info
        end
        local Info = GetInfo(...)

        local Groupbox = self
        local Container = Groupbox.Container

        local Button = {
            Connections = {},
            Destroyed = false,

            Text = Info.Text,
            Func = Info.Func,
            DoubleClick = Info.DoubleClick,
            Icon = Info.Icon,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Risky = Info.Risky,
            Disabled = Info.Disabled,
            Visible = Info.Visible,
            Locked = false,

            Base = nil,
            Stroke = nil,
            Content = nil,
            Label = nil,
            IconImage = nil,

            Tween = nil,
            Type = "Button",

            Parent = Groupbox,
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 21),
            Parent = Container,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalFlex = Enum.UIFlexAlignment.Fill,
            Padding = UDim.new(0, 9),
            Parent = Holder,
        })

        local function ApplyButtonIcon(Button, IconName)
            local Content = Button.Content
            if not Content then
                return
            end

            local ParsedIcon = Library:GetCustomIcon(IconName)
            if ParsedIcon then
                local ColorKey = Button.Risky and "RedColor" or (ParsedIcon.Custom and "WhiteColor" or "FontColor")

                if not Button.IconImage then
                    Button.IconImage = New("ImageLabel", {
                        BackgroundTransparency = 1,
                        ImageColor3 = ColorKey,
                        LayoutOrder = 0,
                        Size = UDim2.fromOffset(14, 14),
                        Parent = Content,
                    })
                else
                    Button.IconImage.ImageColor3 = Library.Scheme[ColorKey]
                    Library.Registry[Button.IconImage].ImageColor3 = ColorKey
                end

                Button.IconImage.ImageTransparency = Button.Disabled and 0.8 or 0.4
                Button.IconImage.Visible = true
                Library:ApplyLucideIcon(Button.IconImage, ParsedIcon)
            elseif Button.IconImage then
                Button.IconImage.Visible = false
            end
        end

        local function CreateButton(Button)
            local Base = New("TextButton", {
                Active = not Button.Disabled,
                BackgroundColor3 = Button.Disabled and "BackgroundColor" or "MainColor",
                Size = UDim2.fromScale(1, 1),
                Text = "",
                Visible = Button.Visible,
                Parent = Holder,
            })

            local Stroke = New("UIStroke", {
                Color = "OutlineColor",
                Transparency = Button.Disabled and 0.5 or 0,
                Parent = Base,
            })

            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                    Parent = Base,
                })
            )

            local Content = New("Frame", {
                AnchorPoint = Vector2.new(0.5, 0.5),
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0.5, 0.5),
                Size = UDim2.fromOffset(0, 16),
                Parent = Base,
            })
            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                HorizontalAlignment = Enum.HorizontalAlignment.Center,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Padding = UDim.new(0, 6),
                Parent = Content,
            })
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                Parent = Content,
            })

            Button.Content = Content
            Button.Label = New("TextLabel", {
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                LayoutOrder = 1,
                Size = UDim2.fromOffset(0, 16),
                Text = Button.Text,
                TextSize = 14,
                TextTransparency = Button.Disabled and 0.8 or 0.4,
                Parent = Content,
            })

            if Button.Risky then
                Button.Label.TextColor3 = Library.Scheme.RedColor
                Library.Registry[Button.Label].TextColor3 = "RedColor"
            end

            ApplyButtonIcon(Button, Button.Icon)

            return Base, Stroke
        end

        local function InitEvents(Button)
            table.insert(Button.Connections, Button.Base.MouseEnter:Connect(function()
                if Button.Disabled then
                    return
                end

                Button.Tween = TweenService:Create(Button.Label, Library.TweenInfo, {
                    TextTransparency = 0,
                })
                Button.Tween:Play()

                if Button.IconImage and Button.IconImage.Visible then
                    TweenService:Create(Button.IconImage, Library.TweenInfo, {
                        ImageTransparency = 0,
                    }):Play()
                end
            end))
            table.insert(Button.Connections, Button.Base.MouseLeave:Connect(function()
                if Button.Disabled then
                    return
                end

                Button.Tween = TweenService:Create(Button.Label, Library.TweenInfo, {
                    TextTransparency = 0.4,
                })
                Button.Tween:Play()

                if Button.IconImage and Button.IconImage.Visible then
                    TweenService:Create(Button.IconImage, Library.TweenInfo, {
                        ImageTransparency = 0.4,
                    }):Play()
                end
            end))

            table.insert(Button.Connections, Button.Base.MouseButton1Click:Connect(function()
                if Button.Disabled or Button.Locked then
                    return
                end

                if Button.DoubleClick then
                    Button.Locked = true

                    local IconWasVisible = false
                    if Button.IconImage then
                        IconWasVisible = Button.IconImage.Visible
                        Button.IconImage.Visible = false
                    end

                    Button.Label.Text = "Are you sure?"
                    Button.Label.TextColor3 = Library.Scheme.AccentColor
                    Library.Registry[Button.Label].TextColor3 = "AccentColor"

                    local Clicked = WaitForEvent(Button.Base.MouseButton1Click, 0.5)

                    Button.Label.Text = Button.Text
                    Button.Label.TextColor3 = Button.Risky and Library.Scheme.RedColor or Library.Scheme.FontColor
                    Library.Registry[Button.Label].TextColor3 = Button.Risky and "RedColor" or "FontColor"

                    if Button.IconImage then
                        Button.IconImage.Visible = IconWasVisible
                    end

                    if Clicked then
                        Library:SafeCallback(Button.Func)
                    end

                    RunService.RenderStepped:Wait()
                    Button.Locked = false
                    return
                end

                Library:SafeCallback(Button.Func)
            end))
        end

        Button.Base, Button.Stroke = CreateButton(Button)
        InitEvents(Button)

        function Button:AddButton(...)
            local Info = GetInfo(...)

            local SubButton = {
                Connections = {},
                Destroyed = false,

                Text = Info.Text,
                Func = Info.Func,
                DoubleClick = Info.DoubleClick,
                Icon = Info.Icon,

                Tooltip = Info.Tooltip,
                DisabledTooltip = Info.DisabledTooltip,
                TooltipTable = nil,

                Risky = Info.Risky,
                Disabled = Info.Disabled,
                Visible = Info.Visible,
                Locked = false,

                Base = nil,
                Stroke = nil,
                Content = nil,
                Label = nil,
                IconImage = nil,

                Tween = nil,
                Type = "SubButton",
            }

            Button.SubButton = SubButton
            SubButton.Base, SubButton.Stroke = CreateButton(SubButton)
            InitEvents(SubButton)

            function SubButton:UpdateColors()
                if Library.Unloaded then
                    return
                end

                StopTween(SubButton.Tween)

                SubButton.Base.BackgroundColor3 = SubButton.Disabled and Library.Scheme.BackgroundColor or Library.Scheme.MainColor
                SubButton.Label.TextTransparency = SubButton.Disabled and 0.8 or 0.4
                SubButton.Stroke.Transparency = SubButton.Disabled and 0.5 or 0

                if SubButton.IconImage and SubButton.IconImage.Visible then
                    SubButton.IconImage.ImageTransparency = SubButton.Disabled and 0.8 or 0.4
                end

                Library.Registry[SubButton.Base].BackgroundColor3 = SubButton.Disabled and "BackgroundColor"
                    or "MainColor"
            end

            function SubButton:SetDisabled(Disabled: boolean)
                SubButton.Disabled = Disabled

                if SubButton.TooltipTable then
                    SubButton.TooltipTable.Disabled = SubButton.Disabled
                end

                SubButton.Base.Active = not SubButton.Disabled
                SubButton:UpdateColors()
                Library:UpdateAddons(SubButton)
            end

            function SubButton:SetVisible(Visible: boolean)
                SubButton.Visible = Visible

                SubButton.Base.Visible = SubButton.Visible
                Groupbox:Resize()
            end

            function SubButton:SetText(Text: string)
                SubButton.Text = Text
                SubButton.Label.Text = Text
            end

            function SubButton:SetIcon(Icon: string?)
                SubButton.Icon = Icon
                ApplyButtonIcon(SubButton, Icon)
            end

            if typeof(SubButton.Tooltip) == "string" or typeof(SubButton.DisabledTooltip) == "string" then
                SubButton.TooltipTable =
                    Library:AddTooltip(SubButton.Tooltip, SubButton.DisabledTooltip, SubButton.Base)
                SubButton.TooltipTable.Disabled = SubButton.Disabled
            end

            SubButton:UpdateColors()

            if Info.Idx then
                Buttons[Info.Idx] = SubButton
            else
                table.insert(Buttons, SubButton)
            end

            SubButton.AddKeyPicker = BaseAddons.__index.AddKeyPicker

            function SubButton:Destroy()
                SubButton.Destroyed = true

                if SubButton.Connections then
                    for _, Connection in SubButton.Connections do
                        Connection:Disconnect()
                    end
                end

                if SubButton.TooltipTable then
                    SubButton.TooltipTable:Destroy()
                end

                if SubButton.Tween then
                    SubButton.Tween:Destroy()
                end

                if SubButton.Base then
                    SubButton.Base:Destroy()
                end

                if Info.Idx then
                    Buttons[Info.Idx] = nil
                else
                    local BIdx = table.find(Buttons, SubButton)

                    if BIdx then
                        table.remove(Buttons, BIdx)
                    end
                end
            end

            return SubButton
        end

        function Button:UpdateColors()
            if Library.Unloaded then
                return
            end

            StopTween(Button.Tween)

            Button.Base.BackgroundColor3 = Button.Disabled and Library.Scheme.BackgroundColor or Library.Scheme.MainColor
            Button.Label.TextTransparency = Button.Disabled and 0.8 or 0.4
            Button.Stroke.Transparency = Button.Disabled and 0.5 or 0

            if Button.IconImage and Button.IconImage.Visible then
                Button.IconImage.ImageTransparency = Button.Disabled and 0.8 or 0.4
            end

            Library.Registry[Button.Base].BackgroundColor3 = Button.Disabled and "BackgroundColor" or "MainColor"
        end

        function Button:SetDisabled(Disabled: boolean)
            Button.Disabled = Disabled

            if Button.TooltipTable then
                Button.TooltipTable.Disabled = Button.Disabled
            end

            Button.Base.Active = not Button.Disabled
            Button:UpdateColors()
            Library:UpdateAddons(Button)
        end

        function Button:SetVisible(Visible: boolean)
            Button.Visible = Visible

            Holder.Visible = Button.Visible
            Groupbox:Resize()
        end

        function Button:SetText(Text: string)
            Button.Text = Text
            Button.Label.Text = Text
        end

        function Button:SetIcon(Icon: string?)
            Button.Icon = Icon
            ApplyButtonIcon(Button, Icon)
        end

        if typeof(Button.Tooltip) == "string" or typeof(Button.DisabledTooltip) == "string" then
            Button.TooltipTable = Library:AddTooltip(Button.Tooltip, Button.DisabledTooltip, Button.Base)
            Button.TooltipTable.Disabled = Button.Disabled
        end

        Button:UpdateColors()
        Groupbox:Resize()

        Button.Holder = Holder
        table.insert(Groupbox.Elements, Button)

        if Info.Idx then
            Buttons[Info.Idx] = Button
        else
            table.insert(Buttons, Button)
        end

        Button.AddKeyPicker = BaseAddons.__index.AddKeyPicker

        function Button:Destroy()
            Button.Destroyed = true

            if Button.Connections then
                for _, Connection in Button.Connections do
                    Connection:Disconnect()
                end
            end

            if Button.TooltipTable then
                Button.TooltipTable:Destroy()
            end

            if Button.Tween then
                Button.Tween:Destroy()
            end

            if Button.SubButton then
                Button.SubButton:Destroy()
            end

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Button)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()

            if Info.Idx then
                Buttons[Info.Idx] = nil
            else
                local BIdx = table.find(Buttons, Button)

                if BIdx then
                    table.remove(Buttons, BIdx)
                end
            end
        end

        return Button
    end

    function Funcs:AddCheckbox(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.Toggle)

        local Groupbox = self
        local Container = Groupbox.Container

        local Toggle = {
            Connections = {},
            Destroyed = false,

            Text = Info.Text,
            Value = Info.Default,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Callback = Info.Callback,
            Changed = Info.Changed,

            Risky = Info.Risky,
            Disabled = Info.Disabled,
            Visible = Info.Visible,

            Addons = {},
            AnyKeyPickerPicking = false,

            Variant = "Checkbox",
            Type = "Toggle",

            Parent = Groupbox,
        }

        local Button = New("TextButton", {
            Active = not Toggle.Disabled,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            Text = "",
            Visible = Toggle.Visible,
            Parent = Container,
        })

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(26, 0),
            Size = UDim2.new(1, -26, 1, 0),
            Text = Toggle.Text,
            TextSize = 14,
            TextTransparency = 0.4,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Button,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 6),
            Parent = Label,
        })

        local Checkbox = New("Frame", {
            BackgroundColor3 = "MainColor",
            Size = UDim2.fromScale(1, 1),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            Parent = Button,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Checkbox,
            })
        )

        local CheckboxStroke = New("UIStroke", {
            Color = "OutlineColor",
            Parent = Checkbox,
        })

        local CheckImage = New("ImageLabel", {
            ImageColor3 = "FontColor",
            ImageTransparency = 1,
            Position = UDim2.fromOffset(2, 2),
            Size = UDim2.new(1, -4, 1, -4),
            Parent = Checkbox,
        })
        if CheckIcon then
            Library:ApplyLucideIcon(CheckImage, CheckIcon)
        end

        function Toggle:UpdateColors()
            Toggle:Display()
        end

        function Toggle:Display()
            if Library.Unloaded then
                return
            end

            CheckboxStroke.Transparency = Toggle.Disabled and 0.5 or 0

            if Toggle.Disabled then
                Label.TextTransparency = 0.8
                CheckImage.ImageTransparency = Toggle.Value and 0.8 or 1

                Checkbox.BackgroundColor3 = Library.Scheme.BackgroundColor
                Library.Registry[Checkbox].BackgroundColor3 = "BackgroundColor"

                return
            end

            TweenService:Create(Label, Library.TweenInfo, {
                TextTransparency = Toggle.Value and 0 or 0.4,
            }):Play()
            TweenService:Create(CheckImage, Library.TweenInfo, {
                ImageTransparency = Toggle.Value and 0 or 1,
            }):Play()

            Checkbox.BackgroundColor3 = Library.Scheme.MainColor
            Library.Registry[Checkbox].BackgroundColor3 = "MainColor"
        end

        function Toggle:OnChanged(Func)
            Toggle.Changed = Func
        end

        function Toggle:RunChanged()
            if Toggle.Disabled then
                return
            end

            Library:SafeCallback(Toggle.Callback, Toggle.Value)
            Library:SafeCallback(Toggle.Changed, Toggle.Value)
        end

        function Toggle:SetValue(Value)
            Toggle.Value = Value
            Toggle:Display()

            for _, Addon in Toggle.Addons do
                if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
                    Addon.Toggled = Toggle.Value
                    Addon:Update()
                end
            end

            if not Toggle.Disabled then
                Library:UpdateDependencyBoxes()
            end

            if not Toggle.AnyKeyPickerPicking then
                Toggle:RunChanged()
            end
        end

        function Toggle:SetDisabled(Disabled: boolean)
            Toggle.Disabled = Disabled

            if Toggle.TooltipTable then
                Toggle.TooltipTable.Disabled = Toggle.Disabled
            end

            Library:UpdateAddons(Toggle)

            Button.Active = not Toggle.Disabled
            Toggle:Display()

            Library:UpdateDependencyBoxes()
        end

        function Toggle:SetVisible(Visible: boolean)
            Toggle.Visible = Visible

            Button.Visible = Toggle.Visible
            Groupbox:Resize()
        end

        function Toggle:SetText(Text: string)
            Toggle.Text = Text
            Label.Text = Text
        end

        table.insert(Toggle.Connections, Button.MouseButton1Click:Connect(function()
            if Toggle.Disabled then
                return
            end

            Toggle:SetValue(not Toggle.Value)
        end))

        if typeof(Toggle.Tooltip) == "string" or typeof(Toggle.DisabledTooltip) == "string" then
            Toggle.TooltipTable = Library:AddTooltip(Toggle.Tooltip, Toggle.DisabledTooltip, Button)
            Toggle.TooltipTable.Disabled = Toggle.Disabled
        end

        if Toggle.Risky then
            Label.TextColor3 = Library.Scheme.RedColor
            Library.Registry[Label].TextColor3 = "RedColor"
        end

        Toggle:Display()
        Groupbox:Resize()

        Toggle.TextLabel = Label
        Toggle.Container = Container
        setmetatable(Toggle, BaseAddons)

        Toggle.Holder = Button
        table.insert(Groupbox.Elements, Toggle)

        Toggle.Default = Toggle.Value

        Toggles[Idx] = Toggle

        function Toggle:Destroy()
            Toggle.Destroyed = true

            if Toggle.Connections then
                for _, Connection in Toggle.Connections do
                    Connection:Disconnect()
                end
            end

            if Toggle.TooltipTable then
                Toggle.TooltipTable:Destroy()
            end

            if Button then
                Button:Destroy()
            end

            if Toggle.Addons then
                for Index = #Toggle.Addons, 1, -1 do
                    local Addon = table.remove(Toggle.Addons, Index)
                    if Addon and Addon.Destroy then
                        Addon:Destroy()
                    end
                end
            end

            local ElemIdx = table.find(Groupbox.Elements, Toggle)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Toggles[Idx] = nil
        end

        return Toggle
    end

    function Funcs:AddToggle(Idx, Info)
        if self.Destroyed then return nil end

        if Library.ForceCheckbox then
            return Funcs.AddCheckbox(self, Idx, Info)
        end

        Info = Library:Validate(Info, Templates.Toggle)

        local Groupbox = self
        local Container = Groupbox.Container

        local Toggle = {
            Connections = {},
            Destroyed = false,

            Text = Info.Text,
            Value = Info.Default,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Callback = Info.Callback,
            Changed = Info.Changed,

            Risky = Info.Risky,
            Disabled = Info.Disabled,
            Visible = Info.Visible,

            Addons = {},
            AnyKeyPickerPicking = false,

            Variant = "Switch",
            Type = "Toggle",

            Parent = Groupbox,
        }

        local Button = New("TextButton", {
            Active = not Toggle.Disabled,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            Text = "",
            Visible = Toggle.Visible,
            Parent = Container,
        })

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -40, 1, 0),
            Text = Toggle.Text,
            TextSize = 14,
            TextTransparency = 0.4,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Button,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Padding = UDim.new(0, 6),
            Parent = Label,
        })

        local Switch = New("Frame", {
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = "MainColor",
            Position = UDim2.fromScale(1, 0),
            Size = UDim2.fromOffset(32, 18),
            Parent = Button,
        })
        New("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = Switch,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 2),
            PaddingLeft = UDim.new(0, 2),
            PaddingRight = UDim.new(0, 2),
            PaddingTop = UDim.new(0, 2),
            Parent = Switch,
        })
        local SwitchStroke = New("UIStroke", {
            Color = "OutlineColor",
            Parent = Switch,
        })

        local Ball = New("Frame", {
            BackgroundColor3 = "FontColor",
            Size = UDim2.fromScale(1, 1),
            SizeConstraint = Enum.SizeConstraint.RelativeYY,
            Parent = Switch,
        })
        New("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = Ball,
        })

        function Toggle:UpdateColors()
            Toggle:Display()
        end

        function Toggle:Display()
            if Library.Unloaded then
                return
            end

            local Offset = Toggle.Value and 1 or 0

            Switch.BackgroundTransparency = Toggle.Disabled and 0.75 or 0
            SwitchStroke.Transparency = Toggle.Disabled and 0.75 or 0

            Switch.BackgroundColor3 = Toggle.Value and Library.Scheme.AccentColor or Library.Scheme.MainColor
            SwitchStroke.Color = Toggle.Value and Library.Scheme.AccentColor or Library.Scheme.OutlineColor

            Library.Registry[Switch].BackgroundColor3 = Toggle.Value and "AccentColor" or "MainColor"
            Library.Registry[SwitchStroke].Color = Toggle.Value and "AccentColor" or "OutlineColor"

            if Toggle.Disabled then
                Label.TextTransparency = 0.8
                Ball.AnchorPoint = Vector2.new(Offset, 0)
                Ball.Position = UDim2.fromScale(Offset, 0)

                Ball.BackgroundColor3 = Library:GetDarkerColor(Library.Scheme.FontColor)
                Library.Registry[Ball].BackgroundColor3 = function()
                    return Library:GetDarkerColor(Library.Scheme.FontColor)
                end

                return
            end

            TweenService:Create(Label, Library.TweenInfo, {
                TextTransparency = Toggle.Value and 0 or 0.4,
            }):Play()
            TweenService:Create(Ball, Library.TweenInfo, {
                AnchorPoint = Vector2.new(Offset, 0),
                Position = UDim2.fromScale(Offset, 0),
            }):Play()

            Ball.BackgroundColor3 = Library.Scheme.FontColor
            Library.Registry[Ball].BackgroundColor3 = "FontColor"
        end

        function Toggle:OnChanged(Func)
            Toggle.Changed = Func
        end

        function Toggle:RunChanged()
            if Toggle.Disabled then
                return
            end

            Library:SafeCallback(Toggle.Callback, Toggle.Value)
            Library:SafeCallback(Toggle.Changed, Toggle.Value)
        end

        function Toggle:SetValue(Value)
            Toggle.Value = Value
            Toggle:Display()

            for _, Addon in Toggle.Addons do
                if Addon.Type == "KeyPicker" and Addon.SyncToggleState then
                    Addon.Toggled = Toggle.Value
                    Addon:Update()
                end
            end

            if not Toggle.Disabled then
                Library:UpdateDependencyBoxes()
            end

            if not Toggle.AnyKeyPickerPicking then
                Toggle:RunChanged()
            end
        end

        function Toggle:SetDisabled(Disabled: boolean)
            Toggle.Disabled = Disabled

            if Toggle.TooltipTable then
                Toggle.TooltipTable.Disabled = Toggle.Disabled
            end

            Library:UpdateAddons(Toggle)

            Button.Active = not Toggle.Disabled
            Toggle:Display()

            Library:UpdateDependencyBoxes()
        end

        function Toggle:SetVisible(Visible: boolean)
            Toggle.Visible = Visible

            Button.Visible = Toggle.Visible
            Groupbox:Resize()
        end

        function Toggle:SetText(Text: string)
            Toggle.Text = Text
            Label.Text = Text
        end

        table.insert(Toggle.Connections, Button.MouseButton1Click:Connect(function()
            if Toggle.Disabled then
                return
            end

            Toggle:SetValue(not Toggle.Value)
        end))

        if typeof(Toggle.Tooltip) == "string" or typeof(Toggle.DisabledTooltip) == "string" then
            Toggle.TooltipTable = Library:AddTooltip(Toggle.Tooltip, Toggle.DisabledTooltip, Button)
            Toggle.TooltipTable.Disabled = Toggle.Disabled
        end

        if Toggle.Risky then
            Label.TextColor3 = Library.Scheme.RedColor
            Library.Registry[Label].TextColor3 = "RedColor"
        end

        Toggle:Display()
        Groupbox:Resize()

        Toggle.TextLabel = Label
        Toggle.Container = Container
        setmetatable(Toggle, BaseAddons)

        Toggle.Holder = Button
        table.insert(Groupbox.Elements, Toggle)

        Toggle.Default = Toggle.Value

        Toggles[Idx] = Toggle

        function Toggle:Destroy()
            Toggle.Destroyed = true

            if Toggle.Connections then
                for _, Connection in Toggle.Connections do
                    Connection:Disconnect()
                end
            end

            if Toggle.TooltipTable then
                Toggle.TooltipTable:Destroy()
            end

            if Button then
                Button:Destroy()
            end

            if Toggle.Addons then
                for Index = #Toggle.Addons, 1, -1 do
                    local Addon = table.remove(Toggle.Addons, Index)
                    if Addon and Addon.Destroy then
                        Addon:Destroy()
                    end
                end
            end

            local ElemIdx = table.find(Groupbox.Elements, Toggle)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Toggles[Idx] = nil
        end

        return Toggle
    end

    function Funcs:AddInput(Idx, Info)
        if self.Destroyed then return nil end

        if typeof(Info) == "table" and (typeof(Info.VerifyValue) == "function" and Info.Finished ~= true) then
            Info.Finished = true
        end

        Info = Library:Validate(Info, Templates.Input)

        local Groupbox = self
        local Container = Groupbox.Container

        local Input = {
            Connections = {},
            Destroyed = false,

            Text = Info.Text,
            Value = Info.Default,

            Finished = Info.Finished,
            Numeric = Info.Numeric,
            ClearTextOnFocus = Info.ClearTextOnFocus,
            ClearTextOnBlur = Info.ClearTextOnBlur,
            Placeholder = Info.Placeholder,
            AllowEmpty = Info.AllowEmpty,
            EmptyReset = Info.EmptyReset,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Callback = Info.Callback,
            Changed = Info.Changed,
            VerifyValue = Info.VerifyValue,

            Disabled = Info.Disabled,
            Visible = Info.Visible,

            Type = "Input",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 39),
            Visible = Input.Visible,
            Parent = Container,
        })

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 14),
            Text = Input.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Holder,
        })

        local Box = New("TextBox", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            ClearTextOnFocus = not Input.Disabled and Input.ClearTextOnFocus,
            PlaceholderText = Input.Placeholder,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 21),
            Text = Input.Value,
            TextEditable = not Input.Disabled,
            TextScaled = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 4),
            Parent = Box,
        })

        local BoxStroke = New("UIStroke", {
            Color = "OutlineColor",
            Parent = Box,
        })

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Box,
            })
        )

        function Input:UpdateColors()
            if Library.Unloaded then
                return
            end

            Label.TextTransparency = Input.Disabled and 0.8 or 0
            Box.TextTransparency = Input.Disabled and 0.8 or 0
            BoxStroke.Transparency = Input.Disabled and 0.5 or 0

            Box.BackgroundColor3 = Input.Disabled and Library.Scheme.BackgroundColor or Library.Scheme.MainColor
            Library.Registry[Box].BackgroundColor3 = Input.Disabled and "BackgroundColor" or "MainColor"
        end

        function Input:OnChanged(Func)
            Input.Changed = Func
        end

        function Input:RunChanged()
            if Input.Disabled then
                return
            end

            Library:SafeCallback(Input.Callback, Input.Value)
            Library:SafeCallback(Input.Changed, Input.Value)
        end

        function Input:SetValue(Text)
            if not Input.AllowEmpty and Trim(Text) == "" then
                Text = Input.EmptyReset
            end

            if Info.MaxLength and #Text > Info.MaxLength then
                Text = Text:sub(1, Info.MaxLength)
            end

            if Input.Numeric then
                if #tostring(Text) > 0 and not tonumber(Text) then
                    Text = Input.Value
                end
            end

            if typeof(Info.VerifyValue) == "function" and (Text ~= Input.EmptyReset and Info.VerifyValue(Text) ~= true) then
                Text = Input.EmptyReset
            end

            Input.Value = Text
            Box.Text = Text

            Input:RunChanged()
        end

        function Input:SetDisabled(Disabled: boolean)
            Input.Disabled = Disabled

            if Input.TooltipTable then
                Input.TooltipTable.Disabled = Input.Disabled
            end

            Box.ClearTextOnFocus = not Input.Disabled and Input.ClearTextOnFocus
            Box.TextEditable = not Input.Disabled
            Input:UpdateColors()
        end

        function Input:SetVisible(Visible: boolean)
            Input.Visible = Visible

            Holder.Visible = Input.Visible
            Groupbox:Resize()
        end

        function Input:SetText(Text: string)
            Input.Text = Text
            Label.Text = Text
        end

        if Input.Finished then
            table.insert(Input.Connections, Box.FocusLost:Connect(function()
                Input:SetValue(Box.Text)
            end))
        else
            table.insert(Input.Connections, Box:GetPropertyChangedSignal("Text"):Connect(function()
                if Box.Text == Input.Value then return end

                Input:SetValue(Box.Text)
            end))
        end

        table.insert(Input.Connections, Box.Focused:Connect(function()
            if Input.Disabled then
                return
            end

            Library.Registry[BoxStroke].Color = "AccentColor"
            TweenService:Create(BoxStroke, Library.TweenInfo, {
                Color = Library.Scheme.AccentColor,
            }):Play()
        end))

        table.insert(Input.Connections, Box.FocusLost:Connect(function()
            if Input.Disabled then
                return
            end

            Library.Registry[BoxStroke].Color = "OutlineColor"
            TweenService:Create(BoxStroke, Library.TweenInfo, {
                Color = Library.Scheme.OutlineColor,
            }):Play()
        end))

        if typeof(Input.Tooltip) == "string" or typeof(Input.DisabledTooltip) == "string" then
            Input.TooltipTable = Library:AddTooltip(Input.Tooltip, Input.DisabledTooltip, Box)
            Input.TooltipTable.Disabled = Input.Disabled
        end

        Groupbox:Resize()

        Input.Holder = Holder
        table.insert(Groupbox.Elements, Input)

        Input.Default = Input.Value
        if typeof(Info.VerifyValue) == "function" and (Input.Default ~= Input.EmptyReset and Info.VerifyValue(Input.Default) ~= true) then
            Input:SetValue(Input.EmptyReset)
            Input.Default = Input.EmptyReset
        end

        Input:UpdateColors()
        Options[Idx] = Input

        function Input:Destroy()
            Input.Destroyed = true

            if Input.Connections then
                for _, Connection in Input.Connections do
                    Connection:Disconnect()
                end
            end

            if Input.TooltipTable then
                Input.TooltipTable:Destroy()
            end

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Input)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Input
    end

    function Funcs:AddSlider(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.Slider)

        local Groupbox = self
        local Container = Groupbox.Container

        local Slider = {
            Connections = {},
            Destroyed = false,

            Text = Info.Text,
            Value = Info.Default,

            Min = Info.Min,
            Max = Info.Max,

            Prefix = Info.Prefix,
            Suffix = Info.Suffix,
            Compact = Info.Compact,
            Rounding = Info.Rounding,
            HideMax = Info.HideMax,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Callback = Info.Callback,
            Changed = Info.Changed,

            Disabled = Info.Disabled,
            Visible = Info.Visible,

            AllowRightClickInput = Info.AllowRightClickInput,

            Type = "Slider",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Info.Compact and 15 or 33),
            Visible = Slider.Visible,
            Parent = Container,
        })

        local SliderLabel
        if not Info.Compact then
            SliderLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 14),
                Text = Slider.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Holder,
            })
        end

        local Bar = New("TextButton", {
            Active = not Slider.Disabled,
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 15),
            Text = "",
            Parent = Holder,
        })

        New("UIStroke", {
            Color = "OutlineColor",
            Parent = Bar,
        })

        local DisplayLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = "",
            TextSize = 14,
            ZIndex = Bar.ZIndex + 2,
            Parent = Bar,
        })
        New("UIStroke", {
            ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
            Color = "DarkColor",
            LineJoinMode = Enum.LineJoinMode.Miter,
            Parent = DisplayLabel,
        })

        local InputTextBox
        local InputTextBoxStroke
        if Info.AllowRightClickInput then
            InputTextBox = New("TextBox", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = "",
                TextSize = 14,
                ZIndex = Bar.ZIndex + 3,
                Visible = false,
                ClearTextOnFocus = false,
                Parent = Bar,
            })
            InputTextBoxStroke = New("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                Color = "DarkColor",
                LineJoinMode = Enum.LineJoinMode.Miter,
                Parent = InputTextBox,
            })
        end

        local Fill = New("Frame", {
            BackgroundColor3 = "AccentColor",
            Size = UDim2.fromScale(0.5, 1),
            ZIndex = Bar.ZIndex + 1,
            Parent = Bar,
        })

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Bar,
            })
        )

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Fill,
            })
        )

        function Slider:UpdateColors()
            if Library.Unloaded then
                return
            end

            if SliderLabel then
                SliderLabel.TextTransparency = Slider.Disabled and 0.8 or 0
            end
            DisplayLabel.TextTransparency = Slider.Disabled and 0.8 or 0

            if Info.AllowRightClickInput then
                InputTextBox.TextTransparency = Slider.Disabled and 0.8 or 0
            end

            Fill.BackgroundColor3 = Slider.Disabled and Library.Scheme.OutlineColor or Library.Scheme.AccentColor
            Library.Registry[Fill].BackgroundColor3 = Slider.Disabled and "OutlineColor" or "AccentColor"
        end

        function Slider:Display()
            if Library.Unloaded then
                return
            end

            local CustomDisplayText = nil
            if Info.FormatDisplayValue then
                CustomDisplayText = Info.FormatDisplayValue(Slider, Slider.Value)
            end

            if CustomDisplayText then
                DisplayLabel.Text = tostring(CustomDisplayText)
            else
                if Info.Compact then
                    DisplayLabel.Text =
                        string.format("%s: %s%s%s", Slider.Text, Slider.Prefix, Slider.Value, Slider.Suffix)
                elseif Info.HideMax then
                    DisplayLabel.Text = string.format("%s%s%s", Slider.Prefix, Slider.Value, Slider.Suffix)
                else
                    DisplayLabel.Text = string.format(
                        "%s%s%s/%s%s%s",
                        Slider.Prefix,
                        Slider.Value,
                        Slider.Suffix,
                        Slider.Prefix,
                        Slider.Max,
                        Slider.Suffix
                    )
                end
            end

            local X = (Slider.Value - Slider.Min) / (Slider.Max - Slider.Min)
            Fill.Size = UDim2.fromScale(X, 1)
        end

        function Slider:OnChanged(Func)
            Slider.Changed = Func
        end

        function Slider:SetMax(Value)
            assert(Value > Slider.Min, "Max value cannot be less than the current min value.")

            Slider:SetValue(math.clamp(Slider.Value, Slider.Min, Value))
            Slider.Max = Value
            Slider:Display()
        end

        function Slider:SetMin(Value)
            assert(Value < Slider.Max, "Min value cannot be greater than the current max value.")

            Slider:SetValue(math.clamp(Slider.Value, Value, Slider.Max))
            Slider.Min = Value
            Slider:Display()
        end

        function Slider:RunChanged()
            if Slider.Disabled then
                return
            end

            Library:SafeCallback(Slider.Callback, Slider.Value)
            Library:SafeCallback(Slider.Changed, Slider.Value)
        end

        function Slider:SetValue(Str)
            local Num = tonumber(Str)
            if not Num or Num == Slider.Value then
                return
            end

            Num = math.clamp(Num, Slider.Min, Slider.Max)

            Slider.Value = Num
            Slider:Display()

            Slider:RunChanged()
        end

        function Slider:SetDisabled(Disabled: boolean)
            Slider.Disabled = Disabled

            if Slider.TooltipTable then
                Slider.TooltipTable.Disabled = Slider.Disabled
            end

            Bar.Active = not Slider.Disabled
            Slider:UpdateColors()
        end

        function Slider:SetVisible(Visible: boolean)
            Slider.Visible = Visible

            Holder.Visible = Slider.Visible
            Groupbox:Resize()
        end

        function Slider:SetText(Text: string)
            Slider.Text = Text
            if SliderLabel then
                SliderLabel.Text = Text
                return
            end
            Slider:Display()
        end

        function Slider:SetPrefix(Prefix: string)
            Slider.Prefix = Prefix
            Slider:Display()
        end

        function Slider:SetSuffix(Suffix: string)
            Slider.Suffix = Suffix
            Slider:Display()
        end

        if Info.AllowRightClickInput then
            local LastValidText = ""
            table.insert(Slider.Connections, InputTextBox:GetPropertyChangedSignal("Text"):Connect(function()
                local Text = InputTextBox.Text
                local AsNum = tonumber(Text)

                if #tostring(Text) > 0 and not AsNum and Text ~= "-" then
                    InputTextBox.Text = LastValidText
                else
                    if Slider.Rounding == 0 and Text:find("%.") then
                        InputTextBox.Text = LastValidText
                        return
                    end

                    local DecimalPos = Text:find("%.")
                    if DecimalPos and Slider.Rounding > 0 then
                        local Decimals = #Text - DecimalPos
                        if Decimals > Slider.Rounding then
                            InputTextBox.Text = LastValidText
                            return
                        end
                    end

                    LastValidText = Text

                    if AsNum then
                        if AsNum > Slider.Max then
                            InputTextBox.Text = tostring(Slider.Max)
                        elseif AsNum < Slider.Min then
                            InputTextBox.Text = tostring(Slider.Min)
                        end
                    end
                end
            end))

            table.insert(Slider.Connections, InputTextBox.FocusLost:Connect(function()
                InputTextBox.Visible = false
                DisplayLabel.Visible = true

                local Num = tonumber(InputTextBox.Text)
                if not Num then
                    return
                end

                Num = Round(Num, Slider.Rounding)
                Slider:SetValue(Num)
            end))

            table.insert(Slider.Connections, InputTextBox.Focused:Connect(function()
                if Slider.Disabled then
                    return
                end

                Library.Registry[InputTextBoxStroke].Color = "AccentColor"
                TweenService:Create(InputTextBoxStroke, Library.TweenInfo, {
                    Color = Library.Scheme.AccentColor,
                }):Play()
            end))

            table.insert(Slider.Connections, InputTextBox.FocusLost:Connect(function()
                if Slider.Disabled then
                    return
                end

                Library.Registry[InputTextBoxStroke].Color = "DarkColor"
                TweenService:Create(InputTextBoxStroke, Library.TweenInfo, {
                    Color = Library.Scheme.DarkColor,
                }):Play()
            end))
        end

        local LastTap = 0
        table.insert(Slider.Connections, Bar.InputBegan:Connect(function(Input: InputObject)
            local ValidInput = IsClickInput(Input) or Input.UserInputType == Enum.UserInputType.MouseButton2
            if not ValidInput or Slider.Disabled then
                return
            end

            if Info.AllowRightClickInput then
                local IsRightClick = Input.UserInputType == Enum.UserInputType.MouseButton2
                local IsDoubleTap = false

                if Library.IsMobile and Input.UserInputType == Enum.UserInputType.Touch then
                    if tick() - LastTap < 0.3 then
                        IsDoubleTap = true
                    end

                    LastTap = tick()
                end

                if IsRightClick or IsDoubleTap then
                    InputTextBox.Text = tostring(Slider.Value)
                    InputTextBox.Visible = true
                    DisplayLabel.Visible = false

                    task.spawn(InputTextBox.CaptureFocus, InputTextBox)
                    return
                end
            end

            if not IsClickInput(Input) then
                return
            end

            if Library.ActiveTab then
                for _, Side in Library.ActiveTab.Sides do
                    Side.ScrollingEnabled = false
                end
            end

            if Library.ActiveLoading and Library.ActiveLoading.Sidebar then
                Library.ActiveLoading.Sidebar.Container.ScrollingEnabled = false
            end

            while IsDragInput(Input) and not Slider.Destroyed do
                local Location = Mouse.X
                local Scale = math.clamp((Location - Bar.AbsolutePosition.X) / Bar.AbsoluteSize.X, 0, 1)

                local OldValue = Slider.Value
                Slider.Value = Round(Slider.Min + ((Slider.Max - Slider.Min) * Scale), Slider.Rounding)

                Slider:Display()
                if Slider.Value ~= OldValue then
                    Slider:RunChanged()
                end

                RunService.RenderStepped:Wait()
            end

            if Library.ActiveTab then
                for _, Side in Library.ActiveTab.Sides do
                    Side.ScrollingEnabled = true
                end
            end

            if Library.ActiveLoading and Library.ActiveLoading.Sidebar then
                Library.ActiveLoading.Sidebar.Container.ScrollingEnabled = true
            end
        end))

        if typeof(Slider.Tooltip) == "string" or typeof(Slider.DisabledTooltip) == "string" then
            Slider.TooltipTable = Library:AddTooltip(Slider.Tooltip, Slider.DisabledTooltip, Bar)
            Slider.TooltipTable.Disabled = Slider.Disabled
        end

        Slider:UpdateColors()
        Slider:Display()
        Groupbox:Resize()

        Slider.Holder = Holder
        table.insert(Groupbox.Elements, Slider)

        Slider.Default = Slider.Value

        Options[Idx] = Slider

        function Slider:Destroy()
            Slider.Destroyed = true

            if Slider.Connections then
                for _, Connection in Slider.Connections do
                    Connection:Disconnect()
                end
            end

            if Slider.TooltipTable then
                Slider.TooltipTable:Destroy()
            end

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Slider)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Slider
    end

    function Funcs:AddDropdown(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.Dropdown)

        local Groupbox = self
        local Container = Groupbox.Container

        if Info.SpecialType == "Player" then
            Info.Values = GetPlayers(Info.ExcludeLocalPlayer)
            Info.AllowNull = true
        elseif Info.SpecialType == "Team" then
            Info.Values = GetTeams()
            Info.AllowNull = true
        end

        local Dropdown = {
            Connections = {},
            Destroyed = false,

            Text = typeof(Info.Text) == "string" and Info.Text or nil,

            Value = Info.Multi and {} or nil,
            Values = Info.Values,
            DisabledValues = Info.DisabledValues,
            ValueImages = Info.ValueImages,

            Multi = Info.Multi,
            DragSelect = Info.Multi and not Library.IsMobile and Info.DragSelect == true,
            KeepDisabledValuePosition = Info.KeepDisabledValuePosition == true,

            SpecialType = Info.SpecialType,
            ExcludeLocalPlayer = Info.ExcludeLocalPlayer,
            EnablePlayerImages = Info.EnablePlayerImages,

            Tooltip = Info.Tooltip,
            DisabledTooltip = Info.DisabledTooltip,
            TooltipTable = nil,

            Callback = Info.Callback,
            Changed = Info.Changed,

            Disabled = Info.Disabled,
            Visible = Info.Visible,

            Type = "Dropdown",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Dropdown.Text and 39 or 21),
            Visible = Dropdown.Visible,
            Parent = Container,
        })

        local Label = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 14),
            Text = Dropdown.Text,
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            Visible = not not Info.Text,
            ZIndex = 3,
            Parent = Holder,
        })

        local DisplayContainer = New("TextButton", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 21),
            Text = "",
            TextTransparency = 1,
            ZIndex = 2,
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 4),
            Parent = DisplayContainer,
        })

        local DisplayStroke = New("UIStroke", {
            Color = "OutlineColor",
            Parent = DisplayContainer,
        })

        local DropdownCorner = New("UICorner", {
            TopLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            TopRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomRightRadius = UDim.new(0, Library.CornerRadius / 2),
            BottomLeftRadius = UDim.new(0, Library.CornerRadius / 2),
            Parent = DisplayContainer,
        }); table.insert(Library.SpecificCorners, DropdownCorner)

        local DisplayImage = New("ImageLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(-4, 3),
            Size = UDim2.fromOffset(16, 16),
            Image = "",
            ImageTransparency = 1,
            ZIndex = 2,
            Parent = DisplayContainer,
        })

        local DisplayButton = New("TextButton", {
            Active = not Dropdown.Disabled,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 21),
            Text = "---",
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 2,
            Parent = DisplayContainer,
        })

        local ArrowImage = New("ImageLabel", {
            AnchorPoint = Vector2.new(1, 0.5),
            ImageColor3 = "FontColor",
            ImageTransparency = 0.5,
            Position = UDim2.fromScale(1, 0.5),
            Size = UDim2.fromOffset(16, 16),
            Parent = DisplayContainer,
        })
        if ArrowIcon then
            Library:ApplyLucideIcon(ArrowImage, ArrowIcon)
        end

        local SearchBox
        if Info.Searchable then
            SearchBox = New("TextBox", {
                BackgroundTransparency = 1,
                PlaceholderText = "Search...",
                Position = UDim2.fromOffset(-8, 0),
                Size = UDim2.new(1, -12, 1, 0),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Visible = false,
                Parent = DisplayButton,
            })
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 8),
                Parent = SearchBox,
            })

            table.insert(Dropdown.Connections, SearchBox.Focused:Connect(function()
                Library.Registry[DisplayStroke].Color = "AccentColor"
                TweenService:Create(DisplayStroke, Library.TweenInfo, {
                    Color = Library.Scheme.AccentColor,
                }):Play()
            end))

            table.insert(Dropdown.Connections, SearchBox.FocusLost:Connect(function()
                Library.Registry[DisplayStroke].Color = "OutlineColor"
                TweenService:Create(DisplayStroke, Library.TweenInfo, {
                    Color = Library.Scheme.OutlineColor,
                }):Play()
            end))
        end

        local GetValueImage = function(Value, RawValue)
            if not Value then
                return nil
            end

            local ValueImage = nil
            if Dropdown.SpecialType == "Player" and Dropdown.EnablePlayerImages == true then
                local PlayerValue = Value
                if typeof(PlayerValue) ~= "Instance" and RawValue ~= nil then
                    PlayerValue = RawValue
                end

                if typeof(PlayerValue) == "Instance" and PlayerValue:IsA("Player") then
                    ValueImage = { Url = string.format("rbxthumb://type=AvatarHeadShot&id=%s&w=48&h=48", tostring(PlayerValue.UserId)) }
                end
            end

            if Dropdown.ValueImages then
                local IconRef = Dropdown.ValueImages[Value]
                if IconRef == nil and RawValue ~= nil then
                    IconRef = Dropdown.ValueImages[RawValue]
                end

                if IconRef then
                    ValueImage = Library:GetCustomIcon(IconRef)
                end
            end

            return ValueImage
        end

        local MenuTable
        MenuTable = Library:AddContextMenu(
            DisplayContainer,
            function()
                return UDim2.fromOffset((DisplayContainer.AbsoluteSize.X / Library.DPIScale), 0)
            end,
            function()
                return { 0.5, DisplayContainer.AbsoluteSize.Y + 1.5 }
            end,
            2,
            function(Active: boolean)
                DisplayButton.TextTransparency = (Active and SearchBox) and 1 or 0

                ArrowImage.ImageTransparency = Active and 0 or 0.5
                ArrowImage.Rotation = Active and 180 or 0

                if SearchBox then
                    SearchBox.Text = ""
                    SearchBox.Visible = Active
                end

                local Half = UDim.new(0, Library.CornerRadius / 2)
                local Zero = UDim.new(0, 0)

                DropdownCorner.TopLeftRadius = Half
                DropdownCorner.TopRightRadius = Half
                DropdownCorner.BottomRightRadius = Active and Zero or Half
                DropdownCorner.BottomLeftRadius = Active and Zero or Half

                local MenuCorner = MenuTable and MenuTable.Corner
                if MenuCorner then
                    MenuCorner.TopLeftRadius = Zero
                    MenuCorner.TopRightRadius = Zero
                    MenuCorner.BottomRightRadius = Half
                    MenuCorner.BottomLeftRadius = Half
                end
            end,
            false,
            "bottom",
            "Dropdown"
        )
        Dropdown.Menu = MenuTable

        local ItemHeight = 21
        local PoolSize = math.max(1, Info.MaxVisibleDropdownItems + 2)
        local Pool = {}
        local FilteredEntries = {}

        function Dropdown:RecalculateListSize(Count)
            local ItemCount = Count or #FilteredEntries
            local Y = math.clamp(ItemCount * ItemHeight, 0, Info.MaxVisibleDropdownItems * ItemHeight)

            MenuTable.Menu.CanvasSize = UDim2.fromOffset(0, ItemCount * ItemHeight)

            MenuTable:SetSize(function()
                return UDim2.fromOffset((DisplayContainer.AbsoluteSize.X / Library.DPIScale), Y)
            end)
        end

        function Dropdown:UpdateColors()
            if Library.Unloaded then
                return
            end

            Label.TextTransparency = Dropdown.Disabled and 0.8 or 0
            DisplayButton.TextTransparency = Dropdown.Disabled and 0.8 or 0
            DisplayImage.ImageTransparency = Dropdown.Disabled and 0.8 or 0
            ArrowImage.ImageTransparency = Dropdown.Disabled and 0.8 or MenuTable.Active and 0 or 0.5
        end

        function Dropdown:Display()
            if Library.Unloaded then
                return
            end

            local Str = ""
            local ValueImage = nil
            local IsDictionary = not IsSequentialArray(Dropdown.Values)

            if Info.Multi then
                for Key, RawValue in Dropdown.Values do
                    local Value = IsDictionary and Key or RawValue

                    if Dropdown.Value[Value] then
                        if not ValueImage then
                            ValueImage = GetValueImage(Value, RawValue)
                        end

                        Str = Str
                            .. (Info.FormatDisplayValue and tostring(Info.FormatDisplayValue(RawValue)) or tostring(RawValue))
                            .. ", "
                    end
                end

                Str = Str:sub(1, #Str - 2)
            else
                local DisplayValue = Dropdown.Value
                if IsDictionary and Dropdown.Value ~= nil then
                    DisplayValue = Dropdown.Values[Dropdown.Value]
                end

                ValueImage = GetValueImage(Dropdown.Value, DisplayValue)
                Str = DisplayValue and tostring(DisplayValue) or ""

                if Str ~= "" and Info.FormatDisplayValue then
                    Str = tostring(Info.FormatDisplayValue(Str))
                end
            end

            if #Str > 25 then
                Str = Str:sub(1, 22) .. "..."
            end

            DisplayButton.Text = (Str == "" and "---" or Str)

            if ValueImage then
                Library:ApplyLucideIcon(DisplayImage, ValueImage)
                DisplayImage.ImageTransparency = 0
            else
                DisplayImage.Image = ""
                DisplayImage.ImageTransparency = 1
            end

            DisplayButton.Size = ValueImage and UDim2.new(1, -8, 0, 21) or UDim2.new(1, 0, 0, 21)
            DisplayButton.Position = ValueImage and UDim2.fromOffset(14, 0) or UDim2.fromOffset(0, 0)
        end

        function Dropdown:OnChanged(Func)
            Dropdown.Changed = Func
        end

        function Dropdown:GetActiveValues(ReturnCount)
            local Table = {}

            if Info.Multi then
                for Value, _ in Dropdown.Value do
                    table.insert(Table, Value)
                end
            else
                if Dropdown.Value then
                    table.insert(Table, Dropdown.Value)
                end
            end

            return ReturnCount == true and GetTableSize(Table) or Table
        end

        local DragSelecting = false
        local DragStartIndex = nil
        local DragPrevMin = nil
        local DragPrevMax = nil
        local DragLastIndex = nil
        local DragInitialValues = {}
        local DragInputEndedConn = nil
        local DragInputChangedConn = nil

        local function RecomputeFilteredEntries()
            local Values = Dropdown.Values
            local DisabledValues = Dropdown.DisabledValues
            local IsDictionary = not IsSequentialArray(Values)

            --// Fuzzy-match dropdown values the same way the sidebar search
            --// does, so e.g. "clr" can find "Clear Inventory" in a list \\--
            local SearchQuery = SearchBox and NormalizeSearch(SearchBox.Text:lower()) or ""
            local IsSearching = SearchQuery ~= ""

            local EnabledList, DisabledList = {}, {}
            local Pending = {}

            for Key, RawValue in Values do
                local Value = IsDictionary and Key or RawValue

                local FormattedValue = tostring(Info.FormatListValue and Info.FormatListValue(RawValue) or RawValue)

                local MatchScore = 0
                if IsSearching then
                    local Matched, Score = FuzzyScore(FormattedValue:lower(), SearchQuery)
                    if not Matched then
                        continue
                    end
                    MatchScore = Score
                end

                local IsDisabled = table.find(DisabledValues, Value) ~= nil
                    or (RawValue ~= nil and RawValue ~= Value and table.find(DisabledValues, RawValue) ~= nil)

                local Entry = {
                    Value = Value,
                    RawValue = RawValue,
                    FormattedValue = FormattedValue,
                    IsDisabled = IsDisabled,
                    ValueImage = GetValueImage(Value, RawValue),
                    SortKey = Key,
                    MatchScore = MatchScore,
                    Order = #Pending + 1,
                }

                table.insert(Pending, Entry)
            end

            if IsSearching then
                --// Best matches first; ties fall back to original order \\--
                table.sort(Pending, function(A, B)
                    if A.MatchScore ~= B.MatchScore then
                        return A.MatchScore > B.MatchScore
                    end
                    return A.Order < B.Order
                end)
            elseif not IsDictionary then
                table.sort(Pending, function(A, B)
                    return A.SortKey < B.SortKey
                end)
            end

            table.clear(FilteredEntries)

            --// Multi dropdowns get a Select All / Deselect All row on top,
            --// acting on whatever enabled values the search currently shows \\--
            if Info.Multi and Info.SelectAll ~= false then
                for _, Entry in Pending do
                    if not Entry.IsDisabled then
                        table.insert(FilteredEntries, { IsToggleAll = true, FormattedValue = "Select All" })
                        break
                    end
                end
            end

            if Dropdown.KeepDisabledValuePosition then
                for _, Entry in Pending do
                    table.insert(FilteredEntries, Entry)
                end
                return
            end

            for _, Entry in Pending do
                if Entry.IsDisabled then
                    table.insert(DisabledList, Entry)
                else
                    table.insert(EnabledList, Entry)
                end
            end

            for _, Entry in EnabledList do
                table.insert(FilteredEntries, Entry)
            end
            for _, Entry in DisabledList do
                table.insert(FilteredEntries, Entry)
            end
        end

        local function GetFirstVisibleIndex()
            local Total = #FilteredEntries
            if Total <= PoolSize then
                return 1
            end

            local MaxFirst = Total - PoolSize + 1
            local ScrollY = MenuTable.Menu.CanvasPosition.Y / Library.DPIScale
            local Index = math.floor(ScrollY / ItemHeight) + 1
            return math.clamp(Index, 1, MaxFirst)
        end

        function Dropdown:RefreshPool()
            local Total = #FilteredEntries
            local First = GetFirstVisibleIndex()

            for SlotIndex, Row in Pool do
                local DataIndex = First + SlotIndex - 1
                local Entry = FilteredEntries[DataIndex]

                Row.Entry = Entry
                Row.Index = Entry and DataIndex or nil

                if not Entry then
                    Row.Container.Visible = false
                    continue
                end

                Row.Container.Visible = true
                Row.Container.Position = UDim2.fromOffset(0, (DataIndex - 1) * ItemHeight)

                local IsLast = DataIndex == Total
                Row.Corner.BottomRightRadius = IsLast and UDim.new(0, Library.CornerRadius / 2) or UDim.new(0, 0)
                Row.Corner.BottomLeftRadius = IsLast and UDim.new(0, Library.CornerRadius / 2) or UDim.new(0, 0)

                Row.Button.Text = Entry.FormattedValue

                if Entry.ValueImage then
                    Row.Image.Visible = true
                    Library:ApplyLucideIcon(Row.Image, Entry.ValueImage)
                    Row.Button.Size = UDim2.new(1, -18, 0, ItemHeight)
                    Row.Button.Position = UDim2.fromOffset(18, 0)
                else
                    Row.Image.Visible = false
                    Row.Button.Size = UDim2.new(1, 0, 0, ItemHeight)
                    Row.Button.Position = UDim2.fromOffset(0, 0)
                end

                Row:UpdateButton()
            end
        end

        function Dropdown:RunChanged()
            if Dropdown.Disabled then
                return
            end

            Library:SafeCallback(Dropdown.Callback, Dropdown.Value)
            Library:SafeCallback(Dropdown.Changed, Dropdown.Value)
        end

        local function StopDragSelect()
            DragSelecting = false
            DragStartIndex = nil
            DragPrevMin = nil
            DragPrevMax = nil
            DragLastIndex = nil
            table.clear(DragInitialValues)

            if DragInputEndedConn then
                DragInputEndedConn:Disconnect()
                DragInputEndedConn = nil
            end

            if DragInputChangedConn then
                DragInputChangedConn:Disconnect()
                DragInputChangedConn = nil
            end
        end

        local function AllShownSelected()
            local Any = false
            for _, Entry in FilteredEntries do
                if not Entry.IsToggleAll and not Entry.IsDisabled then
                    if not Dropdown.Value[Entry.Value] then
                        return false
                    end
                    Any = true
                end
            end
            return Any
        end

        local function ToggleAllShown()
            local Select = not AllShownSelected()

            for _, Entry in FilteredEntries do
                if not Entry.IsToggleAll and not Entry.IsDisabled then
                    Dropdown.Value[Entry.Value] = Select or nil
                end
            end

            --// Without AllowNull, keep the first shown value selected \\--
            if not Select and not Info.AllowNull and next(Dropdown.Value) == nil then
                for _, Entry in FilteredEntries do
                    if not Entry.IsToggleAll and not Entry.IsDisabled then
                        Dropdown.Value[Entry.Value] = true
                        break
                    end
                end
            end
        end

        local DragActiveCount = 0

        local function ApplyDragIndex(Index, InRange)
            local Entry = FilteredEntries[Index]
            if not Entry or Entry.IsDisabled or Entry.IsToggleAll then
                return
            end

            local Try = DragInitialValues[Entry.Value]
            if InRange then
                Try = not Try
            end

            local WantActive = Try and true or false
            local IsActive = Dropdown.Value[Entry.Value] and true or false
            if WantActive == IsActive then
                return
            end

            if not WantActive and DragActiveCount == 1 and not Info.AllowNull then
                return
            end

            Dropdown.Value[Entry.Value] = WantActive and true or nil
            DragActiveCount += WantActive and 1 or -1
        end

        local function ApplyDragRange(From, To, InRange)
            for Index = From, To do
                ApplyDragIndex(Index, InRange)
            end
        end

        local function UpdateDrag(CurrentIndex)
            if CurrentIndex == nil or CurrentIndex == DragLastIndex then
                return
            end

            DragLastIndex = CurrentIndex

            local Min = math.min(DragStartIndex, CurrentIndex)
            local Max = math.max(DragStartIndex, CurrentIndex)
            DragActiveCount = Dropdown:GetActiveValues(true)

            if DragPrevMin == nil then
                ApplyDragRange(Min, Max, true)
            else
                if DragPrevMin < Min then
                    ApplyDragRange(DragPrevMin, Min - 1, false)
                end
                if DragPrevMax > Max then
                    ApplyDragRange(Max + 1, DragPrevMax, false)
                end
                if Min < DragPrevMin then
                    ApplyDragRange(Min, DragPrevMin - 1, true)
                end
                if Max > DragPrevMax then
                    ApplyDragRange(DragPrevMax + 1, Max, true)
                end
            end

            DragPrevMin = Min
            DragPrevMax = Max

            for _, OtherRow in Pool do
                OtherRow:UpdateButton()
            end
        end

        local function CreatePoolRow()
            local Row = {
                Entry = nil,
                Index = nil
            }

            local Container = New("Frame", {
                BackgroundColor3 = "MainColor",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, ItemHeight),
                Visible = false,
                Parent = MenuTable.Menu,
            })

            local Corner = New("UICorner", {
                TopLeftRadius = UDim.new(0, 0),
                TopRightRadius = UDim.new(0, 0),
                BottomRightRadius = UDim.new(0, 0),
                BottomLeftRadius = UDim.new(0, 0),
                Parent = Container,
            }); table.insert(Library.SpecificCorners, Corner)

            local Image = New("ImageLabel", {
                BackgroundTransparency = 1,
                Image = "",
                ImageTransparency = 0.5,
                Size = UDim2.fromOffset(16, 16),
                Position = UDim2.fromOffset(4, 3),
                Visible = false,
                Parent = Container,
            })

            local Button = New("TextButton", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, ItemHeight),
                Text = "",
                TextSize = 14,
                TextTransparency = 0.5,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Container,
            })
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 7),
                PaddingRight = UDim.new(0, 7),
                Parent = Button,
            })

            Row.Container = Container
            Row.Corner = Corner
            Row.Image = Image
            Row.Button = Button

            function Row:UpdateButton()
                local Entry = Row.Entry
                if not Entry then
                    return
                end

                if Entry.IsToggleAll then
                    Button.Text = AllShownSelected() and "Deselect All" or "Select All"
                    Row.Selected = false
                    Container.BackgroundTransparency = 1
                    Button.TextTransparency = 0.5
                    return
                end

                local Selected
                if Info.Multi then
                    Selected = Dropdown.Value[Entry.Value]
                else
                    Selected = Dropdown.Value == Entry.Value
                end

                Row.Selected = Selected and true or false

                Container.BackgroundTransparency = Selected and 0 or 1
                Button.TextTransparency = Entry.IsDisabled and 0.8 or Selected and 0 or 0.5

                if Entry.ValueImage then
                    Image.ImageTransparency = Entry.IsDisabled and 0.8 or Selected and 0 or 0.5
                end
            end

            table.insert(Dropdown.Connections, Button.MouseButton1Click:Connect(function()
                local Entry = Row.Entry
                if not Entry or Entry.IsDisabled or DragSelecting then
                    return
                end

                if Entry.IsToggleAll then
                    ToggleAllShown()

                    for _, OtherRow in Pool do
                        OtherRow:UpdateButton()
                    end
                    Dropdown:Display()

                    Library:UpdateDependencyBoxes()
                    Dropdown:RunChanged()
                    return
                end

                local Selected
                if Info.Multi then
                    Selected = Dropdown.Value[Entry.Value]
                else
                    Selected = Dropdown.Value == Entry.Value
                end

                local Try = not Selected
                if not (Dropdown:GetActiveValues(true) == 1 and not Try and not Info.AllowNull) then
                    Selected = Try
                    if Info.Multi then
                        Dropdown.Value[Entry.Value] = Selected and true or nil
                    else
                        Dropdown.Value = Selected and Entry.Value or nil
                    end

                    for _, OtherRow in Pool do
                        OtherRow:UpdateButton()
                    end
                end

                Row:UpdateButton()
                Dropdown:Display()

                Library:UpdateDependencyBoxes()
                Dropdown:RunChanged()
            end))

            table.insert(Dropdown.Connections, Button.MouseEnter:Connect(function()
                local Entry = Row.Entry
                if not Entry or Entry.IsDisabled then
                    return
                end

                if Row.Selected then
                    return
                end

                TweenService:Create(Container, Library.TweenInfo, {
                    BackgroundTransparency = 0.85,
                }):Play()
                TweenService:Create(Button, Library.TweenInfo, {
                    TextTransparency = 0.25,
                }):Play()

                if Image then
                    TweenService:Create(Image, Library.TweenInfo, {
                        ImageTransparency = 0.25,
                    }):Play()
                end
            end))

            table.insert(Dropdown.Connections, Button.MouseLeave:Connect(function()
                local Entry = Row.Entry
                if not Entry or Entry.IsDisabled then
                    return
                end

                if Row.Selected then
                    return
                end

                TweenService:Create(Container, Library.TweenInfo, {
                    BackgroundTransparency = 1,
                }):Play()
                TweenService:Create(Button, Library.TweenInfo, {
                    TextTransparency = 0.5,
                }):Play()

                if Image then
                    TweenService:Create(Image, Library.TweenInfo, {
                        ImageTransparency = 0.5,
                    }):Play()
                end
            end))

            table.insert(Dropdown.Connections, Button.InputBegan:Connect(function(StartInput)
                if not (Info.Multi and Dropdown.DragSelect and not Library.IsMobile) then
                    return
                end

                local Entry = Row.Entry
                if not Entry or Entry.IsDisabled or Entry.IsToggleAll then
                    return
                end

                if not IsMouseInput(StartInput) then
                    return
                end

                DragSelecting = true
                DragStartIndex = Row.Index
                table.clear(DragInitialValues)

                for _, FilteredEntry in FilteredEntries do
                    if FilteredEntry.IsToggleAll then
                        continue
                    end
                    DragInitialValues[FilteredEntry.Value] = Dropdown.Value[FilteredEntry.Value]
                end

                UpdateDrag(Row.Index)

                if DragInputEndedConn then DragInputEndedConn:Disconnect() end
                if DragInputChangedConn then DragInputChangedConn:Disconnect() end

                DragInputChangedConn = Library:GiveSignal(UserInputService.InputChanged:Connect(function(ChangeInput)
                    if not IsMovementInput(ChangeInput) and ChangeInput ~= StartInput then
                        return
                    end

                    local Pos = ChangeInput.Position
                    for _, OtherRow in Pool do
                        if OtherRow.Entry and Library:MouseIsOverFrame(OtherRow.Button, Pos) then
                            UpdateDrag(OtherRow.Index)
                            break
                        end
                    end
                end))

                DragInputEndedConn = Library:GiveSignal(UserInputService.InputEnded:Connect(function(EndInput)
                    if EndInput ~= StartInput and not (IsMouseInput(EndInput) and EndInput.UserInputType == StartInput.UserInputType) then
                        return
                    end

                    Dropdown:Display()
                    Library:UpdateDependencyBoxes()
                    Dropdown:RunChanged()

                    StopDragSelect()
                end))

                table.insert(Dropdown.Connections, DragInputEndedConn)
                table.insert(Dropdown.Connections, DragInputChangedConn)
            end))

            return Row
        end

        function Dropdown:BuildDropdownList()
            StopDragSelect()

            RecomputeFilteredEntries()

            MenuTable.Menu.CanvasPosition = Vector2.new(0, 0)

            Dropdown:RefreshPool()
            Dropdown:RecalculateListSize(#FilteredEntries)
        end

        for _ = 1, PoolSize do
            table.insert(Pool, CreatePoolRow())
        end

        table.insert(Dropdown.Connections, MenuTable.Menu:GetPropertyChangedSignal("CanvasPosition"):Connect(function()
            Dropdown:RefreshPool()
        end))

        local function ValueExists(Val)
            if IsSequentialArray(Dropdown.Values) then
                for _, Existing in Dropdown.Values do
                    if Existing == Val then
                        return true
                    end
                end

                return false
            end

            return Dropdown.Values[Val] ~= nil
        end

        function Dropdown:SetValue(Value)
            if Info.Multi then
                if typeof(Value) == "string" then
                    Value = if Value == "" then {} else { [Value] = true }
                end

                local Table = {}

                for Val, Active in Value or {} do
                    if typeof(Active) ~= "boolean" then
                        Table[Active] = true
                    elseif Active and ValueExists(Val) then
                        Table[Val] = true
                    end
                end

                Dropdown.Value = Table
            else
                if ValueExists(Value) then
                    Dropdown.Value = Value
                elseif not Value then
                    Dropdown.Value = nil
                end
            end

            Dropdown:Display()
            for _, Row in Pool do
                Row:UpdateButton()
            end

            if not Dropdown.Disabled then
                Library:UpdateDependencyBoxes()
            end

            Dropdown:RunChanged()
        end

        function Dropdown:SetValues(Values)
            Dropdown.Values = Values

            local Changed = false
            if Info.Multi then
                for Val in Dropdown.Value do
                    if not ValueExists(Val) then
                        Dropdown.Value[Val] = nil
                        Changed = true
                    end
                end

            elseif Dropdown.Value ~= nil and not ValueExists(Dropdown.Value) then
                Dropdown.Value = nil
                Changed = true
            end

            Dropdown:BuildDropdownList()
            Dropdown:Display()

            if Changed and not Dropdown.Disabled then
                Library:UpdateDependencyBoxes()
            end

            if Changed then
                Dropdown:RunChanged()
            end
        end

        function Dropdown:AddValues(Values)
            if typeof(Values) ~= "table" and typeof(Values) ~= "string" then
                return
            end

            local IsDictionary = not IsSequentialArray(Dropdown.Values)
            if IsDictionary then
                if typeof(Values) == "string" then
                    Dropdown.Values[Values] = Values

                elseif IsSequentialArray(Values) then
                    for _, Val in Values do
                        Dropdown.Values[Val] = Val
                    end

                else
                    for Key, Val in Values do
                        Dropdown.Values[Key] = Val
                    end
                end
            else
                if typeof(Values) == "table" then
                    for _, Val in Values do
                        table.insert(Dropdown.Values, Val)
                    end
                else
                    table.insert(Dropdown.Values, Values)
                end
            end

            Dropdown:BuildDropdownList()
        end

        function Dropdown:SetDisabledValues(DisabledValues)
            Dropdown.DisabledValues = DisabledValues
            Dropdown:BuildDropdownList()
        end

        function Dropdown:AddDisabledValues(DisabledValues)
            if typeof(DisabledValues) == "table" then
                for _, val in DisabledValues do
                    table.insert(Dropdown.DisabledValues, val)
                end
            elseif typeof(DisabledValues) == "string" then
                table.insert(Dropdown.DisabledValues, DisabledValues)
            else
                return
            end

            Dropdown:BuildDropdownList()
        end

        function Dropdown:SetValueImages(ValueImages)
            if typeof(ValueImages) ~= "table" then
                return
            end

            Dropdown.ValueImages = ValueImages
            Dropdown:BuildDropdownList()
        end

        function Dropdown:AddValueImages(ValueImages)
            if typeof(ValueImages) ~= "table" then
                return
            end

            for key, val in ValueImages do
                Dropdown.ValueImages[key] = val
            end

            Dropdown:BuildDropdownList()
        end

        function Dropdown:SetDisabled(Disabled: boolean)
            Dropdown.Disabled = Disabled

            if Dropdown.TooltipTable then
                Dropdown.TooltipTable.Disabled = Dropdown.Disabled
            end

            MenuTable:Close()
            DisplayButton.Active = not Dropdown.Disabled
            Dropdown:UpdateColors()

            Library:UpdateDependencyBoxes()
        end

        function Dropdown:SetVisible(Visible: boolean)
            Dropdown.Visible = Visible

            Holder.Visible = Dropdown.Visible
            Groupbox:Resize()
        end

        function Dropdown:SetText(Text: string)
            Dropdown.Text = Text
            Holder.Size = UDim2.new(1, 0, 0, Text and 39 or 21)

            Label.Text = Text and Text or ""
            Label.Visible = not not Text
        end

        function Dropdown:SetDragSelect(Value: boolean)
            if not Info.Multi or Library.IsMobile then
                Value = false
            end

            Dropdown.DragSelect = Value == true
            Dropdown:BuildDropdownList()
        end

        local ToggleDropdown = function()
            if Dropdown.Disabled then
                return
            end

            MenuTable:Toggle()
        end

        table.insert(Dropdown.Connections, DisplayContainer.MouseButton1Click:Connect(ToggleDropdown))
        table.insert(Dropdown.Connections, DisplayButton.MouseButton1Click:Connect(ToggleDropdown))

        if SearchBox then
            table.insert(Dropdown.Connections, SearchBox:GetPropertyChangedSignal("Text"):Connect(Dropdown.BuildDropdownList))
        end

        local Defaults = (function()
            local Resolved = {}
            local Default = Info.Default
            if Default == nil then
                return Resolved
            end

            local IsDictionary = not IsSequentialArray(Dropdown.Values)
            local function ResolveOne(Candidate)
                if IsDictionary then
                    return Dropdown.Values[Candidate] ~= nil and Candidate or nil
                end

                for _, Existing in Dropdown.Values do
                    if Existing == Candidate then
                        return Existing
                    end
                end

                return nil
            end

            local DefaultType = typeof(Default)
            if DefaultType == "string" then
                local Value = ResolveOne(Default)
                if Value ~= nil then
                    table.insert(Resolved, Value)
                end

            elseif DefaultType == "table" then
                for _, Candidate in Default do
                    local Value = ResolveOne(Candidate)
                    if Value ~= nil then
                        table.insert(Resolved, Value)
                    end
                end

            elseif Dropdown.Values[Default] ~= nil then
                table.insert(Resolved, IsDictionary and Default or Dropdown.Values[Default])
            end

            return Resolved
        end)()

        for _, SelectValue in Defaults do
            if Info.Multi then
                Dropdown.Value[SelectValue] = true
            else
                Dropdown.Value = SelectValue
                break
            end
        end

        if typeof(Dropdown.Tooltip) == "string" or typeof(Dropdown.DisabledTooltip) == "string" then
            Dropdown.TooltipTable = Library:AddTooltip(Dropdown.Tooltip, Dropdown.DisabledTooltip, DisplayContainer)
            Dropdown.TooltipTable.Disabled = Dropdown.Disabled
        end

        Dropdown:UpdateColors()
        Dropdown:Display()
        Dropdown:BuildDropdownList()
        Groupbox:Resize()

        Dropdown.Holder = Holder
        table.insert(Groupbox.Elements, Dropdown)

        Dropdown.Default = Defaults
        Dropdown.DefaultValues = Dropdown.Values

        Options[Idx] = Dropdown

        function Dropdown:Destroy()
            Dropdown.Destroyed = true

            StopDragSelect()

            if Dropdown.Connections then
                for _, Connection in Dropdown.Connections do
                    Connection:Disconnect()
                end
            end

            if Dropdown.TooltipTable then
                Dropdown.TooltipTable:Destroy()
            end

            if MenuTable then
                MenuTable:Destroy()
            end

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Dropdown)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Dropdown
    end

    function Funcs:AddViewport(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.Viewport)

        local Groupbox = self
        local Container = Groupbox.Container

        local Dragging, Pinching = false, false
        local LastMousePos, LastPinchDist = nil, 0

        local ViewportObject = Info.Object
        if Info.Clone and typeof(Info.Object) == "Instance" then
            if Info.Object.Archivable then
                ViewportObject = ViewportObject:Clone()
            else
                Info.Object.Archivable = true
                ViewportObject = ViewportObject:Clone()
                Info.Object.Archivable = false
            end
        end

        local Viewport = {
            Connections = {},
            Destroyed = false,

            Object = ViewportObject :: PVInstance,
            Camera = if not Info.Camera then Instance.new("Camera") else Info.Camera,
            Interactive = Info.Interactive,
            AutoFocus = Info.AutoFocus,
            Visible = Info.Visible,
            Type = "Viewport",
        }

        assert(
            typeof(Viewport.Object) == "Instance" and (Viewport.Object:IsA("BasePart") or Viewport.Object:IsA("Model")),
            "Instance must be a BasePart or Model."
        )

        assert(
            typeof(Viewport.Camera) == "Instance" and Viewport.Camera:IsA("Camera"),
            "Camera must be a valid Camera instance."
        )

        local function GetModelSize(model)
            if model:IsA("BasePart") then
                return model.Size
            end

            return select(2, model:GetBoundingBox())
        end

        local function FocusCamera()
            local ModelSize = GetModelSize(Viewport.Object)
            local MaxExtent = math.max(ModelSize.X, ModelSize.Y, ModelSize.Z)
            local CameraDistance = MaxExtent * 2
            local ModelPosition = (Viewport.Object :: PVInstance):GetPivot().Position

            Viewport.Camera.CFrame = CFrame.new(ModelPosition + Vector3.new(0, MaxExtent / 2, CameraDistance), ModelPosition)
        end

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Info.Height),
            Visible = Viewport.Visible,
            Parent = Container,
        })

        local Box = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            BorderColor3 = "OutlineColor",
            BorderSizePixel = 1,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.fromScale(1, 1),
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 4),
            Parent = Box,
        })

        local ViewportFrame = New("ViewportFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Parent = Box,
            CurrentCamera = Viewport.Camera,
            Active = Viewport.Interactive,
        })

        table.insert(Viewport.Connections, ViewportFrame.MouseEnter:Connect(function()
            if not Viewport.Interactive then
                return
            end

            for _, Side in Groupbox.Tab.Sides do
                Side.ScrollingEnabled = false
            end
        end))

        table.insert(Viewport.Connections, ViewportFrame.MouseLeave:Connect(function()
            if not Viewport.Interactive then
                return
            end

            for _, Side in Groupbox.Tab.Sides do
                Side.ScrollingEnabled = true
            end
        end))

        table.insert(Viewport.Connections, ViewportFrame.InputBegan:Connect(function(input)
            if not Viewport.Interactive then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseButton2 or (input.UserInputType == Enum.UserInputType.Touch and not Pinching) then
                Dragging = true
                LastMousePos = input.Position
            end
        end))

        table.insert(Viewport.Connections, UserInputService.InputEnded:Connect(function(input)
            if Library.Unloaded then
                return
            end

            if not Viewport.Interactive then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseButton2 or input.UserInputType == Enum.UserInputType.Touch then
                Dragging = false
            end
        end))

        table.insert(Viewport.Connections, UserInputService.InputChanged:Connect(function(input)
            if Library.Unloaded then
                return
            end

            if not Viewport.Interactive or not Dragging or Pinching then
                return
            end

            if
                input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch
            then
                local MouseDelta = input.Position - LastMousePos
                LastMousePos = input.Position

                local Position = (Viewport.Object :: PVInstance):GetPivot().Position
                local Camera = Viewport.Camera

                local RotationY = CFrame.fromAxisAngle(Vector3.new(0, 1, 0), -MouseDelta.X * 0.01)
                Camera.CFrame = CFrame.new(Position) * RotationY * CFrame.new(-Position) * Camera.CFrame

                local RotationX = CFrame.fromAxisAngle(Camera.CFrame.RightVector, -MouseDelta.Y * 0.01)
                local PitchedCFrame = CFrame.new(Position) * RotationX * CFrame.new(-Position) * Camera.CFrame

                if PitchedCFrame.UpVector.Y > 0.1 then
                    Camera.CFrame = PitchedCFrame
                end
            end
        end))

        table.insert(Viewport.Connections, ViewportFrame.InputChanged:Connect(function(input)
            if not Viewport.Interactive then
                return
            end

            if input.UserInputType == Enum.UserInputType.MouseWheel then
                local ZoomAmount = input.Position.Z * 2
                Viewport.Camera.CFrame += Viewport.Camera.CFrame.LookVector * ZoomAmount
            end
        end))

        table.insert(Viewport.Connections, UserInputService.TouchPinch:Connect(function(touchPositions, _, _, state)
            if Library.Unloaded then
                return
            end

            if not Viewport.Interactive or not Library:MouseIsOverFrame(ViewportFrame, touchPositions[1]) then
                return
            end

            if state == Enum.UserInputState.Begin then
                Pinching = true
                Dragging = false
                LastPinchDist = (touchPositions[1] - touchPositions[2]).Magnitude
            elseif state == Enum.UserInputState.Change then
                local currentDist = (touchPositions[1] - touchPositions[2]).Magnitude
                local delta = (currentDist - LastPinchDist) * 0.1
                LastPinchDist = currentDist
                Viewport.Camera.CFrame += Viewport.Camera.CFrame.LookVector * delta
            elseif state == Enum.UserInputState.End or state == Enum.UserInputState.Cancel then
                Pinching = false
            end
        end))

        ;(Viewport.Object :: PVInstance).Parent = ViewportFrame
        if Viewport.AutoFocus then
            FocusCamera()
        end

        function Viewport:SetObject(Object: Instance, Clone: boolean?)
            assert(Object, "Object cannot be nil.")

            if Clone then
                Object = Object:Clone()
            end

            if Viewport.Object then
                Viewport.Object:Destroy()
            end

            Viewport.Object = Object
            ;(Viewport.Object :: PVInstance).Parent = ViewportFrame

            Groupbox:Resize()
        end

        function Viewport:SetHeight(Height: number)
            assert(Height > 0, "Height must be greater than 0.")

            Holder.Size = UDim2.new(1, 0, 0, Height)
            Groupbox:Resize()
        end

        function Viewport:Focus()
            if not Viewport.Object then
                return
            end

            FocusCamera()
        end

        function Viewport:SetCamera(Camera: Instance)
            assert(
                Camera and typeof(Camera) == "Instance" and Camera:IsA("Camera"),
                "Camera must be a valid Camera instance."
            )

            Viewport.Camera = Camera
            ViewportFrame.CurrentCamera = Camera
        end

        function Viewport:SetInteractive(Interactive: boolean)
            Viewport.Interactive = Interactive
            ViewportFrame.Active = Interactive
        end

        function Viewport:SetVisible(Visible: boolean)
            Viewport.Visible = Visible

            Holder.Visible = Viewport.Visible
            Groupbox:Resize()
        end

        Groupbox:Resize()

        Viewport.Holder = Holder
        table.insert(Groupbox.Elements, Viewport)

        Options[Idx] = Viewport

        function Viewport:Destroy()
            Viewport.Destroyed = true

            if Viewport.Connections then
                for _, Connection in Viewport.Connections do
                    Connection:Disconnect()
                end
            end

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Viewport)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Viewport
    end

    function Funcs:AddImage(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.Image)

        local Groupbox = self
        local Container = Groupbox.Container

        local Image = {
            Connections = {},
            Destroyed = false,

            Image = Info.Image,
            Color = Info.Color,
            RectOffset = Info.RectOffset,
            RectSize = Info.RectSize,
            Height = Info.Height,
            ScaleType = Info.ScaleType,
            Transparency = Info.Transparency,
            BackgroundTransparency = Info.BackgroundTransparency,

            Visible = Info.Visible,
            Type = "Image",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Info.Height),
            Visible = Image.Visible,
            Parent = Container,
        })

        local Box = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            BackgroundTransparency = Image.BackgroundTransparency,
            ClipsDescendants = true,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.fromScale(1, 1),
            Parent = Holder,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                Parent = Box,
            })
        )
        New("UIStroke", {
            Color = "OutlineColor",
            Parent = Box,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 4),
            Parent = Box,
        })

        local ImageProperties = {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            ImageTransparency = Image.Transparency,
            ImageColor3 = Image.Color,
            ScaleType = Image.ScaleType,
            Parent = Box,
        }

        local Icon = Library:GetCustomIcon(Image.Image)
        assert(Icon, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

        ImageProperties.Image = Icon.Url
        ImageProperties.ImageRectOffset = Icon.ImageRectOffset
        ImageProperties.ImageRectSize = Icon.ImageRectSize

        local ImageLabel = New("ImageLabel", ImageProperties)
        Library:ApplyLucideIcon(ImageLabel, Icon)

        function Image:SetHeight(Height: number)
            assert(Height > 0, "Height must be greater than 0.")

            Image.Height = Height
            Holder.Size = UDim2.new(1, 0, 0, Height)
            Groupbox:Resize()
        end

        function Image:SetImage(NewImage: string)
            assert(typeof(NewImage) == "string", "Image must be a string.")

            local Icon = Library:GetCustomIcon(NewImage)
            assert(Icon, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

            Image.RectOffset = Icon.ImageRectOffset
            Image.RectSize = Icon.ImageRectSize

            Library:ApplyLucideIcon(ImageLabel, Icon)
            Image.Image = Icon.Url
        end

        function Image:SetColor(Color: Color3)
            assert(typeof(Color) == "Color3", "Color must be a Color3 value.")

            ImageLabel.ImageColor3 = Color
            Image.Color = Color
        end

        function Image:SetRectOffset(RectOffset: Vector2)
            assert(typeof(RectOffset) == "Vector2", "RectOffset must be a Vector2 value.")

            ImageLabel.ImageRectOffset = RectOffset
            Image.RectOffset = RectOffset
        end

        function Image:SetRectSize(RectSize: Vector2)
            assert(typeof(RectSize) == "Vector2", "RectSize must be a Vector2 value.")

            ImageLabel.ImageRectSize = RectSize
            Image.RectSize = RectSize
        end

        function Image:SetScaleType(ScaleType: Enum.ScaleType)
            assert(
                typeof(ScaleType) == "EnumItem" and ScaleType:IsA("ScaleType"),
                "ScaleType must be a valid Enum.ScaleType."
            )

            ImageLabel.ScaleType = ScaleType
            Image.ScaleType = ScaleType
        end

        function Image:SetTransparency(Transparency: number)
            assert(typeof(Transparency) == "number", "Transparency must be a number between 0 and 1.")
            assert(Transparency >= 0 and Transparency <= 1, "Transparency must be between 0 and 1.")

            ImageLabel.ImageTransparency = Transparency
            Image.Transparency = Transparency
        end

        function Image:SetVisible(Visible: boolean)
            Image.Visible = Visible

            Holder.Visible = Image.Visible
            Groupbox:Resize()
        end

        Groupbox:Resize()

        Image.Holder = Holder
        table.insert(Groupbox.Elements, Image)

        Options[Idx] = Image

        function Image:Destroy()
            Image.Destroyed = true

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Image)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Image
    end

    function Funcs:AddVideo(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.Video)

        local Groupbox = self
        local Container = Groupbox.Container

        local Video = {
            Connections = {},
            Destroyed = false,

            Video = Info.Video,
            Looped = Info.Looped,
            Playing = Info.Playing,
            Volume = Info.Volume,
            Height = Info.Height,
            Visible = Info.Visible,

            Type = "Video",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Info.Height),
            Visible = Video.Visible,
            Parent = Container,
        })

        local Box = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = "MainColor",
            BorderColor3 = "OutlineColor",
            BorderSizePixel = 1,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.fromScale(1, 1),
            Parent = Holder,
        })

        New("UIPadding", {
            PaddingBottom = UDim.new(0, 3),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 4),
            Parent = Box,
        })

        local VideoFrameInstance = New("VideoFrame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Video = Video.Video,
            Looped = Video.Looped,
            Volume = Video.Volume,
            Parent = Box,
        })

        VideoFrameInstance.Playing = Video.Playing

        function Video:SetHeight(Height: number)
            assert(Height > 0, "Height must be greater than 0.")

            Video.Height = Height
            Holder.Size = UDim2.new(1, 0, 0, Height)
            Groupbox:Resize()
        end

        function Video:SetVideo(NewVideo: string)
            assert(typeof(NewVideo) == "string", "Video must be a string.")

            VideoFrameInstance.Video = NewVideo
            Video.Video = NewVideo
        end

        function Video:SetLooped(Looped: boolean)
            assert(typeof(Looped) == "boolean", "Looped must be a boolean.")

            VideoFrameInstance.Looped = Looped
            Video.Looped = Looped
        end

        function Video:SetVolume(Volume: number)
            assert(typeof(Volume) == "number", "Volume must be a number between 0 and 10.")

            VideoFrameInstance.Volume = Volume
            Video.Volume = Volume
        end

        function Video:SetPlaying(Playing: boolean)
            assert(typeof(Playing) == "boolean", "Playing must be a boolean.")

            VideoFrameInstance.Playing = Playing
            Video.Playing = Playing
        end

        function Video:Play()
            VideoFrameInstance.Playing = true
            Video.Playing = true
        end

        function Video:Pause()
            VideoFrameInstance.Playing = false
            Video.Playing = false
        end

        function Video:SetVisible(Visible: boolean)
            Video.Visible = Visible

            Holder.Visible = Video.Visible
            Groupbox:Resize()
        end

        Groupbox:Resize()

        Video.Holder = Holder
        Video.VideoFrame = VideoFrameInstance
        table.insert(Groupbox.Elements, Video)

        Options[Idx] = Video

        function Video:Destroy()
            Video.Destroyed = true

            if Video.Connections then
                for _, Connection in Video.Connections do
                    Connection:Disconnect()
                end
            end

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Video)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Video
    end

    function Funcs:AddUIPassthrough(Idx, Info)
        if self.Destroyed then return nil end

        Info = Library:Validate(Info, Templates.UIPassthrough)

        local Groupbox = self
        local Container = Groupbox.Container

        assert(Info.Instance, "Instance must be provided.")
        assert(
            typeof(Info.Instance) == "Instance" and Info.Instance:IsA("GuiBase2d"),
            "Instance must inherit from GuiBase2d."
        )
        assert(typeof(Info.Height) == "number" and Info.Height > 0, "Height must be a number greater than 0.")

        local Passthrough = {
            Connections = {},
            Destroyed = false,

            Instance = Info.Instance,
            Height = Info.Height,
            Visible = Info.Visible,

            Type = "UIPassthrough",
        }

        local Holder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, Info.Height),
            Visible = Passthrough.Visible,
            Parent = Container,
        })

        Passthrough.Instance.Parent = Holder

        Groupbox:Resize()

        function Passthrough:SetHeight(Height: number)
            assert(typeof(Height) == "number" and Height > 0, "Height must be a number greater than 0.")

            Passthrough.Height = Height
            Holder.Size = UDim2.new(1, 0, 0, Height)
            Groupbox:Resize()
        end

        function Passthrough:SetInstance(Instance: Instance)
            assert(Instance, "Instance must be provided.")
            assert(
                typeof(Instance) == "Instance" and Instance:IsA("GuiBase2d"),
                "Instance must inherit from GuiBase2d."
            )

            if Passthrough.Instance then
                Passthrough.Instance.Parent = nil
            end

            Passthrough.Instance = Instance
            Passthrough.Instance.Parent = Holder
        end

        function Passthrough:SetVisible(Visible: boolean)
            Passthrough.Visible = Visible

            Holder.Visible = Passthrough.Visible
            Groupbox:Resize()
        end

        Passthrough.Holder = Holder
        table.insert(Groupbox.Elements, Passthrough)

        Options[Idx] = Passthrough

        function Passthrough:Destroy()
            Passthrough.Destroyed = true

            if Passthrough.Connections then
                for _, Connection in Passthrough.Connections do
                    Connection:Disconnect()
                end
            end

            if Holder then
                Holder:Destroy()
            end

            local ElemIdx = table.find(Groupbox.Elements, Passthrough)
            if ElemIdx then
                table.remove(Groupbox.Elements, ElemIdx)
            end

            Groupbox:Resize()
            Options[Idx] = nil
        end

        return Passthrough
    end

    function Funcs:AddDependencyBox()
        if self.Destroyed then return nil end

        local Groupbox = self
        local Container = Groupbox.Container

        local DepboxContainer
        local DepboxList

        do
            DepboxContainer = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Visible = false,
                Parent = Container,
            })

            DepboxList = New("UIListLayout", {
                Padding = UDim.new(0, 8),
                Parent = DepboxContainer,
            })
        end

        local Depbox = {
            Connections = {},
            Destroyed = false,

            Visible = false,
            Dependencies = {},

            Holder = DepboxContainer,
            Container = DepboxContainer,

            Elements = {},
            DependencyBoxes = {}
        }

        function Depbox:Resize()
            DepboxContainer.Size = UDim2.new(1, 0, 0, DepboxList.AbsoluteContentSize.Y / Library.DPIScale)
            Groupbox:Resize()
        end

        function Depbox:Update(CancelSearch)
            for _, Dependency in Depbox.Dependencies do
                local Element = Dependency[1]
                local Value = Dependency[2]

                if Element.Disabled then
                    DepboxContainer.Visible = false
                    Depbox.Visible = false
                    return
                end

                if Element.Type == "Toggle" and Element.Value ~= Value then
                    DepboxContainer.Visible = false
                    Depbox.Visible = false
                    return
                elseif Element.Type == "Dropdown" then
                    if typeof(Element.Value) == "table" then
                        if not Element.Value[Value] then
                            DepboxContainer.Visible = false
                            Depbox.Visible = false
                            return
                        end
                    else
                        if Element.Value ~= Value then
                            DepboxContainer.Visible = false
                            Depbox.Visible = false
                            return
                        end
                    end
                end
            end

            Depbox.Visible = true
            DepboxContainer.Visible = true
            if not Library.Searching then
                task.defer(function()
                    Depbox:Resize()
                end)
            elseif not CancelSearch then
                Library:UpdateSearch(Library.SearchText)
            end
        end

        table.insert(Depbox.Connections, DepboxList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            if not Depbox.Visible then
                return
            end

            Depbox:Resize()
        end))

        function Depbox:SetupDependencies(Dependencies)
            for _, Dependency in Dependencies do
                assert(typeof(Dependency) == "table", "Dependency should be a table.")
                assert(Dependency[1] ~= nil, "Dependency is missing element.")
                assert(Dependency[2] ~= nil, "Dependency is missing expected value.")
            end

            Depbox.Dependencies = Dependencies
            Depbox:Update()
        end

        table.insert(Depbox.Connections, DepboxContainer:GetPropertyChangedSignal("Visible"):Connect(function()
            Depbox:Resize()
        end))

        setmetatable(Depbox, BaseGroupbox)

        table.insert(Groupbox.DependencyBoxes, Depbox)
        table.insert(Library.DependencyBoxes, Depbox)

        function Depbox:Destroy()
            Depbox.Destroyed = true

            if Depbox.Connections then
                for _, Connection in Depbox.Connections do
                    Connection:Disconnect()
                end
            end

            for _, Element in Depbox.Elements do
                if Element.Destroy then
                    Element:Destroy()
                end
            end

            for _, SubDepbox in Depbox.DependencyBoxes do
                if SubDepbox.Destroy then
                    SubDepbox:Destroy()
                end
            end

            if DepboxContainer then
                DepboxContainer:Destroy()
            end

            local ElemIdx = table.find(Groupbox.DependencyBoxes, Depbox)
            if ElemIdx then
                table.remove(Groupbox.DependencyBoxes, ElemIdx)
            end

            local LibIdx = table.find(Library.DependencyBoxes, Depbox)
            if LibIdx then
                table.remove(Library.DependencyBoxes, LibIdx)
            end
        end

        return Depbox
    end

    function Funcs:AddDependencyGroupbox()
        if self.Destroyed then return nil end

        local Groupbox = self
        local Tab = Groupbox.Tab
        local BoxHolder = Groupbox.BoxHolder

        local DepGroupboxContainer
        local DepGroupboxList

        do
            DepGroupboxContainer = New("Frame", {
                BackgroundColor3 = "BackgroundColor",
                Size = UDim2.fromScale(1, 0),
                Visible = false,
                Parent = BoxHolder,
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius),
                    Parent = DepGroupboxContainer,
                })
            )
            Library:AddOutline(DepGroupboxContainer)

            DepGroupboxList = New("UIListLayout", {
                Padding = UDim.new(0, 8),
                Parent = DepGroupboxContainer,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 7),
                PaddingLeft = UDim.new(0, 7),
                PaddingRight = UDim.new(0, 7),
                PaddingTop = UDim.new(0, 7),
                Parent = DepGroupboxContainer,
            })
        end

        local DepGroupbox = {
            Connections = {},
            Destroyed = false,

            Visible = false,
            Dependencies = {},

            BoxHolder = BoxHolder,
            Holder = DepGroupboxContainer,
            Container = DepGroupboxContainer,

            Tab = Tab,
            Elements = {},
            DependencyBoxes = {},
        }

        function DepGroupbox:Resize()
            DepGroupboxContainer.Size = UDim2.new(1, 0, 0, (DepGroupboxList.AbsoluteContentSize.Y / Library.DPIScale) + 18)
            if Groupbox.RefreshBoxHolderLayout then
                Groupbox.RefreshBoxHolderLayout()
            end
        end

        function DepGroupbox:Update(CancelSearch)
            for _, Dependency in DepGroupbox.Dependencies do
                local Element = Dependency[1]
                local Value = Dependency[2]

                if Element.Disabled then
                    DepGroupboxContainer.Visible = false
                    DepGroupbox.Visible = false
                    return
                end

                if Element.Type == "Toggle" and Element.Value ~= Value then
                    DepGroupboxContainer.Visible = false
                    DepGroupbox.Visible = false
                    return
                elseif Element.Type == "Dropdown" then
                    if typeof(Element.Value) == "table" then
                        if not Element.Value[Value] then
                            DepGroupboxContainer.Visible = false
                            DepGroupbox.Visible = false
                            return
                        end
                    else
                        if Element.Value ~= Value then
                            DepGroupboxContainer.Visible = false
                            DepGroupbox.Visible = false
                            return
                        end
                    end
                end
            end

            DepGroupbox.Visible = true
            if not Library.Searching then
                DepGroupboxContainer.Visible = true
                DepGroupbox:Resize()
            elseif not CancelSearch then
                Library:UpdateSearch(Library.SearchText)
            end
        end

        function DepGroupbox:SetupDependencies(Dependencies)
            for _, Dependency in Dependencies do
                assert(typeof(Dependency) == "table", "Dependency should be a table.")
                assert(Dependency[1] ~= nil, "Dependency is missing element.")
                assert(Dependency[2] ~= nil, "Dependency is missing expected value.")
            end

            DepGroupbox.Dependencies = Dependencies
            DepGroupbox:Update()
        end

        setmetatable(DepGroupbox, BaseGroupbox)

        table.insert(Tab.DependencyGroupboxes, DepGroupbox)
        table.insert(Library.DependencyBoxes, DepGroupbox :: any)

        function DepGroupbox:Destroy()
            DepGroupbox.Destroyed = true

            if DepGroupbox.Connections then
                for _, Connection in DepGroupbox.Connections do
                    Connection:Disconnect()
                end
            end

            for _, Element in DepGroupbox.Elements do
                if Element.Destroy then
                    Element:Destroy()
                end
            end

            for _, SubDepbox in DepGroupbox.DependencyBoxes do
                if SubDepbox.Destroy then
                    SubDepbox:Destroy()
                end
            end

            if DepGroupboxContainer then
                DepGroupboxContainer:Destroy()
            end

            local ElemIdx = table.find(Tab.DependencyGroupboxes, DepGroupbox)
            if ElemIdx then
                table.remove(Tab.DependencyGroupboxes, ElemIdx)
            end

            local LibIdx = table.find(Library.DependencyBoxes, DepGroupbox)
            if LibIdx then
                table.remove(Library.DependencyBoxes, LibIdx)
            end
        end

        return DepGroupbox
    end

    BaseGroupbox.__index = Funcs
    BaseGroupbox.__namecall = function(_, Key, ...)
        return Funcs[Key](...)
    end
end

function Library:SetFont(FontFace)
    if typeof(FontFace) == "EnumItem" then
        FontFace = Font.fromEnum(FontFace :: any)
    end

    Library.Scheme.Font = FontFace
    Library:UpdateColorsUsingRegistry()

    for _, Label in Labels do
        if Label.DoesWrap then
            Label:Display()
            Label.Parent:Resize()
        end
    end

    if Library.Window and Library.Window.RefreshTitleSize then
        Library.Window:RefreshTitleSize()
    end
end

function Library:SetBackgroundImage(Image: string | number)
    assert(typeof(Image) == "string" or typeof(Image) == "number", "Expected string/number got " .. typeof(Image))

    Library.Scheme.BackgroundImage = Image
    if Library.Window then
        Library.Window:SetBackgroundImage(Image)
    end

    Library:UpdateColorsUsingRegistry()
end

function Library:UpdateNotificationPositions(Snap: boolean?)
    local IsLeft = Library.NotifySide:lower() == "left"
    local XScale = IsLeft and 0 or 1
    local RunningY = 0

    for _, FakeBackground in NotifyOrder do
        local Data = Library.Notifications[FakeBackground]
        if not (Data and FakeBackground.Parent) then continue end

        local Target = UDim2.new(XScale, 0, 0, RunningY)
        if Snap or not Data.PositionInitialized then
            FakeBackground.Position = Target
            Data.PositionInitialized = true

        elseif FakeBackground.Position ~= Target then
            TweenService:Create(FakeBackground, Library.NotifyTweenInfo, {
                Position = Target,
            }):Play()
        end

        RunningY = RunningY + FakeBackground.AbsoluteSize.Y / Library.DPIScale + 8
    end
end

function Library:SetNotifySide(Side: string)
    Library.NotifySide = Side

    local IsLeft = Side:lower() == "left"
    if IsLeft then
        NotificationArea.AnchorPoint = Vector2.new(0, 0)
        NotificationArea.Position = UDim2.fromOffset(6, 6)
    else
        NotificationArea.AnchorPoint = Vector2.new(1, 0)
        NotificationArea.Position = UDim2.new(1, -6, 0, 6)
    end

    for FakeBackground in Library.Notifications do
        if not (FakeBackground and FakeBackground.Parent) then continue end
        FakeBackground.AnchorPoint = if IsLeft then Vector2.new(0, 0) else Vector2.new(1, 0)
    end

    if Library.UpdateNotificationPositions then
        Library:UpdateNotificationPositions(true)
    end
end

function Library:Notify(...)
    local Data = {}
    local Info = select(1, ...)

    if typeof(Info) == "table" then
        Data.Title = tostring(Info.Title)
        Data.TitleColor = Info.TitleColor

        Data.Description = tostring(Info.Description)
        Data.DescriptionColor = Info.DescriptionColor

        Data.Time = Info.Time or 5
        Data.SoundId = Info.SoundId
        Data.Steps = Info.Steps
        Data.Persist = Info.Persist

        Data.Callback = typeof(Info.Callback) == "function" and Info.Callback or nil
        Data.Closable = Info.Closable == true

        Data.Icon = Info.Icon
        Data.BigIcon = Info.BigIcon
        Data.IconColor = Info.IconColor

        Data.Volume = tonumber(Info.Volume) or 3
    else
        Data.Description = tostring(Info)
        Data.Time = select(2, ...) or 5
        Data.SoundId = select(3, ...)
        Data.Volume = select(4, ...) or 3
    end
    Data.Destroyed = false

    local DeletedInstance = false
    local DeleteConnection = nil
    if typeof(Data.Time) == "Instance" then
        DeleteConnection = Data.Time.Destroying:Connect(function()
            DeletedInstance = true

            DeleteConnection:Disconnect()
            DeleteConnection = nil
        end)
    end

    local FakeBackground = New("Frame", {
        AnchorPoint = Library.NotifySide:lower() == "left" and Vector2.new(0, 0) or Vector2.new(1, 0),
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(0, 0),
        Visible = false,
        Parent = NotificationArea,
    })

    local Holder = New("Frame", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundColor3 = "MainColor",
        Position = Library.NotifySide:lower() == "left" and UDim2.new(-1, -8, 0, 0) or UDim2.new(1, 8, 0, 0),
        Size = UDim2.new(1, 0, 0, 0),
        ZIndex = 5,
        Parent = FakeBackground,
    })
    table.insert(
        Library.Corners,
        New("UICorner", {
            CornerRadius = UDim.new(0, Library.CornerRadius),
            Parent = Holder,
        })
    )
    Library:AddOutline(Holder)

    local ContentHolder = New("Frame", {
        AutomaticSize = Enum.AutomaticSize.Y,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 0),
        Parent = Holder,
    })
    New("UIListLayout", {
        Padding = UDim.new(0, 4),
        Parent = ContentHolder,
    })
    New("UIPadding", {
        PaddingBottom = UDim.new(0, 8),
        PaddingLeft = UDim.new(0, 8),
        PaddingRight = UDim.new(0, 8),
        PaddingTop = UDim.new(0, 8),
        Parent = ContentHolder,
    })

    local CloseButton
    if Data.Closable then
        CloseButton = New("ImageButton", {
            AnchorPoint = Vector2.new(1, 0),
            BackgroundTransparency = 1,
            Image = CloseIcon and CloseIcon.Url or "",
            ImageColor3 = "FontColor",
            ImageRectOffset = CloseIcon and CloseIcon.ImageRectOffset or Vector2.zero,
            ImageRectSize = CloseIcon and CloseIcon.ImageRectSize or Vector2.zero,
            ImageTransparency = 0.5,
            Position = UDim2.new(1, -8, 0, 8),
            Size = UDim2.fromOffset(14, 14),
            ZIndex = 6,
            Parent = Holder,
        })
        Library:ApplyLucideIcon(CloseButton, CloseIcon)

        CloseButton.MouseEnter:Connect(function()
            TweenService:Create(CloseButton, Library.TweenInfo, {
                ImageTransparency = 0,
            }):Play()
        end)
        CloseButton.MouseLeave:Connect(function()
            TweenService:Create(CloseButton, Library.TweenInfo, {
                ImageTransparency = 0.5,
            }):Play()
        end)
        CloseButton.MouseButton1Click:Connect(function()
            Data:Destroy("user")
        end)
    end

    local ContentContainer = New("Frame", {
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.XY,
        Size = UDim2.fromOffset(0, 0),
        Parent = ContentHolder,
    })

    if Data.BigIcon then
        New("UIListLayout", {
            Padding = UDim.new(0, 8),
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Parent = ContentContainer,
        })
    end

    local BigIconLabel
    if Data.BigIcon then
        local ParsedIcon = Library:GetCustomIcon(Data.BigIcon)
        if ParsedIcon then
            BigIconLabel = New("ImageLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(24, 24),
                ImageColor3 = Data.IconColor or "AccentColor",
                Parent = ContentContainer,
            })
            Library:ApplyLucideIcon(BigIconLabel, ParsedIcon)
        end
    end

    local TextContainer = New("Frame", {
        BackgroundTransparency = 1,
        AutomaticSize = Enum.AutomaticSize.XY,
        Size = UDim2.fromOffset(0, 0),
        Parent = ContentContainer,
    })
    New("UIListLayout", {
        Padding = UDim.new(0, 4),
        Parent = TextContainer,
    })

    local TitleContainer
    if Data.Title then
        TitleContainer = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(0, 0),
            Parent = TextContainer,
        })
    end

    local IconLabel
    if Data.Icon and TitleContainer then
        local ParsedIcon = Library:GetCustomIcon(Data.Icon)
        if ParsedIcon then
            IconLabel = New("ImageLabel", {
                BackgroundTransparency = 1,
                AnchorPoint = Vector2.new(0, 0.5),
                Position = UDim2.new(0, 0, 0.5, 1),
                Size = UDim2.fromOffset(15, 15),
                ImageColor3 = Data.IconColor or "FontColor",
                Parent = TitleContainer,
            })
            Library:ApplyLucideIcon(IconLabel, ParsedIcon)
        end
    end

    local Title
    local Desc
    local TitleX = 0
    local DescX = 0

    local TimerFill

    if Data.Title then
        Title = New("TextLabel", {
            AutomaticSize = Enum.AutomaticSize.None,
            BackgroundTransparency = 1,
            AnchorPoint = Vector2.new(0, 0.5),
            Position = UDim2.new(0, (IconLabel and 21 or 0), 0.5, 0),
            Size = UDim2.fromScale(0, 0),
            Text = Data.Title,
            TextColor3 = Data.TitleColor or "FontColor",
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            TextWrapped = true,
            Parent = TitleContainer,
        })
    end

    if Data.Description then
        Desc = New("TextLabel", {
            AutomaticSize = Enum.AutomaticSize.None,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(0, 0),
            Text = Data.Description,
            TextColor3 = Data.DescriptionColor or "FontColor",
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextWrapped = true,
            Parent = TextContainer,
        })
    end

    function Data:Resize()
        local ExtraWidth = BigIconLabel and 32 or 0
        local IconWidth = IconLabel and 21 or 0
        local CloseWidth = Data.Closable and 20 or 0
        local MaxTextWidth = math.max(
            40,
            (NotificationArea.AbsoluteSize.X / Library.DPIScale) - 24 - ExtraWidth - CloseWidth
        )

        if Title then
            local X, Y = Library:GetTextBounds(Title.Text, Title.FontFace, Title.TextSize, MaxTextWidth - IconWidth)
            Title.Size = UDim2.fromOffset(X, Y)
            TitleX = X + IconWidth
            TitleContainer.Size = UDim2.fromOffset(TitleX, math.max(Y, IconLabel and 16 or 0))
        end

        if Desc then
            local X, Y = Library:GetTextBounds(Desc.Text, Desc.FontFace, Desc.TextSize, MaxTextWidth)
            Desc.Size = UDim2.fromOffset(X, Y)
            DescX = X
        end

        FakeBackground.Size = UDim2.fromOffset(math.max(TitleX, DescX) + 24 + ExtraWidth + CloseWidth, 0)

        if Library.Notifications[FakeBackground] then
            task.defer(function()
                if Data.Destroyed or not FakeBackground.Parent then
                    return
                end

                if FakeBackground.AbsoluteSize.Y <= 0 then
                    task.defer(function()
                        if Data.Destroyed or not FakeBackground.Parent then
                            return
                        end

                        Library:UpdateNotificationPositions(true)
                    end)
                    return
                end

                Library:UpdateNotificationPositions(true)
            end)
        end
    end

    function Data:ChangeTitle(Text)
        if Title then
            Data.Title = tostring(Text)
            Title.Text = Data.Title
            Data:Resize()
        end
    end

    function Data:ChangeDescription(Text)
        if Desc then
            Data.Description = tostring(Text)
            Desc.Text = Data.Description
            Data:Resize()
        end
    end

    function Data:ChangeStep(NewStep)
        if TimerFill and Data.Steps then
            NewStep = math.clamp(NewStep or 0, 0, Data.Steps)
            TimerFill.Size = UDim2.fromScale(NewStep / Data.Steps, 1)
        end
    end

    function Data:Destroy(Reason)
        if Data.Destroyed then
            return
        end

        Reason = Reason or "script"
        Data.Destroyed = true

        if Data.Callback then
            pcall(Data.Callback, Reason)
        end

        if typeof(Data.Time) == "Instance" then
            pcall(Data.Time.Destroy, Data.Time)
        end

        if DeleteConnection then
            DeleteConnection:Disconnect()
        end

        if FakeBackground then
            local Idx = table.find(NotifyOrder, FakeBackground)
            if Idx then
                table.remove(NotifyOrder, Idx)
            end
        end

        Library:UpdateNotificationPositions()

        TweenService
            :Create(Holder, Library.NotifyTweenInfo, {
                Position = Library.NotifySide:lower() == "left" and UDim2.new(-1, -8, 0, -2) or UDim2.new(1, 8, 0, -2),
            })
            :Play()

        task.delay(Library.NotifyTweenInfo.Time, function()
            Library.Notifications[FakeBackground] = nil
            FakeBackground:Destroy()
        end)
    end

    local TimerHolder = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 7),
        Visible = (Data.Persist ~= true and typeof(Data.Time) ~= "Instance") or typeof(Data.Steps) == "number",
        Parent = ContentHolder,
    })
    local TimerBar = New("Frame", {
        BackgroundColor3 = "BackgroundColor",
        BorderColor3 = "OutlineColor",
        BorderSizePixel = 1,
        Position = UDim2.fromOffset(0, 3),
        Size = UDim2.new(1, 0, 0, 2),
        Parent = TimerHolder,
    })
    TimerFill = New("Frame", {
        BackgroundColor3 = "AccentColor",
        Size = UDim2.fromScale(1, 1),
        Parent = TimerBar,
    })

    if typeof(Data.Time) == "Instance" then
        TimerFill.Size = UDim2.fromScale(0, 1)
    end
    if Data.SoundId then
        local SoundId = Data.SoundId
        if typeof(SoundId) == "number" then
            SoundId = string.format("rbxassetid://%d", SoundId)
        end

        New("Sound", {
            SoundId = SoundId,
            Volume = tonumber(Data.Volume) or 3,
            PlayOnRemove = true,
            Parent = SoundService,
        }):Destroy()
    end

    Data.Holder = Holder

    table.insert(NotifyOrder, FakeBackground)
    Library.Notifications[FakeBackground] = Data

    Data:Resize()

    FakeBackground.Visible = true
    TweenService:Create(Holder, Library.NotifyTweenInfo, {
        Position = UDim2.fromOffset(0, 0),
    }):Play()

    task.defer(function()
        if not Data.Destroyed then
            Library:UpdateNotificationPositions(true)
        end
    end)

    task.delay(Library.NotifyTweenInfo.Time, function()
        if Data.Persist then
            return
        elseif typeof(Data.Time) == "Instance" then
            repeat
                task.wait()
            until DeletedInstance or Data.Destroyed
        else
            TweenService
                :Create(TimerFill, TweenInfo.new(Data.Time, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
                    Size = UDim2.fromScale(0, 1),
                })
                :Play()
            task.wait(Data.Time)
        end

        Data:Destroy("timer")
    end)

    return Data
end

function Library:CreateWindow(WindowInfo)
    WindowInfo = Library:Validate(WindowInfo, Templates.Window)
    local ViewportSize: Vector2 = workspace.CurrentCamera.ViewportSize
    if RunService:IsStudio() and ViewportSize.X <= 5 and ViewportSize.Y <= 5 then
        repeat
            ViewportSize = workspace.CurrentCamera.ViewportSize
            task.wait()
        until ViewportSize.X > 5 and ViewportSize.Y > 5
    end

    local MaxX = ViewportSize.X - 64
    local MaxY = ViewportSize.Y - 64

    Library.OriginalMinSize =
        Vector2.new(math.min(Library.OriginalMinSize.X, MaxX), math.min(Library.OriginalMinSize.Y, MaxY))
    Library.MinSize = Vector2.new(math.min(WindowInfo.MinContainerWidth, MaxX), Library.OriginalMinSize.Y)

    WindowInfo.Size = UDim2.fromOffset(
        math.clamp(WindowInfo.Size.X.Offset, Library.MinSize.X, MaxX),
        math.clamp(WindowInfo.Size.Y.Offset, Library.MinSize.Y, MaxY)
    )
    if typeof(WindowInfo.Font) == "EnumItem" then
        WindowInfo.Font = Font.fromEnum(WindowInfo.Font :: any)
    end
    WindowInfo.CornerRadius = math.min(WindowInfo.CornerRadius, 20)

    local TabButtonsStyle = WindowInfo.TabButtonsStyle

    --// Old Naming \\--
    if WindowInfo.Compact ~= nil then
        WindowInfo.SidebarCompacted = WindowInfo.Compact
    end
    if WindowInfo.SidebarMinWidth ~= nil then
        WindowInfo.MinSidebarWidth = WindowInfo.SidebarMinWidth
    end
    WindowInfo.MinSidebarWidth = math.max(64 + TabButtonsStyle.Padding * 2, WindowInfo.MinSidebarWidth)
    WindowInfo.SidebarCompactWidth = math.max(40 + TabButtonsStyle.Padding * 2, WindowInfo.SidebarCompactWidth)
    WindowInfo.SidebarCollapseThreshold = math.clamp(WindowInfo.SidebarCollapseThreshold, 0.1, 0.9)
    WindowInfo.CompactWidthActivation = math.max(40 + TabButtonsStyle.Padding * 2, WindowInfo.CompactWidthActivation)
    WindowInfo.SnapDistance = math.max(0, WindowInfo.SnapDistance)
    WindowInfo.SnapMargin = math.max(0, WindowInfo.SnapMargin)

    Library.CornerRadius = WindowInfo.CornerRadius
    Library:SetNotifySide(WindowInfo.NotifySide)
    Library.Scheme.Font = WindowInfo.Font
    Library.ToggleKeybind = WindowInfo.ToggleKeybind
    Library.GlobalSearch = WindowInfo.GlobalSearch

    Library.Animations = WindowInfo.Animations
    Library.TabTransitionInfo = TweenInfo.new(
        math.max(0, WindowInfo.TabTransitionTime or 0.22),
        Enum.EasingStyle.Quad,
        Enum.EasingDirection.Out
    )
    Library.TabSwipeOffset = math.max(1, WindowInfo.TabSwipeOffset or 26)
    Library.TabSwipeFrom = WindowInfo.TabSwipeFrom or "right"

    local MainFrame
    local DividerLine
    local TitleHolder
    local WindowTitle
    local WindowSubtitle
    local TitleDivider
    local WindowIcon
    local RightWrapper
    local SearchBox
    local ResizeButton
    local IslandMinimized = false
    local DismissIsland, SetIslandIcon
    local Tabs
    local Container
    local BackgroundImage
    local HasBackgroundImage = false
    local BottomBackground
    local BottomBackgroundCorner
    local FooterLabel
    local TopBar
    local WindowSnapConfig = {
        Enabled = WindowInfo.Snapping,
        Distance = WindowInfo.SnapDistance,
        Margin = WindowInfo.SnapMargin,
        AvoidCoreGui = WindowInfo.SnapAvoidCoreGui,
    }

    local InitialLeftWidth = math.ceil(WindowInfo.Size.X.Offset * 0.3)
    local IsCompact = WindowInfo.SidebarCompacted
    local LastExpandedWidth = InitialLeftWidth
    local RefreshWindowTitleSize

    do
        local KeybindFrame, KeybindContainer, _, KeybindDivider, KeybindLabelPadding = Library:AddDraggableMenu("Keybinds")
        KeybindFrame.AnchorPoint = Vector2.new(0, 0.5)
        KeybindFrame.Position = UDim2.new(0, 6, 0.5, 0)
        KeybindFrame.Visible = false
        KeybindLabelPadding.PaddingRight = UDim.new(0, 34)

        local HeaderButtons = New("Frame", {
            AnchorPoint = Vector2.new(1, 0.5),
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -8, 0, 17),
            Size = UDim2.fromOffset(0, 22),
            ZIndex = 2,
            Parent = KeybindFrame,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 4),
            Parent = HeaderButtons,
        })

        local SettingsButton = New("ImageButton", {
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            ImageColor3 = "FontColor",
            LayoutOrder = 1,
            Size = UDim2.fromOffset(18, 18),
            Visible = false,
            ZIndex = 2,
            Parent = HeaderButtons,
        })
        if SettingsIcon then
            Library:ApplyLucideIcon(SettingsButton, SettingsIcon)
        end

        local CollapseButton = New("ImageButton", {
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            ImageColor3 = "FontColor",
            LayoutOrder = 2,
            Size = UDim2.fromOffset(18, 18),
            ZIndex = 2,
            Parent = HeaderButtons,
        })
        if ArrowIcon then
            Library:ApplyLucideIcon(CollapseButton, ArrowIcon, 180)
        end

        local SettingsFrame, SettingsContainer, _, _, SettingsLabelPadding = Library:AddDraggableMenu("Visible Keybinds")
        SettingsFrame.Visible = false
        SettingsLabelPadding.PaddingRight = UDim.new(0, 34)

        local CloseSettingsButton = New("ImageButton", {
            AnchorPoint = Vector2.new(1, 0.5),
            AutoButtonColor = false,
            BackgroundTransparency = 1,
            ImageColor3 = "FontColor",
            Position = UDim2.new(1, -8, 0, 17),
            Size = UDim2.fromOffset(18, 18),
            ZIndex = 2,
            Parent = SettingsFrame,
        })
        if CloseIcon then
            Library:ApplyLucideIcon(CloseSettingsButton, CloseIcon)
        end

        local KeybindMenu = {
            VisibilityControl = false,
            Collapsed = false,
            SettingsOpen = false,
            Frame = KeybindFrame,
            Container = KeybindContainer,
            SettingsFrame = SettingsFrame,
            SettingsContainer = SettingsContainer,
        }

        function KeybindMenu:RefreshSettings()
            for _, Child in SettingsContainer:GetChildren() do
                if Child:IsA("GuiObject") and not Child:IsA("UIListLayout") and not Child:IsA("UIPadding") then
                    Child:Destroy()
                end
            end

            for Idx, Option in Options do
                if Option.Type ~= "KeyPicker" or Option.NoUI == true then
                    continue
                end

                local Holder = New("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 16),
                    Text = "",
                    Parent = SettingsContainer,
                })

                local Visible = Option.MenuVisible ~= false
                New("TextLabel", {
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(22, 0),
                    Size = UDim2.fromScale(0, 1),
                    Text = ("[%s] %s (%s)"):format(
                        Option.DisplayValue or Option.Value or "None",
                        Option.Text or tostring(Idx),
                        Option.Mode or "Toggle"
                    ),
                    TextSize = 14,
                    TextTransparency = Visible and 0 or 0.5,
                    Parent = Holder,
                })

                local Checkbox = New("Frame", {
                    AnchorPoint = Vector2.new(0, 0.5),
                    BackgroundColor3 = "MainColor",
                    Position = UDim2.fromScale(0, 0.5),
                    Size = UDim2.fromOffset(14, 14),
                    Parent = Holder,
                })
                table.insert(
                    Library.Corners,
                    New("UICorner", {
                        CornerRadius = UDim.new(0, Library.CornerRadius / 2),
                        Parent = Checkbox,
                    })
                )
                New("UIStroke", {
                    Color = "OutlineColor",
                    Parent = Checkbox,
                })

                local CheckImage = New("ImageLabel", {
                    ImageColor3 = "FontColor",
                    ImageTransparency = Visible and 0 or 1,
                    Position = UDim2.fromOffset(2, 2),
                    Size = UDim2.new(1, -4, 1, -4),
                    Parent = Checkbox,
                })
                if CheckIcon then
                    Library:ApplyLucideIcon(CheckImage, CheckIcon)
                end

                Holder.MouseButton1Click:Connect(function()
                    local Picker = Options[Idx]
                    if not (Picker and Picker.Type == "KeyPicker" and Picker.SetMenuVisibility) then
                        return
                    end

                    Picker:SetMenuVisibility(Picker.MenuVisible == false)
                end)
            end
        end

        function KeybindMenu:SetCollapsed(Collapsed: boolean)
            Collapsed = Collapsed == true
            KeybindMenu.Collapsed = Collapsed

            KeybindContainer.Visible = not Collapsed
            KeybindDivider.Visible = not Collapsed

            if Collapsed then
                local Width = math.max(160, KeybindFrame.AbsoluteSize.X / Library.DPIScale)
                KeybindFrame.AutomaticSize = Enum.AutomaticSize.None
                KeybindFrame.Size = UDim2.fromOffset(Width, 34)
                CollapseButton.Rotation = 0
            else
                KeybindFrame.AutomaticSize = Enum.AutomaticSize.XY
                KeybindFrame.Size = UDim2.fromOffset(0, 0)
                CollapseButton.Rotation = 180
            end
        end

        function KeybindMenu:ToggleCollapsed()
            KeybindMenu:SetCollapsed(not KeybindMenu.Collapsed)
        end

        function KeybindMenu:SetSettingsOpen(Open: boolean)
            Open = Open == true
            if Open and not KeybindMenu.VisibilityControl then
                return
            end

            KeybindMenu.SettingsOpen = Open
            SettingsFrame.Visible = Open

            if Open then
                KeybindMenu:RefreshSettings()

                local Bounds = Floats.AbsoluteSize
                local Pos = KeybindFrame.AbsolutePosition - Floats.AbsolutePosition
                local Size = KeybindFrame.AbsoluteSize
                local SettingsSize = SettingsFrame.AbsoluteSize

                local X = Pos.X + Size.X + 8
                if X + SettingsSize.X > Bounds.X then
                    X = Pos.X - SettingsSize.X - 8
                end

                SettingsFrame.Position = UDim2.fromOffset(
                    math.clamp(X, 0, math.max(0, Bounds.X - SettingsSize.X)),
                    math.clamp(Pos.Y, 0, math.max(0, Bounds.Y - SettingsSize.Y))
                )
            end
        end

        function KeybindMenu:ToggleSettings()
            KeybindMenu:SetSettingsOpen(not KeybindMenu.SettingsOpen)
        end

        function KeybindMenu:SetVisibilityControl(Enabled: boolean)
            Enabled = Enabled == true
            KeybindMenu.VisibilityControl = Enabled
            SettingsButton.Visible = Enabled
            KeybindLabelPadding.PaddingRight = UDim.new(0, Enabled and 56 or 34)

            if not Enabled then
                KeybindMenu:SetSettingsOpen(false)
            end
        end

        function KeybindMenu:Destroy()
            local DraggableIndex = table.find(Library.DraggableElements, SettingsFrame)
            if DraggableIndex then
                table.remove(Library.DraggableElements, DraggableIndex)
            end

            SettingsFrame:Destroy()
            KeybindMenu.SettingsFrame = nil
            KeybindMenu.SettingsContainer = nil
            KeybindMenu.SettingsOpen = false
            Library.KeybindMenu = nil
        end

        SettingsButton.MouseButton1Click:Connect(function()
            KeybindMenu:ToggleSettings()
        end)
        CollapseButton.MouseButton1Click:Connect(function()
            KeybindMenu:ToggleCollapsed()
        end)
        CloseSettingsButton.MouseButton1Click:Connect(function()
            KeybindMenu:SetSettingsOpen(false)
        end)

        Library.KeybindFrame = KeybindFrame
        Library.KeybindContainer = KeybindContainer
        Library.KeybindMenu = KeybindMenu

        MainFrame = New("TextButton", {
            BackgroundColor3 = function()
                return Library:GetBetterColor(Library.Scheme.BackgroundColor, -1)
            end,
            Name = "Main",
            Text = "",
            Position = WindowInfo.Position,
            Size = WindowInfo.Size,
            Visible = false,
            Parent = ScreenGui,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                Parent = MainFrame,
            })
        )
        table.insert(
            Library.Scales,
            New("UIScale", {
                Parent = MainFrame,
            })
        )
        Library:AddOutline(MainFrame)
        Library:MakeLine(MainFrame, {
            Position = UDim2.fromOffset(0, 48),
            Size = UDim2.new(1, 0, 0, 1),
        })

        DividerLine = New("Frame", {
            BackgroundColor3 = "OutlineColor",
            Position = UDim2.fromOffset(InitialLeftWidth, 49),
            Size = UDim2.new(0, 1, 1, -70),
            Parent = MainFrame,
            ZIndex = 2
        })

        local BackgroundIcon = Library:GetCustomIcon(WindowInfo.BackgroundImage)
        HasBackgroundImage = BackgroundIcon ~= nil
        BackgroundImage = New("ImageLabel", {
            Active = false,
            Position = UDim2.fromScale(0, 0),
            Size = UDim2.fromScale(1, 1),
            ScaleType = Enum.ScaleType.Stretch,
            ZIndex = Overlay.ZIndex + 1,
            BackgroundTransparency = 1,
            ImageTransparency = 0.75,
            Visible = false,
            Parent = ScreenGui,
        })
        if BackgroundIcon then
            Library:ApplyLucideIcon(BackgroundImage, BackgroundIcon)
        end

        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                Parent = BackgroundImage,
            })
        )

        Library:GiveSignal(RunService.RenderStepped:Connect(function()
            if not (BackgroundImage and MainFrame) then
                return
            end

            local ShouldShow = HasBackgroundImage and MainFrame.Visible
            BackgroundImage.Visible = ShouldShow

            if not ShouldShow then
                return
            end

            BackgroundImage.Position = UDim2.fromOffset(
                MainFrame.AbsolutePosition.X,
                MainFrame.AbsolutePosition.Y
            )
            BackgroundImage.Size = UDim2.fromOffset(
                MainFrame.AbsoluteSize.X,
                MainFrame.AbsoluteSize.Y
            )
        end))

        if WindowInfo.Center then
            MainFrame.Position = UDim2.new(0.5, -MainFrame.Size.X.Offset / 2, 0.5, -MainFrame.Size.Y.Offset / 2)
        end

        --// Top Bar \\-
        TopBar = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 48),
            Parent = MainFrame,
        })
        Library:MakeDraggable(MainFrame, TopBar, false, true, WindowSnapConfig)

        --// Title \\--
        TitleHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(0, InitialLeftWidth, 1, 0),
            Parent = TopBar,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 8),
            Parent = TitleHolder,
        })
        New("UIPadding", {
            PaddingLeft = UDim.new(0, 10),
            Parent = TitleHolder,
        })

        if WindowInfo.Icon then
            local Icon = Library:GetCustomIcon(WindowInfo.Icon)
            WindowIcon = New("ImageLabel", {
                Size = WindowInfo.IconSize,
                Parent = TitleHolder,
            })
            if Icon then
                Library:ApplyLucideIcon(WindowIcon, Icon)
            end
        else
            WindowIcon = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = WindowInfo.IconSize,
                Text = WindowInfo.Title:sub(1, 1),
                TextScaled = true,
                Visible = false,
                Parent = TitleHolder,
            })
        end

        WindowTitle = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(0, 0),
            Text = WindowInfo.Title,
            TextSize = 18,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            Parent = TitleHolder,
        })

        WindowSubtitle = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromOffset(0, 0),
            Text = WindowInfo.Subtitle or "",
            TextSize = 13,
            TextTransparency = 0.5,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Center,
            Visible = typeof(WindowInfo.Subtitle) == "string" and WindowInfo.Subtitle ~= "",
            Parent = TitleHolder,
        })

        RefreshWindowTitleSize = function()
            local IconWidth = 0
            if WindowIcon and WindowIcon.Visible then
                IconWidth = WindowIcon.Size.X.Offset + 6
            end

            local MaxWidth = math.max(0, (TitleHolder.AbsoluteSize.X / Library.DPIScale) - IconWidth - 20)
            local NaturalWidth = Library:GetTextBounds(WindowTitle.Text, Library.Scheme.Font, WindowTitle.TextSize)
            local TitleWidth = math.min(NaturalWidth, MaxWidth)
            WindowTitle.Size = UDim2.new(0, TitleWidth, 1, 0)

            if WindowSubtitle.Visible then
                local SubtitleWidth = Library:GetTextBounds(WindowSubtitle.Text, Library.Scheme.Font, WindowSubtitle.TextSize)
                WindowSubtitle.Size = UDim2.new(0, math.max(0, math.min(SubtitleWidth, MaxWidth - TitleWidth - 8)), 1, 0)
            end
        end
        RefreshWindowTitleSize()

        TitleDivider = New("Frame", {
            BackgroundColor3 = "OutlineColor",
            Position = UDim2.fromOffset(InitialLeftWidth, 0),
            Size = UDim2.new(0, 1, 1, 0),
            Parent = TopBar,
        })

        --// Top Right Bar \\--
        RightWrapper = New("Frame", {
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -49, 0.5, 0),
            Size = UDim2.new(1, -InitialLeftWidth - 57 - 1, 1, -16),
            Parent = TopBar,
        })

        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 8),
            Parent = RightWrapper,
        })

        SearchBox = New("TextBox", {
            BackgroundColor3 = "MainColor",
            PlaceholderText = "Search",
            Size = WindowInfo.SearchbarSize,
            TextScaled = true,
            Visible = not (WindowInfo.DisableSearch or false),
            Parent = RightWrapper,
        })
        New("UIFlexItem", {
            FlexMode = Enum.UIFlexMode.Shrink,
            Parent = SearchBox,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                Parent = SearchBox,
            })
        )
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 8),
            PaddingLeft = UDim.new(0, 8),
            PaddingRight = UDim.new(0, 8),
            PaddingTop = UDim.new(0, 8),
            Parent = SearchBox,
        })
        local SearchBoxStroke = New("UIStroke", {
            Color = "OutlineColor",
            Parent = SearchBox,
        })

        Library:GiveSignal(SearchBox.Focused:Connect(function()
            Library.Registry[SearchBoxStroke].Color = "AccentColor"
            TweenService:Create(SearchBoxStroke, Library.TweenInfo, {
                Color = Library.Scheme.AccentColor,
            }):Play()
        end))

        Library:GiveSignal(SearchBox.FocusLost:Connect(function()
            Library.Registry[SearchBoxStroke].Color = "OutlineColor"
            TweenService:Create(SearchBoxStroke, Library.TweenInfo, {
                Color = Library.Scheme.OutlineColor,
            }):Play()
        end))

        local SearchIcon = Library:GetIcon("search")
        if SearchIcon then
            local SearchIconImage = New("ImageLabel", {
                ImageColor3 = "FontColor",
                ImageTransparency = 0.5,
                Size = UDim2.fromScale(1, 1),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Parent = SearchBox,
            })
            Library:ApplyLucideIcon(SearchIconImage, SearchIcon)
        end

        --// Search Results \\--
        local ResultHeight = 32
        local ResultPadding = 6
        local MaxVisibleResults = 8
        local SearchResultsList = {}

        local SearchResults = New("ScrollingFrame", {
            AnchorPoint = Vector2.new(1, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = "BackgroundColor",
            CanvasSize = UDim2.fromScale(0, 0),
            ScrollBarImageColor3 = "OutlineColor",
            ScrollBarThickness = 2,
            Visible = false,
            Parent = Overlay,
        })
        table.insert(Library.Scales, New("UIScale", {
            Scale = Library.DPIScale,
            Parent = SearchResults,
        }))
        table.insert(Library.Corners, New("UICorner", {
            CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
            Parent = SearchResults,
        }))
        New("UIStroke", {
            Color = "OutlineColor",
            Parent = SearchResults,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, ResultPadding),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = SearchResults,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, ResultPadding),
            PaddingLeft = UDim.new(0, ResultPadding),
            PaddingRight = UDim.new(0, ResultPadding),
            PaddingTop = UDim.new(0, ResultPadding),
            Parent = SearchResults,
        })

        local function PlaceSearchResults()
            local Width = math.max(SearchBox.AbsoluteSize.X / Library.DPIScale, 420)
            local Count = math.min(#SearchResultsList, MaxVisibleResults)

            SearchResults.Position = UDim2.fromOffset(
                math.floor(SearchBox.AbsolutePosition.X + SearchBox.AbsoluteSize.X),
                math.floor(SearchBox.AbsolutePosition.Y + SearchBox.AbsoluteSize.Y + 4 * Library.DPIScale)
            )
            SearchResults.Size = UDim2.fromOffset(Width, Count * (ResultHeight + ResultPadding) + ResultPadding)
        end

        --// Rows are cached per element and only rebuilt when their path or text changes \--
        local SearchRowCache = {}

        local function DestroySearchRow(Row)
            for _, Descendant in Row:GetDescendants() do
                Library:RemoveFromRegistry(Descendant)
            end
            Library:RemoveFromRegistry(Row)
            Row:Destroy()
        end

        local function HideSearchResults()
            SearchResults.Visible = false
        end
        Library.HideSearchResults = HideSearchResults

        local function OpenSearchResult(Result)
            HideSearchResults()
            SearchBox.Text = ""
            SearchBox:ReleaseFocus()
            RevealSearchResult(Result)
        end

        local function AddSegment(Parent, Order, Text, Icon, IsLast)
            if Icon then
                local Image = New("ImageLabel", {
                    BackgroundTransparency = 1,
                    ImageColor3 = "FontColor",
                    ImageTransparency = 0.4,
                    LayoutOrder = Order,
                    Size = UDim2.fromOffset(16, 16),
                    Parent = Parent,
                })
                Library:ApplyLucideIcon(Image, Icon)
                Order += 1
            end

            New("TextLabel", {
                AutomaticSize = Enum.AutomaticSize.X,
                BackgroundTransparency = 1,
                LayoutOrder = Order,
                Size = UDim2.fromOffset(0, ResultHeight),
                Text = Text,
                TextColor3 = if IsLast then "AccentColor" else "FontColor",
                TextSize = IsLast and 15 or 14,
                TextTransparency = IsLast and 0 or 0.4,
                TextWrapped = false,
                TextYAlignment = Enum.TextYAlignment.Center,
                Parent = Parent,
            })
            Order += 1

            if not IsLast then
                New("TextLabel", {
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    LayoutOrder = Order,
                    Size = UDim2.fromOffset(0, ResultHeight),
                    Text = ">",
                    TextSize = 14,
                    TextTransparency = 0.6,
                    Parent = Parent,
                })
                Order += 1
            end

            return Order
        end

        local function GetSearchRowKey(Result)
            local Parts = { Result.Tab.Name }
            for _, Step in Result.Chain do
                table.insert(Parts, tostring(Step.Name))
            end
            table.insert(Parts, Result.Text)
            return table.concat(Parts, " > ")
        end

        local function BuildSearchRow(Result, Key)
            local Entry = { Key = Key, Result = Result }

            local Row = New("TextButton", {
                AutoButtonColor = false,
                BackgroundColor3 = "MainColor",
                ClipsDescendants = true,
                Size = UDim2.new(1, 0, 0, ResultHeight),
                Text = "",
                Visible = false,
                Parent = SearchResults,
            })
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius / 2),
                Parent = Row,
            })

            local Content = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Parent = Row,
            })
            New("UIListLayout", {
                FillDirection = Enum.FillDirection.Horizontal,
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder,
                VerticalAlignment = Enum.VerticalAlignment.Center,
                Parent = Content,
            })
            New("UIPadding", {
                PaddingLeft = UDim.new(0, 10),
                PaddingRight = UDim.new(0, 10),
                Parent = Content,
            })

            local Order = AddSegment(Content, 0, Result.Tab.Name, Result.Tab.Icon)
            for _, Step in Result.Chain do
                if typeof(Step.Name) == "string" and Trim(Step.Name) ~= "" then
                    Order = AddSegment(Content, Order, Step.Name, Step.Icon)
                end
            end
            AddSegment(Content, Order, Result.Text, nil, true)

            Row.MouseEnter:Connect(function()
                TweenService:Create(Row, Library.TweenInfo, {
                    BackgroundColor3 = Library.Scheme.OutlineColor,
                }):Play()
            end)
            Row.MouseLeave:Connect(function()
                TweenService:Create(Row, Library.TweenInfo, {
                    BackgroundColor3 = Library.Scheme.MainColor,
                }):Play()
            end)
            Row.MouseButton1Click:Connect(function()
                OpenSearchResult(Entry.Result)
            end)

            Entry.Row = Row
            return Entry
        end

        Library.SearchResultsHandler = function(Results)
            SearchResultsList = Results
            SearchResults.CanvasPosition = Vector2.zero

            local Shown = {}
            for Index, Result in Results do
                local Target = Result.Target
                local Key = GetSearchRowKey(Result)
                local Entry = SearchRowCache[Target]

                if Entry and Entry.Key ~= Key then
                    DestroySearchRow(Entry.Row)
                    Entry = nil
                end
                if not Entry then
                    Entry = BuildSearchRow(Result, Key)
                    SearchRowCache[Target] = Entry
                end

                Entry.Result = Result
                Entry.Row.LayoutOrder = Index
                Entry.Row.Visible = true
                Shown[Target] = true
            end

            for Target, Entry in SearchRowCache do
                if not Target.Parent then
                    DestroySearchRow(Entry.Row)
                    SearchRowCache[Target] = nil
                elseif not Shown[Target] and Entry.Row.Visible then
                    Entry.Row.Visible = false
                    Entry.Row.BackgroundColor3 = Library.Scheme.MainColor
                end
            end

            if #Results == 0 then
                HideSearchResults()
                return
            end

            PlaceSearchResults()
            SearchResults.Visible = Library.Toggled ~= false
        end

        Library:GiveSignal(SearchBox:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
            if SearchResults.Visible then
                PlaceSearchResults()
            end
        end))
        Library:GiveSignal(SearchBox:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
            if SearchResults.Visible then
                PlaceSearchResults()
            end
        end))
        Library:GiveSignal(SearchBox:GetPropertyChangedSignal("Visible"):Connect(function()
            if not SearchBox.Visible then
                HideSearchResults()
            end
        end))

        --// Enter jumps to the best match; clicking anywhere else dismisses the list \\--
        Library:GiveSignal(SearchBox.FocusLost:Connect(function(EnterPressed)
            if EnterPressed and SearchResultsList[1] then
                OpenSearchResult(SearchResultsList[1])
            end
        end))
        Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input)
            if not SearchResults.Visible or not IsClickInput(Input) then
                return
            end

            local Position = Vector2.new(Input.Position.X, Input.Position.Y)
            if Library:MouseIsOverFrame(SearchResults, Position) or Library:MouseIsOverFrame(SearchBox, Position) then
                return
            end

            HideSearchResults()
        end))
        Library:GiveSignal(SearchBox.Focused:Connect(function()
            if #SearchResultsList > 0 then
                PlaceSearchResults()
                SearchResults.Visible = true
            end
        end))

        --// Minimize (Dynamic Island) \\--
        local MinimizeButton = New("ImageButton", {
            AnchorPoint = Vector2.new(1, 0.5),
            BackgroundTransparency = 1,
            ImageColor3 = "OutlineColor",
            Position = UDim2.new(1, -10, 0.5, 0),
            Size = UDim2.fromOffset(24, 24),
            Parent = TopBar,
        })
        local MinimizeIcon = Library:GetIcon("minimize-2")
        if MinimizeIcon then
            Library:ApplyLucideIcon(MinimizeButton, MinimizeIcon)
        end
        MinimizeButton.MouseEnter:Connect(function()
            TweenService:Create(MinimizeButton, Library.TweenInfo, {
                ImageColor3 = Library.Scheme.FontColor,
            }):Play()
        end)
        MinimizeButton.MouseLeave:Connect(function()
            TweenService:Create(MinimizeButton, Library.TweenInfo, {
                ImageColor3 = Library.Scheme.OutlineColor,
            }):Play()
        end)

        local IslandBusy = false
        local IslandDragging = false
        local IslandHovered = false
        local IslandPressed = false
        local IslandCenter -- remembered pill center (screen offset), nil = top center

        local Island = New("TextButton", {
            AutoButtonColor = false,
            BackgroundColor3 = Color3.new(0, 0, 0),
            ClipsDescendants = true,
            Name = "DynamicIsland",
            Text = "",
            Visible = false,
            ZIndex = 50,
            Parent = ScreenGui,
        })
        local IslandCorner = New("UICorner", {
            CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
            Parent = Island,
        })
        local IslandStroke = New("UIStroke", {
            Color = "OutlineColor",
            Transparency = 0.6,
            Parent = Island,
        })
        local IslandContent = New("CanvasGroup", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromScale(1, 1),
            ZIndex = 51,
            Parent = Island,
        })
        New("UIListLayout", {
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            Padding = UDim.new(0, 8),
            Parent = IslandContent,
        })
        local IslandContentScale = New("UIScale", {
            Parent = IslandContent,
        })
        local IslandIcon = New("ImageLabel", {
            BackgroundTransparency = 1,
            ImageTransparency = 1,
            Size = UDim2.fromOffset(18, 18),
            Visible = false,
            ZIndex = 52,
            Parent = IslandContent,
        })
        New("UICorner", {
            CornerRadius = UDim.new(0, 4),
            Parent = IslandIcon,
        })
        local IslandTitle = New("TextLabel", {
            AutomaticSize = Enum.AutomaticSize.X,
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(0, 1),
            Text = WindowInfo.Title,
            TextColor3 = Color3.new(1, 1, 1),
            TextSize = 14,
            TextTransparency = 1,
            ZIndex = 52,
            Parent = IslandContent,
        })

        --// Expanded card shown while hovering, like the iOS island growing into a live activity \\--
        local ExpandedW, ExpandedH, ExpandedPad, ExpandedRadius = 320, 114, 22, 30
        local IslandExpanded = New("CanvasGroup", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            GroupTransparency = 1,
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(ExpandedW, ExpandedH),
            Visible = false,
            ZIndex = 51,
            Parent = Island,
        })
        local IslandExpandedScale = New("UIScale", {
            Parent = IslandExpanded,
        })
        local ExpandedIcon = New("ImageLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(ExpandedPad, 20),
            Size = UDim2.fromOffset(28, 28),
            Visible = false,
            ZIndex = 52,
            Parent = IslandExpanded,
        })
        New("UICorner", {
            CornerRadius = UDim.new(0, 6),
            Parent = ExpandedIcon,
        })
        local ExpandedTitle = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(62, 18),
            Size = UDim2.new(1, -150, 0, 17),
            Text = WindowInfo.Title,
            TextColor3 = Color3.new(1, 1, 1),
            TextSize = 15,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 52,
            Parent = IslandExpanded,
        })
        local ExpandedHint = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(62, 36),
            Size = UDim2.new(1, -150, 0, 14),
            Text = "Click to open \u{00B7} drag to move",
            TextColor3 = Color3.fromRGB(150, 150, 155),
            TextSize = 12,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 52,
            Parent = IslandExpanded,
        })
        local ExpandedClock = New("TextLabel", {
            AnchorPoint = Vector2.new(1, 0),
            BackgroundTransparency = 1,
            Position = UDim2.new(1, -ExpandedPad, 0, 18),
            Size = UDim2.fromOffset(60, 17),
            Text = "",
            TextColor3 = Color3.new(1, 1, 1),
            TextSize = 15,
            TextXAlignment = Enum.TextXAlignment.Right,
            ZIndex = 52,
            Parent = IslandExpanded,
        })
        New("Frame", {
            BackgroundColor3 = Color3.new(1, 1, 1),
            BackgroundTransparency = 0.88,
            BorderSizePixel = 0,
            Position = UDim2.fromOffset(ExpandedPad, 62),
            Size = UDim2.new(1, -ExpandedPad * 2, 0, 1),
            ZIndex = 52,
            Parent = IslandExpanded,
        })
        local ExpandedStatsRow = New("Frame", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(ExpandedPad, 72),
            Size = UDim2.new(1, -ExpandedPad * 2, 0, 31),
            ZIndex = 52,
            Parent = IslandExpanded,
        })

        local ExpandedStats = {}
        local StatAlignments = { Enum.TextXAlignment.Left, Enum.TextXAlignment.Center, Enum.TextXAlignment.Right }
        for Index, Caption in { "FPS", "PING", "PLAYERS" } do
            local Alignment = StatAlignments[Index]
            local Column = New("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.fromScale((Index - 1) / 3, 0),
                Size = UDim2.fromScale(1 / 3, 1),
                ZIndex = 52,
                Parent = ExpandedStatsRow,
            })
            New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 12),
                Text = Caption,
                TextColor3 = Color3.fromRGB(150, 150, 155),
                TextSize = 11,
                TextXAlignment = Alignment,
                ZIndex = 52,
                Parent = Column,
            })
            ExpandedStats[Caption] = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(0, 14),
                Size = UDim2.new(1, 0, 0, 17),
                Text = "-",
                TextColor3 = Color3.new(1, 1, 1),
                TextSize = 15,
                TextXAlignment = Alignment,
                ZIndex = 52,
                Parent = Column,
            })
        end

        SetIslandIcon = function(IconName)
            local Icon = Library:GetCustomIcon(IconName)
            IslandIcon.Visible = Icon ~= nil
            ExpandedIcon.Visible = Icon ~= nil
            if Icon then
                Library:ApplyLucideIcon(IslandIcon, Icon)
                Library:ApplyLucideIcon(ExpandedIcon, Icon)
                -- lucide icons are monochrome; tint them white to sit on the black pill
                if typeof(IconName) == "string" and Library:GetIcon(IconName) then
                    IslandIcon.ImageColor3 = Color3.new(1, 1, 1)
                    ExpandedIcon.ImageColor3 = Color3.new(1, 1, 1)
                end
            end
            local TextX = Icon and 62 or ExpandedPad
            ExpandedTitle.Position = UDim2.fromOffset(TextX, 18)
            ExpandedHint.Position = UDim2.fromOffset(TextX, 36)
        end
        SetIslandIcon(WindowInfo.IslandIcon or WindowInfo.Icon or "sparkles")

        --// Spring physics: every dimension is a damped spring so the island moves like liquid \\--
        local Springs = {
            X = { P = 0, V = 0, T = 0, K = 230, D = 22 },
            Y = { P = 0, V = 0, T = 0, K = 230, D = 22 },
            W = { P = 0, V = 0, T = 0, K = 170, D = 13 }, -- looser so width wobbles like jelly
            H = { P = 0, V = 0, T = 0, K = 300, D = 19 },
            R = { P = 0, V = 0, T = 0, K = 200, D = 24 }, -- roundness: 0 = window corners, 1 = pill
            E = { P = 0, V = 0, T = 0, K = 220, D = 26 }, -- expansion: 0 = compact pill, 1 = hover card
        }
        local IslandExpandWanted = false -- hover has lingered long enough to open the card

        local function SetSpring(Spring, Target, Snap)
            Spring.T = Target
            if Snap then
                Spring.P, Spring.V = Target, 0
            end
        end

        local function SpringsSettled()
            for _, Spring in Springs do
                if math.abs(Spring.T - Spring.P) > 0.75 or math.abs(Spring.V) > 6 then
                    return false
                end
            end
            return true
        end

        local function GetMainRect()
            local Offset = ScreenGui.AbsolutePosition
            local Pos, Size = MainFrame.AbsolutePosition - Offset, MainFrame.AbsoluteSize
            return Pos.X + Size.X / 2, Pos.Y + Size.Y / 2, Size.X, Size.Y
        end

        local function GetPillSize()
            local Scale = Library.DPIScale
            local IconWidth = IslandIcon.Visible and 26 or 0
            return math.clamp(IslandTitle.TextBounds.X + IconWidth + 48, 120, 340) * Scale, 36 * Scale
        end

        local function ClampCenter(X, Y, W, H)
            local Screen = ScreenGui.AbsoluteSize
            return math.clamp(X, W / 2, math.max(W / 2, Screen.X - W / 2)),
                math.clamp(Y, H / 2, math.max(H / 2, Screen.Y - H / 2))
        end

        local function GetExpandedSize()
            local PillW = GetPillSize()
            return math.max(PillW, ExpandedW * Library.DPIScale), ExpandedH * Library.DPIScale
        end

        local function GetPillCenter()
            local W, H = GetPillSize()
            if IslandCenter then
                return ClampCenter(IslandCenter.X, IslandCenter.Y, W, H)
            end
            return ScreenGui.AbsoluteSize.X / 2, 12 * Library.DPIScale + H / 2
        end

        local function SetPillTargets(Snap)
            local W, H = GetPillSize()
            local X, Y = GetPillCenter()
            local Expand = IslandExpandWanted and IslandHovered and not IslandPressed and not IslandDragging
            if Expand then
                -- grow downward from the pill's top edge, like the real island
                local EW, EH = GetExpandedSize()
                X, Y = ClampCenter(X, Y - H / 2 + EH / 2, EW, EH)
                W, H = EW, EH
            else
                local Scale = (IslandPressed and 0.92) or (IslandHovered and 1.06) or 1
                W, H = W * Scale, H * Scale
            end
            SetSpring(Springs.X, X, Snap)
            SetSpring(Springs.Y, Y, Snap)
            SetSpring(Springs.W, W)
            SetSpring(Springs.H, H)
            SetSpring(Springs.R, 1)
            SetSpring(Springs.E, Expand and 1 or 0)
        end

        local FrameRate, StatsClock = 60, 0
        local function UpdateExpandedStats()
            ExpandedClock.Text = os.date("%H:%M")
            ExpandedStats.FPS.Text = tostring(math.round(FrameRate))
            local Ok, Ping = pcall(LocalPlayer.GetNetworkPing, LocalPlayer)
            ExpandedStats.PING.Text = Ok and string.format("%d ms", math.round(Ping * 1000)) or "-"
            ExpandedStats.PLAYERS.Text = string.format("%d / %d", #Players:GetPlayers(), Players.MaxPlayers)
        end

        Library:GiveSignal(RunService.RenderStepped:Connect(function(DeltaTime)
            if not Island.Visible then
                return
            end

            FrameRate += (1 / math.max(DeltaTime, 1e-3) - FrameRate) * math.min(DeltaTime * 4, 1)

            -- fixed substeps keep the springs stable on low framerates
            local Steps = math.clamp(math.ceil(DeltaTime / (1 / 240)), 1, 16)
            local Step = math.min(DeltaTime, 1 / 15) / Steps
            for _ = 1, Steps do
                for _, Spring in Springs do
                    local Accel = Spring.K * (Spring.T - Spring.P) - Spring.D * Spring.V
                    Spring.V += Accel * Step
                    Spring.P += Spring.V * Step
                end
            end

            local X, Y, W, H = Springs.X.P, Springs.Y.P, Springs.W.P, Springs.H.P
            local Round = math.clamp(Springs.R.P, 0, 1)

            -- stretch along the direction of travel, squash across it (only once it's a blob)
            local SpeedX = math.abs(Springs.X.V)
            local SpeedY = math.abs(Springs.Y.V)
            local StretchX = math.clamp(SpeedX / 2500, 0, 0.3) - math.clamp(SpeedY / 5000, 0, 0.12)
            local StretchY = math.clamp(SpeedY / 2500, 0, 0.3) - math.clamp(SpeedX / 5000, 0, 0.12)
            W = math.max(4, W * (1 + StretchX * Round))
            H = math.max(4, H * (1 + StretchY * Round))

            Island.Position = UDim2.fromOffset(X - W / 2, Y - H / 2)
            Island.Size = UDim2.fromOffset(W, H)
            -- the card keeps softer, fixed corners instead of a full pill so its content has room
            local Expand = math.clamp(Springs.E.P, 0, 1)
            local PillRadius = math.min(W, H) / 2
            PillRadius += (math.min(PillRadius, ExpandedRadius * Library.DPIScale) - PillRadius) * Expand
            IslandCorner.CornerRadius = UDim.new(0, WindowInfo.CornerRadius + (PillRadius - WindowInfo.CornerRadius) * Round)

            -- scale content against the shape the island is morphing toward so it never balloons mid-expand
            local PillW, PillH = GetPillSize()
            local EW, EH = GetExpandedSize()
            local ShapeW, ShapeH = PillW + (EW - PillW) * Expand, PillH + (EH - PillH) * Expand
            local Fit = math.clamp(math.min(W / ShapeW, H / ShapeH), 0.6, 1.15)
            IslandContentScale.Scale = Library.DPIScale * Fit
            IslandExpandedScale.Scale = Library.DPIScale * math.min(Fit, 1) * (0.92 + 0.08 * Expand)

            -- crossfade: the pill row leaves quickly, the card arrives once there's room for it
            IslandContent.GroupTransparency = math.clamp(Expand * 2.5, 0, 1)
            IslandExpanded.GroupTransparency = 1 - math.clamp((Expand - 0.4) / 0.6, 0, 1)
            IslandExpanded.Visible = Expand > 0.4
            if IslandExpanded.Visible then
                StatsClock -= DeltaTime
                if StatsClock <= 0 then
                    StatsClock = 0.5
                    UpdateExpandedStats()
                end
            end
        end))

        local FadeInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        local ColorInfo = TweenInfo.new(0.35, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

        local function FadeContent(Transparency)
            TweenService:Create(IslandTitle, FadeInfo, { TextTransparency = Transparency }):Play()
            local IconTween = TweenService:Create(IslandIcon, FadeInfo, { ImageTransparency = Transparency })
            IconTween:Play()
            return IconTween
        end

        local function WaitForSettle(Timeout, Threshold)
            local Start = os.clock()
            while os.clock() - Start < Timeout do
                if SpringsSettled() or (Threshold and Threshold()) then
                    return
                end
                RunService.RenderStepped:Wait()
            end
        end

        local function MinimizeToIsland()
            if IslandMinimized or IslandBusy then
                return
            end
            IslandMinimized, IslandBusy = true, true
            IslandTitle.Text = WindowInfo.Title
            ExpandedTitle.Text = WindowInfo.Title

            local X, Y, W, H = GetMainRect()
            SetSpring(Springs.X, X, true)
            SetSpring(Springs.Y, Y, true)
            SetSpring(Springs.W, W, true)
            SetSpring(Springs.H, H, true)
            SetSpring(Springs.R, 0, true)
            SetSpring(Springs.E, 0, true)
            Island.BackgroundColor3 = MainFrame.BackgroundColor3
            Island.Visible = true
            MainFrame.Visible = false
            TooltipLabel.Visible = false

            -- pinch the height first so it collapses like a drop before spreading into a pill
            Springs.H.V = -H * 6
            SetPillTargets(false)
            TweenService:Create(Island, ColorInfo, { BackgroundColor3 = Color3.new(0, 0, 0) }):Play()

            WaitForSettle(0.6, function()
                return math.abs(Springs.W.T - Springs.W.P) < Springs.W.T * 0.15
            end)
            FadeContent(0)
            IslandBusy = false
        end

        local function RestoreFromIsland()
            if not IslandMinimized or IslandBusy then
                return
            end
            IslandBusy, IslandPressed, IslandHovered, IslandExpandWanted = true, false, false, false

            SetSpring(Springs.E, 0)
            FadeContent(1).Completed:Wait()

            local X, Y, W, H = GetMainRect()
            SetSpring(Springs.X, X)
            SetSpring(Springs.Y, Y)
            SetSpring(Springs.W, W)
            SetSpring(Springs.H, H)
            SetSpring(Springs.R, 0)
            TweenService:Create(Island, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
                BackgroundColor3 = MainFrame.BackgroundColor3,
            }):Play()

            -- reveal the window as soon as the blob is roughly in place instead of waiting out the wobble
            WaitForSettle(0.6, function()
                return math.abs(Springs.W.T - Springs.W.P) < W * 0.08 and math.abs(Springs.H.T - Springs.H.P) < H * 0.08
                    and math.abs(Springs.X.T - Springs.X.P) < 8 and math.abs(Springs.Y.T - Springs.Y.P) < 8
            end)

            MainFrame.Visible = Library.Toggled
            TweenService:Create(IslandStroke, FadeInfo, { Transparency = 1 }):Play()
            local RevealTween = TweenService:Create(Island, TweenInfo.new(0.15, Enum.EasingStyle.Quad), {
                BackgroundTransparency = 1,
            })
            RevealTween:Play()
            RevealTween.Completed:Wait()

            Island.Visible = false
            Island.BackgroundTransparency = 0
            IslandStroke.Transparency = 0.6
            IslandMinimized, IslandBusy = false, false
        end

        DismissIsland = function()
            Island.Visible = false
            IslandTitle.TextTransparency = 1
            IslandIcon.ImageTransparency = 1
            IslandMinimized, IslandBusy, IslandDragging, IslandPressed, IslandHovered = false, false, false, false, false
            IslandExpandWanted = false
            SetSpring(Springs.E, 0, true)
        end

        local function RefreshPill()
            if IslandMinimized and not IslandBusy then
                SetPillTargets(false)
            end
        end

        -- a short linger before opening keeps the card from flickering when the cursor just passes over
        local HoverToken = 0
        Island.MouseEnter:Connect(function()
            IslandHovered = true
            HoverToken += 1
            local Token = HoverToken
            TweenService:Create(IslandStroke, FadeInfo, { Transparency = 0.2 }):Play()
            RefreshPill()
            task.delay(0.15, function()
                if Token == HoverToken and IslandHovered and IslandMinimized then
                    IslandExpandWanted = true
                    StatsClock = 0
                    RefreshPill()
                end
            end)
        end)
        Island.MouseLeave:Connect(function()
            IslandHovered, IslandExpandWanted = false, false
            HoverToken += 1
            TweenService:Create(IslandStroke, FadeInfo, { Transparency = 0.6 }):Play()
            RefreshPill()
        end)

        --// Dragging: a press that moves past a small threshold drags, otherwise it restores \\--
        local DragStartInput, DragStartCenter
        Island.InputBegan:Connect(function(Input: InputObject)
            if not IsClickInput(Input) or not IslandMinimized or IslandBusy then
                return
            end
            IslandPressed, IslandDragging = true, false
            DragStartInput = Input.Position
            DragStartCenter = Vector2.new(GetPillCenter())
            RefreshPill()
        end)

        Library:GiveSignal(UserInputService.InputChanged:Connect(function(Input: InputObject)
            if not IslandPressed or not IsMovementInput(Input) then
                return
            end
            local Delta = Vector2.new(Input.Position.X, Input.Position.Y) - Vector2.new(DragStartInput.X, DragStartInput.Y)
            if not IslandDragging and Delta.Magnitude < 5 then
                return
            end
            IslandDragging = true
            local W, H = GetPillSize()
            local X, Y = ClampCenter(DragStartCenter.X + Delta.X, DragStartCenter.Y + Delta.Y, W, H)
            IslandCenter = Vector2.new(X, Y)
            SetSpring(Springs.X, X)
            SetSpring(Springs.Y, Y)
        end))

        Library:GiveSignal(UserInputService.InputEnded:Connect(function(Input: InputObject)
            if not IslandPressed or not IsMouseInput(Input) then
                return
            end
            local WasDragging = IslandDragging
            IslandPressed, IslandDragging = false, false
            if WasDragging then
                RefreshPill()
            else
                task.spawn(RestoreFromIsland)
            end
        end))

        MinimizeButton.MouseButton1Click:Connect(function()
            task.spawn(MinimizeToIsland)
        end)

        --// Bottom Bar \\--
        local BottomClip = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundTransparency = 1,
            ClipsDescendants = true,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 20),
            ZIndex = 3,
            Parent = MainFrame,
        })

        BottomBackground = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundColor3 = function()
                return Library:GetBetterColor(Library.Scheme.BackgroundColor, 4)
            end,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, math.max(20, WindowInfo.CornerRadius * 2)),
            ZIndex = 3,
            Parent = BottomClip,
        })
        Library:MakeLine(MainFrame, {
            AnchorPoint = Vector2.new(0, 1),
            Position = UDim2.new(0, 0, 1, -20),
            Size = UDim2.new(1, 0, 0, 1),
            ZIndex = 3,
        })

        local BottomBar = New("Frame", {
            AnchorPoint = Vector2.new(0, 1),
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0, 1),
            Size = UDim2.new(1, 0, 0, 20),
            ZIndex = 4,
            Parent = MainFrame,
        })
        BottomBackgroundCorner = New("UICorner", {
            TopLeftRadius = UDim.new(0, 0),
            TopRightRadius = UDim.new(0, 0),
            BottomLeftRadius = UDim.new(0, WindowInfo.CornerRadius),
            BottomRightRadius = UDim.new(0, WindowInfo.CornerRadius),
            Parent = BottomBackground,
        })

        --// Footer \\-
        FooterLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = WindowInfo.Footer,
            TextSize = 14,
            TextTransparency = 0.5,
            Parent = BottomBar,
        })

        --// Resize Button \\--
        if WindowInfo.Resizable then
            ResizeButton = New("TextButton", {
                AnchorPoint = Vector2.new(1, 0),
                BackgroundTransparency = 1,
                Position = UDim2.new(1, -WindowInfo.CornerRadius / 4, 0, 0),
                Size = UDim2.fromScale(1, 1),
                SizeConstraint = Enum.SizeConstraint.RelativeYY,
                Text = "",
                Parent = BottomBar,
            })

            Library:MakeResizable(MainFrame, ResizeButton, function()
                for _, Tab in Library.Tabs do
                    Tab:Resize(true)
                end
            end)
        end

        local WindowResizeIcon = New("ImageLabel", {
            ImageColor3 = "FontColor",
            ImageTransparency = 0.5,
            Position = UDim2.fromOffset(2, 2),
            Size = UDim2.new(1, -4, 1, -4),
            Parent = ResizeButton,
        })
        if ResizeIcon then
            Library:ApplyLucideIcon(WindowResizeIcon, ResizeIcon)
        end

        --// Tabs \\--
        Tabs = New("ScrollingFrame", {
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            BackgroundColor3 = "BackgroundColor",
            CanvasSize = UDim2.fromScale(0, 0),
            Position = UDim2.fromOffset(0, 49),
            ScrollBarImageTransparency = 1,
            ScrollBarThickness = 0,
            Size = UDim2.new(0, InitialLeftWidth, 1, -70),
            Parent = MainFrame,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, TabButtonsStyle.Gap),
            Parent = Tabs,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, TabButtonsStyle.Padding),
            PaddingLeft = UDim.new(0, TabButtonsStyle.Padding),
            PaddingRight = UDim.new(0, TabButtonsStyle.Padding),
            PaddingTop = UDim.new(0, TabButtonsStyle.Padding),
            Parent = Tabs,
        })

        --// Container \\--
        Container = New("Frame", {
            AnchorPoint = Vector2.new(1, 0),
            BackgroundColor3 = function()
                return Library:GetBetterColor(Library.Scheme.BackgroundColor, 1)
            end,
            ClipsDescendants = true,
            Name = "Container",
            Position = UDim2.new(1, 0, 0, 49),
            Size = UDim2.new(1, -InitialLeftWidth - 1, 1, -70),
            Parent = MainFrame,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 0),
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6),
            PaddingTop = UDim.new(0, 0),
            Parent = Container,
        })

        Library.WindowContainer = Container
    end

    --// Window Table \\--
    local Window = {}
    local Fading = false

    local function SetUICorner(UICorner, Corner, HalfValue)
        local Current = UICorner[Corner]
        if Current.Offset == 0 and Current.Scale == 0 then
            return
        end

        UICorner[Corner] = HalfValue
    end

    function Window:ChangeTitle(title)
        assert(typeof(title) == "string", "Expected string for title got: " .. typeof(title))

        WindowTitle.Text = title
        WindowInfo.Title = title
        RefreshWindowTitleSize()
    end

    function Window:SetSubtitle(Subtitle: string?)
        WindowInfo.Subtitle = Subtitle
        WindowSubtitle.Text = Subtitle or ""
        WindowSubtitle.Visible = typeof(Subtitle) == "string" and Subtitle ~= ""
        RefreshWindowTitleSize()
    end

    function Window:SetIslandIcon(Icon: string | number)
        WindowInfo.IslandIcon = Icon
        if SetIslandIcon then
            SetIslandIcon(Icon)
        end
    end

    function Window:RefreshTitleSize()
        RefreshWindowTitleSize()
    end

    function Window:SetBackgroundImage(Image: string)
        local ValidIcon = false

        if typeof(Image) == "string" then
            local BackgroundIcon = Library:GetCustomIcon(Image)

            if BackgroundIcon then
                ValidIcon = true

                Library:ApplyLucideIcon(BackgroundImage, BackgroundIcon)
            elseif Image:match("http://") or Image:match("https://") then
                local RawFileName = Image:match("(.+)%..+$")
                local _, Domain = Image:match("^(https?://)([^/]+)");

                if RawFileName and Domain then
                    local Extention = string.sub(Image, #RawFileName + 1, #Image)
                    local FileNamePos = RawFileName:gsub("\\", "/"):find("/[^/]*$")
                    local FileName = FileNamePos and Image:sub(FileNamePos + 1) or nil

                    if FileName then
                        ValidIcon = true

                        local AssetName = Domain .. FileName
                        if #AssetName > 255 then
                            local NewLength = 255 - #Domain - #Extention
                            if NewLength < 0 then
                                AssetName = Domain .. Extention
                            else
                                AssetName = Domain .. string.sub(FileName:sub(1, #FileName - #Extention), 1, NewLength) .. Extention
                            end
                        end

                        if CustomImageManagerAssets[FileName] == nil then
                            CustomImageManager.AddAsset(FileName, 0, Image)
                        else
                            CustomImageManager.DownloadAsset(FileName, true)
                        end

                        BackgroundImage.Image = CustomImageManager.GetAsset(FileName)
                        BackgroundImage.ImageRectOffset = Vector2.zero
                        BackgroundImage.ImageRectSize = Vector2.zero
                    end
                end
            end
        end

        if not ValidIcon then
            BackgroundImage.Image = ""
            BackgroundImage.ImageRectOffset = Vector2.zero
            BackgroundImage.ImageRectSize = Vector2.zero
        end

        HasBackgroundImage = ValidIcon
        WindowInfo.BackgroundImage = Image
    end

    function Window:SetFooter(Footer: string)
        assert(typeof(Footer) == "string", "Expected string for footer got: " .. typeof(Footer))

        FooterLabel.Text = Footer
        WindowInfo.Footer = Footer
    end

    function Window:SetAlwaysOnTop(Enabled: boolean)
        WindowInfo.AlwaysOnTop = Enabled == true
        SetAlwaysOnTop(Library.ScreenGui, WindowInfo.AlwaysOnTop)
    end

    function Window:SetSnapping(Enabled: boolean, Distance: number?, Margin: number?, AvoidCoreGui: boolean?)
        WindowInfo.Snapping = Enabled == true
        WindowSnapConfig.Enabled = WindowInfo.Snapping

        if Distance then
            WindowInfo.SnapDistance = math.max(0, Distance)
            WindowSnapConfig.Distance = WindowInfo.SnapDistance
        end

        if Margin then
            WindowInfo.SnapMargin = math.max(0, Margin)
            WindowSnapConfig.Margin = WindowInfo.SnapMargin
        end

        if AvoidCoreGui ~= nil then
            WindowInfo.SnapAvoidCoreGui = AvoidCoreGui == true
            WindowSnapConfig.AvoidCoreGui = WindowInfo.SnapAvoidCoreGui
        end
    end

    function Window:SetCornerRadius(Radius: number)
        assert(typeof(Radius) == "number", "Expected number for Radius got: " .. typeof(Radius))
        Radius = math.min(Radius, 20)

        local RadiusHalf = UDim.new(0, Radius / 2)
        local RadiusUDim = UDim.new(0, Radius)
        local HalfCurrent = Library.CornerRadius / 2

        for _, UICorner in Library.Corners do
            if math.abs(UICorner.CornerRadius.Offset - HalfCurrent) < 0.001 then
                UICorner.CornerRadius = RadiusHalf
            else
                UICorner.CornerRadius = RadiusUDim
            end
        end

        for _, UICorner in Library.SpecificCorners do
            SetUICorner(UICorner, "TopRightRadius", RadiusHalf)
            SetUICorner(UICorner, "TopLeftRadius", RadiusHalf)
            SetUICorner(UICorner, "BottomRightRadius", RadiusHalf)
            SetUICorner(UICorner, "BottomLeftRadius", RadiusHalf)
        end

        Library.CornerRadius = Radius
        WindowInfo.CornerRadius = Radius

        if ResizeButton then
            ResizeButton.Position = UDim2.new(1, -Radius / 4, 0, 0)
        end
        if BottomBackgroundCorner then
            BottomBackground.Size = UDim2.new(1, 0, 0, math.max(20, Radius * 2))
            BottomBackgroundCorner.BottomLeftRadius = RadiusUDim
            BottomBackgroundCorner.BottomRightRadius = RadiusUDim
        end

        for _, Menu in Library.ContextMenus do
            if Menu.Destroyed then
                continue
            end

            if typeof(Menu.ActiveCallback) ~= "function" then
                continue
            end

            if not Menu.Active then
                local HolderActive = false
                for _, Other in Library.ContextMenus do
                    if Other == Menu then 
                        continue
                    end
   
                    if Other.Active and Other.Holder == Menu.Holder then
                        HolderActive = true
                        break
                    end
                end

                if HolderActive then
                    continue
                end

                Menu.ActiveCallback(false)
                continue
            end

            Menu.ActiveCallback(true)
        end

        for _, Option in Options do
            if Option.Type == "Dropdown" and Option.RefreshPool then
                Option:RefreshPool()
            end
        end

        for _, Tab in Library.Tabs do
            for _, Tabbox in Tab.Tabboxes do
                Tabbox:UpdateCorners()
            end
        end
    end

    function Window:SetAnimations(Animations: { [string]: boolean }?, TabTransitionTime: number?, TabSwipeOffset: number?, TabSwipeFrom: ("left" | "right" | "top" | "bottom" | string)?)
        if typeof(Animations) == "table" then
            WindowInfo.Animations = Animations
            Library.Animations = Animations
        end

        if typeof(TabTransitionTime) == "number" then
            local TweenInfo = TweenInfo.new(
                math.max(0, TabTransitionTime or 0.22),
                Enum.EasingStyle.Quad,
                Enum.EasingDirection.Out
            )

            WindowInfo.TabTransitionInfo = TweenInfo
            Library.TabTransitionInfo = TweenInfo
        end

        if typeof(TabSwipeOffset) == "number" then
            TabSwipeOffset = math.max(1, TabSwipeOffset)

            WindowInfo.TabSwipeOffset = TabSwipeOffset
            Library.TabSwipeOffset = TabSwipeOffset
        end

        if typeof(TabSwipeFrom) == "string" then
            TabSwipeFrom = string.lower(TabSwipeFrom)

            WindowInfo.TabSwipeFrom = TabSwipeFrom
            Library.TabSwipeFrom = TabSwipeFrom
        end
    end

    local function ApplyCompact()
        IsCompact = Window:GetSidebarWidth() == WindowInfo.SidebarCompactWidth
        if WindowInfo.DisableCompactingSnap then
            IsCompact = Window:GetSidebarWidth() <= WindowInfo.CompactWidthActivation
        end

        if not WindowInfo.Icon then
            WindowIcon.Visible = IsCompact
        end

        for _, Button in Library.TabButtons do
            if not Button.Icon then
                continue
            end

            Button.Label.Visible = not IsCompact
            Button.Padding.PaddingBottom = UDim.new(0, IsCompact and 6 or 11)
            Button.Padding.PaddingLeft = UDim.new(0, IsCompact and 6 or 12)
            Button.Padding.PaddingRight = UDim.new(0, IsCompact and 6 or 12)
            Button.Padding.PaddingTop = UDim.new(0, IsCompact and 6 or 11)
            Button.Icon.SizeConstraint = IsCompact and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.RelativeYY
        end
    end

    --// Bottom-pinned sidebar buttons (e.g. the Discord tab) live here, below the scrolling tab list
    local BottomTabs
    local BottomTabsHeight = 0

    function Window:IsSidebarCompacted()
        return IsCompact
    end

    function Window:SetCompact(State)
        Window:SetSidebarWidth(State and WindowInfo.SidebarCompactWidth or LastExpandedWidth)
    end

    function Window:GetSidebarWidth()
        return Tabs.Size.X.Offset
    end

    function Window:SetSidebarWidth(Width)
        Width = math.clamp(Width, 48, MainFrame.Size.X.Offset - WindowInfo.MinContainerWidth - 1)

        DividerLine.Position = UDim2.fromOffset(Width, 49)

        Tabs.Size = UDim2.new(0, Width, 1, -70 - BottomTabsHeight)
        if BottomTabs then
            BottomTabs.Size = UDim2.fromOffset(Width, BottomTabsHeight)
        end
        Container.Size = UDim2.new(1, -Width - 1, 1, -70)

        if WindowInfo.EnableCompacting then
            ApplyCompact()
        end

        --// Compact sidebars keep the title readable by letting it span the sub-tab panel too
        local TitleWidth = if IsCompact then Width + WindowInfo.SubTabWidth else Width
        TitleHolder.Size = UDim2.new(0, TitleWidth, 1, 0)
        TitleDivider.Position = UDim2.fromOffset(TitleWidth, 0)
        RightWrapper.Size = UDim2.new(1, -TitleWidth - 57 - 1, 1, -16)
    
        RefreshWindowTitleSize()
        if not IsCompact then
            LastExpandedWidth = Width
        end
    end

    function Window:AddDiscordTab(Info)
        Info = typeof(Info) == "table" and Info or { Invite = Info }

        local DiscordColor = Info.Color or Color3.fromRGB(88, 101, 242)
        local InviteCode = tostring(Info.Invite or "")
            :gsub("^https?://", "")
            :gsub("^discord%.gg/", "")
            :gsub("^discord%.com/invite/", "")
            :gsub("/$", "")
        local InviteLink = "https://discord.gg/" .. InviteCode
        local Perks = Info.Perks
            or {
                "Get notified the moment new updates drop",
                "Suggest features and report bugs directly",
                "Chat with the community and get support",
            }

        local Icon = if getcustomasset then CustomImageManager.GetAsset("DiscordIcon") else "message-circle"

        local Tab = Window:AddTab({
            Name = Info.Name or "Discord",
            Icon = Info.Icon or Icon,
            Description = Info.Description or "Join the community",
            Tooltip = Info.Tooltip,
            Order = 1e6,
        })

        --// Pin the button to the bottom of the sidebar \\--
        if not BottomTabs then
            BottomTabsHeight = 40 + TabButtonsStyle.Padding * 2

            BottomTabs = New("Frame", {
                AnchorPoint = Vector2.new(0, 1),
                BackgroundColor3 = "BackgroundColor",
                Position = UDim2.new(0, 0, 1, -21),
                Size = UDim2.fromOffset(Tabs.Size.X.Offset, BottomTabsHeight),
                Parent = MainFrame,
            })
            New("Frame", {
                BackgroundColor3 = "OutlineColor",
                Position = UDim2.fromOffset(TabButtonsStyle.Padding, 0),
                Size = UDim2.new(1, -TabButtonsStyle.Padding * 2, 0, 1),
                Parent = BottomTabs,
            })
            --// Buttons go in their own frame so the list layout doesn't stack the divider like a button
            local BottomTabsList = New("Frame", {
                BackgroundTransparency = 1,
                Name = "List",
                Size = UDim2.fromScale(1, 1),
                Parent = BottomTabs,
            })
            New("UIListLayout", {
                Padding = UDim.new(0, TabButtonsStyle.Gap),
                VerticalAlignment = Enum.VerticalAlignment.Bottom,
                Parent = BottomTabsList,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, TabButtonsStyle.Padding),
                PaddingLeft = UDim.new(0, TabButtonsStyle.Padding),
                PaddingRight = UDim.new(0, TabButtonsStyle.Padding),
                PaddingTop = UDim.new(0, TabButtonsStyle.Padding),
                Parent = BottomTabsList,
            })

            Tabs.Size = UDim2.new(0, Tabs.Size.X.Offset, 1, -70 - BottomTabsHeight)
        end
        Tab.Button.Parent = BottomTabs.List

        --// Full page: the regular left/right columns are not used \\--
        for _, Side in Tab.Sides do
            Side.Visible = false
        end

        local Page = New("ScrollingFrame", {
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            CanvasSize = UDim2.fromScale(0, 0),
            ScrollBarImageTransparency = 1,
            ScrollBarThickness = 0,
            Size = UDim2.fromScale(1, 1),
            Parent = Tab.Container,
        })
        New("UIListLayout", {
            HorizontalAlignment = Enum.HorizontalAlignment.Center,
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = Page,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 12),
            PaddingLeft = UDim.new(0, 6),
            PaddingRight = UDim.new(0, 6),
            PaddingTop = UDim.new(0, 12),
            Parent = Page,
        })

        local function Card(Order, Height)
            local Frame = New("Frame", {
                AutomaticSize = if Height then Enum.AutomaticSize.None else Enum.AutomaticSize.Y,
                BackgroundColor3 = "MainColor",
                LayoutOrder = Order,
                Size = UDim2.new(1, 0, 0, Height or 0),
                Parent = Page,
            })
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                Parent = Frame,
            })
            Library:AddOutline(Frame)
            return Frame
        end

        --// Hero \\--
        local Hero = Card(1, 150)
        Hero.ClipsDescendants = true
        local HeroBanner = New("Frame", {
            BackgroundColor3 = DiscordColor,
            Size = UDim2.new(1, 0, 0, 64),
            Parent = Hero,
        })
        New("UICorner", {
            CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
            Parent = HeroBanner,
        })
        New("UIGradient", {
            Color = ColorSequence.new(DiscordColor, DiscordColor:Lerp(Color3.new(0, 0, 0), 0.45)),
            Rotation = 20,
            Parent = HeroBanner,
        })

        local Avatar = New("Frame", {
            BackgroundColor3 = DiscordColor,
            Position = UDim2.fromOffset(16, 30),
            Size = UDim2.fromOffset(68, 68),
            Parent = Hero,
        })
        New("UICorner", {
            CornerRadius = UDim.new(1, 0),
            Parent = Avatar,
        })
        New("UIStroke", {
            Color = "MainColor",
            Thickness = 4,
            Parent = Avatar,
        })
        local AvatarIcon = New("ImageLabel", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundTransparency = 1,
            ImageColor3 = Color3.new(1, 1, 1),
            Position = UDim2.fromScale(0.5, 0.5),
            ScaleType = Enum.ScaleType.Fit,
            Size = UDim2.fromScale(0.6, 0.6),
            Parent = Avatar,
        })
        local AvatarIconData = Library:GetCustomIcon(Icon)
        if AvatarIconData then
            Library:ApplyLucideIcon(AvatarIcon, AvatarIconData)
        end
        AvatarIcon.ImageColor3 = Color3.new(1, 1, 1)

        local ServerName = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(96, 72),
            Size = UDim2.new(1, -112, 0, 22),
            Text = Info.Title or "Join our Discord",
            TextSize = 20,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Hero,
        })

        local Stats = New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(96, 96),
            RichText = true,
            Size = UDim2.new(1, -112, 0, 16),
            Text = "discord.gg/" .. InviteCode,
            TextSize = 14,
            TextTransparency = 0.4,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Hero,
        })

        New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(16, 120),
            Size = UDim2.new(1, -32, 0, 18),
            Text = Info.Subtitle or "Updates, support and a friendly community, all in one place.",
            TextSize = 14,
            TextTransparency = 0.25,
            TextTruncate = Enum.TextTruncate.AtEnd,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = Hero,
        })

        --// Perks \\--
        local PerkCard = Card(2)
        New("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = PerkCard,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 12),
            PaddingLeft = UDim.new(0, 14),
            PaddingRight = UDim.new(0, 14),
            PaddingTop = UDim.new(0, 12),
            Parent = PerkCard,
        })
        New("TextLabel", {
            BackgroundTransparency = 1,
            LayoutOrder = 0,
            Size = UDim2.new(1, 0, 0, 16),
            Text = "WHY JOIN",
            TextSize = 13,
            TextTransparency = 0.5,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = PerkCard,
        })
        local CheckIcon = Library:GetIcon("check")
        for Index, Perk in Perks do
            local Row = New("Frame", {
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                LayoutOrder = Index,
                Size = UDim2.new(1, 0, 0, 20),
                Parent = PerkCard,
            })
            local Bullet = New("Frame", {
                BackgroundColor3 = DiscordColor,
                BackgroundTransparency = 0.75,
                Size = UDim2.fromOffset(20, 20),
                Parent = Row,
            })
            New("UICorner", {
                CornerRadius = UDim.new(1, 0),
                Parent = Bullet,
            })
            if CheckIcon then
                local BulletIcon = New("ImageLabel", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    BackgroundTransparency = 1,
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromOffset(12, 12),
                    Parent = Bullet,
                })
                Library:ApplyLucideIcon(BulletIcon, CheckIcon)
                BulletIcon.ImageColor3 = DiscordColor:Lerp(Color3.new(1, 1, 1), 0.35)
            end
            New("TextLabel", {
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(30, 1),
                Size = UDim2.new(1, -30, 0, 18),
                Text = Perk,
                TextSize = 15,
                TextWrapped = true,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = Row,
            })
        end

        --// Invite actions \\--
        local ActionCard = Card(3, 96)
        New("TextLabel", {
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(14, 10),
            Size = UDim2.new(1, -28, 0, 16),
            Text = "INVITE",
            TextSize = 13,
            TextTransparency = 0.5,
            TextXAlignment = Enum.TextXAlignment.Left,
            Parent = ActionCard,
        })

        local function ActionButton(Text, Primary, Position, Size)
            local Button = New("TextButton", {
                BackgroundColor3 = if Primary then DiscordColor else "BackgroundColor",
                Position = Position,
                Size = Size,
                Text = Text,
                TextColor3 = if Primary then Color3.new(1, 1, 1) else "FontColor",
                TextSize = 15,
                Parent = ActionCard,
            })
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                Parent = Button,
            })
            if not Primary then
                New("UIStroke", {
                    ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
                    Color = "OutlineColor",
                    Parent = Button,
                })
            end

            local Base = Button.BackgroundColor3
            Button.MouseEnter:Connect(function()
                Base = Button.BackgroundColor3
                TweenService:Create(Button, Library.TweenInfo, {
                    BackgroundColor3 = Base:Lerp(Color3.new(1, 1, 1), 0.08),
                }):Play()
            end)
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, Library.TweenInfo, {
                    BackgroundColor3 = Base,
                }):Play()
            end)

            return Button
        end

        local LinkButton = ActionButton(
            "discord.gg/" .. InviteCode,
            false,
            UDim2.fromOffset(14, 34),
            UDim2.new(0.5, -18, 0, 36)
        )
        LinkButton.Font = Enum.Font.Code
        local JoinButton = ActionButton("Join Server", true, UDim2.new(0.5, 4, 0, 34), UDim2.new(0.5, -18, 0, 36))

        local function CopyInvite()
            if setclipboard then
                pcall(setclipboard, InviteLink)
                Library:Notify({ Title = "Discord", Description = "Invite link copied to clipboard", Time = 3 })
            else
                Library:Notify({ Title = "Discord", Description = InviteLink, Time = 6 })
            end
        end

        LinkButton.MouseButton1Click:Connect(CopyInvite)
        JoinButton.MouseButton1Click:Connect(function()
            --// Ask a running Discord client to open the invite, fall back to the clipboard
            local Opened = false
            if request then
                local Success, Response = pcall(request, {
                    Url = "http://127.0.0.1:6463/rpc?v=1",
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json",
                        Origin = "https://discord.com",
                    },
                    Body = game:GetService("HttpService"):JSONEncode({
                        cmd = "INVITE_BROWSER",
                        args = { code = InviteCode },
                        nonce = game:GetService("HttpService"):GenerateGUID(false),
                    }),
                })
                Opened = Success and Response and Response.StatusCode == 200
            end

            if Opened then
                Library:Notify({ Title = "Discord", Description = "Invite opened in your Discord app", Time = 3 })
            else
                CopyInvite()
            end
        end)

        --// Live member counts \\--
        if request and InviteCode ~= "" and Info.ShowCounts ~= false then
            task.spawn(function()
                local Success, Response = pcall(request, {
                    Url = "https://discord.com/api/v10/invites/" .. InviteCode .. "?with_counts=true",
                    Method = "GET",
                })
                if not (Success and Response and Response.StatusCode == 200) then
                    return
                end

                local Ok, Data = pcall(function()
                    return game:GetService("HttpService"):JSONDecode(Response.Body)
                end)
                if not Ok or typeof(Data) ~= "table" then
                    return
                end

                if not Info.Title and Data.guild and Data.guild.name then
                    ServerName.Text = Data.guild.name
                end
                if Data.approximate_member_count then
                    Stats.Text = string.format(
                        '<font color="#23a55a">●</font> %s Online    <font color="#80848e">●</font> %s Members',
                        tostring(Data.approximate_presence_count or 0),
                        tostring(Data.approximate_member_count)
                    )
                end
            end)
        end

        Tab.Invite = InviteLink
        Tab.Page = Page
        return Tab
    end

    function Window:AddTab(...)
        local Name = nil
        local Icon = nil
        local Description = nil
        local Tooltip = nil
        local Order = nil

        if select("#", ...) == 1 and typeof(...) == "table" then
            local Info = select(1, ...)
            Name = Info.Name or "Tab"
            Icon = Info.Icon
            Description = Info.Description
            Tooltip = Info.Tooltip
            Order = Info.Order
        else
            Name = select(1, ...)
            Icon = select(2, ...)
            Description = select(3, ...)
            Order = select(4, ...)
        end

        if not tonumber(Order) then
            Order = #Tabs:GetChildren()
        end

        local TabButton: TextButton
        local TabIndicator
        local TabLabel
        local TabIcon

        local TabContainer
        local TabLeft
        local TabRight

        Icon = Library:GetCustomIcon(Icon)
        do
            TabButton = New("TextButton", {
                BackgroundColor3 = "MainColor",
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 40),
                Text = "",
                LayoutOrder = Order,
                Parent = Tabs,
            })
            New("UICorner", {
                CornerRadius = UDim.new(0, TabButtonsStyle.CornerRadius),
                Parent = TabButton,
            })

            if TabButtonsStyle.Indicator then
                TabIndicator = New("Frame", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundColor3 = "AccentColor",
                    BackgroundTransparency = 1,
                    Position = UDim2.new(0, -2, 0.5, 0),
                    Size = UDim2.fromOffset(TabButtonsStyle.IndicatorWidth, TabButtonsStyle.IndicatorHeight),
                    Parent = TabButton,
                })

                New("UICorner", {
                    CornerRadius = UDim.new(1, 0),
                    Parent = TabIndicator,
                })
            end

            local ButtonHolder = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Parent = TabButton,
            })
            local ButtonPadding = New("UIPadding", {
                PaddingBottom = UDim.new(0, IsCompact and 6 or 11),
                PaddingLeft = UDim.new(0, IsCompact and 6 or 12),
                PaddingRight = UDim.new(0, IsCompact and 6 or 12),
                PaddingTop = UDim.new(0, IsCompact and 6 or 11),
                Parent = ButtonHolder,
            })
            TabLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(30, 0),
                Size = UDim2.new(1, -30, 1, 0),
                Text = Name,
                TextSize = 16,
                TextTransparency = 0.5,
                TextXAlignment = Enum.TextXAlignment.Left,
                Visible = not IsCompact,
                Parent = ButtonHolder,
            })

            if Icon then
                TabIcon = New("ImageLabel", {
                    ImageColor3 = Icon.Custom and "WhiteColor" or "AccentColor",
                    ImageTransparency = 0.5,
                    ScaleType = Enum.ScaleType.Fit,
                    Size = UDim2.fromScale(1, 1),
                    SizeConstraint = IsCompact and Enum.SizeConstraint.RelativeXY or Enum.SizeConstraint.RelativeYY,
                    Parent = ButtonHolder,
                })
                Library:ApplyLucideIcon(TabIcon, Icon)
            end

            table.insert(Library.TabButtons, {
                Label = TabLabel,
                Padding = ButtonPadding,
                Icon = TabIcon,
            })

            --// Tab Container \\--
            TabContainer = New("Frame", {
                BackgroundTransparency = 1,
                Position = UDim2.fromScale(0, 0),
                Size = UDim2.fromScale(1, 1),
                Visible = false,
                Parent = Container,
            })

            TabLeft = New("ScrollingFrame", {
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                CanvasSize = UDim2.fromScale(0, 0),
                ScrollBarImageTransparency = 1,
                ScrollBarThickness = 0,
                Size = UDim2.new(0.5, -3, 1, 0),
                Parent = TabContainer,
            })
            New("UIListLayout", {
                Padding = UDim.new(0, 2),
                Parent = TabLeft,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 2),
                PaddingLeft = UDim.new(0, 2),
                PaddingRight = UDim.new(0, 2),
                PaddingTop = UDim.new(0, 2),
                Parent = TabLeft,
            })
            do
                New("Frame", {
                    BackgroundTransparency = 1,
                    LayoutOrder = -1,
                    Parent = TabLeft,
                })
                New("Frame", {
                    BackgroundTransparency = 1,
                    LayoutOrder = 1,
                    Parent = TabLeft,
                })
            end

            TabRight = New("ScrollingFrame", {
                AnchorPoint = Vector2.new(1, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                CanvasSize = UDim2.fromScale(0, 0),
                Position = UDim2.fromScale(1, 0),
                ScrollBarImageTransparency = 1,
                ScrollBarThickness = 0,
                Size = UDim2.new(0.5, -3, 1, 0),
                Parent = TabContainer,
            })
            New("UIListLayout", {
                Padding = UDim.new(0, 2),
                Parent = TabRight,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 2),
                PaddingLeft = UDim.new(0, 2),
                PaddingRight = UDim.new(0, 2),
                PaddingTop = UDim.new(0, 2),
                Parent = TabRight,
            })
            do
                New("Frame", {
                    BackgroundTransparency = 1,
                    LayoutOrder = -1,
                    Parent = TabRight,
                })
                New("Frame", {
                    BackgroundTransparency = 1,
                    LayoutOrder = 1,
                    Parent = TabRight,
                })
            end
        end

        --// Tab Table \\--
        local Tab = {
            Name = Name,
            Description = Description,
            Icon = Icon,

            Tooltip = Tooltip,
            TooltipTable = nil,

            Connections = {},
            Destroyed = false,

            Window = Window,
            Button = TabButton,
            Container = TabContainer,
            Sides = {
                TabLeft,
                TabRight,
            },
            WarningBox = {
                IsNormal = false,
                LockSize = false,
                Visible = false,
                Title = "WARNING",
                Text = "",
            },

            Groupboxes = {},
            Tabboxes = {},
            DependencyGroupboxes = {},
        }

        --// Warning Box \\--
        local WarningBoxHolder = New("Frame", {
            AutomaticSize = Enum.AutomaticSize.Y,
            BackgroundTransparency = 1,
            Position = UDim2.fromOffset(0, 7),
            Size = UDim2.fromScale(1, 0),
            Visible = false,
            Parent = TabContainer,
        })

        local WarningBox
        local WarningBoxOutline
        local WarningBoxShadowOutline
        local WarningBoxScrollingFrame
        local WarningTitle
        local WarningStroke
        local WarningText
        do
            WarningBox = New("Frame", {
                BackgroundColor3 = Color3.fromRGB(127, 0, 0),
                Position = UDim2.fromOffset(2, 0),
                Size = UDim2.new(1, -5, 0, 0),
                Parent = WarningBoxHolder,
            })
            Library:AddToRegistry(WarningBox, {
                BackgroundColor3 = function()
                    return Tab.WarningBox.IsNormal == true and Library.Scheme.BackgroundColor or Color3.fromRGB(127, 0, 0)
                end
            })
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                    Parent = WarningBox,
                })
            )
            WarningBoxOutline, WarningBoxShadowOutline = Library:AddOutline(WarningBox)
            Library:AddToRegistry(WarningBoxOutline, {
                Color = function()
                    return Tab.WarningBox.IsNormal == true and Library.Scheme.OutlineColor or Color3.fromRGB(255, 50, 50)
                end
            })
            Library:AddToRegistry(WarningBoxShadowOutline, {
                Color = function()
                    return Tab.WarningBox.IsNormal == true and Library.Scheme.DarkColor or Color3.fromRGB(85, 0, 0)
                end
            })

            WarningBoxScrollingFrame = New("ScrollingFrame", {
                BackgroundTransparency = 1,
                BorderSizePixel = 0,
                Size = UDim2.fromScale(1, 1),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                ScrollBarThickness = 3,
                ScrollingDirection = Enum.ScrollingDirection.Y,
                Parent = WarningBox,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 4),
                PaddingLeft = UDim.new(0, 6),
                PaddingRight = UDim.new(0, 6),
                PaddingTop = UDim.new(0, 4),
                Parent = WarningBoxScrollingFrame,
            })

            WarningTitle = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -4, 0, 14),
                Text = "",
                TextColor3 = Color3.fromRGB(255, 50, 50),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                Parent = WarningBoxScrollingFrame,
            })
            Library:AddToRegistry(WarningTitle, {
                TextColor3 = function()
                    return Tab.WarningBox.IsNormal == true and Library.Scheme.FontColor or Color3.fromRGB(255, 50, 50)
                end
            })

            WarningStroke = New("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                Color = Color3.fromRGB(169, 0, 0),
                LineJoinMode = Enum.LineJoinMode.Miter,
                Parent = WarningTitle,
            })
            Library:AddToRegistry(WarningStroke, {
                Color = function()
                    return Tab.WarningBox.IsNormal == true and Library.Scheme.OutlineColor or Color3.fromRGB(169, 0, 0)
                end
            })

            WarningText = New("TextLabel", {
                BackgroundTransparency = 1,
                Position = UDim2.fromOffset(0, 16),
                Size = UDim2.new(1, -4, 0, 0),
                Text = "",
                TextSize = 14,
                TextWrapped = true,
                Parent = WarningBoxScrollingFrame,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextYAlignment = Enum.TextYAlignment.Top,
            })

            New("UIStroke", {
                ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
                Color = "DarkColor",
                LineJoinMode = Enum.LineJoinMode.Miter,
                Parent = WarningText,
            })
        end

        --// Tab Handlers \\--
        function Tab:UpdateWarningBox(Info)
            if typeof(Info.IsNormal) == "boolean" then
                Tab.WarningBox.IsNormal = Info.IsNormal
            end
            if typeof(Info.LockSize) == "boolean" then
                Tab.WarningBox.LockSize = Info.LockSize
            end
            if typeof(Info.Visible) == "boolean" then
                Tab.WarningBox.Visible = Info.Visible
            end
            if typeof(Info.Title) == "string" then
                Tab.WarningBox.Title = Info.Title
            end
            if typeof(Info.Text) == "string" then
                Tab.WarningBox.Text = Info.Text
            end

            WarningBoxHolder.Visible = Tab.WarningBox.Visible
            WarningTitle.Text = Tab.WarningBox.Title
            WarningText.Text = Tab.WarningBox.Text
            Tab:Resize(true)

            WarningBox.BackgroundColor3 = Library.Registry[WarningBox].BackgroundColor3()
            WarningBoxShadowOutline.Color = Library.Registry[WarningBoxShadowOutline].Color()
            WarningBoxOutline.Color = Library.Registry[WarningBoxOutline].Color()
            WarningTitle.TextColor3 = Library.Registry[WarningTitle].TextColor3()
            WarningStroke.Color = Library.Registry[WarningStroke].Color()
        end

        function Tab:RefreshSides()
            local Offset = WarningBoxHolder.Visible and WarningBox.Size.Y.Offset + 8 or 0
            for _, Side in Tab.Sides do
                Side.Position = UDim2.new(Side.Position.X.Scale, 0, 0, Offset)
                Side.Size = UDim2.new(0.5, -3, 1, -Offset)
            end
        end

        function Tab:Resize(ResizeWarningBox: boolean?)
            if ResizeWarningBox then
                local MaximumSize = math.floor((TabContainer.AbsoluteSize.Y / Library.DPIScale) / 3.25)
                local _, YText = Library:GetTextBounds(
                    WarningText.Text,
                    Library.Scheme.Font,
                    WarningText.TextSize,
                    WarningText.AbsoluteSize.X / Library.DPIScale
                )

                local YBox = 24 + YText
                if Tab.WarningBox.LockSize == true and YBox >= MaximumSize then
                    WarningBoxScrollingFrame.CanvasSize = UDim2.fromOffset(0, YBox)
                    YBox = MaximumSize
                else
                    WarningBoxScrollingFrame.CanvasSize = UDim2.fromOffset(0, 0)
                end

                WarningText.Size = UDim2.new(1, -4, 0, YText)
                WarningBox.Size = UDim2.new(1, -5, 0, YBox + 4)
            end

            Tab:RefreshSides()
        end

        local function GetSide(Owner, Side)
            local Sides = if Owner and Owner.IsSubTab then Owner.Sides else { TabLeft, TabRight }
            return if Side == 1 then Sides[1] else Sides[2]
        end

        local function AddTabbox(self, Info)
            Info = Library:Validate(Info, Templates.Tabbox)
            local ParentObj = self
            local IsNested = ParentObj.Type == "Groupbox" or ParentObj.Type == "SubTab"

            if typeof(Info.Side) == "string" then
                local lowerSide = string.lower(Info.Side)
                if not SideIndex[lowerSide] then
                    error(string.format("Invalid side: %s", Info.Side))
                end

                Info.Side = SideIndex[lowerSide]
            end

            local BoxHolder = New("Frame", {
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                Parent = if IsNested then ParentObj.Container else GetSide(ParentObj, Info.Side),
            })
            New("UIListLayout", {
                Padding = UDim.new(0, 6),
                Parent = BoxHolder,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 4),
                PaddingTop = UDim.new(0, 4),
                Parent = BoxHolder,
            })

            local TabboxHolder
            local TabboxButtons

            do
                TabboxHolder = New("Frame", {
                    BackgroundColor3 = "BackgroundColor",
                    Size = UDim2.fromScale(1, 0),
                    Parent = BoxHolder,
                })
                table.insert(
                    Library.Corners,
                    New("UICorner", {
                        CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                        Parent = TabboxHolder,
                    })
                )
                Library:AddOutline(TabboxHolder)

                TabboxButtons = New("Frame", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 34),
                    Parent = TabboxHolder,
                })
                New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalFlex = Enum.UIFlexAlignment.Fill,
                    Parent = TabboxButtons,
                })
            end

            local TotalTabs = 0
            local FirstTab
            local LastTab

            local Tabbox: any = {
                Type = "Tabbox",

                Connections = {},
                Destroyed = false,

                Visible = true,
                ActiveTab = nil,

                BoxHolder = BoxHolder,
                Holder = TabboxHolder,
                Tabs = {},

                ParentBox = if IsNested then ParentObj else nil,
                Page = if ParentObj.IsSubTab then ParentObj else nil,
            }

            function Tabbox:UpdateCorners()
                for _, Tab in Tabbox.Tabs do
                    Tab:UpdateCorners()
                end
            end

            function Tabbox:Resize()
                if Tabbox.ActiveTab then
                    Tabbox.ActiveTab:Resize()
                end
            end

            function Tabbox:AddTab(Name, IconName)
                TotalTabs = TotalTabs + 1
                local TabIndex = TotalTabs

                LastTab = TabIndex
                if not FirstTab then
                    FirstTab = TabIndex
                end

                local IsNameEmpty = Name == nil or Trim(tostring(Name)) == ""
                local TabStoringIndex = IsNameEmpty and tostring(TabIndex) or Name

                local Button = New("TextButton", {
                    BackgroundColor3 = "MainColor",
                    BackgroundTransparency = 0,
                    Size = UDim2.fromOffset(0, 34),
                    Text = "",
                    Parent = TabboxButtons,
                })

                local ButtonCorner = New("UICorner", {
                    TopLeftRadius = UDim.new(0, WindowInfo.CornerRadius),
                    TopRightRadius = UDim.new(0, WindowInfo.CornerRadius),
                    BottomRightRadius = UDim.new(0, 0),
                    BottomLeftRadius = UDim.new(0, 0),
                    Parent = Button,
                }); table.insert(Library.SpecificCorners, ButtonCorner)

                local ButtonContent = New("Frame", {
                    AnchorPoint = Vector2.new(0.5, 0.5),
                    AutomaticSize = Enum.AutomaticSize.X,
                    BackgroundTransparency = 1,
                    Position = UDim2.fromScale(0.5, 0.5),
                    Size = UDim2.fromOffset(0, 16),
                    Parent = Button,
                })
                New("UIListLayout", {
                    FillDirection = Enum.FillDirection.Horizontal,
                    HorizontalAlignment = Enum.HorizontalAlignment.Center,
                    VerticalAlignment = Enum.VerticalAlignment.Center,
                    Padding = UDim.new(0, 8),
                    Parent = ButtonContent,
                })

                local ButtonIcon
                local BoxIcon = Library:GetCustomIcon(IconName)
                if BoxIcon then
                    ButtonIcon = New("ImageLabel", {
                        ImageColor3 = BoxIcon.Custom and "WhiteColor" or "AccentColor",
                        ImageTransparency = 0.5,
                        Size = IsNameEmpty and UDim2.fromOffset(16, 16) or UDim2.fromOffset(18, 18),
                        Parent = ButtonContent,
                    })
                    Library:ApplyLucideIcon(ButtonIcon, BoxIcon)
                end

                local ButtonLabel
                if not IsNameEmpty then
                    ButtonLabel = New("TextLabel", {
                        AutomaticSize = Enum.AutomaticSize.X,
                        BackgroundTransparency = 1,
                        Size = UDim2.fromOffset(0, 16),
                        Text = Name,
                        TextSize = 15,
                        TextTransparency = 0.5,
                        Parent = ButtonContent,
                    })
                end

                local Line = Library:MakeLine(Button, {
                    AnchorPoint = Vector2.new(0, 1),
                    Position = UDim2.new(0, 0, 1, 1),
                    Size = UDim2.new(1, 0, 0, 1),
                })

                local Container = New("ScrollingFrame", {
                    AutomaticCanvasSize = Enum.AutomaticSize.None,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.fromOffset(0, 0),
                    Position = UDim2.fromOffset(0, 35),
                    ScrollBarImageTransparency = 1,
                    ScrollBarThickness = 0,
                    ScrollingEnabled = false,
                    Size = UDim2.new(1, 0, 1, -35),
                    Visible = false,
                    Parent = TabboxHolder,
                })
                local List = New("UIListLayout", {
                    Padding = UDim.new(0, 8),
                    Parent = Container,
                })
                New("UIPadding", {
                    PaddingBottom = UDim.new(0, 7),
                    PaddingLeft = UDim.new(0, 7),
                    PaddingRight = UDim.new(0, 7),
                    PaddingTop = UDim.new(0, 7),
                    Parent = Container,
                })

                local Tab = {
                    Type = "SubTab",
                    Name = Name,
                    Icon = BoxIcon,

                    Connections = {},
                    Destroyed = false,

                    ButtonHolder = Button,
                    Container = Container,
                    ButtonCorner = ButtonCorner,

                    Tab = Tab,
                    Tabbox = Tabbox,

                    Elements = {},
                    DependencyBoxes = {},
                }

                function Tab:Show()
                    if Tabbox.ActiveTab then
                        Tabbox.ActiveTab:Hide()
                    end

                    Button.BackgroundTransparency = 1

                    if ButtonLabel then
                        ButtonLabel.TextTransparency = 0
                    end
                    if ButtonIcon then
                        ButtonIcon.ImageTransparency = 0
                    end

                    Line.Visible = false

                    Container.Visible = true

                    Tabbox.ActiveTab = Tab
                    Tab:Resize()
                    Tabbox:RefreshPopOutPlaceholder()
                end

                function Tab:Hide()
                    Button.BackgroundTransparency = 0

                    if ButtonLabel then
                        ButtonLabel.TextTransparency = 0.5
                    end
                    if ButtonIcon then
                        ButtonIcon.ImageTransparency = 0.5
                    end
                    Line.Visible = true
                    Container.Visible = false

                    Tabbox.ActiveTab = nil
                end

                function Tab:Resize()
                    if Tabbox.ActiveTab ~= Tab then
                        return
                    end

                    local ContentSize = (List.AbsoluteContentSize.Y / Library.DPIScale) + 14
                    local FrameSize = ContentSize
                    if Tabbox.PoppedOut then
                        FrameSize = math.min(ContentSize, GetPopOutBodyMaxHeight(Tabbox, 35))
                    end

                    local NeedsScroll = ContentSize > FrameSize + 1
                    Container.CanvasSize = UDim2.fromOffset(0, if NeedsScroll then ContentSize else 0)
                    Container.ScrollingEnabled = NeedsScroll
                    TabboxHolder.Size = UDim2.new(1, 0, 0, FrameSize + 35)

                    if IsNested then
                        ParentObj:Resize()
                    end
                end

                function Tab:UpdateCorners()
                    local Radius = WindowInfo.CornerRadius

                    ButtonCorner.TopLeftRadius = UDim.new(0, TabIndex == FirstTab and Radius or 0)
                    ButtonCorner.TopRightRadius = UDim.new(0, TabIndex == LastTab and Radius or 0)
                end

                function Tab:Destroy()
                    Tab.Destroyed = true

                    if Tab.Connections then
                        for _, Connection in Tab.Connections do
                            Connection:Disconnect()
                        end
                    end

                    for _, Element in Tab.Elements do
                        if Element.Destroy then
                            Element:Destroy()
                        end
                    end

                    for _, SubDepbox in Tab.DependencyBoxes do
                        if SubDepbox.Destroy then
                            SubDepbox:Destroy()
                        end
                    end

                    if Container then
                        Container:Destroy()
                    end

                    if Button then
                        Button:Destroy()
                    end
                end

                --// Execution \\--
                if not Tabbox.ActiveTab then
                    Tab:Show()
                end

                Button.MouseButton1Click:Connect(Tab.Show)

                Tab.AddTabbox = AddTabbox
                setmetatable(Tab, BaseGroupbox)

                Tabbox.Tabs[TabStoringIndex] = Tab
                Tabbox:UpdateCorners()

                return Tab, TabStoringIndex
            end

            Library:MakeBoxPopOut(Tabbox, {
                Enabled = Info.PopOut ~= false,
                MaxPopOutHeight = Info.MaxPopOutHeight,
                PopOutWidth = Info.PopOutWidth,

                Header = TabboxButtons,
                Children = function()
                    return { TabboxHolder }
                end,

                After = function()
                    if Tabbox.ActiveTab then
                        Tabbox.ActiveTab:Resize()
                    end
                    if IsNested then
                        ParentObj:Resize()
                    end
                end,
            })

            function Tabbox:Destroy()
                if Tabbox.PoppedOut then
                    Tabbox:SetPoppedOut(false)
                end

                Tabbox.Destroyed = true

                if Tabbox.Connections then
                    for _, Connection in Tabbox.Connections do
                        Connection:Disconnect()
                    end
                end

                for _, Tab in Tabbox.Tabs do
                    if Tab.Destroy then
                        Tab:Destroy()
                    end
                end

                if TabboxHolder then
                    TabboxHolder:Destroy()
                end

                if BoxHolder then
                    BoxHolder:Destroy()
                end
            end

            if Info.Name then
                Tab.Tabboxes[Info.Name] = Tabbox
            else
                table.insert(Tab.Tabboxes, Tabbox)
            end

            return Tabbox
        end

        Tab.AddTabbox = AddTabbox

        --// Deprecated - Use Tab:AddTabbox instead.
        function Tab:AddLeftTabbox(Name)
            return Tab:AddTabbox({ Side = 1, Name = Name })
        end

        --// Deprecated - Use Tab:AddTabbox instead.
        function Tab:AddRightTabbox(Name)
            return Tab:AddTabbox({ Side = 2, Name = Name })
        end

        function Tab:AddGroupbox(Info)
            Info = Library:Validate(Info, Templates.Groupbox)

            if typeof(Info.Side) == "string" then
                local lowerSide = string.lower(Info.Side)
                if not SideIndex[lowerSide] then
                    error(string.format("Invalid side: %s", Info.Side))
                end

                Info.Side = SideIndex[lowerSide]
            end

            local BoxHolder = New("Frame", {
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 0),
                Parent = GetSide(self, Info.Side),
            })
            local BoxHolderList = New("UIListLayout", {
                Padding = UDim.new(0, 6),
                Parent = BoxHolder,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 4),
                PaddingTop = UDim.new(0, 4),
                Parent = BoxHolder,
            })

            local GroupboxHolder

            local GroupboxTop
            local GroupboxLabel
            local GroupboxDescription

            local GroupboxContainer
            local GroupboxList

            local GroupboxCollapseArrow
            local GroupboxLine
            local GroupboxIcon

            do
                GroupboxHolder = New("Frame", {
                    BackgroundColor3 = "BackgroundColor",
                    Size = UDim2.fromScale(1, 0),
                    Parent = BoxHolder,
                })
                table.insert(
                    Library.Corners,
                    New("UICorner", {
                        CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                        Parent = GroupboxHolder,
                    })
                )
                New("UIListLayout", {
                    Parent = GroupboxHolder,
                })
                Library:AddOutline(GroupboxHolder)

                GroupboxTop = New("Frame", {
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 0),
                    Parent = GroupboxHolder,
                })
                New("UIPadding", {
                    PaddingBottom = UDim.new(0, 6),
                    PaddingLeft = UDim.new(0, 6),
                    PaddingRight = UDim.new(0, 6),
                    PaddingTop = UDim.new(0, 6),
                    Parent = GroupboxTop,
                })

                local BoxIcon = Library:GetCustomIcon(Info.IconName)
                GroupboxIcon = BoxIcon
                if BoxIcon then
                    local GroupboxHeaderIcon = New("ImageLabel", {
                        AnchorPoint = Vector2.new(0, 0.5),
                        ImageColor3 = BoxIcon.Custom and "WhiteColor" or "AccentColor",
                        Position = UDim2.fromScale(0, 0.5),
                        Size = UDim2.fromOffset(22, 22),
                        Parent = GroupboxTop,
                    })
                    Library:ApplyLucideIcon(GroupboxHeaderIcon, BoxIcon)
                end

                local RightInset = if Info.DisableCollapsing ~= true then 22 else 0
                local TextsFrame = New("Frame", {
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(BoxIcon and 24 or 0, 0),
                    Size = UDim2.new(1, -RightInset - (BoxIcon and 24 or 0), 0, 0),
                    Parent = GroupboxTop,
                })
                New("UIListLayout", {
                    Parent = TextsFrame,
                })
                New("UIPadding", {
                    PaddingBottom = UDim.new(0, 3),
                    PaddingLeft = UDim.new(0, 6),
                    PaddingRight = UDim.new(0, 6),
                    PaddingTop = UDim.new(0, 3),
                    Parent = TextsFrame,
                })

                GroupboxLabel = New("TextLabel", {
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 0),
                    Text = Info.Name,
                    TextSize = 15,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = TextsFrame,
                })
                New("UIPadding", {
                    PaddingBottom = UDim.new(0, 1),
                    Parent = GroupboxLabel,
                })

                GroupboxDescription = New("TextLabel", {
                    AutomaticSize = Enum.AutomaticSize.Y,
                    BackgroundTransparency = 1,
                    Size = UDim2.fromScale(1, 0),
                    Text = Info.Description or "",
                    TextSize = 14,
                    TextTransparency = 0.5,
                    TextWrapped = true,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Visible = (Info.Description ~= nil),
                    Parent = TextsFrame,
                })

                GroupboxCollapseArrow = New("ImageButton", {
                    Visible = Info.DisableCollapsing ~= true,
                    AnchorPoint = Vector2.new(1, 0.5),
                    BackgroundTransparency = 1,
                    ImageColor3 = "WhiteColor",
                    Position = UDim2.fromScale(1, 0.5),
                    Size = UDim2.fromOffset(22, 22),
                    Parent = GroupboxTop,
                })
                if ArrowIcon then
                    Library:ApplyLucideIcon(GroupboxCollapseArrow, ArrowIcon, 180)
                end

                GroupboxLine = Library:MakeLine(GroupboxHolder, {
                    LayoutOrder = 1,
                    Size = UDim2.new(1, 0, 0, 1),
                })

                GroupboxContainer = New("ScrollingFrame", {
                    AutomaticCanvasSize = Enum.AutomaticSize.None,
                    BackgroundTransparency = 1,
                    BorderSizePixel = 0,
                    CanvasSize = UDim2.fromOffset(0, 0),
                    LayoutOrder = 2,
                    ScrollBarImageTransparency = 1,
                    ScrollBarThickness = 0,
                    ScrollingEnabled = false,
                    Size = UDim2.fromScale(1, 0),
                    Parent = GroupboxHolder,
                })

                GroupboxList = New("UIListLayout", {
                    Padding = UDim.new(0, 8),
                    Parent = GroupboxContainer,
                })
                New("UIPadding", {
                    PaddingBottom = UDim.new(0, 7),
                    PaddingLeft = UDim.new(0, 7),
                    PaddingRight = UDim.new(0, 7),
                    PaddingTop = UDim.new(0, 7),
                    Parent = GroupboxContainer,
                })
            end

            local Groupbox: any = {
                Type = "Groupbox",

                Name = Info.Name,
                Description = Info.Description,
                Icon = GroupboxIcon,
                Page = if self.IsSubTab then self else nil,

                Connections = {},
                Destroyed = false,

                Visible = true,
                Collapsed = false,

                BoxHolder = BoxHolder,
                Holder = GroupboxHolder,
                Container = GroupboxContainer,

                Tab = Tab,
                DependencyBoxes = {},
                Elements = {}
            }

            local ResizeTween
            local CollapseArrowTween

            local function RefreshBoxHolderLayout()
                BoxHolder.AutomaticSize = Enum.AutomaticSize.None
                BoxHolder.Size = UDim2.new(1, 0, 0, BoxHolderList.AbsoluteContentSize.Y / Library.DPIScale + 8)
                BoxHolder.AutomaticSize = Enum.AutomaticSize.Y
            end
            Groupbox.RefreshBoxHolderLayout = RefreshBoxHolderLayout

            function Groupbox:Resize()
                if ResizeTween then
                    StopTween(ResizeTween, true)
                    ResizeTween = nil
                end

                local TopSize = (GroupboxTop.AbsoluteSize.Y / Library.DPIScale)
                local ContentSize = (GroupboxList.AbsoluteContentSize.Y / Library.DPIScale) + 14
                local ContainerSize = ContentSize
                if Groupbox.PoppedOut then
                    ContainerSize = math.min(ContainerSize, GetPopOutBodyMaxHeight(Groupbox, TopSize + 1))
                end

                local NeedsScroll = ContentSize > ContainerSize + 1
                GroupboxContainer.CanvasSize = UDim2.fromOffset(0, if NeedsScroll then ContentSize else 0)
                GroupboxContainer.ScrollingEnabled = NeedsScroll

                local TargetSize = UDim2.new(1, 0, 0, if Groupbox.Collapsed then TopSize else (TopSize + 1 + ContainerSize))
                GroupboxContainer.Size = UDim2.new(1, 0, 0, ContainerSize)
                GroupboxLine.Visible = not Groupbox.Collapsed

                if Library.Animations and Library.Animations.Groupbox then
                    local TweenInfo = Library.GroupboxTweenInfo or TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                    local Tween = TweenService:Create(GroupboxHolder, TweenInfo, { Size = TargetSize })
                    ResizeTween = Tween

                    local Connection; Connection = Library:GiveSignal(Tween.Completed:Once(function()
                        if Connection then
                            Connection:Disconnect()
                        end

                        if ResizeTween == Tween then
                            StopTween(ResizeTween, true)
                            ResizeTween = nil
                        end

                        RefreshBoxHolderLayout()
                    end))

                    Tween:Play()
                else
                    GroupboxHolder.Size = TargetSize
                    RefreshBoxHolderLayout()
                end
            end

            table.insert(Groupbox.Connections, GroupboxList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
                if Groupbox.Visible == false or Groupbox.Destroyed then
                    return
                end

                Groupbox:Resize()
            end))

            function Groupbox:SetDescription(Description: string | nil)
                GroupboxDescription.Text = Description or ""
                GroupboxDescription.Visible = (Description ~= nil)

                Groupbox:Resize()
            end

            function Groupbox:SetCollapsed(Collapsed: boolean)
                if Info.DisableCollapsing == true then return end
                Groupbox.Collapsed = Collapsed

                if CollapseArrowTween then
                    StopTween(CollapseArrowTween, true)
                    CollapseArrowTween = nil
                end

                local TargetRotation = if Collapsed then 0 else 180

                GroupboxContainer.Visible = not Collapsed
                if Library.Animations and Library.Animations.Groupbox then
                    local TweenInfo = Library.GroupboxTweenInfo or TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
                    local Tween = TweenService:Create(GroupboxCollapseArrow, TweenInfo, { Rotation = TargetRotation })
                    CollapseArrowTween = Tween

                    local Connection; Connection = Library:GiveSignal(Tween.Completed:Connect(function()
                        if Connection then
                            Connection:Disconnect()
                        end

                        if CollapseArrowTween == Tween then
                            StopTween(CollapseArrowTween, true)
                            CollapseArrowTween = nil
                        end
                    end))

                    Tween:Play()
                else
                    GroupboxCollapseArrow.Rotation = TargetRotation
                end

                Groupbox:Resize()
            end

            function Groupbox:ToggleCollapsed()
                if Info.DisableCollapsing == true then return end
                Groupbox:SetCollapsed(not Groupbox.Collapsed)
            end

            Library:MakeBoxPopOut(Groupbox, {
                Enabled = Info.PopOut ~= false,
                MaxPopOutHeight = Info.MaxPopOutHeight,
                PopOutWidth = Info.PopOutWidth,

                Header = GroupboxTop,
                Children = function()
                    local Children = {}
                    for _, Child in BoxHolder:GetChildren() do
                        if Child:IsA("GuiObject") and Child ~= Groupbox.PopOutPlaceholder then
                            table.insert(Children, Child)
                        end
                    end
                    return Children
                end,

                Before = function()
                    GroupboxCollapseArrow.Visible = false
                end,
                After = function()
                    GroupboxCollapseArrow.Visible = Info.DisableCollapsing ~= true
                    Groupbox:Resize()
                end
            })

            function Groupbox:Destroy()
                if Groupbox.PoppedOut then
                    Groupbox:SetPoppedOut(false)
                end

                Groupbox.Destroyed = true

                if ResizeTween then
                    StopTween(ResizeTween, true)
                    ResizeTween = nil
                end

                if CollapseArrowTween then
                    StopTween(CollapseArrowTween, true)
                    CollapseArrowTween = nil
                end

                if Groupbox.Connections then
                    for _, Connection in Groupbox.Connections do
                        Connection:Disconnect()
                    end
                end

                for _, Element in Groupbox.Elements do
                    if Element.Destroy then
                        Element:Destroy()
                    end
                end
                table.clear(Groupbox.Elements)

                for _, SubDepbox in Groupbox.DependencyBoxes do
                    if SubDepbox.Destroy then
                        SubDepbox:Destroy()
                    end
                end
                table.clear(Groupbox.DependencyBoxes)

                if GroupboxHolder then
                    GroupboxHolder:Destroy()
                end

                if BoxHolder then
                    BoxHolder:Destroy()
                end
            end

            function Groupbox:SetVisible(Visible: boolean)
                Groupbox.Visible = Visible
                BoxHolder.Visible = Visible
                SyncPopOutVisibility(Groupbox)

                if Visible == true and Library.Searching then
                    Library:UpdateSearch(Library.SearchText)
                end
            end

            function Groupbox:Show()
                Groupbox:SetVisible(true)
            end

            function Groupbox:Hide()
                Groupbox:SetVisible(false)
            end

            if Info.DisableCollapsing ~= true then
                GroupboxCollapseArrow.MouseButton1Click:Connect(function()
                    Groupbox:ToggleCollapsed()
                end)
            end

            Groupbox.AddTabbox = AddTabbox
            setmetatable(Groupbox, BaseGroupbox)

            Groupbox:Resize()
            Tab.Groupboxes[Info.Name] = Groupbox

            if Info.Visible == false then
                Groupbox:Hide()
            end

            if Info.DisableCollapsing ~= true and Info.Collapsed == true then
                Groupbox:SetCollapsed(true)
            end

            return Groupbox
        end

        --// Deprecated - Use Tab:AddGroupbox instead.
        function Tab:AddLeftGroupbox(Name, IconName, Visible, Collapsed, DisableCollapsing)
            return Tab:AddGroupbox({ Side = 1, Name = Name, IconName = IconName, Visible = Visible, Collapsed = Collapsed, DisableCollapsing = DisableCollapsing })
        end

        --// Deprecated - Use Tab:AddGroupbox instead.
        function Tab:AddRightGroupbox(Name, IconName, Visible, Collapsed, DisableCollapsing)
            return Tab:AddGroupbox({ Side = 2, Name = Name, IconName = IconName, Visible = Visible, Collapsed = Collapsed, DisableCollapsing = DisableCollapsing })
        end

        --// Sub Tabs \\--
        local SubTabPanel
        local SubTabList
        local DefaultSection

        local function CreateSubTabPanel()
            if SubTabPanel then
                return
            end

            local Width = WindowInfo.SubTabWidth
            SubTabPanel = New("ScrollingFrame", {
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                BackgroundColor3 = "BackgroundColor",
                CanvasSize = UDim2.fromScale(0, 0),
                Position = UDim2.fromOffset(-6, 0),
                ScrollBarImageTransparency = 1,
                ScrollBarThickness = 0,
                Size = UDim2.new(0, Width, 1, 0),
                Parent = TabContainer,
            })
            SubTabList = New("UIListLayout", {
                Padding = UDim.new(0, 6),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = SubTabPanel,
            })
            New("UIPadding", {
                PaddingBottom = UDim.new(0, 8),
                PaddingLeft = UDim.new(0, 8),
                PaddingRight = UDim.new(0, 8),
                PaddingTop = UDim.new(0, 8),
                Parent = SubTabPanel,
            })
            Library:MakeLine(TabContainer, {
                Position = UDim2.fromOffset(Width - 6, 0),
                Size = UDim2.new(0, 1, 1, 0),
            })

            TabLeft.Visible = false
            TabRight.Visible = false
            Tab.SubTabs = {}
            Tab.SubTabSections = {}
        end

        local function CreateSection(SectionName)
            CreateSubTabPanel()

            local Section = {
                Name = SectionName,
                Collapsed = false,
                SubTabs = {},
            }

            local SectionHolder = New("Frame", {
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                LayoutOrder = #Tab.SubTabSections,
                Size = UDim2.fromScale(1, 0),
                Parent = SubTabPanel,
            })
            New("UIListLayout", {
                Padding = UDim.new(0, 2),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = SectionHolder,
            })

            local ItemHolder = New("Frame", {
                AutomaticSize = Enum.AutomaticSize.Y,
                BackgroundTransparency = 1,
                LayoutOrder = 1,
                Size = UDim2.fromScale(1, 0),
                Parent = SectionHolder,
            })
            New("UIListLayout", {
                Padding = UDim.new(0, 2),
                SortOrder = Enum.SortOrder.LayoutOrder,
                Parent = ItemHolder,
            })

            if SectionName then
                local Header = New("TextButton", {
                    BackgroundTransparency = 1,
                    Size = UDim2.new(1, 0, 0, 20),
                    Text = "",
                    Parent = SectionHolder,
                })
                New("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(4, 0),
                    Size = UDim2.new(1, -24, 1, 0),
                    Text = string.upper(SectionName),
                    TextSize = 12,
                    TextTransparency = 0.6,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Header,
                })

                local Arrow = New("ImageLabel", {
                    AnchorPoint = Vector2.new(1, 0.5),
                    ImageColor3 = "FontColor",
                    ImageTransparency = 0.6,
                    Position = UDim2.new(1, -2, 0.5, 0),
                    Size = UDim2.fromOffset(14, 14),
                    Parent = Header,
                })
                if ArrowIcon then
                    Library:ApplyLucideIcon(Arrow, ArrowIcon)
                end

                function Section:SetCollapsed(Collapsed: boolean)
                    Section.Collapsed = Collapsed
                    ItemHolder.Visible = not Collapsed
                    Arrow.Rotation = Collapsed and 180 or 0
                end

                Header.MouseButton1Click:Connect(function()
                    Section:SetCollapsed(not Section.Collapsed)
                end)
            end

            function Section:AddSubTab(...)
                local Info = if typeof(...) == "table" then ... else { Name = select(1, ...), Badge = select(2, ...) }
                local SubName = Info.Name or "Sub Tab"

                local Button = New("TextButton", {
                    BackgroundColor3 = "MainColor",
                    BackgroundTransparency = 1,
                    LayoutOrder = #Section.SubTabs,
                    Size = UDim2.new(1, 0, 0, 26),
                    Text = "",
                    Parent = ItemHolder,
                })
                New("UICorner", {
                    CornerRadius = UDim.new(0, TabButtonsStyle.CornerRadius),
                    Parent = Button,
                })
                local Label = New("TextLabel", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(6, 0),
                    Size = UDim2.new(1, -32, 1, 0),
                    Text = SubName,
                    TextSize = 14,
                    TextTransparency = 0.4,
                    TextTruncate = Enum.TextTruncate.AtEnd,
                    TextXAlignment = Enum.TextXAlignment.Left,
                    Parent = Button,
                })
                local BadgeLabel = New("TextLabel", {
                    AnchorPoint = Vector2.new(1, 0),
                    BackgroundTransparency = 1,
                    Position = UDim2.new(1, -6, 0, 0),
                    Size = UDim2.new(0, 24, 1, 0),
                    Text = "",
                    TextColor3 = "AccentColor",
                    TextSize = 13,
                    TextXAlignment = Enum.TextXAlignment.Right,
                    Parent = Button,
                })

                local Page = New("Frame", {
                    BackgroundTransparency = 1,
                    Position = UDim2.fromOffset(WindowInfo.SubTabWidth - 3, 0),
                    Size = UDim2.new(1, -WindowInfo.SubTabWidth + 3, 1, 0),
                    Visible = false,
                    Parent = TabContainer,
                })

                local function MakeSide(Right)
                    local Side = New("ScrollingFrame", {
                        AnchorPoint = Vector2.new(Right and 1 or 0, 0),
                        AutomaticCanvasSize = Enum.AutomaticSize.Y,
                        BackgroundTransparency = 1,
                        CanvasSize = UDim2.fromScale(0, 0),
                        Position = UDim2.fromScale(Right and 1 or 0, 0),
                        ScrollBarImageTransparency = 1,
                        ScrollBarThickness = 0,
                        Size = UDim2.new(0.5, -3, 1, 0),
                        Parent = Page,
                    })
                    New("UIListLayout", {
                        Padding = UDim.new(0, 2),
                        Parent = Side,
                    })
                    New("UIPadding", {
                        PaddingBottom = UDim.new(0, 2),
                        PaddingLeft = UDim.new(0, 2),
                        PaddingRight = UDim.new(0, 2),
                        PaddingTop = UDim.new(0, 2),
                        Parent = Side,
                    })
                    New("Frame", { BackgroundTransparency = 1, LayoutOrder = -1, Parent = Side })
                    New("Frame", { BackgroundTransparency = 1, LayoutOrder = 1, Parent = Side })
                    return Side
                end

                local SubTab = {
                    IsSubTab = true,
                    Name = SubName,
                    Tab = Tab,
                    Section = Section,
                    Button = Button,
                    Container = Page,
                    Sides = { MakeSide(false), MakeSide(true) },
                }

                function SubTab:AddGroupbox(GroupInfo)
                    return Tab.AddGroupbox(SubTab, GroupInfo)
                end

                function SubTab:AddTabbox(BoxInfo)
                    return Tab.AddTabbox(SubTab, BoxInfo)
                end

                function SubTab:AddLeftGroupbox(GroupName, IconName)
                    return SubTab:AddGroupbox({ Side = 1, Name = GroupName, IconName = IconName })
                end

                function SubTab:AddRightGroupbox(GroupName, IconName)
                    return SubTab:AddGroupbox({ Side = 2, Name = GroupName, IconName = IconName })
                end

                function SubTab:AddLeftTabbox(BoxName)
                    return SubTab:AddTabbox({ Side = 1, Name = BoxName })
                end

                function SubTab:AddRightTabbox(BoxName)
                    return SubTab:AddTabbox({ Side = 2, Name = BoxName })
                end

                function SubTab:SetBadge(Badge: (string | number)?)
                    BadgeLabel.Text = if Badge == nil then "" else tostring(Badge)
                end

                function SubTab:Show()
                    local Previous = Tab.ActiveSubTab
                    if Previous == SubTab then
                        return
                    end

                    if Previous then
                        Previous.Container.Visible = false
                        TweenService:Create(Previous.Button, Library.TweenInfo, { BackgroundTransparency = 1 }):Play()
                        TweenService:Create(Previous.Label, Library.TweenInfo, { TextTransparency = 0.4 }):Play()
                    end

                    Tab.ActiveSubTab = SubTab
                    Tab.Sides = SubTab.Sides
                    Page.Visible = true
                    TweenService:Create(Button, Library.TweenInfo, { BackgroundTransparency = 0 }):Play()
                    TweenService:Create(Label, Library.TweenInfo, { TextTransparency = 0 }):Play()
                    Tab:RefreshSides()
                end

                SubTab.Label = Label
                SubTab:SetBadge(Info.Badge)

                Button.MouseEnter:Connect(function()
                    if Tab.ActiveSubTab ~= SubTab then
                        TweenService:Create(Label, Library.TweenInfo, { TextTransparency = 0.2 }):Play()
                    end
                end)
                Button.MouseLeave:Connect(function()
                    if Tab.ActiveSubTab ~= SubTab then
                        TweenService:Create(Label, Library.TweenInfo, { TextTransparency = 0.4 }):Play()
                    end
                end)
                Button.MouseButton1Click:Connect(SubTab.Show)

                table.insert(Section.SubTabs, SubTab)
                Tab.SubTabs[SubName] = SubTab
                if not Tab.ActiveSubTab then
                    SubTab:Show()
                end

                return SubTab
            end

            table.insert(Tab.SubTabSections, Section)
            return Section
        end

        function Tab:AddSubTabSection(SectionName: string)
            return CreateSection(SectionName)
        end

        function Tab:AddSubTab(...)
            if not DefaultSection then
                DefaultSection = CreateSection(nil)
            end

            return DefaultSection:AddSubTab(...)
        end

        function Tab:Hover(Hovering)
            if Library.ActiveTab == Tab then
                return
            end

            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = Hovering and 0.25 or 0.5,
            }):Play()
            if TabIcon then
                TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = Hovering and 0.25 or 0.5,
                }):Play()
            end
        end

        function Tab:Show()
            if Library.ActiveTab == Tab then
                return
            end

            if Library.ActiveTab then
                Library.ActiveTab:Hide()
            end

            TweenService:Create(TabButton, Library.TweenInfo, {
                BackgroundTransparency = 0,
            }):Play()
            if TabIndicator then
                TweenService:Create(TabIndicator, Library.TweenInfo, {
                    BackgroundTransparency = 0,
                }):Play()
            end
            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = 0,
            }):Play()
            if TabIcon then
                TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = 0,
                }):Play()
            end

            Library:PlayTabAnimation(Tab, true)
            Tab:RefreshSides()

            Library.ActiveTab = Tab

            if Library.Searching then
                Library:UpdateSearch(Library.SearchText)
            end
        end

        function Tab:Hide()
            TweenService:Create(TabButton, Library.TweenInfo, {
                BackgroundTransparency = 1,
            }):Play()

            if TabIndicator then
                TweenService:Create(TabIndicator, Library.TweenInfo, {
                    BackgroundTransparency = 1,
                }):Play()
            end

            TweenService:Create(TabLabel, Library.TweenInfo, {
                TextTransparency = 0.5,
            }):Play()

            if TabIcon then
                TweenService:Create(TabIcon, Library.TweenInfo, {
                    ImageTransparency = 0.5,
                }):Play()
            end

            Library:PlayTabAnimation(Tab, false)

            Library.PreviousTab = Tab
            Library.ActiveTab = nil
        end

        function Tab:SetVisible(Visible: boolean)
            TabButton.Visible = Visible

            if not Visible and Library.ActiveTab == Tab then
                Tab:Hide()
            end
        end

        function Tab:SetOrder(NewOrder: number)
            Order = NewOrder
            TabButton.LayoutOrder = Order
        end

        function Tab:SetTooltip(Text: string?)
            Tab.Tooltip = Text

            if Tab.TooltipTable then
                Tab.TooltipTable:Destroy()
                Tab.TooltipTable = nil
            end

            if typeof(Text) == "string" then
                Tab.TooltipTable = Library:AddTooltip(Text, nil, TabButton)
            end
        end

        function Tab:Destroy()
            Tab.Destroyed = true

            if Tab.Connections then
                for _, Connection in Tab.Connections do
                    Connection:Disconnect()
                end
            end

            if Tab.TooltipTable then
                Tab.TooltipTable:Destroy()
                Tab.TooltipTable = nil
            end

            for _, Groupbox in Tab.Groupboxes do
                if Groupbox.Destroy then
                    Groupbox:Destroy()
                end
            end
            table.clear(Tab.Groupboxes)

            for _, Tabbox in Tab.Tabboxes do
                if Tabbox.Destroy then
                    Tabbox:Destroy()
                end
            end
            table.clear(Tab.Tabboxes)

            for _, DepGroupbox in Tab.DependencyGroupboxes do
                if DepGroupbox.Destroy then
                    DepGroupbox:Destroy()
                end
            end

            if TabContainer then
                TabContainer:Destroy()
            end

            if TabButton then
                for Index, Entry in Library.TabButtons do
                    if typeof(Entry) == "table" and Entry.Button == TabButton then
                        table.remove(Library.TabButtons, Index)
                        break
                    end
                end

                TabButton:Destroy()
            end

            Library.Tabs[Name] = nil
        end

        --// Execution \\--
        if typeof(Tooltip) == "string" then
            Tab.TooltipTable = Library:AddTooltip(Tooltip, nil, TabButton)
        end

        if not Library.ActiveTab then
            Tab:Show()
        end

        TabButton.MouseEnter:Connect(function()
            Tab:Hover(true)
        end)
        TabButton.MouseLeave:Connect(function()
            Tab:Hover(false)
        end)
        TabButton.MouseButton1Click:Connect(Tab.Show)

        Library.Tabs[Name] = Tab

        return Tab
    end

    function Window:AddDialog(Idx, Info)
        Info = Library:Validate(Info, Templates.Dialog)

        local DialogFrame
        local DialogOverlay
        local DialogContainer
        local ButtonsHolder
        local FooterButtonsList = {}

        DialogOverlay = New("TextButton", {
            AutoButtonColor = false,
            BackgroundColor3 = "DarkColor",
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 1),
            Text = "",
            Active = false,
            ZIndex = 9000,
            Visible = true,
            Parent = MainFrame,
        })
        TweenService:Create(DialogOverlay, Library.TweenInfo, {
            BackgroundTransparency = 0.5,
        }):Play()

        DialogFrame = New("TextButton", {
            AnchorPoint = Vector2.new(0.5, 0.5),
            BackgroundColor3 = "BackgroundColor",
            Position = UDim2.fromScale(0.5, 0.5),
            Size = UDim2.fromOffset(300, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = "",
            AutoButtonColor = false,
            ZIndex = 1,
            Parent = DialogOverlay,
        })
        table.insert(
            Library.Corners,
            New("UICorner", {
                CornerRadius = UDim.new(0, WindowInfo.CornerRadius),
                Parent = DialogFrame,
            })
        )
        Library:AddOutline(DialogFrame)

        local InnerContainer = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            ZIndex = 2,
            Parent = DialogFrame,
        })
        local DialogScale = New("UIScale", {
            Scale = 0.95,
            Parent = DialogFrame,
        })
        TweenService:Create(DialogScale, Library.TweenInfo, {
            Scale = 1
        }):Play()
        local _InnerPadding = New("UIPadding", {
            PaddingBottom = UDim.new(0, 15),
            PaddingLeft = UDim.new(0, 15),
            PaddingRight = UDim.new(0, 15),
            PaddingTop = UDim.new(0, 15),
            Parent = InnerContainer,
        })
        local _InnerLayout = New("UIListLayout", {
            Padding = UDim.new(0, 10),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = InnerContainer,
        })

        local HeaderContainer = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 1,
            ZIndex = 2,
            Parent = InnerContainer,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, 6),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = HeaderContainer,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 5),
            Parent = HeaderContainer,
        })

        local TitleRow = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 20),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 1,
            ZIndex = 2,
            Parent = HeaderContainer,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, 6),
            FillDirection = Enum.FillDirection.Horizontal,
            VerticalAlignment = Enum.VerticalAlignment.Center,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = TitleRow,
        })

        if Info.Icon then
            local ParsedIcon = Library:GetCustomIcon(Info.Icon)
            if ParsedIcon then
                local IconImg = New("ImageLabel", {
                    BackgroundTransparency = 1,
                    Size = UDim2.fromOffset(16, 16),
                    ImageColor3 = Info.TitleColor or "FontColor",
                    LayoutOrder = 1,
                    ZIndex = 2,
                    Parent = TitleRow,
                })
                Library:ApplyLucideIcon(IconImg, ParsedIcon)
            end
        end

        local TitleLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 18),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = Info.Title,
            TextSize = 18,
            TextColor3 = Info.TitleColor or "FontColor",
            TextXAlignment = Enum.TextXAlignment.Left,
            LayoutOrder = 2,
            ZIndex = 2,
            Parent = TitleRow,
        })

        local DescriptionLabel = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 14),
            AutomaticSize = Enum.AutomaticSize.Y,
            Text = Info.Description,
            TextSize = 14,
            TextTransparency = Info.DescriptionColor and 0 or 0.2,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextColor3 = Info.DescriptionColor or "FontColor",
            TextWrapped = true,
            LayoutOrder = 2,
            ZIndex = 2,
            Parent = HeaderContainer,
        })

        DialogContainer = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.fromScale(1, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 4,
            ZIndex = 2,
            Parent = InnerContainer,
        })
        local _DialogContainerLayout = New("UIListLayout", {
            Padding = UDim.new(0, 8),
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = DialogContainer,
        })
        New("UIPadding", {
            PaddingBottom = UDim.new(0, 5),
            Parent = DialogContainer,
        })

        local _Sep2 = New("Frame", {
            BackgroundColor3 = "OutlineColor",
            BackgroundTransparency = 0,
            BorderSizePixel = 0,
            Size = UDim2.new(1, 0, 0, 1),
            LayoutOrder = 5,
            ZIndex = 2,
            Parent = InnerContainer,
        })

        ButtonsHolder = New("Frame", {
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 0),
            AutomaticSize = Enum.AutomaticSize.Y,
            LayoutOrder = 6,
            ZIndex = 2,
            Parent = InnerContainer,
        })
        New("UIListLayout", {
            Padding = UDim.new(0, 8),
            FillDirection = Enum.FillDirection.Horizontal,
            HorizontalAlignment = Enum.HorizontalAlignment.Right,
            Wraps = true,
            SortOrder = Enum.SortOrder.LayoutOrder,
            Parent = ButtonsHolder,
        })
        New("UIPadding", {
            PaddingTop = UDim.new(0, 5),
            Parent = ButtonsHolder,
        })

        local Dialog = {
            Destroyed = false,
            Elements = {},
            Container = DialogContainer,
            OutsideClickDismiss = Info.OutsideClickDismiss,
        }

        function Dialog:Resize()
            local MaxWidth = (MainFrame.AbsoluteSize.X / Library.DPIScale) * 0.75
            local MinWidth = 400

            local TotalButtonWidth = 0
            local ButtonCount = 0
            local HasButtons = false

            for _, BtnWrap in FooterButtonsList do
                HasButtons = true
                ButtonCount = ButtonCount + 1
                TotalButtonWidth = TotalButtonWidth + BtnWrap.Container.Size.X.Offset
            end

            local TargetWidth = MinWidth
            if HasButtons then
                local RequiredWidth = TotalButtonWidth + ((ButtonCount - 1) * 8) + 30
                TargetWidth = math.max(MinWidth, math.min(RequiredWidth, MaxWidth))
            end

            DialogFrame.Size = UDim2.fromOffset(TargetWidth, 0)

            local _DescX, DescY = Library:GetTextBounds(DescriptionLabel.Text, Library.Scheme.Font, 14, TargetWidth - 30)
            DescriptionLabel.Size = UDim2.new(1, 0, 0, DescY)

            local HasElements = false
            for _, v in DialogContainer:GetChildren() do
                if not v:IsA("UIListLayout") and not v:IsA("UIPadding") then
                    HasElements = true
                    break
                end
            end
            DialogContainer.Visible = HasElements

            ButtonsHolder.Visible = HasButtons
            _Sep2.Visible = HasButtons
        end

        function Dialog:SetTitle(Title)
            TitleLabel.Text = Title
            Dialog:Resize()
        end

        function Dialog:SetDescription(Description)
            DescriptionLabel.Text = Description
            Dialog:Resize()
        end

        function Dialog:Dismiss()
            if Dialog.Destroyed then
                return
            end

            Dialog.Destroyed = true

            if Library.ActiveDialog == Dialog then
                Library.ActiveDialog = nil
            end

            for Index = #Dialog.Elements, 1, -1 do
                local Element = Dialog.Elements[Index]
                if Element and Element.Destroy then
                    Element:Destroy()
                end
            end
            table.clear(Dialog.Elements)

            local CloseTween = TweenService:Create(DialogScale, Library.TweenInfo, { Scale = 0.95 })
            TweenService:Create(DialogOverlay, Library.TweenInfo, { BackgroundTransparency = 1 }):Play()
            CloseTween:Play()

            task.delay(Library.TweenInfo.Time, function()
                DialogOverlay:Destroy()
            end)
            Library.Dialogues[Idx] = nil
        end

        DialogOverlay.MouseButton1Click:Connect(function()
            if Info.OutsideClickDismiss then
                Dialog:Dismiss()
            end
        end)

        function Dialog:RemoveFooterButton(ButtonIdx)
            if FooterButtonsList[ButtonIdx] then
                FooterButtonsList[ButtonIdx].Container:Destroy()
                FooterButtonsList[ButtonIdx] = nil
            end
        end

        function Dialog:SetButtonDisabled(ButtonIdx, Disabled)
            if FooterButtonsList[ButtonIdx] and type(FooterButtonsList[ButtonIdx].SetDisabled) == "function" then
                FooterButtonsList[ButtonIdx]:SetDisabled(Disabled)
            end
        end

        function Dialog:SetButtonOrder(ButtonIdx, Order)
            if FooterButtonsList[ButtonIdx] and FooterButtonsList[ButtonIdx].Container then
                FooterButtonsList[ButtonIdx].Container.LayoutOrder = Order
            end
        end

        function Dialog:AddFooterButton(ButtonIdx, ButtonInfo)
            Dialog:RemoveFooterButton(ButtonIdx)

            local WaitTime = ButtonInfo.WaitTime or 0

            local ButtonContainer = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(0, 26),
                LayoutOrder = ButtonInfo.Order or 0,
                ZIndex = 2,
                Parent = ButtonsHolder,
            })

            local BtnColor = "MainColor"
            local BtnOutline = "OutlineColor"
            local Variant = ButtonInfo.Variant or "Primary"

            if Variant == "Primary" then
                BtnColor = "FontColor"
                BtnOutline = "FontColor"
            elseif Variant == "Secondary" then
                BtnColor = "MainColor"
                BtnOutline = "OutlineColor"
            elseif Variant == "Destructive" then
                BtnColor = "DestructiveColor"
                BtnOutline = "DestructiveColor"
            elseif Variant == "Ghost" then
                BtnColor = "BackgroundColor"
                BtnOutline = "BackgroundColor"
            end

            local TextBtn = New("TextButton", {
                BackgroundColor3 = BtnColor,
                BorderColor3 = BtnOutline,
                BackgroundTransparency = WaitTime > 0 and 0.5 or 0,
                Size = UDim2.fromOffset(0, 26),
                Text = "",
                AutoButtonColor = false,
                ZIndex = 2,
                Parent = ButtonContainer,
            })
            Library:AddOutline(TextBtn)
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius),
                    Parent = TextBtn
                })
            )

            local _BtnPadding = New("UIPadding", {
                PaddingLeft = UDim.new(0, 15),
                PaddingRight = UDim.new(0, 15),
                Parent = TextBtn,
            })

            local TextColor = Library.Scheme.FontColor
            if Variant == "Primary" then
                TextColor = Library.Scheme.BackgroundColor
            elseif Variant == "Destructive" then
                TextColor = Color3.new(1, 1, 1)
            end

            local BtnLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = ButtonInfo.Title or ButtonIdx,
                TextColor3 = TextColor,
                TextTransparency = WaitTime > 0 and 0.5 or 0,
                TextSize = 14,
                ZIndex = 2,
                Parent = TextBtn,
            })

            local LabelX, _ = Library:GetTextBounds(BtnLabel.Text, Library.Scheme.Font, 14, 250)
            ButtonContainer.Size = UDim2.fromOffset(LabelX + 30, 26)
            TextBtn.Size = UDim2.fromOffset(LabelX + 30, 26)

            local ProgressBar
            if WaitTime > 0 then
                ProgressBar = New("Frame", {
                    BackgroundColor3 = "AccentColor",
                    BorderSizePixel = 0,
                    Position = UDim2.new(0, 0, 1, -2),
                    Size = UDim2.new(0, 0, 0, 2),
                    ZIndex = 2,
                    Parent = TextBtn,
                })
                table.insert(
                    Library.Corners,
                    New("UICorner", {
                        CornerRadius = UDim.new(0, Library.CornerRadius),
                        Parent = ProgressBar
                    })
                )
            end

            local IsActive = WaitTime <= 0

            local ButtonWrap = {
                Container = ButtonContainer,
                SetDisabled = function(self, Disabled)
                    IsActive = not Disabled
                    if Disabled then
                        TweenService:Create(TextBtn, Library.TweenInfo, { BackgroundTransparency = 0.5 }):Play()
                        TweenService:Create(BtnLabel, Library.TweenInfo, { TextTransparency = 0.5 }):Play()
                    else
                        TweenService:Create(TextBtn, Library.TweenInfo, { BackgroundTransparency = 0 }):Play()
                        TweenService:Create(BtnLabel, Library.TweenInfo, { TextTransparency = 0 }):Play()
                    end
                end
            }

            local ActiveColor = typeof(BtnColor) == "Color3" and BtnColor or Library.Scheme[BtnColor]
            local HoverColor = Variant == "Ghost" and Library.Scheme.MainColor or Library:GetBetterColor(ActiveColor, 10)

            TextBtn.MouseEnter:Connect(function()
                if not IsActive then return end
                TweenService:Create(TextBtn, Library.TweenInfo, {
                    BackgroundColor3 = HoverColor
                }):Play()
            end)
            TextBtn.MouseLeave:Connect(function()
                if not IsActive then return end
                TweenService:Create(TextBtn, Library.TweenInfo, {
                    BackgroundColor3 = ActiveColor
                }):Play()
            end)

            TextBtn.MouseButton1Click:Connect(function()
                if not IsActive then return end
                if ButtonInfo.Callback then
                    ButtonInfo.Callback(Dialog)
                end
                if Info.AutoDismiss then
                    Dialog:Dismiss()
                end
            end)

            if WaitTime > 0 then
                TweenService:Create(ProgressBar, TweenInfo.new(WaitTime, Enum.EasingStyle.Linear), {
                    Size = UDim2.new(1, 0, 0, 2)
                }):Play()

                task.delay(WaitTime, function()
                    ButtonWrap:SetDisabled(false)
                    if ProgressBar then
                        TweenService:Create(ProgressBar, Library.TweenInfo, {
                            BackgroundTransparency = 1
                        }):Play()
                    end
                end)
            end

            FooterButtonsList[ButtonIdx] = ButtonWrap
        end

        for BIdx, BInfo in Info.FooterButtons do
            if type(BIdx) == "number" and BInfo.Id then BIdx = BInfo.Id end
            Dialog:AddFooterButton(BIdx, BInfo)
        end

        setmetatable(Dialog, BaseGroupbox)
        Library.Dialogues[Idx] = Dialog

        Dialog:Resize()

        Library.ActiveDialog = Dialog
        return Dialog
    end

    local GuiProperties = { "BackgroundTransparency" }
    local ImageProperties = { "BackgroundTransparency", "ImageTransparency" }
    local TextProperties = { "BackgroundTransparency", "TextTransparency" }
    local StrokeProperties = { "Transparency" }

    local function FadeInstance(Desc, Properties)
        local Cache = TransparencyCache[Desc]
        if not Cache then
            Cache = {}
            TransparencyCache[Desc] = Cache
        end

        for _, Prop in Properties do
            if not Library.Toggled then
                Cache[Prop] = Desc[Prop]
            end

            if Cache[Prop] ~= nil and Cache[Prop] ~= 1 then
                TweenService:Create(Desc, Library.WindowAnimationInfo, {
                    [Prop] = Library.Toggled and Cache[Prop] or 1,
                }):Play()
            end
        end
    end

    function Window:Toggle(Value: boolean?)
        if Fading then
            return
        end

        if Library.ActiveLoading then
            if Value == true then
                return
            end

            if not Library.Toggled then
                return
            end
        end

        if typeof(Value) == "boolean" then
            Library.Toggled = Value
        else
            Library.Toggled = not Library.Toggled
        end

        if not Library.Toggled and Library.HideSearchResults then
            Library.HideSearchResults()
        end

        if IslandMinimized and DismissIsland then
            DismissIsland()
        end

        if Library.Animations and Library.Animations.ToggleWindow == true then
            local FadeTime = Library.WindowAnimationInfo.Time
            Fading = true

            if Library.Toggled then
                MainFrame.Visible = true
            end

            if Library.Toggled then
                FadeInstance(MainFrame, { "BackgroundTransparency" })
                task.wait(FadeTime / 2)
            else
                task.delay(FadeTime / 2, FadeInstance, MainFrame, { "BackgroundTransparency" })
            end

            for _, Instance in MainFrame:GetDescendants() do
                if Instance == TopBar then
                    continue
                end

                if Instance:IsA("GuiObject") then
                    local ClassName = Instance.ClassName
                    if ClassName == "ImageLabel" or ClassName == "ImageButton" then
                        FadeInstance(Instance, ImageProperties)
                    elseif ClassName == "TextLabel" or ClassName == "TextBox" or ClassName == "TextButton" then
                        FadeInstance(Instance, TextProperties)
                    else
                        FadeInstance(Instance, GuiProperties)
                    end
                elseif Instance.ClassName == "UIStroke" then
                    FadeInstance(Instance, StrokeProperties)
                end
            end

            task.delay(FadeTime, function()
                MainFrame.Visible = Library.Toggled
                Fading = false
            end)
        else
            MainFrame.Visible = Library.Toggled
        end

        if WindowInfo.UnlockMouseWhileOpen then
            ModalElement.Modal = Library.Toggled
        end

        if Library.Toggled and not Library.IsMobile then
            local ShowCursorBinding = Library.ShowCursorBinding
            Library.OriginalMouseIconEnabled = UserInputService.MouseIconEnabled

            pcall(function() RunService:UnbindFromRenderStep(ShowCursorBinding) end)
            RunService:BindToRenderStep(ShowCursorBinding, Enum.RenderPriority.Last.Value, function()
                UserInputService.MouseIconEnabled = true

                if Library.Unloaded == true or not (Library.Toggled and ScreenGui and ScreenGui.Parent) then
                    RestoreMouseIcon()
                end
            end)
        elseif not Library.Toggled then
            RestoreMouseIcon()
            TooltipLabel.Visible = false

            for _, Option in Library.Options do
                if Option.Type == "ColorPicker" then
                    Option.ColorMenu:Close()
                    Option.ContextMenu:Close()
                elseif Option.Type == "Dropdown" or Option.Type == "KeyPicker" then
                    Option.Menu:Close()
                end
            end
        end
    end

    function Library:Toggle(Value: boolean?)
        return Window:Toggle(Value)
    end

    if WindowInfo.EnableSidebarResize then
        local Threshold = (WindowInfo.MinSidebarWidth + WindowInfo.SidebarCompactWidth) * WindowInfo.SidebarCollapseThreshold
        local StartPos, StartWidth
        local Dragging = false
        local Changed

        local SidebarGrabber = New("TextButton", {
            AnchorPoint = Vector2.new(0.5, 0),
            BackgroundTransparency = 1,
            Position = UDim2.fromScale(0.5, 0),
            Size = UDim2.new(0, 8, 1, 0),
            Text = "",
            Parent = DividerLine,
        })
        SidebarGrabber.MouseEnter:Connect(function()
            TweenService:Create(DividerLine, Library.TweenInfo, {
                BackgroundColor3 = Library:GetLighterColor(Library.Scheme.OutlineColor),
            }):Play()
        end)
        SidebarGrabber.MouseLeave:Connect(function()
            if Dragging then
                return
            end
            TweenService:Create(DividerLine, Library.TweenInfo, {
                BackgroundColor3 = Library.Scheme.OutlineColor,
            }):Play()
        end)

        SidebarGrabber.InputBegan:Connect(function(Input: InputObject)
            if not IsClickInput(Input) then
                return
            end

            Library.CantDragForced = true

            StartPos = Input.Position
            StartWidth = Window:GetSidebarWidth()
            Dragging = true

            Changed = Input.Changed:Connect(function()
                if Input.UserInputState ~= Enum.UserInputState.End then
                    return
                end

                Library.CantDragForced = false
                TweenService:Create(DividerLine, Library.TweenInfo, {
                    BackgroundColor3 = Library.Scheme.OutlineColor,
                }):Play()

                Dragging = false
                if Changed and Changed.Connected then
                    Changed:Disconnect()
                    Changed = nil
                end
            end)
        end)

        Library:GiveSignal(UserInputService.InputChanged:Connect(function(Input: InputObject)
            if not Library.Toggled or not (ScreenGui and ScreenGui.Parent) then
                Dragging = false
                if Changed and Changed.Connected then
                    Changed:Disconnect()
                    Changed = nil
                end

                return
            end

            if Dragging and IsHoverInput(Input) then
                local Delta = Input.Position - StartPos
                local Width = StartWidth + Delta.X

                if WindowInfo.DisableCompactingSnap then
                    Window:SetSidebarWidth(Width)
                    return
                end

                if Width > Threshold then
                    Window:SetSidebarWidth(math.max(Width, WindowInfo.MinSidebarWidth))
                else
                    Window:SetSidebarWidth(WindowInfo.SidebarCompactWidth)
                end
            end
        end))
    end

    Window:SetAlwaysOnTop(WindowInfo.AlwaysOnTop)
    if WindowInfo.EnableCompacting and WindowInfo.SidebarCompacted then
        Window:SetSidebarWidth(WindowInfo.SidebarCompactWidth)
    end
    if WindowInfo.AutoShow and not Library.ActiveLoading then
        task.spawn(Library.Toggle)
    end

    if Library.IsMobile then
        local ToggleButton = Library:AddDraggableButton("Toggle", function()
            Library:Toggle()
        end, true)

        local LockButton = Library:AddDraggableButton("Lock", function(self)
            Library.CantDragForced = not Library.CantDragForced
            self:SetText(Library.CantDragForced and "Unlock" or "Lock")
        end, true)

        if WindowInfo.MobileButtonsSide == "Right" then
            ToggleButton.Button.AnchorPoint = Vector2.new(1, 0)
            ToggleButton.Button.Position = UDim2.new(1, -6, 0, 6)

            LockButton.Button.AnchorPoint = Vector2.new(1, 0)
            LockButton.Button.Position = UDim2.new(1, -(ToggleButton.Button.Size.X.Offset + 12), 0, 6)
        else
            ToggleButton.Button.AnchorPoint = Vector2.new(0, 0)
            ToggleButton.Button.Position = UDim2.fromOffset(6, 6)

            LockButton.Button.AnchorPoint = Vector2.new(0, 0)
            LockButton.Button.Position = UDim2.fromOffset(ToggleButton.Button.Size.X.Offset + 12, 6)
        end

        if WindowInfo.ShowMobileButtons == false then
            ToggleButton.Button.Visible = false
            LockButton.Button.Visible = false
        end
    end

    --// Execution \\--
    Library:GiveSignal(SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        Library:UpdateSearch(SearchBox.Text)
    end))

    Library:GiveSignal(UserInputService.InputBegan:Connect(function(Input: InputObject)
        if Library.Unloaded then
            return
        end

        if Input.KeyCode == Enum.KeyCode.Escape then
            -- Releasing focus from a text input takes priority and never toggles the window --
            local FocusedBox = UserInputService:GetFocusedTextBox()
            if FocusedBox then
                FocusedBox:ReleaseFocus()
                return
            end

            -- Dismiss the topmost dialog before closing any open menu --
            if Library.ActiveDialog and Library.ActiveDialog.OutsideClickDismiss ~= false then
                Library.ActiveDialog:Dismiss()
                return
            end

            if CurrentMenu then
                CurrentMenu:Close()
                return
            end

            return
        end

        if UserInputService:GetFocusedTextBox() then
            return
        end

        if Input.KeyCode == Library.ToggleKeybind then
            Library:Toggle()
        end
    end))

    Library:GiveSignal(UserInputService.WindowFocused:Connect(function()
        Library.IsRobloxFocused = true
    end))
    Library:GiveSignal(UserInputService.WindowFocusReleased:Connect(function()
        Library.IsRobloxFocused = false
    end))

    Window.MainFrame = MainFrame
    Library.Window = Window

    return Window
end

function Library:CreateLoading(LoadingInfo)
    if Library.ActiveLoading then
        warn("Loading GUI already exists, you cannot create multiple Loading GUIs.")
        return Library.ActiveLoading
    end

    LoadingInfo = Library:Validate(LoadingInfo, Templates.Loading)

    local Loading = {
        CurrentStep = LoadingInfo.CurrentStep,
        TotalSteps = LoadingInfo.TotalSteps,

        ShowSidebar = LoadingInfo.ShowSidebar,
        AutoResizeHeight = LoadingInfo.AutoResizeHeight,
        AlwaysOnTop = LoadingInfo.AlwaysOnTop,

        IsError = false,
        Destroyed = false,

        WindowWidth = LoadingInfo.WindowWidth,
        WindowHeight = LoadingInfo.WindowHeight,
        BaseWindowHeight = LoadingInfo.WindowHeight,
        WindowErrorHeight = LoadingInfo.WindowHeight,

        ContentWidth = LoadingInfo.ContentWidth,
        SidebarWidth = LoadingInfo.SidebarWidth,
    }

    --// ScreenGui \\--
    local ScreenGui = New("ScreenGui", {
        Name = "ObsidianLoading",
        DisplayOrder = 999,
        ResetOnSpawn = false
    })
    ParentUI(ScreenGui)
    Loading.ScreenGui = ScreenGui
    SetAlwaysOnTop(ScreenGui, LoadingInfo.AlwaysOnTop)

    ScreenGui.DescendantRemoving:Connect(function(Instance)
        task.defer(function()
            if Instance.Parent and Instance:IsDescendantOf(ScreenGui) then
                return
            end

            Library:RemoveFromRegistry(Instance)
        end)
    end)

    --// Main Frame \\--
    local MainFrame = New("TextButton", {
        Name = "Main",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = function()
            return Library:GetBetterColor(Library.Scheme.BackgroundColor, -1)
        end,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(Loading.ShowSidebar and (Loading.ContentWidth + Loading.SidebarWidth) or Loading.WindowWidth, Loading.WindowHeight),
        ClipsDescendants = true,
        Text = "",
        AutoButtonColor = false,
        Parent = ScreenGui,
    })
    Library:AddOutline(MainFrame)
    table.insert(Library.Corners, New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius), Parent = MainFrame }))

    local MainScale = New("UIScale", {
        Scale = Library.IsMobile and 0.8 or 1,
        Parent = MainFrame
    })
    table.insert(Library.Scales, MainScale)
    Library.ScalesOffset[MainScale] = Library.IsMobile and 0.2 or 0

    --// Layout Containers \\--
    local Container = New("Frame", {
        Name = "Content",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(0, Loading.ContentWidth, 1, 0),
        Parent = MainFrame,
    })

    local SideBar = New("Frame", {
        Name = "SideBar",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(Loading.ContentWidth, 0),
        Size = UDim2.new(0, Loading.ShowSidebar and Loading.SidebarWidth or 0, 1, 0),
        ClipsDescendants = true,
        Visible = Loading.ShowSidebar,
        Parent = MainFrame,
    })
    local SidebarCorner = New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius), Parent = SideBar })
    table.insert(Library.Corners, SidebarCorner)

    Library:AddOutline(SideBar)

    local SidebarDivider = New("Frame", {
        BackgroundColor3 = "OutlineColor",
        BorderSizePixel = 0,
        Position = UDim2.fromOffset(0, 0),
        Size = UDim2.new(0, 1, 1, 0),
        Visible = Loading.ShowSidebar,
        Parent = SideBar,
    })

    --// Top Bar \\--
    local TopBar = New("Frame", {
        Name = "TopBar",
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 48),
        ZIndex = 2,
        Parent = Container,
    })
    Library:MakeDraggable(MainFrame, TopBar, true, true)

    local TitleHolder = New("Frame", {
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Parent = TopBar,
    })
    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 6),
        Parent = TitleHolder,
    })
    New("UIPadding", {
        PaddingLeft = UDim.new(0, 12),
        Parent = TitleHolder,
    })

    if LoadingInfo.Icon then
        local Icon = Library:GetCustomIcon(LoadingInfo.Icon)
        local _WindowIcon = New("ImageLabel", {
            Size = LoadingInfo.IconSize,
            Parent = TitleHolder,
        })
        if Icon then
            Library:ApplyLucideIcon(_WindowIcon, Icon)
        end
    else
        local _WindowIcon = New("TextLabel", {
            BackgroundTransparency = 1,
            Size = LoadingInfo.IconSize,
            Text = LoadingInfo.Title:sub(1, 1),
            TextScaled = true,
            Visible = false,
            Parent = TitleHolder,
        })
    end

    local LoadingIconWidth = LoadingInfo.Icon and (LoadingInfo.IconSize.X.Offset + 6) or 0
    local LoadingMaxWidth = math.max(0, (TitleHolder.AbsoluteSize.X / Library.DPIScale) - LoadingIconWidth - 12)
    local LoadingTitleWidth = math.min(
        Library:GetTextBounds(LoadingInfo.Title, Library.Scheme.Font, 20),
        LoadingMaxWidth
    )
    local _WindowTitle = New("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.new(0, LoadingTitleWidth, 1, 0),
        Text = LoadingInfo.Title,
        TextSize = 20,
        TextTruncate = Enum.TextTruncate.AtEnd,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Center,
        Parent = TitleHolder,
    })

    Library:MakeLine(Container, {
        Position = UDim2.fromOffset(0, 48),
        Size = UDim2.new(1, 0, 0, 1),
    })

    --// Loading Content Elements \\--
    local InnerContent = New("Frame", {
        Name = "InnerContent",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 49),
        Size = UDim2.new(1, 0, 1, -49),
        Parent = Container,
    })

    New("UIListLayout", {
        FillDirection = Enum.FillDirection.Vertical,
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        Padding = UDim.new(0, 12),
        Parent = InnerContent,
    })

    local IconHolder = New("Frame", {
        Name = "IconHolder",
        BackgroundTransparency = 1,
        Size = UDim2.fromOffset(64, 64),
        Parent = InnerContent,
    })

    local LoaderIcon = Library:GetCustomIcon(LoadingInfo.LoadingIcon)
    local LoadingIcon = New("ImageLabel", {
        Name = "LoaderIcon",
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundTransparency = 1,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromScale(1, 1),
        ImageColor3 = LoadingInfo.LoadingIconColor or ((LoadingInfo.LoadingIcon == Templates.Loading.LoadingIcon) and "AccentColor" or "WhiteColor"),
        Parent = IconHolder,
    })
    if LoaderIcon then
        Library:ApplyLucideIcon(LoadingIcon, LoaderIcon)
    end

    local RotationTween
    if LoadingInfo.LoadingIconTweenTime > 0 then
        RotationTween = TweenService:Create(
            LoadingIcon,
            TweenInfo.new(LoadingInfo.LoadingIconTweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
            { Rotation = 360 }
        )
        RotationTween:Play()
    end

    local MessageLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        AutomaticSize = Loading.AutoResizeHeight and Enum.AutomaticSize.Y or Enum.AutomaticSize.XY,
        Size = Loading.AutoResizeHeight and UDim2.new(1, -60, 0, 0) or UDim2.fromOffset(0, 0),
        Text = "",
        TextSize = 18,
        TextWrapped = Loading.AutoResizeHeight,
        Parent = InnerContent,
    })

    local DescriptionLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        AutomaticSize = Loading.AutoResizeHeight and Enum.AutomaticSize.Y or Enum.AutomaticSize.XY,
        Size = Loading.AutoResizeHeight and UDim2.new(1, -60, 0, 0) or UDim2.fromOffset(0, 0),
        Text = "",
        TextSize = 14,
        TextTransparency = 0.5,
        TextWrapped = Loading.AutoResizeHeight,
        Parent = InnerContent,
    })

    --// Progress Bar \\--
    local SliderBar = New("Frame", {
        BackgroundColor3 = "MainColor",
        Size = UDim2.new(0.7, 0, 0, 15),
        Parent = InnerContent,
    })
    Library:AddOutline(SliderBar)
    table.insert(Library.Corners, New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius / 2), Parent = SliderBar }))

    local SliderFill = New("Frame", {
        BackgroundColor3 = "AccentColor",
        BorderSizePixel = 0,
        Size = UDim2.fromScale(0, 1),
        Parent = SliderBar,
    })
    table.insert(Library.Corners, New("UICorner", { CornerRadius = UDim.new(0, Library.CornerRadius / 2), Parent = SliderFill }))

    local ProgressLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Size = UDim2.fromScale(1, 1),
        Text = "",
        TextSize = 14,
        ZIndex = 2,
        Parent = SliderBar,
    })
    New("UIStroke", {
        ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual,
        Color = "DarkColor",
        LineJoinMode = Enum.LineJoinMode.Miter,
        Parent = ProgressLabel,
    })

    --// Sidebar Object \\--
    local SidebarScrolling = New("ScrollingFrame", {
        BackgroundTransparency = 1,
        BorderSizePixel = 0,
        CanvasSize = UDim2.new(0, 0, 0, 0),
        Size = UDim2.fromScale(1, 1),
        ScrollBarThickness = 2,
        ScrollBarImageColor3 = "OutlineColor",
        Parent = SideBar,
    })
    local SidebarList = New("UIListLayout", {
        Padding = UDim.new(0, 8),
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = SidebarScrolling,
    })
    New("UIPadding", {
        PaddingBottom = UDim.new(0, 12),
        PaddingLeft = UDim.new(0, 12),
        PaddingRight = UDim.new(0, 12),
        PaddingTop = UDim.new(0, 12),
        Parent = SidebarScrolling,
    })

    local SidebarObject = {
        Elements = {},
        DependencyBoxes = {},
        Tabboxes = {},

        BoxHolder = SidebarScrolling,
        Container = SidebarScrolling,

        Resize = function(self)
            SidebarScrolling.CanvasSize = UDim2.fromOffset(0, SidebarList.AbsoluteContentSize.Y + 24)
        end,
        Tab = {
            Elements = {},
            DependencyBoxes = {},
            DependencyGroupboxes = {},
            Tabboxes = {},
        },
    }

    SidebarList:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        SidebarObject:Resize()
    end)

    setmetatable(SidebarObject, BaseGroupbox)
    Loading.Sidebar = SidebarObject

    --// Error Frame \\--
    local ErrorFrame = New("Frame", {
        Name = "Error",
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(0, 49),
        Size = UDim2.new(1, 0, 1, -49),
        ClipsDescendants = true,
        Visible = false,
        Parent = Container,
    })

    local _ErrorTitle = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(15, 15),
        Size = UDim2.new(1, -30, 0, 18),
        Text = "Error",
        TextColor3 = "RedColor",
        TextSize = 18,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = ErrorFrame,
    })

    local ErrorLabel = New("TextLabel", {
        BackgroundTransparency = 1,
        Position = UDim2.fromOffset(15, 39),
        Size = UDim2.new(1, -30, 1, -90),
        Text = "Error Message",
        TextSize = 14,
        TextTransparency = 0.2,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        Parent = ErrorFrame,
    })

    local ErrorButtonsDivider = New("Frame", {
        BackgroundColor3 = "OutlineColor",
        BackgroundTransparency = 0,
        BorderSizePixel = 0,
        AnchorPoint = Vector2.new(0.5, 0),
        Position = UDim2.new(0.5, 0, 1, -48),
        Size = UDim2.new(1, -30, 0, 1),
        Visible = false,
        Parent = ErrorFrame,
    })

    local ErrorButtonsHolder = New("Frame", {
        AnchorPoint = Vector2.new(0.5, 1),
        BackgroundTransparency = 1,
        Position = UDim2.new(0.5, 0, 1, 0),
        Size = UDim2.new(1, 0, 0, 42),
        Visible = false,
        Parent = ErrorFrame,
    })
    New("UIListLayout", {
        Padding = UDim.new(0, 8),
        FillDirection = Enum.FillDirection.Horizontal,
        HorizontalAlignment = Enum.HorizontalAlignment.Right,
        VerticalAlignment = Enum.VerticalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
        Parent = ErrorButtonsHolder,
    })
    New("UIPadding", {
        PaddingTop = UDim.new(0, 5),
        PaddingBottom = UDim.new(0, 15),
        PaddingRight = UDim.new(0, 15),
        Parent = ErrorButtonsHolder,
    })

    function Loading:UpdateLayout()
        if Loading.IsError then
            Loading:RecalculateErrorHeight()
        end

        local ShowSidebar = Loading.ShowSidebar
        local FinalWidth = ShowSidebar and (Loading.ContentWidth + Loading.SidebarWidth) or Loading.WindowWidth
        local FinalHeight = Loading.IsError and Loading.WindowErrorHeight or Loading.WindowHeight

        if ShowSidebar then
            SideBar.Visible = true
            SidebarDivider.Visible = true
        end

        TweenService:Create(MainFrame, Library.TweenInfo, { Size = UDim2.fromOffset(FinalWidth, FinalHeight) }):Play()
        TweenService:Create(SideBar, Library.TweenInfo, { Position = UDim2.fromOffset(Loading.ContentWidth, 0), Size = UDim2.new(0, ShowSidebar and Loading.SidebarWidth or 0, 1, 0) }):Play()
        TweenService:Create(Container, Library.TweenInfo, { Size = UDim2.new(0, ShowSidebar and Loading.ContentWidth or Loading.WindowWidth, 1, 0) }):Play()

        if not ShowSidebar then
            task.delay(Library.TweenInfo.Time, function()
                if not Loading.ShowSidebar then
                    SideBar.Visible = false
                    SidebarDivider.Visible = false
                end
            end)
        end
    end

    --// Content Page \\--
    function Loading:RecalculateLoadingHeight()
        if not Loading.AutoResizeHeight then
            return
        end

        local RequiredHeight =
              49 -- TopBar
            + 48 -- Padding
            + InnerContent.UIListLayout.AbsoluteContentSize.Y

        Loading.WindowHeight = math.max(Loading.BaseWindowHeight, RequiredHeight)
    end

    function Loading:SetMessage(Text)
        MessageLabel.Text = Text

        if Loading.AutoResizeHeight then
            Loading:RecalculateLoadingHeight()
            Loading:UpdateLayout()
        end
    end

    function Loading:SetDescription(Text)
        DescriptionLabel.Text = Text

        if Loading.AutoResizeHeight then
            Loading:RecalculateLoadingHeight()
            Loading:UpdateLayout()
        end
    end

    function Loading:SetLoadingIcon(Icon)
        local IconData = Library:GetCustomIcon(Icon)
        assert(IconData, "Image must be a valid Roblox asset or a valid URL or a valid lucide icon.")

        Library:ApplyLucideIcon(LoadingIcon, IconData)
    end

    function Loading:SetLoadingIconTweenTime(TweenTime)
        if RotationTween then
            StopTween(RotationTween, true)
            RotationTween = nil
        end

        if TweenTime > 0 then
            RotationTween = TweenService:Create(
                LoadingIcon,
                TweenInfo.new(TweenTime, Enum.EasingStyle.Linear, Enum.EasingDirection.Out, -1),
                { Rotation = 360 }
            )
            RotationTween:Play()
        else
            LoadingIcon.Rotation = 0
        end
    end

    function Loading:SetLoadingIconColor(Color)
        LoadingIcon.ImageColor3 = Color
    end

    function Loading:SetCurrentStep(Step)
        Loading.CurrentStep = math.clamp(Step, 0, Loading.TotalSteps)

        local Progress = Loading.CurrentStep / Loading.TotalSteps
        TweenService:Create(SliderFill, Library.TweenInfo, { Size = UDim2.fromScale(Progress, 1) }):Play()

        ProgressLabel.Text = string.format("%d/%d", Loading.CurrentStep, Loading.TotalSteps)
    end

    function Loading:SetTotalSteps(Steps)
        Loading.TotalSteps = Steps
        Loading:SetCurrentStep(Loading.CurrentStep)
    end

    --// Size \\--
    function Loading:SetWindowHeight(Height)
        Loading.WindowHeight = Height
        Loading:UpdateLayout()
    end

    function Loading:SetWindowWidth(Width)
        Loading.WindowWidth = Width
        Loading:UpdateLayout()
    end

    function Loading:SetContentWidth(Width)
        Loading.ContentWidth = Width
        Loading:UpdateLayout()
    end

    function Loading:SetSidebarWidth(Width)
        Loading.SidebarWidth = Width
        Loading:UpdateLayout()
    end

    --// Sidebar \\--
    function Loading:ShowSidebarPage(Bool)
        Loading.ShowSidebar = Bool
        Loading:UpdateLayout()
    end

    --// Error Page \\--
    function Loading:ShowErrorPage(Enabled)
        Loading.IsError = Enabled
        InnerContent.Visible = not Enabled
        ErrorFrame.Visible = Enabled

        if Loading.ShowSidebar then
            Loading:ShowSidebarPage(not Enabled)
        else
            Loading:UpdateLayout()
        end
    end

    function Loading:RecalculateErrorHeight()
        local TargetWidth = (Loading.ShowSidebar and Loading.ContentWidth or Loading.WindowWidth) - 30
        local _, ErrorY = Library:GetTextBounds(ErrorLabel.Text, Library.Scheme.Font, 14, TargetWidth)

        ErrorLabel.Size = UDim2.new(1, -30, 0, ErrorY)

        local HasButtons = ErrorButtonsHolder.Visible
        local RequiredHeight =
              49                        -- TopBar
            + 15                        -- Padding Top
            + 18                        -- Title Height
            + 6                         -- Padding between Title and Label
            + ErrorY                    -- Label Height
            + 15                        -- Padding between Label and Buttons
            + (HasButtons and 48 or 0)  -- Buttons Area

        Loading.WindowErrorHeight = RequiredHeight -- math.max(Loading.WindowHeight, RequiredHeight)
    end

    function Loading:SetErrorMessage(Text)
        ErrorLabel.Text = Text
        Loading:UpdateLayout()
    end

    function Loading:SetErrorButtons(Buttons)
        assert(typeof(Buttons) == "table", "Buttons must be a table")

        for _, button in ErrorButtonsHolder:GetChildren() do
            if button:IsA("Frame") then
                button:Destroy()
            end
        end

        local HasButtons = GetTableSize(Buttons) > 0
        ErrorButtonsHolder.Visible = HasButtons
        ErrorButtonsDivider.Visible = HasButtons

        for Idx, ButtonInfo in Buttons do
            local ButtonContainer = New("Frame", {
                BackgroundTransparency = 1,
                Size = UDim2.fromOffset(0, 26),
                Parent = ErrorButtonsHolder,
            })

            local BtnColor = "MainColor"
            local BtnOutline = "OutlineColor"
            local Variant = ButtonInfo.Variant or "Primary"

            if Variant == "Primary" then
                BtnColor = "FontColor"
                BtnOutline = "FontColor"
            elseif Variant == "Secondary" then
                BtnColor = "MainColor"
                BtnOutline = "OutlineColor"
            elseif Variant == "Destructive" then
                BtnColor = "DestructiveColor"
                BtnOutline = "DestructiveColor"
            elseif Variant == "Ghost" then
                BtnColor = "BackgroundColor"
                BtnOutline = "BackgroundColor"
            end

            local TextBtn = New("TextButton", {
                BackgroundColor3 = BtnColor,
                BorderColor3 = BtnOutline,
                Size = UDim2.fromOffset(0, 26),
                Text = "",
                AutoButtonColor = false,
                Parent = ButtonContainer,
            })
            Library:AddOutline(TextBtn)
            table.insert(
                Library.Corners,
                New("UICorner", {
                    CornerRadius = UDim.new(0, Library.CornerRadius),
                    Parent = TextBtn
                })
            )

            New("UIPadding", {
                PaddingLeft = UDim.new(0, 15),
                PaddingRight = UDim.new(0, 15),
                Parent = TextBtn,
            })

            local TextColor = Library.Scheme.FontColor
            if Variant == "Primary" then
                TextColor = Library.Scheme.BackgroundColor
            elseif Variant == "Destructive" then
                TextColor = Color3.new(1, 1, 1)
            end

            local BtnLabel = New("TextLabel", {
                BackgroundTransparency = 1,
                Size = UDim2.fromScale(1, 1),
                Text = ButtonInfo.Title or Idx,
                TextColor3 = TextColor,
                TextSize = 14,
                Parent = TextBtn,
            })

            local LabelX, _ = Library:GetTextBounds(BtnLabel.Text, Library.Scheme.Font, 14, 250)
            ButtonContainer.Size = UDim2.fromOffset(LabelX + 30, 26)
            TextBtn.Size = UDim2.fromOffset(LabelX + 30, 26)

            local ActiveColor = typeof(BtnColor) == "Color3" and BtnColor or Library.Scheme[BtnColor]
            local HoverColor = Variant == "Ghost" and Library.Scheme.MainColor or Library:GetBetterColor(ActiveColor, 10)

            TextBtn.MouseEnter:Connect(function()
                TweenService:Create(TextBtn, Library.TweenInfo, {
                    BackgroundColor3 = HoverColor
                }):Play()
            end)
            TextBtn.MouseLeave:Connect(function()
                TweenService:Create(TextBtn, Library.TweenInfo, {
                    BackgroundColor3 = ActiveColor
                }):Play()
            end)

            TextBtn.MouseButton1Click:Connect(function()
                if ButtonInfo.Callback then
                    ButtonInfo.Callback(Loading)
                end
            end)
        end

        Loading:UpdateLayout()
    end

    --// Destroy/Continue \\--
    function Loading:Destroy()
        if RotationTween then
            StopTween(RotationTween, true)
            RotationTween = nil
        end

        ScreenGui:Destroy()
        Loading.Destroyed = true
        Library.ActiveLoading = nil

        if Library.Toggle and Library.Toggled == false and Library.Unloaded ~= true then
            Library:Toggle(true)
        end
    end

    Loading.Continue = Loading.Destroy;

    if Library.Toggle and Library.Toggled and Library.Unloaded ~= true then
        Library:Toggle(false)
    end

    Loading:SetCurrentStep(Loading.CurrentStep)

    Library.ActiveLoading = Loading
    return Loading
end

local function OnPlayerChange()
    if Library.Unloaded then
        return
    end

    local PlayerList, ExcludedPlayerList = GetPlayers(), GetPlayers(true)
    for _, Dropdown in Options do
        if Dropdown.Type == "Dropdown" and Dropdown.SpecialType == "Player" then
            Dropdown:SetValues(Dropdown.ExcludeLocalPlayer and ExcludedPlayerList or PlayerList)
        end
    end
end

local function OnTeamChange()
    if Library.Unloaded then
        return
    end

    local TeamList = GetTeams()
    for _, Dropdown in Options do
        if Dropdown.Type == "Dropdown" and Dropdown.SpecialType == "Team" then
            Dropdown:SetValues(TeamList)
        end
    end
end

Library:GiveSignal(Players.PlayerAdded:Connect(OnPlayerChange))
Library:GiveSignal(Players.PlayerRemoving:Connect(OnPlayerChange))

Library:GiveSignal(Teams.ChildAdded:Connect(OnTeamChange))
Library:GiveSignal(Teams.ChildRemoved:Connect(OnTeamChange))

function Library:Unload()
    Library.Unloaded = true

    --// Disconnect connections
    for Index = #Library.Signals, 1, -1 do
        local Connection = table.remove(Library.Signals, Index)

        if Connection and Connection.Connected then
            Connection:Disconnect()
        end
    end

    --// Run Unload Callbacks
    for _ = 1, #Library.UnloadSignals do
        local Callback = table.remove(Library.UnloadSignals, 1)

        if Callback then
            Library:SafeCallback(Callback)
        end
    end

    --// Destroy elements
    for Index = #Library.Tabs, 1, -1 do
        local Tab = table.remove(Library.Tabs, Index)

        if Tab and Tab.Destroy then
            Library:SafeCallback(Tab.Destroy, Tab)
        end
    end

    for Index = #Tooltips, 1, -1 do
        local Tooltip = table.remove(Tooltips, Index)

        if Tooltip and Tooltip.Destroy then
            Library:SafeCallback(Tooltip.Destroy, Tooltip)
        end
    end

    if Library.ActiveLoading then
        Library.ActiveLoading:Destroy()
    end

    if Library.KeybindMenu then
        Library.KeybindMenu:Destroy()
    end

    if ScreenGui then
        ScreenGui:Destroy()
    end

    --// Clear tables
    table.clear(Library.Registry)

    table.clear(Options)
    table.clear(Toggles)
    table.clear(Buttons)
    table.clear(Labels)
    table.clear(Tooltips)

    table.clear(Library.Tabs)
    table.clear(Library.TabButtons)

    table.clear(Library.Scales)
    table.clear(Library.ScalesOffset)

    table.clear(Library.Corners)
    table.clear(Library.SpecificCorners)
    table.clear(Library.ContextMenus)

    table.clear(Library.Notifications)
    table.clear(Library.Dialogues)
    table.clear(Library.DraggableElements)
    table.clear(Library.KeybindToggles)
    table.clear(Library.DependencyBoxes)

    table.clear(TransparencyCache)
    table.clear(ActiveTabTweens)

    Library.Toggle = function(...) end
    Library.ScreenGui = nil
    Library.Floats = nil
    Library.Overlay = nil
    Library.WindowContainer = nil
    Library.KeybindFrame = nil
    Library.KeybindContainer = nil
    Library.KeybindMenu = nil

    getgenv().Library = nil
end

getgenv().Library = Library
return Library
]===], "=Ouroboros/Library.lua")
local ThemeManager = loadEmbeddedModule(
[===[local cloneref = (cloneref or clonereference or function(instance: any)
    return instance
end)
local clonefunction = (clonefunction or copyfunction or function(func) 
    return func 
end)

local HttpService: HttpService = cloneref(game:GetService("HttpService"))

--// Fix is_____ functions for shitsploits, those functions should never error, only return a boolean. (why is this still a problem in the big 2026)
local isfolder, isfile, listfiles = isfolder, isfile, listfiles
local isfolder_copy, isfile_copy, listfiles_copy = clonefunction(isfolder), clonefunction(isfile), clonefunction(listfiles)
local isfolder_success, isfolder_error = pcall(function() return isfolder_copy("test" .. tostring(math.random(1000000, 9999999))) end)

if isfolder_success == false or typeof(isfolder_error) ~= "boolean" then
    isfolder = function(folder)
        local success, data = pcall(isfolder_copy, folder)
        return (if success then data else false)
    end

    isfile = function(file)
        local success, data = pcall(isfile_copy, file)
        return (if success then data else false)
    end

    listfiles = function(folder)
        local success, data = pcall(listfiles_copy, folder)
        return (if success then data else {})
    end
end

--// WCAG21 constants (https://www.w3.org/TR/WCAG21/#dfn-relative-luminance)
local ContrastWarnThreshold = 4.5 --// Accessibility: minimum WCAG AA contrast ratio for normal text
local SrgbLinearThreshold = 0.03928 --// sRGB channel value below which the linear conversion is a simple divide
local SrgbLinearDivisor = 12.92 --// Divisor used for channel values below SrgbLinearThreshold
local SrgbGammaOffset = 0.055 --// Offset applied before the gamma expansion power curve
local SrgbGammaScale = 1.055 --// Scale applied before the gamma expansion power curve
local SrgbGammaExponent = 2.4 --// Exponent for the gamma expansion power curve
local LuminanceRedWeight,
      LuminanceGreenWeight,
      LuminanceBlueWeight = 0.2126, 0.7152, 0.0722 --// R, G, B channel weights in the relative luminance formula
local ContrastRatioOffset = 0.05 --// Offset added to both luminances when computing a contrast ratio

--// Theme Manager
local SchemeIndexes = { "FontColor", "MainColor", "AccentColor", "BackgroundColor", "OutlineColor" }

local ThemeManager = {
    Library = nil,

    Folder = "ObsidianLibSettings",

    AppliedToTab = false,
    DefaultThemeName = nil,

    --// Accessibility: contrast warning state
    ContrastLabel = nil,
    ContrastWasPoor = false,

    BuiltInThemes = {
        ["Default"] = {
            1,
            { FontColor = "f3f3ee", MainColor = "1e1e1e", AccentColor = "b7f34a", BackgroundColor = "151515", OutlineColor = "303030", BackgroundImage = "" },
        },
        ["Classic"] = {
            2,
            { FontColor = "ffffff", MainColor = "191919", AccentColor = "7d55ff", BackgroundColor = "0f0f0f", OutlineColor = "282828", BackgroundImage = "" },
        },
        ["BBot"] = {
            3,
            { FontColor = "ffffff", MainColor = "1e1e1e", AccentColor = "7e48a3", BackgroundColor = "232323", OutlineColor = "141414", BackgroundImage = "" },
        },
        ["Fatality"] = {
            4,
            { FontColor = "ffffff", MainColor = "1e1842", AccentColor = "c50754", BackgroundColor = "191335", OutlineColor = "3c355d", BackgroundImage = "" },
        },
        ["Jester"] = {
            5,
            { FontColor = "ffffff", MainColor = "242424", AccentColor = "db4467", BackgroundColor = "1c1c1c", OutlineColor = "373737", BackgroundImage = "" },
        },
        ["Mint"] = {
            6,
            { FontColor = "ffffff", MainColor = "242424", AccentColor = "3db488", BackgroundColor = "1c1c1c", OutlineColor = "373737", BackgroundImage = "" },
        },
        ["Tokyo Night"] = {
            7,
            { FontColor = "ffffff", MainColor = "191925", AccentColor = "6759b3", BackgroundColor = "16161f", OutlineColor = "323232", BackgroundImage = "" },
        },
        ["Ubuntu"] = {
            8,
            { FontColor = "ffffff", MainColor = "3e3e3e", AccentColor = "e2581e", BackgroundColor = "323232", OutlineColor = "191919", BackgroundImage = "" },
        },
        ["Quartz"] = {
            9,
            { FontColor = "ffffff", MainColor = "232330", AccentColor = "426e87", BackgroundColor = "1d1b26", OutlineColor = "27232f", BackgroundImage = "" },
        },
        ["Nord"] = {
            10,
            { FontColor = "eceff4", MainColor = "3b4252", AccentColor = "88c0d0", BackgroundColor = "2e3440", OutlineColor = "4c566a", BackgroundImage = "" },
        },
        ["Dracula"] = {
            11,
            { FontColor = "f8f8f2", MainColor = "44475a", AccentColor = "ff79c6", BackgroundColor = "282a36", OutlineColor = "6272a4", BackgroundImage = "" },
        },
        ["Monokai"] = {
            12,
            { FontColor = "f8f8f2", MainColor = "272822", AccentColor = "f92672", BackgroundColor = "1e1f1c", OutlineColor = "49483e", BackgroundImage = "" },
        },
        ["Gruvbox"] = {
            13,
            { FontColor = "ebdbb2", MainColor = "3c3836", AccentColor = "fb4934", BackgroundColor = "282828", OutlineColor = "504945", BackgroundImage = "" },
        },
        ["Solarized"] = {
            14,
            { FontColor = "839496", MainColor = "073642", AccentColor = "cb4b16", BackgroundColor = "002b36", OutlineColor = "586e75", BackgroundImage = "" },
        },
        ["Catppuccin"] = {
            15,
            { FontColor = "d9e0ee", MainColor = "302d41", AccentColor = "f5c2e7", BackgroundColor = "1e1e2e", OutlineColor = "575268", BackgroundImage = "" },
        },
        ["One Dark"] = {
            16,
            { FontColor = "abb2bf", MainColor = "282c34", AccentColor = "c678dd", BackgroundColor = "21252b", OutlineColor = "5c6370", BackgroundImage = "" },
        },
        ["Cyberpunk"] = {
            17,
            { FontColor = "f9f9f9", MainColor = "262335", AccentColor = "00ff9f", BackgroundColor = "1a1a2e", OutlineColor = "413c5e", BackgroundImage = "" },
        },
        ["Oceanic Next"] = {
            18,
            { FontColor = "d8dee9", MainColor = "1b2b34", AccentColor = "6699cc", BackgroundColor = "16232a", OutlineColor = "343d46", BackgroundImage = "" },
        },
        ["Material"] = {
            19,
            { FontColor = "eeffff", MainColor = "212121", AccentColor = "82aaff", BackgroundColor = "151515", OutlineColor = "424242", BackgroundImage = "" },
        }
    }
}

function ThemeManager:SetLibrary(Library)
    ThemeManager.Library = Library
end

--// Helpers \\--
local function Trim(Text: string)
    return Text:match("^%s*(.-)%s*$")
end

local function IsStringEmpty(String: string): boolean
    return if typeof(String) == "string" then Trim(String) == "" else true
end

local function IsValidFolderPath(Name: string): boolean
    return typeof(Name) == "string" and (
        Trim(Name) ~= "" and 
        not Name:match("^%s*$") and 
        not Name:find('[<>:"|%?%*%z]')
    )
end

--// Contrast helpers \\--
local function LinearizeChannel(Channel: number): number
    if Channel <= SrgbLinearThreshold then
        return Channel / SrgbLinearDivisor
    end

    return ((Channel + SrgbGammaOffset) / SrgbGammaScale) ^ SrgbGammaExponent
end

local function GetRelativeLuminance(Color: Color3): number
    local R = LinearizeChannel(Color.R)
    local G = LinearizeChannel(Color.G)
    local B = LinearizeChannel(Color.B)

    return LuminanceRedWeight * R + LuminanceGreenWeight * G + LuminanceBlueWeight * B
end

local function GetContrastRatio(ColorA: Color3, ColorB: Color3): number
    local LuminanceA = GetRelativeLuminance(ColorA)
    local LuminanceB = GetRelativeLuminance(ColorB)

    local Lighter = math.max(LuminanceA, LuminanceB)
    local Darker = math.min(LuminanceA, LuminanceB)

    return (Lighter + ContrastRatioOffset) / (Darker + ContrastRatioOffset)
end

local function IsValidThemeData(Data: any): boolean
    if typeof(Data) ~= "table" then
        return false
    end

    --// Require the color scheme to be present; font/background image are optional and fall back to current values
    for _, SchemeIndex in SchemeIndexes do
        if typeof(Data[SchemeIndex]) ~= "string" then
            return false
        end
    end

    return true
end

--// Folder helper \\--
local function SplitPath(Path: string): {string}
	local Result = {}
	local Current = ""

	for Part in string.gmatch(Path, "[^/]+") do
		Current = if Current == "" then Part else (Current .. "/" .. Part)
		table.insert(Result, Current)
	end

	return Result
end

local function GetFolderPath(): false | string
    if IsStringEmpty(ThemeManager.Folder) then
        return false
    end

    return string.format("%s/themes", ThemeManager.Folder)
end

local GetCurrentThemesPath = GetFolderPath

--// Files helper \\--
local function GetThemePath(ThemeName: string): false | string
    local CurrentThemesPath = GetCurrentThemesPath()
    return if CurrentThemesPath == false then false else string.format("%s/%s.json", CurrentThemesPath, ThemeName)
end

local function DoesThemeExist(ThemeName: string, IncludeBuiltIn: boolean): boolean
    if ThemeManager.BuiltInThemes[ThemeName] then
        return true
    end

    local ThemePath = GetThemePath(ThemeName)
    return if ThemePath == false then false else isfile(ThemePath)
end

local function GetDefaultThemePath(): false | string
    local CurrentThemesPath = GetCurrentThemesPath()
    return if CurrentThemesPath == false then false else string.format("%s/default.txt", CurrentThemesPath)
end

--// Folders \\--
function ThemeManager:GetPaths(): {string}
    local FolderPath = GetFolderPath()
    return if FolderPath == false then {} else SplitPath(FolderPath)
end

function ThemeManager:BuildFolderTree(SkipWhenCreated: boolean?)
    local Paths = ThemeManager:GetPaths()
    if #Paths == 0 then
        return false
    end

    if SkipWhenCreated == true then
        if isfolder(Paths[1]) then
            return true
        end
    end

    for _, Path in Paths do
        if isfolder(Path) then continue end
        
        makefolder(Path)
    end

    return true
end

function ThemeManager:CheckFolderTree()
    return ThemeManager:BuildFolderTree(true)
end

function ThemeManager:SetFolder(Folder: string)
    assert(IsValidFolderPath(Folder), "Invalid path provided")

    ThemeManager.Folder = Folder
    ThemeManager:BuildFolderTree()
end

--// Theme Management \\--
function ThemeManager:ReloadCustomThemes()
    local SettingsPath = GetCurrentThemesPath()
    if SettingsPath == false then
        return {}
    end

    pcall(makefolder, SettingsPath)
    local SuccessList, Files = pcall(listfiles, SettingsPath)
    if not (SuccessList and typeof(Files) == "table") then
        ThemeManager.Library:Notify(string.format("Failed to load theme list: %s", tostring(Files)))
        return {}
    end

    local FileNames = {}
    for _, FilePath in Files do
        local RawFileName = FilePath:match("(.+)%..+$")
        if not RawFileName then continue end

        local Position = RawFileName:gsub("\\", "/"):find("/[^/]*$")
        local FileName = Position and RawFileName:sub(Position + 1) or RawFileName
        if not FileName or FileName == "default" then continue end

        table.insert(FileNames, FileName)
    end

    return FileNames
end

function ThemeManager:GetCustomTheme(ThemeName: string): any
    if IsStringEmpty(ThemeName) then
        return nil
    end

    local ThemePath = GetThemePath(ThemeName)
    if ThemePath == false or not isfile(ThemePath) then
        return nil
    end

    local SuccessRead, Content = pcall(readfile, ThemePath)
    if not SuccessRead then
        return nil
    end

    local SuccessDecode, Decoded = pcall(HttpService.JSONDecode, HttpService, Content)
    if not SuccessDecode or typeof(Decoded) ~= "table" then
        return nil
    end

    return Decoded
end

local function BuildCurrentThemeData(): {[string]: any}
    local Library = ThemeManager.Library
    local ThemeData = {
        FontFace = Library.Options.FontFace.Value,
        BackgroundImage = Library.Options.BackgroundImage.Value
    }

    for _, SchemeIndex in SchemeIndexes do
        ThemeData[SchemeIndex] = Library.Options[SchemeIndex].Value:ToHex()
    end

    return ThemeData
end

function ThemeManager:SaveCustomTheme(ThemeName: string): any
    if IsStringEmpty(ThemeName) then
        return false, "Invalid theme name provided"
    end

    if string.lower(ThemeName) == "default" then
        return false, "Invalid theme name provided"
    end

    local ThemePath = GetThemePath(ThemeName)
    if ThemePath == false then
        return false, "Invalid theme name provided"
    end

    ThemeManager:CheckFolderTree()

    --// Custom theme files use the same flat shape as an exported theme JSON, so reuse the encoder
    local EncodedData, SuccessEncode, EncodeErrorMessage = ThemeManager:SaveJSON()
    if not SuccessEncode then
        return false, EncodeErrorMessage
    end

    local SuccessWrite, ErrorMessage = pcall(writefile, ThemePath, EncodedData)
    if not SuccessWrite then
        return false, "Failed to write theme file: " .. tostring(ErrorMessage)
    end

    return true
end

function ThemeManager:Delete(ThemeName: string): (boolean | string?)
    if IsStringEmpty(ThemeName) then
        return false, "No theme is selected"
    end

    local ThemePath = GetThemePath(ThemeName)
    if ThemePath == false or not isfile(ThemePath) then
        return false, "Theme file does not exist"
    end

    local SuccessDelete, ErrorMessage = pcall(delfile, ThemePath)
    if not SuccessDelete then
        return false, "Failed to delete theme file: " .. tostring(ErrorMessage)
    end

    if ThemeName == ThemeManager.DefaultThemeName then
        ThemeManager:DeleteDefaultTheme()
    end

    return true
end

--// Default Theme \\--
function ThemeManager:GetDefaultTheme(): (string, boolean, string?)
    ThemeManager:CheckFolderTree()

    local DefaultThemePath = GetDefaultThemePath()
    if DefaultThemePath == false then
        return "none", false, "Invalid path provided"
    end

    if not isfile(DefaultThemePath) then
        return "none", false, "Default theme is not set"
    end

    local SuccessRead, DefaultThemeName = pcall(readfile, DefaultThemePath)
    if not (SuccessRead and typeof(DefaultThemeName) == "string") then
        return "none", false, DefaultThemeName
    end

    local ConfigExists = DoesThemeExist(DefaultThemeName, true)
    if not ConfigExists then
        return "none", false, "Theme file not found"
    end

    ThemeManager.DefaultThemeName = DefaultThemeName
    return DefaultThemeName, true
end

function ThemeManager:SetDefaultTheme(Theme: any)
    assert(ThemeManager.Library, "Library is not set, call ThemeManager:SetLibrary(Library) first.")
    assert(not ThemeManager.AppliedToTab, "Cannot set default theme after applying ThemeManager to a tab!")

    local Library = ThemeManager.Library
    local DefaultThemeData = ThemeManager.BuiltInThemes["Default"][2]

    local LibraryScheme = {}
    local FinalTheme = {}

    for _, SchemeIndex in SchemeIndexes do
        local IndexData = Theme[SchemeIndex]
        local IndexType = typeof(IndexData)
        
        if IndexType == "Color3" then
            LibraryScheme[SchemeIndex] = IndexData
            FinalTheme[SchemeIndex] = string.format("#%s", IndexData:ToHex())

        elseif IndexType == "string" then
            LibraryScheme[SchemeIndex] = Color3.fromHex(IndexData)
            FinalTheme[SchemeIndex] = if IndexData:sub(1, 1) == "#" then IndexData else string.format("#%s", IndexData)
        
        else
            local Value = DefaultThemeData[SchemeIndex]
            LibraryScheme[SchemeIndex] = Color3.fromHex(Value)
            FinalTheme[SchemeIndex] = Value
        end
    end

    --// Font
    local FontFace = Theme["FontFace"]
    local FontFaceType = typeof(FontFace)
    
    if FontFaceType == "EnumItem" then
        LibraryScheme.Font = Font.fromEnum(FontFace)
        FinalTheme.FontFace = FontFace.Name

    elseif FontFaceType == "string" then
        LibraryScheme.Font = Font.fromEnum(Enum.Font[FontFace] :: Enum.Font)
        FinalTheme.FontFace = FontFace
    
    else
        LibraryScheme.Font = Font.fromEnum(Enum.Font.Code)
        FinalTheme.FontFace = "Code"
    end

    --// Default Scheme Colors
    for _, DefaultSchemeColor in { "RedColor", "DestructiveColor", "DarkColor", "WhiteColor" } do
        LibraryScheme[DefaultSchemeColor] = Library.Scheme[DefaultSchemeColor]
    end

    --// Apply
    Library.Scheme = LibraryScheme
    ThemeManager.BuiltInThemes["Default"] = { 1, FinalTheme }

    Library:UpdateColorsUsingRegistry()
end

function ThemeManager:SaveDefault(ThemeName: string): (boolean, string?)
    if IsStringEmpty(ThemeName) then
        return false, "No theme is selected"
    end

    ThemeManager:CheckFolderTree()

    local DefaultThemePath = GetDefaultThemePath()
    if DefaultThemePath == false then
        return false, "Invalid path provided"
    end

    if not DoesThemeExist(ThemeName, true) then
        return false, "Theme does not exist"
    end

    local SuccessWrite, ErrorMessage = pcall(writefile, DefaultThemePath, ThemeName)
    if not SuccessWrite then
        return false, ErrorMessage
    end

    ThemeManager.DefaultThemeName = ThemeName
    return true
end

function ThemeManager:LoadDefault()
    local ThemeName, Success, FetchErrorMessage = ThemeManager:GetDefaultTheme()
    if not Success or FetchErrorMessage then
        if FetchErrorMessage ~= "Default theme is not set" then
            ThemeManager.Library:Notify(string.format("Failed to apply default theme: %s", FetchErrorMessage))
        end

        return
    end

    if not ThemeManager:GetCustomTheme(ThemeName) then
        ThemeManager.Library.Options.ThemeManager_ThemeList:SetValue(ThemeName)
        return
    end

    local SuccessLoad, LoadErrorMessage = ThemeManager:ApplyTheme(ThemeName)
    if not SuccessLoad then
        ThemeManager.Library:Notify(string.format("Failed to apply default theme: %s", LoadErrorMessage))
        return
    end

    ThemeManager.Library:Notify(string.format("Successfully applied default theme %q", ThemeName))
end

function ThemeManager:DeleteDefaultTheme(): (boolean, string?)
    ThemeManager:CheckFolderTree()

    local DefaultThemePath = GetDefaultThemePath()
    if DefaultThemePath == false then
        return false, "Invalid path provided"
    end

    if not isfile(DefaultThemePath) then
        return false, "Default theme is not set"
    end

    local SuccessDelete, ErrorMessage = pcall(delfile, DefaultThemePath)
    if not SuccessDelete then
        return false, ErrorMessage
    end

    ThemeManager.DefaultThemeName = nil
    return true
end

--// Accessibility: contrast checking \\--
function ThemeManager:GetContrastReport(): { Ratio: number, PairName: string, Passes: boolean }
    local Library = ThemeManager.Library
    local FontColorOption = Library.Options.FontColor
    local BackgroundColorOption = Library.Options.BackgroundColor
    local MainColorOption = Library.Options.MainColor

    if not (FontColorOption and BackgroundColorOption and MainColorOption) then
        return { Ratio = math.huge, PairName = "", Passes = true }
    end

    local FontColor = FontColorOption.Value
    local Surfaces = {
        { Name = "font color vs. background color", Color = BackgroundColorOption.Value },
        { Name = "font color vs. main color", Color = MainColorOption.Value },
    }

    local WorstRatio, WorstName = math.huge, ""
    for _, Surface in Surfaces do
        local Ratio = GetContrastRatio(FontColor, Surface.Color)
        if Ratio < WorstRatio then
            WorstRatio = Ratio
            WorstName = Surface.Name
        end
    end

    return {
        Ratio = WorstRatio,
        PairName = WorstName,
        Passes = WorstRatio >= ContrastWarnThreshold,
    }
end

function ThemeManager:UpdateContrastWarning()
    local ContrastLabel = ThemeManager.ContrastLabel
    if not ContrastLabel or ContrastLabel.Destroyed then
        return
    end

    local Library = ThemeManager.Library
    local Report = ThemeManager:GetContrastReport()
    local TextLabel = ContrastLabel.TextLabel

    if not Library.Registry[TextLabel] then
        Library:AddToRegistry(TextLabel, {})
    end

    if Report.Passes then
        ContrastLabel:SetText(string.format("Contrast check: good (%.1f:1)", Report.Ratio))

        TextLabel.TextColor3 = Library.Scheme.FontColor
        Library.Registry[TextLabel].TextColor3 = "FontColor"
    else
        ContrastLabel:SetText(string.format(
            "Low contrast (%.1f:1) between %s. Aim for at least %.1f:1 so text stays readable.",
            Report.Ratio, Report.PairName, ContrastWarnThreshold
        ))

        TextLabel.TextColor3 = Library.Scheme.RedColor
        Library.Registry[TextLabel].TextColor3 = "RedColor"

        if not ThemeManager.ContrastWasPoor then
            Library:Notify({
                Title = "Low contrast theme",
                Description = string.format(
                    "Your %s has a contrast ratio of %.1f:1, below the recommended %.1f:1. Text may be hard to read.",
                    Report.PairName, Report.Ratio, ContrastWarnThreshold
                ),
                Time = 10,
            })
        end
    end

    ThemeManager.ContrastWasPoor = not Report.Passes
end

--// Apply Theme \\--
function ThemeManager:ThemeUpdate()
    local Library = ThemeManager.Library

    for _, SchemeIndex in SchemeIndexes do
        local Element = Library.Options[SchemeIndex]
        if not Element then continue end

        Library.Scheme[SchemeIndex] = Element.Value
    end

    Library:UpdateColorsUsingRegistry()
    ThemeManager:UpdateContrastWarning()
end

--// Applies a flat theme data table (either a parsed theme file or an imported JSON blob) to the library.
--// Split out of ApplyTheme so imported JSON can go through the same path as themes loaded from disk.
function ThemeManager:ApplyThemeData(ThemeData: any): (boolean, string?)
    if typeof(ThemeData) ~= "table" then
        return false, "Invalid theme data"
    end

    local Library = ThemeManager.Library

    for Index, Value in ThemeData do
        if Index == "VideoLink" then
            continue
        end

        local Element = Library.Options[Index]
        local FinalValue = Value

        if Index == "FontFace" then
            if typeof(Value) ~= "string" or not Enum.Font[Value] then continue end
            ThemeManager.Library:SetFont(Enum.Font[Value])

        elseif Index == "BackgroundImage" then
            if typeof(Value) ~= "string" then continue end
            ThemeManager.Library:SetBackgroundImage(Value)

        elseif table.find(SchemeIndexes, Index) then
            local SuccessColor, Color = pcall(Color3.fromHex, Value)
            if not SuccessColor then continue end

            FinalValue = Color
            Library.Scheme[Index] = FinalValue

        else
            continue --// Unrecognized field, ignore it
        end

        if Element then
            Element:SetValue(FinalValue)
        end
    end

    ThemeManager:ThemeUpdate()
    return true
end

function ThemeManager:ApplyTheme(ThemeName: string)
    if IsStringEmpty(ThemeName) then
        return false, "No theme is selected"
    end

    local CustomThemeData = ThemeManager:GetCustomTheme(ThemeName)
    local Data = CustomThemeData or ThemeManager.BuiltInThemes[ThemeName]
    
    if not Data then
        return false, "Theme not found"
    end
    
    local ThemeData = CustomThemeData or Data[2]
    return ThemeManager:ApplyThemeData(ThemeData)
end

--// JSON Import & Export \\--
function ThemeManager:SaveJSON(): (string, boolean, string?)
    local ThemeData = BuildCurrentThemeData()

    local SuccessEncode, EncodedData = pcall(HttpService.JSONEncode, HttpService, ThemeData)
    if not SuccessEncode then
        return "", false, "Failed to encode data"
    end

    return EncodedData, true
end

function ThemeManager:LoadJSON(Content: string): (boolean, string?)
    if IsStringEmpty(Content) then
        return false, "No JSON provided"
    end

    local SuccessDecode, Decoded = pcall(HttpService.JSONDecode, HttpService, Content)
    if not SuccessDecode or not IsValidThemeData(Decoded) then
        return false, "Failed to decode theme data"
    end

    return ThemeManager:ApplyThemeData(Decoded)
end

--// GUI \\--
local function ShowDialog(
    Condition: () -> boolean,

    Index: string, 
    Title: string, 
    Description: string,

    DestructiveText: string,
    DestructiveAction: () -> nil
)
    if Condition() == false then
        return DestructiveAction()
    end

    return ThemeManager.Library.Window:AddDialog(Index, {
        Title = Title,
        Description = Description,
        AutoDismiss = false,

        FooterButtons = {
            Cancel = {
                Title = "Cancel",
                Variant = "Ghost",
                Order = 1,
                Callback = function(Dialog)
                    Dialog:Dismiss()
                end
            },

            DestructiveAction = {
                Title = DestructiveText,
                Variant = "Destructive",
                Order = 2,
                Callback = function(Dialog)
                    Dialog:Dismiss()
                    DestructiveAction()
                end
            }
        }
    })
end

function ThemeManager:CreateThemeManager(Themesbox: any)
    assert(ThemeManager.Library, "Library is not set, call ThemeManager:SetLibrary(Library) first.")

    local BuiltInThemesNames = {}
    for Name, _ThemeData in ThemeManager.BuiltInThemes do
        table.insert(BuiltInThemesNames, Name)
    end

    local CustomThemeList, CustomThemeName, ThemeList, FontFace, BackgroundImage, DefaultThemeLabel, ThemeJSONInput
    local function RefreshList()
        CustomThemeList:SetValues(ThemeManager:ReloadCustomThemes())
        CustomThemeList:SetValue(nil)

        ThemeList:SetValues(BuiltInThemesNames)
    end

    local function RefreshDefaultThemeLabel()
        local DefaultThemeName, _Success, _ErrorMessage = ThemeManager:GetDefaultTheme()

        DefaultThemeLabel:SetText(string.format("Current default theme: %s", DefaultThemeName))
        if CustomThemeList then RefreshList() end
    end

    table.sort(BuiltInThemesNames, function(IndexA, IndexB)
        return ThemeManager.BuiltInThemes[IndexA][1] < ThemeManager.BuiltInThemes[IndexB][1]
    end)

    local function CreateColorOption(Text, SchemeIndex)
        Themesbox:AddLabel(Text):AddColorPicker(SchemeIndex, {
            Default = ThemeManager.Library.Scheme[SchemeIndex]
        })

        return ThemeManager.Library.Options[SchemeIndex]
    end

    local BackgroundColor = CreateColorOption("Background color", "BackgroundColor")
    local MainColor = CreateColorOption("Main color", "MainColor")
    local AccentColor = CreateColorOption("Accent color", "AccentColor")
    local OutlineColor = CreateColorOption("Outline color", "OutlineColor")
    local FontColor = CreateColorOption("Font color", "FontColor")

    --// Accessibility: live contrast readout for the colors above
    ThemeManager.ContrastLabel = Themesbox:AddLabel({
        Text = "Contrast check: n/a",
        DoesWrap = true,
    })

    Themesbox:AddDropdown("FontFace", {
        Text = "Font Face",
        Default = "Code",
        
        Values = { "BuilderSans", "Code", "Fantasy", "Gotham", "Jura", "Roboto", "RobotoMono", "SourceSans" },
        AllowNull = false,
        Multi = false
    })
    
    Themesbox:AddInput("BackgroundImage", { 
        Text = "Background Image",

        Default = "",
        Finished = true,
        ClearTextOnFocus = false,
        ClearTextOnBlur = false
    })

    Themesbox:AddDivider()

    Themesbox:AddDropdown("ThemeManager_ThemeList", { 
        Text = "Theme list", 

        Values = BuiltInThemesNames,
        AllowNull = true,
        Multi = false,

        FormatDisplayValue = function(Value: any)
            if Value ~= "Default" and Value == ThemeManager.DefaultThemeName then
                return string.format("%s (default)", Value)
            end

            return Value
        end,
        FormatListValue = function(Value: any)
            if Value ~= "Default" and Value == ThemeManager.DefaultThemeName then
                return string.format("%s (default)", Value)
            end

            return Value
        end
    })

    Themesbox:AddButton("Set as default", function()
        local ThemeName = ThemeList.Value
        ThemeManager:SaveDefault(ThemeName)

        ThemeManager.Library:Notify(string.format("Successfully set default theme to %q", ThemeName))
        RefreshDefaultThemeLabel()
    end)

    Themesbox:AddDivider()

    CustomThemeName = Themesbox:AddInput("ThemeManager_CustomThemeName", { 
        Text = "Custom theme name" 
    })

    local function SaveThemeWithContrastCheck(Name: string, SuccessMessage: string, OnSaved: (() -> nil)?)
        local function DoSave()
            local Success, ErrorMessage = ThemeManager:SaveCustomTheme(Name)
            if not Success then
                ThemeManager.Library:Notify(string.format("Failed to save theme %q: %s", Name, ErrorMessage))
                return
            end

            ThemeManager.Library:Notify(string.format(SuccessMessage, Name))
            if OnSaved then OnSaved() end
        end

        local Report = ThemeManager:GetContrastReport()
        if Report.Passes then
            DoSave()
            return
        end

        ShowDialog(
            function(): boolean
                return true
            end,

            "ThemeManager_LowContrastSave",
            "Low contrast theme",
            string.format(
                "This theme has a contrast ratio of %.1f:1 between %s, below the recommended %.1f:1. Text may be hard to read. Save anyway?",
                Report.Ratio, Report.PairName, ContrastWarnThreshold
            ),

            "Save Anyway",
            DoSave
        )
    end

    Themesbox:AddButton("Create theme", function()
        local Name = CustomThemeName.Value
        if IsStringEmpty(Name) then
            ThemeManager.Library:Notify("Theme name cannot be empty.")
            return
        end

        if string.lower(Name) == "default" then
            ThemeManager.Library:Notify("Invalid theme name provided.")
            return
        end

        ShowDialog(
            function(): boolean
                return ThemeManager:GetCustomTheme(Name) ~= nil
            end,

            "ThemeManager_CreateTheme",
            "Theme already exists",
            string.format("A custom theme named %q already exists. Overwriting it will replace it with your current colors.", Name),

            "Overwrite",
            function()
                SaveThemeWithContrastCheck(Name, "Successfully created theme %q", RefreshList)
            end
        )
    end)

    Themesbox:AddDivider()

    CustomThemeList = Themesbox:AddDropdown("ThemeManager_CustomThemeList", { 
        Text = "Custom themes",

        Values = ThemeManager:ReloadCustomThemes(), 
        AllowNull = true,
        Multi = false,

        FormatDisplayValue = function(Value: any)
            if Value == ThemeManager.DefaultThemeName then
                return string.format("%s (default)", Value)
            end

            return Value
        end,
        FormatListValue = function(Value: any)
            if Value == ThemeManager.DefaultThemeName then
                return string.format("%s (default)", Value)
            end

            return Value
        end
    })

    Themesbox:AddButton("Load theme", function()
        local Name = CustomThemeList.Value
        if IsStringEmpty(Name) then
            ThemeManager.Library:Notify("Please select a theme first.")
            return
        end

        ThemeManager:ApplyTheme(Name)
        ThemeManager.Library:Notify(string.format("Successfully loaded theme %q", Name))
    end)

    Themesbox:AddButton("Overwrite theme", function()
        local Name = CustomThemeList.Value
        if IsStringEmpty(Name) then
            ThemeManager.Library:Notify("Please select a theme first.")
            return
        end

        ShowDialog(
            function(): boolean
                return true
            end,

            "ThemeManager_OverwriteTheme",
            "Overwrite theme",
            string.format("Are you sure you want to overwrite %q with your current colors? This cannot be undone.", Name),

            "Overwrite",
            function()
                SaveThemeWithContrastCheck(Name, "Successfully overwrote theme %q")
            end
        )
    end)

    Themesbox:AddButton("Delete theme", function()
        local Name = CustomThemeList.Value
        if IsStringEmpty(Name) then
            ThemeManager.Library:Notify("Please select a theme first.")
            return
        end

        ShowDialog(
            function(): boolean
                return true
            end,

            "ThemeManager_DeleteTheme",
            "Delete theme",
            string.format("Are you sure you want to delete %q? This cannot be undone.", Name),
            
            "Delete",
            function()
                local Success, ErrorMessage = ThemeManager:Delete(Name)
                if not Success then
                    ThemeManager.Library:Notify(string.format("Failed to delete theme: %s", ErrorMessage))
                    return
                end

                ThemeManager.Library:Notify(string.format("Successfully deleted theme %q", Name))
                RefreshDefaultThemeLabel()
            end
        )
    end)

    Themesbox:AddButton("Refresh list", RefreshList)

    Themesbox:AddButton("Set as default", function()
        local Name = CustomThemeList.Value
        if IsStringEmpty(Name) then
            ThemeManager.Library:Notify("Please select a theme first.")
            return
        end

        ThemeManager:SaveDefault(Name)
        ThemeManager.Library:Notify(string.format("Successfully set default theme to %q", Name))
        RefreshDefaultThemeLabel()
    end)

    Themesbox:AddButton("Reset default", function()
        ShowDialog(
            function(): boolean
                return true
            end,

            "ThemeManager_ResetDefault",
            "Reset default theme",
            "Are you sure you want to clear the default theme? The library will revert to its built-in default on next load.",
            
            "Reset",
            function()
                local Success, ErrorMessage = ThemeManager:DeleteDefaultTheme()
                if not Success then
                    ThemeManager.Library:Notify(string.format("Failed to reset default theme: %s", ErrorMessage))
                    return
                end

                ThemeManager.Library:Notify("Successfully reset default theme.")
                RefreshDefaultThemeLabel()
            end
        )
    end)

    DefaultThemeLabel = Themesbox:AddLabel("Current default theme: ...", true);

    Themesbox:AddDivider()

    --// Import & Export
    Themesbox:AddInput("ThemeManager_ThemeJSON", {
        Text = "Theme JSON"
    })

    Themesbox:AddButton("Import theme", function()
        local ThemeJSON = ThemeJSONInput.Value
        if IsStringEmpty(ThemeJSON) then
            ThemeManager.Library:Notify("Theme JSON cannot be empty")
            return
        end

        ShowDialog(
            function(): boolean
                return true
            end,

            "ThemeManager_ImportTheme",
            "Import theme",
            "Are you sure you want to import this theme? Your current colors will be overwritten.",

            "Import",
            function()
                local Success, ErrorMessage = ThemeManager:LoadJSON(ThemeJSON)
                if not Success then
                    ThemeManager.Library:Notify(string.format("Failed to import theme: %s", ErrorMessage))
                    return
                end

                ThemeManager.Library:Notify("Successfully imported theme")
            end
        )
    end)

    Themesbox:AddButton("Export current theme", function()
        local EncodedData, Success, ErrorMessage = ThemeManager:SaveJSON()
        if not Success then
            ThemeManager.Library:Notify(ErrorMessage)
            return
        end

        ThemeJSONInput:SetValue(EncodedData)
        if setclipboard then
            setclipboard(EncodedData)
            ThemeManager.Library:Notify("Copied theme to your clipboard")
        end
    end)

    --// Set Variables
    CustomThemeList, CustomThemeName, ThemeList, FontFace, BackgroundImage, ThemeJSONInput =
        ThemeManager.Library.Options.ThemeManager_CustomThemeList,
        ThemeManager.Library.Options.ThemeManager_CustomThemeName,
        ThemeManager.Library.Options.ThemeManager_ThemeList,
        ThemeManager.Library.Options.FontFace,
        ThemeManager.Library.Options.BackgroundImage,
        ThemeManager.Library.Options.ThemeManager_ThemeJSON;

    --// Handlers
    ThemeList:OnChanged(function()
        ThemeManager:ApplyTheme(ThemeList.Value)
    end)

    local function UpdateTheme()
        ThemeManager:ThemeUpdate()
    end

    BackgroundColor:OnChanged(UpdateTheme)
    MainColor:OnChanged(UpdateTheme)
    AccentColor:OnChanged(UpdateTheme)
    OutlineColor:OnChanged(UpdateTheme)
    FontColor:OnChanged(UpdateTheme)
    FontFace:OnChanged(function(Value) ThemeManager.Library:SetFont(Enum.Font[Value]) end)
    BackgroundImage:OnChanged(function(Value) ThemeManager.Library:SetBackgroundImage(Value) end)

    --// Load default
    ThemeManager:LoadDefault()
    ThemeManager:UpdateContrastWarning()
    ThemeManager.AppliedToTab = true
    RefreshDefaultThemeLabel()

    return Themesbox
end

function ThemeManager:CreateGroupBox(Tab: any, IconName: string)
    return Tab:AddGroupbox({
        Side = "Left",
        Name = "Themes",
        IconName = IconName or "paintbrush",
    })
end

function ThemeManager:ApplyToTab(Tab: any, IconName: string)
    local Groupbox = ThemeManager:CreateGroupBox(Tab, IconName)
    return ThemeManager:CreateThemeManager(Groupbox)
end

function ThemeManager:ApplyToGroupbox(Groupbox: any)
    return ThemeManager:CreateThemeManager(Groupbox)
end

getgenv().ObsidianThemeManager = ThemeManager
return ThemeManager
]===], "=Ouroboros/ThemeManager.lua")
local SaveManager = loadEmbeddedModule(
[===[local cloneref = (cloneref or clonereference or function(instance: any)
    return instance
end)
local clonefunction = (clonefunction or copyfunction or function(func) 
    return func 
end)

local HttpService: HttpService = cloneref(game:GetService("HttpService"))

--// Fix is_____ functions for shitsploits, those functions should never error, only return a boolean. (why is this still a problem in the big 2026)
local isfolder, isfile, listfiles = isfolder, isfile, listfiles
local isfolder_copy, isfile_copy, listfiles_copy = clonefunction(isfolder), clonefunction(isfile), clonefunction(listfiles)
local isfolder_success, isfolder_error = pcall(function() return isfolder_copy("test" .. tostring(math.random(1000000, 9999999))) end)

if isfolder_success == false or typeof(isfolder_error) ~= "boolean" then
    isfolder = function(folder)
        local success, data = pcall(isfolder_copy, folder)
        return (if success then data else false)
    end

    isfile = function(file)
        local success, data = pcall(isfile_copy, file)
        return (if success then data else false)
    end

    listfiles = function(folder)
        local success, data = pcall(listfiles_copy, folder)
        return (if success then data else {})
    end
end

--// Save Manager
local SaveManager = {
    Library = nil,

    Folder = "ObsidianLibSettings",
    SubFolder = "",

    Ignore = {},
    LoadingOrder = {},
    UseLoadingOrder = false,

    AutoloadConfig = nil
}

function SaveManager:SetLibrary(Library)
    SaveManager.Library = Library
end

--// Element Parser \\--
local SpecialValueParser = {
    UDim2 = {
        Encode = function(Value: UDim2)
            return {
                X = { Scale = Value.X.Scale, Offset = Value.X.Offset },
                Y = { Scale = Value.Y.Scale, Offset = Value.Y.Offset }
            }
        end,

        Decode = function(Data: any)
            local DataType = typeof(Data)
            if DataType == "table" then
                return UDim2.new(Data.X.Scale, Data.X.Offset, Data.Y.Scale, Data.Y.Offset)
            elseif DataType == "UDim2" then
                return Data
            end

            return nil
        end
    }
}

local ElementParser = {}; do
    local function CreateParser(
        ElementType: string, 
        LibaryIndex: string, 
        
        Save: (string, any, ...any) -> any, 
        Load: (any?, any) -> any,
        CustomElementFetcher: boolean?
    )
        ElementParser[ElementType] = { 
            Save = function(Index: string, Element: any, ...)
                local Data = Save(Index, Element, ...)
                Data.type = ElementType
                Data.idx = Index

                return Data
            end, 

            Load = function(Index: string?, Data: any)
                if CustomElementFetcher == true then
                    return Load(nil, Data)
                end

                local Elements = SaveManager.Library and SaveManager.Library[LibaryIndex]
                local Element = Elements and Elements[Index]
                return Load(Element, Data)
            end
        }
    end

    CreateParser(
        "Toggle", "Toggles",
        function(Index: string, Toggle: any)
            return { value = Toggle.Value }
        end,
        function(Element: any?, Data: any)
            if not Element then return end
            if Element.Value == Data.value then
                Element:RunChanged()
                return
            end
            
            Element:SetValue(Data.value)
        end
    )

    CreateParser(
        "Slider", "Options",
        function(Index: string, Slider: any)
            return { value = tostring(Slider.Value) }
        end,
        function(Element: any?, Data: any)
            if not Element then return end
            if Element.Value == Data.value then
                Element:RunChanged()
                return
            end

            Element:SetValue(Data.value)
        end
    )

    CreateParser(
        "Dropdown", "Options",
        function(Index: string, Dropdown: any)
            return { value = Dropdown.Value, multi = Dropdown.Multi }
        end,
        function(Element: any?, Data: any)
            if not Element then return end
            if Element.Value == Data.value then
                Element:RunChanged()
                return
            end
            
            Element:SetValue(Data.value)
        end
    )

    CreateParser(
        "ColorPicker", "Options",
        function(Index: string, ColorPicker: any)
            return { value = ColorPicker.Value:ToHex(), transparency = ColorPicker.Transparency }
        end,
        function(Element: any?, Data: any)
            if not Element then return end
            
            Element:SetValueRGB(Color3.fromHex(Data.value), Data.transparency)
        end
    )

    CreateParser(
        "KeyPicker", "Options",
        function(Index: string, KeyPicker: any)
            return { mode = KeyPicker.Mode, key = KeyPicker.Value, modifiers = KeyPicker.Modifiers, toggled = KeyPicker.Toggled }
        end,
        function(Element: any?, Data: any)
            if not Element then return end
            
            Element:SetValue({ Data.key, Data.mode, Data.modifiers })
            if Data.mode == "Toggle" and Data.toggled ~= nil then
                Element.Toggled = Data.toggled
                Element:Update()
            end
        end
    )

    CreateParser(
        "Input", "Options",
        function(Index: string, Input: any)
            return { text = Input.Value }
        end,
        function(Element: any?, Data: any)
            if not Element then return end
            if typeof(Data.text) ~= "string" then return end

            if Element.Value == Data.text then
                Element:RunChanged()
                return
            end

            Element:SetValue(Data.text)
        end
    )

    CreateParser(
        "Groupbox", "Tabs",
        function(Index: string, Groupbox: any, TabIndex: string)
            return {
                tabIdx = TabIndex,
                collapsed = Groupbox.Collapsed,
                poppedOut = Groupbox.PoppedOut == true,
                popoutPos = if Groupbox.PoppedOut and Groupbox.PopOutFloat then SpecialValueParser.UDim2.Encode(Groupbox.PopOutFloat.Position) else nil,
            }
        end,
        function(_, Data: any)
            local TabIndex, Index = Data.tabIdx, Data.idx
            if typeof(TabIndex) ~= "string" or typeof(Index) ~= "string" then return end

            local Tabs = SaveManager.Library and SaveManager.Library.Tabs
            local Tab = Tabs and Tabs[TabIndex]
            if not Tab then return end

            local Groupbox = Tab.Groupboxes[Index]
            if not Groupbox then return end

            --// Collapsed
            if Groupbox.Collapsed ~= Data.collapsed then
                Groupbox:SetCollapsed(Data.collapsed == true)
            end

            --// Popout
            if Groupbox.PopOutEnabled then
                if Data.poppedOut == true then
                    local Position = SpecialValueParser.UDim2.Decode(Data.popoutPos)
                    Groupbox:SetPoppedOut(true, Position)
                elseif Groupbox.PoppedOut then
                    Groupbox:SetPoppedOut(false)
                end
            end
        end,
        true
    )

    CreateParser(
        "Tabbox", "Tabs",
        function(Index: string, Tabbox: any, TabIndex: string)
            return {
                tabIdx = TabIndex,
                poppedOut = Tabbox.PoppedOut == true,
                popoutPos = if Tabbox.PoppedOut and Tabbox.PopOutFloat then SpecialValueParser.UDim2.Encode(Tabbox.PopOutFloat.Position) else nil,
            }
        end,
        function(_, Data: any)
            local TabIndex, Index = Data.tabIdx, Data.idx
            if typeof(TabIndex) ~= "string" or typeof(Index) ~= "string" then return end

            local Tabs = SaveManager.Library and SaveManager.Library.Tabs
            local Tab = Tabs and Tabs[TabIndex]
            if not Tab then return end

            local Tabbox = Tab.Tabboxes and Tab.Tabboxes[Index]
            if not Tabbox then return end

            --// Popout
            if Tabbox.PopOutEnabled then
                if Data.poppedOut == true then
                    local Position = SpecialValueParser.UDim2.Decode(Data.popoutPos)
                    Tabbox:SetPoppedOut(true, Position)
                elseif Tabbox.PoppedOut then
                    Tabbox:SetPoppedOut(false)
                end
            end
        end,
        true
    )
end

--// Helpers \\--
local function Trim(Text: string)
    return Text:match("^%s*(.-)%s*$")
end

local function IsStringEmpty(String: string): boolean
    return if typeof(String) == "string" then Trim(String) == "" else true
end

local function IsValidFolderPath(Name: string): boolean
    return typeof(Name) == "string" and (
        Trim(Name) ~= "" and 
        not Name:match("^%s*$") and 
        not Name:find('[<>:"|%?%*%z]')
    )
end

--// Folder helper \\--
local function SplitPath(Path: string): {string}
    local Result = {}
    local Current = ""

    for Part in string.gmatch(Path, "[^/]+") do
        Current = if Current == "" then Part else (Current .. "/" .. Part)
        table.insert(Result, Current)
    end

    return Result
end

local function GetFolderPath(): false | string
    if IsStringEmpty(SaveManager.Folder) then
        return false
    end

    return string.format("%s/settings", SaveManager.Folder)
end

local function GetSubFolderPath(): false | string
    if IsStringEmpty(SaveManager.Folder) or IsStringEmpty(SaveManager.SubFolder) then
        return false
    end

    return string.format("%s/settings/%s", SaveManager.Folder, SaveManager.SubFolder)
end

local function GetCurrentSettingsPath(): false | string
    local SubFolderPath = GetSubFolderPath()
    return if SubFolderPath == false then GetFolderPath() else SubFolderPath
end

--// Files helper \\--
local function GetConfigPath(ConfigName: string): false | string
    local CurrentSettingsPath = GetCurrentSettingsPath()
    return if CurrentSettingsPath == false then false else string.format("%s/%s.json", CurrentSettingsPath, ConfigName)
end

local function DoesConfigExist(ConfigName: string): boolean
    local ConfigPath = GetConfigPath(ConfigName)
    return if ConfigPath == false then false else isfile(ConfigPath)
end

local function GetAutoloadPath(): false | string
    local CurrentSettingsPath = GetCurrentSettingsPath()
    return if CurrentSettingsPath == false then false else string.format("%s/autoload.txt", CurrentSettingsPath)
end

--// Indexes \\--
function SaveManager:SetLoadingOrder(Enabled: boolean, Order: {string}?)
    SaveManager.UseLoadingOrder = Enabled == true
    SaveManager.LoadingOrder = typeof(Order) == "table" and Order or SaveManager.LoadingOrder
end

function SaveManager:SetIgnoreIndexes(Indexes: {string}?)
    assert(typeof(Indexes) == "table", "Expected table, got " .. typeof(Indexes))

    for _, Index in Indexes do
        SaveManager.Ignore[Index] = true
    end
end

function SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({
        "BackgroundColor", "MainColor", "AccentColor", "OutlineColor", "FontColor", "FontFace", "BackgroundImage",
        "ThemeManager_ThemeList", "ThemeManager_CustomThemeList", "ThemeManager_CustomThemeName", "ThemeManager_ThemeJSON"
    })
end

--// Folders \\--
function SaveManager:GetPaths(): {string}
    local SubFolderPath = GetSubFolderPath()
    if SubFolderPath == false then
        local FolderPath = GetFolderPath()
        return if FolderPath == false then {} else SplitPath(FolderPath)
    end

    return SplitPath(SubFolderPath)
end

function SaveManager:BuildFolderTree(SkipWhenCreated: boolean?)
    local Paths = SaveManager:GetPaths()
    if #Paths == 0 then
        return false
    end

    if SkipWhenCreated == true then
        if isfolder(Paths[1]) then
            return true
        end
    end

    for _, Path in Paths do
        if isfolder(Path) then continue end
        
        makefolder(Path)
    end

    return true
end

function SaveManager:CheckFolderTree()
    return SaveManager:BuildFolderTree(true)
end

function SaveManager:CheckSubFolder(CreateFolder: boolean)
    local SubFolderPath = GetSubFolderPath()
    if SubFolderPath == false then
        return false
    end

    local FolderExists = isfolder(SubFolderPath)
    if not CreateFolder then
        return FolderExists
    end

    makefolder(SubFolderPath)
    return true
end

function SaveManager:SetFolder(Folder: string)
    assert(IsValidFolderPath(Folder), "Invalid path provided")

    SaveManager.Folder = Folder
    SaveManager:BuildFolderTree()
end

function SaveManager:SetSubFolder(SubFolder: string)
    assert(IsValidFolderPath(SubFolder), "Invalid path provided")

    SaveManager.SubFolder = SubFolder
    SaveManager:BuildFolderTree()
end

--// Config Management \\--
function SaveManager:RefreshConfigList()
    local SettingsPath = GetCurrentSettingsPath()
    if SettingsPath == false then
        return {}
    end

    pcall(makefolder, SettingsPath)
    local SuccessList, Files = pcall(listfiles, SettingsPath)
    if not (SuccessList and typeof(Files) == "table") then
        SaveManager.Library:Notify(string.format("Failed to load config list: %s", tostring(Files)))
        return {}
    end

    local FileNames = {}
    for _, FilePath in Files do
        local RawFileName = FilePath:match("(.+)%..+$")
        if not RawFileName then continue end

        local Position = RawFileName:gsub("\\", "/"):find("/[^/]*$")
        local FileName = Position and RawFileName:sub(Position + 1) or RawFileName
        if not FileName or FileName == "autoload" then continue end

        table.insert(FileNames, FileName)
    end

    return FileNames
end

function SaveManager:SaveJSON(ConfigName)
    local Library = SaveManager.Library
    local IgnoreIndexes = SaveManager.Ignore
    local CurrentData = {
        timestamp = os.date("%d.%m.%Y %H:%M:%S"),
        name = ConfigName or "",

        objects = {},
        keybindMenu = nil,
        window = nil,
    }

    local MainFrame = Library.Window and Library.Window.MainFrame
    if MainFrame then
        CurrentData.window = {
            position = SpecialValueParser.UDim2.Encode(MainFrame.Position),
            size = SpecialValueParser.UDim2.Encode(MainFrame.Size),
        }
    end

    if Library.KeybindFrame then
        local Hidden = {}
        for Index, Option in Library.Options do
            if Option.Type == "KeyPicker" and Option.NoUI ~= true and Option.MenuVisible == false then
                Hidden[Index] = true
            end
        end

        local KeybindMenu = Library.KeybindMenu
        local SettingsPosition = nil
        if KeybindMenu and KeybindMenu.SettingsFrame then
            SettingsPosition = SpecialValueParser.UDim2.Encode(KeybindMenu.SettingsFrame.Position)
        end

        CurrentData.keybindMenu = {
            visible = Library.KeybindFrame.Visible,
            position = SpecialValueParser.UDim2.Encode(Library.KeybindFrame.Position),
            collapsed = if KeybindMenu then KeybindMenu.Collapsed == true else false,
            settingsOpen = false,
            settingsPosition = SettingsPosition,
            hidden = Hidden,
        }
    end

    --// Toggles
    for Index, Toggle in Library.Toggles do
        if not Toggle.Type then continue end
        if IgnoreIndexes[Index] then continue end

        local Parser = ElementParser[Toggle.Type]
        if not Parser then continue end

        table.insert(CurrentData.objects, Parser.Save(Index, Toggle))
    end

    --// Options
    for Index, Option in Library.Options do
        if not Option.Type then continue end
        if IgnoreIndexes[Index] then continue end

        local Parser = ElementParser[Option.Type]
        if not Parser then continue end

        table.insert(CurrentData.objects, Parser.Save(Index, Option))
    end

    --// Groupboxes, Tabboxes
    for TabIndex, Tab in Library.Tabs do
        if Tab.Groupboxes then
            for Index, Groupbox in Tab.Groupboxes do
                if typeof(Index) ~= "string" or IgnoreIndexes[Index] then continue end

                local Parser = ElementParser.Groupbox
                if not Parser then continue end

                table.insert(CurrentData.objects, Parser.Save(Index, Groupbox, TabIndex))
            end
        end

        if Tab.Tabboxes then
            for Index, Tabbox in Tab.Tabboxes do
                if typeof(Index) ~= "string" or IgnoreIndexes[Index] then continue end

                local Parser = ElementParser.Tabbox
                if not Parser then continue end

                table.insert(CurrentData.objects, Parser.Save(Index, Tabbox, TabIndex))
            end
        end
    end

    local SuccessEncode, EncodedData = pcall(HttpService.JSONEncode, HttpService, CurrentData)
    if not SuccessEncode then
        return "", false, "Failed to encode data"
    end

    return EncodedData, true
end

function SaveManager:Save(ConfigName: string): (boolean, string?)
    if IsStringEmpty(ConfigName) then
        return false, "Invalid config name provided"
    end

    if string.lower(ConfigName) == "autoload" then
        return false, "Invalid config name provided"
    end

    local ConfigPath = GetConfigPath(ConfigName)
    if ConfigPath == false then
        return false, "Invalid config name provided"
    end

    SaveManager:CheckFolderTree()

    local EncodedData, SuccessEncode, EncodeErrorMessage = SaveManager:SaveJSON(ConfigName)
    if not SuccessEncode then
        return false, EncodeErrorMessage
    end

    local SuccessWrite, ErrorMessage = pcall(writefile, ConfigPath, EncodedData)
    if not SuccessWrite then
        return false, "Failed to write config file: " .. tostring(ErrorMessage)
    end

    return true
end

function SaveManager:LoadJSON(Content: string)
    if IsStringEmpty(Content) then
        return false, "No JSON provided"
    end

    local SuccessDecode, Decoded = pcall(HttpService.JSONDecode, HttpService, Content)
    if not SuccessDecode or typeof(Decoded) ~= "table" or typeof(Decoded.objects) ~= "table" then
        return false, "Failed to decode config data"
    end

    local Library = SaveManager.Library
    local LoadingOrder = SaveManager.LoadingOrder
    local IgnoreIndexes = SaveManager.Ignore

    if SaveManager.UseLoadingOrder == true and typeof(LoadingOrder) == "table" then
        table.sort(Decoded.objects, function(a, b)
            local aIndex = table.find(LoadingOrder, a.type) or math.huge
            local bIndex = table.find(LoadingOrder, b.type) or math.huge
            return aIndex < bIndex
        end)
    end

    --// Window
    local MainFrame = Library.Window and Library.Window.MainFrame
    if MainFrame and typeof(Decoded.window) == "table" then
        local Position = SpecialValueParser.UDim2.Decode(Decoded.window.position)
        local Size = SpecialValueParser.UDim2.Decode(Decoded.window.size)

        if Position then
            MainFrame.Position = Position
        end
        if Size then
            MainFrame.Size = Size
            for _, Tab in Library.Tabs do
                if Tab.Resize then
                    Tab:Resize(true)
                end
            end
        end
    end

    --// Keybind Menu
    if Library.KeybindFrame and typeof(Decoded.keybindMenu) == "table" then
        local KeybindFrameData = Decoded.keybindMenu
        local IsVisible = KeybindFrameData.visible == true
        local Position = SpecialValueParser.UDim2.Decode(KeybindFrameData.position)

        Library.KeybindFrame.Visible = IsVisible
        Library.KeybindFrame.Position = Position or Library.KeybindFrame.Position

        local KeybindMenuToggle = Library.Options and Library.Options.KeybindMenuOpen
        if KeybindMenuToggle then
            KeybindMenuToggle:SetValue(IsVisible)
        end

        local KeybindMenu = Library.KeybindMenu
        if KeybindMenu then
            if KeybindMenu.SetCollapsed then
                KeybindMenu:SetCollapsed(KeybindFrameData.collapsed == true)
            end

            if typeof(KeybindFrameData.hidden) == "table" then
                for Index, Option in Library.Options do
                    if Option.Type ~= "KeyPicker" or Option.NoUI == true or not Option.SetMenuVisibility then
                        continue
                    end

                    Option:SetMenuVisibility(KeybindFrameData.hidden[Index] ~= true)
                end
            end

            local SettingsPosition = SpecialValueParser.UDim2.Decode(KeybindFrameData.settingsPosition)
            if SettingsPosition and KeybindMenu.SettingsFrame then
                KeybindMenu.SettingsFrame.Position = SettingsPosition
            end
            KeybindMenu:SetSettingsOpen(false)
        end
    end

    --// Elements
    for _, Option in Decoded.objects do
        if not Option.type then continue end
        if IgnoreIndexes[Option.idx] then continue end

        local Parser = ElementParser[Option.type]
        if not Parser then continue end

        task.defer(Parser.Load, Option.idx, Option)
    end

    return true
end

function SaveManager:Load(ConfigName: string): (boolean, string?)
    if IsStringEmpty(ConfigName) then
        return false, "No config is selected"
    end

    local ConfigPath = GetConfigPath(ConfigName)
    if ConfigPath == false or not isfile(ConfigPath) then
        return false, "Config file does not exist"
    end

    local SuccessRead, Content = pcall(readfile, ConfigPath)
    if not SuccessRead then
        return false, "Failed to read config file"
    end

    return SaveManager:LoadJSON(Content)
end

function SaveManager:Delete(ConfigName: string): (boolean | string?)
    if IsStringEmpty(ConfigName) then
        return false, "No config is selected"
    end

    local ConfigPath = GetConfigPath(ConfigName)
    if ConfigPath == false or not isfile(ConfigPath) then
        return false, "Config file does not exist"
    end

    local SuccessDelete, ErrorMessage = pcall(delfile, ConfigPath)
    if not SuccessDelete then
        return false, "Failed to delete config file: " .. tostring(ErrorMessage)
    end

    if ConfigName == SaveManager.AutoloadConfig then
        SaveManager:DeleteAutoLoadConfig()
    end

    return true
end

--// Auto Load Config \\--
function SaveManager:GetAutoloadConfig(): (string, boolean, string?)
    SaveManager:CheckFolderTree()

    local AutoloadPath = GetAutoloadPath()
    if AutoloadPath == false then
        return "none", false, "Invalid path provided"
    end

    if not isfile(AutoloadPath) then
        return "none", false, "Autoload config is not set"
    end

    local SuccessRead, AutoloadConfigName = pcall(readfile, AutoloadPath)
    if not (SuccessRead and typeof(AutoloadConfigName) == "string") then
        return "none", false, AutoloadConfigName
    end

    local ConfigExists = DoesConfigExist(AutoloadConfigName)
    if not ConfigExists then
        return "none", false, "Config file not found"
    end

    SaveManager.AutoloadConfig = AutoloadConfigName
    return AutoloadConfigName, true
end

function SaveManager:SaveAutoloadConfig(ConfigName: string): (boolean, string?)
    if IsStringEmpty(ConfigName) then
        return false, "No config is selected"
    end

    SaveManager:CheckFolderTree()

    local AutoloadPath = GetAutoloadPath()
    if AutoloadPath == false then
        return false, "Invalid path provided"
    end

    if not DoesConfigExist(ConfigName) then
        return false, "Config does not exist"
    end

    local SuccessWrite, ErrorMessage = pcall(writefile, AutoloadPath, ConfigName)
    if not SuccessWrite then
        return false, ErrorMessage
    end

    SaveManager.AutoloadConfig = ConfigName
    return true
end

function SaveManager:LoadAutoloadConfig()
    local ConfigName, Success, FetchErrorMessage = SaveManager:GetAutoloadConfig()
    if not Success or FetchErrorMessage then
        if FetchErrorMessage ~= "Autoload config is not set" then
            SaveManager.Library:Notify(string.format("Failed to load autoload config: %s", FetchErrorMessage))
        end

        return
    end

    local SuccessLoad, LoadErrorMessage = SaveManager:Load(ConfigName)
    if not SuccessLoad then
        SaveManager.Library:Notify(string.format("Failed to load autoload config: %s", LoadErrorMessage))
        return
    end

    SaveManager.Library:Notify(string.format("Successfully loaded autoload config %q", ConfigName))
end

function SaveManager:DeleteAutoLoadConfig(): (boolean, string?)
    SaveManager:CheckFolderTree()

    local AutoloadPath = GetAutoloadPath()
    if AutoloadPath == false then
        return false, "Invalid path provided"
    end

    if not isfile(AutoloadPath) then
        return false, "Autoload config is not set"
    end

    local SuccessDelete, ErrorMessage = pcall(delfile, AutoloadPath)
    if not SuccessDelete then
        return false, ErrorMessage
    end

    SaveManager.AutoloadConfig = nil
    return true
end

--// GUI \\--
local function ShowDialog(
    Condition: () -> boolean,

    Index: string, 
    Title: string, 
    Description: string,

    DestructiveText: string,
    DestructiveAction: () -> nil
)
    if Condition() == false then
        return DestructiveAction()
    end

    return SaveManager.Library.Window:AddDialog(Index, {
        Title = Title,
        Description = Description,
        AutoDismiss = false,

        FooterButtons = {
            Cancel = {
                Title = "Cancel",
                Variant = "Ghost",
                Order = 1,
                Callback = function(Dialog)
                    Dialog:Dismiss()
                end
            },

            DestructiveAction = {
                Title = DestructiveText,
                Variant = "Destructive",
                Order = 2,
                Callback = function(Dialog)
                    Dialog:Dismiss()
                    DestructiveAction()
                end
            }
        }
    })
end

function SaveManager:BuildConfigSection(Tab: any, IconName: string)
    assert(SaveManager.Library, "Library is not set, call SaveManager:SetLibrary(Library) first.")
    local ConfigurationBox = Tab:AddGroupbox({
        Side = "Right",
        Name = "Configuration",
        IconName = IconName or "folder-cog",
    })

    local ConfigNameInput, ConfigList, ConfigJSONInput, AutoloadConfigLabel
    local function RefreshList()
        ConfigList:SetValues(SaveManager:RefreshConfigList())
        ConfigList:SetValue(nil)
    end

    local function RefreshAutoloadConfigLabel()
        local AutoloadConfigName, _Success, _ErrorMessage = SaveManager:GetAutoloadConfig()

        AutoloadConfigLabel:SetText(string.format("Current autoload config: %s", AutoloadConfigName))
        if ConfigList then RefreshList() end
    end

    --// Create
    ConfigurationBox:AddInput("SaveManager_ConfigName", {
        Text = "Config name"
    })

    ConfigurationBox:AddButton("Create config", function()
        local ConfigName = ConfigNameInput.Value
        if IsStringEmpty(ConfigName) then
            SaveManager.Library:Notify("Configuration name cannot be empty.")
            return
        end

        if string.lower(ConfigName) == "autoload" then
            SaveManager.Library:Notify("Invalid config name provided.")
            return
        end
        
        ShowDialog(
            function(): boolean
                return DoesConfigExist(ConfigName)
            end,

            "SaveManager_CreateConfig",
            "Config already exists",
            string.format("A config named %q already exists. Overwriting will replace it with your current settings.", ConfigName),

            "Overwrite",
            function()
                local Success, ErrorMessage = SaveManager:Save(ConfigName)
                if not Success then
                    SaveManager.Library:Notify(string.format("Failed to create config %q: %s", ConfigName, ErrorMessage))
                    return
                end

                SaveManager.Library:Notify(string.format("Successfully created config %q", ConfigName))
                RefreshList()
            end
        )
    end)

    ConfigurationBox:AddDivider()

    --// Manage
    --// Inline config list (always visible, click a row to select) \\--
    do
        local Library = SaveManager.Library
        local RowHeight, ListHeight = 21, 140

        local function Themed(Instance, Properties)
            local Registry = {}
            for Property, SchemeKey in Properties do
                Instance[Property] = Library.Scheme[SchemeKey]
                Registry[Property] = SchemeKey
            end
            Library:AddToRegistry(Instance, Registry)
            return Instance
        end

        local Holder = Instance.new("Frame")
        Holder.BackgroundTransparency = 1
        Holder.Size = UDim2.new(1, 0, 0, 18 + ListHeight)
        Holder.Parent = ConfigurationBox.Container

        local Title = Themed(Instance.new("TextLabel"), { TextColor3 = "FontColor", FontFace = "Font" })
        Title.BackgroundTransparency = 1
        Title.Size = UDim2.new(1, 0, 0, 14)
        Title.Text = "Configs"
        Title.TextSize = 14
        Title.TextXAlignment = Enum.TextXAlignment.Left
        Title.Parent = Holder

        local List = Themed(Instance.new("ScrollingFrame"), {
            BackgroundColor3 = "BackgroundColor",
            ScrollBarImageColor3 = "OutlineColor",
        })
        List.AnchorPoint = Vector2.new(0, 1)
        List.Position = UDim2.fromScale(0, 1)
        List.Size = UDim2.new(1, 0, 0, ListHeight)
        List.BorderSizePixel = 0
        List.ScrollBarThickness = 2
        List.AutomaticCanvasSize = Enum.AutomaticSize.Y
        List.CanvasSize = UDim2.new()
        List.Parent = Holder
        Themed(Instance.new("UIStroke"), { Color = "OutlineColor" }).Parent = List
        local Corner = Instance.new("UICorner")
        Corner.CornerRadius = UDim.new(0, (Library.CornerRadius or 4) / 2)
        Corner.Parent = List
        Instance.new("UIListLayout").Parent = List

        local Rows = {}
        local Hovered = nil
        local Object = { Value = nil, Values = {} }

        local function Format(Value)
            if Value == SaveManager.AutoloadConfig then
                return string.format("%s (autoload)", Value)
            end
            return Value
        end

        local function UpdateRows()
            for Value, Row in Rows do
                local Selected = Value == Object.Value
                local IsHovered = Value == Hovered
                Row.BackgroundColor3 = Library.Scheme.MainColor
                Row.BackgroundTransparency = Selected and 0 or IsHovered and 0.5 or 1
                Row.TextColor3 = Selected and Library.Scheme.AccentColor or Library.Scheme.FontColor
                Row.TextTransparency = (Selected or IsHovered) and 0 or 0.4
                Row.Text = "  " .. Format(Value)
            end
        end

        function Object:SetValue(Value)
            Object.Value = Value
            UpdateRows()
        end

        function Object:SetValues(Values)
            for _, Row in Rows do
                Library:RemoveFromRegistry(Row)
                Row:Destroy()
            end
            table.clear(Rows)
            Hovered = nil
            Object.Values = Values

            for _, Value in Values do
                local Row = Themed(Instance.new("TextButton"), { FontFace = "Font" })
                Row.AutoButtonColor = false
                Row.BorderSizePixel = 0
                Row.Size = UDim2.new(1, 0, 0, RowHeight)
                Row.TextSize = 14
                Row.TextXAlignment = Enum.TextXAlignment.Left
                Row.Parent = List
                Row.MouseEnter:Connect(function()
                    Hovered = Value
                    UpdateRows()
                end)
                Row.MouseLeave:Connect(function()
                    if Hovered == Value then Hovered = nil end
                    UpdateRows()
                end)
                Row.MouseButton1Click:Connect(function()
                    Object:SetValue(if Object.Value == Value then nil else Value)
                end)
                Rows[Value] = Row
            end
            if not Rows[Object.Value] then Object.Value = nil end
            UpdateRows()
        end

        Object:SetValues(SaveManager:RefreshConfigList())
        ConfigList = Object
        if ConfigurationBox.Resize then ConfigurationBox:Resize() end
    end

    ConfigurationBox:AddButton({
        Text = "Load config",
        DoubleClick = false,

        Func = function()
            local ConfigName = ConfigList.Value
            if IsStringEmpty(ConfigName) then
                SaveManager.Library:Notify("Please select a config first.")
                return
            end

            ShowDialog(
                function(): boolean
                    return true --// Always show
                end,

                "SaveManager_LoadConfig",
                "Load config",
                string.format("Are you sure you want to load %q? Your current settings will be overwritten.", ConfigName),

                "Load",
                function()
                    local Success, ErrorMessage = SaveManager:Load(ConfigName)
                    if not Success then
                        SaveManager.Library:Notify(string.format("Failed to load config %q: %s", ConfigName, ErrorMessage))
                        return
                    end

                    SaveManager.Library:Notify(string.format("Successfully loaded config %q", ConfigName))
                end
            )
        end
    })
    
    ConfigurationBox:AddButton({
        Text = "Overwrite config",
        DoubleClick = false,

        Func = function()
            local ConfigName = ConfigList.Value
            if IsStringEmpty(ConfigName) then
                SaveManager.Library:Notify("Please select a config first.")
                return
            end

            ShowDialog(
                function(): boolean
                    return true --// Always show
                end,

                "SaveManager_OverwriteConfig",
                "Overwrite config",
                string.format("Are you sure you want to overwrite %q with your current settings? This cannot be undone.", ConfigName),

                "Overwrite",
                function()
                    local Success, ErrorMessage = SaveManager:Save(ConfigName)
                    if not Success then
                        SaveManager.Library:Notify(string.format("Failed to overwrite config %q: %s", ConfigName, ErrorMessage))
                        return
                    end

                    SaveManager.Library:Notify(string.format("Successfully overwrote config %q", ConfigName))
                end
            )
        end
    })

    ConfigurationBox:AddButton({
        Text = "Delete config",
        DoubleClick = false,

        Func = function()
            local ConfigName = ConfigList.Value
            if IsStringEmpty(ConfigName) then
                SaveManager.Library:Notify("Please select a config first.")
                return
            end

            ShowDialog(
                function(): boolean
                    return true --// Always show
                end,

                "SaveManager_DeleteConfig",
                "Delete config",
                string.format("Are you sure you want to delete %q? This cannot be undone.", ConfigName),
                
                "Delete",
                function()
                    local Success, ErrorMessage = SaveManager:Delete(ConfigName)
                    if not Success then
                        SaveManager.Library:Notify(string.format("Failed to delete config %q: %s", ConfigName, ErrorMessage))
                        return
                    end

                    SaveManager.Library:Notify(string.format("Successfully deleted config %q", ConfigName))
                    RefreshAutoloadConfigLabel()
                end
            )
        end
    })

    ConfigurationBox:AddButton("Refresh list", RefreshList)

    --// Autoload Config
    ConfigurationBox:AddButton({
        Text = "Set as autoload",
        DoubleClick = false,

        Func = function()
            local ConfigName = ConfigList.Value
            if IsStringEmpty(ConfigName) then
                SaveManager.Library:Notify("Please select a config first.")
                return
            end

            local Success, ErrorMessage = SaveManager:SaveAutoloadConfig(ConfigName)
            if not Success then
                SaveManager.Library:Notify(string.format("Failed to set autoload config %q: %s", ConfigName, ErrorMessage))
                return
            end

            SaveManager.Library:Notify(string.format("Successfully set autoload config to %q", ConfigName))
            RefreshAutoloadConfigLabel()
        end
    })

    ConfigurationBox:AddButton({
        Text = "Reset autoload",
        DoubleClick = false,

        Func = function()
            ShowDialog(
                function(): boolean
                    return true --// Always show
                end,

                "SaveManager_ResetAutoload",
                "Reset autoload config",
                "Are you sure you want to clear the autoload config? No config will be loaded automatically on next launch.",
                
                "Reset",
                function()
                    local Success, ErrorMessage = SaveManager:DeleteAutoLoadConfig()
                    if not Success then
                        SaveManager.Library:Notify(string.format("Failed to reset autoload config: %s", ErrorMessage))
                        return
                    end

                    SaveManager.Library:Notify("Successfully reset autoload config.")
                    RefreshAutoloadConfigLabel()
                end
            )
        end
    })

    AutoloadConfigLabel = ConfigurationBox:AddLabel("Current autoload config: ...", true);

    ConfigurationBox:AddDivider()

    --// Import & Export
    ConfigurationBox:AddInput("SaveManager_JSON", {
        Text = "Config JSON"
    })

    ConfigurationBox:AddButton("Import config", function()
        local ConfigJSON = ConfigJSONInput.Value
        if IsStringEmpty(ConfigJSON) then
            SaveManager.Library:Notify("Configuration JSON cannot be empty")
            return
        end

        ShowDialog(
            function(): boolean
                return true --// Always show
            end,

            "SaveManager_ImportConfig",
            "Import config",
            "Are you sure you want to import this configuration? Your current settings will be overwritten.",

            "Import",
            function()
                local Success, ErrorMessage = SaveManager:LoadJSON(ConfigJSON)
                if not Success then
                    SaveManager.Library:Notify(string.format("Failed to import config: %s", ErrorMessage))
                    return
                end

                SaveManager.Library:Notify("Successfully imported config")
            end
        )
    end)

    ConfigurationBox:AddButton("Export current config", function()
        local EncodedData, Success, ErrorMessage = SaveManager:SaveJSON()
        if not Success  then
            SaveManager.Library:Notify(ErrorMessage)
            return
        end

        ConfigJSONInput:SetValue(EncodedData)
        if setclipboard then
            setclipboard(EncodedData)
            SaveManager.Library:Notify("Copied config to your clipboard")
        end
    end)

    --// Set variables
    ConfigNameInput, ConfigJSONInput =
        SaveManager.Library.Options.SaveManager_ConfigName,
        SaveManager.Library.Options.SaveManager_JSON;

    --// Refresh
    RefreshAutoloadConfigLabel()
    SaveManager:SetIgnoreIndexes({ "SaveManager_ConfigList", "SaveManager_ConfigName", "SaveManager_JSON" })

    return ConfigurationBox
end

SaveManager:BuildFolderTree()
return SaveManager
]===], "=Ouroboros/SaveManager.lua")
local Options = Library.Options
local Toggles = Library.Toggles

Library:OnUnload(stop)

local Window = Library:CreateWindow({
    Title = "Ouroboros",
    Subtitle = GAME_NAME,
    Footer = GAME_NAME .. " | " .. SCRIPT_VERSION,
    Icon = 116467237831011,
    NotifySide = "Right",
    ToggleKeybind = Enum.KeyCode.RightControl,
    Size = UDim2.fromOffset(860, 600),
})

local Main = Window:AddTab({ Name = "Main", Icon = "gamepad-2", Tooltip = "Main" })
local Player = Window:AddTab({ Name = "Player", Icon = "user", Tooltip = "Player" })
local Settings = Window:AddTab({ Name = "Settings", Icon = "settings", Tooltip = "Settings" })
Window:AddDiscordTab({ Invite = DISCORD_INVITE, Tooltip = "Discord" })

local function toSet(value)
    local out = {}
    if type(value) == "table" then
        for key, on in pairs(value) do
            if on == true then
                out[key] = true
            end
        end
    end
    return out
end

local function featureToggle(box, idx, text)
    box:AddToggle(idx, {
        Text = text,
        Default = false,
        Callback = function(value)
            setFeature(idx, value)
        end,
    })
end

local function setupMainTab()
    local FarmSub = Main:AddSubTab("Farm")
    local RefineSub = Main:AddSubTab("Refine")

    local Farm = FarmSub:AddLeftGroupbox("Autofarm", "swords")
    featureToggle(Farm, "AutoFarm", "Autofarm")
    Farm:AddDropdown("FarmMobs", {
        Text = "Mob Selector",
        Values = mobNames(),
        Multi = true,
        Searchable = true,
        Default = {},
        AllowNull = true,
        Callback = function(value)
            local set = {}
            for label in pairs(toSet(value)) do
                set[labelToName(label)] = true
            end
            Flags.FarmMobs = set
            local order = {}
            for _, name in ipairs(Flags.FarmOrder) do
                if set[name] then
                    table.insert(order, name)
                end
            end
            local added = {}
            for name in pairs(set) do
                if not table.find(order, name) then
                    table.insert(added, name)
                end
            end
            table.sort(added, function(a, b)
                local oa = MobInfo[a] and MobInfo[a].order or 999
                local ob = MobInfo[b] and MobInfo[b].order or 999
                if oa ~= ob then
                    return oa < ob
                end
                return a < b
            end)
            for _, name in ipairs(added) do
                table.insert(order, name)
            end
            Flags.FarmOrder = order
            Game.travelIndex = 0
            Game.target = nil
        end,
    })
    Farm:AddButton({
        Text = "Refresh Mobs",
        Func = function()
            Options.FarmMobs:SetValues(mobNames())
        end,
    })
    Farm:AddLabel("Empty selection farms any mob", true)
    Farm:AddDropdown("FarmPriority", {
        Text = "Priority",
        Values = { "Selection Order", "Nearest", "Highest Level", "Lowest Level", "Lowest HP" },
        Multi = false,
        Default = "Selection Order",
        Callback = function(value)
            Flags.FarmPriority = value or "Selection Order"
        end,
    })
    Farm:AddDropdown("FarmPosition", {
        Text = "Position",
        Values = { "Front", "Behind", "Above", "Below", "Orbit" },
        Multi = false,
        Default = "Front",
        Callback = function(value)
            Flags.FarmPosition = value or "Front"
        end,
    })
    Farm:AddSlider("FarmDistance", {
        Text = "Distance",
        Default = 8,
        Min = 2,
        Max = 30,
        Rounding = 0,
        Callback = function(value)
            Flags.FarmDistance = tonumber(value) or Flags.FarmDistance
        end,
    })

    local Leveling = FarmSub:AddLeftGroupbox("Level 1 - 99", "trending-up")
    Leveling:AddToggle("Leveling", {
        Text = "Level 1 - 99",
        Default = false,
        Callback = function(value)
            setFeature("Leveling", value)
            if value and not Toggles.AutoFarm.Value then
                Toggles.AutoFarm:SetValue(true)
            end
        end,
    })
    local LevelStatusLabel = Leveling:AddLabel("Status: Idle", true)
    Leveling:AddToggle("LevelQuests", {
        Text = "Use Repeatable Quests",
        Default = true,
        Callback = function(value)
            Flags.LevelQuests = value == true
        end,
    })
    Leveling:AddToggle("LevelBosses", {
        Text = "Fight Gate Bosses",
        Default = true,
        Callback = function(value)
            Flags.LevelBosses = value == true
        end,
    })
    Leveling:AddLabel("Overrides Mob Selector while on", true)
    task.spawn(function()
        local last = nil
        while not unloaded do
            local text = "Status: " .. tostring(Game.levelStatus)
            if text ~= last then
                last = text
                pcall(LevelStatusLabel.SetText, LevelStatusLabel, text)
            end
            task.wait(1)
        end
    end)

    local Skills = FarmSub:AddLeftGroupbox("Skills", "zap")
    featureToggle(Skills, "AutoSkills", "Auto Skills")
    Skills:AddDropdown("Skills", {
        Text = "Skills",
        Values = learnedSkills(),
        Multi = true,
        Searchable = true,
        Default = {},
        Callback = function(value)
            Flags.Skills = toSet(value)
        end,
    })
    Skills:AddButton({
        Text = "Refresh Skills",
        Func = function()
            Options.Skills:SetValues(learnedSkills())
        end,
    })

    local Potions = FarmSub:AddRightGroupbox("Potions", "flask-conical")
    featureToggle(Potions, "AutoPotions", "Auto Potions")
    Potions:AddDropdown("Potions", {
        Text = "Potions",
        Values = potionOptions(),
        Multi = true,
        Searchable = true,
        Default = {},
        Callback = function(value)
            Flags.Potions = toSet(value)
        end,
    })
    Potions:AddSlider("HpPercent", {
        Text = "HP Potion Below %",
        Default = 50,
        Min = 5,
        Max = 90,
        Rounding = 0,
        Callback = function(value)
            Flags.HpPercent = tonumber(value) or Flags.HpPercent
        end,
    })
    Potions:AddSlider("SpPercent", {
        Text = "SP Potion Below %",
        Default = 30,
        Min = 5,
        Max = 90,
        Rounding = 0,
        Callback = function(value)
            Flags.SpPercent = tonumber(value) or Flags.SpPercent
        end,
    })

    local Stats = FarmSub:AddRightGroupbox("Stats", "trending-up")
    featureToggle(Stats, "AutoStats", "Auto Stats")
    Stats:AddDropdown("StatChoice", {
        Text = "Build / Stat",
        Values = buildOptions(),
        Multi = false,
        Default = nil,
        Callback = function(value)
            Flags.StatChoice = value
        end,
    })

    local Progress = FarmSub:AddRightGroupbox("Progression", "gift")
    featureToggle(Progress, "AutoRewards", "Auto Claim Online, 8-Day, Monthly")
    featureToggle(Progress, "AutoGear", "Auto Gear")
    featureToggle(Progress, "AutoCards", "Auto Cards")

    local Collect = FarmSub:AddLeftGroupbox("Collect", "package")
    featureToggle(Collect, "AutoDrops", "Auto Collect Dropped")
    featureToggle(Collect, "AutoBoxes", "Auto Collect Hard Worker Box")

    local Refine = RefineSub:AddLeftGroupbox("Auto Refine", "hammer")
    featureToggle(Refine, "AutoRefine", "Auto Refine")
    RefineStatusLabel = Refine:AddLabel("Status: Idle", true)
    Refine:AddDropdown("RefineWeapons", {
        Text = "Weapons",
        Values = weaponOptions(),
        Multi = true,
        Searchable = true,
        Default = {},
        Callback = function(value)
            local set = {}
            for label, on in pairs(type(value) == "table" and value or {}) do
                local gid = on and tostring(label):match("%[(.-)%]$")
                if gid then
                    set[gid] = true
                end
            end
            Flags.RefineWeapons = set
        end,
    })
    Refine:AddButton({
        Text = "Refresh Weapons",
        Func = function()
            Options.RefineWeapons:SetValues(weaponOptions())
        end,
    })

    local RefineBox = RefineSub:AddRightGroupbox("Configuration", "sliders-horizontal")
    RefineBox:AddSlider("RefineTarget", {
        Text = "Stop At Level",
        Default = 4,
        Min = 1,
        Max = refineMax(),
        Rounding = 0,
        Callback = function(value)
            Flags.RefineTarget = tonumber(value) or Flags.RefineTarget
        end,
    })
    RefineBox:AddToggle("RefineSafeOnly", {
        Text = "Only 100% Chance",
        Default = true,
        Callback = function(value)
            Flags.RefineSafeOnly = value == true
        end,
    })
    RefineBox:AddLabel("Failed refines from +5 drop the weapon a level", true)
    RefineBox:AddToggle("RefineProtect", {
        Text = "Use Protect Stone",
        Default = false,
        Callback = function(value)
            Flags.RefineProtect = value == true
        end,
    })
    RefineBox:AddToggle("RefineLucky", {
        Text = "Use Lucky Stone",
        Default = false,
        Callback = function(value)
            Flags.RefineLucky = value == true
        end,
    })
    RefineBox:AddInput("RefineGoldReserve", {
        Text = "Keep Gold Above",
        Default = "0",
        Numeric = true,
        Finished = true,
        Callback = function(value)
            Flags.RefineGoldReserve = tonumber(value) or 0
        end,
    })
    RefineBox:AddSlider("RefineDelay", {
        Text = "Delay (s)",
        Default = 1,
        Min = 0.5,
        Max = 5,
        Rounding = 1,
        Callback = function(value)
            Flags.RefineDelay = tonumber(value) or Flags.RefineDelay
        end,
    })

    local SellSub = Main:AddSubTab("Sell")
    local Sell = SellSub:AddLeftGroupbox("Auto Sell", "coins")
    featureToggle(Sell, "AutoSell", "Auto Sell")
    SellStatusLabel = Sell:AddLabel("Status: Idle", true)
    Sell:AddDropdown("SellKinds", {
        Text = "Sell Categories",
        Values = sellKindOptions(),
        Multi = true,
        Default = {},
        AllowNull = true,
        Callback = function(value)
            Flags.SellKinds = toSet(value)
        end,
    })
    Sell:AddDropdown("SellKeep", {
        Text = "Never Sell",
        Values = sellItemOptions(),
        Multi = true,
        Searchable = true,
        Default = {},
        AllowNull = true,
        Callback = function(value)
            local set = {}
            for label in pairs(toSet(value)) do
                local id = tostring(label):match("%[(.-)%]$")
                if id then
                    set[id] = true
                end
            end
            Flags.SellKeep = set
        end,
    })
    Sell:AddToggle("SellJunk", {
        Text = "Also Sell Junk",
        Default = true,
        Callback = function(value)
            Flags.SellJunk = value == true
        end,
    })
    Sell:AddLabel("Locked and equipped items are never sold", true)

    local SellBox = SellSub:AddRightGroupbox("Configuration", "sliders-horizontal")
    SellBox:AddDropdown("SellTrigger", {
        Text = "Sell When",
        Values = { "Bag Full %", "Interval" },
        Multi = false,
        Default = "Bag Full %",
        Callback = function(value)
            Flags.SellTrigger = value or "Bag Full %"
        end,
    })
    SellBox:AddSlider("SellBagPercent", {
        Text = "Bag Full %",
        Default = 90,
        Min = 10,
        Max = 100,
        Rounding = 0,
        Callback = function(value)
            Flags.SellBagPercent = tonumber(value) or Flags.SellBagPercent
        end,
    })
    SellBox:AddSlider("SellInterval", {
        Text = "Interval (s)",
        Default = 120,
        Min = 10,
        Max = 900,
        Rounding = 0,
        Callback = function(value)
            Flags.SellInterval = tonumber(value) or Flags.SellInterval
        end,
    })
    SellBox:AddSlider("SellKeepAmount", {
        Text = "Keep Per Item",
        Default = 0,
        Min = 0,
        Max = 100,
        Rounding = 0,
        Callback = function(value)
            Flags.SellKeepAmount = tonumber(value) or 0
        end,
    })
    SellBox:AddToggle("SellKeepRefined", {
        Text = "Keep Refined Gear",
        Default = true,
        Callback = function(value)
            Flags.SellKeepRefined = value == true
        end,
    })
end

local function setupPlayerTab()
    local Movement = Player:AddLeftGroupbox("Movement", "move")
    Movement:AddToggle("WalkSpeedEnabled", {
        Text = "WalkSpeed",
        Default = false,
        Callback = setWalkSpeedEnabled,
    })
    Movement:AddSlider("WalkSpeed", {
        Text = "Speed",
        Default = 32,
        Min = 16,
        Max = 250,
        Rounding = 0,
        Callback = setWalkSpeed,
    })
    Movement:AddToggle("AlwaysSprint", {
        Text = "Always Sprint",
        Default = false,
        Callback = setAlwaysSprint,
    })
    Movement:AddToggle("InfJump", {
        Text = "Infinite Jump",
        Default = false,
        Callback = setInfJump,
    })
    Movement:AddToggle("NoClip", {
        Text = "Noclip",
        Default = false,
        Callback = setNoClip,
    })
    Movement:AddToggle("InstantProximityPrompt", {
        Text = "Instant ProximityPrompt",
        Default = false,
        Callback = setInstantProximityPrompt,
    })

    local FlyBox = Player:AddRightGroupbox("Fly", "plane")
    FlyBox:AddToggle("Fly", {
        Text = "Fly",
        Default = false,
        Callback = setFly,
    })
    FlyBox:AddSlider("FlySpeed", {
        Text = "Fly Speed",
        Default = 60,
        Min = 10,
        Max = 400,
        Rounding = 0,
        Callback = setFlySpeed,
    })

    local Teleports = Player:AddRightGroupbox("Teleports", "map-pin")
    Teleports:AddDropdown("ZoneTeleport", {
        Text = "Zone",
        Values = zoneOptions(),
        Multi = false,
        Searchable = true,
        Default = nil,
    })
    Teleports:AddButton({
        Text = "Teleport To Zone",
        Func = function()
            if not teleportZone(Options.ZoneTeleport.Value) then
                Library:Notify({ Title = GAME_NAME, Description = "Zone position not found", Time = 3 })
            end
        end,
    })
    Teleports:AddDropdown("NpcTeleport", {
        Text = "NPC",
        Values = npcOptions(),
        Multi = false,
        Searchable = true,
        Default = nil,
    })
    Teleports:AddButton({
        Text = "Teleport To NPC",
        Func = function()
            if not teleportNpc(Options.NpcTeleport.Value) then
                Library:Notify({ Title = GAME_NAME, Description = "NPC position not found", Time = 3 })
            end
        end,
    })
    Teleports:AddButton({
        Text = "Refresh NPCs",
        Func = function()
            Options.NpcTeleport:SetValues(npcOptions())
        end,
    })

    local Client = Player:AddLeftGroupbox("Client", "monitor")
    Client:AddToggle("AutoReconnect", {
        Text = "Auto Reconnect on Kick",
        Default = false,
        Callback = setAutoReconnect,
    })
    Client:AddToggle("Disable3DRendering", {
        Text = "Disable 3D Rendering",
        Default = false,
        Callback = setDisable3D,
    })
    Client:AddToggle("FpsBoost", {
        Text = "FPS Boost",
        Default = false,
        Callback = setFpsBoost,
    })
end

local function setupSettingsTab()
    local Menu = Settings:AddLeftGroupbox("Menu", "wrench")
    Menu:AddLabel("Menu Keybind"):AddKeyPicker("MenuKeybind", {
        Default = "RightControl",
        NoUI = true,
        Text = "Menu keybind",
    })
    Library.ToggleKeybind = Options.MenuKeybind

    Menu:AddToggle("AntiAfk", {
        Text = "Anti AFK",
        Default = true,
        Callback = setAntiAfk,
    })

    Menu:AddButton({
        Text = "Unload",
        Risky = true,
        Func = function()
            Window:AddDialog("UnloadConfirm", {
                Title = "Unload?",
                Description = "Stops every feature and closes the menu.",
                FooterButtons = {
                    Cancel = { Title = "Cancel", Variant = "Secondary", Order = 1 },
                    Unload = {
                        Title = "Unload",
                        Variant = "Destructive",
                        Order = 2,
                        Callback = function()
                            task.defer(function()
                                Library:Unload()
                            end)
                        end,
                    },
                },
            })
        end,
    })

    setAntiAfk(Toggles.AntiAfk.Value)

    ThemeManager:SetLibrary(Library)
    SaveManager:SetLibrary(Library)
    SaveManager:IgnoreThemeSettings()
    SaveManager:SetIgnoreIndexes({ "MenuKeybind" })
    ThemeManager:SetFolder("Ouroboros")
    SaveManager:SetFolder("Ouroboros/" .. GAME_KEY)
    SaveManager:BuildConfigSection(Settings)
    ThemeManager:ApplyToTab(Settings)
end

setupMainTab()
setupPlayerTab()
setupSettingsTab()

SaveManager:LoadAutoloadConfig()
