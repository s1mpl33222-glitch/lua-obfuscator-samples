-- ==============================================================================
-- [ SYNTAX HUB - COMPLETE FINAL UNIFIED SCRIPT ]
-- ==============================================================================

local Services = {
    Players = game:GetService("Players"),
    Workspace = game:GetService("Workspace"),
    RunService = game:GetService("RunService"),
    ReplicatedStorage = game:GetService("ReplicatedStorage"),
    TweenService = game:GetService("TweenService"),
    TeleportService = game:GetService("TeleportService"),
    SoundService = game:GetService("SoundService"),
    CollectionService = game:GetService("CollectionService"),
    HttpService = game:GetService("HttpService"),
    UserInputService = game:GetService("UserInputService")
}

local LocalPlayer = Services.Players.LocalPlayer or Services.Players.PlayerAdded:Wait()
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ==============================================================================
-- [ UNIVERSAL EXECUTOR COMPATIBILITY & POLYFILL LAYER ]
-- Multi-executor support for Mobile (Delta) & PC (Wave, Synapse Z, Solara, Celery, MacSploit, etc.)
-- ==============================================================================

local UniversalCompat = {}

function UniversalCompat.FireProximityPrompt(prompt)
    if not prompt or not prompt.Parent then return false end

    -- Method A: Native exploit C-closure fireproximityprompt (zero synthetic input, zero property tampering)
    if typeof(fireproximityprompt) == "function" then
        local ok = pcall(fireproximityprompt, prompt, 0)
        if not ok then ok = pcall(fireproximityprompt, prompt, 1) end
        if not ok then ok = pcall(fireproximityprompt, prompt) end
        if ok then return true end
    end

    -- Method B: Engine input hold simulation matching prompt duration (no VIM, no property alteration)
    local triggered = false
    pcall(function()
        prompt:InputHoldBegin()
        local duration = tonumber(prompt.HoldDuration) or 0
        if duration > 0 then
            task.wait(duration + 0.05)
        else
            task.wait(0.04)
        end
        prompt:InputHoldEnd()
        triggered = true
    end)

    return triggered
end

function UniversalCompat.FireTouch(part1, part2)
    if not part1 or not part2 or not part1.Parent or not part2.Parent then return false end

    -- Method A: Exploit firetouchinterest C-closure
    if typeof(firetouchinterest) == "function" then
        pcall(firetouchinterest, part1, part2, 0)
        task.wait(0.01)
        pcall(firetouchinterest, part1, part2, 1)
    end

    -- Method B: Ensure physical touch properties are enabled
    pcall(function()
        if part1:IsA("BasePart") then part1.CanTouch = true end
        if part2:IsA("BasePart") then part2.CanTouch = true end
    end)

    return true
end

function UniversalCompat.ClickButton(btn)
    if not btn or not btn:IsA("GuiButton") then return false end

    -- Method A: firesignal
    if typeof(firesignal) == "function" then
        local ok1 = pcall(firesignal, btn.Activated)
        local ok2 = pcall(firesignal, btn.MouseButton1Click)
        if ok1 or ok2 then return true end
    end

    -- Method B: getconnections
    if typeof(getconnections) == "function" then
        local triggered = false
        local ok1, conns1 = pcall(getconnections, btn.Activated)
        if ok1 and type(conns1) == "table" then
            for _, c in ipairs(conns1) do
                pcall(function()
                    if c.Fire then c:Fire() elseif c.Function then c.Function() end
                end)
                triggered = true
            end
        end
        local ok2, conns2 = pcall(getconnections, btn.MouseButton1Click)
        if ok2 and type(conns2) == "table" then
            for _, c in ipairs(conns2) do
                pcall(function()
                    if c.Fire then c:Fire() elseif c.Function then c.Function() end
                end)
                triggered = true
            end
        end
        if triggered then return true end
    end

    return false
end

local saveFile = "SyntaxHub_Config.json"

local currentSettings = {
    Theme = "Sapphire",
    Transparency = 0,
    AutoFarm = false,
    FastSteal = false,
    AutoTreadmill = false,
    AutoUpgradeTreadmill = false,
    AutoUpgradeBase = false,
    AutoClaimMastery = false,
    AutoCatchButterfly = false,
    AutoWispQuest = false,
    AutoTradeUp = false,
    AutoCraftEssence = false,
    ButterflySpeed = 320,
    TargetAreas = { ["All"] = true },
    MinRarity = "All",
    AutoCandyCane = false,
    AutoPumpkin = false,
    AutoBossEvent = false,
    AutoGhostDog = false,
    AutoFishing = false,
    CastLuck = "x1.5 Perfect",
    AutoBuyHalloweenEgg = false,
    AutoHalloweenSteal = false,
    HalloweenTargetAreas = { ["All"] = true },
    HalloweenMinRarity = "All",
    TaskPriorities = {
        "Auto Boss",
        "Auto Steal",
        "Candy Cane Farm",
        "Auto Pumpkin",
        "Enchanted / Bloom Event",
        "Auto Upgrades",
        "Auto Treadmill"
    }
}

local function saveStuff()
    if writefile then
        pcall(function()
            writefile(saveFile, Services.HttpService:JSONEncode(currentSettings))
        end)
    end
end

local function loadStuff()
    if isfile and readfile and isfile(saveFile) then
        pcall(function()
            local decoded = Services.HttpService:JSONDecode(readfile(saveFile))
            if decoded and type(decoded) == "table" then
                for k, v in pairs(decoded) do
                    if k == "TargetAreas" and type(v) == "table" then
                        currentSettings.TargetAreas = v
                    elseif k == "HalloweenTargetAreas" and type(v) == "table" then
                        currentSettings.HalloweenTargetAreas = v
                    elseif k == "TaskPriorities" and type(v) == "table" then
                        currentSettings.TaskPriorities = v
                    elseif type(v) == "table" and type(currentSettings[k]) == "table" then
                        for k2, v2 in pairs(v) do currentSettings[k][k2] = v2 end
                    else
                        currentSettings[k] = v
                    end
                end
            end
        end)
    end

    if type(currentSettings.TargetAreas) ~= "table" or next(currentSettings.TargetAreas) == nil then
        currentSettings.TargetAreas = { ["All"] = true }
    end
        if type(currentSettings.MinRarity) ~= "string" or string.find(currentSettings.MinRarity, "table:") then
        currentSettings.MinRarity = "All"
    end
    if type(currentSettings.HalloweenTargetAreas) ~= "table" or next(currentSettings.HalloweenTargetAreas) == nil then
        currentSettings.HalloweenTargetAreas = { ["All"] = true }
    end
    if type(currentSettings.HalloweenMinRarity) ~= "string" or string.find(currentSettings.HalloweenMinRarity, "table:") then
        currentSettings.HalloweenMinRarity = "All"
    end
    end

loadStuff()

getgenv().config = getgenv().config or {}
getgenv().config.targetAreas = currentSettings.TargetAreas
getgenv().config.minRarity = currentSettings.MinRarity
getgenv().config.autoFarm = currentSettings.AutoFarm
getgenv().config.fastSteal = currentSettings.FastSteal
getgenv().config.autoTreadmill = currentSettings.AutoTreadmill
getgenv().config.autoUpgradeTreadmill = currentSettings.AutoUpgradeTreadmill
getgenv().config.autoUpgradeBase = currentSettings.AutoUpgradeBase
getgenv().config.autoClaimMastery = currentSettings.AutoClaimMastery
getgenv().config.autoCatchButterfly = currentSettings.AutoCatchButterfly
getgenv().config.autoWispQuest = currentSettings.AutoWispQuest
getgenv().config.autoTradeUp = currentSettings.AutoTradeUp
getgenv().config.autoCraftEssence = currentSettings.AutoCraftEssence
getgenv().config.butterflySpeed = currentSettings.ButterflySpeed
getgenv().config.autoHalloweenSteal = currentSettings.AutoHalloweenSteal == true
getgenv().InstantStealHalloween = currentSettings.AutoHalloweenSteal == true
getgenv().config.halloweenTargetAreas = currentSettings.HalloweenTargetAreas
getgenv().config.halloweenMinRarity = currentSettings.HalloweenMinRarity
getgenv().config.autoCandyCane = currentSettings.AutoCandyCane
getgenv().config.autoPumpkin = currentSettings.AutoPumpkin
getgenv().AutoCatchPumpkins = currentSettings.AutoPumpkin
getgenv().config.autoBossEvent = currentSettings.AutoBossEvent == true
getgenv().AutoBossEvent = getgenv().config.autoBossEvent
getgenv().config.autoGhostDog = currentSettings.AutoGhostDog == true
getgenv().config.autoFishing = currentSettings.AutoFishing == true
getgenv().config.castLuck = currentSettings.CastLuck or "x1.5 Perfect"
getgenv().config.autoBuyHalloweenEgg = currentSettings.AutoBuyHalloweenEgg == true

local HalloweenPortalManager, HalloweenAreaManager, HalloweenCombatManager, HalloweenPumpkinManager, HalloweenStealManager, HalloweenBossManager, GhostDogManager, HalloweenFishingManager, PriorityManager, getBestEgg, DynamicRarityResolver, activeTheme, Window

local State = {
    currentStealSession = 0,
    isStealingActive = false,
    activeFlightConnection = nil,
    activeCollisionsDisabled = {},
    targetedSpecificUid = nil,
    targetedSpecificIsHalloween = false,
    blacklistedEggs = {},
    lastServerRollbackTime = 0,
    myPlot = nil,
    myTreadmill = nil,
    treadmillFailCount = 0,
    lastResetTime = 0,
    baseUpgradeCooldown = 0,
    treadmillUpgradeCooldown = 0,
    activeStealButtons = {},
    themeSubscribers = {},
    themeName = currentSettings.Theme or "Sapphire",
    isOpn = true,
    curCat = 1,
    activeOpenedDropdown = nil,
    spSortChoice = "Value (Money/s)",
    spSortIndex = 1,
    halloweenIdleSince = nil,
    halloweenIdleCooldownUntil = 0,
    halloweenEggBuyCooldown = 0
}

local CONFIG = {
    HopDistance = 230,
    HopGap = 0.06,
    HopGapMin = 0.05,
    HopGapMax = 0.20,
    FlightAltitude = 71.5,
    HopAltitude = 71.8,
    GroundAltitude = 70.8,
    AirGrabOffset = 1.2,
    CheckpointInterval = 1600,
    BoundaryCheckpointX = 600.2,
    SeparationLineX = 552.2,
    FastStealLineDropOffset = 45,
    -- FastStealHopSpeed removed: no air hopping
    -- FastStealGroundSpeed removed: strictly uses natural hum.WalkSpeed
    FastStealDirectSnapRadius = 45,
    BaseDropPosition = Vector3.new(528.7, 70.8, -364.1)
}

-- ==============================================================================
-- [ DIMENSION DETECTION HELPER ]
-- ==============================================================================
local HALLOWEEN_DIM_CENTER = Vector3.new(-5808, -200, -7376)
local HALLOWEEN_RADIUS = 2500

local function isInHalloweenDimension()
    if LocalPlayer:GetAttribute("InHalloweenDimension") == true then
        return true
    end
    local char = LocalPlayer.Character
    local root = char and (char:FindFirstChild("HumanoidRootPart") or char.PrimaryPart)
    if root then
        local dist = (root.Position - HALLOWEEN_DIM_CENTER).Magnitude
        if dist <= HALLOWEEN_RADIUS then
            return true
        end
    end
    return false
end

-- ==============================================================================
-- [ HELPER FUNCTIONS & NETWORK DISPATCHERS ]
-- ==============================================================================
local function formatMoneyPerSec(val)
    local n = tonumber(val) or 0
    if n >= 1e12 then return string.format("$%.2fT/s", n / 1e12) end
    if n >= 1e9 then return string.format("$%.2fB/s", n / 1e9) end
    if n >= 1e6 then return string.format("$%.2fM/s", n / 1e6) end
    if n >= 1e3 then return string.format("$%.2fK/s", n / 1e3) end
    return string.format("$%.1f/s", n)
end

local function cleanName(name)
    return tostring(name or ""):lower():gsub("[Ee]gg", ""):gsub("[^%w]", "")
end

local function isBlacklisted(uid)
    if not uid then return false end
    local exp = State.blacklistedEggs[uid]
    if exp and exp > os.clock() then return true end
    if exp then State.blacklistedEggs[uid] = nil end
    return false
end

local function blacklistEgg(uid, duration)
    if uid then State.blacklistedEggs[uid] = os.clock() + (duration or 15) end
end

local function isNightPhase()
    local client = Services.ReplicatedStorage:FindFirstChild("Client")
    local cycleModule = client and client:FindFirstChild("AreaEggCycle")
    if cycleModule and cycleModule:IsA("ModuleScript") then
        local ok, mod = pcall(require, cycleModule)
        if ok and type(mod) == "table" and type(mod.IsNightPhase) == "function" then
            local nightOk, res = pcall(mod.IsNightPhase, workspace:GetServerTimeNow())
            return nightOk and res == true
        end
    end
    return false
end

local function isWallSealed()
    local client = Services.ReplicatedStorage:FindFirstChild("Client")
    local wallModule = client and client:FindFirstChild("AreaEggResetWall")
    if wallModule and wallModule:IsA("ModuleScript") then
        local ok, mod = pcall(require, wallModule)
        if ok and type(mod) == "table" and type(mod.IsSealed) == "function" then
            local sealedOk, res = pcall(mod.IsSealed)
            return sealedOk and res == true
        end
    end

    local world = Services.Workspace:FindFirstChild("World") or Services.Workspace:FindFirstChild("__OBJECTS")
    local areas = world and world:FindFirstChild("Areas")
    local wallCol = areas and areas:FindFirstChild("WallStartCollision")
    return (wallCol and wallCol:IsA("BasePart") and wallCol.CanCollide == true) or false
end

local function isMapClosed()
    return isNightPhase() or isWallSealed()
end

local function isHalloweenMapClosed()
    if isMapClosed() then return true end
    local dim = Services.Workspace:FindFirstChild("HalloweenDimension", true)
    if dim then
        local nightWall = dim:FindFirstChild("NightWall", true)
        if nightWall then
            local barrier = nightWall:FindFirstChild("Barrier") or nightWall:FindFirstChildWhichIsA("BasePart")
            if barrier and barrier:IsA("BasePart") and barrier.CanCollide == true then
                return true
            end
        end
    end
    return false
end

local function isNormalStealPanelTarget()
    return State.targetedSpecificUid ~= nil and not State.targetedSpecificIsHalloween
end

local function isStealEnabled()
    if isMapClosed() then return false end
    return getgenv().config.autoFarm == true or isNormalStealPanelTarget()
end

local function isFastStealArea(areaId)
    if not areaId then return false end
    local clean = cleanName(areaId)
    return clean:find("titan", 1, true) ~= nil 
        or clean:find("light", 1, true) ~= nil 
        or clean:find("enchanted", 1, true) ~= nil
end

local function matchesTargetArea(areaId)
    local targetAreas = getgenv().config.targetAreas or { ["All"] = true }
    if targetAreas["All"] == true or next(targetAreas) == nil then return true end
    if not areaId then return false end
    local cleanArea = tostring(areaId):lower():gsub("[^%w]", "")
    for selArea, selVal in pairs(targetAreas) do
        if selVal == true and selArea ~= "All" then
            local cleanSel = tostring(selArea):lower():gsub("[^%w]", "")
            if cleanArea == cleanSel or cleanArea:find(cleanSel, 1, true) or cleanSel:find(cleanArea, 1, true) then
                return true
            end
        end
    end
    return false
end

local function getRemote(pathName)
    local packages = Services.ReplicatedStorage:FindFirstChild("Packages")
    local networking = packages and packages:FindFirstChild("Networking")
    local remote = networking and networking:FindFirstChild(pathName)
    if not remote then
        for _, desc in ipairs(Services.ReplicatedStorage:GetDescendants()) do
            if (desc:IsA("RemoteFunction") or desc:IsA("RemoteEvent")) and desc.Name == pathName then
                return desc
            end
        end
    end
    return remote
end

local Remotes = {
    AskFieldEggDrop = getRemote("RF/EggWorld/AskFieldEggDrop"),
    AskFieldEggCarry = getRemote("RF/EggWorld/AskFieldEggCarry"),
    AskDoff = getRemote("RF/Treadmill/AskDoff"),
    AskWearStill = getRemote("RF/Treadmill/AskWearStill"),
    AskSnapshot = getRemote("RF/EggWorld/AskFieldEggSnapshot"),
    TierRaise = getRemote("RF/Treadmill/AskTierRaise"),
    BaseTierRaise = getRemote("RE/Homestead/AskBaseTierRaise"),
    AskRigWipe = getRemote("RE/RigSync/AskRigWipe"),
    ClaimNet = getRemote("RF/Butterflies/AskClaimNet"),
    TradeUp = getRemote("RF/Butterflies/AskTradeUp"),
    CraftEssence = getRemote("RF/Butterflies/AskCraftEssence"),
    WispRequest = getRemote("RF/WispCompanion/Request")
}

local function invokeRemote(pathName, ...)
    local remote = getRemote(pathName)
    if remote and remote:IsA("RemoteFunction") then
        local ok, r1, r2, r3 = pcall(function(...) return remote:InvokeServer(...) end, ...)
        if ok then return true, r1, r2, r3 end
        return false, r1
    end
    return false, "RemoteFunction not found: " .. tostring(pathName)
end

local function fireRemote(pathName, ...)
    local remote = getRemote(pathName)
    if remote and remote:IsA("RemoteEvent") then
        pcall(function(...) remote:FireServer(...) end, ...)
        return true
    end
    return false
end

local clientFolder = Services.ReplicatedStorage:WaitForChild("Client", 5)
local eggStateModule = clientFolder and clientFolder:WaitForChild("EggState", 5)
local EggState = eggStateModule and require(eggStateModule) or nil

pcall(function()
    local packages = Services.ReplicatedStorage:WaitForChild("Packages", 5)
    local networking = packages and packages:WaitForChild("Networking", 5)
    local refreshRemote = networking and networking:FindFirstChild("RE/RigSync/Refresh")
    if refreshRemote and refreshRemote:IsA("RemoteEvent") then
        refreshRemote.OnClientEvent:Connect(function(packet)
            if type(packet) == "table" and packet.Action == "Relocate" then
                State.lastServerRollbackTime = os.clock()
            end
        end)
    end
end)

-- ==============================================================================
-- [ CHARACTER RIG, GODMODE, & RECOVERY PIPELINE ]
-- ==============================================================================
local function getAliveRig()
    local char = LocalPlayer.Character
    if not char then return nil, nil, nil end
    local root = char:FindFirstChild("HumanoidRootPart")
    local hum = char:FindFirstChildOfClass("Humanoid")
    if root and hum and hum.Health > 0 then
        return char, root, hum
    end
    return nil, nil, nil
end

local function applyGodMode(character)
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    -- Respect server ragdoll duration (BAC-10518 protection): never destroy constraints while server ragdoll timer is active
    local ragdollEndTime = tonumber(LocalPlayer:GetAttribute("RagdollEndTime")) or 0
    if ragdollEndTime > workspace:GetServerTimeNow() then
        return
    end

    local blockedStates = {
        Enum.HumanoidStateType.FallingDown,
        Enum.HumanoidStateType.Ragdoll,
        Enum.HumanoidStateType.Physics
    }
    for _, state in ipairs(blockedStates) do
        pcall(function() humanoid:SetStateEnabled(state, false) end)
    end
    pcall(function() humanoid.BreakJointsOnDeath = false end)

    -- BAC-7516 protection: Never touch constraints or Motor6Ds inside a Tool (preserves egg/weapon welds)
    for _, desc in ipairs(character:GetDescendants()) do
        if not desc:FindFirstAncestorWhichIsA("Tool") then
            if desc:IsA("BallSocketConstraint") or desc:IsA("HingeConstraint") or 
              (desc:IsA("NoCollisionConstraint") and string.find(desc.Name, "Ragdoll", 1, true)) then
                pcall(function() desc:Destroy() end)
            elseif desc:IsA("Motor6D") and not desc.Enabled then
                desc.Enabled = true
            end
        end
    end
end

local function setCollisions(enabled)
    local char = LocalPlayer.Character
    if not char then return end
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = enabled
        end
    end
end

local function cleanupFlightState()
    if State.activeFlightConnection then
        pcall(function() State.activeFlightConnection:Disconnect() end)
        State.activeFlightConnection = nil
    end

    local _, root, hum = getAliveRig()
    if hum then
        pcall(function()
            hum.PlatformStand = false
            hum.Sit = false
            hum:ChangeState(Enum.HumanoidStateType.Running)
        end)
    end
    if root then
        pcall(function()
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end)
    end

    for part, _ in pairs(State.activeCollisionsDisabled) do
        if part and part.Parent then
            pcall(function() part.CanCollide = true end)
        end
    end
    table.clear(State.activeCollisionsDisabled)
    setCollisions(true)
end

-- ==============================================================================
-- [ AUDIO & HUD SUPPRESSION MANAGERS ]
-- ==============================================================================
local ChaseAudioManager = {
    ActiveSiren = nil,
    SavedTimePos = 0,
    HeartbeatConn = nil,
    NewSoundConn = nil
}

function ChaseAudioManager:LockAudio()
    self:UnlockAudio()
    task.spawn(function()
        for _ = 1, 15 do
            if not getgenv().StealUILocked then break end
            local runGui = PlayerGui:FindFirstChild("RunBackEffects")
            if runGui then
                for _, s in ipairs(runGui:GetDescendants()) do
                    if s:IsA("Sound") and s.IsPlaying then
                        self.ActiveSiren = s
                        break
                    end
                end
            end
            if self.ActiveSiren then break end
            task.wait(0.1)
        end

        if self.ActiveSiren then
            local siren = self.ActiveSiren
            local sId = siren.SoundId
            local sName = siren.Name

            if self.HeartbeatConn then self.HeartbeatConn:Disconnect() end
            self.HeartbeatConn = Services.RunService.Heartbeat:Connect(function()
                if not getgenv().StealUILocked then return end
                if siren and siren.Parent then
                    if siren.IsPlaying and siren.TimePosition > 0.15 then
                        self.SavedTimePos = siren.TimePosition
                    elseif not siren.IsPlaying and self.SavedTimePos > 0.1 then
                        siren.TimePosition = self.SavedTimePos
                        siren.Playing = true
                    elseif siren.IsPlaying and siren.TimePosition < 0.2 and self.SavedTimePos > 0.5 then
                        siren.TimePosition = self.SavedTimePos
                    end
                end
            end)

            if self.NewSoundConn then self.NewSoundConn:Disconnect() end
            self.NewSoundConn = Services.SoundService.DescendantAdded:Connect(function(newSnd)
                if getgenv().StealUILocked and newSnd:IsA("Sound") and newSnd ~= siren then
                    if newSnd.SoundId == sId or newSnd.Name == sName then
                        newSnd.Volume = 0
                        task.defer(function() pcall(function() newSnd:Stop() end) end)
                    end
                end
            end)
        end
    end)
end

function ChaseAudioManager:UnlockAudio()
    if self.HeartbeatConn then self.HeartbeatConn:Disconnect(); self.HeartbeatConn = nil end
    if self.NewSoundConn then self.NewSoundConn:Disconnect(); self.NewSoundConn = nil end
    if self.ActiveSiren and self.ActiveSiren.Parent then
        pcall(function() self.ActiveSiren:Stop() end)
    end
    self.ActiveSiren = nil
    self.SavedTimePos = 0
end

local StealUIManager = {
    Connections = {},
    NormalGameplayGuis = {}
}

function StealUIManager:SnapshotNormalHUD()
    table.clear(self.NormalGameplayGuis)
    for _, gui in ipairs(PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Enabled == true then
            if gui.Name ~= "SyntaxHubGUI" and gui.Name ~= "RunBackEffects" and gui.Name ~= "DropHeldEgg" then
                self.NormalGameplayGuis[gui] = true
            end
        end
    end
end

function StealUIManager:Lock()
    if getgenv().StealUILocked then return end
    getgenv().StealUILocked = true

    for _, c in ipairs(self.Connections) do pcall(function() c:Disconnect() end) end
    table.clear(self.Connections)

    for gui, _ in pairs(self.NormalGameplayGuis) do
        if gui and gui.Parent then
            gui.Enabled = false
            local c = gui:GetPropertyChangedSignal("Enabled"):Connect(function()
                if getgenv().StealUILocked and gui.Enabled then
                    gui.Enabled = false
                end
            end)
            table.insert(self.Connections, c)
        end
    end
    ChaseAudioManager:LockAudio()
end

function StealUIManager:Unlock()
    getgenv().StealUILocked = false

    for _, c in ipairs(self.Connections) do pcall(function() c:Disconnect() end) end
    table.clear(self.Connections)

    for gui, _ in pairs(self.NormalGameplayGuis) do
        if gui and gui.Parent then
            gui.Enabled = true
        end
    end
    table.clear(self.NormalGameplayGuis)
    ChaseAudioManager:UnlockAudio()
end

-- ==============================================================================
-- [ ANTI-CHEAT & UGI SHIELD CONTROLLER ]
-- ==============================================================================
local ShieldManager = {
    OriginalHumanoid = nil,
    CloneHumanoid = nil,
    Links = {},
    DisabledUGI = {}
}

function ShieldManager:RebindControls(humanoid)
    pcall(function()
        local playerScripts = LocalPlayer:FindFirstChild("PlayerScripts")
        local playerModule = playerScripts and playerScripts:FindFirstChild("PlayerModule")
        if playerModule then
            local controls = require(playerModule):GetControls()
            if type(controls) == "table" then
                controls.humanoid = humanoid
            end
        end
    end)
end

function ShieldManager:CleanupLinks()
    for _, conn in ipairs(self.Links) do pcall(function() conn:Disconnect() end) end
    table.clear(self.Links)
end

function ShieldManager:ApplyHumanoidSwap(character)
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid or humanoid.Health <= 0 then return end
    if self.CloneHumanoid and self.CloneHumanoid.Parent == character then return end

    self:CleanupLinks()
    local clone = humanoid:Clone()
    humanoid.Parent = nil
    clone.Parent = character
    Services.Workspace.CurrentCamera.CameraSubject = clone
    self:RebindControls(clone)

    self.OriginalHumanoid = humanoid
    self.CloneHumanoid = clone

    table.insert(self.Links, clone:GetPropertyChangedSignal("Health"):Connect(function()
        if clone and clone.Parent and clone.Health < clone.MaxHealth then
            clone.Health = clone.MaxHealth
        end
    end))

    table.insert(self.Links, humanoid:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
        if clone and clone.Parent then
            clone.WalkSpeed = humanoid.WalkSpeed
        end
    end))

    table.insert(self.Links, clone.Died:Connect(function()
        self:UndoSwap()
    end))
end

function ShieldManager:UndoSwap()
    self:CleanupLinks()
    local char = LocalPlayer.Character
    local orig = self.OriginalHumanoid
    local clone = self.CloneHumanoid
    self.OriginalHumanoid = nil
    self.CloneHumanoid = nil

    if orig and clone and char and orig.Parent == nil and clone.Parent == char then
        orig.Parent = char
        Services.Workspace.CurrentCamera.CameraSubject = orig
        self:RebindControls(orig)
        pcall(function() clone:Destroy() end)
    end
end

local function isMonitorAction(fn)
    if not debug or not debug.getconstants then return false end
    local ok, consts = pcall(debug.getconstants, fn)
    if not ok or type(consts) ~= "table" then return false end
    for _, val in pairs(consts) do
        if val == "Relocate" or val == "SetWalkSpeed" or val == "BeginRagdoll" or val == "BeginImpulse" then
            return true
        end
    end
    return false
end

function ShieldManager:MuteUGI()
    if type(getconnections) ~= "function" then return end
    for _, event in ipairs({ Services.RunService.Heartbeat, Services.RunService.PreSimulation, Services.RunService.PostSimulation }) do
        for _, conn in ipairs(getconnections(event)) do
            local fn = conn.Function
            if typeof(fn) == "function" then
                local ok, src = pcall(debug.info, fn, "s")
                if ok and src and string.find(tostring(src), "UGI", 1, true) then
                    if not isMonitorAction(fn) and conn.Enabled then
                        if pcall(function() conn:Disable() end) then
                            table.insert(self.DisabledUGI, conn)
                        end
                    end
                end
            end
        end
    end
end

function ShieldManager:UnmuteUGI()
    for _, conn in ipairs(self.DisabledUGI) do
        pcall(function() conn:Enable() end)
    end
    table.clear(self.DisabledUGI)
end

-- Cleanly resets character on server if flagged or blocked from treadmill
local function resetFlaggedCharacter()
    if os.clock() - State.lastResetTime < 15 then return end
    State.lastResetTime = os.clock()
    State.treadmillFailCount = 0

    pcall(function() ShieldManager:UndoSwap() end)
    if Remotes.AskDoff then
        pcall(function() Remotes.AskDoff:InvokeServer() end)
    end

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if char and hum then
        pcall(function()
            hum:UnequipTools()
            hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
            hum.BreakJointsOnDeath = true
            hum.RequiresNeck = true
            hum.Health = 0
            hum:ChangeState(Enum.HumanoidStateType.Dead)
            char:BreakJoints()
        end)
        if Remotes.AskRigWipe then
            pcall(function() Remotes.AskRigWipe:FireServer(char) end)
        end
    end
