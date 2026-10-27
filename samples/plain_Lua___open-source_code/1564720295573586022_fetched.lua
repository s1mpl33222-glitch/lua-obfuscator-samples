-- Bunny Finder key check
local function notify(msg)
  warn("[Bunny Finder] " .. msg)
  pcall(function()
    game:GetService("StarterGui"):SetCore("SendNotification", { Title = "Bunny Finder", Text = msg, Duration = 8 })
  end)
end
local KEY = script_key or (getgenv and getgenv().script_key)
if type(KEY) ~= "string" or KEY == "" then
  return notify("Set script_key before running the loader")
end
local HttpService = game:GetService("HttpService")
local hwid
pcall(function() hwid = gethwid and gethwid() end)
if type(hwid) ~= "string" or hwid == "" then
  pcall(function() hwid = game:GetService("RbxAnalyticsService"):GetClientId() end)
end
if type(hwid) ~= "string" or hwid == "" then
  return notify("Could not read your device ID")
end
local url = "https://bunnyfinder.lovable.app/api/public/script?key=" .. HttpService:UrlEncode(KEY) .. "&hwid=" .. HttpService:UrlEncode(hwid)
local ok, body = pcall(function() return game:HttpGet(url) end)
if not ok or type(body) ~= "string" or body == "" then
  return notify("Could not reach the key server, try again")
end
local fn = loadstring(body)
if not fn then
  return notify("Key server sent an invalid response")
end
return fn()
