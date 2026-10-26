-- This file was generated at discord.gg/syncrypt

local t1 = {
	value3 = 22126428612671,
	value2 = "loadstring"
}
local t2 = {
	value1 = loadstring(game:HttpGet("https://jnkie.com/sdk/library.lua"))()
}

t2.value1.service = "nibum"
t2.value1.identifier = "1086"
t2.value1.provider = "nibum"
t2.value2 = "https://rscripts.net/raw/auto-play-script-source_1792607632485_wYR5fmaSQB.txt"
t2.value3 = nil
t2.value3 = false

function t2.value4()
	if t2.value3 then
		return
	end

	t2.value3 = true
	print("[nibum HUB] KEY SYSTEM SUCCESS")
	task.delay(0.15, function()
		loadstring(game:HttpGet(t2.value2))()
	end)
end

local Players = game:GetService("Players")

t2.value5 = game:GetService("TweenService")

local UserInputService = game:GetService("UserInputService")

t2.value6 = game:GetService("Lighting")
t1.value3 = game:GetService("CoreGui")
Players = Players.LocalPlayer
Players = UserInputService.TouchEnabled

if Players then
	Players = not UserInputService.KeyboardEnabled
end

t1.value1 = t1.value1
t2.value7 = Players
t1.value5 = "Color3"
UserInputService = Color3.fromRGB
t1.value4 = 9
t1.value5 = 8
UserInputService = UserInputService(t1.value5, t1.value4, 11)
t1.value5 = Color3.fromRGB
t1.value4 = t1.value5(13, 14, 17)
Players = Color3.fromRGB(18, 20, 24)

local color3 = Color3.fromRGB(24, 26, 32)
local color32 = Color3.fromRGB(30, 33, 40)
local color33 = Color3.fromRGB(36, 39, 48)
local color34 = Color3.fromRGB(48, 52, 64)
local color35 = Color3.fromRGB(215, 55, 55)
local color36 = Color3.fromRGB(155, 30, 30)
local color37 = Color3.fromRGB(235, 80, 80)
local color38 = Color3.fromRGB(65, 195, 115)
local color39 = Color3.fromRGB(198, 201, 215)
local color310 = Color3.fromRGB(140, 144, 162)
local color311 = Color3.fromRGB(80, 83, 100)
local color312 = Color3.fromRGB(255, 255, 255)
local color313 = Color3.fromRGB(0, 0, 0)
local color314 = Color3.fromRGB(235, 175, 35)
local color315 = Color3.fromRGB(175, 128, 18)
local color316 = Color3.fromRGB(114, 137, 218)

t2.value8 = {
	bg0 = UserInputService,
	bg1 = t1.value4,
	bg2 = Players,
	bg3 = color3,
	bg4 = color32,
	brd = color33,
	brd2 = color34,
	acc = color35,
	accDark = color36,
	accGlow = color37,
	grn = color38,
	txt = color39,
	txt2 = color310,
	txt3 = color311,
	white = color312,
	black = color313,
	gold = color314,
	goldDk = color315,
	dcBlue = color316
}
t1.value4 = "\250x\249X\223s\237\246\237\221\22C\236`\18l`"
t2.value9 = "nibum_HUB_Key.txt"

function t1.value5()
	if not readfile then
		return nil
	end

	local ok, result = pcall(readfile, t2.value9)

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

t2.value10 = t1.value5

function t2.value11()
	if not delfile then
		return
	end

	pcall(delfile, t2.value9)
end

getgenv().UI_CLOSED = false
getgenv().SCRIPT_KEY = nil
task.spawn(function()
	pcall(function()
		game:GetService("ContentProvider"):PreloadAsync({ "rbxassetid://77911892724832" })
	end)
end)
t1.value4 = Instance.new
t2.value12 = t1.value4("ScreenGui")
t2.value12.Name = "nibum_HUB_KeySystem"
t2.value12.ResetOnSpawn = false
t2.value12.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
t2.value12.IgnoreGuiInset = true
t2.value12.Parent = t1.value3
color316 = t1.value1
color315 = Instance.new("BlurEffect")
color315.Size = 16
color315.Name = "nibum_HUB_KeyBlur"
color315.Parent = t2.value6

local function v23(p1, p2, p3)
	local value5 = t2.value5
	local TweenInfo_ = TweenInfo

	value5.Create(value5, p1, TweenInfo_.new(p2), p3):Play()
end
local function v26(p4, p5, p6, p7, p8)
	t2.value5:Create(p4, TweenInfo.new(p5, p6, p7), p8):Play()
end

function t2.value13(p9, p10, p11, p12)
	local value5 = t2.value5
	local tweenInfoNew = TweenInfo.new
	local EasingDirection = Enum.EasingDirection

	value5.Create(value5, p9, tweenInfoNew(p10, p11, EasingDirection.InOut, -1, true), p12):Play()
end
function t2.value14(p13, p14, p15, p16, p17, p18)
	local Frame = Instance.new("Frame", p13)

	Frame.Size = p14
	Frame.Position = p15
	Frame.BackgroundColor3 = p16 or t2.value8.bg1
	Frame.BorderSizePixel = 0

	if p17 then
		Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, p17)
	end

	if not p18 then
		return Frame
	end

	Frame.ZIndex = p18

	return Frame
