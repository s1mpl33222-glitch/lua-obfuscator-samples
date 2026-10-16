--!nocheck
local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local MarketplaceService = game:GetService("MarketplaceService")
local ProximityPromptService = game:GetService("ProximityPromptService")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local Lighting = game:GetService("Lighting")
local Stats = game:GetService("Stats")
local VirtualUser = game:GetService("VirtualUser")
local Workspace = game:GetService("Workspace")

local LocalPlayer = Players.LocalPlayer
local camera = Workspace.CurrentCamera
local sessionStart = os.clock()

local DISCORD_INVITE = "https://discord.gg/X9BK63j9gb"
local REQUIRED_KEY = "2027"

local currentGameName = "Roblox"
task.spawn(function()
	local ok, info = pcall(function()
		return MarketplaceService:GetProductInfo(game.PlaceId)
	end)
	if ok and info and info.Name then
		currentGameName = info.Name
	end
end)

local function getGuiParent()
	local ok, res = pcall(function()
		if type(gethui) == "function" then return gethui() end
		return game:GetService("CoreGui")
	end)
	return (ok and res) or LocalPlayer:WaitForChild("PlayerGui")
end

local guiParent = getGuiParent()
for _, name in ipairs({
	"SkySettingsUI", "SkySettingsToggle", "SkyOverlayHUD", "SkyTeleporterUI",
	"LarpsMainUI", "LarpsToggleUI", "LarpsOverlayHUD", "LarpsTeleporterUI", "LarpsLoaderUI"
}) do
	local old = guiParent:FindFirstChild(name)
	if old then old:Destroy() end
end
pcall(function() RunService:UnbindFromRenderStep("LarpsAimbotLock") end)

-- ============================================================
-- BORDERLESS THEME, SPRITE ICONS & ANIMATION ENGINE
-- ============================================================
local THEME = {
	BG       = Color3.fromRGB(11, 12, 17),
	SIDE     = Color3.fromRGB(16, 18, 25),
	CARD     = Color3.fromRGB(21, 24, 33),
	CARD_HV  = Color3.fromRGB(29, 33, 46),
	INPUT    = Color3.fromRGB(14, 16, 22),
	TEXT     = Color3.fromRGB(246, 247, 252),
	SUBTEXT  = Color3.fromRGB(148, 154, 175),
	ACCENT   = Color3.fromRGB(235, 135, 50),
	GREEN    = Color3.fromRGB(70, 230, 140),
	RED      = Color3.fromRGB(250, 75, 90),
}

local SPRITE_SHEET = "rbxassetid://3926305904"
local ICONS = {
	Home     = Vector2.new(964, 204),
	Combat   = Vector2.new(124, 924),
	Movement = Vector2.new(604, 444),
	Teleport = Vector2.new(924, 244),
	Visuals  = Vector2.new(84, 44),
	Server   = Vector2.new(604, 324),
	Tune     = Vector2.new(684, 724),
	Toggle   = Vector2.new(764, 244),
	Star     = Vector2.new(44, 644),
	Shield   = Vector2.new(524, 844),
	User     = Vector2.new(764, 684),
	Search   = Vector2.new(964, 324),
	Refresh  = Vector2.new(404, 84),
	Action   = Vector2.new(284, 124),
	Close    = Vector2.new(284, 4),
}

local FAST_TWEEN = TweenInfo.new(0.18, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local MED_TWEEN  = TweenInfo.new(0.28, Enum.EasingStyle.Quart, Enum.EasingDirection.Out)
local POP_TWEEN  = TweenInfo.new(0.36, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

local function tween(obj, info, props)
	local ok, t = pcall(function()
		local tw = TweenService:Create(obj, info, props)
		tw:Play()
		return tw
	end)
	return ok and t or nil
end

local themeBindings = { bg = {}, text = {}, stroke = {}, scroll = {}, image = {}, custom = {} }

local function bindTheme(obj, cat)
	if themeBindings[cat] then table.insert(themeBindings[cat], obj) end
	return obj
end

local function setThemeColor(col)
	THEME.ACCENT = col
	for _, o in ipairs(themeBindings.bg) do if o and o.Parent then o.BackgroundColor3 = col end end
	for _, o in ipairs(themeBindings.text) do if o and o.Parent then o.TextColor3 = col end end
	for _, o in ipairs(themeBindings.stroke) do if o and o.Parent then o.Color = col end end
	for _, o in ipairs(themeBindings.scroll) do if o and o.Parent then o.ScrollBarImageColor3 = col end end
	for _, o in ipairs(themeBindings.image) do if o and o.Parent then o.ImageColor3 = col end end
	for _, fn in ipairs(themeBindings.custom) do pcall(fn, col) end
end

local function Corner(parent, r)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, r)
	c.Parent = parent
	return c
end

local function makeSpriteIcon(parent, iconKey, size, pos, col, z)
	local img = Instance.new("ImageLabel", parent)
	img.Size = UDim2.fromOffset(size, size)
	img.Position = pos
	img.BackgroundTransparency = 1
	img.Image = SPRITE_SHEET
	img.ImageRectOffset = ICONS[iconKey] or ICONS.Star
	img.ImageRectSize = Vector2.new(36, 36)
	img.ImageColor3 = col or THEME.ACCENT
	img.ZIndex = z or 12
	return img
end

local function playRipple(btn, col)
	task.spawn(function()
		if not btn or not btn.Parent then return end
		local mPos = UserInputService:GetMouseLocation()
		local relX = mPos.X - btn.AbsolutePosition.X
		local relY = mPos.Y - btn.AbsolutePosition.Y - 36
		if relX < 0 or relX > btn.AbsoluteSize.X or relY < 0 or relY > btn.AbsoluteSize.Y then
			relX = btn.AbsoluteSize.X * 0.5
			relY = btn.AbsoluteSize.Y * 0.5
		end

		local clip = Instance.new("Frame", btn)
		clip.Size = UDim2.fromScale(1, 1)
		clip.BackgroundTransparency = 1
		clip.ClipsDescendants = true
		clip.ZIndex = btn.ZIndex + 1
		Corner(clip, 9)

		local rip = Instance.new("Frame", clip)
		rip.AnchorPoint = Vector2.new(0.5, 0.5)
		rip.Position = UDim2.fromOffset(relX, relY)
		rip.Size = UDim2.fromOffset(0, 0)
		rip.BackgroundColor3 = col or THEME.ACCENT
		rip.BackgroundTransparency = 0.65
		rip.BorderSizePixel = 0
		rip.ZIndex = clip.ZIndex
		Corner(rip, 999)

		local maxD = math.max(btn.AbsoluteSize.X, btn.AbsoluteSize.Y) * 2.2
		tween(rip, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
			Size = UDim2.fromOffset(maxD, maxD),
			BackgroundTransparency = 1
		})
		task.wait(0.46)
		if clip and clip.Parent then clip:Destroy() end
	end)
end

local function formatTime(seconds)
	local hrs = math.floor(seconds / 3600)
	local mins = math.floor((seconds % 3600) / 60)
	local secs = math.floor(seconds % 60)
	if hrs > 0 then return string.format("%02dh %02dm %02ds", hrs, mins, secs) end
	return string.format("%02dm %02ds", mins, secs)
end

-- ============================================================
-- MASTER STATE & CONFIG REGISTRY
-- ============================================================
local state = {
	rainbowTheme = false,
	notifsEnabled = true,
	windowAlpha = 0.12,
	uiScaleMult = 1.00,
	compactMode = false,
	fpsCapOn = false,
	fpsCapVal = 240,
	autoRejoin = false,
	antiKickOn = true,
	friendAlerts = true,
	accentR = 235,
	accentG = 135,
	accentB = 50,

	-- Combat / Upgraded Aimbot & Hitbox
	aimOn = false,
	aimHoldOnly = false,
	aimFollowMouse = false,
	stickyAim = true,
	showFov = false,
	fovFilled = false,
	aimRadius = 150,
	aimSmooth = 0.65,
	aimMode = "Head",
	aimAirshot = true,
	aimWallCheck = true,
	aimTeamCheck = true,
	aimFFCheck = true,
	aimPrediction = true,
	aimResolver = true,
	autoPingPred = true,
	aimPredAmount = 0.138,
	aimSnapline = true,
	triggerBot = false,
	rapidFire = false,
	targetHudOn = true,
	shotHitNotif = true,
	hitmarkers = true,
	spinBot = false,
	spinSpeed = 45,
	antiLockDesync = false,
	targetOrbit = false,
	orbitSpeed = 8,
	orbitRadius = 8,
	hitboxOn = false,
	hitboxSize = 18,
	hitboxTrans = 0.70,
	hitboxPart = "RootPart",

	-- Movement
	flyEnabled = false,
	flySpeed = 90,
	flyVert = 0,
	cfSpeedOn = false,
	cfSpeed = 45,
	speedOn = false,
	walkSpeed = 65,
	autoSprint = false,
	antiSlow = false,
	antiSit = false,
	instantPrompt = false,
	jumpOn = false,
	jumpPower = 115,
	gravityOn = false,
	gravityVal = 75,
	ctrlClickTp = false,
	dashOn = false,
	dashPower = 110,
	phaseBlinkOn = false,
	phaseDist = 18,
	jetpackOn = false,
	jetpackPower = 48,
	autoParkour = false,
	moonwalkOn = false,
	jumpFX = true,
	noFallDmg = false,
	noclip = false,
	infJump = false,
	bhop = false,
	spiderClimb = false,
	spiderSpeed = 42,
	walkFling = false,
	antiFling = false,
	airWalk = false,
	antiVoid = true,

	-- Visuals, Cosmetics (Korblox / Headless), Camera & ESP
	headlessOn = false,
	korbloxOn = false,
	chinaHatOn = false,
	espTeamCheck = true,
	espBoxes = false,
	espCorners = true,
	espChams = false,
	espTracers = false,
	espHealth = false,
	espNames = false,
	selfAura = false,
	worldTintOn = false,
	invisCamOn = false,
	motionBlurOn = false,
	freecamOn = false,
	freecamSpeed = 75,
	customCrosshair = false,
	fovLock = false,
	fovVal = 110,
	camOffsetOn = false,
	camOffsetX = 0,
	camOffsetY = 0,
	stretchOn = false,
	stretchVal = 0.75,
	fullbright = false,
	customTimeOn = false,
	clockTimeVal = 14,
	fpsBoosted = false,
	unlockZoom = false,

	-- Teleporter
	targetPlrName = "",
	loopGoto = false,
	spectating = false,
	savedPos = nil,
}

local defaultState = {}
for k, v in pairs(state) do defaultState[k] = v end

local uiSyncCallbacks = {}

local origLight = {
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient,
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	FogEnd = Lighting.FogEnd,
	GlobalShadows = Lighting.GlobalShadows,
}

local function applyFpsCap(fps)
	pcall(function()
		if type(setfpscap) == "function" then
			setfpscap(fps)
		end
	end)
end

-- ============================================================
-- 1. OVERLAY HUD, TARGET CARD, NOTIFICATIONS & ESP LAYER
-- ============================================================
local overlayGui = Instance.new("ScreenGui")
overlayGui.Name = "LarpsOverlayHUD"
overlayGui.ResetOnSpawn = false
overlayGui.IgnoreGuiInset = true
overlayGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
overlayGui.DisplayOrder = 990
overlayGui.Enabled = false
overlayGui.Parent = guiParent

local espContainer = Instance.new("Frame", overlayGui)
espContainer.Name = "ESPContainer"
espContainer.Size = UDim2.fromScale(1, 1)
espContainer.BackgroundTransparency = 1
espContainer.ZIndex = 5

local targetSnapline = bindTheme(Instance.new("Frame", overlayGui), "bg")
targetSnapline.AnchorPoint = Vector2.new(0.5, 0.5)
targetSnapline.BackgroundColor3 = THEME.ACCENT
targetSnapline.BackgroundTransparency = 0.2
targetSnapline.BorderSizePixel = 0
targetSnapline.Visible = false
targetSnapline.ZIndex = 32

-- Top Watermark Pill
local topBarPill = Instance.new("Frame", overlayGui)
topBarPill.AnchorPoint = Vector2.new(0.5, 0)
topBarPill.Position = UDim2.new(0.5, 0, 0, 8)
topBarPill.Size = UDim2.fromOffset(510, 28)
topBarPill.BackgroundColor3 = THEME.BG
topBarPill.BackgroundTransparency = 0.16
topBarPill.BorderSizePixel = 0
topBarPill.ZIndex = 40
Corner(topBarPill, 999)

bindTheme(makeSpriteIcon(topBarPill, "Toggle", 15, UDim2.new(0, 12, 0.5, -7.5), THEME.ACCENT, 42), "image")

local topHudText = Instance.new("TextLabel", topBarPill)
topHudText.Size = UDim2.new(1, -36, 1, 0)
topHudText.Position = UDim2.fromOffset(32, 0)
topHudText.BackgroundTransparency = 1
topHudText.Font = Enum.Font.GothamBold
topHudText.Text = "KEY: 2027  •  LARPS V8  •  60 FPS  •  40ms  •  0 studs/s"
topHudText.TextColor3 = THEME.TEXT
topHudText.TextSize = 11
topHudText.TextXAlignment = Enum.TextXAlignment.Left
topHudText.ZIndex = 41

-- Borderless Floating Target HUD Card
local targetHudCard = Instance.new("Frame", overlayGui)
targetHudCard.AnchorPoint = Vector2.new(0.5, 0)
targetHudCard.Position = UDim2.new(0.5, 0, 0.58, 0)
targetHudCard.Size = UDim2.fromOffset(225, 58)
targetHudCard.BackgroundColor3 = THEME.BG
targetHudCard.BackgroundTransparency = 0.15
targetHudCard.BorderSizePixel = 0
targetHudCard.Visible = false
targetHudCard.ZIndex = 50
Corner(targetHudCard, 10)

local thudAvatar = Instance.new("ImageLabel", targetHudCard)
thudAvatar.Size = UDim2.fromOffset(40, 40)
thudAvatar.Position = UDim2.fromOffset(9, 9)
thudAvatar.BackgroundColor3 = THEME.INPUT
thudAvatar.BorderSizePixel = 0
thudAvatar.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
thudAvatar.ZIndex = 51
Corner(thudAvatar, 8)

local thudName = Instance.new("TextLabel", targetHudCard)
thudName.Size = UDim2.new(1, -60, 0, 16)
thudName.Position = UDim2.fromOffset(56, 8)
thudName.BackgroundTransparency = 1
thudName.Font = Enum.Font.GothamBlack
thudName.Text = "Target"
thudName.TextColor3 = THEME.TEXT
thudName.TextSize = 12
thudName.TextXAlignment = Enum.TextXAlignment.Left
thudName.ZIndex = 51

local thudSub = Instance.new("TextLabel", targetHudCard)
thudSub.Size = UDim2.new(1, -60, 0, 14)
thudSub.Position = UDim2.fromOffset(56, 23)
thudSub.BackgroundTransparency = 1
thudSub.Font = Enum.Font.GothamMedium
thudSub.Text = "100 HP • 25m"
thudSub.TextColor3 = THEME.SUBTEXT
thudSub.TextSize = 10
thudSub.TextXAlignment = Enum.TextXAlignment.Left
thudSub.ZIndex = 51

local thudBarBg = Instance.new("Frame", targetHudCard)
thudBarBg.Size = UDim2.new(1, -66, 0, 6)
thudBarBg.Position = UDim2.fromOffset(56, 41)
thudBarBg.BackgroundColor3 = THEME.INPUT
thudBarBg.BorderSizePixel = 0
thudBarBg.ZIndex = 51
Corner(thudBarBg, 99)

local thudBarFill = Instance.new("Frame", thudBarBg)
thudBarFill.Size = UDim2.fromScale(1, 1)
thudBarFill.BackgroundColor3 = THEME.GREEN
thudBarFill.BorderSizePixel = 0
thudBarFill.ZIndex = 52
Corner(thudBarFill, 99)

-- Aimbot FOV Circle
local fovCircle = bindTheme(Instance.new("Frame", overlayGui), "bg")
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.fromScale(0.5, 0.5)
fovCircle.Size = UDim2.fromOffset(state.aimRadius * 2, state.aimRadius * 2)
fovCircle.BackgroundColor3 = THEME.ACCENT
fovCircle.BackgroundTransparency = 1
fovCircle.Visible = false
fovCircle.ZIndex = 30
Corner(fovCircle, 999)
local fovStroke = Instance.new("UIStroke", fovCircle)
fovStroke.Color = THEME.ACCENT
fovStroke.Thickness = 1.4
fovStroke.Transparency = 0.2
bindTheme(fovStroke, "stroke")

-- Center Crosshair
local crosshairHolder = Instance.new("Frame", overlayGui)
crosshairHolder.AnchorPoint = Vector2.new(0.5, 0.5)
crosshairHolder.Position = UDim2.fromScale(0.5, 0.5)
crosshairHolder.Size = UDim2.fromOffset(22, 22)
crosshairHolder.BackgroundTransparency = 1
crosshairHolder.Visible = false
crosshairHolder.ZIndex = 35

for _, cfg in ipairs({
	{UDim2.fromOffset(2, 6), UDim2.fromOffset(10, 0)},
	{UDim2.fromOffset(2, 6), UDim2.fromOffset(10, 16)},
	{UDim2.fromOffset(6, 2), UDim2.fromOffset(0, 10)},
	{UDim2.fromOffset(6, 2), UDim2.fromOffset(16, 10)},
}) do
	local bar = bindTheme(Instance.new("Frame", crosshairHolder), "bg")
	bar.Size = cfg[1]; bar.Position = cfg[2]
	bar.BackgroundColor3 = THEME.ACCENT; bar.BorderSizePixel = 0
end

-- Hitmarker
local hitmarkerFrame = Instance.new("Frame", overlayGui)
hitmarkerFrame.AnchorPoint = Vector2.new(0.5, 0.5)
hitmarkerFrame.Position = UDim2.fromScale(0.5, 0.5)
hitmarkerFrame.Size = UDim2.fromOffset(24, 24)
hitmarkerFrame.BackgroundTransparency = 1
hitmarkerFrame.Visible = false
hitmarkerFrame.ZIndex = 80

for _, rot in ipairs({45, -45}) do
	local line = Instance.new("Frame", hitmarkerFrame)
	line.AnchorPoint = Vector2.new(0.5, 0.5)
	line.Position = UDim2.fromScale(0.5, 0.5)
	line.Size = UDim2.fromOffset(16, 2)
	line.Rotation = rot
	line.BackgroundColor3 = THEME.GREEN
	line.BorderSizePixel = 0
	Corner(line, 2)
end

-- Borderless Mobile Fly Vertical Pad
local mobileFlyPad = Instance.new("Frame", overlayGui)
mobileFlyPad.Size = UDim2.fromOffset(50, 108)
mobileFlyPad.Position = UDim2.new(1, -68, 0.45, -54)
mobileFlyPad.BackgroundTransparency = 1
mobileFlyPad.Visible = false
mobileFlyPad.ZIndex = 90

