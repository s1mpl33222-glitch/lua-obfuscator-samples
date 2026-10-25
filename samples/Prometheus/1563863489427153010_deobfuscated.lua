-- This file was generated at discord.gg/syncrypt

local game_ = game
local t1 = {
	value1 = "GetService",
	value2 = 0.5
}

t1.value1 = game_:GetService("Players")

local t2 = {
	value1 = t1.value1
}

t2.value2 = t2.value1.LocalPlayer

local PlayerGui = t2.value2:WaitForChild("PlayerGui")
local game_2 = game

t1.value1 = game_2.GetService
t1.value1 = t1.value1(game_2, "UserInputService")
t2.value3 = t1.value1

local game_3 = game

t1.value1 = game_3.GetService
t1.value3 = 14
t1.value1 = t1.value1(game_3, "TweenService")
t2.value4 = t1.value1

local game_4 = game

t2.value5 = nil
game_4:GetService("VirtualInputManager")
t1.value1 = game:GetService("VirtualUser")
t2.value6 = t1.value1

local game_5 = game

t1.value1 = "GetService"
t1.value6 = 24
t1.value1 = game_5:GetService("RunService")
t2.value7 = t1.value1
t1.value1 = game:GetService("Lighting")
t2.value8 = t1.value1
t2.value9 = workspace.CurrentCamera
game:GetService("ReplicatedStorage")

local n1 = 140
local n2 = 45

t1.value10 = Instance.new("ScreenGui")
t1.value10.ResetOnSpawn = false
t1.value10.DisplayOrder = 999999
t1.value10.Parent = PlayerGui

local function v11(p1, p2)
	local u12 = false
	local Position = nil
	local Position2 = nil

	p1.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u12 = true
		Position = input.Position
		Position2 = p2.Position
	end)
	t2.value3.InputChanged:Connect(function(input)
		local v15 = u12

		if v15 then
			v15 = input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch
		end

		if not v15 then
			return
		end

		local v16 = input.Position - Position

		p2.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v16.X, Position2.Y.Scale, Position2.Y.Offset + v16.Y)
	end)
	t2.value3.InputEnded:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u12 = false
	end)
end

t1.value1 = Instance.new("Frame")
t2.value10 = t1.value1
t2.value10.Size = UDim2.new(0, 480, 0, 320)
t2.value10.AnchorPoint = Vector2.new(0.5, 0.5)
t2.value10.Position = UDim2.new(0.5, 0, t1.value2, 0)
t2.value10.BackgroundColor3 = Color3.fromRGB(34, 36, 38)
t1.value2 = 1
t1.value1 = "BorderSizePixel"
t2.value10.BorderSizePixel = 0
t2.value10.BackgroundTransparency = 0
t2.value10.ClipsDescendants = true
t2.value10.Parent = t1.value10

local value10 = t2.value10
local UICorner = Instance.new("UICorner")

UICorner.CornerRadius = UDim.new(0, 10)
UICorner.Parent = value10
t1.value1 = Instance.new("Frame")

local UDim2_ = UDim2

t1.value1 = t1.value1

local uDim2 = UDim2_.new(0, 1, t1.value2, 0)

t1.value1.Size = uDim2
t1.value1.Position = UDim2.new(0, n1, 0, 0)

local Color3_ = Color3

t1.value2 = 45

local color3 = Color3_.fromRGB(45, 45, t1.value2)

t1.value1.BackgroundColor3 = color3
t1.value1.BorderSizePixel = 0
t1.value2 = 1
t1.value1.ZIndex = 15
t1.value1.Parent = t2.value10

local TextButton = Instance.new("TextButton")

TextButton.BackgroundTransparency = 1
t1.value1 = ""
TextButton.Text = ""
TextButton.Modal = true
TextButton.Size = UDim2.fromScale(1, t1.value2)
TextButton.ZIndex = 0
TextButton.Parent = t2.value10
t1.value1 = Instance.new("Frame")

local UDim2_2 = UDim2
local value1 = t1.value1

t1.value2 = "new"
t1.value11 = value1

local uDim22 = UDim2_2.new(1, -(n1 - t1.value3), 0, n2)

t1.value11.Size = uDim22
t1.value2 = "UDim2"
t1.value3 = 0
t1.value11.Position = UDim2.new(0, n1 - 14, 0, t1.value3)

local Color3_2 = Color3

t1.value2 = "fromRGB"

local color32 = Color3_2.fromRGB(26, 26, 26)

t1.value11.BackgroundColor3 = color32
t1.value11.BorderSizePixel = 0
t1.value11.Parent = t2.value10
t1.value3 = 24
t1.value11.ZIndex = 10
t1.value1 = Instance.new("UIPadding")
t1.value2 = UDim

local value12 = t1.value1

t1.value2 = t1.value2.new(0, 15)
value12.PaddingLeft = t1.value2
value12.PaddingRight = UDim.new(0, 15)
value12.Parent = t1.value11

local value11 = t1.value11
local UICorner2 = Instance.new("UICorner")

UICorner2.CornerRadius = UDim.new(0, 10)
UICorner2.Parent = value11
t1.value2 = Instance.new("Frame")
t1.value1 = UDim2.new
t1.value2.Size = t1.value1(0, t1.value3, 0, t1.value6)
t1.value14 = nil
t1.value3 = -30
t1.value2.Position = UDim2.new(1, t1.value3, 0.5, -12)
t1.value2.BackgroundTransparency = 1
t1.value2.ZIndex = 11
t1.value2.Parent = t1.value11
t1.value1 = Instance
t1.value15 = 2
t1.value3 = "UDim2"
t1.value1 = t1.value1.new("Frame")

local UDim2_3 = UDim2
local value13 = t1.value1

t1.value3 = "new"
t1.value12 = value13

local uDim23 = UDim2_3.new(0, 18, 0, 2)

t1.value12.Size = uDim23
t1.value6 = 0.5
t1.value1 = UDim2.new
t1.value3 = 0.5

local v35 = t1.value1(t1.value3, -9, t1.value6, 0)

t1.value3 = "Color3"
t1.value12.Position = v35
t1.value1 = Color3.fromRGB
t1.value3 = 0
t1.value6 = 200
t1.value12.BackgroundColor3 = t1.value1(t1.value3, 255, t1.value6)
t1.value17 = nil
t1.value12.BorderSizePixel = 0
t1.value12.Rotation = 45
t1.value6 = 18
t1.value12.ZIndex = 12
t1.value12.Parent = t1.value2

local Frame = Instance.new("Frame")

Frame.Size = UDim2.new(0, t1.value6, 0, 2)
t1.value6 = -9
t1.value3 = UDim2
t1.value3 = t1.value3.new(0.5, t1.value6, 0.5, 0)
Frame.Position = t1.value3
t1.value6 = 255
t1.value1 = Color3.fromRGB
t1.value12 = 0.1
Frame.BackgroundColor3 = t1.value1(0, t1.value6, 200)
Frame.BorderSizePixel = 0
Frame.Rotation = -45
Frame.ZIndex = 12
t1.value3 = "Instance"
Frame.Parent = t1.value2
t1.value1 = Instance.new("TextLabel")
t2.value11 = t1.value1
t2.value11.Size = UDim2.new(0, 110, 0, 20)
t2.value11.Position = UDim2.new(1, -160, 0.5, -10)
t2.value11.BackgroundTransparency = 1
t1.value1 = "Text"
t2.value11.Text = "FPS: 0 | Ping: 0ms"
t2.value11.TextColor3 = Color3.fromRGB(0, 255, 200)
t2.value11.Font = Enum.Font.SourceSansSemibold
t1.value1 = "TextSize"
t2.value11.TextSize = 15
t2.value11.TextXAlignment = Enum.TextXAlignment.Right
t1.value1 = "ZIndex"
t2.value11.ZIndex = 11

local value112 = t1.value11

t1.value1 = "Parent"
t1.value6 = "frameCount"
t2.value11.Parent = value112
t1.value1 = "lastUpdate"
t1.value18 = "BannerNotificationStream"
t2.value12 = {
	lastUpdate = 0,
	frameCount = 0,
	updateInterval = 5
}

local Heartbeat = t2.value7.Heartbeat

function t1.value6(p3)
	local frameCount = t2.value12.frameCount

	t2.value12.frameCount = frameCount + 1
	t2.value12.lastUpdate = t2.value12.lastUpdate + p3

	if not (t2.value12.lastUpdate >= t2.value12.updateInterval) then
		return
	end

	local v40 = t2.value12.frameCount / t2.value12.lastUpdate
	local v41 = math.floor(v40)
	local v42 = t2.value2:GetNetworkPing() * 1000
	local v43 = math.floor(v42)

	t2.value11.Text = ("FPS: %d | Ping: %dms").format("FPS: %d | Ping: %dms", v41, v43)
	t2.value12.lastUpdate = 0
	t2.value12.frameCount = 0
end

Heartbeat:Connect(t1.value6)
v11(t1.value11, t2.value10)
t1.value1 = Instance.new("ScrollingFrame")
t2.value13 = t1.value1
t1.value1 = "Position"
t1.value11 = 0
t2.value13.Position = UDim2.new(0, 0, t1.value11, 0)

local value132 = t2.value13
local UDim2_4 = UDim2

t1.value1 = "Size"
t1.value11 = 0
value132.Size = UDim2_4.new(0, n1, 1, t1.value11)
t2.value13.BackgroundColor3 = Color3.fromRGB(26, 26, 26)
t2.value13.ScrollBarThickness = 0
t2.value13.BorderSizePixel = 0
t2.value13.AutomaticCanvasSize = Enum.AutomaticSize.Y
t2.value13.CanvasSize = UDim2.new(0, 0, 0, 0)
t2.value13.ScrollingDirection = Enum.ScrollingDirection.Y
t2.value13.Parent = t2.value10

local value133 = t2.value13
local UICorner3 = Instance.new("UICorner")

UICorner3.CornerRadius = UDim.new(0, 10)
UICorner3.Parent = value133
t1.value1 = Instance.new("Frame")

local UDim2_5 = UDim2
local value14 = t1.value1

t1.value21 = false
value14.Size = UDim2_5.new(1, 0, 0, 50)
value14.BackgroundTransparency = 1
value14.LayoutOrder = -1
t1.value11 = 0
value14.Parent = t2.value13
t1.value1 = Instance.new("TextLabel")

local UDim2_6 = UDim2
local value15 = t1.value1

value15.Size = UDim2_6.new(1, t1.value11, 0, 24)
t1.value11 = 255
value15.BackgroundTransparency = 1
t1.value1 = "Place name"
value15.Text = "Place name"
value15.TextColor3 = Color3.fromRGB(0, t1.value11, 200)
t1.value11 = "Enum"
value15.Font = Enum.Font.GothamBlack
t1.value11 = "Enum"
value15.TextSize = 14
t1.value22 = "NotificationBanner"
value15.TextXAlignment = Enum.TextXAlignment.Left
t1.value11 = "UDim2"
value15.Parent = value14
t1.value1 = Instance.new("TextLabel")

local UDim2_7 = UDim2
local value16 = t1.value1

t1.value11 = "new"

local uDim24 = UDim2_7.new(1, 0, 0, 15)

t1.value19 = 22
t1.value11 = "UDim2"
value16.Size = uDim24
t1.value1 = UDim2.new
t1.value23 = "WaitForChild"
t1.value11 = 0
value16.Position = t1.value1(t1.value11, 0, 0, t1.value19)
t1.value11 = "Color3"
value16.BackgroundTransparency = 1
t1.value1 = "by Sosiskomras"
value16.Text = "by Sosiskomras"

local Color3_3 = Color3

t1.value11 = "fromRGB"
value16.TextColor3 = Color3_3.fromRGB(200, 200, 200)
value16.Font = Enum.Font.SourceSans
value16.TextSize = 12
value16.TextXAlignment = Enum.TextXAlignment.Left
value16.Parent = value14
t1.value1 = Instance.new("Frame")
t1.value11 = UDim2

local value17 = t1.value1

t1.value11 = t1.value11.new(1, 20, 0, 1)
value17.Size = t1.value11
t1.value19 = 1
value17.Position = UDim2.new(0, -10, t1.value19, -5)
value17.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
value17.BorderSizePixel = 0
t2.value14 = nil
value17.Parent = value14
v11(t2.value13, t2.value10)
t1.value1 = Instance.new("ScrollingFrame")
t2.value15 = t1.value1
t1.value1 = "Size"
t1.value19 = "UDim2"
t2.value15.Size = UDim2.new(1, -n1, 1, -n2)

local WaitForChild = PlayerGui.WaitForChild

t1.value19 = "UDim2"
t1.value23 = WaitForChild
t1.value1 = "Position"
t2.value15.Position = UDim2.new(0, n1, 0, n2)
t2.value15.BackgroundTransparency = 1
t2.value15.ScrollBarThickness = 2
t2.value15.BorderSizePixel = 0
t2.value15.AutomaticCanvasSize = Enum.AutomaticSize.Y
t1.value24 = "GameHUD"
t1.value19 = "UDim2"
t1.value1 = "CanvasSize"

local value152 = t2.value15
local UDim2_8 = UDim2

t1.value19 = "new"
value152.CanvasSize = UDim2_8.new(0, 0, 0, 0)
t2.value15.ScrollingDirection = Enum.ScrollingDirection.Y
t2.value15.ScrollingEnabled = false
t2.value15.Parent = t2.value10
t1.value19 = "UDim"
t1.value9 = "Enum"

local UIPadding = Instance.new("UIPadding")

t1.value1 = UDim.new
t1.value25 = "LoopThread"
t1.value19 = 0
UIPadding.PaddingTop = t1.value1(t1.value19, 20)
t1.value19 = "UDim"
UIPadding.PaddingBottom = UDim.new(0, 20)
t1.value19 = "UDim"

local UDim_ = UDim

t1.value19 = "new"
UIPadding.PaddingLeft = UDim_.new(0, 10)
t1.value19 = "UDim"
UIPadding.PaddingRight = UDim.new(0, 10)
UIPadding.Parent = t2.value13
t1.value1 = Instance.new("UIListLayout")

local Enum_ = Enum
local value18 = t1.value1

t1.value9 = "FillDirection"
value18.FillDirection = Enum_.FillDirection.Vertical

local Enum_2 = Enum

t1.value9 = "SortOrder"
value18.SortOrder = Enum_2.SortOrder.LayoutOrder
t1.value9 = 7
t1.value19 = UDim
t1.value19 = t1.value19.new(0, t1.value9)
value18.Padding = t1.value19
value18.Parent = t2.value13
t2.value16 = {}
t1.value1 = "Main"
t2.value17 = nil

function t1.value9(p4)
	local Frame2 = Instance.new("Frame")

	Frame2.Size = UDim2.new(1, 0, 1, 0)
	Frame2.BackgroundTransparency = 1
	Frame2.Visible = false
	Frame2.Parent = t2.value15

	local Frame3 = Instance.new("Frame")

	Frame3.Size = UDim2.new(1, 0, 0, 0)
	Frame3.BackgroundTransparency = 1
	Frame3.AutomaticSize = Enum.AutomaticSize.Y
	Frame3.Parent = Frame2

	local UIPadding2 = Instance.new("UIPadding")

	UIPadding2.PaddingTop = UDim.new(0, 10)
	UIPadding2.PaddingBottom = UDim.new(0, 20)
	UIPadding2.PaddingLeft = UDim.new(0, 15)
	UIPadding2.PaddingRight = UDim.new(0, 15)
	UIPadding2.Parent = Frame3

	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.FillDirection = Enum.FillDirection.Vertical
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 10)
	UIListLayout.Parent = Frame3
	t2.value16[p4] = {
		frame = Frame2,
		content = Frame3,
		layout = UIListLayout
	}
	UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		local v69 = UIListLayout.AbsoluteContentSize.Y + 10 + 20
		local Y = t2.value15.AbsoluteSize.Y

		t2.value15.ScrollingEnabled = Y < v69
		t2.value15.CanvasSize = UDim2.new(0, 0, 0, v69)
	end)

	return Frame3
end
function t2.value18(p5)
	if t2.value16[p5] then
		for k, v in pairs(t2.value16) do
			v.frame.Visible = k == p5
		end

		t2.value17 = t2.value16[p5]

		local v73 = t2.value17.layout.AbsoluteContentSize.Y + 10 + 20
		local Y = t2.value15.AbsoluteSize.Y

		t2.value15.ScrollingEnabled = Y < v73
		t2.value15.CanvasSize = UDim2.new(0, 0, 0, v73)
	else
		for _, v in pairs(t2.value16) do
			v.frame.Visible = false
		end

		t2.value17 = nil
		t2.value15.ScrollingEnabled = false
		t2.value15.CanvasSize = UDim2.new(0, 0, 0, 0)
	end
end

t2.value19 = nil
t2.value20 = 0
t2.value21 = 0

local function createFrame(p6)
	t2.value20 = t2.value20 + 1

	local Frame2 = Instance.new("Frame")

	Frame2.Size = UDim2.new(1, 0, 0, 0)
	Frame2.BackgroundColor3 = Color3.fromRGB(28, 30, 32)
	Frame2.BorderSizePixel = 0
	Frame2.AutomaticSize = Enum.AutomaticSize.Y
	Frame2.LayoutOrder = t2.value20

	local value172 = t2.value17

	if value172 then
		value172 = t2.value17.content
	end

	Frame2.Parent = value172 or nil

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(0, 8)
	UICorner4.Parent = Frame2

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = Color3.fromRGB(45, 45, 45)
	UIStroke.Thickness = 1
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.Parent = Frame2

	local UIPadding2 = Instance.new("UIPadding")

	UIPadding2.PaddingTop = UDim.new(0, 12)
	UIPadding2.PaddingBottom = UDim.new(0, 12)
	UIPadding2.PaddingLeft = UDim.new(0, 12)
	UIPadding2.PaddingRight = UDim.new(0, 12)
	UIPadding2.Parent = Frame2

	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 8)
	UIListLayout.Parent = Frame2

	local v84

	if p6 then
		v84 = p6 ~= ""
	else
		v84 = p6
	end

	if not v84 then
		t2.value19 = Frame2

		return Frame2
	end

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, 0, 0, 18)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = string.upper(p6)
	TextLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextSize = 13
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.LayoutOrder = -1
	TextLabel.Parent = Frame2
	t2.value19 = Frame2

	return Frame2
end
local function v86()
	t2.value19 = nil
end

t2.value22 = {}
t2.value23 = nil

