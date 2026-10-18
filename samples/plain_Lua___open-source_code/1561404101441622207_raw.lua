-- LeaveConfirmGui.lua  (Moon Theme - Fixed)
-- LocalScript: Place inside StarterPlayerScripts

local Players          = game:GetService("Players")
local GuiService       = game:GetService("GuiService")
local StarterGui       = game:GetService("StarterGui")
local UserInputService = game:GetService("UserInputService")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")
local TeleportService  = game:GetService("TeleportService")
local CoreGui          = game:GetService("CoreGui")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

------------------------------------------------------------
-- MOON THEME
------------------------------------------------------------
local Theme = {
	Void      = Color3.fromRGB(8, 9, 13),
	Panel     = Color3.fromRGB(14, 15, 21),
	PanelSoft = Color3.fromRGB(20, 22, 30),
	Moonlight = Color3.fromRGB(223, 229, 240),
	Moonbeam  = Color3.fromRGB(168, 183, 214),
	Silver    = Color3.fromRGB(120, 132, 158),
	Glow      = Color3.fromRGB(199, 210, 235),
	DeepGlow  = Color3.fromRGB(58, 66, 92),
	ToggleOff = Color3.fromRGB(40, 43, 54),
}

local FontTitle = Enum.Font.Michroma
local FontBody  = Enum.Font.Nunito

local COUNTDOWN = 5

------------------------------------------------------------
-- HELPERS
------------------------------------------------------------
local sweepGradients = {}

local function makeRounded(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 12)
	c.Parent = parent
	return c
end

local function applyMoonGlow(parent, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Thickness = thickness or 1.5
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Color = Theme.Glow
	stroke.Transparency = 0.05

	local grad = Instance.new("UIGradient")
	grad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, Theme.DeepGlow),
		ColorSequenceKeypoint.new(0.5, Theme.Moonlight),
		ColorSequenceKeypoint.new(1, Theme.DeepGlow),
	}
	grad.Parent = stroke
	stroke.Parent = parent
	table.insert(sweepGradients, grad)
	return stroke
end

local function addTextGlow(label, color)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color or Theme.Glow
	stroke.Thickness = 1.2
	stroke.Transparency = 0.35
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Contextual
	stroke.Parent = label
	return stroke
end

-- Left-to-right fade in
local function fadeInLeftToRight(obj, duration, delayTime)
	duration = duration or 0.55
	delayTime = delayTime or 0

	local grad = Instance.new("UIGradient")
	grad.Transparency = NumberSequence.new{
		NumberSequenceKeypoint.new(0, 0),
		NumberSequenceKeypoint.new(0.01, 0),
		NumberSequenceKeypoint.new(0.02, 1),
		NumberSequenceKeypoint.new(1, 1),
	}
	grad.Parent = obj

	obj.TextTransparency = 0
	task.delay(delayTime, function()
		local start = tick()
		local conn
		conn = RunService.RenderStepped:Connect(function()
			local alpha = math.clamp((tick() - start) / duration, 0, 1)
			local ease = 1 - (1 - alpha) ^ 3
			local pos = ease

			grad.Transparency = NumberSequence.new{
				NumberSequenceKeypoint.new(0, 0),
				NumberSequenceKeypoint.new(math.max(0.001, pos - 0.05), 0),
				NumberSequenceKeypoint.new(math.min(0.999, pos), 1),
				NumberSequenceKeypoint.new(1, 1),
			}

			if alpha >= 1 then
				conn:Disconnect()
				grad:Destroy()
			end
		end)
	end)
end

------------------------------------------------------------
-- SCREEN GUI
------------------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name           = "LeaveConfirmGui"
screenGui.ResetOnSpawn   = false
screenGui.IgnoreGuiInset = true
screenGui.DisplayOrder   = 99999
screenGui.Enabled        = false
pcall(function() screenGui.Parent = CoreGui end)
if not screenGui.Parent then screenGui.Parent = playerGui end

-- Full-screen opaque cover
local panel = Instance.new("Frame")
panel.Size                   = UDim2.fromScale(1, 1)
panel.BackgroundColor3       = Theme.Void
panel.BackgroundTransparency = 0          -- fully opaque
panel.BorderSizePixel        = 0
panel.ZIndex                 = 1
panel.Parent                 = screenGui

-- Centred content
local content = Instance.new("Frame")
content.Size                   = UDim2.new(0.70, 0, 0, 430)
content.Position               = UDim2.fromScale(0.5, 0.5)
content.AnchorPoint            = Vector2.new(0.5, 0.5)
content.BackgroundTransparency = 1
content.BorderSizePixel        = 0
content.ZIndex                 = 2
content.Parent                 = panel