local function makeFlyBtn(txt, posY, dir)
	local b = Instance.new("TextButton", mobileFlyPad)
	b.Size = UDim2.fromOffset(50, 48)
	b.Position = UDim2.fromOffset(0, posY)
	b.BackgroundColor3 = THEME.BG
	b.BackgroundTransparency = 0.15
	b.BorderSizePixel = 0
	b.Text = txt
	b.TextColor3 = THEME.TEXT
	b.Font = Enum.Font.GothamBlack
	b.TextSize = 12
	b.AutoButtonColor = false
	b.ZIndex = 91
	Corner(b, 10)

	b.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
			state.flyVert = dir
			tween(b, FAST_TWEEN, {BackgroundColor3 = THEME.ACCENT, TextColor3 = THEME.BG})
		end
	end)
	b.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseButton1 then
			if state.flyVert == dir then state.flyVert = 0 end
			tween(b, FAST_TWEEN, {BackgroundColor3 = THEME.BG, TextColor3 = THEME.TEXT})
		end
	end)
end
makeFlyBtn("UP", 0, 1)
makeFlyBtn("DN", 56, -1)

-- Borderless Slide-In Notifications
local notifHolder = Instance.new("Frame", overlayGui)
notifHolder.AnchorPoint = Vector2.new(1, 1)
notifHolder.Position = UDim2.new(1, -16, 1, -16)
notifHolder.Size = UDim2.fromOffset(255, 250)
notifHolder.BackgroundTransparency = 1
notifHolder.ZIndex = 200

local notifLayout = Instance.new("UIListLayout", notifHolder)
notifLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
notifLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
notifLayout.Padding = UDim.new(0, 6)
notifLayout.SortOrder = Enum.SortOrder.LayoutOrder

local activeNotifs, notifSeq = 0, 0
local function notify(title, msg)
	if not state.notifsEnabled then return end
	if activeNotifs >= 4 then
		local oldest = notifHolder:FindFirstChildOfClass("Frame")
		if oldest then oldest:Destroy(); activeNotifs = math.max(0, activeNotifs - 1) end
	end
	activeNotifs += 1
	notifSeq += 1

	local wrap = Instance.new("Frame", notifHolder)
	wrap.LayoutOrder = notifSeq
	wrap.Size = UDim2.fromOffset(245, 50)
	wrap.BackgroundTransparency = 1
	wrap.ZIndex = 201

	local card = Instance.new("Frame", wrap)
	card.Size = UDim2.fromScale(1, 1)
	card.Position = UDim2.fromOffset(270, 0)
	card.BackgroundColor3 = THEME.BG
	card.BackgroundTransparency = 0.1
	card.BorderSizePixel = 0
	card.ClipsDescendants = true
	card.ZIndex = 202
	Corner(card, 10)

	makeSpriteIcon(card, "Star", 16, UDim2.new(0, 12, 0.5, -9), THEME.ACCENT, 203)

	local l1 = Instance.new("TextLabel", card)
	l1.Size = UDim2.new(1, -40, 0, 18)
	l1.Position = UDim2.fromOffset(34, 6)
	l1.BackgroundTransparency = 1
	l1.Font = Enum.Font.GothamBold
	l1.Text = tostring(title)
	l1.TextColor3 = THEME.TEXT
	l1.TextSize = 12
	l1.TextXAlignment = Enum.TextXAlignment.Left
	l1.ZIndex = 203

	local l2 = Instance.new("TextLabel", card)
	l2.Size = UDim2.new(1, -40, 0, 16)
	l2.Position = UDim2.fromOffset(34, 24)
	l2.BackgroundTransparency = 1
	l2.Font = Enum.Font.GothamMedium
	l2.Text = tostring(msg)
	l2.TextColor3 = THEME.SUBTEXT
	l2.TextSize = 11
	l2.TextXAlignment = Enum.TextXAlignment.Left
	l2.ZIndex = 203

	local timerBar = Instance.new("Frame", card)
	timerBar.Size = UDim2.new(1, 0, 0, 3)
	timerBar.Position = UDim2.new(0, 0, 1, -3)
	timerBar.BackgroundColor3 = THEME.ACCENT
	timerBar.BorderSizePixel = 0
	timerBar.ZIndex = 204

	tween(card, POP_TWEEN, {Position = UDim2.fromOffset(0, 0)})
	tween(timerBar, TweenInfo.new(2.1, Enum.EasingStyle.Linear), {Size = UDim2.new(0, 0, 0, 3)})

	task.delay(2.1, function()
		if card and card.Parent then
			tween(card, FAST_TWEEN, {Position = UDim2.fromOffset(270, 0), BackgroundTransparency = 1})
			task.wait(0.2)
		end
		if wrap and wrap.Parent then
			wrap:Destroy()
			activeNotifs = math.max(0, activeNotifs - 1)
		end
	end)
end

-- ============================================================
-- ANTI-KICK HOOK ENGINE
-- ============================================================
local antiKickHooked = false
local function setupAntiKick()
	if antiKickHooked then return end
	antiKickHooked = true
	pcall(function()
		if type(hookmetamethod) == "function" and type(getnamecallmethod) == "function" then
			local oldNamecall
			oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
				local method = getnamecallmethod()
				if state.antiKickOn and self == LocalPlayer and (method == "Kick" or method == "kick") then
					task.spawn(function() notify("Anti-Kick Shield", "Blocked a client Kick attempt!") end)
					return nil
				end
				return oldNamecall(self, ...)
			end)
		end
	end)
	pcall(function()
		if type(hookfunction) == "function" and LocalPlayer.Kick then
			local oldKick
			oldKick = hookfunction(LocalPlayer.Kick, function(self, ...)
				if state.antiKickOn and self == LocalPlayer then
					task.spawn(function() notify("Anti-Kick Shield", "Blocked direct LocalPlayer:Kick()!") end)
					return nil
				end
				return oldKick(self, ...)
			end)
		end
	end)
end
setupAntiKick()

-- ============================================================
-- VISUAL KORBLOX, HEADLESS & CHINA HAT ENGINE
-- ============================================================
local chinaHatPart = nil
local savedHeadState = {}

local function applyCosmetics(char)
	if not char then return end
	task.spawn(function()
		local head = char:WaitForChild("Head", 5)
		if head then
			if state.headlessOn then
				savedHeadState.trans = savedHeadState.trans or head.Transparency
				head.Transparency = 1
				for _, ch in ipairs(head:GetChildren()) do
					if ch:IsA("Decal") then
						ch.Transparency = 1
					elseif ch:IsA("SpecialMesh") then
						ch.MeshId = ""
					end
				end
			elseif savedHeadState.trans ~= nil then
				head.Transparency = 0
				for _, ch in ipairs(head:GetChildren()) do
					if ch:IsA("Decal") then ch.Transparency = 0 end
				end
			end
		end

		if state.korbloxOn then
			local rUpper = char:FindFirstChild("RightUpperLeg")
			local rLower = char:FindFirstChild("RightLowerLeg")
			local rFoot  = char:FindFirstChild("RightFoot")
			if rUpper then
				pcall(function()
					rUpper.MeshId = "http://www.roblox.com/asset/?id=902942096"
					rUpper.TextureID = "http://www.roblox.com/asset/?id=902843398"
				end)
				if rLower then rLower.Transparency = 1; rLower.CanCollide = false end
				if rFoot then rFoot.Transparency = 1; rFoot.CanCollide = false end
			else
				-- R6 Rig Support
				local rLeg = char:FindFirstChild("Right Leg")
				if rLeg then
					local cm = char:FindFirstChild("LarpsKorbloxMesh") or Instance.new("CharacterMesh", char)
					cm.Name = "LarpsKorbloxMesh"
					cm.BodyPart = Enum.BodyPart.RightLeg
					cm.MeshId = 101851696
					cm.OverlayTextureId = 101851254
				end
			end
		else
			local cm = char:FindFirstChild("LarpsKorbloxMesh")
			if cm then cm:Destroy() end
			local rLower = char:FindFirstChild("RightLowerLeg")
			local rFoot  = char:FindFirstChild("RightFoot")
			if rLower then rLower.Transparency = 0 end
			if rFoot then rFoot.Transparency = 0 end
		end
	end)
end

-- ============================================================
-- 2. BORDERLESS MAIN WINDOW
-- ============================================================
local settingsGui = Instance.new("ScreenGui")
settingsGui.Name = "LarpsMainUI"
settingsGui.ResetOnSpawn = false
settingsGui.IgnoreGuiInset = true
settingsGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
settingsGui.DisplayOrder = 10000
settingsGui.Enabled = false
settingsGui.Parent = guiParent

local MAIN_W, MAIN_H = 615, 405

local sFrame = Instance.new("Frame", settingsGui)
sFrame.Name = "MainFrame"
sFrame.AnchorPoint = Vector2.new(0.5, 0.5)
sFrame.Size = UDim2.fromOffset(MAIN_W, MAIN_H)
sFrame.Position = UDim2.fromScale(0.5, 0.5)
sFrame.BackgroundColor3 = THEME.BG
sFrame.BackgroundTransparency = state.windowAlpha
sFrame.BorderSizePixel = 0
sFrame.ClipsDescendants = true
sFrame.ZIndex = 2
Corner(sFrame, 14)

local bgGrad = Instance.new("UIGradient", sFrame)
bgGrad.Color = ColorSequence.new({
	ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
	ColorSequenceKeypoint.new(1, Color3.fromRGB(190, 192, 210)),
})
bgGrad.Rotation = 45

local uiScale = Instance.new("UIScale", sFrame)
local baseScale = 1

local function calcBaseScale()
	camera = Workspace.CurrentCamera
	local mult = state.uiScaleMult or 1
	if state.compactMode then
		mult = mult * 0.82
	end
	if not camera then
		baseScale = math.clamp(mult, 0.45, 1.15)
		return baseScale
	end
	local vp = camera.ViewportSize
	local sx = (vp.X - 28) / MAIN_W
	local sy = (vp.Y - 32) / MAIN_H
	local fit = math.clamp(math.min(sx, sy, 1), 0.55, 1)
	baseScale = math.clamp(fit * mult, 0.45, 1.15)
	return baseScale
end
calcBaseScale()
uiScale.Scale = baseScale

if camera then
	camera:GetPropertyChangedSignal("ViewportSize"):Connect(function()
		if settingsGui.Enabled then uiScale.Scale = calcBaseScale() end
	end)
end

local uiAnimating = false
local cascadePageItems

local function openHeroUI()
	if uiAnimating then return end
	uiAnimating = true
	calcBaseScale()
	uiScale.Scale = baseScale * 0.82
	sFrame.BackgroundTransparency = 0.65
	settingsGui.Enabled = true
	tween(uiScale, POP_TWEEN, {Scale = baseScale})
	tween(sFrame, MED_TWEEN, {BackgroundTransparency = state.windowAlpha})
	if cascadePageItems then cascadePageItems() end
	task.delay(0.32, function() uiAnimating = false end)
end

local function closeHeroUI()
	if uiAnimating then return end
	uiAnimating = true
	tween(uiScale, FAST_TWEEN, {Scale = baseScale * 0.85})
	tween(sFrame, FAST_TWEEN, {BackgroundTransparency = 0.75})
	task.delay(0.18, function()
		settingsGui.Enabled = false
		uiAnimating = false
	end)
end

-- Header Bar
local sHeader = Instance.new("Frame", sFrame)
sHeader.Size = UDim2.new(1, -20, 0, 44)
sHeader.Position = UDim2.fromOffset(10, 10)
sHeader.BackgroundColor3 = THEME.SIDE
sHeader.BackgroundTransparency = 0.25
sHeader.BorderSizePixel = 0
sHeader.ZIndex = 10
Corner(sHeader, 10)

local hBadge = bindTheme(Instance.new("Frame", sHeader), "bg")
hBadge.Size = UDim2.fromOffset(28, 28)
hBadge.Position = UDim2.fromOffset(10, 8)
hBadge.BackgroundColor3 = THEME.ACCENT
hBadge.BackgroundTransparency = 0.1
hBadge.BorderSizePixel = 0
hBadge.ZIndex = 11
Corner(hBadge, 8)

makeSpriteIcon(hBadge, "Toggle", 18, UDim2.fromOffset(5, 5), THEME.BG, 12)

local sTitle = Instance.new("TextLabel", sHeader)
sTitle.BackgroundTransparency = 1
sTitle.Position = UDim2.fromOffset(46, 0)
sTitle.Size = UDim2.new(0, 100, 1, 0)
sTitle.Font = Enum.Font.GothamBlack
sTitle.Text = "LARPS V8+"
sTitle.TextColor3 = THEME.TEXT
sTitle.TextSize = 15
sTitle.TextXAlignment = Enum.TextXAlignment.Left
sTitle.ZIndex = 11

local sSub = Instance.new("TextLabel", sHeader)
sSub.BackgroundTransparency = 1
sSub.Position = UDim2.fromOffset(135, 1)
sSub.Size = UDim2.new(0, 240, 1, 0)
sSub.Font = Enum.Font.GothamMedium
sSub.Text = "•  Upgraded Aimbot, Korblox & Anti-Kick"
sSub.TextColor3 = THEME.SUBTEXT
sSub.TextSize = 12
sSub.TextXAlignment = Enum.TextXAlignment.Left
sSub.ZIndex = 11

local sClose = Instance.new("TextButton", sHeader)
sClose.Size = UDim2.fromOffset(28, 28)
sClose.Position = UDim2.new(1, -36, 0.5, -14)
sClose.BackgroundColor3 = THEME.CARD
sClose.BackgroundTransparency = 0.15
sClose.BorderSizePixel = 0
sClose.Text = ""
sClose.AutoButtonColor = false
sClose.ZIndex = 12
Corner(sClose, 8)

local closeIcon = makeSpriteIcon(sClose, "Close", 16, UDim2.fromOffset(6, 6), THEME.SUBTEXT, 13)

sClose.MouseEnter:Connect(function()
	tween(sClose, FAST_TWEEN, {BackgroundColor3 = THEME.RED, BackgroundTransparency = 0})
	tween(closeIcon, FAST_TWEEN, {ImageColor3 = THEME.TEXT, Rotation = 90})
end)
sClose.MouseLeave:Connect(function()
	tween(sClose, FAST_TWEEN, {BackgroundColor3 = THEME.CARD, BackgroundTransparency = 0.15})
	tween(closeIcon, FAST_TWEEN, {ImageColor3 = THEME.SUBTEXT, Rotation = 0})
end)
sClose.MouseButton1Click:Connect(closeHeroUI)

local isSliding = false
local function makeDraggable(handle, targetFrame)
	local dragging, dragInput, dragStart, startPos = false, nil, nil, nil
	handle.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = inp.Position
			startPos = targetFrame.Position
			inp.Changed:Connect(function()
				if inp.UserInputState == Enum.UserInputState.End then dragging = false end
			end)
		end
	end)
	handle.InputChanged:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch then
			dragInput = inp
		end
	end)
	UserInputService.InputChanged:Connect(function(inp)
		if inp == dragInput and dragging and not isSliding then
			local delta = inp.Position - dragStart
			local vp = (camera and camera.ViewportSize) or Vector2.new(1280, 720)
			local newX = (vp.X * startPos.X.Scale) + startPos.X.Offset + delta.X
			local newY = (vp.Y * startPos.Y.Scale) + startPos.Y.Offset + delta.Y
			local padX = (targetFrame.AbsoluteSize.X * 0.5)
			local padY = (targetFrame.AbsoluteSize.Y * 0.5)
			newX = math.clamp(newX, padX, math.max(padX, vp.X - padX))
			newY = math.clamp(newY, padY, math.max(padY, vp.Y - padY))
			targetFrame.Position = UDim2.fromOffset(newX, newY)
		end
	end)
end
makeDraggable(sHeader, sFrame)

-- ============================================================
-- 3. FLOATING COMMANDS PILL
-- ============================================================
local toggleGui = Instance.new("ScreenGui")
toggleGui.Name = "LarpsToggleUI"
toggleGui.ResetOnSpawn = false
toggleGui.IgnoreGuiInset = true
toggleGui.DisplayOrder = 10005
toggleGui.Enabled = false
toggleGui.Parent = guiParent

local cmdPill = Instance.new("TextButton", toggleGui)
cmdPill.Name = "CommandsPill"
cmdPill.AnchorPoint = Vector2.new(0.5, 0)
cmdPill.Size = UDim2.fromOffset(146, 38)
cmdPill.Position = UDim2.new(0.5, 0, 0, 44)
cmdPill.BackgroundColor3 = THEME.BG
cmdPill.BackgroundTransparency = 0.14
cmdPill.BorderSizePixel = 0
cmdPill.Text = ""
cmdPill.AutoButtonColor = false
Corner(cmdPill, 999)

local pillIcon = bindTheme(makeSpriteIcon(cmdPill, "Home", 17, UDim2.new(0, 15, 0.5, -8.5), THEME.ACCENT, 14), "image")

local cmdText = Instance.new("TextLabel", cmdPill)
cmdText.Size = UDim2.new(1, -44, 1, 0)
cmdText.Position = UDim2.fromOffset(39, 0)
cmdText.BackgroundTransparency = 1
cmdText.Font = Enum.Font.GothamBold
cmdText.Text = "Commands"
cmdText.TextColor3 = THEME.TEXT
cmdText.TextSize = 13
cmdText.TextXAlignment = Enum.TextXAlignment.Left

cmdPill.MouseEnter:Connect(function()
	tween(cmdPill, POP_TWEEN, {Size = UDim2.fromOffset(156, 40), BackgroundTransparency = 0.05})
	tween(pillIcon, POP_TWEEN, {Rotation = 15})
end)
cmdPill.MouseLeave:Connect(function()
	tween(cmdPill, FAST_TWEEN, {Size = UDim2.fromOffset(146, 38), BackgroundTransparency = 0.14})
	tween(pillIcon, FAST_TWEEN, {Rotation = 0})
end)

local dragCmd, cmdStart, cmdPos = false, nil, nil
cmdPill.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
		dragCmd = true; cmdStart = inp.Position; cmdPos = cmdPill.Position
		tween(cmdPill, FAST_TWEEN, {Size = UDim2.fromOffset(138, 34)})
	end
end)
cmdPill.InputEnded:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
		dragCmd = false
		tween(cmdPill, POP_TWEEN, {Size = UDim2.fromOffset(146, 38)})
		if cmdStart and (inp.Position - cmdStart).Magnitude < 6 then
			playRipple(cmdPill)
			if settingsGui.Enabled then closeHeroUI() else openHeroUI() end
		end
	end
