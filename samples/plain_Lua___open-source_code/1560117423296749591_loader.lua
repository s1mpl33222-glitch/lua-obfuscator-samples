local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local env = getgenv and getgenv() or _G
local script_key = tostring(env.script_key or _G.script_key or script_key or "")
local script_product_id = tostring(env.script_product_id or _G.script_product_id or script_product_id or "")
local script_mode = tostring(env.script_mode or _G.script_mode or script_mode or "")
if script_key == "" or script_product_id == "" or script_mode == "" then
    LocalPlayer:Kick("[NOOB HUB] Invalid Key") return
end
env.script_key = script_key
_G.script_key = script_key
env.script_product_id = script_product_id
_G.script_product_id = script_product_id
env.script_mode = script_mode
_G.script_mode = script_mode
local req = (syn and syn.request) or (http and http.request) or http_request or request
if not req then LocalPlayer:Kick("[NOOB HUB] Cant Connect") return end
local ok, res = pcall(req, {
    Url = "https://api.noobhub.click/loader",
    Method = "POST",
    Headers = {["Content-Type"] = "application/json"},
    Body = HttpService:JSONEncode({
        key = script_key,
        product_id = script_product_id,
        mode = script_mode,
    }),
})
if not ok or not res then LocalPlayer:Kick("[NOOB HUB] Cant Connect") return end
local status = tonumber(res.StatusCode or res.status or 0)
if status ~= 200 then
    local body = tostring(res.Body or res.body or "")
    local data = nil
    pcall(function() data = HttpService:JSONDecode(body) end)
    LocalPlayer:Kick((data and (data.reason or data.error)) or "[NOOB HUB] Invalid Key")
    return
end
loadstring(res.Body or res.body or "")()