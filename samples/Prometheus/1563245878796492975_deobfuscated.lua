-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack
local t2 = {
	value1 = game:GetService("TweenService"),
	value2 = game:GetService("UserInputService"),
	value3 = game:GetService("RunService"),
	value4 = game:GetService("Players"),
	value5 = game:GetService("Lighting"),
	value6 = game:GetService("CoreGui"),
	value7 = game:GetService("VirtualUser"),
	value8 = game:GetService("VirtualInputManager"),
	value9 = game:GetService("TeleportService"),
	value10 = game:GetService("HttpService")
}

t2.value11 = t2.value4.LocalPlayer
t2.value12 = workspace.CurrentCamera
t2.value11:GetMouse()

local ok, result = pcall(function()
	return t2.value6
end)

if not (ok and result) then
	local value11 = t2.value11

	result = value11.WaitForChild(value11, "PlayerGui")
end

if result:FindFirstChild("ZA_Kukirin_Life_Hub") then
	local ok2, result2 = pcall(function()
		return t2.value6
	end)

	if not (ok2 and result2) then
		local value11 = t2.value11

		result2 = value11.WaitForChild(value11, "PlayerGui")
	end

	result2:FindFirstChild("ZA_Kukirin_Life_Hub"):Destroy()
end

t2.value13 = {
	Dark = {
		Background = Color3.fromRGB(11, 14, 20),
		Sidebar = Color3.fromRGB(8, 10, 15),
		CardBg = Color3.fromRGB(16, 21, 30),
		CardHover = Color3.fromRGB(22, 29, 42),
		Border = Color3.fromRGB(28, 36, 50),
		BorderGlow = Color3.fromRGB(0, 162, 255),
		Accent = Color3.fromRGB(14, 115, 245),
		AccentGlow = Color3.fromRGB(56, 189, 248),
		AccentMuted = Color3.fromRGB(15, 31, 56),
		Text = Color3.fromRGB(245, 247, 250),
		TextMuted = Color3.fromRGB(140, 150, 165),
		TextDim = Color3.fromRGB(90, 100, 115),
		ToggleActive = Color3.fromRGB(14, 115, 245),
		ToggleInactive = Color3.fromRGB(35, 42, 54),
		FontBold = Enum.Font.GothamBold,
		FontMedium = Enum.Font.GothamMedium,
		FontRegular = Enum.Font.Gotham
	},
	Light = {
		Background = Color3.fromRGB(248, 250, 252),
		Sidebar = Color3.fromRGB(241, 245, 249),
		CardBg = Color3.fromRGB(255, 255, 255),
		CardHover = Color3.fromRGB(241, 245, 249),
		Border = Color3.fromRGB(226, 232, 240),
		BorderGlow = Color3.fromRGB(14, 115, 245),
		Accent = Color3.fromRGB(14, 115, 245),
		AccentGlow = Color3.fromRGB(2, 132, 199),
		AccentMuted = Color3.fromRGB(219, 234, 254),
		Text = Color3.fromRGB(15, 23, 42),
		TextMuted = Color3.fromRGB(71, 85, 105),
		TextDim = Color3.fromRGB(148, 163, 184),
		ToggleActive = Color3.fromRGB(14, 115, 245),
		ToggleInactive = Color3.fromRGB(203, 213, 225),
		FontBold = Enum.Font.GothamBold,
		FontMedium = Enum.Font.GothamMedium,
		FontRegular = Enum.Font.Gotham
	}
}
t2.value14 = "Dark"
t2.value15 = t2.value13.Dark

local function v10(p1, p2, p3)
	local tween = t2.value1:Create(p1, TweenInfo.new(p2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), p3)

	tween:Play()

	return tween
