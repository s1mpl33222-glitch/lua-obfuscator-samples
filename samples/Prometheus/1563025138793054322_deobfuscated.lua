-- This file was generated at discord.gg/syncrypt

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local t1 = { "KEY" }
local PlayerGui = Players.LocalPlayer:WaitForChild("PlayerGui")
local ScreenGui = Instance.new("ScreenGui")

local function v6(p1, p2, p3)
	local instance = Instance.new(p1)

	for k, v in pairs(p2) do
		instance[k] = v
	end

	instance.Parent = p3

	return instance
end
local function v10(p4)
	local v11, v12, v13 = ipairs(t1)

	while true do
		local v14

		v13, v14 = v11(v12, v13)

		if not v13 then
			break
		end

		if v14 == p4 then
			return true
		end
	end

	return false
end

for k, v in pairs({
	Name = "KeySystem",
	ResetOnSpawn = false,
	IgnoreGuiInset = true
}) do
	ScreenGui[k] = v
end

ScreenGui.Parent = PlayerGui
v6("Frame", {
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = Color3.fromRGB(0, 0, 0),
	BackgroundTransparency = 0.1,
	BorderSizePixel = 0,
	ZIndex = 1
}, ScreenGui)

local Frame = v6("Frame", {
	Name = "Main",
	Size = UDim2.fromOffset(340, 220),
	Position = UDim2.fromScale(0.5, 0.5),
	AnchorPoint = Vector2.new(0.5, 0.5),
	BackgroundColor3 = Color3.fromRGB(90, 60, 160),
	BackgroundTransparency = 0.75,
	BorderSizePixel = 0,
	ZIndex = 2
}, ScreenGui)

v6("UICorner", {
	CornerRadius = UDim.new(0, 18)
}, Frame)
v6("UIStroke", {
	Color = Color3.fromRGB(190, 130, 255),
	Transparency = 0.4,
	Thickness = 1.5
}, Frame)
v6("UIGradient", {
	Color = ColorSequence.new({ ColorSequenceKeypoint.new(0, Color3.fromRGB(190, 130, 255)), ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 30, 110)) }),
	Rotation = 45
}, Frame)
v6("TextLabel", {
	BackgroundTransparency = 1,
	Size = UDim2.new(1, -20, 0, 40),
	Position = UDim2.fromOffset(10, 10),
	Font = Enum.Font.GothamBold,
	Text = "Key System",
	TextColor3 = Color3.fromRGB(255, 255, 255),
	TextSize = 22,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 3
}, Frame)
v6("TextLabel", {
	BackgroundTransparency = 1,
	Size = UDim2.new(1, -20, 0, 20),
	Position = UDim2.fromOffset(10, 46),
	Font = Enum.Font.Gotham,
	Text = "Get a key and paste it below to continue",
	TextColor3 = Color3.fromRGB(220, 200, 245),
	TextSize = 13,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 3
}, Frame)

local Frame2 = v6("Frame", {
	Size = UDim2.new(1, -20, 0, 40),
	Position = UDim2.fromOffset(10, 80),
	BackgroundColor3 = Color3.fromRGB(30, 15, 55),
	BackgroundTransparency = 0.65,
	BorderSizePixel = 0,
	ZIndex = 3
}, Frame)

v6("UICorner", {
	CornerRadius = UDim.new(0, 10)
}, Frame2)

local TextBox = v6("TextBox", {
	BackgroundTransparency = 1,
	Size = UDim2.new(1, -20, 1, 0),
	Position = UDim2.fromOffset(10, 0),
	Font = Enum.Font.Gotham,
	PlaceholderText = "Enter key here...",
	PlaceholderColor3 = Color3.fromRGB(190, 170, 220),
	Text = "",
	TextColor3 = Color3.fromRGB(230, 210, 255),
	TextSize = 14,
	ClearTextOnFocus = false,
	ZIndex = 4
}, Frame2)

local function v20(p5, p6, p7)
	local TextButton = v6("TextButton", {
		Size = UDim2.new(0, p7, 0, 44),
		Position = UDim2.fromOffset(p6, 140),
		BackgroundColor3 = Color3.fromRGB(150, 90, 255),
		BackgroundTransparency = 0.7,
		AutoButtonColor = false,
		Font = Enum.Font.GothamBold,
		Text = p5,
		TextColor3 = Color3.fromRGB(240, 225, 255),
		TextSize = 15,
		ZIndex = 3
	}, Frame)

	v6("UICorner", {
		CornerRadius = UDim.new(0, 10)
	}, TextButton)
	v6("UIStroke", {
		Color = Color3.fromRGB(190, 130, 255),
		Transparency = 0.3
	}, TextButton)
	TextButton.MouseEnter:Connect(function()
		TweenService:Create(TextButton, TweenInfo.new(0.2), {
			BackgroundTransparency = 0.45
		}):Play()
	end)
	TextButton.MouseLeave:Connect(function()
		TweenService:Create(TextButton, TweenInfo.new(0.2), {
			BackgroundTransparency = 0.7
		}):Play()
	end)

	return TextButton
end

local copyKeyLink = v20("Copy Key Link", 10, 150)
local Confirm = v20("Confirm", 170, 150)
local TextLabel = v6("TextLabel", {
	BackgroundTransparency = 1,
	Size = UDim2.new(1, -20, 0, 20),
	Position = UDim2.fromOffset(10, 190),
	Font = Enum.Font.Gotham,
	Text = "",
	TextColor3 = Color3.fromRGB(255, 140, 140),
	TextSize = 13,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 3
}, Frame)

local function v25(p8, p9)
	local v26 = TextLabel

	if not p9 then
		v26.TextColor3 = p9 or Color3.fromRGB(255, 140, 140)
		TextLabel.Text = p8

		return
	end

	p9 = Color3.fromRGB(170, 255, 200)
	v26.TextColor3 = p9 or Color3.fromRGB(255, 140, 140)
	TextLabel.Text = p8
end

copyKeyLink.MouseButton1Click:Connect(function()
	if setclipboard then
		setclipboard("https://link-target.net/8700456/jA2LNbeAQj75")
		v25("Link copied to clipboard!", true)
	else
		v25("Clipboard not supported by executor.", false)
	end
end)
Confirm.MouseButton1Click:Connect(function()
	if v10(TextBox.Text) then
		v25("Key accepted! Loading script...", true)
		task.wait(0.6)
		ScreenGui:Destroy()
	else
		v25("Invalid key. Try again.", false)
	end
end)