local function createFrame2(p7, p8, p9)
	local value21 = not p9

	if value21 then
		value21 = t2.value21 + 1
		t2.value21 = value21
	end

	local Frame2 = Instance.new("Frame")

	Frame2.Size = UDim2.new(1, 0, 0, 38)
	Frame2.BackgroundColor3 = Color3.fromRGB(24, 28, 30)
	Frame2.BorderSizePixel = 0
	Frame2.LayoutOrder = p9 or t2.value21
	Frame2.Parent = t2.value13

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(0, 8)
	UICorner4.Parent = Frame2

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Name = "Stroke"
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.Color = Color3.fromRGB(45, 58, 56)
	UIStroke.Thickness = 1
	UIStroke.Transparency = 0
	UIStroke.Parent = Frame2

	local Frame3 = Instance.new("Frame")

	Frame3.Size = UDim2.new(0, 3, 1, -10)
	Frame3.Position = UDim2.new(0, 6, 0, 5)
	Frame3.BackgroundColor3 = Color3.fromRGB(0, 255, 200)
	Frame3.BorderSizePixel = 0
	Frame3.BackgroundTransparency = 1
	Frame3.Name = "ActiveLine"
	Frame3.Parent = Frame2

	local UICorner5 = Instance.new("UICorner")

	UICorner5.CornerRadius = UDim.new(1, 0)
	UICorner5.Parent = Frame3

	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Name = "Icon"
	ImageLabel.Size = UDim2.new(0, 18, 0, 18)
	ImageLabel.Position = UDim2.new(0, 16, 0.5, -9)
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Image = p8 or ""
	ImageLabel.ImageColor3 = Color3.fromRGB(170, 190, 185)
	ImageLabel.Parent = Frame2

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Name = "Label"
	TextLabel.Size = UDim2.new(1, -44, 1, 0)
	TextLabel.Position = UDim2.new(0, 42, 0, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = p7
	TextLabel.TextColor3 = Color3.fromRGB(170, 190, 185)
	TextLabel.Font = Enum.Font.GothamMedium
	TextLabel.TextSize = 14
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.Parent = Frame2

	local value22 = t2.value22

	table.insert(value22, Frame2)
	Frame2.MouseEnter:Connect(function()
		if t2.value23 == Frame2 then
			return
		end

		t2.value4:Create(Frame2, TweenInfo.new(0.15), {
			BackgroundColor3 = Color3.fromRGB(30, 36, 38)
		}):Play()
		t2.value4:Create(ImageLabel, TweenInfo.new(0.15), {
			ImageColor3 = Color3.fromRGB(210, 230, 225)
		}):Play()

		local value4 = t2.value4
		local v98 = TextLabel
		local tweenInfo = TweenInfo.new(0.15)
		local t3 = {
			TextColor3 = Color3.fromRGB(210, 230, 225)
		}

		value4.Create(value4, v98, tweenInfo, t3):Play()
		t2.value4:Create(UIStroke, TweenInfo.new(0.15), {
			Color = Color3.fromRGB(70, 95, 90)
		}):Play()
	end)
	Frame2.MouseLeave:Connect(function()
		if t2.value23 == Frame2 then
			return
		end

		local value4 = t2.value4
		local v102 = Frame2
		local tweenInfo = TweenInfo.new(0.15)
		local Color3_4 = Color3

		value4.Create(value4, v102, tweenInfo, {
			BackgroundColor3 = Color3_4.fromRGB(24, 28, 30)
		}):Play()

		local value42 = t2.value4
		local v106 = ImageLabel
		local tweenInfo2 = TweenInfo.new(0.15)
		local t4 = {
			ImageColor3 = Color3.fromRGB(170, 190, 185)
		}

		value42.Create(value42, v106, tweenInfo2, t4):Play()
		t2.value4:Create(TextLabel, TweenInfo.new(0.15), {
			TextColor3 = Color3.fromRGB(170, 190, 185)
		}):Play()

		local value43 = t2.value4
		local v110 = UIStroke
		local tweenInfo3 = TweenInfo.new(0.15)
		local Color3_5 = Color3

		value43.Create(value43, v110, tweenInfo3, {
			Color = Color3_5.fromRGB(45, 58, 56)
		}):Play()
	end)
	Frame2.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		t2.value18(p7)

		local value23 = t2.value23

		if value23 then
			value23 = t2.value23 ~= Frame2
		end

		if value23 then
			local value4 = t2.value4
			local value232 = t2.value23
			local tweenInfo = TweenInfo.new(0.2)
			local color33 = Color3.fromRGB

			value4.Create(value4, value232, tweenInfo, {
				BackgroundColor3 = color33(24, 28, 30)
			}):Play()

			local ActiveLine = t2.value23:FindFirstChild("ActiveLine")

			if ActiveLine then
				t2.value4:Create(ActiveLine, TweenInfo.new(0.2), {
					BackgroundTransparency = 1
				}):Play()
			end

			local Icon = t2.value23:FindFirstChild("Icon")

			if Icon then
				t2.value4:Create(Icon, TweenInfo.new(0.2), {
					ImageColor3 = Color3.fromRGB(170, 190, 185)
				}):Play()
			end

			local Label = t2.value23:FindFirstChild("Label")

			if Label then
				local value42 = t2.value4
				local tweenInfo2 = TweenInfo.new(0.2)
				local color34 = Color3.fromRGB

				value42.Create(value42, Label, tweenInfo2, {
					TextColor3 = color34(170, 190, 185)
				}):Play()
			end

			local Stroke = t2.value23:FindFirstChild("Stroke")

			if Stroke then
				local value42 = t2.value4
				local tweenInfo2 = TweenInfo.new(0.2)
				local t5 = {
					Color = Color3.fromRGB(45, 58, 56)
				}

				value42.Create(value42, Stroke, tweenInfo2, t5):Play()
			end
		end

		local tweenInfoNew = TweenInfo.new

		t2.value4:Create(Frame2, tweenInfoNew(0.2), {
			BackgroundColor3 = Color3.fromRGB(18, 48, 42)
		}):Play()
		t2.value4:Create(Frame3, TweenInfo.new(0.2), {
			BackgroundTransparency = 0
		}):Play()

		local value4 = t2.value4
		local v130 = ImageLabel
		local tweenInfo = TweenInfo.new(0.2)
		local t6 = {
			ImageColor3 = Color3.fromRGB(0, 255, 200)
		}

		value4.Create(value4, v130, tweenInfo, t6):Play()
		t2.value4:Create(TextLabel, TweenInfo.new(0.2), {
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}):Play()

		local value42 = t2.value4
		local v134 = UIStroke
		local tweenInfo2 = TweenInfo.new(0.2)
		local color33 = Color3.fromRGB

		value42.Create(value42, v134, tweenInfo2, {
			Color = color33(0, 255, 200)
		}):Play()
		t2.value23 = Frame2
	end)

	return Frame2
end
local function v137(p10)
	t2.value20 = t2.value20 + 1

	local v138 = p10 or {}
	local Text = v138.Text or "Color Picker"
	local Callback = v138.Callback or function() end
	local color33 = Color3.fromRGB(0, 255, 200)
	local u142, u143, u144 = color33:ToHSV()
	local u145 = false
	local u146 = false
	local Frame2 = Instance.new("Frame")

	Frame2.Size = UDim2.new(1, 0, 0, 34)
	Frame2.BackgroundTransparency = 1
	Frame2.ClipsDescendants = true
	Frame2.LayoutOrder = t2.value20

	local value19

	if t2.value19 then
		value19 = t2.value19
	else
		value19 = t2.value17 and t2.value17.content or nil
	end

	Frame2.Parent = value19

	local Frame3 = Instance.new("Frame")

	Frame3.Size = UDim2.new(1, 0, 0, 34)
	Frame3.BackgroundColor3 = Color3.fromRGB(45, 47, 53)
	Frame3.BorderSizePixel = 0
	Frame3.Parent = Frame2

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(0, 8)
	UICorner4.Parent = Frame3

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, -100, 0, 34)
	TextLabel.Position = UDim2.new(0, 12, 0, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = Text
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.Font = Enum.Font.SourceSansSemibold
	TextLabel.TextSize = 18
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.Parent = Frame3

	local Frame4 = Instance.new("Frame")

	Frame4.Size = UDim2.new(0, 22, 0, 22)
	Frame4.Position = UDim2.new(1, -30, 0.5, -11)
	Frame4.BackgroundColor3 = color33
	Frame4.BorderSizePixel = 0
	Frame4.Parent = Frame3

	local UICorner5 = Instance.new("UICorner")

	UICorner5.CornerRadius = UDim.new(0, 4)
	UICorner5.Parent = Frame4

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(0, 60, 0, 22)
	TextLabel2.Position = UDim2.new(1, -95, 0.5, -11)
	TextLabel2.BackgroundColor3 = Color3.fromRGB(25, 27, 30)
	TextLabel2.TextColor3 = Color3.fromRGB(180, 180, 180)
	TextLabel2.Font = Enum.Font.SourceSansSemibold
	TextLabel2.TextSize = 14
	TextLabel2.Text = "#" .. color33:ToHex():upper()
	TextLabel2.Parent = Frame3

	local UICorner6 = Instance.new("UICorner")

	UICorner6.CornerRadius = UDim.new(0, 4)
	UICorner6.Parent = TextLabel2

	local TextButton2 = Instance.new("TextButton")

	TextButton2.Size = UDim2.new(1, 0, 1, 0)
	TextButton2.BackgroundTransparency = 1
	TextButton2.Text = ""
	TextButton2.Parent = Frame3

	local Frame5 = Instance.new("Frame")

	Frame5.Size = UDim2.new(1, 0, 0, 42)
	Frame5.Position = UDim2.new(0, 0, 0, 38)
	Frame5.BackgroundTransparency = 1
	Frame5.ClipsDescendants = true
	Frame5.Parent = Frame2

	local Frame6 = Instance.new("Frame")

	Frame6.Size = UDim2.new(1, -20, 0, 20)
	Frame6.Position = UDim2.new(0, 10, 0, 10)
	Frame6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame6.BorderSizePixel = 0
	Frame6.Parent = Frame5

	local UICorner7 = Instance.new("UICorner")

	UICorner7.CornerRadius = UDim.new(0, 4)
	UICorner7.Parent = Frame6

	local UIGradient = Instance.new("UIGradient")

	UIGradient.Rotation = 0
	UIGradient.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
		ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
		ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
		ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
		ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
	})
	UIGradient.Parent = Frame6

	local Frame7 = Instance.new("Frame")

	Frame7.Size = UDim2.new(0, 10, 1, 4)
	Frame7.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame7.Position = UDim2.new(u142, 0, 0.5, 0)
	Frame7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame7.Parent = Frame6

	local UICorner8 = Instance.new("UICorner")

	UICorner8.CornerRadius = UDim.new(0, 2)
	UICorner8.Parent = Frame7

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = Color3.fromRGB(0, 0, 0)

	local function v164()
		u145 = not u145

		local v165 = u145 and 80 or 34

		t2.value4:Create(Frame2, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
			Size = UDim2.new(1, 0, 0, v165)
		}):Play()
	end

	UIStroke.Thickness = 1
	UIStroke.Parent = Frame7

	local function v166()
		local color34 = Color3.fromHSV(u142, u143, u144)

		Frame4.BackgroundColor3 = color34
		Frame7.Position = UDim2.new(u142, 0, 0.5, 0)
		TextLabel2.Text = "#" .. color34:ToHex():upper()
		Callback(color34)
	end

	TextButton2.MouseButton1Click:Connect(v164)
	Frame6.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u146 = true

		local v168 = (input.Position.X - Frame6.AbsolutePosition.X) / Frame6.AbsoluteSize.X
		local v169 = math.clamp(v168, 0, 1)

		u142 = math.clamp(v169, 0, 1)
		u143 = 1
		u144 = 1
		v166()
	end)
	t2.value3.InputEnded:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u146 = false
	end)
	t2.value3.InputChanged:Connect(function(input)
		local v170 = input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch

		if v170 then
			v170 = u146
		end

		if not v170 then
			return
		end

		local v171 = (input.Position.X - Frame6.AbsolutePosition.X) / Frame6.AbsoluteSize.X
		local v172 = math.clamp(v171, 0, 1)

		u142 = math.clamp(v172, 0, 1)
		u143 = 1
		u144 = 1
		v166()
	end)
	v166()

	return {
		Get = function(_)
			return Color3.fromHSV(u142, u143, u144)
		end,
		Set = function(_, p11)
			local v173 = p11:ToHSV()

			u142 = math.clamp(v173, 0, 1)
			u143 = 1
			u144 = 1
			v166()
		end
	}
end
local function createTextLabel(p12)
	t2.value20 = t2.value20 + 1

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, 0, 0, 20)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = p12
	TextLabel.TextColor3 = Color3.fromRGB(0, 255, 200)
	TextLabel.Font = Enum.Font.SourceSansBold
	TextLabel.TextSize = 13
	TextLabel.TextXAlignment = Enum.TextXAlignment.Center
	TextLabel.LayoutOrder = t2.value20

	local value19

	if t2.value19 then
		value19 = t2.value19
	else
		value19 = t2.value17 and t2.value17.content or nil
	end

	TextLabel.Parent = value19

	return TextLabel
end
local function createFrame3(p13, p14, p15)
	t2.value20 = t2.value20 + 1

	local Frame2 = Instance.new("Frame")

	Frame2.Size = UDim2.new(1, 0, 0, 44)
	Frame2.BackgroundColor3 = Color3.fromRGB(34, 38, 44)
	Frame2.BorderSizePixel = 0
	Frame2.LayoutOrder = t2.value20

	local value19

	if t2.value19 then
		value19 = t2.value19
	else
		value19 = t2.value17 and t2.value17.content or nil
	end

	Frame2.Parent = value19

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(0, 8)
	UICorner4.Parent = Frame2

	local UIStroke = Instance.new("UIStroke")

	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.Color = Color3.fromRGB(65, 72, 84)
	UIStroke.Thickness = 1.2
	UIStroke.Parent = Frame2

	local TextLabel = Instance.new("TextLabel")

	if p15 then
		local uDim25 = UDim2.new(1, -28, 1, 0)
	end

	TextLabel.Size = v203 or UDim2.new(1, -110, 1, 0)
	TextLabel.Position = UDim2.new(0, 14, 0, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = p13
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextSize = 14
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.Parent = Frame2

	local u186 = nil
	local Frame3, TextLabel2

	if p15 then
		Frame3 = nil
		TextLabel2 = nil
	else
		Frame3 = Instance.new("Frame")
		Frame3.Size = UDim2.new(0, 84, 0, 28)
		Frame3.Position = UDim2.new(1, -94, 0.5, -14)
		Frame3.BackgroundColor3 = Color3.fromRGB(48, 54, 64)
		Frame3.BorderSizePixel = 0
		Frame3.Parent = Frame2

		local UICorner5 = Instance.new("UICorner")

		UICorner5.CornerRadius = UDim.new(0, 6)
		UICorner5.Parent = Frame3

		local UIStroke2 = Instance.new("UIStroke")

		UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke2.Color = Color3.fromRGB(75, 84, 98)
		UIStroke2.Thickness = 1
		UIStroke2.Parent = Frame3
		TextLabel2 = Instance.new("TextLabel")
		TextLabel2.Size = UDim2.fromScale(1, 1)
		TextLabel2.BackgroundTransparency = 1
		TextLabel2.Text = "Run"
		TextLabel2.TextColor3 = Color3.fromRGB(0, 255, 200)
		TextLabel2.Font = Enum.Font.GothamBold
		TextLabel2.TextSize = 12
		TextLabel2.Parent = Frame3
	end

	local TextButton2 = Instance.new("TextButton")

	TextButton2.Size = UDim2.fromScale(1, 1)
	TextButton2.BackgroundTransparency = 1

	local function v192()
		if p15 then
			t2.value4:Create(Frame2, TweenInfo.new(0.2), {
				BackgroundColor3 = Color3.fromRGB(44, 50, 58)
			}):Play()
			v214 = t2.value4
			v214.Create(v214, UIStroke, TweenInfo.new(0.2), {
				Color = Color3.fromRGB(0, 255, 200)
			}):Play()

			return
		end

		t2.value4:Create(Frame3, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(0, 255, 200)
		}):Play()

		local value4 = t2.value4
		local v194 = TextLabel2
		local tweenInfo = TweenInfo.new(0.2)
		local Color3_4 = Color3

		value4.Create(value4, v194, tweenInfo, {
			TextColor3 = Color3_4.fromRGB(0, 0, 0)
		}):Play()
		t2.value4:Create(Frame2, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(44, 50, 58)
		}):Play()

		local value42 = t2.value4

		value42.Create(value42, UIStroke, TweenInfo.new(0.2), {
			Color = Color3.fromRGB(0, 255, 200)
		}):Play()
	end

	TextButton2.Text = ""
	TextButton2.Parent = Frame2
	TextButton2.MouseEnter:Connect(v192)
	TextButton2.MouseLeave:Connect(function()
		if p15 then
			v219 = t2.value4
			v220 = Frame2
			v221 = TweenInfo.new(0.2)
			v222 = Color3
			v219.Create(v219, v220, v221, {
				BackgroundColor3 = v222.fromRGB(34, 38, 44)
			}):Play()
			v223 = t2.value4
			v224 = UIStroke
			v225 = TweenInfo.new(0.2)
			v226 = Color3.fromRGB
			v223.Create(v223, v224, v225, {
				Color = v226(65, 72, 84)
			}):Play()

			return
		end

		t2.value4:Create(Frame3, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(48, 54, 64)
		}):Play()

		local value4 = t2.value4
		local v199 = TextLabel2
		local TweenInfo_ = TweenInfo

		value4.Create(value4, v199, TweenInfo_.new(0.2), {
			TextColor3 = Color3.fromRGB(0, 255, 200)
		}):Play()

		local value42 = t2.value4
		local v202 = Frame2
		local tweenInfo = TweenInfo.new(0.2)
		local Color3_4 = Color3

		value42.Create(value42, v202, tweenInfo, {
			BackgroundColor3 = Color3_4.fromRGB(34, 38, 44)
		}):Play()

		local value43 = t2.value4
		local v206 = UIStroke
		local tweenInfo2 = TweenInfo.new(0.2)
		local color33 = Color3.fromRGB

		value43.Create(value43, v206, tweenInfo2, {
			Color = color33(65, 72, 84)
		}):Play()
	end)

	local function v209()
		if p14 then
			p14()
		end

		if p15 or u186 then
			return
		end

		u186 = true
		TextLabel2.Text = "Executed"

		local function v210()
			TextLabel2.Text = "Run"
			u186 = false
		end

		task.delay(1.5, v210)
	end

	TextButton2.Activated:Connect(v209)

	return Frame2
