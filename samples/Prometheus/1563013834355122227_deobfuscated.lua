-- This file was generated at discord.gg/syncrypt

getgenv().Webhook = getgenv().Webhook or (getgenv().Webhoob or "")
_G.AutoFarmEnabled = true
_G.RunningSpeedrun = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local LocalPlayer = Players.LocalPlayer

if #Players:GetPlayers() > 1 then
	LocalPlayer:Kick("join a private server to use currency farm")

	return
end

Players.PlayerAdded:Connect(function(player)
	if player == LocalPlayer then
		return
	end

	LocalPlayer:Kick("join a private server to use currency farm")
end)

local v7 = LocalPlayer.WaitForChild(LocalPlayer, "PlayerGui")
local MainMenu = v7:WaitForChild("MainMenu")
local v9 = MainMenu.WaitForChild(MainMenu, "Title")

v9.WaitForChild(v9, "SettingsMenu"):WaitForChild("SettingsRemote"):InvokeServer("UpdateInfo", {
	StreamerMode = false,
	RandomTrap = false,
	HardMode = true,
	Graphics = false,
	RandomAbility = false,
	ColorMode = false,
	Friendly = true,
	RandomSkin = false
})

local Currency = LocalPlayer.WaitForChild(LocalPlayer, "Data"):WaitForChild("PlayerData"):WaitForChild("Currency")
local now = os.time()
local now2 = os.time()
local Value = Currency.Value
local n1 = 0
local state = "Initializing..."
local v16 = nil

local function v17(p1, p2, p3, p4, p5, p6)
	if not getgenv().Webhook or getgenv().Webhook == "" then
		return
	end

	local v18 = v16(p1)
	local v19 = v16(p3)
	local t1 = {
		username = "NothingHub",
		embeds = {
			{
				author = {
					name = "NothingHub | Piggy",
					icon_url = "https://z-cdn-media.chatglm.cn/files/b4ac2d62-5f96-431a-8345-0117ba0343da.jpg?auth_key=1891314854-04e8ca2605bd4b18983898541e8f07d8-0-bd47587aa7594fca9204703f0dcbc2b3"
				},
				title = "Result",
				color = 0,
				fields = {
					{
						name = "[Carnaval] - Win",
						value = "• Time : " .. v18 .. "\n• Reward:\n+ " .. tostring(p2) .. " Currency",
						inline = false
					},
					{
						name = "Session",
						value = "• Session time : " .. v19 .. "\n• Game played: " .. tostring(p4) .. "\n• Total Currency Won : " .. tostring(p5) .. "\n• Total Currency : " .. tostring(p6),
						inline = false
					}
				},
				thumbnail = {
					url = "https://z-cdn-media.chatglm.cn/files/b4ac2d62-5f96-431a-8345-0117ba0343da.jpg?auth_key=1891314854-04e8ca2605bd4b18983898541e8f07d8-0-bd47587aa7594fca9204703f0dcbc2b3"
				},
				footer = {
					text = "NothingHub • discord.gg/DQkbxAXxxU • " .. os.date("%I:%M %p", os.time()):gsub("^0", "") .. " • " .. os.date("%m/%d/%Y", os.time())
				}
			}
		}
	}

	local function v21()
		request({
			Url = getgenv().Webhook,
			Method = "POST",
			Headers = {
				["Content-Type"] = "application/json"
			},
			Body = HttpService:JSONEncode(t1)
		})
	end

	pcall(v21)
end
local function v22(p7)
	state = p7
end

v16 = function(p8)
	local v23 = p8 / 60
	local v24 = math.floor(v23)
	local v25 = p8 % 60

	return string.format("%dm %ds", v24, v25)
end

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "NothingHubUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
pcall(function()
	ScreenGui.Parent = CoreGui
end)

if not ScreenGui.Parent then
	ScreenGui.Parent = v7
end

local function v27(p9, p10)
	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, p10 or 6)
	UICorner.Parent = p9
end

local Frame = Instance.new("Frame")

Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.BackgroundColor3 = Color3.new(0, 0, 0)
Frame.Visible = true
Frame.ZIndex = 1
Frame.Parent = ScreenGui

