-- This file was generated at discord.gg/syncrypt

if game:GetService("CoreGui"):FindFirstChild("ToraScript") then
	game:GetService("CoreGui").ToraScript:Destroy()
end

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/liebertsx/Tora-Library/main/src/librarynew", true))()
local v2 = lib:CreateWindow("CDT Halloween 2026")

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

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

_G.Pumpkins = false

local t2 = {}

local function v9(p1)
	local Character = LocalPlayer.Character

	if p1 then
		RunService.Stepped:Connect(function()
			Character = LocalPlayer.Character

			if Character then
				local v11 = Character

				for _, descendant in ipairs(v11.GetDescendants(v11)) do
					if descendant:IsA("BasePart") then
						if t2[descendant] == nil then
							t2[descendant] = descendant.CanCollide
						end

						descendant.CanCollide = false
					end
				end
			end
		end)
	else
		for k, v in pairs(t2) do
			local Parent

			if k then
				Parent = k.Parent
			else
				Parent = k
			end

			if Parent then
				k.CanCollide = v
			end
		end

		table.clear(t2)
	end
end

local v17 = nil

local function v18()
	task.spawn(function()
		local v19 = workspace.Spawn.SpawnLocation.Position + Vector3.new(0, 100, 0)
		local n1 = 0
		local n2 = 0.17453292519943295
		local n3 = 20

		while true do
			while true do
				if not _G.Pumpkins then
					return
				end

				local Character = LocalPlayer.Character

				if Character then
					Character = Character:FindFirstChild("HumanoidRootPart")
				end

				if not Character then
					break
				end

				local HalloweenPumpkinsLocal = workspace:FindFirstChild("HalloweenPumpkinsLocal")
				local v25 = nil

				if HalloweenPumpkinsLocal then
					for _, descendant in ipairs(HalloweenPumpkinsLocal:GetDescendants()) do
						if descendant:IsA("BasePart") then
							v25 = descendant

							break
						end
					end
				end

				if v25 then
					if v17(Character, v25.CFrame + Vector3.new(0, 3, 0), 300) then
						task.wait(1)
					end
				else
					n1 = n1 + n2
					n3 = n3 + 200 * (n2 / (2 * math.pi))

					local vector3 = Vector3.new(v19.X + math.cos(n1) * n3, v19.Y, v19.Z + math.sin(n1) * n3)

					v17(Character, CFrame.new(vector3), 300)
				end

				task.wait()
			end

			task.wait(0.5)
		end
	end)
end

v17 = function(p2, p3, p4)
	while true do
		local Pumpkins = _G.Pumpkins

		if Pumpkins then
			if p2 then
				Pumpkins = p2.Parent
			else
				Pumpkins = p2
			end
		end

		if not Pumpkins then
			return false
		end

		local result = RunService.Heartbeat:Wait()

		if not _G.Pumpkins then
			return false
		end

		local Magnitude = (p3.Position - p2.Position).Magnitude

		if Magnitude < 0.5 then
			p2.CFrame = p3

			return true
		end

		p2.AssemblyLinearVelocity = Vector3.zero
		p2.CFrame = p2.CFrame:Lerp(p3, math.min(p4 * result / Magnitude, 1))
	end
end
v2:AddToggle({
	text = "Collect Pumpkins",
	flag = "toggle",
	state = false,
	callback = function(p5)
		_G.Pumpkins = p5
		v9(p5)
		print("Pumpkins:", p5)

		if not p5 then
			return
		end

		v18()
	end
})
v2.AddToggle(v2, {
	text = "Collect Crystals",
	flag = "toggle",
	state = false,
	callback = function(p6)
		_G.Crystals = p6
		print("Crystals: ", p6)

		if not p6 then
			return
		end

		Crystals()
	end
})

function Crystals()
	spawn(function()
		_G.Crystals = true

		while _G.Crystals do
			wait()
			pcall(function()
				for _, descendant in pairs(workspace.Collectibles.Halloween2026:GetDescendants()) do
					local v34

					if descendant.Name == "Part" then
						v34 = descendant.Transparency == 0
					else
						v34 = false
					end

					if v34 then
						game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = descendant.CFrame

						break
					end
				end

				wait(1)
			end)
		end
	end)
end

v2.AddToggle(v2, {
	text = "Loop Drive",
	flag = "toggle",
	state = false,
	callback = function(p7)
		_G.Drive = p7
		print("Drive: ", p7)

		if not p7 then
			return
		end

		Drive()
	end
})

function Drive()
	local pairs_ = pairs
	local Cars = workspace.Cars
	local Parent = nil

	for _, descendant in pairs_(Cars.GetDescendants(Cars)) do
		local v40 = descendant.Name == "Owner"

		if v40 then
			v40 = descendant.Value == game.Players.LocalPlayer.Name
		end

		if v40 then
			Parent = descendant.Parent.Parent
		end
	end

	Parent:SetPrimaryPartCFrame(CFrame.new(-4787, 602, 6058))
	spawn(function()
		local LocalPlayer2 = game.Players.LocalPlayer
		local Name = LocalPlayer2.Name
		local v43 = LocalPlayer2.Character.HumanoidRootPart.CFrame * CFrame.new(0, 5, 0)

		_G.Drive = true

		while _G.Drive do
			wait()
			pcall(function()
				local v44, v45, v46 = pairs(workspace.Cars:GetDescendants())
				local Parent2 = nil

				while true do
					local v48

					v46, v48 = v44(v45, v46)

					if not v46 then
						break
					end

					local v49

					if v48.Name == "Owner" then
						v49 = v48.Value == Name
					else
						v49 = false
					end

					if v49 then
						Parent2 = v48.Parent.Parent
					end
				end

				if not Parent2 then
					return
				end

				game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.W, false, game)
				wait(1)
				game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.W, false, game)
				wait(4)
				Parent2:SetPrimaryPartCFrame(v43)
			end)
		end
	end)