end
local function v211(p16, p17)
	t2.value20 = t2.value20 + 1

	local Frame2 = Instance.new("Frame")

	Frame2.Size = UDim2.new(1, 0, 0, 30)
	Frame2.BackgroundTransparency = 1
	Frame2.LayoutOrder = t2.value20

	local value19

	if t2.value19 then
		value19 = t2.value19
	else
		value19 = t2.value17 and t2.value17.content or nil
	end

	Frame2.Parent = value19

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, -60, 1, 0)
	TextLabel.Position = UDim2.new(0, 0, 0, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = p16
	TextLabel.TextColor3 = Color3.fromRGB(230, 230, 230)
	TextLabel.Font = Enum.Font.SourceSansSemibold
	TextLabel.TextSize = 18
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.Parent = Frame2

	local Frame3 = Instance.new("Frame")

	Frame3.Size = UDim2.new(0, 50, 0, 24)
	Frame3.Position = UDim2.new(1, -55, 0.5, -12)
	Frame3.BackgroundColor3 = Color3.fromRGB(180, 180, 180)
	Frame3.BorderSizePixel = 0
	Frame3.Parent = Frame2

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(0.5, 0)
	UICorner4.Parent = Frame3

	local Frame4 = Instance.new("Frame")

	Frame4.Size = UDim2.new(0, 20, 0, 20)
	Frame4.Position = UDim2.new(0, 2, 0.5, -10)
	Frame4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame4.Parent = Frame3

	local UICorner5 = Instance.new("UICorner")

	UICorner5.CornerRadius = UDim.new(1, 0)
	UICorner5.Parent = Frame4

	local u219 = false

	local function v227()
		if u219 then
			local value4 = t2.value4
			local v228 = Frame3
			local tweenInfo = TweenInfo.new(0.25, Enum.EasingStyle.Quad)
			local t7 = {
				BackgroundColor3 = Color3.fromRGB(100, 200, 120)
			}

			value4.Create(value4, v228, tweenInfo, t7):Play()

			local value42 = t2.value4
			local v229 = Frame4
			local tweenInfo2 = TweenInfo.new(0.25, Enum.EasingStyle.Quad)
			local UDim2_9 = UDim2

			value42.Create(value42, v229, tweenInfo2, {
				Position = UDim2_9.new(1, -22, 0.5, -10)
			}):Play()
		else
			t2.value4:Create(Frame3, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {
				BackgroundColor3 = Color3.fromRGB(180, 180, 180)
			}):Play()

			local value4 = t2.value4
			local v230 = Frame4
			local tweenInfoNew = TweenInfo.new
			local EasingStyle = Enum.EasingStyle

			value4.Create(value4, v230, tweenInfoNew(0.25, EasingStyle.Quad), {
				Position = UDim2.new(0, 2, 0.5, -10)
			}):Play()
		end
	end

	Frame3.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u219 = not u219
		v227()

		if not p17 then
			return
		end

		p17(u219)
	end)
	v227()
end
local function v233(p18)
	t2.value20 = t2.value20 + 1

	local v234 = p18 or {}
	local Text = v234.Text or "Slider"
	local Min = v234.Min or 0
	local Max = v234.Max or 100
	local Default = v234.Default or Min
	local Decimals = v234.Decimals or 1
	local Suffix = v234.Suffix or ""
	local Callback = v234.Callback or function() end
	local u242 = math.clamp(Default, Min, Max)
	local u243 = false
	local Frame2 = Instance.new("Frame")

	Frame2.Size = UDim2.new(1, 0, 0, 90)
	Frame2.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	Frame2.BorderSizePixel = 0
	Frame2.LayoutOrder = t2.value20

	local value19

	if t2.value19 then
		value19 = t2.value19
	else
		value19 = t2.value17 and t2.value17.content or nil
	end

	Frame2.Parent = value19

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(0, 6)
	UICorner4.Parent = Frame2

	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = Color3.fromRGB(153, 66, 66)
	UIStroke.Thickness = 2
	UIStroke.Parent = Frame2

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, -10, 0, 20)
	TextLabel.Position = UDim2.new(0, 5, 0, 5)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = Text .. ": " .. u242 .. Suffix
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.Font = Enum.Font.SourceSansSemibold
	TextLabel.TextSize = 18
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.Parent = Frame2

	local Frame3 = Instance.new("Frame")

	Frame3.Size = UDim2.new(1, -10, 0, 14)
	Frame3.Position = UDim2.new(0, 5, 0, 35)
	Frame3.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
	Frame3.BorderSizePixel = 0
	Frame3.Parent = Frame2

	local UICorner5 = Instance.new("UICorner")

	UICorner5.CornerRadius = UDim.new(1, 0)
	UICorner5.Parent = Frame3

	local Frame4 = Instance.new("Frame")

	Frame4.Size = UDim2.new((u242 - Min) / (Max - Min), 0, 1, 0)
	Frame4.BackgroundColor3 = Color3.fromRGB(153, 66, 66)
	Frame4.BorderSizePixel = 0
	Frame4.Parent = Frame3

	local UICorner6 = Instance.new("UICorner")

	UICorner6.CornerRadius = UDim.new(1, 0)
	UICorner6.Parent = Frame4

	local TextBox = Instance.new("TextBox")

	TextBox.Size = UDim2.new(0, 60, 0, 20)
	TextBox.Position = UDim2.new(0.5, -30, 0, Frame3.Position.Y.Offset + Frame3.Size.Y.Offset + 5)
	TextBox.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
	TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextBox.Font = Enum.Font.SourceSansSemibold
	TextBox.TextSize = 14
	TextBox.Text = tostring(u242)
	TextBox.ClearTextOnFocus = false
	TextBox.Parent = Frame2

	local function v254(p19)
		local v255 = Min
		local v256 = Max
		local v257 = math.clamp(p19, v255, v256) * Decimals

		u242 = math.floor(v257) / Decimals
		Frame4.Size = UDim2.new((u242 - Min) / (Max - Min), 0, 1, 0)
		TextLabel.Text = Text .. ": " .. u242 .. Suffix

		local v258 = u242

		TextBox.Text = tostring(v258)
		Callback(u242)
	end

	TextBox.FocusLost:Connect(function()
		local Text2 = TextBox.Text
		local v260 = tonumber(Text2)

		if v260 then
			v254(v260)
		else
			local v261 = u242

			TextBox.Text = tostring(v261)
		end
	end)
	Frame3.InputBegan:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u243 = true

		local v262 = (input.Position.X - Frame3.AbsolutePosition.X) / Frame3.AbsoluteSize.X
		local v263 = math.clamp(v262, 0, 1)

		v254(Min + (Max - Min) * v263)
	end)
	Frame3.InputEnded:Connect(function(input)
		if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
			return
		end

		u243 = false
	end)
	t2.value3.InputChanged:Connect(function(input)
		local v264 = u243

		if v264 then
			v264 = input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch
		end

		if not v264 then
			return
		end

		local v265 = (input.Position.X - Frame3.AbsolutePosition.X) / Frame3.AbsoluteSize.X
		local v266 = math.clamp(v265, 0, 1)

		v254(Min + (Max - Min) * v266)
	end)
	v254(u242)

	return {
		Get = function(_)
			return u242
		end
	}
end

createFrame2("Main", "rbxassetid://101988819289766")
t1.value9("Main")
t2.value18("Main")
game:GetService("ServerStorage").ChildAdded:Connect(function(child)
	task.defer(function()
		child.Parent = workspace
	end)
end)

function t2.value24()
	local ipairs_ = ipairs
	local workspace_ = workspace

	for _, child in ipairs_(workspace_.GetChildren(workspace_)) do
		local isModel = child:IsA("Model")

		if isModel then
			isModel = child:FindFirstChild("Exits") or child:FindFirstChild("ExitGateways")
		end

		if isModel then
			return child
		end
	end

	return nil
end

local function v272(p20)
	if not p20 then
		return false
	end

	local Character = p20.Character

	if Character then
		Character = Character:FindFirstChildOfClass("Humanoid")
	end

	if not Character or Character.Health <= 0 then
		return false
	end

	local Team = p20.Team

	if Team then
		Team = p20.Team.Name
	end

	local v275

	if Team then
		if Team == "Survivor" then
			v275 = p20:GetAttribute("Downed") == true
		else
			v275 = false
		end

		return not v275
	end

	local Team2 = p20.Team

	Team = tostring(Team2)

	if Team == "Survivor" then
		v275 = p20:GetAttribute("Downed") == true
	else
		v275 = false
	end

	return not v275
end
local function v277(p21)
	local Character = t2.value2.Character
	local HumanoidRootPart

	if Character then
		HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	else
		HumanoidRootPart = Character
	end

	if Character then
		Character = Character:FindFirstChildOfClass("Humanoid")
	end

	if not HumanoidRootPart or (not Character or Character.Health <= 0) then
		return
	end

	local AssemblyLinearVelocity = HumanoidRootPart.AssemblyLinearVelocity

	if not (Character.MoveDirection.Magnitude > 0) then
		HumanoidRootPart.CFrame = p21
		HumanoidRootPart.AssemblyLinearVelocity = AssemblyLinearVelocity

		return
	end

	AssemblyLinearVelocity = Character.MoveDirection * Character.WalkSpeed
	HumanoidRootPart.CFrame = p21
	HumanoidRootPart.AssemblyLinearVelocity = AssemblyLinearVelocity
end
local function v281()
	local _Lobby = workspace:FindFirstChild("_Lobby")
	local v283

	if _Lobby then
	elseif _Lobby then
		if _Lobby:IsA("Model") or _Lobby:IsA("BasePart") then
			return _Lobby:GetPivot() + Vector3.new(0, 3, 0)
		else
			v283 = _Lobby.IsA(_Lobby, "Folder") and _Lobby:GetChildren()[1]

			if v283 then
				return v283:GetPivot() + Vector3.new(0, 3, 0)
			else
				return nil
			end
		end
	else
		return nil
	end

	_Lobby = _Lobby:FindFirstChild("Benches")

	if _Lobby then
		if _Lobby:IsA("Model") or _Lobby:IsA("BasePart") then
			return _Lobby:GetPivot() + Vector3.new(0, 3, 0)
		else
			v283 = _Lobby.IsA(_Lobby, "Folder") and _Lobby:GetChildren()[1]

			if v283 then
				return v283:GetPivot() + Vector3.new(0, 3, 0)
			else
				return nil
			end
		end
	else
		return nil
	end
end
local function v284()
	local ipairs_ = ipairs
	local value19 = t2.value1

	for _, player in ipairs_(value19.GetPlayers(value19)) do
		local Team = player.Team

		if Team then
			Team = player.Team.Name == "Killer"
		end

		if not Team then
			local Team2 = player.Team

			Team = tostring(Team2) == "Killer"
		end

		if Team then
			Team = player.Character

			if Team then
				Team = player.Character:FindFirstChild("HumanoidRootPart")
			end
		end

		if Team then
			return player
		end
	end

	return nil
end

t1.value23 = t1.value23(PlayerGui, "GameHUD")
t1.value24 = t1.value23:WaitForChild("BannerNotificationStream")
t1.value18 = false
t1.value23 = "ExitsOpened"

local value25 = {
	IsEnabled = false,
	NotificationBanner = t1.value24,
	ExitsOpened = t1.value18,
	IsEscaping = t1.value21
}

t1.value21 = "DangerDistance"
t1.value18 = "OriginalPosition"
t1.value1 = "IsEnabled"
t2.value25 = value25
t1.value23 = "IsSaving"
t1.value7 = nil
t1.value22 = false
t1.value24 = false

local value26 = {
	IsEnabled = t1.value22,
	IsSaving = t1.value24,
	OriginalPosition = t1.value7,
	DangerDistance = 22,
	SafeDistance = 35,
	LoopThread = t1.value14
}

t1.value23 = false
t1.value14 = "LoopThread"
t1.value24 = "IsReviving"
t1.value1 = "IsEnabled"
t1.value21 = nil
t1.value7 = "OriginalPosition"
t1.value18 = false
t1.value16 = "SafeDistance"
t1.value25 = 2.5
t1.value8 = "MaxStandTime"
t2.value26 = value26

local value27 = {
	IsEnabled = t1.value23,
	IsReviving = t1.value18,
	OriginalPosition = t1.value21,
	SafeDistance = 25,
	MaxStandTime = t1.value25,
	LoopThread = nil
}

t1.value25 = 0
t1.value21 = "LoopThread"
t1.value5 = nil
t1.value24 = false
t1.value16 = nil
t2.value27 = value27
t1.value1 = "IsEnabled"
t1.value18 = "IsGettingRevived"
t1.value7 = false

local value28 = {
	IsEnabled = t1.value24,
	IsGettingRevived = t1.value7,
	LoopThread = t1.value16
}

t1.value7 = "Mode"
t1.value1 = "IsEnabled"
t1.value16 = "IsLooting"
t1.value13 = false
t1.value8 = "LastLootTime"
t1.value14 = "LoopThread"
t1.value18 = false
t1.value21 = "Infinite"
t2.value28 = value28
t1.value1 = "IsEnabled"
t1.value7 = false
t2.value29 = {
	IsEnabled = t1.value18,
	Mode = "Infinite",
	IsLooting = t1.value13,
	LastLootTime = t1.value25,
	LoopThread = t1.value5
}

local value30 = {
	IsEnabled = t1.value7
}

t1.value16 = false
t1.value8 = nil
t2.value30 = value30
t1.value1 = "IsEnabled"
t1.value13 = "LoopThread"
t2.value31 = {
	IsEnabled = false
}
t1.value5 = Vector3.new(2, t1.value15, 1)
t1.value10 = "Vector3"
t1.value14 = "RageSize"
t1.value15 = Vector3.new(650, 80, 650)
t1.value10 = 0.05
t1.value4 = "NextTargetDelay"
t1.value20 = 0.03
t2.value32 = {
	IsEnabled = t1.value16,
	LoopThread = t1.value8,
	DefaultSize = t1.value5,
	RageSize = t1.value15,
	HitDuration = t1.value10,
	NextTargetDelay = t1.value20,
	LoopDelay = t1.value12
}
t2.value33 = nil
createTextLabel("Survivor")
t1.value15 = "List"
t1.value1 = "Auto Loot"
createFrame("Auto Loot")

local function v296()
	local t8 = {}
	local v298 = t2.value24()

	if not v298 then
		return t8
	end

	local LootSpawns = v298:FindFirstChild("LootSpawns")

	if not LootSpawns then
		return t8
	end

	for _, child in ipairs(LootSpawns:GetChildren()) do
		local Position = child:GetPivot().Position

		table.insert(t8, Position)
	end

	return t8
end

function t1.value5(p22)
	t2.value29.IsEnabled = p22

	if p22 then
		t2.value33()

		return
	end

	if not t2.value29.LoopThread then
		return
	end

	task.cancel(t2.value29.LoopThread)
	t2.value29.LoopThread = nil
end
function t2.value34()
	return t2.value29.Mode == "Every 30 sec" and 30 or (t2.value29.Mode == "Every 1 min" and 60 or (t2.value29.Mode == "Every 2 min" and 120 or (t2.value29.Mode == "Infinite" and 0.1 or 1)))
end
function t2.value35()
	local v303

	if t2.value2.Team then
		local Name = t2.value2.Team.Name

		if not Name then
			local Team = t2.value2.Team

			Name = tostring(Team)
		end

		v303 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or (Name == "Lobby" and "Lobby" or "None"))
	else
		v303 = "None"
	end

	if not (v303 ~= "Survivor" or (t2.value25.ExitsOpened or (t2.value25.IsEscaping or (t2.value27.IsReviving or (t2.value28.IsGettingRevived or (t2.value26.IsSaving or not v272(t2.value2))))))) then
		local v306 = v296()

		if #v306 == 0 then
			return
		else
			t2.value29.IsLooting = true

			local ipairs_ = ipairs

			for _, v in ipairs_(v306) do
				local v310

				if t2.value2.Team then
					local Name = t2.value2.Team.Name

					if not Name then
						local Team = t2.value2.Team

						Name = tostring(Team)
					end

					v310 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or (Name == "Lobby" and "Lobby" or "None"))
				else
					v310 = "None"
				end

				if v310 ~= "Survivor" or (t2.value25.ExitsOpened or (t2.value27.IsReviving or (t2.value28.IsGettingRevived or (t2.value26.IsSaving or not v272(t2.value2))))) then
					t2.value29.IsLooting = false

					return
				end

				local v313 = v284()
				local Character

				if v313 then
					Character = v313.Character

					if Character then
						Character = v313.Character:FindFirstChild("HumanoidRootPart")
					end
				else
					Character = v313
				end

				local v315 = false

				if Character then
					local Magnitude = (Vector3.new(Character.Position.X, 0, Character.Position.Z) - Vector3.new(v.X, 0, v.Z)).Magnitude

					ipairs_ = math.abs

					local v317 = ipairs_(Character.Position.Y - v.Y)
					local v318

					if Magnitude <= 12 then
						v318 = v317 <= 25
					else
						v318 = false
					end

					if v318 then
						v315 = true
						ipairs_ = true
					end
				else
					ipairs_ = v315
				end

				if not v315 then
					v277(CFrame.new(v + Vector3.new(0, 2, 0)))
					task.wait(0.1)
				end
			end

			t2.value29.IsLooting = false

			return
		end
	end
end

t1.value1 = "Enable"
t1.value10 = {
	"Every 30 sec",
	"Every 1 min",
	"Every 2 min",
	"Infinite"
}

function t2.value33()
	if t2.value29.LoopThread then
		task.cancel(t2.value29.LoopThread)
		t2.value29.LoopThread = nil
	end

	if not t2.value29.IsEnabled then
		return
	end

	t2.value29.LastLootTime = 0
	t2.value29.LoopThread = task.spawn(function()
		local n3 = 2131624

		while t2.value29.IsEnabled do
			local v320

			if t2.value2.Team then
				local Name = t2.value2.Team.Name

				if not Name then
					local Team = t2.value2.Team

					Name = tostring(Team)
				end

				v320 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or (Name == "Lobby" and "Lobby" or "None"))
			else
				v320 = "None"
			end

			if v320 == "Survivor" then
				local v323 = not t2.value25.ExitsOpened

				if v323 then
					v323 = not t2.value25.IsEscaping

					if v323 then
						v323 = v272(t2.value2)

						if v323 then
							v323 = not t2.value27.IsReviving

							if v323 then
								v323 = not t2.value28.IsGettingRevived

								if v323 then
									v323 = not t2.value26.IsSaving
								end
							end
						end
					end
				end

				local v324 = t2.value34()

				if v323 then
					v323 = v324 <= os.clock() - t2.value29.LastLootTime
				end

				if v323 then
					t2.value35()
					t2.value29.LastLootTime = os.clock()
				end
			end

			n3 = task.wait
			n3(0.2)
		end
	end)
