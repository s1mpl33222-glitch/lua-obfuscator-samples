
local HttpService = game:GetService("HttpService")

local key = (getgenv and getgenv().script_key) or script_key
if type(key) ~= "string" or key == "" then
    return warn("[License] No script_key set. Put script_key=\"YOUR_KEY\"; above the loadstring line.")
end

local httpRequest = (syn and syn.request) or http_request or request
    or (fluxus and fluxus.request)
if not httpRequest then
    return warn("[License] This executor doesn't support HTTP requests.")
end

local ok, res = pcall(httpRequest, {
    Url = "https://lua-license-api.eazyloader.workers.dev/v1/script",
    Method = "POST",
    Headers = { ["Content-Type"] = "application/json" },
    Body = HttpService:JSONEncode({ key = key })
})

if not ok or type(res) ~= "table" then
    return warn("[License] Could not reach the license server.")
end

if res.StatusCode ~= 200 then
    local decoded = pcall(HttpService.JSONDecode, HttpService, res.Body)
        and HttpService:JSONDecode(res.Body) or {}
    return warn("[License] Check failed: " .. tostring(decoded.error or res.StatusCode))
end

local fn, err = loadstring(res.Body)
if not fn then
    return warn("[License] Script failed to load: " .. tostring(err))
end

return fn()