end
local function v12(p4, p5)
	local u13 = false
	local u14 = nil
	local Position = nil
	local Position2 = nil

	local function v17(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u13 = true
		Position = input.Position
		Position2 = p5.Position
		input.Changed:Connect(function()
			if input.UserInputState ~= Enum.UserInputState.End then
				return
			end

			u13 = false
		end)
	end

	p4.InputBegan:Connect(v17)

	local function v18(input)
		if not (input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u14 = input
	end

	p4.InputChanged:Connect(v18)
	t2.value2.InputChanged:Connect(function(input)
		local v19

		if input == u14 then
			v19 = u13
		else
			v19 = false
		end

		if not v19 then
			return
		end

		local v20 = input.Position - Position
		local v21 = p5
		local t3 = {
			Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v20.X, Position2.Y.Scale, Position2.Y.Offset + v20.Y)
		}

		t2.value1:Create(v21, TweenInfo.new(0.05, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t3):Play()
	end)
end

t2.value16 = {
	ScooterSpeedMultiplier = 1,
	AntiFallOff = true,
	AutoWheelie = false,
	InfiniteTorque = false,
	InstantPrompts = true,
	AutoDeliverLoop = false,
	PoliceESP = false,
	DeliveryESP = false,
	PlayerESP = false,
	Fullbright = false,
	WalkSpeed = 16,
	JumpPower = 50,
	FlyEnabled = false,
	FlySpeed = 50,
	Noclip = false,
	InfiniteJump = false,
	UnlockCursor = true,
	ForceCursorAlways = false,
	AntiAFK = true,
	SpawnCFrame = nil,
	Connections = {},
	ESPObjects = {}
}
t2.value17 = {
	Ambient = t2.value5.Ambient,
	Brightness = t2.value5.Brightness,
	ClockTime = t2.value5.ClockTime,
	FogEnd = t2.value5.FogEnd,
	GlobalShadows = t2.value5.GlobalShadows
}
pcall(function()
	local Character = t2.value11.Character

	if Character then
		Character = t2.value11.Character:FindFirstChild("HumanoidRootPart")
	end

	if not Character then
		return
	end

	local CFrame_ = t2.value11.Character.HumanoidRootPart.CFrame

	t2.value16.SpawnCFrame = CFrame_
end)
t2.value18 = Instance.new("ScreenGui")
t2.value18.Name = "ZA_Kukirin_Life_Hub"
t2.value18.ResetOnSpawn = false
t2.value18.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local value18 = t2.value18
local ok2, parent = pcall(function()
	return t2.value6
end)

if not (ok2 and parent) then
	local value11 = t2.value11

	parent = value11.WaitForChild(value11, "PlayerGui")
end

value18.Parent = parent
t2.value19 = Instance.new("Frame")
t2.value19.Name = "MainFrame"
t2.value19.Size = UDim2.new(0, 680, 0, 440)
t2.value19.Position = UDim2.new(0.5, -340, 0.5, -220)
t2.value19.BackgroundColor3 = t2.value15.Background
t2.value19.BorderSizePixel = 0
t2.value19.ClipsDescendants = true
t2.value19.Parent = t2.value18

local UICorner = Instance.new("UICorner")

UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = t2.value19
t2.value20 = Instance.new("UIStroke")
t2.value20.Thickness = 1.2
t2.value20.Color = t2.value15.Border
t2.value20.Parent = t2.value19

local Frame = Instance.new("Frame")

Frame.Name = "TopBar"
Frame.Size = UDim2.new(1, 0, 0, 48)
Frame.BackgroundTransparency = 1
Frame.Parent = t2.value19
v12(Frame, t2.value19)

local TextLabel = Instance.new("TextLabel")

TextLabel.Size = UDim2.new(0, 32, 0, 32)
TextLabel.Position = UDim2.new(0, 16, 0.5, -16)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "❄️"
TextLabel.TextSize = 20
TextLabel.Parent = Frame
t2.value21 = Instance.new("TextLabel")
t2.value21.Size = UDim2.new(0, 240, 1, 0)
t2.value21.Position = UDim2.new(0, 52, 0, 0)
t2.value21.BackgroundTransparency = 1
t2.value21.Font = t2.value15.FontBold
t2.value21.Text = "ZA HUB | Kukirin Life"
t2.value21.TextColor3 = t2.value15.Text
t2.value21.TextSize = 16
t2.value21.TextXAlignment = Enum.TextXAlignment.Left
t2.value21.Parent = Frame

local Frame2 = Instance.new("Frame")

Frame2.Name = "ControlsContainer"
Frame2.Size = UDim2.new(0, 116, 1, 0)
Frame2.Position = UDim2.new(1, -122, 0, 0)
Frame2.BackgroundTransparency = 1
Frame2.Parent = Frame
t2.value22 = Instance.new("TextButton")
t2.value22.Name = "ThemeBtn"
t2.value22.Size = UDim2.new(0, 30, 0, 30)
t2.value22.Position = UDim2.new(0, 4, 0.5, -15)
t2.value22.BackgroundTransparency = 1
t2.value22.Font = t2.value15.FontBold
t2.value22.Text = "🌙"
t2.value22.TextSize = 14
t2.value22.Parent = Frame2

local t1 = {
	value1 = Instance.new("TextButton")
}

t1.value1.Name = "MinimizeBtn"
t1.value1.Size = UDim2.new(0, 30, 0, 30)
t1.value1.Position = UDim2.new(0, 40, 0.5, -15)
t1.value1.BackgroundTransparency = 1
t1.value1.Font = t2.value15.FontBold
t1.value1.Text = "—"
t1.value1.TextColor3 = t2.value15.TextMuted
t1.value1.TextSize = 14
t1.value1.Parent = Frame2

local TextButton = Instance.new("TextButton")

TextButton.Name = "CloseBtn"
TextButton.Size = UDim2.new(0, 30, 0, 30)
TextButton.Position = UDim2.new(0, 78, 0.5, -15)
TextButton.BackgroundTransparency = 1
TextButton.Font = t2.value15.FontBold
TextButton.Text = "✕"
TextButton.TextColor3 = t2.value15.TextMuted
TextButton.TextSize = 14
TextButton.Parent = Frame2
t2.value22.MouseButton1Click:Connect(function()
	t2.value14 = t2.value14 == "Dark" and "Light" or "Dark"
	t2.value15 = t2.value13[t2.value14]
	t2.value22.Text = t2.value14 == "Light" and "☀️" or "🌙"

	local value19 = t2.value19
	local t4 = {
		BackgroundColor3 = t2.value15.Background
	}

	t2.value1:Create(value19, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t4):Play()

	local value20 = t2.value20
	local t5 = {
		Color = t2.value15.Border
	}

	t2.value1:Create(value20, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t5):Play()

	local value21 = t2.value21
	local t6 = {
		TextColor3 = t2.value15.Text
	}

	t2.value1:Create(value21, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t6):Play()
end)
t2.value23 = false
t1.value1.MouseButton1Click:Connect(function()
	t2.value23 = not t2.value23

	local value19 = t2.value19
	local uDim2 = t2.value23 and UDim2.new(0, 680, 0, 48) or UDim2.new(0, 680, 0, 440)

	t2.value1:Create(value19, TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = uDim2
	}):Play()
end)
TextButton.MouseButton1Click:Connect(function()
	local value19 = t2.value19
	local t7 = {
		Size = UDim2.new(0, 0, 0, 0),
		Position = UDim2.new(0.5, 0, 0.5, 0)
	}

	t2.value1:Create(value19, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t7):Play()
	task.wait(0.2)
	pcall(function()
		t2.value3:UnbindFromRenderStep("ZA_CursorUnlocker")
	end)
	t2.value18:Destroy()
end)

local Frame3 = Instance.new("Frame")

Frame3.Name = "Sidebar"
Frame3.Size = UDim2.new(0, 185, 1, -48)
Frame3.Position = UDim2.new(0, 0, 0, 48)
Frame3.BackgroundColor3 = t2.value15.Sidebar
Frame3.BorderSizePixel = 0
Frame3.Parent = t2.value19
t1.value2 = Instance.new("Frame")
t1.value2.Size = UDim2.new(0, 1, 1, 0)
t1.value2.Position = UDim2.new(1, -1, 0, 0)
t1.value2.BackgroundColor3 = t2.value15.Border
t1.value2.BorderSizePixel = 0
t1.value2.Parent = Frame3
t2.value24 = Instance.new("ScrollingFrame")
t2.value24.Size = UDim2.new(1, 0, 1, -40)
t2.value24.BackgroundTransparency = 1
t2.value24.BorderSizePixel = 0
t2.value24.ScrollBarThickness = 2
t2.value24.CanvasSize = UDim2.new(0, 0, 0, 0)
t2.value24.AutomaticCanvasSize = Enum.AutomaticSize.Y
t2.value24.Parent = Frame3

local UIListLayout = Instance.new("UIListLayout")

UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.Parent = t2.value24

local UIPadding = Instance.new("UIPadding")

UIPadding.PaddingTop = UDim.new(0, 8)
UIPadding.PaddingLeft = UDim.new(0, 12)
UIPadding.PaddingRight = UDim.new(0, 12)
UIPadding.Parent = t2.value24

local Frame4 = Instance.new("Frame")
local UDim2_ = UDim2

t1.value3 = Frame4

local uDim2 = UDim2_.new(1, 0, 0, 40)

t1.value3.Size = uDim2
t1.value3.Position = UDim2.new(0, 0, 1, -40)
t1.value3.BackgroundTransparency = 1
t1.value3.Parent = Frame3

local TextLabel2 = Instance.new("TextLabel")

TextLabel2.Size = UDim2.new(1, -20, 1, 0)
TextLabel2.Position = UDim2.new(0, 14, 0, 0)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Font = t2.value15.FontRegular
TextLabel2.Text = "🌐 ZA HUB | Kukirin v1.0"
TextLabel2.TextColor3 = t2.value15.TextDim
TextLabel2.TextSize = 11
TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
TextLabel2.Parent = t1.value3
t2.value25 = Instance.new("Frame")
t2.value25.Name = "ContentContainer"
t2.value25.Size = UDim2.new(1, -185, 1, -48)
t2.value25.Position = UDim2.new(0, 185, 0, 48)
t2.value25.BackgroundTransparency = 1
t2.value25.Parent = t2.value19
t2.value26 = {}
t2.value27 = {}
t2.value28 = nil

local function createScrollingFrame(p6, p7, p8)
	local TextButton2 = Instance.new("TextButton")

	TextButton2.Name = "Tab_" .. p6
	TextButton2.Size = UDim2.new(1, 0, 0, 38)
	TextButton2.BackgroundTransparency = 1
	TextButton2.LayoutOrder = p8
	TextButton2.Text = ""
	TextButton2.AutoButtonColor = false
	TextButton2.Parent = t2.value24

	local UICorner2 = Instance.new("UICorner")

	UICorner2.CornerRadius = UDim.new(0, 8)
	UICorner2.Parent = TextButton2

	local Frame5 = Instance.new("Frame")

	Frame5.Size = UDim2.new(0, 3, 0.6, 0)
	Frame5.Position = UDim2.new(0, 0, 0.2, 0)
	Frame5.BackgroundColor3 = t2.value15.Accent
	Frame5.BorderSizePixel = 0
	Frame5.Visible = false
	Frame5.Parent = TextButton2

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Size = UDim2.new(0, 24, 1, 0)
	TextLabel3.Position = UDim2.new(0, 10, 0, 0)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Text = p7
	TextLabel3.TextSize = 16
	TextLabel3.Parent = TextButton2

	local TextLabel4 = Instance.new("TextLabel")

	TextLabel4.Size = UDim2.new(1, -40, 1, 0)
	TextLabel4.Position = UDim2.new(0, 38, 0, 0)
	TextLabel4.BackgroundTransparency = 1
	TextLabel4.Font = t2.value15.FontMedium
	TextLabel4.Text = p6
	TextLabel4.TextColor3 = t2.value15.TextMuted
	TextLabel4.TextSize = 13.5
	TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel4.Parent = TextButton2

	local ScrollingFrame = Instance.new("ScrollingFrame")

	ScrollingFrame.Name = "Page_" .. p6
	ScrollingFrame.Size = UDim2.new(1, 0, 1, 0)
	ScrollingFrame.BackgroundTransparency = 1
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.ScrollBarThickness = 3
	ScrollingFrame.ScrollBarImageColor3 = t2.value15.Border
	ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	ScrollingFrame.Visible = false
	ScrollingFrame.Parent = t2.value25

	local UIPadding2 = Instance.new("UIPadding")

	UIPadding2.PaddingTop = UDim.new(0, 16)
	UIPadding2.PaddingBottom = UDim.new(0, 24)
	UIPadding2.PaddingLeft = UDim.new(0, 20)
	UIPadding2.PaddingRight = UDim.new(0, 20)
	UIPadding2.Parent = ScrollingFrame

	local UIListLayout2 = Instance.new("UIListLayout")

	UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout2.Padding = UDim.new(0, 8)
	UIListLayout2.Parent = ScrollingFrame
	t2.value26[p6] = {
		Button = TextButton2,
		ActiveBar = Frame5,
		Icon = TextLabel3,
		Label = TextLabel4
	}
	t2.value27[p6] = ScrollingFrame
	TextButton2.MouseButton1Click:Connect(function()
		for k, v in pairs(t2.value26) do
			if k == p6 then
				local Button = v.Button
				local t8 = {
					BackgroundTransparency = 0,
					BackgroundColor3 = t2.value15.AccentMuted
				}

				t2.value1:Create(Button, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t8):Play()

				local Label = v.Label
				local t9 = {
					TextColor3 = t2.value15.Text
				}

				t2.value1:Create(Label, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t9):Play()
				v.ActiveBar.Visible = true
				t2.value27[k].Visible = true
			else
				local Button = v.Button

				t2.value1:Create(Button, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
					BackgroundTransparency = 1
				}):Play()

				local Label = v.Label
				local t10 = {
					TextColor3 = t2.value15.TextMuted
				}

				t2.value1:Create(Label, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t10):Play()
				v.ActiveBar.Visible = false
				t2.value27[k].Visible = false
			end
		end

		t2.value28 = p6
	end)

	return ScrollingFrame
