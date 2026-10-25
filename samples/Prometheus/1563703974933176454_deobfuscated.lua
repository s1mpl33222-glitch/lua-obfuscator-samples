-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")

game:GetService("RunService")

local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

Players = Players.LocalPlayer:WaitForChild("PlayerGui")

local t1 = {
	Red = Color3.fromRGB(222, 53, 58),
	Orange = Color3.fromRGB(255, 151, 35),
	Yellow = Color3.fromRGB(255, 211, 55),
	Green = Color3.fromRGB(48, 181, 83),
	Blue = Color3.fromRGB(65, 132, 255),
	Purple = Color3.fromRGB(157, 62, 211)
}
local t2 = {
	"Red",
	"Orange",
	"Yellow",
	"Green",
	"Blue",
	"Purple"
}
local color3 = Color3.fromRGB(255, 60, 80)
local color32 = Color3.fromRGB(180, 20, 45)
local color33 = Color3.fromRGB(255, 110, 130)
local t3 = {
	"Red",
	"Orange",
	"Yellow",
	"Green"
}
local t4 = {}
local n1 = 0
local n2 = 0
local scale = 1
local u14 = false
local KevinDicePredictorUI = Players:FindFirstChild("KevinDicePredictorUI")

if KevinDicePredictorUI then
	KevinDicePredictorUI:Destroy()
end

KevinDicePredictorUI = Players:FindFirstChild("AmbitiousPredicterUI")

if KevinDicePredictorUI then
	KevinDicePredictorUI:Destroy()
end

local ScreenGui = Instance.new("ScreenGui")

ScreenGui.Name = "KevinDicePredictorUI"
ScreenGui.ResetOnSpawn = false
ScreenGui.IgnoreGuiInset = true
ScreenGui.DisplayOrder = 999
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = Players

local Frame = Instance.new("Frame")

Frame.AnchorPoint = Vector2.new(0.5, 0)
Frame.Position = UDim2.new(0.5, 0, 0.5, -270)
Frame.Size = UDim2.new(0, 392, 0, 486)
Frame.BackgroundColor3 = Color3.fromRGB(14, 8, 12)
Frame.BackgroundTransparency = 0
Frame.BorderSizePixel = 0
Frame.Active = true
Frame.ClipsDescendants = true
Frame.Parent = ScreenGui
Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 14)
KevinDicePredictorUI = Instance.new("UIStroke", Frame)
KevinDicePredictorUI.Color = color3
KevinDicePredictorUI.Thickness = 1.5
KevinDicePredictorUI.Transparency = 0.1

local UIScale = Instance.new("UIScale")

UIScale.Scale = scale
UIScale.Parent = Frame

local Frame2 = Instance.new("Frame")

Frame2.Size = UDim2.new(1, 0, 1, 0)
Frame2.BackgroundColor3 = Color3.fromRGB(20, 10, 15)
Frame2.BackgroundTransparency = 0
Frame2.BorderSizePixel = 0
Frame2.ZIndex = 0
Frame2.Parent = Frame
Instance.new("UICorner", Frame2).CornerRadius = UDim.new(0, 14)

local UIGradient = Instance.new("UIGradient", Frame2)

UIGradient.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 12, 22)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(16, 6, 10)), ColorSequenceKeypoint.new(1, Color3.fromRGB(38, 12, 22)) })
UIGradient.Rotation = 45
task.spawn(function()
	local rotation = 0

	while Frame2.Parent do
		rotation = (rotation + 1) % 360
		UIGradient.Rotation = rotation
		task.wait(0.04)
	end
end)
KevinDicePredictorUI = Instance.new("Frame")
KevinDicePredictorUI.Size = UDim2.new(1, 0, 1, 0)
KevinDicePredictorUI.BackgroundTransparency = 1
KevinDicePredictorUI.ZIndex = 1
KevinDicePredictorUI.ClipsDescendants = true
KevinDicePredictorUI.Parent = Frame

local function v22(p1, p2, p3, p4)
	local v23 = p2 or color33
	local v24 = p3 or 3
	local UIStroke = Instance.new("UIStroke")

	UIStroke.Color = v23
	UIStroke.Thickness = 0
	UIStroke.Transparency = 1
	UIStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke.LineJoinMode = Enum.LineJoinMode.Round
	UIStroke.Parent = p1

	local UIStroke2 = Instance.new("UIStroke")

	UIStroke2.Color = v23
	UIStroke2.Thickness = 0
	UIStroke2.Transparency = 1
	UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	UIStroke2.LineJoinMode = Enum.LineJoinMode.Round
	UIStroke2.Parent = p1

	local function v27()
		local t5 = {
			Thickness = v24,
			Transparency = 0.05
		}

		TweenService:Create(UIStroke, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), t5):Play()

		local v29 = TweenService
		local v30 = UIStroke2
		local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

		v29.Create(v29, v30, tweenInfo, {
			Thickness = v24 * 2.5,
			Transparency = 0.85
		}):Play()

		local isGuiObject = p4

		if isGuiObject then
			isGuiObject = p1:IsA("GuiObject")

			if isGuiObject then
				isGuiObject = p1.BackgroundTransparency < 1
			end
		end

		if not isGuiObject then
			return
		end

		local v33 = TweenService
		local v34 = p1
		local tweenInfo2 = TweenInfo.new(0.18)
		local t6 = {
			BackgroundColor3 = p4
		}

		v33.Create(v33, v34, tweenInfo2, t6):Play()
	end
	local function v37()
		TweenService:Create(UIStroke, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Thickness = 0,
			Transparency = 1
		}):Play()
		TweenService:Create(UIStroke2, TweenInfo.new(0.22, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
			Thickness = 0,
			Transparency = 1
		}):Play()

		local isGuiObject = p4

		if isGuiObject then
			isGuiObject = p1:IsA("GuiObject")
		end

		if not isGuiObject then
			return
		end

		TweenService:Create(p1, TweenInfo.new(0.18), {
			BackgroundColor3 = p1:GetAttribute("BaseColor") or Color3.fromRGB(26, 12, 18)
		}):Play()
	end

	p1.MouseEnter:Connect(v27)
	p1.MouseLeave:Connect(v37)

	return UIStroke, UIStroke2
end

for i = 1, 10 do
	local Frame3 = Instance.new("Frame")

	v53 = math.random(3, 7)
	Frame3.Size = UDim2.new(0, v53, 0, v53)
	Frame3.BackgroundColor3 = color33
	Frame3.BackgroundTransparency = math.random(55, 85) / 100
	Frame3.BorderSizePixel = 0
	Frame3.Position = UDim2.new(math.random(), 0, math.random(), 0)
	Frame3.ZIndex = 1
	Frame3.Parent = KevinDicePredictorUI
	Instance.new("UICorner", Frame3).CornerRadius = UDim.new(1, 0)
	task.spawn(function()
		while Frame3.Parent do
			local v41 = math.random()
			local v42 = math.random()
			local v43 = math.random(4, 8)
			local v44 = TweenService
			local v45 = Frame3
			local tweenInfo = TweenInfo.new(v43, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
			local t7 = {
				Position = UDim2.new(v41, 0, v42, 0)
			}

			v44.Create(v44, v45, tweenInfo, t7):Play()
			task.wait(v43)
		end
	end)
end

local Frame3 = Instance.new("Frame")

Frame3.Size = UDim2.new(1, 0, 0, 64)
Frame3.BackgroundTransparency = 1
Frame3.ZIndex = 2
Frame3.Parent = Frame

local Frame4 = Instance.new("Frame")

Frame4.Size = UDim2.new(0, 34, 0, 4)
Frame4.AnchorPoint = Vector2.new(0.5, 0)
Frame4.Position = UDim2.new(0.5, 0, 0, 6)
Frame4.BackgroundColor3 = color3
Frame4.BackgroundTransparency = 0.3
Frame4.ZIndex = 3
Frame4.Parent = Frame3
Instance.new("UICorner", Frame4).CornerRadius = UDim.new(0, 2)

local Frame5 = Instance.new("Frame")

Frame5.Size = UDim2.new(0, 36, 0, 36)
Frame5.Position = UDim2.new(0, 18, 0, 16)
Frame5.BackgroundColor3 = color3
Frame5.ZIndex = 3
Frame5.Parent = Frame3
Instance.new("UICorner", Frame5).CornerRadius = UDim.new(0, 10)
Frame4 = Instance.new("UIGradient", Frame5)
Frame4.Color = ColorSequence.new(color3, color32)
Frame4.Rotation = 45
Frame4 = function(p5, p6)
	local Frame6 = Instance.new("Frame")

	Frame6.Size = UDim2.new(0, 7, 0, 7)
	Frame6.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame6.Position = UDim2.new(p5, 0, p6, 0)
	Frame6.BackgroundColor3 = Color3.new(1, 1, 1)
	Frame6.ZIndex = 5
	Frame6.Parent = Frame5
	Instance.new("UICorner", Frame6).CornerRadius = UDim.new(0, 3)
end
Frame4(0.3, 0.3)
Frame4(0.5, 0.5)
Frame4(0.7, 0.7)
Frame4 = Instance.new("TextLabel")
Frame4.Size = UDim2.new(1, -190, 0, 20)
Frame4.Position = UDim2.new(0, 66, 0, 16)
Frame4.BackgroundTransparency = 1
Frame4.Text = "Kevin Dice Predictor"
Frame4.Font = Enum.Font.GothamBold
Frame4.TextSize = 16
Frame4.TextColor3 = Color3.fromRGB(255, 255, 255)
Frame4.TextXAlignment = Enum.TextXAlignment.Left
Frame4.ZIndex = 3
Frame4.Parent = Frame3
Frame4 = Instance.new("TextLabel")
Frame4.Size = UDim2.new(1, -190, 0, 14)
Frame4.Position = UDim2.new(0, 66, 0, 34)
Frame4.BackgroundTransparency = 1
Frame4.Text = "discord.gg/luascript"
Frame4.Font = Enum.Font.GothamMedium
Frame4.TextSize = 11
Frame4.TextColor3 = color33
Frame4.TextXAlignment = Enum.TextXAlignment.Left
Frame4.ZIndex = 3
Frame4.Parent = Frame3
Frame4 = function(p7, p8, p9)
	local TextButton = Instance.new("TextButton")

	TextButton.Size = UDim2.new(0, p9 or 28, 0, 28)
	TextButton.Position = UDim2.new(1, p8, 0, 20)
	TextButton.BackgroundColor3 = Color3.fromRGB(26, 12, 18)
	TextButton.BackgroundTransparency = 0.16
	TextButton.Text = p7
	TextButton.Font = Enum.Font.GothamBold
	TextButton.TextSize = 14
	TextButton.TextColor3 = Color3.fromRGB(220, 190, 200)
	TextButton.AutoButtonColor = false
	TextButton.ZIndex = 3
	TextButton.Parent = Frame3
	Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 8)

	local UIStroke = Instance.new("UIStroke", TextButton)

	UIStroke.Color = color32
	UIStroke.Thickness = 1
	UIStroke.Transparency = 0.4
	v22(TextButton, color33, 3, color3)

	return TextButton