end
function t2.value15(p19, p20, p21, p22, p23, p24)
	local TextLabel = Instance.new("TextLabel", p19)

	TextLabel.Size = UDim2.new(1, 0, 1, 0)
	TextLabel.Position = UDim2.new(0, 0, 0, 0)
	TextLabel.BackgroundTransparency = 1
	TextLabel.Text = p20
	TextLabel.TextSize = p21 or 13
	TextLabel.TextColor3 = p22 or t2.value8.txt
	TextLabel.Font = p23 or Enum.Font.GothamMedium
	TextLabel.TextXAlignment = p24 or Enum.TextXAlignment.Left
	TextLabel.TextYAlignment = Enum.TextYAlignment.Center
	TextLabel.TextWrapped = false

	return TextLabel
end

color315 = function(p25, p26, p27, p28, p29, p30)
	local TextButton = Instance.new("TextButton", p25)

	TextButton.Size = p26
	TextButton.Position = p27
	TextButton.BackgroundColor3 = p28 or t2.value8.bg3
	TextButton.BorderSizePixel = 0
	TextButton.Text = ""
	TextButton.AutoButtonColor = false

	if p29 then
		Instance.new("UICorner", TextButton).CornerRadius = UDim.new(0, p29)
	end

	if not p30 then
		return TextButton
	end

	TextButton.ZIndex = p30

	return TextButton
end
color314 = function(p31, p32, p33)
	p31.MouseButton1Down:Connect(function()
		local v33 = p31
		local t3 = {
			Size = UDim2.new(p32.X.Scale, p32.X.Offset - 2, p32.Y.Scale, p32.Y.Offset - 2),
			Position = UDim2.new(p33.X.Scale, p33.X.Offset + 1, p33.Y.Scale, p33.Y.Offset + 1)
		}
		local value5 = t2.value5
		local TweenInfo_ = TweenInfo

		value5.Create(value5, v33, TweenInfo_.new(0.07), t3):Play()
	end)
	p31.MouseButton1Up:Connect(function()
		local v37 = p31
		local t4 = {
			Size = p32,
			Position = p33
		}
		local value5 = t2.value5
		local TweenInfo_ = TweenInfo

		value5.Create(value5, v37, TweenInfo_.new(0.07), t4):Play()
	end)
end
color313 = function(p34, p35, p36, p37)
	local UIStroke = Instance.new("UIStroke", p34)

	UIStroke.Color = p35 or t2.value8.brd
	UIStroke.Thickness = p36 or 1
	UIStroke.Transparency = p37 or 0

	return UIStroke
end
color312 = t2.value7
color311 = function(p38, p39, p40)
	p38.MouseEnter:Connect(function()
		local v42 = p38
		local t5 = {
			BackgroundColor3 = p40
		}
		local value5 = t2.value5
		local TweenInfo_ = TweenInfo

		value5.Create(value5, v42, TweenInfo_.new(0.14), t5):Play()
	end)
	p38.MouseLeave:Connect(function()
		local v46 = p38
		local t6 = {
			BackgroundColor3 = p39
		}
		local value5 = t2.value5
		local TweenInfo_ = TweenInfo

		value5.Create(value5, v46, TweenInfo_.new(0.14), t6):Play()
	end)
end

if color312 then
	color312 = workspace.CurrentCamera.ViewportSize.X - 16
	color312 = math.min(330, color312)
end

t1.value1 = color316
color316 = color312 or 490
color312 = t1.value1
color312 = t2.value7 and 500 or 430
t2.value16 = t2.value14(t2.value12, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), t2.value8.black, 0, 1)
t2.value16.BackgroundTransparency = 1
color310 = t2.value14(t2.value12, UDim2.new(0, color316 + 80, 0, color312 + 60), UDim2.new(0.5, 0, 0.5, 0), t2.value8.acc, 40, 0)
color310.AnchorPoint = Vector2.new(0.5, 0.5)
color310.BackgroundTransparency = 0.92
color39 = t2.value5
color38 = TweenInfo.new(4, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true)
color37 = {
	BackgroundTransparency = 0.87,
	Size = UDim2.new(0, color316 + 120, 0, color312 + 100)
}
color39.Create(color39, color310, color38, color37):Play()
t2.value17 = t2.value14(t2.value12, UDim2.new(0, color316, 0, color312), UDim2.new(0.5, 0, 0.5, 0), t2.value8.bg1, 12, 2)
t2.value17.AnchorPoint = Vector2.new(0.5, 0.5)
t2.value17.ClipsDescendants = true
color313(t2.value17, t2.value8.brd2, 1)
color316 = t2.value14(t2.value17, UDim2.new(1, 0, 0.5, 0), UDim2.new(0, 0, 0, 0), t2.value8.white, 0, 3)
color316.BackgroundTransparency = 0.97
color316 = Instance.new("UIGradient", color316)
color316.Rotation = 90
color316.Transparency = NumberSequence.new({ NumberSequenceKeypoint.new(0, 0.93), NumberSequenceKeypoint.new(1, 1) })
color316 = t2.value7 and 44 or 38
color312 = t2.value14(t2.value17, UDim2.new(1, 0, 0, color316), UDim2.new(0, 0, 0, 0), t2.value8.bg0, 0, 4)
Instance.new("UICorner", color312).CornerRadius = UDim.new(0, 12)
t2.value14(color312, UDim2.new(1, 0, 0, 12), UDim2.new(0, 0, 1, -12), t2.value8.bg0, 0, 4)
t2.value14(color312, UDim2.new(1, 0, 0, 2), UDim2.new(0, 0, 1, -2), t2.value8.acc, 0, 5)
color310 = t2.value7 and 22 or 20
color39 = Instance.new("ImageLabel", color312)
color39.Size = UDim2.new(0, color310, 0, color310)
color39.Position = UDim2.new(0, t2.value7 and 12 or 10, 0.5, -color310 / 2)
color39.BackgroundTransparency = 1
color39.Image = "rbxassetid://77911892724832"
color310 = Enum.ScaleType
t1.value7 = 27924317549259
color39.ScaleType = color310.Fit
color39.ZIndex = 6
color310 = t2.value15
color39 = "<font color=\"#D73737\">nibum</font>HUB"

