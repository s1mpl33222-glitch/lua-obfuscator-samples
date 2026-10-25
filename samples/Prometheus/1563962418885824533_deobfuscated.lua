-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack

game:GetService("Players").LocalPlayer.Idled:connect(function()
	game:GetService("VirtualUser"):CaptureController()
	game:GetService("VirtualUser"):ClickButton2(Vector2.new())
	game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, true, game, 0)
	task.wait()
	game:GetService("VirtualInputManager"):SendMouseButtonEvent(0, 0, 0, false, game, 0)
end)
getfenv().grav = workspace.Gravity

local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/Marco8642/science/main/ui%20libs2"))()
local v3 = lib:CreateWindow({
	text = "Vehicle Legends"
})

v3:AddBox("Enter Vehicle Speed", function(p1, p2)
	if not p2 then
		return
	end

	local env = getfenv()
	local Text = p1.Text

	env.speed = tonumber(Text)
end)
v3.AddToggle(v3, "Auto Drive", function(p3)
	getfenv().drive = p3 and true or false

	local function v6()
		game.Players.LocalPlayer:RequestStreamAroundAsync(unpack_({ Vector3.new(656.842041, 6.3375659, 2981.96436) }))
	end

	spawn(v6)
	wait(1)

	local v7 = game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name .. "\'s Car"]

	v7:PivotTo(unpack_({ CFrame.new(Vector3.new(656.842041, 6.3375659, 2981.96436), Vector3.new(592.12439, 6.33634377, 1080.79797)) }))
	v7.PrimaryPart = v7.Weight
	wait(1)

	while getfenv().drive do
		task.wait()
		mathlock = getfenv().speed or 300

		local vector3 = Vector3.new(592.12439, 6.33634377, 1080.79797)

		if getfenv().drive then
			if game.Players.LocalPlayer:DistanceFromCharacter(vector3) >= 50 then
				local _ = getfenv().drive == false
			end

			repeat
				task.wait()
				mathlock = getfenv().speed or 300
				v7.PrimaryPart.AssemblyLinearVelocity = Vector3.new(v7.PrimaryPart.AssemblyLinearVelocity.X, -10, v7.PrimaryPart.AssemblyLinearVelocity.Z)
				v7.PrimaryPart.AssemblyLinearVelocity = v7.PrimaryPart.CFrame.LookVector * mathlock
				v7.PrimaryPart.AssemblyLinearVelocity = Vector3.new(v7.PrimaryPart.AssemblyLinearVelocity.X, -10, v7.PrimaryPart.AssemblyLinearVelocity.Z)
				v7:PivotTo(CFrame.new(v7.PrimaryPart.Position, vector3))
				v7.PrimaryPart.AssemblyLinearVelocity = Vector3.new(v7.PrimaryPart.AssemblyLinearVelocity.X, -10, v7.PrimaryPart.AssemblyLinearVelocity.Z)
			until game.Players.LocalPlayer:DistanceFromCharacter(vector3) < 50 or getfenv().drive == false
		end

		local vector32 = Vector3.new(656.842041, 6.3375659, 2981.96436)

		if getfenv().drive then
			if game.Players.LocalPlayer:DistanceFromCharacter(vector32) >= 50 then
				local _ = getfenv().drive == false
			end

			repeat
				task.wait()
				mathlock = getfenv().speed or 300
				v7.PrimaryPart.AssemblyLinearVelocity = Vector3.new(v7.PrimaryPart.AssemblyLinearVelocity.X, -10, v7.PrimaryPart.AssemblyLinearVelocity.Z)
				v7.PrimaryPart.AssemblyLinearVelocity = v7.PrimaryPart.CFrame.LookVector * mathlock
				v7.PrimaryPart.AssemblyLinearVelocity = Vector3.new(v7.PrimaryPart.AssemblyLinearVelocity.X, -10, v7.PrimaryPart.AssemblyLinearVelocity.Z)
				v7:PivotTo(CFrame.new(v7.PrimaryPart.Position, vector32))
				v7.PrimaryPart.AssemblyLinearVelocity = Vector3.new(v7.PrimaryPart.AssemblyLinearVelocity.X, -10, v7.PrimaryPart.AssemblyLinearVelocity.Z)
			until game.Players.LocalPlayer:DistanceFromCharacter(vector32) < 50 or getfenv().drive == false
		end
	end
end)
v3:AddToggle("Auto Race", function(p4)
	getfenv().test = p4 and true or false
	_G.rat = nil
	getfenv().racename = nil

	local huge = math.huge
	local pairs_ = pairs
	local Races = workspace.Races

	for _, descendant in pairs_(Races.GetDescendants(Races)) do
		local v17 = descendant.ClassName == "Part"

		if v17 then
			v17 = descendant.Name == "Queue"
		end

		if v17 then
			local magnitude = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - descendant.Position).magnitude

			if magnitude < huge then
				getfenv().racename = descendant.Parent.Parent.Name
				_G.rat = descendant
				huge = magnitude
			end
		end
	end

	workspace.Gravity = getfenv().grav

	local CFrame_ = _G.rat.CFrame
	local _ = game.Players.LocalPlayer.Character
	local v21 = game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name .. "\'s Car"]

	v21.PrimaryPart = v21.Weight

	while true do
		if not getfenv().test then
			return
		end

		task.wait()

		local v22 = game:GetService("Players").LocalPlayer.PlayerGui.Races.Timer.Visible == true

		if v22 then
			v22 = game:GetService("Players").LocalPlayer.PlayerGui.Races.WaitingForPlayers.Visible == false

			if v22 then
				v22 = v21:GetAttribute("InRace") == true

				if v22 then
					v22 = game:GetService("Players").LocalPlayer.PlayerGui.Races.main.content.Timer.timer.Text ~= "00:00:00"
				end
			end
		end

		if v22 then
			print("ye boi")
			task.wait()

			local v23 = #game:GetService("Workspace").RaceProps.Checkpoints:GetChildren()
			local _
			-- NumForInit