end

local function abortStealRoutine()
    State.currentStealSession = State.currentStealSession + 1
    State.isStealingActive = false
    if State.targetedSpecificUid then
        if State.activeStealButtons[State.targetedSpecificUid] then
            State.activeStealButtons[State.targetedSpecificUid].BackgroundColor3 = activeTheme and activeTheme.Accent or Color3.fromRGB(92, 170, 255)
            State.activeStealButtons[State.targetedSpecificUid].Text = "Steal"
        end
        State.targetedSpecificUid = nil
    end

    if PriorityManager then
        PriorityManager:Release("Steal")
        PriorityManager:Release("Auto Steal")
    end

    ShieldManager:UnmuteUGI()
    ShieldManager:UndoSwap()
    StealUIManager:Unlock()
    cleanupFlightState()
    setCollisions(true)

    local _, root, hum = getAliveRig()
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
    if hum then
        hum.PlatformStand = false
        hum.Sit = false
    end
end

local function isAtBasePlot()
    local _, root = getAliveRig()
    if not root then return false end
    return (root.Position - CONFIG.BaseDropPosition).Magnitude <= 45
end

LocalPlayer.CharacterAdded:Connect(function(newChar)
    task.wait(0.3)
    abortStealRoutine()
    applyGodMode(newChar)
end)

if LocalPlayer.Character then
    applyGodMode(LocalPlayer.Character)
end

-- ==============================================================================
-- [ PET & RARITY MASTER REGISTRY ]
-- ==============================================================================
local MasterRegistry = {
    RarityRanks = {},
    PetDatabase = {},
    IsReady = false
}

function MasterRegistry:Build()
    local dataFolder = Services.ReplicatedStorage:FindFirstChild("Data")
    if not dataFolder then return false end

    self.RarityRanks = {
        Common = 1, Uncommon = 2, SuperRare = 2, Rare = 3, Epic = 4,
        Legendary = 5, Mythic = 6, Rainbow = 6, Cosmic = 7, Secret = 8,
        Limited = 9, Eternal = 9, Divine = 10, Transcendent = 10
    }

    local assetsModule = dataFolder:FindFirstChild("Assets")
    if assetsModule and assetsModule:IsA("ModuleScript") then
        local s, assets = pcall(require, assetsModule)
        if s and type(assets) == "table" and type(assets.Directory) == "table" then
            for pName, pData in pairs(assets.Directory) do
                if type(pData) == "table" and pData.Rarity and type(pData.Rarity) == "table" then
                    local rId = pData.Rarity._id or pData.Rarity.DisplayName
                    local rRank = tonumber(pData.Rarity.RarityNumber or pData.Rarity.Rank) or (rId and self.RarityRanks[rId]) or 1
                    self.PetDatabase[tostring(pName)] = {
                        Rarity = tostring(rId or "Unknown"),
                        Rank = rRank,
                        Icon = pData.Icon or "",
                        EarningRate = tonumber(pData.EarningRate) or 0
                    }
                end
            end
        end
    end

    self.IsReady = true
    return true
end

function MasterRegistry:Lookup(rawName)
    if not rawName then return "Common", 1 end
    rawName = tostring(rawName)
    local direct = self.PetDatabase[rawName]
    if direct then return direct.Rarity, direct.Rank end
    if self.RarityRanks[rawName] then return rawName, self.RarityRanks[rawName] end

    local clean = rawName:gsub("[Ee]gg", ""):gsub("[Pp]ure", ""):gsub("[Gg]olden", ""):gsub("[Ss]hiny", ""):gsub("^%s+", ""):gsub("%s+$", "")
    local cleaned = self.PetDatabase[clean]
    if cleaned then return cleaned.Rarity, cleaned.Rank end

    for petName, data in pairs(self.PetDatabase) do
        if string.find(rawName, petName, 1, true) then
            return data.Rarity, data.Rank
        end
    end
    return "Common", 1
end

MasterRegistry:Build()

local NameResolver = { Aliases = {} }
function NameResolver:Register(name1, name2)
    if not name1 then return end
    local c1 = cleanName(name1)
    self.Aliases[c1] = c1
    if name2 then
        local c2 = cleanName(name2)
        self.Aliases[c2] = c1
    end
end

function NameResolver:Build()
    local dataFolder = Services.ReplicatedStorage:FindFirstChild("Data")
    local assetsModule = dataFolder and dataFolder:FindFirstChild("Assets")
    if assetsModule and assetsModule:IsA("ModuleScript") then
        local s, assets = pcall(require, assetsModule)
        if s and type(assets) == "table" and type(assets.Directory) == "table" then
            for id, data in pairs(assets.Directory) do
                self:Register(id, type(data) == "table" and data.DisplayName or nil)
            end
        end
    end
    self:Register("Kaiju Spider", "Spideron")
    self:Register("Blade Head", "Bladehide")
    self:Register("Snowy Owl", "Snowy Owl")
    self:Register("Salamander", "Salamander")
    self:Register("Cosmic Fox", "Cosmic Fox")
    self:Register("Spirit Hare", "Spirit Hare")
    self:Register("Demon Hound", "Demon Hound")
    self:Register("Spirit Panda", "Spirit Panda")
end

function NameResolver:Matches(name1, name2)
    if not name1 or not name2 then return false end
    local c1, c2 = cleanName(name1), cleanName(name2)
    if c1 == c2 then return true end
    if self.Aliases[c1] and self.Aliases[c2] and self.Aliases[c1] == self.Aliases[c2] then return true end
    if self.Aliases[c1] and self.Aliases[c1] == c2 then return true end
    if self.Aliases[c2] and self.Aliases[c2] == c1 then return true end
    if c1:find(c2, 1, true) or c2:find(c1, 1, true) then return true end
    return false
end

NameResolver:Build()

local EggDetector = { IsHolding = false }
function EggDetector:CheckHolding()
    if EggState and typeof(EggState) == "table" then
        if EggState.Carrying == true or (EggState.CarryUid ~= nil and EggState.CarryUid ~= "") then
            return true
        end
    end
    local dropGui = PlayerGui:FindFirstChild("DropHeldEgg")
    local runGui = PlayerGui:FindFirstChild("RunBackEffects")
    if (dropGui and dropGui:IsA("ScreenGui") and dropGui.Enabled) or 
       (runGui and runGui:IsA("ScreenGui") and runGui.Enabled) then
        return true
    end

    -- Universal check for seasonal "Drop" button ONLY inside Halloween dimension
    if isInHalloweenDimension() then
        for _, gui in ipairs(PlayerGui:GetChildren()) do
            if gui:IsA("ScreenGui") and gui.Enabled and gui.Name ~= "HalloweenDirectGrabGUI" and gui.Name ~= "SyntaxHubGUI" then
                local btn = gui:FindFirstChild("Drop", true)
                if btn and (btn:IsA("TextButton") or btn:IsA("ImageButton")) then
                    return true
                end
            end
        end
    end
    return false
end

local function isHoldingEgg()
    return EggDetector:CheckHolding()
end

local function hopOffTreadmill()
    pcall(function()
        if Remotes.AskDoff then Remotes.AskDoff:InvokeServer() end
    end)
    local _, root, hum = getAliveRig()
    if root then
        root.Anchored = false
        root.CFrame = root.CFrame + root.CFrame.LookVector * 6
    end
    if hum then
        hum.PlatformStand = false
        hum.Sit = false
        pcall(function()
            hum.Jump = true
            hum:ChangeState(Enum.HumanoidStateType.Jumping)
        end)
    end
end

local function dropHeldEggDirect()
    if EggState and typeof(EggState.DropFieldEgg) == "function" then
        pcall(function() EggState.DropFieldEgg("PlayerRequest") end)
    end
    if Remotes.AskFieldEggDrop then
        pcall(function() Remotes.AskFieldEggDrop:InvokeServer({ Reason = "PlayerRequest" }) end)
    end
end

local function getPlayerMoney()
    local leaderstats = LocalPlayer:FindFirstChild("leaderstats")
    if leaderstats then
        for _, child in ipairs(leaderstats:GetChildren()) do
            local lName = string.lower(child.Name)
            if lName:find("money") or lName:find("cash") or lName:find("coin") or lName:find("currency") or lName:find("gold") then
                if child:IsA("ValueBase") then return tonumber(child.Value) or 0 end
            end
        end
    end
    return 0
end

local function getSaveData()
    local saveMod = Services.ReplicatedStorage:FindFirstChild("Shared") and Services.ReplicatedStorage.Shared:FindFirstChild("Save")
    if saveMod and saveMod:IsA("ModuleScript") then
        local s, mod = pcall(require, saveMod)
        if s and type(mod) == "table" then
            local getter = type(mod.Get) == "function" and mod.Get or (type(mod.Peek) == "function" and mod.Peek)
            if getter then
                local ok, res = pcall(getter)
                if ok and type(res) == "table" then return res end
            end
        end
    end
    return nil
end

local function getPhysicalEggPosition(uid, fallbackPos)
    local eggModel = Services.Workspace:FindFirstChild(uid)
    if eggModel then
        local ok, pivot = pcall(function() return eggModel:GetPivot().Position end)
        if ok and pivot then return pivot end
    end
    local slots = Services.Workspace:FindFirstChild("AreaEggSlotsClient")
    local slotModel = slots and slots:FindFirstChild(uid)
    if slotModel then
        local ok, pivot = pcall(function() return slotModel:GetPivot().Position end)
        if ok and pivot then return pivot end
    end
    return fallbackPos
end

local function isEggStillValid(uid)
    if not uid then return false end
    if isBlacklisted(uid) then return false end
    if not EggState or type(EggState.ReadFieldEggs) ~= "function" then return true end

    local data = nil
    pcall(function() data = EggState.ReadFieldEggs() end)
    if not data or not data.Records then return true end

    for rUid, record in pairs(data.Records) do
        if rUid == uid or record.Uid == uid then
            if record.State == "Claimed" or record.State == "Carried" then return false end
            return true
        end
    end
    return false
end

local function getMinRequiredScore()
    local sel = getgenv().config.minRarity or "All"
    if sel == "All" then return 1 end
    local num = tonumber(string.match(tostring(sel), "^(%d+)"))
    return num or (MasterRegistry.RarityRanks[sel] or 1)
end

-- ==============================================================================
-- [ BLOOM & ENCHANTED EVENT CONTROLLER ]
-- ==============================================================================
local BloomManager = { 
    IsBusy = false,
    NetClaimed = false,
    LastTradeCraft = 0
}

local function getButterflyNetTool()
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChildOfClass("Backpack")
    for _, container in ipairs({char, backpack}) do
        if container then
            for _, item in ipairs(container:GetChildren()) do
                if item:IsA("Tool") and (item:GetAttribute("ButterflyNet") == true or tostring(item:GetAttribute("ItemType")) == "ButterflyNet" or item.Name == "Butterfly Net") then
                    return item
                end
            end
        end
    end
    return nil
end

local function ensureButterflyNetEquipped()
    local tool = getButterflyNetTool()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if tool and char and hum then
        if tool.Parent ~= char then
            pcall(function() hum:EquipTool(tool) end)
        end
        return tool
    end

    if Remotes.ClaimNet then
        pcall(function() Remotes.ClaimNet:InvokeServer() end)
        task.wait(0.2)
        local claimed = getButterflyNetTool()
        if claimed and char and hum and claimed.Parent ~= char then
            pcall(function() hum:EquipTool(claimed) end)
        end
        return claimed
    end
    return nil
end

function BloomManager:GetButterflies()
    local list = {}
    local swarm = Services.Workspace:FindFirstChild("ButterflyBloomSwarm")
    if swarm then
        for _, b in ipairs(swarm:GetChildren()) do
            if b:IsA("Model") or b:IsA("BasePart") then
                table.insert(list, b)
            end
        end
    end

    if #list == 0 then
        for _, b in ipairs(Services.CollectionService:GetTagged("Butterfly")) do table.insert(list, b) end
        for _, b in ipairs(Services.CollectionService:GetTagged("BloomButterfly")) do table.insert(list, b) end
        local bFolder = Services.Workspace:FindFirstChild("Butterflies") or Services.Workspace:FindFirstChild("BloomButterflies")
        if bFolder then
            for _, b in ipairs(bFolder:GetChildren()) do
                if b:IsA("Model") or b:IsA("BasePart") then table.insert(list, b) end
            end
        end
    end
    return list
end

function BloomManager:ProcessButterflies(isStealActive, hasEgg)
    if not getgenv().config.autoCatchButterfly or isStealActive or isHoldingEgg() or hasEgg then
        self.IsBusy = false
        return
    end

    local _, root, hum = getAliveRig()
    if not root or not hum then return end

    local butterflies = self:GetButterflies()
    if #butterflies == 0 then
        self.IsBusy = false
        return
    end

    self.IsBusy = true
    hopOffTreadmill()
    ensureButterflyNetEquipped()

    local speed = tonumber(getgenv().config.butterflySpeed) or 320

    for _, b in ipairs(butterflies) do
        if not getgenv().config.autoCatchButterfly or isStealActive or isHoldingEgg() or hasEgg then
            break
        end

        if b and b.Parent then
            local bPos = nil
            if b:IsA("BasePart") then
                bPos = b.Position
            elseif b:IsA("Model") then
                local ok, pivot = pcall(b.GetPivot, b)
                bPos = ok and pivot.Position or (b.PrimaryPart and b.PrimaryPart.Position)
            end

            if bPos then
                local delta = bPos - root.Position
                local timeout = os.clock() + (delta.Magnitude / speed) + 0.8

                while (bPos - root.Position).Magnitude > 4.0 and os.clock() < timeout do
                    if not getgenv().config.autoCatchButterfly or isStealActive or isHoldingEgg() then break end
                    local _, curRoot = getAliveRig()
                    if not curRoot or not b.Parent then break end

                    local diff = bPos - curRoot.Position
                    local dir = diff.Unit
                    curRoot.AssemblyLinearVelocity = dir * speed
                    curRoot.CFrame = CFrame.new(curRoot.Position + dir * math.min(speed * 0.03, diff.Magnitude))
                    Services.RunService.Heartbeat:Wait()
                end

                local _, curRoot = getAliveRig()
                if curRoot and b.Parent then
                    curRoot.CFrame = CFrame.new(bPos)
                    curRoot.AssemblyLinearVelocity = Vector3.zero

                    local part = b:IsA("BasePart") and b or b:FindFirstChildWhichIsA("BasePart")
                    if part then
                        UniversalCompat.FireTouch(curRoot, part)
                    end

                    local prompt = b:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt and prompt.Enabled then
                        UniversalCompat.FireProximityPrompt(prompt)
                    end
                    task.wait(0.06)
                end
            end
        end
    end

    local _, fRoot = getAliveRig()
    if fRoot then fRoot.AssemblyLinearVelocity = Vector3.zero end
    self.IsBusy = false
end

function BloomManager:ProcessWisps(isStealActive, hasEgg)
    if not getgenv().config.autoWispQuest or isStealActive or isHoldingEgg() or hasEgg then return end

    local _, root, hum = getAliveRig()
    if not root or not hum then return end

    local remote = Remotes.WispRequest or getRemote("RF/WispCompanion/Request")

    local save = getSaveData()
    local wispComp = save and save.WispCompanion

    local accepted = type(wispComp) == "table" and wispComp.Accepted == true
    local unlocked = type(wispComp) == "table" and wispComp.Unlocked == true

    if remote and not accepted and not unlocked then
        local world = Services.Workspace:FindFirstChild("World")
        local spawnPart = world and world:FindFirstChild("Build") and world.Build:FindFirstChild("EnchantedForestZone") and world.Build.EnchantedForestZone:FindFirstChild("WispSpawn")
        local targetPos = spawnPart and (spawnPart:IsA("BasePart") and spawnPart.Position or spawnPart:GetPivot().Position)
        if targetPos then
            self.IsBusy = true
            hopOffTreadmill()
            root.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))
            root.AssemblyLinearVelocity = Vector3.zero
            task.wait(0.2)
            pcall(function() remote:InvokeServer("Accept") end)
            task.wait(0.3)
            self.IsBusy = false
            return
        end
    elseif remote and accepted and not unlocked then
        local stage = tonumber(wispComp and wispComp.Stage) or 1
        pcall(function() remote:InvokeServer("Claim", stage) end)

        if wispComp and wispComp.Returning then
            pcall(function() remote:InvokeServer("BeginReturn") end)
            local world = Services.Workspace:FindFirstChild("World")
            local anchor = world and world:FindFirstChild("Build") and world.Build:FindFirstChild("EnchantedForestZone")
            local treeAnchor = anchor and anchor:FindFirstChild("Zone13Props") and anchor.Zone13Props:FindFirstChild("EnchantedTree") and anchor.Zone13Props.EnchantedTree:FindFirstChild("WispAnchor")
            local targetPos = treeAnchor and (treeAnchor:IsA("BasePart") and treeAnchor.Position or treeAnchor:GetPivot().Position)
            if targetPos then
                self.IsBusy = true
                hopOffTreadmill()
                root.CFrame = CFrame.new(targetPos + Vector3.new(0, 2, 0))
                root.AssemblyLinearVelocity = Vector3.zero
                task.wait(0.2)
                pcall(function() remote:InvokeServer("Return") end)
                task.wait(0.3)
                self.IsBusy = false
                return
            end
        end
    end

    -- Fallback proximity prompt check if remote not found
    local wispPrompt = nil
    for _, obj in ipairs(Services.Workspace:GetDescendants()) do
        if obj:IsA("ProximityPrompt") and (string.find(string.lower(obj.Name), "wisp", 1, true) or string.find(string.lower(obj.ActionText), "wisp", 1, true)) then
            wispPrompt = obj
            break
        end
    end

    if wispPrompt and wispPrompt.Parent and wispPrompt.Enabled then
        self.IsBusy = true
        hopOffTreadmill()
        local wPos = wispPrompt.Parent:GetPivot().Position
        root.CFrame = CFrame.new(wPos + Vector3.new(0, 2, 0))
        root.AssemblyLinearVelocity = Vector3.zero
        task.wait(0.1)

        UniversalCompat.FireProximityPrompt(wispPrompt)
        task.wait(0.3)
        self.IsBusy = false
    end
end

function BloomManager:ProcessTradeAndCraft()
    if os.clock() - self.LastTradeCraft < 2.0 then return end
    self.LastTradeCraft = os.clock()

    if getgenv().config.autoTradeUp then
        local tradeRemote = Remotes.TradeUp or getRemote("RF/Butterflies/AskTradeUp")
        if tradeRemote then
            for _, tier in ipairs({"Green", "Blue", "Purple"}) do
                pcall(function() tradeRemote:InvokeServer("ButterflyMachine", tier) end)
            end
        end
    end

    if getgenv().config.autoCraftEssence then
        local craftRemote = Remotes.CraftEssence or getRemote("RF/Butterflies/AskCraftEssence")
        if craftRemote then
            pcall(function() craftRemote:InvokeServer("MutationShrine") end)
        end
    end
end


-- ==============================================================================
-- [ HALLOWEEN DIMENSION - PORTAL & TRANSITION CONTROLLER ]
-- ==============================================================================
HalloweenPortalManager = {}
local HALLOWEEN_DIM_CENTER = Vector3.new(-5808, -200, -7376)
local HALLOWEEN_RADIUS = 2500

function HalloweenPortalManager.IsInHalloweenDimension()
    return isInHalloweenDimension()
end

HalloweenPortalManager.IsEntering = false

function HalloweenPortalManager.EnterDimension(timeout)
    timeout = timeout or 8.0
    if HalloweenPortalManager.IsInHalloweenDimension() then
        return true
    end

    if HalloweenPortalManager.IsEntering then
        local waitDeadline = os.clock() + timeout
        while os.clock() < waitDeadline and not HalloweenPortalManager.IsInHalloweenDimension() do
            Services.RunService.Heartbeat:Wait()
        end
        return HalloweenPortalManager.IsInHalloweenDimension()
    end

    HalloweenPortalManager.IsEntering = true
    hopOffTreadmill()
    task.wait(0.05)

    local _, root, hum = getAliveRig()
    if not root or not hum then
        HalloweenPortalManager.IsEntering = false
        return false
    end

    local portalModel = Services.Workspace:FindFirstChild("HalloweenDimensionPortal", true)
    local hitbox = portalModel and (portalModel:FindFirstChild("Hitbox") or portalModel:FindFirstChildWhichIsA("BasePart"))

    if not hitbox then
        HalloweenPortalManager.IsEntering = false
        return false
    end

    -- Heartbeat Linear Glide (KNOWLEDGE.md section 6.7 compliant)
    local targetPos = hitbox.Position + Vector3.new(0, 1.0, 0)
    local speed = 240 -- Standardized travel speed (180-280 studs/s)
    local stopDist = 3.0

    -- Interceptions & Bypasses
    setCollisions(false)
    hum.PlatformStand = true
    hum.AutoRotate = false

    local glideStart = os.clock()
    while (os.clock() - glideStart) < timeout do
        if HalloweenPortalManager.IsInHalloweenDimension() then
            break
        end

        local _, cRoot, cHum = getAliveRig()
        if not cRoot or not cHum or cHum.Health <= 0 then
            break
        end

        local diff = targetPos - cRoot.Position
        if diff.Magnitude <= stopDist then
            break
        end

        local dt = Services.RunService.Heartbeat:Wait()
        local dir = diff.Unit
        local step = math.min(speed * dt, diff.Magnitude)

        -- Synchronize AssemblyLinearVelocity to match displacement
        cRoot.AssemblyLinearVelocity = dir * speed
        cRoot.CFrame = CFrame.new(cRoot.Position + (dir * step), cRoot.Position + (dir * 10))
    end

    -- Trigger touch interest upon contact
    local _, fRoot, fHum = getAliveRig()
    if fRoot and hitbox and hitbox.Parent then
        fRoot.AssemblyLinearVelocity = Vector3.new(0, -0.5, 0)
        pcall(function()
            if UniversalCompat and UniversalCompat.FireTouch then
                UniversalCompat.FireTouch(fRoot, hitbox, 0)
                task.wait(0.04)
                UniversalCompat.FireTouch(fRoot, hitbox, 1)
            end
        end)
    end

    -- Restore humanoid states & collisions
    if fHum then
        fHum.PlatformStand = false
        fHum.AutoRotate = true
    end
    if fRoot then
        fRoot.AssemblyLinearVelocity = Vector3.zero
        fRoot.AssemblyAngularVelocity = Vector3.zero
    end
    setCollisions(true)

    -- Wait up to 3 seconds for server dimension replication
    local confirmWait = os.clock() + 3.0
    while os.clock() < confirmWait and not HalloweenPortalManager.IsInHalloweenDimension() do
        Services.RunService.Heartbeat:Wait()
    end

    HalloweenPortalManager.IsEntering = false
    return HalloweenPortalManager.IsInHalloweenDimension()
end

function HalloweenPortalManager.ExitDimension(timeout)
    timeout = timeout or 6.0
    if not HalloweenPortalManager.IsInHalloweenDimension() then
        return true
    end

    local _, root, hum = getAliveRig()
    if not root or not hum then return false end

    local exitPart = nil
    local dim = Services.Workspace:FindFirstChild("HalloweenDimension", true)
    if dim then
        local portalHome = dim:FindFirstChild("PortalHome", true)
        if portalHome then
            exitPart = portalHome:FindFirstChild("Portal") or portalHome:FindFirstChildWhichIsA("BasePart")
        end
        if not exitPart then
            local questBuilding = dim:FindFirstChild("Quest Building", true)
            if questBuilding then
                exitPart = questBuilding:FindFirstChild("Portal") or questBuilding:FindFirstChildWhichIsA("BasePart")
            end
        end
        if not exitPart then
            for _, desc in ipairs(dim:GetDescendants()) do
                if desc:IsA("BasePart") and desc.Name == "Portal" then
                    exitPart = desc
                    break
                end
            end
        end
    end

    if not exitPart then return false end

    -- Heartbeat Linear Glide to exit portal
    local targetPos = exitPart.Position + Vector3.new(0, 1.0, 0)
    local speed = 240
    local stopDist = 3.0

    setCollisions(false)
    hum.PlatformStand = true
    hum.AutoRotate = false

    local glideStart = os.clock()
    while (os.clock() - glideStart) < timeout do
        if not HalloweenPortalManager.IsInHalloweenDimension() then
            break
        end

        local _, cRoot, cHum = getAliveRig()
        if not cRoot or not cHum or cHum.Health <= 0 then
            break
        end

        local diff = targetPos - cRoot.Position
        if diff.Magnitude <= stopDist then
            break
        end

        local dt = Services.RunService.Heartbeat:Wait()
        local dir = diff.Unit
        local step = math.min(speed * dt, diff.Magnitude)

        cRoot.AssemblyLinearVelocity = dir * speed
        cRoot.CFrame = CFrame.new(cRoot.Position + (dir * step), cRoot.Position + (dir * 10))
    end

    local _, fRoot, fHum = getAliveRig()
    if fRoot and exitPart and exitPart.Parent then
        fRoot.AssemblyLinearVelocity = Vector3.new(0, -0.5, 0)
        pcall(function()
            if UniversalCompat and UniversalCompat.FireTouch then
                UniversalCompat.FireTouch(fRoot, exitPart, 0)
                task.wait(0.04)
                UniversalCompat.FireTouch(fRoot, exitPart, 1)
            end
        end)
    end

    if fHum then
        fHum.PlatformStand = false
        fHum.AutoRotate = true
    end
    if fRoot then
        fRoot.AssemblyLinearVelocity = Vector3.zero
        fRoot.AssemblyAngularVelocity = Vector3.zero
    end
    setCollisions(true)

    local deadline = os.clock() + 3.0
    while os.clock() < deadline and HalloweenPortalManager.IsInHalloweenDimension() do
        Services.RunService.Heartbeat:Wait()
    end

    return not HalloweenPortalManager.IsInHalloweenDimension()
end

-- [ HALLOWEEN CANONICAL AREA MANAGER ]
-- ==============================================================================
HalloweenAreaManager = {
    -- Canonical Zone Definitions
    CanonicalNames = {
        Zone1 = "Graveyard",
        Zone2 = "Haunted Swamps",
        Zone3 = "Abandoned Manor"
    },
    MasterBoundaries = {},
    IsInitialized = false
}

-- Checks if a 3D coordinate is physically inside a BasePart volume
local function isInsideBoundingBox(worldPos, part)
    if not part or not part:IsA("BasePart") then return false end
    local localPoint = part.CFrame:PointToObjectSpace(worldPos)
    local halfSize = part.Size / 2
    return math.abs(localPoint.X) <= halfSize.X
       and math.abs(localPoint.Z) <= halfSize.Z
end

-- Normalizes any raw string or alias into the official canonical name
function HalloweenAreaManager.NormalizeName(rawName)
    if not rawName then return "Unknown Area" end
    local lower = string.lower(tostring(rawName)):gsub("[^%w]", "")

    if lower:find("graveyard") or lower:find("zone1") or lower:find("cemetery") then
        return HalloweenAreaManager.CanonicalNames.Zone1
    elseif lower:find("swamp") or lower:find("hauntedswamp") or lower:find("zone2") then
        return HalloweenAreaManager.CanonicalNames.Zone2
    elseif lower:find("manor") or lower:find("abandoned") or lower:find("zone3") then
        return HalloweenAreaManager.CanonicalNames.Zone3
    end

    return tostring(rawName)
end

-- Locates and binds the master zone parts directly from HalloweenDimension.Zones
function HalloweenAreaManager:InitMasterBoundaries()
    table.clear(self.MasterBoundaries)
    local dim = Services.Workspace:FindFirstChild("HalloweenDimension", true)
    if not dim then return false end

    local zonesFolder = dim:FindFirstChild("Zones")
    if zonesFolder then
        local z1 = zonesFolder:FindFirstChild("Zone1") or zonesFolder:FindFirstChild("Graveyard")
        local z2 = zonesFolder:FindFirstChild("Zone2") or zonesFolder:FindFirstChild("Haunted Swamps") or zonesFolder:FindFirstChild("Swamps")
        local z3 = zonesFolder:FindFirstChild("Zone3") or zonesFolder:FindFirstChild("Abandoned Manor") or zonesFolder:FindFirstChild("Manor")
        if z1 and z1:IsA("BasePart") then self.MasterBoundaries[self.CanonicalNames.Zone1] = z1 end
        if z2 and z2:IsA("BasePart") then self.MasterBoundaries[self.CanonicalNames.Zone2] = z2 end
        if z3 and z3:IsA("BasePart") then self.MasterBoundaries[self.CanonicalNames.Zone3] = z3 end
    end

    if not self.MasterBoundaries[self.CanonicalNames.Zone1] or not self.MasterBoundaries[self.CanonicalNames.Zone2] or not self.MasterBoundaries[self.CanonicalNames.Zone3] then
        for _, desc in ipairs(dim:GetDescendants()) do
            if desc:IsA("BasePart") then
                local clean = self.NormalizeName(desc.Name)
                if (clean == self.CanonicalNames.Zone1 or clean == self.CanonicalNames.Zone2 or clean == self.CanonicalNames.Zone3) and not self.MasterBoundaries[clean] then
                    self.MasterBoundaries[clean] = desc
                end
            end
        end
    end

    self.IsInitialized = true
    return true