local value7 = t2.value7

value7 = 13
color310 = color310(color312, color39, value7, t2.value8.white, Enum.Font.GothamBold, Enum.TextXAlignment.Left)
color310.Size = UDim2.new(0, 90, 1, -4)
color310.Position = UDim2.new(0, t2.value7 and 40 or 36, 0, 2)
color310.RichText = true
color310.ZIndex = 6
color310 = t2.value14
color39 = UDim2.new(0, 78, 0, t2.value7 and 18 or 16)
value7 = UDim2.new
color37 = t2.value7 and -9
color310 = color310(color312, color39, value7(0, t2.value7 and 136 or 128, 0.5, color37 or -8), t2.value8.bg3, 4, 6)
color313(color310, t2.value8.brd2, 1)
t2.value15(color310, "Key System", 8, t2.value8.txt2, Enum.Font.GothamMedium, Enum.TextXAlignment.Center).ZIndex = 7
color310 = t2.value7 and 30 or 26
color312 = color315(color312, UDim2.new(0, color310, 0, color310), UDim2.new(1, -(color310 + 6), 0.5, -color310 / 2), t2.value8.bg2, 6, 6)
t2.value18 = t2.value15(color312, "X", t2.value7 and 13 or 12, Color3.fromRGB(180, 50, 50), Enum.Font.GothamBold, Enum.TextXAlignment.Center)
t2.value18.ZIndex = 7
color311(color312, t2.value8.bg2, t2.value8.acc)
color312.MouseEnter:Connect(function()
	t2.value18.TextColor3 = t2.value8.white
end)
color312.MouseLeave:Connect(function()
	t2.value18.TextColor3 = Color3.fromRGB(180, 50, 50)
end)
color316 = t2.value14(t2.value17, UDim2.new(1, -36, 1, -(color316 + 14)), UDim2.new(0, 18, 0, color316 + 8), t2.value8.bg1, 0, 3)
color316.BackgroundTransparency = 1
color310 = t2.value14
color39 = t2.value7 and 62 or 70
color310 = color310(color316, UDim2.new(0, color39, 0, color39), UDim2.new(0.5, -color39 / 2, 0, 2), t2.value8.bg2, 16, 4)
color313(color310, t2.value8.acc, 2, 0.3)
value7 = color310:FindFirstChildOfClass("UIStroke")
color37 = Instance.new("UIGradient")
color37.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t2.value8.acc), ColorSequenceKeypoint.new(0.5, t2.value8.accGlow), ColorSequenceKeypoint.new(1, t2.value8.accDark) })
color37.Parent = value7
value7 = t2.value5
color36 = TweenInfo.new(3, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1)
value7.Create(value7, color37, color36, {
	Rotation = 360
}):Play()
t2.value19 = Instance.new("TextLabel", color310)
t2.value19.Size = UDim2.new(1, 0, 1, 0)
t2.value19.BackgroundTransparency = 1
t2.value19.Text = "<font color=\"#D73737\">nibum HUB</font>"
t2.value19.RichText = true
t2.value19.TextColor3 = t2.value8.white
t2.value19.Font = Enum.Font.GothamBold
t2.value19.TextSize = t2.value7 and 14 or 16
t2.value19.TextXAlignment = Enum.TextXAlignment.Center
t2.value19.TextYAlignment = Enum.TextYAlignment.Center
t2.value19.ZIndex = 4
t2.value20 = Instance.new("ImageLabel", color310)
t2.value20.Size = UDim2.new(1, -8, 1, -8)
t2.value20.Position = UDim2.new(0, 4, 0, 4)
t2.value20.BackgroundTransparency = 1
t2.value20.Image = "rbxassetid://77911892724832"
value7 = t2.value20
color37 = Enum.ScaleType.Fit
t1.value6 = 22013641402378
value7.ScaleType = color37
t2.value20.ImageTransparency = 1
t2.value20.ZIndex = 5
Instance.new("UICorner", t2.value20).CornerRadius = UDim.new(0, 12)
value7 = function()
	if not t2.value20.IsLoaded then
		return
	end

	t2.value19.Visible = false

	local value20 = t2.value20
	local value5 = t2.value5
	local TweenInfo_ = TweenInfo

	value5.Create(value5, value20, TweenInfo_.new(0.3), {
		ImageTransparency = 0
	}):Play()
