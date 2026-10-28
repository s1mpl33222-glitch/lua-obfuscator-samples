local k = (getgenv and getgenv().script_key) or script_key
if not k then return warn("[Vault] set script_key first") end
local h = (gethwid and gethwid()) or game:GetService("RbxAnalyticsService"):GetClientId()
local hs = game:GetService("HttpService")
local r = game:HttpGet("https://ethereal-protection.lovable.app/api/public/fetch?s=b0c1bcc7-149d-4454-ba17-801c09661ecd&k="..hs:UrlEncode(k).."&h="..hs:UrlEncode(h))
if r:sub(1,6) == "--ERR:" then return warn("[Vault] "..r:sub(7)) end
local f, e = loadstring(r)
if not f then return warn("[Vault] load failed") end
return f()