end)
UserInputService.InputChanged:Connect(function(inp)
	if dragCmd and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
		local d = inp.Position - cmdStart
		cmdPill.Position = UDim2.new(cmdPos.X.Scale, cmdPos.X.Offset + d.X, cmdPos.Y.Scale, cmdPos.Y.Offset + d.Y)
	end
end)

local keyVerified = false
UserInputService.InputBegan:Connect(function(inp, gpe)
	if not gpe and keyVerified and inp.KeyCode == Enum.KeyCode.RightShift then
		if settingsGui.Enabled then closeHeroUI() else openHeroUI() end
	end
end)

-- ============================================================
-- 4. SIDEBAR TABS & STAGGERED CASCADE
-- ============================================================
local sidebar = Instance.new("Frame", sFrame)
sidebar.Size = UDim2.new(0, 154, 1, -72)
sidebar.Position = UDim2.fromOffset(10, 62)
sidebar.BackgroundColor3 = THEME.SIDE
sidebar.BackgroundTransparency = 0.25
sidebar.BorderSizePixel = 0
sidebar.ZIndex = 10
Corner(sidebar, 10)

local activeTabIndicator = bindTheme(Instance.new("Frame", sidebar), "bg")
activeTabIndicator.Size = UDim2.fromOffset(3, 20)
activeTabIndicator.Position = UDim2.fromOffset(4, 15)
activeTabIndicator.BackgroundColor3 = THEME.ACCENT
activeTabIndicator.BorderSizePixel = 0
activeTabIndicator.ZIndex = 15
Corner(activeTabIndicator, 99)

local tabListHolder = Instance.new("Frame", sidebar)
tabListHolder.Size = UDim2.new(1, -12, 1, -16)
tabListHolder.Position = UDim2.fromOffset(6, 8)
tabListHolder.BackgroundTransparency = 1
tabListHolder.ZIndex = 11

local sideLayout = Instance.new("UIListLayout", tabListHolder)
sideLayout.Padding = UDim.new(0, 5)
sideLayout.SortOrder = Enum.SortOrder.LayoutOrder

local pageHolder = Instance.new("Frame", sFrame)
pageHolder.Size = UDim2.new(1, -182, 1, -72)
pageHolder.Position = UDim2.fromOffset(172, 62)
pageHolder.BackgroundTransparency = 1
pageHolder.ClipsDescendants = true
pageHolder.ZIndex = 10

local pages, tabBtns, tabOrderCounter = {}, {}, 0
local currentActivePage = "Home"

cascadePageItems = function(pageName)
	local p = pages[pageName or currentActivePage]
	if not p then return end
	p.Position = UDim2.fromOffset(0, 16)
	tween(p, POP_TWEEN, {Position = UDim2.fromOffset(0, 0)})

	task.spawn(function()
		local items = {}
		for _, ch in ipairs(p:GetChildren()) do
			if ch:IsA("GuiObject") then table.insert(items, ch) end
		end
		table.sort(items, function(a, b) return a.LayoutOrder < b.LayoutOrder end)
		for i, item in ipairs(items) do
			if i <= 10 then
				local origTrans = item:GetAttribute("BaseTrans")
				if not origTrans then
					origTrans = item.BackgroundTransparency
					item:SetAttribute("BaseTrans", origTrans)
				end
				if origTrans < 1 then
					item.BackgroundTransparency = 0.85
					task.delay((i - 1) * 0.022, function()
						if item and item.Parent then
							tween(item, MED_TWEEN, {BackgroundTransparency = origTrans})
						end
					end)
				end
			end
		end
	end)
end

local function makeTab(name, iconKey)
	tabOrderCounter += 1
	local idx = tabOrderCounter

	local b = Instance.new("TextButton", tabListHolder)
	b.LayoutOrder = idx
	b.Size = UDim2.new(1, 0, 0, 34)
	b.BackgroundColor3 = THEME.CARD
	b.BackgroundTransparency = 1
	b.BorderSizePixel = 0
	b.Text = ""
	b.AutoButtonColor = false
	b.ZIndex = 12
	Corner(b, 8)

	local ico = makeSpriteIcon(b, iconKey or name, 18, UDim2.new(0, 12, 0.5, -9), THEME.SUBTEXT, 13)

	local lbl = Instance.new("TextLabel", b)
	lbl.Size = UDim2.new(1, -40, 1, 0)
	lbl.Position = UDim2.fromOffset(38, 0)
	lbl.BackgroundTransparency = 1
	lbl.Font = Enum.Font.GothamBold
	lbl.Text = name
	lbl.TextColor3 = THEME.SUBTEXT
	lbl.TextSize = 12
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 13

	local p = bindTheme(Instance.new("ScrollingFrame", pageHolder), "scroll")
	p.Size = UDim2.fromScale(1, 1)
	p.Position = UDim2.fromOffset(0, 0)
	p.BackgroundTransparency = 1
	p.BorderSizePixel = 0
	p.ScrollBarThickness = 3
	p.ScrollBarImageColor3 = THEME.ACCENT
	p.CanvasSize = UDim2.new(0, 0, 0, 0)
	p.AutomaticCanvasSize = Enum.AutomaticSize.Y
	p.Visible = false
	p.ZIndex = 10

	local lay = Instance.new("UIListLayout", p)
	lay.Padding = UDim.new(0, 6)
	lay.SortOrder = Enum.SortOrder.LayoutOrder
	local pad = Instance.new("UIPadding", p)
	pad.PaddingRight = UDim.new(0, 6)
	pad.PaddingBottom = UDim.new(0, 10)
	pad.PaddingTop = UDim.new(0, 2)

	pages[name] = p
	tabBtns[name] = {b = b, ico = ico, lbl = lbl, idx = idx, active = false}

	b.MouseEnter:Connect(function()
		if not tabBtns[name].active then
			tween(b, FAST_TWEEN, {BackgroundTransparency = 0.55})
			tween(lbl, FAST_TWEEN, {TextColor3 = THEME.TEXT, Position = UDim2.fromOffset(41, 0)})
		end
	end)
	b.MouseLeave:Connect(function()
		if not tabBtns[name].active then
			tween(b, FAST_TWEEN, {BackgroundTransparency = 1})
			tween(lbl, FAST_TWEEN, {TextColor3 = THEME.SUBTEXT, Position = UDim2.fromOffset(38, 0)})
		end
	end)

	b.MouseButton1Click:Connect(function()
		playRipple(b)
		currentActivePage = name
		for k, v in pairs(pages) do
			v.Visible = (k == name)
		end
		cascadePageItems(name)
		for k, v in pairs(tabBtns) do
			local on = (k == name)
			v.active = on
			tween(v.b, FAST_TWEEN, {
				BackgroundTransparency = on and 0.15 or 1,
				BackgroundColor3 = on and THEME.CARD_HV or THEME.CARD
			})
			tween(v.lbl, FAST_TWEEN, {
				TextColor3 = on and THEME.TEXT or THEME.SUBTEXT,
				Position = on and UDim2.fromOffset(40, 0) or UDim2.fromOffset(38, 0)
			})
			tween(v.ico, POP_TWEEN, {
				ImageColor3 = on and THEME.ACCENT or THEME.SUBTEXT,
				Size = on and UDim2.fromOffset(19, 19) or UDim2.fromOffset(18, 18)
			})
		end
		local targetY = 8 + ((idx - 1) * 39) + 7
		tween(activeTabIndicator, POP_TWEEN, {Position = UDim2.fromOffset(4, targetY)})
	end)
	return p
end

table.insert(themeBindings.custom, function(newCol)
	for _, v in pairs(tabBtns) do
		if v.active then v.ico.ImageColor3 = newCol end
	end
end)

-- ============================================================
-- 5. CONFIG SAVER ENGINE
-- ============================================================
local CONFIG_FOLDER = "LarpsV8_Configs"
local AUTO_FILE = CONFIG_FOLDER .. "/autoload.txt"
local selectedSlot = "Slot1"
local autoLoadEnabled = true

local function ensureFolder()
	pcall(function()
		if type(isfolder) == "function" and type(makefolder) == "function" then
			if not isfolder(CONFIG_FOLDER) then makefolder(CONFIG_FOLDER) end
		end
	end)
end

pcall(function()
	ensureFolder()
	if type(isfile) == "function" and isfile(AUTO_FILE) then
		autoLoadEnabled = (readfile(AUTO_FILE) ~= "false")
	elseif type(writefile) == "function" then
		writefile(AUTO_FILE, "true")
	end
end)

local nonSavedKeys = {
	flyVert = true,
	targetPlrName = true,
	loopGoto = true,
	spectating = true,
	savedPos = true,
	fpsBoosted = true,
}

local function serializeConfig()
	local data = {}
	for k, v in pairs(state) do
		if not nonSavedKeys[k] and (type(v) == "boolean" or type(v) == "number" or type(v) == "string") then
			data[k] = v
		end
	end
	data.accentR = math.floor(THEME.ACCENT.R * 255)
	data.accentG = math.floor(THEME.ACCENT.G * 255)
	data.accentB = math.floor(THEME.ACCENT.B * 255)
	return HttpService:JSONEncode(data)
end

local isApplyingConfig = false
local autoSaveQueued = false

local function queueAutoSave()
	if isApplyingConfig or not autoLoadEnabled then return end
	if autoSaveQueued then return end
	autoSaveQueued = true
	task.delay(0.6, function()
		autoSaveQueued = false
		ensureFolder()
		pcall(function()
			if type(writefile) == "function" then
				writefile(CONFIG_FOLDER .. "/" .. selectedSlot .. ".json", serializeConfig())
			end
		end)
	end)
end

local function applyConfigTable(decoded)
	if type(decoded) ~= "table" then return false end
	isApplyingConfig = true
	if decoded.accentR and decoded.accentG and decoded.accentB then
		setThemeColor(Color3.fromRGB(decoded.accentR, decoded.accentG, decoded.accentB))
	end
	for k, v in pairs(decoded) do
		if state[k] ~= nil and not nonSavedKeys[k] then
			state[k] = v
			if uiSyncCallbacks[k] then
				pcall(uiSyncCallbacks[k], v)
			end
		end
	end
	isApplyingConfig = false
	return true
end

local function saveConfigSlot(slotName, silent)
	ensureFolder()
	local json = serializeConfig()
	local savedOnDisk = false
	pcall(function()
		if type(writefile) == "function" then
			writefile(CONFIG_FOLDER .. "/" .. slotName .. ".json", json)
			savedOnDisk = true
		end
	end)
	if not silent then
		if savedOnDisk then
			notify("Config Saved", "Saved settings to " .. slotName)
		else
			if type(setclipboard) == "function" then setclipboard(json) end
			notify("Config Exported", "Copied JSON to clipboard")
		end
	end
end

local function loadConfigSlot(slotName, silent)
	ensureFolder()
	local raw = nil
	pcall(function()
		local path = CONFIG_FOLDER .. "/" .. slotName .. ".json"
		if type(isfile) == "function" and type(readfile) == "function" and isfile(path) then
			raw = readfile(path)
		end
	end)
	if not raw then
		if not silent then notify("Config Empty", "No saved file found for " .. slotName) end
		return false
	end
	local ok, decoded = pcall(function() return HttpService:JSONDecode(raw) end)
	if ok and applyConfigTable(decoded) then
		if not silent then notify("Config Loaded", "Applied settings from " .. slotName) end
		return true
	end
	return false
end

-- ============================================================
-- 6. WIDGET BUILDERS
-- ============================================================
local function addSection(parent, title, order, iconKey)
	local s = Instance.new("Frame", parent)
	s.LayoutOrder = order
	s.Size = UDim2.new(1, 0, 0, 24)
	s.BackgroundTransparency = 1
	s.ZIndex = 11

	local ico = bindTheme(makeSpriteIcon(s, iconKey or "Star", 14, UDim2.new(0, 2, 0.5, -6), THEME.ACCENT, 12), "image")
	ico.ImageTransparency = 0.15

	local l = Instance.new("TextLabel", s)
	l.Size = UDim2.new(1, -24, 1, 0)
	l.Position = UDim2.fromOffset(22, 1)
	l.BackgroundTransparency = 1
	l.Font = Enum.Font.GothamBlack
	l.Text = string.upper(title)
	l.TextColor3 = THEME.SUBTEXT
	l.TextSize = 10
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.ZIndex = 12
	return s
end

local function addToggle(parent, txt, order, def, cb, iconKey, stateKey)
	local c = Instance.new("TextButton", parent)
	c.LayoutOrder = order
	c.Size = UDim2.new(1, 0, 0, 38)
	c.BackgroundColor3 = THEME.CARD
	c.BackgroundTransparency = 0.2
	c.BorderSizePixel = 0
	c.Text = ""
	c.AutoButtonColor = false
	c.ZIndex = 11
	Corner(c, 9)

	local leftBar = Instance.new("Frame", c)
	leftBar.Size = def and UDim2.fromOffset(3, 18) or UDim2.fromOffset(3, 0)
	leftBar.Position = UDim2.new(0, 0, 0.5, 0)
	leftBar.AnchorPoint = Vector2.new(0, 0.5)
	leftBar.BackgroundColor3 = THEME.ACCENT
	leftBar.BorderSizePixel = 0
	leftBar.ZIndex = 13
	Corner(leftBar, 99)

	local rowIcon = makeSpriteIcon(c, iconKey or "Toggle", 16, UDim2.new(0, 12, 0.5, -8), def and THEME.ACCENT or THEME.SUBTEXT, 12)

	local l = Instance.new("TextLabel", c)
	l.Size = UDim2.new(1, -94, 1, 0)
	l.Position = UDim2.fromOffset(36, 0)
	l.BackgroundTransparency = 1
	l.Text = txt
	l.TextColor3 = THEME.TEXT
	l.Font = Enum.Font.GothamSemibold
	l.TextSize = 12
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.ZIndex = 12

	local sw = Instance.new("Frame", c)
	sw.Size = UDim2.fromOffset(40, 20)
	sw.Position = UDim2.new(1, -50, 0.5, -10)
	sw.BackgroundColor3 = def and THEME.ACCENT or THEME.INPUT
	sw.BorderSizePixel = 0
	sw.ZIndex = 12
	Corner(sw, 999)

	local kn = Instance.new("Frame", sw)
	kn.Size = UDim2.fromOffset(14, 14)
	kn.Position = def and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7)
	kn.BackgroundColor3 = def and THEME.BG or THEME.SUBTEXT
	kn.BorderSizePixel = 0
	kn.ZIndex = 13
	Corner(kn, 999)

	local on = def
	local function setVisual(newVal, silent)
		on = newVal
		tween(sw, FAST_TWEEN, {BackgroundColor3 = on and THEME.ACCENT or THEME.INPUT})
		tween(rowIcon, POP_TWEEN, {ImageColor3 = on and THEME.ACCENT or THEME.SUBTEXT})
		tween(leftBar, POP_TWEEN, {Size = on and UDim2.fromOffset(3, 18) or UDim2.fromOffset(3, 0)})
		tween(kn, POP_TWEEN, {
			Position = on and UDim2.new(1, -17, 0.5, -7) or UDim2.new(0, 3, 0.5, -7),
			BackgroundColor3 = on and THEME.BG or THEME.SUBTEXT
		})
		if not silent then
			notify(txt, on and "Enabled" or "Disabled")
		end
		cb(on)
		queueAutoSave()
	end

	if stateKey then
		uiSyncCallbacks[stateKey] = function(val)
			if type(val) == "boolean" and val ~= on then
				setVisual(val, true)
			end
		end
	end

	table.insert(themeBindings.custom, function(newCol)
		leftBar.BackgroundColor3 = newCol
		if on then
			sw.BackgroundColor3 = newCol
			rowIcon.ImageColor3 = newCol
		end
	end)

	c.MouseEnter:Connect(function()
		tween(c, FAST_TWEEN, {BackgroundColor3 = THEME.CARD_HV})
		tween(l, FAST_TWEEN, {Position = UDim2.fromOffset(39, 0)})
	end)
	c.MouseLeave:Connect(function()
		tween(c, FAST_TWEEN, {BackgroundColor3 = THEME.CARD})
		tween(l, FAST_TWEEN, {Position = UDim2.fromOffset(36, 0)})
	end)

	c.MouseButton1Click:Connect(function()
		playRipple(c)
		setVisual(not on, false)
	end)
end

local function addSlider(parent, txt, order, minV, maxV, defV, isFloat, cb, stateKey)
	local c = Instance.new("Frame", parent)
	c.LayoutOrder = order
	c.Size = UDim2.new(1, 0, 0, 50)
	c.BackgroundColor3 = THEME.CARD
	c.BackgroundTransparency = 0.2
	c.BorderSizePixel = 0
	c.ZIndex = 11
	Corner(c, 9)

	bindTheme(makeSpriteIcon(c, "Tune", 15, UDim2.fromOffset(12, 7), THEME.ACCENT, 12), "image")

	local l = Instance.new("TextLabel", c)
	l.Size = UDim2.new(0.65, 0, 0, 20)
	l.Position = UDim2.fromOffset(34, 5)
	l.BackgroundTransparency = 1
	l.Text = txt
	l.TextColor3 = THEME.TEXT
	l.Font = Enum.Font.GothamSemibold
	l.TextSize = 12
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.ZIndex = 12

	local vl = bindTheme(Instance.new("TextBox", c), "text")
	vl.Size = UDim2.fromOffset(56, 18)
	vl.Position = UDim2.new(1, -68, 0, 6)
	vl.BackgroundColor3 = THEME.INPUT
	vl.BorderSizePixel = 0
	vl.Text = tostring(defV)
	vl.TextColor3 = THEME.ACCENT
	vl.Font = Enum.Font.GothamBold
	vl.TextSize = 11
	vl.ClearTextOnFocus = false
	vl.ZIndex = 13
	Corner(vl, 6)

	local hb = Instance.new("TextButton", c)
	hb.Size = UDim2.new(1, -24, 0, 20)
	hb.Position = UDim2.fromOffset(12, 26)
	hb.BackgroundTransparency = 1
	hb.Text = ""
	hb.ZIndex = 13

	local tr = Instance.new("Frame", hb)
	tr.Size = UDim2.new(1, 0, 0, 6)
	tr.Position = UDim2.new(0, 0, 0.5, -3)
	tr.BackgroundColor3 = THEME.INPUT
	tr.BorderSizePixel = 0
	tr.ZIndex = 12
	Corner(tr, 999)

	local initPct = math.clamp((defV - minV) / (maxV - minV), 0, 1)
	local fl = bindTheme(Instance.new("Frame", tr), "bg")
	fl.Size = UDim2.new(initPct, 0, 1, 0)
	fl.BackgroundColor3 = THEME.ACCENT
	fl.BorderSizePixel = 0
	fl.ZIndex = 13
	Corner(fl, 999)

	local thumb = Instance.new("Frame", fl)
	thumb.AnchorPoint = Vector2.new(0.5, 0.5)
	thumb.Position = UDim2.fromScale(1, 0.5)
	thumb.Size = UDim2.fromOffset(12, 12)
	thumb.BackgroundColor3 = THEME.TEXT
	thumb.BorderSizePixel = 0
	thumb.ZIndex = 14
	Corner(thumb, 999)

	local function setSliderVal(num)
		local clamped = math.clamp(num, minV, maxV)
		local pct = math.clamp((clamped - minV) / (maxV - minV), 0, 1)
		tween(fl, FAST_TWEEN, {Size = UDim2.new(pct, 0, 1, 0)})
		local val = isFloat and (math.floor(clamped * 100) / 100) or math.floor(clamped)
		vl.Text = tostring(val)
		cb(val)
		queueAutoSave()
	end

	if stateKey then
		uiSyncCallbacks[stateKey] = function(val)
			if type(val) == "number" then setSliderVal(val) end
		end
	end

	local active = false
	local function upd(pos)
		local w = math.max(tr.AbsoluteSize.X, 1)
		local pct = math.clamp((pos.X - tr.AbsolutePosition.X) / w, 0, 1)
		tween(fl, TweenInfo.new(0.06, Enum.EasingStyle.Quad), {Size = UDim2.new(pct, 0, 1, 0)})
		local raw = minV + (maxV - minV) * pct
		local val = isFloat and (math.floor(raw * 100) / 100) or math.floor(raw)
		vl.Text = tostring(val)
		cb(val)
		queueAutoSave()
	end

	vl.FocusLost:Connect(function()
		local num = tonumber(vl.Text)
		if num then
			setSliderVal(num)
		else
			vl.Text = tostring(defV)
		end
	end)

	hb.InputBegan:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			active = true; isSliding = true
			tween(thumb, POP_TWEEN, {Size = UDim2.fromOffset(16, 16)})
			upd(inp.Position)
		end
	end)
	UserInputService.InputEnded:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.MouseButton1 or inp.UserInputType == Enum.UserInputType.Touch then
			active = false; isSliding = false
			tween(thumb, FAST_TWEEN, {Size = UDim2.fromOffset(12, 12)})
		end
	end)
	UserInputService.InputChanged:Connect(function(inp)
		if active and (inp.UserInputType == Enum.UserInputType.MouseMovement or inp.UserInputType == Enum.UserInputType.Touch) then
			upd(inp.Position)
		end
	end)
