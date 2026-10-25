-- Orvyn Auth loader - test
-- Protected script. Do not edit: the loader is re-signed on every request.
local GENV = (getgenv and getgenv()) or _G
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")

local API = "https://orvynauth.up.railway.app"
local SCRIPT_ID = "baec5a1e3bfaa5b28563395c76c7ad11"
local SCRIPT_NAME = "test"
local LOADER_VERSION = "1.0.1"
local ACCESS = "paid"

local nativeLoadstring = loadstring
local nativeLoad = load
local nativeHttpGet = game.HttpGet
local nativeJson = HttpService.JSONDecode
local nativePcall = pcall
local nativeWarn = warn or print

local function note(text)
    nativePcall(function() nativeWarn("[Orvyn] " .. tostring(text)) end)
end

local function isNative(fn)
    if type(fn) ~= "function" then return false end
    if iscclosure then
        local ok, closured = nativePcall(iscclosure, fn)
        if ok and closured ~= nil then return closured end
    end
    if debug then
        if debug.info then
            local ok, src = nativePcall(function() return debug.info(fn, "s") end)
            if ok and type(src) == "string" then return src == "[C]" or src == "=[C]" end
        end
        if debug.getinfo then
            local ok, info = nativePcall(debug.getinfo, fn, "S")
            if ok and type(info) == "table" then return info.what == "C" end
        end
    end
    return true
end

-- A hooked loadstring (or HttpGet / JSON decoder) is the classic dump
-- technique. Each one is compared against its own native closure, because
-- load and loadstring are two different functions in every executor.
local function tampered()
    if nativeLoadstring ~= nil and not isNative(nativeLoadstring) then return true end
    if nativeLoad ~= nil and not isNative(nativeLoad) then return true end
    if not isNative(nativeHttpGet) then return true end
    if not isNative(nativeJson) then return true end
    if GENV then
        if nativeLoadstring ~= nil and GENV.loadstring ~= nil and GENV.loadstring ~= nativeLoadstring then return true end
        if nativeLoad ~= nil and GENV.load ~= nil and GENV.load ~= nativeLoad then return true end
    end
    return false
end

local function httpGet(url)
    local ok, body = nativePcall(nativeHttpGet, game, url)
    if ok and type(body) == "string" and #body > 0 then return body end
    if syn and syn.request then
        local done, response = nativePcall(syn.request, { Url = url, Method = "GET" })
        if done and type(response) == "table" and response.Body then return response.Body end
    end
    if request then
        local done, response = nativePcall(request, { Url = url, Method = "GET" })
        if done and type(response) == "table" and response.Body then return response.Body end
    end
    return nil
end

local function runSource(source, chunkName)
    local loaderFn = nativeLoadstring or nativeLoad
    if type(loaderFn) ~= "function" then return false, "no compiler" end
    local ok, fn = nativePcall(loaderFn, source, chunkName or "=orvyn")
    if (not ok or type(fn) ~= "function") and GENV then
        local okEnv, envFn = nativePcall(loaderFn, source, chunkName or "=orvyn", "t", GENV)
        if okEnv and type(envFn) == "function" then ok, fn = okEnv, envFn end
    end
    if not ok or type(fn) ~= "function" then return false, tostring(fn) end
    local ran, err = nativePcall(fn)
    if not ran then return false, tostring(err) end
    return true
end

local function serveTroll()
    local body = httpGet(API .. "/api/v1/troll?v=" .. LOADER_VERSION)
    if body then runSource(body, "=orvyn_troll") end
end

-- 1. a hooked loadstring / HttpGet is the classic dump-script attack.
if tampered() then
    note("Environment check failed.")
    serveTroll()
    return
end

local function getHwid()
    local id = nil
    if gethwid then
        local ok, value = nativePcall(gethwid)
        if ok and value and tostring(value) ~= "" then id = tostring(value) end
    end
    if not id and writefile and readfile then
        local file = ".orvyn_device"
        local okExists, exists = nativePcall(isfile, file)
        if okExists and exists then
            local okRead, saved = nativePcall(readfile, file)
            if okRead and saved and #saved > 0 then id = saved end
        end
        if not id then
            id = HttpService:GenerateGUID(false)
            nativePcall(writefile, file, id)
        end
    end
    if not id then
        local player = Players.LocalPlayer
        id = tostring(player and player.UserId or "unknown") .. "-" .. tostring(game.PlaceId)
    end
    return id
end

local function executorName()
    if identifyexecutor then
        local ok, name = nativePcall(identifyexecutor)
        if ok and type(name) == "string" then return name end
    end
    if getexecutorname then
        local ok, name = nativePcall(getexecutorname)
        if ok and type(name) == "string" then return name end
    end
    return "unknown"
