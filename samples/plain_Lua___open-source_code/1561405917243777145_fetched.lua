-- Ghost Hub bootstrap
local HttpService = game:GetService("HttpService")
local function fail(msg) error("[Ghost Hub] " .. tostring(msg), 0) end
local KEY = script_key or (getgenv and getgenv().script_key)
if type(KEY) ~= "string" or #KEY < 8 then fail("No key provided. Set script_key before the loadstring.") end
local hwid = (gethwid and gethwid()) or game:GetService("RbxAnalyticsService"):GetClientId()
local url = "https://ghostauth01.lovable.app/api/public/b/99e94885-f71b-43ba-aeef-3cf5d7c320e8" .. "?key=" .. HttpService:UrlEncode(KEY) .. "&hwid=" .. HttpService:UrlEncode(hwid)
local ok, res = pcall(function() return game:HttpGet(url) end)
if not ok or type(res) ~= "string" then fail("Key server unreachable") end
if res:sub(1, 4) == "ERR:" then fail(res:sub(5)) end
local fn, err = loadstring(res)
if not fn then fail("Key check failed to load: " .. tostring(err)) end
return fn()
