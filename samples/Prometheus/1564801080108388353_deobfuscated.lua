-- This file was generated at discord.gg/syncrypt

local unpack_ = unpack or table.unpack
local Players = game:GetService("Players")
local t1 = {
	value1 = game:GetService("RunService"),
	value2 = game:GetService("UserInputService"),
	value3 = game:GetService("Workspace")
}
local ReplicatedStorage = game:GetService("ReplicatedStorage")

t1.value4 = game:GetService("CollectionService")

local game_ = game

game_.GetService(game_, "TweenService")
t1.value5 = game:GetService("ProximityPromptService")
t1.value6 = game:GetService("TeleportService")
t1.value7 = game:GetService("HttpService")
t1.value8 = Players.LocalPlayer
t1.value9 = t1.value8:WaitForChild("PlayerGui")
pcall(function()
	if not getgenv().AzureSteal_Unload then
		return
	end

	getgenv().AzureSteal_Unload()
end)
t1.value10 = ReplicatedStorage:FindFirstChild("Remotes") or (ReplicatedStorage:FindFirstChild("RemoteEvents") or ReplicatedStorage:WaitForChild("Remotes", 10))

local Game = t1.value10 and t1.value10:FindFirstChild("Game") or t1.value10

t1.value11 = nil
t1.value11 = Game or nil

function t1.value12(p1)
	if not t1.value11 then
		return nil
	end

	local value10 = t1.value11:FindFirstChild(p1)

	if value10 then
		return value10
	end

	value10 = t1.value10

	if not value10 then
		return value10
	end

	value10 = t1.value10:FindFirstChild(p1)

	return value10
end

t1.value13 = {
	bg = Color3.fromRGB(20, 20, 20),
	panel = Color3.fromRGB(28, 28, 28),
	section = Color3.fromRGB(36, 36, 36),
	element = Color3.fromRGB(44, 44, 44),
	accent = Color3.fromRGB(200, 200, 200),
	text = Color3.fromRGB(235, 235, 235),
	subtext = Color3.fromRGB(150, 150, 150),
	outline = Color3.fromRGB(60, 60, 60),
	good = Color3.fromRGB(120, 200, 120),
	bad = Color3.fromRGB(200, 100, 100)
}
t1.value14 = Instance.new("ScreenGui")
t1.value14.Name = "Azure_StealAEgg"
t1.value14.ResetOnSpawn = false
t1.value14.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
t1.value14.DisplayOrder = 999999
t1.value14.Parent = t1.value9
t1.value15 = Instance.new("Frame")
t1.value15.Size = UDim2.new(0, 580, 0, 440)
t1.value15.Position = UDim2.new(0, 40, 0, 40)
t1.value15.BackgroundColor3 = t1.value13.bg
t1.value15.BorderSizePixel = 0
t1.value15.Active = true
t1.value15.Parent = t1.value14

local UICorner = Instance.new("UICorner")

UICorner.CornerRadius = UDim.new(0, 8)
UICorner.Parent = t1.value15

local UIStroke = Instance.new("UIStroke")

UIStroke.Color = t1.value13.outline
UIStroke.Parent = t1.value15

local Frame = Instance.new("Frame")

Frame.Size = UDim2.new(1, 0, 0, 34)
Frame.BackgroundColor3 = t1.value13.panel
Frame.BorderSizePixel = 0
Frame.Parent = t1.value15

local UICorner2 = Instance.new("UICorner")

UICorner2.CornerRadius = UDim.new(0, 8)
UICorner2.Parent = Frame

local Frame2 = Instance.new("Frame")

Frame2.Size = UDim2.new(1, 0, 0, 8)
Frame2.Position = UDim2.new(0, 0, 1, -8)
Frame2.BackgroundColor3 = t1.value13.panel
Frame2.BorderSizePixel = 0
Frame2.Parent = Frame

local TextLabel = Instance.new("TextLabel")

TextLabel.Size = UDim2.new(1, -20, 1, 0)
TextLabel.Position = UDim2.new(0, 12, 0, 0)
TextLabel.BackgroundTransparency = 1
TextLabel.Text = "Azure | ride a pet"
TextLabel.TextColor3 = t1.value13.text
TextLabel.TextSize = 13
TextLabel.Font = Enum.Font.GothamBold
TextLabel.TextXAlignment = Enum.TextXAlignment.Left
TextLabel.Parent = Frame
t1.value16 = Instance.new("Frame")
t1.value16.Size = UDim2.new(0, 130, 1, -44)
t1.value16.Position = UDim2.new(0, 8, 0, 40)
t1.value16.BackgroundColor3 = t1.value13.panel
t1.value16.BorderSizePixel = 0
t1.value16.Parent = t1.value15

local UICorner3 = Instance.new("UICorner")

UICorner3.CornerRadius = UDim.new(0, 6)
UICorner3.Parent = t1.value16

local UIListLayout = Instance.new("UIListLayout")

UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Padding = UDim.new(0, 4)
UIListLayout.Parent = t1.value16

local UIPadding = Instance.new("UIPadding")

UIPadding.PaddingTop = UDim.new(0, 6)
UIPadding.PaddingLeft = UDim.new(0, 6)
UIPadding.PaddingRight = UDim.new(0, 6)
UIPadding.Parent = t1.value16

local Frame3 = Instance.new("Frame")

Frame3.Size = UDim2.new(1, -150, 1, -44)
Frame3.Position = UDim2.new(0, 142, 0, 40)
Frame3.BackgroundTransparency = 1
Frame3.Parent = t1.value15
t1.value17 = Instance.new("ScrollingFrame")
t1.value17.Size = UDim2.new(1, 0, 1, 0)
t1.value17.BackgroundTransparency = 1
t1.value17.BorderSizePixel = 0
t1.value17.ScrollBarThickness = 4
t1.value17.ScrollBarImageColor3 = t1.value13.outline
t1.value17.CanvasSize = UDim2.new(0, 0, 0, 0)
t1.value17.Parent = Frame3
t1.value18 = Instance.new("UIListLayout")
t1.value18.SortOrder = Enum.SortOrder.LayoutOrder
t1.value18.Padding = UDim.new(0, 6)
t1.value18.Parent = t1.value17

local UIPadding2 = Instance.new("UIPadding")

UIPadding2.PaddingTop = UDim.new(0, 6)
UIPadding2.PaddingBottom = UDim.new(0, 6)
UIPadding2.PaddingRight = UDim.new(0, 6)
UIPadding2.Parent = t1.value17
t1.value18:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	t1.value17.CanvasSize = UDim2.new(0, 0, 0, t1.value18.AbsoluteContentSize.Y + 12)
end)
t1.value19 = nil
t1.value20 = nil
t1.value21 = nil
Frame.InputBegan:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
		return
	end

	t1.value19 = true
	t1.value20 = input.Position
	t1.value21 = t1.value15.Position
end)

local InputEnded = Frame.InputEnded

InputEnded.Connect(InputEnded, function(p2)
	if p2.UserInputType ~= Enum.UserInputType.MouseButton1 then
		return
	end

	t1.value19 = false
end)
t1.value2.InputChanged:Connect(function(input)
	local value19 = t1.value19

	if value19 then
		value19 = input.UserInputType == Enum.UserInputType.MouseMovement
	end

	if not value19 then
		return
	end

	local v21 = input.Position - t1.value20

	t1.value15.Position = UDim2.new(t1.value21.X.Scale, t1.value21.X.Offset + v21.X, t1.value21.Y.Scale, t1.value21.Y.Offset + v21.Y)
end)

local function createTextLabel(p3, p4, p5)
	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, 0, 0, 0)
	TextLabel2.AutomaticSize = Enum.AutomaticSize.Y
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = p4
	TextLabel2.TextColor3 = p5 or t1.value13.text
	TextLabel2.TextSize = 11
	TextLabel2.Font = Enum.Font.Gotham
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel2.TextYAlignment = Enum.TextYAlignment.Top
	TextLabel2.TextWrapped = true
	TextLabel2.Parent = p3

	return TextLabel2