end

-- Identifies the canonical area name of any egg instance or Vector3 coordinate
function HalloweenAreaManager:GetArea(eggOrPosition)
    if not self.IsInitialized or next(self.MasterBoundaries) == nil then
        self:InitMasterBoundaries()
    end

    local targetPos = nil
    local zoneAttr = nil

    if typeof(eggOrPosition) == "Vector3" then
        targetPos = eggOrPosition
    elseif typeof(eggOrPosition) == "Instance" then
        zoneAttr = eggOrPosition:GetAttribute("Zone") or eggOrPosition:GetAttribute("AreaId") or eggOrPosition:GetAttribute("Area")
        if eggOrPosition:IsA("Model") then
            targetPos = eggOrPosition:GetPivot().Position
        elseif eggOrPosition:IsA("BasePart") then
            targetPos = eggOrPosition.Position
        end
    end

    -- 1. Check primary master bounding box parts (Descending order Zone3 -> Zone2 -> Zone1 matching hot.lua)
    if targetPos then
        if self.MasterBoundaries[self.CanonicalNames.Zone3] and isInsideBoundingBox(targetPos, self.MasterBoundaries[self.CanonicalNames.Zone3]) then
            return self.CanonicalNames.Zone3
        end
        if self.MasterBoundaries[self.CanonicalNames.Zone2] and isInsideBoundingBox(targetPos, self.MasterBoundaries[self.CanonicalNames.Zone2]) then
            return self.CanonicalNames.Zone2
        end
        if self.MasterBoundaries[self.CanonicalNames.Zone1] and isInsideBoundingBox(targetPos, self.MasterBoundaries[self.CanonicalNames.Zone1]) then
            return self.CanonicalNames.Zone1
        end
    end

    -- 2. Check the game's official server Zone attribute
    if zoneAttr then
        local zNum = tonumber(zoneAttr)
        if zNum == 1 or zoneAttr == "Zone1" then return self.CanonicalNames.Zone1 end
        if zNum == 2 or zoneAttr == "Zone2" then return self.CanonicalNames.Zone2 end
        if zNum == 3 or zoneAttr == "Zone3" then return self.CanonicalNames.Zone3 end
    end

    -- 3. Check instance name or location keyword
    if typeof(eggOrPosition) == "Instance" then
        local rawName = tostring(eggOrPosition:GetAttribute("PreparedSourceName") or eggOrPosition:GetAttribute("Location") or eggOrPosition.Name):lower()
        if rawName:find("manor") or rawName:find("abandoned") then
            return self.CanonicalNames.Zone3
        elseif rawName:find("swamp") then
            return self.CanonicalNames.Zone2
        elseif rawName:find("graveyard") or rawName:find("cemetery") then
            return self.CanonicalNames.Zone1
        end
    end

    -- 4. Distance heuristic fallback relative to SafeZone
    if targetPos then
        local dim = Services.Workspace:FindFirstChild("HalloweenDimension", true)
        local safeZone = dim and dim:FindFirstChild("Zones") and dim.Zones:FindFirstChild("SafeZone")
        if safeZone and safeZone:IsA("BasePart") then
            local dist = (Vector3.new(targetPos.X, 0, targetPos.Z) - Vector3.new(safeZone.Position.X, 0, safeZone.Position.Z)).Magnitude
            if dist <= 550 then
                return self.CanonicalNames.Zone1
            elseif dist >= 1200 then
                return self.CanonicalNames.Zone3
            else
                return self.CanonicalNames.Zone2
            end
        end
    end

    return self.CanonicalNames.Zone1
end

-- Scans all active eggs in WorldEggs and groups them by canonical area
function HalloweenAreaManager:GetEggsByArea()
    local areaMap = {
        [self.CanonicalNames.Zone1] = {},
        [self.CanonicalNames.Zone2] = {},
        [self.CanonicalNames.Zone3] = {}
    }

    local dim = Services.Workspace:FindFirstChild("HalloweenDimension", true)
    local worldEggs = dim and dim:FindFirstChild("WorldEggs")
    if not worldEggs then return areaMap end

    for _, egg in ipairs(worldEggs:GetChildren()) do
        if egg:IsA("Model") or egg:IsA("BasePart") then
            local areaName = self:GetArea(egg)
            if not areaMap[areaName] then
                areaMap[areaName] = {}
            end

            table.insert(areaMap[areaName], {
                Instance = egg,
                Name = egg:GetAttribute("PreparedSourceName") or egg.Name,
                Uid = egg:GetAttribute("HalloweenEggUid") or "NoUID",
                Position = egg:GetPivot().Position
            })
        end
    end

    return areaMap
end

-- Returns a simple table of all eggs inside a specific area
function HalloweenAreaManager:GetEggsInArea(targetAreaName)
    local canonicalTarget = self.NormalizeName(targetAreaName)
    local grouped = self:GetEggsByArea()
    return grouped[canonicalTarget] or {}
end

getgenv().HalloweenAreaManager = HalloweenAreaManager

-- ==============================================================================
-- [ HALLOWEEN COMBAT MANAGER - MONSTER FARM & WEAPON SWAPPER ]
-- ==============================================================================
HalloweenCombatManager = {
    ToolIndex = 1,
    LastSwapTime = 0,
    IsHolding = false,
    HoverHeight = 3.0,
    SwapDelay = 0.08
}

function HalloweenCombatManager:GetWeaponList()
    local weapons = {}
    local char = LocalPlayer.Character
    local backpack = LocalPlayer:FindFirstChild("Backpack")

    local function scan(container)
        if not container then return end
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") and string.find(string.lower(item.Name), "bat") then
                table.insert(weapons, item)
            end
        end
    end

    scan(char)
    scan(backpack)

    if #weapons == 0 then
        if char then
            for _, item in ipairs(char:GetChildren()) do
                if item:IsA("Tool") then table.insert(weapons, item) end
            end
        end
        if backpack then
            for _, item in ipairs(backpack:GetChildren()) do
                if item:IsA("Tool") then table.insert(weapons, item) end
            end
        end
    end
    return weapons
end

function HalloweenCombatManager:GetClosestMonster()
    local dim = Services.Workspace:FindFirstChild("HalloweenDimension", true)
    local monstersFolder = dim and dim:FindFirstChild("Monsters") or Services.Workspace:FindFirstChild("Monsters", true)
    if not monstersFolder then return nil end

    local _, root = getAliveRig()
    if not root then return nil end

    local nearest = nil
    local minDist = math.huge

    for _, monster in ipairs(monstersFolder:GetChildren()) do
        local mRoot = monster:FindFirstChild("HumanoidRootPart") or monster.PrimaryPart or monster:FindFirstChildWhichIsA("BasePart")
        if mRoot then
            local dist = (root.Position - mRoot.Position).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = monster
            end
        end
    end
    return nearest
end

