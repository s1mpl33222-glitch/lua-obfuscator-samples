local LATAM_DUELS_PLACE_ID = 129714054840627

local ALLOWED_PLACE_IDS = {
    [100000081125400] = true,
    [135207708734108] = true,
    [118663948353042] = true,
    [125354647554476] = true,
    [93930118309121] = true,
    [87505594740333] = true,
    [105010829315032] = true,
    [121562300105609] = true,
    [97874431674178] = true,
    [122322877012159] = true,
    [99312875456341] = true,
    [134963371142373] = true,
    [131117978948830] = true,
    [105508393775130] = true,
    [129043781833299] = true,
    [75456685765982] = true,
    [86635050681926] = true,
    [102504926473744] = true,
    [101617670515690] = true,
    [137570376387995] = true,
    [74084441161738] = true,
    [135856908115931] = true,
    [92876937625630] = true,
    [114176825419426] = true,
    [97251114306253] = true,
    [81344624573389] = true,
    [123627218337521] = true,
    [124848751642883] = true,
}

local isLatamDuels = game.PlaceId == LATAM_DUELS_PLACE_ID

if not isLatamDuels and not ALLOWED_PLACE_IDS[game.PlaceId] then
    return
end

local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local HttpService = game:GetService("HttpService")

if not RunService:IsClient() then
    return
end

local ACTIVE_COUNT_URL = "https://lllll-hub-actives-production.up.railway.app/api/active-count"
local API_KEY = "LLLLL.HUB ACTIVES"

local INIT_SCRIPT_URL = "https://api.jnkie.com/api/v1/luascripts/public/62c58c107d2a4c93f945dc3fada3e443890b667695a41e155de4ab52a288f94c/download"

local SCRIPT_URLS = {
    Mobile = "https://api.jnkie.com/api/v1/luascripts/public/ffe564b4000729161d1ee74d43a701c4a99ca8a14ecb6bf1e8dd591ab7d0886e/download",
    PC = "https://api.jnkie.com/api/v1/luascripts/public/c0d7433e85dd6105ffeac56e4bfc586be4323e120bda5d21ad6f39b9f5a2882c/download",
}

local LATAM_DUELS_SCRIPT_URLS = {
    Mobile = "https://api.jnkie.com/api/v1/luascripts/public/39b21e89e33dc20227dadff16abfe5b9e8cdd7ed0460f6cd6100e0eb3b8628eb/download",
    PC = "https://api.jnkie.com/api/v1/luascripts/public/d3d550538a27f26c4885137f3a56d742653828cbf303fd7510fae087b887a556/download",
}

local function getRequestFunction()
    return (syn and syn.request) or http_request or request
end

local function publishActiveUser()
    local requestFunction = getRequestFunction()

    if not requestFunction then
        return
    end

    pcall(function()
        requestFunction({
            Url = ACTIVE_COUNT_URL,
            Method = "POST",
            Headers = {
                ["Content-Type"] = "application/json",
                ["X-Activos-Key"] = API_KEY,
            },
            Body = HttpService:JSONEncode({
                count = 1,
            }),
        })
    end)
end

task.spawn(function()
    while task.wait(3) do
        publishActiveUser()
    end
end)

publishActiveUser()

local function isMobileDevice()
    return UIS.TouchEnabled
        and not UIS.KeyboardEnabled
        and not UIS.MouseEnabled
end

local function fetchScript(url)
    local body
    local requestError

    local ok, fetchError = pcall(function()
        local success, result = pcall(function()
            return game:HttpGet(url)
        end)

        if success and type(result) == "string" and result ~= "" then
            body = result
            return
        end

        local requestFunction = getRequestFunction()

        if requestFunction then
            local response = requestFunction({
                Url = url,
                Method = "GET",
            })

            if response
                and type(response.Body) == "string"
                and response.Body ~= ""
            then
                body = response.Body
                return
            end
        end

        requestError = result or "Request returned nil"
    end)

    if not ok or type(body) ~= "string" or body == "" then
        error(
            "Could not download script: "
                .. tostring(fetchError or requestError or "unknown error")
        )
    end

    if type(loadstring) ~= "function" then
        error("This executor does not support loadstring")
    end

    local chunk, compileError = loadstring(body)

    if not chunk then
        error("Script compilation failed: " .. tostring(compileError))
    end

    return chunk
end

local initOk, initError = pcall(function()
    fetchScript(INIT_SCRIPT_URL)()
end)

if not initOk then
    warn(tostring(initError))
end

local device = isMobileDevice() and "Mobile" or "PC"
local selectedScripts = isLatamDuels
    and LATAM_DUELS_SCRIPT_URLS
    or SCRIPT_URLS

local targetUrl = selectedScripts[device]

local scriptOk, runtimeError = pcall(function()
    fetchScript(targetUrl)()
end)

if not scriptOk then
    warn(tostring(runtimeError))
end