end
local function v24(p6, p7, p8, p9)
	local Frame4 = Instance.new("Frame")

	Frame4.Size = UDim2.new(1, 0, 0, 50)
	Frame4.BackgroundTransparency = 1
	Frame4.ClipsDescendants = true
	Frame4.Parent = p6

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, 0, 0, 14)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = p7
	TextLabel2.TextColor3 = t1.value13.text
	TextLabel2.TextSize = 11
	TextLabel2.Font = Enum.Font.Gotham
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel2.Parent = Frame4

	local v27 = p8[1]
	local TextButton = Instance.new("TextButton")

	TextButton.Size = UDim2.new(1, 0, 0, 24)
	TextButton.Position = UDim2.new(0, 0, 0, 18)
	TextButton.BackgroundColor3 = t1.value13.element
	TextButton.Text = v27
	TextButton.TextColor3 = t1.value13.text
	TextButton.TextSize = 11
	TextButton.Font = Enum.Font.Gotham
	TextButton.AutoButtonColor = false
	TextButton.Parent = Frame4

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(0, 4)
	UICorner4.Parent = TextButton

	local Frame5 = nil

	local function v31()
		if Frame5 then
			Frame5:Destroy()
		end

		Frame5 = Instance.new("Frame")
		Frame5.Size = UDim2.new(1, 0, 0, #p8 * 20)
		Frame5.Position = UDim2.new(0, 0, 0, 44)
		Frame5.BackgroundColor3 = t1.value13.element
		Frame5.BorderSizePixel = 0
		Frame5.Parent = Frame4

		local UICorner5 = Instance.new("UICorner")

		UICorner5.CornerRadius = UDim.new(0, 4)
		UICorner5.Parent = Frame5

		local UIListLayout2 = Instance.new("UIListLayout")

		UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout2.Parent = Frame5

		for _, v in ipairs(p8) do
			local TextButton2 = Instance.new("TextButton")

			TextButton2.Size = UDim2.new(1, 0, 0, 20)
			TextButton2.BackgroundTransparency = 1
			TextButton2.Text = v
			TextButton2.TextColor3 = t1.value13.text
			TextButton2.TextSize = 10
			TextButton2.Font = Enum.Font.Gotham
			TextButton2.AutoButtonColor = false
			TextButton2.Parent = Frame5
			TextButton2.MouseButton1Click:Connect(function()
				TextButton.Text = v

				if Frame5 then
					Frame5:Destroy()
					Frame5 = nil
				end

				Frame4.Size = UDim2.new(1, 0, 0, 50)

				if not p9 then
					return
				end

				p9(v)
			end)
			TextButton2.MouseEnter:Connect(function()
				TextButton2.BackgroundTransparency = 0.85
			end)
			TextButton2.MouseLeave:Connect(function()
				TextButton2.BackgroundTransparency = 1
			end)
		end
	end

	TextButton.MouseButton1Click:Connect(function()
		if Frame5 then
			Frame5:Destroy()
			Frame4.Size = UDim2.new(1, 0, 0, 50)
		else
			v31()
			Frame4.Size = UDim2.new(1, 0, 0, #p8 * 20 + 50)
		end
	end)
end
local function v37(p10, p11, p12, p13)
	local Frame4 = Instance.new("Frame")

	Frame4.Size = UDim2.new(1, 0, 0, 24)
	Frame4.BackgroundTransparency = 1
	Frame4.Parent = p10

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, -50, 1, 0)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = p11
	TextLabel2.TextColor3 = t1.value13.text
	TextLabel2.TextSize = 11
	TextLabel2.Font = Enum.Font.Gotham
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel2.Parent = Frame4

	local TextButton = Instance.new("TextButton")

	TextButton.Size = UDim2.new(0, 40, 0, 18)
	TextButton.Position = UDim2.new(1, -40, 0.5, -9)

	local accent

	if p12 then
		accent = t1.value13.accent
	else
		accent = p12
	end

	TextButton.BackgroundColor3 = accent or t1.value13.element
	TextButton.Text = ""
	TextButton.AutoButtonColor = false
	TextButton.Parent = Frame4

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(1, 0)
	UICorner4.Parent = TextButton

	local Frame5 = Instance.new("Frame")

	Frame5.Size = UDim2.new(0, 14, 0, 14)

	if p12 then
		local uDim2 = UDim2.new(1, -16, 0.5, -7)
	end

	Frame5.Position = v57 or UDim2.new(0, 2, 0.5, -7)
	Frame5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Frame5.BorderSizePixel = 0
	Frame5.Parent = TextButton

	local UICorner5 = Instance.new("UICorner")

	UICorner5.CornerRadius = UDim.new(1, 0)

	local u46 = nil

	UICorner5.Parent = Frame5

	local function v47()
		local v48 = TextButton
		local accent2 = u46

		if accent2 then
			accent2 = t1.value13.accent
		end

		v48.BackgroundColor3 = accent2 or t1.value13.element

		local v50 = Frame5
		local uDim2 = u46

		if not uDim2 then
			v50.Position = uDim2 or UDim2.new(0, 2, 0.5, -7)

			return
		end

		uDim2 = UDim2.new(1, -16, 0.5, -7)
		v50.Position = uDim2 or UDim2.new(0, 2, 0.5, -7)
	end

	u46 = p12
	TextButton.MouseButton1Click:Connect(function()
		u46 = not u46
		v47()

		if not p13 then
			return
		end

		p13(u46)
	end)
	v47()

	local t2 = {
		Get = function()
			return u46
		end,
		GetValue = function()
			return u46
		end,
		Set = function(_, p14)
			v47()

			if not p13 then
				return
			end

			p13(p14)
		end
	}

	t2.SetValue = t2.Set

	return t2
end

t1.value22 = {}

local function v53(p15, p16, p17, p18, p19, p20)
	local Frame4 = Instance.new("Frame")

	Frame4.Size = UDim2.new(1, 0, 0, 34)
	Frame4.BackgroundTransparency = 1
	Frame4.Parent = p15

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, -50, 0, 14)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = p16
	TextLabel2.TextColor3 = t1.value13.text
	TextLabel2.TextSize = 11
	TextLabel2.Font = Enum.Font.Gotham
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel2.Parent = Frame4

	local TextLabel3 = Instance.new("TextLabel")

	TextLabel3.Size = UDim2.new(0, 50, 0, 14)
	TextLabel3.Position = UDim2.new(1, -50, 0, 0)
	TextLabel3.BackgroundTransparency = 1
	TextLabel3.Text = tostring(p17)
	TextLabel3.TextColor3 = t1.value13.accent
	TextLabel3.TextSize = 11
	TextLabel3.Font = Enum.Font.GothamBold
	TextLabel3.TextXAlignment = Enum.TextXAlignment.Right
	TextLabel3.Parent = Frame4

	local Frame5 = Instance.new("Frame")

	Frame5.Size = UDim2.new(1, 0, 0, 4)
	Frame5.Position = UDim2.new(0, 0, 0, 22)
	Frame5.BackgroundColor3 = t1.value13.element
	Frame5.BorderSizePixel = 0
	Frame5.Parent = Frame4

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(1, 0)
	UICorner4.Parent = Frame5

	local Frame6 = Instance.new("Frame")

	Frame6.Size = UDim2.new((p17 - p18) / (p19 - p18), 0, 1, 0)
	Frame6.BackgroundColor3 = t1.value13.accent
	Frame6.BorderSizePixel = 0
	Frame6.Parent = Frame5

	local UICorner5 = Instance.new("UICorner")

	UICorner5.CornerRadius = UDim.new(1, 0)
	UICorner5.Parent = Frame6

	local TextButton = Instance.new("TextButton")

	TextButton.Size = UDim2.new(1, 0, 1, 16)
	TextButton.Position = UDim2.new(0, 0, 0, -8)
	TextButton.BackgroundTransparency = 1
	TextButton.Text = ""
	TextButton.Parent = Frame5

	local u62 = false

	local function v63(p21)
		local v64 = math.clamp((p21 - Frame5.AbsolutePosition.X) / Frame5.AbsoluteSize.X, 0, 1)
		local v65 = p18 + (p19 - p18) * v64
		local v66

		if p19 - p18 < 5 then
			local v67 = v65 * 100 + 0.5

			v66 = math.floor(v67) / 100
		else
			local v68 = v65 + 0.5

			v66 = math.floor(v68)
		end

		TextLabel3.Text = tostring(v66)
		Frame6.Size = UDim2.new(v64, 0, 1, 0)

		if not p20 then
			return
		end

		p20(v66)
	end
	local function v69()
		u62 = true
		v63(t1.value2:GetMouseLocation().X)
	end

	TextButton.MouseButton1Down:Connect(v69)
	t1.value2.InputEnded:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.MouseButton1 then
			return
		end

		u62 = false
	end)
	t1.value2.InputChanged:Connect(function(input)
		local v70 = u62

		if v70 then
			v70 = input.UserInputType == Enum.UserInputType.MouseMovement
		end

		if not v70 then
			return
		end

		v63(input.Position.X)
	end)
end
local function v71(p22, p23, p24)
	local TextButton = Instance.new("TextButton")

	TextButton.Size = UDim2.new(1, 0, 0, 26)
	TextButton.BackgroundColor3 = t1.value13.element
	TextButton.Text = p23
	TextButton.TextColor3 = t1.value13.text
	TextButton.TextSize = 11
	TextButton.Font = Enum.Font.Gotham
	TextButton.AutoButtonColor = false
	TextButton.Parent = p22

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(0, 4)
	UICorner4.Parent = TextButton
	TextButton.MouseEnter:Connect(function()
		TextButton.BackgroundColor3 = t1.value13.accent
		TextButton.TextColor3 = t1.value13.bg
	end)
	TextButton.MouseLeave:Connect(function()
		TextButton.BackgroundColor3 = t1.value13.element
		TextButton.TextColor3 = t1.value13.text
	end)
	TextButton.MouseButton1Click:Connect(function()
		if not p24 then
			return
		end

		p24()
	end)
end
local function v74(p25, p26, p27, p28)
	local Frame4 = Instance.new("Frame")

	Frame4.Size = UDim2.new(1, 0, 0, 44)
	Frame4.BackgroundTransparency = 1
	Frame4.Parent = p25

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, 0, 0, 14)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = p26
	TextLabel2.TextColor3 = t1.value13.text
	TextLabel2.TextSize = 11
	TextLabel2.Font = Enum.Font.Gotham
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel2.Parent = Frame4

	local TextBox = Instance.new("TextBox")

	TextBox.Size = UDim2.new(1, 0, 0, 22)
	TextBox.Position = UDim2.new(0, 0, 0, 18)
	TextBox.BackgroundColor3 = t1.value13.element
	TextBox.BorderSizePixel = 0
	TextBox.Text = ""
	TextBox.PlaceholderText = p27 or ""
	TextBox.TextColor3 = t1.value13.text
	TextBox.PlaceholderColor3 = t1.value13.subtext
	TextBox.TextSize = 11
	TextBox.Font = Enum.Font.Gotham
	TextBox.ClearTextOnFocus = false
	TextBox.Parent = Frame4

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(0, 4)
	UICorner4.Parent = TextBox
	TextBox.FocusLost:Connect(function()
		if not p28 then
			return
		end

		p28(TextBox.Text)
	end)

	return {
		GetValue = function()
			return TextBox.Text
		end,
		SetValue = function(_, p29)
			TextBox.Text = p29
		end
	}
end

function t1.value23(p30)
	for k, v in pairs(t1.value22) do
		v.frame.Visible = k == p30

		local btn = v.btn
		local s1 = "TextColor3"
		local v83 = k == p30

		if v83 then
			v83 = t1.value13.text
		end

		btn[s1] = v83 or t1.value13.subtext

		local btn2 = v.btn
		local s2 = "BackgroundColor3"
		local v86 = k == p30

		if v86 then
			v86 = t1.value13.accent
		end

		btn2[s2] = v86 or t1.value13.element
	end
end

local function createFrame(p31)
	local TextButton = Instance.new("TextButton")

	TextButton.Size = UDim2.new(1, 0, 0, 26)
	TextButton.BackgroundColor3 = t1.value13.element
	TextButton.BorderSizePixel = 0
	TextButton.Text = p31
	TextButton.TextColor3 = t1.value13.subtext
	TextButton.TextSize = 11
	TextButton.Font = Enum.Font.Gotham
	TextButton.AutoButtonColor = false
	TextButton.Parent = t1.value16

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(0, 4)
	UICorner4.Parent = TextButton

	local Frame4 = Instance.new("Frame")

	Frame4.Size = UDim2.new(1, 0, 0, 0)
	Frame4.AutomaticSize = Enum.AutomaticSize.Y
	Frame4.BackgroundTransparency = 1
	Frame4.Visible = false
	Frame4.Parent = t1.value17

	local UIListLayout2 = Instance.new("UIListLayout")

	UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout2.Padding = UDim.new(0, 6)
	UIListLayout2.Parent = Frame4
	t1.value22[p31] = {
		btn = TextButton,
		frame = Frame4
	}

	local function v92()
		t1.value23(p31)
	end

	TextButton.MouseButton1Click:Connect(v92)

	return Frame4
end
local function createFrame2(p32, p33)
	local Frame4 = Instance.new("Frame")

	Frame4.Size = UDim2.new(1, 0, 0, 0)
	Frame4.AutomaticSize = Enum.AutomaticSize.Y
	Frame4.BackgroundColor3 = t1.value13.section
	Frame4.BorderSizePixel = 0
	Frame4.Parent = p32

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(0, 6)
	UICorner4.Parent = Frame4

	local UIPadding3 = Instance.new("UIPadding")

	UIPadding3.PaddingTop = UDim.new(0, 8)
	UIPadding3.PaddingBottom = UDim.new(0, 8)
	UIPadding3.PaddingLeft = UDim.new(0, 10)
	UIPadding3.PaddingRight = UDim.new(0, 10)
	UIPadding3.Parent = Frame4

	local UIListLayout2 = Instance.new("UIListLayout")

	UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout2.Padding = UDim.new(0, 6)
	UIListLayout2.Parent = Frame4

	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, 0, 0, 16)
	TextLabel2.BackgroundTransparency = 1
	TextLabel2.Text = p33
	TextLabel2.TextColor3 = t1.value13.accent
	TextLabel2.TextSize = 10
	TextLabel2.Font = Enum.Font.GothamBold
	TextLabel2.TextXAlignment = Enum.TextXAlignment.Left
	TextLabel2.Parent = Frame4

	return Frame4
end

t1.value24 = Instance.new("Frame")
t1.value24.Size = UDim2.new(0, 300, 0, 0)
t1.value24.AutomaticSize = Enum.AutomaticSize.Y
t1.value24.Position = UDim2.new(1, -320, 1, -50)
t1.value24.BackgroundTransparency = 1
t1.value24.Parent = t1.value14

local UIListLayout2 = Instance.new("UIListLayout")

UIListLayout2.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout2.VerticalAlignment = Enum.VerticalAlignment.Bottom
UIListLayout2.Padding = UDim.new(0, 4)
UIListLayout2.Parent = t1.value24

function t1.value25(p34, p35)
	local TextLabel2 = Instance.new("TextLabel")

	TextLabel2.Size = UDim2.new(1, 0, 0, 28)
	TextLabel2.BackgroundColor3 = t1.value13.panel
	TextLabel2.BorderSizePixel = 0
	TextLabel2.Text = p34
	TextLabel2.TextColor3 = p35 or t1.value13.text
	TextLabel2.TextSize = 11
	TextLabel2.Font = Enum.Font.Gotham
	TextLabel2.Parent = t1.value24

	local UICorner4 = Instance.new("UICorner")

	UICorner4.CornerRadius = UDim.new(0, 6)
	UICorner4.Parent = TextLabel2
	task.delay(3, function()
		local function v102()
			TextLabel2:Destroy()
		end

		pcall(v102)
	end)
end

local Farm = createFrame("Farm")
local Steal = createFrame("Steal")
local Pets = createFrame("Pets")
local Shop = createFrame("Shop")
local Player = createFrame("Player")
local Server = createFrame("Server")
local Misc = createFrame("Misc")

t1.value23("Farm")

local farmStatus = createFrame2(Farm, "Farm Status")
local v111 = createFrame2(Farm, "Auto Collect / Steal")
local v112 = createFrame2(Farm, "Auto Plant & Hatch")
local stealTargets = createFrame2(Steal, "Steal Targets")
local stealOptions = createFrame2(Steal, "Steal Options")
local team = createFrame2(Pets, "Team")
local feeding = createFrame2(Pets, "Feeding")
local food = createFrame2(Shop, "Food")
local gears = createFrame2(Shop, "Gears")
local v119 = createFrame2(Shop, "Rebirth / Rewards")
local movement = createFrame2(Player, "Movement")
local esp = createFrame2(Player, "ESP")
local server = createFrame2(Server, "Server")
local performance = createFrame2(Misc, "Performance")
local utility = createFrame2(Misc, "Utility")
local credits = createFrame2(Misc, "Credits")