end

local function addBtn(parent, txt, order, col, cb, iconKey)
	local b = Instance.new("TextButton", parent)
	b.LayoutOrder = order
	b.Size = UDim2.new(1, 0, 0, 36)
	b.BackgroundColor3 = THEME.CARD
	b.BackgroundTransparency = 0.2
	b.BorderSizePixel = 0
	b.Text = ""
	b.AutoButtonColor = false
	b.ZIndex = 11
	Corner(b, 9)

	local ico = makeSpriteIcon(b, iconKey or "Action", 16, UDim2.new(0, 12, 0.5, -8), col or THEME.ACCENT, 12)
	if not col then bindTheme(ico, "image") end

	local lbl = Instance.new("TextLabel", b)
	lbl.Size = UDim2.new(1, -42, 1, 0)
	lbl.Position = UDim2.fromOffset(36, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = txt
	lbl.TextColor3 = THEME.TEXT
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 12
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 12

	b.MouseEnter:Connect(function()
		tween(b, FAST_TWEEN, {BackgroundColor3 = THEME.CARD_HV})
		tween(lbl, FAST_TWEEN, {Position = UDim2.fromOffset(39, 0)})
	end)
	b.MouseLeave:Connect(function()
		tween(b, FAST_TWEEN, {BackgroundColor3 = THEME.CARD})
		tween(lbl, FAST_TWEEN, {Position = UDim2.fromOffset(36, 0)})
	end)

	b.MouseButton1Click:Connect(function()
		playRipple(b, col)
		cb(lbl)
	end)
	return b, lbl
end

-- ============================================================
-- 7. BUILD TABS & POPULATE FEATURES
-- ============================================================
local homeTab   = makeTab("Home", "Home")
local combatTab = makeTab("Combat", "Combat")
local moveTab   = makeTab("Movement", "Movement")
local tpTab     = makeTab("Teleport", "Teleport")
local espTab    = makeTab("Visuals", "Visuals")
local worldTab  = makeTab("Server", "Server")

pages["Home"].Visible = true
tabBtns["Home"].active = true
tabBtns["Home"].b.BackgroundTransparency = 0.15
tabBtns["Home"].b.BackgroundColor3 = THEME.CARD_HV
tabBtns["Home"].lbl.TextColor3 = THEME.TEXT
tabBtns["Home"].ico.ImageColor3 = THEME.ACCENT

-- [1] HOME & CONFIG MANAGER TAB
local infoCard = Instance.new("Frame", homeTab)
infoCard.LayoutOrder = 1
infoCard.Size = UDim2.new(1, 0, 0, 78)
infoCard.BackgroundColor3 = THEME.CARD
infoCard.BackgroundTransparency = 0.2
infoCard.BorderSizePixel = 0
infoCard.ZIndex = 11
Corner(infoCard, 10)

local gameNameLbl = Instance.new("TextLabel", infoCard)
gameNameLbl.Size = UDim2.new(1, -24, 0, 20)
gameNameLbl.Position = UDim2.fromOffset(14, 8)
gameNameLbl.BackgroundTransparency = 1
gameNameLbl.Font = Enum.Font.GothamBlack
gameNameLbl.Text = "Experience: " .. currentGameName
gameNameLbl.TextColor3 = THEME.TEXT
gameNameLbl.TextSize = 13
gameNameLbl.TextXAlignment = Enum.TextXAlignment.Left
gameNameLbl.ZIndex = 12

local playTimeLbl = bindTheme(Instance.new("TextLabel", infoCard), "text")
playTimeLbl.Size = UDim2.new(1, -24, 0, 18)
playTimeLbl.Position = UDim2.fromOffset(14, 29)
playTimeLbl.BackgroundTransparency = 1
playTimeLbl.Font = Enum.Font.GothamSemibold
playTimeLbl.Text = "Session Time: 00m 00s  •  RightShift / Pill to Toggle"
playTimeLbl.TextColor3 = THEME.ACCENT
playTimeLbl.TextSize = 11
playTimeLbl.TextXAlignment = Enum.TextXAlignment.Left
playTimeLbl.ZIndex = 12

local plrInfoLbl = Instance.new("TextLabel", infoCard)
plrInfoLbl.Size = UDim2.new(1, -24, 0, 18)
plrInfoLbl.Position = UDim2.fromOffset(14, 48)
plrInfoLbl.BackgroundTransparency = 1
plrInfoLbl.Font = Enum.Font.GothamMedium
plrInfoLbl.Text = string.format("Account: @%s  •  Key: %s  •  Anti-Kick Active", LocalPlayer.Name, REQUIRED_KEY)
plrInfoLbl.TextColor3 = THEME.SUBTEXT
plrInfoLbl.TextSize = 11
plrInfoLbl.TextXAlignment = Enum.TextXAlignment.Left
plrInfoLbl.ZIndex = 12

addSection(homeTab, "UI Size & Compact Scaling", 2, "Tune")
addToggle(homeTab, "Compact Mini UI Mode (Smaller Window)", 3, false, function(v)
	state.compactMode = v
	tween(uiScale, FAST_TWEEN, {Scale = calcBaseScale()})
end, "Home", "compactMode")

addSlider(homeTab, "UI Window Size Scale (0.55x - 1.05x)", 4, 0.55, 1.05, 1.00, true, function(v)
	state.uiScaleMult = v
	tween(uiScale, FAST_TWEEN, {Scale = calcBaseScale()})
end, "uiScaleMult")

addSection(homeTab, "Config Manager (Auto-Loads Old Config)", 5, "Shield")

local slotNames = {"Slot1", "Slot2", "Slot3"}
local slotIdx = 1

addBtn(homeTab, "Active Config Slot: SLOT 1 (Click to Switch)", 6, nil, function(lbl)
	slotIdx = (slotIdx % #slotNames) + 1
	selectedSlot = slotNames[slotIdx]
	lbl.Text = "Active Config Slot: " .. string.upper(selectedSlot) .. " (Click to Switch)"
end, "Tune")

local cfgGrid = Instance.new("Frame", homeTab)
cfgGrid.LayoutOrder = 7
cfgGrid.Size = UDim2.new(1, 0, 0, 78)
cfgGrid.BackgroundTransparency = 1
cfgGrid.ZIndex = 11

local cfgGridLay = Instance.new("UIGridLayout", cfgGrid)
cfgGridLay.CellSize = UDim2.new(0.5, -4, 0, 35)
cfgGridLay.CellPadding = UDim2.fromOffset(8, 8)
cfgGridLay.SortOrder = Enum.SortOrder.LayoutOrder

addBtn(cfgGrid, "Save to Active Slot", 1, THEME.GREEN, function()
	saveConfigSlot(selectedSlot, false)
end, "Shield")

addBtn(cfgGrid, "Load Active Slot", 2, nil, function()
	loadConfigSlot(selectedSlot, false)
end, "Refresh")

addBtn(cfgGrid, "Export Config (Copy)", 3, nil, function()
	local json = serializeConfig()
	if type(setclipboard) == "function" then
		setclipboard(json)
		notify("Config Copied", "Copied JSON config to clipboard")
	end
end, "Action")

addBtn(cfgGrid, "Reset All to Defaults", 4, THEME.RED, function()
	applyConfigTable(defaultState)
	setThemeColor(Color3.fromRGB(235, 135, 50))
	saveConfigSlot(selectedSlot, true)
	notify("Defaults Restored", "All settings reset to default")
end, "Close")

addToggle(homeTab, "Auto-Load & Auto-Save Old Config (Slot 1)", 8, autoLoadEnabled, function(v)
	autoLoadEnabled = v
	ensureFolder()
	pcall(function()
		if type(writefile) == "function" then
			writefile(AUTO_FILE, v and "true" or "false")
		end
	end)
	if v then saveConfigSlot("Slot1", true) end
end, "Star")

addSection(homeTab, "FPS Unlocker & Performance", 9, "Movement")
addToggle(homeTab, "Unlock FPS Cap (setfpscap)", 10, false, function(v)
	state.fpsCapOn = v
	applyFpsCap(v and state.fpsCapVal or 60)
end, "Movement", "fpsCapOn")
addSlider(homeTab, "Target FPS Cap (60 - 999 FPS)", 11, 60, 999, 240, false, function(v)
	state.fpsCapVal = v
	if state.fpsCapOn then applyFpsCap(v) end
end, "fpsCapVal")

addSection(homeTab, "Theme & Glass Transparency", 12, "Tune")

local swatchBar = Instance.new("Frame", homeTab)
swatchBar.LayoutOrder = 13
swatchBar.Size = UDim2.new(1, 0, 0, 40)
swatchBar.BackgroundColor3 = THEME.CARD
swatchBar.BackgroundTransparency = 0.2
swatchBar.BorderSizePixel = 0
swatchBar.ZIndex = 11
Corner(swatchBar, 9)

local swatchLayout = Instance.new("UIListLayout", swatchBar)
swatchLayout.FillDirection = Enum.FillDirection.Horizontal
swatchLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
swatchLayout.VerticalAlignment = Enum.VerticalAlignment.Center
swatchLayout.Padding = UDim.new(0, 8)

for _, preset in ipairs({
	{"Amber",   Color3.fromRGB(235, 135, 50)},
	{"Crimson", Color3.fromRGB(255, 65, 90)},
	{"Violet",  Color3.fromRGB(160, 95, 255)},
	{"Emerald", Color3.fromRGB(65, 235, 145)},
	{"Sky",     Color3.fromRGB(65, 195, 255)},
	{"Rose",    Color3.fromRGB(255, 95, 190)},
	{"Snow",    Color3.fromRGB(240, 242, 250)},
}) do
	local sw = Instance.new("TextButton", swatchBar)
	sw.Size = UDim2.fromOffset(44, 22)
	sw.BackgroundColor3 = preset[2]
	sw.BorderSizePixel = 0
	sw.Text = ""
	sw.AutoButtonColor = false
	sw.ZIndex = 12
	Corner(sw, 6)
	sw.MouseButton1Click:Connect(function()
		state.rainbowTheme = false
		setThemeColor(preset[2])
		queueAutoSave()
		notify("Theme Updated", "Accent set to " .. preset[1])
	end)
end

addSlider(homeTab, "UI Glass Transparency", 14, 0.0, 0.45, 0.12, true, function(v)
	state.windowAlpha = v
	sFrame.BackgroundTransparency = v
end, "windowAlpha")

addSlider(homeTab, "Custom Accent Hue", 15, 0, 100, 8, false, function(v)
	state.rainbowTheme = false
	setThemeColor(Color3.fromHSV(v / 100, 0.78, 1))
end)

addToggle(homeTab, "Chroma Rainbow Accent", 16, false, function(v) state.rainbowTheme = v end, "Star", "rainbowTheme")
addToggle(homeTab, "Pop-Up Notifications", 17, true, function(v) state.notifsEnabled = v end, "Toggle", "notifsEnabled")
addToggle(homeTab, "Friend Join / Leave Alerts", 18, true, function(v) state.friendAlerts = v end, "User", "friendAlerts")

addSection(homeTab, "Quick Backpack Tools", 19, "Action")
addBtn(homeTab, "Give Click-Teleport Tool (TapTP)", 20, THEME.GREEN, function()
	local tool = Instance.new("Tool")
	tool.Name = "TapTP"
	tool.RequiresHandle = false
	tool.Activated:Connect(function()
		local mouse = LocalPlayer:GetMouse()
		if LocalPlayer.Character and mouse.Hit then
			LocalPlayer.Character:PivotTo(CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0)))
		end
	end)
	tool.Parent = LocalPlayer:WaitForChild("Backpack")
	notify("Tool Added", "Equipped TapTP to your Backpack")
end, "Teleport")

addBtn(homeTab, "Give Wall Delete Tool (DestroyPart)", 21, nil, function()
	local tool = Instance.new("Tool")
	tool.Name = "DestroyPart"
	tool.RequiresHandle = false
	tool.Activated:Connect(function()
		local target = LocalPlayer:GetMouse().Target
		if target and not target:IsDescendantOf(LocalPlayer.Character) then
			target:Destroy()
		end
	end)
	tool.Parent = LocalPlayer:WaitForChild("Backpack")
	notify("Tool Added", "Equipped DestroyPart to your Backpack")
end, "Action")

-- [2] COMBAT / UPGRADED PRECISION AIMBOT & HITBOX TAB
local function restoreAllHitboxes()
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character then
			local r = p.Character:FindFirstChild("HumanoidRootPart")
			local hd = p.Character:FindFirstChild("Head")
			if r then
				pcall(function()
					r.Size = Vector3.new(2, 2, 1)
					r.Transparency = 1
					r.CanCollide = false
				end)
			end
			if hd then
				pcall(function()
					hd.Size = Vector3.new(2, 1, 1)
					hd.Transparency = 0
				end)
			end
		end
	end
end

addSection(combatTab, "Upgraded Precision Aimbot V2", 1, "Combat")
addToggle(combatTab, "Enable Precision Aimbot", 2, false, function(v)
	state.aimOn = v
	if not v then targetHudCard.Visible = false; targetSnapline.Visible = false end
end, "Combat", "aimOn")
addToggle(combatTab, "Hold Right-Click Only (PC Aim KeyMode)", 3, false, function(v) state.aimHoldOnly = v end, "Tune", "aimHoldOnly")
addToggle(combatTab, "Mouse-Cursor FOV Mode (Follows Mouse Instead of Center)", 4, false, function(v)
	state.aimFollowMouse = v
	if not v then fovCircle.Position = UDim2.fromScale(0.5, 0.5) end
end, "Search", "aimFollowMouse")
addToggle(combatTab, "Sticky Lock (Keep Target Until Dead / Out of FOV)", 5, true, function(v) state.stickyAim = v end, "Shield", "stickyAim")
addToggle(combatTab, "Airshot Auto-Bone (Aim LowerTorso When Target Jumps)", 6, true, function(v) state.aimAirshot = v end, "Movement", "aimAirshot")
addToggle(combatTab, "Show On-Screen Target HUD Card", 7, true, function(v) state.targetHudOn = v end, "User", "targetHudOn")
addToggle(combatTab, "Show Target Prediction Snapline", 8, true, function(v) state.aimSnapline = v end, "Movement", "aimSnapline")
addToggle(combatTab, "Show Dynamic FOV Circle", 9, false, function(v) state.showFov = v; fovCircle.Visible = v end, "Visuals", "showFov")
addToggle(combatTab, "Filled Translucent FOV Glow", 10, false, function(v)
	state.fovFilled = v
	fovCircle.BackgroundTransparency = v and 0.88 or 1
end, "Star", "fovFilled")
addSlider(combatTab, "FOV Radius (px)", 11, 30, 500, 150, false, function(v)
	state.aimRadius = v
	fovCircle.Size = UDim2.fromOffset(v * 2, v * 2)
end, "aimRadius")
addSlider(combatTab, "Lock Responsiveness (1.0 = Instant Lock)", 12, 0.05, 1.00, 0.65, true, function(v) state.aimSmooth = v end, "aimSmooth")