end

v211("Enable", t1.value5)

function t1.value12(p23)
	t2.value29.Mode = p23

	if not t2.value29.IsEnabled then
		return
	end

	t2.value33()
end

t1.value5 = "Text"
t1.value20 = "Infinite"
(function(p24)
	local value20 = t2.value20 + 1

	t2.value20 = value20

	local v326 = p24 or {}
	local Text = v326.Text or "Dropdown"
	local List = v326.List or {}
	local Default = v326.Default
	local Callback = v326.Callback or function() end
	local Multi = v326.Multi or false
	local v332 = v326.ChangeText ~= false
	local u333 = false
	local u334 = nil
	local t9 = {}
	local Frame2 = Instance.new("Frame")
	local n4 = 34

	Frame2.Size = UDim2.new(1, 0, 0, 34)
	Frame2.BackgroundTransparency = 1
	Frame2.ClipsDescendants = true
	Frame2.LayoutOrder = t2.value20

	local value19

	if t2.value19 then
		value19 = t2.value19
	else
		value19 = t2.value17 and t2.value17.content or nil
	end

	Frame2.Parent = value19

	local Frame3 = Instance.new("Frame")

	Frame3.Size = UDim2.new(1, 0, 0, 34)
	Frame3.BackgroundColor3 = Color3.fromRGB(45, 47, 53)
	Frame3.BorderSizePixel = 0
	Frame3.Parent = Frame2

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(0, 8)
	UICorner4.Parent = Frame3

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, -20, 0, 34)
	TextLabel.Position = UDim2.new(0, 12, 0, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = Text
	TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel.Font = Enum.Font.SourceSansSemibold
	TextLabel.TextSize = 18
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.Parent = Frame3

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, -20, 0, n4)
	TextLabel2.Position = UDim2.new(0, 12, 0, 0)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = ""
	TextLabel2.TextColor3 = Color3.fromRGB(180, 180, 180)
	TextLabel2.Font = Enum.Font.SourceSansSemibold
	TextLabel2.TextSize = 16
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Right
	TextLabel2.Parent = Frame3

	local TextButton2 = Instance.new("TextButton")

	TextButton2.Size = UDim2.new(1, 0, 0, 34)
	TextButton2.BackgroundTransparency = 1
	TextButton2.Text = ""
	TextButton2.Parent = Frame3

	local Frame4 = Instance.new("Frame")

	Frame4.Size = UDim2.new(1, 0, 0, 0)
	Frame4.Position = UDim2.new(0, 0, 0, 34)
	Frame4.BackgroundTransparency = 0
	Frame4.BackgroundColor3 = Color3.fromRGB(22, 23, 26)
	Frame4.ClipsDescendants = true
	Frame4.Parent = Frame3

	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 4)
	UIListLayout.Parent = Frame4

	local UIPadding2 = Instance.new("UIPadding")

	UIPadding2.PaddingLeft = UDim.new(0, 8)
	UIPadding2.PaddingRight = UDim.new(0, 8)
	UIPadding2.PaddingTop = UDim.new(0, 6)
	UIPadding2.PaddingBottom = UDim.new(0, 6)
	UIPadding2.Parent = Frame4

	local function v347()
		if Multi then
			if #t9 == 0 then
				TextLabel2.Text = v326.Placeholder or "Select"
				TextLabel2.TextColor3 = Color3.fromRGB(180, 180, 180)

				return
			else
				TextLabel2.Text = string.format("%d selected", #t9)
				TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)

				return
			end
		end

		local v348 = u334
		local v349

		if not v348 then
			if v348 then
				v349 = u334
				TextLabel2.Text = tostring(v349)
				TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
			else
				TextLabel2.Text = v326.Placeholder or "Select"
				TextLabel2.TextColor3 = Color3.fromRGB(180, 180, 180)
			end

			return
		end

		v348 = u334 ~= ""

		if v348 then
			v349 = u334
			TextLabel2.Text = tostring(v349)
			TextLabel2.TextColor3 = Color3.fromRGB(255, 255, 255)
		else
			TextLabel2.Text = v326.Placeholder or "Select"
			TextLabel2.TextColor3 = Color3.fromRGB(180, 180, 180)
		end
	end

	local t10 = {}

	local function v351(p25, p26)
		local v352 = Multi

		if not v352 then
			if v352 or u334 == p26 then
				p25.BackgroundColor3 = Color3.fromRGB(153, 66, 66)
			else
				p25.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
			end

			return
		end

		v352 = table.find(t9, p26)

		if v352 or u334 == p26 then
			p25.BackgroundColor3 = Color3.fromRGB(153, 66, 66)
		else
			p25.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		end
	end

	local v353 = nil

	local function v354(p27)
		if Multi then
			local v355 = table.find(t9, p27)

			if v355 then
				table.remove(t9, v355)
			else
				local v356 = t9

				table.insert(v356, p27)
			end

			if v332 then
				v347()
			end

			Callback(table.clone(t9))
		else
			u334 = p27

			if v332 then
				v347()
			end

			Callback(p27)
			v353(false)
		end

		for _, v in pairs(t10) do
			v351(v.frame, v.text)
		end
	end

	v353 = function(p28)
		u333 = p28

		local v359 = #List * 32 + 12
		local v360 = u333

		if not v360 then
			t2.value4:Create(Frame2, TweenInfo.new(0.2), {
				Size = UDim2.new(1, 0, 0, v360 or 34)
			}):Play()
			v393 = t2.value4
			v394 = Frame4
			v395 = TweenInfo.new(0.2)
			v396 = {
				Size = UDim2.new(1, 0, 0, u333 and v359 and v359 or 0)
			}
			v393.Create(v393, v394, v395, v396):Play()

			return
		end

		v360 = 34 + v359
		t2.value4:Create(Frame2, TweenInfo.new(0.2), {
			Size = UDim2.new(1, 0, 0, v360 or 34)
		}):Play()

		local value4 = t2.value4
		local v362 = Frame4
		local tweenInfo = TweenInfo.new(0.2)
		local t11 = {
			Size = UDim2.new(1, 0, 0, u333 and v359 and v359 or 0)
		}

		value4.Create(value4, v362, tweenInfo, t11):Play()
	end

	local function v365(p29)
		local Frame5 = Instance.new("Frame")

		Frame5.Size = UDim2.new(1, 0, 0, 28)
		Frame5.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
		Frame5.BorderSizePixel = 0
		Frame5.Parent = Frame4

		local UICorner5 = Instance.new("UICorner")

		UICorner5.CornerRadius = UDim.new(0, 6)
		UICorner5.Parent = Frame5

		local TextLabel3 = Instance.new("TextLabel")

		TextLabel3.Size = UDim2.new(1, -10, 1, 0)
		TextLabel3.Position = UDim2.new(0, 10, 0, 0)
		TextLabel3.BackgroundTransparency = 1
		TextLabel3.Text = p29
		TextLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextLabel3.Font = Enum.Font.SourceSansSemibold
		TextLabel3.TextSize = 16
		TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
		TextLabel3.Parent = Frame5

		local TextButton3 = Instance.new("TextButton")

		TextButton3.Size = UDim2.new(1, 0, 1, 0)
		TextButton3.BackgroundTransparency = 1
		TextButton3.Text = ""
		TextButton3.Parent = Frame5
		TextButton3.MouseEnter:Connect(function()
			local v370 = Multi

			if v370 then
				v370 = table.find(t9, p29)
			end

			if v370 or u334 == p29 then
				return
			end

			Frame5.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
		end)

		local function v371()
			v351(Frame5, p29)
		end

		TextButton3.MouseLeave:Connect(v371)

		local function v372()
			v354(p29)
		end

		TextButton3.MouseButton1Click:Connect(v372)

		local v373 = t10

		table.insert(v373, {
			frame = Frame5,
			text = p29
		})
		v351(Frame5, p29)
	end

	for _, v in ipairs(List) do
		v365(v)
	end

	if Default == nil then
		v347()
	else
		if Multi then
			if typeof(Default) == "table" then
				t9 = table.clone(Default)
			else
				t9 = { Default }
			end
		else
			u334 = Default
		end

		v347()

		for _, v in pairs(t10) do
			v351(v.frame, v.text)
		end

		local v378

		if Multi then
			v378 = table.clone(t9)
		else
			v378 = Multi
		end

		Callback(v378 or u334)
	end

	TextButton2.MouseButton1Click:Connect(function()
		v353(not u333)
	end)

	return {
		Get = function(_)
			return Multi and table.clone(t9) or u334
		end,
		Clear = function(_)
			t9 = {}
			u334 = nil
			List = {}
			u333 = false

			for _, v in pairs(t10) do
				v.frame:Destroy()
			end

			t10 = {}
			v347()
			Frame2.Size = UDim2.new(1, 0, 0, 34)
			Frame4.Size = UDim2.new(1, 0, 0, 0)
		end,
		Add = function(_, p30)
			for _, v in ipairs(p30) do
				local v383 = List

				table.insert(v383, v)
				v365(v)
			end

			local v384 = #List * 32 + 12

			if not u333 then
				return
			end

			Frame2.Size = UDim2.new(1, 0, 0, v384 + 34)
			Frame4.Size = UDim2.new(1, 0, 0, v384)
		end
	}
end)({
	Text = "Select Interval",
	List = t1.value10,
	Default = "Infinite",
	Callback = t1.value12
})
v86()
createFrame("Auto Play")

function t2.value36(p31)
	if p31 then
		p31 = t2.value27.OriginalPosition
	end

	if not p31 then
		t2.value27.OriginalPosition = nil
		t2.value27.IsReviving = false

		return
	end

	local v385

	if t2.value2.Team then
		local Name = t2.value2.Team.Name

		if not Name then
			local Team = t2.value2.Team

			Name = tostring(Team)
		end

		v385 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or (Name == "Lobby" and "Lobby" or "None"))
	else
		v385 = "None"
	end

	local v388 = v385 == "Survivor"

	if v388 then
		v388 = v272(t2.value2)

		if v388 then
			v388 = not t2.value25.ExitsOpened
		end
	end

	if not v388 then
		t2.value27.OriginalPosition = nil
		t2.value27.IsReviving = false

		return
	end

	v277(t2.value27.OriginalPosition)
	t2.value27.OriginalPosition = nil
	t2.value27.IsReviving = false
end

t2.value37 = nil

local function v389()
	local v390

	if t2.value2.Team then
		local Name = t2.value2.Team.Name

		if not Name then
			local Team = t2.value2.Team

			Name = tostring(Team)
		end

		v390 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or (Name == "Lobby" and "Lobby" or "None"))
	else
		v390 = "None"
	end

	if v390 ~= "Survivor" then
		return
	end

	t2.value25.IsEscaping = true
	t2.value36(false)

	local Character = t2.value2.Character

	if Character then
		Character = Character:FindFirstChild("HumanoidRootPart")
	end

	local Exits = t2.value24()

	if Exits then
		Exits = Exits:FindFirstChild("Exits") or Exits:FindFirstChild("ExitGateways")
	end

	if not (Exits and Character) then
		t2.value25.IsEscaping = false
		task.wait(20)
		t2.value25.ExitsOpened = false

		return
	end

	local v397 = Exits.GetChildren(Exits)[1]
	local v398 = v397.FindFirstChild(v397, "Doorway")

	if not v398 then
		t2.value25.IsEscaping = false
		task.wait(20)
		t2.value25.ExitsOpened = false

		return
	end

	v277(v398.GetPivot(v398))
	task.wait(0.4)

	local BrightLight = v397:FindFirstChild("BrightLight", true)

	if not BrightLight then
		t2.value25.IsEscaping = false
		task.wait(20)
		t2.value25.ExitsOpened = false

		return
	end

	local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Linear)
	local value4 = t2.value4
	local t12 = {
		CFrame = BrightLight.CFrame
	}
	local v401 = value4.Create(value4, Character, tweenInfo, t12)

	v401.Play(v401)
	v401.Completed:Wait()
	t2.value25.IsEscaping = false
	task.wait(20)
	t2.value25.ExitsOpened = false
end

t2.value25.NotificationBanner.ChildAdded:Connect(function(child)
	local IsEnabled = t2.value25.IsEnabled

	if IsEnabled then
		IsEnabled = child.Name == "BannerNotification"

		if IsEnabled then
			if child.Text == "The exits are opening!" then
				local v403

				if t2.value2.Team then
					local Name = t2.value2.Team.Name

					if not Name then
						local Team = t2.value2.Team

						Name = tostring(Team)
					end

					v403 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or (Name == "Lobby" and "Lobby" or "None"))
				else
					v403 = "None"
				end

				IsEnabled = v403 == "Survivor"
			else
				IsEnabled = false
			end
		end
	end

	if not IsEnabled then
		return
	end

	t2.value25.ExitsOpened = true
	task.wait(2)
	v389()
end)

function t1.value15(p32)
	t2.value25.IsEnabled = p32
end
function t1.value12(p33)
	t2.value27.IsEnabled = p33

	if p33 then
		t2.value37()

		return
	end

	t2.value36(false)
	t2.value37()
end

v211("Auto Escape", t1.value15)

function t2.value38()
	local v406 = not t2.value26.IsEnabled

	if not v406 then
		local v407

		if t2.value2.Team then
			local Name = t2.value2.Team.Name

			if not Name then
				local Team = t2.value2.Team

				Name = tostring(Team)
			end

			v407 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or (Name == "Lobby" and "Lobby" or "None"))
		else
			v407 = "None"
		end

		v406 = v407 ~= "Survivor" or (t2.value25.ExitsOpened or not v272(t2.value2))
	end

	if v406 then
		if not t2.value26.IsSaving then
			return
		end

		local v410

		if t2.value2.Team then
			local Name = t2.value2.Team.Name

			if not Name then
				local Team = t2.value2.Team

				Name = tostring(Team)
			end

			v410 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or (Name == "Lobby" and "Lobby" or "None"))
		else
			v410 = "None"
		end

		local v413 = v410 == "Survivor"

		if v413 then
			v413 = t2.value26.OriginalPosition

			if v413 then
				v413 = v272(t2.value2)
			end
		end

		if v413 then
			v277(t2.value26.OriginalPosition)
		end

		t2.value26.OriginalPosition = nil
		t2.value26.IsSaving = false

		return
	end

	if t2.value29.IsLooting then
		return
	end

	local Character = t2.value2.Character

	if Character then
		Character = Character:FindFirstChild("HumanoidRootPart")
	end

	if not Character then
		return
	end

	local v415 = v281()
	local v416 = v284()
	local Character2

	if v416 then
		Character2 = v416.Character

		if Character2 then
			Character2 = v416.Character:FindFirstChild("HumanoidRootPart")
		end
	else
		Character2 = v416
	end

	if Character2 and v415 then
		if t2.value26.IsSaving then
			if t2.value26.OriginalPosition then
				local Position = t2.value26.OriginalPosition.Position

				if not ((Vector3.new(Character2.Position.X, 0, Character2.Position.Z) - Vector3.new(Position.X, 0, Position.Z)).Magnitude >= t2.value26.SafeDistance) then
					return
				end

				local v419 = false
				local v420

				if t2.value2.Team then
					local Name = t2.value2.Team.Name

					if not Name then
						local Team = t2.value2.Team

						Name = tostring(Team)
					end

					v420 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or (Name == "Lobby" and "Lobby" or "None"))
				else
					v420 = "None"
				end

				if v420 == "Survivor" then
					v419 = v272(t2.value2)
				end

				if not v419 then
					t2.value26.OriginalPosition = nil
					t2.value26.IsSaving = false

					return
				end

				v277(t2.value26.OriginalPosition)
				t2.value26.OriginalPosition = nil
				t2.value26.IsSaving = false

				return
			else
				t2.value26.IsSaving = false

				return
			end
		else
			local Position = Character.Position
			local Magnitude = (Vector3.new(Character2.Position.X, 0, Character2.Position.Z) - Vector3.new(Position.X, 0, Position.Z)).Magnitude
			local v425 = math.abs(Character2.Position.Y - Position.Y)
			local v426 = Magnitude <= t2.value26.DangerDistance
			local CFrame_

			if v426 then
			elseif v426 then
				CFrame_ = Character.CFrame
				t2.value26.OriginalPosition = CFrame_
				t2.value26.IsSaving = true
				v277(v415)

				return
			else
				return
			end

			if v425 <= 25 then
				v426 = not t2.value2:GetAttribute("Downed")
			else
				v426 = false
			end

			if v426 then
				CFrame_ = Character.CFrame
				t2.value26.OriginalPosition = CFrame_
				t2.value26.IsSaving = true
				v277(v415)

				return
			else
				return
			end
		end
	else
		if not t2.value26.IsSaving then
			return
		end

		local OriginalPosition = t2.value26.OriginalPosition

		if OriginalPosition then
			OriginalPosition = false

			local v429

			if t2.value2.Team then
				local Name = t2.value2.Team.Name

				if not Name then
					local Team = t2.value2.Team

					Name = tostring(Team)
				end

				v429 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or (Name == "Lobby" and "Lobby" or "None"))
			else
				v429 = "None"
			end

			if v429 == "Survivor" then
				OriginalPosition = v272(t2.value2)
			end
		end

		if OriginalPosition then
			v277(t2.value26.OriginalPosition)
		end

		t2.value26.OriginalPosition = nil
		t2.value26.IsSaving = false
	end
end

local function v432()
	local value262

	if t2.value26.LoopThread then
		task.cancel(t2.value26.LoopThread)
		value262 = t2.value26
		value262.LoopThread = nil
	else
		value262 = 8006514
	end

	if t2.value26.IsEnabled then
		t2.value26.LoopThread = task.spawn(function()
			while t2.value26.IsEnabled do
				local v434 = false
				local v435

				if t2.value2.Team then
					local Name = t2.value2.Team.Name

					if not Name then
						local Team = t2.value2.Team

						Name = tostring(Team)
					end

					v435 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or (Name == "Lobby" and "Lobby" or "None"))
				else
					v435 = "None"
				end

				if v435 == "Survivor" then
					v434 = not t2.value25.ExitsOpened
				end

				if v434 then
					t2.value38()
					task.wait(0.1)
				else
					t2.value26.IsSaving = false
					t2.value26.OriginalPosition = nil
					task.wait(1)
				end
			end
		end)

		return
	end

	local IsSaving = t2.value26.IsSaving

	if IsSaving then
		IsSaving = t2.value26.OriginalPosition

		if IsSaving then
			IsSaving = false

			local v439

			if t2.value2.Team then
				local Name = t2.value2.Team.Name

				if not Name then
					local Team = t2.value2.Team

					Name = tostring(Team)
				end

				v439 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or (Name == "Lobby" and "Lobby" or "None"))
			else
				v439 = "None"
			end

			if v439 == "Survivor" then
				IsSaving = v272(t2.value2)
			end
		end
	end

	if not IsSaving then
		t2.value26.OriginalPosition = nil
		t2.value26.IsSaving = false

		return
	end

	v277(t2.value26.OriginalPosition)
	t2.value26.OriginalPosition = nil
	t2.value26.IsSaving = false