local function v126(p36)
	local ok, result = pcall(function()
		return require(p36)
	end)

	return ok and result and result or nil
end

local Eggs

if ReplicatedStorage:FindFirstChild("GameData") then
	Eggs = ReplicatedStorage.GameData:FindFirstChild("Eggs") or nil
else
	Eggs = nil
end

local v130 = v126(Eggs)
local GameData = ReplicatedStorage:FindFirstChild("GameData")

if GameData then
	GameData = ReplicatedStorage.GameData:FindFirstChild("Pets")
end

local v132 = v126(GameData or nil)
local GameData2 = ReplicatedStorage:FindFirstChild("GameData")

if GameData2 then
	GameData2 = ReplicatedStorage.GameData:FindFirstChild("Foods")
end

local v134 = v126(GameData2 or nil)
local Shop2

if ReplicatedStorage:FindFirstChild("GameData") then
	Shop2 = ReplicatedStorage.GameData:FindFirstChild("Shop") or nil
else
	Shop2 = nil
end

local v136 = v126(Shop2)
local s3 = "Rebirths"
local Rebirths = ReplicatedStorage.FindFirstChild(ReplicatedStorage, "GameData")

if Rebirths then
	Rebirths = ReplicatedStorage.GameData:FindFirstChild("Rebirths")
end

local v139 = v126(Rebirths or nil)
local GameData3 = ReplicatedStorage:FindFirstChild("GameData")

if GameData3 then
	GameData3 = ReplicatedStorage.GameData:FindFirstChild("EggBaskets")
end

local v141 = v126(GameData3 or nil)
local Mutations

if ReplicatedStorage:FindFirstChild("GameData") then
	Mutations = ReplicatedStorage.GameData:FindFirstChild("Mutations") or nil
else
	Mutations = nil
end

t1.value26 = {
	Eggs = v130,
	Pets = v132,
	Foods = v134,
	Shop = v136,
	[s3] = v139,
	EggBaskets = v141,
	Mutations = v126(Mutations)
}

local ServerData = ReplicatedStorage:FindFirstChild("ServerData")

if ServerData then
	ServerData = ReplicatedStorage.ServerData:FindFirstChild("ActiveEggs")
end

t1.value27 = ServerData

local t3 = {
	"Common",
	"Uncommon",
	"Rare",
	"Epic",
	"Legendary",
	"Mythic",
	"Divine",
	"Ethereal"
}

t1.value28 = {}

for i, v in ipairs(t3) do
	t1.value28[v] = i
end

t1.value29 = {
	Common = Color3.fromRGB(214, 218, 228),
	Uncommon = Color3.fromRGB(140, 220, 140),
	Rare = Color3.fromRGB(96, 170, 255),
	Epic = Color3.fromRGB(190, 110, 255),
	Legendary = Color3.fromRGB(255, 196, 66),
	Mythic = Color3.fromRGB(255, 82, 90),
	Divine = Color3.fromRGB(255, 240, 150),
	Ethereal = Color3.fromRGB(125, 225, 255)
}
t1.value30 = nil
t1.value31 = {
	FlySpeed = 600,
	CruiseHeight = 250,
	Status = "Idle",
	Movement = {
		Owner = nil
	}
}
t1.value32 = nil

function t1.value32()
	return t1.value8.Character
end
function t1.value33()
	local Humanoid = t1.value32()
	local v148

	if not Humanoid then
		if Humanoid then
			v148 = Humanoid.Health > 0
		else
			v148 = Humanoid
		end

		if v148 then
			return Humanoid
		end

		return
	end

	Humanoid = Humanoid:FindFirstChildOfClass("Humanoid")

	if Humanoid then
		v148 = Humanoid.Health > 0
	else
		v148 = Humanoid
	end

	if v148 then
		return Humanoid
	end
end

local function v149()
	local HumanoidRootPart = t1.value32()
	local v151

	if not HumanoidRootPart then
		if HumanoidRootPart then
			v151 = HumanoidRootPart:IsDescendantOf(t1.value3)
		else
			v151 = HumanoidRootPart
		end

		if v151 then
			return HumanoidRootPart
		end

		return
	end

	HumanoidRootPart = HumanoidRootPart:FindFirstChild("HumanoidRootPart")

	if HumanoidRootPart then
		v151 = HumanoidRootPart:IsDescendantOf(t1.value3)
	else
		v151 = HumanoidRootPart
	end

	if v151 then
		return HumanoidRootPart
	end
end

t1.value30 = nil

function t1.value34()
	local value30 = t1.value30

	if value30 then
		value30 = t1.value30.Parent
	end

	local Plots, Data

	if not value30 then
		t1.value30 = nil
		Plots = t1.value3:FindFirstChild("Plots")

		if Plots then
			for _, child in ipairs(Plots.GetChildren(Plots)) do
				Data = child:FindFirstChild("Data")

				if Data then
					Data = Data:FindFirstChild("Owner")
				end

				if Data then
					Data = Data.Value == t1.value8
				end

				if Data then
					t1.value30 = child

					return child
				end
			end

			return
		else
			return nil
		end
	end

	local Data2 = t1.value30:FindFirstChild("Data")

	if Data2 then
		Data2 = Data2:FindFirstChild("Owner")
	end

	if Data2 then
	elseif Data2 then
		return t1.value30
	else
		t1.value30 = nil
		Plots = t1.value3:FindFirstChild("Plots")

		if Plots then
			for _, child in ipairs(Plots.GetChildren(Plots)) do
				Data = child:FindFirstChild("Data")

				if Data then
					Data = Data:FindFirstChild("Owner")
				end

				if Data then
					Data = Data.Value == t1.value8
				end

				if Data then
					t1.value30 = child

					return child
				end
			end

			return
		else
			return nil
		end
	end

	Data2 = Data2.Value == t1.value8

	if Data2 then
		return t1.value30
	else
		t1.value30 = nil
		Plots = t1.value3:FindFirstChild("Plots")

		if Plots then
			for _, child in ipairs(Plots.GetChildren(Plots)) do
				Data = child:FindFirstChild("Data")

				if Data then
					Data = Data:FindFirstChild("Owner")
				end

				if Data then
					Data = Data.Value == t1.value8
				end

				if Data then
					t1.value30 = child

					return child
				end
			end

			return
		else
			return nil
		end
	end
end
function t1.value35()
	local Baseplate = t1.value34()

	if Baseplate then
		Baseplate = Baseplate:FindFirstChild("Baseplate")
	end

	local isBasePart

	if Baseplate then
		isBasePart = Baseplate:IsA("BasePart")
	else
		isBasePart = Baseplate
	end

	if isBasePart then
		if Baseplate then
			return Baseplate.Position + Vector3.new(0, Baseplate.Size.Y / 2, 0)
		else
			return nil
		end
	end

	Baseplate = nil

	if Baseplate then
		return Baseplate.Position + Vector3.new(0, Baseplate.Size.Y / 2, 0)
	else
		return nil
	end
end
function t1.value36(p37, ...)
	local v164 = t1.value12(p37)

	if not v164 then
		return false
	end

	local v165 = table.pack(...)
	local v166 = nil

	local function v167()
		if v164:IsA("RemoteFunction") then
			v164:InvokeServer(unpack_({ table.unpack(v166, 1, v166.n) }))
		else
			v164:FireServer(unpack_({ table.unpack(v166, 1, v166.n) }))
		end
	end

	v166 = v165

	return pcall(v167)
end

t1.value37 = nil
t1.value37 = {}

function t1.value38(p38)
	local v168 = t1.value32()

	if v168 then
		for _, descendant in ipairs(v168:GetDescendants()) do
			if descendant:IsA("BasePart") then
				if p38 then
					if t1.value37[descendant] == nil then
						t1.value37[descendant] = descendant.CanCollide
					end

					descendant.CanCollide = false
				elseif t1.value37[descendant] ~= nil then
					descendant.CanCollide = t1.value37[descendant]
				end
			end
		end

		if p38 then
			return
		end

		table.clear(t1.value37)
	end
end

local function v171(p39, p40)
	local v172

	if Vector3.new(p40.X - p39.X, 0, p40.Z - p39.Z).Magnitude < 80 then
		local v173 = p40.Y - p39.Y

		v172 = math.abs(v173) < 30
	else
		v172 = false
	end

	if v172 then
		return { p40 }
	else
		local Y = p39.Y
		local Y2 = p40.Y
		local v176 = math.max(Y, Y2) + t1.value31.CruiseHeight

		return { Vector3.new(p39.X, v176, p39.Z), Vector3.new(p40.X, v176, p40.Z), p40 }
	end
end

t1.value39 = nil

function t1.value39(p41, p42)
	local n1 = 0

	for _, v in ipairs((v171(p41, p42))) do
		n1 = n1 + (v - p41).Magnitude
		p41 = v
	end

	local FlySpeed = t1.value31.FlySpeed

	return n1 / math.max(FlySpeed, 20)
end
function t1.value40(p43, p44, p45)
	local v181 = v149()

	if not v181 or typeof(p43) ~= "Vector3" then
		return false
	end

	local v182 = p45 or 3

	if (v181.Position - p43).Magnitude <= v182 then
		return true
	end

	local v183 = v171(v181.Position, p43)
	local v184 = os.clock() + t1.value39(v181.Position, p43) + 6

	t1.value38(true)

	local connection = t1.value1.Stepped:Connect(function()
		local v186 = t1.value32()

		if v186 then
			local GetDescendants = v186.GetDescendants

			for _, v in ipairs(GetDescendants(v186)) do
				local isBasePart = v:IsA("BasePart")

				if isBasePart then
					isBasePart = v.CanCollide
				end

				if isBasePart then
					v.CanCollide = false
				end
			end
		end
	end)
	local n2 = 1
	local v192 = false

	while v184 > os.clock() do
		local v193

		if p44 then
			v193 = p44()
		else
			v193 = p44
		end

		if v193 then
			break
		end

		local result = t1.value1.Heartbeat:Wait()
		local v195 = v149()

		if not v195 then
			break
		end

		local v196 = n2 == #v183
		local v197 = v183[n2] - v195.Position
		local Magnitude = v197.Magnitude

		if Magnitude <= (v196 and v182 or 2) then
			if v196 then
				v192 = true

				break
			end

			n2 = n2 + 1
		else
			local FlySpeed = t1.value31.FlySpeed
			local v200 = math.max(FlySpeed, 20) * result
			local v201 = math.min(Magnitude, v200)
			local vector3 = Vector3.new(v197.X, 0, v197.Z)
			local cFrame = vector3.Magnitude > 0.1 and CFrame.lookAt(Vector3.zero, vector3.Unit) or v195.CFrame.Rotation
			local v204 = nil

			local function v205()
				v195.CFrame = CFrame.new(v195.Position + v197.Unit * v201) * v204
				v195.AssemblyLinearVelocity = Vector3.zero
				v195.AssemblyAngularVelocity = Vector3.zero
			end

			v204 = cFrame
			pcall(v205)
		end
	end

	connection:Disconnect()
	t1.value38(false)

	local HumanoidRootPart = t1.value32()

	if HumanoidRootPart then
		HumanoidRootPart = HumanoidRootPart:FindFirstChild("HumanoidRootPart")
	end

	local v207

	if HumanoidRootPart then
		v207 = HumanoidRootPart:IsDescendantOf(t1.value3)
	else
		v207 = HumanoidRootPart
	end

	if not v207 then
		HumanoidRootPart = nil
	end

	if not HumanoidRootPart then
		return v192
	end

	pcall(function()
		HumanoidRootPart.AssemblyLinearVelocity = Vector3.zero
	end)
	v192 = (HumanoidRootPart.Position - p43).Magnitude <= v182 + 1 and true or v192

	return v192