end
local function createFrame(p9, p10, p11)
	local Frame5 = Instance.new("Frame")

	Frame5.Size = UDim2.new(1, 0, 0, 48)
	Frame5.BackgroundTransparency = 1
	Frame5.Parent = p9

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Size = UDim2.new(1, 0, 0, 22)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Font = t2.value15.FontBold
	TextLabel3.Text = p10
	TextLabel3.TextColor3 = t2.value15.Text
	TextLabel3.TextSize = 16
	TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel3.Parent = Frame5

	local TextLabel4 = Instance.new("TextLabel")

	TextLabel4.Size = UDim2.new(1, 0, 0, 18)
	TextLabel4.Position = UDim2.new(0, 0, 0, 22)
	TextLabel4.BackgroundTransparency = 1
	TextLabel4.Font = t2.value15.FontRegular
	TextLabel4.Text = p11 or ""
	TextLabel4.TextColor3 = t2.value15.TextDim
	TextLabel4.TextSize = 12
	TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel4.Parent = Frame5

	return Frame5
end
local function v73(p12, p13, p14, p15, p16)
	local Frame5 = Instance.new("Frame")

	Frame5.Size = UDim2.new(1, 0, 0, 52)
	Frame5.BackgroundColor3 = t2.value15.CardBg
	Frame5.BorderSizePixel = 0
	Frame5.Parent = p12

	local UICorner2 = Instance.new("UICorner")

	UICorner2.CornerRadius = UDim.new(0, 8)
	UICorner2.Parent = Frame5

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Thickness = 1
	UIStroke.Color = t2.value15.Border
	UIStroke.Parent = Frame5

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Size = UDim2.new(0, 32, 1, 0)
	TextLabel3.Position = UDim2.new(0, 12, 0, 0)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Text = p14 or "⚡"
	TextLabel3.TextSize = 18
	TextLabel3.Parent = Frame5

	local TextLabel4 = Instance.new("TextLabel")

	TextLabel4.Size = UDim2.new(1, -120, 1, 0)
	TextLabel4.Position = UDim2.new(0, 48, 0, 0)
	TextLabel4.BackgroundTransparency = 1
	TextLabel4.Font = t2.value15.FontMedium
	TextLabel4.Text = p13
	TextLabel4.TextColor3 = t2.value15.Text
	TextLabel4.TextSize = 13
	TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel4.Parent = Frame5

	local TextButton2 = Instance.new("TextButton")

	TextButton2.Size = UDim2.new(0, 44, 0, 24)
	TextButton2.Position = UDim2.new(1, -56, 0.5, -12)
	TextButton2.BackgroundColor3 = p15 and t2.value15.ToggleActive or t2.value15.ToggleInactive
	TextButton2.Text = ""
	TextButton2.AutoButtonColor = false
	TextButton2.Parent = Frame5

	local UICorner3 = Instance.new("UICorner")

	UICorner3.CornerRadius = UDim.new(1, 0)
	UICorner3.Parent = TextButton2

	local Frame6 = Instance.new("Frame")

	Frame6.Size = UDim2.new(0, 18, 0, 18)

	local uDim22

	if p15 then
		uDim22 = UDim2.new(1, -21, 0.5, -9)
	else
		uDim22 = p15
	end

	Frame6.Position = uDim22 or UDim2.new(0, 3, 0.5, -9)
	Frame6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame6.BorderSizePixel = 0
	Frame6.Parent = TextButton2

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(1, 0)
	UICorner4.Parent = Frame6

	local u84 = p15 or false

	local function v85(p17)
		u84 = p17

		local v86 = v10
		local v87 = TextButton2
		local ToggleActive = u84

		if ToggleActive then
			ToggleActive = t2.value15.ToggleActive
		end

		v86(v87, 0.2, {
			BackgroundColor3 = ToggleActive or t2.value15.ToggleInactive
		})

		local v89 = v10
		local n1 = 0.2
		local v91 = Frame6
		local uDim23 = u84

		if uDim23 then
			uDim23 = UDim2.new(1, -21, 0.5, -9)
		end

		v89(v91, n1, {
			Position = uDim23 or UDim2.new(0, 3, 0.5, -9)
		})

		if not p16 then
			return
		end

		task.spawn(p16, u84)
	end

	TextButton2.MouseButton1Click:Connect(function()
		v85(not u84)
	end)

	return Frame5, v85