end

-- The key is read from an environment table, so a paid loader can be locked
-- with a plain script_key = "..." line above the loadstring.
local KEY_NAMES = { "script_key", "ScriptKey", "OrvynKey", "orvynKey", "key", "Key" }

local function keyFrom(env)
    if type(env) ~= "table" then return nil end
    for i = 1, #KEY_NAMES do
        local name = KEY_NAMES[i]
        local ok, value = nativePcall(function() return rawget(env, name) end)
        if not ok or value == nil then
            ok, value = nativePcall(function() return env[name] end)
        end
        if ok and type(value) == "string" then
            local clean = value:gsub("%s+", "")
            if #clean > 0 then return clean end
        end
    end
    return nil
end

-- Executors do not all share one environment: several run every script in its
-- own table, so script_key = "..." can land somewhere other than getgenv().
-- Every table this chunk can reach is checked, ending with the caller's own
-- environment, which is where the script_key line actually ran.
local function readKey()
    local seen = {}
    local candidates = { GENV, shared, _G }
    if getfenv then
        for level = 0, 8 do
            local ok, env = nativePcall(getfenv, level)
            if ok then candidates[#candidates + 1] = env end
        end
    end
    for i = 1, #candidates do
        local env = candidates[i]
        if type(env) == "table" and not seen[env] then
            seen[env] = true
            local found = keyFrom(env)
            if found then return found end
        end
    end
    return nil
end

local hwid = getHwid()
local key = readKey()

-- 2. a paid script is refused before it runs. There is no in-game key prompt:
-- a refusal kicks the player, so a guessed or missing key never executes code.
local function kick(message)
    if ACCESS ~= "paid" then return end
    nativePcall(function()
        local player = Players.LocalPlayer
        if player and player.Kick then
            player:Kick("[Orvyn Auth] " .. tostring(message))
        end
    end)
end

if ACCESS == "paid" and not key then
    note("No licence key found.")
    kick('No licence key found. Put script_key = "ORVYN-..." above the loadstring.')
    return
end

local function showError(code, message)
    local text = tostring(message or code or "access denied")
    note(text)
    kick(text)
end

local authUrl = API .. "/api/v1/auth?scriptId=" .. SCRIPT_ID
    .. "&key=" .. HttpService:UrlEncode(key or "")
    .. "&hwid=" .. HttpService:UrlEncode(hwid)
    .. "&executor=" .. HttpService:UrlEncode(executorName())
    .. "&v=" .. LOADER_VERSION

local body = httpGet(authUrl)
if not body then
    note("Authentication failed - check your connection.")
    return
end

local okJson, data = nativePcall(nativeJson, HttpService, body)
if not okJson or type(data) ~= "table" then
    serveTroll()
    return
end

if data.ok ~= true then
    showError(data.code, data.message)
    return
end

-- 3. pull the encrypted payload in ordered chunks, each one single use.
local ticket = data.ticket
local chunks = {}
local total = nil
local xorKey = nil
local index = 0

repeat
    local chunkBody = httpGet(API .. "/api/v1/payload?ticket=" .. tostring(ticket) .. "&i=" .. tostring(index))
    if not chunkBody then
        note("Payload download failed.")
        return
    end
    local okChunk, chunk = nativePcall(nativeJson, HttpService, chunkBody)
    if not okChunk or type(chunk) ~= "table" or chunk.ok ~= true then
        note("Payload rejected.")
        return
    end
    total = tonumber(chunk.n) or 1
    xorKey = tonumber(chunk.x) or 157
    chunks[#chunks + 1] = chunk.d
    index = index + 1
until index >= total

local hex = table.concat(chunks)
chunks = nil

local decoded = {}
for i = 1, #hex, 2 do
    local byte = tonumber(hex:sub(i, i + 1), 16)
    if not byte then
        note("Payload is corrupt.")
        return
    end
    decoded[#decoded + 1] = string.char(bit32.bxor(byte, xorKey))
end

local source = table.concat(decoded)
decoded = nil

-- 4. run it. A failure is reported back (never the source).
local ran, err = runSource(source, "=orvyn_script")
source = nil
if not ran then
    note("Script error: " .. tostring(err))
    if HttpService and HttpService.PostAsync then
        nativePcall(function()
            HttpService:PostAsync(
                API .. "/api/v1/report",
                HttpService:JSONEncode({ ticket = ticket, message = tostring(err) }),
                Enum.HttpContentType.ApplicationJson
            )
        end)
    end
end
