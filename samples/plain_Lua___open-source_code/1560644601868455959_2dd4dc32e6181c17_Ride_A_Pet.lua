-- GISCRIPT server-side launch analytics wrapper. Do not edit the stored source.
local HttpService = game:GetService("HttpService")
local ANALYTICS_ENDPOINT = "https://giscript.org/api/inject"
local ANALYTICS_PROJECT = "glitch"
local ANALYTICS_ID_FILE = "giscript_analytics_client_id.txt"
local ANALYTICS_MEMORY_NAME = "__GISCRIPT_ANALYTICS_CLIENT_ID"

local function validClientId(value)
    return type(value) == "string" and #value >= 16 and #value <= 160
end

local function getMemoryClientId()
    if type(getgenv) ~= "function" then return nil end
    local ok, environment = pcall(getgenv)
    if not ok or type(environment) ~= "table" then return nil end
    local value = environment[ANALYTICS_MEMORY_NAME]
    return validClientId(value) and value or nil
end

local function saveMemoryClientId(value)
    if type(getgenv) ~= "function" then return end
    local ok, environment = pcall(getgenv)
    if ok and type(environment) == "table" then environment[ANALYTICS_MEMORY_NAME] = value end
end

local function getClientId()
    local value = getMemoryClientId()
    if value then return value end

    if type(isfile) == "function" and type(readfile) == "function" then
        local exists, present = pcall(isfile, ANALYTICS_ID_FILE)
        if exists and present then
            local readOk, saved = pcall(readfile, ANALYTICS_ID_FILE)
            if readOk and validClientId(saved) then
                saveMemoryClientId(saved)
                return saved
            end
        end
    end

    local generatedOk, generated = pcall(HttpService.GenerateGUID, HttpService, false)
    if not generatedOk or not validClientId(generated) then return nil end
    saveMemoryClientId(generated)
    if type(writefile) == "function" then pcall(writefile, ANALYTICS_ID_FILE, generated) end
    return generated
end

local function getHttpRequest()
    local candidates = {
        rawget(getfenv(), "request"), rawget(getfenv(), "http_request"),
        type(syn) == "table" and syn.request or nil,
        type(fluxus) == "table" and fluxus.request or nil,
    }
    for _, candidate in ipairs(candidates) do
        if type(candidate) == "function" then return candidate end
    end
end

local function reportLaunch()
    local clientId = getClientId()
    if not clientId then return end
    local payload = { project = ANALYTICS_PROJECT, client_id = clientId, version = "server-loader" }
    local sendRequest = getHttpRequest()
    if sendRequest then
        local encodedOk, body = pcall(HttpService.JSONEncode, HttpService, payload)
        if encodedOk then
            local sent = pcall(sendRequest, {
                Url = ANALYTICS_ENDPOINT, Method = "POST",
                Headers = { ["Content-Type"] = "application/json" }, Body = body,
            })
            if sent then return end
        end
    end

    local query = "?project=" .. HttpService:UrlEncode(ANALYTICS_PROJECT)
        .. "&client_id=" .. HttpService:UrlEncode(clientId)
        .. "&version=server-loader"
    pcall(function() game:HttpGet(ANALYTICS_ENDPOINT .. query) end)
end

-- Analytics must never stop the user's script if an executor blocks requests.
pcall(reportLaunch)

_G.__GH_N = (_G.__GH_N or 0) + 1
local MY_ID = _G.__GH_N
if type(_G.__GH_Kill) == "function" then pcall(_G.__GH_Kill) end
if type(_G.__GH_Conns) == "table" then
    for _, c in ipairs(_G.__GH_Conns) do pcall(function() c:Disconnect() end) end