end
local function createFrame2(p18, p19, p20, p21, p22, p23, p24)
	local Frame5 = Instance.new("Frame")

	Frame5.Size = UDim2.new(1, 0, 0, 68)
	Frame5.BackgroundColor3 = t2.value15.CardBg
	Frame5.BorderSizePixel = 0
	Frame5.Parent = p18

	local UICorner2 = Instance.new("UICorner")

	UICorner2.CornerRadius = UDim.new(0, 8)
	UICorner2.Parent = Frame5

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Thickness = 1
	UIStroke.Color = t2.value15.Border
	UIStroke.Parent = Frame5

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Size = UDim2.new(1, -80, 0, 28)
	TextLabel3.Position = UDim2.new(0, 14, 0, 6)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Font = t2.value15.FontMedium
	TextLabel3.Text = p19
	TextLabel3.TextColor3 = t2.value15.Text
	TextLabel3.TextSize = 13
	TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel3.Parent = Frame5

	local TextLabel4 = Instance.new("TextLabel")

	TextLabel4.Size = UDim2.new(0, 60, 0, 28)
	TextLabel4.Position = UDim2.new(1, -74, 0, 6)
	TextLabel4.BackgroundTransparency = 1
	TextLabel4.Font = t2.value15.FontBold
	TextLabel4.Text = tostring(p22) .. (p23 or "")
	TextLabel4.TextColor3 = t2.value15.Accent
	TextLabel4.TextSize = 13
	TextLabel4.TextXAlignment = Enum.TextXAlignment.Right
	TextLabel4.Parent = Frame5

	local TextButton2 = Instance.new("TextButton")

	TextButton2.Size = UDim2.new(1, -28, 0, 6)
	TextButton2.Position = UDim2.new(0, 14, 0, 44)
	TextButton2.BackgroundColor3 = t2.value15.ToggleInactive
	TextButton2.Text = ""
	TextButton2.AutoButtonColor = false
	TextButton2.Parent = Frame5

	local UICorner3 = Instance.new("UICorner")

	UICorner3.CornerRadius = UDim.new(1, 0)
	UICorner3.Parent = TextButton2

	local Frame6 = Instance.new("Frame")
	local v102 = (p22 - p20) / (p21 - p20)
	local v103 = math.clamp(v102, 0, 1)

	Frame6.Size = UDim2.new(v103, 0, 1, 0)
	Frame6.BackgroundColor3 = t2.value15.Accent
	Frame6.BorderSizePixel = 0
	Frame6.Parent = TextButton2

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(1, 0)
	UICorner4.Parent = Frame6

	local u105 = false

	local function v106(p25)
		local X = TextButton2.AbsolutePosition.X
		local X2 = TextButton2.AbsoluteSize.X
		local v109 = (p25.Position.X - X) / X2
		local v110 = math.clamp(v109, 0, 1)
		local v111 = p20 + (p21 - p20) * v110
		local v112 = math.floor(v111)

		Frame6.Size = UDim2.new(v110, 0, 1, 0)
		TextLabel4.Text = tostring(v112) .. (p23 or "")

		if not p24 then
			return
		end

		task.spawn(p24, v112)
	end

	TextButton2.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u105 = true
		v106(input)
	end)
	t2.value2.InputEnded:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u105 = false
	end)
	t2.value2.InputChanged:Connect(function(input)
		local v113 = u105

		if v113 then
			v113 = input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch
		end

		if not v113 then
			return
		end

		v106(input)
	end)

	return Frame5