end

v211("Auto Save", function(p34)
	t2.value26.IsEnabled = p34
	v432()
end)

function t2.value39()
	local ipairs_ = ipairs
	local value19 = t2.value1

	for _, player in ipairs_(value19.GetPlayers(value19)) do
		local Team = player.Team

		if Team then
			Team = player.Team.Name == "Survivor"
		end

		if not Team then
			local Team2 = player.Team

			Team = tostring(Team2) == "Survivor"
		end

		local v448 = player ~= t2.value2

		if v448 then
			if Team then
				Team = player:GetAttribute("Downed") == true

				if Team then
					if player.GetAttribute(player, "Dead") == true then
						Team = false
					else
						Team = player:GetAttribute("HeldByPlayer") ~= true
					end
				end
			end
		else
			Team = v448
		end

		if Team then
			ipairs_ = player.Character

			local HumanoidRootPart

			if ipairs_ then
				HumanoidRootPart = ipairs_:FindFirstChild("HumanoidRootPart")
			else
				HumanoidRootPart = ipairs_
			end

			if HumanoidRootPart then
				return player
			end
		end
	end

	return nil
end
function t2.value40()
	local v450

	if t2.value2.Team then
		local Name = t2.value2.Team.Name

		if not Name then
			local Team = t2.value2.Team

			Name = tostring(Team)
		end

		v450 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or (Name == "Lobby" and "Lobby" or "None"))
	else
		v450 = "None"
	end

	if v450 ~= "Survivor" or (t2.value25.ExitsOpened or (not v272(t2.value2) or t2.value26.IsSaving)) then
		return
	end

	local Character = t2.value2.Character

	if Character then
		Character = Character:FindFirstChild("HumanoidRootPart")
	end

	if not Character then
		return
	end

	local v454 = t2.value39()

	if not v454 then
		return
	end

	local Character2 = v454.Character

	if Character2 then
		Character2 = v454.Character:FindFirstChild("HumanoidRootPart")
	end

	if not Character2 then
		return
	end

	t2.value27.IsReviving = true

	local CFrame_ = Character.CFrame

	t2.value27.OriginalPosition = CFrame_

	local v457 = true

	while true do
		local IsEnabled = t2.value27.IsEnabled

		if IsEnabled then
			IsEnabled = not t2.value25.ExitsOpened
		end

		if not IsEnabled then
			t2.value36(v457)

			return
		end

		local v459

		if t2.value2.Team then
			local Name = t2.value2.Team.Name

			if not Name then
				local Team = t2.value2.Team

				Name = tostring(Team)
			end

			v459 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or (Name == "Lobby" and "Lobby" or "None"))
		else
			v459 = "None"
		end

		if v459 ~= "Survivor" or (not v272(t2.value2) or t2.value26.IsSaving) then
			break
		end

		local Character3 = v454.Character

		if Character3 then
			Character3 = v454.Character:FindFirstChild("HumanoidRootPart")
		end

		if v454:GetAttribute("Downed") ~= true and true or not Character3 then
			t2.value36(v457)

			return
		end

		local v463 = v284()
		local Character4

		if v463 then
			Character4 = v463.Character

			if Character4 then
				Character4 = v463.Character:FindFirstChild("HumanoidRootPart")
			end
		else
			Character4 = v463
		end

		local v465 = false

		if Character4 then
			local Magnitude = (Vector3.new(Character4.Position.X, 0, Character4.Position.Z) - Vector3.new(Character3.Position.X, 0, Character3.Position.Z)).Magnitude
			local v467 = Character4.Position.Y - Character3.Position.Y
			local v468 = math.abs(v467)
			local v469

			if Magnitude < t2.value27.SafeDistance then
				v469 = v468 <= 25
			else
				v469 = false
			end

			v465 = v469 and true or v465
		end

		if v465 then
			t2.value36(true)
			task.wait(1.5)

			return
		end

		local Character5 = t2.value2.Character

		if Character5 then
			Character5 = t2.value2.Character:FindFirstChild("HumanoidRootPart")
		end

		if Character5 and (Character5.Position - Character3.Position).Magnitude > 6 then
			v277(Character3.CFrame * CFrame.new(0, 0, 2))
		end

		task.wait(0.2)
	end

	v457 = false
	t2.value36(v457)
end
function t2.value37()
	if t2.value27.LoopThread then
		task.cancel(t2.value27.LoopThread)
		t2.value27.LoopThread = nil
	end

	if not t2.value27.IsEnabled then
		t2.value36(true)

		return
	end

	t2.value27.LoopThread = task.spawn(function()
		local n5 = 2976116

		while t2.value27.IsEnabled do
			local v472

			if t2.value2.Team then
				local Name = t2.value2.Team.Name

				if not Name then
					local Team = t2.value2.Team

					Name = tostring(Team)
				end

				v472 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or (Name == "Lobby" and "Lobby" or "None"))
			else
				v472 = "None"
			end

			local v475 = v472 == "Survivor"

			if v475 then
				v475 = not t2.value25.ExitsOpened

				if v475 then
					v475 = v272(t2.value2)
				end
			end

			if v475 then
				if not t2.value26.IsSaving then
					t2.value40()
				end

				n5 = task.wait
				n5(0.5)
			else
				n5 = task.wait
				n5(1)
			end
		end
	end)
end

v211("Auto Revive", t1.value12)

local function v476()
	local ipairs_ = ipairs
	local value19 = t2.value1

	for _, player in ipairs_(value19.GetPlayers(value19)) do
		local v481

		if player.Team and player.Team.Name == "Survivor" then
			v481 = true
		else
			local Team = player.Team

			v481 = tostring(Team) == "Survivor"
		end

		local v483 = player ~= t2.value2

		if v483 then
			if v481 then
				v481 = v272(player)
			end
		else
			v481 = v483
		end

		if v481 then
			ipairs_ = player.Character

			local HumanoidRootPart

			if ipairs_ then
				HumanoidRootPart = ipairs_:FindFirstChild("HumanoidRootPart")
			else
				HumanoidRootPart = ipairs_
			end

			if HumanoidRootPart then
				return player
			end
		end
	end

	return nil
end
local function v485()
	local v486

	if t2.value2.Team then
		local Name = t2.value2.Team.Name

		if not Name then
			local Team = t2.value2.Team

			Name = tostring(Team)
		end

		v486 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or (Name == "Lobby" and "Lobby" or "None"))
	else
		v486 = "None"
	end

	if v486 ~= "Survivor" or (t2.value25.ExitsOpened or t2.value2:GetAttribute("Downed") ~= true) then
		t2.value28.IsGettingRevived = false

		return
	end

	local v489 = v476()

	if not v489 then
		t2.value28.IsGettingRevived = false

		return
	end

	t2.value28.IsGettingRevived = true

	while true do
		local IsEnabled = t2.value28.IsEnabled

		if IsEnabled then
			IsEnabled = t2.value2:GetAttribute("Downed") == true
		end

		if not IsEnabled then
			t2.value28.IsGettingRevived = false

			return
		end

		local v491

		if t2.value2.Team then
			local Name = t2.value2.Team.Name

			if not Name then
				local Team = t2.value2.Team

				Name = tostring(Team)
			end

			v491 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or (Name == "Lobby" and "Lobby" or "None"))
		else
			v491 = "None"
		end

		if v491 ~= "Survivor" or (t2.value25.ExitsOpened or t2.value26.IsSaving) then
			t2.value28.IsGettingRevived = false

			return
		end

		local Character = t2.value2.Character

		if Character then
			Character = t2.value2.Character:FindFirstChild("HumanoidRootPart")
		end

		local Character2 = v489.Character

		if Character2 then
			Character2 = v489.Character:FindFirstChild("HumanoidRootPart")
		end

		if not (Character and (Character2 and v272(v489))) then
			t2.value28.IsGettingRevived = false

			return
		end

		Character.CFrame = Character2.CFrame * CFrame.new(0, 0, 1)
		task.wait(0.1)
	end
end

function t2.value5()
	if t2.value28.LoopThread then
		task.cancel(t2.value28.LoopThread)
		t2.value28.LoopThread = nil
	end

	if not t2.value28.IsEnabled then
		t2.value28.IsGettingRevived = false

		return
	end

	t2.value28.LoopThread = task.spawn(function()
		while t2.value28.IsEnabled do
			local v496 = false
			local v497

			if t2.value2.Team then
				local Name = t2.value2.Team.Name

				if not Name then
					local Team = t2.value2.Team

					Name = tostring(Team)
				end

				v497 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or (Name == "Lobby" and "Lobby" or "None"))
			else
				v497 = "None"
			end

			if v497 == "Survivor" then
				v496 = not t2.value25.ExitsOpened
			end

			if v496 then
				local v500

				if t2.value2:GetAttribute("Downed") == true then
					v500 = not t2.value26.IsSaving
				else
					v500 = false
				end

				if v500 then
					v485()
				end

				task.wait(0.2)
			else
				task.wait(1)
			end
		end
	end)
end

v211("Auto Self Revive", function(p35)
	t2.value28.IsEnabled = p35
	t2.value5()
end)
v86()
createFrame("Anti Traps")
v211("No Rat Traps (Space Lab)", function(p36)
	t2.value30.IsEnabled = p36

	if not p36 then
		return
	end

	task.spawn(function()
		while t2.value30.IsEnabled do
			local v501

			if t2.value2.Team then
				local Name = t2.value2.Team.Name

				if not Name then
					local Team = t2.value2.Team

					Name = tostring(Team)
				end

				v501 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or (Name == "Lobby" and "Lobby" or "None"))
			else
				v501 = "None"
			end

			if v501 == "Survivor" then
				local RatTraps = t2.value24()

				if RatTraps then
					RatTraps = RatTraps:FindFirstChild("RatTraps")
				end

				if RatTraps then
					RatTraps:Destroy()
				end
			end

			task.wait(0.5)
		end
	end)
end)
v211("No Killer Traps", function(p37)
	t2.value31.IsEnabled = p37

	if not p37 then
		return
	end

	task.spawn(function()
		while t2.value31.IsEnabled do
			local v505

			if t2.value2.Team then
				local Name = t2.value2.Team.Name

				if not Name then
					local Team = t2.value2.Team

					Name = tostring(Team)
				end

				v505 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or (Name == "Lobby" and "Lobby" or "None"))
			else
				v505 = "None"
			end

			local Trap = v505 == "Survivor" and workspace:FindFirstChild("Trap")

			if Trap then
				Trap:Destroy()
			end

			task.wait(0.5)
		end
	end)
end)
v86()
createTextLabel("Killer")
createFrame()

local function v509()
	local ipairs_ = ipairs
	local value19 = t2.value1

	for _, player in ipairs_(value19.GetPlayers(value19)) do
		if player ~= t2.value2 then
			local Character = player.Character or workspace:FindFirstChild(player.Name)

			if Character then
				Character = Character:FindFirstChild("HumanoidRootPart")
			end

			local isBasePart

			if Character then
				isBasePart = Character:IsA("BasePart")
			else
				isBasePart = Character
			end

			if isBasePart then
				Character.Size = t2.value32.DefaultSize
				Character.CanCollide = true
			end
		end
	end
end

function t2.value14()
	if t2.value32.LoopThread then
		task.cancel(t2.value32.LoopThread)
		t2.value32.LoopThread = nil
	end

	if not t2.value32.IsEnabled then
		v509()

		return
	end

	t2.value32.LoopThread = task.spawn(function()
		while true do
			while true do
				if not t2.value32.IsEnabled then
					v509()

					return
				end

				local v516

				if t2.value2.Team then
					local Name = t2.value2.Team.Name

					if not Name then
						local Team = t2.value2.Team

						Name = tostring(Team)
					end

					v516 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or (Name == "Lobby" and "Lobby" or "None"))
				else
					v516 = "None"
				end

				if v516 ~= "Killer" then
					break
				end

				local ipairs_ = ipairs
				local value19 = t2.value1

				for _, player in ipairs_(value19.GetPlayers(value19)) do
					local v523 = not t2.value32.IsEnabled

					if not v523 then
						local v524

						if t2.value2.Team then
							local Name = t2.value2.Team.Name

							if not Name then
								local Team = t2.value2.Team

								Name = tostring(Team)
							end

							v524 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or (Name == "Lobby" and "Lobby" or "None"))
						else
							v524 = "None"
						end

						v523 = v524 ~= "Killer"
					end

					if v523 then
						break
					end

					if player ~= t2.value2 then
						local Character = player.Character or workspace:FindFirstChild(player.Name)
						local HumanoidRootPart

						if Character then
							HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
						else
							HumanoidRootPart = Character
						end

						if Character then
							Character = Character:FindFirstChildOfClass("Humanoid")
						end

						local isBasePart

						if HumanoidRootPart then
							isBasePart = HumanoidRootPart:IsA("BasePart")

							if isBasePart then
								isBasePart = not Character or Character.Health > 0
							end
						else
							isBasePart = HumanoidRootPart
						end

						if isBasePart then
							HumanoidRootPart.Size = t2.value32.RageSize
							HumanoidRootPart.CanCollide = false
							task.wait(t2.value32.HitDuration)
							HumanoidRootPart.Size = t2.value32.DefaultSize
							HumanoidRootPart.CanCollide = true
							ipairs_ = task.wait
							ipairs_(t2.value32.NextTargetDelay)
						end
					end
				end

				task.wait(t2.value32.LoopDelay)
			end

			v509()
			task.wait(0.5)
		end
	end)
end

v211("Kill Aura", function(p38)
	t2.value32.IsEnabled = p38
	t2.value14()
end)
v86()
createTextLabel("Other")
createFrame("Render")
createFrame3("No Fog", function()
	for _, v in ipairs({
		"Blur",
		"ColorCorrection",
		"ScreenTint",
		"Ghostly Night"
	}) do
		local v532 = t2.value8:FindFirstChild(v)

		if v532 then
			v532:Remove()
		end
	end

	t2.value8:GetPropertyChangedSignal("FogEnd"):Connect(function()
		if t2.value8.FogEnd == 5000 then
			return
		end

		t2.value8.FogEnd = 5000
	end)
	t2.value7.RenderStepped:Connect(function()
		t2.value8.FogEnd = 5000
	end)
end)
createFrame3("Fullbright", function()
	t2.value8.Brightness = 0.5
	t2.value8.GlobalShadows = false
end)
v86()
createFrame("Gamepasses")
t2.value41 = {
	settings = t2.value2:FindFirstChild("Settings")
}
v211("Double Jump", function(p39)
	if not t2.value41.settings then
		return
	end

	t2.value41.settings:SetAttribute("double_jump", p39)
end)
v211("3x Killer Chance", function(p40)
	if not t2.value41.settings then
		return
	end

	t2.value41.settings:SetAttribute("killer_chance_3x", p40)
end)
t1.value1 = "Movement"
v86()
createFrame2("Movement", "rbxassetid://104433470689984")
t1.value1 = "Movement"
t1.value9("Movement")
t2.value18("Movement")
t1.value1 = "Speed"
createFrame("Speed")
t2.value42 = {
	SpeedHumanoid = nil,
	SpeedRootPart = t1.value17,
	SpeedIsEnabled = false,
	SpeedValue = 16,
	SpeedStopCallback = nil
}

function t2.value43()
	local connection = nil

	local function v534()
		connection:Disconnect()
	end

	connection = t2.value7.Heartbeat:Connect(function()
		if not (t2.value42.SpeedRootPart and t2.value42.SpeedRootPart.Parent) then
			return
		end

		if not t2.value42.SpeedIsEnabled then
			return
		end

		if not t2.value42.SpeedHumanoid then
			return
		end

		local MoveDirection = t2.value42.SpeedHumanoid.MoveDirection

		if MoveDirection.Magnitude > 0 then
			t2.value42.SpeedRootPart.AssemblyLinearVelocity = Vector3.new(MoveDirection.X * t2.value42.SpeedValue, t2.value42.SpeedRootPart.AssemblyLinearVelocity.Y, MoveDirection.Z * t2.value42.SpeedValue)

			return
		end

		t2.value42.SpeedRootPart.AssemblyLinearVelocity = Vector3.new(0, t2.value42.SpeedRootPart.AssemblyLinearVelocity.Y, 0)
	end)

	return v534
end

t1.value1 = t2.value2

function t1.value17(p41)
	t2.value42.SpeedHumanoid = p41:WaitForChild("Humanoid")
	t2.value42.SpeedRootPart = p41:WaitForChild("HumanoidRootPart")

	if not t2.value42.SpeedIsEnabled then
		return
	end

	if t2.value42.SpeedStopCallback then
		t2.value42.SpeedStopCallback()
	end

	t2.value42.SpeedStopCallback = t2.value43()
end

if t1.value1.Character then
	task.spawn(t1.value17, t2.value2.Character)
end

t2.value2.CharacterAdded:Connect(t1.value17)
t1.value17 = "Min"
v211("Enable", function(p42)
	if t2.value42.SpeedIsEnabled == p42 then
		return
	end

	t2.value42.SpeedIsEnabled = p42

	if t2.value42.SpeedStopCallback then
		t2.value42.SpeedStopCallback()
		t2.value42.SpeedStopCallback = nil
	end

	if not t2.value42.SpeedIsEnabled then
		return
	end

	t2.value42.SpeedStopCallback = t2.value43()
end)
v233({
	Text = "Speed",
	Min = 16,
	Max = 300,
	Default = t2.value42.SpeedValue,
	Callback = function(p43)
		t2.value42.SpeedValue = p43
	end
})
v86()
t1.value1 = "Fly"
createFrame("Fly")
t1.value17 = nil
t1.value1 = "FlyCharacter"
t2.value44 = {
	FlyCharacter = nil,
	FlyRootPart = t1.value17,
	FlyHumanoid = nil,
	FlyIsEnabled = false,
	FlySpeed = 16,
	FlyStopCallback = nil
}