local TextButton = Instance.new("TextButton")

TextButton.Size = UDim2.new(0, 250, 0, 35)
TextButton.Position = UDim2.new(0.5, -125, 0, 10)
TextButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TextButton.TextColor3 = Color3.new(1, 1, 1)
TextButton.Font = Enum.Font.GothamBold
TextButton.TextSize = 14
TextButton.Text = "Hide Black Screen"
TextButton.ZIndex = 10
TextButton.Parent = ScreenGui
v27(TextButton, 6)

local Frame2 = Instance.new("Frame")

Frame2.Name = "Main"
Frame2.Size = UDim2.new(0, 320, 0, 360)
Frame2.Position = UDim2.new(0.5, -160, 0.5, -180)
Frame2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Frame2.BorderSizePixel = 0
Frame2.Active = true
Frame2.Draggable = true
Frame2.ZIndex = 2
Frame2.Parent = ScreenGui
v27(Frame2, 8)

local TextLabel = Instance.new("TextLabel")

TextLabel.BackgroundTransparency = 1
TextLabel.Size = UDim2.new(1, -20, 0, 30)
TextLabel.Position = UDim2.new(0, 10, 0, 5)
TextLabel.Text = "NothingHub | Piggy Auto Farm"
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 16
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.ZIndex = 3
TextLabel.Parent = Frame2

local TextLabel2 = Instance.new("TextLabel")

TextLabel2.BackgroundTransparency = 1
TextLabel2.Size = UDim2.new(1, -20, 0, 20)
TextLabel2.Position = UDim2.new(0, 10, 0, 25)
TextLabel2.Text = "Carnival Server Farm"
TextLabel2.TextColor3 = Color3.fromRGB(150, 150, 150)
TextLabel2.Font = Enum.Font.Gotham
TextLabel2.TextSize = 12
TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
TextLabel2.ZIndex = 3
TextLabel2.Parent = Frame2

local Frame3 = Instance.new("Frame")

Frame3.Size = UDim2.new(1, -20, 0, 1)
Frame3.Position = UDim2.new(0, 10, 0, 50)
Frame3.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame3.BorderSizePixel = 0
Frame3.ZIndex = 3
Frame3.Parent = Frame2

local TextLabel3 = Instance.new("TextLabel")

TextLabel3.BackgroundTransparency = 1
TextLabel3.Size = UDim2.new(1, -20, 0, 25)
TextLabel3.Position = UDim2.new(0, 10, 0, 55)
TextLabel3.Text = "State: " .. state
TextLabel3.TextColor3 = Color3.fromRGB(255, 255, 0)
TextLabel3.Font = Enum.Font.Gotham
TextLabel3.TextSize = 14
TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
TextLabel3.ZIndex = 3
TextLabel3.Parent = Frame2

local Frame4 = Instance.new("Frame")

Frame4.BackgroundTransparency = 1
Frame4.Size = UDim2.new(1, -20, 0, 140)
Frame4.Position = UDim2.new(0, 10, 0, 85)
Frame4.ZIndex = 3
Frame4.Parent = Frame2

local UIListLayout = Instance.new("UIListLayout")

UIListLayout.Padding = UDim.new(0, 5)
UIListLayout.Parent = Frame4

local function createTextLabel(p11)
	local Frame5 = Instance.new("Frame")

	Frame5.BackgroundTransparency = 1
	Frame5.Size = UDim2.new(1, 0, 0, 20)
	Frame5.ZIndex = 3

	local TextLabel4 = Instance.new("TextLabel")

	TextLabel4.BackgroundTransparency = 1
	TextLabel4.Size = UDim2.new(0.6, 0, 1, 0)
	TextLabel4.Text = p11
	TextLabel4.TextColor3 = Color3.fromRGB(200, 200, 200)
	TextLabel4.Font = Enum.Font.Gotham
	TextLabel4.TextSize = 14
	TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel4.ZIndex = 3
	TextLabel4.Parent = Frame5

	local TextLabel5 = Instance.new("TextLabel")

	TextLabel5.BackgroundTransparency = 1
	TextLabel5.Size = UDim2.new(0.4, 0, 1, 0)
	TextLabel5.Position = UDim2.new(0.6, 0, 0, 0)
	TextLabel5.Text = "0"
	TextLabel5.TextColor3 = Color3.new(1, 1, 1)
	TextLabel5.Font = Enum.Font.GothamBold
	TextLabel5.TextSize = 14
	TextLabel5.TextXAlignment = Enum.TextXAlignment.Right
	TextLabel5.ZIndex = 3
	TextLabel5.Parent = Frame5
	Frame5.Parent = Frame4

	return TextLabel5