end
local function createFrame3(p26, p27, p28, p29, p30)
	local Frame5 = Instance.new("Frame")

	Frame5.Size = UDim2.new(1, 0, 0, 52)
	Frame5.BackgroundColor3 = t2.value15.CardBg
	Frame5.BorderSizePixel = 0
	Frame5.Parent = p26

	local UICorner2 = Instance.new("UICorner")

	UICorner2.CornerRadius = UDim.new(0, 8)
	UICorner2.Parent = Frame5

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Thickness = 1
	UIStroke.Color = t2.value15.Border
	UIStroke.Parent = Frame5

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Size = UDim2.new(0, 32, 1, 0)
	TextLabel3.Position = UDim2.new(0, 12, 0, 0)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Text = p28 or "🚀"
	TextLabel3.TextSize = 18
	TextLabel3.Parent = Frame5

	local TextLabel4 = Instance.new("TextLabel")

	TextLabel4.Size = UDim2.new(1, -150, 1, 0)
	TextLabel4.Position = UDim2.new(0, 48, 0, 0)
	TextLabel4.BackgroundTransparency = 1
	TextLabel4.Font = t2.value15.FontMedium
	TextLabel4.Text = p27
	TextLabel4.TextColor3 = t2.value15.Text
	TextLabel4.TextSize = 13
	TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel4.Parent = Frame5

	local TextButton2 = Instance.new("TextButton")

	TextButton2.Size = UDim2.new(0, 86, 0, 30)
	TextButton2.Position = UDim2.new(1, -98, 0.5, -15)
	TextButton2.BackgroundColor3 = t2.value15.Accent
	TextButton2.Font = t2.value15.FontBold
	TextButton2.Text = p29 or "Execute"
	TextButton2.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextButton2.TextSize = 12
	TextButton2.Parent = Frame5

	local UICorner3 = Instance.new("UICorner")

	UICorner3.CornerRadius = UDim.new(0, 6)
	UICorner3.Parent = TextButton2
	TextButton2.MouseButton1Click:Connect(function()
		local v122 = TextButton2
		local t11 = {
			BackgroundColor3 = t2.value15.AccentGlow
		}

		t2.value1:Create(v122, TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t11):Play()
		task.wait(0.1)

		local v124 = TextButton2
		local t12 = {
			BackgroundColor3 = t2.value15.Accent
		}

		t2.value1:Create(v124, TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t12):Play()

		if not p30 then
			return
		end

		task.spawn(p30)
	end)

	return Frame5
end
local function v126()
	local Character = t2.value11.Character
	local Humanoid, SeatPart

	if Character then
		Humanoid = Character:FindFirstChild("Humanoid")

		if Humanoid then
		elseif Humanoid then
			SeatPart = Character.Humanoid.SeatPart

			if SeatPart:IsA("VehicleSeat") then
				return SeatPart, SeatPart.FindFirstAncestorOfClass(SeatPart, "Model")
			else
				return nil, nil
			end
		else
			return nil, nil
		end

		Humanoid = Character.Humanoid.SeatPart
	else
		Humanoid = Character
	end

	if Humanoid then
		SeatPart = Character.Humanoid.SeatPart

		if SeatPart:IsA("VehicleSeat") then
			return SeatPart, SeatPart.FindFirstAncestorOfClass(SeatPart, "Model")
		else
			return nil, nil
		end
	else
		return nil, nil
	end
end
local function v130()
	local ipairs_ = ipairs
	local workspace_ = workspace

	for _, descendant in ipairs_(workspace_.GetDescendants(workspace_)) do
		local v135 = descendant.Name:lower()
		local pos = v135:find("delivery") or (v135:find("courier") or (v135:find("pizza") or (v135:find("order") or v135:find("package"))))

		if pos then
			pos = descendant:IsA("BasePart")
		end

		if pos then
			return descendant.CFrame + Vector3.new(0, 3, 0)
		end

		if descendant:IsA("ProximityPrompt") then
			local v137 = (descendant.ActionText .. " " .. descendant.ObjectText):lower()

			if v137:find("delivery") or (v137:find("order") or (v137:find("package") or v137:find("pizza"))) then
				local Parent = descendant.Parent

				if Parent then
					Parent = descendant.Parent:IsA("BasePart")
				end

				if Parent then
					return descendant.Parent.CFrame + Vector3.new(0, 3, 0)
				end
			end
		end
	end

	return t2.value16.SpawnCFrame
end
local function v139()
	local Character = t2.value11.Character
	local HumanoidRootPart

	if Character then
		HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	else
		HumanoidRootPart = Character
	end

	if HumanoidRootPart then
		local HumanoidRootPart2 = Character.HumanoidRootPart
		local ipairs_ = ipairs
		local workspace_ = workspace
		local huge = math.huge
		local v146 = nil

		for _, descendant in ipairs_(workspace_.GetDescendants(workspace_)) do
			local v149 = descendant.Name:lower()
			local pos = v149.find(v149, "dropoff") or (v149:find("customer") or (v149:find("destination") or v149:find("deliverhere")))

			if pos then
				pos = descendant:IsA("BasePart")
			end

			if pos then
				local Magnitude = (descendant.Position - HumanoidRootPart2.Position).Magnitude

				if Magnitude < huge then
					v146 = descendant
					huge = Magnitude
				end
			end
		end

		return v146
	else
		return nil
	end
end

t1.value4 = createScrollingFrame("Scooter", "🛵", 1)
createFrame(t1.value4, "E-Scooter Performance & Stunts", "Fine-tune acceleration, top speed, and anti-crash safety.")
createFrame2(t1.value4, "Scooter Top Speed Multiplier", 1, 5, 1, "x", function(p31)
	t2.value16.ScooterSpeedMultiplier = p31
end)
v73(t1.value4, "Anti-Wipeout (Never Fall Off)", "🛡️", true, function(p32)
	t2.value16.AntiFallOff = p32

	local Character = t2.value11.Character
	local Humanoid

	if Character then
		Humanoid = Character:FindFirstChild("Humanoid")
	else
		Humanoid = Character
	end

	if not Humanoid then
		return
	end

	local Humanoid2 = Character.Humanoid
	local FallingDown = Enum.HumanoidStateType.FallingDown

	Humanoid2.SetStateEnabled(Humanoid2, FallingDown, not p32)
	Humanoid2:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, not p32)