function t2.value45()
	local BodyVelocity = Instance.new("BodyVelocity")

	BodyVelocity.MaxForce = Vector3.new(400000, 400000, 400000)
	BodyVelocity.Velocity = Vector3.new(0, 0, 0)
	BodyVelocity.P = 1250
	BodyVelocity.Parent = t2.value44.FlyRootPart

	local connection = nil

	local function v538()
		connection:Disconnect()
		BodyVelocity:Destroy()
	end

	connection = t2.value7.Heartbeat:Connect(function()
		if not (t2.value44.FlyRootPart and (t2.value44.FlyRootPart.Parent and t2.value44.FlyHumanoid)) then
			BodyVelocity.Velocity = Vector3.zero

			return
		end

		if not t2.value44.FlyIsEnabled then
			BodyVelocity.Velocity = Vector3.zero

			return
		end

		local MoveDirection = t2.value44.FlyHumanoid.MoveDirection

		if not (MoveDirection.Magnitude > 0) then
			BodyVelocity.Velocity = Vector3.zero

			return
		end

		local LookVector = workspace.CurrentCamera.CFrame.LookVector
		local vector3 = Vector3.new(LookVector.X, 0, LookVector.Z)

		if not (vector3.Magnitude > 0) then
			v581 = vector3:Dot(MoveDirection)
			BodyVelocity.Velocity = MoveDirection * t2.value44.FlySpeed + Vector3.new(0, LookVector.Y * v581 * t2.value44.FlySpeed, 0)

			return
		end

		vector3 = vector3.Unit

		local v542 = vector3:Dot(MoveDirection)

		BodyVelocity.Velocity = MoveDirection * t2.value44.FlySpeed + Vector3.new(0, LookVector.Y * v542 * t2.value44.FlySpeed, 0)
	end)

	return v538
end

t1.value1 = t2.value2

function t1.value17(p44)
	t2.value44.FlyCharacter = p44

	local WaitForChild2 = p44.WaitForChild

	t2.value44.FlyRootPart = WaitForChild2(p44, "HumanoidRootPart")

	local WaitForChild3 = p44.WaitForChild

	t2.value44.FlyHumanoid = WaitForChild3(p44, "Humanoid")

	if not t2.value44.FlyIsEnabled then
		return
	end

	if t2.value44.FlyStopCallback then
		t2.value44.FlyStopCallback()
	end

	t2.value44.FlyStopCallback = t2.value45()
end

if t1.value1.Character then
	task.spawn(t1.value17, t2.value2.Character)
end

t1.value26 = "Fly Speed"
t1.value28 = "Min"
t1.value27 = "CharacterAdded"
t2.value2.CharacterAdded:Connect(t1.value17)
v211("Enable", function(p45)
	if t2.value44.FlyIsEnabled == p45 then
		return
	end

	t2.value44.FlyIsEnabled = p45

	if t2.value44.FlyStopCallback then
		t2.value44.FlyStopCallback()
		t2.value44.FlyStopCallback = nil
	end

	if not t2.value44.FlyIsEnabled then
		return
	end

	t2.value44.FlyStopCallback = t2.value45()
end)
v233({
	Text = "Fly Speed",
	Min = 16,
	Max = 300,
	Default = t2.value44.FlySpeed,
	Decimals = 1,
	Callback = function(p46)
		t2.value44.FlySpeed = p46
	end
})
v86()
createFrame()
t2.value46 = {
	InfJumpCharacter = nil,
	InfJumpHumanoid = nil,
	InfJumpIsEnabled = false,
	InfJumpStopCallback = nil
}
t1.value1 = t2.value2

function t1.value28(p47)
	t2.value46.InfJumpCharacter = p47
	t2.value46.InfJumpHumanoid = p47:WaitForChild("Humanoid")

	if not t2.value46.InfJumpIsEnabled then
		return
	end

	if t2.value46.InfJumpStopCallback then
		t2.value46.InfJumpStopCallback()
	end

	local value46 = t2.value46
	local connection = t2.value3.JumpRequest:Connect(function()
		if not (t2.value46.InfJumpCharacter and t2.value46.InfJumpCharacter.Parent) then
			return
		end

		local InfJumpIsEnabled = t2.value46.InfJumpIsEnabled

		if InfJumpIsEnabled then
			InfJumpIsEnabled = t2.value46.InfJumpHumanoid
		end

		if not InfJumpIsEnabled then
			return
		end

		t2.value46.InfJumpHumanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end)

	function value46.InfJumpStopCallback()
		connection:Disconnect()
	end
end

if t1.value1.Character then
	task.spawn(t1.value28, t2.value2.Character)
end

t1.value17 = false
t1.value29 = "CharacterAdded"

local CharacterAdded = t2.value2.CharacterAdded

t1.value1 = "Connect"

function t1.value29(p48)
	if t2.value46.InfJumpIsEnabled == p48 then
		return
	end

	t2.value46.InfJumpIsEnabled = p48

	if t2.value46.InfJumpStopCallback then
		t2.value46.InfJumpStopCallback()
		t2.value46.InfJumpStopCallback = nil
	end

	if not t2.value46.InfJumpIsEnabled then
		return
	end

	local value46 = t2.value46
	local connection = t2.value3.JumpRequest:Connect(function()
		if not (t2.value46.InfJumpCharacter and t2.value46.InfJumpCharacter.Parent) then
			return
		end

		local InfJumpIsEnabled = t2.value46.InfJumpIsEnabled

		if InfJumpIsEnabled then
			InfJumpIsEnabled = t2.value46.InfJumpHumanoid
		end

		if not InfJumpIsEnabled then
			return
		end

		t2.value46.InfJumpHumanoid:ChangeState(Enum.HumanoidStateType.Jumping)
	end)

	function value46.InfJumpStopCallback()
		connection:Disconnect()
	end
end

CharacterAdded:Connect(t1.value28)
v211("Infinite Jump", t1.value29)
v86()
t1.value1 = "NoclipCharacter"
t1.value29 = nil
createFrame()
t2.value47 = {
	NoclipCharacter = t1.value29,
	NoclipIsEnabled = t1.value17,
	NoclipStopCallback = nil,
	NoclipParts = {},
	NoclipOriginalCanCollide = {},
	NoclipDescendantConnection = nil
}

function t2.value48()
	table.clear(t2.value47.NoclipParts)

	if t2.value47.NoclipCharacter then
		table.clear(t2.value47.NoclipOriginalCanCollide)

		local ipairs_ = ipairs
		local NoclipCharacter = t2.value47.NoclipCharacter

		for _, descendant in ipairs_(NoclipCharacter.GetDescendants(NoclipCharacter)) do
			if descendant:IsA("BasePart") then
				local NoclipParts = t2.value47.NoclipParts

				table.insert(NoclipParts, descendant)
				t2.value47.NoclipOriginalCanCollide[descendant] = descendant.CanCollide
			end
		end
	end
end

t1.value1 = t2.value2

local function v557(character)
	t2.value47.NoclipCharacter = character
	t2.value48()

	if t2.value47.NoclipDescendantConnection then
		t2.value47.NoclipDescendantConnection:Disconnect()
	end

	if t2.value47.NoclipRemovingConnection then
		t2.value47.NoclipRemovingConnection:Disconnect()
	end

	t2.value47.NoclipDescendantConnection = character.DescendantAdded:Connect(function(descendant)
		if not descendant.IsA(descendant, "BasePart") then
			return
		end

		local NoclipParts = t2.value47.NoclipParts

		table.insert(NoclipParts, descendant)
		t2.value47.NoclipOriginalCanCollide[descendant] = descendant.CanCollide
	end)

	local function v559(descendant)
		if not descendant:IsA("BasePart") then
			return
		end

		local v560 = table.find(t2.value47.NoclipParts, descendant)

		if not v560 then
			t2.value47.NoclipOriginalCanCollide[descendant] = nil

			return
		end

		table.remove(t2.value47.NoclipParts, v560)
		t2.value47.NoclipOriginalCanCollide[descendant] = nil
	end

	t2.value47.NoclipRemovingConnection = character.DescendantRemoving:Connect(v559)

	if not t2.value47.NoclipIsEnabled then
		return
	end

	if t2.value47.NoclipStopCallback then
		t2.value47.NoclipStopCallback()
	end

	local value47 = t2.value47
	local connection = t2.value7.Stepped:Connect(function()
		if not (t2.value47.NoclipCharacter and t2.value47.NoclipCharacter.Parent) then
			return
		end

		if not t2.value47.NoclipIsEnabled then
			return
		end

		for _, noclipPart in ipairs(t2.value47.NoclipParts) do
			noclipPart.CanCollide = false
		end
	end)

	function value47.NoclipStopCallback()
		connection:Disconnect()

		local NoclipCharacter = t2.value47.NoclipCharacter

		if NoclipCharacter then
			NoclipCharacter = t2.value47.NoclipCharacter.Parent
		end

		if not NoclipCharacter then
			return
		end

		for _, noclipPart in ipairs(t2.value47.NoclipParts) do
			local Parent

			if noclipPart then
				Parent = noclipPart.Parent
			else
				Parent = noclipPart
			end

			if Parent then
				local v569 = t2.value47.NoclipOriginalCanCollide[noclipPart]

				if v569 ~= nil then
					noclipPart.CanCollide = v569
				end
			end
		end
	end
end

if t1.value1.Character then
	task.spawn(v557, t2.value2.Character)
end

t2.value2.CharacterAdded:Connect(v557)
v211("Noclip", function(p49)
	if t2.value47.NoclipIsEnabled == p49 then
		return
	end

	t2.value47.NoclipIsEnabled = p49

	if t2.value47.NoclipStopCallback then
		t2.value47.NoclipStopCallback()
		t2.value47.NoclipStopCallback = nil
	end

	if not t2.value47.NoclipIsEnabled then
		return
	end

	local value47 = t2.value47
	local connection = t2.value7.Stepped:Connect(function()
		if not (t2.value47.NoclipCharacter and t2.value47.NoclipCharacter.Parent) then
			return
		end

		if not t2.value47.NoclipIsEnabled then
			return
		end

		for _, noclipPart in ipairs(t2.value47.NoclipParts) do
			noclipPart.CanCollide = false
		end
	end)

	function value47.NoclipStopCallback()
		connection:Disconnect()

		local NoclipCharacter = t2.value47.NoclipCharacter

		if NoclipCharacter then
			NoclipCharacter = t2.value47.NoclipCharacter.Parent
		end

		if not NoclipCharacter then
			return
		end

		for _, noclipPart in ipairs(t2.value47.NoclipParts) do
			local Parent

			if noclipPart then
				Parent = noclipPart.Parent
			else
				Parent = noclipPart
			end

			if Parent then
				local v578 = t2.value47.NoclipOriginalCanCollide[noclipPart]

				if v578 ~= nil then
					noclipPart.CanCollide = v578
				end
			end
		end
	end
end)
v86()
createFrame2("Esp", "rbxassetid://92867222908387")
t1.value9("Esp")
t2.value18("Esp")
createFrame("Player ESP")
t2.value49 = {
	IsEnabled = false,
	IsChamsEnabled = false,
	IsLivesEnabled = false,
	IsNameEnabled = false,
	IsDistanceEnabled = false,
	MaxDistance = 2000,
	TeamColor = true
}

function t2.value50(p50)
	if p50.Team then
		return p50.TeamColor.Color
	else
		return Color3.fromRGB(255, 255, 255)
	end
end

local function v579()
	local ipairs_ = ipairs
	local value19 = t2.value1

	for _, player in ipairs_(value19.GetPlayers(value19)) do
		if player.Character then
			local PlayerESP_Highlight = player.Character:FindFirstChild("PlayerESP_Highlight")

			if PlayerESP_Highlight then
				PlayerESP_Highlight:Destroy()
			end

			local HumanoidRootPart = player.Character:FindFirstChild("HumanoidRootPart")

			if HumanoidRootPart then
				local PlayerESP_Billboard = HumanoidRootPart:FindFirstChild("PlayerESP_Billboard")

				if PlayerESP_Billboard then
					PlayerESP_Billboard:Destroy()
				end
			end
		end
	end
end

function t2.value51(p51)
	local v587 = t2.value50(p51)
	local Character = p51.Character

	if not Character then
		return
	end

	local HumanoidRootPart = Character:FindFirstChild("HumanoidRootPart")
	local Humanoid = Character:FindFirstChild("Humanoid")

	if not (HumanoidRootPart and Humanoid) then
		return
	end

	if t2.value49.IsNameEnabled then
		Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.None
	else
		Humanoid.DisplayDistanceType = Enum.HumanoidDisplayDistanceType.Viewer
	end

	local Highlight = Instance.new("Highlight")

	Highlight.Name = "PlayerESP_Highlight"
	Highlight.FillColor = v587
	Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	Highlight.FillTransparency = t2.value49.IsChamsEnabled and 0.5 or 1
	Highlight.Parent = Character

	local BillboardGui = Instance.new("BillboardGui")

	BillboardGui.Name = "PlayerESP_Billboard"
	BillboardGui.Size = UDim2.new(0, 200, 0, 70)
	BillboardGui.StudsOffset = Vector3.new(0, 6, 0)
	BillboardGui.AlwaysOnTop = true

	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UIListLayout.Parent = BillboardGui

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, 0, 0, 16)
	TextLabel.BackgroundTransparency = 1
	TextLabel.TextColor3 = Color3.fromRGB(255, 80, 80)
	TextLabel.TextStrokeTransparency = 0.2
	TextLabel.Font = Enum.Font.SourceSansBold
	TextLabel.TextSize = 14
	TextLabel.LayoutOrder = 1
	TextLabel.Parent = BillboardGui

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, 0, 0, 16)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = p51.Name
	TextLabel2.TextColor3 = v587
	TextLabel2.TextStrokeTransparency = 0.2
	TextLabel2.Font = Enum.Font.SourceSansBold
	TextLabel2.TextSize = 14
	TextLabel2.Visible = t2.value49.IsNameEnabled
	TextLabel2.LayoutOrder = 2
	TextLabel2.Parent = BillboardGui

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Size = UDim2.new(1, 0, 0, 16)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.TextColor3 = Color3.fromRGB(200, 200, 200)
	TextLabel3.TextStrokeTransparency = 0.2
	TextLabel3.Font = Enum.Font.SourceSansBold
	TextLabel3.TextSize = 14
	TextLabel3.Visible = t2.value49.IsDistanceEnabled
	TextLabel3.LayoutOrder = 3
	TextLabel3.Parent = BillboardGui
	BillboardGui.Parent = HumanoidRootPart
	task.spawn(function()
		while true do
			local Parent = BillboardGui

			if Parent then
				Parent = BillboardGui.Parent

				if Parent then
					Parent = Character

					if Parent then
						Parent = Character.Parent
					end
				end
			end

			if not Parent then
				return
			end

			local Character2 = t2.value2.Character

			if Character2 then
				Character2 = t2.value2.Character:FindFirstChild("HumanoidRootPart")
			end

			if Character2 then
				Character2 = (Character2.Position - HumanoidRootPart.Position).Magnitude
			end

			local v599 = Character2 or 0

			if v599 <= t2.value49.MaxDistance then
				Highlight.Enabled = true
				BillboardGui.Enabled = true

				local v600 = p51
				local v601 = t2.value50(v600)

				Highlight.FillColor = v601
				TextLabel2.TextColor3 = v601

				local IsLivesEnabled = t2.value49.IsLivesEnabled

				if IsLivesEnabled then
					IsLivesEnabled = p51.Team.Name ~= "Killer"
				end

				if IsLivesEnabled then
					TextLabel.Visible = true

					local v603 = p51
					local v604 = v603.GetAttribute(v603, "Lives")

					if v604 then
						v604 = v604 - 1
					end

					TextLabel.Text = v604 .. " lives"

					if v604 >= 2 then
						TextLabel.TextColor3 = Color3.fromRGB(0, 255, 0)
					elseif v604 == 1 then
						TextLabel.TextColor3 = Color3.fromRGB(255, 220, 0)
					else
						TextLabel.TextColor3 = Color3.fromRGB(255, 50, 50)
					end
				else
					TextLabel.Visible = false
				end

				if t2.value49.IsDistanceEnabled then
					TextLabel3.Text = math.floor(v599) .. "m"
				end
			else
				Highlight.Enabled = false
				BillboardGui.Enabled = false
			end

			task.wait(0.5)
		end
	end)
end

local function v605()
	v579()

	if not t2.value49.IsEnabled then
		return
	end

	local ipairs_ = ipairs
	local value19 = t2.value1

	for _, player in ipairs_(value19.GetPlayers(value19)) do
		if player ~= t2.value2 then
			t2.value51(player)
		end
	end
end

task.spawn(function()
	while true do
		repeat
			task.wait(1)
		until t2.value49.IsEnabled

		v605()
	end
end)
v211("ESP Enable", function(p52)
	t2.value49.IsEnabled = p52
	v605()
end)
v211("Show Chams", function(p53)
	t2.value49.IsChamsEnabled = p53

	if not t2.value49.IsEnabled then
		return
	end

	v605()
end)
v211("Show Lives", function(p54)
	t2.value49.IsLivesEnabled = p54

	if not t2.value49.IsEnabled then
		return
	end

	v605()
end)

function t1.value3(p55)
	t2.value49.MaxDistance = p55
end

v211("Show Name", function(p56)
	t2.value49.IsNameEnabled = p56

	if not t2.value49.IsEnabled then
		return
	end

	v605()
end)
v211("Show Distance", function(p57)
	t2.value49.IsDistanceEnabled = p57

	if not t2.value49.IsEnabled then
		return
	end

	v605()
end)
v233({
	Text = "ESP Distance",
	Min = 50,
	Max = 2000,
	Default = 2000,
	Decimals = 1,
	Callback = t1.value3
})
v86()
createFrame("Trap ESP")
t2.value52 = {
	IsEnabled = false,
	IsNameEnabled = false,
	IsDistanceEnabled = false,
	MaxDistance = 2000,
	ESPColor = Color3.fromRGB(255, 60, 60)
}

function t2.value53()
	local ipairs_ = ipairs
	local workspace_ = workspace
	local t13 = {}

	for _, child in ipairs_(workspace_.GetChildren(workspace_)) do
		if child.Name == "Trap" then
			table.insert(t13, child)
		end
	end

	return t13
end

local function v615()
	for _, v in ipairs(t2.value53()) do
		local TrapESP_Highlight = v:FindFirstChild("TrapESP_Highlight")

		if TrapESP_Highlight then
			TrapESP_Highlight:Destroy()
		end

		local TrapESP_Billboard = v:FindFirstChild("TrapESP_Billboard")

		if TrapESP_Billboard then
			TrapESP_Billboard:Destroy()
		end
	end
end