end

local v54 = Frame4("–", -112)
local v55 = Frame4("···", -78)
local v56 = Frame4("×", -44)

v56.TextSize = 18
Frame4 = Instance.new("Frame")
Frame4.Size = UDim2.new(1, -32, 0, 1)
Frame4.Position = UDim2.new(0, 16, 0, 64)
Frame4.BackgroundColor3 = color3
Frame4.Parent = Frame
Instance.new("UIGradient", Frame4).Color = ColorSequence.new(color3, color32)

local Frame6 = Instance.new("Frame")

Frame6.Size = UDim2.new(1, 0, 1, -64)
Frame6.Position = UDim2.new(0, 0, 0, 64)
Frame6.BackgroundTransparency = 1
Frame6.ClipsDescendants = true
Frame6.Parent = Frame
Frame4 = Instance.new("TextLabel")
Frame4.Size = UDim2.new(0, 180, 0, 12)
Frame4.Position = UDim2.new(0, 20, 0, 14)
Frame4.BackgroundTransparency = 1
Frame4.Text = "ROLLED COLORS"
Frame4.Font = Enum.Font.GothamBold
Frame4.TextSize = 9
Frame4.TextColor3 = Color3.fromRGB(200, 150, 165)
Frame4.TextXAlignment = Enum.TextXAlignment.Left
Frame4.Parent = Frame6
Frame4 = Instance.new("TextLabel")
Frame4.Size = UDim2.new(0, 180, 0, 12)
Frame4.Position = UDim2.new(0, 180, 0, 14)
Frame4.BackgroundTransparency = 1
Frame4.Text = "TAP THE DICE TO CHANGE"
Frame4.Font = Enum.Font.GothamBold
Frame4.TextSize = 9
Frame4.TextColor3 = Color3.fromRGB(200, 150, 165)
Frame4.TextXAlignment = Enum.TextXAlignment.Right
Frame4.Parent = Frame6
Frame4 = Instance.new("Frame")
Frame4.Size = UDim2.new(1, -40, 0, 98)
Frame4.Position = UDim2.new(0, 20, 0, 36)
Frame4.BackgroundTransparency = 1
Frame4.Parent = Frame6

local t8 = {}

for i = 1, 4 do
	local TextButton = Instance.new("TextButton")

	TextButton.AnchorPoint = Vector2.new(0.5, 0.5)
	TextButton.Position = UDim2.new(0, (i - 1) * 96 + 36, 0, 36)
	TextButton.Size = UDim2.new(0, 72, 0, 72)
	TextButton.BackgroundColor3 = t1[t3[i]]
	TextButton.Text = ""
	TextButton.AutoButtonColor = false
	TextButton.Parent = Frame4
	Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 16)
	Players = Instance.new("UIStroke", TextButton)
	Players.Color = Color3.fromRGB(255, 255, 255)
	Players.Thickness = 1.5
	Players.Transparency = 0.85

	local UIStroke = Instance.new("UIStroke", TextButton)

	UIStroke.Color = Color3.new(1, 1, 1)
	UIStroke.Thickness = 0
	UIStroke.Transparency = 1

	local UIStroke2 = Instance.new("UIStroke", TextButton)

	UIStroke2.Color = Color3.new(1, 1, 1)
	UIStroke2.Thickness = 0
	UIStroke2.Transparency = 1
	Players = Instance.new("TextLabel")
	Players.Size = UDim2.new(0, 12, 0, 12)
	Players.Position = UDim2.new(0, 9, 0, 6)
	Players.BackgroundTransparency = 1
	Players.Text = tostring(i)
	Players.Font = Enum.Font.GothamBold
	Players.TextSize = 10
	Players.TextColor3 = Color3.new(1, 1, 1)
	Players.TextTransparency = 0.2
	Players.Parent = TextButton
	v104 = Instance.new("Frame")
	v104.Size = UDim2.new(0, 14, 0, 14)
	v104.AnchorPoint = Vector2.new(0.5, 0.5)
	v104.Position = UDim2.new(0.5, 0, 0.5, 0)
	v104.BackgroundColor3 = Color3.new(1, 1, 1)
	v104.Parent = TextButton
	Instance.new("UICorner", v104).CornerRadius = UDim.new(0, 7)
	v86 = Instance.new("TextLabel")
	v86.Size = UDim2.new(0, 72, 0, 14)
	v86.AnchorPoint = Vector2.new(0.5, 0)
	v86.Position = UDim2.new(0, (i - 1) * 96 + 36, 0, 78)
	v86.BackgroundTransparency = 1
	v86.Text = t3[i]
	v86.Font = Enum.Font.Gotham
	v86.TextSize = 11
	v86.TextColor3 = Color3.fromRGB(200, 170, 180)
	v86.TextXAlignment = Enum.TextXAlignment.Center
	v86.Parent = Frame4
	t8[i] = {
		btn = TextButton,
		dot = v104,
		num = Players,
		label = v86
	}
	TextButton.MouseEnter:Connect(function()
		local v63 = TweenService
		local v64 = TextButton
		local tweenInfo = TweenInfo.new(0.15)
		local t9 = {
			Size = UDim2.new(0, 78, 0, 78)
		}

		v63.Create(v63, v64, tweenInfo, t9):Play()
		TweenService:Create(UIStroke, TweenInfo.new(0.18), {
			Thickness = 4,
			Transparency = 0.05
		}):Play()
		TweenService:Create(UIStroke2, TweenInfo.new(0.18), {
			Thickness = 10,
			Transparency = 0.85
		}):Play()
	end)
	TextButton.MouseLeave:Connect(function()
		local v67 = TweenService
		local v68 = TextButton
		local tweenInfo = TweenInfo.new(0.15)
		local UDim2_ = UDim2

		v67.Create(v67, v68, tweenInfo, {
			Size = UDim2_.new(0, 72, 0, 72)
		}):Play()
		TweenService:Create(UIStroke, TweenInfo.new(0.22), {
			Thickness = 0,
			Transparency = 1
		}):Play()

		local v71 = TweenService
		local v72 = UIStroke2
		local tweenInfo2 = TweenInfo.new(0.22)

		v71.Create(v71, v72, tweenInfo2, {
			Thickness = 0,
			Transparency = 1
		}):Play()
	end)
end

local TextButton = Instance.new("TextButton")