end)
v73(t1.value4, "Auto-Wheelie Stunt Spammer", "🤸", false, function(p33)
	t2.value16.AutoWheelie = p33
end)
createFrame3(t1.value4, "Auto-Flip Scooter (Upright)", "🔄", "Flip", function()
	local v156, v157 = v126()
	local PrimaryPart

	if v157 then
		PrimaryPart = v157.PrimaryPart
	else
		PrimaryPart = v157
	end

	if PrimaryPart then
		v157:SetPrimaryPartCFrame(CFrame.new(v157.PrimaryPart.Position + Vector3.new(0, 3, 0)) * CFrame.Angles(0, 0, 0))

		return
	end

	if not v156 then
		return
	end

	v156.CFrame = CFrame.new(v156.Position + Vector3.new(0, 3, 0)) * CFrame.Angles(0, 0, 0)
end)
createFrame3(t1.value4, "Instant Boost / Launch", "⚡", "Boost", function()
	local v159 = v126()

	if v159 then
		v159.AssemblyLinearVelocity = v159.CFrame.LookVector * 180

		return
	end

	local Character = t2.value11.Character

	if Character then
		Character = t2.value11.Character:FindFirstChild("HumanoidRootPart")
	end

	if not Character then
		return
	end

	t2.value11.Character.HumanoidRootPart.AssemblyLinearVelocity = t2.value12.CFrame.LookVector * 120
end)
t1.value6 = createScrollingFrame("Jobs", "📦", 2)
createFrame(t1.value6, "Courier & Delivery Automations", "Maximize Cash/XP from delivery runs with instant interactions.")
v73(t1.value6, "0s Instant Proximity Prompts", "⚡", true, function(p34)
	t2.value16.InstantPrompts = p34
end)
createFrame3(t1.value6, "Teleport to Delivery Order Hub", "🏢", "Hub", function()
	local v161 = v130()
	local Character = t2.value11.Character
	local HumanoidRootPart

	if v161 then
		if Character then
			HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		else
			HumanoidRootPart = Character
		end
	else
		HumanoidRootPart = v161
	end

	if not HumanoidRootPart then
		return
	end

	Character.HumanoidRootPart.CFrame = v161
end)
createFrame3(t1.value6, "Teleport to Active Dropoff", "📍", "Dropoff", function()
	local v164 = v139()
	local Character = t2.value11.Character
	local HumanoidRootPart

	if v164 then
		if Character then
			HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
		else
			HumanoidRootPart = Character
		end
	else
		HumanoidRootPart = v164
	end

	if not HumanoidRootPart then
		return
	end

	Character.HumanoidRootPart.CFrame = v164.CFrame + Vector3.new(0, 3, 0)
end)
createFrame3(t1.value6, "Teleport to Spawn / Garage", "🏠", "Spawn", function()
	local Character = t2.value11.Character
	local SpawnCFrame = t2.value16.SpawnCFrame

	if SpawnCFrame then
		if Character then
			SpawnCFrame = Character:FindFirstChild("HumanoidRootPart")
		else
			SpawnCFrame = Character
		end
	end

	if not SpawnCFrame then
		return
	end

	Character.HumanoidRootPart.CFrame = t2.value16.SpawnCFrame
end)
t1.value7 = createScrollingFrame("Radar", "👁️", 3)
createFrame(t1.value7, "Police Radar & World ESP", "Track police cruisers, delivery targets, and other riders.")
v73(t1.value7, "Police Cruiser Radar (Red Chams)", "🚓", false, function(p35)
	t2.value16.PoliceESP = p35

	if p35 then
		local ipairs_ = ipairs
		local workspace_ = workspace

		for _, descendant in ipairs_(workspace_.GetDescendants(workspace_)) do
			local v173 = descendant.Name:lower()
			local pos = v173:find("police") or (v173:find("cop") or (v173.find(v173, "patrol") or v173:find("officer")))

			if pos then
				pos = descendant:IsA("Model")
			end

			if pos and not descendant:FindFirstChild("ZA_PoliceHL") then
				local Highlight = Instance.new("Highlight")

				Highlight.Name = "ZA_PoliceHL"
				Highlight.FillColor = Color3.fromRGB(239, 68, 68)
				Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
				Highlight.FillTransparency = 0.4
				Highlight.Parent = descendant
			end
		end
	else
		for _, descendant in ipairs(workspace:GetDescendants()) do
			if descendant.Name == "ZA_PoliceHL" then
				descendant:Destroy()
			end
		end
	end
end)
v73(t1.value7, "Delivery Customer ESP (Green Chams)", "🟢", false, function(p36)
	t2.value16.DeliveryESP = p36

	if p36 then
		local ipairs_ = ipairs
		local workspace_ = workspace

		for _, descendant in ipairs_(workspace_.GetDescendants(workspace_)) do
			local v182 = descendant.Name:lower()
			local pos = v182.find(v182, "dropoff") or (v182:find("customer") or (v182:find("order") or v182:find("destination")))

			if pos then
				pos = descendant:IsA("BasePart")
			end

			if pos and not descendant:FindFirstChild("ZA_DeliveryHL") then
				local Highlight = Instance.new("Highlight")

				Highlight.Name = "ZA_DeliveryHL"
				Highlight.FillColor = Color3.fromRGB(16, 185, 129)
				Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
				Highlight.FillTransparency = 0.4
				Highlight.Parent = descendant
			end
		end
	else
		for _, descendant in ipairs(workspace:GetDescendants()) do
			if descendant.Name == "ZA_DeliveryHL" then
				descendant:Destroy()
			end
		end
	end
end)
v73(t1.value7, "Player Riders ESP (Blue Chams)", "🔵", false, function(p37)
	t2.value16.PlayerESP = p37

	if p37 then
		local ipairs_ = ipairs
		local value4 = t2.value4

		for _, player in ipairs_(value4.GetPlayers(value4)) do
			local v191 = player ~= t2.value11

			if v191 then
				v191 = player.Character

				if v191 then
					v191 = not player.Character:FindFirstChild("ZA_PlayerHL")
				end
			end

			if v191 then
				local Highlight = Instance.new("Highlight")

				Highlight.Name = "ZA_PlayerHL"
				Highlight.FillColor = Color3.fromRGB(14, 115, 245)
				Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
				Highlight.FillTransparency = 0.5
				Highlight.Parent = player.Character
			end
		end
	else
		for _, descendant in ipairs(workspace:GetDescendants()) do
			if descendant.Name == "ZA_PlayerHL" then
				descendant:Destroy()
			end
		end
	end
end)
v73(t1.value7, "Fullbright Mode (Clear Night Vision)", "☀️", false, function(p38)
	t2.value16.Fullbright = p38

	if p38 then
		t2.value5.Brightness = 2
		t2.value5.ClockTime = 14
		t2.value5.FogEnd = 100000
		t2.value5.GlobalShadows = false
		t2.value5.Ambient = Color3.fromRGB(255, 255, 255)
	else
		local Brightness = t2.value17.Brightness

		t2.value5.Brightness = Brightness

		local ClockTime = t2.value17.ClockTime

		t2.value5.ClockTime = ClockTime

		local FogEnd = t2.value17.FogEnd

		t2.value5.FogEnd = FogEnd

		local GlobalShadows = t2.value17.GlobalShadows

		t2.value5.GlobalShadows = GlobalShadows
		t2.value5.Ambient = t2.value17.Ambient
	end
end)
t1.value5 = createScrollingFrame("Mobility", "👤", 4)
createFrame(t1.value5, "Rider Physics & Mobility", "Movement enhancers to scale rooftops, escape police, and bypass walls.")
createFrame2(t1.value5, "WalkSpeed Multiplier", 16, 150, 16, " spd", function(p39)
	t2.value16.WalkSpeed = p39

	local Character = t2.value11.Character

	if Character then
		Character = t2.value11.Character:FindFirstChild("Humanoid")
	end

	if not Character then
		return
	end

	t2.value11.Character.Humanoid.WalkSpeed = p39
end)
createFrame2(t1.value5, "JumpPower Multiplier", 50, 250, 50, " pwr", function(p40)
	t2.value16.JumpPower = p40

	local Character = t2.value11.Character

	if Character then
		Character = t2.value11.Character:FindFirstChild("Humanoid")
	end

	if not Character then
		return
	end

	t2.value11.Character.Humanoid.JumpPower = p40
end)
v73(t1.value5, "Noclip (Walk Through Fences & Gates)", "🧱", false, function(p41)
	t2.value16.Noclip = p41
end)
v73(t1.value5, "Fly Mode (Keybind: E)", "🕊️", false, function(p42)
	t2.value16.FlyEnabled = p42
end)
createFrame2(t1.value5, "Flight Speed", 20, 150, 50, " spd", function(p43)
	t2.value16.FlySpeed = p43
end)
v73(t1.value5, "Infinite Jump (Spacebar Air Jump)", "🦘", false, function(p44)
	t2.value16.InfiniteJump = p44
end)