local aimModes = {"Head", "Torso", "Closest"}
local aimModeIdx = 1
addBtn(combatTab, "Aim Target Bone: HEAD (Click to Cycle)", 13, nil, function(lbl)
	aimModeIdx = (aimModeIdx % #aimModes) + 1
	state.aimMode = aimModes[aimModeIdx]
	lbl.Text = "Aim Target Bone: " .. string.upper(state.aimMode) .. " (Click to Cycle)"
	queueAutoSave()
end, "Combat")

addSection(combatTab, "Velocity Prediction & Resolver", 14, "Tune")
addToggle(combatTab, "Velocity Movement Prediction", 15, true, function(v) state.aimPrediction = v end, "Movement", "aimPrediction")
addToggle(combatTab, "Anti-Lock Resolver (Track Real Position Delta)", 16, true, function(v) state.aimResolver = v end, "Shield", "aimResolver")
addToggle(combatTab, "Auto Ping-Based Prediction", 17, true, function(v) state.autoPingPred = v end, "Server", "autoPingPred")
addSlider(combatTab, "Manual Prediction Factor", 18, 0.02, 0.35, 0.138, true, function(v) state.aimPredAmount = v end, "aimPredAmount")
addToggle(combatTab, "Wall Check (Visible Targets Only)", 19, true, function(v) state.aimWallCheck = v end, "Visuals", "aimWallCheck")
addToggle(combatTab, "Team Check (Ignore Teammates)", 20, true, function(v) state.aimTeamCheck = v end, "Shield", "aimTeamCheck")
addToggle(combatTab, "ForceField / Invincible Check", 21, true, function(v) state.aimFFCheck = v end, "Shield", "aimFFCheck")

addSection(combatTab, "Massive Hitbox Expander & Combat Mods", 22, "Action")
addToggle(combatTab, "Enable Massive Hitbox Expander (Massless Bypass)", 23, false, function(v)
	state.hitboxOn = v
	if not v then restoreAllHitboxes() end
end, "User", "hitboxOn")
addSlider(combatTab, "Expanded Hitbox Size (4 - 120 Studs)", 24, 4, 120, 18, false, function(v) state.hitboxSize = v end, "hitboxSize")
addSlider(combatTab, "Hitbox Transparency (0.1 - 1.0)", 25, 0.1, 1.0, 0.70, true, function(v) state.hitboxTrans = v end, "hitboxTrans")

local hbParts = {"RootPart", "Head"}
local hbPartIdx = 1
addBtn(combatTab, "Hitbox Target Part: ROOTPART (Click to Cycle)", 26, nil, function(lbl)
	restoreAllHitboxes()
	hbPartIdx = (hbPartIdx % #hbParts) + 1
	state.hitboxPart = hbParts[hbPartIdx]
	lbl.Text = "Hitbox Target Part: " .. string.upper(state.hitboxPart) .. " (Click to Cycle)"
end, "Tune")

addToggle(combatTab, "TriggerBot (Auto-Fire When Locked)", 27, false, function(v) state.triggerBot = v end, "Combat", "triggerBot")
addToggle(combatTab, "Rapid Fire / Auto-Activate Held Tool", 28, false, function(v) state.rapidFire = v end, "Movement", "rapidFire")
addToggle(combatTab, "Hitmarkers & Damage Notifications", 29, true, function(v)
	state.shotHitNotif = v
	state.hitmarkers = v
end, "Star", "shotHitNotif")
addToggle(combatTab, "Anti-Lock Velocity Desync (Break Enemy Aimbot)", 30, false, function(v) state.antiLockDesync = v end, "Shield", "antiLockDesync")
addToggle(combatTab, "Target Strafe (360° Orbit Around Enemy)", 31, false, function(v) state.targetOrbit = v end, "Refresh", "targetOrbit")
addSlider(combatTab, "Orbit Radius (Studs)", 32, 4, 25, 8, false, function(v) state.orbitRadius = v end, "orbitRadius")
addSlider(combatTab, "Orbit Speed", 33, 2, 25, 8, false, function(v) state.orbitSpeed = v end, "orbitSpeed")
addToggle(combatTab, "Anti-Aim SpinBot", 34, false, function(v) state.spinBot = v end, "Refresh", "spinBot")
addSlider(combatTab, "SpinBot Speed", 35, 15, 180, 45, false, function(v) state.spinSpeed = v end, "spinSpeed")

-- [3] MOVEMENT & SPIDER WALK TAB
local flyBV, flyBG, flyVel = nil, nil, Vector3.zero
local airWalkPart = nil

local function getHum()
	local c = LocalPlayer.Character
	return c and c:FindFirstChildOfClass("Humanoid")
end

local function applyStats()
	local h = getHum()
	if not h then return end
	pcall(function()
		if state.speedOn then
			h.WalkSpeed = state.walkSpeed
		elseif state.autoSprint then
			h.WalkSpeed = 26
		else
			h.WalkSpeed = 16
		end
		h.UseJumpPower = true
		h.JumpPower = state.jumpOn and state.jumpPower or 50
	end)
end

local function toggleFly(on)
	if flyBV then flyBV:Destroy(); flyBV = nil end
	if flyBG then flyBG:Destroy(); flyBG = nil end
	state.flyVert = 0
	mobileFlyPad.Visible = state.flyEnabled
	local h = getHum()
	if h then
		pcall(function()
			h.PlatformStand = false
			h:ChangeState(Enum.HumanoidStateType.GettingUp)
		end)
	end
	if not on then return end

	local root = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not root or not h then return end

	flyBV = Instance.new("BodyVelocity", root)
	flyBV.MaxForce = Vector3.new(1e9, 1e9, 1e9)
	flyBV.Velocity = Vector3.zero

	flyBG = Instance.new("BodyGyro", root)
	flyBG.MaxTorque = Vector3.new(1e9, 1e9, 1e9)
	flyBG.P = 25000
	flyBG.D = 1200
end

local function spawnJumpRing()
	local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not r then return end
	local ring = Instance.new("Part")
	ring.Name = "LarpsJumpRing"
	ring.Shape = Enum.PartType.Cylinder
	ring.Size = Vector3.new(0.15, 2, 2)
	ring.CFrame = CFrame.new(r.Position - Vector3.new(0, 2.8, 0)) * CFrame.Angles(0, 0, math.rad(90))
	ring.Anchored = true
	ring.CanCollide = false
	ring.CastShadow = false
	ring.Material = Enum.Material.Neon
	ring.Color = THEME.ACCENT
	ring.Transparency = 0.25
	ring.Parent = Workspace

	tween(ring, TweenInfo.new(0.45, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
		Size = Vector3.new(0.05, 14, 14),
		Transparency = 1
	})
	task.delay(0.46, function()
		if ring and ring.Parent then ring:Destroy() end
	end)
end

LocalPlayer.CharacterAdded:Connect(function(c)
	c:WaitForChild("Humanoid", 10)
	task.wait(0.2)
	applyStats()
	if state.flyEnabled then toggleFly(true) end
	if state.headlessOn or state.korbloxOn then
		applyCosmetics(c)
	end
end)

addSection(moveTab, "Flight, Speed & Dash", 1, "Movement")
addToggle(moveTab, "Smooth 3D Camera Fly (WASD / Joystick + Space/Shift)", 2, false, function(v) state.flyEnabled = v; toggleFly(v) end, "Movement", "flyEnabled")
addSlider(moveTab, "3D Fly Speed", 3, 20, 600, 90, false, function(v) state.flySpeed = v end, "flySpeed")
addToggle(moveTab, "CFrame Speed Boost (Bypass WalkSpeed Checks)", 4, false, function(v) state.cfSpeedOn = v end, "Movement", "cfSpeedOn")
addSlider(moveTab, "CFrame Speed Multiplier", 5, 10, 400, 45, false, function(v) state.cfSpeed = v end, "cfSpeed")
addToggle(moveTab, "Custom WalkSpeed", 6, false, function(v) state.speedOn = v; applyStats() end, "Movement", "speedOn")
addSlider(moveTab, "WalkSpeed Value", 7, 16, 500, 65, false, function(v) state.walkSpeed = v; if state.speedOn then applyStats() end end, "walkSpeed")
addToggle(moveTab, "Auto-Sprint (26 WalkSpeed Default)", 8, false, function(v) state.autoSprint = v; applyStats() end, "Movement", "autoSprint")
addToggle(moveTab, "Anti-Slowdown / Anti-Stun", 9, false, function(v) state.antiSlow = v end, "Shield", "antiSlow")
addToggle(moveTab, "Anti-Sit (Never Get Stuck in Chairs/Seats)", 10, false, function(v)
	state.antiSit = v
	local h = getHum()
	if h then pcall(function() h:SetStateEnabled(Enum.HumanoidStateType.Seated, not v) end) end
end, "Shield", "antiSit")
addToggle(moveTab, "Instant Interact (Zero ProximityPrompt Hold)", 11, false, function(v) state.instantPrompt = v end, "Action", "instantPrompt")
addToggle(moveTab, "Forward Dash Boost (Press Q Key)", 12, false, function(v) state.dashOn = v end, "Star", "dashOn")
addSlider(moveTab, "Dash Impulse Power", 13, 50, 300, 110, false, function(v) state.dashPower = v end, "dashPower")
addToggle(moveTab, "Phase Blink Forward (Press E Key)", 14, false, function(v) state.phaseBlinkOn = v end, "Teleport", "phaseBlinkOn")
addSlider(moveTab, "Phase Blink Distance (Studs)", 15, 6, 65, 18, false, function(v) state.phaseDist = v end, "phaseDist")
addToggle(moveTab, "Ctrl + Click Instant Teleport", 16, false, function(v) state.ctrlClickTp = v end, "Teleport", "ctrlClickTp")

addSection(moveTab, "Spider Walk, Parkour & Physics", 17, "Tune")
addToggle(moveTab, "Spider Walk / Wall-Climb (Crash-Proof Ledge Latch)", 18, false, function(v) state.spiderClimb = v end, "Movement", "spiderClimb")
addSlider(moveTab, "Spider Climb Speed", 19, 20, 120, 42, false, function(v) state.spiderSpeed = v end, "spiderSpeed")
addToggle(moveTab, "Auto-Parkour Ledge Vault", 20, false, function(v) state.autoParkour = v end, "Movement", "autoParkour")
addToggle(moveTab, "Jetpack Hover Thruster (Hold Space in Air)", 21, false, function(v) state.jetpackOn = v end, "Star", "jetpackOn")
addSlider(moveTab, "Jetpack Thrust Power", 22, 20, 140, 48, false, function(v) state.jetpackPower = v end, "jetpackPower")
addToggle(moveTab, "Moonwalk Reverse Strafe", 23, false, function(v) state.moonwalkOn = v end, "Refresh", "moonwalkOn")
addToggle(moveTab, "Custom JumpPower", 24, false, function(v) state.jumpOn = v; applyStats() end, "Movement", "jumpOn")
addSlider(moveTab, "JumpPower Value", 25, 50, 500, 115, false, function(v) state.jumpPower = v; if state.jumpOn then applyStats() end end, "jumpPower")
addToggle(moveTab, "Neon Jump Shockwave Rings", 26, true, function(v) state.jumpFX = v end, "Star", "jumpFX")
addToggle(moveTab, "Noclip (Walk Through Walls)", 27, false, function(v) state.noclip = v end, "Shield", "noclip")
addToggle(moveTab, "Infinite Air Jump", 28, false, function(v) state.infJump = v end, "Star", "infJump")
addToggle(moveTab, "Auto BunnyHop", 29, false, function(v) state.bhop = v end, "Refresh", "bhop")
addToggle(moveTab, "AirWalk (Neon Platform Under Feet)", 30, false, function(v)
	state.airWalk = v
	if not v and airWalkPart then airWalkPart:Destroy(); airWalkPart = nil end
end, "Star", "airWalk")
addToggle(moveTab, "Anti-Fall Damage (Cap Downward Velocity)", 31, false, function(v) state.noFallDmg = v end, "Shield", "noFallDmg")
addToggle(moveTab, "Low Gravity", 32, false, function(v)
	state.gravityOn = v
	Workspace.Gravity = v and state.gravityVal or 196.2
end, "Tune", "gravityOn")
addSlider(moveTab, "Custom Gravity", 33, 15, 196, 75, false, function(v)
	state.gravityVal = v
	if state.gravityOn then Workspace.Gravity = v end
end, "gravityVal")
addToggle(moveTab, "WalkFling (Touch Fling Players)", 34, false, function(v) state.walkFling = v end, "Combat", "walkFling")
addToggle(moveTab, "Anti-Fling (Disable Player Collisions)", 35, false, function(v) state.antiFling = v end, "Shield", "antiFling")
addToggle(moveTab, "Anti-Void Protection", 36, true, function(v) state.antiVoid = v end, "Shield", "antiVoid")

ProximityPromptService.PromptButtonHoldBegan:Connect(function(prompt)
	if state.instantPrompt then
		pcall(function()
			if type(fireproximityprompt) == "function" then
				fireproximityprompt(prompt)
			else
				prompt.HoldDuration = 0
			end
		end)
	end
end)

UserInputService.InputBegan:Connect(function(inp, gpe)
	if gpe or not keyVerified then return end
	if state.dashOn and inp.KeyCode == Enum.KeyCode.Q then
		local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		if r and camera then
			r.AssemblyLinearVelocity = camera.CFrame.LookVector * state.dashPower + Vector3.new(0, 22, 0)
			if state.jumpFX then spawnJumpRing() end
		end
	elseif state.phaseBlinkOn and inp.KeyCode == Enum.KeyCode.E then
		local c = LocalPlayer.Character
		local r = c and c:FindFirstChild("HumanoidRootPart")
		if c and r and camera then
			local look = Vector3.new(camera.CFrame.LookVector.X, 0, camera.CFrame.LookVector.Z)
			if look.Magnitude > 0.05 then
				c:PivotTo(r.CFrame + (look.Unit * state.phaseDist))
				if state.jumpFX then spawnJumpRing() end
			end
		end
	elseif state.ctrlClickTp and inp.UserInputType == Enum.UserInputType.MouseButton1 then
		if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) or UserInputService:IsKeyDown(Enum.KeyCode.RightControl) then
			local mouse = LocalPlayer:GetMouse()
			if LocalPlayer.Character and mouse.Hit then
				LocalPlayer.Character:PivotTo(CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0)))
			end
		end
	end
end)

-- ============================================================
-- [4] TELEPORT & TARGET MANAGER TAB
-- ============================================================
local targetCard = Instance.new("Frame", tpTab)
targetCard.LayoutOrder = 1
targetCard.Size = UDim2.new(1, 0, 0, 64)
targetCard.BackgroundColor3 = THEME.CARD
targetCard.BackgroundTransparency = 0.16
targetCard.BorderSizePixel = 0
targetCard.ZIndex = 11
Corner(targetCard, 10)

local targetAvatar = Instance.new("ImageLabel", targetCard)
targetAvatar.Size = UDim2.fromOffset(46, 46)
targetAvatar.Position = UDim2.fromOffset(10, 9)
targetAvatar.BackgroundColor3 = THEME.INPUT
targetAvatar.BorderSizePixel = 0
targetAvatar.Image = "rbxasset://textures/ui/GuiImagePlaceholder.png"
targetAvatar.ZIndex = 12
Corner(targetAvatar, 10)

local targetNameLbl = Instance.new("TextLabel", targetCard)
targetNameLbl.Size = UDim2.new(1, -72, 0, 20)
targetNameLbl.Position = UDim2.fromOffset(66, 11)
targetNameLbl.BackgroundTransparency = 1
targetNameLbl.Font = Enum.Font.GothamBlack
targetNameLbl.Text = "No Player Selected"
targetNameLbl.TextColor3 = THEME.TEXT
targetNameLbl.TextSize = 13
targetNameLbl.TextXAlignment = Enum.TextXAlignment.Left
targetNameLbl.ZIndex = 12

local targetStatsLbl = Instance.new("TextLabel", targetCard)
targetStatsLbl.Size = UDim2.new(1, -72, 0, 18)
targetStatsLbl.Position = UDim2.fromOffset(66, 32)
targetStatsLbl.BackgroundTransparency = 1
targetStatsLbl.Font = Enum.Font.GothamMedium
targetStatsLbl.Text = "Click any player below to lock onto them"
targetStatsLbl.TextColor3 = THEME.SUBTEXT
targetStatsLbl.TextSize = 11
targetStatsLbl.TextXAlignment = Enum.TextXAlignment.Left
targetStatsLbl.ZIndex = 12

local function selectTargetPlayer(p)
	if not p then return end
	state.targetPlrName = p.Name
	targetNameLbl.Text = string.format("%s (@%s)", p.DisplayName, p.Name)
	targetStatsLbl.Text = "Selected  •  Ready to Teleport / Spectate / Fling"
	task.spawn(function()
		local ok, img = pcall(function()
			return Players:GetUserThumbnailAsync(p.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
		end)
		if ok and img then targetAvatar.Image = img end
	end)
	notify("Target Locked", p.DisplayName)
end

local actionGrid = Instance.new("Frame", tpTab)
actionGrid.LayoutOrder = 2
actionGrid.Size = UDim2.new(1, 0, 0, 78)
actionGrid.BackgroundTransparency = 1
actionGrid.ZIndex = 11

local gridLay = Instance.new("UIGridLayout", actionGrid)
gridLay.CellSize = UDim2.new(0.5, -4, 0, 35)
gridLay.CellPadding = UDim2.fromOffset(8, 8)
gridLay.SortOrder = Enum.SortOrder.LayoutOrder

local function getSelectedPlayer()
	local p = Players:FindFirstChild(state.targetPlrName)
	if not p then notify("No Target", "Select a player from the list below first!") end
	return p
end

addBtn(actionGrid, "Instant TP to Player", 1, THEME.GREEN, function()
	local t = getSelectedPlayer()
	local tr = t and t.Character and t.Character:FindFirstChild("HumanoidRootPart")
	if tr and LocalPlayer.Character then
		LocalPlayer.Character:PivotTo(tr.CFrame * CFrame.new(0, 0, 3))
		notify("Teleported", "Warped behind " .. t.DisplayName)
	end
end, "Teleport")

addBtn(actionGrid, "Smooth Glide TP", 2, nil, function()
	local t = getSelectedPlayer()
	local tr = t and t.Character and t.Character:FindFirstChild("HumanoidRootPart")
	local mr = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if tr and mr then
		local dist = (tr.Position - mr.Position).Magnitude
		local duration = math.clamp(dist / 160, 0.25, 2.5)
		notify("Glide TP", string.format("Gliding to %s (%.1fs)", t.DisplayName, duration))
		tween(mr, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = tr.CFrame * CFrame.new(0, 0, 3)})
	end
end, "Movement")

addBtn(actionGrid, "Fling Selected Player", 3, THEME.RED, function()
	local t = getSelectedPlayer()
	local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not (t and t.Character and t.Character:FindFirstChild("HumanoidRootPart") and myRoot) then return end
	notify("Target Fling", "Launching " .. t.DisplayName)
	local oldCF = myRoot.CFrame
	local oldFling = state.walkFling
	state.walkFling = true
	task.spawn(function()
		local t0 = os.clock()
		while os.clock() - t0 < 1.8 do
			local tr = t.Character and t.Character:FindFirstChild("HumanoidRootPart")
			if not tr or not myRoot.Parent then break end
			myRoot.CFrame = tr.CFrame * CFrame.new(math.random(-2, 2), 0, math.random(-2, 2))
			RunService.Heartbeat:Wait()
		end
		state.walkFling = oldFling
		if myRoot and myRoot.Parent then
			myRoot.AssemblyLinearVelocity = Vector3.zero
			myRoot.CFrame = oldCF
		end
	end)
end, "Combat")

addBtn(actionGrid, "TP to Closest Player", 4, nil, function()
	local myRoot = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not myRoot then return end
	local bestP, minD = nil, math.huge
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("HumanoidRootPart") then
			local d = (p.Character.HumanoidRootPart.Position - myRoot.Position).Magnitude
			if d < minD then minD = d; bestP = p end
		end
	end
	if bestP then
		selectTargetPlayer(bestP)
		LocalPlayer.Character:PivotTo(bestP.Character.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3))
	end
end, "User")

