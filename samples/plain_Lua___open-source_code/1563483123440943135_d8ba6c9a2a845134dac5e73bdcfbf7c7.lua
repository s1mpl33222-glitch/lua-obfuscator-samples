-- https://discord.gg/t6rhaAZvhG
if not game:IsLoaded() then
    game.Loaded:Wait()
end

if game.GameId ~= 10684750879 then
    game:GetService("Players").LocalPlayer:Kick("Aeris: this script is for Loot To Forge only")
    return
end

local AerisBanner = {
    Print = print,
    Started = os.clock(),
    Last = os.clock(),
    Done = 0,
    Total = 4,
}

do
    local ok, renv = pcall(getrenv)
    if ok and type(renv) == "table" and type(renv.print) == "function" then AerisBanner.Print = renv.print end
end

function AerisBanner.Show()
    local ok, executor = pcall(identifyexecutor)
    if not ok or type(executor) ~= "string" then executor = "Unknown" end
    local rule = string.rep("=", 54)
    AerisBanner.Print(table.concat({
        "",
        [[
       _              _     
      / \   ___ _ __ (_)___ 
     / _ \ / _ \ '__|| / __|
    / ___ \  __/ |   | \__ \
   /_/   \_\___|_|   |_|___/
        ]],
        rule,
        "   AERIS  //  LOOT TO FORGE",
        "   executor: " .. executor .. "   //   player: " .. game:GetService("Players").LocalPlayer.Name,
        rule,
    }, "\n"))
end

---@param label string
function AerisBanner.Step(label)
    local now = os.clock()
    AerisBanner.Done = math.min(AerisBanner.Done + 1, AerisBanner.Total)
    local filled = math.floor(AerisBanner.Done / AerisBanner.Total * 20 + 0.5)
    AerisBanner.Print(string.format("[Aeris] [%s] %3d%%  %-24s +%dms",
        string.rep("#", filled) .. string.rep(".", 20 - filled),
        math.floor(AerisBanner.Done / AerisBanner.Total * 100), label, math.floor((now - AerisBanner.Last) * 1000)))
    AerisBanner.Last = now
end

function AerisBanner.Ready()
    local rule = string.rep("=", 54)
    AerisBanner.Print(table.concat({
        rule,
        string.format("   >> AERIS READY in %dms", math.floor((os.clock() - AerisBanner.Started) * 1000)),
        rule,
    }, "\n"))
end

pcall(AerisBanner.Show)
pcall(AerisBanner.Step, "Core")

if not LPH_OBFUSCATED then
    local function Passthrough(fn) return fn end
    LPH_JIT, LPH_JIT_MAX, LPH_NO_VIRTUALIZE = Passthrough, Passthrough, Passthrough
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local VirtualUser = game:GetService("VirtualUser")
local RunService = game:GetService("RunService")
local GuiService = game:GetService("GuiService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")
local StarterGui = game:GetService("StarterGui")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

-- ============================================================================
-- AERIS CONSTANTS & SHIMMER ENGINE
-- ============================================================================
local TARGET_KEY = "LootMEaErIs"
local KEY_LINK = "https://discord.gg/t6rhaAZvhG"
local LOGO_ID = "rbxassetid://94398897297532"
local EXPIRE_SECONDS = 86400 -- 24 hours (86,400 seconds)

local ActiveShimmers = {}
local ShimmerConnection = nil

local function EnsureShimmerLoop()
    if ShimmerConnection then return end
    ShimmerConnection = RunService.RenderStepped:Connect(function()
        if #ActiveShimmers == 0 then return end
        local rot = (tick() * 100) % 360
        for i = #ActiveShimmers, 1, -1 do
            local grad = ActiveShimmers[i]
            if grad and grad.Parent then
                grad.Rotation = rot
            else
                table.remove(ActiveShimmers, i)
            end
        end
    end)
end

local function AttachShimmerStroke(instance, thickness)
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = thickness or 2
    stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    stroke.Color = Color3.fromRGB(255, 255, 255)

    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0.00, Color3.fromRGB(168, 85, 247)),  -- Neon Purple
        ColorSequenceKeypoint.new(0.25, Color3.fromRGB(255, 255, 255)),  -- Pure White
        ColorSequenceKeypoint.new(0.50, Color3.fromRGB(192, 132, 252)),  -- Light Lavender
        ColorSequenceKeypoint.new(0.75, Color3.fromRGB(255, 255, 255)),  -- Pure White
        ColorSequenceKeypoint.new(1.00, Color3.fromRGB(168, 85, 247)),  -- Neon Purple
    })
    gradient.Parent = stroke
    stroke.Parent = instance

    table.insert(ActiveShimmers, gradient)
    EnsureShimmerLoop()
    return stroke, gradient
end

local function GetSafeGuiParent()
    local ok, parent = pcall(function()
        if gethui then return gethui() end
        local core = game:GetService("CoreGui")
        return core:FindFirstChild("RobloxGui") or core
    end)
    if ok and parent then return parent end
    return LocalPlayer:WaitForChild("PlayerGui")
end

local function CopyToClipboard(clipboardText)
    local fn = setclipboard or toclipboard or (Clipboard and Clipboard.set) or (syn and syn.write_clipboard)
    if fn then
        pcall(fn, clipboardText)
        return true
    end
    return false
end

local function GetKeyFilePath()
    local userId = LocalPlayer and LocalPlayer.UserId or 0
    return "Aeris_Key_" .. tostring(userId) .. ".json"
end

local function IsKeyValid()
    -- Check in-memory session first
    if getgenv and getgenv().AerisKeyValidated then
        local now = os.time()
        if (now - getgenv().AerisKeyValidated) < EXPIRE_SECONDS then
            return true
        end
    end

    if not isfile or not readfile then return false end
    local path = GetKeyFilePath()
    local exists = false
    local okCheck = pcall(function() exists = isfile(path) end)
    if not okCheck or not exists then return false end

    local content = nil
    local okRead = pcall(function() content = readfile(path) end)
    if not okRead or type(content) ~= "string" then return false end

    local data = nil
    local okParse = pcall(function() data = HttpService:JSONDecode(content) end)
    if not okParse or type(data) ~= "table" then return false end

    -- Exact case-sensitive key check with spaces preserved
    if data.key ~= TARGET_KEY then return false end

    -- Check 24-hour expiration
    local now = os.time()
    local saved = tonumber(data.saved_at) or 0
    if (now - saved) < 0 or (now - saved) >= EXPIRE_SECONDS then
        pcall(delfile, path)
        return false
    end

    if getgenv then getgenv().AerisKeyValidated = saved end
    return true
end

local function SaveKey(key)
    local now = os.time()
    if getgenv then getgenv().AerisKeyValidated = now end

    if not writefile then return end
    local path = GetKeyFilePath()
    local data = {
        key = key,
        saved_at = now,
        user_id = LocalPlayer and LocalPlayer.UserId or 0,
    }
    pcall(function()
        writefile(path, HttpService:JSONEncode(data))
    end)
end

local Aeris = setmetatable({}, {
    __newindex = function(self, key, value)
        rawset(self, key, type(value) == "function" and LPH_JIT(value) or value)
    end,
})

Aeris.Config = {
    SaveFolder = "Aeris/LootToForge",
    UpdateLog = {
        { "2026-10-14", "Autonomous Egg2 Hatching & Auto-Incubate Watchdog\nAccurate Server Timer Sync & Zero-Crash Status UI\nTargeted Legendary Honor Hunt & Auto Egg Trimming\nFull Combat Aura, God Ore Spawning & Rebirth Farm" },
        { "2026-10-13", "Map-Wide Insane Kill Aura (SuperLoot + All Mobs + World Boss)\nInstant God Ore Spawner & Stage 27 Tier 48 farm\nFast Tower Season Coins and shop automation\nDeadlock-free cached profile & enhanced scheduler" },
    },
    UiSource = "https://sirius.menu/rayfield",
    ReloadSource = [[
if not game:IsLoaded() then game.Loaded:Wait() end
task.wait(2)
if getgenv and getgenv().AerisLoaderUrl then
    local url = getgenv().AerisLoaderUrl
    local ok, body = pcall(game.HttpGet, game, url)
    if not (ok and type(body) == "string") then
        local requester = request or http_request or (syn and syn.request) or (http and http.request)
        local sent, reply = pcall(requester, { Url = url, Method = "GET" })
        body = sent and type(reply) == "table" and reply.Body
    end
    if type(body) == "string" then loadstring(body)() end
end]],
    LoadTimeout = 30,
    RemoteTimeout = 10,
    RequireTimeout = 3,
    MaxFailures = 5,
    FailWindow = 10,
    AlertTries = 20,
    AlertDelay = 0.5,
    TickDelay = 0.15,
    StatusInterval = 1.5,
    PumpInterval = 0.2,
    OwnedOresLabel = "Owned ores",
    AcquireRounds = 5,
    StoneWorkers = 16,
    StoneCallsPerWorker = 25,
    EggFarmWorkers = 16,
    EggFarmCalls = 25,
    TurboFarmWorkers = 24,
    TurboFarmCalls = 35,
    TurboBurstCount = 10000,
    PetInterval = 0.5,
    PetDeployInterval = 15,
    TowerWorkers = 16,
    CoinFarmTimeout = 600,
    TowerCallsPerWorker = 15,
    GearForgeTries = 15,
    GearEnhanceTries = 2,
    GearEnhanceWorkers = 8,
    SlotEnhanceRounds = 200,
    ClickInterval = 0.12,
    ForgeTargets = {
        { name = "Great Weapon", forgeType = "Weapon", ores = 13 },
        { name = "Katana", forgeType = "Weapon", ores = 4 },
        { name = "Armor", forgeType = "Armor", ores = 11 },
        { name = "Hat", forgeType = "Armor", ores = 4 },
    },
    GearSlots = {
        { slot = "Weapon", forgeType = "Weapon", ores = 13 },
        { slot = "Armor", forgeType = "Armor", ores = 11 },
        { slot = "Hat", forgeType = "Armor", ores = 4 },
    },
    GearTypes = { "Weapon", "Armor", "Hat" },
    EnchantPriority = { "Poison_3", "Thunder_3", "Ice_3", "Fire_3", "Poison_2", "Thunder_2", "Ice_2", "Fire_2" },
    RuneMinTier = 2,
    EnchantRefill = 50,
    ForgeCountMax = 30,
    PlanSlice = 0.004,
    HuntBatch = 40,
    HuntWorkers = 4,
    HuntMaxForges = 4000,
    HuntTargetHits = 3,
    IndexInterval = 60,
    IndexLevelClaims = 50,
    ClaimIdScan = 20,
    LookKinds = { "Ore", "EnchStone", "Weapon", "Armor", "Material", "Class", "Pet", "Egg", "Food" },
    TokenShopInterval = 60,
    ClaimInterval = 30,
    SeasonInterval = 60,
    BossCards = 8,
    BossAttackIds = { Katana = "K_ATK_1", Great = "G_ATK_1" },
    BossHitsPerTick = 30,
    BossHitGap = 0.02,
    BossJoinSettle = 1,
    BossClaimDelay = 3.5,
    BossStandHeight = 3,
    BossStandBack = 8,
    BossReach = 25,
    UpgradeInterval = 5,
    EquipInterval = 3,
    SellInterval = 1,
    RebirthInterval = 2,
    BossInterval = 1,
    BossHopInterval = 5,
    BossHopAfter = 8,
    BossLootTimeout = 30,
    BossHopFlag = "bosshop.txt",
    BossHopResume = 180,
    BossHopServers = "bossservers.json",
    HopListTtl = 120,
    HopBackoffStart = 5,
    HopBackoffMax = 60,
    HopGiveUp = 8,
    HopStall = 30,
    HopGap = 15,
    TrainRejoinDelay = 0.3,
    TrainWatchdog = 3,
    TrainAcceptWait = 1.5,
    TrainExitTries = 3,
    TrainSettle = 0.5,
    WarnCooldown = 30,
    WarnMemory = 64,
    KillAuraInterval = 0.12,
    KillDamage = 1e30,
    RaceRollDelay = 0.15,
    RaceResultWait = 2,
    RaceProtectRarity = "Mythic",
    RaceSlots = { "Equipped", "Slot 1", "Slot 2", "Slot 3" },
    RejoinDelay = 5,
    CodeReplyWait = 1.5,
    Codes = { "100000CCU", "50000CCU", "30000CCU", "20000CCU" },
    Needs = {
        AutoBattle = { "Utils.CommunicationUtils", "CTRL.EnemyCTRL", "Config.Stage.Helper" },
        AutoCheckIn = { "LocalData.PlanKData", "Remote.PlanKing_Server.TryClaimRE", "Config.PlanK.Config" },
        AutoTokenShop = { "Config.TokenShop.Config", "Remote.TokenShop_Server.OpenGoodsRE", "Remote.TokenShop_Server.ExchangeGoodsRF" },
        KillAura = { "Utils.CommunicationUtils" },
        CollectOre = { "Remote.Stage_Server.StageFinishedRF", "Remote.Stage_Server.GetOreRF", "Remote.Stage_Server.ClaimedAllOreRE", "Config.Stage.Helper", "Config.Ore.Config" },
        SuperLootAura = { "Remote.SuperLoot_Server.KillSuperLootRE", "Remote.SuperLoot_Server.RefreshSuperLootRE", "Remote.Stage_Server.GetOreRF" },
        AutoWorldBoss = { "Remote.WorldBoss_Server.IntoWorldBossFightRE", "Remote.WorldBoss_Server.ExitWorldBossFightRE", "Remote.WorldBoss_Server.BossDeadRE", "Remote.Attack_Server.UseAnyATKRE", "Remote.Attack_Server.AttackEnemyServiceRE" },
        AutoIndex = { "Remote.Forge_Server.ForgeRF", "Remote.Index_Server.TryClaimIndexExpRF", "Utils.ForgeUtils", "Config.Weapon.Config", "Config.Armor.Config" },
        MaxGear = { "Utils.BalanceUtils", "Remote.Forge_Server.ForgeRF", "Remote.Backpack_Server.EnhantEquipmentRF", "Remote.Backpack_Server.EnchantRE", "Config.Enhant.Config", "Config.EnchStone.Show" },
        AutoEquip = { "Utils.BalanceUtils", "Remote.Backpack_Server.TryEquipItemRE", "Config.Weapon.Helper", "Config.Armor.Helper" },
        AutoForge = { "Remote.Forge_Server.ForgeRF", "Remote.Backpack_Server.TrySellItemRE", "Config.Ore.Config" },
        AutoSell = { "Remote.Backpack_Server.TrySellItemRE", "Config.Weapon.Config", "Config.Armor.Config" },
        AutoTrain = { "Remote.Train_Server.IntoAutoTrainRE", "Remote.Train_Server.ExitAutoTrainRE", "Config.TrainArea.Config" },
        AutoRebirth = { "Remote.Rebirth_Server.TryRebirthRE", "Config.Rebirth.Helper" },
        AutoUpgrade = { "Remote.Upgrade_Server.UpgradeOnceRE", "Config.Upgrade.Config" },
        AutoTower = { "Remote.Dungeon_Server.TryIntoDungeonRF", "Remote.Dungeon_Server.StartRoundRE", "Remote.Dungeon_Server.CompleteRoundRF", "Config.Dungeon.Config.LootTab" },
        RaceBuyRolls = { "Config.Season.GoodsConfig", "Remote.Season_Server.ExchangeGoodsRE", "LocalData.ClassData" },
        AutoSeason = { "Remote.Season_Server.TryClaimDailyTicRE", "Remote.Season_Server.ExchangeGoodsRE", "Remote.Season_Server.LuckRE", "Config.Season.GoodsConfig" },
        AutoClaim = { "Remote.Offline_Server.TryClaimOfflineRewardRE", "Remote.Online_Server.TryClaimRE" },
        AutoRace = { "Remote.Class_Server.LuckOnceRE", "Config.Class.Config" },
        AutoBestRace = { "Remote.Class_Server.ChangeEquipedIndexRE", "Config.Class.Config" },
        AutoHatchEgg = { "Remote.Pet_Server.TryHatchEggRE", "Remote.Pet_Server.TryOpenEggRE", "Config.Egg.Config" },
        AutoEquipPet = { "Remote.Pet_Server.IsEquipPetRE", "Utils.BalanceUtils", "Config.Pet.Config" },
        AutoFeedPet = { "Remote.Pet_Server.FeedPetRE", "Config.Pet.Helper", "Config.Food.Config" },
        AutoDeployPet = { "Remote.Pet_Server.IsDeployPetRE", "Remote.Pet_Server.ClaimAllDeployRewardRE", "Config.Pet.Config" },
        AutoSellPet = { "Remote.Pet_Server.DeleteRE", "Config.Pet.Config", "Config.Egg.Config" },
        KeepOre = { "Remote.Stage_Server.LostAllOreRF" },
    },
    KaitunToggles = { "MaxGear", "AutoEquip", "AutoForge", "AutoSell", "AutoTrain", "AutoRebirth", "AutoUpgrade", "AutoClaim", "AutoCheckIn", "AutoSeason", "KillAura", "SuperLootAura", "AutoWorldBoss", "AutoTower", "GodMode", "AutoBestRace", "AutoHatchEgg", "AutoEquipPet", "AutoFeedPet", "AutoDeployPet" },
}

local Config = Aeris.Config
local Remote = ReplicatedStorage:WaitForChild("Remote", Config.LoadTimeout)
local GameConfig = ReplicatedStorage:WaitForChild("Config", Config.LoadTimeout)

Aeris.State = {
    Alive = true,
    Busy = false,
    Rolling = false,
    SavedSpot = nil,
    Rejoining = false,
    Lock = nil,
    LockOwner = nil,
    LockTime = 0,
    Profile = nil,
    ProfileTime = 0,
    ProfileCacheTtl = 0.35,
    Failures = {},
    Halted = {},
    InTower = false,
    Entering = false,
    GearForged = false,
    TrainArea = nil,
    TrainPending = nil,
    TrainEntering = false,
    TrainGen = 0,
    TrainFiredAt = 0,
    TrainRebirth = nil,
    BossReturn = nil,
    TrainLevel = nil,
    TrainNilSince = nil,
    Warned = {},
    WarnedCount = 0,
    LastRun = {},
    RemoteCache = {},
    JobRunning = {},
    WorkerBatches = {},
    ChildThreads = {},
    JobGroups = {},
    JobStats = {},
    ScheduleCursor = 0,
    LootPending = {},
    LootQueue = {},
    LootSeen = {},
    GearNote = nil,
    IndexNote = nil,
    TowerLoot = 0,
    OreLabels = {},
    GearLabels = {},
    SpawnLabels = {},
    BossHopping = false,
    HopFails = 0,
    HopBackoff = nil,
    HopBlockedUntil = 0,
    HopQueued = false,
    BossDone = nil,
    MissingLabels = {},
    OreStage = {},
    Plans = {},
    Runes = nil,
    Conns = {},
    AuraCursor = 0,
    Opt = {
        MaxGear = false,
        AutoEquip = false,
        EnhanceTarget = 20,
        GearForge = true,
        GearEnchant = true,
        GearEnhance = true,
        EnchantPriority = {},
        EnhanceSlot = "Weapon",
        ForgeSellJunk = false,
        ForgePerTick = 10,
        BossCards = true,
        SeasonSpin = true,
        SeasonSpinBatch = 10,
        SeasonGoods = { ["4"] = true, ["5"] = true, ["7"] = true },
        AutoBestRace = false,
        GodMode = false,
        KeepOre = false,
        CollectOre = false,
        Stage = "Stage_27",
        CollectRarities = {},
        KillAura = false,
        AutoBattle = false,
        AutoCheckIn = false,
        TokenReveal = true,
        TokenTargets = {},
        TokenSkipOwned = true,
        AuraMapWide = true,
        AuraRange = 0,
        AuraBatch = 60,
        AuraBurst = 10,
        AuraInterval = 0.12,
        AuraDamage = 1e30,
        AuraCritical = true,
        AuraSuper = true,
        AuraTarget = "All",
        AutoCollectDrops = true,
        JobTimeout = 60,
        WorkerLimit = 16,
        ParallelJobs = 4,
        SuperLootAura = true,
        AutoWorldBoss = false,
        BossHop = false,
        BossWaitMinutes = 2.5,
        AutoForge = false,
        ForgeTarget = "Great Weapon",
        ForgeOre = nil,
        ForgeRarities = {},
        KeepPerOre = 0,
        BestOreFirst = false,
        AutoSell = false,
        SellTypes = { Weapon = true, Armor = true, Hat = true },
        SellRarities = {},
        KeepPerItem = 1,
        AutoIndex = false,
        IndexTypes = { Weapon = true, Armor = true, Hat = true },
        MissingItem = nil,
        AutoTrain = false,
        AutoClick = false,
        AutoRebirth = false,
        AutoUpgrade = false,
        Upgrades = {},
        AutoClaim = false,
        AutoSeason = false,
        AutoTokenShop = false,
        AutoTower = false,
        AutoRace = false,
        RaceTargets = {},
        RaceMinLevel = nil,
        RaceStar = 0,
        RaceSlot = "Equipped",
        RaceLock = false,
        RaceProtect = false,
        RaceBuyRolls = true,
        RaceAnim = false,
        AutoHatchEgg = false,
        TargetPet = nil,
        TargetPetCopies = 1,
        AutoChaseTargetPet = false,
        AutoLockTargetPet = true,
        HatchBestFirst = true,
        SkipEggAnim = true,
        AutoEquipPet = false,
        AutoFeedPet = false,
        AutoDeployPet = false,
        AutoSellPet = false,
        DeletePetRarities = { Common = true, UnCommon = true, Rare = true },
        KeepBestPets = 6,
        AutoDeleteEggs = false,
        KeepPerEgg = 10,
        EggFarmRounds = 10,
        CoinTarget = 50000,
        SpawnItem = nil,
        SpawnAmount = 1000,
        TurboSpawn = false,
        TurboBurst = 10000,
        PotionAmount = 1000,
        SpawnGear = nil,
        GearCopies = 1,
        SpeedOn = false,
        WalkSpeed = 60,
        InfJump = false,
        AutoRejoin = false,
        LowGraphics = false,
    },
}

local State = Aeris.State

Aeris.GameLib = { Loaded = {}, Failed = {}, Apis = {}, Deferred = {} }

---@param module Instance
---@return boolean, any
function Aeris.GameLib.RequireAsGame(module)
    local done, ok, loaded = false, false, nil
    local thread = Aeris.Util.Child(function()
        pcall(setthreadidentity, 2)
        local read, identity = pcall(getthreadidentity)
        if read and identity == 2 then
            ok, loaded = pcall(require, module)
        end
        done = true
    end)
    local deadline = os.clock() + Config.RequireTimeout
    while not done and os.clock() < deadline do
        task.wait()
    end
    if not done then pcall(task.cancel, thread) return false, "module require timed out" end
    return ok, loaded
end

---@param module Instance
---@return table?
function Aeris.GameLib.Require(module)
    local cached = Aeris.GameLib.Loaded[module]
    if cached ~= nil or Aeris.GameLib.Failed[module] then return cached end

    local result
    local thread = Aeris.Util.Child(function() result = table.pack(pcall(require, module)) end)
    local deadline = os.clock() + Config.RequireTimeout
    while not result and os.clock() < deadline do task.wait() end
    if not result then
        pcall(task.cancel, thread)
        result = { false, "module require timed out" }
    end
    local ok, loaded = result[1], result[2]
    if not ok then
        local firstErr = loaded
        ok, loaded = Aeris.GameLib.RequireAsGame(module)
        if not ok then
            Aeris.GameLib.Failed[module] = tostring(firstErr)
            warn("[Aeris] require", module:GetFullName(), firstErr)
            return nil
        end
    end
    Aeris.GameLib.Loaded[module] = loaded
    return loaded
end

---@param fn function
---@return boolean, any ...
function Aeris.GameLib.CallAsGame(fn, ...)
    local args = table.pack(...)
    local box
    local thread = Aeris.Util.Child(function()
        pcall(setthreadidentity, 2)
        box = table.pack(pcall(fn, table.unpack(args, 1, args.n)))
    end)
    local deadline = os.clock() + Config.RequireTimeout
    while not box and os.clock() < deadline do
        task.wait()
    end
    if not box then pcall(task.cancel, thread) return false, "game call timed out" end
    return table.unpack(box, 1, box.n)
end

---@param fn function
---@return any ...
function Aeris.GameLib.Call(fn, ...)
    if not Aeris.GameLib.Deferred[fn] then
        local result = table.pack(pcall(fn, ...))
        if result[1] or not tostring(result[2]):find("non-RobloxScript", 1, true) then
            if not result[1] then error(result[2], 0) end
            return table.unpack(result, 2, result.n)
        end
        Aeris.GameLib.Deferred[fn] = true
    end
    local result = table.pack(Aeris.GameLib.CallAsGame(fn, ...))
    if not result[1] then error(result[2], 0) end
    return table.unpack(result, 2, result.n)
end

---@param module Instance
---@return table
function Aeris.GameLib.Api(module)
    local api = Aeris.GameLib.Apis[module]
    if api then return api end
    local loaded = Aeris.GameLib.Need(module)
    api = setmetatable({}, {
        __index = function(self, key)
            local value = loaded[key]
            if type(value) ~= "function" then return value end
            local wrapped = function(...)
                return Aeris.GameLib.Call(value, ...)
            end
            rawset(self, key, wrapped)
            return wrapped
        end,
    })
    Aeris.GameLib.Apis[module] = api
    return api
end

---@param module Instance
---@return table
function Aeris.GameLib.Need(module)
    local loaded = Aeris.GameLib.Require(module)
    if loaded == nil then
        error(("game data %s.%s can't be read on this executor"):format(module.Parent.Name, module.Name), 0)
    end
    return loaded
end

---@param path string
---@return Instance?
function Aeris.GameLib.Find(path)
    local node = ReplicatedStorage
    for part in path:gmatch("[^%.]+") do
        node = node and node:FindFirstChild(part)
    end
    if node then return node end
    local folder, name = path:match("^Remote%.([^%.]+)%.([^%.]+)$")
    return folder and Aeris.Util.FindRemote(folder, name)
end

---@return table
function Aeris.GameLib.Missing()
    local missing = {}
    for idx, paths in pairs(Config.Needs) do
        for _, path in ipairs(paths) do
            if not Aeris.GameLib.Find(path) then
                missing[idx] = missing[idx] or {}
                table.insert(missing[idx], path)
            end
        end
    end
    return missing
end

for _, name in ipairs({ "Util", "Data", "Stage", "Ore", "Spawn", "Potion", "Forge", "Sell", "Gear", "Index", "Level", "Upgrade", "Tower", "Boss", "Season", "Claim", "TokenShop", "Look", "SuperLoot", "Combat", "Guard", "Race", "Pet", "Movement", "Session", "Scheduler" }) do
    Aeris[name] = {}
end