end
t2.value20:GetPropertyChangedSignal("IsLoaded"):Connect(value7)
task.delay(0.1, value7)
value7 = t2.value13
color37 = Enum.EasingStyle.Sine
color36 = {
	BackgroundColor3 = t2.value8.bg3
}
t1.value6 = "C\231\174T"
t1.value9 = color36
value7(color310, 2.2, color37, t1.value9)
color310 = color39 + 12
t1.value8 = 7312846245197
t1.value7 = "y\248z\154w"
color39 = t2.value15
value7 = t2.value7
color37 = t1.value1
t1.value9 = value7 and 18 or value7 or 20
value7 = t2.value8.white
color37 = Enum
t1.value6 = 14995557423942
t1.value8 = "\154\243\245\1750\11l\223&\159"
color39 = color39(color316, "Verify Your Key", t1.value9, value7, color37.Font.GothamBold, Enum.TextXAlignment.Center)
t1.value6 = 26
t1.value9 = UDim2
t1.value7 = 28
t1.value9 = t1.value9.new(1, 0, 0, t2.value7 and t1.value6 or t1.value7)
t1.value8 = "s\138T\207"
color39.Size = t1.value9
color39.Position = UDim2.new(0, 0, 0, color310)
color39.ZIndex = 4
color39 = t2.value15(color316, "Enter your key below to access nibum HUB", t2.value7 and 11 or 12, t2.value8.txt2, Enum.Font.Gotham, Enum.TextXAlignment.Center)
t1.value9 = UDim2.new
t1.value8 = t1.value1
value7 = t2.value7 and 16
t1.value8 = 18
t1.value7 = value7
color39.Size = t1.value9(1, 0, 0, t1.value7 or t1.value8)
value7 = t1.value1
t1.value7 = 30453298968420
t1.value6 = value7
color39.Position = UDim2.new(0, 0, 0, color310 + (t2.value7 and 28 or 30))
value7 = t1.value1
value7 = t1.value1
color39.ZIndex = 4
color39 = t2.value7 and 54 or 60
value7 = t1.value1
t1.value9 = color39
color310 = color310 + t1.value9
color39 = t2.value7
t1.value9 = color39 and 42 or color39 or 38
t2.value21 = t2.value14(color316, UDim2.new(1, 0, 0, t1.value9), UDim2.new(0, 0, 0, color310), t2.value8.bg2, 8, 4)
color39 = color313(t2.value21, t2.value8.brd2, 1, 0.25)
value7 = t1.value1
t1.value6 = "UDim2"
t1.value8 = 38
t2.value22 = color39
color39 = t2.value14
value7 = t2.value7 and (t1.value8 or 34) or 34
color39 = color39(t2.value21, UDim2.new(0, value7, 1, -8), UDim2.new(0, 6, 0, 4), t2.value8.bg3, 6, 5)
t2.value15(color39, "KEY", 8, t2.value8.acc, Enum.Font.GothamBold, Enum.TextXAlignment.Center).ZIndex = 6
t2.value14(t2.value21, UDim2.new(0, 1, 1, -12), UDim2.new(0, value7 + 10, 0, 6), t2.value8.brd2, 0, 5)
t2.value23 = Instance.new("TextBox", t2.value21)
t2.value23.Size = UDim2.new(1, -(value7 + 18), 1, 0)
t2.value23.Position = UDim2.new(0, value7 + 14, 0, 0)
t2.value23.BackgroundTransparency = 1
t2.value23.PlaceholderText = "Enter your verification key..."
t2.value23.PlaceholderColor3 = t2.value8.txt3
t2.value23.Text = ""
t2.value23.TextColor3 = t2.value8.txt
t2.value23.TextSize = t2.value7 and 12 or 13
t2.value23.Font = Enum.Font.GothamMedium
t2.value23.TextXAlignment = Enum.TextXAlignment.Left
t2.value23.ClearTextOnFocus = false
t2.value23.ZIndex = 5
t1.value7 = Instance.new("UIPadding", t2.value23)
t1.value7.PaddingLeft = UDim.new(0, 2)
color39 = t2.value23.Focused

function t1.value8()
	v23(t2.value22, 0.16, {
		Color = t2.value8.acc,
		Thickness = 1.5,
		Transparency = 0
	})
	v23(t2.value21, 0.16, {
		BackgroundColor3 = t2.value8.bg3
	})
end

color39:Connect(t1.value8)
color39 = t2.value23.FocusLost

function t1.value8()
	v23(t2.value22, 0.16, {
		Color = t2.value8.brd2,
		Thickness = 1,
		Transparency = 0.25
	})
	v23(t2.value21, 0.16, {
		BackgroundColor3 = t2.value8.bg2
	})
end

color39:Connect(t1.value8)
color39 = color310 + t1.value9 + 5
t1.value8 = t2.value15(color316, "", t2.value7 and 10 or 11, t2.value8.txt2, Enum.Font.Gotham, Enum.TextXAlignment.Center)
t2.value24 = t1.value8
t2.value24.Size = UDim2.new(1, 0, 0, 14)
t2.value24.Position = UDim2.new(0, 0, 0, color39)
t2.value24.ZIndex = 4

function t2.value25()
	local Position = t2.value21.Position

	for _ = 1, 3 do
		v23(t2.value21, 0.05, {
			Position = UDim2.new(Position.X.Scale, Position.X.Offset - 7, Position.Y.Scale, Position.Y.Offset)
		})
		task.wait(0.05)
		v23(t2.value21, 0.05, {
			Position = UDim2.new(Position.X.Scale, Position.X.Offset + 7, Position.Y.Scale, Position.Y.Offset)
		})
		task.wait(0.05)
	end

	t2.value21.Position = Position
end