end
function t1.value41(p46)
	if not (p46 and p46:IsA("ProximityPrompt")) then
		return false
	end

	local fireproximityprompt_ = fireproximityprompt

	if typeof(fireproximityprompt_) == "function" then
		return pcall(fireproximityprompt, p46)
	end

	return pcall(function()
		p46:InputHoldBegin()
		task.wait(p46.HoldDuration + 0.1)
		p46:InputHoldEnd()
	end)
end
function t1.value42(p47)
	local t4 = {}
	local Backpack = t1.value8:FindFirstChildOfClass("Backpack")

	if Backpack then
		local GetChildren = Backpack.GetChildren

		for _, v in ipairs(GetChildren(Backpack)) do
			local isTool = v:IsA("Tool")

			if isTool then
				isTool = t1.value4:HasTag(v, p47)
			end

			if isTool then
				table.insert(t4, v)
			end
		end
	end

	local v215 = t1.value32()

	if not v215 then
		return t4
	end

	local GetChildren = v215.GetChildren

	for _, v in ipairs(GetChildren(v215)) do
		local isTool = v:IsA("Tool")

		if isTool then
			isTool = t1.value4:HasTag(v, p47)
		end

		if isTool then
			table.insert(t4, v)
		end
	end

	return t4
end
function t1.value43(p48)
	local v220 = t1.value33()
	local v221 = t1.value32()

	if not (v220 and (p48 and v221)) then
		return false
	end

	if p48.Parent == v221 then
		return true
	end

	pcall(function()
		v220:EquipTool(p48)
	end)

	local v222 = os.clock() + 1

	while true do
		local v223

		if p48.Parent == v221 then
			v223 = false
		else
			v223 = os.clock() < v222
		end

		if not v223 then
			return p48.Parent == v221
		end

		t1.value1.Heartbeat:Wait()
	end
end
function t1.value44()
	local v224 = t1.value33()

	if not v224 then
		return
	end

	pcall(function()
		v224:UnequipTools()
	end)
end
function t1.value45(p49, p50, p51)
	local Baseplate = t1.value34()

	if Baseplate then
		Baseplate = Baseplate:FindFirstChild("Baseplate")
	end

	local isBasePart

	if Baseplate then
		isBasePart = Baseplate:IsA("BasePart")
	else
		isBasePart = Baseplate
	end

	if not isBasePart then
		Baseplate = nil
	end

	if not Baseplate then
		return nil
	end

	local v227 = math.max(1, Baseplate.Size.X / 2 - p49)
	local v228 = Baseplate.Size.Z / 2 - p49
	local v229 = math.max(1, v228)
	local v230 = Baseplate.Position.Y + Baseplate.Size.Y / 2
	local v231 = Random.new()
	local v232 = nil

	for _ = 1, 24 do
		local vector3New = Vector3.new
		local NextNumber = v231.NextNumber
		local NextNumber2 = v231.NextNumber
		local vector3 = vector3New(NextNumber(v231, -v227, v227), 0, NextNumber2(v231, -v229, v229))
		local v238 = Baseplate.CFrame:PointToWorldSpace(vector3)
		local vector32 = Vector3.new(v238.X, v230, v238.Z)
		local v240 = true
		local ipairs_

		if p50 then
			ipairs_ = ipairs

			for _, v in ipairs_(p50) do
				if Vector3.new(v.X - vector32.X, 0, v.Z - vector32.Z).Magnitude < p51 then
					v240 = false
					ipairs_ = false

					break
				end
			end
		else
			ipairs_ = v240
		end

		if v240 then
			return vector32
		end

		v232 = v232 or vector32
	end

	return v232
end
function t1.value46()
	local SavedData = t1.value8:FindFirstChild("SavedData")

	if SavedData then
		SavedData = SavedData:FindFirstChild("Cash")
	end

	if not SavedData then
		return SavedData or 0
	end

	local Value = SavedData.Value

	SavedData = tonumber(Value)

	return SavedData or 0
end
function t1.value47(p52)
	local SavedData = t1.value8:FindFirstChild("SavedData")

	if SavedData then
		SavedData = SavedData:FindFirstChild(p52)
	end

	if not SavedData then
		return SavedData or nil
	end

	SavedData = SavedData.Value

	return SavedData or nil
end
function t1.value48(p53)
	local Eggs2 = t1.value26.Eggs
	local v248

	if type(Eggs2) == "table" then
		v248 = Eggs2[tostring(p53)]
	else
		v248 = false
	end

	return type(v248) == "table" and v248 and v248 or nil
end
function t1.value49(p54)
	local v249 = t1.value48(p54)

	if not v249 then
		return v249 or 0
	end

	local value28 = t1.value28
	local Rarity = v249.Rarity

	v249 = value28[tostring(Rarity)]

	return v249 or 0
end
function t1.value50(p55)
	local v252 = t1.value48(p55)

	if not v252 then
		return v252 or "Common"
	end

	local Rarity = v252.Rarity

	v252 = tostring(Rarity)

	return v252 or "Common"
end
function t1.value51(p56)
	local v254 = t1.value48(p56)

	if not v254 then
		return v254 or 0
	end

	local Luck = v254.Luck

	v254 = tonumber(Luck)

	return v254 or 0
end

t1.value52 = {
	Active = false,
	Manual = {},
	Carried = {},
	Target = nil,
	TargetManual = false,
	Dropped = nil,
	LastPickupAt = 0,
	Relaying = false,
	PickupPos = nil
}
t1.value53 = {
	Active = false,
	MinRank = 0,
	Cooldown = 0,
	Snapshot = 0
}
t1.value54 = {
	Active = false
}
t1.value55 = {
	Active = false,
	Swap = false
}
t1.value56 = {
	Active = false,
	Cooldown = {},
	FoodFilter = {}
}
t1.value57 = {
	BuyFood = false,
	BuyGears = false,
	FoodFilter = {},
	GearFilter = {},
	KeepCash = 0
}
t1.value58 = {
	Rebirth = false,
	ClaimIndex = false
}
t1.value59 = 0
t1.value60 = {}
t1.value61 = "Highest Rarity"
t1.value62 = 0

function t1.value63(p57)
	if not t1.value27 then
		return {}
	end

	local now = os.clock()
	local v257 = t1.value35()
	local ipairs_ = ipairs
	local value27 = t1.value27
	local t5 = {}

	for _, child in ipairs_(value27.GetChildren(value27)) do
		local attribute = child:GetAttribute("Egg")
		local attribute2 = child:GetAttribute("Position")
		local attribute3 = child:GetAttribute("PrivateTo")
		local BlockedUntil = t1.value52.BlockedUntil

		if BlockedUntil then
			BlockedUntil = t1.value52.BlockedUntil[child.Name]
		end

		local v267 = type(attribute) == "string"

		if v267 then
			v267 = typeof(attribute2) == "Vector3"

			if v267 then
				v267 = attribute3 == nil and true or attribute3 == t1.value8.UserId

				if v267 then
					if BlockedUntil then
						BlockedUntil = now < BlockedUntil
					end

					v267 = not BlockedUntil
				end
			end
		end

		if v267 then
			local v268 = t1.value49(attribute)
			local v269 = t1.value59 <= v268

			if v269 then
				v269 = next(t1.value60) == nil and true or t1.value60[attribute]
			end

			if v269 and (not v257 or t1.value39(attribute2, v257) < 15) then
				table.insert(t5, {
					Config = child,
					Name = attribute,
					Position = attribute2,
					Rank = v268,
					Luck = t1.value51(attribute) * (tonumber(child:GetAttribute("Weight")) or 1),
					Distance = (attribute2 - p57).Magnitude
				})
			end
		end
	end

	table.sort(t5, function(p58, p59)
		if t1.value61 == "Nearest" then
			return p58.Distance < p59.Distance
		elseif t1.value61 == "Farthest" then
			return p58.Distance > p59.Distance
		elseif t1.value61 == "Highest Rarity" then
			if p58.Rank == p59.Rank then
				if p58.Luck == p59.Luck then
					return p58.Distance < p59.Distance
				else
					return p58.Luck > p59.Luck
				end
			else
				return p58.Rank > p59.Rank
			end
		elseif p58.Luck == p59.Luck then
			return p58.Distance < p59.Distance
		else
			return p58.Luck > p59.Luck
		end
	end)

	return t5
end
function t1.value64()
	return t1.value8:FindFirstChild("Basket")
end

local function v270()
	local v271 = t1.value64()

	return v271 and #v271:GetChildren() or v271 or 0
end

function t1.value65()
	local EquippedEggBasket = t1.value47("EquippedEggBasket")
	local EggBaskets = t1.value26.EggBaskets
	local v274 = type(EggBaskets) == "table"
	local Capacity, v276

	if v274 then
		if not EquippedEggBasket then
			if type(EquippedEggBasket) == "table" then
				Capacity = EquippedEggBasket.Capacity
				v276 = tonumber(Capacity) or 1
			else
				v276 = 1
			end

			return (v276 == math.huge and true or v276 > 50) and 50 or math.max(1, v276)
		end

		EquippedEggBasket = EggBaskets[tostring(EquippedEggBasket)]
	else
		EquippedEggBasket = v274
	end

	if type(EquippedEggBasket) == "table" then
		Capacity = EquippedEggBasket.Capacity
		v276 = tonumber(Capacity) or 1
	else
		v276 = 1
	end

	return (v276 == math.huge and true or v276 > 50) and 50 or math.max(1, v276)
end
function t1.value66()
	local n3 = 7250753

	while #t1.value52.Manual > 0 do
		local value27 = t1.value27

		if value27 then
			value27 = t1.value27:FindFirstChild(t1.value52.Manual[1])
		end

		local attribute

		if value27 then
			attribute = value27:GetAttribute("Egg")
		else
			attribute = value27
		end

		local attribute2

		if value27 then
			attribute2 = value27:GetAttribute("Position")
		else
			attribute2 = value27
		end

		local attribute3

		if value27 then
			attribute3 = value27:GetAttribute("PrivateTo")
		else
			attribute3 = value27
		end

		local v282 = type(attribute) == "string"

		if v282 then
			v282 = typeof(attribute2) == "Vector3"

			if v282 then
				v282 = attribute3 == nil and true or attribute3 == t1.value8.UserId
			end
		end

		if v282 then
			return {
				Config = value27,
				Name = attribute,
				Position = attribute2,
				Manual = true
			}
		end

		n3 = table.remove
		n3(t1.value52.Manual, 1)
	end
end

