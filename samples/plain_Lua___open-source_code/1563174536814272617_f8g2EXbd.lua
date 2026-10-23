
-- Dance GUI Loading Screen + Access Screen
-- Place in a LocalScript inside StarterGui

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local alive = true
local connections = {}

-- Cleanup any existing GUI
local existing = playerGui:FindFirstChild("DanceGUI")
if existing then
	existing:Destroy()
end

local function trackConnection(connection)
	table.insert(connections, connection)
	return connection
end

-- ========== SCREEN GUI ==========

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "DanceGUI"
screenGui.ResetOnSpawn = false
screenGui.IgnoreGuiInset = true
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

-- ========== LOADING SCREEN ==========

local loadingFrame = Instance.new("Frame")
loadingFrame.Name = "LoadingFrame"
loadingFrame.Size = UDim2.new(0, 320, 0, 175)
loadingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
loadingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
loadingFrame.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
loadingFrame.BorderSizePixel = 0
loadingFrame.Parent = screenGui

local loadingCorner = Instance.new("UICorner")
loadingCorner.CornerRadius = UDim.new(0, 12)
loadingCorner.Parent = loadingFrame

local loadingStroke = Instance.new("UIStroke")
loadingStroke.Color = Color3.fromRGB(40, 40, 40)
loadingStroke.Thickness = 3
loadingStroke.Parent = loadingFrame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 12)
title.BackgroundTransparency = 1
title.Text = "MM2 TRADE FREEZE"
title.Font = Enum.Font.GothamBold
title.TextSize = 22
title.TextColor3 = Color3.fromRGB(30, 30, 30)
title.Parent = loadingFrame

-- Loading status
local loadingText = Instance.new("TextLabel")
loadingText.Name = "LoadingText"
loadingText.Size = UDim2.new(1, 0, 0, 22)
loadingText.Position = UDim2.new(0, 0, 0, 55)
loadingText.BackgroundTransparency = 1
loadingText.Text = "Loading..."
loadingText.Font = Enum.Font.Gotham
loadingText.TextSize = 14
loadingText.TextColor3 = Color3.fromRGB(60, 60, 60)
loadingText.Parent = loadingFrame

-- Progress bar background
local barBackground = Instance.new("Frame")
barBackground.Name = "ProgressBarBackground"
barBackground.Size = UDim2.new(1, -40, 0, 18)
barBackground.Position = UDim2.new(0, 20, 0, 88)
barBackground.BackgroundColor3 = Color3.fromRGB(175, 175, 175)
barBackground.BorderSizePixel = 0
barBackground.ClipsDescendants = true
barBackground.Parent = loadingFrame

local barBgCorner = Instance.new("UICorner")
barBgCorner.CornerRadius = UDim.new(0, 8)
barBgCorner.Parent = barBackground

-- Progress bar fill
local progressBar = Instance.new("Frame")
progressBar.Name = "ProgressBar"
progressBar.Size = UDim2.new(0, 0, 1, 0)
progressBar.BackgroundColor3 = Color3.fromRGB(100, 175, 235)
progressBar.BorderSizePixel = 0
progressBar.Parent = barBackground

local barCorner = Instance.new("UICorner")
barCorner.CornerRadius = UDim.new(0, 8)
barCorner.Parent = progressBar

-- Percentage text
local percentage = Instance.new("TextLabel")
percentage.Name = "Percentage"
percentage.Size = UDim2.new(1, 0, 0, 24)
percentage.Position = UDim2.new(0, 0, 0, 112)
percentage.BackgroundTransparency = 1
percentage.Text = "0%"
percentage.Font = Enum.Font.GothamBold
percentage.TextSize = 15
percentage.TextColor3 = Color3.fromRGB(35, 35, 35)
percentage.Parent = loadingFrame

local credit = Instance.new("TextLabel")
credit.Name = "Credit"
credit.Size = UDim2.new(0, 150, 0, 18)
credit.Position = UDim2.new(0, 12, 1, -22)
credit.BackgroundTransparency = 1
credit.Text = "made by FORZAHD"
credit.Font = Enum.Font.Gotham
credit.TextSize = 12
credit.TextColor3 = Color3.fromRGB(80, 80, 80)
credit.TextXAlignment = Enum.TextXAlignment.Left
credit.Parent = loadingFrame

-- IMPORTANT:
-- No Freeze Trade or Force Accept buttons are created
-- anywhere on the loading screen.

-- ========== ACCESS SCREEN ==========

local accessFrame = Instance.new("Frame")
accessFrame.Name = "AccessFrame"
accessFrame.Size = UDim2.new(0, 340, 0, 260)
accessFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
accessFrame.AnchorPoint = Vector2.new(0.5, 0.5)
accessFrame.BackgroundColor3 = Color3.fromRGB(220, 220, 220)
accessFrame.BorderSizePixel = 0
accessFrame.Visible = false
accessFrame.Parent = screenGui