------------------------------------------------------------
-- ICON
------------------------------------------------------------
local iconLabel = Instance.new("TextLabel")
iconLabel.Size                   = UDim2.new(1, 0, 0, 60)
iconLabel.Position               = UDim2.fromOffset(0, 18)
iconLabel.BackgroundTransparency = 1
iconLabel.Text                   = "🌙"
iconLabel.TextColor3             = Theme.Moonbeam
iconLabel.TextSize               = 42
iconLabel.Font                   = FontTitle
iconLabel.TextXAlignment         = Enum.TextXAlignment.Center
iconLabel.TextTransparency       = 1
iconLabel.ZIndex                 = 3
iconLabel.Parent                 = content
addTextGlow(iconLabel, Theme.Glow)

------------------------------------------------------------
-- DIVIDERS
------------------------------------------------------------
local function makeDivider(y)
	local div = Instance.new("Frame")
	div.Size                   = UDim2.new(0.55, 0, 0, 1)
	div.Position               = UDim2.new(0.225, 0, 0, y)
	div.BackgroundColor3       = Theme.Moonbeam
	div.BackgroundTransparency = 1
	div.BorderSizePixel        = 0
	div.ZIndex                 = 3
	div.Parent                 = content
	return div
end

local divTop = makeDivider(70)
local divBot = makeDivider(248)

------------------------------------------------------------
-- TEXT ELEMENTS
------------------------------------------------------------
local question = Instance.new("TextLabel")
question.Size                   = UDim2.new(1, 0, 0, 80)
question.Position               = UDim2.fromOffset(0, 86)
question.BackgroundTransparency = 1
question.Text                   = "Are you sure you want to leave?"
question.TextColor3             = Theme.Moonlight
question.TextSize               = 26
question.Font                   = FontTitle
question.TextXAlignment         = Enum.TextXAlignment.Center
question.TextYAlignment         = Enum.TextYAlignment.Center
question.TextWrapped            = true
question.TextTransparency       = 1
question.ZIndex                 = 3
question.Parent                 = content
addTextGlow(question, Theme.Glow)

local subText = Instance.new("TextLabel")
subText.Size                   = UDim2.new(1, 0, 0, 30)
subText.Position               = UDim2.fromOffset(0, 174)
subText.BackgroundTransparency = 1
subText.Text                   = "The script won't work if you leave."
subText.TextColor3             = Theme.Silver
subText.TextSize               = 14
subText.Font                   = FontBody
subText.TextXAlignment         = Enum.TextXAlignment.Center
subText.TextWrapped            = true
subText.TextTransparency       = 1
subText.ZIndex                 = 3
subText.Parent                 = content
addTextGlow(subText, Theme.DeepGlow)

local countdownLabel = Instance.new("TextLabel")
countdownLabel.Size                   = UDim2.new(1, 0, 0, 26)
countdownLabel.Position               = UDim2.fromOffset(0, 210)
countdownLabel.BackgroundTransparency = 1
countdownLabel.Text                   = string.format("Please wait  %ds ...", COUNTDOWN)
countdownLabel.TextColor3             = Theme.Silver
countdownLabel.TextSize               = 13
countdownLabel.Font                   = FontBody
countdownLabel.TextXAlignment         = Enum.TextXAlignment.Center
countdownLabel.TextTransparency       = 1
countdownLabel.ZIndex                 = 3
countdownLabel.Parent                 = content
addTextGlow(countdownLabel, Theme.DeepGlow)

local tipLabel = Instance.new("TextLabel")
tipLabel.Size                   = UDim2.new(1, 0, 0, 36)
tipLabel.Position               = UDim2.fromOffset(0, 330)
tipLabel.BackgroundTransparency = 1
tipLabel.Text                   = "Tip: If the script doesn't work, rejoin and try again."
tipLabel.TextColor3             = Theme.Silver
tipLabel.TextSize               = 12
tipLabel.Font                   = FontBody
tipLabel.TextXAlignment         = Enum.TextXAlignment.Center
tipLabel.TextWrapped            = true
tipLabel.TextTransparency       = 1
tipLabel.ZIndex                 = 3
tipLabel.Parent                 = content
addTextGlow(tipLabel, Theme.DeepGlow)

