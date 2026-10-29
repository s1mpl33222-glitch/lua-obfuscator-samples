
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local RUN_URL = "https://preciseware-loader.precisewarecdn.workers.dev/api/v1/run"
local TICKET = "01b9efeb30a24d1aa4276f77a392e96977d61bd3d2e4436c8267a96ab35128c8"

local player = Players.LocalPlayer
if not player then
    player = Players.PlayerAdded:Wait()
end

local function getExecutorName()
    local candidates = {
        rawget(getgenv and getgenv() or _G, "identifyexecutor"),
        rawget(getgenv and getgenv() or _G, "getexecutorname"),
        identifyexecutor,
        getexecutorname
    }

    for _, fn in ipairs(candidates) do
        if type(fn) == "function" then
            local ok, a, b = pcall(fn)
            if ok then
                local value = tostring(a or b or "")
                if value ~= "" and value ~= "nil" then
                    return value
                end
            end
        end
    end

    return "Unknown"
end

local payload = {
    ticket = TICKET,
    userId = tostring(player.UserId),
    username = tostring(player.Name),
    displayName = tostring(player.DisplayName or player.Name),
    executor = getExecutorName(),
    placeId = tostring(game.PlaceId or ""),
    gameId = tostring(game.GameId or ""),
    jobId = tostring(game.JobId or "")
}

local requestFunction =
    (type(request) == "function" and request)
    or (type(http_request) == "function" and http_request)
    or (syn and type(syn.request) == "function" and syn.request)
    or (http and type(http.request) == "function" and http.request)

local source

if requestFunction then
    local response = requestFunction({
        Url = RUN_URL,
        Method = "POST",
        Headers = {
            ["Content-Type"] = "application/json",
            ["Accept"] = "text/plain"
        },
        Body = HttpService:JSONEncode(payload)
    })

    source = response and (response.Body or response.body)
else
    local function enc(value)
        return HttpService:UrlEncode(tostring(value or ""))
    end

    local url = RUN_URL
        .. "?ticket=" .. enc(payload.ticket)
        .. "&userId=" .. enc(payload.userId)
        .. "&username=" .. enc(payload.username)
        .. "&displayName=" .. enc(payload.displayName)
        .. "&executor=" .. enc(payload.executor)
        .. "&placeId=" .. enc(payload.placeId)
        .. "&gameId=" .. enc(payload.gameId)
        .. "&jobId=" .. enc(payload.jobId)

    source = game:HttpGet(url)
end

if type(source) ~= "string" or source == "" then
    error("PreciseWare loader returned an empty response")
end

local fn, loadError = loadstring(source)
if not fn then
    error("PreciseWare loader error: " .. tostring(loadError))
end

return fn()