---@param folder string
---@param name string
---@return Instance?
function Aeris.Util.FindRemote(folder, name)
    if not Remote then return nil end
    local key = folder .. "." .. name
    local cached = State.RemoteCache[key]
    if cached and cached:IsDescendantOf(Remote) then return cached end
    State.RemoteCache[key] = nil

    local directFolder = Remote:FindFirstChild(folder .. "_Server") or Remote:FindFirstChild(folder)
    if directFolder then
        local remote = directFolder:FindFirstChild(name)
        if remote and (remote:IsA("RemoteEvent") or remote:IsA("RemoteFunction")) then
            State.RemoteCache[key] = remote
            return remote
        end
    end

    for _, descendant in ipairs(Remote:GetDescendants()) do
        if descendant.Name == name and (descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction")) then
            local parentName = descendant.Parent and descendant.Parent.Name or ""
            if parentName:find("^" .. folder) then
                State.RemoteCache[key] = descendant
                return descendant
            end
        end
    end

    for _, descendant in ipairs(Remote:GetDescendants()) do
        if descendant.Name == name and (descendant:IsA("RemoteEvent") or descendant:IsA("RemoteFunction")) then
            State.RemoteCache[key] = descendant
            return descendant
        end
    end

    return nil
end

---@param folder string
---@param name string
---@return Instance
function Aeris.Util.Remote(folder, name)
    local remote = Aeris.Util.FindRemote(folder, name)
    if remote then return remote end

    local holder = Remote and (Remote:FindFirstChild(folder .. "_Server") or Remote:WaitForChild(folder, Config.RemoteTimeout))
    remote = holder and holder:WaitForChild(name, Config.RemoteTimeout) or Aeris.Util.FindRemote(folder, name)
    if not remote then error(("remote %s.%s not found"):format(folder, name), 0) end
    return remote
end

---@param url string
---@return string?, string?
function Aeris.Util.HttpGet(url)
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if ok and type(body) == "string" then return body end

    local send = request or http_request or (syn and syn.request) or (http and http.request)
    if not send then return nil, tostring(body) end
    local sent, response = pcall(send, { Url = url, Method = "GET" })
    if not sent then return nil, tostring(response) end
    if type(response) ~= "table" or response.StatusCode ~= 200 or type(response.Body) ~= "string" then
        return nil, "HTTP " .. tostring(type(response) == "table" and response.StatusCode)
    end
    return response.Body
end

---@param text string
---@param detail string?
function Aeris.Util.Alert(text, detail)
    warn("[Aeris] menu:", text, detail or "")
    task.spawn(function()
        for _ = 1, Config.AlertTries do
            local shown = pcall(StarterGui.SetCore, StarterGui, "SendNotification", { Title = "Aeris", Text = text, Duration = 10 })
            if shown then return end
            task.wait(Config.AlertDelay)
        end
    end)
end

local function LoadRayfield()
    local source = Aeris.Util.HttpGet("https://sirius.menu/rayfield")
    if not source or #source < 500 then
        source = Aeris.Util.HttpGet("https://raw.githubusercontent.com/SiriusSoftwareLtd/Rayfield/main/source.lua")
    end
    if not source or #source < 500 then
        Aeris.Util.Alert("Could not download Rayfield library. Please check your internet connection.")
        return nil
    end

    local chunk, compileErr = loadstring(source)
    if not chunk then
        Aeris.Util.Alert("Rayfield compilation error: " .. tostring(compileErr))
        return nil
    end
    local ok, lib = pcall(chunk)
    if not ok or type(lib) ~= "table" then
        Aeris.Util.Alert("Rayfield initialization failed: " .. tostring(lib))
        return nil
    end
    return lib
end

---@return table?
function Aeris.Util.LoadLibrary()
    return LoadRayfield()
end

---@param key string
---@param err any
function Aeris.Util.WarnJob(key, err)
    local stamp = key .. tostring(err):match("[^\n]*")
    local now = os.clock()
    if now - (State.Warned[stamp] or -Config.WarnCooldown) < Config.WarnCooldown then return end

    if not State.Warned[stamp] then
        State.WarnedCount += 1
        if State.WarnedCount > Config.WarnMemory then
            table.clear(State.Warned)
            State.WarnedCount = 1
        end
    end
    State.Warned[stamp] = now
    warn("[Aeris]", key, err)
end

---@param fn function
---@return boolean, any
function Aeris.Util.Try(fn, ...)
    local ok, err = pcall(fn, ...)
    if not ok then
        warn("[Aeris]", err)
    end
    return ok, err
end

---@param id string|number
---@return number
function Aeris.Util.Tier(id)
    return tonumber(tostring(id):match("%d+")) or 0
end

---@param number number
---@return string
function Aeris.Util.Abbreviate(number)
    local units = { "", "K", "M", "B", "T", "Qa", "Qi", "Sx", "Sp" }
    local index = 1
    while number >= 1000 and index < #units do
        number /= 1000
        index += 1
    end
    return (index == 1 and "%d%s" or "%.2f%s"):format(number, units[index])
end

---@param configTable table
---@return any
function Aeris.Util.HighestKey(configTable)
    local bestKey, bestTier = nil, -1
    for key in pairs(configTable) do
        local tier = Aeris.Util.Tier(key)
        if tier > bestTier then
            bestKey, bestTier = key, tier
        end
    end
    return bestKey
end

---@param fn function
---@return thread
function Aeris.Util.Child(fn)
    local owner = coroutine.running()
    local children = State.ChildThreads[owner]
    if not children then children = {} State.ChildThreads[owner] = children end
    local thread
    thread = task.defer(function()
        fn()
        children[thread] = nil
        if next(children) == nil then State.ChildThreads[owner] = nil end
    end)
    children[thread] = true
    return thread
end

---@param thread thread
function Aeris.Util.CancelTree(thread)
    if not thread then return end
    for child in pairs(State.ChildThreads[thread] or {}) do Aeris.Util.CancelTree(child) end
    State.ChildThreads[thread] = nil
    for _, worker in ipairs(State.WorkerBatches[thread] or {}) do Aeris.Util.CancelTree(worker) end
    State.WorkerBatches[thread] = nil
    if State.LockOwner == thread then State.Lock = nil State.LockOwner = nil State.LockTime = 0 end
    for uuid, owner in pairs(State.LootPending) do
        if owner == thread then State.LootPending[uuid] = nil State.LootSeen[uuid] = nil end
    end
    if coroutine.status(thread) ~= "dead" then pcall(task.cancel, thread) end
end

---@param workers number
---@param job function
---@return boolean
function Aeris.Util.WaitAll(workers, job)
    workers = math.max(0, math.floor(workers))
    local nextJob, pending, firstError = 0, workers, nil
    local threads = {}
    local owner = coroutine.running()
    State.WorkerBatches[owner] = threads
    for _ = 1, math.min(workers, math.clamp(State.Opt.WorkerLimit, 1, 32)) do
        table.insert(threads, task.defer(function()
            while State.Alive and nextJob < workers do
                nextJob += 1
                local ok, err = pcall(job)
                if not ok then firstError = firstError or err end
                pending -= 1
            end
        end))
    end
    local deadline = os.clock() + Config.RemoteTimeout * 2
    while State.Alive and pending > 0 and os.clock() < deadline do
        task.wait(0.05)
    end
    for _, thread in ipairs(threads) do
        if coroutine.status(thread) ~= "dead" then pcall(task.cancel, thread) end
    end
    State.WorkerBatches[owner] = nil
    if State.Alive and pending > 0 then error("worker batch timed out", 0) end
    if firstError then error(firstError, 0) end
    return pending == 0
end

---@return string[]
function Aeris.Util.RarityNames()
    local helper = Aeris.GameLib.Api(GameConfig.Rarity.Helper)
    local names = {}
    for level = 1, 20 do
        local name = helper.GetRarityByLevel(level)
        if not name then break end
        table.insert(names, name)
    end
    return names
end

---@param list table
---@return table
function Aeris.Util.AllSet(list)
    local set = {}
    for _, name in ipairs(list) do
        set[name] = true
    end
    return set
end

---@param name string
---@param fn function
---@return boolean, any ...
function Aeris.Util.Exclusive(name, fn, ...)
    local now = os.clock()
    if State.Lock and State.LockTime and (now - State.LockTime > 12) then
        State.Lock = nil
        State.LockOwner = nil
    end
    if State.Lock then return false end
    local owner = coroutine.running()
    for key, thread in pairs(State.JobRunning) do
        if thread ~= owner and not Aeris.Scheduler.Groups[key] then return false end
    end
    State.Lock = name
    State.LockOwner = owner
    State.LockTime = now
    local result = table.pack(pcall(fn, ...))
    if State.LockOwner == owner then
        State.Lock = nil
        State.LockOwner = nil
        State.LockTime = 0
    end
    if not result[1] then error(result[2], 0) end
    return true, table.unpack(result, 2, result.n)
end

---@param force boolean?
---@return table
function Aeris.Data.Get(force)
    local now = os.clock()
    if not force and State.Profile and (now - State.ProfileTime < State.ProfileCacheTtl) then
        return State.Profile
    end
    local remote = Aeris.Util.Remote("Profile", "GetTotalDataRF")
    local ok, profile = pcall(remote.InvokeServer, remote)
    if not ok or type(profile) ~= "table" then
        if State.Profile then return State.Profile end
        error("profile unavailable; retry after loading", 0)
    end
    State.Profile = profile
    State.ProfileTime = now
    return State.Profile
end

---@param profile table
---@param itemId string
---@return number
function Aeris.Data.Count(profile, itemId)
    local total = 0
    for _, entry in pairs(profile.Backpack.have) do
        if entry.ID == itemId then
            total += entry.Number or 1
        end
    end
    return total
end

---@param profile table
---@param itemId string
---@return string?
function Aeris.Data.Uuid(profile, itemId)
    for uuid, entry in pairs(profile.Backpack.have) do
        if entry.ID == itemId and (entry.Number or 0) >= 1 then
            return uuid
        end
    end
    return nil
end

---@return table
function Aeris.Data.Snapshot()
    local seen = {}
    for uuid in pairs(Aeris.Data.Get().Backpack.have) do
        seen[uuid] = true
    end
    return seen
end

---@param before table
---@return table
function Aeris.Data.NewGear(before)
    local fresh = {}
    for uuid, entry in pairs(Aeris.Data.Get(true).Backpack.have) do
        if not before[uuid] and (entry.Type == "Weapon" or entry.Type == "Armor" or entry.Type == "Hat") then
            fresh[uuid] = entry
        end
    end
    return fresh
end

---@param oreId string
---@return string?
function Aeris.Ore.Rarity(oreId)
    local oreConfig = Aeris.GameLib.Need(GameConfig.Ore.Config)[oreId]
    return oreConfig and Aeris.GameLib.Api(GameConfig.Rarity.Helper).GetRarityByLevel(oreConfig.Rarity)
end

---@param profile table
---@return table[]
function Aeris.Ore.Owned(profile)
    local ores = {}
    for uuid, entry in pairs(profile.Backpack.have) do
        if entry.Type == "Ore" and (entry.Number or 0) >= 1 then
            table.insert(ores, {
                uuid = uuid,
                id = entry.ID,
                tier = Aeris.Util.Tier(entry.ID),
                number = math.floor(entry.Number),
                rarity = Aeris.Ore.Rarity(entry.ID),
            })
        end
    end
    table.sort(ores, function(a, b) return a.tier > b.tier end)
    return ores
end

---@return string[]
function Aeris.Ore.Ids()
    local ids = {}
    for oreId in pairs(Aeris.GameLib.Need(GameConfig.Ore.Config)) do
        table.insert(ids, oreId)
    end
    table.sort(ids, function(a, b) return Aeris.Util.Tier(a) > Aeris.Util.Tier(b) end)
    return ids
end

---@param itemId string
---@return string?, string?
function Aeris.Look.Item(itemId)
    for _, kind in ipairs(Config.LookKinds) do
        local folder = GameConfig:FindFirstChild(kind)
        local show = folder and folder:FindFirstChild("Show") and Aeris.GameLib.Require(folder.Show)
        local entry = show and show[itemId]
        if not entry then continue end
        local config = folder:FindFirstChild("Config") and Aeris.GameLib.Require(folder.Config)
        local info = config and config[itemId]
        return entry.Image, info and info.Rarity
    end
    return nil, nil
end

---@param rarity any
---@return Color3?
function Aeris.Look.Color(rarity)
    if rarity == nil then return nil end
    State.RarityColors = State.RarityColors or {}
    local cached = State.RarityColors[rarity]
    if cached ~= nil then return cached or nil end

    local helper = Aeris.GameLib.Api(GameConfig.Rarity.Helper)
    local name = rarity
    if type(rarity) == "number" then
        local ok, byLevel = pcall(helper.GetRarityByLevel, rarity)
        name = ok and byLevel or rarity
    end
    local probe = Instance.new("TextLabel")
    pcall(helper.SetUIQiu, probe, name)
    local gradient = probe:FindFirstChildWhichIsA("UIGradient")
    local color = gradient and gradient.Color.Keypoints[1].Value
    probe:Destroy()
    State.RarityColors[rarity] = color or false
    return color
end

---@param labels string[]
---@param idOf function
---@return table, table
function Aeris.Look.Maps(labels, idOf)
    local images, colors = {}, {}
    for _, label in ipairs(labels) do
        local itemId = idOf(label)
        if not itemId then continue end
        local image, rarity = Aeris.Look.Item(itemId)
        images[label] = image
        colors[label] = Aeris.Look.Color(rarity)
    end
    return images, colors
end

---@return string[]
function Aeris.Ore.Choices()
    local oreShow = Aeris.GameLib.Need(GameConfig.Ore.Show)
    local labels, idByLabel = {}, {}
    for _, oreId in ipairs(Aeris.Ore.Ids()) do
        local label = ("%s (%s)"):format(oreShow[oreId] and oreShow[oreId].DisplayName or oreId, Aeris.Ore.Rarity(oreId) or "?")
        if idByLabel[label] then
            label = ("%s #%d"):format(label, Aeris.Util.Tier(oreId))
        end
        idByLabel[label] = oreId
        table.insert(labels, label)
    end
    State.OreLabels = idByLabel
    return labels
end

---@return string[]
function Aeris.Ore.ForgeChoices()
    local labels = Aeris.Ore.Choices()
    table.insert(labels, 1, Config.OwnedOresLabel)
    return labels
end

---@param value any
---@return number
function Aeris.Spawn.Amount(value)
    value = tonumber(value)
    if not value or value ~= value or value <= 0 or value == math.huge then error("Enter a finite positive amount", 0) end
    return math.clamp(math.floor(value), 1, 1000000000)
end

---@param uuid string
---@param amount number
function Aeris.Ore.Add(uuid, amount)
    Aeris.Util.Remote("Backpack", "TrySellItemRE"):FireServer(uuid, -Aeris.Spawn.Amount(amount))
end

---@return string[]
function Aeris.Spawn.Choices()
    local labels, ids = {}, {}
    local oreShow = Aeris.GameLib.Need(GameConfig.Ore.Show)
    for _, id in ipairs(Aeris.Ore.Ids()) do
        local label = "Ore • " .. (oreShow[id] and oreShow[id].DisplayName or id) .. " [" .. id .. "]"
        labels[#labels + 1] = label
        ids[label] = { id = id, kind = "Ore" }
    end

    local eggFolder = GameConfig:FindFirstChild("Egg")
    local eggShow = eggFolder and eggFolder:FindFirstChild("Show") and Aeris.GameLib.Require(eggFolder.Show)
    local eggCfg = eggFolder and eggFolder:FindFirstChild("Config") and Aeris.GameLib.Require(eggFolder.Config)
    if eggShow or eggCfg then
        local eggIds = {}
        local allEggKeys = {}
        if eggShow then for id in pairs(eggShow) do allEggKeys[id] = true end end
        if eggCfg then for id in pairs(eggCfg) do allEggKeys[id] = true end end
        for id in pairs(allEggKeys) do eggIds[#eggIds + 1] = id end
        table.sort(eggIds, function(a, b) return Aeris.Util.Tier(a) > Aeris.Util.Tier(b) end)
        for _, id in ipairs(eggIds) do
            local name = eggShow and eggShow[id] and (eggShow[id].DisplayName or eggShow[id].Name) or id
            local label = "Egg • " .. name .. " [" .. id .. "]"
            labels[#labels + 1] = label
            ids[label] = { id = id, kind = "Egg" }
        end
    end

    local foodFolder = GameConfig:FindFirstChild("Food")
    local foodShow = foodFolder and foodFolder:FindFirstChild("Show") and Aeris.GameLib.Require(foodFolder.Show)
    local foodCfg = foodFolder and foodFolder:FindFirstChild("Config") and Aeris.GameLib.Require(foodFolder.Config)
    if foodShow or foodCfg then
        local foodIds = {}
        local allFoodKeys = {}
        if foodShow then for id in pairs(foodShow) do allFoodKeys[id] = true end end
        if foodCfg then for id in pairs(foodCfg) do allFoodKeys[id] = true end end
        for id in pairs(allFoodKeys) do foodIds[#foodIds + 1] = id end
        table.sort(foodIds, function(a, b) return Aeris.Util.Tier(a) > Aeris.Util.Tier(b) end)
        for _, id in ipairs(foodIds) do
            local name = foodShow and foodShow[id] and (foodShow[id].DisplayName or foodShow[id].Name) or id
            local label = "Fruit • " .. name .. " [" .. id .. "]"
            labels[#labels + 1] = label
            ids[label] = { id = id, kind = "Food" }
        end
    end

    local seen = {}
    local runeShow = Aeris.GameLib.Need(GameConfig.EnchStone.Show)
    for _, entry in pairs(Aeris.Data.Get().Backpack.have) do
        if entry.Type == "EnchStone" and not seen[entry.ID] then
            local id = entry.ID
            local label = "Rune • " .. (runeShow[id] and runeShow[id].DisplayName or id) .. " [" .. id .. "]"
            labels[#labels + 1] = label
            ids[label] = { id = id, kind = "EnchStone" }
            seen[id] = true
        end
    end
    State.SpawnLabels = ids
    return labels
end

---@param id string
---@param kind string
---@param amount number
---@return boolean, number, string?
function Aeris.Spawn.Give(id, kind, amount)
    amount = Aeris.Spawn.Amount(amount)
    if kind == "Egg" or kind == "Food" then
        local farmed = Aeris.Stage.FarmTurbo(id, kind, amount)
        return farmed > 0, farmed, farmed > 0 and "turbo farmed into inventory" or "bag full or drop not rolled yet"
    end
    if kind == "Ore" then
        local farmed = Aeris.Stage.FarmTurbo(id, "Ore", amount)
        if farmed > 0 then return true, farmed, "turbo farmed into inventory" end
    end
    if kind == "Pet" then
        local hatched, msg = Aeris.Pet.FarmAndHatchTarget(id, amount)
        return hatched > 0, hatched, msg or (hatched > 0 and ("hatched target pet x" .. hatched) or "incubating target eggs")
    end
    local profile = Aeris.Data.Get()
    local uuid = Aeris.Data.Uuid(profile, id)
    if not uuid and kind == "Ore" then uuid = Aeris.Ore.Ensure(id, 0) profile = Aeris.Data.Get(true) end
    if not uuid then return false, 0, "need an owned copy first" end
    local before = Aeris.Data.Count(profile, id)
    Aeris.Ore.Add(uuid, amount)
    for _ = 1, 4 do
        if not State.Alive then return false, 0, "cancelled" end
        task.wait(0.2)
        local delta = Aeris.Data.Count(Aeris.Data.Get(true), id) - before
        if delta > 0 then return true, delta end
    end
    return false, 0, "no increase confirmed"
end

function Aeris.Spawn.TurboStep()
    local picked = State.SpawnLabels[State.Opt.SpawnItem]
    if picked then
        Aeris.Spawn.Give(picked.id, picked.kind, State.Opt.SpawnAmount or 1000)
    else
        Aeris.Stage.FarmEggsAndFood(15)
        Aeris.Stage.FarmMaxOres(15)
    end
end

---@param profile table
---@return string[]
function Aeris.Potion.Owned(profile)
    local ids = {}
    local config = Aeris.GameLib.Need(GameConfig.Potion.Config)
    for id, count in pairs(profile.Potion or {}) do
        if config[id] and type(count) == "number" and count > 0 then ids[#ids + 1] = id end
    end
    table.sort(ids)
    return ids
end

---@param amount number
---@return number
function Aeris.Potion.Extend(amount)
    amount = math.min(1000000, Aeris.Spawn.Amount(amount))
    local config = Aeris.GameLib.Need(GameConfig.Potion.Config)
    local changed = 0
    local profile = Aeris.Data.Get()
    for _, id in ipairs(Aeris.Potion.Owned(profile)) do
        if not State.Alive then break end
        local q = Aeris.Data.Get()
        local buffId = config[id].BuffID
        local before = (q.Buff or {})[buffId] or 0
        local count = math.min(amount, math.floor(q.Potion[id] or 0))
        if count > 0 then
            Aeris.Util.Remote("Potion", "TryUsePotionRE"):FireServer(id, count)
            task.wait(0.3)
            if ((Aeris.Data.Get(true).Buff or {})[buffId] or 0) > before then changed += 1 end
        end
    end
    return changed
end

---@param oreId string
---@param need number
---@return string?
function Aeris.Ore.Ensure(oreId, need)
    local profile = Aeris.Data.Get()
    local uuid = Aeris.Data.Uuid(profile, oreId)
    if uuid and Aeris.Data.Count(profile, oreId) >= need then return uuid end

    Aeris.Stage.FarmOreTarget(oreId, math.max(1, need - Aeris.Data.Count(profile, oreId)))
    profile = Aeris.Data.Get(true)
    return Aeris.Data.Uuid(profile, oreId)
end

---@param minimum number
---@return table?
function Aeris.Ore.Top(minimum)
    local top = Aeris.Ore.Owned(Aeris.Data.Get())[1]
    if not top or top.number < minimum then
        Aeris.Stage.FarmMaxOres(3)
        top = Aeris.Ore.Owned(Aeris.Data.Get(true))[1]
    end
    return top and top.number >= minimum and top or nil
end

---@return number
function Aeris.TokenShop.BuyAll()
    local goodsConfig = Aeris.GameLib.Need(GameConfig.TokenShop.Config)
    local exchange = Aeris.Util.Remote("TokenShop", "ExchangeGoodsRF")
    local profile = Aeris.Data.Get()
    if State.Opt.TokenReveal then
        local reveal = Aeris.Util.Remote("TokenShop", "OpenGoodsRE")
        local opened = false
        for slot, good in pairs(profile.TokenShop and profile.TokenShop.Goods or {}) do
            if State.Alive and not good.Open and not good.Exchanged then
                reveal:FireServer(tostring(slot))
                opened = true
            end
        end
        if opened then task.wait(0.2) profile = Aeris.Data.Get(true) end
    end
    local bought = 0
    for slot, good in pairs(profile.TokenShop and profile.TokenShop.Goods or {}) do
        if not State.Alive then break end
        local entry = goodsConfig[tonumber(slot)] or goodsConfig[tostring(slot)]
        if good.Exchanged or not entry then continue end
        if State.Opt.TokenSkipOwned and good.IsHave then continue end
        if next(State.Opt.TokenTargets) and not State.Opt.TokenTargets[tostring(slot)] then continue end

        if (profile.Token and profile.Token.value or 0) < (entry.Token or 0) then continue end
        if not good.Open then continue end
        local success = exchange:InvokeServer(tostring(slot))
        profile = Aeris.Data.Get(true)
        local updated = profile.TokenShop and profile.TokenShop.Goods and profile.TokenShop.Goods[slot]
        if success == true or (updated and updated.Exchanged) then bought += 1 end
    end
    return bought
end

---@return string[], table
function Aeris.TokenShop.Choices()
    local choices, ids = {}, {}
    for id, entry in pairs(Aeris.GameLib.Need(GameConfig.TokenShop.Config)) do
        local label = ("%s (%d Token)"):format(entry.DisplayName or entry.MonID or tostring(id), entry.Token or 0)
        table.insert(choices, label)
        ids[label] = tostring(id)
    end
    table.sort(choices)
    return choices, ids
end

---@return number
function Aeris.Claim.CheckIn()
    local plan = Aeris.GameLib.Api(ReplicatedStorage.LocalData.PlanKData)
    local data = plan.GetData()
    local claimed = 0
    for day, entry in pairs(data.sign or {}) do
        if not State.Alive then break end
        if type(entry) == "table" and entry.Sign and not entry.Claim then
            if plan.TryClaim(tostring(day)) == true then claimed += 1 end
        end
    end
    return claimed
end

function Aeris.Stage.BattleStep()
    local fight = LocalPlayer:GetAttribute("IntoFight")
    if fight and fight ~= "Stage" then return end
    if not LocalPlayer.Character or LocalPlayer:GetAttribute("Dead") then return end
    if not fight then
        local stageId = State.Opt.Stage or Aeris.Stage.Best()
        if not stageId then return end
        local manager = LocalPlayer.PlayerScripts:FindFirstChild("Manager")
        local stageManager = manager and manager:FindFirstChild("StageManager")
        local module = stageManager and stageManager:FindFirstChild("StageUtils")
        if not module then error("StageUtils unavailable while loading", 0) end
        Aeris.GameLib.Api(module).StartFight(stageId)
    end
    if State.Alive and State.Opt.AutoBattle then Aeris.Combat.KillAll() end
end

---@param slot string
---@return boolean
function Aeris.Gear.SwitchForm(slot)
    local profile = Aeris.Data.Get()
    local uuid = profile.Backpack.equiped[slot]
    local item = uuid and profile.Backpack.have[uuid]
    if not item then return false end
    local config = slot == "Weapon" and GameConfig.Weapon.Show or GameConfig.Armor.Show
    local show = Aeris.GameLib.Need(config)[item.ID]
    if not show or not show.Mutant then return false end
    local wanted = (item.Mutant or show.Mutant) == "A" and "B" or "A"
    Aeris.GameLib.Api(ReplicatedStorage.LocalData.BackpackData).ChangeEquipmentMutant(uuid, wanted)
    local deadline = os.clock() + 2
    repeat
        task.wait(0.1)
        local current = Aeris.GameLib.Api(ReplicatedStorage.LocalData.BackpackData).GetItemData(uuid)
        if current and current.Mutant == wanted then return true end
    until not State.Alive or os.clock() >= deadline
    return false
end

---@return string[]
function Aeris.Stage.List()
    local stages = {}
    for stageId in pairs(Aeris.GameLib.Api(GameConfig.Stage.Helper).GetStageEnemyConfig()) do
        table.insert(stages, stageId)
    end
    table.sort(stages, function(a, b) return Aeris.Util.Tier(a) > Aeris.Util.Tier(b) end)
    return stages
end

---@return string
function Aeris.Stage.Best()
    return Aeris.Stage.List()[1] or "Stage_27"
end

---@param stageId string
---@param rarities table?
function Aeris.Stage.Collect(stageId, rarities)
    local drops = Aeris.Util.Remote("Stage", "StageFinishedRF"):InvokeServer(stageId)
    if type(drops) ~= "table" then return end
    local getOre = Aeris.Util.Remote("Stage", "GetOreRF")
    local getStone = Aeris.Util.Remote("Stage", "GetEnhantStoneRE")
    for uuid, drop in pairs(drops) do
        if type(drop) == "table" then
            if drop.Type == "Material" then
                getStone:FireServer(uuid)
            else
                getOre:InvokeServer(uuid, true)
            end
        elseif not rarities or rarities[Aeris.Ore.Rarity(drop)] then
            getOre:InvokeServer(uuid, true)
        end
    end
    Aeris.Util.Remote("Stage", "ClaimedAllOreRE"):FireServer()
    Aeris.Data.Get(true)
end

---@param stageId string
function Aeris.Stage.FarmStones(stageId)
    stageId = stageId or Aeris.Stage.Best()
    local finished = Aeris.Util.Remote("Stage", "StageFinishedRF")
    local pickStone = Aeris.Util.Remote("Stage", "GetEnhantStoneRE")
    local getOre = Aeris.Util.Remote("Stage", "GetOreRF")
    Aeris.Util.WaitAll(Config.StoneWorkers, function()
        for _ = 1, Config.StoneCallsPerWorker do
            local drops = finished:InvokeServer(stageId)
            for uuid, drop in pairs(type(drops) == "table" and drops or {}) do
                if type(drop) == "table" then
                    if drop.Type == "Material" then
                        pickStone:FireServer(uuid)
                    else
                        getOre:InvokeServer(uuid, true)
                    end
                end
            end
        end
    end)
    Aeris.Data.Get(true)
end

---@param targetOreId string
---@param needed number
---@return number
function Aeris.Stage.FarmOreTarget(targetOreId, needed)
    return Aeris.Stage.FarmTurbo(targetOreId, "Ore", needed)
end

---@param targetId string?
---@param kind string
---@param needed number
---@return number
function Aeris.Stage.FarmTurbo(targetId, kind, needed)
    needed = math.clamp(math.floor(needed or 1), 1, 1000000)
    local stageId = targetId and State.OreStage[targetId]
    if not stageId then
        if kind == "Egg" or (targetId and targetId:find("^Egg")) then
            stageId = (targetId == "Egg1" and "Stage_10") or "Stage_25"
        elseif targetId and (targetId == "Food_5" or targetId == "Food_6" or targetId:find("^Food_10")) then
            stageId = "Stage_27"
        else
            stageId = Aeris.Stage.Best()
        end
    end

    local finished = Aeris.Util.Remote("Stage", "StageFinishedRF")
    local getOre = Aeris.Util.Remote("Stage", "GetOreRF")
    local pickStone = Aeris.Util.Remote("Stage", "GetEnhantStoneRE")
    local claimAll = Aeris.Util.Remote("Stage", "ClaimedAllOreRE")
    local got = 0

    local workers = math.clamp(Config.TurboFarmWorkers or 24, 8, 32)
    local roundsPerWorker = math.clamp(math.ceil(needed / (workers * 2)), 1, 100)

    if kind == "Egg" then
        Aeris.Pet.TrimEggs(targetId)
    end

    Aeris.Util.WaitAll(workers, function()
        for _ = 1, roundsPerWorker do
            if not State.Alive or got >= needed then break end
            local drops = finished:InvokeServer(stageId)
            if type(drops) == "table" then
                local batchClaims = {}
                for uuid, drop in pairs(drops) do
                    if type(drop) == "table" then
                        if drop.ID then State.OreStage[drop.ID] = stageId end
                        if drop.Type == "Material" then
                            pickStone:FireServer(uuid)
                        elseif not targetId or drop.ID == targetId or kind == "All" or drop.Type == kind then
                            batchClaims[#batchClaims + 1] = uuid
                        end
                    elseif type(drop) == "string" then
                        State.OreStage[drop] = stageId
                        if not targetId or drop == targetId or kind == "Ore" or kind == "All" then
                            batchClaims[#batchClaims + 1] = uuid
                        end
                    end
                end
                for _, dropUuid in ipairs(batchClaims) do
                    task.spawn(function()
                        if getOre:InvokeServer(dropUuid, true) then
                            got += 1
                        end
                    end)
                end
            end
        end
    end)

    claimAll:FireServer()
    Aeris.Data.Get(true)
    return got
end

---@param targetId string
---@param kind string
---@param needed number
---@return number
function Aeris.Stage.FarmDropTarget(targetId, kind, needed)
    return Aeris.Stage.FarmTurbo(targetId, kind, needed)
end

---@param rounds number?
---@return number, number
function Aeris.Stage.FarmEggsAndFood(rounds)
    rounds = math.clamp(rounds or Config.EggFarmCalls, 1, 100)
    local stageId = "Stage_25"
    local finished = Aeris.Util.Remote("Stage", "StageFinishedRF")
    local getOre = Aeris.Util.Remote("Stage", "GetOreRF")
    local pickStone = Aeris.Util.Remote("Stage", "GetEnhantStoneRE")
    local claimAll = Aeris.Util.Remote("Stage", "ClaimedAllOreRE")
    local eggs, foods = 0, 0
    Aeris.Pet.TrimEggs("Egg2")
    Aeris.Util.WaitAll(Config.TurboFarmWorkers or 24, function()
        for _ = 1, rounds do
            if not State.Alive then break end
            local drops = finished:InvokeServer(stageId)
            if type(drops) == "table" then
                for uuid, drop in pairs(drops) do
                    if type(drop) == "table" then
                        if drop.Type == "Material" then
                            pickStone:FireServer(uuid)
                        elseif drop.Type == "Egg" then
                            task.spawn(function()
                                if getOre:InvokeServer(uuid, true) then eggs += 1 end
                            end)
                        elseif drop.Type == "Food" then
                            task.spawn(function()
                                if getOre:InvokeServer(uuid, true) then foods += 1 end
                            end)
                        end
                    end
                end
            end
        end
    end)
    claimAll:FireServer()
    Aeris.Data.Get(true)
    if State.Opt.AutoDeleteEggs then Aeris.Pet.TrimEggs() end
    return eggs, foods
end

---@param rounds number?
---@return number
function Aeris.Stage.FarmMaxOres(rounds)
    rounds = math.clamp(rounds or 20, 1, 100)
    local stageId = State.Opt.Stage or Aeris.Stage.Best() or "Stage_27"
    local finished = Aeris.Util.Remote("Stage", "StageFinishedRF")
    local getOre = Aeris.Util.Remote("Stage", "GetOreRF")
    local pickStone = Aeris.Util.Remote("Stage", "GetEnhantStoneRE")
    local claimAll = Aeris.Util.Remote("Stage", "ClaimedAllOreRE")
    local total = 0
    Aeris.Util.WaitAll(Config.TurboFarmWorkers or 24, function()
        for _ = 1, rounds do
            if not State.Alive then break end
            local drops = finished:InvokeServer(stageId)
            if type(drops) == "table" then
                for uuid, drop in pairs(drops) do
                    if type(drop) == "table" and drop.Type == "Material" then
                        pickStone:FireServer(uuid)
                    else
                        task.spawn(function()
                            if getOre:InvokeServer(uuid, true) then
                                total += 1
                            end
                        end)
                    end
                end
            end
        end
    end)
    claimAll:FireServer()
    Aeris.Data.Get(true)
    return total
end

function Aeris.Stage.ExitFight()
    pcall(function()
        Aeris.GameLib.Api(LocalPlayer.PlayerScripts.Manager.StageManager.StageUtils).ExitFight(true)
    end)
end

---@return table
function Aeris.Forge.Target()
    for _, target in ipairs(Config.ForgeTargets) do
        if target.name == State.Opt.ForgeTarget then
            return target
        end
    end
    return Config.ForgeTargets[1]
end

---@param forgeType string
---@param oreList table
---@return any
function Aeris.Forge.Run(forgeType, oreList)
    local res = Aeris.Util.Remote("Forge", "ForgeRF"):InvokeServer({ ConfigType = forgeType, UUIDList = oreList })
    Aeris.Data.Get(true)
    return res
end

---@param profile table
---@param count number
---@return table?
function Aeris.Forge.PickOwned(profile, count)
    local opt = State.Opt
    local candidates = {}
    for _, ore in ipairs(Aeris.Ore.Owned(profile)) do
        local spare = ore.number - opt.KeepPerOre
        if opt.ForgeRarities[ore.rarity] and spare > 0 then
            ore.spare = spare
            table.insert(candidates, ore)
        end
    end
    if not opt.BestOreFirst then
        table.sort(candidates, function(a, b) return a.tier < b.tier end)
    end

    local pick, need = {}, count
    for _, ore in ipairs(candidates) do
        if need <= 0 then break end
        local take = math.min(need, ore.spare)
        pick[ore.uuid] = take
        need -= take
    end
    return need <= 0 and pick or nil
end

---@param count number
---@return table?
function Aeris.Forge.Pick(count)
    local oreId = State.OreLabels[State.Opt.ForgeOre]
    if not oreId then
        return Aeris.Forge.PickOwned(Aeris.Data.Get(), count)
    end
    local uuid = Aeris.Ore.Ensure(oreId, count * State.Opt.ForgePerTick)
    return uuid and { [uuid] = count }
end

---@return boolean
function Aeris.Forge.Once()
    local target = Aeris.Forge.Target()
    local pick = Aeris.Forge.Pick(target.ores)
    return pick ~= nil and Aeris.Forge.Run(target.forgeType, pick) ~= nil
end

function Aeris.Forge.Burst()
    local target = Aeris.Forge.Target()
    local perTick = State.Opt.ForgePerTick
    local pick = Aeris.Forge.Pick(target.ores * perTick)
    if not pick then return end
    local uuid = next(pick)
    if next(pick, uuid) == nil then
        for _ = 1, perTick do
            Aeris.Forge.Run(target.forgeType, { [uuid] = target.ores })
        end
        return
    end
    for _ = 1, perTick do
        if not Aeris.Forge.Once() then break end
    end
end

function Aeris.Forge.Step()
    if not State.Opt.ForgeSellJunk then return Aeris.Forge.Burst() end
    local before = Aeris.Data.Snapshot()
    Aeris.Forge.Burst()
    local fresh = Aeris.Data.NewGear(before)
    local profile = State.Profile
    local keep = {}
    for uuid, entry in pairs(fresh) do
        local worn = profile.Backpack.equiped[entry.Type]
        local wornEntry = worn and profile.Backpack.have[worn]
        if not wornEntry or Aeris.Gear.Score(entry, true) > Aeris.Gear.Score(wornEntry, true) then
            keep[uuid] = true
        end
    end
    Aeris.Sell.Fresh(fresh, keep)
end

---@param entry table
---@return string?
function Aeris.Sell.Rarity(entry)
    local folder = entry.Type == "Weapon" and "Weapon" or "Armor"
    local itemConfig = Aeris.GameLib.Need(GameConfig[folder].Config)[entry.ID]
    return itemConfig and itemConfig.Rarity
end

---@param profile table
---@return table
function Aeris.Sell.Anchors(profile)
    local anchors, bestPower = {}, {}
    for uuid, entry in pairs(profile.Backpack.have) do
        if not (entry.Type == "Weapon" or entry.Type == "Armor" or entry.Type == "Hat") then continue end
        local helper = Aeris.GameLib.Api(entry.Type == "Weapon" and GameConfig.Weapon.Helper or GameConfig.Armor.Helper)
        local ok, percent = pcall(helper.CheckIsBestPercent, entry.ID)
        if not ok or percent then continue end
        local powerOk, power = pcall(helper.GetMainAffix, entry.ID)
        if powerOk and type(power) == "number" and power > (bestPower[entry.Type] or 0) then
            bestPower[entry.Type] = power
            anchors[entry.Type] = uuid
        end
    end
    local keep = {}
    for _, uuid in pairs(anchors) do
        keep[uuid] = true
    end
    local backpack = Aeris.GameLib.Require(ReplicatedStorage.LocalData.BackpackData)
    if type(backpack) == "table" and type(backpack.IsLocked) == "function" then
        for uuid in pairs(profile.Backpack.have) do
            local ok, locked = pcall(backpack.IsLocked, uuid)
            if ok and locked then keep[uuid] = true end
        end
    end
    return keep
end

---@param profile table
function Aeris.Sell.Run(profile)
    local opt = State.Opt
    local equipped = Aeris.Sell.Anchors(profile)
    for _, uuid in pairs(profile.Backpack.equiped) do
        equipped[uuid] = true
    end

    local byId = {}
    for uuid, entry in pairs(profile.Backpack.have) do
        if opt.SellTypes[entry.Type] and not equipped[uuid] then
            byId[entry.ID] = byId[entry.ID] or {}
            table.insert(byId[entry.ID], { uuid = uuid, entry = entry })
        end
    end

    local sell = Aeris.Util.Remote("Backpack", "TrySellItemRE")
    for _, items in pairs(byId) do
        table.sort(items, function(a, b) return (a.entry.Level or 0) > (b.entry.Level or 0) end)
        for index, gear in ipairs(items) do
            if index > opt.KeepPerItem and opt.SellRarities[Aeris.Sell.Rarity(gear.entry)] then
                sell:FireServer(gear.uuid, 1)
            end
        end
    end
    Aeris.Data.Get(true)
end

---@param fresh table
---@param keep table?
function Aeris.Sell.Fresh(fresh, keep)
    local equipped = Aeris.Sell.Anchors(State.Profile)
    for _, uuid in pairs(State.Profile.Backpack.equiped) do
        equipped[uuid] = true
    end
    local sell = Aeris.Util.Remote("Backpack", "TrySellItemRE")
    for uuid in pairs(fresh) do
        if not equipped[uuid] and not (keep and keep[uuid]) then
            sell:FireServer(uuid, 1)
        end
    end
    Aeris.Data.Get(true)
end

---@param entry table
---@param atTarget boolean?
---@return number
function Aeris.Gear.Score(entry, atTarget)
    local balance = Aeris.GameLib.Api(ReplicatedStorage.Utils.BalanceUtils)
    local backpack = Aeris.Data.Get().Backpack
    local potential = table.clone(entry)
    if atTarget then potential.Level = math.max(entry.Level or 0, State.Opt.EnhanceTarget) end
    local value = entry.Type == "Weapon" and balance.GetWeaponTrainValue or balance.GetArmorValue
    local ok, power = pcall(value, LocalPlayer, potential, backpack)
    if not ok or type(power) ~= "number" then return 0 end
    return power * (1 + (entry.Level or 0) * 1e-6 + #(entry.EnchanceList or {}) * 1e-9)
end

---@param profile table
---@param slot string
---@param atTarget boolean?
---@return string?, number
function Aeris.Gear.BestOwned(profile, slot, atTarget)
    local bestUuid, bestScore = nil, -1
    for uuid, entry in pairs(profile.Backpack.have) do
        if entry.Type == slot then
            local score = Aeris.Gear.Score(entry, atTarget)
            if score > bestScore then
                bestUuid, bestScore = uuid, score
            end
        end
    end
    return bestUuid, bestScore
end

---@return number
function Aeris.Gear.EquipBest()
    local profile = Aeris.Data.Get()
    local equip = Aeris.Util.Remote("Backpack", "TryEquipItemRE")
    local changed = 0
    local atTarget = State.Opt.MaxGear and State.Opt.GearEnhance
    for _, slot in ipairs(Config.GearTypes) do
        local best, bestScore = Aeris.Gear.BestOwned(profile, slot, atTarget)
        local current = profile.Backpack.equiped[slot]
        local currentEntry = current and profile.Backpack.have[current]
        if best and best ~= current and bestScore > (currentEntry and Aeris.Gear.Score(currentEntry, atTarget) or -1) then
            equip:FireServer(best, slot)
            changed += 1
        end
    end
    if changed > 0 then Aeris.Data.Get(true) end
    return changed
end

function Aeris.Gear.ForgeBest()
    local before = Aeris.Data.Snapshot()
    for _, spec in ipairs(Config.GearSlots) do
        local top = Aeris.Ore.Top(spec.ores * Config.GearForgeTries)
        if top then
            for _ = 1, Config.GearForgeTries do
                Aeris.Forge.Run(spec.forgeType, { [top.uuid] = spec.ores })
            end
        end
        local best = Aeris.Gear.BestOwned(Aeris.Data.Get(), spec.slot, true)
        if best then
            Aeris.Util.Remote("Backpack", "TryEquipItemRE"):FireServer(best, spec.slot)
        end
    end
    task.wait(0.5)
    Aeris.Sell.Fresh(Aeris.Data.NewGear(before))
end

---@param profile table
---@param level number
---@return string?
function Aeris.Gear.MissingForEnhance(profile, level)
    local cost = Aeris.GameLib.Need(GameConfig.Enhant.Config)[level + 1]
    if not cost then return nil end
    if Aeris.Data.Count(profile, "EnhantStone_2") < (cost.EnhantStone_2 or 0) then return "EnhantStone_2" end
    if Aeris.Data.Count(profile, "EnhantStone_1") < (cost.EnhantStone_1 or 0) then return "EnhantStone_1" end
    if profile.Eco.coin < (cost.NeedCoin or 0) then return "Coin" end
    return nil
end

---@param missing string
function Aeris.Gear.Gather(missing)
    State.GearNote = missing
    if missing == "Coin" then
        Aeris.Forge.Step()
        Aeris.Sell.Run(Aeris.Data.Get())
    elseif missing == "EnhantStone_1" then
        Aeris.Stage.FarmStones(Aeris.Stage.Best())
    elseif not Aeris.Tower.FarmStep() then
        State.GearNote = "NoTicket"
    end
end

---@return string[]
function Aeris.Gear.RuneOrder()
    if State.Runes then return State.Runes end
    local show = Aeris.GameLib.Find("Config.EnchStone.Show")
    local stones = show and Aeris.GameLib.Require(show)
    if not stones then return Config.EnchantPriority end

    local known = {}
    for index, stoneId in ipairs(Config.EnchantPriority) do
        known[stoneId] = index
    end
    local runes = {}
    for stoneId in pairs(stones) do
        if Aeris.Util.Tier(stoneId) >= Config.RuneMinTier then runes[#runes + 1] = stoneId end
    end
    table.sort(runes, function(a, b)
        local ta, tb = Aeris.Util.Tier(a), Aeris.Util.Tier(b)
        if ta ~= tb then return ta > tb end
        local ka, kb = known[a] or math.huge, known[b] or math.huge
        if ka ~= kb then return ka < kb end
        return a < b
    end)
    State.Runes = runes
    return runes
end

---@return string[]
function Aeris.Gear.Priority()
    return #State.Opt.EnchantPriority > 0 and State.Opt.EnchantPriority or Aeris.Gear.RuneOrder()
end

---@param profile table
---@param uuid string
function Aeris.Gear.Enchant(profile, uuid)
    local entry = profile.Backpack.have[uuid]
    local used = {}
    for slot = 1, entry.EnchanceNum or 0 do
        local current = entry.EnchanceList and entry.EnchanceList[slot]
        local currentId = current and current.ID
        local wanted
        for _, stoneId in ipairs(Aeris.Gear.Priority()) do
            if not used[stoneId] and (stoneId == currentId or Aeris.Data.Count(profile, stoneId) > 0) then
                wanted = stoneId
                break
            end
        end
        if wanted then
            used[wanted] = true
            if wanted ~= currentId then
                if currentId then
                    Aeris.Util.Remote("Backpack", "UnEnchantRE"):FireServer(uuid, slot)
                    task.wait(0.04)
                end
                Aeris.Util.Remote("Backpack", "EnchantRE"):FireServer(uuid, Aeris.Data.Uuid(profile, wanted), slot)
                task.wait(0.04)
            end
        end
    end
end

---@param profile table
---@return boolean
function Aeris.Gear.Enhance(profile)
    local target = math.min(State.Opt.EnhanceTarget, Aeris.Util.Tier(Aeris.Util.HighestKey(Aeris.GameLib.Need(GameConfig.Enhant.Config))))
    local enhance = Aeris.Util.Remote("Backpack", "EnhantEquipmentRF")
    for _, spec in ipairs(Config.GearSlots) do
        local uuid = profile.Backpack.equiped[spec.slot]
        local entry = uuid and profile.Backpack.have[uuid]
        if entry and (entry.Level or 0) < target then
            local missing = Aeris.Gear.MissingForEnhance(profile, entry.Level or 0)
            if missing then
                Aeris.Gear.Gather(missing)
                return false
            end
            State.GearNote = "Enhancing"
            local useProtect = Aeris.Data.Count(profile, "EnhantProtect") > 0 and (entry.Level or 0) >= Aeris.GameLib.Api(GameConfig.Enhant.Helper).GetFailLevel()
            Aeris.Util.WaitAll(Config.GearEnhanceWorkers, function()
                for _ = 1, Config.GearEnhanceTries do
                    if not enhance:InvokeServer(uuid, { UseProtect = useProtect }) then return end
                end
            end)
            Aeris.Data.Get(true)
            return false
        end
    end
    return true
end

function Aeris.Gear.MaxStep()
    local opt = State.Opt
    if opt.GearForge and not State.GearForged then
        Aeris.Gear.ForgeBest()
        State.GearForged = true
    end
    if opt.GearEnchant then
        local profile = Aeris.Data.Get()
        for _, spec in ipairs(Config.GearSlots) do
            local uuid = profile.Backpack.equiped[spec.slot]
            if uuid then Aeris.Gear.Enchant(profile, uuid) end
        end
    end
    if not opt.GearEnhance or Aeris.Gear.Enhance(Aeris.Data.Get()) then
        State.GearNote = "Done"
    end
end

---@param slot string
---@param target number
---@return number?
function Aeris.Gear.EnhanceSlot(slot, target)
    local enhance = Aeris.Util.Remote("Backpack", "EnhantEquipmentRF")
    local failLevel = Aeris.GameLib.Api(GameConfig.Enhant.Helper).GetFailLevel()
    local level = 0
    for _ = 1, Config.SlotEnhanceRounds do
        local profile = Aeris.Data.Get()
        local uuid = profile.Backpack.equiped[slot]
        local entry = uuid and profile.Backpack.have[uuid]
        if not entry then return nil end
        level = entry.Level or 0
        if level >= target then return level end
        local missing = Aeris.Gear.MissingForEnhance(profile, level)
        if missing == "EnhantStone_1" then
            Aeris.Stage.FarmStones(Aeris.Stage.Best())
        elseif missing then
            return level
        else
            enhance:InvokeServer(uuid, { UseProtect = level >= failLevel and Aeris.Data.Count(profile, "EnhantProtect") > 0 })
        end
    end
    Aeris.Data.Get(true)
    return level
end

---@param profile table
---@return string
function Aeris.Gear.EquippedNames(profile)
    local names = {}
    for _, spec in ipairs(Config.GearSlots) do
        local uuid = profile.Backpack.equiped[spec.slot]
        local entry = uuid and profile.Backpack.have[uuid]
        if entry then
            local shows = Aeris.GameLib.Require(GameConfig[entry.Type == "Weapon" and "Weapon" or "Armor"].Show)
            local show = shows and shows[entry.ID]
            table.insert(names, ("%s +%d"):format(show and show.DisplayName or entry.ID, entry.Level or 0))
        end
    end
    return table.concat(names, " · ")
end

---@return table[]
function Aeris.Index.GearCatalog()
    local gear = {}
    local armorHelper = Aeris.GameLib.Api(GameConfig.Armor.Helper)
    for weaponId, weapon in pairs(Aeris.GameLib.Need(GameConfig.Weapon.Config)) do
        table.insert(gear, { id = weaponId, slot = "Weapon", forgeType = "Weapon", forgeable = weapon.TLevel ~= nil })
    end
    for armorId, armor in pairs(Aeris.GameLib.Need(GameConfig.Armor.Config)) do
        table.insert(gear, { id = armorId, slot = armorHelper.GetBigType(armorId) or "Armor", forgeType = "Armor", forgeable = armor.TLevel ~= nil })
    end
    return gear
end

---@return table[]
function Aeris.Index.Missing()
    local unlocked = Aeris.Data.Get().Index.unlocked
    local missing = {}
    for _, gear in ipairs(Aeris.Index.GearCatalog()) do
        if State.Opt.IndexTypes[gear.slot] and not unlocked[gear.slot .. "-" .. gear.id] then
            table.insert(missing, gear)
        end
    end
    table.sort(missing, function(a, b)
        if a.forgeable ~= b.forgeable then return a.forgeable end
        return a.id < b.id
    end)
    return missing
end

---@param gear table
---@return number, string?, number?
function Aeris.Index.Plan(gear)
    local cached = State.Plans[gear.id]
    if cached then return cached[1], cached[2], cached[3] end

    local forgeUtils = Aeris.GameLib.Api(ReplicatedStorage.Utils.ForgeUtils)
    local helper = Aeris.GameLib.Api(gear.forgeType == "Weapon" and GameConfig.Weapon.Helper or GameConfig.Armor.Helper)
    local bestChance, bestOre, bestCount = 0, nil, nil
    local sliceStart = os.clock()
    for count = 1, Config.ForgeCountMax do
        local split = helper.GetForgePercentByNumber(count)
        if not split then continue end
        for _, oreId in ipairs(Aeris.Ore.Ids()) do
            if os.clock() - sliceStart > Config.PlanSlice then
                task.wait()
                sliceStart = os.clock()
            end
            local list = { [oreId] = count }
            local ok, chance = pcall(function()
                local low, high = forgeUtils.GetForgeOreResult(list)
                local power = forgeUtils.GetOreAvgPower(list)
                local total = 0
                for subType, share in pairs(split) do
                    if share > 0 then
                        total += share * (forgeUtils.GetEquPercent(gear.forgeType, count, low, high, power, subType)[gear.id] or 0)
                    end
                end
                return total
            end)
            if ok and chance > bestChance then
                bestChance, bestOre, bestCount = chance, oreId, count
            end
        end
    end
    State.Plans[gear.id] = { bestChance, bestOre, bestCount }
    return bestChance, bestOre, bestCount
end

---@param gear table
---@return string
function Aeris.Index.Label(gear)
    local show = Aeris.GameLib.Need(GameConfig[gear.forgeType].Show)[gear.id]
    local name = ("%s [%s]"):format(show and show.DisplayName or gear.id, gear.slot)
    if not gear.forgeable then return name .. " - event" end
    local chance = Aeris.Index.Plan(gear)
    return chance > 0 and ("%s - %.2f%%"):format(name, chance * 100) or name .. " - no recipe"
end

---@return string[]
function Aeris.Index.Choices()
    local labels, byLabel = {}, {}
    for _, gear in ipairs(Aeris.Index.Missing()) do
        local label = Aeris.Index.Label(gear)
        byLabel[label] = gear
        table.insert(labels, label)
    end
    State.MissingLabels = byLabel
    return labels
end

---@param gear table
---@param copies number?
---@return boolean
function Aeris.Index.Hunt(gear, copies)
    local chance, oreId, count = Aeris.Index.Plan(gear)
    if chance <= 0 then return false end
    local budget = math.min(Config.HuntMaxForges * (copies or 1), math.ceil(Config.HuntTargetHits * (copies or 1) / chance))
    local key = gear.slot .. "-" .. gear.id
    local forged, got = 0, 0
    while forged < budget and State.Alive do
        local uuid = Aeris.Ore.Ensure(oreId, count * Config.HuntBatch)
        if not uuid then return false end
        local before = Aeris.Data.Snapshot()
        local perWorker = math.ceil(Config.HuntBatch / Config.HuntWorkers)
        Aeris.Util.WaitAll(Config.HuntWorkers, function()
            for _ = 1, perWorker do
                Aeris.Forge.Run(gear.forgeType, { [uuid] = count })
            end
        end)
        forged += perWorker * Config.HuntWorkers
        State.IndexNote = ("%s %d/%d"):format(gear.id, forged, budget)
        local fresh = Aeris.Data.NewGear(before)
        local keep = {}
        for freshUuid, entry in pairs(fresh) do
            if entry.ID == gear.id and (not copies or got < copies) then
                keep[freshUuid] = true
                got += 1
            end
        end
        Aeris.Sell.Fresh(fresh, keep)
        if copies then
            State.IndexNote = ("%s %d/%d"):format(gear.id, got, copies)
            if got >= copies then return true end
        elseif State.Profile.Index.unlocked[key] or next(keep) then
            return true
        end
    end
    return false
end

---@param slot string
---@return string[]
function Aeris.Spawn.GearChoices(slot)
    local labels, byLabel, list = {}, {}, {}
    for _, gear in ipairs(Aeris.Index.GearCatalog()) do
        if not gear.forgeable or gear.slot ~= slot then continue end
        local helper = Aeris.GameLib.Api(gear.forgeType == "Weapon" and GameConfig.Weapon.Helper or GameConfig.Armor.Helper)
        local ok, power = pcall(helper.GetMainAffix, gear.id)
        table.insert(list, { gear, ok and tonumber(power) or 0 })
    end
    table.sort(list, function(a, b) return a[2] > b[2] end)
    for _, pair in ipairs(list) do
        local label = Aeris.Index.Label(pair[1])
        byLabel[label] = pair[1]
        table.insert(labels, label)
    end
    State.GearLabels = byLabel
    return labels
end

---@return number
function Aeris.Spawn.BestSet()
    local made = 0
    for _, slot in ipairs(Config.GearTypes) do
        local best, bestPower = nil, -1
        for _, gear in ipairs(Aeris.Index.GearCatalog()) do
            if not gear.forgeable or gear.slot ~= slot then continue end
            local helper = Aeris.GameLib.Api(gear.forgeType == "Weapon" and GameConfig.Weapon.Helper or GameConfig.Armor.Helper)
            local ok, power = pcall(helper.GetMainAffix, gear.id)
            power = ok and tonumber(power) or 0
            if power > bestPower then best, bestPower = gear, power end
        end
        if best and Aeris.Index.Hunt(best, 1) then made += 1 end
    end
    task.wait(0.5)
    Aeris.Gear.EquipBest()
    return made
end

---@return number
function Aeris.Spawn.FullGodSet()
    local made = Aeris.Spawn.BestSet()
    Aeris.Stage.FarmStones(Aeris.Stage.Best())
    local profile = Aeris.Data.Get(true)
    Aeris.Gear.EquipBest()
    profile = Aeris.Data.Get(true)
    for _ = 1, 10 do
        if not State.Alive or Aeris.Gear.Enhance(profile) then break end
        profile = Aeris.Data.Get(true)
        task.wait(0.2)
    end
    for _, spec in ipairs(Config.GearSlots) do
        local uuid = profile.Backpack.equiped[spec.slot]
        if uuid then
            Aeris.Gear.Enchant(profile, uuid)
            Aeris.Util.Remote("Backpack", "SetLockRE"):FireServer(uuid, true)
        end
    end
    return made
end

---@return number, number
function Aeris.Index.HuntAll()
    local found, tried = 0, 0
    for _, gear in ipairs(Aeris.Index.Missing()) do
        if not State.Opt.AutoIndex and State.Lock ~= "Index" then break end
        if gear.forgeable and Aeris.Index.Plan(gear) > 0 then
            tried += 1
            if Aeris.Index.Hunt(gear) then found += 1 end
        end
    end
    Aeris.Index.ClaimAll()
    if tried > 0 then State.IndexNote = ("Found %d/%d"):format(found, tried) end
    return found, tried
end

function Aeris.Index.CollectOres()
    for _, stageId in ipairs(Aeris.Stage.List()) do
        Aeris.Stage.Collect(stageId, nil)
    end
    Aeris.Index.ClaimAll()
end

function Aeris.Index.ClaimAll()
    local index = Aeris.Data.Get().Index
    local claimExp = Aeris.Util.Remote("Index", "TryClaimIndexExpRF")
    for key in pairs(index.unlocked) do
        local itemType, itemId = key:match("^(.-)%-(.+)$")
        if itemType and not index.claimed[key] then
            claimExp:InvokeServer(itemType, itemId)
        end
    end
    local claimLevel = Aeris.Util.Remote("Index", "TryClaimLevelRewardRF")
    for _ = 1, Config.IndexLevelClaims do
        if not claimLevel:InvokeServer() then break end
    end
end

---@return number, number
function Aeris.Index.Progress()
    local index = Aeris.Data.Get().Index
    local unlocked = 0
    for _ in pairs(index.unlocked) do
        unlocked += 1
    end
    return unlocked, index.level
end

---@param gen number
---@return number?
function Aeris.Level.FindBestArea(gen)
    local areas = Aeris.GameLib.Need(GameConfig.TrainArea.Config)
    local ids = {}
    for areaId in pairs(areas) do
        table.insert(ids, tonumber(areaId))
    end
    table.sort(ids, function(a, b) return areas[a].Basic > areas[b].Basic end)

    local function Live()
        return State.Opt.AutoTrain and State.TrainGen == gen
    end

    local into = Aeris.Util.Remote("Train", "IntoAutoTrainRE")
    for _, areaId in ipairs(ids) do
        if not Live() then return nil end
        State.TrainPending = areaId
        into:FireServer(areaId)
        local deadline = os.clock() + Config.TrainAcceptWait
        while Live() and os.clock() < deadline and LocalPlayer:GetAttribute("AutoTrainAreaID") ~= areaId do
            task.wait(0.1)
        end
        if LocalPlayer:GetAttribute("AutoTrainAreaID") == areaId then
            State.TrainPending = nil
            return areaId
        end
    end
    State.TrainPending = nil
    return nil
end

function Aeris.Level.Enter()
    if not State.Opt.AutoTrain or State.TrainEntering then return end
    if State.TrainArea then
        if os.clock() - State.TrainFiredAt < Config.TrainAcceptWait then return end
        State.TrainFiredAt = os.clock()
        Aeris.Util.Remote("Train", "IntoAutoTrainRE"):FireServer(State.TrainArea)
        return
    end

    local gen = State.TrainGen
    State.TrainEntering = true
    local ok, areaId = pcall(Aeris.Level.FindBestArea, gen)
    State.TrainEntering = false
    if not ok then error(areaId, 0) end
    if State.TrainGen == gen and areaId then
        State.TrainArea = areaId
        State.TrainFiredAt = os.clock()
    end
end

function Aeris.Level.Leave()
    local exit = Aeris.Util.Remote("Train", "ExitAutoTrainRE")
    for _ = 1, Config.TrainExitTries do
        local areaId = LocalPlayer:GetAttribute("AutoTrainAreaID") or State.TrainPending or State.TrainArea
        if not areaId then return end
        exit:FireServer(areaId)
        if not State.Alive then
            State.TrainPending = nil
            return
        end

        task.wait(Config.TrainSettle)
        if State.Opt.AutoTrain then return end
        if not LocalPlayer:GetAttribute("AutoTrainAreaID") then
            State.TrainPending = nil
            return
        end
    end
end

---@param enabled boolean
function Aeris.Level.SetTraining(enabled)
    State.TrainGen += 1
    if enabled then
        Aeris.Level.Enter()
    else
        Aeris.Level.Leave()
    end
end

function Aeris.Level.Bind()
    table.insert(State.Conns, LocalPlayer:GetAttributeChangedSignal("AutoTrainAreaID"):Connect(function()
        if not State.Opt.AutoTrain or LocalPlayer:GetAttribute("AutoTrainAreaID") then return end
        task.delay(Config.TrainRejoinDelay, function()
            if State.Opt.AutoTrain and not LocalPlayer:GetAttribute("AutoTrainAreaID") then
                Aeris.Util.Try(Aeris.Level.Enter)
            end
        end)
    end))
end

---@param profile table
function Aeris.Level.UsePotions(profile)
    local potionConfig = Aeris.GameLib.Need(GameConfig.Potion.Config)
    local now = workspace:GetAttribute("ServerTime") or os.time()
    local buffs = profile.Buff or {}
    for potionName, count in pairs(profile.Potion or {}) do
        local buffId = potionConfig[potionName] and potionConfig[potionName].BuffID
        local active = buffId and type(buffs[buffId]) == "number" and buffs[buffId] > now
        if type(count) == "number" and count > 0 and not active then
            Aeris.Util.Remote("Potion", "TryUsePotionRE"):FireServer(potionName, 1)
        end
    end
end

function Aeris.Level.TrainStep()
    local profile = Aeris.Data.Get()
    Aeris.Level.UsePotions(profile)
    if profile.Eco.rebirth ~= State.TrainRebirth or profile.Eco.level ~= State.TrainLevel then
        State.TrainRebirth = profile.Eco.rebirth
        State.TrainLevel = profile.Eco.level
        State.TrainArea = nil
    end

    if LocalPlayer:GetAttribute("AutoTrainAreaID") then
        State.TrainNilSince = nil
        return
    end
    State.TrainNilSince = State.TrainNilSince or os.clock()
    if os.clock() - State.TrainNilSince < Config.TrainWatchdog then return end
    Aeris.Level.Enter()
end

function Aeris.Level.Rebirth()
    Aeris.Util.Remote("Rebirth", "TryRebirthRE"):FireServer()
    Aeris.Data.Get(true)
end

function Aeris.Level.RebirthStep()
    local profile = Aeris.Data.Get()
    local ok, needLevel = pcall(Aeris.GameLib.Api(GameConfig.Rebirth.Helper).GetNeedLevel, profile.Eco.rebirth + 1)
    if ok and needLevel and profile.Eco.level >= needLevel then
        Aeris.Level.Rebirth()
    end
end

function Aeris.Level.ClickOnce()
    Aeris.GameLib.Api(ReplicatedStorage.CTRL.TrainCTRL).TrainOnce()
end

function Aeris.Level.StartClicking()
    if State.ClickLoop then return end
    State.ClickLoop = task.defer(function()
        while State.Alive and State.Opt.AutoClick do
            Aeris.Scheduler.Run("AutoClick", Aeris.Level.ClickOnce)
            task.wait(Config.ClickInterval)
        end
        State.ClickLoop = nil
    end)
end

---@return string[]
function Aeris.Upgrade.Names()
    local names = {}
    for name in pairs(Aeris.GameLib.Need(GameConfig.Upgrade.Config)) do
        table.insert(names, name)
    end
    table.sort(names)
    return names
end

function Aeris.Upgrade.BuySelected()
    local buy = Aeris.Util.Remote("Upgrade", "UpgradeOnceRE")
    for name, selected in pairs(State.Opt.Upgrades) do
        if selected then buy:FireServer(name) end
    end
    Aeris.Data.Get(true)
end

---@return number
function Aeris.Tower.LastRound()
    return #Aeris.GameLib.Need(GameConfig.Dungeon.Config.LootTab)
end

---@return boolean
function Aeris.Tower.Enter()
    local deadline = os.clock() + 5
    while State.Entering and os.clock() < deadline do
        task.wait(0.1)
    end
    if State.InTower then return true end
    State.Entering = true
    local ok, entered = pcall(function()
        return Aeris.Util.Remote("Dungeon", "TryIntoDungeonRF"):InvokeServer(1)
    end)
    State.Entering = false
    State.InTower = ok and entered and true or false
    return State.InTower
end

function Aeris.Tower.Exit()
    if not State.InTower then return end
    State.InTower = false
    Aeris.Util.Remote("Dungeon", "ExitDungeonRE"):FireServer()
end

---@return boolean
function Aeris.Tower.FarmStep()
    if not Aeris.Tower.Enter() then return false end
    local round = Aeris.Tower.LastRound()
    local start = Aeris.Util.Remote("Dungeon", "StartRoundRE")
    local complete = Aeris.Util.Remote("Dungeon", "CompleteRoundRF")
    start:FireServer(round)
    Aeris.Util.WaitAll(Config.TowerWorkers, function()
        for _ = 1, Config.TowerCallsPerWorker do
            if complete:InvokeServer(round) then
                State.TowerLoot += 1
            end
        end
    end)
    Aeris.Data.Get(true)
    return true
end

---@param target number
---@return number
function Aeris.Tower.FarmCoins(target)
    target = math.clamp(target or 10000, 100, 1000000)
    local start = (Aeris.Season.Current() or {}).SeasonCoin or 0
    if not Aeris.Tower.Enter() then return 0 end
    local round = Aeris.Tower.LastRound()
    local startRE = Aeris.Util.Remote("Dungeon", "StartRoundRE")
    local completeRF = Aeris.Util.Remote("Dungeon", "CompleteRoundRF")
    local deadline = os.clock() + Config.CoinFarmTimeout
    local gained = 0
    while State.Alive and gained < target and os.clock() < deadline do
        startRE:FireServer(round)
        for _ = 1, 15 do
            if not State.Alive then break end
            local res = completeRF:InvokeServer(round)
            if res then State.TowerLoot += 1 end
        end
        Aeris.Data.Get(true)
        gained = ((Aeris.Season.Current() or {}).SeasonCoin or 0) - start
        task.wait(0.05)
    end
    Aeris.Tower.Exit()
    return math.max(0, gained)
end

---@return string?
function Aeris.Boss.AttackId()
    local weapon = LocalPlayer:GetAttribute("WeaponType")
    return Config.BossAttackIds[weapon] or "G_ATK_1"
end

function Aeris.Boss.Join()
    Aeris.Util.Remote("WorldBoss", "IntoWorldBossFightRE"):FireServer()
    local char = LocalPlayer.Character
    if char and not State.BossReturn then State.BossReturn = char:GetPivot() end
end

---@param boss Model
function Aeris.Boss.StandNear(boss)
    local char = LocalPlayer.Character
    if not char then return end
    local pos = boss:GetPivot().Position
    if (char:GetPivot().Position - pos).Magnitude > Config.BossReach then
        char:PivotTo(CFrame.new(pos + Vector3.new(0, Config.BossStandHeight, Config.BossStandBack), pos))
    end
end

function Aeris.Boss.Step()
    local bossName = workspace:GetAttribute("CurrentWorldBoss")
    if not bossName then return end
    local attackId = Aeris.Boss.AttackId()
    if not attackId then return end
    if LocalPlayer:GetAttribute("IntoFight") ~= "WorldBoss" then
        Aeris.Boss.Join()
        task.wait(Config.BossJoinSettle)
    end

    local folder = workspace:FindFirstChild("EnemyFolder_Server")
    local boss = folder and folder:FindFirstChild(bossName)
    if not boss or boss:GetAttribute("Dead") then return end
    Aeris.Boss.StandNear(boss)
    local announce = Aeris.Util.Remote("Attack", "UseAnyATKRE")
    local attack = Aeris.Util.Remote("Attack", "AttackEnemyServiceRE")
    for _ = 1, Config.BossHitsPerTick do
        if not (State.Alive and State.Opt.AutoWorldBoss and boss.Parent) or boss:GetAttribute("Dead") then return end
        local timestamp = workspace:GetServerTimeNow()
        announce:FireServer(attackId, timestamp)
        attack:FireServer({ bossName }, { Phase = 1, SkillID = attackId, Attacker = LocalPlayer }, timestamp)
        task.wait(Config.BossHitGap)
    end
end

function Aeris.Boss.ClaimCards()
    local claim = Aeris.Util.Remote("WorldBoss", "TryClaimBossRewardRE")
    for card = 1, Config.BossCards do
        task.spawn(claim.FireServer, claim, tostring(card))
    end
end

function Aeris.Boss.Leave()
    Aeris.Util.Remote("WorldBoss", "ExitWorldBossFightRE"):FireServer()
    LocalPlayer:SetAttribute("IntoFight", nil)
    local char = LocalPlayer.Character
    if State.BossReturn and char then char:PivotTo(State.BossReturn) end
    State.BossReturn = nil
end

function Aeris.Boss.Bind()
    table.insert(State.Conns, Aeris.Util.Remote("WorldBoss", "BossDeadRE").OnClientEvent:Connect(function()
        if not State.Opt.AutoWorldBoss then return end
        State.BossLooting = os.clock()
        task.delay(Config.BossClaimDelay, function()
            if State.Opt.BossCards then Aeris.Util.Try(Aeris.Boss.ClaimCards) end
            task.wait(Config.BossHopAfter)
            Aeris.Util.Try(Aeris.Boss.Leave)
            State.BossDone = os.clock()
            State.BossLooting = nil
        end)
    end))
    table.insert(State.Conns, Aeris.Util.Remote("WorldBoss", "BossEscapeRE").OnClientEvent:Connect(function()
        if State.Opt.AutoWorldBoss then Aeris.Util.Try(Aeris.Boss.Leave) end
    end))
end

---@return table?
function Aeris.Season.Current()
    local seasons = Aeris.Data.Get().Season or {}
    if seasons.Season1 then return seasons.Season1 end
    local bestKey = Aeris.Util.HighestKey(seasons)
    return bestKey and seasons[bestKey] or seasons[next(seasons)]
end

---@return string[], table
function Aeris.Season.Goods()
    local goods = Aeris.GameLib.Need(GameConfig.Season.GoodsConfig)
    local ids = {}
    for goodId in pairs(goods) do
        table.insert(ids, goodId)
    end
    table.sort(ids, function(a, b) return tonumber(a) < tonumber(b) end)
    local labels, byLabel = {}, {}
    for _, goodId in ipairs(ids) do
        local good = goods[goodId]
        local label = ("%s x%d (%d coin)"):format(good.ID, good.Number, good.NeedSeasonCoin)
        byLabel[label] = goodId
        table.insert(labels, label)
    end
    return labels, byLabel
end

---@return number
function Aeris.Season.BuyExclusive()
    local goods = Aeris.GameLib.Need(GameConfig.Season.GoodsConfig)
    local exchange = Aeris.Util.Remote("Season", "ExchangeGoodsRE")
    local bought = 0
    for goodId, good in pairs(goods) do
        if not State.Alive then break end
        if good.Type ~= "Weapon" and good.Type ~= "Armor" and good.Type ~= "Hat" then continue end
        local season = Aeris.Season.Current()
        local before = season and ((season.Goods or {})[goodId] or 0) or 0
        if not season or before >= (good.Store or 1) then continue end
        local short = good.NeedSeasonCoin - (season.SeasonCoin or 0)
        if short > 0 then Aeris.Tower.FarmCoins(short) season = Aeris.Season.Current() end
        if not season or (season.SeasonCoin or 0) < good.NeedSeasonCoin then continue end
        exchange:FireServer(goodId)
        task.wait(0.3)
        local updated = Aeris.Season.Current()
        if updated and ((updated.Goods or {})[goodId] or 0) > before then bought += 1 end
    end
    Aeris.Data.Get(true)
    return bought
end

function Aeris.Season.BuyGoods()
    local goods = Aeris.GameLib.Need(GameConfig.Season.GoodsConfig)
    local exchange = Aeris.Util.Remote("Season", "ExchangeGoodsRE")
    for goodId, wanted in pairs(State.Opt.SeasonGoods) do
        local good = goods[goodId]
        if not (wanted and good) then continue end
        for _ = 1, good.Store or 1 do
            if not State.Alive then return end
            local season = Aeris.Season.Current()
            local count = season and ((season.Goods or {})[goodId] or 0) or 0
            if not season or count >= (good.Store or 1) or (season.SeasonCoin or 0) < good.NeedSeasonCoin then break end
            exchange:FireServer(goodId)
            task.wait(0.2)
            local updated = Aeris.Season.Current()
            if not updated or ((updated.Goods or {})[goodId] or 0) <= count then break end
        end
    end
    Aeris.Data.Get(true)
end

function Aeris.Season.Step()
    Aeris.Util.Remote("Season", "TryClaimDailyTicRE"):FireServer()
    Aeris.Util.Remote("Season", "TryClaimAllRewardRE"):FireServer()
    task.wait(0.3)
    Aeris.Season.BuyGoods()
    local season = Aeris.Season.Current()
    if not (season and State.Opt.SeasonSpin) then return end
    local luck = Aeris.Util.Remote("Season", "LuckRE")
    for _ = 1, math.min(season.SeasonTicket or 0, math.clamp(State.Opt.SeasonSpinBatch, 1, 50)) do
        if not State.Alive or not State.Opt.AutoSeason or not State.Opt.SeasonSpin then break end
        luck:FireServer(1)
        task.wait(0.3)
    end
end

function Aeris.Claim.All()
    Aeris.Util.Remote("Offline", "TryClaimOfflineRewardRE"):FireServer()
    Aeris.Util.Remote("Dungeon", "TryClaimDailyDunTicRE"):FireServer()
    Aeris.Util.Remote("Season", "TryClaimDailyTicRE"):FireServer()
    Aeris.Util.Remote("Season", "TryClaimAllRewardRE"):FireServer()
    Aeris.Util.Remote("Player", "TryJoinGroupRE"):FireServer()
    Aeris.Util.Try(Aeris.Claim.CheckIn)
    Aeris.Util.Try(Aeris.Index.ClaimAll)

    local claimQuest = Aeris.Util.Remote("EnhantEvent", "TryClaimQuestRE")
    local claimUpdate = Aeris.Util.Remote("UpdateLog", "TryClaimUPDRewardRE")
    for id = 1, Config.ClaimIdScan do
        claimQuest:FireServer(id)
        claimUpdate:FireServer(id)
    end

    local ok, rewards = pcall(Aeris.GameLib.Api(GameConfig.Online.Helper).GetOnlineRewardConfig)
    for rewardName in pairs(ok and type(rewards) == "table" and rewards or {}) do
        Aeris.Util.Remote("Online", "TryClaimRE"):FireServer(rewardName)
    end
    Aeris.Data.Get(true)
end

---@param code string
---@return string
function Aeris.Claim.Code(code)
    local message
    local hasListener, messageEvent = pcall(Aeris.Util.Remote, "Message", "MessageRE")
    local conn = hasListener and messageEvent.OnClientEvent:Connect(function(text)
        message = message or tostring(text)
    end)
    local ok, err = pcall(function()
        return Aeris.Util.Remote("Code", "TryUseCodeRF"):InvokeServer(code)
    end)
    local deadline = os.clock() + Config.CodeReplyWait
    while conn and not message and os.clock() < deadline do task.wait(0.05) end
    if conn then conn:Disconnect() end
    if not ok then return "failed: " .. tostring(err) end
    return message or "no reply"
end

---@return string
function Aeris.Claim.AllCodes()
    local results = {}
    for _, code in ipairs(Config.Codes) do
        table.insert(results, ("%s: %s"):format(code, Aeris.Claim.Code(code)))
    end
    return table.concat(results, "\n")
end

---@param uuid string
---@return boolean
function Aeris.SuperLoot.Kill(uuid)
    if type(uuid) ~= "string" or State.LootPending[uuid] then return false end
    local folder = workspace:FindFirstChild("EnemyFolder") or workspace:FindFirstChild("EnemyFolder_Server")
    local enemy = folder and folder:FindFirstChild(uuid)
    local hp = enemy and enemy:FindFirstChild("HPValue")
    if not hp or type(hp.Value) ~= "number" then return false end

    State.LootPending[uuid] = coroutine.running()
    local ok, claimed = pcall(function()
        local hit = Aeris.GameLib.Api(ReplicatedStorage.Utils.CommunicationUtils).TryGetBindableEvent("Attack", "EnemyHitBE")
        if not hit or not hit:IsA("BindableEvent") then error("EnemyHitBE unavailable", 0) end
        local attackId = Aeris.Boss.AttackId() or "G_ATK_1"
        local info = { SkillID = attackId, IsCrit = State.Opt.AuraCritical, Damage = State.Opt.AuraDamage }
        local rounds = math.min(50, math.max(1, math.ceil(hp.Value)))
        for _ = 1, rounds do
            if not State.Alive then return false end
            hit:Fire(uuid, State.Opt.AuraDamage, info)
        end
        task.wait(0.1)
        local superKill = Aeris.Util.FindRemote("SuperLoot", "KillSuperLootRE")
        if superKill then superKill:FireServer(uuid) end
        task.wait(0.15)
        local getOre = Aeris.Util.FindRemote("Stage", "GetOreRF")
        if getOre then getOre:InvokeServer(uuid) end
        local claimAll = Aeris.Util.FindRemote("Stage", "ClaimedAllOreRE")
        if claimAll then claimAll:FireServer() end
        return true
    end)
    State.LootPending[uuid] = nil
    if not ok then error(claimed, 0) end
    return claimed
end

function Aeris.SuperLoot.KillExisting()
    local folders = { workspace:FindFirstChild("EnemyFolder"), workspace:FindFirstChild("EnemyFolder_Server") }
    for _, folder in ipairs(folders) do
        if not folder then continue end
        for _, enemy in ipairs(folder:GetChildren()) do
            local enemyId = enemy:GetAttribute("EnemyID")
            if type(enemyId) == "string" and enemyId:find("^Super") then
                Aeris.SuperLoot.Queue(enemy.Name)
            end
        end
    end
end

---@param uuid string
function Aeris.SuperLoot.Queue(uuid)
    if not State.Alive or type(uuid) ~= "string" or State.LootSeen[uuid] then return end
    if #State.LootQueue >= 256 then return end
    State.LootSeen[uuid] = true
    table.insert(State.LootQueue, uuid)
end

function Aeris.SuperLoot.Step()
    local uuid = table.remove(State.LootQueue, 1)
    if not uuid then return end
    Aeris.SuperLoot.Kill(uuid)
end

function Aeris.SuperLoot.Bind()
    table.insert(State.Conns, Aeris.Util.Remote("SuperLoot", "RefreshSuperLootRE").OnClientEvent:Connect(function(_, uuid)
        if State.Opt.SuperLootAura then
            Aeris.SuperLoot.Queue(uuid)
        end
    end))
    local folder = workspace:FindFirstChild("EnemyFolder")
    if folder then
        table.insert(State.Conns, folder.ChildRemoved:Connect(function(enemy)
            State.LootSeen[enemy.Name] = nil
            State.LootPending[enemy.Name] = nil
        end))
    end
end

---@return number
function Aeris.Combat.KillAll()
    local hit = Aeris.GameLib.Api(ReplicatedStorage.Utils.CommunicationUtils).TryGetBindableEvent("Attack", "EnemyHitBE")
    if not hit or not hit:IsA("BindableEvent") then error("EnemyHitBE unavailable", 0) end

    local damage = State.Opt.AuraDamage
    local weaponType = LocalPlayer:GetAttribute("WeaponType")
    local attackId = Config.BossAttackIds[weaponType] or "K_ATK_1"
    local hitInfo = { SkillID = attackId, IsCrit = State.Opt.AuraCritical, Damage = damage }

    local char = LocalPlayer.Character
    local origin = char and char:GetPivot().Position
    local mapWide = State.Opt.AuraMapWide or (State.Opt.AuraRange == 0)
    local range = State.Opt.AuraRange
    local burst = math.clamp(State.Opt.AuraBurst or 10, 1, 50)
    local targetFilter = State.Opt.AuraTarget or "All"

    local killed = 0
    local announce = Aeris.Util.FindRemote("Attack", "UseAnyATKRE")
    local attackService = Aeris.Util.FindRemote("Attack", "AttackEnemyServiceRE")
    local killEnemy = Aeris.Util.FindRemote("Attack", "KillEnemyRE")
    local killSuper = Aeris.Util.FindRemote("SuperLoot", "KillSuperLootRE")
    local getOre = Aeris.Util.FindRemote("Stage", "GetOreRF")
    local pickStone = Aeris.Util.FindRemote("Stage", "GetEnhantStoneRE")

    local folders = { workspace:FindFirstChild("EnemyFolder"), workspace:FindFirstChild("EnemyFolder_Server") }
    for _, folder in ipairs(folders) do
        if not folder then continue end
        local children = folder:GetChildren()
        for _, enemy in ipairs(children) do
            if not State.Alive or not (State.Opt.KillAura or State.Opt.AutoBattle) then return killed end
            local enemyId = tostring(enemy:GetAttribute("EnemyID") or "")
            local isSuper = enemyId:find("^Super") ~= nil
            local isBoss = folder.Name == "EnemyFolder_Server"

            if targetFilter == "Normal" and (isSuper or isBoss) then continue end
            if targetFilter == "Super" and not isSuper then continue end
            if targetFilter == "Boss" and not isBoss then continue end

            local hp = enemy:FindFirstChild("HPValue")
            if hp and type(hp.Value) == "number" and hp.Value <= 0 then continue end
            if enemy:GetAttribute("Dead") == true then continue end

            if not mapWide and origin and enemy:IsA("Model") then
                if (enemy:GetPivot().Position - origin).Magnitude > range then continue end
            end

            local name = enemy.Name
            local hitRounds = isSuper and math.min(burst, math.max(1, math.ceil(hp and hp.Value or 10))) or 1
            for _ = 1, hitRounds do
                hit:Fire(name, damage, hitInfo)
            end

            if announce and attackService then
                local now = workspace:GetServerTimeNow()
                pcall(announce.FireServer, announce, attackId, now)
                pcall(attackService.FireServer, attackService, { name }, { Phase = 1, SkillID = attackId, Attacker = LocalPlayer }, now)
            end

            if isSuper then
                if killSuper then pcall(killSuper.FireServer, killSuper, name) end
                if getOre then pcall(getOre.InvokeServer, getOre, name) end
            else
                if killEnemy then pcall(killEnemy.FireServer, killEnemy, name) end
            end

            killed += 1
            if killed >= State.Opt.AuraBatch then break end
        end
        if killed >= State.Opt.AuraBatch then break end
    end

    if State.Opt.AutoCollectDrops then
        local claimAll = Aeris.Util.FindRemote("Stage", "ClaimedAllOreRE")
        if claimAll then pcall(claimAll.FireServer, claimAll) end
    end

    return killed
end

function Aeris.Combat.Start()
    if State.AuraLoop then return end
    State.AuraLoop = task.defer(function()
        while State.Alive and State.Opt.KillAura do
            Aeris.Scheduler.Run("KillAura", Aeris.Combat.KillAll)
            task.wait(State.Opt.AuraInterval)
        end
        State.AuraLoop = nil
    end)
end

---@return boolean
function Aeris.Guard.HookDamage()
    if State.RestoreDamage then return true end
    local hpCtrl = Aeris.GameLib.Require(ReplicatedStorage.CTRL.HPCTRL)
    local damageOnce = hpCtrl and hpCtrl.DamageOnce
    if type(damageOnce) ~= "function" then return false end

    hpCtrl.DamageOnce = function(target, damage)
        if target == LocalPlayer and State.Opt.GodMode then return false end
        return damageOnce(target, damage)
    end
    State.RestoreDamage = function()
        hpCtrl.DamageOnce = damageOnce
        State.RestoreDamage = nil
    end
    return true
end

---@return boolean
function Aeris.Guard.HookOreLoss()
    if State.RestoreNamecall then return true end
    local compat = Aeris.Compat
    if not (compat and compat.Caps.Namecall) then return false end
    local found, lostOre = pcall(Aeris.Util.Remote, "Stage", "LostAllOreRF")
    if not found then
        warn("[Aeris] keep ore:", lostOre)
        return false
    end

    local original, restore
    original, restore = compat.HookMeta(game, "__namecall", function(self, ...)
        if self == lostOre and State.Opt.KeepOre and getnamecallmethod() == "InvokeServer" then
            return {}
        end
        return original(self, ...)
    end)
    if not original then return false end

    State.RestoreNamecall = function()
        State.RestoreNamecall = nil
        restore()
    end
    return true
end

function Aeris.Guard.UnhookOreLoss()
    if State.RestoreNamecall then State.RestoreNamecall() end
end

function Aeris.Guard.Stop()
    if State.RestoreDamage then State.RestoreDamage() end
    Aeris.Guard.UnhookOreLoss()
end

---@return string[], table
function Aeris.Race.Choices()
    local classConfig = Aeris.GameLib.Need(GameConfig.Class.Config)
    local show = Aeris.GameLib.Need(GameConfig.Class.Show)
    local ids = {}
    for classId in pairs(classConfig) do
        table.insert(ids, classId)
    end
    table.sort(ids, function(a, b) return classConfig[a].Weight < classConfig[b].Weight end)

    local labels, idByLabel = {}, {}
    for _, classId in ipairs(ids) do
        local label = ("%s (%s)"):format(show[classId] and show[classId].DisplayName or classId, classConfig[classId].Rarity)
        idByLabel[label] = classId
        table.insert(labels, label)
    end
    return labels, idByLabel
end

---@return boolean
function Aeris.Race.EquipBest()
    local classData = Aeris.Data.Get().Class
    local classConfig = Aeris.GameLib.Need(GameConfig.Class.Config)
    local bestSlot, bestWeight = nil, math.huge
    for slot, classId in pairs(classData.have) do
        local weight = classConfig[classId] and classConfig[classId].Weight or math.huge
        if weight < bestWeight then bestSlot, bestWeight = slot, weight end
    end
    if not bestSlot or tostring(bestSlot) == tostring(classData.equiped) then return false end
    Aeris.Util.Remote("Class", "ChangeEquipedIndexRE"):FireServer(tostring(bestSlot))
    Aeris.Data.Get(true)
    return true
end

---@param rarity any
---@return number
function Aeris.Race.RarityLevel(rarity)
    local ok, level = pcall(Aeris.GameLib.Api(GameConfig.Rarity.Helper).GetRarityLevel, rarity)
    return ok and tonumber(level) or 0
end

---@param classId string
---@return number
function Aeris.Race.Level(classId)
    local info = classId and Aeris.GameLib.Need(GameConfig.Class.Config)[classId]
    return info and Aeris.Race.RarityLevel(info.Rarity) or 0
end

---@return string[], table
function Aeris.Race.RarityChoices()
    local seen, levels = {}, {}
    for _, info in pairs(Aeris.GameLib.Need(GameConfig.Class.Config)) do
        if seen[info.Rarity] then continue end
        seen[info.Rarity] = true
        table.insert(levels, { info.Rarity, Aeris.Race.RarityLevel(info.Rarity) })
    end
    table.sort(levels, function(a, b) return a[2] < b[2] end)
    local labels, byLabel = { "Off" }, {}
    for _, pair in ipairs(levels) do
        local label = pair[1] .. "+"
        table.insert(labels, label)
        byLabel[label] = pair[2]
    end
    return labels, byLabel
end

---@param classId string
---@return number
function Aeris.Race.Stars(classId)
    local record = Aeris.GameLib.Need(ReplicatedStorage.LocalData.ClassData).GetData().recored
    local entry = record and record[classId]
    return entry and tonumber(entry.Level) or 0
end

---@param classId string
---@return boolean
function Aeris.Race.IsGoal(classId)
    if not classId then return false end
    local wanted = State.Opt.RaceTargets[classId]
        or (State.Opt.RaceMinLevel ~= nil and Aeris.Race.Level(classId) >= State.Opt.RaceMinLevel)
    return wanted and Aeris.Race.Stars(classId) >= (State.Opt.RaceStar or 0)
end

---@param classData table
---@return string?, string?
function Aeris.Race.PickSlot(classData)
    local slot = State.Opt.RaceSlot == "Equipped" and tostring(classData.equiped) or State.Opt.RaceSlot:match("%d+")
    if not (slot and classData.have[slot]) then return nil, "that slot is not unlocked" end
    if classData.lock and classData.lock[slot] then return nil, "that slot is locked" end
    return slot
end

---@param muted boolean
function Aeris.Race.MuteAnim(muted)
    if not Aeris.Compat.Caps.Connections then return end
    local event = Aeris.Util.Remote("Class", "ShowLuckResultRE").OnClientEvent
    for _, conn in ipairs(getconnections(event)) do
        if muted then conn:Disable() else conn:Enable() end
    end
end

---@param classStore table
---@return boolean
function Aeris.Race.EnsureRolls(classStore)
    if (classStore.GetData().luckTimes or 0) > 0 then return true end
    if not State.Opt.RaceBuyRolls then return false end
    local config = Aeris.GameLib.Need(GameConfig.Season.GoodsConfig)
    local season = Aeris.Season.Current()
    for id, good in pairs(config) do
        if good.ID == "ClassRoll" and season and (season.SeasonCoin or 0) >= good.NeedSeasonCoin
            and ((season.Goods or {})[id] or 0) < (good.Store or 1) then
            Aeris.Util.Remote("Season", "ExchangeGoodsRE"):FireServer(id)
            local deadline = os.clock() + Config.RaceResultWait * 2
            repeat task.wait(0.1) until not State.Alive or (classStore.GetData().luckTimes or 0) > 0 or os.clock() >= deadline
            return (classStore.GetData().luckTimes or 0) > 0
        end
    end
    return false
end

---@return string, string?
function Aeris.Race.RollUntil()
    local classStore = Aeris.GameLib.Need(ReplicatedStorage.LocalData.ClassData)
    local roll = Aeris.Util.Remote("Class", "LuckOnceRE")
    local protectLevel = Aeris.Race.RarityLevel(Config.RaceProtectRarity)
    State.RaceRolls = 0
    while State.Alive and State.Opt.AutoRace do
        local classData = classStore.GetData()
        local slot, why = Aeris.Race.PickSlot(classData)
        if not slot then return "blocked", why end

        local current = classData.have[slot]
        if Aeris.Race.IsGoal(current) then
            if State.Opt.RaceLock then Aeris.Util.Remote("Class", "SetIndexLockRE"):FireServer(slot) end
            return "got", current
        end
        if State.Opt.RaceProtect and Aeris.Race.Level(current) >= protectLevel then
            return "blocked", "this slot holds a Mythic+ race"
        end
        if not Aeris.Race.EnsureRolls(classStore) then return "empty" end

        roll:FireServer(slot)
        State.RaceRolls += 1
        local deadline = os.clock() + Config.RaceResultWait
        repeat task.wait() until classStore.GetData().have[slot] ~= current or os.clock() > deadline
        task.wait(Config.RaceRollDelay)
    end
    return "stopped"
end

---@param refresh boolean?
---@return table
function Aeris.Pet.Store(refresh)
    local profile = Aeris.Data.Get(refresh)
    return profile and profile.Pet or {}
end

---@param petId string
---@return string?
function Aeris.Pet.Rarity(petId)
    local cfg = Aeris.GameLib.Need(GameConfig.Pet.Config)[petId]
    return cfg and cfg.Rarity
end

---@param entry table
---@return number
function Aeris.Pet.Score(entry)
    if type(entry) ~= "table" or entry.Type ~= "Pet" then return -1 end
    local cfg = Aeris.GameLib.Need(GameConfig.Pet.Config)[entry.ID]
    if not cfg then return 0 end
    local rarityLv = Aeris.Race.RarityLevel(cfg.Rarity)
    local boostSum = 0
    local ok, boosts = pcall(Aeris.GameLib.Api(ReplicatedStorage.Utils.BalanceUtils).GetPetBoosts, entry)
    if ok and type(boosts) == "table" then
        for _, val in pairs(boosts) do
            if type(val) == "number" then boostSum += val end
        end
    end
    local skills = type(entry.ExtraSkill) == "table" and #entry.ExtraSkill or 0
    return rarityLv * 10000 + boostSum * 1000 + (entry.Level or 1) * 10 + skills * 500 + Aeris.Util.Tier(entry.ID)
end

function Aeris.Pet.ResetVFX()
    pcall(function()
        local gui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
        local openGui = gui and gui:FindFirstChild("OpenEggGui")
        if openGui and openGui.Enabled then
            local vfx = ReplicatedStorage:FindFirstChild("GuiUtils")
                and ReplicatedStorage.GuiUtils:FindFirstChild("PetGUI")
                and ReplicatedStorage.GuiUtils.PetGUI:FindFirstChild("OpenEggVFX")
            if vfx then Aeris.GameLib.Api(vfx).Reset() end
        end
    end)
end

---@param muted boolean
function Aeris.Pet.MuteAnim(muted)
    if Aeris.Compat and Aeris.Compat.Caps.Connections then
        local remote = Aeris.Util.FindRemote("Pet", "ShowLuckResult")
        if remote and remote:IsA("RemoteEvent") then
            for _, conn in ipairs(getconnections(remote.OnClientEvent)) do
                if muted then conn:Disable() else conn:Enable() end
            end
        end
    end
    if muted then Aeris.Pet.ResetVFX() end
end

function Aeris.Pet.Bind()
    local remote = Aeris.Util.FindRemote("Pet", "ShowLuckResult")
    if remote and remote:IsA("RemoteEvent") then
        table.insert(State.Conns, remote.OnClientEvent:Connect(function()
            if State.Opt.SkipEggAnim then
                task.defer(Aeris.Pet.ResetVFX)
                task.delay(0.15, Aeris.Pet.ResetVFX)
            end
        end))
    end
end

---@param petStore table?
---@return number, number
function Aeris.Pet.Counts(petStore)
    petStore = petStore or Aeris.Pet.Store()
    local pets, eggs = 0, 0
    for _, entry in pairs(petStore.have or {}) do
        if entry.Type == "Pet" then
            pets += 1
        elseif entry.Type == "Egg" and not entry.HatchReadyTick then
            eggs += 1
        end
    end
    return pets, eggs
end

---@param preferEggId string?
---@return number
function Aeris.Pet.TrimEggs(preferEggId)
    local petStore = Aeris.Pet.Store()
    local byId, totalEggs = {}, 0
    for uuid, entry in pairs(petStore.have or {}) do
        if entry.Type == "Egg" and not entry.HatchReadyTick then
            byId[entry.ID] = byId[entry.ID] or {}
            table.insert(byId[entry.ID], uuid)
            totalEggs += 1
        end
    end
    local deleteRE = Aeris.Util.Remote("Pet", "DeleteRE")
    local deleted = 0
    local keepLimit = math.max(1, State.Opt.KeepPerEgg or 10)
    local maxEggs = petStore.maxEggNum or 25
    for eggId, list in pairs(byId) do
        local limit = keepLimit
        if preferEggId and eggId ~= preferEggId and totalEggs >= maxEggs - 3 then
            limit = math.min(limit, math.max(2, math.floor(maxEggs / 4)))
        end
        for i = limit + 1, #list do
            deleteRE:FireServer(list[i])
            deleted += 1
            totalEggs -= 1
        end
    end
    if deleted > 0 then Aeris.Data.Get(true) end
    return deleted
end

---@return number, number
function Aeris.Pet.CleanBag()
    local petStore = Aeris.Pet.Store()
    local protected = {}
    for _, uuid in pairs(petStore.equiped or {}) do
        protected[uuid] = true
    end
    local allPets = {}
    for uuid, entry in pairs(petStore.have or {}) do
        if entry.Type == "Pet" then
            if entry.DeployStartTick then protected[uuid] = true end
            table.insert(allPets, { uuid = uuid, entry = entry, score = Aeris.Pet.Score(entry) })
        end
    end
    table.sort(allPets, function(a, b) return a.score > b.score end)
    for i = 1, math.min(#allPets, math.max(1, State.Opt.KeepBestPets or 6)) do
        protected[allPets[i].uuid] = true
    end
    local deleteRE = Aeris.Util.Remote("Pet", "DeleteRE")
    local deletedPets = 0
    for _, item in ipairs(allPets) do
        local rarity = Aeris.Pet.Rarity(item.entry.ID)
        if not protected[item.uuid] and State.Opt.DeletePetRarities[rarity] then
            deleteRE:FireServer(item.uuid)
            deletedPets += 1
        end
    end
    local deletedEggs = State.Opt.AutoDeleteEggs and Aeris.Pet.TrimEggs() or 0
    if deletedPets > 0 then Aeris.Data.Get(true) end
    return deletedPets, deletedEggs
end

---@return number, number
function Aeris.Pet.HatchStep()
    Aeris.Pet.MuteAnim(true)
    local petStore = Aeris.Pet.Store()
    local now = (workspace.GetServerTimeNow and workspace:GetServerTimeNow()) or (workspace:GetAttribute("ServerTime") or os.time())
    local petCount = Aeris.Pet.Counts(petStore)
    local maxPet = petStore.maxPetNum or 25

    if petCount >= maxPet - 2 or State.Opt.AutoSellPet then
        Aeris.Pet.CleanBag()
        petStore = Aeris.Pet.Store(true)
        petCount = Aeris.Pet.Counts(petStore)
    end

    local openRE = Aeris.Util.Remote("Pet", "TryOpenEggRE")
    local hatchRE = Aeris.Util.Remote("Pet", "TryHatchEggRE")
    local opened = 0

    -- Open eggs in incubator whose server timer is ready
    for _, uuid in pairs(petStore.hatched or {}) do
        local entry = petStore.have and petStore.have[uuid]
        if entry and (entry.HatchReadyTick or 0) <= now and petCount + opened < maxPet then
            openRE:FireServer(uuid)
            opened += 1
        end
    end

    if opened > 0 then
        Aeris.Pet.ResetVFX()
        petStore = Aeris.Pet.Store(true)
        petCount = Aeris.Pet.Counts(petStore)
    end

    -- Incubate candidates up to free slots
    local usedSlots = 0
    for _ in pairs(petStore.hatched or {}) do usedSlots += 1 end
    local maxHatch = petStore.maxHatchNum or 3
    local freeSlots = math.max(0, maxHatch - usedSlots)
    local hatched = 0

    if freeSlots > 0 then
        local targetEggId = "Egg2"
        if State.Opt.TargetPet and State.PetTargetLabels and State.PetTargetLabels[State.Opt.TargetPet] then
            local pId = State.PetTargetLabels[State.Opt.TargetPet]
            local eggCfg = Aeris.GameLib.Need(GameConfig.Egg.Config)
            for eggId, data in pairs(eggCfg or {}) do
                if data.PetList then
                    for _, item in ipairs(data.PetList) do
                        local subId = type(item) == "table" and (item.ID or item[1]) or item
                        if subId == pId then targetEggId = eggId break end
                    end
                end
            end
        end

        local candidates = {}
        for uuid, entry in pairs(petStore.have or {}) do
            if entry.Type == "Egg" and not entry.HatchReadyTick then
                table.insert(candidates, {
                    uuid = uuid,
                    id = entry.ID,
                    isTarget = (entry.ID == targetEggId),
                    tier = Aeris.Util.Tier(entry.ID)
                })
            end
        end
        table.sort(candidates, function(a, b)
            if a.isTarget ~= b.isTarget then return a.isTarget end
            if State.Opt.HatchBestFirst then return a.tier > b.tier end
            return a.tier < b.tier
        end)

        for i = 1, math.min(freeSlots, #candidates) do
            hatchRE:FireServer(candidates[i].uuid)
            hatched += 1
        end
    end

    if hatched > 0 or opened > 0 then
        Aeris.Data.Get(true)
        Aeris.Pet.ResetVFX()
    end

    if State.Opt.AutoDeleteEggs then Aeris.Pet.TrimEggs() end
    return opened, hatched
end

---@return number, number
function Aeris.Pet.InstantHatchAll()
    Aeris.Pet.MuteAnim(true)
    local petStore = Aeris.Pet.Store(true)
    local openRE = Aeris.Util.Remote("Pet", "TryOpenEggRE")
    local hatchRE = Aeris.Util.Remote("Pet", "TryHatchEggRE")
    local now = (workspace.GetServerTimeNow and workspace:GetServerTimeNow()) or (workspace:GetAttribute("ServerTime") or os.time())
    local maxPet = petStore.maxPetNum or 25
    
    Aeris.Pet.CleanBag()
    petStore = Aeris.Pet.Store(true)

    local opened, hatched = 0, 0
    -- 1. Open all ready eggs
    for _, uuid in pairs(petStore.hatched or {}) do
        local entry = petStore.have and petStore.have[uuid]
        if entry and (entry.HatchReadyTick or 0) <= now then
            openRE:FireServer(uuid)
            opened += 1
        end
    end

    if opened > 0 then
        Aeris.Pet.ResetVFX()
        petStore = Aeris.Pet.Store(true)
    end

    -- 2. Incubate unhatched eggs into free slots
    local usedSlots = 0
    for _ in pairs(petStore.hatched or {}) do usedSlots += 1 end
    local maxHatch = petStore.maxHatchNum or 3
    local freeSlots = math.max(0, maxHatch - usedSlots)

    if freeSlots > 0 then
        local candidates = {}
        for uuid, entry in pairs(petStore.have or {}) do
            if entry.Type == "Egg" and not entry.HatchReadyTick then
                table.insert(candidates, { uuid = uuid, tier = Aeris.Util.Tier(entry.ID) })
            end
        end
        table.sort(candidates, function(a, b) return a.tier > b.tier end)
        for i = 1, math.min(freeSlots, #candidates) do
            hatchRE:FireServer(candidates[i].uuid)
            hatched += 1
        end
    end

    Aeris.Pet.ResetVFX()
    Aeris.Data.Get(true)
    if State.Opt.AutoEquipPet then Aeris.Pet.EquipBest() end
    if State.Opt.AutoFeedPet then Aeris.Pet.FeedBest() end
    return opened, hatched
end

---@return string[]
function Aeris.Pet.Choices()
    local labels, ids = {}, {}
    local petFolder = GameConfig:FindFirstChild("Pet")
    local petShow = petFolder and petFolder:FindFirstChild("Show") and Aeris.GameLib.Require(petFolder.Show)
    local petCfg = petFolder and petFolder:FindFirstChild("Config") and Aeris.GameLib.Require(petFolder.Config)
    if petShow or petCfg then
        local petIds = {}
        local allPetKeys = {}
        if petShow then for id in pairs(petShow) do allPetKeys[id] = true end end
        if petCfg then for id in pairs(petCfg) do allPetKeys[id] = true end end
        for id in pairs(allPetKeys) do petIds[#petIds + 1] = id end
        table.sort(petIds, function(a, b)
            local rA = petCfg and petCfg[a] and petCfg[a].Rarity or ""
            local rB = petCfg and petCfg[b] and petCfg[b].Rarity or ""
            local lvA = Aeris.Race.RarityLevel(rA)
            local lvB = Aeris.Race.RarityLevel(rB)
            if lvA ~= lvB then return lvA > lvB end
            return Aeris.Util.Tier(a) > Aeris.Util.Tier(b)
        end)
        for _, id in ipairs(petIds) do
            local name = petShow and petShow[id] and (petShow[id].DisplayName or petShow[id].Name) or (petCfg and petCfg[id] and petCfg[id].Name) or id
            local rarity = petCfg and petCfg[id] and petCfg[id].Rarity or "Pet"
            local label = "[" .. rarity .. "] " .. name .. " (" .. id .. ")"
            labels[#labels + 1] = label
            ids[label] = id
        end
    end
    State.PetTargetLabels = ids
    return labels
end

---@return number
function Aeris.Pet.LockAllGodPets()
    local petStore = Aeris.Pet.Store(true)
    local lockRE = Aeris.Util.Remote("Backpack", "SetLockRE")
    local locked = 0
    for uuid, entry in pairs(petStore.have or {}) do
        if entry.Type == "Pet" and not entry.Lock then
            local rarity = Aeris.Pet.Rarity(entry.ID)
            local rarityLv = Aeris.Race.RarityLevel(rarity)
            if rarityLv >= 4 or table.find(petStore.equiped or {}, uuid) then
                lockRE:FireServer(uuid, true)
                locked += 1
            end
        end
    end
    return locked
end

---@param targetPetId string
---@param neededCount number?
---@return number, string
function Aeris.Pet.FarmAndHatchTarget(targetPetId, neededCount)
    neededCount = math.max(1, math.floor(neededCount or 1))
    local eggCfg = Aeris.GameLib.Need(GameConfig.Egg.Config)
    local targetEggId = "Egg2"
    for eggId, data in pairs(eggCfg or {}) do
        if data.PetList then
            for _, item in ipairs(data.PetList) do
                local pId = type(item) == "table" and (item.ID or item[1]) or item
                if pId == targetPetId then
                    targetEggId = eggId
                    break
                end
            end
        end
    end

    -- Ensure target eggs in bag
    local store = Aeris.Pet.Store(true)
    local targetEggCount = 0
    for _, entry in pairs(store.have or {}) do
        if entry.Type == "Egg" and entry.ID == targetEggId and not entry.HatchReadyTick then
            targetEggCount += 1
        end
    end

    if targetEggCount < 5 then
        Aeris.Pet.TrimEggs(targetEggId)
        Aeris.Stage.FarmTurbo(targetEggId, "Egg", 15)
        store = Aeris.Pet.Store(true)
    end

    -- Open finished eggs and incubate target eggs
    local opened, hatched = Aeris.Pet.HatchStep()

    store = Aeris.Pet.Store(true)
    local now = (workspace.GetServerTimeNow and workspace:GetServerTimeNow()) or (workspace:GetAttribute("ServerTime") or os.time())
    local minDiff = math.huge
    for _, u in pairs(store.hatched or {}) do
        local it = store.have and store.have[u]
        if it and it.HatchReadyTick then
            local diff = math.max(0, it.HatchReadyTick - now)
            if diff < minDiff then minDiff = diff end
        end
    end

    local newlyGained = 0
    for uuid, entry in pairs(store.have or {}) do
        if entry.Type == "Pet" and entry.ID == targetPetId then
            newlyGained += 1
            if State.Opt.AutoLockTargetPet and not entry.Lock then
                Aeris.Util.Remote("Backpack", "SetLockRE"):FireServer(uuid, true)
            end
        end
    end

    if newlyGained > 0 then
        Aeris.Pet.EquipBest()
        Aeris.Pet.FeedAllMax()
        return newlyGained, ("Acquired %s!"):format(targetPetId)
    end

    if minDiff < math.huge then
        return 0, ("Incubating %s (%ds left)"):format(targetEggId, minDiff)
    end
    return 0, "No eggs incubating"
end

function Aeris.Pet.ChaseStep()
    if not State.Opt.AutoChaseTargetPet then return end
    local picked = State.PetTargetLabels and State.PetTargetLabels[State.Opt.TargetPet]
    if not picked then return end
    local gained = Aeris.Pet.FarmAndHatchTarget(picked, State.Opt.TargetPetCopies or 1)
    if gained >= (State.Opt.TargetPetCopies or 1) then
        State.Opt.AutoChaseTargetPet = false
        if Library and Library.Options and Library.Options.AutoChaseTargetPet then
            Library.Options.AutoChaseTargetPet:SetValue(false)
        end
    end
end

function Aeris.Pet.InfiniteLoopStep()
    local petStore = Aeris.Pet.Store(true)
    local pets, eggs = Aeris.Pet.Counts(petStore)
    local maxEggs = petStore.maxEggNum or 25
    if eggs < maxEggs - 5 then
        Aeris.Stage.FarmEggsAndFood(20)
    end
    Aeris.Pet.HatchStep()
    Aeris.Pet.EquipBest()
    Aeris.Pet.FeedBest()
    Aeris.Pet.DeployStep()
end

---@return number
function Aeris.Pet.EquipBest()
    local petStore = Aeris.Pet.Store()
    local owned = {}
    for uuid, entry in pairs(petStore.have or {}) do
        if entry.Type == "Pet" then
            table.insert(owned, { uuid = uuid, score = Aeris.Pet.Score(entry) })
        end
    end
    if #owned == 0 then return 0 end
    table.sort(owned, function(a, b) return a.score > b.score end)

    local maxEquip = petStore.maxEquipNum or 1
    local wanted, wantedList = {}, {}
    for i = 1, math.min(maxEquip, #owned) do
        wanted[owned[i].uuid] = owned[i].score
        table.insert(wantedList, owned[i])
    end

    local currentSet = {}
    for _, uuid in pairs(petStore.equiped or {}) do
        currentSet[uuid] = true
    end

    local equipRE = Aeris.Util.Remote("Pet", "IsEquipPetRE")
    local changed = 0
    for uuid in pairs(currentSet) do
        if not wanted[uuid] then
            local entry = petStore.have and petStore.have[uuid]
            local curScore = entry and Aeris.Pet.Score(entry) or -1
            local bestReplacement = wantedList[1]
            if bestReplacement and bestReplacement.score > curScore then
                equipRE:FireServer(uuid, false)
                currentSet[uuid] = nil
            end
        end
    end
    for _, item in ipairs(wantedList) do
        if not currentSet[item.uuid] then
            equipRE:FireServer(item.uuid, true)
            changed += 1
        end
    end
    if changed > 0 then Aeris.Data.Get(true) end
    return changed
end

---@return number
function Aeris.Pet.FeedBest()
    local profile = Aeris.Data.Get()
    local petStore = profile.Pet or {}
    local foodCfg = Aeris.GameLib.Need(GameConfig.Food.Config)
    local petHelper = Aeris.GameLib.Api(GameConfig.Pet.Helper)
    local foods = {}
    for uuid, entry in pairs(profile.Backpack.have or {}) do
        local count = math.floor(entry.Number or 0)
        local info = entry.Type == "Food" and foodCfg[entry.ID]
        if info and count >= 1 and (info.Exp or 0) > 0 then
            table.insert(foods, { uuid = uuid, count = count, exp = info.Exp })
        end
    end
    if #foods == 0 then return 0 end
    table.sort(foods, function(a, b) return a.exp > b.exp end)

    local equippedSet = {}
    for _, uuid in pairs(petStore.equiped or {}) do equippedSet[uuid] = true end
    local targets = {}
    for uuid, entry in pairs(petStore.have or {}) do
        if entry.Type == "Pet" and not petHelper.CheckLevelIsMax(entry.Level or 1, entry.ID) then
            local priority = (equippedSet[uuid] and 1e9 or 0) + (entry.DeployStartTick and 1e8 or 0) + Aeris.Pet.Score(entry)
            table.insert(targets, { uuid = uuid, entry = entry, priority = priority })
        end
    end
    if #targets == 0 then return 0 end
    table.sort(targets, function(a, b) return a.priority > b.priority end)

    local target = targets[1]
    local maxLv = petHelper.GetMaxLevel(target.entry.ID) or 20
    local needExp = -(target.entry.Exp or 0)
    for lv = (target.entry.Level or 1) + 1, maxLv do
        needExp += (petHelper.GetNeedExp(lv) or 0)
    end
    if needExp <= 0 then return 0 end

    local feedMap, usedAny = {}, false
    for _, food in ipairs(foods) do
        if needExp <= 0 then break end
        local use = math.min(food.count, math.max(1, math.ceil(needExp / food.exp)))
        if use > 0 then
            feedMap[food.uuid] = use
            needExp -= use * food.exp
            usedAny = true
        end
    end
    if not usedAny then return 0 end
    Aeris.Util.Remote("Pet", "FeedPetRE"):FireServer(target.uuid, feedMap)
    Aeris.Data.Get(true)
    return 1
end

---@return number
function Aeris.Pet.FeedAllMax()
    local totalFed = 0
    for _ = 1, 15 do
        local fed = Aeris.Pet.FeedBest()
        if fed <= 0 then break end
        totalFed += fed
        task.wait(0.05)
    end
    return totalFed
end

---@return number
function Aeris.Pet.DeployStep()
    local petStore = Aeris.Pet.Store()
    if type(petStore.deployRewardList) == "table" and next(petStore.deployRewardList) ~= nil then
        Aeris.Util.Remote("Pet", "ClaimAllDeployRewardRE"):FireServer()
    end
    local deployedCount = 0
    local candidates = {}
    for uuid, entry in pairs(petStore.have or {}) do
        if entry.Type == "Pet" then
            if entry.DeployStartTick then
                deployedCount += 1
            else
                table.insert(candidates, { uuid = uuid, score = Aeris.Pet.Score(entry) })
            end
        end
    end
    local freeSlots = (petStore.maxDeployNum or 2) - deployedCount
    if freeSlots <= 0 or #candidates == 0 then return 0 end
    table.sort(candidates, function(a, b) return a.score > b.score end)
    local deployRE = Aeris.Util.Remote("Pet", "IsDeployPetRE")
    local deployed = 0
    for i = 1, math.min(freeSlots, #candidates) do
        deployRE:FireServer(candidates[i].uuid, true)
        deployed += 1
    end
    if deployed > 0 then Aeris.Data.Get(true) end
    return deployed
end

---@param profile table?
---@return string
function Aeris.Pet.StatusText(profile)
    local prof = profile or Aeris.Data.Get() or {}
    local petStore = prof.Pet or {}
    local pets, eggs = Aeris.Pet.Counts(petStore)
    local hatched = 0
    for _ in pairs(petStore.hatched or {}) do hatched += 1 end
    local deployed = 0
    for _, entry in pairs(petStore.have or {}) do
        if entry.Type == "Pet" and entry.DeployStartTick then deployed += 1 end
    end
    local equippedNames = {}
    local petShow = GameConfig:FindFirstChild("Pet") and GameConfig.Pet:FindFirstChild("Show") and Aeris.GameLib.Require(GameConfig.Pet.Show)
    for _, uuid in pairs(petStore.equiped or {}) do
        local entry = petStore.have and petStore.have[uuid]
        if entry then
            local name = petShow and petShow[entry.ID] and petShow[entry.ID].DisplayName or entry.ID or "Pet"
            table.insert(equippedNames, ("%s Lv.%d"):format(tostring(name), tonumber(entry.Level) or 1))
        end
    end
    local eqText = #equippedNames > 0 and table.concat(equippedNames, ", ") or "None"
    local now = (workspace.GetServerTimeNow and workspace:GetServerTimeNow()) or (workspace:GetAttribute("ServerTime") or os.time())
    local hatchTimers = {}
    for _, uuid in pairs(petStore.hatched or {}) do
        local entry = petStore.have and petStore.have[uuid]
        if entry and entry.HatchReadyTick then
            local diff = math.max(0, math.floor(entry.HatchReadyTick - now))
            table.insert(hatchTimers, diff .. "s")
        end
    end
    local hatchDetail = #hatchTimers > 0 and (" (" .. table.concat(hatchTimers, ", ") .. ")") or ""
    return string.format(
        "Pet: %s\nBags: %d/%d Pets · %d/%d Eggs | Hatch: %d/%d%s | Deploy: %d/%d",
        tostring(eqText),
        tonumber(pets) or 0, tonumber(petStore.maxPetNum) or 25,
        tonumber(eggs) or 0, tonumber(petStore.maxEggNum) or 25,
        tonumber(hatched) or 0, tonumber(petStore.maxHatchNum) or 3,
        tostring(hatchDetail or ""),
        tonumber(deployed) or 0, tonumber(petStore.maxDeployNum) or 2
    )
end

---@return Humanoid?
function Aeris.Movement.Humanoid()
    return LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
end

function Aeris.Movement.Apply()
    local hum = Aeris.Movement.Humanoid()
    if not hum then return end
    hum.WalkSpeed = State.Opt.SpeedOn and State.Opt.WalkSpeed or (LocalPlayer:GetAttribute("OriWalkSpeed") or 22)
end

function Aeris.Movement.Bind()
    table.insert(State.Conns, UserInputService.JumpRequest:Connect(function()
        local hum = Aeris.Movement.Humanoid()
        if State.Opt.InfJump and hum then
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end
    end))
    table.insert(State.Conns, LocalPlayer.CharacterAdded:Connect(function()
        task.wait(1)
        Aeris.Movement.Apply()
    end))
end

---@param enabled boolean
function Aeris.Session.SetLowGraphics(enabled)
    RunService:Set3dRenderingEnabled(not enabled)
end

function Aeris.Session.Rejoin()
    local queue = queue_on_teleport or queueonteleport
    if queue then queue(Config.ReloadSource) end
    TeleportService:Teleport(game.PlaceId, LocalPlayer)
end

---@return boolean
function Aeris.Session.HopSmallest()
    local body = Aeris.Util.HttpGet(("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId))
    local ok, list = pcall(HttpService.JSONDecode, HttpService, body or "")
    local best
    for _, server in ipairs(ok and type(list) == "table" and type(list.data) == "table" and list.data or {}) do
        if server.id == game.JobId or server.playing >= server.maxPlayers then continue end
        if not best or server.playing < best.playing then best = server end
    end
    if not best then return false end
    local queue = queue_on_teleport or queueonteleport
    if queue then queue(Config.ReloadSource) end
    TeleportService:TeleportToPlaceInstance(game.PlaceId, best.id, LocalPlayer)
    return true
end

---@return boolean
function Aeris.Session.SavePosition()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    State.SavedSpot = root and root.CFrame
    return State.SavedSpot ~= nil
end

---@return boolean
function Aeris.Session.ReturnPosition()
    local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not (root and State.SavedSpot) then return false end
    root.CFrame = State.SavedSpot
    return true
end

---@param enabled boolean
function Aeris.Boss.HopFlag(enabled)
    local flag = Config.SaveFolder .. "/" .. Config.BossHopFlag
    pcall(function()
        if enabled then
            if not isfolder(Config.SaveFolder) then makefolder(Config.SaveFolder) end
            writefile(flag, tostring(os.time()))
        elseif isfile(flag) then
            delfile(flag)
        end
    end)
end

---@return number?
function Aeris.Boss.SinceLastHop()
    local ok, stamp = pcall(readfile, Config.SaveFolder .. "/" .. Config.BossHopFlag)
    if not ok or not tonumber(stamp) then return nil end
    return os.time() - tonumber(stamp)
end

---@return boolean
function Aeris.Boss.HopWanted()
    local since = Aeris.Boss.SinceLastHop()
    return since ~= nil and since < Config.BossHopResume
end

---@return string[], number
function Aeris.Boss.LoadServers()
    local ok, text = pcall(readfile, Config.SaveFolder .. "/" .. Config.BossHopServers)
    if not ok then return {}, 0 end
    local decoded
    ok, decoded = pcall(HttpService.JSONDecode, HttpService, text)
    if not ok or type(decoded) ~= "table" or type(decoded.ids) ~= "table" then return {}, 0 end
    local fetchedAt = tonumber(decoded.at) or 0
    if os.time() - fetchedAt > Config.HopListTtl then return {}, 0 end
    return decoded.ids, fetchedAt
end

---@param ids string[]
---@param fetchedAt number
function Aeris.Boss.SaveServers(ids, fetchedAt)
    pcall(function()
        if not isfolder(Config.SaveFolder) then makefolder(Config.SaveFolder) end
        writefile(Config.SaveFolder .. "/" .. Config.BossHopServers, HttpService:JSONEncode({ at = fetchedAt, ids = ids }))
    end)
end

---@return string[]
function Aeris.Boss.FetchServers()
    if os.clock() < State.HopBlockedUntil then return {} end
    local body = Aeris.Util.HttpGet(("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=Asc&limit=100"):format(game.PlaceId))
    local ok, list = pcall(HttpService.JSONDecode, HttpService, body or "")
    local ids = {}
    for _, server in ipairs(ok and type(list) == "table" and type(list.data) == "table" and list.data or {}) do
        if server.id ~= game.JobId and server.playing < server.maxPlayers then table.insert(ids, server.id) end
    end
    if #ids > 0 then
        State.HopFails, State.HopBackoff = 0, nil
        return ids
    end
    State.HopFails += 1
    State.HopBackoff = math.min((State.HopBackoff or Config.HopBackoffStart / 2) * 2, Config.HopBackoffMax)
    State.HopBlockedUntil = os.clock() + State.HopBackoff
    warn("[Aeris] server list refused, retry in", State.HopBackoff, "s, fail", State.HopFails)
    return {}
end

---@return string?
function Aeris.Boss.PickServer()
    local ids, fetchedAt = Aeris.Boss.LoadServers()
    if #ids == 0 then
        ids, fetchedAt = Aeris.Boss.FetchServers(), os.time()
    end
    while #ids > 0 do
        local serverId = table.remove(ids, math.random(#ids))
        if serverId ~= game.JobId then
            Aeris.Boss.SaveServers(ids, fetchedAt)
            return serverId
        end
    end
    Aeris.Boss.SaveServers(ids, fetchedAt)
    return nil
end

function Aeris.Boss.Hop()
    local serverId = Aeris.Boss.PickServer()
    if not serverId then return end
    State.BossHopping = os.clock()
    Aeris.Boss.HopFlag(true)
    local queue = queue_on_teleport or queueonteleport
    if queue and not State.HopQueued then
        queue(Config.ReloadSource)
        State.HopQueued = true
    end
    TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, LocalPlayer)
end

---@return boolean
function Aeris.Boss.WorthStaying()
    if State.BossLooting and os.clock() - State.BossLooting < Config.BossLootTimeout then return true end
    local boss = workspace:GetAttribute("CurrentWorldBoss")
    if boss and not State.BossDone then return true end
    if State.BossDone then return os.clock() - State.BossDone < Config.BossHopAfter end
    local nextTick, serverTime = workspace:GetAttribute("NextWorldBossTick"), workspace:GetAttribute("ServerTime")
    if not nextTick or not serverTime then return true end
    return nextTick - serverTime <= State.Opt.BossWaitMinutes * 60
end

function Aeris.Boss.HopGiveUp()
    State.Opt.BossHop = false
    Aeris.Boss.HopFlag(false)
    table.insert(State.Halted, { "BossHop", "no server list from Roblox, try again later" })
end

function Aeris.Boss.HopStep()
    if State.BossHopping then
        if os.clock() - State.BossHopping < Config.HopStall then return end
        State.BossHopping = false
    end
    if Aeris.Boss.WorthStaying() then return end
    if (Aeris.Boss.SinceLastHop() or Config.HopGap) < Config.HopGap then return end
    if State.HopFails >= Config.HopGiveUp then
        Aeris.Boss.HopGiveUp()
        return
    end
    Aeris.Boss.Hop()
end

function Aeris.Session.Bind()
    table.insert(State.Conns, TeleportService.TeleportInitFailed:Connect(function()
        if not State.BossHopping then return end
        State.BossHopping = false
        task.delay(1, Aeris.Util.Try, Aeris.Boss.HopStep)
    end))
    table.insert(State.Conns, LocalPlayer.Idled:Connect(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new())
    end))
    table.insert(State.Conns, GuiService.ErrorMessageChanged:Connect(function(msg)
        if State.Opt.AutoRejoin and msg ~= "" and not State.Rejoining then
            State.Rejoining = true
            task.delay(Config.RejoinDelay, Aeris.Session.Rejoin)
        end
    end))
end

Aeris.Scheduler.Jobs = {
    { key = "SuperLootAura", every = Config.KillAuraInterval, run = function() Aeris.SuperLoot.Step() end },
    { key = "AutoBattle", every = Config.KillAuraInterval, run = function() Aeris.Stage.BattleStep() end },
    { key = "AutoCheckIn", every = Config.ClaimInterval, run = function() Aeris.Claim.CheckIn() end },
    { key = "MaxGear", every = 0, run = function() Aeris.Gear.MaxStep() end },
    { key = "CollectOre", every = 0, run = function() Aeris.Stage.Collect(State.Opt.Stage or Aeris.Stage.Best(), State.Opt.CollectRarities) end },
    { key = "AutoForge", every = 0, run = function() Aeris.Forge.Step() end },
    { key = "AutoEquip", every = Config.EquipInterval, run = function() Aeris.Gear.EquipBest() end },
    { key = "AutoSell", every = Config.SellInterval, run = function() Aeris.Sell.Run(Aeris.Data.Get()) end },
    { key = "AutoTrain", every = 1, run = function() Aeris.Level.TrainStep() end },
    { key = "AutoRebirth", every = Config.RebirthInterval, run = function() Aeris.Level.RebirthStep() end },
    { key = "AutoUpgrade", every = Config.UpgradeInterval, run = function() Aeris.Upgrade.BuySelected() end },
    { key = "AutoTower", every = 0, run = function() Aeris.Tower.FarmStep() end },
    { key = "AutoWorldBoss", every = Config.BossInterval, run = function() Aeris.Boss.Step() end },
    { key = "BossHop", every = Config.BossHopInterval, run = function() Aeris.Boss.HopStep() end },
    { key = "AutoClaim", every = Config.ClaimInterval, run = function() Aeris.Claim.All() end },
    { key = "AutoSeason", every = Config.SeasonInterval, run = function() Aeris.Season.Step() end },
    { key = "AutoTokenShop", every = Config.TokenShopInterval, run = function() Aeris.TokenShop.BuyAll() end },
    { key = "AutoBestRace", every = 10, run = function() Aeris.Race.EquipBest() end },
    { key = "TurboSpawn", every = 0, run = function() Aeris.Spawn.TurboStep() end },
    { key = "AutoChaseTargetPet", every = 1, run = function() Aeris.Pet.ChaseStep() end },
    { key = "AutoHatchEgg", every = 1, run = function() Aeris.Pet.HatchStep() end },
    { key = "AutoEquipPet", every = Config.PetInterval, run = function() Aeris.Pet.EquipBest() end },
    { key = "AutoFeedPet", every = Config.PetInterval, run = function() Aeris.Pet.FeedBest() end },
    { key = "AutoDeployPet", every = Config.PetDeployInterval, run = function() Aeris.Pet.DeployStep() end },
    { key = "AutoSellPet", every = Config.SellInterval, run = function() Aeris.Pet.CleanBag() end },
    { key = "AutoIndex", every = Config.IndexInterval, run = function() Aeris.Util.Exclusive("Index", Aeris.Index.HuntAll) end },
}

---@param key string
---@param fn function
function Aeris.Scheduler.Run(key, fn)
    if not State.Alive or State.JobRunning[key] then return end
    local result
    local thread = task.defer(function() result = table.pack(pcall(fn)) end)
    State.JobRunning[key] = thread
    local deadline = os.clock() + State.Opt.JobTimeout
    local toggleJob = type(State.Opt[key]) == "boolean"
    while State.Alive and (not toggleJob or State.Opt[key]) and not result and os.clock() < deadline do task.wait(0.05) end
    if not result then
        Aeris.Util.CancelTree(thread)
        result = { false, "job timed out" }
    end
    State.JobRunning[key] = nil
    if not State.Alive or (toggleJob and not State.Opt[key]) then return end
    local ok, err = result[1], result[2]
    State.JobStats[key] = { ok = ok, at = os.clock(), error = not ok and tostring(err) or nil }
    local failures = State.Failures
    if ok then
        failures[key] = nil
        return
    end

    local streak = failures[key]
    if not streak then
        streak = { count = 0, since = os.clock() }
        failures[key] = streak
        Aeris.Util.WarnJob(key, err)
    end
    streak.count += 1
    if streak.count < Config.MaxFailures or os.clock() - streak.since < Config.FailWindow then return end

    failures[key] = nil
    State.Opt[key] = false
    local reason = tostring(err):match("[^\n]*")
    warn("[Aeris]", key, "stopped:", reason)
    table.insert(State.Halted, { key, reason })
end

Aeris.Scheduler.Groups = {
    SuperLootAura = "combat", KillAura = "combat", AutoBattle = "combat", AutoWorldBoss = "combat",
    AutoTrain = "train", AutoClick = "train", AutoRebirth = "train",
    AutoHatchEgg = "pet", AutoEquipPet = "pet", AutoFeedPet = "pet", AutoDeployPet = "pet", AutoSellPet = "pet",
    BossHop = "travel",
}

function Aeris.Scheduler.Step()
    if not State.Alive then return end
    local now = os.clock()
    if State.Lock and State.LockTime and (now - State.LockTime > 12) then
        State.Lock = nil
        State.LockOwner = nil
        State.LockTime = 0
    end
    if State.Lock then return end

    local active = 0
    for _ in pairs(State.JobGroups) do active += 1 end
    local jobs = Aeris.Scheduler.Jobs
    local cursor = State.ScheduleCursor or 0
    State.ScheduleCursor = cursor % #jobs + 1
    for offset = 1, #jobs do
        if active >= math.clamp(State.Opt.ParallelJobs, 1, 8) then break end
        local index = (cursor + offset - 1) % #jobs + 1
        local job = jobs[index]
        local group = Aeris.Scheduler.Groups[job.key] or "inventory"
        if not State.Opt[job.key] or State.JobRunning[job.key] or State.JobGroups[group] then continue end
        if now - (State.LastRun[job.key] or 0) < job.every then continue end
        State.LastRun[job.key] = now
        active += 1
        local monitor
        monitor = task.defer(function()
            local ok, err = pcall(Aeris.Scheduler.Run, job.key, job.run)
            if State.JobGroups[group] == monitor then State.JobGroups[group] = nil end
            if not ok and State.Alive then Aeris.Util.WarnJob(job.key, err) end
        end)
        State.JobGroups[group] = monitor
    end
end

function Aeris.Scheduler.Start()
    task.spawn(function()
        while State.Alive do
            if not State.Busy then
                State.Busy = true
                Aeris.Util.Try(Aeris.Scheduler.Step)
                State.Busy = false
            end
            task.wait(Config.TickDelay)
        end
    end)
end

function Aeris.Scheduler.Boot()
    for _, bind in ipairs({ Aeris.Movement.Bind, Aeris.Level.Bind, Aeris.SuperLoot.Bind, Aeris.Boss.Bind, Aeris.Pet.Bind, Aeris.Session.Bind }) do
        Aeris.Util.Try(bind)
    end
    Aeris.Scheduler.Start()
end

function Aeris.Scheduler.Stop()
    State.Alive = false
    for _, threads in pairs(State.WorkerBatches) do
        for _, thread in ipairs(threads) do pcall(task.cancel, thread) end
    end
    for _, thread in pairs(State.JobRunning) do pcall(task.cancel, thread) end
    for _, monitor in pairs(State.JobGroups) do Aeris.Util.CancelTree(monitor) end
    for owner in pairs(State.ChildThreads) do Aeris.Util.CancelTree(owner) end
    table.clear(State.JobGroups)
    table.clear(State.ChildThreads)
    State.Lock = nil
    State.LockOwner = nil
    State.LockTime = 0
    table.clear(State.WorkerBatches)
    table.clear(State.JobRunning)
    table.clear(State.LootQueue)
    table.clear(State.LootSeen)
    table.clear(State.LootPending)
    for _, conn in ipairs(State.Conns) do
        conn:Disconnect()
    end
    table.clear(State.Conns)
    if State.Opt.AutoTrain then
        State.Opt.AutoTrain = false
        task.spawn(Aeris.Util.Try, Aeris.Level.SetTraining, false)
    end
    if State.Opt.SpeedOn then
        State.Opt.SpeedOn = false
        Aeris.Movement.Apply()
    end
    if State.Opt.LowGraphics then
        Aeris.Session.SetLowGraphics(false)
    end
    Aeris.Util.Try(Aeris.Pet.MuteAnim, false)
    Aeris.Util.Try(Aeris.Tower.Exit)
    if LocalPlayer:GetAttribute("IntoFight") == "WorldBoss" then Aeris.Util.Try(Aeris.Boss.Leave) end
    Aeris.Guard.Stop()
end

local function BuildInterface()
    local Rayfield = LoadRayfield()
    if not Rayfield then return end

    pcall(AerisBanner.Step, "UI library")
    local T = function(en, th) return en end
    local opt = State.Opt
    local Options = {}
    local featureNames = {}
    local uiQueue = {}
    local statusLabel, gearLabel, taskLabel
    local unloadCallbacks = {}

    local Library = {
        Options = Options,
        Notify = function(self, title, msg, seconds, kind)
            pcall(function()
                Rayfield:Notify({
                    Title = "Aeris",
                    Content = tostring(msg or ""),
                    Duration = seconds or 4,
                    Image = 94398897297532,
                })
            end)
        end,
        Unload = function(self)
            pcall(function() Rayfield:Destroy() end)
        end,
        OnUnload = function(self, cb)
            table.insert(unloadCallbacks, cb)
        end,
        LoadAutoloadConfig = function(self) end,
        Compat = { Caps = {}, Block = function() end, NeedCap = function() end },
    }
    Aeris.Compat = Library.Compat

    local function Later(fn, ...)
        local args = table.pack(...)
        table.insert(uiQueue, function()
            fn(table.unpack(args, 1, args.n))
        end)
    end

    local function Notify(msg, kind, seconds)
        pcall(function()
            Rayfield:Notify({
                Title = "Aeris",
                Content = tostring(msg or ""),
                Duration = seconds or 4,
                Image = 94398897297532,
            })
        end)
    end

    local function TurnOff(key)
        local toggle = Options[key]
        if toggle and toggle.Value then
            toggle:SetValue(false)
        end
    end

    local function SetList(idx, values, pickFirst)
        local dropdown = Options[idx]
        if not dropdown then return end
        dropdown:SetValues(values)
        if pickFirst and values[1] then
            dropdown:SetValue(values[1])
        elseif dropdown.Value ~= opt[idx] then
            dropdown:SetValue(dropdown.Value)
        end
    end

    local function NeedModule(option, module)
        if Aeris.GameLib.Require(module) then return end
        Aeris.Compat.Block(option, "Not available on this executor")
    end

    local function BlockMissing()
        for idx, paths in pairs(Aeris.GameLib.Missing()) do
            warn("[Aeris]", idx, "blocked, missing:", table.concat(paths, ", "))
            if Options[idx] then Aeris.Compat.Block(Options[idx], "Not available after a game update") end
        end
    end

    local function Pump()
        for _, halt in ipairs(State.Halted) do
            TurnOff(halt[1])
            Notify(("%s stopped: %s"):format(featureNames[halt[1]] or halt[1], halt[2]), "Warning")
        end
        table.clear(State.Halted)

        local jobs = uiQueue
        uiQueue = {}
        for _, job in ipairs(jobs) do
            Aeris.Util.Try(job)
        end
    end

    local actionId = 0
    local function Action(action)
        actionId += 1
        local key = "Action:" .. actionId
        return function()
            if not State.Alive or State.JobRunning[key] then return end
            task.defer(Aeris.Scheduler.Run, key, action)
        end
    end

    local function LongAction(name, action, done)
        return Action(function()
            if State.Lock then return Notify("Busy: " .. State.Lock, "Warning") end
            Notify(name .. "...")
            local acquired, outcome = Aeris.Util.Exclusive(name, action)
            if not acquired then return Notify("An inventory task is still running; retry when it finishes", "Warning") end
            if done then Notify(done(outcome), (outcome == false or outcome == nil or outcome == 0) and "Warning" or "Success") end
        end)
    end

    local function Source(fn)
        local ok, first, second = pcall(fn)
        if not ok then
            warn("[Aeris] menu data:", first)
            return {}, {}
        end
        return first or {}, second or {}
    end

    local rarityNames = Source(Aeris.Util.RarityNames)

    local function WrapTab(rayfieldTab)
        local tabObj = {}

        function tabObj:AddSection(title)
            pcall(function() rayfieldTab:CreateSection(tostring(title or "")) end)
            return self
        end

        function tabObj:AddLeftGroupbox(title)
            return self:AddSection(title)
        end

        function tabObj:AddRightGroupbox(title)
            return self:AddSection(title)
        end

        function tabObj:AddToggle(key, spec)
            local name = type(spec.Text) == "table" and spec.Text.EN or tostring(spec.Text or key)
            featureNames[key] = name
            local toggle = rayfieldTab:CreateToggle({
                Name = name,
                Info = type(spec.Description) == "table" and spec.Description.EN or spec.Description,
                CurrentValue = opt[key] or false,
                Flag = key,
                Callback = function(value)
                    opt[key] = value
                    if Options[key] then Options[key].Value = value end
                    if spec.Callback then spec.Callback(value) end
                end,
            })
            local toggleObj = {
                Value = opt[key] or false,
                SetValue = function(self, value)
                    self.Value = value
                    opt[key] = value
                    pcall(function() toggle:Set(value) end)
                end,
                Set = function(self, value)
                    self:SetValue(value)
                end,
                AddKeyPicker = function(self, keyName, keySpec)
                    pcall(function()
                        rayfieldTab:CreateKeybind({
                            Name = name .. " Key",
                            CurrentKeybind = keySpec.Default ~= "None" and keySpec.Default or "Unknown",
                            HoldToInteract = false,
                            Flag = keyName,
                            Callback = function()
                                self:SetValue(not self.Value)
                            end,
                        })
                    end)
                    return self
                end,
            }
            Options[key] = toggleObj
            return toggleObj
        end

        function tabObj:AddCheckbox(key, spec)
            return self:AddToggle(key, spec)
        end

        function tabObj:AddSlider(key, spec)
            local rounding = spec.Rounding or 0
            local increment = rounding == 0 and 1 or (1 / (10 ^ rounding))
            local name = type(spec.Text) == "table" and spec.Text.EN or tostring(spec.Text or key)
            local slider = rayfieldTab:CreateSlider({
                Name = name,
                Info = type(spec.Description) == "table" and spec.Description.EN or spec.Description,
                Range = { spec.Min or 0, spec.Max or 100 },
                Increment = increment,
                Suffix = spec.Suffix or (spec.Prefix and (" " .. spec.Prefix) or ""),
                CurrentValue = spec.Default or opt[key] or spec.Min or 0,
                Flag = key,
                Callback = function(val)
                    opt[key] = val
                    if Options[key] then Options[key].Value = val end
                    if spec.Callback then spec.Callback(val) end
                end,
            })
            local sliderObj = {
                Value = spec.Default or opt[key],
                SetValue = function(self, val)
                    self.Value = val
                    opt[key] = val
                    pcall(function() slider:Set(val) end)
                end,
                Set = function(self, val)
                    self:SetValue(val)
                end,
            }
            Options[key] = sliderObj
            return sliderObj
        end

        function tabObj:AddDropdown(key, spec)
            local isMulti = spec.Multi or false
            local text = type(spec.Text) == "table" and spec.Text.EN or tostring(spec.Text or key)
            local info = type(spec.Description) == "table" and spec.Description.EN or spec.Description
            local values = spec.Values or {}
            local default = spec.Default
            local cb = spec.Callback

            local currentOpt = {}
            if isMulti then
                if type(default) == "table" then
                    for k, v in pairs(default) do
                        if v == true then
                            table.insert(currentOpt, tostring(k))
                        elseif type(k) == "number" then
                            table.insert(currentOpt, tostring(v))
                        end
                    end
                end
            else
                if type(default) == "number" and values[default] then
                    currentOpt = { tostring(values[default]) }
                elseif type(default) == "string" then
                    currentOpt = { default }
                elseif values[1] then
                    currentOpt = { tostring(values[1]) }
                end
            end

            local dropdown = rayfieldTab:CreateDropdown({
                Name = text,
                Info = info,
                Options = values,
                CurrentOption = currentOpt,
                MultipleOptions = isMulti,
                Flag = key,
                Callback = function(selected)
                    if isMulti then
                        local set = {}
                        if type(selected) == "table" then
                            for _, v in ipairs(selected) do set[v] = true end
                        elseif type(selected) == "string" then
                            set[selected] = true
                        end
                        opt[key] = set
                        if Options[key] then Options[key].Value = set end
                        if cb then cb(set) end
                    else
                        local val = type(selected) == "table" and selected[1] or selected
                        opt[key] = val
                        if Options[key] then Options[key].Value = val end
                        if cb then cb(val) end
                    end
                end,
            })

            local dropdownObj = {
                Value = isMulti and (spec.Default or {}) or (currentOpt[1] or ""),
                Values = values,
                SetValue = function(self, val)
                    self.Value = val
                    if isMulti then
                        local list = {}
                        if type(val) == "table" then
                            for k, v in pairs(val) do
                                if v == true then table.insert(list, tostring(k))
                                elseif type(k) == "number" then table.insert(list, tostring(v)) end
                            end
                        end
                        pcall(function() dropdown:Set(list) end)
                    else
                        pcall(function() dropdown:Set(type(val) == "table" and val or { tostring(val) }) end)
                    end
                end,
                SetValues = function(self, newValues)
                    self.Values = newValues or {}
                    pcall(function() dropdown:Refresh(newValues or {}) end)
                end,
                SetImages = function(self) end,
            }
            Options[key] = dropdownObj
            return dropdownObj
        end

        function tabObj:AddInput(key, spec)
            local name = type(spec.Text) == "table" and spec.Text.EN or tostring(spec.Text or key)
            local input = rayfieldTab:CreateInput({
                Name = name,
                Info = type(spec.Description) == "table" and spec.Description.EN or spec.Description,
                PlaceholderText = tostring(opt[key] or spec.Default or "0"),
                NumbersOnly = spec.Numeric or false,
                OnEnter = true,
                RemoveTextAfterFocusLost = false,
                Callback = function(value)
                    local val = spec.Numeric and (tonumber(value) or opt[key] or 0) or value
                    opt[key] = val
                    if Options[key] then Options[key].Value = val end
                    if spec.Callback then spec.Callback(val) end
                end,
            })
            local inputObj = {
                Value = opt[key] or spec.Default,
                SetValue = function(self, val)
                    self.Value = val
                    opt[key] = val
                    pcall(function() input:Set(tostring(val)) end)
                end,
                Set = function(self, val)
                    self:SetValue(val)
                end,
            }
            Options[key] = inputObj
            return inputObj
        end

        function tabObj:AddButton(spec)
            local name = type(spec.Text) == "table" and spec.Text.EN or tostring(spec.Text or "Button")
            rayfieldTab:CreateButton({
                Name = name,
                Callback = spec.Func,
            })
            local btnObj = {}
            function btnObj:AddButton(subSpec)
                if subSpec and subSpec.Text and subSpec.Func then
                    local subName = type(subSpec.Text) == "table" and subSpec.Text.EN or tostring(subSpec.Text)
                    rayfieldTab:CreateButton({
                        Name = subName,
                        Callback = subSpec.Func,
                    })
                end
                return self
            end
            return btnObj
        end

        function tabObj:AddParagraph(spec)
            return rayfieldTab:CreateParagraph({
                Title = spec.Title or "",
                Content = spec.Content or "",
            })
        end

        function tabObj:AddLabel(text)
            local title = type(text) == "table" and text.EN or tostring(text or "")
            local p = rayfieldTab:CreateParagraph({
                Title = title,
                Content = "",
            })
            local labelObj = {
                SetText = function(self, newText)
                    pcall(function()
                        p:Set({ Title = title, Content = tostring(newText or "") })
                    end)
                end,
            }
            return labelObj
        end

        function tabObj:AddDivider()
            pcall(function() rayfieldTab:CreateDivider() end)
            return self
        end

        return tabObj
    end

    local function Toggle(group, key, text, description, onChange)
        local t = type(text) == "table" and text.EN or tostring(text or key)
        local d = type(description) == "table" and description.EN or description
        featureNames[key] = t
        return group:AddToggle(key, {
            Text = t,
            Description = d,
            Default = opt[key],
            Callback = function(value)
                opt[key] = value
                if onChange then onChange(value) end
            end,
        })
    end

    local Feature = Toggle

    local function HotkeyFeature(group, key, text, description, onChange)
        return Toggle(group, key, text, description, onChange):AddKeyPicker(key .. "Key", { Default = "None", Mode = "Toggle" })
    end

    local function Check(group, key, text)
        local t = type(text) == "table" and text.EN or tostring(text or key)
        return group:AddCheckbox(key, {
            Text = t,
            Default = opt[key],
            Callback = function(value)
                opt[key] = value
            end,
        })
    end

    local function MultiSelect(group, key, text, description, values)
        opt[key] = Aeris.Util.AllSet(values)
        local t = type(text) == "table" and text.EN or tostring(text or key)
        local d = type(description) == "table" and description.EN or description
        return group:AddDropdown(key, {
            Text = t,
            Description = d,
            Values = values,
            Multi = true,
            Default = values,
            Callback = function(selected)
                opt[key] = selected
            end,
        })
    end

    local function Pick(group, key, text, description, source, noSave)
        local values = Source(source)
        opt[key] = values[1]
        local t = type(text) == "table" and text.EN or tostring(text or key)
        local d = type(description) == "table" and description.EN or description
        return group:AddDropdown(key, {
            Text = t,
            Description = d,
            Values = values,
            Default = 1,
            NoSave = noSave,
            Callback = function(value)
                opt[key] = value
            end,
        })
    end

    local function NumberInput(group, key, text, description, minimum)
        local t = type(text) == "table" and text.EN or tostring(text or key)
        local d = type(description) == "table" and description.EN or description
        return group:AddInput(key, {
            Text = t,
            Description = d,
            Default = tostring(opt[key]),
            Numeric = true,
            Callback = function(value)
                opt[key] = math.max(minimum or 0, math.floor(tonumber(value) or opt[key]))
            end,
        })
    end

    local function Decorate(idx, idOf)
    end

    local function OreId(label)
        return State.OreLabels and State.OreLabels[label]
    end

    local function RefreshButton(idx, list)
        return {
            Text = "Refresh",
            Func = function()
                task.defer(function()
                    Later(SetList, idx, (Source(list)))
                end)
            end,
        }
    end

    local Window = Rayfield:CreateWindow({
        Name = "Aeris | Loot To Forge",
        Icon = 94398897297532,
        LoadingTitle = "Aeris",
        LoadingSubtitle = "by Team Aeris",
        Theme = "Amethyst",
        DisableRayfieldPrompts = true,
        DisableBuildWarnings = true,
        ConfigurationSaving = {
            Enabled = true,
            FolderName = "Aeris",
            FileName = "LootToForge"
        },
        KeySystem = false,
    })

    local WindowObj = {
        AddTab = function(self, title, icon, desc)
            local rTab = Window:CreateTab(type(title) == "table" and title.EN or tostring(title), icon or 0)
            return WrapTab(rTab)
        end,
        AddTabSection = function(self, title)
        end,
        AddSettingsTab = function(self)
            local rTab = Window:CreateTab("Settings", "settings")
            return WrapTab(rTab)
        end,
    }
    local function BuildMain(tab)
        local statusBox = tab:AddLeftGroupbox(T("Status", "สถานะ"))
        statusLabel = statusBox:AddLabel("Loading...")
        gearLabel = statusBox:AddLabel("Equipped: -")
        taskLabel = statusBox:AddLabel("Working on: Idle")

        local kaitunBox = tab:AddLeftGroupbox(T("Kaitun", "ไก่ตัน"))
        kaitunBox:AddToggle("Kaitun", {
            Text = T("Kaitun (All-in-one)", "ไก่ตัน (ทำทุกอย่าง)"),
            Description = T("Best gear, money, level, rewards and bosses all at once", "ของดีสุด เงิน เลเวล รางวัล และบอส ทำพร้อมกันทั้งหมด"),
            NoSave = true,
            Callback = function(value)
                for _, key in ipairs(Config.KaitunToggles) do
                    if Options[key] then Options[key]:SetValue(value) end
                end
            end,
        })

        local logBox = tab:AddRightGroupbox(T("Update Log", "อัปเดตล่าสุด"), "bell")
        for i = 1, math.min(2, #Config.UpdateLog) do
            local entry = Config.UpdateLog[i]
            logBox:AddParagraph({ Title = entry[1], Content = entry[2] })
        end

        local rewardBox = tab:AddLeftGroupbox(T("Rewards", "รางวัล"))
        Feature(rewardBox, "AutoClaim", T("Auto Claim", "รับรางวัลอัตโนมัติ"), T("Claims every free reward, including index", "รับรางวัลฟรีทุกอย่าง รวมสมุดสะสม"))
        rewardBox:AddButton({ Text = T("Claim Now", "รับเดี๋ยวนี้"), Style = "Success", Func = Action(Aeris.Claim.All) })
        Feature(rewardBox, "AutoCheckIn", T("Auto 30-Day Check-In", "รับเช็กอิน 30 วันอัตโนมัติ"), T("Claims every signed day that still has an unclaimed reward", "รับรางวัลทุกวันที่เช็กอินแล้วและยังไม่ได้รับ"))
        rewardBox:AddButton({ Text = T("Claim Check-In Now", "รับรางวัลเช็กอินเดี๋ยวนี้"), Func = LongAction("Check-In", Aeris.Claim.CheckIn, function(count)
            return ("Claimed %d check-in rewards"):format(count or 0)
        end) })
        rewardBox:AddButton({ Text = T("Redeem All Codes", "ใช้โค้ดทั้งหมด"), Style = "Primary", Func = Action(function()
            Notify(Aeris.Claim.AllCodes(), "Success", 6)
        end) })
    end

    local function BuildGear(tab)
        local formBox = tab:AddRightGroupbox(T("Dual Form", "อุปกรณ์สองร่าง"))
        formBox:AddLabel(T("Switch equipped dual-form gear between A and B", "สลับ A/B ของอุปกรณ์สองร่างที่ใส่อยู่"))
        for _, slot in ipairs(Config.GearTypes) do
            formBox:AddButton({ Text = T("Switch " .. slot .. " Form", "สลับร่าง " .. slot), Func = Action(function()
                local changed = Aeris.Gear.SwitchForm(slot)
                Notify(changed and "Form switched" or "Equip dual-form gear in this slot first", changed and "Success" or "Info")
            end) })
        end

        local gearBox = tab:AddLeftGroupbox(T("Max Gear", "อุปกรณ์สูงสุด"))
        Feature(gearBox, "MaxGear", T("Max Gear", "อุปกรณ์สูงสุด"),
            T("Best gear and runes, enhanced to your target. Finds anything missing by itself", "ของดีสุด รูนดีสุด ตีบวกถึงเป้า ขาดอะไรหาเองหมด"),
            function()
                State.GearForged = false
            end)
        Check(gearBox, "GearForge", T("Forge gear automatically", "หลอมของอัตโนมัติ"))
        Check(gearBox, "GearEnchant", T("Equip runes automatically", "ใส่รูนอัตโนมัติ"))
        Check(gearBox, "GearEnhance", T("Enhance automatically", "ตีบวกอัตโนมัติ"))
        gearBox:AddSlider("EnhanceTarget", {
            Text = T("Enhance Target", "ตีบวกถึง"),
            Description = T("Above +10 the success rate gets very low and can take a long time", "เกิน +10 โอกาสสำเร็จต่ำมาก อาจใช้เวลานาน"),
            Min = 5, Max = 20, Default = opt.EnhanceTarget, Rounding = 0, Prefix = "+",
            Callback = function(value)
                opt.EnhanceTarget = value
            end,
        })
        local runes = Aeris.Gear.RuneOrder()
        opt.EnchantPriority = table.clone(runes)
        gearBox:AddDropdown("EnchantPriority", {
            Text = T("Runes To Use", "รูนที่ใช้"),
            Description = T("Stronger runes go in first", "รูนที่แรงกว่าใส่ก่อน"),
            Values = runes,
            Multi = true,
            Default = runes,
            Searchable = #runes > 8,
            Callback = function(selected)
                local order = {}
                for _, stoneId in ipairs(runes) do
                    if selected[stoneId] then order[#order + 1] = stoneId end
                end
                if #order == 0 then Notify("No rune selected, using all runes", "Warning") end
                opt.EnchantPriority = order
            end,
        })

        local equipBox = tab:AddRightGroupbox(T("Equip", "ใส่ของ"))
        Feature(equipBox, "AutoEquip", T("Auto Equip", "ใส่ของอัตโนมัติ"), T("Always wears your strongest weapon, armor and hat, counting enhance level", "ใส่อาวุธ เกราะ และหมวกที่แรงที่สุดเสมอ นับระดับตีบวกด้วย"))
        equipBox:AddButton({ Text = T("Equip Now", "ใส่ของเดี๋ยวนี้"), Func = function()
            task.defer(function()
                local changed = Aeris.Gear.EquipBest()
                Notify(changed > 0 and ("Equipped %d better item(s)"):format(changed) or "Already wearing your best gear")
            end)
        end })

        equipBox:AddDivider()
        equipBox:AddDropdown("EnhanceSlot", {
            Text = T("Enhance Slot", "ช่องที่ตีบวก"),
            Values = Config.GearTypes,
            Default = opt.EnhanceSlot,
            Callback = function(value)
                opt.EnhanceSlot = value or opt.EnhanceSlot
            end,
        })
        equipBox:AddButton({ Text = T("Enhance To Target", "ตีบวกถึงเป้า"), Style = "Primary", Func = LongAction("Enhance", function()
            return Aeris.Gear.EnhanceSlot(opt.EnhanceSlot, opt.EnhanceTarget)
        end, function(level) return level and ("%s is +%d"):format(opt.EnhanceSlot, level) or "Nothing equipped there" end) })
    end

    local function BuildFarm(tab)
        local stageBox = tab:AddLeftGroupbox(T("Stage", "ด่าน"))
        Pick(stageBox, "Stage", T("Stage", "ด่าน"), T("Any stage, no unlock needed", "เลือกด่านไหนก็ได้ ไม่ต้องปลดล็อก"), Aeris.Stage.List)
        Feature(stageBox, "AutoBattle", T("Auto Battle", "เข้าด่านและฆ่าอัตโนมัติ"), T("Enters the selected stage and clears normal enemies and stage bosses", "เข้าด่านที่เลือกและฆ่ามอนสเตอร์กับบอสด่านทั้งหมด"))
        Feature(stageBox, "CollectOre", T("Auto Collect Ore", "เก็บแร่อัตโนมัติ"), T("Clears the stage and collects its ores nonstop", "เคลียร์ด่านแล้วเก็บแร่ไม่หยุด"))
        MultiSelect(stageBox, "CollectRarities", T("Ore Rarity Filter", "กรอง rarity แร่"), T("Only collect these rarities", "เก็บเฉพาะ rarity ที่เลือก"), rarityNames)

        local combatBox = tab:AddLeftGroupbox(T("Combat", "ต่อสู้"), nil, "OP")
        local killAura = Feature(combatBox, "KillAura", T("Kill Aura", "ฆ่ารอบตัว"), T("Clears all enemies across the whole map instantly", "ฆ่าศัตรูทั้งแมพทันที ยิงทะลุกำแพง ไม่จำกัดระยะ"), function(value)
            if value then Aeris.Combat.Start() end
        end)
        NeedModule(killAura, ReplicatedStorage.Utils.CommunicationUtils)
        Check(combatBox, "AuraMapWide", T("Map-Wide / Infinite Range", "โจมตีทั้งแมพ / ไม่จำกัดระยะ"))
        combatBox:AddDropdown("AuraTarget", {
            Text = T("Target Filter", "ประเภทเป้าหมาย"),
            Values = { "All", "Normal", "Super", "Boss" },
            Default = 1,
            Callback = function(value) opt.AuraTarget = value end,
        })
        NumberInput(combatBox, "AuraBatch", T("Targets Per Sweep", "เป้าหมายต่อรอบ"), T("Number of enemies processed per tick", "จำนวนศัตรูที่ประมวลผลต่อรอบ"), 1)
        combatBox:AddSlider("AuraBurst", {
            Text = T("Attack Burst (Hits/Tick)", "จำนวนฮิตต่อรอบ"), Min = 1, Max = 50,
            Default = opt.AuraBurst, Rounding = 0,
            Callback = function(value) opt.AuraBurst = tonumber(value) or 10 end,
        })
        combatBox:AddSlider("AuraInterval", {
            Text = T("Attack Interval", "ช่วงเวลาโจมตี"), Min = 0.05, Max = 1,
            Default = opt.AuraInterval, Rounding = 2, Suffix = " s",
            Callback = function(value) opt.AuraInterval = math.clamp(tonumber(value) or 0.12, 0.05, 1) end,
        })
        Check(combatBox, "AuraCritical", T("Critical Hits", "โจมตีคริติคอล"))
        Check(combatBox, "AutoCollectDrops", T("Auto Collect Drops", "เก็บของดรอปอัตโนมัติ"))
        Check(combatBox, "AuraSuper", T("Include Ore Bosses", "รวมบอสแร่"))
        Feature(combatBox, "SuperLootAura", T("Kill Ore Boss", "ฆ่าบอสแร่"), T("Handles ore bosses instantly and collects confirmed drops", "จัดการบอสแร่ทันที และรับของที่ยืนยันแล้ว"), function(value)
            if value then
                Aeris.SuperLoot.KillExisting()
            else
                for _, uuid in ipairs(State.LootQueue) do State.LootSeen[uuid] = nil end
                table.clear(State.LootQueue)
            end
        end)
        combatBox:AddButton({ Text = T("Exit Fight Now", "ออกจากการต่อสู้เดี๋ยวนี้"), Style = "Warning", Func = Action(Aeris.Stage.ExitFight) })

        local bossBox = tab:AddRightGroupbox(T("World Boss", "บอสโลก"))
        Feature(bossBox, "AutoWorldBoss", T("Auto World Boss", "บอสโลกอัตโนมัติ"), T("Joins every world boss and kills it", "เข้าบอสโลกทุกรอบแล้วฆ่า"), function(value)
            if not value and LocalPlayer:GetAttribute("IntoFight") == "WorldBoss" then task.spawn(Aeris.Util.Try, Aeris.Boss.Leave) end
        end)
        Check(bossBox, "BossCards", T("Auto Take Reward Card", "เปิดการ์ดรางวัลอัตโนมัติ"))
        Feature(bossBox, "BossHop", T("Boss Server Hop", "ย้ายเซิร์ฟหาบอส"), T("Hops to servers where the boss is up or about to spawn, kills it, then moves on", "ย้ายไปเซิร์ฟที่บอสเกิดอยู่หรือใกล้เกิด ฆ่าแล้วย้ายต่อ"), function(value)
            Aeris.Boss.HopFlag(value)
            if value and Options.AutoWorldBoss and not Options.AutoWorldBoss.Value then Options.AutoWorldBoss:SetValue(true) end
        end)
        bossBox:AddSlider("BossWaitMinutes", {
            Text = T("Wait If Boss Within", "รอถ้าบอสจะเกิดภายใน"),
            Description = T("Stays on a server when the boss spawns this soon", "อยู่เซิร์ฟเดิมถ้าบอสจะเกิดภายในเวลานี้"),
            Min = 0.5, Max = 10, Default = opt.BossWaitMinutes, Rounding = 1, Suffix = " min",
            Callback = function(value)
                opt.BossWaitMinutes = tonumber(value) or opt.BossWaitMinutes
            end,
        })

        local indexBox = tab:AddRightGroupbox(T("Index", "สมุดสะสม"))
        MultiSelect(indexBox, "IndexTypes", T("Index Types", "ประเภทที่จะเก็บ"), nil, Config.GearTypes)
        Pick(indexBox, "MissingItem", T("Missing Item", "ของที่ยังไม่มี"), T("Chance shown is per forge with the best ore", "เปอร์เซ็นต์ = โอกาสต่อการหลอมหนึ่งครั้งด้วยแร่ที่ดีที่สุด"), function()
            return { "..." }
        end, true)
        task.defer(function()
            local ok, labels = pcall(Aeris.Index.Choices)
            if ok then
                Later(SetList, "MissingItem", labels, true)
            else
                warn("[Aeris] index list:", labels)
            end
        end)
        indexBox:AddButton({ Text = T("Get Selected", "หาชิ้นนี้"), Style = "Primary", Func = LongAction("Index", function()
            local gear = State.MissingLabels[opt.MissingItem]
            return gear and Aeris.Index.Hunt(gear)
        end, function(got)
            Later(SetList, "MissingItem", (Source(Aeris.Index.Choices)))
            return got and "Got it!" or "Not found this time, press again"
        end) }):AddButton(RefreshButton("MissingItem", Aeris.Index.Choices))
        Feature(indexBox, "AutoIndex", T("Auto Complete Index", "เก็บสมุดสะสมอัตโนมัติ"), T("Forges every missing weapon, armor and hat, then claims rewards", "หลอมอาวุธ เกราะ หมวกที่ยังไม่มีทุกชิ้น แล้วรับรางวัล"), nil, true)
        indexBox:AddButton({ Text = T("Collect All Ores", "เก็บแร่ทุกชนิด"), Func = LongAction("Ores", Aeris.Index.CollectOres, function()
            local count, level = Aeris.Index.Progress()
            return ("Index %d, level %d"):format(count, level)
        end) }):AddButton({ Text = T("Claim Rewards", "รับรางวัล"), Style = "Success", Func = Action(Aeris.Index.ClaimAll) })
    end

    local function BuildForge(tab)
        local forgeBox = tab:AddLeftGroupbox(T("Forge", "หลอม"))
        local targetNames = {}
        for _, target in ipairs(Config.ForgeTargets) do
            targetNames[#targetNames + 1] = target.name
        end
        forgeBox:AddDropdown("ForgeTarget", {
            Text = T("Target Gear", "อุปกรณ์ที่จะหลอม"),
            Values = targetNames,
            Default = 1,
            Callback = function(value)
                opt.ForgeTarget = value or opt.ForgeTarget
            end,
        })
        Pick(forgeBox, "ForgeOre", T("Ore To Use", "แร่ที่ใช้หลอม"), T("Uses owned ore and farms missing stock", "ใช้แร่ที่มีและฟาร์มส่วนที่ขาด"), Aeris.Ore.ForgeChoices, nil)
        Decorate("ForgeOre", OreId)
        Feature(forgeBox, "AutoForge", T("Auto Forge", "หลอมอัตโนมัติ"), T("Forges the target gear nonstop", "หลอมอุปกรณ์ที่เลือกไม่หยุด"))
        forgeBox:AddButton({ Text = T("Forge Now", "หลอมเดี๋ยวนี้"), Style = "Primary", Func = Action(Aeris.Forge.Step) })
        forgeBox:AddSlider("ForgePerTick", {
            Text = T("Forges Per Round", "หลอมต่อรอบ"),
            Min = 1, Max = 50, Default = opt.ForgePerTick, Rounding = 0,
            Callback = function(value)
                opt.ForgePerTick = value
            end,
        })
        Check(forgeBox, "ForgeSellJunk", T("Sell worse gear right away", "ขายของที่แย่กว่าที่ใส่ทันที"))

        local oreUseBox = tab:AddRightGroupbox(T("Ore Usage", "การใช้แร่"))
        oreUseBox:AddLabel(T("Used when Ore To Use is Owned ores", "ใช้ตอนแร่ที่ใช้หลอม = Owned ores"))
        Toggle(oreUseBox, "BestOreFirst", T("Spend High Tier Ore First", "ใช้แร่ระดับสูงก่อน"), T("Off = spend the weakest ore first", "ปิด = ใช้แร่ที่อ่อนที่สุดก่อน"))
        MultiSelect(oreUseBox, "ForgeRarities", T("Forge Ore Rarity", "rarity แร่ที่ใช้หลอม"), T("Only these ore rarities are used for forging", "ใช้แร่เฉพาะ rarity ที่เลือกในการหลอม"), rarityNames)
        NumberInput(oreUseBox, "KeepPerOre", T("Keep Per Ore", "เก็บแร่ไว้ชนิดละ"), T("Never forge below this amount of each ore", "ไม่หลอมจนแร่แต่ละชนิดต่ำกว่าจำนวนนี้"))
    end

    local function BuildSell(tab)
        local sellBox = tab:AddLeftGroupbox(T("Auto Sell", "ขายอัตโนมัติ"))
        Feature(sellBox, "AutoSell", T("Auto Sell", "ขายอัตโนมัติ"), T("Sells gear that matches your filters. Equipped gear is never sold", "ขายอุปกรณ์ที่ตรงตัวกรอง ของที่ใส่อยู่จะไม่ขาย"))
        sellBox:AddButton({ Text = T("Sell All Now", "ขายทั้งหมดเดี๋ยวนี้"), Style = "Primary", Func = Action(function()
            Aeris.Sell.Run(Aeris.Data.Get())
            Notify("Sold", "Coin")
        end) })

        local filterBox = tab:AddRightGroupbox(T("Filters", "ตัวกรอง"))
        MultiSelect(filterBox, "SellTypes", T("Sell Item Types", "ประเภทที่จะขาย"), nil, Config.GearTypes)
        MultiSelect(filterBox, "SellRarities", T("Sell Rarity Filter", "กรอง rarity ที่จะขาย"), T("Only sell these rarities", "ขายเฉพาะ rarity ที่เลือก"), rarityNames)
        NumberInput(filterBox, "KeepPerItem", T("Keep Per Item", "เก็บไว้ชิ้นละ"), T("Keeps this many of each item, highest enhance first", "เก็บแต่ละไอเทมไว้ตามจำนวนนี้ เลือกตัวตีบวกสูงสุดก่อน"))
    end

    local function BuildProgress(tab)
        local trainBox = tab:AddLeftGroupbox(T("Training", "ฝึก"))
        Feature(trainBox, "AutoTrain", T("Auto Train", "ฝึกอัตโนมัติ"), T("Trains at the best area nonstop and drinks your potions", "ฝึกโซนดีสุดไม่หยุด ใช้ยาให้เอง"), function(value)
            task.spawn(Aeris.Util.Try, Aeris.Level.SetTraining, value)
        end)
        local autoClick = Feature(trainBox, "AutoClick", T("Auto Click", "คลิกอัตโนมัติ"), T("Clicks to train as fast as the game allows", "คลิกฝึกเร็วสุดเท่าที่เกมยอม"), function(value)
            if value then Aeris.Level.StartClicking() end
        end)
        NeedModule(autoClick, ReplicatedStorage.CTRL.TrainCTRL)
        Feature(trainBox, "AutoRebirth", T("Auto Rebirth", "รีเบิร์ธอัตโนมัติ"), T("Rebirths as soon as your level is high enough", "รีเบิร์ธทันทีเมื่อเลเวลถึง"))
        trainBox:AddButton({ Text = T("Rebirth Now", "รีเบิร์ธเดี๋ยวนี้"), Func = Action(Aeris.Level.Rebirth) })

        local upgradeBox = tab:AddRightGroupbox(T("Upgrades", "อัปเกรด"))
        MultiSelect(upgradeBox, "Upgrades", T("Upgrades To Buy", "อัปเกรดที่จะซื้อ"), nil, (Source(Aeris.Upgrade.Names)))
        Feature(upgradeBox, "AutoUpgrade", T("Auto Buy Upgrades", "ซื้ออัปเกรดอัตโนมัติ"), T("Buys the selected upgrades whenever possible", "ซื้ออัปเกรดที่เลือกทุกครั้งที่ซื้อได้"))
        upgradeBox:AddButton({ Text = T("Buy Upgrade Now", "ซื้ออัปเกรดเดี๋ยวนี้"), Func = Action(Aeris.Upgrade.BuySelected) })
    end

    local function BuildTower(tab)
        local towerBox = tab:AddLeftGroupbox(T("Tower", "หอคอย"))
        Feature(towerBox, "AutoTower", T("Auto Farm Tower", "ฟาร์มหอคอยอัตโนมัติ"), T("Top floor loot nonstop on one ticket: rare stones and season coins", "ของชั้นบนสุดไม่หยุดด้วยตั๋วใบเดียว ได้หินหายากและเหรียญซีซั่น"), function(value)
            task.defer(function()
                if not value then return Aeris.Util.Try(Aeris.Tower.Exit) end
                if not Aeris.Tower.Enter() then Notify("No tower ticket", "Warning") end
            end)
        end)
        towerBox:AddButton({ Text = T("Exit Tower Now", "ออกจากหอคอยเดี๋ยวนี้"), Style = "Warning", Func = function()
            Options.AutoTower:SetValue(false)
            task.spawn(Aeris.Util.Try, Aeris.Tower.Exit)
        end })

        local seasonBox = tab:AddRightGroupbox(T("Season", "ซีซั่น"))
        local goodLabels, goodIds = Source(Aeris.Season.Goods)
        local goodDefault = {}
        for label, goodId in pairs(goodIds) do
            if opt.SeasonGoods[goodId] then table.insert(goodDefault, label) end
        end
        Feature(seasonBox, "AutoSeason", T("Auto Season", "ซีซั่นอัตโนมัติ"), T("Daily ticket, pass rewards, spins and shop", "ตั๋วรายวัน รางวัลพาส สุ่ม และร้าน"))
        seasonBox:AddButton({ Text = T("Season Now", "ซีซั่นเดี๋ยวนี้"), Func = Action(Aeris.Season.Step) })
        Check(seasonBox, "SeasonSpin", T("Auto Spin Tickets", "สุ่มตั๋วอัตโนมัติ"))
        NumberInput(seasonBox, "SeasonSpinBatch", T("Spins Per Cycle", "สุ่มต่อรอบ"), T("1–50; remaining tickets continue next cycle", "1–50 ตั๋วที่เหลือสุ่มรอบถัดไป"), 1)
        seasonBox:AddDropdown("SeasonGoods", {
            Text = T("Shop Items To Buy", "ของในร้านที่จะซื้อ"),
            Values = goodLabels,
            Multi = true,
            Default = goodDefault,
            Searchable = #goodLabels > 8,
            Callback = function(selected)
                local wanted = {}
                for label, on in pairs(selected) do
                    if on and goodIds[label] then wanted[goodIds[label]] = true end
                end
                opt.SeasonGoods = wanted
            end,
        })
    end

    local function BuildSpawn(tab)
        local spawnBox = tab:AddLeftGroupbox(T("Ore & Loot Spawner", "เสกแร่และไอเทม"), nil, "OP")
        Feature(spawnBox, "TurboSpawn", T("Continuous Insane Turbo Spawner", "เสกของรัวแบบไม่จำกัดต่อเนื่อง"), T("Continuously streams selected or top tier loot directly into your backpack", "ฟาร์มเสกไอเทมที่เลือกหรือไอเทมระดับเทพเข้ากระเป๋าต่อเนื่องแบบไม่หยุด"))
        Pick(spawnBox, "SpawnItem", T("Ore / Item / Pet", "แร่ / ไอเทม / สัตว์เลี้ยง"), T("Every ore, egg, fruit, rune and pet; farmed into inventory", "แร่ ไข่ ผลไม้ รูน และสัตว์เลี้ยงทั้งหมด ดึงเข้ากระเป๋าทันที"), Aeris.Spawn.Choices, true)
        Decorate("SpawnItem", function(label) local entry = State.SpawnLabels[label] return entry and entry.id end)
        NumberInput(spawnBox, "SpawnAmount", T("Amount", "จำนวน"), T("Target amount to acquire (up to 1,000,000)", "จำนวนที่ต้องการได้ (สูงสุด 1,000,000)"), 1)
        spawnBox:AddButton({ Text = T("Spawn Selected Item (Turbo)", "เสกไอเทมที่เลือก (เทอร์โบ)"), Style = "Primary", Func = Action(function()
            local picked = State.SpawnLabels[opt.SpawnItem]
            if not picked then return Notify("Pick an item first", "Warning") end
            local acquired, outcome, reason = Aeris.Spawn.Give(picked.id, picked.kind, opt.SpawnAmount)
            Notify(acquired and ("Obtained %s"):format(Aeris.Util.Abbreviate(outcome)) or (reason or "Done"), acquired and "Success" or "Warning")
        end) }):AddButton(RefreshButton("SpawnItem", Aeris.Spawn.Choices))

        spawnBox:AddButton({ Text = T("INSANE Farm Tier 40-48 God Ores", "เสกแร่เทพ Tier 40-48 แบบรัวคลั่ง"), Style = "Success", Func = LongAction("Max Ores", function()
            return Aeris.Stage.FarmMaxOres(50)
        end, function(count)
            return ("Acquired %d god tier ores directly!"):format(count or 0)
        end) })

        spawnBox:AddButton({ Text = T("INSANE Farm Pet Eggs & Fruits (Burst)", "เสกไข่สัตว์เลี้ยงและผลไม้แบบรัวคลั่ง"), Style = "Success", Func = LongAction("Eggs & Fruits", function()
            local eggs, foods = Aeris.Stage.FarmEggsAndFood(50)
            return { eggs = eggs, foods = foods }
        end, function(res)
            if type(res) ~= "table" then return "No drops" end
            return ("+%d eggs · +%d fruits"):format(res.eggs or 0, res.foods or 0)
        end) })

        spawnBox:AddButton({ Text = T("INSANE Farm Enhance Stones", "เสกหินตีบวกทั้งหมดแบบรัวคลั่ง"), Style = "Primary", Func = LongAction("Stones", function()
            local before = Aeris.Data.Count(Aeris.Data.Get(), "EnhantStone_1")
            Aeris.Stage.FarmStones(Aeris.Stage.Best())
            task.wait(0.3)
            return Aeris.Data.Count(Aeris.Data.Get(true), "EnhantStone_1") - before
        end, function(gained) return ("+%d enhance stones"):format(gained or 0) end) })

        spawnBox:AddButton({ Text = T("INSANE Stream All Drops (Burst)", "เสกและดึงดรอปทุกชนิดเข้ากระเป๋าแบบรัว"), Style = "Success", Func = LongAction("Stream Drops", function()
            local eggs, foods = Aeris.Stage.FarmEggsAndFood(50)
            local ores = Aeris.Stage.FarmMaxOres(50)
            return { eggs = eggs, foods = foods, ores = ores }
        end, function(res)
            return ("+%d god ores · +%d eggs · +%d fruits"):format(res.ores or 0, res.eggs or 0, res.foods or 0)
        end) })

        local coinBox = tab:AddRightGroupbox(T("Season Coins & Tower", "เหรียญซีซั่นและหอคอย"), nil, "OP")
        NumberInput(coinBox, "CoinTarget", T("Coins Target", "จำนวนเหรียญเป้าหมาย"), nil, 100)
        coinBox:AddButton({ Text = T("Farm 50,000 Season Coins", "ฟาร์ม 50,000 เหรียญซีซั่นทันที"), Style = "Primary", Func = LongAction("Tower Coins", function()
            return Aeris.Tower.FarmCoins(opt.CoinTarget or 50000)
        end, function(gained) return ("+%s season coins"):format(Aeris.Util.Abbreviate(gained or 0)) end) })

        coinBox:AddButton({ Text = T("Farm Rare Enhance Stones (Tier 2)", "ฟาร์มหินตีบวกหายาก (Tier 2)"), Func = LongAction("Tower Stones", function()
            local before = Aeris.Data.Count(Aeris.Data.Get(), "EnhantStone_2")
            Aeris.Tower.FarmStep()
            task.wait(0.3)
            return Aeris.Data.Count(Aeris.Data.Get(true), "EnhantStone_2") - before
        end, function(gained) return ("+%d rare stones"):format(gained or 0) end) })

        local potionBox = tab:AddRightGroupbox(T("Potions", "ยา"), nil, "OP")
        NumberInput(potionBox, "PotionAmount", T("Potion Amount", "จำนวนยา"), T("Amount to consume for extending active buffs", "จำนวนยาที่จะใช้เพื่อต่อเวลาบัฟ"), 1)
        potionBox:AddButton({ Text = T("Extend All Buff Times", "เพิ่มเวลาบัฟยาทุกชนิด"), Style = "Primary", Func = LongAction("Potion Time", function()
            return Aeris.Potion.Extend(opt.PotionAmount)
        end, function(changed) return ("Extended %d potion buffs"):format(changed or 0) end) })

        local gearBox = tab:AddLeftGroupbox(T("Target Gear", "หลอมอาวุธและชุดเป้าหมาย"), nil, "OP")
        local function LoadGearList(slot)
            task.defer(function()
                local ok, labels = pcall(Aeris.Spawn.GearChoices, slot)
                if ok then
                    Later(SetList, "SpawnGear", labels, true)
                    Later(Decorate, "SpawnGear", function(label)
                        local gear = State.GearLabels and State.GearLabels[label]
                        return gear and gear.id
                    end)
                else
                    warn("[Aeris] gear list:", labels)
                end
            end)
        end
        opt.GearSlot = Config.GearTypes[1]
        gearBox:AddDropdown("GearSlot", {
            Text = T("Type", "ประเภท"),
            Values = Config.GearTypes,
            Default = 1,
            NoSave = true,
            Callback = function(value)
                opt.GearSlot = value
                LoadGearList(value)
            end,
        })
        opt.SpawnGear = nil
        gearBox:AddDropdown("SpawnGear", {
            Text = T("Gear", "อุปกรณ์"),
            Description = T("Strongest first. Exclusive gear is shop only", "แรงสุดอยู่บน ของ Exclusive มีแค่ในร้าน"),
            Values = { "..." },
            Default = 1,
            Searchable = true,
            NoSave = true,
            Callback = function(value)
                opt.SpawnGear = value
            end,
        })
        LoadGearList(opt.GearSlot)
        NumberInput(gearBox, "GearCopies", T("Copies", "จำนวนชิ้น"), nil, 1)
        gearBox:AddButton({ Text = T("Forge Target Gear", "หลอมอุปกรณ์เป้าหมาย"), Style = "Primary", Func = LongAction("Index", function()
            local gear = State.GearLabels[opt.SpawnGear]
            return gear and Aeris.Index.Hunt(gear, math.max(1, math.floor(opt.GearCopies)))
        end, function(got)
            return got and "Target forged!" or "Not all copies this time, press again"
        end) })
        gearBox:AddButton({ Text = T("Forge Set", "หลอมเซ็ตอุปกรณ์"), Func = LongAction("Index", Aeris.Spawn.BestSet, function(made)
            return ("Forged and equipped %d/3 pieces"):format(made or 0)
        end) })
        gearBox:AddButton({ Text = T("1-Click Forge & Max Full God Set", "หลอมและอัปเกรดเซ็ตเทพเต็มสูบ 1-คลิก"), Style = "Success", Func = LongAction("God Set", Aeris.Spawn.FullGodSet, function(made)
            return ("Forged, equipped, enhanced +20, and enchanted %d god pieces!"):format(made or 0)
        end) })
        gearBox:AddButton({ Text = T("Buy Exclusive Gear", "ซื้อของ Exclusive"), Func = LongAction("Tower", Aeris.Season.BuyExclusive, function(bought)
            return (bought or 0) > 0 and ("Bought %d exclusive pieces"):format(bought) or "Already bought this refresh"
        end) })

        local tokenBox = tab:AddRightGroupbox(T("Token Shop", "ร้าน Token"), nil, "OP")
        Feature(tokenBox, "AutoTokenShop", T("Auto Mystery Shop", "ร้านลึกลับอัตโนมัติ"), T("Reveals cards and buys selected goods using owned tokens", "เปิดการ์ดและซื้อของที่เลือกด้วย Token ที่มี"))
        Check(tokenBox, "TokenReveal", T("Auto Reveal Cards", "เปิดการ์ดอัตโนมัติ"))
        Check(tokenBox, "TokenSkipOwned", T("Skip Owned Goods", "ข้ามของที่มีแล้ว"))
        local tokenLabels, tokenIds = Source(Aeris.TokenShop.Choices)
        tokenBox:AddDropdown("TokenTargets", {
            Text = T("Buy These Goods (Empty = All)", "ของที่จะซื้อ (ว่าง = ทั้งหมด)"), Values = tokenLabels,
            Multi = true, Default = {}, Searchable = true,
            Callback = function(selected)
                local ids = {}
                for label, on in pairs(selected) do if on and tokenIds[label] then ids[tokenIds[label]] = true end end
                opt.TokenTargets = ids
            end,
        })
        tokenBox:AddButton({ Text = T("Buy All Now", "ซื้อทั้งหมดเดี๋ยวนี้"), Func = LongAction("Token Shop", Aeris.TokenShop.BuyAll, function(bought)
            return (bought or 0) > 0 and ("Bought %d items"):format(bought) or "No purchase: check tokens, ownership and selected goods"
        end) })
    end

    local function BuildPet(tab)
        local hatchBox = tab:AddLeftGroupbox(T("Egg Hatchery & Farm", "ฟักไข่และฟาร์มไข่"), nil, "OP")
        Feature(hatchBox, "AutoHatchEgg", T("Auto Hatch When Ready", "เปิดไข่อัตโนมัติเมื่อครบเวลา"), T("Watches incubator and opens ready eggs the exact second timer hits 0, then incubates next", "ตรวจตู้ฟักตลอดเวลาและเปิดไข่ทันทีที่เวลาครบ 0 วิ แล้วใส่ฟองใหม่ต่อเนื่อง"))
        Check(hatchBox, "HatchBestFirst", T("Hatch Rare Eggs First", "ฟักไข่หายากก่อน (Egg2 > Egg1)"))
        Toggle(hatchBox, "SkipEggAnim", T("Skip Egg Cutscene", "ข้ามฉากเปิดไข่"), T("Hides the egg opening cutscene so farming never pauses", "ปิดฉากแอนิเมชันเปิดไข่เพื่อไม่ให้ขัดจังหวะฟาร์ม"), function(value)
            Aeris.Util.Try(Aeris.Pet.MuteAnim, value)
        end)
        hatchBox:AddButton({ Text = T("Open Ready Eggs Now", "เปิดไข่ที่พร้อมเดี๋ยวนี้"), Style = "Primary", Func = Action(function()
            local opened, hatched = Aeris.Pet.HatchStep()
            Notify(opened > 0 and ("Opened %d ready eggs!"):format(opened) or "No eggs ready yet (timer still counting down)", opened > 0 and "Success" or "Info")
        end) })
        hatchBox:AddButton({ Text = T("Farm & Fill Crown Eggs (Egg2)", "ฟาร์มและเติมไข่ Egg2 เต็มตู้"), Style = "Success", Func = LongAction("Egg2 Farm", function()
            Aeris.Pet.TrimEggs("Egg2")
            Aeris.Stage.FarmTurbo("Egg2", "Egg", 15)
            local opened, hatched = Aeris.Pet.HatchStep()
            return hatched
        end, function(hatched)
            return ("Incubated %d new eggs!"):format(hatched or 0)
        end) })
        hatchBox:AddButton({ Text = T("Refill 20 Eggs & Fruits Burst", "เติมไข่และผลไม้ 20 ชิ้น (เต็มกระเป๋า)"), Style = "Primary", Func = LongAction("Pet Farm", function()
            local eggs, foods = Aeris.Stage.FarmEggsAndFood(20)
            return { eggs = eggs, foods = foods }
        end, function(res)
            if type(res) ~= "table" then return "No drops" end
            return ("+%d eggs · +%d fruits"):format(res.eggs or 0, res.foods or 0)
        end) })

        local cleanBox = tab:AddLeftGroupbox(T("Pet Bag Cleanup", "จัดการกระเป๋าสัตว์เลี้ยง"))
        Feature(cleanBox, "AutoSellPet", T("Auto Clean Pet & Egg Bag", "เคลียร์กระเป๋าสัตว์เลี้ยงและไข่อัตโนมัติ"), T("Deletes low-rarity pets while protecting equipped and top pets", "ลบสัตว์เลี้ยงระดับต่ำโดยล็อกตัวที่ใส่และตัวเก่งสุดไว้"))
        local defaultDelete = { "Common", "Uncommon", "Rare", "Epic" }
        opt.DeletePetRarities = Aeris.Util.AllSet(defaultDelete)
        cleanBox:AddDropdown("DeletePetRarities", {
            Text = T("Delete Pet Rarities", "ลบสัตว์เลี้ยงระดับ"),
            Description = T("Only delete unequipped pets of these rarities", "ลบเฉพาะสัตว์เลี้ยงที่ไม่ได้ใส่ในระดับที่เลือก"),
            Values = rarityNames,
            Multi = true,
            Default = defaultDelete,
            Callback = function(selected)
                opt.DeletePetRarities = selected
            end,
        })
        NumberInput(cleanBox, "KeepBestPets", T("Keep Top Pets", "เก็บสัตว์เลี้ยงตัวหลักไว้"), T("Always keeps at least this many highest-scoring pets", "เก็บสัตว์เลี้ยงที่คะแนนสูงสุดไว้อย่างน้อยจำนวนนี้"), 1)
        Check(cleanBox, "AutoDeleteEggs", T("Trim Excess Unhatched Eggs", "ลบไข่ส่วนเกินอัตโนมัติ"))
        NumberInput(cleanBox, "KeepPerEgg", T("Keep Per Egg Type", "เก็บไข่ไว้ชนิดละ"), T("Deletes unhatched eggs above this count per type", "ลบไข่ที่ยังไม่ได้ฟักที่เกินจำนวนนี้ต่อชนิด"), 1)
        cleanBox:AddButton({ Text = T("Clean Pet & Egg Bag Now", "เคลียร์กระเป๋าเดี๋ยวนี้"), Func = Action(function()
            local delPets, delEggs = Aeris.Pet.CleanBag()
            Notify(("Removed %d pets · %d eggs"):format(delPets or 0, delEggs or 0), "Info")
        end) })

        local petBox = tab:AddRightGroupbox(T("Pet Loadout & Feeding", "ใส่สัตว์เลี้ยงและให้อาหาร"), nil, "OP")
        Feature(petBox, "AutoEquipPet", T("Auto Equip Pets", "ใส่สัตว์เลี้ยงอัตโนมัติ"), T("Always equips your highest-scoring pets for maximum stat boosts", "ใส่สัตว์เลี้ยงที่คะแนนสูงสุดเสมอเพื่อรับบัฟสูงสุด"))
        petBox:AddButton({ Text = T("Equip Best Pets Now", "ใส่สัตว์เลี้ยงเทพเดี๋ยวนี้"), Style = "Primary", Func = Action(function()
            local changed = Aeris.Pet.EquipBest()
            Notify(changed > 0 and ("Equipped %d pet(s)"):format(changed) or "Already equipping top pet(s)", "Info")
        end) })
        petBox:AddDivider()
        Feature(petBox, "AutoFeedPet", T("Auto Feed Fruits", "ให้อาหารผลไม้อัตโนมัติ"), T("Feeds owned fruits to your top pets until they reach max level", "ป้อนผลไม้ที่มีให้สัตว์เลี้ยงตัวหลักจนเลเวลตัน"))
        petBox:AddButton({ Text = T("Feed Pet Once", "ป้อนผลไม้หนึ่งครั้ง"), Func = Action(function()
            local fed = Aeris.Pet.FeedBest()
            Notify(fed > 0 and "Fed highest-priority pet!" or "No pet needs EXP or no fruit owned", fed > 0 and "Success" or "Info")
        end) })
        petBox:AddButton({ Text = T("Feed All Pets to Max Level Now", "ป้อนผลไม้ให้อิ่มจนเวลตันทุกตัวทันที"), Style = "Success", Func = Action(function()
            local totalFed = Aeris.Pet.FeedAllMax()
            Notify(totalFed > 0 and ("Fed pets %d times to max level!"):format(totalFed) or "Pets already max level or out of fruits", totalFed > 0 and "Success" or "Info")
        end) })

        local deployBox = tab:AddRightGroupbox(T("Pet Expedition", "ส่งสัตว์เลี้ยงสำรวจ"))
        Feature(deployBox, "AutoDeployPet", T("Auto Deploy & Claim Rewards", "ส่งสำรวจและรับรางวัลอัตโนมัติ"), T("Deploys best available pets on expeditions and claims all loot", "ส่งสัตว์เลี้ยงสำรวจและรับของรางวัลทั้งหมดอัตโนมัติ"))
        deployBox:AddButton({ Text = T("Deploy & Claim Now", "ส่งสำรวจและรับรางวัลเดี๋ยวนี้"), Style = "Success", Func = Action(function()
            Aeris.Util.Remote("Pet", "ClaimAllDeployRewardRE"):FireServer()
            local deployed = Aeris.Pet.DeployStep()
            Notify(("Claimed rewards · Deployed %d pet(s)"):format(deployed or 0), "Success")
        end) })

        local targetBox = tab:AddRightGroupbox(T("Target Pet Hunt & Auto-Hatch", "ล่าสัตว์เลี้ยงตามสั่ง"), nil, "OP")
        Pick(targetBox, "TargetPet", T("Target Pet", "สัตว์เลี้ยงที่ต้องการ"), T("Select any pet to hunt: farms its parent egg and auto-hatches", "เลือกสัตว์เลี้ยงตัวที่ต้องการ ระบบจะฟาร์มไข่ตรงใบและฟักเมื่อครบเวลา"), Aeris.Pet.Choices, true)
        Decorate("TargetPet", function(label) return State.PetTargetLabels and State.PetTargetLabels[label] end)
        NumberInput(targetBox, "TargetPetCopies", T("Target Copies", "จำนวนที่ต้องการได้"), T("Number of target pets to acquire", "จำนวนตัวที่ต้องการเสกล่า"), 1)
        Feature(targetBox, "AutoChaseTargetPet", T("Auto Chase Target Pet", "ล่าสัตว์เลี้ยงตัวนี้อัตโนมัติ"), T("Automatically farms required eggs, incubates, opens on 0s, max-feeds, and locks", "ฟาร์มไข่ตรงใบ ใส่ตู้ฟัก เปิดทันทีที่ครบเวลา อัปเวลตันและล็อคตัวอัตโนมัติ"))
        Check(targetBox, "AutoLockTargetPet", T("Auto Lock Target Pet", "ล็อคสัตว์เลี้ยงที่ได้อัตโนมัติ"))
        targetBox:AddButton({ Text = T("Farm & Incubate Target Egg Now", "ฟาร์มและใส่ไข่เป้าหมายเข้าตู้เดี๋ยวนี้"), Style = "Primary", Func = LongAction("Pet Hunt", function()
            local picked = State.PetTargetLabels and State.PetTargetLabels[opt.TargetPet]
            if not picked then return nil end
            local gained, msg = Aeris.Pet.FarmAndHatchTarget(picked, opt.TargetPetCopies or 1)
            return msg or (gained > 0 and ("Acquired %d!"):format(gained) or "Incubating")
        end, function(msg)
            return tostring(msg or "Done")
        end) }):AddButton(RefreshButton("TargetPet", Aeris.Pet.Choices))
        targetBox:AddButton({ Text = T("Lock All High-Tier Pets", "ล็อคสัตว์เลี้ยงระดับแรร์ทั้งหมด"), Style = "Success", Func = Action(function()
            local locked = Aeris.Pet.LockAllGodPets()
            Notify(("Locked %d high-tier pets"):format(locked or 0), "Success")
        end) })
    end

    local function BuildPlayer(tab)
        local raceBox = tab:AddLeftGroupbox(T("Race", "เผ่า"))
        local raceLabels, raceIds = Source(Aeris.Race.Choices)
        raceBox:AddDropdown("RaceTargets", {
            Text = T("Target Races", "เผ่าที่ต้องการ"),
            Values = raceLabels,
            Multi = true,
            Default = {},
            Searchable = #raceLabels > 8,
            Callback = function(selected)
                local ids = {}
                for label, on in pairs(selected) do
                    if on and raceIds[label] then ids[raceIds[label]] = true end
                end
                opt.RaceTargets = ids
            end,
        })
        Decorate("RaceTargets", function(label) return raceIds[label] end)
        local rarityLabels, rarityLevels = Source(Aeris.Race.RarityChoices)
        raceBox:AddDropdown("RaceMinRarity", {
            Text = T("Or Any Race Of", "หรือเผ่าระดับ"),
            Values = rarityLabels,
            Default = 1,
            Callback = function(value)
                opt.RaceMinLevel = rarityLevels[value]
            end,
        })
        local starByLabel = { ["Any"] = 0, ["2 Stars+"] = 2, ["3 Stars"] = 3 }
        raceBox:AddDropdown("RaceStar", {
            Text = T("Target Stars", "ดาวที่ต้องการ"),
            Values = { "Any", "2 Stars+", "3 Stars" },
            Default = 1,
            Callback = function(value)
                opt.RaceStar = starByLabel[value] or 0
            end,
        })
        raceBox:AddDropdown("RaceSlot", {
            Text = T("Roll Slot", "ช่องที่สุ่ม"),
            Values = Config.RaceSlots,
            Default = 1,
            Callback = function(value)
                opt.RaceSlot = value
            end,
        })
        Feature(raceBox, "AutoRace", T("Auto Roll Race", "สุ่มเผ่าอัตโนมัติ"), T("Rolls in the background until a chosen race shows up", "สุ่มเบื้องหลังจนกว่าจะได้เผ่าที่เลือก"), function(value)
            if not value or State.Rolling then return end
            if not next(opt.RaceTargets) and not opt.RaceMinLevel then
                Notify("Pick a target race first", "Warning")
                return Later(TurnOff, "AutoRace")
            end
            State.Rolling = true
            task.defer(function()
                if not opt.RaceAnim then Aeris.Util.Try(Aeris.Race.MuteAnim, true) end
                local ok, outcome, detail = pcall(Aeris.Race.RollUntil)
                Aeris.Util.Try(Aeris.Race.MuteAnim, false)
                State.Rolling = false
                local used = State.RaceRolls or 0
                if not ok then
                    warn("[Aeris] race roll:", outcome)
                elseif outcome == "got" then
                    Notify(("Got %s after %d rolls!"):format(tostring(detail), used), "Success", 8)
                elseif outcome == "empty" then
                    Notify("Out of race rolls. Enable Buy Rolls When Empty or collect season rewards", "Warning")
                elseif outcome == "blocked" then
                    Notify("Can't roll: " .. tostring(detail), "Warning")
                end
                Later(TurnOff, "AutoRace")
            end)
        end)
        Check(raceBox, "RaceBuyRolls", T("Buy Rolls When Empty", "ซื้อ roll เมื่อหมด"))
        Check(raceBox, "RaceLock", T("Lock Slot When Found", "ได้แล้วล็อกช่อง"))
        Check(raceBox, "RaceProtect", T("Never Replace Mythic+", "ไม่สุ่มทับเผ่า Mythic ขึ้นไป"))
        Check(raceBox, "RaceAnim", T("Show Roll Animation", "แสดงฉากสุ่ม"))
        Feature(raceBox, "AutoBestRace", T("Auto Equip Rare Race", "ใส่อัตโนมัติตามความหายาก"), T("Switches to your rarest race", "สลับไปใช้เผ่าที่หายากที่สุด"))
        raceBox:AddButton({ Text = T("Switch Now", "สลับเดี๋ยวนี้"), Func = Action(function()
            Notify(Aeris.Race.EquipBest() and "Switched race slot" or "Already on your rarest race")
        end) })

        local moveBox = tab:AddRightGroupbox(T("Movement", "การเคลื่อนที่"))
        HotkeyFeature(moveBox, "SpeedOn", T("Speed", "ความเร็ว"), nil, Aeris.Movement.Apply)
        moveBox:AddSlider("WalkSpeed", {
            Text = T("Walk Speed", "ความเร็วเดิน"),
            Min = 16, Max = 250, Default = opt.WalkSpeed, Rounding = 0,
            Callback = function(value)
                opt.WalkSpeed = value
                Aeris.Movement.Apply()
            end,
        })
        HotkeyFeature(moveBox, "InfJump", T("Infinite Jump", "กระโดดไม่จำกัด"))

        local guardBox = tab:AddRightGroupbox(T("Survival", "เอาตัวรอด"))
        local godMode = Feature(guardBox, "GodMode", T("Invincible", "อมตะ"), T("Monsters and bosses can't kill you", "มอนสเตอร์และบอสฆ่าไม่ตาย"), function(value)
            if not value then
                if State.RestoreDamage then State.RestoreDamage() end
            elseif not Aeris.Guard.HookDamage() then
                Notify("Invincible is not available on this executor", "Warning")
                task.defer(TurnOff, "GodMode")
            end
        end)
        NeedModule(godMode, ReplicatedStorage.CTRL.HPCTRL)
        local keepOre = Feature(guardBox, "KeepOre", T("Keep Ore On Death", "ตายแล้วแร่ไม่หาย"), nil, function(value)
            if not value then
                Aeris.Guard.UnhookOreLoss()
            elseif not Aeris.Guard.HookOreLoss() then
                Notify("Keep Ore On Death is not supported on this executor", "Warning")
                task.defer(TurnOff, "KeepOre")
            end
        end)
        Aeris.Compat.NeedCap(keepOre, "Namecall")
    end

    local function BuildSettings(window)
        local settingsTab = window:AddSettingsTab()
        local runtimeBox = settingsTab:AddLeftGroupbox(T("Performance", "ประสิทธิภาพ"))
        NumberInput(runtimeBox, "ParallelJobs", T("Concurrent Tasks", "จำนวนงานพร้อมกัน"), T("1–8; inventory changes run in order", "1–8 งาน การแก้กระเป๋าทำตามลำดับ"), 1)
        NumberInput(runtimeBox, "WorkerLimit", T("Workers Per Task", "จำนวน worker ต่องาน"), T("1–32; lower this for slow connections", "1–32 ลดเมื่อเน็ตช้า"), 1)
        NumberInput(runtimeBox, "JobTimeout", T("Task Timeout (seconds)", "เวลารองานสูงสุด (วินาที)"), nil, 5)
        runtimeBox:AddButton({ Text = T("Retry Stopped Features", "ลองฟีเจอร์ที่หยุดอีกครั้ง"), Func = function()
            table.clear(Aeris.GameLib.Failed)
            table.clear(State.RemoteCache)
            for key, info in pairs(State.JobStats) do
                if not info.ok and Options[key] then
                    State.Failures[key] = nil
                    State.LastRun[key] = nil
                    Options[key]:SetValue(true)
                end
            end
            Notify("Retry requested", "Info")
        end })
        local sessionBox = settingsTab:AddRightGroupbox(T("Session", "เซสชัน"))
        Toggle(sessionBox, "AutoRejoin", T("Auto Rejoin", "เข้าเกมใหม่อัตโนมัติ"), T("Rejoins the game by itself after a disconnect", "หลุดแล้วเข้าเกมใหม่เอง"))
        Toggle(sessionBox, "LowGraphics", T("FPS Boost", "เพิ่ม FPS"), T("Turns off 3D rendering to save CPU and GPU", "ปิดการแสดงผล 3D ประหยัด CPU/GPU"), Aeris.Session.SetLowGraphics)
        sessionBox:AddButton({ Text = T("Rejoin Now", "เข้าเกมใหม่เดี๋ยวนี้"), Func = Action(Aeris.Session.Rejoin) })
        sessionBox:AddButton({ Text = T("Hop To Emptiest Server", "ย้ายไปเซิร์ฟคนน้อยสุด"), Func = Action(function()
            if not Aeris.Session.HopSmallest() then Notify("Server list unavailable, try again", "Warning") end
        end) })

        local spotBox = settingsTab:AddRightGroupbox(T("Position", "ตำแหน่ง"))
        spotBox:AddButton({ Text = T("Save Position", "บันทึกตำแหน่ง"), Func = Action(function()
            Notify(Aeris.Session.SavePosition() and "Position saved" or "No character", "Info")
        end) }):AddButton({ Text = T("Go Back", "กลับไปจุดที่บันทึก"), Func = Action(function()
            if not Aeris.Session.ReturnPosition() then Notify("Save a position first", "Warning") end
        end) })
    end

    local noteText = {
        EnhantStone_1 = "farming enhance stones",
        EnhantStone_2 = "farming rare enhance stones",
        Coin = "farming coins",
        Enhancing = "enhancing",
        NoTicket = "need a tower ticket",
        Done = "all at target",
    }

    local function TaskText()
        if State.Lock == "Index" then return "Index " .. (State.IndexNote or "planning") end
        if State.Lock then return State.Lock end
        if opt.MaxGear then return "Max Gear, " .. (noteText[State.GearNote] or "starting") end
        return "Idle"
    end

    local function UpdateStatus()
        local ok, profile = pcall(Aeris.Data.Get)
        if not (ok and profile and statusLabel) then return end
        local eco = profile.Eco or {}
        local line = ("Level %d · Rebirth %d · Coins %s"):format(tonumber(eco.level) or 1, tonumber(eco.rebirth) or 0, Aeris.Util.Abbreviate(eco.coin or 0))
        if (State.TowerLoot or 0) > 0 then
            line ..= ("\nTower loot x%d"):format(State.TowerLoot)
        end
        Later(statusLabel.SetText, statusLabel, line)
        local gearLine = "Equipped: " .. tostring(Aeris.Gear.EquippedNames(profile) or "None")
        local petLine = tostring(Aeris.Pet.StatusText(profile) or "")
        Later(gearLabel.SetText, gearLabel, gearLine .. "\n" .. petLine)
        Later(taskLabel.SetText, taskLabel, "Working on: " .. tostring(TaskText() or "Idle"))
    end

    local function BuildTabs()
        local MainTab = WindowObj:AddTab("Main", "home", "Status, all-in-one mode and rewards")
        local GearTab = WindowObj:AddTab("Gear", "sword", "Best gear, equip and enhance")
        local PetTab = WindowObj:AddTab("Pets & Eggs", "heart", "Hatch eggs, equip, feed, deploy and clean pet bag")
        local FarmTab = WindowObj:AddTab("Combat & Farm", "swords", "Stages, monsters, bosses and index")
        local ForgeTab = WindowObj:AddTab("Forge", "zap", "Forge gear from any ore")
        local SellTab = WindowObj:AddTab("Sell", "upload", "Sell gear by type and rarity")
        local ProgressTab = WindowObj:AddTab("Upgrade & Rebirth", "sliders", "Training, rebirth and upgrades")
        local TowerTab = WindowObj:AddTab("Tower", "shield", "Tower loot and season pass")
        local SpawnTab = WindowObj:AddTab("Spawn Items", "target", "Target forging, shops, potions and tower coins")
        local PlayerTab = WindowObj:AddTab("Player", "user", "Race, movement and survival")

        local sections = {
            { BuildMain, MainTab },
            { BuildGear, GearTab },
            { BuildPet, PetTab },
            { BuildFarm, FarmTab },
            { BuildForge, ForgeTab },
            { BuildSell, SellTab },
            { BuildProgress, ProgressTab },
            { BuildTower, TowerTab },
            { BuildSpawn, SpawnTab },
            { BuildPlayer, PlayerTab },
            { BuildSettings, WindowObj },
        }
        for _, section in ipairs(sections) do
            Aeris.Util.Try(section[1], section[2])
        end
        Aeris.Util.Try(BlockMissing)

        task.spawn(function()
            while State.Alive do
                Pump()
                task.wait(Config.PumpInterval or 0.2)
            end
        end)
        task.spawn(function()
            while State.Alive do
                UpdateStatus()
                task.wait(Config.StatusInterval or 1.5)
            end
        end)
    end

    local function Unload()
        for _, cb in ipairs(unloadCallbacks) do pcall(cb) end
        pcall(function() Rayfield:Destroy() end)
    end
    getgenv().AerisUnload = Unload

    BuildTabs()
    Aeris.Util.Try(Aeris.Scheduler.Boot)
    Notify("Aeris Loaded Successfully!", "Success")

    if Aeris.Boss.HopWanted() and Options.BossHop then Options.BossHop:SetValue(true) end

    -- Attach smooth shimmering gradient to Rayfield window outline
    task.defer(function()
        task.wait(0.6)
        local parent = GetSafeGuiParent()
        local rayfieldGui = parent:FindFirstChild("Rayfield") or game:GetService("CoreGui"):FindFirstChild("Rayfield")
        if rayfieldGui then
            local mainFrame = rayfieldGui:FindFirstChild("Main")
            if mainFrame then
                AttachShimmerStroke(mainFrame, 2.5)
            end
        end
    end)
end

-- ============================================================================
-- AERIS SPLASH SCREEN (6-Second Smooth Fade-In and Fade-Out)
-- ============================================================================
local function ShowSplashScreen(onFinished)
    local parent = GetSafeGuiParent()
    local splashGui = Instance.new("ScreenGui")
    splashGui.Name = "AerisSplashScreen"
    splashGui.IgnoreGuiInset = true
    splashGui.DisplayOrder = 999999
    splashGui.ResetOnSpawn = false
    splashGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Fullscreen white background covering everything including top bar (Roblox icon, chat, leaderboard)
    local bg = Instance.new("Frame")
    bg.Name = "SplashBackground"
    bg.Size = UDim2.fromScale(1, 1)
    bg.Position = UDim2.fromScale(0, 0)
    bg.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    bg.BorderSizePixel = 0
    bg.Parent = splashGui

    -- CanvasGroup for smooth fade-in and fade-out
    local cg = Instance.new("CanvasGroup")
    cg.Name = "SplashGroup"
    cg.Size = UDim2.fromScale(1, 1)
    cg.Position = UDim2.fromScale(0, 0)
    cg.BackgroundTransparency = 1
    cg.GroupTransparency = 1
    bg.Parent = splashGui
    cg.Parent = bg

    -- Center content container
    local center = Instance.new("Frame")
    center.Name = "CenterContainer"
    center.AnchorPoint = Vector2.new(0.5, 0.5)
    center.Position = UDim2.fromScale(0.5, 0.48)
    center.Size = UDim2.new(0.7, 0, 0.75, 0)
    center.BackgroundTransparency = 1
    center.Parent = cg

    local layout = Instance.new("UIListLayout")
    layout.FillDirection = Enum.FillDirection.Vertical
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    layout.VerticalAlignment = Enum.VerticalAlignment.Center
    layout.SortOrder = Enum.SortOrder.LayoutOrder
    layout.Padding = UDim.new(0, 16)
    layout.Parent = center

    -- Large Logo (covers prominent part of screen)
    local logo = Instance.new("ImageLabel")
    logo.Name = "AerisLogo"
    logo.Image = LOGO_ID
    logo.BackgroundTransparency = 1
    logo.ScaleType = Enum.ScaleType.Fit
    logo.Size = UDim2.new(0.56, 0, 0.56, 0)
    logo.LayoutOrder = 1

    local aspect = Instance.new("UIAspectRatioConstraint")
    aspect.AspectRatio = 1
    aspect.AspectType = Enum.AspectType.FitWithinMaxSize
    aspect.DominantAxis = Enum.DominantAxis.Width
    aspect.Parent = logo
    logo.Parent = center

    -- Title: Aeris.
    local title = Instance.new("TextLabel")
    title.Name = "AerisTitle"
    title.Text = "Aeris."
    title.Font = Enum.Font.GothamBold
    title.TextSize = 52
    title.TextColor3 = Color3.fromRGB(22, 14, 38)
    title.BackgroundTransparency = 1
    title.Size = UDim2.new(1, 0, 0, 56)
    title.LayoutOrder = 2
    title.Parent = center

    -- Subtitle: All for you
    local sub = Instance.new("TextLabel")
    sub.Name = "AerisSubtitle"
    sub.Text = "All for you"
    sub.Font = Enum.Font.GothamMedium
    sub.TextSize = 24
    sub.TextColor3 = Color3.fromRGB(115, 95, 145)
    sub.BackgroundTransparency = 1
    sub.Size = UDim2.new(1, 0, 0, 32)
    sub.LayoutOrder = 3
    sub.Parent = center

    splashGui.Parent = parent

    -- Smooth Animation Sequence: Total ~6 Seconds
    local fadeIn = TweenService:Create(cg, TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { GroupTransparency = 0 })
    fadeIn:Play()

    task.delay(4.6, function()
        local fadeOut = TweenService:Create(cg, TweenInfo.new(1.2, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { GroupTransparency = 1 })
        fadeOut:Play()
        fadeOut.Completed:Connect(function()
            splashGui:Destroy()
            if onFinished then
                onFinished()
            end
        end)
    end)
end

-- ============================================================================
-- AERIS KEY VERIFICATION GUI (Purple & White Glassmorphism + Shimmering Strokes)
-- ============================================================================
local function ShowKeyVerification(onVerified)
    local parent = GetSafeGuiParent()
    local keyGui = Instance.new("ScreenGui")
    keyGui.Name = "AerisKeyVerification"
    keyGui.IgnoreGuiInset = true
    keyGui.DisplayOrder = 100000
    keyGui.ResetOnSpawn = false
    keyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Dimmed background overlay
    local overlay = Instance.new("Frame")
    overlay.Name = "Overlay"
    overlay.Size = UDim2.fromScale(1, 1)
    overlay.Position = UDim2.fromScale(0, 0)
    overlay.BackgroundColor3 = Color3.fromRGB(10, 6, 18)
    overlay.BackgroundTransparency = 1
    overlay.BorderSizePixel = 0
    overlay.Parent = keyGui

    -- Main Card Container (Glassmorphic translucent purple & white)
    local cardGroup = Instance.new("CanvasGroup")
    cardGroup.Name = "CardGroup"
    cardGroup.AnchorPoint = Vector2.new(0.5, 0.5)
    cardGroup.Position = UDim2.fromScale(0.5, 0.5)
    cardGroup.Size = UDim2.fromOffset(470, 370)
    cardGroup.BackgroundColor3 = Color3.fromRGB(24, 14, 38)
    cardGroup.BackgroundTransparency = 0.28
    cardGroup.GroupTransparency = 1
    cardGroup.BorderSizePixel = 0
    cardGroup.Parent = overlay

    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 16)
    cardCorner.Parent = cardGroup

    AttachShimmerStroke(cardGroup, 2.5)

    local cardScale = Instance.new("UIScale")
    cardScale.Scale = 0.82
    cardScale.Parent = cardGroup

    -- Header Container
    local header = Instance.new("Frame")
    header.Name = "Header"
    header.BackgroundTransparency = 1
    header.Position = UDim2.fromOffset(24, 20)
    header.Size = UDim2.new(1, -48, 0, 52)
    header.Parent = cardGroup

    local logoImg = Instance.new("ImageLabel")
    logoImg.Name = "Logo"
    logoImg.Image = LOGO_ID
    logoImg.BackgroundTransparency = 1
    logoImg.ScaleType = Enum.ScaleType.Fit
    logoImg.Size = UDim2.fromOffset(46, 46)
    logoImg.Position = UDim2.fromOffset(0, 3)
    logoImg.Parent = header

    local titleText = Instance.new("TextLabel")
    titleText.Name = "Title"
    titleText.Text = "AERIS"
    titleText.Font = Enum.Font.GothamBold
    titleText.TextSize = 24
    titleText.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleText.TextXAlignment = Enum.TextXAlignment.Left
    titleText.BackgroundTransparency = 1
    titleText.Position = UDim2.fromOffset(56, 4)
    titleText.Size = UDim2.new(1, -60, 0, 24)
    titleText.Parent = header

    local subText = Instance.new("TextLabel")
    subText.Name = "Subtitle"
    subText.Text = "KEY VERIFICATION SYSTEM"
    subText.Font = Enum.Font.GothamMedium
    subText.TextSize = 11
    subText.TextColor3 = Color3.fromRGB(192, 132, 252)
    subText.TextXAlignment = Enum.TextXAlignment.Left
    subText.BackgroundTransparency = 1
    subText.Position = UDim2.fromOffset(56, 28)
    subText.Size = UDim2.new(1, -60, 0, 16)
    subText.Parent = header

    -- Warning Banner (24-Hour Reset Notice)
    local warnBox = Instance.new("Frame")
    warnBox.Name = "WarningBanner"
    warnBox.Position = UDim2.fromOffset(24, 82)
    warnBox.Size = UDim2.new(1, -48, 0, 46)
    warnBox.BackgroundColor3 = Color3.fromRGB(42, 22, 68)
    warnBox.BackgroundTransparency = 0.5
    warnBox.Parent = cardGroup

    local warnCorner = Instance.new("UICorner")
    warnCorner.CornerRadius = UDim.new(0, 8)
    warnCorner.Parent = warnBox

    local warnStroke = Instance.new("UIStroke")
    warnStroke.Color = Color3.fromRGB(147, 51, 234)
    warnStroke.Thickness = 1
    warnStroke.Transparency = 0.4
    warnStroke.Parent = warnBox

    local warnText = Instance.new("TextLabel")
    warnText.Name = "WarnLabel"
    warnText.Text = "Notice: Keys reset every 24 hours. Verification is required per account."
    warnText.Font = Enum.Font.GothamMedium
    warnText.TextSize = 12
    warnText.TextColor3 = Color3.fromRGB(235, 215, 255)
    warnText.TextWrapped = true
    warnText.BackgroundTransparency = 1
    warnText.Position = UDim2.fromOffset(10, 4)
    warnText.Size = UDim2.new(1, -20, 1, -8)
    warnText.Parent = warnBox

    -- Key Input Container
    local inputContainer = Instance.new("Frame")
    inputContainer.Name = "InputContainer"
    inputContainer.Position = UDim2.fromOffset(24, 142)
    inputContainer.Size = UDim2.new(1, -48, 0, 48)
    inputContainer.BackgroundColor3 = Color3.fromRGB(16, 9, 26)
    inputContainer.BackgroundTransparency = 0.45
    inputContainer.Parent = cardGroup

    local inputCorner = Instance.new("UICorner")
    inputCorner.CornerRadius = UDim.new(0, 10)
    inputCorner.Parent = inputContainer

    AttachShimmerStroke(inputContainer, 1.6)

    local textBox = Instance.new("TextBox")
    textBox.Name = "KeyInput"
    textBox.PlaceholderText = "Paste or enter your key here..."
    textBox.PlaceholderColor3 = Color3.fromRGB(150, 130, 185)
    textBox.Text = ""
    textBox.ClearTextOnFocus = false
    textBox.Font = Enum.Font.Gotham
    textBox.TextSize = 14
    textBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    textBox.BackgroundTransparency = 1
    textBox.Position = UDim2.fromOffset(14, 0)
    textBox.Size = UDim2.new(1, -28, 1, 0)
    textBox.TextXAlignment = Enum.TextXAlignment.Left
    textBox.Parent = inputContainer

    -- Status Feedback Label
    local statusLabel = Instance.new("TextLabel")
    statusLabel.Name = "StatusLabel"
    statusLabel.Text = ""
    statusLabel.Font = Enum.Font.GothamMedium
    statusLabel.TextSize = 12
    statusLabel.TextColor3 = Color3.fromRGB(200, 180, 230)
    statusLabel.BackgroundTransparency = 1
    statusLabel.Position = UDim2.fromOffset(24, 198)
    statusLabel.Size = UDim2.new(1, -48, 0, 20)
    statusLabel.TextXAlignment = Enum.TextXAlignment.Center
    statusLabel.Parent = cardGroup

    -- Buttons Container
    local buttonsFrame = Instance.new("Frame")
    buttonsFrame.Name = "ButtonsFrame"
    buttonsFrame.Position = UDim2.fromOffset(24, 230)
    buttonsFrame.Size = UDim2.new(1, -48, 0, 48)
    buttonsFrame.BackgroundTransparency = 1
    buttonsFrame.Parent = cardGroup

    local buttonLayout = Instance.new("UIListLayout")
    buttonLayout.FillDirection = Enum.FillDirection.Horizontal
    buttonLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    buttonLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    buttonLayout.Padding = UDim.new(0, 14)
    buttonLayout.Parent = buttonsFrame

    -- Button 1: Verify Button
    local verifyBtn = Instance.new("TextButton")
    verifyBtn.Name = "VerifyButton"
    verifyBtn.Text = "Verify"
    verifyBtn.Font = Enum.Font.GothamBold
    verifyBtn.TextSize = 15
    verifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    verifyBtn.BackgroundColor3 = Color3.fromRGB(90, 40, 145)
    verifyBtn.BackgroundTransparency = 0.52
    verifyBtn.Size = UDim2.new(0.5, -7, 1, 0)
    verifyBtn.AutoButtonColor = false
    verifyBtn.Parent = buttonsFrame

    local verifyCorner = Instance.new("UICorner")
    verifyCorner.CornerRadius = UDim.new(0, 10)
    verifyCorner.Parent = verifyBtn

    AttachShimmerStroke(verifyBtn, 1.8)

    -- Button 2: Get Key Button
    local getKeyBtn = Instance.new("TextButton")
    getKeyBtn.Name = "GetKeyButton"
    getKeyBtn.Text = "Get Key"
    getKeyBtn.Font = Enum.Font.GothamBold
    getKeyBtn.TextSize = 15
    getKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    getKeyBtn.BackgroundColor3 = Color3.fromRGB(55, 28, 95)
    getKeyBtn.BackgroundTransparency = 0.52
    getKeyBtn.Size = UDim2.new(0.5, -7, 1, 0)
    getKeyBtn.AutoButtonColor = false
    getKeyBtn.Parent = buttonsFrame

    local getKeyCorner = Instance.new("UICorner")
    getKeyCorner.CornerRadius = UDim.new(0, 10)
    getKeyCorner.Parent = getKeyBtn

    AttachShimmerStroke(getKeyBtn, 1.8)

    -- Footer info
    local footerText = Instance.new("TextLabel")
    footerText.Name = "Footer"
    footerText.Text = "Team Aeris  *  All for you"
    footerText.Font = Enum.Font.Gotham
    footerText.TextSize = 11
    footerText.TextColor3 = Color3.fromRGB(150, 130, 180)
    footerText.BackgroundTransparency = 1
    footerText.Position = UDim2.fromOffset(24, 300)
    footerText.Size = UDim2.new(1, -48, 0, 20)
    footerText.TextXAlignment = Enum.TextXAlignment.Center
    footerText.Parent = cardGroup

    keyGui.Parent = parent

    -- Smooth Open Animation
    TweenService:Create(overlay, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { BackgroundTransparency = 0.45 }):Play()
    TweenService:Create(cardGroup, TweenInfo.new(0.55, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), { GroupTransparency = 0 }):Play()
    TweenService:Create(cardScale, TweenInfo.new(0.55, Enum.EasingStyle.Back, Enum.EasingDirection.Out), { Scale = 1 }):Play()

    local function CloseMenu(callback)
        local t1 = TweenService:Create(cardScale, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { Scale = 0.88 })
        local t2 = TweenService:Create(cardGroup, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { GroupTransparency = 1 })
        local t3 = TweenService:Create(overlay, TweenInfo.new(0.4, Enum.EasingStyle.Quart, Enum.EasingDirection.In), { BackgroundTransparency = 1 })
        t1:Play()
        t2:Play()
        t3:Play()
        t2.Completed:Connect(function()
            keyGui:Destroy()
            if callback then callback() end
        end)
    end

    getKeyBtn.MouseButton1Click:Connect(function()
        CopyToClipboard(KEY_LINK)
        statusLabel.TextColor3 = Color3.fromRGB(160, 225, 255)
        statusLabel.Text = "Key link copied: " .. KEY_LINK
    end)

    local isProcessing = false
    verifyBtn.MouseButton1Click:Connect(function()
        if isProcessing then return end
        local entered = textBox.Text
        if entered == TARGET_KEY then
            isProcessing = true
            statusLabel.TextColor3 = Color3.fromRGB(120, 255, 170)
            statusLabel.Text = "Key Verified! Welcome to Aeris..."
            SaveKey(TARGET_KEY)
            task.delay(0.6, function()
                CloseMenu(function()
                    if onVerified then onVerified() end
                end)
            end)
        else
            statusLabel.TextColor3 = Color3.fromRGB(255, 110, 135)
            statusLabel.Text = "Invalid Key! Please check and try again."
            local origPos = cardGroup.Position
            task.spawn(function()
                for i = 1, 3 do
                    cardGroup.Position = origPos + UDim2.fromOffset(8, 0)
                    task.wait(0.04)
                    cardGroup.Position = origPos + UDim2.fromOffset(-8, 0)
                    task.wait(0.04)
                end
                cardGroup.Position = origPos
            end)
        end
    end)
end

if getgenv().AerisUnload then
    pcall(getgenv().AerisUnload)
end

local function StartScript()
    pcall(AerisBanner.Step, "Systems")
    BuildInterface()
    pcall(AerisBanner.Step, "Interface")
    pcall(AerisBanner.Ready)
end

-- Key Verification & Splash Screen Execution Flow
if IsKeyValid() then
    ShowSplashScreen(function()
        StartScript()
    end)
else
    ShowKeyVerification(function()
        ShowSplashScreen(function()
            StartScript()
        end)
    end)
end