color39 = t2.value7 and 24 or 20
color310 = color310 + t1.value9 + color39
color39 = t2.value7 and 40 or 36
value7 = UDim2.new(0.5, -4, 0, color39)
color37 = UDim2.new(0, 0, 0, color310)
color36 = color315(color316, value7, color37, t2.value8.bg3, 8, 4)
color313(color36, t2.value8.brd2, 1, 0.3)
color35 = Instance.new("UIGradient", color36)
color35.Rotation = 90
color35.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t2.value8.bg4), ColorSequenceKeypoint.new(1, t2.value8.bg3) })
t2.value26 = t2.value15(color36, "Get Key", t2.value7 and 12 or 13, t2.value8.txt, Enum.Font.GothamSemibold, Enum.TextXAlignment.Center)
t2.value26.ZIndex = 5
color311(color36, t2.value8.bg3, t2.value8.bg4)
color36.MouseEnter:Connect(function()
	t2.value26.TextColor3 = t2.value8.white
end)
color36.MouseLeave:Connect(function()
	t2.value26.TextColor3 = t2.value8.txt
end)
color314(color36, value7, color37)
value7 = UDim2.new(0.5, -4, 0, color39)
color37 = UDim2.new(0.5, 4, 0, color310)
t2.value27 = color315(color316, value7, color37, t2.value8.acc, 8, 4)
color35 = Instance.new("UIGradient", t2.value27)
color35.Rotation = 90
color35.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, t2.value8.accGlow), ColorSequenceKeypoint.new(1, t2.value8.accDark) })
t2.value28 = t2.value15(t2.value27, "Verify Key", t2.value7 and 12 or 13, t2.value8.white, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
t2.value28.ZIndex = 5
color311(t2.value27, t2.value8.acc, t2.value8.accGlow)
color314(t2.value27, value7, color37)
color314 = color310 + color39 + (t2.value7 and 14 or 12)
t2.value14(color316, UDim2.new(1, 0, 0, 1), UDim2.new(0, 0, 0, color314), t2.value8.brd, 0, 3)
color314 = color314 + (t2.value7 and 12 or 10)
color310 = t2.value7 and 64 or 58
color39 = t2.value14(color316, UDim2.new(1, 0, 0, color310), UDim2.new(0, 0, 0, color314), t2.value8.bg2, 8, 4)
color313(color39, t2.value8.gold, 1, 0.4)
t2.value14(color39, UDim2.new(0, 3, 1, -12), UDim2.new(0, 0, 0, 6), t2.value8.gold, 2, 5)
value7 = Instance.new("UIGradient", color39)
value7.Rotation = 120
value7.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 24, 12)), ColorSequenceKeypoint.new(1, t2.value8.bg2) })
value7 = t2.value15
color37 = t2.value7 and 22 or 20
value7 = value7(color39, "Buy Premium Access", t2.value7 and 13 or 14, t2.value8.gold, Enum.Font.GothamBold, Enum.TextXAlignment.Left)
value7.Size = UDim2.new(1, -(t2.value7 and 106 or 98), 0, color37)
value7.Position = UDim2.new(0, t2.value7 and 14 or 12, 0, t2.value7 and 9 or 8)
value7.ZIndex = 5
value7 = t2.value15
color37 = "Keyless  |  Priority updates  |  Premium features"

local value72 = t2.value7

value72 = 10
value7 = value7(color39, color37, value72, Color3.fromRGB(188, 168, 105), Enum.Font.Gotham, Enum.TextXAlignment.Left)
color37 = UDim2.new
value72 = t2.value7
value72 = value72 and 106 or value72
t1.value10 = 18
color34 = 16
color33 = t2.value7

if color33 then
	color33 = t1.value10
end

