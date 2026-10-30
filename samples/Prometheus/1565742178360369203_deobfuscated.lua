-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack
local t2 = {
	value1 = game:GetService("TweenService"),
	value2 = game:GetService("UserInputService"),
	value3 = game:GetService("RunService")
}
local Players = game:GetService("Players")

t2.value4 = game:GetService("VirtualInputManager")
t2.value5 = game:GetService("HttpService")
t2.value6 = game:GetService("ReplicatedStorage")
t2.value7 = game:GetService("VirtualUser")
t2.value8 = Players.LocalPlayer
t2.value9 = Color3.fromRGB(15, 15, 15)
t2.value10 = Color3.fromRGB(0, 200, 255)
t2.value11 = Color3.fromRGB(150, 150, 150)
t2.value12 = "SylentHub_Configs"
t2.value13 = t2.value12 .. "/_autoload.txt"

local isfolder_ = isfolder

if isfolder_ then
	isfolder_ = not isfolder(t2.value12)
end

if isfolder_ then
	makefolder(t2.value12)
end

t2.value14 = {}

function t2.value15(p1)
	local value14 = t2.value14

	table.insert(value14, p1)

	return p1
end

task.spawn(function()
	while _G.SylentHubActive do
		local function v7()
			local getconnections_ = getconnections or get_signal_cons

			if not getconnections_ then
				return
			end

			for _, v in pairs(getconnections_(t2.value8.Idled)) do
				if v.Disable then
					v:Disable()
				elseif v.Disconnect then
					v:Disconnect()
				end
			end
		end

		pcall(v7)
		pcall(function()
			t2.value7:CaptureController()
			t2.value7:ClickButton2(Vector2.new())
		end)
		task.wait(120)
	end
end)
_G.SylentHubActive = true
_G.FarmActive = false
_G.IsConverting = true
_G.HasPressedE = false
_G.IgnoreHoney = true
_G.SelectedField = "Sunflower Field"
_G.FixedSpeed = false
_G.FixedSpeedValue = 40
_G.FarmBubbles = false
_G.FarmBloom = false
_G.AutoStickers = false
_G.AutoDig = false
_G.AutoSprinkler = false
_G.SelectedSprinkler = "Basic Sprinkler"
_G.IsPlantingSprinklers = false
_G.AutoConvertBalloons = false
_G.BalloonConvertInterval = 30
_G.LastBalloonConvertTime = tick()
_G.WalkMode = "Random"
_G.AutoMondo = false
_G.IsFightingMondo = false
t2.value16 = { "Random", "Circle", "Pattern" }
t2.value17 = 1
t2.value18 = setmetatable({}, {
	__mode = "k"
})
_G.CurrentPhantomToken = nil
_G.TokenStuckTimer = 0
_G.AutoDispensers = false
_G.DispToggles = {
	["Blueberry Dispenser"] = false,
	["Strawberry Dispenser"] = false,
	["Coconut Dispenser"] = false,
	["Treat Dispenser"] = false,
	["Robo Pass Dispenser"] = false,
	["Free Royal Jelly Dispenser"] = false,
	["Ant Pass Dispenser"] = false
}
_G.DispenserCooldowns = {}
_G.ConfigSetters = {}
_G.ToggleKey = Enum.KeyCode.Insert
t2.value19 = t2.value8:WaitForChild("CoreStats"):WaitForChild("Honey").Value
t2.value20 = tick()
t2.value21 = 60
t2.value22 = workspace:FindFirstChild("FlowerZones")
t2.value23 = {}

if t2.value22 then
	local pairs_ = pairs
	local value22 = t2.value22

	for _, child in pairs_(value22.GetChildren(value22)) do
		if child:IsA("BasePart") then
			local value23 = t2.value23
			local Name = child.Name

			table.insert(value23, Name)
		end
	end

	table.sort(t2.value23)
end

if t2.value8.PlayerGui:FindFirstChild("sylenthub") then
	_G.SylentHubActive = false
	t2.value8.PlayerGui.sylenthub:Destroy()
	task.wait(0.1)
end

_G.SylentHubActive = true
t2.value24 = Instance.new("ScreenGui", t2.value8.PlayerGui)
t2.value24.Name = "sylenthub"
t2.value24.ResetOnSpawn = false
t2.value24.DisplayOrder = 99999

function t2.value25(p2, p3)
	if isfile(p3) then
		return (getcustomasset or getsynasset)(p3)
	end

	local response = game:HttpGet(p2)

	writefile(p3, response)

	return (getcustomasset or getsynasset)(p3)
end

t2.value26 = Instance.new("Frame", t2.value24)
t2.value26.Size = UDim2.new(0, 230, 0.5, 0)

local value26 = t2.value26
local uDim2New = UDim2.new
local t1 = {
	value1 = 0
}

value26.Position = uDim2New(1, -240, 0.45, t1.value1)
t2.value26.BackgroundTransparency = 1

local UIListLayout = Instance.new("UIListLayout", t2.value26)

UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 8)

local function v21(p4)
	local u22 = false
	local u23 = nil
	local Position = nil
	local Position2 = nil

	p4.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u22 = true
		Position = input.Position
		Position2 = p4.Position
	end)
	p4.InputEnded:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u22 = false
	end)
	p4.InputChanged:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u23 = input
	end)
	t2.value15(t2.value2.InputChanged:Connect(function(input)
		local v26

		if input == u23 then
			v26 = u22
		else
			v26 = false
		end

		if not v26 then
			return
		end

		local v27 = input.Position - Position

		p4.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v27.X, Position2.Y.Scale, Position2.Y.Offset + v27.Y)
	end))
end

t2.value27 = 0

function t2.value28(p5, p6)
	local u28 = p6

	task.spawn(function()
		u28 = u28 or 3
		t2.value27 = t2.value27 - 1

		local Frame = Instance.new("Frame", t2.value26)

		Frame.Size = UDim2.new(0, 220, 0, 65)
		Frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		Frame.BackgroundTransparency = 1
		Frame.LayoutOrder = t2.value27
		Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)

		local UIStroke = Instance.new("UIStroke", Frame)

		UIStroke.Thickness = 2
		UIStroke.Color = t2.value10
		UIStroke.Transparency = 1

		local TextLabel = Instance.new("TextLabel", Frame)

		TextLabel.Size = UDim2.new(1, -10, 0, 25)
		TextLabel.Position = UDim2.new(0, 10, 0, 5)
		TextLabel.Text = "SYLENTHUB"
		TextLabel.TextColor3 = t2.value10
		TextLabel.Font = Enum.Font.GothamBold
		TextLabel.TextSize = 13
		TextLabel.BackgroundTransparency = 1
		TextLabel.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel.TextTransparency = 1

		local TextLabel2 = Instance.new("TextLabel", Frame)

		TextLabel2.Size = UDim2.new(1, -20, 0, 30)
		TextLabel2.Position = UDim2.new(0, 10, 0, 28)
		TextLabel2.Text = p5
		TextLabel2.TextColor3 = Color3.fromRGB(200, 200, 200)
		TextLabel2.Font = Enum.Font.Gotham
		TextLabel2.TextSize = 11
		TextLabel2.BackgroundTransparency = 1
		TextLabel2.TextWrapped = true
		TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel2.TextTransparency = 1
		t2.value1:Create(Frame, TweenInfo.new(0.4), {
			BackgroundTransparency = 0
		}):Play()
		t2.value1:Create(UIStroke, TweenInfo.new(0.4), {
			Transparency = 0
		}):Play()

		local value1 = t2.value1
		local tweenInfo = TweenInfo.new(0.4)

		value1.Create(value1, TextLabel, tweenInfo, {
			TextTransparency = 0
		}):Play()

		local value12 = t2.value1
		local TweenInfo_ = TweenInfo

		value12.Create(value12, TextLabel2, TweenInfo_.new(0.4), {
			TextTransparency = 0
		}):Play()
		task.wait(u28)

		local Parent

		if Frame then
			Parent = Frame.Parent
		else
			Parent = Frame
		end

		if not Parent then
			return
		end

		local value13 = t2.value1
		local TweenInfo_2 = TweenInfo
		local v40 = value13.Create(value13, Frame, TweenInfo_2.new(0.4), {
			BackgroundTransparency = 1
		})
		local tweenInfoNew = TweenInfo.new

		t2.value1:Create(UIStroke, tweenInfoNew(0.4), {
			Transparency = 1
		}):Play()
		t2.value1:Create(TextLabel, TweenInfo.new(0.4), {
			TextTransparency = 1
		}):Play()

		local value14 = t2.value1
		local tweenInfo2 = TweenInfo.new(0.4)

		value14.Create(value14, TextLabel2, tweenInfo2, {
			TextTransparency = 1
		}):Play()
		v40:Play()
		v40.Completed:Wait()
		Frame:Destroy()
	end)
end

local function v44(p7)
	if p7 then
		p7 = _G.SylentHubActive
	end

	if p7 then
		if _G.NoclipConn then
			_G.NoclipConn:Disconnect()
		end

		_G.NoclipConn = t2.value3.Stepped:Connect(function()
			if not t2.value8.Character then
				return
			end

			local pairs_ = pairs
			local Character = t2.value8.Character

			for _, descendant in pairs_(Character.GetDescendants(Character)) do
				if descendant:IsA("BasePart") then
					descendant.CanCollide = false
				end
			end
		end)
		t2.value15(_G.NoclipConn)

		return
	end

	if not _G.NoclipConn then
		return
	end

	_G.NoclipConn:Disconnect()
end

t2.value29 = 80

local function v49(p8)
	local HumanoidRootPart = (t2.value8.Character or t2.value8.CharacterAdded:Wait()):WaitForChild("HumanoidRootPart", 5)

	if not HumanoidRootPart then
		return false
	end

	v44(true)

	local v51 = tick() + 10
	local v52 = v51

	while true do
		local SylentHubActive = _G.SylentHubActive

		if SylentHubActive then
			if HumanoidRootPart then
				SylentHubActive = HumanoidRootPart.Parent

				if SylentHubActive then
					SylentHubActive = (HumanoidRootPart.Position - p8.Position).Magnitude > 5
				end
			else
				SylentHubActive = HumanoidRootPart
			end
		end

		if not (SylentHubActive and v52 >= tick()) then
			v44(false)

			return true
		end

		local Unit = (p8.Position - HumanoidRootPart.Position).Unit
		local Position = HumanoidRootPart.Position
		local Magnitude = (p8.Position - HumanoidRootPart.Position).Magnitude
		local v57 = Position + Unit * math.min(50, Magnitude)
		local value1 = t2.value1
		local tweenInfo = TweenInfo.new(50 / t2.value29, Enum.EasingStyle.Linear)
		local CFrame_ = CFrame
		local v61 = value1.Create(value1, HumanoidRootPart, tweenInfo, {
			CFrame = CFrame_.new(v57)
		})

		v61:Play()
		v61.Completed:Wait()
		v51 = task.wait
		v51(0.02)
	end
end
local function v62()
	local Honeycombs = workspace:FindFirstChild("Honeycombs") or workspace:FindFirstChild("Hives")

	if Honeycombs then
		for _, child in pairs(Honeycombs:GetChildren()) do
			local Owner = child:FindFirstChild("Owner")

			if Owner then
				Owner = Owner.Value == t2.value8
			end

			if Owner then
				return child
			end
		end

		return nil
	else
		return nil
	end
end
local function v67()
	t2.value4:SendKeyEvent(true, Enum.KeyCode.E, false, game)
	task.wait(0.1)

	local E = Enum.KeyCode.E

	t2.value4:SendKeyEvent(false, E, false, game)
end

