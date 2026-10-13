-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local t1 = { "KEY" }

local function v5(p1, p2, p3)
	local v53 = Instance.new(p1)

	for k, v in pairs(p2) do
		v53[k] = v
	end

	v53.Parent = p3

	return v53
end
local function v6(p4)
	local v57, v58, v59 = ipairs(t1)

	repeat
		local v60

		v59, v60 = v57(v58, v59)

		if not v59 then
			return false
		end
	until v60 == p4

	return true
end
local t2 = {
	Name = "KeySystem",
	ResetOnSpawn = false,
	IgnoreGuiInset = true
}
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui")

for k, v in pairs(t2) do
	ScreenGui[k] = v
end
ScreenGui.Parent = PlayerGui
local v12 = ScreenGui
local uDim2 = UDim2.fromScale(1, 1)
local color3 = Color3.fromRGB(0, 0, 0)

v5("Frame", {
	Size = uDim2,
	BackgroundColor3 = color3,
	BackgroundTransparency = 0.1,
	BorderSizePixel = 0,
	ZIndex = 1
}, v12)

local uDim2_2 = UDim2.fromOffset(340, 220)
local uDim2_3 = UDim2.fromScale(0.5, 0.5)
local vector2 = Vector2.new(0.5, 0.5)
local color3_2 = Color3.fromRGB(90, 60, 160)
local v19 = v5("Frame", {
	Name = "Main",
	Size = uDim2_2,
	Position = uDim2_3,
	AnchorPoint = vector2,
	BackgroundColor3 = color3_2,
	BackgroundTransparency = 0.75,
	BorderSizePixel = 0,
	ZIndex = 2
}, v12)

v5("UICorner", {
	CornerRadius = UDim.new(0, 18)
}, v19)
v5("UIStroke", {
	Color = Color3.fromRGB(190, 130, 255),
	Transparency = 0.4,
	Thickness = 1.5
}, v19)
v5("UIGradient", {
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, Color3.fromRGB(190, 130, 255)),
		ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 30, 110))
	}),
	Rotation = 45
}, v19)

local uDim2_4 = UDim2.new(1, -20, 0, 40)
local uDim2_5 = UDim2.fromOffset(10, 10)
local GothamBold = Enum.Font.GothamBold
local color3_3 = Color3.fromRGB(255, 255, 255)
local Left = Enum.TextXAlignment.Left
v5("TextLabel", {
	BackgroundTransparency = 1,
	Size = uDim2_4,
	Position = uDim2_5,
	Font = GothamBold,
	Text = "Key System",
	TextColor3 = color3_3,
	TextSize = 22,
	TextXAlignment = Left,
	ZIndex = 3
}, v19)

local uDim2_6 = UDim2.new(1, -20, 0, 20)
local uDim2_7 = UDim2.fromOffset(10, 46)
local Gotham = Enum.Font.Gotham
local color3_4 = Color3.fromRGB(220, 200, 245)
local Left2 = Enum.TextXAlignment.Left
v5("TextLabel", {
	BackgroundTransparency = 1,
	Size = uDim2_6,
	Position = uDim2_7,
	Font = Gotham,
	Text = "Get a key and paste it below to continue",
	TextColor3 = color3_4,
	TextSize = 13,
	TextXAlignment = Left2,
	ZIndex = 3
}, v19)

local uDim2_8 = UDim2.new(1, -20, 0, 40)
local uDim2_9 = UDim2.fromOffset(10, 80)
local color3_5 = Color3.fromRGB(30, 15, 55)
local v33 = v5("Frame", {
	Size = uDim2_8,
	Position = uDim2_9,
	BackgroundColor3 = color3_5,
	BackgroundTransparency = 0.65,
	BorderSizePixel = 0,
	ZIndex = 3
}, v19)

v5("UICorner", {
	CornerRadius = UDim.new(0, 10)
}, v33)

local uDim2_10 = UDim2.new(1, -20, 1, 0)
local uDim2_11 = UDim2.fromOffset(10, 0)
local Gotham2 = Enum.Font.Gotham
local color3_6 = Color3.fromRGB(190, 170, 220)
local color3_7 = Color3.fromRGB(230, 210, 255)
local v39 = v5("TextBox", {
	BackgroundTransparency = 1,
	Size = uDim2_10,
	Position = uDim2_11,
	Font = Gotham2,
	PlaceholderText = "Enter key here...",
	PlaceholderColor3 = color3_6,
	Text = "",
	TextColor3 = color3_7,
	TextSize = 14,
	ClearTextOnFocus = false,
	ZIndex = 4
}, v33)

local function v40(p5, p6, p7)
	local v64 = v5
	local uDim2_12 = UDim2.new(0, p7, 0, 44)
	local uDim2_13 = UDim2.fromOffset(p6, 140)
	local color3_8 = Color3.fromRGB(150, 90, 255)
	local GothamBold2 = Enum.Font.GothamBold
	local color3_9 = Color3.fromRGB(240, 225, 255)
	local v70 = v64("TextButton", {
		Size = uDim2_12,
		Position = uDim2_13,
		BackgroundColor3 = color3_8,
		BackgroundTransparency = 0.7,
		AutoButtonColor = false,
		Font = GothamBold2,
		Text = p5,
		TextColor3 = color3_9,
		TextSize = 15,
		ZIndex = 3
	}, v19)

	v5("UICorner", {
		CornerRadius = UDim.new(0, 10)
	}, v70)
	v5("UIStroke", {
		Color = Color3.fromRGB(190, 130, 255),
		Transparency = 0.3
	}, v70)
	v70.MouseEnter:Connect(function()
		TweenService:Create(v70, TweenInfo.new(0.2), {
			BackgroundTransparency = 0.45
		}):Play()
	end)
	v70.MouseLeave:Connect(function()
		TweenService:Create(v70, TweenInfo.new(0.2), {
			BackgroundTransparency = 0.7
		}):Play()
	end)

	return v70
end
local v41 = v40("Copy Key Link", 10, 150)
local v42 = v40("Confirm", 170, 150)
local uDim2_14 = UDim2.new(1, -20, 0, 20)
local uDim2_15 = UDim2.fromOffset(10, 190)
local Gotham3 = Enum.Font.Gotham
local color3_10 = Color3.fromRGB(255, 140, 140)
local Left3 = Enum.TextXAlignment.Left
local v48 = v5("TextLabel", {
	BackgroundTransparency = 1,
	Size = uDim2_14,
	Position = uDim2_15,
	Font = Gotham3,
	Text = "",
	TextColor3 = color3_10,
	TextSize = 13,
	TextXAlignment = Left3,
	ZIndex = 3
}, v19)

local function v49(p8, p9)
	local v73 = v48

	if p9 then
		p9 = Color3.fromRGB(170, 255, 200)
	end

	if not p9 then
		p9 = Color3.fromRGB(255, 140, 140)
	end

	v73.TextColor3 = p9
	v48.Text = p8
end
v41.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard("https://link-target.net/8700456/jA2LNbeAQj75")
		v49("Link copied to clipboard!", true)

		return
	end

	v49("Clipboard not supported by executor.", false)
end)
v42.MouseButton1Click:Connect(function()
	if v6(v39.Text) then
		v49("Key accepted! Loading script...", true)
		task.wait(0.6)
		v12:Destroy()

		return
	end

	v49("Invalid key. Try again.", false)
end)