addBtn(tpTab, "Save / Teleport Waypoint Position", 3, nil, function(lbl)
	local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if not state.savedPos and r then
		state.savedPos = r.CFrame
		lbl.Text = "Teleport to Saved Waypoint (Active)"
		notify("Waypoint Saved", "Click again anytime to return here")
	elseif state.savedPos and LocalPlayer.Character then
		LocalPlayer.Character:PivotTo(state.savedPos)
		state.savedPos = nil
		lbl.Text = "Save / Teleport Waypoint Position"
		notify("Waypoint TP", "Teleported & cleared saved waypoint")
	end
end, "Star")

addToggle(tpTab, "Stick Behind Target (Loop Goto)", 4, false, function(v) state.loopGoto = v end, "Refresh")
addToggle(tpTab, "Spectate Target Camera", 5, false, function(v)
	state.spectating = v
	if not v and LocalPlayer.Character and camera then
		camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	end
end, "Visuals")

addSection(tpTab, "Live Server Players (Click to Select)", 6, "User")

local searchWrap = Instance.new("Frame", tpTab)
searchWrap.LayoutOrder = 7
searchWrap.Size = UDim2.new(1, 0, 0, 36)
searchWrap.BackgroundColor3 = THEME.INPUT
searchWrap.BorderSizePixel = 0
searchWrap.ZIndex = 11
Corner(searchWrap, 9)

bindTheme(makeSpriteIcon(searchWrap, "Search", 16, UDim2.new(0, 12, 0.5, -8), THEME.ACCENT, 12), "image")

local searchBox = Instance.new("TextBox", searchWrap)
searchBox.Size = UDim2.new(1, -40, 1, 0)
searchBox.Position = UDim2.fromOffset(36, 0)
searchBox.BackgroundTransparency = 1
searchBox.PlaceholderText = "Search player name or @username..."
searchBox.PlaceholderColor3 = THEME.SUBTEXT
searchBox.Text = ""
searchBox.TextColor3 = THEME.TEXT
searchBox.Font = Enum.Font.GothamMedium
searchBox.TextSize = 12
searchBox.TextXAlignment = Enum.TextXAlignment.Left
searchBox.ClearTextOnFocus = false
searchBox.ZIndex = 12

local plrListFrame = Instance.new("Frame", tpTab)
plrListFrame.LayoutOrder = 8
plrListFrame.Size = UDim2.new(1, 0, 0, 0)
plrListFrame.AutomaticSize = Enum.AutomaticSize.Y
plrListFrame.BackgroundTransparency = 1
local plrListLayout = Instance.new("UIListLayout", plrListFrame)
plrListLayout.Padding = UDim.new(0, 5)

local function rebuildPlayers()
	for _, ch in ipairs(plrListFrame:GetChildren()) do
		if ch:IsA("TextButton") then ch:Destroy() end
	end
	local filter = string.lower(searchBox.Text or "")
	for _, p in ipairs(Players:GetPlayers()) do
		if p ~= LocalPlayer then
			local match = (filter == "")
				or string.find(string.lower(p.Name), filter, 1, true)
				or string.find(string.lower(p.DisplayName), filter, 1, true)
			if match then
				addBtn(
					plrListFrame,
					string.format("%s  (@%s)", p.DisplayName, p.Name),
					1,
					(state.targetPlrName == p.Name) and THEME.GREEN or nil,
					function()
						selectTargetPlayer(p)
						rebuildPlayers()
					end,
					"User"
				)
			end
		end
	end
end
searchBox:GetPropertyChangedSignal("Text"):Connect(rebuildPlayers)
Players.PlayerAdded:Connect(function(p)
	rebuildPlayers()
	if state.friendAlerts and keyVerified then
		task.spawn(function()
			local ok, isFr = pcall(function() return LocalPlayer:IsFriendsWith(p.UserId) end)
			if ok and isFr then notify("Friend Joined", p.DisplayName .. " joined the server!") end
		end)
	end
end)
Players.PlayerRemoving:Connect(rebuildPlayers)
rebuildPlayers()

-- [5] VISUALS, KORBLOX, HEADLESS, FREECAM & ESP TAB
local selfHighlight = nil
local blurEffect = nil
local freecamCF = CFrame.new()
local freecamAngles = Vector2.zero

local function toggleFreecam(on)
	local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
	if on and camera then
		freecamCF = camera.CFrame
		local rx, ry, _ = freecamCF:ToEulerAnglesYXZ()
		freecamAngles = Vector2.new(rx, ry)
		if r then r.Anchored = true end
	else
		if r and not state.flyEnabled then r.Anchored = false end
		if camera and LocalPlayer.Character then
			camera.CameraType = Enum.CameraType.Custom
			camera.CameraSubject = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
		end
	end
end

addSection(espTab, "Avatar Cosmetics (Korblox, Headless & Hat)", 1, "Star")
addToggle(espTab, "Visual Headless Horseman (Auto-Respawn Safe)", 2, false, function(v)
	state.headlessOn = v
	applyCosmetics(LocalPlayer.Character)
end, "User", "headlessOn")

addToggle(espTab, "Visual Korblox Right Leg (R15 & R6 Supported)", 3, false, function(v)
	state.korbloxOn = v
	applyCosmetics(LocalPlayer.Character)
end, "Star", "korbloxOn")

addToggle(espTab, "3D Neon China Hat (Theme-Synced Cone)", 4, false, function(v)
	state.chinaHatOn = v
	if not v and chinaHatPart then
		chinaHatPart:Destroy()
		chinaHatPart = nil
	end
end, "Star", "chinaHatOn")

addSection(espTab, "Player ESP Overlay", 5, "Visuals")
addToggle(espTab, "ESP Team Check (Hide Teammates)", 6, true, function(v) state.espTeamCheck = v end, "Shield", "espTeamCheck")
addToggle(espTab, "2D Box ESP", 7, false, function(v) state.espBoxes = v end, "Visuals", "espBoxes")
addToggle(espTab, "Corner-Bracket Box Style", 8, true, function(v) state.espCorners = v end, "Star", "espCorners")
addToggle(espTab, "Dynamic Health Bar", 9, false, function(v) state.espHealth = v end, "Toggle", "espHealth")
addToggle(espTab, "Chams (Through-Wall Glow Highlight)", 10, false, function(v) state.espChams = v end, "User", "espChams")
addToggle(espTab, "Snapline Tracers", 11, false, function(v) state.espTracers = v end, "Movement", "espTracers")
addToggle(espTab, "Name, HP & Distance Tags", 12, false, function(v) state.espNames = v end, "User", "espNames")

addSection(espTab, "Freecam, Camera & World FX", 13, "Tune")
addToggle(espTab, "Cinematic 3D Freecam (Scout Through Walls)", 14, false, function(v)
	state.freecamOn = v
	toggleFreecam(v)
end, "Visuals", "freecamOn")
addSlider(espTab, "Freecam Fly Speed", 15, 20, 350, 75, false, function(v) state.freecamSpeed = v end, "freecamSpeed")
addToggle(espTab, "Wall-Vision Camera (No Wall Camera Pop)", 16, false, function(v)
	state.invisCamOn = v
	pcall(function()
		LocalPlayer.DevCameraOcclusionMode = v and Enum.DevCameraOcclusionMode.Invisicam or Enum.DevCameraOcclusionMode.Zoom
	end)
end, "Visuals", "invisCamOn")
addToggle(espTab, "Dynamic Camera Motion Blur", 17, false, function(v)
	state.motionBlurOn = v
	if not v and blurEffect then blurEffect.Size = 0 end
end, "Star", "motionBlurOn")
addToggle(espTab, "Self Neon Aura Highlight", 18, false, function(v)
	state.selfAura = v
	if not v and selfHighlight then selfHighlight:Destroy(); selfHighlight = nil end
end, "Star", "selfAura")
addToggle(espTab, "Theme World Ambient Tint", 19, false, function(v)
	state.worldTintOn = v
	if not v and not state.fullbright then
		Lighting.Ambient = origLight.Ambient
		Lighting.OutdoorAmbient = origLight.OutdoorAmbient
	end
end, "Tune", "worldTintOn")
addToggle(espTab, "Center Tactical Crosshair", 20, false, function(v)
	state.customCrosshair = v
	crosshairHolder.Visible = v
end, "Combat", "customCrosshair")
addToggle(espTab, "Custom Camera FOV", 21, false, function(v) state.fovLock = v; if not v and camera then camera.FieldOfView = 70 end end, "Visuals", "fovLock")
addSlider(espTab, "Camera FOV Value", 22, 60, 120, 110, false, function(v) state.fovVal = v end, "fovVal")
addToggle(espTab, "3rd-Person Camera Offset", 23, false, function(v)
	state.camOffsetOn = v
	local h = getHum()
	if not v and h then h.CameraOffset = Vector3.zero end
end, "Visuals", "camOffsetOn")
addSlider(espTab, "Camera Offset X (Right/Left)", 24, -10, 10, 0, true, function(v) state.camOffsetX = v end, "camOffsetX")
addSlider(espTab, "Camera Offset Y (Height)", 25, -6, 10, 0, true, function(v) state.camOffsetY = v end, "camOffsetY")
addToggle(espTab, "Unlock Max Camera Zoom", 26, false, function(v)
	state.unlockZoom = v
	LocalPlayer.CameraMaxZoomDistance = v and 1000 or 128
end, "Search", "unlockZoom")
addToggle(espTab, "Stretched Resolution", 27, false, function(v) state.stretchOn = v end, "Tune", "stretchOn")
addSlider(espTab, "Stretch Aspect Ratio", 28, 0.50, 1.00, 0.75, true, function(v) state.stretchVal = v end, "stretchVal")
addToggle(espTab, "Fullbright (Remove Darkness & Fog)", 29, false, function(v)
	state.fullbright = v
	if v then
		Lighting.Ambient = Color3.new(1, 1, 1); Lighting.OutdoorAmbient = Color3.new(1, 1, 1)
		Lighting.Brightness = 2; Lighting.ClockTime = 14; Lighting.FogEnd = 100000; Lighting.GlobalShadows = false
	else
		for k, val in pairs(origLight) do Lighting[k] = val end
	end
end, "Star", "fullbright")
addToggle(espTab, "Lock Custom Time of Day", 30, false, function(v) state.customTimeOn = v end, "Refresh", "customTimeOn")
addSlider(espTab, "Time of Day (0h - 24h)", 31, 0, 24, 14, true, function(v)
	state.clockTimeVal = v
	if state.customTimeOn then Lighting.ClockTime = v end
end, "clockTimeVal")
addBtn(espTab, "Activate FPS Booster (Smooth Plastic)", 32, THEME.GREEN, function()
	if state.fpsBoosted then return end
	state.fpsBoosted = true; Lighting.GlobalShadows = false
	for _, v in ipairs(Workspace:GetDescendants()) do
		pcall(function()
			if v:IsA("BasePart") then v.Material = Enum.Material.SmoothPlastic; v.CastShadow = false
			elseif v:IsA("Decal") or v:IsA("Texture") then v.Transparency = 1
			elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then v.Enabled = false end
		end)
	end
	notify("FPS Booster", "Map materials optimized")
end, "Movement")

-- [6] SERVER, ANTI-KICK & IMPORT CONFIG TAB
addSection(worldTab, "Anti-Kick & Server Protection", 1, "Shield")
addToggle(worldTab, "Client Anti-Kick Shield (Hook Kick & Namecall)", 2, true, function(v)
	state.antiKickOn = v
	if v then setupAntiKick() end
end, "Shield", "antiKickOn")
addToggle(worldTab, "Auto-Rejoin on Kick / Disconnect", 3, false, function(v) state.autoRejoin = v end, "Shield", "autoRejoin")

addSection(worldTab, "Server & Character Utilities", 4, "Server")
local jobBox = Instance.new("TextBox", worldTab)
jobBox.LayoutOrder = 5
jobBox.Size = UDim2.new(1, 0, 0, 36)
jobBox.BackgroundColor3 = THEME.INPUT
jobBox.BorderSizePixel = 0
jobBox.PlaceholderText = "Paste Server JobId, PlaceId, or Config JSON..."
jobBox.PlaceholderColor3 = THEME.SUBTEXT
jobBox.Text = ""
jobBox.TextColor3 = THEME.TEXT
jobBox.Font = Enum.Font.GothamSemibold
jobBox.TextSize = 12
jobBox.ZIndex = 11
Corner(jobBox, 9)

addBtn(worldTab, "Join by JobId / PlaceId", 6, nil, function()
	local id = string.gsub(jobBox.Text, "%s+", "")
	if tonumber(id) then TeleportService:Teleport(tonumber(id), LocalPlayer)
	elseif id ~= "" then TeleportService:TeleportToPlaceInstance(game.PlaceId, id, LocalPlayer) end
end, "Teleport")
addBtn(worldTab, "Import Config JSON from Box Above", 7, THEME.GREEN, function()
	local ok, decoded = pcall(function() return HttpService:JSONDecode(jobBox.Text) end)
	if ok and applyConfigTable(decoded) then
		saveConfigSlot(selectedSlot, true)
		notify("Config Imported", "Loaded & saved custom JSON config!")
	else
		notify("Invalid JSON", "Paste a valid Larps V8 config string first")
	end
end, "Shield")
addBtn(worldTab, "Rejoin Current Server", 8, nil, function()
	TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
end, "Refresh")
addBtn(worldTab, "Server Hop (Join New Server)", 9, THEME.GREEN, function()
	TeleportService:Teleport(game.PlaceId, LocalPlayer)
end, "Server")
addBtn(worldTab, "Copy Current Server JobId", 10, nil, function()
	if type(setclipboard) == "function" then setclipboard(game.JobId) end
	jobBox.Text = game.JobId
	notify("Copied", "JobId copied to clipboard")
end, "Action")
addBtn(worldTab, "Instant Reset Character", 11, THEME.RED, function()
	local h = getHum()
	if h then h.Health = 0 end
end, "User")

GuiService.ErrorMessageChanged:Connect(function()
	if state.autoRejoin then
		task.wait(0.5)
		TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, LocalPlayer)
	end
end)

-- ============================================================
-- 8. UPGRADED PRECISION AIMBOT V2 & ESP ENGINE
-- ============================================================
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude
rayParams.IgnoreWater = true

local resolverHistory = {}

local function getAimReferencePos()
	if not camera then return Vector2.zero end
	if state.aimFollowMouse and not UserInputService.TouchEnabled then
		return UserInputService:GetMouseLocation()
	end
	return camera.ViewportSize * 0.5
end

local function isTargetVisible(part, char)
	if not camera or not part then return false end
	local myChar = LocalPlayer.Character
	rayParams.FilterDescendantsInstances = myChar and {myChar, camera} or {camera}
	local orig = camera.CFrame.Position
	local dir = part.Position - orig
	if dir.Magnitude < 0.5 then return true end
	local ok, hit = pcall(function()
		return Workspace:Raycast(orig, dir, rayParams)
	end)
	if not ok then return true end
	return (not hit) or hit.Instance:IsDescendantOf(char)
end

local function isValidEnemy(p)
	if not p or p == LocalPlayer or not p.Character then return false end
	if state.aimTeamCheck and p.Team ~= nil and p.Team == LocalPlayer.Team then return false end
	if state.aimFFCheck and p.Character:FindFirstChildOfClass("ForceField") then return false end
	local h = p.Character:FindFirstChildOfClass("Humanoid")
	if not h or h.Health <= 0 then return false end
	local be = p.Character:FindFirstChild("BodyEffects")
	local ko = be and (be:FindFirstChild("K.O") or be:FindFirstChild("Dead"))
	if ko and ko.Value == true then return false end
	if p.Character:FindFirstChild("GRABBING_CONSTRAINT") then return false end
	return true
end

