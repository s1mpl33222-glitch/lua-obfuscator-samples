-- This file was generated at discord.gg/syncrypt

if game:GetService("CoreGui"):FindFirstChild("ToraScript") then
	game:GetService("CoreGui").ToraScript:Destroy()
end

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew", true))()
local v2 = lib:CreateWindow("Bullets VS Everything")

task.spawn(function()
	local now = tick()
	local t1 = { "%H", "%M", "%S" }

	while task.wait() do
		if tick() - now >= 1 then
			now = tick()
			os.date(table.concat(t1, ":"))
		end
	end
end)
v2.AddToggle(v2, {
	text = "Perfect FireShot",
	flag = "toggle",
	state = false,
	callback = function(p1)
		_G.Perfect = p1
		print("Perfect: ", p1)

		if not p1 then
			return
		end

		Perfect()
	end
})

function Perfect()
	spawn(function()
		_G.Perfect = true

		while _G.Perfect do
			wait()
			pcall(function()
				game:GetService("ReplicatedStorage").Remotes.FireShot:InvokeServer(require(game:GetService("ReplicatedStorage"):WaitForChild("Shared"):WaitForChild("Remotes")).Get("BeginShot"):InvokeServer().Token, 1)
				wait(0.2)
			end)
		end
	end)
end

v2.AddToggle(v2, {
	text = "Click Train & Bubble",
	flag = "toggle",
	state = false,
	callback = function(p2)
		_G.Train = p2
		print("Train: ", p2)

		if not p2 then
			return
		end

		Train()
	end
})

function Train()
	spawn(function()
		_G.Train = true

		while _G.Train do
			wait()
			pcall(function()
				local game_ = game

				game_.GetService(game_, "ReplicatedStorage").Remotes.Training:FireServer(unpack({ "Tap" }))

				local Button = game:GetService("Players").LocalPlayer.PlayerGui.TrainingBubbles.Bubble.Button

				for _, v in ipairs(getconnections(Button.Activated)) do
					v:Fire()
				end

				wait(0.1)
			end)
		end
	end)
end

v2.AddToggle(v2, {
	text = "Buy Slot",
	flag = "toggle",
	state = false,
	callback = function(p3)
		_G.Slot = p3
		print("Slot: ", p3)

		if not p3 then
			return
		end

		Slot()
	end
})

function Slot()
	spawn(function()
		_G.Slot = true

		while _G.Slot do
			wait()
			pcall(function()
				game:GetService("ReplicatedStorage").Remotes.Action:InvokeServer("BuySlot")
				wait(1)
			end)
		end
	end)
end

v2.AddToggle(v2, {
	text = "Buy Gun",
	flag = "toggle",
	state = false,
	callback = function(p4)
		_G.Gun = p4
		print("Gun: ", p4)

		if not p4 then
			return
		end

		Gun()
	end
})

function Gun()
	spawn(function()
		_G.Gun = true

		while _G.Gun do
			wait()
			pcall(function()
				game:GetService("ReplicatedStorage").Remotes.Action:InvokeServer("BuyGun")
				wait(1)
			end)
		end
	end)
end

v2.AddToggle(v2, {
	text = "Equip Best",
	flag = "toggle",
	state = false,
	callback = function(p5)
		_G.Equip = p5
		print("Equip: ", p5)

		if not p5 then
			return
		end

		Equip()
	end
})

function Equip()
	spawn(function()
		_G.Equip = true

		while _G.Equip do
			wait()
			pcall(function()
				game:GetService("ReplicatedStorage").Remotes.Action:InvokeServer("EquipBest")
				game:GetService("ReplicatedStorage").Remotes.Action:InvokeServer("EquipBestCrateGun")
				wait(2)
			end)
		end
	end)
end

v2.AddToggle(v2, {
	text = "Auto Rebirth",
	flag = "toggle",
	state = false,
	callback = function(p6)
		_G.Rebirth = p6
		print("Rebirth: ", p6)

		if not p6 then
			return
		end

		Rebirth()
	end
})

function Rebirth()
	spawn(function()
		_G.Rebirth = true

		while _G.Rebirth do
			wait()
			pcall(function()
				game:GetService("ReplicatedStorage").Remotes.Action:InvokeServer("Rebirth")
				wait(2)
			end)
		end
	end)
end

v2:AddLabel({
	text = "YouTube: Tora IsMe"
})
lib:Init()