TextButton.Size = UDim2.new(1, -40, 0, 48)
TextButton.Position = UDim2.new(0, 20, 0, 140)
TextButton.BackgroundColor3 = color3
TextButton.Text = ""
TextButton.AutoButtonColor = false
TextButton.ZIndex = 2
TextButton.Parent = Frame6
Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, 12)

local UIGradient2 = Instance.new("UIGradient", TextButton)

UIGradient2.Color = ColorSequence.new(color3, color32)
task.spawn(function()
	local rotation = 0

	while TextButton.Parent do
		rotation = (rotation + 2) % 360
		UIGradient2.Rotation = rotation
		task.wait(0.05)
	end
end)

local TextLabel = Instance.new("TextLabel")

TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "PREDICT NEXT ROLL"
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 14
TextLabel.TextColor3 = Color3.new(1, 1, 1)
TextLabel.Parent = TextButton

local UIStroke = Instance.new("UIStroke", TextButton)

UIStroke.Color = color33
UIStroke.Thickness = 0
UIStroke.Transparency = 1

local UIStroke2 = Instance.new("UIStroke", TextButton)

UIStroke2.Color = color33
UIStroke2.Thickness = 0
UIStroke2.Transparency = 1

local u80 = false

TextButton.MouseEnter:Connect(function()
	u80 = true

	local v81 = TweenService
	local v82 = TextButton
	local tweenInfo = TweenInfo.new(0.15)
	local UDim2_ = UDim2

	v81.Create(v81, v82, tweenInfo, {
		Size = UDim2_.new(1, -36, 0, 50)
	}):Play()

	local v85 = TweenService
	local v87 = UIStroke
	local tweenInfo2 = TweenInfo.new(0.18)

	v85.Create(v85, v87, tweenInfo2, {
		Thickness = 4,
		Transparency = 0.05
	}):Play()
	TweenService:Create(UIStroke2, TweenInfo.new(0.18), {
		Thickness = 12,
		Transparency = 0.82
	}):Play()
end)
TextLabel = TextButton.MouseLeave

local function parent()
	u80 = false

	local v89 = TweenService
	local v90 = TextButton
	local tweenInfo = TweenInfo.new(0.15)
	local uDim2New = UDim2.new

	v89.Create(v89, v90, tweenInfo, {
		Size = uDim2New(1, -40, 0, 48)
	}):Play()
	TweenService:Create(UIStroke, TweenInfo.new(0.22), {
		Thickness = 0,
		Transparency = 1
	}):Play()

	local v93 = TweenService
	local v94 = UIStroke2
	local tweenInfo2 = TweenInfo.new(0.22)

	v93.Create(v93, v94, tweenInfo2, {
		Thickness = 0,
		Transparency = 1
	}):Play()
end

TextLabel.Connect(TextLabel, parent)
TextButton.MouseButton1Down:Connect(function()
	local v96 = TweenService
	local v97 = TextButton
	local tweenInfo = TweenInfo.new(0.08)
	local UDim2_ = UDim2

	v96.Create(v96, v97, tweenInfo, {
		Size = UDim2_.new(1, -44, 0, 44)
	}):Play()
end)
TextButton.MouseButton1Up:Connect(function()
	local uDim2 = u80

	if not uDim2 then
		v110 = uDim2 or UDim2.new(1, -40, 0, 48)
		v111 = TweenService
		v112 = TextButton
		v113 = TweenInfo.new(0.08)
		v111.Create(v111, v112, v113, {
			Size = v110
		}):Play()

		return
	end

	uDim2 = UDim2.new(1, -36, 0, 50)

	local uDim22 = uDim2 or UDim2.new(1, -40, 0, 48)
	local v102 = TweenService
	local v103 = TextButton
	local tweenInfo = TweenInfo.new(0.08)

	v102.Create(v102, v103, tweenInfo, {
		Size = uDim22
	}):Play()
end)
TextLabel = Instance.new("Frame")
TextLabel.Size = UDim2.new(1, -40, 0, 100)
TextLabel.Position = UDim2.new(0, 20, 0, 200)
TextLabel.BackgroundColor3 = Color3.fromRGB(36, 18, 26)
TextLabel.BackgroundTransparency = 0
TextLabel.Parent = Frame6
Instance.new("UICorner", TextLabel).CornerRadius = UDim.new(0, 12)
parent = Instance.new("UIStroke", TextLabel)
parent.Color = color32
parent.Thickness = 1
parent.Transparency = 0.4
parent = Instance.new("TextLabel")
parent.Size = UDim2.new(0, 200, 0, 12)
parent.Position = UDim2.new(0, 16, 0, 12)
parent.BackgroundTransparency = 1
parent.Text = "NEXT ROLL PREDICTION"
parent.Font = Enum.Font.GothamBold
parent.TextSize = 9
parent.TextColor3 = Color3.fromRGB(200, 150, 165)
parent.TextXAlignment = Enum.TextXAlignment.Left
parent.Parent = TextLabel
parent = Instance.new("TextLabel")
parent.Size = UDim2.new(0, 114, 0, 12)
parent.Position = UDim2.new(0, 230, 0, 12)
parent.BackgroundTransparency = 1
parent.Text = "CHANCE"
parent.Font = Enum.Font.GothamBold
parent.TextSize = 9
parent.TextColor3 = Color3.fromRGB(200, 150, 165)
parent.TextXAlignment = Enum.TextXAlignment.Left
parent.Parent = TextLabel

local Frame7 = Instance.new("Frame")

Frame7.Size = UDim2.new(0, 52, 0, 52)
Frame7.Position = UDim2.new(0, 16, 0, 34)
Frame7.BackgroundColor3 = Color3.fromRGB(52, 26, 36)
Frame7.Parent = TextLabel
Instance.new("UICorner", Frame7).CornerRadius = UDim.new(0, 10)
parent = Instance.new("UIStroke", Frame7)
parent.Color = color32
parent.Thickness = 1
parent.Transparency = 0.4

local TextLabel2 = Instance.new("TextLabel")

TextLabel2.Size = UDim2.new(1, 0, 1, 0)
TextLabel2.BackgroundTransparency = 1
TextLabel2.Text = "?"
TextLabel2.Font = Enum.Font.GothamBold
TextLabel2.TextSize = 20
TextLabel2.TextColor3 = Color3.fromRGB(200, 160, 175)
TextLabel2.Parent = Frame7

local Frame8 = Instance.new("Frame")

Frame8.Size = UDim2.new(0, 14, 0, 14)
Frame8.AnchorPoint = Vector2.new(0.5, 0.5)
Frame8.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame8.BackgroundColor3 = Color3.new(1, 1, 1)
Frame8.Visible = false
Frame8.Parent = Frame7
Instance.new("UICorner", Frame8).CornerRadius = UDim.new(0, 7)

local TextLabel3 = Instance.new("TextLabel")

TextLabel3.Size = UDim2.new(0, 150, 0, 30)
TextLabel3.Position = UDim2.new(0, 82, 0, 34)
TextLabel3.BackgroundTransparency = 1
TextLabel3.Text = "—"
TextLabel3.Font = Enum.Font.GothamBold
TextLabel3.TextSize = 24
TextLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel3.TextXAlignment = Enum.TextXAlignment.Left
TextLabel3.Parent = TextLabel
parent = Instance.new("Frame")
parent.Size = UDim2.new(0, 90, 0, 1)
parent.Position = UDim2.new(0, 254, 0, 70)
parent.BackgroundColor3 = Color3.fromRGB(140, 100, 120)
parent.BackgroundTransparency = 0.5
parent.Parent = TextLabel

local TextLabel4 = Instance.new("TextLabel")

TextLabel4.Size = UDim2.new(0, 160, 0, 16)
TextLabel4.Position = UDim2.new(0, 82, 0, 66)
TextLabel4.BackgroundTransparency = 1
TextLabel4.Text = "Waiting for first prediction"
TextLabel4.Font = Enum.Font.Gotham
TextLabel4.TextSize = 11
TextLabel4.TextColor3 = Color3.fromRGB(200, 150, 165)
TextLabel4.TextXAlignment = Enum.TextXAlignment.Left
TextLabel4.Parent = TextLabel

local TextLabel5 = Instance.new("TextLabel")

TextLabel5.Size = UDim2.new(0, 100, 0, 30)
TextLabel5.Position = UDim2.new(0, 244, 0, 32)
TextLabel5.BackgroundTransparency = 1
TextLabel5.Text = ""
TextLabel5.Font = Enum.Font.GothamBold
TextLabel5.TextSize = 20
TextLabel5.TextColor3 = Color3.fromRGB(220, 190, 200)
TextLabel5.TextXAlignment = Enum.TextXAlignment.Left
TextLabel5.Parent = TextLabel
parent = Instance.new("Frame")
parent.Size = UDim2.new(0, 90, 0, 4)
parent.Position = UDim2.new(0, 254, 0, 72)
parent.BackgroundColor3 = Color3.fromRGB(52, 30, 40)
parent.Parent = TextLabel
Instance.new("UICorner", parent).CornerRadius = UDim.new(0, 2)