end

local lastRunTime = createTextLabel("Last Run Time")
local lastRunGain = createTextLabel("Last Run Gain")
local sessionTime = createTextLabel("Session Time")
local gamesPlayed = createTextLabel("Games Played")
local totalCurrencyWon = createTextLabel("Total Currency Won")
local totalCurrency = createTextLabel("Total Currency")
local Frame5 = Instance.new("Frame")

Frame5.Size = UDim2.new(1, -20, 0, 1)
Frame5.Position = UDim2.new(0, 10, 0, 235)
Frame5.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
Frame5.BorderSizePixel = 0
Frame5.ZIndex = 3
Frame5.Parent = Frame2

local TextLabel4 = Instance.new("TextLabel")

TextLabel4.BackgroundTransparency = 1
TextLabel4.Size = UDim2.new(1, -20, 0, 20)
TextLabel4.Position = UDim2.new(0, 10, 0, 240)
TextLabel4.Text = "Discord Webhook"
TextLabel4.TextColor3 = Color3.fromRGB(150, 150, 150)
TextLabel4.Font = Enum.Font.Gotham
TextLabel4.TextSize = 12
TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
TextLabel4.ZIndex = 3
TextLabel4.Parent = Frame2

local TextBox = Instance.new("TextBox")

TextBox.Size = UDim2.new(1, -20, 0, 30)
TextBox.Position = UDim2.new(0, 10, 0, 260)
TextBox.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
TextBox.TextColor3 = Color3.new(1, 1, 1)
TextBox.Font = Enum.Font.Gotham
TextBox.TextSize = 12
TextBox.PlaceholderText = "Enter Webhook URL"
TextBox.Text = getgenv().Webhook or ""
TextBox.TextXAlignment = Enum.TextXAlignment.Left
TextBox.ClearTextOnFocus = false
TextBox.ZIndex = 3
TextBox.Parent = Frame2
v27(TextBox, 4)

local TextButton2 = Instance.new("TextButton")

TextButton2.Size = UDim2.new(0, 140, 0, 30)
TextButton2.Position = UDim2.new(0, 10, 0, 295)
TextButton2.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
TextButton2.TextColor3 = Color3.new(1, 1, 1)
TextButton2.Font = Enum.Font.Gotham
TextButton2.TextSize = 14
TextButton2.Text = "Stop Farm"
TextButton2.ZIndex = 3
TextButton2.Parent = Frame2
v27(TextButton2, 4)

local TextButton3 = Instance.new("TextButton")

TextButton3.Size = UDim2.new(0, 140, 0, 30)
TextButton3.Position = UDim2.new(1, -150, 0, 295)
TextButton3.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
TextButton3.TextColor3 = Color3.new(1, 1, 1)
TextButton3.Font = Enum.Font.Gotham
TextButton3.TextSize = 14
TextButton3.Text = "Test Webhook"
TextButton3.ZIndex = 3
TextButton3.Parent = Frame2
v27(TextButton3, 4)
TextButton.MouseButton1Click:Connect(function()
	Frame.Visible = not Frame.Visible

	if Frame.Visible then
		TextButton.Text = "Hide Black Screen"
	else
		TextButton.Text = "Show Black Screen"
	end
end)
TextBox.FocusLost:Connect(function()
	getgenv().Webhook = TextBox.Text
end)
TextButton3.MouseButton1Click:Connect(function()
	getgenv().Webhook = TextBox.Text
	v22("Sending Test Webhook...")
	v17(0, 0, 0, 0, 0, Currency.Value)
end)
TextButton2.MouseButton1Click:Connect(function()
	if _G.AutoFarmEnabled then
		_G.AutoFarmEnabled = false
		TextButton2.Text = "Start Farm"
		TextButton2.BackgroundColor3 = Color3.fromRGB(40, 150, 40)
		v22("Farm Stopped")
	else
		_G.AutoFarmEnabled = true
		TextButton2.Text = "Stop Farm"
		TextButton2.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
		v22("Resuming Farm...")
		task.spawn(runMainLoop)
	end
end)
task.spawn(function()
	while task.wait(0.5) and ScreenGui.Parent do
		local v53 = os.time() - now
		local Value2 = Currency.Value
		local v55 = Value2 - Value

		TextLabel3.Text = "State: " .. state
		lastRunTime.Text = "0m 0s"
		lastRunGain.Text = "+0"
		sessionTime.Text = v16(v53)

		local v56 = n1

		gamesPlayed.Text = tostring(v56)
		totalCurrencyWon.Text = tostring(v55)
		totalCurrency.Text = tostring(Value2)
	end
end)

