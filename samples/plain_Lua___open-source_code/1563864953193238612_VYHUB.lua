local genv = (type(getgenv) == "function" and getgenv()) or _G
if type(genv.VyPSXClassic) == "table" and type(genv.VyPSXClassic.Stop) == "function" then
    pcall(genv.VyPSXClassic.Stop)
    task.wait(0.3)
end

local K, V, G, UI, F = {}, {}, {}, {}, {}

K.TAG = "[VY PSXClassic] "
K.VERSION = "1.1.0"
K.LIB_FILE = "VyLib.lua"
K.LIB_URLS = {
    "https://raw.githubusercontent.com/92tg/VYHUB/main/VyLib.lua",
}
K.COIN_REACH_MAX = 300
K.EGG_REACH = 20
K.GATE_REACH = 35
K.PAD_REACH = 12
K.GIANT_REACH = 60
K.FARM_STALL = 20
K.ORB_RETRY = 4
K.ORB_DEAD = 12
K.VIP_COOLDOWN = 14400
K.FARM_MODES = { "Nearest", "Highest Health", "Lowest Health" }
K.EGG_AMOUNTS = { "Auto (best owned)", "1", "3", "8" }
K.RARITIES = { "Basic", "Rare", "Epic", "Legendary", "Mythical" }
K.SKIP_EGGS = { ["Dominus Egg"] = true, ["Hacker Egg"] = true, ["Hacker Golden Egg"] = true }
K.BOOST_FALLBACK = { "Triple Coins", "Triple Damage", "Triple Diamonds", "Super Lucky", "Ultra Lucky" }

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local VirtualUser = game:GetService("VirtualUser")
local LocalPlayer = Players.LocalPlayer