local Frame9 = Instance.new("Frame")

Frame9.Size = UDim2.new(0, 0, 1, 0)
Frame9.BackgroundColor3 = Color3.fromRGB(110, 220, 145)
Frame9.Parent = parent
Instance.new("UICorner", Frame9).CornerRadius = UDim.new(0, 2)

local Frame10 = Instance.new("Frame")

Frame10.Size = UDim2.new(1, -32, 0, 2)
Frame10.Position = UDim2.new(0, 16, 1, -6)
Frame10.BackgroundColor3 = Color3.fromRGB(80, 50, 60)
Frame10.Visible = false
Frame10.Parent = TextLabel
Instance.new("UICorner", Frame10).CornerRadius = UDim.new(0, 1)

local Frame11 = Instance.new("Frame")

Frame11.Size = UDim2.new(1, 0, 1, 0)
Frame11.BackgroundColor3 = color3
Frame11.Parent = Frame10
Instance.new("UICorner", Frame11).CornerRadius = UDim.new(0, 1)
Instance.new("UIGradient", Frame11).Color = ColorSequence.new(color3, color32)
parent = Instance.new("Frame")
parent.Size = UDim2.new(1, -40, 0, 60)
parent.Position = UDim2.new(0, 20, 0, 312)
parent.BackgroundColor3 = Color3.fromRGB(36, 18, 26)
parent.BackgroundTransparency = 0
parent.Parent = Frame6
Instance.new("UICorner", parent).CornerRadius = UDim.new(0, 12)
Frame4 = Instance.new("UIStroke", parent)
Frame4.Color = color32
Frame4.Thickness = 1
Frame4.Transparency = 0.4
Frame4 = Instance.new("TextLabel")
Frame4.Size = UDim2.new(0, 120, 0, 12)
Frame4.Position = UDim2.new(0, 16, 0, 11)
Frame4.BackgroundTransparency = 1
Frame4.Text = "HIT RATE"
Frame4.Font = Enum.Font.GothamBold
Frame4.TextSize = 9
Frame4.TextColor3 = Color3.fromRGB(200, 150, 165)
Frame4.TextXAlignment = Enum.TextXAlignment.Left
Frame4.Parent = parent

local TextLabel6 = Instance.new("TextLabel")

TextLabel6.Size = UDim2.new(0, 164, 0, 18)
TextLabel6.Position = UDim2.new(0, 180, 0, 7)
TextLabel6.BackgroundTransparency = 1
TextLabel6.Text = "—"
TextLabel6.Font = Enum.Font.GothamBold
TextLabel6.TextSize = 13
TextLabel6.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel6.TextXAlignment = Enum.TextXAlignment.Right
TextLabel6.Parent = parent
Frame4 = Instance.new("Frame")
Frame4.Size = UDim2.new(1, -32, 0, 6)
Frame4.Position = UDim2.new(0, 16, 0, 30)
Frame4.BackgroundColor3 = Color3.fromRGB(52, 30, 40)
Frame4.Parent = parent
Instance.new("UICorner", Frame4).CornerRadius = UDim.new(1, 0)

local Frame12 = Instance.new("Frame")

Frame12.Size = UDim2.new(0.5, 0, 1, 0)
Frame12.BackgroundColor3 = Color3.fromRGB(110, 220, 145)
Frame12.Parent = Frame4
Instance.new("UICorner", Frame12).CornerRadius = UDim.new(1, 0)

local Frame13 = Instance.new("Frame")

Frame13.AnchorPoint = Vector2.new(0.5, 0.5)
Frame13.Size = UDim2.new(0, 2, 1, 6)
Frame13.Position = UDim2.new(0.518, 0, 0.5, 0)
Frame13.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame13.Parent = Frame4

local TextLabel7 = Instance.new("TextLabel")

TextLabel7.Size = UDim2.new(0, 200, 0, 12)
TextLabel7.Position = UDim2.new(0, 16, 0, 42)
TextLabel7.BackgroundTransparency = 1
TextLabel7.Text = "No results yet"
TextLabel7.Font = Enum.Font.Gotham
TextLabel7.TextSize = 10
TextLabel7.TextColor3 = Color3.fromRGB(200, 150, 165)
TextLabel7.TextXAlignment = Enum.TextXAlignment.Left
TextLabel7.Parent = parent
Frame4 = Instance.new("TextLabel")
Frame4.Size = UDim2.new(0, 160, 0, 12)
Frame4.Position = UDim2.new(0, 184, 0, 42)
Frame4.BackgroundTransparency = 1
Frame4.Text = "| chance level 51.8%"
Frame4.Font = Enum.Font.Gotham
Frame4.TextSize = 10
Frame4.TextColor3 = Color3.fromRGB(200, 150, 165)
Frame4.TextXAlignment = Enum.TextXAlignment.Right
Frame4.Parent = parent
v22(TextLabel, color33, 2.5)
v22(parent, color33, 2.5)

local TextButton2 = Instance.new("TextButton")

TextButton2.Visible = false
TextButton2.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextButton2.BackgroundTransparency = 0.4
TextButton2.Text = ""
TextButton2.Size = UDim2.new(1, 0, 1, 0)
TextButton2.ZIndex = 20
TextButton2.AutoButtonColor = false
TextButton2.Parent = Frame

local Frame14 = Instance.new("Frame")

Frame14.Size = UDim2.new(0, 296, 0, 250)
Frame14.AnchorPoint = Vector2.new(0.5, 0.5)
Frame14.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame14.BackgroundColor3 = Color3.fromRGB(36, 18, 26)
Frame14.Parent = TextButton2
Instance.new("UICorner", Frame14).CornerRadius = UDim.new(0, 14)
TextLabel = Instance.new("UIStroke", Frame14)
TextLabel.Color = color32
TextLabel.Thickness = 1
TextLabel.Transparency = 0.4

local TextLabel8 = Instance.new("TextLabel")

TextLabel8.Size = UDim2.new(1, -70, 0, 20)
TextLabel8.Position = UDim2.new(0, 18, 0, 14)
TextLabel8.BackgroundTransparency = 1
TextLabel8.Text = "CHOOSE A COLOR • DICE 1"
TextLabel8.Font = Enum.Font.GothamBold
TextLabel8.TextSize = 12
TextLabel8.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel8.TextXAlignment = Enum.TextXAlignment.Left
TextLabel8.Parent = Frame14
TextLabel = Instance.new("TextButton")
TextLabel.Size = UDim2.new(0, 26, 0, 26)
TextLabel.Position = UDim2.new(1, -38, 0, 11)
TextLabel.BackgroundColor3 = Color3.fromRGB(120, 40, 60)
TextLabel.Text = "×"
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextSize = 17
TextLabel.TextColor3 = Color3.fromRGB(220, 190, 200)
TextLabel.AutoButtonColor = false
TextLabel.Parent = Frame14
Instance.new("UICorner", TextLabel).CornerRadius = UDim.new(0, 8)
v22(TextLabel, color33, 3)
parent = Instance.new("Frame")
parent.Size = UDim2.new(1, -24, 0, 1)
parent.Position = UDim2.new(0, 12, 0, 44)
parent.BackgroundColor3 = color32
parent.Parent = Frame14
parent = Instance.new("Frame")
parent.Size = UDim2.new(1, -32, 0, 180)
parent.Position = UDim2.new(0, 16, 0, 58)
parent.BackgroundTransparency = 1
parent.Parent = Frame14
Frame4 = Instance.new("UIGridLayout", parent)
Frame4.CellSize = UDim2.new(0, 80, 0, 84)
Frame4.CellPadding = UDim2.new(0, 12, 0, 10)
Frame4.HorizontalAlignment = Enum.HorizontalAlignment.Center
Frame4.SortOrder = Enum.SortOrder.LayoutOrder

local t10 = {}