function HalloweenCombatManager:Process()
    if not getgenv().config.autoCandyCane or isHalloweenMapClosed() then return end
    if not HalloweenPortalManager.IsInHalloweenDimension() then
        HalloweenPortalManager.EnterDimension(5.0)
        return
    end

    local char, root, hum = getAliveRig()
    if not char or not root or not hum then return end

    local monster = self:GetClosestMonster()
    if not monster or not monster.Parent then return end

    local monsterPart = monster:FindFirstChild("HumanoidRootPart") or monster.PrimaryPart or monster:FindFirstChildWhichIsA("BasePart")
    if not monsterPart then return end

    local hoverPosition = monsterPart.Position + Vector3.new(0, self.HoverHeight, 0)
    local combatDiff = hoverPosition - root.Position
    if combatDiff.Magnitude > 12 then
        local cSpeed = 260
        local cDir = combatDiff.Unit
        local dt = Services.RunService.Heartbeat:Wait()
        local _, liveR = getAliveRig()
        if liveR then
            liveR.AssemblyLinearVelocity = cDir * cSpeed
            liveR.CFrame = CFrame.new(liveR.Position + cDir * math.min(cSpeed * dt, combatDiff.Magnitude), monsterPart.Position)
        end
        return
    else
        root.CFrame = CFrame.lookAt(hoverPosition, monsterPart.Position)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end

    if os.clock() - self.LastSwapTime >= self.SwapDelay then
        self.LastSwapTime = os.clock()
        local weapons = self:GetWeaponList()

        if #weapons >= 2 then
            self.ToolIndex = (self.ToolIndex % #weapons) + 1
            local targetTool = weapons[self.ToolIndex]
            if targetTool then
                hum:EquipTool(targetTool)
                pcall(function() targetTool:Activate() end)
            end
        elseif #weapons == 1 then
            local singleTool = weapons[1]
            if self.IsHolding or singleTool.Parent == char then
                hum:UnequipTools()
                self.IsHolding = false
            else
                hum:EquipTool(singleTool)
                pcall(function() singleTool:Activate() end)
                self.IsHolding = true
            end
        end

        local activeTool = char:FindFirstChildOfClass("Tool")
        local handle = activeTool and (activeTool:FindFirstChild("Handle") or activeTool:FindFirstChildWhichIsA("BasePart"))
        if handle and monsterPart then
            UniversalCompat.FireTouch(handle, monsterPart)
        end
    end
end

function HalloweenCombatManager:Abort()
    if PriorityManager then PriorityManager:Release("CandyCane") end
    local _, root, hum = getAliveRig()
    if hum then hum.PlatformStand = false end
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
end

-- ==============================================================================
-- [ HALLOWEEN PUMPKIN MANAGER - AUTONOMOUS 3-ZONE RUNAWAY PUMPKIN FARMER ]
-- ==============================================================================
HalloweenPumpkinManager = {
    IsBusy = false,
    PumpkinsDeposited = 0,
    CurrentTarget = nil,
    Config = {
        AltarDepositPos = Vector3.new(-5521.6, -195.0, -6623.0),
        Bounds = {
            MinX = -7000.0,
            MaxX = -4900.0,
            MinZ = -7700.0,
            MaxZ = -4800.0
        },
        TravelSpeed = 280,
        DepositTimeout = 2.0
    }
}

function HalloweenPumpkinManager:IsEventActive()
    local worldEvent = Services.Workspace:GetAttribute("HalloweenWorldEvent") 
                    or Services.Workspace:GetAttribute("WorldEvent")
    return worldEvent == "PumpkinMoon"
end

function HalloweenPumpkinManager:IsCarrying()
    if LocalPlayer:GetAttribute("HalloweenPumpkinCarrying") == true then
        return true
    end

    local char = LocalPlayer.Character
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if root then
        for _, child in ipairs(root:GetChildren()) do
            if child:IsA("WeldConstraint") and child.Part1 and child.Part1.Name == "HumanoidRootPart" then
                if child.Part1.Parent and child.Part1.Parent.Name:find("Pumpkin") then
                    return true
                end
            end
        end
    end

    return false
end

local function triggerPumpkinPrompt(prompt)
    if not prompt or not prompt.Enabled then return false end
    return UniversalCompat.FireProximityPrompt(prompt)
end

function HalloweenPumpkinManager:GetTarget()
    local _, root = getAliveRig()
    if not root then return nil, nil, nil end

    -- Sticky Target Lock: re-evaluate only when the current target is no longer available or valid
    if self.CurrentTarget then
        local tModel = self.CurrentTarget.Model
        local tPrompt = self.CurrentTarget.Prompt
        local tPart = self.CurrentTarget.Part
        if tModel and tModel.Parent and tPrompt and tPrompt.Parent and tPrompt.Enabled and tPart and tPart.Parent then
            local distToAltar = (tPart.Position - self.Config.AltarDepositPos).Magnitude
            if distToAltar <= 300 then
                return tModel, tPrompt, tPart
            end
        end
        self.CurrentTarget = nil
    end

    local dim = Services.Workspace:FindFirstChild("HalloweenDimension", true)
    if not dim then return nil, nil, nil end

    local folder = dim:FindFirstChild("RunawayPumpkins")
    local searchList = folder and folder:GetChildren() or {}

    local closestModel = nil
    local closestPrompt = nil
    local closestPart = nil
    local minDistance = math.huge

    for _, model in ipairs(searchList) do
        if model:IsA("Model") and model.Parent then
            local prompt = model:FindFirstChildWhichIsA("ProximityPrompt", true)
            local part = model.PrimaryPart or model:FindFirstChild("HumanoidRootPart") or model:FindFirstChildWhichIsA("BasePart")

            if prompt and prompt.Enabled and part then
                local p = part.Position
                local distToAltar = (p - self.Config.AltarDepositPos).Magnitude
                if distToAltar <= 280 then
                    local distToPlayer = (root.Position - p).Magnitude
                    if distToPlayer < minDistance then
                        minDistance = distToPlayer
                        closestModel = model
                        closestPrompt = prompt
                        closestPart = part
                    end
                end
            end
        end
    end

    if closestModel and closestPrompt and closestPart then
        self.CurrentTarget = {
            Model = closestModel,
            Prompt = closestPrompt,
            Part = closestPart
        }
        return closestModel, closestPrompt, closestPart
    end

    return nil, nil, nil
end

function HalloweenPumpkinManager:GlideTo(targetPos, stopDist)
    local char, root = getAliveRig()
    if not root then return false end

    stopDist = stopDist or 3.0
    local speed = self.Config.TravelSpeed

    setCollisions(false)

    local delta = targetPos - root.Position
    local timeout = os.clock() + (delta.Magnitude / speed) + 4.0

    while (targetPos - root.Position).Magnitude > stopDist do
        if not getgenv().config.autoPumpkin or os.clock() > timeout or isHalloweenMapClosed() then
            break
        end

        local dt = Services.RunService.Heartbeat:Wait()
        local _, cRoot = getAliveRig()
        if not cRoot then break end

        local diff = targetPos - cRoot.Position
        local dir = diff.Unit
        local step = math.min(speed * dt, diff.Magnitude)

        cRoot.AssemblyLinearVelocity = dir * speed
        cRoot.CFrame = CFrame.new(cRoot.Position + dir * step, cRoot.Position + dir * 10)
    end

    local _, fRoot = getAliveRig()
    if fRoot then
        fRoot.AssemblyLinearVelocity = Vector3.zero
    end
    setCollisions(true)
    return true
end

function HalloweenPumpkinManager:Process()
    if not getgenv().config.autoPumpkin or isHalloweenMapClosed() then return end
    if self.IsBusy then return end

    if not HalloweenPortalManager.IsInHalloweenDimension() then
        HalloweenPortalManager.EnterDimension(5.0)
        return
    end

    local char, root, hum = getAliveRig()
    if not char or not root or not hum then return end

    self.IsBusy = true
    local isCarrying = self:IsCarrying()

    -- Phase 1: Deliver currently carried pumpkin to the Altar.
    if isCarrying then
        self:GlideTo(self.Config.AltarDepositPos, 3.5)

        local depositStart = os.clock()
        while (os.clock() - depositStart) < self.Config.DepositTimeout and self:IsCarrying() do
            if not getgenv().config.autoPumpkin or isHalloweenMapClosed() then break end
            local _, curRoot = getAliveRig()
            if curRoot then
                curRoot.CFrame = CFrame.new(self.Config.AltarDepositPos)
                curRoot.AssemblyLinearVelocity = Vector3.zero
            end
            Services.RunService.Heartbeat:Wait()
        end

        task.wait(0.2)
        self.PumpkinsDeposited = self.PumpkinsDeposited + 1

    -- Phase 2: Search for and capture the nearest valid pumpkin.
    else
        local pumpkinModel, prompt, targetPart = self:GetTarget()

        if pumpkinModel and prompt and targetPart then
            local speed = self.Config.TravelSpeed
            setCollisions(false)

            -- Dynamically pursue the live moving runaway pumpkin
            local chaseStart = os.clock()
            local chaseTimeout = 8.0

            while (os.clock() - chaseStart) < chaseTimeout and not self:IsCarrying() do
                if not getgenv().config.autoPumpkin or isHalloweenMapClosed() then break end
                local _, curRoot = getAliveRig()
                if not curRoot or not targetPart.Parent or not prompt.Enabled then break end

                local pPos = targetPart.Position
                local diff = pPos - curRoot.Position
                local dist = diff.Magnitude

                if dist <= (prompt.MaxActivationDistance + 2) then
                    triggerPumpkinPrompt(prompt)
                end

                if dist <= 2.5 then
                    curRoot.CFrame = CFrame.new(pPos)
                    curRoot.AssemblyLinearVelocity = Vector3.zero
                    triggerPumpkinPrompt(prompt)
                    break
                end

                local dt = Services.RunService.Heartbeat:Wait()
                local dir = diff.Unit
                local step = math.min(speed * dt, dist)

                curRoot.AssemblyLinearVelocity = dir * speed
                curRoot.CFrame = CFrame.new(curRoot.Position + dir * step, curRoot.Position + dir * 10)
            end

            -- Latch onto the target NPC and trigger the Catch prompt until picked up
            local latchStart = os.clock()
            while (os.clock() - latchStart) < 0.65 and not self:IsCarrying() do
                if not getgenv().config.autoPumpkin or isHalloweenMapClosed() then break end
                local _, curRoot = getAliveRig()
                if curRoot and targetPart and targetPart.Parent and prompt.Enabled then
                    curRoot.CFrame = CFrame.new(targetPart.Position)
                    curRoot.AssemblyLinearVelocity = Vector3.zero
                    triggerPumpkinPrompt(prompt)
                end
                Services.RunService.Heartbeat:Wait()
            end

            setCollisions(true)
            local _, endRoot = getAliveRig()
            if endRoot then endRoot.AssemblyLinearVelocity = Vector3.zero end

            task.wait(0.1)

            -- If successfully acquired, clear locked target and deliver to Altar
            if self:IsCarrying() then
                self.CurrentTarget = nil
                self:GlideTo(self.Config.AltarDepositPos, 3.5)

                local depositStart = os.clock()
                while (os.clock() - depositStart) < self.Config.DepositTimeout and self:IsCarrying() do
                    if not getgenv().config.autoPumpkin or isHalloweenMapClosed() then break end
                    local _, curRoot = getAliveRig()
                    if curRoot then
                        curRoot.CFrame = CFrame.new(self.Config.AltarDepositPos)
                        curRoot.AssemblyLinearVelocity = Vector3.zero
                    end
                    Services.RunService.Heartbeat:Wait()
                end

                task.wait(0.2)
                self.PumpkinsDeposited = self.PumpkinsDeposited + 1
            else
                if not targetPart.Parent or not prompt.Enabled then
                    self.CurrentTarget = nil
                end
            end
        else
            -- Standby pause when no valid pumpkins are active in the altar area
            task.wait(0.3)
        end
    end

    self.IsBusy = false
end

function HalloweenPumpkinManager:Abort()
    self.IsBusy = false
    setCollisions(true)
    if PriorityManager then PriorityManager:Release("Pumpkin") end
    local _, root, hum = getAliveRig()
    if hum then hum.PlatformStand = false end
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
end

-- ==============================================================================
-- [ DYNAMIC RUNTIME EGG RARITY RESOLVER (ZERO HARDCODING) ]
-- ==============================================================================
DynamicRarityResolver = {
    AssetsDirectory = nil,
    HalloweenSpecs = nil,
    RarityIndex = {},
    IsReady = false
}

function DynamicRarityResolver:Initialize()
    local dataFolder = Services.ReplicatedStorage:FindFirstChild("Data")
    if not dataFolder then return false end

    -- 1. Load Master Assets Directory
    local assetsMod = dataFolder:FindFirstChild("Assets")
    if assetsMod and assetsMod:IsA("ModuleScript") then
        local ok, data = pcall(require, assetsMod)
        if ok and type(data) == "table" and type(data.Directory) == "table" then
            self.AssetsDirectory = data.Directory
        end
    end

    -- 2. Load Halloween Pets Specs (Seasonal Module)
    local hwMod = dataFolder:FindFirstChild("HalloweenPets")
    if hwMod and hwMod:IsA("ModuleScript") then
        local ok, data = pcall(require, hwMod)
        if ok and type(data) == "table" and type(data.Specs) == "table" then
            self.HalloweenSpecs = data.Specs
        end
    end

    -- 3. Load Master Rarity Definitions for rank number fallback
    local rarityMod = dataFolder:FindFirstChild("Rarity")
    if rarityMod and rarityMod:IsA("ModuleScript") then
        local ok, data = pcall(require, rarityMod)
        if ok and type(data) == "table" then
            for rName, rInfo in pairs(data) do
                if type(rInfo) == "table" then
                    local rank = rInfo.Rank or rInfo.RarityNumber or rInfo.Order
                    if rank then
                        self.RarityIndex[tostring(rName):lower()] = tonumber(rank)
                    end
                end
            end
        end
    end

    -- Standard rank fallbacks if the Rarity module only provides helper functions
    local defaultRanks = {
        common = 1, uncommon = 2, superrare = 2, rare = 3,
        epic = 4, legendary = 5, mythic = 6, cosmic = 7,
        secret = 8, eternal = 9, divine = 10, transcendent = 10
    }
    for k, v in pairs(defaultRanks) do
        if not self.RarityIndex[k] then
            self.RarityIndex[k] = v
        end
    end

    self.IsReady = (self.AssetsDirectory ~= nil or self.HalloweenSpecs ~= nil)
    return self.IsReady
end

function DynamicRarityResolver:GetEggSourceName(eggInstance)
    if not eggInstance then return "Unknown" end

    local source = eggInstance:GetAttribute("PreparedSourceName")
                or eggInstance:GetAttribute("AssetCategory")
                or eggInstance:GetAttribute("Category")
                or eggInstance.Name

    local cleaned = tostring(source):gsub("[Ee]gg", ""):gsub("^%s+", ""):gsub("%s+$", "")
    return (cleaned ~= "") and cleaned or eggInstance.Name
end

function DynamicRarityResolver:_FormatResult(assetData, displayName)
    local rarityName = "Unknown"
    local rank = 1
    local value = tonumber(assetData.EarningRate or assetData.BaseValue) or 0

    if type(assetData.Rarity) == "table" then
        rarityName = assetData.Rarity._id or assetData.Rarity.DisplayName or "Unknown"
        rank = tonumber(assetData.Rarity.Rank or assetData.Rarity.RarityNumber) 
            or self.RarityIndex[tostring(rarityName):lower()] 
            or 1
    elseif assetData.Rarity then
        rarityName = tostring(assetData.Rarity)
        rank = self.RarityIndex[rarityName:lower()] or 1
    end

    return rarityName, rank, value, displayName
end

function DynamicRarityResolver:ResolveRarity(eggOrName)
    if not self.IsReady then
        self:Initialize()
    end

    local rawName = ""
    local eggInstance = nil

    if typeof(eggOrName) == "Instance" then
        eggInstance = eggOrName
        rawName = self:GetEggSourceName(eggOrName)
    else
        rawName = tostring(eggOrName)
    end

    local cleanTarget = rawName:gsub("[Ee]gg", ""):gsub("^%s+", ""):gsub("%s+$", "")
    local lowerTarget = cleanTarget:lower()

    -- Search Source 1: ReplicatedStorage.Data.Assets.Directory
    if self.AssetsDirectory then
        local direct = self.AssetsDirectory[cleanTarget] or self.AssetsDirectory[rawName]
        if direct and direct.Rarity then
            return self:_FormatResult(direct, cleanTarget)
        end

        for assetKey, assetData in pairs(self.AssetsDirectory) do
            local keyLower = tostring(assetKey):lower()
            local dispLower = assetData.DisplayName and tostring(assetData.DisplayName):lower() or ""

            if keyLower == lowerTarget or dispLower == lowerTarget then
                return self:_FormatResult(assetData, assetData.DisplayName or assetKey)
            end
        end

        for assetKey, assetData in pairs(self.AssetsDirectory) do
            local keyLower = tostring(assetKey):lower()
            if keyLower:find(lowerTarget, 1, true) or lowerTarget:find(keyLower, 1, true) then
                return self:_FormatResult(assetData, assetData.DisplayName or assetKey)
            end
        end
    end

    -- Search Source 2: ReplicatedStorage.Data.HalloweenPets.Specs
    if self.HalloweenSpecs then
        for specKey, specData in pairs(self.HalloweenSpecs) do
            local keyLower = tostring(specKey):lower()
            if keyLower == lowerTarget or keyLower:find(lowerTarget, 1, true) or lowerTarget:find(keyLower, 1, true) then
                local rarityName = tostring(specData.Rarity or "Unknown")
                local rank = self.RarityIndex[rarityName:lower()] or 1
                local value = specData.BaseValue or specData.EarningRate or 0
                return rarityName, rank, value, specKey
            end
        end
    end

    -- Search Source 3: Direct Model Attributes
    if eggInstance then
        local directAttr = eggInstance:GetAttribute("Rarity")
        if directAttr then
            local rName = tostring(directAttr)
            local rank = self.RarityIndex[rName:lower()] or 1
            return rName, rank, 0, cleanTarget
        end
    end

    return "Unknown", 1, 0, cleanTarget
end

function DynamicRarityResolver:MeetsMinRarity(eggInstance, minFilter)
    if not minFilter or minFilter == "All" then return true end

    local _, eggRank = self:ResolveRarity(eggInstance)
    local minRank = tonumber(string.match(tostring(minFilter), "^(%d+)"))

    if not minRank then
        minRank = self.RarityIndex[tostring(minFilter):lower()] or 1
    end

    return eggRank >= minRank
end

function DynamicRarityResolver:GetEggScore(eggInstance)
    if not eggInstance then return -math.huge end

    local rarityName, rank, baseValue = self:ResolveRarity(eggInstance)
    local scale = tonumber(eggInstance:GetAttribute("AssetScale")) or 1.0

    local mutations = eggInstance:GetAttribute("Mutations")
    local mutationBonus = (mutations and type(mutations) == "table" and #mutations > 0) and 2.5 or 1.0

    local score = (rank * 1000000) + (baseValue * (scale ^ 1.85) * mutationBonus)
    return score, rarityName, rank
end

getgenv().DynamicRarityResolver = DynamicRarityResolver

-- ==============================================================================
-- [ HALLOWEEN DIMENSION: HEADLESS INSTANT STEAL SERVICE ]
-- ==============================================================================
HalloweenStealManager = {}

do
    local Services = {
        Players = game:GetService("Players"),
        Workspace = game:GetService("Workspace"),
        RunService = game:GetService("RunService"),
        ReplicatedStorage = game:GetService("ReplicatedStorage")
    }

    local LocalPlayer = Services.Players.LocalPlayer or Services.Players.PlayerAdded:Wait()

    -- ------------------------------------------------------------------------------
    -- [ CONFIGURATION & TUNING ]
    -- ------------------------------------------------------------------------------
    local CONFIG = {
        -- Stepped transit distance across the map (studs per step)
        StepDistance = 40,
        StepDelay = 0.025,
        
        -- Speed when walking from the gate into the SafeZone (natural run speed)
        NaturalWalkSpeed = 26,
        
        -- Radius to locate the dropped egg near the gate (expanded for physics rolls)
        GateSearchRadius = 130.0,
        
        -- Settle delay after regrabbing distant eggs (Manor/Swamp)
        OriginSettleTime = 0.4,

        -- Pacing delay for Graveyard eggs before crossing the delivery line
        GraveyardDeliverDelay = 1.5,

        -- Zone boundary parameters
        GraveyardMaxDistance = 550.0,
        ManorMinDistance = 1200.0,
        TargetZoneNumber = 3,
        TargetAreaKeyword = "manor"
    }

    local State = {
        isBusy = false,
        currentSession = 0,
        cachedCarryRemote = nil,
        cachedDropRemote = nil
    }

    -- ------------------------------------------------------------------------------
    -- [ SECTION 1: CHARACTER RIG & PROTECTION ]
    -- ------------------------------------------------------------------------------

    -- Validates that the character exists, is alive, and has a valid root part
    local function getAliveRig()
        local char = LocalPlayer.Character
        if not char then return nil, nil, nil end
        local root = char:FindFirstChild("HumanoidRootPart")
        local hum = char:FindFirstChildOfClass("Humanoid")
        if root and hum and hum.Health > 0 then
            return char, root, hum
        end
        return nil, nil, nil
    end

    -- Strips ragdoll constraints and disables physics fall states
    local function applyRigProtection(character)
        if not character then return end
        local humanoid = character:FindFirstChildOfClass("Humanoid")
        if not humanoid then return end

        local blockedStates = {
            Enum.HumanoidStateType.FallingDown,
            Enum.HumanoidStateType.Ragdoll,
            Enum.HumanoidStateType.Physics
        }
        for _, state in ipairs(blockedStates) do
            pcall(function() humanoid:SetStateEnabled(state, false) end)
        end
        pcall(function() humanoid.BreakJointsOnDeath = false end)

        for _, desc in ipairs(character:GetDescendants()) do
            if desc:IsA("BasePart") then
                desc.CanCollide = false
            elseif desc:IsA("BallSocketConstraint") or desc:IsA("HingeConstraint") or 
              (desc:IsA("NoCollisionConstraint") and string.find(desc.Name, "Ragdoll", 1, true)) then
                pcall(function() desc:Destroy() end)
            elseif desc:IsA("Motor6D") and not desc.Enabled then
                desc.Enabled = true
            end
        end
    end

    -- ------------------------------------------------------------------------------
    -- [ SECTION 2: NETWORK REMOTES & POSSESSION CHECKS ]
    -- ------------------------------------------------------------------------------

    -- Resolves the server RemoteFunction for picking up an egg
    local function getCarryRemote()
        if State.cachedCarryRemote and State.cachedCarryRemote.Parent then
            return State.cachedCarryRemote
        end
        local networking = Services.ReplicatedStorage:FindFirstChild("Packages") and Services.ReplicatedStorage.Packages:FindFirstChild("Networking")
        local remote = networking and networking:FindFirstChild("RF/HalloweenDimension/AskCarryEgg")
        if not remote then
            for _, desc in ipairs(Services.ReplicatedStorage:GetDescendants()) do
                if desc:IsA("RemoteFunction") and desc.Name == "RF/HalloweenDimension/AskCarryEgg" then
                    remote = desc
                    break
                end
            end
        end
        State.cachedCarryRemote = remote
        return remote
    end

    -- Resolves the server RemoteFunction for dropping an egg
    local function getDropRemote()
        if State.cachedDropRemote and State.cachedDropRemote.Parent then
            return State.cachedDropRemote
        end
        local networking = Services.ReplicatedStorage:FindFirstChild("Packages") and Services.ReplicatedStorage.Packages:FindFirstChild("Networking")
        local remote = networking and networking:FindFirstChild("RF/HalloweenDimension/AskDropEgg")
        if not remote then
            for _, desc in ipairs(Services.ReplicatedStorage:GetDescendants()) do
                if desc:IsA("RemoteFunction") and desc.Name == "RF/HalloweenDimension/AskDropEgg" then
                    remote = desc
                    break
                end
            end
        end
        State.cachedDropRemote = remote
        return remote
    end

    -- Checks if the local player is currently holding an egg (attribute or GUI indicator)
    local function isCarryingEgg()
        if LocalPlayer:GetAttribute("HalloweenCarrying") == true then
            return true
        end

        local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
        if playerGui then
            local dropGui = playerGui:FindFirstChild("DropHeldEgg")
            if dropGui and dropGui:IsA("ScreenGui") and dropGui.Enabled then
                return true
            end

            local runGui = playerGui:FindFirstChild("RunBackEffects")
            if runGui and runGui:IsA("ScreenGui") and runGui.Enabled then
                return true
            end
        end

        return false
    end

    -- Instantly triggers an object's ProximityPrompt bypass-style
    local function interactPrompt(target)
        if not target then return false end
        local prompt = target:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt and prompt.Enabled then
            prompt.RequiresLineOfSight = false
            prompt.MaxActivationDistance = 45
            prompt.HoldDuration = 0
            if typeof(fireproximityprompt) == "function" then
                fireproximityprompt(prompt, 0)
            else
                prompt:InputHoldBegin()
                prompt:InputHoldEnd()
            end
            return true
        end
        return false
    end

    -- ------------------------------------------------------------------------------
    -- [ SECTION 3: SPATIAL ZONE & GEOMETRY CALCULATIONS ]
    -- ------------------------------------------------------------------------------

    -- Locates the physical SafeZone bounding volume part in Workspace
    local function getSafeZonePart()
        local dim = Services.Workspace:FindFirstChild("HalloweenDimension", true)
        local zones = dim and dim:FindFirstChild("Zones")
        local safeZone = zones and zones:FindFirstChild("SafeZone")
        if safeZone and safeZone:IsA("BasePart") then
            return safeZone
        end
        return nil
    end

    -- Calculates the closest exterior boundary point (+10 studs outside the SafeZone)
    local function getSafeZoneEdgePosition(charPos)
        local safeZone = getSafeZonePart()
        if not safeZone then
            return Vector3.new(-5848.0, charPos.Y, -7228.0)
        end

        local localPos = safeZone.CFrame:PointToObjectSpace(charPos)
        local halfX = safeZone.Size.X / 2 + 10.0
        local halfZ = safeZone.Size.Z / 2 + 10.0

        local clampedLocal = Vector3.new(
            math.clamp(localPos.X, -halfX, halfX),
            0,
            math.clamp(localPos.Z, -halfZ, halfZ)
        )
        local worldPos = safeZone.CFrame:PointToWorldSpace(clampedLocal)
        return Vector3.new(worldPos.X, charPos.Y, worldPos.Z)
    end

    -- Calculates a coordinate securely inside the scoring volume (-10 studs inside SafeZone)
    local function getSafeZoneInsidePosition(charPos)
        local safeZone = getSafeZonePart()
        if not safeZone then
            return Vector3.new(-5848.0, charPos.Y, -7244.0)
        end

        local localPos = safeZone.CFrame:PointToObjectSpace(charPos)
        local innerHalfX = math.max(safeZone.Size.X / 2 - 10.0, 0)
        local innerHalfZ = math.max(safeZone.Size.Z / 2 - 10.0, 0)

        local clampedLocal = Vector3.new(
            math.clamp(localPos.X, -innerHalfX, innerHalfX),
            0,
            math.clamp(localPos.Z, -innerHalfZ, innerHalfZ)
        )
        local worldPos = safeZone.CFrame:PointToWorldSpace(clampedLocal)
        return Vector3.new(worldPos.X, charPos.Y, worldPos.Z)
    end

    -- Detects whether an egg belongs to Zone 1 (Graveyard)
    local function isGraveyardEgg(egg)
        if not egg or not egg.Parent then return false end

        local zoneAttr = egg:GetAttribute("Zone")
        if zoneAttr == 1 or zoneAttr == "1" or zoneAttr == "Zone1" then
            return true
        end

        local areaAttr = tostring(egg:GetAttribute("Area") or egg:GetAttribute("AreaId") or egg:GetAttribute("Location") or ""):lower()
        if areaAttr:find("graveyard") or areaAttr:find("cemetery") then
            return true
        end

        local eggName = tostring(egg:GetAttribute("PreparedSourceName") or egg.Name):lower()
        if eggName:find("graveyard") or eggName:find("cemetery") then
            return true
        end

        local safeZone = getSafeZonePart()
        if safeZone then
            local eggPos = egg:GetPivot().Position
            local distFromGate = (Vector3.new(eggPos.X, 0, eggPos.Z) - Vector3.new(safeZone.Position.X, 0, safeZone.Position.Z)).Magnitude
            if distFromGate <= CONFIG.GraveyardMaxDistance then
                return true
            end
        end

        return false
    end

    -- ------------------------------------------------------------------------------
    -- [ SECTION 4: MOVEMENT ENGINES ]
    -- ------------------------------------------------------------------------------

    -- Moves character in discrete 40-stud intervals while preserving terrain Y elevation
    local function stepMove(targetPos, session)
        local char, root = getAliveRig()
        if not root then return false end

        local currentPos = root.Position
        local flatDiff = Vector3.new(targetPos.X - currentPos.X, 0, targetPos.Z - currentPos.Z)
        local totalDist = flatDiff.Magnitude
        if totalDist <= 3.0 then
            root.CFrame = CFrame.new(targetPos.X, targetPos.Y or root.Position.Y, targetPos.Z)
            root.AssemblyLinearVelocity = Vector3.zero
            return true
        end

        local moveDir = flatDiff.Unit
        local distanceCovered = 0
        local startY = currentPos.Y
        local endY = targetPos.Y or currentPos.Y

        while distanceCovered < totalDist do
            if not getgenv().InstantStealHalloween or session ~= State.currentSession then
                return false
            end

            local step = math.min(CONFIG.StepDistance, totalDist - distanceCovered)
            distanceCovered = distanceCovered + step
            local progress = distanceCovered / totalDist

            local curY = startY + (endY - startY) * progress
            local nextPos = currentPos + (moveDir * distanceCovered)

            root.CFrame = CFrame.new(nextPos.X, curY, nextPos.Z) * CFrame.lookAt(Vector3.zero, moveDir)
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero

            task.wait(CONFIG.StepDelay)
        end

        root.CFrame = CFrame.new(targetPos.X, endY, targetPos.Z) * CFrame.lookAt(Vector3.zero, moveDir)
        root.AssemblyLinearVelocity = Vector3.zero
        return true
    end

    -- Frame-by-frame natural walk movement used to step into the SafeZone volume
    local function naturalWalkTo(targetPos, session)
        local char, root, hum = getAliveRig()
        if not root or not hum then return false end

        local speed = hum.WalkSpeed > 0 and hum.WalkSpeed or CONFIG.NaturalWalkSpeed
        local currentPos = root.Position
        local diff = Vector3.new(targetPos.X - currentPos.X, 0, targetPos.Z - currentPos.Z)
        local totalDist = diff.Magnitude
        if totalDist <= 2.0 then return true end

        local dir = diff.Unit
        local duration = totalDist / speed
        local startTime = os.clock()

        while (os.clock() - startTime) < duration do
            if not getgenv().InstantStealHalloween or session ~= State.currentSession or not isCarryingEgg() then
                break
            end

            local dt = Services.RunService.Heartbeat:Wait()
            local _, liveRoot = getAliveRig()
            if not liveRoot then break end

            local step = math.min(speed * dt, (targetPos - liveRoot.Position).Magnitude)
            liveRoot.CFrame = CFrame.new(liveRoot.Position + (dir * step), liveRoot.Position + (dir * 10))
            liveRoot.AssemblyLinearVelocity = dir * speed
        end

        local _, endRoot = getAliveRig()
        if endRoot then
            endRoot.AssemblyLinearVelocity = Vector3.zero
        end
        return true
    end

    -- ------------------------------------------------------------------------------
    -- [ SECTION 5: EGG SCANNING & RETRIEVAL ]
    -- ------------------------------------------------------------------------------

    -- Classifies egg area using friend's exact detection rules + HalloweenAreaManager
    local function getEggArea(egg)
        if not egg or not egg.Parent then return "Unknown" end
        if HalloweenAreaManager and HalloweenAreaManager.GetArea then
            return HalloweenAreaManager:GetArea(egg)
        end

        local zoneAttr = egg:GetAttribute("Zone")
        if zoneAttr == 1 or zoneAttr == "1" or zoneAttr == "Zone1" then return "Graveyard"
        elseif zoneAttr == 2 or zoneAttr == "2" or zoneAttr == "Zone2" then return "Haunted Swamps"
        elseif zoneAttr == 3 or zoneAttr == "3" or zoneAttr == "Zone3" then return "Abandoned Manor"
        end

        local areaAttr = tostring(egg:GetAttribute("Area") or egg:GetAttribute("AreaId") or egg:GetAttribute("Location") or egg.Name):lower()
        if areaAttr:find("manor") or areaAttr:find("abandoned") then return "Abandoned Manor"
        elseif areaAttr:find("swamp") then return "Haunted Swamps"
        elseif areaAttr:find("graveyard") or areaAttr:find("cemetery") then return "Graveyard"
        end

        local safeZone = getSafeZonePart()
        if safeZone then
            local eggPos = egg:GetPivot().Position
            local distFromGate = (Vector3.new(eggPos.X, 0, eggPos.Z) - Vector3.new(safeZone.Position.X, 0, safeZone.Position.Z)).Magnitude
            if distFromGate <= CONFIG.GraveyardMaxDistance then return "Graveyard"
            elseif distFromGate >= CONFIG.ManorMinDistance then return "Abandoned Manor"
            else return "Haunted Swamps"
            end
        end

        return "Graveyard"
    end

    -- Scans WorldEggs for best valid candidate matching Target Areas and Min Rarity
    local function selectTargetEgg()
        local dim = Services.Workspace:FindFirstChild("HalloweenDimension", true)
        local folder = dim and dim:FindFirstChild("WorldEggs")
        if not folder then return nil end

        local _, root = getAliveRig()
        if not root then return nil end

        local selectedAreas = getgenv().config.halloweenTargetAreas or currentSettings.HalloweenTargetAreas or { ["All"] = true }
        local minFilter = getgenv().config.halloweenMinRarity or currentSettings.HalloweenMinRarity or "All"
        local allowAllAreas = (selectedAreas["All"] == true) or (selectedAreas == "All")

        local bestEgg = nil
        local bestScore = -math.huge
        local shortestDist = math.huge

        for _, egg in ipairs(folder:GetChildren()) do
            if egg:IsA("Model") or egg:IsA("BasePart") then
                -- 1. Area Filter Check
                local eggArea = getEggArea(egg)
                local areaAllowed = allowAllAreas or (selectedAreas[eggArea] == true)

                if areaAllowed then
                    -- 2. Rarity Filter Check
                    local rarityAllowed = true
                    if minFilter ~= "All" and DynamicRarityResolver and DynamicRarityResolver.MeetsMinRarity then
                        rarityAllowed = DynamicRarityResolver:MeetsMinRarity(egg, minFilter)
                    end

                    if rarityAllowed then
                        -- 3. Candidate Scoring (Rarest/Highest Score first, with closest distance tie-breaker)
                        local score = 0
                        if DynamicRarityResolver and DynamicRarityResolver.GetEggScore then
                            score = DynamicRarityResolver:GetEggScore(egg)
                        end

                        local pivot = egg:GetPivot().Position
                        local dist = (Vector3.new(root.Position.X, 0, root.Position.Z) - Vector3.new(pivot.X, 0, pivot.Z)).Magnitude

                        if score > bestScore or (score == bestScore and dist < shortestDist) then
                            bestScore = score
                            shortestDist = dist
                            bestEgg = egg
                        end
                    end
                end
            end
        end

        return bestEgg
    end

    -- Scans a 130-stud radius around the player at the gate to find the dropped egg
    local function findDroppedEggAtGate()
        local _, root = getAliveRig()
        if not root then return nil end

        local dim = Services.Workspace:FindFirstChild("HalloweenDimension", true)
        if not dim then return nil end

        local closestEgg = nil
        local closestDist = CONFIG.GateSearchRadius

        local worldEggs = dim:FindFirstChild("WorldEggs")
        if worldEggs then
            for _, egg in ipairs(worldEggs:GetChildren()) do
                if egg:IsA("PVInstance") then
                    local p = egg:GetPivot().Position
                    local dist = (p - root.Position).Magnitude
                    if dist < closestDist then
                        closestDist = dist
                        closestEgg = egg
                    end
                end
            end
        end

        if not closestEgg then
            for _, desc in ipairs(dim:GetDescendants()) do
                if desc:IsA("ProximityPrompt") and desc.Enabled then
                    local parentModel = desc:FindFirstAncestorOfClass("Model") or desc.Parent
                    if parentModel and parentModel:IsA("PVInstance") then
                        local p = parentModel:GetPivot().Position
                        local dist = (p - root.Position).Magnitude
                        if dist < closestDist then
                            closestDist = dist
                            closestEgg = parentModel
                        end
                    end
                end
            end
        end

        return closestEgg
    end

    -- ------------------------------------------------------------------------------
    -- [ SECTION 6: MASTER EXECUTION PIPELINE ]
    -- ------------------------------------------------------------------------------

    -- Executes the complete steal, transit, reset, and delivery lifecycle
    local function runCompleteStealCycle(targetEgg, session)
        local char, root = getAliveRig()
        if not root then return false end

        local carryRemote = getCarryRemote()
        local dropRemote = getDropRemote()
        local fromGraveyard = false

        -- STAGE 1: ACQUISITION AT NEST (If hands are empty)
        if not isCarryingEgg() then
            if not targetEgg or not targetEgg.Parent then return false end

            fromGraveyard = isGraveyardEgg(targetEgg)
            local eggPos = targetEgg:GetPivot().Position
            local eggUid = tostring(targetEgg:GetAttribute("HalloweenEggUid") or targetEgg:GetAttribute("Uid") or "")

            local reachedNest = stepMove(Vector3.new(eggPos.X, eggPos.Y + 2.0, eggPos.Z), session)
            if not reachedNest then return false end

            task.wait(0.2)

            local grabStart = os.clock()
            while (os.clock() - grabStart) < 2.5 and not isCarryingEgg() do
                interactPrompt(targetEgg)
                if carryRemote and eggUid ~= "" then
                    pcall(function() carryRemote:InvokeServer(eggUid) end)
                end
                Services.RunService.Heartbeat:Wait()
            end

            if not isCarryingEgg() then return false end
        else
            local safeZone = getSafeZonePart()
            if safeZone and (root.Position - safeZone.Position).Magnitude <= CONFIG.GraveyardMaxDistance then
                fromGraveyard = true
            end
        end

        -- STAGE 2: TRANSIT TO SAFEZONE BOUNDARY
        local edgePos = getSafeZoneEdgePosition(root.Position)
        local reachedEdge = stepMove(edgePos, session)
        if not reachedEdge or not isCarryingEgg() then return false end

        -- Anti-Rollback recovery
        for _ = 1, 3 do
            local _, curRoot = getAliveRig()
            if curRoot and (Vector3.new(curRoot.Position.X, 0, curRoot.Position.Z) - Vector3.new(edgePos.X, 0, edgePos.Z)).Magnitude >= 80.0 then
                stepMove(edgePos, session)
                task.wait(0.1)
            else
                break
            end
        end

        -- STAGE 3: ORIGIN RESET (OR GRAVEYARD SETTLE)
        if fromGraveyard then
            local _, curRoot = getAliveRig()
            if curRoot then
                curRoot.AssemblyLinearVelocity = Vector3.zero
                curRoot.AssemblyAngularVelocity = Vector3.zero
            end
            task.wait(CONFIG.GraveyardDeliverDelay)
        else
            -- Distant egg origin reset
            if dropRemote then
                pcall(function() dropRemote:InvokeServer() end)
            end

            local dropStart = os.clock()
            while (os.clock() - dropStart) < 1.0 and isCarryingEgg() do
                Services.RunService.Heartbeat:Wait()
            end

            task.wait(0.2)

            -- Search for dropped egg in 130-stud radius
            local droppedEgg = nil
            local searchStart = os.clock()
            while (os.clock() - searchStart) < 3.0 do
                droppedEgg = findDroppedEggAtGate()
                if droppedEgg then break end
                Services.RunService.Heartbeat:Wait()
            end

            if not droppedEgg then return false end

            -- Physically step onto the dropped egg coordinates
            local droppedPos = droppedEgg:GetPivot().Position
            stepMove(Vector3.new(droppedPos.X, droppedPos.Y + 1.0, droppedPos.Z), session)

            -- Regrab the dropped egg
            local regrabStart = os.clock()
            while (os.clock() - regrabStart) < 3.0 and not isCarryingEgg() do
                local _, curRoot = getAliveRig()
                if curRoot then
                    curRoot.CFrame = CFrame.new(droppedPos.X, droppedPos.Y + 1.0, droppedPos.Z)
                end

                interactPrompt(droppedEgg)
                local dropUid = tostring(droppedEgg:GetAttribute("HalloweenEggUid") or droppedEgg:GetAttribute("Uid") or "")
                if carryRemote and dropUid ~= "" then
                    pcall(function() carryRemote:InvokeServer(dropUid) end)
                end
                Services.RunService.Heartbeat:Wait()
            end

            if not isCarryingEgg() then return false end

            task.wait(CONFIG.OriginSettleTime)
        end

        -- STAGE 4: NATURAL WALK-IN DELIVERY
        local insidePos = getSafeZoneInsidePosition(root.Position)
        local prevDelivered = LocalPlayer:GetAttribute("HalloweenDelivered") or 0
        naturalWalkTo(insidePos, session)

        local finishWait = os.clock() + 2.5
        while (os.clock() - finishWait) < 0 and isCarryingEgg() do
            local curDelivered = LocalPlayer:GetAttribute("HalloweenDelivered") or 0
            if curDelivered > prevDelivered then
                break
            end
            Services.RunService.Heartbeat:Wait()
        end

        return not isCarryingEgg()
    end

    -- External interface for toggle and PriorityManager
    HalloweenStealManager.State = State
    HalloweenStealManager.SelectTargetEgg = selectTargetEgg
    HalloweenStealManager.GetEggArea = getEggArea
    HalloweenStealManager.Abort = function()
        State.currentSession = State.currentSession + 1
        State.isBusy = false
        local _, root, hum = getAliveRig()
        if hum then hum.PlatformStand = false end
        if root then
            root.AssemblyLinearVelocity = Vector3.zero
            root.AssemblyAngularVelocity = Vector3.zero
        end
    end

    -- ------------------------------------------------------------------------------
    -- [ SECTION 7: AUTONOMOUS BACKGROUND SCHEDULER ]
    -- ------------------------------------------------------------------------------
    task.spawn(function()
        while true do
            if getgenv().InstantStealHalloween then
                local inDimension = (typeof(isInHalloweenDimension) == "function" and isInHalloweenDimension()) or (LocalPlayer:GetAttribute("InHalloweenDimension") == true)
                if inDimension then
                    local char, root, hum = getAliveRig()

                    if char and root and hum and not State.isBusy then
                        applyRigProtection(char)

                        if isCarryingEgg() then
                            State.isBusy = true
                            State.currentSession = State.currentSession + 1

                            runCompleteStealCycle(nil, State.currentSession)

                            State.isBusy = false
                            task.wait(0.2)
                        else
                            local targetEgg = selectTargetEgg()

                            if targetEgg and targetEgg.Parent then
                                State.isBusy = true
                                State.currentSession = State.currentSession + 1
                                local session = State.currentSession

                                runCompleteStealCycle(targetEgg, session)

                                State.isBusy = false
                                task.wait(0.1)
                            else
                                task.wait(1.0)
                            end
                        end
                    end
                else
                    -- Normal dimension: ONLY enter portal if an action is actually needed!
                    local hasAction = isCarryingEgg() or (selectTargetEgg() ~= nil)
                    local mapOpen = not (typeof(isHalloweenMapClosed) == "function" and isHalloweenMapClosed())

                    if hasAction and mapOpen then
                        if HalloweenPortalManager and HalloweenPortalManager.EnterDimension then
                            HalloweenPortalManager.EnterDimension(5.0)
                        else
                            task.wait(1.5)
                        end
                    else
                        task.wait(1.5)
                    end
                end
            end

            Services.RunService.Heartbeat:Wait()
        end
    end)
end

-- [ HALLOWEEN BOSS: AUTONOMOUS RECURRING EVENT STATE MACHINE ]
-- Halloween Event 2026 feature (KNOWLEDGE.md section 6.5.1).
-- Auto Boss OWNS its navigation: Halloween Dimension -> BossPortal -> PumpkinArena
-- -> BossExitPortal. The Dimension Supervisor must never interrupt it while active.
-- ==============================================================================

-- Shared lifecycle state table (backward compatible with BossFarmerState alias)
getgenv().BossAutomationState = getgenv().BossAutomationState or {
    CurrentState = "WAITING",
    KingEncountered = false,
    CurrentBatIndex = 1,
    StateEnteredAt = os.clock(),
    IsBusy = false
}
getgenv().BossFarmerState = getgenv().BossAutomationState
getgenv().BossFarmerState.IsBusy = false

HalloweenBossManager = {
    IsActive = false,
    ProbeCooldownUntil = 0,
    Config = {
        PortalPosition = Vector3.new(-5671.9, -202.6, -7314.7),
        ArenaCenter = Vector3.new(-133552.1, 477.7, 980.7),
        ArenaRadius = 600,
        ArenaFloorY = 476.24,
        CombatOffsetBehind = 14.0,
        GlideSpeed = 250,
        SwitchInterval = 0.05,
        CannonReloadDelay = 0.18,
        InitBufferTime = 3.0
    },
    Remotes = {
        AskEnter = nil,
        CannonFire = nil,
        MonsterHit = nil
    }
}

function HalloweenBossManager:IsEnabled()
    return getgenv().config.autoBossEvent == true
end

function HalloweenBossManager:ResolveRemotes()
    local r = self.Remotes
    if r.AskEnter and r.CannonFire and r.MonsterHit then return end
    local packages = Services.ReplicatedStorage:FindFirstChild("Packages")
    local networking = packages and packages:FindFirstChild("Networking")
    if networking then
        r.AskEnter = r.AskEnter or networking:FindFirstChild("RF/BossEvent/AskEnter")
        r.CannonFire = r.CannonFire or networking:FindFirstChild("RE/PumpkinBoss/CannonFire")
        r.MonsterHit = r.MonsterHit or networking:FindFirstChild("RE/HalloweenDimension/MonsterHit")
    end
end

function HalloweenBossManager:SetState(newState)
    local state = getgenv().BossAutomationState
    if state.CurrentState ~= newState then
        state.CurrentState = newState
        state.StateEnteredAt = os.clock()
    end
end

function HalloweenBossManager:ApplyStateProtection(character)
    if not character then return end
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if not humanoid then return end

    local blockedStates = {
        Enum.HumanoidStateType.FallingDown,
        Enum.HumanoidStateType.Ragdoll,
        Enum.HumanoidStateType.Physics
    }
    for _, state in ipairs(blockedStates) do
        pcall(function() humanoid:SetStateEnabled(state, false) end)
    end
    pcall(function() humanoid.BreakJointsOnDeath = false end)

    for _, desc in ipairs(character:GetDescendants()) do
        if not desc:FindFirstAncestorWhichIsA("Tool") then
            if desc:IsA("BallSocketConstraint") or desc:IsA("HingeConstraint") or
              (desc:IsA("NoCollisionConstraint") and string.find(desc.Name, "Ragdoll", 1, true)) then
                pcall(function() desc:Destroy() end)
            elseif desc:IsA("Motor6D") and not desc.Enabled then
                desc.Enabled = true
            end
        end
    end
end

function HalloweenBossManager:IsPlayerInArena()
    if LocalPlayer:GetAttribute("InPumpkinArena") == true then
        return true
    end
    local _, root = getAliveRig()
    if root then
        if (root.Position - self.Config.ArenaCenter).Magnitude <= self.Config.ArenaRadius then
            return true
        end
    end
    return false
end

function HalloweenBossManager:GetInventoryBats()
    local bats = {}
    local seen = {}

    local function scan(container)
        if not container then return end
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") and not seen[item] then
                local isBat = item:GetAttribute("IsBat") == true or item.Name:lower():find("bat")
                if isBat then
                    seen[item] = true
                    table.insert(bats, item)
                end
            end
        end
    end

    scan(LocalPlayer.Character)
    scan(LocalPlayer:FindFirstChild("Backpack"))
    return bats
end

function HalloweenBossManager:PerformBatSwitchAttack(targetModel)
    local char, _, hum = getAliveRig()
    if not char or not hum then return end

    local bats = self:GetInventoryBats()
    if #bats == 0 then return end

    local state = getgenv().BossAutomationState
    if state.CurrentBatIndex > #bats then
        state.CurrentBatIndex = 1
    end

    local selectedBat = bats[state.CurrentBatIndex]
    state.CurrentBatIndex = (state.CurrentBatIndex % #bats) + 1

    if selectedBat.Parent ~= char then
        pcall(function() hum:EquipTool(selectedBat) end)
    end

    pcall(function() selectedBat:Activate() end)

    if self.Remotes.MonsterHit and targetModel then
        pcall(function()
            self.Remotes.MonsterHit:FireServer(targetModel)
        end)
    end
end

function HalloweenBossManager:GlideTo(targetPos, stopDistance)
    local char, root = getAliveRig()
    if not root then return false end

    stopDistance = stopDistance or 3.0
    local speed = self.Config.GlideSpeed

    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            part.CanCollide = false
        end
    end

    local delta = targetPos - root.Position
    local timeout = os.clock() + (delta.Magnitude / speed) + 3.0

    while (targetPos - root.Position).Magnitude > stopDistance do
        if not self:IsEnabled() or os.clock() > timeout then
            break
        end

        local dt = Services.RunService.Heartbeat:Wait()
        local _, liveRoot = getAliveRig()
        if not liveRoot then break end
        root = liveRoot

        local diff = targetPos - liveRoot.Position
        if diff.Magnitude < 1e-3 then break end
        local dir = diff.Unit
        local step = math.min(speed * dt, diff.Magnitude)

        liveRoot.AssemblyLinearVelocity = dir * speed
        liveRoot.CFrame = CFrame.new(liveRoot.Position + dir * step, liveRoot.Position + dir * 10)
    end

    local _, endRoot = getAliveRig()
    if endRoot then
        endRoot.AssemblyLinearVelocity = Vector3.zero
    end
    return true
end

function HalloweenBossManager:IsBossPortalOpen()
    local dim = Services.Workspace:FindFirstChild("HalloweenDimension", true)
    local portal = dim and dim:FindFirstChild("BossPortal")
    if not portal then return false end

    local seal = portal:FindFirstChild("BossPortalSeal")
    if not seal then return true end

    for _, desc in ipairs(seal:GetDescendants()) do
        if desc:IsA("BasePart") and desc.Transparency < 0.5 then
            return false
        end
    end
    return true
end

function HalloweenBossManager:IsBossPortalLocked()
    local dim = Services.Workspace:FindFirstChild("HalloweenDimension", true)
    local portal = dim and dim:FindFirstChild("BossPortal")
    if not portal then return false end

    local seal = portal:FindFirstChild("BossPortalSeal")
    if not seal then return false end

    for _, desc in ipairs(seal:GetDescendants()) do
        if desc:IsA("BasePart") and desc.Transparency < 0.5 then
            return true
        end
    end
    return false
end

function HalloweenBossManager:GetPortalTargetPos()
    local dim = Services.Workspace:FindFirstChild("HalloweenDimension", true)
    local portal = dim and dim:FindFirstChild("BossPortal")
    if portal then
        local hitbox = portal:FindFirstChild("Hitbox")
        if hitbox and hitbox:IsA("BasePart") then
            return hitbox.Position
        end
        return portal:GetPivot().Position
    end
    return self.Config.PortalPosition
end

function HalloweenBossManager:FindActiveBoss()
    local arena = Services.Workspace:FindFirstChild("PumpkinArena", true)
    if not arena then return nil, nil, nil end
    local state = getgenv().BossAutomationState

    local king = arena:FindFirstChild("King")
    if king and king:IsA("Model") then
        local root = king:FindFirstChild("RootPart") or king.PrimaryPart or king:FindFirstChildWhichIsA("BasePart")
        local hum = king:FindFirstChildOfClass("Humanoid")
        if root and (not hum or hum.Health > 0) then
            state.KingEncountered = true
            return king, root, hum
        end
    end

    for _, desc in ipairs(arena:GetDescendants()) do
        if desc:IsA("Model") and desc ~= LocalPlayer.Character then
            local name = desc.Name:lower()
            if name:find("brute") or name:find("king") or name == "pumpkinboss" then
                local root = desc:FindFirstChild("RootPart") or desc:FindFirstChild("HumanoidRootPart") or desc.PrimaryPart or desc:FindFirstChildWhichIsA("BasePart")
                local hum = desc:FindFirstChildOfClass("Humanoid")
                if root and (not hum or hum.Health > 0) then
                    if name:find("king") or name == "pumpkinboss" then
                        state.KingEncountered = true
                    end
                    return desc, root, hum
                end
            end
        end
    end
    return nil, nil, nil
end

function HalloweenBossManager:GetAssignedCannon(arena)
    if not arena then return nil end
    local cannonsFolder = arena:FindFirstChild("Cannons")
    if not cannonsFolder then return nil end

    local myUserId = LocalPlayer.UserId

    for _, cannon in ipairs(cannonsFolder:GetChildren()) do
        if cannon:IsA("Model") and cannon:GetAttribute("OwnerUserId") == myUserId then
            return cannon
        end
    end

    local tutBeam = Services.Workspace:FindFirstChild("TutorialBeam")
    if tutBeam and tutBeam:IsA("Beam") and tutBeam.Attachment1 then
        local target = tutBeam.Attachment1:FindFirstAncestorOfClass("Model")
        if target and target.Parent == cannonsFolder then
            return target
        end
    end

    return cannonsFolder:FindFirstChildWhichIsA("Model")
end

function HalloweenBossManager:IsKingShieldActive(arena)
    if not arena then return false end
    return arena:GetAttribute("Phase") == "Shield" or arena:GetAttribute("ShieldActive") == true
end

function HalloweenBossManager:IsKingStunned(arena)
    if not arena then return false end
    if arena:GetAttribute("Phase") == "Stunned" or arena:GetAttribute("StunEnds") ~= nil then
        return true
    end

    local king = arena:FindFirstChild("King")
    if king and (king:GetAttribute("Stunned") == true or king:GetAttribute("Anim") == "Stunned") then
        return true
    end
    return false
end

function HalloweenBossManager:IsCannonFreed(cannon)
    if not cannon then return false end

    for _, gui in ipairs(LocalPlayer.PlayerGui:GetChildren()) do
        if gui:IsA("ScreenGui") and gui.Enabled then
            for _, desc in ipairs(gui:GetDescendants()) do
                if desc:IsA("TextLabel") and desc.Visible then
                    local t = desc.Text:lower()
                    if t:find("man your cannon") or t:find("tap to fire") or t:find("stand on") or t:find("shoot at him") or t:find("stunned") then
                        return true
                    end
                end
            end
        end
    end

    local roots = cannon:FindFirstChild("Roots") or cannon:FindFirstChild("Vines") or cannon:FindFirstChild("Vine")
    if not roots or not roots.Parent then
        return true
    end

    if roots:IsA("BasePart") and (roots.Transparency > 0.8 or not roots.CanCollide) then
        return true
    end

    return false
end

function HalloweenBossManager:GetCannonStandPosition(cannon)
    if not cannon then return nil end

    local targetX, targetZ = nil, nil

    local tutAtt = cannon:FindFirstChild("TutorialBeamTargetAttachment", true)
    if tutAtt and tutAtt:IsA("Attachment") then
        targetX = tutAtt.WorldPosition.X
        targetZ = tutAtt.WorldPosition.Z
    end

    if not targetX then
        local stand = cannon:FindFirstChild("Stand")
        if stand then
            local pos = stand:IsA("BasePart") and stand.Position or stand:GetPivot().Position
            targetX = pos.X
            targetZ = pos.Z
        end
    end

    if not targetX then
        local fallback = cannon:GetPivot() * CFrame.new(0, 0, 6.5)
        targetX = fallback.Position.X
        targetZ = fallback.Position.Z
    end

    local cannonY = cannon:GetPivot().Position.Y
    local rayOrigin = Vector3.new(targetX, cannonY + 12.0, targetZ)
    local rayDirection = Vector3.new(0, -30.0, 0)

    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local filter = {}
    if LocalPlayer.Character then table.insert(filter, LocalPlayer.Character) end
    params.FilterDescendantsInstances = filter

    local result = Services.Workspace:Raycast(rayOrigin, rayDirection, params)
    local padSurfaceY = result and result.Position.Y or (cannonY - 3.16)

    local _, root, hum = getAliveRig()
    local legOffset = 2.8
    if hum and root then
        local hip = hum.HipHeight > 0 and hum.HipHeight or 2.0
        legOffset = hip + (root.Size.Y / 2) - 0.15
    end

    return Vector3.new(targetX, padSurfaceY + legOffset, targetZ)
end

function HalloweenBossManager:ProcessCannonFiring(myCannon, standPos)
    if not myCannon then return end

    local _, root = getAliveRig()
    if root and standPos then
        root.CFrame = CFrame.new(standPos)
        root.AssemblyLinearVelocity = Vector3.zero
    end

    if self.Remotes.CannonFire then
        pcall(function() self.Remotes.CannonFire:FireServer() end)
        pcall(function() self.Remotes.CannonFire:FireServer(myCannon) end)
        pcall(function() self.Remotes.CannonFire:FireServer(myCannon:GetAttribute("CannonId")) end)
    end

    task.wait(self.Config.CannonReloadDelay)
end

function HalloweenBossManager:IsEntireEventCompleted(arena)
    if not arena then return false end
    local state = getgenv().BossAutomationState

    if not state.KingEncountered then
        return false
    end

    local bossHp = arena:GetAttribute("Health")
    if bossHp and bossHp <= 0 then
        return true
    end

    local phase = arena:GetAttribute("Phase")
    if phase == "Defeated" or phase == "Finished" or phase == "Victory" or phase == "Ended" then
        return true
    end

    local king = arena:FindFirstChild("King")
    if king then
        local hum = king:FindFirstChildOfClass("Humanoid")
        if hum and hum.Health <= 0 then
            return true
        end
    end

    return false
end

function HalloweenBossManager:HandleArenaExit(arena)
    local exitPortal = arena and arena:FindFirstChild("BossExitPortal", true)
    if not exitPortal then return false end

    local hitbox = exitPortal:FindFirstChild("Hitbox", true) 
                or (exitPortal:IsA("BasePart") and exitPortal)
                or exitPortal:FindFirstChildWhichIsA("BasePart")

    if hitbox then
        self:GlideTo(hitbox.Position, 2.0)
        task.wait(0.5)
        return true
    end
    return false
end

function HalloweenBossManager:Process()
    if not self:IsEnabled() then return end
    local char, root, hum = getAliveRig()
    local state = getgenv().BossAutomationState

    if not (char and root and hum) or state.IsBusy then return end

    if not HalloweenPortalManager.IsInHalloweenDimension() then
        HalloweenPortalManager.EnterDimension(5.0)
        state.IsBusy = false
        self.IsActive = false
        return
    end
    state.IsBusy = true
    self.IsActive = true
    self:ResolveRemotes()
    self:ApplyStateProtection(char)

    local inArena = self:IsPlayerInArena()

    -- STATE 1: WAITING (In overworld, waiting for portal to unlock)
    if state.CurrentState == "WAITING" then
        if inArena then
            self:SetState("INITIALIZING")
        elseif self:IsBossPortalOpen() then
            self:SetState("ENTERING")
        else
            task.wait(0.5)
        end

    -- STATE 2: ENTERING (Approaching entrance and invoking request)
    elseif state.CurrentState == "ENTERING" then
        if inArena then
            self:SetState("INITIALIZING")
        else
            local entryPos = self:GetPortalTargetPos()
            if self.Remotes.AskEnter then
                pcall(function() self.Remotes.AskEnter:InvokeServer() end)
            end
            self:GlideTo(entryPos, 2.0)

            local waitStart = os.clock()
            while (os.clock() - waitStart) < 2.0 and not self:IsPlayerInArena() do
                Services.RunService.Heartbeat:Wait()
            end

            if self:IsPlayerInArena() then
                self:SetState("INITIALIZING")
            end
        end

    -- STATE 3: INITIALIZING (In arena, waiting for server replication and spawn)
    elseif state.CurrentState == "INITIALIZING" then
        if not inArena then
            self:SetState("WAITING")
        else
            local elapsed = os.clock() - state.StateEnteredAt
            local arena = Services.Workspace:FindFirstChild("PumpkinArena", true)
            local bossModel = arena and self:FindActiveBoss()

            if elapsed >= self.Config.InitBufferTime and (bossModel or (arena and arena:GetAttribute("Phase"))) then
                self:SetState("ACTIVE")
            else
                task.wait(0.5)
            end
        end

    -- STATE 4: ACTIVE (Fighting Brute, clearing cannons, and engaging King)
    elseif state.CurrentState == "ACTIVE" then
        if not inArena then
            self:SetState("COOLDOWN")
        else
            local arena = Services.Workspace:FindFirstChild("PumpkinArena", true)

            if self:IsEntireEventCompleted(arena) then
                self:SetState("EXITING")
            else
                local shieldActive = self:IsKingShieldActive(arena)
                local stunned = self:IsKingStunned(arena)

                -- Sub-Phase: Cannon firing (Shielded or Stunned King)
                if shieldActive or stunned then
                    local myCannon = self:GetAssignedCannon(arena)

                    if myCannon then
                        local freed = self:IsCannonFreed(myCannon)
                        local cannonBasePos = myCannon:GetPivot().Position
                        local standPos = self:GetCannonStandPosition(myCannon)

                        if not freed and shieldActive then
                            self:GlideTo(cannonBasePos + Vector3.new(0, 1.5, 3.0), 3.5)
                            local _, liveRoot = getAliveRig()
                            if liveRoot then
                                liveRoot.CFrame = CFrame.new(cannonBasePos + Vector3.new(0, 1.2, 3.0), cannonBasePos)
                                liveRoot.AssemblyLinearVelocity = Vector3.zero
                            end

                            local rootsObj = myCannon:FindFirstChild("Roots") 
                                          or myCannon:FindFirstChild("Vines") 
                                          or myCannon
                            self:PerformBatSwitchAttack(rootsObj)
                            task.wait(self.Config.SwitchInterval)
                        else
                            local targetPos = standPos or cannonBasePos
                            local distToPad = (root.Position - targetPos).Magnitude

                            if distToPad > 3.0 then
                                self:GlideTo(targetPos, 2.0)
                            else
                                self:ProcessCannonFiring(myCannon, targetPos)
                            end
                        end
                    else
                        task.wait(0.3)
                    end

                -- Sub-Phase: Melee combat (Phase 1 Brute or unshielded King)
                else
                    local bossModel, bossRoot = self:FindActiveBoss()

                    if bossModel and bossRoot then
                        local arenaFloorY = (arena and arena:GetAttribute("FloorY")) or self.Config.ArenaFloorY
                        local behindVector = -bossRoot.CFrame.LookVector * self.Config.CombatOffsetBehind
                        local safePos = Vector3.new(
                            bossRoot.Position.X + behindVector.X,
                            arenaFloorY + 3.0,
                            bossRoot.Position.Z + behindVector.Z
                        )

                        local distToFlank = (root.Position - safePos).Magnitude
                        if distToFlank > (self.Config.CombatOffsetBehind + 4.0) then
                            self:GlideTo(safePos, self.Config.CombatOffsetBehind)
                        else
                            root.CFrame = CFrame.new(safePos, Vector3.new(bossRoot.Position.X, safePos.Y, bossRoot.Position.Z))
                            root.AssemblyLinearVelocity = Vector3.zero

                            self:PerformBatSwitchAttack(bossModel)
                            task.wait(self.Config.SwitchInterval)
                        end
                    else
                        task.wait(0.4)
                    end
                end
            end
        end

    -- STATE 5: EXITING (Defeat verified; stepping into exit portal)
    elseif state.CurrentState == "EXITING" then
        if not inArena then
            self:SetState("COOLDOWN")
        else
            local arena = Services.Workspace:FindFirstChild("PumpkinArena", true)
            self:HandleArenaExit(arena)
            task.wait(1.0)
        end

    -- STATE 6: COOLDOWN (Resetting flags and waiting for portal to lock)
    elseif state.CurrentState == "COOLDOWN" then
        state.KingEncountered = false
        state.CurrentBatIndex = 1

        if inArena then
            self:SetState("EXITING")
        else
            local elapsed = os.clock() - state.StateEnteredAt
            if elapsed >= 10.0 and self:IsBossPortalLocked() then
                self:SetState("WAITING")
            else
                task.wait(1.5)
            end
        end
    end

    state.IsBusy = false
    self.IsActive = false
end

function HalloweenBossManager:HasWork()
    if not self:IsEnabled() then return false end
    local state = getgenv().BossAutomationState

    if state.CurrentState == "COOLDOWN" then
        if self:IsPlayerInArena() then
            return true
        end
        local elapsed = os.clock() - state.StateEnteredAt
        if elapsed >= 10.0 and self:IsBossPortalLocked() then
            self:SetState("WAITING")
        else
            return false
        end
    end

    if self:IsPlayerInArena() then
        return true
    end

    if state.CurrentState == "ENTERING" or state.CurrentState == "INITIALIZING" 
       or state.CurrentState == "ACTIVE" or state.CurrentState == "EXITING" then
        return true
    end

    if state.CurrentState == "WAITING" then
        if self:IsPlayerInArena() then
            self:SetState("INITIALIZING")
            return true
        end
        return self:IsBossPortalOpen()
    end

    return false
end

function HalloweenBossManager:IsLocked()
    if not self:IsEnabled() then return false end
    local state = getgenv().BossAutomationState
    if self:IsPlayerInArena() then return true end
    if state.CurrentState == "ENTERING" or state.CurrentState == "INITIALIZING" 
       or state.CurrentState == "ACTIVE" or state.CurrentState == "EXITING" then
        return true
    end
    return false
end

function HalloweenBossManager:Abort()
    if PriorityManager then PriorityManager:Release("Boss") end
    self.IsActive = false
    local state = getgenv().BossAutomationState
    state.IsBusy = false
    state.CurrentState = "WAITING"
    setCollisions(true)
    local _, root, hum = getAliveRig()
    if hum then hum.PlatformStand = false end
    if root then
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end
end

-- ==============================================================================
-- [ AUTO GHOST DOG QUEST MANAGER ]
-- ==============================================================================
GhostDogManager = {
    IsActive = false,
    CooldownUntil = 0
}

function GhostDogManager:GetDimension()
    return Services.Workspace:FindFirstChild("HalloweenDimension", true)
end

function GhostDogManager:GetMarker(name)
    local dim = self:GetDimension()
    local quest = dim and dim:FindFirstChild("GhostDogQuest")
    local markers = quest and quest:FindFirstChild("Markers")
    local m = markers and markers:FindFirstChild(name)
    return m and m:IsA("BasePart") and m or nil
end

function GhostDogManager:GetQuestData()
    local dataFolder = Services.ReplicatedStorage:FindFirstChild("Data")
    local gdData = dataFolder and dataFolder:FindFirstChild("GhostDogQuest")
    if gdData and gdData:IsA("ModuleScript") then
        local ok, mod = pcall(require, gdData)
        if ok and type(mod) == "table" and type(mod.Get) == "function" then
            local dOk, d = pcall(mod.Get)
            if dOk and type(d) == "table" then return d end
        end
    end
    local save = getSaveData()
    if save and type(save.GhostDogQuest) == "table" then
        return save.GhostDogQuest
    end
    return {}
end

function GhostDogManager:GetStage()
    local data = self:GetQuestData()
    return tonumber(data.Stage) or 0, data
end

function GhostDogManager:HasRod()
    local char = LocalPlayer.Character
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") and (item:GetAttribute("GhostDogRod") == true or item.Name:lower():find("ghostdogrod")) then
                return item
            end
        end
    end
    if bp then
        for _, item in ipairs(bp:GetChildren()) do
            if item:IsA("Tool") and (item:GetAttribute("GhostDogRod") == true or item.Name:lower():find("ghostdogrod")) then
                return item
            end
        end
    end
    return nil
end

function GhostDogManager:HasTicket()
    local char = LocalPlayer.Character
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    local function check(c)
        if not c then return false end
        for _, item in ipairs(c:GetChildren()) do
            if item:GetAttribute("ConductorTicket") == true or item.Name:lower():find("conductorticket") then
                return true
            end
        end
        return false
    end
    return check(char) or check(bp)
end

function GhostDogManager:MoveTo(pos, timeout)
    timeout = timeout or 8.0
    local _, root, hum = getAliveRig()
    if not root or not hum then return false end
    local dist = (root.Position - pos).Magnitude
    if dist <= 4 then return true end

    local speed = 180
    setCollisions(false)

    local start = os.clock()
    while (os.clock() - start) < timeout do
        if isHalloweenMapClosed() then break end
        local _, cRoot, cHum = getAliveRig()
        if not cRoot or not cHum or cHum.Health <= 0 then break end

        local diff = pos - cRoot.Position
        if diff.Magnitude <= 4 then break end

        local dt = Services.RunService.Heartbeat:Wait()
        local dir = diff.Unit
        local step = math.min(speed * dt, diff.Magnitude)

        cRoot.AssemblyLinearVelocity = dir * speed
        cRoot.CFrame = CFrame.new(cRoot.Position + dir * step, cRoot.Position + dir * 10)
    end

    local _, fRoot = getAliveRig()
    if fRoot then
        fRoot.AssemblyLinearVelocity = Vector3.zero
    end
    setCollisions(true)
    local _, endRoot = getAliveRig()
    return endRoot and (endRoot.Position - pos).Magnitude <= 6
end

function GhostDogManager:Talk(markerName, role)
    for i = 1, 3 do
        local ok, res1, res2 = invokeRemote("RF/GhostDogQuest/Talk", role)
        if ok and res1 then
            return res1, res2
        elseif type(res2) == "string" and not res2:lower():find("closer") then
            return res1, res2
        end
        local m = self:GetMarker(markerName)
        if m then self:MoveTo(m.Position + Vector3.new(0, 3, 0), 2.0) end
        task.wait(0.4)
    end
    return false, "failed"
end

function GhostDogManager:UnderwaterChase(chaseId, duration)
    local dataFolder = Services.ReplicatedStorage:FindFirstChild("Data")
    local gdQuestModule = dataFolder and dataFolder:FindFirstChild("GhostDogQuest")
    if not gdQuestModule then return false end
    local reqOk, gdQuestData = pcall(require, gdQuestModule)
    if not reqOk or type(gdQuestData) ~= "table" or type(gdQuestData.ChaseFrame) ~= "function" then
        return false
    end

    local function getChaseCFrame(dist)
        local ok, cf = pcall(gdQuestData.ChaseFrame, chaseId, dist)
        return ok and typeof(cf) == "CFrame" and cf or nil
    end

    local startCf = getChaseCFrame(0)
    if not startCf then return false end

    local _, root, hum = getAliveRig()
    if not root or not hum then return false end

    setCollisions(false)
    hum.PlatformStand = true
    local pitch = CFrame.Angles(-1.2566, 0, 0)

    local chaseSpeed = 58
    local totalDistance = duration * chaseSpeed
    local chaseStart = os.clock()

    while self.IsActive and LocalPlayer:GetAttribute("GhostDogChase") ~= nil do
        local traveled = math.min((os.clock() - chaseStart) * chaseSpeed, totalDistance)
        local cf = getChaseCFrame(traveled)
        if cf then
            local _, cRoot = getAliveRig()
            if cRoot then cRoot.CFrame = cf * pitch end
        end
        if traveled >= totalDistance then break end
        Services.RunService.Heartbeat:Wait()
    end

    local claimed = false
    for attempt = 1, 8 do
        if not self.IsActive then break end
        local ok, res = invokeRemote("RF/GhostDogQuest/Claim")
        if ok and res == true then
            claimed = true
            break
        end
        if attempt == 4 then
            local waitEnd = os.clock() + 5
            while os.clock() < waitEnd do
                local cf = getChaseCFrame(totalDistance)
                local _, cRoot = getAliveRig()
                if cf and cRoot then cRoot.CFrame = cf * pitch end
                Services.RunService.Heartbeat:Wait()
            end
        else
            task.wait(0.7)
        end
    end

    task.wait(claimed and 2.5 or 0.5)

    for surfaceAttempt = 1, 3 do
        local ok, res = invokeRemote("RF/GhostDogQuest/Surface")
        if ok and res == true then break end
        task.wait(0.5)
    end

    local returnSpot = self:GetMarker("ReturnSpot")
    if returnSpot then
        local _, cRoot = getAliveRig()
        if cRoot then cRoot.CFrame = returnSpot.CFrame + Vector3.new(0, 3, 0) end
    end

    local _, fRoot, fHum = getAliveRig()
    if fHum then fHum.PlatformStand = false end
    setCollisions(true)

    return claimed
end

function GhostDogManager:HasWork()
    if getgenv().config.autoGhostDog ~= true or isHalloweenMapClosed() then return false end
    if os.clock() < self.CooldownUntil then return false end
    local stage = self:GetStage()
    if stage >= 4 or self:HasTicket() then return false end
    return true
end

function GhostDogManager:Process()
    if self.IsActive then return end
    self.IsActive = true
    PriorityManager:Acquire("GhostDog", 35.0)

    local stage, questData = self:GetStage()
    local score = stage * 10
    local artifacts = questData and questData.Artifacts or {}
    for _, _ in pairs(artifacts) do score = score + 1 end
    if self:HasRod() then score = score + 5 end

    if stage == 0 then
        local dogSpot = self:GetMarker("DogSpot")
        if dogSpot and self:MoveTo(dogSpot.Position + Vector3.new(0, 3, 0), 8.0) then
            self:Talk("DogSpot", "Dog")
            task.wait(1.0)
        end
    elseif stage == 1 then
        local artifactList = {"Collar", "Bone", "Toy", "Photo"}
        local allCollected = true
        for _, artName in ipairs(artifactList) do
            if not (artifacts and artifacts[artName]) then
                allCollected = false
                local marker = self:GetMarker("Artifact_" .. artName)
                if marker and self:MoveTo(marker.Position + Vector3.new(0, 3, 0), 10.0) then
                    task.wait(0.3)
                    invokeRemote("RF/GhostDogQuest/Collect", artName)
                    task.wait(0.5)
                end
            end
        end
        if allCollected then
            local dogSpot = self:GetMarker("DogSpot")
            if dogSpot and self:MoveTo(dogSpot.Position + Vector3.new(0, 3, 0), 8.0) then
                self:Talk("DogSpot", "Dog")
                task.wait(1.0)
            end
        end
    elseif stage == 2 then
        local fishermanSpot = self:GetMarker("FishermanSpot")
        if fishermanSpot and self:MoveTo(fishermanSpot.Position + Vector3.new(0, 3, 0), 8.0) then
            local ok, res = self:Talk("FishermanSpot", "Fisherman")
            if res == "FisherReunion" or res == "FisherHint" or ok then
                task.wait(2.5)
                self:Talk("FishermanSpot", "Rod")
                task.wait(1.0)
            end
        end
    elseif stage == 3 then
        local castSpot = self:GetMarker("CastSpot")
        local castTarget = self:GetMarker("CastTarget")
        local rod = self:HasRod()
        if castSpot and castTarget and rod then
            if self:MoveTo(castSpot.Position + Vector3.new(0, 3, 0), 8.0) then
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then hum:EquipTool(rod) end
                task.wait(0.5)

                fireRemote("RE/Fishing/Hold")
                task.wait(1.0)
                local cOk, cRes = invokeRemote("RF/Fishing/Cast", 1.0, castTarget.Position)
                if cOk and type(cRes) == "table" and cRes.Mode == "Quest" then
                    task.wait((tonumber(cRes.Wait) or 3) + 0.45)
                    fireRemote("RE/Fishing/Cancel", cRes.Id)
                    local qOk, chaseId = invokeRemote("RF/GhostDogQuest/Cast")
                    if qOk and type(chaseId) == "number" then
                        invokeRemote("RF/GhostDogQuest/Dive")
                        self:UnderwaterChase(chaseId, 50)
                    end
                elseif cRes and cRes.Id then
                    fireRemote("RE/Fishing/Cancel", cRes.Id)
                end
            end
        end
    end

    local newStage, newQuestData = self:GetStage()
    local newScore = newStage * 10
    local newArtifacts = newQuestData and newQuestData.Artifacts or {}
    for _, _ in pairs(newArtifacts) do newScore = newScore + 1 end
    if self:HasRod() then newScore = newScore + 5 end

    if newScore == score then
        self.CooldownUntil = os.clock() + 20
    end

    self.IsActive = false
    PriorityManager:Release("GhostDog")
end

function GhostDogManager:Abort()
    self.IsActive = false
    pcall(function() invokeRemote("RF/GhostDogQuest/Abort") end)
    local _, root, hum = getAliveRig()
    if hum then hum.PlatformStand = false end
    setCollisions(true)
    PriorityManager:Release("GhostDog")
end

-- ==============================================================================
-- [ AUTO HALLOWEEN FISHING ENGINE ]
-- ==============================================================================
HalloweenFishingManager = {
    IsActive = false,
    CooldownUntil = 0,
    FishCaught = 0,
    CurrentFishingSpot = nil
}

function HalloweenFishingManager:HasRod()
    local char = LocalPlayer.Character
    local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
    local function check(c)
        if not c then return nil end
        for _, item in ipairs(c:GetChildren()) do
            if item:IsA("Tool") and (item:GetAttribute("GhostDogRod") == true 
               or item:GetAttribute("FishingRod") ~= nil 
               or item.Name:lower():find("rod") 
               or item.Name:lower():find("fishing")) then
                return item
            end
        end
        return nil
    end
    return check(char) or check(bp)
end

function HalloweenFishingManager:RaycastWater(pos)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    local filter = {LocalPlayer.Character}
    for attempt = 1, 6 do
        params.FilterDescendantsInstances = filter
        local hit = Services.Workspace:Raycast(pos + Vector3.new(0, 40, 0), Vector3.new(0, -180, 0), params)
        if not hit then return nil end
        local inst = hit.Instance
        if hit.Material == Enum.Material.Water 
           or inst:GetAttribute("TerrainRole") == "Basin" 
           or inst:GetAttribute("FishingWater") ~= nil 
           or Services.CollectionService:HasTag(inst, "FishingWater") then
            return hit.Position
        end
        if inst:IsA("BasePart") and inst.Transparency >= 0.95 then
            table.insert(filter, inst)
        else
            return nil
        end
    end
    return nil
end

function HalloweenFishingManager:FindWaterTarget()
    local _, root = getAliveRig()
    if not root then return nil end

    local fisherman = Services.Workspace:FindFirstChild("GhostFisherman")
    local returnSpot = GhostDogManager and GhostDogManager:GetMarker("ReturnSpot")
    local castTarget = GhostDogManager and GhostDogManager:GetMarker("CastTarget")

    local lookVec = fisherman and fisherman:IsA("Model") and fisherman:GetPivot().LookVector
                 or (returnSpot and returnSpot.CFrame.LookVector)
                 or Vector3.new(0, 0, -1)
    local baseAngle = math.atan2(lookVec.Z, lookVec.X)

    local charge = 0.875
    local luck = currentSettings.CastLuck or "x1.5 Perfect"
    if luck == "x1.2 Good" then charge = 0.7 elseif luck == "x1.0 Normal" then charge = 0.5 end
    local scanDist = 10 + 32 * charge

    for i = 0, 12 do
        local angle = baseAngle + (i % 2 == 0 and 1 or -1) * math.ceil(i / 2) * (math.pi / 18)
        local scanPos = root.Position + Vector3.new(math.cos(angle), 0, math.sin(angle)) * scanDist
        local waterPos = self:RaycastWater(scanPos)
        if waterPos then
            if not castTarget or (waterPos - castTarget.Position).Magnitude >= 12 then
                return waterPos
            end
        end
    end
    return nil
end

function HalloweenFishingManager:GetFishingSpot()
    local _, root = getAliveRig()
    if not root then return nil end

    if self.CurrentFishingSpot and (self.CurrentFishingSpot - root.Position).Magnitude <= 10 then
        return self.CurrentFishingSpot
    end

    local returnSpot = GhostDogManager and GhostDogManager:GetMarker("ReturnSpot")
    if returnSpot and returnSpot:IsA("BasePart") then
        self.CurrentFishingSpot = returnSpot.Position + Vector3.new(0, 3, 0)
        return self.CurrentFishingSpot
    end

    local fisherman = Services.Workspace:FindFirstChild("GhostFisherman")
    if fisherman and fisherman:IsA("Model") then
        local pivot = fisherman:GetPivot()
        self.CurrentFishingSpot = pivot.Position + Vector3.new(0, 3, 0)
        return self.CurrentFishingSpot
    end

    return Vector3.new(-5478.0, -195.0, -6830.0)
end

function HalloweenFishingManager:GlideToSpot(targetPos, timeout)
    local char, root = getAliveRig()
    if not root then return false end

    timeout = timeout or 12.0
    local speed = 260
    local stopDist = 4.0

    setCollisions(false)
    local start = os.clock()

    while (targetPos - root.Position).Magnitude > stopDist do
        if not self.IsActive or getgenv().config.autoFishing ~= true or isHalloweenMapClosed() or (os.clock() - start) > timeout then
            break
        end

        local dt = Services.RunService.Heartbeat:Wait()
        local _, cRoot = getAliveRig()
        if not cRoot then break end
        root = cRoot

        local diff = targetPos - cRoot.Position
        if diff.Magnitude <= stopDist then break end
        local dir = diff.Unit
        local step = math.min(speed * dt, diff.Magnitude)

        cRoot.AssemblyLinearVelocity = dir * speed
        cRoot.CFrame = CFrame.new(cRoot.Position + dir * step, cRoot.Position + dir * 10)
    end

    local _, fRoot = getAliveRig()
    if fRoot then
        fRoot.AssemblyLinearVelocity = Vector3.zero
    end
    setCollisions(true)
    return fRoot and (targetPos - fRoot.Position).Magnitude <= 6.0
end

function HalloweenFishingManager:HasWork()
    if getgenv().config.autoFishing ~= true or isHalloweenMapClosed() then return false end
    if os.clock() < self.CooldownUntil then return false end
    if GhostDogManager and GhostDogManager.IsActive then return false end
    return self:HasRod() ~= nil
end

function HalloweenFishingManager:Process()
    if self.IsActive then return end
    self.IsActive = true
    PriorityManager:Acquire("Fishing", 20.0)

    -- Stage 3 check: if on stage 3 of Ghost Dog quest, ripple cast is required first
    local stage = GhostDogManager and GhostDogManager:GetStage()
    if stage == 3 then
        if GhostDogManager and GhostDogManager.Process then
            GhostDogManager:Process()
        end
        self.IsActive = false
        PriorityManager:Release("Fishing")
        return
    end

    local spotPos = self:GetFishingSpot()
    local _, root = getAliveRig()
    if spotPos and root and ((root.Position - spotPos).Magnitude > 6 or spotPos.Y + 1 > root.Position.Y) then
        self:GlideToSpot(spotPos, 12.0)
    end

    local waterTarget = self:FindWaterTarget()
    if not waterTarget then
        self.CooldownUntil = os.clock() + 2
        self.IsActive = false
        PriorityManager:Release("Fishing")
        return
    end

    local rod = self:HasRod()
    local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
    if hum and rod then hum:EquipTool(rod) end
    task.wait(0.3)

    -- Pin character and face water
    local _, liveRoot = getAliveRig()
    if liveRoot then
        liveRoot.CFrame = CFrame.lookAt(liveRoot.Position, Vector3.new(waterTarget.X, liveRoot.Position.Y, waterTarget.Z))
        liveRoot.AssemblyLinearVelocity = Vector3.zero
    end

    local charge = 0.875
    local luck = currentSettings.CastLuck or "x1.5 Perfect"
    if luck == "x1.2 Good" then charge = 0.7 elseif luck == "x1.0 Normal" then charge = 0.5 end
    local holdDuration = 1.2 * (charge ^ 0.7142857)

    fireRemote("RE/Fishing/Hold")
    task.wait(holdDuration)

    local castOk, biteData, errMsg = invokeRemote("RF/Fishing/Cast", holdDuration, waterTarget)
    if not castOk or type(biteData) ~= "table" then
        self.CooldownUntil = os.clock() + (tostring(errMsg):lower():find("closed") and 30 or 2)
        self.IsActive = false
        PriorityManager:Release("Fishing")
        return
    end

    local waitTime = tonumber(biteData.Wait) or 3.0
    local waitStart = os.clock()
    while (os.clock() - waitStart) < waitTime do
        if not self.IsActive then break end
        local _, cRoot = getAliveRig()
        if cRoot then
            cRoot.CFrame = CFrame.lookAt(cRoot.Position, Vector3.new(waterTarget.X, cRoot.Position.Y, waterTarget.Z))
            cRoot.AssemblyLinearVelocity = Vector3.zero
        end
        Services.RunService.Heartbeat:Wait()
    end

    if not self.IsActive then
        fireRemote("RE/Fishing/Cancel", biteData.Id)
        PriorityManager:Release("Fishing")
        return
    end

    if biteData.Mode == "GhostFish" then
        local chaseOk, chaseId = invokeRemote("RF/GhostDogQuest/Cast", biteData.Id)
        if chaseOk and type(chaseId) == "number" and GhostDogManager and GhostDogManager.UnderwaterChase then
            invokeRemote("RF/GhostDogQuest/Dive")
            GhostDogManager:UnderwaterChase(chaseId, 25)
        end
    elseif biteData.Mode == "Nothing" or biteData.Mode == "Hint" or biteData.Mode == "Quest" then
        fireRemote("RE/Fishing/Cancel", biteData.Id)
    else
        -- Simulate reel minigame
        local reelStart = os.clock()
        while (os.clock() - reelStart) < 1.2 and self.IsActive do
            pcall(function()
                local fc = Services.ReplicatedStorage:FindFirstChild("Controllers")
                local gfc = fc and fc:FindFirstChild("Game")
                local fishCtrl = gfc and gfc:FindFirstChild("FishingController")
                local uiMod = fishCtrl and fishCtrl:FindFirstChild("Ui")
                if uiMod then
                    local req = require(uiMod)
                    if req and req.PunchReel then req.PunchReel() end
                end
            end)
            task.wait(0.1)
        end

        local reelOk, reelSuccess, reward = invokeRemote("RF/Fishing/Reel", biteData.Id, "Caught", 16)
        if reelOk and reelSuccess then
            self.FishCaught = self.FishCaught + 1
        else
            fireRemote("RE/Fishing/Cancel", biteData.Id)
        end
    end

    self.CooldownUntil = os.clock() + 1.2
    self.IsActive = false
    PriorityManager:Release("Fishing")
end

function HalloweenFishingManager:Abort()
    self.IsActive = false
    PriorityManager:Release("Fishing")
end


-- [ TASK PRIORITY ARBITRATOR ]
-- ==============================================================================
PriorityManager = {
    ActiveTask = nil,
    ActiveTaskExpiresAt = 0,
    List = {
        "Auto Boss",
        "Auto Ghost Dog",
        "Auto Steal",
        "Candy Cane Farm",
        "Auto Pumpkin",
        "Auto Fishing",
        "Auto Buy Halloween Egg",
        "Enchanted / Bloom Event",
        "Auto Upgrades",
        "Auto Treadmill"
    },
    TaskAliases = {
        ["Steal"] = "Auto Steal",
        ["Auto Steal"] = "Auto Steal",
        ["HalloweenSteal"] = "Halloween Steal",
        ["Halloween Steal"] = "Halloween Steal",
        ["Boss"] = "Auto Boss",
        ["AutoBoss"] = "Auto Boss",
        ["Auto Boss"] = "Auto Boss",
        ["GhostDog"] = "Auto Ghost Dog",
        ["AutoGhostDog"] = "Auto Ghost Dog",
        ["Auto Ghost Dog"] = "Auto Ghost Dog",
        ["CandyCane"] = "Candy Cane Farm",
        ["Candy Cane Farm"] = "Candy Cane Farm",
        ["Auto Candy Cane"] = "Candy Cane Farm",
        ["Pumpkin"] = "Auto Pumpkin",
        ["AutoPumpkin"] = "Auto Pumpkin",
        ["Auto Pumpkin"] = "Auto Pumpkin",
        ["Fishing"] = "Auto Fishing",
        ["AutoFishing"] = "Auto Fishing",
        ["Auto Fishing"] = "Auto Fishing",
        ["BuyHalloweenEgg"] = "Auto Buy Halloween Egg",
        ["AutoBuyHalloweenEgg"] = "Auto Buy Halloween Egg",
        ["Auto Buy Halloween Egg"] = "Auto Buy Halloween Egg",
        ["Bloom"] = "Enchanted / Bloom Event",
        ["Bloom Event"] = "Enchanted / Bloom Event",
        ["Enchanted"] = "Enchanted / Bloom Event",
        ["Enchanted / Bloom Event"] = "Enchanted / Bloom Event",
        ["Upgrades"] = "Auto Upgrades",
        ["Auto Upgrades"] = "Auto Upgrades",
        ["Treadmill"] = "Auto Treadmill",
        ["Auto Treadmill"] = "Auto Treadmill"
    }
}

function PriorityManager:Initialize(savedPriorities)
    local canonicalList = {
        "Auto Boss",
        "Auto Ghost Dog",
        "Auto Train",
        "Auto Vacuum",
        "Auto Steal",
        "Candy Cane Farm",
        "Auto Pumpkin",
        "Auto Fishing",
        "Auto Buy Halloween Egg",
        "Enchanted / Bloom Event",
        "Auto Upgrades",
        "Auto Treadmill"
    }

    local valid = {}
    for _, name in ipairs(canonicalList) do valid[name] = true end

    if type(savedPriorities) == "table" and #savedPriorities > 0 then
        local newList = {}
        for _, rawName in ipairs(savedPriorities) do
            local name = self.TaskAliases[rawName] or rawName
            if valid[name] then
                table.insert(newList, name)
                valid[name] = nil
            end
        end
        for canonIndex, name in ipairs(canonicalList) do
            if valid[name] then
                table.insert(newList, math.min(canonIndex, #newList + 1), name)
            end
        end
        self.List = newList
    else
        self.List = canonicalList
    end
end

function PriorityManager:GetRank(taskName)
    local resolved = self.TaskAliases[taskName] or taskName
    for index, name in ipairs(self.List) do
        if name == resolved then
            return index
        end
    end
    return 999
end

function PriorityManager:IsLocked()
    if self.ActiveTask ~= nil then
        if os.clock() < self.ActiveTaskExpiresAt then
            return true
        else
            self.ActiveTask = nil
            self.ActiveTaskExpiresAt = 0
            return false
        end
    end
    return false
end

function PriorityManager:Acquire(taskName, maxDuration)
    local resolved = self.TaskAliases[taskName] or taskName
    maxDuration = maxDuration or 15.0

    if not self:IsLocked() then
        self.ActiveTask = resolved
        self.ActiveTaskExpiresAt = os.clock() + maxDuration
        return true
    elseif self.ActiveTask == resolved then
        self.ActiveTaskExpiresAt = math.max(self.ActiveTaskExpiresAt, os.clock() + maxDuration)
        return true
    end
    return false
end

function PriorityManager:Claim(taskName)
    return self:Acquire(taskName, 15.0)
end

function PriorityManager:Release(taskName)
    local resolved = self.TaskAliases[taskName] or taskName
    if self.ActiveTask == resolved or self.ActiveTask == taskName then
        self.ActiveTask = nil
        self.ActiveTaskExpiresAt = 0
    end
end

function PriorityManager:GetTaskDimension(taskName)
    local resolved = self.TaskAliases[taskName] or taskName
    if resolved == "Auto Boss" or resolved == "Candy Cane Farm" or resolved == "Auto Pumpkin" or resolved == "Halloween Steal" 
       or resolved == "Auto Ghost Dog" or resolved == "Auto Fishing" or resolved == "Auto Buy Halloween Egg" then
        return "Halloween"
    elseif resolved == "Auto Steal" or resolved == "Enchanted / Bloom Event" or resolved == "Auto Treadmill" then
        return "Normal"
    end
    return "Any"
end

function PriorityManager:IsTaskEnabled(taskName)
    local resolved = self.TaskAliases[taskName] or taskName
    if resolved == "Auto Boss" then
        return getgenv().config.autoBossEvent == true
    elseif resolved == "Auto Ghost Dog" then
        return getgenv().config.autoGhostDog == true and not isHalloweenMapClosed()
    elseif resolved == "Halloween Steal" then
        return getgenv().InstantStealHalloween == true and not isHalloweenMapClosed()
    elseif resolved == "Halloween Steal" then
        if isHalloweenMapClosed() or getgenv().InstantStealHalloween ~= true then return false end
        if isCarryingEgg and isCarryingEgg() then return true end
        if HalloweenStealManager and HalloweenStealManager.State and HalloweenStealManager.State.isBusy then return true end
        if HalloweenStealManager and HalloweenStealManager.SelectTargetEgg then
            return HalloweenStealManager.SelectTargetEgg() ~= nil
        end
        return false
    elseif resolved == "Auto Steal" then
        return isStealEnabled() and not isMapClosed()
    elseif resolved == "Candy Cane Farm" then
        return getgenv().config.autoCandyCane == true and not isHalloweenMapClosed()
    elseif resolved == "Auto Pumpkin" then
        return getgenv().config.autoPumpkin == true and not isHalloweenMapClosed()
    elseif resolved == "Auto Fishing" then
        return getgenv().config.autoFishing == true and not isHalloweenMapClosed()
    elseif resolved == "Auto Buy Halloween Egg" then
        return getgenv().config.autoBuyHalloweenEgg == true
    elseif resolved == "Enchanted / Bloom Event" then
        return (getgenv().config.autoCatchButterfly == true or getgenv().config.autoWispQuest == true or getgenv().config.autoTradeUp == true or getgenv().config.autoCraftEssence == true) and not isMapClosed()
    elseif resolved == "Auto Upgrades" then
        return (getgenv().config.autoUpgradeTreadmill == true or getgenv().config.autoUpgradeBase == true)
    elseif resolved == "Auto Treadmill" then
        return getgenv().config.autoTreadmill == true and not isMapClosed()
    end
    return false
end

function PriorityManager:HasWork(taskName)
    local resolved = self.TaskAliases[taskName] or taskName

    if resolved == "Auto Boss" then
        return HalloweenBossManager ~= nil and HalloweenBossManager:HasWork()

    elseif resolved == "Auto Ghost Dog" then
        return GhostDogManager ~= nil and GhostDogManager:HasWork()

    elseif resolved == "Auto Steal" then
        if isMapClosed() or not isStealEnabled() then return false end
        if isNormalStealPanelTarget() then return true end
        if State.isStealingActive or isHoldingEgg() then return true end
        if typeof(getBestEgg) == "function" then
            return getBestEgg() ~= nil
        end
        return false


    elseif resolved == "Candy Cane Farm" then
        if isHalloweenMapClosed() or getgenv().config.autoCandyCane ~= true then return false end
        local inHalloween = HalloweenPortalManager and HalloweenPortalManager.IsInHalloweenDimension()
        if inHalloween then
            local monster = HalloweenCombatManager and HalloweenCombatManager.GetClosestMonster and HalloweenCombatManager:GetClosestMonster()
            return monster ~= nil
        else
            local dim = Services.Workspace:FindFirstChild("HalloweenDimension", true)
            if dim then
                local monsters = dim:FindFirstChild("Monsters")
                if monsters and #monsters:GetChildren() > 0 then
                    return true
                end
            end
            return true
        end

    elseif resolved == "Auto Pumpkin" then
        if isHalloweenMapClosed() or getgenv().config.autoPumpkin ~= true then return false end
        if HalloweenPumpkinManager and (HalloweenPumpkinManager.IsBusy or HalloweenPumpkinManager:IsCarrying()) then
            return true
        end
        -- Authoritative Pumpkin Moon event gating (stops infinite portal enter/exit oscillation)
        if HalloweenPumpkinManager and HalloweenPumpkinManager.IsEventActive and not HalloweenPumpkinManager:IsEventActive() then
            return false
        end
        local inHalloween = HalloweenPortalManager and HalloweenPortalManager.IsInHalloweenDimension()
        if inHalloween then
            local target = HalloweenPumpkinManager and HalloweenPumpkinManager.GetTarget and HalloweenPumpkinManager:GetTarget()
            return target ~= nil
        else
            return true
        end

    elseif resolved == "Auto Fishing" then
        return HalloweenFishingManager ~= nil and HalloweenFishingManager:HasWork()

    elseif resolved == "Auto Buy Halloween Egg" then
        if getgenv().config.autoBuyHalloweenEgg ~= true then return false end
        local inHalloween = HalloweenPortalManager and HalloweenPortalManager.IsInHalloweenDimension()
        return inHalloween and (os.clock() >= (State.halloweenEggBuyCooldown or 0))

    elseif resolved == "Enchanted / Bloom Event" then
        if isMapClosed() then return false end
        local wantButterfly = getgenv().config.autoCatchButterfly == true
        local wantWisp = getgenv().config.autoWispQuest == true
        local wantTrade = getgenv().config.autoTradeUp == true
        local wantCraft = getgenv().config.autoCraftEssence == true
        if not (wantButterfly or wantWisp or wantTrade or wantCraft) then return false end

        if wantButterfly and BloomManager and BloomManager.GetButterflies and #BloomManager:GetButterflies() > 0 then
            return true
        end
        if wantWisp or wantTrade or wantCraft then
            return true
        end
        return false

    elseif resolved == "Auto Upgrades" then
        if not (getgenv().config.autoUpgradeTreadmill or getgenv().config.autoUpgradeBase) then return false end
        return os.clock() >= State.treadmillUpgradeCooldown or os.clock() >= State.baseUpgradeCooldown

    elseif resolved == "Auto Treadmill" then
        if isMapClosed() or getgenv().config.autoTreadmill ~= true then return false end
        return true
    end

    return false
end

function PriorityManager:GetTopWantedTask()
    -- ActiveTask mutex lock ownership
    if self:IsLocked() and self.ActiveTask then
        return self.ActiveTask
    end

    -- Auto Boss mid-run (portal entry / arena / exit) can never be preempted
    if HalloweenBossManager and HalloweenBossManager:IsLocked() then
        return "Auto Boss"
    end
    if isNormalStealPanelTarget() then
        return "Auto Steal"
    end

    if getgenv().InstantStealHalloween and HalloweenStealManager and HalloweenStealManager.State and HalloweenStealManager.State.isBusy then
        return "Halloween Steal"
    end
    if isHoldingEgg() or State.isStealingActive then
        return "Auto Steal"
    end
    if HalloweenPumpkinManager and (HalloweenPumpkinManager.IsBusy or HalloweenPumpkinManager:IsCarrying()) then
        return "Auto Pumpkin"
    end
    if GhostDogManager and GhostDogManager.IsActive then
        return "Auto Ghost Dog"
    end
    if HalloweenFishingManager and HalloweenFishingManager.IsActive then
        return "Auto Fishing"
    end

    for _, taskName in ipairs(self.List) do
        if self:IsTaskEnabled(taskName) and self:HasWork(taskName) then
            return taskName
        end
    end

    return nil
end

function PriorityManager:CanRun(taskName)
    local inRace = LocalPlayer:GetAttribute("RaceId") ~= nil
    if inRace and taskName ~= "Race" then
        return false
    end

    local resolved = self.TaskAliases[taskName] or taskName

    -- Independent task: Auto Upgrades never contends for the character
    if resolved == "Auto Upgrades" then
        return self:IsTaskEnabled("Auto Upgrades")
    end

    -- If another task holds the character lock, no other task can run
    if self:IsLocked() and self.ActiveTask ~= resolved then
        return false
    end

    local topTask = self:GetTopWantedTask()
    if not topTask then
        return false
    end

    return (resolved == topTask)
end

function PriorityManager:MoveUp(index, saveCallback)
    if index > 1 then
        local item = table.remove(self.List, index)
        table.insert(self.List, index - 1, item)
        if saveCallback then saveCallback(self.List) end
        return true
    end
    return false
end

function PriorityManager:MoveDown(index, saveCallback)
    if index < #self.List then
        local item = table.remove(self.List, index)
        table.insert(self.List, index + 1, item)
        if saveCallback then saveCallback(self.List) end
        return true
    end
    return false
end

PriorityManager:Initialize(currentSettings.TaskPriorities)

-- ==============================================================================
-- [ CENTRALIZED HEARTBEAT WORKER SCHEDULER (NON-OVERLAPPING) ]
-- ==============================================================================
local WorkerScheduler = {
    Tasks = {},
    Connection = nil,
    IsActive = true
}

function WorkerScheduler:Register(name, interval, runFn)
    local item = { Name = name, Gap = 0, Interval = interval or 0.35, Hold = 0, Running = false, Run = runFn }
    table.insert(self.Tasks, item)
    return item
end

function WorkerScheduler:Start()
    if self.Connection then return end
    self.Connection = Services.RunService.Heartbeat:Connect(function(dt)
        if not self.IsActive then return end
        for _, t in ipairs(self.Tasks) do
            t.Gap = t.Gap + dt
            if t.Hold > 0 then
                t.Hold = t.Hold - dt
            elseif not t.Running and t.Gap >= t.Interval then
                t.Gap = 0
                t.Running = true
                task.spawn(function()
                    local ok, err = pcall(t.Run)
                    t.Running = false
                    if not ok and err then
                        t.Hold = 3
                    end
                end)
            end
        end
    end)
end

-- ==============================================================================
-- [ AUTOMATED UPGRADE CONTROLLERS ]
-- ==============================================================================
local function tryUpgradeTreadmill()
    if not Remotes.TierRaise or os.clock() < State.treadmillUpgradeCooldown then return end
    State.treadmillUpgradeCooldown = os.clock() + 5

    local save = getSaveData()
    local myMoney = math.max(getPlayerMoney(), tonumber(save and save.Money) or 0)

    local dataFolder = Services.ReplicatedStorage:FindFirstChild("Data")
    local treadmillsModule = dataFolder and dataFolder:FindFirstChild("Treadmills")
    if not treadmillsModule then return end

    local ok, tData = pcall(require, treadmillsModule)
    if not ok or type(tData) ~= "table" then return end

    local currentLevel = tonumber(save and save.TreadmillUpgradeLevel) or 0
    if type(tData.GetByUpgradeLevel) == "function" then
        local okNext, nextTier = pcall(tData.GetByUpgradeLevel, currentLevel + 1)
        if okNext and type(nextTier) == "table" then
            local nextId = nextTier._id
            local price = tonumber(nextTier.Price) or math.huge
            if type(nextId) == "string" and myMoney >= price then
                pcall(function() Remotes.TierRaise:InvokeServer(nextId) end)
                return
            end
        end
    end

    if type(tData.Directory) == "table" then
        local sorted = {}
        for name, cfg in pairs(tData.Directory) do
            table.insert(sorted, { Name = tostring(name), Price = tonumber(cfg.Price) or 0, Level = tonumber(cfg.UpgradeLevel) or tonumber(cfg.Level) or 0 })
        end
        table.sort(sorted, function(a, b) return a.Price < b.Price end)
        for _, item in ipairs(sorted) do
            if item.Level > currentLevel and myMoney >= item.Price then
                pcall(function() Remotes.TierRaise:InvokeServer(item.Name) end)
                break
            end
        end
    end
end

local function tryUpgradeBase()
    if not Remotes.BaseTierRaise or os.clock() < State.baseUpgradeCooldown then return end
    State.baseUpgradeCooldown = os.clock() + 5

    local dataFolder = Services.ReplicatedStorage:FindFirstChild("Data")
    local basesModule = dataFolder and dataFolder:FindFirstChild("Bases")
    if not basesModule then return end

    local ok, bData = pcall(require, basesModule)
    if not ok or type(bData) ~= "table" or type(bData.BASES) ~= "table" then return end

    local save = getSaveData()
    local currentLevel = tonumber(save and save.BaseUpgradeLevel) or 0
    local maxLevel = type(bData.GetMaxBaseLevel) == "function" and tonumber(bData.GetMaxBaseLevel()) or #bData.BASES

    if currentLevel >= maxLevel then return end

    local nextTier = bData.BASES[currentLevel + 1]
    local cost = nextTier and (tonumber(nextTier.Cost) or tonumber(nextTier.Price)) or nil
    local myMoney = math.max(getPlayerMoney(), tonumber(save and save.Money) or 0)

    if cost and myMoney >= cost then
        pcall(function() Remotes.BaseTierRaise:FireServer() end)
    end
end

-- ==============================================================================
-- [ FAST STEAL PIPELINE (TITAN / LIGHT DARK / ENCHANTED) ]
-- ==============================================================================
-- ==============================================================================
-- [ DYNAMIC SPEED IDENTIFIER ]
-- ==============================================================================
local function getPlayerCurrentSpeed()
    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")

    -- 1. Check live Humanoid WalkSpeed (handling ShieldManager clone if active)
    if hum and typeof(hum.WalkSpeed) == "number" and hum.WalkSpeed > 0 then
        if ShieldManager and ShieldManager.OriginalHumanoid and ShieldManager.OriginalHumanoid.Parent == nil then
            if ShieldManager.OriginalHumanoid.WalkSpeed > hum.WalkSpeed then
                return ShieldManager.OriginalHumanoid.WalkSpeed
            end
        end
        return hum.WalkSpeed
    end

    -- 2. Check Character & Player Attributes
    if char then
        for _, attrName in ipairs({"WalkSpeed", "Speed", "CurrentSpeed", "MovementSpeed"}) do
            local val = char:GetAttribute(attrName)
            if typeof(val) == "number" and val > 0 then return val end
        end
    end
    for _, attrName in ipairs({"WalkSpeed", "Speed", "CurrentSpeed", "MovementSpeed"}) do
        local val = LocalPlayer:GetAttribute(attrName)
        if typeof(val) == "number" and val > 0 then return val end
    end

    -- 3. Check leaderstats
    local lstats = LocalPlayer:FindFirstChild("leaderstats")
    if lstats then
        for _, child in ipairs(lstats:GetChildren()) do
            local lName = child.Name:lower()
            if (lName == "speed" or lName == "walkspeed") and typeof(child.Value) == "number" and child.Value > 0 then
                return child.Value
            end
        end
    end

    -- 4. Check Save module peek
    local saveMod = Services.ReplicatedStorage:FindFirstChild("Shared") and Services.ReplicatedStorage.Shared:FindFirstChild("Save")
    if saveMod and saveMod:IsA("ModuleScript") then
        local ok, mod = pcall(require, saveMod)
        if ok and type(mod) == "table" then
            local getter = type(mod.Get) == "function" and mod.Get or (type(mod.Peek) == "function" and mod.Peek)
            if getter then
                local resOk, res = pcall(getter)
                if resOk and type(res) == "table" then
                    for k, v in pairs(res) do
                        local lk = tostring(k):lower()
                        if (lk == "speed" or lk == "walkspeed") and typeof(v) == "number" and v > 0 then
                            return v
                        end
                    end
                end
            end
        end
    end

    return 16
end
getgenv().getPlayerCurrentSpeed = getPlayerCurrentSpeed

local function getStandingPosition(basePos)
    local _, root, hum = getAliveRig()
    local hipHeight = hum and hum.HipHeight or 2
    local rootSizeY = root and (root.Size.Y / 2) or 1
    return Vector3.new(basePos.X, basePos.Y + hipHeight + rootSizeY, basePos.Z)
end

local function runAlongGroundSegment(targetPos, stopDist, sessionId, targetUid)
    local char, root, hum = getAliveRig()
    if not root or not hum then return false end
    stopDist = stopDist or 3.5

    local liveSpeed = getPlayerCurrentSpeed()
    setCollisions(false)
    if hum then hum.PlatformStand = false end

    local delta = Vector3.new(targetPos.X - root.Position.X, 0, targetPos.Z - root.Position.Z)
    local timeout = os.clock() + math.max(8, (delta.Magnitude / math.max(liveSpeed, 16)) + 5)
    local arrived = false
    local lastLiveCheck = 0

    local conn
    conn = Services.RunService.Heartbeat:Connect(function()
        if sessionId ~= State.currentStealSession or not isStealEnabled() or isMapClosed() then
            if conn then conn:Disconnect() conn = nil end
            return
        end

        local _, cRoot = getAliveRig()
        if not cRoot or os.clock() > timeout then
            if conn then conn:Disconnect() conn = nil end
            return
        end

        if targetUid and (os.clock() - lastLiveCheck >= 0.25) then
            lastLiveCheck = os.clock()
            if not isEggStillValid(targetUid) then
                blacklistEgg(targetUid, 15)
                if conn then conn:Disconnect() conn = nil end
                return
            end
        end

        local currentPos = cRoot.Position
        local flatDiff = Vector3.new(targetPos.X - currentPos.X, 0, targetPos.Z - currentPos.Z)
        if flatDiff.Magnitude <= stopDist then
            arrived = true
            cRoot.AssemblyLinearVelocity = Vector3.zero
            cRoot.AssemblyAngularVelocity = Vector3.zero
            if conn then conn:Disconnect() conn = nil end
            return
        end

        local curSpeed = getPlayerCurrentSpeed()
        local dir = flatDiff.Unit
        -- Pure physics velocity using player's own speed, keeping character naturally grounded
        cRoot.AssemblyLinearVelocity = Vector3.new(dir.X * curSpeed, cRoot.AssemblyLinearVelocity.Y, dir.Z * curSpeed)
        cRoot.CFrame = CFrame.new(currentPos.X, currentPos.Y, currentPos.Z) * CFrame.lookAt(Vector3.zero, dir)
    end)

    while conn and conn.Connected do
        Services.RunService.Heartbeat:Wait()
    end

    local _, fRoot = getAliveRig()
    if fRoot then
        fRoot.AssemblyLinearVelocity = Vector3.zero
        fRoot.AssemblyAngularVelocity = Vector3.zero
    end

    return arrived and (sessionId == State.currentStealSession) and isStealEnabled()
end

local function runAlongGroundToEgg(targetPos, speed, sessionId, targetUid)
    local char, root, hum = getAliveRig()
    if not root or not hum then return false end

    local currentPosInit = root.Position
    local groundY = CONFIG.GroundAltitude + 1.0

    -- Safe Zone T-Shape Routing:
    -- If inside safe zone (X < BoundaryCheckpointX), route via delivery center & corridor mouth
    -- to prevent clipping through corner walls and getting killed!
    if currentPosInit.X < CONFIG.BoundaryCheckpointX then
        local centerDeliveryPos = Vector3.new(CONFIG.BaseDropPosition.X, groundY, CONFIG.BaseDropPosition.Z)
        local mouthPos = Vector3.new(CONFIG.BoundaryCheckpointX, groundY, CONFIG.BaseDropPosition.Z)

        local lateralDist = math.abs(currentPosInit.Z - CONFIG.BaseDropPosition.Z)
        if lateralDist > 12 or currentPosInit.X < CONFIG.BaseDropPosition.X then
            local ok = runAlongGroundSegment(centerDeliveryPos, 4.0, sessionId, targetUid)
            if not ok or sessionId ~= State.currentStealSession or not isStealEnabled() then
                return false
            end
        end

        local ok2 = runAlongGroundSegment(mouthPos, 4.0, sessionId, targetUid)
        if not ok2 or sessionId ~= State.currentStealSession or not isStealEnabled() then
            return false
        end
    end

    -- From corridor mouth, travel directly down the corridor to the target egg
    local targetStandPos = getStandingPosition(targetPos)
    local reached = runAlongGroundSegment(targetStandPos, 3.5, sessionId, targetUid)
    if not reached or sessionId ~= State.currentStealSession or not isStealEnabled() then
        return false
    end

    -- Only align facing when successfully arrived and steal is still actively enabled!
    local _, fRoot = getAliveRig()
    if fRoot then
        fRoot.CFrame = CFrame.lookAt(targetStandPos, targetPos)
        fRoot.AssemblyLinearVelocity = Vector3.zero
        fRoot.AssemblyAngularVelocity = Vector3.zero
    end
    task.wait(0.04)
    return true
end

local function executeFastStealOutbound(targetPos, sessionId, targetUid)
    local world = Services.Workspace:FindFirstChild("World") or Services.Workspace:FindFirstChild("__OBJECTS")
    local build = world and world:FindFirstChild("Build")
    local portals = build and build:FindFirstChild("FuseBiomeLanePortals")
    local entrance = portals and portals:FindFirstChildWhichIsA("BasePart")
    local zone = build and build:FindFirstChild("FuseBiomeZone")
    local exitPart = zone and zone:FindFirstChild("ExitPart", true)

    if not entrance or not exitPart then
        return runAlongGroundToEgg(targetPos, nil, sessionId, targetUid)
    end

    local _, root = getAliveRig()
    if not root then return false end

    root.CFrame = CFrame.new(CONFIG.BaseDropPosition)
    root.AssemblyLinearVelocity = Vector3.zero
    task.wait(0.12)

    local inSky = false
    local entranceTimeout = os.clock() + 4.0

    while os.clock() < entranceTimeout do
        if sessionId ~= State.currentStealSession or not isStealEnabled() then return false end
        local _, cRoot = getAliveRig()
        if not cRoot then return false end

        cRoot.CFrame = CFrame.new(entrance.Position)
        cRoot.AssemblyLinearVelocity = Vector3.new(0, -0.5, 0)
        UniversalCompat.FireTouch(cRoot, entrance)

        if cRoot.Position.Y > 10000 then
            inSky = true
            break
        end
        Services.RunService.Heartbeat:Wait()
    end

    if not inSky then
        return runAlongGroundToEgg(targetPos, nil, sessionId, targetUid)
    end

    local exitedSky = false
    local exitDeadline = os.clock() + 5.0

    while os.clock() < exitDeadline do
        if sessionId ~= State.currentStealSession or not isStealEnabled() then return false end
        local _, cRoot = getAliveRig()
        if not cRoot then return false end

        cRoot.CFrame = CFrame.new(exitPart.Position)
        cRoot.AssemblyLinearVelocity = Vector3.new(0, -0.5, 0)
        UniversalCompat.FireTouch(cRoot, exitPart)

        if cRoot.Position.Y < 10000 then
            exitedSky = true
            break
        end
        Services.RunService.Heartbeat:Wait()
    end

    if not exitedSky then return false end
    task.wait(0.12)

    local _, cRoot = getAliveRig()
    if not cRoot then return false end

    local remainingDist = (Vector3.new(targetPos.X, 0, targetPos.Z) - Vector3.new(cRoot.Position.X, 0, cRoot.Position.Z)).Magnitude
    if remainingDist <= CONFIG.FastStealDirectSnapRadius then
        setCollisions(false)
        local standPos = getStandingPosition(targetPos)
        cRoot.CFrame = CFrame.lookAt(standPos, targetPos)
        cRoot.AssemblyLinearVelocity = Vector3.zero
        task.wait(0.05)
        return true
    else
        return runAlongGroundToEgg(targetPos, nil, sessionId, targetUid)
    end
end

local function findMyPlot()
    if State.myPlot and State.myPlot.Parent and State.myTreadmill and State.myTreadmill.Parent then
        return State.myPlot
    end

    local myName = LocalPlayer.Name:lower()
    local myDisplayName = LocalPlayer.DisplayName:lower()
    local myUserId = LocalPlayer.UserId

    local plotsFolder = Services.Workspace:FindFirstChild("Plots")
    local candidates = plotsFolder and plotsFolder:GetChildren() or Services.Workspace:GetChildren()

    for _, plot in ipairs(candidates) do
        local ownerAttr = plot:GetAttribute("Owner") or plot:GetAttribute("OwnerUserId") or plot:GetAttribute("Player")
        if ownerAttr and (tostring(ownerAttr):lower() == myName or tonumber(ownerAttr) == myUserId) then
            State.myPlot = plot
            break
        end

        local sign = plot:FindFirstChild("PlotSign") or plot:FindFirstChild("Sign")
        if sign then
            for _, desc in ipairs(sign:GetDescendants()) do
                if desc:IsA("TextLabel") or desc:IsA("TextButton") then
                    local txt = desc.Text:lower()
                    if txt:find(myName, 1, true) or txt:find(myDisplayName, 1, true) then
                        State.myPlot = plot
                        break
                    end
                end
            end
        end
        if State.myPlot then break end
    end

    if State.myPlot then
        for _, desc in ipairs(State.myPlot:GetDescendants()) do
            if desc.Name:lower():find("treadmill") then
                if desc:IsA("BasePart") then
                    State.myTreadmill = desc
                    break
                elseif desc:IsA("Model") then
                    State.myTreadmill = desc.PrimaryPart or desc:FindFirstChildWhichIsA("BasePart")
                    if State.myTreadmill then break end
                end
            end
        end
        if not State.myTreadmill then
            for _, child in ipairs(State.myPlot:GetChildren()) do
                if child.Name:lower():find("treadmill") then
                    State.myTreadmill = child:IsA("BasePart") and child or (child:IsA("Model") and (child.PrimaryPart or child:FindFirstChildWhichIsA("BasePart")))
                    if State.myTreadmill then break end
                end
            end
        end
    end

    if not State.myTreadmill then
        for _, obj in ipairs(Services.Workspace:GetDescendants()) do
            if obj.Name == "TreadmillBottom" and obj:IsA("BasePart") then
                State.myTreadmill = obj
                break
            end
        end
    end
    return State.myPlot
end

local function instantGrabAtPosition(uid, targetPos, sessionId, isNest)
    if sessionId ~= State.currentStealSession or not isStealEnabled() then return false end
    local _, root = getAliveRig()
    if root and targetPos then
        local offsetY = isNest and CONFIG.AirGrabOffset or 1.0
        local safeY = (targetPos.Y or CONFIG.GroundAltitude) + offsetY
        root.CFrame = CFrame.new(Vector3.new(targetPos.X, safeY, targetPos.Z))
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end

    local targetPrompt = nil
    local eggModel = uid and (Services.Workspace:FindFirstChild(uid) or (Services.Workspace:FindFirstChild("AreaEggSlotsClient") and Services.Workspace.AreaEggSlotsClient:FindFirstChild(uid)))
    if eggModel then
        targetPrompt = eggModel:FindFirstChildWhichIsA("ProximityPrompt", true)
    end
    if not targetPrompt and targetPos then
        local parts = Services.Workspace:GetPartBoundsInRadius(targetPos, 12)
        for _, part in ipairs(parts) do
            local p = part:FindFirstChildWhichIsA("ProximityPrompt", true)
            if p and p.Enabled then
                targetPrompt = p
                break
            end
        end
    end

    local grabTimeout = os.clock() + 3.0
    local nextRemoteDispatch = 0

    while os.clock() < grabTimeout do
        if sessionId ~= State.currentStealSession or not isStealEnabled() then break end
        local _, cRoot = getAliveRig()
        if not cRoot then break end

        if uid and not isHoldingEgg() and not isEggStillValid(uid) then
            blacklistEgg(uid, 15)
            return false
        end

        if os.clock() >= nextRemoteDispatch then
            nextRemoteDispatch = os.clock() + 0.3
            if Remotes.AskFieldEggCarry and uid then
                task.spawn(function() pcall(function() Remotes.AskFieldEggCarry:InvokeServer({ Uid = uid }) end) end)
            end
            if typeof(EggState.CarryFieldEgg) == "function" and uid then
                pcall(function() EggState.CarryFieldEgg(uid) end)
            end
        end

        if targetPrompt and targetPrompt.Enabled then
            UniversalCompat.FireProximityPrompt(targetPrompt)
        end

        for _ = 1, 3 do
            Services.RunService.Heartbeat:Wait()
            if isHoldingEgg() then return true end
        end
    end
    return isHoldingEgg()
end

local function performGroundCheckpoint(targetEgg, currentX, laneZ, sessionId)
    if sessionId ~= State.currentStealSession or not isStealEnabled() then return false end
    local _, root, humanoid = getAliveRig()
    if not root then return false end
    if humanoid then humanoid.PlatformStand = false end

    local uid = (targetEgg and targetEgg.Uid) or (EggState and EggState.CarryUid)
    local checkY = CONFIG.GroundAltitude + 1.0

    pcall(function()
        root.CFrame = CFrame.new(currentX, checkY, laneZ) * CFrame.Angles(0, math.rad(90), 0)
        root.AssemblyLinearVelocity = Vector3.zero
        root.AssemblyAngularVelocity = Vector3.zero
    end)
    task.wait(0.06)

    dropHeldEggDirect()
    local dropWait = os.clock() + 0.6
    while os.clock() < dropWait and isHoldingEgg() do
        if sessionId ~= State.currentStealSession or not isStealEnabled() then return false end
        dropHeldEggDirect()
        task.wait(0.08)
    end
    task.wait(0.04)

    -- Regrab: try client EggState.CarryFieldEgg first, then physical grab
    if uid and EggState and typeof(EggState.CarryFieldEgg) == "function" then
        pcall(function() EggState.CarryFieldEgg(uid) end)
        task.wait(0.12)
    end

    if not isHoldingEgg() then
        local eggFloorPos = getPhysicalEggPosition(uid, Vector3.new(currentX, checkY, laneZ))
        local grabSuccess = false
        local retryTimeout = os.clock() + 3.0

        while os.clock() < retryTimeout do
            if sessionId ~= State.currentStealSession or not isStealEnabled() then return false end
            grabSuccess = instantGrabAtPosition(uid, eggFloorPos, sessionId, false)
            if grabSuccess and isHoldingEgg() then break end
            Services.RunService.Heartbeat:Wait()
        end
    end
    task.wait(0.04)
    return isHoldingEgg()
end

local function executeCheckpointedHopsHome(targetEgg, sessionId)
    local _, root, humanoid = getAliveRig()
    if not root then return false end

    local boundaryX = CONFIG.BoundaryCheckpointX
    local playerSpeed = getPlayerCurrentSpeed()
    local baseStep = CONFIG.HopDistance
    local stepSize = (playerSpeed < 100) and math.max(34, playerSpeed * 0.45) or math.min(baseStep, math.max(60, playerSpeed * 0.75))
    local interval = CONFIG.CheckpointInterval
    local safeTarget = CONFIG.BaseDropPosition

    local laneZ = math.clamp(root.Position.Z, -425, -300)
    local currentX = root.Position.X
    local lastCheckpointX = currentX

    StealUIManager:Lock()
    ShieldManager:MuteUGI()
    if humanoid then humanoid.PlatformStand = false end

    local groundY = CONFIG.GroundAltitude + 1.0

    -- Phase 1: Hop along lane towards boundary with periodic checkpoints
    while currentX - stepSize > boundaryX do
        if sessionId ~= State.currentStealSession or not isStealEnabled() or not isHoldingEgg() then
            ShieldManager:UnmuteUGI()
            StealUIManager:Unlock()
            cleanupFlightState()
            return false
        end

        local _, cRoot = getAliveRig()
        if not cRoot then 
            ShieldManager:UnmuteUGI()
            StealUIManager:Unlock()
            cleanupFlightState() 
            return false 
        end

        local nextX = currentX - stepSize
        local preHopTime = os.clock()

        pcall(function()
            cRoot.CFrame = CFrame.new(nextX, groundY, laneZ) * CFrame.Angles(0, math.rad(90), 0)
            cRoot.AssemblyLinearVelocity = Vector3.zero
        end)
        task.wait(CONFIG.HopGap)

        local _, postRoot = getAliveRig()
        local pulled = (State.lastServerRollbackTime > preHopTime) or (postRoot ~= nil and (postRoot.Position.X - nextX > 15))

        if pulled then
            CONFIG.HopGap = math.min(CONFIG.HopGapMax, CONFIG.HopGap + 0.02)
            stepSize = math.max(34, stepSize * 0.75)
            task.wait(0.1)
        else
            currentX = nextX
            CONFIG.HopGap = math.max(CONFIG.HopGapMin, CONFIG.HopGap - 0.005)
        end

        -- Intermediate ground checkpoint at configured interval
        if math.abs(lastCheckpointX - currentX) >= interval then
            lastCheckpointX = currentX
            local ok = performGroundCheckpoint(targetEgg, currentX, laneZ, sessionId)
            if not ok and not isHoldingEgg() then
                ShieldManager:UnmuteUGI()
                StealUIManager:Unlock()
                cleanupFlightState()
                return false
            end
        end
    end

    -- Phase 2: Mandatory Boundary Checkpoint right at boundaryX before crossing into base
    if isHoldingEgg() then
        currentX = boundaryX
        pcall(function()
            local _, bRoot = getAliveRig()
            if bRoot then
                bRoot.CFrame = CFrame.new(boundaryX, groundY, laneZ) * CFrame.Angles(0, math.rad(90), 0)
                bRoot.AssemblyLinearVelocity = Vector3.zero
            end
        end)
        task.wait(0.08)
        local boundaryOk = performGroundCheckpoint(targetEgg, boundaryX, laneZ, sessionId)
        if not boundaryOk and not isHoldingEgg() then
            ShieldManager:UnmuteUGI()
            StealUIManager:Unlock()
            cleanupFlightState()
            return false
        end
    end

    -- Phase 3: Safe Zone Corridor Micro-Hops into Base (progressive hops, NEVER jump 450 studs in one step!)
    local corridorStep = 45
    while currentX - corridorStep > safeTarget.X do
        if sessionId ~= State.currentStealSession or not isStealEnabled() or not isHoldingEgg() then
            break
        end

        local nextX = currentX - corridorStep
        local _, cRoot = getAliveRig()
        if cRoot then
            pcall(function()
                cRoot.CFrame = CFrame.new(nextX, groundY, safeTarget.Z) * CFrame.Angles(0, math.rad(90), 0)
                cRoot.AssemblyLinearVelocity = Vector3.zero
            end)
        end
        task.wait(CONFIG.HopGap)
        currentX = nextX
    end

    -- Phase 4: Delivery Location Drop & Settle Sequence
    local _, fRoot, fHum = getAliveRig()
    if fRoot then
        pcall(function()
            fRoot.CFrame = CFrame.new(safeTarget.X, CONFIG.GroundAltitude + 1.2, safeTarget.Z)
            fRoot.AssemblyLinearVelocity = Vector3.zero
        end)
    end
    task.wait(0.15)
    if fHum then fHum.PlatformStand = false end

    dropHeldEggDirect()
    task.wait(0.25)

    local dropVerifyTimeout = os.clock() + 2.0
    while os.clock() < dropVerifyTimeout and isHoldingEgg() do
        dropHeldEggDirect()
        task.wait(0.2)
    end

    StealUIManager:Unlock()
    ShieldManager:UnmuteUGI()
    cleanupFlightState()
    return not isHoldingEgg()
end

local function executeFastStealDelivery(targetEgg, sessionId)
    local _, root, hum = getAliveRig()
    if not root or not hum then return false end

    local uid = targetEgg.Uid
    local laneZ = math.clamp(root.Position.Z, -425, -300)
    local dropTargetPos = Vector3.new(CONFIG.SeparationLineX + CONFIG.FastStealLineDropOffset, CONFIG.GroundAltitude + 1.0, laneZ)
    local playerSpeed = getPlayerCurrentSpeed()

    setCollisions(false)
    ShieldManager:MuteUGI()

    local startTime = os.clock()
    local travelTimeout = math.max(12, ((root.Position.X - dropTargetPos.X) / playerSpeed) + 6)

    -- Phase 1: High speed glide along ground towards separation line
    while root.Position.X > dropTargetPos.X + 2.0 and (os.clock() - startTime) < travelTimeout do
        Services.RunService.Heartbeat:Wait()
        if sessionId ~= State.currentStealSession or not isStealEnabled() or not isHoldingEgg() then
            setCollisions(true)
            ShieldManager:UnmuteUGI()
            return false
        end

        local _, cRoot = getAliveRig()
        if not cRoot then break end
        cRoot.AssemblyLinearVelocity = Vector3.new(-playerSpeed, cRoot.AssemblyLinearVelocity.Y, 0)
        cRoot.CFrame = CFrame.new(cRoot.Position.X, CONFIG.GroundAltitude + 1.0, laneZ) * CFrame.Angles(0, math.rad(90), 0)
    end

    local _, cRoot = getAliveRig()
    if cRoot then
        cRoot.CFrame = CFrame.new(dropTargetPos) * CFrame.Angles(0, math.rad(90), 0)
        cRoot.AssemblyLinearVelocity = Vector3.zero
    end
    task.wait(0.1)

    -- Phase 2: Separation line drop and regrab checkpoint
    local checkpointOk = performGroundCheckpoint(targetEgg, dropTargetPos.X, laneZ, sessionId)
    if not checkpointOk and not isHoldingEgg() then
        setCollisions(true)
        ShieldManager:UnmuteUGI()
        return false
    end

    -- Phase 3: Fast micro-hops from separation line to base drop position
    local currentX = dropTargetPos.X
    local safeTarget = CONFIG.BaseDropPosition
    local corridorStep = 55

    while currentX - corridorStep > safeTarget.X do
        if sessionId ~= State.currentStealSession or not isStealEnabled() or not isHoldingEgg() then break end
        local nextX = currentX - corridorStep
        local _, hRoot = getAliveRig()
        if hRoot then
            pcall(function()
                hRoot.CFrame = CFrame.new(nextX, CONFIG.GroundAltitude + 1.0, safeTarget.Z) * CFrame.Angles(0, math.rad(90), 0)
                hRoot.AssemblyLinearVelocity = Vector3.zero
            end)
        end
        task.wait(CONFIG.HopGap)
        currentX = nextX
    end

    -- Phase 4: Final delivery drop at hopper
    local _, fRoot, fHum = getAliveRig()
    if fRoot then
        fRoot.CFrame = CFrame.new(safeTarget.X, CONFIG.GroundAltitude + 1.2, safeTarget.Z)
        fRoot.AssemblyLinearVelocity = Vector3.zero
    end
    task.wait(0.15)
    if fHum then fHum.PlatformStand = false end

    dropHeldEggDirect()
    task.wait(0.25)

    local dropVerifyTimeout = os.clock() + 2.0
    while os.clock() < dropVerifyTimeout and isHoldingEgg() do
        dropHeldEggDirect()
        task.wait(0.2)
    end

    setCollisions(true)
    ShieldManager:UnmuteUGI()
    return not isHoldingEgg()
end

local function executeGroundDeliveryHome(targetEgg, sessionId)
    return executeCheckpointedHopsHome(targetEgg, sessionId)
end

local function travelPlaneSegment(targetPos, stopDist, speed, timeout, sessionId, targetUid)
    local char, root = getAliveRig()
    if not root then return false end

    stopDist = stopDist or 4
    local startTime = os.clock()
    local reached = false
    local lastLiveCheck = 0

    State.activeFlightConnection = Services.RunService.Heartbeat:Connect(function()
        if sessionId ~= State.currentStealSession or not isStealEnabled() or isMapClosed() then
            if State.activeFlightConnection then State.activeFlightConnection:Disconnect() State.activeFlightConnection = nil end
            return
        end

        local _, cRoot = getAliveRig()
        if not cRoot then
            if State.activeFlightConnection then State.activeFlightConnection:Disconnect() State.activeFlightConnection = nil end
            return
        end

        if targetUid and (os.clock() - lastLiveCheck >= 0.25) then
            lastLiveCheck = os.clock()
            if not isEggStillValid(targetUid) then
                blacklistEgg(targetUid, 15)
                if State.activeFlightConnection then State.activeFlightConnection:Disconnect() State.activeFlightConnection = nil end
                return
            end
        end

        local currentPos = cRoot.Position
        local delta = Vector3.new(targetPos.X - currentPos.X, 0, targetPos.Z - currentPos.Z)
        local dist = delta.Magnitude

        if dist <= stopDist then
            reached = true
            cRoot.AssemblyLinearVelocity = Vector3.zero
            if State.activeFlightConnection then State.activeFlightConnection:Disconnect() State.activeFlightConnection = nil end
            return
        end

        if (os.clock() - startTime) > timeout then
            cRoot.AssemblyLinearVelocity = Vector3.zero
            if State.activeFlightConnection then State.activeFlightConnection:Disconnect() State.activeFlightConnection = nil end
            return
        end

        local moveDir = delta.Unit
        cRoot.AssemblyLinearVelocity = Vector3.new(moveDir.X * speed, 0, moveDir.Z * speed)
        cRoot.CFrame = CFrame.new(currentPos.X, CONFIG.FlightAltitude, currentPos.Z) * CFrame.lookAt(Vector3.zero, moveDir)
    end)

    while State.activeFlightConnection and State.activeFlightConnection.Connected do
        Services.RunService.Heartbeat:Wait()
    end

    return reached and (sessionId == State.currentStealSession) and isStealEnabled() and not isMapClosed()
end

local function flyOutboundElevated(targetPosition, stopDistance, sessionId, targetUid)
    local char, root, humanoid = getAliveRig()
    if not root or not humanoid then return false end

    StealUIManager:SnapshotNormalHUD()
    stopDistance = stopDistance or 4

    local playerSpeed = humanoid.WalkSpeed
    if not playerSpeed or playerSpeed <= 0 then playerSpeed = 16 end

    table.clear(State.activeCollisionsDisabled)
    for _, part in ipairs(char:GetDescendants()) do
        if part:IsA("BasePart") and part.CanCollide then
            State.activeCollisionsDisabled[part] = true
            part.CanCollide = false
        end
    end

    humanoid.PlatformStand = true

    local function snapAltitude(targetY)
        local _, cRoot = getAliveRig()
        if cRoot then
            pcall(function()
                cRoot.CFrame = CFrame.new(cRoot.Position.X, targetY, cRoot.Position.Z) * cRoot.CFrame.Rotation
                cRoot.AssemblyLinearVelocity = Vector3.zero
            end)
            task.wait(0.03)
        end
    end
    snapAltitude(CONFIG.FlightAltitude)

    local currentPosInit = root.Position
    if currentPosInit.X < CONFIG.BoundaryCheckpointX then
        local centerDeliveryPos = Vector3.new(CONFIG.BaseDropPosition.X, CONFIG.FlightAltitude, CONFIG.BaseDropPosition.Z)
        local mouthPos = Vector3.new(CONFIG.BoundaryCheckpointX, CONFIG.FlightAltitude, CONFIG.BaseDropPosition.Z)

        local lateralDist = math.abs(currentPosInit.Z - CONFIG.BaseDropPosition.Z)
        if lateralDist > 12 or currentPosInit.X < CONFIG.BaseDropPosition.X then
            local ok = travelPlaneSegment(centerDeliveryPos, 4, playerSpeed, 20, sessionId, targetUid)
            if not ok then cleanupFlightState() return false end
        end

        local ok2 = travelPlaneSegment(mouthPos, 4, playerSpeed, 20, sessionId, targetUid)
        if not ok2 then cleanupFlightState() return false end
    end

    local finalDelta = Vector3.new(targetPosition.X - root.Position.X, 0, targetPosition.Z - root.Position.Z)
    local dynamicTimeout = math.max(30, (finalDelta.Magnitude / playerSpeed) + 20)

    local reached = travelPlaneSegment(targetPosition, stopDistance, playerSpeed, dynamicTimeout, sessionId, targetUid)
    if reached and sessionId == State.currentStealSession and isStealEnabled() and not isMapClosed() then
        snapAltitude((targetPosition.Y or CONFIG.GroundAltitude) + CONFIG.AirGrabOffset)
    end

    cleanupFlightState()
    return reached and (sessionId == State.currentStealSession) and isStealEnabled() and not isMapClosed()
end

getBestEgg = function()
    if not EggState or not EggState.ReadFieldEggs or isMapClosed() then return nil end
    local data = nil
    pcall(function() data = EggState.ReadFieldEggs() end)
    if not data or not data.Records then return nil end

    -- Steal Panel Target Handling (Normal Dimension only; never clear while actively stealing or holding an egg!)
    if isNormalStealPanelTarget() then
        for uid, record in pairs(data.Records) do
            if uid == State.targetedSpecificUid or record.Uid == State.targetedSpecificUid then
                record.Uid = record.Uid or uid
                if State.isStealingActive or isHoldingEgg() or (record.State ~= "Claimed" and record.State ~= "Carried") then
                    return record
                end
            end
        end

        local directFloorPos = getPhysicalEggPosition(State.targetedSpecificUid, nil)
        if directFloorPos and (State.isStealingActive or isHoldingEgg() or isEggStillValid(State.targetedSpecificUid)) then
            return {
                Uid = State.targetedSpecificUid,
                BottomCFrame = CFrame.new(directFloorPos),
                AssetCategory = "TargetedEgg"
            }
        end

        if not State.isStealingActive and not isHoldingEgg() then
            if State.activeStealButtons[State.targetedSpecificUid] then
                State.activeStealButtons[State.targetedSpecificUid].BackgroundColor3 = activeTheme and activeTheme.Accent or Color3.fromRGB(92, 170, 255)
                State.activeStealButtons[State.targetedSpecificUid].Text = "Steal"
            end
            State.targetedSpecificUid = nil
            State.targetedSpecificIsHalloween = false
        end
    end

    local minScore = getMinRequiredScore()
    local bestEgg = nil
    local highestScore = -math.huge
        local normalStealEnabled = getgenv().config.autoFarm == true

    for keyUid, record in pairs(data.Records) do
        local uid = record.Uid or keyUid
        record.Uid = uid
        if uid and not isBlacklisted(uid) then
            if record.State == "Slot" or record.State == "Dropped" or record.State == nil then
                local posX = nil
                local cf = record.BottomCFrame or record.BoundsCFrame or record.CFrame
                if typeof(cf) == "CFrame" then posX = cf.Position.X
                elseif typeof(cf) == "Vector3" then posX = cf.X
                elseif typeof(record.Position) == "Vector3" then posX = record.Position.X end

                if not posX or posX >= 560 then
                    local rawName = record.AssetCategory or record.Category or record.Name or "Unknown"
                    
                    if isLabNeeded then
                        local scale = tonumber(record.AssetScale) or 1
                        local mutationBonus = (record.Mutations and #record.Mutations > 0) and 2.5 or 1
                        local score = 100000000 + ((scale ^ 1.85) * mutationBonus)

                        if score > highestScore then
                            highestScore = score
                            bestEgg = record
                        end
                    elseif normalStealEnabled then
                        local areaIdStr = tostring(record.AreaId or "")
                        if matchesTargetArea(areaIdStr) then
                            local _, rank = MasterRegistry:Lookup(rawName)
                            if rank >= minScore then
                                local scale = tonumber(record.AssetScale) or 1
                                local mutationBonus = (record.Mutations and #record.Mutations > 0) and 2.5 or 1
                                local score = (rank * 1000) + ((scale ^ 1.85) * mutationBonus)

                                if score > highestScore then
                                    highestScore = score
                                    bestEgg = record
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return bestEgg
end

-- ==============================================================================
-- [ WORKER SCHEDULER TASK REGISTRATIONS & DIMENSION SUPERVISOR ]
-- ==============================================================================

WorkerScheduler:Register("CandyCaneFarm", 0.05, function()
    if not getgenv().config.autoCandyCane or isHalloweenMapClosed() then
        PriorityManager:Release("CandyCane")
        return
    end
    if HalloweenBossManager and HalloweenBossManager:IsLocked() then return end
    if not PriorityManager:CanRun("CandyCane") then return end

    if not HalloweenPortalManager.IsInHalloweenDimension() then
        if PriorityManager:Acquire("CandyCane", 10.0) then
            HalloweenPortalManager.EnterDimension(5.0)
            PriorityManager:Release("CandyCane")
        end
        return
    end

    if HalloweenCombatManager:GetClosestMonster() == nil then
        PriorityManager:Release("CandyCane")
        return
    end

    if PriorityManager:Acquire("CandyCane", 10.0) then
        pcall(function() HalloweenCombatManager:Process() end)
        PriorityManager:Release("CandyCane")
    end
end)

WorkerScheduler:Register("HalloweenPumpkin", 0.05, function()
    if not getgenv().config.autoPumpkin or isHalloweenMapClosed() then
        PriorityManager:Release("Pumpkin")
        return
    end
    if HalloweenBossManager and HalloweenBossManager:IsLocked() then return end
    if not PriorityManager:CanRun("Pumpkin") then return end

    if not HalloweenPortalManager.IsInHalloweenDimension() then
        if PriorityManager:Acquire("Pumpkin", 10.0) then
            HalloweenPortalManager.EnterDimension(5.0)
            PriorityManager:Release("Pumpkin")
        end
        return
    end

    if not (HalloweenPumpkinManager and HalloweenPumpkinManager:IsCarrying()) and HalloweenPumpkinManager:GetTarget() == nil then
        PriorityManager:Release("Pumpkin")
        return
    end

    if PriorityManager:Acquire("Pumpkin", 15.0) then
        pcall(function() HalloweenPumpkinManager:Process() end)
        PriorityManager:Release("Pumpkin")
    end
end)

WorkerScheduler:Register("HalloweenBoss", 0.05, function()
    if not getgenv().config.autoBossEvent then
        PriorityManager:Release("Boss")
        return
    end
    if not PriorityManager:CanRun("Boss") then return end

    if not HalloweenPortalManager.IsInHalloweenDimension() then
        if PriorityManager:Acquire("Boss", 10.0) then
            HalloweenPortalManager.EnterDimension(5.0)
            PriorityManager:Release("Boss")
        end
        return
    end

    if PriorityManager:Acquire("Boss", 30.0) then
        HalloweenBossManager:Process()
        PriorityManager:Release("Boss")
    end
end)

WorkerScheduler:Register("GhostDog", 0.1, function()
    if not getgenv().config.autoGhostDog or isHalloweenMapClosed() then return end
    if not PriorityManager:CanRun("GhostDog") then return end
    if not GhostDogManager:HasWork() then return end

    if not HalloweenPortalManager.IsInHalloweenDimension() then
        if PriorityManager:Acquire("GhostDog", 10.0) then
            HalloweenPortalManager.EnterDimension(5.0)
            PriorityManager:Release("GhostDog")
        end
        return
    end

    pcall(function() GhostDogManager:Process() end)
end)

WorkerScheduler:Register("HalloweenFishing", 0.1, function()
    if not getgenv().config.autoFishing or isHalloweenMapClosed() then return end
    if not PriorityManager:CanRun("Fishing") then return end
    if not HalloweenFishingManager:HasWork() then return end

    if not HalloweenPortalManager.IsInHalloweenDimension() then
        if PriorityManager:Acquire("Fishing", 10.0) then
            HalloweenPortalManager.EnterDimension(5.0)
            PriorityManager:Release("Fishing")
        end
        return
    end

    pcall(function() HalloweenFishingManager:Process() end)
end)

WorkerScheduler:Register("AutoBuyHalloweenEgg", 1.5, function()
    if not getgenv().config.autoBuyHalloweenEgg then return end
    if not HalloweenPortalManager.IsInHalloweenDimension() then return end
    if not PriorityManager:CanRun("BuyHalloweenEgg") then return end

    if os.clock() >= (State.halloweenEggBuyCooldown or 0) then
        State.halloweenEggBuyCooldown = os.clock() + 3.0
        pcall(function() invokeRemote("RF/HalloweenDimension/AskBuyEgg") end)
    end
end)

WorkerScheduler:Register("AutoUpgrades", 6.0, function()
    if not PriorityManager:CanRun("Upgrades") then return end
    if getgenv().config.autoUpgradeTreadmill then tryUpgradeTreadmill() end
    if getgenv().config.autoUpgradeBase then tryUpgradeBase() end
end)

WorkerScheduler:Register("EventsCombat", 0.35, function()
    if State.isStealingActive or isHoldingEgg() then return end
    if HalloweenPortalManager.IsInHalloweenDimension() then return end
    if not PriorityManager:CanRun("Bloom") then return end

    if PriorityManager:Acquire("Bloom", 10.0) then
        BloomManager:ProcessButterflies(State.isStealingActive, false)
        BloomManager:ProcessWisps(State.isStealingActive, false)
        BloomManager:ProcessTradeAndCraft()
        PriorityManager:Release("Bloom")
    end
end)

WorkerScheduler:Register("StealAndTreadmill", 0.25, function()
    local char = LocalPlayer.Character
    if not char then return end

    local inHalloween = HalloweenPortalManager.IsInHalloweenDimension()
    local topTask = PriorityManager:GetTopWantedTask()

    -- Auto Boss owns its own portal/arena navigation: never redirect it (KNOWLEDGE.md 6.5.1)
    if topTask == "Auto Boss" then
        return
    end

    -- Dimension Supervisor: NEVER switch dimensions while character lock is held!
    if PriorityManager:IsLocked() then
        return
    end

    if topTask then
        local targetDim = PriorityManager:GetTaskDimension(topTask)
        if targetDim == "Halloween" and not inHalloween then
            hopOffTreadmill()
            HalloweenPortalManager.EnterDimension(5.0)
            return
        end
    end

    -- If player is inside Halloween dimension, main world Steal & Treadmill must NOT run!
    if inHalloween then
        return
    end

    -- 1. Auto Steal & Steal Panel Execution
    if isStealEnabled() and not State.isStealingActive and not isMapClosed() and PriorityManager:CanRun("Steal") then
        local currentTargetEgg = getBestEgg()
        if currentTargetEgg then
            local targetUid = currentTargetEgg.Uid
            if not isEggStillValid(targetUid) then
                blacklistEgg(targetUid, 15)
                if State.targetedSpecificUid == targetUid then
                    if State.activeStealButtons[targetUid] then
                        State.activeStealButtons[targetUid].BackgroundColor3 = activeTheme and activeTheme.Accent or Color3.fromRGB(92, 170, 255)
                        State.activeStealButtons[targetUid].Text = "Steal"
                    end
                    State.targetedSpecificUid = nil
                end
                return
            end

            PriorityManager:Claim("Steal")
            State.isStealingActive = true
            State.treadmillFailCount = 0
            State.currentStealSession = State.currentStealSession + 1
            local session = State.currentStealSession

            hopOffTreadmill()
            ShieldManager:ApplyHumanoidSwap(char)
            task.wait(0.08)

            local targetCFrame = currentTargetEgg.BottomCFrame or currentTargetEgg.BoundsCFrame or currentTargetEgg.CFrame
            local eggTargetPos = nil
            if typeof(targetCFrame) == "CFrame" then eggTargetPos = targetCFrame.Position
            elseif typeof(targetCFrame) == "Vector3" then eggTargetPos = targetCFrame
            elseif typeof(currentTargetEgg.Position) == "Vector3" then eggTargetPos = currentTargetEgg.Position end

            if not eggTargetPos and targetUid then
                eggTargetPos = getPhysicalEggPosition(targetUid, nil)
            end

            local stealSuccess = false
            if eggTargetPos then
                local areaId = currentTargetEgg.AreaId
                local canUseFastSteal = (getgenv().config.fastSteal == true) and isFastStealArea(areaId)

                if canUseFastSteal then
                    local arrived = executeFastStealOutbound(eggTargetPos, session, targetUid)
                    if not arrived and session == State.currentStealSession and isStealEnabled() and isEggStillValid(targetUid) then
                        arrived = runAlongGroundToEgg(eggTargetPos, nil, session, targetUid)
                    end

                    if arrived and session == State.currentStealSession and isStealEnabled() then
                        task.wait(0.04)
                        local grabbed = instantGrabAtPosition(targetUid, eggTargetPos, session, false)

                        if (grabbed or isHoldingEgg()) and session == State.currentStealSession and isStealEnabled() then
                            stealSuccess = executeFastStealDelivery(currentTargetEgg, session)
                            if not stealSuccess and isHoldingEgg() and session == State.currentStealSession and isStealEnabled() then
                                stealSuccess = executeCheckpointedHopsHome(currentTargetEgg, session)
                            end
                        end
                    end
                else
                    local arrived = runAlongGroundToEgg(eggTargetPos, nil, session, targetUid)
                    if arrived and session == State.currentStealSession and isStealEnabled() then
                        task.wait(0.04)
                        local grabbed = instantGrabAtPosition(targetUid, eggTargetPos, session, false)
                        if (grabbed or isHoldingEgg()) and session == State.currentStealSession and isStealEnabled() then
                            stealSuccess = executeCheckpointedHopsHome(currentTargetEgg, session)
                        end
                    end
                end
            end

            if session == State.currentStealSession then
                State.isStealingActive = false
                ShieldManager:UndoSwap()
                cleanupFlightState()
                PriorityManager:Release("Steal")

                if State.targetedSpecificUid == targetUid and (stealSuccess or not isEggStillValid(targetUid)) then
                    if State.activeStealButtons[targetUid] then
                        State.activeStealButtons[targetUid].BackgroundColor3 = activeTheme and activeTheme.Accent or Color3.fromRGB(92, 170, 255)
                        State.activeStealButtons[targetUid].Text = "Steal"
                    end
                    State.targetedSpecificUid = nil
                end
            else
                State.isStealingActive = false
                ShieldManager:UndoSwap()
                cleanupFlightState()
                if PriorityManager then
                    PriorityManager:Release("Steal")
                    PriorityManager:Release("Auto Steal")
                end
            end
        end
    end

    -- 2. Treadmill Idle Execution
    local isStealBusy = State.isStealingActive or isHoldingEgg()
    local canTreadmill = getgenv().config.autoTreadmill and not isStealBusy and PriorityManager:CanRun("Treadmill")

    if canTreadmill and getAliveRig() then
        ShieldManager:UndoSwap()
        findMyPlot()
        local _, cRoot, cHum = getAliveRig()
        if cRoot and cHum then
            if State.myTreadmill then
                local tPos = State.myTreadmill.Position + Vector3.new(0, 3, 0)
                local dist = (cRoot.Position - tPos).Magnitude
                if dist > 4 then
                    cHum.PlatformStand = false
                    cHum.Sit = false
                    local speed = cHum.WalkSpeed
                    if not speed or speed <= 0 then speed = 16 end
                    local travelDuration = math.clamp(dist / math.max(speed, 16), 0.3, 3)
                    local tw = Services.TweenService:Create(cRoot, TweenInfo.new(travelDuration, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
                        CFrame = CFrame.new(tPos) * cRoot.CFrame.Rotation
                    })
                    tw:Play()
                    tw.Completed:Wait()
                end

                local _, postRoot, postHum = getAliveRig()
                if postRoot and not postRoot.Anchored then
                    if postHum then
                        postHum.PlatformStand = false
                        postHum.Sit = false
                    end
                    if Remotes.AskWearStill and not isStealBusy and PriorityManager:CanRun("Treadmill") then
                        pcall(function() Remotes.AskWearStill:InvokeServer() end)
                    end
                    task.wait(0.35)
                    local _, verifyRoot = getAliveRig()
                    if verifyRoot and not verifyRoot.Anchored then
                        State.treadmillFailCount = State.treadmillFailCount + 1
                        if State.treadmillFailCount >= 8 then
                            resetFlaggedCharacter()
                        elseif State.treadmillFailCount == 4 and Remotes.AskDoff then
                            pcall(function() Remotes.AskDoff:InvokeServer() end)
                        end
                    else
                        State.treadmillFailCount = 0
                    end
                else
                    State.treadmillFailCount = 0
                end
            else
                State.treadmillFailCount = 0
            end
        end
    end
end)

WorkerScheduler:Start()


-- ==============================================================================
-- [ GUI INITIALIZATION & CONTROLS BINDINGS VIA GUILIB ]
-- ==============================================================================
local SyntaxisLib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tenobarillas-ship-it/GUILib/main/SyntaxisLib.lua"))()

Window = SyntaxisLib:CreateWindow({
    Title = "Syntaxis",
    GuiName = "SyntaxHubGUI",
    Theme = currentSettings.Theme or "Sapphire",
    Transparency = currentSettings.Transparency or 0,
    State = State,
    OnThemeChanged = function(themeName, themePalette)
        activeTheme = themePalette
        currentSettings.Theme = themeName
        saveStuff()
    end
})

activeTheme = Window:GetActiveTheme()

-- ==============================================================================
-- [ TAB 1: FARM CONTROLS & EVENT CATEGORIES ]
-- ==============================================================================
local FarmTab = Window:CreateTab("Farm", "Farm")

-- Automation Steal Category
local stealCategory = FarmTab:CreateCategory("Automation Steal", false, 1)

stealCategory:CreateToggle("Auto Steal", "Automatically steal eggs from areas", currentSettings.AutoFarm, function(state)
    getgenv().config.autoFarm = state
    currentSettings.AutoFarm = state
    saveStuff()
    table.clear(State.blacklistedEggs)
    if not state then
        abortStealRoutine()
    end
end)

stealCategory:CreateToggle("Fast Steal", "Only works on Titan temple and above areas.", currentSettings.FastSteal, function(state)
    getgenv().config.fastSteal = state
    currentSettings.FastSteal = state
    saveStuff()
    if state then
        Window:ShowWarningModal("Fast Steal Warning", "Fast Steal is unreliable. Do not use if you are lagging or AFK farming.")
    else
        if State.isStealingActive and not isHoldingEgg() then
            abortStealRoutine()
        end
    end
end)

local areaList = {
    "All", "Forest", "Lake", "Desert", "Jungle", "Snow", 
    "Volcano", "Abyss Ocean", "Prehistoric", "Cosmic", 
    "Cherry Blossom", "Titan Temple", "Light Dark", "Enchanted Forest"
}

stealCategory:CreateMultiDropdown("Target Areas", "Select one or multiple areas (empty = all)", areaList, currentSettings.TargetAreas, function(selectedMap)
    getgenv().config.targetAreas = selectedMap
    currentSettings.TargetAreas = selectedMap
    saveStuff()
    table.clear(State.blacklistedEggs)
end)

local rarityList = {
    "All", "1 - Common", "2 - Uncommon", "3 - Rare", "4 - Epic",
    "5 - Legendary", "6 - Mythic", "7 - Cosmic", "8 - Secret",
    "9 - Eternal", "10 - Divine"
}

stealCategory:CreateDropdown("Min Rarity", "Only steal eggs with rarity >= this", rarityList, currentSettings.MinRarity, function(selected)
    getgenv().config.minRarity = selected
    currentSettings.MinRarity = selected
    saveStuff()
    table.clear(State.blacklistedEggs)
end)

-- Halloween Event Category
local halloweenCategory = FarmTab:CreateCategory("Halloween Event 2026", false, 2)

halloweenCategory:CreateToggle("Auto Steal Halloween Eggs", "Steal seasonal eggs in Halloween Dimension", currentSettings.AutoHalloweenSteal, function(state)
    getgenv().InstantStealHalloween = state
    getgenv().config.autoHalloweenSteal = state
    currentSettings.AutoHalloweenSteal = state
    saveStuff()
    if not state and HalloweenStealManager and HalloweenStealManager.Abort then
        HalloweenStealManager.Abort()
    end
end)

local halloweenAreaList = {
    "All", "Graveyard", "Haunted Swamps", "Abandoned Manor"
}

halloweenCategory:CreateMultiDropdown("Target Areas", "Select Halloween areas to steal from", halloweenAreaList, currentSettings.HalloweenTargetAreas, function(selectedMap)
    getgenv().config.halloweenTargetAreas = selectedMap
    currentSettings.HalloweenTargetAreas = selectedMap
    saveStuff()
end)

halloweenCategory:CreateDropdown("Min Rarity", "Only steal Halloween eggs with rarity >= this", rarityList, currentSettings.HalloweenMinRarity, function(selected)
    getgenv().config.halloweenMinRarity = selected
    currentSettings.HalloweenMinRarity = selected
    saveStuff()
end)

halloweenCategory:CreateToggle("Candy Cane Monster Farm", "Auto weapon swap combat in dimension", currentSettings.AutoCandyCane, function(state)
    getgenv().config.autoCandyCane = state
    currentSettings.AutoCandyCane = state
    saveStuff()
    if not state and HalloweenCombatManager and HalloweenCombatManager.Abort then
        HalloweenCombatManager:Abort()
    end
end)

halloweenCategory:CreateToggle("Auto Pumpkin", "Auto catch runaway pumpkins & deposit at Altar", currentSettings.AutoPumpkin, function(state)
    getgenv().config.autoPumpkin = state
    getgenv().AutoCatchPumpkins = state
    currentSettings.AutoPumpkin = state
    saveStuff()
    if not state and HalloweenPumpkinManager and HalloweenPumpkinManager.Abort then
        HalloweenPumpkinManager:Abort()
    end
end)

halloweenCategory:CreateToggle("Auto Boss", "Auto enter BossPortal, fight the Pumpkin King & fire cannons", currentSettings.AutoBossEvent, function(state)
    getgenv().config.autoBossEvent = state
    getgenv().AutoBossEvent = state
    currentSettings.AutoBossEvent = state
    saveStuff()
    if state then
        if HalloweenBossManager and HalloweenBossManager.SetState then
            HalloweenBossManager:SetState("WAITING")
        end
        if getgenv().BossAutomationState then
            getgenv().BossAutomationState.KingEncountered = false
            getgenv().BossAutomationState.IsBusy = false
        end
    elseif HalloweenBossManager and HalloweenBossManager.Abort then
        HalloweenBossManager:Abort()
    end
end)

halloweenCategory:CreateToggle("Auto Ghost Dog Quest", "Auto full 5-stage quest & ticket unlock", currentSettings.AutoGhostDog, function(state)
    getgenv().config.autoGhostDog = state
    currentSettings.AutoGhostDog = state
    saveStuff()
    if not state and GhostDogManager and GhostDogManager.Abort then
        GhostDogManager:Abort()
    end
end)

halloweenCategory:CreateToggle("Auto Fishing", "Auto dock fishing with charge luck & reel", currentSettings.AutoFishing, function(state)
    getgenv().config.autoFishing = state
    currentSettings.AutoFishing = state
    saveStuff()
    if not state and HalloweenFishingManager and HalloweenFishingManager.Abort then
        HalloweenFishingManager:Abort()
    end
end)

halloweenCategory:CreateDropdown("Cast Luck", "Desired cast timing precision", {"x1.5 Perfect", "x1.2 Good", "x1.0 Normal"}, currentSettings.CastLuck or "x1.5 Perfect", function(selected)
    getgenv().config.castLuck = selected
    currentSettings.CastLuck = selected
    saveStuff()
end)

halloweenCategory:CreateToggle("Auto Buy Halloween Egg", "Auto buy seasonal eggs in Halloween Dimension", currentSettings.AutoBuyHalloweenEgg, function(state)
    getgenv().config.autoBuyHalloweenEgg = state
    currentSettings.AutoBuyHalloweenEgg = state
    saveStuff()
end)

-- Automation Treadmill Category
local treadmillCategory = FarmTab:CreateCategory("Automation Treadmill", false, 3)

treadmillCategory:CreateToggle("Auto Treadmill", "Gain treadmill speed when idle", currentSettings.AutoTreadmill, function(state)
    getgenv().config.autoTreadmill = state
    currentSettings.AutoTreadmill = state
    State.treadmillFailCount = 0
    saveStuff()
    if not state then hopOffTreadmill() end
end)

-- Enchanted / Bloom Event Category
local bloomCategory = FarmTab:CreateCategory("Enchanted / Bloom Event", false, 4)

bloomCategory:CreateToggle("Auto Bloom Event", "Auto catch butterflies during Bloom Event", currentSettings.AutoCatchButterfly, function(state)
    getgenv().config.autoCatchButterfly = state
    currentSettings.AutoCatchButterfly = state
    saveStuff()
    if not state then BloomManager.IsBusy = false end
end)

bloomCategory:CreateToggle("Auto Wisps Quest", "Auto advance & submit Wisp quest eggs", currentSettings.AutoWispQuest, function(state)
    getgenv().config.autoWispQuest = state
    currentSettings.AutoWispQuest = state
    saveStuff()
    if not state then BloomManager.IsBusy = false end
end)

bloomCategory:CreateToggle("Auto Trade Up", "Trade butterflies into higher tiers at machine", currentSettings.AutoTradeUp, function(state)
    getgenv().config.autoTradeUp = state
    currentSettings.AutoTradeUp = state
    saveStuff()
end)

bloomCategory:CreateToggle("Auto Craft Essence", "Craft Enchanted Essence at Mutation Shrine", currentSettings.AutoCraftEssence, function(state)
    getgenv().config.autoCraftEssence = state
    currentSettings.AutoCraftEssence = state
    saveStuff()
end)

bloomCategory:CreateSlider("Butterfly Speed", "Travel speed while catching butterflies", 100, 600, currentSettings.ButterflySpeed or 320, 10, function(val)
    getgenv().config.butterflySpeed = val
    currentSettings.ButterflySpeed = val
    saveStuff()
end)

-- Automation Upgrades Category
local upgradesCategory = FarmTab:CreateCategory("Automation Upgrades", false, 5)

upgradesCategory:CreateToggle("Auto Upgrade Treadmill", "Auto buy next tier treadmill", currentSettings.AutoUpgradeTreadmill, function(state)
    getgenv().config.autoUpgradeTreadmill = state
    currentSettings.AutoUpgradeTreadmill = state
    saveStuff()
end)

upgradesCategory:CreateToggle("Auto Upgrade Base", "Auto buy homestead base expansion", currentSettings.AutoUpgradeBase, function(state)
    getgenv().config.autoUpgradeBase = state
    currentSettings.AutoUpgradeBase = state
    saveStuff()
end)

-- ==============================================================================
-- [ TAB 2: TASK PRIORITY MANAGER ]
-- ==============================================================================
local PriorityTab = Window:CreatePriorityTab("Priority", "Task Priority", {
    GetList = function()
        return PriorityManager.List
    end,
    OnMoveUp = function(index)
        PriorityManager:MoveUp(index, function(list)
            currentSettings.TaskPriorities = list
            saveStuff()
        end)
    end,
    OnMoveDown = function(index)
        PriorityManager:MoveDown(index, function(list)
            currentSettings.TaskPriorities = list
            saveStuff()
        end)
    end
})

-- ==============================================================================
-- [ TAB 3: STEAL SCANNER PANEL ]
-- ==============================================================================
local function getStealPanelEggItems()
    local data = EggState and typeof(EggState.ReadFieldEggs) == "function" and EggState.ReadFieldEggs()
    local records = (data and data.Records) or {}

    if State.targetedSpecificUid and not isHoldingEgg() and not State.isStealingActive then
        local found = false
        for uid, record in pairs(records) do
            if uid == State.targetedSpecificUid or record.Uid == State.targetedSpecificUid then
                found = true
                break
            end
        end
        if not found then
            State.targetedSpecificUid = nil
        end
    end

    local eggItems = {}

    -- Normal Dimension Eggs (Halloween eggs remain hidden from steal panel per user requirement)
    for keyUid, record in pairs(records) do
        local uid = record.Uid or keyUid
        record.Uid = uid
        if not isBlacklisted(uid) and (record.State == "Slot" or record.State == "Dropped" or record.State == nil) then
            local rawName = record.AssetCategory or record.Category or record.Name or "Unknown"
            local rarityName, rarityRank = MasterRegistry:Lookup(rawName)
            local pData = MasterRegistry.PetDatabase[rawName] or {}

            local scale = tonumber(record.AssetScale) or 1
            local factor = scale > 5 and ((scale / 5) ^ 1.2 * 19.637875755794113) or (scale ^ 1.85)
            local mutationBonus = (record.Mutations and #record.Mutations > 0) and 2.5 or 1
            local earningRate = tonumber(pData.EarningRate) or 0
            local valuePerSec = earningRate * factor * mutationBonus

            local iconId = tostring(pData.Icon or "")
            if iconId ~= "" and tonumber(iconId) then iconId = "rbxassetid://" .. iconId end

            table.insert(eggItems, {
                Uid = uid,
                Name = rawName,
                Area = tostring(record.AreaId or "Unknown"),
                Scale = scale,
                Rarity = rarityName,
                Rank = rarityRank,
                Value = valuePerSec,
                Icon = iconId,
                Record = record
            })
        end
    end

    return eggItems
end

local StealPanelTab, renderStealPanel = Window:CreateStealPanelTab("Steal Panel", "Steal Panel", {
    FormatValue = formatMoneyPerSec,
    GetItems = getStealPanelEggItems,
    OnSelectItem = function(item, actBtn)
        local curTheme = Window:GetActiveTheme()
        if State.targetedSpecificUid == item.Uid then
            State.targetedSpecificUid = nil
            abortStealRoutine()
            actBtn.BackgroundColor3 = curTheme.Accent
            actBtn.Text = "Steal"
        else
            if State.isStealingActive then
                abortStealRoutine()
            end
            State.targetedSpecificUid = item.Uid
            State.blacklistedEggs[item.Uid] = nil
            for u, b in pairs(State.activeStealButtons) do
                if u == item.Uid then
                    b.BackgroundColor3 = Color3.fromRGB(240, 65, 60)
                    b.Text = "Stop Steal"
                else
                    b.BackgroundColor3 = curTheme.Accent
                    b.Text = "Steal"
                end
            end
        end
    end
})

-- ==============================================================================
-- [ TAB 4: SETTINGS & THEME CUSTOMIZATION ]
-- ==============================================================================
local SettingsTab = Window:CreateSettingsTab("Settings", "Settings", {
    OnThemeSelected = function(themeName)
        currentSettings.Theme = themeName
        saveStuff()
    end,
    OnTransparencyChanged = function(val)
        currentSettings.Transparency = val
        saveStuff()
    end
})

-- Background Refresh for Steal Panel (every 2s while panel is active)
task.spawn(function()
    while true do
        task.wait(2)
        if StealPanelTab.Page and StealPanelTab.Page.Visible and State.isOpn and not State.isStealingActive and renderStealPanel then
            pcall(renderStealPanel)
        end
    end
end)

-- Initialize Window
Window:Initialize()

-- Show Community Discord Popup upon initial launch
task.defer(function()
    task.wait(0.5)
    Window:ShowDiscordModal()
end)
