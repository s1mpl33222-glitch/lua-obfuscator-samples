-- FXY Loader + Hub (merged) + Trigger Bot
do
	local Players = game:GetService("Players")
	local TweenService = game:GetService("TweenService")
	local LocalPlayer = Players.LocalPlayer
	local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

	local DISCORD = "discord.gg/YqnaxMkbk"
	local ACCENT = Color3.fromRGB(163, 113, 247)
	local ACCENT_BRIGHT = Color3.fromRGB(220, 190, 255)
	local ACCENT_DEEP = Color3.fromRGB(90, 55, 180)
	local BG = Color3.fromRGB(4, 3, 8)
	local TEXT_DIM = Color3.fromRGB(140, 140, 155)

	local screen = Instance.new("ScreenGui")
	screen.Name = "FXY_Loader"
	screen.ResetOnSpawn = false
	screen.IgnoreGuiInset = true
	screen.DisplayOrder = 999
	screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	screen.Parent = PlayerGui

	local root = Instance.new("CanvasGroup")
	root.Size = UDim2.new(1, 0, 1, 0)
	root.BackgroundTransparency = 1
	root.GroupTransparency = 1
	root.Parent = screen

	local bg = Instance.new("Frame")
	bg.Size = UDim2.new(1, 0, 1, 0)
	bg.BackgroundColor3 = BG
	bg.BorderSizePixel = 0
	bg.Parent = root

	local bgGlow = Instance.new("Frame")
	bgGlow.AnchorPoint = Vector2.new(0.5, 0.5)
	bgGlow.Size = UDim2.fromOffset(700, 700)
	bgGlow.Position = UDim2.new(0.5, 0, 0.5, 0)
	bgGlow.BackgroundColor3 = ACCENT_DEEP
	bgGlow.BackgroundTransparency = 0.93
	bgGlow.BorderSizePixel = 0
	bgGlow.Parent = bg
	local bgGlowCorner = Instance.new("UICorner")
	bgGlowCorner.CornerRadius = UDim.new(1, 0)
	bgGlowCorner.Parent = bgGlow

	local scanline = Instance.new("Frame")
	scanline.Size = UDim2.new(1, 0, 0, 2)
	scanline.Position = UDim2.new(0, 0, 0, 0)
	scanline.BackgroundColor3 = ACCENT
	scanline.BackgroundTransparency = 0.85
	scanline.BorderSizePixel = 0
	scanline.ZIndex = 2
	scanline.Parent = bg

	task.spawn(function()
		while scanline.Parent do
			scanline.Position = UDim2.new(0, 0, 0, 0)
			local tw = TweenService:Create(scanline, TweenInfo.new(3.2, Enum.EasingStyle.Linear), { Position = UDim2.new(0, 0, 1, 0) })
			tw:Play()
			tw.Completed:Wait()
			task.wait(0.6)
		end
	end)

	for _ = 1, 24 do
		local p = Instance.new("Frame")
		local size = math.random(2, 5)
		p.Size = UDim2.fromOffset(size, size)
		p.BackgroundColor3 = ACCENT
		p.BackgroundTransparency = 0.35
		p.BorderSizePixel = 0
		p.Position = UDim2.new(math.random(), 0, 1.15, 0)
		p.ZIndex = 1
		p.Parent = bg
		local pc = Instance.new("UICorner")
		pc.CornerRadius = UDim.new(1, 0)
		pc.Parent = p
		local startX = math.random()
		local drift = (math.random() - 0.5) * 0.15
		local duration = math.random(7, 13)
		local delay = math.random() * 5
		task.spawn(function()
			task.wait(delay)
			while p.Parent do
				p.Position = UDim2.new(startX, 0, 1.15, 0)
				p.BackgroundTransparency = 0.35
				local tw = TweenService:Create(p, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
					Position = UDim2.new(startX + drift, 0, -0.15, 0),
					BackgroundTransparency = 1
				})
				tw:Play()
				tw.Completed:Wait()
				task.wait(math.random() * 2)
			end
		end)
	end

	local center = Instance.new("Frame")
	center.Size = UDim2.fromOffset(520, 420)
	center.Position = UDim2.new(0.5, -260, 0.5, -210)
	center.BackgroundTransparency = 1
	center.ZIndex = 3
	center.Parent = root

	local function makeRing(size, thickness, baseTransparency)
		local ring = Instance.new("Frame")
		ring.AnchorPoint = Vector2.new(0.5, 0.5)
		ring.Size = UDim2.fromOffset(size, size)
		ring.Position = UDim2.new(0.5, 0, 0, 140)
		ring.BackgroundTransparency = 1
		ring.ZIndex = 3
		ring.Parent = center
		local c = Instance.new("UICorner")
		c.CornerRadius = UDim.new(1, 0)
		c.Parent = ring
		local s = Instance.new("UIStroke")
		s.Color = ACCENT
		s.Thickness = thickness
		s.Transparency = baseTransparency
		s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		s.Parent = ring
		local grad = Instance.new("UIGradient")
		grad.Color = ColorSequence.new{
			ColorSequenceKeypoint.new(0, ACCENT_DEEP),
			ColorSequenceKeypoint.new(0.35, ACCENT),
			ColorSequenceKeypoint.new(0.5, ACCENT_BRIGHT),
			ColorSequenceKeypoint.new(0.65, ACCENT),
			ColorSequenceKeypoint.new(1, ACCENT_DEEP)
		}
		grad.Parent = s
		return ring
	end

	local ring1 = makeRing(175, 2, 0.15)
	local ring2 = makeRing(230, 1.5, 0.4)
	local ring3 = makeRing(285, 1, 0.65)

	TweenService:Create(ring1, TweenInfo.new(5, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false), { Rotation = 360 }):Play()
	TweenService:Create(ring2, TweenInfo.new(9, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false), { Rotation = -360 }):Play()
	TweenService:Create(ring3, TweenInfo.new(15, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut, -1, false), { Rotation = 360 }):Play()

	local glow = Instance.new("Frame")
	glow.AnchorPoint = Vector2.new(0.5, 0.5)
	glow.Size = UDim2.fromOffset(200, 200)
	glow.Position = UDim2.new(0.5, 0, 0, 140)
	glow.BackgroundColor3 = ACCENT
	glow.BackgroundTransparency = 0.88
	glow.BorderSizePixel = 0
	glow.ZIndex = 3
	glow.Parent = center
	local glowCorner = Instance.new("UICorner")
	glowCorner.CornerRadius = UDim.new(1, 0)
	glowCorner.Parent = glow

	local title = Instance.new("TextLabel")
	title.AnchorPoint = Vector2.new(0.5, 0.5)
	title.Size = UDim2.fromOffset(420, 140)
	title.Position = UDim2.new(0.5, 0, 0, 140)
	title.BackgroundTransparency = 1
	title.Text = "FXY"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBlack
	title.TextSize = 100
	title.TextTransparency = 1
	title.ZIndex = 4
	title.Parent = center
	local titleStroke = Instance.new("UIStroke")
	titleStroke.Color = ACCENT
	titleStroke.Thickness = 3
	titleStroke.Transparency = 1
	titleStroke.Parent = title

	local sub = Instance.new("TextLabel")
	sub.AnchorPoint = Vector2.new(0.5, 0.5)
	sub.Size = UDim2.fromOffset(480, 20)
	sub.Position = UDim2.new(0.5, 0, 0, 232)
	sub.BackgroundTransparency = 1
	sub.Text = "JOIN THE DISCORD FOR MORE UPDATES"
	sub.TextColor3 = ACCENT_BRIGHT
	sub.Font = Enum.Font.GothamBold
	sub.TextSize = 13
	sub.TextTransparency = 1
	sub.ZIndex = 4
	sub.Parent = center

	local link = Instance.new("TextLabel")
	link.AnchorPoint = Vector2.new(1, 0.5)
	link.Size = UDim2.fromOffset(300, 22)
	link.Position = UDim2.new(0.5, -6, 0, 258)
	link.BackgroundTransparency = 1
	link.Text = DISCORD
	link.TextColor3 = ACCENT
	link.Font = Enum.Font.GothamBold
	link.TextSize = 15
	link.TextXAlignment = Enum.TextXAlignment.Right
	link.TextTransparency = 1
	link.ZIndex = 4
	link.Parent = center

	local copyBtn = Instance.new("TextButton")
	copyBtn.AnchorPoint = Vector2.new(0, 0.5)
	copyBtn.Size = UDim2.fromOffset(72, 24)
	copyBtn.Position = UDim2.new(0.5, 8, 0, 258)
	copyBtn.BackgroundColor3 = ACCENT
	copyBtn.BackgroundTransparency = 1
	copyBtn.Text = "COPY"
	copyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	copyBtn.Font = Enum.Font.GothamBold
	copyBtn.TextSize = 11
	copyBtn.TextTransparency = 1
	copyBtn.AutoButtonColor = false
	copyBtn.ZIndex = 5
	copyBtn.Parent = center
	local copyCorner = Instance.new("UICorner")
	copyCorner.CornerRadius = UDim.new(0, 6)
	copyCorner.Parent = copyBtn
	local copyStroke = Instance.new("UIStroke")
	copyStroke.Color = ACCENT_BRIGHT
	copyStroke.Thickness = 1.5
	copyStroke.Transparency = 1
	copyStroke.Parent = copyBtn

	local copyBusy = false
	copyBtn.MouseButton1Click:Connect(function()
		if copyBusy then return end
		copyBusy = true
		pcall(function() if setclipboard then setclipboard("https://" .. DISCORD) end end)
		local old = copyBtn.Text
		copyBtn.Text = "COPIED"
		TweenService:Create(copyBtn, TweenInfo.new(0.1), { BackgroundColor3 = ACCENT_BRIGHT }):Play()
		task.wait(1.1)
		copyBtn.Text = old
		TweenService:Create(copyBtn, TweenInfo.new(0.25), { BackgroundColor3 = ACCENT }):Play()
		copyBusy = false
	end)

	link.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			pcall(function()
				if setclipboard then
					setclipboard("https://" .. DISCORD)
					local old = link.Text
					link.Text = "Copied!"
					link.TextColor3 = ACCENT_BRIGHT
					task.wait(1)
					link.Text = old
					link.TextColor3 = ACCENT
				end
			end)
		end
	end)

	local statusLabel = Instance.new("TextLabel")
	statusLabel.AnchorPoint = Vector2.new(0.5, 0.5)
	statusLabel.Size = UDim2.fromOffset(480, 18)
	statusLabel.Position = UDim2.new(0.5, 0, 0, 302)
	statusLabel.BackgroundTransparency = 1
	statusLabel.Text = ""
	statusLabel.TextColor3 = TEXT_DIM
	statusLabel.Font = Enum.Font.GothamMedium
	statusLabel.TextSize = 12
	statusLabel.TextTransparency = 1
	statusLabel.ZIndex = 4
	statusLabel.Parent = center

	local barTrack = Instance.new("Frame")
	barTrack.AnchorPoint = Vector2.new(0.5, 0.5)
	barTrack.Size = UDim2.new(1, -140, 0, 6)
	barTrack.Position = UDim2.new(0.5, 0, 0, 342)
	barTrack.BackgroundColor3 = Color3.fromRGB(16, 16, 22)
	barTrack.BorderSizePixel = 0
	barTrack.ZIndex = 4
	barTrack.Parent = center
	local barCorner = Instance.new("UICorner")
	barCorner.CornerRadius = UDim.new(1, 0)
	barCorner.Parent = barTrack
	local barStroke = Instance.new("UIStroke")
	barStroke.Color = ACCENT_DEEP
	barStroke.Thickness = 1
	barStroke.Transparency = 0.3
	barStroke.Parent = barTrack

	local barFill = Instance.new("Frame")
	barFill.Size = UDim2.new(0, 0, 1, 0)
	barFill.BackgroundColor3 = ACCENT
	barFill.BorderSizePixel = 0
	barFill.ZIndex = 5
	barFill.Parent = barTrack
	local fillCorner = Instance.new("UICorner")
	fillCorner.CornerRadius = UDim.new(1, 0)
	fillCorner.Parent = barFill
	local fillGrad = Instance.new("UIGradient")
	fillGrad.Color = ColorSequence.new{
		ColorSequenceKeypoint.new(0, ACCENT_DEEP),
		ColorSequenceKeypoint.new(1, ACCENT_BRIGHT)
	}
	fillGrad.Parent = barFill

	local percent = Instance.new("TextLabel")
	percent.AnchorPoint = Vector2.new(0.5, 0.5)
	percent.Size = UDim2.fromOffset(480, 18)
	percent.Position = UDim2.new(0.5, 0, 0, 366)
	percent.BackgroundTransparency = 1
	percent.Text = "0%"
	percent.TextColor3 = TEXT_DIM
	percent.Font = Enum.Font.GothamBold
	percent.TextSize = 11
	percent.TextTransparency = 1
	percent.ZIndex = 4
	percent.Parent = center

	TweenService:Create(root, TweenInfo.new(0.4), { GroupTransparency = 0 }):Play()
	task.spawn(function()
		TweenService:Create(title, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { TextTransparency = 0 }):Play()
		TweenService:Create(titleStroke, TweenInfo.new(0.7, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), { Transparency = 0 }):Play()
		TweenService:Create(glow, TweenInfo.new(1.6, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut, -1, true), { BackgroundTransparency = 0.72 }):Play()
	end)

	task.wait(0.4)
	TweenService:Create(sub, TweenInfo.new(0.5), { TextTransparency = 0 }):Play()
	task.wait(0.12)
	TweenService:Create(link, TweenInfo.new(0.5), { TextTransparency = 0 }):Play()
	TweenService:Create(copyBtn, TweenInfo.new(0.5), { BackgroundTransparency = 0.15, TextTransparency = 0 }):Play()
	TweenService:Create(copyStroke, TweenInfo.new(0.5), { Transparency = 0.3 }):Play()
	task.wait(0.15)
	TweenService:Create(statusLabel, TweenInfo.new(0.5), { TextTransparency = 0 }):Play()
	task.wait(0.05)
	TweenService:Create(percent, TweenInfo.new(0.5), { TextTransparency = 0 }):Play()

	task.spawn(function()
		local messages = {"Connecting to server...","Loading modules...","Injecting FXY...","Almost there..."}
		for _, m in ipairs(messages) do
			if not statusLabel.Parent then break end
			statusLabel.Text = m
			task.wait(0.6)
		end
	end)

	local start = tick()
	local MIN_DURATION = 2.6
	while tick() - start < MIN_DURATION do
		local t = math.min((tick() - start) / MIN_DURATION, 1)
		local eased = 1 - (1 - t) * (1 - t)
		barFill.Size = UDim2.new(eased, 0, 1, 0)
		percent.Text = math.floor(eased * 100) .. "%"
		task.wait()
	end

	barFill.Size = UDim2.new(1, 0, 1, 0)
	percent.Text = "100%"
	statusLabel.Text = "Ready."
	statusLabel.TextColor3 = ACCENT_BRIGHT
	TweenService:Create(barFill, TweenInfo.new(0.15), { BackgroundColor3 = ACCENT_BRIGHT }):Play()
	task.wait(0.2)
	TweenService:Create(barFill, TweenInfo.new(0.2), { BackgroundColor3 = ACCENT }):Play()
	task.wait(0.15)
	TweenService:Create(root, TweenInfo.new(0.5), { GroupTransparency = 1 }):Play()
	task.wait(0.55)
	screen:Destroy()
	task.wait(0.05)