end
_G.__GH_Conns = {}
local function trackConn(c) _G.__GH_Conns[#_G.__GH_Conns + 1] = c; return c end

local Players    = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS        = game:GetService("UserInputService")
local TweenSvc   = game:GetService("TweenService")
local RS         = game:GetService("ReplicatedStorage")
local HttpSvc    = game:GetService("HttpService")
local Tags       = game:GetService("CollectionService")
local GuiSvc     = game:GetService("GuiService")
local StarterGui = game:GetService("StarterGui")
local WS         = workspace
local LP         = Players.LocalPlayer
local VU; pcall(function() VU = game:GetService("VirtualUser") end)
local localeId = string.lower(tostring(LP.LocaleId or "en-us"))
local DEFAULT_LANG = localeId:sub(1,2) == "ru" and "RU"
    or localeId:sub(1,2) == "de" and "DE"
    or localeId:sub(1,2) == "fr" and "FR" or "EN"

local EGG_DB = {
    ["White Egg"]={Rarity="Common",Luck=1},["Brown Egg"]={Rarity="Common",Luck=5},
    ["Cracked Egg"]={Rarity="Rare",Luck=30},["Easter Egg"]={Rarity="Rare",Luck=50},
    ["Stone Egg"]={Rarity="Rare",Luck=100},["Leaf Egg"]={Rarity="Rare",Luck=200},
    ["Mushroom Egg"]={Rarity="Epic",Luck=500},["Flower Egg"]={Rarity="Epic",Luck=750},
    ["Slime Egg"]={Rarity="Epic",Luck=1000},["Ice Egg"]={Rarity="Epic",Luck=3000},
    ["Glass Egg"]={Rarity="Legendary",Luck=10000},["Golden Egg"]={Rarity="Legendary",Luck=30000},
    ["Diamond Egg"]={Rarity="Mythic",Luck=90000},["Crystal Egg"]={Rarity="Mythic",Luck=150000},
    ["Skull Egg"]={Rarity="Mythic",Luck=250000},["Asteroid Egg"]={Rarity="Mythic",Luck=500000},
    ["Dominus Egg"]={Rarity="Mythic",Luck=700000},["Flaming Egg"]={Rarity="Mythic",Luck=1000000},
    ["Sinister Egg"]={Rarity="Mythic",Luck=3000000},["Soul Egg"]={Rarity="Mythic",Luck=7000000},
    ["Tidal Egg"]={Rarity="Mythic",Luck=8000000},["Aurora Egg"]={Rarity="Divine",Luck=300000000},
    ["Galaxy Egg"]={Rarity="Divine",Luck=1500000000},["Bloom Egg"]={Rarity="Divine",Luck=2000000000},
    ["Blackhole Egg"]={Rarity="Ethereal",Luck=100000000000},["Solaris Egg"]={Rarity="Ethereal",Luck=300000000000},
    ["Cherub Egg"]={Rarity="Ethereal",Luck=1000000000000},["Volcanic Egg"]={Rarity="Ethereal",Luck=2500000000000},
}
local RARITY_LIST = {"Common","Uncommon","Rare","Epic","Legendary","Mythic","Divine","Ethereal"}
local RARITY_W    = {Common=100,Uncommon=200,Rare=500,Epic=600,Legendary=700,Mythic=800,Divine=900,Ethereal=1000,Unknown=0}
local MUT_MULT    = {Shocked=2,Volted=3,Rage=4,Void=10,Magma=10,Eternal=100}
local STORM_MAP   = {Thunder="Shocked",Volt="Volted",Raging="Rage",Dreadful="Void",Eternal="Eternal"}
local MUT_TIERS   = {["All"]=0,["Shocked+"]=2,["Volted+"]=3,["Rage+"]=4,["Void/Magma+"]=10,["Eternal Only"]=100}

local REM = {}
local function loadRemotes()
    pcall(function()
        local rem   = RS:FindFirstChild("Remotes") or RS:WaitForChild("Remotes", 8)
        local game_ = rem and (rem:FindFirstChild("Game") or rem:WaitForChild("Game", 5))
        if not game_ then return end
        local plot = game_:FindFirstChild("Plot")
        REM.EggPickup      = game_:FindFirstChild("EggPickup")
        REM.BasketDrop     = game_:FindFirstChild("BasketDrop")
        REM.TeleportToPlot = game_:FindFirstChild("TeleportToPlot")
        REM.EggPlaced      = game_:FindFirstChild("EggPlaced")
        REM.Hatch          = game_:FindFirstChild("Hatch")
        REM.Rebirth        = game_:FindFirstChild("Rebirth")
        REM.FeedPet        = game_:FindFirstChild("FeedPet") or RS:FindFirstChild("FeedPet", true)
        REM.PlacePet       = game_:FindFirstChild("PlacePet")
        REM.PickupPet      = game_:FindFirstChild("PickupPet")
        REM.PlotNests      = plot and plot:FindFirstChild("Nests")
        REM.Upgrades       = plot and plot:FindFirstChild("Upgrades")
    end)
end

local S = {
    farmAll=false, farmBest=false, minRarity="Epic", minMutation="All",
    teleport=true, flySpeed=80, speedOn=false, speed=60,
    antiTrap=true, antiBat=true, antiStun=true,
    autoHatch=false, autoClaim=false, autoSell=false,
    autoPlace=false, autoFeed=false, autoRebirth=false,
    autoLuck=false, autoUnlock=false,
    espEggs=false, espPlayers=false, espMutation=false,
    espMaxDist=600, espMinRarity="Rare",
    antiAfk=true, removeBackground=false, uiLang=DEFAULT_LANG,
}

local function chr()     return LP.Character end
local function hrp()     local c=chr(); return c and c:FindFirstChild("HumanoidRootPart") end
local function hum()     local c=chr(); return c and c:FindFirstChildOfClass("Humanoid") end
local function alive()   local h=hum(); return h and h.Health>0 end
local function low(s)    return string.lower(tostring(s or "")) end
local function dist(a,b) return (a-b).Magnitude end

local function posOf(inst)
    if not inst then return nil end
    local ok, p = pcall(function()
        if typeof(inst) == "Vector3" then return inst end
        if inst:IsA("BasePart") then return inst.Position end
        if inst:IsA("Model") then
            if inst.PrimaryPart then return inst.PrimaryPart.Position end
            local _, piv = pcall(function() return inst:GetPivot().Position end)
            if piv then return piv end
            for _, d in ipairs(inst:GetDescendants()) do
                if d:IsA("BasePart") then return d.Position end
            end
        end
    end)
    return ok and p or nil
end

local function firstPart(obj)
    if not obj then return nil end
    if obj:IsA("BasePart") then return obj end
    for _, d in ipairs(obj:GetDescendants()) do if d:IsA("BasePart") then return d end end
    return nil
end

local function fireRem(rem, ...)
    if not rem then return false end
    local args = table.pack(...)
    local ok = pcall(function() rem:FireServer(table.unpack(args, 1, args.n)) end)
    return ok
end

local function safeRequire(folder, child)
    local container = RS:FindFirstChild(folder)
    local module = container and container:FindFirstChild(child)
    if not module or not module:IsA("ModuleScript") then return nil end
    local ok, result = pcall(require, module)
    return ok and result or nil
end

local gameEggs = nil
local function eggDef(name)
    if gameEggs == nil then gameEggs = safeRequire("GameData", "Eggs") or false end
    local fromGame = gameEggs and gameEggs[name]
    return fromGame or EGG_DB[name] or {}
end

local function eggMutation(obj, attrs)
    local mut = attrs and attrs.Mutation
    if not mut and obj then pcall(function() mut = obj:GetAttribute("Mutation") end) end
    if mut == "" then mut = nil end
    if not mut and obj then
        for name in pairs(MUT_MULT) do
            if obj:FindFirstChild(name, true) then mut = name; break end
        end
        if not mut and obj:FindFirstChild("MutationHitbox", true) then mut = "Unknown" end
    end
    return mut
end

local function getActiveEggs()
    local out = {}
    local sd = RS:FindFirstChild("ServerData"); if not sd then return out end
    local ae = sd:FindFirstChild("ActiveEggs"); if not ae then return out end
    for _, entry in ipairs(ae:GetChildren()) do
        pcall(function()
            local d = entry:GetAttributes()
            local nm = d.Egg or d.EggName or d.Name
            local pos = d.Position or (d.SpawnCFrame and d.SpawnCFrame.Position)
            local eb  = nm and eggDef(nm) or {}
            local rar = d.Rarity or eb.Rarity or "Common"
            local mut = eggMutation(entry, d)
            out[#out+1] = {
                entryName=entry.Name, eggName=nm, pos=pos, rarity=rar,
                rarW=RARITY_W[rar] or 0, luck=tonumber(eb.Luck) or 1,
                eggWeight=tonumber(d.Weight) or 0, entry=entry,
                mutation=mut, mutMult=mut and (MUT_MULT[mut] or 1) or 1,
            }
        end)
    end
    return out
end

local function getRenderedEggs()
    local out = {}
    local re = WS:FindFirstChild("RenderedEggs"); if not re then return out end
    local active = getActiveEggs()
    for _, obj in ipairs(re:GetChildren()) do
        local part = firstPart(obj)
        if part then
            local nm = obj.Name; local eb = eggDef(nm)
            local pos = posOf(obj) or part.Position
            local nearest, nearestDist = nil, 30
            for _, entry in ipairs(active) do
                if entry.pos then
                    local d = dist(pos, entry.pos)
                    if d < nearestDist then nearest, nearestDist = entry, d end
                end
            end
            local nearestAttrs = nil
            if nearest and nearest.entry and nearest.entry.Parent then
                pcall(function() nearestAttrs = nearest.entry:GetAttributes() end)
            end
            local mut = eggMutation(obj, nearestAttrs)
            local rarity = eb.Rarity or (nearest and nearest.rarity) or "Common"
            out[#out+1] = {
                obj=obj, part=part, pos=pos, eggName=nm,
                entryName=nearest and nearest.entryName or nil,
                rarity=rarity, rarW=RARITY_W[rarity] or 0,
                luck=tonumber(eb.Luck) or 1,
                eggWeight=nearest and nearest.eggWeight or tonumber(obj:GetAttribute("Weight")) or 0,
                mutation=mut, mutMult=mut and (MUT_MULT[mut] or 1) or 1,
            }
        end
    end
    return out
end

local function eggPasses(e)
    local minW = RARITY_W[S.minRarity] or 0
    if (e.rarW or 0) < minW then return false end
    local minM = MUT_TIERS[S.minMutation] or 0
    if minM > 0 then
        if not e.mutation then return false end
        if (MUT_MULT[e.mutation] or 0) < minM then return false end
    end
    return true
end

local function getStorm()
    local ok, res = pcall(function()
        local sd = RS:FindFirstChild("ServerData"); if not sd then return nil end
        local aw = sd:GetAttribute("ActiveWeathers")
        if not aw or aw == "" or aw == "[]" then return nil end
        local parsed = game:GetService("HttpService"):JSONDecode(aw)
        local now = tick()
        for _, w in ipairs(parsed) do
            if w.Type == "Storm" and w.Variant then
                if not w.EndsAt or w.EndsAt > now then return w end
            end
        end
        return nil
    end)
    return ok and res or nil
end

local moving = false
local flyBV  = nil

local function clearFly()
    pcall(function()
        local h = hrp(); if not h then return end
        for _, c in ipairs(h:GetChildren()) do
            if c:IsA("BodyVelocity") or c:IsA("BodyGyro") or c:IsA("BodyPosition") then c:Destroy() end
        end
    end)
    flyBV = nil
end

local function tpTo(pos)
    local h = hrp(); if not h then return false end
    pcall(function() h.CFrame = CFrame.new(pos + Vector3.new(0,3,0)); task.wait(0.05) end)
    return true
end

local function flyTo(pos, timeout)
    local h = hrp(); if not h then return false end
    timeout = timeout or 20; moving = true
    local spd = math.clamp(S.flySpeed, 16, 800)
    if not (flyBV and flyBV.Parent) then
        flyBV = Instance.new("BodyVelocity")
        flyBV.MaxForce = Vector3.new(1e7,1e7,1e7); flyBV.P = 12500
        flyBV.Velocity = Vector3.new(0,0,0); flyBV.Parent = h
    end
    local t0 = tick()
    while moving and alive() and tick()-t0 < timeout do
        local cur = hrp(); if not cur then break end
        local flat = Vector3.new(pos.X-cur.Position.X, 0, pos.Z-cur.Position.Z)
        local dy   = pos.Y - cur.Position.Y
        if flat.Magnitude < 4 and math.abs(dy) < 8 then break end
        local dir = flat.Magnitude > 0.1 and flat.Unit or Vector3.new(0,0,0)
        local vy  = math.abs(dy) > 6 and math.clamp(dy,-18,18) or 0
        if flyBV and flyBV.Parent then flyBV.Velocity = Vector3.new(dir.X*spd, vy, dir.Z*spd) end
        task.wait(0.06)
    end
    moving = false
    if flyBV and flyBV.Parent then flyBV.Velocity = Vector3.new(0,0,0) end
    clearFly(); return true
end

local function moveTo(pos, timeout) return S.teleport and tpTo(pos) or flyTo(pos, timeout) end

local plotCache, plotCacheT = nil, -999
local function flushPlot() plotCache = nil; plotCacheT = -999 end

local function myPlot()
    if tick() - plotCacheT < 6 then return plotCache end
    local found = nil
    local general = safeRequire("GameServices", "General")
    if general and type(general.GetPlot) == "function" then
        pcall(function() found = general:GetPlot(LP) end)
    end
    local plots = WS:FindFirstChild("Plots")
    if not found and plots then
        for _, candidate in ipairs(plots:GetChildren()) do
            local owner = candidate:GetAttribute("NestsOwnerLoaded")
                or candidate:GetAttribute("OwnerUserId") or candidate:GetAttribute("Owner")
            local data = candidate:FindFirstChild("Data")
            local ownerValue = data and data:FindFirstChild("Owner")
            if ownerValue then owner = ownerValue.Value end
            if owner == LP.UserId or tostring(owner) == tostring(LP.UserId)
            or owner == LP.Name or tostring(owner) == LP.Name then
                found = candidate; break
            end
        end
    end
    if found then plotCache = found; plotCacheT = tick() end
    return found
end

local function plotPosition(plot)
    if not plot then return nil end
    local base = plot:FindFirstChild("Baseplate") or plot:FindFirstChild("Base", true)
    return posOf(base or plot)
end

local function isEggTool(item)
    if not item or not item:IsA("Tool") then return false end
    local tagged = false; pcall(function() tagged = Tags:HasTag(item, "Egg") end)
    return tagged or item:GetAttribute("Egg") ~= nil or low(item.Name):find("egg", 1, true) ~= nil
end

local function carriedEgg()
    local c = chr()
    for _, container in ipairs({c, LP:FindFirstChild("Backpack")}) do
        if container then
            for _, item in ipairs(container:GetChildren()) do
                if isEggTool(item) then return item end
            end
        end
    end
    return nil
end

local function basketCount()
    local basket = LP:FindFirstChild("Basket")
    return basket and #basket:GetChildren() or 0
end

local function freeNest(plot)
    local nests = plot and plot:FindFirstChild("Nests")
    if not nests then return nil end
    local list = nests:GetChildren()
    table.sort(list, function(a, b) return (tonumber(a.Name) or 999) < (tonumber(b.Name) or 999) end)
    for _, nest in ipairs(list) do
        if nest:GetAttribute("Unlocked") == true and nest:GetAttribute("Occupied") ~= true then
            return nest
        end
    end
    return nil
end

local function placeCarriedEgg(plot)
    local egg = carriedEgg()
    local nest = freeNest(plot)
    if not egg or not nest or not REM.EggPlaced then return false end
    local h = hum()
    if h and egg.Parent ~= chr() then
        h:EquipTool(egg)
        local untilAt = tick() + 1
        while egg.Parent ~= chr() and tick() < untilAt do task.wait(0.05) end
    end
    if egg.Parent ~= chr() then return false end
    fireRem(REM.EggPlaced, {NestId = nest.Name})
    return true
end

local function returnToPlot(plot)
    local before = hrp() and hrp().Position
    fireRem(REM.TeleportToPlot)
    task.wait(0.35)
    local target = plotPosition(plot)
    local root = hrp()
    if target and root and (not before or dist(root.Position, before) < 4) then
        moveTo(target, 18)
    end
end

local collectRunning = false
local function doCollect()
    if not alive() then task.wait(1); return end
    if not REM.EggPickup then loadRemotes() end
    local eggs = getRenderedEggs()
    if #eggs == 0 then eggs = getActiveEggs() end
    if #eggs == 0 then task.wait(2); return end
    local filtered = {}
    for _, e in ipairs(eggs) do
        if e.pos and e.entryName and (S.farmAll or (S.farmBest and eggPasses(e))) then
            filtered[#filtered+1] = e
        end
    end
    if #filtered == 0 then task.wait(2); return end
    table.sort(filtered, function(a, b)
        local am = (a.mutMult or 1)*(a.luck or 1); local bm = (b.mutMult or 1)*(b.luck or 1)
        if am ~= bm then return am > bm end
        if (a.rarW or 0) ~= (b.rarW or 0) then return (a.rarW or 0) > (b.rarW or 0) end
        return (a.eggWeight or 0) > (b.eggWeight or 0)
    end)
    local egg = filtered[1]; if not egg.pos then task.wait(1); return end
    local h = hrp(); if not h then return end
    if dist(h.Position, egg.pos) > 7 then moveTo(egg.pos, 12); task.wait(0.15) end
    if egg.obj then
        local prompt = egg.obj:FindFirstChildWhichIsA("ProximityPrompt", true)
        if prompt and fireproximityprompt then pcall(fireproximityprompt, prompt, 0) end
    end
    local before = basketCount()
    fireRem(REM.EggPickup, egg.entryName)
    local deadline = tick() + 2.5
    while tick() < deadline and basketCount() <= before and not carriedEgg() do task.wait(0.05) end
    if basketCount() <= before and not carriedEgg() then return end
    local plot = myPlot()
    if plot then
        returnToPlot(plot)
        task.wait(0.15)
        placeCarriedEgg(plot)
    end
end

local function collectLoop()
    if collectRunning then return end; collectRunning = true
    while MY_ID == _G.__GH_N and (S.farmAll or S.farmBest) do pcall(doCollect); task.wait(0.35) end
    collectRunning = false
end

local function hatchReadyEggs(plot)
    if not REM.Hatch or not plot then return end
    local readyKeys = {}
    local pg = LP:FindFirstChildOfClass("PlayerGui")
    local main = pg and pg:FindFirstChild("Main")
    local tracker = main and main:FindFirstChild("PlotEggsTracker")
    local holder = tracker and tracker:FindFirstChild("Holder")
    if holder then
        for _, card in ipairs(holder:GetChildren()) do
            local open = card:FindFirstChild("Open", true)
            local timer = card:FindFirstChild("TimeLeft", true)
            local ready = (open and open:IsA("GuiObject") and open.Visible)
                or (timer and timer:IsA("TextLabel") and low(timer.Text):find("ready", 1, true))
            if ready and #card.Name > 10 then readyKeys[card.Name] = true end
        end
    end
    local eggs = plot:FindFirstChild("Eggs")
    if eggs then
        for _, egg in ipairs(eggs:GetChildren()) do
            local key = egg:GetAttribute("EggKey")
            local ready = key and readyKeys[key]
            local ui = egg:FindFirstChild("HatchingUI", true)
            local timer = ui and ui:FindFirstChild("Timer")
            if timer and timer:IsA("TextLabel") and low(timer.Text):find("ready", 1, true) then ready=true end
            if not ready then
                local data = egg:FindFirstChild("EggData")
                local placed = data and data:FindFirstChild("PlaceTime")
                local weight = data and data:FindFirstChild("Weight")
                local def = eggDef(egg.Name)
                if placed and def.GrowthTime then
                    local elapsed = WS:GetServerTimeNow()-(tonumber(placed.Value) or math.huge)
                    local duration = tonumber(def.GrowthTime)*(tonumber(weight and weight.Value) or 1)
                    ready = elapsed >= duration
                end
            end
            if key and ready then
                fireRem(REM.Hatch, {EggKey = key})
                task.wait(0.06)
            end
        end
    end
end

local function unlockNests(plot)
    local nests = plot and plot:FindFirstChild("Nests")
    if not nests then return end
    for _, nest in ipairs(nests:GetChildren()) do
        if nest:GetAttribute("Unlocked") ~= true then
            local prompt = nest:FindFirstChildWhichIsA("ProximityPrompt", true)
            if prompt and fireproximityprompt then pcall(fireproximityprompt, prompt, 0) end
            local id = tonumber(nest.Name)
            if id then fireRem(REM.PlotNests, id) end
            task.wait(0.15)
        end
    end
end

local function clickClaimButtons()
    local pg = LP:FindFirstChildOfClass("PlayerGui"); if not pg then return end
    for _, button in ipairs(pg:GetDescendants()) do
        if button:IsA("GuiButton") and button.Visible then
            local text = low(button.Name).." "..low(button:IsA("TextButton") and button.Text or "")
            if text:find("claim", 1, true) or text:find("collect", 1, true)
            or text:find("redeem", 1, true) or text:find("reward", 1, true) then
                pcall(function()
                    if firesignal then firesignal(button.Activated) else button:Activate() end
                end)
            end
        end
    end
end

local function dataValue(item, name)
    local attr = item:GetAttribute(name)
    if attr ~= nil then return attr end
    local data = item:FindFirstChild("Data")
    local value = data and data:FindFirstChild(name)
    return value and value.Value or nil
end

local petDefs, mutationDefs, foodDefs
local function petScore(name, weight, mutation)
    if petDefs == nil then petDefs = safeRequire("GameData", "Pets") or false end
    if mutationDefs == nil then mutationDefs = safeRequire("GameData", "Mutations") or false end
    local income = petDefs and petDefs[name] and tonumber(petDefs[name].Income) or 1
    local factor = 1
    if mutationDefs and type(mutationDefs.CombinedFactor) == "function" then
        pcall(function() factor = mutationDefs.CombinedFactor(mutation, nil) or 1 end)
    end
    return income * (tonumber(weight) or 1) * factor
end

local function petRecord(item, placed)
    local key = item:GetAttribute("PetKey") or dataValue(item, "PetKey")
    if not key then return nil end
    local name = item:GetAttribute("PetName") or dataValue(item, "PetName") or item.Name
    local weight = tonumber(item:GetAttribute("Weight") or dataValue(item, "Weight")) or 1
    local age = tonumber(item:GetAttribute("Age") or dataValue(item, "Age")) or 1
    local mutation = item:GetAttribute("Mutation") or dataValue(item, "Mutation")
    return {Key=key, Name=name, Weight=weight, Age=age, Mutation=mutation,
        Score=petScore(name, weight, mutation), Item=item, Placed=placed}
end

local function placeBestPets(plot)
    if not plot or not REM.PlacePet or not REM.PickupPet then return end
    local all, byKey = {}, {}
    local petsFolder = plot:FindFirstChild("Pets")
    if petsFolder then
        for _, model in ipairs(petsFolder:GetChildren()) do
            local rec = petRecord(model, true)
            if rec then all[#all+1]=rec; byKey[rec.Key]=rec end
        end
    end
    for _, container in ipairs({LP:FindFirstChild("Backpack"), chr()}) do
        if container then
            for _, tool in ipairs(container:GetChildren()) do
                if tool:IsA("Tool") and tool:GetAttribute("PetKey") then
                    local rec = petRecord(tool, false)
                    if rec and not byKey[rec.Key] then all[#all+1]=rec; byKey[rec.Key]=rec end
                end
            end
        end
    end
    if #all == 0 then return end
    table.sort(all, function(a,b) return a.Score > b.Score end)
    local maxPets = math.max(1, tonumber(LP:GetAttribute("MaxPets")) or 5)
    local wanted = {}; for i=1,math.min(maxPets,#all) do wanted[all[i].Key]=true end
    local positions = {}
    for _, rec in ipairs(all) do
        if rec.Placed and not wanted[rec.Key] then
            positions[#positions+1] = posOf(rec.Item)
            fireRem(REM.PickupPet, rec.Key)
            task.wait(0.15)
        end
    end
    local base = plot:FindFirstChild("Baseplate") or plot:FindFirstChild("Base", true)
    local baseCf = base and base.CFrame or CFrame.new(plotPosition(plot) or Vector3.new())
    for i=1,math.min(maxPets,#all) do
        local rec = all[i]
        if not rec.Placed then
            local tool = nil
            local untilAt = tick()+1.5
            repeat
                for _, container in ipairs({LP:FindFirstChild("Backpack"), chr()}) do
                    if container then
                        for _, item in ipairs(container:GetChildren()) do
                            if item:IsA("Tool") and item:GetAttribute("PetKey") == rec.Key then tool=item; break end
                        end
                    end
                    if tool then break end
                end
                if not tool then task.wait(0.05) end
            until tool or tick()>untilAt
            if tool then
                local h=hum(); if h and tool.Parent~=chr() then h:EquipTool(tool); task.wait(0.1) end
                local row=math.floor((i-1)/3); local col=(i-1)%3-1
                local target=positions[#positions] or baseCf:PointToWorldSpace(Vector3.new(col*4,1,-8-row*4))
                positions[#positions]=nil
                fireRem(REM.PlacePet, rec.Key, target)
                task.wait(0.15)
            end
        end
    end
end

local function feedBestPet(plot)
    if not plot or not REM.FeedPet then return end
    local pets = plot:FindFirstChild("Pets"); if not pets then return end
    local targets = {}
    for _, model in ipairs(pets:GetChildren()) do
        local rec=petRecord(model,true)
        if rec and rec.Age < 100 then targets[#targets+1]=rec end
    end
    table.sort(targets,function(a,b) if a.Age~=b.Age then return a.Age<b.Age end return a.Score>b.Score end)
    local target=targets[1]; if not target then return end
    if foodDefs==nil then foodDefs=safeRequire("GameData","Foods") or false end
    local foods={}
    for _,container in ipairs({LP:FindFirstChild("Backpack"),chr()}) do
        if container then
            for _,tool in ipairs(container:GetChildren()) do
                if tool:IsA("Tool") then
                    local tagged=false; pcall(function() tagged=Tags:HasTag(tool,"Food") end)
                    local def=foodDefs and foodDefs[tool.Name]
                    if tagged or def then foods[#foods+1]={Tool=tool,Name=tool.Name,XP=def and tonumber(def.XP) or 1} end
                end
            end
        end
    end
    table.sort(foods,function(a,b)return a.XP>b.XP end)
    local food=foods[1]; if not food then return end
    local h=hum(); if h and food.Tool.Parent~=chr() then h:EquipTool(food.Tool); task.wait(0.1) end
    local root=hrp(); local petPos=posOf(target.Item)
    if root and petPos and dist(root.Position,petPos)>8 and not (S.farmAll or S.farmBest) then moveTo(petPos,8) end
    fireRem(REM.FeedPet,target.Key,food.Name)
end

local farmRunning = false
local function farmLoop()
    if farmRunning then return end; farmRunning = true
    local lastPlace, lastClaim = 0, 0
    while MY_ID == _G.__GH_N and (S.autoHatch or S.autoClaim or S.autoSell or S.autoPlace
    or S.autoFeed or S.autoRebirth or S.autoLuck or S.autoUnlock) do
        pcall(function()
            if not alive() then return end
            if not REM.EggPlaced then loadRemotes() end
            local plot = myPlot()
            if S.autoHatch   then hatchReadyEggs(plot) end
            if S.autoRebirth then fireRem(REM.Rebirth) end
            if S.autoLuck then
                fireRem(REM.Upgrades,"HatchUpgrade","BuyMax")
                fireRem(REM.Upgrades,"HatchUpgrade","BuyOne")
            end
            if S.autoUnlock then unlockNests(plot) end
            if S.autoHatch or S.autoPlace then placeCarriedEgg(plot) end
            if S.autoPlace and tick()-lastPlace>12 then placeBestPets(plot); lastPlace=tick() end
            if S.autoFeed and not (S.farmAll or S.farmBest) then feedBestPet(plot) end
            if S.autoClaim and tick()-lastClaim>5 then clickClaimButtons(); lastClaim=tick() end
        end)
        task.wait(1.25)
    end
    farmRunning = false
end

local modConn = nil
local function applyMods()
    if modConn then pcall(function() modConn:Disconnect() end) end
    local lastProtection = 0
    modConn = trackConn(RunService.Heartbeat:Connect(function()
        pcall(function()
            local hu = hum(); if not hu then return end
            if S.speedOn then hu.WalkSpeed = math.clamp(S.speed, 8, 250) end
            if S.antiStun then
                hu:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
                hu:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
                hu:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
                if hu.PlatformStand then
                    hu.PlatformStand = false
                    hu:ChangeState(Enum.HumanoidStateType.GettingUp)
                end
            end
            if S.antiTrap and tick()-lastProtection > 0.5 then
                lastProtection = tick()
                local c=chr()
                if c then
                    for _,item in ipairs(c:GetDescendants()) do
                        local name=low(item.Name)
                        if (name:find("trap",1,true) or name:find("cage",1,true)
                        or name:find("net",1,true) or name:find("stun",1,true))
                        and (item:IsA("Constraint") or item:IsA("BodyMover") or item:IsA("Weld")) then
                            item:Destroy()
                        end
                    end
                end
            end
        end)
    end))
end

local function startAfk()
    trackConn(LP.Idled:Connect(function()
        if S.antiAfk and VU then
            pcall(function()
                VU:Button2Down(Vector2.new(0,0), WS.CurrentCamera.CFrame)
                task.wait(0.5)
                VU:Button2Up(Vector2.new(0,0), WS.CurrentCamera.CFrame)
            end)
        end
    end))
end

local espBills = {}; local espConn = nil
local function clearEsp() for _, v in ipairs(espBills) do pcall(function() v:Destroy() end) end; espBills = {} end

local ESP_COL = {
    Common=Color3.fromRGB(200,200,200), Rare=Color3.fromRGB(60,120,255),
    Epic=Color3.fromRGB(180,70,255), Legendary=Color3.fromRGB(255,165,0),
    Mythic=Color3.fromRGB(255,50,50), Divine=Color3.fromRGB(255,215,0),
    Ethereal=Color3.fromRGB(0,230,255),
}
local ESP_MUT = {
    Eternal=Color3.fromRGB(255,100,220), Magma=Color3.fromRGB(255,120,20),
    Void=Color3.fromRGB(130,60,255), Rage=Color3.fromRGB(255,60,60),
    Volted=Color3.fromRGB(255,230,40), Shocked=Color3.fromRGB(80,190,255),
}

local function mkBB(adornee, text, col, d)
    local pg = LP:FindFirstChildOfClass("PlayerGui"); if not pg or not adornee then return end
    local bb = Instance.new("BillboardGui")
    bb.AlwaysOnTop = true; bb.Size = UDim2.new(0,160,0,30)
    bb.StudsOffset = Vector3.new(0,4,0); bb.Adornee = adornee; bb.Parent = pg
    local lb = Instance.new("TextLabel", bb)
    lb.Size = UDim2.new(1,0,1,0); lb.BackgroundTransparency = 1
    lb.TextColor3 = col or Color3.new(1,1,1); lb.Font = Enum.Font.GothamBold
    lb.TextSize = 11; lb.TextStrokeTransparency = 0
    lb.Text = text..(d and ("  "..math.floor(d)) or "")
    espBills[#espBills+1] = bb
end

local function startEsp()
    if espConn then pcall(function() espConn:Disconnect() end) end
    local lastUpdate = 0
    espConn = trackConn(RunService.Heartbeat:Connect(function()
        if not (S.espEggs or S.espPlayers or S.espMutation) then clearEsp(); return end
        if tick()-lastUpdate < 0.25 then return end
        lastUpdate = tick()
        clearEsp(); local h = hrp(); if not h then return end
        local minW = RARITY_W[S.espMinRarity] or 0
        if S.espEggs or S.espMutation then
            for _, re in ipairs(getRenderedEggs()) do
                local showR = S.espEggs and (re.rarW or 0) >= minW
                local showM = S.espMutation and re.mutation ~= nil
                if showR or showM then
                    local d = dist(h.Position, re.pos)
                    if d <= S.espMaxDist then
                        local col = (re.mutation and ESP_MUT[re.mutation]) or ESP_COL[re.rarity] or Color3.new(1,1,1)
                        mkBB(re.part, re.eggName.." | "..(re.rarity or "?")
                            ..(re.mutation and " +"..re.mutation or ""), col, d)
                    end
                end
            end
        end
        if S.espPlayers then
            for _, plr in ipairs(Players:GetPlayers()) do
                if plr ~= LP and plr.Character then
                    local pp = posOf(plr.Character)
                    if pp then
                        local d = dist(h.Position, pp)
                        if d <= S.espMaxDist then
                            local part = plr.Character:FindFirstChild("HumanoidRootPart")
                            if part then mkBB(part, plr.Name, Color3.fromRGB(80,200,255), d) end
                        end
                    end
                end
            end
        end
    end))
end

local T = {
    accent  = Color3.fromRGB(225,128,30),
    accent2 = Color3.fromRGB(160,88,8),
    glass   = Color3.fromRGB(60,37,20),
    glass2  = Color3.fromRGB(46,30,19),
    side    = Color3.fromRGB(36,24,16),
    row     = Color3.fromRGB(72,44,23),
    active  = Color3.fromRGB(112,62,16),
    text    = Color3.fromRGB(250,247,242),
    sub     = Color3.fromRGB(190,177,163),
    nav     = Color3.fromRGB(226,215,202),
    stroke  = Color3.fromRGB(235,158,79),
    close   = Color3.fromRGB(210,75,95),
    minbtn  = Color3.fromRGB(76,48,28),
    tglOff  = Color3.fromRGB(73,50,32),
}

local LOGO_B64 = [==[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]==]
local function decodeBase64(data)
    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    data = string.gsub(data, "[^"..alphabet.."=]", "")
    return (data:gsub(".", function(ch)
        if ch == "=" then return "" end
        local value = (alphabet:find(ch, 1, true) or 1) - 1
        local bits = ""
        for i = 6, 1, -1 do
            bits = bits .. ((value % 2^i - value % 2^(i-1) > 0) and "1" or "0")
        end
        return bits
    end):gsub("%d%d%d?%d?%d?%d?%d?%d?", function(bits)
        if #bits ~= 8 then return "" end
        local byte = 0
        for i = 1, 8 do
            if bits:sub(i,i) == "1" then byte = byte + 2^(8-i) end
        end
        return string.char(byte)
    end))
end

local function embeddedLogoAsset()
    local getAsset = getcustomasset or getsynasset
    if type(writefile) ~= "function" or type(getAsset) ~= "function" then return nil end
    local iconFile = "glitchhub_rideapet_g_128.png"
    local ok = pcall(function()
        if type(isfile) ~= "function" or not isfile(iconFile) then
            writefile(iconFile, decodeBase64(LOGO_B64))
        end
    end)
    if not ok then return nil end
    local assetOk, asset = pcall(getAsset, iconFile)
    return assetOk and asset or nil
end

local UI_LANG = {
    EN = {},
    RU = {
        ["General"]="Общее", ["Main"]="Главное", ["Player"]="Игрок", ["Auto"]="Авто",
        ["MOVEMENT"]="ДВИЖЕНИЕ", ["PROTECTION"]="ЗАЩИТА", ["PETS & NESTS"]="ПИТОМЦЫ И ГНЁЗДА",
        ["ECONOMY"]="ЭКОНОМИКА", ["PROGRESSION"]="ПРОГРЕСС", ["TARGETS"]="ЦЕЛИ",
        ["SETTINGS"]="НАСТРОЙКИ", ["COMFORT"]="УДОБСТВО", ["INFO"]="ИНФОРМАЦИЯ", ["STORM"]="ШТОРМ",
        ["Steal All Eggs"]="Красть все яйца", ["Steal Best Egg"]="Красть лучшее яйцо",
        ["Min Rarity"]="Мин. редкость", ["Min Mutation"]="Мин. мутация", ["Instant Teleport"]="Мгновенный телепорт",
        ["Speed Boost"]="Ускорение", ["Speed"]="Скорость", ["Fly Speed"]="Скорость полёта",
        ["Anti Stun / Ragdoll"]="Защита от оглушения", ["Anti Trap"]="Защита от ловушек",
        ["Auto Hatch"]="Авто-вылупление", ["Auto Place Best Pets"]="Ставить лучших питомцев",
        ["Auto Feed Pets"]="Авто-кормление", ["Auto Claim Rewards"]="Забирать награды",
        ["Auto Upgrade Hatch Luck"]="Улучшать удачу", ["Auto Unlock Nests"]="Открывать гнёзда",
        ["Auto Rebirth"]="Авто-перерождение", ["ESP Eggs"]="ESP яиц", ["ESP Mutations"]="ESP мутаций",
        ["ESP Players"]="ESP игроков", ["Max Distance"]="Макс. расстояние", ["Anti AFK"]="Анти-AFK",
        ["Remove Background"]="Удалить задний фон",
        ["Notifications"]="Уведомления", ["No storm"]="Шторма нет", ["Storm: %s (x%s)"]="Шторм: %s (x%s)",
        ["Place ID: %s"]="ID игры: %s", ["Player: %s"]="Игрок: %s",
        ["Steal All Eggs ON"]="Кража всех яиц включена", ["Steal Best ON · min: %s"]="Кража лучших включена · мин.: %s",
        ["Teleport ON"]="Телепорт включён", ["Fly mode ON"]="Режим полёта включён",
        ["Auto Hatch ON"]="Авто-вылупление включено", ["Auto Rebirth ON!"]="Авто-перерождение включено!",
        ["ESP Eggs ON"]="ESP яиц включён", ["ESP Mutations ON"]="ESP мутаций включён",
        ["Get keys for Delta, Linkvertise and other services in seconds with this Bypass bot."]="Получай ключи для Delta, Linkvertise и других сервисов с помощью этого Bypass бота за несколько секунд.",
        ["Open bot"]="Перейти", ["Link copied"]="Ссылка скопирована", ["Copy unavailable"]="Не удалось скопировать ссылку",
    },
    DE = {
        ["General"]="Allgemein", ["Main"]="Haupt", ["Player"]="Spieler", ["Auto"]="Auto",
        ["MOVEMENT"]="BEWEGUNG", ["PROTECTION"]="SCHUTZ", ["PETS & NESTS"]="TIERE & NESTER",
        ["ECONOMY"]="WIRTSCHAFT", ["PROGRESSION"]="FORTSCHRITT", ["TARGETS"]="ZIELE",
        ["SETTINGS"]="EINSTELLUNGEN", ["COMFORT"]="KOMFORT", ["INFO"]="INFO", ["STORM"]="STURM",
        ["Steal All Eggs"]="Alle Eier stehlen", ["Steal Best Egg"]="Bestes Ei stehlen",
        ["Min Rarity"]="Min. Seltenheit", ["Min Mutation"]="Min. Mutation", ["Instant Teleport"]="Sofort-Teleport",
        ["Speed Boost"]="Tempo-Boost", ["Speed"]="Tempo", ["Fly Speed"]="Flugtempo",
        ["Anti Stun / Ragdoll"]="Schutz vor Betäubung", ["Anti Trap"]="Fallen-Schutz",
        ["Auto Hatch"]="Auto-Schlüpfen", ["Auto Place Best Pets"]="Beste Tiere platzieren",
        ["Auto Feed Pets"]="Tiere automatisch füttern", ["Auto Claim Rewards"]="Belohnungen abholen",
        ["Auto Upgrade Hatch Luck"]="Glück verbessern", ["Auto Unlock Nests"]="Nester freischalten",
        ["Auto Rebirth"]="Auto-Wiedergeburt", ["ESP Eggs"]="Eier-ESP", ["ESP Mutations"]="Mutations-ESP",
        ["ESP Players"]="Spieler-ESP", ["Max Distance"]="Max. Entfernung", ["Anti AFK"]="Anti-AFK",
        ["Remove Background"]="Hintergrund entfernen",
        ["Notifications"]="Benachrichtigungen", ["No storm"]="Kein Sturm", ["Storm: %s (x%s)"]="Sturm: %s (x%s)",
        ["Place ID: %s"]="Spiel-ID: %s", ["Player: %s"]="Spieler: %s",
        ["Steal All Eggs ON"]="Alle Eier stehlen aktiviert", ["Steal Best ON · min: %s"]="Beste Eier aktiviert · Min.: %s",
        ["Teleport ON"]="Teleport aktiviert", ["Fly mode ON"]="Flugmodus aktiviert",
        ["Auto Hatch ON"]="Auto-Schlüpfen aktiviert", ["Auto Rebirth ON!"]="Auto-Wiedergeburt aktiviert!",
        ["ESP Eggs ON"]="Eier-ESP aktiviert", ["ESP Mutations ON"]="Mutations-ESP aktiviert",
        ["Get keys for Delta, Linkvertise and other services in seconds with this Bypass bot."]="Erhalte in wenigen Sekunden Schlüssel für Delta, Linkvertise und andere Dienste mit diesem Bypass-Bot.",
        ["Open bot"]="Bot öffnen", ["Link copied"]="Link kopiert", ["Copy unavailable"]="Link konnte nicht kopiert werden",
    },
    FR = {
        ["General"]="Général", ["Main"]="Principal", ["Player"]="Joueur", ["Auto"]="Auto",
        ["MOVEMENT"]="MOUVEMENT", ["PROTECTION"]="PROTECTION", ["PETS & NESTS"]="ANIMAUX & NIDS",
        ["ECONOMY"]="ÉCONOMIE", ["PROGRESSION"]="PROGRESSION", ["TARGETS"]="CIBLES",
        ["SETTINGS"]="RÉGLAGES", ["COMFORT"]="CONFORT", ["INFO"]="INFO", ["STORM"]="TEMPÊTE",
        ["Steal All Eggs"]="Voler tous les œufs", ["Steal Best Egg"]="Voler le meilleur œuf",
        ["Min Rarity"]="Rareté min.", ["Min Mutation"]="Mutation min.", ["Instant Teleport"]="Téléportation instantanée",
        ["Speed Boost"]="Accélération", ["Speed"]="Vitesse", ["Fly Speed"]="Vitesse de vol",
        ["Anti Stun / Ragdoll"]="Anti-étourdissement", ["Anti Trap"]="Anti-piège",
        ["Auto Hatch"]="Éclosion auto", ["Auto Place Best Pets"]="Placer les meilleurs animaux",
        ["Auto Feed Pets"]="Nourrir automatiquement", ["Auto Claim Rewards"]="Réclamer les récompenses",
        ["Auto Upgrade Hatch Luck"]="Améliorer la chance", ["Auto Unlock Nests"]="Débloquer les nids",
        ["Auto Rebirth"]="Renaissance auto", ["ESP Eggs"]="ESP œufs", ["ESP Mutations"]="ESP mutations",
        ["ESP Players"]="ESP joueurs", ["Max Distance"]="Distance max.", ["Anti AFK"]="Anti-AFK",
        ["Remove Background"]="Supprimer l’arrière-plan",
        ["Notifications"]="Notifications", ["No storm"]="Aucune tempête", ["Storm: %s (x%s)"]="Tempête : %s (x%s)",
        ["Place ID: %s"]="ID du jeu : %s", ["Player: %s"]="Joueur : %s",
        ["Steal All Eggs ON"]="Vol de tous les œufs activé", ["Steal Best ON · min: %s"]="Vol des meilleurs activé · min. : %s",
        ["Teleport ON"]="Téléportation activée", ["Fly mode ON"]="Mode vol activé",
        ["Auto Hatch ON"]="Éclosion auto activée", ["Auto Rebirth ON!"]="Renaissance auto activée !",
        ["ESP Eggs ON"]="ESP œufs activé", ["ESP Mutations ON"]="ESP mutations activé",
        ["Get keys for Delta, Linkvertise and other services in seconds with this Bypass bot."]="Obtenez en quelques secondes des clés pour Delta, Linkvertise et d’autres services avec ce bot Bypass.",
        ["Open bot"]="Ouvrir le bot", ["Link copied"]="Lien copié", ["Copy unavailable"]="Impossible de copier le lien",
    },
}

local VALUE_LANG = {
    EN = {All="All", Common="Common", Uncommon="Uncommon", Rare="Rare", Epic="Epic", Legendary="Legendary", Mythic="Mythic", Divine="Divine", Ethereal="Ethereal",
        Shocked="Shocked", Volted="Volted", Rage="Rage", Void="Void", Magma="Magma", Eternal="Eternal",
        ["Shocked+"]="Shocked+", ["Volted+"]="Volted+", ["Rage+"]="Rage+", ["Void/Magma+"]="Void/Magma+", ["Eternal Only"]="Eternal Only",
        ["Обычный"]="Common", ["Обычная"]="Common", ["Необычный"]="Uncommon", ["Необычная"]="Uncommon",
        ["Редкий"]="Rare", ["Редкая"]="Rare", ["Эпический"]="Epic", ["Эпическая"]="Epic",
        ["Легендарный"]="Legendary", ["Легендарная"]="Legendary", ["Мифический"]="Mythic", ["Мифическая"]="Mythic",
        ["Божественный"]="Divine", ["Божественная"]="Divine", ["Небесный"]="Ethereal", ["Небесная"]="Ethereal"},
    RU = {All="Все", Common="Обычный", Uncommon="Необычный", Rare="Редкий", Epic="Эпический", Legendary="Легендарный", Mythic="Мифический", Divine="Божественный", Ethereal="Небесный",
        Shocked="Шок", Volted="Вольт", Rage="Ярость", Void="Пустота", Magma="Магма", Eternal="Вечная",
        ["Shocked+"]="Шок+", ["Volted+"]="Вольт+", ["Rage+"]="Ярость+", ["Void/Magma+"]="Пустота/Магма+", ["Eternal Only"]="Только Вечная"},
    DE = {All="Alle", Common="Gewöhnlich", Uncommon="Ungewöhnlich", Rare="Selten", Epic="Episch", Legendary="Legendär", Mythic="Mythisch", Divine="Göttlich", Ethereal="Ätherisch",
        Shocked="Schock", Volted="Volt", Rage="Wut", Void="Leere", Magma="Magma", Eternal="Ewig",
        ["Shocked+"]="Schock+", ["Volted+"]="Volt+", ["Rage+"]="Wut+", ["Void/Magma+"]="Leere/Magma+", ["Eternal Only"]="Nur Ewig"},
    FR = {All="Tous", Common="Commun", Uncommon="Inhabituel", Rare="Rare", Epic="Épique", Legendary="Légendaire", Mythic="Mythique", Divine="Divine", Ethereal="Éthérée",
        Shocked="Choc", Volted="Volt", Rage="Rage", Void="Vide", Magma="Magma", Eternal="Éternelle",
        ["Shocked+"]="Choc+", ["Volted+"]="Volt+", ["Rage+"]="Rage+", ["Void/Magma+"]="Vide/Magma+", ["Eternal Only"]="Éternelle seulement"},
}

local localizedTexts = {}
local languageRefreshHooks = {}
local VALUE_ALIASES = {
    ["Обычный"]="Common", ["Обычная"]="Common",
    ["Необычный"]="Uncommon", ["Необычная"]="Uncommon",
    ["Редкий"]="Rare", ["Редкая"]="Rare",
    ["Эпический"]="Epic", ["Эпическая"]="Epic",
    ["Легендарный"]="Legendary", ["Легендарная"]="Legendary",
    ["Мифический"]="Mythic", ["Мифическая"]="Mythic",
    ["Божественный"]="Divine", ["Божественная"]="Divine",
    ["Небесный"]="Ethereal", ["Небесная"]="Ethereal",
}
local function tr(key)
    local lang = UI_LANG[S.uiLang] or UI_LANG.EN
    return lang[key] or key
end
local function canonicalValue(value)
    value = VALUE_ALIASES[value] or value
    for code, language in pairs(VALUE_LANG) do
        if code ~= "EN" then
        for source, translated in pairs(language) do
            if translated == value then return source end
        end
        end
    end
    return value
end
local function trValue(value)
    value = canonicalValue(value)
    local lang = VALUE_LANG[S.uiLang] or VALUE_LANG.EN
    return lang[value] or VALUE_LANG.EN[value] or tostring(value)
end
local function disableRobloxAutoLocalization(object)
    pcall(function()
        if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
            object.AutoLocalize = false
        end
    end)
end
local function bindText(object, key)
    disableRobloxAutoLocalization(object)
    localizedTexts[object] = key; object.Text = tr(key); return object
end
local function refreshLanguage()
    for object, key in pairs(localizedTexts) do
        if object.Parent then object.Text = tr(key) end
    end
    for _, callback in ipairs(languageRefreshHooks) do pcall(callback) end
end

local TABS = {"General","Main","Player","Auto","ESP"}
local screenGui, mainFrame, bodyFrame
local tabBtns, tabBars, tabLabels, tabPages = {}, {}, {}, {}
local minimized = false

local function corner(p, r)
    local u = Instance.new("UICorner", p); u.CornerRadius = UDim.new(0, r or 8); return u
end

local function stroke(p, transparency, thickness)
    local s = Instance.new("UIStroke", p)
    s.Color = T.stroke; s.Transparency = transparency or 0.82; s.Thickness = thickness or 1
    return s
end

local function outsideRoundedBackground(parent, side, color, transparency)
    local rect = Instance.new("Frame", parent)
    rect.Size = UDim2.new(1,-22,1,0)
    rect.Position = side == "Left" and UDim2.new(0,22,0,0) or UDim2.new(0,0,0,0)
    rect.BackgroundColor3 = color; rect.BackgroundTransparency = transparency
    rect.BorderSizePixel = 0

    local clip = Instance.new("Frame", parent)
    clip.Size = UDim2.new(0,22,1,0)
    clip.Position = side == "Left" and UDim2.new(0,0,0,0) or UDim2.new(1,-22,0,0)
    clip.BackgroundTransparency = 1; clip.BorderSizePixel = 0; clip.ClipsDescendants = true

    local cap = Instance.new("Frame", clip)
    cap.Size = UDim2.new(0,44,1,0)
    cap.Position = side == "Left" and UDim2.new(0,0,0,0) or UDim2.new(0,-22,0,0)
    cap.BackgroundColor3 = color; cap.BackgroundTransparency = transparency
    cap.BorderSizePixel = 0; corner(cap, 22)
end

local function glassRow(parent, height)
    local row = Instance.new("Frame", parent)
    row.Size = UDim2.new(1,-4,0,height); row.BackgroundColor3 = T.row
    row.BackgroundTransparency = 0.10; row.BorderSizePixel = 0
    corner(row, 12); stroke(row, 0.86, 1)
    return row
end

local function flagPiece(parent, size, position, color, rotation, zindex)
    local piece = Instance.new("Frame", parent)
    piece.Name = "FlagPiece"; piece.Size = size; piece.Position = position
    piece.AnchorPoint = Vector2.new(0.5,0.5); piece.BackgroundColor3 = color
    piece.BorderSizePixel = 0; piece.Rotation = rotation or 0; piece.ZIndex = zindex or 22
    return piece
end

local function drawFlag(slot, code)
    for _, child in ipairs(slot:GetChildren()) do
        if child.Name == "FlagPiece" then child:Destroy() end
    end
    slot.BackgroundColor3 = code == "DE" and Color3.fromRGB(0,0,0)
        or code == "FR" and Color3.fromRGB(255,255,255)
        or code == "EN" and Color3.fromRGB(25,55,130)
        or Color3.fromRGB(255,255,255)
    if code == "RU" then
        flagPiece(slot, UDim2.new(1,0,0.34,0), UDim2.new(0.5,0,0.50,0), Color3.fromRGB(35,80,185))
        flagPiece(slot, UDim2.new(1,0,0.34,0), UDim2.new(0.5,0,0.83,0), Color3.fromRGB(220,45,55))
    elseif code == "DE" then
        flagPiece(slot, UDim2.new(1,0,0.34,0), UDim2.new(0.5,0,0.50,0), Color3.fromRGB(215,35,45))
        flagPiece(slot, UDim2.new(1,0,0.34,0), UDim2.new(0.5,0,0.83,0), Color3.fromRGB(245,195,35))
    elseif code == "FR" then
        flagPiece(slot, UDim2.new(0.34,0,1,0), UDim2.new(0.17,0,0.5,0), Color3.fromRGB(35,70,170))
        flagPiece(slot, UDim2.new(0.34,0,1,0), UDim2.new(0.83,0,0.5,0), Color3.fromRGB(225,45,55))
    else
        flagPiece(slot, UDim2.new(1.45,0,0,4), UDim2.new(0.5,0,0.5,0), Color3.fromRGB(245,245,245), 34)
        flagPiece(slot, UDim2.new(1.45,0,0,4), UDim2.new(0.5,0,0.5,0), Color3.fromRGB(245,245,245), -34)
        flagPiece(slot, UDim2.new(1.45,0,0,2), UDim2.new(0.5,0,0.5,0), Color3.fromRGB(210,35,55), 34, 23)
        flagPiece(slot, UDim2.new(1.45,0,0,2), UDim2.new(0.5,0,0.5,0), Color3.fromRGB(210,35,55), -34, 23)
        flagPiece(slot, UDim2.new(1,0,0,5), UDim2.new(0.5,0,0.5,0), Color3.fromRGB(245,245,245), 0, 24)
        flagPiece(slot, UDim2.new(0,5,1,0), UDim2.new(0.5,0,0.5,0), Color3.fromRGB(245,245,245), 0, 24)
        flagPiece(slot, UDim2.new(1,0,0,3), UDim2.new(0.5,0,0.5,0), Color3.fromRGB(205,30,50), 0, 25)
        flagPiece(slot, UDim2.new(0,3,1,0), UDim2.new(0.5,0,0.5,0), Color3.fromRGB(205,30,50), 0, 25)
    end
end

local function mkScroll(parent)
    local sf = Instance.new("ScrollingFrame", parent)
    sf.Size = UDim2.new(1,-12,1,-20); sf.Position = UDim2.new(0,4,0,10)
    sf.BackgroundTransparency = 1; sf.BorderSizePixel = 0
    sf.ScrollBarThickness = 3; sf.ScrollBarImageColor3 = T.accent
    sf.ScrollBarImageTransparency = 0.18
    sf.CanvasSize = UDim2.new(0,0,0,0); sf.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local lay = Instance.new("UIListLayout", sf)
    lay.Padding = UDim.new(0,10); lay.SortOrder = Enum.SortOrder.LayoutOrder
    local pad = Instance.new("UIPadding", sf)
    pad.PaddingLeft = UDim.new(0,12); pad.PaddingRight = UDim.new(0,10)
    pad.PaddingTop = UDim.new(0,11); pad.PaddingBottom = UDim.new(0,14)
    return sf
end

local function mkSep(p)
    local f = Instance.new("Frame", p); f.Size = UDim2.new(1,-4,0,1)
    f.BackgroundColor3 = T.stroke; f.BackgroundTransparency = 0.88; f.BorderSizePixel = 0
    return f
end

local function mkLabel(p, t)
    local lb = Instance.new("TextLabel", p); lb.Size = UDim2.new(1,-4,0,16)
    lb.BackgroundTransparency = 1; lb.TextColor3 = T.sub
    lb.Font = Enum.Font.GothamBold; lb.TextSize = 10
    lb.TextXAlignment = Enum.TextXAlignment.Left; bindText(lb, t)
    return lb
end

local function mkToggle(p, label, key, cb)
    local row = glassRow(p, 38)
    local txt = Instance.new("TextLabel", row)
    txt.Size = UDim2.new(1,-70,1,0); txt.Position = UDim2.new(0,12,0,0)
    txt.BackgroundTransparency = 1; txt.TextColor3 = T.text; txt.Font = Enum.Font.GothamBold; txt.TextSize = 12
    txt.TextXAlignment = Enum.TextXAlignment.Left; bindText(txt, label)
    local trk = Instance.new("Frame", row)
    trk.Size = UDim2.new(0,42,0,22); trk.Position = UDim2.new(1,-54,0.5,-11)
    trk.BackgroundColor3 = S[key] and T.accent or T.tglOff; trk.BorderSizePixel = 0; corner(trk, 11)
    local knob = Instance.new("Frame", trk)
    knob.Size = UDim2.new(0,16,0,16)
    knob.Position = S[key] and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)
    knob.BackgroundColor3 = T.text; knob.BorderSizePixel = 0; corner(knob, 8)
    local btn = Instance.new("TextButton", row)
    btn.Size = UDim2.new(1,0,1,0); btn.BackgroundTransparency = 1; btn.Text = ""
    btn.MouseButton1Click:Connect(function()
        S[key] = not S[key]
        TweenSvc:Create(trk, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {
            BackgroundColor3 = S[key] and T.accent or T.tglOff
        }):Play()
        TweenSvc:Create(knob, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {
            Position = S[key] and UDim2.new(1,-19,0.5,-8) or UDim2.new(0,3,0.5,-8)
        }):Play()
        if cb then pcall(cb, S[key]) end
    end)
    return row
end

local function mkSlider(p, label, key, mn, mx, step)
    local row = glassRow(p, 52)
    local txt = Instance.new("TextLabel", row)
    txt.Size = UDim2.new(1,-65,0,22); txt.Position = UDim2.new(0,12,0,4)
    txt.BackgroundTransparency = 1; txt.TextColor3 = T.text; txt.Font = Enum.Font.GothamBold; txt.TextSize = 12
    txt.TextXAlignment = Enum.TextXAlignment.Left; bindText(txt, label)
    local vl = Instance.new("TextLabel", row)
    vl.Size = UDim2.new(0,50,0,22); vl.Position = UDim2.new(1,-62,0,4)
    vl.BackgroundTransparency = 1; vl.TextColor3 = T.accent; vl.Font = Enum.Font.GothamBold
    vl.TextSize = 12; vl.TextXAlignment = Enum.TextXAlignment.Right; vl.Text = tostring(S[key])
    local bar = Instance.new("Frame", row)
    bar.Size = UDim2.new(1,-24,0,6); bar.Position = UDim2.new(0,12,0,35)
    bar.BackgroundColor3 = T.tglOff; bar.BorderSizePixel = 0; corner(bar, 3)
    local fill = Instance.new("Frame", bar)
    fill.BackgroundColor3 = T.accent; fill.BorderSizePixel = 0; corner(fill, 3)
    local knob = Instance.new("Frame", bar)
    knob.Size = UDim2.new(0,14,0,14); knob.AnchorPoint = Vector2.new(0.5,0.5)
    knob.BackgroundColor3 = T.text; knob.BorderSizePixel = 0; corner(knob, 7); stroke(knob, 0.72, 1)
    local hit = Instance.new("TextButton", row)
    hit.Size = UDim2.new(1,-14,0,24); hit.Position = UDim2.new(0,7,0,25)
    hit.BackgroundTransparency = 1; hit.Text = ""; hit.ZIndex = 5
    local draggingSlider = false
    local function render()
        local alpha = math.clamp((S[key]-mn)/(mx-mn), 0, 1)
        fill.Size = UDim2.new(alpha,0,1,0)
        knob.Position = UDim2.new(alpha,0,0.5,0)
        vl.Text = tostring(S[key])
    end
    local function setFromX(x)
        local width = math.max(bar.AbsoluteSize.X, 1)
        local alpha = math.clamp((x-bar.AbsolutePosition.X)/width, 0, 1)
        local raw = mn + (mx-mn)*alpha
        local quantum = step or 1
        S[key] = math.clamp(math.floor(raw/quantum + 0.5)*quantum, mn, mx)
        render()
    end
    hit.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = true; setFromX(inp.Position.X)
        end
    end)
    trackConn(UIS.InputChanged:Connect(function(inp)
        if draggingSlider and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
            setFromX(inp.Position.X)
        end
    end))
    trackConn(UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
            draggingSlider = false
        end
    end))
    render()
    return row
end

local function mkPicker(p, label, key, opts, cb)
    local sourceValue = canonicalValue(S[key])
    local currentIndex = 1
    for i, option in ipairs(opts) do
        if option == sourceValue then currentIndex = i; break end
    end
    S[key] = opts[currentIndex]

    local row = glassRow(p, 38)
    local lb2 = Instance.new("TextLabel", row)
    lb2.Size = UDim2.new(0.43,0,1,0); lb2.Position = UDim2.new(0,12,0,0)
    lb2.BackgroundTransparency = 1; lb2.TextColor3 = T.text; lb2.Font = Enum.Font.GothamBold; lb2.TextSize = 12
    lb2.TextXAlignment = Enum.TextXAlignment.Left; bindText(lb2, label)
    local prev = Instance.new("TextButton", row)
    prev.Size = UDim2.new(0,24,0,24); prev.Position = UDim2.new(0.43,0,0.5,-12)
    prev.BackgroundColor3 = T.active; prev.BackgroundTransparency = 0.18; prev.Text = "‹"; prev.TextColor3 = T.accent
    prev.Font = Enum.Font.GothamBold; prev.TextSize = 16; prev.BorderSizePixel = 0; corner(prev, 7)
    local vl = Instance.new("TextLabel", row)
    vl.Size = UDim2.new(0.57,-58,1,0); vl.Position = UDim2.new(0.43,29,0,0)
    vl.BackgroundTransparency = 1; vl.TextColor3 = T.text; vl.Font = Enum.Font.GothamBold
    vl.TextSize = 11; vl.TextTruncate = Enum.TextTruncate.AtEnd
    disableRobloxAutoLocalization(vl)
    local nxt = Instance.new("TextButton", row)
    nxt.Size = UDim2.new(0,24,0,24); nxt.Position = UDim2.new(1,-31,0.5,-12)
    nxt.BackgroundColor3 = T.active; nxt.BackgroundTransparency = 0.18; nxt.Text = "›"; nxt.TextColor3 = T.accent
    nxt.Font = Enum.Font.GothamBold; nxt.TextSize = 16; nxt.BorderSizePixel = 0; corner(nxt, 7)
    local function refreshPicker()
        local source = opts[currentIndex]
        S[key] = source
        local language = VALUE_LANG[S.uiLang] or VALUE_LANG.EN
        vl.Text = language[source] or VALUE_LANG.EN[source] or source
        prev.Active = currentIndex > 1; prev.AutoButtonColor = currentIndex > 1
        prev.TextColor3 = currentIndex > 1 and T.accent or T.sub
        prev.BackgroundTransparency = currentIndex > 1 and 0.18 or 0.62
        nxt.Active = currentIndex < #opts; nxt.AutoButtonColor = currentIndex < #opts
        nxt.TextColor3 = currentIndex < #opts and T.accent or T.sub
        nxt.BackgroundTransparency = currentIndex < #opts and 0.18 or 0.62
    end
    prev.MouseButton1Click:Connect(function()
        if currentIndex <= 1 then return end
        currentIndex = currentIndex - 1; refreshPicker()
        if cb then pcall(cb, S[key]) end
    end)
    nxt.MouseButton1Click:Connect(function()
        if currentIndex >= #opts then return end
        currentIndex = currentIndex + 1; refreshPicker()
        if cb then pcall(cb, S[key]) end
    end)
    languageRefreshHooks[#languageRefreshHooks+1] = refreshPicker
    refreshPicker()
    return row
end

local function setTab(name)
    for _, t in ipairs(TABS) do
        if tabBtns[t] then
            tabBtns[t].BackgroundTransparency = (t == name) and 0.35 or 1
        end
        if tabLabels[t] then tabLabels[t].TextColor3 = (t == name) and T.text or T.nav end
        if tabBars[t] then tabBars[t].Visible = (t == name) end
        if tabPages[t] then tabPages[t].Visible = (t == name) end
    end
end

local function buildGui()
    local pg = LP:FindFirstChildOfClass("PlayerGui")
    if not pg then
        for i = 1, 12 do task.wait(0.5); pg = LP:FindFirstChildOfClass("PlayerGui"); if pg then break end end
    end
    if not pg then return end

    local old = pg:FindFirstChild("GlitchHub"); if old then old:Destroy() end
    screenGui = Instance.new("ScreenGui")
    screenGui.Name = "GlitchHub"; screenGui.ResetOnSpawn = false; screenGui.IgnoreGuiInset = true
    screenGui.DisplayOrder = 999; screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    trackConn(screenGui.DescendantAdded:Connect(disableRobloxAutoLocalization))
    pcall(function() if syn then syn.protect_gui(screenGui) end end)
    screenGui.Parent = pg

    local mob = WS.CurrentCamera and WS.CurrentCamera.ViewportSize.X < 620
    local W = mob and 360 or 560; local H = mob and 390 or 400; local SW = mob and 92 or 132

    mainFrame = Instance.new("Frame", screenGui)
    mainFrame.Name = "Main"; mainFrame.Size = UDim2.new(0,W,0,H)
    mainFrame.Position = UDim2.new(0.5,-W/2,0.5,-H/2)
    mainFrame.BackgroundColor3 = T.glass; mainFrame.BackgroundTransparency = S.removeBackground and 1 or 0.12
    mainFrame.BorderSizePixel = 0; mainFrame.ClipsDescendants = true
    corner(mainFrame, 22)

    local tb = Instance.new("Frame", mainFrame)
    tb.Size = UDim2.new(1,0,0,44); tb.BackgroundColor3 = T.side
    tb.BackgroundTransparency = 0.15; tb.BorderSizePixel = 0; tb.ZIndex = 10; corner(tb, 22)
    local logo = Instance.new("ImageLabel", tb)
    logo.Size = UDim2.new(0,26,0,26); logo.Position = UDim2.new(0,12,0.5,-13)
    logo.BackgroundColor3 = T.active; logo.BackgroundTransparency = 0.05; logo.BorderSizePixel = 0
    logo.ClipsDescendants = true; logo.ScaleType = Enum.ScaleType.Crop; logo.ZIndex = 12
    corner(logo, 8); stroke(logo, 0.62, 1)
    local logoAsset = embeddedLogoAsset()
    if logoAsset then
        logo.Image = logoAsset
    else
        local fallback = Instance.new("TextLabel", logo)
        fallback.Size = UDim2.new(1,0,1,0); fallback.BackgroundTransparency = 1
        fallback.Text = "G"; fallback.TextColor3 = Color3.fromRGB(255,220,35)
        fallback.Font = Enum.Font.GothamBlack; fallback.TextSize = 17; fallback.ZIndex = 13
    end
    local titlbl = Instance.new("TextLabel", tb)
    titlbl.Size = UDim2.new(0,mob and 130 or 174,1,0); titlbl.Position = UDim2.new(0,46,0,0)
    titlbl.BackgroundTransparency = 1; titlbl.Text = "Glitch  ·  Ride A Pet"
    titlbl.TextColor3 = T.text; titlbl.Font = Enum.Font.GothamBold
    titlbl.TextSize = mob and 11 or 14; titlbl.TextXAlignment = Enum.TextXAlignment.Left
    titlbl.TextTruncate = Enum.TextTruncate.AtEnd; titlbl.ZIndex = 12
    local function mkTBtn(xOff, sym, col)
        local b = Instance.new("TextButton", tb)
        b.Size = UDim2.new(0,28,0,28); b.Position = UDim2.new(1,xOff,0.5,-14)
        b.BackgroundColor3 = col; b.BackgroundTransparency = 0.22; b.BorderSizePixel = 0; b.Text = sym
        b.TextColor3 = T.text; b.Font = Enum.Font.GothamBold; b.TextSize = 13; b.ZIndex = 20; corner(b, 9)
        stroke(b, 0.87, 1)
        return b
    end
    local langBtn  = mkTBtn(-98, "", T.minbtn)
    local minBtn   = mkTBtn(-66, "−", T.minbtn)
    local closeBtn = mkTBtn(-34, "×", T.close)
    local currentFlag = Instance.new("Frame", langBtn)
    currentFlag.Size = UDim2.new(0,19,0,13); currentFlag.Position = UDim2.new(0.5,-9.5,0.5,-6.5)
    currentFlag.BorderSizePixel = 0; currentFlag.ClipsDescendants = true; currentFlag.ZIndex = 21
    corner(currentFlag, 3); stroke(currentFlag, 0.58, 1); drawFlag(currentFlag, S.uiLang)

    local langMenu = Instance.new("Frame", mainFrame)
    langMenu.Size = UDim2.new(0,130,0,38); langMenu.Position = UDim2.new(1,-168,0,40)
    langMenu.BackgroundColor3 = T.side; langMenu.BackgroundTransparency = 0.03
    langMenu.BorderSizePixel = 0; langMenu.Visible = false; langMenu.ZIndex = 50
    corner(langMenu, 11); stroke(langMenu, 0.70, 1)
    local langLayout = Instance.new("UIListLayout", langMenu)
    langLayout.FillDirection = Enum.FillDirection.Horizontal
    langLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    langLayout.VerticalAlignment = Enum.VerticalAlignment.Center; langLayout.Padding = UDim.new(0,3)
    local langChoices = {}
    local function refreshLangChoices()
        for code, choice in pairs(langChoices) do
            choice.BackgroundColor3 = code == S.uiLang and T.accent2 or T.active
            choice.BackgroundTransparency = code == S.uiLang and 0.02 or 0.20
        end
    end
    for _, code in ipairs({"RU","EN","FR","DE"}) do
        local choice = Instance.new("TextButton", langMenu)
        choice.Name = code; choice.Size = UDim2.new(0,28,0,28)
        choice.BackgroundColor3 = code == S.uiLang and T.accent2 or T.active
        choice.BackgroundTransparency = code == S.uiLang and 0.02 or 0.20
        choice.BorderSizePixel = 0; choice.Text = ""; choice.ZIndex = 51
        corner(choice, 8)
        local flag = Instance.new("Frame", choice)
        flag.Size = UDim2.new(0,20,0,14); flag.Position = UDim2.new(0.5,-10,0.5,-7)
        flag.BorderSizePixel = 0; flag.ClipsDescendants = true; flag.ZIndex = 52
        corner(flag, 3); stroke(flag, 0.58, 1); drawFlag(flag, code)
        langChoices[code] = choice
        choice.MouseButton1Click:Connect(function()
            S.uiLang = code; drawFlag(currentFlag, code); refreshLanguage(); refreshLangChoices(); langMenu.Visible = false
        end)
    end
    refreshLangChoices()
    langBtn.MouseButton1Click:Connect(function() langMenu.Visible = not langMenu.Visible end)

    bodyFrame = Instance.new("Frame", mainFrame)
    bodyFrame.Name = "Body"; bodyFrame.Size = UDim2.new(1,0,1,-48)
    bodyFrame.Position = UDim2.new(0,0,0,48); bodyFrame.BackgroundTransparency = 1
    bodyFrame.ClipsDescendants = true

    local sidebar = Instance.new("Frame", bodyFrame)
    sidebar.Size = UDim2.new(0,SW,1,0); sidebar.BackgroundColor3 = T.side
    sidebar.BackgroundTransparency = 1; sidebar.BorderSizePixel = 0
    outsideRoundedBackground(sidebar, "Left", T.side, 0.08)
    local navHolder = Instance.new("Frame", sidebar)
    navHolder.Size = UDim2.new(1,0,1,0); navHolder.BackgroundTransparency = 1
    local sLay = Instance.new("UIListLayout", navHolder)
    sLay.Padding = UDim.new(0,4); sLay.SortOrder = Enum.SortOrder.LayoutOrder
    local sPad = Instance.new("UIPadding", navHolder)
    sPad.PaddingTop = UDim.new(0,10); sPad.PaddingBottom = UDim.new(0,8)
    sPad.PaddingLeft = UDim.new(0,10); sPad.PaddingRight = UDim.new(0,8)

    local content = Instance.new("Frame", bodyFrame)
    content.Size = UDim2.new(1,-SW,1,0); content.Position = UDim2.new(0,SW,0,0)
    content.BackgroundColor3 = T.glass2; content.BackgroundTransparency = 1
    content.BorderSizePixel = 0; content.ClipsDescendants = true
    outsideRoundedBackground(content, "Right", T.glass2, 0.25)

    for i, tabName in ipairs(TABS) do
        local tbtn = Instance.new("TextButton", navHolder)
        tbtn.Name = tabName; tbtn.Size = UDim2.new(1,0,0,34)
        tbtn.BackgroundColor3 = T.active; tbtn.BackgroundTransparency = 1; tbtn.BorderSizePixel = 0
        tbtn.Text = ""; tbtn.TextColor3 = T.sub
        tbtn.LayoutOrder = i; corner(tbtn, 10)
        local activeBar = Instance.new("Frame", tbtn)
        activeBar.Name = "Accent"; activeBar.Size = UDim2.new(0,3,0,16)
        activeBar.Position = UDim2.new(0,2,0.5,-8); activeBar.BackgroundColor3 = T.accent
        activeBar.BorderSizePixel = 0; activeBar.Visible = false; corner(activeBar, 2)
        local navText = Instance.new("TextLabel", tbtn)
        navText.Size = UDim2.new(1,-20,1,0); navText.Position = UDim2.new(0,14,0,0)
        navText.BackgroundTransparency = 1; navText.TextColor3 = T.nav; navText.Font = Enum.Font.GothamBold
        navText.TextSize = mob and 11 or 13; navText.TextXAlignment = Enum.TextXAlignment.Left
        bindText(navText, tabName)
        tabBtns[tabName] = tbtn
        tabLabels[tabName] = navText
        tabBars[tabName] = activeBar
        local tpage = Instance.new("Frame", content)
        tpage.Name = tabName.."_P"; tpage.Size = UDim2.new(1,0,1,0)
        tpage.BackgroundTransparency = 1; tpage.Visible = false
        tabPages[tabName] = tpage
        tbtn.MouseButton1Click:Connect(function() setTab(tabName) end)
    end

    local dragging, dS, fS = false, nil, nil
    tb.InputBegan:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then
            dragging = true; dS = inp.Position; fS = mainFrame.Position
        end
    end)
    trackConn(UIS.InputChanged:Connect(function(inp)
        if dragging and (inp.UserInputType == Enum.UserInputType.MouseMovement
        or inp.UserInputType == Enum.UserInputType.Touch) then
            local d = inp.Position - dS
            mainFrame.Position = UDim2.new(fS.X.Scale, fS.X.Offset+d.X, fS.Y.Scale, fS.Y.Offset+d.Y)
        end
    end))
    trackConn(UIS.InputEnded:Connect(function(inp)
        if inp.UserInputType == Enum.UserInputType.MouseButton1
        or inp.UserInputType == Enum.UserInputType.Touch then dragging = false end
    end))

    minBtn.MouseButton1Click:Connect(function()
        minimized = not minimized; bodyFrame.Visible = not minimized; langMenu.Visible = false
        mainFrame.BackgroundTransparency = minimized and 1 or (S.removeBackground and 1 or 0.12)
        mainFrame.Size = minimized and UDim2.new(0,W,0,44) or UDim2.new(0,W,0,H)
        minBtn.Text = minimized and "+" or "−"
    end)
    closeBtn.MouseButton1Click:Connect(function()
        S.farmAll=false; S.farmBest=false; S.autoHatch=false; S.autoClaim=false
        S.autoPlace=false; S.autoFeed=false; S.autoRebirth=false
        S.autoLuck=false; S.autoUnlock=false
        S.espEggs=false; S.espPlayers=false; S.espMutation=false
        moving=false; clearFly(); clearEsp()
        if espConn then pcall(function() espConn:Disconnect() end) end
        if modConn  then pcall(function() modConn:Disconnect() end) end
        screenGui:Destroy()
    end)

    do
        local sc = mkScroll(tabPages["Main"])
        mkToggle(sc, "Steal All Eggs", "farmAll", function(v)
            if v then task.spawn(collectLoop) end
        end)
        mkToggle(sc, "Steal Best Egg", "farmBest", function(v)
            if v then task.spawn(collectLoop) end
        end)
        mkPicker(sc, "Min Rarity", "minRarity", RARITY_LIST)
        mkPicker(sc, "Min Mutation", "minMutation", {"All","Shocked+","Volted+","Rage+","Void/Magma+","Eternal Only"})
        mkSep(sc)
        mkToggle(sc, "Instant Teleport", "teleport", nil)
    end

    do
        local sc = mkScroll(tabPages["Player"])
        mkLabel(sc, "MOVEMENT")
        mkToggle(sc, "Speed Boost", "speedOn", function(v)
            applyMods(); if not v then local hu = hum(); if hu then hu.WalkSpeed = 16 end end
        end)
        mkSlider(sc, "Speed", "speed", 16, 250, 10)
        mkSlider(sc, "Fly Speed", "flySpeed", 20, 500, 20)
        mkSep(sc); mkLabel(sc, "PROTECTION")
        mkToggle(sc, "Anti Stun / Ragdoll", "antiStun", function() applyMods() end)
        mkToggle(sc, "Anti Trap", "antiTrap", nil)
    end

    do
        local sc = mkScroll(tabPages["Auto"])
        mkLabel(sc, "PETS & NESTS")
        mkToggle(sc, "Auto Hatch", "autoHatch", function(v)
            if v then task.spawn(farmLoop) end
        end)
        mkToggle(sc, "Auto Place Best Pets", "autoPlace", function(v)
            if v then task.spawn(farmLoop) end
        end)
        mkToggle(sc, "Auto Feed Pets", "autoFeed", function(v)
            if v then task.spawn(farmLoop) end
        end)
        mkSep(sc); mkLabel(sc, "ECONOMY")
        mkToggle(sc, "Auto Claim Rewards", "autoClaim", function(v)
            if v then task.spawn(farmLoop) end
        end)
        mkToggle(sc, "Auto Upgrade Hatch Luck", "autoLuck", function(v)
            if v then task.spawn(farmLoop) end
        end)
        mkToggle(sc, "Auto Unlock Nests", "autoUnlock", function(v)
            if v then task.spawn(farmLoop) end
        end)
        mkSep(sc); mkLabel(sc, "PROGRESSION")
        mkToggle(sc, "Auto Rebirth", "autoRebirth", function(v)
            if v then task.spawn(farmLoop) end
        end)
    end

    do
        local sc = mkScroll(tabPages["ESP"])
        mkLabel(sc, "TARGETS")
        mkToggle(sc, "ESP Eggs", "espEggs", function(v)
            if v then startEsp() else clearEsp() end
        end)
        mkToggle(sc, "ESP Mutations", "espMutation", function(v)
            if v then startEsp() else clearEsp() end
        end)
        mkToggle(sc, "ESP Players", "espPlayers", function(v) if v then startEsp() end end)
        mkSep(sc); mkLabel(sc, "SETTINGS")
        mkPicker(sc, "Min Rarity", "espMinRarity", RARITY_LIST)
        mkSlider(sc, "Max Distance", "espMaxDist", 100, 1000, 100)
    end

    do
        local sc = mkScroll(tabPages["General"])
        local botUrl = "https://t.me/bypas_bot"
        local promo = glassRow(sc, 112)
        promo.BackgroundColor3 = T.active; promo.BackgroundTransparency = 0.08; promo.ClipsDescendants = true
        local promoGradient = Instance.new("UIGradient", promo)
        promoGradient.Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(96,49,12)),
            ColorSequenceKeypoint.new(0.42, Color3.fromRGB(145,73,10)),
            ColorSequenceKeypoint.new(0.52, Color3.fromRGB(205,112,22)),
            ColorSequenceKeypoint.new(0.62, Color3.fromRGB(145,73,10)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(96,49,12)),
        })
        promoGradient.Rotation = 8; promoGradient.Offset = Vector2.new(-1.15,0)
        TweenSvc:Create(promoGradient, TweenInfo.new(3.2, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false, 0.65), {
            Offset = Vector2.new(1.15,0)
        }):Play()
        local promoStroke = promo:FindFirstChildOfClass("UIStroke")
        if promoStroke then
            promoStroke.Color = T.accent
            TweenSvc:Create(promoStroke, TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), {
                Transparency = 0.48
            }):Play()
        end
        local shine = Instance.new("Frame", promo)
        shine.Size = UDim2.new(0,42,1,54); shine.Position = UDim2.new(0,-76,0.5,-83)
        shine.BackgroundColor3 = Color3.fromRGB(255,205,120); shine.BackgroundTransparency = 0.82
        shine.BorderSizePixel = 0; shine.Rotation = 12; shine.ZIndex = 1
        local shineGradient = Instance.new("UIGradient", shine)
        shineGradient.Transparency = NumberSequence.new({
            NumberSequenceKeypoint.new(0,1), NumberSequenceKeypoint.new(0.5,0.18), NumberSequenceKeypoint.new(1,1)
        })
        TweenSvc:Create(shine, TweenInfo.new(2.7, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, false, 1.1), {
            Position = UDim2.new(1,50,0.5,-83)
        }):Play()
        local promoText = Instance.new("TextLabel", promo)
        promoText.Size = UDim2.new(1,-28,0,48); promoText.Position = UDim2.new(0,14,0,9)
        promoText.BackgroundTransparency = 1; promoText.TextColor3 = T.text
        promoText.Font = Enum.Font.GothamBold; promoText.TextSize = 12
        promoText.TextWrapped = true; promoText.TextXAlignment = Enum.TextXAlignment.Left
        promoText.TextYAlignment = Enum.TextYAlignment.Top; promoText.ZIndex = 3
        bindText(promoText, "Get keys for Delta, Linkvertise and other services in seconds with this Bypass bot.")
        local urlLabel = Instance.new("TextLabel", promo)
        urlLabel.Size = UDim2.new(1,-132,0,30); urlLabel.Position = UDim2.new(0,14,1,-39)
        urlLabel.BackgroundTransparency = 1; urlLabel.Text = "t.me/bypas_bot"
        urlLabel.TextColor3 = T.sub; urlLabel.Font = Enum.Font.GothamSemibold
        urlLabel.TextSize = 10; urlLabel.TextXAlignment = Enum.TextXAlignment.Left; urlLabel.ZIndex = 3
        local openBot = Instance.new("TextButton", promo)
        openBot.Size = UDim2.new(0,104,0,30); openBot.Position = UDim2.new(1,-116,1,-39)
        openBot.BackgroundColor3 = T.accent2; openBot.BackgroundTransparency = 0.04
        openBot.BorderSizePixel = 0; openBot.Text = ""; openBot.ZIndex = 3; corner(openBot, 9); stroke(openBot, 0.70, 1)
        local openText = Instance.new("TextLabel", openBot)
        openText.Size = UDim2.new(1,-28,1,0); openText.Position = UDim2.new(0,10,0,0)
        openText.BackgroundTransparency = 1; openText.TextColor3 = T.text
        openText.Font = Enum.Font.GothamBold; openText.TextSize = 11
        openText.TextXAlignment = Enum.TextXAlignment.Left; openText.ZIndex = 4; bindText(openText, "Open bot")
        local openArrow = Instance.new("TextLabel", openBot)
        openArrow.Size = UDim2.new(0,20,1,0); openArrow.Position = UDim2.new(1,-24,0,0)
        openArrow.BackgroundTransparency = 1; openArrow.Text = "›"; openArrow.TextColor3 = T.text
        openArrow.Font = Enum.Font.GothamBold; openArrow.TextSize = 18; openArrow.ZIndex = 4
        local copyStatus = Instance.new("TextLabel", sc)
        copyStatus.Size = UDim2.new(1,-4,0,18); copyStatus.BackgroundTransparency = 1
        copyStatus.TextColor3 = T.accent; copyStatus.Font = Enum.Font.GothamBold
        copyStatus.TextSize = 10; copyStatus.TextXAlignment = Enum.TextXAlignment.Left
        copyStatus.Visible = false
        local statusKey, statusToken = "Link copied", 0
        languageRefreshHooks[#languageRefreshHooks+1] = function()
            if copyStatus.Visible then copyStatus.Text = tr(statusKey) end
        end
        openBot.MouseButton1Click:Connect(function()
            local env = (type(getgenv) == "function" and getgenv()) or _G
            local clipboard = rawget(env, "setclipboard") or rawget(env, "toclipboard") or rawget(_G, "setclipboard")
            local copied = type(clipboard) == "function" and pcall(clipboard, botUrl)
            local opened = false
            for _, name in ipairs({"openurl","open_url","launchurl","openbrowser"}) do
                local opener = rawget(env, name) or rawget(_G, name)
                if type(opener) == "function" then
                    opened = pcall(opener, botUrl)
                    if opened then break end
                end
            end
            if not opened then opened = pcall(function() GuiSvc:OpenBrowserWindow(botUrl) end) end
            if not opened then pcall(function() StarterGui:SetCore("OpenBrowser", botUrl) end) end
            statusKey = copied and "Link copied" or "Copy unavailable"
            copyStatus.Text = tr(statusKey); copyStatus.Visible = true
            statusToken = statusToken + 1; local myToken = statusToken
            task.delay(5, function()
                if myToken == statusToken and copyStatus and copyStatus.Parent then copyStatus.Visible = false end
            end)
        end)
        mkSep(sc)
        mkLabel(sc, "COMFORT")
        mkToggle(sc, "Anti AFK", "antiAfk", nil)
        mkToggle(sc, "Remove Background", "removeBackground", function(enabled)
            if mainFrame and not minimized then
                mainFrame.BackgroundTransparency = enabled and 1 or 0.12
            end
        end)
        mkSep(sc); mkLabel(sc, "INFO")
        local function infoRow(t2)
            local lb2 = Instance.new("TextLabel", sc); lb2.Size = UDim2.new(1,-20,0,20)
            lb2.BackgroundTransparency = 1; lb2.TextColor3 = T.sub; lb2.Font = Enum.Font.Gotham
            lb2.TextSize = 11; lb2.TextXAlignment = Enum.TextXAlignment.Left; lb2.Text = "  "..t2
            return lb2
        end
        local function localizedInfoRow(key, value)
            local label = infoRow("")
            local function update() label.Text = "  "..string.format(tr(key), tostring(value)) end
            languageRefreshHooks[#languageRefreshHooks+1] = update; update()
        end
        infoRow("GlitchHub v5.0  |  Ride A Pet")
        localizedInfoRow("Place ID: %s", game.PlaceId)
        localizedInfoRow("Player: %s", LP.Name)
        mkSep(sc); mkLabel(sc, "STORM")
        local stormLbl = Instance.new("TextLabel", sc); stormLbl.Size = UDim2.new(1,-20,0,20)
        stormLbl.BackgroundTransparency = 1; stormLbl.TextColor3 = T.sub
        stormLbl.Font = Enum.Font.GothamBold; stormLbl.TextSize = 11
        stormLbl.TextXAlignment = Enum.TextXAlignment.Left
        local function updateStormText()
            local storm = getStorm()
            if storm and storm.Variant then
                local mut = STORM_MAP[storm.Variant] or storm.Variant
                local mult = MUT_MULT[mut] or 1
                stormLbl.TextColor3 = ESP_MUT[mut] or T.sub
                stormLbl.Text = "  "..string.format(tr("Storm: %s (x%s)"), trValue(mut), tostring(mult))
            else
                stormLbl.TextColor3 = T.sub; stormLbl.Text = "  "..tr("No storm")
            end
        end
        languageRefreshHooks[#languageRefreshHooks+1] = updateStormText
        updateStormText()
        task.spawn(function()
            while screenGui and screenGui.Parent do
                pcall(updateStormText)
                task.wait(5)
            end
        end)
    end

    setTab("Main")
end

_G.__GH_Kill = function()
    S.farmAll=false; S.farmBest=false; S.autoHatch=false; S.autoClaim=false
    S.autoPlace=false; S.autoFeed=false; S.autoRebirth=false
    S.autoLuck=false; S.autoUnlock=false
    S.espEggs=false; S.espPlayers=false; S.espMutation=false
    moving=false; pcall(clearFly); pcall(clearEsp)
    if espConn then pcall(function() espConn:Disconnect() end) end
    if modConn  then pcall(function() modConn:Disconnect() end) end
    if screenGui and screenGui.Parent then pcall(function() screenGui:Destroy() end) end
end

loadRemotes()
trackConn(LP.CharacterAdded:Connect(function()
    task.wait(1.5); flushPlot(); clearFly(); loadRemotes(); pcall(applyMods)
end))

task.spawn(function()
    if MY_ID ~= _G.__GH_N then return end
    task.wait(0.2)
    pcall(buildGui)
    pcall(applyMods)
    pcall(startAfk)
end)