value7.Size = color37(1, -(value72 or 98), 0, color33 or color34)
color37 = UDim2.new
value72 = t2.value7
value7.Position = color37(0, t2.value7 and 14 or 12, 0, value72 and 34 or value72 or 30)
value7.ZIndex = 5
value7 = t2.value7 and 84 or 78
color37 = t2.value7 and 34 or 30
color39 = color315(color39, UDim2.new(0, value7, 0, color37), UDim2.new(1, -(value7 + 8), 0.5, -color37 / 2), t2.value8.gold, 6, 5)
value7 = Instance.new("UIGradient", color39)
value7.Rotation = 90
value7.Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(248, 198, 65)), ColorSequenceKeypoint.new(1, t2.value8.goldDk) })
t2.value29 = t2.value15(color39, "Buy", t2.value7 and 12 or 13, t2.value8.black, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
t2.value29.ZIndex = 6
color311(color39, t2.value8.gold, Color3.fromRGB(255, 215, 80))
color39.MouseButton1Click:Connect(function()
	local s1 = "https://nibum-store.mysellauth.com/product/key-premium"

	if setclipboard then
		setclipboard(s1)

		local gold = t2.value8.gold

		t2.value24.Text = "Link copied! Paste it into your browser."
		t2.value24.TextColor3 = gold or t2.value8.txt2

		local s2 = "Link copied! Paste it into your browser."

		task.delay(5, function()
			if t2.value24.Text ~= s2 then
				return
			end

			t2.value24.Text = ""
		end)
		t2.value29.Text = "Copied!"
		task.delay(2.2, function()
			t2.value29.Text = "Buy"
		end)
	else
		local gold = t2.value8.gold

		t2.value24.Text = "Visit: https://nibum-store.mysellauth.com/product/key-premium"
		t2.value24.TextColor3 = gold or t2.value8.txt2

		local s3 = "Visit: https://nibum-store.mysellauth.com/product/key-premium"

		task.delay(6, function()
			if t2.value24.Text ~= s3 then
				return
			end

			t2.value24.Text = ""
		end)
	end
end)
color39 = 26
t1.value10 = 30
color314 = color314 + color310 + (t2.value7 and 12 or 10)

if t2.value7 then
	color39 = t1.value10 or color39
end

color310 = t2.value7 and 106 or 96
t1.value10 = "UDim2"
color315 = color315(color316, UDim2.new(0, color310, 0, color39), UDim2.new(0, 0, 0, color314), t2.value8.bg3, 6, 4)
color313(color315, t2.value8.brd2, 1, 0.35)
value7 = Instance.new("UIGradient", color315)
value7.Rotation = 90
t1.value10 = ColorSequence.new
color37 = ColorSequenceKeypoint.new(0, Color3.fromRGB(26, 29, 40))
value72 = ColorSequenceKeypoint.new
color34 = t2.value8.bg3
value7.Color = t1.value10({ color37, value72(1, color34) })
t1.value10 = t2.value15(color315, "Discord", t2.value7 and 12 or 12, t2.value8.dcBlue, Enum.Font.GothamSemibold, Enum.TextXAlignment.Center)
t2.value30 = t1.value10
t2.value30.ZIndex = 5
color311(color315, t2.value8.bg3, t2.value8.bg4)
t1.value10 = color315.MouseEnter
t1.value10:Connect(function()
	t2.value30.TextColor3 = Color3.fromRGB(155, 175, 255)
end)
t1.value10 = color315.MouseLeave
t1.value10:Connect(function()
	t2.value30.TextColor3 = t2.value8.dcBlue
end)
t1.value10 = color315.MouseButton1Click
t1.value10:Connect(function()
	if setclipboard then
		setclipboard("https://discord.gg/aah4rn3ff2")

		local txt = t2.value8.txt

		t2.value24.Text = "Discord link copied! Paste it into your browser."
		t2.value24.TextColor3 = txt or t2.value8.txt2

		local s4 = "Discord link copied! Paste it into your browser."

		task.delay(4, function()
			if t2.value24.Text ~= s4 then
				return
			end

			t2.value24.Text = ""
		end)
		t2.value30.Text = "Copied!"

		local function v64()
			t2.value30.Text = "Discord"
		end

		task.delay(2, v64)
	else
		local txt = t2.value8.txt

		t2.value24.Text = "Join: https://discord.gg/aah4rn3ff2"
		t2.value24.TextColor3 = txt or t2.value8.txt2

		local s5 = "Join: https://discord.gg/aah4rn3ff2"

		task.delay(5, function()
			if t2.value24.Text ~= s5 then
				return
			end

			t2.value24.Text = ""
		end)
	end
end)
t1.value10 = t2.value15
color315 = t1.value1
color315 = t2.value7
t1.value11 = color315 and 10 or color315
color316 = t1.value10(color316, "nibum HUB", t1.value11 or 10, t2.value8.txt3, Enum.Font.Gotham, Enum.TextXAlignment.Right)
color316.Size = UDim2.new(1, -(color310 + 10), 0, color39)
color316.Position = UDim2.new(0, color310 + 8, 0, color314)
color316.ZIndex = 4
task.spawn(function()
	while true do
		local value17 = t2.value17

		if value17 then
			value17 = t2.value17.Parent
		end

		if not value17 then
			return
		end

		local v68 = t2.value14(t2.value17, UDim2.new(0, math.random(2, 4), 0, math.random(2, 4)), UDim2.new(math.random(), 0, 1, 0), t2.value8.acc, 2, 6)

		v68.BackgroundTransparency = 0.65

		local value5 = t2.value5
		local tweenInfo = TweenInfo.new(math.random(9, 15), Enum.EasingStyle.Linear)
		local uDim2New = UDim2.new
		local X = v68.Position.X

		value5.Create(value5, v68, tweenInfo, {
			Position = uDim2New(X.Scale, 0, -0.08, 0),
			BackgroundTransparency = 1
		}):Play()
		task.delay(16, function()
			local Parent = v68

			if Parent then
				Parent = v68.Parent
			end

			if not Parent then
				return
			end

			v68:Destroy()
		end)
		task.wait(math.random(2, 4))
	end
end)
t2.value31 = t2.value14(t2.value17, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), t2.value8.bg1, 12, 20)
t2.value31.Visible = false
color316 = t2.value14(t2.value31, UDim2.new(0, 64, 0, 64), UDim2.new(0.5, -32, 0.5, -52), t2.value8.bg1, 0, 21)
color316.BackgroundTransparency = 1
color315 = t2.value14
t1.value11 = UDim2.new
color314 = t1.value11(1, 0, 1, 0)
t1.value11 = UDim2.new
color315 = color315(color316, color314, t1.value11(0, 0, 0, 0), t2.value8.bg1, 0, 21)
color315.BackgroundTransparency = 1
t1.value11 = t2.value8.brd2
color313(color315, t1.value11, 4, 0.6)
t1.value11 = Instance.new("UICorner", color315)
color315 = UDim.new
t1.value11.CornerRadius = color315(1, 0)
t1.value11 = t2.value14(color316, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), t2.value8.bg1, 0, 22)
t1.value11.BackgroundTransparency = 1
color315 = color313(t1.value11, t2.value8.acc, 4, 0)
Instance.new("UICorner", t1.value11).CornerRadius = UDim.new(1, 0)
Instance.new("UIGradient", color315).Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0),
	NumberSequenceKeypoint.new(0.45, 0.1),
	NumberSequenceKeypoint.new(0.75, 0.6),
	NumberSequenceKeypoint.new(1, 1)
})
t2.value5:Create(color316, TweenInfo.new(1, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1), {
	Rotation = 360
}):Play()
color316 = t2.value15
color315 = t2.value31
color314 = t1.value1
t2.value32 = color316(color315, "Checking key", t2.value7 and 14 or 15, t2.value8.txt, Enum.Font.GothamBold, Enum.TextXAlignment.Center)
t2.value32.Size = UDim2.new(1, 0, 0, 22)
t2.value32.Position = UDim2.new(0, 0, 0.5, 22)
t2.value32.ZIndex = 22
color316 = t2.value15(t2.value31, "Please wait a moment", t2.value7 and 10 or 11, t2.value8.txt2, Enum.Font.Gotham, Enum.TextXAlignment.Center)
color316.Size = UDim2.new(1, 0, 0, 16)
color316.Position = UDim2.new(0, 0, 0.5, 48)
color316.ZIndex = 22
task.spawn(function()
	local n1 = 0

	while true do
		local value31 = t2.value31

		if value31 then
			value31 = t2.value31.Parent
		end

		if not value31 then
			return
		end

		if t2.value31.Visible then
			n1 = n1 % 3 + 1
			t2.value32.Text = "Checking key" .. string.rep(".", n1)
		end

		task.wait(0.5)
	end
end)