for i, v in ipairs(t2) do
	v135 = Instance.new("Frame")
	v135.LayoutOrder = i
	v135.BackgroundTransparency = 1
	v135.Parent = parent
	i = Instance.new("TextButton")
	i.AnchorPoint = Vector2.new(0.5, 0)
	i.Position = UDim2.new(0.5, 0, 0, 2)
	i.Size = UDim2.new(0, 58, 0, 58)
	i.BackgroundColor3 = t1[v]
	i.BackgroundTransparency = 0
	i.Text = ""
	i.AutoButtonColor = false
	i.Parent = v135
	Instance.new("UICorner", i).CornerRadius = UDim.new(0, 14)
	v134 = Instance.new("UIStroke", i)
	v134.Color = Color3.new(0, 0, 0)
	v134.Thickness = 2.5
	v134.Transparency = 0.5
	v134 = Instance.new("Frame")
	v134.Size = UDim2.new(0, 10, 0, 10)
	v134.AnchorPoint = Vector2.new(0.5, 0.5)
	v134.Position = UDim2.new(0.5, 0, 0.5, 0)
	v134.BackgroundColor3 = Color3.new(1, 1, 1)
	v134.Parent = i
	Instance.new("UICorner", v134).CornerRadius = UDim.new(0, 5)
	v134 = Instance.new("TextLabel")
	v134.Size = UDim2.new(1, 0, 0, 14)
	v134.Position = UDim2.new(0, 0, 0, 66)
	v134.BackgroundTransparency = 1
	v134.Text = v
	v134.Font = Enum.Font.Gotham
	v134.TextSize = 11
	v134.TextColor3 = Color3.fromRGB(200, 170, 180)
	v134.Parent = v135
	v22(i, t1[v], 3.5)
	t10[v] = i
end

local Frame15 = Instance.new("Frame")

Frame15.Size = UDim2.new(0, 300, 0, 216)
Frame15.AnchorPoint = Vector2.new(0.5, 0.5)
Frame15.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame15.BackgroundColor3 = Color3.fromRGB(12, 6, 10)
Frame15.BackgroundTransparency = 0
Frame15.ZIndex = 30
Frame15.Visible = false
Frame15.Parent = Frame
Instance.new("UICorner", Frame15).CornerRadius = UDim.new(0, 14)

local UIStroke3 = Instance.new("UIStroke", Frame15)

UIStroke3.Color = color32
UIStroke3.Thickness = 1
UIStroke3.Transparency = 0.4
UIStroke3 = Instance.new("TextButton")
UIStroke3.Size = UDim2.new(0, 26, 0, 26)
UIStroke3.Position = UDim2.new(1, -38, 0, 11)
UIStroke3.BackgroundColor3 = Color3.fromRGB(12, 6, 10)
UIStroke3.BackgroundTransparency = 1
UIStroke3.Text = "×"
UIStroke3.Font = Enum.Font.GothamBold
UIStroke3.TextSize = 17
UIStroke3.TextColor3 = Color3.fromRGB(220, 190, 200)
UIStroke3.AutoButtonColor = false
UIStroke3.Parent = Frame15
Instance.new("UICorner", UIStroke3).CornerRadius = UDim.new(0, 8)
v22(UIStroke3, color33, 3)

local TextLabel9 = Instance.new("TextLabel")

TextLabel9.Size = UDim2.new(1, -50, 0, 20)
TextLabel9.Position = UDim2.new(0, 14, 0, 14)
TextLabel9.BackgroundTransparency = 1
TextLabel9.Text = "SETTINGS"
TextLabel9.Font = Enum.Font.GothamBold
TextLabel9.TextSize = 12
TextLabel9.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel9.TextXAlignment = Enum.TextXAlignment.Left
TextLabel9.Parent = Frame15
TextLabel9 = Instance.new("Frame")
TextLabel9.Size = UDim2.new(1, -36, 0, 48)
TextLabel9.Position = UDim2.new(0, 18, 0, 54)
TextLabel9.BackgroundTransparency = 1
TextLabel9.Parent = Frame15
parent = Instance.new("Frame")
parent.Size = UDim2.new(1, 0, 0, 1)
parent.Position = UDim2.new(0, 0, 1, 0)
parent.BackgroundColor3 = Color3.fromRGB(52, 32, 42)
parent.Parent = TextLabel9
parent = Instance.new("TextLabel")
parent.Size = UDim2.new(0.55, 0, 1, 0)
parent.BackgroundTransparency = 1
parent.Text = "Predicts History"
parent.Font = Enum.Font.GothamMedium
parent.TextSize = 12
parent.TextColor3 = Color3.fromRGB(255, 255, 255)
parent.TextXAlignment = Enum.TextXAlignment.Left
parent.Parent = TextLabel9
parent = Instance.new("TextButton")
parent.AnchorPoint = Vector2.new(1, 0.5)
parent.Position = UDim2.new(1, 0, 0.5, 0)
parent.Size = UDim2.new(0, 68, 0, 28)
parent.BackgroundColor3 = Color3.fromRGB(52, 26, 36)
parent.Text = "Open"
parent.Font = Enum.Font.Gotham
parent.TextSize = 11
parent.TextColor3 = Color3.fromRGB(255, 255, 255)
parent.AutoButtonColor = false
parent.Parent = TextLabel9
Instance.new("UICorner", parent).CornerRadius = UDim.new(0, 8)
TextLabel9 = Instance.new("UIStroke", parent)
TextLabel9.Color = color32
TextLabel9.Transparency = 0.4
TextLabel9.Thickness = 1
v22(parent, color33, 3, color3)
TextLabel9 = Instance.new("Frame")
TextLabel9.Size = UDim2.new(1, -36, 0, 48)
TextLabel9.Position = UDim2.new(0, 18, 0, 104)
TextLabel9.BackgroundTransparency = 1
TextLabel9.Parent = Frame15
Frame4 = Instance.new("Frame")
Frame4.Size = UDim2.new(1, 0, 0, 1)
Frame4.Position = UDim2.new(0, 0, 1, 0)
Frame4.BackgroundColor3 = Color3.fromRGB(52, 32, 42)
Frame4.Parent = TextLabel9
Frame4 = Instance.new("TextLabel")
Frame4.Size = UDim2.new(0.55, 0, 1, 0)
Frame4.BackgroundTransparency = 1
Frame4.Text = "UI Size"
Frame4.Font = Enum.Font.GothamMedium
Frame4.TextSize = 12
Frame4.TextColor3 = Color3.fromRGB(255, 255, 255)
Frame4.TextXAlignment = Enum.TextXAlignment.Left
Frame4.Parent = TextLabel9

local TextLabel10 = Instance.new("TextLabel")

TextLabel10.AnchorPoint = Vector2.new(1, 0.5)
TextLabel10.Position = UDim2.new(1, -122, 0.5, 0)
TextLabel10.Size = UDim2.new(0, 40, 0, 14)
TextLabel10.BackgroundTransparency = 1
TextLabel10.Text = string.format("%.2fx", scale)
TextLabel10.Font = Enum.Font.Gotham
TextLabel10.TextSize = 11
TextLabel10.TextColor3 = Color3.fromRGB(200, 170, 180)
TextLabel10.TextXAlignment = Enum.TextXAlignment.Right
TextLabel10.Parent = TextLabel9

local Frame16 = Instance.new("Frame")

Frame16.AnchorPoint = Vector2.new(1, 0.5)
Frame16.Position = UDim2.new(1, -2, 0.5, 0)
Frame16.Size = UDim2.new(0, 110, 0, 6)
Frame16.BackgroundColor3 = Color3.fromRGB(80, 50, 60)
Frame16.Parent = TextLabel9
Instance.new("UICorner", Frame16).CornerRadius = UDim.new(0, 3)

local Frame17 = Instance.new("Frame")

Frame17.Size = UDim2.new((scale - 0.7) / 0.6, 0, 1, 0)
Frame17.BackgroundColor3 = color3
Frame17.Parent = Frame16
Instance.new("UICorner", Frame17).CornerRadius = UDim.new(0, 3)
Instance.new("UIGradient", Frame17).Color = ColorSequence.new(color3, color32)

local TextButton3 = Instance.new("TextButton")

TextButton3.AnchorPoint = Vector2.new(0.5, 0.5)
TextButton3.Position = UDim2.new((scale - 0.7) / 0.6, 0, 0.5, 0)
TextButton3.Size = UDim2.new(0, 16, 0, 16)
TextButton3.BackgroundColor3 = color3
TextButton3.Text = ""
TextButton3.AutoButtonColor = false
TextButton3.Parent = Frame16
Instance.new("UICorner", TextButton3).CornerRadius = UDim.new(0, 8)
Instance.new("UIGradient", TextButton3).Color = ColorSequence.new(color3, color32)
TextLabel9 = Instance.new("Frame")
TextLabel9.Size = UDim2.new(1, -36, 0, 48)
TextLabel9.Position = UDim2.new(0, 18, 0, 154)
TextLabel9.BackgroundTransparency = 1
TextLabel9.Parent = Frame15
Frame4 = Instance.new("TextLabel")
Frame4.Size = UDim2.new(0.7, 0, 1, 0)
Frame4.BackgroundTransparency = 1
Frame4.Text = "Remove Expire Cooldown"
Frame4.Font = Enum.Font.GothamMedium
Frame4.TextSize = 12
Frame4.TextColor3 = Color3.fromRGB(255, 255, 255)
Frame4.TextXAlignment = Enum.TextXAlignment.Left
Frame4.Parent = TextLabel9