local accessCorner = Instance.new("UICorner")
accessCorner.CornerRadius = UDim.new(0, 12)
accessCorner.Parent = accessFrame

local accessStroke = Instance.new("UIStroke")
accessStroke.Color = Color3.fromRGB(40, 40, 40)
accessStroke.Thickness = 3
accessStroke.Parent = accessFrame

-- Title / drag area
local titleBar = Instance.new("Frame")
titleBar.Name = "TitleBar"
titleBar.Size = UDim2.new(1, -12, 0, 48)
titleBar.Position = UDim2.new(0, 6, 0, 4)
titleBar.BackgroundTransparency = 1
titleBar.Active = true
titleBar.Parent = accessFrame

local accessTitle = Instance.new("TextLabel")
accessTitle.Name = "AccessTitle"
accessTitle.Size = UDim2.new(1, -40, 1, 0)
accessTitle.Position = UDim2.new(0, 4, 0, 0)
accessTitle.BackgroundTransparency = 1
accessTitle.Text = "Join group to gain access!"
accessTitle.Font = Enum.Font.GothamBold
accessTitle.TextSize = 18
accessTitle.TextColor3 = Color3.fromRGB(30, 30, 30)
accessTitle.Parent = titleBar

-- Close button
local closeBtn = Instance.new("TextButton")
closeBtn.Name = "CloseButton"
closeBtn.Size = UDim2.new(0, 28, 0, 28)
closeBtn.Position = UDim2.new(1, -30, 0, 4)
closeBtn.BackgroundColor3 = Color3.fromRGB(190, 65, 65)
closeBtn.BorderSizePixel = 0
closeBtn.Text = "X"
closeBtn.Font = Enum.Font.GothamBold
closeBtn.TextSize = 16
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.AutoButtonColor = true
closeBtn.Parent = titleBar

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 7)
closeCorner.Parent = closeBtn

-- Instructions
local instructions = Instance.new("TextLabel")
instructions.Name = "Instructions"
instructions.Size = UDim2.new(1, -30, 0, 90)
instructions.Position = UDim2.new(0, 15, 0, 55)
instructions.BackgroundTransparency = 1
instructions.Text = "1. Copy The Group\n2. Leave Game and Join Group\n3. Reload the script and claim access!"
instructions.Font = Enum.Font.Gotham
instructions.TextSize = 15
instructions.TextColor3 = Color3.fromRGB(40, 40, 40)
instructions.TextXAlignment = Enum.TextXAlignment.Left
instructions.TextYAlignment = Enum.TextYAlignment.Top
instructions.Parent = accessFrame

-- Access Group button
local accessBtn = Instance.new("TextButton")
accessBtn.Name = "AccessGroupBtn"
accessBtn.Size = UDim2.new(0, 160, 0, 40)
accessBtn.Position = UDim2.new(0.5, 0, 0, 160)
accessBtn.AnchorPoint = Vector2.new(0.5, 0)
accessBtn.BackgroundColor3 = Color3.fromRGB(140, 140, 140)
accessBtn.BorderSizePixel = 0
accessBtn.Text = "Access Group"
accessBtn.Font = Enum.Font.GothamBold
accessBtn.TextSize = 16
accessBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
accessBtn.AutoButtonColor = true
accessBtn.Parent = accessFrame

local accessBtnCorner = Instance.new("UICorner")
accessBtnCorner.CornerRadius = UDim.new(0, 10)
accessBtnCorner.Parent = accessBtn

-- Notification
local notify = Instance.new("TextLabel")
notify.Name = "Notify"
notify.Size = UDim2.new(0, 240, 0, 24)
notify.Position = UDim2.new(0.5, 0, 0, 210)
notify.AnchorPoint = Vector2.new(0.5, 0)
notify.BackgroundTransparency = 1
notify.Text = "Group link copied to clipboard!"
notify.Font = Enum.Font.Gotham
notify.TextSize = 13
notify.TextColor3 = Color3.fromRGB(0, 140, 60)
notify.Visible = false
notify.Parent = accessFrame

local credit2 = Instance.new("TextLabel")
credit2.Name = "Credit"
credit2.Size = UDim2.new(0, 150, 0, 20)
credit2.Position = UDim2.new(0, 12, 1, -24)
credit2.BackgroundTransparency = 1
credit2.Text = "made by FORZAHD"
credit2.Font = Enum.Font.Gotham
credit2.TextSize = 12
credit2.TextColor3 = Color3.fromRGB(80, 80, 80)
credit2.TextXAlignment = Enum.TextXAlignment.Left
credit2.Parent = accessFrame

-- ========== DRAGGING ==========

local dragging = false
local dragStart
local startPosition
local dragInput

trackConnection(titleBar.InputBegan:Connect(function(input)
	if not alive then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch then

		dragging = true
		dragStart = input.Position
		startPosition = accessFrame.Position
		dragInput = input

		trackConnection(input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end))
	end
end))

