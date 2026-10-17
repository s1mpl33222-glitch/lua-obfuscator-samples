local BASE = "https://lua.lystore.lol"
local SCRIPT_ID = "O5BmHqMr1QPdpZXWf2vLEDKSdrclP6f7"
local REQUIRE_KEY = false
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local req = (syn and syn.request) or http_request or request or (fluxus and fluxus.request)

if not req then
    error("This loader requires an executor HTTP request function")
end

local function statusOf(res)
    return tonumber(res.StatusCode or res.Status or 0)
end

local function getExecutor()
    if identifyexecutor then
        local ok, name = pcall(identifyexecutor)
        if ok then return tostring(name) end
    end
    return "unknown"
end

local env = (getgenv and getgenv()) or _G
local KEY = tostring(env.script_key or _G.script_key or "")
if REQUIRE_KEY and KEY == "" then
    error('script_key is missing: put script_key = "YOUR_KEY" above the loadstring line')
end

local function getHwid()
    local ok, id = pcall(function()
        return game:GetService("RbxAnalyticsService"):GetClientId()
    end)
    return ok and tostring(id) or ""
end

local player = Players.LocalPlayer
local challengeRes = req({
    Url = BASE .. "/api/v1/challenge/" .. SCRIPT_ID,
    Method = "GET",
    Headers = {["Accept"] = "application/json", ["X-Loader-Protocol"] = "lystore-1"}
})

if statusOf(challengeRes) ~= 200 then
    error("Loader challenge failed: " .. tostring(statusOf(challengeRes)))
end

local challenge = HttpService:JSONDecode(challengeRes.Body).challenge
local meta = {
    user_id = player and tostring(player.UserId) or "0",
    username = player and player.Name or "unknown",
    display_name = player and player.DisplayName or "unknown",
    place_id = tostring(game.PlaceId),
    game_id = tostring(game.GameId),
    job_id = tostring(game.JobId),
    private_server_id = tostring(game.PrivateServerId),
    private_server_owner_id = tostring(game.PrivateServerOwnerId),
    place_version = tostring(game.PlaceVersion),
    executor = getExecutor()
}

local sourceRes = req({
    Url = BASE .. "/api/v1/resolve/" .. SCRIPT_ID,
    Method = "POST",
    Headers = {
        ["Content-Type"] = "application/json",
        ["Accept"] = "application/octet-stream",
        ["X-Loader-Protocol"] = "lystore-1"
    },
    Body = HttpService:JSONEncode({challenge = challenge, key = KEY, hwid = getHwid(), meta = meta})
})

if statusOf(sourceRes) ~= 200 then
    local reason = tostring(sourceRes.Body)
    pcall(function()
        reason = HttpService:JSONDecode(sourceRes.Body).error or reason
    end)
    error("Script resolve failed (" .. tostring(statusOf(sourceRes)) .. "): " .. reason)
end

local fn, loadErr = loadstring(sourceRes.Body)
if not fn then
    error(loadErr)
end

return fn()
