-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack
local lib = loadstring(game:HttpGet("https://raw.githubusercontent.com/NightForRoblox/Obsidian/main/Library.lua"))()
local lib2 = loadstring(game:HttpGet("https://raw.githubusercontent.com/NightForRoblox/Obsidian/main/addons/ThemeManager.lua"))()
local lib3 = loadstring(game:HttpGet("https://raw.githubusercontent.com/NightForRoblox/Obsidian/main/addons/SaveManager.lua"))()
local Options = lib.Options
local _ = lib.Toggles

lib.ForceCheckbox = false
lib.ShowToggleFrameInKeybinds = true

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

game:GetService("TweenService")

local Lighting = game:GetService("Lighting")
local LocalPlayer = Players.LocalPlayer
local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "RivoHubKeySystem"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = LocalPlayer.PlayerGui

local Frame = Instance.new("Frame")

Frame.Size = UDim2.new(1, 0, 1, 0)
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BackgroundTransparency = 0.4
Frame.ZIndex = 10
Frame.Active = false
Frame.Selectable = false
Frame.Parent = ScreenGui

local Frame2 = Instance.new("Frame")

Frame2.Size = UDim2.fromOffset(400, 300)
Frame2.Position = UDim2.new(0.5, -200, 0.5, -150)
Frame2.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
Frame2.BorderSizePixel = 0
Frame2.ZIndex = 11
Frame2.Active = true
Frame2.Selectable = false
Frame2.Parent = ScreenGui

local u15 = false
local Position = nil
local Position2 = nil

Frame2.InputBegan:Connect(function(input)
	if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	u15 = true
	Position = input.Position
	Position2 = Frame2.Position
end)
Frame2.InputEnded:Connect(function(input)
	if not (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	u15 = false
end)
UserInputService.InputChanged:Connect(function(input)
	local v18 = u15

	if v18 then
		v18 = input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch
	end

	if not v18 then
		return
	end

	local v19 = input.Position - Position

	Frame2.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v19.X, Position2.Y.Scale, Position2.Y.Offset + v19.Y)
end)

local UICorner = Instance.new("UICorner")

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = Frame2

local UIStroke = Instance.new("UIStroke")

UIStroke.Color = Color3.fromRGB(80, 60, 140)
UIStroke.Thickness = 1.5
UIStroke.Parent = Frame2

local TextLabel = Instance.new("TextLabel")

TextLabel.Size = UDim2.new(1, 0, 0, 50)
TextLabel.Position = UDim2.fromOffset(0, 10)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "RIVO HUB"
TextLabel.TextColor3 = Color3.fromRGB(200, 170, 255)
TextLabel.TextSize = 26
TextLabel.Font = Enum.Font.GothamBold
TextLabel.ZIndex = 12
TextLabel.Parent = Frame2

local TextLabel2 = Instance.new("TextLabel")

TextLabel2.Size = UDim2.new(1, 0, 0, 24)
TextLabel2.Position = UDim2.fromOffset(0, 55)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Text = "Enter your key to continue"
TextLabel2.TextColor3 = Color3.fromRGB(130, 130, 160)
TextLabel2.TextSize = 13
TextLabel2.Font = Enum.Font.Gotham
TextLabel2.ZIndex = 12
TextLabel2.Parent = Frame2

local TextBox = Instance.new("TextBox")

TextBox.Size = UDim2.new(1, -40, 0, 42)
TextBox.Position = UDim2.fromOffset(20, 100)
TextBox.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
TextBox.BorderSizePixel = 0
TextBox.PlaceholderText = "Enter Key..."
TextBox.PlaceholderColor3 = Color3.fromRGB(90, 90, 120)
TextBox.Text = ""
TextBox.TextColor3 = Color3.fromRGB(220, 220, 255)
TextBox.TextSize = 14
TextBox.Font = Enum.Font.GothamSemibold
TextBox.ClearTextOnFocus = false
TextBox.ZIndex = 12
TextBox.Parent = Frame2

local UICorner2 = Instance.new("UICorner")

UICorner2.CornerRadius = UDim.new(0, 8)
UICorner2.Parent = TextBox

local UIStroke2 = Instance.new("UIStroke")

UIStroke2.Color = Color3.fromRGB(60, 60, 90)
UIStroke2.Thickness = 1
UIStroke2.Parent = TextBox