end

-- ============================================================
-- FXY HUB
-- ============================================================
print("FXY: Started")

_G.FXY_Connections = _G.FXY_Connections or {}
_G.FXY_NameTagBillboards = _G.FXY_NameTagBillboards or {}
_G.FXY_NameTagConnections = _G.FXY_NameTagConnections or {}
_G.FXY_HealthBars = _G.FXY_HealthBars or {}
_G.FXY_HealthBarData = _G.FXY_HealthBarData or {}
_G.FXY_HealthBarConnections = _G.FXY_HealthBarConnections or {}
_G.FXY_ESPBoxes = _G.FXY_ESPBoxes or {}
_G.FXY_ESPBoxData = _G.FXY_ESPBoxData or {}
_G.FXY_ESPBoxConnections = _G.FXY_ESPBoxConnections or {}
_G.FXY_Tracers = _G.FXY_Tracers or {}
_G.FXY_TracerConnections = _G.FXY_TracerConnections or {}

local function safeDisconnect(conn)
	if conn then pcall(function() conn:Disconnect() end) end
end

local function cleanupDictionary(dictionary)
	for key,value in pairs(dictionary) do
		if typeof(value) == "RBXScriptConnection" then safeDisconnect(value)
		elseif typeof(value) == "Instance" then pcall(function() value:Destroy() end)
		elseif type(value) == "table" then
			if value.frame then pcall(function() value.frame:Destroy() end) end
			if value.line then pcall(function() value.line:Destroy() end) end
		end
		dictionary[key] = nil
	end
end

local function cleanupFXY()
	print("FXY: Cleaning previous instance...")
	for _,conn in ipairs(_G.FXY_Connections) do safeDisconnect(conn) end
	_G.FXY_Connections = {}
	for player,bill in pairs(_G.FXY_NameTagBillboards) do
		pcall(function() bill:Destroy() end)
		_G.FXY_NameTagBillboards[player] = nil
	end
	cleanupDictionary(_G.FXY_NameTagConnections)
	for player,bill in pairs(_G.FXY_HealthBars) do
		pcall(function() bill:Destroy() end)
		_G.FXY_HealthBars[player] = nil
	end
	_G.FXY_HealthBarData = {}
	cleanupDictionary(_G.FXY_HealthBarConnections)
	for player,data in pairs(_G.FXY_ESPBoxes) do
		if data and data.frame then pcall(function() data.frame:Destroy() end) end
		_G.FXY_ESPBoxes[player] = nil
	end
	_G.FXY_ESPBoxData = {}
	cleanupDictionary(_G.FXY_ESPBoxConnections)
	for player,data in pairs(_G.FXY_Tracers) do
		if data and data.line then pcall(function() data.line:Destroy() end) end
		_G.FXY_Tracers[player] = nil
	end
	cleanupDictionary(_G.FXY_TracerConnections)
	if _G.FXY_ScreenGui then
		pcall(function() _G.FXY_ScreenGui:Destroy() end)
		_G.FXY_ScreenGui = nil
	end
	print("FXY: Cleanup complete")
end

cleanupFXY()

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")

local LocalPlayer = Players.LocalPlayer
if not LocalPlayer then error("FXY: LocalPlayer unavailable") end
print("FXY: Services acquired")

