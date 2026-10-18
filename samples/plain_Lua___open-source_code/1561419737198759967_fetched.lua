if not LPH_OBFUSCATED then
	LPH_NO_VIRTUALIZE = function(callback)
	return callback
	end
	end

	;LPH_NO_VIRTUALIZE(function()

	do
	local scriptEnv = _G
	pcall(function()
	if type(getfenv) == "function" then scriptEnv = getfenv(0) end
	end)
	local sharedEnv = scriptEnv
	pcall(function()
	if type(getgenv) == "function" then sharedEnv = getgenv() end
	end)
	if type(scriptEnv) ~= "table" then scriptEnv = _G end
	if type(sharedEnv) ~= "table" then sharedEnv = scriptEnv end

	local hiddenSetter = rawget(scriptEnv, "sethiddenproperty")
	or rawget(sharedEnv, "sethiddenproperty")
	or rawget(scriptEnv, "set_hidden_property")
	or rawget(sharedEnv, "set_hidden_property")
	or rawget(scriptEnv, "sethiddenprop")
	or rawget(sharedEnv, "sethiddenprop")
	local synApi = rawget(scriptEnv, "syn") or rawget(sharedEnv, "syn")
	if type(hiddenSetter) ~= "function" and type(synApi) == "table" then
	hiddenSetter = rawget(synApi, "sethiddenproperty") or rawget(synApi, "set_hidden_property")
	end
	if type(hiddenSetter) == "function" then
	pcall(function() rawset(scriptEnv, "sethiddenproperty", hiddenSetter) end)
	pcall(function() rawset(sharedEnv, "sethiddenproperty", hiddenSetter) end)
	end

	local fpsCapSetter = rawget(scriptEnv, "setfpscap")
	or rawget(sharedEnv, "setfpscap")
	or rawget(scriptEnv, "set_fps_cap")
	or rawget(sharedEnv, "set_fps_cap")
	or rawget(scriptEnv, "setfpslimit")
	or rawget(sharedEnv, "setfpslimit")
	if type(fpsCapSetter) ~= "function" and type(synApi) == "table" then
	fpsCapSetter = rawget(synApi, "setfpscap") or rawget(synApi, "set_fps_cap")
	end
	if type(fpsCapSetter) == "function" then pcall(fpsCapSetter, 9999) end
	end

	local Players, UserInputService, TweenService, RunService, ReplicatedStorage,
	Lighting, HttpService, Player, isMobile = (function()
	local players = game:GetService("Players")
	local input = game:GetService("UserInputService")

	local mobile = input.TouchEnabled
	pcall(function()
	local platform = input:GetPlatform()
	mobile = input.TouchEnabled and (
	platform == Enum.Platform.Android
	or platform == Enum.Platform.IOS
	or not input.MouseEnabled
	)
	end)

	return players,
	input,
	game:GetService("TweenService"),
	game:GetService("RunService"),
	game:GetService("ReplicatedStorage"),
	game:GetService("Lighting"),
	game:GetService("HttpService"),
	players.LocalPlayer,
	mobile
	end)()

	local executorName = "unknown"
	do
	local executorEnv = _G
	pcall(function()
	if type(getgenv) == "function" then executorEnv = getgenv() end
	end)
	if type(executorEnv) ~= "table" then executorEnv = _G end
	local identify = rawget(executorEnv, "identifyexecutor")
	or rawget(executorEnv, "getexecutorname")
	or (type(_G) == "table" and (rawget(_G, "identifyexecutor") or rawget(_G, "getexecutorname")))
	if type(identify) == "function" then
	pcall(function()
	local name = identify()
	if name ~= nil then executorName = tostring(name) end
	end)
	end
	end
	local waveSafeMode = string.find(string.lower(executorName), "wave", 1, true) ~= nil
	_G.__CrystalWaveSafeMode = waveSafeMode

	do
	local guiRootNames = {
	"Eclipse_Panel", "EclipseHub", "CRYSTAL_Panel", "VyloHub", "DashEffectGui", "CrystalAutoGrabBar", "VyloStealBar", "VyloTopStatus", "KYejuTopStatus",
	"CrystalLaggerGUI", "CrystalMobileUI",
	"CrystalEnemyWidget",
	}

	pcall(function()
	local oldLagger = _G.CrystalLagger
	if oldLagger then
	if oldLagger.Stop then
	oldLagger.Stop()
	else
	if oldLagger.SetEnabled then oldLagger.SetEnabled(false) end
	if oldLagger.SetLowEndEnabled then oldLagger.SetLowEndEnabled(false) end
	end
	end
	end)
	if _G.__CRYSTAL_STATE then
	_G.__CRYSTAL_STATE.alive = false
	pcall(function()
	for _, stopper in ipairs(_G.__CRYSTAL_STATE.stoppers or {}) do pcall(stopper) end
	for _, conn in ipairs(_G.__CRYSTAL_STATE.conns or {}) do pcall(function() conn:Disconnect() end) end
	end)
	end
	_G.__CRYSTAL_STATE = nil
	_G.__CrystalTrackConn = nil
	_G.__CrystalTrackStopper = nil

	pcall(function()
	if _G.__speedBoostConn then _G.__speedBoostConn:Disconnect(); _G.__speedBoostConn = nil end
	end)
	pcall(function() if _G.__stopSpeedBoost then _G.__stopSpeedBoost() end end)

	pcall(function()
	game:GetService("NetworkClient"):SetOutgoingKBPSLimit(math.huge)
	end)

	pcall(function()
	local coreGui = game:GetService("CoreGui")
	for _, container in ipairs({ coreGui, Player.PlayerGui }) do
	for _, name in ipairs(guiRootNames) do
	while true do
	local found = container:FindFirstChild(name)
	if not found then break end
	found:Destroy()
	end
	end
	end
	end)

	pcall(function()
	for _, plr in ipairs(Players:GetPlayers()) do
	local ch = plr.Character
	if ch then
	for _, part in ipairs(ch:GetChildren()) do
	for _, child in ipairs(part:GetChildren()) do
	if child.Name == "GreenDuelsBB" or child.Name == "CrystalSpeedBill" or child.Name == "CrystalHubOverhead"
	or child.Name == "CrystalAimbotBodyLock" or child.Name == "CrystalAimbotBodyAttachment"
	or child.Name == "CrystalTPBatMarkerBodyLock" or child.Name == "CrystalTPBatMarkerAttachment" then
	child:Destroy()
	end
	end
	end
	end
	end
	end)

	_G.__CRYSTAL_STATE = { conns = {}, stoppers = {}, alive = true }
	_G.__CrystalTrackConn = function(conn)
	if conn then table.insert(_G.__CRYSTAL_STATE.conns, conn) end
	return conn
	end
	_G.__CrystalTrackStopper = function(fn)
	if fn then table.insert(_G.__CRYSTAL_STATE.stoppers, fn) end
	end
	_G.__CrystalResetHooks = {}
	_G.__CrystalOnNewInstance = function(fn)
	if fn then table.insert(_G.__CrystalResetHooks, fn) end
	end
	end
	local crystalRuntimeState = _G.__CRYSTAL_STATE

	do
	local traversalJobs = {}
	local traversalConnection = nil
	local function ensureTraversalRunner()
	if traversalConnection then return end
	traversalConnection = RunService.Heartbeat:Connect(function()
	local deadline = os.clock() + 0.0008
	while traversalJobs[1] and os.clock() < deadline do
	local job = traversalJobs[1]
	if job.cancelled or (job.continue and not job.continue()) then
	table.remove(traversalJobs, 1)
	else
	local object = job.pending[#job.pending]
	if not object then
	table.remove(traversalJobs, 1)
	else
	job.pending[#job.pending] = nil
	pcall(job.apply, object)
	local ok, children = pcall(function() return object:GetChildren() end)
	if ok then
	for _, child in ipairs(children) do job.pending[#job.pending + 1] = child end
	end

	if traversalJobs[2] then
	table.remove(traversalJobs, 1)
	traversalJobs[#traversalJobs + 1] = job
	end
	end
	end
	end
	if not traversalJobs[1] then
	traversalConnection:Disconnect()
	traversalConnection = nil
	end
	end)
	_G.__CrystalTrackConn(traversalConnection)
	end
	_G.__CrystalWalkDescendantsBatched = function(roots, apply, shouldContinue)
	local job = { pending = {}, apply = apply, continue = shouldContinue, cancelled = false }
	if typeof(roots) == "Instance" then roots = { roots } end
	for _, root in ipairs(roots or {}) do
	if root then
	local ok, children = pcall(function() return root:GetChildren() end)
	if ok then for _, child in ipairs(children) do job.pending[#job.pending + 1] = child end end
	end
	end
	traversalJobs[#traversalJobs + 1] = job
	ensureTraversalRunner()
	return function() job.cancelled = true end
	end
	_G.__CrystalTrackStopper(function()
	for _, job in ipairs(traversalJobs) do job.cancelled = true end
	traversalJobs = {}
	if traversalConnection then traversalConnection:Disconnect(); traversalConnection = nil end
	end)
	end
	local CONFIG_FILE = "CrystalHub_UI_Config.txt"

	do

	local antiDieEnabled = false
	local antiDieStopped = false
	_G.__CrystalAntiDieGuiEnabled = nil
	local antiDieCharConns = {}
	local antiDieCharAddedConn = nil

	local function clearCharEntry(char, restore)
	local entry = antiDieCharConns[char]
	if entry then
	if entry.healthConn then pcall(function() entry.healthConn:Disconnect() end) end
	if entry.diedConn then pcall(function() entry.diedConn:Disconnect() end) end
	if entry.cleanupConn then pcall(function() entry.cleanupConn:Disconnect() end) end
	antiDieCharConns[char] = nil
	end
	if restore and char and char.Parent then
	pcall(function()
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
	hum.BreakJointsOnDeath = true
	hum:SetStateEnabled(Enum.HumanoidStateType.Dead, true)
	end
	end)
	end
	end

	local function applyAntiDieToCharacter(char)
	if not char or not char.Parent then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end

	clearCharEntry(char, false)

	hum.BreakJointsOnDeath = false
	hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)

	local entry = { humanoid = hum }
	entry.healthConn = hum:GetPropertyChangedSignal("Health"):Connect(function()
	if antiDieEnabled and antiDieCharConns[char] == entry and hum.Health <= 0 then
	hum.Health = hum.MaxHealth
	end
	end)

	entry.diedConn = hum.Died:Connect(function()
	task.defer(function()
	if antiDieEnabled and antiDieCharConns[char] == entry and hum and hum.Parent then
	hum.BreakJointsOnDeath = false
	hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	hum.Health = hum.MaxHealth
	end
	end)
	end)

	entry.cleanupConn = char.AncestryChanged:Connect(function()
	if not char.Parent then
	clearCharEntry(char, false)
	end
	end)

	antiDieCharConns[char] = entry
	end

	local function setAntiDieEnabled(enabled)
	enabled = enabled == true
	if enabled == antiDieEnabled then return end
	antiDieEnabled = enabled
	if enabled then
	if not antiDieCharAddedConn then
	antiDieCharAddedConn = Player.CharacterAdded:Connect(function(char)
	task.wait(0.2)
	if antiDieEnabled and char and char.Parent then
	applyAntiDieToCharacter(char)
	end
	end)
	end
	local char = Player.Character
	if char and char.Parent and not antiDieCharConns[char] then
	applyAntiDieToCharacter(char)
	end
	else
	for char in pairs(antiDieCharConns) do
	clearCharEntry(char, true)
	end
	end
	end

	local antiDieSources = { toggle = false, autobat = false }
	local function refreshAntiDie()
	if antiDieStopped then return end
	local manual = antiDieSources.toggle
	if _G.__CrystalAntiDieGuiEnabled then manual = _G.__CrystalAntiDieGuiEnabled() == true end
	setAntiDieEnabled(manual or antiDieSources.autobat)
	end

	_G.__CrystalAntiDieSource = function(source, enabled)
	if antiDieStopped or antiDieSources[source] == nil then return end
	antiDieSources[source] = enabled == true
	refreshAntiDie()
	end

	_G.__CrystalAntiDieSet = function(enabled)
	_G.__CrystalAntiDieSource("autobat", enabled)
	end

	_G.__CrystalAntiDieIsEnabled = function() return antiDieEnabled end

	_G.__CrystalTrackStopper(function()
	antiDieStopped = true
	antiDieSources.toggle = false
	antiDieSources.autobat = false
	setAntiDieEnabled(false)
	end)
	local antiDieCharAddedTracked = false
	local _antiDieOrigSet = setAntiDieEnabled
	setAntiDieEnabled = function(enabled)
	_antiDieOrigSet(enabled)
	if antiDieCharAddedConn and not antiDieCharAddedTracked then
	antiDieCharAddedTracked = true
	_G.__CrystalTrackConn(antiDieCharAddedConn)
	end
	end
	_G.__CrystalTrackConn(RunService.Heartbeat:Connect(function()
	if antiDieStopped then return end
	refreshAntiDie()
	if not antiDieEnabled then return end
	local char = Player.Character
	local hum = char and char.Parent and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	local entry = antiDieCharConns[char]

	if not entry or entry.humanoid ~= hum then applyAntiDieToCharacter(char) end
	if hum.BreakJointsOnDeath then hum.BreakJointsOnDeath = false end
	if hum:GetStateEnabled(Enum.HumanoidStateType.Dead) then
	hum:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
	end
	if hum.Health <= 0 then hum.Health = hum.MaxHealth end
	end))
	end

	FeatureToggles = FeatureToggles or {}

	local toggleStates = {}
	local transientToggles = {
	["Aimbot"] = true,
	["Autoplay"] = true,
	["Auto Left"] = true,
	["Auto Right"] = true,
	["Lagger"] = true,
	}
	local mobileFeatures = {
	["Aimbot"] = true,
	["Drop"] = true,
	["TP Down"] = true,
	["Auto Left"] = true,
	["Auto Right"] = true,
	["ESP Players"] = true,
	["Player Tracers"] = true,
	}
	local mobileShortcutStates = {}
	local mobileBtnPlaced = {}
	for featName, _ in pairs(mobileFeatures) do
	mobileShortcutStates[featName] = false
	mobileBtnPlaced[featName] = true
	end

	local speedValues = {
	NormalBoost = 59,
	NormalSteal = 29,
	LaggerBoost = 40,
	LaggerSteal = 20,
	DesyncBoost = 59,
	DesyncSteal = 29,
	MobileButtonScale = 1.0,
	FOV = 90,
	StretchIntensity = 0.75,
	CypherAimbotApproachSpeed = 59,
	AimbotSpeed = 59,
	AimbotSpeedLagger = 40,
	AimbotSpeedCustom = 59,
	AutoTPDownHeight = 20,
	BodyLockRange = 15,
	}
	local customSpeeds = {}
	local autoStealValues = {
	Radius      = 65,
	Duration    = 1.3,
	}
	local autoStealMode = "v1"
	local selectedMode = "Normal"
	local violetteSkinMode = "1"
	local selectedIntroMusicIndex = 1
	local normalSpeed = 59
	local carrySpeed = 30
	local laggerSpeed = 40
	local speedToggled = false
	local carrySpeedMode = "v2"
	local laggerEnabled = false
	local lastMoveDir = Vector3.new(0, 0, 0)
	local MOVE_KEYS = {
	[Enum.KeyCode.W] = true, [Enum.KeyCode.A] = true, [Enum.KeyCode.S] = true, [Enum.KeyCode.D] = true,
	[Enum.KeyCode.Up] = true, [Enum.KeyCode.Left] = true, [Enum.KeyCode.Down] = true, [Enum.KeyCode.Right] = true,
	}
	local _prevSpeed = false
	local FeatureKeybinds = {
	SelectNormalMode = nil,
	SelectLaggerMode = nil,
	Drop = nil,
	["Auto Left"] = nil,
	["Auto Right"] = nil,
	["Toggle UI"] = nil,
	["Speed Boost"] = nil,
	["Aimbot"] = nil,
	["Anti Bat"] = nil, -- removed
	["Carry Speed"] = nil,
	["TP Bat"] = nil, -- removed

	FuckerToggle = nil,
	}
	local listeningBindBtn = nil
	local listeningFeature = nil
	local _allBindBtns = {}
	local _featureToggleMap = {}
	local toggleVisualUpdaters = {}
	local toggleStateSetters = {}
	local ragdollCounterPaused = false
	local FeaturePostToggle = FeaturePostToggle or {}
	local FPSLabel = nil
	local PingLabel = nil
	local StatsRightFps = nil
	local StatsRightPing = nil
	_G = _G or {}
	_G.__CrystalDropMode = (_G.__CrystalDropMode == "Jump Drop") and "Jump Drop" or "Stand Drop"
	_G["_CrystalHub_UI_Data"] = _G["_CrystalHub_UI_Data"] or {}
	local mobileButtonPositions = {}
	local quickButtonPositions = {}
	_G.__CrystalButtonsSize = 1
	_G.__CrystalGuiPositionResetters = {}
	_G.__CrystalResetButtonPositions = nil
	_G.__CrystalGuiPositionsReset = false
	_G.__CrystalRoundPanelBackground = function(image, panel)
		local mask = Instance.new("CanvasGroup")
		mask.Name = "RoundedBackgroundMask"
		mask.Size = UDim2.fromScale(1, 1)
		mask.Position = UDim2.fromOffset(0, 0)
		mask.BackgroundTransparency = 1
		mask.BorderSizePixel = 0
		mask.GroupTransparency = 0
		mask.ZIndex = image.ZIndex
		mask.Parent = panel
		local panelCorner = panel:FindFirstChildOfClass("UICorner")
		local corner = Instance.new("UICorner", mask)
		corner.CornerRadius = panelCorner and panelCorner.CornerRadius or UDim.new(0, 16)
		local imageCorner = image:FindFirstChildOfClass("UICorner")
		if imageCorner then imageCorner:Destroy() end
		image.Parent = mask
	end
	_G.__CrystalFramePanelBackground = function(image, index, panel)
		image.ScaleType = Enum.ScaleType.Crop
			image.Size = UDim2.fromScale(1, 1)
			image.Position = UDim2.fromScale(0, 0)
	end

	_G.__EclipseAddOriginalGui3Title = function(parent, panel)
	if parent then parent.Text = string.upper(tostring(panel or "VYLO")) end
	end

	local function clampOffsetsInsideViewport(scaleX, offsetX, scaleY, offsetY, width, height, sizeScale)
	local camera = workspace.CurrentCamera
	local vs = camera and camera.ViewportSize or Vector2.new(1920, 1080)
	if vs.X <= 0 or vs.Y <= 0 then return offsetX, offsetY end
	sizeScale = sizeScale or 1
	width = width * sizeScale
	height = height * sizeScale
	local minX = -vs.X * scaleX
	local maxX = vs.X * (1 - scaleX) - width
	local minY = -vs.Y * scaleY
	local maxY = vs.Y * (1 - scaleY) - height
	if maxX < minX then maxX = minX end
	if maxY < minY then maxY = minY end
	return math.clamp(offsetX, minX, maxX), math.clamp(offsetY, minY, maxY)
	end

	local function placeInsideViewport(gui, scaleX, offsetX, scaleY, offsetY, sizeScale)
	local width = gui.Size.X.Offset
	local height = gui.Size.Y.Offset
	local x, y = clampOffsetsInsideViewport(scaleX, offsetX, scaleY, offsetY, width, height, sizeScale)
	gui.Position = UDim2.new(scaleX, x, scaleY, y)
	return x, y
	end

	local isScrollDragging = false

	local function attachCleanHubTap(btn, onTap)
	return false
	end

	local cleanTapStates = setmetatable({}, { __mode = "k" })
	_G.__CrystalTrackConn(UserInputService.InputChanged:Connect((function(inp)
	local states = cleanTapStates[inp]
	if not states then return end
	if inp.UserInputType ~= Enum.UserInputType.Touch and inp.UserInputType ~= Enum.UserInputType.MouseMovement then return end
	for _, state in ipairs(states) do
	if (inp.Position - state.tapStart).Magnitude > 12 then state.tapMoved = true end
	end
	end)))
	_G.__CrystalTrackConn(UserInputService.InputEnded:Connect(function(inp)
	local states = cleanTapStates[inp]
	if not states then return end
	cleanTapStates[inp] = nil
	for _, state in ipairs(states) do
	if not state.tapMoved and not isScrollDragging then
	local scrollMoved = state.scroll and state.scrollCanvasAtStart
	and math.abs(state.scroll.CanvasPosition.Y - state.scrollCanvasAtStart) > 5
	if not scrollMoved then state.callback() end
	end
	end
	end))

	local function connectBtn(btn, callback)
	if attachCleanHubTap(btn, callback) then return end
	btn.InputBegan:Connect(function(inp)
	if inp.UserInputType ~= Enum.UserInputType.Touch and inp.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
	local activeScroll = Scroll
	local states = cleanTapStates[inp]
	if not states then states = {}; cleanTapStates[inp] = states end
	table.insert(states, {
	tapStart = inp.Position,
	tapMoved = false,
	scroll = activeScroll,
	scrollCanvasAtStart = activeScroll and activeScroll.CanvasPosition.Y or nil,
	callback = callback,
	})
	end)
	end

	local darkPalette = {
	["245,250,255"] = Color3.fromRGB(25, 31, 42),
	["235,245,255"] = Color3.fromRGB(31, 49, 70),
	["210,230,250"] = Color3.fromRGB(35, 57, 82),
	["190,220,250"] = Color3.fromRGB(55, 105, 160),
	["140,190,240"] = Color3.fromRGB(60, 135, 205),
	["80,160,255"] = Color3.fromRGB(38, 112, 205),
	["50,110,190"] = Color3.fromRGB(160, 205, 255),
	["80,130,200"] = Color3.fromRGB(165, 210, 255),
	["40,80,150"] = Color3.fromRGB(150, 200, 255),
	["30,90,200"] = Color3.fromRGB(130, 190, 255),
	["60,120,200"] = Color3.fromRGB(150, 205, 255),
	["100,140,200"] = Color3.fromRGB(165, 210, 255),
	}
	local GUI_WATCH_PROPERTIES = {"BackgroundColor3", "BorderColor3"}
	local TEXT_COLOR_PROPERTIES = {"BackgroundColor3", "TextColor3", "BorderColor3"}
	local TEXT_WATCH_PROPERTIES = {"TextColor3", "TextStrokeColor3", "TextStrokeTransparency"}
	local applyDarkPaletteTo
	local buttonThemeStates = setmetatable({}, {__mode = "k"})
	local function applyButtonTheme(instance)
	local owner = instance
	while owner and not owner:IsA("GuiButton") and not owner:GetAttribute("CrystalButtonThemeControl") do
	owner = owner.Parent
	end
	if not owner then return end
	local property = instance:IsA("UIStroke") and "Color"
		or instance:IsA("UIGradient") and "Color"
		or instance:IsA("GuiObject") and "BackgroundColor3"
	if not property then return end
	local state = buttonThemeStates[instance]
	if not state then
	state = {}
	buttonThemeStates[instance] = state
	_G.__CrystalTrackConn(instance:GetPropertyChangedSignal(property):Connect(function()
	applyButtonTheme(instance)
	end))
	end
	if state.busy then return end
	local current = instance[property]
	if current == state.applied and state.theme == _G.__CrystalGuiTheme then return end
	if current ~= state.applied then state.original = current end
	local theme = _G.__CrystalGuiTheme
	local function tint(color)
	if theme ~= "GUI 2" and theme ~= "GUI 3" then return color end
	local brightness = math.max(color.R, color.G, color.B)

	local dark = theme == "GUI 2" and Color3.fromRGB(29, 16, 43) or Color3.fromRGB(43, 13, 17)
	local bright = theme == "GUI 2" and Color3.fromRGB(177, 108, 248) or Color3.fromRGB(246, 65, 77)
	return dark:Lerp(bright, brightness)
	end
	local result = state.original
	if instance:IsA("UIGradient") then
	if theme == "GUI 2" or theme == "GUI 3" then
	local points = {}
	for _, point in ipairs(result.Keypoints) do
	table.insert(points, ColorSequenceKeypoint.new(point.Time, tint(point.Value)))
	end
	result = ColorSequence.new(points)
	end
	else
	result = tint(result)
	end
	state.applied = result
	state.theme = theme
	if current ~= result then
	state.busy = true
	instance[property] = result
	state.busy = false
	end
	end
	applyDarkPaletteTo = (function(instance)
	if not instance then return end
	local colorProperties = nil
	if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
	colorProperties = TEXT_COLOR_PROPERTIES
	elseif instance:IsA("GuiObject") then
	colorProperties = GUI_WATCH_PROPERTIES
	end
	if colorProperties then
	for _, property in ipairs(colorProperties) do
	local color = instance[property]
	local key = string.format("%d,%d,%d", math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
	if darkPalette[key] then instance[property] = darkPalette[key] end
	end
	end
	if instance:IsA("UIStroke") then
	local color = instance.Color
	local key = string.format("%d,%d,%d", math.floor(color.R * 255 + 0.5), math.floor(color.G * 255 + 0.5), math.floor(color.B * 255 + 0.5))
	if color.B > color.R + 12 and color.B >= color.G then instance.Color = Color3.fromRGB(0, 0, 0)
	elseif darkPalette[key] then instance.Color = darkPalette[key] end
	end

	if not _G.__CrystalModernGuiActive and not instance:GetAttribute("CrystalDarkPaletteWatched") then
	instance:SetAttribute("CrystalDarkPaletteWatched", true)
	local function watchProperty(property)
	_G.__CrystalTrackConn(instance:GetPropertyChangedSignal(property):Connect(function()
	applyDarkPaletteTo(instance)
	end))
	end
	if instance:IsA("UIStroke") then
	watchProperty("Color")
	elseif instance:IsA("GuiObject") then
	for _, property in ipairs(GUI_WATCH_PROPERTIES) do watchProperty(property) end
	if instance:IsA("TextLabel") or instance:IsA("TextButton") or instance:IsA("TextBox") then
	for _, property in ipairs(TEXT_WATCH_PROPERTIES) do watchProperty(property) end
	end
	end
	end
	applyButtonTheme(instance)
	end)

	_G.__CrystalThemeRoots = {}
	local themeWalkCancels = setmetatable({}, { __mode = "k" })
	_G.__CrystalRegisterThemeRoot = (function(root)
	if not root then return end
	for _, savedRoot in ipairs(_G.__CrystalThemeRoots) do
	if savedRoot == root then return end
	end
	table.insert(_G.__CrystalThemeRoots, root)
	applyDarkPaletteTo(root)
	if themeWalkCancels[root] then themeWalkCancels[root]() end
	themeWalkCancels[root] = _G.__CrystalWalkDescendantsBatched(root, applyDarkPaletteTo, function()
	return root.Parent ~= nil
	end)
	_G.__CrystalTrackConn(root.DescendantAdded:Connect(applyDarkPaletteTo))
	end)
	_G.__CrystalApplyTheme = (function()
	for _, root in ipairs(_G.__CrystalThemeRoots) do
	if root and root.Parent then
	applyDarkPaletteTo(root)
	if themeWalkCancels[root] then themeWalkCancels[root]() end
	themeWalkCancels[root] = _G.__CrystalWalkDescendantsBatched(root, applyDarkPaletteTo, function()
	return root.Parent ~= nil
	end)
	end
	end
	end)

_G.__CrystalAddUnifiedPanelShade = function(parent, cornerRadius, zIndex)
	local oldShade = parent and parent:FindFirstChild("UnifiedBackgroundShade")
	if oldShade then oldShade:Destroy() end
	local oldOutline = parent and parent:FindFirstChild("UnifiedPanelWhiteOutline")
	if oldOutline then oldOutline:Destroy() end
	local oldGlow = parent and parent:FindFirstChild("UnifiedPanelWhiteGlow")
	if oldGlow then oldGlow:Destroy() end
	local shade = Instance.new("Frame")
	shade.Name = "UnifiedBackgroundShade"
	shade.Size = UDim2.fromScale(1, 1)
	shade.Position = UDim2.fromScale(0, 0)
	shade.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	shade.BackgroundTransparency = 0.68
	shade.BorderSizePixel = 0
	shade.Active = false
	shade.ZIndex = zIndex or 1
	shade.ClipsDescendants = true
	shade.Parent = parent
	Instance.new("UICorner", shade).CornerRadius = UDim.new(0, cornerRadius or 10)
	local shadeGradient = Instance.new("UIGradient", shade)
	shadeGradient.Rotation = 90
	shadeGradient.Transparency = NumberSequence.new({
	NumberSequenceKeypoint.new(0, 0.28),
	NumberSequenceKeypoint.new(0.55, 0.42),
	NumberSequenceKeypoint.new(1, 0.56),
	})
	-- No outer strokes: thick UIStroke causes corner "spikes" on rounded panels
	return shade
end

	local gamepadInputTypes = {
	[Enum.UserInputType.Gamepad1] = true,
	[Enum.UserInputType.Gamepad2] = true,
	[Enum.UserInputType.Gamepad3] = true,
	[Enum.UserInputType.Gamepad4] = true,
	[Enum.UserInputType.Gamepad5] = true,
	[Enum.UserInputType.Gamepad6] = true,
	[Enum.UserInputType.Gamepad7] = true,
	[Enum.UserInputType.Gamepad8] = true,
	}

	local function isBindableInput(input)
	return input
	and input.KeyCode
	and input.KeyCode ~= Enum.KeyCode.Unknown
	and (input.UserInputType == Enum.UserInputType.Keyboard or gamepadInputTypes[input.UserInputType])
	end

	local function isClearKeybindInput(input)
	return input
	and input.UserInputType == Enum.UserInputType.Keyboard
	and input.KeyCode == Enum.KeyCode.RightControl
	end

	local mouseButtonMap = {}
	local mouseButtonDisplay = {
	["MB3"] = "Mouse3",
	}
	pcall(function() mouseButtonMap[Enum.UserInputType.MouseButton3] = "MB3" end)
	local function isMouseSideButton(input)
	return input and mouseButtonMap[input.UserInputType] ~= nil
	end
	local function getMouseButtonBind(input)
	return mouseButtonMap[input.UserInputType]
	end

	local function keybindDisplayName(key)
	if not key then return "-" end
	if type(key) == "string" then return mouseButtonDisplay[key] or key end
	return tostring(key):match("KeyCode%.(.+)") or tostring(key)
	end

	local VIOLETTE_SKIN_SETS = {
	    ["1"] = {
	        displayName = "1",
	        hats = "1744060292,439945661,1125510,1029025",
	        hair = "",
	        headless = true,
	        korblox = "Right",
	        accessories = {
	            1744060292,
	            439945661,
	            1125510,
	            1029025,
	            11748356,
	            8465506143,
	            11444217173,
	        },
	        clothing = {
	            7424637509,
	            7689651773,
	        },
	    
	    },
	    ["2"] = {
	        displayName = "2",
	        hats = "74891470",
	        hair = "16630147,6346833550,6594911228,6594919952,6823338112,7097747842",
	        headless = true,
	        korblox = "Right",
	        accessories = {
	            74891470,
	            16630147,
	            6346833550,
	            6594911228,
	            6594919952,
	            6823338112,
	            7097747842,
	        },
	        clothing = {
	            18423061209,
	            18423154566,
	        },
	    
	    },
	    ["3"] = {
	        displayName = "3",
	        hats = "215718515,439945661",
	        hair = "7183785281",
	        headless = true,
	        korblox = "Right",
	        accessories = {
	            215718515,
	            439945661,
	            7183785281,
	        },
	        clothing = {
	            15998365201,
	            7689651773,
	        },
	    
	    },
	    ["4"] = {
	        displayName = "4",
	        hats = "10159600649,439946249,17798262442,92482095662016",
	        hair = "139101716417676",
	        headless = true,
	        korblox = "Right",
	        accessories = {
	            10159600649,
	            439946249,
	            17798262442,
	            92482095662016,
	            139101716417676,
	            12490213797,
	        },
	        clothing = {
	            18766106994,
	            13925390578,
	        },
	    
	    },
	    ["5"] = {
	        displayName = "5",
	        hats = "553970961,1744060292",
	        hair = "93268856876777",
	        headless = true,
	        korblox = "Right",
	        accessories = {
	            553970961,
	            1744060292,
	            93268856876777,
	        },
	        clothing = {
	            9478068776,
	            6348682339,
	        },
	    
	    },
	    ["6"] = {
	        hats = "74891470,215718515,439945661,1016143686,1744060292,"
	            .. "10159600649,89012651581593,88365652378427",
	        hair = "126447390530523",
	        headless = true,
	        korblox = "Right",
	        accessories = {
	            74891470,
	            215718515,
	            439945661,
	            1016143686,
	            1744060292,
	            10159600649,
	            89012651581593,
	            126447390530523,
	        },
	        clothing = {
	            88032876921227,
	            108259950755140,
	        },
	        displayName = "6",
	    
	    },
	    ["7"] = {
	        hats = "", hair = "111149505826763", headless = false, korblox = "Off",
	        accessories = { 111149505826763 }, clothing = { 9733132546, 101481154733615 },
	        displayName = "7",
	    
	    },
	    ["8"] = {
	        hats = "", hair = "111149505826763", headless = false, korblox = "Off",
	        accessories = { 111149505826763 }, clothing = { 10796276786, 101481154733615 },
	        displayName = "8",
	    
	    },
	    ["9"] = {
	        hats = "", hair = "111149505826763", headless = false, korblox = "Off",
	        accessories = { 111149505826763 }, clothing = { 8844377623, 101481154733615 },
	        displayName = "9",
	    
	    },
	    ["10"] = {
	        hats = "", hair = "111149505826763", headless = false, korblox = "Off",
	        accessories = { 111149505826763 }, clothing = { 16107371158, 101481154733615 },
	        displayName = "10",
	    
	    },
	    ["11"] = {
	        hats = "", hair = "111149505826763", headless = false, korblox = "Off",
	        accessories = { 111149505826763 }, clothing = { 15970848598, 101481154733615 },
	        displayName = "11",
	    
	    },
	    ["12"] = {
	        hats = "", hair = "111149505826763", headless = false, korblox = "Off",
	        accessories = { 111149505826763 }, clothing = { 8844377623, 101481154733615 },
	        displayName = "12",
	    
	    },
	    ["13"] = {
	        hats = "17274218093", hair = "", headless = false, korblox = "Off",
	        accessories = { 111553288808103, 17274218093, 17387240647 },
	        clothing = { 130666125397672, 91321960147976 },
	        displayName = "13",
	    
	    },
	    ["14"] = {
	        hats = "127788745429250", hair = "", headless = false, korblox = "Off",
	        accessories = { 127788745429250, 143803235928952 },
	        clothing = { 77038549270215, 16717004839 },
	        displayName = "14",
	    
	    },
	    ["16"] = {
	        hats = "91950080535908", hair = "96954292222783", headless = true, korblox = "Right",
	        accessories = { 91950080535908, 96954292222783, 17309352545, 132404403424262 },
	        clothing = { 9683332649, 13063157758 },
	        displayName = "16",
	    
	    },
	    ["17"] = {
	        hats = "10997283529", hair = "", headless = true, korblox = "Off",
	        accessories = {
	            10997283529, 125085889448130,
	            115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322,
	        },
	        clothing = {},
	        displayName = "17",
	    
	    },
	    ["18"] = {
	        hats = "125157548394108", hair = "", headless = false, korblox = "Off",
	        accessories = {
	            125157548394108, 123231522991173, 74827642361405,
	            115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322,
	        },
	        clothing = {},
	        displayName = "18",
	    
	    },
	    ["19"] = {
	        hats = "136644276218918", hair = "", headless = false, korblox = "Off",
	        accessories = {
	            136644276218918, 132022106987543, 131740907052260,
	            115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322,
	        },
	        clothing = {},
	        displayName = "19",
	    
	    },
	    ["20"] = {
	        hats = "119331031817124", hair = "", headless = true, korblox = "Off",
	        accessories = {
	            119331031817124, 84952305140948,
	            115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322,
	        },
	        clothing = {},
	        displayName = "20",
	    
	    },
	    ["21"] = {
	        hats = "18902416696", hair = "", headless = true, korblox = "Off",
	        accessories = {
	            18902416696, 17739456422, 116750288839357, 12842417046, 122223069519702,
	            115566893133129, 103980259507115, 109790632200416, 112532740065682, 120301257476322,
	        },
	        clothing = {},
	        displayName = "21",
	    
	    },
	    ["22"] = {
	        hats = "13935333090", hair = "", headless = false, korblox = "Off",
	        accessories = { 13935333090, 16110951997, 10632503818 },
	        clothing = {},
	        displayName = "22",
	    
	    },
	    ["23"] = {
	        hats = "74891470", hair = "", headless = true, korblox = "Off",
	        accessories = { 74891470, 4390891467, 91274263831244, 128424248603010, 91151766440767, 17044638424 },
	        clothing = {},
	        displayName = "23",
	    
	    },
	    ["24"] = {
	        hats = "76479271580913", hair = "", headless = true, korblox = "Right",
	        accessories = { 76479271580913, 1402432199, 140627490971265, 128912609563885, 17449551560, 5796531729, 139607718 },
	        clothing = {},
	        displayName = "24",
	    
	    },
	    ["25"] = {
	        hats = "", hair = "", headless = false, korblox = "Both",
	        accessories = { 70414871864071, 14863917259, 133498027006138, 82277826177074 },
	        clothing = {},
	        displayName = "25",
	    
	    },
	    ["26"] = {
	        displayName = "Halloween 1",
	        hats = "",
	        hair = "137816489423089",
	        head = 92670829478194,
	        headless = false,
	        korblox = "Off",
	        accessories = { 137816489423089 },
	        clothing = { 11411687887, 18509017923 },
	    },
	    ["28"] = {
	        displayName = "28",
	        hats = "",
	        hair = "90007911221909",
	        head = 1041195,
	        headless = false,
	        korblox = "Off",
	        accessories = { 90007911221909, 148411014788061 },
	        clothing = { 136011439161390, 18509017923 },
	    },
	}
	_G._KawatanSkinSets = VIOLETTE_SKIN_SETS
	_G._KawatanSkinSetOrder = {}
	for i = 1, 28 do if i ~= 15 and i ~= 27 then table.insert(_G._KawatanSkinSetOrder, tostring(i)) end end
	_G._KawatanSkinColor = _G._KawatanSkinColor or "1"
	do
		local assetProperties = {
			[11] = "Shirt", [12] = "Pants", [2] = "GraphicTShirt",
			[8] = "HatAccessory", [41] = "HairAccessory", [42] = "FaceAccessory",
			[43] = "NeckAccessory", [44] = "ShouldersAccessory", [45] = "FrontAccessory",
			[46] = "BackAccessory", [47] = "WaistAccessory", [64] = "TShirtAccessory",
			[65] = "ShirtAccessory", [66] = "PantsAccessory", [67] = "JacketAccessory",
			[68] = "SweaterAccessory", [69] = "ShortsAccessory", [70] = "LeftShoeAccessory",
			[71] = "RightShoeAccessory", [72] = "DressSkirtAccessory",
		}
		local function addPreviewAsset(description, assetId)
			local ok, info = pcall(function()
				return game:GetService("MarketplaceService"):GetProductInfo(assetId, Enum.InfoType.Asset)
			end)
			if not ok or not info then return end
			local property = assetProperties[tonumber(info.AssetTypeId)]
			if not property then return end
			if property == "Shirt" or property == "Pants" or property == "GraphicTShirt" then
				pcall(function() description[property] = assetId end)
			else
				local current = ""
				pcall(function() current = tostring(description[property] or "") end)
				pcall(function() description[property] = current == "" and tostring(assetId) or (current .. "," .. tostring(assetId)) end)
			end
		end
		_G._KawatanBuildSetDescription = function(setName)
			local skin = VIOLETTE_SKIN_SETS[tostring(setName)]
			if not skin then return nil end
			local base
			pcall(function()
				local hum = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
				if hum then base = hum:GetAppliedDescription() end
			end)
			local description = base and base:Clone() or Instance.new("HumanoidDescription")
			for _, property in ipairs({"HatAccessory", "HairAccessory", "FaceAccessory", "NeckAccessory", "ShouldersAccessory", "FrontAccessory", "BackAccessory", "WaistAccessory", "ShirtAccessory", "PantsAccessory", "JacketAccessory", "SweaterAccessory", "ShortsAccessory", "TShirtAccessory", "DressSkirtAccessory"}) do pcall(function() description[property] = "" end) end
			pcall(function() description.Shirt = 0; description.Pants = 0; description.GraphicTShirt = 0 end)
			pcall(function() description.HatAccessory = skin.hats or ""; description.HairAccessory = skin.hair or ""; if skin.head then description.Head = skin.head end end)
			for _, id in ipairs(skin.accessories or {}) do addPreviewAsset(description, id) end
			for _, id in ipairs(skin.clothing or {}) do addPreviewAsset(description, id) end
			return description
		end
	end

	local toggleDefaults = {}
	toggleDefaults["Inf Jump"] = false
	toggleDefaults["Anti Bat"] = false
	toggleDefaults["TP Down"] = false
	toggleDefaults["Auto TP Down"] = false
	toggleDefaults["Mirror TP Down"] = false
	toggleDefaults["Anti Ragdoll"] = false
	toggleDefaults["Ragdoll Counter"] = false
	toggleDefaults["Medusa Counter"] = false
	toggleDefaults["Aimbot"] = false
	toggleDefaults["Autoplay"] = false
	toggleDefaults["Auto Left"] = false
	toggleDefaults["Auto Right"] = false
	toggleDefaults["Drop"] = false
	toggleDefaults["auto steal"] = false
	toggleDefaults["Steal Bar"] = true
	toggleDefaults["ESP Players"] = false
	toggleDefaults["Player Tracers"] = false
	toggleDefaults["Show Buttons"] = false
	toggleDefaults["Lock Buttons"] = false
	toggleDefaults["Show FPS"] = false
	toggleDefaults["FPS Boost"] = false
	toggleDefaults["Anti Lag"] = false
toggleDefaults["Optimizer"] = true
	toggleDefaults["Lagger"] = false
	toggleDefaults["Speed Boost"] = false
	toggleDefaults["Toggle UI"] = true
	toggleDefaults["Auto Steal Speed"] = false
	toggleDefaults["Auto Carry Speed"] = false
	toggleDefaults["Carry Speed"] = false
	toggleDefaults["Unwalk"] = false
	toggleDefaults["Harder Hit Anim"] = false
	toggleDefaults["Animaciones"] = false
	toggleDefaults["Custom FOV"] = false
	toggleDefaults["Stretchz Res"] = false
	toggleDefaults["Sky Changer"] = false
	toggleDefaults["Violette Custom Skins"] = false
	toggleDefaults["Headless Visual"] = false
	toggleDefaults["Korblox Visual"] = false
	toggleDefaults["Anti Die"] = false
	toggleDefaults["Body Lock"] = false
	for k, v in pairs(toggleDefaults) do toggleStates[k] = v end

	local lastSavedConfigData = nil
	local pendingConfigData = nil
	local configSaveGeneration = 0
	local function flushConfig(data)
	if not data or data == lastSavedConfigData then return end
	pcall(writefile, CONFIG_FILE, data)
	lastSavedConfigData = data
	end
	local function saveConfig()
	local lines = {}
	for name, state in pairs(toggleStates) do
	if not transientToggles[name] then
	table.insert(lines, "T:" .. name .. "=" .. tostring(state))
	end
	end
	for name, state in pairs(mobileShortcutStates) do
	table.insert(lines, "S:" .. name .. "=" .. tostring(state))
	end
	for name, state in pairs(mobileBtnPlaced) do
	table.insert(lines, "B:" .. name .. "=" .. tostring(state))
	end
	for k, v in pairs(speedValues) do
	table.insert(lines, "V:" .. k .. "=" .. tostring(v))
	end
	for k, v in pairs(autoStealValues) do
	table.insert(lines, "A:" .. k .. "=" .. tostring(v))
	end
	for _, cs in ipairs(customSpeeds) do
	table.insert(lines, "C:" .. cs.name .. "=" .. cs.boost .. "," .. cs.steal)
	end
	if _G.__CrystalHub_Anims then
	for k, v in pairs(_G.__CrystalHub_Anims) do
	table.insert(lines, "N:" .. k .. "=" .. v)
	end
	end
	table.insert(lines, "M:selectedMode=" .. selectedMode)
	table.insert(lines, "M:optimizerMode=" .. tostring(_G.__optimizerMode or "Ultra"))
	table.insert(lines, "M:autoplayMode=" .. (_G.__autoplayMode or "Full"))
	table.insert(lines, "M:skyIndex=" .. (tostring(_G.__skyGetIndex and _G.__skyGetIndex() or 1)))
	table.insert(lines, "M:skyMode=" .. tostring(_G.__CrystalSkyChangerMode or "blue"))
	table.insert(lines, "M:violetteSkinMode=" .. tostring(violetteSkinMode))
	table.insert(lines, "M:katanaIndex=" .. (tostring(_G.__katanaGetIndex and _G.__katanaGetIndex() or 1)))
	table.insert(lines, "M:autoStealMode=" .. ((autoStealMode == "v2") and "v2" or "v1"))
	table.insert(lines, "M:carrySpeedMode=v2")
	table.insert(lines, "M:dropMode=" .. ((_G.__CrystalDropMode == "Jump Drop") and "Jump Drop" or "Stand Drop"))
	table.insert(lines, "M:infJumpMode=" .. (_G.__CrystalInfJumpMode or "hold"))
	table.insert(lines, "M:panelVisible=" .. tostring(_G.__CrystalPanelVisible ~= false))
	table.insert(lines, "M:tabPosition=" .. tostring(_G.__CrystalTabPosition or "Down"))
	table.insert(lines, "M:batVersion=" .. tostring(_G.__batVersion or 1))
	table.insert(lines, "M:aimbotMode=bypass")
	table.insert(lines, "M:aimbotEngineVersion=" .. tostring((_G.__aimbotEngineVersion == 2) and 2 or 1))
	table.insert(lines, "M:aimbotVersion=" .. tostring((_G.__aimbotEngineVersion == 2) and 2 or 1))
	table.insert(lines, "M:buttonsSize=" .. tostring(_G.__CrystalButtonsSize or 1))
	table.insert(lines, "M:tpBatV2Distance=" .. tostring(math.clamp(tonumber(_G.__tpBatV2Distance) or 8, 0, 100)))
	if _G.__CrystalAnimationPreset then
	table.insert(lines, "M:animationPreset=" .. tostring(_G.__CrystalAnimationPreset))
	end
	table.insert(lines, "M:guiTheme=" .. tostring(_G.__CrystalGuiTheme or "GUI 1"))
	table.insert(lines, "M:customFont=" .. tostring(_G.CrystalFontChoice or "Default"))
	table.insert(lines, "M:themePrimary=" .. (_G.__CrystalThemePrimary or "BLACK"))
	table.insert(lines, "M:themeSecondary=" .. (_G.__CrystalThemeSecondary or "BLUE"))
	table.insert(lines, "M:autoGrabExpanded=" .. tostring(_G["_CrystalHub_UI_AutoGrabExpanded"] ~= false))
	-- This marker separates new keybinds from configurations predating the reset.
	table.insert(lines, "M:keybindResetVersion=1")
	for feat, key in pairs(FeatureKeybinds) do
	if key then
	local keyName
	if type(key) == "string" then
	keyName = key
	else
	keyName = tostring(key):match("KeyCode%.(.+)") or tostring(key)
	end
	table.insert(lines, "K:" .. feat .. "=" .. keyName)
	end
	end
	if _G["_CrystalHub_UI_MenuPos"] then
	local pos = _G["_CrystalHub_UI_MenuPos"]
	if pos.x and pos.y then
	table.insert(lines, "P:menuPos=" .. math.floor(pos.x) .. "," .. math.floor(pos.y))
	end
	end
	table.insert(lines, "M:introMusicIndex=" .. tostring(selectedIntroMusicIndex))
	table.insert(lines, "M:bgIndex=" .. tostring(_G["_CrystalHub_UI_BgIndex"] or 1))
	if _G.__toggleBtn then
	table.insert(lines, "P:toggleBtn=" .. math.floor(_G.__toggleBtn.Position.X.Offset) .. "," .. math.floor(_G.__toggleBtn.Position.Y.Offset))
	end

	for name, pos in pairs(mobileButtonPositions) do
	if pos.x and pos.y then
	local extra = ""
	if pos.xs and pos.ys then extra = ":" .. pos.xs .. ":" .. pos.ys end
	table.insert(lines, "P:mobileBtn_" .. name .. "=" .. math.floor(pos.x) .. "," .. math.floor(pos.y) .. extra)
	end
	end
	for name, pos in pairs(quickButtonPositions) do
	if pos.x and pos.y then
	table.insert(lines, "P:quickBtn_" .. name .. "=" .. math.floor(pos.x) .. "," .. math.floor(pos.y))
	end
	end
	if _G["_CrystalHub_UI_SpeedFramePos"] then
	local pos = _G["_CrystalHub_UI_SpeedFramePos"]
	if pos.x and pos.y then
	table.insert(lines, "P:speedFrame=" .. math.floor(pos.x) .. "," .. math.floor(pos.y))
	end
	end
	if _G["_CrystalHub_EnemyWidget_SaveHook"] then pcall(_G["_CrystalHub_EnemyWidget_SaveHook"]) end
	if _G["_CrystalHub_UI_EnemyWidgetPos"] then
	local pos = _G["_CrystalHub_UI_EnemyWidgetPos"]
	if pos.x and pos.y then
	table.insert(lines, "P:enemyWidget=" .. math.floor(pos.x) .. "," .. math.floor(pos.y))
	end
	end
	if _G["_CrystalHub_UI_StatusBarPos"] then
	local pos = _G["_CrystalHub_UI_StatusBarPos"]
	if pos.x and pos.y then
	table.insert(lines, "P:statusBar=" .. math.floor(pos.x) .. "," .. math.floor(pos.y))
	end
	end
	if _G["_CrystalHub_UI_AutoGrabBarPos"] then
	local pos = _G["_CrystalHub_UI_AutoGrabBarPos"]
	if pos.x and pos.y then
	table.insert(lines, "P:autoGrabBar=" .. math.floor(pos.x) .. "," .. math.floor(pos.y))
	end
	end
	if _G["_CrystalHub_UI_AutoGrabBarSize"] then
	table.insert(lines, "P:autoGrabBarSize=" .. tostring(_G["_CrystalHub_UI_AutoGrabBarSize"]))
	end
	if _G["_CrystalHub_UI_ModernMiniPos"] then
	local pos = _G["_CrystalHub_UI_ModernMiniPos"]
	if pos.x and pos.y then table.insert(lines, "P:modernMini=" .. math.floor(pos.x) .. "," .. math.floor(pos.y)) end
	end
	local data = table.concat(lines, "\n")
	if data == lastSavedConfigData or data == pendingConfigData then return end
	pendingConfigData = data
	_G["_CrystalHub_UI_Data"] = data
	configSaveGeneration = configSaveGeneration + 1
	local generation = configSaveGeneration

	task.delay(0.2, function()
	if generation ~= configSaveGeneration or pendingConfigData ~= data then return end
	pendingConfigData = nil
	flushConfig(data)
	end)
	end
	_G.__CrystalTrackStopper(function()
	if pendingConfigData then flushConfig(pendingConfigData); pendingConfigData = nil end
	end)

	local function deactivateOtherAimbots(keepName)
	local changed = false
	for _, name in ipairs({ "Aimbot", "TP Bat" }) do
	if name ~= keepName and name ~= "TP Bat" and toggleStates[name] then
	toggleStates[name] = false
	changed = true
	local setter = toggleStateSetters[name]
	if setter then pcall(setter, false) end
	if FeaturePostToggle[name] then pcall(FeaturePostToggle[name], false) end
	end
	end
	if changed then saveConfig() end
	end

	local function deactivateBatExclusive(keepName)
	local changed = false
	for _, name in ipairs({ "Aimbot", "TP Bat" }) do
	if name ~= keepName and name ~= "TP Bat" and toggleStates[name] then
	toggleStates[name] = false
	changed = true
	local setter = toggleStateSetters[name]
	if setter then pcall(setter, false) end
	if FeaturePostToggle[name] then pcall(FeaturePostToggle[name], false) end
	end
	end
	if changed then saveConfig() end
	end
	_G.__deactivateBatExclusive = deactivateBatExclusive

	local function loadConfig()
	local data = nil
	local ok, result = pcall(readfile, CONFIG_FILE)
	if ok and result and #result > 0 then
	data = result
	elseif _G["_CrystalHub_UI_Data"] and #_G["_CrystalHub_UI_Data"] > 0 then
	data = _G["_CrystalHub_UI_Data"]
	end
	if not data then return end
	-- Read the migration marker before loading any keybinds, regardless of line order.
	local restoreKeybinds = false
	for configLine in data:gmatch("[^\n]+") do
	if configLine:match("^M:keybindResetVersion=%s*1%s*$") then
	restoreKeybinds = true
	break
	end
	end
	for line in data:gmatch("[^\n]+") do
	local prefix = line:sub(1, 2)
	local rest = line:sub(3)
	local k, v = rest:match("([^=]+)=(.+)")
	if k and v then
	k = k:match("^%s*(.-)%s*$")
	v = v:match("^%s*(.-)%s*$")
	if prefix == "T:" and toggleStates[k] ~= nil and not transientToggles[k] then
	toggleStates[k] = (v == "true")
	elseif prefix == "S:" then
	mobileShortcutStates[k] = (v == "true")
	elseif prefix == "B:" then
	mobileBtnPlaced[k] = (v == "true")
	elseif prefix == "V:" and speedValues[k] ~= nil then
	local num = tonumber(v)
	if num then
	speedValues[k] = num
	if k == "NormalBoost" then normalSpeed = num end
	if k == "NormalSteal" then carrySpeed = num end
	if k == "LaggerBoost" then laggerSpeed = num end
	if k == "LaggerSteal" then speedValues.LaggerSteal = num end
	end
	elseif prefix == "N:" then
	_G.__savedAnimations = _G.__savedAnimations or {}
	_G.__savedAnimations[k] = v
	elseif prefix == "M:" then
	if k == "introMusicIndex" then
	selectedIntroMusicIndex = tonumber(v) or 2
	elseif k == "bgIndex" then
	_G["_CrystalHub_UI_BgIndex"] = tonumber(v)
	elseif k == "selectedMode" then
	if v == "Normal" or v == "Lagger" or v == "Desync" then selectedMode = v end
	elseif k == "autoplayMode" then
	if v == "Full" or v == "Semi" then _G.__autoplayMode = v end
	elseif k == "skyIndex" then
	_G.__savedSkyIndex = tonumber(v)
	elseif k == "skyMode" then
	if v == "day" or v == "blue" or v == "night" then _G.__CrystalSkyChangerMode = v end
	elseif k == "katanaIndex" then
	_G.__savedKatanaIndex = tonumber(v)
	elseif k == "autoStealMode" then

	if v == "v3" then v = "v1" end
	if v == "v1" or v == "v2" then autoStealMode = v end
	elseif k == "carrySpeedMode" then
	carrySpeedMode = "v2"
	elseif k == "optimizerMode" then
	if v == "Normal" or v == "Ultra" then _G.__optimizerMode = v end
	elseif k == "dropMode" then
	_G.__CrystalDropMode = (v == "Jump Drop") and "Jump Drop" or "Stand Drop"
	elseif k == "infJumpMode" then
	if v == "hold" or v == "manual" then _G.__CrystalInfJumpMode = v end
	elseif k == "autoGrabExpanded" then
	_G["_CrystalHub_UI_AutoGrabExpanded"] = (v == "true")
	elseif k == "panelVisible" then
	_G.__CrystalPanelVisible = (v == "true")
	toggleStates["Toggle UI"] = _G.__CrystalPanelVisible
	elseif k == "tabPosition" then
	if v == "Left" or v == "Down" then _G.__CrystalTabPosition = v end
	elseif k == "themePrimary" then
	if v == "BLACK" or v == "WHITE" then _G.__CrystalThemePrimary = v end
	elseif k == "themeSecondary" then
	if v == "BLUE" or v == "RED" or v == "CONTRAST" then _G.__CrystalThemeSecondary = v end
	elseif k == "buttonsSize" then
	local size = tonumber(v)
	if size and size == size and math.abs(size) < math.huge then
	_G.__CrystalButtonsSize = math.clamp(size, 0.5, 2)
	end
	elseif k == "violetteSkinMode" then
	violetteSkinMode = VIOLETTE_SKIN_SETS[v] and v or "1"
		elseif k == "batVersion" then
	_G.__batVersion = tonumber(v) == 2 and 2 or 1
	if _G.__batVersionPill then _G.__batVersionPill.Text = "V" .. tostring(_G.__batVersion or 1) end
	elseif k == "aimbotMode" then
	_G.__aimbotMode = "bypass"
	elseif k == "aimbotEngineVersion" then
	_G.__aimbotEngineVersion = tonumber(v) == 2 and 2 or 1
	_G.__aimbotVersion = _G.__aimbotEngineVersion
	_G.__aimbotEngineVersionFromConfig = true
	elseif k == "aimbotVersion" then
	-- legacy: map onto engine version when config did not set engine explicitly
	if not _G.__aimbotEngineVersionFromConfig then
	_G.__aimbotEngineVersion = tonumber(v) == 2 and 2 or 1
	end
	_G.__aimbotMode = "bypass"
	_G.__aimbotVersion = (_G.__aimbotEngineVersion == 2) and 2 or 1
	elseif k == "tpBatV2Distance" then
	_G.__tpBatV2Distance = math.clamp(tonumber(v) or 8, 0, 100)
	elseif k == "animationPreset" then
	_G.__CrystalAnimationPreset = v
	elseif k == "customFont" then
	_G.CrystalFontChoice = tostring(v or "Default")
	elseif k == "guiTheme" then
	_G.__CrystalGuiTheme = "GUI 1"
	end
	elseif prefix == "A:" and autoStealValues[k] ~= nil then
	local num = tonumber(v)
	if num then autoStealValues[k] = num end
	elseif prefix == "C:" then
	local boostStr, stealStr = v:match("([^,]+),([^,]+)")
	if boostStr and stealStr then
	table.insert(customSpeeds, { name = k, boost = tonumber(boostStr) or 59, steal = tonumber(stealStr) or 29 })
	end
	elseif prefix == "K:" and restoreKeybinds then
	if mouseButtonDisplay[v] then
	FeatureKeybinds[k] = v
	else
	local okKey, key = pcall(function() return Enum.KeyCode[v] end)
	if okKey then FeatureKeybinds[k] = key end
	end
	elseif prefix == "P:" then
	if k == "menuPos" then
	local mx, my = v:match("(-?%d+),(-?%d+)")
	if mx and my then _G["_CrystalHub_UI_MenuPos"] = { x = tonumber(mx), y = tonumber(my) } end
	elseif k == "toggleBtn" then
	local bx, by = v:match("(-?%d+),(-?%d+)")
	if bx and by then _G["_CrystalHub_UI_BtnPos"] = { x = tonumber(bx), y = tonumber(by) } end
	elseif k == "speedFrame" then
	local sx, sy = v:match("(-?%d+),(-?%d+)")
	if sx and sy then _G["_CrystalHub_UI_SpeedFramePos"] = { x = tonumber(sx), y = tonumber(sy) } end
	elseif k == "enemyWidget" then
	local ex, ey = v:match("(-?%d+),(-?%d+)")
	if ex and ey then _G["_CrystalHub_UI_EnemyWidgetPos"] = { x = tonumber(ex), y = tonumber(ey) } end
	elseif k == "statusBar" then
	local sx, sy = v:match("(-?%d+),(-?%d+)")
	if sx and sy then _G["_CrystalHub_UI_StatusBarPos"] = { x = tonumber(sx), y = tonumber(sy) } end
	elseif k == "autoGrabBar" then
	local ax, ay = v:match("(-?%d+),(-?%d+)")
	if ax and ay then _G["_CrystalHub_UI_AutoGrabBarPos"] = { x = tonumber(ax), y = tonumber(ay) } end
	elseif k == "autoGrabBarSize" then
	local num = tonumber(v)
	if num then _G["_CrystalHub_UI_AutoGrabBarSize"] = num end
	elseif k == "modernMini" then
	local mx, my = v:match("(-?%d+),(-?%d+)")
	if mx and my then _G["_CrystalHub_UI_ModernMiniPos"] = { x = tonumber(mx), y = tonumber(my) } end
	else
	local quickName = k:match("^quickBtn_(.+)$")
	if quickName then
	local qx, qy = v:match("^(-?%d+),(-?%d+)")
	if qx and qy then quickButtonPositions[quickName] = { x = tonumber(qx), y = tonumber(qy) } end
	else
	local mobileName = k:match("^mobileBtn_(.+)$")
	if mobileName then
	local bx, by = v:match("^(-?%d+),(-?%d+)")
	if bx and by then
	_G["_CrystalHub_UI_MobileBtnPos"] = _G["_CrystalHub_UI_MobileBtnPos"] or {}
	local pos = { x = tonumber(bx), y = tonumber(by) }
	local sx, sy = v:match(":(-?%d+):(-?%d+)$")
	if sx and sy then pos.xs = tonumber(sx); pos.ys = tonumber(sy) end
	_G["_CrystalHub_UI_MobileBtnPos"][mobileName] = pos
	end
	end
	end
	end
	end
	end
	end
	end
	loadConfig()
	saveConfig() -- Persist the one-time reset marker and retain all other loaded settings.
	if type(_G.__CrystalPanelVisible) == "boolean" then
	toggleStates["Toggle UI"] = _G.__CrystalPanelVisible
	else
	_G.__CrystalPanelVisible = toggleStates["Toggle UI"] ~= false
	toggleStates["Toggle UI"] = _G.__CrystalPanelVisible
	end
	if autoStealMode ~= "v1" and autoStealMode ~= "v2" then autoStealMode = "v1" end
	carrySpeedMode = "v2"
	_G.__batVersion = tonumber(_G.__batVersion) == 2 and 2 or 1
	_G.__tpBatV2Distance = math.clamp(tonumber(_G.__tpBatV2Distance) or 8, 0, 100)
	laggerEnabled = (selectedMode == "Lagger")
	speedToggled = toggleStates["Carry Speed"]
	toggleStates["TP Bat"] = false
	toggleStates["Anti Bat"] = false
	-- The steal bar is a HUD element: always show it when the hub starts.
	-- It can still be hidden manually from the Combat tab.
	toggleStates["Steal Bar"] = true
	toggleStates["Korblox"] = false
	pcall(function()
	local character = Player.Character
	if not character then return end
	for _, child in ipairs(character:GetChildren()) do
	if child.Name == "Korblox_RightLeg" then
	child:Destroy()
	end
	end
	for _, partName in ipairs({"RightUpperLeg", "RightLowerLeg", "RightFoot"}) do
	local limb = character:FindFirstChild(partName)
	if limb and limb:IsA("BasePart") then
	limb.Transparency = 0
	limb.CanCollide = true
	end
	end
	end)
	toggleStates["Autoplay"] = false
	toggleStates["Lagger"] = false

	mobileButtonPositions = _G["_CrystalHub_UI_MobileBtnPos"] or {}

	_G.__CrystalModernGuiActive = true
	local coreGui = game:GetService("CoreGui")
	local existing = Player.PlayerGui:FindFirstChild("VyloHub") or coreGui:FindFirstChild("VyloHub") or Player.PlayerGui:FindFirstChild("EclipseHub") or coreGui:FindFirstChild("EclipseHub") or Player.PlayerGui:FindFirstChild("CRYSTAL_Panel") or coreGui:FindFirstChild("CRYSTAL_Panel")
	if existing then existing:Destroy() end

	local ScreenGui = Instance.new("ScreenGui")
	ScreenGui.Name = "VyloHub"

	ScreenGui.Enabled = false
	ScreenGui.ResetOnSpawn = false
	ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	ScreenGui.DisplayOrder = 9999999
	ScreenGui.IgnoreGuiInset = true
	pcall(function() ScreenGui.Parent = coreGui end)
	if not ScreenGui.Parent then ScreenGui.Parent = Player.PlayerGui end

	local vp = workspace.CurrentCamera.ViewportSize
	GUI_METRICS = {
	sectionPad = isMobile and 4 or 6, sectionGap = isMobile and 4 or 6,
	sectionHeaderH = isMobile and 16 or 20, toggleH = isMobile and 44 or 62,
	compactRowH = isMobile and 30 or 36, compactCardH = isMobile and 28 or 32,
	toggleTextSize = isMobile and 9 or 10, bindW = isMobile and 34 or 40,
	bindH = isMobile and 16 or 20, bindTextSize = isMobile and 8 or 9,
	}
	local PANEL_W = isMobile and math.clamp(math.floor(vp.X * 0.42), 165, 205) or math.min(340, math.floor(vp.X * 0.52))
	local PANEL_H = isMobile and math.clamp(math.floor(vp.Y * 0.52), 200, 310) or math.min(520, math.floor(vp.Y * 0.80))

	local Panel = Instance.new("Frame")
	Panel.Name = "Panel"
	Panel.Active = true
	Panel.Size = UDim2.new(0, PANEL_W, 0, PANEL_H)
	local savedMenuPos = _G["_CrystalHub_UI_MenuPos"]
	if savedMenuPos then
	local mx, my = placeInsideViewport(Panel, 0, savedMenuPos.x, 0, savedMenuPos.y)
	Panel.Position = UDim2.new(0, mx, 0, my)
	else
	Panel.Position = UDim2.new(1, -PANEL_W - 20, 0.5, -PANEL_H / 2)
	end
	Panel.BackgroundTransparency = 1
	Panel.BorderSizePixel = 0
	Panel.Visible = false
	Panel.Parent = ScreenGui

	local SidebarHeader = Instance.new("Frame")
	SidebarHeader.Name = "LegacyHeaderStub"
	SidebarHeader.BackgroundTransparency = 1
	SidebarHeader.Visible = false
	SidebarHeader.Parent = Panel
	FPSLabel = Instance.new("TextLabel")
	FPSLabel.BackgroundTransparency = 1
	FPSLabel.Visible = false
	FPSLabel.Parent = SidebarHeader
	PingLabel = Instance.new("TextLabel")
	PingLabel.BackgroundTransparency = 1
	PingLabel.Visible = false
	PingLabel.Parent = SidebarHeader

	local ContentArea = Instance.new("Frame")
	ContentArea.Name = "LegacyContentStub"
	ContentArea.BackgroundTransparency = 1
	ContentArea.Visible = false
	ContentArea.Parent = Panel

	local VYLO_BG_LABELS = { "Plaid", "Batman Grillz", "Batman Money", "Blonde" }
local VYLO_BG_B64 = {
	-- Plaid
	[[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]],
	-- Batman Grillz
	[[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]],
	-- Batman Money
	[[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]],
	-- Blonde
	[[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]],
}

local function decodeB64(data)
	local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
	data = string.gsub(data, '[^'..b..'=]', '')
	return (data:gsub('.', function(x)
		if x == '=' then return '' end
		local r, f = '', (b:find(x) - 1)
		for i = 6, 1, -1 do r = r .. (f % 2^i - f % 2^(i-1) > 0 and '1' or '0') end
		return r
	end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
		if #x ~= 8 then return '' end
		local c = 0
		for i = 1, 8 do c = c + (x:sub(i,i) == '1' and 2^(8-i) or 0) end
		return string.char(c)
	end))
end

local function loadVyloBackground(index)
	index = tonumber(index) or 1
	if index < 1 or index > #VYLO_BG_B64 then index = 1 end
	local file = "VyloBG_" .. tostring(index) .. ".jpg"
	local loader = nil
	pcall(function() if type(getcustomasset) == "function" then loader = getcustomasset end end)
	if not loader then pcall(function() if type(getsynasset) == "function" then loader = getsynasset end end) end
	if loader and type(writefile) == "function" then
		local exists = false
		if type(isfile) == "function" then pcall(function() exists = isfile(file) end) end
		if not exists then
			pcall(function()
				local raw = decodeB64(VYLO_BG_B64[index])
				if raw and #raw > 500 then writefile(file, raw) end
			end)
		end
		local ok, asset = pcall(loader, file)
		if ok and type(asset) == "string" and asset ~= "" then return asset end
	end
	return ""
end

	-- Custom panel backgrounds (Plaid default). Halloween themes stay separate.
	local backgroundIds = {}
	for i = 1, #VYLO_BG_B64 do
		backgroundIds[i] = loadVyloBackground(i)
	end
	local bgIndex = tonumber(_G["_CrystalHub_UI_BgIndex"]) or 1
	if type(bgIndex) ~= "number" or bgIndex < 1 or bgIndex > #backgroundIds then bgIndex = 1 end
	local BgImage = Instance.new("ImageLabel")
	BgImage.Name = "LegacyBackgroundStub"
	BgImage.BackgroundTransparency = 1
	BgImage.Image = backgroundIds[bgIndex] or ""
	BgImage.Visible = false
	BgImage.Parent = Panel
	local HeaderBgBtn = Instance.new("TextButton")
	HeaderBgBtn.Name = "LegacyBackgroundButtonStub"
	HeaderBgBtn.Visible = false
	HeaderBgBtn.Parent = Panel

	do
	local fpsBoostDescConn = nil
	local fpsBoostCharConn = nil
	local fpsBoostActive = false
	local fpsBoostWalkCancel = nil

	local function applyFPSDerender(obj)
	pcall(function()
	if _G.__CrystalPreserveOptimizerUI(obj) then return end

	local ok, inLighting = pcall(function() return obj:IsDescendantOf(game:GetService("Lighting")) end)
	if ok and inLighting then return end
	if obj:IsA("Sky") or obj:IsA("Atmosphere") or obj:IsA("ColorCorrectionEffect") or obj:IsA("BloomEffect") or obj:IsA("BlurEffect") or obj:IsA("SunRaysEffect") or obj:IsA("DepthOfFieldEffect") then return end

	local ok2, inChar = pcall(function()
	local p = obj
	while p and p ~= workspace do
	if p.Name == "Headless_Headless" or p.Name:find("^Korblox_") then return true end
	p = p.Parent
	end
	return false
	end)
	if ok2 and inChar then return end
	if obj:IsA("Accessory") or obj:IsA("Hat") then
	obj:Destroy()
	elseif obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") or obj:IsA("BodyColors") or obj:IsA("CharacterMesh") then
	obj:Destroy()
	elseif obj:IsA("BasePart") then
	obj.Material = Enum.Material.Plastic
	obj.Reflectance = 0
	obj.CastShadow = false
	elseif obj:IsA("Decal") or obj:IsA("Texture") then

	obj.Transparency = 1
	elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam") or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
	obj.Enabled = false
	elseif obj:IsA("AnimationController") or obj:IsA("Animator") then

	local ancestor = obj.Parent
	while ancestor and ancestor ~= workspace do
	if ancestor:IsA("Model") and Players:GetPlayerFromCharacter(ancestor) then return end
	ancestor = ancestor.Parent
	end
	for _, t in ipairs(obj:GetPlayingAnimationTracks()) do
	pcall(function() t:Stop(0) end)
	end
	end
	end)
	end

	local function processAllDescendants()
	if fpsBoostWalkCancel then fpsBoostWalkCancel() end
	fpsBoostWalkCancel = _G.__CrystalWalkDescendantsBatched(workspace, applyFPSDerender, function()
	return fpsBoostActive
	end)
	end

	local function startFPSBoost()
	if fpsBoostActive then return end
	fpsBoostActive = true

if fpsBoostDescConn then fpsBoostDescConn:Disconnect() end
	fpsBoostDescConn = workspace.DescendantAdded:Connect(function(obj)
	if fpsBoostActive then
	applyFPSDerender(obj)
	end
end)
processAllDescendants()

if fpsBoostCharConn then fpsBoostCharConn:Disconnect() end
	fpsBoostCharConn = Player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	if fpsBoostActive then
	_G.__CrystalWalkDescendantsBatched(char, applyFPSDerender, function() return fpsBoostActive end)
	end
	end)

end

	local function stopFPSBoost()
	if not fpsBoostActive then return end
	fpsBoostActive = false
	if fpsBoostWalkCancel then fpsBoostWalkCancel(); fpsBoostWalkCancel = nil end

	if fpsBoostDescConn then
	fpsBoostDescConn:Disconnect()
	fpsBoostDescConn = nil
	end
	if fpsBoostCharConn then
	fpsBoostCharConn:Disconnect()
	fpsBoostCharConn = nil
	end
	end

	_G.__refreshFPSBoost = startFPSBoost
	_G.__stopFPSBoost = stopFPSBoost

	FeaturePostToggle["FPS Boost"] = function(active)
	if active then startFPSBoost() else stopFPSBoost() end
	end

	end

	;(function()
	local active, generation = false, 0
	local connections = {}
	local saved = setmetatable({}, { __mode = "k" })
	local detached = {}
	local animators = setmetatable({}, { __mode = "k" })
	local stoppedTracks = setmetatable({}, { __mode = "k" })
	local scanCancel = nil

	local function change(object, property, value)
	pcall(function()
	local original = object[property]
	if original == value then return end
	object[property] = value
	local properties = saved[object]
	if not properties then properties = {}; saved[object] = properties end
	if not properties[property] then properties[property] = { value = original } end
	end)
	end

	local function isProtectedVisual(object)
	local char = Player.Character
	if char and (object == char or object:IsDescendantOf(char)) then return true end

	local parent = object
	while parent and parent ~= workspace do
	if parent:IsA("LayerCollector") or parent:IsA("GuiObject")
	or parent:IsA("GuiBase2d") then return true end
	local name = parent.Name or ""
	if name:match("^Crystal") or name:match("^__Crystal") or name:match("^Eclipse")
	or name:match("^ESP_") or name:match("^Korblox_")
	or name == "Headless_Headless" or name == "GreenDuelsBB"
	or name == "PredictionSphere" then return true end
	parent = parent.Parent
	end
	if toggleStates["Sky Changer"] and (object == Lighting or object:IsDescendantOf(Lighting)) then return true end
	return false
	end

	local function stopAnimations(animator)
	if animators[animator] then return end

	local char = Player.Character
	if char and animator:IsDescendantOf(char) then return end
	animators[animator] = true
	local token = generation
	local ok, connection = pcall(function()
	return animator.AnimationPlayed:Connect(function(track)
	if not active or generation ~= token then return end

	task.defer(function()
	if active and generation == token then pcall(function() track:Stop(0) end) end
	end)
	end)
	end)
	if ok then table.insert(connections, connection) end
	pcall(function()
	for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
	if track.IsPlaying then
	stoppedTracks[track] = { animator = animator, time = track.TimePosition, speed = track.Speed }
	track:Stop(0)
	end
	end
	end)
	end

	local function apply(object)
	if not active or isProtectedVisual(object) then return end
	if object:IsA("Terrain") then
	change(object, "Decoration", false)
	change(object, "WaterWaveSize", 0)
	change(object, "WaterWaveSpeed", 0)
	change(object, "WaterReflectance", 0)
	change(object, "WaterTransparency", 1)
	end
	if object:IsA("BasePart") then
	change(object, "Material", Enum.Material.Plastic)
	change(object, "MaterialVariant", "")
	change(object, "Reflectance", 0)
	change(object, "CastShadow", false)
	if object:IsA("MeshPart") then
	change(object, "TextureID", "")
	change(object, "RenderFidelity", Enum.RenderFidelity.Performance)
	change(object, "DoubleSided", false)
	elseif object:IsA("PartOperation") then
	change(object, "RenderFidelity", Enum.RenderFidelity.Performance)
	end
	elseif object:IsA("SpecialMesh") then
	change(object, "TextureId", "")
	elseif object:IsA("SurfaceAppearance") then
	detached[object] = true
	change(object, "Parent", nil)
	elseif object:IsA("Decal") or object:IsA("Texture") then
	change(object, "Transparency", 1)
	change(object, "Texture", "")
	elseif object:IsA("ParticleEmitter") then
	change(object, "Enabled", false)
	change(object, "Rate", 0)
	pcall(function() object:Clear() end)
	elseif object:IsA("Trail") then
	change(object, "Enabled", false)
	pcall(function() object:Clear() end)
	elseif object:IsA("Beam") or object:IsA("Fire") or object:IsA("Smoke")
	or object:IsA("Sparkles") or object:IsA("Light") or object:IsA("PostEffect")
	or object:IsA("Clouds") then
	change(object, "Enabled", false)
	elseif object:IsA("Atmosphere") then
	change(object, "Density", 0)
	change(object, "Haze", 0)
	change(object, "Glare", 0)
	elseif object:IsA("Sky") then
	for _, face in ipairs({"SkyboxBk", "SkyboxDn", "SkyboxFt", "SkyboxLf", "SkyboxRt", "SkyboxUp", "SunTextureId", "MoonTextureId"}) do
	change(object, face, "")
	end
	change(object, "StarCount", 0)
	change(object, "CelestialBodiesShown", false)
	elseif object:IsA("Shirt") then
	change(object, "ShirtTemplate", "")
	elseif object:IsA("Pants") then
	change(object, "PantsTemplate", "")
	elseif object:IsA("ShirtGraphic") then
	change(object, "Graphic", "")
	elseif object:IsA("Animator") then
	stopAnimations(object)
	end
	end

	local function applyLighting()
	if toggleStates["Sky Changer"] then return end
	change(Lighting, "GlobalShadows", false)
	change(Lighting, "EnvironmentDiffuseScale", 0)
	change(Lighting, "EnvironmentSpecularScale", 0)
	change(Lighting, "FogStart", 0)
	change(Lighting, "FogEnd", 1e10)
	end

	local function stop()
	if not active then return end
	active = false
	generation = generation + 1
	if scanCancel then scanCancel(); scanCancel = nil end
	for _, connection in ipairs(connections) do pcall(function() connection:Disconnect() end) end
	connections = {}

	for object, properties in pairs(saved) do
	for property, original in pairs(properties) do
	pcall(function() object[property] = original.value end)
	end
	end
	saved = setmetatable({}, { __mode = "k" })
	detached = {}
	animators = setmetatable({}, { __mode = "k" })
	for track, state in pairs(stoppedTracks) do
	pcall(function()
	if state.animator.Parent and not track.IsPlaying then
	track:Play(0, 1, state.speed)
	track.TimePosition = state.time
	end
	end)
	end
	stoppedTracks = setmetatable({}, { __mode = "k" })
	end

	FeaturePostToggle["Anti Lag"] = function(enabled)
	if not enabled then stop(); return end
	if active then return end
	active = true
	generation = generation + 1
	local token = generation
	applyLighting()
	pcall(function() change(settings().Rendering, "QualityLevel", Enum.QualityLevel.Level01) end)
	pcall(function()
	change(UserSettings():GetService("UserGameSettings"), "SavedQualityLevel", Enum.SavedQualitySetting.QualityLevel1)
	end)
	for _, root in ipairs({ workspace, Lighting }) do
	table.insert(connections, root.DescendantAdded:Connect(function(object)
	task.defer(function()
	if active and generation == token then pcall(apply, object) end
	end)
	end))
	end
	table.insert(connections, Lighting.Changed:Connect(function(property)
	if active and (property == "GlobalShadows" or property == "EnvironmentDiffuseScale"
	or property == "EnvironmentSpecularScale" or property == "FogStart" or property == "FogEnd") then
	applyLighting()
	end
	end))
	if scanCancel then scanCancel() end
	scanCancel = _G.__CrystalWalkDescendantsBatched({ workspace, Lighting }, apply, function()
	return active and generation == token
	end)
	end
	_G.__CrystalTrackStopper(stop)

	end)()

	do
	local currentFps, currentPing = 0, 0
	local fpsFrames = 0
	local fpsWindowStart = os.clock()
	local topFpsConn = nil

	local function safeGetPing()
	local ok, ping = pcall(function() return Player:GetNetworkPing() * 1000 end)
	if ok and type(ping) == "number" then return math.floor(ping + 0.5) end
	return 0
	end

	local function updateTopLabel()
	if FPSLabel then FPSLabel.Text = tostring(currentFps) .. " FPS" end
	if PingLabel then PingLabel.Text = tostring(currentPing) .. " MS" end
	if StatsRightFps then
		if StatsRightPing and StatsRightPing.Visible then
			StatsRightFps.Text = "FPS " .. tostring(currentFps)
			StatsRightPing.Text = "PING " .. tostring(currentPing) .. "ms"
		else
			StatsRightFps.Text = "FPS " .. tostring(currentFps) .. "  PING " .. tostring(currentPing) .. "ms"
		end
	end
	end

	if topFpsConn then return end
	fpsFrames = 0
	fpsWindowStart = os.clock()
	-- Count real rendered frames with os.clock() (more accurate than summing dt)
	topFpsConn = _G.__CrystalTrackConn(RunService.RenderStepped:Connect(function()
		fpsFrames = fpsFrames + 1
		local now = os.clock()
		local elapsed = now - fpsWindowStart
		if elapsed >= 0.5 then
			currentFps = math.max(0, math.floor(fpsFrames / elapsed + 0.5))
			fpsFrames = 0
			fpsWindowStart = now
			currentPing = safeGetPing()
			updateTopLabel()
		end
	end))

	end

	do
	local enemyWidget = nil
	local enemyWidgetDragging, enemyWidgetDragStart, enemyWidgetStartPos = false, nil, nil
	local enemyWidgetPos = _G["_CrystalHub_UI_EnemyWidgetPos"] or { x = 140, y = -340 }
	_G.__CrystalGuiPositionResetters.EnemyWidget = function()
	enemyWidgetDragging = false
	enemyWidgetPos = { x = 140, y = -340 }
	_G["_CrystalHub_UI_EnemyWidgetPos"] = nil
	if enemyWidget and enemyWidget.Parent then
	enemyWidget.Position = UDim2.fromOffset(enemyWidgetPos.x, enemyWidgetPos.y)
	end
	end
	local enemyRagdollCountdown = 0
	local trackedEnemy = nil
	local trackedEnemyId = nil
	local lastEnemyRagdollState = false
	local cachedTimerLbl = nil
	local cachedEnemyHum = nil
	local lastTimerText = ""
	local lastWidgetVisible = nil

	_G.__CrystalGetVisualEnemy = function()
	if trackedEnemy and trackedEnemy.Parent == Players then return trackedEnemy end
	return nil
	end

	local function createEnemyWidget()
	if enemyWidget and enemyWidget.Parent then return enemyWidget end

	enemyWidget = Instance.new("Frame", ScreenGui)
	enemyWidget.Name = "CrystalEnemyWidget"
	enemyWidget.Size = UDim2.new(0, 140, 0, 80)
	enemyWidget.Position = UDim2.new(0, enemyWidgetPos.x, 0, enemyWidgetPos.y)
	_G.__enemyWidget = enemyWidget
	_G.__CrystalRegisterThemeRoot(enemyWidget)
	enemyWidget.BackgroundTransparency = 0.15
	enemyWidget.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	enemyWidget.ZIndex = 600
	enemyWidget.Visible = false
	Instance.new("UICorner", enemyWidget).CornerRadius = UDim.new(0, 8)
	local stroke = Instance.new("UIStroke", enemyWidget)
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Thickness = 1

	local titleLbl = Instance.new("TextLabel", enemyWidget)
	titleLbl.Name = "EWTitle"
	titleLbl.Size = UDim2.new(1, -10, 0, 14)
	titleLbl.Position = UDim2.new(0, 8, 0, 4)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = "RIVAL"
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextSize = 10
	titleLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.ZIndex = 601

	local avatarImg = Instance.new("ImageLabel", enemyWidget)
	avatarImg.Name = "EWAvatar"
	avatarImg.Size = UDim2.new(0, 44, 0, 44)
	avatarImg.Position = UDim2.new(0, 6, 0, 20)
	avatarImg.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
	avatarImg.BorderSizePixel = 0
	avatarImg.Image = ""
	avatarImg.ZIndex = 601
	Instance.new("UICorner", avatarImg).CornerRadius = UDim.new(0, 6)
	local avatarStroke = Instance.new("UIStroke", avatarImg)
	avatarStroke.Color = Color3.fromRGB(180, 180, 180)
	avatarStroke.Thickness = 1

	local nameLbl = Instance.new("TextLabel", enemyWidget)
	nameLbl.Name = "EWName"
	nameLbl.Size = UDim2.new(1, -60, 0, 18)
	nameLbl.Position = UDim2.new(0, 56, 0, 22)
	nameLbl.BackgroundTransparency = 1
	nameLbl.Text = "---"
	nameLbl.Font = Enum.Font.GothamBold
	nameLbl.TextSize = 13
	nameLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
	nameLbl.TextXAlignment = Enum.TextXAlignment.Left
	nameLbl.TextScaled = false

	local timerLbl = Instance.new("TextLabel", enemyWidget)
	timerLbl.Name = "EWTimer"
	timerLbl.Size = UDim2.new(1, -60, 0, 20)
	timerLbl.Position = UDim2.new(0, 56, 0, 44)
	timerLbl.BackgroundTransparency = 1
	timerLbl.Text = ""
	timerLbl.Font = Enum.Font.GothamBlack
	timerLbl.TextSize = 16
	timerLbl.TextColor3 = Color3.fromRGB(255, 221, 0)
	timerLbl.TextXAlignment = Enum.TextXAlignment.Left
	timerLbl.ZIndex = 601

	enemyWidget.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
	enemyWidgetDragging = true
	enemyWidgetDragStart = inp.Position
	enemyWidgetStartPos = enemyWidget.Position
	inp.Changed:Connect(function()
	if inp.UserInputState == Enum.UserInputState.End then
	enemyWidgetDragging = false
	enemyWidgetPos.x = enemyWidget.Position.X.Offset
	enemyWidgetPos.y = enemyWidget.Position.Y.Offset
	_G["_CrystalHub_UI_EnemyWidgetPos"] = { x = enemyWidgetPos.x, y = enemyWidgetPos.y }
	saveConfig()
	end
	end)
	end
	end)
	_G.__CrystalTrackConn(UserInputService.InputChanged:Connect((function(inp)
	if not enemyWidgetDragging then return end
	if inp.UserInputType ~= Enum.UserInputType.MouseMovement and inp.UserInputType ~= Enum.UserInputType.Touch then return end
	local delta = inp.Position - enemyWidgetDragStart
	local vs = workspace.CurrentCamera.ViewportSize
	local nx = math.clamp(enemyWidgetStartPos.X.Offset + delta.X, 0, vs.X - enemyWidget.AbsoluteSize.X)
	local ny = math.clamp(enemyWidgetStartPos.Y.Offset + delta.Y, 0, vs.Y - enemyWidget.AbsoluteSize.Y)
	enemyWidget.Position = UDim2.new(0, nx, 0, ny)
	end)))

	return enemyWidget
	end

	local function loadEnemyThumbnail(userId)
	local w = createEnemyWidget()
	local avatarImg = w:FindFirstChild("EWAvatar")
	if not avatarImg then return end
	avatarImg.Image = ""
	task.spawn(function()
	local ok, img = pcall(function()
	return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size48x48)
	end)
	if ok and img and avatarImg and avatarImg.Parent then
	avatarImg.Image = img
	end
	end)
	end

	local function setTrackedEnemy(player)
	if player and trackedEnemy and player.UserId == trackedEnemyId then return end
	if not player and not trackedEnemy then return end
	trackedEnemy = player
	lastEnemyRagdollState = false
	cachedEnemyHum = nil

	local w = createEnemyWidget()
	local nameLbl = w:FindFirstChild("EWName")
	cachedTimerLbl = w:FindFirstChild("EWTimer")

	if player then
	trackedEnemyId = player.UserId
	if nameLbl then nameLbl.Text = player.Name end
	if cachedTimerLbl then cachedTimerLbl.Text = ""; lastTimerText = "" end
	loadEnemyThumbnail(player.UserId)
	w.Visible = true; lastWidgetVisible = true
	else
	trackedEnemyId = nil
	if nameLbl then nameLbl.Text = "---" end
	if cachedTimerLbl then cachedTimerLbl.Text = ""; lastTimerText = "" end
	local avatarImg = w:FindFirstChild("EWAvatar")
	if avatarImg then avatarImg.Image = "" end
	w.Visible = false; lastWidgetVisible = false
	end
	end

	local function updateEnemyTimer(dt)
	if enemyRagdollCountdown > 0 then
	enemyRagdollCountdown = math.max(0, enemyRagdollCountdown - dt)
	end
	local timerLbl = cachedTimerLbl
	if not timerLbl or not timerLbl.Parent then return end
	if enemyRagdollCountdown > 0 then
	local newText = string.format("%.1fs", enemyRagdollCountdown)
	if newText ~= lastTimerText then
	timerLbl.Text = newText
	timerLbl.TextColor3 = Color3.fromRGB(255, 221, 0)
	lastTimerText = newText
	end
	elseif lastTimerText ~= "" then
	timerLbl.Text = ""
	lastTimerText = ""
	end
	end

	local ewLastScan = 0
	local ewTimerAcc = 0
	_G.__CrystalTrackConn(RunService.Heartbeat:Connect((function(dt)

	ewTimerAcc = ewTimerAcc + (dt or 0)
	if trackedEnemy and ewTimerAcc >= 0.20 then
	updateEnemyTimer(ewTimerAcc)
	ewTimerAcc = 0
	elseif not trackedEnemy and ewTimerAcc >= 0.20 then
	ewTimerAcc = 0
	end

	local now = os.clock()
	if now - ewLastScan < 0.25 then return end
	ewLastScan = now

	local myChar = Player.Character
	local myHRP = myChar and myChar:FindFirstChild("HumanoidRootPart")
	if not myHRP then return end

	local myPos = myHRP.Position
	local closest = nil
	local closestDist = math.huge
	for _, plr in ipairs(Players:GetPlayers()) do
	local character = plr ~= Player and plr.Character
	if character then
	local hrp = character:FindFirstChild("HumanoidRootPart")
	if hrp then
	local position = hrp.Position
	local dx = myPos.X - position.X
	local dy = myPos.Y - position.Y
	local dz = myPos.Z - position.Z
	local d = dx*dx + dy*dy + dz*dz
	if d < closestDist then
	closestDist = d
	closest = plr
	end
	end
	end
	end

	if closest ~= trackedEnemy then
	setTrackedEnemy(closest)
	end

	local w = enemyWidget
	if w and w.Parent then
	local shouldShow = closest ~= nil
	if shouldShow ~= lastWidgetVisible then
	w.Visible = shouldShow
	lastWidgetVisible = shouldShow
	end
	end

	if trackedEnemy then
	local nameLbl = w and w:FindFirstChild("EWName")
	if nameLbl then
	if trackedEnemy:GetAttribute("Stealing") == true then
	nameLbl.TextColor3 = Color3.fromRGB(255, 60, 60)
	else
	nameLbl.TextColor3 = Color3.fromRGB(180, 180, 180)
	end
	end
	end

	if trackedEnemy and trackedEnemy.Character then
	if not cachedEnemyHum or not cachedEnemyHum.Parent then
	cachedEnemyHum = trackedEnemy.Character:FindFirstChildOfClass("Humanoid")
	end
	if cachedEnemyHum then
	local state = cachedEnemyHum:GetState()
	local isRagdolled = (
	state == Enum.HumanoidStateType.Physics or
	state == Enum.HumanoidStateType.Ragdoll or
	state == Enum.HumanoidStateType.FallingDown
	)
	if isRagdolled and not lastEnemyRagdollState then
	enemyRagdollCountdown = 3.0
	elseif isRagdolled and enemyRagdollCountdown < 0.5 then

	enemyRagdollCountdown = 0.5
	end
	lastEnemyRagdollState = isRagdolled
	end
	end
	end)))

	_G["_CrystalHub_EnemyWidget_SaveHook"] = function()
	if enemyWidget and enemyWidget.Parent then
	enemyWidgetPos.x = enemyWidget.Position.X.Offset
	enemyWidgetPos.y = enemyWidget.Position.Y.Offset
	_G["_CrystalHub_UI_EnemyWidgetPos"] = { x = enemyWidgetPos.x, y = enemyWidgetPos.y }
	end
	end

	createEnemyWidget()
	end

	local function makeUraniumSection(parent, title)
	local section = Instance.new("Frame")
	section.Name = (title and tostring(title) or "Section") .. "SectionStub"
	section.BackgroundTransparency = 1
	section.Visible = false
	section.Parent = parent
	return section
	end

	local function makeToggle(parent, text, featureName, buildExtensionContent)
	local container = Instance.new("Frame")
	container.Name = tostring(featureName or text or "Toggle") .. "Stub"
	container.BackgroundTransparency = 1
	container.Visible = false
	container.Parent = parent
	if buildExtensionContent then
	local card = Instance.new("TextButton")
	card.Text = ""
	card.Parent = container
	local extension = Instance.new("Frame")
	extension.BackgroundTransparency = 1
	extension.Parent = container
	buildExtensionContent(extension)
	end
	return container
	end

	local function makeToggleNoKeybind(parent, text, featureName)
	local container = Instance.new("Frame")
	container.Name = tostring(featureName or text or "Toggle") .. "Stub"
	container.BackgroundTransparency = 1
	container.Visible = false
	container.Parent = parent
	return container
	end

	local function selectMode(mode)

	toggleStates["Speed Boost"] = true
	if _G.__refreshSpeedBoost then pcall(_G.__refreshSpeedBoost) end
	if selectedMode == mode then
	if carrySpeedMode == "v2" then
	speedToggled = not speedToggled
	toggleStates["Carry Speed"] = speedToggled
	if toggleVisualUpdaters["Carry Speed"] then toggleVisualUpdaters["Carry Speed"]() end
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	pcall(function() if _G.__refreshSpeedBoost then _G.__refreshSpeedBoost() end end)
	saveConfig()
	end
	return
	end

	if _G.__CrystalResetSpeedDirection then pcall(_G.__CrystalResetSpeedDirection) end
	selectedMode = mode
	if mode == "Lagger" then
	laggerEnabled = true
	else
	laggerEnabled = false
	end
	for _, ref in ipairs(_speedCardRefs) do
	if ref.updateVisual then pcall(ref.updateVisual) end
	end
	saveConfig()
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	end

	FeatureToggles = FeatureToggles or {}
	FeatureToggles["SelectNormalMode"] = function() selectMode("Normal") end
	FeatureToggles["SelectLaggerMode"] = function() selectMode("Lagger") end
	FeatureToggles["SelectDesyncMode"] = function() selectMode("Desync") end
	FeatureToggles["Toggle UI"] = function()

	if _G.__setPanelVisible then
	_G.__setPanelVisible(not Panel.Visible)
	else
	panelVisible = not Panel.Visible
	Panel.Visible = panelVisible
	toggleStates["Toggle UI"] = panelVisible
	end
	if toggleVisualUpdaters["Toggle UI"] then toggleVisualUpdaters["Toggle UI"]() end
	saveConfig()
	end
	local function getSelectedBoostSpeed()
	if selectedMode == "Lagger" or laggerEnabled then
	return speedValues.LaggerBoost or laggerSpeed
	elseif selectedMode == "Desync" then
	return speedValues.DesyncBoost or normalSpeed
	end
	for _, cs in ipairs(customSpeeds) do
	if selectedMode == cs.name then return cs.boost end
	end
	return speedValues.NormalBoost or normalSpeed
	end

	local AntiRagdollV2 = {
	Enabled = false,
	Connection = nil,
	ResetCooldown = 0,
	}

	local function startAntiRagdoll()
	if AntiRagdollV2.Connection then return end
	AntiRagdollV2.Enabled = true
	AntiRagdollV2.Connection = RunService.Heartbeat:Connect((function()
	if not toggleStates["Anti Ragdoll"] then return end
	local char = Player.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if not hum or not root or hum.Health <= 0 then return end

	if _G.dropActive then return end
	local state = hum:GetState()
	local now = tick()
	if state == Enum.HumanoidStateType.Physics or
	state == Enum.HumanoidStateType.Ragdoll or
	state == Enum.HumanoidStateType.FallingDown then
	if now - AntiRagdollV2.ResetCooldown > 0.15 then
	AntiRagdollV2.ResetCooldown = now
	pcall(function()
	hum:ChangeState(Enum.HumanoidStateType.GettingUp)
	root.Velocity = Vector3.zero
	root.RotVelocity = Vector3.zero
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	for _, obj in ipairs(char:GetDescendants()) do
	if obj:IsA("Motor6D") then obj.Enabled = true end
	if obj:IsA("Constraint") then obj.Enabled = true end
	end
	workspace.CurrentCamera.CameraSubject = hum
	local PM = Player.PlayerScripts:FindFirstChild("PlayerModule")
	if PM then
	local CM = require(PM:FindFirstChild("ControlModule"))
	if CM then CM:Enable() end
	end
	hum.AutoRotate = true
	hum.PlatformStand = false
	hum.Sit = false
	end)
	end
	end
	end))
	end

local function stopAntiRagdoll()
	AntiRagdollV2.Enabled = false
	if AntiRagdollV2.Connection then
	AntiRagdollV2.Connection:Disconnect()
	AntiRagdollV2.Connection = nil
	end
end
_G.__CrystalTrackStopper(stopAntiRagdoll)
FeaturePostToggle["Anti Ragdoll"] = function(active)
if active then startAntiRagdoll() else stopAntiRagdoll() end
end

	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(newChar)
	task.wait(0.5)
	if toggleStates["Anti Ragdoll"] then
	if AntiRagdollV2.Connection then
	AntiRagdollV2.Connection:Disconnect()
	AntiRagdollV2.Connection = nil
	end
	startAntiRagdoll()
	end
	end))

if toggleStates["Anti Ragdoll"] then startAntiRagdoll() end

	do

	local AntiBat = {
	Connection = nil,
	RagdollConnection = nil,
	}

	local function stopAntiBat()
	if AntiBat.Connection then
	AntiBat.Connection:Disconnect()
	AntiBat.Connection = nil
	end
	if AntiBat.RagdollConnection then
	AntiBat.RagdollConnection:Disconnect()
	AntiBat.RagdollConnection = nil
	end
	end

	local function startAntiBatVelocity()
	local char = Player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root then return end
	if AntiBat.Connection then AntiBat.Connection:Disconnect() end
	AntiBat.Connection = RunService.Heartbeat:Connect((function()
	if not toggleStates["Anti Bat"] or not root.Parent then return end
	local originalXZ = Vector3.new(root.Velocity.X, 0, root.Velocity.Z)
	root.Velocity = Vector3.new(1000, root.Velocity.Y, 1000)
	RunService.RenderStepped:Wait()
	if root.Parent then
	root.Velocity = Vector3.new(originalXZ.X, root.Velocity.Y, originalXZ.Z)
	end
	end))
	end

	local function startAntiBatRagdoll()
	if AntiBat.RagdollConnection then return end
	AntiBat.RagdollConnection = RunService.Heartbeat:Connect((function()
	if not toggleStates["Anti Bat"] then return end
	local char = Player.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local root = char:FindFirstChild("HumanoidRootPart")
	if hum then
	local state = hum:GetState()
	if state == Enum.HumanoidStateType.Physics
	or state == Enum.HumanoidStateType.Ragdoll
	or state == Enum.HumanoidStateType.FallingDown then
	hum:ChangeState(Enum.HumanoidStateType.Running)
	workspace.CurrentCamera.CameraSubject = hum
	pcall(function()
	local playerModule = Player.PlayerScripts:FindFirstChild("PlayerModule")
	if playerModule then
	require(playerModule:FindFirstChild("ControlModule")):Enable()
	end
	end)
	if root then
	root.Velocity = Vector3.new(0, 0, 0)
	root.RotVelocity = Vector3.new(0, 0, 0)
	end
	end
	end
	for _, object in ipairs(char:GetDescendants()) do
	if object:IsA("Motor6D") and not object.Enabled then
	object.Enabled = true
	end
	end
	end))
	end

	local function startAntiBat()
	stopAntiBat()
	startAntiBatVelocity()
	startAntiBatRagdoll()
	end

	_G.__CrystalTrackStopper(stopAntiBat)
	FeaturePostToggle["Anti Bat"] = function(active)
		toggleStates["Anti Bat"] = false
		stopAntiBat()
	end
	stopAntiBat()
	end

	local function getSelectedStealSpeed()
	if selectedMode == "Lagger" or laggerEnabled then
	return speedValues.LaggerSteal or carrySpeed
	elseif selectedMode == "Desync" then
	return speedValues.DesyncSteal or carrySpeed
	end
	for _, cs in ipairs(customSpeeds) do
	if selectedMode == cs.name then return cs.steal end
	end
	return speedValues.NormalSteal or carrySpeed
	end

	local function shouldUseStealSpeed(isStealing)
	return speedToggled or (isStealing and toggleStates["Auto Carry Speed"])
	end

	do

	local oldSpeedState = _G.__CrystalSpeedSpoofState
	if type(oldSpeedState) == "table" then oldSpeedState.enabled = false end
	local s2State = _G.__CrystalS2SpeedState
	if type(s2State) ~= "table" then
		s2State = { hooked = false }
		_G.__CrystalS2SpeedState = s2State
	end
	s2State.enabled = false
	s2State.root = nil
	s2State.velChecked = setmetatable({}, { __mode = "k" })

	local function setupVelChecked(character)
		s2State.velChecked = setmetatable({}, { __mode = "k" })
		if not character then s2State.root = nil; return nil end
		local root = character:WaitForChild("HumanoidRootPart", 5)
		if root then
			s2State.root = root
			s2State.velChecked[root] = true
		end
		return root
	end

	local function hookVelHRP(root)
		if not root then return end
		s2State.root = root
		s2State.velChecked[root] = true
		if s2State.hooked then return end
		if type(getrawmetatable) ~= "function" or type(setreadonly) ~= "function"
			or type(newcclosure) ~= "function" or type(checkcaller) ~= "function" then return end
		pcall(function()
			local mt = getrawmetatable(game)
			if not mt then return end
			local originalIndex = rawget(mt, "__index")
			if type(originalIndex) ~= "function" and type(originalIndex) ~= "table" then return end
			local replacementIndex = newcclosure(function(self, key)
				local value
				if type(originalIndex) == "function" then value = originalIndex(self, key)
				else value = originalIndex[key] end
				if not checkcaller() and s2State.velChecked[self]
					and (key == "AssemblyLinearVelocity" or key == "Velocity")
					and typeof(value) == "Vector3" and value.Magnitude > 20 then
					return value.Unit * 20
				end
				return value
			end)
			setreadonly(mt, false)
			mt.__index = replacementIndex
			s2State.hooked = true
			setreadonly(mt, true)
		end)
	end

	local function resetSpeedMovement()
		lastMoveDir = Vector3.zero
		s2State.enabled = false
	end
	_G.__CrystalResetSpeedDirection = function()
		lastMoveDir = Vector3.zero
		local character = Player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if humanoid and root and humanoid.MoveDirection.Magnitude <= 0.05 then
			root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
		end
	end
	local isRagdollState = (function(hum)
		if not hum then return true end
		local st = hum:GetState()
		return hum.PlatformStand or st == Enum.HumanoidStateType.Physics
			or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown
	end)
	local getTargetSpeed = (function(isStealing)
		if shouldUseStealSpeed(isStealing) then return getSelectedStealSpeed() end
		return getSelectedBoostSpeed()
	end)
	local function stopSpeedBoost()
		if _G.__speedBoostConn then _G.__speedBoostConn:Disconnect(); _G.__speedBoostConn = nil end
		resetSpeedMovement()
	end
	local function applyVelocitySpeed(direction, speed)
		local character = Player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local root = character and character:FindFirstChild("HumanoidRootPart")
		if not humanoid or not root or humanoid.Health <= 0 then return end
		if type(speed) ~= "number" or speed ~= speed or speed <= 0 or speed == math.huge then return end

		local verticalVelocity = root.AssemblyLinearVelocity.Y
		if _G._ZurichHub_MovementBlocked == true or _G._CrystalHub_MovementBlocked == true then
			root.AssemblyLinearVelocity = Vector3.new(0, math.min(verticalVelocity, 0), 0)
			return
		end
		if direction and direction.Magnitude > 0.05 then
			pcall(function()
				if root.SetNetworkOwner then root:SetNetworkOwner(Player) end
			end)
			local unit = direction.Unit
			root.AssemblyLinearVelocity = Vector3.new(unit.X * speed, verticalVelocity, unit.Z * speed)
		else
			root.AssemblyLinearVelocity = Vector3.new(0, verticalVelocity, 0)
		end
	end
	local function startSpeedBoost()
		stopSpeedBoost()
		_G.__speedBoostConn = RunService.RenderStepped:Connect(function()
			if not toggleStates["Speed Boost"] then return end
			local character = Player.Character
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			local root = character and character:FindFirstChild("HumanoidRootPart")
			if not humanoid or not root or humanoid.Health <= 0 then return end

			if toggleStates["Autoplay"] or toggleStates["Auto Left"] or toggleStates["Auto Right"]
				or toggleStates["TP Bat"]
				or toggleStates["Aimbot"]
				or _G.dropActive or _G.IsDropping then
				resetSpeedMovement()
				return
			end
			-- Allow speed changes during hit countdown (even while ragdolled)
			if isRagdollState(humanoid) and not _G._CrystalHitCountdownActive then
				lastMoveDir = Vector3.zero
				return
			end
			if s2State.root ~= root or not s2State.velChecked[root] then
				lastMoveDir = Vector3.zero
				setupVelChecked(character)
				hookVelHRP(root)
			end
			s2State.enabled = true
			local direction
			if humanoid.MoveDirection.Magnitude > 0 then
				lastMoveDir = humanoid.MoveDirection
				direction = humanoid.MoveDirection
			elseif lastMoveDir.Magnitude > 0 then
				for key in pairs(MOVE_KEYS) do
					if UserInputService:IsKeyDown(key) then
						direction = lastMoveDir
						break
					end
				end
			end
			local selectedSpeed = getTargetSpeed(Player:GetAttribute("Stealing") == true)
			applyVelocitySpeed(direction, tonumber(selectedSpeed) or 16)
		end)
	end
	local function applySpeedBoostNow()
		if not toggleStates["Speed Boost"] then return end
		local character = Player.Character
		local hum = character and character:FindFirstChildOfClass("Humanoid")
		if not hum or hum.Health <= 0 then return end
		if isRagdollState(hum) and not _G._CrystalHitCountdownActive then return end
		local direction = hum.MoveDirection.Magnitude > 0.05 and hum.MoveDirection or nil
		applyVelocitySpeed(direction, getTargetSpeed(Player:GetAttribute("Stealing") == true))
	end
	local function refreshSpeedBoost()
		if toggleStates["Speed Boost"] then startSpeedBoost() else stopSpeedBoost() end
	end
	_G.__refreshSpeedBoost = refreshSpeedBoost
	_G.__stopSpeedBoost = stopSpeedBoost
	_G.__CrystalTrackStopper(function()
		toggleStates["Speed Boost"] = false
		stopSpeedBoost()
		s2State.root = nil
		_G.__CrystalResetSpeedDirection = nil
	end)
	if Player.Character then
		local initialRoot = setupVelChecked(Player.Character)
		hookVelHRP(initialRoot)
	end
	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(character)
		task.wait(0.5)
		resetSpeedMovement()
		local root = character:WaitForChild("HumanoidRootPart", 5)
		if root then setupVelChecked(character); hookVelHRP(root) end
		if toggleStates["Speed Boost"] then startSpeedBoost() end
	end))
	_G.__CrystalTrackConn(Player.CharacterRemoving:Connect(function()
		stopSpeedBoost()
		s2State.root = nil
		s2State.velChecked = setmetatable({}, { __mode = "k" })
	end))
	FeatureToggles["Speed Boost"] = function()
	if carrySpeedMode == "v2" then

	speedToggled = not speedToggled
	toggleStates["Carry Speed"] = speedToggled

	toggleStates["Speed Boost"] = true
	startSpeedBoost()
	if toggleVisualUpdaters["Carry Speed"] then toggleVisualUpdaters["Carry Speed"]() end
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	saveConfig()
	return
	end
	toggleStates["Speed Boost"] = not toggleStates["Speed Boost"]
	if toggleVisualUpdaters["Speed Boost"] then toggleVisualUpdaters["Speed Boost"]() end
	refreshSpeedBoost(); saveConfig()
	end
	FeaturePostToggle["Speed Boost"] = function(active) if active then startSpeedBoost() else stopSpeedBoost() end end

	FeatureToggles["Carry Speed"] = function()
	toggleStates["Carry Speed"] = not toggleStates["Carry Speed"]
	speedToggled = toggleStates["Carry Speed"]

	toggleStates["Speed Boost"] = true
	startSpeedBoost()
	applySpeedBoostNow()
	if toggleVisualUpdaters["Carry Speed"] then toggleVisualUpdaters["Carry Speed"]() end
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	saveConfig()
	end
	FeaturePostToggle["Carry Speed"] = function(active)
	speedToggled = active
	if active or carrySpeedMode == "v2" then
	toggleStates["Speed Boost"] = true
	startSpeedBoost()
	applySpeedBoostNow()
	end
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	end

	local autoCarryStartedBoost = false
	FeaturePostToggle["Auto Carry Speed"] = function(active)
	if active and not toggleStates["Speed Boost"] then
	toggleStates["Speed Boost"] = true
	autoCarryStartedBoost = true
	startSpeedBoost()
	elseif not active and autoCarryStartedBoost then
	toggleStates["Speed Boost"] = false
	autoCarryStartedBoost = false
	stopSpeedBoost()
	end
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	end

	local sbSetupPending = {}
	local speedLabelCache = setmetatable({}, {__mode = "k"})
	local LOCAL_SPEED_GRADIENT_GUI1 = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(180, 220, 255)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 220, 255)),
	})
	local LOCAL_SPEED_GRADIENT_GUI2 = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(91, 38, 178)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(190, 137, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(139, 72, 246)),
	})

	local function getSpeedThemeGradient(isLocal)
	local curtAccent = _G.__CrystalCurtAccent
	if typeof(curtAccent) == "Color3" then
		local bright = curtAccent:Lerp(Color3.fromRGB(255, 255, 255), 0.22)
		local dark = curtAccent:Lerp(Color3.fromRGB(0, 0, 0), 0.24)
		return ColorSequence.new({
			ColorSequenceKeypoint.new(0, bright),
			ColorSequenceKeypoint.new(0.5, curtAccent),
			ColorSequenceKeypoint.new(1, dark),
		})
	end
	if _G.__CrystalGuiTheme == "GUI 3" then
	return ColorSequence.new(Color3.fromRGB(255, 45, 45), Color3.fromRGB(190, 15, 25))
	end
	if isLocal then
	return _G.__CrystalGuiTheme == "GUI 2" and LOCAL_SPEED_GRADIENT_GUI2 or LOCAL_SPEED_GRADIENT_GUI1
	end
	return ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(230, 230, 230)),
	ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200)),
	})
	end
	local setupSpeedBillboard

	local SPEED_DISPLAY_MAX = 500 -- overhead speed never shows above this
	local function getPlayerSpeedDisplayText(p)
	local char = p.Character
	if not char then return "0" end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return "0" end
	local velocity = hrp.AssemblyLinearVelocity
	local realSpeed = Vector3.new(velocity.X, 0, velocity.Z).Magnitude
	local displaySpeed = realSpeed < 0.5 and 0 or math.min(math.floor(realSpeed + 0.5), SPEED_DISPLAY_MAX)
	if p == Player then
	local isStealing = Player:GetAttribute("Stealing") == true
	local isCarrySpeed = speedToggled or (isStealing and toggleStates["Auto Carry Speed"])
	local humanoid = char:FindFirstChildOfClass("Humanoid")

	if toggleStates["Speed Boost"] and humanoid and humanoid.MoveDirection.Magnitude > 0.05 then
	displaySpeed = math.min(math.floor(getTargetSpeed(isStealing) + 0.5), SPEED_DISPLAY_MAX)
	end
	return tostring(displaySpeed) .. " - " .. (isCarrySpeed and "CARRY" or "NORMAL")
	end
	return tostring(displaySpeed)
	end

	local function requestSpeedBillboard(char, isLocal)
	if not char or not char.Parent then return end
	if sbSetupPending[char] then return end
	sbSetupPending[char] = true
	task.spawn(function()
	setupSpeedBillboard(char, isLocal)
	sbSetupPending[char] = nil
	end)
	end

	setupSpeedBillboard = function(char, isLocal)
	task.wait(0.3)
	local head = char:FindFirstChild("Head")
	if not head then return end
	local old = head:FindFirstChild("GreenDuelsBB")
	if old then old:Destroy() end
	local oldCrystal = head:FindFirstChild("CrystalSpeedBill")
	if oldCrystal then oldCrystal:Destroy() end
	local oldOverhead = head:FindFirstChild("CrystalHubOverhead")
	if oldOverhead then oldOverhead:Destroy() end

	local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
	if torso then local oldTorsoBB = torso:FindFirstChild("GreenDuelsBB")
	if oldTorsoBB then oldTorsoBB:Destroy() end end
	local bb = Instance.new("BillboardGui", head)
	bb.Name = "GreenDuelsBB"
	bb:SetAttribute("CrystalThemeWorldAccent", true)
	bb.Size = isLocal and UDim2.fromOffset(190, 60) or UDim2.fromOffset(130, 42)
	bb.StudsOffset = isLocal and Vector3.new(0, 3.2, 0) or Vector3.new(0, 4.8, 0)
	bb.AlwaysOnTop = true
	bb.LightInfluence = 0
	bb.MaxDistance = 0

	local function applySpeedLabelStyle(lbl, localOnly)
	-- Custom font on overhead (discord + speed) when selected
	local customFont = nil
	pcall(function()
		if _G.CrystalFonts and _G.CrystalFonts.current then
			customFont = _G.CrystalFonts.current()
		end
	end)
	if customFont then
		pcall(function() lbl.FontFace = customFont end)
	else
		lbl.Font = Enum.Font.GothamBlack
	end
	lbl.TextStrokeTransparency = 0
	if localOnly then
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	local stroke = Instance.new("UIStroke", lbl)
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Thickness = 1.5
	stroke.Transparency = 0.2
	local grad = Instance.new("UIGradient")
	grad.Name = "SpeedTextGradient"
	grad.Color = getSpeedThemeGradient(true)
	grad.Parent = lbl
	else
	lbl.TextColor3 = Color3.fromRGB(255, 255, 255)
	local stroke = Instance.new("UIStroke", lbl)
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Thickness = 2
	stroke.Transparency = 0.1
	local grad = Instance.new("UIGradient")
	grad.Name = "SpeedTextGradient"
	grad.Color = getSpeedThemeGradient(false)
	grad.Parent = lbl
	end
	end

	local discordLbl = Instance.new("TextLabel", bb)
	discordLbl.Name = "DiscordBillLbl"
	discordLbl.Size = UDim2.new(1, 0, 0, isLocal and 28 or 22)
	discordLbl.Position = UDim2.new(0, 0, 0, 0)
	discordLbl.BackgroundTransparency = 1
	discordLbl.Text = isLocal and "discord.gg/vylo" or ""
	discordLbl.Visible = isLocal
	discordLbl.TextScaled = false
	discordLbl.TextSize = isLocal and 19 or 15
	applySpeedLabelStyle(discordLbl, isLocal)

	local speedLbl = Instance.new("TextLabel", bb)
	speedLbl.Name = "SpeedBillLbl"
	speedLbl.Size = UDim2.new(1, 0, 0, isLocal and 29 or 20)
	speedLbl.Position = UDim2.new(0, 0, 0, isLocal and 30 or 22)
	speedLbl.BackgroundTransparency = 1
	local owner = Players:GetPlayerFromCharacter(char)
	speedLbl.Text = owner and getPlayerSpeedDisplayText(owner) or "0"
	if owner then speedLabelCache[owner] = speedLbl end
	speedLbl.TextScaled = false
	speedLbl.TextSize = isLocal and 22 or 16
	applySpeedLabelStyle(speedLbl, isLocal)

	-- Register overhead labels with font changer
	pcall(function()
		if _G.CrystalFonts and _G.CrystalFonts.applyOne then
			local f = _G.CrystalFonts.current and _G.CrystalFonts.current() or nil
			_G.CrystalFonts.applyOne(discordLbl, f)
			_G.CrystalFonts.applyOne(speedLbl, f)
		end
	end)

	_G.__CrystalRegisterThemeRoot(bb)
	end

	local function setupForPlayer(p)
	if p.Character then requestSpeedBillboard(p.Character, p == Player) end
	_G.__CrystalTrackConn(p.CharacterAdded:Connect(function(char) requestSpeedBillboard(char, p == Player) end))
	end

	for _, p in ipairs(Players:GetPlayers()) do
	if p ~= Player then setupForPlayer(p) end
	end
	_G.__CrystalTrackConn(Players.PlayerAdded:Connect(function(p) setupForPlayer(p) end))
	if Player.Character then requestSpeedBillboard(Player.Character, true) end
	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(char)

	speedToggled = toggleStates["Carry Speed"] == true
	task.spawn(function()
	requestSpeedBillboard(char, true)
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	end)
	end))

	local sbLastUpdate = 0

	local sbThrottle = 0.25
	local sbLastText = {}

	_G.__CrystalTrackConn(RunService.Heartbeat:Connect((function(dt)
	sbLastUpdate = sbLastUpdate + (dt or 0)
	if sbLastUpdate < sbThrottle then return end
	sbLastUpdate = 0
	for _, p in ipairs(Players:GetPlayers()) do
	local char = p.Character
	if char then
	local sl = speedLabelCache[p]
	if not sl or not sl.Parent then
	speedLabelCache[p] = nil
	requestSpeedBillboard(char, p == Player)
	else
	local newText = getPlayerSpeedDisplayText(p)
	if sbLastText[p.UserId] ~= newText then
	sl.Text = newText
	sbLastText[p.UserId] = newText
	end
	end
	end
	end
	end)))
	_G.__refreshSpeedBillboards = function()
	for _, p in ipairs(Players:GetPlayers()) do
	local char = p.Character
	if char then
	local hrp = char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso")
	local head = char:FindFirstChild("Head")
	local torso = char:FindFirstChild("UpperTorso") or hrp
	if hrp or head then
	local bb = (head and (head:FindFirstChild("Green22sBB") or head:FindFirstChild("GreenDuelsBB")))
		or (torso and (torso:FindFirstChild("Green22sBB") or torso:FindFirstChild("GreenDuelsBB")))
	if bb then
	local sl = bb:FindFirstChild("SpeedBillLbl")
	local dl = bb:FindFirstChild("DiscordBillLbl")
	pcall(function()
		if _G.CrystalFonts and _G.CrystalFonts.applyOne then
			local f = _G.CrystalFonts.current and _G.CrystalFonts.current() or nil
			if sl then _G.CrystalFonts.applyOne(sl, f) end
			if dl then _G.CrystalFonts.applyOne(dl, f) end
		end
	end)
	if sl then
	speedLabelCache[p] = sl
	sl.Text = getPlayerSpeedDisplayText(p)
	do
	local gradientColor = getSpeedThemeGradient(p == Player)
	for _, child in ipairs(bb:GetChildren()) do
	if child:IsA("TextLabel") then
	local gradient = child:FindFirstChild("SpeedTextGradient")
	if gradient then gradient.Color = gradientColor end
	end
	end
	end
	end -- if sl
	end -- if bb
	end -- if hrp or head
	end -- if char
	end -- for
	end

	refreshSpeedBoost()

	-- Clean Hub AP points (Auto Left / Auto Right)
	local autoLeftWaypoints = {
	Vector3.new(-476.48, -6.28, 92.73), -- L1
	Vector3.new(-483.12, -4.95, 94.80), -- L2
	Vector3.new(-482.25, -4.96, 92.09), -- L_FACE
	}
	local autoRightWaypoints = {
	Vector3.new(-476.16, -6.52, 25.62), -- R1
	Vector3.new(-483.06, -5.03, 25.48), -- R2
	Vector3.new(-482.06, -6.93, 35.47), -- R_FACE
	}
	_G.__autoLeftWaypoints = autoLeftWaypoints
	_G.__autoRightWaypoints = autoRightWaypoints

	local autoplayActive = false; local autoplayMode = "none"; local autoplayWPIdx = 1
	local autoplayConn = nil

	_G.__autoplayMode = _G.__autoplayMode or "Full"

	local function getAutoplayModeForMyBase()
	local plots = workspace:FindFirstChild("Plots"); if not plots then return "left" end
	for _, plot in ipairs(plots:GetChildren()) do
	local sign = plot:FindFirstChild("PlotSign"); local yourBase = sign and sign:FindFirstChild("YourBase")
	if yourBase and yourBase.Enabled then
	local target = plot:FindFirstChild("AnimalTarget",true); local refPos = target and target.Position
	if not refPos then local delivery=plot:FindFirstChild("DeliveryHitbox"); refPos=delivery and delivery.Position end
	if refPos then
	if type(autoLeftWaypoints)=="table" and type(autoRightWaypoints)=="table" and autoLeftWaypoints[1] and autoRightWaypoints[1] then
	local leftDist=(refPos-autoLeftWaypoints[1]).Magnitude; local rightDist=(refPos-autoRightWaypoints[1]).Magnitude
	return (leftDist<=rightDist) and "right" or "left"
	end
	end
	do
	local pivotPos = nil
	if typeof(plot.GetPivot) == "function" then
	pcall(function()
	local piv = plot:GetPivot()
	if piv then pivotPos = piv.Position end
	end)
	end
	if pivotPos then
	return (pivotPos.Z>=60) and "right" or "left"
	else
	return (Player and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") and Player.Character:FindFirstChild("HumanoidRootPart").Position.Z>=60) and "right" or "left"
	end
	end
	end
	end
	return "left"
	end

	;(function()
	if _G.__ZurichSetFullNoPlayerCollision then pcall(_G.__ZurichSetFullNoPlayerCollision, false) end
	local npcEnabled = false
	local npcSuspended = false
	local npcConnections = {}
	local npcOriginalCollisions = setmetatable({}, {__mode = "k"})

	local function autoBatControlsPhysics()
	return toggleStates["TP Bat"] == true
	end

	local function disablePartCollision(part)
	if not part:IsA("BasePart") then return end
	if npcOriginalCollisions[part] == nil then
	npcOriginalCollisions[part] = {
	CanCollide = part.CanCollide,
	CanTouch = part.CanTouch,
	}
	end
	if part.CanCollide then part.CanCollide = false end
	if part.CanTouch then part.CanTouch = false end
	end

	local function disableCharacterCollisions(character)
	if not character then return end
	for _, part in ipairs(character:GetDescendants()) do
	disablePartCollision(part)
	end
	end

	local function watchCharacterCollisions(character)
	if autoBatControlsPhysics() then return end
	disableCharacterCollisions(character)
	table.insert(npcConnections, character.DescendantAdded:Connect(function(part)
	if npcEnabled and not npcSuspended and not autoBatControlsPhysics() then disablePartCollision(part) end
	end))
	end

	local function watchPlayerCollisions(plr)
	if plr == Player then return end
	if plr.Character then watchCharacterCollisions(plr.Character) end
	table.insert(npcConnections, plr.CharacterAdded:Connect(function(character)
	if npcEnabled and not npcSuspended and not autoBatControlsPhysics() then watchCharacterCollisions(character) end
	end))
	end

	local function restoreTrackedCollisions()
	for part, original in pairs(npcOriginalCollisions) do
	if part and part.Parent then
	pcall(function()
	part.CanCollide = original.CanCollide
	part.CanTouch = original.CanTouch
	end)
	end
	end
	npcOriginalCollisions = setmetatable({}, {__mode = "k"})
	end

	local alwaysOnAntiFling = (function()
	if _G.dropActive or _G.IsDropping then return end
	local character = Player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not root or not humanoid or humanoid.Health <= 0 then return end
	local velocity = root.AssemblyLinearVelocity
	local horizontal = Vector3.new(velocity.X, 0, velocity.Z)
	local angular = root.AssemblyAngularVelocity
	local intentionalMovement = toggleStates["TP Bat"] == true
		or toggleStates["Aimbot"] == true
		or autoplayActive == true
	local flung = horizontal.Magnitude > 375 or math.abs(velocity.Y) > 300 or angular.Magnitude > 110
	if flung and not intentionalMovement then
	for _, part in ipairs(character:GetDescendants()) do
	if part:IsA("BasePart") then
	part.AssemblyLinearVelocity = Vector3.zero
	part.AssemblyAngularVelocity = Vector3.zero
	end
	end
	end
	end)

	local function enableNoPlayerCollision()
	if npcEnabled then return end
	npcEnabled = true
	npcSuspended = autoBatControlsPhysics()

	if not npcSuspended then
	for _, plr in ipairs(Players:GetPlayers()) do watchPlayerCollisions(plr) end
	end
	table.insert(npcConnections, Players.PlayerAdded:Connect(watchPlayerCollisions))

	table.insert(npcConnections, RunService.Stepped:Connect(function()
	if not npcEnabled then return end
	local shouldSuspend = autoBatControlsPhysics()
	if shouldSuspend then
	if not npcSuspended then
	npcSuspended = true
	restoreTrackedCollisions()
	end
	return
	end
	if npcSuspended then npcSuspended = false end
	for _, plr in ipairs(Players:GetPlayers()) do
	if plr ~= Player and plr.Character then
	disableCharacterCollisions(plr.Character)
	end
	end
	end))
	end

	local function disableNoPlayerCollision()
	if not npcEnabled then return end
	npcEnabled = false
	for _, connection in ipairs(npcConnections) do
	pcall(function() connection:Disconnect() end)
	end
	npcConnections = {}
	restoreTrackedCollisions()
	npcSuspended = false
	end

	_G.__ZurichSetFullNoPlayerCollision = function(active)
	if active then enableNoPlayerCollision() else disableNoPlayerCollision() end
	end
	_G.__setNoPlayerCollision = _G.__ZurichSetFullNoPlayerCollision
	_G.__getNoPlayerCollision = function() return npcEnabled end
	_G.__CrystalTrackStopper(disableNoPlayerCollision)

_G.__CrystalTrackConn(RunService.PostSimulation:Connect(alwaysOnAntiFling))
	enableNoPlayerCollision()
	end)()

	local function killInvisiblePart(part)
	if not part or not part:IsA("BasePart") then return end
	if part.CanCollide and (part.Transparency >= 0.9 or part.LocalTransparencyModifier >= 0.9) then
	part.CanCollide = false
	end
	end
	local function killInvisibleParts(center, radius)
	if not center then return end
	for _, part in ipairs(workspace:GetPartBoundsInRadius(center, radius)) do
	killInvisiblePart(part)
	end
	end
	_G.__killInvisibleNear = killInvisibleParts
	_G.__CrystalTrackConn(workspace.DescendantAdded:Connect(function(part)
	if not (toggleStates["ESP Players"] or toggleStates["Player Tracers"] or toggleStates["Stretchz Res"]) then return end
	killInvisiblePart(part)
	end))
	do

	local invisibleCheckAcc = 0
	local invisibleCheckInterval = 2.0
	local invisibleGlobalAcc = 0
	local invisibleGlobalInterval = 15
	local invisibleGlobalScanCancel = nil
	_G.__CrystalTrackConn(RunService.Heartbeat:Connect((function(dt)
	local hasVisualsActive = toggleStates["ESP Players"] or toggleStates["Player Tracers"] or toggleStates["Stretchz Res"]
	if not hasVisualsActive then return end
	invisibleCheckAcc = invisibleCheckAcc + (dt or 0)
	invisibleGlobalAcc = invisibleGlobalAcc + (dt or 0)
	if invisibleCheckAcc >= invisibleCheckInterval then
	invisibleCheckAcc = 0
	local char = Player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if root then
	for _, part in ipairs(char:GetDescendants()) do
	killInvisiblePart(part)
	end
	local rootVelocity = root.AssemblyLinearVelocity
	local velFlat = Vector3.new(rootVelocity.X, 0, rootVelocity.Z)
	local speed = velFlat.Magnitude
	local radius = math.clamp(20 + speed * 0.2, 20, 40)
	killInvisibleParts(root.Position, radius)
	if speed > 5 then killInvisibleParts(root.Position + velFlat * 0.35, radius) end
	end
	end
	if invisibleGlobalAcc >= invisibleGlobalInterval then
	invisibleGlobalAcc = 0
	if invisibleGlobalScanCancel then invisibleGlobalScanCancel() end
	invisibleGlobalScanCancel = _G.__CrystalWalkDescendantsBatched(workspace, killInvisiblePart, function()
	return toggleStates["ESP Players"] or toggleStates["Player Tracers"] or toggleStates["Stretchz Res"]
	end)
	end
	end)))
	end

	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function()
	awfLastRecovery = 0
	end))

	local autoplayEnabledAutoCarry = false
	local function setAutoplayAutoCarry(active)
	if active then
	if toggleStates["Auto Carry Speed"] then return end
	autoplayEnabledAutoCarry = true
	else
	if not autoplayEnabledAutoCarry then return end
	autoplayEnabledAutoCarry = false
	end

	toggleStates["Auto Carry Speed"] = active
	local setter = toggleStateSetters["Auto Carry Speed"]
	if setter then pcall(setter, active) end
	local postToggle = FeaturePostToggle["Auto Carry Speed"]
	if postToggle then pcall(postToggle, active) end
	local visual = toggleVisualUpdaters["Auto Carry Speed"]
	if visual then pcall(visual) end
	end

	local function setAutoplayToggleUI(state)
	toggleStates["Autoplay"] = state
	local setter = toggleStateSetters["Autoplay"]
	if setter then
	pcall(setter, state)
	return
	end
	local visual = toggleVisualUpdaters["Autoplay"]
	if visual then pcall(visual) end
	end

	local function stopAutoplay(keepToggle)
	if autoplayActive then
	autoplayActive = false
	autoplayMode = "none"
	autoplayWPIdx = 1
	if autoplayConn then autoplayConn:Disconnect(); autoplayConn = nil end
	local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
	if hrp then hrp.Velocity = Vector3.new(0, hrp.Velocity.Y, 0) end
	end
	setAutoplayAutoCarry(false)
	if keepToggle then return end
	if toggleStates["Autoplay"] then
	setAutoplayToggleUI(false)
	saveConfig()
	end
	end
	_G.__stopAutoplay = stopAutoplay
	_G.__CrystalTrackStopper(stopAutoplay)

	local function startAutoplay()
	if autoplayActive then stopAutoplay(true) end
	deactivateOtherAimbots()

	if toggleStates["TP Bat"] and _G.CrystalAutoBat then _G.CrystalAutoBat.SetEnabled(false) end
	local forcedSide = _G.__autoplaySide
	local mode
	if forcedSide == "left" or forcedSide == "right" then
	mode = forcedSide
	else
	mode = getAutoplayModeForMyBase()
	end
	autoplayMode=mode; autoplayWPIdx=1; autoplayActive=true
	setAutoplayAutoCarry(true)

	if not _G.__autoplayMode or (_G.__autoplayMode ~= "Full" and _G.__autoplayMode ~= "Semi") then
	_G.__autoplayMode = "Full"
	end
	if autoplayConn then autoplayConn:Disconnect() end
	autoplayConn = RunService.Heartbeat:Connect((function(dt)
	if not autoplayActive then return end
	setAutoplayAutoCarry(true)
	local waypoints=(autoplayMode=="left") and autoLeftWaypoints or autoRightWaypoints
	if type(waypoints) ~= "table" or not waypoints[1] then return end

	local stopIdx = (_G.__autoplayMode == "Semi") and 2 or #waypoints
	if autoplayWPIdx < 1 then autoplayWPIdx = 1 end
	if autoplayWPIdx > #waypoints then autoplayWPIdx = #waypoints end
	local wp=waypoints[autoplayWPIdx]; if not wp then return end
	local char=Player.Character; if not char then return end
	local hrp=char:FindFirstChild("HumanoidRootPart"); if not hrp then return end
	local hum=char:FindFirstChildOfClass("Humanoid")
	-- Fight hit physics every frame (do not cancel path)
	if hum then
		pcall(function()
			if hum.PlatformStand then hum.PlatformStand = false end
			hum:SetStateEnabled(Enum.HumanoidStateType.FallingDown, false)
			hum:SetStateEnabled(Enum.HumanoidStateType.Ragdoll, false)
			hum:SetStateEnabled(Enum.HumanoidStateType.Physics, false)
			local st = hum:GetState()
			if st == Enum.HumanoidStateType.Physics or st == Enum.HumanoidStateType.Ragdoll or st == Enum.HumanoidStateType.FallingDown then
				hum:ChangeState(Enum.HumanoidStateType.Running)
			end
		end)
	end
	local myPos=hrp.Position
	local targetXZ=Vector3.new(wp.X,0,wp.Z); local myXZ=Vector3.new(myPos.X,0,myPos.Z)
	local dXZ=(targetXZ-myXZ).Magnitude
	local recentHit = tick() < (tonumber(_G.__CrystalAutoplayRecentHitUntil) or 0)
	if dXZ<=1.1 and not recentHit then
	hrp.AssemblyLinearVelocity=Vector3.new(0,hrp.AssemblyLinearVelocity.Y,0)
	if hum then pcall(function() hum:Move(Vector3.zero, false) end) end
	if autoplayWPIdx>=stopIdx then
	if Player:GetAttribute("Stealing") ~= true then stopAutoplay() end
	return
	end
	autoplayWPIdx=autoplayWPIdx+1
	else
	local dir=(targetXZ-myXZ); if dir.Magnitude>0.001 then dir=dir.Unit else dir=Vector3.zero end
	local speed = tonumber(speedValues and speedValues.NormalBoost) or tonumber(normalSpeed) or 59
	speed = math.max(1, speed)
	-- During/after hit, push harder so knockback does not stall the path
	if recentHit then speed = math.max(speed, 45) end
	if dXZ<1.5 and not recentHit then speed=speed*math.clamp(dXZ/1.5,0.6,1) end
	if not recentHit then
		speed=math.min(speed,dXZ/math.max(dt or 1/60,1/240))
	end
	if hum and dir.Magnitude > 0 then pcall(function() hum:Move(dir, false) end) end
	local yv = hrp.AssemblyLinearVelocity.Y
	if recentHit and yv < -5 then yv = math.max(yv, -5) end
	hrp.AssemblyLinearVelocity=Vector3.new(dir.X*speed, yv, dir.Z*speed)
	end
	end))
	end

	_G.__CrystalStartAutoplay = startAutoplay
	_G.__CrystalStopAutoplay = stopAutoplay
	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function() task.wait(0.5); if autoplayActive then startAutoplay() end end))
	FeaturePostToggle["Autoplay"] = function(active)
	if active then
	setAutoplayAutoCarry(true)
	-- Enabled during hit countdown: wait until countdown ends, then start immediately
	if _G._CrystalHitCountdownActive == true then
	_G.__CrystalPendingAutoplayAfterCountdown = true
	return
	end
	_G.__CrystalPendingAutoplayAfterCountdown = false
	_G.__checkAndAutoDrop(function()
	startAutoplay()
	end)
	else
	_G.__CrystalPendingAutoplayAfterCountdown = false
	stopAutoplay()
	end
	end
	FeatureToggles["Autoplay"] = function()
	toggleStates["Autoplay"]=not toggleStates["Autoplay"]
	if toggleStates["Autoplay"] then
	setAutoplayAutoCarry(true)
	if _G._CrystalHitCountdownActive == true then
	_G.__CrystalPendingAutoplayAfterCountdown = true
	if toggleVisualUpdaters["Autoplay"] then toggleVisualUpdaters["Autoplay"]() end
	saveConfig()
	return
	end
	_G.__CrystalPendingAutoplayAfterCountdown = false
	_G.__checkAndAutoDrop(function()
	startAutoplay()
	end)
	else
	_G.__CrystalPendingAutoplayAfterCountdown = false
	stopAutoplay()
	end
	if toggleVisualUpdaters["Autoplay"] then toggleVisualUpdaters["Autoplay"]() end
	saveConfig()
	end
	if toggleStates["Autoplay"] then startAutoplay() end

	-- ============================================================
	-- Auto Left / Auto Right — independent path (hit-proof)
	-- ============================================================
	local sidePath = {
		active = false,
		side = nil,
		wpIdx = 1,
		conn = nil,
		gen = 0,
		recentHitUntil = 0,
	}
	_G.__CrystalSidePath = sidePath

	local function stopSidePath(clearToggles)
		sidePath.gen = (sidePath.gen or 0) + 1
		sidePath.active = false
		local oldSide = sidePath.side
		sidePath.side = nil
		sidePath.wpIdx = 1
		sidePath.phase = 1
		if sidePath.conn then
			pcall(function() sidePath.conn:Disconnect() end)
			sidePath.conn = nil
		end
		pcall(function()
			local char = Player.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			if hum then hum:Move(Vector3.zero, false) end
			if hrp then
				hrp.AssemblyLinearVelocity = Vector3.new(0, hrp.AssemblyLinearVelocity.Y, 0)
			end
		end)
		pcall(function()
			if type(setAutoplayAutoCarry) == "function" then setAutoplayAutoCarry(false) end
		end)
		if clearToggles ~= false then
			if oldSide == "left" or toggleStates["Auto Left"] then
				toggleStates["Auto Left"] = false
			end
			if oldSide == "right" or toggleStates["Auto Right"] then
				toggleStates["Auto Right"] = false
			end
			if toggleVisualUpdaters["Auto Left"] then pcall(toggleVisualUpdaters["Auto Left"]) end
			if toggleVisualUpdaters["Auto Right"] then pcall(toggleVisualUpdaters["Auto Right"]) end
		end
	end

	-- Clean Hub style Auto Left/Right: 2-phase path (P1 -> P2 -> face + stop)
	local function startSidePath(side)
		if side ~= "left" and side ~= "right" then return end
		_G.__CrystalPendingAutoplayAfterCountdown = false
		if autoplayActive then
			pcall(function() stopAutoplay(true) end)
		end
		toggleStates["Autoplay"] = false
		if toggleVisualUpdaters["Autoplay"] then pcall(toggleVisualUpdaters["Autoplay"]) end

		if sidePath.conn then
			pcall(function() sidePath.conn:Disconnect() end)
			sidePath.conn = nil
		end
		sidePath.gen = (sidePath.gen or 0) + 1
		local myGen = sidePath.gen
		sidePath.active = true
		sidePath.side = side
		sidePath.phase = 1
		sidePath.wpIdx = 1
		_G.__autoplaySide = side

		toggleStates["Auto Left"] = (side == "left")
		toggleStates["Auto Right"] = (side == "right")
		if toggleVisualUpdaters["Auto Left"] then pcall(toggleVisualUpdaters["Auto Left"]) end
		if toggleVisualUpdaters["Auto Right"] then pcall(toggleVisualUpdaters["Auto Right"]) end

		pcall(function()
			if type(setAutoplayAutoCarry) == "function" then setAutoplayAutoCarry(true) end
		end)

		local waypoints = (side == "left") and autoLeftWaypoints or autoRightWaypoints
		if type(waypoints) ~= "table" or not waypoints[1] or not waypoints[2] then
			warn("[Vylo] Auto " .. side .. " missing Clean waypoints")
			sidePath.active = false
			return
		end
		local P1 = waypoints[1]
		local P2 = waypoints[2]
		local FACE = waypoints[3] or P2

		sidePath.conn = RunService.Heartbeat:Connect(function()
			if myGen ~= sidePath.gen or not sidePath.active then return end
			local stillOn = (side == "left" and toggleStates["Auto Left"] == true)
				or (side == "right" and toggleStates["Auto Right"] == true)
			if not stillOn then
				stopSidePath(true)
				return
			end

			local char = Player.Character
			local hrp = char and char:FindFirstChild("HumanoidRootPart")
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if not hrp or not hum then return end

			local spd = tonumber(speedValues and speedValues.NormalBoost)
				or tonumber(normalSpeed)
				or 59
			spd = math.max(1, spd)

			local phase = sidePath.phase or 1
			if phase == 1 then
				local tgt = Vector3.new(P1.X, hrp.Position.Y, P1.Z)
				if (tgt - hrp.Position).Magnitude < 1 then
					sidePath.phase = 2
					local d = P2 - hrp.Position
					local mv = Vector3.new(d.X, 0, d.Z)
					if mv.Magnitude > 0.001 then mv = mv.Unit else mv = Vector3.zero end
					pcall(function() hum:Move(mv, false) end)
					hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
					return
				end
				local d = P1 - hrp.Position
				local mv = Vector3.new(d.X, 0, d.Z)
				if mv.Magnitude > 0.001 then mv = mv.Unit else mv = Vector3.zero end
				pcall(function() hum:Move(mv, false) end)
				hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
			else
				local tgt = Vector3.new(P2.X, hrp.Position.Y, P2.Z)
				if (tgt - hrp.Position).Magnitude < 1 then
					pcall(function() hum:Move(Vector3.zero, false) end)
					hrp.AssemblyLinearVelocity = Vector3.zero
					sidePath.active = false
					if sidePath.conn then
						pcall(function() sidePath.conn:Disconnect() end)
						sidePath.conn = nil
					end
					sidePath.phase = 1
					toggleStates["Auto Left"] = false
					toggleStates["Auto Right"] = false
					if toggleVisualUpdaters["Auto Left"] then pcall(toggleVisualUpdaters["Auto Left"]) end
					if toggleVisualUpdaters["Auto Right"] then pcall(toggleVisualUpdaters["Auto Right"]) end
					pcall(function()
						if type(setAutoplayAutoCarry) == "function" then setAutoplayAutoCarry(false) end
					end)
					local facePos = Vector3.new(FACE.X, hrp.Position.Y, FACE.Z)
					if (facePos - hrp.Position).Magnitude > 0.01 then
						hrp.CFrame = CFrame.new(hrp.Position, facePos)
					end
					return
				end
				local d = P2 - hrp.Position
				local mv = Vector3.new(d.X, 0, d.Z)
				if mv.Magnitude > 0.001 then mv = mv.Unit else mv = Vector3.zero end
				pcall(function() hum:Move(mv, false) end)
				hrp.AssemblyLinearVelocity = Vector3.new(mv.X * spd, hrp.AssemblyLinearVelocity.Y, mv.Z * spd)
			end
		end)

		pcall(function()
			if type(_G.__CrystalTrackConn) == "function" then
				_G.__CrystalTrackConn(sidePath.conn)
			end
		end)
	end

	local function markSidePathHit()
		-- Clean path is short; keep restart-on-hit so a bat hit can resume the side run
		sidePath.recentHitUntil = tick() + 2.0
		_G.__CrystalAutoplayRecentHitUntil = sidePath.recentHitUntil
		if not sidePath.active then
			if toggleStates["Auto Left"] == true then
				task.defer(function()
					if toggleStates["Auto Left"] == true then startSidePath("left") end
				end)
			elseif toggleStates["Auto Right"] == true then
				task.defer(function()
					if toggleStates["Auto Right"] == true then startSidePath("right") end
				end)
			end
		end
	end
	_G.__CrystalMarkSidePathHit = markSidePathHit

	-- Toggle wiring: FeatureToggles flips, FeaturePostToggle starts/stops
	FeaturePostToggle["Auto Left"] = function(active)
		if active then
			toggleStates["Auto Right"] = false
			if toggleVisualUpdaters["Auto Right"] then pcall(toggleVisualUpdaters["Auto Right"]) end
			startSidePath("left")
		else
			if sidePath.side == "left" or toggleStates["Auto Left"] ~= true then
				-- only stop if this side was running
				if sidePath.side == "left" then
					stopSidePath(true)
				else
					toggleStates["Auto Left"] = false
					if toggleVisualUpdaters["Auto Left"] then pcall(toggleVisualUpdaters["Auto Left"]) end
				end
			end
		end
		saveConfig()
	end
	FeaturePostToggle["Auto Right"] = function(active)
		if active then
			toggleStates["Auto Left"] = false
			if toggleVisualUpdaters["Auto Left"] then pcall(toggleVisualUpdaters["Auto Left"]) end
			startSidePath("right")
		else
			if sidePath.side == "right" then
				stopSidePath(true)
			else
				toggleStates["Auto Right"] = false
				if toggleVisualUpdaters["Auto Right"] then pcall(toggleVisualUpdaters["Auto Right"]) end
			end
		end
		saveConfig()
	end

	FeatureToggles["Auto Left"] = function()
		local on = not (toggleStates["Auto Left"] == true)
		toggleStates["Auto Left"] = on
		if on then
			toggleStates["Auto Right"] = false
			if toggleVisualUpdaters["Auto Right"] then pcall(toggleVisualUpdaters["Auto Right"]) end
		end
		if FeaturePostToggle["Auto Left"] then
			FeaturePostToggle["Auto Left"](on)
		end
		if toggleVisualUpdaters["Auto Left"] then pcall(toggleVisualUpdaters["Auto Left"]) end
		saveConfig()
	end
	FeatureToggles["Auto Right"] = function()
		local on = not (toggleStates["Auto Right"] == true)
		toggleStates["Auto Right"] = on
		if on then
			toggleStates["Auto Left"] = false
			if toggleVisualUpdaters["Auto Left"] then pcall(toggleVisualUpdaters["Auto Left"]) end
		end
		if FeaturePostToggle["Auto Right"] then
			FeaturePostToggle["Auto Right"](on)
		end
		if toggleVisualUpdaters["Auto Right"] then pcall(toggleVisualUpdaters["Auto Right"]) end
		saveConfig()
	end

	-- Legacy Autoplay stop must not kill side path
	local _origStopAutoplay = stopAutoplay
	stopAutoplay = function(keepToggle)
		_origStopAutoplay(keepToggle)
	end
	_G.__stopAutoplay = stopAutoplay

	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function()
		task.wait(0.6)
		if toggleStates["Auto Left"] == true then
			startSidePath("left")
		elseif toggleStates["Auto Right"] == true then
			startSidePath("right")
		end
	end))
	_G.__CrystalTrackStopper(function()
		stopSidePath(true)
	end)

	_G.__stopAutoplay = stopAutoplay

	do
	local TP_DOWN_COOLDOWN = 0.10
	local lastTPDownAt = 0
	local tpDownPending = false
	local tpDownGeneration = 0
	local tpDownAlive = true
	local function cancelPendingTPDown()
	tpDownGeneration = tpDownGeneration + 1
	tpDownPending = false
	end
	_G.__CrystalTrackConn(Player.CharacterRemoving:Connect(cancelPendingTPDown))
	_G.__CrystalTrackStopper(function()
	tpDownAlive = false
	cancelPendingTPDown()
	end)
	local function executeTPDown()
	if not tpDownAlive or _G.dropActive or _G.IsDropping then return end
	local now = os.clock()
	local remaining = TP_DOWN_COOLDOWN - (now - lastTPDownAt)
	if remaining > 0 then
	if not tpDownPending then
	tpDownPending = true
	local generation = tpDownGeneration
	local pendingCharacter = Player.Character
	task.delay(remaining, function()
	if generation ~= tpDownGeneration or Player.Character ~= pendingCharacter then return end
	tpDownPending = false
	executeTPDown()
	end)
	end
	return
	end
	local char = Player.Character
	if not char then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 or hrp.Anchored or hum.Sit or hum.SeatPart then return end
	lastTPDownAt = os.clock()
	cancelPendingTPDown()

	local _, yaw = hrp.CFrame:ToEulerAnglesYXZ()
	pcall(function()
	hrp.CFrame = CFrame.new(hrp.Position.X, -7, hrp.Position.Z)
	* CFrame.Angles(0, yaw, 0)
	hrp.AssemblyLinearVelocity = Vector3.zero
	end)
	end

	_G["ExecuteTPDown"] = executeTPDown
	FeatureToggles["TP Down"] = executeTPDown

	do
	_G.__loadInstaReset = true
	local RESET_MAX_DURATION = 0.05
	local resetCooldown = false
	local resetThread = nil
	local currentCharacter = nil
	local resetSuccessful = false
	local stopResetSequence = false

	local function doInstaReset()
	if resetCooldown then return end
	resetCooldown = true
	resetSuccessful = false
	stopResetSequence = false
	local character = Player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not character or not humanoid then
	resetCooldown = false
	return
	end

	currentCharacter = character
	resetThread = task.spawn(function()
	local attempts = 0
	local maxAttempts = 40
	local originalHipHeight = humanoid.HipHeight

	while character and character.Parent and humanoid and humanoid.Health > 0
	and Player.Character == character and not stopResetSequence do
	pcall(function()
	humanoid.HipHeight = 1e30
	humanoid.AutoRotate = true
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if rootPart then rootPart.CanCollide = false end
	for _, part in ipairs(character:GetChildren()) do
	if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
	part.CanCollide = false
	end
	end
	end)
	if not character.Parent or humanoid.Health <= 0 or Player.Character ~= character then
	resetSuccessful = true
	break
	end
	attempts = attempts + 1
	if attempts >= maxAttempts then break end
	task.wait(RESET_MAX_DURATION)
	end

	if not resetSuccessful and character and character.Parent and humanoid.Health > 0
	and Player.Character == character then
	pcall(function() humanoid.Health = 0 end)
	task.wait(0.1)
	if not character.Parent or humanoid.Health <= 0 then resetSuccessful = true end
	end

	if not resetSuccessful and character and character.Parent and humanoid then
	pcall(function()
	humanoid.HipHeight = originalHipHeight
	local rootPart = character:FindFirstChild("HumanoidRootPart")
	if rootPart then rootPart.CanCollide = true end
	for _, part in ipairs(character:GetChildren()) do
	if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
	part.CanCollide = true
	end
	end
	end)
	end

	resetCooldown = false
	resetThread = nil
	currentCharacter = nil
	stopResetSequence = false
	end)
	end

	local function stopInstaReset()
	stopResetSequence = true
	if resetThread then
	pcall(task.cancel, resetThread)
	resetThread = nil
	end
	resetCooldown = false
	currentCharacter = nil
	end

	FeatureToggles["Insta Reset"] = doInstaReset
	_G.__CrystalInstaReset = doInstaReset
	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function()
	stopInstaReset()
	resetSuccessful = false
	stopResetSequence = false
	end))
	_G.__CrystalTrackConn(RunService.Heartbeat:Connect(function()
	local character = Player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if (humanoid and humanoid.Health <= 0)
	or (currentCharacter and character ~= currentCharacter) then
	resetSuccessful = true
	if resetThread then
	pcall(task.cancel, resetThread)
	resetThread = nil
	end
	resetCooldown = false
	currentCharacter = nil
	end
	end))
	_G.__CrystalTrackStopper(function()
	stopInstaReset()
	end)
	end

	local autoTPDownElapsed = 0
	local autoTPDownTriggered = false
	local autoTPDownRoot = nil
	local autoTPDownRaycast = RaycastParams.new()
	autoTPDownRaycast.FilterType = Enum.RaycastFilterType.Exclude
	pcall(function() autoTPDownRaycast.RespectCanCollide = true end)
	FeaturePostToggle["Auto TP Down"] = function(active)
	if not active then
	autoTPDownElapsed = 0
	autoTPDownTriggered = false
	autoTPDownRoot = nil
	end
	end
	_G.__CrystalTrackConn(RunService.Heartbeat:Connect((function(dt)
	if toggleStates["Auto TP Down"] ~= true then return end

	if _G.dropActive or _G.IsDropping then
	autoTPDownElapsed = 0
	return
	end
	autoTPDownElapsed = autoTPDownElapsed + dt or 0
	if autoTPDownElapsed < 0.10 then return end
	autoTPDownElapsed = 0
	local char = Player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not root or not hum or hum.Health <= 0 then
	autoTPDownTriggered = false
	autoTPDownRoot = nil
	return
	end
	if root ~= autoTPDownRoot then
	autoTPDownRoot = root
	autoTPDownTriggered = false
	end
	local threshold = math.clamp(tonumber(speedValues.AutoTPDownHeight) or 20, 1, 1000)
	autoTPDownRaycast.FilterDescendantsInstances = { char }
	local result = workspace:Raycast(root.Position, Vector3.new(0, -2048, 0), autoTPDownRaycast)
	local height = result and math.max(0, root.Position.Y - result.Position.Y) or nil
	local reachedHeight = height ~= nil and height >= threshold
	if reachedHeight and not autoTPDownTriggered then
	autoTPDownTriggered = true
	executeTPDown()
	elseif not reachedHeight then
	autoTPDownTriggered = false
	end
	end)))
	end

	do
	local _dropDropActive = false
	local _dropConn = nil

	local DROP_ASCEND_DURATION = 0.2
	local DROP_ASCEND_SPEED = 150

	local function drop()
	if _dropDropActive then return end
	local char = Player.Character; if not char then return end
	local root = char:FindFirstChild("HumanoidRootPart"); if not root then return end
	if _dropConn then _dropConn:Disconnect(); _dropConn = nil end

	local DROP_TARGET_Y = root.Position.Y
	_dropDropActive = true
	_G.dropActive = true
	_G.IsDropping = true
	local t0 = tick()

	_dropConn = RunService.Heartbeat:Connect(function()
	local r = char and char:FindFirstChild("HumanoidRootPart")
	if not r then
	_dropConn:Disconnect(); _dropConn = nil
	_dropDropActive = false
	_G.dropActive = false
	_G.IsDropping = false
	return
	end

	if tick() - t0 >= DROP_ASCEND_DURATION then
	_dropConn:Disconnect(); _dropConn = nil

	local _, yaw = r.CFrame:ToEulerAnglesYXZ()
	r.CFrame = CFrame.new(r.Position.X, DROP_TARGET_Y, r.Position.Z)
	* CFrame.Angles(0, yaw, 0)
	r.AssemblyLinearVelocity = Vector3.zero
	pcall(function() r.Velocity = Vector3.zero end)

	_dropDropActive = false
	_G.dropActive = false
	_G.IsDropping = false
	return
	end

	r.AssemblyLinearVelocity = Vector3.new(
	r.AssemblyLinearVelocity.X,
	DROP_ASCEND_SPEED,
	r.AssemblyLinearVelocity.Z
	)
	end)
	end

	FeatureToggles["Drop"] = drop
	_G.doDrop = drop
	end

	local function checkAndAutoDrop(callback)
	ragdollCounterPaused = true
	local function unpauseRagdollCounter()
	ragdollCounterPaused = false
	end
	if Player:GetAttribute("Stealing") then
	local char = Player.Character
	if not char then
	if callback then callback() end
	unpauseRagdollCounter()
	return
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then
	if callback then callback() end
	unpauseRagdollCounter()
	return
	end

	if FeatureToggles["Drop"] then
	FeatureToggles["Drop"]()
	local start = tick()
	while Player:GetAttribute("Stealing") and (tick() - start) < 5 do
	task.wait()
	end
	end

	if callback then
	callback()
	end
	unpauseRagdollCounter()
	else
	if callback then
	callback()
	end
	unpauseRagdollCounter()
	end
	end
	_G.__checkAndAutoDrop = checkAndAutoDrop
	end

	local v1Progress = 0

	local V2 = { busy = false, data = {} }

	do
	local LP = Player
	local plots = workspace:WaitForChild("Plots")

	local AnimalsData = {}
	local syncRemotes = nil
	local plotAnimalSync = { caches = {}, connections = {} }
	local allAnimalsCache = {}
	local InternalStealCache = {}
	local stealConnection = nil
	local syncStarted = false
	local syncLoopStarted = false
	local _stealDetectConns = {}
	local _stealDetectTimer = nil
	local autoStealGeneration = 0

	local CONFIG_AUTO_STEAL = {
	AUTO_STEAL_ENABLED = false,
	HOLD_MIN = 1.3,
	HOLD_MAX = 2.6,
	ENTRY_DELAY = 0.01,
	COOLDOWN = 0.05,
	STEAL_RANGE = 6,
	PRIME_RANGE = math.clamp(tonumber(autoStealValues.Radius) or 65, 10, 150),
	}
	local stealPromptCache = setmetatable({}, { __mode = "k" })
	local function getCachedStealPrompt(spawn)
	if not spawn then return nil end
	local cached = stealPromptCache[spawn]
	if cached and cached.Parent and cached:IsA("ProximityPrompt") and cached.ActionText and cached.ActionText:find("Steal") then
	return cached
	end
	local promptAttachment = spawn:FindFirstChild("PromptAttachment")
	local candidates = promptAttachment and promptAttachment:GetChildren() or spawn:GetDescendants()
	for _, candidate in ipairs(candidates) do
	if candidate:IsA("ProximityPrompt") and candidate.ActionText and candidate.ActionText:find("Steal") then
	stealPromptCache[spawn] = candidate
	return candidate
	end
	end
	stealPromptCache[spawn] = nil
	return nil
	end

	local StealState = {
	active = false,
	startTime = 0,
	phase = "idle",
	label = "",
	lastResult = "",
	lastResultTime = 0,
	totalSteals = 0,
	failedSteals = 0,
	}

	local State = _G.__CrystalAutoStealState or { isStealing = false }
	_G.__CrystalAutoStealState = State

	local function setStealState(on)
	on = on == true
	if State.isStealing == on then return end
	State.isStealing = on
	end

	local function initializeAutoStealSync()
	if syncRemotes then return true end
	local ok = pcall(function()
	local Packages = ReplicatedStorage:WaitForChild("Packages", 10)
	local Datas = ReplicatedStorage:WaitForChild("Datas", 10)
	if not Packages or not Datas then return end
	AnimalsData = require(Datas:WaitForChild("Animals"))
	local folder = Packages:WaitForChild("Synchronizer")
	syncRemotes = {
	channelFolder = folder:WaitForChild("Channel"),
	routeRemote = folder:WaitForChild("CommunicationRoute"),
	requestData = folder:FindFirstChild("RequestData"),
	}
	end)
	return ok and syncRemotes ~= nil
	end

	local function splitSyncPath(path)
	if typeof(path) == "table" then return path end
	local out = {}
	for part in string.gmatch(tostring(path), "[^%.]+") do
	table.insert(out, tonumber(part) or part)
	end
	return out
	end

	local function resolveSyncPath(path, root)
	local current = root
	local parent = nil
	local key = nil
	for _, part in ipairs(splitSyncPath(path)) do
	parent = current
	key = part
	current = current and current[part] or nil
	end
	return current, parent, key
	end

	local function applyPlotSyncDiff(channelName, packet)
	local cache = plotAnimalSync.caches[channelName]
	if typeof(cache) ~= "table" then return end
	local path, action, a, b = packet[1], packet[2], packet[3], packet[4]
	local current, parent, key = resolveSyncPath(path, cache)
	if action == "Changed" then
	if parent ~= nil then parent[key] = a end
	elseif action == "ArrayInsert" then
	if current ~= nil then table.insert(current, b, a) end
	elseif action == "ArrayRemoved" then
	if current ~= nil then table.remove(current, b) end
	elseif action == "DictionaryInsert" then
	if current ~= nil then current[b] = a end
	elseif action == "DictionaryRemoved" then
	if current ~= nil then current[b] = nil end
	end
	end

	local function attachPlotChannel(remote)
	if not syncRemotes or plotAnimalSync.connections[remote] then return end
	local channelName = tostring(remote.Name)
	if not plots:FindFirstChild(channelName) then return end
	if syncRemotes.requestData and plotAnimalSync.caches[channelName] == nil then
	local ok, data = pcall(function() return syncRemotes.requestData:InvokeServer(channelName) end)
	plotAnimalSync.caches[channelName] = (ok and typeof(data) == "table") and data or {}
	elseif plotAnimalSync.caches[channelName] == nil then
	plotAnimalSync.caches[channelName] = {}
	end
	plotAnimalSync.connections[remote] = remote.OnClientEvent:Connect(function(queue)
	for _, packet in ipairs(queue) do applyPlotSyncDiff(channelName, packet) end
	end)
	end

	local function detachPlotChannel(channelName)
	for remote, conn in pairs(plotAnimalSync.connections) do
	if tostring(remote.Name) == tostring(channelName) then
	conn:Disconnect()
	plotAnimalSync.connections[remote] = nil
	plotAnimalSync.caches[tostring(channelName)] = nil
	break
	end
	end
	end

	local function startAutoStealSync()
	if syncStarted then return true end
	if not initializeAutoStealSync() then return false end
	if not syncRemotes or not syncRemotes.channelFolder then return false end
	for _, child in ipairs(syncRemotes.channelFolder:GetChildren()) do
	if child:IsA("RemoteEvent") then attachPlotChannel(child) end
	end
	syncRemotes.channelFolder.ChildAdded:Connect(function(child)
	if child:IsA("RemoteEvent") then attachPlotChannel(child) end
	end)
	syncRemotes.routeRemote.OnClientEvent:Connect(function(actions)
	for _, action in ipairs(actions) do
	local kind, channelName = action[1], tostring(action[2])
	if plots:FindFirstChild(channelName) then
	if kind == "ListenerAdded" then
	local remote = syncRemotes.channelFolder:FindFirstChild(channelName)
	if remote and remote:IsA("RemoteEvent") then attachPlotChannel(remote) end
	elseif kind == "ListenerRemoved" then
	detachPlotChannel(channelName)
	end
	end
	end
	end)
	syncStarted = true
	return true
	end

	local function getPlotChannelData(plotName)
	return plotAnimalSync.caches[plotName]
	end

	local function getAnimalPosition(animalData)
	local plot = plots:FindFirstChild(animalData.plot)
	local podiums = plot and plot:FindFirstChild("AnimalPodiums")
	local podium = podiums and podiums:FindFirstChild(animalData.slot)
	return podium and podium:GetPivot().Position
	end

	local function distToAnimal(animalData)
	local character = Player.Character
	local hrp = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("UpperTorso"))
	if not hrp then return math.huge end
	local pos = getAnimalPosition(animalData)
	if not pos then return math.huge end
	return (hrp.Position - pos).Magnitude
	end

	local function scanAllPlots()
	if not plots then return {} end
	local newCache = {}
	for _, plot in ipairs(plots:GetChildren()) do
	local cache = getPlotChannelData(plot.Name)
	local animalList = cache and cache.AnimalList
	if typeof(animalList) == "table" then
	for slot, animalData in pairs(animalList) do
	if type(animalData) == "table" then
	local animalName = animalData.Index
	local animalInfo = AnimalsData[animalName]
	if animalInfo then
	table.insert(newCache, {
	name = animalInfo.DisplayName or animalName,
	plot = plot.Name,
	slot = tostring(slot),
	uid = plot.Name .. "_" .. tostring(slot),
	})
	end
	end
	end
	end
	end
	allAnimalsCache = newCache
	return #allAnimalsCache
	end

	local function buildStealCallbacks(prompt)
	if InternalStealCache[prompt] then return end
	local data = { holdCallbacks = {}, triggerCallbacks = {}, ready = true }
	local ok1, conns1 = false, nil
	if getconnections then ok1, conns1 = pcall(getconnections, prompt.PromptButtonHoldBegan) end
	if ok1 and type(conns1) == "table" then
	for _, conn in ipairs(conns1) do
	if type(conn.Function) == "function" then table.insert(data.holdCallbacks, conn.Function) end
	end
	end
	local ok2, conns2 = false, nil
	if getconnections then ok2, conns2 = pcall(getconnections, prompt.Triggered) end
	if ok2 and type(conns2) == "table" then
	for _, conn in ipairs(conns2) do
	if type(conn.Function) == "function" then table.insert(data.triggerCallbacks, conn.Function) end
	end
	end
	if #data.holdCallbacks > 0 or #data.triggerCallbacks > 0 then
	InternalStealCache[prompt] = data
	end
	end

	local function executeStealAsync(prompt, animalData)
	local data = InternalStealCache[prompt]
	if not data or not data.ready then return false end
	data.ready = false
	local label = animalData and animalData.name or "Animal"
	StealState.active = true
	StealState.startTime = tick()
	StealState.phase = "holding"
	StealState.label = label
	setStealState(false)
	v1Progress = 0
	local runGeneration = autoStealGeneration
	task.spawn(function()
	CONFIG_AUTO_STEAL.HOLD_MIN = autoStealValues.Duration or CONFIG_AUTO_STEAL.HOLD_MIN
	CONFIG_AUTO_STEAL.HOLD_MAX = CONFIG_AUTO_STEAL.HOLD_MIN + 1.3
	for _, fn in ipairs(data.holdCallbacks) do task.spawn(fn) end
	while tick() - StealState.startTime < CONFIG_AUTO_STEAL.HOLD_MIN do
	if runGeneration ~= autoStealGeneration then data.ready = true; return end
	if not CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED or not prompt.Parent then break end
	local elapsed = tick() - StealState.startTime
	v1Progress = math.clamp(elapsed / CONFIG_AUTO_STEAL.HOLD_MAX, 0, 1)

	task.wait(0.05)
	end
	StealState.phase = "waitingRange"
	local alreadyInRange = animalData and distToAnimal(animalData) <= CONFIG_AUTO_STEAL.STEAL_RANGE
	local fired = false
	while runGeneration == autoStealGeneration and CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED and prompt.Parent do
	local elapsed = tick() - StealState.startTime
	v1Progress = math.clamp(elapsed / CONFIG_AUTO_STEAL.HOLD_MAX, 0, 1)
	if elapsed > CONFIG_AUTO_STEAL.HOLD_MAX then break end
	if animalData and distToAnimal(animalData) <= CONFIG_AUTO_STEAL.STEAL_RANGE then
	if not alreadyInRange then task.wait(CONFIG_AUTO_STEAL.ENTRY_DELAY) end
	for _, fn in ipairs(data.triggerCallbacks) do task.spawn(fn) end
	fired = true
	break
	end
	task.wait(0.05)
	end
	if runGeneration ~= autoStealGeneration then data.ready = true; return end
	if fired then
	StealState.totalSteals = StealState.totalSteals + 1
	StealState.lastResult = "Stole " .. label
	StealState.phase = "success"
	setStealState(true)
	else
	StealState.failedSteals = StealState.failedSteals + 1
	StealState.lastResult = "Missed window: " .. label
	StealState.phase = "failed"
	end
	StealState.active = false
	StealState.lastResultTime = tick()
	v1Progress = 1
	task.wait(CONFIG_AUTO_STEAL.COOLDOWN)
	v1Progress = 0
	data.ready = true
	end)
	return true
	end

	local function attemptSteal(prompt, animalData)
	if not prompt or not prompt.Parent then return false end
	buildStealCallbacks(prompt)
	return executeStealAsync(prompt, animalData)
	end

                local V3New = {
                    busy = false,
                    active = false,
                    progress = 0,
                    isStealing = false,
                    currentTarget = nil,
                    totalSteals = 0,
                    failedSteals = 0,
                    lastResult = "",
                    generation = 0,
                    phase = "idle",
                    startTime = 0,
                    data = {}
                }

                local V3Config = {
                    RADIUS = 65,
					HOLD_MIN = 1.3,
					HOLD_MAX = 2.6,
					NEAR_TARGET_RANGE = 20,
					ENTRY_DELAY = 0.3,
					FIRE_RANGE = 12,
                    COOLDOWN = 0.45,
                }
					local v3TargetCache = { prompt = nil, radius = 0, expiresAt = 0 , podName = nil }

                local function v3NewFindNearestPrompt(searchRadius)
					-- Raiju-style nearest Steal prompt on enemy plots
					local radius = math.max(0, tonumber(searchRadius) or (autoStealValues and autoStealValues.Radius) or 65)
					if v3TargetCache.expiresAt > tick()
					and v3TargetCache.radius == radius
					and v3TargetCache.prompt
					and v3TargetCache.prompt.Parent then
						return v3TargetCache.prompt, v3TargetCache.podName
					end
					local char = Player.Character
					local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))
					if not root then return nil end
					local plotsRoot = workspace:FindFirstChild("Plots")
					if not plotsRoot then
						plotsRoot = plots -- fallback existing local
					end
					if not plotsRoot then return nil end

					local nearest, nearestDist, nearestName = nil, math.huge, nil
					local rpos = root.Position
					for _, plot in ipairs(plotsRoot:GetChildren()) do
						local sign = plot:FindFirstChild("PlotSign")
						local yourBase = sign and sign:FindFirstChild("YourBase")
						local isMine = yourBase and yourBase:IsA("BillboardGui") and yourBase.Enabled
						if not isMine then
							local pods = plot:FindFirstChild("AnimalPods") or plot:FindFirstChild("AnimalPodiums")
							if pods then
								for _, pod in ipairs(pods:GetChildren()) do
									local base = pod:FindFirstChild("Base")
									local spawn = base and base:FindFirstChild("Spawn")
									if spawn then
										local sp = spawn.Position
										local dx, dy, dz = sp.X - rpos.X, sp.Y - rpos.Y, sp.Z - rpos.Z
										local dist = math.sqrt(dx*dx + dy*dy + dz*dz)
										if dist < nearestDist and dist <= radius then
											local prompt = getCachedStealPrompt(spawn)
											if not prompt then
												local att = spawn:FindFirstChild("PromptAttachment")
												if att then
													for _, child in ipairs(att:GetChildren()) do
														if child:IsA("ProximityPrompt") and child.ActionText and child.ActionText:find("Steal") then
															prompt = child
															break
														end
													end
												end
											end
											if prompt then
												nearest, nearestDist, nearestName = prompt, dist, pod.Name
											end
										end
									end
								end
							end
						end
					end
					v3TargetCache.prompt = nearest
					v3TargetCache.radius = radius
					v3TargetCache.podName = nearestName
					v3TargetCache.expiresAt = tick() + 0.12
					return nearest, nearestName
				end

				_G.__CrystalAutoGrabTargetInRadius = function(radius)
                    return v3NewFindNearestPrompt(radius or 65) ~= nil
                end

                local function v3NewGetPromptDistance(prompt)
                    local char = Player.Character
                    local root = char and (char:FindFirstChild("HumanoidRootPart") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso"))
                    if not root then return math.huge end

                    local part = prompt.Parent
                    if part and part:IsA("Attachment") then part = part.Parent end
                    if part and part:IsA("BasePart") then
                        return (part.Position - root.Position).Magnitude
                    end

                    local ok, pos = pcall(function() return prompt.Parent and prompt.Parent.WorldPosition end)
                    if ok and pos then
                        return (pos - root.Position).Magnitude
                    end
                    return math.huge
                end

				local function v3NewGetPromptCallbacks(prompt)
                    local data = V3New.data[prompt]
                    if data then return data end

                    data = { hold = {}, trigger = {}, ready = true }

                    if getconnections then
                        for _, conn in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
                            if conn.Function then
                                table.insert(data.hold, conn.Function)
                            end
                        end
                        for _, conn in ipairs(getconnections(prompt.Triggered)) do
                            if conn.Function then
                                table.insert(data.trigger, conn.Function)
                            end
                        end
                    end

                    V3New.data[prompt] = data
					return data
				end

				local function v3NewTriggerPrompt(prompt, data)
					if not prompt or not prompt.Parent then return false end
					if Player:GetAttribute("Stealing") == true then return false end
					local invoked = false
					for _, callback in ipairs(data.trigger) do
						local ok = pcall(callback)
						if ok then invoked = true end
					end

					if not invoked and Player:GetAttribute("Stealing") ~= true and typeof(fireproximityprompt) == "function" then
						local ok = pcall(fireproximityprompt, prompt)
						invoked = ok or invoked
					end
					if not invoked and Player:GetAttribute("Stealing") ~= true then
						local ok = pcall(function()
							prompt:InputHoldBegin()
							task.wait(0.05)
							prompt:InputHoldEnd()
						end)
						invoked = ok
					end
					return invoked
				end

				local function v3NewExecuteSteal(prompt, podName)
					-- Raiju V1 auto-steal logic (hold → early stop → trigger + remote)
					if not prompt or V3New.busy or V3New.isStealing then return end
					if State and State.isStealing then return end

					V3New.generation = (V3New.generation or 0) + 1
					local runGen = V3New.generation
					V3New.busy = true
					V3New.active = true
					V3New.isStealing = true
					V3New.phase = "holding"
					V3New.progress = 0
					v1Progress = 0
					setStealState(true)

					-- Cache hold/trigger connections (Raiju style)
					if not V3New.data then V3New.data = {} end
					if not V3New.data[prompt] then
						V3New.data[prompt] = { hold = {}, trigger = {}, ready = true }
						pcall(function()
							if getconnections then
								for _, c in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
									if c.Function then table.insert(V3New.data[prompt].hold, c.Function) end
								end
								for _, c in ipairs(getconnections(prompt.Triggered)) do
									if c.Function then table.insert(V3New.data[prompt].trigger, c.Function) end
								end
							end
						end)
					end
					local data = V3New.data[prompt]
					if not data or not data.ready then
						V3New.busy = false
						V3New.active = false
						V3New.isStealing = false
						setStealState(false)
						return
					end
					data.ready = false

					local duration = tonumber(autoStealValues and autoStealValues.Duration) or CONFIG_AUTO_STEAL.HOLD_MIN or 1.3
					-- Raiju Normal stop = 73% of duration (Semi 80%, Semi Normal 90%)
					local stopFrac = 0.73
					if autoStealMode == "v2" then stopFrac = 0.80 end
					local stopTime = duration * stopFrac
					local stealRadius = tonumber(autoStealValues and autoStealValues.Radius) or 65

					task.spawn(function()
						local startTime = tick()
						local promptFired = false
						local stopProgress = math.clamp(stopTime / duration, 0, 1)

						-- Begin hold immediately
						pcall(function()
							for _, f in ipairs(data.hold) do task.spawn(f) end
						end)

						-- Hold until stopTime (early release window)
						while runGen == V3New.generation and CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED and prompt.Parent do
							local elapsed = tick() - startTime
							local progress = math.clamp(elapsed / duration, 0, 1)
							V3New.progress = math.min(progress, stopProgress)
							v1Progress = V3New.progress
							if StealState then
								StealState.progress = v1Progress
								StealState.phase = "holding"
							end

							if not prompt.Parent or not prompt.Parent.Parent then break end
							local char = Player.Character
							local hrp = char and char:FindFirstChild("HumanoidRootPart")
							if hrp and prompt.Parent and prompt.Parent.Parent then
								local pos = prompt.Parent.Parent
								if pos:IsA("BasePart") then
									if (hrp.Position - pos.Position).Magnitude > stealRadius then break end
								end
							end
							if elapsed >= stopTime then break end
							task.wait()
						end

						-- Fill remainder visually then fire (Raiju)
						if runGen == V3New.generation and CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED and not promptFired then
							local fillStart = tick()
							local fillDuration = math.max(duration - stopTime, 0.05)
							while runGen == V3New.generation do
								local fp = math.clamp((tick() - fillStart) / fillDuration, 0, 1)
								local totalProgress = stopProgress + fp * (1 - stopProgress)
								V3New.progress = totalProgress
								v1Progress = totalProgress
								if fp >= 1 and not promptFired then
									promptFired = true
									V3New.phase = "trigger"
									pcall(function()
										for _, f in ipairs(data.trigger) do task.spawn(f) end
										local remote = ReplicatedStorage:FindFirstChild("StealAnimal")
										if remote and podName then
											pcall(function() remote:FireServer(podName) end)
										end
										if typeof(fireproximityprompt) == "function" then
											pcall(fireproximityprompt, prompt)
										else
											pcall(function()
												prompt:InputHoldBegin()
												task.wait(0.05)
												prompt:InputHoldEnd()
											end)
										end
									end)
									V3New.totalSteals = (V3New.totalSteals or 0) + 1
									if StealState then
										StealState.totalSteals = (StealState.totalSteals or 0) + 1
										StealState.lastResult = "Stole"
									end
									V3New.lastResult = "STOLE"
									V3New.phase = "success"
									break
								end
								task.wait()
							end
						end

						if runGen ~= V3New.generation then return end

						V3New.active = false
						V3New.isStealing = false
						V3New.busy = false
						data.ready = true
						setStealState(false)

						if not promptFired then
							V3New.failedSteals = (V3New.failedSteals or 0) + 1
							V3New.lastResult = "FAIL"
							V3New.phase = "failed"
						end
						V3New.lastResultTime = tick()
						if StealState then StealState.lastResultTime = tick() end

						task.wait(CONFIG_AUTO_STEAL.COOLDOWN or 0.05)
						if runGen ~= V3New.generation then return end
						V3New.progress = 0
						v1Progress = 0
						V3New.phase = "idle"
					end)
				end


	local V2Grab = {
	busy = false,
	active = false,
	progress = 0,
	paused = false,
	pauseTime = nil,
	totalSteals = 0,
	failedSteals = 0,
	lastResult = "",
	generation = 0,
	phase = "idle",
	data = {},
	}

	local V2GrabConfig = {
	STEAL_DURATION = 1.3,
	HOLD_TARGET = 0.8,
	TRIGGER_RADIUS = 10,
	PAUSE_TIMEOUT = 1.3,
	COOLDOWN = 0.05,
	}

	local function v2GrabGetCallbacks(prompt)
	local data = V2Grab.data[prompt]
	if data then return data end
	data = { hold = {}, trigger = {}, ready = true }
	if getconnections then
	pcall(function()
	for _, conn in ipairs(getconnections(prompt.PromptButtonHoldBegan)) do
	if conn.Function then table.insert(data.hold, conn.Function) end
	end
	for _, conn in ipairs(getconnections(prompt.Triggered)) do
	if conn.Function then table.insert(data.trigger, conn.Function) end
	end
	end)
	end
	V2Grab.data[prompt] = data
	return data
	end

	local function v2GrabExecuteSteal(prompt)
	if V2Grab.busy or not prompt or not prompt.Parent then return end
	if Player:GetAttribute("Stealing") == true then return end
	local data = v2GrabGetCallbacks(prompt)
	if not data.ready then return end

	data.ready = false
	V2Grab.busy = true
	V2Grab.active = true
	V2Grab.progress = 0
	V2Grab.paused = false
	V2Grab.pauseTime = nil
	V2Grab.phase = "holding"
	V2Grab.generation = V2Grab.generation + 1
	local runGen = V2Grab.generation
	local startTime = tick()
	local pauseArmed = true
	local fired = false
	StealState.active = true
	StealState.startTime = startTime
	StealState.phase = "holding"
	v1Progress = 0
	setStealState(true)

	task.spawn(function()
	for _, callback in ipairs(data.hold) do
	task.spawn(function() pcall(callback) end)
	end

	while runGen == V2Grab.generation
	and CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED
	and autoStealMode == "v2"
	and Player:GetAttribute("Stealing") ~= true
	and prompt.Parent do
	local skipProgress = false
	if V2Grab.paused then
	local distance = v3NewGetPromptDistance(prompt)
	if distance <= V2GrabConfig.TRIGGER_RADIUS then
	V2Grab.paused = false
	V2Grab.pauseTime = nil
	V2Grab.phase = "finishing"
	startTime = tick() - (V2GrabConfig.HOLD_TARGET * V2GrabConfig.STEAL_DURATION)
	else
	if not V2Grab.pauseTime then
	V2Grab.pauseTime = tick()
	elseif tick() - V2Grab.pauseTime >= V2GrabConfig.PAUSE_TIMEOUT then
	break
	end
	V2Grab.progress = V2GrabConfig.HOLD_TARGET
	v1Progress = V2Grab.progress
	StealState.label = "80%"
	task.wait(0.05)
	skipProgress = true
	end
	end

	if not skipProgress then
	local progress = math.clamp((tick() - startTime) / V2GrabConfig.STEAL_DURATION, 0, 1)
	V2Grab.progress = progress
	v1Progress = progress
	StealState.label = math.floor(progress * 100 + 0.5) .. "%"

	if pauseArmed and progress >= V2GrabConfig.HOLD_TARGET then
	pauseArmed = false
	V2Grab.paused = true
	V2Grab.pauseTime = tick()
	V2Grab.progress = V2GrabConfig.HOLD_TARGET
	v1Progress = V2Grab.progress
	V2Grab.phase = "waitingRange"
	StealState.phase = "waitingRange"
	elseif progress >= 1 then
	V2Grab.phase = "triggering"
	for _, callback in ipairs(data.trigger) do
	task.spawn(function() pcall(callback) end)
	end
	fired = true
	break
	end
	task.wait(0.05)
	end -- if not skipProgress
	end -- while steal loop

	if runGen ~= V2Grab.generation then return end
	V2Grab.active = false
	V2Grab.busy = false
	V2Grab.paused = false
	V2Grab.pauseTime = nil
	data.ready = true
	StealState.active = false
	StealState.lastResultTime = tick()
	setStealState(false)

	if fired then
	V2Grab.totalSteals = V2Grab.totalSteals + 1
	V2Grab.lastResult = "Stole"
	V2Grab.phase = "success"
	StealState.totalSteals = StealState.totalSteals + 1
	StealState.lastResult = "Stole"
	else
	V2Grab.failedSteals = V2Grab.failedSteals + 1
	V2Grab.lastResult = "Missed window"
	V2Grab.phase = "failed"
	StealState.failedSteals = StealState.failedSteals + 1
	StealState.lastResult = "Missed window"
	end

	task.wait(V2GrabConfig.COOLDOWN)
	if runGen == V2Grab.generation then
	V2Grab.progress = 0
	v1Progress = 0
	V2Grab.phase = "idle"
	end
	end)
	end

	local function _startStealHeartbeat()
	if stealConnection then return end
	local elapsed = 0
	stealConnection = RunService.Heartbeat:Connect((function(dt)
	elapsed = elapsed + (dt or 0)
	local scanInterval = 0.15
	if elapsed < scanInterval then return end
	elapsed = 0
	if not CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED then return end
	if Player:GetAttribute("Stealing") == true then return end
	if _G.__CrystalAutoGrabRagdollBlocked == true then return end
	if StealState.active or V2.busy or V3New.busy or V2Grab.busy then return end
	if autoStealMode == "v2" then
	local prompt = v3NewFindNearestPrompt(autoStealValues.Radius)
	if prompt then v2GrabExecuteSteal(prompt) end
	return
	end
	if autoStealMode == "v1" then
	local prompt, podName = v3NewFindNearestPrompt(autoStealValues.Radius)
	if prompt then v3NewExecuteSteal(prompt, podName) end
	return
	end
	end))
	end

	_G.CrystalAutoStealRunCycle = function(prompt, target)
	return attemptSteal(prompt, target)
	end

	local function stopStealDetection()
	if _stealDetectConns then for _, c in ipairs(_stealDetectConns) do pcall(function() c:Disconnect() end) end end
	_stealDetectConns = {}
	if _stealDetectTimer then task.cancel(_stealDetectTimer); _stealDetectTimer = nil end
	end

	local startStealDetection = (function(char)
	stopStealDetection()
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	table.insert(_stealDetectConns, hum:GetPropertyChangedSignal("WalkSpeed"):Connect(function()
	setStealState(hum.WalkSpeed < 22)
	end))
	local function watchPrompt(obj)
	if not obj:IsA("ProximityPrompt") then return end
	table.insert(_stealDetectConns, obj.PromptButtonHoldBegan:Connect(function(player)
	if player ~= LP then return end
	setStealState(true)
	if _stealDetectTimer then task.cancel(_stealDetectTimer) end
	_stealDetectTimer = task.delay(CONFIG_AUTO_STEAL.HOLD_MAX + 0.5, function()
	setStealState(false)
	end)
	end))
	table.insert(_stealDetectConns, obj.Triggered:Connect(function(player)
	if player ~= LP then return end
	task.delay(0.2, function() setStealState(false) end)
	end))
	end

	table.insert(_stealDetectConns, workspace.DescendantAdded:Connect(function(obj)
	task.defer(watchPrompt, obj)
	end))
	_G.__CrystalWalkDescendantsBatched(plots, watchPrompt, function()
	return char.Parent ~= nil
	end)
	end)

	local function ensureSyncLoop()
	if syncLoopStarted then return end
	syncLoopStarted = true
	task.spawn(function()
	if startAutoStealSync() then
	if CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED then scanAllPlots() end
	while crystalRuntimeState.alive do
	task.wait(5)
	if not crystalRuntimeState.alive then break end
	if CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED then scanAllPlots() end
	end
	end
	end)
	end

	ensureSyncLoop()
	if Player.Character then task.defer(startStealDetection, Player.Character) end
	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	startStealDetection(char)
	if toggleStates["auto steal"] then
	CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED = false
	if stealConnection then stealConnection:Disconnect(); stealConnection = nil end
	CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED = true
	scanAllPlots()
	_startStealHeartbeat()
	end
	end))

	_G.CrystalAutoGrab = {
	GetMode = function() return autoStealMode end,
	SetMode = function(mode)
	if mode ~= "v1" and mode ~= "v2" then return false end
	autoStealMode = mode
	saveConfig()
	return true
	end,
	}

	local function enableAutoSteal()
	ensureSyncLoop()
	scanAllPlots()
	CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED = true
	_startStealHeartbeat()
	end

	local function disableAutoSteal()
	autoStealGeneration = autoStealGeneration + 1
	if stealConnection then stealConnection:Disconnect(); stealConnection = nil end
	CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED = false
	StealState.active = false
	StealState.phase = "idle"
	setStealState(false)
	v1Progress = 0
	InternalStealCache = {}
	V2.busy = false
	V2.data = {}
	if V3New then
	V3New.generation = V3New.generation + 1
	V3New.busy = false
	V3New.active = false
	V3New.isStealing = false
	V3New.progress = 0
	V3New.phase = "idle"
	V3New.data = {}
	end
	if V2Grab then
	V2Grab.generation = V2Grab.generation + 1
	V2Grab.busy = false
	V2Grab.active = false
	V2Grab.paused = false
	V2Grab.pauseTime = nil
	V2Grab.progress = 0
	V2Grab.phase = "idle"
	V2Grab.data = {}
	end
	end

	autoStealDisableInternal = disableAutoSteal
	_G.__CrystalTrackConn(Player.CharacterRemoving:Connect(disableAutoSteal))
	_G.__CrystalTrackStopper(disableAutoSteal)

	;(function()
	local restartSerial = 0
	local humanoidStateConnection = nil
	local platformStandConnection = nil
	local stoneSignalConnection = nil
	local ragdollLatched = false
	local ragdollResumeScheduled = false
	local stoneDetectedUntil = 0
	local RAGDOLL_DURATION = 3.0
	local RAGDOLL_REMAINING_BEFORE_GRAB = 2.0
	local STONE_MEMORY_DURATION = 5.0

	local function isRagdollState(hum, state)
	return hum.PlatformStand
	or state == Enum.HumanoidStateType.Physics
	or state == Enum.HumanoidStateType.Ragdoll
	or state == Enum.HumanoidStateType.FallingDown
	end

	local function hasPetrificationSignal(char)
	if not char then return false end
	for _, obj in ipairs(char:GetDescendants()) do
	if not obj:FindFirstAncestorOfClass("Tool") then
	local name = obj.Name:lower()
	if name:find("medusa") or name:find("petrif") or name:find("gorgon") or name:find("stone") then
	return true
	end
	for attributeName, value in pairs(obj:GetAttributes()) do
	local key = tostring(attributeName):lower()
	if value and (key:find("medusa") or key:find("petrif") or key:find("gorgon") or key:find("stone")) then
	return true
	end
	end
	end
	end
	return false
	end

	local function restartAfterRagdoll(_cameFromStone)
	restartSerial = restartSerial + 1
	local thisRestart = restartSerial
	_G.__CrystalAutoGrabRagdollBlocked = true
	ragdollResumeScheduled = true
	disableAutoSteal()

	task.delay(math.max(0, RAGDOLL_DURATION - RAGDOLL_REMAINING_BEFORE_GRAB), function()
	if thisRestart ~= restartSerial then return end
	ragdollResumeScheduled = false
	if not toggleStates["auto steal"] then return end
	_G.__CrystalAutoGrabRagdollBlocked = false
	if not CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED then enableAutoSteal() end
	end)
	end

	local function bindRagdollRestart(char)
	if humanoidStateConnection then
	humanoidStateConnection:Disconnect()
	humanoidStateConnection = nil
	end
	if platformStandConnection then
	platformStandConnection:Disconnect()
	platformStandConnection = nil
	end
	if stoneSignalConnection then
	stoneSignalConnection:Disconnect()
	stoneSignalConnection = nil
	end
	ragdollLatched = false
	stoneDetectedUntil = 0
	local hum = char and (char:FindFirstChildOfClass("Humanoid") or char:WaitForChild("Humanoid", 5))
	if not hum then return end
	if hasPetrificationSignal(char) then
	stoneDetectedUntil = tick() + STONE_MEMORY_DURATION
	end
	stoneSignalConnection = char.DescendantAdded:Connect(function(obj)
	if obj:FindFirstAncestorOfClass("Tool") then return end
	local name = obj.Name:lower()
	if name:find("medusa") or name:find("petrif") or name:find("gorgon") or name:find("stone") then
	stoneDetectedUntil = tick() + STONE_MEMORY_DURATION
	end
	end)
	local function updateRagdollState(state)
	if hasPetrificationSignal(char) then
	stoneDetectedUntil = tick() + STONE_MEMORY_DURATION
	end
	local ragdolled = isRagdollState(hum, state)
	if ragdolled and not ragdollLatched then
	ragdollLatched = true
	restartAfterRagdoll(tick() <= stoneDetectedUntil)
	elseif not ragdolled then
	ragdollLatched = false

	if not ragdollResumeScheduled then
	_G.__CrystalAutoGrabRagdollBlocked = false
	if toggleStates["auto steal"] and not CONFIG_AUTO_STEAL.AUTO_STEAL_ENABLED then
		enableAutoSteal()
	end
	end
	end
	end
	humanoidStateConnection = hum.StateChanged:Connect(function(_, state)
	updateRagdollState(state)
	end)
	platformStandConnection = hum:GetPropertyChangedSignal("PlatformStand"):Connect(function()
	updateRagdollState(hum:GetState())
	end)
	end

	if Player.Character then task.defer(bindRagdollRestart, Player.Character) end
	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(char)
	restartSerial = restartSerial + 1
	ragdollResumeScheduled = false
	_G.__CrystalAutoGrabRagdollBlocked = false
	bindRagdollRestart(char)
	end))
	end)()

	FeaturePostToggle["auto steal"] = function(active)
	if active then
	if _G.__CrystalAutoGrabRagdollBlocked ~= true then enableAutoSteal() end
	else
	disableAutoSteal()
	end
	end

	if toggleStates["auto steal"] then enableAutoSteal() end
	end

	do

	do
	local function setFeatureState(featureName, state)
	if toggleStates[featureName] == state then return end
	toggleStates[featureName] = state

	if FeaturePostToggle[featureName] then
	FeaturePostToggle[featureName](state)
	end
	if toggleVisualUpdaters[featureName] then
	toggleVisualUpdaters[featureName]()
	end
	saveConfig()
	end

	local function disableBoth()
	-- Do NOT cancel Auto Left / Auto Right on hit.
	-- QuartHub-style: path keeps running; only real toggle/stop should end it.
	end

	local function showStealCountdown(char)
	if not char then return end

	local nowT = os.clock()
	if _G._CrystalHitCountdownLast and (nowT - _G._CrystalHitCountdownLast) < 0.15 then return end
	_G._CrystalHitCountdownLast = nowT

	local gen = (_G._CrystalHitCountdownGen or 0) + 1
	_G._CrystalHitCountdownGen = gen
	_G._CrystalHitCountdownActive = true
	if _G._CrystalHitCountdownBB then
	pcall(function() _G._CrystalHitCountdownBB:Destroy() end)
	_G._CrystalHitCountdownBB = nil
	end

	pcall(function() _G._CrystalShowStealCountdown = showStealCountdown end)
	local root = char:FindFirstChild("LowerTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("UpperTorso") or char:FindFirstChild("HumanoidRootPart")
	if not root then _G._CrystalHitCountdownActive = false; return end
	local bb = Instance.new("BillboardGui")
	bb.Name = "CrystalHitCountdown"
	bb.Adornee = root
	bb.Size = UDim2.new(0, 120, 0, 56)
	bb.StudsOffset = Vector3.new(0, 0.6, 0)
	bb.AlwaysOnTop = true
	bb.LightInfluence = 0
	local parentGui = Player and (Player:FindFirstChildOfClass("PlayerGui") or game:GetService("CoreGui")) or game:GetService("CoreGui")
	bb.Parent = parentGui
	_G._CrystalHitCountdownBB = bb

	local frame = Instance.new("Frame", bb)
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0

	local label = Instance.new("TextLabel", frame)
	label.Size = UDim2.new(1, 0, 1, 0)
	label.Position = UDim2.new(0, 0, 0, 6)
	label.BackgroundTransparency = 1
	label.Text = "3"
	label.TextScaled = false
	label.TextSize = 28
	label.Font = Enum.Font.GothamBlack
	label.TextColor3 = Color3.fromRGB(175, 180, 185)
	label.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	label.TextStrokeTransparency = 0
	label.ZIndex = 10
	label.TextTransparency = 1

	local function animateText(txt, color)
	label.Text = txt
	if color then label.TextColor3 = color end
	local hold = (txt == "STEAL!") and 1.0 or 0.76

	for i = 0, 6 do
	label.TextTransparency = 1 - (i / 6)
	task.wait(0.02)
	if _G._CrystalHitCountdownGen ~= gen then return false end
	end
	task.wait(hold)
	if _G._CrystalHitCountdownGen ~= gen then return false end

	for i = 0, 6 do
	label.TextTransparency = i / 6
	task.wait(0.02)
	if _G._CrystalHitCountdownGen ~= gen then return false end
	end
	return true
	end

	task.spawn(function()
	pcall(function()
	label.TextStrokeTransparency = 0
	label.TextColor3 = Color3.fromRGB(175, 180, 185)
	for step = 0, 24 do
	local value = 2.4 - (2.4 * step / 24)
	local display = value <= 0.05 and "0" or string.format("%.1f", value)
	label.Text = display
	label.TextTransparency = 0
	for i = 0, 2 do
	label.TextTransparency = 0.18 * i
	task.wait(0.02)
	if _G._CrystalHitCountdownGen ~= gen then return end
	end
	if _G._CrystalHitCountdownGen ~= gen then return end
	task.wait(0.08)
	if _G._CrystalHitCountdownGen ~= gen then return end
	end
	if not animateText("STEAL!", Color3.fromRGB(175, 180, 185)) then return end
	end)

	if _G._CrystalHitCountdownGen == gen then
	pcall(function() bb:Destroy() end)
	if _G._CrystalHitCountdownBB == bb then _G._CrystalHitCountdownBB = nil end
	_G._CrystalHitCountdownActive = false
	-- After hit countdown: ensure independent side path is still alive if toggled
	_G.__CrystalPendingAutoplayAfterCountdown = false
	task.defer(function()
		if type(_G.__CrystalMarkSidePathHit) == "function" then
			pcall(_G.__CrystalMarkSidePathHit)
		end
		local sp = _G.__CrystalSidePath
		if not sp then return end
		if toggleStates["Auto Left"] == true and (not sp.active or sp.side ~= "left") then
			if type(FeaturePostToggle["Auto Left"]) == "function" then
				pcall(FeaturePostToggle["Auto Left"], true)
			end
		elseif toggleStates["Auto Right"] == true and (not sp.active or sp.side ~= "right") then
			if type(FeaturePostToggle["Auto Right"]) == "function" then
				pcall(FeaturePostToggle["Auto Right"], true)
			end
		end
	end)
	end
	end)
	end

	local function attachDamageDetection(char)
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	local lastHealth = hum.Health

	hum.HealthChanged:Connect(function(newHealth)
	if newHealth < lastHealth then
	if type(_G.__CrystalMarkSidePathHit) == "function" then
		pcall(_G.__CrystalMarkSidePathHit)
	else
		_G.__CrystalAutoplayRecentHitUntil = tick() + 2.0
	end
	pcall(function() showStealCountdown(char) end)
	end
	lastHealth = newHealth
	end)

	if hum.StateChanged then
	hum.StateChanged:Connect(function(oldState, newState)
	local isRagdolled = (newState == Enum.HumanoidStateType.Physics or newState == Enum.HumanoidStateType.Ragdoll or newState == Enum.HumanoidStateType.FallingDown)
	if isRagdolled then
	if type(_G.__CrystalMarkSidePathHit) == "function" then
		pcall(_G.__CrystalMarkSidePathHit)
	else
		_G.__CrystalAutoplayRecentHitUntil = tick() + 2.0
	end
	pcall(function() showStealCountdown(char) end)
	end
	end)
	end

	pcall(function()
	hum:GetPropertyChangedSignal("PlatformStand"):Connect(function()
	if hum.PlatformStand then pcall(function() showStealCountdown(char) end) end
	end)
	end)

	hum.Died:Connect(function()
	-- Character dead: stop path cleanly
	if type(stopAutoplay) == "function" then pcall(stopAutoplay) end
	end)

	end

	if Player.Character then
	attachDamageDetection(Player.Character)
	end

	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(char)
	local hum = char:WaitForChild("Humanoid", 5)
	-- Fresh character: path will restart itself if still toggled via existing CharacterAdded hook
	if hum then
	attachDamageDetection(char)
	else
	task.wait(0.5)
	attachDamageDetection(char)
	end
	end))
	end

	do
	local unwalkState = {
		generation = 0,
		animationConn = nil,
		animate = nil,
		disabledByUs = false,
	}

	local function disconnectUnwalk()
		unwalkState.generation = generation + 1
		if unwalkState.animationConn then
			unwalkState.animationConn:Disconnect()
			unwalkState.animationConn = nil
		end
	end

	local function resumeAnimations(force)
		local animate = unwalkState.animate
		local shouldEnable = unwalkState.disabledByUs
		unwalkState.animate = nil
		unwalkState.disabledByUs = false
		if animate and animate.Parent and shouldEnable and (force or not toggleStates["Unwalk"]) then
			pcall(function() animate.Disabled = false end)
		end
	end

	local function applyUnwalk(character)
		local previousAnimate = unwalkState.animate
		local previouslyDisabledByUs = unwalkState.disabledByUs
		disconnectUnwalk()
		if not toggleStates["Unwalk"] or character ~= Player.Character then return end
		local generation = unwalkState.generation
		local humanoid = character:FindFirstChildOfClass("Humanoid") or character:WaitForChild("Humanoid", 5)
		local animate = character:FindFirstChild("Animate") or character:WaitForChild("Animate", 5)
		if not humanoid or not animate or generation ~= unwalkState.generation or not toggleStates["Unwalk"] then return end
		unwalkState.animate = animate
		unwalkState.disabledByUs = (previousAnimate == animate and previouslyDisabledByUs)
			or (animate:IsA("LocalScript") and not animate.Disabled)
		if animate:IsA("LocalScript") then animate.Disabled = true end

		local function stopAllTracks()
			if generation ~= unwalkState.generation or not toggleStates["Unwalk"]
				or character ~= Player.Character or humanoid.Parent ~= character then return end
			for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do
				pcall(function() track:Stop(0) end)
			end
		end

		unwalkState.animationConn = humanoid.AnimationPlayed:Connect(function(track)
			if generation ~= unwalkState.generation or not toggleStates["Unwalk"] then return end
			pcall(function() track:Stop(0) end)
		end)

		stopAllTracks()
	end

	FeaturePostToggle["Unwalk"] = function(active)
		if active then
			applyUnwalk(Player.Character)
		else
			disconnectUnwalk()
			resumeAnimations(false)
		end
	end
	_G.__CrystalTrackStopper(function()
		disconnectUnwalk()
		resumeAnimations(true)
	end)
	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(character)
		if not toggleStates["Unwalk"] then return end
		task.defer(function() applyUnwalk(character) end)
	end))
	if toggleStates["Unwalk"] then
		task.defer(function() applyUnwalk(Player.Character) end)
	end
	end

	do
	local counterConn  = nil
	local wasRagdolled = false

	local function getBat()
	local char = Player.Character
	if not char then return nil end
	local equipped = char:FindFirstChildOfClass("Tool")
	if equipped and equipped.Name:lower():find("bat") then return equipped end
	local bp = Player:FindFirstChild("Backpack")
	if bp then
	local hum = char:FindFirstChildOfClass("Humanoid")
	for _, t in ipairs(bp:GetChildren()) do
	if t:IsA("Tool") and t.Name:lower():find("bat") then
	if hum then pcall(function() hum:EquipTool(t) end) end
	return char:FindFirstChild(t.Name) or t
	end
	end
	end
	return nil
	end

	local function getClosest(hrp)
	local best, bestDist = nil, math.huge
	for _, p in ipairs(Players:GetPlayers()) do
	if p ~= Player and p.Character then
	local r = p.Character:FindFirstChild("HumanoidRootPart")
	local targetHumanoid = p.Character:FindFirstChildOfClass("Humanoid")
	if r and targetHumanoid and targetHumanoid.Health > 0 then
	local d = (hrp.Position - r.Position).Magnitude
	if d < bestDist then bestDist = d; best = r end
	end
	end
	end
	return best, bestDist
	end

	local function onRagdoll(hrp)
	if ragdollCounterPaused or not toggleStates["Ragdoll Counter"] then return end
	local char = Player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not char or not hum or not root or hum.Health <= 0 then return end
	local targetRoot, distance = getClosest(root)

	if targetRoot and distance <= 4 then
		local lookPosition = Vector3.new(targetRoot.Position.X, root.Position.Y, targetRoot.Position.Z)
		if (lookPosition - root.Position).Magnitude > 0.01 then
			pcall(function()
				hum.AutoRotate = false
				root.CFrame = CFrame.lookAt(root.Position, lookPosition)
			end)
		end
	end
	local bat = getBat()
	if bat then
	pcall(function() bat:Activate() end)
	local remote = bat:FindFirstChildWhichIsA("RemoteEvent", true)
	if remote then pcall(function() remote:FireServer() end) end
	end
	task.defer(function()
	if hum.Parent then hum.AutoRotate = true end
	end)
	end

	local function startRagdollCounter()
	if counterConn then return end
	local char = Player.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then return end

	counterConn = {}

	do
	local ok, con = pcall(function()
	return hum.StateChanged:Connect(function(_, newState)
	if ragdollCounterPaused or not toggleStates["Ragdoll Counter"] then return end
	local isRag = (newState == Enum.HumanoidStateType.Physics or newState == Enum.HumanoidStateType.Ragdoll or newState == Enum.HumanoidStateType.FallingDown)
	if isRag and not wasRagdolled then wasRagdolled = true; pcall(function() onRagdoll(hrp) end)
	elseif not isRag and wasRagdolled then wasRagdolled = false end
	end)
	end)
	if ok and con then table.insert(counterConn, con) end
	end

	do
	local ok, con = pcall(function()
	return hum:GetPropertyChangedSignal("PlatformStand"):Connect(function()
	if ragdollCounterPaused or not toggleStates["Ragdoll Counter"] then return end
	if hum.PlatformStand and not wasRagdolled then
	wasRagdolled = true
	pcall(function() onRagdoll(hrp) end)
	elseif not hum.PlatformStand then
	wasRagdolled = false
	end
	end)
	end)
	if ok and con then table.insert(counterConn, con) end
	end
	end

	local function stopRagdollCounter()
	if counterConn then
	for _, c in ipairs(counterConn) do pcall(function() c:Disconnect() end) end
	counterConn = nil
	end
	wasRagdolled = false
	end

	FeaturePostToggle["Ragdoll Counter"] = function(active)
	if active then startRagdollCounter() else stopRagdollCounter() end
	end

	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function()
	task.wait(0.5); wasRagdolled = false
	if toggleStates["Ragdoll Counter"] then
	stopRagdollCounter()
	startRagdollCounter()
	end
	end))

	if toggleStates["Ragdoll Counter"] then startRagdollCounter() end
	end

	do

	local MEDUSA_COOLDOWN = 25
	local medusaDebounce = false
	local medusaLastUsed = 0
	local medusaCounterEnabled = false
	local medusaConns = {}

	local function findMedusa()
	local char = Player.Character
	if not char then return nil end
	for _, t in ipairs(char:GetChildren()) do
	if t:IsA("Tool") and (t.Name:lower():find("medusa") or t.Name:lower():find("head") or t.Name:lower():find("stone")) then
	return t
	end
	end
	local bp = Player:FindFirstChild("Backpack")
	if bp then
	for _, t in ipairs(bp:GetChildren()) do
	if t:IsA("Tool") and (t.Name:lower():find("medusa") or t.Name:lower():find("head") or t.Name:lower():find("stone")) then
	return t
	end
	end
	end
	return nil
	end

	local function useMedusa()
	if not medusaCounterEnabled then return end
	if medusaDebounce then return end
	if tick() - medusaLastUsed < MEDUSA_COOLDOWN then return end
	local char = Player.Character
	if not char then return end
	medusaDebounce = true
	local med = findMedusa()
	if not med then
	medusaDebounce = false
	return
	end
	if med.Parent ~= char then
	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then pcall(function() hum:EquipTool(med) end) end
	task.wait(0.05)
	end
	pcall(function() med:Activate() end)
	medusaLastUsed = tick()
	medusaDebounce = false
	end

	local function onAnchorChanged(part)
	return part:GetPropertyChangedSignal("Anchored"):Connect(function()
	if medusaCounterEnabled and part.Anchored and part.Transparency == 1 then
	useMedusa()
	end
	end)
	end

	local function setupMedusa(char)
	for _, c in pairs(medusaConns) do
	pcall(function() c:Disconnect() end)
	end
	medusaConns = {}
	if not char then return end
	for _, part in ipairs(char:GetDescendants()) do
	if part:IsA("BasePart") then
	table.insert(medusaConns, onAnchorChanged(part))
	end
	end
	table.insert(medusaConns, char.DescendantAdded:Connect(function(part)
	if part:IsA("BasePart") then
	table.insert(medusaConns, onAnchorChanged(part))
	end
	end))
	end

	local function startMedusaCounter()
	medusaCounterEnabled = true
	if Player.Character then
	setupMedusa(Player.Character)
	end
	end

local function stopMedusaCounter()
	medusaCounterEnabled = false
	for _, c in pairs(medusaConns) do
	pcall(function() c:Disconnect() end)
	end
medusaConns = {}
end
_G.__CrystalTrackStopper(stopMedusaCounter)
FeaturePostToggle["Medusa Counter"] = function(active)
if active then startMedusaCounter() else stopMedusaCounter() end
end

	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(newChar)
	task.wait(0.5)
	if medusaCounterEnabled then
	setupMedusa(newChar)
	end
	end))

if toggleStates["Medusa Counter"] then
	startMedusaCounter()
	end
	end

	do
	local LP = Player

	local function getBat()
	local char = LP.Character
	if char then
	local equippedTool = char:FindFirstChildOfClass("Tool")
	if equippedTool then
	local equippedName = equippedTool.Name:lower()
	if equippedName:find("bat", 1, true) or equippedName:find("slap", 1, true) then
	return equippedTool
	end
	end
	local backpack = LP:FindFirstChildOfClass("Backpack")
	if backpack then
	for _, tool in ipairs(backpack:GetChildren()) do
	if tool:IsA("Tool") then
	local toolName = tool.Name:lower()
	if toolName:find("bat", 1, true) or toolName:find("slap", 1, true) then
	return tool
	end
	end
	end
	end
	end
	return nil
	end

	local _cypherConn = nil

	_G.__CrystalAceNormalAimbot = _G.__CrystalAceNormalAimbot or {
	target = nil,
	swingCooldown = false,
	nextSwingAt = 0,
	}
	local function getEnemyRenderCFrame(root)
	if not root then return nil end
	local rendered = root.CFrame

	local ok, current = pcall(root.GetRenderCFrame, root)
	if ok and current then rendered = current end
	return rendered
	end

	_cypherStartFollowing = function(char)
	char = char or Player.Character
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not humanoid or not root then return end
	if _cypherConn then _cypherConn:Disconnect(); _cypherConn = nil end
	_G.__CrystalAceNormalAimbot.nextSwingAt = 0
	_G.__CrystalAceNormalAimbot.swingCooldown = false
	humanoid.AutoRotate = false
	local initialBat = char:FindFirstChildOfClass("Tool") or getBat()
	if initialBat and initialBat.Parent ~= char then
	pcall(humanoid.EquipTool, humanoid, initialBat)
	end

	_cypherConn = RunService.RenderStepped:Connect((function()
	if not toggleStates["Aimbot"] then return end
	local currentChar = Player.Character
	if not currentChar then return end
	local currentRoot = currentChar:FindFirstChild("HumanoidRootPart")
	local currentHumanoid = currentChar:FindFirstChildOfClass("Humanoid")
	if not currentRoot or not currentHumanoid then return end
	if currentHumanoid.AutoRotate then currentHumanoid.AutoRotate = false end

	local bat = currentChar:FindFirstChildOfClass("Tool") or getBat()
	if bat and bat.Parent ~= currentChar then
	pcall(currentHumanoid.EquipTool, currentHumanoid, bat)
	end

	local markerCFrame = nil
	if _G.__CrystalTPBatGetMarkerCFrame then
	local ok, result = pcall(_G.__CrystalTPBatGetMarkerCFrame)
	if ok then markerCFrame = result end
	end

	local visualTarget = nil
	local visualTargetCFrame = nil
	local visualEnemy = _G.__CrystalGetVisualEnemy and _G.__CrystalGetVisualEnemy()
	if visualEnemy and visualEnemy ~= Player and visualEnemy.Character then
	local visualRoot = visualEnemy.Character:FindFirstChild("HumanoidRootPart")
	local visualHumanoid = visualEnemy.Character:FindFirstChildOfClass("Humanoid")
	if visualRoot and visualHumanoid and visualHumanoid.Health > 0 then
	visualTarget = visualRoot
	visualTargetCFrame = getEnemyRenderCFrame(visualRoot)
	end
	end
	if not markerCFrame and (not visualTarget or not visualTargetCFrame) then return end
	_G.__CrystalAceNormalAimbot.target = markerCFrame or visualTarget

	local myPosition = currentRoot.Position
	local targetCFrame = markerCFrame or visualTargetCFrame
	local targetPosition = targetCFrame.Position
	local predictedChase = targetPosition
	local direction = predictedChase - myPosition
	local flatDirection = Vector3.new(direction.X, 0, direction.Z)

	local chaseSpeed = tonumber(speedValues.CypherAimbotApproachSpeed) or 59
	local horizontalVelocity = Vector3.zero
	if flatDirection.Magnitude >= 0.01 then
	horizontalVelocity = flatDirection.Unit * chaseSpeed
	end
	local verticalVelocity = (targetPosition.Y - myPosition.Y) * 19.5
	verticalVelocity = math.clamp(verticalVelocity, -70, 110)
	local desiredVelocity = Vector3.new(
	horizontalVelocity.X,
	verticalVelocity,
	horizontalVelocity.Z
	)
	currentRoot.AssemblyLinearVelocity = desiredVelocity

	local predictedPosition = targetPosition
	if (predictedPosition - myPosition).Magnitude > 0.1 then
	local goalCFrame = CFrame.lookAt(myPosition, predictedPosition)
	local difference = currentRoot.CFrame:Inverse() * goalCFrame
	local rx, ry, rz = difference:ToEulerAnglesXYZ()
	rx = math.clamp(rx, -2.5, 2.5)
	ry = math.clamp(ry, -2.5, 2.5)
	rz = math.clamp(rz, -2.5, 2.5)
	currentRoot.AssemblyAngularVelocity = currentRoot.CFrame:VectorToWorldSpace(
	Vector3.new(rx * 42, ry * 42, rz * 42)
	)
	end

	local swingNow = tick()
	if bat and swingNow >= (_G.__CrystalAceNormalAimbot.nextSwingAt or 0) then
	_G.__CrystalAceNormalAimbot.nextSwingAt = swingNow + 0.08
	pcall(bat.Activate, bat)
	end
	end))
	end

	_cypherStop = function()
	if _cypherConn then _cypherConn:Disconnect(); _cypherConn = nil end
	if _G.__CrystalAceNormalAimbot then
	_G.__CrystalAceNormalAimbot.target = nil
	_G.__CrystalAceNormalAimbot.swingCooldown = false
	_G.__CrystalAceNormalAimbot.nextSwingAt = 0
	end
	local char = Player.Character
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if root then
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	end
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	if humanoid then humanoid.AutoRotate = true end
	end

	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	if toggleStates["Aimbot"] then _cypherStartFollowing(char) end
	end))

	FeaturePostToggle["Aimbot"] = function(active)
	if active then
	if _G.__stopSpeedBoost then _G.__stopSpeedBoost() end
	if autoplayActive or toggleStates["Autoplay"] then
	_G.__stopAutoplay()
	end
	deactivateOtherAimbots("Aimbot")
	if _G.__deactivateBatExclusive then _G.__deactivateBatExclusive("Aimbot") end
	_G.__checkAndAutoDrop(function()
	local char = Player.Character
	if char then _cypherStartFollowing(char) end
	end)
	else
	_cypherStop()
	if _G.__refreshSpeedBoost then _G.__refreshSpeedBoost() end
	end
	end


	-- Preserve Zurich V4 NORMAL before the next aimbot implementation replaces the shared callbacks.
	_G.__ZurichV4NormalStart = _cypherStartFollowing
	_G.__ZurichV4NormalStop = _cypherStop

	do
	pcall(function()
	local oldSphere = workspace:FindFirstChild("PredictionSphere")
	if oldSphere then oldSphere:Destroy() end
	end)
	local Z = {
	targetPlayer = nil,
	lastTargetPos = nil,
	targetVelocity = Vector3.zero,
	smoothedVelocity = Vector3.zero,
	velocityHistory = {},
	accelerationHistory = {},
	aerialVelocityHistory = {},
	verticalVelocityHistory = {},
	previousDirection = nil,
	lastDirectionChangeTime = 0,
	airborneTime = 0,
	lastYVelocity = 0,
	lastJumpTime = 0,
	lastActivationTime = 0,
	currentPing = 0.1,
	realPingMs = 0,
	}
	local ZCFG = {
	FOLLOW_SPEED = 59,
	ACTIVATE_DISTANCE = 13,
	MIN_FOLLOW_DISTANCE = 1,
	PREDICTION_TIME = 0.22,
	PREDICT_AHEAD = 3,
	MAX_VELOCITY_CHANGE = 150,
	VELOCITY_SMOOTHING = 0.2,
	MAX_HORIZONTAL_VELOCITY = 80,
	SERVER_TICKRATE = 1 / 60,
	MIN_PING_COMPENSATION = 0.03,
	MAX_PING_COMPENSATION = 0.25,
	ACCELERATION_PREDICTION_WEIGHT = 0.3,
	DIRECTION_CHANGE_DETECTION_TIME = 0.12,
	QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
	GRAVITY = 196.2,
	AIR_CONTROL_FACTOR = 0.8,
	AERIAL_VELOCITY_DECAY = 0.95,
	MIN_AIRBORNE_TIME = 0.08,
	FALLING_SPEED_THRESHOLD = -15,
	}
	local zurichConn = nil
	local function averageVector(history)
	if #history == 0 then return Vector3.zero end
	local total = Vector3.zero
	for _, value in ipairs(history) do total = total + value end
	return total / #history
	end
	local function pushHistory(history, value, maximum)
	table.insert(history, value)
	if #history > maximum then table.remove(history, 1) end
	end
	local function resetZurichTarget()
	Z.targetPlayer = nil
	Z.lastTargetPos = nil
	Z.targetVelocity = Vector3.zero
	Z.smoothedVelocity = Vector3.zero
	Z.velocityHistory = {}
	Z.accelerationHistory = {}
	Z.aerialVelocityHistory = {}
	Z.verticalVelocityHistory = {}
	Z.previousDirection = nil
	Z.airborneTime = 0
	Z.lastYVelocity = 0
	end
	local function nearestZurichTarget(root)
	local nearest, nearestDistance = nil, math.huge
	for _, candidate in ipairs(Players:GetPlayers()) do
	if candidate ~= Player and candidate.Character then
	local targetRoot = candidate.Character:FindFirstChild("HumanoidRootPart")
	local targetHumanoid = candidate.Character:FindFirstChildOfClass("Humanoid")
	if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
	local distance = (root.Position - targetRoot.Position).Magnitude
	if distance < nearestDistance then nearest, nearestDistance = candidate, distance end
	end
	end
	end
	return nearest
	end
	local function rotateZurichRoot(root, direction)
	if direction.Magnitude < 0.01 then return end
	local axis = root.CFrame.LookVector:Cross(direction.Unit)
	local angle = math.asin(math.clamp(axis.Magnitude, -1, 1))
	root.AssemblyAngularVelocity = axis.Magnitude > 0.01 and axis.Unit * angle * 80 or Vector3.zero
	end
	-- Imported Akatsuki marker bridge.  The TP Bat marker is optional; when it
	-- does not exist, the original Akatsuki nearest-player aimbot path runs.
	local function getImportedBatAimbotMarker()
		local markerGetter = _G.__AkatsukiTPBatGetMarkerCFrame or _G.__CrystalTPBatGetMarkerCFrame
		if type(markerGetter) ~= "function" then return nil end
		local ok, markerCFrame = pcall(markerGetter)
		return ok and markerCFrame or nil
	end
	local function sampleZurichPing()
	local ok, value = pcall(function()
	return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
	end)
	if ok and type(value) == "number" then Z.realPingMs = math.floor(value) end
	Z.currentPing = math.clamp(Z.realPingMs / 1000, ZCFG.MIN_PING_COMPENSATION, ZCFG.MAX_PING_COMPENSATION)
	end
	task.spawn(function()
	while _G.__CRYSTAL_STATE == crystalRuntimeState do
	pcall(sampleZurichPing)
	task.wait(0.5)
	end
	end)

	local function stopZurichAimbot()
	if zurichConn then zurichConn:Disconnect(); zurichConn = nil end
	local char = Player.Character
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if humanoid then humanoid.AutoRotate = true end
	if root then root.AssemblyAngularVelocity = Vector3.zero end
	resetZurichTarget()
	Z.lastActivationTime = 0
	end

	local function startZurichAimbot(char)
	char = char or Player.Character
	local humanoid = char and char:FindFirstChildOfClass("Humanoid")
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not humanoid or not root then return end
	stopZurichAimbot()
	humanoid.AutoRotate = false
	local bat = getBat()
	if bat and bat.Parent ~= char then pcall(humanoid.EquipTool, humanoid, bat) end
	zurichConn = RunService.RenderStepped:Connect(function(dt)
	if not toggleStates["Aimbot"] then stopZurichAimbot(); return end
	local currentChar = Player.Character
	local currentRoot = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
	local currentHumanoid = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
	if not currentRoot or not currentHumanoid or currentHumanoid.Health <= 0 then return end
	currentHumanoid.AutoRotate = false
	root, humanoid = currentRoot, currentHumanoid
	bat = currentChar:FindFirstChildOfClass("Tool") or getBat()
	if bat and bat.Parent ~= currentChar then pcall(currentHumanoid.EquipTool, currentHumanoid, bat) end

	local markerCFrame = getImportedBatAimbotMarker()
	if markerCFrame then
	local markedDirection = markerCFrame.Position - root.Position
	if markedDirection.Magnitude > 0.1 then rotateZurichRoot(root, markedDirection) end
	if markedDirection.Magnitude > ZCFG.MIN_FOLLOW_DISTANCE then
	local markedSpeed = tonumber(speedValues.CypherAimbotApproachSpeed) or ZCFG.FOLLOW_SPEED
	root.AssemblyLinearVelocity = markedDirection.Unit * math.clamp(markedSpeed, 1, 120)
	else
	root.AssemblyLinearVelocity = Vector3.zero
	end
	return
	end

	Z.targetPlayer = nearestZurichTarget(root)
	local targetChar = Z.targetPlayer and Z.targetPlayer.Character
	local targetRoot = targetChar and targetChar:FindFirstChild("HumanoidRootPart")
	local targetHumanoid = targetChar and targetChar:FindFirstChildOfClass("Humanoid")
	if not targetRoot or not targetHumanoid or targetHumanoid.Health <= 0 then resetZurichTarget(); return end
	local targetPos = targetRoot.Position
	local safeDt = math.max(dt, 1 / 240)
	if Z.lastTargetPos then
	local rawVelocity = (targetPos - Z.lastTargetPos) / safeDt
	local velocityDelta = rawVelocity - Z.targetVelocity
	if velocityDelta.Magnitude > ZCFG.MAX_VELOCITY_CHANGE then
	rawVelocity = Z.targetVelocity + velocityDelta.Unit * ZCFG.MAX_VELOCITY_CHANGE
	end
	local horizontal = Vector3.new(rawVelocity.X, 0, rawVelocity.Z)
	if horizontal.Magnitude > ZCFG.MAX_HORIZONTAL_VELOCITY then
	horizontal = horizontal.Unit * ZCFG.MAX_HORIZONTAL_VELOCITY
	rawVelocity = Vector3.new(horizontal.X, rawVelocity.Y, horizontal.Z)
	end
	pushHistory(Z.accelerationHistory, (rawVelocity - Z.targetVelocity) / safeDt, 4)
	pushHistory(Z.velocityHistory, rawVelocity, 8)
	pushHistory(Z.verticalVelocityHistory, rawVelocity.Y, 5)
	Z.targetVelocity = rawVelocity
	Z.smoothedVelocity = Z.smoothedVelocity:Lerp(rawVelocity, ZCFG.VELOCITY_SMOOTHING)
	end
	Z.lastTargetPos = targetPos

	local airborne = targetHumanoid.FloorMaterial == Enum.Material.Air
	Z.airborneTime = airborne and (Z.airborneTime + safeDt) or 0
	if airborne and Z.airborneTime >= ZCFG.MIN_AIRBORNE_TIME then
	pushHistory(Z.aerialVelocityHistory, Z.targetVelocity, 6)
	elseif not airborne then
	Z.aerialVelocityHistory = {}
	end
	local predictionVelocity = Z.smoothedVelocity
	if airborne and #Z.aerialVelocityHistory > 0 then
	local aerial = averageVector(Z.aerialVelocityHistory)
	predictionVelocity = Vector3.new(aerial.X, Z.targetVelocity.Y, aerial.Z) * ZCFG.AIR_CONTROL_FACTOR
	end
	local quickTurn = false
	local horizontalVelocity = Vector3.new(Z.targetVelocity.X, 0, Z.targetVelocity.Z)
	if horizontalVelocity.Magnitude > 5 then
	local direction = horizontalVelocity.Unit
	if Z.previousDirection and Z.previousDirection:Dot(direction) < 0.5 then
	quickTurn = tick() - Z.lastDirectionChangeTime < ZCFG.DIRECTION_CHANGE_DETECTION_TIME
	Z.lastDirectionChangeTime = tick()
	end
	Z.previousDirection = direction
	end
	local serverDelay = Z.currentPing + ZCFG.SERVER_TICKRATE
	if quickTurn then serverDelay = serverDelay * ZCFG.QUICK_DIRECTION_CHANGE_MULTIPLIER end
	local predicted = targetPos + predictionVelocity * serverDelay
	local acceleration = averageVector(Z.accelerationHistory)
	predicted = predicted + acceleration * ZCFG.ACCELERATION_PREDICTION_WEIGHT * (serverDelay * serverDelay * 0.5)
	local predictionTime = ZCFG.PREDICTION_TIME * 1.1
	if airborne then
	predicted = predicted + predictionVelocity * predictionTime
	predicted = predicted + Vector3.new(0, -0.5 * ZCFG.GRAVITY * predictionTime * predictionTime, 0)
	else
	predicted = predicted + predictionVelocity * predictionTime
	end
	local flatPrediction = Vector3.new(predictionVelocity.X, 0, predictionVelocity.Z)
	if flatPrediction.Magnitude > 1 then predicted = predicted + flatPrediction.Unit * ZCFG.PREDICT_AHEAD end
	local toTarget = predicted - root.Position
	rotateZurichRoot(root, toTarget)
	if (targetPos - root.Position).Magnitude <= ZCFG.ACTIVATE_DISTANCE and tick() - Z.lastActivationTime >= 0.3 then
	if bat then pcall(bat.Activate, bat) end
	Z.lastActivationTime = tick()
	end
	if toTarget.Magnitude > ZCFG.MIN_FOLLOW_DISTANCE then
	local speed = math.clamp(tonumber(speedValues.CypherAimbotApproachSpeed) or ZCFG.FOLLOW_SPEED or 59, 1, 120)
	root.AssemblyLinearVelocity = toTarget.Unit * speed
	else
	root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y * 0.5, 0)
	end
	end)
	end

	_cypherStartFollowing = startZurichAimbot
	_cypherStop = stopZurichAimbot
	FeaturePostToggle["Aimbot"] = function(active)
	if active then
	if _G.__stopSpeedBoost then _G.__stopSpeedBoost() end
	if autoplayActive or toggleStates["Autoplay"] then _G.__stopAutoplay() end
	deactivateOtherAimbots("Aimbot")
	if _G.__deactivateBatExclusive then _G.__deactivateBatExclusive("Aimbot") end
	_G.__checkAndAutoDrop(function() startZurichAimbot(Player.Character) end)
	else
	stopZurichAimbot()
	if _G.__refreshSpeedBoost then _G.__refreshSpeedBoost() end
	end
	end
	_G.__CrystalTrackStopper(stopZurichAimbot)
	-- Preserve Zurich V4 BYPASS before V1 installs its own callbacks.
	_G.__ZurichV4BypassStart = startZurichAimbot
	_G.__ZurichV4BypassStop = stopZurichAimbot
	end

	-- Aimbot start is owned by the final V1/V2 engine block below (not Zurich).
	end


	-- ============================================================
	-- Rival Hub Aimbot (Bypass Bat / adaptBP) — used as Vylo Aimbot V1
	-- ============================================================
	do
		local RivalAim = {
			bypassBatEnabled = false,
			bypassBatSpeed = tonumber(speedValues and speedValues.CypherAimbotApproachSpeed) or 58,
		}
		local circleConnection = nil
		local circleSafetyConn = nil
		local stopCircleCombat
		local startCircleCombat

		local ADAPT_BP_ANG = "_AdaptBP_AngV"
		local ADAPT_BP_ATT = "_AdaptBP_Att"
		local ADAPT_BP_CLEAN = {
			"LockBAV", "LockAngVel", "LockBodyAtt", "BatLock", "LockBAVAtt",
			"AutoBatAtt", "AutoBatAV", "AntiBatDet", "AntiAim", "VelocityLock",
		}
		local ADAPT_BP_SWING_RANGE = 12

		local adaptBP = {
			equipped = false,
			target = nil,
			intendedVelocity = Vector3.zero,
			angularVelocity = nil,
			attachment = nil,
			respawnConn = nil,
		}
		_G.__RivalHubBubbleAimbotState = adaptBP

		local function isBatTool(tool)
			if not tool or not tool:IsA("Tool") then return false end
			local n = tool.Name:lower()
			return n:find("bat", 1, true) ~= nil or n:find("slap", 1, true) ~= nil
		end

		local function adaptBPClean(root)
			if not root then return end
			pcall(function()
				for _, n in ipairs(ADAPT_BP_CLEAN) do
					local c = root:FindFirstChild(n)
					if c then c:Destroy() end
				end
				for _, child in ipairs(root:GetChildren()) do
					if child.Name ~= ADAPT_BP_ANG and child.Name ~= ADAPT_BP_ATT then
						local ln = child.Name:lower()
						if ln:find("lockb") or ln:find("lockangv") or ln:find("batlock")
							or ln:find("antiaim") or ln:find("velocitylock") then
							child:Destroy()
						end
					end
				end
			end)
		end

		local function adaptBPEnsureAngular(parent)
			if not parent then return end
			pcall(function()
				local a = parent:FindFirstChild(ADAPT_BP_ANG); if a then a:Destroy() end
				local b = parent:FindFirstChild(ADAPT_BP_ATT); if b then b:Destroy() end
			end)
			local att = Instance.new("Attachment")
			att.Name = ADAPT_BP_ATT
			att.Parent = parent
			local angV = Instance.new("AngularVelocity")
			angV.Name = ADAPT_BP_ANG
			angV.Attachment0 = att
			angV.RelativeTo = Enum.ActuatorRelativeTo.World
			angV.MaxTorque = math.huge
			angV.AngularVelocity = Vector3.zero
			angV.Parent = parent
			adaptBP.attachment = att
			adaptBP.angularVelocity = angV
		end

		local function adaptBPRemoveAngular()
			pcall(function()
				if adaptBP.angularVelocity and adaptBP.angularVelocity.Parent then
					adaptBP.angularVelocity:Destroy()
				end
			end)
			pcall(function()
				if adaptBP.attachment and adaptBP.attachment.Parent then
					adaptBP.attachment:Destroy()
				end
			end)
			adaptBP.angularVelocity = nil
			adaptBP.attachment = nil
		end

		local function adaptBPFindBat()
			local char = Player.Character
			if char then
				for _, child in ipairs(char:GetChildren()) do
					if child:IsA("Tool") then
						local n = child.Name:lower()
						if n:find("bat", 1, true) or n:find("slap", 1, true) then
							return child
						end
					end
				end
			end
			local backpack = Player:FindFirstChildOfClass("Backpack")
			if backpack then
				for _, child in ipairs(backpack:GetChildren()) do
					if child:IsA("Tool") then
						local n = child.Name:lower()
						if n:find("bat", 1, true) or n:find("slap", 1, true) then
							return child
						end
					end
				end
			end
			return nil
		end

		local function adaptBPNearest(fromRoot)
			local best, bestDist = nil, math.huge
			for _, plr in ipairs(Players:GetPlayers()) do
				if plr ~= Player and plr.Character then
					local hrp = plr.Character:FindFirstChild("HumanoidRootPart")
					local hum = plr.Character:FindFirstChildOfClass("Humanoid")
					if hrp and hum and hum.Health > 0 then
						local d = (hrp.Position - fromRoot.Position).Magnitude
						if d < bestDist then
							bestDist = d
							best = hrp
						end
					end
				end
			end
			return best, bestDist
		end

		startCircleCombat = function()
			if circleConnection then return end
			adaptBP.equipped = false
			adaptBP.target = nil
			adaptBP.intendedVelocity = Vector3.zero

			local c0 = Player.Character
			local r0 = c0 and c0:FindFirstChild("HumanoidRootPart")
			if r0 then
				adaptBPClean(r0)
				adaptBPEnsureAngular(r0)
			end

			circleConnection = RunService.Heartbeat:Connect(function()
				if not RivalAim.bypassBatEnabled then return end
				local char = Player.Character
				local humanoid = char and char:FindFirstChildOfClass("Humanoid")
				local root = char and char:FindFirstChild("HumanoidRootPart")
				if not root or not humanoid or humanoid.Health <= 0 then return end

				adaptBPClean(root)
				if not adaptBP.angularVelocity or not adaptBP.angularVelocity.Parent then
					adaptBPEnsureAngular(root)
				end

				if not adaptBP.equipped then
					adaptBP.equipped = true
					if not char:FindFirstChildOfClass("Tool") then
						local b = adaptBPFindBat()
						if b then pcall(function() humanoid:EquipTool(b) end) end
					end
				end

				local target, dist = adaptBPNearest(root)
				if not target then
					adaptBP.target = nil
					humanoid.AutoRotate = true
					if adaptBP.angularVelocity then
						adaptBP.angularVelocity.AngularVelocity = Vector3.zero
					end
					return
				end
				adaptBP.target = target

				local aimPos = target.Position
					+ target.CFrame.LookVector * (target.AssemblyLinearVelocity.Magnitude < 0.1 and 1.5 or 5)
				local delta = aimPos - root.Position
				local flat = Vector3.new(delta.X, 0, delta.Z)
				humanoid.AutoRotate = false

				if delta.Magnitude > 0.01 and flat.Magnitude > 0.01 and adaptBP.angularVelocity then
					local curY = root.Orientation.Y
					local yawD = (math.deg(math.atan2(-flat.X, -flat.Z)) - curY + 180) % 360 - 180
					local curX = root.Orientation.X
					local pitchD = (math.deg(math.atan2(delta.Y, flat.Magnitude)) - curX + 180) % 360 - 180
					local rotY = math.clamp(math.rad(yawD) * 40, -28, 28)
					local rotX = math.clamp(math.rad(pitchD) * 40, -28, 28)
					local yawR = math.rad(root.Orientation.Y)
					local fwd = Vector3.new(math.cos(yawR), 0, -math.sin(yawR))
					adaptBP.angularVelocity.AngularVelocity = Vector3.new(0, rotY, 0) + fwd * rotX
				elseif adaptBP.angularVelocity then
					adaptBP.angularVelocity.AngularVelocity = Vector3.zero
				end

				local spd = tonumber(RivalAim.bypassBatSpeed) or 58
				if spd ~= spd or spd <= 0 or spd == math.huge then spd = 58 end

				adaptBP.intendedVelocity =
					(flat.Magnitude > 0.1 and flat.Unit * spd or Vector3.zero)
					+ (math.abs(delta.Y) > 0.8
						and Vector3.new(0, math.sign(delta.Y) * spd, 0)
						or Vector3.new(0, -2, 0))
				pcall(function()
					root.AssemblyLinearVelocity = adaptBP.intendedVelocity
				end)
				pcall(function()
					root.Velocity = adaptBP.intendedVelocity
				end)

				if flat.Magnitude > 0.5 then
					pcall(function() humanoid:Move(flat.Unit, false) end)
				end

				if dist <= ADAPT_BP_SWING_RANGE then
					local bat = char:FindFirstChildOfClass("Tool")
					if bat and isBatTool(bat) then
						pcall(function()
							bat:Activate()
							local re = bat:FindFirstChildWhichIsA("RemoteEvent")
							if re then re:FireServer() end
						end)
					end
				end
			end)

			circleSafetyConn = RunService.RenderStepped:Connect(function()
				if not RivalAim.bypassBatEnabled then return end
				local char = Player.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				if not root then return end
				local v = root.AssemblyLinearVelocity
				if math.abs(v.X) > 350 or math.abs(v.Z) > 350 then
					pcall(function()
						root.AssemblyLinearVelocity = adaptBP.intendedVelocity
					end)
				end
				adaptBPClean(root)
			end)

			if not adaptBP.respawnConn then
				adaptBP.respawnConn = Player.CharacterAdded:Connect(function(character)
					task.wait(0.5)
					adaptBP.equipped = false
					adaptBP.target = nil
					if RivalAim.bypassBatEnabled then
						local root = character:WaitForChild("HumanoidRootPart", 5)
						if root then
							adaptBPClean(root)
							adaptBPEnsureAngular(root)
						end
					end
				end)
				if _G.__CrystalTrackConn then
					_G.__CrystalTrackConn(adaptBP.respawnConn)
				end
			end
		end

		stopCircleCombat = function()
			if circleConnection then
				circleConnection:Disconnect()
				circleConnection = nil
			end
			if circleSafetyConn then
				circleSafetyConn:Disconnect()
				circleSafetyConn = nil
			end
			adaptBP.equipped = false
			adaptBP.target = nil

			local char = Player.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if root then
				pcall(function()
					root.AssemblyLinearVelocity = root.AssemblyLinearVelocity * 0.3
				end)
			end
			if hum then hum.AutoRotate = true end
			if adaptBP.angularVelocity then
				pcall(function() adaptBP.angularVelocity.AngularVelocity = Vector3.zero end)
			end
			adaptBPRemoveAngular()
			if root then
				local a = root:FindFirstChild(ADAPT_BP_ANG); if a then a:Destroy() end
				local at = root:FindFirstChild(ADAPT_BP_ATT); if at then at:Destroy() end
			end
		end

		_G.__RivalHubAimbotStart = function(char)
			RivalAim.bypassBatSpeed = tonumber(speedValues and speedValues.CypherAimbotApproachSpeed)
				or tonumber(speedValues and speedValues.AimbotSpeed)
				or RivalAim.bypassBatSpeed
				or 58
			RivalAim.bypassBatEnabled = true
			if type(startCircleCombat) == "function" then
				startCircleCombat()
			end
		end
		_G.__RivalHubAimbotStop = function()
			RivalAim.bypassBatEnabled = false
			if type(stopCircleCombat) == "function" then
				pcall(stopCircleCombat)
			end
		end
		if _G.__CrystalTrackStopper then
			_G.__CrystalTrackStopper(function()
				pcall(function()
					if type(stopCircleCombat) == "function" then stopCircleCombat() end
				end)
			end)
		end
	end


	-- ==================== CLEAN BAT BYPASS (ported as Vylo Bypass / engine 2) ====================
	do
		local BB = {
			Enabled = false,
			Connection = nil,
			Z = {
				targetPlayer = nil,
				lastTargetPos = nil,
				targetVelocity = Vector3.zero,
				smoothedVelocity = Vector3.zero,
				velocityHistory = {},
				accelerationHistory = {},
				aerialVelocityHistory = {},
				previousDirection = nil,
				lastDirectionChangeTime = 0,
				airborneTime = 0,
				lastActivationTime = 0,
				currentPing = 0.1,
				realPingMs = 0,
			},
			ZCFG = {
				FOLLOW_SPEED = 55,
				ACTIVATE_DISTANCE = 13,
				MIN_FOLLOW_DISTANCE = 1,
				PREDICTION_TIME = 0.22,
				PREDICT_AHEAD = 3,
				MAX_VELOCITY_CHANGE = 150,
				VELOCITY_SMOOTHING = 0.2,
				MAX_HORIZONTAL_VELOCITY = 80,
				SERVER_TICKRATE = 1 / 60,
				MIN_PING_COMPENSATION = 0.03,
				MAX_PING_COMPENSATION = 0.25,
				ACCELERATION_PREDICTION_WEIGHT = 0.3,
				DIRECTION_CHANGE_DETECTION_TIME = 0.12,
				QUICK_DIRECTION_CHANGE_MULTIPLIER = 1.5,
				GRAVITY = 196.2,
				AIR_CONTROL_FACTOR = 0.8,
				MIN_AIRBORNE_TIME = 0.08,
			},
		}

		local function bbAverageVector(history)
			if #history == 0 then return Vector3.zero end
			local total = Vector3.zero
			for _, v in ipairs(history) do total = total + v end
			return total / #history
		end

		local function bbPushHistory(history, value, maximum)
			table.insert(history, value)
			if #history > maximum then table.remove(history, 1) end
		end

		local function bbFindBat()
			local char = Player.Character
			if not char then return nil end
			local equipped = char:FindFirstChildOfClass("Tool")
			if equipped then
				local n = equipped.Name:lower()
				if n:find("bat", 1, true) or n:find("slap", 1, true) then
					return equipped
				end
			end
			local bp = Player:FindFirstChildOfClass("Backpack")
			if bp then
				for _, tool in ipairs(bp:GetChildren()) do
					if tool:IsA("Tool") then
						local n = tool.Name:lower()
						if n:find("bat", 1, true) or n:find("slap", 1, true) then
							return tool
						end
					end
				end
			end
			return nil
		end

		local function bbResetTarget()
			local Z = BB.Z
			Z.targetPlayer = nil
			Z.lastTargetPos = nil
			Z.targetVelocity = Vector3.zero
			Z.smoothedVelocity = Vector3.zero
			Z.velocityHistory = {}
			Z.accelerationHistory = {}
			Z.aerialVelocityHistory = {}
			Z.previousDirection = nil
			Z.airborneTime = 0
		end

		local function bbNearestTarget(root)
			local nearest, nearestDistance = nil, math.huge
			for _, candidate in ipairs(Players:GetPlayers()) do
				if candidate ~= Player and candidate.Character then
					local targetRoot = candidate.Character:FindFirstChild("HumanoidRootPart")
					local targetHumanoid = candidate.Character:FindFirstChildOfClass("Humanoid")
					if targetRoot and targetHumanoid and targetHumanoid.Health > 0 then
						local distance = (root.Position - targetRoot.Position).Magnitude
						if distance < nearestDistance then
							nearest, nearestDistance = candidate, distance
						end
					end
				end
			end
			return nearest
		end

		local function bbRotateRoot(root, direction)
			if direction.Magnitude < 0.01 then return end
			local axis = root.CFrame.LookVector:Cross(direction.Unit)
			local angle = math.asin(math.clamp(axis.Magnitude, -1, 1))
			root.AssemblyAngularVelocity = axis.Magnitude > 0.01
				and axis.Unit * angle * 80
				or Vector3.zero
		end

		local function bbSamplePing()
			local ok, value = pcall(function()
				return game:GetService("Stats").Network.ServerStatsItem["Data Ping"]:GetValue()
			end)
			local Z = BB.Z
			if ok and type(value) == "number" then Z.realPingMs = math.floor(value) end
			Z.currentPing = math.clamp(
				Z.realPingMs / 1000,
				BB.ZCFG.MIN_PING_COMPENSATION,
				BB.ZCFG.MAX_PING_COMPENSATION
			)
		end

		if not BB.PingLoopStarted then
			BB.PingLoopStarted = true
			task.spawn(function()
				while true do
					pcall(bbSamplePing)
					task.wait(0.5)
				end
			end)
		end

		local function bbGetFollowSpeed()
			-- Match Vylo speed modes: Lagger uses AimbotSpeedLagger, else AimbotSpeed / Custom
			local mode = selectedMode
			if mode == "Lagger" or laggerEnabled then
				return tonumber(speedValues.AimbotSpeedLagger) or 40
			end
			if mode == "Desync" then
				return tonumber(speedValues.AimbotSpeedCustom) or tonumber(speedValues.AimbotSpeed) or 59
			end
			return tonumber(speedValues.AimbotSpeed) or 59
		end

		local function bbStop()
			local Z = BB.Z
			BB.Enabled = false
			if BB.Connection then
				BB.Connection:Disconnect()
				BB.Connection = nil
			end
			local char = Player.Character
			local humanoid = char and char:FindFirstChildOfClass("Humanoid")
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if humanoid then humanoid.AutoRotate = true end
			if root then root.AssemblyAngularVelocity = Vector3.zero end
			bbResetTarget()
			Z.lastActivationTime = 0
		end

		local function bbStart(charArg)
			if BB.Connection then return end
			local char = charArg or Player.Character
			local humanoid = char and char:FindFirstChildOfClass("Humanoid")
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if not humanoid or not root then return end

			BB.Enabled = true
			humanoid.AutoRotate = false

			local bat = bbFindBat()
			if bat and bat.Parent ~= char then
				pcall(function() humanoid:EquipTool(bat) end)
			end

			BB.Connection = RunService.RenderStepped:Connect(function(dt)
				if not BB.Enabled then bbStop(); return end
				local Z = BB.Z
				local ZCFG = BB.ZCFG

				ZCFG.FOLLOW_SPEED = bbGetFollowSpeed()

				char = Player.Character
				humanoid = char and char:FindFirstChildOfClass("Humanoid")
				root = char and char:FindFirstChild("HumanoidRootPart")
				if not humanoid or not root or humanoid.Health <= 0 then return end

				bat = bbFindBat()
				if bat and bat.Parent ~= char then
					pcall(function() humanoid:EquipTool(bat) end)
				end

				local targetPlayer = Z.targetPlayer
				local targetRoot = targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
				local targetHumanoid = targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid")
				if not targetRoot or not targetHumanoid or targetHumanoid.Health <= 0 then
					targetPlayer = bbNearestTarget(root)
					Z.targetPlayer = targetPlayer
					targetRoot = targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart")
					targetHumanoid = targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChildOfClass("Humanoid")
					bbResetTarget()
					Z.targetPlayer = targetPlayer
					if not targetRoot then
						root.AssemblyAngularVelocity = Vector3.zero
						return
					end
				end

				local safeDt = math.clamp(dt or 0.016, 0.001, 0.05)
				local targetPos = targetRoot.Position
				if Z.lastTargetPos then
					local rawVel = (targetPos - Z.lastTargetPos) / safeDt
					if rawVel.Magnitude > ZCFG.MAX_VELOCITY_CHANGE then
						rawVel = rawVel.Unit * ZCFG.MAX_VELOCITY_CHANGE
					end
					local horiz = Vector3.new(rawVel.X, 0, rawVel.Z)
					if horiz.Magnitude > ZCFG.MAX_HORIZONTAL_VELOCITY then
						horiz = horiz.Unit * ZCFG.MAX_HORIZONTAL_VELOCITY
						rawVel = Vector3.new(horiz.X, rawVel.Y, horiz.Z)
					end
					bbPushHistory(Z.velocityHistory, rawVel, 8)
					local avg = bbAverageVector(Z.velocityHistory)
					local prev = Z.smoothedVelocity
					Z.smoothedVelocity = prev:Lerp(avg, ZCFG.VELOCITY_SMOOTHING)
					local accel = (Z.smoothedVelocity - prev) / safeDt
					bbPushHistory(Z.accelerationHistory, accel, 6)
					Z.targetVelocity = Z.smoothedVelocity
				end
				Z.lastTargetPos = targetPos

				local airborne = targetHumanoid.FloorMaterial == Enum.Material.Air
				Z.airborneTime = airborne and (Z.airborneTime + safeDt) or 0
				if airborne and Z.airborneTime >= ZCFG.MIN_AIRBORNE_TIME then
					bbPushHistory(Z.aerialVelocityHistory, Z.targetVelocity, 6)
				elseif not airborne then
					Z.aerialVelocityHistory = {}
				end

				local predictionVelocity = Z.smoothedVelocity
				if airborne and #Z.aerialVelocityHistory > 0 then
					local aerial = bbAverageVector(Z.aerialVelocityHistory)
					predictionVelocity = Vector3.new(aerial.X, Z.targetVelocity.Y, aerial.Z) * ZCFG.AIR_CONTROL_FACTOR
				end

				local quickTurn = false
				local horizontalVelocity = Vector3.new(Z.targetVelocity.X, 0, Z.targetVelocity.Z)
				if horizontalVelocity.Magnitude > 5 then
					local direction = horizontalVelocity.Unit
					if Z.previousDirection and Z.previousDirection:Dot(direction) < 0.5 then
						quickTurn = tick() - Z.lastDirectionChangeTime < ZCFG.DIRECTION_CHANGE_DETECTION_TIME
						Z.lastDirectionChangeTime = tick()
					end
					Z.previousDirection = direction
				end

				local serverDelay = Z.currentPing + ZCFG.SERVER_TICKRATE
				if quickTurn then serverDelay = serverDelay * ZCFG.QUICK_DIRECTION_CHANGE_MULTIPLIER end

				local predicted = targetPos + predictionVelocity * serverDelay
				local acceleration = bbAverageVector(Z.accelerationHistory)
				predicted = predicted + acceleration * ZCFG.ACCELERATION_PREDICTION_WEIGHT * (serverDelay * serverDelay * 0.5)

				local predictionTime = ZCFG.PREDICTION_TIME * 1.1
				if airborne then
					predicted = predicted + predictionVelocity * predictionTime
					predicted = predicted + Vector3.new(0, -0.5 * ZCFG.GRAVITY * predictionTime * predictionTime, 0)
				else
					predicted = predicted + predictionVelocity * predictionTime
				end

				local flatPrediction = Vector3.new(predictionVelocity.X, 0, predictionVelocity.Z)
				if flatPrediction.Magnitude > 1 then
					predicted = predicted + flatPrediction.Unit * ZCFG.PREDICT_AHEAD
				end

				local toTarget = predicted - root.Position
				bbRotateRoot(root, toTarget)

				if (targetPos - root.Position).Magnitude <= ZCFG.ACTIVATE_DISTANCE
					and tick() - Z.lastActivationTime >= 0.3 then
					if bat then pcall(function() bat:Activate() end) end
					Z.lastActivationTime = tick()
				end

				if toTarget.Magnitude > ZCFG.MIN_FOLLOW_DISTANCE then
					root.AssemblyLinearVelocity = toTarget.Unit * ZCFG.FOLLOW_SPEED
				else
					root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y * 0.5, 0)
				end
			end)
		end

		_G.__CleanBatBypassStart = bbStart
		_G.__CleanBatBypassStop = bbStop
		_G.__CrystalTrackStopper(bbStop)
	end

	-- Bat Aimbot: Normal (V1) = Clean Hub normal adapt, Bypass (V2) = Clean Bat Bypass
	_G.__aimbotMode = "bypass"
	if _G.__aimbotEngineVersion ~= 2 then _G.__aimbotEngineVersion = 1 end
	_G.__aimbotVersion = (_G.__aimbotEngineVersion == 2) and 2 or 1
	do
		local Conns = {}
		local _mirrorConns = {}
		local BAT_SLAP_LIST = {
			"Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap",
			"Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap",
			"Nuclear Slap", "Galaxy Slap", "Glitched Slap",
		}

		local function findBat()
			local char = Player.Character
			if not char then return nil end
			for _, name in ipairs(BAT_SLAP_LIST) do
				local tool = char:FindFirstChild(name)
				if tool and tool:IsA("Tool") then return tool end
			end
			local bp = Player:FindFirstChildOfClass("Backpack")
			if bp then
				for _, name in ipairs(BAT_SLAP_LIST) do
					local tool = bp:FindFirstChild(name)
					if tool and tool:IsA("Tool") then
						local hum = char:FindFirstChildOfClass("Humanoid")
						if hum then pcall(function() hum:EquipTool(tool) end) end
						return tool
					end
				end
			end
			for _, ch in ipairs(char:GetChildren()) do
				if ch:IsA("Tool") then
					local n = ch.Name:lower()
					if n:find("bat", 1, true) or n:find("slap", 1, true) then return ch end
				end
			end
			if bp then
				for _, tool in ipairs(bp:GetChildren()) do
					if tool:IsA("Tool") then
						local n = tool.Name:lower()
						if n:find("bat", 1, true) or n:find("slap", 1, true) then return tool end
					end
				end
			end
			return nil
		end

		local BYPASS_CHASE_SPEED = 59
		local BYPASS_HIT_DIST = 8
		local BYPASS_SWING_CD = 0.15
		local bypassHitCD = false

		local function bypassSwing()
			if bypassHitCD then return end
			bypassHitCD = true
			pcall(function()
				local char = Player.Character
				if not char then return end
				local bat = findBat()
				if not bat then return end
				if bat.Parent ~= char then
					local hum = char:FindFirstChildOfClass("Humanoid")
					if hum then pcall(function() hum:EquipTool(bat) end) end
				end
				pcall(function() bat:Activate() end)
				local handle = bat:FindFirstChild("Handle")
				if not (handle and firetouchinterest) then return end
				local myHRP = char:FindFirstChild("HumanoidRootPart")
				if not myHRP then return end
				for _, plr in ipairs(Players:GetPlayers()) do
					if plr ~= Player and plr.Character then
						local tHRP = plr.Character:FindFirstChild("HumanoidRootPart")
						if tHRP and (tHRP.Position - myHRP.Position).Magnitude <= BYPASS_HIT_DIST then
							for _, part in ipairs(plr.Character:GetChildren()) do
								if part:IsA("BasePart") then
									pcall(function()
										firetouchinterest(handle, part, 0)
										firetouchinterest(handle, part, 1)
									end)
								end
							end
						end
					end
				end
			end)
			task.delay(BYPASS_SWING_CD, function() bypassHitCD = false end)
		end

		local lockedTarget = nil
		local trackedVelocity = Vector3.zero
		local function resetTracking()
			lockedTarget = nil
			trackedVelocity = Vector3.zero
		end
		local function closestPlayerRootAndDist()
			local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
			if not root then resetTracking(); return nil, math.huge end
			local best, bestDist = nil, math.huge
			local lockedDistance = nil
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= Player and p.Character then
					local tr = p.Character:FindFirstChild("HumanoidRootPart")
					local hm = p.Character:FindFirstChildOfClass("Humanoid")
					if tr and hm and hm.Health > 0 then
						local d = (tr.Position - root.Position).Magnitude
						if tr == lockedTarget then lockedDistance = d end
						if d < bestDist then bestDist = d; best = tr end
					end
				end
			end
			-- Nearby players must be meaningfully closer before taking over the lock.
			if lockedDistance and bestDist >= lockedDistance - math.max(2, lockedDistance * 0.2) then
				best, bestDist = lockedTarget, lockedDistance
			end
			if best ~= lockedTarget then
				trackedVelocity = Vector3.zero
				lockedTarget = best
			end
			return best, bestDist
		end
		local function closestPlayerRoot()
			local root = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
			if not root then return nil end
			local best, bestDist = nil, math.huge
			for _, p in ipairs(Players:GetPlayers()) do
				if p ~= Player and p.Character then
					local tr = p.Character:FindFirstChild("HumanoidRootPart")
					local hm = p.Character:FindFirstChildOfClass("Humanoid")
					if tr and hm and hm.Health > 0 then
						local d = (tr.Position - root.Position).Magnitude
						if d < bestDist then bestDist = d; best = tr end
					end
				end
			end
			return best
		end

		local function predictedPosition(target, dt)
			local velocity = target.AssemblyLinearVelocity
			local flat = Vector3.new(velocity.X, 0, velocity.Z)
			if flat.Magnitude > 100 then flat = flat.Unit * 100 end
			local sample = Vector3.new(flat.X, math.clamp(velocity.Y, -70, 70), flat.Z)
			-- Respond immediately to a reversal rather than leading along the old heading.
			if trackedVelocity:Dot(sample) < 0 then trackedVelocity = sample end
			trackedVelocity = trackedVelocity:Lerp(sample, 1 - math.exp(-18 * math.max(dt, 0)))
			local lead = trackedVelocity * 0.08
			if lead.Magnitude > 5 then lead = lead.Unit * 5 end
			return target.Position + lead
		end
		local function turnToward(root, position, dt)
			local offset = position - root.Position
			local flat = Vector3.new(offset.X, 0, offset.Z)
			if flat.Magnitude <= 0.01 then root.AssemblyAngularVelocity = Vector3.zero; return end
			local look = root.CFrame.LookVector
			local yaw = math.atan2(-look.X, -look.Z)
			local wanted = math.atan2(-flat.X, -flat.Z)
			local error = math.atan2(math.sin(wanted - yaw), math.cos(wanted - yaw))
			local rate = math.min(16, 1 / math.max(dt, 1 / 240))
			root.AssemblyAngularVelocity = Vector3.new(0, math.clamp(error * rate, -28, 28), 0)
		end
		local function chaseVelocity(root, aimAt, maximum, dt)
			local offset = aimAt - root.Position
			local flat = Vector3.new(offset.X, 0, offset.Z)
			local remaining = math.max(0, flat.Magnitude - 2.8)
			local speed = math.min(math.clamp(maximum, 1, 200), remaining * 9, remaining / math.max(dt, 1 / 240))
			return flat.Magnitude > 0.01 and flat.Unit * speed or Vector3.zero
		end
		local function releaseMovement(root, hum)
			hum.AutoRotate = true
			root.AssemblyAngularVelocity = Vector3.zero
			root.AssemblyLinearVelocity = Vector3.new(0, root.AssemblyLinearVelocity.Y, 0)
			hum:Move(Vector3.zero, false)
		end

		local AIMBOT_ATTACHMENT_NAME = "CrystalAimbotMoveAttachment"
		local AIMBOT_MOVER_NAME = "CrystalAimbotMoveVelocity"
		local function clearAimbotMoverOn(root)
			local mover = root and root:FindFirstChild(AIMBOT_MOVER_NAME)
			if mover and mover:IsA("LinearVelocity") then mover:Destroy() end
			local attachment = root and root:FindFirstChild(AIMBOT_ATTACHMENT_NAME)
			if attachment and attachment:IsA("Attachment") then attachment:Destroy() end
		end
		_G._CrystalClearAimbotMover = function()
			local char = Player.Character
			clearAimbotMoverOn(char and char:FindFirstChild("HumanoidRootPart"))
		end

		local function aimbotSpeed()
			if selectedMode == "Lagger" or laggerEnabled then
				return tonumber(speedValues and speedValues.AimbotSpeedLagger)
					or tonumber(speedValues and speedValues.LaggerBoost)
					or 40
			end
			if selectedMode == "Desync" or (type(selectedMode) == "string" and selectedMode ~= "Normal" and selectedMode ~= "Lagger") then
				-- custom / desync family
				local custom = tonumber(speedValues and speedValues.AimbotSpeedCustom)
				if custom then return custom end
			end
			return tonumber(speedValues and speedValues.AimbotSpeed)
				or tonumber(speedValues and speedValues.CypherAimbotApproachSpeed)
				or 59
		end
		local function aimbotOn()
			return toggleStates["Aimbot"] == true
		end
		local function usesBypassLoop()
			-- Mode switcher removed: bypass loop only used by engine V2 path (handled separately).
			-- V1 local fallback always uses the normal loop.
			return false
		end

		-- Normal (Vanta "new") tuning
		local ZBAT_SPEED = 59
		local ZBAT_VERT_SPEED = 52
		local ZBAT_DIST = -2.8
		local ZBAT_HEIGHT = 4.75
		local ZBAT_VERT_OFFSET = 1
		local ZBAT_TURN_SPEED = 285
		local ZBAT_MAX_TURN_RATE = 28


				-- ==================== KATANA BAT V2 (used as Aimbot Engine V2) ====================
		-- ==================== BAT V2 - RIVAL ====================
		do
			local LP = Player
			local BAV2_ANG = "_GB_AngV"
			local BAV2_ATT = "_GB_Att"
			local BAV2_CLEAN = {
				"LockBAV", "LockAngVel", "LockBodyAtt", "BatLock", "LockBAVAtt",
				"AutoBatAtt", "AutoBatAV", "AntiBatDet", "AntiAim", "VelocityLock"
			}

			local V2 = {
				enabled = false,
				conn = nil,
				safetyConn = nil,
				target = nil,
				equipped = false,
				intendedVelocity = Vector3.zero,
				attachment = nil,
				angularVelocity = nil,
			}

			local function cleanMovers(root)
				if not root then return end
				pcall(function()
					for _, n in ipairs(BAV2_CLEAN) do
						local c = root:FindFirstChild(n)
						if c then c:Destroy() end
					end
					for _, child in ipairs(root:GetChildren()) do
						if child.Name ~= BAV2_ANG and child.Name ~= BAV2_ATT then
							local ln = string.lower(child.Name)
							if string.find(ln, "lockb", 1, true)
								or string.find(ln, "lockangv", 1, true)
								or string.find(ln, "batlock", 1, true)
								or string.find(ln, "antiaim", 1, true)
								or string.find(ln, "velocitylock", 1, true) then
								child:Destroy()
							end
						end
					end
				end)
			end

			local function ensureAngular(root)
				if not root then return end
				pcall(function()
					local a = root:FindFirstChild(BAV2_ANG)
					if a then a:Destroy() end
					local b = root:FindFirstChild(BAV2_ATT)
					if b then b:Destroy() end
				end)
				local att = Instance.new("Attachment")
				att.Name = BAV2_ATT
				att.Parent = root
				local angV = Instance.new("AngularVelocity")
				angV.Name = BAV2_ANG
				angV.Attachment0 = att
				angV.RelativeTo = Enum.ActuatorRelativeTo.World
				angV.MaxTorque = math.huge
				angV.AngularVelocity = Vector3.zero
				angV.Parent = root
				V2.attachment = att
				V2.angularVelocity = angV
			end

			local function removeAngular()
				pcall(function()
					if V2.angularVelocity and V2.angularVelocity.Parent then
						V2.angularVelocity:Destroy()
					end
				end)
				pcall(function()
					if V2.attachment and V2.attachment.Parent then
						V2.attachment:Destroy()
					end
				end)
				V2.angularVelocity = nil
				V2.attachment = nil
			end

			local function pickTarget(root)
				local visualEnemy = nil
				if type(_G.__CrystalGetVisualEnemy) == "function" then
					pcall(function() visualEnemy = _G.__CrystalGetVisualEnemy() end)
				end
				if visualEnemy and visualEnemy ~= LP and visualEnemy.Character then
					local hrp = visualEnemy.Character:FindFirstChild("HumanoidRootPart")
					local hum = visualEnemy.Character:FindFirstChildOfClass("Humanoid")
					if hrp and hum and hum.Health > 0 then
						return hrp, (hrp.Position - root.Position).Magnitude
					end
				end
				local best, bestD = nil, math.huge
				for _, p in ipairs(Players:GetPlayers()) do
					if p ~= LP and p.Character then
						local hrp = p.Character:FindFirstChild("HumanoidRootPart")
						local hum = p.Character:FindFirstChildOfClass("Humanoid")
						if hrp and hum and hum.Health > 0 then
							local d = (hrp.Position - root.Position).Magnitude
							if d < bestD then
								bestD = d
								best = hrp
							end
						end
					end
				end
				return best, bestD
			end

			local function getBat(char)
				if not char then return nil end
				for _, t in ipairs(char:GetChildren()) do
					if t:IsA("Tool") then
						local n = string.lower(t.Name)
						if string.find(n, "bat", 1, true) or string.find(n, "slap", 1, true) then
							return t
						end
					end
				end
				local backpack = LP:FindFirstChild("Backpack")
				if backpack then
					for _, t in ipairs(backpack:GetChildren()) do
						if t:IsA("Tool") then
							local n = string.lower(t.Name)
							if string.find(n, "bat", 1, true) or string.find(n, "slap", 1, true) then
								return t
							end
						end
					end
				end
				return nil
			end

			local function stopBatV2()
				V2.enabled = false
				if V2.conn then
					pcall(function() V2.conn:Disconnect() end)
					V2.conn = nil
				end
				if V2.safetyConn then
					pcall(function() V2.safetyConn:Disconnect() end)
					V2.safetyConn = nil
				end
				removeAngular()
				V2.target = nil
				V2.equipped = false
				V2.intendedVelocity = Vector3.zero
				local char = LP.Character
				local hrp = char and char:FindFirstChild("HumanoidRootPart")
				if hrp then cleanMovers(hrp) end
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				if hum then pcall(function() hum.AutoRotate = true end) end
			end

			local function startBatV2(char)
				stopBatV2()
				V2.enabled = true
				V2.equipped = false
				V2.target = nil
				V2.intendedVelocity = Vector3.zero

				local c = char or LP.Character
				local root = c and c:FindFirstChild("HumanoidRootPart")
				if root then
					cleanMovers(root)
					ensureAngular(root)
				end

				V2.conn = RunService.Heartbeat:Connect(function()
					if not V2.enabled then return end
					if toggleStates and toggleStates["Aimbot"] == false then return end

					local currentChar = LP.Character
					local hum = currentChar and currentChar:FindFirstChildOfClass("Humanoid")
					local hrp = currentChar and currentChar:FindFirstChild("HumanoidRootPart")
					if not hrp or not hum or hum.Health <= 0 then return end

					cleanMovers(hrp)
					if not V2.angularVelocity or not V2.angularVelocity.Parent then
						ensureAngular(hrp)
					end

					if not V2.equipped then
						local bat = getBat(currentChar)
						if bat and bat.Parent ~= currentChar then
							pcall(function() hum:EquipTool(bat) end)
						end
						if currentChar:FindFirstChildOfClass("Tool") then
							V2.equipped = true
						end
					end

					local target, dist = pickTarget(hrp)
					V2.target = target
					if not target then
						pcall(function() hum.AutoRotate = true end)
						if V2.angularVelocity then
							V2.angularVelocity.AngularVelocity = Vector3.zero
						end
						return
					end

					pcall(function() hum.AutoRotate = false end)

					local spd = 59
					if speedValues and tonumber(speedValues.CypherAimbotApproachSpeed) then
						spd = math.clamp(tonumber(speedValues.CypherAimbotApproachSpeed), 1, 120)
					elseif speedValues and tonumber(speedValues.AimbotSpeed) then
						spd = math.clamp(tonumber(speedValues.AimbotSpeed), 1, 120)
					end

					local tv = target.AssemblyLinearVelocity or Vector3.zero
					local aimAt = target.Position
						+ tv * math.clamp(tv.Magnitude / 130, 0.05, 0.15)
						+ Vector3.new(0, 1, 0)

					local toAim = aimAt - hrp.Position
					local flat = Vector3.new(toAim.X, 0, toAim.Z)
					if flat.Magnitude < 0.05 then return end

					local unit = flat.Unit
					local distXZ = flat.Magnitude
					local holdDist = -2.8
					local height = 3.5
					local spot = aimAt + unit * holdDist + Vector3.new(0, height, 0)
					local toSpot = spot - hrp.Position
					local spotFlat = Vector3.new(toSpot.X, 0, toSpot.Z)

					local horiz = (spotFlat.Magnitude > 0.2) and (spotFlat.Unit * spd) or Vector3.zero
					local vert = math.clamp(toSpot.Y * 2.5, -52, 52)
					V2.intendedVelocity = Vector3.new(horiz.X, vert, horiz.Z)
					hrp.AssemblyLinearVelocity = V2.intendedVelocity

					-- face target
					local look = CFrame.lookAt(hrp.Position, Vector3.new(target.Position.X, hrp.Position.Y, target.Position.Z))
					local _, yaw, _ = look:ToEulerAnglesYXZ()
					if V2.angularVelocity and V2.angularVelocity.Parent then
						local cur = hrp.CFrame
						local _, curYaw, _ = cur:ToEulerAnglesYXZ()
						local err = (yaw - curYaw + math.pi) % (2 * math.pi) - math.pi
						V2.angularVelocity.AngularVelocity = Vector3.new(0, math.clamp(err * 12, -20, 20), 0)
					end

					if spotFlat.Magnitude > 0.5 then
						pcall(function() hum:Move(spotFlat.Unit, false) end)
					end

					-- keep velocity from being overwritten
					if math.abs(hrp.AssemblyLinearVelocity.X - V2.intendedVelocity.X) > 30
						or math.abs(hrp.AssemblyLinearVelocity.Z - V2.intendedVelocity.Z) > 30 then
						hrp.AssemblyLinearVelocity = V2.intendedVelocity
					end
				end)

				if _G.__CrystalTrackConn then
					_G.__CrystalTrackConn(V2.conn)
				end
			end

			_G.__RivalBatV2Start = startBatV2
			_G.__RivalBatV2Stop = stopBatV2
			_G.__RivalBatV2Enabled = function()
				return V2.enabled == true
			end
			if _G.__CrystalTrackStopper then
				_G.__CrystalTrackStopper(stopBatV2)
			end
		end -- close Katana Bat V2 do



		-- ==================== end Katana Bat V2 ====================

		local function startBatAimbotV1()
			-- Clean Hub normal bat aimbot (startAimbotAdapt)
			resetTracking()
			if Conns.aimbot then Conns.aimbot:Disconnect(); Conns.aimbot = nil end
			if Conns.aimbotNew then Conns.aimbotNew:Disconnect(); Conns.aimbotNew = nil end

			_G.__CrystalNormalAimbot = _G.__CrystalNormalAimbot or {}
			local S = _G.__CrystalNormalAimbot
			S.target = nil
			S.swingCooldown = false
			S.prevAutoRotate = nil

			local function cleanFindBat()
				local char = Player.Character
				if not char then return nil end
				local list = {
					"Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap",
					"Emerald Slap", "Ruby Slap", "Dark Matter Slap",
					"Flame Slap", "Nuclear Slap", "Galaxy Slap", "Glitched Slap",
				}
				for _, name in ipairs(list) do
					local t = char:FindFirstChild(name)
					if t and t:IsA("Tool") then return t end
				end
				local bp = Player:FindFirstChildOfClass("Backpack")
				if bp then
					for _, name in ipairs(list) do
						local t = bp:FindFirstChild(name)
						if t and t:IsA("Tool") then
							local hum = char:FindFirstChildOfClass("Humanoid")
							if hum then pcall(function() hum:EquipTool(t) end) end
							return t
						end
					end
				end
				for _, ch in ipairs(char:GetChildren()) do
					if ch:IsA("Tool") then
						local n = ch.Name:lower()
						if n:find("bat", 1, true) or n:find("slap", 1, true) then return ch end
					end
				end
				if bp then
					for _, ch in ipairs(bp:GetChildren()) do
						if ch:IsA("Tool") then
							local n = ch.Name:lower()
							if n:find("bat", 1, true) or n:find("slap", 1, true) then return ch end
						end
					end
				end
				return nil
			end

			local function cleanIsBatTool(tool)
				if not tool then return false end
				local n = tool.Name:lower()
				return n:find("bat", 1, true) ~= nil or n:find("slap", 1, true) ~= nil
			end

			local function cleanClosestTarget()
				local char = Player.Character
				if not char then return nil end
				local root = char:FindFirstChild("HumanoidRootPart")
				if not root then return nil end
				local rpos = root.Position
				local closest, minDist = nil, math.huge
				for _, plr in ipairs(Players:GetPlayers()) do
					if plr ~= Player then
						local c = plr.Character
						if c then
							local tRoot = c:FindFirstChild("HumanoidRootPart")
							local hum = c:FindFirstChildOfClass("Humanoid")
							if tRoot and hum and hum.Health > 0 then
								local d = (tRoot.Position - rpos).Magnitude
								if d < minDist then
									minDist = d
									closest = tRoot
								end
							end
						end
					end
				end
				return closest
			end

			local function cleanTrySwing()
				if S.swingCooldown then return end
				S.swingCooldown = true
				pcall(function()
					local char = Player.Character
					if not char then return end
					local currentTool = char:FindFirstChildOfClass("Tool")
					if currentTool and not cleanIsBatTool(currentTool) then return end
					local bat = cleanFindBat()
					if bat then
						if bat.Parent ~= char then
							local hum = char:FindFirstChildOfClass("Humanoid")
							if hum then pcall(function() hum:EquipTool(bat) end) end
						end
						pcall(function() bat:Activate() end)
					end
				end)
				task.delay(0.12, function() S.swingCooldown = false end)
			end

			local function cleanFollowSpeed()
				local mode = selectedMode
				if mode == "Lagger" or laggerEnabled then
					return tonumber(speedValues.AimbotSpeedLagger) or 40
				end
				if mode == "Desync" then
					return tonumber(speedValues.AimbotSpeedCustom) or tonumber(speedValues.AimbotSpeed) or 58
				end
				return tonumber(speedValues.AimbotSpeed) or 58
			end

			local hum0 = Player.Character and Player.Character:FindFirstChildOfClass("Humanoid")
			if hum0 then
				S.prevAutoRotate = hum0.AutoRotate
				hum0.AutoRotate = false
			end

			Conns.aimbot = RunService.RenderStepped:Connect(function()
				if not (toggleStates and toggleStates["Aimbot"]) then return end
				if (_G.__aimbotEngineVersion or 1) == 2 then return end

				local char = Player.Character
				if not char then return end
				local root = char:FindFirstChild("HumanoidRootPart")
				local hum = char:FindFirstChildOfClass("Humanoid")
				if not root or not hum or hum.Health <= 0 then return end

				if not char:FindFirstChildOfClass("Tool") then
					local bat = cleanFindBat()
					if bat then pcall(function() hum:EquipTool(bat) end) end
				end

				local target = cleanClosestTarget()
				S.target = target
				if not target then return end

				local targetVel = target.AssemblyLinearVelocity
				local myPos = root.Position
				local targetPos = target.Position
				local predictPos = targetPos + targetVel * 0.14
				predictPos = predictPos + target.CFrame.LookVector * 0.3
				local direction = predictPos - myPos
				local flatDir = Vector3.new(direction.X, 0, direction.Z)
				if flatDir.Magnitude > 0 then
					flatDir = flatDir.Unit
				else
					flatDir = Vector3.zero
				end

				local desiredHeight = targetPos.Y + 3.7
				local yVel = (desiredHeight - myPos.Y) * 19.5 + targetVel.Y * 0.8
				if hum.FloorMaterial ~= Enum.Material.Air then
					yVel = math.max(yVel, 13)
				end
				yVel = math.clamp(yVel, -70, 110)

				local spd = cleanFollowSpeed()
				local desiredVel = Vector3.new(flatDir.X * spd, yVel, flatDir.Z * spd)
				root.AssemblyLinearVelocity = root.AssemblyLinearVelocity:Lerp(desiredVel, 0.8)

				local speed3 = targetVel.Magnitude
				local predictTime = math.clamp(speed3 / 150, 0.05, 0.2)
				local predictedPos = targetPos + targetVel * predictTime
				local toPredict = predictedPos - myPos
				if toPredict.Magnitude > 0.1 then
					local goalCF = CFrame.lookAt(myPos, predictedPos)
					local diffCF = root.CFrame:Inverse() * goalCF
					local rx, ry, rz = diffCF:ToEulerAnglesXYZ()
					rx = math.clamp(rx, -2.5, 2.5)
					ry = math.clamp(ry, -2.5, 2.5)
					rz = math.clamp(rz, -2.5, 2.5)
					root.AssemblyAngularVelocity = root.CFrame:VectorToWorldSpace(Vector3.new(rx * 42, ry * 42, rz * 42))
				end

				local distToTarget = (root.Position - target.Position).Magnitude
				if distToTarget <= 8 then
					cleanTrySwing()
				end
			end)

			if type(_G.__CrystalTrackConn) == "function" then
				pcall(function() _G.__CrystalTrackConn(Conns.aimbot) end)
			end
		end

		local function stopBatAimbotV1()
			resetTracking()
			if Conns.aimbot then Conns.aimbot:Disconnect(); Conns.aimbot = nil end
			if Conns.aimbotNew then Conns.aimbotNew:Disconnect(); Conns.aimbotNew = nil end
			local S = _G.__CrystalNormalAimbot
			if S then
				S.target = nil
				S.swingCooldown = false
			end
			local c = Player.Character
			if not c then return end
			local r = c:FindFirstChild("HumanoidRootPart")
			local h2 = c:FindFirstChildOfClass("Humanoid")
			if h2 then
				if S and S.prevAutoRotate ~= nil then
					h2.AutoRotate = S.prevAutoRotate
				else
					h2.AutoRotate = true
				end
				h2.PlatformStand = false
				pcall(function() h2:ChangeState(Enum.HumanoidStateType.Running) end)
				pcall(function() h2:Move(Vector3.zero, false) end)
			end
			if r then
				if type(clearAimbotMoverOn) == "function" then
					pcall(clearAimbotMoverOn, r)
				end
				r.AssemblyLinearVelocity = Vector3.new(0, -0.1, 0)
				r.AssemblyAngularVelocity = Vector3.zero
			end
			if S then S.prevAutoRotate = nil end
		end

		-- Mirror TP Down (from Vanta): when a nearby enemy drops hard, TP you down too
		local MIRROR_TP_DROP_THRESHOLD = 3
		local MIRROR_TP_DOWN_Y = -7.00
		local mirrorTPPreviousY = {}
		local mirrorTPLastTeleport = 0

		local function mirrorTPTeleportDown()
			local character = Player.Character
			local root = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if not root or not humanoid or humanoid.Health <= 0 then return end
			local now = tick()
			if now - mirrorTPLastTeleport < 0.08 then return end
			mirrorTPLastTeleport = now
			local _, yaw = root.CFrame:ToEulerAnglesYXZ()
			root.CFrame = CFrame.new(root.Position.X, MIRROR_TP_DOWN_Y, root.Position.Z) * CFrame.Angles(0, yaw, 0)
			pcall(function() root.AssemblyLinearVelocity = Vector3.zero end)
			pcall(function() root.Velocity = Vector3.zero end)
		end

		local mirrorTPNextCheck = 0
		_G.__CrystalTrackConn(RunService.Heartbeat:Connect(function()
			local now = tick()
			if now < mirrorTPNextCheck then return end
			mirrorTPNextCheck = now + 0.10
			if toggleStates["Mirror TP Down"] ~= true then
				table.clear(mirrorTPPreviousY)
				return
			end
			-- Active while aimbot is on (same behavior as Vanta)
			if not aimbotOn() then
				table.clear(mirrorTPPreviousY)
				return
			end
			local character = Player.Character
			local localRoot = character and character:FindFirstChild("HumanoidRootPart")
			if not localRoot then return end
			for _, player in ipairs(Players:GetPlayers()) do
				if player ~= Player and player.Character then
					local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
					local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
					if targetRoot and humanoid and humanoid.Health > 0 then
						local dx = targetRoot.Position.X - localRoot.Position.X
						local dz = targetRoot.Position.Z - localRoot.Position.Z
						if (dx * dx + dz * dz) <= 64 then
							local currentY = targetRoot.Position.Y
							local previousY = mirrorTPPreviousY[player.UserId]
							if previousY and previousY - currentY >= MIRROR_TP_DROP_THRESHOLD then
								pcall(mirrorTPTeleportDown)
								table.clear(mirrorTPPreviousY)
							end
							mirrorTPPreviousY[player.UserId] = currentY
						else
							mirrorTPPreviousY[player.UserId] = nil
						end
					end
				end
			end
		end))


		local function stopBatAimbot()
			pcall(stopBatAimbotV1)
			if type(_G.__CleanBatBypassStop) == "function" then pcall(_G.__CleanBatBypassStop) end
			if type(_G.__RivalHubAimbotStop) == "function" then pcall(_G.__RivalHubAimbotStop) end
			if type(_G.__RivalBatV2Stop) == "function" then pcall(_G.__RivalBatV2Stop) end
			if type(_G.__ZurichV4NormalStop) == "function" then pcall(_G.__ZurichV4NormalStop) end
			if type(_G.__ZurichV4BypassStop) == "function" then pcall(_G.__ZurichV4BypassStop) end
			for k, conn in pairs(Conns) do
				if typeof(conn) == "RBXScriptConnection" then
					pcall(function() conn:Disconnect() end)
					Conns[k] = nil
				end
			end
			_G.__CrystalActiveAimbotEngine = nil
		end

		local function startBatAimbot()
			stopBatAimbot()
			local engine = tonumber(_G.__aimbotEngineVersion) or 1
			_G.__aimbotEngineVersion = (engine == 2) and 2 or 1
			_G.__aimbotVersion = _G.__aimbotEngineVersion
			if _G.__aimbotEngineVersion == 2 then
				_G.__CrystalActiveAimbotEngine = "Bypass"
				if type(_G.__CleanBatBypassStart) == "function" then
					local ok, err = pcall(_G.__CleanBatBypassStart, Player.Character)
					if not ok then warn("[Vylo] Bypass aimbot start failed:", err) end
					return
				end
				-- fallbacks
				if type(_G.__RivalBatV2Start) == "function" then
					local ok, err = pcall(_G.__RivalBatV2Start, Player.Character)
					if not ok then warn("[Vylo] Bypass fallback start failed:", err) end
					return
				end
			else
				_G.__CrystalActiveAimbotEngine = "Normal"
				local ok, err = pcall(startBatAimbotV1)
				if not ok then warn("[Vylo] Normal aimbot start failed:", err) end
				return
			end
		end

		_G.__CrystalSetAimbotEngineVersion = function(version)
			local nextVersion = tonumber(version) == 2 and 2 or 1
			local wasOn = toggleStates["Aimbot"] == true
			stopBatAimbot()
			_G.__aimbotEngineVersion = nextVersion
			_G.__aimbotVersion = nextVersion
			if type(_G.__CrystalRefreshAimbotEngineUI) == "function" then
				pcall(_G.__CrystalRefreshAimbotEngineUI, nextVersion)
			end
			if wasOn then
				startBatAimbot()
			end
			if saveConfig then pcall(saveConfig) end
			return nextVersion
		end
		_G.__CrystalGetAimbotEngineVersion = function()
			return (_G.__aimbotEngineVersion == 2) and 2 or 1
		end

		-- Mode switcher: Bypass (2) = Clean Bat Bypass, Normal (1) = Clean Hub normal adapt.
		_G.__CrystalSetAimbotMode = function(mode)
			-- Kept for compatibility; mode is no longer user-selectable.
			_G.__aimbotMode = "bypass"
			return "bypass"
		end
		_G.__CrystalGetAimbotMode = function()
			return "bypass"
		end
		-- Legacy V1/V2 bridge maps to engine version only
		_G.__CrystalSetAimbotVersion = function(version)
			return _G.__CrystalSetAimbotEngineVersion(version)
		end
		_G.__CrystalGetAimbotVersion = function()
			return (_G.__aimbotEngineVersion == 2) and 2 or 1
		end

		_cypherStartFollowing = startBatAimbot
		_cypherStop = stopBatAimbot
		FeaturePostToggle["Aimbot"] = function(active)
			if active then
				if _G.__stopSpeedBoost then _G.__stopSpeedBoost() end
				-- Do NOT stop Auto Left/Right side path when aimbot turns on
				if autoplayActive or toggleStates["Autoplay"] then
					if _G.__stopAutoplay then pcall(_G.__stopAutoplay) end
				end
				deactivateOtherAimbots("Aimbot")
				if _G.__deactivateBatExclusive then _G.__deactivateBatExclusive("Aimbot") end
				startBatAimbot()
			else
				stopBatAimbot()
				if _G.__refreshSpeedBoost then _G.__refreshSpeedBoost() end
			end
		end
		FeatureToggles["Aimbot"] = function()
			local on = not (toggleStates["Aimbot"] == true)
			toggleStates["Aimbot"] = on
			FeaturePostToggle["Aimbot"](on)
			if toggleVisualUpdaters["Aimbot"] then pcall(toggleVisualUpdaters["Aimbot"]) end
			saveConfig()
		end
		FeaturePostToggle["Mirror TP Down"] = function() end
		_G.__CrystalTrackStopper(stopBatAimbot)
		_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function()
			task.wait(0.5)
			if toggleStates["Aimbot"] then startBatAimbot() end
		end))
		-- Take ownership after full registration
		task.defer(function()
			if toggleStates["Aimbot"] == true then
				startBatAimbot()
			end
		end)
	end



	do
	local espEnabled = false
	local espActivePlayers = {}
	local espLoopConn = nil
	local Camera = workspace.CurrentCamera
	local GUI2_ESP_COLOR = Color3.fromRGB(139, 72, 246)
	local GUI2_ESP_TEXT_STROKE = Color3.fromRGB(48, 16, 92)
	local function getESPThemeColors(accent)
	if _G.__CrystalGuiTheme == "GUI 3" then
	return Color3.fromRGB(255, 45, 45), Color3.fromRGB(255, 45, 45)
	end
	if _G.__CrystalGuiTheme == "GUI 2" then
	return GUI2_ESP_COLOR, GUI2_ESP_COLOR
	end
	return accent or _G.__CrystalThemeAccent or Color3.fromRGB(245, 245, 250), Color3.fromRGB(0, 0, 0)
	end

	local function createESP()
	local currentFill, currentLine = getESPThemeColors()
	local esp = {
	Tracer = Drawing.new("Line"),
	Highlight = Instance.new("Highlight"),
	Lines = {}
	}

	esp.Tracer.Color = currentLine
	esp.Tracer.Thickness = 3
	esp.Tracer.Transparency = 1
	esp.Tracer.ZIndex = 2

	esp.Highlight.Name = "ESP_Highlight"
	esp.Highlight.FillColor = currentFill
	esp.Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
	esp.Highlight.FillTransparency = 0.12
	esp.Highlight.OutlineTransparency = 0.18
	esp.Highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

	local parentGui
	local ok, robGui = pcall(function() return game:GetService("CoreGui"):FindFirstChild("RobloxGui") end)
	if ok and robGui then
	parentGui = robGui
	else
	parentGui = Player:FindFirstChildOfClass("PlayerGui")
	end
	if not parentGui then
	parentGui = game:GetService("CoreGui")
	end

	pcall(function() esp.Highlight.Parent = parentGui end)

	local nameBillboard = Instance.new("BillboardGui")
	nameBillboard.Name = "ESP_Name"
	nameBillboard.Size = UDim2.new(0, 170, 0, 28)
	nameBillboard.StudsOffset = Vector3.new(0, 1.3, 0)
	nameBillboard.AlwaysOnTop = true
	nameBillboard.Parent = parentGui

	local nameLabel = Instance.new("TextLabel")
	nameLabel.Size = UDim2.new(0, 170, 0, 28)
	nameLabel.AnchorPoint = Vector2.new(0.5, 0)
	nameLabel.Position = UDim2.new(0.5, 0, 0, 2)
	nameLabel.BackgroundTransparency = 1
	nameLabel.Text = tostring(currentPresetName or "")
	nameLabel.TextColor3 = _G.__CrystalGuiTheme == "GUI 3" and Color3.fromRGB(255, 45, 45) or (_G.__CrystalGuiTheme == "GUI 2" and GUI2_ESP_COLOR or Color3.fromRGB(245, 245, 255))
	nameLabel.TextSize = 15
	nameLabel.Font = Enum.Font.GothamBold
	nameLabel.TextStrokeColor3 = _G.__CrystalGuiTheme == "GUI 2" and GUI2_ESP_TEXT_STROKE or Color3.fromRGB(0, 0, 0)
	nameLabel.TextStrokeTransparency = 0
	nameLabel.TextXAlignment = Enum.TextXAlignment.Center
	nameLabel.TextYAlignment = Enum.TextYAlignment.Center
	nameLabel.ZIndex = 5
	nameLabel.Parent = nameBillboard

	local nameOutline = Instance.new("UIStroke")
	nameOutline.Color = _G.__CrystalGuiTheme == "GUI 2" and GUI2_ESP_TEXT_STROKE or Color3.fromRGB(0, 0, 0)
	nameOutline.Thickness = 2.2
	nameOutline.Transparency = 0.12
	nameOutline.Parent = nameLabel
	for i = 1, 14 do
	local line = Drawing.new("Line")
	line.Color = currentLine
	line.Thickness = 2
	line.Transparency = 1
	line.ZIndex = 3
	table.insert(esp.Lines, line)
	end

	esp.NameTag = nameBillboard
	esp.NameLabel = nameLabel
	esp.NameOutline = nameOutline
	return esp
	end

	_G.__CrystalRefreshESPTheme = function(accent, outlineColor)
	local fillColor, lineColor = getESPThemeColors(accent)
	for _, data in pairs(espActivePlayers) do
	if type(data) == "table" and data.esp then
	local esp = data.esp
	if esp.Tracer then pcall(function() esp.Tracer.Color = lineColor end) end
	if esp.Highlight then
	esp.Highlight.FillColor = fillColor
	esp.Highlight.OutlineColor = Color3.fromRGB(0, 0, 0)
	end
	if esp.NameLabel then
	esp.NameLabel.TextColor3 = _G.__CrystalGuiTheme == "GUI 3" and Color3.fromRGB(255, 45, 45) or (_G.__CrystalGuiTheme == "GUI 2" and GUI2_ESP_COLOR or Color3.fromRGB(245, 245, 255))
	esp.NameLabel.TextStrokeColor3 = _G.__CrystalGuiTheme == "GUI 2" and GUI2_ESP_TEXT_STROKE or Color3.fromRGB(0, 0, 0)
	end
	if esp.NameOutline then
	esp.NameOutline.Color = _G.__CrystalGuiTheme == "GUI 2" and GUI2_ESP_TEXT_STROKE or Color3.fromRGB(0, 0, 0)
	end
	for _, line in ipairs(esp.Lines or {}) do pcall(function() line.Color = lineColor end) end
	end
	end
	end

	local function removeESP(plr)
	local data = espActivePlayers[plr]
	if data then
	if data.esp.Tracer then pcall(function() data.esp.Tracer:Remove() end) end
	if data.esp.Highlight then pcall(function() data.esp.Highlight:Destroy() end) end
	if data.esp.NameTag then pcall(function() data.esp.NameTag:Destroy() end) end
	for _, line in ipairs(data.esp.Lines) do
	pcall(function() line:Remove() end)
	end
	if data.loopConn then pcall(function() data.loopConn:Disconnect() end) end
	espActivePlayers[plr] = nil
	end
	end

	local function updateESP(plr, esp)
	if not espEnabled then
	esp.Tracer.Visible = false
	esp.Highlight.Enabled = false
	for _, line in ipairs(esp.Lines) do line.Visible = false end
	return
	end

	local character = plr.Character
	local hum = character and character:FindFirstChildOfClass("Humanoid")
	local trackPart = character and (
	character:FindFirstChild("HumanoidRootPart")
	or character.PrimaryPart
	or character:FindFirstChild("UpperTorso")
	or character:FindFirstChild("Torso")
	or character:FindFirstChild("Head")
	)

	if character and trackPart and (not hum or hum.Health > 0) then
	esp.Highlight.Adornee = character
	esp.Highlight.Enabled = toggleStates["ESP Players"] or false

	local _, onScreen = Camera:WorldToViewportPoint(trackPart.Position)

	if onScreen then
	esp.Tracer.Visible = false
	else
	for _, line in ipairs(esp.Lines) do line.Visible = false end
	end

	if esp.NameTag and esp.NameLabel then
	pcall(function()
	esp.NameTag.Adornee = trackPart
	esp.NameTag.Enabled = toggleStates["ESP Players"] or false
	esp.NameLabel.Text = plr.Name or plr.DisplayName or ""
	local gui2Active = _G.__CrystalGuiTheme == "GUI 2"
	esp.NameLabel.TextColor3 = _G.__CrystalGuiTheme == "GUI 3" and Color3.fromRGB(255, 45, 45) or (gui2Active and GUI2_ESP_COLOR or Color3.fromRGB(245, 245, 255))
	esp.NameLabel.TextStrokeColor3 = gui2Active and GUI2_ESP_TEXT_STROKE or Color3.fromRGB(0, 0, 0)
	if esp.NameOutline then
	esp.NameOutline.Color = gui2Active and GUI2_ESP_TEXT_STROKE or Color3.fromRGB(0, 0, 0)
	end
	end)
	end
	else
	esp.Tracer.Visible = false
	esp.Highlight.Enabled = false
	esp.Highlight.Adornee = nil
	for _, line in ipairs(esp.Lines) do line.Visible = false end
	if esp.NameTag and esp.NameLabel then
	pcall(function()
	esp.NameTag.Enabled = false
	end)
	end
	end
	end

	local function createESPForPlayer(plr)
	if plr == Player then return end
	if espActivePlayers[plr] and espActivePlayers[plr].esp then
	if espActivePlayers[plr].esp.NameTag then
	pcall(function() espActivePlayers[plr].esp.NameTag.Enabled = toggleStates["ESP Players"] or false end)
	end
	return
	end
	removeESP(plr)
	local esp = createESP()
	espActivePlayers[plr] = {esp = esp}
	end

	local function enableESP()
	if espEnabled then return end; espEnabled = true
	for _, plr in pairs(Players:GetPlayers()) do
	if plr ~= Player then task.spawn(function() createESPForPlayer(plr) end) end
	end
	local espAccumulator = 0
	if espLoopConn then espLoopConn:Disconnect() end
	espLoopConn = RunService.Heartbeat:Connect((function(dt)
	espAccumulator = espAccumulator + (dt or 0)
	if espAccumulator < 0.50 then return end
	espAccumulator = 0
	for plr, data in pairs(espActivePlayers) do
	if typeof(plr) == "Instance" and plr:IsA("Player") and data and data.esp then
	pcall(function() updateESP(plr, data.esp) end)
	end
	end
	end))
	local joinConn = Players.PlayerAdded:Connect(function(plr)
	if not espEnabled or plr == Player then return end
	task.wait(0.3)
	createESPForPlayer(plr)
	end)
	local leaveConn = Players.PlayerRemoving:Connect(function(plr) removeESP(plr) end)
	espActivePlayers._joinConn = joinConn
	espActivePlayers._leaveConn = leaveConn
	end

local function disableESP()
	espEnabled = false
	if espLoopConn then espLoopConn:Disconnect(); espLoopConn = nil end
	if espActivePlayers._joinConn then pcall(function() espActivePlayers._joinConn:Disconnect() end); espActivePlayers._joinConn = nil end
	if espActivePlayers._leaveConn then pcall(function() espActivePlayers._leaveConn:Disconnect() end); espActivePlayers._leaveConn = nil end
	for plr in pairs(espActivePlayers) do
	if typeof(plr) == "Instance" and plr:IsA("Player") and plr ~= Player then removeESP(plr) end
end
end
_G.__CrystalTrackStopper(disableESP)
FeaturePostToggle["ESP Players"] = function(active)
if active then enableESP() else disableESP() end
end

if toggleStates["ESP Players"] then enableESP() end

	local oldTracer = _G.__CrystalPlayerTracerLine
	if oldTracer then pcall(function() oldTracer:Remove() end) end
	local tracerGui = Instance.new("ScreenGui")
	tracerGui.Name = "CrystalPlayerTracerOverlay"
	tracerGui.IgnoreGuiInset = true
	tracerGui.ResetOnSpawn = false
	tracerGui.DisplayOrder = 1000
	tracerGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	tracerGui.Parent = Player:WaitForChild("PlayerGui")
	local playerTracer = Instance.new("Frame")
	playerTracer.Name = "ESPLine"
	playerTracer.AnchorPoint = Vector2.new(0.5, 0.5)
	playerTracer.BorderSizePixel = 0
	playerTracer.Active = false
	playerTracer.Visible = false
	playerTracer.ZIndex = 1
	playerTracer.Parent = tracerGui
	local tracerOutline = Instance.new("UIStroke", playerTracer)
	tracerOutline.Color = Color3.fromRGB(255, 255, 255)
	tracerOutline.Thickness = 0.7
	tracerOutline.Transparency = 0.45
	_G.__CrystalPlayerTracerLine = {Remove = function() tracerGui:Destroy() end}
	_G.__CrystalTrackStopper(function() tracerGui:Destroy() end)
	local playerTracerState = { scanElapsed = math.huge, targetRoot = nil }

	_G.__CrystalTrackConn(RunService.RenderStepped:Connect((function(dt)
	if not toggleStates["Player Tracers"] then
	if playerTracer.Visible then playerTracer.Visible = false end
	playerTracerState.targetRoot = nil
	playerTracerState.scanElapsed = math.huge
	return
	end
	local ok = pcall(function()

	local activeCamera = workspace.CurrentCamera
	local myCharacter = Player.Character
	local myRoot = myCharacter and (myCharacter:FindFirstChild("LowerTorso") or myCharacter:FindFirstChild("HumanoidRootPart") or myCharacter:FindFirstChild("Torso"))
	if not activeCamera or not myRoot then
	playerTracer.Visible = false
	return
	end

	local myPosition = myRoot.Position
	playerTracerState.scanElapsed = playerTracerState.scanElapsed + (dt or 0)
	local cachedRoot = playerTracerState.targetRoot
	local cachedCharacter = cachedRoot and cachedRoot.Parent
	local cachedHumanoid = cachedCharacter and cachedCharacter:FindFirstChildOfClass("Humanoid")
	local cachedValid = cachedRoot and cachedRoot.Parent and (not cachedHumanoid or cachedHumanoid.Health > 0)

	if playerTracerState.scanElapsed >= 0.12 or not cachedValid then
	playerTracerState.scanElapsed = 0
	local closestRoot, closestDistanceSq = nil, math.huge
	for _, otherPlayer in ipairs(Players:GetPlayers()) do
	if otherPlayer ~= Player then
	local character = otherPlayer.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = character and (character:FindFirstChild("HumanoidRootPart") or character:FindFirstChild("LowerTorso") or character:FindFirstChild("Torso"))
	if root and root:IsA("BasePart") and (not humanoid or humanoid.Health > 0) then
	local delta = root.Position - myPosition
	local distanceSq = delta:Dot(delta)
	if distanceSq < closestDistanceSq then
	closestRoot, closestDistanceSq = root, distanceSq
	end
	end
	end
	end
	playerTracerState.targetRoot = closestRoot
	end

	local closestRoot = playerTracerState.targetRoot
	if not closestRoot or not closestRoot.Parent then
	playerTracer.Visible = false
	return
	end
	local closestPosition = closestRoot.Position

	local from = activeCamera:WorldToViewportPoint(myPosition - Vector3.new(0, myRoot.Size.Y * 0.35, 0))
	local to, targetOnScreen = activeCamera:WorldToViewportPoint(closestPosition)
	local viewport = activeCamera.ViewportSize
	local fromPoint = Vector2.new(from.X, from.Y)
	local targetPoint = Vector2.new(to.X, to.Y)

	if not targetOnScreen or to.Z <= 0 then
	local center = viewport * 0.5
	local direction = targetPoint - center
	if to.Z <= 0 then direction = -direction end
	if direction.Magnitude < 0.001 then direction = Vector2.new(0, -1) end
	local limit = Vector2.new(math.max(8, center.X - 8), math.max(8, center.Y - 8))
	local scaleX = limit.X / math.max(math.abs(direction.X), 0.001)
	local scaleY = limit.Y / math.max(math.abs(direction.Y), 0.001)
	targetPoint = center + direction * math.min(scaleX, scaleY)
	end

	if from.Z <= 0 or fromPoint.X < 0 or fromPoint.X > viewport.X or fromPoint.Y < 0 or fromPoint.Y > viewport.Y then
	fromPoint = Vector2.new(viewport.X * 0.5, viewport.Y - 8)
	end

	local delta = targetPoint - fromPoint
	local midpoint = (fromPoint + targetPoint) * 0.5
	playerTracer.Position = UDim2.fromOffset(midpoint.X, midpoint.Y)
	playerTracer.Size = UDim2.fromOffset(math.max(delta.Magnitude, 1), 2)
	playerTracer.Rotation = math.deg(math.atan2(delta.Y, delta.X))
	local _, tracerColor = getESPThemeColors()
	playerTracer.BackgroundColor3 = tracerColor
	playerTracer.Visible = true
	end)
	if not ok then pcall(function() playerTracer.Visible = false end) end
	end)))
	end

	local function makeToggleWithInput(parent, text, featureName, speedKey, fmtFn, parseFn)
	local container = Instance.new("Frame")
	container.Name = tostring(featureName or text or "Input") .. "Stub"
	container.BackgroundTransparency = 1
	container.Visible = false
	container.Parent = parent
	return {
	container = container,
	input = nil,
	activeRef = function() return toggleStates[featureName] == true end,
	}
	end

	local tabPages = {}
	local tabNames = {"Movement", "Combat", "Visuals", "Animations"}

	local function createTabPage(name)
	local page = Instance.new("ScrollingFrame", ContentArea)
	page.Name = name .. "PageStub"
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 0
	page.Visible = false
	tabPages[name] = page
	end
	for _, name in ipairs(tabNames) do createTabPage(name) end

	local function selectSectionTab(selected)
	local selectedPage = tabPages[selected]
	if not selectedPage then return end
	for name, page in pairs(tabPages) do
	page.Visible = (name == selected)
	end
	end

	selectSectionTab("Movement")

	_speedCardRefs = _speedCardRefs or {}
	local function makeUraniumSpeedCard(parent, cardTitle, modeName, boostKey, stealKey, featureName)
	local container = Instance.new("Frame")
	container.Name = tostring(modeName or cardTitle or "Speed") .. "SpeedStub"
	container.BackgroundTransparency = 1
	container.Visible = false
	container.Parent = parent
	if featureName then FeatureToggles[featureName] = function() selectMode(modeName) end end
	return container
	end

	local speedSection = makeUraniumSection(tabPages.Movement, "SPEED")
	makeUraniumSpeedCard(speedSection, "Normal Speed", "Normal", "NormalBoost", "NormalSteal", "SelectNormalMode")
	makeUraniumSpeedCard(speedSection, "Lagger Speed", "Lagger", "LaggerBoost", "LaggerSteal", "SelectLaggerMode")

	local function createCustomSpeedCard(cs)
	local featureName = "SelectCustomMode_" .. cs.name
	local boostKey = "CustomBoost_" .. cs.name
	local stealKey = "CustomSteal_" .. cs.name
	speedValues[boostKey] = cs.boost
	speedValues[stealKey] = cs.steal
	FeatureToggles[featureName] = function() selectMode(cs.name) end
	local card = makeUraniumSpeedCard(speedSection, cs.name, cs.name, boostKey, stealKey, featureName)
	local delBtn = Instance.new("TextButton", card)
	delBtn.Size = UDim2.new(0, 18, 0, 18)
	delBtn.AnchorPoint = Vector2.new(1, 1)
	delBtn.Position = UDim2.new(1, -8, 1, -8)
	delBtn.ZIndex = 30
	delBtn.BackgroundColor3 = Color3.fromRGB(240, 200, 200)
	delBtn.BorderSizePixel = 0
	delBtn.Text = "x"
	delBtn.TextColor3 = Color3.fromRGB(180, 60, 60)
	delBtn.TextSize = 11
	delBtn.Font = Enum.Font.GothamBold
	delBtn.AutoButtonColor = false
	delBtn.TextXAlignment = Enum.TextXAlignment.Center
	delBtn.TextYAlignment = Enum.TextYAlignment.Center
	Instance.new("UICorner", delBtn).CornerRadius = UDim.new(0, 4)
	connectBtn(delBtn, function()
	for i = #customSpeeds, 1, -1 do
	if customSpeeds[i].name == cs.name then table.remove(customSpeeds, i) break end
	end
	if selectedMode == cs.name then selectMode("Normal") end
	pcall(function() card:Destroy() end)
	saveConfig()
	end)
	return card
	end

	for _, cs in ipairs(customSpeeds) do
	pcall(function() createCustomSpeedCard(cs) end)
	end

	do
	local addBtn = Instance.new("TextButton", speedSection)
	addBtn.Size = UDim2.new(1, -2, 0, 28)
	addBtn.BackgroundColor3 = Color3.fromRGB(235, 240, 245)
	addBtn.BackgroundTransparency = 0.55
	addBtn.BorderSizePixel = 0
	addBtn.Text = "+ Add Custom Speed"
	addBtn.TextColor3 = Color3.fromRGB(100, 140, 200)
	addBtn.TextSize = 11
	addBtn.Font = Enum.Font.GothamBold
	addBtn.AutoButtonColor = false
	Instance.new("UICorner", addBtn).CornerRadius = UDim.new(0, 6)
	local addStroke = Instance.new("UIStroke", addBtn)
	addStroke.Color = Color3.fromRGB(0, 0, 0)
	addStroke.Thickness = 1
	addStroke.Transparency = 0.3

	local formCard = nil
	connectBtn(addBtn, function()
	if formCard then pcall(function() formCard:Destroy() end) formCard = nil return end
	formCard = Instance.new("Frame", speedSection)
	formCard.Size = UDim2.new(1, -2, 0, 96)
	formCard.BackgroundColor3 = Color3.fromRGB(230, 238, 245)
	formCard.BorderSizePixel = 0
	Instance.new("UICorner", formCard).CornerRadius = UDim.new(0, 6)
	local formStroke = Instance.new("UIStroke", formCard)
	formStroke.Color = Color3.fromRGB(0, 0, 0)
	formStroke.Thickness = 1

	local nameLbl = Instance.new("TextLabel", formCard)
	nameLbl.Size = UDim2.new(0, 40, 0, 14)
	nameLbl.Position = UDim2.new(0, 8, 0, 6)
	nameLbl.BackgroundTransparency = 1
	nameLbl.Text = "Name"
	nameLbl.TextColor3 = Color3.fromRGB(100, 140, 190)
	nameLbl.TextSize = 9
	nameLbl.Font = Enum.Font.GothamBold
	nameLbl.TextXAlignment = Enum.TextXAlignment.Left
	local nameBox = Instance.new("TextBox", formCard)
	nameBox.Size = UDim2.new(0, 120, 0, 20)
	nameBox.Position = UDim2.new(0, 8, 0, 21)
	nameBox.BackgroundColor3 = Color3.fromRGB(245, 247, 250)
	nameBox.BorderSizePixel = 0
	nameBox.Text = ""
	nameBox.PlaceholderText = "My Speed"
	nameBox.Font = Enum.Font.GothamBold
	nameBox.TextSize = 11
	nameBox.TextColor3 = Color3.fromRGB(30, 90, 200)
	nameBox.ClearTextOnFocus = false
	Instance.new("UICorner", nameBox).CornerRadius = UDim.new(0, 4)
	local nameStroke = Instance.new("UIStroke", nameBox)
	nameStroke.Color = Color3.fromRGB(0, 0, 0)
	nameStroke.Thickness = 1

	local boostLbl = Instance.new("TextLabel", formCard)
	boostLbl.Size = UDim2.new(0, 50, 0, 14)
	boostLbl.Position = UDim2.new(0, 140, 0, 6)
	boostLbl.BackgroundTransparency = 1
	boostLbl.Text = "Boost"
	boostLbl.TextColor3 = Color3.fromRGB(100, 140, 190)
	boostLbl.TextSize = 9
	boostLbl.Font = Enum.Font.GothamBold
	boostLbl.TextXAlignment = Enum.TextXAlignment.Left
	local boostBox = Instance.new("TextBox", formCard)
	boostBox.Size = UDim2.new(0, 56, 0, 20)
	boostBox.Position = UDim2.new(0, 140, 0, 21)
	boostBox.BackgroundColor3 = Color3.fromRGB(220, 238, 255)
	boostBox.BorderSizePixel = 0
	boostBox.Text = "59"
	boostBox.Font = Enum.Font.GothamBold
	boostBox.TextSize = 12
	boostBox.TextColor3 = Color3.fromRGB(30, 90, 200)
	boostBox.TextXAlignment = Enum.TextXAlignment.Center
	boostBox.ClearTextOnFocus = false
	Instance.new("UICorner", boostBox).CornerRadius = UDim.new(0, 5)
	local boostStroke2 = Instance.new("UIStroke", boostBox)
	boostStroke2.Color = Color3.fromRGB(0, 0, 0)
	boostStroke2.Thickness = 1

	local stealLbl = Instance.new("TextLabel", formCard)
	stealLbl.Size = UDim2.new(0, 50, 0, 14)
	stealLbl.Position = UDim2.new(0, 204, 0, 6)
	stealLbl.BackgroundTransparency = 1
	stealLbl.Text = "Steal"
	stealLbl.TextColor3 = Color3.fromRGB(100, 140, 190)
	stealLbl.TextSize = 9
	stealLbl.Font = Enum.Font.GothamBold
	stealLbl.TextXAlignment = Enum.TextXAlignment.Left
	local stealBox = Instance.new("TextBox", formCard)
	stealBox.Size = UDim2.new(0, 56, 0, 20)
	stealBox.Position = UDim2.new(0, 204, 0, 21)
	stealBox.BackgroundColor3 = Color3.fromRGB(220, 238, 255)
	stealBox.BorderSizePixel = 0
	stealBox.Text = "29"
	stealBox.Font = Enum.Font.GothamBold
	stealBox.TextSize = 12
	stealBox.TextColor3 = Color3.fromRGB(30, 90, 200)
	stealBox.TextXAlignment = Enum.TextXAlignment.Center
	stealBox.ClearTextOnFocus = false
	Instance.new("UICorner", stealBox).CornerRadius = UDim.new(0, 5)
	local stealStroke2 = Instance.new("UIStroke", stealBox)
	stealStroke2.Color = Color3.fromRGB(0, 0, 0)
	stealStroke2.Thickness = 1

	boostBox.InputChanged:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.TextInput then
	boostBox.Text = boostBox.Text:gsub("[^0-9]", "")
	end
	end)
	stealBox.InputChanged:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.TextInput then
	stealBox.Text = stealBox.Text:gsub("[^0-9]", "")
	end
	end)

	local confirmBtn = Instance.new("TextButton", formCard)
	confirmBtn.Size = UDim2.new(1, -16, 0, 24)
	confirmBtn.Position = UDim2.new(0, 8, 0, 50)
	confirmBtn.BackgroundColor3 = Color3.fromRGB(50, 130, 255)
	confirmBtn.BorderSizePixel = 0
	confirmBtn.Text = "Add Speed"
	confirmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	confirmBtn.TextSize = 11
	confirmBtn.Font = Enum.Font.GothamBold
	confirmBtn.AutoButtonColor = false
	Instance.new("UICorner", confirmBtn).CornerRadius = UDim.new(0, 5)

	local errLbl = Instance.new("TextLabel", formCard)
	errLbl.Size = UDim2.new(1, -16, 0, 14)
	errLbl.Position = UDim2.new(0, 8, 0, 78)
	errLbl.BackgroundTransparency = 1
	errLbl.Text = ""
	errLbl.TextColor3 = Color3.fromRGB(200, 60, 60)
	errLbl.TextSize = 9
	errLbl.Font = Enum.Font.GothamBold
	errLbl.TextXAlignment = Enum.TextXAlignment.Left

	connectBtn(confirmBtn, function()
	local cname = nameBox.Text:match("^%s*(.-)%s*$")
	local cboost = tonumber(boostBox.Text)
	local csteal = tonumber(stealBox.Text)
	if not cname or #cname < 1 then errLbl.Text = "Enter a name" return end
	if not cboost or cboost < 1 or cboost > 200 then errLbl.Text = "Boost: 1-200" return end
	if not csteal or csteal < 1 or csteal > 200 then errLbl.Text = "Steal: 1-200" return end
	for _, cs in ipairs(customSpeeds) do
	if cs.name == cname then errLbl.Text = "Name already exists" return end
	end
	if cname == "Normal" or cname == "Lagger" or cname == "Desync" then errLbl.Text = "Reserved name" return end
	local cs = { name = cname, boost = cboost, steal = csteal }
	table.insert(customSpeeds, cs)
	pcall(function() createCustomSpeedCard(cs) end)
	pcall(function() formCard:Destroy() end)
	formCard = nil
	saveConfig()
	end)
	end)
	end

	for _, ref in ipairs(_speedCardRefs) do if ref.updateVisual then pcall(ref.updateVisual) end end

	local movementSection = makeUraniumSection(tabPages.Movement, "MOVEMENT")
	local autoplayRow = makeToggle(movementSection, "Auto Play", "Autoplay")
		do
	local autoplayCard = nil
	for _, child in ipairs(autoplayRow:GetChildren()) do
	if child:IsA("TextButton") then autoplayCard = child; break end
	end
	if autoplayCard then
	local autoplayModeButton = Instance.new("TextButton", autoplayCard)
	autoplayModeButton.Name = "AutoplayModeButton"
	autoplayModeButton.Size = UDim2.new(0, 56, 0, 20)
	autoplayModeButton.Position = UDim2.new(1, -120, 0.5, -10)
	autoplayModeButton.BackgroundColor3 = Color3.fromRGB(30,30,38)
	autoplayModeButton.BorderSizePixel = 0
	autoplayModeButton.Text = string.upper(_G.__autoplayMode or "Full")
	autoplayModeButton.TextColor3 = Color3.fromRGB(225,238,255)
	autoplayModeButton.TextSize = 10
	autoplayModeButton.Font = Enum.Font.GothamBold
	autoplayModeButton.AutoButtonColor = false
	autoplayModeButton.ZIndex = 10
	Instance.new("UICorner", autoplayModeButton).CornerRadius = UDim.new(0, 4)
	local autoplayModeStroke = Instance.new("UIStroke", autoplayModeButton)
	autoplayModeStroke.Color = Color3.fromRGB(255,255,255)
	autoplayModeStroke.Thickness = 1
	autoplayModeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	attachCleanHubTap(autoplayModeButton, function()
	_G.__autoplayMode = (_G.__autoplayMode == "Semi") and "Full" or "Semi"
	autoplayModeButton.Text = string.upper(_G.__autoplayMode)
	if type(_G.__CrystalRefreshAutoplayModeUI) == "function" then
		pcall(_G.__CrystalRefreshAutoplayModeUI, _G.__autoplayMode)
	end
	saveConfig()
	end)
	end
	end
	makeToggleNoKeybind(movementSection, "Auto Carry Speed", "Auto Carry Speed")
	do
	local carryRow = makeToggle(movementSection, "Carry Speed", "Carry Speed")

	local carryCard = nil
	for _, ch in ipairs(carryRow:GetChildren()) do
	if ch:IsA("TextButton") then carryCard = ch; break end
	end

	pcall(function() styleSmallToggle(carryRow) end)

	if carryCard then
	local vBtn = Instance.new("TextButton", carryCard)
	vBtn.Size = UDim2.new(0, 56, 0, 20)
	vBtn.Position = UDim2.new(1, -120, 0.5, -10)
	vBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	vBtn.BorderSizePixel = 0
	vBtn.Text = "V2"
	vBtn.TextColor3 = Color3.fromRGB(225,238,255)
	vBtn.TextSize = 10
	vBtn.Font = Enum.Font.GothamBold
	vBtn.AutoButtonColor = false
	vBtn.ZIndex = 10
	Instance.new("UICorner", vBtn).CornerRadius = UDim.new(0, 4)
	local vStroke = Instance.new("UIStroke", vBtn)
	vStroke.Color = Color3.fromRGB(255,255,255)
	vStroke.Thickness = 1
	vStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local function getBindPill()
	for _, c in ipairs(carryCard:GetChildren()) do
	if c:IsA("TextButton") and c ~= vBtn and c.Size.X.Offset == 48 and c.Position.X.Scale == 1 and c.Position.X.Offset == -54 then
	return c
	end
	end
	return nil
	end

	local function applyV1Mode()
	carrySpeedMode = "v1"
	vBtn.Text = "V1"
	vBtn.TextColor3 = Color3.fromRGB(225,238,255)
	vBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	vBtn.Position = UDim2.new(1, -120, 0.5, -10)
	local pill = getBindPill()
	if pill then pill.Visible = true end
	end

	local function applyV2Mode()
	carrySpeedMode = "v2"
	vBtn.Text = "V2"
	vBtn.TextColor3 = Color3.fromRGB(225,238,255)
	vBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	vBtn.Position = UDim2.new(1, -120, 0.5, -10)
	local pill = getBindPill()
	if pill then pill.Visible = true end
	end

	applyV2Mode()
	vBtn.Visible = false
	end
	end

	pcall(function()
	if _G and _G.__setNoPlayerCollision then _G.__setNoPlayerCollision(true) end
	end)

	local function styleSmallToggle(row)
	if not row then return end
	pcall(function()
	row.Size = UDim2.new(1, -2, 0, GUI_METRICS.compactCardH)
	for _, c in ipairs(row:GetChildren()) do
	if c:IsA("TextButton") then
	c.Size = UDim2.new(1, 0, 0, GUI_METRICS.compactCardH)
	c.BackgroundColor3 = Color3.fromRGB(25,31,42)
	c.BackgroundTransparency = 0.35
	c.BorderSizePixel = 0
	c.ZIndex = 21
	local corner = c:FindFirstChildOfClass("UICorner")
	if corner then corner.CornerRadius = UDim.new(0,5) else Instance.new("UICorner", c).CornerRadius = UDim.new(0,5) end
	local stroke = c:FindFirstChildOfClass("UIStroke")
	if stroke then stroke.Color = Color3.fromRGB(0,0,0); stroke.Thickness = 1; stroke.Transparency = 0 end
	break
	end
	end
	end)
	end

	pcall(function()
	local m = _featureToggleMap and _featureToggleMap["Autoplay"]
	if m and m.card and m.card.Parent then styleSmallToggle(m.card.Parent) end
	end)
	pcall(function()
	local m = _featureToggleMap and _featureToggleMap["Carry Speed"]
	if m and m.card and m.card.Parent then styleSmallToggle(m.card.Parent) end
	end)
	pcall(function()
	local m = _featureToggleMap and _featureToggleMap["TP Bat"]
	if m and m.card and m.card.Parent then styleSmallToggle(m.card.Parent) end
	end)

	_G.__CrystalInfJumpMode = _G.__CrystalInfJumpMode or "hold"
	makeToggleNoKeybind(movementSection, "Unwalk", "Unwalk")
	local infJumpToggleRow = makeToggleNoKeybind(movementSection, "Inf Jump", "Inf Jump")
	if infJumpToggleRow then
	local infJumpModeBtn = Instance.new("TextButton", infJumpToggleRow)
	infJumpModeBtn.Name = "InfJumpModeBtn"
	infJumpModeBtn.Size = UDim2.new(0, 66, 0, 20)
	infJumpModeBtn.Position = UDim2.new(1, -74, 0.5, -10)
	infJumpModeBtn.AnchorPoint = Vector2.new(0, 0)
	infJumpModeBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	infJumpModeBtn.BorderSizePixel = 0
	infJumpModeBtn.Text = (_G.__CrystalInfJumpMode == "hold") and "HOLD" or "MANUAL"
	infJumpModeBtn.TextColor3 = Color3.fromRGB(225,238,255)
	infJumpModeBtn.Font = Enum.Font.GothamBold
	infJumpModeBtn.TextSize = 10
	infJumpModeBtn.AutoButtonColor = false
	infJumpModeBtn.ZIndex = 30
	Instance.new("UICorner", infJumpModeBtn).CornerRadius = UDim.new(0, 4)
	local infJumpModeStroke = Instance.new("UIStroke", infJumpModeBtn)
	infJumpModeStroke.Color = Color3.fromRGB(255,255,255)
	infJumpModeStroke.Thickness = 1
	infJumpModeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local function updateInfJumpModeButton()
	local isHold = (_G.__CrystalInfJumpMode == "hold")
	infJumpModeBtn.Text = isHold and "HOLD" or "MANUAL"
	infJumpModeBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	infJumpModeBtn.TextColor3 = Color3.fromRGB(225,238,255)
	infJumpModeStroke.Color = Color3.fromRGB(255,255,255)
	infJumpModeStroke.Thickness = 1
	infJumpModeBtn.TextStrokeTransparency = 1
	end
	updateInfJumpModeButton()
	connectBtn(infJumpModeBtn, function()
	_G.__CrystalInfJumpMode = (_G.__CrystalInfJumpMode == "hold") and "manual" or "hold"
	updateInfJumpModeButton()
	if toggleStates["Inf Jump"] then
	if _G.__CrystalInfJumpMode == "hold" then
	startInfJump()
	else
	stopInfJump()
	end
	end
	end)
	end
	local tpDownRow = makeToggle(movementSection, "TP Down", "TP Down")
	pcall(function() styleSmallToggle(tpDownRow) end)
	makeToggleWithInput(movementSection, "Auto TP Down", "Auto TP Down", "AutoTPDownHeight",
	function(value) return tostring(math.floor((tonumber(value) or 20) + 0.5)) end,
	function(value) return math.clamp(math.floor((tonumber(value) or 20) + 0.5), 1, 1000) end)

	local combatSection = makeUraniumSection(tabPages.Combat, "COMBAT")
	makeToggleNoKeybind(combatSection, "Anti Ragdoll", "Anti Ragdoll")
	makeToggleNoKeybind(combatSection, "Ragdoll Counter", "Ragdoll Counter")
	makeToggleNoKeybind(combatSection, "Medusa Counter", "Medusa Counter")

	_G.__CrystalAntiDieGuiEnabled = function()
	return toggleStates["Anti Die"] == true
	end
	FeaturePostToggle["Anti Die"] = function(active)
	pcall(function() if _G.__CrystalAntiDieSource then _G.__CrystalAntiDieSource("toggle", active) end end)
	end
	makeToggleNoKeybind(combatSection, "Anti Die", "Anti Die")
	FeaturePostToggle["Anti Die"](toggleStates["Anti Die"] == true)

	-- Body Lock (ported from Violette): turns your character to face the nearest player in range.
	do
	if type(_G.__VyloBodyLockStop) == "function" then pcall(_G.__VyloBodyLockStop) end

	local TURN_SPEED = 30
	local lockConn = nil

	local function getLocalRig()
		local char = Player.Character
		if not char or not char.Parent then return nil, nil end
		return char:FindFirstChild("HumanoidRootPart"), char:FindFirstChildOfClass("Humanoid")
	end

	-- Nearest other player inside the configured range.
	local function getNearestTarget(root)
		local range = tonumber(speedValues.BodyLockRange) or 15
		local best, bestDist = nil, range
		for _, other in ipairs(Players:GetPlayers()) do
			if other ~= Player and other.Character then
				local hum = other.Character:FindFirstChildOfClass("Humanoid")
				local tRoot = other.Character:FindFirstChild("HumanoidRootPart")
				if hum and tRoot and hum.Health > 0 then
					local dist = (root.Position - tRoot.Position).Magnitude
					if dist <= bestDist then best, bestDist = tRoot, dist end
				end
			end
		end
		return best
	end

	local function releaseRotation()
		local root, hum = getLocalRig()
		if root then root.AssemblyAngularVelocity = Vector3.zero end
		if hum then hum.AutoRotate = true end
	end

	local function stopBodyLock()
		if lockConn then lockConn:Disconnect(); lockConn = nil end
		releaseRotation()
	end

	local function startBodyLock()
		if lockConn then lockConn:Disconnect(); lockConn = nil end
		lockConn = RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function()
			if toggleStates["Body Lock"] ~= true then return end
			local root, hum = getLocalRig()
			if not root or not hum or hum.Health <= 0 then return end

			local target = getNearestTarget(root)
			if not target then
				root.AssemblyAngularVelocity = Vector3.zero
				hum.AutoRotate = true
				return
			end

			hum.AutoRotate = false
			local look = root.CFrame.LookVector
			local current = Vector3.new(look.X, 0, look.Z)
			local offset = target.Position - root.Position
			local wanted = Vector3.new(offset.X, 0, offset.Z)
			if current.Magnitude <= 0.001 or wanted.Magnitude <= 0.001 then return end

			current, wanted = current.Unit, wanted.Unit
			local angle = math.acos(math.clamp(current:Dot(wanted), -1, 1))
			local cross = current:Cross(wanted)
			root.AssemblyAngularVelocity = Vector3.new(0, cross.Y * angle * TURN_SPEED, 0)
		end))
		pcall(function() _G.__CrystalTrackConn(lockConn) end)
	end

	_G.__VyloBodyLockStop = stopBodyLock
	FeaturePostToggle["Body Lock"] = function(active)
		if active then startBodyLock() else stopBodyLock() end
	end
	end
	FeaturePostToggle["Body Lock"](toggleStates["Body Lock"] == true)

	do
	local aimbotRow = makeToggle(combatSection, "Aimbot", "Aimbot")
	pcall(function() styleSmallToggle(aimbotRow) end)
	end


;(function()
pcall(function()
local oldMarker = workspace:FindFirstChild("CrystalTPBatLastPosition")
if oldMarker then oldMarker:Destroy() end
end)
local tpBatState = {
enabled = false,
heartbeat = nil,
target = nil,
samples = {},
swingLocked = false,
nextSwingAt = 0,
lastSafeCFrame = nil,
lastPosition = nil,
lastSampleTime = 0,
recoverUntil = 0,
physicsPauseUntil = 0,
previousAutoRotate = nil,
lastTargetMarker = nil,
markerLocked = false,
markerTarget = nil,
markerBodyLock = nil,
markerBodyAttachment = nil,
}
_G.__batVersion = tonumber(_G.__batVersion) == 2 and 2 or 1
local getRig = (function()
local character = Player.Character
if not character then return nil, nil, nil end
return character, character:FindFirstChild("HumanoidRootPart"), character:FindFirstChildOfClass("Humanoid")
end)

local finiteVector = (function(vector)
return vector ~= nil
and vector.X == vector.X and vector.Y == vector.Y and vector.Z == vector.Z
and math.abs(vector.X) < 10000000
and math.abs(vector.Y) < 10000000
and math.abs(vector.Z) < 10000000
end)

local facingCFrame = (function(position, lookTargetPos, fallbackLook, keepCF)
local flat = Vector3.new(lookTargetPos.X - position.X, 0, lookTargetPos.Z - position.Z)
if flat.Magnitude > 0.05 then
return CFrame.lookAt(position, position + flat.Unit)
end
local flatFallback = fallbackLook and Vector3.new(fallbackLook.X, 0, fallbackLook.Z) or nil
if flatFallback and flatFallback.Magnitude >= 0.01 then
return CFrame.lookAt(position, position + flatFallback.Unit)
end
if keepCF then
local _, yaw = keepCF:ToEulerAnglesYXZ()
return CFrame.new(position) * CFrame.Angles(0, yaw, 0)
end
return CFrame.new(position)
end)

local TP_BAT_MARKER_DISTANCE = 3

local markerEngagementCFrame = (function(root, marker)
if not root or not marker then return nil end
local markerPosition = marker.Position
local away = Vector3.new(
root.Position.X - markerPosition.X,
0,
root.Position.Z - markerPosition.Z
)
if away.Magnitude <= 0.05 then
local look = marker.CFrame.LookVector
away = Vector3.new(-look.X, 0, -look.Z)
end
if away.Magnitude <= 0.05 then away = Vector3.new(0, 0, 1) end
local teleportPosition = markerPosition + away.Unit * TP_BAT_MARKER_DISTANCE
return facingCFrame(teleportPosition, markerPosition, marker.CFrame.LookVector, root.CFrame)
end)

local clearMarkerBodyLock = (function()
if tpBatState.markerBodyLock then
pcall(function() tpBatState.markerBodyLock:Destroy() end)
tpBatState.markerBodyLock = nil
end
if tpBatState.markerBodyAttachment then
pcall(function() tpBatState.markerBodyAttachment:Destroy() end)
tpBatState.markerBodyAttachment = nil
end
end)

local applyMarkerBodyLock = (function(root, marker)

clearMarkerBodyLock()
end)

_G.__CrystalTPBatApplyMarkerBodyLock = applyMarkerBodyLock
_G.__CrystalTPBatClearMarkerBodyLock = clearMarkerBodyLock

local safeTeleport = (function(root, targetCFrame)
	if not root or not targetCFrame then return false end
	local marker = tpBatState and tpBatState.lastTargetMarker
	if marker and marker.Parent and marker.Transparency and marker.Transparency < 1 then

		return false
	end
	local ok = pcall(function()
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
		root.CFrame = targetCFrame
		root.AssemblyLinearVelocity = Vector3.zero
		root.AssemblyAngularVelocity = Vector3.zero
	end)
	return ok
end)

local TP_BAT_MIN_X, TP_BAT_MAX_X = -536.2, -422
local TP_BAT_MIN_Y, TP_BAT_MAX_Y = -10, 75
local TP_BAT_MIN_Z, TP_BAT_MAX_Z = -71.8, 192.9
local TP_BAT_MARKER_GROUND_Y = -7
local TP_BAT_MARKER_LOOKBACK = 0.2

local isInsideAllowedArea = (function(position)
if not position then return false end
return position.X >= TP_BAT_MIN_X and position.X <= TP_BAT_MAX_X
and position.Y >= TP_BAT_MIN_Y and position.Y <= TP_BAT_MAX_Y
and position.Z >= TP_BAT_MIN_Z and position.Z <= TP_BAT_MAX_Z
end)

_G.__CrystalTPBatIsInsideMap = isInsideAllowedArea

local updateLastTargetMarker = (function(targetCFrame)
if tpBatState.markerLocked then return end

	local tracked = tpBatState.markerTarget
	local character = tracked and tracked.Parent == Players and tracked.Character
	local targetRoot = character and character:FindFirstChild("HumanoidRootPart")
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	if not targetRoot or not humanoid or humanoid.Health <= 0
	or not finiteVector(targetRoot.Position) or isInsideAllowedArea(targetRoot.Position) then return end
if not targetCFrame or not isInsideAllowedArea(targetCFrame.Position) then return end

local groundMarkerCFrame = CFrame.new(
targetCFrame.Position.X,
TP_BAT_MARKER_GROUND_Y,
targetCFrame.Position.Z
) * targetCFrame.Rotation
local marker = tpBatState.lastTargetMarker
if not marker or not marker.Parent then
marker = Instance.new("Part")
marker.Name = "CrystalTPBatLastPosition"
marker.Shape = Enum.PartType.Ball
marker.Size = Vector3.new(3, 3, 3)
marker.Color = Color3.fromRGB(0, 110, 255)
marker.Material = Enum.Material.Neon
marker.Anchored = true
marker.CanCollide = false
marker.CanTouch = false
marker.CanQuery = false
marker.CastShadow = false
marker.Parent = workspace

local overlaySphere = Instance.new("SphereHandleAdornment")
overlaySphere.Name = "AlwaysOnTopSphere"
overlaySphere.Adornee = marker
overlaySphere.Radius = 1.55
overlaySphere.Color3 = Color3.fromRGB(0, 125, 255)
overlaySphere.Transparency = 0.05
overlaySphere.AlwaysOnTop = true
overlaySphere.Visible = true
overlaySphere.ZIndex = 10
overlaySphere.Parent = marker

local highlight = Instance.new("Highlight")
highlight.Name = "LastPositionHighlight"
highlight.Adornee = marker
highlight.FillColor = Color3.fromRGB(0, 110, 255)
highlight.FillTransparency = 0.15
highlight.OutlineColor = Color3.fromRGB(120, 200, 255)
highlight.OutlineTransparency = 0
highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
highlight.Enabled = true
highlight.Parent = marker

local billboard = Instance.new("BillboardGui")
billboard.Name = "LastPositionLabel"
billboard.Size = UDim2.new(0, 110, 0, 20)
billboard.StudsOffset = Vector3.new(0, 2.1, 0)
billboard.AlwaysOnTop = true
billboard.Adornee = marker
billboard.Parent = marker

local label = Instance.new("TextLabel")
label.Name = "Text"
label.Size = UDim2.fromScale(1, 1)
label.BackgroundTransparency = 1
label.Text = "ultima posicion"
label.TextColor3 = Color3.fromRGB(220, 235, 255)
label.TextStrokeColor3 = Color3.fromRGB(0, 35, 90)
label.TextStrokeTransparency = 0.25
label.TextSize = 11
label.Font = Enum.Font.GothamMedium
label.Parent = billboard

tpBatState.lastTargetMarker = marker
end
marker.Transparency = 0
local overlaySphere = marker:FindFirstChild("AlwaysOnTopSphere")
if overlaySphere then overlaySphere.Visible = true end
local highlight = marker:FindFirstChild("LastPositionHighlight")
if highlight then highlight.Enabled = true end
local billboard = marker:FindFirstChild("LastPositionLabel")
if billboard then billboard.Enabled = true end
marker.CFrame = groundMarkerCFrame
tpBatState.markerLocked = true
end)

local clearLastTargetMarker = (function()
tpBatState.markerLocked = false
clearMarkerBodyLock()
if tpBatState.lastTargetMarker then
pcall(function()
tpBatState.lastTargetMarker.Transparency = 1
local overlaySphere = tpBatState.lastTargetMarker:FindFirstChild("AlwaysOnTopSphere")
if overlaySphere then overlaySphere.Visible = false end
local highlight = tpBatState.lastTargetMarker:FindFirstChild("LastPositionHighlight")
if highlight then highlight.Enabled = false end
local billboard = tpBatState.lastTargetMarker:FindFirstChild("LastPositionLabel")
if billboard then billboard.Enabled = false end
end)
end
end)

_G.__CrystalTPBatGetMarkerCFrame = function()
local marker = tpBatState.lastTargetMarker
if tpBatState.markerLocked and marker and marker.Parent and marker.Transparency < 1 then
local tracked = tpBatState.markerTarget
local trackedRoot = tracked and tracked.Character and tracked.Character:FindFirstChild("HumanoidRootPart")
if trackedRoot and isInsideAllowedArea(trackedRoot.Position) then
clearLastTargetMarker()
return nil
end
local _, root = getRig()
return markerEngagementCFrame(root, marker) or marker.CFrame
end
return nil
end

_G.__CrystalTPBatTrackTarget = function(player)
if tpBatState.markerLocked then return tpBatState.markerTarget end

local current = tpBatState.markerTarget
local currentCharacter = current and current.Parent == Players and current.Character
local currentHumanoid = currentCharacter and currentCharacter:FindFirstChildOfClass("Humanoid")
local currentRoot = currentCharacter and currentCharacter:FindFirstChild("HumanoidRootPart")
local currentSample = current and tpBatState.samples[current]
if current and current.Parent == Players then

if currentHumanoid and currentHumanoid.Health > 0
and ((currentRoot and isInsideAllowedArea(currentRoot.Position))
or (currentSample and currentSample.safeCFrame)) then return current end
if not currentHumanoid and currentSample and currentSample.safeCFrame then return current end
end
if player and player ~= Player and player.Parent == Players then
tpBatState.markerTarget = player
return player
end
return tpBatState.markerTarget
end

_G.__CrystalTPBatClearMarkerTracking = function()
tpBatState.target = nil

end

local targetAlive = (function(player, myRoot)
if not player or player.Parent ~= Players or not player.Character then return false end
local root = player.Character:FindFirstChild("HumanoidRootPart")
local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
if not root or not humanoid or humanoid.Health <= 0 or not isInsideAllowedArea(root.Position) then
return false
end
return true
end)

local getSnapshotBeforeExit = (function(sample, now)
if not sample or not sample.history or #sample.history == 0 then return nil end
local cutoff = now - TP_BAT_MARKER_LOOKBACK
local selected = nil
for _, entry in ipairs(sample.history) do
if entry.time <= cutoff then
selected = entry
else
break
end
end

return selected or sample.history[1]
end)

_G.__CrystalTPBatForceMarker = function(player, fallbackCFrame)
if player and player.Parent == Players then
tpBatState.markerTarget = player
end
local sample = player and tpBatState.samples[player]
local snapshot = getSnapshotBeforeExit(sample, tick())
local remembered = snapshot and snapshot.safeCFrame or (sample and sample.safeCFrame)
if not remembered and fallbackCFrame and isInsideAllowedArea(fallbackCFrame.Position) then
remembered = fallbackCFrame
end
if remembered then updateLastTargetMarker(remembered) end
return _G.__CrystalTPBatGetMarkerCFrame()
end

local monitorLastTarget = (function()
local _, myRoot = getRig()
if not myRoot then return end

local tracked = tpBatState.markerTarget
	if tracked and tracked.Parent == Players then
local targetRoot = tracked.Character and tracked.Character:FindFirstChild("HumanoidRootPart")
local targetHumanoid = tracked.Character and tracked.Character:FindFirstChildOfClass("Humanoid")
local sample = tpBatState.samples[tracked] or {}
tpBatState.samples[tracked] = sample

if targetRoot and targetHumanoid and targetHumanoid.Health > 0 and finiteVector(targetRoot.Position) then
if isInsideAllowedArea(targetRoot.Position) then
local now = tick()
if tpBatState.markerLocked then
sample.history = {}
end
sample.history = sample.history or {}
table.insert(sample.history, {
time = now,
safePosition = targetRoot.Position,
safeCFrame = targetRoot.CFrame,
})

while sample.history[1] and now - sample.history[1].time > (TP_BAT_MARKER_LOOKBACK + 0.25) do
table.remove(sample.history, 1)
end
sample.safePosition = targetRoot.Position
sample.safeCFrame = targetRoot.CFrame
clearLastTargetMarker()
else
local snapshot = getSnapshotBeforeExit(sample, tick())
updateLastTargetMarker((snapshot and snapshot.safeCFrame) or sample.safeCFrame)
end
end
		if (targetHumanoid and targetHumanoid.Health <= 0)
		or (not targetRoot and not sample.safeCFrame) then
		tpBatState.markerTarget = nil
		clearLastTargetMarker()
		else
		return
		end
end

local closest, closestDistanceSq = nil, math.huge
for _, player in ipairs(Players:GetPlayers()) do
if player ~= Player and targetAlive(player) then
local targetRoot = player.Character:FindFirstChild("HumanoidRootPart")
local delta = targetRoot.Position - myRoot.Position
local distanceSq = delta:Dot(delta)
if distanceSq < closestDistanceSq then
closest = player
closestDistanceSq = distanceSq
end
end
end

if closest then
tpBatState.markerTarget = closest
local targetRoot = closest.Character:FindFirstChild("HumanoidRootPart")
local sample = tpBatState.samples[closest] or {}
tpBatState.samples[closest] = sample
sample.safePosition = targetRoot.Position
sample.safeCFrame = targetRoot.CFrame
sample.history = {
{ time = tick(), safePosition = targetRoot.Position, safeCFrame = targetRoot.CFrame }
}
end
end)

local markerMonitorAccumulator = 0
local TP_BAT_MARKER_INTERVAL = 1 / 60
local markerMonitor = RunService.Heartbeat:Connect((function(dt)

markerMonitorAccumulator = markerMonitorAccumulator + (dt or 0)
if markerMonitorAccumulator < TP_BAT_MARKER_INTERVAL then return end
markerMonitorAccumulator = markerMonitorAccumulator % TP_BAT_MARKER_INTERVAL
monitorLastTarget()
end))
_G.__CrystalTrackConn(markerMonitor)

local function followPreservedMarker(root)
local markerCFrame = _G.__CrystalTPBatGetMarkerCFrame()
if not markerCFrame then
clearMarkerBodyLock()
return false
end
pcall(function()
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
root.CFrame = markerCFrame
root.AssemblyLinearVelocity = Vector3.zero
root.AssemblyAngularVelocity = Vector3.zero
end)
local marker = tpBatState.lastTargetMarker
if marker then applyMarkerBodyLock(root, marker) end
return true
end
_G.__CrystalTrackStopper(function() pcall(clearLastTargetMarker) end)

	do
	local tpBatState = {
	enabled = false,
	heartbeat = nil,
	target = nil,
	samples = {},
	swingLocked = false,
	nextSwingAt = 0,
	lastSafeCFrame = nil,
	lastPosition = nil,
	lastSampleTime = 0,
	recoverUntil = 0,
	physicsPauseUntil = 0,
	previousAutoRotate = nil,
	lastTargetMarker = nil,
	markerLocked = false,
	markerTarget = nil,
	}
	_G.__batVersion = tonumber(_G.__batVersion) == 2 and 2 or 1
	local TP_BAT_RATE = 67
	local TP_BAT_COOLDOWN = 1 / TP_BAT_RATE

	local BAT_NAMES = {
	"Bat", "Slap", "Iron Slap", "Gold Slap", "Diamond Slap",
	"Emerald Slap", "Ruby Slap", "Dark Matter Slap", "Flame Slap",
	"Nuclear Slap", "Galaxy Slap", "Glitched Slap",
	}

	local function getRig()
	local character = Player.Character
	if not character then return nil, nil, nil end
	return character, character:FindFirstChild("HumanoidRootPart"), character:FindFirstChildOfClass("Humanoid")
	end

	local function findBat(equip)
	local character, _, humanoid = getRig()
	if not character then return nil end

	for _, name in ipairs(BAT_NAMES) do
	local tool = character:FindFirstChild(name)
	if tool and tool:IsA("Tool") then return tool end
	end
	for _, child in ipairs(character:GetChildren()) do
	if child:IsA("Tool") then
	local name = child.Name:lower()
	if name:find("bat", 1, true) or name:find("slap", 1, true) then
	return child
	end
	end
	end

	local backpack = Player:FindFirstChildOfClass("Backpack")
	if backpack then
	local found = nil
	for _, name in ipairs(BAT_NAMES) do
	local tool = backpack:FindFirstChild(name)
	if tool and tool:IsA("Tool") then found = tool; break end
	end
	if not found then
	for _, child in ipairs(backpack:GetChildren()) do
	if child:IsA("Tool") then
	local name = child.Name:lower()
	if name:find("bat", 1, true) or name:find("slap", 1, true) then
	found = child
	break
	end
	end
	end
	end
	if found and equip and humanoid then
	pcall(function() humanoid:EquipTool(found) end)
	end
	return found
	end
	return nil
	end

	local function finiteVector(vector)
	return vector.X == vector.X and vector.Y == vector.Y and vector.Z == vector.Z
	and math.abs(vector.X) < 10000000
	and math.abs(vector.Y) < 10000000
	and math.abs(vector.Z) < 10000000
	end

	local function facingCFrame(position, lookTargetPos, fallbackLook, keepCF)
	local flat = Vector3.new(lookTargetPos.X - position.X, 0, lookTargetPos.Z - position.Z)
	if flat.Magnitude > 0.05 then
	return CFrame.lookAt(position, position + flat.Unit)
	end
	local flatFallback = fallbackLook and Vector3.new(fallbackLook.X, 0, fallbackLook.Z) or nil
	if flatFallback and flatFallback.Magnitude >= 0.01 then
	return CFrame.lookAt(position, position + flatFallback.Unit)
	end
	if keepCF then
	local _, yaw = keepCF:ToEulerAnglesYXZ()
	return CFrame.new(position) * CFrame.Angles(0, yaw, 0)
	end
	return CFrame.new(position)
	end

	local function isInsideAllowedArea(position)
	return position ~= nil
	end

	local function clearLastTargetMarker() end
	local function targetAlive(player, myRoot)
	if not player or player.Parent ~= Players or not player.Character then return false end
	local root = player.Character:FindFirstChild("HumanoidRootPart")
	local humanoid = player.Character:FindFirstChildOfClass("Humanoid")
	if not root or not humanoid or humanoid.Health <= 0 or not finiteVector(root.Position) then
	return false
	end
	local sample = tpBatState.samples[player]
	return _G.__CrystalTPBatIsInsideMap(root.Position)
	or (sample ~= nil and sample.safeCFrame ~= nil)
	end

	local function getRememberedTargetCFrame(player, myRoot)
	local sample = player and tpBatState.samples[player]
	local saved = sample and sample.safeCFrame
	if saved and isInsideAllowedArea(saved.Position)
	and (not myRoot or isInsideAllowedArea(saved.Position)) then
	return saved
	end
	return nil
	end

	local function closestTarget(myRoot)

	local tracked = _G.__CrystalTPBatTrackTarget(tpBatState.target)
	if targetAlive(tracked, myRoot) then
	tpBatState.target = tracked
	return tracked
	end
	if targetAlive(tpBatState.target, myRoot) then return tpBatState.target end

	local closest = nil
	local closestDistance = math.huge
	for _, player in ipairs(Players:GetPlayers()) do
	if player ~= Player and targetAlive(player, myRoot) then
	local root = player.Character:FindFirstChild("HumanoidRootPart")
	if root then
	local distance = (root.Position - myRoot.Position).Magnitude
	if distance < closestDistance then
	closest = player
	closestDistance = distance
	end
	end
	end
	end
	if closest then
	tpBatState.target = closest
	_G.__CrystalTPBatTrackTarget(closest)
	end
	return closest
	end

	local function getTPBatDistance()
	local distance = tonumber(_G.__tpBatV2Distance)
	if not distance or distance ~= distance then return 8 end
	return math.clamp(distance, 0, 100)
	end

	local function swingBat()
	local now = tick()
	if tpBatState.swingLocked or now < tpBatState.nextSwingAt then return end
	tpBatState.swingLocked = true
	tpBatState.nextSwingAt = now + TP_BAT_COOLDOWN

	pcall(function()
	local character = Player.Character
	if not character then return end
	local tool = findBat(true)
	if not tool then return end
	if tool.Parent ~= character then
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then humanoid:EquipTool(tool) end
	end
	tool:Activate()
	local remote = tool:FindFirstChildWhichIsA("RemoteEvent", true)
	if remote then pcall(function() remote:FireServer() end) end
	end)

	task.delay(TP_BAT_COOLDOWN, function()
	tpBatState.swingLocked = false
	end)
	end

	local function resetPhysicsRoot(root)
	if sethiddenproperty then
	pcall(function() sethiddenproperty(root, "PhysicsRepRootPart", root) end)
	end
	end

	local function desktopHeartbeatStep()
	if not tpBatState.enabled then return end
	local character, root, humanoid = getRig()
	if not character or not root or not humanoid or humanoid.Health <= 0 then return end

	if followPreservedMarker(root) then
	swingBat()
	return
	end
	if tpBatState.previousAutoRotate == nil then tpBatState.previousAutoRotate = humanoid.AutoRotate end
	humanoid.AutoRotate = false

	findBat(true)
	local target = closestTarget(root)
	if target then
	local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
	local rememberedCFrame = getRememberedTargetCFrame(target, root)

	if not targetRoot or not finiteVector(targetRoot.Position) then return end
	if not _G.__CrystalTPBatIsInsideMap(targetRoot.Position) then
	_G.__CrystalTPBatForceMarker(target, rememberedCFrame)
	if followPreservedMarker(root) then swingBat() end
	return
	end
	local targetCFrame = targetRoot.CFrame
	local sample = tpBatState.samples[target] or {}
	tpBatState.samples[target] = sample
	sample.safeCFrame = targetRoot.CFrame
	sample.safePosition = targetRoot.Position
	local targetPos = targetCFrame.Position + Vector3.new(0, 0.9, 0)
	local targetLook = targetCFrame.LookVector
		if (root.Position - targetPos).Magnitude > getTPBatDistance() then

		safeTeleport(root, facingCFrame(targetPos, targetCFrame.Position, targetLook, root.CFrame))
		else

		safeTeleport(root, facingCFrame(root.Position, targetCFrame.Position, targetLook, root.CFrame))
		end

	if sethiddenproperty then
	pcall(function()
	if targetRoot then sethiddenproperty(root, "PhysicsRepRootPart", targetRoot) end
	end)
	end
	local cam = workspace.CurrentCamera
	if cam then
	pcall(function() cam.CFrame = CFrame.new(cam.CFrame.Position, targetCFrame.Position) end)
	end
	swingBat()
	end
	end

	local function zurichV2HeartbeatStep()
	if not tpBatState.enabled then return end
	local character, root, humanoid = getRig()
	if not character or not root or not humanoid or humanoid.Health <= 0 then return end

	if followPreservedMarker(root) then
	swingBat()
	return
	end
	if tpBatState.previousAutoRotate == nil then tpBatState.previousAutoRotate = humanoid.AutoRotate end
	humanoid.AutoRotate = false

	local target = closestTarget(root)
	if not target then return end
	local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
	local rememberedCFrame = getRememberedTargetCFrame(target, root)
	local targetCFrame = targetRoot and targetRoot.CFrame or rememberedCFrame
	local usingRememberedPosition = not targetRoot
	local markerTrigger = false

	if targetRoot then
	local sample = tpBatState.samples[target] or {}
	tpBatState.samples[target] = sample
	markerTrigger = targetRoot.Position.Y < -9
	or not _G.__CrystalTPBatIsInsideMap(targetRoot.Position)
	or not finiteVector(targetRoot.Position)
	local validSnapshot = finiteVector(targetRoot.Position)
	and _G.__CrystalTPBatIsInsideMap(targetRoot.Position)
	if validSnapshot then
	sample.safeCFrame = targetRoot.CFrame
	sample.safePosition = targetRoot.Position
	else
	targetCFrame = rememberedCFrame
	usingRememberedPosition = true
	end
	end

	if not targetCFrame then return end
	if usingRememberedPosition and markerTrigger then
	_G.__CrystalTPBatForceMarker(target, targetCFrame)
	if followPreservedMarker(root) then
	swingBat()
	return
	end
	end

	local targetPosition = targetCFrame.Position
	if not usingRememberedPosition then
	targetPosition = targetPosition + Vector3.new(0, 0.9, 0)
	end
	local engagement
	if (root.Position - targetPosition).Magnitude > getTPBatDistance() then
	engagement = facingCFrame(targetPosition, targetCFrame.Position, targetCFrame.LookVector, root.CFrame)
	else
	engagement = facingCFrame(root.Position, targetCFrame.Position, targetCFrame.LookVector, root.CFrame)
	end
	safeTeleport(root, engagement)

	if sethiddenproperty then
	pcall(function()
	if targetRoot then sethiddenproperty(root, "PhysicsRepRootPart", targetRoot) end
	end)
	end
	local camera = workspace.CurrentCamera
	if camera then
	pcall(function() camera.CFrame = CFrame.new(camera.CFrame.Position, targetCFrame.Position) end)
	end
	swingBat()
	end

	local function inspectMobileTarget(player, targetRoot, myRoot)
	if not targetAlive(player, myRoot) or not targetRoot then return true, nil end

	local now = tick()
	local position = targetRoot.Position
	local velocity = targetRoot.AssemblyLinearVelocity
	local sample = tpBatState.samples[player] or {}
	tpBatState.samples[player] = sample

	local destroyHeight = workspace.FallenPartsDestroyHeight or -500
	local voidFloor = math.max(destroyHeight + 90, -50)
	local deltaTime = sample.time and math.max(now - sample.time, 1 / 240) or math.huge
	local delta = sample.position and (position - sample.position) or Vector3.zero
	local impossibleStep = sample.position ~= nil and deltaTime < 0.4 and (delta.Magnitude > 90 or math.abs(delta.Y) > 38)
	local badVelocity = not finiteVector(velocity) or velocity.Magnitude > 100 or math.abs(velocity.Y) > 150
	local badPosition = not finiteVector(position) or position.Y <= voidFloor or position.Y > 650 or (myRoot and (position - myRoot.Position).Magnitude > 4000)

	if badPosition or badVelocity or impossibleStep then
	sample.suspiciousUntil = now + 1.35
	elseif now >= (sample.suspiciousUntil or 0) then
	sample.safePosition = position
	sample.safeCFrame = targetRoot.CFrame
	end
	sample.position = position
	sample.time = now
	return now < (sample.suspiciousUntil or 0), sample
	end

	local function guardMobileAgainstVoid(root, humanoid, targetRoot)
	local now = tick()
	local position = root.Position
	local velocity = root.AssemblyLinearVelocity
	local destroyHeight = workspace.FallenPartsDestroyHeight or -500
	local voidFloor = math.max(destroyHeight + 80, -55)
	local deltaTime = now - (tpBatState.lastSampleTime or now)
	local suddenDrop = tpBatState.lastPosition and deltaTime <= 0.35 and position.Y < tpBatState.lastPosition.Y - 40
	local suddenRise = tpBatState.lastPosition and deltaTime <= 0.35 and position.Y > tpBatState.lastPosition.Y + 25
	local forcedLaunch = math.abs(velocity.Y) > 90 or velocity.Magnitude > 450
	local invalidHeight = position.Y <= voidFloor or position.Y > 400
	local recovering = now < tpBatState.recoverUntil

	if invalidHeight or suddenDrop or suddenRise or forcedLaunch then
	resetPhysicsRoot(root)
	local recovery = tpBatState.lastSafeCFrame
	if targetRoot and targetRoot.Parent and targetRoot.Position.Y > voidFloor + 10 and targetRoot.Position.Y < 350 then
	local positionOnTarget = targetRoot.Position + Vector3.new(0, 0.9, 0)
	recovery = facingCFrame(positionOnTarget, targetRoot.Position, targetRoot.CFrame.LookVector)
	end
	pcall(function()
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	humanoid.PlatformStand = false
	humanoid.Sit = false
	humanoid.AutoRotate = true
	humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	if recovery then safeTeleport(root, recovery) end
	end)
	tpBatState.recoverUntil = now + 0.55
	tpBatState.physicsPauseUntil = now + 0.20
	recovering = true
	elseif not recovering and position.Y > voidFloor + 15 and math.abs(velocity.Y) < 85 and position.Y < 250 then
	tpBatState.lastSafeCFrame = root.CFrame
	end

	if recovering then
	pcall(function()
	root.AssemblyLinearVelocity = Vector3.zero
	root.AssemblyAngularVelocity = Vector3.zero
	if targetRoot and targetRoot.Parent and targetRoot.Position.Y > voidFloor + 10 and targetRoot.Position.Y < 350 then
	safeTeleport(root, facingCFrame(targetRoot.Position + Vector3.new(0, 0.9, 0), targetRoot.Position, targetRoot.CFrame.LookVector))
	elseif tpBatState.lastSafeCFrame then
	safeTeleport(root, facingCFrame(root.Position, root.Position, nil, tpBatState.lastSafeCFrame))
	end
	end)
	resetPhysicsRoot(root)
	end

	tpBatState.lastPosition = root.Position
	tpBatState.lastSampleTime = now
	return recovering
	end

	local function mobileHeartbeatStep()
	if not tpBatState.enabled then return end
	local character, root, humanoid = getRig()
	if not character or not root or not humanoid or humanoid.Health <= 0 then return end

	if followPreservedMarker(root) then
	swingBat()
	return
	end
	if tpBatState.previousAutoRotate == nil then tpBatState.previousAutoRotate = humanoid.AutoRotate end
	humanoid.AutoRotate = false

	findBat(true)
	local target = closestTarget(root)
	if target then
	local targetRoot = target.Character and target.Character:FindFirstChild("HumanoidRootPart")
	local rememberedCFrame = getRememberedTargetCFrame(target, root)
	local targetLeftMap = targetRoot and not _G.__CrystalTPBatIsInsideMap(targetRoot.Position)
	if targetLeftMap then targetRoot = nil end
	if targetRoot or rememberedCFrame then
	local suspicious, sample = false, tpBatState.samples[target]
	if targetRoot then suspicious, sample = inspectMobileTarget(target, targetRoot, root) end
	if guardMobileAgainstVoid(root, humanoid, suspicious and nil or targetRoot) then
	swingBat()
	return
	end

	local targetPosition
	if suspicious then
	targetPosition = sample and sample.safePosition
	if not targetPosition and tpBatState.lastSafeCFrame then targetPosition = tpBatState.lastSafeCFrame.Position end
	if not targetPosition then targetPosition = root.Position end
	elseif targetRoot then
	local velocity = targetRoot.AssemblyLinearVelocity
	local prediction = Vector3.new(velocity.X, 0, velocity.Z) * 0.05
	targetPosition = targetRoot.Position + Vector3.new(0, 0.9, 0) + prediction
	else
	targetPosition = rememberedCFrame.Position
	end

	if targetRoot and not suspicious and targetPosition.Y < -20 then
	targetPosition = Vector3.new(targetPosition.X, root.Position.Y, targetPosition.Z)
	end

	local targetCFrame = targetRoot and targetRoot.CFrame or rememberedCFrame
	local engagement = facingCFrame(targetPosition, targetCFrame.Position, targetCFrame.LookVector, tpBatState.lastSafeCFrame)
	safeTeleport(root, engagement)
	pcall(function()
	if targetRoot then
	local targetVelocity = targetRoot.AssemblyLinearVelocity
	root.AssemblyLinearVelocity = Vector3.new(targetVelocity.X, 0, targetVelocity.Z)
	end
	root.AssemblyAngularVelocity = Vector3.zero
	end)
	tpBatState.lastSafeCFrame = engagement

	if sethiddenproperty and tick() >= tpBatState.physicsPauseUntil then
	pcall(function()
	if targetRoot then sethiddenproperty(root, "PhysicsRepRootPart", targetRoot) end
	end)
	end

	local camera = workspace.CurrentCamera
	if camera then pcall(function() camera.CFrame = CFrame.new(camera.CFrame.Position, targetCFrame.Position) end) end
	swingBat()
	end
	end
	end

	local function selectedHeartbeatStep()
	if _G.__batVersion == 2 then
	return zurichV2HeartbeatStep()
	end

	return desktopHeartbeatStep()
	end

	local function stopTPBat()
	local wasEnabled = tpBatState.enabled
	local stopGeneration = tpBatState.returnGeneration
	clearMarkerBodyLock()
	tpBatState.enabled = false
	if tpBatState.heartbeat then
	tpBatState.heartbeat:Disconnect()
	tpBatState.heartbeat = nil
	end
	tpBatState.target = nil
	tpBatState.samples = {}
	tpBatState.swingLocked = false

	local _, root, humanoid = getRig()
	if root then

	local velocity = root.AssemblyLinearVelocity
	local horizontal = Vector3.new(velocity.X, 0, velocity.Z)
	if horizontal.Magnitude > 120 then horizontal = horizontal.Unit * 120 end
	root.AssemblyLinearVelocity = Vector3.new(horizontal.X, math.clamp(velocity.Y, -50, 50), horizontal.Z)
	root.AssemblyAngularVelocity = Vector3.zero
	resetPhysicsRoot(root)
	end
	if humanoid then
	humanoid.AutoRotate = tpBatState.previousAutoRotate == nil and true or tpBatState.previousAutoRotate
	pcall(function()
	humanoid.PlatformStand = false
	humanoid.Sit = false
	local state = humanoid:GetState()
	if state == Enum.HumanoidStateType.Physics
	or state == Enum.HumanoidStateType.Ragdoll
	or state == Enum.HumanoidStateType.FallingDown then
	humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
	humanoid:ChangeState(Enum.HumanoidStateType.Running)
	end
	local camera = workspace.CurrentCamera
	if camera then camera.CameraSubject = humanoid end
	end)
	end
	tpBatState.previousAutoRotate = nil

	if wasEnabled and root then
	task.spawn(function()
	for _ = 1, 12 do
	RunService.Heartbeat:Wait()
	if tpBatState.enabled or tpBatState.returnGeneration ~= stopGeneration then return end
	if _G.__CRYSTAL_STATE ~= crystalRuntimeState then return end
	local _, currentRoot, currentHumanoid = getRig()
	if currentRoot ~= root or not currentHumanoid or currentHumanoid.Health <= 0 then return end
	local currentVelocity = currentRoot.AssemblyLinearVelocity
	local currentHorizontal = Vector3.new(currentVelocity.X, 0, currentVelocity.Z)
	if currentHorizontal.Magnitude > 120 then currentHorizontal = currentHorizontal.Unit * 120 end
	currentRoot.AssemblyLinearVelocity = Vector3.new(currentHorizontal.X, math.clamp(currentVelocity.Y, -50, 50), currentHorizontal.Z)
	currentRoot.AssemblyAngularVelocity = Vector3.zero
	resetPhysicsRoot(currentRoot)
	end
	end)
	end

	if wasEnabled then
	task.delay(0.4, function()
	if tpBatState.enabled or tpBatState.returnGeneration ~= stopGeneration then return end
	if _G.__CRYSTAL_STATE ~= crystalRuntimeState then return end
	pcall(function() if _G.__CrystalAntiDieSet then _G.__CrystalAntiDieSet(false) end end)
	end)
	else
	pcall(function() if _G.__CrystalAntiDieSet then _G.__CrystalAntiDieSet(false) end end)
	end
	end

	local function startTPBat()
	if tpBatState.enabled then return end
	tpBatState.returnGeneration = (tpBatState.returnGeneration or 0) + 1
	if toggleStates["Autoplay"] and _G.__stopAutoplay then _G.__stopAutoplay() end
	tpBatState.enabled = true

	pcall(function() if _G.__CrystalAntiDieSet then _G.__CrystalAntiDieSet(true) end end)
	tpBatState.target = nil
	tpBatState.samples = {}
	tpBatState.swingLocked = false
	tpBatState.nextSwingAt = 0
	tpBatState.lastPosition = nil
	tpBatState.lastSampleTime = tick()
		tpBatState.recoverUntil = 0
		tpBatState.physicsPauseUntil = 0

		tpBatState.startingUntil = tick() + 0.35
	local _, root, humanoid = getRig()
	if root then
	resetPhysicsRoot(root)
	if root.Position.Y > -30 then tpBatState.lastSafeCFrame = root.CFrame end
	end
	if humanoid then tpBatState.previousAutoRotate = humanoid.AutoRotate end
		if tpBatState.heartbeat then tpBatState.heartbeat:Disconnect() end
		tpBatState.heartbeat = RunService.Heartbeat:Connect(selectedHeartbeatStep)

		task.spawn(function() pcall(selectedHeartbeatStep) end)
	end

	-- The previous Crystal TP Bat engine is intentionally left disconnected.
	-- The toggle below now uses the direct Cursed TP Bat engine only; this does
	-- not create a second GUI and is controlled exclusively by the existing UI.
	local cursedDirectBat = {
		enabled = false,
		connection = nil,
		hitCooldown = false,
		antiDieConnections = {},
	}

	local function cursedDisconnectAntiDie()
		for _, connection in ipairs(cursedDirectBat.antiDieConnections) do
			pcall(function() connection:Disconnect() end)
		end
		cursedDirectBat.antiDieConnections = {}
	end

	local function cursedHookAntiDie(character)
		cursedDisconnectAntiDie()
		if not cursedDirectBat.enabled or not character then return end
		local humanoid = character:FindFirstChildOfClass("Humanoid")
		if not humanoid then return end
		pcall(function()
			humanoid.BreakJointsOnDeath = false
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Dead, false)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Dying, false)
		end)
		cursedDirectBat.antiDieConnections[#cursedDirectBat.antiDieConnections + 1] = humanoid:GetPropertyChangedSignal("Health"):Connect(function()
			if cursedDirectBat.enabled and humanoid.Parent and humanoid.Health <= 0 then
				pcall(function()
					humanoid.Health = humanoid.MaxHealth
					humanoid:ChangeState(Enum.HumanoidStateType.Running)
				end)
			end
		end)
	end

	local function cursedFindBat()
		local character = Player.Character
		if not character then return nil end
		local function isBat(item)
			local name = item.Name:lower()
			return item:IsA("Tool") and (name:find("bat") or name:find("slap"))
		end
		for _, child in ipairs(character:GetChildren()) do
			if isBat(child) then return child end
		end
		local backpack = Player:FindFirstChildOfClass("Backpack")
		if backpack then
			for _, child in ipairs(backpack:GetChildren()) do
				if isBat(child) then
					local humanoid = character:FindFirstChildOfClass("Humanoid")
					if humanoid then pcall(function() humanoid:EquipTool(child) end) end
					return child
				end
			end
		end
		return nil
	end

	local function cursedNearestPlayerTarget(root)
		local target, distance = nil, math.huge
		for _, otherPlayer in ipairs(Players:GetPlayers()) do
			local character = otherPlayer ~= Player and otherPlayer.Character
			local otherRoot = character and character:FindFirstChild("HumanoidRootPart")
			local humanoid = character and character:FindFirstChildOfClass("Humanoid")
			if otherRoot and humanoid and humanoid.Health > 0 then
				local candidateDistance = (root.Position - otherRoot.Position).Magnitude
				if candidateDistance < distance then
					target, distance = otherPlayer, candidateDistance
				end
			end
		end
		return target, distance
	end

	local function cursedSwing()
		if cursedDirectBat.hitCooldown then return end
		cursedDirectBat.hitCooldown = true
		pcall(function()
			local bat = cursedFindBat()
			if not bat then return end
			bat:Activate()
			local remote = bat:FindFirstChildWhichIsA("RemoteEvent")
			if remote then remote:FireServer() end
		end)
		task.delay(0.08, function() cursedDirectBat.hitCooldown = false end)
	end

	local function cursedTPBatTick()
		if not cursedDirectBat.enabled then return end
		local character = Player.Character
		local root = character and character:FindFirstChild("HumanoidRootPart")
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		if not root or not humanoid or humanoid.Health <= 0 then return end
		local bat = cursedFindBat()
		if bat and bat.Parent ~= character then pcall(function() humanoid:EquipTool(bat) end) end
		local target, distance = cursedNearestPlayerTarget(root)
		local targetRoot = target and target.Character and target.Character:FindFirstChild("HumanoidRootPart")
		if not targetRoot or distance > 100 then return end
		root.CFrame = CFrame.new(targetRoot.Position + Vector3.new(0, 0.9, 0))
		root.AssemblyLinearVelocity = targetRoot.AssemblyLinearVelocity
		local camera = workspace.CurrentCamera
		if camera then camera.CFrame = CFrame.new(camera.CFrame.Position, targetRoot.Position) end
		cursedSwing()
		for _, part in ipairs(character:GetDescendants()) do
			if part:IsA("BasePart") then part.CanCollide = false end
		end
	end

	local function cursedSetTPBatEnabled(active)
		active = active == true
		cursedDirectBat.enabled = active
		if cursedDirectBat.connection then
			cursedDirectBat.connection:Disconnect()
			cursedDirectBat.connection = nil
		end
		cursedDisconnectAntiDie()
		if active then
			cursedHookAntiDie(Player.Character)
			cursedDirectBat.connection = RunService.Heartbeat:Connect(cursedTPBatTick)
		end
		return cursedDirectBat.enabled
	end

	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(character)
		if cursedDirectBat.enabled then
			task.wait(0.1)
			cursedHookAntiDie(character)
		end
	end))

	FeaturePostToggle["TP Bat"] = function(active)
		toggleStates["TP Bat"] = false
		pcall(cursedSetTPBatEnabled, false)
		pcall(stopTPBat)
		return false
	end

	_G.__CrystalTrackStopper(function()
		pcall(cursedSetTPBatEnabled, false)
		pcall(stopTPBat)
		pcall(clearLastTargetMarker)
	end)

	_G.CrystalAutoBat = {
	GetVersion = function() return _G.__batVersion or 1 end,
	SetVersion = function(v)
	_G.__batVersion = tonumber(v) == 2 and 2 or 1
	tpBatState.samples = {}
	tpBatState.lastPosition = nil
	tpBatState.lastSampleTime = tick()
	tpBatState.recoverUntil = 0
	tpBatState.physicsPauseUntil = 0
	if _G.__batVersionPill then
	_G.__batVersionPill.Text = "V" .. tostring(_G.__batVersion)
	end
	if _G.__CrystalUpdateBatVersionButton then _G.__CrystalUpdateBatVersionButton() end
	if _G.__CrystalRefreshVisibleTPBatConfig then _G.__CrystalRefreshVisibleTPBatConfig() end
	saveConfig()
	if tpBatState.enabled then
	local _, root = getRig()
	if root then resetPhysicsRoot(root) end
	selectedHeartbeatStep()
	end
	return _G.__batVersion
	end,
	GetV2Distance = getTPBatDistance,
	SetV2Distance = function(value)
	local normalized = tostring(value):gsub(",", ".")
	local distance = tonumber(normalized)
	local valid = distance and distance == distance and math.abs(distance) < math.huge
	if valid then
	_G.__tpBatV2Distance = math.floor(math.clamp(distance, 0, 100) * 100 + 0.5) / 100
	end
	if _G.__CrystalUpdateBatVersionButton then _G.__CrystalUpdateBatVersionButton() end
	if _G.__CrystalRefreshVisibleTPBatConfig then _G.__CrystalRefreshVisibleTPBatConfig() end
	if valid then
	saveConfig()
	if tpBatState.enabled then selectedHeartbeatStep() end
	end
	return getTPBatDistance()
	end,
	SetEnabled = function(active)
		toggleStates["TP Bat"] = false
		pcall(cursedSetTPBatEnabled, false)
		pcall(stopTPBat)
		if toggleStateSetters["TP Bat"] then pcall(toggleStateSetters["TP Bat"], false) end
		if toggleVisualUpdaters["TP Bat"] then pcall(toggleVisualUpdaters["TP Bat"]) end
		return false
	end,
	Toggle = function()
		return false
	end,
	Stop = function() pcall(cursedSetTPBatEnabled, false) end,
	}
	end
end)()

	local farmingSection = combatSection

	local dropRow = makeToggle(farmingSection, "Drop", "Drop")
	pcall(function() styleSmallToggle(dropRow) end)
	local autoGrabRow = makeToggle(farmingSection, "Auto Grab", "auto steal")
	pcall(function() styleSmallToggle(autoGrabRow) end)

	do
	local grabBarGui = Instance.new("Frame", ScreenGui)
	grabBarGui.Name = "VyloStealBar"
	grabBarGui.AnchorPoint = Vector2.new(0, 0)
	local defaultExpandedW = isMobile and 270 or 360
	local defaultCollapsedW = isMobile and 240 or 320
	local partialCollapsedW = math.floor((defaultExpandedW + defaultCollapsedW) / 2)
	local savedSize = _G["_CrystalHub_UI_AutoGrabBarSize"]
	local grabBarExpanded = _G["_CrystalHub_UI_AutoGrabExpanded"] ~= nil and _G["_CrystalHub_UI_AutoGrabExpanded"] or true
	local savedWidth = tonumber(savedSize)

	if savedWidth and savedWidth < defaultCollapsedW then savedWidth = nil end
	local currentW = savedWidth and math.clamp(savedWidth, defaultCollapsedW, defaultExpandedW) or defaultExpandedW
	if savedSize and tonumber(savedSize) and tonumber(savedSize) <= defaultCollapsedW then
	grabBarExpanded = false
	end
	_G["_CrystalHub_UI_AutoGrabExpanded"] = grabBarExpanded
	local grabBarSize = UDim2.new(0, currentW, 0, isMobile and 54 or 64)
	grabBarGui.Size = grabBarSize

	local savedBarPos = _G["_CrystalHub_UI_AutoGrabBarPos"]
	if savedBarPos and savedBarPos.x and savedBarPos.y then
	grabBarGui.Position = UDim2.fromOffset(savedBarPos.x, savedBarPos.y)
	else
	grabBarGui.Position = UDim2.new(0.5, -currentW / 2, 0.80, 0)
	end
	grabBarGui.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	grabBarGui.BackgroundTransparency = 0
	grabBarGui.BorderSizePixel = 0
	grabBarGui.ZIndex = 500
	grabBarGui.Active = true
	grabBarGui.Draggable = false
	grabBarGui.Visible = toggleStates["Steal Bar"] == true
	grabBarGui.ClipsDescendants = true
	Instance.new("UICorner", grabBarGui).CornerRadius = UDim.new(0, isMobile and 18 or 22)
	local barStrokeInst = Instance.new("UIStroke", grabBarGui)
	barStrokeInst.Color = Color3.fromRGB(0, 0, 0)
	barStrokeInst.Thickness = 0
	barStrokeInst.Transparency = 1
	barStrokeInst.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local outerReliefGradient = Instance.new("UIGradient", grabBarGui)
	outerReliefGradient.Enabled = false
	outerReliefGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(0, 0, 0)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0)),
	})
	outerReliefGradient.Rotation = 90

	local topRow = Instance.new("Frame", grabBarGui)
	topRow.Size = UDim2.new(0, isMobile and 70 or 82, 1, -4)
	topRow.Position = UDim2.new(1, isMobile and -72 or -84, 0, 2)
	topRow.BackgroundTransparency = 1
	topRow.Visible = false
	topRow.ZIndex = 504

	local statsDivider = Instance.new("Frame", topRow)
	statsDivider.Name = "Divider"
	statsDivider.Size = UDim2.new(0, 1, 1, -10)
	statsDivider.Position = UDim2.new(0, 0, 0, 5)
	statsDivider.BorderSizePixel = 0
	statsDivider.BackgroundColor3 = Color3.fromRGB(58, 58, 64)
	statsDivider.BackgroundTransparency = 0.25
	statsDivider.ZIndex = 505

	StatsRightFps = Instance.new("TextLabel", topRow)
	StatsRightFps.Size = UDim2.new(1, -10, 0, 14)
	StatsRightFps.Position = UDim2.new(0, isMobile and 7 or 9, 0, isMobile and 6 or 9)
	StatsRightFps.BackgroundTransparency = 1
	StatsRightFps.TextColor3 = Color3.fromRGB(245, 245, 248)
	StatsRightFps.Font = Enum.Font.GothamBold
	StatsRightFps.TextSize = isMobile and 8 or 9
	StatsRightFps.TextXAlignment = Enum.TextXAlignment.Left
	StatsRightFps.ZIndex = 506
	StatsRightFps.Visible = false

	StatsRightPing = Instance.new("TextLabel", topRow)
	StatsRightPing.Size = UDim2.new(1, -10, 0, 14)
	StatsRightPing.Position = UDim2.new(0, isMobile and 7 or 9, 0, isMobile and 23 or 27)
	StatsRightPing.BackgroundTransparency = 1
	StatsRightPing.TextColor3 = Color3.fromRGB(200, 200, 208)
	StatsRightPing.Font = Enum.Font.GothamBold
	StatsRightPing.TextSize = isMobile and 8 or 9
	StatsRightPing.TextXAlignment = Enum.TextXAlignment.Left
	StatsRightPing.ZIndex = 506
	StatsRightPing.Visible = false

	local percentLabel = Instance.new("TextLabel", topRow)
	percentLabel.Size = UDim2.new(0, 54, 1, 0)
	percentLabel.Position = UDim2.new(1, -84, 0, 0)
	percentLabel.BackgroundTransparency = 1
	percentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	percentLabel.Font = Enum.Font.GothamBold
	percentLabel.TextSize = 11
	percentLabel.TextXAlignment = Enum.TextXAlignment.Right
	percentLabel.ZIndex = 502
	percentLabel.Visible = false

	local resizeBtn = Instance.new("TextButton", grabBarGui)
	resizeBtn.Size = UDim2.new(0, 16, 0, 16)
	resizeBtn.Position = UDim2.new(1, -22, 0, 3)
	resizeBtn.AnchorPoint = Vector2.new(0, 0)
	resizeBtn.BackgroundTransparency = 0.2
	resizeBtn.BackgroundColor3 = Color3.fromRGB(110, 110, 110)
	resizeBtn.TextColor3 = Color3.fromRGB(235, 240, 245)
	resizeBtn.Font = Enum.Font.GothamBold
	resizeBtn.TextSize = 10
	resizeBtn.Text = grabBarExpanded and "-" or "+"
	resizeBtn.Visible = false
	Instance.new("UICorner", resizeBtn).CornerRadius = UDim.new(1,0)
	resizeBtn.ZIndex = 510

	local barBg
	local function applyBarWidth(newW)
	if not newW or tonumber(newW) == nil then
	return
	end

	local ok, _ = pcall(function()
	if grabBarGui and grabBarGui.Size and grabBarGui.Size.Y then
	local yOffset = grabBarGui.Size.Y.Offset or (isMobile and 58 or 72)
	grabBarGui.Size = UDim2.new(0, tonumber(newW), 0, yOffset)
	end
	if barBg and barBg.Size then
	barBg.Size = UDim2.new(1, isMobile and -20 or -24, 0, 8)
	end
	end)
	if ok then
	_G["_CrystalHub_UI_AutoGrabBarSize"] = tonumber(newW)
	pcall(saveConfig)
	end
	end
	if not grabBarExpanded then
	applyBarWidth(partialCollapsedW)
	end

	resizeBtn.MouseButton1Click:Connect(function()
	grabBarExpanded = not grabBarExpanded
	_G["_CrystalHub_UI_AutoGrabExpanded"] = grabBarExpanded
	if grabBarExpanded then
	applyBarWidth(defaultExpandedW)
	resizeBtn.Text = "-"
	else
	applyBarWidth(partialCollapsedW)
	resizeBtn.Text = "+"
	end
	end)

	-- Clean solid black steal bar (no theme art)
	grabBarGui.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	grabBarGui.BackgroundTransparency = 0
	if outerReliefGradient then outerReliefGradient.Enabled = false end
	barStrokeInst.Transparency = 1
	barStrokeInst.Thickness = 0

	-- Icon image on steal bar
	local sLetter = nil
	local sSub = nil
	local leftDivider = nil
	-- Full-bar theme image (red/blue)
	local stealBarIcon = Instance.new("ImageLabel", grabBarGui)
	stealBarIcon.Name = "StealBarIcon"
	stealBarIcon.Size = UDim2.new(1, 0, 1, 0)
	stealBarIcon.Position = UDim2.new(0, 0, 0, 0)
	stealBarIcon.BackgroundTransparency = 1
	stealBarIcon.BorderSizePixel = 0
	stealBarIcon.Image = ""
	stealBarIcon.Visible = false
	stealBarIcon.ScaleType = Enum.ScaleType.Crop
	stealBarIcon.ImageTransparency = 1
	stealBarIcon.ZIndex = 501
	stealBarIcon.ClipsDescendants = true
	Instance.new("UICorner", stealBarIcon).CornerRadius = UDim.new(0, isMobile and 18 or 22)

	local leftAccent = nil

	-- Hidden mode switch (click percent to cycle V1/V2 still via modePill)
	local modePill = Instance.new("TextButton", grabBarGui)
	modePill.Size = UDim2.new(0, 1, 0, 1)
	modePill.Position = UDim2.new(0, 0, 0, 0)
	modePill.BackgroundTransparency = 1
	modePill.Text = "V1"
	modePill.TextTransparency = 1
	modePill.ZIndex = 1
	modePill.AutoButtonColor = false
	modePill.Visible = false

	local autoGrabTitle = Instance.new("TextLabel", grabBarGui)
	autoGrabTitle.Size = UDim2.new(0, 0, 0, 0)
	autoGrabTitle.BackgroundTransparency = 1
	autoGrabTitle.Text = ""
	autoGrabTitle.Visible = false
	autoGrabTitle.ZIndex = 1

	-- Percent LEFT (like reference)
	local percentLabel = Instance.new("TextLabel", grabBarGui)
	percentLabel.Size = UDim2.new(0, isMobile and 52 or 64, 0, isMobile and 18 or 20)
	percentLabel.Position = UDim2.new(0, isMobile and 14 or 18, 0, isMobile and 8 or 10)
	percentLabel.BackgroundTransparency = 1
	percentLabel.Text = "0%"
	percentLabel.Font = Enum.Font.GothamBold
	percentLabel.TextSize = isMobile and 13 or 15
	percentLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	percentLabel.TextXAlignment = Enum.TextXAlignment.Left
	percentLabel.ZIndex = 506

	-- FPS + PING combined on the RIGHT
	local barFpsLabel = Instance.new("TextLabel", grabBarGui)
	barFpsLabel.Name = "BarFps"
	barFpsLabel.Size = UDim2.new(0, isMobile and 120 or 150, 0, isMobile and 18 or 20)
	barFpsLabel.Position = UDim2.new(1, isMobile and -134 or -168, 0, isMobile and 8 or 10)
	barFpsLabel.BackgroundTransparency = 1
	barFpsLabel.Text = "FPS --  PING --ms"
	barFpsLabel.Font = Enum.Font.GothamBold
	barFpsLabel.TextSize = isMobile and 11 or 13
	barFpsLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	barFpsLabel.TextXAlignment = Enum.TextXAlignment.Right
	barFpsLabel.ZIndex = 506

	local barPingLabel = Instance.new("TextLabel", grabBarGui)
	barPingLabel.Name = "BarPing"
	barPingLabel.Size = UDim2.new(0, 0, 0, 0)
	barPingLabel.BackgroundTransparency = 1
	barPingLabel.Text = ""
	barPingLabel.Visible = false
	barPingLabel.ZIndex = 1

	StatsRightFps = barFpsLabel
	StatsRightPing = barPingLabel
	StatsRightFps.Visible = true

	-- FPS/PING on steal bar is driven by the global counter via StatsRightFps

	-- Progress track (bottom, pill)
	barBg = Instance.new("Frame", grabBarGui)
	barBg.Size = UDim2.new(1, isMobile and -28 or -36, 0, isMobile and 10 or 12)
	barBg.Position = UDim2.new(0, isMobile and 14 or 18, 1, isMobile and -20 or -24)
	barBg.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
	barBg.BorderSizePixel = 0
	barBg.ZIndex = 504
	Instance.new("UICorner", barBg).CornerRadius = UDim.new(1, 0)
	local barTrackStroke = Instance.new("UIStroke", barBg)
	barTrackStroke.Transparency = 1

	local barFill = Instance.new("Frame", barBg)
	barFill.Size = UDim2.new(0, 0, 1, 0)
	barFill.Position = UDim2.new(0, 0, 0, 0)
	barFill.BorderSizePixel = 0
	barFill.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	barFill.ClipsDescendants = true
	barFill.ZIndex = 505
	Instance.new("UICorner", barFill).CornerRadius = UDim.new(1, 0)
	local fillGradient = Instance.new("UIGradient", barFill)
	-- White tracking shine: it is vertically centered and follows the live
	-- progress edge at exactly the same speed, while staying inside the frame.
	local fillGlow = Instance.new("Frame")
	fillGlow.Name = "ProgressInsetGlow"
	fillGlow.Size = UDim2.new(0, isMobile and 54 or 72, 1, -2)
	fillGlow.AnchorPoint = Vector2.new(0.5, 0.5)
	fillGlow.Position = UDim2.new(1, isMobile and -39 or -52, 0.5, 0)
	fillGlow.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	fillGlow.BackgroundTransparency = 0.25
	fillGlow.BorderSizePixel = 0
	fillGlow.ZIndex = 505
	fillGlow.Parent = barFill
	Instance.new("UICorner", fillGlow).CornerRadius = UDim.new(1, 0)
	local glowStroke = Instance.new("UIStroke")
	glowStroke.Color = Color3.fromRGB(255, 255, 255)
	glowStroke.Thickness = isMobile and 2 or 3
	glowStroke.Transparency = 0.42
	glowStroke.Parent = fillGlow
	local glowGradient = Instance.new("UIGradient")
	glowGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.52, 0.02),
		NumberSequenceKeypoint.new(1, 1),
	})
	glowGradient.Parent = fillGlow
	local fillShine = Instance.new("Frame")
	fillShine.Name = "ProgressInsetShine"
	fillShine.Size = UDim2.new(0, isMobile and 32 or 42, 1, -4)
	fillShine.AnchorPoint = Vector2.new(0.5, 0.5)
	fillShine.Position = UDim2.new(1, isMobile and -28 or -37, 0.5, 0)
	fillShine.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	fillShine.BackgroundTransparency = 0.06
	fillShine.BorderSizePixel = 0
	fillShine.ZIndex = 506
	fillShine.Parent = barFill
	Instance.new("UICorner", fillShine).CornerRadius = UDim.new(1, 0)
	local shineGradient = Instance.new("UIGradient")
	shineGradient.Rotation = 0
	shineGradient.Transparency = NumberSequence.new({
		NumberSequenceKeypoint.new(0, 1),
		NumberSequenceKeypoint.new(0.42, 0.05),
		NumberSequenceKeypoint.new(1, 1),
	})
	shineGradient.Parent = fillShine
	task.spawn(function()
		while fillGlow.Parent and fillShine.Parent do
			local glowIn = TweenService:Create(fillGlow, TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0.02})
			local shineIn = TweenService:Create(fillShine, TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {BackgroundTransparency = 0})
			glowIn:Play(); shineIn:Play(); glowIn.Completed:Wait()
			if not fillGlow.Parent or not fillShine.Parent then break end
			local glowOut = TweenService:Create(fillGlow, TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0.32})
			local shineOut = TweenService:Create(fillShine, TweenInfo.new(0.55, Enum.EasingStyle.Sine, Enum.EasingDirection.In), {BackgroundTransparency = 0.16})
			glowOut:Play(); shineOut:Play(); glowOut.Completed:Wait()
		end
	end)

	local barThemeColor = Color3.fromRGB(255, 150, 60)
	local function resolveAutoStealAccent()
		if typeof(_G.__CrystalCurtAccent) == "Color3" then return _G.__CrystalCurtAccent end
		if typeof(_G.__CrystalThemeAccent) == "Color3" then return _G.__CrystalThemeAccent end
		local index = tonumber(_G["_CrystalHub_UI_BgIndex"]) or 1
		if index == 1 then return Color3.fromRGB(255, 176, 90) end
		if index == 2 then return Color3.fromRGB(255, 120, 25) end
		if index == 3 then return Color3.fromRGB(245, 245, 250) end
		if index == 4 then return Color3.fromRGB(255, 255, 255) end
		if index == 5 then return Color3.fromRGB(255, 150, 50) end
		if index == 6 then return Color3.fromRGB(255, 110, 20) end
		return Color3.fromRGB(255, 176, 90)
	end
	-- Top status bar removed
	pcall(function()
		for _, name in ipairs({"VyloTopStatus", "VyroTopStatus", "KYejuTopStatus"}) do
			local old = ScreenGui:FindFirstChild(name)
			if old then old:Destroy() end
		end
	end)
	local topHud, topImage, topStroke, topBrand, topOwner, topDivider = nil, nil, nil, nil, nil, nil
	local function applyKYejuTopHudTheme(themeName) end
	_G.__CrystalApplyKYejuTopHudTheme = applyKYejuTopHudTheme
	_G.__CrystalSetStatusBarVisible = function() end


	local function applyAutoStealBarTheme(themeName)
		barThemeColor = resolveAutoStealAccent()
		-- solid black bar, no artwork
		grabBarGui.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		grabBarGui.BackgroundTransparency = 0
		if outerReliefGradient then outerReliefGradient.Enabled = false end
		barStrokeInst.Transparency = 1
		if stealBarIcon then
			stealBarIcon.Image = ""
			stealBarIcon.Visible = false
		end
		-- progress fill uses theme accent
		fillGradient.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, barThemeColor:Lerp(Color3.fromRGB(255, 255, 255), 0.35)),
			ColorSequenceKeypoint.new(0.5, barThemeColor),
			ColorSequenceKeypoint.new(1, barThemeColor:Lerp(Color3.fromRGB(0, 0, 0), 0.15)),
		})
		barFill.BackgroundColor3 = barThemeColor
		if barBg then barBg.BackgroundColor3 = Color3.fromRGB(28, 28, 32) end
		-- text uses theme accent
		if percentLabel then percentLabel.TextColor3 = barThemeColor end
		if barFpsLabel then barFpsLabel.TextColor3 = barThemeColor end
		if StatsRightFps then StatsRightFps.TextColor3 = barThemeColor end
		if StatsRightPing then StatsRightPing.TextColor3 = barThemeColor end
		if sLetter then sLetter.TextColor3 = barThemeColor end
		if sSub then sSub.TextColor3 = barThemeColor end
		if leftDivider then leftDivider.BackgroundColor3 = barThemeColor end
		if leftAccent then leftAccent.BackgroundColor3 = barThemeColor end
		if statsDivider then statsDivider.BackgroundColor3 = Color3.fromRGB(40, 40, 44) end
		if type(_G.__CrystalApplyKYejuTopHudTheme) == "function" then
			pcall(_G.__CrystalApplyKYejuTopHudTheme, themeName)
		end
		do
			local idx = tonumber(themeName) or tonumber(_G["_CrystalHub_UI_BgIndex"]) or 1
			if type(_G.__CrystalSetStealBarParticles) == "function" then
				pcall(_G.__CrystalSetStealBarParticles, idx == 2, idx)
			elseif type(setThemeParticles) == "function" then
				pcall(setThemeParticles, idx == 2, idx)
			end
		end
	end

	-- Pink particles ONLY when pink theme (bgIndex == 2)
	local particleLayer = Instance.new("Frame", grabBarGui)
	particleLayer.Name = "ThemeParticles"
	particleLayer.Size = UDim2.new(1, 0, 1, 0)
	particleLayer.BackgroundTransparency = 1
	particleLayer.ZIndex = 520
	particleLayer.ClipsDescendants = true
	particleLayer.Visible = false
	local particlesOn = false
	local particleConn = nil
	local spawnAcc = 0

	local function clearParticles()
		for _, ch in ipairs(particleLayer:GetChildren()) do
			pcall(function() ch:Destroy() end)
		end
	end

	local function stopParticles()
		particlesOn = false
		particleLayer.Visible = false
		if particleConn then
			pcall(function() particleConn:Disconnect() end)
			particleConn = nil
		end
		clearParticles()
	end

	local function startPinkParticles()
		if particlesOn and particleConn then
			particleLayer.Visible = true
			return
		end
		stopParticles()
		particlesOn = true
		particleLayer.Visible = true
		spawnAcc = 0
		particleConn = RunService.Heartbeat:Connect(function(dt)
			if not particlesOn then return end
			if not grabBarGui.Parent or grabBarGui.Visible == false then return end
			spawnAcc = spawnAcc + (dt or 0)
			local barW = math.max(1, grabBarGui.AbsoluteSize.X)
			local barH = math.max(1, grabBarGui.AbsoluteSize.Y)
			while spawnAcc >= 0.055 do
				spawnAcc = spawnAcc - 0.055
				if #particleLayer:GetChildren() >= 36 then break end
				local p = Instance.new("Frame")
				local sz = math.random(3, 6)
				p.Size = UDim2.fromOffset(sz, sz)
				p.Position = UDim2.fromOffset(math.random(0, math.floor(barW)), -sz)
				p.BackgroundColor3 = Color3.fromRGB(255, math.random(80, 170), math.random(180, 240))
				p.BackgroundTransparency = math.random(5, 25) / 100
				p.BorderSizePixel = 0
				p.ZIndex = 521
				Instance.new("UICorner", p).CornerRadius = UDim.new(1, 0)
				p.Parent = particleLayer
				local speed = math.random(32, 62)
				local drift = math.random(-14, 14)
				local life = 0
				-- fade out near the bottom of the bar (not at the hard UI edge)
				local fadeStart = math.max(8, barH * 0.55)
				local fadeEnd = math.max(fadeStart + 6, barH * 0.92)
				local pConn
				pConn = RunService.Heartbeat:Connect(function(pdt)
					if not p.Parent then
						if pConn then pConn:Disconnect() end
						return
					end
					life = life + (pdt or 0)
					local y = life * speed
					local x = p.Position.X.Offset + drift * (pdt or 0)
					p.Position = UDim2.fromOffset(x, y - sz)
					local baseT = 0.08
					if y >= fadeEnd then
						if pConn then pConn:Disconnect() end
						p:Destroy()
						return
					elseif y >= fadeStart then
						local fadeT = (y - fadeStart) / math.max(1, fadeEnd - fadeStart)
						p.BackgroundTransparency = math.clamp(baseT + fadeT * 0.92, 0, 1)
					else
						p.BackgroundTransparency = baseT
					end
				end)
			end
		end)
		_G.__CrystalTrackConn(particleConn)
	end

	local function setThemeParticles(enabled, index)
		stopParticles()
	end

	local function setPinkParticles(enabled)
		local idx = tonumber(_G["_CrystalHub_UI_BgIndex"]) or 1
		setThemeParticles(idx == 2, idx)
	end

	_G.__CrystalApplyAutoStealBarTheme = applyAutoStealBarTheme
	_G.__CrystalSetStealBarParticles = setThemeParticles
	applyAutoStealBarTheme(_G.__CrystalGuiTheme or "GUI 1")
	do
		local idx = tonumber(_G["_CrystalHub_UI_BgIndex"]) or 1
		setThemeParticles(idx == 2, idx)
	end

	-- Keep aliases used by the update loop
	local barLabel = autoGrabTitle
	local statusLabel = autoGrabTitle
	local barPercentLabel = percentLabel
	local autoGrabModeLabels = { v1 = "V1", v2 = "V2" }
	local function autoGrabModeName(mode)
		return autoGrabModeLabels[mode] or "V1"
	end
	local titleLabel = modePill
	titleLabel.Text = autoGrabModeName(autoStealMode)
	local function refreshModePill()
		modePill.Text = string.upper(tostring(autoStealMode or "v1"))
	end
	refreshModePill()

	local function switchAutoStealVersion()
		autoStealMode = (autoStealMode == "v2") and "v1" or "v2"
		refreshModePill()
		-- restart auto steal if running so version applies
		if toggleStates["auto steal"] and FeaturePostToggle["auto steal"] then
			pcall(FeaturePostToggle["auto steal"], false)
			pcall(FeaturePostToggle["auto steal"], true)
		end
		if _G.CrystalAutoGrab and _G.CrystalAutoGrab.SetMode then
			pcall(_G.CrystalAutoGrab.SetMode, autoStealMode)
		end
		-- sync main UI button text
		if type(_G.__CrystalRefreshAutoStealModeUI) == "function" then
			pcall(_G.__CrystalRefreshAutoStealModeUI, autoStealMode)
		end
		saveConfig()
		return autoStealMode
	end
	_G.__CrystalSwitchAutoStealVersion = switchAutoStealVersion
	_G.__CrystalRefreshStealBarModePill = refreshModePill

	modePill.MouseButton1Click:Connect(function()
		switchAutoStealVersion()
	end)

	local _barDragging = false
	local _barDragStart = nil
	local _barDragInput = nil
	_G.__CrystalGuiPositionResetters.AutoGrab = function()
	_barDragging = false
	_barDragStart = nil
	_barDragInput = nil
	grabBarGui.AnchorPoint = Vector2.new(0, 0)
	grabBarGui.Position = UDim2.new(0.5, -currentW / 2, 0.80, 0)
	_G["_CrystalHub_UI_AutoGrabBarPos"] = nil
	end
	grabBarGui.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
	_barDragging = true
	_barDragStart = { pointer = inp.Position, position = grabBarGui.AbsolutePosition }
	if inp.UserInputType == Enum.UserInputType.Touch then _barDragInput = inp end
	end
	end)
	grabBarGui.InputChanged:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
	_barDragInput = inp
	end
	end)
	_G.__CrystalTrackConn(UserInputService.InputChanged:Connect((function(inp)
	if not _barDragging or not _barDragStart or inp ~= _barDragInput then return end
	if inp.UserInputType ~= Enum.UserInputType.MouseMovement and inp.UserInputType ~= Enum.UserInputType.Touch then return end
	local delta = inp.Position - _barDragStart.pointer
	local nextX = _barDragStart.position.X + delta.X
	local nextY = _barDragStart.position.Y + delta.Y
	grabBarGui.Position = UDim2.fromOffset(nextX, nextY)
	end)))
	_G.__CrystalTrackConn(UserInputService.InputEnded:Connect(function(inp)
	if _barDragging and (inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch) then
	_barDragging = false
	local absPos = grabBarGui.AbsolutePosition
	grabBarGui.AnchorPoint = Vector2.new(0, 0)
	grabBarGui.Position = UDim2.fromOffset(absPos.X, absPos.Y)
	_G["_CrystalHub_UI_AutoGrabBarPos"] = { x = absPos.X, y = absPos.Y }
	_barDragStart = nil
	_barDragInput = nil
	saveConfig()
	end
	end))

	local grabBarState = {
	displayProgress = 0,
	radiusProgress = 0,
	targetInRadius = false,
	radiusCheckElapsed = 0,
	uiElapsed = 0,
	lastVisible = nil,
	lastPercent = nil,
	lastActive = nil,
	lastMode = nil,
	}
	FeaturePostToggle["Steal Bar"] = function(active)
		local visible = active == true
		grabBarGui.Visible = visible
		grabBarState.lastVisible = visible
	end
	_G.__CrystalTrackConn(RunService.Heartbeat:Connect((function(dt)

	grabBarState.uiElapsed = grabBarState.uiElapsed + (dt or 0)
	if grabBarState.uiElapsed < (1 / 20) then return end
	dt = grabBarState.uiElapsed
	grabBarState.uiElapsed = 0
	if grabBarState.lastMode ~= autoStealMode then
	grabBarState.lastMode = autoStealMode
	if modePill then modePill.Text = autoGrabModeName(autoStealMode) end
	end

	if toggleStates["Steal Bar"] ~= true then
	if grabBarState.lastVisible ~= false then
	grabBarGui.Visible = false
	grabBarState.lastVisible = false
	end
	return
	end

	grabBarState.radiusCheckElapsed = grabBarState.radiusCheckElapsed + (dt or 0)
	local ragdollBlocked = _G.__CrystalAutoGrabRagdollBlocked == true
	if ragdollBlocked then
	grabBarState.targetInRadius = false
	grabBarState.radiusProgress = 0
	end
	if grabBarState.radiusCheckElapsed >= 0.25 then
	grabBarState.radiusCheckElapsed = 0
	grabBarState.targetInRadius = false
	local autoGrabBusy = (StealState and StealState.active)
		or (V2 and V2.busy) or (V3New and V3New.busy)
		or (V2Grab and V2Grab.busy)

	if not ragdollBlocked and not autoGrabBusy and toggleStates["auto steal"] == true and _G.__CrystalAutoGrabTargetInRadius then
	local activeRadius = math.clamp(tonumber(autoStealValues.Radius) or 65, 10, 150)
	local ok, inRange = pcall(_G.__CrystalAutoGrabTargetInRadius, activeRadius)
	grabBarState.targetInRadius = ok and inRange == true
	end
	end

	local actualProgress = ragdollBlocked and 0 or math.clamp(v1Progress or 0, 0, 1)
	if grabBarState.targetInRadius then
	if actualProgress > 0 then
	grabBarState.radiusProgress = actualProgress
	else
	local fillDuration = math.max(0.1, tonumber(autoStealValues.Duration) or 1.3)
	grabBarState.radiusProgress = grabBarState.radiusProgress + (dt or 0) / fillDuration
	if grabBarState.radiusProgress >= 1 then grabBarState.radiusProgress = 0 end
	end
	else
	grabBarState.radiusProgress = 0
	end

	local progress = math.max(actualProgress, grabBarState.radiusProgress)
	local totalW = barBg.AbsoluteSize.X
	if totalW <= 0 then totalW = grabBarGui.AbsoluteSize.X - (isMobile and 76 or 88) end
	if totalW <= 0 then totalW = isMobile and 192 or 222 end
	local targetW = math.clamp(progress * totalW, 0, totalW)
	local currentW = grabBarState.displayProgress * totalW
	local lerpSpeed = progress > grabBarState.displayProgress and 18 or 22
	currentW = currentW + (targetW - currentW) * math.min(lerpSpeed * dt, 1)
	if math.abs(currentW - targetW) < 0.5 then currentW = targetW end
	grabBarState.displayProgress = totalW > 0 and math.clamp(currentW / totalW, 0, 1) or 0
	barFill.Size = UDim2.new(0, currentW, 1, 0)

	local shouldShowGrab = toggleStates["Steal Bar"] == true
	if shouldShowGrab ~= grabBarState.lastVisible then
	grabBarGui.Visible = shouldShowGrab
	grabBarState.lastVisible = shouldShowGrab
	end

	do
	local pct = math.floor(progress * 100)
	pct = math.clamp(pct, 0, 100)
	if pct ~= grabBarState.lastPercent then
	percentLabel.Text = tostring(pct) .. "%"
	if barPercentLabel then barPercentLabel.Text = tostring(pct) .. "%" end
	grabBarState.lastPercent = pct
	end
	end
	local grabIsActive = progress > 0
	if grabIsActive and grabBarState.lastActive ~= true then
	barFill.BackgroundColor3 = barThemeColor
	barStrokeInst.Color = barThemeColor:Lerp(Color3.fromRGB(255, 255, 255), 0.12)
	barStrokeInst.Transparency = 0.12
	titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
	end
	grabBarState.lastActive = grabIsActive
	end)))
	end

	local visualSection = makeUraniumSection(tabPages.Visuals, "VISUALS")
	makeToggleNoKeybind(visualSection, "anti lag", "Anti Lag")
	_G.__visualSection = visualSection

	makeToggleNoKeybind(visualSection, "ESP Players", "ESP Players")
	makeToggleNoKeybind(visualSection, "Player Tracers", "Player Tracers")

	local optimizerMode = "Ultra"
	local optimizerModeRefreshers = {}
	local applySky
	local skyCurrentMode
	local function refreshOptimizerModeUI()
	for _, refresh in ipairs(optimizerModeRefreshers) do pcall(refresh, optimizerMode) end
	end
	local function setOptimizerMode(mode)
	if mode ~= "Normal" and mode ~= "Ultra" then mode = "Normal" end
	optimizerMode = mode
	_G.__optimizerMode = mode
	refreshOptimizerModeUI()
	pcall(saveConfig)
	if toggleStates["Optimizer"] and FeaturePostToggle["Optimizer"] then
	FeaturePostToggle["Optimizer"](false)
	FeaturePostToggle["Optimizer"](true)
	end
	end
	if _G.__optimizerMode == "Normal" or _G.__optimizerMode == "Ultra" then
	optimizerMode = _G.__optimizerMode
	else
	_G.__optimizerMode = optimizerMode
	end

	do
	local optimizerRow = makeToggleNoKeybind(visualSection, "Optimizer", "Optimizer")
	local optimizerCard = nil
	for _, child in ipairs(optimizerRow:GetChildren()) do
	if child:IsA("TextButton") then optimizerCard = child; break end
	end
	if optimizerCard then
	local modeBtn = Instance.new("TextButton", optimizerCard)
	modeBtn.Size = UDim2.new(0, 66, 0, 20)
	modeBtn.Position = UDim2.new(1, -74, 0.5, -10)
	modeBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
	modeBtn.BorderSizePixel = 0
	modeBtn.TextColor3 = Color3.fromRGB(225, 238, 255)
	modeBtn.TextSize = 10
	modeBtn.Font = Enum.Font.GothamBold
	modeBtn.AutoButtonColor = false
	modeBtn.ZIndex = 10
	Instance.new("UICorner", modeBtn).CornerRadius = UDim.new(0, 4)
	local modeStroke = Instance.new("UIStroke", modeBtn)
	modeStroke.Color = Color3.fromRGB(255, 255, 255)
	modeStroke.Thickness = 1
	modeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local function refreshMode() modeBtn.Text = string.upper(optimizerMode) end
	table.insert(optimizerModeRefreshers, refreshMode)
	connectBtn(modeBtn, function()
	setOptimizerMode(optimizerMode == "Normal" and "Ultra" or "Normal")
	refreshMode()
	end)
	refreshMode()
	end
	end

	do
	local optimizerActive = false
	local optimizerConn = nil
	local optimizerLightingConn = nil
	local optimizerCharConn = nil
	local optimizerWalkCancel = nil
	local defLightBrightness, defLightClock, defLightAmbient
	local removeAccessoriesEnabled = false
	local lowHarshUntil = 0
	local lowFlagGeneration = 0
	local optimizerUltraOriginals = {}

	local function rememberUltraState(obj, state)
	if optimizerUltraOriginals[obj] == nil then optimizerUltraOriginals[obj] = state end
	end

	local function restoreUltraState()
	for obj, original in pairs(optimizerUltraOriginals) do
	pcall(function()
	if original.Parent ~= nil and obj.Parent == nil and original.Parent.Parent ~= nil then
	obj.Parent = original.Parent
	end
	if obj.Parent ~= nil then
	if original.Material ~= nil then obj.Material = original.Material end
	if original.Reflectance ~= nil then obj.Reflectance = original.Reflectance end
	if original.CastShadow ~= nil then obj.CastShadow = original.CastShadow end
	if original.Transparency ~= nil then obj.Transparency = original.Transparency end
	if original.Enabled ~= nil then obj.Enabled = original.Enabled end
	end
	end)
	end
	optimizerUltraOriginals = {}
	end

	local lowFlags = {
	{"DFIntClusterSenderMaxJoinBandwidthBps", "2100000000"},
	{"DFIntClusterSenderMaxUpdateBandwidthBps", "2100000000"},
	{"DFIntServerFramesBetweenJoins", "1"},
	{"DFIntRaknetBandwidthInfluxHundredthsPercentageV2", "10000"},
	{"DFIntConnectionMTUSize", "1400"},
	{"FIntRakNetResendBufferArrayLength", "1024"},
	{"DFIntRakNetNakResendDelayMsMax", "1"},
	{"DFIntWaitOnUpdateNetworkLoopEndedMS", "100"},
	{"DFIntWaitOnRecvFromLoopEndedMS", "100"},
	{"DFIntLargePacketQueueSizeCutoffMB", "1000"},
	{"DFIntSendRakNetStatsInterval", "2147483647"},
	{"DFIntRakNetLoopMs", "1"},
	{"DFIntRakNetSelectTimeoutMs", "1"},
	{"DFIntNetworkClusterPacketCacheNumParallelTasks", "8"},
	{"DFIntReplicationDataCacheNumParallelTasks", "8"},
	{"DFIntMegaReplicatorNumParallelTasks", "16"},
	{"DFIntMegaReplicatorNetworkQualityProcessorUnit", "10"},
	{"DFIntMaxProcessPacketsStepsPerCyclic", "512"},
	{"DFIntMaxProcessPacketsStepsAccumulated", "0"},
	{"DFIntMaxProcessPacketsJobScaling", "1000"},
	{"DFIntClientPacketMaxFrameMicroseconds", "200000"},
	{"DFIntClientPacketExcessMicroseconds", "10000"},
	{"DFIntClientPacketMinMicroseconds", "1"},
	{"DFIntClientPacketMaxDelayMs", "1"},
	{"DFIntMaxWaitTimeBeforeForcePacketProcessMS", "1"},
	{"DFIntMaxFrameBufferSize", "4"},
	{"DFIntBufferCompressionThreshold", "100"},
	{"DFIntOverrideISRReplicatorStepBandwidthBytes", "131072"},
	{"DFIntTaskSchedulerJobInitThreads", "8"},
	{"DFIntTaskSchedulerJobInGameThreads", "8"},
	{"FIntTaskSchedulerAutoThreadLimit", "16"},
	{"FIntTaskSchedulerAsyncTasksMinimumThreadCount", "4"},
	{"DFIntRuntimeConcurrency", "16"},
	{"FIntSimWorldTaskQueueParallelTasks", "20"},
	{"DFIntHttpBatchLimit", "256"},
	{"FIntHttpBatchLimit", "256"},
	{"DFIntHttpCurlConnectionCacheSize", "512"},
	{"FIntDefaultMeshCacheSizeMB", "512"},
	{"DFIntMemCacheMaxCapacityMB", "256"},
	{"DFIntNumAssetsMaxToPreload", "1"},
	{"DFFlagEnableSoundPreloading", "false"},
	{"FFlagSlimContentProvider", "true"},
	{"DFFlagDebugSkipMeshVoxelizer", "true"},
	{"DFFlagTextureQualityOverrideEnabled", "true"},
	{"DFIntTextureQualityOverride", "0"},
	{"FIntDebugTextureManagerSkipMips", "7"},
	{"DFIntDebugLimitMinTextureResolutionWhenSkipMips", "8"},
	{"FFlagTM2SkipMipsForUnstreamable2", "true"},
	{"DFFlagDoNotSkipMipsBasedOnSystemMemoryPS", "true"},
	{"FFlagRenderUseTextureManager224", "false"},
	{"DFIntDebugFRMQualityLevelOverride", "1"},
	{"DFFlagDebugPauseVoxelizer", "true"},
	{"FFlagFastGPULightCulling3", "true"},
	{"FIntRenderLocalLightFadeInMs", "0"},
	{"FIntRenderLocalLightUpdatesMax", "1"},
	{"FIntRenderShadowmapBias", "0"},
	{"FIntSSAOMipLevels", "0"},
	{"FIntDebugForceMSAASamples", "1"},
	{"FIntDebugFRMOptionalMSAALevelOverride", "0"},
	{"FIntRobloxGuiBlurIntensity", "0"},
	{"FIntFRMMinGrassDistance", "0"},
	{"FIntFRMMaxGrassDistance", "0"},
	{"DFFlagCoreScriptTelemetry2", "false"},
	{"DFFlagBrowserTrackerIdTelemetryEnabled", "false"},
	{"FFlagPerfDataOnTelemetryV2", "false"},
	{"FFlagSendRenderFidelityTelemetry2", "false"},
	{"FFlagEnableTelemetryServiceMemoryCPUInfo", "false"},
	{"DFIntTelemetryProfilerHundredthsPercentage", "0"},
	{"FIntTelemetryProfilerFrequency", "0"},
	{"FIntPerformanceTelemetryQueueProcessLimit", "0"},
	{"DFIntContentProviderPreloadHangTelemetryHundredthsPercentage", "0"},
	}

	local function applyLowFlags()
	local env = (getgenv and getgenv()) or _G
	local setter = rawget(env, "setfflag") or rawget(_G, "set_fflag")
	local getter = rawget(env, "getfflag") or rawget(_G, "get_fflag")
	if type(setter) ~= "function" then return end
	for _, flag in ipairs(lowFlags) do
	local canSet = true
	if type(getter) == "function" then
	local ok, current = pcall(getter, flag[1])
	canSet = ok and current ~= nil
	end
	if canSet then pcall(setter, flag[1], tostring(flag[2])) end
	end
	end

	local function applyLowPermanentSettings()
	pcall(function() settings().Rendering.QualityLevel = Enum.QualityLevel.Level01 end)
	pcall(function()
	UserSettings():GetService("UserGameSettings").SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
	end)
	pcall(function()
	Lighting.GlobalShadows = false
	Lighting.EnvironmentDiffuseScale = 0
	Lighting.EnvironmentSpecularScale = 0
	end)
	pcall(function()
	local atmosphere = Lighting:FindFirstChildOfClass("Atmosphere")
	if atmosphere then
	atmosphere.Density = 0
	atmosphere.Glare = 0
	atmosphere.Haze = 0
	end
	end)
	pcall(function()
	local terrain = workspace:FindFirstChildOfClass("Terrain")
	if terrain then
	terrain.Decoration = false
	terrain.WaterWaveSize = 0
	terrain.WaterWaveSpeed = 0
	terrain.WaterReflectance = 0
	local clouds = terrain:FindFirstChildOfClass("Clouds")
	if clouds then clouds.Enabled = false end
	end
	end)
	end

	local applyOptimizerDerender = (function(obj)
	pcall(function()
	if _G.__CrystalPreserveOptimizerUI(obj) then return end
	if optimizerMode ~= "Ultra" then
	if obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Smoke")
	or obj:IsA("Fire") or obj:IsA("Sparkles") or obj:IsA("PostEffect") then
	obj.Enabled = false
	end
	if tick() <= lowHarshUntil then
	if obj:IsA("Decal") or obj:IsA("Texture") then
	obj.Transparency = 1
	end
	end
	return
	end
	local objName = obj.Name or ""
	local parentName = (obj.Parent and obj.Parent.Name) or ""
	local grandParentName = (obj.Parent and obj.Parent.Parent and obj.Parent.Parent.Name) or ""
	if obj:IsA("Accessory") or obj:IsA("Hat") or obj:IsA("Clothing")
	or obj:IsA("Shirt") or obj:IsA("Pants") or obj:IsA("ShirtGraphic") then
	rememberUltraState(obj, {Parent = obj.Parent})
	obj.Parent = nil
	elseif obj:IsA("BasePart") then
	rememberUltraState(obj, {
	Material = obj.Material,
	Reflectance = obj.Reflectance,
	CastShadow = obj.CastShadow,
	})
	obj.Material = Enum.Material.Plastic
	obj.Reflectance = 0
	obj.CastShadow = false
	elseif obj:IsA("Decal") or obj:IsA("Texture") then
	rememberUltraState(obj, {Transparency = obj.Transparency})
	obj.Transparency = 1
	elseif obj:IsA("ParticleEmitter") or obj:IsA("Trail") or obj:IsA("Beam")
	or obj:IsA("Fire") or obj:IsA("Smoke") or obj:IsA("Sparkles") then
	rememberUltraState(obj, {Enabled = obj.Enabled})
	obj.Enabled = false
	elseif obj:IsA("AnimationController") or obj:IsA("Animator") then
	for _, track in ipairs(obj:GetPlayingAnimationTracks()) do
	pcall(function() track:Stop(0) end)
	end
	end
	end)
	end)

	local processAllDescendants = (function()
	local roots = optimizerMode == "Ultra" and {workspace} or {workspace, Lighting}
	if optimizerWalkCancel then optimizerWalkCancel() end
	optimizerWalkCancel = _G.__CrystalWalkDescendantsBatched(roots, applyOptimizerDerender, function()
	return optimizerActive
	end)
	end)

	local function applyOptimizerLighting()
	defLightBrightness = defLightBrightness or Lighting.Brightness
	defLightClock = defLightClock or Lighting.ClockTime
	defLightAmbient = defLightAmbient or Lighting.OutdoorAmbient
	if optimizerMode ~= "Ultra" then
	applyLowPermanentSettings()
	return
	end
	Lighting.GlobalShadows = false
	Lighting.FogEnd = 1e10
	Lighting.Brightness = 1
	Lighting.EnvironmentDiffuseScale = 0
	Lighting.EnvironmentSpecularScale = 0
	for _, effect in ipairs(Lighting:GetChildren()) do
	pcall(function()
	if effect:IsA("BlurEffect") or effect:IsA("SunRaysEffect")
	or effect:IsA("ColorCorrectionEffect") or effect:IsA("BloomEffect")
	or effect:IsA("DepthOfFieldEffect") then effect.Enabled = false end
	end)
	end
	end

	local function resetOptimizerLighting()
	pcall(function()
	if defLightBrightness then Lighting.Brightness = defLightBrightness end
	if defLightClock then Lighting.ClockTime = defLightClock end
	if defLightAmbient then Lighting.OutdoorAmbient = defLightAmbient end
	Lighting.ExposureCompensation = 0
	Lighting.GlobalShadows = true
	Lighting.FogEnd = 100000
	Lighting.EnvironmentDiffuseScale = 1
	Lighting.EnvironmentSpecularScale = 1
	end)
	end

	FeaturePostToggle["Optimizer"] = function(active)
	if active then
	if optimizerActive then return end

	removeAccessoriesEnabled = true
	optimizerActive = true
	if optimizerMode ~= "Ultra" then
	lowHarshUntil = tick() + 1
	lowFlagGeneration = lowFlagGeneration + 1
	local generation = lowFlagGeneration
	applyLowFlags()
	for _, delaySeconds in ipairs({2, 6, 12, 20}) do
	task.delay(delaySeconds, function()
	if optimizerActive and optimizerMode ~= "Ultra" and generation == lowFlagGeneration then
	applyLowFlags()
	end
	end)
	end
	pcall(function() game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen() end)
	end
	applyOptimizerLighting()
	if toggleStates["Sky Changer"] then
	applySky(skyCurrentMode)
	end
	processAllDescendants()

	if optimizerConn then optimizerConn:Disconnect() end
optimizerConn = workspace.DescendantAdded:Connect(function(obj)
if removeAccessoriesEnabled then
applyOptimizerDerender(obj)
end
end)
	if optimizerLightingConn then optimizerLightingConn:Disconnect() end
	optimizerLightingConn = Lighting.DescendantAdded:Connect(function(obj)
	if removeAccessoriesEnabled then applyOptimizerDerender(obj) end
	end)

	if optimizerCharConn then optimizerCharConn:Disconnect() end
	optimizerCharConn = Player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	_G.__CrystalWalkDescendantsBatched(char, applyOptimizerDerender, function() return optimizerActive end)
	end)

	print("[Optimizer] Anti Lag ACTIVADO - Modo " .. optimizerMode)
	else
	if not optimizerActive then return end

	removeAccessoriesEnabled = false
	optimizerActive = false
	if optimizerWalkCancel then optimizerWalkCancel(); optimizerWalkCancel = nil end
	lowFlagGeneration = lowFlagGeneration + 1
	restoreUltraState()

	if optimizerConn then
	optimizerConn:Disconnect()
	optimizerConn = nil
	end
	if optimizerLightingConn then
	optimizerLightingConn:Disconnect()
	optimizerLightingConn = nil
	end

	if optimizerCharConn then
	optimizerCharConn:Disconnect()
	optimizerCharConn = nil
	end

	if toggleStates["Sky Changer"] then
	applySky(skyCurrentMode)
	else
	resetOptimizerLighting()
	end
	print("[Optimizer] Anti Lag DESACTIVADO")
end
end
end
_G.__CrystalTrackStopper(function()
if optimizerActive and FeaturePostToggle["Optimizer"] then FeaturePostToggle["Optimizer"](false) end
end)

	makeToggleWithInput(visualSection, "FOV", "Custom FOV", "FOV",
	function(v) return tostring(v) end,
	function(n) return math.clamp(math.floor(n+0.5), 30, 120) end
	)

	do
	local fovActive = false
	local fovConn = nil
	local defaultFOV = 90
	local originalFOV = nil

	local function enableFOV()
	if fovActive then return end
	fovActive = true
	toggleStates["Custom FOV"] = true
	if fovConn then fovConn:Disconnect() end
	local cam = workspace.CurrentCamera
	if cam and originalFOV == nil then originalFOV = cam.FieldOfView end

	fovConn = RunService.RenderStepped:Connect((function()
	if not fovActive then return end
	local activeCamera = workspace.CurrentCamera
	local desiredFOV = speedValues.FOV or 90
	if activeCamera and math.abs(activeCamera.FieldOfView - desiredFOV) > 0.01 then
	activeCamera.FieldOfView = desiredFOV
	end
	end))
	if cam then cam.FieldOfView = speedValues.FOV or 90 end
	task.defer(saveConfig)
	end

	local function disableFOV()
	if not fovActive then return end
	fovActive = false
	toggleStates["Custom FOV"] = false
	if fovConn then
	fovConn:Disconnect()
	fovConn = nil
	end
	local cam = workspace.CurrentCamera
	if cam then cam.FieldOfView = originalFOV or defaultFOV end
	originalFOV = nil
	task.defer(saveConfig)
	end

	FeaturePostToggle["Custom FOV"] = function(active)
	if active then enableFOV() else disableFOV() end
	end
	_G.__CrystalTrackStopper(disableFOV)

	if toggleStates["Custom FOV"] then task.defer(enableFOV) end
	end

	makeToggleNoKeybind(visualSection, "Stretchz Res", "Stretchz Res")
	do
	local stretchRezEnabled = false
	local stretchRezConn = nil
	local STRETCH_FOV = 90
	local DEFAULT_FOV = 90

	local function applyStretchFOV(val)
	local cam = workspace.CurrentCamera
	if cam then
	pcall(function() cam.FieldOfView = val end)
	end
	end

	local function enableStretchRez()
	if stretchRezEnabled then return end
	stretchRezEnabled = true
	toggleStates["Stretchz Res"] = true

	local cam = workspace.CurrentCamera
	if not cam then return end

	if stretchRezConn then stretchRezConn:Disconnect() end
	stretchRezConn = RunService.RenderStepped:Connect((function()
	if not stretchRezEnabled then return end
	applyStretchFOV(STRETCH_FOV)
	pcall(function()
	cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, 0.7, 0, 0, 0, 1)
	end)
	end))

	applyStretchFOV(STRETCH_FOV)
	task.defer(saveConfig)
	end

	local function disableStretchRez()
	stretchRezEnabled = false
	toggleStates["Stretchz Res"] = false
	if stretchRezConn then
	stretchRezConn:Disconnect()
	stretchRezConn = nil
	end
	local cam = workspace.CurrentCamera
	if cam then
	pcall(function() cam.FieldOfView = DEFAULT_FOV end)
	end
	task.defer(saveConfig)
	end

	FeaturePostToggle["Stretchz Res"] = function(active)
	if active then enableStretchRez() else disableStretchRez() end
	end
	_G.__CrystalTrackStopper(disableStretchRez)

	if toggleStates["Stretchz Res"] then task.defer(enableStretchRez) end
	end


	-- Violette custom skins: preset data and asset application.
	do
	local originals=setmetatable({}, {__mode="k"})
	local generation=0
	local enabled=false
	local function mark(o) pcall(function() o:SetAttribute("_CrystalVioletteSkin",true) end); return o end
	local function clearObjects(c)
		if not c then return end
		for _,o in ipairs(c:GetDescendants()) do if o:GetAttribute("_CrystalVioletteSkin") then pcall(function() o:Destroy() end) end end
	end
	local function clearAccessories(c)
		if not c then return end
		for _,o in ipairs(c:GetChildren()) do if o:IsA("Accessory") or o:IsA("Accoutrement") then pcall(function() o:Destroy() end) end end
	end
	local function attach(c,h,a)
		if not a or not a:IsA("Accessory") then return false end
		mark(a); pcall(function() h:AddAccessory(a) end); if a.Parent~=c then a.Parent=c end
		local handle=a:FindFirstChild("Handle"); if not handle or not handle:IsA("BasePart") then return a.Parent==c end
		local ha=handle:FindFirstChildWhichIsA("Attachment"); if not ha then return a.Parent==c end
		local ba
		for _,o in ipairs(c:GetDescendants()) do if o:IsA("Attachment") and o.Name==ha.Name and not o:IsDescendantOf(a) then ba=o; break end end
		local bp=ba and ba.Parent
		if bp and bp:IsA("BasePart") then
			handle.Anchored=false; handle.CanCollide=false; handle.CanTouch=false; handle.CanQuery=false; handle.Massless=true
			handle.CFrame=bp.CFrame*ba.CFrame*ha.CFrame:Inverse()
			local w=Instance.new("WeldConstraint"); w.Name="CrystalVioletteAccessoryWeld"; w.Part0=bp; w.Part1=handle; w.Parent=handle
		end
		return true
	end
	local function addAsset(c,h,id)
		local ok,objs=pcall(function() return game:GetObjects("rbxassetid://"..tostring(id)) end)
		if not ok or type(objs)~="table" or #objs==0 then local x; local q=pcall(function() x=game:GetService("InsertService"):LoadAsset(id) end); if q and x then objs={x} else return false end end
		local added=false
		for _,root in ipairs(objs) do
			local list={}
			if root:IsA("Accessory") or root:IsA("Shirt") or root:IsA("Pants") or root:IsA("ShirtGraphic") then list={root} else for _,o in ipairs(root:GetDescendants()) do if o:IsA("Accessory") or o:IsA("Shirt") or o:IsA("Pants") or o:IsA("ShirtGraphic") then table.insert(list,o) end end end
			for _,src in ipairs(list) do
				local x=mark(src:Clone())
				if x:IsA("Accessory") then attach(c,h,x) else for _,old in ipairs(c:GetChildren()) do if old.ClassName==x.ClassName then old:Destroy() end end; x.Parent=c end
				added=true
			end
			pcall(function() root:Destroy() end)
		end
		return added
	end
	local function headless(c,on)
		local head=c and c:FindFirstChild("Head"); if not head then return end
		local t=on and 1 or 0; head.Transparency=t; head.LocalTransparencyModifier=t
		for _,o in ipairs(head:GetChildren()) do if o:IsA("Decal") or o:IsA("Texture") then o.Transparency=t end end
	end
	local function apply(c)
		local h=c and c:FindFirstChildOfClass("Humanoid"); if not h then return false end
		generation=generation+1; local token=generation; clearObjects(c)
		local old; pcall(function() old=h:GetAppliedDescription() end); if old and not originals[c] then originals[c]=old:Clone() end
		clearAccessories(c)
		if old then
			local d=old:Clone()
			for _,p in ipairs({"HatAccessory","HairAccessory","FaceAccessory","NeckAccessory","ShouldersAccessory","FrontAccessory","BackAccessory","WaistAccessory","ShirtAccessory","PantsAccessory","JacketAccessory","SweaterAccessory","ShortsAccessory","TShirtAccessory","DressSkirtAccessory"}) do pcall(function() d[p]="" end) end
			pcall(function() d.Shirt=0; d.Pants=0; d.GraphicTShirt=0 end)
			local skin=VIOLETTE_SKIN_SETS[violetteSkinMode] or VIOLETTE_SKIN_SETS["1"]
			pcall(function() d.HatAccessory=skin.hats or ""; d.HairAccessory=skin.hair or ""; if skin.head then d.Head=skin.head end; h:ApplyDescription(d) end); d:Destroy()
		end
		task.wait(); if not enabled or token~=generation or not c.Parent then return false end
		local skin=VIOLETTE_SKIN_SETS[violetteSkinMode] or VIOLETTE_SKIN_SETS["1"]
		for _,id in ipairs(skin.accessories or {}) do addAsset(c,h,id) end
		for _,id in ipairs(skin.clothing or {}) do addAsset(c,h,id) end
		headless(c,skin.headless==true); return true
	end
	local function clear(c)
		generation=generation+1; c=c or Player.Character; if not c then return end; clearObjects(c)
		local h=c:FindFirstChildOfClass("Humanoid"); local old=originals[c]
		if h and old then pcall(function() h:ApplyDescription(old:Clone()) end) else headless(c,false) end
	end
	FeaturePostToggle["Violette Custom Skins"]=function(on) enabled=on==true; if enabled then task.spawn(apply,Player.Character) else clear(Player.Character) end end
	_G._KawatanSkinColor = violetteSkinMode
	_G.__CrystalVioletteSkinSet=function(mode)
		mode=tostring(mode); if not VIOLETTE_SKIN_SETS[mode] then return violetteSkinMode end
		violetteSkinMode=mode; _G._KawatanSkinColor=mode; if enabled then task.spawn(apply,Player.Character) end; saveConfig(); return mode
	end
	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(c) if enabled then task.wait(.75); if enabled then task.spawn(apply,c) end end end))
	_G.__CrystalTrackStopper(function() enabled=false; clear(Player.Character) end)
	if toggleStates["Violette Custom Skins"] then
		enabled=true
		task.defer(apply, Player.Character)
	end
	end

	_G._CrystalCustomSkinPicked = function(name)
		name = tostring(name)
		if not VIOLETTE_SKIN_SETS[name] then return end
		-- Select first so enabling applies the skin that was clicked.
		_G.__CrystalVioletteSkinSet(name)
		local featureName = "Violette Custom Skins"
		if not toggleStates[featureName] then
			toggleStates[featureName] = true
			FeaturePostToggle[featureName](true)
		end
		local setter = toggleStateSetters[featureName]
		if setter then setter(true) end
		local updater = toggleVisualUpdaters[featureName]
		if updater then updater() end
		saveConfig()
	end


;(function()

    local LP  = Player
    local UIS = UserInputService

    if _G._CrystalCustomSkinsGalleryRuntime and _G._CrystalCustomSkinsGalleryRuntime.Destroy then
        pcall(_G._CrystalCustomSkinsGalleryRuntime.Destroy)
    end

    local _conns = {}
    local function hubConnect(signal, handler)
        local c = signal:Connect(handler)
        _conns[#_conns + 1] = c
        return c
    end
;(function()
    local function new(class, props, kids)
        local o = Instance.new(class)
        for k, v in pairs(props or {}) do o[k] = v end
        for _, c in ipairs(kids or {}) do c.Parent = o end
        return o
    end
    local function corner(r) return new("UICorner", {CornerRadius = UDim.new(0, r)}) end
    local function stroke(c, t, tr)
        return new("UIStroke", {Color = c, Thickness = t or 1, Transparency = tr or 0,
            ApplyStrokeMode = Enum.ApplyStrokeMode.Border})
    end
    local Q = TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    local function tw(o, ti, p)
        if typeof(o) ~= "Instance" then return end
        TweenService:Create(o, ti, p):Play()
    end
    local CAT_ACCENT = Color3.fromRGB(254, 254, 254)
    local CAT_PANEL  = Color3.fromRGB(18, 18, 18)
    local CAT_PANEL2 = Color3.fromRGB(32, 32, 32)
    local CAT_CARD   = Color3.fromRGB(10, 10, 10)
    local CAT_EDGE   = Color3.fromRGB(28, 28, 34)
    local CAT_EDGE_H = Color3.fromRGB(48, 48, 56)
    local CAT_DARK   = Color3.fromRGB(0, 0, 0)
    local CAT_TEXT   = Color3.fromRGB(255, 255, 255)
    local CAT_DIM    = Color3.fromRGB(150, 150, 155)
    local function accent()
        local a = _G._VioletteAccent
        return (typeof(a) == "Color3") and a or CAT_ACCENT
    end

    for _, root in ipairs({game:GetService("CoreGui"), LP:FindFirstChild("PlayerGui")}) do
        if root then
            local old = root:FindFirstChild("CrystalCustomSkinsGallery")
            if old then pcall(function() old:Destroy() end) end
        end
    end

    local gui = new("ScreenGui", {
        Name = "CrystalCustomSkinsGallery", ResetOnSpawn = false, IgnoreGuiInset = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling, DisplayOrder = 100001,
    })
    pcall(function() gui.Parent = (gethui and gethui()) or game:GetService("CoreGui") end)
    if not gui.Parent then gui.Parent = LP:WaitForChild("PlayerGui") end
    gui.Archivable = false
    pcall(function() gui:SetAttribute("_VlonEProtected", true) end)

    local compact = UIS.TouchEnabled and not UIS.KeyboardEnabled
    local PANEL_W, PANEL_H = (compact and 424 or 616), (compact and 456 or 632)
    local CELL_W, CELL_H = (compact and 126 or 190), (compact and 184 or 272)
    local PAD_X, PAD_Y = (compact and 2 or 5), (compact and 3 or 6)
    local SPIN_SPEED = 0.8
    local CAM_DIST, CAM_HEIGHT = 9.6, 0.5
    local HOVER_ZOOM = 0.86
    local DOLLY_RESPONSE = 9

    local backdrop = new("TextButton", {
        Parent = gui, Name = "CatalogBackdrop", Size = UDim2.fromScale(1, 1),
        BackgroundColor3 = Color3.fromRGB(0, 0, 0), BackgroundTransparency = 1,
        Text = "", AutoButtonColor = false, BorderSizePixel = 0,
        Visible = false, ZIndex = 200,
    })

    local panel = new("Frame", {
        Parent = backdrop, Name = "CatalogPanel",
        AnchorPoint = Vector2.new(0.5, 0.5), Position = UDim2.fromScale(0.5, 0.5),
        Size = UDim2.fromOffset(PANEL_W, PANEL_H),
        BackgroundColor3 = CAT_PANEL, BorderSizePixel = 0,
        Active = true, ZIndex = 201,
    }, {corner(14)})
    local panelEdge = stroke(accent(), 1.2, 0.55)
    panelEdge.Parent = panel
    local panelScale = new("UIScale", {Parent = panel, Scale = 1})
    new("UIGradient", {Parent = panel, Rotation = 35,
        Color = ColorSequence.new(CAT_PANEL, CAT_PANEL2)})

    local head = new("Frame", {
        Parent = panel, BackgroundTransparency = 1, Active = true,
        Position = UDim2.fromOffset(14, 8), Size = UDim2.new(1, -28, 0, 46), ZIndex = 202,
    })
    new("TextLabel", {
        Parent = head, Size = UDim2.new(1, -40, 0, 22), Position = UDim2.fromOffset(0, 2),
        BackgroundTransparency = 1, Text = "CUSTOM SKINS", Font = Enum.Font.GothamBlack,
        TextSize = compact and 16 or 18, TextColor3 = CAT_TEXT,
        TextXAlignment = Enum.TextXAlignment.Left, ZIndex = 203,
    })
    local subtitle = new("TextLabel", {
        Parent = head, Size = UDim2.new(1, -40, 0, 12), Position = UDim2.fromOffset(0, 24),
        BackgroundTransparency = 1, Text = "PICK A SKIN", Font = Enum.Font.GothamBold,
        TextSize = 9, TextColor3 = accent(), TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 203,
    })
    local closeBtn = new("TextButton", {
        Parent = head, Name = "CloseCatalog", BackgroundTransparency = 1,
        Text = "\u{00D7}", TextSize = 20, TextColor3 = CAT_TEXT,
        Font = Enum.Font.GothamMedium, AutoButtonColor = false,
        Position = UDim2.new(1, -30, 0, 2), Size = UDim2.fromOffset(30, 30), ZIndex = 204,
    })

    local scrolling = new("ScrollingFrame", {
        Parent = panel, Name = "SetCards", BackgroundTransparency = 1, BorderSizePixel = 0,
        Position = UDim2.fromOffset(14, 58), Size = UDim2.new(1, -28, 1, -72),
        CanvasSize = UDim2.new(), ScrollBarThickness = 0, ZIndex = 202,
    })
    new("UIPadding", {Parent = scrolling,
        PaddingTop = UDim.new(0, 5), PaddingBottom = UDim.new(0, 5),
        PaddingLeft = UDim.new(0, 4), PaddingRight = UDim.new(0, 4)})
    local grid = new("UIGridLayout", {
        Parent = scrolling, CellSize = UDim2.fromOffset(CELL_W, CELL_H),
        CellPadding = UDim2.fromOffset(PAD_X, PAD_Y),
        HorizontalAlignment = Enum.HorizontalAlignment.Center,
        SortOrder = Enum.SortOrder.LayoutOrder,
    })
    grid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        scrolling.CanvasSize = UDim2.fromOffset(0, grid.AbsoluteContentSize.Y + 12)
    end)

    local cards, shots = {}, {}
    local built, catalogOpen = false, false
    local panelDragging, panelDragEndedAt = false, 0
    local refreshCards

    local function dressPreview(rig, skin)
        rig.PrimaryPart = rig:FindFirstChild("HumanoidRootPart") or rig.PrimaryPart
        for _, object in ipairs(rig:GetDescendants()) do
            if object:IsA("BasePart") then
                object.CanCollide = false
                object.CastShadow = false
            elseif object:IsA("Script") or object:IsA("LocalScript") then
                object:Destroy()
            end
        end
        if skin.headless ~= false then
            local rigHead = rig:FindFirstChild("Head")
            if rigHead then
                rigHead.Transparency = 1
                for _, object in ipairs(rigHead:GetChildren()) do
                    if object:IsA("Decal") or object:IsA("Texture") then object.Transparency = 1 end
                end
            end
        end
        local mode = skin.korblox or "Off"
        for _, entry in ipairs({{"Left", "Left Leg"}, {"Right", "Right Leg"}}) do
            if mode == "Both" or mode == entry[1] then
                local config = _G._RaVeKorbloxAssets and _G._RaVeKorbloxAssets[entry[2]]
                local target = config and rig:FindFirstChild(config.targetBodyPart)
                if target then
                    for _, partName in ipairs(config.partsToHide) do
                        local limb = rig:FindFirstChild(partName)
                        if limb and limb:IsA("BasePart") then limb.Transparency = 1 end
                    end
                    local ok, objects = pcall(function() return game:GetObjects(config.id) end)
                    local source = ok and objects and objects[1]
                    local mesh = source and (source:IsA("BasePart") and source
                        or source:FindFirstChildWhichIsA("BasePart", true))
                    if mesh then
                        mesh.CanCollide = false
                        mesh.CastShadow = false
                        mesh.CFrame = target.CFrame * (config.offset or CFrame.new())
                        local weld = Instance.new("WeldConstraint")
                        weld.Part0, weld.Part1, weld.Parent = target, mesh, mesh
                        mesh.Parent = rig
                    end
                    if source and source ~= mesh and source.Parent ~= rig then
                        pcall(function() source:Destroy() end)
                    end
                end
            end
        end
    end

    local function seatStrays(rig)
        local root = rig:FindFirstChild("HumanoidRootPart")
        if not root then return end
        for _, accessory in ipairs(rig:GetChildren()) do
            if accessory:IsA("Accessory") then
                pcall(function()
                    local handle = accessory:FindFirstChild("Handle")
                    if not (handle and handle:IsA("BasePart")) then return end
                    if (handle.Position - root.Position).Magnitude <= 8 then return end

                    local handleAttachment = handle:FindFirstChildWhichIsA("Attachment")
                    local bodyAttachment
                    if handleAttachment then
                        for _, object in ipairs(rig:GetDescendants()) do
                            if object:IsA("Attachment") and object.Name == handleAttachment.Name
                                and not object:IsDescendantOf(accessory) then
                                bodyAttachment = object
                                break
                            end
                        end
                    end
                    local bodyPart = bodyAttachment and bodyAttachment.Parent
                    if bodyPart and bodyPart:IsA("BasePart") then
                        handle.CFrame = bodyPart.CFrame * bodyAttachment.CFrame
                            * handleAttachment.CFrame:Inverse()
                    else
                        local rigHead = rig:FindFirstChild("Head")
                        if rigHead then handle.CFrame = rigHead.CFrame end
                    end
                end)
            end
        end
    end

    local function loadCard(setName, card)
        task.spawn(function()
            local description = _G._KawatanBuildSetDescription
                and _G._KawatanBuildSetDescription(setName)
            if not description then card.loading.Text = "N/A" return end
            local rig
            local ok = pcall(function()
                rig = Players:CreateHumanoidModelFromDescriptionAsync(description, Enum.HumanoidRigType.R15)
            end)
            if not ok or not rig then
                pcall(function()
                    rig = Players:CreateHumanoidModelFromDescription(description, Enum.HumanoidRigType.R15)
                end)
            end
            pcall(function() description:Destroy() end)
            if not rig or not (rig:FindFirstChild("UpperTorso") or rig:FindFirstChild("Torso")) then
                if rig then pcall(function() rig:Destroy() end) end
                card.loading.Text = "N/A"
                return
            end

            pcall(dressPreview, rig, _G._KawatanSkinSets[setName])
            rig.Parent = card.world

            task.wait()
            pcall(seatStrays, rig)
            for _, object in ipairs(rig:GetDescendants()) do
                if object:IsA("BasePart") then object.Anchored = true end
            end
            pcall(function() rig:PivotTo(CFrame.new()) end)
            card.shot.rig = rig
            card.loading.Visible = false
        end)
    end

    local function selectSet(name)
        _G._KawatanSkinColor = name
        if _G._CrystalCustomSkinPicked then
            pcall(_G._CrystalCustomSkinPicked, name)
        end
        if refreshCards then refreshCards() end
    end

    for index, setName in ipairs(_G._KawatanSkinSetOrder or {}) do
        local card = new("TextButton", {
            Parent = scrolling, Name = setName .. "Preview", LayoutOrder = index,
            BackgroundColor3 = CAT_CARD, BackgroundTransparency = 0,
            BorderSizePixel = 0, Text = "", AutoButtonColor = false, ZIndex = 203,
        }, {corner(10)})
        local cardStroke = stroke(CAT_EDGE, 1, 0)
        cardStroke.Parent = card

        local viewport = new("ViewportFrame", {
            Parent = card, Name = "AvatarPreview",
            BackgroundColor3 = CAT_DARK, BackgroundTransparency = 0,
            BorderSizePixel = 0, Position = UDim2.fromOffset(7, 7),
            Size = UDim2.new(1, -14, 1, -34),
            Ambient = Color3.fromRGB(255, 255, 255), LightColor = Color3.fromRGB(255, 255, 255),
            LightDirection = Vector3.new(-0.25, -0.5, -0.83), ZIndex = 204,
        }, {corner(8)})

        local world = new("WorldModel", {Parent = viewport})
        local camera = new("Camera", {Parent = viewport, FieldOfView = 42,
            CFrame = CFrame.lookAt(Vector3.new(0, CAM_HEIGHT, CAM_DIST),
                Vector3.new(0, CAM_HEIGHT, 0))})
        viewport.CurrentCamera = camera

        local loading = new("TextLabel", {
            Parent = viewport, Size = UDim2.fromScale(1, 1), BackgroundTransparency = 1,
            Text = "LOADING", Font = Enum.Font.GothamBold, TextSize = 9,
            TextColor3 = CAT_DIM, ZIndex = 205,
        })

        local label = new("TextLabel", {
            Parent = card, Position = UDim2.new(0, 8, 1, -24),
            Size = UDim2.new(1, -16, 0, 19), BackgroundTransparency = 1, Text = ((_G._KawatanSkinSets or {})[setName] or {}).displayName or tostring(setName):gsub("_", " "),
            Font = Enum.Font.GothamBlack, TextSize = 10,
            TextColor3 = CAT_DIM,
            TextXAlignment = Enum.TextXAlignment.Center, ZIndex = 204,
        })

        local shot = {camera = camera, rig = nil, phase = index * 0.47,
            distance = CAM_DIST, current = CAM_DIST, target = CAM_DIST}
        shots[#shots + 1] = shot

        card.Activated:Connect(function() selectSet(setName) end)
        card.MouseEnter:Connect(function()
            shot.target = shot.distance * HOVER_ZOOM
            if _G._KawatanSkinColor ~= setName then
                tw(cardStroke, Q, {Color = CAT_EDGE_H, Transparency = 0})
                tw(label, Q, {TextColor3 = CAT_TEXT})
            end
        end)
        card.MouseLeave:Connect(function()
            shot.target = shot.distance
            if refreshCards then refreshCards() end
        end)

        cards[setName] = {card = card, stroke = cardStroke, viewport = viewport,
            world = world, camera = camera, label = label, loading = loading,
            shot = shot}
    end

    refreshCards = function()
        local live = accent()
        panelEdge.Color = live
        subtitle.TextColor3 = live
        for setName, entry in pairs(cards) do
            local on = setName == _G._KawatanSkinColor
            tw(entry.stroke, Q, {
                Color = on and live or CAT_EDGE,
                Thickness = on and 2 or 1, Transparency = 0,
            })
            tw(entry.label, Q, {TextColor3 = on and CAT_TEXT or CAT_DIM})
        end
    end
    refreshCards()
    _G._KawatanRefreshGalleryCards = refreshCards

    local elapsed = 0
    hubConnect(RunService.RenderStepped, LPH_NO_VIRTUALIZE(function(dt)
        if not catalogOpen then return end
        elapsed = elapsed + dt
        local ease = math.min(dt * DOLLY_RESPONSE, 1)
        for _, shot in ipairs(shots) do
            if shot.rig and shot.rig.Parent then
                local breath = math.cos(elapsed * 3 + shot.phase) * 0.035
                pcall(function()
                    shot.rig:PivotTo(CFrame.new(0, breath, 0)
                        * CFrame.Angles(0, math.pi + elapsed * SPIN_SPEED + shot.phase, 0))
                end)
            end
            if shot.camera.Parent then
                shot.current = shot.current + (shot.target - shot.current) * ease
                shot.camera.CFrame = CFrame.lookAt(
                    Vector3.new(0, CAM_HEIGHT, shot.current), Vector3.new(0, CAM_HEIGHT, 0))
            end
        end
    end))

    local function closeCatalog()
        catalogOpen = false
        tw(backdrop, Q, {BackgroundTransparency = 1})
        tw(panelScale, TweenInfo.new(0.14, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
            {Scale = 0.9})
        task.delay(0.16, function()
            if not catalogOpen then backdrop.Visible = false end
        end)
    end

    _G._KawatanOpenSkinGallery = function()
        catalogOpen = true
        refreshCards()
        for _, shot in ipairs(shots) do shot.target = shot.distance end
        backdrop.Visible = true
        backdrop.BackgroundTransparency = 1
        panelScale.Scale = 0.9
        tw(backdrop, TweenInfo.new(0.2), {BackgroundTransparency = 0.42})
        tw(panelScale, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.Out),
            {Scale = 1})
        if built then return end
        built = true
        task.spawn(function()
            for _, setName in ipairs(_G._KawatanSkinSetOrder or {}) do
                local entry = cards[setName]
                if entry then loadCard(setName, entry) end
                task.wait(0.12)
            end
        end)
    end
    _G._KawatanCloseSkinGallery = closeCatalog

    closeBtn.Activated:Connect(closeCatalog)
    backdrop.MouseButton1Click:Connect(function()
        if panelDragging or (os.clock() - panelDragEndedAt) < 0.25 then return end
        closeCatalog()
    end)

    do
        local startInput, startPosition, dragInput
        head.InputBegan:Connect(function(input)
            if input.UserInputType ~= Enum.UserInputType.MouseButton1
                and input.UserInputType ~= Enum.UserInputType.Touch then return end
            panelDragging, startInput, startPosition, dragInput =
                true, input.Position, panel.Position, input
        end)
        head.InputChanged:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseMovement
                or input.UserInputType == Enum.UserInputType.Touch then
                dragInput = input
            end
        end)
        hubConnect(UIS.InputChanged, function(input)
            if not panelDragging then return end
            if input ~= dragInput and input.UserInputType ~= Enum.UserInputType.MouseMovement then return end
            local delta = input.Position - startInput
            panel.Position = UDim2.new(startPosition.X.Scale, startPosition.X.Offset + delta.X,
                startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
        end)
        hubConnect(UIS.InputEnded, function(input)
            if not panelDragging then return end
            if input == dragInput
                or input.UserInputType == Enum.UserInputType.MouseButton1
                or input.UserInputType == Enum.UserInputType.Touch then
                panelDragging, dragInput = false, nil
                panelDragEndedAt = os.clock()
            end
        end)
    end
end)()

    _G._CrystalCustomSkinsGalleryRuntime = {
        Destroy = function()
            for _, c in ipairs(_conns) do pcall(function() c:Disconnect() end) end
            _conns = {}
            pcall(function() gui:Destroy() end)
            _G._CrystalCustomSkinsGalleryRuntime = nil
        end,
    }
end)()
	do
	local appearanceState = _G.__CrystalVisualAppearanceState
	if type(appearanceState) ~= "table" or appearanceState.version ~= 2 then
		appearanceState = {
			version = 2,
			headless = setmetatable({}, {__mode = "k"}),
			korblox = setmetatable({}, {__mode = "k"}),
		}
		_G.__CrystalVisualAppearanceState = appearanceState
	end
	appearanceState.setHeadless = function(active, character)
		character = character or Player.Character
		local head = character and character:FindFirstChild("Head")
		if not head or not head:IsA("BasePart") then return false end
		if active then
			if not appearanceState.headless[character] then
				local saved = {headTransparency = head.Transparency, headLocalTransparency = head.LocalTransparencyModifier, faces = {}}
				for _, item in ipairs(head:GetChildren()) do
					if item:IsA("Decal") or item:IsA("Texture") then
						table.insert(saved.faces, {item = item, transparency = item.Transparency})
					end
				end
				appearanceState.headless[character] = saved
			end
			head.Transparency = 1
			head.LocalTransparencyModifier = 1
			for _, item in ipairs(head:GetChildren()) do
				if item:IsA("Decal") or item:IsA("Texture") then item.Transparency = 1 end
			end
			return true
		end
		local saved = appearanceState.headless[character]
		if not saved then return false end
		head.Transparency = saved.headTransparency
		head.LocalTransparencyModifier = saved.headLocalTransparency
		for _, face in ipairs(saved.faces) do
			if face.item and face.item.Parent then face.item.Transparency = face.transparency end
		end
		return true
	end
	appearanceState.setKorblox = function(active, character)
		character = character or Player.Character
		if not character then return false end
		local saved = appearanceState.korblox[character]
		if not active then
			local oldVisual = character:FindFirstChild("CrystalVisual_Korblox")
			if oldVisual then pcall(function() oldVisual:Destroy() end) end
			for _, child in ipairs(character:GetChildren()) do
				if child:IsA("CharacterMesh") and child.Name == "CrystalVisual_KorbloxCharacterMesh" then
					pcall(function() child:Destroy() end)
				end
			end
			if not saved then return false end
			for _, partState in ipairs(saved.parts) do
				if partState.part and partState.part.Parent then
					partState.part.Transparency = partState.transparency
					partState.part.LocalTransparencyModifier = partState.localTransparency
				end
			end
			return true
		end
		local target = character:FindFirstChild("LeftUpperLeg") or character:FindFirstChild("Left Leg")
		if not target or not target:IsA("BasePart") then return false end
		local ok, objects = pcall(function() return game:GetObjects("rbxassetid://139607673") end)
		if not ok or not objects or not objects[1] then
			warn("Crystal Korblox: no se pudo cargar el asset 139607673")
			return false
		end
		local oldVisual = character:FindFirstChild("CrystalVisual_Korblox")
		if oldVisual then pcall(function() oldVisual:Destroy() end) end
		for _, child in ipairs(character:GetChildren()) do
			if child:IsA("CharacterMesh") and child.Name == "CrystalVisual_KorbloxCharacterMesh" then
				pcall(function() child:Destroy() end)
			end
		end
		local visual = Instance.new("Model")
		visual.Name = "CrystalVisual_Korblox"
		for _, object in ipairs(objects) do object.Parent = visual end
		local importedParts = {}
		for _, descendant in ipairs(visual:GetDescendants()) do
			if descendant:IsA("BasePart") then table.insert(importedParts, descendant) end
		end
		local characterMeshes = {}
		for _, descendant in ipairs(visual:GetDescendants()) do
			if descendant:IsA("CharacterMesh") then table.insert(characterMeshes, descendant) end
		end
		if #importedParts == 0 and #characterMeshes == 0 then
			visual:Destroy()
			warn("Crystal Korblox: el asset 139607673 no contiene piezas compatibles")
			return false
		end
		if not saved then
			saved = {parts = {}}
			for _, partName in ipairs({"LeftUpperLeg", "LeftLowerLeg", "LeftFoot", "Left Leg"}) do
				local part = character:FindFirstChild(partName)
				if part and part:IsA("BasePart") then
					table.insert(saved.parts, {part = part, transparency = part.Transparency, localTransparency = part.LocalTransparencyModifier})
				end
			end
			appearanceState.korblox[character] = saved
		end
		visual.Parent = character
		local isR15 = character:FindFirstChild("LeftUpperLeg") ~= nil
		if isR15 then
			for _, partState in ipairs(saved.parts) do
				if partState.part and partState.part.Parent then
					partState.part.Transparency = 1
					partState.part.LocalTransparencyModifier = 1
				end
			end
		end
		for _, part in ipairs(importedParts) do
			local matchingTarget = character:FindFirstChild(part.Name)
			if not matchingTarget or not matchingTarget:IsA("BasePart") then matchingTarget = target end
			part.Anchored = false
			part.CanCollide = false
			part.Massless = true
			part.CFrame = matchingTarget.CFrame
			local weld = Instance.new("WeldConstraint")
			weld.Part0 = matchingTarget
			weld.Part1 = part
			weld.Parent = part
		end
		for _, mesh in ipairs(characterMeshes) do
			mesh.Name = "CrystalVisual_KorbloxCharacterMesh"
			mesh.Parent = character
		end
		return true
	end
	FeaturePostToggle["Headless Visual"] = function(active)
		appearanceState.setHeadless(active == true, Player.Character)
	end
	FeaturePostToggle["Korblox Visual"] = function(active)
		task.spawn(appearanceState.setKorblox, active == true, Player.Character)
	end
	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(character)
		task.wait(0.75)
		if toggleStates["Headless Visual"] then appearanceState.setHeadless(true, character) end
		if toggleStates["Korblox Visual"] then appearanceState.setKorblox(true, character) end
	end))
	if toggleStates["Headless Visual"] then task.delay(0.5, appearanceState.setHeadless, true, Player.Character) end
	if toggleStates["Korblox Visual"] then task.delay(0.5, appearanceState.setKorblox, true, Player.Character) end
	end

	do
	local skyOrigLighting = {
	Ambient = Lighting.Ambient,
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	FogColor = Lighting.FogColor,
	FogEnd = Lighting.FogEnd,
	GlobalShadows = Lighting.GlobalShadows,
	EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
	EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
	OutdoorAmbient = Lighting.OutdoorAmbient,
	}
	local skyActiveColorCorr = nil
	skyCurrentMode = _G.__CrystalSkyChangerMode or "blue"

	local function clearSkyColorCorr()
	if skyActiveColorCorr then
	pcall(function() skyActiveColorCorr:Destroy() end)
	skyActiveColorCorr = nil
	end
	end

	local function restoreSkyLighting()
	clearSkyColorCorr()
	pcall(function()
	Lighting.Ambient = skyOrigLighting.Ambient
	Lighting.Brightness = skyOrigLighting.Brightness
	Lighting.ClockTime = skyOrigLighting.ClockTime
	Lighting.FogColor = skyOrigLighting.FogColor
	Lighting.FogEnd = skyOrigLighting.FogEnd
	Lighting.GlobalShadows = skyOrigLighting.GlobalShadows
	Lighting.EnvironmentDiffuseScale = skyOrigLighting.EnvironmentDiffuseScale
	Lighting.EnvironmentSpecularScale = skyOrigLighting.EnvironmentSpecularScale
	Lighting.OutdoorAmbient = skyOrigLighting.OutdoorAmbient
	end)
	end

	function applySky(kind)
	if kind == nil or kind == "none" then
	restoreSkyLighting()
	return
	end

	clearSkyColorCorr()
	local cc = Instance.new("ColorCorrectionEffect")
	cc.Parent = Lighting
	skyActiveColorCorr = cc

	if kind == "blue" then
	Lighting.Ambient = Color3.fromRGB(30, 60, 120)
	Lighting.FogColor = Color3.fromRGB(40, 80, 160)
	cc.TintColor = Color3.fromRGB(140, 180, 255)
	cc.Saturation = 0.4
	cc.Contrast = 0.1
	elseif kind == "night" then
	Lighting.ClockTime = 0
	Lighting.Brightness = 0.2
	Lighting.Ambient = Color3.fromRGB(20, 20, 35)
	cc.TintColor = Color3.fromRGB(180, 180, 220)
	cc.Saturation = -0.2
	cc.Contrast = 0.1
	elseif kind == "day" then
	Lighting.ClockTime = 14
	Lighting.Brightness = 2
	Lighting.Ambient = Color3.fromRGB(140, 140, 140)
	cc.TintColor = Color3.fromRGB(255, 255, 255)
	cc.Saturation = 0.1
	cc.Contrast = 0
	end
	end

	FeaturePostToggle["Sky Changer"] = function(active)
	if active then
	applySky(skyCurrentMode)
	else
	restoreSkyLighting()
	end
	end

	local skyChangerToggle = makeToggleNoKeybind(visualSection, "Sky Changer", "Sky Changer")
	if skyChangerToggle then
	local skyModeBtn = Instance.new("TextButton", skyChangerToggle)
	skyModeBtn.Name = "SkyModeBtn"
	skyModeBtn.Size = UDim2.new(0, 66, 0, 20)
	skyModeBtn.Position = UDim2.new(1, -74, 0.5, -10)
	skyModeBtn.AnchorPoint = Vector2.new(0, 0)
	skyModeBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	skyModeBtn.BorderSizePixel = 0
	skyModeBtn.Text = "BLUE"
	skyModeBtn.TextColor3 = Color3.fromRGB(225,238,255)
	skyModeBtn.Font = Enum.Font.GothamBold
	skyModeBtn.TextSize = 10
	skyModeBtn.AutoButtonColor = false
	skyModeBtn.ZIndex = 30
	Instance.new("UICorner", skyModeBtn).CornerRadius = UDim.new(0, 4)
	local skyModeStroke = Instance.new("UIStroke", skyModeBtn)
	skyModeStroke.Color = Color3.fromRGB(255,255,255)
	skyModeStroke.Thickness = 1
	skyModeStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	local function updateSkyModeBtn()
	local label = skyCurrentMode == "day" and "DAY" or skyCurrentMode == "night" and "NIGHT" or "BLUE"
	skyModeBtn.Text = label
	skyModeBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	skyModeBtn.TextColor3 = Color3.fromRGB(225,238,255)
	skyModeStroke.Color = Color3.fromRGB(255,255,255)
	skyModeStroke.Thickness = 1
	skyModeBtn.TextStrokeTransparency = 1
	end
	updateSkyModeBtn()
	connectBtn(skyModeBtn, function()
	if skyCurrentMode == "day" then
	skyCurrentMode = "blue"
	elseif skyCurrentMode == "blue" then
	skyCurrentMode = "night"
	else
	skyCurrentMode = "day"
	end
	_G.__CrystalSkyChangerMode = skyCurrentMode
	saveConfig()
	updateSkyModeBtn()
	if toggleStates["Sky Changer"] then
	applySky(skyCurrentMode)
	end
	end)
	end

	if toggleStates["Sky Changer"] then
	task.delay(0.2, function() applySky(skyCurrentMode) end)
	end
	end

	makeToggleNoKeybind(visualSection, "Mobile Buttons", "Show Buttons")
	makeToggleNoKeybind(visualSection, "Lock Buttons", "Lock Buttons")

	do
	local mainThemesBtnContainer = Instance.new("Frame", visualSection)
	mainThemesBtnContainer.Name = "MainThemesBtnContainer"
	mainThemesBtnContainer.Visible = true
	mainThemesBtnContainer.Size = UDim2.new(1, 0, 0, 30)
	mainThemesBtnContainer.BackgroundTransparency = 1
	mainThemesBtnContainer.BorderSizePixel = 0
	mainThemesBtnContainer.ZIndex = 12
	mainThemesBtnContainer.LayoutOrder = 20

	local mainThemesBtn = Instance.new("TextButton", mainThemesBtnContainer)
	mainThemesBtn.Name = "MainThemesBtn"
	mainThemesBtn.AnchorPoint = Vector2.new(0.5, 0)
	mainThemesBtn.Size = UDim2.new(0, 150, 0, 30)
	mainThemesBtn.Position = UDim2.new(0.5, 0, 0, 0)
	mainThemesBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	mainThemesBtn.BackgroundTransparency = 0.12
	mainThemesBtn.AutoButtonColor = false
	mainThemesBtn.Font = Enum.Font.GothamBold
	mainThemesBtn.Text = "Colors"
	mainThemesBtn.TextColor3 = Color3.fromRGB(235,240,245)
	mainThemesBtn.TextSize = 11
	mainThemesBtn.ZIndex = 12
	mainThemesBtn.TextXAlignment = Enum.TextXAlignment.Center
	mainThemesBtn.TextYAlignment = Enum.TextYAlignment.Center
	Instance.new("UICorner", mainThemesBtn).CornerRadius = UDim.new(0, 8)
	local mainThemesBtnStroke = Instance.new("UIStroke", mainThemesBtn)
	mainThemesBtnStroke.Color = Color3.fromRGB(255,255,255)
	mainThemesBtnStroke.Thickness = 1.2
	mainThemesBtnStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	mainThemesBtnStroke.Transparency = 0.15

	local mainThemesFrame = Instance.new("Frame")
	mainThemesFrame.Name = "MainThemesPanel"
	mainThemesFrame.Size = UDim2.fromOffset(260, 360)
	mainThemesFrame.BackgroundColor3 = Color3.fromRGB(48, 92, 138)
	mainThemesFrame.BorderSizePixel = 0
	mainThemesFrame.Visible = false
	mainThemesFrame.ZIndex = 20
	mainThemesFrame.Parent = ScreenGui
	local themesGradient = Instance.new("UIGradient", mainThemesFrame)
	themesGradient.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 75, 118)),
	ColorSequenceKeypoint.new(0.48, Color3.fromRGB(67, 120, 174)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(34, 67, 108)),
	})
	themesGradient.Rotation = 35

	local function positionMainThemesPanel()
	if Panel then
	local panelX = Panel.Position.X.Offset + Panel.Size.X.Offset
	mainThemesFrame.Position = UDim2.new(
	Panel.Position.X.Scale,
	panelX + 24,
	Panel.Position.Y.Scale,
	Panel.Position.Y.Offset + 6
	)
	end
	end
	if Panel then
	Panel:GetPropertyChangedSignal("Position"):Connect(function()
	if _G.__CrystalModernGuiActive or not mainThemesFrame.Parent then return end
	if mainThemesFrame.Visible then positionMainThemesPanel() end
	end)
	Panel:GetPropertyChangedSignal("Size"):Connect(function()
	if _G.__CrystalModernGuiActive or not mainThemesFrame.Parent then return end
	if mainThemesFrame.Visible then positionMainThemesPanel() end
	end)

	local mainThemesWasOpen = false
	Panel:GetPropertyChangedSignal("Visible"):Connect(function()
	if _G.__CrystalModernGuiActive or not mainThemesFrame.Parent then return end
	if not Panel.Visible then
	if mainThemesFrame.Visible then
	mainThemesWasOpen = true
	mainThemesFrame.Visible = false
	else
	mainThemesWasOpen = false
	end
	else
	if mainThemesWasOpen then
	positionMainThemesPanel()
	mainThemesFrame.Visible = true
	end
	end
	end)
	end
	Instance.new("UICorner", mainThemesFrame).CornerRadius = UDim.new(0, 12)
	local themesStroke = Instance.new("UIStroke", mainThemesFrame)
	themesStroke.Color = Color3.fromRGB(0, 0, 0)
	themesStroke.Thickness = 0
	themesStroke.Transparency = 1

	local pendingBackground = bgIndex or 1
	local themeCards = {}
	local function refreshMainThemeCards()
	for index, data in ipairs(themeCards) do
	local selected = index == pendingBackground
	local card = data.card
	local image = data.image
	local stroke = data.stroke
	local baseX, baseY = data.baseX, data.baseY
	local baseW, baseH = data.baseW, data.baseH

	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Thickness = selected and 2 or 1.5
	stroke.Transparency = selected and 0.25 or 0.7
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	card.Size = selected and UDim2.fromOffset(math.max(4, baseW - 6), math.max(4, baseH - 6)) or UDim2.fromOffset(baseW, baseH)
	card.Position = selected and UDim2.new(0, baseX + 3, 0, baseY + 3) or UDim2.new(0, baseX, 0, baseY)
	card.BackgroundTransparency = 1
	image.Size = UDim2.new(1, 0, 1, 0)
	image.Position = UDim2.new(0, 0, 0, 0)
	image.BackgroundTransparency = 1
	end
	end

	local function layoutMainThemeCards()
	if not mainThemesFrame or not themeCards then return end
	local frameW = mainThemesFrame.AbsoluteSize.X > 0 and mainThemesFrame.AbsoluteSize.X or mainThemesFrame.Size.X.Offset
	local frameH = mainThemesFrame.AbsoluteSize.Y > 0 and mainThemesFrame.AbsoluteSize.Y or mainThemesFrame.Size.Y.Offset
	local paddingX = 12
	local paddingY = 12
	local gapX = 10
	local gapY = 10
	local safeBottom = 36
	local usableW = math.max(0, frameW - paddingX * 2)
	local usableH = math.max(0, frameH - safeBottom - paddingY * 2)
	local cardW = math.floor((usableW - gapX) / 2)
	local rowCount = math.max(2, math.ceil(#themeCards / 2))
	local cardH = math.floor((usableH - gapY * (rowCount - 1)) / rowCount)

	for index, data in ipairs(themeCards) do
	local col = ((index - 1) % 2)
	local row = math.floor((index - 1) / 2)
	local x = paddingX + col * (cardW + gapX)
	local y = paddingY + row * (cardH + gapY)
	data.baseX = x
	data.baseY = y
	data.baseW = cardW
	data.baseH = cardH
	data.card.Size = UDim2.fromOffset(cardW, cardH)
	data.card.Position = UDim2.new(0, x, 0, y)
	data.image.Size = UDim2.new(1, 0, 1, 0)
	data.image.Position = UDim2.new(0, 0, 0, 0)
	end
	end

	for index, imageId in ipairs(backgroundIds) do
	local card = Instance.new("TextButton", mainThemesFrame)
	card.BackgroundColor3 = Color3.fromRGB(30,30,38)
	card.BackgroundTransparency = 1
	card.BorderSizePixel = 0
	card.Text = ""
	card.AutoButtonColor = false
	card.ZIndex = 21
	Instance.new("UICorner", card).CornerRadius = UDim.new(0, 7)
	local cardImage = Instance.new("ImageLabel", card)
	cardImage.BackgroundTransparency = 1
	cardImage.Image = imageId
	cardImage.ScaleType = Enum.ScaleType.Crop
	cardImage.ZIndex = 21
	Instance.new("UICorner", cardImage).CornerRadius = UDim.new(0, 7)
	local cardLabel = Instance.new("TextLabel", card)
	cardLabel.Size = UDim2.new(1, -12, 0, 12)
	cardLabel.Position = UDim2.new(0, 6, 1, -14)
	cardLabel.BackgroundTransparency = 1
	cardLabel.Text = "GUI " .. tostring(index)
	cardLabel.TextColor3 = Color3.fromRGB(235,240,245)
	cardLabel.TextSize = 8
	cardLabel.Font = Enum.Font.GothamBold
	cardLabel.ZIndex = 23
	cardLabel.TextStrokeColor3 = Color3.fromRGB(5, 12, 25)
	cardLabel.TextStrokeTransparency = 0.25
	local cardStroke = Instance.new("UIStroke", card)
	cardStroke.Color = Color3.fromRGB(255,255,255)
	cardStroke.Thickness = 0
	cardStroke.Transparency = 1
	cardStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	table.insert(themeCards, {
	card = card,
	image = cardImage,
	stroke = cardStroke,
	baseX = 0,
	baseY = 0,
	baseW = 0,
	baseH = 0,
	})
	card.Activated:Connect(function()
	pendingBackground = index
	refreshMainThemeCards()
	end)
	end

	local saveThemeButton = Instance.new("TextButton", mainThemesFrame)
	saveThemeButton.Size = UDim2.new(1, -24, 0, 28)
	saveThemeButton.Position = UDim2.new(0, 12, 1, -44)

	pcall(function() layoutMainThemeCards() end)
	mainThemesFrame:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
	pcall(layoutMainThemeCards)
	end)
	saveThemeButton.BackgroundColor3 = Color3.fromRGB(120,180,240)
	saveThemeButton.BorderSizePixel = 0
	saveThemeButton.Text = "Apply Color"
	saveThemeButton.TextColor3 = Color3.fromRGB(235,240,245)
	saveThemeButton.TextSize = 11
	saveThemeButton.Font = Enum.Font.GothamBold
	saveThemeButton.ZIndex = 21
	Instance.new("UICorner", saveThemeButton).CornerRadius = UDim.new(0, 7)
	saveThemeButton.Activated:Connect(function()
	bgIndex = pendingBackground
	if BgImage then BgImage.Image = backgroundIds[bgIndex] end
	mainThemesFrame.Visible = false
	if HeaderBgBtn then pcall(function() HeaderBgBtn.Text = tostring(bgIndex) .. "/" .. tostring(#backgroundIds) end) end
	_G["_CrystalHub_UI_BgIndex"] = bgIndex
	if _G.__CrystalApplyCurtVisualTheme then pcall(_G.__CrystalApplyCurtVisualTheme, bgIndex) end
	saveConfig()
	end)

	mainThemesBtn.Activated:Connect(function()
	pendingBackground = bgIndex
	positionMainThemesPanel()
	mainThemesFrame.Visible = not mainThemesFrame.Visible
	refreshMainThemeCards()
	end)

	if HeaderBgBtn then pcall(function() HeaderBgBtn.Visible = false end) end
	end

	do
	local oldQuickButtons = _G.__CrystalQuickButtonsFrame
	if oldQuickButtons then pcall(function() oldQuickButtons:Destroy() end) end

	local quickButtons = Instance.new("Frame")
	quickButtons.Name = "CrystalQuickButtons"
	quickButtons.Size = UDim2.new(1, 0, 1, 0)
	quickButtons.Position = UDim2.new(0, 0, 0, 0)
	quickButtons.BackgroundTransparency = 1
	quickButtons.BorderSizePixel = 0
	quickButtons.Active = false
	quickButtons.ZIndex = 750
	quickButtons.Visible = toggleStates["Show Buttons"] == true
	quickButtons.Parent = ScreenGui
	_G.__CrystalQuickButtonsFrame = quickButtons

	local function makeQuickButton(label, order)
	local button = Instance.new("TextButton")
	button.Name = label:gsub("%s+", "") .. "Button"
	local sizeScale = Instance.new("UIScale", button)
	sizeScale.Name = "QuickButtonSizeScale"
	sizeScale.Scale = _G.__CrystalButtonsSize or 1

	local BTN_W = 72
	local BTN_H = 58
	local buttonGap = 7
	local CORNER_R = 12
	button.Size = UDim2.new(0, BTN_W, 0, BTN_H)

	local baseY = (isMobile and 72 or 81)
	local leftX = isMobile and 12 or 16
	if order <= 3 then
	button.Position = UDim2.new(0, leftX, 0, baseY + (order - 1) * (BTN_H + buttonGap))
	else
	local idx = (order - 4)
	button.Position = UDim2.new(0, leftX + BTN_W + buttonGap, 0, baseY + idx * (BTN_H + buttonGap))
	end
	button.LayoutOrder = order
	button:SetAttribute("OriginalPosition", button.Position)
	button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	button.BackgroundTransparency = 0
	button.BorderSizePixel = 0
	button.AutoButtonColor = false
	button.Active = true
	button.Draggable = false
	button.Font = Enum.Font.GothamBold
	button.Text = label
	button.TextScaled = true
	button.TextWrapped = true
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
	button.TextStrokeTransparency = 0.35
	button.ZIndex = 751
	button.Parent = quickButtons
	Instance.new("UICorner", button).CornerRadius = UDim.new(0, CORNER_R)
	local textSizeConstraint = Instance.new("UITextSizeConstraint")
	textSizeConstraint.MinTextSize = 11
	textSizeConstraint.MaxTextSize = 15
	textSizeConstraint.Parent = button
	local stroke = Instance.new("UIStroke")
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Thickness = 1.2
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Transparency = 0.2
	stroke.Parent = button
	return button, stroke
	end

	local aimbotButton, aimbotStroke = makeQuickButton("AIMBOT", 1)
	local autoBatButton, autoBatStroke = makeQuickButton("BAT TP", 2)
	local tpDownButton, tpDownStroke = makeQuickButton("TP DOWN", 3)
	local dropButton, dropStroke = makeQuickButton("DROP", 4)
	local carrySpeedButton, carrySpeedStroke = makeQuickButton("CARRY SPEED", 5)
	local speedModeButton, speedModeStroke = makeQuickButton("LAGGER SPEED", 6)
	local autoLeftButton, autoLeftStroke = makeQuickButton("AUTO LEFT", 7)
	local autoRightButton, autoRightStroke = makeQuickButton("AUTO RIGHT", 8)
	local quickTapBlocked = {}
	quickTapBlocked.custom = {}
	quickTapBlocked.custom.button, quickTapBlocked.custom.stroke = makeQuickButton("CUSTOM SPEED", 9)

	quickTapBlocked.custom.button.Visible = true

	quickTapBlocked.custom.getByName = function(name)
	for _, customSpeed in ipairs(customSpeeds) do
	if customSpeed.name == name then return customSpeed end
	end
	return nil
	end

	quickTapBlocked.custom.getSelected = function()
	local selectedCustomSpeed = quickTapBlocked.custom.getByName(selectedMode)
	if selectedCustomSpeed then
	quickTapBlocked.custom.lastName = selectedCustomSpeed.name
	return selectedCustomSpeed
	end
	return quickTapBlocked.custom.getByName(quickTapBlocked.custom.lastName) or customSpeeds[1]
	end

	local function setQuickVisual(button, stroke, active)

	if active then
	local accent = typeof(_G.__CrystalCurtAccent) == "Color3" and _G.__CrystalCurtAccent or Color3.fromRGB(220, 70, 70)
	button.BackgroundColor3 = accent
	button.BackgroundTransparency = 0
	button.TextColor3 = Color3.fromRGB(20, 6, 2)
	button.TextStrokeTransparency = 0.5
	stroke.Color = accent:Lerp(Color3.fromRGB(255, 255, 255), 0.24)
	stroke.Thickness = 1.6
	stroke.Transparency = 0.1
	else
	button.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	button.BackgroundTransparency = 0
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextStrokeTransparency = 0.35
	stroke.Color = Color3.fromRGB(0, 0, 0)
	stroke.Thickness = 1.2
	stroke.Transparency = 0.2
	end
	end

	local function toggleQuickFeature(featureName)
	local blockedWhileStealing = {}
	local newState = not (toggleStates[featureName] == true)
	if newState and blockedWhileStealing[featureName] and Player:GetAttribute("Stealing") == true then
	return
	end
	toggleStates[featureName] = newState
	if toggleStateSetters[featureName] then pcall(toggleStateSetters[featureName], newState) end
	if FeaturePostToggle[featureName] then pcall(FeaturePostToggle[featureName], newState) end
	saveConfig()
	end

	local movableButtons = {
	aimbotButton, autoBatButton, tpDownButton,
	dropButton, carrySpeedButton, speedModeButton, autoLeftButton, autoRightButton, quickTapBlocked.custom.button,
	}

	task.defer(function()
	for _, button in ipairs(movableButtons) do
	local saved = quickButtonPositions[button.Name]
	if saved and saved.x and saved.y then
	local x, y = placeInsideViewport(button, 0, saved.x, 0, saved.y, _G.__CrystalButtonsSize or 1)
	button.Position = UDim2.new(0, x, 0, y)
	quickButtonPositions[button.Name] = { x = x, y = y }
	else
	local position = button.Position
	placeInsideViewport(button, position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset, _G.__CrystalButtonsSize or 1)
	end
	end
	end)

	local draggingQuickButton = nil
	local quickDragStart = nil
	local quickDragPosition = nil
	local quickDragInput = nil

	local quickDragMoved = false
	_G.__CrystalSetButtonsSize = function(value)
		local size = tonumber((tostring(value):gsub(",", ".")))
		if not size or size ~= size or math.abs(size) == math.huge then return _G.__CrystalButtonsSize end
		size = math.floor(math.clamp(size, 0.5, 2) * 100 + 0.5) / 100
		_G.__CrystalButtonsSize = size
		draggingQuickButton, quickDragStart, quickDragPosition, quickDragInput = nil, nil, nil, nil
		quickDragMoved = false
		for _, button in ipairs(movableButtons) do
			button.QuickButtonSizeScale.Scale = size
			local position = button.Position
			local x, y = placeInsideViewport(button, position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset, size)
			if quickButtonPositions[button.Name] then quickButtonPositions[button.Name] = {x = x, y = y} end
		end
		saveConfig()
		return size
	end
	quickTapBlocked.resetPositions = function()

	if draggingQuickButton then
	local button = draggingQuickButton
	quickTapBlocked[button] = true
	task.delay(0.2, function() quickTapBlocked[button] = nil end)
	end
	draggingQuickButton = nil
	quickDragStart = nil
	quickDragPosition = nil
	quickDragInput = nil
	quickDragMoved = false
	table.clear(quickButtonPositions)
	for _, button in ipairs(movableButtons) do
	local position = button:GetAttribute("OriginalPosition")
	placeInsideViewport(button, position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset, _G.__CrystalButtonsSize or 1)
	end
	_G.__CrystalGuiPositionsReset = true
	for _, resetPosition in pairs(_G.__CrystalGuiPositionResetters) do
	resetPosition()
	end
	saveConfig()
	end
	_G.__CrystalResetButtonPositions = quickTapBlocked.resetPositions
	local function quickButtonsAreLocked()
	return toggleStates["Lock Buttons"] == true
	end
	local function updateQuickButtonPosition(input)
	if not draggingQuickButton or not quickDragStart or not quickDragPosition then return end
	local delta = input.Position - quickDragStart
	if delta.Magnitude > 6 then
	quickDragMoved = true
	end
	local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(0, 0)
	local size = draggingQuickButton.AbsoluteSize
	local x = math.clamp(quickDragPosition.X.Offset + delta.X, 0, math.max(0, viewport.X - size.X))
	local y = math.clamp(quickDragPosition.Y.Offset + delta.Y, 0, math.max(0, viewport.Y - size.Y))
	draggingQuickButton.Position = UDim2.new(0, x, 0, y)
	end
	for _, button in ipairs(movableButtons) do
	button.InputBegan:Connect(function(input)
	if quickButtonsAreLocked() then return end
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
	draggingQuickButton = button
	quickDragStart = input.Position
	quickDragPosition = button.Position
	quickDragInput = input
	quickDragMoved = false
	end
	end)
	end
	_G.__CrystalTrackConn(UserInputService.InputChanged:Connect((function(input)
	if not draggingQuickButton or quickButtonsAreLocked() then return end
	if input.UserInputType == Enum.UserInputType.MouseMovement or input == quickDragInput then
	updateQuickButtonPosition(input)
	end
	end)))
	_G.__CrystalTrackConn(UserInputService.InputEnded:Connect(function(input)
	local isMouseRelease = quickDragInput and quickDragInput.UserInputType == Enum.UserInputType.MouseButton1 and input.UserInputType == Enum.UserInputType.MouseButton1
	if draggingQuickButton and (input == quickDragInput or isMouseRelease) then
	local movedButton = draggingQuickButton
	draggingQuickButton = nil
	quickDragStart = nil
	quickDragPosition = nil
	quickDragInput = nil
	if quickDragMoved then
	quickButtonPositions[movedButton.Name] = {
	x = movedButton.Position.X.Offset,
	y = movedButton.Position.Y.Offset,
	}
	saveConfig()

	quickTapBlocked[movedButton] = true
	task.delay(0.2, function()
	quickTapBlocked[movedButton] = nil
	end)
	end
	end
	end))

	local function connectQuickButton(button, callback)
	button.Activated:Connect(function()
	if quickTapBlocked[button] then
	quickTapBlocked[button] = nil
	return
	end
	callback()
	end)
	end
	connectQuickButton(aimbotButton, function() toggleQuickFeature("Aimbot") end)
	connectQuickButton(autoBatButton, function()

	-- TP Bat removed
	if false and _G.CrystalAutoBat and _G.CrystalAutoBat.Toggle then
	pcall(_G.CrystalAutoBat.Toggle)
	else
	-- toggleQuickFeature("TP Bat")
	end
	end)
	connectQuickButton(tpDownButton, function()
	if FeatureToggles["TP Down"] then pcall(FeatureToggles["TP Down"]) end
	end)
	connectQuickButton(dropButton, function()
	if FeatureToggles["Drop"] then pcall(FeatureToggles["Drop"], "button") end
	end)
	connectQuickButton(carrySpeedButton, function()

	if carrySpeedMode == "v2" then
	speedToggled = not speedToggled
	toggleStates["Carry Speed"] = speedToggled

	toggleStates["Speed Boost"] = true
	if _G.__refreshSpeedBoost then pcall(_G.__refreshSpeedBoost) end
	if toggleVisualUpdaters["Carry Speed"] then toggleVisualUpdaters["Carry Speed"]() end
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	saveConfig()
	elseif FeatureToggles["Carry Speed"] then
	pcall(FeatureToggles["Carry Speed"])
	else
	toggleQuickFeature("Carry Speed")
	end
	end)
	connectQuickButton(speedModeButton, function()
	if selectedMode == "Lagger" then
	if FeatureToggles["SelectNormalMode"] then pcall(FeatureToggles["SelectNormalMode"]) end
	else
	if FeatureToggles["SelectLaggerMode"] then pcall(FeatureToggles["SelectLaggerMode"]) end
	end
	end)
	connectQuickButton(autoLeftButton, function()
	if FeatureToggles["Auto Left"] then
	pcall(FeatureToggles["Auto Left"])
	end
	end)
	connectQuickButton(autoRightButton, function()
	if FeatureToggles["Auto Right"] then
	pcall(FeatureToggles["Auto Right"])
	end
	end)
	connectQuickButton(quickTapBlocked.custom.button, function()
	local customSpeed = quickTapBlocked.custom.getSelected()
	if customSpeed and selectedMode ~= customSpeed.name then
	selectMode(customSpeed.name)
	end
	end)
	local quickUpdateAccumulator = 0
	local quickLast = {}
	_G.__CrystalRefreshQuickButtonTheme = function()
		quickLast = {}
	end
	_G.__CrystalTrackConn(RunService.Heartbeat:Connect((function(dt)
	quickUpdateAccumulator = quickUpdateAccumulator + (dt or 0)
	if quickUpdateAccumulator < 0.40 then return end
	quickUpdateAccumulator = 0
	local showButtons = toggleStates["Show Buttons"] == true
	if quickLast.show ~= showButtons then quickButtons.Visible = showButtons; quickLast.show = showButtons end
	if not showButtons then return end
	local aimbotActive = toggleStates["Aimbot"] == true
	local autoBatActive = toggleStates["TP Bat"] == true
	local carryActive = toggleStates["Carry Speed"] == true
	local autoLeftIsActive = toggleStates["Auto Left"] == true
	local autoRightIsActive = toggleStates["Auto Right"] == true
	local activeCustomSpeed = quickTapBlocked.custom.getByName(selectedMode)
	local quickCustomSpeed = activeCustomSpeed or quickTapBlocked.custom.getSelected()
	if quickLast.carryVisible ~= true then carrySpeedButton.Visible = true; quickLast.carryVisible = true end
	if quickLast.aimbot ~= aimbotActive then setQuickVisual(aimbotButton, aimbotStroke, aimbotActive); quickLast.aimbot = aimbotActive end
	if quickLast.autoBat ~= autoBatActive then setQuickVisual(autoBatButton, autoBatStroke, autoBatActive); quickLast.autoBat = autoBatActive end
	if quickLast.carry ~= carryActive then setQuickVisual(carrySpeedButton, carrySpeedStroke, carryActive); quickLast.carry = carryActive end
	if quickLast.autoLeft ~= autoLeftIsActive then setQuickVisual(autoLeftButton, autoLeftStroke, autoLeftIsActive); quickLast.autoLeft = autoLeftIsActive end
	if quickLast.autoRight ~= autoRightIsActive then setQuickVisual(autoRightButton, autoRightStroke, autoRightIsActive); quickLast.autoRight = autoRightIsActive end
	local customSpeedName = quickCustomSpeed and quickCustomSpeed.name or nil
	if quickLast.customName ~= customSpeedName or quickLast.customActive ~= (activeCustomSpeed ~= nil) then
	quickTapBlocked.custom.button.Text = customSpeedName and ("CUSTOM\n" .. string.upper(customSpeedName)) or "NO CUSTOM"
	setQuickVisual(quickTapBlocked.custom.button, quickTapBlocked.custom.stroke, activeCustomSpeed ~= nil)
	quickLast.customName = customSpeedName
	quickLast.customActive = activeCustomSpeed ~= nil
	end
	local isLaggerSpeed = selectedMode == "Lagger"
	if quickLast.lagger ~= isLaggerSpeed then
	speedModeButton.Text = isLaggerSpeed and "NORMAL SPEED" or "LAGGER SPEED"
	setQuickVisual(speedModeButton, speedModeStroke, isLaggerSpeed)
	quickLast.lagger = isLaggerSpeed
	end
	if quickLast.actionsInitialized ~= true then
	setQuickVisual(tpDownButton, tpDownStroke, false)
	setQuickVisual(dropButton, dropStroke, false)
	quickLast.actionsInitialized = true
	end
	end)))
	end

	do
	local panelsSection = makeUraniumSection(tabPages.Visuals, "PANELS")
	pcall(function() panelsSection.Visible = false end)
	local panelsPanel = Instance.new("Frame", panelsSection)
	panelsPanel.Size = UDim2.new(1, -10, 0, 104)
	panelsPanel.Position = UDim2.new(0, 5, 0, 28)
	panelsPanel.BackgroundColor3 = Color3.fromRGB(20, 22, 31)
	panelsPanel.BackgroundTransparency = 0.12
	panelsPanel.BorderSizePixel = 0
	Instance.new("UICorner", panelsPanel).CornerRadius = UDim.new(0, 8)
	local panelsPanelStroke = Instance.new("UIStroke", panelsPanel)
	panelsPanelStroke.Color = Color3.fromRGB(0, 0, 0)
	panelsPanelStroke.Thickness = 1.2
	panelsPanelStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	panelsPanelStroke.Transparency = 0.15

	local row = Instance.new("Frame", panelsPanel)
	row.Size = UDim2.new(1, -18, 0, 30)
	row.Position = UDim2.new(0, 9, 0, 10)
	row.BackgroundTransparency = 1

	local laggerBtn = Instance.new("TextButton", row)
	laggerBtn.Size = UDim2.new(1, 0, 1, 0)
	laggerBtn.Position = UDim2.new(0, 0, 0, 0)
	laggerBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 38)
	laggerBtn.BackgroundTransparency = 0.15
	laggerBtn.BorderSizePixel = 0
	laggerBtn.Text = "LAGGER"
	laggerBtn.Visible = false
	laggerBtn.TextColor3 = Color3.fromRGB(50, 110, 190)
	laggerBtn.TextSize = 11
	laggerBtn.Font = Enum.Font.GothamBold
	laggerBtn.AutoButtonColor = false
	Instance.new("UICorner", laggerBtn).CornerRadius = UDim.new(0, 6)
	local laggerStroke = Instance.new("UIStroke", laggerBtn)
	laggerStroke.Color = Color3.fromRGB(0, 0, 0)
	laggerStroke.Thickness = 1
	laggerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	local laggerToggled = false

	local function updateLaggerVisual()
	laggerBtn.BackgroundColor3 = laggerToggled and Color3.fromRGB(80, 160, 255) or Color3.fromRGB(30, 30, 38)
	laggerBtn.TextColor3 = laggerToggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(50, 110, 190)
		laggerStroke.Color = laggerToggled and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(0, 0, 0)
	laggerStroke.Thickness = laggerToggled and 1.5 or 1
	end

	(function()

	local animationPresets = {
	["Cartoon"] = { RunAnim=742638842, WalkAnim=742640026, JumpAnim=742637942, FallAnim=742637151, Swim=742639220, SwimIdle=742639812, ClimbAnim=742636889, Idle={742637544,742638445,885477856} },
	["Adidas Community"] = { WalkAnim=122150855457006, RunAnim=82598234841035, JumpAnim=75290611992385, FallAnim=98600215928904, SwimIdle=109346520324160, Swim=133308483266208, Animation1=122257458498464, Animation2=102357151005774, ClimbAnim=88763136693023 },
	["Adidas Aura"] = { WalkAnim=83842218823011, RunAnim=118320322718866, JumpAnim=109996626521204, FallAnim=95603166884636, SwimIdle=94922130551805, Swim=134530128383903, Animation1=110211186840347, Animation2=114191137265065, ClimbAnim=97824616490448 },
	["Zombie"] = { WalkAnim=10921355261, RunAnim=616163682, JumpAnim=10921351278, FallAnim=10921350320, SwimIdle=10921353442, Swim=10921352344, Animation1=10921344533, Animation2=10921345304, ClimbAnim=10921343576 },
	["Catwalk Glam"] = { WalkAnim=109168724482748, RunAnim=81024476153754, JumpAnim=116936326516985, FallAnim=92294537340807, SwimIdle=98854111361360, Swim=134591743181628, ClimbAnim=119377220967554, Animation1=133806214992291, Animation2=94970088341563 },
	["Toy"] = { WalkAnim=10921312010, RunAnim=10921306285, JumpAnim=10921308158, FallAnim=10921307241, SwimIdle=10921310341, Swim=10921309319, ClimbAnim=10921300839, Animation1=10921301576 },
	["Amazon Unboxed"] = { WalkAnim=90478085024465, RunAnim=134824450619865, JumpAnim=121454505477205, FallAnim=94788218468396, SwimIdle=129126268464847, Swim=105962919001086, ClimbAnim=121145883950231, Animation1=98281136301627 },
	["Vampire"] = { WalkAnim=10921326949, RunAnim=10921320299, JumpAnim=10921322186, FallAnim=10921321317, SwimIdle=10921325443, Swim=10921324408, ClimbAnim=10921314188, Animation1=10921315373 },
	["Ninja"] = { RunAnim=656118852, WalkAnim=656121766, JumpAnim=656117878, FallAnim=656115606, Swim=656119721, SwimIdle=656121397, ClimbAnim=656114359, Idle={656117400,656118341,886742569} },
	}

	local animationPresetOrder = {
	"Cartoon",
	"Adidas Community",
	"Adidas Aura",
	"Zombie",
	"Catwalk Glam",
	"Toy",
	"Amazon Unboxed",
	"Vampire",
	"Ninja",
	}

	local currentPresetIndex = 1
	local currentPresetName = animationPresetOrder[1]

	local function normalizeAnimValue(value)
	if not value then return nil end
	if type(value) == "number" then return "rbxassetid://" .. tostring(value) end
	if type(value) == "string" then
	if string.sub(value, 1, 11) == "rbxassetid://" then return value end
	if string.match(value, "^%d+$") then return "rbxassetid://" .. value end
	return value
	end
	return nil
	end

	local function buildAnimPackFromPreset(preset)
	local idle = preset and preset.Idle
	return {
	idle1 = normalizeAnimValue(preset and (preset.Animation1 or (idle and idle[1]))),
	idle2 = normalizeAnimValue(preset and (preset.Animation2 or (idle and idle[2]))),
	walk = normalizeAnimValue(preset and (preset.WalkAnim or preset.Walk)),
	run = normalizeAnimValue(preset and (preset.RunAnim or preset.Run)),
	jump = normalizeAnimValue(preset and (preset.JumpAnim or preset.Jump)),
	fall = normalizeAnimValue(preset and (preset.FallAnim or preset.Fall)),
	climb = normalizeAnimValue(preset and (preset.ClimbAnim or preset.Climb)),
	swim = normalizeAnimValue(preset and (preset.Swim or preset.SwimAnim)),
	swimidle = normalizeAnimValue(preset and (preset.SwimIdle or preset.SwimIdleAnim)),
	}
	end

	local function applyAnimationsToCharacter(char, animPack)
	if not char or not animPack then return false end
	local animate = char:FindFirstChild("Animate")
	if not animate then
	animate = Instance.new("Animation")
	animate.Name = "Animate"
	animate.Parent = char
	end

	_G.__ZurichHub_OriginalAnims = _G.__ZurichHub_OriginalAnims or {}
	local playerKey = tostring(Player.UserId or "local")
	if not _G.__ZurichHub_OriginalAnims[playerKey] then
	local originals = {}
	for _, containerName in ipairs({"idle","walk","run","jump","fall","climb","swim","swimidle"}) do
	local cont = animate:FindFirstChild(containerName)
	if cont then
	for _, child in ipairs(cont:GetChildren()) do
	pcall(function()
	originals[containerName .. "." .. child.Name] = child.AnimationId
	end)
	end
	end
	end
	_G.__ZurichHub_OriginalAnims[playerKey] = originals
	end

	local function ensureAnim(parent, name)
	local obj = parent:FindFirstChild(name)
	if not obj then
	obj = Instance.new("Animation")
	obj.Name = name
	obj.Parent = parent
	end
	return obj
	end

	local function setAnim(container, animName, id)
	if not id then return end
	local animObj = container:FindFirstChild(animName)
	if not animObj then
	animObj = Instance.new("Animation")
	animObj.Name = animName
	animObj.Parent = container
	end
	animObj.AnimationId = id
	end

	local idle = ensureAnim(animate, "idle")
	local walk = ensureAnim(animate, "walk")
	local run = ensureAnim(animate, "run")
	local jump = ensureAnim(animate, "jump")
	local fall = ensureAnim(animate, "fall")
	local climb = ensureAnim(animate, "climb")
	local swim = ensureAnim(animate, "swim")
	local swimidle = ensureAnim(animate, "swimidle")

	setAnim(idle, "Animation1", animPack.idle1)
	setAnim(idle, "Animation2", animPack.idle2)
	setAnim(walk, "WalkAnim", animPack.walk)
	setAnim(run, "RunAnim", animPack.run)
	setAnim(jump, "JumpAnim", animPack.jump)
	setAnim(fall, "FallAnim", animPack.fall)
	setAnim(climb, "ClimbAnim", animPack.climb)
	setAnim(swim, "Swim", animPack.swim)
	setAnim(swimidle, "SwimIdle", animPack.swimidle)

	_G.__ZurichHub_Anims = _G.__ZurichHub_Anims or {}
	for key, value in pairs(animPack) do
	if value then _G.__ZurichHub_Anims[key] = value end
	end

	local hum = char:FindFirstChildOfClass("Humanoid")
	if hum then
	for _, track in ipairs(hum:GetPlayingAnimationTracks()) do
	pcall(function() track:Stop(0) end)
	end
	end

	return true
	end

	local function restoreOriginalAnims(char)
	if not char then return false end
	local playerKey = tostring(Player.UserId or "local")
	local saved = _G.__ZurichHub_OriginalAnims and _G.__ZurichHub_OriginalAnims[playerKey]
	if not saved then return false end
	local animate = char:FindFirstChild("Animate")
	if not animate then return false end
	for key, animId in pairs(saved) do
	local sep = string.find(key, "%.")
	if sep then
	local containerName = string.sub(key, 1, sep - 1)
	local childName = string.sub(key, sep + 1)
	local cont = animate:FindFirstChild(containerName)
	if not cont then
	cont = Instance.new("Animation")
	cont.Name = containerName
	cont.Parent = animate
	end
	local child = cont:FindFirstChild(childName)
	if not child then
	child = Instance.new("Animation")
	child.Name = childName
	child.Parent = cont
	end
	pcall(function() child.AnimationId = animId end)
	end
	end
	return true
	end

	local function applyAnimationPreset(presetName)
	local preset = animationPresets[presetName]
	if not preset then return false end
	local animPack = buildAnimPackFromPreset(preset)
	local char = Player.Character
	if char then
	return applyAnimationsToCharacter(char, animPack)
	else
	currentPresetName = presetName
	_G.__pendingAnimationPreset = presetName
	return true
	end
	end

	local CONFIG_FILE = "AnimationSelector_Config.txt"
	local animsEnabled = false

	local function saveAnimConfig()
	local currPreset = currentPresetName or animationPresetOrder[currentPresetIndex] or "Cartoon"
	local data = { presetIndex = currentPresetIndex, presetName = currPreset, enabled = animsEnabled }
	local ok, json = pcall(function() return HttpService:JSONEncode(data) end)
	if ok then pcall(function() writefile(CONFIG_FILE, json) end) end
	end

	local function loadAnimConfig()
	local ok, hasFile = pcall(function() return isfile(CONFIG_FILE) end)
	if not ok or not hasFile then return false end
	local ok2, json = pcall(function() return readfile(CONFIG_FILE) end)
	if not ok2 or not json or json == "" then return false end
	local ok3, data = pcall(function() return HttpService:JSONDecode(json) end)
	if not ok3 or not data then return false end

	if data.presetName and animationPresets[data.presetName] then
	currentPresetName = data.presetName
	for i, presetName in ipairs(animationPresetOrder) do
	if presetName == data.presetName then
	currentPresetIndex = i
	break
	end
	end
	elseif data.presetIndex and data.presetIndex >= 1 and data.presetIndex <= #animationPresetOrder then
	currentPresetIndex = data.presetIndex
	currentPresetName = animationPresetOrder[currentPresetIndex]
	end

	if currentPresetName == nil then
	currentPresetName = animationPresetOrder[currentPresetIndex or 1]
	end

	animsEnabled = false
	return true
	end

	pcall(loadAnimConfig)
	if animsEnabled and currentPresetName and animationPresets[currentPresetName] then
	pcall(function() applyAnimationPreset(currentPresetName) end)
	end
	if animsEnabled and currentPresetName and Player.Character then
	pcall(function() applyAnimationPreset(currentPresetName) end)
	end

	local animSection = makeUraniumSection(tabPages.Visuals, "ANIMATION PACK")

	do
	local parentSection = animSection and animSection.Parent
	if parentSection then
	for _, child in ipairs(parentSection:GetChildren()) do
	if child:IsA("Frame") then
	local lab = child:FindFirstChildOfClass("TextLabel")
	if lab and lab.Text == string.upper("ANIMATION PACK") then
	for _, f in ipairs(child:GetChildren()) do
	if f:IsA("Frame") and f.Size and f.Size.Y and f.Size.Y.Offset == 1 then
	f:Destroy()
	break
	end
	end
	break
	end
	end
	end
	end
	end
	local sectionFrame = animSection
	local container = Instance.new("Frame", sectionFrame)
	container.Size = UDim2.new(1, -10, 0, 68)
	container.Position = UDim2.new(0, 5, 0, 30)
	container.BackgroundColor3 = Color3.fromRGB(20, 22, 31)
	container.BackgroundTransparency = 0.12
	container.BorderSizePixel = 0
	container.Parent = animSection
	Instance.new("UICorner", container).CornerRadius = UDim.new(0,8)
	local containerStroke = Instance.new("UIStroke", container)
	containerStroke.Color = Color3.fromRGB(0, 0, 0)
	containerStroke.Thickness = 1.2
	containerStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	containerStroke.Transparency = 0.15

	local animTogglePanel = Instance.new("Frame", container)
	animTogglePanel.Size = UDim2.new(0, 72, 1, -10)
	animTogglePanel.Position = UDim2.new(0, 6, 0, 5)
	animTogglePanel.BackgroundColor3 = Color3.fromRGB(32, 35, 42)
	animTogglePanel.BackgroundTransparency = 0.08
	animTogglePanel.BorderSizePixel = 0
	Instance.new("UICorner", animTogglePanel).CornerRadius = UDim.new(0, 7)

	pcall(loadAnimConfig)
	if animsEnabled and currentPresetName and animationPresets[currentPresetName] then
	pcall(function() applyAnimationPreset(currentPresetName) end)
	end

	local animToggleBtn = Instance.new("TextButton", animTogglePanel)
	animToggleBtn.Size = UDim2.new(1, -8, 1, -8)
	animToggleBtn.Position = UDim2.new(0, 4, 0, 4)
	animToggleBtn.BackgroundColor3 = Color3.fromRGB(50, 55, 64)
	animToggleBtn.BorderSizePixel = 0
	animToggleBtn.Text = "OFF"
	animToggleBtn.TextColor3 = Color3.fromRGB(245, 247, 250)
	animToggleBtn.TextSize = 10
	animToggleBtn.Font = Enum.Font.GothamBold
	animToggleBtn.AutoButtonColor = false
	animToggleBtn.TextWrapped = false
	animToggleBtn.ZIndex = 6
	Instance.new("UICorner", animToggleBtn).CornerRadius = UDim.new(0, 5)
	pcall(function(parent)
	local stroke = Instance.new("UIStroke", parent)
	stroke.Color = Color3.fromRGB(255, 255, 255)
	stroke.Thickness = 0.8
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	end, animToggleBtn)

	local function updateAnimToggleVisual()
	animToggleBtn.Text = animsEnabled and "ON" or "OFF"
	animToggleBtn.BackgroundColor3 = animsEnabled and Color3.fromRGB(82, 140, 220) or Color3.fromRGB(52, 58, 68)
	animToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	animToggleBtn.Font = Enum.Font.GothamBold
	end

	animToggleBtn.Activated:Connect(function()
	animsEnabled = not animsEnabled
	updateAnimToggleVisual()
	if animsEnabled then
	applyAnimationPreset(currentPresetName)
	elseif Player.Character then
	restoreOriginalAnims(Player.Character)
	end
	saveAnimConfig()
	end)

	local leftBtn = Instance.new("TextButton")
	leftBtn.Size = UDim2.new(0, 32, 0, 32)
	leftBtn.Position = UDim2.new(0, 88, 0.5, -16)
	leftBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	leftBtn.BackgroundTransparency = 0.15
	leftBtn.BorderSizePixel = 0
	leftBtn.Text = "◄"
	leftBtn.TextColor3 = Color3.fromRGB(240,245,255)
	leftBtn.TextSize = 20
	leftBtn.Font = Enum.Font.GothamBold
	leftBtn.AutoButtonColor = false
	leftBtn.ZIndex = 5
	leftBtn.Parent = container
	pcall(function(parent)
	local corner = Instance.new("UICorner", parent)
	corner.CornerRadius = UDim.new(0,5)
	local stroke = Instance.new("UIStroke", parent)
	stroke.Color = Color3.fromRGB(255,255,255)
	stroke.Thickness = 0.8
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	end, leftBtn)

	local selectorFrame = Instance.new("Frame")
	selectorFrame.Name = "AnimationPackSelector"
	selectorFrame.Size = UDim2.new(1, -122, 0, 30)
	selectorFrame.Position = UDim2.new(0, 108, 0, 19)
	selectorFrame.BackgroundTransparency = 1
	selectorFrame.Parent = container

	local titleLabel = Instance.new("TextLabel")
	titleLabel.Size = UDim2.new(1, -36, 1, 0)
	titleLabel.BackgroundTransparency = 1
	titleLabel.Text = tostring(currentPresetName or "")
	titleLabel.TextColor3 = Color3.fromRGB(240, 245, 255)
	titleLabel.TextSize = 12
	titleLabel.Font = Enum.Font.GothamBold
	titleLabel.TextXAlignment = Enum.TextXAlignment.Center
	titleLabel.TextYAlignment = Enum.TextYAlignment.Center
	titleLabel.ZIndex = 5
	titleLabel.Parent = selectorFrame
	titleLabel.AnchorPoint = Vector2.new(0.5, 0.5)

	titleLabel.Position = UDim2.new(0.5, 0, 0.5, 4)
	pcall(function(parent)
	local stroke = Instance.new("UIStroke", parent)
	stroke.Color = Color3.fromRGB(255,255,255)
	stroke.Thickness = 0.8
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	stroke.Transparency = 1
	end, titleLabel)

	local rightBtn = Instance.new("TextButton")
	rightBtn.Size = UDim2.new(0, 32, 0, 32)
	rightBtn.Position = UDim2.new(1, -32, 0.5, -16)
	rightBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	rightBtn.BackgroundTransparency = 0.15
	rightBtn.BorderSizePixel = 0
	rightBtn.Text = "►"
	rightBtn.TextColor3 = Color3.fromRGB(240,245,255)
	rightBtn.TextSize = 20
	rightBtn.Font = Enum.Font.GothamBold
	rightBtn.AutoButtonColor = false
	rightBtn.ZIndex = 5
	rightBtn.Parent = selectorFrame
	pcall(function(parent)
	local corner = Instance.new("UICorner", parent)
	corner.CornerRadius = UDim.new(0,5)
	local stroke = Instance.new("UIStroke", parent)
	stroke.Color = Color3.fromRGB(255,255,255)
	stroke.Thickness = 0.8
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	end, rightBtn)

	local function updateTitle(t, direction)
	direction = direction or "next"
	titleLabel.Text = tostring(t or "")
	titleLabel.TextTransparency = 1
	titleLabel.Position = UDim2.new(0.5, direction == "next" and -90 or 90, 0.5, 0)
	TweenService:Create(titleLabel, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
	Position = UDim2.new(0.5, 0, 0.5, 0),
	TextTransparency = 0,
	}):Play()
	end

	local function changePreset(direction)
	local newIdx = currentPresetIndex + (direction == "next" and 1 or -1)
	if newIdx < 1 then newIdx = #animationPresetOrder end
	if newIdx > #animationPresetOrder then newIdx = 1 end
	currentPresetIndex = newIdx
	currentPresetName = animationPresetOrder[currentPresetIndex]
	updateTitle(currentPresetName, direction)
	if animsEnabled then
	applyAnimationPreset(currentPresetName)
	else
	if Player.Character then
	restoreOriginalAnims(Player.Character)
	end
	end
	saveAnimConfig()
	local btn = (direction == "next") and rightBtn or leftBtn
	TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(0,80,180)}):Play()
	task.delay(0.08, function() TweenService:Create(btn, TweenInfo.new(0.08), {BackgroundColor3 = Color3.fromRGB(30,30,38)}):Play() end)
	end

	leftBtn.MouseButton1Click:Connect(function() changePreset("prev") end)
	rightBtn.MouseButton1Click:Connect(function() changePreset("next") end)

	leftBtn.Parent = selectorFrame
	rightBtn.Parent = selectorFrame
	titleLabel.Parent = selectorFrame
	updateAnimToggleVisual()
	if animsEnabled and currentPresetName then
	pcall(function() applyAnimationPreset(currentPresetName) end)
	end

	leftBtn.Position = UDim2.new(0, -8, 0.5, -12)
	rightBtn.Position = UDim2.new(1, -24, 0.5, -12)

	leftBtn.MouseEnter:Connect(function()
	TweenService:Create(leftBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
	end)
	leftBtn.MouseLeave:Connect(function()
	TweenService:Create(leftBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.15, TextColor3 = Color3.fromRGB(240,245,255)}):Play()
	end)
	rightBtn.MouseEnter:Connect(function()
	TweenService:Create(rightBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
	end)
	rightBtn.MouseLeave:Connect(function()
	TweenService:Create(rightBtn, TweenInfo.new(0.15), {BackgroundTransparency = 0.15, TextColor3 = Color3.fromRGB(240,245,255)}):Play()
	end)

	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function(char)
	task.wait(0.5)
	if animsEnabled then
	local animPack = buildAnimPackFromPreset(animationPresets[currentPresetName])
	applyAnimationsToCharacter(char, animPack)
	end
	end))

	task.spawn(function()
	task.wait(0.5)
	if Player.Character and animsEnabled then
	local animPack = buildAnimPackFromPreset(animationPresets[currentPresetName])
	applyAnimationsToCharacter(Player.Character, animPack)
	end
	end)
	end)()

	_G.__CrystalReadSavedPanelVisibility = function(settingsFile)
	if typeof(readfile) ~= "function" or typeof(isfile) ~= "function" then return false, false end
	local ok, data = pcall(function()
	if not isfile(settingsFile) then return nil end
	return HttpService:JSONDecode(readfile(settingsFile))
	end)
	if not ok or type(data) ~= "table" then return false, false end
	return true, data.visible == true
	end

	local function openLaggerGUI(openPanel)
	-- Lagger panel removed
	pcall(function()
		local pg = Player:FindFirstChild("PlayerGui")
		if not pg then return end
		local gui = pg:FindFirstChild("CrystalLaggerGUI")
		if gui then gui:Destroy() end
	end)
	_G.CrystalLagger = {
		Stop = function() end,
		ResetPosition = function() end,
		IsEnabled = function() return false end,
		IsLowEndEnabled = function() return false end,
		Toggle = function() return false end,
		ToggleLowEnd = function() return false end,
		SetEnabled = function() end,
		SetLowEndEnabled = function() end,
		SetVisible = function() end,
		SaveSettings = function() end,
		SetBackground = function() end,
	}
	_G._CrystalLaggerGUILoaded = false
	_G.__openLaggerGUI = openLaggerGUI
	end

	local function closeLaggerGUI()
		laggerToggled = false
		pcall(updateLaggerVisual)
		pcall(function()
			local pg = Player:FindFirstChild("PlayerGui")
			local gui = pg and pg:FindFirstChild("CrystalLaggerGUI")
			if gui then gui:Destroy() end
		end)
	end

	connectBtn(laggerBtn, function()
	laggerToggled = not laggerToggled
	updateLaggerVisual()

	if laggerToggled then
	if _G._CrystalLaggerGUILoaded then
	if _G.CrystalLagger and _G.CrystalLagger.SetVisible then
	_G.CrystalLagger.SetVisible(true)
	end
	if _G.CrystalLagger and _G.CrystalLagger.SaveSettings then
	_G.CrystalLagger.SaveSettings()
	end
	else
	openLaggerGUI(true)
	end
	else
	closeLaggerGUI()
	end
	end)

	do
	local laggerHasSavedState, laggerSavedVisible = _G.__CrystalReadSavedPanelVisibility("CrystalLagger_Settings.json")
	laggerToggled = laggerHasSavedState and laggerSavedVisible or false
	updateLaggerVisual()
	pcall(openLaggerGUI, false)
	end

	_G.__CrystalReadSavedPanelVisibility = nil

	local toggleUiRow = Instance.new("Frame", panelsPanel)
	toggleUiRow.Size = UDim2.new(1, -18, 0, 28)
	toggleUiRow.Position = UDim2.new(0, 9, 0, 68)
	toggleUiRow.BackgroundTransparency = 1
	toggleUiRow.Visible = true
	local toggleUiLabel = Instance.new("TextLabel", toggleUiRow)
	toggleUiLabel.Size = UDim2.new(1, -50, 0, 32)
	toggleUiLabel.Position = UDim2.new(0, 0, 0, 2)
	toggleUiLabel.BackgroundTransparency = 1
	toggleUiLabel.Text = "Toggle UI"
	toggleUiLabel.TextColor3 = Color3.fromRGB(40, 80, 150)
	toggleUiLabel.TextSize = 10
	toggleUiLabel.Font = Enum.Font.GothamBold
	toggleUiLabel.TextXAlignment = Enum.TextXAlignment.Left
	toggleUiLabel.TextYAlignment = Enum.TextYAlignment.Center

	local toggleUiBindBtn = Instance.new("TextButton", toggleUiRow)
	toggleUiBindBtn.Size = UDim2.new(0, 40, 0, 20)
	toggleUiBindBtn.Position = UDim2.new(1, -48, 0.5, -10)
	toggleUiBindBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	toggleUiBindBtn.BackgroundTransparency = 0.15
	toggleUiBindBtn.BorderSizePixel = 0
	toggleUiBindBtn.Text = FeatureKeybinds["Toggle UI"] and keybindDisplayName(FeatureKeybinds["Toggle UI"]) or "-"
	toggleUiBindBtn.TextColor3 = Color3.fromRGB(225,238,255)
	toggleUiBindBtn.TextSize = 9
	toggleUiBindBtn.Font = Enum.Font.GothamBold
	toggleUiBindBtn.AutoButtonColor = false
	Instance.new("UICorner", toggleUiBindBtn).CornerRadius = UDim.new(0, 4)
	local toggleUiStroke = Instance.new("UIStroke", toggleUiBindBtn)
	toggleUiStroke.Color = Color3.fromRGB(255,255,255)
	toggleUiStroke.Thickness = 1
	toggleUiStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

	connectBtn(toggleUiBindBtn, function()
	if listeningBindBtn then
	listeningBindBtn.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
	listeningBindBtn.BackgroundTransparency = 1
	listeningBindBtn.Text = "-"
	end
	listeningBindBtn = toggleUiBindBtn
	listeningFeature = "Toggle UI"
	toggleUiBindBtn.Text = "..."
	toggleUiBindBtn.BackgroundColor3 = Color3.fromRGB(4, 18, 42)
	toggleUiBindBtn.BackgroundTransparency = 0
	end)

	table.insert(_allBindBtns, toggleUiBindBtn)
	if toggleVisualUpdaters["Toggle UI"] == nil then
	toggleVisualUpdaters["Toggle UI"] = function()
	toggleUiBindBtn.Text = FeatureKeybinds["Toggle UI"] and keybindDisplayName(FeatureKeybinds["Toggle UI"]) or "-"
	toggleUiBindBtn.BackgroundColor3 = Color3.fromRGB(30,30,38)
	toggleUiBindBtn.BackgroundTransparency = 0.15
	toggleUiBindBtn.TextColor3 = Color3.fromRGB(225,238,255)
	end
	end

	end

	local animationsSection = makeUraniumSection(tabPages["Animations"], "ANIMATIONS")
	local animationPresetOrder = {
	"Adidas Sports",
	"Adidas Community",
	"Adidas Aura",
	"Wicked Popular",
	"Elder",
	"Zombie",
	"Mage",
	"Catwalk Glam",
	"Astronaut",
	'Wicked "Dancing Through Life"',
	"Werewolf",
	"Superhero",
	"Toy",
	"No Boundaries",
	"NFL",
	"Amazon Unboxed",
	"Vampire",
	"Ninja",
	"Robot",
	"Levitation",
	"Stylish",
	"Bubbly",
	"Cartoon",
	}
	local animationPresets = {
	["Adidas Sports"]               = {WalkAnim=18537392113, RunAnim=18537384940, JumpAnim=18537380791, FallAnim=18537367238, SwimIdle=18537387180, Swim=18537389531, Animation1=18537376492, Animation2=18537371272, ClimbAnim=18537363391},
	["Adidas Community"]            = {WalkAnim=122150855457006, RunAnim=82598234841035, JumpAnim=75290611992385, FallAnim=98600215928904, SwimIdle=109346520324160, Swim=133308483266208, Animation1=122257458498464, Animation2=102357151005774, ClimbAnim=88763136693023},
	["Adidas Aura"]                 = {WalkAnim=83842218823011, RunAnim=118320322718866, JumpAnim=109996626521204, FallAnim=95603166884636, SwimIdle=94922130551805, Swim=134530128383903, Animation1=110211186840347, Animation2=114191137265065, ClimbAnim=97824616490448},
	["Wicked Popular"]              = {WalkAnim=92072849924640, RunAnim=72301599441680, JumpAnim=104325245285198, FallAnim=121152442762481, Animation1=118832222982049, ClimbAnim=131326830509784, SwimIdle=113199415118199, Swim=99384245425157, Animation2=76049494037641},
	["Elder"]                       = {WalkAnim=10921111375, RunAnim=10921104374, JumpAnim=10921107367, FallAnim=10921105765, SwimIdle=10921110146, Swim=10921108971, ClimbAnim=10921100400, Animation1=10921101664, Animation2=10921102574},
	["Zombie"]                      = {WalkAnim=10921355261, RunAnim=616163682, JumpAnim=10921351278, FallAnim=10921350320, SwimIdle=10921353442, Swim=10921352344, Animation1=10921344533, Animation2=10921345304, ClimbAnim=10921343576},
	["Mage"]                        = {WalkAnim=10921152678, RunAnim=10921148209, JumpAnim=10921149743, FallAnim=10921148939, SwimIdle=10921151661, Swim=10921150788, ClimbAnim=10921143404, Animation1=10921144709, Animation2=10921145797},
	["Catwalk Glam"]                = {WalkAnim=109168724482748, RunAnim=81024476153754, JumpAnim=116936326516985, FallAnim=92294537340807, SwimIdle=98854111361360, Swim=134591743181628, ClimbAnim=119377220967554, Animation1=133806214992291, Animation2=94970088341563},
	["Astronaut"]                   = {WalkAnim=10921046031, RunAnim=10921039308, JumpAnim=10921042494, FallAnim=10921040576, SwimIdle=10921045006, Swim=10921044000, ClimbAnim=10921032124, Animation1=10921034824, Animation2=10921036806},
	["Wicked \"Dancing Through Life\""] = {WalkAnim=73718308412641, RunAnim=135515454877967, JumpAnim=78508480717326, FallAnim=78147885297412, SwimIdle=129183123083281, Swim=110657013921774, ClimbAnim=129447497744818, Animation1=92849173543269, Animation2=132238900951109},
	["Werewolf"]                    = {WalkAnim=10921342074, RunAnim=10921336997, FallAnim=10921337907, SwimIdle=10921341319, Swim=10921340419, ClimbAnim=10921329322, Animation1=10921330408, Animation2=10921333667},
	["Superhero"]                   = {WalkAnim=10921298616, RunAnim=10921291831, JumpAnim=10921294559, FallAnim=10921293373, SwimIdle=10921297391, Swim=10921295495, ClimbAnim=10921286911, Animation1=10921288909, Animation2=10921290167},
	["Toy"]                         = {WalkAnim=10921312010, RunAnim=10921306285, JumpAnim=10921308158, FallAnim=10921307241, SwimIdle=10921310341, Swim=10921309319, ClimbAnim=10921300839, Animation1=10921301576},
	["No Boundaries"]               = {WalkAnim=18747074203, RunAnim=18747070484, JumpAnim=18747069148, FallAnim=18747062535, SwimIdle=18747071682, Swim=18747073181, ClimbAnim=18747060903, Animation1=18747067405, Animation2=18747063918},
	["NFL"]                         = {WalkAnim=110358958299415, RunAnim=117333533048078, JumpAnim=119846112151352, FallAnim=129773241321032, SwimIdle=79090109939093, Swim=132697394189921, ClimbAnim=134630013742019, Animation1=92080889861410, Animation2=74451233229259},
	["Amazon Unboxed"]              = {WalkAnim=90478085024465, RunAnim=134824450619865, JumpAnim=121454505477205, FallAnim=94788218468396, SwimIdle=129126268464847, Swim=105962919001086, ClimbAnim=121145883950231, Animation1=98281136301627},
	["Vampire"]                     = {WalkAnim=10921326949, RunAnim=10921320299, JumpAnim=10921322186, FallAnim=10921321317, SwimIdle=10921325443, Swim=10921324408, ClimbAnim=10921314188, Animation1=10921315373},
	["Ninja"]                       = {RunAnim=656118852, WalkAnim=656121766, JumpAnim=656117878, FallAnim=656115606, Swim=656119721, SwimIdle=656121397, ClimbAnim=656114359, Idle={656117400,656118341,886742569}},
	["Robot"]                       = {RunAnim=616091570, WalkAnim=616095330, JumpAnim=616090535, FallAnim=616087089, Swim=616092998, SwimIdle=616094091, ClimbAnim=616086039, Idle={616088211,616089559,885531463}},
	["Levitation"]                  = {RunAnim=616010382, WalkAnim=616013216, JumpAnim=616008936, FallAnim=616005863, Swim=616011509, SwimIdle=616012453, ClimbAnim=616003713, Idle={616006778,616008087,886862142}},
	["Stylish"]                     = {RunAnim=616140816, WalkAnim=616146177, JumpAnim=616139451, FallAnim=616134815, Swim=616143378, SwimIdle=616144772, ClimbAnim=616133594, Idle={616136790,616138447,886888594}},
	["Bubbly"]                      = {RunAnim=910025107, WalkAnim=910034870, JumpAnim=910016857, FallAnim=910001910, Swim=910028158, SwimIdle=910030921, ClimbAnim=909997997, Idle={910004836,910009958,1018536639}},
	["Cartoon"]                     = {RunAnim=742638842, WalkAnim=742640026, JumpAnim=742637942, FallAnim=742637151, Swim=742639220, SwimIdle=742639812, ClimbAnim=742636889, Idle={742637544,742638445,885477856}},
	}
	local animationPropertyOrder = {"idle1", "idle2", "walk", "run", "jump", "fall", "climb", "swim", "swimidle"}
	local animationPropertyLabels = {
	idle1 = "Idle 1",
	idle2 = "Idle 2",
	walk = "Walk",
	run = "Run",
	jump = "Jump",
	fall = "Fall",
	climb = "Climb",
	swim = "Swim",
	swimidle = "Swim Idle",
	}
	local function normalizeAnimValue(value)
	if not value then return nil end
	if type(value) == "number" then
	return "rbxassetid://" .. tostring(value)
	end
	if type(value) == "string" then
	local trimmed = string.gsub(value, "^%s+", "")
	trimmed = string.gsub(trimmed, "%s+$", "")
	if trimmed == "" then return nil end
	if string.sub(trimmed, 1, 11) == "rbxassetid://" then return trimmed end
	if string.match(trimmed, "^%d+$") then return "rbxassetid://" .. trimmed end
	return trimmed
	end
	return nil
	end
	local function buildAnimPackFromPreset(preset)
	local idle = preset and preset.Idle
	return {
	idle1 = normalizeAnimValue(preset and (preset.Animation1 or (idle and idle[1]))),
	idle2 = normalizeAnimValue(preset and (preset.Animation2 or (idle and idle[2]))),
	walk = normalizeAnimValue(preset and (preset.WalkAnim or preset.Walk)),
	run = normalizeAnimValue(preset and (preset.RunAnim or preset.Run)),
	jump = normalizeAnimValue(preset and (preset.JumpAnim or preset.Jump)),
	fall = normalizeAnimValue(preset and (preset.FallAnim or preset.Fall)),
	climb = normalizeAnimValue(preset and (preset.ClimbAnim or preset.Climb)),
	swim = normalizeAnimValue(preset and (preset.Swim or preset.SwimAnim)),
	swimidle = normalizeAnimValue(preset and (preset.SwimIdle or preset.SwimIdleAnim)),
	}
	end
	local animationFieldRefs = {}
	local Anims = {
	idle1    = "rbxassetid://133806214992291",
	idle2    = "rbxassetid://94970088341563",
	walk     = "rbxassetid://707897309",
	run      = "rbxassetid://707861613",
	jump     = "rbxassetid://116936326516985",
	fall     = "rbxassetid://116936326516985",
	climb    = "rbxassetid://116936326516985",
	swim     = "rbxassetid://116936326516985",
	swimidle = "rbxassetid://116936326516985",
	}
	_G.__CrystalHub_Anims = Anims
	local animIdToName = {}
	local animNameToId = {}
	for presetName, preset in pairs(animationPresets) do
	local pack = buildAnimPackFromPreset(preset)
	for _, key in ipairs(animationPropertyOrder) do
	local id = pack[key]
	if id then
	local nm = presetName .. " " .. animationPropertyLabels[key]
	if not animNameToId[nm] then
	animNameToId[nm] = id
	animIdToName[id] = nm
	end
	end
	end
	end
	local function animDisplayName(id)
	if not id then return "" end
	if id == "rbxassetid://" then return "Custom" end
	return animIdToName[id] or id
	end
	local slotAnimationList = {}
	for _, key in ipairs(animationPropertyOrder) do slotAnimationList[key] = {} end
	for _, presetName in ipairs(animationPresetOrder) do
	local preset = animationPresets[presetName]
	if preset then
	local pack = buildAnimPackFromPreset(preset)
	for _, key in ipairs(animationPropertyOrder) do
	local id = pack[key]
	if id and not table.find(slotAnimationList[key], id) then
	table.insert(slotAnimationList[key], id)
	end
	end
	end
	end
	local function cycleSlotAnimation(key, box)
	local list = slotAnimationList[key]
	if not list or not box then return end
	local currentId = Anims[key]
	local nextIndex = 1
	for i, id in ipairs(list) do
	if id == currentId then
	nextIndex = i % #list + 1
	break
	end
	end
	Anims[key] = list[nextIndex]
	box.Text = animDisplayName(list[nextIndex])
	saveConfig()
	if toggleStates["Harder Hit Anim"] and saveOriginalAnims then
	local char = Player.Character
	if char then
	saveOriginalAnims(char)
	applyAnimPack(char)
	end
	end
	end
	local selectedAnimationPresetName = animationPresetOrder[1]
	local function applyAnimationPreset(name)
	local preset = animationPresets[name]
	if not preset then return end
	local pack = buildAnimPackFromPreset(preset)
	selectedAnimationPresetName = name
	Anims.idle1 = pack.idle1 or Anims.idle1
	Anims.idle2 = pack.idle2 or Anims.idle2
	Anims.walk = pack.walk or Anims.walk
	Anims.run = pack.run or Anims.run
	Anims.jump = pack.jump or Anims.jump
	Anims.fall = pack.fall or Anims.fall
	Anims.climb = pack.climb or Anims.climb
	Anims.swim = pack.swim or Anims.swim
	Anims.swimidle = pack.swimidle or Anims.swimidle
	if toggleStates["Harder Hit Anim"] and saveOriginalAnims and applyAnimPack then
	local char = Player.Character
	if char then
	saveOriginalAnims(char)
	applyAnimPack(char)
	end
	end
	end
	local function loadAnimationPresetIntoFields(name)
	local preset = animationPresets[name]
	if not preset then return end
	local pack = buildAnimPackFromPreset(preset)
	for _, key in ipairs(animationPropertyOrder) do
	local box = animationFieldRefs[key]
	if box then
	local value = pack[key] or ""
	box.Text = animDisplayName(value)
	end
	end
	applyAnimationPreset(name)
	end
	makeToggleNoKeybind(animationsSection, "Animations (Master)", "Animaciones")
	FeaturePostToggle["Animaciones"] = function(active)

	if toggleStates["Harder Hit Anim"] == active then return end
	toggleStates["Harder Hit Anim"] = active
	if FeaturePostToggle["Harder Hit Anim"] then FeaturePostToggle["Harder Hit Anim"](active) end
	if toggleVisualUpdaters["Harder Hit Anim"] then toggleVisualUpdaters["Harder Hit Anim"]() end
	saveConfig()
	end

	local presetButton = Instance.new("TextButton", animationsSection)
	presetButton.Size = UDim2.new(1, 0, 0, 34)
	presetButton.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
	presetButton.BorderSizePixel = 0
	presetButton.Text = "Preset: " .. selectedAnimationPresetName
	presetButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	presetButton.TextSize = 11
	presetButton.Font = Enum.Font.GothamBold
	presetButton.AutoButtonColor = false
	Instance.new("UICorner", presetButton).CornerRadius = UDim.new(0, 8)
	connectBtn(presetButton, function()
	local currentIndex = 1
	for i, name in ipairs(animationPresetOrder) do
	if name == selectedAnimationPresetName then
	currentIndex = i
	break
	end
	end
	local nextIndex = currentIndex + 1
	if nextIndex > #animationPresetOrder then nextIndex = 1 end
	local nextName = animationPresetOrder[nextIndex]
	presetButton.Text = "Preset: " .. nextName
	loadAnimationPresetIntoFields(nextName)
	saveConfig()
	end)

	local fieldsContainer = Instance.new("Frame", animationsSection)
	fieldsContainer.Size = UDim2.new(1, -2, 0, 0)
	fieldsContainer.BackgroundTransparency = 1
	fieldsContainer.ClipsDescendants = false
	local fieldLayout = Instance.new("UIListLayout", fieldsContainer)
	fieldLayout.Padding = UDim.new(0, 6)
	fieldLayout.SortOrder = Enum.SortOrder.LayoutOrder
	fieldLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
	fieldsContainer.Size = UDim2.new(1, -2, 0, fieldLayout.AbsoluteContentSize.Y)
	end)

	for _, key in ipairs(animationPropertyOrder) do
	local row = Instance.new("Frame", fieldsContainer)
	row.Size = UDim2.new(1, 0, 0, 30)
	row.BackgroundColor3 = Color3.fromRGB(16, 16, 20)
	row.BackgroundTransparency = 0.25
	row.BorderSizePixel = 0
	Instance.new("UICorner", row).CornerRadius = UDim.new(0, 8)

	local label = Instance.new("TextLabel", row)
	label.Size = UDim2.new(0.48, 0, 1, 0)
	label.Position = UDim2.new(0, 8, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = animationPropertyLabels[key]
	label.TextColor3 = Color3.fromRGB(220, 220, 230)
	label.TextSize = 11
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left

	local input = Instance.new("TextButton", row)
	input.Size = UDim2.new(0.5, -10, 0, 20)
	input.Position = UDim2.new(0.5, 0, 0.5, -10)
	input.BackgroundColor3 = Color3.fromRGB(20, 20, 24)
	input.BorderSizePixel = 0
	input.Text = ""
	input.TextColor3 = Color3.fromRGB(255, 255, 255)
	input.TextSize = 10
	input.Font = Enum.Font.Gotham
	input.AutoButtonColor = false
	Instance.new("UICorner", input).CornerRadius = UDim.new(0, 6)

	input.Activated:Connect(function()
	cycleSlotAnimation(key, input)
	end)
	animationFieldRefs[key] = input
	end

	local infoLabel = Instance.new("TextLabel", animationsSection)
	infoLabel.Size = UDim2.new(1, 0, 0, 24)
	infoLabel.BackgroundTransparency = 1
	infoLabel.Text = "Master: enable/disable all. Tap an animation to cycle to the next one."
	infoLabel.TextColor3 = Color3.fromRGB(140, 180, 220)
	infoLabel.TextSize = 10
	infoLabel.Font = Enum.Font.Gotham
	infoLabel.TextXAlignment = Enum.TextXAlignment.Left

	loadAnimationPresetIntoFields(selectedAnimationPresetName)
	if _G.__savedAnimations then
	for k, savedVal in pairs(_G.__savedAnimations) do
	if Anims[k] ~= nil then
	Anims[k] = savedVal
	local box = animationFieldRefs[k]
	if box then box.Text = animDisplayName(savedVal) end
	end
	end
	_G.__savedAnimations = nil
	end

    local toggleBtn = nil
    _G.__toggleBtn = nil

	local panelScale = Instance.new("UIScale", Panel)
	panelScale.Scale = 1

	local panelVisible = toggleStates["Toggle UI"] ~= false
	if type(_G.__CrystalPanelVisible) == "boolean" then
	panelVisible = _G.__CrystalPanelVisible
	end
	if toggleStates["Toggle UI"] ~= panelVisible then toggleStates["Toggle UI"] = panelVisible end
	if toggleVisualUpdaters["Toggle UI"] then toggleVisualUpdaters["Toggle UI"]() end

	local _panelAnimating = false
	local _toggleUIDebounce = false
	local miniPanel = nil
	local miniSubtitle = nil
	function setPanelVisible(show)
	show = show == true
	_G.__CrystalPanelVisible = show
	toggleStates["Toggle UI"] = show
	if Panel.Visible == show then
	panelVisible = show
	if miniPanel then miniPanel.Visible = not show end
	if miniSubtitle then miniSubtitle.Visible = not show end
	saveConfig()
	return
	end
	if _panelAnimating or _toggleUIDebounce then return end

	_toggleUIDebounce = true
	task.delay(0.3, function() _toggleUIDebounce = false end)
	panelVisible = show
	if show then
	Panel.Visible = true
	if miniPanel then miniPanel.Visible = false end
	if miniSubtitle then miniSubtitle.Visible = false end
	panelScale.Scale = 0.92
	Panel.BackgroundTransparency = 0.2
	TweenService:Create(panelScale, TweenInfo.new(0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Scale = 1}):Play()
	TweenService:Create(Panel, TweenInfo.new(0.18, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.2}):Play()
	else
	_panelAnimating = true
	TweenService:Create(panelScale, TweenInfo.new(0.16, Enum.EasingStyle.Quad, Enum.EasingDirection.In), {Scale = 0.9}):Play()
	TweenService:Create(Panel, TweenInfo.new(0.16, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.8}):Play()
	task.delay(0.16, function()
	Panel.Visible = false
	if miniPanel then miniPanel.Visible = true end
	if miniSubtitle then miniSubtitle.Visible = true end
	panelScale.Scale = 1
	Panel.BackgroundTransparency = 0.95
	_panelAnimating = false
	end)
	end
	if toggleVisualUpdaters["Toggle UI"] then toggleVisualUpdaters["Toggle UI"]() end
	saveConfig()
	end

	Panel.Visible = false
	_G.__setPanelVisible = setPanelVisible

	FeatureToggles["Toggle UI"] = function()

	setPanelVisible(not Panel.Visible)
	end

	savedMenuPos = _G["_CrystalHub_UI_MenuPos"]
	if savedMenuPos then
	local placedMenuPos = Vector2.new(placeInsideViewport(Panel, 0, savedMenuPos.x, 0, savedMenuPos.y))
	Panel.Position = UDim2.new(0, placedMenuPos.X, 0, placedMenuPos.Y)
	else
	Panel.Position = UDim2.new(1, -PANEL_W - 20, 0.5, -PANEL_H/2)
	end

	Panel.Visible = false
	toggleStates["Toggle UI"] = panelVisible
	_G.__CrystalPanelVisible = panelVisible
	if miniPanel then miniPanel.Visible = not panelVisible end
	if miniSubtitle then miniSubtitle.Visible = not panelVisible end

	;(function()
	_G.__CrystalModernGuiActive = true
	local themesPanel = ScreenGui:FindFirstChild("MainThemesPanel")
	if themesPanel then themesPanel:Destroy() end

	if FPSLabel then FPSLabel.Parent = ScreenGui end
	if PingLabel then PingLabel.Parent = ScreenGui end
	for _, child in ipairs(Panel:GetChildren()) do
	if child ~= panelScale then child:Destroy() end
	end
	if panelScale then panelScale.Scale = 1 end
	if toggleBtn then toggleBtn:Destroy(); toggleBtn = nil; _G.__toggleBtn = nil end
	if miniPanel then pcall(function() miniPanel:Destroy() end); miniPanel = nil; miniSubtitle = nil end

	Panel.Name = "EclipseModernPanel"

	-- ===== Vylo Custom Bat Skins =====
	do
		local ASSET_ID = "rbxassetid://18566246244"
		local POSITION_OFFSET = CFrame.new(-0.02, -0.52, -0.2)
		local ROTATION_OFFSET = CFrame.Angles(math.rad(45), math.rad(0), math.rad(5))
		local FINAL_SCALE = 2
		local activeMode = "Default"
		local rgbConnection = nil
		local COLORS = {
			["Abyss Blue"] = Color3.fromRGB(0, 40, 150),
			["Venom Green"] = Color3.fromRGB(20, 255, 50),
			["Royal Gold"] = Color3.fromRGB(255, 200, 0),
			["Velvet Rose"] = Color3.fromRGB(220, 20, 100),
			["Crimson Night"] = Color3.fromRGB(90, 0, 20),
		}
		local cachedVisualPart = nil
		_G.__VyloBatSkinPrefs = _G.__VyloBatSkinPrefs or { enabled = true }
		local batPrefs = _G.__VyloBatSkinPrefs
		local batSkinEnabled = batPrefs.enabled ~= false
		pcall(function()
			if type(game.GetObjects) ~= "function" then return end
			local objects = game:GetObjects(ASSET_ID)
			if objects and #objects > 0 then
				local model = objects[1]
				cachedVisualPart = model:IsA("BasePart") and model or model:FindFirstChildWhichIsA("BasePart", true)
			end
		end)

		local function setPartColor(visual, color)
			if not visual then return end
			pcall(function() visual.Color = color end)
			if visual:IsA("UnionOperation") then
				pcall(function() visual.UsePartColor = true end)
			end
			local sm = visual:FindFirstChildWhichIsA("SpecialMesh")
			if sm then
				pcall(function() sm.VertexColor = Vector3.new(color.R, color.G, color.B) end)
			end
		end

		local function applyVisual(tool)
			if not batSkinEnabled then return end
			if not tool or tool.Name ~= "Bat" or not cachedVisualPart then return end
			local handle = tool:FindFirstChild("Handle") or tool:WaitForChild("Handle", 2)
			if not handle then return end

			local oldVisual = tool:FindFirstChild("CustomUnionVisual")
			if oldVisual then oldVisual:Destroy() end

			handle.Transparency = 1
			for _, child in ipairs(handle:GetChildren()) do
				if child:IsA("SpecialMesh") or child:IsA("Mesh") or child:IsA("Decal") then
					pcall(function() child.Transparency = 1 end)
				end
			end

			local newVisual = cachedVisualPart:Clone()
			newVisual.Name = "CustomUnionVisual"
			newVisual.CanCollide = false
			newVisual.Massless = true
			newVisual.Anchored = false

			local tempModel = Instance.new("Model")
			newVisual.Parent = tempModel
			tempModel.PrimaryPart = newVisual
			pcall(function() tempModel:ScaleTo(FINAL_SCALE) end)
			newVisual.Parent = nil
			tempModel:Destroy()

			if activeMode == "RGB" then
				setPartColor(newVisual, Color3.fromHSV((tick() % 3) / 3, 1, 1))
			elseif COLORS[activeMode] then
				setPartColor(newVisual, COLORS[activeMode])
			end

			for _, child in ipairs(newVisual:GetChildren()) do
				if child:IsA("Weld") or child:IsA("WeldConstraint") then child:Destroy() end
			end

			newVisual.CFrame = handle.CFrame * POSITION_OFFSET * ROTATION_OFFSET
			newVisual.Parent = tool

			local weld = Instance.new("WeldConstraint")
			weld.Part0 = handle
			weld.Part1 = newVisual
			weld.Parent = newVisual
		end

		local function updateEquippedBat()
			local char = Player.Character
			if not char then return end
			local tool = char:FindFirstChild("Bat")
			if tool then applyVisual(tool) end
		end

		local function clearVisual(tool)
			if not tool then return end
			local oldVisual = tool:FindFirstChild("CustomUnionVisual")
			if oldVisual then oldVisual:Destroy() end
			local handle = tool:FindFirstChild("Handle")
			if handle then
				handle.Transparency = 0
				for _, child in ipairs(handle:GetChildren()) do
					if child:IsA("SpecialMesh") or child:IsA("Mesh") or child:IsA("Decal") then
						pcall(function() child.Transparency = 0 end)
					end
				end
			end
		end

		local function checkChar(char)
			if not char then return end
			for _, tool in ipairs(char:GetChildren()) do applyVisual(tool) end
			_G.__CrystalTrackConn(char.ChildAdded:Connect(applyVisual))
		end

		if Player.Character then checkChar(Player.Character) end
		_G.__CrystalTrackConn(Player.CharacterAdded:Connect(checkChar))
		local bp = Player:FindFirstChild("Backpack") or Player:WaitForChild("Backpack", 5)
		if bp then
			for _, tool in ipairs(bp:GetChildren()) do applyVisual(tool) end
			_G.__CrystalTrackConn(bp.ChildAdded:Connect(applyVisual))
		end

		if rgbConnection then pcall(function() rgbConnection:Disconnect() end) end
		rgbConnection = RunService.RenderStepped:Connect(function()
			if activeMode ~= "RGB" or not batSkinEnabled then return end
			local char = Player.Character
			if not char then return end
			local tool = char:FindFirstChild("Bat")
			if not tool then return end
			local visual = tool:FindFirstChild("CustomUnionVisual")
			if visual then
				setPartColor(visual, Color3.fromHSV((tick() % 3) / 3, 1, 1))
			end
		end)
		_G.__CrystalTrackConn(rgbConnection)

		_G.__VyloBatSkin = {
			SetMode = function(mode)
				activeMode = tostring(mode or "Default")
				if activeMode == "Default" then
					-- reapply default asset look (no tint)
					updateEquippedBat()
					local char = Player.Character
					if char then
						local tool = char:FindFirstChild("Bat")
						if tool then
							local visual = tool:FindFirstChild("CustomUnionVisual")
							if visual and cachedVisualPart then
								pcall(function() visual.Color = cachedVisualPart.Color end)
							end
						end
					end
				else
					updateEquippedBat()
				end
				return activeMode
			end,
			GetMode = function() return activeMode end,
			Refresh = updateEquippedBat,
			GetEnabled = function() return batSkinEnabled end,
			SetEnabled = function(on)
				batSkinEnabled = on == true
				batPrefs.enabled = batSkinEnabled
				if not batSkinEnabled then
					local char = Player.Character
					if char then
						local tool = char:FindFirstChild("Bat")
						if tool then clearVisual(tool) end
					end
				else
					updateEquippedBat()
				end
			end,
			Colors = COLORS,
		}
	end

	local MODERN = {
	headerH = isMobile and 78 or 90,
	pageGap = isMobile and 5 or 7,
	sectionH = isMobile and 16 or 18,
	inputH = isMobile and 32 or 38,
	toggleH = isMobile and 32 or 40,
	toggleBindH = isMobile and 42 or 52,
	actionH = isMobile and 34 or 42,
	textSize = isMobile and 10 or 11,
	categoryH = isMobile and 26 or 30,
	}
	local modernViewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or vp
	local modernPanelW = isMobile and math.clamp(math.floor(modernViewport.X * 0.52), 205, 255) or 310
	local modernPanelH = isMobile and math.clamp(math.floor(modernViewport.Y * 0.82), 420, 560) or 620
	Panel.Size = UDim2.new(0, modernPanelW, 0, modernPanelH)
	local savedModernPosition = _G["_CrystalHub_UI_MenuPos"]
	if savedModernPosition and savedModernPosition.x ~= nil and savedModernPosition.y ~= nil then
	Panel.Position = UDim2.new(savedModernPosition.xs or 0, savedModernPosition.x, savedModernPosition.ys or 0, savedModernPosition.y)
	else
	Panel.Position = UDim2.new(1, -modernPanelW - 12, 0.5, -modernPanelH / 2)
	end
	Panel.BackgroundTransparency = 1
	Panel.BorderSizePixel = 0
	Panel.ClipsDescendants = true
	Panel.Visible = panelVisible

	local CURT_WORD_IMAGE = "rbxassetid://138011890749936"
	local CURT_THEME_PRESETS = {
		[1] = { -- light orange / BG1
			bg = Color3.fromRGB(10, 7, 4),
			bgDark = Color3.fromRGB(5, 3, 2),
			row = Color3.fromRGB(26, 18, 11),
			accent = Color3.fromRGB(255, 176, 90),
			accentDim = Color3.fromRGB(64, 42, 22),
			activeRow = Color3.fromRGB(54, 35, 17),
			text = Color3.fromRGB(255, 246, 236),
			textDim = Color3.fromRGB(200, 170, 135),
			textMuted = Color3.fromRGB(135, 108, 82),
			divider = Color3.fromRGB(54, 38, 22),
		},
		[2] = { -- dark orange / BG2
			bg = Color3.fromRGB(10, 5, 2),
			bgDark = Color3.fromRGB(5, 2, 1),
			row = Color3.fromRGB(28, 14, 7),
			accent = Color3.fromRGB(255, 120, 25),
			accentDim = Color3.fromRGB(72, 32, 10),
			activeRow = Color3.fromRGB(60, 27, 8),
			text = Color3.fromRGB(255, 242, 228),
			textDim = Color3.fromRGB(205, 150, 105),
			textMuted = Color3.fromRGB(140, 95, 60),
			divider = Color3.fromRGB(58, 32, 16),
		},
		[3] = { -- white / BG3
			bg = Color3.fromRGB(8, 8, 10),
			bgDark = Color3.fromRGB(4, 4, 6),
			row = Color3.fromRGB(22, 22, 26),
			accent = Color3.fromRGB(245, 245, 250),
			accentDim = Color3.fromRGB(45, 45, 52),
			activeRow = Color3.fromRGB(38, 38, 44),
			text = Color3.fromRGB(250, 250, 255),
			textDim = Color3.fromRGB(175, 175, 185),
			textMuted = Color3.fromRGB(115, 115, 125),
			divider = Color3.fromRGB(40, 40, 48),
		},
		[4] = { -- white / BG4
			bg = Color3.fromRGB(6, 6, 8),
			bgDark = Color3.fromRGB(2, 2, 4),
			row = Color3.fromRGB(20, 20, 24),
			accent = Color3.fromRGB(255, 255, 255),
			accentDim = Color3.fromRGB(42, 42, 48),
			activeRow = Color3.fromRGB(36, 36, 42),
			text = Color3.fromRGB(252, 252, 255),
			textDim = Color3.fromRGB(170, 170, 180),
			textMuted = Color3.fromRGB(110, 110, 120),
			divider = Color3.fromRGB(38, 38, 46),
		},
		[5] = { -- orange / BG5
			bg = Color3.fromRGB(10, 6, 3),
			bgDark = Color3.fromRGB(5, 3, 1),
			row = Color3.fromRGB(28, 17, 9),
			accent = Color3.fromRGB(255, 150, 50),
			accentDim = Color3.fromRGB(70, 40, 16),
			activeRow = Color3.fromRGB(58, 32, 12),
			text = Color3.fromRGB(255, 244, 232),
			textDim = Color3.fromRGB(205, 165, 125),
			textMuted = Color3.fromRGB(140, 105, 75),
			divider = Color3.fromRGB(58, 36, 18),
		},
		[6] = { -- deep orange / BG6
			bg = Color3.fromRGB(10, 5, 2),
			bgDark = Color3.fromRGB(5, 2, 1),
			row = Color3.fromRGB(30, 15, 7),
			accent = Color3.fromRGB(255, 110, 20),
			accentDim = Color3.fromRGB(78, 34, 10),
			activeRow = Color3.fromRGB(64, 28, 8),
			text = Color3.fromRGB(255, 242, 228),
			textDim = Color3.fromRGB(210, 155, 110),
			textMuted = Color3.fromRGB(145, 98, 62),
			divider = Color3.fromRGB(64, 30, 12),
		},
	}
	local HALLOWEEN_THEME = {
		bg = Color3.fromRGB(10, 5, 1),
		bgDark = Color3.fromRGB(0, 0, 0),
		row = Color3.fromRGB(26, 12, 3),
		accent = Color3.fromRGB(255, 126, 26),
		accentDim = Color3.fromRGB(132, 54, 8),
		activeRow = Color3.fromRGB(102, 39, 4),
		text = Color3.fromRGB(255, 246, 226),
		textDim = Color3.fromRGB(255, 191, 112),
		textMuted = Color3.fromRGB(196, 126, 62),
		divider = Color3.fromRGB(82, 35, 8),
	}
	local function getCurtThemePreset(index)
		return CURT_THEME_PRESETS[tonumber(index) or 1] or CURT_THEME_PRESETS[1]
	end
	local _initialCurtTheme = getCurtThemePreset(bgIndex)
	local C = {
	bg = _initialCurtTheme.bg,
	bgDark = _initialCurtTheme.bgDark,
	row = _initialCurtTheme.row,
	accent = _initialCurtTheme.accent,
	accentDim = _initialCurtTheme.accentDim,
	activeRow = _initialCurtTheme.activeRow,
	text = _initialCurtTheme.text,
	textDim = _initialCurtTheme.textDim,
	textMuted = _initialCurtTheme.textMuted,
	divider = _initialCurtTheme.divider,
	}
	local function corner(parent, radius)
	local item = Instance.new("UICorner")
	item.CornerRadius = UDim.new(0, radius or 10)
	item.Parent = parent
	return item
	end
	local function stroke(parent, color, thickness)
	local item = Instance.new("UIStroke")
	item.Color = color or C.divider
	item.Thickness = thickness or 1
	item.Parent = parent
	return item
	end

	local activeUiTweens = setmetatable({}, { __mode = "k" })
	local function tween(object, properties, duration, easingStyle, easingDirection)
	if not object or not object.Parent then return nil end
	local previous = activeUiTweens[object]
	if previous then pcall(function() previous:Cancel() end) end
	local animation = TweenService:Create(object, TweenInfo.new(
	duration or 0.16,
	easingStyle or Enum.EasingStyle.Quart,
	easingDirection or Enum.EasingDirection.Out
	), properties)
	activeUiTweens[object] = animation
	animation:Play()
	return animation
	end
	local function makeDraggable(handle, target)
	local dragging, dragInput, dragStart, startPosition = false, nil, nil, nil
	handle.Active = true
	_G.__CrystalGuiPositionResetters[target.Name] = function()
	dragging = false
	dragInput = nil
	dragStart = nil
	startPosition = nil
	target.Position = UDim2.fromOffset(6, 54)
	if target == Panel then
	_G["_CrystalHub_UI_MenuPos"] = nil
	else
	_G["_CrystalHub_UI_ModernMiniPos"] = nil
	end
	end
	handle.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
	if dragging then return end
	dragInput = input
	dragging = true; dragStart = input.Position; startPosition = target.Position
	input.Changed:Connect(function()
	if input.UserInputState == Enum.UserInputState.End then
	dragging = false
	if target == Panel then
	_G["_CrystalHub_UI_MenuPos"] = {
	x = target.Position.X.Offset,
	y = target.Position.Y.Offset,
	xs = target.Position.X.Scale,
	ys = target.Position.Y.Scale,
	}
	pcall(saveConfig)
	elseif target.Name == "EclipseRestoreButton" then
	_G["_CrystalHub_UI_ModernMiniPos"] = {
	x = target.Position.X.Offset,
	y = target.Position.Y.Offset,
	}
	pcall(saveConfig)
	end
	end
	end)
	end
	end)
	handle.InputChanged:Connect(function(input)
	if dragging and dragInput.UserInputType ~= Enum.UserInputType.Touch and input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
	end)

	_G.__CrystalTrackConn(UserInputService.InputChanged:Connect(function(input)
	if dragging and input == dragInput then
	local delta = input.Position - dragStart
	placeInsideViewport(target, startPosition.X.Scale, startPosition.X.Offset + delta.X, startPosition.Y.Scale, startPosition.Y.Offset + delta.Y)
	end
	end))
	end

	local inner = Instance.new("Frame")
	inner.Name = "Inner"
	inner.Size = UDim2.new(1, 0, 1, 0)
	inner.BackgroundColor3 = C.bg
	inner.BorderSizePixel = 0
	inner.ClipsDescendants = true
	inner.Parent = Panel
	corner(inner, 10)
	local innerStroke = stroke(inner, Color3.fromRGB(45, 45, 45), 0)
	innerStroke.LineJoinMode = Enum.LineJoinMode.Round

	local background = Instance.new("ImageLabel")
	background.Name = "BackgroundImage"
	background.Size = UDim2.fromScale(1, 1)
	background.Position = UDim2.fromOffset(0, 0)
	background.BackgroundTransparency = 1
	background.ClipsDescendants = true
	local GUI_THEME_IMAGES = { ["GUI 1"] = "rbxassetid://128167124865101" }
	local GUI_THEME_PANEL_BACKGROUND = { ["GUI 1"] = 1 }
	local activeGuiTheme = "GUI 1"
	_G.__CrystalGuiTheme = activeGuiTheme
	local refreshCategoryTextColors
	local function syncGuiThemeToPanels(themeName)
		local backgroundIndex = GUI_THEME_PANEL_BACKGROUND[themeName] or 1
		pcall(function()
			if _G.CrystalLagger and _G.CrystalLagger.SetBackground then
				_G.CrystalLagger.SetBackground(backgroundIndex)
			end
		end)
	end
	local mainShade = _G.__CrystalAddUnifiedPanelShade(inner, 10, 1)
	for _, extraName in ipairs({"UnifiedPanelWhiteOutline", "UnifiedPanelWhiteGlow"}) do
		local extra = inner:FindFirstChild(extraName)
		if extra then extra:Destroy() end
	end
	if mainShade then
		mainShade.Position = UDim2.fromOffset(0, 0)
		mainShade.Size = UDim2.fromScale(1, 1)
		local shadeCorner = mainShade:FindFirstChildOfClass("UICorner")
		if shadeCorner then shadeCorner.CornerRadius = UDim.new(0, 10) end
	end
	local function applyGuiTheme(themeName)
	if not GUI_THEME_IMAGES[themeName] then themeName = "GUI 1" end
	activeGuiTheme = themeName
	_G.__CrystalGuiTheme = themeName
	if _G.__CrystalApplyTheme then _G.__CrystalApplyTheme() end
	background.Image = GUI_THEME_IMAGES[themeName]
	local backgroundShade = inner:FindFirstChild("UnifiedBackgroundShade")
	if backgroundShade then backgroundShade.Visible = themeName ~= "GUI 1" end
	innerStroke.Transparency = 1
	syncGuiThemeToPanels(themeName)
	if _G.__CrystalApplyAutoStealBarTheme then
	pcall(_G.__CrystalApplyAutoStealBarTheme, themeName)
	end
	if _G.__CrystalRefreshESPTheme then
	pcall(_G.__CrystalRefreshESPTheme, _G.__CrystalThemeAccent, Color3.fromRGB(0, 0, 0))
	end
	if _G.__refreshSpeedBillboards then
	pcall(_G.__refreshSpeedBillboards)
	end
	if refreshCategoryTextColors then refreshCategoryTextColors() end
	end
	applyGuiTheme(activeGuiTheme)
	background.ImageTransparency = 0
	background.ScaleType = Enum.ScaleType.Crop
	background.ZIndex = 0
	background.Parent = inner
	background.Visible = true
	corner(background, 10)

	local header = Instance.new("Frame")
	header.Name = "HeaderFrame"
	header.Size = UDim2.new(1, 0, 0, MODERN.headerH)
	header.BackgroundTransparency = 1
	header.ZIndex = 10
	header.Parent = inner
	makeDraggable(header, Panel)

	local statsPanel = Instance.new("Frame")
	statsPanel.Name = "HeaderStats"
	statsPanel.Position = UDim2.new(0, 14, 0, 8)
	statsPanel.Size = UDim2.new(0, 78, 0, 40)
	statsPanel.BackgroundColor3 = C.bgDark
	statsPanel:SetAttribute("CurtThemeRole", "BgDark")
	statsPanel.BackgroundTransparency = 0.35
	statsPanel.BorderSizePixel = 0
	statsPanel.ZIndex = 12
	statsPanel.Parent = header
	statsPanel.Visible = true
	statsPanel.BackgroundTransparency = 1
	statsPanel.Size = UDim2.new(1, -28, 0, 18)
	statsPanel.Position = UDim2.new(0, 14, 0, MODERN.headerH - 22)
	corner(statsPanel, 0)

	if FPSLabel then
	FPSLabel.Parent = statsPanel
	FPSLabel.Position = UDim2.new(0, 0, 0, 0)
	FPSLabel.Size = UDim2.new(0.5, -4, 1, 0)
	FPSLabel.BackgroundTransparency = 1
	FPSLabel.TextColor3 = Color3.fromRGB(120, 255, 140)
	FPSLabel.TextSize = isMobile and 9 or 10
	FPSLabel.Font = Enum.Font.GothamBold
	FPSLabel.TextXAlignment = Enum.TextXAlignment.Left
	FPSLabel.TextTransparency = 0
	FPSLabel.Visible = true
	FPSLabel.ZIndex = 13
	end
	if PingLabel then
	PingLabel.Parent = statsPanel
	PingLabel.Position = UDim2.new(0.5, 0, 0, 0)
	PingLabel.Size = UDim2.new(0.5, 0, 1, 0)
	PingLabel.BackgroundTransparency = 1
	PingLabel.TextColor3 = Color3.fromRGB(120, 255, 140)
	PingLabel.TextSize = isMobile and 9 or 10
	PingLabel.Font = Enum.Font.GothamBold
	PingLabel.TextXAlignment = Enum.TextXAlignment.Right
	PingLabel.TextTransparency = 0
	PingLabel.Visible = true
	PingLabel.ZIndex = 13
	end

	local title = Instance.new("TextLabel")
	title.Position = UDim2.new(0, 98, 0, 8)
	title.Size = UDim2.new(1, -146, 0, 22)
	title.BackgroundTransparency = 1
	title.Text = "VYLO HUB"
	title.TextColor3 = C.text
	title.TextSize = 17
	title.Font = Enum.Font.GothamBlack
	title.TextXAlignment = Enum.TextXAlignment.Center
	title.ZIndex = 11
	title.Parent = header

	local subtitle = Instance.new("TextLabel")
	subtitle.Position = UDim2.new(0, 98, 0, 32)
	subtitle.Size = UDim2.new(1, -146, 0, 14)
	subtitle.BackgroundTransparency = 1
	subtitle.Text = ""
	subtitle.TextColor3 = C.textDim
	subtitle.TextSize = 10
	subtitle.Font = Enum.Font.GothamBold
	subtitle.TextXAlignment = Enum.TextXAlignment.Center
	subtitle.ZIndex = 11
	subtitle.Parent = header
	subtitle.Visible = false

	local wordMark = Instance.new("ImageLabel")
	wordMark.Name = "CurtWordMark"
	wordMark.AnchorPoint = Vector2.new(0.5, 0)
	wordMark.Position = UDim2.new(0.5, 0, 0, isMobile and 10 or 12)
	wordMark.Size = UDim2.fromOffset(isMobile and 170 or 210, isMobile and 46 or 54)
	wordMark.BackgroundTransparency = 1
	wordMark.Image = CURT_WORD_IMAGE
	wordMark.ScaleType = Enum.ScaleType.Fit
	wordMark.ImageColor3 = C.accent
	wordMark.ZIndex = 13
	wordMark.Parent = header

	local wordGlow = Instance.new("ImageLabel")
	wordGlow.Name = "CurtWordGlow"
	wordGlow.AnchorPoint = Vector2.new(0.5, 0)
	wordGlow.Position = wordMark.Position
	wordGlow.Size = UDim2.fromOffset(isMobile and 186 or 228, isMobile and 52 or 60)
	wordGlow.BackgroundTransparency = 1
	wordGlow.Image = CURT_WORD_IMAGE
	wordGlow.ImageTransparency = 0.74
	wordGlow.ScaleType = Enum.ScaleType.Fit
	wordGlow.ZIndex = 12
	wordGlow.Parent = header

	local closeButton = Instance.new("TextButton")
	closeButton.Size = UDim2.new(0, 28, 0, 28)
	closeButton.Position = UDim2.new(1, -38, 0, 8)
	closeButton.BackgroundColor3 = C.bgDark
	closeButton:SetAttribute("CurtThemeRole", "BgDark")
	closeButton.BorderSizePixel = 0
	closeButton.Text = "×"
	closeButton.TextColor3 = C.text
	closeButton.Font = Enum.Font.GothamBlack
	closeButton.TextSize = 18
	closeButton.ZIndex = 12
	closeButton.Parent = header
	corner(closeButton, 4)
	stroke(closeButton, C.accent, 1)

	local separator = Instance.new("Frame")
	separator.Position = UDim2.new(0, 14, 0, MODERN.headerH)
	separator.Size = UDim2.new(1, -28, 0, 1)
	separator.BackgroundColor3 = C.accent
	separator:SetAttribute("CurtThemeRole", "Accent")
	separator.BackgroundTransparency = 0.35
	separator.Size = UDim2.new(1, -28, 0, 2)
	separator.BorderSizePixel = 0
	separator.ZIndex = 9
	separator.Parent = inner

	local categoryPanel = Instance.new("Frame")
	categoryPanel.Name = "LeftPanel"
	categoryPanel.Size = UDim2.new(0, 85, 1, -78)
	categoryPanel.Position = UDim2.new(1, -85, 0, 68)
	categoryPanel.BackgroundColor3 = C.bgDark
	categoryPanel:SetAttribute("CurtThemeRole", "BgDark")
	categoryPanel.BackgroundTransparency = 0.5
	categoryPanel.BorderSizePixel = 0
	categoryPanel.ZIndex = 5
	categoryPanel.Parent = inner
	corner(categoryPanel, 12)
	categoryPanel.Visible = false

	title.Text = ""
	title.Visible = false

	local bottomTabsH = isMobile and 38 or 44
	local bottomTabs = Instance.new("Frame")
	bottomTabs.Name = "BottomTabs"
	bottomTabs.Size = UDim2.new(1, -12, 0, bottomTabsH)
	bottomTabs.Position = UDim2.new(0, 6, 1, -(bottomTabsH + 6))
	bottomTabs.BackgroundColor3 = C.bgDark
	bottomTabs:SetAttribute("CurtThemeRole", "BgDark")
	bottomTabs.BackgroundTransparency = 0.55
	bottomTabs.BorderSizePixel = 0
	bottomTabs.ZIndex = 10
	bottomTabs.Parent = inner
	corner(bottomTabs, 14)
	local bottomTabsStroke = stroke(bottomTabs, C.divider, 1)
	bottomTabsStroke.Transparency = 0.7

	local categoryList = Instance.new("Frame")
	categoryList.Size = UDim2.new(1, -12, 1, -8)
	categoryList.Position = UDim2.new(0, 6, 0, 4)
	categoryList.BackgroundTransparency = 1
	categoryList.ZIndex = 12
	categoryList.Parent = bottomTabs
	local categoryLayout = Instance.new("UIListLayout", categoryList)
	categoryLayout.SortOrder = Enum.SortOrder.LayoutOrder
	categoryLayout.FillDirection = Enum.FillDirection.Horizontal
	categoryLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	categoryLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	categoryLayout.Padding = UDim.new(0, isMobile and 2 or 4)
	local categoryPadding = Instance.new("UIPadding", categoryList)
	categoryPadding.PaddingLeft = UDim.new(0, 0)
	categoryPadding.PaddingRight = UDim.new(0, 0)
	categoryPadding.PaddingTop = UDim.new(0, 0)

	local content = Instance.new("Frame")
	content.Name = "ContentFrame"
	content.Size = UDim2.new(1, -12, 1, -(MODERN.headerH + bottomTabsH + 20))
	content.Position = UDim2.new(0, 6, 0, MODERN.headerH + 8)
	content.BackgroundTransparency = 1
	content.ClipsDescendants = true
	content.ZIndex = 4
	content.Parent = inner

	local function setTabPosition(position)
		position = "Down"
		_G.__CrystalTabPosition = "Down"
		local isLeft = false
		if isLeft then
			bottomTabs.Size = UDim2.new(0, isMobile and 90 or 106, 1, -(MODERN.headerH + 14))
			bottomTabs.Position = UDim2.new(0, 6, 0, MODERN.headerH + 8)
			-- Keep only a subtle dark backdrop behind the floating left tabs.
			bottomTabs.BackgroundTransparency = 0.82
			bottomTabsStroke.Transparency = 0.82
			categoryList.Size = UDim2.new(1, -8, 1, -8)
			categoryList.Position = UDim2.new(0, 4, 0, -8)
			categoryLayout.FillDirection = Enum.FillDirection.Vertical
			categoryLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			categoryLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			categoryLayout.Padding = UDim.new(0, isMobile and 3 or 4)
			content.Size = UDim2.new(1, -(isMobile and 108 or 124), 1, -(MODERN.headerH + 14))
			content.Position = UDim2.new(0, isMobile and 102 or 118, 0, MODERN.headerH + 8)
		else
			bottomTabs.Size = UDim2.new(1, -12, 0, bottomTabsH)
			bottomTabs.Position = UDim2.new(0, 6, 1, -(bottomTabsH + 6))
			bottomTabs.BackgroundTransparency = 0.3
			bottomTabsStroke.Transparency = 0
			categoryList.Size = UDim2.new(1, -12, 1, -8)
			categoryList.Position = UDim2.new(0, 6, 0, 4)
			categoryLayout.FillDirection = Enum.FillDirection.Horizontal
			categoryLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			categoryLayout.VerticalAlignment = Enum.VerticalAlignment.Center
			categoryLayout.Padding = UDim.new(0, isMobile and 2 or 4)
			content.Size = UDim2.new(1, -12, 1, -(MODERN.headerH + bottomTabsH + 20))
			content.Position = UDim2.new(0, 6, 0, MODERN.headerH + 8)
		end
		for _, button in ipairs(categoryList:GetChildren()) do
			if button:IsA("TextButton") then
				button.Size = isLeft
					and UDim2.new(1, -4, 0, isMobile and 34 or 38)
					or UDim2.new(0.25, isMobile and -2 or -4, 0, MODERN.categoryH)
				button.TextWrapped = isLeft
			end
		end
		pcall(saveConfig)
		return position
	end
	_G.__CrystalSetTabPosition = setTabPosition

	local function keepOriginalText(object)
	object:SetAttribute("EclipseKeepBlackText", true)
	object.TextStrokeTransparency = 1
	return object
	end
	for _, object in ipairs(inner:GetDescendants()) do
	if object:IsA("TextLabel") or object:IsA("TextButton") or object:IsA("TextBox") then
	keepOriginalText(object)
	end
	end
	title.TextColor3 = C.text
	subtitle.TextColor3 = C.textDim
	closeButton.TextColor3 = C.textMuted
	local pageScales = {}
	local function newPage(name)
	local page = Instance.new("ScrollingFrame")
	page.Name = name .. "Page"
	page.Size = UDim2.new(1, 0, 1, 0)
	page.BackgroundTransparency = 1
	page.BorderSizePixel = 0
	page.ScrollBarThickness = 2
	page.ScrollBarImageColor3 = C.accent
	page.ScrollBarImageTransparency = 0.28
	page.ElasticBehavior = Enum.ElasticBehavior.Always
	page.ScrollingDirection = Enum.ScrollingDirection.Y
	page.AutomaticCanvasSize = Enum.AutomaticSize.Y
	page.CanvasSize = UDim2.new(0, 0, 0, 0)
	page.Visible = name == "Movement"
	page.ZIndex = 5
	page.Parent = content
	local pageScale = Instance.new("UIScale")
	pageScale.Name = "PageTransitionScale"
	pageScale.Scale = 1
	pageScale.Parent = page
	pageScales[name] = pageScale
	local layout = Instance.new("UIListLayout", page)
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Padding = UDim.new(0, MODERN.pageGap)
	local padding = Instance.new("UIPadding", page)
	padding.PaddingLeft = UDim.new(0, 4)
	padding.PaddingRight = UDim.new(0, 4)
	padding.PaddingTop = UDim.new(0, isMobile and 4 or 6)
	padding.PaddingBottom = UDim.new(0, isMobile and 4 or 6)
	return page
	end
	local pages = {
	Movement = newPage("Movement"),
	Combat = newPage("Combat"),
	Visual = newPage("Visual"),
	Animations = newPage("Animations"),
	}

	local function setFeature(featureName, enabled)
	if featureName == "TP Bat" or featureName == "Anti Bat" or featureName == "Halloween Mode" then
		toggleStates[featureName] = false
		local postToggle = FeaturePostToggle[featureName]
		if postToggle then pcall(postToggle, false) end
		return
	end
	local current = toggleStates[featureName] == true
	if current == enabled then return end
	local toggler = FeatureToggles[featureName]
	if toggler then pcall(toggler) end
	if toggleStates[featureName] ~= enabled then
	toggleStates[featureName] = enabled
	local postToggle = FeaturePostToggle[featureName]
	if postToggle then pcall(postToggle, enabled) end
	end
	local updater = toggleVisualUpdaters[featureName]
	if updater then pcall(updater) end
	pcall(saveConfig)
	end
	local function beginKeybind(button, featureName)
	if listeningBindBtn then
	listeningBindBtn.Text = "-"
	end
	listeningBindBtn = button
	listeningFeature = featureName
	button.Text = "..."
	end
	local function sectionLabel(parent, text, order)
	local wrapper = Instance.new("Frame")
	wrapper.Size = UDim2.new(1, 0, 0, MODERN.sectionH)
	wrapper.BackgroundTransparency = 1
	wrapper.LayoutOrder = order
	wrapper.Parent = parent
	local label = keepOriginalText(Instance.new("TextLabel"))
	label.Size = UDim2.new(1, -8, 0, isMobile and 14 or 16)
	label.Position = UDim2.new(0, 4, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = string.upper(tostring(text))
	label.TextColor3 = C.textMuted
	label.TextSize = isMobile and 8 or 9
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.TextTransparency = 0.15
	label.Parent = wrapper
	end
	local function inlineModeBind(parent, featureName, position)
	local bind = keepOriginalText(Instance.new("TextButton"))
	bind.Name = "ModeKeybind"
	bind.Size = UDim2.fromOffset(isMobile and 38 or 44, isMobile and 16 or 20)
	bind.Position = position
	bind.BackgroundColor3 = C.accentDim
	bind:SetAttribute("CurtThemeRole", "AccentDim")
	bind.BackgroundTransparency = 0.25
	bind.BorderSizePixel = 0
	bind.TextColor3 = C.text
	bind.TextSize = isMobile and 8 or 9
	bind.Font = Enum.Font.GothamBold
	bind.Text = FeatureKeybinds[featureName] and keybindDisplayName(FeatureKeybinds[featureName]) or "-"
	bind.ZIndex = 8
	bind.Parent = parent
	corner(bind, 5); stroke(bind, Color3.fromRGB(55, 55, 60), 1)
	bind.MouseButton1Click:Connect(function()
	beginKeybind(bind, featureName)
	end)
	table.insert(_allBindBtns, bind)

	local previousUpdater = toggleVisualUpdaters[featureName]
	toggleVisualUpdaters[featureName] = function()
	if previousUpdater then pcall(previousUpdater) end
	local key = FeatureKeybinds[featureName]
	bind.Text = key and keybindDisplayName(key) or "-"
	bind.BackgroundColor3 = C.accentDim
	bind:SetAttribute("CurtThemeRole", "AccentDim")
	bind.BackgroundTransparency = 0.25
	bind.TextColor3 = C.text
	end
	return bind
	end
	local function inputRow(parent, labelText, value, order, callback, bindFeatureName)
	local row = Instance.new("Frame")
	row.Size = UDim2.new(1, 0, 0, MODERN.inputH)
	row.BackgroundColor3 = C.row
	row:SetAttribute("CurtThemeRole", "Row")
	row.BackgroundTransparency = 0.28
	row.BorderSizePixel = 0
	row.LayoutOrder = order
	row.Parent = parent
	corner(row, 14)
	local label = keepOriginalText(Instance.new("TextLabel"))
	label.Size = bindFeatureName and UDim2.new(1, isMobile and -116 or -142, 1, 0) or UDim2.new(0.65, 0, 1, 0)
	label.Position = UDim2.new(0, isMobile and 12 or 16, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = string.upper(tostring(labelText))
	label.TextColor3 = C.text
	label.TextSize = MODERN.textSize
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row
	if bindFeatureName then
	inlineModeBind(row, bindFeatureName, UDim2.new(1, isMobile and -94 or -116, 0.5, isMobile and -8 or -10))
	end
	local boxFrame = Instance.new("Frame")
	boxFrame.Size = UDim2.new(0, isMobile and 44 or 54, 0, isMobile and 18 or 22)
	boxFrame.Position = UDim2.new(1, isMobile and -51 or -64, 0.5, isMobile and -9 or -11)
	boxFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 14)
	boxFrame:SetAttribute("CurtThemeRole", "Row")
	boxFrame.BackgroundTransparency = 0.1
	boxFrame.BorderSizePixel = 0
	boxFrame.Parent = row
	corner(boxFrame, 10)
	local box = keepOriginalText(Instance.new("TextBox"))
	box.Size = UDim2.new(1, 0, 1, 0)
	box.BackgroundTransparency = 1
	box.Text = tostring(value)
	box.TextColor3 = C.text
	box.TextSize = isMobile and 9 or 11
	box.Font = Enum.Font.GothamBold
	box.ClearTextOnFocus = false
	box.Parent = boxFrame
	box.FocusLost:Connect(function()
	local number = tonumber(box.Text)
	if number then callback(number); box.Text = tostring(number) else box.Text = tostring(value) end
	end)
	end
	local function customSpeedRow(parent, customSpeed, order)
	local row = Instance.new("Frame")
	row.Name = "CustomSpeed_" .. customSpeed.name
	row.Size = UDim2.new(1, 0, 0, 58)
	row.BackgroundColor3 = C.row
	row:SetAttribute("CurtThemeRole", "Row")
	row.BackgroundTransparency = 0.5
	row.BorderSizePixel = 0
	row.LayoutOrder = order
	row.Parent = parent
	corner(row, 8); stroke(row, C.divider, 1)

	local selectedMarker = Instance.new("Frame")
	selectedMarker.Size = UDim2.new(0, 3, 0, 36)
	selectedMarker.Position = UDim2.new(0, 4, 0.5, -18)
	selectedMarker.BackgroundColor3 = C.accent
	selectedMarker:SetAttribute("CurtThemeRole", "Accent")
	selectedMarker.BorderSizePixel = 0
	selectedMarker.Parent = row
	corner(selectedMarker, 2)

	local selectButton = keepOriginalText(Instance.new("TextButton"))
	selectButton.Size = UDim2.new(0, 88, 1, 0)
	selectButton.Position = UDim2.new(0, 12, 0, 0)
	selectButton.BackgroundTransparency = 1
	selectButton.Text = customSpeed.name
	selectButton.TextColor3 = C.text
	selectButton.TextSize = 11
	selectButton.Font = Enum.Font.GothamBold
	selectButton.TextXAlignment = Enum.TextXAlignment.Left
	selectButton.Parent = row
	local customFeatureName = "SelectCustomMode_" .. customSpeed.name
	inlineModeBind(row, customFeatureName, UDim2.fromOffset(106, 19))

	local function speedBox(labelText, value, xPosition, onChanged)
	local label = keepOriginalText(Instance.new("TextLabel"))
	label.Size = UDim2.fromOffset(54, 14)
	label.Position = UDim2.fromOffset(xPosition, 5)
	label.BackgroundTransparency = 1
	label.Text = labelText
	label.TextColor3 = C.textMuted
	label.TextSize = 8
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row
	local box = keepOriginalText(Instance.new("TextBox"))
	box.Size = UDim2.fromOffset(54, 22)
	box.Position = UDim2.fromOffset(xPosition, 24)
	box.BackgroundColor3 = C.bgDark
	box:SetAttribute("CurtThemeRole", "BgDark")
	box.BorderSizePixel = 0
	box.Text = tostring(value)
	box.TextColor3 = C.text
	box.TextSize = 10
	box.Font = Enum.Font.GothamBold
	box.ClearTextOnFocus = false
	box.Parent = row
	corner(box, 5); stroke(box, Color3.fromRGB(55, 55, 60), 1)
	box.FocusLost:Connect(function()
	local number = tonumber(box.Text)
	if not number then box.Text = tostring(value); return end
	number = math.clamp(math.floor(number + 0.5), 1, 200)
	value = number
	box.Text = tostring(number)
	onChanged(number)
	end)
	return box
	end

	speedBox("NORMAL", customSpeed.boost, 158, function(value)
	customSpeed.boost = value
	speedValues["CustomBoost_" .. customSpeed.name] = value
	saveConfig()
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	end)
	speedBox("CARRY", customSpeed.steal, 224, function(value)
	customSpeed.steal = value
	speedValues["CustomSteal_" .. customSpeed.name] = value
	saveConfig()
	pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
	end)

	local deleteButton = keepOriginalText(Instance.new("TextButton"))
	deleteButton.Size = UDim2.fromOffset(30, 24)
	deleteButton.Position = UDim2.new(1, -40, 0.5, -12)
	deleteButton.BackgroundColor3 = Color3.fromRGB(72, 34, 34)
	deleteButton.BorderSizePixel = 0
	deleteButton.Text = "X"
	deleteButton.TextColor3 = Color3.fromRGB(255, 180, 180)
	deleteButton.TextSize = 10
	deleteButton.Font = Enum.Font.GothamBold
	deleteButton.Parent = row
	corner(deleteButton, 5)

	local function updateVisual()
	local active = selectedMode == customSpeed.name
	row.BackgroundTransparency = active and 0.28 or 0.5
	selectedMarker.Visible = active
	end
	selectButton.MouseButton1Click:Connect(function()
	selectMode(customSpeed.name)
	end)
	deleteButton.MouseButton1Click:Connect(function()
	for index = #customSpeeds, 1, -1 do
	if customSpeeds[index] == customSpeed then table.remove(customSpeeds, index); break end
	end
	speedValues["CustomBoost_" .. customSpeed.name] = nil
	speedValues["CustomSteal_" .. customSpeed.name] = nil
	FeatureKeybinds[customFeatureName] = nil
	FeatureToggles[customFeatureName] = nil
	if selectedMode == customSpeed.name then selectMode("Normal") end
	row:Destroy()
	saveConfig()
	end)
	FeatureToggles[customFeatureName] = function() selectMode(customSpeed.name) end
	table.insert(_speedCardRefs, { modeName = customSpeed.name, updateVisual = updateVisual })
	updateVisual()
	return row
	end

	local function customSpeedForm(parent, order, onCreated)
	local form = Instance.new("Frame")
	form.Name = "CustomSpeedForm"
	form.Size = UDim2.new(1, 0, 0, 112)
	form.BackgroundColor3 = C.row
	form:SetAttribute("CurtThemeRole", "Row")
	form.BackgroundTransparency = 0.2
	form.BorderSizePixel = 0
	form.LayoutOrder = order
	form.Parent = parent
	corner(form, 8); stroke(form, C.divider, 1)

	local function formLabel(text, x, width)
	local label = keepOriginalText(Instance.new("TextLabel"))
	label.Size = UDim2.fromOffset(width, 14)
	label.Position = UDim2.fromOffset(x, 8)
	label.BackgroundTransparency = 1
	label.Text = text
	label.TextColor3 = C.textMuted
	label.TextSize = 8
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = form
	end
	local function formBox(defaultText, x, width)
	local box = keepOriginalText(Instance.new("TextBox"))
	box.Size = UDim2.fromOffset(width, 24)
	box.Position = UDim2.fromOffset(x, 24)
	box.BackgroundColor3 = C.bgDark
	box:SetAttribute("CurtThemeRole", "BgDark")
	box.BorderSizePixel = 0
	box.Text = defaultText
	box.TextColor3 = C.text
	box.TextSize = 10
	box.Font = Enum.Font.GothamBold
	box.ClearTextOnFocus = false
	box.Parent = form
	corner(box, 5); stroke(box, Color3.fromRGB(55, 55, 60), 1)
	return box
	end
	formLabel("NAME", 12, 150)
	formLabel("NORMAL", 174, 70)
	formLabel("CARRY", 256, 70)
	local nameBox = formBox("Custom " .. tostring(#customSpeeds + 1), 12, 150)
	local normalBox = formBox("59", 174, 70)
	local carryBox = formBox("29", 256, 70)
	local errorLabel = keepOriginalText(Instance.new("TextLabel"))
	errorLabel.Size = UDim2.new(1, -24, 0, 14)
	errorLabel.Position = UDim2.new(0, 12, 1, -20)
	errorLabel.BackgroundTransparency = 1
	errorLabel.Text = ""
	errorLabel.TextColor3 = Color3.fromRGB(255, 150, 150)
	errorLabel.TextSize = 8
	errorLabel.Font = Enum.Font.GothamBold
	errorLabel.TextXAlignment = Enum.TextXAlignment.Left
	errorLabel.Parent = form
	local addButton = keepOriginalText(Instance.new("TextButton"))
	addButton.Size = UDim2.new(1, -24, 0, 26)
	addButton.Position = UDim2.new(0, 12, 0, 62)
	addButton.BackgroundColor3 = C.accentDim
	addButton:SetAttribute("CurtThemeRole", "AccentDim")
	addButton.BorderSizePixel = 0
	addButton.Text = "CREATE CUSTOM SPEED"
	addButton.TextColor3 = C.text
	addButton.TextSize = 10
	addButton.Font = Enum.Font.GothamBold
	addButton.Parent = form
	corner(addButton, 6)
	addButton.MouseButton1Click:Connect(function()
	local name = nameBox.Text:match("^%s*(.-)%s*$")
	local normal = tonumber(normalBox.Text)
	local carry = tonumber(carryBox.Text)
	if not name or #name < 1 then errorLabel.Text = "Escribe un nombre."; return end
	if name:find("[:,=]") then errorLabel.Text = "El nombre no puede contener : , o =."; return end
	if name == "Normal" or name == "Lagger" or name == "Desync" then errorLabel.Text = "Ese nombre está reservado."; return end
	for _, item in ipairs(customSpeeds) do if item.name == name then errorLabel.Text = "Ese nombre ya existe."; return end end
	if not normal or normal < 1 or normal > 200 then errorLabel.Text = "Normal: elige un valor entre 1 y 200."; return end
	if not carry or carry < 1 or carry > 200 then errorLabel.Text = "Carry: elige un valor entre 1 y 200."; return end
	local customSpeed = { name = name, boost = math.floor(normal + 0.5), steal = math.floor(carry + 0.5) }
	table.insert(customSpeeds, customSpeed)
	speedValues["CustomBoost_" .. name] = customSpeed.boost
	speedValues["CustomSteal_" .. name] = customSpeed.steal
	saveConfig()
	form:Destroy()
	onCreated(customSpeed)
	end)
	return form
	end
	local function toggleRow(parent, labelText, featureName, initial, order, hasKeybind, callback, bindFeatureName)
	local row = Instance.new("Frame")
	row:SetAttribute("CrystalButtonThemeControl", true)
	row.Size = UDim2.new(1, 0, 0, hasKeybind and MODERN.toggleBindH or MODERN.toggleH)
	row.BackgroundColor3 = C.row
	row:SetAttribute("CurtThemeRole", "Row")
	row.BackgroundTransparency = 0.28
	row.BorderSizePixel = 0
	row.LayoutOrder = order
	row.Parent = parent
	corner(row, 14)
	local rowScale = Instance.new("UIScale", row)
	rowScale.Scale = 1
	local label = keepOriginalText(Instance.new("TextLabel"))
	label.Size = UDim2.new(1, -70, 0, hasKeybind and (isMobile and 16 or 20) or MODERN.toggleH)
	label.Position = UDim2.new(0, isMobile and 12 or 16, 0, hasKeybind and (isMobile and 2 or 3) or 0)
	label.BackgroundTransparency = 1
	label.Text = string.upper(tostring(labelText))
	label.TextColor3 = C.text
	label.TextSize = MODERN.textSize
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row
	local activeMarker = Instance.new("Frame")
	activeMarker.Name = "ActiveMarker"
	activeMarker.Size = UDim2.new(0, 3, 0, isMobile and 18 or 24)
	activeMarker.Position = UDim2.new(0, 4, 0.5, isMobile and -9 or -12)
	activeMarker.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	activeMarker.BorderSizePixel = 0
	activeMarker.Visible = false
	activeMarker.Parent = row
	corner(activeMarker, 2)
	local switchTrack = Instance.new("Frame")
	switchTrack.Name = "ToggleSwitch"
	switchTrack.Size = UDim2.new(0, isMobile and 34 or 40, 0, isMobile and 16 or 20)
	switchTrack.Position = UDim2.new(1, isMobile and -42 or -50, 0.5, isMobile and -8 or -10)
	switchTrack.BackgroundColor3 = Color3.fromRGB(32, 32, 38)
	switchTrack:SetAttribute("CurtThemeRole", "BgDark")
	switchTrack.BorderSizePixel = 0
	switchTrack.ZIndex = 8
	switchTrack.Parent = row
	corner(switchTrack, 20)
	local switchKnob = Instance.new("Frame")
	switchKnob.Name = "Knob"
	switchKnob.Size = UDim2.new(0, isMobile and 12 or 16, 0, isMobile and 12 or 16)
	switchKnob.Position = UDim2.new(0, 2, 0.5, isMobile and -6 or -8)
	switchKnob.BackgroundColor3 = Color3.fromRGB(210, 210, 215)
	switchKnob:SetAttribute("CurtThemeRole", "SwitchKnob")
	switchKnob.BorderSizePixel = 0
	switchKnob.ZIndex = 9
	switchKnob.Parent = switchTrack
	corner(switchKnob, 20)
	local keyFeatureName = bindFeatureName or featureName
	if hasKeybind and keyFeatureName then
	local bind = keepOriginalText(Instance.new("TextButton"))
	bind.Size = UDim2.new(0, isMobile and 36 or 42, 0, isMobile and 14 or 17)
	bind.Position = UDim2.new(0, isMobile and 8 or 12, 1, isMobile and -17 or -21)
	bind.BackgroundColor3 = C.accentDim
	bind:SetAttribute("CurtThemeRole", "AccentDim")
	bind.BackgroundTransparency = 0.35
	bind.BorderSizePixel = 0
	local key = FeatureKeybinds[keyFeatureName]
	bind.Text = key and keybindDisplayName(key) or "-"
	bind.TextColor3 = C.text
	bind.TextSize = isMobile and 8 or 9
	bind.Font = Enum.Font.GothamBold
	bind.Parent = row
	corner(bind, 5)
	bind.MouseButton1Click:Connect(function() beginKeybind(bind, keyFeatureName) end)
	table.insert(_allBindBtns, bind)
	end
	local active = initial == true
	local visualInitialized = false
	local function updateVisual(value)
	active = value == true
	local targetColor = C.row
	local targetTransparency = 0.5
	activeMarker.Visible = false
	local trackColor = active and C.accent or Color3.fromRGB(42, 42, 48)
	switchTrack:SetAttribute("SwitchActive", active)
	switchTrack:SetAttribute("CurtThemeRole", active and "Accent" or "BgDark")
	local knobPosition = active
		and UDim2.new(1, isMobile and -14 or -18, 0.5, isMobile and -6 or -8)
		or UDim2.new(0, 2, 0.5, isMobile and -6 or -8)
	if visualInitialized then
	tween(row, {
	BackgroundColor3 = targetColor,
	BackgroundTransparency = targetTransparency,
	}, 0.18)
	tween(switchTrack, { BackgroundColor3 = trackColor }, 0.18)
	tween(switchKnob, { Position = knobPosition }, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	else
	row.BackgroundColor3 = targetColor
	row.BackgroundTransparency = targetTransparency
	switchTrack.BackgroundColor3 = trackColor
	switchKnob.Position = knobPosition
	visualInitialized = true
	end
	end
	updateVisual(active)
	local button = Instance.new("TextButton")
	keepOriginalText(button)
	button.Size = UDim2.new(1, 0, 1, 0)
	button.Position = UDim2.new(0, 0, 0, 0)
	button.BackgroundTransparency = 1
	button.Text = ""
	button.ZIndex = 0
	button.Parent = row
	button.MouseButton1Click:Connect(function()
	rowScale.Scale = 0.985
	tween(rowScale, {Scale = 1}, 0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local desired = not active
	callback(desired)
	updateVisual(featureName and toggleStates[featureName] == true or desired)
	end)
	if featureName then
	toggleVisualUpdaters[featureName] = function() updateVisual(toggleStates[featureName] == true) end
	end
	return updateVisual, row
	end
	local function modeButton(row, initialText, callback)
	local button = keepOriginalText(Instance.new("TextButton"))
	-- A selector goes before an ON/OFF switch; standalone selectors stay right-aligned.
	local rowHasSwitch = row:FindFirstChild("ToggleSwitch") ~= nil
	button.Size = UDim2.new(0, isMobile and 42 or 52, 0, isMobile and 16 or 20)
	button.Position = rowHasSwitch
		and UDim2.new(1, isMobile and -92 or -112, 0.5, isMobile and -8 or -10)
		or UDim2.new(1, isMobile and -54 or -68, 0.5, isMobile and -8 or -10)
	button.BackgroundColor3 = Color3.fromRGB(14, 14, 16)
	button:SetAttribute("CurtThemeRole", "AccentDim")
	button.BackgroundTransparency = 0.05
	button.BorderSizePixel = 0
	button.Text = string.upper(tostring(initialText))
	button.TextColor3 = C.text
	button.TextSize = isMobile and 8 or 9
	button.Font = Enum.Font.GothamBold
	button.ZIndex = 8
	button.Parent = row
	corner(button, 10)
	local buttonScale = Instance.new("UIScale", button)
	buttonScale.Scale = 1
	button.MouseButton1Click:Connect(function()
	buttonScale.Scale = 0.92
	tween(buttonScale, {Scale = 1}, 0.2, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	local newText = callback()
	if newText then button.Text = tostring(newText) end
	end)
	return button
	end
	local function actionRow(parent, labelText, featureName, order, action)
	local row = Instance.new("Frame")
	row:SetAttribute("CrystalButtonThemeControl", true)
	row.Size = UDim2.new(1, 0, 0, MODERN.actionH)
	row.BackgroundColor3 = C.row
	row:SetAttribute("CurtThemeRole", "Row")
	row.BackgroundTransparency = 0.28
	row.BorderSizePixel = 0
	row.LayoutOrder = order
	row.Parent = parent
	corner(row, 14)
	local rowScale = Instance.new("UIScale", row)
	rowScale.Scale = 1
	local label = keepOriginalText(Instance.new("TextButton"))
	label.Size = UDim2.new(1, featureName and -64 or -24, 1, 0)
	label.Position = UDim2.new(0, isMobile and 12 or 16, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = string.upper(tostring(labelText))
	label.TextColor3 = C.text
	label.TextSize = MODERN.textSize
	label.Font = Enum.Font.GothamBold
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = row
	label.MouseButton1Click:Connect(function()
	rowScale.Scale = 0.985
	tween(rowScale, {Scale = 1}, 0.18, Enum.EasingStyle.Back, Enum.EasingDirection.Out)
	action()
	end)
	if featureName then
	local bind = keepOriginalText(Instance.new("TextButton"))
	bind.Size = UDim2.new(0, isMobile and 38 or 44, 0, isMobile and 18 or 22)
	bind.Position = UDim2.new(1, isMobile and -45 or -54, 0.5, isMobile and -9 or -11)
	bind.BackgroundColor3 = C.accentDim
	bind:SetAttribute("CurtThemeRole", "AccentDim")
	bind.BackgroundTransparency = 0.35
	bind.BorderSizePixel = 0
	local key = FeatureKeybinds[featureName]
	bind.Text = key and keybindDisplayName(key) or "-"
	bind.TextColor3 = C.text
	bind.TextSize = isMobile and 8 or 9
	bind.Font = Enum.Font.GothamBold
	bind.Parent = row
	corner(bind, 5)
	bind.MouseButton1Click:Connect(function() beginKeybind(bind, featureName) end)
	table.insert(_allBindBtns, bind)
	end
	return row
	end

	local movement = pages.Movement
	sectionLabel(movement, "NORMAL SPEEDS", 0)
	inputRow(movement, "Normal Speed", speedValues.NormalBoost or 59, 1, function(value)
		speedValues.NormalBoost = math.max(1, math.floor(value))
		normalSpeed = speedValues.NormalBoost
		pcall(function() if _G.__refreshSpeedBoost then _G.__refreshSpeedBoost() end end)
		saveConfig()
	end, "SelectNormalMode")
	inputRow(movement, "Carry Speed", speedValues.NormalSteal or 29, 2, function(value)
		speedValues.NormalSteal = math.max(1, math.floor(value))
		carrySpeed = speedValues.NormalSteal
		pcall(function() if _G.__refreshSpeedBoost then _G.__refreshSpeedBoost() end end)
		saveConfig()
	end)
	sectionLabel(movement, "LAGGER SPEEDS", 3)
	inputRow(movement, "Lagger Normal", speedValues.LaggerBoost or 40, 4, function(value)
		speedValues.LaggerBoost = math.max(1, math.floor(value))
		laggerSpeed = speedValues.LaggerBoost
		pcall(function() if _G.__refreshSpeedBoost then _G.__refreshSpeedBoost() end end)
		saveConfig()
	end, "SelectLaggerMode")
	inputRow(movement, "Lagger Carry", speedValues.LaggerSteal or 20, 5, function(value)
		speedValues.LaggerSteal = math.max(1, math.floor(value))
		pcall(function() if _G.__refreshSpeedBoost then _G.__refreshSpeedBoost() end end)
		saveConfig()
	end, "SelectLaggerMode")
	sectionLabel(movement, "CUSTOM SPEEDS", 6)
	local customSpeedRows = {}
	local function addCustomSpeedToMainPanel(customSpeed)
	local row = customSpeedRow(movement, customSpeed, 10 + #customSpeedRows)
	table.insert(customSpeedRows, row)
	return row
	end
	for _, customSpeed in ipairs(customSpeeds) do
	addCustomSpeedToMainPanel(customSpeed)
	end
	local addCustomSpeedButton = keepOriginalText(Instance.new("TextButton"))
	addCustomSpeedButton.Size = UDim2.new(1, 0, 0, 38)
	addCustomSpeedButton.BackgroundColor3 = C.row
	addCustomSpeedButton:SetAttribute("CurtThemeRole", "Row")
	addCustomSpeedButton.BackgroundTransparency = 0.3
	addCustomSpeedButton.BorderSizePixel = 0
	addCustomSpeedButton.LayoutOrder = 50
	addCustomSpeedButton.Text = "+  ADD CUSTOM SPEED"
	addCustomSpeedButton.TextColor3 = C.text
	addCustomSpeedButton.TextSize = 10
	addCustomSpeedButton.Font = Enum.Font.GothamBold
	addCustomSpeedButton.Parent = movement
	corner(addCustomSpeedButton, 10); stroke(addCustomSpeedButton, C.divider, 1)
	local customSpeedFormOpen = nil
	addCustomSpeedButton.MouseButton1Click:Connect(function()
	if customSpeedFormOpen and customSpeedFormOpen.Parent then
	customSpeedFormOpen:Destroy()
	customSpeedFormOpen = nil
	return
	end
	customSpeedFormOpen = customSpeedForm(movement, 51, function(customSpeed)
	customSpeedFormOpen = nil
	addCustomSpeedToMainPanel(customSpeed)
	selectMode(customSpeed.name)
	end)
	end)
	sectionLabel(movement, "CONTROLS", 60)
	toggleRow(movement, "Auto Left", "Auto Left", toggleStates["Auto Left"], 61, true, function(on) setFeature("Auto Left", on) end)
	toggleRow(movement, "Auto Right", "Auto Right", toggleStates["Auto Right"], 61.5, true, function(on) setFeature("Auto Right", on) end)
	do
	local modeRow = actionRow(movement, "Auto Full/Semi", nil, 61.8, function() end)
	local autoplayModeUiBtn = modeButton(modeRow, string.upper(_G.__autoplayMode or "Full"), function()
	_G.__autoplayMode = (_G.__autoplayMode == "Semi") and "Full" or "Semi"
	saveConfig()
	return string.upper(_G.__autoplayMode)
	end)
	_G.__CrystalRefreshAutoplayModeUI = function(mode)
		local label = string.upper(tostring(mode or _G.__autoplayMode or "Full"))
		if autoplayModeUiBtn and autoplayModeUiBtn.Parent then
			autoplayModeUiBtn.Text = label
		end
	end
	end
	toggleRow(movement, "Auto Carry Speed", "Auto Carry Speed", toggleStates["Auto Carry Speed"], 62, false, function(on) setFeature("Auto Carry Speed", on) end)
	toggleRow(movement, "Carry Speed", "Carry Speed", toggleStates["Carry Speed"], 63, true, function(on) setFeature("Carry Speed", on) end)
	sectionLabel(movement, "MOVEMENT SETTINGS", 70)
	local _, infJumpUiRow = toggleRow(movement, "Infinite Jump", "Inf Jump", toggleStates["Inf Jump"], 71, false, function(on) setFeature("Inf Jump", on) end)
	modeButton(infJumpUiRow, string.upper(_G.__CrystalInfJumpMode or "hold"), function()
	_G.__CrystalInfJumpMode = (_G.__CrystalInfJumpMode or "hold") == "hold" and "manual" or "hold"
	if toggleStates["Inf Jump"] then
	if _G.__CrystalInfJumpMode == "hold" and startInfJump then
	pcall(startInfJump)
	elseif stopInfJump then
	pcall(stopInfJump)
	end
	end
	saveConfig()
	return string.upper(_G.__CrystalInfJumpMode)
	end)
	toggleRow(movement, "Unwalk", "Unwalk", toggleStates["Unwalk"], 72, false, function(on)
	setFeature("Unwalk", on)
	end)
	sectionLabel(movement, "TP DOWN", 73)
	actionRow(movement, "TP Down", "TP Down", 74, function()
	if FeatureToggles["TP Down"] then pcall(FeatureToggles["TP Down"]) end
	end)
	toggleRow(movement, "Auto TP Down", "Auto TP Down", toggleStates["Auto TP Down"], 75, false, function(on)
	setFeature("Auto TP Down", on)
	end)
	inputRow(movement, "Height (studs)", speedValues.AutoTPDownHeight, 76, function(value)
	speedValues.AutoTPDownHeight = math.clamp(math.floor(value + 0.5), 1, 1000)
	saveConfig()
	end)

	local combat = pages.Combat
	sectionLabel(combat, "BAT CONTROLS", 0)
	local _, batAimbotUiRow = toggleRow(combat, "Bat Aimbot", "Aimbot", toggleStates.Aimbot, 1, true, function(on) setFeature("Aimbot", on) end)
	-- Normal = Clean Hub normal bat aimbot, Bypass = Clean Bat Bypass aimbot.
	local function aimbotEngineLabel()
		return (_G.__aimbotEngineVersion == 2) and "Bypass" or "Normal"
	end
	local aimbotEngineBtn = modeButton(batAimbotUiRow, aimbotEngineLabel(), function()
		local nextVersion = (_G.__aimbotEngineVersion == 2) and 1 or 2
		_G.__aimbotEngineVersion = nextVersion
		_G.__aimbotVersion = nextVersion
		if type(_G.__CrystalSetAimbotEngineVersion) == "function" then
			pcall(_G.__CrystalSetAimbotEngineVersion, nextVersion)
		end
		-- Force engine live if aimbot currently enabled
		if toggleStates["Aimbot"] == true and type(FeaturePostToggle["Aimbot"]) == "function" then
			pcall(FeaturePostToggle["Aimbot"], true)
		end
		saveConfig()
		return (nextVersion == 2) and "Bypass" or "Normal"
	end)
	_G.__CrystalRefreshAimbotEngineUI = function(version)
		if aimbotEngineBtn and aimbotEngineBtn.Parent then
			aimbotEngineBtn.Text = (version == 2 or version == "2") and "Bypass" or "Normal"
		end
	end
	_G.__CrystalRefreshAimbotModeUI = function() end
	toggleRow(combat, "Mirror TP Down", "Mirror TP Down", toggleStates["Mirror TP Down"], 1.5, false, function(on)
		setFeature("Mirror TP Down", on)
	end)
	sectionLabel(combat, "AIMBOT SPEED", 1.6)
	inputRow(combat, "Normal Aimbot", speedValues.AimbotSpeed or 59, 1.7, function(value)
		speedValues.AimbotSpeed = math.clamp(math.floor(value + 0.5), 1, 200)
		speedValues.CypherAimbotApproachSpeed = speedValues.AimbotSpeed
		saveConfig()
	end)
	inputRow(combat, "Lagger Mode Spd", speedValues.AimbotSpeedLagger or 40, 1.8, function(value)
		speedValues.AimbotSpeedLagger = math.clamp(math.floor(value + 0.5), 1, 200)
		saveConfig()
	end)
	inputRow(combat, "Custom Aimbot Spd", speedValues.AimbotSpeedCustom or 59, 1.9, function(value)
		speedValues.AimbotSpeedCustom = math.clamp(math.floor(value + 0.5), 1, 200)
		saveConfig()
	end)
		sectionLabel(combat, "BODY LOCK", 2)
	toggleRow(combat, "Body Lock", "Body Lock", toggleStates["Body Lock"], 2.1, false, function(on) setFeature("Body Lock", on) end)
	inputRow(combat, "Lock Range", speedValues.BodyLockRange or 15, 2.2, function(value)
		speedValues.BodyLockRange = math.clamp(math.floor(value + 0.5), 1, 500)
		saveConfig()
	end)
	toggleRow(combat, "Ragdoll Counter", "Ragdoll Counter", toggleStates["Ragdoll Counter"], 4, false, function(on) setFeature("Ragdoll Counter", on) end)
	sectionLabel(combat, "RAGDOLL", 5)
	toggleRow(combat, "Anti Ragdoll", "Anti Ragdoll", toggleStates["Anti Ragdoll"], 6, false, function(on) setFeature("Anti Ragdoll", on) end)
	toggleRow(combat, "Medusa Counter", "Medusa Counter", toggleStates["Medusa Counter"], 7, false, function(on) setFeature("Medusa Counter", on) end)
	toggleRow(combat, "Anti Die", "Anti Die", toggleStates["Anti Die"], 8, false, function(on) setFeature("Anti Die", on) end)
	toggleRow(combat, "Steal Bar", "Steal Bar", true, 11, false, function(on)
		setFeature("Steal Bar", on)
	end)
	sectionLabel(combat, "ACTIONS", 12)
	do
	actionRow(combat, "Drop Brainrot", "Drop", 13, function()
	if FeatureToggles.Drop then pcall(FeatureToggles.Drop, "button") end
	end)

	end
	actionRow(combat, "TP Down", "TP Down", 14, function() if FeatureToggles["TP Down"] then pcall(FeatureToggles["TP Down"]) end end)
	actionRow(combat, "Insta Reset", "Insta Reset", 15, function() if FeatureToggles["Insta Reset"] then pcall(FeatureToggles["Insta Reset"]) end end)
	sectionLabel(combat, "AUTO STEAL", 16)
	local _, autoGrabUiRow = toggleRow(combat, "Auto Steal", "auto steal", toggleStates["auto steal"], 17, false, function(on) setFeature("auto steal", on) end)

	local autoStealModeBtn = modeButton(autoGrabUiRow, string.upper(autoStealMode), function()
	autoStealMode = (autoStealMode == "v2") and "v1" or "v2"
	if toggleStates["auto steal"] and FeaturePostToggle["auto steal"] then
	pcall(FeaturePostToggle["auto steal"], false)
	pcall(FeaturePostToggle["auto steal"], true)
	end
	if type(_G.__CrystalRefreshStealBarModePill) == "function" then
		pcall(_G.__CrystalRefreshStealBarModePill)
	end
	saveConfig()
	return string.upper(autoStealMode)
	end)
	_G.__CrystalRefreshAutoStealModeUI = function(mode)
		if autoStealModeBtn and autoStealModeBtn.Parent then
			autoStealModeBtn.Text = string.upper(tostring(mode or autoStealMode or "v1"))
		end
	end
	inputRow(combat, "Steal Radius", autoStealValues.Radius, 18, function(value) autoStealValues.Radius = math.clamp(math.floor(value), 10, 150); saveConfig() end)

	local visual = pages.Visual
	sectionLabel(visual, "VISUAL", -2)
	toggleRow(visual, "anti lag", "Anti Lag", toggleStates["Anti Lag"], -1, false, function(on) setFeature("Anti Lag", on) end)
	toggleRow(visual, "ESP Players", "ESP Players", toggleStates["ESP Players"], 1, false, function(on)
	setFeature("ESP Players", on)
	end)
	toggleRow(visual, "ESP Line", "Player Tracers", toggleStates["Player Tracers"], 2, false, function(on)
	setFeature("Player Tracers", on)
	end)
	local _, optimizerUiRow = toggleRow(visual, "Optimizer", "Optimizer", toggleStates.Optimizer, 3, false, function(on)
	setFeature("Optimizer", on)
	end)
	local optimizerUiModeButton = modeButton(optimizerUiRow, string.upper(optimizerMode or "Ultra"), function()
	local mode = optimizerMode == "Ultra" and "Normal" or "Ultra"
	setOptimizerMode(mode)
	return string.upper(mode)
	end)
	table.insert(optimizerModeRefreshers, function(mode)
	if optimizerUiModeButton and optimizerUiModeButton.Parent then
	optimizerUiModeButton.Text = string.upper(mode)
	end
	end)
	toggleRow(visual, "Stretch Rez", "Stretchz Res", toggleStates["Stretchz Res"], 4, false, function(on) setFeature("Stretchz Res", on) end)
	sectionLabel(visual, "FOV", 5)
	toggleRow(visual, "Custom FOV", "Custom FOV", toggleStates["Custom FOV"], 6, false, function(on)
	setFeature("Custom FOV", on)
	end)
	inputRow(visual, "FOV", speedValues.FOV, 7, function(value)
	speedValues.FOV = math.clamp(math.floor(value), 30, 120)
	setFeature("Custom FOV", true)
	if FeaturePostToggle["Custom FOV"] then pcall(FeaturePostToggle["Custom FOV"], true) end
	local camera = workspace.CurrentCamera; if camera then camera.FieldOfView = speedValues.FOV end
	saveConfig()
	end)
	sectionLabel(visual, "SKY", 8)
	local _, skyThemesUiRow = toggleRow(visual, "Sky Themes", "Sky Changer", toggleStates["Sky Changer"], 9, false, function(on)
	setFeature("Sky Changer", on)
	end)
	modeButton(skyThemesUiRow, string.upper(skyCurrentMode or "blue"), function()
	if skyCurrentMode == "day" then
	skyCurrentMode = "blue"
	elseif skyCurrentMode == "blue" then
	skyCurrentMode = "night"
	else
	 skyCurrentMode = "day"
	end
	_G.__CrystalSkyChangerMode = skyCurrentMode
	if toggleStates["Sky Changer"] then applySky(skyCurrentMode) end
	saveConfig()
	return string.upper(skyCurrentMode)
	end)
	sectionLabel(visual, "APPEARANCE", 10)

	do
	local appearanceUi = {}
	appearanceUi.add = function(label, featureName, order)
		local ref = {}
		ref.update, ref.row = toggleRow(visual, label, featureName, toggleStates[featureName], order, false, function(on)
			setFeature(featureName, on)
		end)
		ref.button = modeButton(ref.row, toggleStates[featureName] and "ON" or "OFF", function()
			setFeature(featureName, not toggleStates[featureName])
			return toggleStates[featureName] and "ON" or "OFF"
		end)
		ref.refresh = function()
			ref.update(toggleStates[featureName] == true)
			ref.button.Text = toggleStates[featureName] and "ON" or "OFF"
		end
		toggleVisualUpdaters[featureName] = ref.refresh
		ref.refresh()
	end
	appearanceUi.add("Skins", "Violette Custom Skins", 11.5)
	actionRow(visual, "Custom Skins", nil, 12, function()
		if _G._KawatanOpenSkinGallery then pcall(_G._KawatanOpenSkinGallery) end
	end)
	appearanceUi.add("Headless", "Headless Visual", 13)
	appearanceUi.add("Korblox", "Korblox Visual", 14)
	end
	sectionLabel(visual, "BAT SKINS", 14.2)
	do
		local batModes = {
			{"Default", Color3.fromRGB(50, 50, 60)},
			{"Abyss Blue", Color3.fromRGB(0, 40, 150)},
			{"Venom Green", Color3.fromRGB(20, 255, 50)},
			{"Royal Gold", Color3.fromRGB(255, 200, 0)},
			{"Velvet Rose", Color3.fromRGB(220, 20, 100)},
			{"Crimson Night", Color3.fromRGB(90, 0, 20)},
			{"RGB", Color3.fromRGB(255, 80, 180)},
		}
		local currentBatMode = (_G.__VyloBatSkin and _G.__VyloBatSkin.GetMode and _G.__VyloBatSkin.GetMode()) or "Default"
		local function batApi() return _G.__VyloBatSkin end
		local batOnRow = actionRow(visual, "Bat Skin Toggle", nil, 14.21, function() end)
		local batOnBtn
		batOnBtn = modeButton(batOnRow, (batApi() and batApi().GetEnabled and batApi().GetEnabled()) and "ON" or "OFF", function()
			local api = batApi()
			if not (api and api.SetEnabled) then return "OFF" end
			local new = not api.GetEnabled()
			pcall(api.SetEnabled, new)
			return new and "ON" or "OFF"
		end)
		local batModeRow = actionRow(visual, "Bat Skin", nil, 14.3, function() end)
		local batModeBtn = modeButton(batModeRow, string.upper(currentBatMode), function()
			local idx = 1
			for i, entry in ipairs(batModes) do
				if entry[1] == currentBatMode then idx = i break end
			end
			idx = idx % #batModes + 1
			currentBatMode = batModes[idx][1]
			if _G.__VyloBatSkin and _G.__VyloBatSkin.SetMode then
				pcall(_G.__VyloBatSkin.SetMode, currentBatMode)
			end
			return string.upper(currentBatMode)
		end)
	end
	sectionLabel(visual, "GUI", 15)
	do
		local colorNames = { "Plaid", "Batman Grillz", "Batman Money", "Blonde" }
		local colorRow = actionRow(visual, "Background", nil, 15, function() end)
		local colorModeButton
		colorModeButton = modeButton(colorRow, colorNames[bgIndex] or "BG1", function()
			bgIndex = (tonumber(bgIndex) or 1) + 1
			if bgIndex > #backgroundIds then bgIndex = 1 end
			_G["_CrystalHub_UI_BgIndex"] = bgIndex
			if BgImage then BgImage.Image = backgroundIds[bgIndex] end
			if background then background.Image = backgroundIds[bgIndex] end
			if _G.__CrystalApplyCurtVisualTheme then pcall(_G.__CrystalApplyCurtVisualTheme, bgIndex) end
			if type(_G.__CrystalSetStealBarParticles) == "function" then
				pcall(_G.__CrystalSetStealBarParticles, bgIndex == 2, bgIndex)
			end
			if type(_G.__CrystalApplyAutoStealBarTheme) == "function" then
				pcall(_G.__CrystalApplyAutoStealBarTheme, bgIndex)
			end
			saveConfig()
			return colorNames[bgIndex]
		end)
		colorModeButton.Name = "ScriptColorMode"
	end
	toggleRow(visual, "Mobile Buttons", "Show Buttons", toggleStates["Show Buttons"], 16, false, function(on)
	setFeature("Show Buttons", on)
	end)
	do
	local sizeRow = actionRow(visual, "Mobile Buttons Size", nil, 16.5, function() end)
	local sizeBox = keepOriginalText(Instance.new("TextBox"))
	sizeBox.Name = "ButtonsSizeInput"
	sizeBox.Size = UDim2.fromOffset(64, isMobile and 22 or 26)
	sizeBox.AnchorPoint = Vector2.new(1, 0.5)
	sizeBox.Position = UDim2.new(1, -10, 0.5, 0)
	sizeBox.BackgroundColor3 = C.accentDim
	sizeBox:SetAttribute("CurtThemeRole", "AccentDim")
	sizeBox:SetAttribute("CurtThemeAccentInput", true)
	sizeBox.BorderSizePixel = 0
	sizeBox.TextColor3 = C.text
	sizeBox.Font = Enum.Font.GothamBold
	sizeBox.TextSize = 12
	sizeBox.Text = tostring(_G.__CrystalButtonsSize or 1)
	sizeBox.PlaceholderText = "0.5 - 2"
	sizeBox.ClearTextOnFocus = false
	sizeBox.ZIndex = 8
	sizeBox.Parent = sizeRow
	corner(sizeBox, 5)
	sizeBox.FocusLost:Connect(function()
		sizeBox.Text = tostring(_G.__CrystalSetButtonsSize(sizeBox.Text))
	end)
	end
	actionRow(visual, "Reset Buttons Pos.", nil, 17, function()
	_G.__CrystalResetButtonPositions()
	if _G.CrystalLagger and _G.CrystalLagger.ResetPosition then _G.CrystalLagger.ResetPosition() end
	end)
	toggleRow(visual, "Lock Buttons", "Lock Buttons", toggleStates["Lock Buttons"], 18, false, function(on)
	setFeature("Lock Buttons", on)
	end)
	actionRow(visual, "Hide GUI Key", "Toggle UI", 19, function() Panel.Visible = false end)

	local animations = pages.Animations
	sectionLabel(animations, "ANIMATION SOURCE", 0)
	local selectedSourcePreset = _G.__CrystalAnimationPreset
	if not selectedSourcePreset or not animationPresets[selectedSourcePreset] then
	selectedSourcePreset = selectedAnimationPresetName or animationPresetOrder[1]
	end
	local presetSelector = Instance.new("Frame")
	presetSelector.Size = UDim2.new(1, 0, 0, 42)
	presetSelector.BackgroundColor3 = C.row
	presetSelector:SetAttribute("CurtThemeRole", "Row")
	presetSelector.BackgroundTransparency = 0.5
	presetSelector.BorderSizePixel = 0
	presetSelector.LayoutOrder = 1
	presetSelector.Parent = animations
	corner(presetSelector, 10); stroke(presetSelector, C.divider, 1)
	local previousPresetButton = keepOriginalText(Instance.new("TextButton"))
	previousPresetButton.Size = UDim2.new(0, 42, 1, -8)
	previousPresetButton.Position = UDim2.new(0, 4, 0, 4)
	previousPresetButton.BackgroundColor3 = C.accentDim
	previousPresetButton:SetAttribute("CurtThemeRole", "AccentDim")
	previousPresetButton.BackgroundTransparency = 0.2
	previousPresetButton.BorderSizePixel = 0
	previousPresetButton.Text = "<"
	previousPresetButton.TextColor3 = C.text
	previousPresetButton.TextSize = 18
	previousPresetButton.Font = Enum.Font.GothamBlack
	previousPresetButton.Parent = presetSelector
	corner(previousPresetButton, 7)
	local presetLabel = keepOriginalText(Instance.new("TextLabel"))
	presetLabel.Size = UDim2.new(1, -100, 1, 0)
	presetLabel.Position = UDim2.new(0, 50, 0, 0)
	presetLabel.BackgroundTransparency = 1
	presetLabel.TextColor3 = C.text
	presetLabel.TextSize = 10
	presetLabel.TextWrapped = true
	presetLabel.Font = Enum.Font.GothamBold
	presetLabel.Parent = presetSelector
	local nextPresetButton = keepOriginalText(Instance.new("TextButton"))
	nextPresetButton.Size = UDim2.new(0, 42, 1, -8)
	nextPresetButton.Position = UDim2.new(1, -46, 0, 4)
	nextPresetButton.BackgroundColor3 = C.accentDim
	nextPresetButton:SetAttribute("CurtThemeRole", "AccentDim")
	nextPresetButton.BackgroundTransparency = 0.2
	nextPresetButton.BorderSizePixel = 0
	nextPresetButton.Text = ">"
	nextPresetButton.TextColor3 = C.text
	nextPresetButton.TextSize = 18
	nextPresetButton.Font = Enum.Font.GothamBlack
	nextPresetButton.Parent = presetSelector
	corner(nextPresetButton, 7)
	local function refreshAnimationPresetButton()
	presetLabel.Text = tostring(selectedSourcePreset)
	end
	local function changeSourcePreset(direction)
	local currentIndex = 1
	for index, name in ipairs(animationPresetOrder) do
	if name == selectedSourcePreset then currentIndex = index break end
	end
	currentIndex = currentIndex + direction
	if currentIndex < 1 then currentIndex = #animationPresetOrder end
	if currentIndex > #animationPresetOrder then currentIndex = 1 end
	selectedSourcePreset = animationPresetOrder[currentIndex]
	refreshAnimationPresetButton()
	_G.__CrystalAnimationPreset = selectedSourcePreset
	if toggleStates["Animaciones"] then
		FeaturePostToggle["Animaciones"](true)
	else
		setFeature("Animaciones", true)
	end
	pcall(saveConfig)
	end
	previousPresetButton.MouseButton1Click:Connect(function() changeSourcePreset(-1) end)
	nextPresetButton.MouseButton1Click:Connect(function() changeSourcePreset(1) end)
	refreshAnimationPresetButton()
	local function sourceAssetId(value)
	if type(value) == "number" then return "rbxassetid://" .. tostring(value) end
	if type(value) == "string" and string.match(value, "^%d+$") then return "rbxassetid://" .. value end
	return value
	end
	local sourceAnimationOriginals = _G.__CrystalOriginalAnimations
	if type(sourceAnimationOriginals) ~= "table" then
	sourceAnimationOriginals = setmetatable({}, {__mode = "k"})
	_G.__CrystalOriginalAnimations = sourceAnimationOriginals
	end
	local function captureSourceAnimationOriginals(character, targets, saved)
	saved = saved or {}
	if next(saved) == nil then
		for name, target in pairs(targets) do
			if target then saved[name] = target.AnimationId end
		end
	end

	local humanoid = character:FindFirstChildOfClass("Humanoid")
	local ok, description = pcall(function()
		return humanoid and humanoid:GetAppliedDescription()
	end)
	if ok and description then
		local function useDescription(name, property)
			local value = tonumber(description[property])
			if value and value > 0 and targets[name] then
				saved[name] = "rbxassetid://" .. tostring(value)
			end
		end
		useDescription("idle1", "IdleAnimation")
		useDescription("idle2", "IdleAnimation")
		useDescription("walk", "WalkAnimation")
		useDescription("run", "RunAnimation")
		useDescription("jump", "JumpAnimation")
		useDescription("fall", "FallAnimation")
		useDescription("climb", "ClimbAnimation")
		useDescription("swim", "SwimAnimation")
		useDescription("swimidle", "SwimAnimation")
	end
	return saved
	end
	local function applySourcePreset(presetName, restoreOriginal)
	local character = Player.Character
	local animate = character and (character:FindFirstChild("Animate") or character:WaitForChild("Animate", 3))
	if not animate then return false end
	local targets = {
		idle1 = animate:FindFirstChild("idle") and animate.idle:FindFirstChild("Animation1"),
		idle2 = animate:FindFirstChild("idle") and animate.idle:FindFirstChild("Animation2"),
		walk = animate:FindFirstChild("walk") and animate.walk:FindFirstChild("WalkAnim"),
		run = animate:FindFirstChild("run") and animate.run:FindFirstChild("RunAnim"),
		jump = animate:FindFirstChild("jump") and animate.jump:FindFirstChild("JumpAnim"),
		fall = animate:FindFirstChild("fall") and animate.fall:FindFirstChild("FallAnim"),
		climb = animate:FindFirstChild("climb") and animate.climb:FindFirstChild("ClimbAnim"),
		swim = animate:FindFirstChild("swim") and animate.swim:FindFirstChild("Swim"),
		swimidle = animate:FindFirstChild("swimidle") and animate.swimidle:FindFirstChild("SwimIdle"),
	}
	if restoreOriginal then
		local saved = sourceAnimationOriginals[character]
		if not saved then return false end
		for name, value in pairs(saved) do
			if targets[name] then targets[name].AnimationId = value end
		end
	else
		local preset = animationPresets[presetName]
		if not preset then return false end

		sourceAnimationOriginals[character] = captureSourceAnimationOriginals(
			character,
			targets,
			sourceAnimationOriginals[character]
		)
		local idle = preset.Idle or {}
		local values = {
			idle1 = preset.Animation1 or idle[1], idle2 = preset.Animation2 or idle[2],
			walk = preset.WalkAnim, run = preset.RunAnim, jump = preset.JumpAnim,
			fall = preset.FallAnim, climb = preset.ClimbAnim, swim = preset.Swim, swimidle = preset.SwimIdle,
		}
		for name, value in pairs(values) do
			if targets[name] and value then targets[name].AnimationId = sourceAssetId(value) end
		end
	end
	local humanoid = character:FindFirstChildOfClass("Humanoid")
	if humanoid then
		for _, track in ipairs(humanoid:GetPlayingAnimationTracks()) do pcall(function() track:Stop(0) end) end
	end
	return true
	end
	FeaturePostToggle["Animaciones"] = function(active)

	toggleStates["Harder Hit Anim"] = false
	if active then
		_G.__CrystalAnimationPreset = selectedSourcePreset
		pcall(applySourcePreset, selectedSourcePreset, false)
	else
		pcall(applySourcePreset, nil, true)
	end
	if toggleVisualUpdaters["Harder Hit Anim"] then pcall(toggleVisualUpdaters["Harder Hit Anim"]) end
	end
	local animationToggleUpdater, animationToggleRow = toggleRow(
	animations,
	"Animations",
	"Animaciones",
	toggleStates["Animaciones"],
	2,
	false,
	function(on) setFeature("Animaciones", on) end
	)
	animationToggleRow.Name = "AnimationsMasterToggle"
	animationToggleRow.Visible = true
	animationToggleRow.ZIndex = 8
	local animationStateButton = modeButton(
	animationToggleRow,
	toggleStates["Animaciones"] and "ON" or "OFF",
	function()
	setFeature("Animaciones", not toggleStates["Animaciones"])
	return toggleStates["Animaciones"] and "ON" or "OFF"
	end
	)
	local function refreshAnimationToggle()
	animationToggleUpdater(toggleStates["Animaciones"] == true)
	animationStateButton.Text = toggleStates["Animaciones"] and "ON" or "OFF"
	end
	toggleVisualUpdaters["Animaciones"] = refreshAnimationToggle
	refreshAnimationToggle()
	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function()
	if not toggleStates["Animaciones"] or not _G.__CrystalAnimationPreset then return end
	task.wait(0.75)
	pcall(applySourcePreset, _G.__CrystalAnimationPreset, false)
	end))
	if toggleStates["Animaciones"] and _G.__CrystalAnimationPreset then
	task.defer(function()
	task.wait(0.5)
	pcall(applySourcePreset, _G.__CrystalAnimationPreset, false)
	end)
	end
	local animationInfo = keepOriginalText(Instance.new("TextLabel"))
	animationInfo.Size = UDim2.new(1, -8, 0, 30)
	animationInfo.BackgroundTransparency = 1
	animationInfo.LayoutOrder = 4
	animationInfo.Text = "Use < and > to apply and save automatically. The toggle enables or disables animations."
	animationInfo.TextColor3 = C.textDim
	animationInfo.TextSize = 10
	animationInfo.Font = Enum.Font.Gotham
	animationInfo.TextWrapped = true
	animationInfo.TextXAlignment = Enum.TextXAlignment.Left
	animationInfo.Parent = animations

	local activeCategory = "Movement"
	local tabDisplayNames = {
		Movement = "SPEEDS",
		Combat = "COMBAT",
		Visual = "VISUAL",
		Animations = "ANIMS",
	}
	for order, name in ipairs({"Movement", "Combat", "Visual", "Animations"}) do
	local button = keepOriginalText(Instance.new("TextButton"))
	button.Name = name .. "Button"
	button.Size = UDim2.new(0.25, isMobile and -3 or -5, 0, isMobile and 26 or 30)
	button.BackgroundColor3 = name == activeCategory and C.accent or Color3.fromRGB(18, 18, 22)
	button:SetAttribute("CurtThemeRole", name == activeCategory and "Accent" or "BgDark")
	button.BackgroundTransparency = name == activeCategory and 0.05 or 0.35
	button.BorderSizePixel = 0
	button.Text = tabDisplayNames[name] or string.upper(name)
	button.TextColor3 = name == activeCategory and Color3.fromRGB(12, 12, 14) or C.text
	button.TextSize = isMobile and 8 or 9
	button.Font = Enum.Font.GothamBlack
	button.LayoutOrder = order
	button.Parent = categoryList
	corner(button, 10)
	local indicator = Instance.new("Frame")
	indicator.Name = "Indicator"
	indicator.Size = UDim2.new(0, 0, 0, 0)
	indicator.BackgroundTransparency = 1
	indicator.Visible = false
	indicator.Parent = button
	button.MouseButton1Click:Connect(function()
	if activeCategory == name then return end
	activeCategory = name
	for pageName, page in pairs(pages) do
	local selectedPage = pageName == name
	page.Visible = selectedPage
	if selectedPage then
	local pageScale = pageScales[pageName]
	if pageScale then
	pageScale.Scale = 0.975
	tween(pageScale, {Scale = 1}, 0.2, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
	end
	end
	end
	for _, other in ipairs(categoryList:GetChildren()) do
	if other:IsA("TextButton") then
	local selected = other.Name == name .. "Button"
	other:SetAttribute("CurtThemeRole", selected and "Accent" or "BgDark")
	tween(other, {
	BackgroundColor3 = selected and C.accent or Color3.fromRGB(18, 18, 22),
	BackgroundTransparency = selected and 0.05 or 0.35,
	TextColor3 = selected and Color3.fromRGB(12, 12, 14) or C.text,
	}, 0.18)
	end
	end
	end)
	button.MouseEnter:Connect(function()
	if activeCategory ~= name then
		tween(button, {BackgroundTransparency = 0.2, TextColor3 = C.text})
	end
	end)
	button.MouseLeave:Connect(function()
	if activeCategory ~= name then
		tween(button, {BackgroundTransparency = 0.35, TextColor3 = C.text})
	end
	end)
	end
	refreshCategoryTextColors = function()
	for _, categoryButton in ipairs(categoryList:GetChildren()) do
	if categoryButton:IsA("TextButton") then
		local selected = categoryButton.Name == activeCategory .. "Button"
		categoryButton.BackgroundColor3 = selected and C.accent or Color3.fromRGB(18, 18, 22)
		categoryButton.BackgroundTransparency = selected and 0.05 or 0.35
		categoryButton.TextColor3 = selected and Color3.fromRGB(12, 12, 14) or C.text
		categoryButton:SetAttribute("CurtThemeRole", selected and "Accent" or "BgDark")
	end
	end
	end
	refreshCategoryTextColors()
	setTabPosition("Down")
	if _G.__CrystalApplyCurtVisualTheme then pcall(_G.__CrystalApplyCurtVisualTheme, bgIndex) end

	local miniButton = Instance.new("TextButton")
	keepOriginalText(miniButton)
	miniButton.Name = "EclipseRestoreButton"
	miniButton.Size = UDim2.new(0, 120, 0, 30)
	local savedMiniPos = _G["_CrystalHub_UI_ModernMiniPos"]
	miniButton.Position = savedMiniPos and UDim2.fromOffset(savedMiniPos.x or 6, savedMiniPos.y or 54) or UDim2.new(0, 6, 0, 54)
	miniButton.BackgroundColor3 = C.bgDark
	miniButton:SetAttribute("CurtThemeRole", "BgDark")
	miniButton.BorderSizePixel = 0
	miniButton.Text = "VYLO"
	miniButton.TextColor3 = C.text
	miniButton.TextSize = 11
	miniButton.Font = Enum.Font.GothamBlack
	miniButton.Visible = not Panel.Visible
	miniButton.ZIndex = 900
	miniButton.Parent = ScreenGui
	corner(miniButton, 8)
	stroke(miniButton, Color3.fromRGB(45, 45, 45), 1.2)

	local function applyCurtVisualTheme(selectedIndex)
		local palette = getCurtThemePreset(selectedIndex)
		for key, value in pairs(palette) do C[key] = value end
		_G.__CrystalHalloweenMode = false
		toggleStates["Halloween Mode"] = false
		_G.__CrystalCurtAccent = C.accent
		_G.__CrystalThemeAccent = C.accent
		if _G.__CrystalApplyAutoStealBarTheme then pcall(_G.__CrystalApplyAutoStealBarTheme, selectedIndex) end
		inner.BackgroundColor3 = C.bg
		local selectedBackground = backgroundIds[tonumber(selectedIndex) or 1] or backgroundIds[1]
		background.Image = selectedBackground
		if BgImage then BgImage.Image = selectedBackground end
		local backgroundCorner = background:FindFirstChildOfClass("UICorner")
		background.Size = UDim2.fromScale(1, 1)
		background.Position = UDim2.fromOffset(0, 0)
		if backgroundCorner then backgroundCorner.CornerRadius = UDim.new(0, 10) end
		innerStroke.Transparency = 1
		if mainShade then mainShade.Visible = activeGuiTheme ~= "GUI 1" end

		statsPanel.BackgroundColor3 = C.bgDark
		statsPanel:SetAttribute("CurtThemeRole", "BgDark")
		closeButton.BackgroundColor3 = C.bgDark
		closeButton:SetAttribute("CurtThemeRole", "BgDark")
		miniButton.BackgroundColor3 = C.bgDark
		miniButton:SetAttribute("CurtThemeRole", "BgDark")
		separator.BackgroundColor3 = C.accent
		separator:SetAttribute("CurtThemeRole", "Accent")
		bottomTabs.BackgroundColor3 = C.bgDark
		bottomTabs:SetAttribute("CurtThemeRole", "BgDark")
		for _, extraName in ipairs({"UnifiedPanelWhiteOutline", "UnifiedPanelWhiteGlow"}) do
			local extra = inner:FindFirstChild(extraName)
			if extra then extra:Destroy() end
		end
		-- keep corners consistent so nothing pokes out
		local ic = inner:FindFirstChildOfClass("UICorner")
		if ic then ic.CornerRadius = UDim.new(0, 10) end
		if wordMark then wordMark.ImageColor3 = C.accent end
		if wordGlow then wordGlow.ImageColor3 = C.accent end
		for _, descendant in ipairs(inner:GetDescendants()) do
			if descendant:IsA("GuiObject") then
				local role = descendant:GetAttribute("CurtThemeRole")
				if role == "AccentDim" then
					descendant.BackgroundColor3 = C.accentDim
				elseif role == "Accent" then
					descendant.BackgroundColor3 = C.accent
				elseif role == "Row" then
					descendant.BackgroundColor3 = C.row
				elseif role == "BgDark" then
					descendant.BackgroundColor3 = C.bgDark
				elseif role == "SwitchKnob" then
					descendant.BackgroundColor3 = C.text
				end
			end
			if descendant:IsA("TextLabel") or descendant:IsA("TextButton") or descendant:IsA("TextBox") then
				if descendant == FPSLabel or descendant == PingLabel then
					descendant.TextColor3 = descendant == FPSLabel and C.text or C.textDim
				elseif descendant ~= closeButton then
					pcall(function() descendant.TextColor3 = C.text end)
				end
				if descendant.Name == "SectionLabel" then pcall(function() descendant.TextColor3 = C.textDim end) end
				if descendant:IsA("TextBox") and descendant:GetAttribute("CurtThemeAccentInput") then
					descendant.BackgroundColor3 = C.accentDim
					descendant:SetAttribute("CurtThemeRole", "AccentDim")
				end
			end
			if descendant:IsA("Frame") then
				if descendant.Name == "Indicator" or descendant.Name == "ActiveMarker" then
					descendant.BackgroundColor3 = C.accent
					descendant:SetAttribute("CurtThemeRole", "Accent")
				elseif descendant:GetAttribute("CrystalButtonThemeControl") then
					descendant.BackgroundColor3 = C.row
					descendant:SetAttribute("CurtThemeRole", "Row")
				elseif descendant.Name == "BottomTabs" then
					descendant.BackgroundColor3 = C.bgDark
					descendant:SetAttribute("CurtThemeRole", "BgDark")
				end
			end
			if descendant:IsA("TextButton") then
				if descendant.Parent == categoryList then
					descendant.BackgroundColor3 = C.accentDim
					descendant:SetAttribute("CurtThemeRole", "AccentDim")
				elseif descendant ~= closeButton and descendant ~= miniButton and descendant.Text ~= "" then
					local alpha = descendant.BackgroundTransparency
					if alpha < 0.95 then
						descendant.BackgroundColor3 = descendant:GetAttribute("CrystalButtonThemeControl") and C.row or C.accentDim
					end
				end
			end
			if descendant:IsA("UIStroke") then
				if descendant.Parent and descendant.Parent.Name == "BottomTabs" then
					descendant.Color = C.divider
				elseif descendant.Parent and descendant.Parent:IsA("GuiObject") then
					if descendant.Parent:GetAttribute("CrystalButtonThemeControl") then
						descendant.Color = C.divider
					elseif descendant.Parent == closeButton or descendant.Parent == miniButton or descendant.Parent == statsPanel then
						descendant.Color = C.divider
					else
						descendant.Color = C.accentDim
					end
				end
			end
		end
		-- Repaint every active control immediately; changing a color must never
		-- require toggling a feature off and back on.
		for _, refreshToggle in pairs(toggleVisualUpdaters) do
			pcall(refreshToggle)
		end
		if refreshCategoryTextColors then refreshCategoryTextColors() end
		if _G.__refreshSpeedBillboards then pcall(_G.__refreshSpeedBillboards) end
		if _G.__CrystalRefreshQuickButtonTheme then pcall(_G.__CrystalRefreshQuickButtonTheme) end
	end
	_G.__CrystalApplyCurtVisualTheme = applyCurtVisualTheme
	applyCurtVisualTheme(bgIndex)
	makeDraggable(miniButton, miniButton)

	closeButton.MouseButton1Click:Connect(function()
	if _G.__setPanelVisible then _G.__setPanelVisible(false) else Panel.Visible = false end
	end)
	miniButton.MouseButton1Click:Connect(function()
	if _G.__setPanelVisible then _G.__setPanelVisible(true) else Panel.Visible = true end
	end)
	Panel:GetPropertyChangedSignal("Visible"):Connect(function()
	_G.__CrystalPanelVisible = Panel.Visible
	toggleStates["Toggle UI"] = Panel.Visible
	miniButton.Visible = not Panel.Visible
	saveConfig()
	end)

	local function keepNewPanelSize()
	local camera = workspace.CurrentCamera
	if not camera then return end
	local viewport = camera.ViewportSize
	if viewport.X <= 0 or viewport.Y <= 0 then return end
	local availableW = math.max(1, viewport.X - 12)
	local availableH = math.max(1, viewport.Y - 60)
	if isMobile then
	Panel.Size = UDim2.new(0, math.min(availableW, math.clamp(math.floor(viewport.X * 0.52), 205, 255)), 0, math.min(availableH, math.clamp(math.floor(viewport.Y * 0.82), 420, 560)))
	else
	Panel.Size = UDim2.new(0, math.min(310, availableW), 0, math.min(620, availableH))
	end
	for _, target in ipairs({Panel, miniButton}) do
	local position = target.Position
	placeInsideViewport(target, position.X.Scale, position.X.Offset, position.Y.Scale, position.Y.Offset)
	end
	end
	keepNewPanelSize()
	local viewportConnection
	local function watchModernCamera()
	if viewportConnection then viewportConnection:Disconnect(); viewportConnection = nil end
	local camera = workspace.CurrentCamera
	if camera then
	viewportConnection = _G.__CrystalTrackConn(camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
	task.defer(keepNewPanelSize)
	end))
	end
	task.defer(keepNewPanelSize)
	end
	_G.__CrystalTrackConn(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(watchModernCamera))
	watchModernCamera()
	end)()
	_G.__CrystalRegisterThemeRoot(ScreenGui)

	task.spawn(function()
	local blackout = Instance.new("Frame")
	blackout.Size = UDim2.new(1, 0, 1, 0)
	blackout.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	blackout.BackgroundTransparency = 1
	blackout.BorderSizePixel = 0
	blackout.ZIndex = 10000
	blackout.Parent = ScreenGui
	TweenService:Create(blackout, TweenInfo.new(0.08, Enum.EasingStyle.Quad), {BackgroundTransparency = 0.45}):Play()
	task.wait(0.12)
	TweenService:Create(blackout, TweenInfo.new(0.25, Enum.EasingStyle.Quad), {BackgroundTransparency = 1}):Play()
	task.wait(0.3)
	pcall(function() blackout:Destroy() end)
	end)

	;(function()
	local function keyDisplayName(kc)
	if not kc then return "..." end
	return keybindDisplayName(kc)
	end

	local function handleKeyInput(input, gameProcessed)

	if listeningBindBtn and listeningFeature then
	local updatedFeature = listeningFeature
	local isTouchOrClick = (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1)
	if isBindableInput(input) or isTouchOrClick or isMouseSideButton(input) then
	if isTouchOrClick or input.KeyCode == Enum.KeyCode.Escape or (isClearKeybindInput(input) and updatedFeature ~= "Toggle UI") then
	FeatureKeybinds[updatedFeature] = nil
	local emptyText = (listeningBindBtn.Size.X.Offset == 42 or listeningBindBtn:GetAttribute("MiniUIBind")) and "-" or "BIND"
	listeningBindBtn.Text = emptyText
	elseif isMouseSideButton(input) then
	local mbName = getMouseButtonBind(input)
	FeatureKeybinds[updatedFeature] = mbName
	listeningBindBtn.Text = mouseButtonDisplay[mbName] or mbName
	else
	FeatureKeybinds[updatedFeature] = input.KeyCode
	listeningBindBtn.Text = keyDisplayName(input.KeyCode)
	end
	listeningBindBtn.BackgroundColor3 = Color3.fromRGB(210,230,250)
	listeningBindBtn.TextColor3 = Color3.fromRGB(80,130,200)
	listeningBindBtn = nil
	listeningFeature = nil
	saveConfig()
	if updatedFeature and toggleVisualUpdaters[updatedFeature] then toggleVisualUpdaters[updatedFeature]() end
	local mapped = _featureToggleMap[updatedFeature]
	if mapped and mapped.bindCircle then
	local k = FeatureKeybinds[updatedFeature]
	mapped.bindCircle.Text = k and keyDisplayName(k) or "-"
	end
	return
	end
	end

	if UserInputService:GetFocusedTextBox() then return end

	local carryKey = FeatureKeybinds["Carry Speed"]
	local carryKeyMatches = carryKey ~= nil and (
		(isBindableInput(input) and input.KeyCode == carryKey)
		or (isMouseSideButton(input) and getMouseButtonBind(input) == carryKey)
	)
	local normalModeKey = FeatureKeybinds["SelectNormalMode"]
	local normalModeKeyMatches = normalModeKey ~= nil and (
		(isBindableInput(input) and input.KeyCode == normalModeKey)
		or (isMouseSideButton(input) and getMouseButtonBind(input) == normalModeKey)
	)

	if normalModeKeyMatches and selectedMode ~= "Normal" then
		if FeatureToggles["SelectNormalMode"] then
			FeatureToggles["SelectNormalMode"]()
		end
		pcall(function() if _G.__refreshSpeedBoost then _G.__refreshSpeedBoost() end end)
		pcall(function() if _G.__refreshSpeedBillboards then _G.__refreshSpeedBillboards() end end)
		saveConfig()
		return
	end
	if carryKeyMatches then
		if FeatureToggles["Carry Speed"] then
			FeatureToggles["Carry Speed"]()
		else
			local active = not toggleStates["Carry Speed"]
			toggleStates["Carry Speed"] = active
			speedToggled = active
			if FeaturePostToggle["Carry Speed"] then FeaturePostToggle["Carry Speed"](active) end
			if toggleVisualUpdaters["Carry Speed"] then toggleVisualUpdaters["Carry Speed"]() end
			saveConfig()
		end
		return
	end

	local autoLeftKey = FeatureKeybinds["Auto Left"]
	local autoLeftKeyMatches = autoLeftKey ~= nil and (
	(isBindableInput(input) and input.KeyCode == autoLeftKey)
	or (isMouseSideButton(input) and getMouseButtonBind(input) == autoLeftKey)
	)
	if autoLeftKeyMatches then
	if FeatureToggles["Auto Left"] then FeatureToggles["Auto Left"]() end
	return
	end
	local autoRightKey = FeatureKeybinds["Auto Right"]
	local autoRightKeyMatches = autoRightKey ~= nil and (
	(isBindableInput(input) and input.KeyCode == autoRightKey)
	or (isMouseSideButton(input) and getMouseButtonBind(input) == autoRightKey)
	)
	if autoRightKeyMatches then
	if FeatureToggles["Auto Right"] then FeatureToggles["Auto Right"]() end
	return
	end
	local dropKey = FeatureKeybinds["Drop"]
	local dropKeyMatches = dropKey ~= nil and (
	(isBindableInput(input) and input.KeyCode == dropKey)
	or (isMouseSideButton(input) and getMouseButtonBind(input) == dropKey)
	)
	if dropKeyMatches then
	if FeatureToggles["Drop"] then FeatureToggles["Drop"]("keybind") end
	return
	end
	if gameProcessed and not gamepadInputTypes[input.UserInputType] then return end

	if isBindableInput(input) then
	for feat, key in pairs(FeatureKeybinds) do
	if input.KeyCode == key then
	if FeatureToggles[feat] then
	if feat == "Drop" then FeatureToggles[feat]("keybind") else FeatureToggles[feat]() end
	else
	local active = not toggleStates[feat]
	toggleStates[feat] = active
	saveConfig()
	if FeaturePostToggle[feat] then FeaturePostToggle[feat](active) end
	if toggleVisualUpdaters[feat] then toggleVisualUpdaters[feat]() end
	end
	end
	end
	end

	if isMouseSideButton(input) then
	local mbBind = getMouseButtonBind(input)
	for feat, key in pairs(FeatureKeybinds) do
	if key == mbBind then
	if FeatureToggles[feat] then
	if feat == "Drop" then FeatureToggles[feat]("keybind") else FeatureToggles[feat]() end
	else
	local active = not toggleStates[feat]
	toggleStates[feat] = active
	saveConfig()
	if FeaturePostToggle[feat] then FeaturePostToggle[feat](active) end
	if toggleVisualUpdaters[feat] then toggleVisualUpdaters[feat]() end
	end
	end
	end
	end

	end

	_G.__CrystalTrackConn(UserInputService.InputBegan:Connect(handleKeyInput))
	end)()

	;(function()
	local infJumpState = _G.__CrystalInfJumpState or {}
	_G.__CrystalInfJumpState = infJumpState
	infJumpState.conn = infJumpState.conn or nil
	infJumpState.lastJumpTime = infJumpState.lastJumpTime or 0
	infJumpState.manualLock = false
	local HOP_POWER = 55
	local HOP_COOLDOWN = 0.08

	local function isJumpBlocked()
	return false
	end

	local function triggerManualJump()
	if (_G.__CrystalInfJumpMode or "hold") ~= "manual" or infJumpState.manualLock then return end
	infJumpState.manualLock = true
	local char = Player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	local hrp = char and char:FindFirstChild("HumanoidRootPart")
	if not hum or not hrp then
	infJumpState.manualLock = false
	return
	end
	local now = tick()
	if (now - infJumpState.lastJumpTime) < HOP_COOLDOWN then
	infJumpState.manualLock = false
	return
	end
	infJumpState.lastJumpTime = now
	hrp.Velocity = Vector3.new(hrp.Velocity.X, HOP_POWER, hrp.Velocity.Z)
	task.delay(0.14, function() infJumpState.manualLock = false end)
	end

	_G.__CrystalTrackConn(UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.Space or input.KeyCode == Enum.KeyCode.ButtonA then
	if (_G.__CrystalInfJumpMode or "hold") == "manual" then
	triggerManualJump()
	return
	end
	if not isJumpBlocked() then
	infJumpState.lastJumpTime = tick() - HOP_COOLDOWN
	end
	end
	end))

	function startInfJump()
	if infJumpState.conn then
	infJumpState.conn:Disconnect()
	infJumpState.conn = nil
	end

	infJumpState.conn = RunService.Heartbeat:Connect(function()
	if not toggleStates["Inf Jump"] or (_G.__CrystalInfJumpMode or "hold") ~= "hold" then return end
	if isJumpBlocked() then return end
	pcall(function()
	local char = Player.Character
	if not char then return end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	local hrp = char:FindFirstChild("HumanoidRootPart")
	if not hrp then return end
	local now = tick()
	local wantsToJump = UserInputService:IsKeyDown(Enum.KeyCode.Space) or UserInputService:IsKeyDown(Enum.KeyCode.ButtonA) or hum.Jump == true
	if wantsToJump and (now - infJumpState.lastJumpTime) >= HOP_COOLDOWN then
	infJumpState.lastJumpTime = now
	local velocity = hrp.Velocity
	hrp.Velocity = Vector3.new(velocity.X, HOP_POWER, velocity.Z)
	end
	end)
	end)
	end

function stopInfJump()
	if infJumpState.conn then
	infJumpState.conn:Disconnect()
	infJumpState.conn = nil
end
end
_G.__CrystalTrackStopper(stopInfJump)
FeaturePostToggle["Inf Jump"] = function(active)
if active and (_G.__CrystalInfJumpMode or "hold") == "hold" then
startInfJump()
else
stopInfJump()
end
end
if toggleStates["Inf Jump"] and (_G.__CrystalInfJumpMode or "hold") == "hold" then startInfJump() end

	_G.__CrystalTrackConn(Player.CharacterAdded:Connect(function()
	if toggleStates["Inf Jump"] and (_G.__CrystalInfJumpMode or "hold") == "hold" then
	task.wait(0.5)
	stopInfJump()
	startInfJump()
	end
	end))
	end)()


	-- ==================== FONT CHANGER (from Ambitious) ====================
	do
_G.CrystalFonts = _G.CrystalFonts or {}
_G.CrystalFonts.orig = _G.CrystalFonts.orig or {}
_G.CrystalFonts.conns = _G.CrystalFonts.conns or {}
-- TextSize di partenza di ogni elemento, per l'adattamento automatico.
-- Strong come orig: senza il valore originale il ripristino non tornerebbe.
_G.CrystalFonts.size = _G.CrystalFonts.size or {}
_G.CrystalFontChoice = "Default"

-- Nome breve del peso, per l'etichetta della card.
_G.CrystalFonts.WEIGHT_LABEL = {
  Thin = "Thin", ExtraLight = "ExLight", Light = "Light", Regular = "",
  Medium = "Medium", SemiBold = "SemiBold", Bold = "Bold",
  ExtraBold = "ExBold", Heavy = "Heavy",
}

-- Catalogo completo, costruito una volta sola e tenuto in cache: sono
-- centinaia di voci, rifarle a ogni apertura del popup sarebbe sprecato.
function _G.CrystalFonts.list()
  local F = _G.CrystalFonts
  if F.cache then return F.cache end

  local out = {{ key = "Default", label = "Default", font = nil }}

  -- Famiglie uniche ricavate da Enum.Font. Si parte da li' perche' e'
  -- l'unico elenco che il motore garantisce: niente id inventati.
  local seen, families = {}, {}
  for _, item in ipairs(Enum.Font:GetEnumItems()) do
    if item.Name ~= "Unknown" then
      local ok, f = pcall(function() return Font.fromEnum(item) end)
      if ok and f and f.Family and not seen[f.Family] then
        seen[f.Family] = true
        -- Nome leggibile: dal percorso rbxasset si tiene solo il file.
        local nice = tostring(f.Family):match("([^/\\]+)%.json$")
                  or tostring(f.Family):match("([^/\\]+)$")
                  or item.Name
        families[#families + 1] = { family = f.Family, nice = nice }
      end
    end
  end

  for _, fam in ipairs(families) do
    for _, w in ipairs(Enum.FontWeight:GetEnumItems()) do
      for _, italic in ipairs({false, true}) do
        local ok, f = pcall(function()
          return Font.new(fam.family, w,
            italic and Enum.FontStyle.Italic or Enum.FontStyle.Normal)
        end)
        if ok and f then
          local wl = F.WEIGHT_LABEL[w.Name] or w.Name
          local label = fam.nice
          if wl ~= "" then label = label .. " " .. wl end
          if italic then label = label .. " Italic" end
          out[#out + 1] = {
            key = fam.family .. "|" .. w.Name .. "|" .. (italic and "i" or "n"),
            label = label,
            font = f,
          }
        end
      end
    end
  end

  F.cache = out
  return out
end

function _G.CrystalFonts.byKey(key)
  for _, e in ipairs(_G.CrystalFonts.list()) do
    if e.key == key then return e end
  end
  return nil
end

-- I contenitori da percorrere. HubGui copre tutte le ScreenGui della hub;
-- il billboard sopra la testa vive sulla Head e va aggiunto a mano.
function _G.CrystalFonts.roots()
  local list = {}
  local core = game:GetService("CoreGui")
  local pg = Player.PlayerGui
  for _, container in ipairs({core, pg}) do
    pcall(function()
      local sg = container:FindFirstChild("VyloHub") or container:FindFirstChild("EclipseHub")
      if sg then list[#list + 1] = sg end
    end)
  end
  local char = Player.Character
  local head = char and char:FindFirstChild("Head")
  if head then
    for _, n in ipairs({"Green22sBB", "22sSpeedBill", "CrystalHubOverhead", "22sHubOverhead"}) do
      local oh = head:FindFirstChild(n)
      if oh then list[#list + 1] = oh end
    end
  end
  return list
end

function _G.CrystalFonts.isGlyph(obj)
  local t = obj.Text
  if t == nil then return false end
  -- Una lettera o una cifra sono scrittura anche da sole: la "Q" di una
  -- keybind o la "X" di un bottone sono caratteri normali, e devono
  -- seguire il font come tutto il resto. L'esenzione vale solo per i
  -- segni: ▲ ▼ ◀ ▶ - +.
  if string.match(t, "%w") then return false end
  local ok, n = pcall(function() return utf8.len(t) end)
  return ok and n ~= nil and n <= 1
end

function _G.CrystalFonts.applyOne(obj, font)
  if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then
    return
  end
  -- Elementi esenti: le anteprime del popup dei font devono mostrare
  -- CIASCUNA il proprio campione. Sono dentro la hub come tutto il resto,
  -- quindi senza questa uscita il font scelto le sovrascriverebbe e i
  -- campioni diventerebbero tutti uguali fra loro.
  if obj:GetAttribute("CrystalFontLock") then return end
  local F = _G.CrystalFonts
  -- Primo contatto: si conservano FontFace e TextSize di partenza.
  if F.orig[obj] == nil then
    F.orig[obj] = obj.FontFace
    F.size[obj] = obj.TextSize
  end
  if F.isGlyph(obj) then font = nil end   -- i simboli restano l'originale
  pcall(function()
    obj.FontFace = font or F.orig[obj]
    -- Si riparte SEMPRE dalla misura originale: l'adattamento sotto
    -- puo' solo rimpicciolire, mai ingrandire oltre com'era. Su Default
    -- questa riga e' anche il ripristino, e nessun adattamento segue.
    if F.size[obj] then obj.TextSize = F.size[obj] end
  end)
end

-- ADATTAMENTO AUTOMATICO DELLA MISURA
-- Ogni famiglia ha larghezze diverse: lo stesso testo che con Gotham sta
-- dentro la riga, con un font piu' largo esce dai margini.
--
-- La misura si CALCOLA, non si cerca a tentativi: GetTextBoundsAsync dice
-- quanto occuperebbe quel testo con quel font a quella misura, e con due
-- divisioni si ricava di quanto scalare. Ogni scritta e' a posto al primo
-- colpo, anche quelle che in quel momento non sono a schermo — le
-- dimensioni esistono comunque, mentre TextFits lo calcola il motore solo
-- su cio' che disegna, ed era per quello che si adattava la sola tab
-- aperta.
--
-- MARGIN: non basta che il testo "ci stia", deve anche non arrivare
-- appiccicato al bottone che ha accanto. Si toglie quel tanto di spazio
-- dai lati prima di fare il conto.
--
-- Su "Default" non gira affatto: le misure restano quelle di sempre.
_G.CrystalFonts.MIN_SIZE = 7    -- sotto e' illeggibile
_G.CrystalFonts.MARGIN   = 8    -- respiro ai lati, in pixel
_G.CrystalFonts.MAX_GROW = 1.35 -- quanto al massimo puo' crescere
-- Chiavi deboli: qui non si conserva niente da ripristinare, sono solo
-- appunti su chi e' gia' stato agganciato. Se l'oggetto sparisce dalla
-- GUI puo' sparire anche l'appunto.
_G.CrystalFonts.tconns = _G.CrystalFonts.tconns
  or setmetatable({}, {__mode = "k"})
-- Lunghezza del testo con cui ogni scritta e' stata adattata l'ultima
-- volta, per non rifare il conto a vuoto su un contatore che cambia cifra
-- restando lungo uguale.
_G.CrystalFonts.lastLen = _G.CrystalFonts.lastLen
  or setmetatable({}, {__mode = "k"})

function _G.CrystalFonts.params()
  local F = _G.CrystalFonts
  if F.gtbp == nil then
    local ok, p = pcall(function() return Instance.new("GetTextBoundsParams") end)
    F.gtbp = (ok and p) or false
  end
  return F.gtbp or nil
end

-- ------------------------------------------------------------
-- Il conto e' in DUE parti, e la differenza e' tutta qui.
--
-- 1) LA MISURA (costosa): quanto occupa quel testo col font nuovo e
--    quanto occupava col font originale. Da queste due nasce il rapporto
--    s0 — quanto scalare per avere lo stesso ingombro che la scritta
--    aveva su Default. Non c'entra niente con la casella, quindi si puo'
--    fare subito, anche su una scritta appena nata che non e' ancora
--    stata impaginata.
--
-- 2) IL CONTENIMENTO (gratis): il testo deve stare dentro la sua casella.
--    Qui serve la dimensione vera, ma NON serve rimisurare niente: le
--    dimensioni del testo sono gia' in cache, e ridurle allo spazio
--    disponibile sono due divisioni.
--
-- Separandole si risolve il problema di prima. Le scritte dei popup
-- nascono mentre il riquadro si sta ancora aprendo, e la loro casella in
-- quel momento e' piu' piccola di quella finale: con un conto solo o si
-- sbagliava, o bisognava aspettare e correggere dopo — ed era quello che
-- si vedeva cambiare sotto gli occhi. Adesso la parte 1 si applica
-- all'istante e la parte 2 si riapplica da sola a ogni variazione della
-- casella, quindi mentre il popup si ingrandisce il testo lo segue e
-- arriva gia' giusto. Stessa cosa per una freccetta o una riga dentro una
-- tendina chiusa: quando compare e prende una dimensione, si sistema da
-- se' senza che nessuno la tocchi.
-- ------------------------------------------------------------
_G.CrystalFonts.m = _G.CrystalFonts.m or setmetatable({}, {__mode = "k"})
_G.CrystalFonts.aconns = _G.CrystalFonts.aconns
  or setmetatable({}, {__mode = "k"})
_G.CrystalFonts.stamp = _G.CrystalFonts.stamp or 0

-- Parte 2: solo aritmetica sui numeri gia' in cache.
function _G.CrystalFonts.reclamp(obj)
  local F = _G.CrystalFonts
  local c = F.m[obj]
  if not c then return end
  -- Stessa esenzione di fitOne: un simbolo solo resta com'era.
  if F.isGlyph(obj) then
    if obj.TextSize ~= c.base then obj.TextSize = c.base end
    return
  end
  local s = c.s0
  local box = obj.AbsoluteSize
  if box.X > 1 and box.Y > 1 then
    -- AutomaticSize: su quell'asse la casella non e' un limite, e' il
    -- testo stesso a deciderla. Contenere il testo dentro una casella che
    -- lo insegue non ha senso e per di piu' si morde la coda: cambio la
    -- misura -> cambia la casella -> l'aggancio scatta -> ricontengo ->
    -- cambio di nuovo la misura, e si finisce dove capita. Il contatore
    -- degli MS e quello degli FPS sono gli unici due cosi' fatti nella
    -- barra, ed e' per questo che uno dei due si ritrovava con una misura
    -- che non c'entrava niente.
    local auto = obj.AutomaticSize
    local freeX = (auto == Enum.AutomaticSize.X or auto == Enum.AutomaticSize.XY)
    local freeY = (auto == Enum.AutomaticSize.Y or auto == Enum.AutomaticSize.XY)
    if not freeY then
      s = math.min(s, math.max(box.Y - 2, 1) / c.by)
    end
    -- Il respiro laterale e' in pixel, ma su una casella stretta 8px sono
    -- un quinto dello spazio: sotto una certa larghezza si accorcia con
    -- lei, se no le scritte piccole (FPS, MS, la percentuale) si
    -- ridurrebbero a niente.
    if not (freeX or c.wrapped) then
      s = math.min(s, math.max(box.X - math.min(F.MARGIN, box.X * 0.08), 1) / c.bx)
    end
  end
  local want = math.floor(c.base * s + 0.5)
  if want < F.MIN_SIZE then want = F.MIN_SIZE end
  if obj.TextSize ~= want then obj.TextSize = want end
end

-- Parte 1: le due misurazioni, e il rapporto con l'ingombro di Default.
function _G.CrystalFonts.measure(obj)
  local F = _G.CrystalFonts
  local font = F.current()
  if not font then return false end
  local prm = F.params()
  if not prm then return false end
  F.tsvc = F.tsvc or game:GetService("TextService")

  local base = F.size[obj]
  if not base then base = obj.TextSize; F.size[obj] = base end

  local txt = obj.Text
  if txt == nil or txt == "" then
    F.m[obj] = {base = base, bx = 1, by = 1, s0 = 1, stamp = F.stamp, text = txt}
    return true
  end

  -- Con TextWrapped la larghezza e' vincolata e quello che conta e'
  -- l'altezza; senza, si misura su una riga sola.
  local wrapped = obj.TextWrapped and obj.AbsoluteSize.X > 1
  prm.Text = txt
  prm.Size = base
  prm.Width = wrapped and obj.AbsoluteSize.X or 0

  prm.Font = font
  local ok, b = pcall(function() return F.tsvc:GetTextBoundsAsync(prm) end)
  if not (ok and b and b.X > 0 and b.Y > 0) then return false end

  -- L'ingombro col font ORIGINALE e' il riferimento: e' com'era la GUI su
  -- Default. Il font nuovo va portato li' — se disegna piu' largo si
  -- rimpicciolisce, se disegna piu' stretto si INGRANDISCE.
  local s0 = 1
  local of = F.orig[obj]
  if of then
    prm.Font = of
    local ok2, b2 = pcall(function() return F.tsvc:GetTextBoundsAsync(prm) end)
    if ok2 and b2 and b2.X > 0 and b2.Y > 0 then
      -- Il confronto e' sulla LARGHEZZA: l'altezza dei due riquadri e'
      -- quasi sempre la stessa (la misura del font e' gia' l'altezza
      -- della riga) e quel rapporto vale circa 1 sempre. Sul testo a capo
      -- vale l'opposto, li' la larghezza e' fissa per definizione.
      s0 = wrapped and (b2.Y / b.Y) or (b2.X / b.X)
    end
  end
  -- Tetto alla crescita: un font molto stretto non deve diventare enorme
  -- solo perche' la casella e' larga.
  if s0 > F.MAX_GROW then s0 = F.MAX_GROW end

  F.m[obj] = {base = base, bx = b.X, by = b.Y, s0 = s0,
              wrapped = wrapped, stamp = F.stamp, text = txt}
  return true
end

-- Misura se serve, poi contiene. noBox e' rimasto per compatibilita': la
-- casella ormai la guarda solo reclamp, che e' gratis.
function _G.CrystalFonts.fitOne(obj)
  local F = _G.CrystalFonts
  if not F.current() then return end
  if obj:GetAttribute("CrystalFontLock") then return end
  if not (obj:IsA("TextLabel") or obj:IsA("TextButton") or obj:IsA("TextBox")) then return end
  if obj.TextScaled then return end

  -- I BOTTONI DI UN SEGNO SOLO NON SI TOCCANO, ne' nel font ne' nella
  -- misura: il criterio "stesso ingombro che aveva su Default" su un
  -- simbolo non vuol dire niente, e ricalcolarlo produceva solo quelle
  -- variazioni che sembravano un difetto quando li premevi.
  if F.isGlyph(obj) then return true end

  local c = F.m[obj]
  if not (c and c.stamp == F.stamp and c.text == obj.Text) then
    if not F.measure(obj) then return false end
  end
  F.reclamp(obj)
  return true
end

-- Aggancia una scritta: da qui in poi si tiene aggiornata da sola.
-- Un aggancio per oggetto, fatto una volta sola.
function _G.CrystalFonts.watch(obj)
  local F = _G.CrystalFonts
  if F.aconns[obj] then return end
  -- La casella cambia: durante l'apertura di un popup, con la GUI Scale,
  -- quando una tendina si apre. Qui non si rimisura niente, si ricontiene
  -- e basta.
  F.aconns[obj] = obj:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
    local G = _G.CrystalFonts
    if not G.current() then return end
    if G.m[obj] then G.reclamp(obj) else pcall(G.fitOne, obj) end
  end)
  if F.tconns[obj] then return end
  -- Il testo cambia: LOCK che diventa UNLOCK, una keybind, un contatore.
  -- Un contatore che passa da 58 a 59 pero' occupa lo stesso spazio, e
  -- rimisurarlo a ogni cifra sarebbe lavoro buttato su roba che cambia
  -- anche piu' volte al secondo: si rifa il conto quando cambia la
  -- lunghezza.
  F.tconns[obj] = obj:GetPropertyChangedSignal("Text"):Connect(function()
    local G = _G.CrystalFonts
    if not G.current() then return end
    if G.lastLen[obj] == #obj.Text then return end
    G.lastLen[obj] = #obj.Text
    -- Anche il font va rideciso: una scritta puo' diventare un simbolo
    -- solo (o smettere di esserlo) e l'esenzione cambia con lei.
    pcall(G.applyOne, obj, G.current())
    pcall(G.fitOne, obj)
  end)
end

function _G.CrystalFonts.fit(pass)
  local F = _G.CrystalFonts
  F.fitToken = (F.fitToken or 0) + 1
  local myToken = F.fitToken
  if not F.current() then return end   -- Default: nessuna modifica
  F.tsvc = F.tsvc or game:GetService("TextService")

  task.spawn(function()
    local list = {}
    for _, root in ipairs(F.roots()) do
      for _, d in ipairs(root:GetDescendants()) do
        if (d:IsA("TextLabel") or d:IsA("TextButton") or d:IsA("TextBox"))
           and not d.TextScaled and not d:GetAttribute("CrystalFontLock") then
          list[#list + 1] = d
        end
      end
    end

    for _, o in ipairs(list) do
      if F.fitToken ~= myToken then return end   -- font cambiato nel frattempo
      if o.Parent then
        F.fitOne(o)
        F.lastLen[o] = #o.Text
        F.watch(o)
      end
    end

    -- Un ripasso comunque: un font appena scelto puo' non essere ancora
    -- stato caricato dal motore, e finche' non lo e' le misure che
    -- tornano sono quelle del ripiego. Il secondo giro cade a
    -- caricamento finito. La cache viene buttata apposta, se no si
    -- riuserebbero proprio i numeri sbagliati.
    pass = (tonumber(pass) or 0) + 1
    if pass < 3 then
      task.delay(pass == 1 and 0.35 or 1.5, function()
        if F.fitToken ~= myToken then return end
        F.stamp = F.stamp + 1
        F.fit(pass)
      end)
    end
  end)
end

-- Font attualmente scelto, oppure nil se siamo su "Default".
function _G.CrystalFonts.current()
  local key = _G.CrystalFontChoice
  if not key or key == "Default" then return nil end
  local e = _G.CrystalFonts.byKey(key)
  return e and e.font or nil
end

function _G.CrystalFonts.applyAll()
  local F = _G.CrystalFonts
  local font = F.current()
  for _, root in ipairs(F.roots()) do
    F.applyOne(root, font)
    for _, d in ipairs(root:GetDescendants()) do
      F.applyOne(d, font)
    end
  end
  F.fit()
end

-- Aggancio a eventi, non a un loop: i popup e le righe create dopo
-- devono nascere gia' col font giusto, ma senza riscandire niente.
function _G.CrystalFonts.hook()
  local F = _G.CrystalFonts
  for _, c in ipairs(F.conns) do pcall(function() c:Disconnect() end) end
  F.conns = {}
  for _, root in ipairs(F.roots()) do
    F.conns[#F.conns + 1] = root.DescendantAdded:Connect(function(d)
      if _G.CrystalFontChoice == "Default" then return end
      F.applyOne(d, F.current())
      -- Subito, nello stesso istante in cui nasce: cosi' compare gia'
      -- della misura giusta invece di correggersi sotto gli occhi un
      -- attimo dopo. Il contenimento nella casella non serve aspettarlo,
      -- ci pensa l'aggancio qui sotto mentre il riquadro si apre.
      pcall(F.fitOne, d)
      pcall(F.watch, d)
    end)
  end
end

function _G.CrystalFonts.set(key, skipSave)
  _G.CrystalFontChoice = "Default"
  _G.CrystalFonts.stamp = (_G.CrystalFonts.stamp or 0) + 1
  _G.CrystalFonts.applyAll()
  _G.CrystalFonts.hook()
  -- Force overhead (discord + speed) to rebuild with new font
  pcall(function()
    if type(_G.__refreshSpeedBillboards) == "function" then
      -- re-apply style on existing labels
      local F = _G.CrystalFonts
      local font = F.current and F.current() or nil
      for _, p in ipairs(game:GetService("Players"):GetPlayers()) do
        local char = p.Character
        local head = char and char:FindFirstChild("Head")
        if head then
          for _, n in ipairs({"Green22sBB", "GreenDuelsBB", "22sSpeedBill"}) do
            local bb = head:FindFirstChild(n)
            if bb then
              for _, child in ipairs(bb:GetChildren()) do
                if child:IsA("TextLabel") then
                  F.applyOne(child, font)
                end
              end
            end
          end
        end
      end
    end
  end)
  if not skipSave and saveConfig then pcall(saveConfig) end
end

-- Il catalogo si costruisce una volta sola; farlo adesso in sottofondo
-- vuol dire che al primo click sul PICK e' gia' pronto in cache.
task.spawn(function() pcall(_G.CrystalFonts.list) end)


-- L'etichetta sopra la testa viene ricreata a ogni respawn: si riapplica
-- il font e si riaggancia il listener sul nuovo billboard.
if not _G.CrystalFonts.charConn then
  _G.CrystalFonts.charConn = Player.CharacterAdded:Connect(function()
    task.delay(1.5, function()
      if _G.CrystalFontChoice == "Default" then return end
      pcall(_G.CrystalFonts.applyAll)
      pcall(_G.CrystalFonts.hook)
    end)
  end)
end

  
	end

	ScreenGui.Enabled = true

	task.defer(function()
	for _, feature in ipairs({ "FPS Boost", "Anti Lag", "Optimizer" }) do
	if toggleStates[feature] and FeaturePostToggle[feature] then
	pcall(function() FeaturePostToggle[feature](true) end)
	end
	end
	end)

	end
	end)()