local TextButton4 = Instance.new("TextButton")

TextButton4.AnchorPoint = Vector2.new(1, 0.5)
TextButton4.Position = UDim2.new(1, 0, 0.5, 0)
TextButton4.Size = UDim2.new(0, 42, 0, 24)
TextButton4.BackgroundColor3 = Color3.fromRGB(52, 32, 42)
TextButton4.Text = ""
TextButton4.AutoButtonColor = false
TextButton4.Parent = TextLabel9
Instance.new("UICorner", TextButton4).CornerRadius = UDim.new(0, 12)

local UIStroke4 = Instance.new("UIStroke", TextButton4)

UIStroke4.Color = color32
UIStroke4.Thickness = 1
UIStroke4.Transparency = 0.4
v22(TextButton4, color33, 3)

local Frame18 = Instance.new("Frame")

Frame18.AnchorPoint = Vector2.new(0, 0.5)
Frame18.Position = UDim2.new(0, 3, 0.5, 0)
Frame18.Size = UDim2.new(0, 18, 0, 18)
Frame18.BackgroundColor3 = Color3.fromRGB(200, 180, 190)
Frame18.Parent = TextButton4
Instance.new("UICorner", Frame18).CornerRadius = UDim.new(0, 9)

local function v136()
	if u14 then
		local t11 = {
			BackgroundColor3 = color3
		}

		TweenService:Create(TextButton4, TweenInfo.new(0.2), t11):Play()

		local v137 = TweenService
		local v138 = Frame18
		local tweenInfo = TweenInfo.new(0.2)
		local uDim2 = UDim2.new(1, -21, 0.5, 0)
		local color34 = Color3.fromRGB

		v137.Create(v137, v138, tweenInfo, {
			Position = uDim2,
			BackgroundColor3 = color34(255, 255, 255)
		}):Play()
		UIStroke4.Color = color33
	else
		local v141 = TweenService
		local v142 = TextButton4
		local tweenInfo = TweenInfo.new(0.2)
		local Color3_ = Color3

		v141.Create(v141, v142, tweenInfo, {
			BackgroundColor3 = Color3_.fromRGB(52, 32, 42)
		}):Play()

		local v145 = TweenService
		local v146 = Frame18
		local tweenInfo2 = TweenInfo.new(0.2)
		local uDim2 = UDim2.new(0, 3, 0.5, 0)
		local color34 = Color3.fromRGB

		v145.Create(v145, v146, tweenInfo2, {
			Position = uDim2,
			BackgroundColor3 = color34(200, 180, 190)
		}):Play()
		UIStroke4.Color = color32
	end
end

TextButton4.MouseButton1Click:Connect(function()
	u14 = not u14
	v136()
end)

local TextButton5 = Instance.new("TextButton")

TextButton5.Visible = false
TextButton5.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
TextButton5.BackgroundTransparency = 0.28
TextButton5.Text = ""
TextButton5.Size = UDim2.new(1, 0, 1, 0)
TextButton5.ZIndex = 30
TextButton5.AutoButtonColor = false
TextButton5.Parent = Frame

local Frame19 = Instance.new("Frame")

Frame19.Size = UDim2.new(0, 330, 0, 380)
Frame19.AnchorPoint = Vector2.new(0.5, 0.5)
Frame19.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame19.BackgroundColor3 = Color3.fromRGB(20, 10, 15)
Frame19.BackgroundTransparency = 0
Frame19.Parent = TextButton5
Instance.new("UICorner", Frame19).CornerRadius = UDim.new(0, 14)
TextLabel9 = Instance.new("UIStroke", Frame19)
TextLabel9.Color = color32
TextLabel9.Thickness = 1
TextLabel9.Transparency = 0.4
TextLabel9 = Instance.new("TextLabel")
TextLabel9.Size = UDim2.new(1, -60, 0, 20)
TextLabel9.Position = UDim2.new(0, 14, 0, 14)
TextLabel9.BackgroundTransparency = 1
TextLabel9.Text = "PREDICTS HISTORY"
TextLabel9.Font = Enum.Font.GothamBold
TextLabel9.TextSize = 12
TextLabel9.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel9.TextXAlignment = Enum.TextXAlignment.Left
TextLabel9.Parent = Frame19

local TextLabel11 = Instance.new("TextLabel")

TextLabel11.Size = UDim2.new(0, 42, 0, 20)
TextLabel11.Position = UDim2.new(0, 132, 0, 14)
TextLabel11.BackgroundTransparency = 1
TextLabel11.Text = "·  0"
TextLabel11.Font = Enum.Font.GothamBold
TextLabel11.TextSize = 11
TextLabel11.TextColor3 = Color3.fromRGB(200, 180, 194)
TextLabel11.TextXAlignment = Enum.TextXAlignment.Left
TextLabel11.Parent = Frame19
TextLabel9 = Instance.new("Frame")
TextLabel9.Size = UDim2.new(1, -24, 0, 1)
TextLabel9.Position = UDim2.new(0, 12, 0, 42)
TextLabel9.BackgroundColor3 = color3
TextLabel9.Parent = Frame19
Instance.new("UIGradient", TextLabel9).Color = ColorSequence.new(color3, color32)
TextLabel9 = Instance.new("TextButton")
TextLabel9.Size = UDim2.new(0, 26, 0, 26)
TextLabel9.Position = UDim2.new(1, -38, 0, 11)
TextLabel9.BackgroundColor3 = Color3.fromRGB(120, 40, 60)
TextLabel9.Text = "×"
TextLabel9.Font = Enum.Font.GothamBold
TextLabel9.TextSize = 17
TextLabel9.TextColor3 = Color3.fromRGB(220, 190, 200)
TextLabel9.AutoButtonColor = false
TextLabel9.Parent = Frame19
Instance.new("UICorner", TextLabel9).CornerRadius = UDim.new(0, 8)
v22(TextLabel9, color33, 3)

local ScrollingFrame = Instance.new("ScrollingFrame")

ScrollingFrame.Size = UDim2.new(1, -24, 1, -60)
ScrollingFrame.Position = UDim2.new(0, 12, 0, 52)
ScrollingFrame.BackgroundTransparency = 1
ScrollingFrame.BorderSizePixel = 0
ScrollingFrame.ScrollBarThickness = 3
ScrollingFrame.ScrollBarImageColor3 = color3
ScrollingFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
ScrollingFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
ScrollingFrame.ScrollingDirection = Enum.ScrollingDirection.Y
ScrollingFrame.ElasticBehavior = Enum.ElasticBehavior.WhenScrollable
ScrollingFrame.Parent = Frame19
Frame4 = Instance.new("UIListLayout", ScrollingFrame)
Frame4.SortOrder = Enum.SortOrder.LayoutOrder

