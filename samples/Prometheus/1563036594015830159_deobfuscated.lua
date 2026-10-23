-- This file was generated at discord.gg/syncrypt

local loadstring_ = loadstring or (getgenv().loadstring or getfenv().loadstring)
local HttpGet = game.HttpGet
local v3

if loadstring_ then
	v3 = HttpGet
else
	v3 = loadstring_
end

if not v3 then
	return
end

local PlaceId = game.PlaceId
local v5 = tostring(PlaceId)
local u6 = nil

if pcall(function()
	u6 = HttpGet(game, "https://raw.githubusercontent.com/hololove1021/HolonHUB/refs/heads/main/main/" .. v5 .. "-en.lua")
end) then
	loadstring_(u6)()
else
	warn("Script not found for this game in HolonHUB repository.")
end
