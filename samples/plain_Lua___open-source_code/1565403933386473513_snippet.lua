local _genv=(type(getgenv)=="function" and getgenv())or _G
_genv.KING_API_URL="http://151.241.100.83:3002/api/list"
_genv.KING_API_KEY="3EMNXK3Z9ANQFT"
local King = {}

local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local _env = (type(getgenv) == "function" and getgenv()) or _G
local API_URL = (type(_env.KING_API_URL) == "string" and _env.KING_API_URL) or "http://151.241.100.83:3002/api/list"
local API_KEY = (type(_env.KING_API_KEY) == "string" and _env.KING_API_KEY) or nil
local REFRESH = tonumber(_env.KING_REFRESH) or 120
if REFRESH < 30 then REFRESH = 30 end

local good = {}
local bad = {}
local generation = 0
local lastError = "not attempted"
local source = "?"

local memo = setmetatable({}, { __mode = "k" })
local memoGen = -1

local function httpGet(url)
    local fns = {
        { "syn.request", syn and syn.request },
        { "http_request", http_request },
        { "request", request },
        { "http.request", http and http.request },
        { "fluxus.request", fluxus and fluxus.request },
        { "getgenv().request", getgenv and getgenv().request }
    }
    for _, e in ipairs(fns) do
        local fn = e[2]
        if type(fn) == "function" then
            local ok, res = pcall(function()
                return fn({ Url = url, Method = "GET", Headers = { ["Cache-Control"] = "no-cache" } })
            end)
            local body = ok and res and type(res.Body) == "string" and res.Body or nil
            local status = ok and res and tonumber(res.StatusCode) or nil
            if body and body ~= "" and (status == nil or status == 200) and body:find('"king-api"', 1, true) then
                lastError = nil
                source = e[1]
                return body
            end
            lastError = e[1] .. ": status=" .. tostring(status)
        end
    end
    local ok, body = pcall(function() return game:HttpGet(url) end)
    if ok and type(body) == "string" and body:find('"king-api"', 1, true) then
        lastError = nil
        source = "HttpGet"
        return body
    end
    lastError = "HttpGet: " .. string.sub(tostring(body), 1, 120)
    return nil
end

local function addName(t, name)
    if type(name) ~= "string" then return end
    local cleaned = string.lower((name:gsub("^%s+", ""):gsub("%s+$", ""):gsub("^@", "")))
    cleaned = cleaned:gsub("%s.*$", "")
    if cleaned ~= "" then t[cleaned] = true end
end

local function collect(list, out)
    if type(list) ~= "table" then return end
    for _, n in pairs(list) do
        if type(n) == "string" then
            addName(out, n)
        elseif type(n) == "table" then
            addName(out, n.roblox or n.name or n.username)
        end
    end
end

local function buildUrl()
    local parts = {}
    if API_KEY then parts[#parts + 1] = "key=" .. API_KEY end
    if generation > 0 then parts[#parts + 1] = "gen=" .. tostring(generation) end
    parts[#parts + 1] = "cb=" .. tostring(os.time())
    return API_URL .. (API_URL:find("?", 1, true) and "&" or "?") .. table.concat(parts, "&")
end

local function sync()
    local raw = httpGet(buildUrl())
    if not raw then return false end

    local i = raw:find("{", 1, true)
    local j = nil
    for k = #raw, 1, -1 do
        if raw:sub(k, k) == "}" then j = k break end
    end
    if i and j and j > i then raw = raw:sub(i, j) end

    local ok, d = pcall(function() return HttpService:JSONDecode(raw) end)
    if not ok or type(d) ~= "table" then
        lastError = "decode failed"
        return false
    end
    if d.marker ~= "king-api" then
        lastError = "not a king api response"
        return false
    end
    if d.ok == false then
        lastError = "api refused: " .. tostring(d.error or "no reason")
        return false
    end
    if tonumber(d.refresh) and tonumber(d.refresh) >= 30 then REFRESH = tonumber(d.refresh) end
    if d.unchanged == true then return true end
    if d.good == nil and d.bad == nil then
        lastError = "unexpected shape"
        return false
    end

    local g, b = {}, {}
    collect(d.good, g)
    collect(d.bad, b)
    good = g
    bad = b
    generation = tonumber(d.generation) or (generation + 1)
    return true
end

local function lookup(player)
    if memoGen ~= generation then
        memo = setmetatable({}, { __mode = "k" })
        memoGen = generation
    end
    local hit = memo[player]
    if hit ~= nil then return hit end

    local name = player.Name and string.lower(player.Name) or nil
    local display = player.DisplayName and string.lower(player.DisplayName) or nil
    local isBad = (name ~= nil and bad[name] == true) or (display ~= nil and bad[display] == true)
    local isGood = (not isBad) and ((name ~= nil and good[name] == true) or (display ~= nil and good[display] == true))

    hit = { good = isGood, bad = isBad }
    memo[player] = hit
    return hit
end

function King.ready()
    return generation > 0
end

function King.isGood(player)
    if not player or generation <= 0 then return false end
    return lookup(player).good == true
end

function King.isBad(player)
    if not player or generation <= 0 then return false end
    return lookup(player).bad == true
end

function King.status(player)
    if not player or generation <= 0 then return "unknown" end
    local hit = lookup(player)
    if hit.bad then return "bad" end
    if hit.good then return "good" end
    return "none"
end

function King.shouldSkip(player)
    if not player then return false end
    if generation <= 0 then return true end
    if King.isBad(player) then return false end
    return King.isGood(player)
end

function King.counts()
    local g, b = 0, 0
    for _ in pairs(good) do g = g + 1 end
    for _ in pairs(bad) do b = b + 1 end
    return g, b
end

function King.lastError()
    return lastError
end

function King.resync()
    return pcall(sync)
end

function King.byName(name)
    if type(name) ~= "string" or generation <= 0 then return "unknown" end
    local n = string.lower(name)
    if bad[n] then return "bad" end
    if good[n] then return "good" end
    return "none"
end

task.spawn(function()
    local loaded = false
    for _ = 1, 8 do
        if pcall(sync) and generation > 0 then
            loaded = true
            break
        end
        task.wait(1.5)
    end
    local g, b = King.counts()
    if loaded then
        print(string.format("[King] list loaded: %d good / %d griefer via %s", g, b, tostring(source)))
    else
        warn("[King] list FAILED to load: " .. tostring(lastError))
        warn("[King] every player reads as protected until the list loads")
    end
    while true do
        task.wait(REFRESH)
        pcall(sync)
    end
end)

return King
