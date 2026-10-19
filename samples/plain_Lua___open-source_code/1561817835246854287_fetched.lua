-- Ghost Hub key check. Obfuscate this, then paste it back into the dashboard.
local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")
local LP = Players.LocalPlayer
local function fail(msg) LP:Kick("[Ghost Hub] " .. tostring(msg)) error(msg, 0) end

local KEY = script_key or (getgenv and getgenv().script_key)
if type(KEY) ~= "string" or #KEY < 8 then fail("No key provided. Set script_key before the loadstring.") end

local hwid = (gethwid and gethwid()) or game:GetService("RbxAnalyticsService"):GetClientId()
local url = "https://ghostauth01.lovable.app/api/public/v/086848f0-4a6a-4ff5-b875-843c4ba137c4?key=" .. HttpService:UrlEncode(KEY)
  .. "&hwid=" .. HttpService:UrlEncode(hwid)
  .. "&uid=" .. tostring(LP.UserId)

local ok, res = pcall(function() return game:HttpGet(url) end)
if not ok or type(res) ~= "string" then fail("Key server unreachable") end
if res:sub(1, 4) == "ERR:" then fail(res:sub(5)) end

local fn, err = loadstring(res)
if not fn then fail("Script failed to load: " .. tostring(err)) end
return fn()