local Settings = createScrollingFrame("Settings", "⚙️", 5)

createFrame(Settings, "Hub Configuration", "System hotkeys, persistent cursor unlock, and unloading.")
v73(Settings, "Auto-Unlock Cursor When Hub Open", "🖱️", true, function(p45)
	t2.value16.UnlockCursor = p45
end)
v73(Settings, "Force Cursor Visible Always (Key: LeftAlt)", "🔓", false, function(p46)
	t2.value16.ForceCursorAlways = p46
end)
v73(Settings, "Anti-AFK Protection (No 20m Kick)", "🛡️", true, function(p47)
	t2.value16.AntiAFK = p47
end)
createFrame3(Settings, "Rejoin Current Server", "🔄", "Rejoin", function()
	t2.value9:TeleportToPlaceInstance(game.PlaceId, game.JobId, t2.value11)
end)
createFrame3(Settings, "Server Hop (Low Ping)", "🔀", "Hop", function()
	pcall(function()
		local v202 = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"
		local value10 = t2.value10
		local game_ = game
		local data = value10:JSONDecode(unpack_({ game_.HttpGet(game_, v202) }))

		for _, v in ipairs(data.data) do
			local v208

			if v.playing < v.maxPlayers then
				v208 = v.id ~= game.JobId
			else
				v208 = false
			end

			if v208 then
				t2.value9:TeleportToPlaceInstance(game.PlaceId, v.id, t2.value11)

				return
			end
		end
	end)
end)
createFrame3(Settings, "Unload Kukirin Life Hub", "🗑️", "Unload", function()
	local function v209()
		t2.value3:UnbindFromRenderStep("ZA_CursorUnlocker")
	end

	pcall(v209)

	for _, connection in pairs(t2.value16.Connections) do
		pcall(function()
			connection:Disconnect()
		end)
	end

	t2.value18:Destroy()
end)
pcall(function()
	t2.value3:UnbindFromRenderStep("ZA_CursorUnlocker")
end)

local Value = Enum.RenderPriority.Last.Value