end

v2.AddToggle(v2, {
	text = "Speed Traps",
	flag = "toggle",
	state = false,
	callback = function(p8)
		_G.Traps = p8
		print("Traps: ", p8)

		if not p8 then
			return
		end

		Traps()
	end
})

function Traps()
	spawn(function()
		_G.Traps = true

		while _G.Traps do
			wait()
			pcall(function()
				local pairs_ = pairs
				local SpeedCameras = workspace.SpeedCameras

				for _, descendant in pairs_(SpeedCameras.GetDescendants(SpeedCameras)) do
					if descendant:IsA("TouchTransmitter") then
						descendant.Parent.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
					end
				end

				wait(1)
			end)
		end
	end)
end

v2.AddList(v2, {
	text = "Vote Laps",
	flag = "list",
	value = "==Select Laps==",
	values = { "x1", "x3", "x5" },
	callback = function(p9)
		if p9 == "x1" then
			lab = "1"

			return
		end

		if p9 == "x3" then
			lab = "3"

			return
		end

		if p9 ~= "x5" then
			return
		end

		lab = "5"
	end
})
v2.AddToggle(v2, {
	text = "Auto Join",
	flag = "toggle",
	state = false,
	callback = function(p10)
		_G.Join = p10
		print("Join: ", p10)

		if not p10 then
			return
		end

		Join()
	end
})

function Join()
	spawn(function()
		_G.Join = true

		while _G.Join do
			wait()
			pcall(function()
				if workspace.Races.Halloween:FindFirstChild("Extras") then
					wait(1)

					return
				end

				local pairs_ = pairs
				local Cars = workspace.Cars
				local Parent = nil

				for _, descendant in pairs_(Cars.GetDescendants(Cars)) do
					local v59 = descendant.Name == "Owner"

					if v59 then
						v59 = descendant.Value == game.Players.LocalPlayer.Name
					end

					if v59 then
						Parent = descendant.Parent.Parent
					end
				end

				Parent:SetPrimaryPartCFrame(CFrame.new(workspace.Races.Halloween.LobbyBottom.Position))
				workspace.Races.RaceHandler.StartLobby:FireServer("Halloween")
				workspace.Races.Halloween.Script.Vote:FireServer(lab, "Vote")
				wait(1)
			end)
		end
	end)
end

v2.AddToggle(v2, {
	text = "Auto Race",
	flag = "toggle",
	state = false,
	callback = function(p11)
		_G.Race = p11
		print("Race: ", p11)

		if not p11 then
			return
		end

		Race()
	end
})

function Race()
	spawn(function()
		_G.Race = true

		while _G.Race do
			wait()
			pcall(function()
				if workspace.Races.Halloween.Script.RaceProgress.Value ~= true then
					return
				end

				if workspace.Races.Halloween.GoalCheckpoint.IsActive.Value == false then
					local pairs_ = pairs
					local Cars = workspace.Cars
					local Parent = nil

					for _, descendant in pairs_(Cars.GetDescendants(Cars)) do
						local v65 = descendant.Name == "Owner"

						if v65 then
							v65 = descendant.Value == game.Players.LocalPlayer.Name
						end

						if v65 then
							Parent = descendant.Parent.Parent
						end
					end

					local pairs_2 = pairs
					local Checkpoints = workspace.Races.Halloween.Checkpoints

					for _, descendant in pairs_2(Checkpoints.GetDescendants(Checkpoints)) do
						local v70 = descendant.name == "Checkpoint"

						if v70 then
							v70 = descendant.Parent.IsActive.Value == true
						end

						if v70 then
							Parent:SetPrimaryPartCFrame(CFrame.new(descendant.Position))
						end
					end
				elseif workspace.Races.Halloween.GoalCheckpoint.IsActive.Value == true then
					local pairs_ = pairs
					local Cars = workspace.Cars
					local Parent = nil

					for _, descendant in pairs_(Cars.GetDescendants(Cars)) do
						local v76 = descendant.Name == "Owner"

						if v76 then
							v76 = descendant.Value == game.Players.LocalPlayer.Name
						end

						if v76 then
							Parent = descendant.Parent.Parent
						end
					end

					Parent:SetPrimaryPartCFrame(CFrame.new(workspace.Races.Halloween.GoalCheckpoint.GoalCheckpoint.Position))
				end

				wait(2.5)
				workspace.Races.Halloween.GoalPart.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
			end)
		end
	end)
end

v2.AddLabel(v2, {
	text = "YouTube: Tora IsMe"
})
lib:Init()