function t2.value33(p41, p42)
	if not p42 then
		t2.value31.Visible = p41

		return
	end

	t2.value32.Text = p42
	t2.value31.Visible = p41
end
function t2.value34(p43)
	local v76 = t2.value14(t2.value17, UDim2.new(1, 0, 1, 0), UDim2.new(0, 0, 0, 0), t2.value8.bg1, 12, 30)

	v76.BackgroundTransparency = 1

	local value5 = t2.value5
	local TweenInfo_ = TweenInfo

	value5.Create(value5, v76, TweenInfo_.new(0.22), {
		BackgroundTransparency = 0.05
	}):Play()

	local n2 = 82
	local v80 = t2.value14(v76, UDim2.new(0, n2, 0, n2), UDim2.new(0.5, -n2 / 2, 0.5, -70), t2.value8.grn, n2 / 2, 31)

	v80.BackgroundTransparency = 0.15
	v26(v80, 0.4, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {
		Size = UDim2.new(0, 90, 0, 90),
		Position = UDim2.new(0.5, -45, 0.5, -74)
	})

	local v81 = t2.value15(v80, "v", 44, t2.value8.white, Enum.Font.GothamBold, Enum.TextXAlignment.Center)

	v81.TextSize = 0
	v81.ZIndex = 32

	local Back = Enum.EasingStyle.Back
	local Out = Enum.EasingDirection.Out

	t2.value5:Create(v81, TweenInfo.new(0.3, Back, Out), {
		TextSize = 48
	}):Play()
	t2.value13(v80, 0.9, Enum.EasingStyle.Sine, {
		Size = UDim2.new(0, 92, 0, 92)
	})

	local v84 = t2.value15(v76, p43 or "Key Verified!", t2.value7 and 17 or 19, t2.value8.grn, Enum.Font.GothamBold, Enum.TextXAlignment.Center)

	v84.Size = UDim2.new(1, 0, 0, 26)
	v84.Position = UDim2.new(0, 0, 0.5, 30)
	v84.ZIndex = 31

	local v85 = t2.value15(v76, "Starting nibum HUB...", t2.value7 and 11 or 12, t2.value8.txt2, Enum.Font.Gotham, Enum.TextXAlignment.Center)

	v85.Size = UDim2.new(1, 0, 0, 16)
	v85.Position = UDim2.new(0, 0, 0.5, 60)
	v85.ZIndex = 31
	task.wait(1.3)
end

t2.value17.BackgroundTransparency = 1
t2.value17.Position = UDim2.new(0.5, 0, 0.5, 36)
v26(t2.value17, 0.32, Enum.EasingStyle.Back, Enum.EasingDirection.Out, {
	BackgroundTransparency = 0,
	Position = UDim2.new(0.5, 0, 0.5, 0)
})
color316 = t2.value16
color315 = t2.value5
color314 = TweenInfo
color315.Create(color315, color316, color314.new(0.22), {
	BackgroundTransparency = 0.35
}):Play()

function t2.value35()
	getgenv().UI_CLOSED = true

	local nibum_HUB_KeyBlur = t2.value6:FindFirstChild("nibum_HUB_KeyBlur")
	local value17 = t2.value17
	local t7 = {
		BackgroundTransparency = 1,
		Position = UDim2.new(0.5, 0, 0.5, 28)
	}
	local value5 = t2.value5
	local TweenInfo_ = TweenInfo

	value5.Create(value5, value17, TweenInfo_.new(0.18), t7):Play()

	local value16 = t2.value16
	local value52 = t2.value5
	local TweenInfo_2 = TweenInfo

	value52.Create(value52, value16, TweenInfo_2.new(0.18), {
		BackgroundTransparency = 1
	}):Play()
	task.wait(0.2)

	if nibum_HUB_KeyBlur then
		nibum_HUB_KeyBlur:Destroy()
	end

	local value12 = t2.value12

	if value12 then
		value12 = t2.value12.Parent
	end

	if not value12 then
		return
	end

	t2.value12:Destroy()
end

