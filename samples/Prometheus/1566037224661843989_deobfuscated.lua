-- This file was generated at discord.gg/syncrypt

local t2 = {
	value1 = {}
}
local t1 = {
	value5 = 22126428612671,
	value8 = {
		__index = t2.value1,
		__metatable = nil
	}
}
local Players = game:GetService("Players")
local game_ = game

t1.value6 = 32235748178594
t1.value5 = "d\24\155\14\"&\0056\177\242\197\30t\128~\248\144"
t1.value4 = 18063688655067

local GetService = game_.GetService

t1.value3 = "\193\27\146\237\229\153 \212\231"
t1.value1 = GetService
t1.value1 = t1.value1(game_, "ReplicatedStorage")
t2.value2 = t1.value1
t2.value3 = game:GetService("Workspace")
t1.value4 = "\189Ї\190\130\192\141\23\254\246\253j\184E\150\219"
t1.value2 = "game"
t1.value2 = game:GetService("UserInputService")
t2.value4 = t1.value2
t2.value5 = game:GetService("TweenService")
t1.value6 = 22367117977775
t1.value7 = "\152\214,\143\140\162\244\tt"
t2.value6 = Players.LocalPlayer
t1.value5 = t2.value6:WaitForChild("PlayerGui")
t2.value7 = t1.value5
t1.value3 = getgenv()

local vector3New = Vector3.new

t1.value7 = 282
t1.value8 = 3.76
t1.value6 = vector3New(t1.value7, t1.value8, 18000)

local vector3 = Vector3.new(292.82, 4.12, 17999.98)

t1.value5 = {
	Start = t1.value6,
	StartWait = 2.5,
	Finish = vector3,
	TweenSpeed = 50,
	LoadTimeout = 15,
	ProgressTimeout = 8,
	ClaimTimeout = 10,
	ArrivalPause = 0.5,
	BetweenActions = 0.25,
	MarkerPromptDistance = 12
}
t2.value8 = t1.value5
t1.value5 = Color3.fromRGB
t1.value7 = 10
t1.value6 = 10

local v9 = t1.value5(t1.value6, t1.value7, 10)

t1.value5 = Color3.fromRGB
t1.value8 = 120
t1.value7 = 255
t1.value6 = t1.value5(t1.value7, t1.value8, 25)
t2.value9 = t1.value6
t1.value7 = Color3.fromRGB(255, 255, 255)
t1.value8 = Color3.fromRGB(190, 100, 35)
t2.value10 = t1.value8
t2.value11 = Color3.fromRGB(185, 45, 45)

local ShedstryCleanup = t1.value3.ShedstryCleanup

if type(ShedstryCleanup) == "function" then
	pcall(t1.value3.ShedstryCleanup)
end

local ShedstryHollowHub = t2.value7:FindFirstChild("ShedstryHollowHub")

if ShedstryHollowHub then
	ShedstryHollowHub:Destroy()
end

t2.value12 = false
t2.value13 = false
t2.value14 = {}
t2.value15 = {}
t2.value16 = nil
t2.value17 = nil
t2.value18 = nil
t2.value19 = nil

function t2.value20(p1, p2)
	local connection = p1:Connect(p2)
	local value14 = t2.value14

	table.insert(value14, connection)

	return connection
end
function t2.value21()
	if not t2.value12 then
		return
	end

	error("Execution cancelled.", 0)
end

local function v14(p3)
	local v15 = os.clock() + p3

	while os.clock() < v15 do
		t2.value21()
		task.wait(0.05)
	end

	t2.value21()
end

function t2.value22(p4, p5)
	local v16 = os.clock() + p5

	while true do
		t2.value21()

		local v17 = p4()

		if v17 then
			break
		end

		task.wait(0.1)

		if v16 <= os.clock() then
			return nil
		end
	end

	return v22
end

t2.value23 = Instance.new("ScreenGui")
t2.value23.Name = "ShedstryHollowHub"
t2.value23.ResetOnSpawn = false
t2.value23.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
t2.value23.Parent = t2.value7