function t2.value54(p58)
	local Highlight = Instance.new("Highlight")

	Highlight.Name = "TrapESP_Highlight"
	Highlight.FillColor = t2.value52.ESPColor
	Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	Highlight.FillTransparency = 0.5
	Highlight.Parent = p58

	local BillboardGui = Instance.new("BillboardGui")

	BillboardGui.Name = "TrapESP_Billboard"
	BillboardGui.Size = UDim2.new(0, 200, 0, 60)
	BillboardGui.StudsOffset = Vector3.new(0, 6, 0)
	BillboardGui.AlwaysOnTop = true

	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UIListLayout.Parent = BillboardGui

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, 0, 0, 16)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = "Trap"
	TextLabel.TextColor3 = t2.value52.ESPColor
	TextLabel.TextStrokeTransparency = 0.2
	TextLabel.Font = Enum.Font.SourceSansBold
	TextLabel.TextSize = 14
	TextLabel.Visible = t2.value52.IsNameEnabled
	TextLabel.LayoutOrder = 1
	TextLabel.Parent = BillboardGui

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, 0, 0, 16)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.TextColor3 = Color3.fromRGB(200, 200, 200)
	TextLabel2.TextStrokeTransparency = 0.2
	TextLabel2.Font = Enum.Font.SourceSansBold
	TextLabel2.TextSize = 14
	TextLabel2.Visible = t2.value52.IsDistanceEnabled
	TextLabel2.LayoutOrder = 2
	TextLabel2.Parent = BillboardGui
	BillboardGui.Parent = p58
	task.spawn(function()
		while true do
			local Parent = BillboardGui

			if Parent then
				Parent = BillboardGui.Parent

				if Parent then
					Parent = p58

					if Parent then
						Parent = p58.Parent
					end
				end
			end

			if not Parent then
				return
			end

			local Character = t2.value2.Character

			if Character then
				Character = t2.value2.Character:FindFirstChild("HumanoidRootPart")
			end

			if Character then
				Character = (Character.Position - p58:GetPivot().Position).Magnitude
			end

			local v627 = Character or 0

			if v627 <= t2.value52.MaxDistance then
				Highlight.Enabled = true
				BillboardGui.Enabled = true

				if t2.value52.IsDistanceEnabled then
					TextLabel2.Text = math.floor(v627) .. "m"
				end
			else
				Highlight.Enabled = false
				BillboardGui.Enabled = false
			end

			task.wait(0.5)
		end
	end)
end
function t2.value55()
	v615()

	if not t2.value52.IsEnabled then
		return
	end

	for _, v in ipairs(t2.value53()) do
		t2.value54(v)
	end
end

workspace.ChildAdded:Connect(function(child)
	local IsEnabled = t2.value52.IsEnabled

	if IsEnabled then
		IsEnabled = child.Name == "Trap"
	end

	if not IsEnabled then
		return
	end

	local Parent = child.Parent

	if Parent then
		Parent = not child:FindFirstChild("TrapESP_Highlight")
	end

	if not Parent then
		return
	end

	t2.value54(child)
end)
v211("ESP Enable", function(p59)
	t2.value52.IsEnabled = p59
	t2.value55()
end)
v211("Show Name", function(p60)
	t2.value52.IsNameEnabled = p60

	if not t2.value52.IsEnabled then
		return
	end

	t2.value55()
end)
v211("Show Distance", function(p61)
	t2.value52.IsDistanceEnabled = p61

	if not t2.value52.IsEnabled then
		return
	end

	t2.value55()
end)

function t1.value4(p62)
	t2.value52.MaxDistance = p62
end

local ESPColor = t2.value52.ESPColor

function t1.value1(p63)
	t2.value52.ESPColor = p63

	if not t2.value52.IsEnabled then
		return
	end

	t2.value55()
end

v137({
	Text = "ESP Color",
	Default = ESPColor,
	Callback = t1.value1
})
v233({
	Text = "ESP Distance",
	Min = 50,
	Max = 2000,
	Default = 2000,
	Decimals = 1,
	Callback = t1.value4
})
v86()
createFrame("Exit ESP")
t2.value56 = {
	IsEnabled = false,
	IsNameEnabled = false,
	IsDistanceEnabled = false,
	MaxDistance = 2000,
	ESPColor = Color3.fromRGB(60, 255, 60)
}

local function v633()
	local t14 = {}
	local v635 = t2.value24()
	local ExitGateways = v635:FindFirstChild("ExitGateways") or v635:FindFirstChild("Exits")

	if not ExitGateways then
		return t14
	end

	for _, child in ipairs(ExitGateways:GetChildren()) do
		local v639 = child.FindFirstChild(child, "Doorway")

		if v639 then
			table.insert(t14, v639)
		end
	end

	return t14
end
local function v640()
	for _, v in ipairs((v633())) do
		local ExitESP_Highlight = v:FindFirstChild("ExitESP_Highlight")

		if ExitESP_Highlight then
			ExitESP_Highlight:Destroy()
		end

		local ExitESP_Billboard = v:FindFirstChild("ExitESP_Billboard")

		if ExitESP_Billboard then
			ExitESP_Billboard:Destroy()
		end
	end
end

function t1.value3(p64)
	t2.value56.MaxDistance = p64
end
function t2.value57(p65)
	local Highlight = Instance.new("Highlight")

	Highlight.Name = "ExitESP_Highlight"
	Highlight.FillColor = t2.value56.ESPColor
	Highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
	Highlight.FillTransparency = 0.5
	Highlight.Parent = p65

	local BillboardGui = Instance.new("BillboardGui")

	BillboardGui.Name = "ExitESP_Billboard"
	BillboardGui.Size = UDim2.new(0, 200, 0, 60)
	BillboardGui.StudsOffset = Vector3.new(0, 6, 0)
	BillboardGui.AlwaysOnTop = true

	local UIListLayout = Instance.new("UIListLayout")

	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
	UIListLayout.Parent = BillboardGui

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, 0, 0, 16)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = "Exit"
	TextLabel.TextColor3 = t2.value56.ESPColor
	TextLabel.TextStrokeTransparency = 0.2
	TextLabel.Font = Enum.Font.SourceSansBold
	TextLabel.TextSize = 14
	TextLabel.Visible = t2.value56.IsNameEnabled
	TextLabel.LayoutOrder = 1
	TextLabel.Parent = BillboardGui

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, 0, 0, 16)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.TextColor3 = Color3.fromRGB(200, 200, 200)
	TextLabel2.TextStrokeTransparency = 0.2
	TextLabel2.Font = Enum.Font.SourceSansBold
	TextLabel2.TextSize = 14
	TextLabel2.Visible = t2.value56.IsDistanceEnabled
	TextLabel2.LayoutOrder = 2
	TextLabel2.Parent = BillboardGui
	BillboardGui.Parent = p65
	task.spawn(function()
		while true do
			local Parent = BillboardGui

			if Parent then
				Parent = BillboardGui.Parent

				if Parent then
					Parent = p65

					if Parent then
						Parent = p65.Parent
					end
				end
			end

			if not Parent then
				return
			end

			local Character = t2.value2.Character

			if Character then
				Character = t2.value2.Character:FindFirstChild("HumanoidRootPart")
			end

			if Character then
				Character = (Character.Position - p65:GetPivot().Position).Magnitude
			end

			local v652 = Character or 0

			if v652 <= t2.value56.MaxDistance then
				Highlight.Enabled = true
				BillboardGui.Enabled = true

				if t2.value56.IsDistanceEnabled then
					TextLabel2.Text = math.floor(v652) .. "m"
				end
			else
				Highlight.Enabled = false
				BillboardGui.Enabled = false
			end

			task.wait(0.5)
		end
	end)
end

local function v653()
	v640()

	if not t2.value56.IsEnabled then
		return
	end

	for _, v in ipairs((v633())) do
		t2.value57(v)
	end
end

local ChildAdded = workspace.ChildAdded

function t1.value1(p66)
	task.wait(3)

	local IsEnabled = t2.value56.IsEnabled

	if IsEnabled then
		IsEnabled = p66 == t2.value24()
	end

	if not IsEnabled then
		return
	end

	v653()
end

ChildAdded:Connect(t1.value1)
v211("ESP Enable", function(p67)
	t2.value56.IsEnabled = p67
	v653()
end)
v211("Show Name", function(p68)
	t2.value56.IsNameEnabled = p68

	if not t2.value56.IsEnabled then
		return
	end

	v653()
end)
v211("Show Distance", function(p69)
	t2.value56.IsDistanceEnabled = p69

	if not t2.value56.IsEnabled then
		return
	end

	v653()
end)

local ESPColor2 = t2.value56.ESPColor

function t1.value1(p70)
	t2.value56.ESPColor = p70

	if not t2.value56.IsEnabled then
		return
	end

	v653()
end

v137({
	Text = "ESP Color",
	Default = ESPColor2,
	Callback = t1.value1
})
v233({
	Text = "ESP Distance",
	Min = 50,
	Max = 2000,
	Default = 2000,
	Decimals = 1,
	Callback = t1.value3
})
v86()
createFrame2("Teleport", "rbxassetid://127576370347941")
t1.value9("Teleport")
t2.value18("Teleport")
createFrame("Spectate")
t2.value58 = {
	IsEnabled = false,
	CurrentTarget = nil,
	CurrentIndex = 1,
	CharAddedConnection = nil
}
t2.value59 = nil

local function v659(p71)
	if not (p71 and p71.Team) then
		return "Lobby"
	end

	local Name = p71.Team.Name

	if Name then
		return Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or "Lobby")
	end

	local Team = p71.Team

	Name = tostring(Team)

	return Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or "Lobby")
end
local function v662()
	local ipairs_ = ipairs
	local value19 = t2.value1
	local t15 = {}

	for _, player in ipairs_(value19.GetPlayers(value19)) do
		local v668 = player ~= t2.value2

		if v668 then
			v668 = false

			local v669

			if player and player.Team then
				local Name = player.Team.Name

				if not Name then
					local Team = player.Team

					Name = tostring(Team)
				end

				v669 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or "Lobby")
			else
				v669 = "Lobby"
			end

			if v669 ~= "Lobby" then
				v668 = v272(player)
			end
		end

		if v668 then
			ipairs_ = table.insert
			ipairs_(t15, player)
		end
	end

	table.sort(t15, function(p72, p73)
		return p72.Name < p73.Name
	end)

	return t15
end

function t2.value60()
	local CurrentCamera = workspace.CurrentCamera

	if not CurrentCamera then
		return
	end

	local Humanoid = t2.value2.Character and t2.value2.Character:FindFirstChildOfClass("Humanoid")

	if not Humanoid then
		return
	end

	CurrentCamera.CameraSubject = Humanoid
end

local function v674(p74)
	local value58

	if t2.value58.CharAddedConnection then
		t2.value58.CharAddedConnection:Disconnect()
		value58 = t2.value58
		value58.CharAddedConnection = nil
	else
		value58 = 848269
	end

	if not p74 or (v659(p74) == "Lobby" and true or not v272(p74)) then
		t2.value60()
		t2.value58.CurrentTarget = nil

		return
	end

	t2.value58.CurrentTarget = p74

	local function v676(character)
		if not character then
			return
		end

		local v677 = character.WaitForChild(character, "Humanoid", 5)
		local CurrentCamera = workspace.CurrentCamera
		local IsEnabled

		if v677 then
			if CurrentCamera then
				IsEnabled = t2.value58.IsEnabled

				if IsEnabled then
					IsEnabled = t2.value58.CurrentTarget == p74
				end
			else
				IsEnabled = CurrentCamera
			end
		else
			IsEnabled = v677
		end

		if not IsEnabled then
			return
		end

		CurrentCamera.CameraSubject = v677
	end

	t2.value58.CharAddedConnection = p74.CharacterAdded:Connect(v676)

	if not p74.Character then
		return
	end

	v676(p74.Character)
end
local function v680(p75)
	local v681 = v662()

	if #v681 == 0 then
		t2.value60()
		t2.value58.CurrentTarget = nil

		return
	end

	t2.value58.CurrentIndex = t2.value58.CurrentIndex + p75

	if t2.value58.CurrentIndex > #v681 then
		t2.value58.CurrentIndex = 1
	elseif t2.value58.CurrentIndex < 1 then
		t2.value58.CurrentIndex = #v681
	end

	local v682 = v681[t2.value58.CurrentIndex]

	if not v682 then
		return
	end

	v674(v682)
end

v211("Enable", function(p76)
	t2.value58.IsEnabled = p76

	if p76 then
		v680(0)

		return
	end

	if not t2.value58.CharAddedConnection then
		t2.value60()

		return
	end

	t2.value58.CharAddedConnection:Disconnect()
	t2.value58.CharAddedConnection = nil
	t2.value60()
end)
createFrame3("Next Player", function()
	if t2.value58.IsEnabled then
		v680(1)
	end
end, true)
createFrame3("Previous Player", function()
	if t2.value58.IsEnabled then
		v680(-1)
	end
end, true)

local PlayerRemoving = t2.value1.PlayerRemoving

function t1.value4(p77)
	if t2.value58.CurrentTarget ~= p77 then
		return
	end

	if t2.value58.IsEnabled then
		v680(0)

		return
	end

	t2.value60()
	t2.value58.CurrentTarget = nil
end

PlayerRemoving:Connect(t1.value4)
task.spawn(function()
	while true do
		task.wait(1.5)

		local IsEnabled = t2.value58.IsEnabled

		if IsEnabled then
			IsEnabled = t2.value58.CurrentTarget
		end

		if IsEnabled then
			local v685 = false
			local CurrentTarget = t2.value58.CurrentTarget
			local v687

			if CurrentTarget and CurrentTarget.Team then
				local Name = CurrentTarget.Team.Name

				if not Name then
					local Team = CurrentTarget.Team

					Name = tostring(Team)
				end

				v687 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or "Lobby")
			else
				v687 = "Lobby"
			end

			if v687 ~= "Lobby" then
				v685 = v272(t2.value58.CurrentTarget)
			end

			if not v685 then
				v680(0)
			end
		end
	end
end)
v86()
createFrame("Player Teleport")
t2.value61 = {
	CurrentIndex = 1
}

function t2.value62()
	local t16 = {}
	local v691

	if t2.value2.Team then
		local Name = t2.value2.Team.Name

		if not Name then
			local Team = t2.value2.Team

			Name = tostring(Team)
		end

		v691 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or (Name == "Lobby" and "Lobby" or "None"))
	else
		v691 = "None"
	end

	if v691 == "Lobby" and true or v691 == "None" then
		return t16
	end

	local ipairs_ = ipairs
	local value19 = t2.value1

	for _, player in ipairs_(value19.GetPlayers(value19)) do
		local v698

		if player == t2.value2 then
			v698 = false
		else
			v698 = player.Team
		end

		if v698 then
			local Name = player.Team.Name

			if not Name then
				local Team = player.Team

				Name = tostring(Team)
			end

			local v701

			if Name == "Lobby" then
				v701 = false
			else
				v701 = Name ~= "None"
			end

			if v701 then
				if v691 == "Survivor" then
					local v702

					if Name == "Survivor" then
						v702 = v272(player)
					else
						v702 = false
					end

					if v702 then
						table.insert(t16, player)
					end
				elseif v691 == "Killer" and Name == "Survivor" then
					local Character = player.Character

					if Character then
						Character = Character:FindFirstChildOfClass("Humanoid")
					end

					if Character then
						if Character.Health > 0 then
							Character = player:GetAttribute("Dead") ~= true
						else
							Character = false
						end
					end

					if Character then
						table.insert(t16, player)
					end
				end
			end
		end
	end

	table.sort(t16, function(p78, p79)
		return p78.Name < p79.Name
	end)

	return t16
end
function t1.value1()
	t2.value59(1)
end
function t2.value63(p80)
	if not (p80 and p80.Character) then
		return
	end

	local HumanoidRootPart = p80.Character:FindFirstChild("HumanoidRootPart")
	local v705

	if HumanoidRootPart then
		v705 = v272(t2.value2)
	else
		v705 = HumanoidRootPart
	end

	if not v705 then
		return
	end

	v277(HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
end
function t2.value59(p81)
	local v706 = not v272(t2.value2)

	if not v706 then
		v706 = true

		local v707

		if t2.value2.Team then
			local Name = t2.value2.Team.Name

			if not Name then
				local Team = t2.value2.Team

				Name = tostring(Team)
			end

			v707 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or (Name == "Lobby" and "Lobby" or "None"))
		else
			v707 = "None"
		end

		if v707 ~= "Lobby" then
			local v710

			if t2.value2.Team then
				local Name = t2.value2.Team.Name

				if not Name then
					local Team = t2.value2.Team

					Name = tostring(Team)
				end

				v710 = Name == "Survivor" and "Survivor" or (Name == "Killer" and "Killer" or (Name == "Lobby" and "Lobby" or "None"))
			else
				v710 = "None"
			end

			v706 = v710 == "None"
		end
	end

	if v706 then
		return
	end

	local v713 = t2.value62()

	if #v713 == 0 then
		return
	end

	t2.value61.CurrentIndex = t2.value61.CurrentIndex + p81

	if t2.value61.CurrentIndex > #v713 then
		t2.value61.CurrentIndex = 1
	elseif t2.value61.CurrentIndex < 1 then
		t2.value61.CurrentIndex = #v713
	end

	local v714 = v713[t2.value61.CurrentIndex]

	if not v714 then
		return
	end

	t2.value63(v714)
end

createFrame3("Teleport to Next Player", t1.value1, true)
createFrame3("Teleport to Previous Player", function()
	t2.value59(-1)
end, true)
v86()

function t1.value1()
	local v715 = v281()
	local v716

	if v715 then
		v716 = v272(t2.value2)
	else
		v716 = v715
	end

	if not v716 then
		return
	end

	v277(v715)
end

