-- This file was generated at discord.gg/syncrypt

local t1 = {}
local unpack_ = unpack or table.unpack
local UserInputService = game:GetService("UserInputService")
local TouchEnabled = UserInputService.TouchEnabled

if TouchEnabled then
	TouchEnabled = not UserInputService.KeyboardEnabled
end

local Add, CharacterAdded, Parent, Parent2

if TouchEnabled then
	local lib = loadstring(game:HttpGet("https://sirius.menu/rayfield"))()
	local Players = game:GetService("Players")
	local RunService = game:GetService("RunService")
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Workspace = game:GetService("Workspace")
	local LocalPlayer = Players.LocalPlayer

	getgenv().SecureMode = true

	local Assets = ReplicatedStorage:FindFirstChild("Assets")

	if Assets then
		Assets = ReplicatedStorage.Assets:FindFirstChild("Modules") and ReplicatedStorage.Assets.Modules:FindFirstChild("Client")

		if Assets then
			Assets = ReplicatedStorage.Assets.Modules.Client:FindFirstChild("Mechanics")
		end
	end

	if Assets then
		Assets = require(Assets)
	end

	local value1 = {
		connections = {},
		Add = function(p1, p2, p3)
			if not p1.connections[p2] then
				p1.connections[p2] = p3

				return
			end

			p1.connections[p2]:Disconnect()
			p1.connections[p2] = p3
		end,
		Remove = function(p4, p5)
			if not p4.connections[p5] then
				return
			end

			p4.connections[p5]:Disconnect()
			p4.connections[p5] = nil
		end,
		CleanupAll = function(p6)
			for _, connection in pairs(p6.connections) do
				if connection then
					connection:Disconnect()
				end
			end

			p6.connections = {}
		end
	}
	local u19 = false
	local u20 = false
	local u21 = false
	local u22 = false
	local u23 = false
	local u24 = false
	local u25 = false
	local u26 = false
	local u27 = false
	local n1 = 15
	local n2 = 0.2
	local n3 = 50
	local n4 = 1
	local n5 = 5
	local n6 = 5
	local n7 = 35
	local n8 = 0.5
	local n9 = 32
	local connection = nil
	local connection2 = nil
	local s1 = "Buttons"
	local v40 = Workspace:FindFirstChild("ParkMatchMap") ~= nil
	local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
	local Humanoid = Character:WaitForChild("Humanoid")
	local Head = Character:WaitForChild("Head")
	local Size = Head.Size
	local Transparency = Head.Transparency

	t1.value1 = value1
	TouchEnabled = function(p7)
		Character = p7
		HumanoidRootPart = p7:WaitForChild("HumanoidRootPart")
		Humanoid = p7:WaitForChild("Humanoid")
		Head = p7:WaitForChild("Head")
		Size = Head.Size
		Transparency = Head.Transparency
	end
	t1.value2 = LocalPlayer
	Add = t1.value1.Add
	CharacterAdded = t1.value2.CharacterAdded
	t1.value2 = { CharacterAdded.Connect(CharacterAdded, TouchEnabled) }
	Add(t1.value1, "CharacterAdded", unpack_(t1.value2))

	local function v47()
		local ParkMap = Workspace:FindFirstChild("ParkMap")
		local Replicated

		if ParkMap then
			Replicated = ParkMap:FindFirstChild("Replicated")
		else
			Replicated = ParkMap
		end

		local Fields = Replicated and ParkMap.Replicated:FindFirstChild("Fields")

		if Fields then
			local t2 = {
				Fields:FindFirstChild("LeftField"),
				Fields:FindFirstChild("RightField"),
				Fields:FindFirstChild("BLeftField"),
				Fields:FindFirstChild("BRightField"),
				Fields:FindFirstChild("HighField"),
				Fields:FindFirstChild("TLeftField"),
				Fields.FindFirstChild(Fields, "TRightField")
			}

			for _, v in ipairs(t2) do
				local Replicated2

				if v then
					Replicated2 = v:FindFirstChild("Replicated")
				else
					Replicated2 = v
				end

				if Replicated2 then
					local Football = v.Replicated:FindFirstChild("Football")
					local isBasePart

					if Football then
						isBasePart = Football:IsA("BasePart")
					else
						isBasePart = Football
					end

					if isBasePart then
						return Football
					end
				end
			end
		end

		if v40 then
			local ParkMatchMap = Workspace:FindFirstChild("ParkMatchMap")
			local Replicated2

			if ParkMatchMap then
				Replicated2 = ParkMatchMap:FindFirstChild("Replicated")
			else
				Replicated2 = ParkMatchMap
			end

			if Replicated2 then
				local Fields2 = ParkMatchMap.Replicated:FindFirstChild("Fields")
				local MatchField

				if Fields2 then
					MatchField = Fields2:FindFirstChild("MatchField")
				else
					MatchField = Fields2
				end

				local Replicated3 = MatchField and Fields2.MatchField:FindFirstChild("Replicated")

				if Replicated3 then
					local Football = Replicated3:FindFirstChild("Football")
					local isBasePart

					if Football then
						isBasePart = Football:IsA("BasePart")
					else
						isBasePart = Football
					end

					if isBasePart then
						return Football
					end
				end
			end
		end

		local Games = Workspace:FindFirstChild("Games")

		if not Games then
			return nil
		end

		for _, child in ipairs(Games.GetChildren(Games)) do
			local Replicated2 = child:FindFirstChild("Replicated")

			if Replicated2 then
				local v68 = Replicated2:FindFirstChild("918f5408-d86a-4fb8-a88c-5cab57410acf")
				local isBasePart

				if v68 then
					isBasePart = v68:IsA("BasePart")
				else
					isBasePart = v68
				end

				if isBasePart then
					return v68
				end

				local GetChildren = Replicated2.GetChildren

				for _, v in ipairs(GetChildren(Replicated2)) do
					local isBasePart2 = v:IsA("BasePart")

					if isBasePart2 then
						isBasePart2 = v.Name == "Football"
					end

					if isBasePart2 then
						return v
					end
				end
			end
		end

		return nil
	end
	local function v74()
		local v75 = Players

		for _, player in ipairs(v75.GetPlayers(v75)) do
			local v78

			if player == LocalPlayer then
				v78 = false
			else
				v78 = player.Character
			end

			if v78 and player.Character:FindFirstChild("Football") then
				return player
			end
		end

		return nil
	end

	function t1.value2()
		local v79 = v47()
		local v80

		if v79 then
			v80 = HumanoidRootPart
		else
			v80 = v79
		end

		if not v80 then
			return
		end

		if Workspace:FindFirstChild("ParkMap") and n7 < (v79.Position - HumanoidRootPart.Position).Magnitude then
			return
		end

		local Velocity = v79.Velocity
		local vector3 = Velocity.Magnitude > 0 and Velocity.Unit * n1 or Vector3.new(0, 0, 0)
		local v83 = v79.Position + vector3 + Vector3.new(0, 3, 0)
		local Unit = (v79.Position - HumanoidRootPart.Position).Unit

		HumanoidRootPart.CFrame = HumanoidRootPart.CFrame:Lerp(CFrame.new(v83, v83 + Unit), n2)
	end

	CharacterAdded = t1.value2

	local function v85(p8)
		local BodyVelocity = Instance.new("BodyVelocity")

		BodyVelocity.Velocity = Vector3.new(0, n9, 0)
		BodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
		BodyVelocity.P = 5000
		BodyVelocity.Parent = p8
		game:GetService("Debris"):AddItem(BodyVelocity, 0.2)
	end

	local Players2 = game:GetService("Players")

	CharacterAdded = Players2.LocalPlayer

	local TweenService = game:GetService("TweenService")
	local LocalPlayer2 = game:GetService("Players").LocalPlayer

	getgenv().turkeyFarmEnabled = getgenv().turkeyFarmEnabled or false

	local function v90()
		local Character2 = LocalPlayer2.Character
		local Character3 = LocalPlayer2.Character

		if not Character3 then
			return Character2, Character3
		end

		Character3 = LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")

		return Character2, Character3
	end
	local function v93(p9)
		local Parent3

		if p9 then
			Parent3 = p9.Parent

			if not Parent3 then
				return Parent3
			end

			Parent3 = p9:IsDescendantOf(workspace)
		else
			Parent3 = p9
		end

		return Parent3
	end

	getgenv().turkeySpeed = getgenv().turkeySpeed or 0.3

	local function v95()
		local ipairs_ = ipairs
		local MiniGames = workspace.MiniGames

		for _, child in ipairs_(MiniGames.GetChildren(MiniGames)) do
			local Replicated = child:FindFirstChild("Replicated")
			local Turkeys

			if Replicated then
				Turkeys = Replicated:FindFirstChild("Turkeys")
			else
				Turkeys = Replicated
			end

			if Turkeys then
				return Replicated
			end
		end

		return nil
	end
	local function v102()
		return LocalPlayer2.Replicated.TeamID.Value == "AwayTeam" and Vector3.new(137, 372, 0) or Vector3.new(-138, 372, 2)
	end

	local connection3 = nil

	local function v104(p10, p11, p12, p13)
		local v105 = (p10.Position - p11).Magnitude / 100
		local v106 = math.max(p12 or 0.5, v105)
		local tween = TweenService:Create(p10, TweenInfo.new(v106, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut), {
			CFrame = CFrame.new(p11)
		})

		tween:Play()

		if not p13 then
			tween.Completed:Wait()

			return true
		end

		local connection4 = nil
		local Y = p10.Position.Y

		connection4 = game:GetService("RunService").Heartbeat:Connect(function()
			if v93(p13) then
				if p10.Position.Y < Y - 10 then
					tween:Cancel()
					connection4:Disconnect()

					return
				else
					return
				end
			else
				tween:Cancel()
				connection4:Disconnect()
			end
		end)
		tween.Completed:Wait()
		connection4:Disconnect()

		if p10.Position.Y < Y - 10 then
			return false
		else
			return v93(p13)
		end
	end

	game:GetService("RunService").Heartbeat:Connect(function()
		if getgenv().turkeyFarmEnabled then
			if connection3 then
				return
			end

			connection3 = game:GetService("RunService").Heartbeat:Connect(function()
				if getgenv().turkeyFarmEnabled then
					task.spawn(function()
						local v110, v111 = v90()

						if not (v110 and v111) then
							return
						end

						local v112 = v95()

						if not v112 then
							return
						end

						local Turkeys = v112:FindFirstChild("Turkeys")

						if not Turkeys then
							return
						end

						local v114, v115, v116 = pairs(Turkeys:GetChildren())
						local t3 = {}

						while true do
							local v118

							v116, v118 = v114(v115, v116)

							if not v116 then
								break
							end

							local isBasePart = v118:IsA("BasePart")

							if isBasePart then
								isBasePart = v93(v118)
							end

							if isBasePart then
								table.insert(t3, v118)
							end
						end

						for _, v in ipairs(t3) do
							if not getgenv().turkeyFarmEnabled then
								return
							end

							if v93(v) then
								pcall(function()
									local _, v123 = v90()

									if not v123 then
										return
									end

									if v123.Position.Y - v.Position.Y > 15 then
										return
									end

									local v124 = v104(v123, v.Position, getgenv().turkeySpeed, v)

									if v124 then
										v124 = v93(v)
									end

									if not v124 then
										return
									end

									firetouchinterest(v123, v, 0)
									firetouchinterest(v123, v, 1)
									task.wait(0.1)
									v104(v123, v102(), getgenv().turkeySpeed, nil)
									task.wait(0.1)
								end)
							end
						end
					end)

					return
				end

				if not connection3 then
					return
				end

				connection3:Disconnect()
				connection3 = nil
			end)

			return
		end

		if not connection3 then
			return
		end

		connection3:Disconnect()
	end)

	local function v125()
		if not u24 then
			return
		end

		local Replicated = LocalPlayer:FindFirstChild("Replicated")

		if Replicated then
			Replicated = LocalPlayer.Replicated:FindFirstChild("GameID")
		end

		if not Replicated then
			return
		end

		local Value = Replicated.Value
		local Games = ReplicatedStorage:FindFirstChild("Games")

		if Games then
			local v129 = Games:FindFirstChild(Value)
			local GameParams = v129 and v129:FindFirstChild("GameParams")

			if GameParams then
				local DivePower = GameParams:FindFirstChild("DivePower")
				local isNumberValue

				if DivePower then
					isNumberValue = DivePower:IsA("NumberValue")
				else
					isNumberValue = DivePower
				end

				if isNumberValue then
					DivePower.Value = diveBoostPower
				end
			end
		end

		local MiniGames = ReplicatedStorage:FindFirstChild("MiniGames")

		if not MiniGames then
			return
		end

		local v134 = MiniGames:FindFirstChild(Value)
		local GameParams = v134 and v134:FindFirstChild("GameParams")

		if not GameParams then
			return
		end

		local DivePower = GameParams:FindFirstChild("DivePower")
		local isNumberValue

		if DivePower then
			isNumberValue = DivePower:IsA("NumberValue")
		else
			isNumberValue = DivePower
		end

		if not isNumberValue then
			return
		end

		DivePower.Value = diveBoostPower
	end
	local function v138(p14)
		local HumanoidRootPart2 = p14:WaitForChild("HumanoidRootPart")
		local v140 = value1
		local Touched = HumanoidRootPart2.Touched

		local function v142(p15)
			if not u22 or false then
				return
			end

			if HumanoidRootPart2.Velocity.Y >= -2 then
				return
			end

			local Model = p15:FindFirstAncestorWhichIsA("Model")
			local Humanoid2

			if Model then
				Humanoid2 = Model:FindFirstChild("Humanoid")
			else
				Humanoid2 = Model
			end

			if Model then
				if Model == p14 then
					Humanoid2 = false
				end
			else
				Humanoid2 = Model
			end

			if not Humanoid2 then
				return
			end

			if u23 then
				v85(HumanoidRootPart2)
				task.delay(1, function() end)

				return
			end

			local v145 = v47()

			if not (v145 and (v145.Position - HumanoidRootPart2.Position).Magnitude <= 10) then
				return
			end

			v85(HumanoidRootPart2)
			task.delay(1, function() end)
		end

		local Connect = Touched.Connect

		v140.Add(v140, "JumpBoostTouch", unpack_({ Connect(Touched, v142) }))
	end

	CharacterAdded = Instance.new("ScreenGui")
	CharacterAdded.Name = "PullButtonGui"
	CharacterAdded.ResetOnSpawn = false
	CharacterAdded.Parent = LocalPlayer:WaitForChild("PlayerGui")

	local Frame = Instance.new("Frame")

	Frame.Name = "PullContainer"
	Frame.Size = UDim2.new(0, 100, 0, 100)
	Frame.Position = UDim2.new(0.85, 0, 0.7, 0)
	Frame.BackgroundTransparency = 1
	Frame.Active = true
	Frame.Draggable = false
	Frame.Parent = CharacterAdded

	local TextButton = Instance.new("TextButton")

	TextButton.Size = UDim2.new(0, 70, 0, 70)
	TextButton.Position = UDim2.new(0, 15, 0, 15)
	TextButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	TextButton.BorderSizePixel = 0
	TextButton.Text = "Pull"
	TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton.Font = Enum.Font.GothamBold
	TextButton.TextSize = 16
	TextButton.Parent = Frame
	Add = Instance.new("UICorner")
	Add.CornerRadius = UDim.new(1, 0)
	Add.Parent = TextButton

	local Frame2 = Instance.new("Frame")

	Frame2.Size = UDim2.new(0, 100, 0, 100)
	Frame2.Position = UDim2.new(0.85, 0, 0.55, 0)
	Frame2.BackgroundTransparency = 1
	Frame2.Active = true
	Frame2.Draggable = false
	Frame2.Parent = CharacterAdded

	local TextButton2 = Instance.new("TextButton")

	TextButton2.Size = UDim2.new(0, 70, 0, 70)
	TextButton2.Position = UDim2.new(0, 15, 0, 15)
	TextButton2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	TextButton2.BorderSizePixel = 0
	TextButton2.Text = "Legit"
	TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton2.Font = Enum.Font.GothamBold
	TextButton2.TextSize = 16
	TextButton2.Parent = Frame2
	CharacterAdded = Instance.new("UICorner")
	CharacterAdded.CornerRadius = UDim.new(1, 0)
	CharacterAdded.Parent = TextButton2
	TextButton.MouseButton1Down:Connect(function() end)
	TextButton.MouseButton1Up:Connect(function()
		u25 = false
		TextButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	end)
	TextButton2.MouseButton1Down:Connect(function() end)
	TextButton2.MouseButton1Up:Connect(function()
		u26 = false
		TextButton2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	end)
	UserInputService.TouchEnded:Connect(function(_, _)
		if u25 then
			u25 = false
			TextButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		end

		if not u26 then
			return
		end

		u26 = false
		TextButton2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	end)
	RunService.RenderStepped:Connect(function()
		if not u25 then
			TextButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			TextButton.Text = "Pull"
		end

		if not u26 then
			TextButton2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
			TextButton2.Text = "Legit"
		end

		if s1 == "Tapping" then
			TextButton.Visible = false
			TextButton2.Visible = false

			return
		end

		if not (s1 == "Buttons" and true or s1 == "Both") then
			return
		end

		TextButton.Visible = false
		TextButton2.Visible = false
	end)
	UserInputService.InputBegan:Connect(function(input, gameProcessed)
		if not gameProcessed then
			local v151

			if input.UserInputType == Enum.UserInputType.Gamepad1 then
				v151 = input.KeyCode == Enum.KeyCode.ButtonR2
			else
				v151 = false
			end
		end
	end)
	UserInputService.InputEnded:Connect(function(input, _)
		local v152

		if input.UserInputType == Enum.UserInputType.Gamepad1 then
			v152 = input.KeyCode == Enum.KeyCode.ButtonR2
		else
			v152 = false
		end

		if not v152 then
			return
		end

		if u25 then
			TextButton.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
		end

		if not u26 then
			return
		end

		TextButton2.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	end)

	local function v153(p16)
		local PlayerGui = LocalPlayer:FindFirstChild("PlayerGui")

		if PlayerGui then
			local Menu = PlayerGui:FindFirstChild("Menu")
			local Basis = Menu and Menu:FindFirstChild("Basis")

			if Basis then
				local Window = Basis:FindFirstChild("Window")
				local AddFriends = Window and Window:FindFirstChild("AddFriends")

				if AddFriends then
					local Basis2 = AddFriends:FindFirstChild("Basis")
					local Frame3 = Basis2 and Basis2:FindFirstChild("Frame")

					if Frame3 then
						local HomeTeam = Frame3:FindFirstChild("HomeTeam")
						local AwayTeam = Frame3:FindFirstChild("AwayTeam")
						local Frame4

						if HomeTeam then
							Frame4 = HomeTeam:FindFirstChild("Frame")
						else
							Frame4 = HomeTeam
						end

						if Frame4 and HomeTeam.Frame:FindFirstChild(p16.Name) then
							return "Home"
						else
							local Frame5

							if AwayTeam then
								Frame5 = AwayTeam:FindFirstChild("Frame")
							else
								Frame5 = AwayTeam
							end

							if Frame5 and AwayTeam.Frame:FindFirstChild(p16.Name) then
								return "Away"
							else
								return nil
							end
						end
					else
						return nil
					end
				else
					return nil
				end
			else
				return nil
			end
		else
			return nil
		end
	end

	CharacterAdded = lib:CreateWindow({
		Name = "Mini Hub | NFL Universe [Mobile]",
		LoadingTitle = "Loading NFL Universe Script",
		LoadingSubtitle = "by Mini Hub",
		ConfigurationSaving = {
			Enabled = true,
			FolderName = "NFLUniverse",
			FileName = "MiniHub"
		}
	})
	Add = CharacterAdded:CreateTab("⚡ Main", nil)
	Add:CreateSection("Button Controls")
	Add.CreateToggle(Add, {
		Name = "Draggable Buttons",
		CurrentValue = false,
		Flag = "DragButtons",
		Callback = function(p17)
			u27 = p17
			Frame.Draggable = p17
			Frame2.Draggable = p17

			if p17 then
				Frame.BackgroundTransparency = 0.8
				Frame.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
				Frame2.BackgroundTransparency = 0.8
				Frame2.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
			else
				Frame.BackgroundTransparency = 1
				Frame2.BackgroundTransparency = 1
			end
		end
	})
	t1.value1 = Add.CreateDropdown
	t1.value1(Add, {
		Name = "Mobile Input Method",
		Options = { "Buttons", "Tapping", "Both" },
		CurrentOption = { "Buttons" },
		MultipleOptions = false,
		Flag = "InputMethod",
		Callback = function(p18)
			s1 = p18[1]

			if s1 == "Tapping" then
				TextButton.Visible = false
				TextButton2.Visible = false

				return
			end

			if s1 == "Buttons" then
				TextButton.Visible = false
				TextButton2.Visible = false

				return
			end

			if s1 ~= "Both" then
				return
			end

			TextButton.Visible = false
			TextButton2.Visible = false
		end
	})

	if string.split(identifyexecutor() or "None", " ")[1] ~= "Xeno" then
		local u165 = false
		local n10 = 120
		local u167 = false
		local Part = nil
		local LocalPlayer3 = game.Players.LocalPlayer
		local Character2 = LocalPlayer3.Character or LocalPlayer3.CharacterAdded:Wait()
		local HumanoidRootPart2 = Character2:WaitForChild("HumanoidRootPart")
		local cFrame = CFrame.new()
		local u173 = nil
		local u174 = false
		local t4 = {}

		local function v176(p19)
			local v177 = tostring(p19:GetDebugId())
			local v178 = t4[v177]
			local Position = p19.Position

			t4[v177] = Position

			return Position, v178 or Position
		end
		local function v180(p20)
			u173 = p20
			t4[tostring(p20:GetDebugId())] = p20.Position
		end

		local t5 = {
			Football = true,
			["Football MeshPart"] = true
		}

		function t1.value2()
			local Parent3 = u173

			if Parent3 then
				Parent3 = u173.Parent
			end

			if not Parent3 then
				return false
			end

			local Parent4 = u173.Parent
			local isModel = Parent4:IsA("Model")

			if isModel then
				isModel = game.Players:GetPlayerFromCharacter(Parent4)
			end

			if isModel then
				return true
			end

			local next_ = next
			local players, key = game.Players:GetPlayers()

			while true do
				local v188

				key, v188 = next_(players, key)

				if not key then
					break
				end

				local Character3 = v188.Character

				if Character3 then
					Character3 = u173:IsDescendantOf(v188.Character)
				end

				if Character3 then
					return true
				end
			end

			return false
		end

		local function v190(p21)
			local isMeshPart = p21:IsA("MeshPart")

			if not isMeshPart then
				return isMeshPart
			end

			isMeshPart = t5[p21.Name]

			return isMeshPart
		end
		local function v192()
			if not Part then
				Part = Instance.new("Part")
				Part.Name = "MagnetHitbox"
				Part.Size = Vector3.new(n10 * 2, n10 * 2, n10 * 2)
				Part.Anchored = true
				Part.CanCollide = false
				Part.Transparency = 0.7
				Part.Material = Enum.Material.ForceField
				Part.Color = Color3.fromRGB(138, 43, 226)
				Part.CastShadow = false
				Part.Shape = Enum.PartType.Ball
				Part.Parent = workspace

				return Part
			end

			Part:Destroy()
			Part = Instance.new("Part")
			Part.Name = "MagnetHitbox"
			Part.Size = Vector3.new(n10 * 2, n10 * 2, n10 * 2)
			Part.Anchored = true
			Part.CanCollide = false
			Part.Transparency = 0.7
			Part.Material = Enum.Material.ForceField
			Part.Color = Color3.fromRGB(138, 43, 226)
			Part.CastShadow = false
			Part.Shape = Enum.PartType.Ball
			Part.Parent = workspace

			return Part
		end

		function t1.value1()
			local v193 = LocalPlayer3:GetNetworkPing() * 1000

			return v193 > 250 and 2.5 or (v193 > 200 and 2 or (v193 > 150 and 1.7 or (v193 > 100 and 1.4 or (v193 > 50 and 1.2 or 1))))
		end

		local v194 = nil

		local function v195()
			local Parent3 = u167

			if Parent3 then
				Parent3 = u165 and u173

				if Parent3 then
					Parent3 = u173.Parent
				end
			end

			if Parent3 then
				if Part then
					Part.CFrame = u173.CFrame
					Part.Size = Vector3.new(n10 * 2, n10 * 2, n10 * 2)

					return
				end

				v192()
				Part.CFrame = u173.CFrame
				Part.Size = Vector3.new(n10 * 2, n10 * 2, n10 * 2)
			else
				if not Part then
					return
				end

				v194()
			end
		end

		v194 = function()
			if not Part then
				return
			end

			Part:Destroy()
			Part = nil
		end

		local value12 = t1.value1
		local value2 = t1.value2

		workspace.DescendantAdded:Connect(function(descendant)
			if not v190(descendant) then
				return
			end

			v180(descendant)
			u174 = false
		end)
		workspace.DescendantAdded:Connect(function(descendant)
			if not v190(descendant) then
				return
			end

			descendant.AncestryChanged:Connect(function()
				local Parent3 = descendant.Parent

				if Parent3 then
					Parent3 = descendant.Parent:IsA("Model")

					if Parent3 then
						Parent3 = game.Players:GetPlayerFromCharacter(descendant.Parent)
					end
				end

				if Parent3 then
					u174 = true

					return
				end

				if not (descendant.Parent == workspace and true or descendant.Parent == nil) then
					return
				end

				u174 = false
			end)
		end)
		workspace.DescendantRemoving:Connect(function(descendant)
			if descendant ~= u173 then
				return
			end

			u173 = nil
			u174 = false
		end)
		TouchEnabled = next
		UserInputService, Parent = workspace:GetDescendants()
		t1.value3 = Parent

		local v200 = u173
		local u201 = u174
		local v202 = v194

		while true do
			Parent, Parent2 = TouchEnabled(UserInputService, t1.value3)
			t1.value3 = Parent

			if not t1.value3 then
				break
			end

			if v190(Parent2) then
				v180(Parent2)
				Parent = Parent2.Parent
				t1.value1 = Parent

				if Parent then
					t1.value2 = Parent2.Parent:IsA("Model")
					Parent = t1.value2

					if t1.value2 then
						t1.value2 = game.Players
						Parent2 = Parent2.Parent
						Parent = t1.value2:GetPlayerFromCharacter(Parent2)
					end

					t1.value1 = Parent
				end

				u201 = t1.value1 and true or u201
			end
		end

		local v203 = nil

		v203 = hookmetamethod(game, "__index", function(p22, p23)
			local v204 = u165

			if v204 then
			elseif v204 then
				return cFrame
			else
				return v203(p22, p23)
			end

			v204 = not checkcaller()

			if v204 then
			elseif v204 then
				return cFrame
			else
				return v203(p22, p23)
			end

			local _ = p23 == "CFrame" and p22 == HumanoidRootPart2

			v204 = false

			if v204 then
				return cFrame
			else
				return v203(p22, p23)
			end
		end)
		game:GetService("RunService").Heartbeat:Connect(function()
			v195()

			if u165 and (v200 and v200.Parent) then
				u201 = value2()

				if u201 then
					return
				else
					local v206, v207 = v176(v200)

					if n10 < (HumanoidRootPart2.Position - v206).Magnitude then
						return
					else
						local v208 = v206 - v207
						local v209 = value12()
						local n11 = 8
						local v211

						if v208.Magnitude > 0.1 then
							v211 = v206 + v208.Unit * n11 * v209
						else
							v211 = v206 + Vector3.new(5, 0, 5) * v209
						end

						local vector3New = Vector3.new
						local X = v211.X
						local Y = v211.Y
						local Y2 = v206.Y
						local vector3 = vector3New(X, math.max(Y, Y2), v211.Z)

						cFrame = HumanoidRootPart2.CFrame
						HumanoidRootPart2.CFrame = CFrame.new(vector3)
						game:GetService("RunService").RenderStepped:Wait()
						HumanoidRootPart2.CFrame = cFrame

						return
					end
				end
			else
				u201 = false
			end
		end)
		LocalPlayer3.CharacterAdded:Connect(function(character)
			Character2 = character
			character:WaitForChild("HumanoidRootPart")
			v202()
		end)
		Add:CreateSection("Magnets")
		t1.value3 = Add.CreateToggle
		t1.value3(Add, {
			Name = "Desync Mags",
			CurrentValue = false,
			Flag = "FootballMagnet",
			Callback = function(p24)
				u165 = p24

				if p24 then
					return
				end

				v202()
			end
		})
		t1.value2 = { 0, 120 }
		Add.CreateSlider(Add, {
			Name = "Magnet Distance",
			Range = t1.value2,
			Increment = 1,
			CurrentValue = 120,
			Flag = "FootballDistance",
			Callback = function(p25)
				n10 = p25
			end
		})
		Add.CreateToggle(Add, {
			Name = "Show Hitbox",
			CurrentValue = false,
			Flag = "ShowHitbox",
			Callback = function(p26)
				u167 = p26

				if p26 then
					return
				end

				v202()
			end
		})
	end

	Add:CreateSection("Legit Pull Vector")
	Parent2 = {
		Name = "Legit Pull Vector",
		CurrentValue = false,
		Flag = "LegitPull",
		Callback = function(p27)
			if not (s1 == "Buttons" and true or s1 == "Both") then
				return
			end

			TextButton2.Visible = p27
		end
	}
	Add.CreateToggle(Add, Parent2)
	Parent2 = {
		Name = "Vector Smoothing",
		Range = { 0.01, 1 },
		Increment = 0.01,
		CurrentValue = 0.2,
		Flag = "Smoothness",
		Callback = function(p28)
			n2 = p28
		end
	}
	Add.CreateSlider(Add, Parent2)
	Add:CreateSection("Pull Vector")
	Parent2 = {
		Name = "Pull Vector",
		CurrentValue = false,
		Flag = "PullVector",
		Callback = function(p29)
			if not (s1 == "Buttons" and true or s1 == "Both") then
				return
			end

			TextButton.Visible = p29
		end
	}
	Add.CreateToggle(Add, Parent2)
	Parent2 = Add.CreateSlider

	function t1.value1(p30)
		n1 = p30
	end

	Parent2(Add, {
		Name = "Offset Distance",
		Range = { 0, 30 },
		Increment = 1,
		CurrentValue = 15,
		Flag = "Offset",
		Callback = t1.value1
	})
	Parent2 = {
		Name = "Max Pull Distance",
		Range = { 1, 100 },
		Increment = 1,
		CurrentValue = 35,
		Flag = "MaxDist",
		Callback = function(p31)
			n7 = p31
		end
	}
	Add.CreateSlider(Add, Parent2)
	Parent2 = CharacterAdded:CreateTab("👤 Player", nil)
	Parent2:CreateSection("Stamina")
	Parent = {
		Name = "Infinite Stamina",
		CurrentValue = false,
		Flag = "StaminaDepletion",
		Callback = function(p32)
			staminaDepletionEnabled = p32

			if not p32 then
				return
			end

			spawn(function()
				while staminaDepletionEnabled do
					task.wait()

					if Assets then
						Assets.Stamina = 100
					end
				end
			end)
		end
	}
	Parent2.CreateToggle(Parent2, Parent)
	Parent2:CreateSection("WalkSpeed")
	Parent2:CreateToggle({
		Name = "WalkSpeed",
		CurrentValue = false,
		Flag = "WalkSpeed",
		Callback = function(p33)
			u19 = p33

			local function v217()
				local Character2 = LocalPlayer.Character

				if Character2 then
					Character2 = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
				end

				if not Character2 then
					return
				end

				Character2.WalkSpeed = u19 and 25 or 16
			end

			if p33 then
				local Character2 = LocalPlayer.Character

				if Character2 then
					Character2 = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
				end

				if not Character2 then
					v252 = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

					if v252 then
						v252:GetPropertyChangedSignal("WalkSpeed"):Connect(v217)

						return
					else
						return
					end
				end

				Character2.WalkSpeed = u19 and 25 or 16

				local Humanoid2 = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")

				if Humanoid2 then
					Humanoid2:GetPropertyChangedSignal("WalkSpeed"):Connect(v217)

					return
				else
					return
				end
			else
				local Character2 = LocalPlayer.Character

				if Character2 then
					Character2 = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
				end

				if not Character2 then
					return
				end

				Character2.WalkSpeed = u19 and 25 or 16
			end
		end
	})
	t1.value1 = { 16, 35 }
	Parent = function(p34)
		if not u19 then
			return
		end

		local Character2 = LocalPlayer.Character

		if Character2 then
			Character2 = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		end

		if not Character2 then
			return
		end

		Character2.WalkSpeed = p34
	end
	Parent2.CreateSlider(Parent2, {
		Name = "Custom WalkSpeed",
		Range = t1.value1,
		Increment = 1,
		CurrentValue = 25,
		Flag = "WSValue",
		Callback = Parent
	})
	Parent2:CreateSection("JumpPower")
	Parent = {
		Name = "JumpPower",
		CurrentValue = false,
		Flag = "JumpPower",
		Callback = function(p35)
			u20 = p35

			if p35 then
				if connection then
					connection:Disconnect()
				end

				connection = Humanoid.Jumping:Connect(function()
					local v223 = u20

					if v223 then
						v223 = HumanoidRootPart
					end

					if not v223 then
						return
					end

					local vector3 = Vector3.new(0, n3, 0)

					HumanoidRootPart.Velocity = Vector3.new(HumanoidRootPart.Velocity.X, 0, HumanoidRootPart.Velocity.Z) + vector3
				end)

				return
			end

			if not connection then
				return
			end

			connection:Disconnect()
		end
	}
	Parent2.CreateToggle(Parent2, Parent)
	Parent = Parent2.CreateSlider

	function t1.value2(p36)
		n3 = p36
	end

	Parent(Parent2, {
		Name = "Custom JumpPower",
		Range = { 10, 200 },
		Increment = 5,
		CurrentValue = 50,
		Flag = "JPValue",
		Callback = t1.value2
	})
	Parent2:CreateSection("Jump Boost")
	t1.value1 = Parent2.CreateToggle
	Parent = {
		Name = "Jump Boost",
		CurrentValue = false,
		Flag = "JumpBoost",
		Callback = function(p37)
			u22 = p37

			if p37 then
				if LocalPlayer.Character then
					v138(LocalPlayer.Character)

					return
				else
					return
				end
			end

			value1:Remove("JumpBoostTouch")
		end
	}
	t1.value1(Parent2, Parent)

	function t1.value2(p38)
		u23 = p38
	end

	Parent2:CreateToggle({
		Name = "Always Boost Mode",
		CurrentValue = false,
		Flag = "BoostMode",
		Callback = t1.value2
	})

	function t1.value2(p39)
		n9 = p39
	end

	Parent2:CreateSlider({
		Name = "Boost Force",
		Range = { 10, 100 },
		Increment = 2,
		CurrentValue = 32,
		Flag = "BoostForce",
		Callback = t1.value2
	})
	Parent2:CreateSection("Dive Boost")
	Parent = {
		Name = "Dive Boost",
		CurrentValue = false,
		Flag = "DiveBoost",
		Callback = function(p40)
			u24 = p40

			if p40 then
				v125()

				return
			end

			local Replicated = LocalPlayer:FindFirstChild("Replicated")

			if Replicated then
				Replicated = LocalPlayer.Replicated:FindFirstChild("GameID")
			end

			if not Replicated then
				return
			end

			local Value = Replicated.Value
			local Games = ReplicatedStorage:FindFirstChild("Games")

			if Games then
				local v228 = Games:FindFirstChild(Value)
				local GameParams = v228 and v228:FindFirstChild("GameParams")

				if GameParams then
					local DivePower = GameParams:FindFirstChild("DivePower")
					local isNumberValue

					if DivePower then
						isNumberValue = DivePower:IsA("NumberValue")
					else
						isNumberValue = DivePower
					end

					if isNumberValue then
						DivePower.Value = 2.2
					end
				end
			end

			local MiniGames = ReplicatedStorage:FindFirstChild("MiniGames")

			if not MiniGames then
				return
			end

			local v233 = MiniGames:FindFirstChild(Value)
			local GameParams = v233 and v233:FindFirstChild("GameParams")

			if not GameParams then
				return
			end

			local DivePower = GameParams:FindFirstChild("DivePower")
			local isNumberValue

			if DivePower then
				isNumberValue = DivePower:IsA("NumberValue")
			else
				isNumberValue = DivePower
			end

			if not isNumberValue then
				return
			end

			DivePower.Value = 2.2
		end
	}
	Parent2.CreateToggle(Parent2, Parent)
	t1.value2 = { 2.2, 10 }
	t1.value3 = Parent2.CreateSlider
	t1.value3(Parent2, {
		Name = "Dive Boost Power",
		Range = t1.value2,
		Increment = 0.1,
		CurrentValue = 2,
		Flag = "DivePower",
		Callback = function(p41)
			diveBoostPower = p41
		end
	})
	Parent2:CreateSection("Auto Rush")
	Parent = {
		Name = "Auto Follow Ball Carrier",
		CurrentValue = false,
		Flag = "AutoFollow",
		Callback = function(p42)
			if not p42 then
				return
			end

			RunService.Heartbeat:Connect(function()
				local v237 = v74()
				local Character2 = v237 and (v237.Character and HumanoidRootPart)

				if Character2 then
					Character2 = Humanoid
				end

				if not Character2 then
					return
				end

				local v239 = v153(LocalPlayer)
				local v240 = v153(v237)

				if v239 then
					if v240 then
						v240 = v239 ~= v240
					end
				else
					v240 = v239
				end

				local HumanoidRootPart2 = v240 and v237.Character:FindFirstChild("HumanoidRootPart")

				if not HumanoidRootPart2 then
					return
				end

				local Velocity = HumanoidRootPart2.Velocity
				local v243 = (HumanoidRootPart2.Position - HumanoidRootPart.Position).Magnitude / (Humanoid.WalkSpeed or 16)
				local v244 = HumanoidRootPart
				local v245 = HumanoidRootPart2.Position + Velocity * v243 - v244.Position
				local v246 = Humanoid
				local Position = HumanoidRootPart.Position
				local math_ = math

				v246.MoveTo(v246, Position + v245 * math_.clamp(n8, 0, 1))
			end)
		end
	}
	Parent2.CreateToggle(Parent2, Parent)
	Parent = {
		Name = "Follow Blatancy",
		Range = { 0, 1 },
		Increment = 0.05,
		CurrentValue = 0.5,
		Flag = "Blatancy",
		Callback = function(p43)
			n8 = p43
		end
	}
	Parent2.CreateSlider(Parent2, Parent)
	Parent2 = CharacterAdded:CreateTab("📦 Hitbox", nil)
	Parent2:CreateSection("BigHead")
	t1.value2 = Parent2.CreateToggle
	Parent = {
		Name = "Bighead Collision",
		CurrentValue = false,
		Flag = "Bighead",
		Callback = function(p44)
			u21 = p44

			if p44 then
				if connection2 then
					connection2:Disconnect()
				end

				connection2 = RunService.RenderStepped:Connect(function()
					local v249 = Players2

					for _, player in pairs(v249.GetPlayers(v249)) do
						if player ~= LocalPlayer then
							local Character2 = player.Character

							if Character2 then
								local Head2 = Character2:FindFirstChild("Head")
								local isBasePart

								if Head2 then
									isBasePart = Head2:IsA("BasePart")
								else
									isBasePart = Head2
								end

								if isBasePart then
									Head2.Size = Vector3.new(n4, n4, n4)
									Head2.Transparency = 0.5
									Head2.CanCollide = true

									local face = Head2:FindFirstChild("face")

									if face then
										face:Destroy()
									end
								end
							end
						end
					end
				end)

				return
			end

			local Character2, Head2, isBasePart

			if not connection2 then
				v303 = Players2

				for _, player in pairs(v303.GetPlayers(v303)) do
					if player ~= LocalPlayer then
						Character2 = player.Character

						if Character2 then
							Head2 = Character2:FindFirstChild("Head")

							if Head2 then
								isBasePart = Head2:IsA("BasePart")
							else
								isBasePart = Head2
							end

							if isBasePart then
								Head2.Size = Size
								Head2.Transparency = Transparency
								Head2.CanCollide = false
							end
						end
					end
				end

				return
			end

			connection2:Disconnect()

			local v261 = Players2

			for _, player in pairs(v261.GetPlayers(v261)) do
				if player ~= LocalPlayer then
					Character2 = player.Character

					if Character2 then
						Head2 = Character2:FindFirstChild("Head")

						if Head2 then
							isBasePart = Head2:IsA("BasePart")
						else
							isBasePart = Head2
						end

						if isBasePart then
							Head2.Size = Size
							Head2.Transparency = Transparency
							Head2.CanCollide = false
						end
					end
				end
			end
		end
	}
	t1.value2(Parent2, Parent)
	t1.value2 = { 1, 10 }
	Parent = function(p45)
		n4 = p45
	end
	Parent2.CreateSlider(Parent2, {
		Name = "Head Size",
		Range = t1.value2,
		Increment = 1,
		CurrentValue = 1,
		Flag = "HeadSize",
		Callback = Parent
	})
	Parent2:CreateSection("Tackle Reach")
	Parent = Parent2.CreateToggle

	function t1.value1(p46)
		if not p46 then
			return
		end

		RunService.Heartbeat:Connect(function()
			local v264 = Players2

			for _, player in ipairs(v264.GetPlayers(v264)) do
				local v267

				if player == LocalPlayer then
					v267 = false
				else
					v267 = player.Character
				end

				if v267 then
					local ipairs_ = ipairs
					local Character2 = player.Character

					for _, descendant in ipairs_(Character2.GetDescendants(Character2)) do
						if descendant.Name == "FootballGrip" then
							local PlayerName = nil
							local GameID = LocalPlayer:FindFirstChild("Replicated") and LocalPlayer.Replicated:FindFirstChild("GameID")

							if GameID then
								GameID = LocalPlayer.Replicated.GameID.Value
							end

							if GameID then
								local v274

								if Workspace:FindFirstChild("Games") then
									v274 = Workspace.Games:FindFirstChild(GameID)
								else
									v274 = nil
								end

								local v275 = not v274

								if v275 then
									v275 = Workspace:FindFirstChild("MiniGames")
								end

								if v275 then
									v274 = Workspace.MiniGames:FindFirstChild(GameID)
								end

								if v274 then
									local Replicated = v274:FindFirstChild("Replicated")

									if Replicated then
										local Hitboxes = Replicated:FindFirstChild("Hitboxes")

										if Hitboxes then
											PlayerName = Hitboxes:FindFirstChild(player.Name)
										end
									end
								end
							end

							local v278

							if PlayerName then
								v278 = HumanoidRootPart
							else
								v278 = PlayerName
							end

							if v278 then
								local v279 = n5

								n5 = tonumber(v279) or 1

								if (PlayerName.Position - HumanoidRootPart.Position).Magnitude <= n5 then
									PlayerName.Position = HumanoidRootPart.Position
									task.wait(0.1)
									PlayerName.Position = player.Character:FindFirstChild("HumanoidRootPart").Position
								end
							end
						end
					end
				end
			end
		end)
	end

	Parent(Parent2, {
		Name = "Tackle Reach",
		CurrentValue = false,
		Flag = "TackleReach",
		Callback = t1.value1
	})
	t1.value2 = Parent2.CreateSlider
	Parent = {
		Name = "Reach Distance",
		Range = { 1, 10 },
		Increment = 1,
		CurrentValue = 5,
		Flag = "TackleDistance",
		Callback = function(p47)
			n5 = p47
		end
	}
	t1.value2(Parent2, Parent)
	Parent2:CreateSection("Player Hitbox")
	t1.value2 = Parent2.CreateToggle

	function t1.value3(p48)
		if p48 then
			RunService.RenderStepped:Connect(function()
				local Games = workspace:FindFirstChild("Games")

				if not Games then
					return
				end

				local v281 = Games:GetChildren()[1]
				local Hitboxes = v281 and v281.Replicated:FindFirstChild("Hitboxes")

				if not Hitboxes then
					return
				end

				local v283 = Players2

				for _, player in ipairs(v283.GetPlayers(v283)) do
					if player ~= LocalPlayer then
						local PlayerName = Hitboxes:FindFirstChild(player.Name)
						local isBasePart

						if PlayerName then
							isBasePart = PlayerName:IsA("BasePart")
						else
							isBasePart = PlayerName
						end

						if isBasePart then
							PlayerName.Size = Vector3.new(n6, n6, n6)
							PlayerName.Transparency = playerHitboxTransparency
							PlayerName.CanCollide = false
							PlayerName.Material = Enum.Material.Neon
							PlayerName.Color = Color3.fromRGB(255, 0, 0)
						end
					end
				end
			end)

			return
		end

		local Games = workspace:FindFirstChild("Games")

		if not Games then
			return
		end

		local v289 = Games:GetChildren()[1]
		local Hitboxes = v289 and v289.Replicated:FindFirstChild("Hitboxes")

		if not Hitboxes then
			return
		end

		local v291 = Players2

		for _, player in ipairs(v291.GetPlayers(v291)) do
			if player ~= LocalPlayer then
				local PlayerName = Hitboxes:FindFirstChild(player.Name)
				local isBasePart

				if PlayerName then
					isBasePart = PlayerName:IsA("BasePart")
				else
					isBasePart = PlayerName
				end

				if isBasePart then
					PlayerName.Size = Vector3.new(2, 2, 1)
					PlayerName.Transparency = 1
					PlayerName.CanCollide = false
					PlayerName.Material = Enum.Material.Plastic
					PlayerName.Color = Color3.fromRGB(255, 255, 255)
				end
			end
		end
	end

	t1.value2(Parent2, {
		Name = "Player Hitbox Expander",
		CurrentValue = false,
		Flag = "PlayerHitbox",
		Callback = t1.value3
	})
	t1.value1 = { 2, 50 }
	Parent = Parent2.CreateSlider

	function t1.value2(p49)
		n6 = p49
	end

	Parent(Parent2, {
		Name = "Hitbox Size",
		Range = t1.value1,
		Increment = 1,
		CurrentValue = 5,
		Flag = "HitboxSize",
		Callback = t1.value2
	})
	Parent = Parent2.CreateSlider

	function t1.value2(p50)
		playerHitboxTransparency = p50
	end

	Parent(Parent2, {
		Name = "Hitbox Transparency",
		Range = { 0, 1 },
		Increment = 0.1,
		CurrentValue = 0.7,
		Flag = "HitboxTransparency",
		Callback = t1.value2
	})
	Parent2 = CharacterAdded:CreateTab("🤖 Automation", nil)
	Parent2.CreateToggle(Parent2, {
		Name = "Auto Sack",
		CurrentValue = false,
		Flag = "AutoSacker",
		Callback = function(p51)
			getgenv().AutoSack = p51
		end
	})
	Parent = Parent2.CreateToggle

	function t1.value2(p52)
		getgenv().AntiBlock = p52
	end

	Parent(Parent2, {
		Name = "Anti Block",
		CurrentValue = false,
		Flag = "AntiBlocker",
		Callback = t1.value2
	})
	t1.value1 = Parent2.CreateSlider
	t1.value1(Parent2, {
		Name = "Cframe Speed",
		Range = { 0.1, 2 },
		Increment = 0.01,
		CurrentValue = 0.3,
		Flag = "TurkeySpeed",
		Callback = function(p53)
			getgenv().turkeySpeed = p53
		end
	})
	Parent = Parent2.CreateToggle

	function t1.value1(p54)
		getgenv().turkeyFarmEnabled = p54

		if p54 then
			lib:Notify({
				Title = "Turkey Farm",
				Content = "Turkey Farm Started 🦃",
				Duration = 3,
				Image = 4483362458
			})
		else
			lib:Notify({
				Title = "Turkey Farm",
				Content = "Turkey Farm Stopped",
				Duration = 2,
				Image = 4483362458
			})
		end
	end

	Parent(Parent2, {
		Name = "Turkey Autofarm (EVENT)",
		CurrentValue = false,
		Flag = "TurkeyFarm",
		Callback = t1.value1
	})

	function t1.value1(p55)
		if not p55 then
			return
		end

		local VirtualUser = game:GetService("VirtualUser")

		game:GetService("Players").LocalPlayer.Idled:Connect(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end)
	end

	Parent2:CreateToggle({
		Name = "Anti AFK",
		CurrentValue = false,
		Flag = "AntiAFK",
		Callback = t1.value1
	})
	t1.value3 = CharacterAdded:CreateTab("🔧 Misc", nil)
	t1.value3.CreateToggle(t1.value3, {
		Name = "Potato Graphics Mode",
		CurrentValue = false,
		Flag = "PotatoMode",
		Callback = function(p56)
			if p56 then
				_G.OriginalSettings = {
					lighting = game:GetService("Lighting"),
					terrain = workspace.Terrain
				}

				local Lighting = game:GetService("Lighting")

				Lighting.GlobalShadows = false
				Lighting.FogEnd = 9000000000
				Lighting.Brightness = 0

				for _, child in pairs(Lighting:GetChildren()) do
					if child:IsA("PostEffect") then
						child.Enabled = false
					end
				end

				local Terrain = workspace.Terrain

				Terrain.WaterWaveSize = 0
				Terrain.WaterWaveSpeed = 0
				Terrain.WaterReflectance = 0
				Terrain.WaterTransparency = 0
				settings().Rendering.QualityLevel = Enum.QualityLevel.Level01

				local pairs_ = pairs
				local workspace_ = workspace

				for _, descendant in pairs_(workspace_.GetDescendants(workspace_)) do
					if descendant:IsA("ParticleEmitter") or descendant:IsA("Trail") then
						descendant.Enabled = false
					elseif descendant:IsA("Explosion") then
						descendant.BlastPressure = 1
						descendant.BlastRadius = 1
					elseif descendant:IsA("Fire") or (descendant:IsA("Smoke") or descendant:IsA("Sparkles")) then
						descendant.Enabled = false
					elseif descendant:IsA("MeshPart") then
						descendant.Material = Enum.Material.SmoothPlastic
						descendant.Reflectance = 0
					elseif descendant:IsA("Part") then
						descendant.Material = Enum.Material.SmoothPlastic
						descendant.Reflectance = 0
					end
				end

				if not Lighting:FindFirstChildOfClass("Sky") then
					lib:Notify({
						Title = "FPS Booster",
						Content = "Potato graphics enabled! 🥔",
						Duration = 3,
						Image = 4483362458
					})

					return
				end

				Lighting:FindFirstChildOfClass("Sky"):Destroy()
				lib:Notify({
					Title = "FPS Booster",
					Content = "Potato graphics enabled! 🥔",
					Duration = 3,
					Image = 4483362458
				})
			else
				settings().Rendering.QualityLevel = Enum.QualityLevel.Automatic

				local Lighting = game:GetService("Lighting")

				Lighting.GlobalShadows = true
				Lighting.Brightness = 2

				local GetChildren = Lighting.GetChildren

				for _, v in pairs(GetChildren(Lighting)) do
					if v:IsA("PostEffect") then
						v.Enabled = true
					end
				end

				lib:Notify({
					Title = "FPS Booster",
					Content = "Graphics restored to normal",
					Duration = 3,
					Image = 4483362458
				})
			end
		end
	})

	function t1.value1()
		local pairs_ = pairs
		local workspace_ = workspace

		for _, descendant in pairs_(workspace_.GetDescendants(workspace_)) do
			if descendant:IsA("Decal") or descendant:IsA("Texture") then
				descendant.Transparency = 1
			elseif descendant:IsA("BasePart") then
				descendant.Material = Enum.Material.SmoothPlastic
			end
		end

		lib:Notify({
			Title = "FPS Booster",
			Content = "All textures removed!",
			Duration = 3,
			Image = 4483362458
		})
	end

	t1.value3:CreateButton({
		Name = "Remove Textures",
		Callback = t1.value1
	})

	local v313 = t1.value3:CreateParagraph({
		Title = "FPS Counter",
		Content = "FPS: Calculating..."
	})

	task.spawn(function()
		local currentFps = 0
		local now = tick()

		game:GetService("RunService").RenderStepped:Connect(function()
			currentFps = currentFps + 1

			if not (tick() - now >= 1) then
				return
			end

			v313:Set({
				Title = "FPS Counter",
				Content = "Current FPS: " .. currentFps
			})
			tick()
		end)
	end)