function t2.value30()
	local value8 = t2.value8
	local Honey = value8.FindFirstChild(value8, "CoreStats")
	local Pollen

	if Honey then
		Pollen = Honey:FindFirstChild("Pollen")
	else
		Pollen = Honey
	end

	if Honey then
		Honey = Honey:FindFirstChild("Honey")
	end

	if not Pollen or Pollen.Value == 0 then
		return
	end

	local v72 = v62()

	if not v72 then
		return
	end

	local boundingBox, v74 = v72:GetBoundingBox()
	local v75 = boundingBox * CFrame.new(0, -v74.Y / 2 + 1, 5.5)

	v49(v75)

	local wait = task.wait

	wait(0.5)

	local Character = t2.value8.Character

	if Character then
		Character = t2.value8.Character:FindFirstChild("HumanoidRootPart")
	end

	while true do
		local SylentHubActive = _G.SylentHubActive

		if SylentHubActive then
			SylentHubActive = Pollen.Value > 0
		end

		local AutoConvertBalloons, v80, Value, n1, v83, SylentHubActive2, v85, Value2

		if not SylentHubActive then
			AutoConvertBalloons = _G.AutoConvertBalloons

			if AutoConvertBalloons then
				AutoConvertBalloons = _G.SylentHubActive
			end

			if not (AutoConvertBalloons and (tick() - _G.LastBalloonConvertTime) / 60 >= _G.BalloonConvertInterval) then
				task.wait(2)

				return
			end

			if Character then
				v80 = (Character.Position - v75.Position).Magnitude > 15
			else
				v80 = Character
			end

			if v80 then
				v49(v75)
			end

			t2.value28("Converting Balloons...", 3)
			task.wait(2)

			if Honey then
				Value = Honey.Value
			else
				Value = Honey
			end

			n1 = 0
			v83 = Value or 0

			while true do
				SylentHubActive2 = _G.SylentHubActive

				if SylentHubActive2 then
					SylentHubActive2 = n1 < 5
				end

				if not SylentHubActive2 then
					break
				end

				if Character then
					v85 = (Character.Position - v75.Position).Magnitude > 15
				else
					v85 = Character
				end

				if v85 then
					v49(v75)
				end

				task.wait(1)
				Value2 = Honey and (Honey.Value or 0) or 0

				if v83 < Value2 then
					v83 = Value2
					n1 = 0
				else
					n1 = n1 + 1
				end
			end

			_G.LastBalloonConvertTime = tick()
			t2.value28("Balloons finished converting.", 2)
			task.wait(2)

			return
		end

		local v87

		if Character then
			v87 = (Character.Position - v75.Position).Magnitude > 15
		else
			v87 = Character
		end

		if v87 then
			v49(v75)
			task.wait(0.5)
		end

		local Value3 = Pollen.Value

		v67()
		wait = task.wait
		wait(2)

		if Pollen.Value < Value3 then
			local Value4 = Pollen.Value

			wait = 0

			local n2 = 0

			while true do
				local SylentHubActive3 = _G.SylentHubActive

				if SylentHubActive3 then
					SylentHubActive3 = Pollen.Value > 0
				end

				if not SylentHubActive3 then
					break
				end

				local v92

				if Character then
					v92 = (Character.Position - v75.Position).Magnitude > 15
				else
					v92 = Character
				end

				if v92 then
					v49(v75)
					task.wait(0.5)
				end

				wait = task.wait
				wait(1)

				if Value4 <= Pollen.Value then
					wait = n2 + 1

					if wait > 3 then
						break
					end

					n2 = wait
				else
					Value4 = Pollen.Value
					n2 = 0
				end

				continue
			end

			if Pollen.Value == 0 then
				AutoConvertBalloons = _G.AutoConvertBalloons

				if AutoConvertBalloons then
					AutoConvertBalloons = _G.SylentHubActive
				end

				if not (AutoConvertBalloons and (tick() - _G.LastBalloonConvertTime) / 60 >= _G.BalloonConvertInterval) then
					task.wait(2)

					return
				end

				if Character then
					v80 = (Character.Position - v75.Position).Magnitude > 15
				else
					v80 = Character
				end

				if v80 then
					v49(v75)
				end

				t2.value28("Converting Balloons...", 3)
				task.wait(2)

				if Honey then
					Value = Honey.Value
				else
					Value = Honey
				end

				n1 = 0
				v83 = Value or 0

				while true do
					SylentHubActive2 = _G.SylentHubActive

					if SylentHubActive2 then
						SylentHubActive2 = n1 < 5
					end

					if not SylentHubActive2 then
						break
					end

					if Character then
						v85 = (Character.Position - v75.Position).Magnitude > 15
					else
						v85 = Character
					end

					if v85 then
						v49(v75)
					end

					task.wait(1)
					Value2 = Honey and (Honey.Value or 0) or 0

					if v83 < Value2 then
						v83 = Value2
						n1 = 0
					else
						n1 = n1 + 1
					end
				end

				_G.LastBalloonConvertTime = tick()
				t2.value28("Balloons finished converting.", 2)
				task.wait(2)

				return
			end
		end

		task.wait(0.5)

		continue
	end
end
function t2.value31()
	local Honeycombs = workspace:FindFirstChild("Honeycombs") or workspace:FindFirstChild("Hives")

	if not Honeycombs then
		return
	end

	local pairs_ = v62
	local v95 = pairs_()

	if v95 then
		if not v95 then
			return
		end

		v110 = t2.value8:FindFirstChild("CoreStats")

		if v110 then
			v110 = v110:FindFirstChild("Pollen")
		end

		if v110 then
			v110 = v110.Value > 0
		end

		if v110 then
			t2.value28("Emptying backpack...", 3)
			t2.value30()
		end

		t2.value28("Hive secured.", 2)

		return
	end

	t2.value28("Finding free hive...", 3)
	pairs_ = pairs

	for _, child in pairs_(Honeycombs:GetChildren()) do
		pairs_ = child:FindFirstChild("Owner")

		local v98

		if pairs_ then
			v98 = pairs_.Value == nil and true or pairs_.Value == ""
		else
			v98 = pairs_
		end

		if v98 then
			local boundingBox, v100 = child:GetBoundingBox()

			v49(boundingBox * CFrame.new(0, -v100.Y / 2 + 2, 0))
			task.wait(0.5)

			local n3 = 0

			pairs_ = 0

			while true do
				if true then
					local v102

					if n3 < 5 then
						v102 = not v62()
					else
						v102 = false
					end
				end

				if not v109 then
					v95 = v62()

					break
				end

				v67()
				task.wait(1)
				n3 = n3 + 1
				pairs_ = n3
			end

			return
		end
	end

	if not v95 then
		return
	end

	local CoreStats = t2.value8:FindFirstChild("CoreStats")

	if CoreStats then
		CoreStats = CoreStats:FindFirstChild("Pollen")
	end

	if CoreStats then
		CoreStats = CoreStats.Value > 0
	end

	if CoreStats then
		t2.value28("Emptying backpack...", 3)
		t2.value30()
	end

	t2.value28("Hive secured.", 2)
end

local function v104(p9)
	local v105 = t2.value22:FindFirstChild(p9)
	local Character = t2.value8.Character
	local v107, X, Z, v111

	if Character then
	elseif v105 and Character then
		v107 = v105.CFrame:PointToObjectSpace(Character.Position)
		X = v107.X

		if math.abs(X) <= v105.Size.X / 2 + 2 then
			Z = v107.Z
			v111 = math.abs(Z) <= v105.Size.Z / 2 + 2
		else
			v111 = false
		end

		return v111
	else
		return false
	end

	Character = t2.value8.Character:FindFirstChild("HumanoidRootPart")

	if v105 and Character then
		v107 = v105.CFrame:PointToObjectSpace(Character.Position)
		X = v107.X

		if math.abs(X) <= v105.Size.X / 2 + 2 then
			Z = v107.Z
			v111 = math.abs(Z) <= v105.Size.Z / 2 + 2
		else
			v111 = false
		end

		return v111
	else
		return false
	end
end
local function v112(p10, p11)
	local Character = t2.value8.Character

	if Character then
		Character = t2.value8.Character:FindFirstChild("HumanoidRootPart")
	end

	local Particles = workspace:FindFirstChild("Particles")

	if not (Character and Particles) then
		return nil
	end

	local GetChildren = Particles.GetChildren
	local n4 = 999
	local v116 = nil

	for _, v in pairs(GetChildren(Particles)) do
		if v:IsA("BasePart") then
			local v119 = false

			for _, v2 in pairs(p11) do
				if v.Name:lower():find(v2) then
					v119 = true

					break
				end
			end

			if v119 and (v.Position - p10.Position).Magnitude <= math.max(p10.Size.X, p10.Size.Z) / 2 + 10 then
				local Magnitude = (v.Position - Character.Position).Magnitude

				if Magnitude < n4 then
					v116 = v
					n4 = Magnitude
				end
			end
		end
	end

	return v116
end

t2.value32 = Instance.new("ImageButton", t2.value24)
t2.value32.Size = UDim2.new(0, 60, 0, 60)
t2.value32.Position = UDim2.new(0.5, -22, 0, 10)
t2.value32.BackgroundColor3 = t2.value9

local TouchEnabled = t2.value2.TouchEnabled

if TouchEnabled then
	TouchEnabled = not t2.value2.KeyboardEnabled
end

if TouchEnabled then
	t2.value32.Visible = true
else
	t2.value32.Visible = false
end

t1.value2 = "UDim"
t2.value33 = nil
t2.value33 = "https://raw.githubusercontent.com/sylent345/sylenthub-bss/main/main/icon.png"
pcall(function()
	t2.value32.Image = t2.value25(t2.value33, "SylentHub_MobileIcon.png")
end)

local Instance_ = Instance

t1.value3 = 250
t1.value4 = 0

local UICorner = Instance_.new("UICorner", t2.value32)
local uDimNew = UDim.new

t1.value2 = 0
t1.value5 = 310
UICorner.CornerRadius = uDimNew(t1.value2, 8)

local UIStroke = Instance.new("UIStroke", t2.value32)

t1.value2 = "Instance"
UIStroke.Thickness = 2
UIStroke.Color = t2.value10
v21(t2.value32)
t2.value34 = Instance.new("Frame", t2.value24)

local value34 = t2.value34

t1.value6 = "UDim2"
value34.Size = UDim2.new(0, 480, t1.value4, t1.value5)
t1.value6 = "UDim2"
t1.value5 = -155
t1.value4 = 0.5

local value342 = t2.value34
local UDim2_ = UDim2

t1.value7 = 30
t1.value6 = "new"
value342.Position = UDim2_.new(0.5, -240, t1.value4, t1.value5)
t2.value34.BackgroundColor3 = t2.value9
t2.value34.BorderSizePixel = 0

local instanceNew = Instance.new

t1.value8 = 0
instanceNew("UICorner", t2.value34)

local UIStroke2 = Instance.new("UIStroke", t2.value34)

UIStroke2.Thickness = 2
UIStroke2.Color = t2.value10
UIStroke2.Name = "MainStroke"
v21(t2.value34)

local TextLabel = Instance.new("TextLabel", t2.value34)

t1.value6 = UDim2
t1.value6 = t1.value6.new(1, 0, 0, 30)
TextLabel.Size = t1.value6
t1.value4 = "Enum"
TextLabel.Text = "SylentHub | BSS | @s1lnt"
t1.value10 = "CONFIGS"
TextLabel.TextColor3 = t2.value10

local Enum_ = Enum

t1.value4 = "Font"
TextLabel.Font = Enum_.Font.GothamBold
t1.value5 = "UDim2"
TextLabel.TextSize = 14
TextLabel.BackgroundTransparency = 1
t2.value35 = Instance.new("Frame", t2.value34)
t2.value35.Size = UDim2.new(0, 180, 0, t1.value3)
t1.value5 = "UDim2"

local value35 = t2.value35
local uDim2New2 = UDim2.new