if not _G.NoclipConnection then
	_G.NoclipConnection = RunService.Stepped:Connect(function()
		local AutoFarmEnabled = _G.AutoFarmEnabled

		if AutoFarmEnabled then
			AutoFarmEnabled = LocalPlayer.Character
		end

		if not AutoFarmEnabled then
			return
		end

		local ipairs_ = ipairs
		local Character = LocalPlayer.Character

		for _, descendant in ipairs_(Character.GetDescendants(Character)) do
			local isBasePart = descendant:IsA("BasePart")

			if isBasePart then
				isBasePart = descendant.CanCollide
			end

			if isBasePart then
				descendant.CanCollide = false
			end
		end
	end)
end

local function v63(p12)
	if not p12 then
		return
	end

	local HumanoidRootPart = p12:FindFirstChild("HumanoidRootPart")

	if not HumanoidRootPart then
		return
	end

	if not HumanoidRootPart:FindFirstChild("FlyVelocity") then
		local BodyVelocity = Instance.new("BodyVelocity")

		BodyVelocity.Name = "FlyVelocity"
		BodyVelocity.MaxForce = Vector3.new(1000000000, 1000000000, 1000000000)
		BodyVelocity.Velocity = Vector3.new(0, 0, 0)
		BodyVelocity.Parent = HumanoidRootPart
	end

	if HumanoidRootPart:FindFirstChild("FlyGyro") then
		return
	end

	local BodyGyro = Instance.new("BodyGyro")

	BodyGyro.Name = "FlyGyro"
	BodyGyro.MaxTorque = Vector3.new(1000000000, 1000000000, 1000000000)
	BodyGyro.CFrame = HumanoidRootPart.CFrame
	BodyGyro.Parent = HumanoidRootPart
end

LocalPlayer.CharacterAdded:Connect(function(character)
	task.wait(1)

	if not _G.AutoFarmEnabled then
		return
	end

	v63(character)
end)

if LocalPlayer.Character then
	v63(LocalPlayer.Character)
end

local v67 = nil