else
	local t6 = {
		value1 = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/Library.lua"))()
	}

	Parent2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/ThemeManager.lua"))()
	Parent = loadstring(game:HttpGet("https://raw.githubusercontent.com/violin-suzutsuki/LinoriaLib/main/addons/SaveManager.lua"))()
	t6.value2 = game:GetService("Players")
	t6.value3 = game:GetService("TweenService")
	t6.value4 = game:GetService("UserInputService")
	t6.value5 = game:GetService("RunService")
	t6.value6 = game:GetService("ReplicatedStorage")
	t6.value7 = game:GetService("Workspace")
	t6.value8 = game:GetService("Players").LocalPlayer
	t6.value8:GetMouse()
	getgenv().SecureMode = true
	CharacterAdded = t6.value6:FindFirstChild("Assets")

	if CharacterAdded then
		CharacterAdded = t6.value6.Assets:FindFirstChild("Modules") and t6.value6.Assets.Modules:FindFirstChild("Client")

		if CharacterAdded then
			CharacterAdded = t6.value6.Assets.Modules.Client:FindFirstChild("Mechanics")
		end
	end

	t6.value9 = CharacterAdded

	if t6.value9 then
		t6.value9 = require(t6.value9)
	end

	t6.value10 = {}
	t6.value10.connections = {}

	function t6.value10.Add(p57, p58, p59)
		if not p57.connections[p58] then
			p57.connections[p58] = p59

			return
		end

		p57.connections[p58]:Disconnect()
		p57.connections[p58] = p59
	end
	function t6.value10.Remove(p60, p61)
		if not p60.connections[p61] then
			return
		end

		p60.connections[p61]:Disconnect()
		p60.connections[p61] = nil
	end
	function t6.value10.CleanupAll(p62)
		for _, connection in pairs(p62.connections) do
			if connection then
				connection:Disconnect()
			end
		end

		p62.connections = {}
	end

	t6.value11 = false
	t6.value12 = false
	t6.value13 = false
	t6.value14 = false
	t6.value15 = false
	t6.value16 = false
	t6.value17 = false
	t6.value18 = false
	t6.value19 = false
	t6.value20 = false
	t6.value21 = false
	t6.value22 = false
	t6.value23 = false
	t6.value24 = false
	t6.value25 = false
	t6.value26 = true
	t6.value27 = false
	t6.value28 = nil
	t6.value29 = {}
	t6.value30 = {}
	t6.value31 = 5
	t6.value32 = 120
	t6.value33 = 50
	t6.value34 = 120
	t6.value35 = 40
	t6.value36 = workspace.Gravity or 196.2
	t6.value37 = 3
	t6.value38 = 100
	t6.value39 = 15
	t6.value40 = 0.01
	t6.value41 = 50
	t6.value42 = 50
	t6.value43 = 1
	t6.value44 = 0.5
	t6.value45 = 1
	t6.value46 = 0
	t6.value47 = 150
	t6.value48 = 0.5
	t6.value49 = 32
	t6.value50 = 10
	t6.value51 = 1
	t6.value52 = 15
	t6.value53 = 2
	t6.value54 = 2.2
	t6.value55 = false
	t6.value56 = 5
	t6.value57 = 0.7
	t6.value58 = "WalkSpeed"
	t6.value59 = nil
	t6.value60 = nil
	t6.value61 = nil
	t6.value62 = nil
	t6.value63 = nil
	t6.value64 = nil
	t6.value65 = nil
	t6.value66 = nil
	t6.value67 = nil
	t6.value68 = nil
	t6.value69 = t6.value7:FindFirstChild("ParkMatchMap") ~= nil
	t6.value70 = t6.value8.Character or t6.value8.CharacterAdded:Wait()
	t6.value71 = t6.value70:WaitForChild("HumanoidRootPart")
	t6.value72 = t6.value70:WaitForChild("Humanoid")
	t1.value1 = t6.value70:WaitForChild("Head")
	t6.value73 = t1.value1
	t1.value1 = t6.value72.WalkSpeed
	t1.value1 = t6.value72.JumpPower
	t1.value1 = t6.value73.Size
	t6.value74 = t1.value1
	t1.value1 = t6.value73.Transparency
	t6.value75 = t1.value1

	function t1.value1(p63)
		t6.value70 = p63
		t6.value71 = p63:WaitForChild("HumanoidRootPart")
		t6.value72 = p63:WaitForChild("Humanoid")
		t6.value73 = p63:WaitForChild("Head")

		local _ = t6.value72.WalkSpeed
		local _ = t6.value72.JumpPower

		t6.value74 = t6.value73.Size
		t6.value75 = t6.value73.Transparency
	end

	t6.value10:Add("CharacterAdded", unpack_({ t6.value8.CharacterAdded:Connect(t1.value1) }))
	t6.value76 = game.Players.LocalPlayer
	CharacterAdded = t6.value76.Name
	t6.value77 = "https://pastebin.com/raw/Yvyb4pLt"
	t6.value78 = "https://pastebin.com/raw/DjazvQVU"

	function t6.value79()
		local function v321()
			return game:HttpGetAsync(t6.value77 .. "?t=" .. tick(), true)
		end

		local ok, result = pcall(v321)

		if not (ok and result) then
			return false
		end

		for match in string.gmatch(result, "[^\r\n]+") do
			if match:gsub("%s+", "") == playerHWID then
				return true
			end
		end

		return false
	end

	if t6.value79() then
		t6.value76:Kick("You\'ve been kicked from the game")

		return
	end

	task.spawn(function()
		while task.wait(5) do
			if t6.value79() then
				t6.value76:Kick("You\'ve been kicked from the game")

				return
			end
		end
	end)

	local function v325()
		local function v326()
			return game:HttpGetAsync(t6.value78 .. "?t=" .. tick(), true)
		end

		local ok, result = pcall(v326)

		if not (ok and result) then
			return false, nil
		end

		for match in string.gmatch(result, "[^\r\n]+") do
			if match:gsub("%s+", "") == playerHWID then
				return true, "XDXDXD"
			end
		end

		return false, nil
	end

	CharacterAdded, Add = v325()

	if CharacterAdded then
		logAction("🚫 BLACKLISTED USER DETECTED", "HWID: " .. playerHWID .. ("\nReason: " .. Add or "Violation of Terms"), true)
		t6.value76:Kick("⛔ Access Denied\n\nYou have been blacklisted from Mini Hub.\nReason: MY FAULT OG " .. (Add or "Violation of Terms"))

		return
	end

	CharacterAdded = task.spawn

	function t1.value3()
		local Games = t6.value6:WaitForChild("Games")
		local result = nil

		for _, child in ipairs(Games:GetChildren()) do
			if child:FindFirstChild("ReEvent") then
				result = child

				break
			end
		end

		if result then
			return result:WaitForChild("ReEvent")
		end

		result = Games.ChildAdded:Wait()
		result:WaitForChild("ReEvent")

		return result:WaitForChild("ReEvent")
	end

	CharacterAdded(function()
		while task.wait(5) do
			if v325() then
				logAction("🚫 BLACKLISTED (LIVE KICK)", "HWID: " .. playerHWID .. "\nKicked during active session", true)
				t6.value76:Kick("⛔ Access Denied\n\nYou have been blacklisted from Mini Hub.")

				return
			end
		end
	end)

	function t1.value1()
		local ParkMap = t6.value7:FindFirstChild("ParkMap")
		local Replicated

		if ParkMap then
			Replicated = ParkMap:FindFirstChild("Replicated")
		else
			Replicated = ParkMap
		end

		local Fields = Replicated and ParkMap.Replicated:FindFirstChild("Fields")

		if Fields then
			local t7 = {
				Fields:FindFirstChild("LeftField"),
				Fields:FindFirstChild("RightField"),
				Fields:FindFirstChild("BLeftField"),
				Fields:FindFirstChild("BRightField"),
				Fields:FindFirstChild("HighField"),
				Fields:FindFirstChild("TLeftField"),
				Fields.FindFirstChild(Fields, "TRightField")
			}

			for _, v in ipairs(t7) do
				local Replicated2

				if v then
					Replicated2 = v:FindFirstChild("Replicated")
				else
					Replicated2 = v
				end

				if Replicated2 then
					local Football = v.Replicated:FindFirstChild("Football")
					local isBasePart

					if Football then
						isBasePart = Football:IsA("BasePart")
					else
						isBasePart = Football
					end

					if isBasePart then
						return Football
					end
				end
			end
		end

		if t6.value69 then
			local ParkMatchMap = t6.value7:FindFirstChild("ParkMatchMap")
			local Replicated2

			if ParkMatchMap then
				Replicated2 = ParkMatchMap:FindFirstChild("Replicated")
			else
				Replicated2 = ParkMatchMap
			end

			if Replicated2 then
				local Fields2 = ParkMatchMap.Replicated:FindFirstChild("Fields")
				local MatchField

				if Fields2 then
					MatchField = Fields2:FindFirstChild("MatchField")
				else
					MatchField = Fields2
				end

				local Replicated3 = MatchField and Fields2.MatchField:FindFirstChild("Replicated")

				if Replicated3 then
					local Football = Replicated3:FindFirstChild("Football")
					local isBasePart

					if Football then
						isBasePart = Football:IsA("BasePart")
					else
						isBasePart = Football
					end

					if isBasePart then
						return Football
					end
				end
			end
		end

		local Games = t6.value7:FindFirstChild("Games")

		if not Games then
			return nil
		end

		local GetChildren = Games.GetChildren

		for _, v in ipairs(GetChildren(Games)) do
			local Replicated2 = v:FindFirstChild("Replicated")

			if Replicated2 then
				local v355 = Replicated2:FindFirstChild("918f5408-d86a-4fb8-a88c-5cab57410acf")
				local isBasePart

				if v355 then
					isBasePart = v355:IsA("BasePart")
				else
					isBasePart = v355
				end

				if isBasePart then
					return v355
				end

				for _, child in ipairs(Replicated2.GetChildren(Replicated2)) do
					local isBasePart2 = child:IsA("BasePart")

					if isBasePart2 then
						isBasePart2 = child.Name == "Football"
					end

					if isBasePart2 then
						return child
					end
				end
			end
		end

		return nil
	end

	local value1 = t1.value1

	local function v361()
		local v362 = value1()
		local value71

		if v362 then
			value71 = t6.value71
		else
			value71 = v362
		end

		if not value71 then
			return
		end

		if t6.value7:FindFirstChild("ParkMap") and (v362.Position - t6.value71.Position).Magnitude > t6.value47 then
			return
		end

		local Velocity = v362.Velocity
		local vector3 = Velocity.Magnitude > 0 and Velocity.Unit * t6.value39 or Vector3.new(0, 0, 0)
		local v366 = v362.Position + vector3 + Vector3.new(0, 3, 0)
		local Unit = (v362.Position - t6.value71.Position).Unit

		t6.value71.CFrame = t6.value71.CFrame:Lerp(CFrame.new(v366, v366 + Unit), t6.value40)
	end
	local function v368()
		local ipairs_ = ipairs
		local value2 = t6.value2

		for _, player in ipairs_(value2.GetPlayers(value2)) do
			local v373

			if player == t6.value8 then
				v373 = false
			else
				v373 = player.Character
			end

			if v373 and player.Character:FindFirstChild("Football") then
				return player
			end
		end

		return nil
	end

	function t1.value2()
		local v374 = value1()
		local value71

		if v374 then
			value71 = t6.value71
		else
			value71 = v374
		end

		if not value71 then
			return
		end

		if t6.value7:FindFirstChild("ParkMap") and (v374.Position - t6.value71.Position).Magnitude > t6.value47 then
			return
		end

		local Velocity = v374.Velocity
		local Position = v374.Position
		local Unit = Velocity.Unit
		local value39 = t6.value39

		if t6.value55 then
			local Magnitude = Velocity.Magnitude

			value39 = Magnitude > 80 and 12 or (Magnitude > 50 and 8 or (Magnitude > 25 and 5 or 3))
		end

		local v381 = Position + Unit * value39 - Vector3.new(0, 1.5, 0) + Vector3.new(0, 0.86624995867411, 0)
		local Unit2 = (Position - t6.value71.Position).Unit

		t6.value71.CFrame = CFrame.new(v381, v381 + Unit2)
	end

	local value2 = t1.value2

	function t1.value1()
		local mouse = t6.value8:GetMouse()
		local ipairs_ = ipairs
		local value22 = t6.value2
		local huge = math.huge
		local v388 = nil

		for _, player in ipairs_(value22.GetPlayers(value22)) do
			local v391

			if player == t6.value8 then
				v391 = false
			else
				v391 = player.Character
			end

			if v391 then
				local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

				if HumanoidRootPart then
					local v393, v394 = workspace.CurrentCamera:WorldToViewportPoint(HumanoidRootPart.Position)

					if v394 then
						local Magnitude = (Vector2.new(mouse.X, mouse.Y) - Vector2.new(v393.X, v393.Y)).Magnitude

						if Magnitude < huge then
							v388 = player
							huge = Magnitude
						end
					end
				end
			end
		end

		return v388
	end

	local value3 = t1.value3
	local v397 = nil

	local function v398(p64)
		local HumanoidRootPart = p64:WaitForChild("HumanoidRootPart")

		t6.value10:Add("JumpBoostTouch", HumanoidRootPart.Touched:Connect(function(part)
			if not (t6.value23 and t6.value26) then
				return
			end

			if HumanoidRootPart.Velocity.Y >= -2 then
				return
			end

			local Model = part:FindFirstAncestorWhichIsA("Model")
			local Humanoid

			if Model then
				Humanoid = Model:FindFirstChild("Humanoid")
			else
				Humanoid = Model
			end

			if Model then
				if Model == p64 then
					Humanoid = false
				end
			else
				Humanoid = Model
			end

			if not Humanoid then
				return
			end

			if t6.value24 then
				v397(HumanoidRootPart)
				task.delay(t6.value51, function() end)

				return
			end

			local v402 = value1()

			if not (v402 and (v402.Position - HumanoidRootPart.Position).Magnitude <= t6.value50) then
				return
			end

			v397(HumanoidRootPart)
			task.delay(t6.value51, function() end)
		end))
	end

	v397 = function(p65)
		local BodyVelocity = Instance.new("BodyVelocity")

		BodyVelocity.Velocity = Vector3.new(0, t6.value49, 0)
		BodyVelocity.MaxForce = Vector3.new(0, math.huge, 0)
		BodyVelocity.P = 5000
		BodyVelocity.Parent = p65
		game:GetService("Debris"):AddItem(BodyVelocity, 0.2)
	end
	CharacterAdded = t6.value10
	Add = CharacterAdded.Add
	t1.value2 = t6.value8
	t1.value2 = t1.value2.CharacterAdded
	Add(CharacterAdded, "CharacterAddedJumpBoost", t1.value2.Connect(t1.value2, function(p66)
		if not t6.value23 then
			return
		end

		v398(p66)
	end))

	local function v404(p67)
		local PlayerGui = t6.value8:FindFirstChild("PlayerGui")

		if PlayerGui then
			local Menu = PlayerGui:FindFirstChild("Menu")
			local Basis = Menu and Menu:FindFirstChild("Basis")

			if Basis then
				local Window = Basis:FindFirstChild("Window")
				local AddFriends = Window and Window:FindFirstChild("AddFriends")

				if AddFriends then
					local Basis2 = AddFriends:FindFirstChild("Basis")
					local Frame = Basis2 and Basis2:FindFirstChild("Frame")

					if Frame then
						local HomeTeam = Frame:FindFirstChild("HomeTeam")
						local AwayTeam = Frame:FindFirstChild("AwayTeam")
						local Frame2

						if HomeTeam then
							Frame2 = HomeTeam:FindFirstChild("Frame")
						else
							Frame2 = HomeTeam
						end

						if Frame2 and HomeTeam.Frame:FindFirstChild(p67.Name) then
							return "Home"
						else
							local Frame3

							if AwayTeam then
								Frame3 = AwayTeam:FindFirstChild("Frame")
							else
								Frame3 = AwayTeam
							end

							if Frame3 and AwayTeam.Frame:FindFirstChild(p67.Name) then
								return "Away"
							else
								return nil
							end
						end
					else
						return nil
					end
				else
					return nil
				end
			else
				return nil
			end
		else
			return nil
		end
	end
	local function v416()
		local v417 = value3()

		v417:FireServer(unpack_({ unpack({
				"Mechanics",
				"KickAngleChanged",
				1,
				60,
				1
			}) }))
		v417:FireServer(unpack_({ unpack({ "Mechanics", "KickPowerSet", 1 }) }))
		v417:FireServer(unpack_({ unpack({
				"Mechanics",
				"KickHiked",
				60,
				1,
				1
			}) }))
		v417:FireServer(unpack_({ unpack({ "Mechanics", "KickAccuracySet", 60 }) }))
	end

	t1.value2 = t6.value4
	t1.value2.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		local v418

		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			v418 = true
		elseif input.UserInputType == Enum.UserInputType.Gamepad1 then
			v418 = input.KeyCode == Enum.KeyCode.ButtonR2
		else
			v418 = false
		end

		if v418 then
			if t6.value11 then
				local function v419()
					while t6.value13 do
						value2()
						wait(0.05)
					end
				end

				t6.value13 = true
				spawn(v419)
			end

			if not t6.value12 then
				return
			end

			t6.value14 = true

			local function v420()
				while t6.value14 do
					v361()
					wait(0.01)
				end
			end

			spawn(v420)

			return
		end

		if input.UserInputType ~= Enum.UserInputType.Keyboard then
			return
		end

		local value18 = t6.value18

		if value18 then
			value18 = input.KeyCode == Enum.KeyCode.Z
		end

		if value18 then
			local value70 = t6.value70

			if value70 then
				value70 = t6.value71
			end

			if value70 then
				t6.value71.CFrame = t6.value71.CFrame + t6.value71.CFrame.LookVector * 3
			end
		end

		local value19

		if input.KeyCode == Enum.KeyCode.L then
			value19 = t6.value19
		else
			value19 = false
		end

		if not value19 then
			return
		end

		v416()
	end)

	function t1.value2(p68)
		local format = string.format
		local X = p68 and (p68.X or 0) or 0
		local Y = p68 and (p68.Y or 0) or 0

		if not p68 then
			return format("(%.2f, %.2f, %.2f)", X, Y, p68 or 0)
		end

		p68 = p68.Z

		return format("(%.2f, %.2f, %.2f)", X, Y, p68 or 0)
	end
	function t1.value2(p69, p70)
		if not p69 then
			return p69 or 0
		end

		p69 = p69[p70]

		return p69 or 0
	end

	local function v427(p71, p72, p73)
		local v428 = t6.value29[p71] or {
			lastPos = p72,
			lastVel = p73,
			acc = Vector3.new(),
			history = {}
		}
		local acc = p73 - v428.lastVel
		local history = v428.history

		table.insert(history, 1, p73)

		if not (#v428.history > 5) then
			v489 = Vector3.new(0, 0, 0)

			for _, v in ipairs(v428.history) do
				v489 = v489 + v
			end

			v492 = v489 / #v428.history
			v428.lastPos = p72
			v428.lastVel = p73
			v428.acc = acc
			v428.avgVel = v492
			t6.value29[p71] = v428

			return v428
		end

		table.remove(v428.history)

		local vector3 = Vector3.new(0, 0, 0)

		for _, v in ipairs(v428.history) do
			vector3 = vector3 + v
		end

		local avgVel = vector3 / #v428.history

		v428.lastPos = p72
		v428.lastVel = p73
		v428.acc = acc
		v428.avgVel = avgVel
		t6.value29[p71] = v428

		return v428
	end
	local function v437(p74)
		local value30 = t6.value30

		table.insert(value30, p74)

		if not (#t6.value30 > t6.value31) then
			return
		end

		table.remove(t6.value30, 1)
	end

	function t1.value2(p75)
		if #p75 < 4 then
			return "unknown", false
		else
			local v439 = p75[#p75 - 3]
			local v440 = p75[#p75 - 2]
			local v441 = p75[#p75 - 1]
			local v442 = p75[#p75]
			local Unit = (v442 - v439).Unit
			local v444 = Unit:Dot((v442 - v441).Unit)
			local v445 = math.clamp(v444, -1, 1)
			local v446 = math.acos(v445) * 57.29577951308232
			local v447

			if v446 > 60 then
				v447 = (v442 - v441).Magnitude < (v440 - v439).Magnitude * 0.7
			else
				v447 = false
			end

			local X = Unit.X
			local v449

			if math.abs(X) < 0.3 then
				v449 = Unit.Z > 0.7
			else
				v449 = false
			end

			local s2

			if v449 then
				s2 = "streak"
			else
				local v451

				if Unit.X > 0.7 then
					v451 = Unit.Z > 0.5
				else
					v451 = false
				end

				if v451 then
					s2 = "corner_right"
				else
					local v452

					if Unit.X < -0.7 then
						v452 = Unit.Z > 0.5
					else
						v452 = false
					end

					if v452 then
						s2 = "corner_left"
					else
						local v453

						if Unit.X > 0.7 then
							local Z = Unit.Z

							v453 = math.abs(Z) < 0.3
						else
							v453 = false
						end

						if v453 then
							s2 = "out_right"
						else
							local v455

							if Unit.X < -0.7 then
								local Z = Unit.Z

								v455 = math.abs(Z) < 0.3
							else
								v455 = false
							end

							if v455 then
								s2 = "out_left"
							else
								local v457

								if Unit.X > 0.7 then
									v457 = Unit.Z < -0.5
								else
									v457 = false
								end

								if v457 then
									s2 = "slant_right"
								else
									local v458

									if Unit.X < -0.7 then
										v458 = Unit.Z < -0.5
									else
										v458 = false
									end

									if v458 then
										s2 = "slant_left"
									else
										local v459

										if Unit.Z < -0.5 then
											v459 = v446 > 90
										else
											v459 = false
										end

										s2 = v459 and "curl" or "streak"
									end
								end
							end
						end
					end
				end
			end

			return s2, v447
		end
	end

	local value22 = t1.value2

	local function v461(p76)
		return t6.value35 + p76 / 100 * (t6.value34 - t6.value35)
	end

	function t1.value2(p77, p78)
		local Character = p77.Character

		if Character then
			local UpperTorso = Character:FindFirstChild("UpperTorso") or (Character:FindFirstChild("Torso") or Character:FindFirstChild("HumanoidRootPart"))

			if UpperTorso then
				return UpperTorso.Position + UpperTorso.Velocity * p78
			else
				return nil
			end
		else
			return nil
		end
	end

	local function v464(p79, p80, p81)
		local v465 = v461(p81)
		local Unit = (p80 - p79).Unit
		local Magnitude = Vector3.new(p80.X - p79.X, 0, p80.Z - p79.Z).Magnitude
		local _ = p80.Y - p79.Y
		local huge = math.huge
		local vector3 = nil
		local v471 = nil

		for i = 0.08726646259971647, 1.4835298641951802, 0.004363323129985824 do
			local v473 = v465 * math.cos(i)
			local v474 = v465 * math.sin(i)
			local v475 = Magnitude / v473
			local v476 = p79.Y + v474 * v475 - 0.5 * t6.value36 * v475 ^ 2 - p80.Y
			local v477 = math.abs(v476)

			if v477 < huge then
				local value37 = t6.value37
				local v479 = Unit.X * v473
				local v480 = Unit.Z * v473
				local v481 = p79.X + v479 * v475
				local v482 = p79.Z + v480 * v475

				vector3 = Vector3.new(v481, value37, v482)
				v471 = v475
				huge = v477
			end
		end

		return vector3, v471
	end
	local function v483(p82, p83)
		return p82 >= 300 and 120 or ((p83 > 12 and true or p82 > 100) and 100 or 80)
	end

	local value12 = t1.value1

	local function v485()
		if t6.value28 then
			t6.value28:Disconnect()
		end

		if t6.value29 then
			for k in pairs(t6.value29) do
				t6.value29[k] = nil
			end
		end

		if not t6.value30 then
			return
		end

		for k in pairs(t6.value30) do
			t6.value30[k] = nil
		end
	end
	local function v488()
		if not t6.value25 then
			return
		end

		local Replicated = t6.value8:FindFirstChild("Replicated")

		if Replicated then
			Replicated = t6.value8.Replicated:FindFirstChild("GameID")
		end

		if not Replicated then
			return
		end

		local Value = Replicated.Value
		local Games = t6.value6:FindFirstChild("Games")

		if Games then
			local v493 = Games:FindFirstChild(Value)
			local GameParams = v493 and v493:FindFirstChild("GameParams")

			if GameParams then
				local DivePower = GameParams:FindFirstChild("DivePower")
				local isNumberValue

				if DivePower then
					isNumberValue = DivePower:IsA("NumberValue")
				else
					isNumberValue = DivePower
				end

				if isNumberValue then
					DivePower.Value = t6.value54
				end
			end
		end

		local MiniGames = t6.value6:FindFirstChild("MiniGames")

		if not MiniGames then
			return
		end

		local v497 = MiniGames:FindFirstChild(Value)
		local GameParams = v497 and v497:FindFirstChild("GameParams")

		if not GameParams then
			return
		end

		local DivePower = GameParams:FindFirstChild("DivePower")
		local isNumberValue

		if DivePower then
			isNumberValue = DivePower:IsA("NumberValue")
		else
			isNumberValue = DivePower
		end

		if not isNumberValue then
			return
		end

		DivePower.Value = t6.value54
	end

	t6.value4.InputEnded:Connect(function(input, _)
		local v501

		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			v501 = true
		elseif input.UserInputType == Enum.UserInputType.Gamepad1 then
			v501 = input.KeyCode == Enum.KeyCode.ButtonR2
		else
			v501 = false
		end
	end)
	t6.value4.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		local value27

		if input.KeyCode == Enum.KeyCode.H then
			value27 = t6.value27
		else
			value27 = false
		end

		if not value27 then
			return
		end

		local v503 = value12()

		_G.SelectedAimbotPlayer = v503

		if v503 then
			t6.value1:Notify("Selected: " .. v503.Name, 3)

			return
		end

		t6.value1:Notify("No player found", 2)
	end)
	CharacterAdded = t6.value4.InputBegan
	t1.value3 = CharacterAdded.Connect
	t1.value3(CharacterAdded, function(p84, p85)
		if p85 then
			return
		end

		local value27

		if p84.KeyCode == Enum.KeyCode.T then
			value27 = t6.value27
		else
			value27 = false
		end

		if not value27 then
			return
		end

		local SelectedAimbotPlayer = _G.SelectedAimbotPlayer

		if not SelectedAimbotPlayer then
			t6.value1:Notify("No player selected! Press H first", 3)

			return
		end

		local Football = workspace[t6.value8.Name]

		if Football then
			Football = workspace[t6.value8.Name]:FindFirstChild("Football")
		end

		if not Football then
			t6.value1:Notify("No football found!", 2)

			return
		end

		local Position = Football.Position

		if not Football.Velocity then
			Vector3.new()
		end

		local Character = SelectedAimbotPlayer.Character

		if Character then
			Character = SelectedAimbotPlayer.Character:FindFirstChild("HumanoidRootPart")
		end

		if not Character then
			return
		end

		local Position2 = Character.Position
		local v510 = v427(SelectedAimbotPlayer, Position2, Character.Velocity)

		v483((Position2 - Position).Magnitude, v510.avgVel and (v510.avgVel.Magnitude or 0) or 0)

		local t8 = {
			[120] = {
				{ 324, 230 },
				{ 335, 250 },
				{ 355, 320 },
				{ 360, 370 },
				{ 380, 420 },
				{ 317, 260 }
			},
			[100] = {
				{ 40, 6 },
				{ 50, 9 },
				{ 60, 13 },
				{ 70, 17 },
				{ 80, 21 },
				{ 90, 23 },
				{ 100, 24 },
				{ 110, 28 },
				{ 120, 32 },
				{ 130, 36 },
				{ 140, 40 },
				{ 150, 44 },
				{ 160, 50 },
				{ 170, 55 },
				{ 178, 65 },
				{ 190, 75 },
				{ 200, 85 },
				{ 220, 95 },
				{ 233, 105 },
				{ 264, 140 },
				{ 274, 170 },
				{ 317, 200 },
				{ 332, 220 },
				{ 360, 270 }
			},
			[80] = {
				{ 4, 2 },
				{ 13, 4 },
				{ 31, 6 },
				{ 33, 7 },
				{ 40, 8 },
				{ 50, 13 },
				{ 60, 15 },
				{ 68, 18 },
				{ 75, 20 },
				{ 80, 12 },
				{ 89, 13 },
				{ 100, 15 },
				{ 150, 38 },
				{ 170, 55 },
				{ 185, 70 },
				{ 200, 120 },
				{ 233, 140 },
				{ 264, 180 },
				{ 274, 210 },
				{ 317, 220 },
				{ 332, 250 }
			}
		}
		local t9 = {
			[120] = {
				{ 324, 250 },
				{ 335, 270 },
				{ 355, 340 },
				{ 360, 390 }
			},
			[100] = {
				{ 40, 15 },
				{ 45, 15 },
				{ 50, 16 },
				{ 55, 17 },
				{ 60, 18 },
				{ 65, 18 },
				{ 70, 20 },
				{ 75, 21 },
				{ 80, 22 },
				{ 85, 23 },
				{ 90, 25 },
				{ 95, 27 },
				{ 100, 28 },
				{ 105, 30 },
				{ 110, 32 },
				{ 115, 34 },
				{ 120, 36 },
				{ 125, 39 },
				{ 130, 41 },
				{ 135, 44 },
				{ 140, 46 },
				{ 145, 49 },
				{ 150, 52 },
				{ 155, 55 },
				{ 160, 58 },
				{ 165, 61 },
				{ 170, 64 },
				{ 175, 68 },
				{ 180, 71 },
				{ 185, 75 },
				{ 190, 79 },
				{ 195, 82 },
				{ 200, 86 },
				{ 205, 90 },
				{ 210, 95 },
				{ 215, 99 },
				{ 220, 103 },
				{ 225, 108 },
				{ 230, 112 },
				{ 235, 117 },
				{ 240, 122 },
				{ 245, 127 },
				{ 250, 132 },
				{ 255, 137 },
				{ 260, 142 },
				{ 265, 148 },
				{ 270, 153 },
				{ 275, 159 },
				{ 280, 165 },
				{ 285, 171 },
				{ 290, 176 },
				{ 295, 183 },
				{ 300, 189 },
				{ 305, 195 },
				{ 310, 201 },
				{ 315, 208 },
				{ 320, 214 },
				{ 325, 221 },
				{ 330, 228 },
				{ 332, 231 },
				{ 335, 235 }
			},
			[80] = {
				{ 4, 7 },
				{ 13, 7 },
				{ 31, 9 },
				{ 33, 10 },
				{ 40, 11 },
				{ 50, 13 },
				{ 54, 14 },
				{ 60, 16 },
				{ 80, 23 },
				{ 89, 26 },
				{ 100, 31 },
				{ 150, 61 },
				{ 170, 76 },
				{ 185, 88 },
				{ 200, 102 }
			}
		}

		local function v513(p86, p87, p88)
			local v514 = p86[p87]

			if v514 then
				if p88 <= v514[1][1] then
					return v514[1][2]
				elseif v514[#v514][1] <= p88 then
					return v514[#v514][2]
				else
					for i = 2, #v514 do
						local v516 = v514[i - 1][1]
						local v517 = v514[i - 1][2]
						local v518 = v514[i][1]
						local v519 = v514[i][2]

						if p88 == v518 then
							return v519
						end

						if p88 < v518 then
							return v517 + (p88 - v516) / (v518 - v516) * (v519 - v517)
						end
					end

					return v514[#v514][2]
				end
			else
				return t6.value37
			end
		end

		local n12 = 3
		local avgVel = v510.avgVel

		if avgVel then
			avgVel = v510.avgVel.Magnitude
		end

		local v522 = avgVel or 0
		local Magnitude = (Position - Position2).Magnitude

		v437(Position2)

		local v524, v525 = value22(t6.value30)
		local v526 = Magnitude < 80

		if v526 then
			v526 = (v524 == "curl" or (v524 == "comeback" or v524 == "out_right")) and true or v524 == "out_left"
		end

		local v527 = v526 and 80 or (Magnitude > 200 and 120 or (n12 < v522 and 100 or 80))
		local vector3

		if n12 < v522 then
			local v529 = Position2

			for _ = 1, 3 do
				local _, v532 = v464(Position, v529, v527)

				if v525 then
					local Unit = v510.avgVel.Unit
					local Magnitude2 = v510.avgVel.Magnitude

					v529 = Position2 + Unit * math.min(Magnitude2, 12)
				elseif v524 == "streak" then
					v529 = Position2 + v510.avgVel * v532 * 1.1
				elseif v524 == "corner_right" and true or v524 == "corner_left" then
					v529 = Position2 + v510.avgVel * v532 * 2.05
				elseif v524 == "slant_right" and true or v524 == "slant_left" then
					v529 = Position2 + v510.avgVel * v532 * 2.05
				elseif v524 == "out_right" and true or v524 == "out_left" then
					v529 = Position2 + v510.avgVel * v532 * 2.05
				elseif v524 == "curl" and true or v524 == "comeback" then
					v529 = Position2
				else
					v529 = Position2 + v510.avgVel * v532
				end
			end

			local Magnitude2 = (Vector3.new(v529.X, Position.Y, v529.Z) - Vector3.new(Position.X, Position.Y, Position.Z)).Magnitude
			local v536 = v513(t9, v527, Magnitude2)

			if v524 == "streak" then
				v536 = v536 - 6
			elseif Magnitude2 > 280 then
				v536 = v536 + 6.2
			elseif Magnitude2 > 150 then
				v536 = v536 + 4.2
			end

			vector3 = Vector3.new(v529.X, v536, v529.Z)
		else
			local v537 = v513(t8, v527, (Position2 - Position).Magnitude)

			vector3 = Vector3.new(Position2.X, v537, Position2.Z)
		end

		local _ = v464(Position, vector3, v527)
		local v540 = nil
		local MiniGames = workspace:FindFirstChild("MiniGames")
		local v542

		if MiniGames then
			v542 = #MiniGames:GetChildren() > 0
		else
			v542 = MiniGames
		end

		if v542 then
			local GetChildren = MiniGames.GetChildren
			local v544, v545, v546 = ipairs(GetChildren(MiniGames))
			local ReEvent

			while true do
				v546, v621 = v544(v545, v546)

				if not v546 then
					break
				end

				if v621:IsA("Model") then
					local Replicated = v621:FindFirstChild("Replicated")
					local isModel

					if Replicated then
						isModel = Replicated:IsA("Model")
					else
						isModel = Replicated
					end

					if isModel then
						local SpotTags = Replicated:FindFirstChild("SpotTags")

						if SpotTags then
							SpotTags = SpotTags:IsA("Folder")
						end

						if SpotTags then
							if v621 then
								ReEvent = game:GetService("ReplicatedStorage"):WaitForChild("MiniGames"):WaitForChild(v621.Name):WaitForChild("ReEvent")
								ReEvent.FireServer(ReEvent, unpack({
									"Mechanics",
									"ThrowBall",
									{
										Target = vector3,
										AutoThrow = false,
										Power = v527
									}
								}))

								return
							else
								return
							end
						end
					end
				end
			end

			local v551 = v540

			if v551 then
				ReEvent = game:GetService("ReplicatedStorage"):WaitForChild("MiniGames"):WaitForChild(v551.Name):WaitForChild("ReEvent")
				ReEvent.FireServer(ReEvent, unpack({
					"Mechanics",
					"ThrowBall",
					{
						Target = vector3,
						AutoThrow = false,
						Power = v527
					}
				}))

				return
			else
				return
			end
		end

		local Games = workspace:FindFirstChild("Games")
		local v553

		if Games then
			v553 = #Games:GetChildren() > 0
		else
			v553 = Games
		end

		if not v553 then
			return
		end

		local GetChildren = Games.GetChildren
		local v555, v556, v557 = ipairs(GetChildren(Games))

		while true do
			local v558

			v557, v558 = v555(v556, v557)

			if not v557 then
				v558 = v540

				break
			end

			if v558:IsA("Model") then
				local Replicated = v558:FindFirstChild("Replicated")
				local isModel

				if Replicated then
					isModel = Replicated:IsA("Model")
				else
					isModel = Replicated
				end

				if isModel then
					local ActiveSpots = Replicated:FindFirstChild("ActiveSpots")

					if ActiveSpots then
						ActiveSpots = ActiveSpots:IsA("Folder")
					end

					if ActiveSpots then
						break
					end
				end
			end
		end

		if not v628 then
			return
		end

		local ReEvent = game:GetService("ReplicatedStorage"):WaitForChild("Games"):WaitForChild(v628.Name):WaitForChild("ReEvent")

		ReEvent.FireServer(ReEvent, unpack({
			"Mechanics",
			"ThrowBall",
			{
				Target = vector3,
				AutoThrow = false,
				Power = v527
			}
		}))
	end)
	t1.value3 = t6.value1:CreateWindow({
		Title = "Mini Hub | NFL Universe",
		Center = true,
		AutoShow = true,
		TabPadding = 8,
		MenuFadeTime = 0.2
	})
	CharacterAdded = t1.value3:AddTab("Main")
	Add = t1.value3:AddTab("Player")
	t1.value2 = t1.value3:AddTab("Hitbox")
	t1.value1 = t1.value3:AddTab("Automatic")
	TouchEnabled = t1.value3:AddTab("UI Settings")
	CharacterAdded = {
		Main = CharacterAdded,
		Player = Add,
		Hitbox = t1.value2,
		Automatic = t1.value1,
		["UI Settings"] = TouchEnabled
	}
	Add = CharacterAdded.Main:AddLeftGroupbox("QB Aimbot")
	Add.AddToggle(Add, "QBAimbot", {
		Text = "QB Aimbot",
		Default = false,
		Tooltip = "Automatically throw to selected receiver with prediction",
		Callback = function(p89)
			t6.value27 = p89

			if p89 then
				t6.value1:Notify("QB Aimbot Enabled! Press H to select, T to throw", 5)
			else
				v485()
				_G.SelectedAimbotPlayer = nil
			end
		end
	})
	Add:AddLabel("Controls:", true)
	Add:AddLabel("H - Select nearest player", true)
	Add:AddLabel("T - Throw to selected player", true)
	t1.value1 = string.split(identifyexecutor() or "None", " ")[1]

	if t1.value1 ~= "Xeno" then
		local u563 = false
		local n13 = 120
		local u565 = false
		local Part = nil
		local LocalPlayer = game.Players.LocalPlayer
		local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

		t1.value1 = Character:WaitForChild("HumanoidRootPart")

		local value13 = t1.value1
		local cFrame = CFrame.new()
		local u571 = nil
		local v572 = nil

		function t1.value2(p90)
			u571 = p90
			v572[tostring(p90:GetDebugId())] = p90.Position
		end

		u571 = nil

		local u573 = false

		v572 = {}

		local t10 = {
			Football = true,
			["Football MeshPart"] = true
		}

		local function v575(p91)
			local isMeshPart = p91:IsA("MeshPart")

			if not isMeshPart then
				return isMeshPart
			end

			isMeshPart = t10[p91.Name]

			return isMeshPart
		end
		local function v577()
			if not Part then
				Part = Instance.new("Part")
				Part.Name = "MagnetHitbox"
				Part.Size = Vector3.new(n13 * 2, n13 * 2, n13 * 2)
				Part.Anchored = true
				Part.CanCollide = false
				Part.Transparency = 0.7
				Part.Material = Enum.Material.ForceField
				Part.Color = Color3.fromRGB(138, 43, 226)
				Part.CastShadow = false
				Part.Shape = Enum.PartType.Ball
				Part.Parent = workspace

				return Part
			end

			Part:Destroy()
			Part = Instance.new("Part")
			Part.Name = "MagnetHitbox"
			Part.Size = Vector3.new(n13 * 2, n13 * 2, n13 * 2)
			Part.Anchored = true
			Part.CanCollide = false
			Part.Transparency = 0.7
			Part.Material = Enum.Material.ForceField
			Part.Color = Color3.fromRGB(138, 43, 226)
			Part.CastShadow = false
			Part.Shape = Enum.PartType.Ball
			Part.Parent = workspace

			return Part
		end
		local function v578(p92)
			local v579 = tostring(p92:GetDebugId())
			local v580 = v572[v579]
			local Position = p92.Position

			v572[v579] = Position

			return Position, v580 or Position
		end
		local function v582()
			local Parent3 = u571

			if Parent3 then
				Parent3 = u571.Parent
			end

			if not Parent3 then
				return false
			end

			local Parent4 = u571.Parent
			local isModel = Parent4:IsA("Model")

			if isModel then
				isModel = game.Players:GetPlayerFromCharacter(Parent4)
			end

			if isModel then
				return true
			end

			local next_ = next
			local players, key = game.Players:GetPlayers()

			while true do
				local v589

				key, v589 = next_(players, key)

				if not key then
					break
				end

				local Character2 = v589.Character

				if Character2 then
					Character2 = u571:IsDescendantOf(v589.Character)
				end

				if Character2 then
					return true
				end
			end

			return false
		end
		local function v591()
			if not Part then
				return
			end

			Part:Destroy()
			Part = nil
		end
		local function v592()
			local Parent3 = u565

			if Parent3 then
				Parent3 = u563 and u571

				if Parent3 then
					Parent3 = u571.Parent
				end
			end

			if Parent3 then
				if Part then
					Part.CFrame = u571.CFrame
					Part.Size = Vector3.new(n13 * 2, n13 * 2, n13 * 2)

					return
				end

				v577()
				Part.CFrame = u571.CFrame
				Part.Size = Vector3.new(n13 * 2, n13 * 2, n13 * 2)
			else
				if not Part then
					return
				end

				v591()
			end
		end

		local value23 = t1.value2

		t1.value2 = workspace.DescendantAdded
		Add = function(p93)
			if not v575(p93) then
				return
			end

			value23(p93)
			u573 = false
		end
		t1.value2:Connect(Add)
		t1.value2 = workspace.DescendantAdded
		Add = function(p94)
			if not v575(p94) then
				return
			end

			p94.AncestryChanged:Connect(function()
				local Parent3 = p94.Parent

				if Parent3 then
					Parent3 = p94.Parent:IsA("Model")

					if Parent3 then
						Parent3 = game.Players:GetPlayerFromCharacter(p94.Parent)
					end
				end

				if Parent3 then
					u573 = true

					return
				end

				if not (p94.Parent == workspace and true or p94.Parent == nil) then
					return
				end

				u573 = false
			end)
		end
		t1.value2:Connect(Add)
		t1.value2 = workspace.DescendantRemoving
		Add = function(p95)
			if p95 ~= u571 then
				return
			end

			u571 = nil
			u573 = false
		end
		t1.value2:Connect(Add)
		t1.value2 = next
		Add, TouchEnabled = workspace:GetDescendants()

		local u596 = u573
		local v597 = u571

		local function v598()
			local v599 = LocalPlayer:GetNetworkPing() * 1000

			return v599 > 250 and 2.5 or (v599 > 200 and 2 or (v599 > 150 and 1.7 or (v599 > 100 and 1.4 or (v599 > 50 and 1.2 or 1))))
		end

		while true do
			TouchEnabled, UserInputService = t1.value2(Add, TouchEnabled)

			if not TouchEnabled then
				break
			end

			t1.value4 = v575(UserInputService)

			if t1.value4 then
				value23(UserInputService)
				t1.value4 = UserInputService.Parent
				t1.value1 = t1.value4

				if t1.value4 then
					v698 = UserInputService.Parent:IsA("Model")
					t1.value4 = v698

					if v698 then
						t1.value5 = game.Players
						t1.value3 = UserInputService.Parent
						t1.value4 = t1.value5:GetPlayerFromCharacter(t1.value3)
					end

					t1.value1 = t1.value4
				end

				u596 = t1.value1 and true or u596
			end
		end

		local v600 = nil

		v600 = hookmetamethod(game, "__index", function(p96, p97)
			local v601 = u563

			if v601 then
			elseif v601 then
				return cFrame
			else
				return v600(p96, p97)
			end

			v601 = not checkcaller()

			if v601 then
			elseif v601 then
				return cFrame
			else
				return v600(p96, p97)
			end

			local _ = p97 == "CFrame" and p96 == value13

			v601 = false

			if v601 then
				return cFrame
			else
				return v600(p96, p97)
			end
		end)
		t1.value2 = game:GetService("RunService").Heartbeat
		t1.value2:Connect(function()
			v592()

			if u563 and (v597 and v597.Parent) then
				u596 = v582()

				if u596 then
					return
				else
					local v603, v604 = v578(v597)

					if n13 < (value13.Position - v603).Magnitude then
						return
					else
						local v605 = v603 - v604
						local v606 = v598()
						local n14 = 8
						local v608

						if v605.Magnitude > 0.1 then
							v608 = v603 + v605.Unit * n14 * v606
						else
							v608 = v603 + Vector3.new(5, 0, 5) * v606
						end

						local vector3New = Vector3.new
						local X = v608.X
						local Y = v608.Y
						local Y2 = v603.Y
						local vector3 = vector3New(X, math.max(Y, Y2), v608.Z)

						cFrame = value13.CFrame
						value13.CFrame = CFrame.new(vector3)
						game:GetService("RunService").RenderStepped:Wait()
						value13.CFrame = cFrame

						return
					end
				end
			else
				u596 = false
			end
		end)
		t1.value2 = LocalPlayer.CharacterAdded
		t1.value2:Connect(function(p98)
			Character = p98
			p98:WaitForChild("HumanoidRootPart")
			v591()
		end)
		v698 = CharacterAdded.Main:AddLeftGroupbox("Football Magnet")
		t1.value2 = v698.AddToggle

		function t1.value4(p99)
			u563 = p99

			if p99 then
				return
			end

			v591()
		end

		t1.value2(v698, "FootballMagnet", {
			Text = "Desync Mags",
			Default = false,
			Tooltip = "Auto mags football to you when in range",
			Callback = t1.value4
		})
		t1.value2 = v698.AddSlider
		t1.value2(v698, "FootballDistance", {
			Text = "Magnet Distance",
			Default = 120,
			Min = 0,
			Max = 120,
			Rounding = 0,
			Compact = false,
			Tooltip = "Maximum distance to magnet from",
			Callback = function(p100)
				n13 = p100
			end
		})
		t1.value2 = v698.AddToggle

		function t1.value4(p101)
			u565 = p101

			if p101 then
				return
			end

			v591()
		end

		t1.value2(v698, "ShowHitbox", {
			Text = "Show Hitbox",
			Default = false,
			Tooltip = "Show visual hitbox sphere",
			Callback = t1.value4
		})
	end

	t1.value1 = CharacterAdded.Main:AddLeftGroupbox("Legit Pull Vector")
	t1.value1.AddToggle(t1.value1, "SmoothPull", {
		Text = "Legit Pull Vector (M1)",
		Default = false,
		Tooltip = "Smoothly pulls you to the football",
		Callback = function(p102)
			t6.value12 = p102
		end
	})
	t1.value1.AddSlider(t1.value1, "MagnetSmoothness", {
		Text = "Vector Smoothing",
		Default = 0.2,
		Min = 0.01,
		Max = 1,
		Rounding = 2,
		Compact = false,
		Tooltip = "Lower = smoother, Higher = faster",
		Callback = function(p103)
			t6.value40 = p103
		end
	})

	local WalkSpeedValue = CharacterAdded.Main:AddRightGroupbox("Pull Vector")

	WalkSpeedValue.AddToggle(WalkSpeedValue, "PullVector", {
		Text = "Pull Vector (M1)",
		Default = false,
		Tooltip = "Instantly teleports you to the football",
		Callback = function(p104)
			t6.value11 = p104
		end
	})
	WalkSpeedValue.AddToggle(WalkSpeedValue, "AutoOffset", {
		Text = "Auto Offset Distance",
		Default = false,
		Tooltip = "Automatically adjusts offset based on ball power (Not recommended for open park)",
		Callback = function(p105)
			t6.value55 = p105
		end
	})
	WalkSpeedValue.AddSlider(WalkSpeedValue, "OffsetDistance", {
		Text = "Offset Distance",
		Default = 15,
		Min = 0,
		Max = 30,
		Rounding = 0,
		Compact = false,
		Tooltip = "Distance in front of the ball",
		Callback = function(p106)
			t6.value39 = p106
		end
	})
	WalkSpeedValue.AddSlider(WalkSpeedValue, "MaxPullDistance", {
		Text = "Max Pull Distance",
		Default = 35,
		Min = 1,
		Max = 100,
		Rounding = 0,
		Compact = false,
		Tooltip = "Maximum distance to pull from (Park only)",
		Callback = function(p107)
			t6.value47 = p107
		end
	})
	t1.value2 = CharacterAdded.Player:AddLeftGroupbox("WalkSpeed")
	t1.value1 = { "WalkSpeed", "CFrame" }
	t1.value2:AddDropdown("SpeedMethod", {
		Values = t1.value1,
		Default = 1,
		Multi = false,
		Text = "Speed Method",
		Tooltip = "Choose how speed boost works"
	})
	Options.SpeedMethod:OnChanged(function()
		t6.value58 = Options.SpeedMethod.Value

		if t6.value67 then
			t6.value67:Disconnect()
			t6.value67 = nil
		end

		if t6.value68 then
			t6.value68:Disconnect()
			t6.value68 = nil
		end

		if not t6.value17 then
			return
		end

		if t6.value58 == "CFrame" then
			t6.value68 = t6.value5.RenderStepped:Connect(function(dt)
				local Character = t6.value8.Character

				if not Character then
					return
				end

				local Humanoid = Character:FindFirstChildOfClass("Humanoid")
				local v617 = not Humanoid
				local v618 = Character.FindFirstChild(Character, "HumanoidRootPart")

				if v617 or not v618 then
					return
				end

				local MoveDirection = Humanoid.MoveDirection

				if not (MoveDirection.Magnitude > 0) then
					return
				end

				v618.CFrame = v618.CFrame + MoveDirection * Options.CFrameMultiplier.Value * dt
			end)

			return
		end

		local Character = t6.value8.Character

		if Character then
			Character = t6.value8.Character:FindFirstChildOfClass("Humanoid")
		end

		if not Character then
			return
		end

		Character.WalkSpeed = Options.WalkSpeedValue.Value
		t6.value67 = Character:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
			if not t6.value17 then
				return
			end

			Character.WalkSpeed = Options.WalkSpeedValue.Value
		end)
	end)
	t1.value2:AddSlider("CFrameMultiplier", {
		Text = "CFrame Speed Multiplier",
		Default = 5,
		Min = 0.01,
		Max = 10,
		Rounding = 2,
		Compact = false
	})
	t1.value2.AddToggle(t1.value2, "WalkSpeedToggle", {
		Text = "Enable Speed",
		Default = false,
		Tooltip = "Increases your movement speed",
		Callback = function(p108)
			t6.value17 = p108

			if t6.value67 then
				t6.value67:Disconnect()
			end

			if t6.value68 then
				t6.value68:Disconnect()
			end

			if p108 then
				if Options.SpeedMethod.Value == "CFrame" then
					t6.value5.RenderStepped:Connect(function(dt)
						local Character = t6.value8.Character

						if not Character then
							return
						end

						local Humanoid = Character:FindFirstChildOfClass("Humanoid")
						local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")

						if not (Humanoid and HumanoidRootPart) then
							return
						end

						local MoveDirection = Humanoid.MoveDirection

						if not (MoveDirection.Magnitude > 0) then
							return
						end

						local WalkSpeed = Humanoid.WalkSpeed or 16

						HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + MoveDirection.Unit * WalkSpeed * Options.CFrameMultiplier.Value * dt
					end)
				else
					local Character = t6.value8.Character

					if Character then
						Character = t6.value8.Character:FindFirstChildOfClass("Humanoid")
					end

					if not Character then
						return
					end

					Character.WalkSpeed = Options.WalkSpeedValue.Value
					Character:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
						if not t6.value17 then
							return
						end

						Character.WalkSpeed = Options.WalkSpeedValue.Value
					end)
				end
			end

			local Character = t6.value8.Character

			if Character then
				Character = t6.value8.Character:FindFirstChildOfClass("Humanoid")
			end

			if not Character then
				return
			end

			Character.WalkSpeed = 16
		end
	})
	t1.value2:AddSlider("WalkSpeedValue", {
		Text = "WalkSpeed Value",
		Default = 25,
		Min = 16,
		Max = 35,
		Rounding = 0,
		Compact = false
	})
	WalkSpeedValue = Options.WalkSpeedValue

	function t1.value1()
		local value17 = t6.value17

		if value17 then
			value17 = Options.SpeedMethod.Value == "WalkSpeed"
		end

		if not value17 then
			return
		end

		local Character = t6.value8.Character

		if Character then
			Character = t6.value8.Character:FindFirstChildOfClass("Humanoid")
		end

		if not Character then
			return
		end

		Character.WalkSpeed = Options.WalkSpeedValue.Value
	end

	WalkSpeedValue:OnChanged(t1.value1)
	WalkSpeedValue = Options.CFrameMultiplier

	function t1.value1() end

	WalkSpeedValue:OnChanged(t1.value1)
	t1.value2 = CharacterAdded.Player:AddLeftGroupbox("JumpPower")
	t1.value2.AddToggle(t1.value2, "JumpPowerToggle", {
		Text = "JumpPower",
		Default = false,
		Tooltip = "Increases your jump height",
		Callback = function(p109)
			t6.value20 = p109

			if p109 then
				if t6.value62 then
					t6.value62:Disconnect()
				end

				t6.value62 = t6.value72.Jumping:Connect(function()
					local value20 = t6.value20

					if value20 then
						value20 = t6.value71
					end

					if not value20 then
						return
					end

					local vector3 = Vector3.new(0, t6.value42, 0)

					t6.value71.Velocity = Vector3.new(t6.value71.Velocity.X, 0, t6.value71.Velocity.Z) + vector3
				end)

				return
			end

			if not t6.value62 then
				return
			end

			t6.value62:Disconnect()
		end
	})
	t1.value2.AddSlider(t1.value2, "JumpPowerValue", {
		Text = "Custom JumpPower",
		Default = 50,
		Min = 10,
		Max = 200,
		Rounding = 0,
		Compact = false,
		Callback = function(p110)
			t6.value42 = p110
		end
	})
	t1.value1 = CharacterAdded.Player:AddRightGroupbox("Fly")
	t1.value1.AddToggle(t1.value1, "FlyToggle", {
		Text = "Fly",
		Default = false,
		Tooltip = "Allows your character to fly",
		Callback = function(p111)
			t6.value15 = p111

			if p111 then
				if t6.value60 then
					return
				end

				t6.value60 = Instance.new("BodyVelocity")
				t6.value60.MaxForce = Vector3.new(100000, 100000, 100000)
				t6.value60.Velocity = Vector3.new(0, 0, 0)
				t6.value60.Parent = t6.value71
				t6.value61 = Instance.new("BodyGyro")
				t6.value61.MaxTorque = Vector3.new(100000, 100000, 100000)
				t6.value61.P = 1000
				t6.value61.D = 100

				local function v632()
					while t6.value16 do
						local CurrentCamera = t6.value7.CurrentCamera
						local vector3 = Vector3.new(0, 0, 0)

						if t6.value4:IsKeyDown(Enum.KeyCode.W) then
							vector3 = vector3 + CurrentCamera.CFrame.LookVector
						end

						if t6.value4:IsKeyDown(Enum.KeyCode.S) then
							vector3 = vector3 - CurrentCamera.CFrame.LookVector
						end

						if t6.value4:IsKeyDown(Enum.KeyCode.A) then
							vector3 = vector3 - CurrentCamera.CFrame.RightVector
						end

						if t6.value4:IsKeyDown(Enum.KeyCode.D) then
							vector3 = vector3 + CurrentCamera.CFrame.RightVector
						end

						if t6.value4:IsKeyDown(Enum.KeyCode.Space) then
							vector3 = vector3 + Vector3.new(0, 1, 0)
						end

						if t6.value4:IsKeyDown(Enum.KeyCode.LeftShift) then
							vector3 = vector3 - Vector3.new(0, 1, 0)
						end

						if vector3.Magnitude > 0 then
							t6.value60.Velocity = vector3.Unit * t6.value41
						else
							t6.value60.Velocity = Vector3.new(0, 0, 0)
						end

						wait()
					end
				end

				t6.value61.Parent = t6.value71
				t6.value16 = true
				spawn(v632)

				return
			end

			if t6.value60 then
				t6.value60:Destroy()
			end

			if not t6.value61 then
				return
			end

			t6.value61:Destroy()
		end
	})
	WalkSpeedValue = t1.value1.AddSlider

	function t1.value2(p112)
		t6.value41 = p112
	end

	WalkSpeedValue(t1.value1, "FlySpeed", {
		Text = "Fly Speed",
		Default = 50,
		Min = 10,
		Max = 200,
		Rounding = 0,
		Compact = false,
		Callback = t1.value2
	})
	t1.value1 = CharacterAdded.Player:AddRightGroupbox("Stamina")
	t1.value1.AddToggle(t1.value1, "StaminaDepletion", {
		Text = "(High Unc) Stamina Depletion",
		Default = false,
		Tooltip = "Reduces stamina depletion rate",
		Callback = function(p113)
			local function v635()
				while t6.value22 do
					task.wait()

					local value9 = t6.value9

					if value9 then
						value9 = t6.value38 > t6.value9.Stamina
					end

					if value9 then
						t6.value9.Stamina = t6.value9.Stamina + t6.value46 * 0.001
					end
				end
			end

			t6.value22 = p113
			spawn(v635)
		end
	})
	t1.value1.AddSlider(t1.value1, "StaminaDepletionRate", {
		Text = "Stamina Depletion Rate",
		Default = 1,
		Min = 1,
		Max = 100,
		Rounding = 1,
		Compact = false,
		Tooltip = "Higher = lower depletion",
		Callback = function(p114)
			t6.value46 = p114
		end
	})

	function t1.value2(p115)
		infiniteStaminaEnabled = p115
	end

	t1.value2 = {
		Text = "( Low Unc ) Infinite Stamina",
		Default = false,
		Tooltip = "Infinite Stamina for low unc executors",
		Callback = t1.value2
	}
	t1.value1:AddToggle("InfiniteStaminaToggle", t1.value2)
	t1.value1 = (function()
		local ReplicatedStorage = game:GetService("ReplicatedStorage")
		local Games = ReplicatedStorage:FindFirstChild("Games")

		if Games then
			for _, child in ipairs(Games:GetChildren()) do
				local MechanicsUsed = child:FindFirstChild("MechanicsUsed")
				local Sprinting = MechanicsUsed and MechanicsUsed:FindFirstChild("Sprinting")

				if Sprinting then
					Sprinting = MechanicsUsed.Sprinting:IsA("BoolValue")
				end

				if Sprinting then
					return MechanicsUsed.Sprinting
				end
			end
		end

		local MiniGames = ReplicatedStorage:FindFirstChild("MiniGames")

		if not MiniGames then
			return nil
		end

		for _, child in ipairs(MiniGames.GetChildren(MiniGames)) do
			if child:IsA("Folder") then
				local MechanicsUsed = child:FindFirstChild("MechanicsUsed")
				local Sprinting = MechanicsUsed and MechanicsUsed:FindFirstChild("Sprinting")

				if Sprinting then
					Sprinting = MechanicsUsed.Sprinting:IsA("BoolValue")
				end

				if Sprinting then
					return MechanicsUsed.Sprinting
				end
			end
		end

		return nil
	end)()

	local value13 = t1.value1

	if value13 then
		t1.value1 = t6.value4.InputBegan
		t1.value1:Connect(function(p116, p117)
			if p117 then
				return
			end

			if not (p116.KeyCode == Enum.KeyCode.Q and true or p116.KeyCode == Enum.KeyCode.ButtonL3) then
				return
			end

			isSprinting = not isSprinting

			if isSprinting then
				value13.Value = true

				if infiniteStaminaEnabled then
					task.wait(0.1)
					value13.Value = false

					return
				else
					return
				end
			end

			if not infiniteStaminaEnabled then
				return
			end

			value13.Value = true
			task.wait(0.1)
			value13.Value = false
		end)
	end

	t1.value2 = CharacterAdded.Player:AddLeftGroupbox("Jump Boost")
	t1.value1 = t1.value2.AddToggle
	t1.value1(t1.value2, "JumpBoostToggle", {
		Text = "Jump Boost",
		Default = false,
		Tooltip = "Boosts you up when colliding with players",
		Callback = function(p118)
			t6.value23 = p118

			if p118 then
				if t6.value8.Character then
					v398(t6.value8.Character)

					return
				else
					return
				end
			end

			t6.value10:Remove("JumpBoostTouch")
		end
	})
	t1.value1 = t1.value2.AddToggle
	t1.value1(t1.value2, "JumpBoostTradeMode", {
		Text = "Always Boost Mode",
		Default = false,
		Tooltip = "Boost on any player collision (no ball required)",
		Callback = function(p119)
			t6.value24 = p119
		end
	})
	t1.value1 = t1.value2.AddSlider
	t1.value1(t1.value2, "BoostForce", {
		Text = "Boost Force",
		Default = 32,
		Min = 10,
		Max = 100,
		Rounding = 0,
		Compact = false,
		Tooltip = "How high you get boosted",
		Callback = function(p120)
			t6.value49 = p120
		end
	})
	t1.value1 = t1.value2.AddSlider
	t1.value1(t1.value2, "BoostCooldown", {
		Text = "Boost Cooldown",
		Default = 1,
		Min = 0.1,
		Max = 5,
		Rounding = 1,
		Compact = false,
		Tooltip = "Cooldown between boosts (seconds)",
		Callback = function(p121)
			t6.value51 = p121
		end
	})
	WalkSpeedValue = CharacterAdded.Player:AddLeftGroupbox("Dive Boost")
	t1.value1 = WalkSpeedValue.AddToggle
	t1.value1(WalkSpeedValue, "DiveBoostToggle", {
		Text = "Dive Boost",
		Default = false,
		Tooltip = "Makes you dive further",
		Callback = function(p122)
			if t6.value59 then
				t6.value59:Disconnect()
			end

			if not p122 then
				v488()

				return
			end

			t6.value5.Heartbeat:Connect(v488)
			v488()
		end
	})
	t1.value1 = WalkSpeedValue.AddSlider

	function t1.value5(p123)
		t6.value54 = p123
	end

	t1.value1(WalkSpeedValue, "DiveBoostPower", {
		Text = "Dive Power",
		Default = 2.2,
		Min = 2.2,
		Max = 10,
		Rounding = 1,
		Compact = false,
		Tooltip = "How far you dive (default: 2.2)",
		Callback = t1.value5
	})
	t1.value1 = WalkSpeedValue.AddSlider

	function t1.value5(p124)
		t6.value53 = p124
	end

	t1.value1(WalkSpeedValue, "DiveBoostCooldown", {
		Text = "Dive Boost Cooldown",
		Default = 2,
		Min = 0.1,
		Max = 5,
		Rounding = 1,
		Compact = false,
		Tooltip = "Cooldown between dive boosts (seconds)",
		Callback = t1.value5
	})
	WalkSpeedValue = CharacterAdded.Player:AddRightGroupbox("BigHead")
	t1.value1 = WalkSpeedValue.AddToggle

	function t1.value2(p125)
		t6.value21 = p125

		if p125 then
			if t6.value63 then
				t6.value63:Disconnect()
			end

			t6.value63 = t6.value5.RenderStepped:Connect(function()
				local pairs_ = pairs
				local value23 = t6.value2

				for _, player in pairs_(value23.GetPlayers(value23)) do
					if player ~= t6.value8 then
						local Character = player.Character

						if Character then
							local Head = Character:FindFirstChild("Head")
							local isBasePart

							if Head then
								isBasePart = Head:IsA("BasePart")
							else
								isBasePart = Head
							end

							if isBasePart then
								local vector3New = Vector3.new
								local value43 = t6.value43

								Head.Size = vector3New(t6.value43, t6.value43, value43)
								Head.Transparency = t6.value44
								Head.CanCollide = true

								local face = Head:FindFirstChild("face")

								if face then
									face:Destroy()
								end
							end
						end
					end
				end
			end)

			return
		end

		local Character, Head, isBasePart

		if not t6.value63 then
			v769 = pairs
			v770 = t6.value2

			for _, player in v769(v770.GetPlayers(v770)) do
				if player ~= t6.value8 then
					Character = player.Character

					if Character then
						Head = Character:FindFirstChild("Head")

						if Head then
							isBasePart = Head:IsA("BasePart")
						else
							isBasePart = Head
						end

						if isBasePart then
							Head.Size = t6.value74
							Head.Transparency = t6.value75
							Head.CanCollide = false
						end
					end
				end
			end

			return
		end

		t6.value63:Disconnect()

		local pairs_ = pairs
		local value23 = t6.value2

		for _, player in pairs_(value23.GetPlayers(value23)) do
			if player ~= t6.value8 then
				Character = player.Character

				if Character then
					Head = Character:FindFirstChild("Head")

					if Head then
						isBasePart = Head:IsA("BasePart")
					else
						isBasePart = Head
					end

					if isBasePart then
						Head.Size = t6.value74
						Head.Transparency = t6.value75
						Head.CanCollide = false
					end
				end
			end
		end
	end

	t1.value1(WalkSpeedValue, "BigheadToggle", {
		Text = "Bighead Collision",
		Default = false,
		Tooltip = "Enlarge players heads for easier tackles",
		Callback = t1.value2
	})
	t1.value1 = WalkSpeedValue.AddSlider
	t1.value1(WalkSpeedValue, "BigheadSize", {
		Text = "Head Size",
		Default = 1,
		Min = 1,
		Max = 10,
		Rounding = 1,
		Compact = false,
		Tooltip = "Size multiplier for head",
		Callback = function(p126)
			t6.value43 = p126
		end
	})
	WalkSpeedValue:AddSlider("BigheadTransparency", {
		Text = "Head Transparency",
		Default = 0.5,
		Min = 0,
		Max = 1,
		Rounding = 2,
		Compact = false,
		Tooltip = "Adjust the transparency of enlarged heads",
		Callback = function(p127)
			t6.value44 = p127
		end
	})
	WalkSpeedValue = CharacterAdded.Hitbox:AddLeftGroupbox("Tackle Reach")
	t1.value1 = WalkSpeedValue.AddToggle
	t1.value1(WalkSpeedValue, "TackleReachToggle", {
		Text = "Tackle Reach",
		Default = false,
		Tooltip = "Expands your reach for tackling",
		Callback = function(p128)
			if t6.value65 then
				t6.value65:Disconnect()
			end

			if not p128 then
				return
			end

			t6.value5.Heartbeat:Connect(function()
				local ipairs_ = ipairs
				local value23 = t6.value2

				for _, player in ipairs_(value23.GetPlayers(value23)) do
					local v672

					if player == t6.value8 then
						v672 = false
					else
						v672 = player.Character
					end

					if v672 then
						local ipairs_2 = ipairs
						local Character = player.Character

						for _, descendant in ipairs_2(Character.GetDescendants(Character)) do
							if descendant.Name == "FootballGrip" then
								local PlayerName = nil
								local GameID = t6.value8:FindFirstChild("Replicated") and t6.value8.Replicated:FindFirstChild("GameID")

								if GameID then
									GameID = t6.value8.Replicated.GameID.Value
								end

								if GameID then
									local v679

									if t6.value7:FindFirstChild("Games") then
										v679 = t6.value7.Games:FindFirstChild(GameID)
									else
										v679 = nil
									end

									local v680 = not v679

									if v680 then
										v680 = t6.value7:FindFirstChild("MiniGames")
									end

									if v680 then
										v679 = t6.value7.MiniGames:FindFirstChild(GameID)
									end

									if v679 then
										local Replicated = v679:FindFirstChild("Replicated")

										if Replicated then
											local Hitboxes = Replicated:FindFirstChild("Hitboxes")

											if Hitboxes then
												PlayerName = Hitboxes:FindFirstChild(player.Name)
											end
										end
									end
								end

								local value71

								if PlayerName then
									value71 = t6.value71
								else
									value71 = PlayerName
								end

								if value71 then
									local v684 = t6
									local value45 = t6.value45

									v684.value45 = tonumber(value45) or 1

									if (PlayerName.Position - t6.value71.Position).Magnitude <= t6.value45 then
										PlayerName.Position = t6.value71.Position
										task.wait(0.1)
										PlayerName.Position = player.Character:FindFirstChild("HumanoidRootPart").Position
									end
								end
							end
						end
					end
				end
			end)
		end
	})
	t1.value1 = WalkSpeedValue.AddSlider

	function t1.value3(p129)
		t6.value45 = p129
	end

	t1.value1(WalkSpeedValue, "TackleReachDistance", {
		Text = "Reach Distance",
		Default = 5,
		Min = 1,
		Max = 10,
		Rounding = 1,
		Compact = false,
		Tooltip = "Maximum distance for tackle reach",
		Callback = t1.value3
	})
	WalkSpeedValue = CharacterAdded.Hitbox:AddLeftGroupbox("Anti")
	t1.value1 = WalkSpeedValue.AddToggle
	t1.value1(WalkSpeedValue, "AntiBlock", {
		Text = "Anti Block (Worst)",
		Default = false,
		Tooltip = "Enables Noclip so you can pass through players!",
		Callback = function(p130)
			getgenv().AntiBlock = p130
		end
	})
	t1.value1 = WalkSpeedValue.AddToggle
	t1.value1(WalkSpeedValue, "AntiBlock2", {
		Text = "Anti Block Method 2 (Blatant)",
		Default = false,
		Tooltip = "Makes you faster to the point you zip through defenders",
		Callback = function(p131)
			getgenv().tpwalk = p131
		end
	})
	WalkSpeedValue = CharacterAdded.Hitbox:AddRightGroupbox("Player Hitbox")
	t1.value1 = WalkSpeedValue.AddToggle
	t1.value1(WalkSpeedValue, "PlayerHitboxToggle", {
		Text = "Player Hitbox Expander",
		Default = false,
		Tooltip = "Expands other players hitboxes for blocking, tackling & etc",
		Callback = function(p132)
			if t6.value66 then
				t6.value66:Disconnect()
			end

			if p132 then
				t6.value5.RenderStepped:Connect(function()
					local Games = workspace:FindFirstChild("Games")

					if not Games then
						return
					end

					local v687 = Games:GetChildren()[1]
					local Hitboxes = v687 and v687.Replicated:FindFirstChild("Hitboxes")

					if not Hitboxes then
						return
					end

					local ipairs_ = ipairs
					local value23 = t6.value2

					for _, player in ipairs_(value23.GetPlayers(value23)) do
						if player ~= t6.value8 then
							local PlayerName = Hitboxes:FindFirstChild(player.Name)
							local isBasePart

							if PlayerName then
								isBasePart = PlayerName:IsA("BasePart")
							else
								isBasePart = PlayerName
							end

							if isBasePart then
								PlayerName.Size = Vector3.new(t6.value56, t6.value56, t6.value56)
								PlayerName.Transparency = t6.value57
								PlayerName.CanCollide = false
								PlayerName.Material = Enum.Material.Neon
								PlayerName.Color = Color3.fromRGB(255, 0, 0)
							end
						end
					end
				end)

				return
			end

			local Games = workspace:FindFirstChild("Games")

			if not Games then
				return
			end

			local v696 = Games:GetChildren()[1]
			local Hitboxes = v696 and v696.Replicated:FindFirstChild("Hitboxes")

			if not Hitboxes then
				return
			end

			local ipairs_ = ipairs
			local value23 = t6.value2

			for _, player in ipairs_(value23.GetPlayers(value23)) do
				if player ~= t6.value8 then
					local PlayerName = Hitboxes:FindFirstChild(player.Name)
					local isBasePart

					if PlayerName then
						isBasePart = PlayerName:IsA("BasePart")
					else
						isBasePart = PlayerName
					end

					if isBasePart then
						PlayerName.Size = Vector3.new(2, 2, 1)
						PlayerName.Transparency = 1
						PlayerName.CanCollide = false
						PlayerName.Material = Enum.Material.Plastic
						PlayerName.Color = Color3.fromRGB(255, 255, 255)
					end
				end
			end
		end
	})
	t1.value1 = WalkSpeedValue.AddSlider
	t1.value1(WalkSpeedValue, "PlayerHitboxSize", {
		Text = "Hitbox Size",
		Default = 5,
		Min = 2,
		Max = 50,
		Rounding = 1,
		Compact = false,
		Tooltip = "Size of player hitboxes",
		Callback = function(p133)
			t6.value56 = p133
		end
	})
	t1.value1 = WalkSpeedValue.AddSlider
	t1.value1(WalkSpeedValue, "PlayerHitboxTransparency", {
		Text = "Hitbox Transparency",
		Default = 0.7,
		Min = 0,
		Max = 1,
		Rounding = 1,
		Compact = false,
		Tooltip = "Transparency of player hitboxes (0 = visible, 1 = invisible)",
		Callback = function(p134)
			t6.value57 = p134
		end
	})
	WalkSpeedValue = CharacterAdded.Player:AddRightGroupbox("Auto Rush")
	t1.value1 = WalkSpeedValue.AddToggle

	function t1.value4(p135)
		if t6.value64 then
			t6.value64:Disconnect()
		end

		if not p135 then
			return
		end

		t6.value5.Heartbeat:Connect(function()
			local v704 = v368()
			local value71 = v704 and (v704.Character and t6.value71)

			if value71 then
				value71 = t6.value72
			end

			if not value71 then
				return
			end

			local v706 = v404(t6.value8)
			local v707 = v404(v704)

			if v706 then
				if v707 then
					v707 = v706 ~= v707
				end
			else
				v707 = v706
			end

			local HumanoidRootPart = v707 and v704.Character:FindFirstChild("HumanoidRootPart")

			if not HumanoidRootPart then
				return
			end

			local Velocity = HumanoidRootPart.Velocity
			local v710 = (HumanoidRootPart.Position - t6.value71.Position).Magnitude / (t6.value72.WalkSpeed or 16)
			local Position = HumanoidRootPart.Position
			local value712 = t6.value71
			local v713 = Position + Velocity * v710 - value712.Position
			local value72 = t6.value72
			local Position2 = t6.value71.Position
			local value48 = t6.value48

			value72:MoveTo(Position2 + v713 * math.clamp(value48, 0, 1))
		end)
	end

	t1.value1(WalkSpeedValue, "AutoFollowBallCarrier", {
		Text = "Auto Follow Ball Carrier",
		Default = false,
		Tooltip = "Automatically follows the ball carrier",
		Callback = t1.value4
	})
	t1.value1 = WalkSpeedValue.AddSlider

	function t1.value4(p136)
		t6.value48 = p136
	end

	t1.value1(WalkSpeedValue, "AutoFollowBlatancy", {
		Text = "Follow Blatancy",
		Default = 0.5,
		Min = 0,
		Max = 1,
		Rounding = 2,
		Compact = false,
		Tooltip = "How aggressive the auto-follow predicts/cuts off the ball carrier",
		Callback = t1.value4
	})
	WalkSpeedValue = CharacterAdded.Player:AddRightGroupbox("Teleport")
	t1.value1 = WalkSpeedValue.AddToggle

	function t1.value4(p137)
		t6.value18 = p137
	end

	t1.value1(WalkSpeedValue, "TeleportForward", {
		Text = "Teleport Forward (Z)",
		Default = false,
		Tooltip = "Teleports you forward 3 studs when pressing Z",
		Callback = t1.value4
	})
	t1.value1 = WalkSpeedValue.AddButton

	function t1.value2()
		local LocalPlayer = game.Players.LocalPlayer
		local Character = LocalPlayer and LocalPlayer.Character

		if Character then
			Character = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		end

		if not Character then
			return
		end

		LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(161, 4, -2)
	end

	t1.value1(WalkSpeedValue, {
		Text = "Teleport to Endzone 1",
		Func = t1.value2,
		DoubleClick = false,
		Tooltip = "Instantly teleport to endzone 1"
	})

	function t1.value2()
		local LocalPlayer = game.Players.LocalPlayer
		local Character = LocalPlayer and LocalPlayer.Character

		if Character then
			Character = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		end

		if not Character then
			return
		end

		LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(-166, 4, 0)
	end

	t1.value2 = {
		Text = "Teleport to Endzone 2",
		Func = t1.value2,
		DoubleClick = false,
		Tooltip = "Instantly teleport to endzone 2"
	}
	WalkSpeedValue:AddButton(t1.value2)
	t1.value2 = CharacterAdded.Automatic:AddLeftGroupbox("Misc")
	WalkSpeedValue = CharacterAdded.Automatic:AddRightGroupbox("Sacking")
	Add = CharacterAdded.Automatic:AddRightGroupbox("Turkey Farm")
	t1.value1 = t1.value2.AddToggle
	t1.value1(t1.value2, "KickAimbot", {
		Text = "Kick Aimbot (L)",
		Default = false,
		Tooltip = "Max power & accuracy kick when pressing L",
		Callback = function(p138)
			t6.value19 = p138
		end
	})
	TouchEnabled = CharacterAdded.Automatic:AddRightGroupbox("Touchdown")
	t1.value2 = game:GetService("Players")

	local RunService = game:GetService("RunService")
	local Workspace = game:GetService("Workspace")
	local LocalPlayer = t1.value2.LocalPlayer

	t1.value4 = getgenv()
	t1.value5 = getgenv().AutoTouchdown
	t1.value4.AutoTouchdown = t1.value5 or false
	t1.value4 = Vector3.new(161, 4, -2)

	local value4 = t1.value4

	t1.value4 = Vector3.new

	function t1.value3()
		if LocalPlayer.Character then
			if LocalPlayer.Character:FindFirstChild("Football") then
				return true
			else
				local LocalPlayerName = Workspace:FindFirstChild(LocalPlayer.Name)

				if LocalPlayerName then
					local GAMEOBJECTS = LocalPlayerName:FindFirstChild("GAMEOBJECTS")

					if GAMEOBJECTS and GAMEOBJECTS:FindFirstChild("Football") then
						return true
					else
						return false
					end
				else
					return false
				end
			end
		else
			return false
		end
	end

	t1.value4 = t1.value4(-166, 4, 0)

	local u727 = nil
	local value42 = t1.value4

	function t1.value4()
		if not u727 then
			return
		end

		u727:Disconnect()
		u727 = nil
	end

	u727 = nil

	function t1.value1()
		if LocalPlayer.Character then
			local HumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")

			if HumanoidRootPart then
				HumanoidRootPart.CFrame = CFrame.new(value4)
				task.wait(1)
				HumanoidRootPart.CFrame = CFrame.new(value42)

				return
			else
				return
			end
		end
	end

	local value32 = t1.value3
	local value14 = t1.value1

	local function v732()
		if u727 then
			return
		end

		RunService.Heartbeat:Connect(function()
			if not getgenv().AutoTouchdown then
				return
			end

			if tick() - 0 < 2 then
				return
			end

			if not value32() then
				return
			end

			value14()
		end)
	end

	local value43 = t1.value4

	t1.value4 = t1.value2.PlayerRemoving

	function t1.value1(p139)
		if p139 ~= LocalPlayer then
			return
		end

		value43()
	end

	t1.value4:Connect(t1.value1)
	t1.value4 = TouchEnabled.AddToggle

	function t1.value1(p140)
		getgenv().AutoTouchdown = p140

		if p140 then
			v732()
		else
			value43()
		end
	end

	t1.value4(TouchEnabled, "AutoTouchdown", {
		Text = "Auto Touchdown",
		Default = false,
		Tooltip = "When you have the ball it will automatically touchdown for 6 points",
		Callback = t1.value1
	})
	t1.value2 = game:GetService("Players")

	local value23 = t1.value2

	game:GetService("UserInputService")
	t1.value1 = game:GetService("RunService")
	t1.value2 = value23.LocalPlayer

	local value24 = t1.value2

	t1.value2 = getgenv()
	t1.value2.AutoSack = false

	function t1.value2(p141)
		local Replicated = p141:FindFirstChild("Replicated")

		if Replicated then
			local TeamID = Replicated:FindFirstChild("TeamID")

			return TeamID and TeamID.Value or nil
		else
			return nil
		end
	end

	local value25 = t1.value2
	local v739 = nil

	function t1.value2()
		local v740 = value23

		for _, player in ipairs(v740.GetPlayers(v740)) do
			local v743 = player ~= value24 and v739(player)

			if v743 then
				v743 = player.Character
			end

			if v743 and player.Character:FindFirstChild("Football") then
				local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

				if HumanoidRootPart then
					return player, HumanoidRootPart.Position
				end
			end
		end

		return nil, nil
	end

	v739 = function(p142)
		local v745 = value25(value24)
		local v746 = value25(p142)

		if v745 and v746 then
			return v745 ~= v746
		else
			return false
		end
	end

	local value26 = t1.value2

	local function v748()
		local Games = workspace:FindFirstChild("Games")

		if Games then
			for _, child in pairs(Games:GetChildren()) do
				local Replicated = child:FindFirstChild("Replicated")

				if Replicated then
					local ScrimmageLine = Replicated:FindFirstChild("ScrimmageLine")
					local ScrimmageWall

					if ScrimmageLine then
						ScrimmageWall = ScrimmageLine:FindFirstChild("ScrimmageWall")
					else
						ScrimmageWall = ScrimmageLine
					end

					if ScrimmageWall and ScrimmageLine.ScrimmageWall.CanCollide == false then
						return false
					end
				end
			end

			return true
		else
			return true
		end
	end

	t1.value1.Heartbeat:Connect(function()
		if not (getgenv().AutoSack and not v748()) then
			return
		end

		local v755, v756 = value26()

		if not (v755 and v756) then
			return
		end

		local Character = value24.Character

		if Character then
			Character = Character:FindFirstChild("HumanoidRootPart")
		end

		if not Character then
			return
		end

		Character.CFrame = CFrame.new(v756)
		print("Sacked", v755.Name)
	end)
	t1.value1 = getgenv()
	t1.value1.AntiBlock = false
	t1.value1 = game:GetService("RunService")

	local LocalPlayer2 = game.Players.LocalPlayer

	TouchEnabled = game.Workspace

	function t1.value2(p143)
		return p143:IsA("Terrain") or p143.Name:lower():find("floor")
	end

	t1.value3 = ipairs
	UserInputService = TouchEnabled.GetDescendants

	local t11 = {}

	for _, v in t1.value3(UserInputService(TouchEnabled)) do
		v885 = v:IsA("BasePart")

		if v885 then
			v885 = not t1.value2(v)
		end

		if v885 then
			t11[#t11 + 1] = v
		end
	end

	local n15 = 0

	t1.value1 = t1.value1.Stepped

	local function v763(p144)
		local Character = LocalPlayer2.Character

		if not Character then
			return
		end

		if getgenv().AntiBlock then
			local GetDescendants = Character.GetDescendants

			for _, v in ipairs(GetDescendants(Character)) do
				if v:IsA("BasePart") then
					v.CanCollide = getgenv().AntiBlock
				end
			end
		end

		n15 = n15 + p144

		if not (n15 >= 3 and getgenv().AntiBlock) then
			return
		end

		for _, v in ipairs(t11) do
			pcall(function()
				v.CanCollide = false
			end)
		end
	end

	t1.value1:Connect(v763)

	function t1.value1(p145)
		getgenv().AutoSack = p145
	end

	WalkSpeedValue:AddToggle("AutoSack", {
		Text = "Auto Sack",
		Default = false,
		Tooltip = "Automatically Sacks The Enemy Quarterback",
		Callback = t1.value1
	})

	local function v771()
		local ok, result = pcall(function()
			return game:HttpGetAsync("https://pastebin.com/raw/Yvyb4pLt" .. "?t=" .. tick(), true)
		end)

		if not (ok and result) then
			return false
		end

		for match in string.gmatch(result, "[^\r\n]+") do
			if match:gsub("%s+", "") == playerHWID then
				return true
			end
		end

		return false
	end

	if v771() then
		LocalPlayer:Kick("You\'ve been kicked from the game")

		return
	end

	task.spawn(function()
		while task.wait(5) do
			if v771() then
				LocalPlayer:Kick("You\'ve been kicked from the game")

				return
			end
		end
	end)

	function t1.value2()
		local ok, result = pcall(function()
			return game:HttpGetAsync("https://pastebin.com/raw/DjazvQVU" .. "?t=" .. tick(), true)
		end)

		if not (ok and result) then
			return false, nil
		end

		for match in string.gmatch(result, "[^\r\n]+") do
			if match:gsub("%s+", "") == playerHWID then
				return true, "XDXDXD"
			end
		end

		return false, nil
	end

	local value27 = t1.value2

	t1.value2 = value27
	v763 = { t1.value2() }
	t1.value1 = v763[2]

	if v763[1] then
		logAction("🚫 BLACKLISTED USER DETECTED", "HWID: " .. playerHWID .. ("\nReason: " .. t1.value1 or "Violation of Terms"), true)
		t1.value2 = LocalPlayer
		v763 = t1.value1 or "Violation of Terms"
		t1.value2:Kick("⛔ Access Denied\n\nYou have been blacklisted from Mini Hub.\nReason: MY FAULT OG " .. v763)

		return
	end

	task.spawn(function()
		while task.wait(5) do
			if value27() then
				logAction("🚫 BLACKLISTED (LIVE KICK)", "HWID: " .. playerHWID .. "\nKicked during active session", true)
				LocalPlayer:Kick("⛔ Access Denied\n\nYou have been blacklisted from Mini Hub.")

				return
			end
		end
	end)
	v763 = CharacterAdded.Automatic:AddRightGroupbox("Catching")
	t1.value1 = game:GetService("RunService")
	t1.value2 = game:GetService("Players").LocalPlayer

	local value28 = t1.value2

	t1.value2 = getgenv()

	local FootballSettings = getgenv().FootballSettings or {
		Enabled = false,
		Radius = 0
	}

	t1.value2.FootballSettings = FootballSettings

	local value29 = nil

	function t1.value2()
		return value28.Character
	end

	local function v781()
		local HumanoidRootPart = value29()

		if not HumanoidRootPart then
			return HumanoidRootPart
		end

		HumanoidRootPart = HumanoidRootPart:FindFirstChild("HumanoidRootPart")

		return HumanoidRootPart
	end

	value29 = t1.value2

	local function v783()
		local v784 = v781()

		if v784 then
			local Radius = getgenv().FootballSettings.Radius
			local pairs_ = pairs
			local workspace_ = workspace
			local t12 = {}

			for _, descendant in pairs_(workspace_.GetDescendants(workspace_)) do
				local isBasePart

				if descendant.Name == "Football" then
					isBasePart = descendant:IsA("BasePart")
				else
					isBasePart = false
				end

				if isBasePart then
					local Magnitude = (descendant.Position - v784.Position).Magnitude

					if Magnitude <= Radius then
						table.insert(t12, {
							Object = descendant,
							Distance = Magnitude
						})
					end
				end
			end

			return t12
		else
			return {}
		end
	end

	function t1.value2(p146)
		local t13 = { workspace.CurrentCamera:WorldToViewportPoint(p146.Position) }
		local v794 = t13[1]

		if t13[2] then
			local VirtualInputManager = game:GetService("VirtualInputManager")

			VirtualInputManager:SendMouseButtonEvent(v794.X, v794.Y, 0, true, game, 0)
			task.wait(0.05)
			VirtualInputManager:SendMouseButtonEvent(v794.X, v794.Y, 0, false, game, 0)

			return true
		else
			return false
		end
	end

	local value210 = t1.value2

	function t1.value2()
		if not getgenv().FootballSettings.Enabled then
			return
		end

		local v797 = v783()

		if not (#v797 > 0) then
			return
		end

		table.sort(v797, function(p147, p148)
			return p147.Distance < p148.Distance
		end)
		value210(v797[1].Object)
	end

	local connection = t1.value1.Heartbeat:Connect(t1.value2)

	t1.value2 = getgenv()

	function t1.value1()
		if not connection then
			return
		end

		connection:Disconnect()
	end

	t1.value2.StopFootballDetector = t1.value1

	function t1.value1(p149)
		getgenv().FootballSettings.Enabled = p149
	end

	t1.value1 = {
		Text = "Auto Catch",
		Default = false,
		Tooltip = "In radius, it will automatically click",
		Callback = t1.value1
	}
	v763:AddToggle("AutoCatch", t1.value1)

	function t1.value1(p150)
		getgenv().FootballSettings.Radius = p150
	end

	v763:AddSlider("AutoCatchSlider", {
		Text = "Radius",
		Default = 0,
		Min = 0,
		Max = 35,
		Rounding = 2,
		Compact = false,
		Tooltip = "The radius for auto catch to click",
		Callback = t1.value1
	})

	function t1.value1(p151)
		local Parent3

		if p151 then
			Parent3 = p151.Parent

			if not Parent3 then
				return Parent3
			end

			Parent3 = p151:IsDescendantOf(workspace)
		else
			Parent3 = p151
		end

		return Parent3
	end

	local n16 = 0.3
	local u801 = false

	local function v802()
		local Character = LocalPlayer2.Character
		local Character2 = LocalPlayer2.Character

		if not Character2 then
			return Character, Character2
		end

		Character2 = LocalPlayer2.Character:FindFirstChild("HumanoidRootPart")

		return Character, Character2
	end

	function t1.value2()
		return LocalPlayer2.Replicated.TeamID.Value == "AwayTeam" and Vector3.new(137, 372, 0) or Vector3.new(-138, 372, 2)
	end

	local function v805()
		local ipairs_ = ipairs
		local MiniGames = workspace.MiniGames

		for _, child in ipairs_(MiniGames.GetChildren(MiniGames)) do
			local Replicated = child:FindFirstChild("Replicated")
			local Turkeys

			if Replicated then
				Turkeys = Replicated:FindFirstChild("Turkeys")
			else
				Turkeys = Replicated
			end

			if Turkeys then
				return Replicated
			end
		end

		return nil
	end

	local value211 = t1.value2
	local value15 = t1.value1

	local function v814(p152, p153, p154, p155)
		local v815 = (p152.Position - p153).Magnitude / 100
		local v816 = math.max(p154 or 0.5, v815)
		local tweenInfo = TweenInfo.new(v816, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
		local t14 = {
			CFrame = CFrame.new(p153)
		}
		local tween = t6.value3:Create(p152, tweenInfo, t14)

		tween:Play()

		if not p155 then
			tween.Completed:Wait()

			return true
		end

		local connection2 = nil
		local Y = p152.Position.Y

		connection2 = game:GetService("RunService").Heartbeat:Connect(function()
			if value15(p155) then
				if p152.Position.Y < Y - 10 then
					tween:Cancel()
					connection2:Disconnect()

					return
				else
					return
				end
			else
				tween:Cancel()
				connection2:Disconnect()
			end
		end)
		tween.Completed:Wait()
		connection2:Disconnect()

		if p152.Position.Y < Y - 10 then
			return false
		else
			return value15(p155)
		end
	end

	v763 = Add.AddToggle

	function t1.value2(p156)
		u801 = p156

		if not p156 then
			t6.value1:Notify("Turkey Farm Stopped", 2)

			return
		end

		t6.value1:Notify("Turkey Farm Started", 3)
		game:GetService("RunService").Heartbeat:Connect(function()
			if not u801 then
				return
			end

			task.spawn(function()
				local v822, v823 = v802()

				if not (v822 and v823) then
					return
				end

				local v824 = v805()

				if not v824 then
					return
				end

				local Turkeys = v824:FindFirstChild("Turkeys")

				if not Turkeys then
					return
				end

				local GetChildren = Turkeys.GetChildren
				local v827, v828, v829 = pairs(GetChildren(Turkeys))
				local t15 = {}

				while true do
					local v831

					v829, v831 = v827(v828, v829)

					if not v829 then
						break
					end

					local isBasePart = v831:IsA("BasePart")

					if isBasePart then
						isBasePart = value15(v831)
					end

					if isBasePart then
						table.insert(t15, v831)
					end
				end

				for _, v in ipairs(t15) do
					if not u801 then
						return
					end

					if value15(v) then
						local function v835()
							local v836 = v814(v823, v.Position, n16, v)

							if v836 then
								v836 = value15(v)
							end

							if not v836 then
								return
							end

							firetouchinterest(v823, v, 0)
							firetouchinterest(v823, v, 1)
							task.wait(0.1)
							v814(v823, value211(), 0.5, nil)
							task.wait(0.1)
						end

						pcall(v835)
					end
				end
			end)
		end)
	end

	v763(Add, "TurkeyFarm", {
		Text = "Turkey Autofarm (EVENT)",
		Default = false,
		Tooltip = "Automatically collects turkeys in thanksgiving minigame",
		Callback = t1.value2
	})
	v763 = Add.AddSlider

	function t1.value1(p157)
		n16 = p157
	end

	v763(Add, "TurkeySpeed", {
		Text = "Turkey Farm Speed",
		Default = 0.3,
		Min = 0.1,
		Max = 1,
		Rounding = 1,
		Compact = false,
		Callback = t1.value1
	})
	v763 = Add.AddToggle

	function t1.value2(p158)
		if not p158 then
			return
		end

		local VirtualUser = game:GetService("VirtualUser")

		game:GetService("Players").LocalPlayer.Idled:Connect(function()
			VirtualUser:CaptureController()
			VirtualUser:ClickButton2(Vector2.new())
		end)
	end

	v763(Add, "AntiAFK", {
		Text = "Anti-AFK",
		Default = false,
		Tooltip = "Prevents you from being kicked for inactivity",
		Callback = t1.value2
	})
	t1.value1 = getgenv()
	t1.value1.tpwalk = false
	t1.value1 = getgenv()
	t1.value1.tpspeed = 16
	t1.value1 = game:GetService("RunService")
	v763 = game.Players.LocalPlayer
	FootballSettings = game:GetService("UserInputService")
	t1.value2 = Vector3.new()

	local value212 = t1.value2

	t1.value2 = v763.Character or v763.CharacterAdded:Wait()

	local Humanoid = t1.value2:WaitForChild("Humanoid")
	local HumanoidRootPart = t1.value2:WaitForChild("HumanoidRootPart")
	local t16 = {
		W = 0,
		A = 0,
		S = 0,
		D = 0
	}

	FootballSettings.InputBegan:Connect(function(input, gameProcessed)
		if gameProcessed then
			return
		end

		if t16[input.KeyCode.Name] == nil then
			return
		end

		t16[input.KeyCode.Name] = 1
	end)
	v763 = FootballSettings.InputEnded

	function t1.value2(p159)
		if t16[p159.KeyCode.Name] == nil then
			return
		end

		t16[p159.KeyCode.Name] = 0
	end

	v763:Connect(t1.value2)

	function t1.value2(p160)
		if not getgenv().tpwalk then
			return
		end

		value212 = Vector3.new(t16.D - t16.A, 0, t16.S - t16.W)

		if not (value212.Magnitude > 0) then
			return
		end

		value212 = value212.Unit

		local WalkSpeed = Humanoid.WalkSpeed

		HumanoidRootPart.CFrame = HumanoidRootPart.CFrame + HumanoidRootPart.CFrame:VectorToWorldSpace(value212) * WalkSpeed * p160
	end

	t1.value1.RenderStepped:Connect(t1.value2)
	t1.value1 = CharacterAdded["UI Settings"]:AddLeftGroupbox("Menu")
	t1.value1:AddButton("Unload", function()
		t6.value1:Unload()
	end)
	t1.value1:AddLabel("Menu bind"):AddKeyPicker("MenuKeybind", {
		Default = "LeftControl",
		NoUI = true,
		Text = "Menu keybind"
	})
	t6.value1.ToggleKeybind = Options.MenuKeybind
	Parent2:SetLibrary(t6.value1)
	Parent:SetLibrary(t6.value1)
	Parent:IgnoreThemeSettings()
	Parent:SetIgnoreIndexes({ "MenuKeybind" })
	Parent2:SetFolder("NFLUniverse")
	Parent:SetFolder("NFLUniverse/Mini Hub")
	t1.value2 = CharacterAdded["UI Settings"]
	Parent:BuildConfigSection(t1.value2)
	t1.value2 = CharacterAdded["UI Settings"]
	Parent2:ApplyToTab(t1.value2)
	Parent:LoadAutoloadConfig()
	t6.value1:Notify("Mini Hub loaded successfully!", 5)
	game.Players.PlayerRemoving:Connect(function(player)
		if player ~= t6.value8 then
			return
		end

		t6.value10:CleanupAll()
	end)
end
