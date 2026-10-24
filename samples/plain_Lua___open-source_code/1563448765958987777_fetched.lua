local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local genv = type(getgenv) == "function" and getgenv() or _G

local function kick(msg)
    pcall(function() Players.LocalPlayer:Kick(msg) end)
end

local executor = ""
pcall(function()
    if type(identifyexecutor) == "function" then
        executor = tostring((identifyexecutor()) or "")
    elseif type(getexecutorname) == "function" then
        executor = tostring(getexecutorname() or "")
    end
end)

local unsupported = type(genv.Xeno) == "table"
    or executor:lower():find("xeno", 1, true) ~= nil
    or executor:lower():find("solara", 1, true) ~= nil
    or executor:lower():match("^%s*wave") ~= nil
if not unsupported then
    for _, name in ipairs({ "hookfunction", "getrawmetatable", "setreadonly", "getconnections", "getgc", "checkcaller" }) do
        if type(genv[name]) ~= "function" and type(rawget(_G, name)) ~= "function" then
            unsupported = true
            break
        end
    end
end
if unsupported then
    kick((executor ~= "" and executor or "This executor") .. " is NOT supported.")
    return
end

local key = tostring((getgenv and (getgenv().key or getgenv().script_key)) or script_key or "")
local placeId = game.PlaceId

local function deny()
    kick("Not Whitelisted! Join discord.gg/netherware for support")
end

local freePlaces = { 135734662656599,77764836384604 }
local isFree = table.find(freePlaces, placeId) ~= nil
if not isFree then
    if key:gsub("%s+", "") == "" then deny() return end
    local ok, result = pcall(game.HttpGet, game, "https://netherware.xyz/api/validate-key?key=" .. HttpService:UrlEncode(key), true)
    if ok and tostring(result) == "0" then deny() return end

    local hwid = ""
    pcall(function() if gethwid then hwid = tostring(gethwid()) end end)
    if hwid ~= "" then
        local reason
        pcall(function()
            local raw = game:HttpGet("https://netherware.xyz/api/hwid-check?key=" .. HttpService:UrlEncode(key) .. "&hwid=" .. HttpService:UrlEncode(hwid), true)
            local data = HttpService:JSONDecode(raw)
            if data and data.ok == false and data.error then reason = tostring(data.error) end
        end)
        if reason then kick(reason) return end
    end
end

local function isAdminKey()
    if key:gsub("%s+", "") == "" then return false end
    local ok, raw = pcall(game.HttpGet, game, "https://netherware.xyz/api/key-admin?key=" .. HttpService:UrlEncode(key), true)
    if not ok then return false end
    local ok2, data = pcall(HttpService.JSONDecode, HttpService, raw)
    return ok2 and type(data) == "table" and data.admin == true
end

local function isPremiumKey()
    if key:gsub("%s+", "") == "" then return false end
    local ok, raw = pcall(game.HttpGet, game, "https://netherware.xyz/api/key-tester?key=" .. HttpService:UrlEncode(key), true)
    if not ok then return false end
    local ok2, data = pcall(HttpService.JSONDecode, HttpService, raw)
    return ok2 and type(data) == "table" and data.allowed == true
end

local function isGameKey(gameId)
    if key:gsub("%s+", "") == "" then return false end
    local ok, raw = pcall(game.HttpGet, game, "https://netherware.xyz/api/key-tester?key=" .. HttpService:UrlEncode(key), true)
    if not ok then return false end
    local ok2, data = pcall(HttpService.JSONDecode, HttpService, raw)
    if not ok2 or type(data) ~= "table" then return false end
    return data.allowed == true or (type(data.games) == "table" and data.games[gameId] == true)
end

local function isOwnGameKey(gameId)
    if key:gsub("%s+", "") == "" then return false end
    local ok, raw = pcall(game.HttpGet, game, "https://netherware.xyz/api/key-tester?key=" .. HttpService:UrlEncode(key), true)
    if not ok then return false end
    local ok2, data = pcall(HttpService.JSONDecode, HttpService, raw)
    if not ok2 or type(data) ~= "table" then return false end
    return data.admin == true or (type(data.games) == "table" and data.games[gameId] == true)
end

local function isAdoptMeKey()
    if key:gsub("%s+", "") == "" then return false end
    local ok, raw = pcall(game.HttpGet, game, "https://netherware.xyz/api/key-tester?key=" .. HttpService:UrlEncode(key), true)
    if not ok then return false end
    local ok2, data = pcall(HttpService.JSONDecode, HttpService, raw)
    return ok2 and type(data) == "table" and (data.adoptme == true or data.admin == true)
end

local function load(id, free)
    if free then
        if key ~= "" and getgenv then getgenv().key = key end
        script_key = nil
        if getgenv then getgenv().script_key = nil end
    elseif key ~= "" then
        script_key = key
    end
    if getgenv then getgenv().__NW_SCRIPT_ACTIVE = true end
    loadstring(game:HttpGet("https://api.luarmor.net/files/v3/loaders/" .. id .. ".lua", true))()
end

local routes = {
    { places = { 100826958521689, 16615247087, 81287561532935 }, id = "ea00cb3983a5cd0bcf7898e9cb089eb9", premium = "Heroes: Online World", game = "how" },
    { places = { 109629391874197 }, id = "d153d8c5a0594fe7c2694371c451c0f6" },
    { places = { 11759251076, 14449145868 }, id = "a1c5f30c86f62caeb4981586ff88b218", premium = "Bewitched", game = "bw" },
    { places = { 135734662656599, 77764836384604 }, id = "81c5779c11b38e3196ff71264b39e624", free = true },
    { places = { 12691971351 }, id = "6bff6803fc58533935e7e420c180804c", premium = "Charmed: Reborn", game = "cr" },
    { places = { 920587237 }, id = "e980074493404bdd0029bc643b50ea5e", adoptme = "Adopt Me!" },
    { places = { 142823291 }, id = "36a7763ce52ce2a4a03f418f1a842718", owngame = "mm2" },
    { places = { 10561483644, 10561482233, 10561484691, 10561456271 }, id = "67f01633cae42d13ed74f0ee3db5a247" },
}

for _, route in ipairs(routes) do
    if table.find(route.places, placeId) then
        if route.premium and not (route.game and isGameKey(route.game) or (not route.game and isPremiumKey())) then deny() return end
        if route.adoptme and not isAdoptMeKey() then deny() return end
        if route.owngame and not isOwnGameKey(route.owngame) then deny() return end
        if route.kick then
            if route.id and isAdminKey() then load(route.id, route.free) else kick(route.kick) end
        elseif route.deny then deny() else load(route.id, route.free) end
        return
    end
end
deny()
