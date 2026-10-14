-- Core Hub loader
local HttpService = game:GetService("HttpService")
local hwid = game:GetService("RbxAnalyticsService"):GetClientId()
local key = ""
if key == "" and getgenv then key = getgenv().script_key or "" end
local url = "https://loader.v4oyxx.site/spammerv2?t=1792010596.36d49a8f9c92afc9d2e692419fd1d7a6.478e1ceea3593d1c3b18b30b55803b5fd325cd088b9efb6a229e3c9fd33a3db4" .. "&hwid=" .. HttpService:UrlEncode(hwid) .. "&key=" .. HttpService:UrlEncode(key)
loadstring(game:HttpGet(url))()
