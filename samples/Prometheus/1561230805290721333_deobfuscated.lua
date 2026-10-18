-- This file was generated at discord.gg/syncrypt

local n1 = 0
local connection = game:GetService("RunService").Heartbeat:Connect(function()
	n1 = n1 + 1
end)

repeat
	task.wait()
until n1 >= 2
connection:Disconnect()