local function v68()
	local n2 = 0

	while true do
		local v70 = n2 < 3

		if v70 then
			v70 = _G.AutoFarmEnabled
		end

		if not v70 then
			return
		end

		local v71 = n2 + 1

		v22("Deleting Piggy Bot & Foxy...")

		local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
		local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
		local Humanoid = Character:WaitForChild("Humanoid")

		v63(Character)

		local Remotes = ReplicatedStorage:FindFirstChild("Remotes")

		if Remotes then
			Remotes = Remotes:FindFirstChild("DoorInteract_Event")
		end

		local function v76(p13)
			if p13 then
				local children = LocalPlayer.Backpack:GetChildren()

				for _, child in ipairs(children) do
					local isTool = child:IsA("Tool")

					if isTool then
						isTool = string.find(string.lower(child.Name), string.lower(p13))
					end

					if isTool then
						Humanoid:EquipTool(child)
						task.wait(0.3)

						return child
					end
				end
			end

			local children = LocalPlayer.Backpack:GetChildren()
			local v82, v83, v84 = ipairs(children)
			local t2 = {
				"wrench",
				"mallet",
				"hammer",
				"white",
				"water"
			}

			while true do
				local v86

				v84, v86 = v82(v83, v84)

				if v84 then
				elseif #children > 0 then
					Humanoid:EquipTool(children[1])
					task.wait(0.3)

					return children[1]
				else
					for _, child in ipairs(Character:GetChildren()) do
						if child:IsA("Tool") then
							return child
						end
					end

					return nil
				end

				if v86:IsA("Tool") then
					local v89 = string.lower(v86.Name)
					local v90, v91, v92 = ipairs(t2)
					local v93 = false

					while true do
						local v94

						v92, v94 = v90(v91, v92)

						if not v92 then
							break
						end

						if string.find(v89, v94) then
							v93 = true

							break
						end
					end

					if not v93 then
						Humanoid:EquipTool(v86)
						task.wait(0.3)

						return v86
					end
				end
			end
		end
		local function v95(p14, p15, p16)
			local ipairs_ = ipairs
			local workspace_ = workspace
			local v98 = p15 or 4.5

			for _, descendant in ipairs_(workspace_.GetDescendants(workspace_)) do
				local isClickDetector = descendant:IsA("ClickDetector")

				if isClickDetector then
					isClickDetector = descendant.Parent

					if isClickDetector then
						isClickDetector = descendant.Parent:IsA("BasePart")
					end
				end

				if isClickDetector and (descendant.Parent.Position - p14).Magnitude <= v98 then
					if not p16 then
						return descendant, descendant.Parent
					end

					local v102 = string.lower(descendant.Parent.Name)
					local Parent = descendant.Parent.Parent

					if Parent then
						Parent = string.lower(descendant.Parent.Parent.Name)
					end

					if string.find(v102, string.lower(p16)) or string.find(Parent or "", string.lower(p16)) then
						return descendant, descendant.Parent
					end
				end
			end

			return nil, nil
		end
		local function v104(p17, p18)
			local ipairs_ = ipairs
			local v106, v107, v108 = ipairs_(workspace:GetDescendants())
			local v109 = nil
			local v110 = nil

			while true do
				local v111

				v108, v111 = v106(v107, v108)

				if not v108 then
					v131 = v110
					v129 = v109

					if v129 and v131 then
						HumanoidRootPart.CFrame = v129.CFrame + Vector3.new(0, 2, 0)
						task.wait(0.3)
						fireclickdetector(v131)
						task.wait(0.5)

						return true
					else
						return false
					end
				end

				local MeshId = v111.IsA(v111, "MeshPart")

				if MeshId then
					MeshId = v111.MeshId
				end

				if not MeshId then
					local isSpecialMesh = v111:IsA("SpecialMesh")

					if isSpecialMesh then
						isSpecialMesh = v111.MeshId
					end

					MeshId = isSpecialMesh or ""
				end

				local v114 = MeshId ~= ""

				if v114 then
					v114 = string.find(MeshId, p17)
				end

				if not v114 then
					continue
				end

				local isBasePart = v111:IsA("BasePart") and v111

				if not isBasePart then
					isBasePart = v111.IsA(v111, "SpecialMesh")

					if isBasePart then
						isBasePart = v111.Parent
					end
				end

				if not isBasePart then
					continue
				end

				if p18 then
					local v116 = isBasePart.BrickColor.Name == "Institutional white"

					if not v116 then
						v116 = isBasePart.Color.R > 0.9

						if v116 then
							v116 = isBasePart.Color.G > 0.9

							if v116 then
								v116 = isBasePart.Color.B > 0.9
							end
						end
					end

					if not v116 then
						continue
					end
				end

				local ClickDetector = isBasePart:FindFirstChildOfClass("ClickDetector")

				if not ClickDetector then
					ClickDetector = isBasePart.Parent

					if ClickDetector then
						ClickDetector = isBasePart.Parent:FindFirstChildOfClass("ClickDetector")
					end
				end

				local v118

				if ClickDetector then
					v118 = ClickDetector.MaxActivationDistance > 0
				else
					v118 = ClickDetector
				end

				if v118 then
					if isBasePart and ClickDetector then
						HumanoidRootPart.CFrame = isBasePart.CFrame + Vector3.new(0, 2, 0)
						task.wait(0.3)
						fireclickdetector(ClickDetector)
						task.wait(0.5)

						return true
					else
						return false
					end
				end

				continue
			end
		end
		local function v119(p19, _, p20, p21)
			v76(p20)

			local v120, v121 = v95(p19, 4.5, p21)

			if not (v120 and v121) then
				v120, v121 = v95(p19, 4.5)
			end

			if not (v120 and v121) then
				return false
			end

			HumanoidRootPart.CFrame = v121.CFrame + Vector3.new(0, 2, 0)
			task.wait(0.3)
			v76(p20)
			fireclickdetector(v120)

			if not Remotes then
				task.wait(0.6)

				return true
			end

			Remotes:FireServer(v121)
			task.wait(0.6)

			return true
		end

		local PiggyNPC = workspace:FindFirstChild("PiggyNPC")

		if PiggyNPC then
			PiggyNPC:Destroy()
		end

		local ipairs_ = ipairs
		local workspace_ = workspace
		local v125, v126, v127 = ipairs_(workspace_.GetDescendants(workspace_))

		n2 = v71

		while true do
			local v128

			v127, v128 = v125(v126, v127)

			if not v127 then
				break
			end

			local Parent

			if v128.Name == "FoxyHead" then
				Parent = v128.Parent
			else
				Parent = false
			end

			if Parent then
				v128.Parent:Destroy()
			end
		end

		v22("Picking up Wrench...")

		if v104("16884681", false) then
			v22("Using Wrench Mechanism...")
			v119(Vector3.new(-386.971, 79.55, 443.504), "Wrench Mechanism", "Wrench")
		end

		v22("Picking up Mallet...")

		if v104("120607730", false) then
			v22("Playing Strength Game (Mallet)...")
			v119(Vector3.new(-470.3, 78.605, 438.712), "Mallet Strength Game", "Mallet")
			task.wait(0.5)
		end

		v22("Picking up Hammer...")

		if v104("16198309", false) then
			v22("Removing Wood Planks...")

			local vector3 = Vector3.new(-386.27, 79, 450.9)
			local ipairs_2 = ipairs
			local workspace_2 = workspace

			for _, descendant in ipairs_2(workspace_2.GetDescendants(workspace_2)) do
				local isClickDetector = descendant:IsA("ClickDetector")

				if isClickDetector then
					isClickDetector = descendant.Parent

					if isClickDetector then
						isClickDetector = descendant.Parent:IsA("BasePart")
					end
				end

				if isClickDetector then
					local Parent = descendant.Parent

					if (Parent.Material == Enum.Material.WoodPlanks or (Parent.Material == Enum.Material.Wood or Parent.BrickColor.Name == "Dark orange")) and (Parent.Position - vector3).Magnitude < 5 then
						HumanoidRootPart.CFrame = Parent.CFrame + Vector3.new(0, 2, 0)
						task.wait(0.3)
						v76("Hammer")
						fireclickdetector(descendant)

						if Remotes then
							Remotes:FireServer(Parent)
						end

						task.wait(0.6)
					end
				end
			end
		end

		v22("Picking up White Key...")

		if v104("456878024", true) then
			v22("Unlocking White Key Lock...")
			v119(Vector3.new(-385.757, 79.276, 450.948), "WhiteKey Lock", "White", "lock")
		end

		v22("Picking up WaterGun...")

		local v137, v138 = v95(Vector3.new(-515.25, 74.87, 326.86), 5, "water")

		if v137 and v138 then
			HumanoidRootPart.CFrame = v138.CFrame + Vector3.new(0, 2, 0)
			task.wait(0.3)
			fireclickdetector(v137)
			task.wait(0.5)
		else
			v104("1771168429", false)
		end

		v22("Shooting Target (WaterGun)...")
		v119(Vector3.new(-515, 78.605, 322.213), "WaterGun Stand Target", "Water", "target")
		task.wait(1.5)
		v22("Searching for KeyCode (0000)...")

		local v139, v140, v141 = ipairs(workspace:GetDescendants())
		local v142 = nil
		local ClickDetector = nil

		while true do
			local v144

			v141, v144 = v139(v140, v141)

			local Parent

			if not v141 then
				Parent = v142

				return
			end

			if v144:IsA("TextLabel") then
				local Text = v144.Text

				if string.match(Text, "^%d%d%d%d$") then
					Parent = v144.Parent

					while true do
						if true then
							local v147

							if Parent then
								v147 = not Parent:IsA("BasePart")
							else
								v147 = Parent
							end
						end

						if not v164 then
							break
						end

						Parent = Parent.Parent
					end

					local isBasePart

					if Parent then
						isBasePart = Parent:IsA("BasePart")
					else
						isBasePart = Parent
					end

					if isBasePart and (Parent.Position - Vector3.new(-515, 78.605, 322.213)).Magnitude < 30 then
						ClickDetector = Parent:FindFirstChildOfClass("ClickDetector")

						local v149 = not ClickDetector

						if v149 then
							v149 = Parent.Parent
						end

						if v149 then
							ClickDetector = Parent.Parent:FindFirstChildOfClass("ClickDetector")
						end

						return
					end
				end
			end
		end

		if v162 and ClickDetector then
			v22("Picking up KeyCode...")
			HumanoidRootPart.CFrame = v162.CFrame + Vector3.new(0, 2, 0)
			task.wait(0.3)
			fireclickdetector(ClickDetector)
			task.wait(0.5)
		else
			v104("72012879", false)
		end

		v22("Unlocking Door (KeyCode)...")
		v119(Vector3.new(-386.86, 79.425, 457.14), "KeyCode Keypad", nil, "keypad")
		v22("Teleporting to Exit...")
		HumanoidRootPart.CFrame = CFrame.new(-386, 79, 452)
		task.wait(1)

		if not v67() then
			return
		end

		task.wait(1)
	end