local function getTargetBone(char, refPos)
	local h = char:FindFirstChildOfClass("Humanoid")
	if state.aimAirshot and h and (h.FloorMaterial == Enum.Material.Air or h:GetState() == Enum.HumanoidStateType.Freefall) then
		local airBone = char:FindFirstChild("LowerTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
		if airBone then return airBone end
	end

	if state.aimMode == "Head" then
		return char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
	elseif state.aimMode == "Torso" then
		return char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
	else
		local bestBone, bestDist = nil, math.huge
		for _, bName in ipairs({"Head", "HumanoidRootPart", "UpperTorso", "Torso", "LowerTorso"}) do
			local pt = char:FindFirstChild(bName)
			if pt then
				local sp, onScr = camera:WorldToViewportPoint(pt.Position)
				if onScr and sp.Z > 0 then
					local d = (Vector2.new(sp.X, sp.Y) - refPos).Magnitude
					if d < bestDist then bestDist = d; bestBone = pt end
				end
			end
		end
		return bestBone or char:FindFirstChild("HumanoidRootPart")
	end
end

local lockedTargetPlr = nil
local lockedTargetPrevHp = nil
local lastHudThumbUser = nil

local function getAimTarget()
	if not camera then return nil, nil end
	local refPos = getAimReferencePos()

	if state.stickyAim and lockedTargetPlr and isValidEnemy(lockedTargetPlr) then
		local bone = getTargetBone(lockedTargetPlr.Character, refPos)
		if bone then
			local sp, onScr = camera:WorldToViewportPoint(bone.Position)
			if onScr and sp.Z > 0 then
				local d = (Vector2.new(sp.X, sp.Y) - refPos).Magnitude
				if d <= state.aimRadius * 1.25 and ((not state.aimWallCheck) or isTargetVisible(bone, lockedTargetPlr.Character)) then
					return bone, lockedTargetPlr
				end
			end
		end
	end

	local candidates = {}
	for _, p in ipairs(Players:GetPlayers()) do
		if isValidEnemy(p) then
			local pt = getTargetBone(p.Character, refPos)
			if pt then
				local sp, onScr = camera:WorldToViewportPoint(pt.Position)
				if onScr and sp.Z > 0 then
					local d = (Vector2.new(sp.X, sp.Y) - refPos).Magnitude
					if d <= state.aimRadius then
						table.insert(candidates, {pt = pt, plr = p, char = p.Character, dist = d})
					end
				end
			end
		end
	end

	table.sort(candidates, function(a, b) return a.dist < b.dist end)
	for i = 1, math.min(#candidates, 4) do
		local c = candidates[i]
		if (not state.aimWallCheck) or isTargetVisible(c.pt, c.char) then
			return c.pt, c.plr
		end
	end
	return nil, nil
end

-- ESP Cache & Rendering
local espCache = {}
Players.PlayerRemoving:Connect(function(p)
	resolverHistory[p] = nil
	if espCache[p] then
		for _, v in pairs(espCache[p]) do if typeof(v) == "Instance" then v:Destroy() end end
		espCache[p] = nil
	end
end)

local function createDeltaBox(parent)
	local box = Instance.new("Frame", parent)
	box.BackgroundTransparency = 1; box.Visible = false; box.ZIndex = 10

	local edges = {}
	for _, cfg in ipairs({
		{UDim2.fromOffset(0, 0), UDim2.new(1, 0, 0, 2)},
		{UDim2.new(0, 0, 1, -2), UDim2.new(1, 0, 0, 2)},
		{UDim2.fromOffset(0, 0), UDim2.new(0, 2, 1, 0)},
		{UDim2.new(1, -2, 0, 0), UDim2.new(0, 2, 1, 0)},
	}) do
		local e = Instance.new("Frame", box)
		e.Position = cfg[1]; e.Size = cfg[2]; e.BorderSizePixel = 0; e.ZIndex = 11
		table.insert(edges, e)
	end

	local corners = {}
	for _, cd in ipairs({
		{Vector2.new(0, 0), UDim2.fromScale(0, 0), UDim2.new(0.28, 0, 0, 2)},
		{Vector2.new(0, 0), UDim2.fromScale(0, 0), UDim2.new(0, 2, 0.25, 0)},
		{Vector2.new(1, 0), UDim2.fromScale(1, 0), UDim2.new(0.28, 0, 0, 2)},
		{Vector2.new(1, 0), UDim2.fromScale(1, 0), UDim2.new(0, 2, 0.25, 0)},
		{Vector2.new(0, 1), UDim2.fromScale(0, 1), UDim2.new(0.28, 0, 0, 2)},
		{Vector2.new(0, 1), UDim2.fromScale(0, 1), UDim2.new(0, 2, 0.25, 0)},
		{Vector2.new(1, 1), UDim2.fromScale(1, 1), UDim2.new(0.28, 0, 0, 2)},
		{Vector2.new(1, 1), UDim2.fromScale(1, 1), UDim2.new(0, 2, 0.25, 0)},
	}) do
		local cf = Instance.new("Frame", box)
		cf.AnchorPoint = cd[1]; cf.Position = cd[2]; cf.Size = cd[3]; cf.BorderSizePixel = 0; cf.ZIndex = 12
		table.insert(corners, cf)
	end

	local hpBg = Instance.new("Frame", box)
	hpBg.Size = UDim2.new(0, 3, 1, 0); hpBg.Position = UDim2.new(0, -6, 0, 0)
	hpBg.BackgroundColor3 = Color3.fromRGB(20, 20, 20); hpBg.BorderSizePixel = 0; hpBg.Visible = false; hpBg.ZIndex = 11

	local hpFill = Instance.new("Frame", hpBg)
	hpFill.AnchorPoint = Vector2.new(0, 1); hpFill.Position = UDim2.fromScale(0, 1)
	hpFill.Size = UDim2.fromScale(1, 1); hpFill.BackgroundColor3 = THEME.GREEN; hpFill.BorderSizePixel = 0; hpFill.ZIndex = 12

	return {box = box, edges = edges, corners = corners, hpBg = hpBg, hpFill = hpFill}
end

local function updateEsp()
	if not camera or not keyVerified then return end
	local vp = camera.ViewportSize
	local orig = Vector2.new(vp.X * 0.5, vp.Y - 6)

	for _, p in ipairs(Players:GetPlayers()) do
		if p == LocalPlayer then continue end
		local d = espCache[p]
		if not d then
			local bData = createDeltaBox(espContainer)
			local tr = Instance.new("Frame", espContainer)
			tr.AnchorPoint = Vector2.new(0.5, 0.5); tr.BorderSizePixel = 0; tr.Visible = false; tr.ZIndex = 9
			local nm = Instance.new("TextLabel", espContainer)
			nm.AnchorPoint = Vector2.new(0.5, 1); nm.Size = UDim2.fromOffset(160, 15)
			nm.BackgroundTransparency = 1; nm.Font = Enum.Font.GothamBold; nm.TextSize = 11
			nm.TextColor3 = THEME.TEXT; nm.TextStrokeTransparency = 0.2; nm.Visible = false; nm.ZIndex = 13
			d = {bData = bData, tr = tr, nm = nm, hl = nil}
			espCache[p] = d
		end

		local c = p.Character
		local h = c and c:FindFirstChildOfClass("Humanoid")
		local r = c and c:FindFirstChild("HumanoidRootPart")
		local hd = c and c:FindFirstChild("Head")
		local teamMate = (p.Team ~= nil and p.Team == LocalPlayer.Team)

		if not (c and h and h.Health > 0 and r and hd) or (state.espTeamCheck and teamMate) then
			d.bData.box.Visible = false; d.tr.Visible = false; d.nm.Visible = false
			if d.hl then d.hl.Enabled = false end
			continue
		end

		local col = teamMate and THEME.GREEN or THEME.ACCENT
		if state.espChams then
			if not d.hl or d.hl.Parent ~= c then
				if d.hl then d.hl:Destroy() end
				d.hl = Instance.new("Highlight", c)
				d.hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
				d.hl.FillTransparency = 0.55
			end
			d.hl.Enabled = true; d.hl.FillColor = col; d.hl.OutlineColor = THEME.TEXT
		elseif d.hl then
			d.hl.Enabled = false
		end

		local rootSp, onScr = camera:WorldToViewportPoint(r.Position)
		if onScr and rootSp.Z > 0 then
			local tp = camera:WorldToViewportPoint(hd.Position + Vector3.new(0, 1.2, 0))
			local bp = camera:WorldToViewportPoint(r.Position - Vector3.new(0, 3.1, 0))
			local bh = math.clamp(math.abs(bp.Y - tp.Y), 12, vp.Y * 1.5)
			local bw = math.clamp(bh * 0.62, 8, vp.X)
			local cx, cy = rootSp.X, (tp.Y + bp.Y) * 0.5

			if state.espBoxes or state.espHealth then
				d.bData.box.Size = UDim2.fromOffset(bw, bh)
				d.bData.box.Position = UDim2.fromOffset(cx - bw * 0.5, cy - bh * 0.5)
				d.bData.box.Visible = true

				local fullOn = state.espBoxes and (not state.espCorners)
				local cornOn = state.espBoxes and state.espCorners
				for _, e in ipairs(d.bData.edges) do e.Visible = fullOn; e.BackgroundColor3 = col end
				for _, cr in ipairs(d.bData.corners) do cr.Visible = cornOn; cr.BackgroundColor3 = col end

				d.bData.hpBg.Visible = state.espHealth
				d.bData.hpFill.Size = UDim2.fromScale(1, math.clamp(h.Health / math.max(h.MaxHealth, 1), 0, 1))
			else
				d.bData.box.Visible = false
			end

			if state.espTracers then
				local targetPt = Vector2.new(cx, cy + bh * 0.5)
				local dst = targetPt - orig
				local mid = (orig + targetPt) * 0.5
				d.tr.Position = UDim2.fromOffset(mid.X, mid.Y)
				d.tr.Size = UDim2.fromOffset(dst.Magnitude, 1.5)
				d.tr.Rotation = math.deg(math.atan2(dst.Y, dst.X))
				d.tr.BackgroundColor3 = col; d.tr.Visible = true
			else
				d.tr.Visible = false
			end

			if state.espNames then
				local studs = math.floor((camera.CFrame.Position - r.Position).Magnitude)
				d.nm.Text = string.format("%s [%d HP • %dm]", p.DisplayName, math.floor(h.Health), studs)
				d.nm.Position = UDim2.fromOffset(cx, (cy - bh * 0.5) - 3)
				d.nm.Visible = true
			else
				d.nm.Visible = false
			end
		else
			d.bData.box.Visible = false; d.tr.Visible = false; d.nm.Visible = false
		end
	end
end

-- ============================================================
-- 9. CAMERA PRIORITY BIND & CRASH-PROOF RUNTIME LOOPS
-- ============================================================
local currentPing = 45
local frames, lastT = 0, os.clock()
local lastShotHitTime = 0
local lastTriggerShot = 0
local orbitAngle = 0
local flingToggle = false
local lastCamLook = Vector3.new(0, 0, -1)

RunService:BindToRenderStep("LarpsAimbotLock", Enum.RenderPriority.Camera.Value + 1, function(dt)
	if not keyVerified then return end
	camera = Workspace.CurrentCamera
	if not camera then return end

	if state.fovLock then camera.FieldOfView = state.fovVal end

	if state.showFov then
		if state.aimFollowMouse and not UserInputService.TouchEnabled then
			local mPos = UserInputService:GetMouseLocation()
			fovCircle.Position = UDim2.fromOffset(mPos.X, mPos.Y)
		else
			fovCircle.Position = UDim2.fromScale(0.5, 0.5)
		end
	end

	if state.freecamOn then
		camera.CameraType = Enum.CameraType.Scriptable
		local mDelta = UserInputService:GetMouseDelta()
		if UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) or UserInputService.TouchEnabled then
			freecamAngles = Vector2.new(
				math.clamp(freecamAngles.X - math.rad(mDelta.Y * 0.35), -math.rad(89), math.rad(89)),
				freecamAngles.Y - math.rad(mDelta.X * 0.35)
			)
		end
		local rotCF = CFrame.fromEulerAnglesYXZ(freecamAngles.X, freecamAngles.Y, 0)
		local h = getHum()
		local moveVec = Vector3.zero
		if h and h.MoveDirection.Magnitude > 0 then
			local flatLook = Vector3.new(rotCF.LookVector.X, 0, rotCF.LookVector.Z)
			local flatRight = Vector3.new(rotCF.RightVector.X, 0, rotCF.RightVector.Z)
			if flatLook.Magnitude > 0.01 and flatRight.Magnitude > 0.01 then
				moveVec = (rotCF.LookVector * h.MoveDirection:Dot(flatLook.Unit)) + (rotCF.RightVector * h.MoveDirection:Dot(flatRight.Unit))
			end
		end
		if not UserInputService:GetFocusedTextBox() then
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then moveVec += Vector3.new(0, 1, 0) end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then moveVec -= Vector3.new(0, 1, 0) end
		end
		freecamCF = CFrame.new(freecamCF.Position + (moveVec * state.freecamSpeed * dt)) * rotCF
		camera.CFrame = freecamCF
		return
	end

	local aimActive = state.aimOn and ((not state.aimHoldOnly) or UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2))

	if aimActive then
		local targ, targPlr = getAimTarget()
		if targ and targPlr then
			if lockedTargetPlr ~= targPlr then
				lockedTargetPlr = targPlr
				local th = targPlr.Character and targPlr.Character:FindFirstChildOfClass("Humanoid")
				lockedTargetPrevHp = th and th.Health or nil
				if lastHudThumbUser ~= targPlr.UserId then
					lastHudThumbUser = targPlr.UserId
					task.spawn(function()
						local ok, img = pcall(function()
							return Players:GetUserThumbnailAsync(targPlr.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
						end)
						if ok and img then thudAvatar.Image = img end
					end)
				end
			end
			fovStroke.Color = THEME.GREEN

			local th = targPlr.Character and targPlr.Character:FindFirstChildOfClass("Humanoid")
			if state.targetHudOn and th then
				targetHudCard.Visible = true
				thudName.Text = targPlr.DisplayName
				local studs = math.floor((camera.CFrame.Position - targ.Position).Magnitude)
				thudSub.Text = string.format("%d HP  •  %dm away", math.floor(th.Health), studs)
				thudBarFill.Size = UDim2.fromScale(math.clamp(th.Health / math.max(th.MaxHealth, 1), 0, 1), 1)
			else
				targetHudCard.Visible = false
			end

			local aimPos = targ.Position
			if state.aimPrediction then
				local vel = targ.AssemblyLinearVelocity
				local hist = resolverHistory[targPlr]
				if state.aimResolver and hist and hist.vel then
					-- Use resolved delta velocity if standard velocity is spoofed or desynced
					if vel.Magnitude > 140 or (vel - hist.vel).Magnitude > 65 then
						vel = hist.vel
					end
				end

				if vel.Magnitude < 320 then
					local predFactor = state.aimPredAmount
					if state.autoPingPred then
						predFactor = math.clamp((currentPing / 1000) + 0.048, 0.08, 0.30)
					end
					local predOffset = Vector3.new(vel.X * predFactor, vel.Y * (predFactor * 0.58), vel.Z * predFactor)
					aimPos = aimPos + predOffset
				end
			end

			if state.aimSnapline then
				local sp, onScr = camera:WorldToViewportPoint(aimPos)
				if onScr and sp.Z > 0 then
					local originPt = getAimReferencePos()
					local pt2D = Vector2.new(sp.X, sp.Y)
					local diff = pt2D - originPt
					local mid = (originPt + pt2D) * 0.5
					targetSnapline.Position = UDim2.fromOffset(mid.X, mid.Y)
					targetSnapline.Size = UDim2.fromOffset(diff.Magnitude, 1.5)
					targetSnapline.Rotation = math.deg(math.atan2(diff.Y, diff.X))
					targetSnapline.Visible = true
				else
					targetSnapline.Visible = false
				end
			else
				targetSnapline.Visible = false
			end

			local camPos = camera.CFrame.Position
			local delta = aimPos - camPos
			if delta.Magnitude > 0.5 and aimPos == aimPos then
				local goalCF = CFrame.lookAt(camPos, aimPos)
				if state.aimSmooth >= 0.98 then
					camera.CFrame = goalCF
				else
					-- Frame-rate independent exponential smoothing
					local speed = 6 + (state.aimSmooth * 42)
					local expAlpha = math.clamp(1 - math.exp(-speed * dt), 0.02, 1)
					camera.CFrame = camera.CFrame:Lerp(goalCF, expAlpha)
				end
			end

			if state.triggerBot and os.clock() - lastTriggerShot > 0.10 then
				lastTriggerShot = os.clock()
				local tool = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Tool")
				if tool then pcall(function() tool:Activate() end) end
			end
		else
			lockedTargetPlr = nil
			lockedTargetPrevHp = nil
			fovStroke.Color = THEME.ACCENT
			targetHudCard.Visible = false
			targetSnapline.Visible = false
		end
	else
		lockedTargetPlr = nil
		lockedTargetPrevHp = nil
		fovStroke.Color = THEME.ACCENT
		targetHudCard.Visible = false
		targetSnapline.Visible = false
	end

	if state.stretchOn then
		camera.CFrame = camera.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, state.stretchVal, 0, 0, 0, 1)
	end
end)

RunService.RenderStepped:Connect(function(dt)
	if not keyVerified then return end
	camera = Workspace.CurrentCamera
	if not camera then return end

	frames += 1
	local now = os.clock()
	if now - lastT >= 0.5 then
		local fps = math.floor(frames / (now - lastT))
		pcall(function() currentPing = math.floor(Stats.Network.ServerStatsItem["Data Ping"]:GetValue()) end)
		local pTime = formatTime(now - sessionStart)
		local r = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
		local spd = r and math.floor(Vector3.new(r.AssemblyLinearVelocity.X, 0, r.AssemblyLinearVelocity.Z).Magnitude) or 0
		topHudText.Text = string.format("KEY: %s  •  %s  •  %d FPS  •  %dms  •  %d studs/s  •  %s", REQUIRED_KEY, string.sub(currentGameName, 1, 14), fps, currentPing, spd, pTime)
		gameNameLbl.Text = "Experience: " .. currentGameName
		playTimeLbl.Text = "Session Time: " .. pTime .. "  •  RightShift / Pill to Toggle"

		if state.targetPlrName ~= "" then
			local tp = Players:FindFirstChild(state.targetPlrName)
			local th = tp and tp.Character and tp.Character:FindFirstChildOfClass("Humanoid")
			local tr = tp and tp.Character and tp.Character:FindFirstChild("HumanoidRootPart")
			if th and tr then
				local studs = math.floor((camera.CFrame.Position - tr.Position).Magnitude)
				targetStatsLbl.Text = string.format("HP: %d/%d  •  Distance: %d studs", math.floor(th.Health), math.floor(th.MaxHealth), studs)
			end
		end
		frames = 0; lastT = now
	end

	if state.rainbowTheme then
		setThemeColor(Color3.fromHSV((now * 0.16) % 1, 0.78, 1))
	end

	if state.worldTintOn and not state.fullbright then
		Lighting.Ambient = THEME.ACCENT
		Lighting.OutdoorAmbient = THEME.ACCENT
	end

	if state.customTimeOn then
		Lighting.ClockTime = state.clockTimeVal
	end

	if state.motionBlurOn then
		if not blurEffect or blurEffect.Parent ~= Lighting then
			blurEffect = Instance.new("BlurEffect", Lighting)
			blurEffect.Size = 0
		end
		local curLook = camera.CFrame.LookVector
		local turnSpeed = (curLook - lastCamLook).Magnitude / math.max(dt, 0.001)
		lastCamLook = curLook
		blurEffect.Size = math.clamp(turnSpeed * 1.4, 0, 16)
	end

	-- 3D Neon China Hat Update
	if state.chinaHatOn and LocalPlayer.Character then
		local hd = LocalPlayer.Character:FindFirstChild("Head")
		if hd then
			if not chinaHatPart or not chinaHatPart.Parent then
				chinaHatPart = Instance.new("Part", Workspace)
				chinaHatPart.Name = "LarpsChinaHat"
				chinaHatPart.Size = Vector3.new(3, 0.8, 3)
				chinaHatPart.Anchored = true
				chinaHatPart.CanCollide = false
				chinaHatPart.CastShadow = false
				chinaHatPart.Material = Enum.Material.Neon
				chinaHatPart.Transparency = 0.32
				local mesh = Instance.new("SpecialMesh", chinaHatPart)
				mesh.MeshType = Enum.MeshType.FileMesh
				mesh.MeshId = "rbxassetid://1033714"
				mesh.Scale = Vector3.new(1.75, 0.55, 1.75)
			end
			chinaHatPart.Color = THEME.ACCENT
			chinaHatPart.CFrame = CFrame.new(hd.Position + Vector3.new(0, 1.15, 0))
		end
	end

	updateEsp()

	if state.spectating and state.targetPlrName ~= "" then
		local t = Players:FindFirstChild(state.targetPlrName)
		local th = t and t.Character and t.Character:FindFirstChildOfClass("Humanoid")
		if th then camera.CameraSubject = th end
	end

	local h = getHum()
	if h and state.camOffsetOn then
		h.CameraOffset = Vector3.new(state.camOffsetX, state.camOffsetY, 0)
	end

	if state.flyEnabled and flyBV and flyBG and h then
		local camCF = camera.CFrame
		local moveDir = h.MoveDirection
		local wishDir = Vector3.zero

		if moveDir.Magnitude > 0 then
			local flatLook = Vector3.new(camCF.LookVector.X, 0, camCF.LookVector.Z)
			local flatRight = Vector3.new(camCF.RightVector.X, 0, camCF.RightVector.Z)
			if flatLook.Magnitude > 0.01 and flatRight.Magnitude > 0.01 then
				local fwdAmount = moveDir:Dot(flatLook.Unit)
				local rightAmount = moveDir:Dot(flatRight.Unit)
				wishDir = (camCF.LookVector * fwdAmount) + (camCF.RightVector * rightAmount)
			else
				wishDir = moveDir
			end
		end

		local vIn = state.flyVert
		if not UserInputService:GetFocusedTextBox() then
			if UserInputService:IsKeyDown(Enum.KeyCode.Space) then vIn = 1 end
			if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) or UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then vIn = -1 end
		end

		wishDir += Vector3.new(0, vIn, 0)
		if wishDir.Magnitude > 0 then
			wishDir = wishDir.Unit * state.flySpeed
		end

		flyVel = flyVel:Lerp(wishDir, math.clamp(dt * 15, 0, 1))
		flyBV.Velocity = flyVel
		flyBG.CFrame = camCF
	end