------------------------------------------------------------
-- BUTTONS
------------------------------------------------------------
local function makeButton(name, label, xScale)
	local btn = Instance.new("TextButton")
	btn.Name             = name
	btn.Size             = UDim2.new(0.30, 0, 0, 48)
	btn.Position         = UDim2.new(xScale, 0, 0, 266)
	btn.BackgroundColor3 = Theme.PanelSoft
	btn.BackgroundTransparency = 0.3
	btn.BorderSizePixel  = 0
	btn.Text             = label
	btn.TextColor3       = Theme.Silver
	btn.TextSize         = 15
	btn.Font             = FontBody
	btn.AutoButtonColor  = false
	btn.Active           = false
	btn.TextTransparency = 1
	btn.ZIndex           = 3
	btn.Parent           = content

	makeRounded(btn, 10)
	local stroke = applyMoonGlow(btn, 1.6)
	addTextGlow(btn, Theme.Glow)

	return btn, stroke
end

local leaveBtn,  leaveBtnStroke  = makeButton("LeaveBtn",  "Leave",  0.02)
local rejoinBtn, rejoinBtnStroke = makeButton("RejoinBtn", "Rejoin", 0.35)
local stayBtn,   stayBtnStroke   = makeButton("StayBtn",   "Stay",   0.68)

local allBtns = {
	{leaveBtn,  leaveBtnStroke,  Theme.Moonbeam},
	{rejoinBtn, rejoinBtnStroke, Theme.Moonlight},
	{stayBtn,   stayBtnStroke,   Theme.Silver},
}

------------------------------------------------------------
-- STATE
------------------------------------------------------------
local guiOpen       = false
local countdownConn = nil
local scriptLocked  = false
local isClosing     = false

------------------------------------------------------------
-- BUTTON UNLOCK / RESET
------------------------------------------------------------
local function unlockButtons()
	for _, t in ipairs(allBtns) do
		local btn, st, clr = t[1], t[2], t[3]
		btn.Active     = true
		btn.TextColor3 = clr
		st.Color       = Theme.Glow

		btn.MouseEnter:Connect(function()
			if btn.Active then
				TweenService:Create(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
					BackgroundTransparency = 0,
					BackgroundColor3 = Theme.Panel
				}):Play()
			end
		end)
		btn.MouseLeave:Connect(function()
			TweenService:Create(btn, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {
				BackgroundTransparency = 0.3,
				BackgroundColor3 = Theme.PanelSoft
			}):Play()
		end)
	end

	countdownLabel.Text       = "Make your choice:"
	countdownLabel.TextColor3 = Theme.Moonlight
end

local function resetButtons()
	for _, t in ipairs(allBtns) do
		t[1].Active     = false
		t[1].TextColor3 = Theme.Silver
		t[2].Color      = Theme.DeepGlow
		t[1].Visible    = true
		t[1].TextTransparency = 0
	end
	countdownLabel.Text       = string.format("Please wait  %ds ...", COUNTDOWN)
	countdownLabel.TextColor3 = Theme.Silver
end

------------------------------------------------------------
-- SMOOTH 2-SECOND EXIT ANIMATION
------------------------------------------------------------
local function playExitAnimation(onComplete)
	if isClosing then return end
	isClosing = true

	-- Disable all buttons immediately
	for _, t in ipairs(allBtns) do
		t[1].Active = false
	end

	-- Fade everything out smoothly over ~2 seconds
	local fadeInfo = TweenInfo.new(1.8, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

	-- Content scale + fade
	TweenService:Create(content, fadeInfo, {
		Size = UDim2.new(0.55, 0, 0, 320),
	}):Play()

	-- Fade all text
	for _, obj in ipairs({iconLabel, question, subText, countdownLabel, tipLabel}) do
		TweenService:Create(obj, fadeInfo, {TextTransparency = 1}):Play()
	end

	-- Fade buttons
	for _, t in ipairs(allBtns) do
		TweenService:Create(t[1], fadeInfo, {
			TextTransparency = 1,
			BackgroundTransparency = 1
		}):Play()
	end

	-- Fade dividers
	TweenService:Create(divTop, fadeInfo, {BackgroundTransparency = 1}):Play()
	TweenService:Create(divBot, fadeInfo, {BackgroundTransparency = 1}):Play()

	-- Final panel fade
	task.delay(0.9, function()
		TweenService:Create(panel, TweenInfo.new(1.0, Enum.EasingStyle.Quad), {
			BackgroundTransparency = 1
		}):Play()
	end)

	-- Finish after 2 seconds
	task.delay(2.05, function()
		if onComplete then onComplete() end
		isClosing = false
	end)
end

------------------------------------------------------------
-- CLOSE / OPEN
------------------------------------------------------------
local function closeGui()
	pcall(function() StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true) end)
	screenGui.Enabled = false
	guiOpen = false
	if countdownConn then countdownConn:Disconnect(); countdownConn = nil end
	resetButtons()
	question.Text  = "Are you sure you want to leave?"
	subText.Text   = "The script won't work if you leave."
	iconLabel.Text = "🌙"

	-- Reset content size for next open
	content.Size = UDim2.new(0.70, 0, 0, 430)