local ok,err = pcall(function()
	local PlayerGui = LocalPlayer:FindFirstChildOfClass("PlayerGui")
	if not PlayerGui then PlayerGui = LocalPlayer:WaitForChild("PlayerGui") end
	if not PlayerGui then error("FXY: PlayerGui unavailable") end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "FXY_Interface"
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.IgnoreGuiInset = true
	ScreenGui.Parent = PlayerGui
	_G.FXY_ScreenGui = ScreenGui

	local GUI_THEMES = {
		Purple = { Background = Color3.fromRGB(15,15,17), Panel = Color3.fromRGB(22,22,26), Accent = Color3.fromRGB(163,113,247), AccentDim = Color3.fromRGB(98,67,148), TextActive = Color3.fromRGB(255,255,255), TextMuted = Color3.fromRGB(140,140,145), Border = Color3.fromRGB(35,35,40) },
		Blue = { Background = Color3.fromRGB(10,14,22), Panel = Color3.fromRGB(18,25,38), Accent = Color3.fromRGB(70,145,255), AccentDim = Color3.fromRGB(45,82,145), TextActive = Color3.fromRGB(255,255,255), TextMuted = Color3.fromRGB(145,155,170), Border = Color3.fromRGB(32,43,62) },
		Cyan = { Background = Color3.fromRGB(8,17,20), Panel = Color3.fromRGB(14,28,32), Accent = Color3.fromRGB(45,220,230), AccentDim = Color3.fromRGB(30,120,130), TextActive = Color3.fromRGB(255,255,255), TextMuted = Color3.fromRGB(140,165,170), Border = Color3.fromRGB(30,55,60) },
		Pink = { Background = Color3.fromRGB(20,10,17), Panel = Color3.fromRGB(31,17,27), Accent = Color3.fromRGB(255,90,175), AccentDim = Color3.fromRGB(145,50,100), TextActive = Color3.fromRGB(255,255,255), TextMuted = Color3.fromRGB(165,140,155), Border = Color3.fromRGB(55,30,48) },
		Red = { Background = Color3.fromRGB(20,10,10), Panel = Color3.fromRGB(32,17,17), Accent = Color3.fromRGB(255,75,75), AccentDim = Color3.fromRGB(145,45,45), TextActive = Color3.fromRGB(255,255,255), TextMuted = Color3.fromRGB(165,140,140), Border = Color3.fromRGB(55,30,30) },
		Green = { Background = Color3.fromRGB(9,18,12), Panel = Color3.fromRGB(16,29,20), Accent = Color3.fromRGB(70,220,115), AccentDim = Color3.fromRGB(40,125,70), TextActive = Color3.fromRGB(255,255,255), TextMuted = Color3.fromRGB(140,165,148), Border = Color3.fromRGB(30,55,37) },
		Orange = { Background = Color3.fromRGB(20,14,8), Panel = Color3.fromRGB(32,24,14), Accent = Color3.fromRGB(255,155,55), AccentDim = Color3.fromRGB(145,85,30), TextActive = Color3.fromRGB(255,255,255), TextMuted = Color3.fromRGB(165,150,135), Border = Color3.fromRGB(55,43,28) },
		Gold = { Background = Color3.fromRGB(19,17,8), Panel = Color3.fromRGB(31,28,14), Accent = Color3.fromRGB(255,205,65), AccentDim = Color3.fromRGB(145,115,35), TextActive = Color3.fromRGB(255,255,255), TextMuted = Color3.fromRGB(165,158,130), Border = Color3.fromRGB(55,50,28) },
		Ice = { Background = Color3.fromRGB(9,16,21), Panel = Color3.fromRGB(16,27,35), Accent = Color3.fromRGB(150,225,255), AccentDim = Color3.fromRGB(80,125,150), TextActive = Color3.fromRGB(255,255,255), TextMuted = Color3.fromRGB(145,165,175), Border = Color3.fromRGB(30,50,62) },
		Rose = { Background = Color3.fromRGB(20,10,13), Panel = Color3.fromRGB(32,17,22), Accent = Color3.fromRGB(255,115,140), AccentDim = Color3.fromRGB(145,60,78), TextActive = Color3.fromRGB(255,255,255), TextMuted = Color3.fromRGB(165,140,145), Border = Color3.fromRGB(55,30,37) },
		Midnight = { Background = Color3.fromRGB(7,8,15), Panel = Color3.fromRGB(13,15,28), Accent = Color3.fromRGB(105,120,255), AccentDim = Color3.fromRGB(55,65,145), TextActive = Color3.fromRGB(255,255,255), TextMuted = Color3.fromRGB(135,140,165), Border = Color3.fromRGB(27,30,52) },
		White = { Background = Color3.fromRGB(235,235,238), Panel = Color3.fromRGB(250,250,252), Accent = Color3.fromRGB(80,80,90), AccentDim = Color3.fromRGB(175,175,185), TextActive = Color3.fromRGB(20,20,24), TextMuted = Color3.fromRGB(90,90,100), Border = Color3.fromRGB(205,205,212) }
	}
	local GUI_THEME_NAMES = {"Purple","Blue","Cyan","Pink","Red","Green","Orange","Gold","Ice","Rose","Midnight","White"}
	local THEME = GUI_THEMES.Purple

	local SettingsState = {
		CameraLockEnabled = false,
		LockPart = "HumanoidRootPart",
		PredictionHorizontal = 0.15,
		PredictionVertical = 0.15,
		RapidFire = false,
		RapidFireDelay = 0.05,
		ActiveTab = "Aim",
		CurrentTarget = nil,
		NameTagsEnabled = false,
		HealthBarsEnabled = false,
		ESPBoxesEnabled = false,
		TracersEnabled = false,
		ESPColor = Color3.fromRGB(255,255,255),
		TracerColor = Color3.fromRGB(255,255,255),
		NameTagColor = Color3.fromRGB(255,255,255),
		GUITheme = "Purple",
		espFrameCounter = 0,
		tracerFrameCounter = 0,
		UpdateInterval = 2,
		-- NEW: Trigger Bot
		TriggerBotEnabled = false,
		TriggerBotDelay = 0.05,
	}

	local ThemeObjects = {}
	local glowTween
	local MainFrame
	local quickCamlockBtn
	local targetNameLabel
	local ToggleButton
	local watermarkLabel

	local function themeObject(object,role)
		if object then
			object:SetAttribute("FXYThemeRole",role)
			table.insert(ThemeObjects,object)
		end
		return object
	end

	local function setThemeColor(object,property,color)
		if object and object.Parent then
			pcall(function() object[property] = color end)
		end
	end

	local function applyGUITheme(themeName)
		local selected = GUI_THEMES[themeName]
		if not selected then themeName = "Purple" selected = GUI_THEMES.Purple end
		THEME = selected
		SettingsState.GUITheme = themeName
		for _,object in ipairs(ThemeObjects) do
			if object and object.Parent then
				local role = object:GetAttribute("FXYThemeRole")
				if role == "Background" then setThemeColor(object,"BackgroundColor3",THEME.Background)
				elseif role == "Panel" then setThemeColor(object,"BackgroundColor3",THEME.Panel)
				elseif role == "Accent" then setThemeColor(object,"BackgroundColor3",THEME.Accent)
				elseif role == "AccentText" then setThemeColor(object,"TextColor3",THEME.Accent)
				elseif role == "ActiveText" then setThemeColor(object,"TextColor3",THEME.TextActive)
				elseif role == "MutedText" then setThemeColor(object,"TextColor3",THEME.TextMuted)
				elseif role == "Border" then setThemeColor(object,"Color",THEME.Border)
				elseif role == "AccentStroke" then setThemeColor(object,"Color",THEME.Accent)
				elseif role == "AccentDim" then setThemeColor(object,"BackgroundColor3",THEME.AccentDim)
				elseif role == "ScrollBar" then setThemeColor(object,"ScrollBarImageColor3",THEME.Accent) end
			end
		end
		if quickCamlockBtn then quickCamlockBtn.BackgroundColor3 = SettingsState.CameraLockEnabled and THEME.Accent or THEME.Background end
		if targetNameLabel then targetNameLabel.TextColor3 = THEME.Accent end
		if watermarkLabel then watermarkLabel.TextColor3 = THEME.Accent end
		if ToggleButton then ToggleButton.BackgroundColor3 = THEME.Panel ToggleButton.TextColor3 = THEME.Accent end
		if MainFrame then MainFrame.BackgroundColor3 = THEME.Background end
		if glowTween then pcall(function() glowTween:Cancel() end) glowTween = nil end
		if SettingsState.CameraLockEnabled and targetNameLabel then targetNameLabel.TextColor3 = THEME.Accent end
	end

	local function createCorner(parent,radius)
		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(0,radius or 8)
		corner.Parent = parent
		return corner
	end

	local function createStroke(parent,color,thickness,role)
		local stroke = Instance.new("UIStroke")
		stroke.Color = color
		stroke.Thickness = thickness or 1
		stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		stroke.Parent = parent
		if role then themeObject(stroke,role) end
		return stroke
	end

	local function addConnection(conn)
		if conn then table.insert(_G.FXY_Connections,conn) end
		return conn
	end

	local fpsLabel = Instance.new("TextLabel")
	fpsLabel.Name = "FPS_Counter"
	fpsLabel.Size = UDim2.fromOffset(90,30)
	fpsLabel.Position = UDim2.new(1,-100,0,10)
	fpsLabel.BackgroundTransparency = 1
	fpsLabel.Text = "FPS: 0"
	fpsLabel.TextColor3 = THEME.TextActive
	fpsLabel.Font = Enum.Font.GothamBold
	fpsLabel.TextSize = 14
	fpsLabel.TextXAlignment = Enum.TextXAlignment.Right
	fpsLabel.Visible = false
	fpsLabel.Parent = ScreenGui
	themeObject(fpsLabel,"ActiveText")

	watermarkLabel = Instance.new("TextLabel")
	watermarkLabel.Name = "Watermark"
	watermarkLabel.Size = UDim2.fromOffset(180,30)
	watermarkLabel.Position = UDim2.new(1,-190,1,-40)
	watermarkLabel.BackgroundTransparency = 1
	watermarkLabel.Text = "FXY // FAISLXYHAY"
	watermarkLabel.TextColor3 = THEME.Accent
	watermarkLabel.Font = Enum.Font.GothamBold
	watermarkLabel.TextSize = 14
	watermarkLabel.TextXAlignment = Enum.TextXAlignment.Right
	watermarkLabel.Visible = false
	watermarkLabel.Parent = ScreenGui
	themeObject(watermarkLabel,"AccentText")

	local fpsHistory = {}
	local fpsConn = RunService.Heartbeat:Connect(function(delta)
		if delta and delta > 0 then
			local fps = math.floor((1/delta)+0.5)
			table.insert(fpsHistory,fps)
			if #fpsHistory > 10 then table.remove(fpsHistory,1) end
			local total = 0
			for _,value in ipairs(fpsHistory) do total = total + value end
			if #fpsHistory > 0 then
				local average = math.floor((total/#fpsHistory)+0.5)
				fpsLabel.Text = "FPS: "..average
			end
		end
	end)
	addConnection(fpsConn)

	local function makeDraggable(frame,handle)
		local dragging = false
		local dragStart
		local startPosition
		addConnection(handle.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				dragStart = input.Position
				startPosition = frame.Position
			end
		end))
		addConnection(UserInputService.InputChanged:Connect(function(input)
			if not dragging then return end
			if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end
			local delta = input.Position-dragStart
			frame.Position = UDim2.new(startPosition.X.Scale,startPosition.X.Offset+delta.X,startPosition.Y.Scale,startPosition.Y.Offset+delta.Y)
		end))
		addConnection(UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
		end))
	end

	targetNameLabel = Instance.new("TextLabel")
	targetNameLabel.Name = "TargetName"
	targetNameLabel.Size = UDim2.fromOffset(220,30)
	targetNameLabel.Position = UDim2.fromOffset(10,10)
	targetNameLabel.BackgroundTransparency = 1
	targetNameLabel.Text = ""
	targetNameLabel.TextColor3 = THEME.Accent
	targetNameLabel.Font = Enum.Font.GothamBold
	targetNameLabel.TextSize = 18
	targetNameLabel.TextXAlignment = Enum.TextXAlignment.Left
	targetNameLabel.Parent = ScreenGui
	themeObject(targetNameLabel,"AccentText")
	createStroke(targetNameLabel,THEME.Background,2)

	local function startGlow()
		if glowTween then return end
		glowTween = TweenService:Create(targetNameLabel,TweenInfo.new(1.2,Enum.EasingStyle.Sine,Enum.EasingDirection.InOut,-1,true),{TextColor3=THEME.Accent:Lerp(Color3.fromRGB(255,255,255),0.35)})
		glowTween:Play()
	end
	local function stopGlow()
		if glowTween then glowTween:Cancel() glowTween = nil end
		targetNameLabel.TextColor3 = THEME.Accent
	end

	quickCamlockBtn = Instance.new("TextButton")
	quickCamlockBtn.Name = "QuickCamlock"
	quickCamlockBtn.Size = UDim2.fromOffset(70,70)
	quickCamlockBtn.Position = UDim2.new(0.85,-80,0.30,-80)
	quickCamlockBtn.BackgroundColor3 = THEME.Background
	quickCamlockBtn.Text = "🔒"
	quickCamlockBtn.TextColor3 = THEME.TextActive
	quickCamlockBtn.Font = Enum.Font.GothamBold
	quickCamlockBtn.TextSize = 28
	quickCamlockBtn.Parent = ScreenGui
	themeObject(quickCamlockBtn,"Background")
	createCorner(quickCamlockBtn,35)
	createStroke(quickCamlockBtn,THEME.Accent,2,"AccentStroke")

	local function getTargetFromCrosshair()
		local character = LocalPlayer.Character
		if not character then return nil end
		local camera = workspace.CurrentCamera
		if not camera then return nil end
		local viewport = camera.ViewportSize
		local center = Vector2.new(viewport.X/2,viewport.Y/2)
		local ray = camera:ViewportPointToRay(center.X,center.Y)
		local params = RaycastParams.new()
		params.FilterType = Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances = {character}
		params.IgnoreWater = true
		local result = workspace:Raycast(ray.Origin,ray.Direction*500,params)
		if result then
			local model = result.Instance:FindFirstAncestorOfClass("Model")
			if model then
				local player = Players:GetPlayerFromCharacter(model)
				local humanoid = model:FindFirstChildOfClass("Humanoid")
				if player and player ~= LocalPlayer and humanoid and humanoid.Health > 0 then return model end
			end
		end
		local bestTarget
		local bestDistance = 150
		for _,player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer and player.Character then
				local targetPart = player.Character:FindFirstChild(SettingsState.LockPart)
				local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
				if targetPart and humanoid and humanoid.Health > 0 then
					local screenPos,onScreen = camera:WorldToViewportPoint(targetPart.Position)
					if onScreen then
						local dx = screenPos.X-center.X
						local dy = screenPos.Y-center.Y
						local distance = math.sqrt(dx*dx+dy*dy)
						if distance < bestDistance then
							bestDistance = distance
							bestTarget = player.Character
						end
					end
				end
			end
		end
		return bestTarget
	end

	local camlockToggleSetter
	local isToggling = false
	local function toggleLock(state)
		if isToggling then return end
		isToggling = true
		if state == nil then state = not SettingsState.CameraLockEnabled end
		if state then
			local target = getTargetFromCrosshair()
			if target then
				SettingsState.CameraLockEnabled = true
				SettingsState.CurrentTarget = target
				quickCamlockBtn.BackgroundColor3 = THEME.Accent
				quickCamlockBtn.Text = "🔓"
				if camlockToggleSetter then camlockToggleSetter(true) end
			else
				SettingsState.CameraLockEnabled = false
				SettingsState.CurrentTarget = nil
				quickCamlockBtn.BackgroundColor3 = THEME.Background
				quickCamlockBtn.Text = "🔒"
				if camlockToggleSetter then camlockToggleSetter(false) end
			end
		else
			SettingsState.CameraLockEnabled = false
			SettingsState.CurrentTarget = nil
			targetNameLabel.Text = ""
			stopGlow()
			quickCamlockBtn.BackgroundColor3 = THEME.Background
			quickCamlockBtn.Text = "🔒"
			if camlockToggleSetter then camlockToggleSetter(false) end
		end
		isToggling = false
	end

	addConnection(quickCamlockBtn.MouseButton1Click:Connect(function() toggleLock() end))

	MainFrame = Instance.new("Frame")
	MainFrame.Name = "MainFrame"
	MainFrame.Size = UDim2.fromOffset(580,380)
	MainFrame.Position = UDim2.new(0.5,-290,0.5,-190)
	MainFrame.BackgroundColor3 = THEME.Background
	MainFrame.BorderSizePixel = 0
	MainFrame.Parent = ScreenGui
	themeObject(MainFrame,"Background")
	createCorner(MainFrame,12)
	createStroke(MainFrame,THEME.Border,1,"Border")

	local function clampMainFrame()
		local camera = workspace.CurrentCamera
		if not camera then return end
		local viewport = camera.ViewportSize
		if viewport.X <= 0 or viewport.Y <= 0 then return end
		local width = math.min(580,math.max(260,viewport.X-20))
		local height = math.min(380,math.max(220,viewport.Y-20))
		MainFrame.Size = UDim2.fromOffset(width,height)
		MainFrame.Position = UDim2.new(0.5,-width/2,0.5,-height/2)
	end
	clampMainFrame()

	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.fromOffset(30,30)
	closeBtn.Position = UDim2.new(1,-40,0,10)
	closeBtn.BackgroundTransparency = 1
	closeBtn.Text = "✕"
	closeBtn.TextColor3 = THEME.TextMuted
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 16
	closeBtn.Parent = MainFrame
	themeObject(closeBtn,"MutedText")
	addConnection(closeBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false end))

	local TopBar = Instance.new("Frame")
	TopBar.Size = UDim2.new(1,0,0,50)
	TopBar.BackgroundTransparency = 1
	TopBar.Parent = MainFrame

	local BrandLabel = Instance.new("TextLabel")
	BrandLabel.Size = UDim2.fromOffset(180,50)
	BrandLabel.Position = UDim2.fromOffset(20,0)
	BrandLabel.BackgroundTransparency = 1
	BrandLabel.Text = "FXY // FAISLXYHAY"
	BrandLabel.TextColor3 = THEME.TextActive
	BrandLabel.Font = Enum.Font.GothamBold
	BrandLabel.TextSize = 14
	BrandLabel.TextXAlignment = Enum.TextXAlignment.Left
	BrandLabel.Parent = TopBar
	themeObject(BrandLabel,"ActiveText")
	makeDraggable(MainFrame,TopBar)

	local Sidebar = Instance.new("Frame")
	Sidebar.Size = UDim2.new(0,140,1,-50)
	Sidebar.Position = UDim2.fromOffset(0,50)
	Sidebar.BackgroundTransparency = 1
	Sidebar.Parent = MainFrame
	local sidebarLayout = Instance.new("UIListLayout")
	sidebarLayout.Padding = UDim.new(0,6)
	sidebarLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	sidebarLayout.Parent = Sidebar

	local ContentContainer = Instance.new("Frame")
	ContentContainer.Size = UDim2.new(1,-160,1,-70)
	ContentContainer.Position = UDim2.fromOffset(140,55)
	ContentContainer.BackgroundTransparency = 1
	ContentContainer.ClipsDescendants = true
	ContentContainer.Parent = MainFrame

	local TabFrames = {}
	local function createTabFrame(name)
		local scroll = Instance.new("ScrollingFrame")
		scroll.Size = UDim2.new(1,0,1,0)
		scroll.BackgroundTransparency = 1
		scroll.BorderSizePixel = 0
		scroll.ScrollBarThickness = 2
		scroll.ScrollBarImageColor3 = THEME.Accent
		scroll.Visible = SettingsState.ActiveTab == name
		scroll.Parent = ContentContainer
		themeObject(scroll,"ScrollBar")
		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0,10)
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		layout.Parent = scroll
		TabFrames[name] = scroll
		return scroll,layout
	end
	local aimTab,aimLayout = createTabFrame("Aim")
	local gunsTab,gunsLayout = createTabFrame("Guns")
	local visualsTab,visualsLayout = createTabFrame("Visuals")
	local settingsTab,settingsLayout = createTabFrame("Settings")

	ToggleButton = Instance.new("TextButton")
	ToggleButton.Name = "FXY_Toggle"
	ToggleButton.Size = UDim2.fromOffset(50,50)
	ToggleButton.Position = UDim2.new(0.05,0,0.05,0)
	ToggleButton.BackgroundColor3 = THEME.Panel
	ToggleButton.Text = "FXY"
	ToggleButton.TextColor3 = THEME.Accent
	ToggleButton.Font = Enum.Font.GothamBold
	ToggleButton.TextSize = 14
	ToggleButton.Parent = ScreenGui
	themeObject(ToggleButton,"Panel")
	createCorner(ToggleButton,25)
	createStroke(ToggleButton,THEME.Accent,2,"AccentStroke")
	makeDraggable(ToggleButton,ToggleButton)

	local menuOpen = true
	addConnection(ToggleButton.MouseButton1Click:Connect(function()
		menuOpen = not menuOpen
		if menuOpen then
			MainFrame.Visible = true
			MainFrame.BackgroundTransparency = 0
		else
			MainFrame.Visible = false
		end
	end))

	local Components = {}

	function Components.CreateSection(parent,text)
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0.95,0,0,25)
		label.BackgroundTransparency = 1
		label.Text = string.upper(text)
		label.TextColor3 = THEME.Accent
		label.Font = Enum.Font.GothamBold
		label.TextSize = 10
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = parent
		themeObject(label,"AccentText")
	end

	function Components.CreateToggle(parent,text,default,callback,comingSoon)
		local container = Instance.new("Frame")
		container.Size = UDim2.new(0.95,0,0,40)
		container.BackgroundColor3 = THEME.Panel
		container.Parent = parent
		themeObject(container,"Panel")
		createCorner(container,8)
		createStroke(container,THEME.Border,1,"Border")

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0.6,0,1,0)
		label.Position = UDim2.fromOffset(12,0)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextColor3 = THEME.TextActive
		label.Font = Enum.Font.GothamMedium
		label.TextSize = 12
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = container
		themeObject(label,"ActiveText")

		local switch = Instance.new("TextButton")
		switch.Size = UDim2.fromOffset(40,20)
		switch.Position = UDim2.new(1,-52,0.5,-10)
		switch.BackgroundColor3 = default and THEME.Accent or THEME.Background
		switch.Text = ""
		switch.Parent = container
		createCorner(switch,10)
		createStroke(switch,THEME.Border,1,"Border")

		local glow = Instance.new("UIStroke")
		glow.Color = THEME.Accent
		glow.Thickness = 2
		glow.Transparency = default and 0.3 or 1
		glow.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		glow.Parent = switch
		themeObject(glow,"AccentStroke")

		local ball = Instance.new("Frame")
		ball.Size = UDim2.fromOffset(14,14)
		ball.Position = default and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
		ball.BackgroundColor3 = Color3.fromRGB(255,255,255)
		ball.Parent = switch
		createCorner(ball,7)

		local state = default

		if comingSoon then
			local labelCS = Instance.new("TextLabel")
			labelCS.Size = UDim2.fromOffset(30,40)
			labelCS.Position = UDim2.new(0.65,0,0,0)
			labelCS.BackgroundTransparency = 1
			labelCS.Text = "⏳"
			labelCS.TextColor3 = Color3.fromRGB(255,200,100)
			labelCS.Font = Enum.Font.GothamMedium
			labelCS.TextSize = 14
			labelCS.Parent = container
		end

		addConnection(switch.MouseButton1Click:Connect(function()
			if comingSoon then return end
			state = not state
			local position = state and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
			TweenService:Create(ball,TweenInfo.new(0.2),{Position=position}):Play()
			TweenService:Create(switch,TweenInfo.new(0.2),{BackgroundColor3=state and THEME.Accent or THEME.Background}):Play()
			TweenService:Create(glow,TweenInfo.new(0.2),{Transparency=state and 0.3 or 1}):Play()
			callback(state)
		end))

		return function(newState)
			state = newState
			ball.Position = newState and UDim2.new(1,-17,0.5,-7) or UDim2.new(0,3,0.5,-7)
			switch.BackgroundColor3 = newState and THEME.Accent or THEME.Background
			glow.Transparency = newState and 0.3 or 1
		end
	end

	function Components.CreateSlider(parent,text,minimum,maximum,default,callback,comingSoon)
		if maximum <= minimum then maximum = minimum+1 end
		local container = Instance.new("Frame")
		container.Size = UDim2.new(0.95,0,0,50)
		container.BackgroundColor3 = THEME.Panel
		container.Parent = parent
		themeObject(container,"Panel")
		createCorner(container,8)
		createStroke(container,THEME.Border,1,"Border")

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0.5,0,0,25)
		label.Position = UDim2.fromOffset(12,2)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextColor3 = THEME.TextActive
		label.Font = Enum.Font.GothamMedium
		label.TextSize = 12
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = container
		themeObject(label,"ActiveText")

		local valueLabel = Instance.new("TextLabel")
		valueLabel.Size = UDim2.new(0.4,0,0,25)
		valueLabel.Position = UDim2.new(1,-122,0,2)
		valueLabel.BackgroundTransparency = 1
		valueLabel.Text = tostring(default)
		valueLabel.TextColor3 = THEME.Accent
		valueLabel.Font = Enum.Font.GothamMedium
		valueLabel.TextSize = 12
		valueLabel.TextXAlignment = Enum.TextXAlignment.Right
		valueLabel.Parent = container
		themeObject(valueLabel,"AccentText")

		local track = Instance.new("TextButton")
		track.Size = UDim2.new(0.95,-10,0,6)
		track.Position = UDim2.new(0.025,5,0.7,-3)
		track.BackgroundColor3 = THEME.Background
		track.Text = ""
		track.Parent = container
		themeObject(track,"Background")
		createCorner(track,3)

		local fill = Instance.new("Frame")
		fill.Size = UDim2.new(math.clamp((default-minimum)/(maximum-minimum),0,1),0,1,0)
		fill.BackgroundColor3 = THEME.Accent
		fill.BorderSizePixel = 0
		fill.Parent = track
		themeObject(fill,"Accent")
		createCorner(fill,3)

		if comingSoon then
			local labelCS = Instance.new("TextLabel")
			labelCS.Size = UDim2.fromOffset(30,40)
			labelCS.Position = UDim2.new(0.65,0,0,0)
			labelCS.BackgroundTransparency = 1
			labelCS.Text = "⏳"
			labelCS.TextColor3 = Color3.fromRGB(255,200,100)
			labelCS.Font = Enum.Font.GothamMedium
			labelCS.TextSize = 14
			labelCS.Parent = container
		end

		local dragging = false
		local function update(input)
			if comingSoon then return end
			local size = track.AbsoluteSize.X
			if size <= 0 then return end
			local relative = math.clamp((input.Position.X-track.AbsolutePosition.X)/size,0,1)
			fill.Size = UDim2.new(relative,0,1,0)
			local value = minimum+relative*(maximum-minimum)
			value = math.floor(value*100+0.5)/100
			valueLabel.Text = tostring(value)
			callback(value)
		end

		addConnection(track.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
				dragging = true
				update(input)
			end
		end))
		addConnection(UserInputService.InputChanged:Connect(function(input)
			if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end
		end))
		addConnection(UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end
		end))
	end

	function Components.CreateDropdown(parent,text,options,default,callback)
		local container = Instance.new("Frame")
		container.Size = UDim2.new(0.95,0,0,40)
		container.BackgroundColor3 = THEME.Panel
		container.ClipsDescendants = true
		container.Parent = parent
		themeObject(container,"Panel")
		createCorner(container,8)
		createStroke(container,THEME.Border,1,"Border")

		local button = Instance.new("TextButton")
		button.Size = UDim2.new(1,0,0,40)
		button.BackgroundTransparency = 1
		button.Text = ""
		button.Parent = container

		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(0.5,0,1,0)
		label.Position = UDim2.fromOffset(12,0)
		label.BackgroundTransparency = 1
		label.Text = text
		label.TextColor3 = THEME.TextActive
		label.Font = Enum.Font.GothamMedium
		label.TextSize = 12
		label.TextXAlignment = Enum.TextXAlignment.Left
		label.Parent = button
		themeObject(label,"ActiveText")

		local selected = Instance.new("TextLabel")
		selected.Size = UDim2.new(0.4,0,1,0)
		selected.Position = UDim2.new(1,-132,0,0)
		selected.BackgroundTransparency = 1
		selected.Text = default
		selected.TextColor3 = THEME.Accent
		selected.Font = Enum.Font.GothamMedium
		selected.TextSize = 12
		selected.TextXAlignment = Enum.TextXAlignment.Right
		selected.Parent = button
		themeObject(selected,"AccentText")

		local list = Instance.new("Frame")
		list.Size = UDim2.new(1,0,0,#options*30)
		list.Position = UDim2.fromOffset(0,40)
		list.BackgroundTransparency = 1
		list.Parent = container
		local layout = Instance.new("UIListLayout")
		layout.Parent = list
		local open = false

		for _,option in ipairs(options) do
			local optionButton = Instance.new("TextButton")
			optionButton.Size = UDim2.new(1,0,0,30)
			optionButton.BackgroundColor3 = THEME.Background
			optionButton.BackgroundTransparency = 0.5
			optionButton.BorderSizePixel = 0
			optionButton.Text = option
			optionButton.TextColor3 = THEME.TextMuted
			optionButton.Font = Enum.Font.GothamMedium
			optionButton.TextSize = 11
			optionButton.Parent = list
			themeObject(optionButton,"Background")
			addConnection(optionButton.MouseButton1Click:Connect(function()
				selected.Text = option
				callback(option)
				open = false
				TweenService:Create(container,TweenInfo.new(0.15),{Size=UDim2.new(0.95,0,0,40)}):Play()
			end))
		end

		addConnection(button.MouseButton1Click:Connect(function()
			open = not open
			local height = open and 40+(#options*30) or 40
			TweenService:Create(container,TweenInfo.new(0.15),{Size=UDim2.new(0.95,0,0,height)}):Play()
		end))
	end

	local function createTab(name,icon)
		local button = Instance.new("TextButton")
		button.Size = UDim2.new(0.9,0,0,35)
		button.BackgroundTransparency = 1
		button.BackgroundColor3 = THEME.Background
		button.Text = "  "..icon.." "..name
		button.TextColor3 = THEME.TextMuted
		button.Font = Enum.Font.GothamMedium
		button.TextSize = 12
		button.TextXAlignment = Enum.TextXAlignment.Left
		button.Parent = Sidebar
		themeObject(button,"MutedText")
		createCorner(button,8)
		addConnection(button.MouseButton1Click:Connect(function()
			for _,child in ipairs(Sidebar:GetChildren()) do
				if child:IsA("TextButton") then
					child.TextColor3 = THEME.TextMuted
					child.BackgroundTransparency = 1
				end
			end
			button.TextColor3 = THEME.TextActive
			button.BackgroundTransparency = 0.8
			button.BackgroundColor3 = THEME.AccentDim
			SettingsState.ActiveTab = name
			for tab,frame in pairs(TabFrames) do
				frame.Visible = tab == name
			end
		end))
		if SettingsState.ActiveTab == name then
			button.TextColor3 = THEME.TextActive
			button.BackgroundTransparency = 0.8
			button.BackgroundColor3 = THEME.AccentDim
		end
	end
	createTab("Aim","🎯")
	createTab("Guns","🔫")
	createTab("Visuals","👁")
	createTab("Settings","⚙")

	-- ============================================================
	-- NAME TAGS
	-- ============================================================
	local nameTagsEnabled = false
	local function destroyNameTag(player)
		local bill = _G.FXY_NameTagBillboards[player]
		if bill then pcall(function() bill:Destroy() end) end
		_G.FXY_NameTagBillboards[player] = nil
	end
	local function createNameTag(player,character)
		if not nameTagsEnabled or player == LocalPlayer or not character or player.Character ~= character then return end
		local head = character:FindFirstChild("Head")
		if not head then head = character:WaitForChild("Head",5) end
		if not head or not nameTagsEnabled or player.Character ~= character then return end
		destroyNameTag(player)
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "FXY_NameTag"
		billboard.Adornee = head
		billboard.Size = UDim2.fromOffset(180,40)
		billboard.StudsOffset = Vector3.new(0,2.8,0)
		billboard.AlwaysOnTop = true
		billboard.MaxDistance = 900
		billboard.Parent = head
		local label = Instance.new("TextLabel")
		label.Size = UDim2.new(1,0,1,0)
		label.BackgroundTransparency = 1
		label.Text = player.DisplayName
		label.TextColor3 = SettingsState.NameTagColor
		label.Font = Enum.Font.GothamBold
		label.TextSize = 15
		label.TextStrokeColor3 = Color3.new(0,0,0)
		label.TextStrokeTransparency = 0.15
		label.Parent = billboard
		_G.FXY_NameTagBillboards[player] = billboard
	end
	local function setupNameTagPlayer(player)
		if player == LocalPlayer then return end
		local addKey = "Added_"..tostring(player.UserId)
		local removeKey = "Removing_"..tostring(player.UserId)
		if not _G.FXY_NameTagConnections[addKey] then
			_G.FXY_NameTagConnections[addKey] = player.CharacterAdded:Connect(function(character)
				if nameTagsEnabled then task.spawn(function() createNameTag(player,character) end) end
			end)
		end
		if not _G.FXY_NameTagConnections[removeKey] then
			_G.FXY_NameTagConnections[removeKey] = player.CharacterRemoving:Connect(function() destroyNameTag(player) end)
		end
	end
	local function enableNameTags()
		if nameTagsEnabled then return end
		nameTagsEnabled = true
		SettingsState.NameTagsEnabled = true
		for _,player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				setupNameTagPlayer(player)
				if player.Character then task.spawn(function() createNameTag(player,player.Character) end) end
			end
		end
		_G.FXY_NameTagConnections._PlayerAdded = Players.PlayerAdded:Connect(function(player)
			setupNameTagPlayer(player)
			if player.Character then task.spawn(function() createNameTag(player,player.Character) end) end
		end)
		_G.FXY_NameTagConnections._PlayerRemoving = Players.PlayerRemoving:Connect(function(player) destroyNameTag(player) end)
	end
	local function disableNameTags()
		nameTagsEnabled = false
		SettingsState.NameTagsEnabled = false
		for player in pairs(_G.FXY_NameTagBillboards) do destroyNameTag(player) end
		cleanupDictionary(_G.FXY_NameTagConnections)
	end

	-- ============================================================
	-- HEALTH BARS
	-- ============================================================
	local healthBarsEnabled = false
	local function destroyHealthBar(player)
		local bill = _G.FXY_HealthBars[player]
		if bill then pcall(function() bill:Destroy() end) end
		_G.FXY_HealthBars[player] = nil
		_G.FXY_HealthBarData[player] = nil
		local key = "HealthChanged_"..tostring(player.UserId)
		if _G.FXY_HealthBarConnections[key] then
			safeDisconnect(_G.FXY_HealthBarConnections[key])
			_G.FXY_HealthBarConnections[key] = nil
		end
	end
	local function createHealthBar(player,character)
		if not healthBarsEnabled or player == LocalPlayer or not character or player.Character ~= character then return end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid then return end
		local adornee = character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("Head")
		if not adornee then return end
		destroyHealthBar(player)
		local billboard = Instance.new("BillboardGui")
		billboard.Name = "FXY_HealthBar"
		billboard.Adornee = adornee
		billboard.Size = UDim2.fromOffset(100,8)
		billboard.StudsOffset = Vector3.new(0,2.5,0)
		billboard.AlwaysOnTop = true
		billboard.MaxDistance = 300
		billboard.Parent = adornee
		local background = Instance.new("Frame")
		background.Size = UDim2.new(1,0,1,0)
		background.BackgroundColor3 = Color3.fromRGB(30,30,30)
		background.BorderSizePixel = 0
		background.Parent = billboard
		createCorner(background,4)
		local fill = Instance.new("Frame")
		fill.Size = UDim2.new(1,0,1,0)
		fill.BackgroundColor3 = Color3.fromRGB(0,255,0)
		fill.BorderSizePixel = 0
		fill.Parent = background
		createCorner(fill,4)
		_G.FXY_HealthBars[player] = billboard
		_G.FXY_HealthBarData[player] = { fill = fill, humanoid = humanoid }
		local function update()
			local data = _G.FXY_HealthBarData[player]
			if not data or not data.fill then return end
			if not data.humanoid or not data.humanoid.Parent then destroyHealthBar(player) return end
			local maxHealth = math.max(data.humanoid.MaxHealth,1)
			local percent = math.clamp(data.humanoid.Health/maxHealth,0,1)
			data.fill.Size = UDim2.new(percent,0,1,0)
			if percent > 0.6 then data.fill.BackgroundColor3 = Color3.fromRGB(0,255,0)
			elseif percent > 0.3 then data.fill.BackgroundColor3 = Color3.fromRGB(255,200,0)
			else data.fill.BackgroundColor3 = Color3.fromRGB(255,0,0) end
		end
		update()
		local key = "HealthChanged_"..tostring(player.UserId)
		_G.FXY_HealthBarConnections[key] = humanoid.HealthChanged:Connect(update)
	end
	local function setupHealthPlayer(player)
		if player == LocalPlayer then return end
		local addKey = "HB_Added_"..tostring(player.UserId)
		local removeKey = "HB_Removing_"..tostring(player.UserId)
		if not _G.FXY_HealthBarConnections[addKey] then
			_G.FXY_HealthBarConnections[addKey] = player.CharacterAdded:Connect(function(character)
				if healthBarsEnabled then
					task.spawn(function()
						local humanoid = character:FindFirstChildOfClass("Humanoid")
						if not humanoid then humanoid = character:WaitForChild("Humanoid",5) end
						if humanoid and healthBarsEnabled and player.Character == character then
							createHealthBar(player,character)
						end
					end)
				end
			end)
		end
		if not _G.FXY_HealthBarConnections[removeKey] then
			_G.FXY_HealthBarConnections[removeKey] = player.CharacterRemoving:Connect(function() destroyHealthBar(player) end)
		end
	end
	local function enableHealthBars()
		if healthBarsEnabled then return end
		healthBarsEnabled = true
		SettingsState.HealthBarsEnabled = true
		for _,player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				setupHealthPlayer(player)
				if player.Character then createHealthBar(player,player.Character) end
			end
		end
		_G.FXY_HealthBarConnections._PlayerAdded = Players.PlayerAdded:Connect(function(player)
			setupHealthPlayer(player)
			if player.Character then createHealthBar(player,player.Character) end
		end)
		_G.FXY_HealthBarConnections._PlayerRemoving = Players.PlayerRemoving:Connect(function(player) destroyHealthBar(player) end)
	end
	local function disableHealthBars()
		healthBarsEnabled = false
		SettingsState.HealthBarsEnabled = false
		for player in pairs(_G.FXY_HealthBars) do destroyHealthBar(player) end
		cleanupDictionary(_G.FXY_HealthBarConnections)
	end

	-- ============================================================
	-- ESP BOXES
	-- ============================================================
	local espEnabled = false
	local espConnection
	local function destroyESP(player)
		local data = _G.FXY_ESPBoxes[player]
		if data and data.frame then pcall(function() data.frame:Destroy() end) end
		_G.FXY_ESPBoxes[player] = nil
		_G.FXY_ESPBoxData[player] = nil
	end
	local function createESP(player,character)
		if not espEnabled or player == LocalPlayer or not character or player.Character ~= character then return end
		destroyESP(player)
		local frame = Instance.new("Frame")
		frame.Name = "FXY_ESPBox"
		frame.BackgroundTransparency = 1
		frame.BorderSizePixel = 0
		frame.Visible = false
		frame.Parent = ScreenGui
		local stroke = createStroke(frame,SettingsState.ESPColor,2)
		_G.FXY_ESPBoxes[player] = { frame = frame, character = character, stroke = stroke }
	end
	local function getBounds(character,camera)
		local minX = math.huge
		local maxX = -math.huge
		local minY = math.huge
		local maxY = -math.huge
		local found = false
		for _,part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") and not part:FindFirstAncestorOfClass("Accessory") then
				local half = part.Size/2
				local corners = {
					Vector3.new(-half.X,-half.Y,-half.Z),
					Vector3.new(-half.X,-half.Y,half.Z),
					Vector3.new(-half.X,half.Y,-half.Z),
					Vector3.new(-half.X,half.Y,half.Z),
					Vector3.new(half.X,-half.Y,-half.Z),
					Vector3.new(half.X,-half.Y,half.Z),
					Vector3.new(half.X,half.Y,-half.Z),
					Vector3.new(half.X,half.Y,half.Z)
				}
				for _,corner in ipairs(corners) do
					local point = part.CFrame:PointToWorldSpace(corner)
					local screen = camera:WorldToViewportPoint(point)
					if screen.Z > 0 then
						minX = math.min(minX,screen.X)
						maxX = math.max(maxX,screen.X)
						minY = math.min(minY,screen.Y)
						maxY = math.max(maxY,screen.Y)
						found = true
					end
				end
			end
		end
		if not found then return nil end
		return minX,maxX,minY,maxY
	end
	local function updateESP()
		if not espEnabled then return end
		local camera = workspace.CurrentCamera
		if not camera then return end
		local viewport = camera.ViewportSize
		for player,data in pairs(_G.FXY_ESPBoxes) do
			if not player or not data or not data.frame then
				if player then destroyESP(player) end
			elseif player.Character ~= data.character then
				destroyESP(player)
			else
				local humanoid = data.character:FindFirstChildOfClass("Humanoid")
				if not humanoid or humanoid.Health <= 0 then
					data.frame.Visible = false
				else
					local a,b,c,d = getBounds(data.character,camera)
					if not a then
						data.frame.Visible = false
					else
						a = math.clamp(a,0,viewport.X)
						b = math.clamp(b,0,viewport.X)
						c = math.clamp(c,0,viewport.Y)
						d = math.clamp(d,0,viewport.Y)
						local width = b-a
						local height = d-c
						if width <= 2 or height <= 2 then
							data.frame.Visible = false
						else
							data.frame.Position = UDim2.fromOffset(math.floor(a),math.floor(c))
							data.frame.Size = UDim2.fromOffset(math.ceil(width),math.ceil(height))
							data.frame.Visible = true
							data.stroke.Color = SettingsState.ESPColor
						end
					end
				end
			end
		end
	end
	local function startESP()
		if espConnection then return end
		espConnection = RunService.RenderStepped:Connect(function()
			SettingsState.espFrameCounter = SettingsState.espFrameCounter+1
			if SettingsState.espFrameCounter % SettingsState.UpdateInterval == 0 then updateESP() end
		end)
		_G.FXY_ESPBoxConnections["_Render"] = espConnection
	end
	local function stopESP()
		if espConnection then
			safeDisconnect(espConnection)
			_G.FXY_ESPBoxConnections["_Render"] = nil
			espConnection = nil
		end
	end
	local function enableESP()
		if espEnabled then return end
		espEnabled = true
		SettingsState.ESPBoxesEnabled = true
		for _,player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				if player.Character then createESP(player,player.Character) end
				local addKey = "ESP_Added_"..tostring(player.UserId)
				local removeKey = "ESP_Removing_"..tostring(player.UserId)
				if not _G.FXY_ESPBoxConnections[addKey] then
					_G.FXY_ESPBoxConnections[addKey] = player.CharacterAdded:Connect(function(character) createESP(player,character) end)
				end
				if not _G.FXY_ESPBoxConnections[removeKey] then
					_G.FXY_ESPBoxConnections[removeKey] = player.CharacterRemoving:Connect(function() destroyESP(player) end)
				end
			end
		end
		startESP()
	end
	local function disableESP()
		espEnabled = false
		SettingsState.ESPBoxesEnabled = false
		for player in pairs(_G.FXY_ESPBoxes) do destroyESP(player) end
		stopESP()
		cleanupDictionary(_G.FXY_ESPBoxConnections)
	end

	-- ============================================================
	-- TRACERS
	-- ============================================================
	local tracersEnabled = false
	local tracerConnection
	local function destroyTracer(player)
		local data = _G.FXY_Tracers[player]
		if data and data.line then pcall(function() data.line:Destroy() end) end
		_G.FXY_Tracers[player] = nil
	end
	local function createTracer(player)
		if not tracersEnabled or player == LocalPlayer then return end
		local character = player.Character
		if not character then return end
		destroyTracer(player)
		local line = Instance.new("Frame")
		line.Name = "FXY_Tracer"
		line.BackgroundColor3 = SettingsState.TracerColor
		line.BorderSizePixel = 0
		line.AnchorPoint = Vector2.new(0.5,0.5)
		line.Size = UDim2.fromOffset(0,2)
		line.Visible = false
		line.ZIndex = 2
		line.Parent = ScreenGui
		_G.FXY_Tracers[player] = { line = line, character = character }
	end
	local function updateTracerLine(line,fromPos,toPos)
		local delta = toPos-fromPos
		local length = delta.Magnitude
		if length <= 1 then line.Visible = false return end
		local midpoint = (fromPos+toPos)/2
		line.Position = UDim2.fromOffset(midpoint.X,midpoint.Y)
		line.Size = UDim2.fromOffset(length,2)
		line.Rotation = math.deg(math.atan2(delta.Y,delta.X))
		line.Visible = true
	end
	local function updateTracers()
		if not tracersEnabled then return end
		local camera = workspace.CurrentCamera
		if not camera then return end
		local viewport = camera.ViewportSize
		local startPos = Vector2.new(viewport.X/2,viewport.Y)
		for player,data in pairs(_G.FXY_Tracers) do
			if not data or not data.line then
				if player then destroyTracer(player) end
			elseif player.Character ~= data.character then
				destroyTracer(player)
			else
				local humanoid = data.character:FindFirstChildOfClass("Humanoid")
				if not humanoid or humanoid.Health <= 0 then
					data.line.Visible = false
				else
					local a,b,c,d = getBounds(data.character,camera)
					if not a then
						data.line.Visible = false
					else
						a = math.clamp(a,0,viewport.X)
						b = math.clamp(b,0,viewport.X)
						c = math.clamp(c,0,viewport.Y)
						d = math.clamp(d,0,viewport.Y)
						local target = Vector2.new((a+b)/2,d)
						data.line.BackgroundColor3 = SettingsState.TracerColor
						updateTracerLine(data.line,startPos,target)
					end
				end
			end
		end
	end
	local function startTracers()
		if tracerConnection then return end
		tracerConnection = RunService.RenderStepped:Connect(function()
			SettingsState.tracerFrameCounter = SettingsState.tracerFrameCounter+1
			if SettingsState.tracerFrameCounter % SettingsState.UpdateInterval == 0 then updateTracers() end
		end)
		_G.FXY_TracerConnections["_Render"] = tracerConnection
	end
	local function stopTracers()
		if tracerConnection then
			safeDisconnect(tracerConnection)
			_G.FXY_TracerConnections["_Render"] = nil
			tracerConnection = nil
		end
	end
	local function enableTracers()
		if tracersEnabled then return end
		tracersEnabled = true
		SettingsState.TracersEnabled = true
		for _,player in ipairs(Players:GetPlayers()) do
			if player ~= LocalPlayer then
				createTracer(player)
				local addKey = "Tracer_Added_"..tostring(player.UserId)
				local removeKey = "Tracer_Removing_"..tostring(player.UserId)
				if not _G.FXY_TracerConnections[addKey] then
					_G.FXY_TracerConnections[addKey] = player.CharacterAdded:Connect(function() createTracer(player) end)
				end
				if not _G.FXY_TracerConnections[removeKey] then
					_G.FXY_TracerConnections[removeKey] = player.CharacterRemoving:Connect(function() destroyTracer(player) end)
				end
			end
		end
		startTracers()
	end
	local function disableTracers()
		tracersEnabled = false
		SettingsState.TracersEnabled = false
		for player in pairs(_G.FXY_Tracers) do destroyTracer(player) end
		stopTracers()
		cleanupDictionary(_G.FXY_TracerConnections)
	end

	-- ============================================================
	-- COLORS
	-- ============================================================
	local PRESET_COLORS = {
		White = Color3.fromRGB(255,255,255),
		Red = Color3.fromRGB(255,0,0),
		Green = Color3.fromRGB(0,255,0),
		Blue = Color3.fromRGB(0,0,255),
		Yellow = Color3.fromRGB(255,255,0),
		Purple = Color3.fromRGB(255,0,255),
		Orange = Color3.fromRGB(255,165,0),
		Cyan = Color3.fromRGB(0,255,255)
	}
	local colorNames = {"White","Red","Green","Blue","Yellow","Purple","Orange","Cyan"}

	-- ============================================================
	-- RAPID FIRE
	-- ============================================================
	local rapidFireConnection = nil
	local lastRapidFireTick = 0
	local function doRapidFireActivate()
		local char = LocalPlayer.Character
		if not char then return end
		local tool = char:FindFirstChildOfClass("Tool")
		if tool then pcall(function() tool:Activate() end) end
	end
	local function startRapidFire()
		if rapidFireConnection then return end
		rapidFireConnection = RunService.RenderStepped:Connect(function()
			if not SettingsState.RapidFire then return end
			local delay = SettingsState.RapidFireDelay
			if delay <= 0.05 then
				doRapidFireActivate()
				doRapidFireActivate()
				doRapidFireActivate()
				return
			end
			local now = os.clock()
			if (now - lastRapidFireTick) < delay then return end
			lastRapidFireTick = now
			doRapidFireActivate()
		end)
	end
	local function stopRapidFire()
		if rapidFireConnection then
			rapidFireConnection:Disconnect()
			rapidFireConnection = nil
		end
	end

	-- ============================================================
	-- TRIGGER BOT (NEW)
	-- ============================================================
	local lastTriggerTick = 0
	local triggerBotConnection = nil
	local function startTriggerBot()
		if triggerBotConnection then return end
		triggerBotConnection = RunService.RenderStepped:Connect(function()
			if not SettingsState.TriggerBotEnabled then return end
			local now = os.clock()
			if (now - lastTriggerTick) < SettingsState.TriggerBotDelay then return end

			local camera = workspace.CurrentCamera
			local char = LocalPlayer.Character
			if not camera or not char then return end

			-- Raycast from crosshair center
			local ray = camera:ViewportPointToRay(camera.ViewportSize.X/2, camera.ViewportSize.Y/2)
			local params = RaycastParams.new()
			params.FilterType = Enum.RaycastFilterType.Exclude
			params.FilterDescendantsInstances = {char}
			local hit = workspace:Raycast(ray.Origin, ray.Direction * 1000, params)

			if hit then
				local hitModel = hit.Instance:FindFirstAncestorOfClass("Model")
				if hitModel then
					local hitPlayer = Players:GetPlayerFromCharacter(hitModel)
					if hitPlayer and hitPlayer ~= LocalPlayer then
						local tool = char:FindFirstChildOfClass("Tool")
						if tool then
							lastTriggerTick = now
							pcall(function() tool:Activate() end)
						end
					end
				end
			end
		end)
	end
	local function stopTriggerBot()
		if triggerBotConnection then
			triggerBotConnection:Disconnect()
			triggerBotConnection = nil
		end
	end

	-- ============================================================
	-- RAPID FIRE BUTTON
	-- ============================================================
	local rapidFireToggleSetter = nil
	local rapidFireBtn = Instance.new("TextButton")
	rapidFireBtn.Name = "RapidFireBtn"
	rapidFireBtn.Size = UDim2.fromOffset(55,55)
	rapidFireBtn.Position = UDim2.new(0.02,0,0.28,0)
	rapidFireBtn.BackgroundColor3 = THEME.Background
	rapidFireBtn.Text = "RF"
	rapidFireBtn.TextColor3 = THEME.TextActive
	rapidFireBtn.Font = Enum.Font.GothamBold
	rapidFireBtn.TextSize = 18
	rapidFireBtn.Parent = ScreenGui
	themeObject(rapidFireBtn,"Background")
	createCorner(rapidFireBtn,28)
	createStroke(rapidFireBtn,THEME.Accent,2,"AccentStroke")

	addConnection(rapidFireBtn.MouseButton1Click:Connect(function()
		local newState = not SettingsState.RapidFire
		SettingsState.RapidFire = newState
		if newState then
			startRapidFire()
			rapidFireBtn.BackgroundColor3 = THEME.Accent
		else
			stopRapidFire()
			rapidFireBtn.BackgroundColor3 = THEME.Background
		end
		if rapidFireToggleSetter then rapidFireToggleSetter(newState) end
	end))

	-- ============================================================
	-- POPULATE AIM TAB
	-- ============================================================
	Components.CreateSection(aimTab,"Camera Target Settings")
	camlockToggleSetter = Components.CreateToggle(aimTab,"Authorized Camera Lock-On",false,function(state) toggleLock(state) end)
	Components.CreateDropdown(aimTab,"Camera Target Part",{"HumanoidRootPart","Head","UpperTorso"},"HumanoidRootPart",function(value) SettingsState.LockPart = value end)
	Components.CreateSlider(aimTab,"Horizontal Offset",0,1,0.15,function(value) SettingsState.PredictionHorizontal = value end)
	Components.CreateSlider(aimTab,"Vertical Offset",0,1,0.15,function(value) SettingsState.PredictionVertical = value end)

	Components.CreateSection(aimTab,"Trigger Bot")
	Components.CreateToggle(aimTab,"Enable Trigger Bot",false,function(state)
		SettingsState.TriggerBotEnabled = state
		if state then
			startTriggerBot()
		else
			stopTriggerBot()
		end
	end)
	Components.CreateSlider(aimTab,"Trigger Delay (ms)",0,500,50,function(value)
		SettingsState.TriggerBotDelay = value / 1000
	end)
	Components.CreateSection(aimTab,"Simulated Features")
	Components.CreateToggle(aimTab,"Silent Target Calculation",false,function() end,true)
	rapidFireToggleSetter = Components.CreateToggle(aimTab,"Rapid Fire",false,function(state)
		SettingsState.RapidFire = state
		if state then startRapidFire() else stopRapidFire() end
		if rapidFireBtn then rapidFireBtn.BackgroundColor3 = state and THEME.Accent or THEME.Background end
	end)
	Components.CreateSlider(aimTab,"Rapid Fire Pulse (Seconds)",0.05,1,0.05,function(value) SettingsState.RapidFireDelay = value end)

	-- ============================================================
	-- POPULATE GUNS TAB
	-- ============================================================
	Components.CreateSection(gunsTab,"Weapon Mods")
	Components.CreateToggle(gunsTab,"No Recoil",false,function() end,true)
	Components.CreateToggle(gunsTab,"No Spread",false,function() end,true)
	Components.CreateToggle(gunsTab,"Instant Reload",false,function() end,true)
	Components.CreateSlider(gunsTab,"Fire Rate Multiplier",1,5,1,function() end,true)

	-- ============================================================
	-- POPULATE VISUALS TAB
	-- ============================================================
	Components.CreateSection(visualsTab,"Visual Enhancements")
	Components.CreateToggle(visualsTab,"ESP Boxes",false,function(state) if state then enableESP() else disableESP() end end)
	Components.CreateToggle(visualsTab,"Name Tags",false,function(state) if state then enableNameTags() else disableNameTags() end end)
	Components.CreateToggle(visualsTab,"Health Bars",false,function(state) if state then enableHealthBars() else disableHealthBars() end end)
	Components.CreateToggle(visualsTab,"Tracers",false,function(state) if state then enableTracers() else disableTracers() end end)
	Components.CreateSection(visualsTab,"Custom Colors")
	Components.CreateDropdown(visualsTab,"ESP Box Color",colorNames,"White",function(value)
		SettingsState.ESPColor = PRESET_COLORS[value]
		for _,data in pairs(_G.FXY_ESPBoxes) do
			if data and data.stroke then data.stroke.Color = SettingsState.ESPColor end
		end
	end)
	Components.CreateDropdown(visualsTab,"Tracer Color",colorNames,"White",function(value)
		SettingsState.TracerColor = PRESET_COLORS[value]
		for _,data in pairs(_G.FXY_Tracers) do
			if data and data.line then data.line.BackgroundColor3 = SettingsState.TracerColor end
		end
	end)
	Components.CreateDropdown(visualsTab,"Name Tag Color",colorNames,"White",function(value)
		SettingsState.NameTagColor = PRESET_COLORS[value]
		for _,bill in pairs(_G.FXY_NameTagBillboards) do
			local label = bill:FindFirstChildOfClass("TextLabel")
			if label then label.TextColor3 = SettingsState.NameTagColor end
		end
	end)

	-- ============================================================
	-- POPULATE SETTINGS TAB
	-- ============================================================
	Components.CreateSection(settingsTab,"Interface Settings")
	Components.CreateToggle(settingsTab,"Show FPS",false,function(state) fpsLabel.Visible = state end)
	Components.CreateToggle(settingsTab,"Show Watermark",false,function(state) watermarkLabel.Visible = state end)
	Components.CreateDropdown(settingsTab,"GUI Theme",GUI_THEME_NAMES,"Purple",function(value)
		applyGUITheme(value)
		for _,child in ipairs(Sidebar:GetChildren()) do
			if child:IsA("TextButton") then
				child.TextColor3 = THEME.TextMuted
				child.BackgroundTransparency = 1
			end
		end
		for _,child in ipairs(Sidebar:GetChildren()) do
			if child:IsA("TextButton") and child.Text:find(SettingsState.ActiveTab) then
				child.TextColor3 = THEME.TextActive
				child.BackgroundTransparency = 0.8
				child.BackgroundColor3 = THEME.AccentDim
			end
		end
		if SettingsState.RapidFire then rapidFireBtn.BackgroundColor3 = THEME.Accent end
	end)

	-- ============================================================
	-- CAMERA LOCK LOOP
	-- ============================================================
	local LERP_SPEED = 0.95
	addConnection(RunService.RenderStepped:Connect(function()
		local camera = workspace.CurrentCamera
		if not camera then return end
		if SettingsState.CameraLockEnabled and SettingsState.CurrentTarget then
			local target = SettingsState.CurrentTarget
			if not target.Parent then toggleLock(false); return end
			local humanoid = target:FindFirstChildOfClass("Humanoid")
			if not humanoid or humanoid.Health <= 0 then toggleLock(false); return end
			local targetPlayer = Players:GetPlayerFromCharacter(target)
			if targetPlayer then
				targetNameLabel.Text = targetPlayer.DisplayName
				startGlow()
			else
				targetNameLabel.Text = "Unknown"
				startGlow()
			end
			local targetPart = target:FindFirstChild(SettingsState.LockPart)
			if targetPart then
				local offset = Vector3.new(
					SettingsState.PredictionHorizontal * 0.5,
					SettingsState.PredictionVertical * 0.5,
					0
				)
				local targetPosition = targetPart.Position + offset
				local targetCFrame = CFrame.new(camera.CFrame.Position, targetPosition)
				camera.CFrame = camera.CFrame:Lerp(targetCFrame, LERP_SPEED)
			end
		else
			if targetNameLabel.Text ~= "" then
				targetNameLabel.Text = ""
				stopGlow()
			end
		end
	end))

	-- ============================================================
	-- INITIAL STATE
	-- ============================================================
	SettingsState.CameraLockEnabled = false
	SettingsState.CurrentTarget = nil
	SettingsState.TriggerBotEnabled = false
	MainFrame.Visible = true
	menuOpen = true

	print("FXY: Main initialization complete")
end)

if ok then
	print("FXY: LOADED SUCCESSFULLY")
else
	warn("FXY: LOAD FAILED")
	warn("FXY: Error: "..tostring(err))
	if typeof(debug) == "table" and type(debug.traceback) == "function" then
		warn("FXY: "..debug.traceback(tostring(err),2))
	end
end