local n1, v28, n2 = 1, game:GetService("ReplicatedStorage").Event.GetRaceLaps:InvokeServer()[getfenv().racename] + 100, 1

-- end NumForInit
			while true do
				n1 = n1 + n2

				if (0 >= n2 or n1 > v28) and (n2 > 0 or v28 > n1) then
					break
				end

				local v30 = v23
				local n3 = 0
				local n4 = 1
				local v33 = false

				while true do
					n3 = n3 + n4

					local v34 = ((not v33 or v23 > n3) and true or false) and not v33

					if v34 then
						v34 = n3 <= v23
					end

					if not v34 then
						break
					end

					local Checkpoints = game:GetService("Workspace").RaceProps:FindFirstChild("Checkpoints")

					if Checkpoints then
						Checkpoints = game:GetService("Workspace").RaceProps.Checkpoints:FindFirstChild(n3)
					end

					if Checkpoints then
						local v36 = game:GetService("Workspace").RaceProps.Checkpoints[n3]

						if v36 == nil then
							v36 = game:GetService("Workspace").RaceProps.Checkpoints[tostring(n3)]
						end

						local speed = getfenv().speed or 300
						local magnitude = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v36.Position).magnitude
						local v39 = game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name .. "\'s Car"]
						local TweenService = game:GetService("TweenService")
						local tweenInfo = TweenInfo.new(magnitude / speed, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, 0, false, 0)
						local CFrameValue = Instance.new("CFrameValue")

						CFrameValue.Value = v39:GetPrimaryPartCFrame()
						CFrameValue.Changed:Connect(function()
							v39:PivotTo(CFrameValue.Value)
							v39.PrimaryPart.Velocity = v36.CFrame.LookVector * speed
							v39.PrimaryPart.Velocity = Vector3.new(v39.PrimaryPart.Velocity.X, 0, v39.PrimaryPart.Velocity.Z)
						end)

						local v43 = v36

						getfenv().tween = TweenService.Create(TweenService, CFrameValue, tweenInfo, {
							Value = v43.CFrame
						})
						getfenv().tween:Play()

						if v39:GetAttribute("InRace") == true and (getfenv().tween.PlaybackState ~= Enum.PlaybackState.Cancelled and getfenv().tween.PlaybackState ~= Enum.PlaybackState.Completed) then
							local _ = getfenv().tween.PlaybackState == Enum.PlaybackState.Paused
						end

						repeat
							task.wait()
						until v39:GetAttribute("InRace") ~= true or (getfenv().tween.PlaybackState == Enum.PlaybackState.Cancelled or (getfenv().tween.PlaybackState == Enum.PlaybackState.Completed or getfenv().tween.PlaybackState == Enum.PlaybackState.Paused))

						finished = true

						local v45 = getfenv().tween ~= nil

						if v45 then
							v45 = getfenv().tween.PlaybackState ~= Enum.PlaybackState.Completed
						end

						if v45 then
							getfenv().tween:Cancel()
						end
					end

					continue
				end

				v23 = v30

				continue
			end

			local _ = game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name .. "\'s Car"]

			continue
		else
			local v47 = game:GetService("Players").LocalPlayer.PlayerGui.Races.Timer.Visible == false

			if v47 then
				v47 = v21:GetAttribute("InRace") ~= true

				if v47 then
					v47 = not game:GetService("Workspace").RaceProps:FindFirstChild("Checkpoints")

					if v47 then
						v47 = game.Players.LocalPlayer:DistanceFromCharacter(Vector3.new(CFrame_.X, game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame.Y, CFrame_.Z)) > 15
					end
				end
			end

			if v47 then
				workspace.Gravity = getfenv().grav

				local v48 = game:GetService("Workspace").Vehicles[game.Players.LocalPlayer.Name .. "\'s Car"]

				v48.PrimaryPart.Velocity = Vector3.new(0, 0, 0)
				v48:PivotTo(CFrame_)
				wait(1)
			end

			continue
		end
	end
end)
v3:AddButton("Smash Snowmen", function(_)
	local Character = game.Players.LocalPlayer.Character
	local pairs_ = pairs
	local BreakableSnowmens = workspace.BreakableSnowmens

	for _, child in pairs_(BreakableSnowmens.GetChildren(BreakableSnowmens)) do
		Character:PivotTo(unpack_({ child.GetPivot(child) }))
		task.wait(0.4)
		game:GetService("ReplicatedStorage").Event.ChallengesTracker.SmashedSnowman:FireServer(child)
		task.wait()
	end
end)

local v54 = lib:CreateWindow({
	text = "Race Custom Laps"
})

v54:AddLabel("                  Select Race", function(_, _) end)
v54:AddDropdown((function()
	local pairs_ = pairs
	local RaceStorage = game:GetService("ReplicatedStorage").Storage.RaceStorage
	local t1 = {}

	for _, child in pairs_(RaceStorage.GetChildren(RaceStorage)) do
		if child:IsA("Folder") then
			local Name = child.Name

			table.insert(t1, Name)
		end
	end

	return t1
end)(), function(p5)
	getfenv().selectedrace = p5
end)
v54:AddLabel("            Race Laps Changer", function(_, _) end)
v54:AddBox("Enter Race Laps Amount", function(p6, p7)
	if not p7 then
		return
	end

	local PrivateServer = game:GetService("ReplicatedStorage").Event.PrivateServer
	local selectedrace = getfenv().selectedrace
	local Text = p6.Text

	PrivateServer:InvokeServer("ChangeLaps", selectedrace, (tonumber(Text)))
end)