end

local function openGui()
	if guiOpen or scriptLocked or isClosing then return end
	guiOpen = true

	pcall(function()
		GuiService:SetMenuIsOpen(false)
		StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, false)
	end)

	-- Reset everything
	iconLabel.TextTransparency = 1
	question.TextTransparency  = 1
	subText.TextTransparency   = 1
	countdownLabel.TextTransparency = 1
	tipLabel.TextTransparency  = 1
	for _, t in ipairs(allBtns) do
		t[1].TextTransparency = 1
		t[1].BackgroundTransparency = 0.3
	end
	divTop.BackgroundTransparency = 1
	divBot.BackgroundTransparency = 1
	content.Size = UDim2.new(0.70, 0, 0, 430)

	panel.BackgroundTransparency = 0          -- fully opaque
	screenGui.Enabled = true

	-- Dividers
	task.delay(0.15, function()
		TweenService:Create(divTop, TweenInfo.new(0.4), {BackgroundTransparency = 0.45}):Play()
		TweenService:Create(divBot, TweenInfo.new(0.4), {BackgroundTransparency = 0.45}):Play()
	end)

	-- Left-to-right reveals
	fadeInLeftToRight(iconLabel,      0.50, 0.10)
	fadeInLeftToRight(question,       0.65, 0.22)
	fadeInLeftToRight(subText,        0.55, 0.38)
	fadeInLeftToRight(countdownLabel, 0.50, 0.50)
	fadeInLeftToRight(tipLabel,       0.55, 0.70)

	fadeInLeftToRight(leaveBtn,  0.45, 0.58)
	fadeInLeftToRight(rejoinBtn, 0.45, 0.64)
	fadeInLeftToRight(stayBtn,   0.45, 0.70)

	-- Countdown
	local remaining = COUNTDOWN
	countdownLabel.Text = string.format("Please wait  %ds ...", remaining)

	countdownConn = RunService.Heartbeat:Connect(function(dt)
		remaining -= dt
		local display = math.ceil(remaining)
		if display > 0 then
			countdownLabel.Text = string.format("Please wait  %ds ...", display)
		else
			countdownConn:Disconnect()
			countdownConn = nil
			unlockButtons()
		end
	end)
end

------------------------------------------------------------
-- BUTTON ACTIONS (with 2s smooth exit)
------------------------------------------------------------
leaveBtn.MouseButton1Click:Connect(function()
	if not leaveBtn.Active or isClosing then return end
	scriptLocked = true

	playExitAnimation(function()
		closeGui()
		pcall(function()
			StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.All, true)
		end)
	end)
end)

rejoinBtn.MouseButton1Click:Connect(function()
	if not rejoinBtn.Active or isClosing then return end
	scriptLocked = true
	if countdownConn then countdownConn:Disconnect(); countdownConn = nil end

	-- Change text first so player sees "Rejoining..."
	question.Text       = "Rejoining..."
	subText.Text        = "Reconnecting to the game..."
	iconLabel.Text      = "↻"
	countdownLabel.Text = ""

	playExitAnimation(function()
		TeleportService:Teleport(game.PlaceId, player)
	end)
end)

stayBtn.MouseButton1Click:Connect(function()
	if not stayBtn.Active or isClosing then return end

	playExitAnimation(function()
		closeGui()
	end)
end)

------------------------------------------------------------
-- DETECT ESC / ROBLOX MENU
------------------------------------------------------------
UserInputService.InputBegan:Connect(function(input, _)
	if input.KeyCode == Enum.KeyCode.Escape then
		if scriptLocked or isClosing then return end
		if not guiOpen then openGui() end
	end
end)

local menuWasOpen = false
RunService.Heartbeat:Connect(function()
	if scriptLocked or isClosing then return end
	local ok, isOpen = pcall(function() return GuiService.MenuIsOpen end)
	if not ok then return end
	if isOpen and not menuWasOpen then
		GuiService:SetMenuIsOpen(false)
		openGui()
	end
	menuWasOpen = isOpen
end)

------------------------------------------------------------
-- ONGOING GLOW ANIMATION
------------------------------------------------------------
RunService.RenderStepped:Connect(function()
	local t = tick()
	for _, grad in ipairs(sweepGradients) do
		grad.Rotation = (t * 40) % 360
	end
end)