-- mm2
--
-- how the file is organized:
--   - header, single-instance lifecycle cleanup, and state storage
--   - color and ui math utilities
--   - mduilib initialization and tab adapter wrappers
--   - core game trackers (roles, weapons, round flow)
--   - combat algorithms (silent aim, prediction, kill aura, fling)
--   - movement and autofarm systems (coin paths, anti-void, flight)
--   - cosmetics and visual pipelines (ground aura, wings, china hat, trails)
--   - inventory and trading value calculation overlays
--   - tab and ui components construction
--   - main loop hooks, input event bindings, and configuration autoload
--
-- where to add a new feature:
--   - declare default state properties in the state table near top
--   - implement runtime logic in the matching functional domain
--   - expose controls via adapter methods inside _buildScriptUI()
--   - add instance reset and connection teardown inside doCleanup()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local ContentProvider = game:GetService("ContentProvider")
local LightingService = game:GetService("Lighting")
local TweenService   = game:GetService("TweenService")
local Debris         = game:GetService("Debris")
math.randomseed(math.random(1000, 9999) + tick())
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local CurrentCamera = Workspace.CurrentCamera

local rainbowHue = 0
_G.rainbowHue = 0

-- forward declare state so early helpers like getColor capture it as an upvalue
local state

-- interpolate palette shifts for visuals

local function getColor(mode, c1, c2, tOverride)
    if mode == "Rainbow" then
        local speed = state and state.colorShiftSpeed or 3
        local hue = (tick() * (speed * 0.15)) % 1.0
        return Color3.fromHSV(hue, 1, 1)
    elseif mode == "Gradient" or mode == "Shift" then
        local speed = state and state.colorShiftSpeed or 3
        local t = tOverride or ((math.sin(tick() * speed) + 1) / 2)
        return (c1 or Color3.new(1,1,1)):Lerp(c2 or Color3.new(0, 170, 255), t)
    else
        return c1 or Color3.new(1,1,1)
    end
end

-- tear down previous session before mounting 
if getgenv and getgenv().MD_MM2_CLEANUP then
    pcall(getgenv().MD_MM2_CLEANUP)
end

for _, child in ipairs(game:GetChildren()) do
    if child:IsA("BindableEvent") and child.Name:find("^__MD_Cleanup") then
        pcall(function() child:Fire() end)
        task.wait(0.05)
        pcall(function() child:Destroy() end)
    end
end


local cleanupSignal = Instance.new("BindableEvent")
cleanupSignal.Name = "__MD_Cleanup__"
cleanupSignal.Parent = game

local myUniqueId = HttpService:GenerateGUID(false)
game:SetAttribute("__MD_ActiveID__", myUniqueId)

-- persist runtime toggles and session values 
state = {
    unloaded = false,
    
    -- track match progression and weapon holders
    roundActive = false,
    roundStartTime = 0,
    deadPlayers = {},
    knifeHolder = nil,
    gunHolder = nil,
    avoidMurderer = false,
    avoidDistance = 35,
    noRoundStartTime = tick(),
    
    -- configure coin and round automation settings
    autofarmEnabled = false,
    autofarmMode = "Coin",
    autofarmTweenSpeed = 22,
    afterFarmAction = "Farm exp",
    roundEndFling = false,
    autoTakeGun = false,
    autoTakeGunMethod = "Touch interest",
    webhookEnabled = false,
    webhookUrl = "",
    webhookIntervalStr = "5m",
    webhookIntervalSec = 300,
    hasTeleportedToLobby = false,
    
    -- record session earnings for telemetry
    startTime = tick(),
    totalCoinsFarmed = 0,
    roundsPassed = 0,
    lastWebhookSent = tick(),
    currentTaskStatus = "Idle",
    taskLoggerEnabled = true,
    tweenRoundTeleported = false,
    
    -- map auto voting
    autoVoteRunning = false,
    autoVotePadIndex = 1,
    
    -- tune movement physics and weapon targeting
    speedEnabled = false,
    speedValue = 16,
    speedMode = "WalkSpeed",
    
    bhopEnabled = false,
    bhopSpeed = 30,
    autoBhop = false,
    
    flightEnabled = false,
    flightSpeed = 50,
    
    aimbotEnabled = false,
    autoAimEnabled = false,
    autoAimWallbang = false,
    antiFlingEnabled = false,
    chinaHatEnabled = false,
    chinaHatFollowHead = false,
    spinbotEnabled = false,
    spinbotSpeed = 30,
    
    -- highlight characters and carried items
    espEnabled = false,
    espMaxDistance = 1000,
    chamsEnabled = true,
    chamsMode = "Highlight",
    chamsMurdererColor = Color3.fromRGB(255, 70, 70),
    chamsSheriffColor = Color3.fromRGB(90, 120, 255),
    chamsInnocentColor = Color3.fromRGB(50, 230, 110),
    chamsFillTransparency = 0.45,
    chamsOutlineTransparency = 0,
    boxEspEnabled = false,
    nameEspEnabled = true,
    roleEspEnabled = true,
    gunEspEnabled = true,
    skeletonEspEnabled = false,
    skeletonColorMode = "Normal",
    skeletonUseRoleColor = true,
    skeletonColor = Color3.fromRGB(255, 255, 255),
    skeletonColor2 = Color3.fromRGB(0, 170, 255),
    skeletonThickness = 1.5,
    skeletonTransparency = 0,
    
    -- select targets for physics flinging
    targetUsername = "",
    flingForwardOffset = 3.0,
    flingYOffset = 0,
    flingHeadHeight = 0,
    flingYVelocityFactor = 0.15,

    -- automate role-specific interactions
    killAuraEnabled = false,
    killAuraRange = 15,
    killAuraVisible = true,
    killAuraParticleSize = 15.0,
    killAuraParticlePreset = "Fade circle",
    killAuraParticleCustomId = "",
    killAuraParticleEnabled = false,
    killAuraParticleColor = Color3.fromRGB(255, 255, 255),
    killAuraParticleTransparency = 0.2,
    killAuraParticleGlow = 1.0,
    killAuraType = "Stab",
    killAuraParticleCount = 1,
    killAuraDegreeOffset = 0,
    killAuraHeightOffset = 0,
    killAuraParticleSpawnDelay = 0,
    killAuraParticleMinSpin = 0,
    killAuraParticleMaxSpin = 0,
    killAuraParticleColorMode = "Normal",
    killAuraParticleColor2 = Color3.fromRGB(255, 0, 128),
    killAuraParticleIsFlipbook = false,
    killAuraParticleFlipbookLayout = "Grid4x4",
    killAuraParticleFlipbookMode = "Loop",
    killAuraParticleFlipbookSpeed = 15,

    emoteStopOnMove = false,
    selectedEmote = "Sit",
    customEmotes = {},
    valueCalculatorEnabled = true,
    isFlinging = false,

    -- override jump height limits
    jumpPowerEnabled = false,
    jumpPowerValue = 50,

    -- attach view to focused player
    spectateTarget = false,

    -- track match timestamps for discord logs
    webhookCoinsPerHour = true,
    webhookCurrentCoins = true,

    -- queue automated box purchases
    autoOpenCratesEnabled = false,
    selectedCrateType = "MysteryBox1",
    autoServerHopEnabled = false,
    autoServerHopIntervalMin = 15,
    autoServerHopWaitForRound = true,
    lastServerHopTimer = 0,
    colorShiftSpeed = 3,
    configFileName = "MM2_MD_CONFIG.json",

    -- render touch shortcuts on touch screens
    mobileButtonsEnabled = false,
    lockMobileButtons = false,
    mobileBtnFlightEnabled = true,
    mobileBtnLockEnabled = true,
    mobileBtnFlingMurdEnabled = true,
    mobileBtnFlingSheriffEnabled = true,
    mobileBtnShootEnabled = true,
}

-- retain active instances for graceful teardown
local Window
local camlockConn
local noclipConn
local flyConn
local spinbotConn
local mobileFlyBtn, mobileCamlockBtn, mobileShootBtn, mobileFlingMurdBtn, mobileFlingSheriffBtn
local removeESP
local espPlayers
local currentCustomSky
local defaultLighting
local worldState
local stretchSettings
local camlockSettings = {
    isLockedOn = false,
    targetPlayer = nil,
    aimLockEnabled = false,
    smoothingFactor = 0.2,
    predictionFactor = 0.2,
    horizontalPrediction = 0.2,
    verticalPrediction = 0.2,
    predictionMode = "Auto (MoveDirection)",
    bodyPartSelected = "Head"
}
local isCoinBagVisible
local activeJumpRings = {}

local function formatCustomAssetId(raw)
    if not raw or raw == "" then return "" end
    local str = tostring(raw):gsub("%s+", "")
    local digits = str:match("%d+")
    return digits and ("rbxassetid://" .. digits) or str
end

local killAuraParticlePresets = {
    ["Fade circle"]           = { texture = "112096280571499", isAnimated = false },
    ["Telemon's fire circle"] = { texture = "58889937", isAnimated = false },
    ["Dashed circle"]         = { texture = "10131954007", isAnimated = false },
    ["Magic circle"]          = { texture = "7452563698", isAnimated = false },
    ["Custom"]                = { texture = "", isAnimated = false },
}

local connections = {}
local threads = {}
local playerConnections = {}
local playerCharConnections = {}

local function trackConnection(conn)
    table.insert(connections, conn)
    return conn
end

local function trackPlayerConnection(plr, conn)
    if not playerConnections[plr] then
        playerConnections[plr] = {}
    end
    table.insert(playerConnections[plr], conn)
    return conn
end

local function clearPlayerConnections(plr)
    if playerConnections[plr] then
        for _, conn in ipairs(playerConnections[plr]) do
            pcall(function() conn:Disconnect() end)
        end
        playerConnections[plr] = nil
    end
end

local function trackThread(thr)
    table.insert(threads, thr)
    return thr
end

local function restoreCharacterCollision(char)
    char = char or LocalPlayer.Character
    if not char then return end
    for _, p in ipairs(char:GetDescendants()) do
        if p:IsA("BasePart") then
            p.CanCollide = (p.Name == "HumanoidRootPart")
        end
    end
end

local function stopAllMovement()
    if state and state.flightEnabled then return end
    if state and state.isFlinging then return end
    pcall(function()
        if noclipConn then
            pcall(function() noclipConn:Disconnect() end)
            noclipConn = nil
        end
        local char = LocalPlayer.Character
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp then
                for _, obj in ipairs(hrp:GetChildren()) do
                    if obj.Name == "SafePlate" or obj:IsA("BodyVelocity") then
                        pcall(function() obj:Destroy() end)
                    end
                end
                pcall(function()
                    hrp.AssemblyLinearVelocity  = Vector3.zero
                    hrp.AssemblyAngularVelocity = Vector3.zero
                end)
            end
            restoreCharacterCollision(char)
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end
        end
    end)
end

-- restore default game state on unload 
local cleanupHooks = {}
local function registerCleanupHook(fn)
    table.insert(cleanupHooks, fn)
end

local function doCleanup()
    state.unloaded = true
    state.autofarmEnabled = false
    state.espEnabled = false
    state.aimbotEnabled = false
    state.autoAimEnabled = false
    state.autoAimWallbang = false
    state.bhopEnabled = false
    state.autoBhop = false
    state.flightEnabled = false
    state.speedMode = "WalkSpeed"
    state.isFlinging = false

    if camlockConn then pcall(function() camlockConn:Disconnect() end) camlockConn = nil end
    if currentCustomSky then
        pcall(function() currentCustomSky:Destroy() end)
        currentCustomSky = nil
    end
    if defaultLighting then
        pcall(function()
            LightingService.ClockTime = defaultLighting.ClockTime
            LightingService.Brightness = defaultLighting.Brightness
            LightingService.FogEnd = defaultLighting.FogEnd
            LightingService.FogColor = defaultLighting.FogColor
        end)
    end
    pcall(function()
        RunService:UnbindFromRenderStep("CameraPipeline")
        CurrentCamera.FieldOfView = 70
    end)
    if activeJumpRings then
        for _, p in ipairs(activeJumpRings) do
            pcall(function() p:Destroy() end)
        end
        table.clear(activeJumpRings)
    end
    pcall(function() if Window then Window:Destroy() end end)

    for _, fn in ipairs(cleanupHooks) do
        pcall(fn)
    end
    table.clear(cleanupHooks)

    pcall(function()
        if flyConn then flyConn:Disconnect() flyConn = nil end
        if spinbotConn then pcall(function() spinbotConn:Disconnect() end) spinbotConn = nil end
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp then
            for _, obj in ipairs(hrp:GetChildren()) do
                if obj:IsA("BodyVelocity") or obj:IsA("BodyGyro") or obj:IsA("BodyPosition") or obj:IsA("BodyMover")
                    or obj.Name == "SafePlate" then
                    pcall(function() obj:Destroy() end)
                end
            end
            pcall(function() hrp.Anchored = false end)
            hrp.AssemblyLinearVelocity  = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end
        if hum then
            hum.WalkSpeed = 16
            hum.JumpPower = 50
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.GettingUp) end)
        end
        if char then
            for _, p in ipairs(char:GetDescendants()) do
                if p:IsA("BasePart") then
                    pcall(function()
                        p.Anchored = false
                        p.CanCollide = (p.Name == "HumanoidRootPart")
                    end)
                end
            end
        end
    end)

    pcall(function()
        if noclipConn then noclipConn:Disconnect() noclipConn = nil end
    end)

    pcall(function()
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then
                for _, obj in ipairs(plr.Character:GetChildren()) do
                    if obj.Name == "ChamsHighlight" then pcall(function() obj:Destroy() end) end
                end
            end
        end
    end)

    pcall(function()
        if game:GetAttribute("__MD_ActiveID__") == myUniqueId then
            game:SetAttribute("__MD_ActiveID__", nil)
        end
    end)

    for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
    table.clear(connections)
    for plr, conns in pairs(playerConnections) do
        for _, c in ipairs(conns) do pcall(function() c:Disconnect() end) end
    end
    table.clear(playerConnections)
    for plr, conn in pairs(playerCharConnections) do
        pcall(function() conn:Disconnect() end)
    end
    table.clear(playerCharConnections)
    for _, t in ipairs(threads) do pcall(function() task.cancel(t) end) end
    table.clear(threads)

    pcall(function()
        if stopChinaHat then stopChinaHat() end
        if stopWings then stopWings() end
        if removeOrb then removeOrb() end
        if removeCrosshair then removeCrosshair() end
        if translucentBodyConfig then translucentBodyConfig.enabled = false end
        if applyTranslucentBody then pcall(applyTranslucentBody) end
        if bodyParticlesConfig then bodyParticlesConfig.enabled = false end
        if removeBodyParticles then pcall(removeBodyParticles) end
        if removeBodyContainerPart then pcall(removeBodyContainerPart) end
        if silentAimConfig then silentAimConfig.enabled = false end
        if removeFOVCircle then pcall(removeFOVCircle) end
        if fovCircleDrawing then pcall(function() fovCircleDrawing:Remove() end) fovCircleDrawing = nil end
        if fovCircleGui then pcall(function() fovCircleGui:Destroy() end) fovCircleGui = nil end
        
        for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
            if plr.Character then
                for _, child in ipairs(plr.Character:GetChildren()) do
                    if child.Name == "ChinaHat" or child.Name == "LeftWing" or child.Name == "RightWing" or child.Name == "_LeftWing" or child.Name == "_RightWing" or child.Name == "BodyParticleContainerPart" then
                        pcall(function() child:Destroy() end)
                    end
                end
            end
        end
    end)

    local okCoreGui, coreGui = pcall(function() return game:GetService("CoreGui") end)
    local targetGuiParents = {
        PlayerGui,
        (gethui and gethui() or nil),
        (okCoreGui and coreGui or nil)
    }

    for _, guiName in ipairs({
        "PizdatyUI", "ESPGui",
        "MobileButtonsGui",
        "CrosshairGui", "FOVCircleGui"
    }) do
        for _, parent in ipairs(targetGuiParents) do
            if parent then
                local found = parent:FindFirstChild(guiName)
                if found then pcall(function() found:Destroy() end) end
            end
        end
    end

    pcall(stopAllMovement)
    pcall(function() cleanupSignal:Destroy() end)
    pcall(function()
        local plate = Workspace:FindFirstChild("AntiVoidPlate")
        if plate then plate:Destroy() end
    end)
end

cleanupSignal.Event:Connect(doCleanup)
if getgenv then
    getgenv().MD_MM2_CLEANUP = doCleanup
end




-- MM2 Values Cache & Scraper (mm2checker.com)
local MM2Values = {}
local MM2ValuesNormalized = {}
local MM2ValuesByRarity = {}
local MM2ValuesNormalizedByRarity = {}
local MM2ValueDisplays = {}
local isFetchingMM2Values = false
local hasFetchedMM2Values = false

local function storeItem(rName, name, numVal)
    if not name or name == '' or not numVal then return end
    if not MM2ValuesByRarity[rName]           then MM2ValuesByRarity[rName] = {} end
    if not MM2ValuesNormalizedByRarity[rName] then MM2ValuesNormalizedByRarity[rName] = {} end

    local normKey = name:lower():gsub('[^%w]', '')
    MM2Values[name]                             = numVal
    MM2ValuesNormalized[normKey]                 = numVal
    MM2ValuesByRarity[rName][name]               = numVal
    MM2ValuesNormalizedByRarity[rName][normKey]     = numVal
    MM2ValueDisplays[name]                      = tostring(numVal)

    -- Chroma aliases: "C. Traveler's Gun" <-> "Chroma Traveler's Gun"
    if name:find('^C%.%s*') then
        local chromaName = name:gsub('^C%.%s*', 'Chroma ')
        local cNorm = chromaName:lower():gsub('[^%w]', '')
        MM2Values[chromaName] = numVal
        MM2ValuesNormalized[cNorm] = numVal
        MM2ValuesByRarity[rName][chromaName] = numVal
        MM2ValuesNormalizedByRarity[rName][cNorm] = numVal
    elseif name:find('^Chroma%s+') then
        local cDotName = name:gsub('^Chroma%s+', 'C. ')
        local cNorm = cDotName:lower():gsub('[^%w]', '')
        MM2Values[cDotName] = numVal
        MM2ValuesNormalized[cNorm] = numVal
        MM2ValuesByRarity[rName][cDotName] = numVal
        MM2ValuesNormalizedByRarity[rName][cNorm] = numVal
    end

    -- Sunset (Gun) Rare alias: The orange palm-tree revolver (asset 120907601916735) has value 0.5, while "Sun" on the site has value 3
    if name == "Sunset (Gun)" and rName == "Rare" then
        if not MM2ValuesByRarity["Rare"]["Sunset"] then
            MM2ValuesByRarity["Rare"]["Sunset"] = numVal
        end
        if not MM2ValuesNormalizedByRarity["Rare"]["sunset"] then
            MM2ValuesNormalizedByRarity["Rare"]["sunset"] = numVal
        end
        if not MM2ValuesByRarity["Rare"]["Sunset Gun"] then
            MM2ValuesByRarity["Rare"]["Sunset Gun"] = numVal
        end
        if not MM2ValuesNormalizedByRarity["Rare"]["sunsetgun"] then
            MM2ValuesNormalizedByRarity["Rare"]["sunsetgun"] = numVal
        end
    end

    -- Index without parentheses e.g. "Cursed (Knife)" -> "Cursed"
    local noParens = name:gsub('%s*%b()', ''):gsub('^%s+', ''):gsub('%s+$', '')
    if noParens ~= name and noParens ~= '' then
        local npNorm = noParens:lower():gsub('[^%w]', '')
        if not MM2Values[noParens] then MM2Values[noParens] = numVal end
        if not MM2ValuesNormalized[npNorm] then MM2ValuesNormalized[npNorm] = numVal end
        if not MM2ValuesByRarity[rName][noParens] then MM2ValuesByRarity[rName][noParens] = numVal end
        if not MM2ValuesNormalizedByRarity[rName][npNorm] then MM2ValuesNormalizedByRarity[rName][npNorm] = numVal end
    end

    -- Index without weapon suffix
    local noSuf = name
        :gsub('%s+[Kk]nife$', '')
        :gsub('%s+[Gg]un$',   '')
        :gsub('%s+[Aa]xe$',   '')
        :gsub('%s+[Ss]cythe$','')
        :gsub('%s+[Ss]word$', '')
        :gsub('%s+[Bb]lade$', '')
        :gsub('%s+[Dd]agger$','')
        :gsub('%s+[Ss]aber$', '')
    if noSuf ~= name and noSuf ~= '' then
        local noSufNorm = noSuf:lower():gsub('[^%w]', '')
        if not MM2Values[noSuf]                         then MM2Values[noSuf] = numVal end
        if not MM2ValuesNormalized[noSufNorm]           then MM2ValuesNormalized[noSufNorm] = numVal end
        if not MM2ValuesByRarity[rName][noSuf]          then MM2ValuesByRarity[rName][noSuf] = numVal end
        if not MM2ValuesNormalizedByRarity[rName][noSufNorm] then MM2ValuesNormalizedByRarity[rName][noSufNorm] = numVal end
    end
end

-- Pre-compiled static MM2Checker item values (always available instantly without HTTP)
local MM2_STATIC_VALUES = {
    ["2015"] = { val = 0.8, rarity = "Common" },
    ["8Bit"] = { val = 0.05, rarity = "Common" },
    ["<3"] = { val = 14, rarity = "Pets" },
    ["Abduction"] = { val = 0.15, rarity = "Uncommon" },
    ["Abstract"] = { val = 0.3, rarity = "Rare" },
    ["Ace"] = { val = 0.3, rarity = "Rare" },
    ["Adurite (Gun)"] = { val = 0.2, rarity = "Uncommon" },
    ["Adurite (Knife)"] = { val = 0.2, rarity = "Uncommon" },
    ["Alex"] = { val = 4, rarity = "Common" },
    ["Alienbeam"] = { val = 3046, rarity = "Godly" },
    ["Aliens"] = { val = 0.12, rarity = "Common" },
    ["America"] = { val = 10, rarity = "Vintage" },
    ["Amerilaser"] = { val = 31, rarity = "Godly" },
    ["Apocalypse (Gun)"] = { val = 0.45, rarity = "Common" },
    ["Apocalypse (Knife)"] = { val = 0.45, rarity = "Common" },
    ["Aqua"] = { val = 0.05, rarity = "Common" },
    ["Aquarium (Gun)"] = { val = 0.6, rarity = "Legendary" },
    ["Aquarium (Knife)"] = { val = 0.45, rarity = "Legendary" },
    ["Arctic (Gun)"] = { val = 7, rarity = "Legendary" },
    ["Arctic (Knife)"] = { val = 0.8, rarity = "Legendary" },
    ["Asteroid"] = { val = 4, rarity = "Common" },
    ["Aurora (Gun)"] = { val = 1, rarity = "Rare" },
    ["Aurora (Knife)"] = { val = 16, rarity = "Rare" },
    ["Australis"] = { val = 137, rarity = "Godly" },
    ["Bacon"] = { val = 0.3, rarity = "Rare" },
    ["Badger"] = { val = 1, rarity = "Pets" },
    ["Balloons"] = { val = 0.1, rarity = "Common" },
    ["Bat"] = { val = 0.23, rarity = "Pets" },
    ["Bats"] = { val = 4, rarity = "Rare" },
    ["Bats (2020)"] = { val = 0.25, rarity = "Common" },
    ["Bats (Gun)"] = { val = 1, rarity = "Common" },
    ["Bats (Knife)"] = { val = 171, rarity = "Common" },
    ["Bats Gun (2024)"] = { val = 0.15, rarity = "Common" },
    ["Bats Knife (2024)"] = { val = 0.1, rarity = "Common" },
    ["Battleaxe"] = { val = 16, rarity = "Godly" },
    ["Battleaxe II"] = { val = 23, rarity = "Godly" },
    ["Batwing"] = { val = 62, rarity = "Ancient" },
    ["Bauble"] = { val = 1232, rarity = "Godly" },
    ["Beach"] = { val = 41, rarity = "Legendary" },
    ["Bear"] = { val = 0.15, rarity = "Pets" },
    ["Bells"] = { val = 0.1, rarity = "Common" },
    ["Big Kill"] = { val = 0.05, rarity = "Common" },
    ["Bio"] = { val = 0.38, rarity = "Rare" },
    ["Bioblade"] = { val = 14, rarity = "Godly" },
    ["Biogun"] = { val = 0.2, rarity = "Uncommon" },
    ["Bit"] = { val = 0.05, rarity = "Common" },
    ["Black"] = { val = 0.3, rarity = "Rare" },
    ["Black Cat"] = { val = 274, rarity = "Pets" },
    ["Blaster"] = { val = 25, rarity = "Godly" },
    ["Bleached"] = { val = 0.05, rarity = "Common" },
    ["Blizzard"] = { val = 219, rarity = "Godly" },
    ["Blood"] = { val = 11, rarity = "Vintage" },
    ["Bloom"] = { val = 431, rarity = "Godly" },
    ["Blossom"] = { val = 0.8, rarity = "Common" },
    ["Blue"] = { val = 0.2, rarity = "Uncommon" },
    ["Blue Elite"] = { val = 4, rarity = "Legendary" },
    ["Blue Pumpkin (2018)"] = { val = 301, rarity = "Pets" },
    ["Blue Pumpkin (2019)"] = { val = 3, rarity = "Pets" },
    ["Blue Pumpkin (2020)"] = { val = 4, rarity = "Pets" },
    ["Blue Scratch"] = { val = 3, rarity = "Legendary" },
    ["Blue Seer"] = { val = 4, rarity = "Godly" },
    ["Bluesteel (Gun)"] = { val = 0.2, rarity = "Uncommon" },
    ["Bluesteel (Knife)"] = { val = 0.2, rarity = "Uncommon" },
    ["Boneblade"] = { val = 10, rarity = "Godly" },
    ["Bones"] = { val = 1, rarity = "Common" },
    ["Bones (Knife)"] = { val = 0.15, rarity = "Uncommon" },
    ["Borders"] = { val = 0.05, rarity = "Common" },
    ["Borealis"] = { val = 144, rarity = "Godly" },
    ["Box of Blue Papers"] = { val = 3, rarity = "Other" },
    ["Box of Fertilizer"] = { val = 3, rarity = "Other" },
    ["Box of Gold Papers"] = { val = 3, rarity = "Other" },
    ["Box of Green Papers"] = { val = 3, rarity = "Other" },
    ["Box of Purple Papers"] = { val = 3, rarity = "Other" },
    ["Box of Red Papers"] = { val = 3, rarity = "Other" },
    ["Box of Ultra Wrap"] = { val = 3, rarity = "Other" },
    ["Brains"] = { val = 1, rarity = "Common" },
    ["Brains 2022"] = { val = 0.23, rarity = "Uncommon" },
    ["Branches"] = { val = 41, rarity = "Uncommon" },
    ["Broken"] = { val = 10, rarity = "Legendary" },
    ["Brown"] = { val = 0.05, rarity = "Common" },
    ["Brush"] = { val = 0.2, rarity = "Uncommon" },
    ["Bunnies"] = { val = 5, rarity = "Legendary" },
    ["Bunny"] = { val = 0.8, rarity = "Common" },
    ["Butterflies"] = { val = 0.25, rarity = "Rare" },
    ["C. Candleflame"] = { val = 62, rarity = "Godly" },
    ["C. Constellation"] = { val = 49284, rarity = "Godly" },
    ["C. Cookiecane"] = { val = 52, rarity = "Godly" },
    ["C. Darkbringer"] = { val = 103, rarity = "Godly" },
    ["C. Deathshard"] = { val = 52, rarity = "Godly" },
    ["C. Elderwood Blade"] = { val = 62, rarity = "Godly" },
    ["C. Fire Bunny"] = { val = 7, rarity = "Pets" },
    ["C. Gingerblade"] = { val = 44, rarity = "Godly" },
    ["C. Heart Wand"] = { val = 6503, rarity = "Godly" },
    ["C. Lightbringer"] = { val = 96, rarity = "Godly" },
    ["C. Snow Dagger"] = { val = 7872, rarity = "Godly" },
    ["C. Snowcannon"] = { val = 11636, rarity = "Godly" },
    ["C. Swirly Gun"] = { val = 62, rarity = "Godly" },
    ["C. Traveler's Gun"] = { val = 308025, rarity = "Godly" },
    ["C. Vampire's Gun"] = { val = 47915, rarity = "Godly" },
    ["Camo (Gun)"] = { val = 0.2, rarity = "Uncommon" },
    ["Camo (Knife)"] = { val = 0.2, rarity = "Uncommon" },
    ["Candied (Gun)"] = { val = 0.1, rarity = "Common" },
    ["Candied (Knife)"] = { val = 0.15, rarity = "Common" },
    ["Candies (2016)"] = { val = 0.1, rarity = "Other" },
    ["Candies (2017)"] = { val = 0.05, rarity = "Other" },
    ["Candle"] = { val = 0.15, rarity = "Common" },
    ["Candleflame"] = { val = 55, rarity = "Godly" },
    ["Candleflame (Gun)"] = { val = 0.25, rarity = "Rare" },
    ["Candles"] = { val = 0.15, rarity = "Common" },
    ["Candy"] = { val = 116, rarity = "Godly" },
    ["Candy Corn (Gun)"] = { val = 0.1, rarity = "Common" },
    ["Candy Corn (Knife)"] = { val = 0.1, rarity = "Common" },
    ["Candy Swirl (Gun)"] = { val = 7, rarity = "Rare" },
    ["Candy Swirl (Knife)"] = { val = 1, rarity = "Rare" },
    ["CandyCorn (2019)"] = { val = 4, rarity = "Common" },
    ["CandyCorn (Gun)"] = { val = 0.15, rarity = "Common" },
    ["CandyCorn (Knife)"] = { val = 0.1, rarity = "Common" },
    ["CandyCorn 2017"] = { val = 21, rarity = "Common" },
    ["Cane (Gun)"] = { val = 0.8, rarity = "Rare" },
    ["Cane (Knife)"] = { val = 0.8, rarity = "Rare" },
    ["Cane 2018 (Gun)"] = { val = 0.6, rarity = "Rare" },
    ["Cane 2021 (Gun)"] = { val = 0.23, rarity = "Common" },
    ["Cane 2021 (Knife)"] = { val = 0.1, rarity = "Common" },
    ["Cane Knife (2018)"] = { val = 1232, rarity = "Rare" },
    ["Canes (Gun)"] = { val = 0.23, rarity = "Uncommon" },
    ["Canes (Knife)"] = { val = 0.15, rarity = "Uncommon" },
    ["Cardboard"] = { val = 0.05, rarity = "Common" },
    ["Carrot"] = { val = 0.8, rarity = "Common" },
    ["Carrot (Gun)"] = { val = 0.23, rarity = "Uncommon" },
    ["Carrot (Knife)"] = { val = 0.15, rarity = "Uncommon" },
    ["Carrot Bunny"] = { val = 0.38, rarity = "Pets" },
    ["Carrots"] = { val = 0.15, rarity = "Common" },
    ["Carved (Gun)"] = { val = 0.15, rarity = "Common" },
    ["Carved (Knife)"] = { val = 0.15, rarity = "Common" },
    ["Cat"] = { val = 0.05, rarity = "Pets" },
    ["Cats"] = { val = 0.15, rarity = "Common" },
    ["Caution"] = { val = 0.2, rarity = "Uncommon" },
    ["Cavern (Gun)"] = { val = 1, rarity = "Legendary" },
    ["Cavern (Knife)"] = { val = 10, rarity = "Legendary" },
    ["Celestial"] = { val = 2396, rarity = "Ancient" },
    ["Checkers"] = { val = 0.23, rarity = "Uncommon" },
    ["Cheddar"] = { val = 0.2, rarity = "Uncommon" },
    ["Cheesy"] = { val = 0.2, rarity = "Uncommon" },
    ["Cherry"] = { val = 0.05, rarity = "Common" },
    ["Chick"] = { val = 0.15, rarity = "Common" },
    ["Chill"] = { val = 14, rarity = "Godly" },
    ["Chilly"] = { val = 10, rarity = "Pets" },
    ["Choco"] = { val = 0.8, rarity = "Common" },
    ["Chroma Alienbeam"] = { val = 41070, rarity = "Godly" },
    ["Chroma Bauble"] = { val = 52022, rarity = "Godly" },
    ["Chroma Blizzard"] = { val = 10952, rarity = "Godly" },
    ["Chroma Boneblade"] = { val = 37, rarity = "Godly" },
    ["Chroma Evergreen"] = { val = 82140, rarity = "Godly" },
    ["Chroma Evergun"] = { val = 105413, rarity = "Godly" },
    ["Chroma Fang"] = { val = 48, rarity = "Godly" },
    ["Chroma Fire Bat"] = { val = 7, rarity = "Pets" },
    ["Chroma Fire Bear"] = { val = 7, rarity = "Pets" },
    ["Chroma Fire Cat"] = { val = 7, rarity = "Pets" },
    ["Chroma Fire Dog"] = { val = 7, rarity = "Pets" },
    ["Chroma Fire Fox"] = { val = 7, rarity = "Pets" },
    ["Chroma Fire Pig"] = { val = 7, rarity = "Pets" },
    ["Chroma Gemstone"] = { val = 44, rarity = "Godly" },
    ["Chroma Heat"] = { val = 44, rarity = "Godly" },
    ["Chroma Laser"] = { val = 57, rarity = "Godly" },
    ["Chroma Luger"] = { val = 75, rarity = "Godly" },
    ["Chroma Ornament"] = { val = 3628, rarity = "Godly" },
    ["Chroma Raygun"] = { val = 20193, rarity = "Godly" },
    ["Chroma Saw"] = { val = 41, rarity = "Godly" },
    ["Chroma Seer"] = { val = 44, rarity = "Godly" },
    ["Chroma Shark"] = { val = 48, rarity = "Godly" },
    ["Chroma Slasher"] = { val = 52, rarity = "Godly" },
    ["Chroma Snowstorm"] = { val = 5818, rarity = "Godly" },
    ["Chroma Sunrise"] = { val = 15401, rarity = "Godly" },
    ["Chroma Sunset"] = { val = 8898, rarity = "Godly" },
    ["Chroma Sweet"] = { val = 3902, rarity = "Godly" },
    ["Chroma Tides"] = { val = 41, rarity = "Godly" },
    ["Chroma Treat"] = { val = 6640, rarity = "Godly" },
    ["Chroma Watergun"] = { val = 4655, rarity = "Godly" },
    ["Chromatic (Gun)"] = { val = 0.8, rarity = "Legendary" },
    ["Chromatic (Knife)"] = { val = 1, rarity = "Legendary" },
    ["Circuit"] = { val = 0.2, rarity = "Uncommon" },
    ["Clan"] = { val = 0.05, rarity = "Common" },
    ["Clockwork"] = { val = 14, rarity = "Godly" },
    ["Clown (Gun)"] = { val = 0.05, rarity = "Common" },
    ["Clown (Knife)"] = { val = 0.05, rarity = "Common" },
    ["Clown Gun (2024)"] = { val = 0.15, rarity = "Uncommon" },
    ["Clownfish (Gun)"] = { val = 0.1, rarity = "Common" },
    ["Clownfish (Knife)"] = { val = 0.15, rarity = "Common" },
    ["Coal"] = { val = 0.15, rarity = "Common" },
    ["Coal (Gun)"] = { val = 0.12, rarity = "Common" },
    ["Coal (Knife)"] = { val = 16, rarity = "Common" },
    ["Coal 2021 (Gun)"] = { val = 0.15, rarity = "Common" },
    ["Coal 2021 (Knife)"] = { val = 0.23, rarity = "Common" },
    ["Coal 2022 (Gun)"] = { val = 0.12, rarity = "Common" },
    ["Coal 2022 (Knife)"] = { val = 0.1, rarity = "Common" },
    ["Coconut"] = { val = 0.1, rarity = "Common" },
    ["Cold"] = { val = 0.05, rarity = "Common" },
    ["Combat"] = { val = 0.05, rarity = "Common" },
    ["Combat II"] = { val = 14, rarity = "Common" },
    ["Constellation"] = { val = 3559, rarity = "Godly" },
    ["Cookie (Gun)"] = { val = 0.23, rarity = "Uncommon" },
    ["Cookie (Knife)"] = { val = 0.25, rarity = "Uncommon" },
    ["Cookieblade"] = { val = 4, rarity = "Godly" },
    ["Cookiecane"] = { val = 21, rarity = "Godly" },
    ["Copper"] = { val = 0.05, rarity = "Common" },
    ["Corl"] = { val = 4, rarity = "Common" },
    ["Corrupt"] = { val = 821, rarity = "Other" },
    ["Cotton Candy"] = { val = 55, rarity = "Legendary" },
    ["Cowboy"] = { val = 5, rarity = "Vintage" },
    ["Cracks (Gun)"] = { val = 0.12, rarity = "Common" },
    ["Cracks (Knife)"] = { val = 0.1, rarity = "Common" },
    ["Cupid"] = { val = 0.6, rarity = "Legendary" },
    ["Curse"] = { val = 0.38, rarity = "Rare" },
    ["Cursed (Gun)"] = { val = 0.45, rarity = "Legendary" },
    ["Cursed (Knife)"] = { val = 0.6, rarity = "Legendary" },
    ["Damp"] = { val = 0.25, rarity = "Rare" },
    ["Darkbringer"] = { val = 55, rarity = "Godly" },
    ["Darkgun"] = { val = 0.8, rarity = "Rare" },
    ["Darkknife"] = { val = 23, rarity = "Rare" },
    ["Darkness (Gun)"] = { val = 0.1, rarity = "Common" },
    ["Darkness (Knife)"] = { val = 0.12, rarity = "Common" },
    ["Darkshot"] = { val = 1930, rarity = "Godly" },
    ["Darksword"] = { val = 1903, rarity = "Godly" },
    ["Deathshard"] = { val = 18, rarity = "Godly" },
    ["Deathspeaker"] = { val = 1, rarity = "Pets" },
    ["Decorated"] = { val = 0.23, rarity = "Uncommon" },
    ["Deep Sea"] = { val = 0.23, rarity = "Rare" },
    ["Denis"] = { val = 4, rarity = "Common" },
    ["Dog"] = { val = 0.05, rarity = "Pets" },
    ["Doge"] = { val = 0.2, rarity = "Uncommon" },
    ["Dogey"] = { val = 151, rarity = "Pets" },
    ["Dolphins"] = { val = 0.1, rarity = "Common" },
    ["Donut"] = { val = 0.15, rarity = "Uncommon" },
    ["Dungeon"] = { val = 68, rarity = "Rare" },
    ["Eclipse"] = { val = 0.23, rarity = "Uncommon" },
    ["Eco"] = { val = 0.05, rarity = "Common" },
    ["Ecto"] = { val = 11, rarity = "Common" },
    ["Egg"] = { val = 0.8, rarity = "Common" },
    ["Eggblade"] = { val = 7, rarity = "Godly" },
    ["Elderwood Blade"] = { val = 55, rarity = "Godly" },
    ["Elderwood Revolver"] = { val = 55, rarity = "Godly" },
    ["Elderwood Scythe"] = { val = 62, rarity = "Ancient" },
    ["Electro"] = { val = 1, rarity = "Pets" },
    ["Elf"] = { val = 14, rarity = "Pets" },
    ["Elf (2018)"] = { val = 1, rarity = "Common" },
    ["Elf (2019)"] = { val = 287, rarity = "Pets" },
    ["Elf (2023)"] = { val = 0.1, rarity = "Common" },
    ["Elf (Gun)"] = { val = 0.8, rarity = "Common" },
    ["Elf (Knife)"] = { val = 23, rarity = "Common" },
    ["Elf 2017"] = { val = 0.15, rarity = "Common" },
    ["Elite"] = { val = 0.38, rarity = "Legendary" },
    ["Elitey"] = { val = 0.12, rarity = "Pets" },
    ["Emerald"] = { val = 0.8, rarity = "Legendary" },
    ["Energized (Gun)"] = { val = 1, rarity = "Legendary" },
    ["Energized (Knife)"] = { val = 0.8, rarity = "Legendary" },
    ["Engraved"] = { val = 0.05, rarity = "Common" },
    ["Etched"] = { val = 0.23, rarity = "Common" },
    ["Eternal"] = { val = 11, rarity = "Godly" },
    ["Eternal II"] = { val = 11, rarity = "Godly" },
    ["Eternal III"] = { val = 14, rarity = "Godly" },
    ["Eternal IV"] = { val = 14, rarity = "Godly" },
    ["Eternalcane"] = { val = 21, rarity = "Godly" },
    ["Euro"] = { val = 5, rarity = "Common" },
    ["Evergreen"] = { val = 3354, rarity = "Godly" },
    ["Evergun"] = { val = 4518, rarity = "Godly" },
    ["Eyeball"] = { val = 10, rarity = "Pets" },
    ["Eyes"] = { val = 0.23, rarity = "Uncommon" },
    ["Fade"] = { val = 0.5, rarity = "Legendary" },
    ["Fairy"] = { val = 11, rarity = "Pets" },
    ["Fall"] = { val = 0.1, rarity = "Common" },
    ["Fall Camo"] = { val = 0.23, rarity = "Uncommon" },
    ["Fallout"] = { val = 0.05, rarity = "Common" },
    ["Fang"] = { val = 14, rarity = "Godly" },
    ["Fire Bat"] = { val = 0.8, rarity = "Pets" },
    ["Fire Bear"] = { val = 0.8, rarity = "Pets" },
    ["Fire Bunny"] = { val = 0.8, rarity = "Pets" },
    ["Fire Cat"] = { val = 0.8, rarity = "Pets" },
    ["Fire Dog"] = { val = 0.8, rarity = "Pets" },
    ["Fire Fox"] = { val = 0.8, rarity = "Pets" },
    ["Fire Pig"] = { val = 0.8, rarity = "Pets" },
    ["Fireplace"] = { val = 0.15, rarity = "Uncommon" },
    ["Flames"] = { val = 7, rarity = "Godly" },
    ["Floatie"] = { val = 0.23, rarity = "Uncommon" },
    ["Flora"] = { val = 445, rarity = "Godly" },
    ["Floral (Gun)"] = { val = 0.25, rarity = "Rare" },
    ["Floral (Knife)"] = { val = 11, rarity = "Rare" },
    ["Flowerwood"] = { val = 274, rarity = "Godly" },
    ["Flowerwood Gun"] = { val = 281, rarity = "Godly" },
    ["Forest"] = { val = 0.15, rarity = "Uncommon" },
    ["Fox"] = { val = 0.1, rarity = "Pets" },
    ["Fragile (Gun)"] = { val = 0.25, rarity = "Common" },
    ["Fragile (Knife)"] = { val = 0.25, rarity = "Common" },
    ["Frostbird"] = { val = 1, rarity = "Pets" },
    ["Frostbite"] = { val = 10, rarity = "Godly" },
    ["Frosted (Gun)"] = { val = 0.45, rarity = "Common" },
    ["Frosted (Knife)"] = { val = 23, rarity = "Common" },
    ["Frostfade (Gun)"] = { val = 0.45, rarity = "Legendary" },
    ["Frostfade (Knife)"] = { val = 1, rarity = "Legendary" },
    ["Frostflame (Gun)"] = { val = 0.38, rarity = "Rare" },
    ["Frostflame (Knife)"] = { val = 0.25, rarity = "Rare" },
    ["Frostsaber"] = { val = 14, rarity = "Godly" },
    ["Frosty"] = { val = 0.25, rarity = "Uncommon" },
    ["Frozen (Gun)"] = { val = 0.1, rarity = "Common" },
    ["Frozen (Knife)"] = { val = 0.15, rarity = "Common" },
    ["Fusion"] = { val = 0.5, rarity = "Legendary" },
    ["Future"] = { val = 0.23, rarity = "Uncommon" },
    ["Galactic"] = { val = 0.3, rarity = "Rare" },
    ["Galaxy"] = { val = 0.3, rarity = "Rare" },
    ["Gemstone"] = { val = 21, rarity = "Godly" },
    ["Ghastly (Gun)"] = { val = 4, rarity = "Rare" },
    ["Ghastly (Knife)"] = { val = 0.25, rarity = "Rare" },
    ["Ghost"] = { val = 14, rarity = "Vintage" },
    ["Ghost (Gun)"] = { val = 3, rarity = "Legendary" },
    ["Ghost (Knife)"] = { val = 7, rarity = "Legendary" },
    ["Ghostblade"] = { val = 10, rarity = "Godly" },
    ["Ghostfire"] = { val = 0.8, rarity = "Rare" },
    ["Ghostly"] = { val = 0.15, rarity = "Uncommon" },
    ["Ghosts (2023)"] = { val = 0.15, rarity = "Common" },
    ["Ghosts (2024)"] = { val = 0.1, rarity = "Common" },
    ["Ghosts (Gun)"] = { val = 0.38, rarity = "Rare" },
    ["Ghosts (Knife)"] = { val = 0.15, rarity = "Uncommon" },
    ["Ghosty"] = { val = 4, rarity = "Common" },
    ["Ghoulish"] = { val = 68, rarity = "Common" },
    ["Gift Bag (Gun)"] = { val = 0.12, rarity = "Common" },
    ["Gift Bag (Knife)"] = { val = 0.15, rarity = "Common" },
    ["Gifted"] = { val = 0.8, rarity = "Uncommon" },
    ["Gifts (2024)"] = { val = 0.15, rarity = "Common" },
    ["Gifts (Gun)"] = { val = 0.25, rarity = "Common" },
    ["Gifts (Knife)"] = { val = 110, rarity = "Common" },
    ["Gifts 2015"] = { val = 0.45, rarity = "Other" },
    ["Giftwrap"] = { val = 0.1, rarity = "Common" },
    ["Ginger (Gun)"] = { val = 0.8, rarity = "Rare" },
    ["Ginger (Knife)"] = { val = 0.8, rarity = "Rare" },
    ["Ginger Luger"] = { val = 23, rarity = "Godly" },
    ["Gingerblade"] = { val = 21, rarity = "Godly" },
    ["Gingerbread"] = { val = 0.23, rarity = "Uncommon" },
    ["Gingerbread (Gun)"] = { val = 0.23, rarity = "Uncommon" },
    ["Gingerbread (Knife)"] = { val = 0.15, rarity = "Uncommon" },
    ["Gingercookie (Gun)"] = { val = 0.38, rarity = "Rare" },
    ["Gingercookie (Knife)"] = { val = 0.38, rarity = "Rare" },
    ["Gingerheart"] = { val = 0.25, rarity = "Uncommon" },
    ["Gingermint"] = { val = 21, rarity = "Godly" },
    ["Gingerscope"] = { val = 24300, rarity = "Ancient" },
    ["Glitch1"] = { val = 103, rarity = "Common" },
    ["Glitch2"] = { val = 68, rarity = "Common" },
    ["Glowy"] = { val = 0.23, rarity = "Uncommon" },
    ["Golden"] = { val = 5, rarity = "Vintage" },
    ["Goo"] = { val = 0.8, rarity = "Common" },
    ["Gothic (Gun)"] = { val = 4, rarity = "Uncommon" },
    ["Gothic (Knife)"] = { val = 0.8, rarity = "Uncommon" },
    ["Graffiti"] = { val = 0.15, rarity = "Uncommon" },
    ["Grave (Gun)"] = { val = 5, rarity = "Common" },
    ["Grave (Knife)"] = { val = 1, rarity = "Common" },
    ["Green"] = { val = 0.05, rarity = "Common" },
    ["Green Elite"] = { val = 4, rarity = "Legendary" },
    ["Green Fire"] = { val = 0.8, rarity = "Legendary" },
    ["Green Luger"] = { val = 34, rarity = "Godly" },
    ["Green Marble"] = { val = 3, rarity = "Rare" },
    ["Green Pumpkin (2018)"] = { val = 82, rarity = "Pets" },
    ["Green Pumpkin (2019)"] = { val = 10, rarity = "Pets" },
    ["Green Pumpkin (2020)"] = { val = 11, rarity = "Pets" },
    ["Green Pumpkin (2021)"] = { val = 10, rarity = "Pets" },
    ["Grind"] = { val = 3, rarity = "Common" },
    ["HL2"] = { val = 0.05, rarity = "Common" },
    ["Hacker"] = { val = 0.3, rarity = "Rare" },
    ["Hallow's Blade"] = { val = 11, rarity = "Godly" },
    ["Hallow's Edge"] = { val = 11, rarity = "Godly" },
    ["Hallowgun"] = { val = 31, rarity = "Godly" },
    ["Hallows Stickers 2022"] = { val = 0.1, rarity = "Common" },
    ["Hallowscythe"] = { val = 44, rarity = "Ancient" },
    ["Handsaw"] = { val = 11, rarity = "Godly" },
    ["Hardened"] = { val = 0.05, rarity = "Common" },
    ["Harvester"] = { val = 397, rarity = "Ancient" },
    ["Haunted"] = { val = 0.1, rarity = "Common" },
    ["Haunted (2025)"] = { val = 0.15, rarity = "Common" },
    ["Haunted (Gun)"] = { val = 1, rarity = "Common" },
    ["Haunted (Knife)"] = { val = 1, rarity = "Common" },
    ["Hazard (Gun)"] = { val = 0.45, rarity = "Uncommon" },
    ["Hazard (Knife)"] = { val = 0.38, rarity = "Uncommon" },
    ["Hazmat"] = { val = 0.2, rarity = "Uncommon" },
    ["Heart"] = { val = 0.25, rarity = "Rare" },
    ["Heart Wand"] = { val = 582, rarity = "Godly" },
    ["Heartblade"] = { val = 96, rarity = "Godly" },
    ["Heartbreak"] = { val = 0.25, rarity = "Rare" },
    ["Hearts"] = { val = 0.8, rarity = "Common" },
    ["Hearts (2026)"] = { val = 0.1, rarity = "Common" },
    ["Heat"] = { val = 14, rarity = "Godly" },
    ["High Tech"] = { val = 0.15, rarity = "Uncommon" },
    ["Hive"] = { val = 0.2, rarity = "Uncommon" },
    ["Holly (Gun)"] = { val = 4, rarity = "Uncommon" },
    ["Holly (Knife)"] = { val = 0.25, rarity = "Uncommon" },
    ["Hologram (Gun)"] = { val = 0.38, rarity = "Rare" },
    ["Hologram (Knife)"] = { val = 0.25, rarity = "Rare" },
    ["Hot Chocolate"] = { val = 0.15, rarity = "Common" },
    ["Hunter"] = { val = 0.25, rarity = "Common" },
    ["Ice"] = { val = 0.05, rarity = "Common" },
    ["Ice Camo"] = { val = 0.25, rarity = "Rare" },
    ["Ice Dragon"] = { val = 10, rarity = "Godly" },
    ["Ice Phoenix"] = { val = 1, rarity = "Pets" },
    ["Ice Shard"] = { val = 10, rarity = "Godly" },
    ["Icebeam"] = { val = 27, rarity = "Godly" },
    ["Iceblaster"] = { val = 55, rarity = "Godly" },
    ["Icebreaker"] = { val = 103, rarity = "Ancient" },
    ["Icecracker"] = { val = 1, rarity = "Legendary" },
    ["Icedriller"] = { val = 7, rarity = "Legendary" },
    ["Iceflake"] = { val = 25, rarity = "Godly" },
    ["Icepiercer"] = { val = 260, rarity = "Ancient" },
    ["Icewing"] = { val = 21, rarity = "Ancient" },
    ["Icey"] = { val = 0.6, rarity = "Pets" },
    ["Icicles (Gun)"] = { val = 11, rarity = "Rare" },
    ["Icicles (Knife)"] = { val = 0.45, rarity = "Rare" },
    ["Igloo (Gun)"] = { val = 0.15, rarity = "Common" },
    ["Igloo (Knife)"] = { val = 0.1, rarity = "Common" },
    ["Imbued"] = { val = 0.3, rarity = "Rare" },
    ["Indy"] = { val = 3, rarity = "Common" },
    ["Infected"] = { val = 0.6, rarity = "Common" },
    ["Infected (Gun)"] = { val = 0.45, rarity = "Common" },
    ["Infected (Knife)"] = { val = 0.45, rarity = "Common" },
    ["Infiltrator"] = { val = 0.05, rarity = "Common" },
    ["Iron"] = { val = 0.05, rarity = "Common" },
    ["JD"] = { val = 48, rarity = "Legendary" },
    ["Jack"] = { val = 4, rarity = "Rare" },
    ["Jellyfish"] = { val = 0.15, rarity = "Uncommon" },
    ["Jetstream"] = { val = 10, rarity = "Pets" },
    ["Jigsaw"] = { val = 0.2, rarity = "Uncommon" },
    ["Jinglegun"] = { val = 21, rarity = "Godly" },
    ["Juice"] = { val = 0.05, rarity = "Common" },
    ["Korblox"] = { val = 0.3, rarity = "Rare" },
    ["Kraken"] = { val = 0.25, rarity = "Rare" },
    ["Krypto"] = { val = 0.3, rarity = "Rare" },
    ["Lantern"] = { val = 0.45, rarity = "Uncommon" },
    ["Laser"] = { val = 31, rarity = "Godly" },
    ["Latte (Gun)"] = { val = 178, rarity = "Legendary" },
    ["Latte (Knife)"] = { val = 178, rarity = "Legendary" },
    ["Lava (Gun)"] = { val = 0.15, rarity = "Uncommon" },
    ["Lava (Knife)"] = { val = 0.23, rarity = "Uncommon" },
    ["Leaf"] = { val = 0.05, rarity = "Common" },
    ["Leaves"] = { val = 0.1, rarity = "Common" },
    ["Lightbringer"] = { val = 51, rarity = "Godly" },
    ["Lights (Gun)"] = { val = 0.1, rarity = "Common" },
    ["Lights (Knife)"] = { val = 0.1, rarity = "Common" },
    ["Lil' Alien"] = { val = 0.45, rarity = "Pets" },
    ["Linked"] = { val = 0.05, rarity = "Common" },
    ["Log"] = { val = 0.05, rarity = "Common" },
    ["Logchopper"] = { val = 25, rarity = "Ancient" },
    ["Logcutter"] = { val = 0.25, rarity = "Rare" },
    ["Love (Gun)"] = { val = 0.38, rarity = "Uncommon" },
    ["Love (Knife)"] = { val = 0.05, rarity = "Common" },
    ["Love 2023"] = { val = 0.15, rarity = "Common" },
    ["Lovely"] = { val = 0.05, rarity = "Common" },
    ["Lucky"] = { val = 0.2, rarity = "Uncommon" },
    ["Luger"] = { val = 62, rarity = "Godly" },
    ["Lugercane"] = { val = 21, rarity = "Godly" },
    ["Magma"] = { val = 7, rarity = "Rare" },
    ["Magma (Gun)"] = { val = 7, rarity = "Rare" },
    ["Magma (Knife)"] = { val = 0.25, rarity = "Rare" },
    ["Makeshift"] = { val = 55, rarity = "Godly" },
    ["Makeshift (Knife)"] = { val = 38, rarity = "Rare" },
    ["Marble"] = { val = 0.15, rarity = "Uncommon" },
    ["Marina"] = { val = 0.2, rarity = "Uncommon" },
    ["Meadow"] = { val = 0.23, rarity = "Uncommon" },
    ["Mechbug"] = { val = 7, rarity = "Pets" },
    ["Melon"] = { val = 0.2, rarity = "Uncommon" },
    ["Meltdown"] = { val = 0.45, rarity = "Uncommon" },
    ["Midnight"] = { val = 0.6, rarity = "Legendary" },
    ["Minty"] = { val = 21, rarity = "Godly" },
    ["Missing"] = { val = 0.2, rarity = "Uncommon" },
    ["Mistletoe (Gun)"] = { val = 0.25, rarity = "Uncommon" },
    ["Mistletoe (Knife)"] = { val = 0.15, rarity = "Uncommon" },
    ["Molten (Gun)"] = { val = 0.6, rarity = "Rare" },
    ["Molten (Knife)"] = { val = 0.6, rarity = "Rare" },
    ["Monster"] = { val = 0.23, rarity = "Uncommon" },
    ["Moon"] = { val = 0.15, rarity = "Common" },
    ["Moonlight"] = { val = 0.25, rarity = "Uncommon" },
    ["Moons"] = { val = 1, rarity = "Uncommon" },
    ["Moons (2024)"] = { val = 0.23, rarity = "Uncommon" },
    ["Mr. Reindeer"] = { val = 41, rarity = "Pets" },
    ["Mr. Snowman"] = { val = 4, rarity = "Pets" },
    ["Mummified"] = { val = 4, rarity = "Common" },
    ["Mummy"] = { val = 0.8, rarity = "Rare" },
    ["Mummy (2017)"] = { val = 3, rarity = "Uncommon" },
    ["Mummy 2018 (Gun)"] = { val = 7, rarity = "Uncommon" },
    ["Mummy 2018 (Knife)"] = { val = 3, rarity = "Uncommon" },
    ["Mummy 2020 (Gun)"] = { val = 0.23, rarity = "Uncommon" },
    ["Mummy 2020 (Knife)"] = { val = 0.15, rarity = "Uncommon" },
    ["Musical"] = { val = 0.3, rarity = "Rare" },
    ["Mystery Key"] = { val = 1, rarity = "Other" },
    ["Nebula"] = { val = 21, rarity = "Godly" },
    ["Neon"] = { val = 0.6, rarity = "Common" },
    ["Nether"] = { val = 0.25, rarity = "Rare" },
    ["News"] = { val = 0.05, rarity = "Common" },
    ["Night"] = { val = 0.23, rarity = "Uncommon" },
    ["Nightblade"] = { val = 27, rarity = "Godly" },
    ["Nightfire"] = { val = 0.3, rarity = "Rare" },
    ["Nightsky"] = { val = 7, rarity = "Legendary" },
    ["Nightstar"] = { val = 0.6, rarity = "Legendary" },
    ["Nik's Scythe"] = { val = 1200000, rarity = "Ancient" },
    ["Nobledragon"] = { val = 11, rarity = "Pets" },
    ["Nova"] = { val = 0.3, rarity = "Rare" },
    ["Nuke"] = { val = 0.25, rarity = "Rare" },
    ["Nutcracker"] = { val = 0.8, rarity = "Uncommon" },
    ["Ocean"] = { val = 253, rarity = "Godly" },
    ["Oily"] = { val = 0.05, rarity = "Common" },
    ["Old Glory"] = { val = 23, rarity = "Godly" },
    ["Ollie"] = { val = 10, rarity = "Common" },
    ["Orange"] = { val = 0.05, rarity = "Common" },
    ["Orange Marble"] = { val = 3, rarity = "Rare" },
    ["Orange Seer"] = { val = 3, rarity = "Godly" },
    ["Ornament"] = { val = 0.8, rarity = "Common" },
    ["Ornament1"] = { val = 0.8, rarity = "Common" },
    ["Ornament2 (Gun)"] = { val = 0.8, rarity = "Common" },
    ["Ornament2 (Knife)"] = { val = 0.8, rarity = "Common" },
    ["Ornaments"] = { val = 0.15, rarity = "Uncommon" },
    ["Ornaments (Gun)"] = { val = 0.23, rarity = "Common" },
    ["Ornaments (Knife)"] = { val = 0.15, rarity = "Common" },
    ["Overseer (Gun)"] = { val = 0.8, rarity = "Legendary" },
    ["Overseer (Knife)"] = { val = 0.5, rarity = "Legendary" },
    ["Overseer Eye"] = { val = 10, rarity = "Pets" },
    ["Painted (Gun)"] = { val = 0.23, rarity = "Uncommon" },
    ["Painted (Knife)"] = { val = 0.25, rarity = "Rare" },
    ["Palms (Gun)"] = { val = 0.6, rarity = "Legendary" },
    ["Palms (Knife)"] = { val = 0.45, rarity = "Legendary" },
    ["Paper"] = { val = 0.2, rarity = "Uncommon" },
    ["Passion"] = { val = 0.8, rarity = "Common" },
    ["Patrick"] = { val = 0.8, rarity = "Common" },
    ["Paws"] = { val = 0.15, rarity = "Uncommon" },
    ["Pea"] = { val = 0.05, rarity = "Common" },
    ["Pearl"] = { val = 75, rarity = "Godly" },
    ["Pearlshine"] = { val = 82, rarity = "Godly" },
    ["Penguin"] = { val = 0.12, rarity = "Common" },
    ["Pengy"] = { val = 10, rarity = "Pets" },
    ["Peppermint"] = { val = 5, rarity = "Godly" },
    ["Peppermint (Gun)"] = { val = 0.1, rarity = "Common" },
    ["Peppermint (Knife)"] = { val = 0.1, rarity = "Common" },
    ["Phantom"] = { val = 14, rarity = "Common" },
    ["Phaser"] = { val = 7, rarity = "Vintage" },
    ["Phoenix"] = { val = 1, rarity = "Pets" },
    ["Pig"] = { val = 0.1, rarity = "Pets" },
    ["Piggy"] = { val = 34, rarity = "Pets" },
    ["Pine (Gun)"] = { val = 0.15, rarity = "Common" },
    ["Pine (Knife)"] = { val = 110, rarity = "Common" },
    ["Pink"] = { val = 0.2, rarity = "Uncommon" },
    ["Pirate"] = { val = 0.2, rarity = "Uncommon" },
    ["Pixel"] = { val = 23, rarity = "Godly" },
    ["Plaid"] = { val = 0.1, rarity = "Common" },
    ["Plasmabeam"] = { val = 25, rarity = "Godly" },
    ["Plasmablade"] = { val = 23, rarity = "Godly" },
    ["Plasmite"] = { val = 0.5, rarity = "Legendary" },
    ["Polar Bear"] = { val = 0.23, rarity = "Uncommon" },
    ["Pool"] = { val = 0.23, rarity = "Uncommon" },
    ["Pool Noodle"] = { val = 0.38, rarity = "Uncommon" },
    ["Pop Art (Gun)"] = { val = 0.25, rarity = "Rare" },
    ["Pop Art (Knife)"] = { val = 0.38, rarity = "Rare" },
    ["Popsicle"] = { val = 0.23, rarity = "Uncommon" },
    ["Popsicle (Gun)"] = { val = 0.15, rarity = "Uncommon" },
    ["Portal (Gun)"] = { val = 0.15, rarity = "Uncommon" },
    ["Portal (Knife)"] = { val = 0.25, rarity = "Rare" },
    ["Potion (2017)"] = { val = 4, rarity = "Uncommon" },
    ["Potion (Gun)"] = { val = 4, rarity = "Uncommon" },
    ["Potion (Knife)"] = { val = 7, rarity = "Uncommon" },
    ["Predator (Gun)"] = { val = 0.5, rarity = "Legendary" },
    ["Predator (Knife)"] = { val = 0.8, rarity = "Legendary" },
    ["Present"] = { val = 0.15, rarity = "Common" },
    ["Present (2023)"] = { val = 0.15, rarity = "Common" },
    ["Prince"] = { val = 8, rarity = "Vintage" },
    ["Prism"] = { val = 14, rarity = "Common" },
    ["Prismatic"] = { val = 10, rarity = "Godly" },
    ["Pumpkin (2017)"] = { val = 41, rarity = "Pets" },
    ["Pumpkin (2018)"] = { val = 0.25, rarity = "Pets" },
    ["Pumpkin (2019)"] = { val = 0.15, rarity = "Pets" },
    ["Pumpkin (2020)"] = { val = 0.1, rarity = "Pets" },
    ["Pumpkin (2021)"] = { val = 0.05, rarity = "Pets" },
    ["Pumpkin (2023)"] = { val = 0.12, rarity = "Common" },
    ["Pumpkin (2025)"] = { val = 0.23, rarity = "Uncommon" },
    ["Pumpkin (Knife)"] = { val = 0.15, rarity = "Uncommon" },
    ["Pumpkin Patch"] = { val = 0.15, rarity = "Uncommon" },
    ["Pumpkin Pie"] = { val = 4, rarity = "Uncommon" },
    ["Pumpking"] = { val = 10, rarity = "Godly" },
    ["Purple"] = { val = 0.3, rarity = "Rare" },
    ["Purple Pumpkin (2018)"] = { val = 10, rarity = "Pets" },
    ["Purple Seer"] = { val = 4, rarity = "Godly" },
    ["RB Knife"] = { val = 0.25, rarity = "Common" },
    ["RIP"] = { val = 21, rarity = "Common" },
    ["Rainbow"] = { val = 397, rarity = "Godly" },
    ["Rainbow (Gun)"] = { val = 0.3, rarity = "Rare" },
    ["Rainbow (Knife)"] = { val = 0.3, rarity = "Rare" },
    ["Rainbow Gun"] = { val = 411, rarity = "Godly" },
    ["Raygun"] = { val = 1780, rarity = "Godly" },
    ["Red"] = { val = 0.2, rarity = "Uncommon" },
    ["Red Fire"] = { val = 1, rarity = "Legendary" },
    ["Red Luger"] = { val = 57, rarity = "Godly" },
    ["Red Pumpkin (2018)"] = { val = 164, rarity = "Pets" },
    ["Red Pumpkin (2019)"] = { val = 10, rarity = "Pets" },
    ["Red Pumpkin (2020)"] = { val = 14, rarity = "Pets" },
    ["Red Pumpkin (2021)"] = { val = 11, rarity = "Pets" },
    ["Red Scratch"] = { val = 5, rarity = "Legendary" },
    ["Red Seer"] = { val = 4, rarity = "Godly" },
    ["Reindeer"] = { val = 10, rarity = "Pets" },
    ["Reptile"] = { val = 0.8, rarity = "Common" },
    ["Retro"] = { val = 0.15, rarity = "Uncommon" },
    ["Ribbon"] = { val = 0.12, rarity = "Common" },
    ["Ribbons"] = { val = 0.25, rarity = "Common" },
    ["Ripper (Gun)"] = { val = 0.45, rarity = "Legendary" },
    ["Ripper (Knife)"] = { val = 0.8, rarity = "Legendary" },
    ["Ritual"] = { val = 0.25, rarity = "Rare" },
    ["Robot"] = { val = 0.25, rarity = "Rare" },
    ["Rose"] = { val = 0.25, rarity = "Uncommon" },
    ["Roses"] = { val = 0.8, rarity = "Common" },
    ["Rudolph"] = { val = 10, rarity = "Pets" },
    ["Rune"] = { val = 0.5, rarity = "Legendary" },
    ["Rupture"] = { val = 0.8, rarity = "Legendary" },
    ["Sakura"] = { val = 1629, rarity = "Godly" },
    ["Sammy"] = { val = 1, rarity = "Pets" },
    ["Sandy"] = { val = 0.05, rarity = "Common" },
    ["Sandy (Gun)"] = { val = 0.1, rarity = "Common" },
    ["Santa"] = { val = 0.15, rarity = "Common" },
    ["Santa (2018)"] = { val = 0.1, rarity = "Common" },
    ["Santa (2023)"] = { val = 0.15, rarity = "Common" },
    ["Santa (Gun)"] = { val = 0.8, rarity = "Common" },
    ["Santa (Knife)"] = { val = 0.8, rarity = "Common" },
    ["Santa Dog"] = { val = 0.15, rarity = "Pets" },
    ["Santa's Magic"] = { val = 4, rarity = "Legendary" },
    ["Santa's Spirit"] = { val = 4, rarity = "Legendary" },
    ["Saw"] = { val = 10, rarity = "Godly" },
    ["Scarecrow"] = { val = 0.25, rarity = "Pets" },
    ["Scarf"] = { val = 0.23, rarity = "Common" },
    ["Seahorsey"] = { val = 11, rarity = "Pets" },
    ["Seer"] = { val = 4, rarity = "Godly" },
    ["Shaded"] = { val = 0.05, rarity = "Common" },
    ["Shadow"] = { val = 8, rarity = "Vintage" },
    ["Shadow Pumpkin"] = { val = 3, rarity = "Pets" },
    ["Shark"] = { val = 27, rarity = "Godly" },
    ["Sharky"] = { val = 0.38, rarity = "Rare" },
    ["Shiny"] = { val = 0.5, rarity = "Legendary" },
    ["Sidewinder"] = { val = 10, rarity = "Common" },
    ["Silent Night (Gun)"] = { val = 16, rarity = "Rare" },
    ["Silent Night (Knife)"] = { val = 68, rarity = "Rare" },
    ["Skeleton Key"] = { val = 7, rarity = "Other" },
    ["Skelly"] = { val = 1, rarity = "Pets" },
    ["Sketch"] = { val = 0.2, rarity = "Uncommon" },
    ["Sketchy"] = { val = 5, rarity = "Common" },
    ["Skool"] = { val = 11, rarity = "Common" },
    ["Skulls"] = { val = 16, rarity = "Uncommon" },
    ["Skully"] = { val = 11, rarity = "Pets" },
    ["Skyline"] = { val = 0.1, rarity = "Common" },
    ["Slashed"] = { val = 0.25, rarity = "Common" },
    ["Slasher"] = { val = 23, rarity = "Godly" },
    ["Slate"] = { val = 0.05, rarity = "Common" },
    ["Sleigh"] = { val = 0.25, rarity = "Rare" },
    ["Slime (Gun)"] = { val = 4, rarity = "Common" },
    ["Slime (Knife)"] = { val = 5, rarity = "Common" },
    ["Slimy"] = { val = 1, rarity = "Common" },
    ["Snakebite (Gun)"] = { val = 1, rarity = "Rare" },
    ["Snakebite (Knife)"] = { val = 4, rarity = "Rare" },
    ["Snow Dagger"] = { val = 356, rarity = "Godly" },
    ["Snowball (Gun)"] = { val = 0.1, rarity = "Common" },
    ["Snowball (Knife)"] = { val = 0.1, rarity = "Common" },
    ["Snowbear"] = { val = 0.25, rarity = "Pets" },
    ["Snowcannon"] = { val = 1266, rarity = "Godly" },
    ["Snowfall"] = { val = 0.1, rarity = "Common" },
    ["Snowflake"] = { val = 14, rarity = "Uncommon" },
    ["Snowflake (Gun)"] = { val = 0.23, rarity = "Uncommon" },
    ["Snowflake 2022 (Gun)"] = { val = 0.23, rarity = "Uncommon" },
    ["Snowflake 2022 (Knife)"] = { val = 0.25, rarity = "Uncommon" },
    ["Snowflake Key"] = { val = 0.45, rarity = "Other" },
    ["Snowflakes"] = { val = 1, rarity = "Rare" },
    ["Snowflakes (Gun)"] = { val = 21, rarity = "Common" },
    ["Snowflakes (Knife)"] = { val = 0.25, rarity = "Common" },
    ["Snowglobe"] = { val = 0.25, rarity = "Rare" },
    ["Snowman (2018)"] = { val = 0.1, rarity = "Common" },
    ["Snowman (2023)"] = { val = 0.15, rarity = "Uncommon" },
    ["Snowman (2024)"] = { val = 0.15, rarity = "Uncommon" },
    ["Snowman (Gun)"] = { val = 0.45, rarity = "Uncommon" },
    ["Snowman (Knife)"] = { val = 0.15, rarity = "Uncommon" },
    ["Snowman 2022 (Gun)"] = { val = 0.12, rarity = "Common" },
    ["Snowman 2022 (Knife)"] = { val = 0.1, rarity = "Common" },
    ["Snowman Gun"] = { val = 27, rarity = "Common" },
    ["Snowstorm"] = { val = 219, rarity = "Godly" },
    ["Snowy"] = { val = 0.8, rarity = "Uncommon" },
    ["Soda"] = { val = 0.2, rarity = "Uncommon" },
    ["Soda (Gun)"] = { val = 0.23, rarity = "Uncommon" },
    ["Soda (Knife)"] = { val = 0.15, rarity = "Uncommon" },
    ["Soul"] = { val = 548, rarity = "Godly" },
    ["Space"] = { val = 0.3, rarity = "Rare" },
    ["Sparkle"] = { val = 0.6, rarity = "Legendary" },
    ["Sparkle1"] = { val = 4, rarity = "Common" },
    ["Sparkle10"] = { val = 27, rarity = "Common" },
    ["Sparkle2"] = { val = 4, rarity = "Common" },
    ["Sparkle3"] = { val = 4, rarity = "Common" },
    ["Sparkle4"] = { val = 14, rarity = "Common" },
    ["Sparkle5"] = { val = 11, rarity = "Common" },
    ["Sparkle6"] = { val = 16, rarity = "Common" },
    ["Sparkle7"] = { val = 25, rarity = "Common" },
    ["Sparkle8"] = { val = 27, rarity = "Common" },
    ["Sparkle9"] = { val = 41, rarity = "Common" },
    ["Spearmint (Gun)"] = { val = 0.38, rarity = "Rare" },
    ["Spearmint (Knife)"] = { val = 0.38, rarity = "Rare" },
    ["Spectral (Gun)"] = { val = 4, rarity = "Legendary" },
    ["Spectral (Knife)"] = { val = 34, rarity = "Legendary" },
    ["Spectre"] = { val = 55, rarity = "Godly" },
    ["Spectrum"] = { val = 0.3, rarity = "Rare" },
    ["Spider"] = { val = 14, rarity = "Godly" },
    ["Spider (2023)"] = { val = 0.1, rarity = "Common" },
    ["Spirit"] = { val = 534, rarity = "Godly" },
    ["Spitfire"] = { val = 0.25, rarity = "Rare" },
    ["Splash (Gun)"] = { val = 0.38, rarity = "Legendary" },
    ["Splash (Knife)"] = { val = 0.5, rarity = "Legendary" },
    ["Splat"] = { val = 0.05, rarity = "Common" },
    ["Splatter"] = { val = 0.05, rarity = "Common" },
    ["Splitter"] = { val = 4, rarity = "Vintage" },
    ["Spring"] = { val = 0.38, rarity = "Rare" },
    ["Squire"] = { val = 0.3, rarity = "Rare" },
    ["Stainless"] = { val = 0.05, rarity = "Common" },
    ["Stalker"] = { val = 0.2, rarity = "Uncommon" },
    ["Star"] = { val = 0.05, rarity = "Common" },
    ["Starfish (Gun)"] = { val = 0.1, rarity = "Common" },
    ["Starfish (Knife)"] = { val = 0.1, rarity = "Common" },
    ["Starry"] = { val = 0.25, rarity = "Common" },
    ["Starry (Gun)"] = { val = 16, rarity = "Rare" },
    ["Starry (Knife)"] = { val = 0.8, rarity = "Rare" },
    ["Stars (Gun)"] = { val = 0.23, rarity = "Uncommon" },
    ["Stars (Knife)"] = { val = 0.45, rarity = "Uncommon" },
    ["Static"] = { val = 0.05, rarity = "Common" },
    ["Steambird"] = { val = 1, rarity = "Pets" },
    ["Steel (Gun)"] = { val = 0.45, rarity = "Uncommon" },
    ["Steel (Knife)"] = { val = 0.15, rarity = "Uncommon" },
    ["Stickers"] = { val = 0.1, rarity = "Common" },
    ["Stickers (Gun)"] = { val = 0.1, rarity = "Common" },
    ["Stickers (Knife)"] = { val = 0.1, rarity = "Common" },
    ["Stockings"] = { val = 0.1, rarity = "Common" },
    ["Stockings (2024)"] = { val = 0.1, rarity = "Common" },
    ["Stockings (Gun)"] = { val = 0.15, rarity = "Uncommon" },
    ["Stockings (Knife)"] = { val = 0.23, rarity = "Uncommon" },
    ["Storm"] = { val = 0.38, rarity = "Rare" },
    ["Strawberries (Gun)"] = { val = 0.1, rarity = "Common" },
    ["Strawberries (Knife)"] = { val = 0.1, rarity = "Common" },
    ["Striped (Gun)"] = { val = 0.1, rarity = "Common" },
    ["Striped (Knife)"] = { val = 0.1, rarity = "Common" },
    ["Sub"] = { val = 4, rarity = "Common" },
    ["Sugar"] = { val = 52, rarity = "Godly" },
    ["Sun"] = { val = 3, rarity = "Rare" },
    ["Sunny"] = { val = 0.38, rarity = "Rare" },
    ["Sunrise"] = { val = 1369, rarity = "Godly" },
    ["Sunset"] = { val = 719, rarity = "Godly" },
    ["Sunset (Gun)"] = { val = 0.25, rarity = "Rare" },
    ["Sunset Gun"] = { val = 0.5, rarity = "Rare" },
    ["Sweater"] = { val = 0.23, rarity = "Uncommon" },
    ["Sweater (Gun)"] = { val = 0.15, rarity = "Uncommon" },
    ["Sweater (Knife)"] = { val = 0.23, rarity = "Uncommon" },
    ["Sweet"] = { val = 226, rarity = "Godly" },
    ["Sweetheart"] = { val = 0.8, rarity = "Common" },
    ["Swirl"] = { val = 11, rarity = "Rare" },
    ["Swirly Axe"] = { val = 57, rarity = "Ancient" },
    ["Swirly Blade"] = { val = 21, rarity = "Godly" },
    ["Swirly Gun"] = { val = 31, rarity = "Godly" },
    ["TNL"] = { val = 0.6, rarity = "Common" },
    ["Tailslide"] = { val = 11, rarity = "Common" },
    ["Tankie"] = { val = 10, rarity = "Pets" },
    ["Teddy"] = { val = 0.25, rarity = "Pets" },
    ["Tides"] = { val = 14, rarity = "Godly" },
    ["Tiger"] = { val = 0.2, rarity = "Uncommon" },
    ["Toxic (Gun)"] = { val = 3, rarity = "Rare" },
    ["Toxic (Knife)"] = { val = 10, rarity = "Rare" },
    ["Toy (Gun)"] = { val = 0.12, rarity = "Common" },
    ["Toy (Knife)"] = { val = 0.38, rarity = "Common" },
    ["Traveler (Gun)"] = { val = 41, rarity = "Legendary" },
    ["Traveler (Knife)"] = { val = 3, rarity = "Legendary" },
    ["Traveler's Axe"] = { val = 11500, rarity = "Ancient" },
    ["Traveler's Gun"] = { val = 6297, rarity = "Godly" },
    ["Traveller"] = { val = 1, rarity = "Pets" },
    ["Treat"] = { val = 233, rarity = "Godly" },
    ["Treats (Gun)"] = { val = 0.23, rarity = "Uncommon" },
    ["Treats (Knife)"] = { val = 0.15, rarity = "Uncommon" },
    ["Tree (2017)"] = { val = 0.23, rarity = "Uncommon" },
    ["Tree (2021)"] = { val = 0.45, rarity = "Uncommon" },
    ["Tree (2023)"] = { val = 0.38, rarity = "Rare" },
    ["Tree (Gun)"] = { val = 0.25, rarity = "Rare" },
    ["Tree (Knife)"] = { val = 0.38, rarity = "Rare" },
    ["Trees"] = { val = 0.1, rarity = "Common" },
    ["Tropical"] = { val = 0.38, rarity = "Rare" },
    ["Tulip"] = { val = 0.8, rarity = "Common" },
    ["Turkey"] = { val = 3354, rarity = "Godly" },
    ["Turtle"] = { val = 0.15, rarity = "Uncommon" },
    ["UFO"] = { val = 5, rarity = "Pets" },
    ["UFOs (Gun)"] = { val = 0.1, rarity = "Common" },
    ["UFOs (Knife)"] = { val = 0.15, rarity = "Common" },
    ["Universe"] = { val = 0.5, rarity = "Legendary" },
    ["Valentine"] = { val = 0.8, rarity = "Common" },
    ["Vampire"] = { val = 1, rarity = "Uncommon" },
    ["Vampire (Gun)"] = { val = 10, rarity = "Rare" },
    ["Vampire (Knife)"] = { val = 1, rarity = "Rare" },
    ["Vampire Bat"] = { val = 10, rarity = "Pets" },
    ["Vampire's Axe"] = { val = 1266, rarity = "Ancient" },
    ["Vampire's Edge"] = { val = 21, rarity = "Godly" },
    ["Vampire's Gun"] = { val = 2327, rarity = "Godly" },
    ["Vines (Gun)"] = { val = 0.1, rarity = "Common" },
    ["Vines (Knife)"] = { val = 0.12, rarity = "Common" },
    ["Viper"] = { val = 0.5, rarity = "Legendary" },
    ["Virtual"] = { val = 21, rarity = "Godly" },
    ["Void"] = { val = 14, rarity = "Uncommon" },
    ["Vortex"] = { val = 0.3, rarity = "Rare" },
    ["Wanwood"] = { val = 0.2, rarity = "Uncommon" },
    ["Watcher (Gun)"] = { val = 0.15, rarity = "Common" },
    ["Watcher (Knife)"] = { val = 0.1, rarity = "Common" },
    ["Watergun"] = { val = 267, rarity = "Godly" },
    ["Waves"] = { val = 0.25, rarity = "Rare" },
    ["Wavy (Gun)"] = { val = 0.12, rarity = "Common" },
    ["Wavy (Knife)"] = { val = 0.15, rarity = "Common" },
    ["Web"] = { val = 0.8, rarity = "Legendary" },
    ["Webbed (Gun)"] = { val = 7, rarity = "Common" },
    ["Webbed (Knife)"] = { val = 0.25, rarity = "Common" },
    ["Webs"] = { val = 0.12, rarity = "Common" },
    ["Whiteout"] = { val = 0.05, rarity = "Common" },
    ["Winter's Edge"] = { val = 7, rarity = "Godly" },
    ["Witch"] = { val = 1, rarity = "Common" },
    ["Witch's Brew"] = { val = 0.15, rarity = "Uncommon" },
    ["Witchbrew"] = { val = 0.23, rarity = "Uncommon" },
    ["Witched"] = { val = 4, rarity = "Legendary" },
    ["Wolf"] = { val = 1, rarity = "Uncommon" },
    ["Wood"] = { val = 0.1, rarity = "Common" },
    ["Wooden"] = { val = 0.2, rarity = "Uncommon" },
    ["Wraith (Gun)"] = { val = 0.25, rarity = "Rare" },
    ["Wraith (Knife)"] = { val = 0.6, rarity = "Rare" },
    ["Wraiths (Gun)"] = { val = 0.23, rarity = "Uncommon" },
    ["Wraiths (Knife)"] = { val = 0.25, rarity = "Uncommon" },
    ["Wrap (Gun)"] = { val = 1, rarity = "Uncommon" },
    ["Wrap (Knife)"] = { val = 1, rarity = "Uncommon" },
    ["Wrapped (Gun)"] = { val = 0.8, rarity = "Uncommon" },
    ["Wrapped (Knife)"] = { val = 0.1, rarity = "Common" },
    ["Wrapped Gun"] = { val = 27, rarity = "Common" },
    ["Wrapped Gun (2024)"] = { val = 0.25, rarity = "Uncommon" },
    ["Wrapped Knife (2024)"] = { val = 0.15, rarity = "Uncommon" },
    ["Wreaths"] = { val = 0.15, rarity = "Uncommon" },
    ["Xbox"] = { val = 0.1, rarity = "Common" },
    ["Xeno (Gun)"] = { val = 0.25, rarity = "Rare" },
    ["Xeno (Knife)"] = { val = 0.38, rarity = "Rare" },
    ["Xenoknife"] = { val = 274, rarity = "Godly" },
    ["Xenoshot"] = { val = 274, rarity = "Godly" },
    ["Xmas"] = { val = 11, rarity = "Godly" },
    ["Yellow"] = { val = 0.05, rarity = "Common" },
    ["Yellow Seer"] = { val = 3, rarity = "Godly" },
    ["Yummy"] = { val = 0.25, rarity = "Rare" },
    ["Zombie"] = { val = 7, rarity = "Common" },
    ["Zombie (2023)"] = { val = 0.6, rarity = "Uncommon" },
    ["Zombie (Gun)"] = { val = 11, rarity = "Uncommon" },
    ["Zombie (Knife)"] = { val = 3, rarity = "Uncommon" },
    ["Zombie Dog"] = { val = 1095, rarity = "Pets" },
    ["Zombified"] = { val = 41, rarity = "Rare" },
    ["Zombified (Gun)"] = { val = 21, rarity = "Uncommon" },
    ["Zombified (Knife)"] = { val = 96, rarity = "Uncommon" },
    ["iRevolver"] = { val = 0.3, rarity = "Rare" },
}

-- Pre-populate all items immediately on script start
for sName, sData in pairs(MM2_STATIC_VALUES) do
    storeItem(sData.rarity, sName, sData.val)
end

local function fetchMM2ValuesFromWeb()
    if isFetchingMM2Values or hasFetchedMM2Values then return end
    isFetchingMM2Values = true
    task.spawn(function()
        local categories = {
            { url = 'https://mm2checker.com/ancients.html',    rName = 'Ancient'   },
            { url = 'https://mm2checker.com/vintages.html',    rName = 'Vintage'   },
            { url = 'https://mm2checker.com/godlies.html',     rName = 'Godly'     },
            { url = 'https://mm2checker.com/legendaries.html', rName = 'Legendary' },
            { url = 'https://mm2checker.com/rares.html',       rName = 'Rare'      },
            { url = 'https://mm2checker.com/uncommons.html',   rName = 'Uncommon'  },
            { url = 'https://mm2checker.com/commons.html',     rName = 'Common'    },
            { url = 'https://mm2checker.com/pets.html',        rName = 'Pets'      },
            { url = 'https://mm2checker.com/other.html',       rName = 'Other'     },
        }

        local httpReq = (syn and syn.request)
            or (http and http.request)
            or http_request
            or (fluxus and fluxus.request)
            or request

        local function toBodyString(val)
            if type(val) == "string" then return val end
            if type(val) == "table" then
                local b = val.Body or val.body
                if type(b) == "string" then return b end
            end
            if typeof and typeof(val) == "Instance" then
                local ok, b = pcall(function() return val.Body or val.body or val.Value or val.Text end)
                if ok and type(b) == "string" then return b end
                return nil
            end
            return nil
        end

        for _, cat in ipairs(categories) do
            local html = nil

            -- 1. Try request / httpReq
            if httpReq then
                pcall(function()
                    local res = httpReq({
                        Url     = cat.url,
                        Method  = 'GET',
                        Headers = { ['User-Agent'] = 'Roblox/WinInet' },
                    })
                    html = toBodyString(res)
                end)
            end

            -- 2. Try game:HttpGet only if needed and game.HttpGet is a function
            if not html and game and type(game.HttpGet) == "function" then
                pcall(function()
                    local res = game:HttpGet(cat.url)
                    html = toBodyString(res)
                end)
            end

            if type(html) == "string" and #html > 0 then
                local pos = 1
                while true do
                    local idStart, idEnd, itemName = html:find('<div%s+class="box"%s+id="([^"]+)"', pos)
                    if not idStart then break end
                    pos = idEnd + 1

                    local _, valEnd, rawVal = html:find(
                        '<span%s+class="itemvalue">([^<]+)</span>',
                        idEnd
                    )
                    if valEnd then
                        local cleanVal = rawVal:gsub(',', ''):gsub('%s+', '')
                        local numVal = tonumber(cleanVal)
                        if numVal and numVal > 0 then
                            storeItem(cat.rName, itemName, numVal)
                        end
                        pos = valEnd + 1
                    end
                end
            end

            task.wait(0.2)
        end

        hasFetchedMM2Values = true
        isFetchingMM2Values = false
    end)
end

-- background refresh
pcall(fetchMM2ValuesFromWeb)

-- asset-id -> full mm2checker name (for gun/knife disambiguation)
local MM2_ITEM_ASSET_MAP = {
    ["196749885"] = "Adurite (Knife)",
    ["196750197"] = "Bluesteel (Knife)",
    ["196750305"] = "Deathshard",
    ["196750384"] = "Default (Knife)",
    ["196750422"] = "Galaxy",
    ["196750668"] = "Ice",
    ["196750845"] = "Love (Knife)",
    ["196750899"] = "Plasmite",
    ["196750963"] = "Rainbow (Knife)",
    ["196751441"] = "Wanwood",
    ["196751515"] = "S1 Test Knife",
    ["196751752"] = "America",
    ["196751820"] = "Default (Gun)",
    ["196751943"] = "Laser",
    ["196751989"] = "Golden",
    ["196752052"] = "Cowboy",
    ["196752144"] = "Phaser",
    ["196752289"] = "Adurite (Gun)",
    ["196752330"] = "Big Kill",
    ["196752379"] = "Bluesteel (Gun)",
    ["196752456"] = "Camo (Gun)",
    ["196752499"] = "Cold",
    ["196752601"] = "Fallout",
    ["196752683"] = "Galactic",
    ["196752718"] = "Imbued",
    ["196752812"] = "Iron",
    ["196752926"] = "Viper",
    ["197499641"] = "Reptile",
    ["197626358"] = "Gifted",
    ["197638833"] = "Future",
    ["197656593"] = "Nether",
    ["197663897"] = "Midnight",
    ["197829003"] = "Night",
    ["197829561"] = "Spitfire",
    ["197830043"] = "Overseer (Gun)",
    ["197879343"] = "Corrupt",
    ["198042673"] = "Luger",
    ["198433893"] = "Linked",
    ["198434520"] = "Slate",
    ["198434881"] = "Borders",
    ["198439107"] = "Stalker",
    ["198439692"] = "Missing",
    ["198440101"] = "Cheesy",
    ["198440414"] = "Krypto",
    ["198441038"] = "Spectrum",
    ["198441413"] = "Overseer (Knife)",
    ["198441783"] = "Seer",
    ["198442811"] = "Fang",
    ["198443382"] = "Checker",
    ["198443956"] = "Damp",
    ["198444909"] = "Emerald",
    ["198566885"] = "Neon (Knife)",
    ["200953094"] = "Infected (Knife)",
    ["201238541"] = "Heat",
    ["201542790"] = "TNL",
    ["203806022"] = "Infiltrator",
    ["203807397"] = "Juice",
    ["203807690"] = "Engraved",
    ["203807904"] = "Star",
    ["203808108"] = "Sketch",
    ["203808190"] = "Marina",
    ["203808317"] = "Cheddar",
    ["203809168"] = "iRevolver",
    ["203810176"] = "Predator (Gun)",
    ["203819271"] = "Hacker",
    ["203858533"] = "Shark",
    ["203867650"] = "Love (Gun)",
    ["203869110"] = "Sparkle",
    ["203869308"] = "Molten (Gun)",
    ["235366460"] = "Clan",
    ["235366729"] = "Cardboard",
    ["235366771"] = "Stainless",
    ["235366815"] = "Donut",
    ["235366870"] = "Paper",
    ["235366945"] = "Circuit",
    ["235371276"] = "Doge",
    ["235371439"] = "Splash (Knife)",
    ["235371508"] = "Vortex",
    ["235371686"] = "Nova",
    ["235371809"] = "Molten (Knife)",
    ["235372015"] = "Predator (Knife)",
    ["235381341"] = "Saw",
    ["237336076"] = "Goo",
    ["238545971"] = "Pea",
    ["238546032"] = "News",
    ["238546100"] = "HL2",
    ["238546356"] = "Wooden",
    ["238546400"] = "Soda (Gun)",
    ["238546422"] = "Caution",
    ["238546467"] = "Bacon",
    ["238546577"] = "Ace",
    ["238546660"] = "Universe",
    ["238546983"] = "Laser",
    ["238549030"] = "Bit",
    ["241095344"] = "Elite",
    ["295269977"] = "Skool",
    ["305503783"] = "Sidewinder",
    ["305503942"] = "Grind",
    ["305504173"] = "Euro",
    ["305504399"] = "Ollie",
    ["305506822"] = "Tailslide",
    ["305506951"] = "Indy",
    ["306046703"] = "Prism",
    ["310709709"] = "Sparkle1",
    ["310710191"] = "Sparkle2",
    ["310710694"] = "Sparkle3",
    ["310712788"] = "Sparkle4",
    ["310713235"] = "Sparkle5",
    ["310713648"] = "Sparkle6",
    ["310714089"] = "Sparkle7",
    ["310714407"] = "Sparkle8",
    ["310715104"] = "Sparkle9",
    ["310715768"] = "Sparkle10",
    ["315099010"] = "Jack",
    ["315100702"] = "Rupture",
    ["315104004"] = "Web",
    ["315155591"] = "Mummy (Gun)",
    ["315500879"] = "Bleached",
    ["315501118"] = "Clown (Knife)",
    ["315501170"] = "Oily",
    ["315501208"] = "Aqua",
    ["315501297"] = "Hazmat",
    ["315501369"] = "Melon (Knife)",
    ["315501434"] = "Hive",
    ["315501501"] = "Korblox",
    ["315501560"] = "Squire",
    ["315501640"] = "Fade",
    ["315506122"] = "Slasher",
    ["331140746"] = "Cane (Knife)",
    ["331744703"] = "Ginger (Knife)",
    ["331745341"] = "Ornament2 (Knife)",
    ["331745428"] = "Ornament",
    ["331745500"] = "Wrapped (Knife)",
    ["331745577"] = "Tree (Knife)",
    ["331745799"] = "Snowman (Knife)",
    ["331746096"] = "Santa (Knife)",
    ["331746317"] = "Elf (Knife)",
    ["332011125"] = "Snowy",
    ["332021011"] = "Candy",
    ["332022166"] = "Chill",
    ["332044583"] = "Red Luger",
    ["332044679"] = "Green Luger",
    ["332496861"] = "Santa (Gun)",
    ["332497038"] = "Ginger (Gun)",
    ["332497103"] = "Wrapped (Gun)",
    ["332497144"] = "Ornament1",
    ["332497187"] = "Cane (Gun)",
    ["332497550"] = "Ornament2 (Gun)",
    ["332497603"] = "Snowman (Gun)",
    ["332497657"] = "Nutcracker",
    ["332497688"] = "Tree (Gun)",
    ["332731156"] = "Green Elite",
    ["332767999"] = "Elf (Gun)",
    ["332848695"] = "Sugar",
    ["363150149"] = "Valentine",
    ["363150334"] = "Passion",
    ["363150561"] = "Blossom (Knife)",
    ["363150761"] = "Sweetheart",
    ["363352002"] = "Roses",
    ["363352211"] = "Hearts",
    ["365567889"] = "Eco",
    ["365567962"] = "Log",
    ["365568056"] = "Sandy (Knife)",
    ["365568163"] = "Static",
    ["365568602"] = "Brush",
    ["365569126"] = "Jigsaw",
    ["365569265"] = "Lucky",
    ["365569428"] = "Abstract",
    ["365569566"] = "Musical",
    ["365569686"] = "Fusion",
    ["383476085"] = "Patrick",
    ["386276987"] = "Virtual",
    ["386277381"] = "Blaster",
    ["387874071"] = "Carrot (Knife)",
    ["387874365"] = "Bunny",
    ["387874661"] = "Tulip",
    ["387874991"] = "Choco",
    ["387875405"] = "Egg",
    ["435933179"] = "Cotton Candy",
    ["439325100"] = "Xbox",
    ["446050753"] = "Amerilaser",
    ["473569625"] = "Tides",
    ["473570051"] = "Old Glory",
    ["473570519"] = "Clockwork",
    ["473571549"] = "Spider",
    ["473572138"] = "Handsaw",
    ["473572568"] = "Xmas",
    ["473573054"] = "Pixel",
    ["473573464"] = "Blood",
    ["473574001"] = "Splitter",
    ["473574401"] = "Ghost (Knife)",
    ["473575049"] = "Prince",
    ["473625645"] = "Brown",
    ["473625785"] = "Green",
    ["473625906"] = "Yellow",
    ["473626025"] = "Orange",
    ["473626150"] = "Red",
    ["473626317"] = "Blue",
    ["473626473"] = "Pink",
    ["473626646"] = "Black",
    ["473626740"] = "Purple",
    ["473626979"] = "Shiny",
    ["474030882"] = "Shadow",
    ["475478854"] = "Nightblade",
    ["476599365"] = "Asteroid",
    ["531873011"] = "Orange Marble",
    ["531873080"] = "Ghosty",
    ["531873154"] = "Moons",
    ["531873248"] = "Vampire (Knife)",
    ["531873371"] = "Scratch",
    ["531873487"] = "Wolf",
    ["531873553"] = "Witch",
    ["531873625"] = "Bats (Knife)",
    ["531873816"] = "Bones (Knife)",
    ["531873956"] = "Brains (Knife)",
    ["531878205"] = "Hallow's Edge",
    ["546159020"] = "Alex",
    ["546159250"] = "Sub",
    ["546161062"] = "Denis",
    ["546161470"] = "Sketchy",
    ["546161858"] = "Corl",
    ["566867312"] = "JD",
    ["585872642"] = "Ice Dragon",
    ["585873746"] = "Flames",
    ["619605312"] = "Eternal",
    ["1132775323"] = "Hallow's Blade",
    ["1133237368"] = "BattleAxe",
    ["1133316381"] = "Scratch",
    ["1133317890"] = "Magma (Knife)",
    ["1133325465"] = "Webs (Knife)",
    ["1133331679"] = "Ecto",
    ["1133331885"] = "Zombie (Knife)",
    ["1133332075"] = "Phantom",
    ["1133337797"] = "CandyCorn",
    ["1133352032"] = "Mummy (Knife)",
    ["1133366632"] = "Potion (Knife)",
    ["1133366830"] = "Green Marble",
    ["1138143590"] = "Pumpking",
    ["1268699212"] = "Present",
    ["1268699677"] = "Coal (Knife)",
    ["1268703023"] = "Elf (Knife)",
    ["1268703618"] = "Santa (Knife)",
    ["1268704124"] = "Tree (Knife)",
    ["1268704507"] = "Frosty",
    ["1268704902"] = "Sweater (Knife)",
    ["1268705527"] = "Gingerbread (Knife)",
    ["1268705947"] = "Snowy",
    ["1268706374"] = "Green Fire",
    ["1268708987"] = "Winter's Edge",
    ["1268710824"] = "Ice Shard",
    ["1268932977"] = "Snowflake (Knife)",
    ["1269256860"] = "Red Fire",
    ["1269374321"] = "Blue Elite",
    ["1269580035"] = "Frostsaber",
    ["1489495701"] = "Blue Candy",
    ["1520188792"] = "Gold Candy",
    ["1520189487"] = "Bronze Candy",
    ["1520190188"] = "Silver Candy",
    ["2511340308"] = "Gold Hallow",
    ["2511341094"] = "Silver Hallow",
    ["2511342846"] = "Bronze Hallow",
    ["2511343130"] = "Red Hallow",
    ["2511791893"] = "Batwing",
    ["2513505477"] = "Boneblade",
    ["2513535503"] = "BattleAxe II",
    ["2513598419"] = "Boneblade",
    ["2513728474"] = "Grave (Knife)",
    ["2513731746"] = "Grave (Gun)",
    ["2513732731"] = "Bats (Knife)",
    ["2513732969"] = "Ghost (Knife)",
    ["2513733542"] = "Mummy (Knife)",
    ["2513733741"] = "Haunted (Knife)",
    ["2513733987"] = "Potion (Knife)",
    ["2513734227"] = "Slime (Knife)",
    ["2513734535"] = "Toxic (Knife)",
    ["2513734708"] = "Vampire (Knife)",
    ["2513734908"] = "Zombie (Knife)",
    ["2513741174"] = "Bats (Gun)",
    ["2513741407"] = "Ghost (Gun)",
    ["2513741663"] = "Mummy (Gun)",
    ["2513741901"] = "Haunted (Gun)",
    ["2513742133"] = "Potion (Gun)",
    ["2513742319"] = "Slime (Gun)",
    ["2513742519"] = "Toxic (Gun)",
    ["2513742751"] = "Vampire (Gun)",
    ["2513743298"] = "Zombie (Gun)",
    ["2533351841"] = "Nik's Scythe",
    ["2545253030"] = "Eternal II",
    ["2669336659"] = "Gingerblade",
    ["2669637780"] = "Santa (Knife)",
    ["2669638285"] = "Coal (Knife)",
    ["2669638508"] = "Cane (Knife)",
    ["2669638742"] = "Ginger (Knife)",
    ["2669638990"] = "Holly (Knife)",
    ["2669639638"] = "Icicles (Knife)",
    ["2669639913"] = "Snowflake (Knife)",
    ["2669640152"] = "Snowman (Knife)",
    ["2669640357"] = "Wrapped (Knife)",
    ["2669640567"] = "Sweater (Knife)",
    ["2669784920"] = "Coal (Gun)",
    ["2669785184"] = "Elf (Gun)",
    ["2669785546"] = "Cane (Gun)",
    ["2669785821"] = "Ginger (Gun)",
    ["2669786044"] = "Icicles (Gun)",
    ["2669786261"] = "Holly (Gun)",
    ["2669786515"] = "Snowflake (Gun)",
    ["2669786846"] = "Snowman (Gun)",
    ["2669787088"] = "Sweater (Gun)",
    ["2669787533"] = "Wrapped (Gun)",
    ["2672349340"] = "Gingerblade",
    ["2674983099"] = "Ginger Luger",
    ["3183085102"] = "Icewing",
    ["3183597816"] = "Gemstone",
    ["3183598040"] = "Gemstone",
    ["3183604570"] = "Combat",
    ["3183605392"] = "Copper",
    ["3183605810"] = "Hardened",
    ["3183606225"] = "Camo (Knife)",
    ["3183606579"] = "Tiger",
    ["3183607442"] = "Space",
    ["3183607894"] = "Rune",
    ["3183639522"] = "Splat",
    ["3183639867"] = "Pirate",
    ["3183640145"] = "Rainbow (Gun)",
    ["3184122829"] = "Red Seer",
    ["3184124504"] = "Orange Seer",
    ["3184124768"] = "Yellow Seer",
    ["3184125087"] = "Blue Seer",
    ["3184125244"] = "Purple Seer",
    ["3184125538"] = "Seer",
    ["3187390667"] = "Deathshard",
    ["3187392501"] = "Fang",
    ["3187392992"] = "Saw",
    ["3187393285"] = "Slasher",
    ["3187394934"] = "Tides",
    ["3187395238"] = "Heat",
    ["3187395551"] = "Luger",
    ["3187395738"] = "Shark",
    ["3187395952"] = "Laser",
    ["3215260149"] = "Gold Sugar",
    ["3215261680"] = "Silver Sugar",
    ["3215261913"] = "Bronze Sugar",
    ["3215262120"] = "Blue Sugar",
    ["3279011390"] = "Eternal III",
    ["4210915060"] = "Skulls",
    ["4210920512"] = "Dungeon",
    ["4210925026"] = "Snakebite (Gun)",
    ["4210926347"] = "Bones (Gun)",
    ["4210928053"] = "Zombified (Knife)",
    ["4210929184"] = "Brains (Knife)",
    ["4210931354"] = "Pumpkin (Knife)",
    ["4210932676"] = "Slimy",
    ["4210934082"] = "Candy Corn (Knife)",
    ["4210936652"] = "Webbed (Gun)",
    ["4210938270"] = "Witched",
    ["4210939388"] = "Snakebite (Knife)",
    ["4210941474"] = "Monster (Gun)",
    ["4210943691"] = "Branches",
    ["4210944924"] = "Zombified (Gun)",
    ["4210946577"] = "Mummified",
    ["4210947993"] = "RIP",
    ["4210949599"] = "Webbed (Knife)",
    ["4211142894"] = "Elderwood Revolver",
    ["4211148191"] = "Elderwood Scythe",
    ["4221789003"] = "Ghostblade",
    ["4468574885"] = "Blue Elderwood (Gun)",
    ["4468583758"] = "Silver Elderwood (Gun)",
    ["4468584345"] = "Gold Elderwood (Gun)",
    ["4468585407"] = "Bronze Elderwood (Gun)",
    ["4488391411"] = "Eternalcane",
    ["4528484880"] = "Frostbite",
    ["4534853444"] = "Frosted (Knife)",
    ["4534855045"] = "Snowflakes (Knife)",
    ["4534855710"] = "Pine (Knife)",
    ["4534856285"] = "Gifts (Knife)",
    ["4534856940"] = "Gingerbread (Knife)",
    ["4534857523"] = "Frozen (Knife)",
    ["4534858185"] = "Lights (Knife)",
    ["4534860226"] = "Candy Swirl (Knife)",
    ["4534860689"] = "Aurora (Knife)",
    ["4534861110"] = "Cavern (Knife)",
    ["4534866065"] = "Snowflakes (Gun)",
    ["4534866678"] = "Frosted (Gun)",
    ["4534867381"] = "Gifts (Gun)",
    ["4534871260"] = "Pine (Gun)",
    ["4534872116"] = "Gingerbread (Gun)",
    ["4534872673"] = "Lights (Gun)",
    ["4534873956"] = "Frozen (Gun)",
    ["4534874602"] = "Candy Swirl (Gun)",
    ["4534875165"] = "Aurora (Gun)",
    ["4534875511"] = "Cavern (Gun)",
    ["4535408229"] = "Minty",
    ["4535482609"] = "Lugercane",
    ["4535483042"] = "Santa's Magic",
    ["4535644282"] = "Logchopper",
    ["4659626370"] = "Splash (Gun)",
    ["4659626966"] = "Nightfire",
    ["4659627458"] = "Bio (Gun)",
    ["4659627976"] = "Clown (Gun)",
    ["4659634072"] = "Deep Sea",
    ["4659634630"] = "Graffiti",
    ["4659635055"] = "High Tech",
    ["4659635584"] = "Lovely",
    ["4659636085"] = "Shaded",
    ["4659636452"] = "Leaf",
    ["4749070432"] = "Lightbringer",
    ["4749071819"] = "???",
    ["4751500761"] = "Lightbringer",
    ["4751501078"] = "Darkbringer",
    ["4751539262"] = "Bioblade",
    ["4753346087"] = "Silver Minty",
    ["4753347062"] = "Blue Minty",
    ["4753347636"] = "Gold Minty",
    ["4753348263"] = "Bronze Minty",
    ["4753352581"] = "Silver Logchopper",
    ["4753353471"] = "Blue Logchopper",
    ["4753354123"] = "Bronze Logchopper",
    ["4753354638"] = "Gold Logchopper",
    ["4972196241"] = "Combat II",
    ["4999958740"] = "Eternal IV",
    ["5360359935"] = "Prismatic",
    ["5866435364"] = "Candy Corn (Knife)",
    ["5866436906"] = "Carved (Knife)",
    ["5866438542"] = "Watcher (Knife)",
    ["5866441301"] = "Ripper (Knife)",
    ["5866442790"] = "Ghosts (Knife)",
    ["5866444722"] = "Portal (Knife)",
    ["5866447521"] = "Mummy (Knife)",
    ["5866454590"] = "Candy Corn (Gun)",
    ["5866457985"] = "Carved (Gun)",
    ["5866459380"] = "Watcher (Gun)",
    ["5866460591"] = "Ripper (Gun)",
    ["5866461926"] = "Portal (Gun)",
    ["5866463755"] = "Mummy (Gun)",
    ["5866465099"] = "Ghosts (Gun)",
    ["5872490600"] = "Pumpkin (Knife)",
    ["5872491708"] = "Candle",
    ["5872492951"] = "Bones (Knife)",
    ["5873256998"] = "Vampire's Edge",
    ["5877016863"] = "Hallowscythe",
    ["5878721461"] = "Hallowgun",
    ["5929317433"] = "Slashed",
    ["5930729222"] = "Bats (Knife)",
    ["5930731295"] = "Starry (Gun)",
    ["5984754897"] = "RB Knife",
    ["6084838617"] = "Gold Vamp's Edge",
    ["6084840560"] = "Silver Vamp's Edge",
    ["6084842077"] = "Bronze Vamp's Edge",
    ["6084854835"] = "Blue Vamp's Edge",
    ["6085035357"] = "Peppermint (Knife)",
    ["6121847170"] = "Gift Bag (Knife)",
    ["6121848805"] = "Icecracker",
    ["6121850031"] = "Gingerbread (Knife)",
    ["6121851313"] = "Silent Night (Knife)",
    ["6121853160"] = "Ornaments (Knife)",
    ["6121854816"] = "Wrap (Knife)",
    ["6121860619"] = "Gingerbread (Gun)",
    ["6121862034"] = "Silent Night (Gun)",
    ["6121863515"] = "Ornaments (Gun)",
    ["6121864813"] = "Gift Bag (Gun)",
    ["6121866490"] = "Icedriller",
    ["6121867603"] = "Wrap (Gun)",
    ["6123335682"] = "Stockings (Knife)",
    ["6123336879"] = "Trees",
    ["6123338102"] = "Snowflakes (Knife)",
    ["6123357775"] = "Santa's Spirit",
    ["6125729383"] = "Icebreaker",
    ["6125733703"] = "Cookieblade",
    ["6125742758"] = "Jinglegun",
    ["6125814417"] = "Iceblaster",
    ["6404115112"] = "Gold Icebreaker",
    ["6404126280"] = "Silver Icebreaker",
    ["6404127119"] = "Bronze Icebreaker",
    ["6404129111"] = "Red Icebreaker",
    ["6404165933"] = "Gold Iceblaster",
    ["6404166698"] = "Silver Iceblaster",
    ["6404167442"] = "Bronze Iceblaster",
    ["6404168049"] = "Red Iceblaster",
    ["6413145922"] = "Heartblade",
    ["6598123521"] = "Nebula",
    ["6607277825"] = "Eggblade",
    ["6711852603"] = "Cherry",
    ["6967771328"] = "SharkSeeker",
    ["7791485669"] = "Reaver",
    ["7791511648"] = "Reaver",
    ["7791640819"] = "Reaver",
    ["7800220325"] = "Skulls",
    ["7800221141"] = "Gothic (Knife)",
    ["7800222135"] = "Haunted (Knife)",
    ["7800222975"] = "Zombie (Knife)",
    ["7800224197"] = "Moon",
    ["7800224981"] = "Cracks (Knife)",
    ["7800225996"] = "Magma (Knife)",
    ["7800226793"] = "Spectral (Knife)",
    ["7800227475"] = "Watcher (Knife)",
    ["7800229084"] = "Stickers (Knife)",
    ["7800250906"] = "Aliens",
    ["7800251557"] = "Wraiths (Gun)",
    ["7800252572"] = "Magma (Gun)",
    ["7800253444"] = "Cat",
    ["7800253970"] = "Gothic (Gun)",
    ["7800254737"] = "Cracks (Gun)",
    ["7800255531"] = "Spectral (Gun)",
    ["7800256309"] = "Watcher (Gun)",
    ["7800257010"] = "Stickers (Gun)",
    ["7800257544"] = "Fall Camo",
    ["7800847534"] = "Harvester",
    ["7805833970"] = "Candleflame (Knife)",
    ["7806121918"] = "Candleflame (Knife)",
    ["7808362279"] = "Wraiths (Knife)",
    ["8194217388"] = "Silver Harvester",
    ["8194219645"] = "Blue Harvester",
    ["8194221072"] = "Bronze Harvester",
    ["8194222523"] = "Gold Harvester",
    ["8304750295"] = "Cane (Knife)",
    ["8304750877"] = "Aurora (Knife)",
    ["8304751659"] = "Coal (Knife)",
    ["8304752586"] = "Cookie (Knife)",
    ["8304753468"] = "Snowman (Knife)",
    ["8304754179"] = "Giftwrap",
    ["8304754882"] = "Ribbons",
    ["8304755417"] = "Stickers (Knife)",
    ["8304756423"] = "Tree (Knife)",
    ["8304757110"] = "Swirl",
    ["8304757707"] = "Starry (Knife)",
    ["8304766165"] = "Aurora (Gun)",
    ["8304766932"] = "Snowman (Gun)",
    ["8304767724"] = "Ice Camo",
    ["8304768700"] = "Cane (Gun)",
    ["8304769409"] = "Coal (Gun)",
    ["8304770115"] = "Stickers (Gun)",
    ["8304771148"] = "Cookie (Gun)",
    ["8304772140"] = "Gingerbread (Gun)",
    ["8304772774"] = "Starry (Gun)",
    ["8304801000"] = "Swirly Axe",
    ["8304805693"] = "Swirly Blade",
    ["8304818186"] = "Iceflake",
    ["8305264097"] = "Swirly Gun",
    ["8311005531"] = "Icebeam",
    ["8311393414"] = "Swirly Gun",
    ["8626617523"] = "Dartbringer",
    ["9552048857"] = "Blue Swirly (Knife)",
    ["9552050165"] = "Bronze Swirly (Knife)",
    ["9552051805"] = "Silver Swirly (Knife)",
    ["9552054920"] = "Gold Swirly (Knife)",
    ["9552060741"] = "Blue Swirly (Gun)",
    ["9552063524"] = "Bronze Swirly (Gun)",
    ["9552064240"] = "Silver Swirly (Gun)",
    ["9552065167"] = "Gold Swirly (Gun)",
    ["10014680882"] = "Plasmablade",
    ["10014717343"] = "Plasmabeam",
    ["11117375743"] = "Ghostly",
    ["11229732037"] = "Phantom",
    ["11229779932"] = "Spectre",
    ["11229814357"] = "Bat",
    ["11229837140"] = "Makeshift (Gun)",
    ["11254057417"] = "Candy Corn (Knife)",
    ["11254065007"] = "Eyeball",
    ["11254067158"] = "Stickers (Knife)",
    ["11254081561"] = "Darkness (Knife)",
    ["11254083234"] = "Hazard (Knife)",
    ["11254093910"] = "Lantern",
    ["11254115609"] = "Witchbrew",
    ["11254118399"] = "Wraith (Knife)",
    ["11254123390"] = "Curse",
    ["11254125546"] = "Vampire (Knife)",
    ["11254145154"] = "Zombie Camo",
    ["11254146743"] = "Survivor Camo",
    ["11254152435"] = "Boney",
    ["11254154978"] = "Hunter",
    ["11254158802"] = "TestItem",
    ["11254172968"] = "Apocalypse (Knife)",
    ["11254175272"] = "Infected (Knife)",
    ["11254180750"] = "Makeshift (Knife)",
    ["11254182560"] = "Zombified (Knife)",
    ["11254975176"] = "Elderwood Blade",
    ["11255501940"] = "Apocalypse (Gun)",
    ["11255502768"] = "Infected (Gun)",
    ["11255503583"] = "Vampire (Gun)",
    ["11255504462"] = "Wraith (Gun)",
    ["11255505449"] = "Hazard (Gun)",
    ["11255507374"] = "Darkness (Gun)",
    ["11255558166"] = "Candy Corn (Gun)",
    ["11262771067"] = "Elderwood Blade",
    ["11284140034"] = "Ghostfire",
    ["11284143055"] = "Moonlight",
    ["11284145298"] = "Brains (Gun)",
    ["11284147880"] = "Webs (Gun)",
    ["11505913287"] = "Blue Elderwood (Knife)",
    ["11505914752"] = "Bronze Elderwood (Knife)",
    ["11505916486"] = "Silver Elderwood (Knife)",
    ["11505917850"] = "Gold Elderwood (Knife)",
    ["11548082732"] = "Void",
    ["11834384755"] = "Candied (Knife)",
    ["11834387858"] = "Stickers (Knife)",
    ["11834390120"] = "Coal (Knife)",
    ["11834391469"] = "Snowman (Knife)",
    ["11834392930"] = "Stockings (Knife)",
    ["11834394793"] = "Mistletoe (Knife)",
    ["11834397133"] = "Snowflake (Knife)",
    ["11834399071"] = "Gingerbread (Knife)",
    ["11834400185"] = "Tree (Knife)",
    ["11834401547"] = "Arctic (Knife)",
    ["11834403282"] = "Wrapped (Knife)",
    ["11834404402"] = "Frozen (Knife)",
    ["11834432971"] = "Stickers (Gun)",
    ["11834434264"] = "Coal (Gun)",
    ["11834435627"] = "Candied (Gun)",
    ["11834436620"] = "Snowman (Gun)",
    ["11834437796"] = "Snowflake (Gun)",
    ["11834438982"] = "Mistletoe (Gun)",
    ["11834440319"] = "Stockings (Gun)",
    ["11834441321"] = "Tree (Gun)",
    ["11834442414"] = "Gingerbread (Gun)",
    ["11834443783"] = "Arctic (Gun)",
    ["11834445016"] = "Frozen (Gun)",
    ["11855274019"] = "Icecrusher",
    ["11855282546"] = "Icecrusher",
    ["11855306927"] = "Cookiecane",
    ["11855361567"] = "Icecrusher",
    ["11872179646"] = "Gingermint",
    ["11873640255"] = "Cookiecane",
    ["11874071041"] = "Icepiercer",
    ["12226688172"] = "Gold Icepiercer",
    ["12226843957"] = "Silver Icepiercer",
    ["12226920195"] = "Bronze Icepiercer",
    ["12227133450"] = "Red Icepiercer",
    ["12227137860"] = "Gold Icecrusher",
    ["12227142478"] = "Silver Icecrusher",
    ["12227148356"] = "Bronze Icecrusher",
    ["12227186408"] = "Red Icecrusher",
    ["12339323856"] = "Broken",
    ["12339325736"] = "Rose",
    ["12339327069"] = "Heart",
    ["12339328595"] = "Love (Knife)",
    ["12339366064"] = "Sakura",
    ["12339377105"] = "Blossom (Gun)",
    ["12965294432"] = "Fragile (Knife)",
    ["12965298174"] = "Bio (Knife)",
    ["12965302237"] = "Marble",
    ["12965304445"] = "Chromatic (Knife)",
    ["12965307410"] = "Carrot (Knife)",
    ["12965311567"] = "Painted (Knife)",
    ["12965335931"] = "Nuke",
    ["12965339774"] = "Chromatic (Gun)",
    ["12965344675"] = "Painted (Gun)",
    ["12965349193"] = "Fragile (Gun)",
    ["12966184630"] = "Rainbow (Knife)",
    ["12966354606"] = "Rainbow (Gun)",
    ["13944127959"] = "Toy (Knife)",
    ["13944129596"] = "Stickers (Knife)",
    ["13944131195"] = "Popsicle (Knife)",
    ["13944132845"] = "Pool Noodle",
    ["13944134705"] = "Floral (Knife)",
    ["13944135892"] = "Beach",
    ["13944151514"] = "Stickers (Gun)",
    ["13944152795"] = "Toy (Gun)",
    ["13944153861"] = "Melon (Gun)",
    ["13944155639"] = "Sun",
    ["13945892398"] = "Waves",
    ["13945898892"] = "Ocean",
    ["14967668214"] = "Ghoulish",
    ["15070870271"] = "Traveler's Axe",
    ["15080267070"] = "Darksword",
    ["15080280688"] = "Darkshot",
    ["15091321393"] = "Etched",
    ["15091325210"] = "Vines (Knife)",
    ["15091326116"] = "Ghosts (Knife)",
    ["15091327743"] = "Pumpkin (Gun)",
    ["15091339932"] = "Zombie (Knife)",
    ["15091340751"] = "Meltdown",
    ["15091341552"] = "Steel (Gun)",
    ["15091342564"] = "Ghastly (Gun)",
    ["15091343579"] = "Dark (Knife)",
    ["15091344462"] = "Traveler (Gun)",
    ["15091399982"] = "Spider",
    ["15091400883"] = "Leaves (Knife)",
    ["15091401811"] = "Wood",
    ["15091402817"] = "Vines (Gun)",
    ["15091403551"] = "Glowy",
    ["15091404278"] = "Eclipse",
    ["15091405483"] = "Steel (Knife)",
    ["15091406343"] = "Dark (Gun)",
    ["15091407068"] = "Ghastly (Knife)",
    ["15091407901"] = "Traveler (Knife)",
    ["15091442039"] = "Traveler's Gun",
    ["15097897227"] = "Traveler's Gun",
    ["15413114703"] = "Latte (Knife)",
    ["15413116029"] = "Latte (Gun)",
    ["15413117611"] = "Pumpkin Pie",
    ["15413149176"] = "Turkey",
    ["15415482999"] = "Scarf",
    ["15635550625"] = "Santa (Gun)",
    ["15635552019"] = "Ribbon",
    ["15635553149"] = "Present",
    ["15635556891"] = "Frozen (Knife)",
    ["15635558021"] = "Fireplace",
    ["15635558982"] = "Canes (Gun)",
    ["15635559978"] = "Stars (Knife)",
    ["15635560825"] = "Neon (Gun)",
    ["15635563249"] = "Tree (Knife)",
    ["15635565488"] = "Frostfade (Knife)",
    ["15635568751"] = "Snowfall",
    ["15635569893"] = "Elf (Gun)",
    ["15635570486"] = "Bells",
    ["15635571468"] = "Frozen (Gun)",
    ["15635572427"] = "Snowman (Gun)",
    ["15635574031"] = "Stars (Gun)",
    ["15635574962"] = "Canes (Knife)",
    ["15635575718"] = "Snowflake (Gun)",
    ["15635576863"] = "Snowglobe",
    ["15635577623"] = "Frostfade (Gun)",
    ["15666469505"] = "Gingerscope",
    ["15667157715"] = "Evergreen",
    ["15682703596"] = "Evergun",
    ["15683140564"] = "Gingerscythe",
    ["15683175970"] = "Synthwave",
    ["15683188776"] = "Gingerscythe",
    ["15694110573"] = "Evergreen",
    ["15695405379"] = "Red Traveler's",
    ["15695407020"] = "Bronze Traveler's",
    ["15695407742"] = "Silver Traveler's",
    ["15695408631"] = "Gold Traveler's",
    ["16959755393"] = "Wavy (Knife)",
    ["16959771850"] = "Carrot (Knife)",
    ["16959775902"] = "Spring",
    ["16959778188"] = "Robot",
    ["16960077712"] = "Wavy (Gun)",
    ["16960082652"] = "Carrot (Gun)",
    ["16963860501"] = "Flowerwood (Knife)",
    ["16963894455"] = "Flowerwood (Gun)",
    ["16964346058"] = "Splatter",
    ["16964448042"] = "Blue Gingerscythe",
    ["16964449392"] = "Bronze Gingerscythe",
    ["16964450895"] = "Silver Gingerscythe",
    ["16964452491"] = "Gold Gingerscythe",
    ["16964462231"] = "Blue Gingerscope",
    ["16964465320"] = "Bronze Gingerscope",
    ["16964468980"] = "Silver Gingerscope",
    ["16964471890"] = "Gold Gingerscope",
    ["18322137551"] = "Palms (Knife)",
    ["18322166908"] = "Turtle",
    ["18322176343"] = "Starfish (Knife)",
    ["18322178053"] = "Waves",
    ["18322179563"] = "Sharky",
    ["18322181701"] = "Jellyfish",
    ["18322183619"] = "Clownfish (Knife)",
    ["18322189584"] = "Starfish (Gun)",
    ["18322191060"] = "Popsicle (Gun)",
    ["18322192817"] = "Palms (Gun)",
    ["18322194067"] = "Floatie",
    ["18322197952"] = "Clownfish (Gun)",
    ["18322621319"] = "Pearl",
    ["18322646152"] = "Pearlshine",
    ["18323751219"] = "Floral (Gun)",
    ["18323751962"] = "Balloons",
    ["18323752709"] = "Sandy (Gun)",
    ["18351388416"] = "Watergun",
    ["18351401528"] = "Watergun",
    ["70701057041846"] = "Gold Snow Dagger",
    ["70973050894155"] = "Snowstorm",
    ["71088901904009"] = "Logcutter",
    ["71228862432065"] = "Lights (Knife)",
    ["71258273720666"] = "Bats (Gun)",
    ["71511736314707"] = "Silver Raygun",
    ["71982363966070"] = "Clown (Gun)",
    ["72230744607038"] = "Bronze Synthwave",
    ["72638846676083"] = "Wrapped (Knife)",
    ["73148873488539"] = "Peppermint (Gun)",
    ["73203940450745"] = "Igloo (Knife)",
    ["73486056426142"] = "Leaves (Knife)",
    ["73897192147749"] = "Strawberries (Knife)",
    ["73980008491741"] = "Neopolitan",
    ["74908113882525"] = "Gingerbread (Gun)",
    ["74917318027165"] = "Sleigh",
    ["75123474631661"] = "Stickers (Gun)",
    ["75233248021696"] = "Soul",
    ["75237025203058"] = "Coconut",
    ["75608370390005"] = "Skyline",
    ["76250851065456"] = "Gold Raygun",
    ["76288270695961"] = "Stockings (Gun)",
    ["76461209737867"] = "Bones (Knife)",
    ["76537883908961"] = "Treats (Gun)",
    ["76914260444878"] = "Carrots",
    ["77271917200992"] = "Turtles",
    ["77607127867154"] = "Alienbeam",
    ["77773918675860"] = "Hologram (Knife)",
    ["78153346812503"] = "Fall",
    ["78199422065424"] = "Forest",
    ["78432760615312"] = "Wreaths",
    ["78479059410850"] = "Heart Wand",
    ["79235438948261"] = "Heartbreak",
    ["79722325448464"] = "Xenoshot",
    ["80492487454400"] = "Xeno (Knife)",
    ["80900354672590"] = "Aquarium (Knife)",
    ["81352860339620"] = "Spearmint (Gun)",
    ["83838802472095"] = "Silver Snowcannon",
    ["83843575465564"] = "Stickers (Knife)",
    ["84030107970606"] = "UFOs (Gun)",
    ["84481559639371"] = "Bauble",
    ["84605926178412"] = "Peppermint (Knife)",
    ["84743767811732"] = "Bronze Snowcannon",
    ["85299848190695"] = "Retro",
    ["85751270338066"] = "Snowman (Knife)",
    ["85766514163212"] = "Red Constellation",
    ["86258299490709"] = "Energized (Knife)",
    ["86405207895194"] = "Candy Corn (Knife)",
    ["87189663191639"] = "Icecream",
    ["87617250559234"] = "Red Snow Dagger",
    ["88928894807422"] = "Blizzard",
    ["89899263078420"] = "Soda (Knife)",
    ["90170220549489"] = "Lava (Gun)",
    ["90194465176219"] = "Haunted (Knife)",
    ["90241292303974"] = "Silver Celestial",
    ["90274872705656"] = "Vampire's Gun",
    ["90526048501163"] = "Pop Art (Gun)",
    ["90549252812333"] = "Bunnies",
    ["90595111293037"] = "Candleflame (Gun)",
    ["90622014285727"] = "Frozen (Gun)",
    ["90751163516480"] = "Eyes",
    ["91224254479440"] = "Stickers (Gun)",
    ["91446990047399"] = "Moons",
    ["93320180084418"] = "Penguin",
    ["93906279038399"] = "Sunny",
    ["94311965719769"] = "Nightsky",
    ["95328449981238"] = "Snow Dagger",
    ["95517099886712"] = "Igloo (Gun)",
    ["96164363513384"] = "Cherries",
    ["97369825731567"] = "Storm",
    ["97641024072972"] = "UFOs (Knife)",
    ["98506456649552"] = "Spearmint (Knife)",
    ["98868784444742"] = "Stickers (Knife)",
    ["99160839686845"] = "Gingercookie (Gun)",
    ["99939659856909"] = "Hearts",
    ["100461386281007"] = "Stickers (Knife)",
    ["100576599313371"] = "Xeno (Knife)",
    ["100747436297625"] = "Silver Constellation",
    ["101343256002049"] = "Australis",
    ["102130993592804"] = "Sweater (Knife)",
    ["102283625659356"] = "Stickers (Knife)",
    ["103455022994358"] = "Silver Synthwave",
    ["103526268515240"] = "Sunset (Knife)",
    ["104229967982042"] = "Gold Celestial",
    ["104258636970738"] = "Lights (Gun)",
    ["104416405402940"] = "Snowball (Gun)",
    ["104747488009018"] = "Bats (Knife)",
    ["104988218477551"] = "Frostflame (Knife)",
    ["107190526940939"] = "Spirit",
    ["107321881182350"] = "Meadow",
    ["107508982214346"] = "Floral (Gun)",
    ["107510647616718"] = "Abduction",
    ["108122054293502"] = "Stickers (Gun)",
    ["108331177567412"] = "Witch's Brew",
    ["108635848059846"] = "Borealis",
    ["108751717527377"] = "Hologram (Gun)",
    ["108996627787763"] = "Frozen (Knife)",
    ["109101361674956"] = "Reindeer",
    ["109292073070223"] = "Monster (Knife)",
    ["109929760056853"] = "Wrapped (Gun)",
    ["110160120309916"] = "Blossom (Knife)",
    ["110812086479763"] = "Red Snowcannon",
    ["111092946728824"] = "Ornament",
    ["111291962899457"] = "Tropical",
    ["111408683823094"] = "Gingercookie (Knife)",
    ["112511843095202"] = "Pool",
    ["112811587103866"] = "Bronze Constellation",
    ["113677688954146"] = "Yummy",
    ["113979322866878"] = "Nightstar",
    ["114197436469014"] = "Constellation",
    ["114403390530326"] = "Energized (Gun)",
    ["114781759936576"] = "Frostflame (Gun)",
    ["115093067149752"] = "Candy Corn (Knife)",
    ["115273559455814"] = "Gingerheart",
    ["115280072896190"] = "Stickers (Knife)",
    ["115298865715727"] = "Treats (Knife)",
    ["115609046800090"] = "Gold Snowcannon",
    ["116059045830205"] = "Kraken",
    ["116361515042274"] = "Chick",
    ["117088166092009"] = "Pumpkin Patch",
    ["117473869340749"] = "Candy Corn (Gun)",
    ["118334707962654"] = "Heart Wand",
    ["118530164125152"] = "Striped (Gun)",
    ["118557229750245"] = "Sweater (Gun)",
    ["119157529694972"] = "Red Celestial",
    ["119213058412452"] = "Sands",
    ["119399643874968"] = "Bronze Celestial",
    ["119626042140839"] = "Pumpkin (Knife)",
    ["119914093248842"] = "Snowball (Knife)",
    ["120089556380493"] = "Paws",
    ["120248733900674"] = "Stickers (Knife)",
    ["120422092957504"] = "Polar Bear",
    ["120888453565511"] = "Beachy",
    ["120907601916735"] = "Sunset (Gun)",
    ["121681210724670"] = "Plaid",
    ["122021199074749"] = "Ritual",
    ["122078592955794"] = "Reindeer",
    ["122762984016505"] = "Blue Synthwave",
    ["122855768693454"] = "Cursed (Gun)",
    ["123269723073737"] = "Pop Art (Knife)",
    ["123955324398353"] = "Cupid",
    ["124567820488562"] = "Duckies",
    ["124860763249593"] = "Decorated",
    ["126937716954396"] = "Sweet",
    ["127489830827583"] = "Stickers (Gun)",
    ["127570773123670"] = "Pier",
    ["128427983277729"] = "Silver Snow Dagger",
    ["128553215441980"] = "Bloom",
    ["128646835922561"] = "Strawberries (Gun)",
    ["129186939023729"] = "Snowcannon",
    ["129290011017110"] = "Gifts (Knife)",
    ["129460052425837"] = "Aquarium (Gun)",
    ["129480661108374"] = "Sunrise",
    ["129781304866793"] = "Candy Corn (Gun)",
    ["129970927613267"] = "Leaves (Gun)",
    ["130537925107449"] = "Starry (Knife)",
    ["130837676383567"] = "Vampire's Axe",
    ["131417913843701"] = "Lava (Knife)",
    ["131626924640663"] = "Treat",
    ["132040985617451"] = "Synthwave",
    ["132354489228618"] = "Red Raygun",
    ["132504094164819"] = "Ornaments (Knife)",
    ["132525981806780"] = "Soda (Gun)",
    ["132565936309463"] = "Cursed (Knife)",
    ["132975248521820"] = "Gold Constellation",
    ["133219566412887"] = "Dolphins",
    ["133307062463653"] = "Hot Chocolate",
    ["133654810681274"] = "Candles",
    ["133828016595037"] = "Synthwave",
    ["134312132943601"] = "Bronze Snow Dagger",
    ["134429631587448"] = "Neon (Gun)",
    ["134478959354477"] = "Gingerbread (Knife)",
    ["134681523511387"] = "Ghosts (Knife)",
    ["135606903872678"] = "Tourist",
    ["135662872427976"] = "Butterflies",
    ["136673966529736"] = "Celestial",
    ["136747578920542"] = "Striped (Knife)",
    ["138109619662236"] = "Sand",
    ["138204709945147"] = "Flora",
    ["138388933477235"] = "Bubbles",
    ["138834911796124"] = "Gold Synthwave",
    ["138881346504998"] = "Bronze Raygun",
    ["139431943195380"] = "Raygun",
    ["139755862211442"] = "Xeno (Gun)",
    ["140366567839959"] = "Cats",
}

local MM2_ITEM_RARITY_MAP = {
    ["196749885"] = "Uncommon",
    ["196750197"] = "Uncommon",
    ["196750305"] = "Godly",
    ["196750384"] = "Common",
    ["196750422"] = "Rare",
    ["196750668"] = "Common",
    ["196750845"] = "Common",
    ["196750899"] = "Legendary",
    ["196750963"] = "Rare",
    ["196751441"] = "Uncommon",
    ["196751515"] = "Common",
    ["196751752"] = "Classic",
    ["196751820"] = "Common",
    ["196751943"] = "Classic",
    ["196751989"] = "Classic",
    ["196752052"] = "Classic",
    ["196752144"] = "Classic",
    ["196752289"] = "Uncommon",
    ["196752330"] = "Common",
    ["196752379"] = "Uncommon",
    ["196752456"] = "Uncommon",
    ["196752499"] = "Common",
    ["196752601"] = "Common",
    ["196752683"] = "Rare",
    ["196752718"] = "Rare",
    ["196752812"] = "Common",
    ["196752926"] = "Legendary",
    ["197499641"] = "Common",
    ["197626358"] = "Uncommon",
    ["197638833"] = "Uncommon",
    ["197656593"] = "Rare",
    ["197663897"] = "Legendary",
    ["197829003"] = "Uncommon",
    ["197829561"] = "Rare",
    ["197830043"] = "Legendary",
    ["197879343"] = "Unique",
    ["198042673"] = "Godly",
    ["198433893"] = "Common",
    ["198434520"] = "Common",
    ["198434881"] = "Common",
    ["198439107"] = "Uncommon",
    ["198439692"] = "Uncommon",
    ["198440101"] = "Uncommon",
    ["198440414"] = "Rare",
    ["198441038"] = "Rare",
    ["198441413"] = "Legendary",
    ["198441783"] = "Godly",
    ["198442811"] = "Godly",
    ["198443382"] = "Uncommon",
    ["198443956"] = "Rare",
    ["198444909"] = "Legendary",
    ["198566885"] = "Common",
    ["200953094"] = "Common",
    ["201238541"] = "Godly",
    ["201542790"] = "Common",
    ["203806022"] = "Common",
    ["203807397"] = "Common",
    ["203807690"] = "Common",
    ["203807904"] = "Common",
    ["203808108"] = "Uncommon",
    ["203808190"] = "Uncommon",
    ["203808317"] = "Uncommon",
    ["203809168"] = "Rare",
    ["203810176"] = "Legendary",
    ["203819271"] = "Rare",
    ["203858533"] = "Godly",
    ["203867650"] = "Uncommon",
    ["203869110"] = "Legendary",
    ["203869308"] = "Rare",
    ["235366460"] = "Common",
    ["235366729"] = "Common",
    ["235366771"] = "Common",
    ["235366815"] = "Uncommon",
    ["235366870"] = "Uncommon",
    ["235366945"] = "Uncommon",
    ["235371276"] = "Uncommon",
    ["235371439"] = "Legendary",
    ["235371508"] = "Rare",
    ["235371686"] = "Rare",
    ["235371809"] = "Rare",
    ["235372015"] = "Legendary",
    ["235381341"] = "Godly",
    ["237336076"] = "Common",
    ["238545971"] = "Common",
    ["238546032"] = "Common",
    ["238546100"] = "Common",
    ["238546356"] = "Uncommon",
    ["238546400"] = "Uncommon",
    ["238546422"] = "Uncommon",
    ["238546467"] = "Rare",
    ["238546577"] = "Rare",
    ["238546660"] = "Legendary",
    ["238546983"] = "Godly",
    ["238549030"] = "Common",
    ["241095344"] = "Legendary",
    ["295269977"] = "Common",
    ["305503783"] = "Common",
    ["305503942"] = "Common",
    ["305504173"] = "Common",
    ["305504399"] = "Common",
    ["305506822"] = "Common",
    ["305506951"] = "Common",
    ["306046703"] = "Common",
    ["310709709"] = "Common",
    ["310710191"] = "Common",
    ["310710694"] = "Common",
    ["310712788"] = "Common",
    ["310713235"] = "Common",
    ["310713648"] = "Common",
    ["310714089"] = "Common",
    ["310714407"] = "Common",
    ["310715104"] = "Common",
    ["310715768"] = "Common",
    ["315099010"] = "Rare",
    ["315100702"] = "Legendary",
    ["315104004"] = "Legendary",
    ["315155591"] = "Rare",
    ["315500879"] = "Common",
    ["315501118"] = "Unique",
    ["315501170"] = "Common",
    ["315501208"] = "Common",
    ["315501297"] = "Uncommon",
    ["315501369"] = "Uncommon",
    ["315501434"] = "Uncommon",
    ["315501501"] = "Rare",
    ["315501560"] = "Rare",
    ["315501640"] = "Legendary",
    ["315506122"] = "Godly",
    ["331140746"] = "Rare",
    ["331744703"] = "Rare",
    ["331745341"] = "Common",
    ["331745428"] = "Common",
    ["331745500"] = "Uncommon",
    ["331745577"] = "Legendary",
    ["331745799"] = "Uncommon",
    ["331746096"] = "Common",
    ["331746317"] = "Common",
    ["332011125"] = "Uncommon",
    ["332021011"] = "Godly",
    ["332022166"] = "Godly",
    ["332044583"] = "Godly",
    ["332044679"] = "Godly",
    ["332496861"] = "Common",
    ["332497038"] = "Rare",
    ["332497103"] = "Uncommon",
    ["332497144"] = "Common",
    ["332497187"] = "Rare",
    ["332497550"] = "Common",
    ["332497603"] = "Uncommon",
    ["332497657"] = "Uncommon",
    ["332497688"] = "Legendary",
    ["332731156"] = "Legendary",
    ["332767999"] = "Common",
    ["332848695"] = "Godly",
    ["363150149"] = "Common",
    ["363150334"] = "Common",
    ["363150561"] = "Common",
    ["363150761"] = "Common",
    ["363352002"] = "Common",
    ["363352211"] = "Common",
    ["365567889"] = "Common",
    ["365567962"] = "Common",
    ["365568056"] = "Common",
    ["365568163"] = "Common",
    ["365568602"] = "Uncommon",
    ["365569126"] = "Uncommon",
    ["365569265"] = "Uncommon",
    ["365569428"] = "Rare",
    ["365569566"] = "Rare",
    ["365569686"] = "Legendary",
    ["383476085"] = "Common",
    ["386276987"] = "Godly",
    ["386277381"] = "Godly",
    ["387874071"] = "Common",
    ["387874365"] = "Common",
    ["387874661"] = "Common",
    ["387874991"] = "Common",
    ["387875405"] = "Common",
    ["435933179"] = "Legendary",
    ["439325100"] = "Common",
    ["446050753"] = "Godly",
    ["473569625"] = "Godly",
    ["473570051"] = "Godly",
    ["473570519"] = "Godly",
    ["473571549"] = "Godly",
    ["473572138"] = "Godly",
    ["473572568"] = "Godly",
    ["473573054"] = "Godly",
    ["473573464"] = "Classic",
    ["473574001"] = "Classic",
    ["473574401"] = "Classic",
    ["473575049"] = "Classic",
    ["473625645"] = "Common",
    ["473625785"] = "Common",
    ["473625906"] = "Common",
    ["473626025"] = "Common",
    ["473626150"] = "Uncommon",
    ["473626317"] = "Uncommon",
    ["473626473"] = "Uncommon",
    ["473626646"] = "Rare",
    ["473626740"] = "Rare",
    ["473626979"] = "Legendary",
    ["474030882"] = "Classic",
    ["475478854"] = "Godly",
    ["476599365"] = "Common",
    ["531873011"] = "Rare",
    ["531873080"] = "Common",
    ["531873154"] = "Uncommon",
    ["531873248"] = "Uncommon",
    ["531873371"] = "Legendary",
    ["531873487"] = "Uncommon",
    ["531873553"] = "Common",
    ["531873625"] = "Rare",
    ["531873816"] = "Common",
    ["531873956"] = "Common",
    ["531878205"] = "Godly",
    ["546159020"] = "Common",
    ["546159250"] = "Common",
    ["546161062"] = "Common",
    ["546161470"] = "Common",
    ["546161858"] = "Common",
    ["566867312"] = "Legendary",
    ["585872642"] = "Godly",
    ["585873746"] = "Godly",
    ["619605312"] = "Godly",
    ["1132775323"] = "Godly",
    ["1133237368"] = "Godly",
    ["1133316381"] = "Legendary",
    ["1133317890"] = "Rare",
    ["1133325465"] = "Uncommon",
    ["1133331679"] = "Common",
    ["1133331885"] = "Common",
    ["1133332075"] = "Common",
    ["1133337797"] = "Common",
    ["1133352032"] = "Uncommon",
    ["1133366632"] = "Uncommon",
    ["1133366830"] = "Rare",
    ["1138143590"] = "Godly",
    ["1268699212"] = "Common",
    ["1268699677"] = "Common",
    ["1268703023"] = "Common",
    ["1268703618"] = "Common",
    ["1268704124"] = "Uncommon",
    ["1268704507"] = "Uncommon",
    ["1268704902"] = "Uncommon",
    ["1268705527"] = "Rare",
    ["1268705947"] = "Rare",
    ["1268706374"] = "Legendary",
    ["1268708987"] = "Godly",
    ["1268710824"] = "Godly",
    ["1268932977"] = "Godly",
    ["1269256860"] = "Legendary",
    ["1269374321"] = "Legendary",
    ["1269580035"] = "Godly",
    ["1489495701"] = "Unique",
    ["1520188792"] = "Unique",
    ["1520189487"] = "Unique",
    ["1520190188"] = "Unique",
    ["2511340308"] = "Unique",
    ["2511341094"] = "Unique",
    ["2511342846"] = "Unique",
    ["2511343130"] = "Unique",
    ["2511791893"] = "Ancient",
    ["2513505477"] = "Godly",
    ["2513535503"] = "Godly",
    ["2513598419"] = "Godly",
    ["2513728474"] = "Common",
    ["2513731746"] = "Common",
    ["2513732731"] = "Common",
    ["2513732969"] = "Legendary",
    ["2513733542"] = "Uncommon",
    ["2513733741"] = "Common",
    ["2513733987"] = "Uncommon",
    ["2513734227"] = "Common",
    ["2513734535"] = "Rare",
    ["2513734708"] = "Rare",
    ["2513734908"] = "Uncommon",
    ["2513741174"] = "Common",
    ["2513741407"] = "Legendary",
    ["2513741663"] = "Uncommon",
    ["2513741901"] = "Common",
    ["2513742133"] = "Uncommon",
    ["2513742319"] = "Common",
    ["2513742519"] = "Rare",
    ["2513742751"] = "Rare",
    ["2513743298"] = "Uncommon",
    ["2533351841"] = "Ancient",
    ["2545253030"] = "Godly",
    ["2669336659"] = "Godly",
    ["2669637780"] = "Common",
    ["2669638285"] = "Common",
    ["2669638508"] = "Rare",
    ["2669638742"] = "Legendary",
    ["2669638990"] = "Uncommon",
    ["2669639638"] = "Rare",
    ["2669639913"] = "Uncommon",
    ["2669640152"] = "Common",
    ["2669640357"] = "Common",
    ["2669640567"] = "Uncommon",
    ["2669784920"] = "Common",
    ["2669785184"] = "Common",
    ["2669785546"] = "Rare",
    ["2669785821"] = "Legendary",
    ["2669786044"] = "Rare",
    ["2669786261"] = "Uncommon",
    ["2669786515"] = "Uncommon",
    ["2669786846"] = "Common",
    ["2669787088"] = "Uncommon",
    ["2669787533"] = "Common",
    ["2672349340"] = "Godly",
    ["2674983099"] = "Godly",
    ["3183085102"] = "Ancient",
    ["3183597816"] = "Godly",
    ["3183598040"] = "Godly",
    ["3183604570"] = "Common",
    ["3183605392"] = "Common",
    ["3183605810"] = "Common",
    ["3183606225"] = "Uncommon",
    ["3183606579"] = "Uncommon",
    ["3183607442"] = "Rare",
    ["3183607894"] = "Legendary",
    ["3183639522"] = "Common",
    ["3183639867"] = "Uncommon",
    ["3183640145"] = "Rare",
    ["3184122829"] = "Godly",
    ["3184124504"] = "Godly",
    ["3184124768"] = "Godly",
    ["3184125087"] = "Godly",
    ["3184125244"] = "Godly",
    ["3184125538"] = "Godly",
    ["3187390667"] = "Godly",
    ["3187392501"] = "Godly",
    ["3187392992"] = "Godly",
    ["3187393285"] = "Godly",
    ["3187394934"] = "Godly",
    ["3187395238"] = "Godly",
    ["3187395551"] = "Godly",
    ["3187395738"] = "Godly",
    ["3187395952"] = "Godly",
    ["3215260149"] = "Unique",
    ["3215261680"] = "Unique",
    ["3215261913"] = "Unique",
    ["3215262120"] = "Unique",
    ["3279011390"] = "Godly",
    ["4210915060"] = "Legendary",
    ["4210920512"] = "Rare",
    ["4210925026"] = "Rare",
    ["4210926347"] = "Uncommon",
    ["4210928053"] = "Uncommon",
    ["4210929184"] = "Uncommon",
    ["4210931354"] = "Common",
    ["4210932676"] = "Common",
    ["4210934082"] = "Common",
    ["4210936652"] = "Common",
    ["4210938270"] = "Legendary",
    ["4210939388"] = "Rare",
    ["4210941474"] = "Rare",
    ["4210943691"] = "Uncommon",
    ["4210944924"] = "Uncommon",
    ["4210946577"] = "Common",
    ["4210947993"] = "Common",
    ["4210949599"] = "Common",
    ["4211142894"] = "Godly",
    ["4211148191"] = "Ancient",
    ["4221789003"] = "Godly",
    ["4468574885"] = "Unique",
    ["4468583758"] = "Unique",
    ["4468584345"] = "Unique",
    ["4468585407"] = "Unique",
    ["4488391411"] = "Godly",
    ["4528484880"] = "Godly",
    ["4534853444"] = "Common",
    ["4534855045"] = "Common",
    ["4534855710"] = "Common",
    ["4534856285"] = "Common",
    ["4534856940"] = "Uncommon",
    ["4534857523"] = "Uncommon",
    ["4534858185"] = "Uncommon",
    ["4534860226"] = "Rare",
    ["4534860689"] = "Rare",
    ["4534861110"] = "Legendary",
    ["4534866065"] = "Common",
    ["4534866678"] = "Common",
    ["4534867381"] = "Common",
    ["4534871260"] = "Common",
    ["4534872116"] = "Uncommon",
    ["4534872673"] = "Uncommon",
    ["4534873956"] = "Uncommon",
    ["4534874602"] = "Rare",
    ["4534875165"] = "Rare",
    ["4534875511"] = "Legendary",
    ["4535408229"] = "Godly",
    ["4535482609"] = "Godly",
    ["4535483042"] = "Legendary",
    ["4535644282"] = "Ancient",
    ["4659626370"] = "Legendary",
    ["4659626966"] = "Rare",
    ["4659627458"] = "Uncommon",
    ["4659627976"] = "Common",
    ["4659634072"] = "Rare",
    ["4659634630"] = "Uncommon",
    ["4659635055"] = "Uncommon",
    ["4659635584"] = "Common",
    ["4659636085"] = "Common",
    ["4659636452"] = "Common",
    ["4749070432"] = "Godly",
    ["4749071819"] = "Godly",
    ["4751500761"] = "Godly",
    ["4751501078"] = "Godly",
    ["4751539262"] = "Godly",
    ["4753346087"] = "Unique",
    ["4753347062"] = "Unique",
    ["4753347636"] = "Unique",
    ["4753348263"] = "Unique",
    ["4753352581"] = "Unique",
    ["4753353471"] = "Unique",
    ["4753354123"] = "Unique",
    ["4753354638"] = "Unique",
    ["4972196241"] = "Common",
    ["4999958740"] = "Godly",
    ["5360359935"] = "Godly",
    ["5866435364"] = "Common",
    ["5866436906"] = "Common",
    ["5866438542"] = "Common",
    ["5866441301"] = "Legendary",
    ["5866442790"] = "Uncommon",
    ["5866444722"] = "Rare",
    ["5866447521"] = "Uncommon",
    ["5866454590"] = "Common",
    ["5866457985"] = "Common",
    ["5866459380"] = "Common",
    ["5866460591"] = "Legendary",
    ["5866461926"] = "Uncommon",
    ["5866463755"] = "Uncommon",
    ["5866465099"] = "Rare",
    ["5872490600"] = "Uncommon",
    ["5872491708"] = "Common",
    ["5872492951"] = "Rare",
    ["5873256998"] = "Godly",
    ["5877016863"] = "Ancient",
    ["5878721461"] = "Godly",
    ["5929317433"] = "Common",
    ["5930729222"] = "Common",
    ["5930731295"] = "Common",
    ["5984754897"] = "Common",
    ["6084838617"] = "Unique",
    ["6084840560"] = "Unique",
    ["6084842077"] = "Unique",
    ["6084854835"] = "Unique",
    ["6085035357"] = "Godly",
    ["6121847170"] = "Common",
    ["6121848805"] = "Legendary",
    ["6121850031"] = "Uncommon",
    ["6121851313"] = "Rare",
    ["6121853160"] = "Common",
    ["6121854816"] = "Uncommon",
    ["6121860619"] = "Uncommon",
    ["6121862034"] = "Rare",
    ["6121863515"] = "Common",
    ["6121864813"] = "Common",
    ["6121866490"] = "Legendary",
    ["6121867603"] = "Uncommon",
    ["6123335682"] = "Common",
    ["6123336879"] = "Common",
    ["6123338102"] = "Rare",
    ["6123357775"] = "Legendary",
    ["6125729383"] = "Ancient",
    ["6125733703"] = "Godly",
    ["6125742758"] = "Godly",
    ["6125814417"] = "Godly",
    ["6404115112"] = "Unique",
    ["6404126280"] = "Unique",
    ["6404127119"] = "Unique",
    ["6404129111"] = "Unique",
    ["6404165933"] = "Unique",
    ["6404166698"] = "Unique",
    ["6404167442"] = "Unique",
    ["6404168049"] = "Unique",
    ["6413145922"] = "Godly",
    ["6598123521"] = "Godly",
    ["6607277825"] = "Godly",
    ["6711852603"] = "Common",
    ["6967771328"] = "Unique",
    ["7791485669"] = "Legendary",
    ["7791511648"] = "Godly",
    ["7791640819"] = "Ancient",
    ["7800220325"] = "Uncommon",
    ["7800221141"] = "Uncommon",
    ["7800222135"] = "Common",
    ["7800222975"] = "Uncommon",
    ["7800224197"] = "Common",
    ["7800224981"] = "Common",
    ["7800225996"] = "Rare",
    ["7800226793"] = "Legendary",
    ["7800227475"] = "Rare",
    ["7800229084"] = "Common",
    ["7800250906"] = "Common",
    ["7800251557"] = "Uncommon",
    ["7800252572"] = "Rare",
    ["7800253444"] = "Common",
    ["7800253970"] = "Uncommon",
    ["7800254737"] = "Common",
    ["7800255531"] = "Legendary",
    ["7800256309"] = "Rare",
    ["7800257010"] = "Common",
    ["7800257544"] = "Uncommon",
    ["7800847534"] = "Ancient",
    ["7805833970"] = "Godly",
    ["7806121918"] = "Godly",
    ["7808362279"] = "Uncommon",
    ["8194217388"] = "Unique",
    ["8194219645"] = "Unique",
    ["8194221072"] = "Unique",
    ["8194222523"] = "Unique",
    ["8304750295"] = "Common",
    ["8304750877"] = "Legendary",
    ["8304751659"] = "Common",
    ["8304752586"] = "Uncommon",
    ["8304753468"] = "Uncommon",
    ["8304754179"] = "Common",
    ["8304754882"] = "Common",
    ["8304755417"] = "Common",
    ["8304756423"] = "Uncommon",
    ["8304757110"] = "Rare",
    ["8304757707"] = "Rare",
    ["8304766165"] = "Legendary",
    ["8304766932"] = "Uncommon",
    ["8304767724"] = "Rare",
    ["8304768700"] = "Common",
    ["8304769409"] = "Common",
    ["8304770115"] = "Common",
    ["8304771148"] = "Uncommon",
    ["8304772140"] = "Uncommon",
    ["8304772774"] = "Rare",
    ["8304801000"] = "Ancient",
    ["8304805693"] = "Godly",
    ["8304818186"] = "Godly",
    ["8305264097"] = "Godly",
    ["8311005531"] = "Godly",
    ["8311393414"] = "Godly",
    ["8626617523"] = "Unique",
    ["9552048857"] = "Unique",
    ["9552050165"] = "Unique",
    ["9552051805"] = "Unique",
    ["9552054920"] = "Unique",
    ["9552060741"] = "Unique",
    ["9552063524"] = "Unique",
    ["9552064240"] = "Unique",
    ["9552065167"] = "Unique",
    ["10014680882"] = "Godly",
    ["10014717343"] = "Godly",
    ["11117375743"] = "Uncommon",
    ["11229732037"] = "Godly",
    ["11229779932"] = "Godly",
    ["11229814357"] = "Godly",
    ["11229837140"] = "Godly",
    ["11254057417"] = "Common",
    ["11254065007"] = "Common",
    ["11254067158"] = "Common",
    ["11254081561"] = "Common",
    ["11254083234"] = "Uncommon",
    ["11254093910"] = "Uncommon",
    ["11254115609"] = "Uncommon",
    ["11254118399"] = "Rare",
    ["11254123390"] = "Rare",
    ["11254125546"] = "Legendary",
    ["11254145154"] = "Common",
    ["11254146743"] = "Common",
    ["11254152435"] = "Common",
    ["11254154978"] = "Common",
    ["11254158802"] = "Common",
    ["11254172968"] = "Common",
    ["11254175272"] = "Common",
    ["11254180750"] = "Rare",
    ["11254182560"] = "Rare",
    ["11254975176"] = "Godly",
    ["11255501940"] = "Common",
    ["11255502768"] = "Common",
    ["11255503583"] = "Legendary",
    ["11255504462"] = "Rare",
    ["11255505449"] = "Uncommon",
    ["11255507374"] = "Common",
    ["11255558166"] = "Common",
    ["11262771067"] = "Godly",
    ["11284140034"] = "Rare",
    ["11284143055"] = "Uncommon",
    ["11284145298"] = "Uncommon",
    ["11284147880"] = "Common",
    ["11505913287"] = "Unique",
    ["11505914752"] = "Unique",
    ["11505916486"] = "Unique",
    ["11505917850"] = "Unique",
    ["11548082732"] = "Uncommon",
    ["11834384755"] = "Common",
    ["11834387858"] = "Common",
    ["11834390120"] = "Common",
    ["11834391469"] = "Common",
    ["11834392930"] = "Uncommon",
    ["11834394793"] = "Uncommon",
    ["11834397133"] = "Uncommon",
    ["11834399071"] = "Rare",
    ["11834400185"] = "Rare",
    ["11834401547"] = "Legendary",
    ["11834403282"] = "Common",
    ["11834404402"] = "Common",
    ["11834432971"] = "Common",
    ["11834434264"] = "Common",
    ["11834435627"] = "Common",
    ["11834436620"] = "Common",
    ["11834437796"] = "Uncommon",
    ["11834438982"] = "Uncommon",
    ["11834440319"] = "Uncommon",
    ["11834441321"] = "Rare",
    ["11834442414"] = "Rare",
    ["11834443783"] = "Legendary",
    ["11834445016"] = "Common",
    ["11855274019"] = "Ancient",
    ["11855282546"] = "Godly",
    ["11855306927"] = "Godly",
    ["11855361567"] = "Legendary",
    ["11872179646"] = "Godly",
    ["11873640255"] = "Godly",
    ["11874071041"] = "Ancient",
    ["12226688172"] = "Unique",
    ["12226843957"] = "Unique",
    ["12226920195"] = "Unique",
    ["12227133450"] = "Unique",
    ["12227137860"] = "Unique",
    ["12227142478"] = "Unique",
    ["12227148356"] = "Unique",
    ["12227186408"] = "Unique",
    ["12339323856"] = "Legendary",
    ["12339325736"] = "Uncommon",
    ["12339327069"] = "Rare",
    ["12339328595"] = "Common",
    ["12339366064"] = "Godly",
    ["12339377105"] = "Godly",
    ["12965294432"] = "Common",
    ["12965298174"] = "Rare",
    ["12965302237"] = "Uncommon",
    ["12965304445"] = "Legendary",
    ["12965307410"] = "Uncommon",
    ["12965311567"] = "Rare",
    ["12965335931"] = "Rare",
    ["12965339774"] = "Legendary",
    ["12965344675"] = "Uncommon",
    ["12965349193"] = "Common",
    ["12966184630"] = "Godly",
    ["12966354606"] = "Godly",
    ["13944127959"] = "Common",
    ["13944129596"] = "Common",
    ["13944131195"] = "Uncommon",
    ["13944132845"] = "Uncommon",
    ["13944134705"] = "Rare",
    ["13944135892"] = "Legendary",
    ["13944151514"] = "Common",
    ["13944152795"] = "Common",
    ["13944153861"] = "Uncommon",
    ["13944155639"] = "Rare",
    ["13945892398"] = "Godly",
    ["13945898892"] = "Godly",
    ["14967668214"] = "Common",
    ["15070870271"] = "Ancient",
    ["15080267070"] = "Godly",
    ["15080280688"] = "Godly",
    ["15091321393"] = "Common",
    ["15091325210"] = "Common",
    ["15091326116"] = "Common",
    ["15091327743"] = "Common",
    ["15091339932"] = "Uncommon",
    ["15091340751"] = "Uncommon",
    ["15091341552"] = "Uncommon",
    ["15091342564"] = "Rare",
    ["15091343579"] = "Rare",
    ["15091344462"] = "Legendary",
    ["15091399982"] = "Common",
    ["15091400883"] = "Common",
    ["15091401811"] = "Common",
    ["15091402817"] = "Common",
    ["15091403551"] = "Uncommon",
    ["15091404278"] = "Uncommon",
    ["15091405483"] = "Uncommon",
    ["15091406343"] = "Rare",
    ["15091407068"] = "Rare",
    ["15091407901"] = "Legendary",
    ["15091442039"] = "Godly",
    ["15097897227"] = "Godly",
    ["15413114703"] = "Legendary",
    ["15413116029"] = "Legendary",
    ["15413117611"] = "Uncommon",
    ["15413149176"] = "Godly",
    ["15415482999"] = "Common",
    ["15635550625"] = "Common",
    ["15635552019"] = "Common",
    ["15635553149"] = "Common",
    ["15635556891"] = "Common",
    ["15635558021"] = "Uncommon",
    ["15635558982"] = "Uncommon",
    ["15635559978"] = "Uncommon",
    ["15635560825"] = "Rare",
    ["15635563249"] = "Rare",
    ["15635565488"] = "Legendary",
    ["15635568751"] = "Common",
    ["15635569893"] = "Common",
    ["15635570486"] = "Common",
    ["15635571468"] = "Common",
    ["15635572427"] = "Uncommon",
    ["15635574031"] = "Uncommon",
    ["15635574962"] = "Uncommon",
    ["15635575718"] = "Rare",
    ["15635576863"] = "Rare",
    ["15635577623"] = "Legendary",
    ["15666469505"] = "Ancient",
    ["15667157715"] = "Godly",
    ["15682703596"] = "Godly",
    ["15683140564"] = "Legendary",
    ["15683175970"] = "Godly",
    ["15683188776"] = "Ancient",
    ["15694110573"] = "Godly",
    ["15695405379"] = "Unique",
    ["15695407020"] = "Unique",
    ["15695407742"] = "Unique",
    ["15695408631"] = "Unique",
    ["16959755393"] = "Common",
    ["16959771850"] = "Uncommon",
    ["16959775902"] = "Rare",
    ["16959778188"] = "Rare",
    ["16960077712"] = "Common",
    ["16960082652"] = "Uncommon",
    ["16963860501"] = "Godly",
    ["16963894455"] = "Godly",
    ["16964346058"] = "Common",
    ["16964448042"] = "Unique",
    ["16964449392"] = "Unique",
    ["16964450895"] = "Unique",
    ["16964452491"] = "Unique",
    ["16964462231"] = "Unique",
    ["16964465320"] = "Unique",
    ["16964468980"] = "Unique",
    ["16964471890"] = "Unique",
    ["18322137551"] = "Legendary",
    ["18322166908"] = "Uncommon",
    ["18322176343"] = "Common",
    ["18322178053"] = "Rare",
    ["18322179563"] = "Rare",
    ["18322181701"] = "Uncommon",
    ["18322183619"] = "Common",
    ["18322189584"] = "Common",
    ["18322191060"] = "Uncommon",
    ["18322192817"] = "Legendary",
    ["18322194067"] = "Uncommon",
    ["18322197952"] = "Common",
    ["18322621319"] = "Godly",
    ["18322646152"] = "Godly",
    ["18323751219"] = "Rare",
    ["18323751962"] = "Common",
    ["18323752709"] = "Common",
    ["18351388416"] = "Godly",
    ["18351401528"] = "Godly",
    ["70701057041846"] = "Unique",
    ["70973050894155"] = "Godly",
    ["71088901904009"] = "Rare",
    ["71228862432065"] = "Common",
    ["71258273720666"] = "Common",
    ["71511736314707"] = "Unique",
    ["71982363966070"] = "Uncommon",
    ["72230744607038"] = "Unique",
    ["72638846676083"] = "Uncommon",
    ["73148873488539"] = "Common",
    ["73203940450745"] = "Common",
    ["73486056426142"] = "Common",
    ["73897192147749"] = "Common",
    ["73980008491741"] = "Uncommon",
    ["74908113882525"] = "Uncommon",
    ["74917318027165"] = "Rare",
    ["75123474631661"] = "Common",
    ["75233248021696"] = "Godly",
    ["75237025203058"] = "Common",
    ["75608370390005"] = "Common",
    ["76250851065456"] = "Unique",
    ["76288270695961"] = "Common",
    ["76461209737867"] = "Uncommon",
    ["76537883908961"] = "Uncommon",
    ["76914260444878"] = "Common",
    ["77271917200992"] = "Uncommon",
    ["77607127867154"] = "Godly",
    ["77773918675860"] = "Rare",
    ["78153346812503"] = "Common",
    ["78199422065424"] = "Uncommon",
    ["78432760615312"] = "Uncommon",
    ["78479059410850"] = "Godly",
    ["79235438948261"] = "Rare",
    ["79722325448464"] = "Godly",
    ["80492487454400"] = "Rare",
    ["80900354672590"] = "Legendary",
    ["81352860339620"] = "Rare",
    ["83838802472095"] = "Unique",
    ["83843575465564"] = "Common",
    ["84030107970606"] = "Common",
    ["84481559639371"] = "Godly",
    ["84605926178412"] = "Common",
    ["84743767811732"] = "Unique",
    ["85299848190695"] = "Uncommon",
    ["85751270338066"] = "Uncommon",
    ["85766514163212"] = "Unique",
    ["86258299490709"] = "Legendary",
    ["86405207895194"] = "Common",
    ["87189663191639"] = "Godly",
    ["87617250559234"] = "Unique",
    ["88928894807422"] = "Godly",
    ["89899263078420"] = "Uncommon",
    ["90170220549489"] = "Uncommon",
    ["90194465176219"] = "Common",
    ["90241292303974"] = "Unique",
    ["90274872705656"] = "Godly",
    ["90526048501163"] = "Rare",
    ["90549252812333"] = "Legendary",
    ["90595111293037"] = "Rare",
    ["90622014285727"] = "Legendary",
    ["90751163516480"] = "Uncommon",
    ["91224254479440"] = "Common",
    ["91446990047399"] = "Uncommon",
    ["93320180084418"] = "Common",
    ["93906279038399"] = "Rare",
    ["94311965719769"] = "Legendary",
    ["95328449981238"] = "Godly",
    ["95517099886712"] = "Common",
    ["96164363513384"] = "Common",
    ["97369825731567"] = "Rare",
    ["97641024072972"] = "Common",
    ["98506456649552"] = "Rare",
    ["98868784444742"] = "Common",
    ["99160839686845"] = "Rare",
    ["99939659856909"] = "Common",
    ["100461386281007"] = "Common",
    ["100576599313371"] = "Godly",
    ["100747436297625"] = "Unique",
    ["101343256002049"] = "Godly",
    ["102130993592804"] = "Uncommon",
    ["102283625659356"] = "Common",
    ["103455022994358"] = "Unique",
    ["103526268515240"] = "Godly",
    ["104229967982042"] = "Unique",
    ["104258636970738"] = "Common",
    ["104416405402940"] = "Common",
    ["104747488009018"] = "Common",
    ["104988218477551"] = "Rare",
    ["107190526940939"] = "Godly",
    ["107321881182350"] = "Uncommon",
    ["107508982214346"] = "Uncommon",
    ["107510647616718"] = "Uncommon",
    ["108122054293502"] = "Common",
    ["108331177567412"] = "Uncommon",
    ["108635848059846"] = "Godly",
    ["108751717527377"] = "Rare",
    ["108996627787763"] = "Legendary",
    ["109101361674956"] = "Common",
    ["109292073070223"] = "Uncommon",
    ["109929760056853"] = "Uncommon",
    ["110160120309916"] = "Uncommon",
    ["110812086479763"] = "Unique",
    ["111092946728824"] = "Godly",
    ["111291962899457"] = "Rare",
    ["111408683823094"] = "Rare",
    ["112511843095202"] = "Uncommon",
    ["112811587103866"] = "Unique",
    ["113677688954146"] = "Rare",
    ["113979322866878"] = "Legendary",
    ["114197436469014"] = "Godly",
    ["114403390530326"] = "Legendary",
    ["114781759936576"] = "Rare",
    ["115093067149752"] = "Common",
    ["115273559455814"] = "Uncommon",
    ["115280072896190"] = "Common",
    ["115298865715727"] = "Uncommon",
    ["115609046800090"] = "Unique",
    ["116059045830205"] = "Rare",
    ["116361515042274"] = "Common",
    ["117088166092009"] = "Uncommon",
    ["117473869340749"] = "Common",
    ["118334707962654"] = "Godly",
    ["118530164125152"] = "Common",
    ["118557229750245"] = "Uncommon",
    ["119157529694972"] = "Unique",
    ["119213058412452"] = "Godly",
    ["119399643874968"] = "Unique",
    ["119626042140839"] = "Uncommon",
    ["119914093248842"] = "Common",
    ["120089556380493"] = "Uncommon",
    ["120248733900674"] = "Common",
    ["120422092957504"] = "Uncommon",
    ["120888453565511"] = "Godly",
    ["120907601916735"] = "Rare",
    ["121681210724670"] = "Common",
    ["122021199074749"] = "Rare",
    ["122078592955794"] = "Common",
    ["122762984016505"] = "Unique",
    ["122855768693454"] = "Legendary",
    ["123269723073737"] = "Rare",
    ["123955324398353"] = "Legendary",
    ["124567820488562"] = "Common",
    ["124860763249593"] = "Uncommon",
    ["126937716954396"] = "Godly",
    ["127489830827583"] = "Common",
    ["127570773123670"] = "Rare",
    ["128427983277729"] = "Unique",
    ["128553215441980"] = "Godly",
    ["128646835922561"] = "Common",
    ["129186939023729"] = "Godly",
    ["129290011017110"] = "Common",
    ["129460052425837"] = "Legendary",
    ["129480661108374"] = "Godly",
    ["129781304866793"] = "Common",
    ["129970927613267"] = "Uncommon",
    ["130537925107449"] = "Uncommon",
    ["130837676383567"] = "Unique",
    ["131417913843701"] = "Uncommon",
    ["131626924640663"] = "Godly",
    ["132040985617451"] = "Legendary",
    ["132354489228618"] = "Unique",
    ["132504094164819"] = "Uncommon",
    ["132525981806780"] = "Uncommon",
    ["132565936309463"] = "Legendary",
    ["132975248521820"] = "Unique",
    ["133219566412887"] = "Common",
    ["133307062463653"] = "Common",
    ["133654810681274"] = "Common",
    ["133828016595037"] = "Ancient",
    ["134312132943601"] = "Unique",
    ["134429631587448"] = "Rare",
    ["134478959354477"] = "Uncommon",
    ["134681523511387"] = "Common",
    ["135606903872678"] = "Common",
    ["135662872427976"] = "Rare",
    ["136673966529736"] = "Ancient",
    ["136747578920542"] = "Common",
    ["138109619662236"] = "Common",
    ["138204709945147"] = "Godly",
    ["138388933477235"] = "Legendary",
    ["138834911796124"] = "Unique",
    ["138881346504998"] = "Unique",
    ["139431943195380"] = "Godly",
    ["139755862211442"] = "Rare",
    ["140366567839959"] = "Common",
}

local function extractIconAssetId(imageUrl)
    if not imageUrl then return nil end
    local url = tostring(imageUrl)
    local id = url:match("[?&]assetId=(%d+)")
        or url:match("[?&]id=(%d+)")
        or url:match("rbxassetid://(%d+)")
        or url:match("/asset/%?id=(%d+)")
    return id
end

-- Returns resolved full name (e.g. "Clown (Gun)") and rarity from an Icon ImageLabel
local function resolveItemNameFromIcon(iconObj)
    if not iconObj then return nil end
    local id = extractIconAssetId(iconObj.Image)
    if not id then return nil end
    return MM2_ITEM_ASSET_MAP[id], MM2_ITEM_RARITY_MAP[id]
end

local function detectRarityFromColor(guiObj, fallbackCont)
    if not guiObj and not fallbackCont then return nil end
    local candidates = {}

    local function addColor(col)
        if not col then return end
        local r = math.round(col.R * 255)
        local g = math.round(col.G * 255)
        local b = math.round(col.B * 255)
        -- ignore neutral text and background shades
        if (r > 240 and g > 240 and b > 240) or (r < 20 and g < 20 and b < 20) then
            return
        end
        table.insert(candidates, {r = r, g = g, b = b})
    end

    -- inspect root container color
    if (guiObj:IsA("ImageLabel") or guiObj:IsA("ImageButton")) and guiObj.ImageColor3 then
        addColor(guiObj.ImageColor3)
    end
    if guiObj:IsA("GuiObject") and guiObj.BackgroundColor3 then
        addColor(guiObj.BackgroundColor3)
    end
    if (guiObj:IsA("TextLabel") or guiObj:IsA("TextButton")) and guiObj.TextColor3 then
        addColor(guiObj.TextColor3)
    end

    -- inspect direct children colors
    for _, ch in ipairs(guiObj:GetChildren()) do
        if (ch:IsA("ImageLabel") or ch:IsA("ImageButton")) and ch.ImageColor3 then
            addColor(ch.ImageColor3)
        end
        if ch:IsA("GuiObject") and ch.BackgroundColor3 then
            addColor(ch.BackgroundColor3)
        end
        if (ch:IsA("TextLabel") or ch:IsA("TextButton")) and ch.TextColor3 then
            addColor(ch.TextColor3)
        end
    end

    -- inspect nested children colors
    for _, ch in ipairs(guiObj:GetDescendants()) do
        if (ch:IsA("ImageLabel") or ch:IsA("ImageButton")) and ch.ImageColor3 then
            addColor(ch.ImageColor3)
        end
        if ch:IsA("GuiObject") and ch.BackgroundColor3 then
            addColor(ch.BackgroundColor3)
        end
        if (ch:IsA("TextLabel") or ch:IsA("TextButton")) and ch.TextColor3 then
            addColor(ch.TextColor3)
        end
    end

    -- inspect parent card color
    local par = guiObj.Parent
    if par and par:IsA("GuiObject") then
        if (par:IsA("ImageLabel") or par:IsA("ImageButton")) and par.ImageColor3 then
            addColor(par.ImageColor3)
        end
        if par.BackgroundColor3 then
            addColor(par.BackgroundColor3)
        end
        if (par:IsA("TextLabel") or par:IsA("TextButton")) and par.TextColor3 then
            addColor(par.TextColor3)
        end
    end

    if fallbackCont and fallbackCont:IsA("GuiObject") then
        if (fallbackCont:IsA("ImageLabel") or fallbackCont:IsA("ImageButton")) and fallbackCont.ImageColor3 then
            addColor(fallbackCont.ImageColor3)
        end
        if fallbackCont.BackgroundColor3 then
            addColor(fallbackCont.BackgroundColor3)
        end
        for _, ch in ipairs(fallbackCont:GetChildren()) do
            if (ch:IsA("ImageLabel") or ch:IsA("ImageButton")) and ch.ImageColor3 then
                addColor(ch.ImageColor3)
            end
            if ch:IsA("GuiObject") and ch.BackgroundColor3 then
                addColor(ch.BackgroundColor3)
            end
        end
    end

    local bestRarity = nil
    local globalMinDist = 999999

    for _, c in ipairs(candidates) do
        local r, g, b = c.r, c.g, c.b

        -- match ui accent colors to item rarity tiers (mm2 inventory card border color constants)
        local dCommon    = math.abs(r - 106) + math.abs(g - 106) + math.abs(b - 106)
        local dUncommon  = math.abs(r - 0)   + math.abs(g - 255) + math.abs(b - 255)
        local dRare      = math.abs(r - 0)   + math.abs(g - 200) + math.abs(b - 0)
        local dLegendary = math.abs(r - 220) + math.abs(g - 0)   + math.abs(b - 5)
        local dGodly     = math.abs(r - 255) + math.abs(g - 0)   + math.abs(b - 179)
        local dVintage   = math.abs(r - 240) + math.abs(g - 130) + math.abs(b - 20)
        local dAncient   = math.abs(r - 110) + math.abs(g - 0)   + math.abs(b - 140)

        local best = "Common"
        local minDist = dCommon
        if dUncommon < minDist then minDist = dUncommon; best = "Uncommon" end
        if dRare < minDist then minDist = dRare; best = "Rare" end
        if dLegendary < minDist then minDist = dLegendary; best = "Legendary" end
        if dGodly < minDist then minDist = dGodly; best = "Godly" end
        if dVintage < minDist then minDist = dVintage; best = "Vintage" end
        if dAncient < minDist then minDist = dAncient; best = "Ancient" end

        if minDist < globalMinDist then
            globalMinDist = minDist
            bestRarity = best
        end
    end

    if globalMinDist <= 90 then
        return bestRarity
    end
    return nil
end

local function getMM2ItemValue(rawName, rarity)
    if not rawName or rawName == "" then return nil end
    local clean = rawName:gsub("^%s+", ""):gsub("%s+$", "")
    if clean:lower():find("default") then return 0 end

    local noParens = clean:gsub("%s*%b()", ""):gsub("^%s+", ""):gsub("%s+$", "")
    local noSuf = noParens:lower()
        :gsub("%s+knife$", ""):gsub("%s+gun$", ""):gsub("%s+axe$", ""):gsub("%s+scythe$", "")
        :gsub("%s+blade$", ""):gsub("%s+sword$", ""):gsub("%s+dagger$", ""):gsub("%s+saber$", "")
        :gsub("^%s+", ""):gsub("%s+$", "")

    local normKey = clean:lower():gsub("[^%w]", "")
    local normNoParens = noParens:lower():gsub("[^%w]", "")
    local normNoSuf = noSuf:gsub("[^%w]", "")

    -- 1. Rarity-specific match FIRST if rarity is known
    -- (This prevents cross-rarity collisions, e.g. Common Skulls/Wolf taking Uncommon Skulls/Wolf values)
    if rarity and MM2ValuesByRarity and MM2ValuesByRarity[rarity] then
        local rTab = MM2ValuesByRarity[rarity]
        if rTab[clean] and rTab[clean] > 0 then return rTab[clean] end
        if noParens ~= "" and rTab[noParens] and rTab[noParens] > 0 then return rTab[noParens] end
        if MM2ValuesNormalizedByRarity and MM2ValuesNormalizedByRarity[rarity] then
            local rNorm = MM2ValuesNormalizedByRarity[rarity]
            if normKey ~= "" and rNorm[normKey] and rNorm[normKey] > 0 then return rNorm[normKey] end
            if normNoParens ~= "" and rNorm[normNoParens] and rNorm[normNoParens] > 0 then return rNorm[normNoParens] end
            if normNoSuf ~= "" and rNorm[normNoSuf] and rNorm[normNoSuf] > 0 then return rNorm[normNoSuf] end
        end
        -- If rarity is explicitly known and was NOT found in this rarity category,
        -- check if an item with this name exists in a DIFFERENT rarity.
        -- If so, this is a distinct item of a different tier whose value is unknown (e.g. new Common Skulls vs old Uncommon Skulls).
        -- Returning nil displays '?' instead of incorrectly copying another rarity's value!
        if MM2ValuesNormalizedByRarity then
            for otherR, oNorm in pairs(MM2ValuesNormalizedByRarity) do
                if otherR ~= rarity then
                    if (normKey ~= "" and oNorm[normKey]) or (normNoParens ~= "" and oNorm[normNoParens]) or (normNoSuf ~= "" and oNorm[normNoSuf]) then
                        return nil
                    end
                end
            end
        end
    end

    -- 2. Direct match in MM2Values (only if rarity wasn't specified or matched)
    if not rarity then
        if MM2Values and MM2Values[clean] and MM2Values[clean] > 0 then
            return MM2Values[clean]
        end

        -- 3. Normalized key match in MM2ValuesNormalized
        if normKey ~= "" and MM2ValuesNormalized and MM2ValuesNormalized[normKey] and MM2ValuesNormalized[normKey] > 0 then
            return MM2ValuesNormalized[normKey]
        end

        -- 4. Chroma alias ("Chroma Luger" <-> "C. Luger")
        if clean:lower():find("^chroma%s+") then
            local cDot = clean:gsub("^[Cc][Hh][Rr][Oo][Mm][Aa]%s+", "C. ")
            if MM2Values and MM2Values[cDot] and MM2Values[cDot] > 0 then return MM2Values[cDot] end
            local cNorm = cDot:lower():gsub("[^%w]", "")
            if MM2ValuesNormalized and MM2ValuesNormalized[cNorm] and MM2ValuesNormalized[cNorm] > 0 then return MM2ValuesNormalized[cNorm] end
        elseif clean:lower():find("^c%.%s*") then
            local cFull = clean:gsub("^[Cc]%.%s*", "Chroma ")
            if MM2Values and MM2Values[cFull] and MM2Values[cFull] > 0 then return MM2Values[cFull] end
            local cNorm = cFull:lower():gsub("[^%w]", "")
            if MM2ValuesNormalized and MM2ValuesNormalized[cNorm] and MM2ValuesNormalized[cNorm] > 0 then return MM2ValuesNormalized[cNorm] end
        end

        -- 5. Match without parentheses e.g. "Sunset (Gun)" -> "Sunset"
        if noParens ~= "" and noParens ~= clean then
            if MM2Values and MM2Values[noParens] and MM2Values[noParens] > 0 then
                return MM2Values[noParens]
            end
            if normNoParens ~= "" and MM2ValuesNormalized and MM2ValuesNormalized[normNoParens] and MM2ValuesNormalized[normNoParens] > 0 then
                return MM2ValuesNormalized[normNoParens]
            end
        end

        -- 6. Match without weapon suffix
        if normNoSuf ~= "" and normNoSuf ~= normKey and MM2ValuesNormalized and MM2ValuesNormalized[normNoSuf] and MM2ValuesNormalized[normNoSuf] > 0 then
            return MM2ValuesNormalized[normNoSuf]
        end

        -- 7. Search all other rarities
        if MM2ValuesNormalizedByRarity then
            for _, checkR in ipairs({"Godly", "Ancient", "Vintage", "Legendary", "Rare", "Uncommon", "Common", "Pets", "Other"}) do
                local rNorm = MM2ValuesNormalizedByRarity[checkR]
                if rNorm then
                    if normKey ~= "" and rNorm[normKey] and rNorm[normKey] > 0 then return rNorm[normKey] end
                    if normNoParens ~= "" and rNorm[normNoParens] and rNorm[normNoParens] > 0 then return rNorm[normNoParens] end
                    if normNoSuf ~= "" and rNorm[normNoSuf] and rNorm[normNoSuf] > 0 then return rNorm[normNoSuf] end
                end
            end
        end
    end

    -- value could not be fetched
    return nil
end

-- Like getMM2ItemValue but uses icon to disambiguate gun vs knife.
-- Returns nil when value cannot be fetched or icon resolution fails on ambiguous names.
local function getMM2ItemValueWithIcon(rawName, rarity, iconObj)
    local resolved, iconRarity = nil, nil
    if iconObj then
        resolved, iconRarity = resolveItemNameFromIcon(iconObj)
    end

    -- If icon resolved to an item, verify rarity consistency
    -- If the card is detected as Common but the icon asset ID resolved to an Uncommon/Legendary item with the same name,
    -- or if icon is an unknown/new asset ID, do not falsely return the old item's value!
    if resolved and iconRarity and rarity and iconRarity ~= rarity then
        -- Rarity mismatch between known icon asset and current GUI card rarity!
        -- This indicates a new item reusing an existing name or new asset tier.
        return nil
    end

    local effectiveRarity = rarity or iconRarity
    if resolved then
        local v = getMM2ItemValue(resolved, effectiveRarity)
        if v and v > 0 then return v end
    end

    -- check if this base name is actually ambiguous (both gun+knife exist in DB)
    if rawName and MM2Values then
        local hasGun   = MM2Values[rawName .. " (Gun)"]   or MM2Values[rawName .. " Gun"]
        local hasKnife = MM2Values[rawName .. " (Knife)"] or MM2Values[rawName .. " Knife"]
        if hasGun and hasKnife and not resolved then return nil end  -- ambiguous, cannot be fetched without icon
    end

    return getMM2ItemValue(rawName, effectiveRarity)
end

local function getMM2ItemDisplay(rawName)
    if not rawName or rawName == "" then return nil end
    local clean = rawName:gsub("^%s+", ""):gsub("%s+$", "")
    if MM2ValueDisplays and MM2ValueDisplays[clean] then
        return MM2ValueDisplays[clean]
    end
    local lower = clean:lower()
    if MM2ValueDisplays then
        for name, disp in pairs(MM2ValueDisplays) do
            if name:lower() == lower then return disp end
        end
    end
    return nil
end

local function formatValue(val)
    if val == nil or val == "?" then return "?" end
    local num = tonumber(val)
    if not num then return "?" end
    if num >= 1000000 then
        return string.format("%.1fM", num / 1000000):gsub("%.0M", "M")
    elseif num >= 10000 then
        return string.format("%.1fk", num / 1000):gsub("%.0k", "k")
    elseif num >= 1 then
        if math.abs(num - math.floor(num)) > 0.01 then
            local formatted = string.format("%.2f", num):gsub("%.?0+$", "")
            return formatted
        else
            local formatted = tostring(math.floor(num))
            while true do
                local k
                formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", "%1,%2")
                if k == 0 then break end
            end
            return formatted
        end
    elseif num > 0 then
        local formatted = string.format("%.2f", num):gsub("%.?0+$", "")
        return formatted
    else
        return "0"
    end
end

-- load ui library from github
local Library = (function()
    local src = game:HttpGet("https://raw.githubusercontent.com/rilorfakesilly/scripts/refs/heads/main/MDuiLib.lua")
    local fn, err = loadstring(src, "MDuiLib")
    if not fn then
        error("[MorningDrift MM2] Failed to compile MDuiLib: " .. tostring(err), 2)
    end
    return fn()
end)()

Window = Library:CreateWindow({
    Title = "MorningDrift MM2",
    ScriptName = "MorningDrift MM2",
    Discord = "discord.gg/48jdqB8rAw",
    Languages = { "English", "Russian" },
    DefaultLanguage = "English",
    LanguageSelector = true,
    Translations = {
        Russian = {
            -- Tabs
            ["Main"] = "Главная",
            ["Autofarm"] = "Автофарм",
            ["Player"] = "Игрок",
            ["Murderer"] = "Убийца",
            ["Sheriff"] = "Шериф",
            ["Sounds"] = "Звуки",
            ["Visuals"] = "Визуалы",
            ["Animations"] = "Анимации",
            ["World"] = "Мир",
            ["Camera"] = "Камера",
            ["Webhook"] = "Вебхук",
            ["Settings"] = "Настройки",

            -- Sub Tabs
            ["Movement"] = "Движение",
            ["Aim & combat"] = "Аим и бой",
            ["ESP"] = "ВХ",
            ["Cosmetics"] = "Косметика",
            ["Effects"] = "Эффекты",

            -- Sections
            ["Farm"] = "Фарм",
            ["Aim & combat"] = "Аим и бой",
            ["Cosmetics"] = "Косметика",
            ["Effects"] = "Эффекты",
            ["ESP"] = "ВХ",
            ["Movement"] = "Движение",
            ["Body stuff"] = "Эффекты тела",
            ["China hat"] = "Азиатская шляпа",
            ["Spinbot"] = "Спинбот",
            ["Murderer tools"] = "Инструменты убийцы",
            ["Kill aura circle"] = "Круг киллауры",
            ["Sheriff tools"] = "Инструменты шерифа",
            ["Silent aim"] = "Сайлент аим",
            ["Auto aim"] = "Авто аим",
            ["Camlock"] = "Камлок",
            ["Gun ray"] = "Трейсер выстрела",
            ["Gunshot sound"] = "Звук выстрела",
            ["Knife kill sound"] = "Звук убийства ножом",
            ["Gun kill sound"] = "Звук убийства из пистолета",
            ["Reload sound"] = "Звук перезарядки",
            ["Coin pickup sound"] = "Звук сбора монет",
            ["Player esp"] = "ВХ на игроков",
            ["Custom crosshair"] = "Кастомный прицел",
            ["Crosshair"] = "Прицел",
            ["Emotes"] = "Эмоции",
            ["Custom animations"] = "Кастомные анимации",
            ["Skybox"] = "Небо (Skybox)",
            ["Atmosphere and lighting"] = "Атмосфера и освещение",
            ["Resolution stretch"] = "Растяжение экрана",
            ["Discord webhook"] = "Discord вебхук",
            ["Server"] = "Сервер",
            ["Auto open crates"] = "Автооткрытие ящиков",
            ["Auto server hop"] = "Авто смена сервера",
            ["Utility"] = "Утилиты",
            ["Target"] = "Цель",
            ["Mobile overlay"] = "Мобильный оверлей",
            ["Configurations"] = "Конфигурации",
            ["Credits"] = "Создатели",
            ["Language"] = "Язык",
            ["Audio & Notifications"] = "Звуки и уведомления",
            ["Interface & Customization"] = "Интерфейс и кастомизация",
            ["Neon wings"] = "Неоновые крылья",
            ["Orb"] = "Сфера",
            ["Trail"] = "Трейл",
            ["Jump ring"] = "Кольцо прыжка",
            ["Color animation"] = "Анимация цвета",
            ["Value calculator"] = "Калькулятор ценностей",
            ["Map voting"] = "Голосование за карту",
            ["Choose map"] = "Выбор карты",
            ["Start auto voting"] = "Начать автоголосование",
            ["Stop auto voting"] = "Остановить автоголосование",
            ["Start dupe voting"] = "Начать дюп голосования",
            ["Stop dupe voting"] = "Остановить дюп голосования",
            ["Refresh maps"] = "Обновить карты",

            -- Buttons & Actions
            ["Rejoin server"] = "Перезайти на сервер",
            ["Server hop"] = "Сменить сервер",
            ["Kill character"] = "Убить персонажа",
            ["Fling murderer"] = "Флингнуть убийцу",
            ["Fling murd"] = "Флингнуть убийцу",
            ["Fling sheriff"] = "Флингнуть шерифа",
            ["Fling target"] = "Флингнуть цель",
            ["Kill all"] = "Убить всех",
            ["Shoot"] = "Выстрелить",
            ["Wallbang murder"] = "Прострелить убийцу",
            ["Wallbang"] = "Прострел сквозь стены",
            ["Play emote"] = "Включить эмоцию",
            ["Stop emote"] = "Остановить эмоцию",
            ["Send test webhook"] = "Отправить тестовый вебхук",
            ["Teleport to target"] = "Телепорт к цели",
            ["Spectate target"] = "Наблюдать за целью",
            ["Add custom emote"] = "Добавить свою эмоцию",
            ["Remove custom emote"] = "Удалить свою эмоцию",
            ["Trade & inventory values"] = "Ценности инвентаря и трейда",
            ["Save config"] = "Сохранить конфиг",
            ["Load config"] = "Загрузить конфиг",
            ["Delete config"] = "Удалить конфиг",
            ["Export config"] = "Экспорт конфига",
            ["Import config"] = "Импорт конфига",
            ["Copy link"] = "Скопировать ссылку",
            ["Lock"] = "Захват цели",
            ["Fly"] = "Полёт",
            ["Auto bhop"] = "Авто распрыжка",
            ["Bunnyhop"] = "Распрыжка (Bhop)",
            ["Bhop speed"] = "Скорость распрыжки",
            ["Avoid murderer"] = "Убегать от убийцы",
            ["Avoid distance"] = "Дистанция побега",
            ["Spin speed"] = "Скорость вращения",
            ["Preset"] = "Пресет",
            ["Custom emote name"] = "Название эмоции",
            ["Custom animation ID"] = "ID анимации",
            ["Stop on move"] = "Остановка при ходьбе",
            ["Server hop"] = "Сменить сервер",
            ["Kill character"] = "Убить персонажа",
            ["Fling murderer"] = "Флингнуть убийцу",
            ["Fling murd"] = "Флингнуть убийцу",
            ["Fling sheriff"] = "Флингнуть шерифа",
            ["Fling target"] = "Флингнуть цель",
            ["Kill all"] = "Убить всех",
            ["Shoot"] = "Выстрелить",
            ["Wallbang murder"] = "Прострелить убийцу",
            ["Play emote"] = "Включить эмоцию",
            ["Stop emote"] = "Остановить эмоцию",
            ["Send test webhook"] = "Отправить тестовый вебхук",
            ["Teleport to target"] = "Телепорт к цели",
            ["Spectate target"] = "Наблюдать за целью",
            ["Add custom emote"] = "Добавить свою эмоцию",
            ["Remove custom emote"] = "Удалить свою эмоцию",
            ["Trade & inventory values"] = "Ценности инвентаря и трейда",

            -- Interface & Controls
            ["Interface language"] = "Язык интерфейса",
            ["Autofarm"] = "Автофарм",
            ["Autofarm mode"] = "Режим автофарма",
            ["Tween speed"] = "Скорость полёта (твина)",
            ["After farm"] = "После фарма",
            ["Auto take dropped gun"] = "Автоподбор выпавшего пистолета",
            ["Gun pickup method"] = "Способ подбора пистолета",
            ["Wait for round end"] = "Ждать конца раунда",
            ["Speed"] = "Скорость",
            ["Speed method"] = "Метод скорости",
            ["Speed value"] = "Значение скорости",
            ["Flight"] = "Полёт",
            ["Flight speed"] = "Скорость полёта",
            ["Jump power"] = "Сила прыжка",
            ["China hat cosmetic"] = "Косметика: шляпа",
            ["Hat always on top"] = "Шляпа поверх всего",
            ["Hat head offset"] = "Смещение шляпы",
            ["Hat cone height"] = "Высота конуса",
            ["Hat cone radius"] = "Радиус конуса",
            ["Follow user head (X/Z only)"] = "Следовать за головой (только X/Z)",
            ["Hat self player only"] = "Шляпа только для себя",
            ["Hat transparency"] = "Прозрачность шляпы",
            ["Hat color mode"] = "Цветовой режим шляпы",
            ["Hat primary color"] = "Основной цвет шляпы",
            ["Hat secondary color"] = "Второй цвет шляпы",
            ["Spinbot"] = "Спинбот",
            ["Spinbot rotation speed"] = "Скорость вращения спинбота",
            ["Min spin speed"] = "Мин. скорость вращения",
            ["Max spin speed"] = "Макс. скорость вращения",
            ["Degree difference"] = "Разница углов",
            ["Height difference"] = "Разница высоты",
            ["Random offset"] = "Случайное смещение",
            ["Horizontal prediction"] = "Горизонтальное упреждение",
            ["Vertical prediction"] = "Вертикальное упреждение",
            ["Fling offset"] = "Дистанция флинга",
            ["Fling dynamic Y velocity"] = "Динамическая Y скорость",
            ["Fling head height offset"] = "Высота цели для флинга",
            ["Anti fling"] = "Анти-флинг",
            ["Target player"] = "Выбрать игрока",
            ["Kill aura"] = "Киллаура",
            ["Kill aura range"] = "Радиус киллауры",
            ["Kill aura type"] = "Тип киллауры",
            ["Kill aura zone visible"] = "Отображать зону киллауры",
            ["Circle glow"] = "Свечение круга",
            ["Circle layers"] = "Слои круга",
            ["Circle transparency"] = "Прозрачность круга",
            ["Circle color 1"] = "Цвет круга 1",
            ["Circle color 2"] = "Цвет круга 2",
            ["Circle size"] = "Размер круга",
            ["Circle texture"] = "Текстура круга",
            ["Custom texture ID"] = "ID кастомной текстуры",
            ["Body particles"] = "Частицы на теле",
            ["Particle preset"] = "Пресет частиц",
            ["Custom particle asset id"] = "ID кастомных частиц",
            ["Particle emission rate"] = "Частота испускания частиц",
            ["Particle lifetime"] = "Время жизни частиц",
            ["Particle speed"] = "Скорость частиц",
            ["Particle size"] = "Размер частиц",
            ["Particle transparency"] = "Прозрачность частиц",
            ["Particle spin"] = "Вращение частиц",
            ["Particle orientation"] = "Ориентация частиц",
            ["Particle color mode"] = "Цветовой режим частиц",
            ["Particle primary color"] = "Основной цвет частиц",
            ["Particle secondary color"] = "Второй цвет частиц",
            ["Particle flipbook animation"] = "Флипбук-анимация частиц",
            ["Flipbook mode"] = "Режим флипбука",
            ["Flipbook layout (grid)"] = "Сетка флипбука",
            ["Flipbook play speed"] = "Скорость проигрывания",
            ["Neon wings cosmetic"] = "Неоновые крылья",
            ["Wings self player only"] = "Крылья только для себя",
            ["Wings glow"] = "Свечение крыльев",
            ["Wings scale size"] = "Размер крыльев",
            ["Wings flap speed"] = "Скорость взмахов",
            ["Wings transparency"] = "Прозрачность крыльев",
            ["Wings position offset x"] = "Смещение крыльев по X",
            ["Wings position offset y"] = "Смещение крыльев по Y",
            ["Wings position offset z"] = "Смещение крыльев по Z",
            ["Wings color mode"] = "Цветовой режим крыльев",
            ["Wings primary color"] = "Основной цвет крыльев",
            ["Wings secondary color"] = "Второй цвет крыльев",
            ["Orbiting light orb"] = "Орбитальная световая сфера",
            ["Orb orbit distance"] = "Дистанция орбиты",
            ["Orb orbit speed"] = "Скорость орбиты",
            ["Orb size scale"] = "Размер сферы",
            ["Orb color mode"] = "Цветовой режим сферы",
            ["Orb primary color"] = "Основной цвет сферы",
            ["Orb secondary color"] = "Второй цвет сферы",
            ["Character trail"] = "Трейл за персонажем",
            ["Trail duration lifetime"] = "Длительность трейла",
            ["Trail width scale"] = "Ширина трейла",
            ["Trail transparency"] = "Прозрачность трейла",
            ["Trail color mode"] = "Цветовой режим трейла",
            ["Trail primary color"] = "Основной цвет трейла",
            ["Trail secondary color"] = "Второй цвет трейла",
            ["Jump ring"] = "Кольцо прыжка",
            ["Ring max size"] = "Макс. размер кольца",
            ["Ring fade speed"] = "Скорость затухания кольца",
            ["Ring color mode"] = "Цветовой режим кольца",
            ["Ring color 1"] = "Цвет кольца 1",
            ["Ring color 2"] = "Цвет кольца 2",
            ["Translucent body"] = "Полупрозрачное тело",
            ["Body color mode"] = "Цветовой режим тела",
            ["Body primary color"] = "Основной цвет тела",
            ["Body secondary color"] = "Второй цвет тела",
            ["Gun ray"] = "Трейсер выстрела",
            ["Own shots only"] = "Только свои выстрелы",
            ["Ray texture"] = "Текстура луча",
            ["Color mode"] = "Режим цвета",
            ["Color"] = "Цвет",
            ["Color 2 (Gradient / Shift)"] = "Цвет 2 (Градиент / Перелив)",
            ["Width"] = "Ширина",
            ["Initial transparency"] = "Начальная прозрачность",
            ["Fade in"] = "Появление",
            ["Duration"] = "Длительность",
            ["Glowing"] = "Свечение",
            ["Light emission"] = "Излучение света",
            ["Rainbow & gradient animation speed"] = "Скорость анимации цвета",
            ["Auto aim"] = "Авто аим",
            ["Hit chance"] = "Шанс попадания",
            ["Target body part"] = "Часть тела цели",
            ["Wallbang"] = "Прострел сквозь стены",
            ["Silent aim"] = "Сайлент аим",
            ["Target part"] = "Целевая часть",
            ["Wall check"] = "Проверка стен",
            ["Alive check"] = "Проверка на живого",
            ["Fov circle"] = "Круг FOV",
            ["Fov radius"] = "Радиус FOV",
            ["Spin fov"] = "Вращение FOV",
            ["Fov transparency"] = "Прозрачность FOV",
            ["Fill fov"] = "Заливка FOV",
            ["Fov drop shadow"] = "Тень круга FOV",
            ["Fov shadow transparency"] = "Прозрачность тени FOV",
            ["Camlock"] = "Камлок",
            ["Camlock smoothness"] = "Плавность камлока",
            ["Enable ESP"] = "Включить ESP",
            ["Esp chams"] = "Чамсы игроков",
            ["Esp box"] = "Боксы (Box ESP)",
            ["Esp skeleton"] = "Скелеты (Skeleton ESP)",
            ["Esp name"] = "Имена игроков",
            ["Esp role"] = "Роли игроков",
            ["Gun ESP"] = "Пистолет (Gun ESP)",
            ["Chams mode"] = "Режим чамсов",
            ["Murderer chams color"] = "Цвет чамсов убийцы",
            ["Sheriff chams color"] = "Цвет чамсов шерифа",
            ["Innocent chams color"] = "Цвет чамсов невиновного",
            ["Highlight fill transparency"] = "Прозрачность заливки",
            ["Highlight outline transparency"] = "Прозрачность обводки",
            ["Esp max render distance"] = "Макс. дистанция отрисовки ESP",
            ["Skeleton color mode"] = "Цветовой режим скелетов",
            ["Skeleton use role color"] = "Цвет роли для скелета",
            ["Skeleton primary color"] = "Основной цвет скелета",
            ["Skeleton secondary color"] = "Второй цвет скелета",
            ["Skeleton line thickness"] = "Толщина линий скелета",
            ["Skeleton transparency"] = "Прозрачность скелета",
            ["Custom crosshair"] = "Кастомный прицел",
            ["Crosshair preset"] = "Пресет прицела",
            ["Crosshair follows cursor"] = "Прицел следует за курсором",
            ["Spin crosshair"] = "Вращение прицела",
            ["Crosshair spin speed"] = "Скорость вращения",
            ["Crosshair size scale"] = "Размер прицела",
            ["Crosshair transparency"] = "Прозрачность прицела",
            ["Crosshair color mode"] = "Цветовой режим прицела",
            ["Crosshair primary color"] = "Основной цвет прицела",
            ["Crosshair secondary color"] = "Второй цвет прицела",
            ["Crosshair animation speed"] = "Скорость анимации прицела",
            ["Crosshair flipbook animation"] = "Флипбук-анимация прицела",
            ["Crosshair flipbook mode"] = "Режим флипбука прицела",
            ["Crosshair flipbook layout"] = "Сетка флипбука прицела",
            ["Crosshair custom asset id"] = "Кастомный ID прицела",
            ["Crosshair custom flipbook"] = "Кастомный флипбук прицела",
            ["Custom crosshair asset id"] = "Кастомный ID прицела",
            ["Select emote"] = "Выбрать эмоцию",
            ["Stop on move"] = "Останавливать при движении",
            ["Custom emote name"] = "Название своей эмоции",
            ["Custom animation ID"] = "ID анимации",
            ["Animation pack ID"] = "ID набора анимаций",
            ["Custom animations"] = "Кастомные анимации",
            ["Custom skybox id"] = "ID кастомного скайбокса",
            ["Skybox preset"] = "Пресет скайбокса",
            ["Custom time"] = "Кастомное время суток",
            ["Time"] = "Время",
            ["Custom brightness"] = "Кастомная яркость",
            ["Brightness"] = "Яркость",
            ["Custom fog"] = "Кастомный туман",
            ["Fog distance"] = "Дистанция тумана",
            ["Fog color"] = "Цвет тумана",
            ["Custom field of view"] = "Кастомный угол обзора (FOV)",
            ["Field of view"] = "Угол обзора (FOV)",
            ["Enable stretch"] = "Включить растяжение",
            ["Horizontal stretch"] = "Растяжение по горизонтали",
            ["Vertical stretch"] = "Растяжение по вертикали",
            ["Gun sound preset"] = "Пресет звука выстрела",
            ["Gun sound volume"] = "Громкость выстрела",
            ["Custom gun sound"] = "Кастомный звук выстрела",
            ["Knife kill volume"] = "Громкость убийства ножом",
            ["Custom knife kill sound"] = "Кастомный звук убийства ножом",
            ["Gun kill volume"] = "Громкость убийства из пистолета",
            ["Custom gun kill sound"] = "Кастомный звук убийства из пистолета",
            ["Reload volume"] = "Громкость перезарядки",
            ["Custom reload sound"] = "Кастомный звук перезарядки",
            ["Coin sound volume"] = "Громкость сбора монет",
            ["Custom coin pickup sound"] = "Кастомный звук сбора монет",
            ["Custom sound asset ID"] = "ID кастомного звука",
            ["Auto open crates"] = "Автооткрытие ящиков",
            ["Crate box type"] = "Тип ящика",
            ["Auto server hop"] = "Авто смена сервера",
            ["Hop timer"] = "Таймер смены",
            ["Webhook logger"] = "Логирование в вебхук",
            ["Webhook url"] = "URL вебхука",
            ["Webhook interval"] = "Интервал отправки вебхука",
            ["Include current coins"] = "Указывать текущие монеты",
            ["Include coins / hour"] = "Указывать монеты / час",
            ["Mobile buttons overlay"] = "Кнопки на экране для телефона",
            ["Lock button positions"] = "Заблокировать позиции кнопок",
            ["Flight button"] = "Кнопка полёта",
            ["Camlock button"] = "Кнопка камлока",
            ["Shoot button"] = "Кнопка выстрела",
            ["Fling murderer button"] = "Кнопка флинга убийцы",
            ["Fling sheriff button"] = "Кнопка флинга шерифа",
            ["Enable notifications"] = "Включить уведомления",
            ["Enable UI sounds"] = "Включить звуки интерфейса",
            ["UI sound volume"] = "Громкость звуков UI",
            ["Theme preset"] = "Пресет темы",
            ["Custom theme color"] = "Кастомный цвет темы",
            ["Custom background transparency"] = "Кастомная прозрачность фона",
            ["Elements transparency"] = "Прозрачность элементов",
            ["Top/bottom bar transparency"] = "Прозрачность верхней/нижней панели",
            ["Enable UI shadows"] = "Включить тени интерфейса",
            ["Shadow intensity"] = "Интенсивность теней",
            ["Sections transparent"] = "Прозрачные секции",
            ["Background blur"] = "Размытие фона",
            ["Spiderweb background"] = "Фоновая паутинка",
            ["Click particles"] = "Частицы при клике",
            ["Click particle type"] = "Тип частиц клика",
            ["Noise overlay"] = "Шумовой оверлей",
            ["Noise type"] = "Тип шума",
            ["Noise size"] = "Размер зерна шума",
            ["Noise transparency"] = "Прозрачность шума",
            ["Save config"] = "Сохранить конфигурацию",
            ["Load config"] = "Загрузить конфигурацию",
            ["Delete config"] = "Удалить конфигурацию",
            ["Config name"] = "Название конфига",
            ["Export config"] = "Экспорт конфига",
            ["Import config"] = "Импорт конфига",
            ["Creator"] = "Создатель",
            ["Developer"] = "Разработчик",
            ["Creator and developer"] = "Создатель и разработчик",
            ["Discord"] = "Дискорд",
            ["Discord server"] = "Сервер Discord",
            ["Discord server if you have any questions"] = "Сервер Discord, если у вас есть вопросы",
            ["Click to copy Discord link"] = "Нажмите, чтобы скопировать ссылку",
            ["Copy link"] = "Копировать ссылку",
            ["UI shadows"] = "Тени интерфейса",
            ["Section backgrounds"] = "Фон секций",
            ["Background noise"] = "Шумовой фон",
            ["Noise tile size"] = "Размер зерна шума",
            ["Background transparency"] = "Прозрачность фона",
            ["UI elements transparency"] = "Прозрачность элементов",
            ["Top, left & bottom frames transparency"] = "Прозрачность панелей",
            ["Blur intensity"] = "Интенсивность размытия",
            ["Enable click effects"] = "Включить эффекты клика",
            ["Particle style"] = "Стиль частиц",
            ["Custom image ID"] = "ID своего изображения",
            ["Themes"] = "Темы",
            ["Click Effects & Particles"] = "Эффекты и частицы клика",
            ["Appearance & Visuals"] = "Внешний вид и визуалы",
            ["Hover sound ID"] = "ID звука наведения",
            ["Click sound ID"] = "ID звука клика",
            ["Notification sound ID"] = "ID звука уведомления",
            ["Anchored"] = "Зафиксировать (Anchored)",
            ["Glowing"] = "Свечение (Glowing)",
            ["Fade in"] = "Плавное появление (Fade in)",
            ["Fov shape"] = "Форма FOV",
            ["Color mode"] = "Цветовой режим",
            ["Jump ring color mode"] = "Цветовой режим кольца прыжка",
            ["Skeleton color mode"] = "Цветовой режим скелета"
        }
    }
})

-- leverage library layout rows for element grouping

-- sync palette updates to active elements
local _origApplyTheme = Window.ApplyTheme
function Window:ApplyTheme(themeKey, animated)
    local res = _origApplyTheme(self, themeKey, animated)
    local currentTheme = Window.CurrentTheme or (Library.ThemePresets and Library.ThemePresets[themeKey])
    if currentTheme then
        if Window.RegisteredMDButtons then
            for _, btnData in ipairs(Window.RegisteredMDButtons) do
                if btnData and btnData.Frame and btnData.Frame.Parent then
                    btnData.Frame.BackgroundColor3 = currentTheme.ButtonBG
                    if btnData.TextLabel then btnData.TextLabel.TextColor3 = currentTheme.Text end
                end
            end
        end
        if Window.RegisteredSections then
            for _, sec in ipairs(Window.RegisteredSections) do
                if sec and sec.RefreshTheme then
                    pcall(function() sec:RefreshTheme(currentTheme, animated) end)
                end
            end
        end
    end
    return res
end

local _origApplyCustomTheme = Window.ApplyCustomTheme
function Window:ApplyCustomTheme(baseColor, animated)
    local res = _origApplyCustomTheme(self, baseColor, animated)
    local currentTheme = Window.CurrentTheme
    if currentTheme then
        if Window.RegisteredMDButtons then
            for _, btnData in ipairs(Window.RegisteredMDButtons) do
                if btnData and btnData.Frame and btnData.Frame.Parent then
                    btnData.Frame.BackgroundColor3 = currentTheme.ButtonBG
                    if btnData.TextLabel then btnData.TextLabel.TextColor3 = currentTheme.Text end
                end
            end
        end
        if Window.RegisteredSections then
            for _, sec in ipairs(Window.RegisteredSections) do
                if sec and sec.RefreshTheme then
                    pcall(function() sec:RefreshTheme(currentTheme, animated) end)
                end
            end
        end
    end
    return res
end

local Options = {}

local function log(msg)
    pcall(function()
        if Window and Window.Notify then
            Window:Notify("MD MM2", tostring(msg), 3)
        end
    end)
end

-- control atmosphere and ambient contrast

local skyboxPresets = {
    ["Default"] = nil,
    ["Space Skybox"] = "136402262",
    ["Fog on the water"] = "15876671760",
    ["Red sky"] = "136055162054954",
    ["Midnight"] = "179809386",
    ["Tattletail"] = "75818364502492"
}

worldState = {
    skyboxPreset = "Default",
    customTime = 14,
    timeEnabled = false,
    customBrightness = 2,
    brightnessEnabled = false,
    customFog = false,
    fogEndDistance = 2000,
    fogColor = Color3.fromRGB(180, 200, 220),
}

defaultLighting = {
    ClockTime = LightingService.ClockTime,
    Brightness = LightingService.Brightness,
    FogEnd = LightingService.FogEnd,
    FogColor = LightingService.FogColor
}

local activeSkyboxAssetId = nil

local function applySkybox(assetId)
    activeSkyboxAssetId = (assetId and assetId ~= "") and assetId or nil

    if currentCustomSky then
        pcall(function() currentCustomSky:Destroy() end)
        currentCustomSky = nil
    end

    if not assetId or assetId == "" then return end

    local cleanId = tostring(assetId):match("%d+")
    if not cleanId then return end

    for _, child in ipairs(LightingService:GetChildren()) do
        if child:IsA("Sky") and child.Name ~= "CustomSkybox" then
            pcall(function() child:Destroy() end)
        end
    end

    local loaded = false
    pcall(function()
        local objects = game:GetObjects("rbxassetid://" .. cleanId)
        if objects and #objects > 0 then
            local skyObj = nil
            for _, obj in ipairs(objects) do
                if obj:IsA("Sky") then
                    skyObj = obj
                    break
                elseif obj:FindFirstChildOfClass("Sky") then
                    skyObj = obj:FindFirstChildOfClass("Sky")
                    break
                end
            end
            if skyObj then
                skyObj.Name = "CustomSkybox"
                skyObj.Parent = LightingService
                currentCustomSky = skyObj
                loaded = true
            end
        end
    end)

    if not loaded then
        local sky = Instance.new("Sky")
        sky.Name = "CustomSkybox"
        local formatted = "rbxassetid://" .. cleanId
        sky.SkyboxBk = formatted
        sky.SkyboxDn = formatted
        sky.SkyboxFt = formatted
        sky.SkyboxLf = formatted
        sky.SkyboxRt = formatted
        sky.SkyboxUp = formatted
        sky.CelestialBodiesShown = true
        sky.Parent = LightingService
        currentCustomSky = sky
    end
end

-- keep custom skybox across round map reloads
task.spawn(function()
    while not (state and state.unloaded) do
        task.wait(1.5)
        if state and state.unloaded then break end
        if activeSkyboxAssetId and activeSkyboxAssetId ~= "" then
            local needsRefresh = false
            if not currentCustomSky or currentCustomSky.Parent ~= LightingService then
                needsRefresh = true
            else
                for _, child in ipairs(LightingService:GetChildren()) do
                    if child:IsA("Sky") and child ~= currentCustomSky then
                        pcall(function() child:Destroy() end)
                        needsRefresh = true
                    end
                end
            end
            if needsRefresh then
                applySkybox(activeSkyboxAssetId)
            end
        end
    end
end)

local function updateLighting()
    if not worldState then return end
    if worldState.timeEnabled then
        LightingService.ClockTime = worldState.customTime
    end
    if worldState.brightnessEnabled then
        LightingService.Brightness = worldState.customBrightness
    end
    if worldState.customFog then
        local atmos = LightingService:FindFirstChildOfClass("Atmosphere")
        if atmos then
            atmos.Density = math.clamp(1 - (worldState.fogEndDistance / 5000), 0.1, 0.95)
            atmos.Color = worldState.fogColor
            atmos.Decay = worldState.fogColor
        end
        LightingService.FogStart = 0
        LightingService.FogEnd = worldState.fogEndDistance
        LightingService.FogColor = worldState.fogColor
    end
end

trackThread(task.spawn(function()
    while not (state and state.unloaded) do
        updateLighting()
        task.wait(1.5)
    end
end))

-- widen field of view and stretch aspect ratio
stretchSettings = {
    enabled = false,
    horizontalScale = 0.53,
    verticalScale = 0.74,
    customFov = 70,
    fovModifierEnabled = false
}

local function onCameraStep()
    if state and state.unloaded then return end

    -- scale camera fov dynamically
    if stretchSettings.fovModifierEnabled then
        CurrentCamera.FieldOfView = stretchSettings.customFov
    end

    -- adjust viewport aspect scale
    if stretchSettings.enabled then
        local cf = CurrentCamera.CFrame
        local x, y, z, r00, r01, r02, r10, r11, r12, r20, r21, r22 = cf:GetComponents()
        local sx = stretchSettings.horizontalScale
        local sy = stretchSettings.verticalScale

        CurrentCamera.CFrame = CFrame.new(
            x, y, z,
            r00 * sx, r01 * sy, r02,
            r10 * sx, r11 * sy, r12,
            r20 * sx, r21 * sy, r22
        )
    end
end

pcall(function()
    RunService:BindToRenderStep("CameraPipeline", Enum.RenderPriority.Camera.Value + 1, onCameraStep)
end)


-- detect active murderer and sheriff gear 
local function isKnifeTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    if tool.Name == "Knife" then return true end
    if tool:FindFirstChild("KnifeServer") or tool:FindFirstChild("Stab") or tool:FindFirstChild("KnifeHost") or tool:FindFirstChild("Throw") or tool:FindFirstChild("Knife") or tool:FindFirstChild("KnifeClient") then
        return true
    end
    return false
end

local function isGunTool(tool)
    if not tool or not tool:IsA("Tool") then return false end
    if tool.Name == "Gun" or tool.Name == "Revolver" then return true end
    if tool:FindFirstChild("GunServer") or tool:FindFirstChild("Shoot") or tool:FindFirstChild("GunHost") or tool:FindFirstChild("ShootScript") or tool:FindFirstChild("GunClient") then
        return true
    end
    return false
end

local function getPlayerTool(plr, toolType)
    if not plr then return nil end
    local containers = {}
    if plr.Character then table.insert(containers, plr.Character) end
    local bp = plr:FindFirstChild("Backpack")
    if bp then table.insert(containers, bp) end

    for _, container in ipairs(containers) do
        for _, item in ipairs(container:GetChildren()) do
            if item:IsA("Tool") then
                if toolType == "Knife" and isKnifeTool(item) then
                    return item
                elseif toolType == "Gun" and isGunTool(item) then
                    return item
                elseif item.Name == toolType then
                    return item
                end
            end
        end
    end
    return nil
end

local function hasTool(plr, toolType)
    return getPlayerTool(plr, toolType) ~= nil
end

local function isPlayerAlive(plr)
    if not plr or not plr.Parent then return false end
    local char = plr.Character
    if not char then return false end
    local hum = char:FindFirstChildOfClass("Humanoid")
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hum or not hrp then return false end
    if hum.Health <= 0 then return false end
    return true
end

local function getPlayerData()
    local rs = game:GetService("ReplicatedStorage")
    local pd = rs:FindFirstChild("GetPlayerData", true) or rs:FindFirstChild("PlayerData", true)
    if pd then
        local success, data
        if pd:IsA("BindableFunction") then
            success, data = pcall(function() return pd:Invoke() end)
        elseif pd:IsA("RemoteFunction") then
            success, data = pcall(function() return pd:InvokeServer() end)
        end
        if success and type(data) == "table" then
            return data
        end
    end
    return nil
end

local _lastRolesCache = { murderer = nil, sheriff = nil, lastCheck = 0 }

local function getGameRoles()
    if tick() - _lastRolesCache.lastCheck < 0.25 then
        return _lastRolesCache.murderer, _lastRolesCache.sheriff
    end
    _lastRolesCache.lastCheck = tick()
    local murderer, sheriff = nil, nil

    -- check replicated state first to avoid backpack scan
    local playerData = getPlayerData()
    if playerData then
        for player, data in pairs(playerData) do
            if type(data) == "table" and data.Role then
                local targetPlr = nil
                if typeof(player) == "Instance" and player:IsA("Player") then
                    targetPlr = player
                elseif type(player) == "string" then
                    targetPlr = Players:FindFirstChild(player)
                end
                if targetPlr and isPlayerAlive(targetPlr) then
                    local r = data.Role
                    if r == "Murderer" or r == "Murder" then
                        murderer = targetPlr
                    elseif r == "Sheriff" or r == "Hero" then
                        sheriff = targetPlr
                    end
                end
            end
        end
    end

    -- scan tool instances when replicated data is missing
    if not murderer then
        if state.knifeHolder and isPlayerAlive(state.knifeHolder) then
            murderer = state.knifeHolder
        else
            for _, p in ipairs(Players:GetPlayers()) do
                if isPlayerAlive(p) and hasTool(p, "Knife") then
                    murderer = p
                    break
                end
            end
        end
    end

    if not sheriff then
        if state.gunHolder and isPlayerAlive(state.gunHolder) then
            sheriff = state.gunHolder
        else
            for _, p in ipairs(Players:GetPlayers()) do
                if isPlayerAlive(p) and hasTool(p, "Gun") then
                    sheriff = p
                    break
                end
            end
        end
    end

    _lastRolesCache.murderer = murderer
    _lastRolesCache.sheriff = sheriff
    return murderer, sheriff
end

local function getMurd()
    local murderer, _ = getGameRoles()
    return murderer
end
local function getSheriff()
    local _, sheriff = getGameRoles()
    return sheriff
end

local function getPlayerRole(plr)
    if not plr then return "Innocent" end
    local m, s = getGameRoles()
    if m and m == plr and isPlayerAlive(plr) then return "Murderer" end
    if s and s == plr and isPlayerAlive(plr) then return "Sheriff" end
    return "Innocent"
end

local function getMurderers()
    local list = {}
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and isPlayerAlive(p) and hasTool(p, "Knife") then
            list[#list + 1] = p
        end
    end
    if #list == 0 then
        local m = state.knifeHolder or getMurd()
        if m and m ~= LocalPlayer and isPlayerAlive(m) then list[1] = m end
    end
    return list
end

local function getClosestMurderer()
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    local best, bestDist
    for _, p in ipairs(getMurderers()) do
        local hrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local d = myHrp and (hrp.Position - myHrp.Position).Magnitude or 0
            if not bestDist or d < bestDist then best, bestDist = p, d end
        end
    end
    return best
end

-- configure projectile aim-assist bounds
local silentAimConfig = {
    enabled = false,
    hitChance = 100,
    targetPart = "Head",
    randomOffset = false,
    wallCheck = false,
    aliveCheck = true,
    wallbang = false,
    predictionFactor = 0.2,
    horizontalPrediction = 0.2,
    verticalPrediction = 0.2,

    fovRadius = 125,
    fovVisible = true,
    fovType = "Normal",
    spin = false,
    spinSpeed = 60,
    colorMode = "Normal",
    color1 = Color3.fromRGB(255, 60, 60),
    color2 = Color3.fromRGB(0, 170, 255),
    transparency = 0,
    shadow = false,
    shadowTransparency = 0.5,
    filled = false,
}

local customSoundPresets = {
    Gunshot = {
        ["Minecraft"]    = "123925235254965",
        ["Laser"]        = "1898322396",
        ["CS:GO Deagle"] = "82286818216627",
        ["Custom"]       = ""
    },
    Coin = {
        ["Ultrakill coinflip"] = "138571475125488",
        ["Coin click"]         = "133570405319995",
        ["Coin click 2"]       = "10066947742",
        ["Custom"]             = ""
    },
    Reload = {
        ["Laser pistol"] = "1898332552",
        ["Custom"]       = ""
    },
    GunKill = {
        ["Fortnite knocked"] = "118171751820277",
        ["CS:GO headshot"]   = "118849595584555",
        ["Fatality"]         = "115982072912004",
        ["Rust headshot"]    = "138750331387064",
        ["Tom scream"]       = "139694892021582",
        ["Old church bell"]  = "139726388352120",
        ["Ouch"]             = "137171473068941",
        ["Minecraft"]        = "135478009117226",
        ["Death note"]       = "140695149439373",
        ["Victory"]          = "124793974135748",
        ["Stariy bog"]       = "117940360151688",
        ["Stariy bog yaica"] = "120335972389688",
        ["Custom"]           = ""
    },
    KnifeKill = {
        ["Golden pan"]   = "135260359985455",
        ["Orange water"] = "94072167050534",
        ["Bye bye"]      = "111254351722884",
        ["Katana"]       = "109880603489484",
        ["Knife slice"]  = "133096341705333",
        ["Custom"]       = ""
    }
}

local customSoundConfigs = {
    Gunshot = {
        Enabled = false,
        Target = "Own",
        Preset = "Minecraft",
        CustomId = "",
        SoundId = "123925235254965",
        Volume = 1.0,
    },
    Coin = {
        Enabled = false,
        Target = "Own",
        Preset = "Ultrakill coinflip",
        CustomId = "",
        SoundId = "138571475125488",
        Volume = 1.0,
    },
    Reload = {
        Enabled = false,
        Target = "Own",
        Preset = "Laser pistol",
        CustomId = "",
        SoundId = "1898332552",
        Volume = 1.0,
    },
    GunKill = {
        Enabled = false,
        Target = "Own",
        Preset = "Fortnite knocked",
        CustomId = "",
        SoundId = "118171751820277",
        Volume = 1.0,
    },
    KnifeKill = {
        Enabled = false,
        Target = "Own",
        Preset = "Golden pan",
        CustomId = "",
        SoundId = "135260359985455",
        Volume = 1.0,
    }
}

local function getActiveCustomSoundId(cat)
    local cfg = customSoundConfigs[cat]
    if not cfg then return "" end
    local preset = cfg.Preset
    if preset == "Custom" then
        return cfg.CustomId or ""
    end
    local presets = customSoundPresets[cat]
    return (presets and presets[preset]) or cfg.CustomId or cfg.SoundId or ""
end

local refreshCustomSounds = function() end

local fovCircleDrawing = nil
local fovDotDrawings = {}
local fovLineDrawings = {}
local fovCircleGuiFrame = nil
local fovCircleGui = nil

local function removeFOVCircle()
    if fovCircleDrawing then
        pcall(function() fovCircleDrawing.Visible = false end)
        pcall(function() fovCircleDrawing:Remove() end)
        fovCircleDrawing = nil
    end
    for _, dot in ipairs(fovDotDrawings) do
        pcall(function() dot.Visible = false end)
        pcall(function() dot:Remove() end)
    end
    table.clear(fovDotDrawings)
    for _, line in ipairs(fovLineDrawings) do
        pcall(function() line.Visible = false end)
        pcall(function() line:Remove() end)
    end
    table.clear(fovLineDrawings)
    if fovCircleGui then
        pcall(function() fovCircleGui:Destroy() end)
        fovCircleGui = nil
        fovCircleGuiFrame = nil
    end
end

local _fovGradientAngle = 0
local _canCreateUIShadow = true
local fovElementsContainer = nil

local function updateFOVCircle()
    if not silentAimConfig.enabled or not silentAimConfig.fovVisible or (state and state.unloaded) then
        removeFOVCircle()
        return
    end

    -- avoid orphaned overlays across mode switches
    if fovCircleDrawing then pcall(function() fovCircleDrawing.Visible = false end) end
    for _, d in ipairs(fovDotDrawings) do pcall(function() d.Visible = false end) end
    for _, l in ipairs(fovLineDrawings) do pcall(function() l.Visible = false end) end

    local mouseLoc = UserInputService:GetMouseLocation()
    local colorMode = silentAimConfig.colorMode or "Normal"
    local fovType = silentAimConfig.fovType or "Normal"
    local r = silentAimConfig.fovRadius or 100
    local c1 = silentAimConfig.color1 or Color3.fromRGB(255, 0, 0)
    local c2 = silentAimConfig.color2 or Color3.fromRGB(0, 170, 255)
    local trans = silentAimConfig.transparency or 0

    if not fovCircleGuiFrame then
        local parentGui = gethui and gethui() or (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui") or PlayerGui)
        local sg = Instance.new("ScreenGui")
        sg.Name = "FOVCircleGui"
        sg.ResetOnSpawn = false
        sg.IgnoreGuiInset = true
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

        local f = Instance.new("Frame")
        f.Name = "FOVCircle"
        f.AnchorPoint = Vector2.new(0.5, 0.5)
        f.BackgroundTransparency = 1
        f.Parent = sg

        local c = Instance.new("UICorner", f)
        c.CornerRadius = UDim.new(1, 0)

        local s = Instance.new("UIStroke", f)
        s.Thickness = 2
        s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

        sg.Parent = parentGui
        fovCircleGui = sg
        fovCircleGuiFrame = f
    end

    local diam = r * 2
    fovCircleGuiFrame.Size = UDim2.fromOffset(diam, diam)
    fovCircleGuiFrame.Position = UDim2.fromOffset(mouseLoc.X, mouseLoc.Y)
    fovCircleGuiFrame.BackgroundTransparency = silentAimConfig.filled and trans or 1
    fovCircleGuiFrame.BackgroundColor3 = c1

    local uiShadow = fovCircleGuiFrame:FindFirstChildOfClass("UIShadow")
    if silentAimConfig.shadow then
        if not uiShadow and _canCreateUIShadow then
            local ok, s = pcall(function() return Instance.new("UIShadow") end)
            if ok and s then
                s.BlurRadius = UDim.new(0, 15)
                s.Color = Color3.new(0, 0, 0)
                s.Offset = UDim2.new(0, 2, 0, 2)
                s.Parent = fovCircleGuiFrame
                uiShadow = s
            else
                _canCreateUIShadow = false
            end
        end
        if uiShadow then
            pcall(function()
                uiShadow.Transparency = silentAimConfig.shadowTransparency or 0.5
                uiShadow.Color = Color3.new(0, 0, 0)
                uiShadow.Enabled = true
            end)
        end
    else
        if uiShadow then
            pcall(function() uiShadow.Enabled = false end)
        end
    end

    local rotOffset = (silentAimConfig.spin and (tick() * (silentAimConfig.spinSpeed or 60) * (math.pi / 180))) or 0
    if silentAimConfig.spin then
        fovCircleGuiFrame.Rotation = (fovCircleGuiFrame.Rotation + (silentAimConfig.spinSpeed or 60) * 0.016) % 360
    else
        fovCircleGuiFrame.Rotation = 0
    end

    local stroke = fovCircleGuiFrame:FindFirstChildOfClass("UIStroke")

    -- group procedural indicator segments
    if fovType == "Dots" or fovType == "Stripes" or fovType == "Dots out of dots" then
        if stroke then stroke.Enabled = false end
        fovCircleGuiFrame.BackgroundTransparency = 1

        if not fovElementsContainer or fovElementsContainer.Parent ~= fovCircleGui then
            if fovElementsContainer then pcall(function() fovElementsContainer:Destroy() end) end
            local container = Instance.new("Frame")
            container.Name = "FOVElementsContainer"
            container.BackgroundTransparency = 1
            container.Size = UDim2.new(1, 0, 1, 0)
            container.Parent = fovCircleGui
            fovElementsContainer = container
        end
        fovElementsContainer.Visible = true

        local isDots = (fovType == "Dots")
        local isDotsOut = (fovType == "Dots out of dots")
        local isStripes = (fovType == "Stripes")

        local count = 12
        local assetId = "rbxassetid://187012669"

        if isDots then
            count = math.clamp(math.floor(r / 5), 16, 48)
            assetId = "rbxassetid://187012669"
        elseif isDotsOut then
            count = math.clamp(math.floor(r / 6), 12, 36)
            assetId = "rbxassetid://76727753077449"
        elseif isStripes then
            count = 12 -- space ring segments evenly around circumference
            assetId = "rbxassetid://125191624584912"
        end

        local shiftSpeed = state and state.colorShiftSpeed or 3
        local animPhase = (tick() * (shiftSpeed * 0.15)) % 1.0

        for i = 1, count do
            local childName = "Elem_" .. i
            local imgLabel = fovElementsContainer:FindFirstChild(childName)
            if not imgLabel then
                imgLabel = Instance.new("ImageLabel")
                imgLabel.Name = childName
                imgLabel.BackgroundTransparency = 1
                imgLabel.AnchorPoint = Vector2.new(0.5, 0.5)
                imgLabel.Parent = fovElementsContainer
            end

            local angle = (i / count) * math.pi * 2 + rotOffset
            local pos = mouseLoc + Vector2.new(math.cos(angle) * r, math.sin(angle) * r)
            imgLabel.Position = UDim2.fromOffset(pos.X, pos.Y)
            imgLabel.Image = assetId
            imgLabel.ImageTransparency = trans

            if isDots then
                imgLabel.Size = UDim2.fromOffset(10, 10)
                imgLabel.Rotation = 0
            elseif isDotsOut then
                imgLabel.Size = UDim2.fromOffset(14, 14)
                imgLabel.Rotation = 0
            elseif isStripes then
                imgLabel.Size = UDim2.fromOffset(24, 8)
                -- orient indicator notches toward center
                local dirX = mouseLoc.X - pos.X
                local dirY = mouseLoc.Y - pos.Y
                local centerAngleDeg = math.deg(math.atan2(dirY, dirX))
                imgLabel.Rotation = centerAngleDeg
            end

            -- apply directional color gradients across perimeter
            local elemColor = c1
            if colorMode == "2 colors" then
                local tVal = (math.sin(tick() * shiftSpeed) + 1) / 2
                elemColor = c1:Lerp(c2, tVal)
            elseif colorMode == "Shift" then
                -- animate gradient waves across screen x axis
                local screenX = (mouseLoc + Vector2.new(math.cos(angle) * r, math.sin(angle) * r)).X
                local normX = math.clamp(screenX / (workspace.CurrentCamera.ViewportSize.X or 1920), 0, 1)
                local tVal = (math.sin((normX + animPhase) * math.pi * 2) + 1) * 0.5
                elemColor = c1:Lerp(c2, tVal)
            elseif colorMode == "Gradient" or colorMode == "Gradient 2" then
                local tVal = (math.sin((angle / (math.pi * 2) + animPhase) * math.pi * 2) + 1) * 0.5
                elemColor = c1:Lerp(c2, tVal)
            elseif colorMode == "Rainbow" then
                local hue = ((angle / (math.pi * 2)) + animPhase) % 1.0
                elemColor = Color3.fromHSV(hue, 1, 1)
            elseif colorMode == "Rainbow 2" then
                -- align hue spectrum with screen space
                local screenX = (mouseLoc + Vector2.new(math.cos(angle) * r, math.sin(angle) * r)).X
                local normX = math.clamp(screenX / (workspace.CurrentCamera.ViewportSize.X or 1920), 0, 1)
                local hue = (normX + animPhase) % 1.0
                elemColor = Color3.fromHSV(hue, 1, 1)
            end
            imgLabel.ImageColor3 = elemColor
            imgLabel.Visible = true
        end

        -- avoid rendering inactive ring styles
        for _, child in ipairs(fovElementsContainer:GetChildren()) do
            local idx = tonumber(child.Name:match("^Elem_(%d+)$"))
            if idx and idx > count then
                child.Visible = false
            end
        end
    else
        if stroke then stroke.Enabled = true end
        if fovElementsContainer then fovElementsContainer.Visible = false end

        local white = Color3.new(1, 1, 1)

        -- update vector drawing circle attributes
        if colorMode == "Normal" then
            local oldGrad = fovCircleGuiFrame:FindFirstChildOfClass("UIGradient")
            if oldGrad then oldGrad:Destroy() end
            fovCircleGuiFrame.BackgroundColor3 = c1
            if stroke then
                local oldStrokeGrad = stroke:FindFirstChildOfClass("UIGradient")
                if oldStrokeGrad then oldStrokeGrad:Destroy() end
                stroke.Color = c1
            end
        elseif colorMode == "2 colors" then
            local oldGrad = fovCircleGuiFrame:FindFirstChildOfClass("UIGradient")
            if oldGrad then oldGrad:Destroy() end
            local shiftSpeed = state and state.colorShiftSpeed or 3
            local tVal = (math.sin(tick() * shiftSpeed) + 1) / 2
            local cycledCol = c1:Lerp(c2, tVal)
            fovCircleGuiFrame.BackgroundColor3 = cycledCol
            if stroke then
                local oldStrokeGrad = stroke:FindFirstChildOfClass("UIGradient")
                if oldStrokeGrad then oldStrokeGrad:Destroy() end
                stroke.Color = cycledCol
            end
        elseif colorMode == "Shift" then
            fovCircleGuiFrame.BackgroundColor3 = white
            if stroke then stroke.Color = white end

            local shiftSpeed = state and state.colorShiftSpeed or 3
            local phase = (tick() * (shiftSpeed * 0.15)) % 1.0
            -- pulse color cycle smoothly over time
            local function shiftCol(off)
                local tVal = (math.sin((phase + off) * math.pi * 2) + 1) * 0.5
                return c1:Lerp(c2, tVal)
            end
            local shiftSeq = ColorSequence.new({
                ColorSequenceKeypoint.new(0,    shiftCol(0)),
                ColorSequenceKeypoint.new(0.25, shiftCol(0.25)),
                ColorSequenceKeypoint.new(0.5,  shiftCol(0.5)),
                ColorSequenceKeypoint.new(0.75, shiftCol(0.75)),
                ColorSequenceKeypoint.new(1,    shiftCol(1))
            })

            local frameGrad = fovCircleGuiFrame:FindFirstChildOfClass("UIGradient")
            if not frameGrad then
                frameGrad = Instance.new("UIGradient")
                frameGrad.Parent = fovCircleGuiFrame
            end
            frameGrad.Color = shiftSeq
            frameGrad.Rotation = 0

            if stroke then
                local strokeGrad = stroke:FindFirstChildOfClass("UIGradient")
                if not strokeGrad then
                    strokeGrad = Instance.new("UIGradient")
                    strokeGrad.Parent = stroke
                end
                strokeGrad.Color = shiftSeq
                strokeGrad.Rotation = 0
            end
        elseif colorMode == "Gradient" then
            fovCircleGuiFrame.BackgroundColor3 = white
            if stroke then stroke.Color = white end

            local speed = silentAimConfig.spinSpeed or 60
            _fovGradientAngle = (_fovGradientAngle + speed * 0.016) % 360

            local frameGrad = fovCircleGuiFrame:FindFirstChildOfClass("UIGradient")
            if not frameGrad then
                frameGrad = Instance.new("UIGradient")
                frameGrad.Parent = fovCircleGuiFrame
            end
            frameGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, c1),
                ColorSequenceKeypoint.new(0.5, c2),
                ColorSequenceKeypoint.new(1, c1)
            })
            frameGrad.Rotation = _fovGradientAngle

            if stroke then
                local strokeGrad = stroke:FindFirstChildOfClass("UIGradient")
                if not strokeGrad then
                    strokeGrad = Instance.new("UIGradient")
                    strokeGrad.Parent = stroke
                end
                strokeGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, c1),
                    ColorSequenceKeypoint.new(0.5, c2),
                    ColorSequenceKeypoint.new(1, c1)
                })
                strokeGrad.Rotation = _fovGradientAngle
            end
        elseif colorMode == "Gradient 2" then
            fovCircleGuiFrame.BackgroundColor3 = white
            if stroke then stroke.Color = white end

            local shiftSpeed = state and state.colorShiftSpeed or 3
            local phase = (tick() * (shiftSpeed * 0.15)) % 1.0
            local function getSmoothCol(off)
                local tVal = (math.sin((phase + off) * math.pi * 2) + 1) * 0.5
                return c1:Lerp(c2, tVal)
            end
            local animSeq = ColorSequence.new({
                ColorSequenceKeypoint.new(0,    getSmoothCol(0)),
                ColorSequenceKeypoint.new(0.25, getSmoothCol(0.25)),
                ColorSequenceKeypoint.new(0.5,  getSmoothCol(0.5)),
                ColorSequenceKeypoint.new(0.75, getSmoothCol(0.75)),
                ColorSequenceKeypoint.new(1,    getSmoothCol(1))
            })

            local frameGrad = fovCircleGuiFrame:FindFirstChildOfClass("UIGradient")
            if not frameGrad then
                frameGrad = Instance.new("UIGradient")
                frameGrad.Parent = fovCircleGuiFrame
            end
            frameGrad.Color = animSeq
            frameGrad.Rotation = 0

            if stroke then
                local strokeGrad = stroke:FindFirstChildOfClass("UIGradient")
                if not strokeGrad then
                    strokeGrad = Instance.new("UIGradient")
                    strokeGrad.Parent = stroke
                end
                strokeGrad.Color = animSeq
                strokeGrad.Rotation = 0
            end
        elseif colorMode == "Rainbow" then
            fovCircleGuiFrame.BackgroundColor3 = white
            if stroke then stroke.Color = white end

            local speed = silentAimConfig.spinSpeed or 60
            _fovGradientAngle = (_fovGradientAngle + speed * 0.016) % 360

            local rainbowSeq = ColorSequence.new({
                ColorSequenceKeypoint.new(0,    Color3.fromHSV(0.00, 1, 1)),
                ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17, 1, 1)),
                ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
                ColorSequenceKeypoint.new(0.50, Color3.fromHSV(0.50, 1, 1)),
                ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67, 1, 1)),
                ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
                ColorSequenceKeypoint.new(1.00, Color3.fromHSV(1.00, 1, 1))
            })

            local frameGrad = fovCircleGuiFrame:FindFirstChildOfClass("UIGradient")
            if not frameGrad then
                frameGrad = Instance.new("UIGradient")
                frameGrad.Parent = fovCircleGuiFrame
            end
            frameGrad.Color = rainbowSeq
            frameGrad.Rotation = _fovGradientAngle

            if stroke then
                local strokeGrad = stroke:FindFirstChildOfClass("UIGradient")
                if not strokeGrad then
                    strokeGrad = Instance.new("UIGradient")
                    strokeGrad.Parent = stroke
                end
                strokeGrad.Color = rainbowSeq
                strokeGrad.Rotation = _fovGradientAngle
            end
        elseif colorMode == "Rainbow 2" then
            fovCircleGuiFrame.BackgroundColor3 = white
            if stroke then stroke.Color = white end

            local shiftSpeed = state and state.colorShiftSpeed or 3
            local phase = (tick() * (shiftSpeed * 0.15)) % 1.0

            local rainbowSeq2 = ColorSequence.new({
                ColorSequenceKeypoint.new(0,    Color3.fromHSV((0.00 + phase) % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.17, Color3.fromHSV((0.17 + phase) % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.33, Color3.fromHSV((0.33 + phase) % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.50, Color3.fromHSV((0.50 + phase) % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.67, Color3.fromHSV((0.67 + phase) % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.83, Color3.fromHSV((0.83 + phase) % 1, 1, 1)),
                ColorSequenceKeypoint.new(1.00, Color3.fromHSV((1.00 + phase) % 1, 1, 1))
            })

            local frameGrad = fovCircleGuiFrame:FindFirstChildOfClass("UIGradient")
            if not frameGrad then
                frameGrad = Instance.new("UIGradient")
                frameGrad.Parent = fovCircleGuiFrame
            end
            frameGrad.Color = rainbowSeq2
            frameGrad.Rotation = 0

            if stroke then
                local strokeGrad = stroke:FindFirstChildOfClass("UIGradient")
                if not strokeGrad then
                    strokeGrad = Instance.new("UIGradient")
                    strokeGrad.Parent = stroke
                end
                strokeGrad.Color = rainbowSeq2
                strokeGrad.Rotation = 0
            end
        end
    end

    fovCircleGuiFrame.Visible = true
end

-- block targeting through solid obstructions
local function isPartVisible(part, character)
    if not part then return false end
    local origin = CurrentCamera.CFrame.Position
    local direction = part.Position - origin
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude

    local ignoreList = { CurrentCamera }
    if LocalPlayer.Character then
        table.insert(ignoreList, LocalPlayer.Character)
    end
    params.FilterDescendantsInstances = ignoreList

    local result = Workspace:Raycast(origin, direction, params)
    if not result then return true end
    return result.Instance:IsDescendantOf(character)
end


local function getAutoAimTarget()
    if state and state.unloaded then return nil, nil end
    local targetPlayer = nil
    local targetPart = nil

    local murderer = getClosestMurderer()
    if murderer then
        targetPlayer = murderer
    end

    if not targetPlayer then
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and isPlayerAlive(p) then
                targetPlayer = p
                break
            end
        end
    end

    if targetPlayer and targetPlayer.Character then
        local char = targetPlayer.Character
        if silentAimConfig.targetPart == "Random" then
            local partsList = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Torso"}
            local available = {}
            for _, pName in ipairs(partsList) do
                local pt = char:FindFirstChild(pName)
                if pt and pt:IsA("BasePart") then
                    table.insert(available, pt)
                end
            end
            if #available > 0 then
                targetPart = available[math.random(1, #available)]
            end
        elseif silentAimConfig.targetPart and silentAimConfig.targetPart ~= "" then
            targetPart = char:FindFirstChild(silentAimConfig.targetPart)
        end

        if not targetPart then
            targetPart = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso")
        end
    end

    return targetPlayer, targetPart
end

local function calculateAimPosition(rawPos, part, predH, predV)
    if not part then return rawPos end

    local vel = Vector3.zero
    pcall(function()
        vel = part.AssemblyLinearVelocity or part.Velocity or Vector3.zero
    end)

    local hFactor = tonumber(predH) or 0
    local vFactor = tonumber(predV) or 0
    if hFactor < 0 then hFactor = 0 end
    if vFactor < 0 then vFactor = 0 end

    local offsetX = vel.X * hFactor
    local offsetZ = vel.Z * hFactor
    local offsetY = 0

    if vFactor > 0.001 then
        local char = part.Parent
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        local isGrounded = false
        if hum then
            local floorMat = hum.FloorMaterial
            if floorMat and floorMat ~= Enum.Material.Air then
                isGrounded = true
            end
        end

        if not isGrounded and math.abs(vel.Y) > 1 then
            local grav = 196.2
            pcall(function()
                if Workspace.Gravity and Workspace.Gravity > 0 then
                    grav = Workspace.Gravity
                end
            end)
            local ballistic = (vel.Y * vFactor) - (0.5 * grav * (vFactor * vFactor))
            offsetY = math.clamp(ballistic, -15, 15)
        end
    end

    return rawPos + Vector3.new(offsetX, offsetY, offsetZ)
end

local function getSilentAimPred()
    local predH = 0.2
    local predV = 0.2
    if silentAimConfig then
        if silentAimConfig.horizontalPrediction ~= nil then
            predH = tonumber(silentAimConfig.horizontalPrediction) or 0
        elseif silentAimConfig.predictionFactor ~= nil then
            predH = tonumber(silentAimConfig.predictionFactor) or 0
        end
        if silentAimConfig.verticalPrediction ~= nil then
            predV = tonumber(silentAimConfig.verticalPrediction) or 0
        else
            predV = 0
        end
    end
    return predH, predV
end

local function getCamlockPred()
    local predH = 0.2
    local predV = 0.2
    if camlockSettings then
        if camlockSettings.horizontalPrediction ~= nil then
            predH = tonumber(camlockSettings.horizontalPrediction) or 0
        elseif camlockSettings.predictionFactor ~= nil then
            predH = tonumber(camlockSettings.predictionFactor) or 0
        end
        if camlockSettings.verticalPrediction ~= nil then
            predV = tonumber(camlockSettings.verticalPrediction) or 0
        else
            predV = 0
        end
    end
    return predH, predV
end

local function getSilentAimTarget()
    if not silentAimConfig.enabled or (state and state.unloaded) then return nil, nil, nil end
    local fov = silentAimConfig.fovRadius or 125
    local bestScreen = fov
    local bestWorld = math.huge
    local targetPlayer, targetPart, targetPos = nil, nil, nil
    local mouseLoc = UserInputService:GetMouseLocation()
    local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

    local hasGun = hasTool(LocalPlayer, "Gun")
    local murdererSet, anyMurderer = {}, false
    if hasGun then
        for _, m in ipairs(getMurderers()) do
            murdererSet[m] = true
            anyMurderer = true
        end
    end
    local byDistance = hasGun and anyMurderer

    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and (not silentAimConfig.aliveCheck or isPlayerAlive(p)) then
            local isValidTarget = true
            if byDistance then isValidTarget = murdererSet[p] == true end

            if isValidTarget and p.Character then
                local char = p.Character
                local part = nil
                if silentAimConfig.wallbang then
                    part = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("LowerTorso") or char:FindFirstChild("HumanoidRootPart")
                elseif silentAimConfig.targetPart == "Random" then
                    local available = {}
                    for _, pName in ipairs({"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Torso"}) do
                        local pt = char:FindFirstChild(pName)
                        if pt and pt:IsA("BasePart") then available[#available + 1] = pt end
                    end
                    if #available > 0 then part = available[math.random(1, #available)] end
                elseif silentAimConfig.targetPart and silentAimConfig.targetPart ~= "" then
                    part = char:FindFirstChild(silentAimConfig.targetPart)
                end
                if not part then
                    part = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                end

                if part and (silentAimConfig.wallbang or not silentAimConfig.wallCheck or isPartVisible(part, char)) then
                    local worldDist = myHrp and (part.Position - myHrp.Position).Magnitude or 0

                    if silentAimConfig.wallbang then
                        local better = byDistance and (worldDist < bestWorld) or (not byDistance and not targetPlayer)
                        if better then
                            bestWorld = worldDist
                            targetPlayer, targetPart, targetPos = p, part, part.Position
                        end
                    else
                        local screenPos, onScreen = CurrentCamera:WorldToViewportPoint(part.Position)
                        if onScreen and screenPos.Z > 0 then
                            local dist = (Vector2.new(screenPos.X, screenPos.Y) - mouseLoc).Magnitude
                            if dist <= fov then
                                local better
                                if byDistance then better = worldDist < bestWorld else better = dist <= bestScreen end
                                if better then
                                    local predH, predV = getSilentAimPred()
                                    bestScreen, bestWorld = dist, worldDist
                                    targetPlayer, targetPart = p, part
                                    targetPos = calculateAimPosition(part.Position, part, predH, predV)
                                end
                            end
                        end
                    end
                end
            end
        end
    end
    return targetPlayer, targetPart, targetPos
end

local function getOwnGunHandle()
    local charModel = Workspace:FindFirstChild(LocalPlayer.Name) or LocalPlayer.Character
    if charModel then
        local gun = charModel:FindFirstChild("Gun") or charModel:FindFirstChild("Revolver")
        if gun then
            local handle = gun:FindFirstChild("Handle")
            if handle then return handle end
        end
    end
    local char = LocalPlayer.Character
    if char then
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") and isGunTool(item) then
                local h = item:FindFirstChild("Handle")
                if h then return h end
            end
        end
    end
    return nil
end

trackConnection(RunService.RenderStepped:Connect(function()
    if silentAimConfig.enabled then
        pcall(updateFOVCircle)
    else
        if fovCircleDrawing and fovCircleDrawing.Visible then pcall(function() fovCircleDrawing.Visible = false end) end
        if fovCircleGuiFrame and fovCircleGuiFrame.Visible then fovCircleGuiFrame.Visible = false end
    end
end))

-- redirect gun fire remotes directly to target
local rawNamecall = nil
if hookmetamethod then
    rawNamecall = hookmetamethod(game, "__namecall", newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if not checkcaller() and (method == "FireServer" or method == "fireServer") then
            local sName = self and self.Name
            -- preserve standard gameplay actions for non-gun tools
            if sName == "Shoot" and not (state and state.unloaded) then
                -- snap aim to target without fov limits
                if state and state.autoAimEnabled then
                    local target, tPart = getAutoAimTarget()
                    if target and isPlayerAlive(target) and tPart then
                        local args = { ... }
                        local targetChar = target.Character
                        local isWallbang = (state and state.autoAimWallbang) or (silentAimConfig and silentAimConfig.wallbang)

                        local shootPart = tPart
                        if isWallbang and targetChar then
                            shootPart = targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("LowerTorso") or tPart
                        end

                        local rawPos = shootPart.Position
                        local predH, predV = getSilentAimPred()
                        local targetPos = calculateAimPosition(rawPos, shootPart, predH, predV)

                        local originPos = nil
                        if isWallbang and targetChar then
                            local head = targetChar:FindFirstChild("Head")
                            originPos = head and (head.Position + (targetPos - rawPos)) or (targetPos + Vector3.new(0, 1.5, 0))
                        else
                            local originCF = args[1]
                            local handle = getOwnGunHandle()
                            local char = LocalPlayer.Character
                            local myHrp = char and char:FindFirstChild("HumanoidRootPart")
                            originPos = (typeof(originCF) == "CFrame" and originCF.Position)
                                or (handle and (handle.CFrame * CFrame.new(0, 0.5, -1)).Position)
                                or (myHrp and myHrp.Position)
                                or targetPos
                        end

                        args[1] = CFrame.new(originPos, targetPos)
                        args[2] = CFrame.new(targetPos)

                        return rawNamecall(self, unpack(args))
                    end
                -- constrain trajectory assist to fov radius
                elseif silentAimConfig and silentAimConfig.enabled then
                    local target, tPart, targetPos = getSilentAimTarget()
                    if target and isPlayerAlive(target) and targetPos then
                        local hitChance = silentAimConfig.hitChance or 100
                        if hitChance >= 100 or math.random(1, 100) <= hitChance then
                            local args = { ... }
                            local originPos = nil
                            local isWallbang = silentAimConfig.wallbang
                            local targetChar = target.Character
                            if isWallbang and targetChar then
                                local head = targetChar:FindFirstChild("Head")
                                originPos = head and (head.Position + (targetPos - rawPos)) or (targetPos + Vector3.new(0, 1.5, 0))
                            else
                                local originCF = args[1]
                                local handle = getOwnGunHandle()
                                local char = LocalPlayer.Character
                                local myHrp = char and char:FindFirstChild("HumanoidRootPart")
                                originPos = (typeof(originCF) == "CFrame" and originCF.Position)
                                    or (handle and (handle.CFrame * CFrame.new(0, 0.5, -1)).Position)
                                    or (myHrp and myHrp.Position)
                                    or targetPos
                            end

                            args[1] = CFrame.new(originPos, targetPos)
                            args[2] = CFrame.new(targetPos)

                            return rawNamecall(self, unpack(args))
                        end
                    end
                end
            end
        end
        return rawNamecall(self, ...)
    end))
end

-- lock camera orient toward target head

local function getCamlockTarget()
    local shortest = math.huge
    local result = nil
    local mouseLoc = UserInputService:GetMouseLocation()
    for _, p in pairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and isPlayerAlive(p) then
            local char = p.Character
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            if char and hum and hum.Health > 0 then
                local part = char:FindFirstChild(camlockSettings.bodyPartSelected) or char:FindFirstChild("HumanoidRootPart")
                if part then
                    local sp, onScreen = CurrentCamera:WorldToViewportPoint(part.Position)
                    if onScreen then
                        local dist = (Vector2.new(sp.X, sp.Y) - mouseLoc).Magnitude
                        if dist < shortest then
                            shortest = dist
                            result = p
                        end
                    end
                end
            end
        end
    end
    return result
end

local function updateCamlock()
    if not camlockSettings.aimLockEnabled then return end
    
    local tp = camlockSettings.targetPlayer
    local char = tp and tp.Character
    local hum  = char and char:FindFirstChildOfClass("Humanoid")

    -- prevent locking onto despawned characters
    if not tp or not isPlayerAlive(tp) or not char or not hum or hum.Health <= 0 then
        camlockSettings.targetPlayer = getCamlockTarget()
        tp = camlockSettings.targetPlayer
        char = tp and tp.Character
        hum = char and char:FindFirstChildOfClass("Humanoid")
    end

    if tp and char and hum and hum.Health > 0 then
        local part = char:FindFirstChild(camlockSettings.bodyPartSelected) or char:FindFirstChild("HumanoidRootPart")
        if part then
            local rawPos = part.Position
            local predH, predV = getCamlockPred()
            local predicted = calculateAimPosition(rawPos, part, predH, predV)
            local goalCF    = CFrame.new(CurrentCamera.CFrame.Position, predicted)
            local alpha     = math.clamp(1 - camlockSettings.smoothingFactor, 0.05, 1)
            CurrentCamera.CFrame = CurrentCamera.CFrame:Lerp(goalCF, alpha)
        end
    end
end

local function toggleCamlockConnection(enabled)
    if camlockConn then
        pcall(function() camlockConn:Disconnect() end)
        camlockConn = nil
    end
    if enabled and not state.unloaded then
        camlockConn = RunService.RenderStepped:Connect(updateCamlock)
    end
end

-- locate active play area and network endpoints 
local _cachedMap = nil

local function _isMapChild(child)
    if not child or not (child:IsA("Model") or child:IsA("Folder")) then return false end
    local name = child.Name
    if name == "Lobby" or name == "Terrain" or name == "Camera" or name == LocalPlayer.Name or Players:FindFirstChild(name) then
        return false
    end
    if name == "Workplace" or name == "Normal" or name == "Map" or name == "CurrentMap" then
        return true
    end
    if child:FindFirstChild("CoinContainer") or child:FindFirstChild("CoinArea") or child:FindFirstChild("Coins")
        or child:FindFirstChild("Spawns") or child:FindFirstChild("GunDrop")
        or child:FindFirstChild("Knife") or child:FindFirstChild("Gun")
        or child:FindFirstChild("Geometry") or child:FindFirstChild("Interactive") then
        return true
    end
    return false
end

for _, child in ipairs(Workspace:GetChildren()) do
    if _isMapChild(child) then _cachedMap = child break end
end

trackConnection(Workspace.ChildAdded:Connect(function(child)
    if _isMapChild(child) then _cachedMap = child end
end))
trackConnection(Workspace.ChildRemoved:Connect(function(child)
    if _cachedMap == child then _cachedMap = nil end
end))

local function getActiveMap()
    if _cachedMap and _cachedMap.Parent == Workspace then
        return _cachedMap
    end
    for _, child in ipairs(Workspace:GetChildren()) do
        if _isMapChild(child) then _cachedMap = child; return child end
    end
    return nil
end

-- mm2 stores knife hit and throw remotes under Knife.Events; update path if game moves them
local function getKnifeEvents()
    local plrModel = Workspace:FindFirstChild(LocalPlayer.Name)
    if plrModel then
        local knife = plrModel:FindFirstChild("Knife")
        if knife and knife:FindFirstChild("Events") then
            return knife.Events
        end
    end
    local map = getActiveMap()
    if map then
        local knife = map:FindFirstChild("Knife")
        if knife then
            local ev = knife:FindFirstChild("Events")
            if ev then return ev end
        end
    end
    return nil
end

-- mm2 gun tools fire bullet raycasts via Shoot remote event; update if game renames gun remotes
local function getGunShootEvent()
    local char = LocalPlayer.Character or Workspace:FindFirstChild(LocalPlayer.Name)
    if char then
        local gun = char:FindFirstChild("Gun") or char:FindFirstChild("Revolver")
        if gun and gun:FindFirstChild("Shoot") then
            return gun.Shoot
        end
        for _, item in ipairs(char:GetChildren()) do
            if item:IsA("Tool") and isGunTool(item) then
                local shoot = item:FindFirstChild("Shoot")
                if shoot and shoot:IsA("RemoteEvent") then return shoot end
            end
        end
    end
    local bp = LocalPlayer:FindFirstChild("Backpack")
    if bp then
        local gun = bp:FindFirstChild("Gun") or bp:FindFirstChild("Revolver")
        if gun and gun:FindFirstChild("Shoot") then
            return gun.Shoot
        end
        for _, item in ipairs(bp:GetChildren()) do
            if item:IsA("Tool") and isGunTool(item) then
                local shoot = item:FindFirstChild("Shoot")
                if shoot and shoot:IsA("RemoteEvent") then return shoot end
            end
        end
    end
    local map = getActiveMap()
    if map then
        local gun = map:FindFirstChild("Gun") or map:FindFirstChild("Revolver")
        if gun then
            local shoot = gun:FindFirstChild("Shoot")
            if shoot and shoot:IsA("RemoteEvent") then return shoot end
        end
    end
    if getnilinstances then
        local success, result = pcall(function()
            for _, obj in ipairs(getnilinstances()) do
                if obj:IsA("RemoteEvent") and obj.Name == "Shoot" then
                    return obj
                end
            end
            return nil
        end)
        if success and result then return result end
    end
    return nil
end

local cachedGunDrop = nil
local attemptTakeGun = nil

local function extractGunPart(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then return obj end
    if obj:IsA("Model") then
        if obj.PrimaryPart then return obj.PrimaryPart end
        return obj:FindFirstChildWhichIsA("BasePart", true)
    end
    return nil
end

local function getDroppedGun()
    if cachedGunDrop and cachedGunDrop.Parent and cachedGunDrop.Name == "GunDrop" then
        return cachedGunDrop
    end
    cachedGunDrop = nil

    local direct = Workspace:FindFirstChild("GunDrop")
    if direct then
        cachedGunDrop = direct
        return direct
    end

    local map = getActiveMap()
    if map then
        local drop = map:FindFirstChild("GunDrop")
        if drop then
            cachedGunDrop = drop
            return drop
        end
    end

    for _, child in ipairs(Workspace:GetChildren()) do
        if child.Name ~= "Lobby" then
            local drop = child:FindFirstChild("GunDrop")
            if drop then
                cachedGunDrop = drop
                return drop
            end
        end
    end
    return nil
end

local function getDroppedGunPart()
    local drop = getDroppedGun()
    if drop then
        return extractGunPart(drop)
    end
    return nil
end

trackConnection(Workspace.DescendantAdded:Connect(function(child)
    if child.Name == "GunDrop" then
        cachedGunDrop = child
        if state.autoTakeGun and attemptTakeGun then
            task.spawn(function()
                task.wait(0.01)
                local part = extractGunPart(child)
                if part then
                    attemptTakeGun(part)
                end
            end)
        end
    end
end))

trackConnection(Workspace.DescendantRemoving:Connect(function(child)
    if child == cachedGunDrop then
        cachedGunDrop = nil
    end
end))

local function isInLobby()
    local ok, roundUI = pcall(function()
        return isRoundActiveUI and isRoundActiveUI()
    end)
    if ok and roundUI then return false end
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return true end
    local lobby = Workspace:FindFirstChild("Lobby")
    local lobbySpawns = lobby and lobby:FindFirstChild("Spawns")
    if lobbySpawns then
        for _, s in ipairs(lobbySpawns:GetChildren()) do
            if s:IsA("BasePart") then
                local dist = (hrp.Position - s.Position).Magnitude
                if dist < 150 then
                    return true
                end
            end
        end
    end
    return false
end

local function isMurdererAlive(plr)
    if not plr or not isPlayerAlive(plr) then return false end
    if state.deadPlayers[plr] == true then return false end
    return hasTool(plr, "Knife")
end

-- deliver match statistics to remote endpoint 
local function parseInterval(str)
    if not str or str == "" then return 300 end
    local num, unit = str:match("(%d+)%s*([smh]?)")
    if not num then return 300 end
    local n = tonumber(num)
    if unit == "s" then return n end
    if unit == "h" then return n * 3600 end
    return n * 60
end

local function getCurrentCoinsText()
    local ok, val = pcall(function()
        return LocalPlayer.PlayerGui.CrossPlatform.Shop.Medium.Title.Coins.Container.Amount.Text
    end)
    if ok and val then return tostring(val) end
    return "0"
end

local function getCoinsPerHourNum()
    local elapsedHrs = (tick() - state.startTime) / 3600
    if elapsedHrs <= 0 then return 0 end
    local farmed = state.totalCoinsFarmed or 0
    return math.floor(farmed / elapsedHrs)
end

local function sendDiscordWebhook(isTest)
    if not state.webhookUrl or state.webhookUrl == "" then return end
    if not isTest and not state.webhookEnabled then return end
    
    local elapsedSec = math.floor(tick() - state.startTime)
    local hrs = math.floor(elapsedSec / 3600)
    local mins = math.floor((elapsedSec % 3600) / 60)
    local secs = elapsedSec % 60
    local timeStr = string.format("%02d:%02d:%02d", hrs, mins, secs)
    
    local lines = {
        "```yaml",
        isTest and "MM2 MD Status (Test)" or "MM2 MD Status",
        "",
        string.format("Username     : %s", LocalPlayer.Name),
        string.format("Time passed  : %s", timeStr),
        string.format("Rounds passed: %d", state.roundsPassed),
        string.format("Status       : %s", isTest and "Test notification" or (state.currentTaskStatus or "Idle"))
    }

    if state.webhookCurrentCoins then
        table.insert(lines, string.format("Current coins: %s", getCurrentCoinsText()))
    end
    if state.webhookCoinsPerHour then
        table.insert(lines, string.format("Coins / hour : %d", getCoinsPerHourNum()))
    end

    table.insert(lines, "```")
    local reportText = table.concat(lines, "\n")
    
    local payload = HttpService:JSONEncode({
        content = reportText,
        username = "MorningDrift Jr."
    })
    
    local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    if req then
        pcall(function()
            req({
                Url = state.webhookUrl,
                Method = "POST",
                Headers = {["Content-Type"] = "application/json"},
                Body = payload
            })
        end)
    else
        pcall(function()
            HttpService:PostAsync(state.webhookUrl, payload, Enum.HttpContentType.ApplicationJson)
        end)
    end
end

-- fetch public servers list and teleport to another instance
local function serverHop()
    log("Server hopping...")
    local placeId = game.PlaceId
    local servers = {}
    local req = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
    local url = "https://games.roblox.com/v1/games/" .. tostring(placeId) .. "/servers/Public?sortOrder=Asc&limit=100"
    
    if req then
        local res = req({Url = url, Method = "GET"})
        if res and res.Body then
            local data = HttpService:JSONDecode(res.Body)
            if data and data.data then
                for _, s in ipairs(data.data) do
                    if s.id ~= game.JobId and s.playing < s.maxPlayers then
                        table.insert(servers, s.id)
                    end
                end
            end
        end
    end
    
    if #servers > 0 then
        TeleportService:TeleportToPlaceInstance(placeId, servers[math.random(1, #servers)], LocalPlayer)
    else
        TeleportService:Teleport(placeId, LocalPlayer)
    end
end

-- hover and pass through collision geometry 
local function setNoclip(enabled)
    if noclipConn then
        pcall(function() noclipConn:Disconnect() end)
        noclipConn = nil
    end
    if enabled then
        if not (state.autofarmEnabled or state.flightEnabled or state.isFlinging or state.autoTakeGun) then
            return
        end
        noclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum and hum.Health > 0 then
                    for _, p in ipairs(char:GetDescendants()) do
                        if p:IsA("BasePart") and p.Name ~= "OrbitingOrb" then
                            p.CanCollide = false
                        end
                    end
                end
            end
        end)
    else
        local char = LocalPlayer.Character
        if char then
            restoreCharacterCollision(char)
            local hum = char:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                pcall(function()
                    hum:ChangeState(Enum.HumanoidStateType.GettingUp)
                    hum:ChangeState(Enum.HumanoidStateType.Running)
                end)
            end
        end
    end
end

local function startFloating()
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Physics) end
    if hrp then
        local bv = hrp:FindFirstChild("SafePlate")
        if not bv then
            bv = Instance.new("BodyVelocity")
            bv.Name     = "SafePlate"
            bv.MaxForce = Vector3.new(1e9, 1e9, 1e9)
            bv.Velocity = Vector3.zero
            bv.Parent   = hrp
        end
    end
    setNoclip(true)
end

-- catch character above kill plane to prevent deaths 
local function getVoidY()
    -- roblox destroys parts below FallenPartsDestroyHeight; defaults to -500 if unset
    local fallenY = Workspace.FallenPartsDestroyHeight
    if not fallenY or fallenY > -50 then
        fallenY = -500
    end
    return fallenY
end

local function getAntiVoidPlateY()
    -- keep platform 150 studs above void limit (minimum -250) to catch flings early
    return math.max(getVoidY() + 150, -250)
end

local function getMinAllowedY()
    return getAntiVoidPlateY() + 50
end

local function makeAntiVoidPlate()
    local plate = Workspace:FindFirstChild("AntiVoidPlate")
    if not plate then
        plate = Instance.new("Part")
        plate.Name = "AntiVoidPlate"
        -- 100k studs wide to cover entire map boundary during extreme physics flings
        plate.Size = Vector3.new(100000, 100, 100000)
        plate.Anchored = true
        plate.CanCollide = true
        plate.Transparency = 0.6
        plate.Color = Color3.fromRGB(0, 170, 255)
        plate.Material = Enum.Material.ForceField
        plate.Parent = Workspace
    end

    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local posX = hrp and hrp.Position.X or 0
    local posZ = hrp and hrp.Position.Z or 0

    plate.Position = Vector3.new(posX, getAntiVoidPlateY(), posZ)
    return plate
end

trackThread(task.spawn(function()
    while not state.unloaded do
        if state.autofarmEnabled or state.flightEnabled or state.isFlinging then
            pcall(function()
                local plate = Workspace:FindFirstChild("AntiVoidPlate")
                if not plate then plate = makeAntiVoidPlate() end
                local char = LocalPlayer.Character
                local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                if hrp and plate then
                    plate.Position = Vector3.new(hrp.Position.X, getAntiVoidPlateY(), hrp.Position.Z)
                end
            end)
            task.wait(0.05)
        else
            task.wait(0.5)
        end
    end
end))

-- reset forces and recover character physics 
local function stopTween()
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if hrp then
        for _, obj in ipairs(hrp:GetChildren()) do
            if obj.Name == "SafePlate"
                or obj:IsA("BodyVelocity") or obj:IsA("BodyPosition")
                or obj.Name == "FarmOrientation" then
                pcall(function() obj:Destroy() end)
            end
        end
        pcall(function()
            hrp.Anchored = false
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)
    end
    if hum then
        pcall(function()
            hum.PlatformStand = false
            hum.AutoRotate = true
            hum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end)
    end
    setNoclip(false)
end

local SAFEZONE_POS = Vector3.new(390.562195, -41.5624847, 110.499878)
local safeZoneAnchorToken = 0

local function tpToSafeSpawn(anchor)
    if state then
        state.tweenRoundTeleported = false
    end
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    hrp.CFrame = CFrame.new(SAFEZONE_POS)
    pcall(function()
        hrp.AssemblyLinearVelocity  = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end)
    safeZoneAnchorToken = safeZoneAnchorToken + 1
    local currentToken = safeZoneAnchorToken
    if anchor ~= false then
        pcall(function() hrp.Anchored = false end)
        task.delay(0.2, function()
            if safeZoneAnchorToken ~= currentToken then return end
            local c = LocalPlayer.Character
            local root = c and c:FindFirstChild("HumanoidRootPart")
            if root and (root.Position - SAFEZONE_POS).Magnitude < 100 then
                pcall(function() root.Anchored = true end)
            end
        end)
    else
        pcall(function() hrp.Anchored = false end)
    end
end

-- push target away with extreme momentum 
local lastFlingTick = tick()
local function flingTarget(targetPlr, isManual, customDuration)
    if (tick() - state.startTime) < 2.0 then
        log("Fling blocked: script initializing")
        return
    end
    if not isManual and (tick() - lastFlingTick < 6) then return end
    if not targetPlr or not isPlayerAlive(targetPlr) then return end
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local targetChar = targetPlr.Character
    local targetHrp  = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
    if not targetHrp then return end

    makeAntiVoidPlate()
    local minAllowedY = getMinAllowedY()

    local hum = char:FindFirstChildOfClass("Humanoid")
    if hum then hum:ChangeState(Enum.HumanoidStateType.Physics) end
    
    state.isFlinging = true
    pcall(function() hrp.Anchored = false end)
    setNoclip(true)

    local camera = Workspace.CurrentCamera
    local originalSubject = camera and camera.CameraSubject
    local startTime = tick()
    local flingMaxDuration = customDuration or 4.0

    pcall(function()
        while (isManual or state.autofarmEnabled) and isPlayerAlive(targetPlr) and isPlayerAlive(LocalPlayer)
              and (tick() - startTime < flingMaxDuration) and not state.unloaded do

            -- If player acquired a gun while flinging during autofarm, abort fling to shoot murderer instead
            if state.autofarmEnabled and hasTool(LocalPlayer, "Gun") then
                break
            end

            targetChar = targetPlr.Character
            targetHrp  = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
            if not targetHrp then break end

            pcall(function()
                if camera then
                    local tHum = targetChar:FindFirstChildOfClass("Humanoid")
                    if tHum and camera.CameraSubject ~= tHum then
                        camera.CameraSubject = tHum
                    end
                end
            end)

            pcall(function()
                local plate = Workspace:FindFirstChild("AntiVoidPlate")
                if plate then
                    plate.Position = Vector3.new(hrp.Position.X, getAntiVoidPlateY(), hrp.Position.Z)
                end
            end)

            local targetHead = targetChar:FindFirstChild("Head")
            local headY = targetHead and targetHead.Position.Y or (targetHrp.Position.Y + 1.5)
            local headHeightOffset = (state.flingHeadHeight ~= nil and state.flingHeadHeight) or (state.flingYOffset or 0)
            local targetVel = targetHrp.AssemblyLinearVelocity or targetHrp.Velocity or Vector3.zero
            local yFactor = state.flingYVelocityFactor or 0.15
            local dynamicY = headY + headHeightOffset + (targetVel.Y * yFactor)
            if dynamicY < minAllowedY then
                dynamicY = minAllowedY
            end

            local targetPos = Vector3.new(targetHrp.Position.X, dynamicY, targetHrp.Position.Z)

            local t = tick()
            local targetLook = targetHrp.CFrame.LookVector
            local baseOffset = state.flingForwardOffset or 3.0
            local fwdOffset  = math.sin(t * 30) * baseOffset
            local upOffset   = math.cos(t * 25) * 0.8

            local flingPos = targetPos + (targetLook * fwdOffset) + Vector3.new(0, upOffset, 0)

            pcall(function()
                hrp.Anchored = false
                hrp.CFrame = CFrame.new(flingPos) * CFrame.Angles(math.rad(90), 0, 0)
                hrp.AssemblyAngularVelocity = Vector3.new(10000000, 10000000, 10000000)
                local dirToTarget = (targetPos - hrp.Position).Unit
                hrp.AssemblyLinearVelocity = (dirToTarget * 4000) + Vector3.new(0, math.sin(t * 40) * 2000, 0)
            end)

            RunService.Heartbeat:Wait()
        end
    end)

    state.isFlinging = false
    lastFlingTick = tick()

    pcall(function()
        local myChar = LocalPlayer.Character
        local myHrp  = myChar and myChar:FindFirstChild("HumanoidRootPart")
        local myHum  = myChar and myChar:FindFirstChildOfClass("Humanoid")

        if myHrp then
            myHrp.CFrame = CFrame.new(myHrp.Position)
            myHrp.AssemblyLinearVelocity  = Vector3.zero
            myHrp.AssemblyAngularVelocity = Vector3.zero
        end

        stopAllMovement()

        if myHum then
            myHum.PlatformStand = false
            myHum.Sit = false
            myHum:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
        RunService.Heartbeat:Wait()
        if myHum then
            myHum:ChangeState(Enum.HumanoidStateType.Running)
        end
        if myHrp then
            myHrp.AssemblyLinearVelocity  = Vector3.zero
            myHrp.AssemblyAngularVelocity = Vector3.zero
        end
    end)

    pcall(function()
        local camera = Workspace.CurrentCamera
        local myHum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if camera then
            camera.CameraSubject = myHum or originalSubject
        end
    end)

    if state.autofarmEnabled then
        tpToSafeSpawn(true)
    end
end

-- resolve player name from partial input 
local function findPlayer(queryStr)
    if not queryStr or type(queryStr) ~= "string" or queryStr:gsub("%s+", "") == "" then
        return nil, "enter username"
    end

    local cleanQuery = queryStr:lower():gsub("%s+", "")
    local exactMatches = {}
    local prefixMatches = {}
    local containsMatches = {}

    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            local pName = plr.Name:lower()
            local pDisp = plr.DisplayName:lower()

            if pName == cleanQuery or pDisp == cleanQuery then
                table.insert(exactMatches, plr)
            elseif pName:sub(1, #cleanQuery) == cleanQuery or pDisp:sub(1, #cleanQuery) == cleanQuery then
                table.insert(prefixMatches, plr)
            elseif pName:find(cleanQuery, 1, true) or pDisp:find(cleanQuery, 1, true) then
                table.insert(containsMatches, plr)
            end
        end
    end

    local candidateList = #exactMatches > 0 and exactMatches or (#prefixMatches > 0 and prefixMatches or containsMatches)

    if #candidateList == 1 then
        return candidateList[1], nil
    elseif #candidateList > 1 then
        local names = {}
        for _, p in ipairs(candidateList) do
            table.insert(names, p.Name)
        end
        return nil, "Ambiguous: " .. #candidateList .. " players found (" .. table.concat(names, ", ") .. ")"
    else
        return nil, "no player matching '" .. queryStr .. "'"
    end
end

-- mm2 hud displays MainGUI.Game.CoinBags only while a round is active; update if game renames hud frame
function isCoinBagVisible()
    local ok, res = pcall(function()
        local gui = LocalPlayer.PlayerGui:FindFirstChild("MainGUI")
        if not gui then return false end
        local gameFrame = gui:FindFirstChild("Game")
        if not gameFrame then return false end
        local coinBags = gameFrame:FindFirstChild("CoinBags")
        if not coinBags or not coinBags.Visible then return false end

        local container = coinBags:FindFirstChild("Container")
        if container and container.Visible then
            for _, child in ipairs(container:GetChildren()) do
                if child:IsA("GuiObject") and child.Visible then return true end
            end
        end
        local coin = coinBags:FindFirstChild("Coin")
        if coin and coin:IsA("GuiObject") and coin.Visible then return true end
        for _, child in ipairs(coinBags:GetChildren()) do
            if child.Name ~= "Container" and child:IsA("GuiObject") and child.Visible then return true end
        end
        return false
    end)
    return ok and res == true
end

-- dispatch attack action to eliminate target 
local function killTarget()
    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    local hum  = char and char:FindFirstChildOfClass("Humanoid")
    if not hrp or not hum or hum.Health <= 0 then return end

    local role = getPlayerRole(LocalPlayer)

    if role == "Murderer" then
        local knifeTool = getPlayerTool(LocalPlayer, "Knife")
        if knifeTool then
            hum:EquipTool(knifeTool)
            task.wait(0.1)
            local events = getKnifeEvents()
            if events then
                pcall(function() events.KnifeStabbed:FireServer() end)
                task.wait(0.02)
                for _, target in ipairs(Players:GetPlayers()) do
                    if target ~= LocalPlayer and isPlayerAlive(target) then
                        local tChar = target.Character
                        local tHrp  = tChar and tChar:FindFirstChild("HumanoidRootPart")
                        if tChar and tHrp then
                            local handle = nil
                            for _, acc in ipairs(tChar:GetChildren()) do
                                if acc:IsA("Accessory") then
                                    local h = acc:FindFirstChild("Handle")
                                    if h then handle = h; break end
                                end
                            end
                            handle = handle or tHrp

                            pcall(function() events.HandleTouched:FireServer(handle) end)
                            local tKnifeLook = tHrp.CFrame.LookVector
                            local tKnifeStart = Vector3.new(tHrp.Position.X - tKnifeLook.X * 0.1, tHrp.Position.Y, tHrp.Position.Z - tKnifeLook.Z * 0.1)
                            pcall(function() events.KnifeThrown:FireServer(CFrame.new(tKnifeStart, tHrp.Position), CFrame.new(tHrp.Position)) end)
                            task.wait(0.02)
                        end
                    end
                end
            end
        end

    elseif role == "Sheriff" or hasTool(LocalPlayer, "Gun") then
        local gunTool = getPlayerTool(LocalPlayer, "Gun")
        local murderer = state.knifeHolder
        if not murderer or not isMurdererAlive(murderer) then murderer = getMurd() end
        if murderer and isMurdererAlive(murderer) then state.knifeHolder = murderer end
        if gunTool and murderer and isPlayerAlive(murderer) then
            hum:EquipTool(gunTool)
            task.wait(0.1)
            local shootEvent = getGunShootEvent()
            local mChar = murderer.Character
            local mHead = mChar and mChar:FindFirstChild("Head")
            local mTorso = mChar and (mChar:FindFirstChild("UpperTorso") or mChar:FindFirstChild("Torso") or mChar:FindFirstChild("LowerTorso") or mChar:FindFirstChild("HumanoidRootPart"))
            if shootEvent and mTorso then
                local rawPos = mTorso.Position
                local predH, predV = getSilentAimPred()
                local targetPos = calculateAimPosition(rawPos, mTorso, predH, predV)
                local startPos = mHead and mHead.Position or (rawPos + Vector3.new(0, 1.5, 0))
                local startCF  = CFrame.new(startPos, targetPos)
                local targetCF = CFrame.new(targetPos)
                pcall(function()
                    shootEvent:FireServer(startCF, targetCF)
                end)
            end
        end

    else
        local gunShot = false
        if state.autoTakeGun and isCoinBagVisible() and isPlayerAlive(LocalPlayer) then
            local droppedGun = getDroppedGun()
            if droppedGun then
                local returnCFrame = hrp.CFrame
                hrp.CFrame = droppedGun.CFrame
                task.wait(0.2)
                local gunTool = getPlayerTool(LocalPlayer, "Gun")
                local murderer = state.knifeHolder
                if gunTool and murderer and isPlayerAlive(murderer) then
                    hum:EquipTool(gunTool)
                    task.wait(0.1)
                    local shootEvent = getGunShootEvent()
                    local mChar = murderer.Character
                    local mHead = mChar and mChar:FindFirstChild("Head")
                    local mTorso = mChar and (mChar:FindFirstChild("UpperTorso") or mChar:FindFirstChild("Torso") or mChar:FindFirstChild("LowerTorso") or mChar:FindFirstChild("HumanoidRootPart"))
                    if shootEvent and mTorso then
                        local rawPos = mTorso.Position
                        local predH, predV = getSilentAimPred()
                        local targetPos = calculateAimPosition(rawPos, mTorso, predH, predV)
                        local startPos = mHead and mHead.Position or (rawPos + Vector3.new(0, 1.5, 0))
                        local startCF  = CFrame.new(startPos, targetPos)
                        local targetCF = CFrame.new(targetPos)
                        pcall(function()
                            shootEvent:FireServer(startCF, targetCF)
                        end)
                        gunShot = true
                    end
                end
                task.wait(0.02)
                pcall(function() hrp.CFrame = returnCFrame end)
            end
        end

        if not gunShot and state.knifeHolder and isPlayerAlive(state.knifeHolder) and state.knifeHolder ~= LocalPlayer then
            while state.autofarmEnabled and isPlayerAlive(LocalPlayer) and isCoinBagVisible() do
                -- Check if player acquired gun during or before fling
                if hasTool(LocalPlayer, "Gun") or getPlayerRole(LocalPlayer) == "Sheriff" then
                    killTarget()
                    break
                end

                local m = state.knifeHolder
                if not m or not isMurdererAlive(m) then m = getMurd() end
                if not m or not isMurdererAlive(m) or m == LocalPlayer then break end
                flingTarget(m, true, 4.0)

                -- Check again immediately after fling return if player acquired a gun
                if hasTool(LocalPlayer, "Gun") or getPlayerRole(LocalPlayer) == "Sheriff" then
                    killTarget()
                    break
                end

                if isMurdererAlive(m) and state.autofarmEnabled and isPlayerAlive(LocalPlayer) and isCoinBagVisible() then
                    task.wait(2.0)
                else
                    break
                end
            end
        end
    end
end


-- detect coin cap and round state from player gui 

local function getMapModel()
    local m = getActiveMap and getActiveMap()
    if m and m.Parent == Workspace then return m end
    for _, child in ipairs(Workspace:GetChildren()) do
        if _isMapChild and _isMapChild(child) then return child end
    end
    return nil
end

local function getCoinTouchInterest(part)
    if not part or not part.Parent then return nil end
    local ti = part:FindFirstChild("TouchInterest")
        or part:FindFirstChildOfClass("TouchTransmitter")
        or part:FindFirstChildWhichIsA("TouchTransmitter")
    if ti and ti.Parent then return ti end
    if part.Parent and part.Parent ~= Workspace then
        ti = part.Parent:FindFirstChild("TouchInterest")
            or part.Parent:FindFirstChildOfClass("TouchTransmitter")
            or part.Parent:FindFirstChildWhichIsA("TouchTransmitter")
        if ti and ti.Parent then return ti end
    end
    return nil
end

local lastFallbackCoinScan = 0

local function scanAllCoins()
    local coins = {}
    local seen  = {}

    local function tryAdd(item, part)
        -- locate physics collider holding pickup trigger
        if not part or not part:IsA("BasePart") then return end
        if seen[part] then return end
        if not part.Parent then return end

        -- ignore coins already collected: CoinVisual fades to ~1 when collected (normal value ~0.05)
        if item then
            local visual = item:FindFirstChild("CoinVisual")
            if visual and visual:IsA("BasePart") and visual.Transparency >= 0.9 then return end
        end
        if part.Transparency >= 0.9 then return end

        -- TouchInterest lives on Coin_Server (item), fall back to checking part directly
        local ti = (item and getCoinTouchInterest(item)) or getCoinTouchInterest(part)
        if not ti then return end  -- ignore static decoration coins

        seen[part] = true
        table.insert(coins, {
            Part          = part,
            TouchInterest = ti,
            Position      = part.Position,
        })
    end

    -- pull coin folder from active map first
    local map = getMapModel()
    if map then
        local cc = map:FindFirstChild("CoinContainer")
              or map:FindFirstChild("Coins")
              or map:FindFirstChild("CoinArea")
        if cc then
            for _, item in ipairs(cc:GetChildren()) do
                -- item IS the Coin_Server model; CoinVisual is the BasePart inside it
                local visual = item:FindFirstChild("CoinVisual")
                if visual and visual:IsA("BasePart") then
                    tryAdd(item, visual)
                elseif item:IsA("BasePart") then
                    tryAdd(nil, item)
                else
                    tryAdd(item, item:FindFirstChildWhichIsA("BasePart", true))
                end
            end
        end
    end

    -- fall back to common map container names
    for _, parentName in ipairs({"Workplace", "Normal", "Map", "CurrentMap"}) do
        local p = Workspace:FindFirstChild(parentName)
        if p and p ~= map then
            local cc = p:FindFirstChild("CoinContainer") or p:FindFirstChild("Coins") or p:FindFirstChild("CoinArea")
            if cc then
                for _, item in ipairs(cc:GetChildren()) do
                    -- item IS the Coin_Server model; CoinVisual is the BasePart inside it
                    local visual = item:FindFirstChild("CoinVisual")
                    if visual and visual:IsA("BasePart") then
                        tryAdd(item, visual)
                    elseif item:IsA("BasePart") then
                        tryAdd(nil, item)
                    else
                        tryAdd(item, item:FindFirstChildWhichIsA("BasePart", true))
                    end
                end
            end
        end
    end

    -- scan workspace if map hierarchy differs (look for CoinVisual BaseParts)
    local now = tick()
    if #coins == 0 and (now - lastFallbackCoinScan >= 5) then
        lastFallbackCoinScan = now
        for _, desc in ipairs(Workspace:GetDescendants()) do
            if desc:IsA("BasePart") and desc.Name == "CoinVisual" then
                -- desc.Parent is Coin_Server
                tryAdd(desc.Parent, desc)
            end
        end
    end

    return coins
end

local function getBagIconState()
    local ok, active, full = pcall(function()
        if not isCoinBagVisible() then return false, false end
        local gui      = LocalPlayer.PlayerGui:FindFirstChild("MainGUI")
        local game_    = gui and gui:FindFirstChild("Game")
        local coinBags = game_ and game_:FindFirstChild("CoinBags")
        if not coinBags then return true, false end

        -- check both fullbagicon visibility and parsed cur/max text because mm2 variations represent capacity differently across updates
        local function checkFull(obj)
            if not obj then return false end
            local fi = obj:FindFirstChild("FullBagIcon")
            if fi and fi.Visible then return true end
            local lbl = obj:FindFirstChild("Amount") or obj:FindFirstChild("CoinCount")
                     or obj:FindFirstChildWhichIsA("TextLabel", true)
            if lbl and lbl:IsA("TextLabel") then
                local cur, max_ = lbl.Text:match("(%d+)%s*/%s*(%d+)")
                if cur and max_ and tonumber(max_) > 0 and tonumber(cur) >= tonumber(max_) then
                    return true
                end
            end
            return false
        end

        local container = coinBags:FindFirstChild("Container")
        if container then
            for _, c in ipairs(container:GetChildren()) do
                if c:IsA("GuiObject") and c.Visible and checkFull(c) then return true, true end
            end
        end
        for _, c in ipairs(coinBags:GetChildren()) do
            if c.Name ~= "Container" and c:IsA("GuiObject") and c.Visible and checkFull(c) then return true, true end
        end
        return true, false
    end)
    if not ok then return false, false end
    return active == true, full == true
end

local function isBagFull()
    local _, full = getBagIconState()
    return full
end

local function isRoundActiveUI()
    return isPlayerAlive(LocalPlayer) and isCoinBagVisible()
end

local function isIntermission()
    return not isCoinBagVisible()
end

local function canFarmCoins()
    if not state or state.unloaded or not state.autofarmEnabled then return false end
    if not isPlayerAlive(LocalPlayer)  then return false end
    if not isCoinBagVisible()          then return false end
    if isBagFull()                     then return false end
    return true
end

-- verify match status before dispatching actions 
local cachedKnifeHolder = nil
local cachedGunHolder   = nil

local function endRound()
    if not state.roundActive then return end
    state.roundActive  = false
    state.tweenRoundTeleported = false
    state.knifeHolder  = nil
    state.gunHolder    = nil
    cachedKnifeHolder  = nil
    cachedGunHolder    = nil
    state.roundsPassed = state.roundsPassed + 1
    state.noRoundStartTime = tick()
    if state.deadPlayers then
        table.clear(state.deadPlayers)
    end
    if state.webhookEnabled and tick() - state.lastWebhookSent >= state.webhookIntervalSec then
        state.lastWebhookSent = tick()
        task.spawn(sendDiscordWebhook)
    end
end

local function hookCharacterDeath(plr, char)
    local hum = char:FindFirstChildOfClass("Humanoid")
        or char:WaitForChild("Humanoid", 3)
    if not hum then return end
    trackPlayerConnection(plr, hum.Died:Connect(function()
        state.deadPlayers[plr] = true
        if plr == state.knifeHolder or plr == cachedKnifeHolder then
            task.delay(0.5, function()
                if not state.unloaded and not hasTool(plr, "Knife") and not isRoundActiveUI() then
                    endRound()
                end
            end)
        end
        if plr == LocalPlayer then
            if state.flightEnabled then
                state.flightEnabled = false
                if flyConn then pcall(function() flyConn:Disconnect() end); flyConn = nil end
                stopAllMovement()
                pcall(function() if Options.FlightEnabled then Options.FlightEnabled:SetValue(false) end end)
            else
                setNoclip(false)
            end
        end
    end))
end

local function hookPlayer(plr)
    if not plr then return end
    clearPlayerConnections(plr)
    if plr.Character then
        hookCharacterDeath(plr, plr.Character)
    end
    if playerCharConnections[plr] then
        pcall(function() playerCharConnections[plr]:Disconnect() end)
    end
    playerCharConnections[plr] = plr.CharacterAdded:Connect(function(char)
        clearPlayerConnections(plr)
        task.wait(0.1)
        hookCharacterDeath(plr, char)
    end)
end

for _, plr in ipairs(Players:GetPlayers()) do
    hookPlayer(plr)
end

trackConnection(Players.PlayerAdded:Connect(function(plr)
    hookPlayer(plr)
end))

trackConnection(Players.PlayerRemoving:Connect(function(plr)
    clearPlayerConnections(plr)
    if playerCharConnections[plr] then
        pcall(function() playerCharConnections[plr]:Disconnect() end)
        playerCharConnections[plr] = nil
    end
    if state and state.deadPlayers then
        state.deadPlayers[plr] = nil
    end
end))

trackThread(task.spawn(function()
    local knifeMissingStartTime = 0

    while not state.unloaded do
        local newKnifeHolder = nil
        local newGunHolder   = nil

        for _, plr in ipairs(Players:GetPlayers()) do
            if isPlayerAlive(plr) then
                if hasTool(plr, "Knife") then
                    newKnifeHolder = plr
                end
                if hasTool(plr, "Gun") then
                    newGunHolder = plr
                end
            end
        end

        if not newKnifeHolder then
            local rsMurderer = getMurd()
            if rsMurderer and isPlayerAlive(rsMurderer) then
                newKnifeHolder = rsMurderer
            end
        end
        if not newGunHolder then
            local rsSheriff = getSheriff()
            if rsSheriff and isPlayerAlive(rsSheriff) then
                newGunHolder = rsSheriff
            end
        end

        local knifeInGame = (newKnifeHolder ~= nil)

        if (knifeInGame or isRoundActiveUI()) and not state.roundActive then
            state.roundActive          = true
            state.roundStartTime       = tick()
            state.noRoundStartTime     = tick()
            state.knifeHolder          = newKnifeHolder
            state.gunHolder            = newGunHolder
            cachedKnifeHolder          = newKnifeHolder
            cachedGunHolder            = newGunHolder
            knifeMissingStartTime      = 0
            state.tweenRoundTeleported = false
            table.clear(state.deadPlayers)

        elseif state.roundActive then
            if newKnifeHolder then
                state.knifeHolder = newKnifeHolder
                cachedKnifeHolder = newKnifeHolder
            end
            if newGunHolder then
                state.gunHolder = newGunHolder
                cachedGunHolder = newGunHolder
            end

            state.noRoundStartTime = tick()

            if not knifeInGame and isIntermission() then
                if knifeMissingStartTime == 0 then
                    knifeMissingStartTime = tick()
                end
                if tick() - knifeMissingStartTime >= 2.0 then
                    endRound()
                    knifeMissingStartTime = 0
                end
            elseif knifeInGame or isRoundActiveUI() then
                knifeMissingStartTime = 0
            end

        else
            state.knifeHolder = newKnifeHolder
            state.gunHolder   = newGunHolder
            knifeMissingStartTime = 0

            if state.autofarmEnabled and tick() - state.noRoundStartTime > 240 then
                serverHop()
            end
        end

        task.wait(0.1)
    end
end))

-- deliver match statistics to remote endpoint loop 
trackThread(task.spawn(function()
    while not state.unloaded do
        task.wait(10)
        if state.webhookEnabled and tick() - state.lastWebhookSent >= state.webhookIntervalSec then
            state.lastWebhookSent = tick()
            task.spawn(sendDiscordWebhook)
        end
    end
end))

-- project procedural circular rings under character
local auraLayers = {}
local particleAnchorPart = nil
local auraSurfaceGui = nil
-- snap visual plane to floor surface under feet
local function getGroundCFrame(character, rootPart)
    local rayOrigin = rootPart.Position
    local rayDirection = Vector3.new(0, -8, 0)

    local raycastParams = RaycastParams.new()
    local ignoreList = { character }
    for _, layer in ipairs(auraLayers) do
        if layer.part then
            table.insert(ignoreList, layer.part)
        end
    end
    if particleAnchorPart then
        table.insert(ignoreList, particleAnchorPart)
    end
    raycastParams.FilterDescendantsInstances = ignoreList
    raycastParams.FilterType = Enum.RaycastFilterType.Exclude
    raycastParams.IgnoreWater = true

    -- ignore non-solid geometry during floor cast
    for _ = 1, 4 do
        local hit = workspace:Raycast(rayOrigin, rayDirection, raycastParams)
        if not hit then break end

        if hit.Instance and hit.Instance.CanCollide then
            -- elevate slightly to prevent floor z-fighting
            return CFrame.new(rootPart.Position.X, hit.Position.Y + 0.04, rootPart.Position.Z)
        end

        table.insert(ignoreList, hit.Instance)
        raycastParams.FilterDescendantsInstances = ignoreList
    end

    -- default to hip height when hovering over void
    return CFrame.new(rootPart.Position.X, rootPart.Position.Y - 2.35, rootPart.Position.Z)
end

-- resolve decal asset and flipbook metadata from preset choice
local function getParticleTextureData()
    local preset = state.killAuraParticlePreset
    local presetVal = killAuraParticlePresets[preset]
    local rawId = ""
    local isAnim = false
    local layout = "Grid4x4"
    if type(presetVal) == "table" then
        rawId = presetVal.texture
        isAnim = presetVal.isAnimated or false
        layout = presetVal.flipbookLayout or "Grid4x4"
    elseif type(presetVal) == "string" then
        rawId = presetVal
    end
    if preset == "Custom" then
        rawId = state.killAuraParticleCustomId or ""
    end
    local formatted = formatCustomAssetId(rawId)
    if not formatted or formatted == "" then
        formatted = "rbxassetid://112096280571499"
    end
    return formatted, isAnim, layout
end

local function getParticleTextureId()
    local formatted = getParticleTextureData()
    return formatted
end

local auraFlipbookState = {
    lastTime = 0,
    frameIndex = 0,
    pingPongForward = true
}

local function parseAuraFlipbookGrid(layoutStr)
    local s = tostring(layoutStr or "4x4"):gsub("%s+", "")
    local c, r = s:match("^(%d+)[xX*:,](%d+)$")
    if not c and s:match("^(%d+)$") then
        local d = s:match("^(%d+)$")
        c, r = d, d
    end
    if c and r then
        return tonumber(c) or 4, tonumber(r) or 4
    end
    local upper = s:upper()
    if upper:find("2X2") or upper:find("2") then
        return 2, 2
    elseif upper:find("8X8") or upper:find("8") then
        return 8, 8
    else
        return 4, 4
    end
end

-- vary layer spin rates for natural parallax
local function getRandomSpinSpeed()
    local minS = math.min(state.killAuraParticleMinSpin, state.killAuraParticleMaxSpin)
    local maxS = math.max(state.killAuraParticleMinSpin, state.killAuraParticleMaxSpin)
    if minS == maxS then
        return minS
    end
    return minS + math.random() * (maxS - minS)
end

-- refresh rotation speeds across active rings
local function randomizeLayerSpeeds()
    for _, layer in ipairs(auraLayers) do
        layer.spinSpeed = getRandomSpinSpeed()
    end
end

-- update layer positions and color transitions
local function updateAuraVisuals(dt)
    if #auraLayers == 0 then return end

    local color1 = state.killAuraParticleColor
    local color2 = state.killAuraParticleColor2
    local mode = state.killAuraParticleColorMode
    local speed = state and state.colorShiftSpeed or 3
    local phase = (tick() * (speed * 0.15)) % 1.0

    local degreeOffset = state.killAuraDegreeOffset or state.killAuraParticleSpawnDelay or 0
    for idx, layer in ipairs(auraLayers) do
        local img = layer.imageLabel
        local uiGrad = layer.gradient
        local offsetAngle = (idx - 1) * degreeOffset

        -- advance layer angle by individual spin speed
        if dt and dt > 0 and layer.spinSpeed and layer.spinSpeed ~= 0 then
            layer.rotationAngle = ((layer.rotationAngle or 0) + dt * layer.spinSpeed) % 360
        end
        img.Rotation = ((layer.rotationAngle or 0) + offsetAngle) % 360

        if mode == "Gradient" or mode == "Gradient 2" then
            uiGrad.Enabled = true
            uiGrad.Rotation = 0
            local function getSmoothCol(off)
                local tVal = (math.sin((phase - off) * math.pi * 2) + 1) * 0.5
                return color1:Lerp(color2, tVal)
            end
            uiGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0,    getSmoothCol(0)),
                ColorSequenceKeypoint.new(0.25, getSmoothCol(0.25)),
                ColorSequenceKeypoint.new(0.5,  getSmoothCol(0.5)),
                ColorSequenceKeypoint.new(0.75, getSmoothCol(0.75)),
                ColorSequenceKeypoint.new(1,    getSmoothCol(1))
            })
            img.ImageColor3 = Color3.new(1, 1, 1)
        elseif mode == "Rainbow" or mode == "Rainbow 2" or mode == "Rainbow 1" then
            uiGrad.Enabled = true
            uiGrad.Rotation = 0
            local function getRainbowCol(off)
                return Color3.fromHSV((phase - off) % 1, 1, 1)
            end
            uiGrad.Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0,    getRainbowCol(0)),
                ColorSequenceKeypoint.new(0.17, getRainbowCol(0.17)),
                ColorSequenceKeypoint.new(0.33, getRainbowCol(0.33)),
                ColorSequenceKeypoint.new(0.50, getRainbowCol(0.50)),
                ColorSequenceKeypoint.new(0.67, getRainbowCol(0.67)),
                ColorSequenceKeypoint.new(0.83, getRainbowCol(0.83)),
                ColorSequenceKeypoint.new(1.00, getRainbowCol(1))
            })
            img.ImageColor3 = Color3.new(1, 1, 1)
        elseif mode == "Shift" then
            uiGrad.Enabled = false
            local shiftFactor = (math.sin(tick() * 3) + 1) * 0.5
            img.ImageColor3 = color1:Lerp(color2, shiftFactor)
        else
            uiGrad.Enabled = false
            img.ImageColor3 = color1
        end
    end

    -- advance flipbook animation across frames
    local _, presetIsAnim, presetLayout = getParticleTextureData()
    local isFlipbook = state.killAuraParticleIsFlipbook or (presetIsAnim and state.killAuraParticlePreset ~= "Custom")
    if isFlipbook then
        local layoutStr = state.killAuraParticleFlipbookLayout
        if presetIsAnim and (not state.killAuraParticleIsFlipbook or layoutStr == "Grid4x4" or not layoutStr) then
            layoutStr = presetLayout
        end
        local gridX, gridY = parseAuraFlipbookGrid(layoutStr)
        local fps = tonumber(state.killAuraParticleFlipbookSpeed) or 15
        local interval = 1 / math.max(1, fps)
        local now = tick()
        if now - auraFlipbookState.lastTime >= interval then
            auraFlipbookState.lastTime = now
            local totalFrames = math.max(1, gridX * gridY)
            local mode = state.killAuraParticleFlipbookMode or "Loop"
            if mode == "OneShot" then
                auraFlipbookState.frameIndex = math.min(auraFlipbookState.frameIndex + 1, totalFrames - 1)
            elseif mode == "PingPong" then
                if auraFlipbookState.pingPongForward then
                    auraFlipbookState.frameIndex = auraFlipbookState.frameIndex + 1
                    if auraFlipbookState.frameIndex >= totalFrames - 1 then
                        auraFlipbookState.frameIndex = totalFrames - 1
                        auraFlipbookState.pingPongForward = false
                    end
                else
                    auraFlipbookState.frameIndex = auraFlipbookState.frameIndex - 1
                    if auraFlipbookState.frameIndex <= 0 then
                        auraFlipbookState.frameIndex = 0
                        auraFlipbookState.pingPongForward = true
                    end
                end
            else
                auraFlipbookState.frameIndex = (auraFlipbookState.frameIndex + 1) % totalFrames
            end
        end

        local col = auraFlipbookState.frameIndex % gridX
        local row = math.floor(auraFlipbookState.frameIndex / gridX)
        for _, layer in ipairs(auraLayers) do
            local img = layer.imageLabel
            if img then
                local imgW = (img.ContentImageSize and img.ContentImageSize.X > 0) and img.ContentImageSize.X or 1024
                local imgH = (img.ContentImageSize and img.ContentImageSize.Y > 0) and img.ContentImageSize.Y or 1024
                local frameW = imgW / gridX
                local frameH = imgH / gridY
                img.ImageRectSize = Vector2.new(frameW, frameH)
                img.ImageRectOffset = Vector2.new(col * frameW, row * frameH)
            end
        end
    else
        for _, layer in ipairs(auraLayers) do
            local img = layer.imageLabel
            if img and img.ImageRectSize ~= Vector2.zero then
                img.ImageRectSize = Vector2.zero
                img.ImageRectOffset = Vector2.zero
            end
        end
    end
end

-- clean up aura visual instances
local function cleanupParticleAura()
    for _, layer in ipairs(auraLayers) do
        if layer.part then
            pcall(function() layer.part:Destroy() end)
        end
    end
    table.clear(auraLayers)
    particleAnchorPart = nil
    auraSurfaceGui = nil
end

-- construct multi-layered circle rings
local function rebuildParticleAura()
    if not state.killAuraParticleEnabled or not isPlayerAlive(LocalPlayer) then
        cleanupParticleAura()
        return
    end

    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then
        cleanupParticleAura()
        return
    end

    cleanupParticleAura()

    local size = state.killAuraParticleSize
    local groundCFrame = getGroundCFrame(char, hrp)
    local count = math.clamp(state.killAuraParticleCount, 1, 10)
    local textureId, presetIsAnim, presetLayout = getParticleTextureData()
    local heightDiff = state.killAuraHeightOffset or 0
    local brightness = 1 + (state.killAuraParticleGlow * 2)

    for i = 1, count do
        local layerYOffset = (i - 1) * heightDiff + (i - 1) * 0.001
        local partCFrame = groundCFrame + Vector3.new(0, layerYOffset, 0)

        local part = Instance.new("Part")
        part.Name = "AuraAnchor_" .. i
        part.Transparency = 1
        part.CanCollide = false
        part.CanTouch = false
        part.CanQuery = false
        part.CastShadow = false
        part.Anchored = true
        part.Size = Vector3.new(size, 0.05, size)
        part.CFrame = partCFrame
        part.Parent = workspace

        local sg = Instance.new("SurfaceGui")
        sg.Name = "AuraSurfaceGui_" .. i
        sg.Face = Enum.NormalId.Top
        sg.LightInfluence = 0
        sg.AlwaysOnTop = false
        sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
        sg.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
        sg.CanvasSize = Vector2.new(1024, 1024)
        sg.Brightness = brightness
        sg.Adornee = part
        sg.Parent = part

        local img = Instance.new("ImageLabel")
        img.Name = "AuraImage_" .. i
        img.Size = UDim2.fromScale(1, 1)
        img.Position = UDim2.fromScale(0.5, 0.5)
        img.AnchorPoint = Vector2.new(0.5, 0.5)
        img.BackgroundTransparency = 1
        img.Image = textureId
        img.ImageTransparency = state.killAuraParticleTransparency
        img.ScaleType = Enum.ScaleType.Fit
        img.ZIndex = i
        img.Parent = sg

        local isFlipbook = state.killAuraParticleIsFlipbook or (presetIsAnim and state.killAuraParticlePreset ~= "Custom")
        if isFlipbook then
            local layoutStr = state.killAuraParticleFlipbookLayout
            if presetIsAnim and (not state.killAuraParticleIsFlipbook or layoutStr == "Grid4x4" or not layoutStr) then
                layoutStr = presetLayout
            end
            local gridX, gridY = parseAuraFlipbookGrid(layoutStr)
            local frameW = 1024 / gridX
            local frameH = 1024 / gridY
            img.ImageRectSize = Vector2.new(frameW, frameH)
            img.ImageRectOffset = Vector2.zero
        else
            img.ImageRectSize = Vector2.zero
            img.ImageRectOffset = Vector2.zero
        end

        local uiAspect = Instance.new("UIAspectRatioConstraint")
        uiAspect.AspectRatio = 1
        uiAspect.DominantAxis = Enum.DominantAxis.Width
        uiAspect.AspectType = Enum.AspectType.FitWithinMaxSize
        uiAspect.Parent = img

        local uiGrad = Instance.new("UIGradient")
        uiGrad.Name = "AuraGradient"
        uiGrad.Parent = img

        table.insert(auraLayers, {
            part = part,
            surfaceGui = sg,
            imageLabel = img,
            gradient = uiGrad,
            spinSpeed = getRandomSpinSpeed(),
            rotationAngle = 0
        })
    end

    particleAnchorPart = auraLayers[1] and auraLayers[1].part or nil
    auraSurfaceGui = auraLayers[1] and auraLayers[1].surfaceGui or nil

    updateAuraVisuals(0)
end

-- reattach aura when character respawns
trackConnection(LocalPlayer.CharacterAdded:Connect(function(newChar)
    if state.killAuraParticleEnabled then
        task.spawn(function()
            local hrp = newChar:WaitForChild("HumanoidRootPart", 5)
            if hrp and state.killAuraParticleEnabled then
                task.wait(0.2)
                rebuildParticleAura()
            end
        end)
    end
end))

-- track ground position each frame
trackConnection(RunService.RenderStepped:Connect(function(dt)
    if state.killAuraParticleEnabled and isPlayerAlive(LocalPlayer) then
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if hrp and #auraLayers > 0 then
            local groundCF = getGroundCFrame(char, hrp)
            local heightDiff = state.killAuraHeightOffset or 0
            for i, layer in ipairs(auraLayers) do
                if layer.part and layer.part.Parent == workspace then
                    local yOff = (i - 1) * heightDiff + (i - 1) * 0.001
                    layer.part.CFrame = groundCF + Vector3.new(0, yOff, 0)
                end
            end
            updateAuraVisuals(dt)
        end
    end
end))

-- recreate destroyed aura parts automatically
trackThread(task.spawn(function()
    while not state.unloaded do
        if state.killAuraParticleEnabled and isPlayerAlive(LocalPlayer) then
            local char = LocalPlayer.Character
            local hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                local needsRebuild = (#auraLayers == 0)
                for _, layer in ipairs(auraLayers) do
                    if not layer.part or layer.part.Parent ~= workspace
                        or not layer.surfaceGui or layer.surfaceGui.Parent ~= layer.part then
                        needsRebuild = true
                        break
                    end
                end
                if needsRebuild then
                    rebuildParticleAura()
                end
            else
                cleanupParticleAura()
            end
        else
            cleanupParticleAura()
        end
        task.wait(0.5)
    end
end))

-- attack enemies within knife reach automatically
local knifeKillAuraZonePart = nil
local knifeAttackDebounce = false

trackThread(task.spawn(function()
    while not state.unloaded do
        if state.killAuraEnabled and isPlayerAlive(LocalPlayer) then
            local char = LocalPlayer.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            local hum  = char and char:FindFirstChildOfClass("Humanoid")

            if hrp and hum and hum.Health > 0 then
                local range = math.clamp(state.killAuraRange, 5, 40)

                if not knifeKillAuraZonePart or knifeKillAuraZonePart.Parent ~= char then
                    if knifeKillAuraZonePart then pcall(function() knifeKillAuraZonePart:Destroy() end) end
                    knifeKillAuraZonePart = Instance.new("Part")
                    knifeKillAuraZonePart.Name = "KillAuraZone"
                    knifeKillAuraZonePart.Shape = Enum.PartType.Cylinder
                    knifeKillAuraZonePart.Material = Enum.Material.Neon
                    knifeKillAuraZonePart.Color = Color3.fromRGB(160, 5, 15)
                    knifeKillAuraZonePart.Transparency = 0.8
                    knifeKillAuraZonePart.Anchored = true
                    knifeKillAuraZonePart.CanCollide = false
                    knifeKillAuraZonePart.CanQuery   = false
                    knifeKillAuraZonePart.CanTouch   = false
                    knifeKillAuraZonePart.CastShadow = false
                    knifeKillAuraZonePart.Parent = char
                end

                knifeKillAuraZonePart.Size = Vector3.new(0.08, range * 2, range * 2)
                knifeKillAuraZonePart.CFrame = (hrp.CFrame * CFrame.new(0, -2.75, 0)) * CFrame.Angles(0, 0, math.rad(90))
                knifeKillAuraZonePart.Transparency = (state.killAuraVisible == false) and 1 or 0.8

                local knifeTool = getPlayerTool(LocalPlayer, "Knife")
                if knifeTool and not knifeAttackDebounce then
                    local targetsInRange = {}
                    for _, target in ipairs(Players:GetPlayers()) do
                        if target ~= LocalPlayer and isPlayerAlive(target) then
                            local tChar = target.Character
                            local tHrp  = tChar and tChar:FindFirstChild("HumanoidRootPart")
                            if tHrp then
                                local dist = (tHrp.Position - hrp.Position).Magnitude
                                if dist <= range then
                                    table.insert(targetsInRange, { player = target, char = tChar, hrp = tHrp })
                                end
                            end
                        end
                    end

                    if #targetsInRange > 0 then
                        knifeAttackDebounce = true
                        if knifeTool.Parent ~= char then
                            hum:EquipTool(knifeTool)
                        end
                        task.wait(0.1)

                        if isPlayerAlive(LocalPlayer) and hum and hum.Health > 0 then
                            local events = getKnifeEvents()
                            if events then
                                if state.killAuraType == "Throw" then
                                    for _, tData in ipairs(targetsInRange) do
                                        if isPlayerAlive(tData.player) then
                                            local tChar = tData.char
                                            local tHrp  = tData.hrp
                                            local torso = tChar:FindFirstChild("UpperTorso") or tChar:FindFirstChild("Torso") or tHrp
                                            local torsoPos = torso.Position
                                            local knifeOrigin = hrp.Position + Vector3.new(0, 1.5, 0)
                                            pcall(function() events.KnifeThrown:FireServer(CFrame.new(knifeOrigin, torsoPos), CFrame.new(torsoPos)) end)
                                        end
                                    end
                                else
                                    pcall(function() events.KnifeStabbed:FireServer() end)
                                    for _, tData in ipairs(targetsInRange) do
                                        if isPlayerAlive(tData.player) then
                                            local tChar = tData.char
                                            local tHrp  = tData.hrp
                                            local handle = nil
                                            for _, acc in ipairs(tChar:GetChildren()) do
                                                if acc:IsA("Accessory") then
                                                    local h = acc:FindFirstChild("Handle")
                                                    if h then handle = h; break end
                                                end
                                            end
                                            handle = handle or tHrp
                                            pcall(function() events.KnifeStabbed:FireServer() end)
                                            pcall(function() events.HandleTouched:FireServer(handle) end)
                                        end
                                    end
                                end
                            end
                        end

                        task.delay(0.1, function()
                            pcall(function() hum:UnequipTools() end)
                            task.delay(0.05, function()
                                knifeAttackDebounce = false
                            end)
                        end)
                    end
                end
            else
                -- remove reach indicator when inactive
                if knifeKillAuraZonePart then
                    pcall(function() knifeKillAuraZonePart:Destroy() end)
                    knifeKillAuraZonePart = nil
                end
            end
        else
            -- remove reach indicator when inactive
            if knifeKillAuraZonePart then
                pcall(function() knifeKillAuraZonePart:Destroy() end)
                knifeKillAuraZonePart = nil
            end
        end
        task.wait(0.01)
    end
end))

registerCleanupHook(function()
    cleanupParticleAura()
    if knifeKillAuraZonePart then
        pcall(function() knifeKillAuraZonePart:Destroy() end)
        knifeKillAuraZonePart = nil
    end
end)

-- avoid slowing down in water volumes 
trackThread(task.spawn(function()
    while not state.unloaded do
        if state.autofarmEnabled then
            pcall(function()
                local pier = Workspace:FindFirstChild("Pier")
                if pier then
                    local respawn = pier:FindFirstChild("Respawn")
                    if respawn then
                        local wc = respawn:FindFirstChild("WaterClient")
                        if wc then pcall(function() wc:Destroy() end) end
                    end
                end

                local yacht = Workspace:FindFirstChild("Yacht")
                if yacht then
                    local int = yacht:FindFirstChild("Intereactive") or yacht:FindFirstChild("Interactive")
                    if int then
                        local waterFolder = int:FindFirstChild("Water")
                        if waterFolder then
                            local wcWater = waterFolder:FindFirstChild("WaterClient")
                            if wcWater then pcall(function() wcWater:Destroy() end) end
                        end
                        local wcDirect = int:FindFirstChild("WaterClient")
                        if wcDirect then pcall(function() wcDirect:Destroy() end) end
                    end
                end

                local wcMap = _cachedMap
                if wcMap and wcMap.Parent == Workspace then
                    for _, child in ipairs(wcMap:GetChildren()) do
                        if child.Name == "WaterClient" then
                            pcall(function() child:Destroy() end)
                        elseif child:IsA("Folder") or child:IsA("Model") then
                            local wcSub = child:FindFirstChild("WaterClient")
                            if wcSub then
                                pcall(function() wcSub:Destroy() end)
                            end
                        end
                    end
                end
            end)
            task.wait(1.5)
        else
            task.wait(4.0)
        end
    end
end))


-- trigger character emote animations
local currentEmoteTrack = nil

local standardEmotes = {
    ["Take The L"]       = "rbxassetid://75460729737525",
    ["neck roller"]      = "rbxassetid://110855869390004",
    ["WISH NLE"]         = "rbxassetid://82501710348206",
    ["Zero Two Dance"]   = "rbxassetid://82682811348660",
    ["Gangnam Style"]    = "rbxassetid://129764254213842",
}

local function stopEmote()
    if currentEmoteTrack then
        pcall(function() currentEmoteTrack:Stop() end)
        currentEmoteTrack = nil
    end
    local pe = ReplicatedStorage:FindFirstChild("PlayEmote")
    if pe then
        if pe:IsA("BindableFunction") then
            pcall(function() pe:Invoke("") end)
        elseif pe:IsA("RemoteFunction") then
            pcall(function() pe:InvokeServer("") end)
        elseif pe:IsA("RemoteEvent") then
            pcall(function() pe:FireServer("") end)
        end
    end
end

local function playEmote(emoteNameOrId)
    stopEmote()
    if not emoteNameOrId or emoteNameOrId == "" then return end

    local char = LocalPlayer.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    if not hum then return end
    local animator = hum:FindFirstChildOfClass("Animator") or hum

    local rawStr = tostring(emoteNameOrId)
    local animAsset = nil
    if state.customEmotes and state.customEmotes[rawStr] then
        animAsset = state.customEmotes[rawStr]
    elseif standardEmotes[rawStr] then
        animAsset = standardEmotes[rawStr]
    end

    if not animAsset then
        local num = rawStr:match("%d+")
        if num and (#num >= 6 or rawStr:find("rbxassetid")) then
            animAsset = "rbxassetid://" .. num
        end
    end

    if animAsset then
        local digits = tostring(animAsset):match("%d+")
        if digits then animAsset = "rbxassetid://" .. digits end
        local anim = Instance.new("Animation")
        anim.AnimationId = animAsset
        local track = animator:LoadAnimation(anim)
        track.Priority = Enum.AnimationPriority.Action4 or Enum.AnimationPriority.Action
        track.Looped = true
        track:Play()
        currentEmoteTrack = track
    else
        local lowerName = string.lower(rawStr)
        local pe = ReplicatedStorage:FindFirstChild("PlayEmote")
        if pe then
            if pe:IsA("BindableFunction") then
                pcall(function() pe:Invoke(lowerName) end)
            elseif pe:IsA("RemoteFunction") then
                pcall(function() pe:InvokeServer(lowerName) end)
            elseif pe:IsA("RemoteEvent") then
                pcall(function() pe:FireServer(lowerName) end)
            end
        end
    end
end

trackConnection(RunService.Heartbeat:Connect(function()
    if state.emoteStopOnMove and currentEmoteTrack and currentEmoteTrack.IsPlaying then
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.MoveDirection.Magnitude > 0.05 then
            stopEmote()
        end
    end
end))
registerCleanupHook(stopEmote)

-- display item values directly over inventory slots
local function applyRedGradient(label)
    if not label then return end
    label.TextColor3 = Color3.fromRGB(255, 255, 255)
    local grad = label:FindFirstChild("RedGradient")
    if not grad then
        grad = Instance.new("UIGradient")
        grad.Name = "RedGradient"
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 60)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 0, 10))
        })
        grad.Rotation = 90
        grad.Parent = label
    else
        grad.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 60)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(120, 0, 10))
        })
    end

    label.TextStrokeTransparency = 0
    label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)

    local stroke = label:FindFirstChild("ValueStroke") or label:FindFirstChildOfClass("UIStroke")
    if not stroke then
        stroke = Instance.new("UIStroke")
        stroke.Name = "ValueStroke"
        stroke.Color = Color3.fromRGB(0, 0, 0)
        stroke.Thickness = 1.5
        stroke.Transparency = 0
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
        stroke.Parent = label
    else
        stroke.Color = Color3.fromRGB(0, 0, 0)
        stroke.Thickness = 1.5
        stroke.Transparency = 0
        stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
    end
end

local function isSlotFilled(slot)
    if not slot or not slot.Visible then return false end
    local itemCont = slot:FindFirstChild("Container")
    if not itemCont or not itemCont.Visible then return false end
    local nameObj = slot:FindFirstChild("ItemName")
    if not nameObj or not nameObj.Visible then return false end
    local label = nameObj:FindFirstChild("Label")
    if not label or not label:IsA("TextLabel") then return false end
    local txt = label.Text:gsub("^%s+", ""):gsub("%s+$", "")
    if txt == "" or txt == "Item Name" or txt == "Label" or txt == "Default" then return false end
    return true, txt, nameObj, itemCont
end

local function updateTradeValues()
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not playerGui then return end
    local tradeGui = playerGui:FindFirstChild("TradeGUI")
    if not tradeGui then return end
    local container = tradeGui:FindFirstChild("Container")
    local trade = container and container:FindFirstChild("Trade")
    if not trade then return end

    local isTradeOpen = trade.Visible and state.valueCalculatorEnabled

    local function processOffer(offerFrame)
        if not offerFrame then return end
        local slotContainer = offerFrame:FindFirstChild("Container")
        local itemBg = offerFrame:FindFirstChild("ItemBackground")
        local totalOfferVal = 0
        local hasUnknown = false

        -- clear previous summary labels before redraw
        if itemBg then
            local oldLbl = itemBg:FindFirstChild("TotalValueLabel")
            if oldLbl then oldLbl:Destroy() end
        end
        if slotContainer then
            local oldContainerTotal = slotContainer:FindFirstChild("TotalValueLabel")
            if oldContainerTotal then oldContainerTotal:Destroy() end
        end

        if slotContainer then
            -- mm2 trade slots are indexed NewItem1 through NewItem4 under trade offer containers
            for i = 1, 4 do
                local slot = slotContainer:FindFirstChild("NewItem" .. i)
                if slot then
                    local isFilled, rawName, nameObj, itemCont = isSlotFilled(slot)
                    local oldSlotVal = slot:FindFirstChild("ValueLabel") or slot:FindFirstChild("ItemValueLabel")
                    if oldSlotVal then oldSlotVal:Destroy() end

                    if itemCont then
                        itemCont.ClipsDescendants = false
                        local valLabel = itemCont:FindFirstChild("ItemValueLabel") or itemCont:FindFirstChild("ValueLabel")
                        if isFilled and isTradeOpen then
                            local amount = 1
                            local amountObj = itemCont:FindFirstChild("Amount")
                            if amountObj and amountObj.Visible and amountObj.Text ~= "" then
                                local n = amountObj.Text:match("%d+")
                                if n then amount = tonumber(n) or 1 end
                            end

                            local iconObj = itemCont:FindFirstChild("Icon")
                            local rarity = detectRarityFromColor(nameObj, itemCont)
                            local unitVal = getMM2ItemValueWithIcon(rawName, rarity, iconObj)
                            local isDefault = rawName and rawName:lower():find("default")

                            if not valLabel then
                                valLabel = Instance.new("TextLabel")
                                valLabel.Name = "ItemValueLabel"
                                valLabel.BackgroundTransparency = 1
                                valLabel.BorderSizePixel = 0
                                valLabel.Size = UDim2.new(0, 75, 0, 20)
                                valLabel.Position = UDim2.new(0.05, 0, 0, 3)
                                valLabel.ZIndex = (itemCont.ZIndex or 1) + 20
                                valLabel.Font = Enum.Font.GothamBold
                                valLabel.TextSize = 15
                                valLabel.TextXAlignment = Enum.TextXAlignment.Left
                                valLabel.Parent = itemCont
                            end
                            valLabel.Name = "ItemValueLabel"
                            valLabel.Visible = true
                            valLabel.BackgroundTransparency = 1
                            valLabel.Size = UDim2.new(0, 75, 0, 20)
                            valLabel.Position = UDim2.new(0.05, 0, 0, 3)
                            valLabel.TextSize = 15
                            valLabel.TextXAlignment = Enum.TextXAlignment.Left

                            if unitVal and unitVal > 0 then
                                local slotVal = unitVal * amount
                                totalOfferVal = totalOfferVal + slotVal
                                valLabel.Text = formatValue(slotVal)
                            elseif unitVal == 0 and isDefault then
                                valLabel.Text = "0"
                            else
                                valLabel.Text = "?"
                                hasUnknown = true
                            end
                            applyRedGradient(valLabel)
                        else
                            if valLabel then
                                valLabel.Visible = false
                                valLabel.Text = ""
                            end
                        end
                    end
                end
            end
        end

        -- place total value of current trade offer parented to TheirOffer or YourOffer respectfully
        offerFrame.ClipsDescendants = false
        local totalLabel = offerFrame:FindFirstChild("TotalValueLabel")
        if isTradeOpen then
            if not totalLabel then
                totalLabel = Instance.new("TextLabel")
                totalLabel.Name = "TotalValueLabel"
                totalLabel.BackgroundTransparency = 1
                totalLabel.BorderSizePixel = 0
                totalLabel.Size = UDim2.new(0, 300, 0, 26)
                totalLabel.Position = UDim2.new(0.025, 0, 0.95, 3)
                totalLabel.ZIndex = (offerFrame.ZIndex or 1) + 20
                totalLabel.Font = Enum.Font.GothamBold
                totalLabel.TextSize = 18
                totalLabel.TextXAlignment = Enum.TextXAlignment.Left
                totalLabel.Parent = offerFrame
            end
            totalLabel.Visible = true
            totalLabel.BackgroundTransparency = 1
            totalLabel.Size = UDim2.new(0, 300, 0, 26)
            totalLabel.Position = UDim2.new(0.025, 0, 0.95, 3)
            totalLabel.TextSize = 18
            totalLabel.TextXAlignment = Enum.TextXAlignment.Left

            local totalStr
            if totalOfferVal > 0 then
                if hasUnknown then
                    totalStr = "Total Value: " .. formatValue(totalOfferVal) .. "+?"
                else
                    totalStr = "Total Value: " .. formatValue(totalOfferVal)
                end
            elseif hasUnknown then
                totalStr = "Total Value: ?"
            else
                totalStr = "Total Value: 0"
            end
            totalLabel.Text = totalStr
            applyRedGradient(totalLabel)
        elseif totalLabel then
            totalLabel.Visible = false
        end
    end

    processOffer(trade:FindFirstChild("YourOffer"))
    processOffer(trade:FindFirstChild("TheirOffer"))
end

-- ── ViewProfile value overlays ───────────────────────────────────────────────
local function updateViewProfileValues()
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not playerGui then return end
    local mainGui = playerGui:FindFirstChild("MainGUI")
    if not mainGui then return end
    local gameFrame = mainGui:FindFirstChild("Game")
    local vp = gameFrame and gameFrame:FindFirstChild("ViewProfile")
    if not vp or not vp.Visible then return end

    local mainFrame = vp:FindFirstChild("Main")
    local weapons   = mainFrame and mainFrame:FindFirstChild("Weapons")
    local items     = weapons and weapons:FindFirstChild("Items")
    if not items then return end

    local containerRoot = items:FindFirstChild("Container")
    if not containerRoot then return end

    local grandTotal = 0
    local hasUnknown = false

    local function scanVPContainer(parentCont)
        if not parentCont then return end
        for _, card in ipairs(parentCont:GetChildren()) do
            if card:IsA("GuiObject")
                and card.Name ~= "UIListLayout"
                and card.Name ~= "UIGridLayout"
                and card.Name ~= "UIPadding" then
                local nameObj = card:FindFirstChild("ItemName")
                local label   = nameObj and nameObj:FindFirstChild("Label")
                if label and label:IsA("TextLabel")
                    and label.Text ~= ""
                    and label.Text ~= "Item Name"
                    and label.Text ~= "Label" then
                    local skinName = label.Text:gsub("^%s+",""):gsub("%s+$","")
                    local amount   = 1
                    local cont     = card:FindFirstChild("Container")
                    local amountObj = cont and cont:FindFirstChild("Amount")
                    if amountObj and amountObj.Visible and amountObj.Text ~= "" then
                        local n = amountObj.Text:match("%d+")
                        if n then amount = tonumber(n) or 1 end
                    end
                    local iconObj  = cont and cont:FindFirstChild("Icon")
                    local rarity   = detectRarityFromColor(nameObj, card or cont)
                    local unitVal  = getMM2ItemValueWithIcon(skinName, rarity, iconObj)
                    local isDefault = skinName:lower():find("default")

                    local displayValText = nil
                    if unitVal and unitVal > 0 then
                        local itemTotal = unitVal * amount
                        grandTotal = grandTotal + itemTotal
                        displayValText = formatValue(itemTotal)
                    elseif not isDefault then
                        displayValText = "?"
                        hasUnknown = true
                    end

                    local oldCardBadge = card:FindFirstChild("VPValueLabel") or card:FindFirstChild("ItemValueLabel")
                    if oldCardBadge then oldCardBadge:Destroy() end

                    if cont then
                        cont.ClipsDescendants = false
                        card.ClipsDescendants = false
                        local badge = cont:FindFirstChild("ItemValueLabel")
                        if state.valueCalculatorEnabled and displayValText then
                            if not badge then
                                badge = Instance.new("TextLabel")
                                badge.Name = "ItemValueLabel"
                                badge.BackgroundTransparency = 1
                                badge.BorderSizePixel = 0
                                badge.Size = UDim2.new(0, 75, 0, 20)
                                badge.Position = UDim2.new(0.05, 0, 0, 3)
                                badge.ZIndex = (cont.ZIndex or 1) + 20
                                badge.Font = Enum.Font.GothamBold
                                badge.TextSize = 15
                                badge.TextXAlignment = Enum.TextXAlignment.Left
                                badge.Parent = cont
                            end
                            badge.Visible = true
                            badge.BackgroundTransparency = 1
                            badge.Size = UDim2.new(0, 75, 0, 20)
                            badge.Position = UDim2.new(0.05, 0, 0, 3)
                            badge.TextSize = 15
                            badge.TextXAlignment = Enum.TextXAlignment.Left
                            badge.Text = displayValText
                            applyRedGradient(badge)
                        elseif badge then
                            badge.Visible = false
                        end
                    end
                end
            end
        end
    end

    local classic = containerRoot:FindFirstChild("Classic")
    if classic then scanVPContainer(classic:FindFirstChild("Container")) end
    local current = containerRoot:FindFirstChild("Current")
    if current then scanVPContainer(current:FindFirstChild("Container")) end
    local holiday = containerRoot:FindFirstChild("Holiday")
    local holidayCont = holiday and holiday:FindFirstChild("Container")
    if holidayCont then
        scanVPContainer(holidayCont)
        local xmas = holidayCont:FindFirstChild("Christmas")
        if xmas then scanVPContainer(xmas:FindFirstChild("Container")) end
        local hall = holidayCont:FindFirstChild("Halloween")
        if hall then scanVPContainer(hall:FindFirstChild("Container")) end
        for _, sub in ipairs(holidayCont:GetChildren()) do
            if sub ~= xmas and sub ~= hall and sub:IsA("GuiObject") and sub.Name ~= "UIListLayout" and sub.Name ~= "UIPadding" and sub.Name ~= "UIGridLayout" then
                local subCont = sub:FindFirstChild("Container")
                if subCont then scanVPContainer(subCont) end
            end
        end
    end

    local oldVPTotal = (mainFrame and mainFrame:FindFirstChild("VPTotalValueLabel")) or (vp:FindFirstChild("VPTotalValueLabel"))
    if oldVPTotal then oldVPTotal:Destroy() end

    -- place total value in bottom left of:
    -- game:GetService("Players").LocalPlayer.PlayerGui.MainGUI.Game.ViewProfile.Main.Weapons.Items
    local totalLbl = items:FindFirstChild("VPTotalValueLabel")
    if state.valueCalculatorEnabled and vp.Visible and items.Visible then
        if not totalLbl then
            totalLbl = Instance.new("TextLabel")
            totalLbl.Name = "VPTotalValueLabel"
            totalLbl.BackgroundTransparency = 1
            totalLbl.BorderSizePixel = 0
            totalLbl.Size = UDim2.new(0, 350, 0, 28)
            totalLbl.AnchorPoint = Vector2.new(0, 1)
            totalLbl.Position = UDim2.new(0, 6, 1, -4)
            totalLbl.ZIndex = 100
            totalLbl.Font = Enum.Font.GothamBold
            totalLbl.TextSize = 20
            totalLbl.TextXAlignment = Enum.TextXAlignment.Left
            totalLbl.Parent = items
        end
        totalLbl.AnchorPoint = Vector2.new(0, 1)
        totalLbl.Position = UDim2.new(0, 6, 1, -4)
        totalLbl.Size = UDim2.new(0, 350, 0, 28)
        totalLbl.TextSize = 20
        totalLbl.Visible = true
        totalLbl.BackgroundTransparency = 1

        local totalStr
        if grandTotal > 0 then
            if hasUnknown then
                totalStr = "Total Value: " .. formatValue(grandTotal) .. "+?"
            else
                totalStr = "Total Value: " .. formatValue(grandTotal)
            end
        elseif hasUnknown then
            totalStr = "Total Value: ?"
        else
            totalStr = "Total Value: 0"
        end
        totalLbl.Text = totalStr
        applyRedGradient(totalLbl)
    elseif totalLbl then
        totalLbl.Visible = false
    end
end

-- ── TradeGUI item-selection panel values ─────────────────────────────────────
-- Covers both the Weapons panel and the Pets panel inside the trade screen.
local function updateTradeItemPanelValues()
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not playerGui then return end
    local tradeGui = playerGui:FindFirstChild("TradeGUI")
    if not tradeGui then return end
    local tradeContainer = tradeGui:FindFirstChild("Container")
    local itemsRoot = tradeContainer and tradeContainer:FindFirstChild("Items")
    if not itemsRoot or not itemsRoot.Visible then return end
    local mainPanel = itemsRoot:FindFirstChild("Main")
    if not mainPanel then return end

    local function scanPanelItems(panelFrame)
        if not panelFrame then return end
        local itemsFrame = panelFrame:FindFirstChild("Items")
        local contRoot   = itemsFrame and itemsFrame:FindFirstChild("Container")
        if not contRoot then return end

        local function scanFolder(folderCont)
            if not folderCont then return end
            for _, card in ipairs(folderCont:GetChildren()) do
                if card:IsA("GuiObject")
                    and card.Name ~= "UIListLayout"
                    and card.Name ~= "UIGridLayout"
                    and card.Name ~= "UIPadding" then
                    local nameObj  = card:FindFirstChild("ItemName")
                    local label    = nameObj and nameObj:FindFirstChild("Label")
                    local cardCont = card:FindFirstChild("Container")
                    local iconObj  = cardCont and cardCont:FindFirstChild("Icon")

                    if label and label:IsA("TextLabel")
                        and label.Text ~= ""
                        and label.Text ~= "Item Name"
                        and label.Text ~= "Label" then
                        local skinName = label.Text:gsub("^%s+",""):gsub("%s+$","")
                        local amount   = 1
                        local amountObj = cardCont and cardCont:FindFirstChild("Amount")
                        if amountObj and amountObj.Visible and amountObj.Text ~= "" then
                            local n = amountObj.Text:match("%d+")
                            if n then amount = tonumber(n) or 1 end
                        end
                        local rarity  = detectRarityFromColor(nameObj, card or cardCont)
                        local unitVal = getMM2ItemValueWithIcon(skinName, rarity, iconObj)
                        local isDefault = skinName:lower():find("default")

                        local oldCardBadge = card:FindFirstChild("TradePanelValueLabel") or card:FindFirstChild("ItemValueLabel")
                        if oldCardBadge then oldCardBadge:Destroy() end

                        local displayValText = nil
                        if unitVal and unitVal > 0 then
                            displayValText = formatValue(unitVal * amount)
                        elseif not isDefault then
                            displayValText = "?"
                        end

                        if cardCont then
                            cardCont.ClipsDescendants = false
                            card.ClipsDescendants = false
                            local badge = cardCont:FindFirstChild("ItemValueLabel")
                            if state.valueCalculatorEnabled and displayValText then
                                if not badge then
                                    badge = Instance.new("TextLabel")
                                    badge.Name = "ItemValueLabel"
                                    badge.BackgroundTransparency = 1
                                    badge.BorderSizePixel = 0
                                    badge.Size = UDim2.new(0, 75, 0, 20)
                                    badge.Position = UDim2.new(0.05, 0, 0, 3)
                                    badge.ZIndex = (cardCont.ZIndex or 1) + 20
                                    badge.Font = Enum.Font.GothamBold
                                    badge.TextSize = 15
                                    badge.TextXAlignment = Enum.TextXAlignment.Left
                                    badge.Parent = cardCont
                                end
                                badge.Visible = true
                                badge.BackgroundTransparency = 1
                                badge.Size = UDim2.new(0, 75, 0, 20)
                                badge.Position = UDim2.new(0.05, 0, 0, 3)
                                badge.TextSize = 15
                                badge.TextXAlignment = Enum.TextXAlignment.Left
                                badge.Text = displayValText
                                applyRedGradient(badge)
                            elseif badge then
                                badge.Visible = false
                            end
                        end
                    end
                end
            end
        end

        local current = contRoot:FindFirstChild("Current")
        if current then scanFolder(current:FindFirstChild("Container")) end
        local classic = contRoot:FindFirstChild("Classic")
        if classic then scanFolder(classic:FindFirstChild("Container")) end
        local holiday = contRoot:FindFirstChild("Holiday")
        if holiday then
            local hCont = holiday:FindFirstChild("Container")
            if hCont then
                scanFolder(hCont)
                for _, sub in ipairs(hCont:GetChildren()) do
                    if sub:IsA("GuiObject") and sub.Name ~= "UIListLayout" and sub.Name ~= "UIPadding" and sub.Name ~= "UIGridLayout" then
                        local sc = sub:FindFirstChild("Container")
                        if sc then scanFolder(sc) end
                    end
                end
            end
        end
    end

    scanPanelItems(mainPanel:FindFirstChild("Weapons"))
    scanPanelItems(mainPanel:FindFirstChild("Pets"))
end

local function updateInventoryValues()
    local playerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
    if not playerGui then return end
    local mainGui = playerGui:FindFirstChild("MainGUI")
    if not mainGui then return end
    local gameFrame = mainGui:FindFirstChild("Game")
    local inv = gameFrame and gameFrame:FindFirstChild("Inventory")
    if not inv or not inv.Visible then return end

    local mainFrame = inv:FindFirstChild("Main")
    local weapons = mainFrame and mainFrame:FindFirstChild("Weapons")
    local items = weapons and weapons:FindFirstChild("Items")
    if not items or not items.Visible then return end

    -- mm2 inventory gui hierarchy stores active weapon grid cards under Weapons.Items.Container
    local containerRoot = items:FindFirstChild("Container")
    if not containerRoot then return end

    local grandTotal = 0
    local hasUnknown = false

    local function scanCardContainer(parentCont)
        if not parentCont then return end
        for _, card in ipairs(parentCont:GetChildren()) do
            if card:IsA("GuiObject") and card.Name ~= "UIListLayout" and card.Name ~= "UIGridLayout" and card.Name ~= "UIPadding" then
                local nameObj = card:FindFirstChild("ItemName")
                local label = nameObj and nameObj:FindFirstChild("Label")
                if label and label:IsA("TextLabel") and label.Text ~= "" and label.Text ~= "Item Name" and label.Text ~= "Label" then
                    local skinName = label.Text:gsub("^%s+", ""):gsub("%s+$", "")
                    local amount = 1
                    local cont = card:FindFirstChild("Container")
                    local amountObj = cont and cont:FindFirstChild("Amount")
                    if amountObj and amountObj.Visible and amountObj.Text ~= "" then
                        local n = amountObj.Text:match("%d+")
                        if n then amount = tonumber(n) or 1 end
                    end

                    local iconObj = cont and cont:FindFirstChild("Icon")
                    local rarity = detectRarityFromColor(nameObj, card or cont)
                    local unitVal = getMM2ItemValueWithIcon(skinName, rarity, iconObj)
                    local isDefault = skinName:lower():find("default")

                    local displayValText = nil
                    if unitVal and unitVal > 0 then
                        local itemTotal = unitVal * amount
                        grandTotal = grandTotal + itemTotal
                        displayValText = formatValue(itemTotal)
                    elseif not isDefault then
                        displayValText = "?"
                        hasUnknown = true
                    end

                    local oldBadge = card:FindFirstChild("ItemValueLabel")
                    if oldBadge then oldBadge:Destroy() end

                    if cont then
                        cont.ClipsDescendants = false
                        card.ClipsDescendants = false
                        local badge = cont:FindFirstChild("ItemValueLabel")
                        if state.valueCalculatorEnabled and displayValText then
                            if not badge then
                                badge = Instance.new("TextLabel")
                                badge.Name = "ItemValueLabel"
                                badge.BackgroundTransparency = 1
                                badge.BorderSizePixel = 0
                                badge.Size = UDim2.new(0, 75, 0, 20)
                                badge.Position = UDim2.new(0.05, 0, 0, 3)
                                badge.ZIndex = (cont.ZIndex or 1) + 20
                                badge.Font = Enum.Font.GothamBold
                                badge.TextSize = 15
                                badge.TextXAlignment = Enum.TextXAlignment.Left
                                badge.Parent = cont
                            end
                            badge.Visible = true
                            badge.BackgroundTransparency = 1
                            badge.Size = UDim2.new(0, 75, 0, 20)
                            badge.Position = UDim2.new(0.05, 0, 0, 3)
                            badge.TextSize = 15
                            badge.TextXAlignment = Enum.TextXAlignment.Left
                            badge.Text = displayValText
                            applyRedGradient(badge)
                        elseif badge then
                            badge.Visible = false
                        end
                    end
                end
            end
        end
    end

    local classic = containerRoot:FindFirstChild("Classic")
    if classic then scanCardContainer(classic:FindFirstChild("Container")) end

    local current = containerRoot:FindFirstChild("Current")
    if current then scanCardContainer(current:FindFirstChild("Container")) end

    local holiday = containerRoot:FindFirstChild("Holiday")
    local holidayCont = holiday and holiday:FindFirstChild("Container")
    if holidayCont then
        scanCardContainer(holidayCont)
        local xmas = holidayCont:FindFirstChild("Christmas")
        if xmas then scanCardContainer(xmas:FindFirstChild("Container")) end
        local hall = holidayCont:FindFirstChild("Halloween")
        if hall then scanCardContainer(hall:FindFirstChild("Container")) end
        for _, sub in ipairs(holidayCont:GetChildren()) do
            if sub ~= xmas and sub ~= hall and sub:IsA("GuiObject") and sub.Name ~= "UIListLayout" and sub.Name ~= "UIPadding" and sub.Name ~= "UIGridLayout" then
                local subCont = sub:FindFirstChild("Container")
                if subCont then scanCardContainer(subCont) end
            end
        end
    end

    local oldInsideItems = (mainFrame and mainFrame:FindFirstChild("TotalInventoryValueLabel")) or (inv:FindFirstChild("TotalInventoryValueLabel"))
    if oldInsideItems then oldInsideItems:Destroy() end

    -- place total value of own inventory in bottom left of:
    -- game:GetService("Players").LocalPlayer.PlayerGui.MainGUI.Game.Inventory.Main.Weapons.Items
    local totalInvLabel = items:FindFirstChild("TotalInventoryValueLabel")
    if state.valueCalculatorEnabled and items.Visible and inv.Visible then
        if not totalInvLabel then
            totalInvLabel = Instance.new("TextLabel")
            totalInvLabel.Name = "TotalInventoryValueLabel"
            totalInvLabel.BackgroundTransparency = 1
            totalInvLabel.BorderSizePixel = 0
            totalInvLabel.Size = UDim2.new(0, 350, 0, 28)
            totalInvLabel.AnchorPoint = Vector2.new(0, 1)
            totalInvLabel.Position = UDim2.new(0, 6, 1, -4)
            totalInvLabel.ZIndex = 100
            totalInvLabel.Font = Enum.Font.GothamBold
            totalInvLabel.TextSize = 20
            totalInvLabel.TextXAlignment = Enum.TextXAlignment.Left
            totalInvLabel.Parent = items
        end
        totalInvLabel.AnchorPoint = Vector2.new(0, 1)
        totalInvLabel.Position = UDim2.new(0, 6, 1, -4)
        totalInvLabel.Size = UDim2.new(0, 350, 0, 28)
        totalInvLabel.TextSize = 20
        totalInvLabel.Visible = true
        totalInvLabel.BackgroundTransparency = 1

        local totalStr
        if grandTotal > 0 then
            if hasUnknown then
                totalStr = "Total Value: " .. formatValue(grandTotal) .. "+?"
            else
                totalStr = "Total Value: " .. formatValue(grandTotal)
            end
        elseif hasUnknown then
            totalStr = "Total Value: ?"
        else
            totalStr = "Total Value: 0"
        end
        totalInvLabel.Text = totalStr
        applyRedGradient(totalInvLabel)
    elseif totalInvLabel then
        totalInvLabel.Visible = false
    end
end

trackThread(task.spawn(function()
    while not state.unloaded do
        if state.valueCalculatorEnabled then
            pcall(updateTradeValues)
            pcall(updateInventoryValues)
            pcall(updateViewProfileValues)
            pcall(updateTradeItemPanelValues)
            task.wait(0.25)
        else
            task.wait(1.5)
        end
    end
end))


local function toKeyCode(k)
    if typeof(k) == "EnumItem" and k.EnumType == Enum.KeyCode then
        return k
    elseif type(k) == "string" then
        local name = k:gsub("^Enum%.KeyCode%.", ""):gsub("%s+", "")
        local ok, res = pcall(function() return Enum.KeyCode[name] end)
        if ok and typeof(res) == "EnumItem" then return res end
    end
    return nil
end






local function _buildScriptUI()

    -- load external tab adapter module from github to decouple layout structure
    local mdTabs
    pcall(function()
        local url = "https://raw.githubusercontent.com/rilorfakesilly/scripts/refs/heads/main/modules/tab_adapter.lua"
        local ok, raw = pcall(function() return game:HttpGet(url) end)
        if not ok or not raw or raw:find("404: Not Found") then
            url = "https://raw.githubusercontent.com/rilorfakesilly/scripts/refs/heads/main/tab_adapter.lua"
            raw = game:HttpGet(url)
        end
        local adapter = loadstring(raw)()
        if type(adapter) == "table" and type(adapter.createTabs) == "function" then
            mdTabs = adapter.createTabs(Window)
        end
    end)

    if not mdTabs then
        mdTabs = {
            Main       = Window:CreateTab("Main", 1, "home"),
            Autofarm   = Window:CreateTab("Autofarm", 3, "coins"),
            Player     = Window:CreateTab("Player", 5, "user"),
            Murderer   = Window:CreateTab("Murderer", 7, "skull"),
            Sheriff    = Window:CreateTab("Sheriff", 9, "shield"),
            Sounds     = Window:CreateTab("Sounds", 11, "volume-2"),
            Visuals    = Window:CreateTab("Visuals", 13, "eye"),
            Animations = Window:CreateTab("Animations", 15, "activity"),
            World      = Window:CreateTab("World", 17, "globe"),
            Camera     = Window:CreateTab("Camera", 19, "camera"),
            Webhook    = Window:CreateTab("Webhook", 21, "send"),
            Settings   = (Window.GetSettingsTab and Window:GetSettingsTab()) or Window.SettingsTab or Window:CreateTab("Settings", 999, "settings"),
        }

    end

    -- construct main overview controls
    mdTabs.Main:AddWelcomeHeader()

    mdTabs.Main:AddButtonRow({
        { Text = "Rejoin server", Icon = "rotate-ccw", Callback = function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end },
        { Text = "Server hop",    Icon = "shuffle",    Callback = function() serverHop() end },
        { Text = "Kill character",Icon = "skull",      Callback = function() if LocalPlayer.Character then LocalPlayer.Character:BreakJoints() end end }
    }, 31)

    local function createTabAdapter(rawTab)
        local adapter = {
            RawTab = rawTab,
            AddSection = function(self, title, isFullWidth)
                if rawTab and rawTab.AddSection then
                    local sec = rawTab:AddSection(title, isFullWidth)
                    self._currentSection = sec
                    self._sectionContainer = sec and sec.Container or nil
                    return sec
                elseif rawTab and rawTab.AddLabel then
                    return rawTab:AddLabel(title)
                end
                return self
            end,
            AddLabel = function(self, textOrConfig, options)
                if rawTab and rawTab.AddLabel then
                    return rawTab:AddLabel(textOrConfig, options)
                end
                return self
            end,
            AddDivider = function(self, options)
                if rawTab and rawTab.AddDivider then
                    return rawTab:AddDivider(options)
                end
                return self
            end,
            AddToggle = function(self, id, cfg)
                local title = cfg.Title or id
                local defaultVal = (cfg.Default ~= nil) and cfg.Default or false
                local cb = cfg.Callback
                local bindVal = cfg.Bind or cfg.DefaultBind

                local sliderCfg = nil
                if cfg.Slider and type(cfg.Slider) == "table" then
                    sliderCfg = {}
                    for k, v in pairs(cfg.Slider) do sliderCfg[k] = v end
                    local slId = sliderCfg.Id or sliderCfg.id or sliderCfg.SaveKey or sliderCfg.saveKey or (id .. "Volume") or (id .. "_Slider") or sliderCfg.Title
                    sliderCfg.Id = slId
                    sliderCfg.SaveKey = slId
                    sliderCfg.Identifier = slId
                end

                local toggleObj = rawTab:AddToggle({
                    Name = title,
                    Title = title,
                    SaveKey = cfg.SaveKey or cfg.Id or id,
                    Identifier = cfg.Identifier or id,
                    Id = cfg.Id or id,
                    Default = defaultVal,
                    DefaultBind = bindVal,
                    Connect = cfg.Connect,
                    Slider = sliderCfg,
                    Parent = self._sectionContainer or self._currentSection,
                    Callback = function(v)
                        if Options[id] then
                            Options[id].Value = v
                            if Options[id]._callback then
                                Options[id]._callback(v)
                            end
                        elseif cb then
                            cb(v)
                        end
                    end
                })
                if Window and Window.SearchableItems and #Window.SearchableItems > 0 then
                    local lastItem = Window.SearchableItems[#Window.SearchableItems]
                    if lastItem and (lastItem.Type == "Toggle" or lastItem.Instance == (toggleObj and toggleObj.Frame)) then
                        lastItem.Name = title
                        lastItem.Id = id
                    end
                end

                local wrapper = {
                    Value = defaultVal,
                    Element = toggleObj,
                    _callback = cb,
                    SetValue = function(s, v, trigger)
                        s.Value = v
                        pcall(function()
                            if toggleObj and toggleObj.SetState then
                                toggleObj.SetState(v, trigger ~= false)
                            end
                        end)
                    end,
                    GetValue = function(s)
                        return (toggleObj and toggleObj.GetState) and toggleObj.GetState() or s.Value
                    end,
                    OnChanged = function(s, callback)
                        s._callback = callback
                        return s
                    end
                }
                Options[id] = wrapper

                if sliderCfg and toggleObj and toggleObj.ConnectedSlider then
                    local slId = sliderCfg.Id
                    local slElem = toggleObj.ConnectedSlider
                    local slWrapper = {
                        Value = (slElem.GetValue and slElem:GetValue()) or sliderCfg.Default,
                        Element = slElem,
                        SetValue = function(s, v, trigger)
                            s.Value = v
                            pcall(function()
                                if slElem and slElem.SetValue then
                                    slElem:SetValue(v, trigger ~= false)
                                end
                            end)
                        end,
                        GetValue = function(s)
                            return (slElem and slElem.GetValue) and slElem:GetValue() or s.Value
                        end,
                        OnChanged = function(s, callback)
                            s._callback = callback
                            return s
                        end
                    }
                    if slId then Options[slId] = slWrapper end
                    Options[id .. "Volume"] = slWrapper
                    Options[id .. "_Slider"] = slWrapper
                end

                return wrapper
            end,
            AddCheckbox = function(self, id, cfg)
                local title = cfg.Title or id
                local defaultVal = (cfg.Default ~= nil) and cfg.Default or false
                local cb = cfg.Callback

                local checkboxObj = rawTab:AddCheckbox({
                    Name = title,
                    Title = title,
                    SaveKey = cfg.SaveKey or cfg.Id or id,
                    Identifier = cfg.Identifier or id,
                    Id = cfg.Id or id,
                    Default = defaultVal,
                    Parent = self._sectionContainer or self._currentSection,
                    Callback = function(v)
                        if Options[id] then
                            Options[id].Value = v
                            if Options[id]._callback then
                                Options[id]._callback(v)
                            end
                        elseif cb then
                            cb(v)
                        end
                    end
                })
                if Window and Window.SearchableItems and #Window.SearchableItems > 0 then
                    local lastItem = Window.SearchableItems[#Window.SearchableItems]
                    if lastItem and (lastItem.Type == "Checkbox" or lastItem.Instance == (checkboxObj and checkboxObj.Frame)) then
                        lastItem.Name = title
                        lastItem.Id = id
                    end
                end

                local wrapper = {
                    Value = defaultVal,
                    Element = checkboxObj,
                    _callback = cb,
                    SetValue = function(s, v, trigger)
                        s.Value = v
                        pcall(function()
                            if checkboxObj and checkboxObj.SetState then
                                checkboxObj:SetState(v, trigger ~= false)
                            end
                        end)
                    end,
                    GetValue = function(s)
                        return (checkboxObj and checkboxObj.GetState) and checkboxObj:GetState() or s.Value
                    end,
                    OnChanged = function(s, callback)
                        s._callback = callback
                        return s
                    end
                }
                Options[id] = wrapper
                return wrapper
            end,
            AddSlider = function(self, id, cfg)
                local title = cfg.Title or id
                local minVal = cfg.Min or 0
                local maxVal = cfg.Max or 100
                local defVal = (cfg.Default ~= nil) and cfg.Default or minVal
                local cb = cfg.Callback

                local sliderCfg = {}
                for k, v in pairs(cfg) do
                    sliderCfg[k] = v
                end
                sliderCfg.Title = title
                sliderCfg.Min = minVal
                sliderCfg.Max = maxVal
                sliderCfg.Default = defVal
                sliderCfg.SaveKey = cfg.SaveKey or cfg.Id or id
                sliderCfg.Identifier = cfg.Identifier or id
                sliderCfg.Id = cfg.Id or id
                sliderCfg.Parent = self._sectionContainer or self._currentSection
                sliderCfg.Callback = function(v, pct)
                    if Options[id] then
                        Options[id].Value = v
                        if Options[id]._callback then
                            Options[id]._callback(v, pct)
                        end
                    elseif cb then
                        cb(v, pct)
                    end
                end

                local sliderObj = rawTab:AddSlider(sliderCfg, self._sectionContainer or self._currentSection)
                if Window and Window.SearchableItems and #Window.SearchableItems > 0 then
                    local lastItem = Window.SearchableItems[#Window.SearchableItems]
                    if lastItem and (lastItem.Type == "Slider" or (sliderObj and (lastItem.Instance == sliderObj.CardFrame or lastItem.Instance == sliderObj.Track))) then
                        lastItem.Name = title
                        lastItem.Id = id
                    end
                end

                local wrapper = {
                    Value = defVal,
                    Element = sliderObj,
                    _callback = cb,
                    SetValue = function(s, v, trigger)
                        s.Value = v
                        pcall(function()
                            if sliderObj and sliderObj.SetValue then
                                sliderObj.SetValue(v, trigger ~= false)
                            end
                        end)
                    end,
                    GetValue = function(s)
                        return (sliderObj and sliderObj.GetValue) and sliderObj.GetValue() or s.Value
                    end,
                    OnChanged = function(s, callback)
                        s._callback = callback
                        return s
                    end
                }
                Options[id] = wrapper
                return wrapper
            end,
            AddDropdown = function(self, id, cfg)
                local title = cfg.Title or id
                local optionsList = cfg.Values or cfg.Options or {}
                local defVal = cfg.Default or (optionsList[1] or "")
                local cb = cfg.Callback

                local dropCfg = {
                    Title = title,
                    Options = optionsList,
                    Values = optionsList,
                    Default = defVal,
                    SaveKey = cfg.SaveKey or cfg.Id or id,
                    Identifier = cfg.Identifier or id,
                    Id = cfg.Id or id,
                    Parent = self._sectionContainer or self._currentSection,
                    Callback = function(selected)
                        if Options[id] then
                            Options[id].Value = selected
                            if Options[id]._callback then
                                Options[id]._callback(selected)
                            end
                        elseif cb then
                            cb(selected)
                        end
                    end
                }

                local dropObj = rawTab:AddDropdown(dropCfg, optionsList, defVal, dropCfg.Callback, self._sectionContainer or self._currentSection, nil, nil, dropCfg)
                if Window and Window.SearchableItems and #Window.SearchableItems > 0 then
                    local lastItem = Window.SearchableItems[#Window.SearchableItems]
                    if lastItem and (lastItem.Type == "Dropdown" or lastItem.Instance == (dropObj and dropObj.Frame)) then
                        lastItem.Name = title
                        lastItem.Id = id
                    end
                end

                local wrapper = {
                    Value = defVal,
                    Options = optionsList,
                    Element = dropObj,
                    _callback = cb,
                    SetValue = function(s, v, trigger)
                        s.Value = v
                        pcall(function()
                            if dropObj and dropObj.SetSelected then
                                dropObj.SetSelected(v, trigger ~= false)
                            end
                        end)
                    end,
                    SetValues = function(s, newOpts)
                        s.Options = newOpts
                        pcall(function()
                            if dropObj and dropObj.RefreshOptions then
                                dropObj.RefreshOptions(newOpts)
                            end
                        end)
                    end,
                    RefreshOptions = function(s, newOpts)
                        s.Options = newOpts
                        pcall(function()
                            if dropObj and dropObj.RefreshOptions then
                                dropObj.RefreshOptions(newOpts)
                            end
                        end)
                    end,
                    GetValue = function(s)
                        return (dropObj and dropObj.GetSelected) and dropObj.GetSelected() or s.Value
                    end,
                    OnChanged = function(s, callback)
                        s._callback = callback
                        return s
                    end
                }
                Options[id] = wrapper
                return wrapper
            end,
            AddInput = function(self, id, cfg)
                local title = cfg.Title or id
                local placeholder = cfg.Placeholder or ""
                local defVal = (cfg.Default ~= nil) and tostring(cfg.Default) or ""
                local cb = cfg.Callback

                local boxCfg = {
                    Title = title,
                    Placeholder = placeholder,
                    Default = defVal,
                    SaveKey = cfg.SaveKey or cfg.Id or id,
                    Identifier = cfg.Identifier or id,
                    Id = cfg.Id or id,
                    Parent = self._sectionContainer or self._currentSection,
                    Callback = function(text, enter)
                        if Options[id] then
                            Options[id].Value = text
                            if Options[id]._callback then
                                Options[id]._callback(text, enter)
                            end
                        elseif cb then
                            cb(text, enter)
                        end
                    end
                }

                local boxObj = rawTab:AddTextbox(boxCfg, placeholder, defVal, boxCfg.Callback, self._sectionContainer or self._currentSection, nil, nil, boxCfg)
                if Window and Window.SearchableItems and #Window.SearchableItems > 0 then
                    local lastItem = Window.SearchableItems[#Window.SearchableItems]
                    if lastItem and (lastItem.Type == "Textbox" or lastItem.Instance == (boxObj and boxObj.Frame)) then
                        lastItem.Name = title
                        lastItem.Id = id
                    end
                end

                local wrapper = {
                    Value = defVal,
                    Element = boxObj,
                    _callback = cb,
                    SetValue = function(s, v)
                        s.Value = tostring(v or "")
                        pcall(function()
                            if boxObj and boxObj.SetText then
                                boxObj.SetText(s.Value)
                            end
                        end)
                    end,
                    SetText = function(s, v)
                        s.Value = tostring(v or "")
                        pcall(function()
                            if boxObj and boxObj.SetText then
                                boxObj.SetText(s.Value)
                            end
                        end)
                    end,
                    GetValue = function(s)
                        return (boxObj and boxObj.GetText) and boxObj.GetText() or s.Value
                    end,
                    OnChanged = function(s, callback)
                        s._callback = callback
                        return s
                    end
                }
                Options[id] = wrapper
                return wrapper
            end,
            AddTextInput = function(self, id, cfg)
                if type(id) == "table" and cfg == nil then
                    cfg = id
                    id = cfg.Title or cfg.Name or "Input"
                end
                return self:AddInput(id, cfg)
            end,
            AddTextbox = function(self, id, cfg)
                if type(id) == "table" and cfg == nil then
                    cfg = id
                    id = cfg.Title or cfg.Name or "Input"
                end
                return self:AddInput(id, cfg)
            end,
            AddColorpicker = function(self, id, cfg)
                local title = cfg.Title or id
                local defVal = cfg.Default or Color3.fromRGB(255, 255, 255)
                local cb = cfg.Callback

                local cpCfg = {
                    Title = title,
                    Default = defVal,
                    SaveKey = cfg.SaveKey or cfg.Id or id,
                    Identifier = cfg.Identifier or id,
                    Id = cfg.Id or id,
                    Parent = self._sectionContainer or self._currentSection,
                    Callback = function(newCol)
                        if Options[id] then
                            Options[id].Value = newCol
                            if Options[id]._callback then
                                Options[id]._callback(newCol)
                            end
                        elseif cb then
                            cb(newCol)
                        end
                    end
                }

                local cpObj = rawTab:AddColorPicker(cpCfg, defVal, cpCfg.Callback, self._sectionContainer or self._currentSection, nil, nil, id)
                if Window and Window.SearchableItems and #Window.SearchableItems > 0 then
                    local lastItem = Window.SearchableItems[#Window.SearchableItems]
                    if lastItem and (lastItem.Type == "Color picker" or lastItem.Instance == (cpObj and cpObj.Frame)) then
                        lastItem.Name = title
                        lastItem.Id = id
                    end
                end

                local wrapper = {
                    Value = defVal,
                    Element = cpObj,
                    _callback = cb,
                    SetValue = function(s, v, trigger)
                        s.Value = v
                        pcall(function()
                            if cpObj and cpObj.SetColor then
                                cpObj.SetColor(v, trigger ~= false)
                            end
                        end)
                    end,
                    SetColor = function(s, v, trigger)
                        s.Value = v
                        pcall(function()
                            if cpObj and cpObj.SetColor then
                                cpObj.SetColor(v, trigger ~= false)
                            end
                        end)
                    end,
                    GetValue = function(s)
                        return (cpObj and cpObj.GetColor) and cpObj.GetColor() or s.Value
                    end,
                    OnChanged = function(s, callback)
                        s._callback = callback
                        return s
                    end
                }
                Options[id] = wrapper
                return wrapper
            end,
            AddColorPicker = function(self, id, cfg, ...)
                if type(id) == "string" and type(cfg) == "table" then
                    return self:AddColorpicker(id, cfg)
                elseif rawTab and rawTab.AddColorPicker then
                    return rawTab:AddColorPicker(id, cfg, ...)
                end
                return self:AddColorpicker(id, cfg)
            end,
            AddButton = function(self, cfg)
                local title = cfg.Title or cfg.Text or "Button"
                local cb = cfg.Callback
                local target = cfg.Parent or self._sectionContainer or self._currentSection
                local icon = cfg.Icon or cfg.icon or cfg.IconAsset

                local btnObj = rawTab:AddLongButton(title, function()
                    if cb then cb() end
                end, cfg.Size or 1.0, target, nil, icon, cfg.ShowArrow)
                return btnObj
            end,
            AddButtonRow = function(self, buttonList, height, parentRow)
                if not rawTab or not rawTab.AddButtonRow then return end
                local target = parentRow or self._sectionContainer or self._currentSection
                return rawTab:AddButtonRow(buttonList, height or 24, target)
            end,
            AddRow = function(self, height, padding, parentRow)
                if not rawTab or not rawTab.AddRow then return end
                local target = parentRow or self._sectionContainer or self._currentSection
                return rawTab:AddRow(height, padding, target)
            end,
            AddKeybind = function(self, id, cfg)
                local title = cfg.Title or id
                local defVal = cfg.Default or Enum.KeyCode.Unknown
                local cb = cfg.Callback

                local wrapper = {
                    Value = defVal,
                    _callback = cb,
                    SetValue = function(s, v)
                        s.Value = v
                        if s._callback then s._callback(v) end
                    end,
                    OnChanged = function(s, callback)
                        s._callback = callback
                        return s
                    end
                }
                Options[id] = wrapper
                return wrapper
            end,
            AddGroup = function(self, itemList, direction)
                if not rawTab or not rawTab.AddGroup then return {} end
                local dir = direction or "Vertical"
                local isHoriz = (dir == "Horizontal" or dir == "horizontal" or dir == "H" or dir == "h")
                local wrappedList = {}
                local origCallbacks = {}
                for i, item in ipairs(itemList) do
                    local it = {}
                    for k, v in pairs(item) do it[k] = v end
                    if not isHoriz and it.Fraction == nil and it.Size == nil then
                        it.Fraction = 1.0
                    end
                    local opts = it.Values or it.values or it.Options or it.options
                    if opts and not it.Options then
                        it.Options = opts
                    end
                    local id = it.Id or it.id or it.Identifier or it.identifier or it.SaveKey or it.saveKey or it.Title or it.Name
                    if id then
                        it.Id = id
                        it.SaveKey = it.SaveKey or id
                        it.Identifier = it.Identifier or id
                    end
                    if type(it.Slider) == "table" then
                        local sl = {}
                        for sk, sv in pairs(it.Slider) do sl[sk] = sv end
                        local slId = sl.Id or sl.id or sl.SaveKey or sl.saveKey or sl.Identifier or sl.identifier or (id and (id .. "Volume")) or (id and (id .. "_Slider")) or sl.Title
                        if slId then
                            sl.Id = slId
                            sl.SaveKey = sl.SaveKey or slId
                            sl.Identifier = sl.Identifier or slId
                        end
                        it.Slider = sl
                    end
                    local origCb = it.Callback or it.callback or it.OnChanged or it.OnSelect
                    origCallbacks[i] = origCb
                    if id then
                        it.Callback = function(...)
                            local arg1 = ...
                            if Options[id] then
                                Options[id].Value = arg1
                                if Options[id]._callback then
                                    Options[id]._callback(...)
                                end
                            elseif origCb then
                                origCb(...)
                            end
                        end
                    end
                    table.insert(wrappedList, it)
                end

                local results = rawTab:AddGroup(wrappedList, dir, self._sectionContainer or self._currentSection)
                for i, item in ipairs(wrappedList) do
                    local id = item.Id or item.id or item.Title or item.Name
                    if id and results[i] then
                        local elem = results[i]
                        local itemOpts = item.Values or item.values or item.Options or item.options
                        local defVal = (item.Default ~= nil) and item.Default or (itemOpts and itemOpts[1]) or false
                        local origCb = origCallbacks[i]
                        local wrapper = {
                            Value = defVal,
                            Options = itemOpts or {},
                            Element = elem,
                            _callback = origCb,
                            SetValue = function(s, v, trigger)
                                s.Value = v
                                pcall(function()
                                    if elem.SetState then elem:SetState(v, trigger ~= false)
                                    elseif elem.SetValue then elem:SetValue(v, trigger ~= false)
                                    elseif elem.SetSelected then elem:SetSelected(v, trigger ~= false)
                                    elseif elem.SetColor then elem:SetColor(v, trigger ~= false)
                                    elseif elem.SetText then elem:SetText(v) end
                                end)
                            end,
                            GetValue = function(s)
                                if elem.GetState then return elem:GetState()
                                elseif elem.GetValue then return elem:GetValue()
                                elseif elem.GetSelected then return elem:GetSelected()
                                elseif elem.GetColor then return elem:GetColor()
                                elseif elem.GetText then return elem:GetText() end
                                return s.Value
                            end,
                            SetValues = function(s, newOpts)
                                s.Options = newOpts
                                pcall(function()
                                    if elem.SetOptions then elem:SetOptions(newOpts)
                                    elseif elem.SetValues then elem:SetValues(newOpts)
                                    elseif elem.RefreshOptions then elem.RefreshOptions(newOpts) end
                                end)
                            end,
                            RefreshOptions = function(s, newOpts)
                                s.Options = newOpts
                                pcall(function()
                                    if elem.SetOptions then elem:SetOptions(newOpts)
                                    elseif elem.SetValues then elem:SetValues(newOpts)
                                    elseif elem.RefreshOptions then elem.RefreshOptions(newOpts) end
                                end)
                            end,
                            OnChanged = function(s, callback)
                                s._callback = callback
                                return s
                            end
                        }
                        Options[id] = wrapper
                        if item.Id then Options[item.Id] = wrapper end
                        if item.SaveKey then Options[item.SaveKey] = wrapper end

                        local slElem = elem.ConnectedSlider or (elem.Element and elem.Element.ConnectedSlider)
                        if slElem or (item.Slider and type(item.Slider) == "table") then
                            local slCfg = type(item.Slider) == "table" and item.Slider or {}
                            local slId = slCfg.Id or slCfg.SaveKey or (id .. "Volume")
                            local slDef = slCfg.Default or (slElem and slElem.GetValue and slElem:GetValue()) or 100
                            local slCb = slCfg.Callback or slCfg.callback or slCfg.OnChanged
                            local slWrapper = {
                                Value = slDef,
                                Element = slElem,
                                _callback = slCb,
                                SetValue = function(s, v, trigger)
                                    s.Value = v
                                    pcall(function()
                                        if slElem and slElem.SetValue then
                                            slElem:SetValue(v, trigger ~= false)
                                        end
                                    end)
                                end,
                                GetValue = function(s)
                                    return (slElem and slElem.GetValue) and slElem:GetValue() or s.Value
                                end,
                                OnChanged = function(s, callback)
                                    s._callback = callback
                                    return s
                                end
                            }
                            if slId then Options[slId] = slWrapper end
                            Options[id .. "Volume"] = slWrapper
                            Options[id .. "_Slider"] = slWrapper
                            if slCfg.Title then Options[slCfg.Title] = slWrapper end
                        end
                    end
                end
                return results
            end,
            AddToggleGroup = function(self, toggleList)
                if not rawTab or not rawTab.AddToggleGroup then return {} end
                local wrappedList = {}
                local origCallbacks = {}
                for i, item in ipairs(toggleList) do
                    local it = {}
                    for k, v in pairs(item) do it[k] = v end
                    local id = it.Id or it.id or it.Identifier or it.identifier or it.SaveKey or it.saveKey or it.Title or it.Name
                    if id then
                        it.Id = id
                        it.SaveKey = it.SaveKey or id
                        it.Identifier = it.Identifier or id
                    end
                    if type(it.Slider) == "table" then
                        local sl = {}
                        for sk, sv in pairs(it.Slider) do sl[sk] = sv end
                        local slId = sl.Id or sl.id or sl.SaveKey or sl.saveKey or sl.Identifier or sl.identifier or (id and (id .. "Volume")) or (id and (id .. "_Slider")) or sl.Title
                        if slId then
                            sl.Id = slId
                            sl.SaveKey = sl.SaveKey or slId
                            sl.Identifier = sl.Identifier or slId
                        end
                        it.Slider = sl
                    end
                    local origCb = it.Callback or it.callback
                    origCallbacks[i] = origCb
                    if id then
                        it.Callback = function(...)
                            local arg1 = ...
                            if Options[id] then
                                Options[id].Value = arg1
                                if Options[id]._callback then
                                    Options[id]._callback(...)
                                end
                            elseif origCb then
                                origCb(...)
                            end
                        end
                    end
                    table.insert(wrappedList, it)
                end

                local results = rawTab:AddToggleGroup(wrappedList, self._sectionContainer or self._currentSection)
                for i, item in ipairs(wrappedList) do
                    local id = item.Id or item.id or item.Title or item.Name
                    if id and results[i] then
                        local elem = results[i]
                        local defVal = (item.Default ~= nil) and item.Default or false
                        local origCb = origCallbacks[i]
                        local wrapper = {
                            Value = defVal,
                            Element = elem,
                            _callback = origCb,
                            SetValue = function(s, v, trigger)
                                s.Value = v
                                pcall(function()
                                    if elem.SetState then elem:SetState(v, trigger ~= false) end
                                end)
                            end,
                            GetValue = function(s)
                                if elem.GetState then return elem:GetState() end
                                return s.Value
                            end,
                            OnChanged = function(s, callback)
                                s._callback = callback
                                return s
                            end
                        }
                        Options[id] = wrapper
                        if item.Id then Options[item.Id] = wrapper end
                        if item.SaveKey then Options[item.SaveKey] = wrapper end

                        local slElem = elem.ConnectedSlider or (elem.Element and elem.Element.ConnectedSlider)
                        if slElem or (item.Slider and type(item.Slider) == "table") then
                            local slCfg = type(item.Slider) == "table" and item.Slider or {}
                            local slId = slCfg.Id or slCfg.SaveKey or (id .. "Volume")
                            local slDef = slCfg.Default or (slElem and slElem.GetValue and slElem:GetValue()) or 100
                            local slCb = slCfg.Callback or slCfg.callback or slCfg.OnChanged
                            local slWrapper = {
                                Value = slDef,
                                Element = slElem,
                                _callback = slCb,
                                SetValue = function(s, v, trigger)
                                    s.Value = v
                                    pcall(function()
                                        if slElem and slElem.SetValue then
                                            slElem:SetValue(v, trigger ~= false)
                                        end
                                    end)
                                end,
                                GetValue = function(s)
                                    return (slElem and slElem.GetValue) and slElem:GetValue() or s.Value
                                end,
                                OnChanged = function(s, callback)
                                    s._callback = callback
                                    return s
                                end
                            }
                            if slId then Options[slId] = slWrapper end
                            Options[id .. "Volume"] = slWrapper
                            Options[id .. "_Slider"] = slWrapper
                            if slCfg.Title then Options[slCfg.Title] = slWrapper end
                        end
                    end
                end
                return results
            end,
            AddImageGrid = function(self, cfg, container)
                local target = container or self._sectionContainer or self._currentSection
                if rawTab and rawTab.AddImageGrid then
                    return rawTab:AddImageGrid(cfg, target)
                end
                return nil
            end,
            AddGallery = function(self, cfg, container)
                return self:AddImageGrid(cfg, container)
            end
        }
        setmetatable(adapter, {
            __index = function(t, k)
                if rawTab and rawTab[k] then
                    return function(self, ...)
                        return rawTab[k](rawTab, ...)
                    end
                end
                return nil
            end
        })
        return adapter
    end

    local function createRoutedTabAdapter(rawTab, subTabConfig)
        if not rawTab or not rawTab.AddSubTabs then
            return createTabAdapter(rawTab)
        end

        local defaultName = subTabConfig.Default or subTabConfig.Names[1]
        local subTabsObj = rawTab:AddSubTabs(subTabConfig.Names, defaultName)
        local adapters = {}
        for _, name in ipairs(subTabConfig.Names) do
            local subObj = subTabsObj:Get(name)
            adapters[name] = createTabAdapter(subObj)
        end

        local router = {
            RawTab = rawTab,
            SubTabsObj = subTabsObj,
            SubAdapters = adapters,
            _activeAdapter = adapters[defaultName],
            _activeSubName = defaultName,

            AddSection = function(self, title, isFullWidth)
                local targetSubName = (subTabConfig.Routes and subTabConfig.Routes[title]) or subTabConfig.Default or subTabConfig.Names[1]
                local targetAdapter = adapters[targetSubName] or self._activeAdapter
                self._activeAdapter = targetAdapter
                self._activeSubName = targetSubName
                local sec = targetAdapter:AddSection(title, isFullWidth)
                self._currentSection = targetAdapter._currentSection
                self._sectionContainer = targetAdapter._sectionContainer
                return sec
            end
        }

        setmetatable(router, {
            __index = function(t, k)
                local active = rawget(t, "_activeAdapter")
                if active and active[k] then
                    return function(self, ...)
                        local res = active[k](active, ...)
                        rawset(t, "_currentSection", active._currentSection)
                        rawset(t, "_sectionContainer", active._sectionContainer)
                        if res == active then return t end
                        return res
                    end
                elseif rawTab and rawTab[k] then
                    return function(self, ...)
                        return rawTab[k](rawTab, ...)
                    end
                end
                return nil
            end
        })

        return router
    end

    local Tabs = {
        Main       = createTabAdapter(mdTabs.Main),
        Autofarm   = createTabAdapter(mdTabs.Autofarm),
        Player     = createRoutedTabAdapter(mdTabs.Player, {
            Names = { "Movement", "Aim & combat" },
            Default = "Movement",
            Routes = {
                ["Movement"] = "Movement",
                ["Utility"] = "Movement",
                ["Silent aim"] = "Aim & combat",
                ["Camlock"] = "Aim & combat",
                ["Target"] = "Aim & combat",
            }
        }),
        Murderer   = createTabAdapter(mdTabs.Murderer),
        Sheriff    = createTabAdapter(mdTabs.Sheriff),
        Sounds     = createTabAdapter(mdTabs.Sounds),
        Visuals    = createRoutedTabAdapter(mdTabs.Visuals, {
            Names = { "ESP", "Cosmetics", "Effects" },
            Default = "ESP",
            Routes = {
                ["Player esp"] = "ESP",
                ["Value calculator"] = "ESP",
                ["Body stuff"] = "Cosmetics",
                ["China hat"] = "Cosmetics",
                ["Neon wings"] = "Cosmetics",
                ["Trail"] = "Cosmetics",
                ["Orb"] = "Cosmetics",
                ["Jump ring"] = "Cosmetics",
                ["Spinbot"] = "Cosmetics",
                ["Crosshair"] = "Effects",
                ["Gun ray"] = "Effects",
                ["Color animation"] = "Effects",
            }
        }),
        Animations = createTabAdapter(mdTabs.Animations),
        World      = createTabAdapter(mdTabs.World),
        Camera     = createTabAdapter(mdTabs.Camera),
        Webhook    = createTabAdapter(mdTabs.Webhook),
        Settings   = createTabAdapter(mdTabs.Settings),
    }

    -- construct main tab map voting controls
    Tabs.Main:AddSection("Map voting", true)

    local function getVotePadsFolder()
        local lobby = workspace:FindFirstChild("Lobby")
        if not lobby then return nil end
        return lobby:FindFirstChild("VotePads")
    end

    local function extractMapImage(iconObj)
        if not iconObj then return "" end
        if iconObj:IsA("ImageLabel") or iconObj:IsA("ImageButton") then
            if iconObj.Image and iconObj.Image ~= "" then return iconObj.Image end
        end
        if iconObj:IsA("Decal") or iconObj:IsA("Texture") then
            if iconObj.Texture and iconObj.Texture ~= "" then return iconObj.Texture end
        end
        local subImg = iconObj:FindFirstChildWhichIsA("ImageLabel", true)
        if subImg and subImg.Image and subImg.Image ~= "" then
            return subImg.Image
        end
        local subDecal = iconObj:FindFirstChildWhichIsA("Decal", true)
        if subDecal and subDecal.Texture and subDecal.Texture ~= "" then
            return subDecal.Texture
        end
        local s, val = pcall(function() return iconObj.Image end)
        if s and type(val) == "string" and val ~= "" then
            return val
        end
        local s2, val2 = pcall(function() return iconObj.Texture end)
        if s2 and type(val2) == "string" and val2 ~= "" then
            return val2
        end
        return ""
    end

    local function getVotePadDetails(padIndex)
        local padsFolder = getVotePadsFolder()
        local padModel = padsFolder and padsFolder:FindFirstChild("VotePad" .. tostring(padIndex))
        local mapName = "Map " .. tostring(padIndex)
        local mapImage = ""
        local padPart = nil

        if padModel then
            padPart = padModel:FindFirstChild("Pad")
            local vig = padModel:FindFirstChild("VoteInfoGui")
            local container = vig and vig:FindFirstChild("Container")
            local nameLabel = container and container:FindFirstChild("MapName")
            if nameLabel and nameLabel:IsA("TextLabel") and nameLabel.Text and nameLabel.Text ~= "" then
                mapName = nameLabel.Text
            elseif vig then
                local fallback = vig:FindFirstChild("MapName", true)
                if fallback and fallback:IsA("TextLabel") and fallback.Text and fallback.Text ~= "" then
                    mapName = fallback.Text
                end
            end

            local mig = padModel:FindFirstChild("MapInfoGui")
            local iconObj = mig and mig:FindFirstChild("MapIcon")
            if iconObj then
                mapImage = extractMapImage(iconObj)
            end
        end

        return {
            Index = padIndex,
            Name = mapName,
            Image = mapImage,
            PadPart = padPart,
            Model = padModel
        }
    end

    local function isVoteMapIconGone(padIndex)
        local padsFolder = getVotePadsFolder()
        if not padsFolder or not padsFolder.Parent then
            return true
        end
        local padModel = padsFolder:FindFirstChild("VotePad" .. tostring(padIndex))
        if not padModel or not padModel.Parent then
            return true
        end
        local mig = padModel:FindFirstChild("MapInfoGui")
        if not mig or not mig.Parent then
            return true
        end
        if mig:IsA("LayerCollector") and not mig.Enabled then
            return true
        end
        local iconObj = mig:FindFirstChild("MapIcon")
        if not iconObj or not iconObj.Parent then
            return true
        end
        if iconObj:IsA("GuiObject") and not iconObj.Visible then
            return true
        end
        local img = extractMapImage(iconObj)
        if img == "" then
            if iconObj:IsA("ImageLabel") or iconObj:IsA("ImageButton") or iconObj:FindFirstChildWhichIsA("ImageLabel", true) then
                return true
            end
        end
        return false
    end

    local function teleportInsidePad(padPart)
        if not padPart or not padPart:IsA("BasePart") then return false end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return false end

        hrp.CFrame = padPart.CFrame * CFrame.new(0, 1.0, 0)
        pcall(function()
            hrp.AssemblyLinearVelocity = Vector3.zero
            hrp.AssemblyAngularVelocity = Vector3.zero
        end)

        if typeof(firetouchinterest) == "function" then
            pcall(function()
                firetouchinterest(hrp, padPart, 0)
                task.wait(0.04)
                firetouchinterest(hrp, padPart, 1)
            end)
        end
        return true
    end

    local function resetPlayerCharacter()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.Health = 0
        end
        pcall(function()
            char:BreakJoints()
        end)
    end

    local function waitForCharacterRespawn(oldChar, timeout)
        local startT = tick()
        timeout = timeout or 10

        while tick() - startT < timeout do
            local c = LocalPlayer.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            if not c or c ~= oldChar or not h or h.Health <= 0 then
                break
            end
            task.wait(0.05)
        end

        while tick() - startT < timeout do
            local c = LocalPlayer.Character
            local h = c and c:FindFirstChildOfClass("Humanoid")
            local hrp = c and c:FindFirstChild("HumanoidRootPart")
            if (c ~= oldChar or (h and h.Health > 0 and tick() - startT > 1.0)) and hrp and h and h.Health > 0 then
                task.wait(0.15)
                return c
            end
            task.wait(0.05)
        end

        return LocalPlayer.Character
    end

    local function getMapGridItems()
        local items = {}
        for i = 1, 3 do
            local det = getVotePadDetails(i)
            table.insert(items, {
                Name = det.Name,
                Image = det.Image ~= "" and det.Image or "rbxassetid://6034287525",
                PadIndex = i
            })
        end
        return items
    end

    local initialMapItems = getMapGridItems()
    local mapGrid = Tabs.Main:AddImageGrid({
        Title = "Choose map",
        Columns = 3,
        Items = initialMapItems,
        Default = initialMapItems[1] and initialMapItems[1].Name,
        Callback = function(item)
            if type(item) == "table" and item.PadIndex then
                state.autoVotePadIndex = item.PadIndex
            end
        end
    })

    local autoVoteBtn = nil

    autoVoteBtn = Tabs.Main:AddButton({
        Title = "Start dupe voting",
        Icon = "play",
        Callback = function()
            if state.autoVoteRunning then
                state.autoVoteRunning = false
                if autoVoteBtn and autoVoteBtn.SetText then
                    autoVoteBtn:SetText("Start dupe voting")
                    autoVoteBtn:SetIcon("play")
                end
                Window:Notify("Map voting", "Dupe voting stopped", 2)
                return
            end

            local chosenPad = state.autoVotePadIndex or 1
            if isVoteMapIconGone(chosenPad) then
                Window:Notify("Map voting", "Map voting is not active right now!", 2.5)
                return
            end

            state.autoVoteRunning = true
            if autoVoteBtn and autoVoteBtn.SetText then
                autoVoteBtn:SetText("Stop dupe voting")
                autoVoteBtn:SetIcon("square")
            end
            Window:Notify("Map voting", "Dupe voting started for map " .. tostring(chosenPad), 2)

            task.spawn(function()
                while state.autoVoteRunning and not (state and state.unloaded) do
                    local currentPad = state.autoVotePadIndex or 1
                    if isVoteMapIconGone(currentPad) then
                        log("Auto vote stopped: Voting ended or map icon is gone.")
                        Window:Notify("Map voting", "Voting ended (map icon is gone)", 3)
                        break
                    end

                    local padDetails = getVotePadDetails(currentPad)
                    local padPart = padDetails.PadPart
                    if not padPart then
                        task.wait(0.5)
                        continue
                    end

                    local char = LocalPlayer.Character
                    local hum = char and char:FindFirstChildOfClass("Humanoid")
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")

                    if char and hum and hrp and hum.Health > 0 then
                        teleportInsidePad(padPart)
                        task.wait(0.2)

                        if not state.autoVoteRunning or isVoteMapIconGone(currentPad) then
                            break
                        end

                        local oldChar = LocalPlayer.Character
                        resetPlayerCharacter()
                        waitForCharacterRespawn(oldChar, 10)
                    else
                        task.wait(0.2)
                    end

                    task.wait(0.1)
                end

                state.autoVoteRunning = false
                if autoVoteBtn and autoVoteBtn.SetText then
                    autoVoteBtn:SetText("Start dupe voting")
                    autoVoteBtn:SetIcon("play")
                end
            end)
        end
    })

    -- Background watcher to dynamically update map thumbnails & names during voting phase
    task.spawn(function()
        local lastSignature = ""
        while not (state and state.unloaded) do
            local p1 = getVotePadDetails(1)
            local p2 = getVotePadDetails(2)
            local p3 = getVotePadDetails(3)
            local sig = string.format("%s|%s|%s|%s|%s|%s", p1.Name, p1.Image, p2.Name, p2.Image, p3.Name, p3.Image)
            if sig ~= lastSignature then
                lastSignature = sig
                if mapGrid and mapGrid.SetItems then
                    local updatedItems = {
                        { Name = p1.Name, Image = p1.Image ~= "" and p1.Image or "rbxassetid://6034287525", PadIndex = 1 },
                        { Name = p2.Name, Image = p2.Image ~= "" and p2.Image or "rbxassetid://6034287525", PadIndex = 2 },
                        { Name = p3.Name, Image = p3.Image ~= "" and p3.Image or "rbxassetid://6034287525", PadIndex = 3 },
                    }
                    mapGrid:SetItems(updatedItems)
                    local currIndex = state.autoVotePadIndex or 1
                    if updatedItems[currIndex] and mapGrid.SetSelected then
                        mapGrid:SetSelected(updatedItems[currIndex].Name)
                    end
                end
            end
            task.wait(1.5)
        end
    end)

    -- construct automated farming controls
    Tabs.Autofarm:AddSection("Farm")

    Tabs.Autofarm:AddToggle("AutofarmEnabled", {
        Title = "Autofarm",
        Default = false,
        Slider = {
            Title = "Tween speed",
            Min = 5,
            Max = 25,
            Default = 22,
            Increment = 0.5,
            Rounding = 1,
            Suffix = " studs/s",
            Callback = function(val)
                state.autofarmTweenSpeed = val
            end
        },
        Callback = function(v)
            state.autofarmEnabled = v
            if v then
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    state.autofarmSavedCFrame = hrp.CFrame
                end

                state.tweenRoundTeleported = false
                state.hasTeleportedToLobby = false
                state.roundsPassed = 0
                state.totalCoinsFarmed = 0
                state.startTime = tick()
                state.lastWebhookSent = tick()
                state.currentTaskStatus = "Starting..."
                log("Autofarm Started (" .. state.autofarmMode .. ")")

            else
                state.currentTaskStatus = "Stopped"
                log("Autofarm Stopped")
                stopAllMovement()
                stopTween()
                -- restore player position after disabling farm
                if state.autofarmSavedCFrame then
                    local char = LocalPlayer.Character
                    local hrp = char and char:FindFirstChild("HumanoidRootPart")
                    if hrp then
                        pcall(function()
                            hrp.Anchored = false
                            hrp.CFrame = state.autofarmSavedCFrame
                            hrp.AssemblyLinearVelocity = Vector3.zero
                            hrp.AssemblyAngularVelocity = Vector3.zero
                        end)
                    end
                    state.autofarmSavedCFrame = nil
                end
            end
        end
    })

    Tabs.Autofarm:AddDropdown("AutofarmMode", {
        Title = "Autofarm mode",
        Values = {"Coin", "Wins", "Teleport (unreliable)"},
        Default = "Coin",
        Callback = function(v)
            state.autofarmMode = v
            log("Autofarm mode set to: " .. v)
        end
    })

    Tabs.Autofarm:AddDropdown("AfterFarmAction", {
        Title = "After farm",
        Values = {"Farm exp", "End round", "Reset"},
        Default = "Farm exp",
        Callback = function(val)
            state.afterFarmAction = val
            state.roundEndFling = (val == "End round")
            log("After farm action: " .. val)
        end
    })

    Tabs.Autofarm:AddToggle("AvoidMurderer", {
        Title = "Avoid murderer",
        Default = false,
        Slider = {
            Title = "Avoid distance",
            Min = 10,
            Max = 80,
            Default = 35,
            Suffix = " studs",
            Callback = function(v) state.avoidDistance = v end
        },
        Callback = function(v) state.avoidMurderer = v end
    })

    Tabs.Autofarm:AddSection("Auto open crates")
    Tabs.Autofarm:AddToggle("AutoOpenCratesEnabled", {
        Title = "Auto open crates",
        Default = false,
        Callback = function(v)
            state.autoOpenCratesEnabled = v
            log("Auto open crates: " .. (v and "Enabled" or "Disabled"))
        end
    })

    Tabs.Autofarm:AddDropdown("SelectedCrateType", {
        Title = "Crate box type",
        Values = {"MysteryBox1", "MysteryBox2", "KnifeBox1", "KnifeBox2", "KnifeBox3", "KnifeBox4", "KnifeBox5", "GunBox1", "GunBox2", "GunBox3"},
        Default = "MysteryBox1",
        Callback = function(v)
            state.selectedCrateType = v
        end
    })

    Tabs.Autofarm:AddSection("Auto server hop")

    Tabs.Autofarm:AddToggle("AutoServerHopEnabled", {
        Title = "Auto server hop",
        Default = false,
        Slider = {
            Title = "Hop timer",
            Min = 1,
            Max = 60,
            Default = 15,
            Increment = 1,
            Rounding = 0,
            Suffix = " min",
            Callback = function(val)
                state.autoServerHopIntervalMin = val
            end
        },
        Callback = function(v)
            state.autoServerHopEnabled = v
            state.lastServerHopTimer = tick()
            log("Auto server hop: " .. (v and ("Enabled (" .. tostring(state.autoServerHopIntervalMin or 15) .. " min)") or "Disabled"))
        end
    })

    Tabs.Autofarm:AddToggle("AutoServerHopWaitForRound", {
        Title = "Wait for round end",
        Default = true,
        Callback = function(v)
            state.autoServerHopWaitForRound = v
        end
    })



    -- construct decorative china hat geometry 
    local chinaHatConfig = {
        enabled = false,
        followHead = false,
        colorMode = "Normal",
        color1 = Color3.fromRGB(255, 0, 100),
        color2 = Color3.fromRGB(0, 200, 255),
        color = Color3.fromRGB(255, 0, 100),
        transparency = 0.3,
        alwaysOnTop = false,
        selfOnly = true,
        height = 0.6,
        radius = 1.2,
        heightOffset = 2.0
    }

    local chinaHatAdornments = {}
    local chinaHatConnections = {}
    local chinaHatPlayerAddedConn = nil
    local chinaHatPlayerRemovingConn = nil
    local HAT_ROT_CF = CFrame.Angles(math.rad(90), 0, 0)

    local function getHatColor()
        local color = getColor(chinaHatConfig.colorMode, chinaHatConfig.color1, chinaHatConfig.color2)
        if color.R <= 0.005 and color.G <= 0.005 and color.B <= 0.005 then
            return Color3.fromRGB(1, 1, 1)
        end
        return color
    end

    local function getHatCFrame(char, hrp)
        if chinaHatConfig.followHead and char and hrp then
            local head = char:FindFirstChild("Head")
            if head then
                local targetWorldPos = Vector3.new(head.Position.X, hrp.Position.Y + chinaHatConfig.heightOffset, head.Position.Z)
                local localPos = hrp.CFrame:PointToObjectSpace(targetWorldPos)
                return CFrame.new(localPos) * HAT_ROT_CF
            end
        end
        return CFrame.new(0, chinaHatConfig.heightOffset, 0) * HAT_ROT_CF
    end

    local function removeHat(player, char)
        chinaHatAdornments[player] = nil
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if hrp then
            local adornment = hrp:FindFirstChild("ChinaHat")
            if adornment then pcall(function() adornment:Destroy() end) end
        end
    end

    local function applyHat(player, char)
        if not chinaHatConfig.enabled then return end
        if not char then return end
        local hrp = char:WaitForChild("HumanoidRootPart", 5) or char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end
    
        local existing = hrp:FindFirstChild("ChinaHat")
        if existing then pcall(function() existing:Destroy() end) end
    
        if not chinaHatConfig.enabled then return end

        local adornment = Instance.new("ConeHandleAdornment")
        adornment.Name = "ChinaHat"
        adornment.Height = chinaHatConfig.height
        adornment.Radius = chinaHatConfig.radius
        adornment.Transparency = chinaHatConfig.transparency
        adornment.AlwaysOnTop = chinaHatConfig.alwaysOnTop
        adornment.Adornee = hrp
        adornment.CFrame = getHatCFrame(char, hrp)
        adornment.Parent = hrp
        adornment.Color3 = getHatColor()

        chinaHatAdornments[player] = adornment
    end

    local function setupHatForPlayer(player)
        if chinaHatConnections[player] then
            pcall(function() chinaHatConnections[player]:Disconnect() end)
            chinaHatConnections[player] = nil
        end
        local function onCharAdded(char)
            if chinaHatConfig.enabled then
                if player == LocalPlayer or not chinaHatConfig.selfOnly then
                    applyHat(player, char)
                end
            else
                removeHat(player, char)
            end
        end
        if player.Character and chinaHatConfig.enabled then
            if player == LocalPlayer or not chinaHatConfig.selfOnly then
                applyHat(player, player.Character)
            end
        end
        chinaHatConnections[player] = player.CharacterAdded:Connect(onCharAdded)
    end

    local function removeHatForPlayer(player)
        if chinaHatConnections[player] then
            pcall(function() chinaHatConnections[player]:Disconnect() end)
            chinaHatConnections[player] = nil
        end
        chinaHatAdornments[player] = nil
        if player.Character then
            removeHat(player, player.Character)
        end
    end

    local function updateHatColors()
        if not chinaHatConfig.enabled then return end
        local mainColor = getHatColor()

        for _, plr in ipairs(Players:GetPlayers()) do
            if plr.Character then
                local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
                if hrp then
                    local hat = hrp:FindFirstChild("ChinaHat")
                    if hat then hat.Color3 = mainColor end
                end
            end
        end
    end

    local function updateHatProps()
        if not chinaHatConfig.enabled then return end
        local color = getHatColor()
        local function applyProps(player, char)
            if not char then return end
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local adornment = hrp and hrp:FindFirstChild("ChinaHat")
            if adornment then
                adornment.Color3 = color
                adornment.Transparency = chinaHatConfig.transparency
                adornment.AlwaysOnTop = chinaHatConfig.alwaysOnTop
                adornment.Height = chinaHatConfig.height
                adornment.Radius = chinaHatConfig.radius
                adornment.CFrame = getHatCFrame(char, hrp)
            end
        end
    
        if LocalPlayer.Character then applyProps(LocalPlayer, LocalPlayer.Character) end
        for _, p in pairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character then
                if not chinaHatConfig.selfOnly then
                    applyProps(p, p.Character)
                else
                    removeHat(p, p.Character)
                end
            end
        end
    end

    local function updateHatPositions()
        if not (chinaHatConfig.enabled and chinaHatConfig.followHead) then return end
        for plr, adornment in pairs(chinaHatAdornments) do
            if adornment and adornment.Parent then
                local char = plr.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    adornment.CFrame = getHatCFrame(char, hrp)
                end
            else
                chinaHatAdornments[plr] = nil
            end
        end
    end

    local function stopChinaHat()
        chinaHatConfig.enabled = false
        if chinaHatPlayerAddedConn then
            pcall(function() chinaHatPlayerAddedConn:Disconnect() end)
            chinaHatPlayerAddedConn = nil
        end
        if chinaHatPlayerRemovingConn then
            pcall(function() chinaHatPlayerRemovingConn:Disconnect() end)
            chinaHatPlayerRemovingConn = nil
        end
        for p, conn in pairs(chinaHatConnections) do
            if conn then pcall(function() conn:Disconnect() end) end
            if p and p.Character then removeHat(p, p.Character) end
        end
        chinaHatConnections = {}
        chinaHatAdornments = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then removeHat(p, p.Character) end
        end
    end

    local function startChinaHat()
        stopChinaHat()
        chinaHatConfig.enabled = true
        if chinaHatConfig.selfOnly then
            setupHatForPlayer(LocalPlayer)
            if LocalPlayer.Character then applyHat(LocalPlayer, LocalPlayer.Character) end
        else
            for _, p in pairs(Players:GetPlayers()) do
                setupHatForPlayer(p)
                if p.Character then applyHat(p, p.Character) end
            end
            chinaHatPlayerAddedConn = Players.PlayerAdded:Connect(setupHatForPlayer)
            chinaHatPlayerRemovingConn = Players.PlayerRemoving:Connect(removeHatForPlayer)
        end
    end

    trackConnection(Players.PlayerRemoving:Connect(function(plr)
        removeHatForPlayer(plr)
    end))

    registerCleanupHook(function()
        stopChinaHat()
    end)

    -- construct cosmetic wing meshes 
    local wingsConfig = {
        enabled = false,
        colorMode = "Normal",
        color1 = Color3.fromRGB(0, 255, 170),
        color2 = Color3.fromRGB(170, 0, 255),
        color = Color3.fromRGB(0, 255, 170),
        transparency = 0.55,
        glow = 1.28,
        speed = 3.5,
        size = 0.59,
        posX = 1.41,
        posY = 2.12,
        posZ = 1.41,
        selfOnly = true
    }

    local wingsParts = {}
    local wingsConnections = {}
    local wingsPlayerAddedConn = nil
    local wingsPlayerRemovingConn = nil

    local function removeWings(player, char)
        if wingsParts[player] then
            local w = wingsParts[player]
            if w.left then pcall(function() w.left:Destroy() end) end
            if w.right then pcall(function() w.right:Destroy() end) end
            wingsParts[player] = nil
        end
        if char then
            local lw = char:FindFirstChild("_LeftWing") or char:FindFirstChild("LeftWing")
            if lw then pcall(function() lw:Destroy() end) end
            local rw = char:FindFirstChild("_RightWing") or char:FindFirstChild("RightWing")
            if rw then pcall(function() rw:Destroy() end) end
        end
    end

    local function applyWings(player, char)
        if not wingsConfig.enabled then return end
        if not char then return end
        local root = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
        if not root then
            root = char:WaitForChild("UpperTorso", 4)
                or char:WaitForChild("Torso", 2)
                or char:WaitForChild("HumanoidRootPart", 4)
        end
        if not root or not char.Parent then return end

        removeWings(player, char)

        if not wingsConfig.enabled then return end

        local curColor = getColor(wingsConfig.colorMode, wingsConfig.color1, wingsConfig.color2)
        local curGlow = wingsConfig.glow or 1.28

        local leftPart = Instance.new("Part")
        leftPart.Name = "LeftWing"
        leftPart.Size = Vector3.new(1, 1, 1)
        leftPart.CanCollide = false
        leftPart.CanQuery = false
        leftPart.CanTouch = false
        leftPart.Anchored = true
        leftPart.Material = Enum.Material.Neon
        leftPart.Color = curColor
        leftPart.Transparency = wingsConfig.transparency
        leftPart.Parent = char

        local leftMesh = Instance.new("SpecialMesh")
        leftMesh.MeshType = Enum.MeshType.FileMesh
        leftMesh.MeshId = "rbxassetid://125496490342257"
        leftMesh.TextureId = ""
        leftMesh.Scale = Vector3.new(wingsConfig.size, wingsConfig.size, wingsConfig.size)
        leftMesh.Parent = leftPart

        local lightL = Instance.new("PointLight")
        lightL.Name = "WingLight"
        lightL.Color = curColor
        lightL.Range = 8
        lightL.Brightness = curGlow
        lightL.Enabled = curGlow > 0
        lightL.Parent = leftPart

        local rightPart = Instance.new("Part")
        rightPart.Name = "RightWing"
        rightPart.Size = Vector3.new(1, 1, 1)
        rightPart.CanCollide = false
        rightPart.CanQuery = false
        rightPart.CanTouch = false
        rightPart.Anchored = true
        rightPart.Material = Enum.Material.Neon
        rightPart.Color = curColor
        rightPart.Transparency = wingsConfig.transparency
        rightPart.Parent = char

        local rightMesh = Instance.new("SpecialMesh")
        rightMesh.MeshType = Enum.MeshType.FileMesh
        rightMesh.MeshId = "rbxassetid://127905516694871"
        rightMesh.TextureId = ""
        rightMesh.Scale = Vector3.new(wingsConfig.size, wingsConfig.size, wingsConfig.size)
        rightMesh.Parent = rightPart

        local lightR = Instance.new("PointLight")
        lightR.Name = "WingLight"
        lightR.Color = curColor
        lightR.Range = 8
        lightR.Brightness = curGlow
        lightR.Enabled = curGlow > 0
        lightR.Parent = rightPart

        local function createFeatherEmitter(parentPart)
            local pe = Instance.new("ParticleEmitter")
            pe.Name = "FeatherEmitter"
            pe.Texture = "http://www.roblox.com/asset/?id=87991277160964"
            pe.Rate = 1.2
            pe.Speed = NumberRange.new(0.3, 0.75)
            pe.VelocityInheritance = 0.05
            pe.Acceleration = Vector3.new(0, -0.75, 0)
            pe.Drag = 1.2
            pe.Lifetime = NumberRange.new(5.0, 7.0)
            pe.Rotation = NumberRange.new(0, 360)
            pe.RotSpeed = NumberRange.new(-70, 70)
            local glowRatio = curGlow / 2.14
            pe.LightEmission = math.clamp(0.71 * glowRatio, 0, 1)
            pe.LightInfluence = 0.0
            pe.Size = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.4),
                NumberSequenceKeypoint.new(0.8, 0.4),
                NumberSequenceKeypoint.new(1, 0)
            })
            pe.Transparency = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.1),
                NumberSequenceKeypoint.new(0.8, 0.3),
                NumberSequenceKeypoint.new(1, 1)
            })
            pe.Color = ColorSequence.new(curColor)
            pe.Parent = parentPart
            return pe
        end

        local emitterL = createFeatherEmitter(leftPart)
        local emitterR = createFeatherEmitter(rightPart)

        wingsParts[player] = {
            left = leftPart,
            right = rightPart,
            emitterL = emitterL,
            emitterR = emitterR,
            lightL = lightL,
            lightR = lightR
        }
    end

    local function setupWingsForPlayer(player)
        if wingsConnections[player] then
            pcall(function() wingsConnections[player]:Disconnect() end)
            wingsConnections[player] = nil
        end
        local function onCharAdded(char)
            task.spawn(function()
                if not char then return end
                local root = char:WaitForChild("UpperTorso", 5)
                    or char:WaitForChild("Torso", 2)
                    or char:WaitForChild("HumanoidRootPart", 5)
                if not root or not char.Parent then return end

                if wingsConfig.enabled then
                    if player == LocalPlayer or not wingsConfig.selfOnly then
                        applyWings(player, char)
                    end
                else
                    removeWings(player, char)
                end
            end)
        end
        if player.Character and wingsConfig.enabled then
            if player == LocalPlayer or not wingsConfig.selfOnly then
                task.spawn(applyWings, player, player.Character)
            end
        end
        wingsConnections[player] = player.CharacterAdded:Connect(onCharAdded)
    end

    local function removeWingsForPlayer(player)
        if wingsConnections[player] then
            pcall(function() wingsConnections[player]:Disconnect() end)
            wingsConnections[player] = nil
        end
        if wingsParts[player] then
            local w = wingsParts[player]
            if w.left then pcall(function() w.left:Destroy() end) end
            if w.right then pcall(function() w.right:Destroy() end) end
            wingsParts[player] = nil
        end
        if player.Character then
            removeWings(player, player.Character)
        end
    end

    local function stopWings()
        wingsConfig.enabled = false
        if wingsPlayerAddedConn then
            pcall(function() wingsPlayerAddedConn:Disconnect() end)
            wingsPlayerAddedConn = nil
        end
        if wingsPlayerRemovingConn then
            pcall(function() wingsPlayerRemovingConn:Disconnect() end)
            wingsPlayerRemovingConn = nil
        end
        for p, conn in pairs(wingsConnections) do
            if conn then pcall(function() conn:Disconnect() end) end
            if p and p.Character then removeWings(p, p.Character) end
        end
        wingsConnections = {}
        wingsParts = {}
        for _, p in pairs(Players:GetPlayers()) do
            if p.Character then removeWings(p, p.Character) end
        end
    end

    local function startWings()
        stopWings()
        wingsConfig.enabled = true
        if wingsConfig.selfOnly then
            setupWingsForPlayer(LocalPlayer)
            if LocalPlayer.Character then applyWings(LocalPlayer, LocalPlayer.Character) end
        else
            for _, p in pairs(Players:GetPlayers()) do
                setupWingsForPlayer(p)
                if p.Character then applyWings(p, p.Character) end
            end
            wingsPlayerAddedConn = Players.PlayerAdded:Connect(setupWingsForPlayer)
            wingsPlayerRemovingConn = Players.PlayerRemoving:Connect(removeWingsForPlayer)
        end
    end

    local function updateWingsGlow(val)
        wingsConfig.glow = val
        local glowRatio = (val or 1.28) / 2.14
        for _, w in pairs(wingsParts) do
            if w.lightL then
                w.lightL.Brightness = val
                w.lightL.Enabled = val > 0
            end
            if w.lightR then
                w.lightR.Brightness = val
                w.lightR.Enabled = val > 0
            end
            if w.emitterL then
                w.emitterL.LightEmission = math.clamp(0.71 * glowRatio, 0, 1)
            end
            if w.emitterR then
                w.emitterR.LightEmission = math.clamp(0.71 * glowRatio, 0, 1)
            end
        end
    end

    local function updateWings()
        if not wingsConfig.enabled then return end
        local curColor = getColor(wingsConfig.colorMode, wingsConfig.color1, wingsConfig.color2)
        local curGlow = wingsConfig.glow or 1.28
        local glowRatio = curGlow / 2.14
        for player, w in pairs(wingsParts) do
            if w.left and w.left.Parent then
                w.left.Color = curColor
                w.left.Transparency = wingsConfig.transparency
                if w.emitterL then
                    w.emitterL.Color = ColorSequence.new(curColor)
                    w.emitterL.LightEmission = math.clamp(0.71 * glowRatio, 0, 1)
                end
                if w.lightL then
                    w.lightL.Color = curColor
                    w.lightL.Brightness = curGlow
                    w.lightL.Enabled = curGlow > 0
                end
            end
            if w.right and w.right.Parent then
                w.right.Color = curColor
                w.right.Transparency = wingsConfig.transparency
                if w.emitterR then
                    w.emitterR.Color = ColorSequence.new(curColor)
                    w.emitterR.LightEmission = math.clamp(0.71 * glowRatio, 0, 1)
                end
                if w.lightR then
                    w.lightR.Color = curColor
                    w.lightR.Brightness = curGlow
                    w.lightR.Enabled = curGlow > 0
                end
            end
        end
    end

    trackConnection(Players.PlayerRemoving:Connect(function(plr)
        removeWingsForPlayer(plr)
    end))

    registerCleanupHook(function()
        stopWings()
    end)

    -- rotate character to disrupt incoming aim 
    spinbotConn = nil
    local function stopSpinbot()
        if spinbotConn then
            spinbotConn:Disconnect()
            spinbotConn = nil
        end
    end
    local function startSpinbot()
        stopSpinbot()
        spinbotConn = RunService.Heartbeat:Connect(function()
            pcall(function()
                local char = LocalPlayer.Character
                local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                if not hrp then return end
                hrp.CFrame = hrp.CFrame * CFrame.Angles(0, math.rad(state.spinbotSpeed or 30), 0)
            end)
        end)
    end

    local spinbotMonitorThread = task.spawn(function()
        while not state.unloaded do
            if state.spinbotEnabled and not spinbotConn then
                startSpinbot()
            elseif not state.spinbotEnabled and spinbotConn then
                stopSpinbot()
            end
            task.wait(0.5)
        end
    end)
    trackThread(spinbotMonitorThread)

    -- override default character movement animations
    local customAnimationConfig = {
        enabled = false,
        preset = "Mage",
        customPackId = "",
    }

    local animIdCache = {}

    local function extractTrueAnimationId(rawAssetId)
        local numId = tostring(rawAssetId or ""):match("%d+")
        if not numId or numId == "" then return rawAssetId end
        if animIdCache[numId] then
            return animIdCache[numId]
        end

        local foundId = nil
        local ok1, objs = pcall(function()
            return game:GetObjects("rbxassetid://" .. numId)
        end)
        if ok1 and objs and #objs > 0 then
            for _, rootObj in ipairs(objs) do
                for _, desc in ipairs(rootObj:GetDescendants()) do
                    if desc:IsA("Animation") and desc.AnimationId and desc.AnimationId ~= "" then
                        foundId = desc.AnimationId
                        break
                    end
                end
                if not foundId and rootObj:IsA("Animation") and rootObj.AnimationId ~= "" then
                    foundId = rootObj.AnimationId
                end
                if foundId then break end
            end
            for _, rootObj in ipairs(objs) do
                pcall(function() rootObj:Destroy() end)
            end
        end

        if not foundId then
            local ok2, model = pcall(function()
                return game:GetService("InsertService"):LoadAsset(tonumber(numId))
            end)
            if ok2 and model then
                for _, desc in ipairs(model:GetDescendants()) do
                    if desc:IsA("Animation") and desc.AnimationId and desc.AnimationId ~= "" then
                        foundId = desc.AnimationId
                        break
                    end
                end
                if not foundId and model:IsA("Animation") and model.AnimationId ~= "" then
                    foundId = model.AnimationId
                end
                pcall(function() model:Destroy() end)
            end
        end

        if foundId and foundId ~= "" then
            animIdCache[numId] = foundId
            return foundId
        end

        animIdCache[numId] = "rbxassetid://" .. numId
        return "rbxassetid://" .. numId
    end

    local presetAnimationPacks = {
        ["Mage"] = {
            id = "63",
            anims = {
                idle = "rbxassetid://10921144709",
                walk = "rbxassetid://10921152678",
                run = "rbxassetid://10921148209",
                jump = "rbxassetid://10921149743",
                fall = "rbxassetid://10921148939",
                climb = "rbxassetid://10921143404",
                swim = "rbxassetid://10921150788",
            }
        },
        ["Vampire"] = {
            id = "33",
            anims = {
                idle = "rbxassetid://10921315373",
                walk = "rbxassetid://10921326949",
                run = "rbxassetid://10921320299",
                jump = "rbxassetid://10921322186",
                fall = "rbxassetid://10921321317",
                climb = "rbxassetid://10921314188",
                swim = "rbxassetid://10921324408",
            }
        },
        ["Zombie"] = {
            id = "80",
            anims = {
                idle = "rbxassetid://10921344533",
                walk = "rbxassetid://10921355261",
                run = "rbxassetid://616163682",
                jump = "rbxassetid://10921351278",
                fall = "rbxassetid://10921350320",
                climb = "rbxassetid://10921343576",
                swim = "rbxassetid://10921352344",
            }
        },
        ["Adidas"] = {
            id = "427999",
            anims = {
                idle = "rbxassetid://18537376492",
                walk = "rbxassetid://18537392113",
                run = "rbxassetid://18537384940",
                jump = "rbxassetid://18537380791",
                fall = "rbxassetid://18537367238",
                climb = "rbxassetid://18537363391",
                swim = "rbxassetid://18537389531",
            }
        },
        ["Elder"] = {
            id = "48",
            anims = {
                idle = "rbxassetid://10921101664",
                walk = "rbxassetid://10921111375",
                run = "rbxassetid://10921104374",
                jump = "rbxassetid://10921107367",
                fall = "rbxassetid://10921105765",
                climb = "rbxassetid://10921100400",
                swim = "rbxassetid://10921108971",
            }
        },
        ["Dumb Dumb"] = {
            id = "3290671274997",
            containerIds = {
                idle = "105004614594851",
                walk = "82802187852670",
                run = "94065959215233",
                jump = "95678097589635",
                fall = "139471194330271",
                climb = "74141666174470",
                swim = "128952343229653",
            }
        }
    }

    local presetPacksById = {
        ["63"] = presetAnimationPacks["Mage"],
        ["33"] = presetAnimationPacks["Vampire"],
        ["80"] = presetAnimationPacks["Zombie"],
        ["427999"] = presetAnimationPacks["Adidas"],
        ["48"] = presetAnimationPacks["Elder"],
        ["3290671274997"] = presetAnimationPacks["Dumb Dumb"],
    }

    local dynamicPackCache = {}

    local function resolveAnimationPack(packId)
        local rawId = tostring(packId or ""):match("%d+")
        if not rawId or rawId == "" then return nil end

        if presetPacksById[rawId] then
            local pack = presetPacksById[rawId]
            if pack.anims then return pack.anims end
            if pack.containerIds then
                local animMap = {}
                for action, cId in pairs(pack.containerIds) do
                    animMap[action] = extractTrueAnimationId(cId)
                end
                pack.anims = animMap
                return animMap
            end
        end
        if dynamicPackCache[rawId] then
            return dynamicPackCache[rawId]
        end

        local AssetService = game:GetService("AssetService")
        local success, details = pcall(function()
            return AssetService:GetBundleDetailsAsync(tonumber(rawId))
        end)

        local animMap = {}
        if success and details and details.Items then
            for _, item in ipairs(details.Items) do
                if item.Type == "Asset" then
                    local itemName = string.lower(item.Name or "")
                    local assetId = item.Id
                    local animId = extractTrueAnimationId(assetId)

                    if itemName:find("idle") then
                        animMap.idle = animId
                    elseif itemName:find("walk") then
                        animMap.walk = animId
                    elseif itemName:find("run") then
                        animMap.run = animId
                    elseif itemName:find("jump") then
                        animMap.jump = animId
                    elseif itemName:find("fall") then
                        animMap.fall = animId
                    elseif itemName:find("climb") then
                        animMap.climb = animId
                    elseif itemName:find("swim") then
                        animMap.swim = animId
                    end
                end
            end
        end

        if not next(animMap) then
            pcall(function()
                local objs = game:GetObjects("rbxassetid://" .. rawId)
                if objs and #objs > 0 then
                    for _, desc in ipairs(objs[1]:GetDescendants()) do
                        if desc:IsA("Animation") and desc.AnimationId and desc.AnimationId ~= "" then
                            local n = string.lower(desc.Name)
                            for _, action in ipairs({"idle", "walk", "run", "jump", "fall", "climb", "swim"}) do
                                if n:find(action) and not animMap[action] then
                                    animMap[action] = desc.AnimationId
                                end
                            end
                        end
                    end
                end
            end)
        end

        if next(animMap) then
            dynamicPackCache[rawId] = animMap
            return animMap
        end
        return nil
    end

    local originalAnimations = {}
    local isCustomAnimActive = false

    local function storeOriginalAnimations(animateScript)
        if not animateScript then return end
        originalAnimations = {}
        for _, action in ipairs({"idle", "walk", "run", "jump", "fall", "climb", "swim"}) do
            local folder = animateScript:FindFirstChild(action)
            if folder then
                originalAnimations[action] = {}
                for _, child in ipairs(folder:GetChildren()) do
                    if child:IsA("Animation") then
                        table.insert(originalAnimations[action], {
                            Name = child.Name,
                            Id = child.AnimationId
                        })
                    end
                end
            end
        end
    end

    local function applyCustomAnimations()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        local animate = char:FindFirstChild("Animate")
        if not animate then return end

        if not customAnimationConfig.enabled then
            if isCustomAnimActive and next(originalAnimations) then
                for action, animList in pairs(originalAnimations) do
                    local folder = animate:FindFirstChild(action)
                    if folder then
                        for _, data in ipairs(animList) do
                            local existing = folder:FindFirstChild(data.Name)
                            if existing and existing:IsA("Animation") then
                                existing.AnimationId = data.Id
                            end
                        end
                    end
                end
                if hum then
                    for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
                        pcall(function() track:Stop(0) end)
                    end
                end
                isCustomAnimActive = false
            end
            return
        end

        if not isCustomAnimActive and not next(originalAnimations) then
            storeOriginalAnimations(animate)
        end

        local animMap = nil
        local sel = customAnimationConfig.preset or "Mage"
        if sel ~= "Custom" then
            local pack = presetAnimationPacks[sel]
            if not pack then
                for name, data in pairs(presetAnimationPacks) do
                    if sel:find(name, 1, true) or sel:find(data.id, 1, true) then
                        pack = data
                        break
                    end
                end
            end
            if pack then
                if pack.anims then
                    animMap = pack.anims
                elseif pack.containerIds then
                    animMap = {}
                    for action, cId in pairs(pack.containerIds) do
                        animMap[action] = extractTrueAnimationId(cId)
                    end
                    pack.anims = animMap
                end
            end
        else
            animMap = resolveAnimationPack(customAnimationConfig.customPackId)
        end

        if not animMap then return end

        for action, animId in pairs(animMap) do
            local folder = animate:FindFirstChild(action)
            if folder then
                local found = false
                for _, child in ipairs(folder:GetChildren()) do
                    if child:IsA("Animation") then
                        child.AnimationId = animId
                        found = true
                    end
                end
                if not found then
                    local a = Instance.new("Animation")
                    a.Name = action .. "Anim"
                    a.AnimationId = animId
                    a.Parent = folder
                end
            end
        end

        isCustomAnimActive = true
        if hum then
            for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
                pcall(function() track:Stop(0) end)
            end
        end
    end

    trackConnection(LocalPlayer.CharacterAdded:Connect(function(char)
        originalAnimations = {}
        isCustomAnimActive = false
        if customAnimationConfig.enabled then
            task.spawn(function()
                local animate = char:WaitForChild("Animate", 6)
                if animate then
                    task.wait(0.2)
                    applyCustomAnimations()
                end
            end)
        end
    end))

    -- mitigate aggressive physics impulses from other players
    local antiFlingConn = nil
    local antiFlingHeartbeatConn = nil
    local activeNoCollisionConstraints = {}

    -- cache player parts and lists to avoid allocation overhead
    local antiFlingPartCache = {}
    local antiFlingPlayers = {}
    local antiFlingHbTick = 0

    local function rebuildPlayerList()
        table.clear(antiFlingPlayers)
        for _, plr in ipairs(Players:GetPlayers()) do
            if plr ~= LocalPlayer then
                table.insert(antiFlingPlayers, plr)
            end
        end
    end

    local function cachePlayerParts(plr)
        local char = plr.Character
        if not char then antiFlingPartCache[plr] = nil; return end
        local parts = {}
        for _, d in ipairs(char:GetDescendants()) do
            if d:IsA("BasePart") then
                parts[#parts + 1] = d
            end
        end
        antiFlingPartCache[plr] = parts
    end

    local function clearNoCollisionConstraints()
        for _, c in ipairs(activeNoCollisionConstraints) do
            pcall(function() c:Destroy() end)
        end
        table.clear(activeNoCollisionConstraints)
    end

    local function pruneNoCollisionConstraints()
        local valid = {}
        for _, c in ipairs(activeNoCollisionConstraints) do
            if c and c.Parent and c.Part0 and c.Part1 and c.Part0.Parent and c.Part1.Parent then
                valid[#valid + 1] = c
            else
                if c then pcall(function() c:Destroy() end) end
            end
        end
        activeNoCollisionConstraints = valid
    end

    local function resetCollisions()
        clearNoCollisionConstraints()
        for _, plr in ipairs(antiFlingPlayers) do
            local parts = antiFlingPartCache[plr]
            if parts then
                for _, part in ipairs(parts) do
                    if part and part.Parent then
                        part.CanCollide = true
                    end
                end
            end
        end
    end

    local function updateAntiFling()
        if antiFlingConn then
            pcall(function() antiFlingConn:Disconnect() end)
            antiFlingConn = nil
        end
        if antiFlingHeartbeatConn then
            pcall(function() antiFlingHeartbeatConn:Disconnect() end)
            antiFlingHeartbeatConn = nil
        end

        if state.antiFlingEnabled and not state.unloaded then
            -- refresh player caches when anti-fling turns on
            rebuildPlayerList()
            for _, plr in ipairs(antiFlingPlayers) do
                cachePlayerParts(plr)
            end

            local lastWasFlinging = false

            -- disable part collisions and attach constraints using cached lists
            antiFlingConn = RunService.Stepped:Connect(function()
                if state.unloaded or not state.antiFlingEnabled then
                    antiFlingConn:Disconnect(); antiFlingConn = nil
                    resetCollisions(); return
                end

                local isFlinging = state.isFlinging == true
                if isFlinging then
                    if not lastWasFlinging then
                        lastWasFlinging = true
                        resetCollisions()
                    end
                    return
                end
                lastWasFlinging = false

                local myChar = LocalPlayer.Character
                local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")

                -- disable collision on local character limbs
                if myChar then
                    for _, part in ipairs(myChar:GetChildren()) do
                        if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                            part.CanCollide = false
                        end
                    end
                end

                -- disable collision on adjacent player parts
                for _, plr in ipairs(antiFlingPlayers) do
                    local char = plr.Character
                    if not char then continue end

                    local parts = antiFlingPartCache[plr]
                    if not parts or #parts == 0 or (parts[1] and parts[1].Parent == nil) then
                        cachePlayerParts(plr)
                        parts = antiFlingPartCache[plr]
                    end
                    if parts then
                        for i = 1, #parts do
                            local part = parts[i]
                            if part and part.Parent then
                                part.CanCollide = false
                            end
                        end
                    end

                    -- attach pairwise no-collision constraints
                    local oHrp = char:FindFirstChild("HumanoidRootPart")
                    if myHrp and oHrp then
                        local existing = oHrp:FindFirstChild("AntiFlingConstraint")
                        if existing and existing.Part0 == myHrp then
                            -- retain established constraint without recreating
                        else
                            if existing then existing:Destroy() end
                            local constraint = Instance.new("NoCollisionConstraint")
                            constraint.Name = "AntiFlingConstraint"
                            constraint.Part0 = myHrp
                            constraint.Part1 = oHrp
                            constraint.Parent = oHrp
                            activeNoCollisionConstraints[#activeNoCollisionConstraints + 1] = constraint
                        end
                    end
                end

                if #activeNoCollisionConstraints > 40 then
                    pruneNoCollisionConstraints()
                end
            end)

            -- throttle physics dampening to reduce cpu load
            antiFlingHeartbeatConn = RunService.Heartbeat:Connect(function()
                if state.unloaded or not state.antiFlingEnabled then
                    antiFlingHeartbeatConn:Disconnect(); antiFlingHeartbeatConn = nil
                    return
                end
                if state.isFlinging then return end

                antiFlingHbTick = antiFlingHbTick + 1

                local myChar = LocalPlayer.Character
                local myHrp = myChar and myChar:FindFirstChild("HumanoidRootPart")
                local myHum = myChar and myChar:FindFirstChildOfClass("Humanoid")

                -- cancel abnormal external velocity on local root
                if myHrp and not state.flightEnabled then
                    local lv = myHrp.AssemblyLinearVelocity
                    local av = myHrp.AssemblyAngularVelocity
                    if lv.Magnitude > 65 then
                        myHrp.AssemblyLinearVelocity = Vector3.new(
                            math.clamp(lv.X, -25, 25),
                            math.clamp(lv.Y, -35, 35),
                            math.clamp(lv.Z, -25, 25)
                        )
                    end
                    if av.Magnitude > 25 then
                        myHrp.AssemblyAngularVelocity = Vector3.zero
                    end
                end

                -- keep character upright and prevent knockdown
                if myHum and myHum.Health > 0 then
                    local s = myHum:GetState()
                    if s == Enum.HumanoidStateType.FallingDown
                    or s == Enum.HumanoidStateType.Ragdoll
                    or s == Enum.HumanoidStateType.PlatformStanding then
                        myHum:ChangeState(Enum.HumanoidStateType.GettingUp)
                        myHum:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end

                -- damp erratic physics spikes on adjacent characters
                if antiFlingHbTick % 3 ~= 0 then return end
                if not myHrp then return end
                local myPos = myHrp.Position
                for _, plr in ipairs(antiFlingPlayers) do
                    if plr.Character then
                        local oHrp = plr.Character:FindFirstChild("HumanoidRootPart")
                        if oHrp and (oHrp.Position - myPos).Magnitude < 35 then
                            local lv = oHrp.AssemblyLinearVelocity
                            local av = oHrp.AssemblyAngularVelocity
                            if lv.Magnitude > 30 or av.Magnitude > 20 then
                                pcall(function()
                                    oHrp.AssemblyLinearVelocity = Vector3.zero
                                    oHrp.AssemblyAngularVelocity = Vector3.zero
                                end)
                            end
                        end
                    end
                end
            end)
        else
            resetCollisions()
        end
    end

    registerCleanupHook(function()
        if antiFlingConn then
            pcall(function() antiFlingConn:Disconnect() end)
            antiFlingConn = nil
        end
        if antiFlingHeartbeatConn then
            pcall(function() antiFlingHeartbeatConn:Disconnect() end)
            antiFlingHeartbeatConn = nil
        end
        resetCollisions()
        table.clear(antiFlingPartCache)
        table.clear(antiFlingPlayers)
    end)

    local function hookCharacter(plr, char)
        if not char then return end
        cachePlayerParts(plr)
        trackPlayerConnection(plr, char.ChildAdded:Connect(function(child)
            if child:IsA("Tool") or child:IsA("BasePart") or child:IsA("Accessory") then
                task.wait(0.05)
                cachePlayerParts(plr)
            end
        end))
    end

    -- Periodic auto-refresh watchdog: updates players and recaches parts every 1.5s
    -- ensures players who respawned, equipped tools, or reset collision states never become collidable
    task.spawn(function()
        while not state.unloaded do
            task.wait(1.5)
            if state.antiFlingEnabled and not state.isFlinging then
                rebuildPlayerList()
                for _, plr in ipairs(antiFlingPlayers) do
                    cachePlayerParts(plr)
                end
                pruneNoCollisionConstraints()
            end
        end
    end)

    -- keep player cache in sync with lobby changes
    trackConnection(Players.PlayerAdded:Connect(function(plr)
        rebuildPlayerList()
        trackPlayerConnection(plr, plr.CharacterAdded:Connect(function(char)
            task.wait(0.1)
            hookCharacter(plr, char)
        end))
    end))
    trackConnection(Players.PlayerRemoving:Connect(function(plr)
        antiFlingPartCache[plr] = nil
        rebuildPlayerList()
    end))
    for _, plr in ipairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer then
            if plr.Character then hookCharacter(plr, plr.Character) end
            trackPlayerConnection(plr, plr.CharacterAdded:Connect(function(char)
                task.wait(0.1)
                hookCharacter(plr, char)
            end))
        end
    end

    trackConnection(LocalPlayer.CharacterAdded:Connect(function()
        task.wait(0.3)
        updateAntiFling()
    end))

    -- run primary farming lifecycle 
    local collectedCoinsDebounce = {}

    local autofarmLoopThread = task.spawn(function()
        local wasFarmingLastTick = false
        while not state.unloaded do
            if state.autofarmEnabled then
                wasFarmingLastTick = true
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                local hum = char and char:FindFirstChildOfClass("Humanoid")
            
                if hrp and hum and hum.Health > 0 then
                    -- Passive: kill all players early if user is Murderer and round end action is "Farm exp"
                    -- (Murderer earns EXP only from kills, not from round survival/time)
                    if state.afterFarmAction == "Farm exp" and state.autofarmMode ~= "Wins" and getPlayerRole(LocalPlayer) == "Murderer" and state.roundActive and isBagFull() then
                        local anyAlive = false
                        for _, plr in ipairs(Players:GetPlayers()) do
                            if plr ~= LocalPlayer and isPlayerAlive(plr) then
                                anyAlive = true
                                break
                            end
                        end
                        if anyAlive then
                            state.currentTaskStatus = "Killing all (murd exp)"
                            killTarget()
                            task.wait(0.3)
                        end
                    end

                    -- collect coins via direct position updates
                    if state.autofarmMode == "Teleport (unreliable)" or state.autofarmMode == "Tp Coin Farm (unreliable)" then
                        state.hasTeleportedToLobby = false
                        makeAntiVoidPlate()

                        if not canFarmCoins() then
                            stopTween()
                            state.currentTaskStatus = "waiting in lobby"
                            tpToSafeSpawn(true)
                            task.wait(0.5)
                        else
                            setNoclip(true)

                            local _genv     = getgenv and getgenv() or {}
                            local touchFire = _genv.firetouchinterest
                                           or rawget(_G, "firetouchinterest")
                                           or (syn and syn.firetouchinterest)
                                           or firetouchinterest

                            local coins = scanAllCoins()
                            if #coins == 0 then
                                state.currentTaskStatus = "Farming coins"
                                task.wait(0.1)
                            else
                                -- teleport to random coin on round start before beginning route
                                if not state.tweenRoundTeleported or (hrp.Position - SAFEZONE_POS).Magnitude < 100 then
                                    local rndCoin = coins[math.random(1, #coins)]
                                    if rndCoin and rndCoin.Position then
                                        pcall(function()
                                            hrp.Anchored = false
                                            hrp.CFrame = CFrame.new(rndCoin.Position.X, rndCoin.Position.Y - 1.5, rndCoin.Position.Z)
                                            hrp.AssemblyLinearVelocity = Vector3.zero
                                            hrp.AssemblyAngularVelocity = Vector3.zero
                                        end)
                                        task.wait(0.05)
                                    end
                                    state.tweenRoundTeleported = true
                                    char = LocalPlayer.Character
                                    hrp  = char and char:FindFirstChild("HumanoidRootPart")
                                    if not hrp then return end
                                end

                                -- route path to nearest available coin
                                table.sort(coins, function(a, b)
                                    return (a.Position - hrp.Position).Magnitude
                                         < (b.Position - hrp.Position).Magnitude
                                end)
                                local coin    = coins[1]
                                local part    = coin.Part
                                local coinPos = coin.Position
                                -- position root part 1.5 studs below coin to touch hitbox
                                local tgtPos  = Vector3.new(coinPos.X, coinPos.Y - 1.5, coinPos.Z)
                                local targetCF = CFrame.new(tgtPos) * CFrame.Angles(math.rad(90), 0, 0)

                                state.currentTaskStatus = "Farming coins"

                                -- face upward to align pickup interaction
                                pcall(function()
                                    hrp.CFrame = targetCF
                                    hrp.Anchored = true
                                    hrp.AssemblyLinearVelocity  = Vector3.zero
                                    hrp.AssemblyAngularVelocity = Vector3.zero
                                end)

                                -- pulse interaction until server confirms collection
                                local deadline = tick() + 1.5
                                while tick() < deadline do
                                    if not canFarmCoins() then break end
                                    if not part.Parent then break end

                                    local ti = getCoinTouchInterest(part)
                                    -- advance immediately once coin disappears
                                    if not ti or not ti.Parent then
                                        break
                                    end

                                    if touchFire then
                                        local touchTarget = (ti and ti.Parent and ti.Parent:IsA("BasePart") and ti.Parent) or part
                                        pcall(function() touchFire(hrp, touchTarget, 0) end)
                                        pcall(function() touchFire(hrp, touchTarget, 1) end)
                                    end

                                    pcall(function()
                                        hrp.CFrame = targetCF
                                        hrp.Anchored = true
                                        hrp.AssemblyLinearVelocity  = Vector3.zero
                                        hrp.AssemblyAngularVelocity = Vector3.zero
                                    end)
                                    task.wait(0.05)
                                end

                                -- proceed without delay to maintain high collection rates
                                state.totalCoinsFarmed = state.totalCoinsFarmed + 1
                            end
                        end

                    -- collect coins via smooth tween movement
                    elseif state.autofarmMode == "Coin" then
                        state.hasTeleportedToLobby = false
                        makeAntiVoidPlate()

                        local function handleMurdererAction()
                            if not state.roundEndFling then return end
                            if not isPlayerAlive(LocalPlayer) then return end
                            local murderer = state.knifeHolder
                            if not murderer or not isMurdererAlive(murderer) then
                                murderer = getMurd()
                                if murderer and isMurdererAlive(murderer) then
                                    state.knifeHolder = murderer
                                end
                            end
                            local localRole = getPlayerRole(LocalPlayer)
                            local hasGun    = hasTool(LocalPlayer, "Gun")
                            local hasKnife  = (localRole == "Murderer") or hasTool(LocalPlayer, "Knife")
                            if hasKnife or hasGun or localRole == "Sheriff" then
                                killTarget()
                            else
                                while state.autofarmEnabled and isPlayerAlive(LocalPlayer) and isCoinBagVisible() do
                                    -- If player picked up or received a gun, abort fling and shoot murderer instead
                                    if hasTool(LocalPlayer, "Gun") or getPlayerRole(LocalPlayer) == "Sheriff" then
                                        state.currentTaskStatus = "Shooting murd"
                                        killTarget()
                                        break
                                    end

                                    local m = state.knifeHolder
                                    if not m or not isMurdererAlive(m) then m = getMurd() end
                                    if not m or not isMurdererAlive(m) or m == LocalPlayer then break end
                                    state.currentTaskStatus = "Flinging murd"
                                    flingTarget(m, true, 4.0)

                                    -- Check again immediately after fling finishes/aborts
                                    if hasTool(LocalPlayer, "Gun") or getPlayerRole(LocalPlayer) == "Sheriff" then
                                        state.currentTaskStatus = "Shooting murd"
                                        killTarget()
                                        break
                                    end

                                    if isMurdererAlive(m) and state.autofarmEnabled and isPlayerAlive(LocalPlayer) and isCoinBagVisible() then
                                        state.currentTaskStatus = "retrying fling in 2s..."
                                        task.wait(2.0)
                                    else
                                        break
                                    end
                                end
                            end
                        end

                        if not canFarmCoins() then
                            stopTween()
                            if isBagFull() then
                                if state.afterFarmAction == "End round" then
                                    tpToSafeSpawn(true)
                                    handleMurdererAction()
                                elseif state.afterFarmAction == "Reset" and isPlayerAlive(LocalPlayer) then
                                    state.currentTaskStatus = "resetting"
                                    tpToSafeSpawn(true)
                                    pcall(function()
                                        local c = LocalPlayer.Character
                                        local h = c and c:FindFirstChildOfClass("Humanoid")
                                        if h then h.Health = 0 end
                                    end)
                                else
                                    tpToSafeSpawn(true)
                                    if state.afterFarmAction == "Farm exp" and getPlayerRole(LocalPlayer) == "Murderer" then
                                        state.currentTaskStatus = "Killing all (murd exp)"
                                        killTarget()
                                    else
                                        state.currentTaskStatus = "bag full"
                                    end
                                end
                            else
                                tpToSafeSpawn(true)
                                state.currentTaskStatus = "waiting in lobby"
                            end
                            task.wait(0.5)

                        elseif not isPlayerAlive(LocalPlayer) then
                            state.currentTaskStatus = "waiting for respawn"
                            task.wait(0.5)

                        else
                            local _genv     = getgenv and getgenv() or {}
                            local touchFire = _genv.firetouchinterest
                                           or rawget(_G, "firetouchinterest")
                                           or (syn and syn.firetouchinterest)
                                           or firetouchinterest
                            local minY = getMinAllowedY()
                            local COIN_FARM_SPEED = state.autofarmTweenSpeed or 22

                            pcall(function()
                                hrp.Anchored = false
                            end)

                            local function markCoinCollected(part)
                                if part and not collectedCoinsDebounce[part] then
                                    collectedCoinsDebounce[part] = true
                                    state.totalCoinsFarmed = state.totalCoinsFarmed + 1
                                end
                            end

                            local function coinGone(part)
                                return not part.Parent or not getCoinTouchInterest(part) or part.Transparency >= 0.9
                            end

                            local function fireCoin(part)
                                if not touchFire or not part or not part.Parent then return end
                                local ti = getCoinTouchInterest(part)
                                local target = (ti and ti.Parent and ti.Parent:IsA("BasePart") and ti.Parent) or part
                                pcall(function() touchFire(hrp, target, 0) end)
                                pcall(function() touchFire(hrp, target, 1) end)
                            end

                            local function murdPos()
                                if not state.avoidMurderer then return nil end
                                local m = state.knifeHolder
                                if not m or m == LocalPlayer or not isPlayerAlive(m) then return nil end
                                local r = m.Character and m.Character:FindFirstChild("HumanoidRootPart")
                                if not r then return nil end
                                -- lead the murderer slightly so we avoid where he's heading
                                return r.Position + r.AssemblyLinearVelocity * 0.4
                            end

                            local function safeCoins(list)
                                local mp = murdPos()
                                if not mp then return list end
                                local out = {}
                                for _, c in ipairs(list) do
                                    if (c.Position - mp).Magnitude > state.avoidDistance then
                                        out[#out + 1] = c
                                    end
                                end
                                return out
                            end

                            local function getCoinContainer()
                                -- locate coin container within active map
                                local map = getActiveMap()
                                if map then
                                    local container = map:FindFirstChild("CoinContainer")
                                    if container then
                                        return container
                                    end
                                    for _, child in ipairs(map:GetChildren()) do
                                        local nestedContainer = child:FindFirstChild("CoinContainer")
                                        if nestedContainer then
                                            return nestedContainer
                                        end
                                    end
                                end

                                -- search workspace if map hierarchy differs
                                for _, child in ipairs(Workspace:GetChildren()) do
                                    if child:IsA("Model") or child:IsA("Folder") then
                                        local container = child:FindFirstChild("CoinContainer")
                                        if container and #container:GetChildren() > 0 then
                                            return container
                                        end
                                    end
                                end

                                return nil
                            end

                            local function scanCoins()
                                local coins = {}
                                local container = getCoinContainer()

                                if not container then
                                    return coins
                                end

                                for _, item in ipairs(container:GetChildren()) do
                                    -- item IS the Coin_Server model; CoinVisual is the BasePart inside it
                                    local visual = item:FindFirstChild("CoinVisual")
                                    -- CoinVisual is used for position/transparency; item (Coin_Server) has the TouchInterest
                                    local part = (visual and visual:IsA("BasePart") and visual)
                                        or (item:IsA("BasePart") and item)
                                        or item:FindFirstChildWhichIsA("BasePart")

                                    if part then
                                        -- TouchInterest lives on Coin_Server (item), not on CoinVisual
                                        local touchTarget = item:IsA("BasePart") and item or item
                                        local hasTouch = getCoinTouchInterest(touchTarget) or getCoinTouchInterest(part)
                                        local inDebounce = collectedCoinsDebounce[part]
                                        local yCheck = part.Position.Y >= minY

                                        -- coin is available when CoinVisual is visible; normal value ~0.05, fully collected = 1
                                        local isNotCollected = true
                                        if visual and visual:IsA("BasePart") then
                                            isNotCollected = visual.Transparency < 0.9
                                        elseif part.Transparency >= 0.9 then
                                            isNotCollected = false
                                        end

                                        if yCheck and not inDebounce and hasTouch and isNotCollected then
                                            table.insert(coins, part)
                                        end
                                    end
                                end

                                return coins
                            end

                            local cachedCoins = {}
                            local nextCoinScan = 0
                            local function refreshCoinCache(force)
                                if not force and tick() < nextCoinScan then return false end
                                cachedCoins = scanCoins()
                                nextCoinScan = tick() + 0.5
                                return true
                            end

                            refreshCoinCache(true)

                            if #cachedCoins == 0 then
                                state.currentTaskStatus = "Farming coins (no coins found)"
                                task.wait(0.5)
                            else
                                if not state.tweenRoundTeleported then
                                    state.tweenRoundTeleported = true
                                    table.clear(collectedCoinsDebounce)
                                    refreshCoinCache(true)

                                    local startPool = safeCoins(cachedCoins)
                                    local firstCoin = startPool[math.random(1, math.max(#startPool, 1))] or cachedCoins[math.random(1, #cachedCoins)]
                                    if firstCoin then
                                        local firstPosition = Vector3.new(firstCoin.Position.X, firstCoin.Position.Y - 2.6, firstCoin.Position.Z)
                                        pcall(function()
                                            hrp.CFrame = CFrame.new(firstPosition) * CFrame.Angles(math.rad(90), 0, 0)
                                            hrp.AssemblyLinearVelocity = Vector3.zero
                                            hrp.AssemblyAngularVelocity = Vector3.zero
                                        end)
                                        task.wait(0.2)
                                    end
                                end

                                char = LocalPlayer.Character
                                hrp = char and char:FindFirstChild("HumanoidRootPart")
                                hum = char and char:FindFirstChildOfClass("Humanoid")
                                if hrp and hum then
                                    pcall(function()
                                        hum.PlatformStand = true
                                        hum:ChangeState(Enum.HumanoidStateType.PlatformStanding)
                                    end)
                                    setNoclip(true)

                                    local bodyVelocity = hrp:FindFirstChild("SafePlate")
                                    if not bodyVelocity then
                                        bodyVelocity = Instance.new("BodyVelocity")
                                        bodyVelocity.Name = "SafePlate"
                                        bodyVelocity.MaxForce = Vector3.new(1e9, 1e9, 1e9)
                                        bodyVelocity.Velocity = Vector3.zero
                                        bodyVelocity.Parent = hrp
                                    end

                                    state.currentTaskStatus = "Farming coins"
                                    while state.autofarmEnabled and canFarmCoins() do
                                        char = LocalPlayer.Character
                                        hrp = char and char:FindFirstChild("HumanoidRootPart")
                                        local hum2 = char and char:FindFirstChildOfClass("Humanoid")
                                        if not hrp or not hum2 or hum2.Health <= 0 then break end

                                        refreshCoinCache()
                                        if #cachedCoins == 0 then
                                            task.wait(0.5)
                                            continue
                                        end

                                        local pool = safeCoins(cachedCoins)
                                        if #pool == 0 then
                                            state.currentTaskStatus = "Avoiding murderer"
                                            task.wait(0.2)
                                            continue
                                        end

                                        table.sort(pool, function(a, b)
                                            return (a.Position - hrp.Position).Magnitude < (b.Position - hrp.Position).Magnitude
                                        end)

                                        local coinPart = pool[1]
                                        local targetPos = Vector3.new(coinPart.Position.X, coinPart.Position.Y - 2.6, coinPart.Position.Z)
                                        local flyDuration = (hrp.Position - targetPos).Magnitude / math.max(COIN_FARM_SPEED, 1)
                                        local flyStart = tick()
                                        local startPos = hrp.Position
                                        local touched = false
                                        local retarget = false

                                        while tick() - flyStart < flyDuration do
                                            if not state.autofarmEnabled or not canFarmCoins() then break end
                                            if not coinPart.Parent or not getCoinTouchInterest(coinPart) then
                                                retarget = true
                                                break
                                            end

                                            if state.avoidMurderer then
                                                local mp = murdPos()
                                                if mp and ((coinPart.Position - mp).Magnitude <= state.avoidDistance
                                                    or (hrp.Position - mp).Magnitude <= state.avoidDistance * 0.6) then
                                                    retarget = true
                                                    break
                                                end
                                            end

                                            if refreshCoinCache() then
                                                local targetDistance = (coinPart.Position - hrp.Position).Magnitude
                                                for _, candidate in ipairs(cachedCoins) do
                                                    if candidate ~= coinPart
                                                        and candidate.Parent
                                                        and getCoinTouchInterest(candidate)
                                                        and (candidate.Position - hrp.Position).Magnitude + 0.5 < targetDistance then
                                                        retarget = true
                                                        break
                                                    end
                                                end
                                                if retarget then break end
                                            end

                                            local alpha = math.clamp((tick() - flyStart) / math.max(flyDuration, 0.001), 0, 1)
                                            local currentPos = startPos:Lerp(targetPos, alpha)
                                            pcall(function()
                                                hrp.CFrame = CFrame.new(currentPos) * CFrame.Angles(math.rad(90), 0, 0)
                                                hrp.AssemblyLinearVelocity = Vector3.zero
                                                hrp.AssemblyAngularVelocity = Vector3.zero
                                            end)

                                            if not touched and (hrp.Position - coinPart.Position).Magnitude <= 3.5 then
                                                touched = true
                                                fireCoin(coinPart)
                                            end
                                            task.wait()
                                        end

                                        if retarget then
                                            refreshCoinCache(true)
                                            task.wait()
                                        else
                                            for _ = 1, 6 do
                                                if coinGone(coinPart) then break end
                                                fireCoin(coinPart)
                                                task.wait(0.05)
                                            end
                                            if coinGone(coinPart) then
                                                markCoinCollected(coinPart)
                                            else
                                                collectedCoinsDebounce[coinPart] = true
                                                task.delay(3, function() collectedCoinsDebounce[coinPart] = nil end)
                                            end
                                            refreshCoinCache(true)
                                        end
                                    end
                                end
                            end

                            -- reset tween forces on cycle completion
                            stopTween()
                            if isBagFull() then
                                if state.afterFarmAction == "End round" then
                                    tpToSafeSpawn(true)
                                    handleMurdererAction()
                                elseif state.afterFarmAction == "Reset" and isPlayerAlive(LocalPlayer) then
                                    state.currentTaskStatus = "resetting"
                                    tpToSafeSpawn(true)
                                    pcall(function()
                                        local c = LocalPlayer.Character
                                        local h = c and c:FindFirstChildOfClass("Humanoid")
                                        if h then h.Health = 0 end
                                    end)
                                else
                                    tpToSafeSpawn(true)
                                    if state.afterFarmAction == "Farm exp" and getPlayerRole(LocalPlayer) == "Murderer" then
                                        state.currentTaskStatus = "Killing all (murd exp)"
                                        killTarget()
                                    else
                                        state.currentTaskStatus = "bag full"
                                    end
                                end
                            elseif not isCoinBagVisible() then
                                tpToSafeSpawn(true)
                                state.currentTaskStatus = "waiting in lobby"
                            end
                        end

                    -- auto-eliminate targets to secure match victory
                    elseif state.autofarmMode == "Wins" then
                        state.hasTeleportedToLobby = false
                        if state.roundActive then
                            state.currentTaskStatus = "Killing murd"
                            killTarget()
                            task.wait(0.5)
                        else
                            state.currentTaskStatus = "Idle"
                            tpToSafeSpawn()
                            task.wait(1)
                        end
                    end
                end
            else
                if wasFarmingLastTick then
                    wasFarmingLastTick = false
                    pcall(stopTween)
                    pcall(stopAllMovement)
                end
            end
            task.wait(0.1)
        end
    end)

    trackThread(autofarmLoopThread)

        -- clear map hazards that kill farming characters
    local killbrickThread = task.spawn(function()
        while not state.unloaded do
            pcall(function()
                local man2 = Workspace:FindFirstChild("Mansion2")
                if man2 then
                    local base = man2:FindFirstChild("Base")
                    if base then
                        local gp = base:FindFirstChild("GlitchProof")
                        if gp then
                            local killbr = gp:FindFirstChild("KillBrick")
                            if killbr then
                                pcall(function() killbr.CanTouch = false end)
                                for _, child in ipairs(killbr:GetChildren()) do
                                    if child:IsA("Script") or child:IsA("LocalScript") then
                                        pcall(function()
                                            child.Disabled = true
                                            child:Destroy()
                                        end)
                                    end
                                end
                                pcall(function() killbr:Destroy() end)
                            end
                        end
                    end
                end
            end)
            task.wait(0.5)
        end
    end)
    trackThread(killbrickThread)

-- retrieve dropped sheriff gun to defend 
    local lastAttemptedGunPart = nil  -- remember attempted drops to avoid position spam
    local lastAttemptTime = 0         -- space out pickup attempts to bypass anticheat checks
    local isTakingGun = false

    attemptTakeGun = function(targetPart)
        if isTakingGun then return end
        if not state.autoTakeGun then return end
        if not isCoinBagVisible() or not isPlayerAlive(LocalPlayer) then return end

        local localRole = getPlayerRole(LocalPlayer)
        local char = LocalPlayer.Character
        local hrp  = char and char:FindFirstChild("HumanoidRootPart")
        local hum  = char and char:FindFirstChildOfClass("Humanoid")
        local aliveInMap = isPlayerAlive(LocalPlayer) and not isInLobby() and isCoinBagVisible()

        -- constrain gun retrieval to safe match conditions
        local isRemoteMethod = (state.autoTakeGunMethod == "Touch interest" or state.autoTakeGunMethod == "Remote")
        local shouldTakeGun = false
        if not state.autofarmEnabled then
            shouldTakeGun = true
        elseif state.autofarmEnabled and (isRemoteMethod or (state.afterFarmAction == "End round" and localRole == "Innocent")) then
            shouldTakeGun = true
        end

        local busyCoinFarming = state.autofarmEnabled and state.autofarmMode == "Coin" and not isBagFull() and not isRemoteMethod
        local alreadyHasGun = hasTool(LocalPlayer, "Gun") or (LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Gun"))
        local alreadyHasKnife = hasTool(LocalPlayer, "Knife") or (LocalPlayer.Backpack and LocalPlayer.Backpack:FindFirstChild("Knife"))

        -- clear drop history once gun enters inventory
        if alreadyHasGun then
            lastAttemptedGunPart = nil
            lastAttemptTime = 0
        end

        if aliveInMap
            and shouldTakeGun
            and not busyCoinFarming
            and localRole ~= "Murderer"
            and not alreadyHasGun
            and not alreadyHasKnife then

            local gunPart = targetPart or getDroppedGunPart()

            -- bypass already attempted weapons
            local now = tick()
            local isNewGun = gunPart and gunPart ~= lastAttemptedGunPart
            local cooldownExpired = (now - lastAttemptTime) >= 1.5

            if gunPart and hrp and hum and (isNewGun or cooldownExpired) then
                isTakingGun = true
                -- flag weapon as processed
                lastAttemptedGunPart = gunPart
                lastAttemptTime = now

                if state.autoTakeGunMethod == "Touch interest" or state.autoTakeGunMethod == "Remote" then
                    -- fire touch interest directly when supported
                    local _genv2 = getgenv and getgenv() or {}
                    local touchFire = _genv2.firetouchinterest or firetouchinterest or (syn and syn.firetouchinterest)
                    if touchFire then
                        pcall(function() touchFire(hrp, gunPart, 0) end)
                        pcall(function() touchFire(hrp, gunPart, 1) end)

                        local ti = gunPart:FindFirstChildWhichIsA("TouchTransmitter", true) or gunPart:FindFirstChild("TouchInterest", true)
                        if ti then
                            pcall(function() touchFire(hrp, ti.Parent, 0) end)
                            pcall(function() touchFire(hrp, ti.Parent, 1) end)
                        end
                    end
                else
                    -- teleport directly to gun dropped position
                    local originalCF = hrp.CFrame
                    local gunPos = Vector3.new(gunPart.Position.X, gunPart.Position.Y - 2, gunPart.Position.Z)

                    setNoclip(true)

                    pcall(function()
                        hrp.CFrame = CFrame.new(gunPos) * CFrame.Angles(math.rad(90), 0, 0)
                        hrp.AssemblyLinearVelocity = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                    end)

                    local _genv2 = getgenv and getgenv() or {}
                    local touchFire = _genv2.firetouchinterest or firetouchinterest or (syn and syn.firetouchinterest)
                    if touchFire then
                        pcall(function() touchFire(hrp, gunPart, 0) end)
                        pcall(function() touchFire(hrp, gunPart, 1) end)
                        local ti = gunPart:FindFirstChildWhichIsA("TouchTransmitter", true) or gunPart:FindFirstChild("TouchInterest", true)
                        if ti then
                            pcall(function() touchFire(hrp, ti.Parent, 0) end)
                            pcall(function() touchFire(hrp, ti.Parent, 1) end)
                        end
                    end

                    task.wait(0.12)

                    local gunTool = getPlayerTool(LocalPlayer, "Gun")
                    if gunTool then
                        pcall(function() hum:EquipTool(gunTool) end)
                        task.wait(0.04)
                    end

                    task.wait(0.08)

                    pcall(function()
                        hrp.CFrame = originalCF
                        hrp.AssemblyLinearVelocity  = Vector3.zero
                        hrp.AssemblyAngularVelocity = Vector3.zero
                    end)
                    task.wait(0.04)
                    setNoclip(false)
                    restoreCharacterCollision()
                end
                isTakingGun = false
            end
        end
    end

    local autoTakeGunThread = task.spawn(function()
        while not state.unloaded do
            if state.autoTakeGun then
                attemptTakeGun()
            end
            task.wait(0.04)
        end
    end)
    trackThread(autoTakeGunThread)

    -- purchase and unlock mystery crates automatically 
    local autoOpenCratesThread = task.spawn(function()
        while not state.unloaded do
            if state.autoOpenCratesEnabled then
                local crate = state.selectedCrateType or "MysteryBox1"
                local keyType = (crate == "Summer2026Box") and "SummerKey2026" or "Coins"
                pcall(function()
                    local rs = game:GetService("ReplicatedStorage")
                    local remotes = rs:FindFirstChild("Remotes")
                    local shopRemotes = remotes and remotes:FindFirstChild("Shop")
                    local openRemote = shopRemotes and shopRemotes:FindFirstChild("OpenCrate")
                    if openRemote and openRemote:IsA("RemoteFunction") then
                        openRemote:InvokeServer(crate, "MysteryBox", keyType)
                    end
                end)
            end
            task.wait(1)
        end
    end)
    trackThread(autoOpenCratesThread)

    -- automatically hop servers on a configurable timer
    local autoServerHopThread = task.spawn(function()
        while not state.unloaded do
            task.wait(1)
            if state.autoServerHopEnabled then
                local intervalSec = (state.autoServerHopIntervalMin or 15) * 60
                local elapsed = tick() - (state.lastServerHopTimer or tick())
                if elapsed >= intervalSec then
                    local canHop = true
                    if state.autoServerHopWaitForRound then
                        -- If wait for round end is active, allow hop when not actively collecting coins
                        -- (e.g. coin bag is not visible/intermission, bag is full, player is dead, or round is inactive)
                        local isCollectingCoins = canFarmCoins()
                        if isCollectingCoins then
                            canHop = false
                        end
                    end
                    if canHop then
                        state.lastServerHopTimer = tick()
                        log("Auto server hop timer reached (" .. tostring(state.autoServerHopIntervalMin or 15) .. " min). Hopping server...")
                        if Window and Window.Notify then
                            Window:Notify("Auto Server Hop", "Timer reached (" .. tostring(state.autoServerHopIntervalMin or 15) .. " min). Finding a new server...", 3)
                        end
                        task.wait(1.5)
                        serverHop()
                    end
                end
            else
                state.lastServerHopTimer = tick()
            end
        end
    end)
    trackThread(autoServerHopThread)

    -- construct character physics and movement controls
    Tabs.Player:AddSection("Movement")

    -- bind speed toggle to slider value
    Tabs.Player:AddToggle("SpeedEnabled", {
        Title = "Speed",
        Default = false,
        DefaultBind = Enum.KeyCode.V,
        Slider = {
            Title = "Speed value",
            Min = 16,
            Max = 250,
            Default = 16,
            Suffix = " studs/s",
            Callback = function(v)
                state.speedValue = v
                if state.speedEnabled and state.speedMode == "WalkSpeed" then
                    local char = LocalPlayer.Character
                    local hum  = char and char:FindFirstChildOfClass("Humanoid")
                    if hum then hum.WalkSpeed = v end
                end
            end
        },
        Callback = function(v)
            state.speedEnabled = v
            local char = LocalPlayer.Character
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                if v and state.speedMode == "WalkSpeed" then
                    hum.WalkSpeed = state.speedValue
                else
                    hum.WalkSpeed = 16
                end
            end
        end
    })

    Tabs.Player:AddDropdown("SpeedMode", {
        Title = "Speed method",
        Values = {"WalkSpeed", "CFrame"},
        Default = "WalkSpeed",
        Callback = function(v)
            state.speedMode = v
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                if state.speedEnabled and v == "WalkSpeed" then
                    hum.WalkSpeed = state.speedValue
                else
                    hum.WalkSpeed = 16
                end
            end
        end
    })

    -- Bunnyhop with speed slider
    Tabs.Player:AddToggle("BhopEnabled", {
        Title = "Bunnyhop",
        Default = false,
        Slider = {
            Title = "Bhop speed",
            Min = 16,
            Max = 250,
            Default = 30,
            Suffix = " studs/s",
            Callback = function(v)
                state.bhopSpeed = v
            end
        },
        Callback = function(v)
            state.bhopEnabled = v
            if not v then
                isAirborneFromJump = false
            end
            local char = LocalPlayer.Character
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                if state.speedEnabled and state.speedMode == "WalkSpeed" then
                    hum.WalkSpeed = state.speedValue
                else
                    hum.WalkSpeed = 16
                end
            end
        end
    })

    Tabs.Player:AddCheckbox("AutoBhop", {
        Title = "Auto bhop",
        Default = false,
        Callback = function(v)
            state.autoBhop = v
        end
    })
    
    local flyHoverPos, flyHoverLook
    local function updateFly(dt)
        if not state.flightEnabled then return end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum then return end

        local moving = false
        local moveDir = Vector3.zero

        -- read wasd input for horizontal flight velocity
        if UserInputService:IsKeyDown(Enum.KeyCode.W) then moveDir = moveDir + CurrentCamera.CFrame.LookVector; moving = true end
        if UserInputService:IsKeyDown(Enum.KeyCode.S) then moveDir = moveDir - CurrentCamera.CFrame.LookVector; moving = true end
        if UserInputService:IsKeyDown(Enum.KeyCode.A) then moveDir = moveDir - CurrentCamera.CFrame.RightVector; moving = true end
        if UserInputService:IsKeyDown(Enum.KeyCode.D) then moveDir = moveDir + CurrentCamera.CFrame.RightVector; moving = true end
        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveDir = moveDir + Vector3.new(0, 1, 0); moving = true end
        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveDir = moveDir - Vector3.new(0, 1, 0); moving = true end

        -- fallback to virtual thumbstick on mobile
        if not moving then
            local md = hum.MoveDirection
            if md.Magnitude > 0.1 then
                local look = CurrentCamera.CFrame.LookVector
                local right = CurrentCamera.CFrame.RightVector
                local flatLookV = Vector3.new(look.X, 0, look.Z)
                local flatRightV = Vector3.new(right.X, 0, right.Z)
                if flatLookV.Magnitude > 0 then flatLookV = flatLookV.Unit end
                if flatRightV.Magnitude > 0 then flatRightV = flatRightV.Unit end
                moveDir = (flatLookV * -md.Z) + (flatRightV * md.X)
                moving = true
            end
        end
        if state.flyUpPressed then moveDir = moveDir + Vector3.new(0, 1, 0); moving = true end
        if state.flyDownPressed then moveDir = moveDir - Vector3.new(0, 1, 0); moving = true end

        local look = CurrentCamera.CFrame.LookVector
        local flatLook = Vector3.new(look.X, 0, look.Z)
        if flatLook.Magnitude == 0 then flatLook = Vector3.new(0, 0, -1) else flatLook = flatLook.Unit end

        local bv = hrp:FindFirstChild("SafePlate")
        local speed = state.flightSpeed

        if moving then
            if moveDir.Magnitude > 0 then moveDir = moveDir.Unit end
            local vel = moveDir * speed
            flyHoverPos  = hrp.Position + moveDir * (speed * dt)
            flyHoverLook = flatLook
            if bv then bv.Velocity = vel else hrp.AssemblyLinearVelocity = vel end
            hrp.CFrame = CFrame.new(hrp.Position, hrp.Position + flatLook)
        else
            if bv then
                bv.Velocity = Vector3.zero
            else
                pcall(function() hrp.AssemblyLinearVelocity = Vector3.zero; hrp.AssemblyAngularVelocity = Vector3.zero end)
            end
            if flyHoverPos then
                hrp.CFrame = CFrame.new(flyHoverPos, flyHoverPos + (flyHoverLook or flatLook))
            else
                flyHoverPos = hrp.Position; flyHoverLook = flatLook
            end
        end
    end

    flyConn = nil
    local function toggleFlyConnection(active)
        if flyConn then pcall(function() flyConn:Disconnect() end); flyConn = nil end
        if active then
            flyHoverPos = nil; flyHoverLook = nil
            local char = LocalPlayer.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then flyHoverPos = hrp.Position; flyHoverLook = CurrentCamera.CFrame.LookVector end
            startFloating()
            flyConn = RunService.Heartbeat:Connect(updateFly)
        else
            stopAllMovement()
        end
    end

    -- fly character along camera look direction
    Tabs.Player:AddToggle("FlightEnabled", {
        Title = "Flight",
        Default = false,
        DefaultBind = Enum.KeyCode.C,
        Slider = {
            Title = "Flight speed",
            Min = 10,
            Max = 2000,
            Default = 50,
            Suffix = " studs/s",
            Callback = function(v)
                state.flightSpeed = v
            end
        },
        Callback = function(v)
            state.flightEnabled = v
            toggleFlyConnection(v)
            if mobileFlyBtn and mobileFlyBtn.GetState and mobileFlyBtn:GetState() ~= v then
                mobileFlyBtn:SetState(v, false)
            end
        end
    })
    
    -- override character jump impulse
    Tabs.Player:AddToggle("JumpPowerEnabled", {
        Title = "Jump power",
        Default = false,
        Slider = {
            Title = "Jump power",
            Min = 50,
            Max = 400,
            Default = 50,
            Suffix = " power",
            Callback = function(v)
                state.jumpPowerValue = v
                if state.jumpPowerEnabled then
                    local char = LocalPlayer.Character
                    local hum  = char and char:FindFirstChildOfClass("Humanoid")
                    if hum then
                        hum.UseJumpPower = true
                        hum.JumpPower = v
                    end
                end
            end
        },
        Callback = function(v)
            state.jumpPowerEnabled = v
            local char = LocalPlayer.Character
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                hum.UseJumpPower = true
                hum.JumpPower = v and state.jumpPowerValue or 50
            end
        end
    })
    
    Tabs.Player:AddSection("Utility")
    Tabs.Player:AddGroup({
        {
            Id = "AutoTakeGun",
            Type = "Toggle",
            Title = "Auto take dropped gun",
            Default = false,
            Callback = function(v)
                state.autoTakeGun = v
                log("Auto take gun: " .. (v and "Enabled" or "Disabled"))
            end
        },
        {
            Id = "GunPickupMethod",
            Type = "Dropdown",
            Title = "Gun pickup method",
            Values = {"Touch interest", "Teleport"},
            Default = "Touch interest",
            Callback = function(selected)
                state.autoTakeGunMethod = selected
                log("Gun pickup method: " .. selected)
            end
        },
        {
            Id = "AntiFlingEnabled",
            Type = "Toggle",
            Title = "Anti fling",
            Default = false,
            Callback = function(v)
                state.antiFlingEnabled = v
                updateAntiFling()
                log("Anti fling: " .. (v and "Enabled" or "Disabled"))
            end
        }
    })

    Tabs.Player:AddSection("Camlock")
    Tabs.Player:AddGroup({
        {
            Id = "CamlockEnabled",
            Type = "Toggle",
            Title = "Camlock",
            Default = false,
            DefaultBind = Enum.KeyCode.Q,
            Slider = {
                Title = "Camlock smoothness",
                Min = 0,
                Max = 100,
                Default = 20,
                Suffix = "%",
                Callback = function(v)
                    camlockSettings.smoothingFactor = v / 100
                end
            },
            Callback = function(v)
                state.camlockEnabled = v
                camlockSettings.aimLockEnabled = v
                camlockSettings.isLockedOn = v
                if v then
                    camlockSettings.targetPlayer = getCamlockTarget()
                else
                    camlockSettings.targetPlayer = nil
                end
                toggleCamlockConnection(v)
                if mobileCamlockBtn and mobileCamlockBtn.GetState and mobileCamlockBtn:GetState() ~= v then
                    mobileCamlockBtn:SetState(v, false)
                end
            end
        },

        {
            Id = "CamlockBodyPart",
            Type = "Dropdown",
            Title = "Target body part",
            Values = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso"},
            Default = "Head",
            Callback = function(v)
                camlockSettings.bodyPartSelected = v
            end
        },

        {
            Id = "CamlockHorizPred",
            Type = "Slider",
            Title = "Horizontal prediction",
            Description = "Lead moving targets horizontally (default 0.2)",
            Min = 0,
            Max = 200,
            Default = 20,
            Suffix = " %",
            Callback = function(v)
                local n = tonumber(v) or 0
                camlockSettings.horizontalPrediction = n / 100
                camlockSettings.predictionFactor = n / 100
            end
        },

        {
            Id = "CamlockVertPred",
            Type = "Slider",
            Title = "Vertical prediction",
            Description = "Lead jumping/falling targets vertically (default 0.2)",
            Min = 0,
            Max = 200,
            Default = 20,
            Suffix = " %",
            Callback = function(v)
                local n = tonumber(v) or 0
                camlockSettings.verticalPrediction = n / 100
            end
        }
    })

    Tabs.Player:AddSection("Target")

    local function getPlayerList()
        local list = {}
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer then
                table.insert(list, p.Name)
            end
        end
        if #list == 0 then table.insert(list, "None") end
        table.sort(list)
        return list
    end

    local initialPlayers = getPlayerList()
    if initialPlayers[1] and initialPlayers[1] ~= "None" then
        state.targetUsername = initialPlayers[1]
    end

    local targetDropdown = nil
    targetDropdown = Tabs.Player:AddDropdown("TargetPlayer", {
        Title = "Target player",
        Values = initialPlayers,
        Default = initialPlayers[1] or "None",
        Callback = function(name)
            if name == "None" or name == "" then
                state.targetUsername = ""
            else
                state.targetUsername = name
                log("Target set to: " .. name)
            end
        end
    })

    local lastTargetListStr = ""
    local function updateTargetDropdown()
        if not targetDropdown then return end
        local currentList = getPlayerList()
        local listKey = table.concat(currentList, ",")
        if listKey == lastTargetListStr then return end
        lastTargetListStr = listKey

        targetDropdown:SetValues(currentList)
        if state.targetUsername and state.targetUsername ~= "" then
            local found = false
            for _, n in ipairs(currentList) do
                if n == state.targetUsername then found = true; break end
            end
            if not found then
                local newTarget = (currentList[1] ~= "None") and currentList[1] or ""
                state.targetUsername = newTarget
                targetDropdown:SetValue(currentList[1] or "None", false)
            end
        elseif currentList[1] and currentList[1] ~= "None" then
            state.targetUsername = currentList[1]
            targetDropdown:SetValue(currentList[1], false)
        end
    end

    trackConnection(Players.PlayerAdded:Connect(function()
        task.defer(updateTargetDropdown)
    end))

    trackConnection(Players.PlayerRemoving:Connect(function()
        task.defer(updateTargetDropdown)
    end))

    local targetListSyncThread = task.spawn(function()
        while not state.unloaded do
            task.wait(6)
            updateTargetDropdown()
        end
    end)
    trackThread(targetListSyncThread)

    Tabs.Player:AddButton({
        Title = "Teleport to target",
        Icon = "navigation",
        Callback = function()
            local target = findPlayer(state.targetUsername)
            if target and isPlayerAlive(target) then
                local tHrp = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
                local myHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                if tHrp and myHrp then
                    myHrp.CFrame = tHrp.CFrame * CFrame.new(0, 0, 3)
                    log("Teleported to: " .. target.Name)
                end
            else
                log("Target not found or dead")
            end
        end
    })

    local spectateConn = nil
    Tabs.Player:AddToggle("SpectateTarget", {
        Title = "Spectate target",
        Default = false,
        Callback = function(v)
            state.spectateTarget = v
            if spectateConn then
                pcall(function() spectateConn:Disconnect() end)
                spectateConn = nil
            end
            if v then
                spectateConn = RunService.RenderStepped:Connect(function()
                    if not state.spectateTarget then
                        if spectateConn then spectateConn:Disconnect(); spectateConn = nil end
                        return
                    end
                    local target = findPlayer(state.targetUsername)
                    local hum = target and target.Character and target.Character:FindFirstChildOfClass("Humanoid")
                    if hum and hum.Health > 0 then
                        if CurrentCamera.CameraSubject ~= hum then
                            CurrentCamera.CameraSubject = hum
                        end
                    end
                end)
                trackConnection(spectateConn)
                local target = findPlayer(state.targetUsername)
                if target then log("Spectating: " .. target.Name) end
            else
                local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                if hum then CurrentCamera.CameraSubject = hum end
                log("Stopped spectating")
            end
        end
    })

    Tabs.Player:AddSlider("FlingForwardOffset", {
        Title = "Fling offset",
        Min = 0,
        Max = 10,
        Default = 6,
        Increment = 0.1,
        Rounding = 1,
        Suffix = " studs",
        Callback = function(val)
            state.flingForwardOffset = val
        end
    })

    Tabs.Player:AddSlider("FlingYOffset", {
        Title = "Fling head height offset",
        Min = -10,
        Max = 10,
        Default = 0,
        Increment = 0.1,
        Rounding = 1,
        Suffix = " studs",
        Callback = function(val)
            state.flingYOffset = val
            state.flingHeadHeight = val
        end
    })

    Tabs.Player:AddSlider("FlingYVelocityFactor", {
        Title = "Fling dynamic Y velocity",
        Min = 0,
        Max = 100,
        Default = 15,
        Increment = 1,
        Rounding = 0,
        Suffix = " %",
        Callback = function(val)
            state.flingYVelocityFactor = val / 100
        end
    })

    -- dispatch targeted flings against players
    Tabs.Player:AddButtonRow({
        { Text = "Fling target", Icon = "wind", Callback = function()
            local target, err = findPlayer(state.targetUsername)
            if not target then log("Fling stopped: " .. (err or "No target")); return end
            if not isPlayerAlive(target) then log("target died"); return end
            if not isPlayerAlive(LocalPlayer) then log("Cannot fling while dead"); return end
            local char = LocalPlayer.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local originalCF = hrp.CFrame
            log("Flinging: " .. target.Name)
            flingTarget(target, true)
            char = LocalPlayer.Character; hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = originalCF
                pcall(function() hrp.AssemblyLinearVelocity = Vector3.zero; hrp.AssemblyAngularVelocity = Vector3.zero end)
            end
            log("Fling done")
        end },
        { Text = "Fling murderer", Icon = "flame", Callback = function()
            local target = state.knifeHolder or getMurd()
            if not target then log("Murderer not found"); return end
            if not isPlayerAlive(target) then log("Murderer not alive"); return end
            if not isPlayerAlive(LocalPlayer) then log("Cannot fling while dead"); return end
            local char = LocalPlayer.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local originalCF = hrp.CFrame
            log("flinging murderer: " .. target.Name)
            flingTarget(target, true)
            char = LocalPlayer.Character; hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = originalCF
                pcall(function() hrp.AssemblyLinearVelocity = Vector3.zero; hrp.AssemblyAngularVelocity = Vector3.zero end)
            end
            log("Fling done")
        end },
        { Text = "Fling sheriff", Icon = "shield-alert", Callback = function()
            local target = state.gunHolder or getSheriff()
            if not target then log("Sheriff not found"); return end
            if not isPlayerAlive(target) then log("Sheriff not alive"); return end
            if not isPlayerAlive(LocalPlayer) then log("Cannot fling while dead"); return end
            local char = LocalPlayer.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local originalCF = hrp.CFrame
            log("flinging sheriff: " .. target.Name)
            flingTarget(target, true)
            char = LocalPlayer.Character; hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = originalCF
                pcall(function() hrp.AssemblyLinearVelocity = Vector3.zero; hrp.AssemblyAngularVelocity = Vector3.zero end)
            end
            log("Fling done")
        end }
    }, 31)

    -- construct murderer combat and kill-all controls
    Tabs.Murderer:AddSection("Murderer tools")

    -- provide quick actions for knife attacks
    Tabs.Murderer:AddButtonRow({
        { Text = "Kill all", Icon = "swords", Callback = function()
            if not isPlayerAlive(LocalPlayer) then log("Dead - cannot kill"); return end
            local char = LocalPlayer.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            local hum  = char and char:FindFirstChildOfClass("Humanoid")
            local knifeTool = getPlayerTool(LocalPlayer, "Knife")
            if not knifeTool or not hrp or not hum then log("No knife found"); return end
            hum:EquipTool(knifeTool)
            task.wait(0.1)
            local events = getKnifeEvents()
            if events then
                pcall(function() events.KnifeStabbed:FireServer() end)
                local count = 0
                for _, target in ipairs(Players:GetPlayers()) do
                    if target ~= LocalPlayer and isPlayerAlive(target) then
                        local tChar = target.Character
                        local tHrp  = tChar and tChar:FindFirstChild("HumanoidRootPart")
                        if tChar and tHrp then
                            local handle = nil
                            for _, acc in ipairs(tChar:GetChildren()) do
                                if acc:IsA("Accessory") then local h = acc:FindFirstChild("Handle"); if h then handle = h; break end end
                            end
                            handle = handle or tHrp
                            pcall(function() events.KnifeStabbed:FireServer() end)
                            pcall(function() events.HandleTouched:FireServer(handle) end)
                            local tKnifeLook = tHrp.CFrame.LookVector
                            local tKnifeStart = Vector3.new(tHrp.Position.X - tKnifeLook.X * 0.1, tHrp.Position.Y, tHrp.Position.Z - tKnifeLook.Z * 0.1)
                            pcall(function() events.KnifeThrown:FireServer(CFrame.new(tKnifeStart, tHrp.Position), CFrame.new(tHrp.Position)) end)
                            count = count + 1
                        end
                    end
                end
                log("Kill all executed on " .. count .. " players")
            end
        end },
        { Text = "Fling sheriff", Icon = "shield-alert", Callback = function()
            local target = state.gunHolder or getSheriff()
            if not target then log("Sheriff not found"); return end
            if not isPlayerAlive(target) then log("Sheriff not alive"); return end
            if not isPlayerAlive(LocalPlayer) then log("Cannot fling while dead"); return end
            local char = LocalPlayer.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local originalCF = hrp.CFrame
            log("flinging sheriff: " .. target.Name)
            flingTarget(target, true)
            char = LocalPlayer.Character; hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = originalCF
                pcall(function() hrp.AssemblyLinearVelocity = Vector3.zero; hrp.AssemblyAngularVelocity = Vector3.zero end)
            end
            log("Fling done")
        end }
    }, 24)

    Tabs.Murderer:AddToggleGroup({
        {
            Id = "KillAuraEnabled",
            Title = "Kill aura",
            Default = false,
            Slider = {
                Title = "Kill aura range",
                Min = 5,
                Max = 30,
                Default = 15,
                Suffix = " studs",
                Callback = function(v)
                    state.killAuraRange = v
                end
            },
            Callback = function(v)
                state.killAuraEnabled = v
                if v and state.killAuraParticleEnabled then
                    rebuildParticleAura()
                end
            end
        },
        {
            Id = "KillAuraVisible",
            Title = "Kill aura zone visible",
            Default = true,
            Callback = function(v)
                state.killAuraVisible = v
            end
        }
    })

    Tabs.Murderer:AddDropdown("KillAuraType", {
        Title = "Kill aura type",
        Values = { "Stab", "Throw" },
        Default = "Stab",
        Callback = function(v)
            state.killAuraType = v
        end
    })

    Tabs.Murderer:AddSection("Kill aura circle")

    Tabs.Murderer:AddToggle("KillAuraParticleEnabled", {
        Title = "Kill aura circle",
        Default = false,
        Callback = function(v)
            state.killAuraParticleEnabled = v
            if v then
                rebuildParticleAura()
            else
                cleanupParticleAura()
            end
        end
    })

    Tabs.Murderer:AddSlider("KillAuraParticleCount", {
        Title = "Circle layers",
        Min = 1,
        Max = 10,
        Default = 1,
        Increment = 1,
        Callback = function(v)
            state.killAuraParticleCount = v
            if state.killAuraParticleEnabled then
                rebuildParticleAura()
            end
        end
    })

    Tabs.Murderer:AddSlider("KillAuraParticleSpawnDelay", {
        Title = "Degree difference",
        Min = 0,
        Max = 360,
        Default = 0,
        Increment = 1,
        Suffix = "°",
        Callback = function(v)
            state.killAuraDegreeOffset = v
            state.killAuraParticleSpawnDelay = v
        end
    })

    Tabs.Murderer:AddSlider("KillAuraParticleHeightOffset", {
        Title = "Height difference",
        Min = -5,
        Max = 10,
        Default = 0,
        Increment = 0.1,
        Precision = 1,
        Suffix = " studs",
        Callback = function(v)
            state.killAuraHeightOffset = v
        end
    })

    Tabs.Murderer:AddSlider("KillAuraParticleSize", {
        Title = "Circle size",
        Min = 0.1,
        Max = 50,
        Default = 15,
        Increment = 0.1,
        Precision = 1,
        Suffix = " studs",
        Callback = function(v)
            state.killAuraParticleSize = v
            if state.killAuraParticleEnabled then
                for _, layer in ipairs(auraLayers) do
                    if layer.part and layer.part.Parent == workspace then
                        layer.part.Size = Vector3.new(v, 0.05, v)
                    end
                end
            end
        end
    })

    Tabs.Murderer:AddDropdown("KillAuraParticlePreset", {
        Title = "Circle texture",
        Values = {
            "Fade circle",
            "Telemon's fire circle",
            "Dashed circle",
            "Magic circle",
            "Custom"
        },
        Default = "Fade circle",
        Callback = function(v)
            state.killAuraParticlePreset = v
            local presetData = killAuraParticlePresets[v]
            if type(presetData) == "table" and presetData.isAnimated then
                state.killAuraParticleIsFlipbook = true
                if presetData.flipbookLayout then
                    state.killAuraParticleFlipbookLayout = presetData.flipbookLayout
                end
            end
            if state.killAuraParticleEnabled then
                rebuildParticleAura()
            end
        end
    })

    Tabs.Murderer:AddInput("KillAuraParticleCustomId", {
        Title = "Custom texture ID",
        Default = "",
        Placeholder = "58889937 or rbxassetid://...",
        Callback = function(text)
            state.killAuraParticleCustomId = text
            if state.killAuraParticleEnabled and state.killAuraParticlePreset == "Custom" then
                rebuildParticleAura()
            end
        end
    })

    Tabs.Murderer:AddToggle("KillAuraParticleIsFlipbook", {
        Title = "Particle flipbook animation",
        Default = state.killAuraParticleIsFlipbook,
        Callback = function(v)
            state.killAuraParticleIsFlipbook = v
            if state.killAuraParticleEnabled then
                rebuildParticleAura()
            end
        end
    })

    Tabs.Murderer:AddInput("KillAuraParticleFlipbookLayout", {
        Title = "Flipbook layout (grid)",
        Default = state.killAuraParticleFlipbookLayout or "Grid4x4",
        Placeholder = "Grid4x4 or 4x4, 8x8, 2x2",
        Callback = function(text)
            state.killAuraParticleFlipbookLayout = text
            if state.killAuraParticleEnabled then
                rebuildParticleAura()
            end
        end
    })

    Tabs.Murderer:AddDropdown("KillAuraParticleFlipbookMode", {
        Title = "Flipbook mode",
        Values = { "Loop", "OneShot", "PingPong" },
        Default = state.killAuraParticleFlipbookMode or "Loop",
        Callback = function(v)
            state.killAuraParticleFlipbookMode = v
            if state.killAuraParticleEnabled then
                rebuildParticleAura()
            end
        end
    })

    Tabs.Murderer:AddSlider("KillAuraParticleFlipbookSpeed", {
        Title = "Flipbook play speed",
        Min = 1,
        Max = 60,
        Default = state.killAuraParticleFlipbookSpeed or 15,
        Suffix = " FPS",
        Callback = function(v)
            state.killAuraParticleFlipbookSpeed = v
        end
    })

    Tabs.Murderer:AddDropdown("KillAuraParticleColorMode", {
        Title = "Color mode",
        Values = { "Normal", "Gradient", "Shift", "Rainbow" },
        Default = "Normal",
        Callback = function(v)
            state.killAuraParticleColorMode = v
            if state.killAuraParticleEnabled then
                rebuildParticleAura()
            end
        end
    })

    Tabs.Murderer:AddColorpicker("KillAuraParticleColor", {
        Title = "Circle color 1",
        Default = Color3.fromRGB(255, 255, 255),
        Callback = function(col)
            state.killAuraParticleColor = col
            if state.killAuraParticleEnabled then
                rebuildParticleAura()
            end
        end
    })

    Tabs.Murderer:AddColorpicker("KillAuraParticleColor2", {
        Title = "Circle color 2",
        Default = Color3.fromRGB(255, 0, 128),
        Callback = function(col)
            state.killAuraParticleColor2 = col
            if state.killAuraParticleEnabled then
                rebuildParticleAura()
            end
        end
    })

    Tabs.Murderer:AddSlider("KillAuraParticleMinSpin", {
        Title = "Min spin speed",
        Min = -360,
        Max = 360,
        Default = 0,
        Increment = 5,
        Suffix = "°/s",
        Callback = function(v)
            state.killAuraParticleMinSpin = v
            if state.killAuraParticleEnabled then
                randomizeLayerSpeeds()
            end
        end
    })

    Tabs.Murderer:AddSlider("KillAuraParticleMaxSpin", {
        Title = "Max spin speed",
        Min = -360,
        Max = 360,
        Default = 0,
        Increment = 5,
        Suffix = "°/s",
        Callback = function(v)
            state.killAuraParticleMaxSpin = v
            if state.killAuraParticleEnabled then
                randomizeLayerSpeeds()
            end
        end
    })

    Tabs.Murderer:AddSlider("KillAuraParticleTransparency", {
        Title = "Circle transparency",
        Min = 0,
        Max = 100,
        Default = 20,
        Increment = 1,
        Suffix = "%",
        Callback = function(v)
            state.killAuraParticleTransparency = v / 100
            if state.killAuraParticleEnabled then
                for _, layer in ipairs(auraLayers) do
                    if layer.imageLabel then
                        pcall(function() layer.imageLabel.ImageTransparency = state.killAuraParticleTransparency end)
                    end
                end
            end
        end
    })

    Tabs.Murderer:AddSlider("KillAuraParticleGlow", {
        Title = "Circle glow",
        Min = 0,
        Max = 100,
        Default = 100,
        Increment = 1,
        Suffix = "%",
        Callback = function(v)
            state.killAuraParticleGlow = v / 100
            if state.killAuraParticleEnabled then
                for _, layer in ipairs(auraLayers) do
                    if layer.surfaceGui then
                        pcall(function() layer.surfaceGui.Brightness = 1 + (state.killAuraParticleGlow * 2) end)
                    end
                end
            end
        end
    })

    Tabs.Sheriff:AddSection("Sheriff tools")

    -- construct sheriff shooting and role assist tools
    Tabs.Sheriff:AddButtonRow({
        { Text = "Wallbang murder", Icon = "crosshair", Callback = function()
            local murderer = state.knifeHolder or getMurd()
            if not murderer or not isPlayerAlive(murderer) then log("Murderer not found or dead"); return end
            local gunTool = getPlayerTool(LocalPlayer, "Gun")
            if not gunTool then log("No gun found!"); return end
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if not hum then return end
            if gunTool.Parent ~= char then
                hum:EquipTool(gunTool)
                task.wait(0.1)
            end
            local shootEvent = getGunShootEvent()
            local mChar = murderer.Character
            local mHead = mChar and mChar:FindFirstChild("Head")
            local mTorso = mChar and (mChar:FindFirstChild("UpperTorso") or mChar:FindFirstChild("Torso") or mChar:FindFirstChild("LowerTorso") or mChar:FindFirstChild("HumanoidRootPart"))
            if shootEvent and mTorso then
                local rawPos = mTorso.Position
                local predH, predV = getSilentAimPred()
                local targetPos = calculateAimPosition(rawPos, mTorso, predH, predV)
                local startPos = mHead and mHead.Position or (rawPos + Vector3.new(0, 1.5, 0))
                local startCF  = CFrame.new(startPos, targetPos)
                local targetCF = CFrame.new(targetPos)
                pcall(function()
                    shootEvent:FireServer(startCF, targetCF)
                end)
                log("Wallbanged murderer: " .. murderer.Name)
            end
        end },
        { Text = "Fling murderer", Icon = "flame", Callback = function()
            local target = state.knifeHolder or getMurd()
            if not target then log("Murderer not found"); return end
            if not isPlayerAlive(target) then log("Murderer not alive"); return end
            if not isPlayerAlive(LocalPlayer) then log("Cannot fling while dead"); return end
            local char = LocalPlayer.Character
            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
            if not hrp then return end
            local originalCF = hrp.CFrame
            log("flinging murderer: " .. target.Name)
            flingTarget(target, true)
            char = LocalPlayer.Character; hrp = char and char:FindFirstChild("HumanoidRootPart")
            if hrp then
                hrp.CFrame = originalCF
                pcall(function() hrp.AssemblyLinearVelocity = Vector3.zero; hrp.AssemblyAngularVelocity = Vector3.zero end)
            end
            log("Fling done")
        end }
    }, 24)

    Tabs.Sheriff:AddSection("Auto aim")
    Tabs.Sheriff:AddGroup({
        {
            Id = "AutoAimEnabled",
            Type = "Toggle",
            Title = "Auto aim",
            Description = "Always hits murderer with gun (no FOV needed)",
            Default = false,
            Callback = function(v)
                state.autoAimEnabled = v
                log("Auto aim: " .. (v and "on" or "off"))
            end
        },
        {
            Id = "AutoAimWallbang",
            Type = "Toggle",
            Title = "Wallbang",
            Description = "Shoots through walls with infinite map range",
            Default = false,
            Callback = function(v)
                state.autoAimWallbang = v
                silentAimConfig.wallbang = v
                log("Auto aim wallbang: " .. (v and "on" or "off"))
            end
        },
        {
            Id = "AutoAimHorizPred",
            Type = "Slider",
            Title = "Horizontal prediction",
            Description = "Lead moving targets horizontally (default 0.2)",
            Min = 0,
            Max = 200,
            Default = 16,
            Suffix = " %",
            Callback = function(val)
                local n = tonumber(val) or 0
                silentAimConfig.horizontalPrediction = n / 100
                silentAimConfig.predictionFactor = n / 100
            end
        },
        {
            Id = "AutoAimVertPred",
            Type = "Slider",
            Title = "Vertical prediction",
            Description = "Lead jumping/falling targets vertically (default 0.2)",
            Min = 0,
            Max = 200,
            Default = 13,
            Suffix = " %",
            Callback = function(val)
                local n = tonumber(val) or 0
                silentAimConfig.verticalPrediction = n / 100
            end
        }
    })


    Tabs.Player:AddSection("Silent aim")
    Tabs.Player:AddGroup({
        {
            Id = "SilentAimEnabled",
            Type = "Toggle",
            Title = "Silent aim",
            Default = false,
            Callback = function(v)
                silentAimConfig.enabled = v
                if not v then removeFOVCircle() end
            end
        },
        {
            Id = "SilentAimWallbang",
            Type = "Checkbox",
            Title = "Wallbang",
            Description = "Shoots through walls with infinite map range",
            Default = false,
            Callback = function(v)
                silentAimConfig.wallbang = v
                state.autoAimWallbang = v
            end
        },
        {
            Id = "SilentAimTargetPart",
            Type = "Dropdown",
            Title = "Target part",
            Values = {"Head", "HumanoidRootPart", "UpperTorso", "LowerTorso", "Random"},
            Default = "Head",
            Callback = function(selected)
                silentAimConfig.targetPart = selected
            end
        },
        {
            Id = "SilentAimHitChance",
            Type = "Slider",
            Title = "Hit chance",
            Min = 1,
            Max = 100,
            Default = 100,
            Suffix = "%",
            Callback = function(val)
                silentAimConfig.hitChance = val
            end
        },
        {
            Id = "SilentAimHorizPred",
            Type = "Slider",
            Title = "Horizontal prediction",
            Description = "Lead moving targets horizontally (default 0.2)",
            Min = 0,
            Max = 200,
            Default = 20,
            Suffix = " %",
            Callback = function(val)
                local n = tonumber(val) or 0
                silentAimConfig.horizontalPrediction = n / 100
                silentAimConfig.predictionFactor = n / 100
            end
        },
        {
            Id = "SilentAimVertPred",
            Type = "Slider",
            Title = "Vertical prediction",
            Description = "Lead jumping/falling targets vertically (default 0.2)",
            Min = 0,
            Max = 200,
            Default = 20,
            Suffix = " %",
            Callback = function(val)
                local n = tonumber(val) or 0
                silentAimConfig.verticalPrediction = n / 100
            end
        }
    })


    Tabs.Player:AddCheckbox("SilentAimWallCheck", {
        Title = "Wall check",
        Default = false,
        Callback = function(v)
            silentAimConfig.wallCheck = v
        end
    })

    Tabs.Player:AddCheckbox("SilentAimAliveCheck", {
        Title = "Alive check",
        Default = true,
        Callback = function(v)
            silentAimConfig.aliveCheck = v
        end
    })

    Tabs.Player:AddCheckbox("SilentAimRandomOffset", {
        Title = "Random offset",
        Default = false,
        Callback = function(v)
            silentAimConfig.randomOffset = v
        end
    })

    Tabs.Player:AddToggle("SilentAimFOVVisible", {
        Title = "Fov circle",
        Default = true,
        Slider = {
            Title = "Fov radius",
            Min = 20,
            Max = 600,
            Default = 125,
            Suffix = " px",
            Callback = function(val)
                silentAimConfig.fovRadius = val
            end
        },
        Callback = function(v)
            silentAimConfig.fovVisible = v
            if not v then removeFOVCircle() end
        end
    })

    local fovDropRow = Tabs.Player:AddRow(44, 8)
    fovDropRow:AddDropdown(
        "Fov shape",
        {"Normal", "Dots", "Dots out of dots", "Stripes"},
        "Normal",
        function(selected)
            silentAimConfig.fovType = selected
        end
    )
    fovDropRow:AddDropdown(
        "Color mode",
        {"Normal", "Rainbow", "Rainbow 2", "Shift", "Gradient"},
        "Normal",
        function(selected)
            silentAimConfig.colorMode = selected
        end
    )

    Tabs.Player:AddToggleGroup({
        {
            Title = "Spin fov",
            Default = false,
            Callback = function(v)
                silentAimConfig.spin = v
            end
        },
        {
            Title = "Fill fov",
            Default = false,
            Callback = function(v)
                silentAimConfig.filled = v
            end
        }
    })

    Tabs.Player:AddSlider("SilentAimSpinSpeed", {
        Title = "Spin speed",
        Min = 10,
        Max = 360,
        Default = 60,
        Suffix = "°/s",
        Callback = function(val)
            silentAimConfig.spinSpeed = val
        end
    })

    local fovColorRow = Tabs.Player:AddRow(44, 8)
    fovColorRow:AddColorPicker("Fov color", Color3.fromRGB(255, 60, 60), function(col)
        silentAimConfig.color1 = col
    end)
    fovColorRow:AddColorPicker("Fov secondary color", Color3.fromRGB(0, 170, 255), function(col)
        silentAimConfig.color2 = col
    end)

    Tabs.Player:AddSlider("SilentAimTransparency", {
        Title = "Fov transparency",
        Min = 0,
        Max = 100,
        Default = 0,
        Suffix = "%",
        Callback = function(v)
            silentAimConfig.transparency = v / 100
        end
    })

    Tabs.Player:AddToggle("SilentAimShadow", {
        Title = "Fov drop shadow",
        Default = false,
        Slider = {
            Title = "Fov shadow transparency",
            Min = 0,
            Max = 100,
            Default = 50,
            Suffix = "%",
            Callback = function(v)
                silentAimConfig.shadowTransparency = v / 100
            end
        },
        Callback = function(v)
            silentAimConfig.shadow = v
        end
    })
    
    local customSoundOriginals = setmetatable({}, { __mode = "k" })

    local function isOwnSoundInstance(sound)
        local char = LocalPlayer.Character
        if char and sound:IsDescendantOf(char) then return true end
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp and sound:IsDescendantOf(bp) then return true end
        local pg = LocalPlayer:FindFirstChild("PlayerGui")
        if pg and sound:IsDescendantOf(pg) then return true end
        if char then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and sound.Parent and sound.Parent:IsA("BasePart") then
                if (sound.Parent.Position - hrp.Position).Magnitude <= 20 then
                    return true
                end
            end
        end
        return false
    end

    local function getSoundType(sound)
        if not sound or not sound:IsA("Sound") then return nil end
        local name = sound.Name:lower()
        if name == "coinsound" then
            return "Coin"
        elseif name == "reload" then
            return "Reload"
        elseif name == "gunkill" or name == "hit" or name == "gunhit" or name == "bullethit" or name == "headshot" then
            return "GunKill"
        elseif name == "kill" or name == "knifekill" then
            return "KnifeKill"
        elseif name == "gunshot" or name == "shoot" or name == "shot" or name == "gunsound" or name == "shootsound" or name == "fire" then
            return "Gunshot"
        end
        return nil
    end

    local function applyCustomSoundInstanceDirect(cat, sound)
        if not sound or not sound:IsA("Sound") then return end
        local cfg = customSoundConfigs[cat]
        if not cfg then return end

        if not customSoundOriginals[sound] then
            customSoundOriginals[sound] = {
                SoundId = sound.SoundId,
                Volume = sound.Volume
            }
        end

        local isOwn = isOwnSoundInstance(sound)
        local shouldReplace = cfg.Enabled and (cfg.Target == "All" or isOwn)

        if shouldReplace then
            local targetId = formatCustomAssetId(cfg.SoundId or getActiveCustomSoundId(cat))
            if targetId ~= "" and sound.SoundId ~= targetId then
                sound.SoundId = targetId
            end
            local vol = cfg.Volume
            if vol then
                sound.Volume = vol
            end
        else
            local orig = customSoundOriginals[sound]
            if orig and sound.SoundId ~= orig.SoundId then
                sound.SoundId = orig.SoundId
                sound.Volume = orig.Volume
            end
        end
    end

    local function applyCustomSoundInstance(sound)
        local cat = getSoundType(sound)
        if not cat then return end
        applyCustomSoundInstanceDirect(cat, sound)
    end

    refreshCustomSounds = function()
        for _, cfg in pairs(customSoundConfigs) do
            local isEnabled = cfg.Enabled or cfg.enabled
            local sId = cfg.SoundId or cfg.soundId or ""
            if isEnabled and sId ~= "" then
                local formatted = formatCustomAssetId(sId)
                if formatted and formatted ~= "" then
                    task.spawn(function()
                        local s = Instance.new("Sound")
                        s.SoundId = formatted
                        pcall(function() ContentProvider:PreloadAsync({ s }) end)
                        s:Destroy()
                    end)
                end
            end
        end

        for _, sound in ipairs(Workspace:GetDescendants()) do
            if sound:IsA("Sound") and getSoundType(sound) then
                applyCustomSoundInstance(sound)
            end
        end
        local bp = LocalPlayer:FindFirstChild("Backpack")
        if bp then
            for _, sound in ipairs(bp:GetDescendants()) do
                if sound:IsA("Sound") and getSoundType(sound) then
                    applyCustomSoundInstance(sound)
                end
            end
        end
        local soundService = game:GetService("SoundService")
        for _, sound in ipairs(soundService:GetDescendants()) do
            if sound:IsA("Sound") and getSoundType(sound) then
                applyCustomSoundInstance(sound)
            end
        end
    end

    local customGunSoundConfig = customSoundConfigs.Gunshot

    local function applyGunSound(tool)
        if not tool or not tool:IsA("Tool") then return end

        if isGunTool(tool) then
            for _, s in ipairs(tool:GetDescendants()) do
                if s:IsA("Sound") then
                    local sType = getSoundType(s)
                    if sType then
                        applyCustomSoundInstance(s)
                    elseif s.Name ~= "Reload" and s.Name ~= "GunKill" and s.Name ~= "Kill" and s.Name ~= "Hit" and s.Name ~= "GunHit" and s.Name ~= "BulletHit" and s.Name ~= "Headshot" then
                        applyCustomSoundInstanceDirect("Gunshot", s)
                    end
                end
            end
        else
            for _, s in ipairs(tool:GetDescendants()) do
                if s:IsA("Sound") and getSoundType(s) then
                    applyCustomSoundInstance(s)
                end
            end
        end
    end

    local function hookGunSounds()
        if customGunSoundConfig.Target == "All" then
            for _, plr in ipairs(game:GetService("Players"):GetPlayers()) do
                if plr.Character then
                    for _, item in ipairs(plr.Character:GetChildren()) do
                        applyGunSound(item)
                    end
                end
                local bp = plr:FindFirstChild("Backpack")
                if bp then
                    for _, item in ipairs(bp:GetChildren()) do
                        applyGunSound(item)
                    end
                end
            end
        else
            local char = LocalPlayer.Character
            if char then
                for _, item in ipairs(char:GetChildren()) do
                    applyGunSound(item)
                end
            end
            local bp = LocalPlayer:FindFirstChild("Backpack")
            if bp then
                for _, item in ipairs(bp:GetChildren()) do
                    applyGunSound(item)
                end
            end
        end
        refreshCustomSounds()
    end

    local ownBpChildConn = nil
    local ownCharChildConn = nil

    local function setupBackpackListener(bp)
        if ownBpChildConn then pcall(function() ownBpChildConn:Disconnect() end) ownBpChildConn = nil end
        if bp then
            ownBpChildConn = bp.ChildAdded:Connect(function(tool)
                if customGunSoundConfig and customGunSoundConfig.Enabled then
                    task.wait(0.1)
                    applyGunSound(tool)
                end
            end)
        end
    end

    trackConnection(LocalPlayer.ChildAdded:Connect(function(child)
        if child.Name == "Backpack" then
            task.wait(0.2)
            hookGunSounds()
            setupBackpackListener(child)
        end
    end))

    if LocalPlayer:FindFirstChild("Backpack") then
        setupBackpackListener(LocalPlayer.Backpack)
    end

    trackConnection(LocalPlayer.CharacterAdded:Connect(function(char)
        if ownCharChildConn then pcall(function() ownCharChildConn:Disconnect() end) ownCharChildConn = nil end
        task.wait(0.5)
        hookGunSounds()
        ownCharChildConn = char.ChildAdded:Connect(function(child)
            if customGunSoundConfig and customGunSoundConfig.Enabled then
                task.wait(0.1)
                applyGunSound(child)
            end
        end)
    end))

    trackConnection(Workspace.DescendantAdded:Connect(function(descendant)
        if descendant:IsA("Sound") and getSoundType(descendant) then
            applyCustomSoundInstance(descendant)
        end
    end))

    trackConnection(game:GetService("SoundService").DescendantAdded:Connect(function(descendant)
        if descendant:IsA("Sound") and getSoundType(descendant) then
            applyCustomSoundInstance(descendant)
        end
    end))

    -- construct custom sound effect triggers
    Tabs.Sounds:AddSection("Gunshot sound")
    Tabs.Sounds:AddGroup({
        {
            Id = "CustomGunSoundEnabled",
            Type = "Toggle",
            Title = "Custom gun sound",
            Default = false,
            Slider = {
                Title = "Gun sound volume",
                Min = 0,
                Max = 150,
                Default = 100,
                Increment = 1,
                Suffix = "%",
                Callback = function(v)
                    customGunSoundConfig.Volume = v / 100
                    refreshCustomSounds()
                end
            },
            Callback = function(v)
                customGunSoundConfig.Enabled = v
                hookGunSounds()
                refreshCustomSounds()
            end
        },
        {
            Id = "CustomGunSoundPreset",
            Type = "Dropdown",
            Title = "Gun sound preset",
            Values = {"Minecraft", "Laser", "CS:GO Deagle", "Custom"},
            Default = "Minecraft",
            Callback = function(v)
                customGunSoundConfig.Preset = v
                customGunSoundConfig.SoundId = getActiveCustomSoundId("Gunshot")
                hookGunSounds()
                refreshCustomSounds()
            end
        },
        {
            Id = "CustomGunSoundTarget",
            Type = "Dropdown",
            Title = "Target",
            Values = {"Own", "All"},
            Default = "Own",
            Callback = function(v)
                customGunSoundConfig.Target = v
                hookGunSounds()
                refreshCustomSounds()
            end
        },
        {
            Id = "CustomGunSoundId",
            Type = "Input",
            Title = "Custom sound asset ID",
            Default = "",
            Placeholder = "7554632797",
            Callback = function(text)
                customGunSoundConfig.CustomId = text
                if customGunSoundConfig.Preset == "Custom" then
                    customGunSoundConfig.SoundId = text
                    hookGunSounds()
                    refreshCustomSounds()
                end
            end
        }
    })

    Tabs.Sounds:AddSection("Reload sound")
    Tabs.Sounds:AddGroup({
        {
            Id = "CustomReloadSoundEnabled",
            Type = "Toggle",
            Title = "Custom reload sound",
            Default = false,
            Slider = {
                Title = "Reload volume",
                Min = 0,
                Max = 150,
                Default = 100,
                Increment = 1,
                Suffix = "%",
                Callback = function(v)
                    customSoundConfigs.Reload.Volume = v / 100
                    refreshCustomSounds()
                end
            },
            Callback = function(v)
                customSoundConfigs.Reload.Enabled = v
                refreshCustomSounds()
            end
        },
        {
            Id = "CustomReloadSoundPreset",
            Type = "Dropdown",
            Title = "Preset",
            Values = {"Laser pistol", "Custom"},
            Default = "Laser pistol",
            Callback = function(v)
                customSoundConfigs.Reload.Preset = v
                customSoundConfigs.Reload.SoundId = getActiveCustomSoundId("Reload")
                refreshCustomSounds()
            end
        },
        {
            Id = "CustomReloadSoundTarget",
            Type = "Dropdown",
            Title = "Target",
            Values = {"Own", "All"},
            Default = "Own",
            Callback = function(v)
                customSoundConfigs.Reload.Target = v
                refreshCustomSounds()
            end
        },
        {
            Id = "CustomReloadSoundId",
            Type = "Input",
            Title = "Custom sound asset ID",
            Default = "",
            Placeholder = "1898332552",
            Callback = function(text)
                customSoundConfigs.Reload.CustomId = text
                if customSoundConfigs.Reload.Preset == "Custom" then
                    customSoundConfigs.Reload.SoundId = text
                    refreshCustomSounds()
                end
            end
        }
    })

    Tabs.Sounds:AddSection("Gun kill sound")
    Tabs.Sounds:AddGroup({
        {
            Id = "CustomGunKillSoundEnabled",
            Type = "Toggle",
            Title = "Custom gun kill sound",
            Default = false,
            Slider = {
                Title = "Gun kill volume",
                Min = 0,
                Max = 150,
                Default = 100,
                Increment = 1,
                Suffix = "%",
                Callback = function(v)
                    customSoundConfigs.GunKill.Volume = v / 100
                    refreshCustomSounds()
                end
            },
            Callback = function(v)
                customSoundConfigs.GunKill.Enabled = v
                refreshCustomSounds()
            end
        },
        {
            Id = "CustomGunKillSoundPreset",
            Type = "Dropdown",
            Title = "Preset",
            Values = {"Fortnite knocked", "CS:GO headshot", "Fatality", "Rust headshot", "Tom scream", "Old church bell", "Ouch", "Minecraft", "Death note", "Victory", "Stariy bog", "Stariy bog yaica", "Custom"},
            Default = "Fortnite knocked",
            Callback = function(v)
                customSoundConfigs.GunKill.Preset = v
                customSoundConfigs.GunKill.SoundId = getActiveCustomSoundId("GunKill")
                refreshCustomSounds()
            end
        },
        {
            Id = "CustomGunKillSoundTarget",
            Type = "Dropdown",
            Title = "Target",
            Values = {"Own", "All"},
            Default = "Own",
            Callback = function(v)
                customSoundConfigs.GunKill.Target = v
                refreshCustomSounds()
            end
        },
        {
            Id = "CustomGunKillSoundId",
            Type = "Input",
            Title = "Custom sound asset ID",
            Default = "",
            Placeholder = "118171751820277",
            Callback = function(text)
                customSoundConfigs.GunKill.CustomId = text
                if customSoundConfigs.GunKill.Preset == "Custom" then
                    customSoundConfigs.GunKill.SoundId = text
                    refreshCustomSounds()
                end
            end
        }
    })

    Tabs.Sounds:AddSection("Knife kill sound")
    Tabs.Sounds:AddGroup({
        {
            Id = "CustomKnifeKillSoundEnabled",
            Type = "Toggle",
            Title = "Custom knife kill sound",
            Default = false,
            Slider = {
                Title = "Knife kill volume",
                Min = 0,
                Max = 150,
                Default = 100,
                Increment = 1,
                Suffix = "%",
                Callback = function(v)
                    customSoundConfigs.KnifeKill.Volume = v / 100
                    refreshCustomSounds()
                end
            },
            Callback = function(v)
                customSoundConfigs.KnifeKill.Enabled = v
                refreshCustomSounds()
            end
        },
        {
            Id = "CustomKnifeKillSoundPreset",
            Type = "Dropdown",
            Title = "Preset",
            Values = {"Golden pan", "Orange water", "Bye bye", "Katana", "Knife slice", "Custom"},
            Default = "Golden pan",
            Callback = function(v)
                customSoundConfigs.KnifeKill.Preset = v
                customSoundConfigs.KnifeKill.SoundId = getActiveCustomSoundId("KnifeKill")
                refreshCustomSounds()
            end
        },
        {
            Id = "CustomKnifeKillSoundTarget",
            Type = "Dropdown",
            Title = "Target",
            Values = {"Own", "All"},
            Default = "Own",
            Callback = function(v)
                customSoundConfigs.KnifeKill.Target = v
                refreshCustomSounds()
            end
        },
        {
            Id = "CustomKnifeKillSoundId",
            Type = "Input",
            Title = "Custom sound asset ID",
            Default = "",
            Placeholder = "135260359985455",
            Callback = function(text)
                customSoundConfigs.KnifeKill.CustomId = text
                if customSoundConfigs.KnifeKill.Preset == "Custom" then
                    customSoundConfigs.KnifeKill.SoundId = text
                    refreshCustomSounds()
                end
            end
        }
    })

    Tabs.Sounds:AddSection("Coin pickup sound")
    Tabs.Sounds:AddGroup({
        {
            Id = "CustomCoinSoundEnabled",
            Type = "Toggle",
            Title = "Custom coin pickup sound",
            Default = false,
            Slider = {
                Title = "Coin sound volume",
                Min = 0,
                Max = 150,
                Default = 100,
                Increment = 1,
                Suffix = "%",
                Callback = function(v)
                    customSoundConfigs.Coin.Volume = v / 100
                    refreshCustomSounds()
                end
            },
            Callback = function(v)
                customSoundConfigs.Coin.Enabled = v
                refreshCustomSounds()
            end
        },
        {
            Id = "CustomCoinSoundPreset",
            Type = "Dropdown",
            Title = "Preset",
            Values = {"Ultrakill coinflip", "Coin click", "Coin click 2", "Custom"},
            Default = "Ultrakill coinflip",
            Callback = function(v)
                customSoundConfigs.Coin.Preset = v
                customSoundConfigs.Coin.SoundId = getActiveCustomSoundId("Coin")
                refreshCustomSounds()
            end
        },
        {
            Id = "CustomCoinSoundTarget",
            Type = "Dropdown",
            Title = "Target",
            Values = {"Own", "All"},
            Default = "Own",
            Callback = function(v)
                customSoundConfigs.Coin.Target = v
                refreshCustomSounds()
            end
        },
        {
            Id = "CustomCoinSoundId",
            Type = "Input",
            Title = "Custom sound asset ID",
            Default = "",
            Placeholder = "138571475125488",
            Callback = function(text)
                customSoundConfigs.Coin.CustomId = text
                if customSoundConfigs.Coin.Preset == "Custom" then
                    customSoundConfigs.Coin.SoundId = text
                    refreshCustomSounds()
                end
            end
        }
    })

    -- configure particle ribbons and orbiting spheres 
    local trailConfig = {
        enabled = false,
        colorMode = "Normal",
        color1 = Color3.fromRGB(0, 170, 255),
        color2 = Color3.fromRGB(255, 0, 128),
        color = Color3.fromRGB(0, 170, 255),
        lifetime = 1.0,
        width = 1.0,
        lightEmission = 0.5,
        transparency = 0,
    }

    local orbConfig = {
        enabled = false,
        colorMode = "Normal",
        color1 = Color3.fromRGB(0, 255, 170),
        color2 = Color3.fromRGB(255, 85, 0),
        speed = 4,
        radius = 3,
        size = 0.3,
        brightness = 1.43,
        range = 8
    }

    local localTrail = nil
    local localOrb = nil
    local orbRotationAngle = 0
    local function getTrailColors()
        local mode = trailConfig.colorMode
        local c1 = trailConfig.color1 or trailConfig.color or Color3.fromRGB(0, 170, 255)
        local c2 = trailConfig.color2 or Color3.fromRGB(255, 0, 128)
        local shiftSpeed = state and state.colorShiftSpeed or 3

        if mode == "Shift" then
            local tVal = (math.sin(tick() * shiftSpeed) + 1) * 0.5
            return ColorSequence.new(c1:Lerp(c2, tVal))
        elseif mode == "Gradient" then
            local tVal = (math.sin(tick() * shiftSpeed) + 1) / 2
            return ColorSequence.new(c1:Lerp(c2, tVal), c2:Lerp(c1, tVal))
        elseif mode == "Rainbow" then
            local hue = ((tick() * 0.45) % 1.0)
            return ColorSequence.new({
                ColorSequenceKeypoint.new(0,    Color3.fromHSV((hue + 0.00) % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.25, Color3.fromHSV((hue + 0.25) % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.50, Color3.fromHSV((hue + 0.50) % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.75, Color3.fromHSV((hue + 0.75) % 1, 1, 1)),
                ColorSequenceKeypoint.new(1,    Color3.fromHSV((hue + 1.00) % 1, 1, 1)),
            })
        elseif mode == "2 colors" then
            local tVal = (math.sin(tick() * shiftSpeed) + 1) / 2
            return ColorSequence.new(c1:Lerp(c2, tVal))
        else
            return ColorSequence.new(c1)
        end
    end

    -- attach decorative emitters to character limbs 
    local translucentBodyConfig = {
        enabled = false,
        colorMode = "Normal",
        color1 = Color3.fromRGB(255, 255, 255),
        color2 = Color3.fromRGB(0, 0, 0),
        color = Color3.fromRGB(255, 255, 255)
    }
    local originalBodyProperties = {}

    local function applyTranslucentBody()
        local char = LocalPlayer.Character
        if not char then return end

        if translucentBodyConfig.enabled then
            local bodyColor = getColor(
                translucentBodyConfig.colorMode or "Normal",
                translucentBodyConfig.color1 or translucentBodyConfig.color or Color3.fromRGB(255, 255, 255),
                translucentBodyConfig.color2 or Color3.fromRGB(0, 0, 0)
            )

            for _, part in ipairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    if not originalBodyProperties[part] then
                        originalBodyProperties[part] = {
                            Material = part.Material,
                            Color = part.Color,
                            Transparency = part.Transparency
                        }
                    end

                    if part.Name == "HumanoidRootPart" or part.Name == "KillAuraZone" or part.Name == "OrbitingOrb" then
                        part.Transparency = 1
                    else
                        part.Material = Enum.Material.ForceField
                        part.Transparency = 0.35
                        part.Color = bodyColor
                    end
                end
            end
        else
            for part, props in pairs(originalBodyProperties) do
                if part and part.Parent then
                    pcall(function()
                        part.Material = props.Material
                        part.Color = props.Color
                        part.Transparency = props.Transparency
                    end)
                end
            end
            table.clear(originalBodyProperties)
        end
    end

    -- configure particle preset parameters
    local BODY_PARTICLE_PRESETS = {
        ["Hexagon"] = {
            texture = "http://www.roblox.com/asset/?id=5021159599",
            isAnimated = false
        },
        ["Triangle"] = {
            texture = "http://www.roblox.com/asset/?id=4505798638",
            isAnimated = false
        },
        ["Heart"] = {
            texture = "http://www.roblox.com/asset/?id=241778280",
            isAnimated = false
        },
        ["Square"] = {
            texture = "http://www.roblox.com/asset/?id=642505794",
            isAnimated = false
        },
        ["Smoke (animated)"] = {
            texture = "http://www.roblox.com/asset/?id=8733226116",
            isAnimated = true,
            flipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
        },
        ["Pixel sparkle (animated)"] = {
            texture = "http://www.roblox.com/asset/?id=13448020277",
            isAnimated = true,
            flipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
        },
        ["Spinning robux (animated)"] = {
            texture = "http://www.roblox.com/asset/?id=12859930047",
            isAnimated = true,
            flipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
        },
        ["Bat (animated)"] = {
            texture = "http://www.roblox.com/asset/?id=117267873734624",
            isAnimated = true,
            flipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
        },
        ["Potion particle (animated)"] = {
            texture = "http://www.roblox.com/asset/?id=8733731095",
            isAnimated = true,
            flipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
        },
        ["Wingdings (animated)"] = {
            texture = "http://www.roblox.com/asset/?id=92668765537961",
            isAnimated = true,
            flipbookLayout = Enum.ParticleFlipbookLayout.Grid8x8
        },
        ["YouAreAnIdiot (animated)"] = {
            texture = "http://www.roblox.com/asset/?id=119483013767759",
            isAnimated = true,
            flipbookLayout = Enum.ParticleFlipbookLayout.Grid2x2
        },
        ["Eye (animated)"] = {
            texture = "http://www.roblox.com/asset/?id=136598435215978",
            isAnimated = true,
            flipbookLayout = Enum.ParticleFlipbookLayout.Grid8x8
        },
        ["Dollar (animated)"] = {
            texture = "http://www.roblox.com/asset/?id=17451596749",
            isAnimated = true,
            flipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
        },
        ["maxwell (animated)"] = {
            texture = "http://www.roblox.com/asset/?id=12890944256",
            isAnimated = true,
            flipbookLayout = Enum.ParticleFlipbookLayout.Grid4x4
        },
        ["Triangle shard (animated)"] = {
            texture = "http://www.roblox.com/asset/?id=79466620842369",
            isAnimated = true,
            flipbookLayout = Enum.ParticleFlipbookLayout.Grid8x8
        },
        ["Custom"] = {
            texture = "",
            isAnimated = false
        }
    }

    local VALID_BODY_PARTS = {
        ["Head"] = true,
        ["Torso"] = true,
        ["UpperTorso"] = true,
        ["LowerTorso"] = true,
        ["Left Arm"] = true,
        ["LeftUpperArm"] = true,
        ["LeftLowerArm"] = true,
        ["LeftHand"] = true,
        ["Right Arm"] = true,
        ["RightUpperArm"] = true,
        ["RightLowerArm"] = true,
        ["RightHand"] = true,
        ["Left Leg"] = true,
        ["LeftUpperLeg"] = true,
        ["LeftLowerLeg"] = true,
        ["LeftFoot"] = true,
        ["Right Leg"] = true,
        ["RightUpperLeg"] = true,
        ["RightLowerLeg"] = true,
        ["RightFoot"] = true
    }

    local bodyParticlesConfig = {
        enabled = false,
        preset = "Pixel sparkle (animated)",
        customTextureId = "",
        colorMode = "Normal",
        color1 = Color3.fromRGB(255, 255, 255),
        color2 = Color3.fromRGB(0, 0, 0),
        size = 0.2,
        transparency = 0,
        speed = 0.0,
        spin = 0,
        lifetime = 5,
        rate = 2,
        orientation = "Camera",
        glowing = false,
        anchored = false,
        fadeIn = true,
        fadeOut = true,
        isCustomFlipbook = false,
        customFlipbookLayout = "Grid4x4",
        customFlipbookMode = "Loop",
        flipbookPlaySpeed = 15
    }

    local bodyParticleEmitters = {}
    local bodySliceParts = {}
    local bodyContainerPart = nil
    local bodyContainerHeartbeat = nil

    local function removeBodyContainerPart()
        if bodyContainerHeartbeat then
            pcall(function() bodyContainerHeartbeat:Disconnect() end)
            bodyContainerHeartbeat = nil
        end
        for _, sInfo in ipairs(bodySliceParts) do
            if sInfo.part then
                pcall(function() sInfo.part:Destroy() end)
            end
        end
        table.clear(bodySliceParts)
        if bodyContainerPart then
            pcall(function() bodyContainerPart:Destroy() end)
            bodyContainerPart = nil
        end
        local char = LocalPlayer.Character
        if char then
            for _, desc in ipairs(char:GetChildren()) do
                if desc.Name == "BodyParticleContainerPart" or desc.Name == "BodyParticleSlice" then
                    pcall(function() desc:Destroy() end)
                end
            end
        end
    end

    local function removeBodyParticles()
        for _, emitter in ipairs(bodyParticleEmitters) do
            if emitter and emitter.Parent then
                pcall(function() emitter:Destroy() end)
            end
        end
        table.clear(bodyParticleEmitters)
        removeBodyContainerPart()

        local char = LocalPlayer.Character
        if char then
            for _, desc in ipairs(char:GetDescendants()) do
                if desc:IsA("ParticleEmitter") and desc.Name == "BodyParticleEmitter" then
                    pcall(function() desc:Destroy() end)
                end
            end
        end
    end

    local function getBodyBounds(char)
        if not char then return nil, nil end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return nil, nil end

        local hrpCF = hrp.CFrame

        local minX, maxX = math.huge, -math.huge
        local minY, maxY = math.huge, -math.huge
        local minZ, maxZ = math.huge, -math.huge
        local found = false

        for _, child in ipairs(char:GetChildren()) do
            if child:IsA("BasePart") and VALID_BODY_PARTS[child.Name] then
                found = true
                local pCF = child.CFrame
                local half = child.Size * 0.5
                for x = -1, 1, 2 do
                    for y = -1, 1, 2 do
                        for z = -1, 1, 2 do
                            local worldPt = pCF * Vector3.new(half.X * x, half.Y * y, half.Z * z)
                            local localPt = hrpCF:PointToObjectSpace(worldPt)
                            minX = math.min(minX, localPt.X)
                            maxX = math.max(maxX, localPt.X)
                            minY = math.min(minY, localPt.Y)
                            maxY = math.max(maxY, localPt.Y)
                            minZ = math.min(minZ, localPt.Z)
                            maxZ = math.max(maxZ, localPt.Z)
                        end
                    end
                end
            end
        end

        if not found then
            return hrpCF, Vector3.new(3.0, 5.0, 1.2)
        end

        local sizeX = math.clamp(maxX - minX, 1.5, 4.0)
        local sizeY = math.clamp(maxY - minY, 3.5, 6.0)
        local sizeZ = math.clamp(maxZ - minZ, 0.8, 2.5)

        local size = Vector3.new(sizeX, sizeY, sizeZ)
        local localCenter = Vector3.new((minX + maxX) * 0.5, (minY + maxY) * 0.5, (minZ + maxZ) * 0.5)
        local centerCF = hrpCF * CFrame.new(localCenter)

        return centerCF, size
    end

    local function getParticleColors(mode, c1, c2)
        local col1 = c1 or Color3.fromRGB(255, 0, 0)
        local col2 = c2 or Color3.fromRGB(0, 170, 255)
        local shiftSpeed = state and state.colorShiftSpeed or 3
        local phase = (tick() * (shiftSpeed * 0.15)) % 1.0

        if mode == "2 colors" then
            local tVal = (math.sin(tick() * shiftSpeed) + 1) / 2
            local cycled = col1:Lerp(col2, tVal)
            return ColorSequence.new(cycled)
        elseif mode == "Gradient" then
            local tVal = (math.sin(tick() * shiftSpeed) + 1) / 2
            local lerped1 = col1:Lerp(col2, tVal)
            local lerped2 = col2:Lerp(col1, tVal)
            return ColorSequence.new(lerped1, lerped2)
        elseif mode == "Gradient 2" then
            local function getSmoothCol(off)
                local tVal = (math.sin((phase + off) * math.pi * 2) + 1) * 0.5
                return col1:Lerp(col2, tVal)
            end
            return ColorSequence.new({
                ColorSequenceKeypoint.new(0,    getSmoothCol(0)),
                ColorSequenceKeypoint.new(0.25, getSmoothCol(0.25)),
                ColorSequenceKeypoint.new(0.5,  getSmoothCol(0.5)),
                ColorSequenceKeypoint.new(0.75, getSmoothCol(0.75)),
                ColorSequenceKeypoint.new(1,    getSmoothCol(1))
            })
        elseif mode == "Rainbow" then
            local hue = rainbowHue or ((tick() * 0.45) % 1.0)
            return ColorSequence.new({
                ColorSequenceKeypoint.new(0,    Color3.fromHSV((hue + 0.00) % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.17, Color3.fromHSV((hue + 0.17) % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.33, Color3.fromHSV((hue + 0.33) % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.50, Color3.fromHSV((hue + 0.50) % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.67, Color3.fromHSV((hue + 0.67) % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.83, Color3.fromHSV((hue + 0.83) % 1, 1, 1)),
                ColorSequenceKeypoint.new(1.00, Color3.fromHSV((hue + 1.00) % 1, 1, 1))
            })
        elseif mode == "Rainbow 2" then
            return ColorSequence.new({
                ColorSequenceKeypoint.new(0,    Color3.fromHSV((0.00 + phase) % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.17, Color3.fromHSV((0.17 + phase) % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.33, Color3.fromHSV((0.33 + phase) % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.50, Color3.fromHSV((0.50 + phase) % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.67, Color3.fromHSV((0.67 + phase) % 1, 1, 1)),
                ColorSequenceKeypoint.new(0.83, Color3.fromHSV((0.83 + phase) % 1, 1, 1)),
                ColorSequenceKeypoint.new(1.00, Color3.fromHSV((1.00 + phase) % 1, 1, 1))
            })
        else
            return ColorSequence.new(col1)
        end
    end

    local function applyBodyParticles()
        removeBodyParticles()

        if not bodyParticlesConfig.enabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local hrp = char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local centerCF, boxSize = getBodyBounds(char)
        if not centerCF or not boxSize then return end

        local container = Instance.new("Part")
        container.Name = "BodyParticleContainerPart"
        container.Size = boxSize
        container.CFrame = centerCF
        container.Transparency = 1
        container.CanCollide = false
        container.CanTouch = false
        container.CanQuery = false
        container.CastShadow = false
        container.Massless = true
        container.Anchored = false
        container.Parent = char

        bodyContainerPart = container

        
        container.Changed:Connect(function(prop)
            if prop == "Transparency" and container.Transparency ~= 1 then
                container.Transparency = 1
            end
            if prop == "CanCollide" and container.CanCollide ~= false then
                container.CanCollide = false
            end
            if prop == "CanTouch" and container.CanTouch ~= false then
                container.CanTouch = false
            end
            if prop == "CanQuery" and container.CanQuery ~= false then
                container.CanQuery = false
            end
        end)

        
        local _bodyHBFrame = 0
        local _cachedBodySize = nil
        bodyContainerHeartbeat = game:GetService("RunService").Heartbeat:Connect(function()
            if not container or not container.Parent then
                if bodyContainerHeartbeat then
                    bodyContainerHeartbeat:Disconnect()
                    bodyContainerHeartbeat = nil
                end
                return
            end
            local c = LocalPlayer.Character
            if not c then return end
            _bodyHBFrame = _bodyHBFrame + 1
            -- smooth container position without lag spikes
            local hrpPart = c:FindFirstChild("HumanoidRootPart")
            if not hrpPart then return end
            if _bodyHBFrame % 5 == 0 or not _cachedBodySize then
                local newCF, newSize = getBodyBounds(c)
                if newCF then
                    container.CFrame = newCF
                    if newSize and newSize ~= _cachedBodySize then
                        container.Size = newSize
                        _cachedBodySize = newSize
                        if #bodySliceParts > 0 then
                            local n = #bodySliceParts
                            local sW = newSize.X / n
                            for i, sInfo in ipairs(bodySliceParts) do
                                sInfo.offset = Vector3.new((i - (n + 1) * 0.5) * sW, 0, 0)
                                if sInfo.part and sInfo.part.Parent then
                                    sInfo.part.Size = Vector3.new(sW, newSize.Y, newSize.Z)
                                end
                            end
                        end
                    end
                end
            else
                -- anchor container to root part coordinates
                container.CFrame = hrpPart.CFrame
            end

            if #bodySliceParts > 0 then
                for _, sInfo in ipairs(bodySliceParts) do
                    if sInfo.part and sInfo.part.Parent then
                        sInfo.part.CFrame = container.CFrame * CFrame.new(sInfo.offset)
                    end
                end
            end

            if container.Transparency ~= 1 then container.Transparency = 1 end
            if container.CanCollide then container.CanCollide = false end
        end)

        local presetData = BODY_PARTICLE_PRESETS[bodyParticlesConfig.preset] or BODY_PARTICLE_PRESETS["Custom"]
        local textureUrl = presetData.texture or ""
        if bodyParticlesConfig.preset == "Custom" and bodyParticlesConfig.customTextureId and bodyParticlesConfig.customTextureId ~= "" then
            local raw = tostring(bodyParticlesConfig.customTextureId):gsub("%s+", "")
            local id = raw:match("(%d+)")
            if id and not raw:find("^http") then
                textureUrl = "rbxassetid://" .. id
            else
                textureUrl = raw
            end
        end

        local isAnim = presetData.isAnimated or bodyParticlesConfig.isCustomFlipbook

        local function getSafeEnum(enumType, memberName)
            if not memberName or type(memberName) ~= "string" then return nil end
            local ok, val = pcall(function()
                return enumType[memberName]
            end)
            if ok and val then return val end
            return nil
        end

        local function configureEmitter(emitter, rateToUse, colSeq)
            emitter.Name = "BodyParticleEmitter"
            emitter.Texture = textureUrl

            if isAnim then
                pcall(function()
                    local customStr = tostring(bodyParticlesConfig.customFlipbookLayout or "4x4"):gsub("%s+", "")
                    local customCols, customRows = customStr:match("^(%d+)[xX*:,](%d+)$")
                    if not customCols and customStr:match("^(%d+)$") then
                        local d = customStr:match("^(%d+)$")
                        customCols, customRows = d, d
                    end

                    local layoutToUse = presetData.flipbookLayout

                    if not layoutToUse or bodyParticlesConfig.preset == "Custom" or bodyParticlesConfig.isCustomFlipbook then
                        if customCols and customRows then
                            local c = tonumber(customCols)
                            local r = tonumber(customRows)
                            if c == 2 and r == 2 then
                                layoutToUse = Enum.ParticleFlipbookLayout.Grid2x2
                            elseif c == 4 and r == 4 then
                                layoutToUse = Enum.ParticleFlipbookLayout.Grid4x4
                            elseif c == 8 and r == 8 then
                                layoutToUse = Enum.ParticleFlipbookLayout.Grid8x8
                            else
                                local customEnum = getSafeEnum(Enum.ParticleFlipbookLayout, "Custom")
                                if customEnum then
                                    layoutToUse = customEnum
                                    pcall(function() emitter.FlipbookSize = Vector2.new(c, r) end)
                                else
                                    local maxDim = math.max(c, r)
                                    if maxDim <= 2 then
                                        layoutToUse = Enum.ParticleFlipbookLayout.Grid2x2
                                    elseif maxDim <= 4 then
                                        layoutToUse = Enum.ParticleFlipbookLayout.Grid4x4
                                    else
                                        layoutToUse = Enum.ParticleFlipbookLayout.Grid8x8
                                    end
                                    pcall(function() emitter.FlipbookSize = Vector2.new(c, r) end)
                                end
                            end
                        else
                            layoutToUse = getSafeEnum(Enum.ParticleFlipbookLayout, customStr) or Enum.ParticleFlipbookLayout.Grid4x4
                        end
                    end

                    if layoutToUse then
                        emitter.FlipbookLayout = layoutToUse
                    end

                    local modeToUse = presetData.flipbookMode or getSafeEnum(Enum.ParticleFlipbookMode, bodyParticlesConfig.customFlipbookMode) or Enum.ParticleFlipbookMode.Loop
                    emitter.FlipbookMode = modeToUse

                    local fps = tonumber(bodyParticlesConfig.flipbookPlaySpeed) or 15
                    emitter.FlipbookFramerate = NumberRange.new(fps)
                end)
            else
                pcall(function()
                    emitter.FlipbookLayout = Enum.ParticleFlipbookLayout.None
                end)
            end

            local sz = math.clamp(bodyParticlesConfig.size or 0.2, 0.01, 10.0)
            emitter.Size = NumberSequence.new(sz)

            local trans = bodyParticlesConfig.transparency or 0.2
            local fadeIn = bodyParticlesConfig.fadeIn
            local fadeOut = bodyParticlesConfig.fadeOut

            if fadeIn and fadeOut then
                emitter.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1.0),
                    NumberSequenceKeypoint.new(0.2, trans),
                    NumberSequenceKeypoint.new(0.8, trans),
                    NumberSequenceKeypoint.new(1, 1.0)
                })
            elseif fadeIn then
                emitter.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, 1.0),
                    NumberSequenceKeypoint.new(0.3, trans),
                    NumberSequenceKeypoint.new(1, trans)
                })
            elseif fadeOut then
                emitter.Transparency = NumberSequence.new({
                    NumberSequenceKeypoint.new(0, trans),
                    NumberSequenceKeypoint.new(1, 1.0)
                })
            else
                emitter.Transparency = NumberSequence.new(trans)
            end

            local spd = bodyParticlesConfig.speed or 0.0
            emitter.Speed = NumberRange.new(spd, spd)

            local rotSpd = bodyParticlesConfig.spin or 0
            emitter.RotSpeed = NumberRange.new(-rotSpd, rotSpd)

            local life = bodyParticlesConfig.lifetime or 1.5
            emitter.Lifetime = NumberRange.new(life * 0.8, life * 1.2)

            emitter.Rate = rateToUse

            if bodyParticlesConfig.glowing then
                emitter.LightEmission = 1.0
                emitter.LightInfluence = 0.0
            else
                emitter.LightEmission = 0.0
                emitter.LightInfluence = 1.0
            end

            if bodyParticlesConfig.anchored then
                emitter.LockedToPart = true
            else
                emitter.LockedToPart = false
            end

            local orientMode = bodyParticlesConfig.orientation or "Camera"
            pcall(function()
                if orientMode == "VelocityParallel" then
                    emitter.Orientation = Enum.ParticleOrientation.VelocityParallel
                elseif orientMode == "VelocityPerpendicular" then
                    emitter.Orientation = Enum.ParticleOrientation.VelocityPerpendicular
                else
                    emitter.Orientation = Enum.ParticleOrientation.Camera
                end
            end)

            emitter.Color = colSeq
        end

        local isRainbow2 = (bodyParticlesConfig.colorMode == "Rainbow 2")
        local numSlices = isRainbow2 and 5 or 1
        local sliceWidth = boxSize.X / numSlices
        local baseRate = bodyParticlesConfig.rate or 10
        local ratePerSlice = isRainbow2 and math.max(1, math.ceil(baseRate / numSlices)) or baseRate
        local shiftSpeed = state and state.colorShiftSpeed or 3
        local phase = (tick() * (shiftSpeed * 0.15)) % 1.0

        for i = 1, numSlices do
            local parentPart = container
            local colSeq = nil
            if isRainbow2 then
                local slice = Instance.new("Part")
                slice.Name = "BodyParticleSlice"
                slice.Size = Vector3.new(sliceWidth, boxSize.Y, boxSize.Z)
                local xOffset = (i - (numSlices + 1) * 0.5) * sliceWidth
                slice.CFrame = container.CFrame * CFrame.new(xOffset, 0, 0)
                slice.Transparency = 1
                slice.CanCollide = false
                slice.CanTouch = false
                slice.CanQuery = false
                slice.CastShadow = false
                slice.Massless = true
                slice.Anchored = false
                slice.Parent = container
                table.insert(bodySliceParts, {part = slice, offset = Vector3.new(xOffset, 0, 0)})
                parentPart = slice

                local frac = (i - 1) / numSlices
                local hue = (phase - frac) % 1.0
                if hue < 0 then hue = hue + 1 end
                colSeq = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, 1, 1)),
                    ColorSequenceKeypoint.new(1, Color3.fromHSV((hue + 0.1) % 1.0, 1, 1))
                })
            else
                colSeq = getParticleColors(bodyParticlesConfig.colorMode, bodyParticlesConfig.color1, bodyParticlesConfig.color2)
            end

            local emitter = Instance.new("ParticleEmitter")
            configureEmitter(emitter, ratePerSlice, colSeq)
            emitter.Parent = parentPart
            table.insert(bodyParticleEmitters, emitter)
        end
    end

    local function updateBodyParticlesColors()
        if not bodyParticlesConfig.enabled then return end
        local mode = bodyParticlesConfig.colorMode
        local shiftSpeed = state and state.colorShiftSpeed or 3
        local phase = (tick() * (shiftSpeed * 0.15)) % 1.0

        if mode == "Rainbow 2" and #bodyParticleEmitters > 1 then
            local n = #bodyParticleEmitters
            for i, emitter in ipairs(bodyParticleEmitters) do
                if emitter and emitter.Parent then
                    local frac = (i - 1) / n
                    local hue = (phase - frac) % 1.0
                    if hue < 0 then hue = hue + 1 end
                    emitter.Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromHSV(hue, 1, 1)),
                        ColorSequenceKeypoint.new(1, Color3.fromHSV((hue + 0.1) % 1.0, 1, 1))
                    })
                end
            end
        else
            for _, emitter in ipairs(bodyParticleEmitters) do
                if emitter and emitter.Parent then
                    emitter.Color = getParticleColors(bodyParticlesConfig.colorMode, bodyParticlesConfig.color1, bodyParticlesConfig.color2)
                end
            end
        end
    end

    local translucentDescConn = nil
    trackConnection(LocalPlayer.CharacterAdded:Connect(function(char)
        table.clear(originalBodyProperties)
        if translucentDescConn then pcall(function() translucentDescConn:Disconnect() end) translucentDescConn = nil end
        if translucentBodyConfig.enabled then
            task.wait(0.3)
            applyTranslucentBody()
            translucentDescConn = char.DescendantAdded:Connect(function(desc)
                if translucentBodyConfig.enabled and desc:IsA("BasePart") then
                    task.wait(0.05)
                    applyTranslucentBody()
                end
            end)
        end
        if bodyParticlesConfig.enabled then
            task.wait(0.3)
            applyBodyParticles()
        end
    end))

    local function removeAllTrails(char)
        localTrail = nil
        char = char or LocalPlayer.Character
        if char then
            for _, desc in ipairs(char:GetDescendants()) do
                if desc:IsA("Trail") and desc.Name == "Trail" then
                    pcall(function() desc:Destroy() end)
                elseif desc:IsA("Attachment") and (desc.Name == "TrailAtt1" or desc.Name == "TrailAtt2") then
                    pcall(function() desc:Destroy() end)
                end
            end
        end
    end

    local function applyTrail(char)
        char = char or LocalPlayer.Character
        if not char then return end
        removeAllTrails(char)
        local parentPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
        if not parentPart then return end
    
        local w = math.clamp(tonumber(trailConfig.width) or 1.0, 0.1, 10)
        local att1 = Instance.new("Attachment", parentPart)
        att1.Name = "TrailAtt1"
        att1.Position = Vector3.new(0, w, 0)
    
        local att2 = Instance.new("Attachment", parentPart)
        att2.Name = "TrailAtt2"
        att2.Position = Vector3.new(0, -w, 0)
    
        local t = Instance.new("Trail", parentPart)
        t.Name = "Trail"
        t.Attachment0 = att1
        t.Attachment1 = att2
        t.Texture = "rbxassetid://446111271"
        t.TextureMode = Enum.TextureMode.Stretch
        t.Color = getTrailColors()
        t.Lifetime = math.clamp(tonumber(trailConfig.lifetime) or 1.0, 0.05, 10)
        local trans = math.clamp(tonumber(trailConfig.transparency) or 0, 0, 0.95)
        t.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, trans), NumberSequenceKeypoint.new(1, 1) })
        t.LightEmission = 0.8
        t.LightInfluence = 0
        t.WidthScale = NumberSequence.new({ NumberSequenceKeypoint.new(0, 1), NumberSequenceKeypoint.new(1, 0.2) })
        t.FaceCamera = true
        localTrail = t
    end

    local function updateTrailProps()
        if not trailConfig.enabled then return end
        local char = LocalPlayer.Character
        if not char then return end
        local parentPart = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso")
        if not parentPart then return end

        local att1 = parentPart:FindFirstChild("TrailAtt1")
        local att2 = parentPart:FindFirstChild("TrailAtt2")
        if not localTrail or not localTrail.Parent or not att1 or not att2 then
            applyTrail(char)
            return
        end

        local w = math.clamp(tonumber(trailConfig.width) or 1.0, 0.1, 10)
        att1.Position = Vector3.new(0, w, 0)
        att2.Position = Vector3.new(0, -w, 0)
        localTrail.Texture = "rbxassetid://446111271"
        localTrail.TextureMode = Enum.TextureMode.Stretch
        localTrail.Color = getTrailColors()
        localTrail.Lifetime = math.clamp(tonumber(trailConfig.lifetime) or 1.0, 0.05, 10)
        local trans = math.clamp(tonumber(trailConfig.transparency) or 0, 0, 0.95)
        localTrail.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, trans), NumberSequenceKeypoint.new(1, 1) })
        localTrail.LightEmission = 0.8
        localTrail.LightInfluence = 0
    end

    local function removeOrb()
        if localOrb then
            pcall(function() localOrb:Destroy() end)
            localOrb = nil
        end
    end

    local function applyOrb()
        removeOrb()
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then return end

        local orb = Instance.new("Part")
        orb.Name = "OrbitingOrb"
        orb.Shape = Enum.PartType.Ball
        orb.Size = Vector3.new(orbConfig.size, orbConfig.size, orbConfig.size)
        orb.CanCollide = false
        orb.CanQuery   = false
        orb.CanTouch   = false
        orb.Anchored = true
        orb.Transparency = 1
        orb.Parent = char

        local bgui = Instance.new("BillboardGui", orb)
        bgui.Name = "OrbGui"
        bgui.Size = UDim2.new(orbConfig.size * 3, 0, orbConfig.size * 3, 0)
        bgui.AlwaysOnTop = false
        bgui.LightInfluence = 0

        local orbColor = getColor(orbConfig.colorMode, orbConfig.color1, orbConfig.color2)

        local img = Instance.new("ImageLabel", bgui)
        img.Name = "OrbImage"
        img.Size = UDim2.new(1, 0, 1, 0)
        img.BackgroundTransparency = 1
        img.Image = "http://www.roblox.com/asset/?id=112882057182762"
        img.ImageColor3 = orbColor
        img.Rotation = 0

        local light = Instance.new("PointLight", orb)
        light.Name = "OrbLight"
        light.Color = orbColor
        light.Brightness = orbConfig.brightness
        light.Range = orbConfig.range

        local att1 = Instance.new("Attachment", orb)
        att1.Name = "OrbAtt1"
        att1.Position = Vector3.new(0, orbConfig.size / 2, 0)

        local att2 = Instance.new("Attachment", orb)
        att2.Name = "OrbAtt2"
        att2.Position = Vector3.new(0, -orbConfig.size / 2, 0)

        local trail = Instance.new("Trail", orb)
        trail.Name = "OrbTrail"
        trail.Attachment0 = att1
        trail.Attachment1 = att2
        trail.Color = ColorSequence.new(orbColor)
        trail.Lifetime = 0.8
        trail.WidthScale = NumberSequence.new({
                NumberSequenceKeypoint.new(0, 0.8),
                NumberSequenceKeypoint.new(1, 0)
        })
        trail.LightEmission = 0.57
        trail.FaceCamera = true

        localOrb = orb
    end

    local crosshairConfig, updateCrosshair, removeCrosshair
    local visualHeartbeatConn = nil
    local function startVisualUpdates()
        if visualHeartbeatConn then return end
        local _vHBFrame = 0
        visualHeartbeatConn = RunService.Heartbeat:Connect(function(dt)
            if state.unloaded then
                if visualHeartbeatConn then pcall(function() visualHeartbeatConn:Disconnect() end) visualHeartbeatConn = nil end
                return
            end
            _vHBFrame = _vHBFrame + 1
            -- compute common transformation factors once per frame
            local speed = state and state.colorShiftSpeed or 3
            rainbowHue = (rainbowHue + dt * (speed * 0.15)) % 1.0
            _G.rainbowHue = rainbowHue
            local _t = tick()
            local _gradTVal = (math.sin(_t * speed) + 1) * 0.5

            if trailConfig.enabled and localTrail and localTrail.Parent then
                if trailConfig.colorMode ~= "Normal" then
                    localTrail.Color = getTrailColors()
                end
            end

            -- throttle palette updates for body, particles, and hat
            if _vHBFrame % 3 == 0 then
                if translucentBodyConfig.enabled and translucentBodyConfig.colorMode ~= "Normal" then
                    applyTranslucentBody()
                end

                if bodyParticlesConfig.enabled and bodyParticlesConfig.colorMode ~= "Normal" then
                    updateBodyParticlesColors()
                end

                if chinaHatConfig.enabled then
                    updateHatColors()
                end
            end

            if wingsConfig.enabled then
                local flapSpeed = wingsConfig.speed or 3.5
                local flapAngle = math.sin(_t * flapSpeed) * math.rad(14)
                -- avoid redundant palette calculations across wings
                local curColor = getColor(wingsConfig.colorMode, wingsConfig.color1, wingsConfig.color2)

                local targetList = wingsConfig.selfOnly and { LocalPlayer } or Players:GetPlayers()
                for _, player in ipairs(targetList) do
                    local char = player.Character
                    local root = char and (char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart"))
                    local w = wingsParts[player]
                    if root and (not w or not w.left or not w.left.Parent or w.left.Parent ~= char) then
                        applyWings(player, char)
                        w = wingsParts[player]
                    end
                    if root and w and w.left and w.left.Parent and w.right and w.right.Parent then
                        local zCompensation = math.sin(_t * flapSpeed) * -0.23
                        local xCompensation = math.sin(_t * flapSpeed) * 0.12
                        local backCF = root.CFrame * CFrame.new(0, wingsConfig.posY, wingsConfig.posZ)

                        w.left.CFrame  = backCF * CFrame.new(-wingsConfig.posX - xCompensation, 0, zCompensation) * CFrame.Angles(0, math.rad(15) - flapAngle, math.rad(-5))
                        w.right.CFrame = backCF * CFrame.new(wingsConfig.posX + xCompensation, 0, zCompensation) * CFrame.Angles(0, math.rad(-15) + flapAngle, math.rad(5))

                        w.left.CanCollide = false
                        w.right.CanCollide = false
                        w.left.Transparency  = wingsConfig.transparency
                        w.right.Transparency = wingsConfig.transparency

                        w.left.Color  = curColor
                        w.right.Color = curColor

                        if w.emitterL then w.emitterL.Color = ColorSequence.new(curColor) end
                        if w.emitterR then w.emitterR.Color = ColorSequence.new(curColor) end
                        if w.lightL then w.lightL.Color = curColor end
                        if w.lightR then w.lightR.Color = curColor end
                    end
                end
            end

            if orbConfig.enabled then
                local char = LocalPlayer.Character
                local hrp = char and char:FindFirstChild("HumanoidRootPart")
                if hrp then
                    if not localOrb or localOrb.Parent ~= char then
                        applyOrb()
                    end

                    if localOrb then
                        orbRotationAngle = (orbRotationAngle + dt * orbConfig.speed) % (math.pi * 2)
                        local t = _t
                        local radius = orbConfig.radius

                        local maxTiltRad = math.rad(25)
                        local tiltAngle  = math.sin(t * 0.5) * maxTiltRad

                        local horizRadius = math.cos(tiltAngle) * radius
                        local vertOffset  = math.sin(tiltAngle) * radius * math.sin(orbRotationAngle)

                        local offset = Vector3.new(
                            math.cos(orbRotationAngle) * horizRadius,
                            vertOffset,
                            math.sin(orbRotationAngle) * horizRadius
                        )
                        localOrb.Position = hrp.Position + Vector3.new(0, 0.5, 0) + offset

                        -- live-apply size changes from slider
                        local curSize = orbConfig.size
                        if localOrb.Size.X ~= curSize then
                            localOrb.Size = Vector3.new(curSize, curSize, curSize)
                            local bgui2 = localOrb:FindFirstChild("OrbGui")
                            if bgui2 then bgui2.Size = UDim2.new(curSize * 3, 0, curSize * 3, 0) end
                            local a1 = localOrb:FindFirstChild("OrbAtt1")
                            local a2 = localOrb:FindFirstChild("OrbAtt2")
                            if a1 then a1.Position = Vector3.new(0,  curSize / 2, 0) end
                            if a2 then a2.Position = Vector3.new(0, -curSize / 2, 0) end
                        end

                        local bgui = localOrb:FindFirstChild("OrbGui")
                        local img = bgui and bgui:FindFirstChild("OrbImage")
                        if img then
                            img.Rotation = (img.Rotation + dt * 180) % 360
                        end

                        local currentOrbColor = getColor(orbConfig.colorMode, orbConfig.color1, orbConfig.color2)
                        local light = localOrb:FindFirstChild("OrbLight")
                        local trail = localOrb:FindFirstChild("OrbTrail")

                        if img then img.ImageColor3 = currentOrbColor end
                        if light then light.Color = currentOrbColor end

                        if img then
                            if orbConfig.colorMode == "Gradient" or orbConfig.colorMode == "Gradient 2" or orbConfig.colorMode == "Rainbow" or orbConfig.colorMode == "Rainbow 2" then
                                local uiGrad = img:FindFirstChildOfClass("UIGradient")
                                if not uiGrad then
                                    uiGrad = Instance.new("UIGradient")
                                    uiGrad.Parent = img
                                end
                                local c1 = orbConfig.color1 or Color3.new(1, 1, 1)
                                local c2 = orbConfig.color2 or Color3.new(0, 170, 255)
                                local phase = (tick() * (speed * 0.15)) % 1.0

                                if orbConfig.colorMode == "Gradient" then
                                    uiGrad.Enabled = true
                                    uiGrad.Rotation = (uiGrad.Rotation + dt * (speed * 60)) % 360
                                    uiGrad.Color = ColorSequence.new({
                                        ColorSequenceKeypoint.new(0, c1),
                                        ColorSequenceKeypoint.new(0.5, c2),
                                        ColorSequenceKeypoint.new(1, c1)
                                    })
                                    img.ImageColor3 = Color3.new(1, 1, 1)
                                elseif orbConfig.colorMode == "Gradient 2" then
                                    uiGrad.Enabled = true
                                    uiGrad.Rotation = 0
                                    local function getSmoothCol(off)
                                        local tVal = (math.sin((phase + off) * math.pi * 2) + 1) * 0.5
                                        return c1:Lerp(c2, tVal)
                                    end
                                    uiGrad.Color = ColorSequence.new({
                                        ColorSequenceKeypoint.new(0,    getSmoothCol(0)),
                                        ColorSequenceKeypoint.new(0.25, getSmoothCol(0.25)),
                                        ColorSequenceKeypoint.new(0.5,  getSmoothCol(0.5)),
                                        ColorSequenceKeypoint.new(0.75, getSmoothCol(0.75)),
                                        ColorSequenceKeypoint.new(1,    getSmoothCol(1))
                                    })
                                    img.ImageColor3 = Color3.new(1, 1, 1)
                                elseif orbConfig.colorMode == "Rainbow" then
                                    uiGrad.Enabled = true
                                    uiGrad.Rotation = (uiGrad.Rotation + dt * (speed * 60)) % 360
                                    uiGrad.Color = ColorSequence.new({
                                        ColorSequenceKeypoint.new(0,    Color3.fromHSV(0.00, 1, 1)),
                                        ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17, 1, 1)),
                                        ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
                                        ColorSequenceKeypoint.new(0.50, Color3.fromHSV(0.50, 1, 1)),
                                        ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67, 1, 1)),
                                        ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
                                        ColorSequenceKeypoint.new(1.00, Color3.fromHSV(1.00, 1, 1))
                                    })
                                    img.ImageColor3 = Color3.new(1, 1, 1)
                                elseif orbConfig.colorMode == "Rainbow 2" then
                                    uiGrad.Enabled = true
                                    uiGrad.Rotation = 0
                                    uiGrad.Color = ColorSequence.new({
                                        ColorSequenceKeypoint.new(0,    Color3.fromHSV((0.00 + phase) % 1, 1, 1)),
                                        ColorSequenceKeypoint.new(0.17, Color3.fromHSV((0.17 + phase) % 1, 1, 1)),
                                        ColorSequenceKeypoint.new(0.33, Color3.fromHSV((0.33 + phase) % 1, 1, 1)),
                                        ColorSequenceKeypoint.new(0.50, Color3.fromHSV((0.50 + phase) % 1, 1, 1)),
                                        ColorSequenceKeypoint.new(0.67, Color3.fromHSV((0.67 + phase) % 1, 1, 1)),
                                        ColorSequenceKeypoint.new(0.83, Color3.fromHSV((0.83 + phase) % 1, 1, 1)),
                                        ColorSequenceKeypoint.new(1.00, Color3.fromHSV((1.00 + phase) % 1, 1, 1))
                                    })
                                    img.ImageColor3 = Color3.new(1, 1, 1)
                                end
                            else
                                local oldGrad = img:FindFirstChildOfClass("UIGradient")
                                if oldGrad then oldGrad.Enabled = false end
                                img.ImageColor3 = currentOrbColor
                            end
                        end

                        if trail then
                            trail.Color = getParticleColors(orbConfig.colorMode, orbConfig.color1, orbConfig.color2)
                        end
                    end
                else
                    removeOrb()
                end
            else
                removeOrb()
            end

            if trailConfig.enabled and localTrail and localTrail.Parent then
                local cMode = trailConfig.colorMode
                if cMode == "Rainbow" or cMode == "Rainbow 2" or cMode == "Shift" or cMode == "2 colors" or cMode == "Gradient" or cMode == "Gradient 2" then
                    localTrail.Color = getTrailColors()
                end
            end

            if chinaHatConfig.enabled then
                if updateHatColors then updateHatColors() end
                if chinaHatConfig.followHead and updateHatPositions then updateHatPositions() end
            end
            if wingsConfig.enabled then
                if updateWings then updateWings() end
            end
        end)
        trackConnection(visualHeartbeatConn)
    end

-- jump ring visual effect under feet
local jumpRingConfig = {
    enabled = false,
    colorMode = "Rainbow 1",
    color1 = Color3.fromRGB(255, 255, 255),
    color2 = Color3.fromRGB(0, 170, 255),
    maxSize = 7.5,
    initialSize = 1.5,
    duration = 0.6,
    transparency = 0.1,
    glow = 1.0,
}

local lastJumpRingTick = 0
local function spawnJumpRing()
    if not jumpRingConfig.enabled or (state and state.unloaded) then return end
    if not isPlayerAlive(LocalPlayer) then return end
    local now = tick()
    if now - lastJumpRingTick < 0.15 then return end
    lastJumpRingTick = now

    local char = LocalPlayer.Character
    local hrp  = char and char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end

    local groundCF = getGroundCFrame(char, hrp)
    local textureId = formatCustomAssetId("112096280571499") -- Fade circle
    local initialSize = jumpRingConfig.initialSize or 1.5
    local targetMaxSize = jumpRingConfig.maxSize or 7.5
    local duration = jumpRingConfig.duration or 0.6
    local initTransparency = jumpRingConfig.transparency or 0.1
    local speed = (state and state.colorShiftSpeed) or 3

    local part = Instance.new("Part")
    part.Name = "JumpRing"
    part.Transparency = 1
    part.CanCollide = false
    part.CanTouch = false
    part.CanQuery = false
    part.CastShadow = false
    part.Anchored = true
    part.Size = Vector3.new(initialSize, 0.05, initialSize)
    part.CFrame = groundCF
    part.Parent = workspace

    local sg = Instance.new("SurfaceGui")
    sg.Name = "JumpRingGui"
    sg.Face = Enum.NormalId.Top
    sg.LightInfluence = 0
    sg.AlwaysOnTop = false
    sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    sg.SizingMode = Enum.SurfaceGuiSizingMode.FixedSize
    sg.CanvasSize = Vector2.new(1024, 1024)
    sg.Brightness = 1 + ((jumpRingConfig.glow or 1) * 2)
    sg.Adornee = part
    sg.Parent = part

    local img = Instance.new("ImageLabel")
    img.Name = "JumpRingImage"
    img.Size = UDim2.fromScale(1, 1)
    img.Position = UDim2.fromScale(0.5, 0.5)
    img.AnchorPoint = Vector2.new(0.5, 0.5)
    img.BackgroundTransparency = 1
    img.Image = textureId
    img.ImageTransparency = initTransparency
    img.ScaleType = Enum.ScaleType.Fit
    img.Parent = sg

    local uiAspect = Instance.new("UIAspectRatioConstraint")
    uiAspect.AspectRatio = 1
    uiAspect.DominantAxis = Enum.DominantAxis.Width
    uiAspect.AspectType = Enum.AspectType.FitWithinMaxSize
    uiAspect.Parent = img

    local uiGrad = Instance.new("UIGradient")
    uiGrad.Name = "JumpRingGradient"
    uiGrad.Parent = img

    table.insert(activeJumpRings, part)

    task.spawn(function()
        local spawnTime = tick()
        while (tick() - spawnTime < duration) and part and part.Parent and not (state and state.unloaded) do
            local elapsed = tick() - spawnTime
            local progress = math.clamp(elapsed / duration, 0, 1)

            -- starts smaller then grows larger smoothly
            local easeProgress = 1 - (1 - progress) * (1 - progress)
            local currentSize = initialSize + (targetMaxSize - initialSize) * easeProgress
            part.Size = Vector3.new(currentSize, 0.05, currentSize)

            -- fade away smoothly after early expansion
            local fadeProgress = math.clamp((progress - 0.25) / 0.75, 0, 1)
            local currentTransparency = initTransparency + (1 - initTransparency) * (fadeProgress ^ 1.6)
            img.ImageTransparency = math.clamp(currentTransparency, 0, 1)

            -- color modes: Gradient, Shift, Rainbow 1, Rainbow 2, Normal (same as killaura circle)
            local phase = (tick() * (speed * 0.2)) % 1.0
            local mode = jumpRingConfig.colorMode or "Rainbow 1"
            local c1 = jumpRingConfig.color1 or Color3.fromRGB(255, 255, 255)
            local c2 = jumpRingConfig.color2 or Color3.fromRGB(0, 170, 255)

            if mode == "Gradient" or mode == "Gradient 2" then
                uiGrad.Enabled = true
                uiGrad.Rotation = 0
                local function getSmoothCol(off)
                    local tVal = (math.sin((phase - off) * math.pi * 2) + 1) * 0.5
                    return c1:Lerp(c2, tVal)
                end
                uiGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0,    getSmoothCol(0)),
                    ColorSequenceKeypoint.new(0.25, getSmoothCol(0.25)),
                    ColorSequenceKeypoint.new(0.5,  getSmoothCol(0.5)),
                    ColorSequenceKeypoint.new(0.75, getSmoothCol(0.75)),
                    ColorSequenceKeypoint.new(1,    getSmoothCol(1))
                })
                img.ImageColor3 = Color3.new(1, 1, 1)
            elseif mode == "Rainbow" or mode == "Rainbow 1" then
                uiGrad.Enabled = true
                uiGrad.Rotation = 0
                local function getRainbowCol(off)
                    return Color3.fromHSV((phase - off) % 1, 1, 1)
                end
                uiGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0,    getRainbowCol(0)),
                    ColorSequenceKeypoint.new(0.17, getRainbowCol(0.17)),
                    ColorSequenceKeypoint.new(0.33, getRainbowCol(0.33)),
                    ColorSequenceKeypoint.new(0.50, getRainbowCol(0.50)),
                    ColorSequenceKeypoint.new(0.67, getRainbowCol(0.67)),
                    ColorSequenceKeypoint.new(0.83, getRainbowCol(0.83)),
                    ColorSequenceKeypoint.new(1.00, getRainbowCol(1))
                })
                img.ImageColor3 = Color3.new(1, 1, 1)
            elseif mode == "Rainbow 2" then
                uiGrad.Enabled = true
                uiGrad.Rotation = (uiGrad.Rotation + 3) % 360
                uiGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0,    Color3.fromHSV((0.00 + phase) % 1, 1, 1)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromHSV((0.17 + phase) % 1, 1, 1)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromHSV((0.33 + phase) % 1, 1, 1)),
                    ColorSequenceKeypoint.new(0.50, Color3.fromHSV((0.50 + phase) % 1, 1, 1)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromHSV((0.67 + phase) % 1, 1, 1)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromHSV((0.83 + phase) % 1, 1, 1)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromHSV((1.00 + phase) % 1, 1, 1))
                })
                img.ImageColor3 = Color3.new(1, 1, 1)
            elseif mode == "Shift" then
                uiGrad.Enabled = false
                local shiftFactor = (math.sin(tick() * speed) + 1) * 0.5
                img.ImageColor3 = c1:Lerp(c2, shiftFactor)
            else
                uiGrad.Enabled = false
                img.ImageColor3 = c1
            end

            RunService.Heartbeat:Wait()
        end

        pcall(function() part:Destroy() end)
        local idx = table.find(activeJumpRings, part)
        if idx then table.remove(activeJumpRings, idx) end
    end)
end

local function bindJumpRingCharacter(char)
    if not char then return end
    local hum = char:WaitForChild("Humanoid", 3)
    if not hum then return end
    trackPlayerConnection(LocalPlayer, hum.StateChanged:Connect(function(oldState, newState)
        if newState == Enum.HumanoidStateType.Jumping then
            spawnJumpRing()
        end
    end))
    trackPlayerConnection(LocalPlayer, hum.Jumping:Connect(function(isActive)
        if isActive then
            spawnJumpRing()
        end
    end))
end

if LocalPlayer.Character then
    bindJumpRingCharacter(LocalPlayer.Character)
end
trackConnection(LocalPlayer.CharacterAdded:Connect(function(newChar)
    bindJumpRingCharacter(newChar)
end))

trackConnection(UserInputService.JumpRequest:Connect(function()
    if isPlayerAlive(LocalPlayer) then
        local hum = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum and (hum:GetState() == Enum.HumanoidStateType.Running or hum.FloorMaterial ~= Enum.Material.Air) then
            spawnJumpRing()
        end
    end
end))

    startVisualUpdates()

    trackConnection(LocalPlayer.CharacterAdded:Connect(function(char)
        task.wait(0.5)
        if trailConfig.enabled then
            pcall(function() applyTrail(char) end)
        end
        if orbConfig.enabled then
            pcall(function() applyOrb() end)
        end
    end))

    registerCleanupHook(function()
        local char = LocalPlayer.Character
        if char then
            removeAllTrails(char)
            removeOrb()
        end
        if removeCrosshair then pcall(removeCrosshair) end
    end)

    -- draw customizable center-screen reticle 
    removeCrosshair = nil
    local crosshairPresets = {
        ["Heart"]                  = { texture = "rbxassetid://11754490323" },
        ["Parenthesis"]            = { texture = "rbxassetid://10872863389" },
        [">.<"]                    = { texture = "rbxassetid://10831379335" },
        ["somename (animated)"]    = { texture = "http://www.roblox.com/asset/?id=77885757570841", isAnimated = true, gridX = 4, gridY = 4, fps = 15 },
        ["shockwave (animated)"]   = { texture = "http://www.roblox.com/asset/?id=9872919636", isAnimated = true, gridX = 4, gridY = 4, fps = 15 },
        ["pixel shockwave (animated)"] = { texture = "http://www.roblox.com/asset/?id=11817698226", isAnimated = true, gridX = 8, gridY = 8, fps = 20 },
        ["maxwell (animated)"]     = { texture = "http://www.roblox.com/asset/?id=12890944256", isAnimated = true, gridX = 4, gridY = 4, fps = 15 }
    }

    crosshairConfig = {
        enabled = false,
        preset = "Parenthesis",
        customAssetId = "",
        size = 50,
        color = Color3.fromRGB(255, 255, 255),
        color1 = Color3.fromRGB(255, 255, 255),
        color2 = Color3.fromRGB(0, 170, 255),
        colorMode = "Normal",
        transparency = 0,
        followCursor = false,
        spinEnabled = false,
        spinSpeed = 180,
        rainbowEnabled = false,
        isCustomFlipbook = false,
        customFlipbookLayout = "Grid4x4",
        customFlipbookMode = "Loop",
        flipbookPlaySpeed = 15
    }

    local crosshairGui = nil
    local crosshairImage = nil
    local crosshairConn = nil
    local crosshairThread = nil

    local function formatAssetId(rawInput)
        if not rawInput or rawInput == "" then return "" end
        local id = rawInput:match("%d+")
        if id then
            return "rbxassetid://" .. id
        end
        return rawInput
    end

    local function getCrosshairData()
        if crosshairConfig.preset == "Custom" then
            local data = { texture = formatAssetId(crosshairConfig.customAssetId) }
            if crosshairConfig.isCustomFlipbook then
                data.isAnimated = true
                local customStr = tostring(crosshairConfig.customFlipbookLayout or "4x4"):gsub("%s+", "")
                local cols, rows = customStr:match("^(%d+)[xX*:,](%d+)$")
                if not cols and customStr:match("^(%d+)$") then
                    local d = customStr:match("^(%d+)$")
                    cols, rows = d, d
                end
                data.gridX = tonumber(cols) or 4
                data.gridY = tonumber(rows) or 4
                data.fps = tonumber(crosshairConfig.flipbookPlaySpeed) or 15
                data.flipbookMode = crosshairConfig.customFlipbookMode or "Loop"
            end
            return data
        end
        local data = crosshairPresets[crosshairConfig.preset] or { texture = "rbxassetid://10872863389" }
        local res = {}
        for k, v in pairs(data) do res[k] = v end
        if res.isAnimated then
            if crosshairConfig.flipbookPlaySpeed then res.fps = crosshairConfig.flipbookPlaySpeed end
            res.flipbookMode = crosshairConfig.customFlipbookMode or "Loop"
        end
        return res
    end

    local function getCrosshairAsset()
        local data = getCrosshairData()
        return data.texture or "rbxassetid://10872863389"
    end

    updateCrosshair = nil
    local createCrosshair = function() if updateCrosshair then updateCrosshair() end end

    removeCrosshair = function()
        if crosshairConn then
            pcall(function() crosshairConn:Disconnect() end)
            crosshairConn = nil
        end
        if crosshairThread then
            pcall(function() task.cancel(crosshairThread) end)
            crosshairThread = nil
        end
        if crosshairImage then
            pcall(function() crosshairImage:Destroy() end)
            crosshairImage = nil
        end
        pcall(function() UserInputService.MouseIconEnabled = true end)
        pcall(function()
            local m = LocalPlayer:GetMouse()
            if m then m.Icon = "" end
        end)
        pcall(function() UserInputService.MouseIcon = "" end)
    end

    updateCrosshair = function()
        removeCrosshair()
        if not crosshairConfig.enabled then return end

        if not fovCircleGui or not fovCircleGui.Parent then
            local parentGui = gethui and gethui() or (pcall(function() return game:GetService("CoreGui") end) and game:GetService("CoreGui") or PlayerGui)
            local sg = Instance.new("ScreenGui")
            sg.Name = "FOVCircleGui"
            sg.ResetOnSpawn = false
            sg.IgnoreGuiInset = true
            sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
            sg.DisplayOrder = 2147483647
            pcall(function()
                if syn and syn.protect_gui then syn.protect_gui(sg) end
            end)
            sg.Parent = parentGui
            fovCircleGui = sg
        end

        local img = Instance.new("ImageLabel")
        img.Name = "CrosshairImage"
        img.AnchorPoint = Vector2.new(0.5, 0.5)
        img.BackgroundTransparency = 1
        img.Active = false
        img.Size = UDim2.fromOffset(crosshairConfig.size, crosshairConfig.size)
        img.Position = UDim2.new(0.5, 0, 0.5, 0)
        img.Image = getCrosshairAsset()
        img.ImageColor3 = getColor(crosshairConfig.colorMode, crosshairConfig.color1, crosshairConfig.color2)
        img.ImageTransparency = crosshairConfig.transparency
        img.ZIndex = 2147483647
        img.Parent = fovCircleGui

        crosshairGui = fovCircleGui
        crosshairImage = img

        local frameIndex = 0
        local lastFrameTime = tick()
        local pingPongForward = true

        crosshairConn = RunService.RenderStepped:Connect(function(dt)
            if not crosshairConfig.enabled or not crosshairImage or not crosshairImage.Parent then return end
            
            local data = getCrosshairData()
            local assetId = data.texture or "rbxassetid://10872863389"
            crosshairImage.Image = assetId
            crosshairImage.Size = UDim2.fromOffset(crosshairConfig.size, crosshairConfig.size)
            crosshairImage.ImageTransparency = crosshairConfig.transparency

            -- animate flipbook textures across frames
            if data.isAnimated and data.gridX and data.gridY then
                local fps = data.fps or 15
                local interval = 1 / fps
                if tick() - lastFrameTime >= interval then
                    lastFrameTime = tick()
                    local totalFrames = data.gridX * data.gridY
                    local mode = data.flipbookMode or crosshairConfig.customFlipbookMode or "Loop"

                    if mode == "OneShot" then
                        frameIndex = math.min(frameIndex + 1, totalFrames - 1)
                    elseif mode == "PingPong" then
                        if pingPongForward then
                            frameIndex = frameIndex + 1
                            if frameIndex >= totalFrames - 1 then
                                frameIndex = totalFrames - 1
                                pingPongForward = false
                            end
                        else
                            frameIndex = frameIndex - 1
                            if frameIndex <= 0 then
                                frameIndex = 0
                                pingPongForward = true
                            end
                        end
                    else -- loop sprite playback continuously
                        frameIndex = (frameIndex + 1) % totalFrames
                    end
                end
                local col = frameIndex % data.gridX
                local row = math.floor(frameIndex / data.gridX)
                pcall(function()
                    if crosshairImage.ContentImageSize and crosshairImage.ContentImageSize.X > 0 then
                        local imgW = crosshairImage.ContentImageSize.X
                        local imgH = crosshairImage.ContentImageSize.Y
                        local frameW = imgW / data.gridX
                        local frameH = imgH / data.gridY
                        crosshairImage.ImageRectSize = Vector2.new(frameW, frameH)
                        crosshairImage.ImageRectOffset = Vector2.new(col * frameW, row * frameH)
                    else
                        local frameW = 256 / data.gridX
                        local frameH = 256 / data.gridY
                        crosshairImage.ImageRectSize = Vector2.new(frameW, frameH)
                        crosshairImage.ImageRectOffset = Vector2.new(col * frameW, row * frameH)
                    end
                end)
            else
                crosshairImage.ImageRectSize = Vector2.zero
                crosshairImage.ImageRectOffset = Vector2.zero
            end

            local uiGrad = crosshairImage:FindFirstChildOfClass("UIGradient")
            if not uiGrad then
                uiGrad = Instance.new("UIGradient")
                uiGrad.Name = "CrosshairGradient"
                uiGrad.Parent = crosshairImage
            end

            local mode = crosshairConfig.colorMode or "Normal"
            local c1 = crosshairConfig.color1 or Color3.fromRGB(255, 255, 255)
            local c2 = crosshairConfig.color2 or Color3.fromRGB(0, 170, 255)
            local speed = state and state.colorShiftSpeed or 3
            local phase = (tick() * (speed * 0.15)) % 1.0

            if mode == "Gradient" then
                uiGrad.Enabled = true
                uiGrad.Rotation = (uiGrad.Rotation + dt * (speed * 60)) % 360
                uiGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, c1),
                    ColorSequenceKeypoint.new(0.5, c2),
                    ColorSequenceKeypoint.new(1, c1)
                })
                crosshairImage.ImageColor3 = Color3.new(1, 1, 1)
            elseif mode == "Gradient 2" then
                uiGrad.Enabled = true
                uiGrad.Rotation = 0
                local function getSmoothCol(off)
                    local tVal = (math.sin((phase - off) * math.pi * 2) + 1) * 0.5
                    return c1:Lerp(c2, tVal)
                end
                uiGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0,    getSmoothCol(0)),
                    ColorSequenceKeypoint.new(0.25, getSmoothCol(0.25)),
                    ColorSequenceKeypoint.new(0.5,  getSmoothCol(0.5)),
                    ColorSequenceKeypoint.new(0.75, getSmoothCol(0.75)),
                    ColorSequenceKeypoint.new(1,    getSmoothCol(1))
                })
                crosshairImage.ImageColor3 = Color3.new(1, 1, 1)
            elseif mode == "Shift" then
                uiGrad.Enabled = true
                uiGrad.Rotation = 0
                local function shiftCol(off)
                    local tVal = (math.sin((phase - off) * math.pi * 2) + 1) * 0.5
                    return c1:Lerp(c2, tVal)
                end
                uiGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0,    shiftCol(0)),
                    ColorSequenceKeypoint.new(0.25, shiftCol(0.25)),
                    ColorSequenceKeypoint.new(0.5,  shiftCol(0.5)),
                    ColorSequenceKeypoint.new(0.75, shiftCol(0.75)),
                    ColorSequenceKeypoint.new(1,    shiftCol(1))
                })
                crosshairImage.ImageColor3 = Color3.new(1, 1, 1)
            elseif mode == "Rainbow" then
                uiGrad.Enabled = true
                uiGrad.Rotation = (uiGrad.Rotation + dt * (speed * 60)) % 360
                uiGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0,    Color3.fromHSV(0.00, 1, 1)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromHSV(0.17, 1, 1)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromHSV(0.33, 1, 1)),
                    ColorSequenceKeypoint.new(0.50, Color3.fromHSV(0.50, 1, 1)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromHSV(0.67, 1, 1)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromHSV(0.83, 1, 1)),
                    ColorSequenceKeypoint.new(1.00, Color3.fromHSV(1.00, 1, 1))
                })
                crosshairImage.ImageColor3 = Color3.new(1, 1, 1)
            elseif mode == "Rainbow 2" then
                uiGrad.Enabled = true
                uiGrad.Rotation = 0
                local function getRainbowCol(off)
                    return Color3.fromHSV((phase - off) % 1, 1, 1)
                end
                uiGrad.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0,    getRainbowCol(0)),
                    ColorSequenceKeypoint.new(0.17, getRainbowCol(0.17)),
                    ColorSequenceKeypoint.new(0.33, getRainbowCol(0.33)),
                    ColorSequenceKeypoint.new(0.50, getRainbowCol(0.50)),
                    ColorSequenceKeypoint.new(0.67, getRainbowCol(0.67)),
                    ColorSequenceKeypoint.new(0.83, getRainbowCol(0.83)),
                    ColorSequenceKeypoint.new(1.00, getRainbowCol(1))
                })
                crosshairImage.ImageColor3 = Color3.new(1, 1, 1)
            else
                uiGrad.Enabled = false
                crosshairImage.ImageColor3 = getColor(mode, c1, c2)
            end

            if crosshairConfig.followCursor then
                pcall(function() UserInputService.MouseIconEnabled = false end)
                local mouseLoc = UserInputService:GetMouseLocation()
                crosshairImage.Position = UDim2.fromOffset(mouseLoc.X, mouseLoc.Y)
            else
                pcall(function() UserInputService.MouseIconEnabled = true end)
                crosshairImage.Position = UDim2.new(0.5, 0, 0.5, 0)
            end

            if crosshairConfig.spinEnabled then
                crosshairImage.Rotation = (crosshairImage.Rotation + dt * crosshairConfig.spinSpeed) % 360
            end
        end)
        trackConnection(crosshairConn)
    end




    -- construct visual esp and chams configurations
    Tabs.Visuals:AddSection("Value calculator")
    Tabs.Visuals:AddToggle("ValueCalculatorEnabled", {
        Title = "Trade & inventory values",
        Default = true,
        Callback = function(v)
            state.valueCalculatorEnabled = v
        end
    })

    Tabs.Visuals:AddSection("Player esp")

    -- group visual tracking checkboxes
    Tabs.Visuals:AddToggleGroup({
        { Name = "Enable ESP", Default = false, Callback = function(v) state.espEnabled = v end },
        { Name = "Esp chams", Default = true, Callback = function(v) state.chamsEnabled = v end },
        { Name = "Esp box", Default = false, Callback = function(v) state.boxEspEnabled = v end },
        { Name = "Esp skeleton", Default = false, Callback = function(v) state.skeletonEspEnabled = v end },
        { Name = "Esp name", Default = true, Callback = function(v) state.nameEspEnabled = v end },
        { Name = "Esp role", Default = true, Callback = function(v) state.roleEspEnabled = v end },
        { Name = "Gun ESP", Default = true, Callback = function(v) state.gunEspEnabled = v end }
    })

    Tabs.Visuals:AddDropdown("SkeletonColorMode", {
        Title = "Skeleton color mode",
        Values = {"Normal", "Shift", "Gradient", "Rainbow"},
        Default = "Normal",
        Callback = function(v)
            state.skeletonColorMode = v
        end
    })

    Tabs.Visuals:AddToggle("SkeletonUseRoleColor", {
        Title = "Skeleton use role color",
        Default = true,
        Callback = function(v)
            state.skeletonUseRoleColor = v
        end
    })

    Tabs.Visuals:AddGroup({
        {
            Id = "SkeletonColor1",
            Type = "ColorPicker",
            Title = "Skeleton primary color",
            Default = Color3.fromRGB(255, 255, 255),
            Callback = function(c) state.skeletonColor = c end
        },
        {
            Id = "SkeletonColor2",
            Type = "ColorPicker",
            Title = "Skeleton secondary color",
            Default = Color3.fromRGB(0, 170, 255),
            Callback = function(c) state.skeletonColor2 = c end
        }
    })

    Tabs.Visuals:AddSlider("SkeletonThickness", {
        Title = "Skeleton line thickness",
        Min = 1,
        Max = 4,
        Default = 1.5,
        Increment = 0.5,
        Rounding = 1,
        Callback = function(v)
            state.skeletonThickness = v
        end
    })

    Tabs.Visuals:AddSlider("SkeletonTransparency", {
        Title = "Skeleton transparency",
        Min = 0,
        Max = 1,
        Default = 0,
        Increment = 0.05,
        Rounding = 2,
        Callback = function(v)
            state.skeletonTransparency = v
        end
    })

    Tabs.Visuals:AddSlider("ESPMaxDistance", {
        Title = "Esp max render distance",
        Min = 100,
        Max = 5000,
        Default = 1000,
        Suffix = " studs",
        Callback = function(v)
            state.espMaxDistance = v
        end
    })

    Tabs.Visuals:AddDropdown("ChamsMode", {
        Title = "Chams mode",
        Values = {"Highlight", "Glow Outline", "Fill Only", "Box Adornment"},
        Default = "Highlight",
        Callback = function(v)
            state.chamsMode = v
        end
    })

    Tabs.Visuals:AddGroup({
        {
            Id = "ChamsMurdererColor",
            Type = "ColorPicker",
            Title = "Murderer chams color",
            Default = Color3.fromRGB(255, 70, 70),
            Callback = function(c) state.chamsMurdererColor = c end
        },
        {
            Id = "ChamsSheriffColor",
            Type = "ColorPicker",
            Title = "Sheriff chams color",
            Default = Color3.fromRGB(90, 120, 255),
            Callback = function(c) state.chamsSheriffColor = c end
        },
        {
            Id = "ChamsInnocentColor",
            Type = "ColorPicker",
            Title = "Innocent chams color",
            Default = Color3.fromRGB(50, 230, 110),
            Callback = function(c) state.chamsInnocentColor = c end
        }
    })

    Tabs.Visuals:AddSlider("ChamsFillTransparency", {
        Title = "Highlight fill transparency",
        Min = 0,
        Max = 1,
        Default = 0.45,
        Increment = 0.05,
        Rounding = 2,
        Callback = function(v)
            state.chamsFillTransparency = v
            -- force redraw on all existing highlights next frame
            for _, d in pairs(espPlayers) do
                d.LastRoleColor = nil
                d.LastChamsMode = nil
            end
        end
    })

    Tabs.Visuals:AddSlider("ChamsOutlineTransparency", {
        Title = "Highlight outline transparency",
        Min = 0,
        Max = 1,
        Default = 0,
        Increment = 0.05,
        Rounding = 2,
        Callback = function(v)
            state.chamsOutlineTransparency = v
            for _, d in pairs(espPlayers) do
                d.LastRoleColor = nil
                d.LastChamsMode = nil
            end
        end
    })

    Tabs.Visuals:AddSection("Body stuff")

    Tabs.Visuals:AddGroup({
        {
            Id = "TranslucentBodyEnabled",
            Type = "Toggle",
            Title = "Translucent body",
            Default = false,
            Callback = function(v)
                translucentBodyConfig.enabled = v
                applyTranslucentBody()
            end
        },
        {
            Id = "TranslucentBodyColorMode",
            Type = "Dropdown",
            Title = "Body color mode",
            Values = {"Normal", "Rainbow", "Shift", "Gradient"},
            Default = "Normal",
            Callback = function(v)
                translucentBodyConfig.colorMode = v
                applyTranslucentBody()
            end
        },
        {
            Id = "TranslucentBodyColor1",
            Type = "ColorPicker",
            Title = "Body primary color",
            Default = Color3.fromRGB(0, 170, 255),
            Callback = function(c)
                translucentBodyConfig.color1 = c
                applyTranslucentBody()
            end
        },
        {
            Id = "TranslucentBodyColor2",
            Type = "ColorPicker",
            Title = "Body secondary color",
            Default = Color3.fromRGB(255, 0, 128),
            Callback = function(c)
                translucentBodyConfig.color2 = c
                applyTranslucentBody()
            end
        }
    })

    Tabs.Visuals:AddGroup({
        {
            Id = "BodyParticlesEnabled",
            Type = "Toggle",
            Title = "Body particles",
            Default = false,
            Callback = function(v)
                bodyParticlesConfig.enabled = v
                if v then applyBodyParticles() else removeBodyParticles() end
            end
        },
        {
            Id = "BodyParticlesPreset",
            Type = "Dropdown",
            Title = "Particle preset",
            Values = {
                "Hexagon",
                "Triangle",
                "Heart",
                "Square",
                "Smoke (animated)",
                "Pixel sparkle (animated)",
                "Spinning robux (animated)",
                "Bat (animated)",
                "Potion particle (animated)",
                "Wingdings (animated)",
                "YouAreAnIdiot (animated)",
                "Eye (animated)",
                "Dollar (animated)",
                "maxwell (animated)",
                "Triangle shard (animated)",
                "Custom"
            },
            Default = "Pixel sparkle (animated)",
            Callback = function(v)
                bodyParticlesConfig.preset = v
                applyBodyParticles()
            end
        },
        {
            Id = "BodyParticlesCustomId",
            Type = "Input",
            Title = "Custom particle asset id",
            Default = "",
            Placeholder = "rbxassetid://...",
            Callback = function(text)
                bodyParticlesConfig.customTextureId = text
                applyBodyParticles()
            end
        }
    })

    Tabs.Visuals:AddGroup({
        {
            Id = "BodyParticlesCustomFlipbook",
            Type = "Toggle",
            Title = "Particle flipbook animation",
            Default = false,
            Callback = function(v)
                bodyParticlesConfig.isCustomFlipbook = v
                applyBodyParticles()
            end
        },
        {
            Id = "BodyParticlesFlipbookLayout",
            Type = "Input",
            Title = "Flipbook layout (grid)",
            Default = "Grid4x4",
            Placeholder = "Grid2x2, Grid4x4, Grid8x8",
            Callback = function(text)
                bodyParticlesConfig.customFlipbookLayout = text
                applyBodyParticles()
            end
        },
        {
            Id = "BodyParticlesFlipbookMode",
            Type = "Dropdown",
            Title = "Flipbook mode",
            Values = {"Loop", "OneShot", "PingPong"},
            Default = "Loop",
            Callback = function(v)
                bodyParticlesConfig.customFlipbookMode = v
                applyBodyParticles()
            end
        },
        {
            Id = "BodyParticlesFlipbookSpeed",
            Type = "Slider",
            Title = "Flipbook play speed",
            Min = 1,
            Max = 60,
            Default = 15,
            Suffix = " fps",
            Callback = function(v)
                bodyParticlesConfig.flipbookPlaySpeed = v
                applyBodyParticles()
            end
        }
    })

    Tabs.Visuals:AddGroup({
        {
            Id = "BodyParticlesColorMode",
            Type = "Dropdown",
            Title = "Particle color mode",
            Values = {"Normal", "Rainbow", "Rainbow 2", "Shift", "Gradient"},
            Default = "Normal",
            Callback = function(v)
                bodyParticlesConfig.colorMode = v
                applyBodyParticles()
            end
        },
        {
            Id = "BodyParticlesColor1",
            Type = "ColorPicker",
            Title = "Particle primary color",
            Default = Color3.fromRGB(255, 255, 255),
            Callback = function(c)
                bodyParticlesConfig.color1 = c
                applyBodyParticles()
            end
        },
        {
            Id = "BodyParticlesColor2",
            Type = "ColorPicker",
            Title = "Particle secondary color",
            Default = Color3.fromRGB(0, 0, 0),
            Callback = function(c)
                bodyParticlesConfig.color2 = c
                applyBodyParticles()
            end
        }
    })

    Tabs.Visuals:AddSlider("BodyParticlesSize", {
        Title = "Particle size",
        Min = 0.01,
        Max = 3,
        Default = 0.2,
        Increment = 0.01,
        Rounding = 2,
        Suffix = "",
        Callback = function(v)
            bodyParticlesConfig.size = v
            applyBodyParticles()
        end
    })

    Tabs.Visuals:AddSlider("BodyParticlesTransparency", {
        Title = "Particle transparency",
        Min = 0,
        Max = 100,
        Default = 0,
        Suffix = "%",
        Callback = function(v)
            bodyParticlesConfig.transparency = v / 100
            applyBodyParticles()
        end
    })

    Tabs.Visuals:AddSlider("BodyParticlesSpeed", {
        Title = "Particle speed",
        Min = -10,
        Max = 10,
        Default = 0,
        Increment = 0.1,
        Rounding = 1,
        Suffix = "",
        Callback = function(v)
            bodyParticlesConfig.speed = v
            applyBodyParticles()
        end
    })

    Tabs.Visuals:AddSlider("BodyParticlesSpin", {
        Title = "Particle spin",
        Min = -360,
        Max = 360,
        Default = 0,
        Suffix = " deg/s",
        Callback = function(v)
            bodyParticlesConfig.spin = v
            applyBodyParticles()
        end
    })

    Tabs.Visuals:AddSlider("BodyParticlesLifetime", {
        Title = "Particle lifetime",
        Min = 0.1,
        Max = 20,
        Default = 5,
        Increment = 0.1,
        Rounding = 1,
        Suffix = " s",
        Callback = function(v)
            bodyParticlesConfig.lifetime = v
            applyBodyParticles()
        end
    })

    Tabs.Visuals:AddSlider("BodyParticlesRate", {
        Title = "Particle emission rate",
        Min = 1,
        Max = 50,
        Default = 2,
        Callback = function(v)
            bodyParticlesConfig.rate = v
            applyBodyParticles()
        end
    })

    Tabs.Visuals:AddDropdown("BodyParticlesOrientation", {
        Title = "Particle orientation",
        Values = {"Camera", "FacingCameraWorldUp", "VelocityParallel", "VelocityPerpendicular"},
        Default = "Camera",
        Callback = function(v)
            bodyParticlesConfig.orientation = v
            applyBodyParticles()
        end
    })

    -- align visual appearance toggles in a row
    Tabs.Visuals:AddToggleGroup({
        { Title = "Glowing", Default = false, Callback = function(v) bodyParticlesConfig.glowing = v; applyBodyParticles() end },
        { Title = "Anchored", Default = false, Callback = function(v) bodyParticlesConfig.anchored = v; applyBodyParticles() end },
        { Title = "Fade in", Default = true, Callback = function(v) bodyParticlesConfig.fadeIn = v; applyBodyParticles() end }
    })

    Tabs.Visuals:AddSection("Crosshair")
    Tabs.Visuals:AddToggle("CrosshairEnabled", {
        Title = "Custom crosshair",
        Default = false,
        Callback = function(v)
            crosshairConfig.enabled = v
            if v then
                if crosshairConfig.followCursor then
                    pcall(function() UserInputService.MouseIconEnabled = false end)
                end
                updateCrosshair()
            else
                pcall(function() UserInputService.MouseIconEnabled = true end)
                removeCrosshair()
            end
        end
    })

    Tabs.Visuals:AddDropdown("CrosshairPreset", {
        Title = "Crosshair preset",
        Values = {
            "Heart",
            "Parenthesis",
            ">.<",
            "somename (animated)",
            "shockwave (animated)",
            "pixel shockwave (animated)",
            "maxwell (animated)",
            "Custom"
        },
        Default = "Parenthesis",
        Callback = function(v)
            crosshairConfig.preset = v
            if crosshairConfig.enabled then updateCrosshair() end
        end
    })

    Tabs.Visuals:AddInput("CrosshairCustomId", {
        Title = "Custom crosshair asset id",
        Default = "",
        Placeholder = "rbxassetid://...",
        Callback = function(text)
            crosshairConfig.customAssetId = text
            if crosshairConfig.enabled then updateCrosshair() end
        end
    })

    Tabs.Visuals:AddToggle("CrosshairCustomFlipbook", {
        Title = "Crosshair flipbook animation",
        Default = false,
        Callback = function(v)
            crosshairConfig.isCustomFlipbook = v
            if crosshairConfig.enabled then updateCrosshair() end
        end
    })

    Tabs.Visuals:AddInput("CrosshairFlipbookLayout", {
        Title = "Crosshair flipbook layout",
        Default = "Grid4x4",
        Placeholder = "Grid2x2, Grid4x4, Grid8x8",
        Callback = function(text)
            crosshairConfig.customFlipbookLayout = text
            if crosshairConfig.enabled then updateCrosshair() end
        end
    })

    Tabs.Visuals:AddDropdown("CrosshairFlipbookMode", {
        Title = "Crosshair flipbook mode",
        Values = {"Loop", "OneShot", "PingPong"},
        Default = "Loop",
        Callback = function(v)
            crosshairConfig.customFlipbookMode = v
            if crosshairConfig.enabled then updateCrosshair() end
        end
    })

    Tabs.Visuals:AddSlider("CrosshairFlipbookSpeed", {
        Title = "Crosshair animation speed",
        Min = 1,
        Max = 60,
        Default = 15,
        Suffix = " fps",
        Callback = function(v)
            crosshairConfig.flipbookPlaySpeed = v
            if crosshairConfig.enabled then updateCrosshair() end
        end
    })

    Tabs.Visuals:AddSlider("CrosshairSize", {
        Title = "Crosshair size scale",
        Min = 10,
        Max = 200,
        Default = 50,
        Suffix = " px",
        Callback = function(v)
            crosshairConfig.size = v
            if crosshairConfig.enabled then updateCrosshair() end
        end
    })

    Tabs.Visuals:AddDropdown("CrosshairColorMode", {
        Title = "Crosshair color mode",
        Values = {"Normal", "Gradient", "Gradient 2", "Rainbow", "Rainbow 2"},
        Default = "Normal",
        Callback = function(v)
            crosshairConfig.colorMode = v
            if crosshairConfig.enabled then updateCrosshair() end
        end
    })

    Tabs.Visuals:AddColorpicker("CrosshairColor1", {
        Title = "Crosshair primary color",
        Default = Color3.fromRGB(255, 255, 255),
        Callback = function(c)
            crosshairConfig.color1 = c
            if crosshairConfig.enabled then updateCrosshair() end
        end
    })

    Tabs.Visuals:AddColorpicker("CrosshairColor2", {
        Title = "Crosshair secondary color",
        Default = Color3.fromRGB(0, 170, 255),
        Callback = function(c)
            crosshairConfig.color2 = c
            if crosshairConfig.enabled then updateCrosshair() end
        end
    })

    Tabs.Visuals:AddSlider("CrosshairTransparency", {
        Title = "Crosshair transparency",
        Min = 0,
        Max = 100,
        Default = 0,
        Suffix = "%",
        Callback = function(v)
            crosshairConfig.transparency = v / 100
            if crosshairConfig.enabled then updateCrosshair() end
        end
    })

    Tabs.Visuals:AddCheckbox("CrosshairFollowCursor", {
        Title = "Crosshair follows cursor",
        Default = false,
        Callback = function(v)
            crosshairConfig.followCursor = v
            if not v or not crosshairConfig.enabled then
                pcall(function() UserInputService.MouseIconEnabled = true end)
            else
                pcall(function() UserInputService.MouseIconEnabled = false end)
            end
            if crosshairConfig.enabled then updateCrosshair() end
        end
    })

    Tabs.Visuals:AddToggle("CrosshairSpinEnabled", {
        Title = "Spin crosshair",
        Default = false,
        Slider = {
            Title = "Crosshair spin speed",
            Min = 10,
            Max = 360,
            Default = 180,
            Suffix = " deg/s",
            Callback = function(v)
                crosshairConfig.spinSpeed = v
            end
        },
        Callback = function(v)
            crosshairConfig.spinEnabled = v
        end
    })

    Tabs.Visuals:AddSection("Color animation")
    Tabs.Visuals:AddSlider("ColorShiftSpeed", {
        Title = "Rainbow & gradient animation speed",
        Min = 0.1,
        Max = 20,
        Default = 3,
        Increment = 0.1,
        Rounding = 1,
        Suffix = "x",
        Callback = function(v)
            state.colorShiftSpeed = v
        end
    })

    Tabs.Visuals:AddSection("Trail")
    Tabs.Visuals:AddToggle("TrailEnabled", {
        Title = "Character trail",
        Default = false,
        Callback = function(v)
            trailConfig.enabled = v
            if v then applyTrail() else removeAllTrails() end
        end
    })

    Tabs.Visuals:AddDropdown("TrailColorMode", {
        Title = "Trail color mode",
        Values = {"Normal", "Rainbow", "Shift", "Gradient"},
        Default = "Normal",
        Callback = function(v)
            trailConfig.colorMode = v
            updateTrailProps()
        end
    })

    Tabs.Visuals:AddGroup({
        {
            Id = "TrailColor1",
            Type = "ColorPicker",
            Title = "Trail primary color",
            Default = Color3.fromRGB(0, 170, 255),
            Callback = function(c)
                trailConfig.color1 = c
                updateTrailProps()
            end
        },
        {
            Id = "TrailColor2",
            Type = "ColorPicker",
            Title = "Trail secondary color",
            Default = Color3.fromRGB(255, 0, 128),
            Callback = function(c)
                trailConfig.color2 = c
                updateTrailProps()
            end
        }
    })

    Tabs.Visuals:AddSlider("TrailLifetime", {
        Title = "Trail duration lifetime",
        Min = 0.05,
        Max = 5,
        Default = 1.0,
        Increment = 0.05,
        Rounding = 2,
        Suffix = " s",
        Callback = function(v)
            trailConfig.lifetime = v
            updateTrailProps()
        end
    })

    Tabs.Visuals:AddSlider("TrailWidth", {
        Title = "Trail width scale",
        Min = 0.05,
        Max = 5,
        Default = 1.0,
        Increment = 0.05,
        Rounding = 2,
        Suffix = " studs",
        Callback = function(v)
            trailConfig.width = v
            updateTrailProps()
        end
    })

    Tabs.Visuals:AddSlider("TrailTransparency", {
        Title = "Trail transparency",
        Min = 0,
        Max = 100,
        Default = 0,
        Suffix = "%",
        Callback = function(v)
            trailConfig.transparency = v / 100
            updateTrailProps()
        end
    })

    Tabs.Visuals:AddSection("Orb")
    Tabs.Visuals:AddGroup({
        {
            Id = "OrbEnabled",
            Type = "Toggle",
            Title = "Orbiting light orb",
            Default = false,
            Callback = function(v)
                orbConfig.enabled = v
                if v then applyOrb() else removeOrb() end
            end
        },
        {
            Id = "OrbColorMode",
            Type = "Dropdown",
            Title = "Orb color mode",
            Values = {"Normal", "Rainbow", "Shift", "Gradient"},
            Default = "Normal",
            Callback = function(v)
                orbConfig.colorMode = v
            end
        },
        {
            Id = "OrbColor1",
            Type = "ColorPicker",
            Title = "Orb primary color",
            Default = Color3.fromRGB(0, 255, 170),
            Callback = function(c)
                orbConfig.color1 = c
            end
        },
        {
            Id = "OrbColor2",
            Type = "ColorPicker",
            Title = "Orb secondary color",
            Default = Color3.fromRGB(255, 85, 0),
            Callback = function(c)
                orbConfig.color2 = c
            end
        }
    })

    Tabs.Visuals:AddSlider("OrbRadius", {
        Title = "Orb orbit distance",
        Min = 0.5,
        Max = 20,
        Default = 3,
        Increment = 0.1,
        Rounding = 1,
        Suffix = " studs",
        Callback = function(v)
            orbConfig.radius = v
        end
    })

    Tabs.Visuals:AddSlider("OrbSpeed", {
        Title = "Orb orbit speed",
        Min = 0.1,
        Max = 20,
        Default = 4,
        Increment = 0.1,
        Rounding = 1,
        Suffix = "x",
        Callback = function(v)
            orbConfig.speed = v
        end
    })

    Tabs.Visuals:AddSlider("OrbSize", {
        Title = "Orb size scale",
        Min = 0.05,
        Max = 5,
        Default = 0.3,
        Increment = 0.05,
        Rounding = 2,
        Suffix = " studs",
        Callback = function(v)
            orbConfig.size = v
        end
    })

    Tabs.Visuals:AddSection("China hat")
    Tabs.Visuals:AddGroup({
        {
            Id = "ChinaHatEnabled",
            Type = "Toggle",
            Title = "China hat cosmetic",
            Default = false,
            Callback = function(v)
                chinaHatConfig.enabled = v
                if v then startChinaHat() else stopChinaHat() end
            end
        },
        {
            Id = "ChinaHatColorMode",
            Type = "Dropdown",
            Title = "Hat color mode",
            Values = {"Normal", "Rainbow", "Shift", "Gradient"},
            Default = "Normal",
            Callback = function(v)
                chinaHatConfig.colorMode = v
                updateHatColors()
            end
        },
        {
            Id = "ChinaHatColor1",
            Type = "ColorPicker",
            Title = "Hat primary color",
            Default = Color3.fromRGB(255, 0, 100),
            Callback = function(c)
                chinaHatConfig.color1 = c
                updateHatColors()
            end
        },
        {
            Id = "ChinaHatColor2",
            Type = "ColorPicker",
            Title = "Hat secondary color",
            Default = Color3.fromRGB(0, 200, 255),
            Callback = function(c)
                chinaHatConfig.color2 = c
                updateHatColors()
            end
        }
    })

    Tabs.Visuals:AddSlider("ChinaHatTransparency", {
        Title = "Hat transparency",
        Min = 0,
        Max = 100,
        Default = 0,
        Suffix = "%",
        Callback = function(v)
            chinaHatConfig.transparency = v / 100
            updateHatProps()
        end
    })

    Tabs.Visuals:AddToggleGroup({
        {
            Id = "ChinaHatAlwaysOnTop",
            Title = "Hat always on top",
            Default = false,
            Callback = function(v)
                chinaHatConfig.alwaysOnTop = v
                updateHatProps()
            end
        },
        {
            Id = "ChinaHatSelfOnly",
            Title = "Hat self player only",
            Default = true,
            Callback = function(v)
                chinaHatConfig.selfOnly = v
                if chinaHatConfig.enabled then
                    stopChinaHat()
                    startChinaHat()
                end
            end
        }
    })

    Tabs.Visuals:AddCheckbox("ChinaHatFollowHead", {
        Title = "Follow user head (X/Z only)",
        Default = false,
        Callback = function(v)
            chinaHatConfig.followHead = v
            if state then state.chinaHatFollowHead = v end
            updateHatProps()
        end
    })

    Tabs.Visuals:AddSlider("ChinaHatHeight", {
        Title = "Hat cone height",
        Min = 0.1,
        Max = 5,
        Default = 0.6,
        Increment = 0.05,
        Rounding = 2,
        Suffix = " studs",
        Callback = function(v)
            chinaHatConfig.height = v
            updateHatProps()
        end
    })

    Tabs.Visuals:AddSlider("ChinaHatRadius", {
        Title = "Hat cone radius",
        Min = 0.1,
        Max = 10,
        Default = 1.2,
        Increment = 0.05,
        Rounding = 2,
        Suffix = " studs",
        Callback = function(v)
            chinaHatConfig.radius = v
            updateHatProps()
        end
    })

    Tabs.Visuals:AddSlider("ChinaHatHeightOffset", {
        Title = "Hat head offset",
        Min = -2,
        Max = 5,
        Default = 2.0,
        Increment = 0.05,
        Rounding = 2,
        Suffix = " studs",
        Callback = function(v)
            chinaHatConfig.heightOffset = v
            updateHatProps()
        end
    })

    Tabs.Visuals:AddSection("Neon wings")
    Tabs.Visuals:AddToggle("WingsEnabled", {
        Title = "Neon wings cosmetic",
        Default = false,
        Callback = function(v)
            wingsConfig.enabled = v
            if v then startWings() else stopWings() end
        end
    })

    Tabs.Visuals:AddDropdown("WingsColorMode", {
        Title = "Wings color mode",
        Values = {"Normal", "Rainbow", "Shift", "Gradient"},
        Default = "Normal",
        Callback = function(v)
            wingsConfig.colorMode = v
        end
    })

    Tabs.Visuals:AddColorpicker("WingsColor1", {
        Title = "Wings primary color",
        Default = Color3.fromRGB(0, 255, 170),
        Callback = function(c)
            wingsConfig.color1 = c
        end
    })

    Tabs.Visuals:AddColorpicker("WingsColor2", {
        Title = "Wings secondary color",
        Default = Color3.fromRGB(170, 0, 255),
        Callback = function(c)
            wingsConfig.color2 = c
        end
    })

    Tabs.Visuals:AddSlider("WingsTransparency", {
        Title = "Wings transparency",
        Min = 0,
        Max = 100,
        Default = 55,
        Suffix = "%",
        Callback = function(v)
            wingsConfig.transparency = v / 100
        end
    })

    Tabs.Visuals:AddSlider("WingsGlow", {
        Title = "Wings glow",
        Min = 0,
        Max = 5,
        Default = 1.28,
        Increment = 0.05,
        Rounding = 2,
        Callback = function(v)
            if updateWingsGlow then
                updateWingsGlow(v)
            else
                wingsConfig.glow = v
            end
        end
    })

    Tabs.Visuals:AddSlider("WingsSpeed", {
        Title = "Wings flap speed",
        Min = 0.1,
        Max = 20,
        Default = 3.5,
        Increment = 0.1,
        Rounding = 1,
        Suffix = "x",
        Callback = function(v)
            wingsConfig.speed = v
        end
    })

    Tabs.Visuals:AddCheckbox("WingsSelfOnly", {
        Title = "Wings self player only",
        Default = true,
        Callback = function(v)
            wingsConfig.selfOnly = v
            if wingsConfig.enabled then
                stopWings()
                startWings()
            end
        end
    })

    Tabs.Visuals:AddSlider("WingsSize", {
        Title = "Wings scale size",
        Min = 0.1,
        Max = 5,
        Default = 0.59,
        Increment = 0.01,
        Rounding = 2,
        Suffix = "x",
        Callback = function(v)
            wingsConfig.size = v
        end
    })

    Tabs.Visuals:AddSlider("WingsPosX", {
        Title = "Wings position offset x",
        Min = -5,
        Max = 5,
        Default = 1.41,
        Increment = 0.01,
        Rounding = 2,
        Suffix = " studs",
        Callback = function(v)
            wingsConfig.posX = v
        end
    })

    Tabs.Visuals:AddSlider("WingsPosY", {
        Title = "Wings position offset y",
        Min = -5,
        Max = 5,
        Default = 2.12,
        Increment = 0.01,
        Rounding = 2,
        Suffix = " studs",
        Callback = function(v)
            wingsConfig.posY = v
        end
    })

    Tabs.Visuals:AddSlider("WingsPosZ", {
        Title = "Wings position offset z",
        Min = -5,
        Max = 5,
        Default = 1.41,
        Increment = 0.01,
        Rounding = 2,
        Suffix = " studs",
        Callback = function(v)
            wingsConfig.posZ = v
        end
    })

    Tabs.Visuals:AddSection("Jump ring")
    Tabs.Visuals:AddToggle("JumpRingEnabled", {
        Title = "Jump ring",
        Default = false,
        Callback = function(v)
            jumpRingConfig.enabled = v
        end
    })

    Tabs.Visuals:AddDropdown("JumpRingColorMode", {
        Title = "Jump ring color mode",
        Values = { "Normal", "Gradient", "Shift", "Rainbow 1", "Rainbow 2" },
        Default = "Rainbow 1",
        Callback = function(v)
            jumpRingConfig.colorMode = v
        end
    })

    Tabs.Visuals:AddGroup({
        {
            Id = "JumpRingColor1",
            Type = "Colorpicker",
            Title = "Ring color 1",
            Default = Color3.fromRGB(255, 255, 255),
            Callback = function(c)
                jumpRingConfig.color1 = c
            end
        },
        {
            Id = "JumpRingColor2",
            Type = "Colorpicker",
            Title = "Ring color 2",
            Default = Color3.fromRGB(0, 170, 255),
            Callback = function(c)
                jumpRingConfig.color2 = c
            end
        }
    })

    Tabs.Visuals:AddSlider("JumpRingMaxSize", {
        Title = "Ring max size",
        Min = 3,
        Max = 16,
        Default = 7.5,
        Increment = 0.5,
        Rounding = 1,
        Suffix = " studs",
        Callback = function(v)
            jumpRingConfig.maxSize = v
        end
    })

    Tabs.Visuals:AddSlider("JumpRingDuration", {
        Title = "Ring fade speed",
        Min = 0.2,
        Max = 1.5,
        Default = 0.6,
        Increment = 0.05,
        Rounding = 2,
        Suffix = " s",
        Callback = function(v)
            jumpRingConfig.duration = v
        end
    })

    Tabs.Visuals:AddSlider("JumpRingTransparency", {
        Title = "Initial transparency",
        Min = 0,
        Max = 100,
        Default = 10,
        Increment = 1,
        Rounding = 0,
        Suffix = " %",
        Callback = function(v)
            jumpRingConfig.transparency = v / 100
        end
    })

    Tabs.Visuals:AddSection("Spinbot")
    Tabs.Visuals:AddToggle("SpinbotEnabled", {
        Title = "Spinbot",
        Default = false,
        Slider = {
            Title = "Spinbot rotation speed",
            Min = 5,
            Max = 100,
            Default = 30,
            Suffix = "°/s",
            Callback = function(v)
                state.spinbotSpeed = v
            end
        },
        Callback = function(v)
            state.spinbotEnabled = v
            if v then startSpinbot() else stopSpinbot() end
        end
    })

    -- ── Gun ray / bullet tracer ─────────────────────────────────────────────
    local tracerPresets = {
        ["Lighting beam"]   = "rbxassetid://81042383807716",
        ["Lighting beam 2"] = "rbxassetid://104296222791074",
        ["Thick beam"]      = "rbxassetid://78956314822091",
    }

    local tracerConfig = {
        enabled       = false,
        ownOnly       = false,
        colorMode     = "Normal",
        color         = Color3.fromRGB(255, 220, 50),
        color2        = Color3.fromRGB(255, 85, 0),
        duration      = 1.0,
        width         = 0.25,
        lightEmission = 3,
        texture       = "rbxassetid://81042383807716",
        customTexture = "",
    }

    local tracerFadeTween = TweenInfo.new(0.2, Enum.EasingStyle.Linear, Enum.EasingDirection.Out)

    local function tracerToPosition(value)
        if typeof(value) == "Vector3" then return value end
        if typeof(value) == "CFrame"   then return value.Position end
        if typeof(value) == "Instance" then
            if value:IsA("Attachment") then return value.WorldPosition end
            if value:IsA("BasePart")   then return value.Position end
        end
        return nil
    end

    local function tracerMakeAnchor(position, lifetime)
        local p = Instance.new("Part")
        p.Transparency = 1
        p.Anchored     = true
        p.CanCollide   = false
        p.CanQuery     = false
        p.Size         = Vector3.new(1, 1, 1)
        p.CFrame       = CFrame.new(position)
        Instance.new("Attachment", p)
        Debris:AddItem(p, lifetime + 0.5)
        p.Parent = workspace
        return p
    end

    -- resolve beam ColorSequence from the active color mode
    local function tracerColorSeq()
        local mode = tracerConfig.colorMode
        local c1   = tracerConfig.color
        local c2   = tracerConfig.color2
        if mode == "Rainbow" then
            local c = getColor("Rainbow", c1, c2)
            return ColorSequence.new(c)
        elseif mode == "Gradient" then
            -- true two-colour gradient along the beam length
            return ColorSequence.new({
                ColorSequenceKeypoint.new(0, c1),
                ColorSequenceKeypoint.new(1, c2),
            })
        elseif mode == "Shift" then
            local c = getColor("Shift", c1, c2)
            return ColorSequence.new(c)
        else
            return ColorSequence.new(c1)
        end
    end

    local function createTracer(startValue, endValue)
        local sPos = tracerToPosition(startValue)
        local ePos = tracerToPosition(endValue)
        if not sPos or not ePos then return end

        local dur = tracerConfig.duration
        local w   = tracerConfig.width
        local p0  = tracerMakeAnchor(sPos, dur)
        local p1  = tracerMakeAnchor(ePos, dur)

        local tex = tracerConfig.texture
        if tracerConfig.customTexture and tracerConfig.customTexture ~= "" then
            local digits = tostring(tracerConfig.customTexture):match("%d+")
            if digits then tex = "rbxassetid://" .. digits end
        end

        local beam = Instance.new("Beam")
        beam.FaceCamera     = true
        beam.TextureSpeed   = 1.5
        beam.TextureLength  = 2
        beam.Width0         = w
        beam.Width1         = w
        beam.LightEmission  = tracerConfig.lightEmission
        beam.LightInfluence = 0
        beam.Brightness     = 2.5
        beam.Texture        = tex
        beam.Color          = tracerColorSeq()
        beam.Transparency   = NumberSequence.new({
            NumberSequenceKeypoint.new(0, 0.1),
            NumberSequenceKeypoint.new(1, 0.1),
        })
        beam.Attachment0 = p0:FindFirstChildOfClass("Attachment")
        beam.Attachment1 = p1:FindFirstChildOfClass("Attachment")
        beam.Parent      = p0

        -- For animated modes, update beam.Color every frame during its lifetime.
        -- Gradient and Normal are static, so skip the loop for them.
        local mode = tracerConfig.colorMode
        if mode == "Rainbow" or mode == "Shift" then
            local colorConn
            colorConn = RunService.Heartbeat:Connect(function()
                if not beam or not beam.Parent then
                    colorConn:Disconnect()
                    return
                end
                beam.Color = tracerColorSeq()
            end)
            -- safety disconnect after beam dies + a little extra
            task.delay(dur + 0.5, function()
                pcall(function() colorConn:Disconnect() end)
            end)
        end

        task.delay(dur, function()
            if beam and beam.Parent then
                TweenService:Create(beam, tracerFadeTween, { Width0 = 0, Width1 = 0 }):Play()
            end
        end)
    end


    local tracerGunFiredConn   = nil
    local tracerGunFiredRemote = nil
    local tracerRoundClient    = nil

    local function tracerIsLocalSheriff()
        local char = LocalPlayer.Character
        if char and char:FindFirstChild("Gun") then return true end
        local bp = LocalPlayer:FindFirstChildOfClass("Backpack")
        if bp and bp:FindFirstChild("Gun") then return true end
        if not tracerRoundClient then
            pcall(function()
                tracerRoundClient = require(
                    ReplicatedStorage:WaitForChild("Modules", 2)
                        :WaitForChild("CurrentRoundClient", 2)
                )
            end)
        end
        if tracerRoundClient then
            local data = tracerRoundClient.PlayerData
            local d = data and data[LocalPlayer.Name]
            return d ~= nil and (d.Role == "Sheriff" or d.Role == "Hero")
        end
        return false
    end

    local function onGunFired(gun, startValue, endValue)
        if not tracerConfig.enabled then return end
        if tracerConfig.ownOnly then
            local char = LocalPlayer.Character
            if not char then return end
            if not (typeof(gun) == "Instance" and gun:IsDescendantOf(char)) then return end
            if not tracerIsLocalSheriff() then return end
        end
        createTracer(startValue, endValue)
    end

    local function connectGunFiredRemote()
        local ok, remote = pcall(function()
            return ReplicatedStorage
                :WaitForChild("ClientServices", 2)
                :WaitForChild("WeaponService", 2)
                :WaitForChild("GunFired", 2)
        end)
        if not ok or not remote then return end
        if tracerGunFiredConn
            and tracerGunFiredRemote == remote
            and tracerGunFiredConn.Connected then return end
        if tracerGunFiredConn then
            pcall(function() tracerGunFiredConn:Disconnect() end)
            tracerGunFiredConn = nil
        end
        tracerGunFiredRemote = remote
        tracerGunFiredConn   = remote.OnClientEvent:Connect(function(gun, sv, ev)
            task.spawn(onGunFired, gun, sv, ev)
        end)
    end

    -- reconnect loop: handles map reloads where the remote may change
    do
        local lastTracerPoll = 0
        trackConnection(RunService.Heartbeat:Connect(function()
            if state.unloaded then return end
            if not tracerConfig.enabled then return end
            local now = tick()
            if now - lastTracerPoll < 1 then return end
            lastTracerPoll = now
            pcall(connectGunFiredRemote)
        end))
    end

    -- Gun ray UI
    Tabs.Visuals:AddSection("Gun ray")
    Tabs.Visuals:AddToggle("GunTracerEnabled", {
        Title    = "Gun ray",
        Default  = false,
        Callback = function(v)
            tracerConfig.enabled = v
            if v then pcall(connectGunFiredRemote) end
        end
    })
    Tabs.Visuals:AddCheckbox("GunTracerOwnOnly", {
        Title    = "Own shots only",
        Default  = false,
        Callback = function(v) tracerConfig.ownOnly = v end
    })
    Tabs.Visuals:AddDropdown("GunTracerColorMode", {
        Title    = "Color mode",
        Values   = { "Normal", "Rainbow", "Gradient", "Shift" },
        Default  = "Normal",
        Callback = function(v) tracerConfig.colorMode = v end
    })
    Tabs.Visuals:AddGroup({
        {
            Id       = "GunTracerColor",
            Type     = "ColorPicker",
            Title    = "Color",
            Default  = Color3.fromRGB(255, 220, 50),
            Callback = function(c) tracerConfig.color = c end
        },
        {
            Id       = "GunTracerColor2",
            Type     = "ColorPicker",
            Title    = "Color 2 (Gradient / Shift)",
            Default  = Color3.fromRGB(255, 85, 0),
            Callback = function(c) tracerConfig.color2 = c end
        }
    })
    local tracerDrop = Tabs.Visuals:AddDropdown("GunTracerTexture", {
        Title    = "Ray texture",
        Values   = { "Lighting beam", "Lighting beam 2", "Thick beam", "Custom" },
        Default  = "Lighting beam",
        Callback = function(v)
            if tracerPresets[v] then
                tracerConfig.texture       = tracerPresets[v]
                tracerConfig.customTexture = ""
            end
            -- "Custom" → user fills in the input below; texture resolved at fire time
        end
    })

    -- Migration safeguard: if an older saved config file restores obsolete presets (e.g. "Laser"),
    -- ensure the updated beam options are restored and a valid beam is selected
    if Window and Window.OnConfigLoaded then
        Window:OnConfigLoaded(function()
            if tracerDrop then
                if tracerDrop.SetOptions then
                    tracerDrop.SetOptions({ "Lighting beam", "Lighting beam 2", "Thick beam", "Custom" })
                end
                local cur = tracerDrop.GetSelected and tracerDrop.GetSelected()
                if cur == "Laser" or (not tracerPresets[cur] and cur ~= "Custom") then
                    if tracerDrop.SetSelected then
                        tracerDrop.SetSelected("Lighting beam", true)
                    end
                end
            end
        end)
    end
    Tabs.Visuals:AddInput("GunTracerCustomTex", {
        Title       = "Custom texture ID",
        Placeholder = "Asset ID or full rbxassetid://...",
        Default     = "",
        Callback    = function(v)
            tracerConfig.customTexture = v
        end
    })
    Tabs.Visuals:AddSlider("GunTracerDuration", {
        Title     = "Duration",
        Min       = 0.1,
        Max       = 5,
        Default   = 1,
        Increment = 0.1,
        Rounding  = 1,
        Suffix    = " s",
        Callback  = function(v) tracerConfig.duration = v end
    })
    Tabs.Visuals:AddSlider("GunTracerWidth", {
        Title     = "Width",
        Min       = 0.05,
        Max       = 2,
        Default   = 0.25,
        Increment = 0.05,
        Rounding  = 2,
        Suffix    = " st",
        Callback  = function(v) tracerConfig.width = v end
    })
    Tabs.Visuals:AddSlider("GunTracerGlow", {
        Title     = "Light emission",
        Min       = 0,
        Max       = 10,
        Default   = 3,
        Increment = 0.5,
        Rounding  = 1,
        Callback  = function(v) tracerConfig.lightEmission = v end
    })

    -- construct character animation overrides
    Tabs.Animations:AddSection("Custom animations")
    Tabs.Animations:AddGroup({
        {
            Id = "CustomAnimationsEnabled",
            Type = "Toggle",
            Title = "Custom animations",
            Default = false,
            Callback = function(v)
                customAnimationConfig.enabled = v
                task.spawn(applyCustomAnimations)
            end
        },
        {
            Id = "CustomAnimationPreset",
            Type = "Dropdown",
            Title = "Preset",
            Values = {"Mage", "Vampire", "Zombie", "Adidas", "Elder", "Dumb Dumb", "Custom"},
            Default = "Mage",
            Callback = function(v)
                customAnimationConfig.preset = v
                task.spawn(applyCustomAnimations)
            end
        },
        {
            Id = "CustomAnimationPackId",
            Type = "Input",
            Title = "Animation pack ID",
            Default = "",
            Placeholder = "Bundle or pack ID...",
            Callback = function(text)
                customAnimationConfig.customPackId = text
                if customAnimationConfig.preset == "Custom" then
                    task.spawn(applyCustomAnimations)
                end
            end
        }
    })

    -- construct character dance and wave presets
    Tabs.Animations:AddSection("Emotes")

    local function getEmoteOptions()
        local list = { "Take The L", "neck roller", "WISH NLE", "Zero Two Dance", "Gangnam Style" }
        if state.customEmotes then
            for name, _ in pairs(state.customEmotes) do
                local found = false
                for _, existing in ipairs(list) do
                    if existing == name then found = true; break end
                end
                if not found then table.insert(list, name) end
            end
        end
        return list
    end

    local emoteDropdownObj = Tabs.Animations:AddDropdown("SelectedEmote", {
        Title = "Select emote",
        Values = getEmoteOptions(),
        Default = "Take The L",
        Callback = function(v)
            state.selectedEmote = v
        end
    })

    Tabs.Animations:AddButtonRow({
        {
            Text = "Play emote",
            Icon = "play",
            Callback = function()
                playEmote(state.selectedEmote)
            end
        },
        {
            Text = "Stop emote",
            Icon = "square",
            Callback = function()
                stopEmote()
            end
        }
    }, 28)

    Tabs.Animations:AddCheckbox("EmoteStopOnMove", {
        Title = "Stop on move",
        Default = false,
        Callback = function(v)
            state.emoteStopOnMove = v
        end
    })

    local customEmoteTempName = ""
    local customEmoteTempId = ""

    Tabs.Animations:AddInput("CustomEmoteNameInput", {
        Title = "Custom emote name",
        Placeholder = "e.g. MyDance",
        Callback = function(txt)
            customEmoteTempName = txt
        end
    })

    Tabs.Animations:AddInput("CustomEmoteIdInput", {
        Title = "Custom animation ID",
        Placeholder = "rbxassetid://... or numbers",
        Callback = function(txt)
            customEmoteTempId = txt
        end
    })

    Tabs.Animations:AddButton({
        Title = "Add custom emote",
        Icon = "plus-circle",
        Callback = function()
            local name = customEmoteTempName:gsub("^%s+", ""):gsub("%s+$", "")
            local id = customEmoteTempId:gsub("^%s+", ""):gsub("%s+$", "")
            if name == "" then
                name = "Custom_" .. (#getEmoteOptions() + 1)
            end
            if id ~= "" then
                state.customEmotes = state.customEmotes or {}
                state.customEmotes[name] = id
                if emoteDropdownObj and emoteDropdownObj.RefreshOptions then
                    emoteDropdownObj:RefreshOptions(getEmoteOptions())
                elseif emoteDropdownObj and emoteDropdownObj.SetValues then
                    emoteDropdownObj:SetValues(getEmoteOptions())
                end
                pcall(function()
                    if Window.Notify then
                        Window:Notify("Emote added", "Added custom emote: " .. name, 2.5)
                    end
                end)
            end
        end
    })

    Tabs.Animations:AddButton({
        Title = "Remove custom emote",
        Icon = "trash-2",
        Callback = function()
            local selected = state.selectedEmote
            if selected and state.customEmotes and state.customEmotes[selected] then
                state.customEmotes[selected] = nil
                local opts = getEmoteOptions()
                state.selectedEmote = opts[1] or "Take The L"
                if emoteDropdownObj and emoteDropdownObj.RefreshOptions then
                    emoteDropdownObj:RefreshOptions(opts)
                    if emoteDropdownObj.Select then emoteDropdownObj:Select(state.selectedEmote) end
                elseif emoteDropdownObj and emoteDropdownObj.SetValues then
                    emoteDropdownObj:SetValues(opts)
                end
                pcall(function()
                    if Window.Notify then
                        Window:Notify("Emote removed", "Removed custom emote: " .. selected, 2.5)
                    end
                end)
            else
                pcall(function()
                    if Window.Notify then
                        Window:Notify("Emotes", "Cannot remove standard preset emote", 2)
                    end
                end)
            end
        end
    })

    Window.ConfigSavedCallbacks = Window.ConfigSavedCallbacks or {}
    table.insert(Window.ConfigSavedCallbacks, function(cName, saveData)
        saveData.CustomEmotes = state.customEmotes
    end)

    Window.ConfigLoadedCallbacks = Window.ConfigLoadedCallbacks or {}
    table.insert(Window.ConfigLoadedCallbacks, function(data)
        if data and data.CustomEmotes then
            state.customEmotes = data.CustomEmotes
            if emoteDropdownObj and emoteDropdownObj.RefreshOptions then
                emoteDropdownObj:RefreshOptions(getEmoteOptions())
            end
        end
    end)

Tabs.World:AddSection("Skybox")

    Tabs.World:AddDropdown("WorldSkyboxPreset", {
        Title = "Skybox preset",
        Values = {"Default", "Space Skybox", "Fog on the water", "Red sky", "Midnight", "Tattletail"},
        Default = "Default",
        Callback = function(selected)
            worldState.skyboxPreset = selected
            local id = skyboxPresets[selected]
            applySkybox(id)
        end
    })

    Tabs.World:AddInput("WorldCustomSkybox", {
        Title = "Custom skybox id",
        Placeholder = "Asset id",
        ClearTextOnFocus = false,
        Callback = function(txt)
            applySkybox(txt)
        end
    })

    Tabs.World:AddSection("Atmosphere and lighting")

    Tabs.World:AddToggle("WorldCustomTime", {
        Title = "Custom time",
        Default = false,
        Callback = function(v)
            worldState.timeEnabled = v
            if not v then
                LightingService.ClockTime = defaultLighting.ClockTime
            end
        end
    })

    Tabs.World:AddSlider("WorldTime", {
        Title = "Time",
        Min = 0,
        Max = 24,
        Default = 14,
        Suffix = " hrs",
        Callback = function(val)
            worldState.customTime = val
        end
    })

    Tabs.World:AddToggle("WorldCustomBrightness", {
        Title = "Custom brightness",
        Default = false,
        Callback = function(v)
            worldState.brightnessEnabled = v
            if not v then
                LightingService.Brightness = defaultLighting.Brightness
            end
        end
    })

    Tabs.World:AddSlider("WorldBrightness", {
        Title = "Brightness",
        Min = 0,
        Max = 10,
        Default = 2,
        Suffix = "",
        Callback = function(val)
            worldState.customBrightness = val
        end
    })

    Tabs.World:AddToggle("WorldCustomFog", {
        Title = "Custom fog",
        Default = false,
        Callback = function(v)
            worldState.customFog = v
            if not v then
                LightingService.FogEnd = defaultLighting.FogEnd
                LightingService.FogColor = defaultLighting.FogColor
            end
        end
    })

    Tabs.World:AddSlider("WorldFogDistance", {
        Title = "Fog distance",
        Min = 100,
        Max = 5000,
        Default = 2000,
        Suffix = " studs",
        Callback = function(val)
            worldState.fogEndDistance = val
        end
    })

    Tabs.World:AddColorpicker("WorldFogColor", {
        Title = "Fog color",
        Default = Color3.fromRGB(180, 200, 220),
        Callback = function(col)
            worldState.fogColor = col
        end
    })

    -- construct camera fov and stretch adjustments
    Tabs.Camera:AddSection("Resolution stretch")

    Tabs.Camera:AddToggle("CameraEnableStretch", {
        Title = "Enable stretch",
        Default = false,
        Callback = function(v)
            stretchSettings.enabled = v
        end
    })

    Tabs.Camera:AddSlider("CameraHorizontalStretch", {
        Title = "Horizontal stretch",
        Min = 10,
        Max = 53,
        Default = 53,
        Suffix = "%",
        Callback = function(val)
            stretchSettings.horizontalScale = val / 100
        end
    })

    Tabs.Camera:AddSlider("CameraVerticalStretch", {
        Title = "Vertical stretch",
        Min = 10,
        Max = 74,
        Default = 74,
        Suffix = "%",
        Callback = function(val)
            stretchSettings.verticalScale = val / 100
        end
    })

    Tabs.Camera:AddToggle("CameraCustomFOV", {
        Title = "Custom field of view",
        Default = false,
        Callback = function(v)
            stretchSettings.fovModifierEnabled = v
            if not v then
                CurrentCamera.FieldOfView = 70
            else
                CurrentCamera.FieldOfView = stretchSettings.customFov
            end
        end
    })

    Tabs.Camera:AddSlider("CameraFOV", {
        Title = "Field of view",
        Min = 40,
        Max = 120,
        Default = 70,
        Suffix = "°",
        Callback = function(val)
            stretchSettings.customFov = val
            if stretchSettings.fovModifierEnabled then
                CurrentCamera.FieldOfView = val
            end
        end
    })


    -- mount floating action buttons for touch devices
    mobileFlyBtn = Window:CreateMobileButton({
        Text = "Fly",
        Type = "Toggle",
        Default = false,
        Visible = true,
        SaveKey = "mobile_fly",
        Callback = function(btnState, btn)
            state.flightEnabled = btnState
            toggleFlyConnection(btnState)
            if Options and Options.FlightEnabled and Options.FlightEnabled.Value ~= btnState then
                Options.FlightEnabled:SetValue(btnState, false)
            end
        end
    })

    mobileCamlockBtn = Window:CreateMobileButton({
        Text = "Camlock",
        Type = "Toggle",
        Default = false,
        Visible = true,
        SaveKey = "mobile_camlock",
        Callback = function(btnState, btn)
            state.camlockEnabled = btnState
            camlockSettings.aimLockEnabled = btnState
            camlockSettings.isLockedOn = btnState
            if btnState then
                camlockSettings.targetPlayer = getCamlockTarget()
            else
                camlockSettings.targetPlayer = nil
            end
            toggleCamlockConnection(btnState)
            if Options and Options.CamlockEnabled and Options.CamlockEnabled.Value ~= btnState then
                Options.CamlockEnabled:SetValue(btnState, false)
            end
        end
    })

    mobileShootBtn = Window:CreateMobileButton({
        Text = "Shoot",
        Type = "Button",
        Visible = true,
        SaveKey = "mobile_shoot",
        Callback = function(btn)
            local char = LocalPlayer.Character
            if not char then return end
            local gunTool = getPlayerTool(LocalPlayer, "Gun")
            if not gunTool then
                log("No gun found")
                return
            end
            if gunTool.Parent ~= char then
                local hum = char:FindFirstChildOfClass("Humanoid")
                if hum then hum:EquipTool(gunTool); task.wait(0.05) end
            end

            local shootEvent = getGunShootEvent()
            if not shootEvent then
                log("Gun remote missing")
                return
            end

            local target, tPart = nil, nil
            if state and state.autoAimEnabled then
                target, tPart = getAutoAimTarget()
            else
                local murderer = state.knifeHolder or getMurd()
                if murderer and isPlayerAlive(murderer) then
                    target = murderer
                    tPart = murderer.Character and (murderer.Character:FindFirstChild("UpperTorso") or murderer.Character:FindFirstChild("HumanoidRootPart"))
                else
                    local t, p, _ = getSilentAimTarget()
                    target, tPart = t, p
                end
            end

            local targetChar = target and target.Character
            local isWallbang = (state and state.autoAimWallbang) or (silentAimConfig and silentAimConfig.wallbang)
            local shootPart = tPart or (targetChar and (targetChar:FindFirstChild(silentAimConfig and silentAimConfig.targetPart or "Head") or targetChar:FindFirstChild("HumanoidRootPart")))
            local targetPos = nil
            if shootPart then
                local rawPos = shootPart.Position
                local predH, predV = getSilentAimPred()
                targetPos = calculateAimPosition(rawPos, shootPart, predH, predV)
            end

            local originPos = nil
            if isWallbang and targetChar then
                local head = targetChar:FindFirstChild("Head")
                originPos = head and head.Position or (shootPart and (shootPart.Position + Vector3.new(0, 1.5, 0)))
            else
                local handle = getOwnGunHandle()
                local myHrp = char:FindFirstChild("HumanoidRootPart")
                originPos = handle and (handle.CFrame * CFrame.new(0, 0.5, -1)).Position or (myHrp and myHrp.Position or targetPos)
            end

            if not targetPos then
                local vpSize = CurrentCamera.ViewportSize
                local ray = CurrentCamera:ViewportPointToRay(vpSize.X / 2, vpSize.Y / 2)
                targetPos = originPos + ray.Direction * 1000
            end

            pcall(function()
                shootEvent:FireServer(CFrame.new(originPos, targetPos), CFrame.new(targetPos))
            end)
            log("Mobile shot triggered")
        end
    })

    mobileFlingMurdBtn = Window:CreateMobileButton({
        Text = "Fling murd",
        Type = "Button",
        Visible = true,
        SaveKey = "mobile_fling_murd",
        Callback = function(btn)
            if (tick() - state.startTime) < 2.0 then return end
            local target = state.knifeHolder or getMurd()
            if target and isPlayerAlive(target) then
                log("flinging murderer: " .. target.Name)
                flingTarget(target, true, 3.5)
            else
                log("Murderer not found or dead")
            end
        end
    })

    mobileFlingSheriffBtn = Window:CreateMobileButton({
        Text = "Fling sheriff",
        Type = "Button",
        Visible = true,
        SaveKey = "mobile_fling_sheriff",
        Callback = function(btn)
            if (tick() - state.startTime) < 2.0 then return end
            local target = state.gunHolder or getSheriff()
            if target and isPlayerAlive(target) then
                log("flinging sheriff: " .. target.Name)
                flingTarget(target, true, 3.5)
            else
                log("Sheriff not found or dead")
            end
        end
    })


    -- construct match logging webhook settings
    Tabs.Webhook:AddSection("Discord webhook")
    Tabs.Webhook:AddToggle("WebhookEnabled", {
        Title = "Webhook logger",
        Default = false,
        Callback = function(v)
            state.webhookEnabled = v
            log("Webhook logger: " .. (v and "Enabled" or "Disabled"))
        end
    })

    Tabs.Webhook:AddInput("WebhookUrl", {
        Title = "Webhook url",
        Default = "",
        Placeholder = "https://discord.com/api/webhooks/...",
        Callback = function(text)
            state.webhookUrl = text
        end
    })

    Tabs.Webhook:AddInput("WebhookInterval", {
        Title = "Webhook interval",
        Default = "5m",
        Placeholder = "e.g. 5m, 1h, 30s",
        Callback = function(text)
            state.webhookIntervalStr = text
            state.webhookIntervalSec = parseInterval(text)
        end
    })

    Tabs.Webhook:AddToggleGroup({
        { Name = "Include current coins", Default = true, Callback = function(v) state.webhookCurrentCoins = v end },
        { Name = "Include coins / hour", Default = true, Callback = function(v) state.webhookCoinsPerHour = v end }
    })

    Tabs.Webhook:AddButton({
        Title = "Send test webhook",
        Icon = "send",
        Callback = function()
            sendDiscordWebhook(true)
        end
    })

    -- construct script configuration and reload options
    Tabs.Settings:AddSection("Mobile overlay")

    -- group mobile on-screen buttons
    Tabs.Settings:AddToggleGroup({
        { Name = "Mobile buttons overlay", Default = false, Callback = function(v)
            state.mobileButtonsEnabled = v
            if Window.MobileUI then
                Window.MobileUI.Enabled = v
            end
        end },
        { Name = "Lock button positions", Default = false, Callback = function(v)
            state.lockMobileButtons = v
            if Window.SetMobileButtonsLocked then
                Window:SetMobileButtonsLocked(v)
            end
        end },
        { Name = "Flight button", Default = true, Callback = function(v)
            state.mobileBtnFlightEnabled = v
            if mobileFlyBtn then mobileFlyBtn:SetVisible(v) end
        end },
        { Name = "Camlock button", Default = true, Callback = function(v)
            state.mobileBtnLockEnabled = v
            if mobileCamlockBtn then mobileCamlockBtn:SetVisible(v) end
        end },
        { Name = "Shoot button", Default = true, Callback = function(v)
            state.mobileBtnShootEnabled = v
            if mobileShootBtn then mobileShootBtn:SetVisible(v) end
        end },
        { Name = "Fling murderer button", Default = true, Callback = function(v)
            state.mobileBtnFlingMurdEnabled = v
            if mobileFlingMurdBtn then mobileFlingMurdBtn:SetVisible(v) end
        end },
        { Name = "Fling sheriff button", Default = true, Callback = function(v)
            state.mobileBtnFlingSheriffEnabled = v
            if mobileFlingSheriffBtn then mobileFlingSheriffBtn:SetVisible(v) end
        end }
    })

    Tabs.Settings:AddSection("Server")

    -- group server management shortcuts
    Tabs.Settings:AddButtonRow({
        { Text = "Server hop",    Icon = "shuffle",    Callback = function() serverHop() end },
        { Text = "Rejoin server", Icon = "rotate-ccw", Callback = function() pcall(function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer) end) end }
    }, 31)

    -- render 2d boxes, nametags, and chams highlights for players
    local _espState = { gunLabel = nil, gunOutline = nil, gunChamsObj = nil }
    espPlayers = {}

    local function safeRemoveDrawing(obj)
        if not obj then return end
        pcall(function() obj.Visible = false end)
        pcall(function() obj:Remove() end)
        pcall(function() obj:Destroy() end)
    end

    removeESP = function(player)
        local drawings = espPlayers[player]
        if drawings then
            safeRemoveDrawing(drawings.Box)
            safeRemoveDrawing(drawings.BoxOutline)
            safeRemoveDrawing(drawings.Name)
            if drawings.SkeletonLines then
                for _, line in ipairs(drawings.SkeletonLines) do
                    safeRemoveDrawing(line)
                end
                drawings.SkeletonLines = nil
            end
            if drawings.Highlight then
                pcall(function() drawings.Highlight:Destroy() end)
                drawings.Highlight = nil
            end
            if drawings.HasAdornments and player and player.Character then
                for _, part in ipairs(player.Character:GetChildren()) do
                    if part:IsA("BasePart") then
                        local ch = part:FindFirstChild("AdornChams")
                        if ch then pcall(function() ch:Destroy() end) end
                    end
                end
            end
            espPlayers[player] = nil
        end
    end

    local function hide2DDrawings(drawings)
        if not drawings then return end
        if drawings.BoxVisible then
            drawings.Box.Visible = false
            drawings.BoxVisible = false
        end
        if drawings.BoxOutlineVisible then
            drawings.BoxOutline.Visible = false
            drawings.BoxOutlineVisible = false
        end
        if drawings.NameVisible then
            drawings.Name.Visible = false
            drawings.NameVisible = false
        end
        if drawings.SkeletonLines then
            for _, line in ipairs(drawings.SkeletonLines) do
                if line.Visible then line.Visible = false end
            end
        end
    end

    local function hideESPDrawings(drawings, plr)
        if not drawings then return end
        hide2DDrawings(drawings)
        if drawings.Highlight and drawings.Highlight.Enabled then
            drawings.Highlight.Enabled = false
        end
        if drawings.HasAdornments and plr and plr.Character then
            drawings.HasAdornments = false
            for _, part in ipairs(plr.Character:GetChildren()) do
                if part:IsA("BasePart") then
                    local ch = part:FindFirstChild("AdornChams")
                    if ch then pcall(function() ch.Visible = false end) end
                end
            end
        end
    end

    local function getSkeletonSegments(char)
        local segments = {}
        if not char then return segments end

        local isR15 = char:FindFirstChild("UpperTorso") ~= nil
        if isR15 then
            local r15Joints = {
                {"Head", "UpperTorso"},
                {"UpperTorso", "LowerTorso"},
                {"UpperTorso", "LeftUpperArm"},
                {"LeftUpperArm", "LeftLowerArm"},
                {"LeftLowerArm", "LeftHand"},
                {"UpperTorso", "RightUpperArm"},
                {"RightUpperArm", "RightLowerArm"},
                {"RightLowerArm", "RightHand"},
                {"LowerTorso", "LeftUpperLeg"},
                {"LeftUpperLeg", "LeftLowerLeg"},
                {"LeftLowerLeg", "LeftFoot"},
                {"LowerTorso", "RightUpperLeg"},
                {"RightUpperLeg", "RightLowerLeg"},
                {"RightLowerLeg", "RightFoot"}
            }
            for _, pair in ipairs(r15Joints) do
                local p1 = char:FindFirstChild(pair[1])
                local p2 = char:FindFirstChild(pair[2])
                if p1 and p2 and p1:IsA("BasePart") and p2:IsA("BasePart") then
                    table.insert(segments, {p1.Position, p2.Position})
                end
            end
        else
            local head = char:FindFirstChild("Head")
            local torso = char:FindFirstChild("Torso")
            local lArm = char:FindFirstChild("Left Arm")
            local rArm = char:FindFirstChild("Right Arm")
            local lLeg = char:FindFirstChild("Left Leg")
            local rLeg = char:FindFirstChild("Right Leg")

            if torso and torso:IsA("BasePart") then
                local tCf = torso.CFrame
                local topTorso = tCf:PointToWorldSpace(Vector3.new(0, 0.8, 0))
                local botTorso = tCf:PointToWorldSpace(Vector3.new(0, -0.8, 0))
                local lShoulder = tCf:PointToWorldSpace(Vector3.new(-1, 0.6, 0))
                local rShoulder = tCf:PointToWorldSpace(Vector3.new(1, 0.6, 0))
                local lHip = tCf:PointToWorldSpace(Vector3.new(-0.5, -0.8, 0))
                local rHip = tCf:PointToWorldSpace(Vector3.new(0.5, -0.8, 0))

                if head and head:IsA("BasePart") then
                    table.insert(segments, {topTorso, head.Position})
                end
                table.insert(segments, {topTorso, botTorso})

                if lArm and lArm:IsA("BasePart") then
                    local aCf = lArm.CFrame
                    local lArmTop = aCf:PointToWorldSpace(Vector3.new(0, 0.8, 0))
                    local lArmBot = aCf:PointToWorldSpace(Vector3.new(0, -0.8, 0))
                    table.insert(segments, {lShoulder, lArmTop})
                    table.insert(segments, {lArmTop, lArmBot})
                end
                if rArm and rArm:IsA("BasePart") then
                    local aCf = rArm.CFrame
                    local rArmTop = aCf:PointToWorldSpace(Vector3.new(0, 0.8, 0))
                    local rArmBot = aCf:PointToWorldSpace(Vector3.new(0, -0.8, 0))
                    table.insert(segments, {rShoulder, rArmTop})
                    table.insert(segments, {rArmTop, rArmBot})
                end
                if lLeg and lLeg:IsA("BasePart") then
                    local legCf = lLeg.CFrame
                    local lLegTop = legCf:PointToWorldSpace(Vector3.new(0, 0.8, 0))
                    local lLegBot = legCf:PointToWorldSpace(Vector3.new(0, -0.8, 0))
                    table.insert(segments, {lHip, lLegTop})
                    table.insert(segments, {lLegTop, lLegBot})
                end
                if rLeg and rLeg:IsA("BasePart") then
                    local legCf = rLeg.CFrame
                    local rLegTop = legCf:PointToWorldSpace(Vector3.new(0, 0.8, 0))
                    local rLegBot = legCf:PointToWorldSpace(Vector3.new(0, -0.8, 0))
                    table.insert(segments, {rHip, rLegTop})
                    table.insert(segments, {rLegTop, rLegBot})
                end
            end
        end
        return segments
    end

    local function createESP(player)
        if player == LocalPlayer or not state.espEnabled or espPlayers[player] then return end

        local ok, box        = pcall(function() return Drawing.new("Square") end)
        local ok2, outline   = pcall(function() return Drawing.new("Square") end)
        local ok3, nameLabel = pcall(function() return Drawing.new("Text") end)

        if not ok or not ok2 or not ok3 then
            if ok  then pcall(function() box:Remove() end) end
            if ok2 then pcall(function() outline:Remove() end) end
            if ok3 then pcall(function() nameLabel:Remove() end) end
            return
        end

        box.Thickness = 1.5
        box.Filled = false
        box.Visible = false

        outline.Thickness = 2.5
        outline.Color = Color3.new(0, 0, 0)
        outline.Filled = false
        outline.Visible = false

        nameLabel.Font = Drawing.Fonts and Drawing.Fonts.Michroma or 34
        nameLabel.Size = 17
        nameLabel.Center = true
        nameLabel.Outline = false
        nameLabel.Visible = false

        local skeletonLines = {}
        for i = 1, 16 do
            local okL, line = pcall(function() return Drawing.new("Line") end)
            if okL and line then
                line.Thickness = state.skeletonThickness or 1.5
                line.Transparency = 1 - (state.skeletonTransparency or 0)
                line.Visible = false
                table.insert(skeletonLines, line)
            end
        end

        espPlayers[player] = {
            Box               = box,
            BoxOutline        = outline,
            Name              = nameLabel,
            SkeletonLines     = skeletonLines,
            Highlight         = nil,
            BoxVisible        = false,
            BoxOutlineVisible = false,
            NameVisible       = false,
            LastRole          = nil,
            LastRoleColor     = nil,
            LastChamsMode     = nil,
            LastNameText      = nil,
            LastNameColor     = nil,
            LastBoxColor      = nil,
            HasAdornments     = false,
        }
    end

    registerCleanupHook(function()
        for plr, _ in pairs(espPlayers) do
            removeESP(plr)
        end
        table.clear(espPlayers)
        safeRemoveDrawing(_espState.gunOutline)
        _espState.gunOutline = nil
        safeRemoveDrawing(_espState.gunLabel)
        _espState.gunLabel = nil
        if _espState.gunChamsObj then
            pcall(function() _espState.gunChamsObj:Destroy() end)
            _espState.gunChamsObj = nil
        end
    end)

    trackConnection(Players.PlayerAdded:Connect(function(plr)
        if plr ~= LocalPlayer and state.espEnabled then
            createESP(plr)
        end
    end))

    trackConnection(Players.PlayerRemoving:Connect(function(plr)
        removeESP(plr)
    end))

    local espLoopThread = task.spawn(function()
        local _frameRoles = {}
        local _frameMurderer, _frameSheriff = nil, nil
        local lastGunSearch = 0
        local cachedGunObj = nil
        local wasEspEnabled = false

        local function getPlayerRoleCached(plr)
            local cached = _frameRoles[plr]
            if cached then return cached end

            local role
            if plr == _frameMurderer and isPlayerAlive(plr) then
                role = "Murderer"
            elseif plr == _frameSheriff and isPlayerAlive(plr) then
                role = "Sheriff"
            elseif hasTool(plr, "Knife") then
                role = "Murderer"
            elseif hasTool(plr, "Gun") then
                role = "Sheriff"
            else
                role = "Innocent"
            end
            _frameRoles[plr] = role
            return role
        end

        while not state.unloaded do
            if not state.espEnabled then
                if wasEspEnabled then
                    wasEspEnabled = false
                    for plr, drawings in pairs(espPlayers) do
                        hideESPDrawings(drawings, plr)
                    end
                    if _espState.gunLabel and _espState.gunLabel.Visible then
                        _espState.gunLabel.Visible = false
                    end
                    if _espState.gunOutline and _espState.gunOutline.Visible then
                        _espState.gunOutline.Visible = false
                    end
                    if _espState.gunChamsObj then
                        pcall(function() _espState.gunChamsObj:Destroy() end)
                        _espState.gunChamsObj = nil
                    end
                end
                task.wait(0.2)
            else
                wasEspEnabled = true
                table.clear(_frameRoles)
                _frameMurderer = state.knifeHolder
                _frameSheriff  = state.gunHolder

                local cam = CurrentCamera
                local camPos = cam and cam.CFrame.Position
                local maxDist = state.espMaxDistance or 1000
                local chamsOn = state.chamsEnabled
                local cMode   = state.chamsMode or "Highlight"
                local murdCol = state.chamsMurdererColor or Color3.fromRGB(255, 70, 70)
                local sherCol = state.chamsSheriffColor or Color3.fromRGB(90, 120, 255)
                local innoCol = state.chamsInnocentColor or Color3.fromRGB(50, 230, 110)

                for _, plr in ipairs(Players:GetPlayers()) do
                    if plr ~= LocalPlayer then
                        if not espPlayers[plr] then
                            createESP(plr)
                        end
                        local drawings = espPlayers[plr]
                        if drawings then
                            local char = plr.Character
                            local hrp  = char and char:FindFirstChild("HumanoidRootPart")
                            local hum  = char and char:FindFirstChildOfClass("Humanoid")
                            local alive = hrp and hum and hum.Health > 0

                            if not alive or not camPos then
                                hideESPDrawings(drawings, plr)
                            else
                                local hrpPos = hrp.Position
                                local playerDist = (hrpPos - camPos).Magnitude

                                if playerDist > maxDist then
                                    hideESPDrawings(drawings, plr)
                                else
                                    local role = getPlayerRoleCached(plr)
                                    local roleColor = (role == "Murderer" and murdCol)
                                        or (role == "Sheriff" and sherCol)
                                        or innoCol

                                    -- refresh highlight styles when role shifts
                                    if chamsOn then
                                        if cMode == "Highlight" or cMode == "Glow Outline" or cMode == "Fill Only" then
                                            -- destroy leftover adornments before switching mode
                                            if drawings.HasAdornments then
                                                drawings.HasAdornments = false
                                                for _, part in ipairs(char:GetChildren()) do
                                                    if part:IsA("BasePart") then
                                                        local ch1 = part:FindFirstChild("AdornChams")
                                                        if ch1 then pcall(function() ch1:Destroy() end) end
                                                    end
                                                end
                                            end

                                            local hl = drawings.Highlight
                                            if not hl or hl.Parent ~= char then
                                                if hl then pcall(function() hl:Destroy() end) end
                                                hl = Instance.new("Highlight")
                                                hl.Name = "ChamsHighlight"
                                                hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                                                hl.Parent = char
                                                drawings.Highlight = hl
                                                drawings.LastRoleColor = nil
                                                drawings.LastChamsMode = nil
                                            end

                                            if drawings.LastRoleColor ~= roleColor or drawings.LastChamsMode ~= cMode
                                                or drawings.LastFillTransp ~= state.chamsFillTransparency
                                                or drawings.LastOutlineTransp ~= state.chamsOutlineTransparency then
                                                hl.FillColor = roleColor
                                                hl.OutlineColor = roleColor
                                                local fillT    = state.chamsFillTransparency    or 0.45
                                                local outlineT = state.chamsOutlineTransparency or 0
                                                if cMode == "Glow Outline" then
                                                    hl.FillTransparency    = 1.0
                                                    hl.OutlineTransparency = outlineT
                                                elseif cMode == "Fill Only" then
                                                    hl.FillTransparency    = fillT
                                                    hl.OutlineTransparency = 1.0
                                                else
                                                    hl.FillTransparency    = fillT
                                                    hl.OutlineTransparency = outlineT
                                                end
                                                drawings.LastRoleColor    = roleColor
                                                drawings.LastChamsMode    = cMode
                                                drawings.LastFillTransp   = state.chamsFillTransparency
                                                drawings.LastOutlineTransp = state.chamsOutlineTransparency
                                            end
                                            if not hl.Enabled then
                                                hl.Enabled = true
                                            end
                                        elseif cMode == "Box Adornment" then
                                            if drawings.Highlight and drawings.Highlight.Enabled then
                                                drawings.Highlight.Enabled = false
                                            end
                                            drawings.HasAdornments = true
                                            for _, part in ipairs(char:GetChildren()) do
                                                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                                                    local adorn = part:FindFirstChild("AdornChams")
                                                    if not adorn then
                                                        adorn = Instance.new("BoxHandleAdornment")
                                                        adorn.Name = "AdornChams"
                                                        adorn.AlwaysOnTop = true
                                                        adorn.ZIndex = 5
                                                        adorn.Adornee = part
                                                        adorn.Parent = part
                                                    end
                                                    adorn.Size = part.Size + Vector3.new(0.04, 0.04, 0.04)
                                                    adorn.Color3 = roleColor
                                                    adorn.Transparency = 0.35
                                                    adorn.Visible = true
                                                end
                                            end
                                        end
                                    else
                                        if drawings.Highlight and drawings.Highlight.Enabled then
                                            drawings.Highlight.Enabled = false
                                        end
                                        if drawings.HasAdornments then
                                            drawings.HasAdornments = false
                                            for _, part in ipairs(char:GetChildren()) do
                                                if part:IsA("BasePart") then
                                                    local ch1 = part:FindFirstChild("AdornChams")
                                                    if ch1 then pcall(function() ch1:Destroy() end) end
                                                end
                                            end
                                        end
                                    end

                                    -- project 3d player bounds onto screen space
                                    local rootScreen, onScreen = cam:WorldToViewportPoint(hrpPos)
                                    if not onScreen or rootScreen.Z <= 0 then
                                        hide2DDrawings(drawings)
                                    else
                                        local topScr = cam:WorldToViewportPoint(hrpPos + Vector3.new(0, 3.0, 0))
                                        local botScr = cam:WorldToViewportPoint(hrpPos - Vector3.new(0, 3.2, 0))
                                        local height = math.abs(topScr.Y - botScr.Y)
                                        local width  = height * 0.55
                                        local boxX   = rootScreen.X - width * 0.5
                                        local boxY   = topScr.Y

                                        if state.boxEspEnabled then
                                            local box = drawings.Box
                                            box.Size = Vector2.new(width, height)
                                            box.Position = Vector2.new(boxX, boxY)
                                            if drawings.LastBoxColor ~= roleColor then
                                                box.Color = roleColor
                                                drawings.LastBoxColor = roleColor
                                            end
                                            if not drawings.BoxVisible then
                                                box.Visible = true
                                                drawings.BoxVisible = true
                                            end
                                        elseif drawings.BoxVisible then
                                            drawings.Box.Visible = false
                                            drawings.BoxVisible = false
                                        end

                                        if state.nameEspEnabled or state.roleEspEnabled then
                                            local nameLabel = drawings.Name
                                            nameLabel.Position = Vector2.new(rootScreen.X, boxY - 16)
                                            local curNameSetting = (state.nameEspEnabled == true)
                                            local curRoleSetting = (state.roleEspEnabled == true)
                                            if drawings.LastRole ~= role or drawings.LastNameSetting ~= curNameSetting or drawings.LastRoleSetting ~= curRoleSetting or drawings.LastNameText == nil then
                                                local textParts = {}
                                                if curNameSetting then
                                                    table.insert(textParts, plr.Name)
                                                end
                                                if curRoleSetting then
                                                    table.insert(textParts, "[" .. role .. "]")
                                                end
                                                local textStr = table.concat(textParts, " ")
                                                nameLabel.Text = textStr
                                                drawings.LastNameText = textStr
                                                drawings.LastRole = role
                                                drawings.LastNameSetting = curNameSetting
                                                drawings.LastRoleSetting = curRoleSetting
                                            end
                                            if drawings.LastNameColor ~= roleColor then
                                                nameLabel.Color = roleColor
                                                drawings.LastNameColor = roleColor
                                            end
                                            if not drawings.NameVisible then
                                                nameLabel.Visible = true
                                                drawings.NameVisible = true
                                            end
                                        elseif drawings.NameVisible then
                                            drawings.Name.Visible = false
                                            drawings.NameVisible = false
                                        end

                                        -- render character skeleton lines connecting joints
                                        if state.skeletonEspEnabled and drawings.SkeletonLines then
                                            local segments = getSkeletonSegments(char)
                                            local totalSegs = #segments
                                            local skelMode = state.skeletonColorMode or "Normal"
                                            local skelUseRole = (state.skeletonUseRoleColor ~= false)
                                            local c1 = (skelUseRole and roleColor) or (state.skeletonColor or Color3.fromRGB(255, 255, 255))
                                            local c2 = state.skeletonColor2 or Color3.fromRGB(0, 170, 255)
                                            local shiftSpeed = state.colorShiftSpeed or 3
                                            local skelThickness = state.skeletonThickness or 1.5
                                            local skelTrans = 1 - (state.skeletonTransparency or 0)

                                            for i, line in ipairs(drawings.SkeletonLines) do
                                                if i <= totalSegs then
                                                    local seg = segments[i]
                                                    local pA, onA = cam:WorldToViewportPoint(seg[1])
                                                    local pB, onB = cam:WorldToViewportPoint(seg[2])
                                                    if (onA or onB) and pA.Z > 0 and pB.Z > 0 then
                                                        line.From = Vector2.new(pA.X, pA.Y)
                                                        line.To = Vector2.new(pB.X, pB.Y)
                                                        line.Thickness = skelThickness
                                                        line.Transparency = skelTrans

                                                        local charHeight = (height and height > 1) and height or 50
                                                        local midY = (pA.Y + pB.Y) * 0.5
                                                        local vertRatio = math.clamp((midY - boxY) / charHeight, 0, 1)
                                                        local segColor = c1

                                                        if skelMode == "Shift" then
                                                            local tVal = (math.sin(tick() * shiftSpeed) + 1) * 0.5
                                                            segColor = c1:Lerp(c2, tVal)
                                                        elseif skelMode == "Gradient" then
                                                            local tVal = (math.sin((vertRatio * math.pi * 2) - (tick() * shiftSpeed * 1.5)) + 1) * 0.5
                                                            segColor = c1:Lerp(c2, tVal)
                                                        elseif skelMode == "Rainbow" then
                                                            local hue = ((tick() * (shiftSpeed * 0.15)) + (vertRatio * 0.5)) % 1.0
                                                            segColor = Color3.fromHSV(hue, 1, 1)
                                                        end

                                                        line.Color = segColor
                                                        line.Visible = true
                                                    else
                                                        line.Visible = false
                                                    end
                                                else
                                                    line.Visible = false
                                                end
                                            end
                                        elseif drawings.SkeletonLines then
                                            for _, line in ipairs(drawings.SkeletonLines) do
                                                if line.Visible then line.Visible = false end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                end

                -- locate dropped gun in workspace for esp
                if state.gunEspEnabled and state.roundActive then
                    local now = tick()
                    if now - lastGunSearch >= 0.3 or not cachedGunObj or not cachedGunObj.Parent then
                        lastGunSearch = now
                        cachedGunObj = getDroppedGun()
                    end

                    local gunObj = cachedGunObj
                    local gunPos = nil
                    if gunObj and gunObj.Parent then
                        if gunObj:IsA("BasePart") then
                            gunPos = gunObj.Position
                        elseif gunObj:IsA("Model") then
                            local pp = gunObj.PrimaryPart or gunObj:FindFirstChildWhichIsA("BasePart", true)
                            if pp then gunPos = pp.Position end
                        end

                        if not _espState.gunChamsObj or _espState.gunChamsObj.Parent ~= gunObj then
                            if _espState.gunChamsObj then
                                pcall(function() _espState.gunChamsObj:Destroy() end)
                            end
                            local hl = Instance.new("Highlight")
                            hl.Name = "GunChams"
                            hl.FillColor = Color3.fromRGB(255, 220, 50)
                            hl.OutlineColor = Color3.fromRGB(255, 255, 255)
                            hl.FillTransparency = 0.35
                            hl.OutlineTransparency = 0
                            hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                            hl.Parent = gunObj
                            _espState.gunChamsObj = hl
                        end
                        if not _espState.gunChamsObj.Enabled then
                            _espState.gunChamsObj.Enabled = true
                        end
                    else
                        if _espState.gunChamsObj then
                            pcall(function() _espState.gunChamsObj:Destroy() end)
                            _espState.gunChamsObj = nil
                        end
                    end

                    if gunPos and cam then
                        local scr, onScr = cam:WorldToViewportPoint(gunPos)
                        if onScr and scr.Z > 0 then
                            if not _espState.gunOutline then
                                local ok2, obj = pcall(function() return Drawing.new("Text") end)
                                if ok2 then
                                    obj.Font = Drawing.Fonts and Drawing.Fonts.Michroma or 34
                                    obj.Size = 18
                                    obj.Outline = false
                                    obj.Color = Color3.fromRGB(0, 0, 0)
                                    obj.Center = true
                                    obj.ZIndex = 4
                                    _espState.gunOutline = obj
                                end
                            end
                            if not _espState.gunLabel then
                                local ok3, obj = pcall(function() return Drawing.new("Text") end)
                                if ok3 then
                                    obj.Font = Drawing.Fonts and Drawing.Fonts.Michroma or 34
                                    obj.Size = 18
                                    obj.Color = Color3.fromRGB(255, 220, 50)
                                    obj.Center = true
                                    obj.ZIndex = 5
                                    _espState.gunLabel = obj
                                end
                            end
                            local dist = math.floor((gunPos - camPos).Magnitude)
                            local labelText = "[GUN] " .. dist .. "m"
                            local labelPos  = Vector2.new(scr.X, scr.Y - 8)

                            if _espState.gunOutline then
                                _espState.gunOutline.Text     = labelText
                                _espState.gunOutline.Position = labelPos
                                _espState.gunOutline.Visible  = true
                            end
                            if _espState.gunLabel then
                                _espState.gunLabel.Text       = labelText
                                _espState.gunLabel.Position   = labelPos
                                _espState.gunLabel.Visible    = true
                            end
                        else
                            if _espState.gunLabel and _espState.gunLabel.Visible then _espState.gunLabel.Visible = false end
                            if _espState.gunOutline and _espState.gunOutline.Visible then _espState.gunOutline.Visible = false end
                        end
                    else
                        if _espState.gunLabel and _espState.gunLabel.Visible then _espState.gunLabel.Visible = false end
                        if _espState.gunOutline and _espState.gunOutline.Visible then _espState.gunOutline.Visible = false end
                    end
                else
                    if _espState.gunLabel and _espState.gunLabel.Visible then _espState.gunLabel.Visible = false end
                    if _espState.gunOutline and _espState.gunOutline.Visible then _espState.gunOutline.Visible = false end
                    if _espState.gunChamsObj then
                        pcall(function() _espState.gunChamsObj:Destroy() end)
                        _espState.gunChamsObj = nil
                    end
                end

                RunService.RenderStepped:Wait()
            end
        end
    end)
    trackThread(espLoopThread)

    -- enforce configured movement speed multiplier 
    local speedThread = task.spawn(function()
        while not state.unloaded do
            local char = LocalPlayer.Character
            local hum = char and char:FindFirstChildOfClass("Humanoid")
            if hum then
                if state.speedEnabled and state.speedMode == "WalkSpeed" then
                    hum.WalkSpeed = state.speedValue
                elseif hum.WalkSpeed ~= 16 and (not state.speedEnabled or state.speedMode == "CFrame") then
                    hum.WalkSpeed = 16
                end
            end
            task.wait(0.1)
        end
    end)
    trackThread(speedThread)

    local isAirborneFromJump = false
    local lastJumpTick = 0

    local function hookBhopHumanoid(hum)
        if not hum then return end
        trackConnection(hum.StateChanged:Connect(function(oldState, newState)
            if newState == Enum.HumanoidStateType.Jumping then
                isAirborneFromJump = true
                lastJumpTick = os.clock()
            elseif newState == Enum.HumanoidStateType.Landed or newState == Enum.HumanoidStateType.Running then
                if os.clock() - lastJumpTick > 0.15 then
                    isAirborneFromJump = false
                end
            elseif newState == Enum.HumanoidStateType.Dead or newState == Enum.HumanoidStateType.Seated then
                isAirborneFromJump = false
            end
        end))
        trackConnection(hum.Jumping:Connect(function(active)
            if active then
                isAirborneFromJump = true
                lastJumpTick = os.clock()
            end
        end))
    end

    if LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid") then
        hookBhopHumanoid(LocalPlayer.Character:FindFirstChildOfClass("Humanoid"))
    end
    trackConnection(LocalPlayer.CharacterAdded:Connect(function(char)
        isAirborneFromJump = false
        lastJumpTick = 0
        local hum = char:WaitForChild("Humanoid", 5)
        if hum then
            hookBhopHumanoid(hum)
        end
    end))
    trackConnection(UserInputService.JumpRequest:Connect(function()
        local char = LocalPlayer.Character
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if hum and hum.FloorMaterial ~= Enum.Material.Air and hum.Health > 0 and not hum.Sit then
            isAirborneFromJump = true
            lastJumpTick = os.clock()
        end
    end))

    local cframeSpeedConn = RunService.Heartbeat:Connect(function(dt)
        if state.unloaded or state.flightEnabled then return end
        local char = LocalPlayer.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        local hum = char and char:FindFirstChildOfClass("Humanoid")
        if not hrp or not hum or hum.Health <= 0 or hum.Sit then return end

        if hum.FloorMaterial ~= Enum.Material.Air and (os.clock() - lastJumpTick > 0.15) then
            isAirborneFromJump = false
        end

        if state.bhopEnabled and state.autoBhop and hum.FloorMaterial ~= Enum.Material.Air and (hum.MoveDirection.Magnitude > 0.05 or UserInputService:IsKeyDown(Enum.KeyCode.Space)) then
            isAirborneFromJump = true
            lastJumpTick = os.clock()
            hum.Jump = true
            pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end)
        end

        local md = hum.MoveDirection
        local flat = Vector3.new(md.X, 0, md.Z)
        if flat.Magnitude > 0.05 then
            local extraSpeed = 0
            if state.bhopEnabled and isAirborneFromJump then
                local currentY = hrp.AssemblyLinearVelocity.Y
                local baseSpeed = math.min(state.bhopSpeed, 16)
                hrp.AssemblyLinearVelocity = Vector3.new(flat.Unit.X * baseSpeed, currentY, flat.Unit.Z * baseSpeed)
                extraSpeed = math.max(0, state.bhopSpeed - baseSpeed)
            elseif state.speedEnabled and state.speedMode == "CFrame" then
                extraSpeed = math.max(0, state.speedValue - 16)
            end
            if extraSpeed > 0 then
                local clampedDt = math.min(dt, 0.1)
                hrp.CFrame = hrp.CFrame + (flat.Unit * (extraSpeed * clampedDt))
            end
        end
    end)
    trackConnection(cframeSpeedConn)

    -- align camera with active target position 
    local aimbotThread = task.spawn(function()
        while not state.unloaded do
            if state.aimbotEnabled and not camlockSettings.isLockedOn then
                local targetPlr = nil
                local localHasKnife = hasTool(LocalPlayer, "Knife")
            
                if localHasKnife then
                    if state.gunHolder and isPlayerAlive(state.gunHolder) and state.gunHolder ~= LocalPlayer then
                        targetPlr = state.gunHolder
                    else
                        local closestDist = math.huge
                        local lHrp = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if lHrp then
                            for _, p in ipairs(Players:GetPlayers()) do
                                if p ~= LocalPlayer and isPlayerAlive(p) then
                                    local pHrp = p.Character and p.Character:FindFirstChild("HumanoidRootPart")
                                    if pHrp then
                                        local dist = (pHrp.Position - lHrp.Position).Magnitude
                                        if dist < closestDist then
                                            closestDist = dist
                                            targetPlr = p
                                        end
                                    end
                                end
                            end
                        end
                    end
                else
                    if state.knifeHolder and isPlayerAlive(state.knifeHolder) and state.knifeHolder ~= LocalPlayer then
                        targetPlr = state.knifeHolder
                    end
                end
            
                if targetPlr and isPlayerAlive(targetPlr) then
                    local tHrp = targetPlr.Character and targetPlr.Character:FindFirstChild("HumanoidRootPart")
                    if tHrp then
                        CurrentCamera.CFrame = CFrame.new(CurrentCamera.CFrame.Position, tHrp.Position)
                    end
                end
            end
            task.wait(0.02)
        end
    end)
    trackThread(aimbotThread)

    -- handle keybind shortcuts and mouse triggers
    local silentAimFiring = false
    -- trigger aim assist on click or touch activation
    trackConnection(UserInputService.InputBegan:Connect(function(input, gpe)
        if gpe then return end
        local focused = UserInputService:GetFocusedTextBox()
        if focused then return end

        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            if (state and (state.autoAimEnabled or (silentAimConfig and silentAimConfig.enabled))) and not silentAimFiring then
                local hasGun = hasTool(LocalPlayer, "Gun")
                if hasGun then
                    local target, tPart = nil, nil
                    if state.autoAimEnabled then
                        target, tPart = getAutoAimTarget()
                    elseif silentAimConfig and silentAimConfig.enabled then
                        local t, p, _ = getSilentAimTarget()
                        target, tPart = t, p
                    end

                    if target and isPlayerAlive(target) then
                        local targetChar = target.Character
                        local isWallbang = (state and state.autoAimWallbang) or (silentAimConfig and silentAimConfig.wallbang)

                        local shootPart = tPart
                        if isWallbang and targetChar then
                            shootPart = targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Torso") or targetChar:FindFirstChild("LowerTorso") or tPart
                        else
                            shootPart = tPart or (targetChar and (targetChar:FindFirstChild(silentAimConfig and silentAimConfig.targetPart or "Head") or targetChar:FindFirstChild("HumanoidRootPart") or targetChar:FindFirstChild("UpperTorso") or targetChar:FindFirstChild("Head")))
                        end

                        if shootPart then
                            local shootEvent = getGunShootEvent()
                            if shootEvent then
                                silentAimFiring = true
                                task.spawn(function()
                                    task.wait(0.01)
                                    local rawPos = shootPart.Position
                                    local predH, predV = getSilentAimPred()
                                    local targetPos = calculateAimPosition(rawPos, shootPart, predH, predV)
                                    -- prediction delta: how much the target will have moved
                                    local predDelta = targetPos - rawPos

                                    local originPos = nil
                                    if isWallbang and targetChar then
                                        local head = targetChar:FindFirstChild("Head")
                                        local headPos = head and head.Position or (rawPos + Vector3.new(0, 1.5, 0))
                                        -- shift wallbang origin by the same prediction delta so the
                                        -- ray travels with the predicted character, not the stale one
                                        originPos = headPos + predDelta
                                    else
                                        local handle = getOwnGunHandle()
                                        local char = LocalPlayer.Character
                                        local myHrp = char and char:FindFirstChild("HumanoidRootPart")
                                        originPos = handle and (handle.CFrame * CFrame.new(0, 0.5, -1)).Position or (myHrp and myHrp.Position or Vector3.zero)
                                    end

                                    pcall(function()
                                        shootEvent:FireServer(CFrame.new(originPos, targetPos), CFrame.new(targetPos))
                                    end)
                                    task.wait(0.01)
                                    silentAimFiring = false
                                end)
                            end
                        end
                    end
                end
            end
        end
    end))

    -- minimize ui panel on keypress
    trackConnection(UserInputService.InputEnded:Connect(function(input, gpe)
        if gpe then return end
        local focused = UserInputService:GetFocusedTextBox()
        if focused then return end

        local kc = input.KeyCode
        if kc == Enum.KeyCode.Unknown then return end

        local menuKey = toKeyCode(state.menuToggleKey or Enum.KeyCode.End)
        if menuKey and kc == menuKey then
            Window.Minimized = not Window.Minimized
        end
    end))

    -- passive anti afk after 10 minutes of user inactivity
    local lastUserActionTick = tick()
    trackConnection(UserInputService.InputBegan:Connect(function()
        lastUserActionTick = tick()
    end))
    trackConnection(UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            lastUserActionTick = tick()
        end
    end))

    local safeKeys = {
        Enum.KeyCode.RightControl,
        Enum.KeyCode.RightAlt,
        Enum.KeyCode.PageDown,
        Enum.KeyCode.End,
        Enum.KeyCode.Insert
    }

    local antiAfkThread = task.spawn(function()
        local vim = nil
        pcall(function() vim = game:GetService("VirtualInputManager") end)
        local vu = nil
        pcall(function() vu = game:GetService("VirtualUser") end)

        while not state.unloaded do
            task.wait(10)
            if (tick() - lastUserActionTick) >= 600 then
                lastUserActionTick = tick()
                pcall(function()
                    local key = safeKeys[math.random(1, #safeKeys)]
                    if vim then
                        vim:SendKeyEvent(true, key, false, game)
                        task.wait(0.05)
                        vim:SendKeyEvent(false, key, false, game)
                    elseif vu then
                        vu:CaptureController()
                        vu:ClickButton2(Vector2.new(0, 0))
                    end
                end)
            end
        end
    end)
    trackThread(antiAfkThread)

    trackConnection(LocalPlayer.Idled:Connect(function()
        pcall(function()
            local vu = game:GetService("VirtualUser")
            if vu then
                vu:CaptureController()
                vu:ClickButton2(Vector2.new(0, 0))
            end
        end)
    end))

    -- restore saved profile settings on startup
    task.spawn(function()
        if Window.SnapshotDefaultConfig then
            Window:SnapshotDefaultConfig()
        end
        local auto = Window:GetAutoloadConfig()
        if auto and auto ~= "" and auto:upper() ~= "NONE" then
            task.wait(0.3)
            Window:LoadConfig(auto)
        end
    end)

end
_buildScriptUI()
