local genv = (type(getgenv) == "function" and getgenv()) or _G
if type(genv.VyDiamondMountain) == "table" and type(genv.VyDiamondMountain.Stop) == "function" then
    pcall(genv.VyDiamondMountain.Stop)
    task.wait(0.3)
end

local K, V, G, UI, F = {}, {}, {}, {}, {}

K.TAG = "[VY DiamondMountain] "
K.VERSION = "1.0.0"
K.INSTANCE_ID = "DiamondMountain"
K.CURRENCY = "TrailCoins"
K.MERCHANT = "DiamondMountainMerchant"
K.UPGRADE_MACHINE = "DiamondMountainUpgradeMachine"
K.MERCHANT_REACH = 30
K.MACHINE_REACH = 8
K.CAMP_TOLERANCE = 12
K.LIB_FILE = "VyLib.lua"
K.LIB_URLS = {
    "https://raw.githubusercontent.com/92tg/VYHUB/main/VyLib.lua",
}

K.CAMPS = {
    { Number = 1, Name = "#1 Maple Trailhead",   Egg = "Trailhead Egg",      Pos = Vector3.new(-29982.732421875, 302.99798583984375, 30234.884765625) },
    { Number = 2, Name = "#2 Russet Falls",      Egg = "Russet Falls Egg",   Pos = Vector3.new(-29624.287109375, 362.99798583984375, 30536.87890625) },
    { Number = 3, Name = "#3 Boulder Ridge",     Egg = "Boulder Ridge Egg",  Pos = Vector3.new(-29487.91796875, 437.99798583984375, 30912.603515625) },
    { Number = 4, Name = "#4 Eagle Crag",        Egg = "Eagle Crag Egg",     Pos = Vector3.new(-29671.43359375, 527.9979858398438, 31273.4453125) },
    { Number = 5, Name = "#5 Frostline Pass",    Egg = "Frostline Egg",      Pos = Vector3.new(-30052.294921875, 633.1180419921875, 31315.068359375) },
    { Number = 6, Name = "#6 The Diamond Summit", Egg = "Diamond Summit Egg", Pos = Vector3.new(-30138.53125, 752.9979858398438, 30915.35546875) },
}
K.CAMP_NAMES = {}
K.CAMP_BY_NAME = {}
K.CAMP_BY_EGG = {}
for _, c in ipairs(K.CAMPS) do
    K.CAMP_NAMES[#K.CAMP_NAMES + 1] = c.Name
    K.CAMP_BY_NAME[c.Name] = c
    K.CAMP_BY_EGG[c.Egg] = c
end

K.UPGRADES = {
    { Key = "WallPower",       Id = "DiamondMountainWallPower",       Name = "Wall Power" },
    { Key = "WallSlots",       Id = "DiamondMountainWallSlots",       Name = "Wall Slots", Retired = true },
    { Key = "OfflineHours",    Id = "DiamondMountainOfflineHours",    Name = "Offline Hours" },
    { Key = "CoinFinder",      Id = "DiamondMountainCoinFinder",      Name = "Acorn Finder" },
    { Key = "TrailLuck",       Id = "DiamondMountainTrailLuck",       Name = "Trail Luck" },
    { Key = "ExpeditionSpeed", Id = "DiamondMountainExpeditionSpeed", Name = "Expedition Speed" },
}
K.OBJECTIVES = { "Balanced (cheapest first)", "Luck (eggs)", "Acorns (farming)", "Walls / Yeti damage", "Expeditions" }
K.OBJECTIVE_ORDER = {
    ["Balanced (cheapest first)"] = nil,
    ["Luck (eggs)"]            = { "TrailLuck", "CoinFinder", "WallPower", "OfflineHours", "ExpeditionSpeed" },
    ["Acorns (farming)"]       = { "CoinFinder", "WallPower", "OfflineHours", "TrailLuck", "ExpeditionSpeed" },
    ["Walls / Yeti damage"]    = { "WallPower", "OfflineHours", "CoinFinder", "TrailLuck", "ExpeditionSpeed" },
    ["Expeditions"]            = { "ExpeditionSpeed", "OfflineHours", "CoinFinder", "TrailLuck", "WallPower" },
}

K.BOOSTS = {
    { Key = "Coins",  Label = "Acorns Boost", Item = "Trail Coins Boost",  Ids = { "DiamondMountainCoins1",  "DiamondMountainCoins2" } },
    { Key = "Luck",   Label = "Luck Boost",   Item = "Trail Luck Boost",   Ids = { "DiamondMountainLuck1",   "DiamondMountainLuck2" } },
    { Key = "Damage", Label = "Damage Boost", Item = "Trail Damage Boost", Ids = { "DiamondMountainDamage1", "DiamondMountainDamage2" } },
}

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local state = {
    alive = true,
    hatched = 0,
    farmTicks = 0,
    upgradesBought = 0,
    boostsUsed = 0,
    merchantBought = 0,
    artifactsFound = 0,
    excursion = nil,
    taps = 0,
    trailHatched = 0,
    hatchRequests = 0,
    yetiPetsSent = 0,
    lastCampTeleport = 0,
    status = "starting",
    campTarget = nil,
    hatchTarget = nil,
}
local connections = {}
local restoreFns = {}
local logOnceSeen = {}

local function log(fmt, ...)
    local ok, msg = pcall(string.format, fmt, ...)
    print(K.TAG .. (ok and msg or tostring(fmt)))
end
local function warnlog(fmt, ...)
    local ok, msg = pcall(string.format, fmt, ...)
    warn(K.TAG .. (ok and msg or tostring(fmt)))
end
local function logOnce(key, fmt, ...)
    if logOnceSeen[key] then return end
    logOnceSeen[key] = true
    warnlog(fmt, ...)
end
local function track(conn)
    if conn then connections[#connections + 1] = conn end
    return conn
end

K.IDENTITY_GAME = 2
local canSetIdentity = type(setthreadidentity) == "function"
K.IDENTITY_EXEC = 7
if type(getthreadidentity) == "function" then
    local ok, id = pcall(getthreadidentity)
    if ok and type(id) == "number" then K.IDENTITY_EXEC = id end
end

local function gcall(fn, ...)
    if type(fn) ~= "function" then return false, "gcall: not a function" end
    if canSetIdentity then pcall(setthreadidentity, K.IDENTITY_GAME) end
    local r = table.pack(pcall(fn, ...))
    if canSetIdentity then pcall(setthreadidentity, K.IDENTITY_EXEC) end
    return table.unpack(r, 1, r.n)
end
local function gval(fn, ...)
    local ok, a, b, c = gcall(fn, ...)
    if ok then return a, b, c end
    return nil
end
local function isfn(t, k)
    return type(t) == "table" and type(t[k]) == "function"
end

local function notify(title, desc, dur)
    if genv.Library and type(genv.Library.Notification) == "function" then
        pcall(function() genv.Library:Notification(title, desc, dur or 5) end)
        return
    end
    pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", { Title = "VY HUB - " .. tostring(title), Text = tostring(desc), Duration = dur or 5 })
    end)
end

local function loadLibrary()
    local src
    if type(isfile) == "function" and type(readfile) == "function" then
        local ok, exists = pcall(isfile, K.LIB_FILE)
        if ok and exists then
            local okR, content = pcall(readfile, K.LIB_FILE)
            if okR and type(content) == "string" and #content > 1000 then src = content end
        end
    end
    if not src and type(genv.VyHub_LibUrl) == "string" then
        local ok, content = pcall(game.HttpGet, game, genv.VyHub_LibUrl)
        if ok and type(content) == "string" and #content > 1000 then src = content end
    end
    if not src then
        for _, url in ipairs(K.LIB_URLS) do
            local ok, content = pcall(game.HttpGet, game, url)
            if ok and type(content) == "string" and #content > 1000 then src = content break end
        end
    end
    assert(src, "VyLib could not be loaded from github.com/92tg/VYHUB (no internet / HttpGet blocked?)")
    if genv.Library and type(genv.Library.Unload) == "function" then pcall(function() genv.Library:Unload() end) end
    local fn, err = loadstring(src, "=VyLib")
    assert(fn, "VyLib failed to compile: " .. tostring(err))
    local lib = fn()
    if lib == nil then lib = genv.Library end
    assert(type(lib) == "table", "VyLib did not return the Library table")
    genv.Library = lib
    return lib
end

Library = loadLibrary()

local function req(path)
    local ok, mod = gcall(function()
        local node = RS
        for seg in string.gmatch(path, "[^%.]+") do
            node = node:WaitForChild(seg, 5)
            if not node then error("missing " .. path) end
        end
        return require(node)
    end)
    if ok then return mod end
    logOnce("mod-" .. path, "module %s unavailable: %s", path, tostring(mod))
    return nil
end

G.Network = req("Library.Client.Network")
G.Save = req("Library.Client.Save")
G.Instancing = req("Library.Client.InstancingCmds")
G.InstanceZone = req("Library.Client.InstanceZoneCmds")
G.CustomEggs = req("Library.Client.CustomEggsCmds")
G.EggCmds = req("Library.Client.EggCmds")
G.EventUpgradeCmds = req("Library.Client.EventUpgradeCmds")
G.EventUpgrades = req("Library.Directory.EventUpgrades")
G.Eggs = req("Library.Directory.Eggs")
G.BoostCmds = req("Library.Client.BoostCmds")
G.CurrencyCmds = req("Library.Client.CurrencyCmds")
G.DMCmds = req("Library.Client.DiamondMountainCmds")
G.DM = req("Library.Types.DiamondMountain")
G.DMMerchant = req("Library.Util.DiamondMountainMerchant")
G.MerchantUtil = req("Library.Util.MerchantUtil")
G.PlayerPet = req("Library.Client.PlayerPet")
G.EnchantCmds = req("Library.Client.EnchantCmds")
G.UpgradeCmds = req("Library.Client.UpgradeCmds")
G.MachineCmds = req("Library.Client.MachineCmds")
G.BreakableFrontend = req("Library.Client.BreakableFrontend")

local function netInvoke(name, ...)
    if not isfn(G.Network, "Invoke") then return false, "Network.Invoke unavailable" end
    return gcall(G.Network.Invoke, name, ...)
end
local function netFire(name, ...)
    if not isfn(G.Network, "Fire") then return false, "Network.Fire unavailable" end
    return gcall(G.Network.Fire, name, ...)
end
local function netUnreliable(name, ...)
    if isfn(G.Network, "UnreliableFire") then return gcall(G.Network.UnreliableFire, name, ...) end
    return false
end
local function getSave()
    if not isfn(G.Save, "Get") then return nil end
    return gval(G.Save.Get)
end
local function acorns()
    if isfn(G.CurrencyCmds, "Get") then
        local v = gval(G.CurrencyCmds.Get, K.CURRENCY)
        if type(v) == "number" then return v end
    end
    local s = getSave()
    if s and type(s.Currency) == "table" and type(s.Currency[K.CURRENCY]) == "number" then return s.Currency[K.CURRENCY] end
    return 0
end
local function shorten(n)
    n = tonumber(n) or 0
    local a = math.abs(n)
    if a >= 1e12 then return string.format("%.2fT", n / 1e12) end
    if a >= 1e9 then return string.format("%.2fB", n / 1e9) end
    if a >= 1e6 then return string.format("%.2fM", n / 1e6) end
    if a >= 1e3 then return string.format("%.1fK", n / 1e3) end
    return tostring(math.floor(n))
end

local function hrp()
    local c = LocalPlayer.Character
    return c and c:FindFirstChild("HumanoidRootPart") or nil
end
local function playerPos()
    local r = hrp()
    return r and r.Position or nil
end
local function teleportTo(pos, lookAt)
    local c = LocalPlayer.Character
    local r = hrp()
    if not (c and r) then return false end
    local cf
    if lookAt then
        cf = CFrame.lookAt(pos, Vector3.new(lookAt.X, pos.Y, lookAt.Z))
    else
        cf = CFrame.new(pos) * (r.CFrame - r.CFrame.Position)
    end
    pcall(function()
        r.AssemblyLinearVelocity = Vector3.zero
        r.AssemblyAngularVelocity = Vector3.zero
    end)
    local ok = pcall(function() c:PivotTo(cf) end)
    return ok
end
local function dist(a, b)
    if not (a and b) then return math.huge end
    return (a - b).Magnitude
end

local function inInstance()
    if not isfn(G.Instancing, "GetInstanceID") then return false end
    return gval(G.Instancing.GetInstanceID) == K.INSTANCE_ID
end
local function dmModel()
    if isfn(G.Instancing, "GetModel") and inInstance() then
        local m = gval(G.Instancing.GetModel)
        if typeof(m) == "Instance" then return m end
    end
    local things = workspace:FindFirstChild("__THINGS")
    local cont = things and things:FindFirstChild("__INSTANCE_CONTAINER")
    local act = cont and cont:FindFirstChild("Active")
    return act and act:FindFirstChild(K.INSTANCE_ID) or nil
end

local function enterInstance()
    if inInstance() then return true end
    if not isfn(G.Instancing, "Enter") then return false, "InstancingCmds.Enter missing" end
    log("entering Diamond Mountain")
    if canSetIdentity then pcall(setthreadidentity, 2) end
    local ok, err = pcall(G.Instancing.Enter, K.INSTANCE_ID)
    if canSetIdentity then pcall(setthreadidentity, K.IDENTITY_EXEC) end
    if not ok then return false, tostring(err) end
    local t0 = os.clock()
    while state.alive and os.clock() - t0 < 25 do
        if inInstance() and dmModel() then return true end
        task.wait(0.5)
    end
    return inInstance(), "timed out waiting for the instance"
end

local function campUnlocked(n)
    if n <= 1 then return true end
    if isfn(G.InstanceZone, "IsUnlocked") then
        local v = gval(G.InstanceZone.IsUnlocked, n)
        if v ~= nil then return v == true end
    end
    local s = getSave()
    local iv = s and s.InstanceVars and s.InstanceVars[K.INSTANCE_ID]
    local iz = iv and iv.InstanceZones
    return type(iz) == "table" and iz["__Zone_" .. n] == true
end
local function bestCampNumber()
    if isfn(G.InstanceZone, "GetMaximumOwnedZoneNumber") then
        local n = gval(G.InstanceZone.GetMaximumOwnedZoneNumber)
        if type(n) == "number" and n >= 1 then return math.clamp(n, 1, #K.CAMPS) end
    end
    local best = 1
    for i = 2, #K.CAMPS do
        if campUnlocked(i) then best = i end
    end
    return best
end

local function holdExcursion(name, timeout)
    local t0 = os.clock()
    while state.alive and state.excursion ~= nil and state.excursion ~= name do
        if os.clock() - t0 > (timeout or 30) then return false end
        task.wait(0.2)
    end
    if not state.alive then return false end
    state.excursion = name
    return true
end
local function releaseExcursion(name)
    if state.excursion == name then state.excursion = nil end
end

local function keepAtCamp(camp)
    if not camp then return end
    local p = playerPos()
    if not p then return end
    if dist(p, camp.Pos) > K.CAMP_TOLERANCE and os.clock() - state.lastCampTeleport > 1.5 then
        state.lastCampTeleport = os.clock()
        teleportTo(camp.Pos)
    end
end

F.infiniteSpeed = false
F.superMagnet = false
F.noHatchAnim = true

local function installSpeedHook()
    if type(hookfunction) ~= "function" then
        logOnce("nohook", "hookfunction unavailable - Infinite Pet Speed disabled")
        return
    end
    if not isfn(G.PlayerPet, "CalculateSpeedMultiplier") then
        logOnce("nospeedfn", "PlayerPet.CalculateSpeedMultiplier missing - Infinite Pet Speed disabled")
        return
    end
    local orig
    local ok, err = pcall(function()
        orig = hookfunction(G.PlayerPet.CalculateSpeedMultiplier, function(...)
            if F.infiniteSpeed and state.alive then return math.huge end
            if type(orig) == "function" then return orig(...) end
            return 1
        end)
    end)
    if ok and type(orig) == "function" then
        log("pet speed hook installed")
    else
        warnlog("pet speed hook failed: %s", tostring(err))
    end
end

V.magnetBackup = setmetatable({}, { __mode = "k" })
local function applyMagnetConfig(r)
    if type(r) ~= "table" then return end
    if F.superMagnet and state.alive then
        if type(r.config) ~= "table" then r.config = {} end
        if V.magnetBackup[r.config] == nil then V.magnetBackup[r.config] = { orig = r.config.SuperMagnet } end
        r.config.SuperMagnet = true
    elseif type(r.config) == "table" and V.magnetBackup[r.config] then
        r.config.SuperMagnet = V.magnetBackup[r.config].orig
        V.magnetBackup[r.config] = nil
    end
end
local function installMagnet()
    local applied = 0
    local function patch(mod, name, fn)
        if type(mod) ~= "table" then return end
        pcall(function() if type(setreadonly) == "function" then setreadonly(mod, false) end end)
        local ok, err = pcall(fn, mod)
        if ok then applied += 1 else warnlog("super magnet patch %s failed: %s", name, tostring(err)) end
    end
    patch(G.EnchantCmds, "EnchantCmds", function(e)
        local o = e.GetPower
        if type(o) ~= "function" then error("no GetPower") end
        e.GetPower = function(...)
            local p = ...
            if F.superMagnet and state.alive and (p == "Super Magnet" or p == "Magnet") then return 999 end
            return o(...)
        end
        restoreFns[#restoreFns + 1] = function() e.GetPower = o end
    end)
    patch(G.UpgradeCmds, "UpgradeCmds", function(u)
        local o = u.GetPower
        if type(o) ~= "function" then error("no GetPower") end
        u.GetPower = function(...)
            if F.superMagnet and state.alive and (...) == "Magnet" then return 999 end
            return o(...)
        end
        restoreFns[#restoreFns + 1] = function() u.GetPower = o end
    end)
    patch(G.Instancing, "InstancingCmds", function(i)
        local g = i.Get
        if type(g) ~= "function" then error("no Get") end
        i.Get = function(...)
            local r = g(...)
            if type(r) == "table" then pcall(applyMagnetConfig, r) end
            return r
        end
        restoreFns[#restoreFns + 1] = function() i.Get = g end
    end)
    log("super magnet patches applied (%d/3)", applied)
end
local function refreshMagnetNow()

    if isfn(G.Instancing, "Get") then
        local r = gval(G.Instancing.Get)
        if type(r) == "table" then pcall(applyMagnetConfig, r) end
    end
end

V.animOrig = nil
V.animEnv = nil
local function installNoHatchAnimation()
    if type(getsenv) ~= "function" then
        logOnce("nogetsenv", "getsenv unavailable - hatch animation stays on")
        return
    end
    task.spawn(function()
        local ok, err = pcall(function()
            local ps = LocalPlayer:WaitForChild("PlayerScripts", 10)
            local scripts = ps and ps:WaitForChild("Scripts", 10)
            local gameFolder = scripts and scripts:WaitForChild("Game", 10)
            local eggScript = gameFolder and gameFolder:WaitForChild("Egg Opening Frontend", 10)
            if not eggScript then error("Egg Opening Frontend not found") end
            local env = getsenv(eggScript)
            if type(env) ~= "table" then error("getsenv returned " .. typeof(env)) end
            V.animEnv = env
            V.animOrig = env.PlayEggAnimation
            env.PlayEggAnimation = function(...)
                if F.noHatchAnim and state.alive then return end
                if type(V.animOrig) == "function" then return V.animOrig(...) end
            end
            restoreFns[#restoreFns + 1] = function()
                if V.animEnv and V.animOrig ~= nil then V.animEnv.PlayEggAnimation = V.animOrig end
            end
        end)
        if ok then log("hatch animation hook installed") else warnlog("could not hook hatch animation: %s", tostring(err)) end
    end)
end

F.antiAfk = true
local function installAntiAfk()
    pcall(function()
        if type(getconnections) == "function" then
            for _, c in ipairs(getconnections(LocalPlayer.Idled)) do
                if c.Disable then c:Disable() elseif c.Disconnect then c:Disconnect() end
            end
        end
    end)
    track(LocalPlayer.Idled:Connect(function()
        if not (F.antiAfk and state.alive) then return end
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
        end)
    end))
    log("anti-AFK installed")
end

F.autoBestEgg = false
F.autoNearestEgg = false
F.hatchDelay = 0.6
F.hatchAmountOverride = 0

local function allDMEggs()
    local out = {}
    if not isfn(G.CustomEggs, "All") then return out end
    local all = gval(G.CustomEggs.All)
    if type(all) ~= "table" then return out end
    for uid, e in pairs(all) do
        if type(e) == "table" and K.CAMP_BY_EGG[e._id] then
            local pos = e._position
            if typeof(pos) ~= "Vector3" and e._model and e._model.Parent then
                pcall(function() pos = e._model:GetPivot().Position end)
            end
            if typeof(pos) == "Vector3" then
                local camp = K.CAMP_BY_EGG[e._id]
                local trail
                pcall(function() trail = tonumber(e._model and e._model:GetAttribute("DM_TrailEgg")) end)
                out[#out + 1] = {
                    uid = e._uid or uid,
                    id = e._id,
                    dir = e._dir or (G.Eggs and G.Eggs[e._id]) or nil,
                    pos = pos,
                    hatchable = e._hatchable,
                    maxCount = e._maxEggCount,
                    camp = camp,
                    campDist = dist(pos, camp.Pos),
                    trail = trail,
                }
            end
        end
    end
    return out
end

local function campEgg(campNumber)
    local best
    for _, e in ipairs(allDMEggs()) do
        if e.camp.Number == campNumber and not e.trail and (not best or e.campDist < best.campDist) then best = e end
    end
    return best
end

F.nearestRange = 40
local function nearestEgg()
    local p = playerPos()
    if not p then return nil end
    local best, bestD
    for _, e in ipairs(allDMEggs()) do
        local d = dist(p, e.pos)
        if d <= F.nearestRange and e.hatchable ~= false and (not bestD or d < bestD) then best, bestD = e, d end
    end
    if not best then
        for _, e in ipairs(allDMEggs()) do
            local d = dist(p, e.pos)
            if d <= F.nearestRange and (not bestD or d < bestD) then best, bestD = e, d end
        end
    end
    return best, bestD
end

local function trailEgg(trailNumber)
    for _, e in ipairs(allDMEggs()) do
        if e.trail == trailNumber then return e end
    end
    return nil
end

local function maxHatch(egg)
    if F.hatchAmountOverride and F.hatchAmountOverride >= 1 then return math.floor(F.hatchAmountOverride) end
    if egg and type(egg.maxCount) == "number" and egg.maxCount >= 1 then return math.floor(egg.maxCount) end
    if isfn(G.EggCmds, "GetMaxHatch") then
        local n = gval(G.EggCmds.GetMaxHatch, egg and egg.dir or nil)
        if type(n) == "number" and n >= 1 then return math.floor(n) end
    end
    return 1
end
local function eggCost(egg)
    local d = egg and egg.dir
    if type(d) == "table" and type(d.overrideCost) == "number" then return d.overrideCost end
    return nil
end

V.hatchFails = 0
V.hatchLower, V.hatchLowerUntil = nil, 0
V.lastHatchAt = 0
local function hatchOnce(egg)
    if os.clock() - V.lastHatchAt < math.max(0.15, F.hatchDelay) then return false, "hatch cooldown" end
    V.lastHatchAt = os.clock()
    local amount = maxHatch(egg)
    local cost = eggCost(egg)
    if cost and cost > 0 then
        local affordable = math.floor(acorns() / cost)
        if affordable < 1 then
            state.status = string.format("hatch %s: need %s acorns", egg.id, shorten(cost))
            return false, "not enough acorns"
        end
        amount = math.max(1, math.min(amount, affordable))
    end
    V.lastHatchEgg, V.lastHatchReq = egg, os.clock()
    local ok, res, msg = netInvoke("CustomEggs_Hatch", egg.uid, amount)
    if ok and res == true then
        state.hatchRequests += amount
        V.hatchFails = 0
        state.status = string.format("hatching %s x%d", egg.id, amount)
        return true
    end
    local text = string.lower(tostring(msg or res or ""))
    local shortOnAcorns = text:find("afford", 1, true) or text:find("enough", 1, true) or text:find("acorn", 1, true) or text:find("coin", 1, true)
    if shortOnAcorns then
        local a = amount
        while state.alive and a > 1 do
            a = math.max(1, math.floor(a / 2))
            local ok2, res2 = netInvoke("CustomEggs_Hatch", egg.uid, a)
            if ok2 and res2 == true then
                state.hatchRequests += a
                V.hatchFails = 0
                state.status = string.format("hatching %s x%d (not enough acorns for x%d)", egg.id, a, amount)
                return true
            end
        end
    elseif text:find("quickly", 1, true) then
        state.status = string.format("hatch %s: server rate limit, retrying", egg.id)
        return false, "rate limit"
    end
    V.hatchFails += 1
    if V.hatchFails % 5 == 1 then
        warnlog("hatch %s failed: %s", tostring(egg.id), tostring(msg or res))
    end
    state.status = string.format("hatch %s failed: %s", egg.id, tostring(msg or res))
    return false, msg or res
end

F.autoFarm = true
V.breakAssign = {}

local function petEuids()
    if not isfn(G.PlayerPet, "GetAll") then return {} end
    local ok, out = gcall(function()
        local res, unfiltered = {}, {}
        local all = G.PlayerPet.GetAll()
        if type(all) ~= "table" then return res end
        local belongs = type(G.PlayerPet.BelongsToLocalPlayer) == "function" and G.PlayerPet.BelongsToLocalPlayer or nil
        for _, p in pairs(all) do
            if type(p) == "table" and p.euid ~= nil then
                unfiltered[#unfiltered + 1] = p.euid
                local keep = true
                if belongs then
                    local okB, r = pcall(belongs, p)
                    if okB and r == false then keep = false end
                end
                if keep then res[#res + 1] = p.euid end
            end
        end
        if #res == 0 then return unfiltered end
        return res
    end)
    if ok and type(out) == "table" then return out end
    return {}
end

local function campBreakables(campNumber)
    local list = {}
    local things = workspace:FindFirstChild("__THINGS")
    local folder = things and things:FindFirstChild("Breakables")
    if not folder then return list end
    local area = "Main_" .. tostring(campNumber)
    for _, m in ipairs(folder:GetChildren()) do
        if m:IsA("Model") and m:GetAttribute("ParentID") == K.INSTANCE_ID and m:GetAttribute("AreaID") == area then
            local uid = m:GetAttribute("BreakableUID")
            if uid ~= nil then list[#list + 1] = uid end
        end
    end
    return list
end

local function dmBreakableModels()
    local list = {}
    local things = workspace:FindFirstChild("__THINGS")
    local folder = things and things:FindFirstChild("Breakables")
    if not folder then return list end
    for _, m in ipairs(folder:GetChildren()) do
        if m:IsA("Model") and m:GetAttribute("ParentID") == K.INSTANCE_ID and m:GetAttribute("BreakableUID") ~= nil then
            list[#list + 1] = m
        end
    end
    return list
end

local function breakablesNear(center, radius, skipMain)
    local list = {}
    for _, m in ipairs(dmBreakableModels()) do
        local area = tostring(m:GetAttribute("AreaID") or "")
        if not (skipMain and area:sub(1, 5) == "Main_") then
            local ok, pos = pcall(function() return m:GetPivot().Position end)
            if ok and dist(pos, center) <= radius then list[#list + 1] = m:GetAttribute("BreakableUID") end
        end
    end
    return list
end

F.autoTap = false
F.tapInterval = 0.05
V.tapTarget = nil
V.tapTargetAt = 0
local function nearestBreakableUid()
    local p = playerPos()
    if not p then return nil end
    if V.yetiTarget then return V.yetiTarget end
    if F.fastFarm and V.tapPreferred and os.clock() - V.tapPreferredAt < 1 then return V.tapPreferred end
    if os.clock() - V.tapTargetAt < 0.5 then return V.tapTarget end
    V.tapTargetAt = os.clock()
    local best, bestD
    for _, m in ipairs(dmBreakableModels()) do
        local ok, pos = pcall(function() return m:GetPivot().Position end)
        if ok then
            local d = dist(pos, p)
            if d <= 80 and (not bestD or d < bestD) then best, bestD = m:GetAttribute("BreakableUID"), d end
        end
    end
    V.tapTarget = best
    return best
end
local function tapTick()
    local uid = nearestBreakableUid()
    if uid == nil then return end
    netUnreliable("Breakables_PlayerDealDamage", uid)
    state.taps += 1
end

local function farmTick(campNumber, overrideTargets)
    local targets = overrideTargets or campBreakables(campNumber)
    if #targets == 0 then return end
    local pets = petEuids()
    if #pets == 0 then return end
    local live, used, petSet = {}, {}, {}
    for _, u in ipairs(targets) do live[u] = true end
    for _, e in ipairs(pets) do petSet[e] = true end
    for e, u in pairs(V.breakAssign) do
        if live[u] and petSet[e] then used[u] = true else V.breakAssign[e] = nil end
    end
    local free = {}
    for _, u in ipairs(targets) do if not used[u] then free[#free + 1] = u end end
    local rr, map = 0, {}
    for _, e in ipairs(pets) do
        if V.breakAssign[e] == nil then
            if #free > 0 then
                V.breakAssign[e] = table.remove(free, 1)
            else
                rr += 1
                V.breakAssign[e] = targets[(rr - 1) % #targets + 1]
            end
        end
        map[e] = V.breakAssign[e]
    end
    if next(map) == nil then return end
    netUnreliable("Breakables_PlayerDealDamage", targets[1])
    local ok, err = netFire("Breakables_JoinPetBulk", map)
    if ok then state.farmTicks += 1 else logOnce("farm-fire", "Breakables_JoinPetBulk failed: %s", tostring(err)) end
end

F.fastFarm = false
V.fastAssign = {}
V.tapPreferred = nil
V.tapPreferredAt = 0

local function breakableInfo(uid)
    if not isfn(G.BreakableFrontend, "Get") then return nil end
    local b = gval(G.BreakableFrontend.Get, uid)
    if type(b) ~= "table" then return nil end
    return {
        uid = uid,
        health = type(b.health) == "number" and b.health or (type(b.maxHealth) == "number" and b.maxHealth or math.huge),
        maxHealth = type(b.maxHealth) == "number" and b.maxHealth or 0,
        class = tostring(b.class or "Normal"),
        pos = typeof(b.position) == "Vector3" and b.position or nil,
    }
end

local function fastFarmTick(targetUids)
    if #targetUids == 0 then return end
    local pets = petEuids()
    if #pets == 0 then return end
    local infos, chests = {}, {}
    for _, uid in ipairs(targetUids) do
        local info = breakableInfo(uid)
        if info and info.health > 0 then
            if info.class ~= "Normal" then chests[#chests + 1] = info end
            infos[#infos + 1] = info
        end
    end
    if #infos == 0 then return end
    local ordered = (#chests > 0) and chests or infos
    table.sort(ordered, function(a, b)
        if a.health ~= b.health then return a.health < b.health end
        return tostring(a.uid) < tostring(b.uid)
    end)
    local map, changed = {}, false
    for i, e in ipairs(pets) do
        local target = ordered[((i - 1) % #ordered) + 1].uid
        map[e] = target
        if V.fastAssign[e] ~= target then changed = true end
    end
    V.fastAssign = map
    local p = playerPos()
    if p then
        local best, bestH
        for _, info in ipairs(ordered) do
            if info.pos and dist(info.pos, p) <= 30 and (not bestH or info.health < bestH) then best, bestH = info.uid, info.health end
        end
        V.tapPreferred, V.tapPreferredAt = best, os.clock()
    end
    netUnreliable("Breakables_PlayerDealDamage", ordered[1].uid)
    if changed or os.clock() - (V.fastLastSend or 0) > 1 then
        V.fastLastSend = os.clock()
        local ok, err = netFire("Breakables_JoinPetBulk", map)
        if ok then state.farmTicks += 1 else logOnce("fastfarm-fire", "Breakables_JoinPetBulk failed: %s", tostring(err)) end
    end
end

local function installBreakableWatcher()
    local things = workspace:FindFirstChild("__THINGS")
    local folder = things and things:FindFirstChild("Breakables")
    if not folder then return end
    track(folder.ChildRemoved:Connect(function()
        V.fastDirty = true
    end))
end

F.autoUpgrades = false
F.objective = K.OBJECTIVES[1]
F.upgradeEnabled = { WallPower = true, OfflineHours = true, CoinFinder = true, TrailLuck = true, ExpeditionSpeed = true }

local function upgradeDir(id)
    return type(G.EventUpgrades) == "table" and G.EventUpgrades[id] or nil
end
local function upgradeTier(id)
    if isfn(G.EventUpgradeCmds, "GetTier") then
        local t = gval(G.EventUpgradeCmds.GetTier, id)
        if type(t) == "number" then return t end
    end
    local s = getSave()
    return s and type(s.EventUpgrades) == "table" and (s.EventUpgrades[id] or 0) or 0
end
local function upgradeInfo(u)
    local d = upgradeDir(u.Id)
    local tier = upgradeTier(u.Id)
    local maxTier = d and type(d.TierPowers) == "table" and #d.TierPowers or 5
    local cost
    if d and type(d.TierCosts) == "table" and d.TierCosts[tier + 1] then
        local okC, amt = gcall(function() return d.TierCosts[tier + 1]:GetAmount() end)
        if okC and type(amt) == "number" then cost = amt end
    end
    local power = d and type(d.TierPowers) == "table" and d.TierPowers[tier] or nil
    return { tier = tier, max = maxTier, cost = cost, power = power, disabled = d and d.Disabled == true, dir = d }
end

local function upgradeMachinePart()
    local m = dmModel()
    local inter = m and m:FindFirstChild("INTERACT")
    local machines = inter and inter:FindFirstChild("Machines")
    local mach = machines and machines:FindFirstChild(K.UPGRADE_MACHINE)
    return mach
end
local function machineStandPos()
    local mach = upgradeMachinePart()
    if not mach then return nil end
    local pivot = mach:GetPivot().Position
    local spawn = K.CAMPS[1].Pos
    local dir = (Vector3.new(spawn.X, pivot.Y, spawn.Z) - pivot)
    dir = dir.Magnitude > 0.1 and dir.Unit or Vector3.new(0, 0, 1)
    return pivot + dir * 7 + Vector3.new(0, 3, 0), pivot
end
local function nearMachine()
    if isfn(G.MachineCmds, "CanUse") then
        local v = gval(G.MachineCmds.CanUse, K.UPGRADE_MACHINE)
        if v == true then return true end
    end
    local stand, pivot = machineStandPos()
    local p = playerPos()
    return pivot ~= nil and p ~= nil and dist(p, pivot) <= K.MACHINE_REACH + 4
end

local function pickUpgrade()
    local coins = acorns()
    local candidates = {}
    for _, u in ipairs(K.UPGRADES) do
        if not u.Retired and F.upgradeEnabled[u.Key] then
            local info = upgradeInfo(u)
            if info.dir and not info.disabled and info.tier < info.max and info.cost and info.cost <= coins then
                candidates[#candidates + 1] = { u = u, info = info }
            end
        end
    end
    if #candidates == 0 then return nil end
    local order = K.OBJECTIVE_ORDER[F.objective]
    if order then
        local rank = {}
        for i, key in ipairs(order) do rank[key] = i end
        table.sort(candidates, function(a, b)
            local ra, rb = rank[a.u.Key] or 99, rank[b.u.Key] or 99
            if ra ~= rb then return ra < rb end
            return a.info.cost < b.info.cost
        end)
    else
        table.sort(candidates, function(a, b) return a.info.cost < b.info.cost end)
    end
    return candidates[1]
end

local function buyUpgrade(cand)
    local ok, res, msg = netInvoke("EventUpgrades: Purchase", cand.u.Id)
    if ok and res == true then
        state.upgradesBought += 1
        log("bought %s tier %d for %s acorns", cand.u.Name, cand.info.tier + 1, shorten(cand.info.cost))
        notify("Upgrade bought", string.format("%s -> tier %d", cand.u.Name, cand.info.tier + 1), 4)
        return true
    end
    warnlog("upgrade %s failed: %s", cand.u.Name, tostring(msg or res))
    return false, msg or res
end

local function upgradeRun()
    local cand = pickUpgrade()
    if not cand then return end
    if not holdExcursion("upgrades", 20) then return end
    local before = playerPos()
    local okAll = pcall(function()
        local stand = machineStandPos()
        if not stand then logOnce("nomachine", "upgrade machine not found in the instance") return end
        if not nearMachine() then
            teleportTo(stand)
            local t0 = os.clock()
            repeat task.wait(0.2) until nearMachine() or os.clock() - t0 > 3 or not state.alive
        end
        local bought = 0
        while state.alive and F.autoUpgrades and cand and bought < 12 do
            state.status = "buying upgrade " .. cand.u.Name
            local ok = buyUpgrade(cand)
            if not ok then break end
            bought += 1
            task.wait(0.6)
            cand = pickUpgrade()
        end
    end)
    if before and state.alive then teleportTo(before) end
    releaseExcursion("upgrades")
end

F.autoBoosts = false
F.boostEnabled = { Coins = true, Luck = true, Damage = true }
F.boostPreferTier2 = true
F.boostMinLeft = 90

local function boostTimer(ids)
    local best = 0
    for _, id in ipairs(ids) do
        if isfn(G.BoostCmds, "GetTimer") then
            local t = gval(G.BoostCmds.GetTimer, id)
            if type(t) == "number" and t > best then best = t end
        end
    end
    return best
end
local function boostItems(itemId)
    local s = getSave()
    local inv = s and s.Inventory and s.Inventory.Consumable
    local out = {}
    if type(inv) ~= "table" then return out end
    for uid, it in pairs(inv) do
        if type(it) == "table" and it.id == itemId and (it._am == nil or it._am > 0) then
            out[#out + 1] = { uid = uid, tier = tonumber(it.tn) or 1, amount = it._am or 1 }
        end
    end
    table.sort(out, function(a, b)
        if a.tier ~= b.tier then
            if F.boostPreferTier2 then return a.tier > b.tier end
            return a.tier < b.tier
        end
        return a.amount > b.amount
    end)
    return out
end
V.boostLastUse = {}
local function boostTick()
    if not inInstance() then return end
    for _, b in ipairs(K.BOOSTS) do
        if F.boostEnabled[b.Key] and (os.clock() - (V.boostLastUse[b.Key] or 0)) > 20 then
            local left = boostTimer(b.Ids)
            if left < F.boostMinLeft then
                local items = boostItems(b.Item)
                if #items > 0 then
                    local it = items[1]
                    local ok, res, msg = netInvoke("Consumables_Consume", it.uid, 1)
                    V.boostLastUse[b.Key] = os.clock()
                    if ok and res then
                        state.boostsUsed += 1
                        log("used %s (tier %d)", b.Item, it.tier)
                        notify("Boost used", string.format("%s %s", b.Label, it.tier == 2 and "II" or ""), 4)
                    else
                        warnlog("boost %s failed: %s", b.Item, tostring(msg or res))
                    end
                end
            end
        end
    end
end

F.autoMerchant = false
F.merchantOnlyBoosts = true
V.merchantVisitDone = nil
V.merchantRetryAt = 0

local function merchantPhase()
    if not isfn(G.DMMerchant, "Phase") then return nil end
    local ph = gval(G.DMMerchant.Phase)
    return type(ph) == "table" and ph or nil
end
local function merchantStop(camp)
    if isfn(G.DMMerchant, "Stop") then
        local part = gval(G.DMMerchant.Stop, camp)
        if typeof(part) == "Instance" then return part end
    end
    local m = dmModel()
    local camps = m and m:FindFirstChild("Camps")
    local c = camps and camps:FindFirstChild(tostring(camp))
    local part = c and c:FindFirstChild("Merchant")
    return part
end

local function offersTableValid(t)
    if type(t) ~= "table" then return false end
    local mine = rawget(t, K.MERCHANT)
    return type(mine) == "table" and type(rawget(mine, "Offers")) == "table"
end
local function scanCachedOffers()
    if type(getgc) ~= "function" then return nil end
    local okGc, objects = pcall(getgc, true)
    if not okGc or type(objects) ~= "table" then return nil end
    for _, obj in ipairs(objects) do
        if type(obj) == "table" then
            local ok, valid = pcall(offersTableValid, obj)
            if ok and valid then return obj end
        end
    end
    return nil
end
local function installHatchListener()
    if not isfn(G.Network, "Fired") then return end
    local ok, signal = gcall(G.Network.Fired, "Eggs_PlayOpenAnimation")
    if ok and signal and type(signal.Connect) == "function" then
        track(signal:Connect(function(eggId, payload)
            local n = 0
            if type(payload) == "table" then
                if type(payload.uids) == "table" then
                    n = #payload.uids
                else
                    for _ in pairs(payload) do n += 1 end
                end
            end
            if n <= 0 then return end
            state.hatched += n
            local last = V.lastHatchEgg
            if last and last.trail and last.id == eggId and os.clock() - (V.lastHatchReq or 0) < 6 then
                state.trailHatched += n
            end
        end))
    end
end

local function installMerchantListener()
    if not isfn(G.Network, "Fired") then return end
    local ok, signal = gcall(G.Network.Fired, "Merchant_Updated")
    if ok and signal and type(signal.Connect) == "function" then
        track(signal:Connect(function(data)
            if type(data) == "table" then V.merchantOffers = data end
        end))
    end
end
local function merchantOffers()
    local ok, offers = netInvoke("Merchant_GetOffers")
    if ok and type(offers) == "table" then V.merchantOffers = offers end
    if not offersTableValid(V.merchantOffers) then
        local cached = scanCachedOffers()
        if cached then V.merchantOffers = cached end
    end
    if offersTableValid(V.merchantOffers) then return V.merchantOffers[K.MERCHANT] end
    return nil
end
local function respectLevel()
    local s = getSave()
    local xp = s and type(s.MerchantExperience) == "table" and s.MerchantExperience[K.MERCHANT] or 0
    if isfn(G.MerchantUtil, "RespectLevelFromExperience") then
        local lvl = gval(G.MerchantUtil.RespectLevelFromExperience, xp or 0)
        if type(lvl) == "number" then return lvl end
    end
    return 0
end
local function offerIsBoost(o)
    local item = type(o) == "table" and o.ItemData or nil
    local data = type(item) == "table" and item.data or nil
    local id = type(data) == "table" and tostring(data.id or data._id or "") or ""
    return id:find("Boost", 1, true) ~= nil
end
local function offerName(o)
    local item = type(o) == "table" and o.ItemData or nil
    local data = type(item) == "table" and item.data or nil
    return type(data) == "table" and tostring(data.id or data._id or "?") or "?"
end

local function merchantRun()
    local ph = merchantPhase()
    if not (ph and ph.Arrived) then return end
    if V.merchantVisitDone == ph.Visit and os.clock() < V.merchantRetryAt then return end
    local stop = merchantStop(ph.Camp)
    if not stop then logOnce("nomerchantstop", "merchant stop part for camp %s not found", tostring(ph.Camp)) return end
    local t0 = os.clock()
    while state.alive and state.excursion ~= nil and state.excursion ~= "merchant" and state.excursion ~= "trail" and state.excursion ~= "yeti" do
        if os.clock() - t0 > 20 then return end
        task.wait(0.2)
    end
    if not state.alive then return end
    local interrupted = state.excursion
    state.excursion = "merchant"
    if interrupted then log("merchant arrived: pausing %s to buy boosts", interrupted) end
    task.wait(0.4)
    local before = playerPos()
    pcall(function()
        local campPos = K.CAMPS[ph.Camp] and K.CAMPS[ph.Camp].Pos or stop.Position
        local toward = (Vector3.new(campPos.X, stop.Position.Y, campPos.Z) - stop.Position)
        toward = toward.Magnitude > 0.1 and toward.Unit or Vector3.new(0, 0, 1)
        local standPos = stop.Position + toward * 8 + Vector3.new(0, 3, 0)
        state.status = string.format("visiting merchant at camp %d", ph.Camp)
        teleportTo(standPos, stop.Position)
        task.wait(0.8)
        local data = merchantOffers()
        if not (data and type(data.Offers) == "table") then
            V.merchantRetryAt = os.clock() + 30
            logOnce("nooffers-" .. tostring(ph.Visit), "merchant offers not available yet (visit %s)", tostring(ph.Visit))
            return
        end
        local lvl = respectLevel()
        local idx = {}
        for k in pairs(data.Offers) do idx[#idx + 1] = tonumber(k) or k end
        table.sort(idx, function(a, b) return tostring(a) < tostring(b) end)
        local bought, skipped = 0, 0
        for _, i in ipairs(idx) do
            local o = data.Offers[tostring(i)] or data.Offers[i]
            if type(o) == "table" and (o.Stock or 0) > 0 and (o.Respect or 0) <= lvl and (not F.merchantOnlyBoosts or offerIsBoost(o)) then
                local ok, res, msg = netInvoke("Merchant_RequestPurchase", K.MERCHANT, tonumber(i) or i)
                if ok and res == true then
                    bought += 1
                    state.merchantBought += 1
                    log("merchant: bought %s", offerName(o))
                else
                    skipped += 1
                    log("merchant: %s not bought (%s)", offerName(o), tostring(msg or res))
                end
                task.wait(0.5)
            end
        end
        V.merchantVisitDone = ph.Visit
        V.merchantRetryAt = os.clock() + 120
        if bought > 0 then notify("Traveling Merchant", string.format("bought %d offer(s) at camp %d", bought, ph.Camp), 5) end
        state.status = string.format("merchant visit done (%d bought, %d skipped)", bought, skipped)
    end)
    if before and state.alive then teleportTo(before) end
    releaseExcursion("merchant")
end

F.autoArtifacts = false
V.artifactsFound = {}
V.artifactsAllFound = false

local function expeditionFeature()
    if not isfn(G.DMCmds, "Feature") then return nil end
    local f = gval(G.DMCmds.Feature, "Expedition")
    return type(f) == "table" and f or nil
end
local function readArtifactState()
    local found = {}
    local E = expeditionFeature()
    if E and type(E.State) == "function" then
        local st = gval(E.State)
        if type(st) == "table" and type(st.finds) == "table" then
            for _, f in ipairs(st.finds) do
                local d = tonumber(f.door)
                if d then found[d] = true end
            end
            V.artifactsFound = found
            return found, true
        end
    end
    if E and type(E.Found) == "table" then
        for d, v in pairs(E.Found) do if v then found[tonumber(d) or 0] = true end end
        V.artifactsFound = found
        return found, true
    end
    return V.artifactsFound, false
end
local function artifactModel(i)
    local m = dmModel()
    local folder = m and m:FindFirstChild("Artifacts")
    return folder and folder:FindFirstChild(tostring(i)) or nil
end
local function artifactPos(i)
    local a = artifactModel(i)
    if not a then return nil end
    local ok, pos = pcall(function() return a:GetPivot().Position end)
    if ok then return pos end
    return nil
end

local function artifactRun()
    local found, fresh = readArtifactState()
    local total, missing = 6, {}
    for i = 1, total do
        if not found[i] and campUnlocked(i) then missing[#missing + 1] = i end
    end
    local count = 0
    for i = 1, total do if found[i] then count += 1 end end
    state.artifactsFound = count
    if #missing == 0 then
        if not V.artifactsAllFound then
            V.artifactsAllFound = true
            log("all reachable artifacts found (%d/%d)", count, total)
            notify("Artifacts", string.format("%d/%d artifacts found", count, total), 5)
        end
        return
    end
    V.artifactsAllFound = false
    if not holdExcursion("artifacts", 20) then return end
    local before = playerPos()
    pcall(function()
        for _, i in ipairs(missing) do
            if not (state.alive and F.autoArtifacts) then break end
            local pos = artifactPos(i)
            if pos then
                state.status = string.format("searching artifact #%d", i)

                for _, off in ipairs({ Vector3.new(0, 2, 0), Vector3.new(3, 2, 0), Vector3.new(-3, 2, 3), Vector3.new(0, 1, -3) }) do
                    if not state.alive then break end
                    teleportTo(pos + off)
                    task.wait(0.9)
                    local f2 = readArtifactState()
                    if f2[i] then
                        log("artifact #%d found", i)
                        break
                    end
                end
            end
        end
    end)
    if before and state.alive then teleportTo(before) end
    releaseExcursion("artifacts")
end

F.autoCamp = false
F.autoBestCamp = false
F.selectedCamp = K.CAMP_NAMES[1]

local function desiredCamp()
    if F.autoBestEgg then return K.CAMPS[bestCampNumber()] end
    if F.autoBestCamp then return K.CAMPS[bestCampNumber()] end
    if F.autoCamp then return K.CAMP_BY_NAME[F.selectedCamp] or K.CAMPS[1] end
    return nil
end

local function dmAttrFolder()
    local things = workspace:FindFirstChild("__THINGS")
    local inst = things and things:FindFirstChild("Instances")
    local f = inst and inst:FindFirstChild(K.INSTANCE_ID)
    return f or dmModel()
end
local function serverNow()
    return workspace:GetServerTimeNow()
end

F.autoYeti = false
F.autoYetiSend = false
V.yetiTarget = nil
V.yetiLastLoad = 0
V.yetiLastAssign = 0
V.yetiLastTeleport = 0

local function yetiInfo()
    local f = dmAttrFolder()
    if not f then return nil end
    local info = {
        uid = f:GetAttribute("DM_YetiUid"),
        at = f:GetAttribute("DM_YetiAt"),
        health = f:GetAttribute("DM_YetiHealth"),
        maxHealth = f:GetAttribute("DM_YetiMaxHealth"),
        backAt = f:GetAttribute("DM_YetiBackAt"),
        floor = f:GetAttribute("DM_YetiFloor"),
        stage = f:GetAttribute("DM_YetiStage"),
    }
    if type(info.uid) ~= "string" and type(info.uid) ~= "number" then info.uid = nil end
    if typeof(info.at) ~= "Vector3" then
        local m = dmModel()
        local summit = m and m:FindFirstChild("Summit")
        local arena = summit and summit:FindFirstChild("YetiArena")
        if arena and arena:IsA("PVInstance") then info.at = arena:GetPivot().Position end
    end
    local ready = LocalPlayer:GetAttribute("DM_YetiReadyAt")
    info.cooldown = type(ready) == "number" and math.max(0, ready - serverNow()) or 0
    info.alive = info.uid ~= nil and type(info.health) == "number" and info.health > 0
    return info
end

local function yetiStandPos(info)
    local at = info.at
    if typeof(at) ~= "Vector3" then return nil end
    local y = type(info.floor) == "number" and info.floor + 3 or at.Y
    local p = playerPos()
    local dir = p and Vector3.new(p.X - at.X, 0, p.Z - at.Z) or Vector3.new(0, 0, 1)
    dir = dir.Magnitude > 0.5 and dir.Unit or Vector3.new(0, 0, 1)
    return Vector3.new(at.X, y, at.Z) + dir * 14
end

local function yetiSendPets(info)
    if not isfn(G.DMCmds, "Feature") then return end
    local Y = gval(G.DMCmds.Feature, "Yeti")
    local D = gval(G.DMCmds.Feature, "Deposit")
    if type(Y) ~= "table" or type(D) ~= "table" then return end
    local ok, reason, capacity = gval(Y.CanLoad)
    if ok ~= true or type(capacity) ~= "number" or capacity <= 0 then return end
    local okS, spare = gcall(D.Spare, {})
    if not okS or type(spare) ~= "table" or #spare == 0 then return end
    local Dmg = req("Library.Modules.InstanceDamageModules.DiamondMountain")
    local scored = {}
    for _, item in ipairs(spare) do
        local uid, amount, power = nil, 0, 0
        pcall(function() uid = item:GetUID() amount = item:GetAmount() end)
        if Dmg and type(Dmg.Compute) == "function" then
            local okC, v = gcall(Dmg.Compute, LocalPlayer, item, 0)
            if okC and type(v) == "number" then power = v end
        end
        if uid and amount > 0 then scored[#scored + 1] = { uid = uid, amount = amount, power = power } end
    end
    table.sort(scored, function(a, b) return a.power > b.power end)
    local stacks, left, n = {}, capacity, 0
    for _, s in ipairs(scored) do
        if left <= 0 or n >= 100 then break end
        local take = math.min(s.amount, left)
        if take > 0 then
            stacks[s.uid] = take
            left -= take
            n += 1
        end
    end
    if n == 0 then return end
    local okL, res, msg = gcall(Y.LoadStacks, stacks)
    if okL and res == true then
        state.yetiPetsSent += (capacity - left)
        log("sent %d pets to the Yeti", capacity - left)
    else
        logOnce("yeti-load-" .. tostring(msg), "Yeti pet load refused: %s", tostring(msg or res))
    end
end

local function yetiTick()
    local info = yetiInfo()
    if not info then return end
    state.yeti = info
    if not info.alive or info.cooldown > 0 then
        if state.excursion == "yeti" then releaseExcursion("yeti") end
        V.yetiTarget = nil
        if not info.alive then
            state.status = type(info.backAt) == "number" and string.format("Yeti returns in %ds", math.max(0, math.floor(info.backAt - serverNow()))) or "Yeti not here"
        else
            state.status = string.format("Yeti cooldown %ds", math.floor(info.cooldown))
        end
        return
    end
    if state.excursion ~= nil and state.excursion ~= "yeti" then return end
    state.excursion = "yeti"
    local stand = yetiStandPos(info)
    local p = playerPos()
    if stand and p and dist(p, info.at) > 22 and os.clock() - V.yetiLastTeleport > 1.5 then
        V.yetiLastTeleport = os.clock()
        teleportTo(stand, info.at)
    end
    V.yetiTarget = info.uid
    if os.clock() - V.yetiLastAssign > 0.5 then
        V.yetiLastAssign = os.clock()
        local pets = petEuids()
        if #pets > 0 then
            local map = {}
            for _, e in ipairs(pets) do map[e] = info.uid end
            netFire("Breakables_JoinPetBulk", map)
        end
        netUnreliable("Breakables_PlayerDealDamage", info.uid)
    end
    if F.autoYetiSend and os.clock() - V.yetiLastLoad > 30 then
        V.yetiLastLoad = os.clock()
        pcall(yetiSendPets, info)
    end
    state.status = string.format("fighting the Yeti (%s%%)", type(info.health) == "number" and type(info.maxHealth) == "number" and info.maxHealth > 0 and tostring(math.floor(info.health / info.maxHealth * 100)) or "?")
end

F.autoTrail = false
F.trailHatch = true
F.trailChoice = "Auto (first open trail)"
K.TRAIL_CHOICES = { "Auto (first open trail)", "Trail 1", "Trail 2", "Trail 3", "Trail 4", "Trail 5", "Trail 6" }

local function trailModel(i)
    local m = dmModel()
    local trails = m and m:FindFirstChild("Trails")
    return trails and trails:FindFirstChild(tostring(i)) or nil
end
local function trailState(i)
    local f = dmAttrFolder()
    local now = serverNow()
    local st = { number = i }
    if f then
        local sleep = tonumber(f:GetAttribute("DM_Trail" .. i .. "SleepUntil"))
        local eggUntil = tonumber(f:GetAttribute("DM_Trail" .. i .. "EggUntil"))
        st.sleepLeft = sleep and sleep > now and (sleep - now) or nil
        st.eggLeft = eggUntil and eggUntil > now and (eggUntil - now) or nil
        st.chest = tonumber(f:GetAttribute("DM_Trail" .. i .. "Chest")) or 1
    end
    local ready = tonumber(LocalPlayer:GetAttribute("DM_TrailReady" .. i))
    st.rollIn = ready and math.max(0, ready - os.time()) or 0
    local T = isfn(G.DMCmds, "Feature") and gval(G.DMCmds.Feature, "Trails") or nil
    if type(T) == "table" and type(T.Closed) == "function" then
        local c = gval(T.Closed, i)
        st.closed = c == true
    else
        st.closed = st.sleepLeft ~= nil
    end
    if st.sleepLeft then st.closed = true end
    st.open = not st.closed
    return st
end
local function trailPoints(i)
    local m = trailModel(i)
    if not m then return nil end
    local gate = m:FindFirstChild("Gate")
    local clearing = m:FindFirstChild("Clearing")
    local pedestal = clearing and clearing:FindFirstChild("EggPedestal")
    local pts = {}
    if gate and gate:IsA("BasePart") then pts.gate = gate.Position pts.past = gate.Position + gate.CFrame.LookVector * 25 end
    if pedestal and pedestal:IsA("BasePart") then pts.pedestal = pedestal.Position end
    if clearing and clearing:IsA("PVInstance") then pts.clearing = clearing:GetPivot().Position end
    pts.center = pts.pedestal or pts.clearing or pts.past
    return pts
end
local function pickTrail()
    local n = tonumber(tostring(F.trailChoice):match("%d+"))
    if n then return trailState(n) end
    for i = 1, 6 do
        local st = trailState(i)
        if st.open and trailModel(i) then return st end
    end
    return nil
end

V.trailFarmTargets = nil
V.trailLastTeleport = 0
F.trailRejoin = false
F.trailHop = false
K.RESUME_FILE = "VYHUB/DM_Resume.json"
K.SCRIPT_URL = "https://raw.githubusercontent.com/92tg/VYHUB/main/VY_DiamondMountain.lua"
V.trailClosedSince = nil
V.teleporting = false

local function saveResume()
    if type(writefile) ~= "function" then return end
    pcall(function()
        if type(makefolder) == "function" and type(isfolder) == "function" and not isfolder("VYHUB") then makefolder("VYHUB") end
        writefile(K.RESUME_FILE, game:GetService("HttpService"):JSONEncode({
            at = os.time(),
            originPlace = game.PlaceId,
            world = K.WORLD_PLACES and K.WORLD_PLACES[game.PlaceId] or nil,
            autoTrail = F.autoTrail,
            trailChoice = F.trailChoice,
            trailHatch = F.trailHatch,
            trailRejoin = F.trailRejoin,
            trailHop = F.trailHop,
            autoFarm = F.autoFarm,
            fastFarm = F.fastFarm,
            autoTap = F.autoTap,
        }))
    end)
end

local function queueReexec()
    if type(queue_on_teleport) ~= "function" then return end
    local src = table.concat({
        "task.wait(3)",
        "repeat task.wait(1) until game:IsLoaded()",
        "local ok, err = pcall(function()",
        "    local s",
        "    if type(isfile) == 'function' and isfile('VY_DiamondMountain.luau') then s = readfile('VY_DiamondMountain.luau') end",
        "    if not s then s = game:HttpGet('" .. K.SCRIPT_URL .. "') end",
        "    loadstring(s, '=VY_DiamondMountain')()",
        "end)",
        "if not ok then warn('[VY DiamondMountain] re-exec failed: ' .. tostring(err)) end",
    }, "\n")
    pcall(queue_on_teleport, src)
end

local function pickOtherServer(placeId)
    placeId = placeId or game.PlaceId
    local body
    for _, order in ipairs({ "Desc", "Asc" }) do
        local ok, b = pcall(game.HttpGet, game, string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=%s&excludeFullGames=true&limit=100", placeId, order))
        if ok and type(b) == "string" and #b > 10 then body = b break end
        task.wait(1)
    end
    if not body then return nil end
    local okJ, data = pcall(function() return game:GetService("HttpService"):JSONDecode(body) end)
    if not okJ or type(data) ~= "table" or type(data.data) ~= "table" then return nil end
    local choices = {}
    for _, s in ipairs(data.data) do
        if type(s) == "table" and s.id ~= game.JobId and type(s.playing) == "number" and type(s.maxPlayers) == "number" and s.playing < s.maxPlayers and s.playing >= 1 then
            choices[#choices + 1] = s.id
        end
    end
    if #choices == 0 then return nil end
    return choices[math.random(1, #choices)]
end

K.ROOT_PLACE = 8737899170
K.WORLD_PLACES = { [8737899170] = 1, [16498369169] = 2, [17503543197] = 3, [140403681187145] = 4 }

local function rootPlaceId()
    if K.WORLD_PLACES[game.PlaceId] then return K.ROOT_PLACE end
    local ok, body = pcall(game.HttpGet, game, "https://games.roblox.com/v1/games?universeIds=" .. tostring(game.GameId))
    if ok and type(body) == "string" then
        local id = tonumber(body:match('"rootPlaceId":(%d+)'))
        if id then return id end
    end
    return K.ROOT_PLACE
end

local function inPrivateServer()
    local ok, v = pcall(function() return game.PrivateServerId ~= "" and game.PrivateServerOwnerId ~= 0 end)
    return ok and v == true
end

local function privateServerAccessCode()
    local ok, body = pcall(game.HttpGet, game, string.format("https://games.roblox.com/v1/games/%d/private-servers?limit=100", game.GameId))
    if not ok or type(body) ~= "string" then return nil end
    local okJ, data = pcall(function() return game:GetService("HttpService"):JSONDecode(body) end)
    if not okJ or type(data) ~= "table" or type(data.data) ~= "table" then return nil end
    local want = tostring(game.PrivateServerId)
    local first
    for _, s in ipairs(data.data) do
        if type(s) == "table" and type(s.accessCode) == "string" then
            first = first or s.accessCode
            if tostring(s.vipServerId) == want or tostring(s.id) == want then return s.accessCode end
        end
    end
    return first
end

local function doTeleport(sameServer)
    if V.teleporting then return end
    V.teleporting = true
    local root = rootPlaceId()
    saveResume()
    queueReexec()
    local TS = game:GetService("TeleportService")
    local ok, err = pcall(function()
        if inPrivateServer() then
            local code = privateServerAccessCode()
            if code then
                TS:TeleportToPrivateServer(root, code, { LocalPlayer })
                return
            end
            if sameServer then
                TS:TeleportToPlaceInstance(root, game.JobId, LocalPlayer)
                return
            end
        end
        if sameServer then
            if game.PlaceId == root then
                TS:TeleportToPlaceInstance(root, game.JobId, LocalPlayer)
            else
                TS:Teleport(root, LocalPlayer)
            end
        else
            local target = pickOtherServer(root)
            if target then
                TS:TeleportToPlaceInstance(root, target, LocalPlayer)
            else
                TS:Teleport(root, LocalPlayer)
            end
        end
    end)
    if not ok then
        warnlog("teleport failed: %s", tostring(err))
        V.teleporting = false
    end
end

local function trailClosedAction(st)
    if not (F.trailRejoin or F.trailHop) then return end
    if not tonumber(tostring(F.trailChoice):match("%d+")) then return end
    if st.eggLeft then return end
    V.trailClosedSince = V.trailClosedSince or os.clock()
    if os.clock() - V.trailClosedSince < 5 then return end
    if V.teleporting then return end
    state.status = string.format("trail %d closed: %s", st.number, F.trailHop and "hopping server" or "rejoining server")
    notify("Trail closed", F.trailHop and "Hopping to another server" or "Rejoining the same server", 5)
    doTeleport(not F.trailHop)
end

local function loadResume()
    if type(isfile) ~= "function" or type(readfile) ~= "function" then return nil end
    local ok, data = pcall(function()
        if not isfile(K.RESUME_FILE) then return nil end
        local raw = readfile(K.RESUME_FILE)
        delfile(K.RESUME_FILE)
        return game:GetService("HttpService"):JSONDecode(raw)
    end)
    if ok and type(data) == "table" and type(data.at) == "number" and os.time() - data.at < 600 then return data end
    return nil
end

local function trailTick()
    local st = pickTrail()
    if not st then
        V.trailFarmTargets = nil
        if state.excursion == "trail" then releaseExcursion("trail") end
        state.status = "no open trail"
        return
    end
    state.trail = st
    local pts = trailPoints(st.number)
    if not pts or not pts.center then
        V.trailFarmTargets = nil
        if state.excursion == "trail" then releaseExcursion("trail") end
        state.status = string.format("trail %d: model not found", st.number)
        return
    end
    if st.closed and not st.eggLeft then
        V.trailFarmTargets = nil
        if state.excursion == "trail" then releaseExcursion("trail") end
        state.status = string.format("trail %d closed%s", st.number, st.sleepLeft and string.format(" (%dm)", math.ceil(st.sleepLeft / 60)) or "")
        trailClosedAction(st)
        return
    end
    V.trailClosedSince = nil
    if state.excursion ~= nil and state.excursion ~= "trail" then return end
    state.excursion = "trail"
    local p = playerPos()
    local egg = st.eggLeft and trailEgg(st.number) or nil
    if egg and F.trailHatch then
        V.trailFarmTargets = nil
        if p and dist(p, egg.pos) > 18 and os.clock() - V.trailLastTeleport > 1.5 then
            V.trailLastTeleport = os.clock()
            teleportTo(egg.pos + Vector3.new(0, 3, 8), egg.pos)
            return
        end
        state.status = string.format("trail %d egg open (%ds): hatching %s", st.number, math.floor(st.eggLeft), egg.id)
        hatchOnce(egg)
        return
    end
    local targets = {}
    for _, m in ipairs(dmBreakableModels()) do
        if tostring(m:GetAttribute("AreaID")) == "Trail" .. st.number then targets[#targets + 1] = m:GetAttribute("BreakableUID") end
    end
    V.trailFarmTargets = #targets > 0 and targets or nil
    if #targets == 0 then
        state.status = string.format("trail %d: waiting for the boss chest", st.number)
        task.wait(1.5)
        return
    end
    local standAt = pts.center + Vector3.new(0, 3, 0)
    if #targets > 0 then
        local m = nil
        for _, mm in ipairs(dmBreakableModels()) do
            if mm:GetAttribute("BreakableUID") == targets[1] then m = mm break end
        end
        if m then
            local okP, pos = pcall(function() return m:GetPivot().Position end)
            if okP then standAt = pos + Vector3.new(0, 3, 0) end
        end
    end
    if p and dist(p, standAt) > 30 and os.clock() - V.trailLastTeleport > 1.5 then
        V.trailLastTeleport = os.clock()
        teleportTo(standAt)
    end
    state.status = string.format("farming trail %d (chest %d/3%s, %d targets)", st.number, st.chest or 1, st.rollIn > 0 and string.format(", roll in %ds", st.rollIn) or "", #targets)
end

local function loop(name, interval, fn)
    task.spawn(function()
        while state.alive do
            local ok, err = pcall(fn)
            if not ok then logOnce("loop-" .. name .. tostring(err):sub(1, 40), "%s loop error: %s", name, tostring(err)) end
            local dt = type(interval) == "function" and interval() or interval
            task.wait(dt)
        end
    end)
end

loop("camp", 0.25, function()
    if not inInstance() then return end
    local camp = desiredCamp()
    state.campTarget = camp
    if camp and state.excursion == nil then keepAtCamp(camp) end
end)

loop("hatch", function() return math.max(0.15, F.hatchDelay) end, function()
    if not (F.autoBestEgg or F.autoNearestEgg) then state.hatchTarget = nil return end
    if not inInstance() then return end
    local egg
    if F.autoBestEgg then
        egg = campEgg(bestCampNumber())
    else
        egg = nearestEgg()
    end
    if not egg then
        state.status = F.autoBestEgg and "no camp egg found" or string.format("no egg within %d studs", F.nearestRange)
        task.wait(1)
        return
    end
    state.hatchTarget = egg
    if state.excursion == "merchant" then return end
    if F.autoBestEgg then
        if state.excursion ~= nil then return end
        local p = playerPos()
        if not p or dist(p, egg.camp.Pos) > K.CAMP_TOLERANCE then
            keepAtCamp(egg.camp)
            task.wait(0.3)
            return
        end
    end
    local ok, msg = hatchOnce(egg)
    if not ok and msg ~= "hatch cooldown" then task.wait(1) end
end)

loop("tap", function() return math.max(0.02, F.tapInterval) end, function()
    if not F.autoTap or not inInstance() or state.excursion == "merchant" then return end
    tapTick()
end)

loop("yeti", 0.5, function()
    if F.autoYeti and inInstance() then
        yetiTick()
    elseif state.excursion == "yeti" then
        releaseExcursion("yeti")
        V.yetiTarget = nil
    end
end)

loop("trail", 0.5, function()
    if F.autoTrail and inInstance() then
        trailTick()
    elseif state.excursion == "trail" then
        releaseExcursion("trail")
        V.trailFarmTargets = nil
    end
end)

loop("farm", function() return F.fastFarm and 0.2 or 0.5 end, function()
    if not F.autoFarm or not inInstance() then return end
    if state.excursion == "yeti" or state.excursion == "merchant" then return end
    local tick = F.fastFarm and fastFarmTick or function(targets) farmTick(nil, targets) end
    if state.excursion == "trail" then
        if V.trailFarmTargets then tick(V.trailFarmTargets) end
        return
    end
    local camp = state.campTarget
    if not camp then

        local p = playerPos()
        if not p then return end
        local bestD
        for _, c in ipairs(K.CAMPS) do
            local d = dist(p, c.Pos)
            if not bestD or d < bestD then camp, bestD = c, d end
        end
        if bestD > 120 then return end
    end
    if F.fastFarm then
        fastFarmTick(campBreakables(camp.Number))
    else
        farmTick(camp.Number)
    end
end)

loop("farmwatch", 0.05, function()
    if F.fastFarm and F.autoFarm and V.fastDirty and inInstance() and state.excursion ~= "yeti" then
        V.fastDirty = false
        local targets = V.trailFarmTargets
        if state.excursion ~= "trail" then
            local camp = state.campTarget
            if not camp then
                local p = playerPos()
                local bestD
                for _, c in ipairs(K.CAMPS) do
                    local d = p and dist(p, c.Pos) or math.huge
                    if not bestD or d < bestD then camp, bestD = c, d end
                end
                if not camp or bestD > 120 then return end
            end
            targets = campBreakables(camp.Number)
        end
        if targets then fastFarmTick(targets) end
    end
end)

loop("upgrades", 6, function()
    if F.autoUpgrades and inInstance() then upgradeRun() end
end)

loop("boosts", 5, function()
    if F.autoBoosts then boostTick() end
end)

loop("merchant", 4, function()
    if F.autoMerchant and inInstance() then merchantRun() end
end)

loop("artifacts", 10, function()
    if F.autoArtifacts and inInstance() then artifactRun() end
end)

if type(Library.ExecutorSettings) ~= "table" or type(Library.ExecutorSettings.MenuKeybind) ~= "string" or Library.ExecutorSettings.MenuKeybind == "" then
    pcall(function() Library:SetMenuKeybind(Enum.KeyCode.RightShift) end)
end

local isMobile = false
pcall(function() isMobile = Library:IsMobileClient() end)

UI.Window = Library:CreateWindow({
    Name = "VY HUB",
    SubName = "Diamond Mountain",
    Logo = "mountain",
    ToggleButtonEnabled = isMobile,
    KeybindListEnabled = false,
    SettingsTabEnabled = true,
    WatermarkEnabled = true,
    WatermarkText = "VY HUB | Diamond Mountain",
})

local function tab(name, icon)
    return UI.Window:AddTab({ Name = name, Icon = icon })
end

local function num(v, fallback)
    local n = tonumber(v)
    if n == nil or n ~= n then return fallback end
    return n
end
local function section(t, name)
    return t:AddSection({ Name = name })
end

UI.MainTab = tab("Main", "mountain")
UI.StatusSec = section(UI.MainTab, "Status")
UI.lblStatus = UI.StatusSec:AddLabel("Status: starting")
UI.lblAcorns = UI.StatusSec:AddLabel("Acorns: -")
UI.lblCamp = UI.StatusSec:AddLabel("Best camp: -")
UI.lblCounters = UI.StatusSec:AddLabel("Hatched: 0 | Upgrades: 0 | Boosts: 0 | Merchant: 0")
UI.StatusSec:AddButton({ Name = "Enter Diamond Mountain", Callback = function()
    task.spawn(function()
        local ok, err = enterInstance()
        notify("Diamond Mountain", ok and "Entered the instance" or ("Enter failed: " .. tostring(err)), 5)
    end)
end })

UI.TeleSec = section(UI.MainTab, "Teleport")
UI.TeleSec:AddDropdown({ Name = "Camp", Items = K.CAMP_NAMES, Default = F.selectedCamp, Flag = "dm_camp", Callback = function(v)
    if type(v) == "table" then v = v[1] end
    if K.CAMP_BY_NAME[v] then F.selectedCamp = v end
end })
UI.TeleSec:AddToggle({ Name = "Auto Teleport To Camp", Default = false, Flag = "dm_autoCamp", Callback = function(v) F.autoCamp = v end })
UI.TeleSec:AddToggle({ Name = "Auto Teleport To Best Camp", Default = false, Flag = "dm_autoBestCamp", Callback = function(v) F.autoBestCamp = v end })
UI.TeleSec:AddButton({ Name = "Teleport To Selected Camp Now", Callback = function()
    local c = K.CAMP_BY_NAME[F.selectedCamp]
    if c then teleportTo(c.Pos) end
end })
UI.TeleSec:AddButton({ Name = "Teleport To Best Camp Now", Callback = function()
    local c = K.CAMPS[bestCampNumber()]
    if c then teleportTo(c.Pos) end
end })

UI.FarmSec = section(UI.MainTab, "Breakables")
UI.FarmSec:AddToggle({ Name = "Auto Break Breakables (pets)", Default = true, Flag = "dm_farm", Callback = function(v) F.autoFarm = v end })
UI.FarmSec:AddToggle({ Name = "Fast Farm (Efficient)", Default = false, Flag = "dm_fastFarm", Callback = function(v) F.fastFarm = v V.fastAssign = {} V.breakAssign = {} end })
UI.FarmSec:AddToggle({ Name = "Auto Tap Nearest Breakables", Default = false, Flag = "dm_autoTap", Callback = function(v) F.autoTap = v end })
UI.FarmSec:AddSlider({ Name = "Tap Interval", Min = 0.02, Max = 0.5, Default = 0.05, Decimals = 0.01, Suffix = "s", Flag = "dm_tapInterval", Callback = function(v) F.tapInterval = math.clamp(num(v, F.tapInterval), 0.02, 0.5) end })
UI.lblFarm = UI.FarmSec:AddLabel("Farm ticks: 0 | Taps: 0")

UI.EggTab = tab("Eggs", "egg")
UI.EggSec = section(UI.EggTab, "Auto Hatch")
UI.lblEgg = UI.EggSec:AddLabel("Egg: -")
UI.EggSec:AddToggle({ Name = "Auto Buy The Current Best Egg", Default = false, Flag = "dm_bestEgg", Callback = function(v)
    F.autoBestEgg = v
    if v and UI.tglNearest and UI.tglNearest:Get() then UI.tglNearest:Set(false) end
end })
UI.tglNearest = UI.EggSec:AddToggle({ Name = "Auto Buy Nearest Egg", Default = false, Flag = "dm_nearestEgg", Callback = function(v)
    F.autoNearestEgg = v
    if v and UI.tglBest and UI.tglBest:Get() then UI.tglBest:Set(false) end
end })
UI.EggSec:AddToggle({ Name = "Disable Egg Animation", Default = true, Flag = "dm_noAnim", Callback = function(v) F.noHatchAnim = v end })

UI.EggSec:AddSlider({ Name = "Hatch Delay", Min = 0.15, Max = 3, Default = 0.6, Decimals = 0.05, Suffix = "s", Flag = "dm_hatchDelay", Callback = function(v) F.hatchDelay = math.clamp(num(v, F.hatchDelay), 0.15, 3) end })
UI.EggSec:AddSlider({ Name = "Hatch Amount (0 = max)", Min = 0, Max = 99, Default = 0, Decimals = 1, Flag = "dm_hatchAmount", Callback = function(v) F.hatchAmountOverride = math.floor(math.clamp(num(v, F.hatchAmountOverride), 0, 99)) end })
UI.EggSec:AddSlider({ Name = "Nearest Egg Range", Min = 10, Max = 120, Default = 40, Decimals = 5, Suffix = " studs", Flag = "dm_nearestRange", Callback = function(v) F.nearestRange = math.clamp(num(v, F.nearestRange), 10, 120) end })

UI.YetiTab = tab("Summit", "snowflake")
UI.YetiSec = section(UI.YetiTab, "The Yeti")
UI.YetiSec:AddToggle({ Name = "Auto Fight The Yeti", Default = false, Flag = "dm_autoYeti", Callback = function(v) F.autoYeti = v end })
UI.YetiSec:AddToggle({ Name = "Auto Send Pets To The Yeti", Default = false, Flag = "dm_autoYetiSend", Callback = function(v) F.autoYetiSend = v end })
UI.lblYeti = UI.YetiSec:AddLabel("Yeti: -")
UI.lblYeti2 = UI.YetiSec:AddLabel("Pets sent: 0")

UI.TrailSec = section(UI.YetiTab, "Trails")
UI.TrailSec:AddToggle({ Name = "Auto Farm Trail", Default = false, Flag = "dm_autoTrail", Callback = function(v) F.autoTrail = v end })
UI.TrailSec:AddDropdown({ Name = "Trail", Items = K.TRAIL_CHOICES, Default = F.trailChoice, Flag = "dm_trailChoice", Callback = function(v)
    if type(v) == "table" then v = v[1] end
    if type(v) == "string" then F.trailChoice = v end
end })
UI.TrailSec:AddToggle({ Name = "Open Trail Eggs When Opened", Default = true, Flag = "dm_trailHatch", Callback = function(v) F.trailHatch = v end })
UI.tglTrailRejoin = UI.TrailSec:AddToggle({ Name = "Auto Rejoin Same Server When Trail Selected Closed", Default = false, Flag = "dm_trailRejoin", Callback = function(v)
    F.trailRejoin = v
    if v and UI.tglTrailHop and UI.tglTrailHop:Get() then UI.tglTrailHop:Set(false) end
end })
UI.tglTrailHop = UI.TrailSec:AddToggle({ Name = "Auto Server Hop When Trail Selected Closed", Default = false, Flag = "dm_trailHop", Callback = function(v)
    F.trailHop = v
    if v and UI.tglTrailRejoin and UI.tglTrailRejoin:Get() then UI.tglTrailRejoin:Set(false) end
end })
UI.lblTrail = UI.TrailSec:AddLabel("Trail: -")

UI.ArtSec = section(UI.YetiTab, "Mountain Artifacts")
UI.ArtSec:AddToggle({ Name = "Auto Find Mountain Artifacts", Default = false, Flag = "dm_autoArtifacts", Callback = function(v)
    F.autoArtifacts = v
    V.artifactsAllFound = false
end })
UI.lblArtifacts = UI.ArtSec:AddLabel("Artifacts: -")
UI.ArtSec:AddButton({ Name = "Search Artifacts Now", Callback = function()
    V.artifactsAllFound = false
    task.spawn(function()
        local prev = F.autoArtifacts
        F.autoArtifacts = true
        artifactRun()
        F.autoArtifacts = prev
    end)
end })

UI.UpTab = tab("Upgrades", "trending-up")
UI.UpSec = section(UI.UpTab, "Auto Upgrades")
UI.UpSec:AddToggle({ Name = "Auto Buy Upgrades", Default = false, Flag = "dm_autoUpgrades", Callback = function(v) F.autoUpgrades = v end })
UI.UpSec:AddDropdown({ Name = "Objective", Items = K.OBJECTIVES, Default = F.objective, Flag = "dm_objective", Callback = function(v)
    if type(v) == "table" then v = v[1] end
    if K.OBJECTIVE_ORDER[v] ~= nil or v == K.OBJECTIVES[1] then F.objective = v end
end })
for _, u in ipairs(K.UPGRADES) do
    if not u.Retired then
        UI.UpSec:AddToggle({ Name = "Buy " .. u.Name, Default = true, Flag = "dm_up_" .. u.Key, Callback = function(v) F.upgradeEnabled[u.Key] = v end })
    end
end
UI.UpTrackSec = section(UI.UpTab, "Upgrade Tracks")
UI.lblUpgrades = {}
for _, u in ipairs(K.UPGRADES) do
    UI.lblUpgrades[u.Key] = UI.UpTrackSec:AddLabel(u.Name .. ": -")
end
UI.lblRecommend = UI.UpTrackSec:AddLabel("Next: -")

UI.BoostSec = section(UI.UpTab, "Auto Use Boosts")
UI.BoostSec:AddToggle({ Name = "Auto Use Boosts", Default = false, Flag = "dm_autoBoosts", Callback = function(v) F.autoBoosts = v end })
for _, b in ipairs(K.BOOSTS) do
    UI.BoostSec:AddToggle({ Name = "Use " .. b.Label, Default = true, Flag = "dm_boost_" .. b.Key, Callback = function(v) F.boostEnabled[b.Key] = v end })
end
UI.BoostSec:AddToggle({ Name = "Prefer Tier II", Default = true, Flag = "dm_boostTier2", Callback = function(v) F.boostPreferTier2 = v end })
UI.BoostSec:AddSlider({ Name = "Re-use when under", Min = 10, Max = 600, Default = 90, Decimals = 5, Suffix = "s", Flag = "dm_boostMinLeft", Callback = function(v) F.boostMinLeft = math.clamp(num(v, F.boostMinLeft), 10, 600) end })
UI.lblBoosts = {}
for _, b in ipairs(K.BOOSTS) do
    UI.lblBoosts[b.Key] = UI.BoostSec:AddLabel(b.Label .. ": -")
end

UI.MerchTab = tab("Merchant", "store")
UI.MerchSec = section(UI.MerchTab, "Traveling Merchant")
UI.MerchSec:AddToggle({ Name = "Auto Buy All Boosts From Merchant", Default = false, Flag = "dm_autoMerchant", Callback = function(v) F.autoMerchant = v end })
UI.MerchSec:AddToggle({ Name = "Only Boost Offers", Default = true, Flag = "dm_merchantOnlyBoosts", Callback = function(v) F.merchantOnlyBoosts = v end })
UI.lblMerchant = UI.MerchSec:AddLabel("Merchant: -")
UI.MerchSec:AddButton({ Name = "Visit Merchant Now", Callback = function()
    V.merchantVisitDone = nil
    V.merchantRetryAt = 0
    task.spawn(merchantRun)
end })

UI.MiscTab = tab("Misc", "settings-2")
UI.PatchSec = section(UI.MiscTab, "Patches")
UI.PatchSec:AddToggle({ Name = "Infinite Pet Speed", Default = false, Flag = "dm_infSpeed", Callback = function(v) F.infiniteSpeed = v end })
UI.PatchSec:AddToggle({ Name = "Super Magnet (Auto Collect Orbs)", Default = false, Flag = "dm_superMagnet", Callback = function(v)
    F.superMagnet = v
    refreshMagnetNow()
end })
UI.PatchSec:AddToggle({ Name = "Anti AFK", Default = true, Flag = "dm_antiAfk", Callback = function(v) F.antiAfk = v end })
UI.CtrlSec = section(UI.MiscTab, "Script")
UI.CtrlSec:AddLabel("VY HUB Diamond Mountain v" .. K.VERSION)
UI.CtrlSec:AddLabel("Made By Vy | .gg/Fgaw3JZt6w")
UI.CtrlSec:AddButton({ Name = "Stop Script", Callback = function()
    if genv.VyDiamondMountain then genv.VyDiamondMountain.Stop() end
end })

pcall(function() UI.Window:CreateInfoPage({}) end)
pcall(function() UI.Window:HideLoading() end)

local function setText(lbl, text)
    if lbl and type(lbl.SetText) == "function" then pcall(lbl.SetText, lbl, text) end
end
loop("ui", 1, function()
    setText(UI.lblStatus, "Status: " .. tostring(state.status))
    setText(UI.lblAcorns, "Acorns: " .. shorten(acorns()) .. (inInstance() and "" or "  (not inside Diamond Mountain)"))
    local best = bestCampNumber()
    setText(UI.lblCamp, "Best camp: " .. (K.CAMPS[best] and K.CAMPS[best].Name or tostring(best)))
    setText(UI.lblCounters, string.format("Hatched: %d (requested %d) | Upgrades: %d | Boosts: %d | Merchant: %d", state.hatched, state.hatchRequests, state.upgradesBought, state.boostsUsed, state.merchantBought))
    setText(UI.lblFarm, string.format("Farm ticks: %d | Taps: %d", state.farmTicks, state.taps))
    local st = state.trail
    if F.autoTrail and st then
        local txt
        if st.eggLeft then
            txt = string.format("Trail %d: egg open %ds", st.number, math.floor(st.eggLeft))
        elseif st.closed then
            txt = string.format("Trail %d: closed%s", st.number, st.sleepLeft and string.format(" (%dm)", math.ceil(st.sleepLeft / 60)) or "")
        else
            txt = string.format("Trail %d: open, chest %d/3%s", st.number, st.chest or 1, st.rollIn > 0 and string.format(", roll in %ds", st.rollIn) or "")
        end
        setText(UI.lblTrail, txt .. string.format(" | trail eggs hatched: %d", state.trailHatched))
    else
        local parts = {}
        for i = 1, 6 do
            local s = trailState(i)
            parts[#parts + 1] = string.format("%d:%s", i, s.eggLeft and "EGG" or (s.closed and "closed" or "open"))
        end
        setText(UI.lblTrail, "Trails " .. table.concat(parts, "  "))
    end
    local yi = state.yeti or yetiInfo()
    if yi then
        local txt
        if yi.alive then
            txt = string.format("Yeti: alive %s%%%s", type(yi.health) == "number" and type(yi.maxHealth) == "number" and yi.maxHealth > 0 and tostring(math.floor(yi.health / yi.maxHealth * 100)) or "?", yi.cooldown > 0 and string.format(", your cooldown %ds", math.floor(yi.cooldown)) or "")
        elseif type(yi.backAt) == "number" then
            txt = string.format("Yeti: returns in %ds", math.max(0, math.floor(yi.backAt - serverNow())))
        else
            txt = "Yeti: not here"
        end
        setText(UI.lblYeti, txt)
    end
    setText(UI.lblYeti2, "Pets sent: " .. tostring(state.yetiPetsSent))
    local egg = state.hatchTarget
    if egg then
        local cost = eggCost(egg)
        setText(UI.lblEgg, string.format("Egg: %s (x%d, %s acorns each)", egg.id, maxHatch(egg), cost and shorten(cost) or "?"))
    else
        setText(UI.lblEgg, "Egg: -")
    end

    local coins = acorns()
    for _, u in ipairs(K.UPGRADES) do
        local info = upgradeInfo(u)
        local txt
        if u.Retired or info.disabled then
            txt = string.format("%s: tier %d/%d (retired)", u.Name, info.tier, info.max)
        elseif info.tier >= info.max then
            txt = string.format("%s: MAX (%s)", u.Name, tostring(info.power or ""))
        else
            txt = string.format("%s: tier %d/%d  next %s%s", u.Name, info.tier, info.max, info.cost and shorten(info.cost) or "?", (info.cost and info.cost <= coins) and " (affordable)" or "")
        end
        setText(UI.lblUpgrades[u.Key], txt)
    end
    local cand = pickUpgrade()
    setText(UI.lblRecommend, cand and string.format("Next: %s -> tier %d (%s acorns)", cand.u.Name, cand.info.tier + 1, shorten(cand.info.cost)) or "Next: nothing affordable")

    for _, b in ipairs(K.BOOSTS) do
        local t1 = isfn(G.BoostCmds, "GetTimer") and (gval(G.BoostCmds.GetTimer, b.Ids[1]) or 0) or 0
        local t2 = isfn(G.BoostCmds, "GetTimer") and (gval(G.BoostCmds.GetTimer, b.Ids[2]) or 0) or 0
        local items = boostItems(b.Item)
        local n1, n2 = 0, 0
        for _, it in ipairs(items) do if it.tier == 2 then n2 += it.amount else n1 += it.amount end end
        setText(UI.lblBoosts[b.Key], string.format("%s: I %s | II %s  (inv: %d / %d)", b.Label, t1 > 0 and (math.floor(t1 / 60) .. "m") or "off", t2 > 0 and (math.floor(t2 / 60) .. "m") or "off", n1, n2))
    end

    local ph = merchantPhase()
    if ph then
        local now = workspace:GetServerTimeNow()
        if ph.Arrived then
            setText(UI.lblMerchant, string.format("Merchant: camp %d, leaves in %dm %02ds", ph.Camp, math.max(0, math.floor((ph.LeaveAt - now) / 60)), math.max(0, math.floor(ph.LeaveAt - now) % 60)))
        else
            setText(UI.lblMerchant, string.format("Merchant: traveling to camp %d (%ds)", ph.Camp, math.max(0, math.floor(ph.ArriveAt - now))))
        end
    else
        setText(UI.lblMerchant, "Merchant: -")
    end

    local found = readArtifactState()
    local n = 0
    local list = {}
    for i = 1, 6 do if found[i] then n += 1 list[#list + 1] = tostring(i) end end
    state.artifactsFound = n
    setText(UI.lblArtifacts, string.format("Artifacts: %d/6 found %s", n, n > 0 and ("(" .. table.concat(list, ",") .. ")") or ""))
end)

pcall(installSpeedHook)
pcall(installMagnet)
pcall(installNoHatchAnimation)
pcall(installAntiAfk)
pcall(installMerchantListener)
pcall(installHatchListener)
pcall(installBreakableWatcher)

genv.VyDiamondMountain = {
    Stop = function()
        if not state.alive then return end
        state.alive = false
        F.infiniteSpeed, F.superMagnet, F.noHatchAnim = false, false, false
        F.autoYeti, F.autoTrail, F.autoTap = false, false, false
        for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
        connections = {}
        for _, fn in ipairs(restoreFns) do pcall(fn) end
        restoreFns = {}
        pcall(refreshMagnetNow)
        pcall(function() if genv.Library and genv.Library.Unload then genv.Library:Unload() end end)
        log("stopped")
    end,
    State = state,
    Features = F,
    Debug = { inInstance = inInstance, nearestEgg = nearestEgg, tapTick = tapTick, nearestBreakableUid = nearestBreakableUid, allDMEggs = allDMEggs, yetiInfo = yetiInfo, trailState = trailState, pickTrail = pickTrail, dmBreakableModels = dmBreakableModels, pickOtherServer = pickOtherServer, saveResume = saveResume, loadResume = loadResume },
}

pcall(function()
    if type(Library.OnUnload) == "function" then
        Library:OnUnload(function()
            if state.alive then
                state.alive = false
                for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
                for _, fn in ipairs(restoreFns) do pcall(fn) end
            end
        end)
    end
end)

task.spawn(function()
    local resume = loadResume()
    if resume then
        task.wait(2)
        local function setFlag(key, flagName)
            if resume[key] == nil then return end
            local setter = Library.SetFlags and Library.SetFlags[flagName]
            if type(setter) == "function" then pcall(setter, resume[key]) end
        end
        setFlag("trailChoice", "dm_trailChoice")
        setFlag("trailHatch", "dm_trailHatch")
        setFlag("trailRejoin", "dm_trailRejoin")
        setFlag("trailHop", "dm_trailHop")
        setFlag("autoFarm", "dm_farm")
        setFlag("fastFarm", "dm_fastFarm")
        setFlag("autoTap", "dm_autoTap")
        setFlag("autoTrail", "dm_autoTrail")
        log("resumed trail settings after server teleport")
        if resume.originPlace and resume.originPlace ~= game.PlaceId and type(resume.world) == "number" and resume.world > 1 then
            local okE = enterInstance()
            if not okE then
                log("Diamond Mountain not reachable here, teleporting to World %d", resume.world)
                saveResume()
                queueReexec()
                local okW, errW = netInvoke("World" .. resume.world .. "Teleport")
                if not okW then warnlog("world teleport failed: %s", tostring(errW)) end
                return
            end
        end
    end
    local ok, err = enterInstance()
    if ok then
        state.status = "inside Diamond Mountain"
        notify("VY HUB", "Diamond Mountain loaded - RightShift opens the menu", 6)
    else
        state.status = "not inside Diamond Mountain (" .. tostring(err) .. ")"
        notify("VY HUB", "Could not enter Diamond Mountain: " .. tostring(err), 8)
    end
end)

pcall(function() Library:LoadAutoloadConfig(true) end)
log("loaded v%s (identity %d)", K.VERSION, K.IDENTITY_EXEC)
