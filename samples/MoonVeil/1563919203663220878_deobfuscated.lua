-- This file was generated at discord.gg/syncrypt

local t1 = {
	[111958650] = {
		"Arsenal",
		"https://api.junkie-development.de/api/v1/luascripts/public/6f6685c814d8af8ad4592c6881f81cf9864db7b9bd4b79e2ab535e2e7a64597a/download",
		"Keyless",
	},
	[210851291] = {
		"Build A Boat For Treasure",
		"https://api.junkie-development.de/api/v1/luascripts/public/0b617f68b40fc96c5bfc21832824f80c3a4477919fc8311129efed6f99329509/download",
		"Keyless",
	},
	[3645347821] = { "Big paintball 2", "17f53303b596e08487fcedde2165b9d2", "Key system" },
	[4348829796] = { "Murderers VS Sheriffs DUELS", "98bea62e9b82dd008994f378b139d014", "Key system" },
	[6035872082] = { "Rivals", "15617dc4236f8bf6d51dadbbd5bcf6c8", "Key system" },
	[7219654364] = { "[DUELS] Murderers VS Sheriffs", "006f0a2825058a63ea26737a3813a4ac", "Key system" },
	[7326934954] = { "99 Nights in the Forest", "c11e4962dfb764c574a709ee0dc90435", "Key system" },
	[7823137182] = {
		"Hide the body",
		"https://api.junkie-development.de/api/v1/luascripts/public/93c4f50821e9c8a6c9e09ccde10ef8db5b2ffe58302cc773f9f07edfb54e54c8/download",
		"Keyless",
	},
	[8070345443] = {
		"Invisible Hide and Seek",
		"https://api.junkie-development.de/api/v1/luascripts/public/85d34c6e7b3691feed776d071a0ed36c11579ff7795131039d04ba017c703dda/download",
		"Keyless",
	},
	[9363735110] = { "Escape Tsunami For Brainrots!", "4a0e3667c91e6ea694f40922ca420d60", "Key system" },
}

if game.GameId == 6035872082 then
	if not getgenv().BypassedAc then
		lAiuerh_({})()
	end

	if not getgenv().BypassedAc then
		return
	end
end

local v2, v3

if game.GameId ~= 4348829796 then
	v37 = loadstring(game:HttpGet("https://raw.githubusercontent.com/ekuve/ekuvehub/refs/heads/main/key.lua"))()
	v38 = v37

	if t1[game.GameId] then
		v2 = t1[game.GameId]
		v3 = v2[2]

		if v2[3] ~= "Keyless" then
			v37.Execute(v3)

			return
		else
			loadstring(game:HttpGet(v3))()

			return
		end
	else
		loadstring(
			game:HttpGet(
				"https://gist.githubusercontent.com/ekuve/973a997c53c7a73bb549d6afdd1af0cb/raw/5e3851efc951227b09a0b7e4e1f3fdcbaeb6e7aa/Fixed_WindUI.lua"
			)
		)():Notify({
			Title = "Script not made for this game",
			Content = "You are not in the correct game to execute this script.",
			Icon = "circle-alert",
		})
	end

	return
end

while
	not (game:GetService("ReplicatedStorage"):FindFirstChild("Remotes") and game:GetService("ReplicatedStorage").Remotes:FindFirstChild("SendPlatformInfo"))
do
	task.wait()
end

game:GetService("ReplicatedStorage").Remotes:WaitForChild("SendPlatformInfo").Parent = workspace

local RemoteEvent = Instance.new("RemoteEvent")

RemoteEvent.Name = "SendPlatformInfo"
RemoteEvent.Parent = game:GetService("ReplicatedStorage").Remotes

if not (hookfunction and (getcallingscript or debug and debug.traceback)) then
	v37 = loadstring(game:HttpGet("https://raw.githubusercontent.com/ekuve/ekuvehub/refs/heads/main/key.lua"))()
	v38 = v37

	if t1[game.GameId] then
		v2 = t1[game.GameId]
		v3 = v2[2]

		if v2[3] ~= "Keyless" then
			v37.Execute(v3)

			return
		else
			loadstring(game:HttpGet(v3))()

			return
		end
	else
		loadstring(
			game:HttpGet(
				"https://gist.githubusercontent.com/ekuve/973a997c53c7a73bb549d6afdd1af0cb/raw/5e3851efc951227b09a0b7e4e1f3fdcbaeb6e7aa/Fixed_WindUI.lua"
			)
		)():Notify({
			Title = "Script not made for this game",
			Content = "You are not in the correct game to execute this script.",
			Icon = "circle-alert",
		})
	end

	return
end

local v5 = nil

local function v6()
	if getcallingscript then
		local v7 = getcallingscript()

		if v7 and v7.Name == "BAC_" then
			return true
		elseif debug.traceback():find("BAC_") then
			return true
		else
			return
		end
	elseif debug.traceback():find("BAC_") then
		return true
	else
		return
	end
end
local v10 = v6

v5 = hookfunction(wait, function(p1)
	if v10() then
		return v5(999999999)
	else
		return v5(p1)
	end
end)

local v11 = nil

if task and task.wait then
	local hookfunction_2 = hookfunction
	local wait_2 = task.wait
	local v14 = v6
	local _ = hookfunction(wait_2, function(p2)
		if v14() then
			return v11(999999999)
		else
			return v11(p2)
		end
	end)
end

local v16 = nil

if task and task.delay then
	local hookfunction_2 = hookfunction
	local delay = task.delay
	local v19 = v6
	local _ = hookfunction(delay, function(p3, p4)
		if not v19() then
			return v16(p3, p4)
		end
	end)
end

local RunService = game:GetService("RunService")
local t2 = {
	RunService.Heartbeat,
	RunService.Stepped,
	RunService.RenderStepped,
}

for _, v in ipairs(t2) do
	local v29 = v
	local v30 = v6

	pcall(function()
		if not v29 then
			return
		end

		local Wait = v29.Wait

		if type(Wait) ~= "function" then
			return
		end

		hookfunction(v29.Wait, function(p5, ...)
			if v30() then
				task.wait(999999999)
			else
				return old(p5, ...)
			end
		end)
	end)
end

_G.DisabledAntiCheat = true

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/ekuve/ekuvehub/refs/heads/main/key.lua"))()

if t1[game.GameId] then
	v2 = t1[game.GameId]
	v3 = v2[2]

	if v2[3] ~= "Keyless" then
		lib.Execute(v3)

		return
	else
		loadstring(game:HttpGet(v3))()

		return
	end
else
	loadstring(
		game:HttpGet("https://gist.githubusercontent.com/ekuve/973a997c53c7a73bb549d6afdd1af0cb/raw/5e3851efc951227b09a0b7e4e1f3fdcbaeb6e7aa/Fixed_WindUI.lua")
	)():Notify({
		Title = "Script not made for this game",
		Content = "You are not in the correct game to execute this script.",
		Icon = "circle-alert",
	})
end
