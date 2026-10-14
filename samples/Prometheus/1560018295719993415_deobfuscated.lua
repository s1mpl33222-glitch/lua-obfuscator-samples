-- This file was generated at discord.gg/syncrypt

if autoload == nil then
	autoload = true
end
if autoleave == nil then
	autoleave = true
end
pcall(function()
	if not autoload then
		return
	end

	loadstring(game:HttpGet("https://raw.githubusercontent.com/thegop7y-ui/Unlock-all/refs/heads/main/Noks"))()

	if autoleave then
		queue_on_teleport("            pcall(function()\n                autoload = true\n                autoleave = true\n                loadstring(game:HttpGet(\"https://raw.githubusercontent.com/thegop7y-ui/Unlock-all/refs/heads/main/Noks\"))()\n            end)\n        ")
	end
end)