t1.value5 = 1
t1.value3 = 0
value35.Position = uDim2New2(t1.value5, 10, 0, t1.value3)
t2.value35.BackgroundColor3 = t2.value9
t2.value35.Visible = false
Instance.new("UICorner", t2.value35)
Instance.new("UIStroke", t2.value35).Color = t2.value10
t2.value36 = Instance.new("TextBox", t2.value35)
t2.value36.Size = UDim2.new(1, -10, 0, 25)
t2.value36.Position = UDim2.new(0, 5, 0, 5)

local value36 = t2.value36

t1.value3 = 25
t1.value12 = "DISPENSERS"
value36.BackgroundColor3 = Color3.fromRGB(25, 25, t1.value3)
t2.value36.PlaceholderText = "Search..."
t1.value9 = 1
t1.value4 = ""
t2.value36.Text = ""
t2.value36.TextColor3 = Color3.new(1, 1, 1)
t2.value36.Font = Enum.Font.Gotham
t1.value3 = -5
t2.value36.TextSize = 12
Instance.new("UICorner", t2.value36)
t2.value37 = Instance.new("ScrollingFrame", t2.value35)
t2.value37.Size = UDim2.new(1, t1.value3, t1.value9, -40)

local value37 = t2.value37

t1.value5 = UDim2.new
t1.value9 = 0
t1.value13 = 40
t1.value3 = 2
value37.Position = t1.value5(0, t1.value3, t1.value9, 35)
t1.value5 = 1
t1.value3 = "Enum"
t2.value37.BackgroundTransparency = t1.value5
t2.value37.ScrollBarThickness = 2
t2.value37.AutomaticCanvasSize = Enum.AutomaticSize.Y
Instance.new("UIListLayout", t2.value37).Padding = UDim.new(0, 2)

local instanceNew2 = Instance.new

t1.value5 = "Frame"
t1.value3 = "UDim2"
t2.value38 = instanceNew2("Frame", t2.value24)
t2.value38.Size = UDim2.new(0, 150, 0, 70)

local value38 = t2.value38
local UDim2_2 = UDim2

t1.value3 = "new"

local uDim2New3 = UDim2_2.new

t1.value3 = 0.5
t1.value11 = -155
t1.value9 = 250
value38.Position = uDim2New3(t1.value3, t1.value9, 0.5, t1.value11)
t2.value38.BackgroundColor3 = t2.value9
t2.value38.Visible = false
Instance.new("UICorner", t2.value38)

local UIStroke3 = Instance.new("UIStroke", t2.value38)

UIStroke3.Thickness = 2
t1.value11 = 0
UIStroke3.Color = t2.value10
v21(t2.value38)

local TextLabel2 = Instance.new("TextLabel", t2.value38)

TextLabel2.Size = UDim2.new(1, 0, t1.value11, 25)
TextLabel2.Text = "Set Speed (Max 80)"
TextLabel2.TextColor3 = t2.value10
TextLabel2.Font = Enum.Font.GothamBold
TextLabel2.TextSize = 11
t1.value3 = "Instance"
TextLabel2.BackgroundTransparency = 1

local instanceNew3 = Instance.new

t1.value11 = "UDim2"
t2.value39 = instanceNew3("TextBox", t2.value38)

local value39 = t2.value39
local uDim2 = UDim2.new(0.8, 0, 0, t1.value7)

t1.value7 = 30
t1.value11 = "UDim2"
value39.Size = uDim2
t2.value39.Position = UDim2.new(0.1, 0, 0, t1.value7)
t2.value39.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local value392 = t2.value39

t1.value7 = 1
value392.TextColor3 = Color3.new(1, 1, 1)
t2.value39.Font = Enum.Font.Gotham
t2.value39.TextSize = 12

local value393 = t2.value39
local FixedSpeedValue = _G.FixedSpeedValue

value393.Text = tostring(FixedSpeedValue)

local Instance_2 = Instance

t1.value17 = "MAIN"
t1.value9 = "new"
Instance_2.new("UICorner", t2.value39)

local signal = t2.value39:GetPropertyChangedSignal("Text")

function t1.value9()
	local Text = t2.value39.Text
	local fixedSpeedValue = tonumber(Text)

	if not fixedSpeedValue then
		return
	end

	if fixedSpeedValue > 80 then
		t2.value39.Text = "80"
		fixedSpeedValue = 80
	end

	_G.FixedSpeedValue = fixedSpeedValue
end

signal:Connect(t1.value9)

local instanceNew4 = Instance.new

t1.value9 = "Frame"
t2.value40 = instanceNew4("Frame", t2.value34)
t2.value40.Size = UDim2.new(0, 110, t1.value7, -40)

local value40 = t2.value40

t1.value7 = 0
value40.Position = UDim2.new(0, 5, t1.value7, 35)
t2.value40.BackgroundTransparency = 1
t1.value7 = "UDim2"

local UIListLayout2 = Instance.new("UIListLayout", t2.value40)

UIListLayout2.FillDirection = Enum.FillDirection.Vertical
UIListLayout2.Padding = UDim.new(0, 5)
t2.value41 = Instance.new("Frame", t2.value34)
t2.value41.Size = UDim2.new(1, -125, 1, -40)
t1.value7 = "UDim2"
t2.value41.Position = UDim2.new(0, 120, 0, 35)
t2.value41.BackgroundTransparency = 1
t2.value42 = nil
t2.value43 = nil

local function v158(p12)
	local TextButton = Instance.new("TextButton", t2.value40)

	TextButton.Size = UDim2.new(1, 0, 0, 30)
	TextButton.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	TextButton.Text = p12
	TextButton.TextColor3 = t2.value11
	TextButton.Font = Enum.Font.Gotham
	TextButton.TextSize = 11
	Instance.new("UICorner", TextButton)

	local UIStroke4 = Instance.new("UIStroke", TextButton)

	UIStroke4.Color = Color3.fromRGB(40, 40, 40)
	UIStroke4.Thickness = 1

	local ScrollingFrame = Instance.new("ScrollingFrame", t2.value41)

	ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
	ScrollingFrame.BackgroundTransparency = 1
	ScrollingFrame.Visible = false
	ScrollingFrame.ScrollBarThickness = 2
	ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	Instance.new("UIListLayout", ScrollingFrame).Padding = UDim.new(0, 5)
	TextButton.MouseButton1Click:Connect(function()
		if not t2.value42 then
			t2.value42 = ScrollingFrame
			ScrollingFrame.Visible = true
			t2.value43 = TextButton
			v172 = pairs
			v173 = t2.value40

			for _, child in v172(v173.GetChildren(v173)) do
				if child:IsA("TextButton") then
					child.TextColor3 = t2.value11
				end
			end

			TextButton.TextColor3 = t2.value10

			return
		end

		t2.value42.Visible = false
		t2.value42 = ScrollingFrame
		ScrollingFrame.Visible = true
		t2.value43 = TextButton

		local pairs_ = pairs
		local value402 = t2.value40

		for _, child in pairs_(value402.GetChildren(value402)) do
			if child:IsA("TextButton") then
				child.TextColor3 = t2.value11
			end
		end

		TextButton.TextColor3 = t2.value10
	end)

	return ScrollingFrame, TextButton
end

local info, v169 = v158("INFO")

t1.value18 = info

local main, v171 = v158("MAIN")

t1.value17 = main
t1.value7 = v171

function t1.value7(p13, p14, p15, p16, p17)
	local TextButton = Instance.new("TextButton", p13)

	TextButton.Size = UDim2.new(1, -5, 0, 30)
	TextButton.BackgroundColor3 = t2.value9

	local u173 = p16 or false

	TextButton.Text = p14 .. ": " .. (u173 and "ON" or "OFF")

	if u173 then
		local value10 = t2.value10
	end

	TextButton.TextColor3 = v188 or t2.value11
	TextButton.Font = Enum.Font.Gotham
	TextButton.TextSize = 11
	Instance.new("UICorner", TextButton)
	TextButton.MouseButton1Click:Connect(function()
		u173 = not u173
		TextButton.Text = p14 .. ": " .. (u173 and "ON" or "OFF")

		local v175 = TextButton
		local value10 = u173

		if not value10 then
			v175.TextColor3 = value10 or t2.value11
			p15(u173)

			return
		end

		value10 = t2.value10
		v175.TextColor3 = value10 or t2.value11
		p15(u173)
	end)

	if not p17 then
		return TextButton
	end

	_G.ConfigSetters[p17] = function(p18)
		u173 = p18
		TextButton.Text = p14 .. ": " .. (u173 and "ON" or "OFF")
		TextButton.TextColor3 = u173 and t2.value10 or t2.value11
		p15(u173)
	end

	return TextButton
end

local combat = v158("COMBAT")

t1.value16 = combat

local dispensers, v180 = v158("DISPENSERS")

t1.value12 = dispensers
t1.value10 = v180

local stickers = v158("STICKERS")

t1.value15 = stickers

local settings = v158("SETTINGS")
local configs = v158("CONFIGS")

t1.value10 = configs

local TextLabel3 = Instance.new("TextLabel", t1.value18)

TextLabel3.Size = UDim2.new(1, t1.value8, 0, t1.value13)
TextLabel3.BackgroundTransparency = 1
TextLabel3.Text = "SylentHub V1.0"
TextLabel3.TextColor3 = t2.value10
t1.value8 = "Enum"
t1.value13 = 0
TextLabel3.Font = Enum.Font.GothamBold
TextLabel3.TextSize = 16

local TextLabel4 = Instance.new("TextLabel", t1.value18)

t1.value8 = "UDim2"
TextLabel4.Size = UDim2.new(1, 0, t1.value13, 200)
t1.value8 = "Color3"
t1.value13 = 0.8
TextLabel4.BackgroundTransparency = 1
TextLabel4.Text = "Status: Connected\nGame: Bee Swarm Simulator\n\nUpdates:\n- Added Auto Mondo Chick Combat\n- Optimized priority targeting\n- Added Auto-Sprinkler"

local Color3_ = Color3

t1.value8 = "new"
TextLabel4.TextColor3 = Color3_.new(0.8, 0.8, t1.value13)
TextLabel4.Font = Enum.Font.Gotham
TextLabel4.TextSize = 12
t1.value14 = true
TextLabel4.TextYAlignment = Enum.TextYAlignment.Top
t1.value18.Visible = true

local value18 = t1.value18

t1.value13 = "Text"
t2.value42 = value18
t2.value43 = v169
v169.TextColor3 = t2.value10

local function v191(p19)
	local pairs_ = pairs
	local value372 = t2.value37

	for _, child in pairs_(value372.GetChildren(value372)) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	for _, v in pairs(t2.value23) do
		local v198 = p19 == ""

		if not v198 then
			local v199 = v:lower()

			v198 = v199.find(v199, p19.lower(p19))
		end

		if v198 then
			local TextButton = Instance.new("TextButton", t2.value37)

			TextButton.Size = UDim2.new(1, -5, 0, 25)
			TextButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
			TextButton.Text = v
			TextButton.TextColor3 = t2.value11
			TextButton.Font = Enum.Font.Gotham
			TextButton.TextSize = 10
			Instance.new("UICorner", TextButton)

			local function v201()
				_G.SelectedField = v
				_G.FieldBtn.Text = "Field: " .. v
				t2.value35.Visible = false
			end

			TextButton.MouseButton1Click:Connect(v201)
		end
	end
end

local signal2 = t2.value36:GetPropertyChangedSignal("Text")

function t1.value13()
	v191(t2.value36.Text)
end

signal2:Connect(t1.value13)
t1.value7(t1.value17, "Ignore Honey", function(p20)
	_G.IgnoreHoney = p20
end, t1.value14, "IgnoreHoney")
_G.FieldBtn = Instance.new("TextButton", t1.value17)
t1.value8 = _G.FieldBtn
t1.value8.Size = UDim2.new(1, -5, 0, 30)
t1.value8 = _G.FieldBtn
t1.value8.BackgroundColor3 = t2.value9
t1.value8 = _G.FieldBtn
t1.value14 = _G.SelectedField
t1.value8.Text = "Field: " .. t1.value14
t1.value8 = _G.FieldBtn
t1.value8.TextColor3 = t2.value10
t1.value8 = _G.FieldBtn
t1.value8.Font = Enum.Font.Gotham
t1.value8 = _G.FieldBtn
t1.value13 = 11
t1.value8.TextSize = t1.value13
Instance.new("UICorner", _G.FieldBtn)
_G.FieldBtn.MouseButton1Click:Connect(function()
	t2.value35.Visible = not t2.value35.Visible

	if not t2.value35.Visible then
		return
	end

	v191("")
end)
t1.value14 = false
t1.value13 = "_G"
t1.value8 = _G.ConfigSetters