local function createTextButton(p1, p2, p3)
	local TextButton = Instance.new("TextButton")

	TextButton.Size = UDim2.new(0.44, 0, 0, 38)
	TextButton.Position = UDim2.fromOffset(p3 == 1 and 20 or 220, 165)
	TextButton.BackgroundColor3 = p2
	TextButton.BorderSizePixel = 0
	TextButton.Text = p1
	TextButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton.TextSize = 13
	TextButton.Font = Enum.Font.GothamSemibold
	TextButton.ZIndex = 12
	TextButton.Parent = Frame2

	local UICorner3 = Instance.new("UICorner")

	UICorner3.CornerRadius = UDim.new(0, 8)
	UICorner3.Parent = TextButton

	return TextButton
end

local checkKey = createTextButton("Check Key", Color3.fromRGB(100, 60, 180), 1)
local getKey = createTextButton("Get Key", Color3.fromRGB(40, 40, 60), 2)
local TextButton = Instance.new("TextButton")

TextButton.Size = UDim2.new(1, -40, 0, 38)
TextButton.Position = UDim2.fromOffset(20, 218)
TextButton.BackgroundColor3 = Color3.fromRGB(30, 35, 80)
TextButton.BorderSizePixel = 0
TextButton.Text = "Join Discord"
TextButton.TextColor3 = Color3.fromRGB(180, 190, 255)
TextButton.TextSize = 13
TextButton.Font = Enum.Font.GothamSemibold
TextButton.ZIndex = 12
TextButton.Parent = Frame2

local UICorner3 = Instance.new("UICorner")

UICorner3.CornerRadius = UDim.new(0, 8)
UICorner3.Parent = TextButton

local TextLabel3 = Instance.new("TextLabel")

TextLabel3.Size = UDim2.new(1, -40, 0, 24)
TextLabel3.Position = UDim2.fromOffset(20, 268)
TextLabel3.BackgroundTransparency = 1
TextLabel3.Text = ""
TextLabel3.TextColor3 = Color3.fromRGB(200, 100, 100)
TextLabel3.TextSize = 12
TextLabel3.Font = Enum.Font.Gotham
TextLabel3.ZIndex = 12
TextLabel3.Parent = Frame2

local function v35(p4, p5)
	TextLabel3.Text = p4

	local v36 = TextLabel3

	if not p5 then
		v36.TextColor3 = p5 or Color3.fromRGB(220, 90, 90)

		return
	end

	p5 = Color3.fromRGB(100, 220, 140)
	v36.TextColor3 = p5 or Color3.fromRGB(220, 90, 90)
end

getKey.MouseButton1Click:Connect(function()
	if pcall(function()
		setclipboard("https://discord.gg/ZN4jtyPNHG")
	end) then
		v35("Discord link copied! Join to get your key.", true)
	else
		v35("Join: https://discord.gg/ZN4jtyPNHG", true)
	end
end)
TextButton.MouseButton1Click:Connect(function()
	lib:Notify({
		Title = "Rivo Hub",
		Content = "Join: https://discord.gg/ZN4jtyPNHG",
		Duration = 5
	})
end)
checkKey.MouseButton1Click:Connect(function()
	if TextBox.Text:lower():gsub("%s+", "") == "kairon-script" then
		v35("Key accepted!", true)
		task.wait(0.8)
		ScreenGui:Destroy()
		loadRivoHub()
	else
		v35("Invalid key. Try again.", false)
	end
end)