trackConnection(UserInputService.InputChanged:Connect(function(input)
	if not alive or not dragging then
		return
	end

	if input.UserInputType == Enum.UserInputType.MouseMovement
		or input.UserInputType == Enum.UserInputType.Touch then

		local delta = input.Position - dragStart

		accessFrame.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end
end))

-- ========== CLOSE / TERMINATE GUI ==========

trackConnection(closeBtn.MouseButton1Click:Connect(function()
	if not alive then
		return
	end

	alive = false

	for _, connection in ipairs(connections) do
		connection:Disconnect()
	end

	table.clear(connections)
	screenGui:Destroy()
end))

-- ========== LOADING LOGIC ==========

-- Animated loading dots
task.spawn(function()
	local dots = {".", "..", "...", ""}
	local index = 1

	while alive and loadingFrame.Parent and loadingFrame.Visible do
		loadingText.Text = "Loading" .. dots[index]
		index = index % #dots + 1
		task.wait(0.35)
	end
end)

-- Progress from 0% to 100%
task.spawn(function()
	local duration = 3.2
	local steps = 100
	local stepDuration = duration / steps

	for i = 0, steps do
		if not alive or not screenGui.Parent then
			return
		end

		percentage.Text = tostring(i) .. "%"
		progressBar.Size = UDim2.new(i / 100, 0, 1, 0)

		if i < steps then
			task.wait(stepDuration)
		end
	end

	if not alive or not screenGui.Parent then
		return
	end

	loadingText.Text = "Loaded!"
	task.wait(0.2)

	if not alive or not screenGui.Parent then
		return
	end

	-- Fade out loading screen
	local fadeInfo = TweenInfo.new(0.4)

	local fadeOut = TweenService:Create(
		loadingFrame,
		fadeInfo,
		{BackgroundTransparency = 1}
	)

	for _, child in ipairs(loadingFrame:GetDescendants()) do
		if child:IsA("TextLabel") then
			TweenService:Create(child, fadeInfo, {
				TextTransparency = 1
			}):Play()

		elseif child:IsA("Frame") then
			TweenService:Create(child, fadeInfo, {
				BackgroundTransparency = 1
			}):Play()

		elseif child:IsA("UIStroke") then
			TweenService:Create(child, fadeInfo, {
				Transparency = 1
			}):Play()
		end
	end

	fadeOut:Play()
	fadeOut.Completed:Wait()

	if not alive or not screenGui.Parent then
		return
	end

	loadingFrame.Visible = false

	-- Prepare access screen for fade-in
	accessFrame.Visible = true
	accessFrame.BackgroundTransparency = 1
	accessStroke.Transparency = 1

	for _, child in ipairs(accessFrame:GetDescendants()) do
		if child:IsA("TextLabel") then
			child.TextTransparency = 1

		elseif child:IsA("TextButton") then
			child.TextTransparency = 1
			child.BackgroundTransparency = 1

		elseif child:IsA("UIStroke") then
			child.Transparency = 1
		end
	end

	-- Fade in access screen
	TweenService:Create(accessFrame, fadeInfo, {
		BackgroundTransparency = 0
	}):Play()

	for _, child in ipairs(accessFrame:GetDescendants()) do
		if child:IsA("TextLabel") then
			TweenService:Create(child, fadeInfo, {
				TextTransparency = 0
			}):Play()

		elseif child:IsA("TextButton") then
			TweenService:Create(child, fadeInfo, {
				TextTransparency = 0,
				BackgroundTransparency = 0
			}):Play()

		elseif child:IsA("UIStroke") then
			TweenService:Create(child, fadeInfo, {
				Transparency = 0
			}):Play()
		end
	end
end)

-- ========== ACCESS BUTTON ==========

trackConnection(accessBtn.MouseButton1Click:Connect(function()
	if not alive then
		return
	end

	local link = "https://shorturl.sh/CCgjb"

	-- Clipboard functions are supported only in environments
	-- that provide them; standard Roblox LocalScripts do not.
	local copied = false

	if typeof(setclipboard) == "function" then
		local success = pcall(setclipboard, link)
		copied = success
	elseif typeof(toclipboard) == "function" then
		local success = pcall(toclipboard, link)
		copied = success
	elseif typeof(Clipboard) == "table"
		and typeof(Clipboard.SetText) == "function" then

		local success = pcall(function()
			Clipboard:SetText(link)
		end)
		copied = success
	end

	if not copied then
		-- Fallback for environments without clipboard access
		print("Group link:", link)
		notify.Text = "Group link printed to output!"
	else
		notify.Text = "Group link copied to clipboard!"
	end

	notify.Visible = true
	notify.TextTransparency = 0

	task.delay(2.5, function()
		if not alive or not notify.Parent then
			return
		end

		local fade = TweenService:Create(
			notify,
			TweenInfo.new(0.4),
			{TextTransparency = 1}
		)

		fade:Play()
		fade.Completed:Wait()

		if alive and notify.Parent then
			notify.Visible = false
		end
	end)
end))