local function v154(p10, p11)
	local Frame20 = Instance.new("Frame")

	Frame20.Size = UDim2.new(1, -6, 0, 44)
	Frame20.BackgroundColor3 = Color3.fromRGB(32, 16, 24)
	Frame20.LayoutOrder = -p11
	Frame20.Parent = ScrollingFrame
	Instance.new("UICorner", Frame20).CornerRadius = UDim.new(0, 8)

	local TextLabel12 = Instance.new("TextLabel")

	TextLabel12.Size = UDim2.new(0, 34, 1, 0)
	TextLabel12.Position = UDim2.new(0, 10, 0, 0)
	TextLabel12.BackgroundTransparency = 1
	TextLabel12.Text = "#" .. p11
	TextLabel12.Font = Enum.Font.GothamBold
	TextLabel12.TextSize = 10
	TextLabel12.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel12.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel12.Parent = Frame20

	for i = 1, 4 do
		local Frame21 = Instance.new("Frame")

		Frame21.Size = UDim2.new(0, 20, 0, 20)
		Frame21.Position = UDim2.new(0, (i - 1) * 24 + 46, 0.5, -10)
		Frame21.BackgroundColor3 = t1[p10.picks[i]] or Color3.new(1, 1, 1)
		Frame21.Parent = Frame20
		Instance.new("UICorner", Frame21).CornerRadius = UDim.new(0, 6)

		local Frame22 = Instance.new("Frame")

		Frame22.Size = UDim2.new(0, 5, 0, 5)
		Frame22.AnchorPoint = Vector2.new(0.5, 0.5)
		Frame22.Position = UDim2.new(0.5, 0, 0.5, 0)
		Frame22.BackgroundColor3 = Color3.new(1, 1, 1)
		Frame22.Parent = Frame21
		Instance.new("UICorner", Frame22).CornerRadius = UDim.new(1, 0)
	end

	local prediction = p10.prediction or "—"
	local Frame21 = Instance.new("Frame")

	Frame21.Size = UDim2.new(0, 7, 0, 7)
	Frame21.AnchorPoint = Vector2.new(0.5, 0.5)
	Frame21.Position = UDim2.new(0, 164, 0.5, 0)
	Frame21.BackgroundColor3 = t1[prediction] or Color3.fromRGB(140, 140, 150)
	Frame21.Parent = Frame20
	Instance.new("UICorner", Frame21).CornerRadius = UDim.new(1, 0)

	local TextLabel13 = Instance.new("TextLabel")

	TextLabel13.Size = UDim2.new(0, 58, 0, 18)
	TextLabel13.Position = UDim2.new(0, 174, 0.5, -9)
	TextLabel13.BackgroundTransparency = 1
	TextLabel13.Text = prediction
	TextLabel13.Font = Enum.Font.GothamBold
	TextLabel13.TextSize = 10
	TextLabel13.TextColor3 = t1[prediction] or Color3.fromRGB(160, 160, 170)
	TextLabel13.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel13.Parent = Frame20

	local TextLabel14 = Instance.new("TextLabel")

	TextLabel14.Size = UDim2.new(0, 56, 0, 20)
	TextLabel14.AnchorPoint = Vector2.new(1, 0.5)
	TextLabel14.Position = UDim2.new(1, -10, 0.5, 0)
	TextLabel14.BackgroundColor3 = Color3.fromRGB(54, 34, 44)
	TextLabel14.Text = p10.result or "PENDING"
	TextLabel14.Font = Enum.Font.GothamBold
	TextLabel14.TextSize = 9
	TextLabel14.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel14.Parent = Frame20
	Instance.new("UICorner", TextLabel14).CornerRadius = UDim.new(0, 6)

	if p10.result == "HIT" then
		TextLabel14.BackgroundColor3 = Color3.fromRGB(34, 75, 57)
		TextLabel14.TextColor3 = Color3.fromRGB(116, 226, 166)

		return
	end

	if p10.result ~= "MISS" then
		return
	end

	TextLabel14.BackgroundColor3 = Color3.fromRGB(78, 43, 52)
	TextLabel14.TextColor3 = Color3.fromRGB(255, 122, 137)
end
local function v164()
	if #t4 == 0 then
		return t2[math.random(#t2)], math.random(50, 63)
	end

	local v165, v166, v167 = ipairs(t2)
	local t12 = {}
	local t13 = {}

	while true do
		local v170

		v167, v170 = v165(v166, v167)

		if not v167 then
			break
		end

		t12[v170] = 0
		t13[v170] = 0
	end

	local v171, v172, v173 = ipairs(t4)

	while true do
		local v174

		v173, v174 = v171(v172, v173)

		if not v173 then
			break
		end

		for i = 1, 4 do
			if v174.picks[i] then
				t12[v174.picks[i]] = t12[v174.picks[i]] + 1
			end
		end
	end

	local v176, v177, v178 = ipairs(t2)

	while true do
		local v179

		v178, v179 = v176(v177, v178)

		if not v178 then
			local v180 = -math.huge
			local t14 = {}

			for _, v in ipairs(t2) do
				local v184 = t13[v] + 1 / (1 + t12[v]) + math.random()

				if v180 < v184 then
					v180 = v184
					t14 = { v }
				else
					local v185 = v184 - v180

					if math.abs(v185) < 0.001 then
						table.insert(t14, v)
					end
				end
			end

			return t14[math.random(1, #t14)], math.random(50, 63)
		end

		local _
		-- NumForInit
local v189, n3, n4 = #t4, 1, -1

-- end NumForInit
		while true do
			local v192 = v189 + n4

			if (0 >= n4 or v192 > n3) and (n4 > 0 or n3 > v192) then
				break
			end

			v189 = v192

			local v193 = false

			for i = 1, 4 do
				if t4[v192].picks[i] == v179 then
					v193 = true

					break
				end
			end

			if v193 then
				break
			end

			t13[v179] = t13[v179] + 1

			continue
		end

		continue
	end
end

Frame4.Padding = UDim.new(0, 6)

local function v195()
	TextLabel3.Text = "—"
	TextLabel3.TextColor3 = Color3.fromRGB(255, 255, 255)
	TextLabel2.Visible = true
	Frame8.Visible = false
	Frame7.BackgroundColor3 = Color3.fromRGB(52, 26, 36)
	TextLabel5.Text = ""
	TextLabel4.Text = "Waiting for next roll"
	TextLabel4.TextColor3 = Color3.fromRGB(200, 150, 165)
	Frame9.Size = UDim2.new(0, 0, 1, 0)
end
local function v196(p12, p13)
	local v197 = t1[p13]
	local v198 = t8[p12]

	if v197 and v198 then
		t3[p12] = p13

		local ipairs_ = ipairs
		local btn = v198.btn

		for _, child in ipairs_(btn.GetChildren(btn)) do
			if child:IsA("UIGradient") then
				child:Destroy()
			end
		end

		v198.btn.BackgroundColor3 = v197
		v198.btn.BackgroundTransparency = 0
		v198.label.Text = p13
	end
end
local function v203(p14, p15, p16)
	TextLabel3.Text = p14
	TextLabel3.TextColor3 = t1[p14] or Color3.new(1, 1, 1)
	TextLabel2.Visible = false
	Frame8.Visible = true
	Frame7.BackgroundColor3 = t1[p14] or Color3.fromRGB(52, 26, 36)
	TextLabel5.Text = tostring(p15) .. "%"
	TextLabel4.Text = p16
	TextLabel4.TextColor3 = Color3.fromRGB(200, 150, 165)
	Color3.fromRGB(110, 220, 145)

	local color34

	if p15 >= 70 then
		color34 = Color3.fromRGB(110, 220, 145)
	elseif p15 >= 50 then
		color34 = Color3.fromRGB(220, 200, 100)
	else
		color34 = Color3.fromRGB(220, 110, 110)
	end

	TextLabel5.TextColor3 = color34
	Frame9.BackgroundColor3 = color34
	Frame9.Size = UDim2.new(0, 0, 1, 0)

	local v205 = TweenService
	local v206 = Frame9
	local tweenInfoNew = TweenInfo.new

	v205.Create(v205, v206, tweenInfoNew(0.4), {
		Size = UDim2.new(p15 / 100, 0, 1, 0)
	}):Play()

	local v208 = TweenService
	local v209 = Frame7
	local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Back)

	v208.Create(v208, v209, tweenInfo, {
		Size = UDim2.new(0, 56, 0, 56)
	}):Play()
	task.delay(0.2, function()
		local v211 = TweenService
		local v212 = Frame7
		local tweenInfo2 = TweenInfo.new(0.2)
		local UDim2_ = UDim2

		v211.Create(v211, v212, tweenInfo2, {
			Size = UDim2_.new(0, 52, 0, 52)
		}):Play()
	end)
end
local function v215()
	local v216 = ScrollingFrame

	for _, child in ipairs(v216.GetChildren(v216)) do
		if child:IsA("Frame") then
			child:Destroy()
		end
	end
end
local function v219()
	local v220 = 0 + n1

	if v220 == 0 then
		TextLabel6.Text = "—"
		TextLabel7.Text = "No results yet"
		Frame12.Size = UDim2.new(0.5, 0, 1, 0)
	else
		local v221 = 0 / v220

		TextLabel6.Text = string.format("%.1f%%", v221 * 100)
		TextLabel7.Text = string.format("%d / %d hits • streak %d", 0, v220, 0)

		local v222 = TweenService
		local v223 = Frame12
		local tweenInfo = TweenInfo.new(0.4)
		local uDim2New = UDim2.new

		v222.Create(v222, v223, tweenInfo, {
			Size = uDim2New(v221, 0, 1, 0)
		}):Play()

		local color34 = Color3.fromRGB(110, 220, 145)

		if v221 < 0.4 then
			color34 = Color3.fromRGB(220, 110, 110)
		else
			if not (v221 < 0.55) then
				Frame12.BackgroundColor3 = color34
				TextLabel6.TextColor3 = color34

				return
			end

			color34 = Color3.fromRGB(220, 200, 100)
		end

		Frame12.BackgroundColor3 = color34
		TextLabel6.TextColor3 = color34
	end
end
local function v227()
	v215()

	local v228 = TextLabel11
	local v229 = #t4

	v228.Text = "·  " .. tostring(v229)

	if #t4 == 0 then
		local TextLabel12 = Instance.new("TextLabel")

		TextLabel12.Size = UDim2.new(1, 0, 0, 80)
		TextLabel12.BackgroundTransparency = 1
		TextLabel12.Text = "No predictions yet"
		TextLabel12.Font = Enum.Font.Gotham
		TextLabel12.TextSize = 11
		TextLabel12.TextColor3 = Color3.fromRGB(200, 150, 165)
		TextLabel12.Parent = ScrollingFrame
	else
		for i = #t4, 1, -1 do
			v154(t4[i], i)
		end

		ScrollingFrame.CanvasPosition = Vector2.new(0, 0)
	end
end

Frame4 = function()
	local t15 = {}

	for i = 1, 4 do
		t15[i] = t3[i]
	end

	local t16 = {
		picks = t15,
		result = "PENDING",
		confidence = 0
	}
	local v235, v236 = v164()
	local v237 = t4

	table.insert(v237, t16)

	local _ = n2 + 1

	t16.prediction = v235
	t16.confidence = v236
	v203(v235, v236, string.format("Based on %d rolls", #t4))

	local v239 = false

	for i = 1, 4 do
		if t15[i] == v235 then
			v239 = true

			break
		end
	end

	if #t4 == 1 and true or v239 then
		t16.result = "HIT"
	else
		t16.result = "MISS"

		local _ = n1 + 1
	end

	v219()

	if TextButton5.Visible then
		v227()
	end

	if u14 then
		Frame10.Visible = false

		return
	end

	Frame10.Visible = true
	Frame11.Size = UDim2.new(1, 0, 1, 0)
	Frame11.BackgroundColor3 = color3

	local v242 = TweenService
	local v243 = Frame11
	local tweenInfo = TweenInfo.new(3, Enum.EasingStyle.Linear)
	local UDim2_ = UDim2

	v242.Create(v242, v243, tweenInfo, {
		Size = UDim2_.new(0, 0, 1, 0)
	}):Play()
	task.spawn(function()
		for i = 3, 1, -1 do
			TextLabel4.Text = string.format("Expires in %ds", i)
			TextLabel4.TextColor3 = Color3.fromRGB(220, 200, 100)
			task.wait(1)
		end

		Frame10.Visible = false
		v195()
	end)
end
Frame13 = TextButton.MouseButton1Click

local function v247()
	TextButton2.Visible = false
end

Frame13.Connect(Frame13, Frame4)

local n5 = 1

local function v249(p17)
	n5 = p17
	TextLabel8.Text = "CHOOSE A COLOR • DICE " .. p17
	TextButton2.Visible = true
	Frame14.Size = UDim2.new(0, 250, 0, 210)

	local v250 = TweenService
	local v251 = Frame14
	local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Back)

	v250.Create(v250, v251, tweenInfo, {
		Size = UDim2.new(0, 296, 0, 250)
	}):Play()
end

local v253 = n5

for i = 1, 4 do
	t8[i].btn.MouseButton1Click:Connect(function()
		v249(i)
	end)
end

for i, v in ipairs(t2) do
	i = t10[v]
	i.BackgroundColor3 = t1[v]
	i.MouseButton1Click:Connect(function()
		v196(v253, v)

		local btn = t8[v253].btn
		local v258 = TweenService
		local tweenInfo = TweenInfo.new(0.15)
		local UDim2_ = UDim2

		v258.Create(v258, btn, tweenInfo, {
			Size = UDim2_.new(0, 76, 0, 76)
		}):Play()

		local function v261()
			local Parent = btn

			if Parent then
				Parent = btn.Parent
			end

			if not Parent then
				return
			end

			local v263 = TweenService
			local v264 = btn
			local tweenInfo2 = TweenInfo.new(0.15)

			v263.Create(v263, v264, tweenInfo2, {
				Size = UDim2.new(0, 72, 0, 72)
			}):Play()
		end

		task.delay(0.15, v261)
		v247()
	end)
end

TextLabel.MouseButton1Click:Connect(v247)
TextButton2.MouseButton1Click:Connect(v247)
v54.MouseButton1Click:Connect(function()
	local v266 = TweenService
	local v267 = Frame
	local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quart)
	local UDim2_ = UDim2

	v266.Create(v266, v267, tweenInfo, {
		Size = UDim2_.new(0, 392, 0, 64)
	}):Play()
	Frame6.Visible = false
end)
v55.MouseButton1Click:Connect(function()
	Frame15.Visible = not Frame15.Visible

	if not Frame15.Visible then
		return
	end

	Frame15.Size = UDim2.new(0, 260, 0, 190)

	local v270 = TweenService
	local v271 = Frame15
	local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Back)

	v270.Create(v270, v271, tweenInfo, {
		Size = UDim2.new(0, 300, 0, 216)
	}):Play()
end)
v56.MouseButton1Click:Connect(function()
	local v273 = TweenService
	local v274 = Frame
	local tweenInfo = TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In)
	local uDim2 = UDim2.new(0, 0, 0, 0)
	local UDim2_ = UDim2
	local v278 = v273.Create(v273, v274, tweenInfo, {
		Size = uDim2,
		Position = UDim2_.new(0.5, 0, 0.5, 0),
		BackgroundTransparency = 1
	})
	local tween = TweenService:Create(Frame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
		Rotation = 25
	})
	local tween2 = TweenService:Create(UIScale, TweenInfo.new(0.35, Enum.EasingStyle.Back, Enum.EasingDirection.In), {
		Scale = 0
	})

	v278:Play()
	tween:Play()
	tween2:Play()
	task.wait(0.35)
	ScreenGui:Destroy()
end)
UIStroke3.MouseButton1Click:Connect(function()
	Frame15.Visible = false
end)
parent.MouseButton1Click:Connect(function()
	Frame15.Visible = false
	TextButton5.Visible = true
	v227()
	Frame19.Size = UDim2.new(0, 280, 0, 330)

	local v281 = TweenService
	local v282 = Frame19
	local tweenInfo = TweenInfo.new(0.18, Enum.EasingStyle.Back)

	v281.Create(v281, v282, tweenInfo, {
		Size = UDim2.new(0, 330, 0, 380)
	}):Play()
end)
TextLabel9.MouseButton1Click:Connect(function()
	TextButton5.Visible = false
end)
TextButton5.MouseButton1Click:Connect(function()
	TextButton5.Visible = false
end)

