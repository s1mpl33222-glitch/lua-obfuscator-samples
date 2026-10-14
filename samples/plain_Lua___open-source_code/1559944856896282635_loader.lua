do
    local teleportLoaderUrl = "https://unknownhub.win/api/projects/54474b4c5d5a4f459909c4cb70e7b4f3/loader"
    local teleportQueuedSource = "do\n    local autoLoadPath = \"UnknownHub/autoload.json\"\n    local loaderUrl = \"https://unknownhub.win/api/projects/54474b4c5d5a4f459909c4cb70e7b4f3/loader\"\n\n    local function autoLoadStore()\n        if type(getgenv) == \"function\" then\n            local ok, env = pcall(getgenv)\n            if ok and type(env) == \"table\" then\n                return env\n            end\n        end\n        if type(_G) == \"table\" then\n            return _G\n        end\n        return nil\n    end\n\n    local function autoLoadEnabled()\n        local store = autoLoadStore()\n        if store and store.__UnknownHubAutoLoadEnabled == false then\n            return false\n        end\n        if type(readfile) ~= \"function\" then\n            return true\n        end\n        if type(isfile) == \"function\" then\n            local okExists, exists = pcall(isfile, autoLoadPath)\n            if okExists and not exists then\n                return true\n            end\n        end\n\n        local okRead, raw = pcall(readfile, autoLoadPath)\n        if not okRead or type(raw) ~= \"string\" or raw == \"\" then\n            return true\n        end\n\n        local okDecode, payload = pcall(function()\n            return game:GetService(\"HttpService\"):JSONDecode(raw)\n        end)\n        return not (okDecode and type(payload) == \"table\" and payload.enabled == false)\n    end\n\n    if autoLoadEnabled() then\n        local okSource, source = pcall(function()\n            return game:HttpGet(loaderUrl)\n        end)\n        if okSource and type(source) == \"string\" and source ~= \"\" then\n            local chunk = loadstring(source)\n            if chunk then\n                pcall(chunk)\n            end\n        end\n    end\nend"
    local teleportQueueJobId = tostring(game.JobId or "")

    local function getQueueOnTeleport()
        if type(queue_on_teleport) == "function" then
            return queue_on_teleport
        end
        if type(queueonteleport) == "function" then
            return queueonteleport
        end
        if type(syn) == "table" then
            if type(syn.queue_on_teleport) == "function" then
                return function(source)
                    return syn.queue_on_teleport(source)
                end
            end
            if type(syn.queueonteleport) == "function" then
                return function(source)
                    return syn.queueonteleport(source)
                end
            end
        end
        if type(fluxus) == "table" and type(fluxus.queue_on_teleport) == "function" then
            return function(source)
                return fluxus.queue_on_teleport(source)
            end
        end
        return nil
    end

    local function teleportQueueStore()
        if type(getgenv) == "function" then
            local ok, env = pcall(getgenv)
            if ok and type(env) == "table" then
                return env
            end
        end
        if type(_G) == "table" then
            return _G
        end
        return nil
    end

    local function teleportAlreadyQueued()
        local store = teleportQueueStore()
        if not store then
            return false
        end
        if type(store.__UnknownHubTeleportQueue) ~= "table" then
            store.__UnknownHubTeleportQueue = {}
        end
        return store.__UnknownHubTeleportQueue[teleportLoaderUrl] == teleportQueueJobId
    end

    local function markTeleportQueued()
        local store = teleportQueueStore()
        if not store then
            return
        end
        if type(store.__UnknownHubTeleportQueue) ~= "table" then
            store.__UnknownHubTeleportQueue = {}
        end
        store.__UnknownHubTeleportQueue[teleportLoaderUrl] = teleportQueueJobId
    end

    local queueOnTeleport = getQueueOnTeleport()
    if queueOnTeleport and not teleportAlreadyQueued() then
        local okQueued = pcall(queueOnTeleport, teleportQueuedSource)
        if okQueued then
            markTeleportQueued()
        end
    end
end

local baseUrl = "https://unknownhub.win/api/projects/54474b4c5d5a4f459909c4cb70e7b4f3/loader"
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function safeString(value)
    if value == nil then
        return ""
    end
    return tostring(value)
end

local function safeCall(fn, ...)
    if type(fn) ~= "function" then
        return ""
    end
    local ok, result = pcall(fn, ...)
    if ok and result ~= nil then
        return safeString(result)
    end
    return ""
end

local function encode(value)
    local text = safeString(value)
    local ok, encoded = pcall(function()
        return HttpService:UrlEncode(text)
    end)
    if ok and encoded then
        return encoded
    end
    return (text:gsub("([^%w%-_%.~])", function(char)
        return string.format("%%%02X", string.byte(char))
    end))
end

local function getExecutor()
    if type(identifyexecutor) == "function" then
        local ok, name, version = pcall(identifyexecutor)
        if ok then
            return safeString(name), safeString(version)
        end
    end
    if type(getexecutorname) == "function" then
        return safeCall(getexecutorname), ""
    end
    return "", ""
end

local function getHwid()
    local value = safeCall(get_hwid)
    if value ~= "" then
        return value
    end
    value = safeCall(gethwid)
    if value ~= "" then
        return value
    end
    value = safeCall(get_hardware_id)
    if value ~= "" then
        return value
    end
    local ok, analytics = pcall(function()
        return game:GetService("RbxAnalyticsService")
    end)
    if ok and analytics then
        return safeCall(function()
            return analytics:GetClientId()
        end)
    end
    return ""
end

local executorName, executorVersion = getExecutor()
local params = {
    uh_telemetry = "1",
    place_id = safeString(game.PlaceId),
    game_id = safeString(game.GameId),
    job_id = safeString(game.JobId),
    roblox_user_id = LocalPlayer and safeString(LocalPlayer.UserId) or "",
    roblox_username = LocalPlayer and safeString(LocalPlayer.Name) or "",
    executor_name = executorName,
    executor_version = executorVersion,
    hwid = getHwid(),
}

local query = {}
for key, value in pairs(params) do
    if value ~= "" then
        table.insert(query, encode(key) .. "=" .. encode(value))
    end
end

local separator = baseUrl:find("?", 1, true) and "&" or "?"
local sourceUrl = baseUrl .. (#query > 0 and (separator .. table.concat(query, "&")) or "")
local source = game:HttpGet(sourceUrl)
local chunk, compileError = loadstring(source)
if not chunk then
    error(compileError or "UnknownHub project loader compile failed.", 0)
end
return chunk()