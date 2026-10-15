local key, req = getgenv().SCRIPT_KEY, request or http_request or (syn and syn.request) or (fluxus and fluxus.request) or (type(http) == "table" and http.request)
if type(key) ~= "string" or not req then return warn("[CruelHub] key not verified yet, re-execute the loader") end
local ok, r = pcall(req, { Url = "https://cruelty.win/s-ticket", Method = "POST", Headers = { ["Content-Type"] = "application/json" },
    Body = game:GetService("HttpService"):JSONEncode({ key = key, path = "mog-or-die/mog_auto.lua", id = game:GetService("Players").LocalPlayer.UserId, hwid = getgenv().__cruelHwid }) })
if not (ok and type(r) == "table" and r.StatusCode == 200 and type(r.Body) == "string" and r.Body:find("^%d+%.%x+$")) then
    return warn("[CruelHub] " .. (ok and type(r) == "table" and r.StatusCode == 403 and tostring(r.Body) or "key not verified, get a new key and re-execute the loader"))
end
return loadstring(game:HttpGet("https://cruelty.win/s/mog-or-die/mog_auto.lua?t=" .. r.Body))(...)