end)

RunService.Heartbeat:Connect(function(dt)
	if not keyVerified then return end

	-- Update Resolver History for Enemies
	if state.aimResolver then
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character then
				local tr = p.Character:FindFirstChild("HumanoidRootPart")
				if tr then
					local prev = resolverHistory[p]
					if prev and prev.pos then
						local rawVel = (tr.Position - prev.pos) / math.max(dt, 0.001)
						resolverHistory[p] = {
							pos = tr.Position,
							vel = prev.vel:Lerp(rawVel, 0.45)
						}
					else
						resolverHistory[p] = {pos = tr.Position, vel = Vector3.zero}
					end
				end
			end
		end
	end

	local c = LocalPlayer.Character
	local h = getHum()
	local r = c and c:FindFirstChild("HumanoidRootPart")
	if not r or not h or h.Health <= 0 then return end

	if state.rapidFire and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) and not settingsGui.Enabled then
		local tool = c:FindFirstChildOfClass("Tool")
		if tool then pcall(function() tool:Activate() end) end
	end

	if lockedTargetPlr and lockedTargetPlr.Character then
		local th = lockedTargetPlr.Character:FindFirstChildOfClass("Humanoid")
		if th then
			if lockedTargetPrevHp and th.Health < lockedTargetPrevHp and (lockedTargetPrevHp - th.Health) >= 1 then
				local now = os.clock()
				if now - lastShotHitTime > 0.25 then
					lastShotHitTime = now
					local dmg = math.floor(lockedTargetPrevHp - th.Health)
					if state.hitmarkers then
						hitmarkerFrame.Visible = true
						task.delay(0.16, function() hitmarkerFrame.Visible = false end)
					end
					if state.shotHitNotif then
						notify("Target Hit", string.format("%s (-%d HP)", lockedTargetPlr.DisplayName, dmg))
					end
				end
			end
			lockedTargetPrevHp = th.Health
		end
	end

	if state.selfAura then
		if not selfHighlight or selfHighlight.Parent ~= c then
			if selfHighlight then selfHighlight:Destroy() end
			selfHighlight = Instance.new("Highlight", c)
			selfHighlight.FillTransparency = 0.65
		end
		selfHighlight.FillColor = THEME.ACCENT
		selfHighlight.OutlineColor = THEME.TEXT
	end

	if state.speedOn and h.WalkSpeed ~= state.walkSpeed then
		h.WalkSpeed = state.walkSpeed
	elseif not state.speedOn and state.autoSprint and h.WalkSpeed ~= 26 then
		h.WalkSpeed = 26
	elseif state.antiSlow and h.WalkSpeed < 16 then
		h.WalkSpeed = 16
	end

	if state.antiSlow then
		pcall(function() h:SetStateEnabled(Enum.HumanoidStateType.Jumping, true) end)
	end

	if state.antiSit and h.Sit then
		h.Sit = false
	end

	if state.cfSpeedOn and not state.flyEnabled and h.MoveDirection.Magnitude > 0 then
		r.CFrame = r.CFrame + (h.MoveDirection * (state.cfSpeed * dt))
	end

	if state.noFallDmg and r.AssemblyLinearVelocity.Y < -65 then
		r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, -15, r.AssemblyLinearVelocity.Z)
	end

	if state.spinBot then
		r.CFrame = r.CFrame * CFrame.Angles(0, math.rad(state.spinSpeed), 0)
	elseif state.moonwalkOn and h.MoveDirection.Magnitude > 0.05 then
		local flatDir = Vector3.new(h.MoveDirection.X, 0, h.MoveDirection.Z)
		if flatDir.Magnitude > 0.05 then
			r.CFrame = CFrame.lookAt(r.Position, r.Position - flatDir.Unit)
		end
	end

	if state.antiLockDesync and not state.walkFling then
		local realVel = r.AssemblyLinearVelocity
		r.AssemblyLinearVelocity = Vector3.new(math.random(-180, 180), -95, math.random(-180, 180))
		RunService.RenderStepped:Wait()
		if r and r.Parent then
			r.AssemblyLinearVelocity = realVel
		end
	end

	if state.targetOrbit then
		local tPlr = lockedTargetPlr or Players:FindFirstChild(state.targetPlrName)
		local tr = tPlr and tPlr.Character and tPlr.Character:FindFirstChild("HumanoidRootPart")
		if tr then
			orbitAngle += dt * state.orbitSpeed
			local offset = Vector3.new(math.cos(orbitAngle) * state.orbitRadius, 0, math.sin(orbitAngle) * state.orbitRadius)
			r.CFrame = CFrame.lookAt(tr.Position + offset, tr.Position)
		end
	end

	if state.bhop and h.MoveDirection.Magnitude > 0 and h.FloorMaterial ~= Enum.Material.Air then
		h:ChangeState(Enum.HumanoidStateType.Jumping)
	end

	if state.spiderClimb then
		pcall(function()
			rayParams.FilterDescendantsInstances = camera and {c, camera} or {c}
			local checkDir = (h.MoveDirection.Magnitude > 0.05) and h.MoveDirection.Unit or r.CFrame.LookVector
			local wallHit = Workspace:Raycast(r.Position, checkDir * 3.4, rayParams)
				or Workspace:Raycast(r.Position - Vector3.new(0, 1.5, 0), checkDir * 3.4, rayParams)
			if wallHit and wallHit.Instance and wallHit.Instance.CanCollide then
				r.AssemblyLinearVelocity = Vector3.new(checkDir.X * 14, state.spiderSpeed, checkDir.Z * 14)
			end
		end)
	end

	if state.autoParkour and h.MoveDirection.Magnitude > 0.1 and h.FloorMaterial ~= Enum.Material.Air then
		pcall(function()
			rayParams.FilterDescendantsInstances = camera and {c, camera} or {c}
			local dir = h.MoveDirection.Unit
			local lowHit = Workspace:Raycast(r.Position - Vector3.new(0, 1.4, 0), dir * 3.8, rayParams)
			local highHit = Workspace:Raycast(r.Position + Vector3.new(0, 2.5, 0), dir * 3.8, rayParams)
			if lowHit and not highHit then
				h:ChangeState(Enum.HumanoidStateType.Jumping)
			end
		end)
	end

	if state.jetpackOn and not state.flyEnabled and not UserInputService:GetFocusedTextBox() then
		if UserInputService:IsKeyDown(Enum.KeyCode.Space) then
			local v = r.AssemblyLinearVelocity
			r.AssemblyLinearVelocity = Vector3.new(v.X, state.jetpackPower, v.Z)
		end
	end

	if state.antiVoid and r.Position.Y < (Workspace.FallenPartsDestroyHeight + 55) then
		r.AssemblyLinearVelocity = Vector3.new(r.AssemblyLinearVelocity.X, 135, r.AssemblyLinearVelocity.Z)
	end

	if state.loopGoto and state.targetPlrName ~= "" then
		local t = Players:FindFirstChild(state.targetPlrName)
		local tr = t and t.Character and t.Character:FindFirstChild("HumanoidRootPart")
		if tr then
			r.AssemblyLinearVelocity = Vector3.zero
			r.CFrame = tr.CFrame * CFrame.new(0, 0, 3.5)
		end
	end

	if state.airWalk then
		if not airWalkPart or not airWalkPart.Parent then
			airWalkPart = Instance.new("Part", Workspace)
			airWalkPart.Size = Vector3.new(10, 1, 10)
			airWalkPart.Anchored = true
			airWalkPart.Transparency = 0.65
			airWalkPart.Color = THEME.ACCENT
			airWalkPart.Material = Enum.Material.Neon
		end
		airWalkPart.CFrame = CFrame.new(r.Position.X, r.Position.Y - 3.5, r.Position.Z)
	end

	-- Upgraded Massive Hitbox Expander (Massless & Collision Bypass)
	if state.hitboxOn then
		local targetPartName = (state.hitboxPart == "Head") and "Head" or "HumanoidRootPart"
		local boxVec = Vector3.new(state.hitboxSize, state.hitboxSize, state.hitboxSize)
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character then
				if state.aimTeamCheck and p.Team ~= nil and p.Team == LocalPlayer.Team then continue end
				local tr = p.Character:FindFirstChild(targetPartName)
				if tr and tr:IsA("BasePart") then
					pcall(function()
						tr.Size = boxVec
						tr.Transparency = state.hitboxTrans
						tr.CanCollide = false
						tr.Massless = true
						tr.Color = THEME.ACCENT
					end)
				end
			end
		end
	end

	if state.walkFling then
		flingToggle = not flingToggle
		if flingToggle then
			r.AssemblyLinearVelocity = Vector3.new(0, 4500, 0)
		else
			r.AssemblyLinearVelocity = h.MoveDirection * (state.speedOn and state.walkSpeed or 16)
		end
	end
end)

RunService.Stepped:Connect(function()
	if not keyVerified then return end
	if (state.noclip or state.walkFling or state.flyEnabled) and LocalPlayer.Character then
		for _, pt in ipairs(LocalPlayer.Character:GetDescendants()) do
			if pt:IsA("BasePart") and pt.CanCollide then pt.CanCollide = false end
		end
	end
	if state.antiFling or state.hitboxOn then
		for _, p in ipairs(Players:GetPlayers()) do
			if p ~= LocalPlayer and p.Character then
				for _, pt in ipairs(p.Character:GetDescendants()) do
					if pt:IsA("BasePart") and pt.CanCollide then pt.CanCollide = false end
				end
			end
		end
	end
end)

local lastRingTime = 0
UserInputService.JumpRequest:Connect(function()
	if not keyVerified then return end
	local h = getHum()
	if state.infJump and h then
		h:ChangeState(Enum.HumanoidStateType.Jumping)
	end
	if state.jumpFX and os.clock() - lastRingTime > 0.22 then
		lastRingTime = os.clock()
		spawnJumpRing()
	end
end)

LocalPlayer.Idled:Connect(function()
	VirtualUser:CaptureController()
	VirtualUser:ClickButton2(Vector2.zero)
end)

-- ============================================================
-- 10. KEY SYSTEM LOADER WITH TOP-SCREEN KEY BANNER (KEY: 2027)
-- ============================================================
local function launchMainScript()
	if keyVerified then return end
	keyVerified = true
	overlayGui.Enabled = true
	toggleGui.Enabled = true

	if autoLoadEnabled then
		task.spawn(function()
			local loaded = loadConfigSlot("Slot1", true)
			if loaded then
				notify("Old Config Loaded", "Auto-restored your saved settings")
			end
			if state.headlessOn or state.korbloxOn then
				applyCosmetics(LocalPlayer.Character)
			end
		end)
	end

	openHeroUI()
	notify("LARPS V8+ Ready", "Key Verified • Welcome " .. LocalPlayer.DisplayName)
end

local loaderGui = Instance.new("ScreenGui")
loaderGui.Name = "LarpsLoaderUI"
loaderGui.ResetOnSpawn = false
loaderGui.IgnoreGuiInset = true
loaderGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
loaderGui.DisplayOrder = 20000
loaderGui.Parent = guiParent

local topKeyBanner = Instance.new("TextButton", loaderGui)
topKeyBanner.AnchorPoint = Vector2.new(0.5, 0)
topKeyBanner.Position = UDim2.new(0.5, 0, 0, 10)
topKeyBanner.Size = UDim2.fromOffset(420, 32)
topKeyBanner.BackgroundColor3 = THEME.BG
topKeyBanner.BackgroundTransparency = 0.08
topKeyBanner.BorderSizePixel = 0
topKeyBanner.Text = "🔑  KEY IS: 2027  (No Discord? Click Here to Auto-Fill Key!)"
topKeyBanner.TextColor3 = THEME.GREEN
topKeyBanner.Font = Enum.Font.GothamBlack
topKeyBanner.TextSize = 12
topKeyBanner.AutoButtonColor = false
topKeyBanner.ZIndex = 100
Corner(topKeyBanner, 999)

local bannerStroke = Instance.new("UIStroke", topKeyBanner)
bannerStroke.Color = THEME.ACCENT
bannerStroke.Thickness = 1.4
bannerStroke.Transparency = 0.25

local keyCard = Instance.new("Frame", loaderGui)
keyCard.AnchorPoint = Vector2.new(0.5, 0.5)
keyCard.Position = UDim2.fromScale(0.5, 0.5)
keyCard.Size = UDim2.fromOffset(370, 215)
keyCard.BackgroundColor3 = THEME.BG
keyCard.BackgroundTransparency = 0.08
keyCard.BorderSizePixel = 0
keyCard.ZIndex = 90
Corner(keyCard, 14)

local keyCardScale = Instance.new("UIScale", keyCard)
keyCardScale.Scale = 0.85
tween(keyCardScale, POP_TWEEN, {Scale = 1})

local kTitle = Instance.new("TextLabel", keyCard)
kTitle.Size = UDim2.new(1, -28, 0, 24)
kTitle.Position = UDim2.fromOffset(14, 14)
kTitle.BackgroundTransparency = 1
kTitle.Font = Enum.Font.GothamBlack
kTitle.Text = "LARPS V8+  •  KEY SYSTEM"
kTitle.TextColor3 = THEME.TEXT
kTitle.TextSize = 16
kTitle.TextXAlignment = Enum.TextXAlignment.Left
kTitle.ZIndex = 92

local kSub = Instance.new("TextLabel", keyCard)
kSub.Size = UDim2.new(1, -28, 0, 32)
kSub.Position = UDim2.fromOffset(14, 38)
kSub.BackgroundTransparency = 1
kSub.Font = Enum.Font.GothamMedium
kSub.Text = "Join our Discord for keys & updates:\n" .. DISCORD_INVITE
kSub.TextColor3 = THEME.SUBTEXT
kSub.TextSize = 11
kSub.TextWrapped = true
kSub.TextXAlignment = Enum.TextXAlignment.Left
kSub.ZIndex = 92

local keyInput = Instance.new("TextBox", keyCard)
keyInput.Size = UDim2.new(1, -28, 0, 38)
keyInput.Position = UDim2.fromOffset(14, 78)
keyInput.BackgroundColor3 = THEME.INPUT
keyInput.BorderSizePixel = 0
keyInput.PlaceholderText = "Enter Key Here (Key is 2027)..."
keyInput.PlaceholderColor3 = THEME.SUBTEXT
keyInput.Text = ""
keyInput.TextColor3 = THEME.TEXT
keyInput.Font = Enum.Font.GothamBold
keyInput.TextSize = 13
keyInput.ClearTextOnFocus = false
keyInput.ZIndex = 92
Corner(keyInput, 9)

local kBtnRow = Instance.new("Frame", keyCard)
kBtnRow.Size = UDim2.new(1, -28, 0, 38)
kBtnRow.Position = UDim2.fromOffset(14, 126)
kBtnRow.BackgroundTransparency = 1
kBtnRow.ZIndex = 92

local verifyBtn = Instance.new("TextButton", kBtnRow)
verifyBtn.Size = UDim2.new(0.5, -5, 1, 0)
verifyBtn.Position = UDim2.fromOffset(0, 0)
verifyBtn.BackgroundColor3 = THEME.GREEN
verifyBtn.BorderSizePixel = 0
verifyBtn.Text = "Unlock Script"
verifyBtn.TextColor3 = THEME.BG
verifyBtn.Font = Enum.Font.GothamBlack
verifyBtn.TextSize = 12
verifyBtn.AutoButtonColor = false
verifyBtn.ZIndex = 93
Corner(verifyBtn, 9)

local discordBtn = Instance.new("TextButton", kBtnRow)
discordBtn.Size = UDim2.new(0.5, -5, 1, 0)
discordBtn.Position = UDim2.new(0.5, 5, 0, 0)
discordBtn.BackgroundColor3 = THEME.ACCENT
discordBtn.BorderSizePixel = 0
discordBtn.Text = "Copy Discord"
discordBtn.TextColor3 = THEME.BG
discordBtn.Font = Enum.Font.GothamBlack
discordBtn.TextSize = 12
discordBtn.AutoButtonColor = false
discordBtn.ZIndex = 93
Corner(discordBtn, 9)

local kStatus = Instance.new("TextLabel", keyCard)
kStatus.Size = UDim2.new(1, -28, 0, 20)
kStatus.Position = UDim2.fromOffset(14, 174)
kStatus.BackgroundTransparency = 1
kStatus.Font = Enum.Font.GothamSemibold
kStatus.Text = "Tip: Type 2027 to auto-load immediately!"
kStatus.TextColor3 = THEME.ACCENT
kStatus.TextSize = 11
kStatus.TextXAlignment = Enum.TextXAlignment.Center
kStatus.ZIndex = 92

local unlocking = false
local function checkEnteredKey(rawText)
	if unlocking then return end
	local clean = string.gsub(tostring(rawText or ""), "%s+", "")
	if clean == REQUIRED_KEY then
		unlocking = true
		kStatus.TextColor3 = THEME.GREEN
		kStatus.Text = "Key Verified! Auto-loading LARPS V8+..."
		tween(keyCardScale, FAST_TWEEN, {Scale = 0.8})
		tween(keyCard, FAST_TWEEN, {BackgroundTransparency = 1})
		tween(topKeyBanner, FAST_TWEEN, {BackgroundTransparency = 1, TextTransparency = 1})
		task.delay(0.2, function()
			if loaderGui and loaderGui.Parent then loaderGui:Destroy() end
			launchMainScript()
		end)
	end
end

keyInput:GetPropertyChangedSignal("Text"):Connect(function()
	checkEnteredKey(keyInput.Text)
end)

verifyBtn.MouseButton1Click:Connect(function()
	playRipple(verifyBtn, THEME.TEXT)
	local clean = string.gsub(keyInput.Text, "%s+", "")
	if clean == REQUIRED_KEY then
		checkEnteredKey(clean)
	else
		kStatus.TextColor3 = THEME.RED
		kStatus.Text = "Invalid Key! Use key 2027 at the top of your screen."
	end
end)

discordBtn.MouseButton1Click:Connect(function()
	playRipple(discordBtn, THEME.TEXT)
	pcall(function()
		if type(setclipboard) == "function" then
			setclipboard(DISCORD_INVITE)
		end
	end)
	kStatus.TextColor3 = THEME.GREEN
	kStatus.Text = "Copied " .. DISCORD_INVITE .. " to clipboard! (Key: 2027)"
end)

topKeyBanner.MouseButton1Click:Connect(function()
	keyInput.Text = REQUIRED_KEY
	checkEnteredKey(REQUIRED_KEY)
end)