t2.value3:BindToRenderStep("ZA_CursorUnlocker", Value, function()
	local UnlockCursor = t2.value16.UnlockCursor

	if UnlockCursor then
		UnlockCursor = t2.value19.Visible or t2.value16.ForceCursorAlways
	end

	if not UnlockCursor then
		return
	end

	local Default = Enum.MouseBehavior.Default

	t2.value2.MouseBehavior = Default
	t2.value2.MouseIconEnabled = true
end)
t2.value11.Idled:Connect(function()
	if not t2.value16.AntiAFK then
		return
	end

	t2.value7:CaptureController()
	t2.value7:ClickButton2(unpack_({ Vector2.new(0, 0) }))
end)
t2.value3.Stepped:Connect(function()
	local Character = t2.value11.Character

	if not Character then
		return
	end

	local Humanoid = Character:FindFirstChild("Humanoid")

	if Humanoid then
		local v217

		if t2.value16.WalkSpeed == 16 then
			v217 = false
		else
			v217 = Humanoid.WalkSpeed ~= t2.value16.WalkSpeed
		end

		if v217 then
			Humanoid.WalkSpeed = t2.value16.WalkSpeed
		end

		local v218

		if t2.value16.JumpPower == 50 then
			v218 = false
		else
			v218 = Humanoid.JumpPower ~= t2.value16.JumpPower
		end

		if v218 then
			Humanoid.JumpPower = t2.value16.JumpPower
		end

		if t2.value16.AntiFallOff then
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			Humanoid:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
		end
	end

	if not t2.value16.Noclip then
		return
	end

	local GetDescendants = Character.GetDescendants

	for _, v in ipairs(GetDescendants(Character)) do
		local isBasePart = v:IsA("BasePart")

		if isBasePart then
			isBasePart = v.CanCollide
		end

		if isBasePart then
			v.CanCollide = false
		end
	end
end)
t2.value3.RenderStepped:Connect(function()
	if not t2.value16.InstantPrompts then
		return
	end

	local ipairs_ = ipairs
	local workspace_ = workspace

	for _, descendant in ipairs_(workspace_.GetDescendants(workspace_)) do
		local isProximityPrompt = descendant:IsA("ProximityPrompt")

		if isProximityPrompt then
			isProximityPrompt = descendant.HoldDuration > 0
		end

		if isProximityPrompt then
			descendant.HoldDuration = 0
		end
	end
end)
t2.value2.JumpRequest:Connect(function()
	local InfiniteJump = t2.value16.InfiniteJump

	if InfiniteJump then
		InfiniteJump = t2.value11.Character

		if InfiniteJump then
			InfiniteJump = t2.value11.Character:FindFirstChild("Humanoid")
		end
	end

	if not InfiniteJump then
		return
	end

	t2.value11.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
end)
task.spawn(function()
	while true do
		local parent2 = t2.value16.ScooterSpeedMultiplier > 1 and v126()

		if parent2 then
			if not parent2:FindFirstChild("ZA_OrigMaxSpeed") then
				local NumberValue = Instance.new("NumberValue")

				NumberValue.Name = "ZA_OrigMaxSpeed"
				NumberValue.Value = parent2.MaxSpeed
				NumberValue.Parent = parent2
			end

			parent2.MaxSpeed = parent2:FindFirstChild("ZA_OrigMaxSpeed").Value * t2.value16.ScooterSpeedMultiplier
		end

		task.wait(1)
	end
end)
task.spawn(function()
	while true do
		while t2.value16.AutoWheelie do
			local v231 = v126()

			if v231 then
				v231 = t2.value2:IsKeyDown(Enum.KeyCode.W)
			end

			if v231 then
				local function v232()
					local Up = Enum.KeyCode.Up

					t2.value8:SendKeyEvent(true, Up, false, game)
					task.wait(0.1)
					t2.value8:SendKeyEvent(false, Enum.KeyCode.Up, false, game)
				end

				pcall(v232)
			end

			task.wait(0.15)
		end

		task.wait(0.8)
	end
end)
t2.value29 = nil
t2.value30 = nil
t2.value29 = nil

function t2.value31(p48)
	local Character = t2.value11.Character
	local HumanoidRootPart

	if Character then
		HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	else
		HumanoidRootPart = Character
	end

	if not HumanoidRootPart then
		return
	end

	local HumanoidRootPart2 = Character.HumanoidRootPart

	if p48 then
		t2.value30 = Instance.new("BodyVelocity")
		t2.value30.Name = "ZA_FlyVel"
		t2.value30.MaxForce = Vector3.new(9000000000, 9000000000, 9000000000)

		local vector3 = Vector3.zero

		t2.value30.Velocity = vector3
		t2.value30.Parent = HumanoidRootPart2
		t2.value29 = Instance.new("BodyGyro")
		t2.value29.Name = "ZA_FlyGyro"
		t2.value29.MaxTorque = Vector3.new(9000000000, 9000000000, 9000000000)

		local CFrame_ = HumanoidRootPart2.CFrame

		t2.value29.CFrame = CFrame_
		t2.value29.Parent = HumanoidRootPart2
		table.insert(t2.value16.Connections, t2.value3.RenderStepped:Connect(function()
			if not (t2.value16.FlyEnabled and t2.value30) then
				return
			end

			local vector32 = Vector3.zero

			if t2.value2:IsKeyDown(Enum.KeyCode.W) then
				vector32 = vector32 + t2.value12.CFrame.LookVector
			end

			if t2.value2:IsKeyDown(Enum.KeyCode.S) then
				vector32 = vector32 - t2.value12.CFrame.LookVector
			end

			if t2.value2:IsKeyDown(Enum.KeyCode.A) then
				vector32 = vector32 - t2.value12.CFrame.RightVector
			end

			if t2.value2:IsKeyDown(Enum.KeyCode.D) then
				vector32 = vector32 + t2.value12.CFrame.RightVector
			end

			if t2.value2:IsKeyDown(Enum.KeyCode.Space) then
				vector32 = vector32 + Vector3.new(0, 1, 0)
			end

			if not t2.value2:IsKeyDown(Enum.KeyCode.LeftShift) then
				v282 = t2.value16.FlySpeed
				t2.value30.Velocity = vector32 * v282
				t2.value29.CFrame = t2.value12.CFrame

				return
			end

			vector32 = vector32 - Vector3.new(0, 1, 0)

			local FlySpeed = t2.value16.FlySpeed

			t2.value30.Velocity = vector32 * FlySpeed
			t2.value29.CFrame = t2.value12.CFrame
		end))

		return
	end

	if t2.value30 then
		t2.value30:Destroy()
		t2.value30 = nil
	end

	if not t2.value29 then
		return
	end

	t2.value29:Destroy()
	t2.value29 = nil
end

t2.value2.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	local FlyEnabled

	if input.KeyCode == Enum.KeyCode.E then
		FlyEnabled = t2.value16.FlyEnabled
	else
		FlyEnabled = false
	end

	if FlyEnabled then
		t2.value31(not t2.value30)

		return
	end

	if input.KeyCode == Enum.KeyCode.RightShift then
		t2.value19.Visible = not t2.value19.Visible

		return
	end

	if input.KeyCode ~= Enum.KeyCode.LeftAlt then
		return
	end

	t2.value16.ForceCursorAlways = not t2.value16.ForceCursorAlways
end)
t2.value26.Scooter.Button.BackgroundColor3 = t2.value15.AccentMuted
t2.value26.Scooter.Button.BackgroundTransparency = 0
t2.value26.Scooter.ActiveBar.Visible = true
t2.value27.Scooter.Visible = true
t2.value28 = "Scooter"
print("🛴 [ZA HUB] Kukirin Life Edition successfully loaded! Press RightShift to toggle.")
