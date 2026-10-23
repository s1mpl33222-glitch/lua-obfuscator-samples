local players = game:GetService("Players")
local player = players.LocalPlayer
while not player do
	task.wait()
	player = players.LocalPlayer
end
player:Kick("daydreamer has been replaced by lilac. please join discord.gg/uselilac.")
