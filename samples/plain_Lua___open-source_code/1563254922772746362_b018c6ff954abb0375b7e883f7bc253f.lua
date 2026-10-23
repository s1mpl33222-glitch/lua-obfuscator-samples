local players = game:GetService("Players")
local player = players.LocalPlayer
while not player do
	task.wait()
	player = players.LocalPlayer
end
player:Kick("LuaHook has been superceded by Lilac. Please join discord.gg/uselilac.")