local function v284(p18)
	local v285 = math.clamp((p18 - Frame16.AbsolutePosition.X) / Frame16.AbsoluteSize.X, 0, 1)
	local v286 = (v285 * 0.6 + 0.7) * 100

	scale = math.floor(v286) / 100
	UIScale.Scale = scale
	TextLabel10.Text = string.format("%.2fx", scale)
	Frame17.Size = UDim2.new(v285, 0, 1, 0)
	TextButton3.Position = UDim2.new(v285, 0, 0.5, 0)
end

local u287 = false

Frame16.InputBegan:Connect(function(input)
	if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	u287 = true
	v284(input.Position.X)
end)
TextButton3.InputBegan:Connect(function(input)
	if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	u287 = true
end)
UserInputService.InputChanged:Connect(function(input)
	local v288 = u287

	if v288 then
		v288 = input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch
	end

	if not v288 then
		return
	end

	v284(input.Position.X)
end)
UserInputService.InputEnded:Connect(function(input)
	local _ = input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch
end)

local u290 = false
local Position = nil
local Position2 = nil

Frame3.InputBegan:Connect(function(input)
	if not (input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch) then
		return
	end

	local mouseLocation = UserInputService:GetMouseLocation()
	local t17 = { v54, v55, v56 }

	for _, v in ipairs(t17) do
		local AbsolutePosition = v.AbsolutePosition
		local AbsoluteSize = v.AbsoluteSize
		local v299 = mouseLocation.X >= AbsolutePosition.X

		if v299 then
			v299 = mouseLocation.X <= AbsolutePosition.X + AbsoluteSize.X

			if v299 then
				if mouseLocation.Y >= AbsolutePosition.Y then
					v299 = mouseLocation.Y <= AbsolutePosition.Y + AbsoluteSize.Y
				else
					v299 = false
				end
			end
		end

		if v299 then
			return
		end
	end

	u290 = true
	Position = input.Position
	Position2 = Frame.Position
end)
UserInputService.InputChanged:Connect(function(input)
	local v300 = u290

	if v300 then
		v300 = input.UserInputType == Enum.UserInputType.MouseMovement and true or input.UserInputType == Enum.UserInputType.Touch
	end

	if not v300 then
		return
	end

	local v301 = input.Position - Position

	Frame.Position = UDim2.new(Position2.X.Scale, Position2.X.Offset + v301.X, Position2.Y.Scale, Position2.Y.Offset + v301.Y)
end)
UserInputService.InputEnded:Connect(function(input)
	local _ = input.UserInputType == Enum.UserInputType.MouseButton1 and true or input.UserInputType == Enum.UserInputType.Touch
end)
v136()