createFrame("Locations Teleport")
createFrame3("Teleport to Lobby", t1.value1)
createFrame3("Teleport to Map", function()
	local v717 = t2.value24()

	if not (v717 and v272(t2.value2)) then
		return
	end

	local LootSpawns = v717:FindFirstChild("LootSpawns")

	if not LootSpawns then
		return
	end

	local children = LootSpawns:GetChildren()
	local v720 = #children > 0 and children[1]

	if not v720 then
		return
	end

	v277(v720:GetPivot() + Vector3.new(0, 3, 0))
end)
createFrame3("Teleport to Nearest Exit", function()
	if not v272(t2.value2) then
		return
	end

	local Character = t2.value2.Character

	if Character then
		Character = Character:FindFirstChild("HumanoidRootPart")
	end

	local Exits = t2.value24()
	local GetChildren, huge, v725, Doorway, GetPivot, Magnitude

	if not Exits then
		if Exits and Character then
			GetChildren = Exits.GetChildren
			huge = math.huge
			v725 = nil

			for _, v in ipairs(GetChildren(Exits)) do
				Doorway = v:FindFirstChild("Doorway")

				if Doorway then
					GetPivot = Doorway.GetPivot
					Magnitude = (Character.Position - GetPivot(Doorway).Position).Magnitude

					if Magnitude < huge then
						v725 = Doorway
						huge = Magnitude
					end
				end
			end

			if not v725 then
				return
			end

			v277(v725.GetPivot(v725))
		end

		return
	end

	Exits = Exits:FindFirstChild("Exits") or Exits:FindFirstChild("ExitGateways")

	if Exits and Character then
		GetChildren = Exits.GetChildren
		huge = math.huge
		v725 = nil

		for _, v in ipairs(GetChildren(Exits)) do
			Doorway = v:FindFirstChild("Doorway")

			if Doorway then
				GetPivot = Doorway.GetPivot
				Magnitude = (Character.Position - GetPivot(Doorway).Position).Magnitude

				if Magnitude < huge then
					v725 = Doorway
					huge = Magnitude
				end
			end
		end

		if not v725 then
			return
		end

		v277(v725.GetPivot(v725))
	end
end)
v86()
t2.value18("Main")
createFrame2("Settings", "rbxassetid://90091610697193", 999)
t1.value9("Settings")
t2.value18("Settings")
createFrame("Interface settings")
t2.value64 = {
	HideMiniWidget = false,
	IsAnimating = false
}
t1.value3 = Instance.new("ScreenGui")
t1.value3.Name = "MiniWidgetGui"
t1.value3.ResetOnSpawn = false
t1.value3.DisplayOrder = 999999
t1.value3.IgnoreGuiInset = true
t1.value3.Parent = PlayerGui
t1.value1 = Instance.new("Frame")
t2.value65 = t1.value1
t2.value65.Size = UDim2.new(0, 155, 0, 34)
t2.value65.AnchorPoint = Vector2.new(0.5, 0)
t2.value65.Position = UDim2.new(0.5, 0, 0, -45)
t2.value65.BackgroundColor3 = Color3.fromRGB(24, 28, 30)
t2.value65.BorderSizePixel = 0
t2.value65.Visible = false
t2.value65.ZIndex = 20
t2.value65.Parent = t1.value3

local value65 = t2.value65
local UICorner4 = Instance.new("UICorner")

UICorner4.CornerRadius = UDim.new(0, 6)
UICorner4.Parent = value65
t1.value1 = Instance.new("UIStroke")
t2.value66 = t1.value1
t2.value66.Color = Color3.fromRGB(45, 58, 56)
t2.value66.Thickness = 1
t2.value66.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
t2.value66.Parent = t2.value65

local Frame2 = Instance.new("Frame")

Frame2.Size = UDim2.fromScale(1, 1)
Frame2.BackgroundTransparency = 1
Frame2.ZIndex = 21
Frame2.Parent = t2.value65
t1.value9 = Instance.new("UIListLayout")
t1.value9.FillDirection = Enum.FillDirection.Horizontal
t1.value9.HorizontalAlignment = Enum.HorizontalAlignment.Center
t1.value9.VerticalAlignment = Enum.VerticalAlignment.Center
t1.value9.SortOrder = Enum.SortOrder.LayoutOrder
t1.value9.Padding = UDim.new(0, 8)
t1.value9.Parent = Frame2
t1.value3 = Instance.new("ImageLabel")
t1.value3.Size = UDim2.new(0, 20, 0, 20)
t1.value3.BackgroundTransparency = 1
t1.value1 = "rbxassetid://85587045526405"
t1.value3.Image = "rbxassetid://85587045526405"
t1.value3.ImageColor3 = Color3.fromRGB(255, 255, 255)
t1.value3.LayoutOrder = 1
t1.value3.ZIndex = 21
t1.value3.Parent = Frame2
t1.value1 = Instance.new("TextLabel")
t2.value67 = t1.value1
t2.value67.AutomaticSize = Enum.AutomaticSize.X
t2.value67.Size = UDim2.new(0, 0, 1, 0)
t2.value67.BackgroundTransparency = 1
t2.value67.Text = "FPS: 0 | Ping: 0ms"
t2.value67.TextColor3 = Color3.fromRGB(0, 255, 200)
t2.value67.Font = Enum.Font.SourceSansSemibold
t2.value67.TextSize = 14
t2.value67.TextXAlignment = Enum.TextXAlignment.Left
t2.value67.LayoutOrder = 2
t2.value67.ZIndex = 21
t2.value67.Parent = Frame2
t1.value9 = Instance.new("TextButton")
t1.value9.Size = UDim2.fromScale(1, 1)
t1.value9.BackgroundTransparency = 1
t1.value1 = ""
t1.value9.Text = ""
t1.value9.ZIndex = 22
t1.value9.Parent = t2.value65
t2.value11:GetPropertyChangedSignal("Text"):Connect(function()
	t2.value67.Text = t2.value11.Text
	t2.value65.Size = UDim2.new(0, t2.value67.TextBounds.X + 44, 0, 34)
end)

local MouseEnter = t1.value9.MouseEnter

function t1.value4()
	t2.value4:Create(t2.value65, TweenInfo.new(0.15), {
		BackgroundColor3 = Color3.fromRGB(30, 36, 38)
	}):Play()
	t2.value4:Create(t2.value66, TweenInfo.new(0.15), {
		Color = Color3.fromRGB(0, 255, 200)
	}):Play()
end

t1.value1 = MouseEnter.Connect
t1.value1(MouseEnter, t1.value4)

function t1.value4()
	t2.value4:Create(t2.value65, TweenInfo.new(0.15), {
		BackgroundColor3 = Color3.fromRGB(24, 28, 30)
	}):Play()

	local value4 = t2.value4
	local value66 = t2.value66
	local tweenInfo = TweenInfo.new(0.15)
	local t17 = {
		Color = Color3.fromRGB(45, 58, 56)
	}

	value4.Create(value4, value66, tweenInfo, t17):Play()
end

t1.value9.MouseLeave:Connect(t1.value4)

local function v741()
	if not t2.value64.IsAnimating then
		t2.value64.IsAnimating = true
		t2.value10.Visible = false
		t2.value65.Position = UDim2.new(0.5, 0, 0, -45)
		t2.value65.Visible = true

		local value4 = t2.value4
		local value652 = t2.value65
		local tweenInfoNew = TweenInfo.new
		local Quart = Enum.EasingStyle.Quart
		local v746 = value4.Create(value4, value652, tweenInfoNew(0.25, Quart, Enum.EasingDirection.Out), {
			Position = UDim2.new(0.5, 0, 0, 10)
		})

		v746:Play()
		v746.Completed:Wait()
		t2.value64.IsAnimating = false
	end
end
local function v747()
	if not t2.value64.IsAnimating then
		t2.value64.IsAnimating = true

		local value4 = t2.value4
		local value652 = t2.value65
		local tweenInfoNew = TweenInfo.new
		local EasingStyle = Enum.EasingStyle
		local v752 = value4.Create(value4, value652, tweenInfoNew(0.2, EasingStyle.Quart, Enum.EasingDirection.In), {
			Position = UDim2.new(0.5, 0, 0, -45)
		})

		v752.Play(v752)
		v752.Completed:Wait()
		t2.value65.Visible = false
		t2.value10.Visible = true
		t2.value64.IsAnimating = false
	end
end

function t2.value68()
	t2.value10.Visible = false
	t2.value65.Visible = false
end

t1.value9.MouseButton1Click:Connect(function()
	v747()
end)
t1.value2.InputBegan:Connect(function(input)
	if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	if not t2.value10.Visible then
		return
	end

	if t2.value64.HideMiniWidget then
		t2.value68()

		return
	end

	v741()
end)
v211("Hide Mini Widget", function(p82)
	t2.value64.HideMiniWidget = p82

	if p82 then
		p82 = t2.value65.Visible
	end

	if not p82 then
		return
	end

	t2.value65.Visible = false
end)
v86()
createFrame("Camera")

local CameraMaxZoomDistance = t2.value2.CameraMaxZoomDistance
local CameraMinZoomDistance = t2.value2.CameraMinZoomDistance

t1.value2 = t2.value2.CameraMode
t1.value9 = t2.value9.FieldOfView
t1.value3 = t2.value9.CameraType
t1.value4 = t2.value2.DevCameraOcclusionMode
t2.value69 = nil

function t1.value1(p83)
	t2.value69.UnlockCamActive = p83

	if p83 then
		local Custom = Enum.CameraType.Custom

		t2.value9.CameraType = Custom
		t2.value9.FieldOfView = 70
		t2.value2.CameraMaxZoomDistance = 400
		t2.value2.CameraMinZoomDistance = 0.5
		t2.value2.CameraMode = Enum.CameraMode.Classic

		return
	end

	if t2.value69.UnlockCamNoWallsActive then
		return
	end

	local DefaultType = t2.value69.DefaultType

	t2.value9.CameraType = DefaultType

	local DefaultFOV = t2.value69.DefaultFOV

	t2.value9.FieldOfView = DefaultFOV

	local DefaultMax = t2.value69.DefaultMax

	t2.value2.CameraMaxZoomDistance = DefaultMax

	local DefaultMin = t2.value69.DefaultMin

	t2.value2.CameraMinZoomDistance = DefaultMin
	t2.value2.CameraMode = t2.value69.DefaultMode
end

t2.value69 = {
	DefaultMax = CameraMaxZoomDistance,
	DefaultMin = CameraMinZoomDistance,
	DefaultMode = t1.value2,
	DefaultFOV = t1.value9,
	DefaultType = t1.value3,
	DefaultOcclusion = t1.value4,
	UnlockCamActive = false,
	UnlockCamNoWallsActive = false
}
v211("Unlock Camera", t1.value1)
v211("Unlock Camera (No Walls)", function(p84)
	t2.value69.UnlockCamNoWallsActive = p84

	if p84 then
		local Custom = Enum.CameraType.Custom

		t2.value9.CameraType = Custom
		t2.value9.FieldOfView = 70
		t2.value2.CameraMaxZoomDistance = 400
		t2.value2.CameraMinZoomDistance = 0.5

		local Classic = Enum.CameraMode.Classic

		t2.value2.CameraMode = Classic
		t2.value2.DevCameraOcclusionMode = Enum.DevCameraOcclusionMode.Invisicam

		return
	end

	t2.value2.DevCameraOcclusionMode = t2.value69.DefaultOcclusion

	if t2.value69.UnlockCamActive then
		return
	end

	local DefaultType = t2.value69.DefaultType

	t2.value9.CameraType = DefaultType

	local DefaultFOV = t2.value69.DefaultFOV

	t2.value9.FieldOfView = DefaultFOV

	local DefaultMax = t2.value69.DefaultMax

	t2.value2.CameraMaxZoomDistance = DefaultMax

	local DefaultMin = t2.value69.DefaultMin

	t2.value2.CameraMinZoomDistance = DefaultMin

	local DefaultMode = t2.value69.DefaultMode

	t2.value2.CameraMode = DefaultMode
	t2.value2.DevCameraOcclusionMode = t2.value69.DefaultOcclusion
end)
v86()
createFrame("Utilities")
t2.value70 = nil
t2.value71 = nil
t2.value72 = {
	IsEnabled = false,
	Connection = nil
}

function t1.value2(p85)
	t2.value72.IsEnabled = p85

	if p85 then
		t2.value71()
	else
		t2.value70()
	end
end
function t2.value71()
	if t2.value72.Connection then
		return
	end

	t2.value72.Connection = t2.value1.LocalPlayer.Idled:Connect(function()
		t2.value6:CaptureController()
		t2.value6:ClickButton2(Vector2.new())
	end)
end
function t2.value70()
	if not t2.value72.Connection then
		return
	end

	t2.value72.Connection:Disconnect()
	t2.value72.Connection = nil
end

v211("Anti AFK", t1.value2)
v86()

local function createFrame4(p86)
	t2.value20 = t2.value20 + 1

	local Frame3 = Instance.new("Frame")

	Frame3.Size = UDim2.new(1, 0, 0, 52)
	Frame3.BackgroundColor3 = Color3.fromRGB(20, 22, 24)
	Frame3.BorderSizePixel = 0
	Frame3.LayoutOrder = t2.value20

	local value19

	if t2.value19 then
		value19 = t2.value19
	else
		value19 = t2.value17 and t2.value17.content or nil
	end

	Frame3.Parent = value19

	local UICorner5 = Instance.new("UICorner")

	UICorner5.CornerRadius = UDim.new(0, 8)
	UICorner5.Parent = Frame3

	local UIStroke = Instance.new("UIStroke")

	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.Color = Color3.fromRGB(42, 45, 50)
	UIStroke.Thickness = 1.2
	UIStroke.Parent = Frame3

	local ImageLabel = Instance.new("ImageLabel")

	ImageLabel.Size = UDim2.new(0, 24, 0, 24)
	ImageLabel.Position = UDim2.new(0, 14, 0.5, -12)
	ImageLabel.BackgroundTransparency = 1
	ImageLabel.Image = p86.Icon
	ImageLabel.ImageColor3 = p86.AccentColor
	ImageLabel.Parent = Frame3

	local Frame4 = Instance.new("Frame")

	Frame4.Size = UDim2.new(1, -150, 1, 0)
	Frame4.Position = UDim2.new(0, 48, 0, 0)
	Frame4.BackgroundTransparency = 1
	Frame4.Parent = Frame3

	local TextLabel = Instance.new("TextLabel")

	TextLabel.Size = UDim2.new(1, 0, 0, 18)
	TextLabel.Position = UDim2.new(0, 0, 0, 9)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = p86.Title
	TextLabel.TextColor3 = Color3.fromRGB(240, 240, 240)
	TextLabel.Font = Enum.Font.GothamBold
	TextLabel.TextSize = 14
	TextLabel.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel.Parent = Frame4

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, 0, 0, 14)
	TextLabel2.Position = UDim2.new(0, 0, 0, 27)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = p86.Subtitle
	TextLabel2.TextColor3 = Color3.fromRGB(130, 135, 145)
	TextLabel2.Font = Enum.Font.SourceSans
	TextLabel2.TextSize = 13
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel2.Parent = Frame4

	local Frame5 = Instance.new("Frame")

	Frame5.Size = UDim2.new(0, 74, 0, 28)
	Frame5.Position = UDim2.new(1, -84, 0.5, -14)
	Frame5.BackgroundColor3 = Color3.fromRGB(30, 33, 38)
	Frame5.BorderSizePixel = 0
	Frame5.Parent = Frame3

	local UICorner6 = Instance.new("UICorner")

	UICorner6.CornerRadius = UDim.new(0, 6)
	UICorner6.Parent = Frame5

	local UIStroke2 = Instance.new("UIStroke")

	UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke2.Color = Color3.fromRGB(50, 54, 62)
	UIStroke2.Thickness = 1
	UIStroke2.Parent = Frame5

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Size = UDim2.fromScale(1, 1)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Text = p86.ActionText
	TextLabel3.TextColor3 = p86.AccentColor
	TextLabel3.Font = Enum.Font.GothamBold
	TextLabel3.TextSize = 12
	TextLabel3.Parent = Frame5

	local TextButton2 = Instance.new("TextButton")

	TextButton2.Size = UDim2.fromScale(1, 1)
	TextButton2.BackgroundTransparency = 1
	TextButton2.Text = ""
	TextButton2.Parent = Frame3

	local function v781()
		local value4 = t2.value4
		local v783 = Frame3
		local tweenInfo = TweenInfo.new(0.2)
		local t18 = {
			BackgroundColor3 = Color3.fromRGB(26, 29, 33)
		}

		value4.Create(value4, v783, tweenInfo, t18):Play()
		t2.value4:Create(UIStroke, TweenInfo.new(0.2), {
			Color = p86.AccentColor
		}):Play()
		t2.value4:Create(Frame5, TweenInfo.new(0.2), {
			BackgroundColor3 = p86.AccentColor
		}):Play()

		local value42 = t2.value4
		local v787 = TextLabel3
		local tweenInfo2 = TweenInfo.new(0.2)
		local t19 = {
			TextColor3 = Color3.fromRGB(255, 255, 255)
		}

		value42.Create(value42, v787, tweenInfo2, t19):Play()
	end

	local u790 = false

	TextButton2.MouseEnter:Connect(v781)

	local function v791()
		t2.value4:Create(Frame3, TweenInfo.new(0.2), {
			BackgroundColor3 = Color3.fromRGB(20, 22, 24)
		}):Play()

		local value4 = t2.value4
		local v793 = UIStroke
		local tweenInfo = TweenInfo.new(0.2)
		local Color3_4 = Color3

		value4.Create(value4, v793, tweenInfo, {
			Color = Color3_4.fromRGB(42, 45, 50)
		}):Play()

		local value42 = t2.value4
		local v797 = Frame5
		local tweenInfo2 = TweenInfo.new(0.2)
		local Color3_5 = Color3

		value42.Create(value42, v797, tweenInfo2, {
			BackgroundColor3 = Color3_5.fromRGB(30, 33, 38)
		}):Play()
		t2.value4:Create(TextLabel3, TweenInfo.new(0.2), {
			TextColor3 = p86.AccentColor
		}):Play()
	end

	TextButton2.MouseLeave:Connect(v791)

	local function v800()
		if p86.Callback then
			p86.Callback()
		end

		if u790 then
			return
		end

		local function v801()
			TextLabel3.Text = p86.ActionText
			u790 = false
		end

		u790 = true
		TextLabel3.Text = "Copied"
		task.delay(1.5, v801)
	end

	TextButton2.Activated:Connect(v800)

	return Frame3
end

t1.value9 = Color3.fromRGB(88, 101, 242)
createFrame4({
	Title = "Discord Server",
	Subtitle = "Updates & Support",
	ActionText = "Copy Link",
	AccentColor = t1.value9,
	Icon = "rbxassetid://86312085123783",
	Callback = function()
		if setclipboard then
			setclipboard("https://discord.gg/behjGQhNFX")

			return
		end

		if not toclipboard then
			return
		end

		toclipboard("https://discord.gg/behjGQhNFX")
	end
})
t1.value9 = Color3.fromRGB(255, 75, 75)
createFrame4({
	Title = "YouTube Channel",
	Subtitle = "Videos & Showcases",
	ActionText = "Copy Link",
	AccentColor = t1.value9,
	Icon = "rbxassetid://99775080325014",
	Callback = function()
		if setclipboard then
			setclipboard("https://www.youtube.com/@Sosiskomras/videos")

			return
		end

		if not toclipboard then
			return
		end

		toclipboard("https://www.youtube.com/@Sosiskomras/videos")
	end
})
