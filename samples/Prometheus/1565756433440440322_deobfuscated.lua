-- This file was generated at discord.gg/syncrypt

local t1 = {}
local PlaceId = game.PlaceId
local GameId = game.GameId
local v4 = table.find({ 100448435050950, 74436060734791 }, PlaceId) and true or false

if table.find({ 372226183 }, GameId) and true or v4 then
	function t1.value8()
		task.spawn(function()
			pcall(function()
				loadstring(game:HttpGet("https://raw.githubusercontent.com/1D4vid/FTFNexVoid/refs/heads/main/nexvoid2.2.2"))()
			end)
		end)
	end

	local value8 = t1.value8

	t1.value1 = "NexVoidConfigs"

	local value9 = t1.value1 .. "/NexVoidSecurity.txt"

	t1.value2 = "2.8"

	local v7 = "NexVoid_Verified_V" .. t1.value2

	t1.value8 = {}

	local value82 = t1.value8

	function t1.value4(p1, p2)
		local t2 = {}

		for i = 1, #p1 do
			local v11 = string.byte(p1, i)
			local v12 = (i - 1) % #p2 + 1
			local v13 = (v11 + string.byte(p2, v12)) % 256
			local format = string.format

			table.insert(t2, format("%02X", v13))
		end

		return table.concat(t2)
	end

	local function v15(p3)
		local v16 = value82

		table.insert(v16, p3)

		return p3
	end

	local value4 = t1.value4

	function t1.value4(p4, p5)
		local t3 = {}
		local n1 = 1
		local ok = pcall(function()
			for i = 1, #p4, 2 do
				local v22 = p4
				local v23 = i + 1
				local v24 = string.sub(v22, i, v23)
				local v25 = tonumber(v24, 16)

				if not v25 then
					error()
				end

				local v26 = p5
				local v27 = (n1 - 1) % #p5 + 1
				local v28 = (v25 - string.byte(v26, v27) + 256) % 256
				local v29 = t3
				local v30 = string.char(v28)

				table.insert(v29, v30)
				n1 = n1 + 1
			end
		end)

		if not ok then
			return ok or nil
		end

		ok = table.concat(t3)

		return ok or nil
	end

	local isfolder_ = isfolder
	local value3

	if type(isfolder_) == "function" then
		value3 = not isfolder("NexVoidConfigs")
	else
		value3 = false
	end

	t1.value3 = value3

	if t1.value3 then
		local makefolder_ = makefolder

		t1.value5 = type(makefolder_)

		if t1.value5 == "function" then
			pcall(function()
				makefolder("NexVoidConfigs")
			end)
		end
	end

	t1.value3 = false

	local isfile_ = isfile
	local value6

	if type(isfile_) == "function" then
		value6 = isfile(value9)
	else
		value6 = false
	end

	t1.value6 = value6

	if t1.value6 then
		local readfile_ = readfile

		t1.value7 = type(readfile_)

		if t1.value7 == "function" then
			t1.value6 = pcall
			t1.value10 = readfile
			t1.value9 = value9
			t1.value11 = { t1.value6(t1.value10, t1.value9) }
			t1.value7 = t1.value11[2]

			if t1.value11[1] then
				t1.value6 = t1.value4(t1.value7, "NexVoid_UltraSecure_Key_V2.8")
				t1.value10 = t1.value6

				if t1.value6 then
					t1.value10 = string.find(t1.value6, v7)
				end

				if t1.value10 then
					t1.value3 = false
				else
					t1.value3 = true
				end
			else
				t1.value3 = true
			end
		end
	else
		local getgenv_ = getgenv

		t1.value11 = type(getgenv_)

		if t1.value11 == "function" then
			t1.value12 = getgenv()

			if not t1.value12["NexVoid_Update_2.8"] then
				t1.value3 = true
			end
		else
			t1.value3 = true
		end
	end

	if not t1.value3 then
		value8()

		return
	end

	t1.value12 = game:GetService("CoreGui")
	t1.value13 = game:GetService("TweenService")

	local value13 = t1.value13

	t1.value14 = game:GetService("RunService")

	local value14 = t1.value14

	t1.value15 = game:GetService("Players")

	local value15 = t1.value15

	t1.value16 = game:GetService("UserInputService")
	t1.value17 = game:GetService("Stats")

	local value17 = t1.value17

	t1.value19 = game:GetService("HttpService")

	local value19 = t1.value19

	t1.value19 = value15.LocalPlayer

	local value192 = t1.value19

	t1.value22 = value14:IsStudio()
	t1.value18 = t1.value22

	if t1.value22 then
		t1.value18 = value192:WaitForChild("PlayerGui")
	end

	t1.value19 = t1.value18 or t1.value12
	t1.value18 = Color3.fromRGB(255, 255, 255)

	local value18 = t1.value18

	t1.value20 = Color3.fromRGB(15, 15, 17)
	t1.value21 = Color3.fromRGB(140, 140, 145)
	t1.value23 = Color3.fromRGB(6, 6, 6)

	local color3 = Color3.fromRGB(14, 14, 15)
	local color32 = Color3.fromRGB(35, 35, 38)
	local color33 = Color3.fromRGB(255, 255, 255)
	local color34 = Color3.fromRGB(150, 150, 155)
	local color35 = Color3.fromRGB(245, 245, 245)

	t1.value18 = {
		Bg = t1.value23,
		Surface = color3,
		Stroke = color32,
		TextMain = color33,
		TextSub = color34,
		Accent = color35
	}

	local value182 = t1.value18
	local ScreenGui = Instance.new("ScreenGui")

	ScreenGui.Name = "NexVoidIntro"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.DisplayOrder = 2147483647
	ScreenGui.Parent = t1.value19
	t1.value23 = Instance.new("Frame")

	local value23 = t1.value23

	t1.value23 = value23

	local uDim2 = UDim2.new(1, 0, 1, 0)

	t1.value23.Size = uDim2
	t1.value23 = value23

	local color36 = Color3.fromRGB(6, 6, 6)

	t1.value23.BackgroundColor3 = color36
	t1.value23 = value23
	t1.value23.BackgroundTransparency = 1
	t1.value23 = value23
	t1.value23.ClipsDescendants = true
	t1.value23 = value23
	t1.value23.Parent = ScreenGui

	local Frame = Instance.new("Frame")

	Frame.Size = UDim2.new(0, 240, 0, 240)
	Frame.Position = UDim2.new(0.5, 0, 0.46, 0)
	Frame.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame.BackgroundTransparency = 1
	Frame.Parent = value23

	local UIScale = Instance.new("UIScale")

	UIScale.Scale = 0
	UIScale.Parent = Frame

	local v57 = nil

	local function v58()
		if not (Frame.Parent and v57) then
			return
		end

		local Frame2 = Instance.new("Frame")
		local v60 = math.random(5, 9)

		Frame2.Size = UDim2.new(0, 0, 0, 0)
		Frame2.BackgroundColor3 = value18
		Frame2.BackgroundTransparency = 0.1
		Frame2.Rotation = 45
		Frame2.ZIndex = 4

		local v61 = math.random(0, 360) * 3.141592653589793 / 180
		local v62 = math.random(90, 125)
		local v63 = math.cos(v61)
		local math_ = math
		local v65 = v63 * v62
		local v66 = math_.sin(v61) * v62

		Frame2.Position = UDim2.new(0.5, v65, 0.5, v66)
		Frame2.Parent = Frame

		local UIStroke = Instance.new("UIStroke")

		UIStroke.Color = value18
		UIStroke.Thickness = 1.5
		UIStroke.Transparency = 0.4
		UIStroke.Parent = Frame2

		local v68 = math.random(12, 18) / 10
		local v69 = value13
		local tweenInfo = TweenInfo.new(v68 * 0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
		local UDim2_ = UDim2

		v69.Create(v69, Frame2, tweenInfo, {
			Size = UDim2_.new(0, v60, 0, v60)
		}):Play()

		local v72 = v65 + math.cos(v61) * math.random(15, 30)
		local v73 = v66 + math.sin(v61) * math.random(15, 30)

		value13:Create(Frame2, TweenInfo.new(v68, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Position = UDim2.new(0.5, v72, 0.5, v73),
			Rotation = 135,
			BackgroundTransparency = 1
		}):Play()
		value13:Create(UIStroke, TweenInfo.new(v68, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Transparency = 1
		}):Play()
		task.delay(v68, function()
			Frame2:Destroy()
		end)
	end

	v57 = true

	local function v74()
		if not (value23.Parent and v57) then
			return
		end

		local Frame2 = Instance.new("Frame")

		Frame2.BorderSizePixel = 0
		Frame2.BackgroundColor3 = value18
		Frame2.BackgroundTransparency = 0.92

		local v76 = math.random(120, 280)
		local v77 = math.random(10, 90) / 100
		local v78 = math.random(1, 2) == 1 and 1 or -1

		Frame2.Size = UDim2.new(0, v76, 0, 1)
		Frame2.Position = UDim2.new(v78 == 1 and -0.3 or 1.3, 0, v77, 0)
		Frame2.Parent = value23

		local UIGradient = Instance.new("UIGradient")

		UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(0.5, value18), ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)) })
		UIGradient.Parent = Frame2

		local v80 = math.random(4, 7)
		local v81 = value13
		local tweenInfo = TweenInfo.new(v80, Enum.EasingStyle.Linear)
		local uDim2New = UDim2.new
		local math_ = math
		local v85 = v78 == 1 and 1.3 or -0.3
		local v86 = math_.random(-5, 5) / 100

		v81.Create(v81, Frame2, tweenInfo, {
			Position = uDim2New(v85, 0, v77 + v86, 0)
		}):Play()
		task.delay(v80, function()
			Frame2:Destroy()
		end)
	end
	local function v87()
		if not (value23.Parent and v57) then
			return
		end

		local Frame2 = Instance.new("Frame")
		local v89 = math.random(2, 4)

		Frame2.Size = UDim2.new(0, v89, 0, v89)
		Frame2.BackgroundColor3 = value18
		Frame2.BackgroundTransparency = math.random(6, 8) / 10

		local UICorner = Instance.new("UICorner")

		UICorner.CornerRadius = UDim.new(1, 0)
		UICorner.Parent = Frame2
		Frame2.Position = UDim2.new(math.random(5, 95) / 100, 0, 1.1, 0)
		Frame2.Parent = value23

		local v91 = math.random(5, 9)
		local v92 = value13
		local tweenInfo = TweenInfo.new(v91, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		local uDim2New = UDim2.new
		local Position = Frame2.Position

		v92.Create(v92, Frame2, tweenInfo, {
			Position = uDim2New(Position.X.Scale + math.random(-15, 15) / 100, 0, -0.1, 0),
			BackgroundTransparency = 1
		}):Play()
		task.delay(v91, function()
			Frame2:Destroy()
		end)
	end

	task.spawn(function()
		while v57 do
			v74()
			task.wait(0.6)
		end
	end)
	task.spawn(function()
		while v57 do
			v87()
			task.wait(0.35)
		end
	end)
	task.spawn(function()
		while v57 do
			v58()
			task.wait(0.24)
		end
	end)

	local Frame2 = Instance.new("Frame")

	Frame2.Size = UDim2.new(0.9, 0, 0.9, 0)
	Frame2.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame2.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame2.BackgroundTransparency = 1
	Frame2.Parent = Frame

	local UICorner = Instance.new("UICorner")

	UICorner.CornerRadius = UDim.new(1, 0)
	UICorner.Parent = Frame2

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = Color3.fromRGB(0, 0, 0)
	UIStroke.Thickness = 12
	UIStroke.Transparency = 0.5
	UIStroke.Parent = Frame2

	local Frame3 = Instance.new("Frame")

	Frame3.Size = UDim2.new(0.85, 0, 0.85, 0)
	Frame3.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame3.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame3.BackgroundTransparency = 1
	Frame3.Parent = Frame

	local UICorner2 = Instance.new("UICorner")

	UICorner2.CornerRadius = UDim.new(1, 0)
	UICorner2.Parent = Frame3

	local UIStroke2 = Instance.new("UIStroke")

	UIStroke2.Color = value18
	UIStroke2.Thickness = 4.5
	UIStroke2.Parent = Frame3

	local UIGradient = Instance.new("UIGradient")

	UIGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.24, 0),
		NumberSequenceKeypoint.new(0.25, 1),
		NumberSequenceKeypoint.new(0.29, 1),
		NumberSequenceKeypoint.new(0.3, 0),
		NumberSequenceKeypoint.new(0.57, 0),
		NumberSequenceKeypoint.new(0.58, 1),
		NumberSequenceKeypoint.new(0.62, 1),
		NumberSequenceKeypoint.new(0.63, 0),
		NumberSequenceKeypoint.new(0.88, 0),
		NumberSequenceKeypoint.new(0.89, 1),
		NumberSequenceKeypoint.new(0.93, 1),
		NumberSequenceKeypoint.new(0.94, 0),
		NumberSequenceKeypoint.new(1, 0)
	})
	UIGradient.Rotation = 35
	UIGradient.Parent = UIStroke2

	local Frame4 = Instance.new("Frame")

	Frame4.Size = UDim2.new(0.76, 0, 0.76, 0)
	Frame4.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame4.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame4.BackgroundTransparency = 1
	Frame4.Parent = Frame

	local UICorner3 = Instance.new("UICorner")

	UICorner3.CornerRadius = UDim.new(1, 0)
	UICorner3.Parent = Frame4

	local UIStroke3 = Instance.new("UIStroke")

	UIStroke3.Color = value18
	UIStroke3.Thickness = 2.2
	UIStroke3.Parent = Frame4

	local UIGradient2 = Instance.new("UIGradient")

	UIGradient2.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.45, 0.1),
		NumberSequenceKeypoint.new(0.6, 1),
		NumberSequenceKeypoint.new(1, 1)
	})
	UIGradient2.Rotation = -45
	UIGradient2.Parent = UIStroke3

	local Frame5 = Instance.new("Frame")

	Frame5.Size = UDim2.new(0.65, 0, 0.65, 0)
	Frame5.Position = UDim2.new(0.5, 0, 0.5, 0)
	Frame5.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame5.BackgroundTransparency = 1
	Frame5.ZIndex = 1
	Frame5.Parent = Frame

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(1, 0)
	UICorner4.Parent = Frame5

	local UIStroke4 = Instance.new("UIStroke")

	UIStroke4.Color = value18
	UIStroke4.Thickness = 8
	UIStroke4.Transparency = 0.82
	UIStroke4.Parent = Frame5

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(0.85, 0, 0.85, 0)
	TextLabel.Position = UDim2.new(0.5, 0, 0.5, 0)
	TextLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = "NV"
	TextLabel.Font = Enum.Font.GothamBlack
	TextLabel.TextColor3 = value18
	TextLabel.TextSize = 115
	TextLabel.Rotation = -5
	TextLabel.ZIndex = 3
	TextLabel.Parent = Frame

	local UIStroke5 = Instance.new("UIStroke")

	UIStroke5.Color = t1.value20
	UIStroke5.Thickness = 3
	UIStroke5.Transparency = 0.1
	UIStroke5.Parent = TextLabel

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, 0, 0, 25)
	TextLabel2.Position = UDim2.new(0.5, 0, 0.5, 145)
	TextLabel2.AnchorPoint = Vector2.new(0.5, 0.5)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = ""
	TextLabel2.Font = Enum.Font.GothamMedium
	TextLabel2.TextColor3 = t1.value21
	TextLabel2.TextSize = 10.5
	TextLabel2.TextTransparency = 1
	TextLabel2.Parent = value23

	local UIStroke6 = Instance.new("UIStroke")

	UIStroke6.Color = Color3.fromRGB(0, 0, 0)
	UIStroke6.Thickness = 1.5
	UIStroke6.Transparency = 0.4
	UIStroke6.Parent = TextLabel2

	local connection = nil

	connection = value14.RenderStepped:Connect(function(dt)
		local Parent = UIGradient.Parent

		if not Parent then
			if Parent then
				UIGradient.Rotation = (UIGradient.Rotation + 45 * dt) % 360
				UIGradient2.Rotation = (UIGradient2.Rotation - 120 * dt) % 360
			else
				connection:Disconnect()
			end

			return
		end

		Parent = UIGradient2.Parent

		if Parent then
			UIGradient.Rotation = (UIGradient.Rotation + 45 * dt) % 360
			UIGradient2.Rotation = (UIGradient2.Rotation - 120 * dt) % 360
		else
			connection:Disconnect()
		end
	end)

	local ScreenGui2 = Instance.new("ScreenGui")

	ScreenGui2.Name = "NexVoidDashboard"
	ScreenGui2.ResetOnSpawn = false
	ScreenGui2.IgnoreGuiInset = true
	ScreenGui2.DisplayOrder = 2147483646
	ScreenGui2.Enabled = false
	ScreenGui2.Parent = t1.value19

	local Frame6 = Instance.new("Frame")

	Frame6.Size = UDim2.new(1, 0, 1, 0)
	Frame6.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	Frame6.BackgroundTransparency = 1
	Frame6.Parent = ScreenGui2

	local Frame7 = Instance.new("Frame")

	Frame7.Size = UDim2.new(0, 840, 0, 420)
	Frame7.Position = UDim2.new(0.5, 0, 0.5, 50)
	Frame7.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame7.BackgroundTransparency = 1
	Frame7.Parent = Frame6

	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.Padding = UDim.new(0, 15)
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Parent = Frame7

	local UIScale2 = Instance.new("UIScale")

	UIScale2.Scale = 0.5
	UIScale2.Parent = Frame7

	local CurrentCamera = workspace.CurrentCamera or workspace:FindFirstChildOfClass("Camera")
	local u122 = (function()
		if CurrentCamera then
			local ViewportSize = CurrentCamera.ViewportSize
			local v124 = ViewportSize.X / 950
			local v125 = ViewportSize.Y / 500
			local v126 = math.min(v124, v125)

			return math.clamp(v126, 0.4, 1)
		else
			return 1
		end
	end)()

	UIScale2.Scale = u122

	if CurrentCamera then
		CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
			if not ScreenGui2.Parent then
				return
			end

			local v127

			if CurrentCamera then
				local ViewportSize = CurrentCamera.ViewportSize
				local v129 = ViewportSize.X / 950
				local v130 = ViewportSize.Y / 500
				local v131 = math.min(v129, v130)

				v127 = math.clamp(v131, 0.4, 1)
			else
				v127 = 1
			end

			u122 = v127

			local v132 = value13
			local v133 = UIScale2
			local tweenInfoNew = TweenInfo.new
			local t4 = {
				Scale = u122
			}

			v132.Create(v132, v133, tweenInfoNew(0.2), t4):Play()
		end)
	end

	local function v136(p6, p7)
		local Frame8 = Instance.new("Frame")

		Frame8.Size = UDim2.new(1, 0, 0, 1)
		Frame8.Position = UDim2.new(0, 0, 0, p7)
		Frame8.BackgroundColor3 = value182.Stroke
		Frame8.BorderSizePixel = 0
		Frame8.Parent = p6
	end
	local function v138(p8)
		local UIGradient3 = Instance.new("UIGradient")

		UIGradient3.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(15, 15, 15)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(15, 15, 15)) })
		UIGradient3.Parent = p8

		local rotation = 0
		local connection2 = nil

		connection2 = value14.RenderStepped:Connect(function(dt)
			local Parent = p8

			if not Parent then
				if Parent then
					rotation = (rotation + 30 * dt) % 360
					UIGradient3.Rotation = rotation
				else
					connection2:Disconnect()
				end

				return
			end

			Parent = p8.Parent

			if Parent then
				rotation = (rotation + 30 * dt) % 360
				UIGradient3.Rotation = rotation
			else
				connection2:Disconnect()
			end
		end)

		local v143 = connection2
		local v144 = value82

		table.insert(v144, v143)
	end
	local function createFrame(p9, p10, p11)
		local Frame8 = Instance.new("Frame")

		Frame8.Name = p9
		Frame8.Size = UDim2.new(0, p10, 1, 0)
		Frame8.BackgroundColor3 = value182.Bg
		Frame8.LayoutOrder = p11
		Frame8.Parent = Frame7

		local UICorner5 = Instance.new("UICorner")

		UICorner5.CornerRadius = UDim.new(0, 6)
		UICorner5.Parent = Frame8

		local UIStroke7 = Instance.new("UIStroke")

		UIStroke7.Color = Color3.fromRGB(255, 255, 255)
		UIStroke7.Thickness = 1.2
		UIStroke7.Parent = Frame8
		v138(UIStroke7)

		return Frame8
	end
	local function v150()
		for _, v in ipairs(value82) do
			if v.Connected then
				v:Disconnect()
			end
		end

		table.clear(value82)
		value13:Create(UIScale2, TweenInfo.new(0.3, Enum.EasingStyle.Quint, Enum.EasingDirection.In), {
			Scale = u122 * 0.8
		}):Play()
		value13:Create(Frame6, TweenInfo.new(0.3), {
			BackgroundTransparency = 1
		}):Play()
		task.wait(0.3)
		ScreenGui2:Destroy()
		value8()
	end

	t1.value25 = {
		UserInfo = "User Info",
		Exec = "Executor",
		Dev = "Device",
		Reg = "Timezone",
		MidTitle = "Community & Feedback",
		DTitle = "Official Discord Server",
		DFeat = "• Full Executors Support\n• Key Bypasses & Updates\n• Open Source Scripts & More",
		Copy = "Copy Link",
		Join = "Join Server",
		Copied = "Copied!",
		FeedTitle = "Do you like NexVoid?",
		FeedSub = "Help us improve by submitting your feedback.",
		Yes = "Yes",
		No = "No",
		Sent = "Feedback Sent!",
		ChangeTitle = "Changelog",
		L1 = "• Added translation for notifications\n• Interface image IDs changed\n• Some Reworked Scripts\n• New functions added\n• Improved UI performance\n\nAny bugs that occur will be fixed soon.\nThank you very much for using NexVoid.",
		L2 = "• UI Reworked\n• Added More functions\n• Fixed and reworked ALL scripts in the \"Progress\" category\n• Still undetected and Working\n• Improved UI performance",
		L3 = "• Added Auto Farm features\n• Highlights logic reworked\n• New visual configurations\n• Minor bugs fixed\n• UI performance improvements"
	}

	local t6 = {
		EN = t1.value25,
		PT = {
			UserInfo = "Info do Usuário",
			Exec = "Executor",
			Dev = "Dispositivo",
			Reg = "Fuso Horário",
			MidTitle = "Comunidade e Avaliação",
			DTitle = "Servidor Oficial do Discord",
			DFeat = "• Suporte a Todos Executores\n• Bypass de Keys e Updates\n• Scripts Open Source e Mais",
			Copy = "Copiar Link",
			Join = "Entrar no Servidor",
			Copied = "Copiado!",
			FeedTitle = "Você gosta do NexVoid?",
			FeedSub = "Ajude-nos a melhorar enviando sua avaliação.",
			Yes = "Sim",
			No = "Não",
			Sent = "Avaliação Enviada!",
			ChangeTitle = "Histórico de Atualizações",
			L1 = "• Adicionado tradução para notificações\n• IDs de imagem da interface alterados\n• Alguns scripts refeitos\n• Novas funções adicionadas\n• Desempenho da UI aprimorado\n\nQualquer bug que ocorra será corrigido em breve.\nMuito obrigado por usar o NexVoid.",
			L2 = "• Interface Gráfica Refeita\n• Mais funções adicionadas\n• TODOS os scripts da categoria \"Progress\" corrigidos e refeitos\n• Continua indetectável e Funcionando\n• Desempenho da UI melhorado",
			L3 = "• Adicionado Auto Farm\n• Lógica de Highlights refeita\n• Novas configurações visuais\n• Pequenos bugs corrigidos\n• Desempenho da UI melhorado"
		},
		ES = {
			UserInfo = "Info del Usuario",
			Exec = "Ejecutor",
			Dev = "Dispositivo",
			Reg = "Zona Horaria",
			MidTitle = "Comunidad y Opinión",
			DTitle = "Servidor Oficial de Discord",
			DFeat = "• Soporte para Todos los Ejecutores\n• Bypass de Keys y Updates\n• Scripts Open Source y Más",
			Copy = "Copiar Enlace",
			Join = "Unirse al Servidor",
			Copied = "¡Copiado!",
			FeedTitle = "¿Te gusta NexVoid?",
			FeedSub = "Ayúdanos a mejorar enviando tu opinión.",
			Yes = "Sí",
			No = "No",
			Sent = "¡Opinión Enviada!",
			ChangeTitle = "Registro de Cambios",
			L1 = "• Añadido traducción para notificaciones\n• IDs de imagen de interfaz cambiados\n• Algunos scripts rehechos\n• Nuevas funciones añadidas\n• Rendimiento de UI mejorado\n\nCualquier error que ocurra se corregirá pronto.\nMuchas gracias por usar NexVoid.",
			L2 = "• Interfaz Gráfica Rehecha\n• Más funciones añadidas\n• TODOS los scripts de la categoría \"Progress\" corrigidos y rehechos\n• Sigue indetectable y Funcionando\n• Mejoras de rendimiento en la UI",
			L3 = "• Funciones de Auto Farm añadidas\n• Lógica de Highlights rehecha\n• Nuevas configuraciones visuales\n• Pequeños errores corregidos\n• Mejoras de rendimiento"
		}
	}
	local LeftPanel = createFrame("LeftPanel", 220, 1)
	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Size = UDim2.new(1, -30, 0, 45)
	TextLabel3.Position = UDim2.new(0, 15, 0, 0)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Text = t6.EN.UserInfo
	TextLabel3.Font = Enum.Font.GothamBold
	TextLabel3.TextColor3 = value182.TextMain
	TextLabel3.TextSize = 13
	TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel3.Parent = LeftPanel

	local t5 = {
		UserInfo = TextLabel3
	}

	v136(LeftPanel, 45)

	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Size = UDim2.new(0, 65, 0, 65)
	ImageLabel.Position = UDim2.new(0.5, 0, 0, 65)
	ImageLabel.AnchorPoint = Vector2.new(0.5, 0)
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Parent = LeftPanel

	local UICorner5 = Instance.new("UICorner")

	UICorner5.CornerRadius = UDim.new(0, 6)
	UICorner5.Parent = ImageLabel

	local UIStroke7 = Instance.new("UIStroke")

	UIStroke7.Color = value182.Stroke
	UIStroke7.Parent = ImageLabel
	task.spawn(function()
		local function v159()
			ImageLabel.Image = value15:GetUserThumbnailAsync(value192.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
		end

		pcall(v159)
	end)

	local TextLabel4 = Instance.new("TextLabel")

	TextLabel4.Size = UDim2.new(1, -20, 0, 15)
	TextLabel4.Position = UDim2.new(0, 10, 0, 140)
	TextLabel4.BackgroundTransparency = 1
	t1.value24 = value192.Name
	TextLabel4.Text = t1.value24
	t1.value24 = Enum.Font.GothamBold
	TextLabel4.Font = t1.value24
	t1.value24 = value182.TextMain
	TextLabel4.TextColor3 = t1.value24
	TextLabel4.TextSize = 12
	TextLabel4.Parent = LeftPanel
	v136(LeftPanel, 170)

	local function createTextLabel(p12, p13)
		local TextLabel5 = Instance.new("TextLabel")

		TextLabel5.Size = UDim2.new(0, 70, 0, 15)
		TextLabel5.Position = UDim2.new(0, 15, 0, p13)
		TextLabel5.BackgroundTransparency = 1
		TextLabel5.Text = t6.EN[p12] or p12
		TextLabel5.Font = Enum.Font.Gotham
		TextLabel5.TextColor3 = value182.TextSub
		TextLabel5.TextSize = 10
		TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel5.Parent = LeftPanel

		local v163

		if p12 == "FPS" then
			v163 = false
		else
			v163 = p12 ~= "Ping"
		end

		if not v163 then
			v177 = Instance.new("TextLabel")
			v177.Size = UDim2.new(1, -100, 0, 15)
			v177.Position = UDim2.new(0, 85, 0, p13)
			v177.BackgroundTransparency = 1
			v177.Text = "..."
			v177.Font = Enum.Font.GothamBold
			v177.TextColor3 = value182.TextMain
			v177.TextSize = 11
			v177.TextXAlignment = Enum.TextXAlignment.Right
			v177.Parent = LeftPanel

			return v177
		end

		t5[p12] = TextLabel5

		local TextLabel6 = Instance.new("TextLabel")

		TextLabel6.Size = UDim2.new(1, -100, 0, 15)
		TextLabel6.Position = UDim2.new(0, 85, 0, p13)
		TextLabel6.BackgroundTransparency = 1
		TextLabel6.Text = "..."
		TextLabel6.Font = Enum.Font.GothamBold
		TextLabel6.TextColor3 = value182.TextMain
		TextLabel6.TextSize = 11
		TextLabel6.TextXAlignment = Enum.TextXAlignment.Right
		TextLabel6.Parent = LeftPanel

		return TextLabel6
	end

	t1.value24 = createTextLabel("Exec", 185)

	local Dev = createTextLabel("Dev", 205)
	local fps = createTextLabel("FPS", 225)
	local Ping = createTextLabel("Ping", 245)
	local Reg = createTextLabel("Reg", 265)
	local identifyexecutor_ = identifyexecutor and identifyexecutor() or "Unknown"

	t1.value24.Text = identifyexecutor_
	Dev.Text = t1.value16.TouchEnabled and not t1.value16.KeyboardEnabled and "Mobile" or "PC"
	Reg.Text = os.date("%Z") or "Local"

	local n2 = 0

	t1.value26 = value14.RenderStepped:Connect(function()
		n2 = n2 + 1
	end)
	v15(t1.value26)
	task.spawn(function()
		while task.wait(1) and LeftPanel.Parent do
			local v171 = n2

			local function v172()
				local v173 = Ping
				local value = value17.Network.ServerStatsItem["Data Ping"]:GetValue()
				local v175 = math.floor(value)

				v173.Text = tostring(v175) .. " ms"
			end

			fps.Text = tostring(v171) .. " fps"
			n2 = 0
			pcall(v172)
		end
	end)
	v136(LeftPanel, 295)

	local TextLabel5 = Instance.new("TextLabel")

	TextLabel5.Size = UDim2.new(1, 0, 0, 20)
	TextLabel5.Position = UDim2.new(0, 0, 0, 320)
	TextLabel5.BackgroundTransparency = 1
	TextLabel5.Font = Enum.Font.GothamBlack
	TextLabel5.TextColor3 = value182.TextMain
	TextLabel5.TextSize = 16
	TextLabel5.Parent = LeftPanel

	local TextLabel6 = Instance.new("TextLabel")

	TextLabel6.Size = UDim2.new(1, 0, 0, 15)
	TextLabel6.Position = UDim2.new(0, 0, 0, 345)
	TextLabel6.BackgroundTransparency = 1
	TextLabel6.Font = Enum.Font.Gotham
	TextLabel6.TextColor3 = value182.TextSub
	TextLabel6.TextSize = 11
	TextLabel6.Parent = LeftPanel
	task.spawn(function()
		while task.wait(1) and LeftPanel.Parent do
			TextLabel5.Text = os.date("%I:%M:%S %p")
			TextLabel6.Text = os.date("%B %d, %Y")
		end
	end)

	local CenterPanel = createFrame("CenterPanel", 350, 2)
	local TextLabel7 = Instance.new("TextLabel")

	TextLabel7.Size = UDim2.new(0, 180, 0, 45)
	TextLabel7.Position = UDim2.new(0, 15, 0, 0)
	TextLabel7.BackgroundTransparency = 1
	TextLabel7.Text = t6.EN.MidTitle
	TextLabel7.Font = Enum.Font.GothamBold
	TextLabel7.TextColor3 = value182.TextMain
	TextLabel7.TextSize = 13
	TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel7.Parent = CenterPanel
	t5.MidTitle = TextLabel7

	local Frame8 = Instance.new("Frame")

	Frame8.Size = UDim2.new(0, 95, 0, 45)
	Frame8.Position = UDim2.new(1, -165, 0, 0)
	Frame8.BackgroundTransparency = 1
	Frame8.Parent = CenterPanel

	local UIListLayout2 = Instance.new("UIListLayout")

	UIListLayout2.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout2.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout2.Padding = UDim.new(0, 8)
	UIListLayout2.Parent = Frame8

	local v182 = connection
	local t7 = {}

	for _, v in ipairs({ "EN", "PT", "ES" }) do
		local TextButton = Instance.new("TextButton")

		TextButton.Size = UDim2.new(0, 20, 0, 20)
		TextButton.BackgroundTransparency = 1
		TextButton.Text = v
		TextButton.Font = Enum.Font.GothamBold

		local s1 = "TextColor3"
		local v188 = v == "EN"

		if v188 then
			v188 = value182.TextMain
		end

		TextButton[s1] = v188 or value182.TextSub
		TextButton.TextSize = 11
		TextButton.Parent = Frame8
		t7[v] = TextButton
		TextButton.MouseButton1Click:Connect(function()
			setLang(v)
		end)
	end

	local TextButton = Instance.new("TextButton")

	TextButton.Size = UDim2.new(0, 40, 0, 45)
	TextButton.Position = UDim2.new(1, -40, 0, 0)
	TextButton.BackgroundTransparency = 1
	TextButton.Text = "X"
	TextButton.Font = Enum.Font.GothamBlack
	TextButton.TextColor3 = value182.TextSub
	TextButton.TextSize = 18
	TextButton.Parent = CenterPanel
	TextButton.MouseEnter:Connect(function()
		local v190 = value13
		local v191 = TextButton
		local tweenInfo = TweenInfo.new(0.2)
		local Color3_ = Color3

		v190.Create(v190, v191, tweenInfo, {
			TextColor3 = Color3_.fromRGB(255, 80, 80)
		}):Play()
	end)
	TextButton.MouseLeave:Connect(function()
		local v194 = value13
		local v195 = TextButton
		local tweenInfo = TweenInfo.new(0.2)

		v194.Create(v194, v195, tweenInfo, {
			TextColor3 = value182.TextSub
		}):Play()
	end)
	TextButton.MouseButton1Click:Connect(v150)
	v136(CenterPanel, 45)

	local Frame9 = Instance.new("Frame")

	Frame9.Size = UDim2.new(1, -30, 0, 185)
	Frame9.Position = UDim2.new(0, 15, 0, 60)
	Frame9.BackgroundTransparency = 1
	Frame9.Parent = CenterPanel

	local UICorner6 = Instance.new("UICorner")

	UICorner6.CornerRadius = UDim.new(0, 6)
	UICorner6.Parent = Frame9

	local UIStroke8 = Instance.new("UIStroke")

	UIStroke8.Color = value182.Stroke
	UIStroke8.Parent = Frame9

	local ImageLabel2 = Instance.new("ImageLabel")

	ImageLabel2.Size = UDim2.new(0, 32, 0, 32)
	ImageLabel2.Position = UDim2.new(0, 15, 0, 15)
	ImageLabel2.BackgroundTransparency = 1
	ImageLabel2.Image = "rbxassetid://129831248340415"
	ImageLabel2.Parent = Frame9

	local TextLabel8 = Instance.new("TextLabel")

	TextLabel8.Size = UDim2.new(1, -65, 0, 15)
	TextLabel8.Position = UDim2.new(0, 60, 0, 15)
	TextLabel8.BackgroundTransparency = 1
	TextLabel8.Text = t6.EN.DTitle
	TextLabel8.Font = Enum.Font.GothamBold
	TextLabel8.TextColor3 = value182.TextMain
	TextLabel8.TextSize = 12
	TextLabel8.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel8.Parent = Frame9
	t5.DTitle = TextLabel8

	local TextLabel9 = Instance.new("TextLabel")

	TextLabel9.Size = UDim2.new(1, -65, 0, 45)
	TextLabel9.Position = UDim2.new(0, 60, 0, 35)
	TextLabel9.BackgroundTransparency = 1
	TextLabel9.Text = t6.EN.DFeat
	TextLabel9.Font = Enum.Font.GothamMedium
	TextLabel9.TextColor3 = value182.TextSub
	TextLabel9.TextSize = 10
	TextLabel9.LineHeight = 1.3
	TextLabel9.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel9.TextYAlignment = Enum.TextYAlignment.Top
	TextLabel9.Parent = Frame9
	t5.DFeat = TextLabel9

	local Frame10 = Instance.new("Frame")

	Frame10.Size = UDim2.new(1, -30, 0, 35)
	Frame10.Position = UDim2.new(0, 15, 0, 90)
	Frame10.BackgroundTransparency = 1
	Frame10.Parent = Frame9

	local UICorner7 = Instance.new("UICorner")

	UICorner7.CornerRadius = UDim.new(0, 4)
	UICorner7.Parent = Frame10

	local UIStroke9 = Instance.new("UIStroke")

	UIStroke9.Color = value182.Stroke
	UIStroke9.Parent = Frame10

	local TextLabel10 = Instance.new("TextLabel")

	TextLabel10.Size = UDim2.new(1, -20, 1, 0)
	TextLabel10.Position = UDim2.new(0, 10, 0, 0)
	TextLabel10.BackgroundTransparency = 1
	TextLabel10.Text = "discord.gg/ATXbsv8aM7"
	TextLabel10.Font = Enum.Font.GothamMedium
	TextLabel10.TextColor3 = value182.TextSub
	TextLabel10.TextSize = 11
	TextLabel10.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel10.Parent = Frame10

	local TextButton2 = Instance.new("TextButton")

	TextButton2.Size = UDim2.new(0.47, 0, 0, 36)
	TextButton2.Position = UDim2.new(0, 15, 1, -50)
	TextButton2.BackgroundTransparency = 1
	TextButton2.Text = t6.EN.Copy
	TextButton2.Font = Enum.Font.GothamBold
	TextButton2.TextColor3 = value182.TextMain
	TextButton2.TextSize = 11
	TextButton2.Parent = Frame9

	local UICorner8 = Instance.new("UICorner")

	UICorner8.CornerRadius = UDim.new(0, 4)
	UICorner8.Parent = TextButton2

	local UIStroke10 = Instance.new("UIStroke")

	UIStroke10.Color = value182.Stroke
	UIStroke10.Parent = TextButton2
	t5.Copy = TextButton2

	local TextButton3 = Instance.new("TextButton")

	TextButton3.Size = UDim2.new(0.47, 0, 0, 36)
	TextButton3.Position = UDim2.new(1, -15, 1, -50)
	TextButton3.AnchorPoint = Vector2.new(1, 0)
	TextButton3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TextButton3.Text = t6.EN.Join
	TextButton3.Font = Enum.Font.GothamBold
	TextButton3.TextColor3 = Color3.fromRGB(15, 15, 15)
	TextButton3.TextSize = 11
	TextButton3.Parent = Frame9

	local UICorner9 = Instance.new("UICorner")

	UICorner9.CornerRadius = UDim.new(0, 4)
	UICorner9.Parent = TextButton3
	t5.Join = TextButton3

	local UIGradient3 = Instance.new("UIGradient")

	UIGradient3.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 210, 210)) })
	UIGradient3.Rotation = 90
	UIGradient3.Parent = TextButton3
	TextButton2.MouseButton1Click:Connect(function()
		if not setclipboard then
			return
		end

		setclipboard("https://discord.gg/ATXbsv8aM7")
		TextButton2.Text = t6.EN.Copied
		task.wait(1.5)
		TextButton2.Text = t6.EN.Copy
	end)
	TextButton3.MouseButton1Click:Connect(function()
		local request_ = request or (http_request or syn.request)

		if not request_ then
			return
		end

		local function v214()
			local v215 = value19

			request_({
				Url = "http://127.0.0.1:6463/rpc?v=1",
				Method = "POST",
				Headers = {
					["Content-Type"] = "application/json",
					Origin = "https://discord.com"
				},
				Body = v215.JSONEncode(v215, {
					cmd = "INVITE_BROWSER",
					args = {
						code = "ATXbsv8aM7"
					},
					nonce = value19:GenerateGUID(false)
				})
			})
		end

		pcall(v214)
	end)
	v136(CenterPanel, 260)

	local Frame11 = Instance.new("Frame")

	Frame11.Size = UDim2.new(1, -30, 0, 130)
	Frame11.Position = UDim2.new(0, 15, 0, 275)
	Frame11.BackgroundTransparency = 1
	Frame11.Parent = CenterPanel

	local UICorner10 = Instance.new("UICorner")

	UICorner10.CornerRadius = UDim.new(0, 6)
	UICorner10.Parent = Frame11

	local UIStroke11 = Instance.new("UIStroke")

	UIStroke11.Color = value182.Stroke
	UIStroke11.Parent = Frame11

	local ImageLabel3 = Instance.new("ImageLabel")

	ImageLabel3.Size = UDim2.new(0, 32, 0, 32)
	ImageLabel3.Position = UDim2.new(0, 15, 0, 15)
	ImageLabel3.BackgroundTransparency = 1
	ImageLabel3.Image = "rbxassetid://138188957887846"
	ImageLabel3.Parent = Frame11

	local TextLabel11 = Instance.new("TextLabel")

	TextLabel11.Size = UDim2.new(1, -65, 0, 15)
	TextLabel11.Position = UDim2.new(0, 60, 0, 15)
	TextLabel11.BackgroundTransparency = 1
	TextLabel11.Text = t6.EN.FeedTitle
	TextLabel11.Font = Enum.Font.GothamBold
	TextLabel11.TextColor3 = value182.TextMain
	TextLabel11.TextSize = 13
	TextLabel11.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel11.Parent = Frame11
	t5.FeedTitle = TextLabel11

	local TextLabel12 = Instance.new("TextLabel")

	TextLabel12.Size = UDim2.new(1, -65, 0, 30)
	TextLabel12.Position = UDim2.new(0, 60, 0, 35)
	TextLabel12.BackgroundTransparency = 1
	TextLabel12.Text = t6.EN.FeedSub
	TextLabel12.Font = Enum.Font.Gotham
	TextLabel12.TextColor3 = value182.TextSub
	TextLabel12.TextSize = 11
	TextLabel12.TextWrapped = true
	TextLabel12.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel12.TextYAlignment = Enum.TextYAlignment.Top
	TextLabel12.Parent = Frame11
	t5.FeedSub = TextLabel12

	local TextButton4 = Instance.new("TextButton")

	TextButton4.Size = UDim2.new(0.47, 0, 0, 36)
	TextButton4.Position = UDim2.new(0, 15, 1, -50)
	TextButton4.BackgroundColor3 = Color3.fromRGB(46, 204, 113)
	TextButton4.Text = t6.EN.Yes
	TextButton4.Font = Enum.Font.GothamBold
	TextButton4.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextButton4.TextSize = 12
	TextButton4.Parent = Frame11

	local UICorner11 = Instance.new("UICorner")

	UICorner11.CornerRadius = UDim.new(0, 4)
	UICorner11.Parent = TextButton4
	t5.Yes = TextButton4

	local UIGradient4 = Instance.new("UIGradient")

	UIGradient4.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(210, 210, 210)) })
	UIGradient4.Rotation = 90
	UIGradient4.Parent = TextButton4

	local TextButton5 = Instance.new("TextButton")

	TextButton5.Size = UDim2.new(0.47, 0, 0, 36)
	TextButton5.Position = UDim2.new(1, -15, 1, -50)
	TextButton5.AnchorPoint = Vector2.new(1, 0)
	TextButton5.BackgroundColor3 = Color3.fromRGB(237, 66, 69)
	TextButton5.Text = t6.EN.No
	TextButton5.Font = Enum.Font.GothamBold
	TextButton5.TextColor3 = Color3.fromRGB(0, 0, 0)
	TextButton5.TextSize = 12
	TextButton5.Parent = Frame11

	local UICorner12 = Instance.new("UICorner")

	UICorner12.CornerRadius = UDim.new(0, 4)
	UICorner12.Parent = TextButton5
	t5.No = TextButton5
	UIGradient4:Clone().Parent = TextButton5
	TextButton4.MouseEnter:Connect(function()
		local v227 = value13
		local v228 = TextButton4
		local tweenInfo = TweenInfo.new(0.15)
		local color37 = Color3.fromRGB

		v227.Create(v227, v228, tweenInfo, {
			BackgroundColor3 = color37(86, 244, 153)
		}):Play()
	end)
	TextButton4.MouseLeave:Connect(function()
		local v231 = value13
		local v232 = TextButton4
		local tweenInfo = TweenInfo.new(0.15)
		local Color3_ = Color3

		v231.Create(v231, v232, tweenInfo, {
			BackgroundColor3 = Color3_.fromRGB(46, 204, 113)
		}):Play()
	end)
	TextButton5.MouseEnter:Connect(function()
		local v235 = value13
		local v236 = TextButton5
		local tweenInfo = TweenInfo.new(0.15)
		local color37 = Color3.fromRGB

		v235.Create(v235, v236, tweenInfo, {
			BackgroundColor3 = color37(255, 96, 99)
		}):Play()
	end)
	TextButton5.MouseLeave:Connect(function()
		local v239 = value13
		local v240 = TextButton5
		local tweenInfo = TweenInfo.new(0.15)
		local color37 = Color3.fromRGB

		v239.Create(v239, v240, tweenInfo, {
			BackgroundColor3 = color37(237, 66, 69)
		}):Play()
	end)

	local function v243(p14)
		TextButton4.Visible = false
		TextButton5.Visible = false
		TextLabel12.Visible = false
		TextLabel11.Position = UDim2.new(0, 60, 0.5, 0)
		TextLabel11.AnchorPoint = Vector2.new(0, 0.5)
		TextLabel11.Text = t6.EN.Sent
		t5.FeedTitle = nil
		task.spawn(function()
			local v244 = ("https://discord.com/api/webhooks/1494114029856096519/xEs1H50YPUFAqPgR8uqt4y5Xkqra90aOlRELa_4CXtYXRXb08VV5jw0uxdrkVLpYqB1F"):gsub("discord.com", "webhook.lewisakura.moe"):gsub("discordapp.com", "webhook.lewisakura.moe")
			local identifyexecutor_2 = identifyexecutor and identifyexecutor() or "Unknown"
			local t8 = {
				embeds = {
					{
						title = "⭐ NexVoid - Feedback",
						color = p14 == "Yes" and 3066993 or 15158332,
						fields = {
							{
								name = "Gostou do NexVoid?",
								value = p14,
								inline = false
							},
							{
								name = "👤 User",
								value = value192.Name,
								inline = true
							},
							{
								name = "⚙️ Executor",
								value = identifyexecutor_2,
								inline = true
							}
						}
					}
				}
			}
			local request_ = request or (http_request or syn.request)

			if not request_ then
				return
			end

			local function v248()
				request_({
					Url = v244,
					Method = "POST",
					Headers = {
						["Content-Type"] = "application/json"
					},
					Body = value19:JSONEncode(t8)
				})
			end

			pcall(v248)
		end)
	end

	TextButton4.MouseButton1Click:Connect(function()
		v243("Yes")
	end)
	TextButton5.MouseButton1Click:Connect(function()
		v243("No")
	end)

	local RightPanel = createFrame("RightPanel", 230, 3)
	local TextLabel13 = Instance.new("TextLabel")

	TextLabel13.Size = UDim2.new(1, -30, 0, 45)
	TextLabel13.Position = UDim2.new(0, 15, 0, 0)
	TextLabel13.BackgroundTransparency = 1
	TextLabel13.Text = t6.EN.ChangeTitle
	TextLabel13.Font = Enum.Font.GothamBold
	TextLabel13.TextColor3 = value182.TextMain
	TextLabel13.TextSize = 13
	TextLabel13.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel13.Parent = RightPanel
	t5.ChangeTitle = TextLabel13
	v136(RightPanel, 45)

	local ScrollingFrame = Instance.new("ScrollingFrame")

	ScrollingFrame.Size = UDim2.new(1, 0, 1, -50)
	ScrollingFrame.Position = UDim2.new(0, 0, 0, 45)
	ScrollingFrame.BackgroundTransparency = 1
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.ScrollBarThickness = 2
	ScrollingFrame.ScrollBarImageColor3 = value182.Stroke
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ScrollingFrame.Parent = RightPanel

	local UIListLayout3 = Instance.new("UIListLayout")

	UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout3.Padding = UDim.new(0, 12)
	UIListLayout3.Parent = ScrollingFrame

	local UIPadding = Instance.new("UIPadding")

	UIPadding.PaddingLeft = UDim.new(0, 15)
	UIPadding.PaddingRight = UDim.new(0, 15)
	UIPadding.PaddingTop = UDim.new(0, 15)
	UIPadding.Parent = ScrollingFrame

	local function v254(p15, p16, p17)
		local Frame12 = Instance.new("Frame")

		Frame12.Size = UDim2.new(1, 0, 0, 0)
		Frame12.BackgroundTransparency = 1
		Frame12.AutomaticSize = Enum.AutomaticSize.Y
		Frame12.Parent = ScrollingFrame

		local TextLabel14 = Instance.new("TextLabel")

		TextLabel14.Size = UDim2.new(1, 0, 0, 15)
		TextLabel14.BackgroundTransparency = 1
		TextLabel14.Text = "v" .. p15 .. " • " .. p16
		TextLabel14.Font = Enum.Font.GothamBold
		TextLabel14.TextColor3 = value182.TextMain
		TextLabel14.TextSize = 11
		TextLabel14.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel14.Parent = Frame12

		local TextLabel15 = Instance.new("TextLabel")

		TextLabel15.Size = UDim2.new(1, 0, 0, 0)
		TextLabel15.Position = UDim2.new(0, 0, 0, 22)
		TextLabel15.BackgroundTransparency = 1
		TextLabel15.Text = t6.EN[p17]
		TextLabel15.Font = Enum.Font.GothamMedium
		TextLabel15.TextColor3 = value182.TextSub
		TextLabel15.TextSize = 11
		TextLabel15.LineHeight = 1.3
		TextLabel15.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel15.TextYAlignment = Enum.TextYAlignment.Top
		TextLabel15.AutomaticSize = Enum.AutomaticSize.Y
		TextLabel15.Parent = Frame12
		t5[p17] = TextLabel15

		local Frame13 = Instance.new("Frame")

		Frame13.Size = UDim2.new(1, 0, 0, 1)
		Frame13.Position = UDim2.new(0, 0, 1, 10)
		Frame13.AnchorPoint = Vector2.new(0, 1)
		Frame13.BackgroundColor3 = value182.Stroke
		Frame13.BorderSizePixel = 0
		Frame13.Parent = Frame12
	end

	v254("2.8", "Ago 01, 2026", "L1")
	v254("2.7", "Jun 08, 2026", "L2")
	v254("2.6", "May 04, 2026", "L3")
	task.spawn(function()
		value13:Create(value23, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0.4
		}):Play()
		task.wait(0.1)
		value13:Create(UIScale, TweenInfo.new(0.8, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
			Scale = 1
		}):Play()
		value13:Create(TextLabel2, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			TextTransparency = 0
		}):Play()
		TextLabel2.Text = "loading script.."
		task.wait(1.5)
		TextLabel2.Text = "Downloading the new version.."
		task.wait(1.8)
		TextLabel2.Text = "optimizing script.."
		task.wait(1.5)
		TextLabel2.Text = "ENJOY"
		TextLabel2.TextColor3 = value18
		task.wait(1.2)

		local writefile_ = writefile

		if type(writefile_) == "function" then
			local v260 = value4(v7 .. " | User: " .. value192.Name .. " | Time: " .. os.date("%c"), "NexVoid_UltraSecure_Key_V2.8")

			pcall(writefile, value9, v260)
		else
			local getgenv_ = getgenv

			if type(getgenv_) == "function" then
				getgenv()["NexVoid_Update_2.8"] = true
			end
		end

		value13:Create(UIScale, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
			Scale = 0
		}):Play()
		value13:Create(TextLabel2, TweenInfo.new(0.4, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			TextTransparency = 1
		}):Play()
		value13:Create(value23, TweenInfo.new(0.6, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {
			BackgroundTransparency = 1
		}):Play()
		task.wait(0.6)

		if not v182 then
			ScreenGui:Destroy()
			ScreenGui2.Enabled = true
			value13:Create(Frame6, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
				BackgroundTransparency = 0.5
			}):Play()
			v279 = value13
			v280 = Frame7
			v281 = TweenInfo.new
			v282 = Enum.EasingStyle.Back
			v283 = Enum.EasingDirection
			v279.Create(v279, v280, v281(0.6, v282, v283.Out), {
				Position = UDim2.new(0.5, 0, 0.5, 0)
			}):Play()

			return
		end

		v182:Disconnect()
		ScreenGui:Destroy()
		ScreenGui2.Enabled = true
		value13:Create(Frame6, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			BackgroundTransparency = 0.5
		}):Play()

		local v262 = value13
		local v263 = Frame7
		local tweenInfoNew = TweenInfo.new
		local Back = Enum.EasingStyle.Back
		local EasingDirection = Enum.EasingDirection

		v262.Create(v262, v263, tweenInfoNew(0.6, Back, EasingDirection.Out), {
			Position = UDim2.new(0.5, 0, 0.5, 0)
		}):Play()
	end)

	return
end

local LocalPlayer = game:GetService("Players").LocalPlayer

if not LocalPlayer then
	return
end

LocalPlayer:Kick("Segurança: Você não está em um mapa ou servidor permitido.")
