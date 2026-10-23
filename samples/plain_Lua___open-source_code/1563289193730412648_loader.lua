local BASE_URL = "https://raw.githubusercontent.com/robloxvibecoders/vibecoders/main/games/"
local LOADER_URL = "https://raw.githubusercontent.com/robloxvibecoders/vibecoders/refs/heads/main/loader.lua"

local GAMES = {
    [443406476] = { name = "Project Lazarus", file = "lazarus.lua" },
    [111543903102439] = { name = "Stone Skipping", file = "stoneskipping.lua", reentrant = true },
    [99409088950210] = { name = "Survive a Million Monkeys", file = "survivemonkeys.lua", reentrant = true },
    [115317125060158] = { name = "Survive a Million Monkeys", file = "survivemonkeys.lua", reentrant = true },
    [114326934417838] = { name = "Break and Steal an Egg", file = "breakandstealegg.lua" },
    [74023858073178] = { name = "Bike For Egg", file = "bikeforeggs.lua" },
    [107535308163741] = { name = "Huss Valley", file = "hussvalley.lua" },
    [893973440] = { name = "Flee the Facility", file = "fleethefacility.lua" },
    [72169370437173] = { name = "Tribes 3v3", file = "tribes3v3.lua" },
}

local function report(msg)
    warn("[Vibecoders] " .. msg)
end

if not game:IsLoaded() then
    game.Loaded:Wait()
end

local entry = GAMES[game.PlaceId]
if not entry then
    report(string.format("Unsupported place (PlaceId %.0f).", game.PlaceId))
    return
end

-- Re-run this loader after teleports (once per session)
local queueTeleport = queue_on_teleport
    or (syn and syn.queue_on_teleport)
    or (fluxus and fluxus.queue_on_teleport)

local qenv = (getgenv and getgenv()) or _G
if queueTeleport and not qenv.__VibecodersQueued then
    qenv.__VibecodersQueued = true
    pcall(queueTeleport, 'loadstring(game:HttpGet("' .. LOADER_URL .. '"))()')
end

local httpRequest = (syn and syn.request) or request or http_request or (fluxus and fluxus.request)
local hasHttpGet = false
do
    local ok, fn = pcall(function()
        return game.HttpGet
    end)
    hasHttpGet = ok and type(fn) == "function"
end

if not (httpRequest or hasHttpGet) then
    report("No HTTP function available.")
    return
end
if type(loadstring) ~= "function" then
    report("loadstring is not available.")
    return
end

local env = (getgenv and getgenv()) or _G
local loader = env.VibecodersLoader
if type(loader) ~= "table" or type(loader.status) ~= "table" then
    loader = { status = {} }
    env.VibecodersLoader = loader
end

local key = entry.file .. "@" .. tostring(game.JobId)
local status = loader.status[key]
if status == "loading" or (status and not entry.reentrant) then
    report(entry.file .. " is already loaded or loading in this server.")
    return
end
loader.status[key] = "loading"

local function fetch(url)
    if httpRequest then
        local ok, res = pcall(httpRequest, { Url = url, Method = "GET" })
        if ok and type(res) == "table" then
            local code = res.StatusCode
            if type(code) == "number" and (code < 200 or code >= 300) then
                return nil, "HTTP " .. code
            end
            if res.Success == false then
                return nil, "request failed"
            end
            if type(res.Body) ~= "string" or res.Body == "" then
                return nil, "empty response"
            end
            return res.Body
        end
        if not hasHttpGet then
            return nil, ok and "unexpected response" or tostring(res)
        end
    end

    local ok, body = pcall(function()
        return game:HttpGet(url)
    end)
    if not ok then
        return nil, tostring(body)
    end
    if type(body) ~= "string" or body == "" then
        return nil, "empty response"
    end
    return body
end

local url = BASE_URL .. entry.file
local source, err = fetch(url)
if not source or source:match("^%s*404: Not Found") then
    loader.status[key] = nil
    report("Download failed for " .. url .. ": " .. (source and "file not found" or tostring(err)))
    return
end

local chunk, compileErr = loadstring(source)
if not chunk then
    loader.status[key] = nil
    report("Could not compile " .. entry.file .. ": " .. tostring(compileErr))
    return
end

loader.status[key] = "running"
local ok, runErr = xpcall(chunk, function(e)
    return debug.traceback(tostring(e), 2)
end)
loader.status[key] = "done"
if not ok then
    report(entry.name .. " errored: " .. tostring(runErr))
end