function loadRivoHub()
	local v38 = lib:CreateWindow({
		Title = "RIVO HUB",
		Footer = "Rivo Hub — discord.gg/ZN4jtyPNHG",
		NotifySide = "Right",
		ShowCustomCursor = true
	})
	local t2 = {
		Player = v38:AddTab("Player", "user"),
		ESP = v38:AddTab("ESP", "eye"),
		Entities = v38:AddTab("Entities", "zap"),
		Items = v38:AddTab("Items", "package"),
		Teleport = v38:AddTab("Teleport", "map-pin"),
		Environment = v38:AddTab("Environment", "sun"),
		["UI Settings"] = v38:AddTab("UI Settings", "settings")
	}
	local t1 = {
		value1 = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
	}

	t1.value2 = t1.value1:WaitForChild("Humanoid")
	t1.value3 = t1.value1:WaitForChild("HumanoidRootPart")
	LocalPlayer.CharacterAdded:Connect(function(character)
		t1.value1 = character
		t1.value2 = character:WaitForChild("Humanoid")
		t1.value3 = character:WaitForChild("HumanoidRootPart")
	end)

	local Movement = t2.Player:AddLeftGroupbox("Movement")

	Movement.AddSlider(Movement, "WalkSpeedSlider", {
		Text = "WalkSpeed",
		Default = 16,
		Min = 1,
		Max = 150,
		Rounding = 1,
		Callback = function(p6)
			if not t1.value2 then
				return
			end

			t1.value2.WalkSpeed = p6
		end
	})
	Movement.AddSlider(Movement, "JumpPowerSlider", {
		Text = "JumpPower",
		Default = 50,
		Min = 1,
		Max = 300,
		Rounding = 1,
		Callback = function(p7)
			if not t1.value2 then
				return
			end

			t1.value2.JumpPower = p7
		end
	})
	Movement.AddButton(Movement, {
		Text = "Reset WalkSpeed",
		Func = function()
			if not t1.value2 then
				return
			end

			t1.value2.WalkSpeed = 16
		end
	})
	Movement.AddButton(Movement, {
		Text = "Reset JumpPower",
		Func = function()
			if not t1.value2 then
				return
			end

			t1.value2.JumpPower = 50
		end
	})
	t1.value4 = nil

	local t3 = {
		Text = "Infinite Jump",
		Default = false,
		Callback = function(p8)
			if t1.value4 then
				t1.value4:Disconnect()
			end

			if not p8 then
				return
			end

			UserInputService.JumpRequest:Connect(function()
				local value1 = t1.value1

				if value1 then
					value1 = t1.value2
				end

				if not value1 then
					return
				end

				t1.value2:ChangeState(Enum.HumanoidStateType.Jumping)
			end)
		end
	}

	Movement.AddToggle(Movement, "InfiniteJump", t3)

	local Player = t2.Player
	local v44 = Player.AddRightGroupbox(Player, "Abilities")

	t1.value5 = nil

	local t4 = {
		Text = "Noclip",
		Default = false,
		Callback = function(p9)
			if t1.value5 then
				t1.value5:Disconnect()
			end

			if p9 then
				RunService.Stepped:Connect(function()
					if not t1.value1 then
						return
					end

					local ipairs_ = ipairs
					local value1 = t1.value1

					for _, descendant in ipairs_(value1.GetDescendants(value1)) do
						if descendant:IsA("BasePart") then
							descendant.CanCollide = false
						end
					end
				end)

				return
			end

			if not t1.value1 then
				return
			end

			for _, descendant in ipairs(t1.value1:GetDescendants()) do
				if descendant:IsA("BasePart") then
					descendant.CanCollide = true
				end
			end
		end
	}

	v44.AddToggle(v44, "Noclip", t4):AddKeyPicker("NoclipKey", {
		Default = "N",
		Text = "Noclip",
		Mode = "Toggle",
		SyncToggleState = true
	})
	t1.value6 = false
	t1.value7 = 30
	t1.value8 = nil
	t1.value9 = nil
	t1.value10 = nil

	function t1.value11()
		t1.value6 = true

		if not t1.value3 then
			return
		end

		t1.value8 = Instance.new("BodyVelocity")
		t1.value8.MaxForce = Vector3.new(1000000, 1000000, 1000000)
		t1.value8.Velocity = Vector3.new(0, 0, 0)
		t1.value8.Parent = t1.value3
		t1.value9 = Instance.new("BodyGyro")
		t1.value9.MaxTorque = Vector3.new(1000000, 1000000, 1000000)
		t1.value9.CFrame = t1.value3.CFrame
		t1.value9.Parent = t1.value3

		if t1.value2 then
			t1.value2.PlatformStand = true
		end

		t1.value10 = RunService.Heartbeat:Connect(function()
			if not t1.value6 then
				return
			end

			local CurrentCamera = workspace.CurrentCamera
			local vector3 = Vector3.new(0, 0, 0)
			local v54 = UserInputService

			if v54:IsKeyDown(Enum.KeyCode.W) then
				vector3 = vector3 + CurrentCamera.CFrame.LookVector
				v54 = vector3
			end

			if UserInputService:IsKeyDown(Enum.KeyCode.S) then
				vector3 = vector3 - CurrentCamera.CFrame.LookVector
			end

			if UserInputService:IsKeyDown(Enum.KeyCode.A) then
				vector3 = vector3 - CurrentCamera.CFrame.RightVector
			end

			if UserInputService:IsKeyDown(Enum.KeyCode.D) then
				vector3 = vector3 + CurrentCamera.CFrame.RightVector
			end

			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
				vector3 = vector3 + Vector3.new(0, 1, 0)
			end

			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then
				vector3 = vector3 - Vector3.new(0, 1, 0)
			end

			if t1.value8 then
				local value8 = t1.value8
				local s1 = "Velocity"
				local v57

				if vector3.Magnitude > 0 then
					v57 = vector3.Unit * t1.value7
				else
					v57 = false
				end

				value8[s1] = v57 or Vector3.new(0, 0, 0)
			end

			if not t1.value9 then
				return
			end

			t1.value9.CFrame = CurrentCamera.CFrame
		end)
	end

	v44:AddToggle("Fly", {
		Text = "Fly",
		Default = false,
		Callback = function(p10)
			if p10 then
				t1.value11()

				return
			end

			if t1.value10 then
				t1.value10:Disconnect()
			end

			if t1.value8 then
				t1.value8:Destroy()
			end

			if t1.value9 then
				t1.value9:Destroy()
			end

			if not t1.value2 then
				return
			end

			t1.value2.PlatformStand = false
		end
	}):AddKeyPicker("FlyKey", {
		Default = "F",
		Text = "Fly",
		Mode = "Toggle",
		SyncToggleState = true
	})
	v44.AddSlider(v44, "FlySpeedSlider", {
		Text = "Fly Speed",
		Default = 30,
		Min = 5,
		Max = 200,
		Rounding = 1,
		Callback = function(p11)
			t1.value7 = p11
		end
	})
	v44.AddToggle(v44, "GodMode", {
		Text = "God Mode (Test Invulnerability)",
		Default = false,
		Callback = function(p12)
			if not t1.value2 then
				return
			end

			t1.value2.MaxHealth = p12 and math.huge or p12 or 100

			if not p12 then
				return
			end

			t1.value2.Health = math.huge
		end
	})
	v44.AddButton(v44, {
		Text = "Reset Character",
		Func = function()
			if not t1.value2 then
				return
			end

			t1.value2.Health = 0
		end,
		Risky = true
	})
	t1.value12 = {}
	t1.value13 = false

	local v58 = t2.ESP:AddLeftGroupbox("ESP Controls")
	local Options2 = t2.ESP:AddRightGroupbox("Options")

	t1.value14 = true
	t1.value15 = true
	t1.value16 = true
	Options2.AddToggle(Options2, "ESPNames", {
		Text = "Show Names",
		Default = true,
		Callback = function(p13)
			t1.value14 = p13
		end
	})
	Options2.AddToggle(Options2, "ESPDistance", {
		Text = "Show Distance",
		Default = true,
		Callback = function(p14)
			t1.value15 = p14
		end
	})
	Options2.AddToggle(Options2, "ESPHighlight", {
		Text = "Highlight Entities",
		Default = true,
		Callback = function(p15)
			t1.value16 = p15
		end
	})

	local function v60()
		for _, v in pairs(t1.value12) do
			local Parent

			if v then
				Parent = v.Parent
			else
				Parent = v
			end

			if Parent then
				v:Destroy()
			end
		end

		t1.value12 = {}
	end

	function t1.value17(p16)
		if not (p16 and p16:FindFirstChild("HumanoidRootPart")) then
			return
		end

		local Parent = t1.value12[p16]

		if Parent then
			Parent = Parent.Parent
		end

		if Parent then
			return
		end

		local Highlight = Instance.new("Highlight")

		Highlight.Adornee = p16
		Highlight.FillColor = Color3.fromRGB(160, 100, 255)
		Highlight.OutlineColor = Color3.fromRGB(220, 180, 255)
		Highlight.FillTransparency = 0.6
		Highlight.OutlineTransparency = 0
		Highlight.Parent = p16
		t1.value12[p16] = Highlight

		local BillboardGui = Instance.new("BillboardGui")

		BillboardGui.Size = UDim2.fromOffset(120, 40)
		BillboardGui.StudsOffset = Vector3.new(0, 3, 0)
		BillboardGui.AlwaysOnTop = true
		BillboardGui.Adornee = p16.HumanoidRootPart
		BillboardGui.Parent = p16.HumanoidRootPart

		local TextLabel4 = Instance.new("TextLabel")

		TextLabel4.Size = UDim2.fromScale(1, 1)
		TextLabel4.BackgroundTransparency = 1
		TextLabel4.TextColor3 = Color3.fromRGB(220, 200, 255)
		TextLabel4.TextSize = 13
		TextLabel4.Font = Enum.Font.GothamBold
		TextLabel4.TextStrokeTransparency = 0.4
		TextLabel4.Parent = BillboardGui
		t1.value12[p16 .. "_bb"] = BillboardGui
		RunService.Heartbeat:Connect(function()
			if not t1.value13 then
				return
			end

			if not (p16 and p16.Parent) then
				return
			end

			local HumanoidRootPart = p16:FindFirstChild("HumanoidRootPart")
			local value1 = t1.value1

			if value1 then
				value1 = t1.value1:FindFirstChild("HumanoidRootPart")
			end

			local v70 = HumanoidRootPart and value1

			if v70 then
				local Magnitude = (HumanoidRootPart.Position - value1.Position).Magnitude

				v70 = math.floor(Magnitude)
			end

			local v72 = v70 or 0
			local Name = p16.Name
			local t5 = {}

			if t1.value14 then
				t5[#t5 + 1] = Name
			end

			if not t1.value15 then
				TextLabel4.Text = table.concat(t5, " | ")
				TextLabel4.Visible = t1.value14 or t1.value15
				Highlight.Enabled = t1.value16

				return
			end

			t5[#t5 + 1] = v72 .. "m"
			TextLabel4.Text = table.concat(t5, " | ")
			TextLabel4.Visible = t1.value14 or t1.value15
			Highlight.Enabled = t1.value16
		end)
	end

	local function v75()
		v60()

		local v76 = Players
		local v77, v78, v79 = ipairs(v76.GetPlayers(v76))

		while true do
			local v80

			v79, v80 = v77(v78, v79)

			if not v79 then
				break
			end

			local v81

			if v80 == LocalPlayer then
				v81 = false
			else
				v81 = v80.Character
			end

			if v81 then
				t1.value17(v80.Character)
			end
		end

		local ipairs_ = ipairs
		local workspace_ = workspace

		for _, descendant in ipairs_(workspace_.GetDescendants(workspace_)) do
			local isModel = descendant:IsA("Model")

			if isModel then
				isModel = descendant:FindFirstChild("Humanoid")
			end

			if isModel then
				t1.value17(descendant)
			end
		end
	end

	v58.AddToggle(v58, "EntityESP", {
		Text = "Enable ESP",
		Default = false,
		Callback = function(p17)
			t1.value13 = p17

			if p17 then
				v75()
			else
				v60()
			end
		end
	})
	v58:AddButton({
		Text = "Refresh ESP",
		Func = v75
	})
	v58.AddButton(v58, {
		Text = "Remove ESP",
		Func = function()
			v60()
		end
	})

	local v87 = t2.Entities:AddLeftGroupbox("Entity Tests")
	local v88 = t2.Entities:AddRightGroupbox("Custom Triggers")

	for i, v in ipairs({
		{
			name = "Screech Test",
			remote = "TestScreech"
		},
		{
			name = "Eyes Test",
			remote = "TestEyes"
		},
		{
			name = "Dread Test",
			remote = "TestDread"
		},
		{
			name = "Figure Test",
			remote = "TestFigure"
		},
		{
			name = "Seek Test",
			remote = "TestSeek"
		},
		{
			name = "Halt Test",
			remote = "TestHalt"
		},
		{
			name = "Shadow Test",
			remote = "TestShadow"
		},
		{
			name = "Timothy Test",
			remote = "TestTimothy"
		}
	}) do
		local v91 = i <= 4 and v87 and v87 or v88

		local function v92()
			local VRemote = game:GetService("ReplicatedStorage"):FindFirstChild(v.remote, true)
			local isRemoteEvent

			if VRemote then
				isRemoteEvent = VRemote:IsA("RemoteEvent")
			else
				isRemoteEvent = VRemote
			end

			if isRemoteEvent then
				VRemote:FireServer()
				lib:Notify({
					Title = "Rivo Hub",
					Content = v.name .. " triggered.",
					Duration = 3
				})
			else
				local v95 = lib

				v95.Notify(v95, {
					Title = "Rivo Hub",
					Content = "Remote not found: " .. v.remote,
					Duration = 3
				})
			end
		end

		v91.AddButton(v91, {
			Text = v.name,
			Func = v92
		})
	end

	local v96 = t2.Items:AddLeftGroupbox("Item Testing")
	local Inventory = t2.Items:AddRightGroupbox("Inventory")

	for _, v in ipairs({
		{
			text = "Give Test Item",
			remote = "GiveTestItem"
		},
		{
			text = "Give Crucifix",
			remote = "GiveCrucifix"
		},
		{
			text = "Give Flashlight",
			remote = "GiveFlashlight"
		},
		{
			text = "Give Key",
			remote = "GiveKey"
		},
		{
			text = "Give Lighter",
			remote = "GiveLighter"
		},
		{
			text = "Give Vitamins",
			remote = "GiveVitamins"
		}
	}) do
		local function v100()
			local VRemote = game:GetService("ReplicatedStorage"):FindFirstChild(v.remote, true)
			local isRemoteEvent

			if VRemote then
				isRemoteEvent = VRemote:IsA("RemoteEvent")
			else
				isRemoteEvent = VRemote
			end

			if isRemoteEvent then
				VRemote:FireServer()

				local v103 = lib
				local v104 = v

				v103.Notify(v103, {
					Title = "Rivo Hub",
					Content = v104.text .. " sent.",
					Duration = 3
				})
			else
				lib:Notify({
					Title = "Rivo Hub",
					Content = "Remote not found: " .. v.remote,
					Duration = 3
				})
			end
		end

		v96.AddButton(v96, {
			Text = v.text,
			Func = v100
		})
	end

	Inventory.AddButton(Inventory, {
		Text = "Remove Test Item",
		Func = function()
			local RemoveTestItem = game:GetService("ReplicatedStorage"):FindFirstChild("RemoveTestItem", true)

			if not RemoveTestItem then
				return
			end

			RemoveTestItem:FireServer()
		end
	})
	Inventory.AddButton(Inventory, {
		Text = "Clear Inventory",
		Func = function()
			local ClearInventory = game:GetService("ReplicatedStorage"):FindFirstChild("ClearInventory", true)

			if not ClearInventory then
				return
			end

			ClearInventory:FireServer()
		end,
		Risky = true
	})
	Inventory.AddToggle(Inventory, "InfiniteItems", {
		Text = "Infinite Item Mode",
		Default = false,
		Callback = function(p18)
			local SetInfiniteItems = game:GetService("ReplicatedStorage"):FindFirstChild("SetInfiniteItems", true)

			if not SetInfiniteItems then
				return
			end

			SetInfiniteItems:FireServer(p18)
		end
	})

	local Locations = t2.Teleport:AddLeftGroupbox("Locations")
	local Custom = t2.Teleport:AddRightGroupbox("Custom")
	local t6 = {
		{
			name = "Lobby",
			vector = Vector3.new(0, 5, 0)
		},
		{
			name = "Room 1",
			vector = nil,
			room = 1
		},
		{
			name = "Room 10",
			vector = nil,
			room = 10
		},
		{
			name = "Room 50",
			vector = nil,
			room = 50
		},
		{
			name = "Room 100",
			vector = nil,
			room = 100
		},
		{
			name = "Stairwell",
			vector = nil,
			stairwell = true
		}
	}

	local function v111(p19)
		local CurrentRooms = workspace:FindFirstChild("CurrentRooms")

		if CurrentRooms then
			local v113 = CurrentRooms:FindFirstChild(tostring(p19))

			if v113 then
				local Door = v113:FindFirstChild("Door", true)

				if Door then
					t1.value3.CFrame = Door.CFrame + Vector3.new(0, 3, 0)
				else
					t1.value3.CFrame = v113:GetModelCFrame() + Vector3.new(0, 5, 0)
				end

				local v115 = lib

				v115.Notify(v115, {
					Title = "Rivo Hub",
					Content = "Teleported to Room " .. p19,
					Duration = 3
				})

				return
			else
				lib:Notify({
					Title = "Rivo Hub",
					Content = "Room " .. p19 .. " not found.",
					Duration = 3
				})

				return
			end
		else
			lib:Notify({
				Title = "Rivo Hub",
				Content = "CurrentRooms not found.",
				Duration = 3
			})
		end
	end

	for _, v in ipairs(t6) do
		local t7 = {
			Text = v.name,
			Func = function()
				if not t1.value3 then
					return
				end

				if v.vector then
					t1.value3.CFrame = CFrame.new(v.vector)

					return
				end

				if v.room then
					v111(v.room)

					return
				end

				if not v.stairwell then
					return
				end

				local Stairwell = workspace:FindFirstChild("Stairwell", true)

				if Stairwell then
					local value3 = t1.value3
					local s2 = "CFrame"
					local isModel = Stairwell:IsA("Model")

					if not isModel then
						value3[s2] = isModel or CFrame.new(Stairwell.Position + Vector3.new(0, 5, 0))

						return
					end

					isModel = Stairwell:GetModelCFrame() + Vector3.new(0, 5, 0)
					value3[s2] = isModel or CFrame.new(Stairwell.Position + Vector3.new(0, 5, 0))
				else
					lib:Notify({
						Title = "Rivo Hub",
						Content = "Stairwell not found.",
						Duration = 3
					})
				end
			end
		}

		Locations.AddButton(Locations, t7)
	end

	t1.value18 = nil

	local t8 = {
		Text = "Save Current Position",
		Func = function()
			if not t1.value3 then
				return
			end

			t1.value18 = t1.value3.Position
			lib:Notify({
				Title = "Rivo Hub",
				Content = "Position saved.",
				Duration = 3
			})
		end
	}

	Custom.AddButton(Custom, t8)

	local t9 = {
		Text = "Teleport to Saved",
		Func = function()
			local value18 = t1.value18

			if not value18 then
				if value18 then
					t1.value3.CFrame = CFrame.new(t1.value18)
				else
					lib:Notify({
						Title = "Rivo Hub",
						Content = "No saved position.",
						Duration = 3
					})
				end

				return
			end

			value18 = t1.value3

			if value18 then
				t1.value3.CFrame = CFrame.new(t1.value18)
			else
				lib:Notify({
					Title = "Rivo Hub",
					Content = "No saved position.",
					Duration = 3
				})
			end
		end
	}

	Custom.AddButton(Custom, t9)

	local t10 = {
		Text = "Teleport to Next Room",
		Func = function()
			local GameData = game:GetService("ReplicatedStorage"):FindFirstChild("GameData")
			local LatestRoom = GameData and GameData:FindFirstChild("LatestRoom")

			if LatestRoom then
				v111(LatestRoom.Value + 1)
			else
				local v129 = lib

				v129.Notify(v129, {
					Title = "Rivo Hub",
					Content = "GameData not found.",
					Duration = 3
				})
			end
		end
	}

	Custom.AddButton(Custom, t10)

	local Lighting2 = t2.Environment:AddLeftGroupbox("Lighting")
	local v131 = t2.Environment:AddRightGroupbox("Debug Info")
	local v132 = t2.Environment:AddLeftGroupbox("Room Controls")

	t1.value19 = false
	t1.value20 = nil

	local t11 = {
		Text = "Fullbright",
		Default = false,
		Callback = function(p20)
			t1.value19 = p20

			if t1.value20 then
				t1.value20:Disconnect()
			end

			if not p20 then
				Lighting.Ambient = Color3.fromRGB(67, 51, 56)
				Lighting.Brightness = 0
				Lighting.FogEnd = 9999
				Lighting.GlobalShadows = true

				return
			end

			RunService.Heartbeat:Connect(function()
				if t1.value19 then
					Lighting.Ambient = Color3.fromRGB(255, 255, 255)
					Lighting.Brightness = 2
					Lighting.FogEnd = 10000000000
					Lighting.GlobalShadows = false
				end
			end)
		end
	}

	Lighting2.AddToggle(Lighting2, "Fullbright", t11)

	local t12 = {
		Text = "Brightness",
		Default = 0,
		Min = 0,
		Max = 10,
		Rounding = 1,
		Callback = function(p21)
			Lighting.Brightness = p21
		end
	}

	Lighting2.AddSlider(Lighting2, "BrightnessSlider", t12)

	local t13 = {
		Text = "Fog End",
		Default = 9999,
		Min = 10,
		Max = 10000,
		Rounding = 1,
		Callback = function(p22)
			Lighting.FogEnd = p22
		end
	}

	Lighting2.AddSlider(Lighting2, "FogSlider", t13)
	t1.value21 = v131:AddLabel("Pos: 0, 0, 0")
	t1.value22 = v131:AddLabel("Room: Unknown")
	RunService.Heartbeat:Connect(function()
		if t1.value3 then
			local Position3 = t1.value3.Position

			t1.value21:SetText(unpack_({ string.format("Pos: %.1f, %.1f, %.1f", Position3.X, Position3.Y, Position3.Z) }))
		end

		local GameData = game:GetService("ReplicatedStorage"):FindFirstChild("GameData")
		local LatestRoom = GameData and GameData:FindFirstChild("LatestRoom")

		if not LatestRoom then
			return
		end

		local value22 = t1.value22
		local Value = LatestRoom.Value

		value22:SetText("Current Room: " .. tostring(Value))
	end)

	local t14 = {
		Text = "Print Workspace Tree",
		Func = function()
			local ipairs_ = ipairs
			local workspace_ = workspace

			for _, child in ipairs_(workspace_.GetChildren(workspace_)) do
				print(child.Name, child.ClassName)
			end

			lib:Notify({
				Title = "Rivo Hub",
				Content = "Workspace printed to output.",
				Duration = 3
			})
		end
	}

	v131.AddButton(v131, t14)

	local t15 = {
		Text = "Destroy Puzzle Doors",
		Func = function()
			local CurrentRooms = workspace:FindFirstChild("CurrentRooms")

			if not CurrentRooms then
				lib:Notify({
					Title = "Rivo Hub",
					Content = "Gates destroyed.",
					Duration = 3
				})

				return
			end

			local GetDescendants = CurrentRooms.GetDescendants

			for _, v in ipairs(GetDescendants(CurrentRooms)) do
				local isModel = v:IsA("Model")

				if isModel then
					isModel = v.Name == "Gate"
				end

				if isModel then
					v:Destroy()
				end
			end

			lib:Notify({
				Title = "Rivo Hub",
				Content = "Gates destroyed.",
				Duration = 3
			})
		end
	}

	v132.AddButton(v132, t15)

	local t16 = {
		Text = "Spawn Debug Room",
		Func = function()
			local SpawnDebugRoom = game:GetService("ReplicatedStorage"):FindFirstChild("SpawnDebugRoom", true)

			if SpawnDebugRoom then
				SpawnDebugRoom.FireServer(SpawnDebugRoom)
				lib:Notify({
					Title = "Rivo Hub",
					Content = "Debug room spawned.",
					Duration = 3
				})
			else
				lib:Notify({
					Title = "Rivo Hub",
					Content = "Remote not found.",
					Duration = 3
				})
			end
		end
	}

	v132.AddButton(v132, t16)

	local t17 = {
		Text = "Reset Room",
		Func = function()
			local ResetRoom = game:GetService("ReplicatedStorage"):FindFirstChild("ResetRoom", true)

			if ResetRoom then
				ResetRoom:FireServer()
				lib:Notify({
					Title = "Rivo Hub",
					Content = "Room reset.",
					Duration = 3
				})
			else
				lib:Notify({
					Title = "Rivo Hub",
					Content = "Remote not found.",
					Duration = 3
				})
			end
		end,
		Risky = true
	}

	v132.AddButton(v132, t17)

	local Menu = t2["UI Settings"]:AddLeftGroupbox("Menu")
	local KeybindFrame = lib.KeybindFrame

	if KeybindFrame then
		KeybindFrame = lib.KeybindFrame.Visible
	end

	local t18 = {
		Default = KeybindFrame or false,
		Text = "Open Keybind Menu",
		Callback = function(p23)
			if not lib.KeybindFrame then
				return
			end

			lib.KeybindFrame.Visible = p23
		end
	}

	Menu.AddToggle(Menu, "KeybindMenuOpen", t18)

	local t19 = {
		Text = "Custom Cursor",
		Default = true,
		Callback = function(p24)
			lib.ShowCustomCursor = p24
		end
	}

	Menu.AddToggle(Menu, "ShowCustomCursor", t19)

	local t20 = {
		Values = { "Left", "Right" },
		Default = "Right",
		Text = "Notification Side",
		Callback = function(p25)
			lib:SetNotifySide(p25)
		end
	}

	Menu.AddDropdown(Menu, "NotifSide", t20)

	local t21 = {
		Values = {
			"50%",
			"75%",
			"100%",
			"125%",
			"150%",
			"175%",
			"200%"
		},
		Default = "100%",
		Text = "DPI Scale",
		Callback = function(p26)
			local v162 = p26:gsub("%%", "")

			lib:SetDPIScale(unpack_({ (tonumber(v162)) }))
		end
	}

	Menu.AddDropdown(Menu, "DPIScale", t21)
	Menu:AddDivider()
	Menu:AddLabel("Menu Bind"):AddKeyPicker("MenuKeybind", {
		Default = "RightShift",
		NoUI = true,
		Text = "Menu keybind"
	})

	local Links = t2["UI Settings"]:AddRightGroupbox("Links")

	local function v164()
		lib:Notify({
			Title = "Rivo Hub",
			Content = "discord.gg/ZN4jtyPNHG",
			Duration = 6
		})
	end

	Links.AddButton(Links, {
		Text = "Join Discord",
		Func = v164
	})
	Links:AddLabel("discord.gg/ZN4jtyPNHG")
	Links:AddLabel("Key: kairon-script")
	Menu:AddButton("Unload", function()
		lib:Unload()
	end)
	lib.ToggleKeybind = Options.MenuKeybind
	lib2:SetLibrary(lib)
	lib3:SetLibrary(lib)
	lib3:IgnoreThemeSettings()

	local v165 = lib3

	v165.SetIgnoreIndexes(v165, { "MenuKeybind" })
	lib2:SetFolder("RivoHub")
	lib3:SetFolder("RivoHub/saves")
	lib3:BuildConfigSection(t2["UI Settings"])
	lib2:ApplyToTab(t2["UI Settings"])
	lib3:LoadAutoloadConfig()
	lib:Notify({
		Title = "Rivo Hub",
		Content = "Authorized. Welcome.",
		Duration = 4
	})
end