color312.MouseButton1Click:Connect(t2.value35)
color36.MouseButton1Click:Connect(function()
	local s6 = "https://jnkie.com/overview/nibum"

	if setclipboard then
		setclipboard(s6)

		local grn = t2.value8.grn

		t2.value24.Text = "Link copied! Paste it into your browser."
		t2.value24.TextColor3 = grn or t2.value8.txt2

		local s7 = "Link copied! Paste it into your browser."

		task.delay(5, function()
			if t2.value24.Text ~= s7 then
				return
			end

			t2.value24.Text = ""
		end)
		t2.value26.Text = "Copied!"
		task.delay(2.5, function()
			t2.value26.Text = "Get Key"
		end)
	else
		local txt = t2.value8.txt

		t2.value24.Text = "Get your key at: https://jnkie.com/overview/nibum"
		t2.value24.TextColor3 = txt or t2.value8.txt2

		local s8 = "Get your key at: https://jnkie.com/overview/nibum"

		task.delay(6, function()
			if t2.value24.Text ~= s8 then
				return
			end

			t2.value24.Text = ""
		end)
	end
end)
t2.value36 = false

function t2.value37(p44)
	if t2.value36 then
		return
	end

	local scriptKey = p44:gsub("%s+", "")

	if scriptKey == "" then
		local acc = t2.value8.acc

		t2.value24.Text = "Please enter a key first."
		t2.value24.TextColor3 = acc or t2.value8.txt2

		local s9 = "Please enter a key first."

		task.delay(3, function()
			if t2.value24.Text ~= s9 then
				return
			end

			t2.value24.Text = ""
		end)
		task.spawn(t2.value25)

		return
	end

	t2.value28.Text = "Checking..."
	t2.value27.Active = false

	local v103 = t2.value1.check_key(scriptKey)
	local valid

	if v103 then
		valid = v103.valid
	else
		valid = v103
	end

	if not valid then
		local acc = t2.value8.acc

		t2.value24.Text = "Invalid key. Try again or get a new one."
		t2.value24.TextColor3 = acc or t2.value8.txt2

		local s10 = "Invalid key. Try again or get a new one."

		task.delay(5, function()
			if t2.value24.Text ~= s10 then
				return
			end

			t2.value24.Text = ""
		end)
		task.spawn(t2.value25)
		v23(t2.value21, 0.09, {
			BackgroundColor3 = Color3.fromRGB(50, 16, 16)
		})
		task.delay(0.38, function()
			local value21 = t2.value21
			local t8 = {
				BackgroundColor3 = t2.value8.bg2
			}
			local value5 = t2.value5
			local TweenInfo_ = TweenInfo

			value5.Create(value5, value21, TweenInfo_.new(0.18), t8):Play()
		end)
		v23(t2.value22, 0.12, {
			Color = t2.value8.acc,
			Thickness = 1.5,
			Transparency = 0
		})
		task.delay(1.2, function()
			local value22 = t2.value22
			local t9 = {
				Color = t2.value8.brd2,
				Thickness = 1,
				Transparency = 0.25
			}
			local value5 = t2.value5
			local TweenInfo_ = TweenInfo

			value5.Create(value5, value22, TweenInfo_.new(0.18), t9):Play()
		end)
		t2.value28.Text = "Verify Key"
		t2.value27.Active = true

		return
	end

	if not writefile then
		getgenv().SCRIPT_KEY = scriptKey
		print("[nibum HUB] KEY SYSTEM SUCCESS: manual verify")
		t2.value33(false)
		t2.value34(v103.message == "KEYLESS" and "Keyless Mode!" or "Key Verified!")
		t2.value35()
		t2.value4()

		return
	end

	pcall(writefile, t2.value9, scriptKey)
	getgenv().SCRIPT_KEY = scriptKey
	print("[nibum HUB] KEY SYSTEM SUCCESS: manual verify")
	t2.value33(false)
	t2.value34(v103.message == "KEYLESS" and "Keyless Mode!" or "Key Verified!")
	t2.value35()
	t2.value4()
end

t2.value27.MouseButton1Click:Connect(function()
	t2.value37(t2.value23.Text)
end)
t2.value23.FocusLost:Connect(function(enterPressed)
	if not enterPressed then
		return
	end

	t2.value37(t2.value23.Text)
end)
task.spawn(function()
	t2.value33(true, "Checking verification")

	local SCRIPT_KEY = t2.value10() or getgenv().SCRIPT_KEY
	local v116 = t2.value1.check_key(SCRIPT_KEY)
	local valid

	if v116 then
		valid = v116.valid
	else
		valid = v116
	end

	if not valid then
		t2.value33(false)

		return
	end

	if v116.message == "KEYLESS" then
		print("[nibum HUB] KEY SYSTEM SUCCESS: keyless")
		t2.value33(false)
		t2.value34("Keyless Mode!")
		getgenv().SCRIPT_KEY = "KEYLESS"
		t2.value35()
		t2.value4()

		return
	end

	if v116.message == "KEY_VALID" then
		print("[nibum HUB] KEY SYSTEM SUCCESS: saved key")
		t2.value33(false)
		t2.value34(SCRIPT_KEY and "Saved Key Verified!" or SCRIPT_KEY or "Key Verified!")
		getgenv().SCRIPT_KEY = SCRIPT_KEY
		t2.value35()
		t2.value4()

		return
	end

	if not SCRIPT_KEY then
		t2.value33(false)

		return
	end

	t2.value11()
	t2.value33(false)
end)

while true do
	t1.value12 = getgenv()

	if t1.value12.UI_CLOSED then
		break
	end

	task.wait(0.1)
end