function t1.value8.Field(p21)
	_G.SelectedField = p21
	_G.FieldBtn.Text = "Field: " .. p21
end

t1.value7(t1.value17, "Farm", function(p22)
	_G.FarmActive = p22

	if p22 then
		p22 = not _G.IsConverting

		if p22 then
			p22 = not _G.IsFightingMondo
		end
	end

	local _GSelectedField = p22 and t2.value22:FindFirstChild(_G.SelectedField)

	if not _GSelectedField then
		return
	end

	v49(_GSelectedField.CFrame + Vector3.new(0, 5, 0))
end)
t1.value7(t1.value17, "Convert Balloons", function(p23)
	_G.AutoConvertBalloons = p23

	if not p23 then
		return
	end

	_G.LastBalloonConvertTime = tick()
end, t1.value14, "ConvertBalloons")
t1.value13 = 1
t1.value14 = 60
(function(p24, p25, p26, p27, p28, p29, p30)
	local Frame = Instance.new("Frame", p24)

	Frame.Size = UDim2.new(1, -5, 0, 40)
	Frame.BackgroundColor3 = t2.value9
	Instance.new("UICorner", Frame)

	local TextLabel5 = Instance.new("TextLabel", Frame)

	TextLabel5.Size = UDim2.new(1, -10, 0, 20)
	TextLabel5.Position = UDim2.new(0, 5, 0, 0)
	TextLabel5.BackgroundTransparency = 1
	TextLabel5.Text = p25 .. ": " .. p28
	TextLabel5.TextColor3 = t2.value10
	TextLabel5.Font = Enum.Font.Gotham
	TextLabel5.TextSize = 11
	TextLabel5.TextXAlignment = Enum.TextXAlignment.Left

	local Frame2 = Instance.new("Frame", Frame)

	Frame2.Size = UDim2.new(1, -10, 0, 10)
	Frame2.Position = UDim2.new(0, 5, 0, 25)
	Frame2.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Instance.new("UICorner", Frame2)

	local Frame3 = Instance.new("Frame", Frame2)

	Frame3.Size = UDim2.new((p28 - p26) / (p27 - p26), 0, 1, 0)
	Frame3.BackgroundColor3 = t2.value10
	Instance.new("UICorner", Frame3)

	local TextButton = Instance.new("TextButton", Frame2)

	TextButton.Size = UDim2.new(1, 0, 1, 0)
	TextButton.BackgroundTransparency = 1
	TextButton.Text = ""

	local function v209(p31, p32)
		local v210

		if p32 then
			v210 = (p31 - p26) / (p27 - p26)
		else
			local v211 = (p31.Position.X - Frame2.AbsolutePosition.X) / Frame2.AbsoluteSize.X

			v210 = math.clamp(v211, 0, 1)

			local v212 = p26 + (p27 - p26) * v210

			p31 = math.floor(v212)
		end

		Frame3.Size = UDim2.new(v210, 0, 1, 0)
		TextLabel5.Text = p25 .. ": " .. p31
		p29(p31)
	end

	local u213 = nil

	local function v214(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		u213 = true
		v209(input, false)
	end

	u213 = false
	TextButton.InputBegan:Connect(v214)

	local function v215(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		u213 = false
	end

	TextButton.InputEnded:Connect(v215)
	t2.value15(t2.value2.InputChanged:Connect(function(input)
		local v216 = u213

		if v216 then
			v216 = input.UserInputType == Enum.UserInputType.MouseMovement
		end

		if not v216 then
			return
		end

		v209(input, false)
	end))

	if not p30 then
		return
	end

	_G.ConfigSetters[p30] = function(p33)
		local v217 = (p33 - p26) / (p27 - p26)

		Frame3.Size = UDim2.new(v217, 0, 1, 0)
		TextLabel5.Text = p25 .. ": " .. p33
		p29(p33)
	end
end)(t1.value17, "Balloon Timer (Mins)", t1.value13, t1.value14, 30, function(p34)
	_G.BalloonConvertInterval = p34
end, "BalloonTimer")

function t1.value13(p35)
	_G.FarmBubbles = p35
end

t1.value14 = false
t1.value7(t1.value17, "Farm Bubbles", t1.value13, t1.value14, "FarmBubbles")

function t1.value13(p36)
	_G.FarmBloom = p36
end

t1.value14 = false
t1.value7(t1.value17, "Farm Blooms", t1.value13, t1.value14, "FarmBlooms")
t2.value44 = Instance.new("TextButton", t1.value17)
t2.value44.Size = UDim2.new(1, -5, 0, 30)
t2.value44.BackgroundColor3 = t2.value9

local WalkMode = _G.WalkMode

t2.value44.Text = "Walk Mode: " .. WalkMode
t2.value44.TextColor3 = t2.value10
t2.value44.Font = Enum.Font.Gotham
t1.value14 = 11
t1.value13 = "TextSize"
t2.value44.TextSize = t1.value14
Instance.new("UICorner", t2.value44)

local MouseButton1Click = t2.value44.MouseButton1Click

function t1.value14()
	t2.value17 = t2.value17 + 1

	if not (t2.value17 > #t2.value16) then
		_G.WalkMode = t2.value16[t2.value17]
		t2.value44.Text = "Walk Mode: " .. _G.WalkMode

		return
	end

	t2.value17 = 1
	_G.WalkMode = t2.value16[t2.value17]
	t2.value44.Text = "Walk Mode: " .. _G.WalkMode
end

MouseButton1Click:Connect(t1.value14)

function _G.ConfigSetters.WalkMode(p37)
	_G.WalkMode = p37

	local WalkMode2 = _G.WalkMode

	t2.value44.Text = "Walk Mode: " .. WalkMode2

	for i, v in ipairs(t2.value16) do
		if v == p37 then
			t2.value17 = i

			return
		end
	end
end

t1.value13 = Instance.new("TextButton", t1.value17)
t2.value45 = t1.value13
t2.value45.Size = UDim2.new(1, -5, 0, 30)
t2.value45.BackgroundColor3 = t2.value9
Instance.new("UICorner", t2.value45)
t2.value45.Text = "Auto-Dig: " .. (_G.AutoDig and "ON" or "OFF")

local value45 = t2.value45
local AutoDig = _G.AutoDig

if AutoDig then
	AutoDig = t2.value10
end

value45.TextColor3 = AutoDig or t2.value11
t1.value14 = t2.value45.MouseButton1Click
t1.value14:Connect(function()
	_G.AutoDig = not _G.AutoDig
	t2.value45.Text = "Auto-Dig: " .. (_G.AutoDig and "ON" or "OFF")

	local value452 = t2.value45
	local AutoDig2 = _G.AutoDig

	if not AutoDig2 then
		value452.TextColor3 = AutoDig2 or t2.value11

		return
	end

	AutoDig2 = t2.value10
	value452.TextColor3 = AutoDig2 or t2.value11
end)
t1.value14 = _G.ConfigSetters

function t1.value14.AutoDig(p38)
	_G.AutoDig = p38
	t2.value45.Text = "Auto-Dig: " .. (_G.AutoDig and "ON" or "OFF")

	local value452 = t2.value45
	local AutoDig2 = _G.AutoDig

	if not AutoDig2 then
		value452.TextColor3 = AutoDig2 or t2.value11

		return
	end

	AutoDig2 = t2.value10
	value452.TextColor3 = AutoDig2 or t2.value11
end

t1.value14 = t1.value17:FindFirstChildOfClass("UIListLayout")

if t1.value14 then
	local LayoutOrder = Enum.SortOrder.LayoutOrder

	t1.value14.SortOrder = LayoutOrder
end

local Frame = Instance.new("Frame", t1.value17)

Frame.Name = "SprinklerSection"
Frame.Size = UDim2.new(1, -5, 0, 0)
Frame.BackgroundTransparency = 1
Frame.AutomaticSize = Enum.AutomaticSize.Y
t1.value14 = "LayoutOrder"
Frame.LayoutOrder = 999
t1.value18 = Instance.new("UIListLayout", Frame)
t1.value18.SortOrder = Enum.SortOrder.LayoutOrder
t1.value14 = "Padding"
t1.value18.Padding = UDim.new(0, 5)
t1.value14 = Instance.new
t1.value18 = 1

local Frame2 = t1.value14("Frame", Frame)

Frame2.Size = UDim2.new(1, 0, 0, 30)
t1.value14 = "BackgroundTransparency"
Frame2.BackgroundTransparency = 1
t1.value14 = "LayoutOrder"
Frame2.LayoutOrder = 1
t2.value46 = Instance.new("TextButton", Frame2)
t2.value46.Size = UDim2.new(1, -35, t1.value18, 0)
t2.value46.BackgroundColor3 = t2.value9
t2.value46.Font = Enum.Font.Gotham
t2.value46.TextSize = 11

local instanceNew5 = Instance.new

t1.value17 = "UDim2"
instanceNew5("UICorner", t2.value46)

local TextButton = Instance.new("TextButton", Frame2)

TextButton.Size = UDim2.new(0, 30, 1, 0)

local UDim2_3 = UDim2

t1.value17 = "new"
t1.value18 = 0

local uDim2New4 = UDim2_3.new

t1.value17 = 1
TextButton.Position = uDim2New4(t1.value17, -30, t1.value18, 0)
TextButton.BackgroundColor3 = t2.value9
TextButton.Text = "⚙️"
TextButton.TextColor3 = t2.value10
TextButton.Font = Enum.Font.GothamBold
TextButton.TextSize = 14
Instance.new("UICorner", TextButton)
t2.value47 = Instance.new("Frame", Frame)
t1.value18 = "UDim2"
t2.value47.Size = UDim2.new(1, 0, 0, 0)
t2.value47.BackgroundTransparency = 1
t2.value47.AutomaticSize = Enum.AutomaticSize.Y
t2.value47.Visible = false
t2.value47.LayoutOrder = 2

local UIListLayout3 = Instance.new("UIListLayout", t2.value47)

UIListLayout3.Padding = UDim.new(0, 3)
UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
t2.value48 = {}

function t2.value49()
	t2.value46.Text = "Auto-Sprinkler: " .. (_G.AutoSprinkler and "ON" or "OFF")

	local value46 = t2.value46
	local AutoSprinkler = _G.AutoSprinkler

	if not AutoSprinkler then
		value46.TextColor3 = AutoSprinkler or t2.value11

		return
	end

	AutoSprinkler = t2.value10
	value46.TextColor3 = AutoSprinkler or t2.value11
end

TextButton.MouseButton1Click:Connect(function()
	local Visible = t2.value47.Visible

	t2.value47.Visible = not Visible
end)

for _, v in ipairs(TextButton) do
	local TextButton2 = Instance.new("TextButton", t2.value47)

	TextButton2.Size = UDim2.new(1, -10, 0, 25)
	TextButton2.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
	TextButton2.Text = "•  " .. v

	local value10

	if _G.SelectedSprinkler == v then
		value10 = t2.value10
	else
		value10 = false
	end

	TextButton2.TextColor3 = value10 or t2.value11
	TextButton2.Font = Enum.Font.Gotham
	TextButton2.TextSize = 10
	TextButton2.TextXAlignment = Enum.TextXAlignment.Left
	Instance.new("UICorner", TextButton2)
	Instance.new("UIPadding", TextButton2).PaddingLeft = UDim.new(0, 10)
	TextButton2.MouseButton1Click:Connect(function()
		_G.SelectedSprinkler = v

		for _, v2 in pairs(t2.value48) do
			v2.TextColor3 = t2.value11
		end

		TextButton2.TextColor3 = t2.value10
	end)
	table.insert(t2.value48, TextButton2)
end

t2.value46.MouseButton1Click:Connect(function()
	_G.AutoSprinkler = not _G.AutoSprinkler
	t2.value49()
end)

function _G.ConfigSetters.AutoSprinkler(p39)
	_G.AutoSprinkler = p39
	t2.value49()
end
function _G.ConfigSetters.SelectedSprinkler(p40)
	_G.SelectedSprinkler = p40

	for _, v in pairs(t2.value48) do
		local pos = v.Text:find(p40)

		if pos then
			pos = t2.value10
		end

		v.TextColor3 = pos or t2.value11
	end
end

t2.value49()

function t1.value18(p41)
	if _G.IsPlantingSprinklers then
		return
	end

	_G.IsPlantingSprinklers = true

	local Character = t2.value8.Character
	local HumanoidRootPart

	if Character then
		HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	else
		HumanoidRootPart = Character
	end

	if Character then
		Character = Character:FindFirstChildOfClass("Humanoid")
	end

	if not (HumanoidRootPart and (Character and p41)) then
		_G.IsPlantingSprinklers = false

		return
	end

	local function v251()
		local function v252()
			local Events = t2.value6:FindFirstChild("Events")
			local PlayerActivesCommand

			if Events then
				PlayerActivesCommand = Events:FindFirstChild("PlayerActivesCommand")
			else
				PlayerActivesCommand = Events
			end

			if not PlayerActivesCommand then
				return
			end

			local PlayerActivesCommand2 = Events.PlayerActivesCommand
			local t3 = {
				Name = _G.SelectedSprinkler
			}

			PlayerActivesCommand2.FireServer(PlayerActivesCommand2, t3)
			Events.PlayerActivesCommand:FireServer({
				Name = "Sprinkler Builder"
			})
		end

		pcall(v252)
	end

	local Position = p41.CFrame.Position
	local pairs_ = pairs
	local workspace_ = workspace
	local v260 = false

	for _, child in pairs_(workspace_.GetChildren(workspace_)) do
		local pos = child.Name:find("Planter")

		if pos then
			pos = child:IsA("BasePart") or child:IsA("Model")
		end

		if pos then
			local isModel = child:IsA("Model")

			if isModel then
				isModel = child:GetPivot().Position
			end

			local Position2 = isModel or child.Position

			if (Vector3.new(Position2.X, 0, Position2.Z) - Vector3.new(Position.X, 0, Position.Z)).Magnitude < 20 then
				v260 = true
				pairs_ = true

				break
			end
		end
	end

	if v260 then
		Position = Position + Vector3.new(15, 0, 15)
	end

	local t4 = {
		Vector3.new(0, 0, 0),
		Vector3.new(-14, 0, 0),
		Vector3.new(14, 0, 0),
		Vector3.new(0, 0, 14)
	}
	local v267 = _G.SelectedSprinkler == "Silver Sprinkler" and 2 or (_G.SelectedSprinkler == "Golden Sprinkler" and 3 or (_G.SelectedSprinkler == "Diamond Sprinkler" and 4 or (_G.SelectedSprinkler == "Supreme Sprinkler" and 1 or 1)))
	local FixedSpeed = _G.FixedSpeed

	_G.FixedSpeed = false
	Character.WalkSpeed = 30

	for i = 1, v267 do
		if not (_G.SylentHubActive and _G.FarmActive) then
			break
		end

		local v270 = t4[i]
		local vector3 = Vector3.new(Position.X + v270.X, HumanoidRootPart.Position.Y, Position.Z + v270.Z)

		Character:MoveTo(vector3)

		local v272 = tick() + 5
		local _ = i

		while true do
			local SylentHubActive = _G.SylentHubActive

			if SylentHubActive then
				if HumanoidRootPart then
					SylentHubActive = Character.Health > 0
				else
					SylentHubActive = HumanoidRootPart
				end
			end

			if not SylentHubActive or ((Vector3.new(HumanoidRootPart.Position.X, 0, HumanoidRootPart.Position.Z) - Vector3.new(vector3.X, 0, vector3.Z)).Magnitude <= 3 or v272 < tick()) then
				break
			end

			Character:MoveTo(vector3)
			task.wait(0.05)
		end

		Character:MoveTo(HumanoidRootPart.Position)
		HumanoidRootPart.Velocity = Vector3.zero
		task.wait(0.2)

		if i == 1 then
			v251()
		else
			Character.Jump = true
			task.wait(0.2)
			v251()
		end

		task.wait(0.8)
	end

	_G.FixedSpeed = FixedSpeed

	if not _G.FixedSpeed then
		_G.IsPlantingSprinklers = false

		return
	end

	Character.WalkSpeed = _G.FixedSpeedValue
	_G.IsPlantingSprinklers = false
end

t2.value50 = t1.value18
t1.value18 = nil
t2.value51 = t1.value18
task.spawn(function()
	while _G.SylentHubActive do
		task.wait(1)

		local AutoSprinkler = _G.AutoSprinkler

		if AutoSprinkler then
			AutoSprinkler = _G.FarmActive

			if AutoSprinkler then
				AutoSprinkler = not _G.IsConverting

				if AutoSprinkler then
					AutoSprinkler = not _G.IsFightingMondo
				end
			end
		end

		if AutoSprinkler then
			local _GSelectedField = t2.value22:FindFirstChild(_G.SelectedField)

			if _GSelectedField and (t2.value51 ~= _G.SelectedField and v104(_G.SelectedField)) then
				t2.value50(_GSelectedField)
				t2.value51 = _G.SelectedField
			end
		elseif not _G.FarmActive then
			t2.value51 = nil
		end
	end
end)
t1.value7(t1.value16, "Auto Mondo Chick", function(p42)
	_G.AutoMondo = p42
end, false, "AutoMondo")
t1.value18 = task.spawn
t1.value18(function()
	while true do
		if not _G.SylentHubActive then
			return
		end

		task.wait(1)

		if _G.AutoMondo and not _G.IsConverting then
			local Monsters = workspace:FindFirstChild("Monsters") or workspace
			local GetChildren = Monsters.GetChildren
			local pairs_ = pairs
			local v280 = nil

			for _, v in pairs_(GetChildren(Monsters)) do
				local pos = v.Name:find("Mondo")

				if pos then
					pos = v:FindFirstChild("Humanoid")

					if pos then
						pos = v.Humanoid.Health > 0
					end
				end

				if pos then
					pairs_ = v
					v280 = pairs_

					local v284 = pairs_

					pairs_ = v280
					v284 = v280

					break
				end
			end

			if v280 then
				_G.IsFightingMondo = true
				t2.value28("Mondo Chick spawned! Intercepting...", 4)

				local MountainTopField = t2.value22:FindFirstChild("Mountain Top Field")

				if MountainTopField then
					v49(MountainTopField.CFrame + Vector3.new(0, 5, 0))
					task.wait(0.5)

					while true do
						local SylentHubActive = _G.SylentHubActive

						if SylentHubActive then
							SylentHubActive = _G.AutoMondo

							if SylentHubActive then
								SylentHubActive = v280.Parent

								if SylentHubActive then
									SylentHubActive = v280:FindFirstChild("Humanoid")

									if SylentHubActive then
										SylentHubActive = v280.Humanoid.Health > 0
									end
								end
							end
						end

						if not SylentHubActive or _G.IsConverting then
							break
						end

						task.wait(0.05)

						local Character = t2.value8.Character
						local HumanoidRootPart

						if Character then
							HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
						else
							HumanoidRootPart = Character
						end

						if Character then
							Character = Character:FindFirstChild("Humanoid")
						end

						if not HumanoidRootPart or (not Character or Character.Health <= 0) then
							task.wait(1)
						elseif (HumanoidRootPart.Position - MountainTopField.Position).Magnitude > 100 then
							v49(MountainTopField.CFrame + Vector3.new(0, 5, 0))
							task.wait(0.5)
						else
							local HumanoidRootPart2 = v280:FindFirstChild("HumanoidRootPart") or v280.PrimaryPart

							if HumanoidRootPart and HumanoidRootPart2 then
								local v290 = nil
								local Collectibles = workspace:FindFirstChild("Collectibles")
								local Magnitude = (HumanoidRootPart.Position - HumanoidRootPart2.Position).Magnitude
								local n5 = 35

								if Collectibles then
									for _, child in pairs(Collectibles.GetChildren(Collectibles)) do
										local isBasePart = child:IsA("BasePart")

										if isBasePart then
											isBasePart = child.Transparency < 0.5
										end

										if isBasePart and ((child.Position - MountainTopField.Position).Magnitude < 45 and (child.Position - HumanoidRootPart2.Position).Magnitude > 30) then
											local v297 = child.Name:lower()

											if v297:find("vicious") or (v297:find("spike") or (v297:find("impale") or (v297.find(v297, "focus") or v297:find("melody")))) then
												v290 = child

												break
											end
										end
									end
								end

								local v298

								if v290 then
									v298 = Magnitude > 30
								else
									v298 = v290
								end

								local Position

								if v298 then
									Position = v290.Position
								elseif Magnitude < n5 then
									local Unit = (HumanoidRootPart.Position - HumanoidRootPart2.Position).Unit
									local Unit2 = Vector3.new(Unit.X, 0, Unit.Z).Unit

									Position = HumanoidRootPart.Position + Unit2 * 40
								else
									if not _G.MondoWanderPos or ((HumanoidRootPart.Position - _G.MondoWanderPos).Magnitude < 5 and true or tick() - (_G.MondoWanderTime or 0) > 2.5) then
										local v302 = (math.random() - 0.5) * (MountainTopField.Size.X - 15)
										local v303 = (math.random() - 0.5) * (MountainTopField.Size.Z - 15)

										_G.MondoWanderPos = (MountainTopField.CFrame * CFrame.new(v302, 0, v303)).Position
										_G.MondoWanderTime = tick()
									end

									Position = _G.MondoWanderPos
								end

								local v304 = Position - MountainTopField.Position
								local vector3 = Vector3.new(v304.X, 0, v304.Z)

								if vector3.Magnitude > 40 then
									Position = MountainTopField.Position + vector3.Unit * 40
								end

								Character:MoveTo(Position)
							end
						end
					end
				end

				_G.IsFightingMondo = false
				t2.value28("Mondo Chick defeated or despawned.", 3)

				local FarmActive = _G.FarmActive

				if FarmActive then
					FarmActive = not _G.IsConverting
				end

				local _GSelectedField = FarmActive and t2.value22:FindFirstChild(_G.SelectedField)

				if _GSelectedField then
					v49(_GSelectedField.CFrame + Vector3.new(0, 5, 0))
				end

				task.wait(10)
			end
		end
	end
end)
t1.value7(t1.value12, "[MASTER] Auto Dispensers", function(p43)
	_G.AutoDispensers = p43

	if not p43 then
		return
	end

	for k, dispToggle in pairs(_G.DispToggles) do
		if dispToggle then
			_G.DispenserCooldowns[k] = 0
		end
	end
end, false, "MasterDispenser")
t2.value52 = {
	{ "Blueberry", "Blueberry Dispenser" },
	{ "Strawberry", "Strawberry Dispenser" },
	{ "Coconut", "Coconut Dispenser" },
	{ "Treat", "Treat Dispenser" },
	{ "Robo Pass", "Robo Pass Dispenser" },
	{ "Free Royal Jelly", "Free Royal Jelly Dispenser" },
	{ "Ant Pass", "Ant Pass Dispenser" }
}

local function v310(p44)
	t2.value28("Checking " .. p44 .. "...", 2)

	local pairs_ = pairs
	local workspace_ = workspace
	local PrimaryPart = nil

	for _, descendant in pairs_(workspace_.GetDescendants(workspace_)) do
		local lower = p44.lower
		local pos = descendant.Name:lower():find(unpack_({ lower(p44) }))

		if pos then
			pos = descendant:IsA("BasePart") or descendant:IsA("Model")
		end

		if pos then
			pairs_ = descendant:IsA("Model")

			if pairs_ then
				PrimaryPart = descendant.PrimaryPart or descendant:FindFirstChildWhichIsA("BasePart")
			else
				pairs_ = descendant
				PrimaryPart = pairs_

				local v318 = pairs_

				pairs_ = PrimaryPart
				v318 = PrimaryPart
			end

			if PrimaryPart then
				break
			end
		end
	end

	if not PrimaryPart then
		return
	end

	local v319 = PrimaryPart.CFrame + Vector3.new(0, 3, 0)

	v49(v319)
	task.wait(0.5)

	local Character = t2.value8.Character

	if Character then
		Character = t2.value8.Character:FindFirstChild("HumanoidRootPart")
	end

	if Character then
		Character = (Character.Position - v319.Position).Magnitude > 15
	end

	if Character then
		v49(v319)
	end

	v67()
	task.wait(1)
end

for _, v in pairs(t2.value52) do
	local v323 = "Dispenser: " .. v[1]

	t1.value16 = v
	t1.value7(t1.value12, v323, function(p45)
		_G.DispToggles[v[2]] = p45

		if not p45 then
			return
		end

		_G.DispenserCooldowns[v[2]] = 0

		if _G.AutoDispensers then
			return
		end

		t2.value28("Enable [MASTER] Auto Dispensers to collect!", 3)
	end, false, "Disp_" .. t1.value16[2])
end

task.spawn(function()
	while true do
		if not _G.SylentHubActive then
			return
		end

		task.wait(1)

		if not (_G.IsConverting or _G.IsFightingMondo) and _G.AutoDispensers then
			local pairs_ = pairs
			local t5 = {}

			for k, dispToggle in pairs_(_G.DispToggles) do
				if dispToggle then
					local v328 = _G.DispenserCooldowns[k] or 0

					if (k == "Treat Dispenser" and 3600 or (k == "Free Royal Jelly Dispenser" and 72000 or 10800)) <= tick() - v328 then
						table.insert(t5, k)
					end
				end
			end

			if #t5 > 0 then
				local FarmActive = _G.FarmActive

				_G.FarmActive = false
				task.wait(1)

				for _, v in ipairs(t5) do
					if not (_G.AutoDispensers and (_G.SylentHubActive and _G.DispToggles[v])) or (_G.IsConverting or _G.IsFightingMondo) then
						break
					end

					if not (t2.value8.Character and t2.value8.Character:FindFirstChild("HumanoidRootPart")) then
						t2.value8.CharacterAdded:Wait()
						task.wait(2)
					end

					v310(v)
					_G.DispenserCooldowns[v] = tick()
					task.wait(1.5)
				end

				_G.FarmActive = FarmActive
			end
		end
	end
end)
t2.value53 = 0
t1.value7(t1.value15, "Auto Loot Hidden Stickers", function(p46)
	_G.AutoStickers = p46
end, false, "AutoStickers")
task.spawn(function()
	while true do
		if not _G.SylentHubActive then
			return
		end

		task.wait(1)

		if not (_G.IsConverting or _G.IsFightingMondo) and _G.AutoStickers then
			local v332 = false
			local HiddenStickers = workspace:FindFirstChild("HiddenStickers")

			if HiddenStickers then
				HiddenStickers = HiddenStickers:GetChildren()
			end

			local descendants = HiddenStickers or workspace:GetDescendants()
			local ipairs_ = ipairs

			for k, descendant in ipairs_(descendants) do
				if k % 400 == 0 then
					ipairs_ = task.wait
					ipairs_()
				end

				if not _G.AutoStickers or (not _G.SylentHubActive or (_G.IsConverting or _G.IsFightingMondo)) then
					break
				end

				local isBasePart = descendant:IsA("BasePart") or descendant:IsA("Model")

				if isBasePart then
					isBasePart = descendant.Name:lower():find("sticker")

					if isBasePart then
						local Name = descendant.Name

						isBasePart = not Name.lower(Name):find("planter")

						if isBasePart then
							isBasePart = not descendant:IsDescendantOf(t2.value8.Character)
						end
					end
				end

				if isBasePart then
					local v340 = descendant.FindFirstChildWhichIsA(descendant, "ProximityPrompt", true)
					local ClickDetector = descendant:FindFirstChildWhichIsA("ClickDetector", true)

					if v340 or (ClickDetector or descendant:FindFirstChild("TouchInterest", true)) then
						ipairs_ = true

						local FarmActive = _G.FarmActive

						_G.FarmActive = false

						local Name = descendant.Name

						t2.value28("Looting sticker: " .. Name, 2)

						local ok, result = pcall(function()
							return descendant:IsA("Model") and descendant:GetPivot().Position or descendant.Position
						end)

						if ok and result then
							local cFrame = CFrame.new(result + Vector3.new(0, 2, 0))

							v49(cFrame)
							task.wait(0.3)

							local Character = t2.value8.Character

							if Character then
								Character = t2.value8.Character:FindFirstChild("HumanoidRootPart")
							end

							if Character then
								Character = (Character.Position - cFrame.Position).Magnitude > 15
							end

							if Character then
								v49(cFrame)
							end

							local fireproximityprompt_

							if v340 then
								fireproximityprompt_ = fireproximityprompt
							else
								fireproximityprompt_ = v340
							end

							if fireproximityprompt_ then
								fireproximityprompt(v340)
							end

							local fireclickdetector_

							if ClickDetector then
								fireclickdetector_ = fireclickdetector
							else
								fireclickdetector_ = ClickDetector
							end

							if fireclickdetector_ then
								fireclickdetector(ClickDetector)
							end

							v67()
							task.wait(0.5)
						end

						local v350

						if FarmActive then
							v350 = not _G.IsConverting

							if v350 then
								v350 = not _G.IsFightingMondo
							end
						else
							v350 = FarmActive
						end

						local _GSelectedField = v350 and t2.value22:FindFirstChild(_G.SelectedField)

						if _GSelectedField then
							v49(_GSelectedField.CFrame + Vector3.new(0, 5, 0))
							task.wait(0.5)
						end

						_G.FarmActive = FarmActive
						v332 = ipairs_
					else
						ipairs_ = descendant
					end
				end
			end

			if v332 then
				task.wait(1)
			else
				if tick() - t2.value53 > 60 then
					t2.value28("Hidden stickers not found on map.", 3)
					t2.value53 = tick()
				end

				task.wait(5)
			end
		end
	end
end)

function t2.value54(p47)
	local Character = t2.value8.Character
	local v353, n6, v355, isBasePart, v357, n7, FarmBloom, v360

	if not Character then
		v393 = workspace:FindFirstChild("Collectibles")

		if Character and (v393 and p47) then
			v353 = math.max(p47.Size.X, p47.Size.Z) / 2 + 10
			n6 = 999
			v355 = nil

			for _, child in pairs(v393:GetChildren()) do
				isBasePart = child:IsA("BasePart")

				if isBasePart then
					isBasePart = child.Transparency < 0.5
				end

				if isBasePart then
					if not t2.value18[child] then
						if v353 >= (child.Position - p47.Position).Magnitude then
							v357 = child.Name:lower()

							if not (_G.IgnoreHoney and v357:find("honey") or v357:find("loot")) then
								if (child.Position - Character.Position).Magnitude < 150 then
									n7 = 99
									FarmBloom = _G.FarmBloom

									if FarmBloom then
										FarmBloom = v357:find("bloom") or v357:find("petal")
									end

									v360 = FarmBloom and 0 or (v357:find("link") and 1 or (v357:find("bear morph") and 2 or ((v357:find("inspire") or (v357:find("focus") or (v357:find("melody") or v357:find("baby love")))) and 3 or ((v357:find("frog") or (v357:find("tabby love") or (v357:find("ballon") or v357:find("balloon")))) and 4 or ((v357:find("boost") or (v357:find("bomb") or (v357:find("festive gift") or (v357:find("mark") or v357:find("fuzz"))))) and 5 or n7)))))

									if v360 < n6 then
										v355 = child
										n6 = v360
									end
								end
							end
						end
					end
				end
			end

			return v355
		else
			return nil
		end
	end

	Character = t2.value8.Character:FindFirstChild("HumanoidRootPart")

	local Collectibles = workspace:FindFirstChild("Collectibles")

	if Character and (Collectibles and p47) then
		v353 = math.max(p47.Size.X, p47.Size.Z) / 2 + 10
		n6 = 999
		v355 = nil

		for _, child in pairs(Collectibles:GetChildren()) do
			isBasePart = child:IsA("BasePart")

			if isBasePart then
				isBasePart = child.Transparency < 0.5
			end

			if isBasePart then
				if not t2.value18[child] then
					if v353 >= (child.Position - p47.Position).Magnitude then
						v357 = child.Name:lower()

						if not (_G.IgnoreHoney and v357:find("honey") or v357:find("loot")) then
							if (child.Position - Character.Position).Magnitude < 150 then
								n7 = 99
								FarmBloom = _G.FarmBloom

								if FarmBloom then
									FarmBloom = v357:find("bloom") or v357:find("petal")
								end

								v360 = FarmBloom and 0 or (v357:find("link") and 1 or (v357:find("bear morph") and 2 or ((v357:find("inspire") or (v357:find("focus") or (v357:find("melody") or v357:find("baby love")))) and 3 or ((v357:find("frog") or (v357:find("tabby love") or (v357:find("ballon") or v357:find("balloon")))) and 4 or ((v357:find("boost") or (v357:find("bomb") or (v357:find("festive gift") or (v357:find("mark") or v357:find("fuzz"))))) and 5 or n7)))))

								if v360 < n6 then
									v355 = child
									n6 = v360
								end
							end
						end
					end
				end
			end
		end

		return v355
	else
		return nil
	end
end

t2.value55 = 0
task.spawn(function()
	while _G.SylentHubActive do
		t2.value3.Heartbeat:Wait()

		if not (_G.IsConverting or (_G.IsFightingMondo or _G.IsPlantingSprinklers)) then
			local FarmActive = _G.FarmActive

			if FarmActive then
				FarmActive = t2.value8.Character
			end

			if FarmActive then
				local Character = t2.value8.Character
				local v368 = Character.FindFirstChild(Character, "HumanoidRootPart")
				local Humanoid = t2.value8.Character:FindFirstChildOfClass("Humanoid")
				local SelectedField = _G.SelectedField
				local v371 = t2.value22:FindFirstChild(SelectedField)
				local v372 = not v368
				local CoreStats = t2.value8:FindFirstChild("CoreStats")

				if not v372 and (Humanoid and (v371 and CoreStats)) then
					local Pollen = CoreStats:FindFirstChild("Pollen")
					local Capacity = CoreStats:FindFirstChild("Capacity")
					local v376

					if Pollen then
						if Capacity then
							v376 = Capacity.Value > 0
						else
							v376 = Capacity
						end
					else
						v376 = Pollen
					end

					if v376 then
						v376 = Pollen.Value >= Capacity.Value
					end

					if v376 then
						_G.IsConverting = true
						t2.value30()
						_G.IsConverting = false
					elseif v104(_G.SelectedField) then
						local v377 = nil
						local t6 = {}

						if _G.FarmBubbles then
							table.insert(t6, "bubble")
						end

						if _G.FarmBloom then
							table.insert(t6, "bloom")
							table.insert(t6, "petal")
						end

						if #t6 > 0 then
							v377 = v112(v371, t6)
						end

						local v379 = t2.value54(v371)

						if v379 then
							if _G.CurrentPhantomToken == v379 then
								if tick() - _G.TokenStuckTimer > 3 then
									t2.value18[v379] = true
									_G.CurrentPhantomToken = nil
									v379 = nil
								end
							else
								_G.CurrentPhantomToken = v379
								_G.TokenStuckTimer = tick()
							end
						else
							_G.CurrentPhantomToken = nil
						end

						if v377 then
							Humanoid:MoveTo(v377.Position)
						elseif v379 then
							Humanoid:MoveTo(v379.Position)
						else
							local WalkToPoint = Humanoid.WalkToPoint
							local Magnitude = (Vector3.new(v368.Position.X, 0, v368.Position.Z) - Vector3.new(WalkToPoint.X, 0, WalkToPoint.Z)).Magnitude

							if _G.WalkMode == "Random" then
								if Magnitude < 3 or (tick() - t2.value55 > 1.5 and true or WalkToPoint.Magnitude < 1) then
									t2.value55 = tick()

									local v382 = (math.random() - 0.5) * (v371.Size.X - 10)
									local v383 = (math.random() - 0.5) * (v371.Size.Z - 10)

									Humanoid:MoveTo((v371.CFrame * CFrame.new(v382, 0, v383)).Position)
								end
							elseif _G.WalkMode == "Circle" then
								local X = v371.Size.X
								local Z = v371.Size.Z
								local v386 = math.min(X, Z) / 2 - 5
								local v387 = tick() * 3.5
								local v388 = math.cos(v387) * v386
								local v389 = math.sin(v387) * v386

								Humanoid:MoveTo((v371.CFrame * CFrame.new(v388, 0, v389)).Position)
							elseif _G.WalkMode == "Pattern" then
								local v390 = tick() * 3.5
								local v391 = math.sin(v390) * (v371.Size.X / 2 - 5)
								local v392 = tick() * 1.5
								local v394 = math.sin(v392) * (v371.Size.Z / 2 - 5)

								Humanoid:MoveTo((v371.CFrame * CFrame.new(v391, 0, v394)).Position)
							end
						end
					else
						v368.CFrame = v371.CFrame + Vector3.new(0, 5, 0)
					end
				end
			end
		end
	end
end)

local Events = t2.value6:WaitForChild("Events", 5)

if Events then
	Events = Events:WaitForChild("ToolCollect", 5)
end

t2.value56 = Events
task.spawn(function()
	while _G.SylentHubActive do
		local AutoDig2 = _G.AutoDig

		if AutoDig2 then
			AutoDig2 = t2.value56

			if AutoDig2 then
				AutoDig2 = not _G.IsConverting

				if AutoDig2 then
					AutoDig2 = not _G.IsFightingMondo
				end
			end
		end

		if AutoDig2 then
			pcall(function()
				t2.value56:FireServer()
			end)
			task.wait(0.03)
		else
			task.wait(0.2)
		end
	end
end)
t2.value57 = Instance.new("Frame", t2.value24)

local value57 = t2.value57
local UDim2_4 = UDim2

t1.value16 = 0
value57.Size = UDim2_4.new(0, 240, t1.value16, 115)
t1.value16 = 0
t2.value57.Position = UDim2.new(0, 10, t1.value16, 10)
t2.value57.BackgroundColor3 = t2.value9
t2.value57.BackgroundTransparency = 0.2
t2.value57.Visible = false
v21(t2.value57)
Instance.new("UICorner", t2.value57)

local UIStroke4 = Instance.new("UIStroke", t2.value57)

UIStroke4.Color = t2.value10
UIStroke4.Thickness = 1.5
t2.value58 = Instance.new("TextLabel", t2.value57)

local value58 = t2.value58
local UDim2_5 = UDim2

t1.value16 = "new"

local uDim22 = UDim2_5.new(1, -10, 1, -10)

t1.value16 = "UDim2"
value58.Size = uDim22

local value582 = t2.value58
local UDim2_6 = UDim2

t1.value16 = "new"
value582.Position = UDim2_6.new(0, 5, 0, 5)
t2.value58.BackgroundTransparency = 1

local value583 = t2.value58
local color3New = Color3.new

t1.value16 = 1
value583.TextColor3 = color3New(t1.value16, 1, 1)
t2.value58.Font = Enum.Font.Code
t2.value58.TextSize = 11
t2.value58.RichText = true
t2.value58.TextXAlignment = Enum.TextXAlignment.Left
t2.value58.TextYAlignment = Enum.TextYAlignment.Top
t1.value7(settings, "Speed", function(p48)
	_G.FixedSpeed = p48
	t2.value38.Visible = p48

	local v406 = not p48

	if v406 then
		v406 = t2.value8.Character

		if v406 then
			v406 = t2.value8.Character:FindFirstChild("Humanoid")
		end
	end

	if not v406 then
		return
	end

	t2.value8.Character.Humanoid.WalkSpeed = 16
end, false, "FixedSpeed")

local _G_ = _G

t1.value16 = "ShowWatermark"

function _G_.ConfigSetters.FixedSpeedValue(p49)
	_G.FixedSpeedValue = p49
	t2.value39.Text = tostring(p49)

	local FixedSpeed = _G.FixedSpeed

	if FixedSpeed then
		FixedSpeed = t2.value8.Character

		if FixedSpeed then
			FixedSpeed = t2.value8.Character:FindFirstChild("Humanoid")
		end
	end

	if not FixedSpeed then
		return
	end

	t2.value8.Character.Humanoid.WalkSpeed = p49
end

t1.value7(settings, "Show Watermark", function(p50)
	t2.value57.Visible = p50
end, false, "ShowWatermark")

local ConfigSetters = _G.ConfigSetters

t1.value16 = "MobileButton"

function ConfigSetters.WatermarkPos(p51)
	local XS = p51 and p51.XS

	if XS then
		XS = p51.XO

		if XS then
			XS = p51.YS

			if XS then
				XS = p51.YO
			end
		end
	end

	if not XS then
		return
	end

	t2.value57.Position = UDim2.new(p51.XS, p51.XO, p51.YS, p51.YO)
end

t1.value7(settings, "Show Mobile Button", function(p52)
	t2.value32.Visible = p52
end, false, "MobileButton")
t2.value59 = Instance.new("TextButton", settings)
t2.value59.Size = UDim2.new(1, -5, 0, 30)
t1.value16 = "Toggle UI Key: "
t2.value59.BackgroundColor3 = t2.value9
t1.value7 = _G.ToggleKey.Name
t2.value59.Text = "Toggle UI Key: " .. t1.value7
t2.value59.TextColor3 = t2.value10
t2.value59.Font = Enum.Font.Gotham
t2.value59.TextSize = 11
Instance.new("UICorner", t2.value59)
t2.value60 = false

local MouseButton1Click2 = t2.value59.MouseButton1Click

function t1.value16()
	t2.value59.Text = "Press any key..."
	t2.value60 = true
end

MouseButton1Click2:Connect(t1.value16)

function _G.ConfigSetters.ToggleKey(p53)
	local v412 = nil

	local function v413()
		return Enum.KeyCode[v412]
	end

	v412 = p53

	local ok, toggleKey = pcall(v413)

	if not (ok and toggleKey) then
		return
	end

	_G.ToggleKey = toggleKey
	t2.value59.Text = "Toggle UI Key: " .. toggleKey.Name
end

t1.value16 = "Instance"
t2.value61 = Instance.new("TextBox", t1.value10)
t2.value61.Size = UDim2.new(1, -5, 0, 30)

local value61 = t2.value61

t1.value16 = "BackgroundColor3"
t1.value7 = Color3.fromRGB
t1.value15 = 25
value61.BackgroundColor3 = t1.value7(25, 25, t1.value15)
t2.value61.PlaceholderText = "Enter Config Name..."
t1.value16 = "Text"
t2.value61.Text = ""

local value612 = t2.value61

t1.value16 = "TextColor3"
t1.value15 = 1
value612.TextColor3 = Color3.new(1, 1, t1.value15)
t1.value16 = "Font"
t2.value61.Font = Enum.Font.Gotham
t2.value61.TextSize = 12
Instance.new("UICorner", t2.value61)
t1.value15 = -5
t1.value16 = Instance.new("ScrollingFrame", t1.value10)
t2.value62 = t1.value16
t1.value16 = t2.value62

local uDim23 = UDim2.new(1, t1.value15, 0, 100)

t1.value15 = 20
t1.value16.Size = uDim23
t1.value16 = t2.value62

local color3 = Color3.fromRGB

t1.value12 = 20
t1.value16.BackgroundColor3 = color3(20, t1.value15, t1.value12)
t1.value12 = 40
t2.value62.ScrollBarThickness = 2
t2.value62.AutomaticCanvasSize = Enum.AutomaticSize.Y
t1.value7 = Instance
t1.value7.new("UICorner", t2.value62)
t1.value7 = Instance.new("UIStroke", t2.value62)

local Color3_2 = Color3

t1.value15 = 40

local fromRGB = Color3_2.fromRGB

t1.value16 = "Color"
t1.value7.Color = fromRGB(40, t1.value15, t1.value12)
t1.value7 = Instance
t1.value16 = t1.value7.new
t1.value15 = 2
t1.value7 = t1.value16("UIListLayout", t2.value62)

local uDimNew2 = UDim.new

function t1.value12()
	local t7 = {
		IgnoreHoney = true,
		Field = "Sunflower Field",
		ConvertBalloons = false,
		BalloonTimer = 30,
		FarmBubbles = false,
		FarmBlooms = false,
		WalkMode = "Random",
		AutoDig = false,
		AutoSprinkler = false,
		SelectedSprinkler = "Basic Sprinkler",
		AutoMondo = false,
		MasterDispenser = false,
		AutoStickers = false,
		FixedSpeed = false,
		FixedSpeedValue = 40,
		ShowWatermark = false,
		MobileButton = false,
		ToggleKey = "Insert",
		WatermarkPos = {
			XS = 0,
			XO = 10,
			YS = 0,
			YO = 10
		}
	}

	for _, v in pairs(t2.value52) do
		t7["Disp_" .. v[2]] = false
	end

	return t7
end

t1.value7.Padding = uDimNew2(0, t1.value15)
t2.value63 = nil
t2.value63 = nil

function t1.value15()
	local ok, result = pcall(function()
		return readfile(t2.value13)
	end)

	if ok then
	elseif ok then
		return result
	else
		return nil
	end

	if result then
		ok = result ~= ""
	else
		ok = result
	end

	if ok then
		return result
	else
		return nil
	end
end

t2.value64 = nil

function t2.value64()
	local pairs_ = pairs
	local value62 = t2.value62

	for _, child in pairs_(value62.GetChildren(value62)) do
		if child:IsA("TextButton") then
			child:Destroy()
		end
	end

	t2.value63 = nil
	t2.value61.Text = ""

	if not listfiles then
		return
	end

	local function v432()
		return listfiles(t2.value12)
	end

	local ok, result = pcall(v432)

	if not (ok and result) then
		return
	end

	for _, v in ipairs(result) do
		local match = v:match("([^/\\]+)%.json$")

		if match then
			local TextButton2 = Instance.new("TextButton", t2.value62)

			TextButton2.Size = UDim2.new(1, -5, 0, 25)
			TextButton2.BackgroundColor3 = t2.value9
			TextButton2.Text = match
			TextButton2.TextColor3 = t2.value11
			TextButton2.Font = Enum.Font.Gotham
			TextButton2.TextSize = 11
			Instance.new("UICorner", TextButton2)
			TextButton2.MouseButton1Click:Connect(function()
				t2.value63 = match
				t2.value61.Text = match

				local pairs_2 = pairs
				local value622 = t2.value62

				for _, child in pairs_2(value622.GetChildren(value622)) do
					if child:IsA("TextButton") then
						child.TextColor3 = t2.value11
					end
				end

				TextButton2.TextColor3 = t2.value10
			end)
		end
	end
end
function t2.value65(p54)
	local function v443()
		writefile(t2.value13, p54)
	end

	pcall(v443)
end
function t1.value7(p55)
	if not writefile then
		return t2.value28("Your executor doesn\'t support writing files.", 3)
	end

	if p55 == "" then
		return t2.value28("Please enter a config name.", 3)
	end

	local t8 = {
		IgnoreHoney = _G.IgnoreHoney,
		Field = _G.SelectedField,
		ConvertBalloons = _G.AutoConvertBalloons,
		BalloonTimer = _G.BalloonConvertInterval,
		FarmBubbles = _G.FarmBubbles,
		FarmBlooms = _G.FarmBloom,
		WalkMode = _G.WalkMode,
		AutoDig = _G.AutoDig,
		AutoSprinkler = _G.AutoSprinkler,
		SelectedSprinkler = _G.SelectedSprinkler,
		AutoMondo = _G.AutoMondo,
		MasterDispenser = _G.AutoDispensers,
		AutoStickers = _G.AutoStickers,
		FixedSpeed = _G.FixedSpeed,
		FixedSpeedValue = _G.FixedSpeedValue,
		ShowWatermark = t2.value57.Visible,
		MobileButton = t2.value32.Visible,
		ToggleKey = _G.ToggleKey.Name,
		WatermarkPos = {
			XS = t2.value57.Position.X.Scale,
			XO = t2.value57.Position.X.Offset,
			YS = t2.value57.Position.Y.Scale,
			YO = t2.value57.Position.Y.Offset
		}
	}

	for _, v in pairs(t2.value52) do
		t8["Disp_" .. v[2]] = _G.DispToggles[v[2]]
	end

	local function v447()
		local json = t2.value5:JSONEncode(t8)

		writefile(t2.value12 .. "/" .. p55 .. ".json", json)
	end

	local t9 = { pcall(v447) }
	local _ = t9[2]

	if t9[1] then
		t2.value65(p55)

		local v451 = "Saved: " .. p55

		t2.value28(v451, 3)
		t2.value64()
	else
		t2.value28("Failed to save config.", 3)
	end
end

t2.value66 = t1.value15
t2.value67 = t1.value12
t2.value68 = t1.value7

function t2.value69(p56)
	if not readfile then
		return t2.value28("Your executor doesn\'t support reading files.", 3)
	end

	if p56 == "" then
		return t2.value28("No config selected.", 3)
	end

	local v452 = "/" .. p56 .. ".json"
	local v453 = t2.value12 .. v452

	if not isfile(v453) then
		return t2.value28("Config not found.", 3)
	end

	local function v454()
		local v455 = readfile(v453)

		return t2.value5:JSONDecode(v455)
	end

	local ok, result = pcall(v454)

	if ok then
		ok = type(result) == "table"
	end

	if not ok then
		t2.value28("Failed to load config.", 3)

		return
	end

	t2.value67()

	for k, v in pairs("pairs") do
		if result[k] == nil then
			result[k] = v
		end
	end

	for k, v in pairs(result) do
		if _G.ConfigSetters[k] then
			pcall(function()
				_G.ConfigSetters[k](v)
			end)
		end
	end

	t2.value65(p56)
	t2.value28("Loaded: " .. p56, 3)
end
function t2.value70(p57)
	if not delfile then
		return t2.value28("Your executor doesn\'t support deleting files.", 3)
	end

	if p57 == "" then
		return t2.value28("No config selected.", 3)
	end

	local v462 = t2.value12 .. "/" .. p57 .. ".json"

	if not isfile(v462) then
		return
	end

	pcall(function()
		delfile(v462)
	end)

	local v463 = "Deleted: " .. p57

	t2.value28(v463, 3)
	t2.value64()
end
function t2.value71()
	local Text = t2.value61.Text
	local createdDefaultConfig = Text == "" and "DefaultConfig" or Text
	local v466 = t2.value67()

	pcall(function()
		writefile(t2.value12 .. "/" .. createdDefaultConfig .. ".json", t2.value5:JSONEncode(v466))
	end)

	local v467 = "Created Default Config: " .. createdDefaultConfig

	t2.value28(v467, 3)
	t2.value64()
end

local TextButton2 = Instance.new("TextButton", t1.value10)

TextButton2.Size = UDim2.new(1, -5, 0, 30)
TextButton2.BackgroundColor3 = t2.value9
TextButton2.Text = "Save Config"
TextButton2.TextColor3 = t2.value11
Instance.new("UICorner", TextButton2)

local TextButton3 = Instance.new("TextButton", t1.value10)

TextButton3.Size = UDim2.new(1, -5, 0, 30)
TextButton3.BackgroundColor3 = t2.value9
TextButton3.Text = "Load Config"
TextButton3.TextColor3 = t2.value11
Instance.new("UICorner", TextButton3)

local TextButton4 = Instance.new("TextButton", t1.value10)

TextButton4.Size = UDim2.new(1, -5, 0, 30)
TextButton4.BackgroundColor3 = t2.value9
TextButton4.Text = "Create Default Config"
TextButton4.TextColor3 = t2.value11
Instance.new("UICorner", TextButton4)

local TextButton5 = Instance.new("TextButton", t1.value10)

TextButton5.Size = UDim2.new(1, -5, 0, 30)
TextButton5.BackgroundColor3 = t2.value9
TextButton5.Text = "Delete Config"
TextButton5.TextColor3 = t2.value11
Instance.new("UICorner", TextButton5)

local TextButton6 = Instance.new("TextButton", t1.value10)

TextButton6.Size = UDim2.new(1, -5, 0, 30)
TextButton6.BackgroundColor3 = t2.value9
TextButton6.Text = "Refresh List"
TextButton6.TextColor3 = t2.value11
Instance.new("UICorner", TextButton6)

function t1.value10()
	t2.value68(t2.value61.Text)
end

TextButton2.MouseButton1Click:Connect(t1.value10)

local MouseButton1Click3 = TextButton3.MouseButton1Click

function t1.value10()
	t2.value69(t2.value63 or t2.value61.Text)
end

MouseButton1Click3:Connect(t1.value10)

function t1.value10()
	t2.value71()
end

TextButton4.MouseButton1Click:Connect(t1.value10)

local MouseButton1Click4 = TextButton5.MouseButton1Click

function t1.value10()
	t2.value70(t2.value63 or t2.value61.Text)
end

MouseButton1Click4:Connect(t1.value10)

local MouseButton1Click5 = TextButton6.MouseButton1Click

function t1.value10()
	t2.value64()
end

MouseButton1Click5:Connect(t1.value10)
task.spawn(t2.value64)
t1.value10 = t2.value3.Stepped

local Connect = t1.value10.Connect

t2.value15(Connect(t1.value10, function()
	local SylentHubActive = _G.SylentHubActive

	if SylentHubActive then
		SylentHubActive = _G.FixedSpeed

		if SylentHubActive then
			SylentHubActive = t2.value8.Character

			if SylentHubActive then
				SylentHubActive = t2.value8.Character:FindFirstChild("Humanoid")
			end
		end
	end

	if not SylentHubActive then
		return
	end

	t2.value8.Character.Humanoid.WalkSpeed = _G.FixedSpeedValue
end))
t1.value10 = t2.value3.RenderStepped
t2.value15(t1.value10:Connect(function(p58)
	local v478 = t2
	local v479 = 1 / p58

	v478.value21 = math.floor(v479)
end))
task.spawn(function()
	while _G.SylentHubActive do
		local CoreStats = t2.value8:FindFirstChild("CoreStats")

		if CoreStats then
			local Honey = CoreStats:FindFirstChild("Honey")
			local Pollen = CoreStats:FindFirstChild("Pollen")
			local Capacity = CoreStats:FindFirstChild("Capacity")
			local v484

			if Honey then
				v484 = Pollen and Capacity
			else
				v484 = Honey
			end

			if v484 then
				local Value = Honey.Value
				local Value2 = Pollen.Value
				local Value3 = Capacity.Value
				local v488 = tick() - t2.value20
				local v489 = Value - t2.value19
				local v490

				if v489 > 0 then
					local v491 = v489 / (v488 / 3600)

					v490 = math.floor(v491)
				else
					v490 = false
				end

				local v492 = v490 or 0

				local function v493(p59)
					local v494 = math.floor(p59)

					return tostring(v494):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
				end
				local function v495()
					local value584 = t2.value58
					local format = string.format
					local value21 = t2.value21
					local value = game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
					local v500 = math.floor(value)
					local v501 = Value2
					local v502 = math.floor(v501)
					local v503 = tostring(v502):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
					local v504 = Value3
					local v505 = math.floor(v504)
					local v506 = tostring(v505):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", "")
					local v507 = Value
					local v508 = math.floor(v507)

					value584.Text = format("<font color=\'#00C8FF\'>FPS:</font> %d | <font color=\'#00C8FF\'>PING:</font> %d\n<font color=\'#00C8FF\'>POLLEN:</font> %s / %s\n<font color=\'#00C8FF\'>HONEY:</font> %s\n<font color=\'#00C8FF\'>HPH:</font> %s/hr", value21, v500, v503, v506, tostring(v508):reverse():gsub("(%d%d%d)", "%1,"):reverse():gsub("^,", ""), v493(v492))
				end

				pcall(v495)
			end
		end

		task.wait(1)
	end
end)

local TextButton7 = Instance.new("TextButton", settings)

TextButton7.Size = UDim2.new(1, -5, 0, 30)
TextButton7.Text = "UNLOAD HUB"
TextButton7.BackgroundColor3 = Color3.fromRGB(60, 20, 20)
TextButton7.TextColor3 = Color3.new(1, 0.5, 0.5)
Instance.new("UICorner", TextButton7)
TextButton7.MouseButton1Click:Connect(function()
	_G.SylentHubActive = false

	for _, v in pairs(t2.value14) do
		local Connected

		if v then
			Connected = v.Connected
		else
			Connected = v
		end

		if Connected then
			v:Disconnect()
		end
	end

	table.clear(t2.value14)

	local Character = t2.value8.Character

	if Character then
		Character = t2.value8.Character:FindFirstChild("Humanoid")
	end

	if Character then
		t2.value8.Character.Humanoid.WalkSpeed = 16
	end

	if not t2.value24 then
		return
	end

	t2.value24:Destroy()
end)
t2.value15(t2.value2.InputBegan:Connect(function(input, gameProcessed)
	local value60 = t2.value60

	if value60 then
		value60 = input.UserInputType == Enum.UserInputType.Keyboard
	end

	if value60 then
		_G.ToggleKey = input.KeyCode

		local text = "Toggle UI Key: " .. _G.ToggleKey.Name

		t2.value59.Text = text
		t2.value60 = false

		return
	end

	local v516 = not gameProcessed

	if v516 then
		v516 = input.KeyCode == _G.ToggleKey
	end

	if not v516 then
		return
	end

	local visible = not t2.value34.Visible

	t2.value34.Visible = visible
	t2.value35.Visible = false

	if not _G.FixedSpeed then
		return
	end

	t2.value38.Visible = t2.value34.Visible
end))

if t2.value32 then
	t2.value32.MouseButton1Click:Connect(function()
		if not t2.value34 then
			return
		end

		t2.value34.Visible = not t2.value34.Visible

		if t2.value35 then
			t2.value35.Visible = false
		end

		local FixedSpeed = _G.FixedSpeed

		if FixedSpeed then
			FixedSpeed = t2.value38
		end

		if FixedSpeed then
			t2.value38.Visible = t2.value34.Visible

			return
		end

		if not t2.value38 then
			return
		end

		t2.value38.Visible = false
	end)
end

t2.value28("Thank You for using SylentHub. <3", 5)
task.spawn(function()
	_G.IsConverting = true
	task.wait(1)

	local v519 = t2.value66()
	local v520

	if v519 then
		v520 = isfile(t2.value12 .. "/" .. v519 .. ".json")
	else
		v520 = v519
	end

	if not v520 then
		t2.value31()
		_G.IsConverting = false

		return
	end

	t2.value69(v519)
	t2.value31()
	_G.IsConverting = false
end)