local state = {
    alive = true,
    status = "starting",
    orbs = 0,
    ghostOrbs = 0,
    lootbags = 0,
    joins = 0,
    coinsBroken = 0,
    giantsBroken = 0,
    hatched = 0,
    hatchRequests = 0,
    areasBought = 0,
    teleportsBought = 0,
    upgradesBought = 0,
    boostsUsed = 0,
    equips = 0,
    goldens = 0,
    rainbows = 0,
    fuses = 0,
    enchants = 0,
    deletesSynced = 0,
    rankRedeems = 0,
    vipRedeems = 0,
    farmNote = nil,
    eggTarget = nil,
    eggNote = nil,
    areaTarget = nil,
    areaNote = nil,
    petNote = nil,
    progressNote = nil,
    rewardNote = nil,
    collectNote = nil,
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
local function has(list, value)
    if type(list) ~= "table" then return false end
    for _, v in ipairs(list) do
        if v == value then return true end
    end
    return false
end
local function listOf(v)
    if type(v) == "table" then return v end
    if type(v) == "string" then return { v } end
    return {}
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

G.Library = req("Framework.Library")
assert(type(G.Library) == "table", "PSX Classic Library (ReplicatedStorage.Framework.Library) is unavailable")
G.Network = G.Library.Network
G.Save = G.Library.Save
G.PetCmds = G.Library.PetCmds
G.WorldCmds = G.Library.WorldCmds
G.Gamepasses = G.Library.Gamepasses
G.Directory = G.Library.Directory
G.Shared = G.Library.Shared
G.RebornLock = G.Library.RebornLock
G.RebornBalance = G.Library.RebornBalance
G.Variables = G.Library.Variables
G.FFlags = G.Library.FFlags
G.Yeet = req("Library.Types.Yeet")

local function gameScript(folder, name)
    local ok, inst = pcall(function()
        return LocalPlayer:WaitForChild("PlayerScripts", 5):WaitForChild("Scripts", 5):WaitForChild(folder, 5):WaitForChild(name, 5)
    end)
    return ok and inst or nil
end
local function scriptEnv(inst)
    if not inst or type(getsenv) ~= "function" then return nil end
    local ok, env = pcall(getsenv, inst)
    if ok and type(env) == "table" then return env end
    return nil
end

local function findUpvalue(fn, name)
    if type(fn) ~= "function" or type(debug.getupvalues) ~= "function" then return nil end
    local ok, ups = pcall(debug.getupvalues, fn)
    if not ok or type(ups) ~= "table" then return nil end
    for _, u in pairs(ups) do
        if type(u) == "function" then
            local okN, n = pcall(debug.info, u, "n")
            if okN and n == name then return u end
        end
    end
    return nil
end

V.remoteFns = {}
V.remoteEvents = {}
local function resolveRemotes()
    if V.getName and V.remote then return true end
    local rfn = findUpvalue(G.Network and G.Network.Invoke, "_remoteFunction")
    local getName = findUpvalue(rfn, "_getName")
    local remote = findUpvalue(rfn, "_remote")
    if type(getName) == "function" and type(remote) == "function" then
        V.getName, V.remote = getName, remote
        return true
    end
    logOnce("remotes", "could not resolve the Network remote lookup; game calls are unavailable")
    return false
end
local function remoteFunction(name)
    local r = V.remoteFns[name]
    if r and r.Parent then return r end
    if not resolveRemotes() then return nil end
    local ok, inst = pcall(function() return V.remote(2, V.getName(2, name)) end)
    if ok and typeof(inst) == "Instance" then V.remoteFns[name] = inst return inst end
    logOnce("rf-" .. name, "RemoteFunction %s not found", name)
    return nil
end
local function remoteEvent(name)
    local r = V.remoteEvents[name]
    if r and r.Parent then return r end
    if not resolveRemotes() then return nil end
    local ok, inst = pcall(function() return V.remote(1, V.getName(1, name)) end)
    if ok and typeof(inst) == "Instance" then V.remoteEvents[name] = inst return inst end
    logOnce("re-" .. name, "RemoteEvent %s not found", name)
    return nil
end
local function netInvoke(name, ...)
    local rf = remoteFunction(name)
    if not rf then return false, "remote unavailable: " .. name end
    return gcall(rf.InvokeServer, rf, ...)
end
local function netFire(name, ...)
    local re = remoteEvent(name)
    if not re then return false, "remote unavailable: " .. name end
    return gcall(re.FireServer, re, ...)
end
local function onRemote(name, fn)
    local re = remoteEvent(name)
    if not re then return nil end
    return track(re.OnClientEvent:Connect(function(...)
        if not state.alive then return end
        local ok, err = pcall(fn, ...)
        if not ok then logOnce("evt-" .. name, "%s handler error: %s", name, tostring(err)) end
    end))
end
local function resultText(ok, res, msg)
    if not ok then return tostring(res) end
    if res == true then return "ok" end
    return tostring(msg or res or "refused")
end

V.save = nil
V.saveAt = 0
local function getSave()
    if type(V.save) ~= "table" then
        local s = isfn(G.Save, "Get") and gval(G.Save.Get) or nil
        if type(s) == "table" then
            local copy = {}
            for k, v in pairs(s) do copy[k] = v end
            V.save = copy
            V.saveAt = os.clock()
        end
    end
    return V.save
end
local function installSaveTracker()
    onRemote("New Stats", function(changes, who)
        if who ~= nil and who ~= LocalPlayer then return end
        if type(changes) ~= "table" then return end
        local s = getSave()
        if not s then return end
        for k, v in pairs(changes) do s[k] = v end
        V.saveAt = os.clock()
    end)
end
local function currency(name)
    local s = getSave()
    local v = s and s[name]
    if type(v) == "number" then return v end
    return 0
end
local function isHardcore()
    return G.Shared and G.Shared.IsHardcore == true
end
local function hasArea(name)
    if type(name) ~= "string" or name == "" then return true end
    if not (G.Directory and G.Directory.Areas and G.Directory.Areas[name]) then return false end
    if not isfn(G.WorldCmds, "HasArea") then return false end
    return gval(G.WorldCmds.HasArea, name) == true
end
local function areaOpen(name)
    if not isfn(G.RebornLock, "AreaOpen") then return true end
    return gval(G.RebornLock.AreaOpen, name) ~= false
end
local function canDoAction()
    if not isfn(G.WorldCmds, "CanDoAction") then return true end
    return gval(G.WorldCmds.CanDoAction) ~= false
end
local function currentWorld()
    return isfn(G.WorldCmds, "Get") and gval(G.WorldCmds.Get) or "?"
end
local function worldMap()
    local m = workspace:FindFirstChild("__MAP")
    return m
end
local function ownsPass(name)
    local pass = G.Directory and G.Directory.Gamepasses and G.Directory.Gamepasses[name]
    if not (pass and pass.ID and isfn(G.Gamepasses, "Owns")) then return false end
    return gval(G.Gamepasses.Owns, pass.ID) == true
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
local function teleportTo(cf)
    local c = LocalPlayer.Character
    local r = hrp()
    if not (c and r) then return false end
    pcall(function()
        r.AssemblyLinearVelocity = Vector3.zero
        r.AssemblyAngularVelocity = Vector3.zero
    end)
    return pcall(function() c:PivotTo(cf) end)
end
local function dist(a, b)
    if not (a and b) then return math.huge end
    return (a - b).Magnitude
end
local function thingsFolder(name)
    local things = workspace:FindFirstChild("__THINGS")
    return things and things:FindFirstChild(name) or nil
end
local function padOf(name)
    local map = worldMap()
    local inter = map and map:FindFirstChild("Interactive")
    local model = inter and inter:FindFirstChild(name)
    if not model then return nil end
    return model:FindFirstChild("Pad") or model:FindFirstChildWhichIsA("BasePart", true)
end
local function goNear(position, reach, allowed)
    local p = playerPos()
    if not p or dist(p, position) <= reach then return nil end
    if not allowed then return false end
    local r = hrp()
    local origin = r and r.CFrame
    teleportTo(CFrame.new(position + Vector3.new(0, 3, 0)))
    task.wait(0.35)
    return origin
end
local function goBack(origin, allowed)
    if origin and allowed then
        task.wait(0.3)
        teleportTo(origin)
    end
end
V.osTimeBase = nil
V.osTimeAt = 0
local function osTime()
    if type(V.osTimeBase) ~= "number" or os.clock() - V.osTimeAt > 600 then
        local ok, t = netInvoke("Get OSTime")
        if ok and type(t) == "number" then
            V.osTimeBase, V.osTimeAt = t, os.clock()
        end
    end
    if type(V.osTimeBase) == "number" then return V.osTimeBase + (os.clock() - V.osTimeAt) end
    return os.time()
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
    local function nudge()
        pcall(function()
            VirtualUser:CaptureController()
            VirtualUser:ClickButton2(Vector2.new())
            local cam = workspace.CurrentCamera
            VirtualUser:Button2Down(Vector2.new(0, 0), cam and cam.CFrame or CFrame.new())
            task.wait(0.05)
            VirtualUser:Button2Up(Vector2.new(0, 0), cam and cam.CFrame or CFrame.new())
        end)
    end
    track(LocalPlayer.Idled:Connect(function()
        if not (F.antiAfk and state.alive) then return end
        nudge()
    end))
    task.spawn(function()
        while state.alive do
            task.wait(60)
            if F.antiAfk and state.alive then nudge() end
        end
    end)
    log("anti-AFK installed")
end

F.autoOrbs = false
F.ghostOrbs = true
F.autoLootbags = false
V.orbQueue = {}
V.orbSeen = {}
V.orbClaims = {}
V.orbGone = {}
V.orbsEnv = nil
V.lootTried = {}
local function queueOrb(id)
    if type(id) ~= "string" or V.orbSeen[id] then return end
    V.orbSeen[id] = os.clock()
    V.orbClaims[id] = 0
    V.orbQueue[#V.orbQueue + 1] = id
end
local function removeOrbPart(part)
    if not (part and part.Parent) then return end
    if not F.ghostOrbs then return end
    local done = false
    if type(V.orbsEnv) == "table" and type(V.orbsEnv.RemoveOrb) == "function" then
        done = gcall(V.orbsEnv.RemoveOrb, part.Name) == true
    end
    if not done or part.Parent then pcall(function() part:Destroy() end) end
    state.ghostOrbs += 1
end
local function installOrbListener()
    V.orbsEnv = scriptEnv(gameScript("Game", "Orbs"))
    onRemote("Orb Added", function(id)
        if F.autoOrbs then queueOrb(id) end
    end)
    onRemote("Orb Removed", function(id)
        if type(id) ~= "string" then return end
        if V.orbSeen[id] then state.orbs += 1 end
        V.orbSeen[id] = nil
        V.orbClaims[id] = nil
        V.orbGone[id] = os.clock()
    end)
    onRemote("Remove Lootbag", function(id)
        if type(id) ~= "string" then return end
        if V.lootTried[id] then
            state.lootbags += 1
            V.lootTried[id] = nil
        end
        local folder = thingsFolder("Lootbags")
        local part = folder and folder:FindFirstChild(id)
        if part then pcall(function() part:Destroy() end) end
    end)
end
local function sweepOrbs()
    local folder = thingsFolder("Orbs")
    if not folder then return end
    for _, part in ipairs(folder:GetChildren()) do queueOrb(part.Name) end
end
local function orbTick()
    if not F.autoOrbs then
        if #V.orbQueue > 0 then V.orbQueue = {} end
        return
    end
    if #V.orbQueue > 0 then
        local ids = V.orbQueue
        V.orbQueue = {}
        local ok, err = netFire("Claim Orbs", ids)
        if not ok then logOnce("claim-orbs", "Claim Orbs failed: %s", tostring(err)) end
        local now = os.clock()
        for _, id in ipairs(ids) do
            V.orbClaims[id] = (V.orbClaims[id] or 0) + 1
            V.orbSeen[id] = now
        end
    end
    local now = os.clock()
    local folder = thingsFolder("Orbs")
    if folder then
        for _, part in ipairs(folder:GetChildren()) do
            local id = part.Name
            if V.orbGone[id] then
                removeOrbPart(part)
            end
        end
    end
    for id, t in pairs(V.orbSeen) do
        local age = now - t
        local claims = V.orbClaims[id] or 0
        if age > K.ORB_DEAD then
            local part = folder and folder:FindFirstChild(id)
            if part then removeOrbPart(part) end
            V.orbSeen[id] = nil
            V.orbClaims[id] = nil
        elseif age > K.ORB_RETRY and claims < 2 then
            V.orbQueue[#V.orbQueue + 1] = id
            V.orbClaims[id] = claims + 1
            V.orbSeen[id] = now
        end
    end
    for id, t in pairs(V.orbGone) do
        if now - t > 60 then V.orbGone[id] = nil end
    end
end
local function lootTick()
    if not F.autoLootbags then return end
    local folder = thingsFolder("Lootbags")
    if not folder then return end
    local now = os.clock()
    for _, part in ipairs(folder:GetChildren()) do
        if part:IsA("BasePart") and part:GetAttribute("ID") and not part:GetAttribute("Collected") then
            local id = part:GetAttribute("ID")
            local t = V.lootTried[id]
            if not t or now - t > 3 then
                V.lootTried[id] = now
                netFire("Collect Lootbag", id, part.Position)
            end
        end
    end
    for id, t in pairs(V.lootTried) do
        if now - t > 30 then V.lootTried[id] = nil end
    end
end

F.autoFarm = false
F.farmMode = K.FARM_MODES[1]
F.farmRange = 150
F.autoGiant = false
F.giantNames = {}
F.giantTeleport = true
V.coinHealth = {}
V.farmTarget = nil
V.farmJoinedAt = 0
V.farmLastHit = 0
V.farmPets = {}
V.farmIsGiant = false
V.serverCoins = nil
V.serverCoinsAt = 0
V.coinBlock = {}

K.GIANT_LIST = {}
do
    local coins = G.Directory and G.Directory.Coins
    if type(coins) == "table" then
        for name in pairs(coins) do
            if type(name) == "string" and name:find("Giant") then K.GIANT_LIST[#K.GIANT_LIST + 1] = name end
        end
        table.sort(K.GIANT_LIST)
    end
end

local function coinsFolder()
    return thingsFolder("Coins")
end
local function refreshServerCoins()
    if os.clock() - V.serverCoinsAt < 5 then return V.serverCoins end
    V.serverCoinsAt = os.clock()
    local ok, res = netInvoke("Get Coins")
    if ok and type(res) == "table" then
        V.serverCoins = res
        for id, data in pairs(res) do
            if type(data) == "table" and type(data.h) == "number" and V.coinHealth[id] == nil then V.coinHealth[id] = data.h end
        end
    end
    return V.serverCoins
end
local function coinHealth(folder)
    local h = V.coinHealth[folder.Name]
    if type(h) ~= "number" then
        local s = V.serverCoins and V.serverCoins[folder.Name]
        h = (type(s) == "table" and tonumber(s.h)) or tonumber(folder:GetAttribute("Health")) or 0
    end
    return h
end
local function coinPos(folder)
    local pos = folder:FindFirstChild("POS")
    if pos and pos:IsA("BasePart") then return pos.Position end
    local ok, p = pcall(function() return folder:GetPivot().Position end)
    return ok and p or nil
end
local function coinOk(folder)
    if not (folder and folder.Parent) then return false end
    if folder:GetAttribute("ID") == nil then return false end
    if V.serverCoins and V.serverCoins[folder.Name] == nil then return false end
    if (V.coinBlock[folder.Name] or 0) > os.clock() then return false end
    local area = folder:GetAttribute("Area")
    if type(area) == "string" and area ~= "" then
        if not hasArea(area) then return false end
        if isfn(G.RebornLock, "CoinAreaOpen") and gval(G.RebornLock.CoinAreaOpen, area) == false then return false end
    end
    local model = folder:FindFirstChild("Coin")
    if model and model:GetAttribute("PreventClick") then return false end
    return coinHealth(folder) > 0
end
local function installCoinListeners()
    onRemote("Update Coin Health", function(id, h)
        if type(id) == "string" and type(h) == "number" then
            V.coinHealth[id] = h
            if V.farmTarget and V.farmTarget.Name == id then V.farmLastHit = os.clock() end
        end
    end)
    onRemote("Remove Coin", function(id)
        if type(id) ~= "string" then return end
        V.coinHealth[id] = nil
        if V.farmTarget and V.farmTarget.Name == id then
            if V.farmLastHit > 0 then
                state.coinsBroken += 1
                if V.farmIsGiant then state.giantsBroken += 1 end
            end
            local pets = V.farmPets
            V.farmTarget = nil
            V.farmPets = {}
            V.farmIsGiant = false
            for _, uid in ipairs(pets) do netFire("Change Pet Target", uid, "Player") end
        end
    end)
end
local function releasePets(uids, lastId)
    if lastId then netInvoke("Leave Coin", lastId, uids) end
    for _, uid in ipairs(uids) do netFire("Change Pet Target", uid, "Player") end
end
local function petUids()
    local list = {}
    if not isfn(G.PetCmds, "GetEquipped") then return list end
    local eq = gval(G.PetCmds.GetEquipped)
    if type(eq) ~= "table" then return list end
    for _, p in ipairs(eq) do
        if type(p) == "table" and type(p.uid) == "string" then list[#list + 1] = p.uid end
    end
    return list
end
local function pickCoin()
    local folder = coinsFolder()
    local p = playerPos()
    if not (folder and p) then return nil end
    refreshServerCoins()
    local best, bestScore
    for _, c in ipairs(folder:GetChildren()) do
        if coinOk(c) then
            local pos = coinPos(c)
            local d = pos and dist(pos, p) or math.huge
            if d <= F.farmRange then
                local score
                if F.farmMode == "Highest Health" then
                    score = -coinHealth(c)
                elseif F.farmMode == "Lowest Health" then
                    score = coinHealth(c)
                else
                    score = d
                end
                if not bestScore or score < bestScore then best, bestScore = c, score end
            end
        end
    end
    return best
end
local function giantTarget()
    if not F.autoGiant or #F.giantNames == 0 then return nil end
    local folder = coinsFolder()
    local p = playerPos()
    if not (folder and p) then return nil end
    refreshServerCoins()
    local best, bestD
    for _, c in ipairs(folder:GetChildren()) do
        if has(F.giantNames, c:GetAttribute("Name")) and coinOk(c) then
            local pos = coinPos(c)
            local d = pos and dist(pos, p) or math.huge
            if not bestD or d < bestD then best, bestD = c, d end
        end
    end
    return best
end
local function joinCoin(folder, giant)
    local uids = petUids()
    if #uids == 0 then
        state.farmNote = "no pets equipped"
        return false
    end
    local id = folder:GetAttribute("ID") or folder.Name
    local ok, res = netInvoke("Join Coin", id, uids)
    if not ok then
        state.farmNote = "Join Coin error: " .. tostring(res)
        return false
    end
    if type(res) ~= "table" then
        state.farmNote = "Join Coin refused (" .. tostring(res) .. ")"
        return false
    end
    local joined, msg = {}, nil
    for _, uid in ipairs(uids) do
        local r = res[uid]
        if r == true then
            joined[#joined + 1] = uid
            netFire("Change Pet Target", uid, "Coin", id)
            netFire("Farm Coin", id, uid)
        elseif type(r) == "string" then
            msg = r
        end
    end
    state.joins += 1
    if #joined == 0 then
        state.farmNote = msg or "no pet accepted the coin, releasing pets"
        V.coinBlock[id] = os.clock() + 30
        releasePets(uids, V.lastTargetId)
        return false
    end
    V.farmTarget = folder
    V.farmIsGiant = giant == true
    V.lastTargetId = id
    V.farmPets = joined
    V.farmJoinedAt = os.clock()
    V.farmLastHit = 0
    state.farmNote = msg
    return true
end
local function farmTick()
    if not F.autoFarm then
        V.farmTarget = nil
        return
    end
    if not canDoAction() then
        state.status = "waiting (world loading / busy)"
        return
    end
    local target = V.farmTarget
    if target then
        if not coinOk(target) then
            V.farmTarget = nil
            target = nil
        else
            local since = os.clock() - math.max(V.farmJoinedAt, V.farmLastHit)
            if since > K.FARM_STALL then
                state.farmNote = "no hits for " .. math.floor(since) .. "s, retargeting"
                releasePets(V.farmPets, target:GetAttribute("ID") or target.Name)
                V.farmTarget = nil
                target = nil
            end
        end
    end
    local giant = giantTarget()
    if giant and giant ~= target then
        if target then
            releasePets(V.farmPets, target:GetAttribute("ID") or target.Name)
            V.farmTarget = nil
        end
        local pos = coinPos(giant)
        if pos then goNear(pos, K.GIANT_REACH, F.giantTeleport) end
        if joinCoin(giant, true) then
            state.status = string.format("breaking giant %s (%s hp)", tostring(giant:GetAttribute("Name")), shorten(coinHealth(giant)))
        else
            state.status = "giant join failed: " .. tostring(state.farmNote)
        end
        return
    end
    if target then
        state.status = string.format("farming %s (%s hp)", tostring(target:GetAttribute("Name")), shorten(coinHealth(target)))
        return
    end
    local pick = pickCoin()
    if not pick then
        state.status = string.format("no breakable within %d studs", F.farmRange)
        return
    end
    if joinCoin(pick, false) then
        state.status = string.format("farming %s (%s hp)", tostring(pick:GetAttribute("Name")), shorten(coinHealth(pick)))
    else
        state.status = "join failed: " .. tostring(state.farmNote)
        task.wait(1)
    end
end

F.autoEgg = false
F.autoSelectedEgg = false
F.selectedEgg = nil
F.eggPercent = 100
F.eggDelay = 1
F.eggGolden = false
F.eggSaveArea = false
F.eggAmount = K.EGG_AMOUNTS[1]
F.eggTeleport = true
F.eggReturn = true
F.skipEggAnim = false
F.autoDelete = false
F.deleteRarities = {}

local function masteryLevel(key)
    local s = getSave()
    local xp = s and type(s.Mastery) == "table" and s.Mastery[key] or 0
    if isfn(G.Shared, "MasteryXPToLevel") then
        local lvl = gval(G.Shared.MasteryXPToLevel, xp)
        if type(lvl) == "number" then return lvl end
    end
    return 0
end
local function masteryMult(golden)
    local dir = G.Directory and G.Directory.Mastery
    local entry = dir and dir[golden and "Golden Eggs" or "Eggs"]
    local perks = entry and entry.perks
    if type(perks) ~= "table" then return 1 end
    local lvl = masteryLevel(golden and "Golden Eggs" or "Eggs")
    local p2, p4 = perks[2], perks[4]
    if golden then
        if p4 and p4.level <= lvl then return 0.85 end
        if p2 and p2.level <= lvl then return 0.95 end
    else
        if p4 and p4.level <= lvl then return 0.8 end
        if p2 and p2.level <= lvl then return 0.9 end
    end
    return 1
end
local function yeetMult()
    local s = getSave()
    local tier = s and type(s.Upgrades) == "table" and s.Upgrades["Yeet Egg Price"] or 0
    local tbl = G.Yeet and type(G.Yeet.Upgrades) == "table" and G.Yeet.Upgrades["Yeet Egg Price"]
    if type(tier) == "number" and tier > 0 and type(tbl) == "table" and type(tbl[tier]) == "number" then return tbl[tier] end
    return 1
end
local function eggCost(dir)
    if type(dir) ~= "table" then return nil end
    local base = (isHardcore() and dir.hardcoreCost) or dir.cost
    if type(base) ~= "number" then return nil end
    local mult = dir.isYeet and yeetMult() or masteryMult(dir.isGolden == true)
    return math.round(base * mult)
end
local function eggUnlocked(id, depth)
    depth = depth or 0
    if depth > 8 then return false end
    local dir = G.Directory and G.Directory.Eggs and G.Directory.Eggs[id]
    if type(dir) ~= "table" then return false end
    if K.SKIP_EGGS[id] then return false end
    if dir.areaRequired and not hasArea(dir.area) then return false end
    local reqEgg = dir.eggRequired
    if type(reqEgg) == "string" and reqEgg ~= "" and reqEgg ~= id and not eggUnlocked(reqEgg, depth + 1) then return false end
    if type(reqEgg) == "string" and reqEgg ~= "" and (tonumber(dir.eggRequiredOpenAmount) or 0) > 0 then
        local s = getSave()
        local opened = s and (isHardcore() and type(s.Hardcore) == "table" and s.Hardcore.EggsOpened or s.EggsOpened)
        local n = type(opened) == "table" and opened[reqEgg] or 0
        if (tonumber(n) or 0) < dir.eggRequiredOpenAmount then return false end
    end
    return true
end
local function allEggs()
    if isfn(G.WorldCmds, "GetAllEggs") then
        local list = gval(G.WorldCmds.GetAllEggs)
        if type(list) == "table" then return list end
    end
    return {}
end
local function eggEntry(m)
    local id = m:GetAttribute("ID")
    local dir = type(id) == "string" and G.Directory.Eggs[id] or nil
    if type(dir) ~= "table" then return nil end
    local cost = eggCost(dir)
    if not cost then return nil end
    return { model = m, id = id, dir = dir, cost = cost, currency = dir.currency or "Coins" }
end
local function bestEgg()
    local best
    for _, m in ipairs(allEggs()) do
        local e = eggEntry(m)
        if e and not e.dir.disabled and e.dir.hatchable ~= false and not e.dir.isYeet and (F.eggGolden or not e.dir.isGolden) and eggUnlocked(e.id) then
            if not best or e.cost > best.cost then best = e end
        end
    end
    return best
end
local function selectedEgg()
    if type(F.selectedEgg) ~= "string" then return nil end
    for _, m in ipairs(allEggs()) do
        if m:GetAttribute("ID") == F.selectedEgg then
            local e = eggEntry(m)
            if e then
                e.locked = not eggUnlocked(e.id)
                return e
            end
        end
    end
    return nil
end
local function eggItems()
    local list = {}
    for _, m in ipairs(allEggs()) do
        local e = eggEntry(m)
        if e and not e.dir.disabled then list[#list + 1] = e end
    end
    table.sort(list, function(a, b) return a.cost < b.cost end)
    local names = {}
    for _, e in ipairs(list) do names[#names + 1] = e.id end
    return names
end
local function eggAmountFlags()
    local s = getSave()
    local ownsOct = s and s.OwnsOctupleEggs == true
    local ownsTriple = ownsPass("Triple Egg Open")
    local choice = F.eggAmount
    if choice == "8" then return false, ownsOct, ownsOct and 8 or 1 end
    if choice == "3" then return ownsTriple, false, ownsTriple and 3 or 1 end
    if choice == "1" then return false, false, 1 end
    if ownsOct then return false, true, 8 end
    if ownsTriple then return true, false, 3 end
    return false, false, 1
end
local function eggStandCFrame(model)
    local center = model:FindFirstChild("Center")
    local base = (center and center:IsA("BasePart")) and center.CFrame or model:GetPivot()
    return base * CFrame.new(0, 3, 8)
end
local nextGate
local function eggTick()
    if not (F.autoEgg or F.autoSelectedEgg) then
        state.eggTarget = nil
        return
    end
    local egg
    if F.autoSelectedEgg then
        egg = selectedEgg()
        if not egg then
            state.eggTarget = nil
            state.eggNote = F.selectedEgg and ("selected egg " .. tostring(F.selectedEgg) .. " is not in this world") or "no egg selected"
            return
        end
        if egg.locked then
            state.eggTarget = egg
            state.eggNote = egg.id .. " is still locked"
            return
        end
    else
        egg = bestEgg()
    end
    state.eggTarget = egg
    if not egg then
        state.eggNote = "no unlocked egg in this world"
        return
    end
    local have = currency(egg.currency)
    local need = egg.cost * math.max(1, F.eggPercent) / 100
    if F.eggSaveArea then
        local gate = nextGate()
        if gate and gate.currency == egg.currency then need = need + gate.cost end
    end
    if have < need then
        state.eggNote = string.format("waiting: %s / %s %s%s", shorten(have), shorten(need), egg.currency, F.eggSaveArea and " (saving for area)" or "")
        return
    end
    if not canDoAction() then
        state.eggNote = "waiting (busy)"
        return
    end
    local standCf = eggStandCFrame(egg.model)
    local origin = goNear(standCf.Position, K.EGG_REACH, F.eggTeleport)
    if origin == false then
        state.eggNote = "too far from the egg (teleport disabled)"
        return
    end
    local triple, octuple, amount = eggAmountFlags()
    state.hatchRequests += 1
    local ok, res, msg = netInvoke("Buy Egg", egg.id, triple, octuple)
    if ok and res == true then
        state.hatched += amount
        state.eggNote = string.format("bought %s x%d", egg.id, amount)
    else
        state.eggNote = "Buy Egg: " .. resultText(ok, res, msg)
    end
    goBack(origin, F.eggReturn)
end
local function installEggSkip()
    local pass = G.Directory and G.Directory.Gamepasses and G.Directory.Gamepasses["Skip Egg Open"]
    local passId = pass and pass.ID
    if passId and isfn(G.Gamepasses, "Owns") then
        local orig = G.Gamepasses.Owns
        G.Gamepasses.Owns = function(id, ...)
            if F.skipEggAnim and state.alive and id == passId then return true end
            return orig(id, ...)
        end
        restoreFns[#restoreFns + 1] = function() G.Gamepasses.Owns = orig end
    end
    local env = scriptEnv(gameScript("Game", "Open Eggs"))
    if env and type(env.OpenEgg) == "function" and type(G.Variables) == "table" then
        local orig = env.OpenEgg
        env.OpenEgg = function(...)
            if not (F.skipEggAnim and state.alive) then return orig(...) end
            local prev = G.Variables.AutoHatchEnabled
            G.Variables.AutoHatchEnabled = true
            local r = table.pack(pcall(orig, ...))
            G.Variables.AutoHatchEnabled = prev
            if not r[1] then error(r[2], 0) end
            return table.unpack(r, 2, r.n)
        end
        restoreFns[#restoreFns + 1] = function() env.OpenEgg = orig end
        log("egg skip hook installed")
    else
        logOnce("eggskip", "egg animation skip unavailable (Open Eggs script env not reachable)")
    end
end
V.deleteSynced = false
local function deleteTick()
    local s = getSave()
    if not s then return end
    if not F.autoDelete and V.deleteSynced == false then return end
    local current = type(s.AutoDelete) == "table" and s.AutoDelete or {}
    local changed = false
    for _, rarity in ipairs(K.RARITIES) do
        local want = F.autoDelete and has(F.deleteRarities, rarity)
        local cur = current[rarity] == true
        if want ~= cur then
            local ok, res, _, newValue = netInvoke("Toggle Auto Delete", rarity)
            if ok and res then
                local copy = {}
                for k, v in pairs(current) do copy[k] = v end
                copy[rarity] = newValue == nil and want or newValue
                current = copy
                s.AutoDelete = copy
                state.deletesSynced += 1
                changed = true
            else
                state.eggNote = "Toggle Auto Delete " .. rarity .. ": " .. resultText(ok, res)
            end
        end
    end
    V.deleteSynced = F.autoDelete
    if changed then state.eggNote = "auto delete synced" end
end

F.autoEquipBest = false
F.autoGolden = false
F.goldenCount = 6
F.autoRainbow = false
F.rainbowCount = 6
F.autoFuse = false
F.fuseRarities = { "Basic" }
F.fuseCount = 12
F.autoEnchant = false
F.enchantTier = nil
F.machineTeleport = true
F.machineReturn = true

K.ENCHANT_TIERS = {}
do
    local powers = G.Directory and G.Directory.Powers
    if type(powers) == "table" then
        for _, p in pairs(powers) do
            if type(p) == "table" and p.canDrop and type(p.tiers) == "table" then
                for _, t in ipairs(p.tiers) do
                    if type(t) == "table" and type(t.title) == "string" then K.ENCHANT_TIERS[#K.ENCHANT_TIERS + 1] = t.title end
                end
            end
        end
        table.sort(K.ENCHANT_TIERS)
    end
end

local function savePets()
    local s = getSave()
    return (s and type(s.Pets) == "table") and s.Pets or {}
end
local function equippedSet()
    local s = getSave()
    local set = {}
    local list = s and (isHardcore() and s.HardcorePetsEquipped or s.PetsEquipped)
    if type(list) == "table" then
        for _, uid in ipairs(list) do set[uid] = true end
    end
    for _, uid in ipairs(petUids()) do set[uid] = true end
    return set
end
local function petDir(p)
    return G.Directory and G.Directory.Pets and G.Directory.Pets[p.id] or nil
end
local function machineEligible(p, equipped, allowEquipped)
    if type(p) ~= "table" or (equipped[p.uid] and not allowEquipped) or p.l or p.dm then return false end
    local dir = petDir(p)
    if type(dir) ~= "table" then return false end
    if dir.isPremium or dir.isGift or dir.rarity == "Event" or dir.rarity == "Exclusive" then return false end
    if (p.hc or false) ~= isHardcore() then return false end
    return true
end
local function groupPets(golden)
    local groups = {}
    local equipped = equippedSet()
    for _, p in ipairs(savePets()) do
        if machineEligible(p, equipped, true) and not p.r and ((golden and p.g) or (not golden and not p.g)) then
            local key = tostring(p.id) .. "|" .. tostring(p.sh or false)
            groups[key] = groups[key] or {}
            table.insert(groups[key], p.uid)
        end
    end
    return groups
end
local function machineRows(odds)
    if isfn(G.RebornBalance, "MachineRows") then
        local rows = gval(G.RebornBalance.MachineRows, odds, isHardcore())
        if type(rows) == "table" then return rows end
    end
    return type(odds) == "table" and (isHardcore() and odds.Hardcore or odds.Normal) or nil
end
local function machineCost(normal, hardcore)
    if isfn(G.RebornBalance, "MachineCost") then
        local c = gval(G.RebornBalance.MachineCost, normal, hardcore, isHardcore())
        if type(c) == "number" then return c end
    end
    return isHardcore() and hardcore or normal
end
local function runMachine(padName, remoteName, uids, counter)
    local pad = padOf(padName)
    local origin
    if pad then
        origin = goNear(pad.Position, K.PAD_REACH, F.machineTeleport)
        if origin == false then
            state.petNote = padName .. ": too far (teleport disabled)"
            return false
        end
    end
    local ok, res, msg = netInvoke(remoteName, uids)
    if ok and res == true then
        state[counter] += 1
        state.petNote = string.format("%s: converted %d pets", remoteName, #uids)
    else
        state.petNote = remoteName .. ": " .. resultText(ok, res, msg)
    end
    goBack(origin, F.machineReturn)
    task.wait(1)
    return ok and res == true
end
local function convertTick(golden)
    local odds = G.Shared and (golden and G.Shared.GoldMachineOdds or G.Shared.RainbowMachineOdds)
    local rows = machineRows(odds)
    if type(rows) ~= "table" or #rows == 0 then
        state.petNote = "machine odds unavailable"
        return
    end
    local n = math.clamp(math.floor(golden and F.goldenCount or F.rainbowCount), 1, #rows)
    local cost = type(rows[n]) == "table" and tonumber(rows[n].cost) or nil
    if not cost then return end
    local groups = groupPets(not golden)
    local pick
    for _, uids in pairs(groups) do
        if #uids >= n and (not pick or #uids > #pick) then pick = uids end
    end
    if not pick then
        state.petNote = string.format("%s: need %d matching %spets", golden and "golden" or "rainbow", n, golden and "" or "golden ")
        return
    end
    if currency("Diamonds") < cost then
        state.petNote = string.format("%s: need %s diamonds", golden and "golden" or "rainbow", shorten(cost))
        return
    end
    local uids = {}
    for i = 1, n do uids[i] = pick[i] end
    runMachine(golden and "Gold Machine" or "Rainbow Machine", golden and "Use Golden Machine" or "Use Rainbow Machine", uids, golden and "goldens" or "rainbows")
end
local function fuseTick()
    local minPets = tonumber(G.Shared and G.Shared.FuseMinPets) or 3
    local maxPets = tonumber(G.Shared and G.Shared.FuseMaxPets) or 12
    local cost = machineCost(tonumber(G.Shared and G.Shared.FusePetsCost) or 5000, tonumber(G.Shared and G.Shared.FuseHardcoreCost) or 5000)
    local wanted = math.clamp(math.floor(F.fuseCount), minPets, maxPets)
    local equipped = equippedSet()
    local uids = {}
    for _, p in ipairs(savePets()) do
        local dir = petDir(p)
        if machineEligible(p, equipped) and dir and has(F.fuseRarities, dir.rarity) then
            uids[#uids + 1] = p.uid
            if #uids >= wanted then break end
        end
    end
    if #uids < minPets then
        state.petNote = string.format("fuse: %d/%d eligible pets", #uids, minPets)
        return
    end
    if currency("Diamonds") < cost then
        state.petNote = string.format("fuse: need %s diamonds", shorten(cost))
        return
    end
    runMachine("Fuse Pets", "Fuse Pets", uids, "fuses")
end
local function hasTier(p, title)
    if type(p) ~= "table" or type(p.powers) ~= "table" then return false end
    for _, pw in ipairs(p.powers) do
        local power = type(pw) == "table" and G.Directory.Powers[pw[1]]
        local tier = power and type(power.tiers) == "table" and power.tiers[pw[2]]
        if type(tier) == "table" and tier.title == title then return true end
    end
    return false
end
local function enchantTick()
    if type(F.enchantTier) ~= "string" then
        state.petNote = "enchant: pick a target enchant"
        return
    end
    local equipped = equippedSet()
    local baseCost = machineCost(tonumber(G.Shared and G.Shared.EnchantCost) or 10000, tonumber(G.Shared and G.Shared.EnchantHardcoreCost) or 10000)
    if masteryLevel("Enchanting") >= 99 then baseCost = math.round(baseCost * 0.75) end
    for _, p in ipairs(savePets()) do
        if equipped[p.uid] and not hasTier(p, F.enchantTier) then
            if currency("Diamonds") < baseCost then
                state.petNote = string.format("enchant: need %s diamonds", shorten(baseCost))
                return
            end
            local ok, res, msg = netInvoke("Enchant Pets", { p.uid }, true, { F.enchantTier })
            if ok and res == true then
                state.enchants += 1
                state.petNote = "enchanted " .. tostring(p.nk or p.id) .. " (rolling for " .. F.enchantTier .. ")"
            else
                state.petNote = "Enchant Pets: " .. resultText(ok, res, msg)
            end
            return
        end
    end
    state.petNote = "enchant: every equipped pet has " .. F.enchantTier
end
local function equipTick()
    if not F.autoEquipBest then return end
    if isfn(G.PetCmds, "HasBestEquipped") and gval(G.PetCmds.HasBestEquipped) == true then return end
    local ok, res, msg = netInvoke("Equip Best Pets")
    if ok and res == true then
        state.equips += 1
        state.petNote = "equipped best pets"
    else
        state.petNote = "Equip Best Pets: " .. resultText(ok, res, msg)
    end
end
local function petTick()
    if F.autoGolden then convertTick(true) end
    if F.autoRainbow then convertTick(false) end
    if F.autoFuse then fuseTick() end
    if F.autoEnchant then enchantTick() end
end

F.autoArea = false
F.areaTeleport = true
F.areaReturn = true
F.autoTeleports = false
F.autoUpgrades = false
F.upgradeNames = {}
F.autoUseBoosts = false
F.boostNames = {}
F.boostMinLeft = 60

K.UPGRADE_LIST = {}
do
    local ups = G.Directory and G.Directory.Upgrades
    if type(ups) == "table" then
        for name, u in pairs(ups) do
            if type(u) == "table" and not (u.isHalloweenEvent or u.isLuckyBlockEvent or u.isYeetEvent) then
                local open = true
                if u.rebornFlag and isfn(G.FFlags, "Get") and type(G.FFlags.Keys) == "table" then
                    open = gval(G.FFlags.Get, G.FFlags.Keys[u.rebornFlag]) ~= false
                end
                if open then K.UPGRADE_LIST[#K.UPGRADE_LIST + 1] = name end
            end
        end
        table.sort(K.UPGRADE_LIST)
    end
end
K.BOOST_LIST = {}
do
    pcall(function()
        for _, c in ipairs(G.Library.GUI.ExclusiveShop.Container.Boosts:GetChildren()) do
            local b = c:GetAttribute("Boost")
            if type(b) == "string" then K.BOOST_LIST[#K.BOOST_LIST + 1] = b end
        end
    end)
    if #K.BOOST_LIST == 0 then
        for _, b in ipairs(K.BOOST_FALLBACK) do K.BOOST_LIST[#K.BOOST_LIST + 1] = b end
    end
    table.sort(K.BOOST_LIST)
end

local function allGates()
    if isfn(G.WorldCmds, "GetAllGates") then
        local list = gval(G.WorldCmds.GetAllGates)
        if type(list) == "table" then return list end
    end
    return {}
end
nextGate = function()
    local best
    for _, gate in ipairs(allGates()) do
        local name = gate.Name
        local area = G.Directory and G.Directory.Areas and G.Directory.Areas[name]
        local g = type(area) == "table" and type(area.gate) == "table" and area.gate or nil
        if g and type(g.cost) == "number" and not area.hideGatePurchase and not hasArea(name) and areaOpen(name) then
            local part = gate:FindFirstChildWhichIsA("BasePart")
            if part and (not best or g.cost < best.cost) then
                best = { gate = gate, part = part, name = name, cost = g.cost, currency = g.currency or "Coins" }
            end
        end
    end
    return best
end
local function areaTick()
    if not F.autoArea then
        state.areaTarget = nil
        return
    end
    local gate = nextGate()
    state.areaTarget = gate
    if not gate then
        state.areaNote = "every gate in this world is unlocked"
        return
    end
    local have = currency(gate.currency)
    if have < gate.cost then
        state.areaNote = string.format("saving for %s: %s / %s %s", gate.name, shorten(have), shorten(gate.cost), gate.currency)
        return
    end
    if not canDoAction() then
        state.areaNote = "waiting (busy)"
        return
    end
    local standCf = gate.part.CFrame * CFrame.new(0, 0, 12)
    local origin = goNear(standCf.Position, K.GATE_REACH, F.areaTeleport)
    if origin == false then
        state.areaNote = "too far from the gate (teleport disabled)"
        return
    end
    local ok, res, msg = netInvoke("Buy Area", gate.name)
    if ok and res == true then
        state.areasBought += 1
        state.areaNote = "bought " .. gate.name
        notify("PSX Classic", "Unlocked " .. gate.name, 5)
    else
        state.areaNote = "Buy Area: " .. resultText(ok, res, msg)
    end
    goBack(origin, F.areaReturn)
end
F.autoBestArea = false
V.bestAreaLast = nil
V.bestAreaAt = 0
local function areaScore(area)
    local mult = tonumber(area.mult) or 0
    local gate = type(area.gate) == "table" and tonumber(area.gate.cost) or 0
    return mult * 1e12 + gate
end
local function areaLanding(folder, name)
    local map = worldMap()
    local pads = map and map:FindFirstChild("Teleports")
    local pad = pads and pads:FindFirstChild(name)
    if pad and pad:IsA("BasePart") then return pad.CFrame, pad end
    local ground
    for _, d in ipairs(folder:GetDescendants()) do
        if d:IsA("BasePart") and d.CanCollide and (not ground or d.Size.X * d.Size.Z > ground.Size.X * ground.Size.Z) then ground = d end
    end
    if ground then return CFrame.new(ground.Position + Vector3.new(0, ground.Size.Y / 2, 0)), ground end
    local ok, cf = pcall(function() return CFrame.new(folder:GetPivot().Position) end)
    return ok and cf or nil, nil
end
local function scanAreas()
    local map = worldMap()
    local folder = map and map:FindFirstChild("Areas")
    if not folder then return {} end
    local list = {}
    for _, child in ipairs(folder:GetChildren()) do
        local name = child.Name
        local area = G.Directory and G.Directory.Areas and G.Directory.Areas[name]
        if type(area) == "table" and not area.isShop and not area.hidden then
            local unlocked = hasArea(name) and areaOpen(name)
            list[#list + 1] = { name = name, folder = child, area = area, unlocked = unlocked, score = areaScore(area), mult = area.mult }
        end
    end
    table.sort(list, function(a, b) return a.score > b.score end)
    return list
end
local function bestArea()
    for _, entry in ipairs(scanAreas()) do
        if entry.unlocked then
            local cf, part = areaLanding(entry.folder, entry.name)
            if cf then
                entry.cframe, entry.part = cf, part
                return entry
            end
        end
    end
    return nil
end
local function teleportToArea(target)
    local c = LocalPlayer.Character
    local r = hrp()
    local hum = c and c:FindFirstChildOfClass("Humanoid")
    if not (c and r and hum and target and target.cframe) then return false end
    if not canDoAction() then return false end
    teleportTo(target.cframe + target.cframe.UpVector * (hum.HipHeight + r.Size.Y / 2))
    if target.part and target.part.Parent and target.part.Parent.Name == "Teleports" and isfn(G.WorldCmds, "HasTeleport") and gval(G.WorldCmds.HasTeleport, target.name) == true then
        netFire("Performed Teleport", target.name)
    end
    if V.farmTarget then
        releasePets(V.farmPets, V.farmTarget:GetAttribute("ID") or V.farmTarget.Name)
        V.farmTarget = nil
    end
    return true
end
local function bestAreaTick()
    if not F.autoBestArea then
        V.bestAreaLast = nil
        return
    end
    local best = bestArea()
    if not best then
        state.areaNote = "best area: none unlocked in this world"
        return
    end
    if best.name == V.bestAreaLast then return end
    if os.clock() - V.bestAreaAt < 5 then return end
    if teleportToArea(best) then
        V.bestAreaLast = best.name
        V.bestAreaAt = os.clock()
        state.areaNote = "teleported to best area " .. best.name
        notify("PSX Classic", "Teleported to " .. best.name, 4)
    end
end
local function nextTeleport()
    if ownsPass("Teleport") then return nil, "Teleport gamepass owned" end
    if not isfn(G.WorldCmds, "HasTeleport") then return nil, "HasTeleport unavailable" end
    local best
    for name, area in pairs(G.Directory.Areas or {}) do
        if type(area) == "table" and type(area.teleportPrice) == "number" and area.teleportPrice > 0 and not area.hidden and hasArea(name) and areaOpen(name) then
            local owned = gval(G.WorldCmds.HasTeleport, name)
            if owned == false and (not best or area.teleportPrice < best.cost) then
                best = { name = name, cost = area.teleportPrice }
            end
        end
    end
    return best
end
local function teleportTick()
    if not F.autoTeleports then return end
    local tp, why = nextTeleport()
    if not tp then
        state.progressNote = "teleports: " .. (why or "every unlocked area has its teleport")
        return
    end
    if currency("Diamonds") < tp.cost then
        state.progressNote = string.format("teleports: saving for %s (%s / %s diamonds)", tp.name, shorten(currency("Diamonds")), shorten(tp.cost))
        return
    end
    local ok, res, msg = netInvoke("Buy Teleport Area", tp.name)
    if ok and res == true then
        state.teleportsBought += 1
        state.progressNote = "bought teleport to " .. tp.name
    else
        state.progressNote = "Buy Teleport Area: " .. resultText(ok, res, msg)
    end
end
local function nextUpgrade()
    local s = getSave()
    local levels = s and type(s.Upgrades) == "table" and s.Upgrades or {}
    local best
    for _, name in ipairs(F.upgradeNames) do
        local u = G.Directory.Upgrades and G.Directory.Upgrades[name]
        if type(u) == "table" and type(u.prices) == "table" then
            local lvl = tonumber(levels[name]) or 0
            local price = u.prices[lvl + 1]
            if type(price) == "number" and (not best or price < best.price) then
                best = { name = name, price = price, currency = u.currency or "Diamonds", level = lvl, max = #u.prices }
            end
        end
    end
    return best
end
local function upgradeTick()
    if not F.autoUpgrades then return end
    local up = nextUpgrade()
    if not up then
        state.progressNote = #F.upgradeNames == 0 and "upgrades: none selected" or "upgrades: selected upgrades are maxed"
        return
    end
    if currency(up.currency) < up.price then
        state.progressNote = string.format("upgrades: saving for %s %d/%d (%s / %s %s)", up.name, up.level + 1, up.max, shorten(currency(up.currency)), shorten(up.price), up.currency)
        return
    end
    if not canDoAction() then return end
    local pad = padOf("Upgrade Station")
    local origin
    if pad then
        origin = goNear(pad.Position, K.PAD_REACH, F.machineTeleport)
        if origin == false then
            state.progressNote = "upgrades: too far from the Upgrade Station (teleport disabled)"
            return
        end
    end
    local ok, res, msg = netInvoke("Buy Upgrade", up.name)
    if ok and res == true then
        state.upgradesBought += 1
        state.progressNote = string.format("bought %s level %d", up.name, up.level + 1)
    else
        state.progressNote = "Buy Upgrade: " .. resultText(ok, res, msg)
    end
    goBack(origin, F.machineReturn)
end
local function boostTick()
    if not F.autoUseBoosts then return end
    local s = getSave()
    if not s then return end
    local inv = type(s.BoostsInventory) == "table" and s.BoostsInventory or {}
    local active = type(s.Boosts) == "table" and s.Boosts or {}
    for _, name in ipairs(F.boostNames) do
        local count = tonumber(inv[name]) or 0
        local left = tonumber(active[name]) or 0
        if count > 0 and left <= F.boostMinLeft then
            local ok, err = netFire("Activate Boost", name)
            if ok then
                state.boostsUsed += 1
                state.progressNote = "used " .. name .. " boost"
            else
                state.progressNote = "Activate Boost: " .. tostring(err)
            end
            return
        end
    end
end

F.autoRank = false
F.autoVip = false
F.autoReturn = false
F.returnMinutes = 60
V.rankRetryAt = 0
V.vipRetryAt = 0
V.returnStartedAt = os.clock()
V.returned = false

local function rankState()
    local s = getSave()
    local rank = s and G.Directory.Ranks and G.Directory.Ranks[s.Rank]
    if not (s and type(rank) == "table") then return nil end
    local rewards = type(rank.rewards) == "table" and #rank.rewards or 0
    local cooldown = tonumber(rank.rewardCooldown) or 0
    local left = cooldown - (osTime() - (tonumber(s.RankTimer) or 0))
    return { name = s.Rank, rewards = rewards, left = left, cooldown = cooldown }
end
local function rankTick()
    if not F.autoRank then return end
    if os.clock() < V.rankRetryAt then return end
    local r = rankState()
    if not r then return end
    if r.rewards == 0 then
        state.rewardNote = "rank " .. tostring(r.name) .. " has no rewards yet"
        return
    end
    if r.left > 0 then
        state.rewardNote = string.format("rank rewards in %dm %02ds", math.floor(r.left / 60), math.floor(r.left % 60))
        return
    end
    local pad = padOf("Rank Rewards")
    local origin = pad and goNear(pad.Position, K.PAD_REACH, true) or nil
    local ok, res, msg = netInvoke("Redeem Rank Rewards")
    if ok and res then
        state.rankRedeems += 1
        state.rewardNote = "rank rewards redeemed"
        notify("PSX Classic", "Rank rewards redeemed", 5)
    else
        state.rewardNote = "Redeem Rank Rewards: " .. resultText(ok, res, msg)
        V.rankRetryAt = os.clock() + 300
    end
    goBack(origin, true)
end
local function vipTick()
    if not F.autoVip then return end
    if os.clock() < V.vipRetryAt then return end
    if not ownsPass("VIP") then
        state.rewardNote = "VIP rewards need the VIP gamepass"
        return
    end
    local s = getSave()
    local left = K.VIP_COOLDOWN - (osTime() - (tonumber(s and s.VIPCooldown) or 0))
    if left > 0 then
        state.rewardNote = string.format("VIP rewards in %dm %02ds", math.floor(left / 60), math.floor(left % 60))
        return
    end
    local pad = padOf("VIP Rewards")
    local origin = pad and goNear(pad.Position, K.PAD_REACH, true) or nil
    local ok, res, msg = netInvoke("Redeem VIP Rewards")
    if ok and res then
        state.vipRedeems += 1
        state.rewardNote = "VIP rewards redeemed"
    else
        state.rewardNote = "Redeem VIP Rewards: " .. resultText(ok, res, msg)
        V.vipRetryAt = os.clock() + 300
    end
    goBack(origin, true)
end
local function returnToPS99()
    local ok, res, msg = netInvoke("Back To PS99")
    if ok and res == true then
        V.returned = true
        state.rewardNote = "returning to Pet Simulator 99"
        notify("PSX Classic", "Returning to Pet Simulator 99", 6)
    else
        state.rewardNote = "Back To PS99: " .. resultText(ok, res, msg)
    end
    return ok and res == true
end
local function returnTick()
    if not F.autoReturn or V.returned then return end
    local elapsed = os.clock() - V.returnStartedAt
    local total = math.max(1, F.returnMinutes) * 60
    if elapsed < total then return end
    if returnToPS99() then F.autoReturn = false end
end

F.webhookEnabled = false
F.webhookUrl = ""
F.webhookKeywords = { "huge", "titanic" }
F.webhookTest = true
V.webhookSeen = nil
state.webhooksSent = 0
state.webhookNote = nil
local HttpService = game:GetService("HttpService")

local function httpRequestFn()
    if type(request) == "function" then return request end
    if type(http_request) == "function" then return http_request end
    if type(http) == "table" and type(http.request) == "function" then return http.request end
    if type(syn) == "table" and type(syn.request) == "function" then return syn.request end
    return nil
end
local function webhookPost(payload)
    local fn = httpRequestFn()
    if not fn then
        state.webhookNote = "executor has no HTTP request function"
        return false
    end
    if type(F.webhookUrl) ~= "string" or not F.webhookUrl:find("^https://") then
        state.webhookNote = "set a Discord webhook URL first"
        return false
    end
    local ok, res = pcall(fn, { Url = F.webhookUrl, Method = "POST", Headers = { ["Content-Type"] = "application/json" }, Body = HttpService:JSONEncode(payload) })
    if not ok then
        state.webhookNote = "webhook request failed: " .. tostring(res)
        return false
    end
    local code = type(res) == "table" and tonumber(res.StatusCode) or nil
    if code and code >= 400 then
        state.webhookNote = "Discord returned status " .. tostring(code) .. " (check the URL)"
        return false
    end
    state.webhooksSent += 1
    state.webhookNote = "sent " .. os.date("%H:%M:%S")
    return true
end
local function petIconUrl(thumb)
    local fn = httpRequestFn()
    local assetId = type(thumb) == "string" and thumb:match("%d+") or nil
    if not (fn and assetId) then return nil end
    local api = string.format("https://thumbnails.roblox.com/v1/assets?assetIds=%s&size=420x420&format=Png&isCircular=false", assetId)
    for _ = 1, 3 do
        local ok, res = pcall(fn, { Url = api, Method = "GET" })
        if ok and type(res) == "table" and type(res.Body) == "string" then
            local okJ, json = pcall(HttpService.JSONDecode, HttpService, res.Body)
            local entry = okJ and type(json) == "table" and type(json.data) == "table" and json.data[1] or nil
            if type(entry) == "table" and entry.state == "Completed" and type(entry.imageUrl) == "string" then return entry.imageUrl end
        end
        task.wait(1)
    end
    return nil
end
local function petDisplayName(p)
    local dir = petDir(p)
    local base = (type(dir) == "table" and dir.name) or tostring(p.id)
    local prefix = ""
    if p.sh then prefix = prefix .. "Shiny " end
    if p.dm then prefix = prefix .. "Dark Matter " elseif p.r then prefix = prefix .. "Rainbow " elseif p.g then prefix = prefix .. "Golden " end
    return prefix .. base
end
local function webhookMatches(name)
    local lower = string.lower(name)
    for _, word in ipairs(F.webhookKeywords) do
        if word ~= "" and string.find(lower, word, 1, true) then return true end
    end
    return false
end
local function setWebhookKeywords(text)
    local list = {}
    for word in string.gmatch(tostring(text or ""), "[^,]+") do
        local w = string.lower(word):gsub("^%s+", ""):gsub("%s+$", "")
        if w ~= "" then list[#list + 1] = w end
    end
    F.webhookKeywords = list
end
local function sendPetWebhook(name, p)
    local lower = string.lower(name)
    local title, color = "🐾 PET OBTAINED!", 0x3498DB
    if string.find(lower, "gargantuan", 1, true) then
        title, color = "👑 GARGANTUAN OBTAINED!", 0x9B30FF
    elseif string.find(lower, "titanic", 1, true) then
        title, color = "🌟 TITANIC OBTAINED!", 0xFF0055
    elseif string.find(lower, "huge", 1, true) then
        title, color = "🎉 HUGE OBTAINED!", 0xFFD000
    end
    local dir = petDir(p)
    local thumb = type(dir) == "table" and ((p.g and dir.goldenThumbnail) or (p.dm and dir.darkMatterThumbnail) or dir.thumbnail) or nil
    local payload = {
        username = "VY HUB Notifier",
        embeds = { {
            title = title,
            description = string.format("**%s** just hatched a **%s** with VY HUB!", LocalPlayer.Name, name),
            author = { name = "VY HUB" },
            timestamp = os.date("!%Y-%m-%dT%H:%M:%SZ"),
            color = color,
            fields = {
                { name = "Pet", value = name, inline = true },
                { name = "Game", value = "Pet Simulator X Classic", inline = true },
                { name = "Hatched At", value = os.date("%H:%M:%S") .. " (local time)", inline = true },
                { name = "World", value = tostring(currentWorld()), inline = true },
            },
            footer = { text = "VY HUB Notifier | " .. os.date("%Y-%m-%d %H:%M:%S") },
        } },
    }
    local icon = petIconUrl(thumb)
    if icon then payload.embeds[1].thumbnail = { url = icon } end
    webhookPost(payload)
end
local function sendTestWebhook()
    return webhookPost({ username = "VY HUB Notifier", content = string.format("✅ VY HUB PSX Classic notifier started for **%s** (watching: %s)", LocalPlayer.Name, table.concat(F.webhookKeywords, ", ")) })
end
local function webhookTick()
    if not F.webhookEnabled then
        V.webhookSeen = nil
        return
    end
    local pets = savePets()
    if type(V.webhookSeen) ~= "table" then
        local seen = {}
        for _, p in ipairs(pets) do
            if type(p) == "table" and p.uid then seen[p.uid] = true end
        end
        V.webhookSeen = seen
        state.webhookNote = string.format("watching %d pets for: %s", #pets, table.concat(F.webhookKeywords, ", "))
        return
    end
    local alive = {}
    for _, p in ipairs(pets) do
        if type(p) == "table" and p.uid then
            alive[p.uid] = true
            if not V.webhookSeen[p.uid] then
                V.webhookSeen[p.uid] = true
                local name = petDisplayName(p)
                log("new pet: %s", name)
                if webhookMatches(name) then task.spawn(sendPetWebhook, name, p) end
            end
        end
    end
    for uid in pairs(V.webhookSeen) do
        if not alive[uid] then V.webhookSeen[uid] = nil end
    end
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

loop("orbs", 0.25, orbTick)
loop("loot", 1, lootTick)
loop("farm", 1, farmTick)
loop("egg", function() return math.max(0.3, F.eggDelay) end, eggTick)
loop("delete", 5, deleteTick)
loop("equip", 10, equipTick)
loop("pets", 4, petTick)
loop("area", 2, areaTick)
loop("teleports", 5, teleportTick)
loop("upgrades", 3, upgradeTick)
loop("boosts", 5, boostTick)
loop("rank", 15, rankTick)
loop("vip", 30, vipTick)
loop("return", 10, returnTick)
loop("bestArea", 3, bestAreaTick)
loop("webhook", 2, webhookTick)

if type(Library.ExecutorSettings) ~= "table" or type(Library.ExecutorSettings.MenuKeybind) ~= "string" or Library.ExecutorSettings.MenuKeybind == "" then
    pcall(function() Library:SetMenuKeybind(Enum.KeyCode.RightShift) end)
end

local isMobile = false
pcall(function() isMobile = Library:IsMobileClient() end)

UI.Window = Library:CreateWindow({
    Name = "VY HUB",
    SubName = "PSX Classic",
    Logo = "egg",
    ToggleButtonEnabled = isMobile,
    KeybindListEnabled = false,
    SettingsTabEnabled = true,
    WatermarkEnabled = true,
    WatermarkText = "VY HUB | PSX Classic",
    Theme = "Onyx",
})

local function tab(name, icon)
    return UI.Window:AddTab({ Name = name, Icon = icon })
end
local function section(t, name)
    return t:AddSection({ Name = name })
end
local function num(v, fallback)
    local n = tonumber(v)
    if n == nil or n ~= n then return fallback end
    return n
end

UI.MainTab = tab("Main", "egg")
UI.StatusSec = section(UI.MainTab, "Status")
UI.lblStatus = UI.StatusSec:AddLabel("Status: starting")
UI.lblMoney = UI.StatusSec:AddLabel("Coins: - | Diamonds: -")
UI.lblWorld = UI.StatusSec:AddLabel("World: -")
UI.lblCounters = UI.StatusSec:AddLabel("Orbs: 0 | Coins broken: 0 | Eggs: 0 | Areas: 0")
UI.RewardSec = section(UI.MainTab, "Rewards")
UI.RewardSec:AddToggle({ Name = "Auto Redeem Rank Rewards", Default = false, Flag = "px_autoRank", Callback = function(v) F.autoRank = v V.rankRetryAt = 0 end })
UI.RewardSec:AddToggle({ Name = "Auto Redeem VIP Rewards", Default = false, Flag = "px_autoVip", Callback = function(v) F.autoVip = v V.vipRetryAt = 0 end })
UI.lblRewards = UI.RewardSec:AddLabel("Rewards: -")
UI.ReturnSec = section(UI.MainTab, "Pet Simulator 99")
UI.ReturnSec:AddToggle({ Name = "Auto Return To Pet Simulator 99", Default = false, Flag = "px_autoReturn", Callback = function(v) F.autoReturn = v V.returnStartedAt = os.clock() V.returned = false end })
UI.ReturnSec:AddSlider({ Name = "Return After", Min = 5, Max = 240, Default = 60, Decimals = 5, Suffix = " min", Flag = "px_returnMinutes", Callback = function(v) F.returnMinutes = math.clamp(num(v, F.returnMinutes), 5, 240) end })
UI.ReturnSec:AddButton({ Name = "Return To Pet Simulator 99 Now", Callback = function() task.spawn(returnToPS99) end })
UI.lblReturn = UI.ReturnSec:AddLabel("Return: -")

UI.FarmTab = tab("Farm", "coins")
UI.FarmSec = section(UI.FarmTab, "Auto Farm")
UI.FarmSec:AddToggle({ Name = "Auto Farm Coins (Tap Once, Pets Farm)", Default = false, Flag = "px_autoFarm", Callback = function(v) F.autoFarm = v V.farmTarget = nil end })
UI.FarmSec:AddDropdown({ Name = "Target", Items = K.FARM_MODES, Default = F.farmMode, Flag = "px_farmMode", Callback = function(v)
    if type(v) == "string" then F.farmMode = v V.farmTarget = nil end
end })
UI.FarmSec:AddSlider({ Name = "Breakable Range", Min = 30, Max = K.COIN_REACH_MAX, Default = F.farmRange, Decimals = 10, Suffix = " studs", Flag = "px_farmRange", Callback = function(v) F.farmRange = math.clamp(num(v, F.farmRange), 30, K.COIN_REACH_MAX) end })
UI.lblFarm = UI.FarmSec:AddLabel("Target: -")
UI.GiantSec = section(UI.FarmTab, "Giant Chests")
UI.GiantSec:AddToggle({ Name = "Auto Break Selected Giant Chests", Default = false, Flag = "px_autoGiant", Callback = function(v) F.autoGiant = v end })
UI.GiantSec:AddDropdown({ Name = "Giant Chests", Items = K.GIANT_LIST, Multi = true, Flag = "px_giantNames", Callback = function(v) F.giantNames = listOf(v) end })
UI.GiantSec:AddToggle({ Name = "Teleport To The Giant Chest", Default = true, Flag = "px_giantTeleport", Callback = function(v) F.giantTeleport = v end })
UI.lblGiant = UI.GiantSec:AddLabel("Giant chests broken: 0")
UI.CollectSec = section(UI.FarmTab, "Collect")
UI.CollectSec:AddToggle({ Name = "Auto Collect Orbs (Instant)", Default = false, Flag = "px_autoOrbs", Callback = function(v) F.autoOrbs = v if v then sweepOrbs() end end })
UI.CollectSec:AddToggle({ Name = "Remove Ghost Orbs", Default = true, Flag = "px_ghostOrbs", Callback = function(v) F.ghostOrbs = v end })
UI.CollectSec:AddToggle({ Name = "Auto Collect Lootbags", Default = false, Flag = "px_autoLootbags", Callback = function(v) F.autoLootbags = v end })
UI.lblCollect = UI.CollectSec:AddLabel("Orbs: 0 | Lootbags: 0")

UI.EggTab = tab("Eggs", "egg-fried")
UI.EggSec = section(UI.EggTab, "Auto Hatch")
UI.lblEgg = UI.EggSec:AddLabel("Best egg: -")
UI.EggSec:AddToggle({ Name = "Auto Buy Best Unlocked Egg", Default = false, Flag = "px_autoEgg", Callback = function(v) F.autoEgg = v end })
UI.EggSec:AddToggle({ Name = "Auto Buy Selected Egg", Default = false, Flag = "px_autoSelectedEgg", Callback = function(v) F.autoSelectedEgg = v end })
UI.ddEgg = UI.EggSec:AddDropdown({ Name = "Selected Egg", Items = eggItems(), Flag = "px_selectedEgg", Callback = function(v)
    if type(v) == "string" then F.selectedEgg = v end
end })
UI.EggSec:AddButton({ Name = "Refresh Egg List", Callback = function()
    pcall(function() UI.ddEgg:Refresh(eggItems()) end)
end })
UI.EggSec:AddSlider({ Name = "Buy When Money Is Above X% Of Price", Min = 100, Max = 1000, Default = 100, Decimals = 5, Suffix = "%", Flag = "px_eggPercent", Callback = function(v) F.eggPercent = math.clamp(num(v, F.eggPercent), 100, 1000) end })
UI.EggSec:AddToggle({ Name = "Save Money For Area Unlock", Default = false, Flag = "px_eggSaveArea", Callback = function(v) F.eggSaveArea = v end })
UI.EggSec:AddDropdown({ Name = "Eggs Per Buy", Items = K.EGG_AMOUNTS, Default = F.eggAmount, Flag = "px_eggAmount", Callback = function(v)
    if type(v) == "string" then F.eggAmount = v end
end })
UI.EggSec:AddSlider({ Name = "Buy Delay", Min = 0.3, Max = 5, Default = 1, Decimals = 0.1, Suffix = "s", Flag = "px_eggDelay", Callback = function(v) F.eggDelay = math.clamp(num(v, F.eggDelay), 0.3, 5) end })
UI.EggSec:AddToggle({ Name = "Prefer Golden Eggs", Default = false, Flag = "px_eggGolden", Callback = function(v) F.eggGolden = v end })
UI.EggSec:AddToggle({ Name = "Teleport To The Egg When Buying", Default = true, Flag = "px_eggTeleport", Callback = function(v) F.eggTeleport = v end })
UI.EggSec:AddToggle({ Name = "Return After Buying", Default = true, Flag = "px_eggReturn", Callback = function(v) F.eggReturn = v end })
UI.lblEggNote = UI.EggSec:AddLabel("Eggs: -")
UI.HatchSec = section(UI.EggTab, "Hatching")
UI.HatchSec:AddToggle({ Name = "Skip Egg Opening Animation", Default = false, Flag = "px_skipEggAnim", Callback = function(v) F.skipEggAnim = v end })
UI.DeleteSec = section(UI.EggTab, "Auto Delete")
UI.DeleteSec:AddToggle({ Name = "Auto Delete Selected Rarities", Default = false, Flag = "px_autoDelete", Callback = function(v) F.autoDelete = v end })
UI.DeleteSec:AddDropdown({ Name = "Rarities To Delete", Items = K.RARITIES, Multi = true, Flag = "px_deleteRarities", Callback = function(v) F.deleteRarities = listOf(v) end })
UI.lblDelete = UI.DeleteSec:AddLabel("Auto delete: -")

UI.PetTab = tab("Pets", "paw-print")
UI.EquipSec = section(UI.PetTab, "Equip")
UI.EquipSec:AddToggle({ Name = "Auto Equip Best Pets", Default = false, Flag = "px_autoEquipBest", Callback = function(v) F.autoEquipBest = v end })
UI.GoldSec = section(UI.PetTab, "Machines")
UI.GoldSec:AddToggle({ Name = "Auto Make Golden Pets", Default = false, Flag = "px_autoGolden", Callback = function(v) F.autoGolden = v end })
UI.GoldSec:AddSlider({ Name = "Pets Per Golden Attempt", Min = 1, Max = 6, Default = 6, Decimals = 1, Flag = "px_goldenCount", Callback = function(v) F.goldenCount = math.clamp(num(v, F.goldenCount), 1, 6) end })
UI.GoldSec:AddToggle({ Name = "Auto Make Rainbow Pets", Default = false, Flag = "px_autoRainbow", Callback = function(v) F.autoRainbow = v end })
UI.GoldSec:AddSlider({ Name = "Pets Per Rainbow Attempt", Min = 1, Max = 6, Default = 6, Decimals = 1, Flag = "px_rainbowCount", Callback = function(v) F.rainbowCount = math.clamp(num(v, F.rainbowCount), 1, 6) end })
UI.GoldSec:AddToggle({ Name = "Auto Fuse Pets", Default = false, Flag = "px_autoFuse", Callback = function(v) F.autoFuse = v end })
UI.GoldSec:AddDropdown({ Name = "Fuse Rarities", Items = K.RARITIES, Default = F.fuseRarities, Multi = true, Flag = "px_fuseRarities", Callback = function(v) F.fuseRarities = listOf(v) end })
UI.GoldSec:AddSlider({ Name = "Pets Per Fuse", Min = 3, Max = 12, Default = 12, Decimals = 1, Flag = "px_fuseCount", Callback = function(v) F.fuseCount = math.clamp(num(v, F.fuseCount), 3, 12) end })
UI.GoldSec:AddToggle({ Name = "Auto Enchant Equipped Pets", Default = false, Flag = "px_autoEnchant", Callback = function(v) F.autoEnchant = v end })
UI.GoldSec:AddDropdown({ Name = "Target Enchant", Items = K.ENCHANT_TIERS, Flag = "px_enchantTier", Callback = function(v)
    if type(v) == "string" then F.enchantTier = v end
end })
UI.GoldSec:AddToggle({ Name = "Teleport To The Machine", Default = true, Flag = "px_machineTeleport", Callback = function(v) F.machineTeleport = v end })
UI.GoldSec:AddToggle({ Name = "Return After Using It", Default = true, Flag = "px_machineReturn", Callback = function(v) F.machineReturn = v end })
UI.lblPets = UI.GoldSec:AddLabel("Pets: -")

UI.ProgTab = tab("Progression", "map")
UI.AreaSec = section(UI.ProgTab, "Areas")
UI.lblArea = UI.AreaSec:AddLabel("Next area: -")
UI.AreaSec:AddToggle({ Name = "Auto Unlock Next Area", Default = false, Flag = "px_autoArea", Callback = function(v) F.autoArea = v end })
UI.AreaSec:AddToggle({ Name = "Teleport To The Gate When Buying", Default = true, Flag = "px_areaTeleport", Callback = function(v) F.areaTeleport = v end })
UI.AreaSec:AddToggle({ Name = "Return After Buying", Default = true, Flag = "px_areaReturn", Callback = function(v) F.areaReturn = v end })
UI.AreaSec:AddToggle({ Name = "Auto Buy Area Teleports", Default = false, Flag = "px_autoTeleports", Callback = function(v) F.autoTeleports = v end })
UI.AreaSec:AddToggle({ Name = "Auto Teleport To Best Area", Default = false, Flag = "px_autoBestArea", Callback = function(v) F.autoBestArea = v V.bestAreaLast = nil end })
UI.AreaSec:AddButton({ Name = "Teleport To Best Area Now", Callback = function()
    task.spawn(function()
        local best = bestArea()
        if best and teleportToArea(best) then V.bestAreaLast = best.name V.bestAreaAt = os.clock() state.areaNote = "teleported to " .. best.name end
    end)
end })
UI.lblBestArea = UI.AreaSec:AddLabel("Best area: -")
UI.lblAreaNote = UI.AreaSec:AddLabel("Areas: -")
UI.UpSec = section(UI.ProgTab, "Upgrades")
UI.UpSec:AddToggle({ Name = "Auto Buy Selected Upgrades", Default = false, Flag = "px_autoUpgrades", Callback = function(v) F.autoUpgrades = v end })
UI.UpSec:AddDropdown({ Name = "Upgrades", Items = K.UPGRADE_LIST, Multi = true, Flag = "px_upgradeNames", Callback = function(v) F.upgradeNames = listOf(v) end })
UI.BoostSec = section(UI.ProgTab, "Boosts")
UI.BoostSec:AddToggle({ Name = "Auto Use Selected Boosts", Default = false, Flag = "px_autoUseBoosts", Callback = function(v) F.autoUseBoosts = v end })
UI.BoostSec:AddDropdown({ Name = "Boosts", Items = K.BOOST_LIST, Multi = true, Flag = "px_boostNames", Callback = function(v) F.boostNames = listOf(v) end })
UI.BoostSec:AddSlider({ Name = "Re-use When Less Than", Min = 0, Max = 600, Default = 60, Decimals = 10, Suffix = "s left", Flag = "px_boostMinLeft", Callback = function(v) F.boostMinLeft = math.clamp(num(v, F.boostMinLeft), 0, 600) end })
UI.lblProgress = UI.BoostSec:AddLabel("Progression: -")

UI.MiscTab = tab("Misc", "settings-2")
UI.PatchSec = section(UI.MiscTab, "Patches")
UI.PatchSec:AddToggle({ Name = "Anti AFK", Default = true, Flag = "px_antiAfk", Callback = function(v) F.antiAfk = v end })
UI.HookSec = section(UI.MiscTab, "Discord Webhook")
UI.HookSec:AddTextbox({ Name = "Webhook URL", Placeholder = "https://discord.com/api/webhooks/...", Finished = true, Flag = "px_webhookUrl", Callback = function(v)
    F.webhookUrl = type(v) == "string" and v:gsub("^%s+", ""):gsub("%s+$", "") or ""
end })
UI.HookSec:AddTextbox({ Name = "Pet Keywords (comma separated)", Default = "huge, titanic", Finished = true, Flag = "px_webhookKeywords", Callback = function(v) setWebhookKeywords(v) end })
UI.HookSec:AddToggle({ Name = "Webhook Notifications", Default = false, Flag = "px_webhookEnabled", Callback = function(v)
    F.webhookEnabled = v
    V.webhookSeen = nil
    if v and F.webhookTest then task.spawn(sendTestWebhook) end
end })
UI.HookSec:AddToggle({ Name = "Send Test Message When Enabled", Default = true, Flag = "px_webhookTest", Callback = function(v) F.webhookTest = v end })
UI.HookSec:AddButton({ Name = "Send Test Message Now", Callback = function() task.spawn(sendTestWebhook) end })
UI.lblWebhook = UI.HookSec:AddLabel("Webhook: off")
UI.CtrlSec = section(UI.MiscTab, "Script")
UI.CtrlSec:AddLabel("VY HUB PSX Classic v" .. K.VERSION)
UI.CtrlSec:AddLabel("Made By Vy | .gg/Fgaw3JZt6w")
UI.CtrlSec:AddButton({ Name = "Stop Script", Callback = function()
    if genv.VyPSXClassic then genv.VyPSXClassic.Stop() end
end })

pcall(function() UI.Window:CreateInfoPage({ credits = { "Lead Developer: @vy", "UI Library: VyLib" } }) end)
pcall(function() UI.Window:HideLoading() end)

local function setText(lbl, text)
    if lbl and type(lbl.SetText) == "function" then pcall(lbl.SetText, lbl, text) end
end
local function withNote(prefix, note)
    return prefix .. (note and (" | " .. tostring(note)) or "")
end
loop("ui", 1, function()
    setText(UI.lblStatus, "Status: " .. tostring(state.status))
    setText(UI.lblMoney, string.format("Coins: %s | Diamonds: %s", shorten(currency("Coins")), shorten(currency("Diamonds"))))
    setText(UI.lblWorld, string.format("World: %s%s", tostring(currentWorld()), isHardcore() and " (hardcore)" or ""))
    setText(UI.lblCounters, string.format("Orbs: %d | Coins broken: %d | Eggs: %d | Areas: %d", state.orbs, state.coinsBroken, state.hatched, state.areasBought))
    local r = (F.autoRank or F.autoVip) and rankState() or nil
    setText(UI.lblRewards, withNote(string.format("Rewards: rank %d, VIP %d%s", state.rankRedeems, state.vipRedeems, r and string.format(" | %s: %d rewards", tostring(r.name), r.rewards) or ""), state.rewardNote))
    if F.autoReturn and not V.returned then
        local left = math.max(0, math.max(1, F.returnMinutes) * 60 - (os.clock() - V.returnStartedAt))
        setText(UI.lblReturn, string.format("Return: in %dm %02ds", math.floor(left / 60), math.floor(left % 60)))
    else
        setText(UI.lblReturn, V.returned and "Return: requested" or "Return: off")
    end
    local t = V.farmTarget
    if t and t.Parent then
        setText(UI.lblFarm, withNote(string.format("Target: %s  -  %s hp, %d pets", tostring(t:GetAttribute("Name")), shorten(coinHealth(t)), #V.farmPets), state.farmNote))
    else
        setText(UI.lblFarm, withNote("Target: -", state.farmNote))
    end
    setText(UI.lblGiant, string.format("Giant chests broken: %d%s", state.giantsBroken, (F.autoGiant and #F.giantNames == 0) and " | pick at least one chest" or ""))
    setText(UI.lblCollect, string.format("Orbs: %d claimed, %d ghosts removed | Lootbags: %d", state.orbs, state.ghostOrbs, state.lootbags))
    local egg = (F.autoEgg or F.autoSelectedEgg) and state.eggTarget or bestEgg()
    if egg then
        setText(UI.lblEgg, string.format("%s: %s for %s %s%s", F.autoSelectedEgg and "Selected egg" or "Best egg", egg.id, shorten(egg.cost), egg.currency, egg.locked and " (locked)" or ""))
    else
        setText(UI.lblEgg, "Best egg: none unlocked here")
    end
    setText(UI.lblEggNote, withNote(string.format("Eggs: %d bought (%d requests)", state.hatched, state.hatchRequests), state.eggNote))
    do
        local s = getSave()
        local on = {}
        if s and type(s.AutoDelete) == "table" then
            for _, rar in ipairs(K.RARITIES) do if s.AutoDelete[rar] then on[#on + 1] = rar end end
        end
        setText(UI.lblDelete, "Auto delete: " .. (#on > 0 and table.concat(on, ", ") or "off"))
    end
    setText(UI.lblPets, withNote(string.format("Pets: %d equips, %d golden, %d rainbow, %d fuses, %d enchants", state.equips, state.goldens, state.rainbows, state.fuses, state.enchants), state.petNote))
    local gate = F.autoArea and state.areaTarget or nextGate()
    if gate then
        setText(UI.lblArea, string.format("Next area: %s for %s %s%s", gate.name, shorten(gate.cost), gate.currency, currency(gate.currency) >= gate.cost and " (you can afford it)" or ""))
    else
        setText(UI.lblArea, "Next area: everything here is unlocked")
    end
    setText(UI.lblAreaNote, withNote(string.format("Areas: %d bought, %d teleports", state.areasBought, state.teleportsBought), state.areaNote))
    do
        local best = bestArea()
        setText(UI.lblBestArea, best and string.format("Best area: %s (x%s coins)%s", best.name, tostring(best.mult), F.autoBestArea and (V.bestAreaLast == best.name and " - you are set" or " - teleporting") or "") or "Best area: -")
    end
    setText(UI.lblProgress, withNote(string.format("Progression: %d upgrades, %d boosts", state.upgradesBought, state.boostsUsed), state.progressNote))
    setText(UI.lblWebhook, withNote(string.format("Webhook: %s, %d sent", F.webhookEnabled and "on" or "off", state.webhooksSent), state.webhookNote))
end)

resolveRemotes()
pcall(installSaveTracker)
pcall(installOrbListener)
pcall(installCoinListeners)
pcall(installEggSkip)
pcall(installAntiAfk)

genv.VyPSXClassic = {
    Stop = function()
        if not state.alive then return end
        state.alive = false
        for k, v in pairs(F) do
            if type(v) == "boolean" and k ~= "antiAfk" then F[k] = false end
        end
        for _, c in ipairs(connections) do pcall(function() c:Disconnect() end) end
        connections = {}
        for _, fn in ipairs(restoreFns) do pcall(fn) end
        restoreFns = {}
        pcall(function() if genv.Library and genv.Library.Unload then genv.Library:Unload() end end)
        log("stopped")
    end,
    State = state,
    Features = F,
    Vars = V,
    Debug = { pickCoin = pickCoin, giantTarget = giantTarget, joinCoin = joinCoin, farmTick = farmTick, bestEgg = bestEgg, selectedEgg = selectedEgg, eggItems = eggItems, eggCost = eggCost, eggTick = eggTick, deleteTick = deleteTick, nextGate = nextGate, areaTick = areaTick, bestArea = bestArea, scanAreas = scanAreas, teleportToArea = teleportToArea, bestAreaTick = bestAreaTick, nextTeleport = nextTeleport, teleportTick = teleportTick, nextUpgrade = nextUpgrade, upgradeTick = upgradeTick, boostTick = boostTick, convertTick = convertTick, fuseTick = fuseTick, enchantTick = enchantTick, equipTick = equipTick, groupPets = groupPets, rankState = rankState, rankTick = rankTick, vipTick = vipTick, returnToPS99 = returnToPS99, currency = currency, getSave = getSave, petUids = petUids, netInvoke = netInvoke, netFire = netFire, remoteFunction = remoteFunction, remoteEvent = remoteEvent, orbTick = orbTick, sweepOrbs = sweepOrbs, lootTick = lootTick, osTime = osTime, padOf = padOf, webhookTick = webhookTick, sendTestWebhook = sendTestWebhook, sendPetWebhook = sendPetWebhook, petDisplayName = petDisplayName, webhookPost = webhookPost, petIconUrl = petIconUrl },
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

state.status = "idle"
notify("VY HUB", "PSX Classic loaded - RightShift opens the menu", 6)
pcall(function() Library:LoadAutoloadConfig(true) end)
log("loaded v%s (identity %d, remotes %s)", K.VERSION, K.IDENTITY_EXEC, (V.getName and V.remote) and "resolved" or "unresolved")