end

v67 = function()
	local vector3 = Vector3.new(-386.27, 79, 450.9)
	local ipairs_ = ipairs
	local workspace_ = workspace

	for _, descendant in ipairs_(workspace_.GetDescendants(workspace_)) do
		local isClickDetector = descendant:IsA("ClickDetector")

		if isClickDetector then
			isClickDetector = descendant.Parent

			if isClickDetector then
				isClickDetector = descendant.Parent:IsA("BasePart")
			end
		end

		if isClickDetector and (descendant.Parent.Position - vector3).Magnitude < 10 then
			return true
		end
	end

	return false
end

function runMainLoop()
	local s1 = "INIT"

	while _G.AutoFarmEnabled do
		task.wait(0.3)
		pcall(function()
			local MainMenu2 = v7:FindFirstChild("MainMenu")
			local Remotes = ReplicatedStorage:FindFirstChild("Remotes")
			local GameFolder = workspace:FindFirstChild("GameFolder")

			if GameFolder then
				GameFolder = GameFolder:FindFirstChild("Timer")
			end

			local isIntValue

			if GameFolder then
				isIntValue = GameFolder:IsA("IntValue")

				if isIntValue then
					isIntValue = GameFolder.Value > 100
				end
			else
				isIntValue = GameFolder
			end

			if MainMenu2 then
				local MainScreen = MainMenu2:FindFirstChild("MainScreen")
				local isGuiObject

				if MainScreen then
					isGuiObject = MainScreen:IsA("GuiObject")

					if isGuiObject then
						isGuiObject = MainScreen.Visible
					end
				else
					isGuiObject = MainScreen
				end

				if isIntValue then
					MainScreen = "INGAME"
					s1 = "INGAME"
				elseif isGuiObject then
					local Play = MainScreen:FindFirstChild("Play", true)
					local isGuiButton

					if Play then
						isGuiButton = Play:IsA("GuiButton")

						if isGuiButton then
							isGuiButton = Play.Visible
						end
					else
						isGuiButton = Play
					end

					if isGuiButton then
						if s1 == "INGAME" or s1 == "INIT" then
							local v165 = s1 == "INIT"

							s1 = "LOBBY"

							if not v165 then
								v22("Game Ended. Sending Webhook...")

								local Value2 = Currency.Value
								local v167 = Value2 - Value
								local v168 = Value2 - Value

								n1 = n1 + 1

								local v169 = os.time() - now2
								local v170 = os.time() - now

								v16(v169)
								tostring(v167)
								v17(v169, v167, v170, n1, v168, Value2)
								Value = Value2
							end
						end

						v22("Firing Play Button...")

						if firesignal then
							pcall(function()
								firesignal(Play.MouseButton1Click)
							end)
							pcall(function()
								firesignal(Play.Activated)
							end)
						end
					end
				end

				local PlayMenu = MainMenu2:FindFirstChild("PlayMenu")

				if PlayMenu then
					PlayMenu = PlayMenu:FindFirstChild("VotingMenu")
				end

				if PlayMenu then
					local ResultsMenu = PlayMenu:FindFirstChild("ResultsMenu")
					local isGuiObject2

					if ResultsMenu then
						isGuiObject2 = ResultsMenu:IsA("GuiObject")

						if isGuiObject2 then
							isGuiObject2 = ResultsMenu.Visible
						end
					else
						isGuiObject2 = ResultsMenu
					end

					if isGuiObject2 then
						v22("Skipping Results Timer...")

						local VIPCommandEvent

						if Remotes then
							VIPCommandEvent = Remotes:FindFirstChild("VIPCommandEvent")
						else
							VIPCommandEvent = Remotes
						end

						if VIPCommandEvent then
							Remotes.VIPCommandEvent:FireServer("SkipTimer", true)
						end
					end

					local MapVoting = PlayMenu:FindFirstChild("MapVoting")
					local isGuiObject3

					if MapVoting then
						isGuiObject3 = MapVoting:IsA("GuiObject")

						if isGuiObject3 then
							isGuiObject3 = MapVoting.Visible
						end
					else
						isGuiObject3 = MapVoting
					end

					if isGuiObject3 then
						v22("Choosing Map (Carnival)...")

						local VIPCommandEvent

						if Remotes then
							VIPCommandEvent = Remotes:FindFirstChild("VIPCommandEvent")
						else
							VIPCommandEvent = Remotes
						end

						if VIPCommandEvent then
							Remotes.VIPCommandEvent:FireServer("SetMap", "Carnival")
							task.wait(0.1)
							Remotes.VIPCommandEvent:FireServer("SkipTimer", true)
						end
					end

					local ModeVoting = PlayMenu:FindFirstChild("ModeVoting")
					local isGuiObject4

					if ModeVoting then
						isGuiObject4 = ModeVoting:IsA("GuiObject")

						if isGuiObject4 then
							isGuiObject4 = ModeVoting.Visible
						end
					else
						isGuiObject4 = ModeVoting
					end

					if isGuiObject4 then
						v22("Choosing Mode (Swarm)...")

						local VIPCommandEvent

						if Remotes then
							VIPCommandEvent = Remotes:FindFirstChild("VIPCommandEvent")
						else
							VIPCommandEvent = Remotes
						end

						if VIPCommandEvent then
							Remotes.VIPCommandEvent:FireServer("SetMode", "Swarm")
							task.wait(0.1)
							Remotes.VIPCommandEvent:FireServer("SkipTimer", true)
						end
					end
				end

				local Skip = MainMenu2:FindFirstChild("Skip")
				local isGuiObject2

				if Skip then
					isGuiObject2 = Skip:IsA("GuiObject")

					if isGuiObject2 then
						isGuiObject2 = Skip.Visible
					end
				else
					isGuiObject2 = Skip
				end

				if isGuiObject2 and firesignal then
					pcall(function()
						firesignal(Skip.MouseButton1Click)
					end)
					pcall(function()
						firesignal(Skip.Activated)
					end)
				end
			end

			if isIntValue then
				isIntValue = not _G.RunningSpeedrun
			end

			if not isIntValue then
				return
			end

			_G.RunningSpeedrun = true
			task.spawn(function()
				v22("Waiting Cutscene / Load...")
				now2 = os.time()
				task.wait(5)
				v22("Playing Game (Speedrun)...")
				v68()
				task.wait(3)
				_G.RunningSpeedrun = false
			end)
		end)
	end
end

task.spawn(runMainLoop)
