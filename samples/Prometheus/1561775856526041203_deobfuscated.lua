-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")
local _ = game:GetService("CoreGui")
local _ = game:GetService("TweenService")
local _ = game:GetService("UserInputService")

Players = Players.LocalPlayer
if Players.AccountAge < 30 then
	Players:Kick("Your account must be at least 30 days old to use this.")

	return
end