local function v18(p6, p7)
	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(0, p7)
	UICorner.Parent = p6
end

t2.value24 = Instance.new("Frame")
t2.value24.Name = "Window"
t2.value24.Size = UDim2.fromOffset(230, 121)
t2.value24.Position = UDim2.new(0.5, -115, 0.5, -60)
t2.value24.BackgroundColor3 = v9
t2.value24.Parent = t2.value23
v18(t2.value24, 12)

local value24 = t2.value24
local UIStroke = Instance.new("UIStroke")

UIStroke.Color = t2.value9
UIStroke.Thickness = 2
UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke.Parent = value24

local Frame = Instance.new("Frame")

Frame.Size = UDim2.new(1, 0, 0, 48)
Frame.BackgroundTransparency = 1
Frame.Active = true
Frame.Parent = t2.value24

local TextLabel = Instance.new("TextLabel")

TextLabel.Size = UDim2.new(1, -20, 1, 0)
TextLabel.Position = UDim2.fromOffset(10, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "Shedstry Hollow Hub"
TextLabel.TextColor3 = t2.value9
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 13
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Parent = Frame

local Frame2 = Instance.new("Frame")

Frame2.Position = UDim2.fromOffset(12, 48)
Frame2.Size = UDim2.new(1, -24, 0, 1)
Frame2.BorderSizePixel = 0
Frame2.BackgroundColor3 = t2.value9
Frame2.Parent = t2.value24
t2.value25 = Instance.new("TextButton")
t2.value25.Name = "AutoFloor9Button"
t2.value25.Position = UDim2.fromOffset(8, 58)
t2.value25.Size = UDim2.new(1, -16, 0, 34)
t2.value25.BackgroundColor3 = t2.value10
t2.value25.BorderSizePixel = 0
t2.value25.Text = "AUTO-FLOOR 9"
t2.value25.TextColor3 = t1.value7
t2.value25.TextStrokeTransparency = 1
t2.value25.Font = Enum.Font.GothamBold
t2.value25.TextSize = 12
t2.value25.Parent = t2.value24
v18(t2.value25, 7)

local TextButton = Instance.new("TextButton")

TextButton.Name = "ToggleButton"
TextButton.Size = UDim2.fromOffset(56, 56)
TextButton.Position = UDim2.new(0, 20, 0.5, -28)
TextButton.BackgroundColor3 = v9
TextButton.Text = "OwO"
TextButton.TextColor3 = t1.value7
TextButton.TextStrokeColor3 = v9
TextButton.TextStrokeTransparency = 0
TextButton.Font = Enum.Font.GothamBlack
TextButton.TextSize = 19
TextButton.Parent = t2.value23
v18(TextButton, 8)

local UIStroke2 = Instance.new("UIStroke")

UIStroke2.Color = t2.value9
UIStroke2.Thickness = 2
UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
UIStroke2.Parent = TextButton

local function v27(p8, p9, p10)
	local u28 = nil
	local Position = nil
	local Position2 = nil
	local u31 = false

	t2.value20(p8.InputBegan, function(p11)
		if u28 then
			return
		end

		if not (p11.UserInputType == Enum.UserInputType.MouseButton1 or p11.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u28 = p11
		Position = p11.Position
		Position2 = p9.Position
		u31 = false
	end)
	t2.value20(t2.value4.InputChanged, function(p12)
		if not u28 then
			return
		end

		local v32 = p12 == u28

		if not v32 then
			v32 = u28.UserInputType == Enum.UserInputType.MouseButton1

			if v32 then
				v32 = p12.UserInputType == Enum.UserInputType.MouseMovement
			end
		end

		if not v32 then
			return
		end

		local v33 = p12.Position - Position

		if v33.Magnitude > 8 then
			u31 = true
		end

		if not u31 then
			return
		end

		p9.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v33.X, Position2.Y.Scale, Position2.Y.Offset + v33.Y)
	end)
	t2.value20(t2.value4.InputEnded, function(p13)
		if not u28 or p13 ~= u28 then
			return
		end

		local v34 = not u31

		if v34 then
			v34 = p10
		end

		if not v34 then
			return
		end

		p10()
	end)
end

v27(Frame, t2.value24)
v27(TextButton, TextButton, function()
	t2.value24.Visible = not t2.value24.Visible
end)

function t2.value26()
	local ipairs_ = ipairs
	local value7 = t2.value7

	for _, child in ipairs_(value7.GetChildren(value7)) do
		local isScreenGui = child:IsA("ScreenGui")

		if isScreenGui then
			isScreenGui = child ~= t2.value23
		end

		if isScreenGui then
			t2.value15[child] = child.Enabled
			child.Enabled = false
		end
	end
end
function t2.value27()
	for k, v in pairs(t2.value15) do
		if k.Parent then
			k.Enabled = v
		end
	end

	table.clear(t2.value15)
end
function t2.value28()
	local value16 = t2.value16

	if not value16 then
		return
	end

	pcall(function()
		value16:InputHoldEnd()
	end)
end
function t2.value29()
	local value17 = t2.value17

	t2.value17 = nil

	if not value17 then
		return
	end

	value17:Cancel()
end
function t2.value30()
	local value18 = t2.value18

	t2.value18 = nil

	local Parent

	if value18 then
		Parent = value18.root.Parent
	else
		Parent = value18
	end

	if not Parent then
		return
	end

	value18.root.Anchored = value18.wasAnchored
	value18.root.AssemblyLinearVelocity = Vector3.zero
	value18.root.AssemblyAngularVelocity = Vector3.zero
end
function t1.value3.ShedstryCleanup()
	t2.value12 = true
	t2.value29()
	t2.value28()
	t2.value30()
	t2.value27()

	for _, v in ipairs(t2.value14) do
		v:Disconnect()
	end

	t2.value23:Destroy()
end
function t2.value31()
	local Character = t2.value6.Character
	local Humanoid

	if Character then
		Humanoid = Character:FindFirstChildOfClass("Humanoid")
	else
		Humanoid = Character
	end

	if Character then
		Character = Character:FindFirstChild("HumanoidRootPart")
	end

	if not (not Character or (not Humanoid or Humanoid.Health <= 0)) then
		return Character
	end

	error("Character is unavailable or dead.", 0)

	return Character
end
function t2.value32()
	t2.value21()

	local v50 = t2.value31()
	local value18 = {
		root = v50,
		wasAnchored = v50.Anchored
	}

	local function v52()
		v50.Anchored = true
		v50.CFrame = CFrame.new(t2.value8.Start)
		v50.AssemblyLinearVelocity = Vector3.zero
		v50.AssemblyAngularVelocity = Vector3.zero
		v14(t2.value8.StartWait)
	end

	t2.value18 = value18

	local ok, result = pcall(v52)

	if t2.value18 == value18 then
		t2.value30()
	end

	if ok then
		t2.value21()

		return
	end

	error(result, 0)
	t2.value21()
end
function t2.value33()
	local ClientModules = t2.value2:FindFirstChild("ClientModules")

	if ClientModules then
		ClientModules = ClientModules:FindFirstChild("ReleasedPuzzles")
	end

	if ClientModules then
		ClientModules = ClientModules:FindFirstChild("LeverWalls")
	end

	if ClientModules then
		ClientModules = ClientModules:FindFirstChild("LeverWallsPuzzle")
	end

	if not (ClientModules and ClientModules:IsA("ModuleScript")) then
		error("LeverWallsPuzzle module not found.", 0)
	end

	local module = require(ClientModules)
	local v57 = type(module) ~= "table"

	if not v57 then
		local getState = module.getState

		v57 = type(getState) ~= "function"
	end

	if not v57 then
		t2.value19 = module

		return
	end

	error("Invalid LeverWallsPuzzle module.", 0)
	t2.value19 = module
end
function t2.value34()
	local v59 = t2.value19.getState()
	local v60 = type(v59) ~= "table"

	if v60 then
		if v60 then
			return nil
		else
			return v59
		end
	end

	v60 = type(v59.Walls) ~= "table"

	if v60 then
		if v60 then
			return nil
		else
			return v59
		end
	end

	local Levers = v59.Levers

	v60 = type(Levers) ~= "table"

	if v60 then
		if v60 then
			return nil
		else
			return v59
		end
	end

	local Opened = v59.Opened

	v60 = type(Opened) ~= "number"

	if v60 then
		return nil
	else
		return v59
	end
end
function t2.value35(p14)
	if p14:IsA("Attachment") then
		return p14.WorldPosition
	elseif p14:IsA("BasePart") then
		return p14.Position
	elseif p14:IsA("Model") then
		return p14:GetPivot().Position
	else
		return nil
	end
end

t2.value36 = nil

function t2.value36(p15)
	local Parent = p15.Parent

	if not Parent then
		return Parent
	end

	Parent = t2.value35(p15.Parent)

	return Parent
end
function t2.value37(p16)
	t2.value21()

	local v64 = t2.value36(p16)

	if not v64 then
		error("Prompt position unavailable.", 0)
	end

	local v65 = t2.value31()
	local v66 = p16.MaxActivationDistance * 0.5
	local v67 = math.min(3, v66)
	local vector32

	if not (v67 <= 0) then
		v83 = v65.Position - v64
		v84 = Vector3.new(v83.X, 0, v83.Z)

		if v84.Magnitude < 0.01 then
			vector32 = Vector3.new(0, 0, 1)
		else
			vector32 = v84.Unit
		end

		v85 = v64 + vector32 * v67
		v65.CFrame = CFrame.lookAt(v85, Vector3.new(v64.X, v85.Y, v64.Z))
		v65.AssemblyLinearVelocity = Vector3.zero
		v65.AssemblyAngularVelocity = Vector3.zero

		return
	end

	error("Prompt has no usable activation range.", 0)

	local v69 = v65.Position - v64
	local vector33 = Vector3.new(v69.X, 0, v69.Z)

	if vector33.Magnitude < 0.01 then
		vector32 = Vector3.new(0, 0, 1)
	else
		vector32 = vector33.Unit
	end

	local v71 = v64 + vector32 * v67

	v65.CFrame = CFrame.lookAt(v71, Vector3.new(v64.X, v71.Y, v64.Z))
	v65.AssemblyLinearVelocity = Vector3.zero
	v65.AssemblyAngularVelocity = Vector3.zero
end
function t2.value38(p17)
	local v72 = tostring(t2.value6.UserId)
	local v73 = t2.value31()
	local ipairs_ = ipairs
	local value3 = t2.value3
	local huge = math.huge
	local v77 = nil

	for _, descendant in ipairs_(value3.GetDescendants(value3)) do
		if descendant:IsA("BasePart") then
			local attribute = descendant:GetAttribute(v72)
			local v81

			if attribute == nil then
				v81 = false
			else
				v81 = tostring(attribute) == tostring(p17)
			end

			if v81 then
				local Magnitude = (v73.Position - descendant.Position).Magnitude

				if Magnitude < huge then
					v77 = descendant
					huge = Magnitude
				end
			end
		end
	end

	return v77
end
function t2.value39(p18)
	local MarkerPromptDistance = t2.value8.MarkerPromptDistance
	local ipairs_ = ipairs
	local value3 = t2.value3
	local v86 = nil

	for _, descendant in ipairs_(value3.GetDescendants(value3)) do
		local isProximityPrompt = descendant:IsA("ProximityPrompt")

		if isProximityPrompt then
			if descendant.ActionText == "Pull" then
				isProximityPrompt = descendant.Enabled
			else
				isProximityPrompt = false
			end
		end

		if isProximityPrompt then
			ipairs_ = t2.value36

			local v90 = ipairs_(descendant)

			if v90 then
				ipairs_ = (v90 - p18.Position).Magnitude

				if ipairs_ < MarkerPromptDistance then
					v86 = descendant
					MarkerPromptDistance = ipairs_
					ipairs_ = v86

					local v91 = v86

					v86 = ipairs_
					v91 = ipairs_
				end
			end
		end
	end

	return v86
end

t2.value40 = nil

function t2.value40(p19)
	t2.value21()

	if not (p19:IsDescendantOf(t2.value3) and p19.Enabled) then
		error("Prompt is unavailable or disabled.", 0)
	end

	local v92 = t2.value36(p19)

	if not v92 or (t2.value31().Position - v92).Magnitude > p19.MaxActivationDistance then
		error("Character is outside prompt range.", 0)
	end

	local function v93()
		p19:InputHoldEnd()
		p19:InputHoldBegin()

		local v94 = os.clock() + p19.HoldDuration + 0.1

		while true do
			v14(0.03)

			if not (p19:IsDescendantOf(t2.value3) and p19.Enabled) then
				break
			end

			local v95 = t2.value36(p19)

			if not v95 or (t2.value31().Position - v95).Magnitude > p19.MaxActivationDistance then
				error("Character moved outside prompt range.", 0)
			end

			if v94 <= os.clock() then
				return
			end
		end
	end

	local ok, result = pcall(v93)

	t2.value28()

	if ok then
		return
	end

	error(result, 0)
end
function t2.value41()
	while true do
		t2.value21()

		local v98 = t2.value34()

		if not v98 then
			error("Puzzle state became unavailable.", 0)
		end

		if v98.Solved or v98.Opened >= #v98.Walls then
			return
		end

		local Opened = v98.Opened
		local v100 = v98.Walls[Opened + 1]
		local t3 = {}

		for k, lever in pairs(v98.Levers) do
			if lever == v100 then
				local v104 = tostring(k)

				table.insert(t3, v104)
			end
		end

		if #t3 == 0 then
			error("No lever matches figure: " .. tostring(v100), 0)
		end

		local u105 = nil
		local u106 = nil

		local function v107()
			for _, v in ipairs(t3) do
				local v110 = t2.value38(v)

				if v110 then
					local v111 = t2.value39(v110)

					if v111 then
						u105 = v110
						u106 = v111

						return true
					end
				end
			end
		end

		u105 = nil
		u106 = nil

		if not t2.value22(v107, t2.value8.LoadTimeout) then
			error("Matching lever or prompt not loaded for: " .. tostring(v100), 0)
		end

		print("AUTO-FLOOR 9: step", Opened + 1, "figure", v100, "marker", u105:GetFullName())
		t2.value37(u106)
		v14(t2.value8.ArrivalPause)

		local v112 = t2.value34()

		if not v112 then
			error("Puzzle state unavailable before interaction.", 0)
		end

		local v113

		if v112.Opened == Opened then
			v113 = not v112.Solved
		else
			v113 = false
		end

		if v113 then
			t2.value40(u106)

			local function v114()
				local v115 = t2.value34()

				if not v115 then
					return nil
				end

				if not (v115.Opened < Opened) then
					return v115.Solved or Opened < v115.Opened
				end

				error("Puzzle progress reset; stopping safely.", 0)

				return v115.Solved or Opened < v115.Opened
			end

			if not t2.value22(v114, t2.value8.ProgressTimeout) then
				error("Lever progress was not confirmed; stopping.", 0)
			end
		end

		v14(t2.value8.BetweenActions)
	end
end

t2.value42 = nil

function t2.value42()
	local v116 = t2.value31()
	local ipairs_ = ipairs
	local value3 = t2.value3
	local huge = math.huge
	local v120 = nil

	for _, descendant in ipairs_(value3.GetDescendants(value3)) do
		local isProximityPrompt = descendant:IsA("ProximityPrompt")

		if isProximityPrompt then
			if descendant.ActionText == "Take Rune" then
				isProximityPrompt = descendant.Enabled
			else
				isProximityPrompt = false
			end
		end

		if isProximityPrompt then
			local v124 = t2.value36(descendant)

			if v124 then
				local Magnitude = (v116.Position - v124).Magnitude

				if Magnitude < huge then
					v120 = descendant
					huge = Magnitude
				end
			end
		end
	end

	return v120
end
function t2.value43()
	local Solved = t2.value34()

	if Solved then
		Solved = Solved.Solved
	end

	if Solved then
		return
	end

	local v127 = t2.value22(function()
		local Solved2 = t2.value34()

		if not Solved2 then
			return Solved2 and true or t2.value42()
		end

		Solved2 = Solved2.Solved

		return Solved2 and true or t2.value42()
	end, t2.value8.LoadTimeout)

	if v127 == true then
		return
	end

	if not v127 then
		error("Enabled Take Rune prompt not found.", 0)
	end

	t2.value37(v127)
	v14(t2.value8.ArrivalPause)

	local function v129()
		local v130 = t2.value34()

		if not v130 then
			return v130
		end

		v130 = v130.Solved == true

		return v130
	end

	t2.value40(v127)

	if t2.value22(v129, t2.value8.ClaimTimeout) then
		return
	end

	error("Relic claim was not confirmed.", 0)
end

t2.value44 = nil

function t2.value44()
	t2.value21()

	local v131 = t2.value31()
	local Magnitude = (v131.Position - t2.value8.Finish).Magnitude

	if Magnitude < 0.01 then
		return
	end

	local t4 = {
		CFrame = CFrame.new(t2.value8.Finish) * v131.CFrame.Rotation
	}
	local tween = t2.value5:Create(v131, TweenInfo.new(Magnitude / t2.value8.TweenSpeed, Enum.EasingStyle.Linear), t4)

	t2.value17 = tween

	local u135 = nil
	local Completed = tween.Completed

	local function v137()
		v131.AssemblyLinearVelocity = Vector3.zero
		v131.AssemblyAngularVelocity = Vector3.zero
		tween:Play()

		while true do
			t2.value21()

			if t2.value31() ~= v131 then
				error("Character changed during tween.", 0)
			end

			task.wait()
		end
	end

	local v138 = Completed.Connect(Completed, function(p20)
		u135 = p20
	end)
	local ok, result = pcall(v137)

	v138.Disconnect(v138)

	local _ = t2.value17 == tween

	if not ok then
		tween:Cancel()
	end

	tween:Destroy()

	if ok then
		return
	end

	error(result, 0)
end
function t2.value45()
	t2.value32()
	t2.value33()

	local v142 = t2.value22(t2.value34, t2.value8.LoadTimeout)

	if not v142 then
		error("Puzzle state did not load.", 0)
	end

	if not v142.Solved then
		if #v142.Walls == 0 then
			error("Puzzle has no loaded wall sequence.", 0)
		end

		t2.value41()
		t2.value43()
	end

	local v143 = t2.value34()

	if not (not v143 or v143.Solved ~= true) then
		t2.value44()
		print("AUTO-FLOOR 9: completed.")

		return
	end

	error("Solved state not confirmed; final tween cancelled.", 0)
	t2.value44()
	print("AUTO-FLOOR 9: completed.")
end

t2.value20(t2.value25.MouseButton1Click, function()
	if t2.value13 or t2.value12 then
		return
	end

	t2.value25.Text = "working..."
	t2.value25.BackgroundColor3 = t2.value11
	t2.value26()
	t2.value24.Visible = false
	task.spawn(function()
		local ok, result = pcall(t2.value45)

		t2.value28()
		t2.value29()
		t2.value30()

		if t2.value12 then
			return
		end

		t2.value27()
		t2.value25.Text = "AUTO-FLOOR 9"
		t2.value25.BackgroundColor3 = t2.value10

		if ok then
			return
		end

		warn("AUTO-FLOOR 9: " .. tostring(result))
	end)
end)
