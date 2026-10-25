-- Astra verify stub
local HttpService = game:GetService("HttpService")
local req = syn and syn.request or http_request or request or (http and http.request)
if not req then return warn("[Astra] No HTTP function available in this executor.") end
local hwid
if gethwid then hwid = gethwid()
elseif syn and syn.get_hwid then hwid = syn.get_hwid()
elseif get_hwid then hwid = get_hwid()
else
    local ok, id = pcall(function() return game:GetService("RbxAnalyticsService"):GetClientId() end)
    if ok then hwid = id end
end
if type(hwid) ~= "string" or #hwid < 8 then return warn("[Astra] Could not read HWID from this executor.") end
local ok, resp = pcall(req, {
    Url     = "https://astra-key-system-f12g.onrender.com/api/client/verify-token",
    Method  = "POST",
    Headers = { ["Content-Type"] = "application/json" },
    Body    = HttpService:JSONEncode({ token = "d235d4771ed13e5e8676cf656f2cc280efff407af759ed22", hwid = hwid })
})
if not ok or not resp or not resp.Body then return warn("[Astra] Verify request failed: " .. tostring(resp)) end
local decodedOk, parsed = pcall(function() return HttpService:JSONDecode(resp.Body) end)
if not decodedOk or type(parsed) ~= "table" then return warn("[Astra] Server returned non-JSON: " .. tostring(resp.Body):sub(1, 80)) end
if not parsed.success or not parsed.script then return warn("[Astra] " .. tostring(parsed.error or "Verification failed.")) end
local loader = loadstring or load
local fn, err = loader(parsed.script)
if not fn then return warn("[Astra] Compile error: " .. tostring(err) .. " | payload_head=" .. tostring(parsed.script):sub(1, 80)) end
local runOk, runErr = pcall(fn)
if not runOk then return warn("[Astra] Runtime error: " .. tostring(runErr)) end