local function v283(p60)
	if v270() <= 0 then
		return true
	end

	local v284 = t1.value35()
	local v285 = not v284

	if not v285 then
		local Baseplate = t1.value34()

		if Baseplate then
			Baseplate = Baseplate:FindFirstChild("Baseplate")
		end

		local isBasePart

		if Baseplate then
			isBasePart = Baseplate:IsA("BasePart")
		else
			isBasePart = Baseplate
		end

		if not isBasePart then
			Baseplate = nil
		end

		v285 = not Baseplate
	end

	if v285 then
		return false
	end

	t1.value31.Status = "Bringing eggs home"
	t1.value40(v284 + Vector3.new(0, 4, 0), p60, 4)

	local v288 = os.clock() + 3

	while true do
		if true then
			local v289 = t1.value64()
			local v290

			if (v289 and #v289:GetChildren() or v289 or 0) > 0 then
				v290 = os.clock() < v288
			else
				v290 = false
			end
		end

		if not v341 then
			local v291 = t1.value64()

			if (v291 and #v291:GetChildren() or v291 or 0) ~= 0 then
				v343 = t1.value64()

				return (v343 and #v343:GetChildren() or v343 or 0) == 0
			end

			table.clear(t1.value52.Carried)
			t1.value52.PickupPos = nil

			local v292 = t1.value64()

			return (v292 and #v292:GetChildren() or v292 or 0) == 0
		end

		t1.value1.Heartbeat:Wait()
	end
end

function t1.value67(p61)
	local HumanoidRootPart = t1.value32()

	if HumanoidRootPart then
		HumanoidRootPart = HumanoidRootPart:FindFirstChild("HumanoidRootPart")
	end

	local v294

	if HumanoidRootPart then
		v294 = HumanoidRootPart:IsDescendantOf(t1.value3)
	else
		v294 = HumanoidRootPart
	end

	if not v294 then
		HumanoidRootPart = nil
	end

	if not HumanoidRootPart then
		return false
	end

	local v295 = t1.value65()
	local v296 = false

	while true do
		local v297 = t1.value64()
		local v298

		if not ((v297 and #v297:GetChildren() or v297 or 0) < v295 and not p61()) then
			t1.value52.Target = nil
			v298 = t1.value64()

			if not ((v298 and #v298:GetChildren() or v298 or 0) > 0) then
				return v296
			end

			v283(p61)

			return v296
		end

		local HumanoidRootPart2 = t1.value32()

		if HumanoidRootPart2 then
			HumanoidRootPart2 = HumanoidRootPart2:FindFirstChild("HumanoidRootPart")
		end

		local v300

		if HumanoidRootPart2 then
			v300 = HumanoidRootPart2:IsDescendantOf(t1.value3)
		else
			v300 = HumanoidRootPart2
		end

		if not v300 then
			HumanoidRootPart2 = nil
		end

		if not HumanoidRootPart2 then
			t1.value52.Target = nil
			v298 = t1.value64()

			if not ((v298 and #v298:GetChildren() or v298 or 0) > 0) then
				return v296
			end

			v283(p61)

			return v296
		end

		local v301 = t1.value66()

		if not v301 then
			for _, v in ipairs(t1.value63(HumanoidRootPart2.Position)) do
				if not table.find(t1.value52.Manual, v.Config.Name) then
					v301 = v

					break
				end
			end
		end

		if not v301 then
			t1.value31.Status = "No egg matches filters"

			return
		end

		local Name = v301.Config.Name

		t1.value52.Target = Name
		t1.value52.TargetManual = v301.Manual == true
		t1.value52.Dropped = nil
		t1.value31.Status = "Collecting " .. Name

		local v305 = t1.value40(v301.Position + Vector3.new(0, 3, 0), function()
			return p61() or (v301.Config.Parent == nil and true or t1.value52.Dropped == Name)
		end, 6)

		if t1.value52.Dropped == Name then
			t1.value52.Target = nil
			t1.value52.Dropped = nil

			continue
		else
			local v306

			if v301.Config.Parent == nil then
				v306 = not v305
			else
				v306 = false
			end

			if v306 then
				t1.value52.Target = nil

				continue
			else
				if not v305 then
					t1.value52.BlockedUntil = t1.value52.BlockedUntil or {}
					t1.value52.BlockedUntil[Name] = os.clock() + 20
					t1.value52.Target = nil

					return
				end

				local v307 = t1.value64()
				local v308 = v307 and #v307:GetChildren() or v307 or 0

				t1.value52.LastPickupAt = os.clock()

				if v308 == 0 then
					t1.value52.PickupPos = v301.Position
				end

				t1.value36("EggPickup", Name)

				local v309 = os.clock() + 1.2

				while true do
					if true then
						local v310 = t1.value64()
						local v311

						if (v310 and #v310:GetChildren() or v310 or 0) == v308 then
							v311 = os.clock() < v309
						else
							v311 = false
						end
					end

					if not v363 then
						break
					end

					t1.value1.Heartbeat:Wait()

					continue
				end

				t1.value52.Target = nil

				local v312 = t1.value64()

				if v308 < (v312 and #v312:GetChildren() or v312 or 0) then
					t1.value52.Carried[Name] = v301.Config
					v296 = true
				else
					t1.value52.BlockedUntil = t1.value52.BlockedUntil or {}
					t1.value52.BlockedUntil[Name] = os.clock() + 20
				end

				continue
			end
		end
	end
end
function t1.value68()
	local Eggs2 = t1.value34()

	if Eggs2 then
		Eggs2 = Eggs2:FindFirstChild("Eggs")
	end

	if not Eggs2 then
		return Eggs2 or {}
	end

	Eggs2 = Eggs2:GetChildren()

	return Eggs2 or {}
end
function t1.value69()
	local Pets2 = t1.value34()

	if Pets2 then
		Pets2 = Pets2:FindFirstChild("Pets")
	end

	if not Pets2 then
		return Pets2 or {}
	end

	Pets2 = Pets2:GetChildren()

	return Pets2 or {}
end
function t1.value70()
	local v315, v316, v317 = ipairs(t1.value68())
	local t6 = {}

	while true do
		local v319

		v317, v319 = v315(v316, v317)

		if not v317 then
			break
		end

		local ok, result = pcall(function()
			return v319:GetPivot().Position
		end)

		if ok then
			table.insert(t6, result)
		end
	end

	for _, v in ipairs(t1.value69()) do
		local ok, result = pcall(function()
			return v:GetPivot().Position
		end)

		if ok then
			table.insert(t6, result)
		end
	end

	return t6
end
function t1.value71(p62)
	local v326

	if os.clock() < t1.value53.Cooldown then
		v326 = #t1.value68() >= t1.value53.Snapshot
	else
		v326 = false
	end

	if v326 then
		return false
	end

	local v327, v328, v329 = ipairs(t1.value42("Egg"))
	local t7 = {}

	while true do
		local v331

		v329, v331 = v327(v328, v329)

		if not v329 then
			break
		end

		if t1.value49(v331.Name) >= t1.value53.MinRank then
			table.insert(t7, v331)
		end
	end

	if #t7 == 0 then
		return false
	end

	table.sort(t7, function(p63, p64)
		return t1.value51(p63.Name) > t1.value51(p64.Name)
	end)

	local n4 = 0

	for _, v in ipairs(t7) do
		if p62() then
			t1.value44()

			return n4 > 0
		end

		if v.Parent then
			local v335 = t1.value45(8, t1.value70(), 5)

			if v335 then
				t1.value31.Status = "Planting " .. v.Name

				if t1.value43(v) then
					local v336 = #t1.value68()

					t1.value36("EggPlaced", {
						PlantPosition = v335
					})

					local v337 = os.clock() + 1.2

					while true do
						if true then
							local v338

							if os.clock() < v337 then
								v338 = #t1.value68() == v336
							else
								v338 = false
							end
						end

						if not v391 then
							break
						end

						t1.value1.Heartbeat:Wait()
					end

					if not (v336 < #t1.value68()) then
						t1.value53.Cooldown = os.clock() + 15
						t1.value53.Snapshot = #t1.value68()

						break
					end

					n4 = n4 + 1
				end
			end
		end
	end

	t1.value44()

	return n4 > 0
end
function t1.value72()
	local t8 = {}

	for _, v in ipairs(t1.value68()) do
		local Timer = v:FindFirstChild("Timer", true)
		local Hatch = v:FindFirstChild("Hatch", true)
		local isProximityPrompt

		if Hatch then
			isProximityPrompt = Hatch:IsA("ProximityPrompt")

			if isProximityPrompt then
				isProximityPrompt = Hatch.Enabled

				if isProximityPrompt then
					isProximityPrompt = Timer and Timer:IsA("TextLabel")

					if isProximityPrompt then
						isProximityPrompt = Timer.Text == "Ready"
					end
				end
			end
		else
			isProximityPrompt = Hatch
		end

		if isProximityPrompt then
			table.insert(t8, {
				Egg = v,
				Prompt = Hatch
			})
		end
	end

	return t8
end
function t1.value73(p65)
	local n5 = 0

	for _, v in ipairs(t1.value72()) do
		if p65() then
			break
		end

		if v.Egg.Parent then
			local ok, result = pcall(function()
				return v.Egg:GetPivot().Position
			end)

			if ok then
				t1.value31.Status = "Hatching eggs"
				t1.value40(result + Vector3.new(0, 3, 3), p65, 5)
				t1.value41(v.Prompt)

				local v350 = os.clock() + 2

				while true do
					if true then
						local Parent

						if os.clock() < v350 then
							Parent = v.Egg.Parent
						else
							Parent = false
						end
					end

					if not v403 then
						break
					end

					t1.value1.Heartbeat:Wait()
				end

				if not v.Egg.Parent then
					n5 = n5 + 1
				end
			end
		end
	end

	if not (n5 > 0) then
		return n5 > 0
	end

	task.wait(0.5)
	t1.value44()

	return n5 > 0
end
function t1.value74(p66)
	local Pets2 = t1.value26.Pets
	local v353

	if type(Pets2) == "table" then
		v353 = Pets2[tostring(p66)]
	else
		v353 = false
	end

	return type(v353) == "table" and v353 and v353 or nil
end

t1.value75 = nil

function t1.value75(p67)
	local Mutations2 = t1.value26.Mutations
	local StatMultiplier, v356

	if type(Mutations2) == "table" then
		if not p67 then
			if type(p67) == "table" then
				StatMultiplier = p67.StatMultiplier
				v356 = tonumber(StatMultiplier)
			else
				v356 = false
			end

			return 1 + (v356 or 0) / 100
		end

		p67 = Mutations2[tostring(p67)]
	else
		p67 = false
	end

	if type(p67) == "table" then
		StatMultiplier = p67.StatMultiplier
		v356 = tonumber(StatMultiplier)
	else
		v356 = false
	end

	return 1 + (v356 or 0) / 100
end
function t1.value76(p68, p69, p70)
	local v357 = t1.value74(p68)
	local v358

	if v357 then
		local Income = v357.Income

		v358 = tonumber(Income) or 1
	else
		v358 = 1
	end

	local v360 = tonumber(p69) or 1

	return v358 * math.max(v360, 0.1) * t1.value75(p70)
end
function t1.value77(p71)
	local attribute = p71:GetAttribute("PetName")
	local v362

	if type(attribute) == "string" then
		v362 = attribute ~= ""
	else
		v362 = false
	end

	if v362 then
		return attribute
	else
		return string.gsub(p71.Name, "%s*%[.*$", "")
	end
end
function t1.value78(p72)
	return t1.value76(t1.value77(p72), p72:GetAttribute("Weight"), p72:GetAttribute("Mutation"))
end
function t1.value79()
	local max = math.max
	local n6 = 1
	local v365 = tonumber(t1.value8:GetAttribute("MaxPets"))

	if v365 then
		return max(n6, v365)
	end

	local value47 = t1.value47

	v365 = tonumber(value47("MaxPets")) or 5

	return max(n6, v365)
end
function t1.value80()
	local n7 = -1
	local v368 = nil

	for _, v in ipairs(t1.value42("Pet")) do
		local v371 = t1.value76(t1.value77(v), v:GetAttribute("Weight"), v:GetAttribute("Mutation"))

		if n7 < v371 then
			v368 = v
			n7 = v371
		end
	end

	return v368, n7
end
function t1.value81()
	local huge = math.huge
	local v373 = nil

	for _, v in ipairs(t1.value69()) do
		local v376 = t1.value78(v)

		if v376 < huge then
			v373 = v
			huge = v376
		end
	end

	return v373, huge
end
function t1.value82(p73, p74)
	local v377 = p73.GetAttribute(p73, "PetKey")

	if not v377 then
		return false
	end

	local v378 = t1.value35()

	if v378 then
		t1.value40(v378 + Vector3.new(0, 4, 0), p74, 20)
	end

	if not t1.value43(p73) then
		return false
	end

	local v379 = t1.value45(10, nil, 0)
	local v380 = #t1.value69()

	t1.value36("PlacePet", v377, v379 + Vector3.new(0, 2, 0))
	task.wait(0.35)
	t1.value44()

	local v381 = os.clock() + 1.5

	while true do
		local v382

		if os.clock() < v381 then
			v382 = #t1.value69() == v380
		else
			v382 = false
		end

		if not v382 then
			return v380 < #t1.value69()
		end

		t1.value1.Heartbeat:Wait()
	end
end
function t1.value83(p75)
	local n8 = 0

	for _ = 1, t1.value79() do
		if p75() then
			return n8 > 0
		end

		local v385, v386 = t1.value80()

		if not v385 then
			return n8 > 0
		end

		if #t1.value69() < t1.value79() then
			t1.value31.Status = "Placing " .. t1.value77(v385)

			if t1.value82(v385, p75) then
				n8 = n8 + 1
			end
		elseif t1.value55.Swap then
			local v387, v388 = t1.value81()
			local attribute

			if v387 then
				attribute = v387:GetAttribute("PetKey")
			else
				attribute = v387
			end

			local v390

			if attribute then
				v390 = v388 * 1.05 < v386
			else
				v390 = attribute
			end

			if v390 then
				t1.value31.Status = "Swapping in stronger pet"

				local v392 = t1.value35()

				if v392 then
					t1.value40(v392 + Vector3.new(0, 4, 0), p75, 20)
				end

				t1.value36("PickupPet", attribute)

				local v393 = os.clock() + 1.5

				while true do
					if true then
						local Parent

						if os.clock() < v393 then
							Parent = v387.Parent
						else
							Parent = false
						end
					end

					if not v452 then
						break
					end

					t1.value1.Heartbeat:Wait()
				end

				if not v387.Parent and t1.value82(v385, p75) then
					n8 = n8 + 1
				end
			end
		end
	end

	return n8 > 0
end
function t1.value84()
	local huge = math.huge
	local v395 = nil

	for _, v in ipairs(t1.value42("Food")) do
		local Amount = v:FindFirstChild("Amount", true)
		local v399

		if Amount then
			local Value = Amount.Value

			v399 = tonumber(Value) or 1
		else
			v399 = 1
		end

		local v401 = v399 > 0

		if v401 then
			v401 = next(t1.value56.FoodFilter) == nil and true or t1.value56.FoodFilter[v.Name]
		end

		if v401 then
			local Foods = t1.value26.Foods
			local v404

			if type(Foods) == "table" then
				v404 = t1.value26.Foods[v.Name]
			else
				v404 = false
			end

			local v405

			if type(v404) == "table" then
				local Cost = v404.Cost

				v405 = tonumber(Cost) or 0
			else
				v405 = 0
			end

			if v405 < huge then
				v395 = v
				huge = v405
			end
		end
	end

	return v395
end
function t1.value85(p76)
	local v406 = t1.value69()

	table.sort(v406, function(p77, p78)
		return t1.value78(p77) > t1.value78(p78)
	end)

	local n9 = 0

	for _, v in ipairs(v406) do
		if p76() then
			t1.value44()

			return n9 > 0
		end

		local attribute = v:GetAttribute("PetKey")

		if not attribute or (t1.value56.Cooldown[attribute] or 0) <= os.clock() then
			local v411 = t1.value84()

			if v411 then
				local ok, result = pcall(function()
					return v:GetPivot().Position
				end)

				if ok then
					t1.value31.Status = "Feeding " .. tostring(v:GetAttribute("PetName") or v.Name)
					t1.value40(result + Vector3.new(0, 4, 4), p76, 8)

					if t1.value43(v411) then
						local attribute2 = v:GetAttribute("Age")

						t1.value36("FeedPet", attribute, v411.Name)

						local v415 = os.clock() + 1.2

						while true do
							if true then
								local v416

								if os.clock() < v415 then
									v416 = v:GetAttribute("Age") == attribute2
								else
									v416 = false
								end
							end

							if not v476 then
								break
							end

							t1.value1.Heartbeat:Wait()
						end

						t1.value56.Cooldown[attribute] = os.clock() + 2
						n9 = n9 + 1
					end
				end
			end
		end
	end

	t1.value44()

	return n9 > 0
end

t1.value86 = {
	Food = {},
	Gears = {}
}
t1.value87 = {}

function t1.value88(p79)
	local t9 = {}
	local v418

	if type(t1.value26.Shop) == "table" then
		v418 = t1.value26.Shop[p79]
	else
		v418 = false
	end

	if type(v418) == "table" then
		for k, v in pairs(v418) do
			if type(v) == "table" then
				local insert = table.insert
				local Price = v.Price

				insert(t9, {
					Name = k,
					Price = tonumber(Price) or 0
				})
			end
		end
	end

	table.sort(t9, function(p80, p81)
		return p80.Price < p81.Price
	end)

	local t10 = {}

	for _, v in ipairs(t9) do
		local Name = v.Name

		table.insert(t10, Name)
	end

	return t10
end
function t1.value89(p82, p83)
	local Shop3 = t1.value26.Shop
	local v428

	if type(Shop3) == "table" then
		v428 = t1.value26.Shop[p82]
	else
		v428 = false
	end

	local v429

	if type(v428) == "table" then
		v429 = v428[p83]
	else
		v429 = false
	end

	local huge

	if type(v429) == "table" then
		local Price = v429.Price

		huge = tonumber(Price) or math.huge
	else
		huge = math.huge
	end

	return huge
end

local function v432(p84)
	if type(p84) == "table" then
		local pairs_ = pairs

		for k, v in pairs_(p84) do
			local v436 = k == "Food" or k == "Gears"

			if v436 then
				v436 = type(v) == "table"
			end

			if v436 then
				local t11 = {}

				for k2, v2 in pairs(v) do
					if type(v2) == "table" then
						local Amount = v2.Amount

						t11[k2] = tonumber(Amount) or (v2.InStock and 1 or 0)
					end
				end

				pairs_ = t1.value86
				pairs_[k] = t11
			end
		end
	end
end

for _, v in ipairs({ "Restock", "ShopStock" }) do
	local v443 = t1.value12(v)
	local isRemoteEvent

	if v443 then
		isRemoteEvent = v443:IsA("RemoteEvent")
	else
		isRemoteEvent = v443
	end

	if isRemoteEvent then
		v443.OnClientEvent:Connect(v432)
	end
end

t1.value36("ShopStock")

local function v445(p85)
	local n10 = 0

	for _, v in ipairs({ t1.value8:FindFirstChildOfClass("Backpack"), t1.value32() }) do
		if v then
			local GetChildren = v.GetChildren

			for _, v2 in ipairs(GetChildren(v)) do
				local isTool = v2:IsA("Tool")

				if isTool then
					isTool = string.gsub(v2.Name, "%s*%[.*$", "") == p85
				end

				if isTool then
					local Amount = v2:FindFirstChild("Amount", true)
					local v454

					if Amount then
						local Value = Amount.Value

						v454 = tonumber(Value) or 1
					else
						v454 = 1
					end

					n10 = n10 + v454
				end
			end
		end
	end

	return n10
end

t1.value90 = nil

function t1.value91(p86, p87)
	if not p87 or next(p87) == nil then
		return
	end

	local v456 = false

	for _, v in ipairs(t1.value88(p86)) do
		if p87[v] then
			local v459 = t1.value89(p86, v)
			local v460 = t1.value86[p86]
			local v461

			if v460 then
				v461 = v460[v]
			else
				v461 = v460
			end

			local v462 = p86 .. v
			local v463 = v461 == nil

			if v463 then
				v463 = (t1.value87[v462] or 0) <= os.clock()
			end

			if v463 then
				v461 = v463
			elseif v461 then
				v461 = v461 > 0
			end

			if v461 then
				local n11 = 0

				while true do
					if true then
						local v465

						if n11 < 20 then
							v465 = t1.value46() - v459 >= t1.value57.KeepCash
						else
							v465 = false
						end
					end

					if not v529 then
						break
					end

					if not v456 then
						t1.value36("SetOpenShop", p86)
						task.wait(0.15)
						v456 = true
					end

					local v466 = v445(v)

					t1.value36("BuyWithCash", p86, v)
					n11 = n11 + 1

					local v467 = os.clock() + 0.8

					while true do
						if true then
							local v468

							if os.clock() < v467 then
								v468 = v445(v) <= v466
							else
								v468 = false
							end
						end

						if not v532 then
							break
						end

						t1.value1.Heartbeat:Wait()
					end

					if not (v466 < v445(v)) then
						if v460 then
							v460[v] = 0
						end

						t1.value87[v462] = os.clock() + 30

						break
					end

					local v469

					if v460 then
						v469 = v460[v]
					else
						v469 = v460
					end

					if v469 then
						local v470 = v460[v] - 1

						v460[v] = math.max(0, v470)
					end
				end
			end
		end
	end
end
function t1.value92()
	local Rebirths2 = t1.value26.Rebirths
	local value47 = t1.value47
	local v473 = tonumber(value47("Rebirths")) or 0

	if type(Rebirths2) ~= "table" then
		return nil
	end

	local Cap = Rebirths2.Cap
	local v475 = tonumber(Cap)

	if v475 then
		v475 = v475 <= v473
	end

	if v475 then
		return nil
	end

	local GetCost = Rebirths2.GetCost

	if type(GetCost) ~= "function" then
		return
	end

	local ok, result = pcall(Rebirths2.GetCost, v473)

	if not ok then
		if ok then
			return tonumber(result)
		end

		return
	end

	ok = tonumber(result)

	if ok then
		return tonumber(result)
	end
end

t1.value93 = nil
t1.value94 = {}
t1.value95 = true
t1.value90 = nil
pcall(function()
	t1.value90 = Font.new("rbxasset://fonts/families/GothamSSm.json", Enum.FontWeight.ExtraBold, Enum.FontStyle.Normal)
end)
t1.value96 = nil

function t1.value96(p88, p89)
	p88.BackgroundTransparency = 1
	p88.TextScaled = true
	p88.TextStrokeTransparency = 1
	p88.TextColor3 = Color3.fromRGB(255, 255, 255)
	p88.Size = UDim2.new(1, 0, 0, p89)

	if t1.value90 then
		p88.FontFace = t1.value90
	else
		p88.Font = Enum.Font.GothamBold
	end

	local UIStroke2 = Instance.new("UIStroke")

	UIStroke2.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	UIStroke2.Color = Color3.fromRGB(0, 0, 0)
	UIStroke2.Thickness = 1.8
	UIStroke2.Transparency = 0.05
	UIStroke2.Parent = p88
end
function t1.value97(p90)
	if not (t1.value94[p90] or not t1.value93) then
		local attribute = p90:GetAttribute("Egg")
		local attribute2 = p90:GetAttribute("Position")

		if type(attribute) ~= "string" and true or typeof(attribute2) ~= "Vector3" then
			return
		else
			local attribute3 = p90:GetAttribute("PrivateTo")
			local v483

			if attribute3 == nil then
				v483 = false
			else
				v483 = attribute3 ~= t1.value8.UserId
			end

			if v483 then
				return
			elseif t1.value49(attribute) < t1.value62 then
				return
			else
				local v484 = t1.value50(attribute)
				local BillboardGui = Instance.new("BillboardGui")

				BillboardGui.AlwaysOnTop = true
				BillboardGui.LightInfluence = 0
				BillboardGui.Size = UDim2.fromOffset(170, 46)
				BillboardGui.Adornee = t1.value3.Terrain
				BillboardGui.StudsOffsetWorldSpace = attribute2 + Vector3.new(0, 4, 0)
				BillboardGui.MaxDistance = 100000

				local Frame4 = Instance.new("Frame")

				Frame4.BackgroundTransparency = 1
				Frame4.Size = UDim2.fromScale(1, 1)
				Frame4.Parent = BillboardGui

				local UIListLayout3 = Instance.new("UIListLayout")

				UIListLayout3.SortOrder = Enum.SortOrder.LayoutOrder
				UIListLayout3.HorizontalAlignment = Enum.HorizontalAlignment.Center
				UIListLayout3.Parent = Frame4

				local TextLabel2 = Instance.new("TextLabel")

				TextLabel2.LayoutOrder = 1
				t1.value96(TextLabel2, 24)
				TextLabel2.Text = attribute
				TextLabel2.TextColor3 = t1.value29[v484] or Color3.fromRGB(255, 255, 255)
				TextLabel2.Parent = Frame4

				local TextLabel3 = Instance.new("TextLabel")

				TextLabel3.LayoutOrder = 2
				t1.value96(TextLabel3, 18)
				TextLabel3.TextColor3 = Color3.fromRGB(230, 232, 240)
				TextLabel3.Visible = t1.value95
				TextLabel3.Parent = Frame4
				BillboardGui.Parent = t1.value93
				t1.value94[p90] = {
					Gui = BillboardGui,
					Info = TextLabel3,
					Rarity = v484,
					Position = attribute2,
					Weight = tonumber(p90:GetAttribute("Weight")) or 1
				}

				return
			end
		end
	end
end

local function v490(p91)
	local v491 = t1.value94[p91]

	if not v491 then
		return
	end

	t1.value94[p91] = nil
	pcall(function()
		v491.Gui:Destroy()
	end)
end

t1.value98 = nil
t1.value98 = {}

function t1.value99()
	stopEsp()
	t1.value93 = Instance.new("Folder")
	t1.value93.Name = "AzureEsp"
	t1.value93.Parent = t1.value9

	if not t1.value27 then
		return
	end

	task.spawn(function()
		local ipairs_ = ipairs
		local value27 = t1.value27

		for _, child in ipairs_(value27.GetChildren(value27)) do
			t1.value97(child)
		end
	end)

	local value98 = t1.value98
	local ChildAdded = t1.value27.ChildAdded

	local function v498(p92)
		task.defer(t1.value97, p92)
	end

	table.insert(value98, ChildAdded:Connect(v498))

	local value982 = t1.value98
	local ChildRemoved = t1.value27.ChildRemoved
	local v501 = v490

	table.insert(value982, ChildRemoved:Connect(v501))

	local n12 = 0
	local value983 = t1.value98
	local Heartbeat = t1.value1.Heartbeat

	local function v505(p93)
		n12 = n12 + p93

		if n12 < 0.5 then
			return
		end

		local HumanoidRootPart = t1.value32()

		if HumanoidRootPart then
			HumanoidRootPart = HumanoidRootPart:FindFirstChild("HumanoidRootPart")
		end

		local v507

		if HumanoidRootPart then
			v507 = HumanoidRootPart:IsDescendantOf(t1.value3)
		else
			v507 = HumanoidRootPart
		end

		local Info, format, Rarity, Weight, Magnitude

		if v507 then
			if HumanoidRootPart and t1.value95 then
				for _, v in pairs(t1.value94) do
					Info = v.Info
					format = string.format
					Rarity = v.Rarity
					Weight = v.Weight
					Magnitude = (v.Position - HumanoidRootPart.Position).Magnitude
					Info.Text = format("%s  %.2fkg  %dm", Rarity, Weight, (math.floor(Magnitude)))
				end
			end

			return
		end

		HumanoidRootPart = nil

		if HumanoidRootPart and t1.value95 then
			for _, v in pairs(t1.value94) do
				Info = v.Info
				format = string.format
				Rarity = v.Rarity
				Weight = v.Weight
				Magnitude = (v.Position - HumanoidRootPart.Position).Magnitude
				Info.Text = format("%s  %.2fkg  %dm", Rarity, Weight, (math.floor(Magnitude)))
			end
		end
	end

	table.insert(value983, Heartbeat:Connect(v505))
end
function stopEsp()
	for _, v in ipairs(t1.value98) do
		v:Disconnect()
	end

	table.clear(t1.value98)

	local v519, v520, v521 = pairs(t1.value94)

	while true do
		v521 = v519(v520, v521)

		if not v521 then
			break
		end

		local v522 = t1.value94[v521]

		if v522 then
			t1.value94[v521] = nil
			pcall(function()
				v522.Gui:Destroy()
			end)
		end
	end

	if not t1.value93 then
		return
	end

	local function v523()
		t1.value93:Destroy()
	end

	pcall(v523)
	t1.value93 = nil
end

t1.value100 = true
t1.value101 = false
t1.value102 = false

function t1.value103()
	return t1.value52.Active or (#t1.value52.Manual > 0 or (t1.value53.Active or (t1.value54.Active or (t1.value55.Active or t1.value56.Active))))
end
function t1.value104(p94)
	return function()
		return not (t1.value100 and p94.Active)
	end
end

task.spawn(function()
	while true do
		if not t1.value100 then
			return
		end

		local u524 = false
		local HumanoidRootPart = t1.value103()

		if HumanoidRootPart then
			HumanoidRootPart = t1.value32()

			if HumanoidRootPart then
				HumanoidRootPart = HumanoidRootPart:FindFirstChild("HumanoidRootPart")
			end

			local v526

			if HumanoidRootPart then
				v526 = HumanoidRootPart:IsDescendantOf(t1.value3)
			else
				v526 = HumanoidRootPart
			end

			if not v526 then
				HumanoidRootPart = nil
			end

			if HumanoidRootPart then
				HumanoidRootPart = t1.value34()
			end
		end

		if HumanoidRootPart then
			local function v527()
				local v528 = t1.value64()
				local v530 = (v528 and #v528:GetChildren() or v528 or 0) > 0

				if v530 then
					v530 = t1.value52.Active or (#t1.value52.Manual > 0 and true or t1.value52.Carried)
				end

				if v530 then
					v283(function()
						return not t1.value100
					end)
					u524 = true
				end

				local Active = t1.value53.Active

				if Active then
					Active = t1.value100

					if Active then
						Active = not pcall(function() end)
					end
				end

				local Active2 = t1.value53.Active

				if Active2 then
					Active2 = t1.value100
				end

				if Active2 and t1.value71(t1.value104(t1.value53)) then
					u524 = true
				end

				local Active3 = t1.value54.Active

				if Active3 then
					Active3 = t1.value100
				end

				if Active3 and t1.value73(t1.value104(t1.value54)) then
					u524 = true
				end

				local Active4 = t1.value55.Active

				if Active4 then
					Active4 = t1.value100
				end

				if Active4 and t1.value83(t1.value104(t1.value55)) then
					u524 = true
				end

				local Active5 = t1.value56.Active

				if Active5 then
					Active5 = t1.value100
				end

				if Active5 and t1.value85(t1.value104(t1.value56)) then
					u524 = true
				end

				local Active6 = t1.value52.Active or #t1.value52.Manual > 0

				if Active6 then
					Active6 = t1.value100
				end

				if not Active6 then
					return
				end

				local function v536()
					local v537 = t1.value100 and not t1.value52.Active and true or false

					if not v537 then
						return v537
					end

					v537 = #t1.value52.Manual == 0

					return v537
				end

				if not t1.value67(v536) then
					return
				end

				u524 = true
			end

			pcall(v527)
			t1.value101 = false

			local v538 = not u524

			if v538 then
				v538 = not t1.value52.Active

				if v538 then
					v538 = not t1.value53.Active

					if v538 then
						v538 = not (t1.value54.Active or t1.value55.Active)

						if v538 then
							v538 = not t1.value56.Active
						end
					end
				end
			end

			if v538 then
				t1.value31.Status = "Waiting for work"
			end
		elseif not t1.value103() then
			t1.value31.Status = "Idle"
		end

		local v539 = os.clock() + (u524 and 0.15 or 1)

		while true do
			local value100 = t1.value100

			if value100 then
				if os.clock() < v539 then
					value100 = not t1.value102
				else
					value100 = false
				end
			end

			if not value100 then
				break
			end

			t1.value1.Heartbeat:Wait()

			continue
		end

		t1.value102 = false

		continue
	end
end)
task.spawn(function()
	while t1.value100 do
		pcall(t1.value91, "Food", t1.value57.FoodFilter)
		pcall(t1.value91, "Gears", t1.value57.GearFilter)
		task.wait(3)
	end
end)
task.spawn(function()
	while t1.value100 do
		if t1.value58.Rebirth then
			local v541 = t1.value92()

			if v541 then
				v541 = v541 <= t1.value46()
			end

			if v541 then
				t1.value36("Rebirth")
				task.wait(15)
			end
		end

		if t1.value58.ClaimIndex then
			t1.value36("ClaimIndexReward")
		end

		task.wait(1)
	end
end)
t1.value105 = createTextLabel(farmStatus, "Idle", t1.value13.text)
task.spawn(function()
	while t1.value100 do
		if t1.value105.Text ~= t1.value31.Status then
			t1.value105.Text = t1.value31.Status
		end

		t1.value1.Heartbeat:Wait()
	end
end)
v37(v111, "Auto Collect / Steal", false, function(p95)
	t1.value52.Active = p95
end)

local t12 = { "Any" }

for _, v in ipairs(t3) do
	table.insert(t12, v)
end

v24(v111, "Min Egg Rarity", t12, function(p96)
	t1.value59 = t1.value28[tostring(p96)] or 0
end)

local t13 = {}

if type(t1.value26.Eggs) == "table" then
	for k in pairs(t1.value26.Eggs) do
		table.insert(t13, k)
	end

	table.sort(t13, function(p97, p98)
		if t1.value49(p97) == t1.value49(p98) then
			return t1.value51(p97) > t1.value51(p98)
		else
			return t1.value49(p97) > t1.value49(p98)
		end
	end)
end

v24(v111, "Collect Priority", {
	"Highest Luck",
	"Highest Rarity",
	"Nearest",
	"Farthest"
}, function(p99)
	tostring(p99)
end)
v53(v111, "Tween Speed", 600, 100, 1300, function(p100)
	t1.value31.FlySpeed = math.clamp(p100, 100, 1300)
end)
v37(v111, "Auto Deliver Basket", true, function() end)
v71(v111, "Collect Once (queued)", function()
	local HumanoidRootPart = t1.value32()

	if HumanoidRootPart then
		HumanoidRootPart = HumanoidRootPart:FindFirstChild("HumanoidRootPart")
	end

	local v548

	if HumanoidRootPart then
		v548 = HumanoidRootPart:IsDescendantOf(t1.value3)
	else
		v548 = HumanoidRootPart
	end

	if not v548 then
		HumanoidRootPart = nil
	end

	if not HumanoidRootPart then
		return t1.value25("No character", t1.value13.bad)
	end

	local v549 = t1.value63(HumanoidRootPart.Position)[1]

	if not v549 then
		t1.value25("No matching egg", t1.value13.bad)

		return
	end

	if table.find(t1.value52.Manual, v549.Config.Name) then
		t1.value25("Queued " .. v549.Name)

		return
	end

	local Manual = t1.value52.Manual
	local Name = v549.Config.Name

	table.insert(Manual, Name)
	t1.value25("Queued " .. v549.Name)
end)
v37(v112, "Auto Plant Eggs", false, function(p101)
	t1.value53.Active = p101
	t1.value53.Cooldown = 0
end)
v24(v112, "Plant Min Rarity", t12, function(p102)
	t1.value53.MinRank = t1.value28[tostring(p102)] or 0
end)
v37(v112, "Auto Hatch Eggs", false, function(p103)
	t1.value54.Active = p103
end)
createTextLabel(stealTargets, "Steal mode uses same pickup remote on eggs outside your plot.\nToggle Auto Collect + set Min Rarity. Fly-to handles the rest.", t1.value13.subtext)
v71(stealTargets, "List Other Plots", function()
	local Plots = t1.value3:FindFirstChild("Plots")

	if Plots then
		local t14 = {}

		for _, child in ipairs(Plots:GetChildren()) do
			local Data = child:FindFirstChild("Data")

			if Data then
				Data = Data:FindFirstChild("Owner")
			end

			local v557

			if Data then
				v557 = Data.Value ~= t1.value8
			else
				v557 = Data
			end

			if v557 then
				local Name = Data.Value.Name or child.Name

				table.insert(t14, Name)
			end
		end

		t1.value25(#t14 .. " other plot(s): " .. table.concat(t14, ", "))
	else
		return t1.value25("No Plots folder", t1.value13.bad)
	end
end)
v53(stealOptions, "Max Steal Distance", 500, 50, 3000, function() end)
v37(stealOptions, "Ignore Own Plot Eggs", true, function() end)
v37(stealOptions, "Auto Return After Steal", true, function() end)
v37(team, "Auto Place Best Pets", false, function(p104)
	t1.value55.Active = p104
end)
v37(team, "Swap Weaker Pets", false, function(p105)
	t1.value55.Swap = p105
end)
v37(feeding, "Auto Feed Pets", false, function(p106)
	t1.value56.Active = p106
	table.clear(t1.value56.Cooldown)
end)

local t15 = {}
local Foods = t1.value26.Foods

if type(Foods) == "table" then
	local v561, v562, v563 = pairs(t1.value26.Foods)
	local t16 = {}

	while true do
		local v565

		v563, v565 = v561(v562, v563)

		if not v563 then
			break
		end

		if type(v565) == "table" then
			local insert = table.insert
			local Cost = v565.Cost

			insert(t16, {
				Name = v563,
				Cost = tonumber(Cost) or 0
			})
		end
	end

	table.sort(t16, function(p107, p108)
		return p107.Cost < p108.Cost
	end)

	for _, v in ipairs(t16) do
		local Name = v.Name

		table.insert(t15, Name)
	end
end

v24(feeding, "Food Priority", { "Best XP/Cash", "Lowest XP", "Highest XP" }, function() end)
v24(feeding, "Specific Food (all if unset)", t15, function(p109)
	t1.value56.FoodFilter = {}
	t1.value56.FoodFilter[tostring(p109)] = true
end)
v37(food, "Auto Buy Food", false, function(p110)
	t1.value57.BuyFood = p110
end)
v24(food, "Food To Buy", t1.value88("Food"), function(p111)
	t1.value57.FoodFilter = {
		[tostring(p111)] = true
	}
end)
v37(gears, "Auto Buy Gears/Radars", false, function(p112)
	t1.value57.BuyGears = p112
end)
v24(gears, "Gear To Buy", t1.value88("Gears"), function(p113)
	t1.value57.GearFilter = {
		[tostring(p113)] = true
	}
end)
v53(gears, "Keep Cash", 0, 0, 100000000, function(p114)
	t1.value57.KeepCash = p114
end)
v37(v119, "Auto Rebirth", false, function(p115)
	t1.value58.Rebirth = p115
end)
v37(v119, "Auto Claim Index Reward", false, function(p116)
	t1.value58.ClaimIndex = p116
end)
t1.value106 = false
t1.value107 = 60
v37(movement, "Speed Boost", false, function(p117)
	t1.value106 = p117
end)
v53(movement, "Boost Speed", 60, 16, 1300, function(p118)
	t1.value107 = p118
end)
task.spawn(function()
	while t1.value100 do
		local value106 = t1.value106

		if value106 then
			value106 = not t1.value101
		end

		if value106 then
			local v572 = t1.value33()
			local v573 = v149()
			local v574

			if v572 then
				if v573 then
					v574 = not v572.Sit
				else
					v574 = v573
				end
			else
				v574 = v572
			end

			if v574 then
				local MoveDirection = v572.MoveDirection
				local vector3 = Vector3.new(MoveDirection.X, 0, MoveDirection.Z)

				if vector3.Magnitude >= 0.05 then
					v573.AssemblyLinearVelocity = Vector3.new(0, v573.AssemblyLinearVelocity.Y, 0) + vector3.Unit * t1.value107
				end
			end
		end

		t1.value1.Heartbeat:Wait()
	end
end)
t1.value108 = false
t1.value2.JumpRequest:Connect(function()
	local value108 = t1.value108 and t1.value33()

	if not value108 then
		return
	end

	pcall(function()
		value108:ChangeState(Enum.HumanoidStateType.Jumping)
	end)
end)
v37(movement, "Infinite Jump", false, function(p119)
	t1.value108 = p119
end)
t1.value109 = false
t1.value110 = false
t1.value1.Stepped:Connect(function()
	if t1.value109 then
		t1.value110 = true
		t1.value38(true)

		return
	end

	if not (t1.value110 and not t1.value101) then
		return
	end

	t1.value38(false)
end)
v37(movement, "Noclip", false, function(p120)
	t1.value109 = p120
end)
t1.value111 = nil
t1.value112 = {}
t1.value111 = {}

function t1.value113()
	local v578, v579, v580 = ipairs(t1.value111)

	while true do
		local v581

		v580, v581 = v578(v579, v580)

		if not v580 then
			break
		end

		v581:Disconnect()
	end

	table.clear(t1.value111)

	for k, v in pairs(t1.value112) do
		if k.Parent then
			pcall(function()
				k.HoldDuration = v
			end)
		end
	end

	table.clear(t1.value112)
end
function t1.value114(p121)
	if not p121:IsA("ProximityPrompt") then
		return
	end

	if t1.value112[p121] == nil then
		t1.value112[p121] = p121.HoldDuration
	end

	if p121.HoldDuration == 0 then
		return
	end

	p121.HoldDuration = 0
end
function t1.value115()
	t1.value113()

	local ipairs_ = ipairs
	local value3 = t1.value3

	for _, descendant in ipairs_(value3.GetDescendants(value3)) do
		if descendant:IsA("ProximityPrompt") then
			t1.value114(descendant)
		end
	end

	table.insert(t1.value111, t1.value3.DescendantAdded:Connect(function(descendant)
		if not descendant:IsA("ProximityPrompt") then
			return
		end

		task.defer(t1.value114, descendant)
	end))

	local value111 = t1.value111
	local PromptShown = t1.value5.PromptShown
	local value114 = t1.value114

	table.insert(value111, PromptShown:Connect(value114))
end

v37(movement, "Instant Pickup (HoldDuration 0)", false, function(p122)
	if p122 then
		t1.value115()
	else
		t1.value113()
	end
end)
v37(esp, "ESP Eggs", false, function(p123)
	if p123 then
		t1.value99()
	else
		stopEsp()
	end
end)
v24(esp, "ESP Min Rarity", t12, function(p124)
	t1.value62 = t1.value28[tostring(p124)] or 0

	if not t1.value93 then
		return
	end

	t1.value99()
end)
t1.value116 = "Least Players"
t1.value117 = false
t1.value118 = {}
v24(server, "Server Hop Mode", { "Most Players", "Least Players", "Random" }, function(p125)
	t1.value116 = tostring(p125)
end)
v71(server, "Server Hop", function()
	if t1.value117 then
		return t1.value25("Hop already running", t1.value13.bad)
	end

	task.spawn(function()
		local v591 = t1.value116 == "Least Players" and "Asc" or false or "Desc"
		local v592 = nil

		local function v593()
			return t1.value7:JSONDecode(unpack_({ game:HttpGet(unpack_({ string.format("https://games.roblox.com/v1/games/%d/servers/Public?sortOrder=%s&excludeFullGames=true&limit=100", game.PlaceId, v592) })) }))
		end

		v592 = v591

		local ok, result = pcall(v593)

		if not ok or type(result) ~= "table" then
			return t1.value25("Hop fetch failed", t1.value13.bad)
		end

		local v596, v597, v598 = ipairs(result.data or {})
		local t17 = {}

		while true do
			local v600

			v598, v600 = v596(v597, v598)

			if not v598 then
				break
			end

			local id = v600.id

			if id then
				id = v600.id ~= game.JobId

				if id then
					local v602 = tonumber(v600.playing) or 99
					local maxPlayers = v600.maxPlayers

					if v602 < (tonumber(maxPlayers) or 0) then
						id = not t1.value118[v600.id]
					else
						id = false
					end
				end
			end

			if id then
				table.insert(t17, v600)
			end
		end

		if #t17 == 0 then
			return t1.value25("No available servers", t1.value13.bad)
		end

		local v604

		if t1.value116 == "Random" then
			v604 = t17[math.random(1, #t17)]
		else
			table.sort(t17, function(p126, p127)
				local playing = p126.playing
				local v606 = tonumber(playing) or 0
				local v607 = tonumber(p127.playing) or 0

				return t1.value116 == "Least Players" and v606 < v607 and true or v607 < v606
			end)
			v604 = t17[1]
		end

		t1.value118[v604.id] = true
		pcall(function()
			t1.value6:TeleportToPlaceInstance(game.PlaceId, v604.id, t1.value8)
		end)
		t1.value25("Hopping to " .. v604.id:sub(1, 8) .. "…")
	end)
end)
t1.value119 = v74(server, "Job ID", "paste a job id…", function() end)
v71(server, "Join Job ID", function()
	local v608 = t1.value119.GetValue()
	local match = tostring(v608):match("^%s*(.-)%s*$")

	if match == "" then
		return t1.value25("Empty job id", t1.value13.bad)
	end

	local function v610()
		t1.value6:TeleportToPlaceInstance(game.PlaceId, match, t1.value8)
	end

	pcall(v610)
end)
v71(server, "Copy Current Job ID", function()
	local JobId = game.JobId or ""
	local jobId = tostring(JobId)
	local setclipboard_ = setclipboard

	if type(setclipboard_) ~= "function" then
		t1.value25("JobId: " .. jobId)

		return
	end

	pcall(setclipboard, jobId)
	t1.value25("JobId: " .. jobId)
end)
v71(server, "Rejoin Server", function()
	local function v614()
		if game.JobId == "" then
			t1.value6:Teleport(game.PlaceId, t1.value8)
		else
			t1.value6:TeleportToPlaceInstance(game.PlaceId, game.JobId, t1.value8)
		end
	end

	pcall(v614)
end)
v53(performance, "FPS Cap", 240, 30, 1000, function(p128)
	local v615 = math.floor(p128)
	local v616 = math.clamp(v615, 30, 1000)
	local setfpscap_ = setfpscap

	if type(setfpscap_) == "function" then
		pcall(setfpscap, v616)

		return
	end

	local sethiddenproperty_ = sethiddenproperty

	if type(sethiddenproperty_) ~= "function" then
		return
	end

	pcall(sethiddenproperty, game, "MaxFPS", v616)
end)
t1.value120 = false
t1.value121 = {}
t1.value122 = false

function t1.value123(p129)
	if not (t1.value120 and p129.Parent) then
		return
	end

	if p129:IsA("ParticleEmitter") or (p129:IsA("Trail") or p129:IsA("Beam")) then
		if t1.value121[p129] ~= nil then
			p129.Enabled = false

			return
		end

		t1.value121[p129] = {
			Enabled = p129.Enabled
		}
		p129.Enabled = false

		return
	end

	if p129:IsA("PointLight") or (p129:IsA("SpotLight") or p129:IsA("SurfaceLight")) then
		if t1.value121[p129] == nil then
			t1.value121[p129] = {
				Enabled = p129.Enabled,
				Brightness = p129.Brightness
			}
		end

		p129.Enabled = false
		pcall(function()
			p129.Brightness = 0
		end)

		return
	end

	if p129:IsA("Decal") or p129:IsA("Texture") then
		local v619 = p129.Name == "face"

		if v619 then
			v619 = p129.Parent

			if v619 then
				v619 = p129.Parent.Name == "Head"
			end
		end

		if v619 then
			return
		end

		if t1.value121[p129] == nil then
			t1.value121[p129] = {
				Transparency = p129.Transparency
			}
		end

		pcall(function()
			p129.Transparency = 1
		end)

		return
	end

	if not p129:IsA("BasePart") then
		return
	end

	if t1.value121[p129] == nil then
		t1.value121[p129] = {
			CastShadow = p129.CastShadow,
			Reflectance = p129.Reflectance
		}
	end

	pcall(function()
		p129.CastShadow = false
		p129.Reflectance = 0
	end)
end

local function v620()
	for k, v in pairs(t1.value121) do
		if k.Parent then
			for k2, v2 in pairs(v) do
				pcall(function()
					k[k2] = v2
				end)
			end
		end
	end

	table.clear(t1.value121)
end

v37(performance, "Optimizer", false, function(p130)
	t1.value120 = p130

	if not p130 then
		v620()

		return
	end

	if t1.value122 then
		return
	end

	task.spawn(function()
		local n13 = 0

		for _, descendant in ipairs(t1.value3:GetDescendants()) do
			if not t1.value120 then
				return
			end

			t1.value123(descendant)

			if os.clock() - n13 > 0.004 then
				t1.value1.Heartbeat:Wait()
				n13 = os.clock()
			end
		end
	end)
end)
t1.value124 = true
task.spawn(function()
	while t1.value100 do
		local value124 = t1.value124

		if value124 then
			local getconnections_ = getconnections

			value124 = type(getconnections_) == "function"
		end

		if value124 then
			local ok, result = pcall(getconnections, t1.value8.Idled)

			if ok then
				ok = type(result) == "table"
			end

			if ok then
				for _, v in ipairs(result) do
					pcall(function()
						v:Disable()
					end)
				end
			end
		end

		task.wait(30)
	end
end)
v37(utility, "Anti AFK", true, function(p131)
	t1.value124 = p131
end)
v71(utility, "Unload Script", function()
	if not getgenv().AzureSteal_Unload then
		return
	end

	getgenv().AzureSteal_Unload()
end)
v71(credits, "Azure | Steal A Egg", function()
	t1.value25("Azure | Steal A Egg")
end)
v71(credits, "Copy Discord Link", function()
	local setclipboard_ = setclipboard

	if type(setclipboard_) ~= "function" then
		t1.value25("Copied")

		return
	end

	pcall(setclipboard, "https://discord.gg/9YkBCKQeGt")
	t1.value25("Copied")
end)
t1.value2.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end

	if input.KeyCode ~= Enum.KeyCode.RightShift then
		return
	end

	t1.value15.Visible = not t1.value15.Visible
end)
getgenv().AzureSteal_Unload = function()
	t1.value52.Active = false
	t1.value53.Active = false
	t1.value54.Active = false
	t1.value55.Active = false
	t1.value56.Active = false
	t1.value38(false)
	stopEsp()

	local function v635()
		t1.value14:Destroy()
	end

	t1.value113()
	v620()
	pcall(v635)
end
t1.value25("Azure loaded | RightShift toggles menu")
