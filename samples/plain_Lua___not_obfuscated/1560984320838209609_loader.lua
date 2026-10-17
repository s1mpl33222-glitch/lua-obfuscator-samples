local NINE_BASE          = "https://ninekey.lovable.app"
local NINE_BOOTSTRAP_URL = NINE_BASE .. "/api/loader/bootstrap"
local NINE_SCRIPT_URL    = NINE_BASE .. "/api/loader/script"
local NINE_HEARTBEAT_URL = NINE_BASE .. "/api/loader/heartbeat"
local NINE_DISCORD_URL   = "https://discord.gg/tZkuKRZwrB"
local LUMORE_DISCORD_URL = "https://discord.gg/4PZUnNqfkN"
local NINE_ICON_URL   = NINE_BASE .. "/__l5e/assets-v1/882a6d44-c1cb-4cd0-a952-65e23e40adf0/nine-discord-icon.jpg"
local LUMORE_ICON_URL = NINE_BASE .. "/__l5e/assets-v1/8f983bf6-1680-4ef4-b8d6-3dc8c6a18f1e/lumore-discord-icon.png"

local NINE_AUTOEXEC_PLACE_ID = 107778070777162

local TweenService       = game:GetService("TweenService")
local Players            = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")

local player    = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")

local BLACK      = Color3.fromHex("#000000")
local BLUE       = Color3.fromHex("#5479E3")
local BLUE_DARK  = Color3.fromHex("#3A5BB8")
local CARD       = Color3.fromRGB(14, 14, 18)
local FIELD      = Color3.fromRGB(8, 8, 12)
local BTN_ALT    = Color3.fromRGB(24, 24, 30)
local BORDER     = Color3.fromRGB(38, 38, 50)
local TEXT_MAIN  = Color3.fromRGB(242, 242, 246)
local TEXT_MUTED = Color3.fromRGB(150, 150, 168)
local TEXT_DIM   = Color3.fromRGB(88, 88, 105)
local GREEN      = Color3.fromRGB(74, 222, 128)
local RED        = Color3.fromRGB(248, 113, 113)
local AMBER      = Color3.fromRGB(251, 191, 36)

local TWEEN_FAST   = TweenInfo.new(0.25, Enum.EasingStyle.Quad,  Enum.EasingDirection.Out)
local TWEEN_SMOOTH = TweenInfo.new(0.5,  Enum.EasingStyle.Quint, Enum.EasingDirection.Out)

local defaultSettings = {
	autoGameDetect = false,
	animations     = true,
	uiScaleOption  = "Normal",
	showKeyInfo    = true,
}

local settingsData = {
	autoGameDetect = defaultSettings.autoGameDetect,
	animations     = defaultSettings.animations,
	uiScaleOption  = defaultSettings.uiScaleOption,
	showKeyInfo    = defaultSettings.showKeyInfo,
}

local old = playerGui:FindFirstChild("NineKeySystem")
if old then old:Destroy() end

local function new(class, props, parent)
	local inst = Instance.new(class)
	for k, v in pairs(props) do inst[k] = v end
	inst.Parent = parent
	return inst
end

local function corner(parent, r)
	return new("UICorner", { CornerRadius = UDim.new(0, r) }, parent)
end

local function stroke(parent, color, thickness)
	return new("UIStroke", {
		Color = color,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	}, parent)
end

local function tween(obj, info, props)
	if settingsData and not settingsData.animations then
		for k, v in pairs(props) do
			obj[k] = v
		end
	else
		TweenService:Create(obj, info, props):Play()
	end
end

local function getScaleMultiplier()
	if settingsData.uiScaleOption == "Small" then
		return 0.85
	elseif settingsData.uiScaleOption == "Large" then
		return 1.15
	end
	return 1.0
end

local function addFeedback(btn, base, hover)
	btn.MouseEnter:Connect(function()
		tween(btn, TWEEN_FAST, { BackgroundColor3 = hover })
	end)
	btn.MouseLeave:Connect(function()
		tween(btn, TWEEN_FAST, { BackgroundColor3 = base })
	end)
	btn.MouseButton1Down:Connect(function()
		tween(btn, TweenInfo.new(0.1), { BackgroundTransparency = 0.35 })
	end)
	btn.MouseButton1Up:Connect(function()
		tween(btn, TweenInfo.new(0.1), { BackgroundTransparency = 0 })
	end)
end

local gui = new("ScreenGui", {
	Name = "NineLoader",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)

local backdrop = new("Frame", {
	Name = "Backdrop",
	Size = UDim2.fromScale(1, 1),
	BackgroundColor3 = BLACK,
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
}, gui)

local glow = new("ImageLabel", {
	Name = "Glow",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(560, 560),
	BackgroundTransparency = 1,
	Image = "rbxassetid://5028857084",
	ImageColor3 = BLUE,
	ImageTransparency = 1,
	ScaleType = Enum.ScaleType.Fit,
}, backdrop)

local LOADER_W, LOADER_H = 920, 440
local loaderCard = new("Frame", {
	Name = "LoaderCard",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.new(0.5, 0, 0.54, 0),
	Size = UDim2.fromOffset(LOADER_W, LOADER_H),
	BackgroundColor3 = CARD,
	BorderSizePixel = 0,
	Visible = false,
	BackgroundTransparency = 1,
	ClipsDescendants = true,
}, backdrop)
corner(loaderCard, 24)
local loaderStroke = stroke(loaderCard, BORDER, 1)

local loaderScale = new("UIScale", { Scale = 1 }, loaderCard)
local function fitLoader()
	local vp = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
	local mult = getScaleMultiplier()
	loaderScale.Scale = math.clamp(math.min((vp.X - 24) / LOADER_W, (vp.Y - 24) / LOADER_H) * mult, 0.4, 1.3)
end
fitLoader()
if workspace.CurrentCamera then
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(fitLoader)
end

local topBar = new("Frame", {
	Name = "TopBar",
	Size = UDim2.new(1, 0, 0, 60),
	BackgroundTransparency = 1,
}, loaderCard)

local loaderLogo = new("Frame", {
	Name = "Logo",
	Position = UDim2.new(0, 24, 0.5, -16),
	Size = UDim2.fromOffset(32, 32),
	BackgroundColor3 = BLUE,
	BorderSizePixel = 0,
}, topBar)
corner(loaderLogo, 10)
new("UIGradient", {
	Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, BLUE),
		ColorSequenceKeypoint.new(1, BLUE_DARK),
	}),
	Rotation = 135,
}, loaderLogo)

new("TextLabel", {
	Name = "Mark",
	Size = UDim2.fromScale(1, 1),
	BackgroundTransparency = 1,
	Text = "9",
	Font = Enum.Font.GothamBlack,
	TextSize = 18,
	TextColor3 = Color3.fromRGB(255, 255, 255),
}, loaderLogo)

new("TextLabel", {
	Name = "Title",
	Position = UDim2.new(0, 72, 0.5, -10),
	Size = UDim2.new(0, 200, 0, 20),
	BackgroundTransparency = 1,
	Text = "NINE LOADER",
	Font = Enum.Font.GothamBold,
	TextSize = 16,
	TextColor3 = TEXT_MAIN,
	TextXAlignment = Enum.TextXAlignment.Left,
}, topBar)

local closeBtn = new("TextButton", {
	Name = "CloseButton",
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -24, 0.5, 0),
	Size = UDim2.fromOffset(32, 32),
	BackgroundColor3 = BTN_ALT,
	BorderSizePixel = 0,
	Text = "X",
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	TextColor3 = TEXT_MUTED,
	AutoButtonColor = false,
}, topBar)
corner(closeBtn, 10)
stroke(closeBtn, BORDER, 1)
addFeedback(closeBtn, BTN_ALT, Color3.fromRGB(32, 32, 40))

closeBtn.MouseButton1Click:Connect(function()
	tween(loaderCard, TWEEN_SMOOTH, { BackgroundTransparency = 1 })
	tween(glow, TWEEN_SMOOTH, { ImageTransparency = 1 })
	tween(backdrop, TWEEN_SMOOTH, { BackgroundTransparency = 1 })
	task.wait(0.6)
	gui:Destroy()
end)

new("Frame", {
	Name = "Divider",
	AnchorPoint = Vector2.new(0.5, 1),
	Position = UDim2.new(0.5, 0, 1, 0),
	Size = UDim2.new(1, -48, 0, 1),
	BackgroundColor3 = BORDER,
	BorderSizePixel = 0,
}, topBar)

local bottomBar = new("Frame", {
	Name = "BottomBar",
	AnchorPoint = Vector2.new(0, 1),
	Position = UDim2.new(0, 0, 1, 0),
	Size = UDim2.new(1, 0, 0, 50),
	BackgroundTransparency = 1,
}, loaderCard)

new("Frame", {
	Name = "Divider",
	Position = UDim2.new(0.5, 0, 0, 0),
	AnchorPoint = Vector2.new(0.5, 0),
	Size = UDim2.new(1, -48, 0, 1),
	BackgroundColor3 = BORDER,
	BorderSizePixel = 0,
}, bottomBar)

local keyStatusLabel = new("TextLabel", {
	Name = "KeyStatusLabel",
	Position = UDim2.new(0, 24, 0.5, -7),
	Size = UDim2.new(0, 250, 0, 14),
	BackgroundTransparency = 1,
	Text = "Nine: Ready • Free Access",
	Font = Enum.Font.GothamMedium,
	TextSize = 12,
	TextColor3 = GREEN,
	TextXAlignment = Enum.TextXAlignment.Left,
}, bottomBar)

local settingsBtn = new("TextButton", {
	Name = "SettingsButton",
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -24, 0.5, 0),
	Size = UDim2.fromOffset(80, 28),
	BackgroundColor3 = FIELD,
	BorderSizePixel = 0,
	Text = "Settings",
	Font = Enum.Font.GothamMedium,
	TextSize = 12,
	TextColor3 = TEXT_MUTED,
	AutoButtonColor = false,
}, bottomBar)
corner(settingsBtn, 8)
stroke(settingsBtn, BORDER, 1)
addFeedback(settingsBtn, FIELD, BTN_ALT)

local contentArea = new("Frame", {
	Name = "Content",
	Position = UDim2.new(0, 244, 0, 70),
	Size = UDim2.new(0, 412, 1, -130),
	BackgroundTransparency = 1,
}, loaderCard)

new("TextLabel", {
	Name = "SectionTitle",
	Size = UDim2.new(1, 0, 0, 20),
	BackgroundTransparency = 1,
	Text = "Supported Games",
	Font = Enum.Font.GothamBold,
	TextSize = 14,
	TextColor3 = TEXT_MAIN,
	TextXAlignment = Enum.TextXAlignment.Left,
}, contentArea)

local gameList = new("ScrollingFrame", {
	Name = "GameList",
	Position = UDim2.new(0, 0, 0, 30),
	Size = UDim2.new(1, 0, 1, -30),
	BackgroundTransparency = 1,
	ScrollBarThickness = 4,
	ScrollBarImageColor3 = BORDER,
	BorderSizePixel = 0,
	CanvasSize = UDim2.new(0, 0, 0, 0),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
}, contentArea)

new("UIPadding", {
	PaddingTop = UDim.new(0, 6),
	PaddingBottom = UDim.new(0, 6),
	PaddingLeft = UDim.new(0, 2),
	PaddingRight = UDim.new(0, 2),
}, gameList)

new("UIGridLayout", {
	CellSize = UDim2.new(0, 194, 0, 148),
	CellPadding = UDim2.new(0, 12, 0, 12),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, gameList)

local statusData = {
	stateName = "Operational",
	stateColor = Color3.fromRGB(84, 121, 227),
	desc = "All systems are running normally.",
	version = "-",
	gamesCount = "-",
	liveUsers = "-",
	lastUpdated = "-"
}

local statusPanel = new("Frame", {
	Name = "NineStatusPanel",
	Position = UDim2.new(0, 672, 0, 70),
	Size = UDim2.new(0, 204, 1, -130),
	BackgroundColor3 = BLACK,
	BackgroundTransparency = 0,
	BorderSizePixel = 0,
	ZIndex = 1,
}, loaderCard)
corner(statusPanel, 12)
stroke(statusPanel, Color3.fromRGB(84, 121, 227), 1)

new("TextLabel", {
	Name = "PanelTitle",
	Position = UDim2.new(0, 16, 0, 16),
	Size = UDim2.new(1, -32, 0, 16),
	BackgroundTransparency = 1,
	TextTransparency = 0,
	Text = "NINE STATUS",
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	TextColor3 = Color3.fromRGB(84, 121, 227),
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 3,
}, statusPanel)

local liveDot = new("Frame", {
	Name = "Dot",
	Position = UDim2.new(0, 16, 0, 47),
	Size = UDim2.fromOffset(8, 8),
	BackgroundColor3 = Color3.fromRGB(84, 121, 227),
	BorderSizePixel = 0,
	ZIndex = 3,
}, statusPanel)
corner(liveDot, 4)

new("TextLabel", {
	Name = "StateLabel",
	Position = UDim2.new(0, 32, 0, 44),
	Size = UDim2.new(1, -48, 0, 14),
	BackgroundTransparency = 1,
	TextTransparency = 0,
	Text = statusData.stateName,
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	TextColor3 = Color3.fromRGB(84, 121, 227),
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 3,
}, statusPanel)

new("TextLabel", {
	Name = "DescLabel",
	Position = UDim2.new(0, 32, 0, 62),
	Size = UDim2.new(1, -48, 0, 18),
	BackgroundTransparency = 1,
	TextTransparency = 0,
	Text = statusData.desc,
	Font = Enum.Font.Gotham,
	TextSize = 11,
	TextColor3 = Color3.fromRGB(170, 170, 170),
	TextWrapped = true,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 3,
}, statusPanel)

new("Frame", {
	Name = "InnerDivider",
	Position = UDim2.new(0.5, 0, 0, 92),
	AnchorPoint = Vector2.new(0.5, 0),
	Size = UDim2.new(1, -32, 0, 1),
	BackgroundColor3 = BORDER,
	BorderSizePixel = 0,
	ZIndex = 2,
}, statusPanel)

local function createMetaRow(labelTitle, labelValue, yPos)
	new("TextLabel", {
		Name = labelTitle .. "Key",
		Position = UDim2.new(0, 16, 0, yPos),
		Size = UDim2.new(0.5, -16, 0, 16),
		BackgroundTransparency = 1,
		TextTransparency = 0,
		Text = labelTitle,
		Font = Enum.Font.Gotham,
		TextSize = 11,
		TextColor3 = Color3.fromRGB(170, 170, 170),
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 3,
	}, statusPanel)

	local valueLabel = new("TextLabel", {
		Name = labelTitle .. "Val",
		Position = UDim2.new(0.5, 0, 0, yPos),
		Size = UDim2.new(0.5, -16, 0, 16),
		BackgroundTransparency = 1,
		TextTransparency = 0,
		Text = labelValue,
		Font = Enum.Font.GothamMedium,
		TextSize = 11,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		TextXAlignment = Enum.TextXAlignment.Right,
		ZIndex = 3,
	}, statusPanel)

	return valueLabel
end

local statusValueLabels = {
	version = createMetaRow("Version", statusData.version, 108),
	games = createMetaRow("Games", statusData.gamesCount, 134),
	liveUsers = createMetaRow("Live Users", statusData.liveUsers, 160),
	lastUpdated = createMetaRow("Last Updated", statusData.lastUpdated, 186),
}

local nineCopy

local function loadIconAsset(url, filename)
	local asset = getcustomasset or getsynasset
	if not (writefile and asset) then return nil end
	local ok, data = pcall(function() return game:HttpGet(url) end)
	if not ok or type(data) ~= "string" or #data < 100 then return nil end
	if not pcall(writefile, filename, data) then return nil end
	local ok2, path = pcall(asset, filename)
	if ok2 and type(path) == "string" then return path end
	return nil
end

local discordPanel = new("Frame", {
	Name = "DiscordPanel",
	Position = UDim2.new(0, 20, 0, 70),
	Size = UDim2.new(0, 204, 1, -130),
	BackgroundColor3 = BLACK,
	BorderSizePixel = 0,
}, loaderCard)
corner(discordPanel, 12)
stroke(discordPanel, BLUE, 1)

new("TextLabel", {
	Name = "DiscordMark",
	Position = UDim2.new(0, 16, 0, 14),
	Size = UDim2.fromOffset(36, 30),
	BackgroundColor3 = BLUE,
	BorderSizePixel = 0,
	Text = "D",
	Font = Enum.Font.GothamBlack,
	TextSize = 16,
	TextColor3 = Color3.fromRGB(255, 255, 255),
}, discordPanel)
corner(discordPanel.DiscordMark, 9)

new("TextLabel", {
	Name = "DiscordTitle",
	Position = UDim2.new(0, 62, 0, 20),
	Size = UDim2.new(1, -78, 0, 18),
	BackgroundTransparency = 1,
	Text = "DISCORD",
	Font = Enum.Font.GothamBold,
	TextSize = 12,
	TextColor3 = BLUE,
	TextXAlignment = Enum.TextXAlignment.Left,
}, discordPanel)

local function makeServerBlock(name, letter, iconUrl, iconFile, title, copyText, invite, shortInvite)
	local block = new("Frame", {
		Name = name,
		Size = UDim2.new(1, -24, 0, 118),
		BackgroundColor3 = CARD,
		BorderSizePixel = 0,
	}, discordPanel)
	corner(block, 10)
	stroke(block, BORDER, 1)

	local iconHolder = new("Frame", {
		Name = "IconHolder",
		Position = UDim2.new(0, 12, 0, 12),
		Size = UDim2.fromOffset(40, 40),
		BackgroundColor3 = FIELD,
		BorderSizePixel = 0,
	}, block)
	corner(iconHolder, 10)

	local iconAsset = loadIconAsset(iconUrl, iconFile)
	if iconAsset then
		local img = new("ImageLabel", {
			Name = "Icon",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Image = iconAsset,
			ScaleType = Enum.ScaleType.Crop,
		}, iconHolder)
		corner(img, 10)
	else
		new("TextLabel", {
			Name = "IconFallback",
			Size = UDim2.fromScale(1, 1),
			BackgroundTransparency = 1,
			Text = letter,
			Font = Enum.Font.GothamBlack,
			TextSize = 18,
			TextColor3 = BLUE,
		}, iconHolder)
	end

	new("TextLabel", {
		Name = "Title",
		Position = UDim2.new(0, 62, 0, 14),
		Size = UDim2.new(1, -74, 0, 16),
		BackgroundTransparency = 1,
		Text = title,
		Font = Enum.Font.GothamBold,
		TextSize = 12,
		TextColor3 = TEXT_MAIN,
		TextXAlignment = Enum.TextXAlignment.Left,
	}, block)

	new("TextLabel", {
		Name = "Copy",
		Position = UDim2.new(0, 62, 0, 32),
		Size = UDim2.new(1, -74, 0, 40),
		BackgroundTransparency = 1,
		Text = copyText,
		Font = Enum.Font.Gotham,
		TextSize = 10,
		TextColor3 = TEXT_MUTED,
		TextWrapped = true,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Top,
	}, block)

	local joinBtn = new("TextButton", {
		Name = "Join",
		Position = UDim2.new(0, 12, 1, -40),
		Size = UDim2.new(1, -24, 0, 28),
		BackgroundColor3 = BLUE,
		BorderSizePixel = 0,
		Text = "JOIN",
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		AutoButtonColor = false,
	}, block)
	corner(joinBtn, 8)
	addFeedback(joinBtn, BLUE, Color3.fromHex("#6B8EF0"))

	joinBtn.MouseButton1Click:Connect(function()
		if nineCopy(invite) then
			joinBtn.Text = "INVITE COPIED"
		else
			joinBtn.Text = shortInvite
		end
		task.delay(2, function()
			if joinBtn then joinBtn.Text = "JOIN" end
		end)
	end)

	return block
end

local nineBlock = makeServerBlock(
	"NineBlock", "N", NINE_ICON_URL, "nine_discord_icon.jpg",
	"NINE HUB", "Updates, giveaways, support and sneak peeks.",
	NINE_DISCORD_URL, "discord.gg/tZkuKRZwrB"
)
local lumoreBlock = makeServerBlock(
	"LumoreBlock", "L", LUMORE_ICON_URL, "lumore_discord_icon.png",
	"LUMORE", "Our community for people who make and protect scripts.",
	LUMORE_DISCORD_URL, "discord.gg/4PZUnNqfkN"
)

local compactLoader = false
local function arrangeLoaderPanels()
	local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(800, 600)
	local compact = viewport.X < 820
	if compact == compactLoader then return end
	compactLoader = compact
	if compact then
		LOADER_W, LOADER_H = 680, 590
		loaderCard.Size = UDim2.fromOffset(LOADER_W, LOADER_H)
		discordPanel.Position = UDim2.new(0, 24, 0, 70)
		discordPanel.Size = UDim2.new(1, -48, 0, 130)
		discordPanel.DiscordMark.Visible = false
		discordPanel.DiscordTitle.Visible = false
		nineBlock.Position = UDim2.new(0, 12, 0, 12)
		nineBlock.Size = UDim2.new(0.5, -18, 0, 106)
		lumoreBlock.Position = UDim2.new(0.5, 6, 0, 12)
		lumoreBlock.Size = UDim2.new(0.5, -18, 0, 106)
		contentArea.Position = UDim2.new(0, 24, 0, 220)
		contentArea.Size = UDim2.new(0, 412, 1, -280)
		statusPanel.Position = UDim2.new(0, 452, 0, 220)
		statusPanel.Size = UDim2.new(0, 204, 1, -280)
	else
		LOADER_W, LOADER_H = 920, 440
		loaderCard.Size = UDim2.fromOffset(LOADER_W, LOADER_H)
		discordPanel.Position = UDim2.new(0, 20, 0, 70)
		discordPanel.Size = UDim2.new(0, 204, 1, -130)
		discordPanel.DiscordMark.Visible = true
		discordPanel.DiscordTitle.Visible = true
		nineBlock.Position = UDim2.new(0, 12, 0, 56)
		nineBlock.Size = UDim2.new(1, -24, 0, 118)
		lumoreBlock.Position = UDim2.new(0, 12, 0, 182)
		lumoreBlock.Size = UDim2.new(1, -24, 0, 118)
		contentArea.Position = UDim2.new(0, 244, 0, 70)
		contentArea.Size = UDim2.new(0, 412, 1, -130)
		statusPanel.Position = UDim2.new(0, 672, 0, 70)
		statusPanel.Size = UDim2.new(0, 204, 1, -130)
	end
	fitLoader()
end

compactLoader = not ((workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize.X or 800) < 820)
arrangeLoaderPanels()
if workspace.CurrentCamera then
	workspace.CurrentCamera:GetPropertyChangedSignal("ViewportSize"):Connect(arrangeLoaderPanels)
end

local settingsPanel = new("Frame", {
	Name = "SettingsPanel",
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, 240, 0, 60),
	Size = UDim2.new(0, 228, 1, -110),
	BackgroundColor3 = BLACK,
	BorderSizePixel = 0,
	ZIndex = 10,
}, loaderCard)
corner(settingsPanel, 12)
stroke(settingsPanel, BLUE, 1)

local settingsHeader = new("Frame", {
	Name = "Header",
	Size = UDim2.new(1, 0, 0, 36),
	BackgroundTransparency = 1,
	ZIndex = 11,
}, settingsPanel)

new("TextLabel", {
	Name = "Title",
	Position = UDim2.new(0, 14, 0, 10),
	Size = UDim2.new(0, 100, 0, 16),
	BackgroundTransparency = 1,
	Text = "SETTINGS",
	Font = Enum.Font.GothamBold,
	TextSize = 11,
	TextColor3 = BLUE,
	TextXAlignment = Enum.TextXAlignment.Left,
	ZIndex = 11,
}, settingsHeader)

local settingsBackBtn = new("TextButton", {
	Name = "BackButton",
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -10, 0.5, 0),
	Size = UDim2.fromOffset(48, 22),
	BackgroundColor3 = BTN_ALT,
	BorderSizePixel = 0,
	Text = "Back",
	Font = Enum.Font.GothamMedium,
	TextSize = 11,
	TextColor3 = TEXT_MUTED,
	AutoButtonColor = false,
	ZIndex = 11,
}, settingsHeader)
corner(settingsBackBtn, 6)
stroke(settingsBackBtn, BORDER, 1)
addFeedback(settingsBackBtn, BTN_ALT, Color3.fromRGB(32, 32, 40))

new("Frame", {
	Name = "HeaderDivider",
	Position = UDim2.new(0.5, 0, 1, -1),
	AnchorPoint = Vector2.new(0.5, 0),
	Size = UDim2.new(1, -24, 0, 1),
	BackgroundColor3 = BORDER,
	BorderSizePixel = 0,
	ZIndex = 11,
}, settingsHeader)

local settingsContainer = new("Frame", {
	Name = "Container",
	Position = UDim2.new(0, 12, 0, 42),
	Size = UDim2.new(1, -24, 1, -48),
	BackgroundTransparency = 1,
	ZIndex = 11,
}, settingsPanel)

new("UIListLayout", {
	SortOrder = Enum.SortOrder.LayoutOrder,
	Padding = UDim.new(0, 10),
}, settingsContainer)

local function createSettingRow(titleText, layoutOrder)
	local row = new("Frame", {
		Name = titleText .. "Row",
		Size = UDim2.new(1, 0, 0, 32),
		BackgroundTransparency = 1,
		LayoutOrder = layoutOrder,
		ZIndex = 11,
	}, settingsContainer)

	new("TextLabel", {
		Name = "Label",
		Position = UDim2.new(0, 0, 0.5, -8),
		Size = UDim2.new(0.62, 0, 0, 16),
		BackgroundTransparency = 1,
		Text = titleText,
		Font = Enum.Font.GothamMedium,
		TextSize = 11,
		TextColor3 = TEXT_MAIN,
		TextXAlignment = Enum.TextXAlignment.Left,
		ZIndex = 11,
	}, row)

	return row
end

local function createToggle(parentRow, initialValue)
	local toggleBtn = new("TextButton", {
		Name = "Toggle",
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(48, 22),
		BackgroundColor3 = FIELD,
		BorderSizePixel = 0,
		Text = initialValue and "ON" or "OFF",
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		TextColor3 = initialValue and BLUE or TEXT_MUTED,
		AutoButtonColor = false,
		ZIndex = 11,
	}, parentRow)
	corner(toggleBtn, 6)
	local toggleStroke = stroke(toggleBtn, initialValue and BLUE or BORDER, 1)
	return toggleBtn, toggleStroke
end

local rowAutoDetect = createSettingRow("Auto Detect", 1)
local autoDetectBtn, autoDetectStroke = createToggle(rowAutoDetect, settingsData.autoGameDetect)

local rowAnim = createSettingRow("Animations", 2)
local animBtn, animStroke = createToggle(rowAnim, settingsData.animations)

local rowScale = createSettingRow("UI Scale", 3)
local scaleSegmentFrame = new("Frame", {
	Name = "ScaleSegment",
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, 0, 0.5, 0),
	Size = UDim2.fromOffset(102, 22),
	BackgroundTransparency = 1,
	ZIndex = 11,
}, rowScale)

local scaleButtons = {}
local scaleOptions = { "Small", "Normal", "Large" }
for idx, opt in ipairs(scaleOptions) do
	local sBtn = new("TextButton", {
		Name = opt .. "Btn",
		Position = UDim2.new((idx - 1) * 0.34, 0, 0, 0),
		Size = UDim2.new(0.32, 0, 1, 0),
		BackgroundColor3 = (settingsData.uiScaleOption == opt) and BLUE or FIELD,
		BorderSizePixel = 0,
		Text = opt:sub(1, 1),
		Font = Enum.Font.GothamBold,
		TextSize = 10,
		TextColor3 = (settingsData.uiScaleOption == opt) and Color3.fromRGB(255, 255, 255) or TEXT_MUTED,
		AutoButtonColor = false,
		ZIndex = 11,
	}, scaleSegmentFrame)
	corner(sBtn, 5)
	stroke(sBtn, BORDER, 1)
	scaleButtons[opt] = sBtn
end

local rowKeyInfo = createSettingRow("Show Status", 4)
local keyInfoBtn, keyInfoStroke = createToggle(rowKeyInfo, settingsData.showKeyInfo)

local resetBtn = new("TextButton", {
	Name = "ResetSettings",
	Size = UDim2.new(1, 0, 0, 26),
	BackgroundColor3 = BTN_ALT,
	BorderSizePixel = 0,
	Text = "Reset Settings",
	Font = Enum.Font.GothamMedium,
	TextSize = 11,
	TextColor3 = RED,
	AutoButtonColor = false,
	LayoutOrder = 5,
	ZIndex = 11,
}, settingsContainer)
corner(resetBtn, 6)
stroke(resetBtn, BORDER, 1)
addFeedback(resetBtn, BTN_ALT, Color3.fromRGB(32, 32, 40))

local gameCardElements = {}
local nineRuntimeSession = nil
local nineBootstrapData = nil
local nineLoadGames
local nineFetchScript
local gamesFetched = false

local gamesNotice = new("TextLabel", {
	Name = "GamesNotice",
	Position = UDim2.new(0, 0, 0, 30),
	Size = UDim2.new(1, 0, 0, 20),
	BackgroundTransparency = 1,
	Text = "Loading games...",
	Font = Enum.Font.GothamMedium,
	TextSize = 12,
	TextColor3 = TEXT_MUTED,
	TextXAlignment = Enum.TextXAlignment.Left,
}, contentArea)

local function checkAutoGameDetection()
	for _, item in ipairs(gameCardElements) do
		local isMatch = settingsData.autoGameDetect and (item.data.placeId == game.PlaceId or item.data.placeId == game.GameId)
		if isMatch then
			tween(item.stroke, TWEEN_FAST, { Color = BLUE, Thickness = 2 })
			item.badge.Visible = true
		else
			tween(item.stroke, TWEEN_FAST, { Color = BORDER, Thickness = 1 })
			item.badge.Visible = false
		end
	end
end

local function applySettingsToUI()
	autoDetectBtn.Text = settingsData.autoGameDetect and "ON" or "OFF"
	autoDetectBtn.TextColor3 = settingsData.autoGameDetect and BLUE or TEXT_MUTED
	autoDetectStroke.Color = settingsData.autoGameDetect and BLUE or BORDER
	checkAutoGameDetection()

	animBtn.Text = settingsData.animations and "ON" or "OFF"
	animBtn.TextColor3 = settingsData.animations and BLUE or TEXT_MUTED
	animStroke.Color = settingsData.animations and BLUE or BORDER

	for optName, sBtnObj in pairs(scaleButtons) do
		if settingsData.uiScaleOption == optName then
			sBtnObj.BackgroundColor3 = BLUE
			sBtnObj.TextColor3 = Color3.fromRGB(255, 255, 255)
		else
			sBtnObj.BackgroundColor3 = FIELD
			sBtnObj.TextColor3 = TEXT_MUTED
		end
	end
	fitLoader()

	keyInfoBtn.Text = settingsData.showKeyInfo and "ON" or "OFF"
	keyInfoBtn.TextColor3 = settingsData.showKeyInfo and BLUE or TEXT_MUTED
	keyInfoStroke.Color = settingsData.showKeyInfo and BLUE or BORDER
	keyStatusLabel.Visible = settingsData.showKeyInfo
end

autoDetectBtn.MouseButton1Click:Connect(function()
	settingsData.autoGameDetect = not settingsData.autoGameDetect
	applySettingsToUI()
end)

animBtn.MouseButton1Click:Connect(function()
	settingsData.animations = not settingsData.animations
	applySettingsToUI()
end)

for optName, sBtnObj in pairs(scaleButtons) do
	sBtnObj.MouseButton1Click:Connect(function()
		settingsData.uiScaleOption = optName
		applySettingsToUI()
	end)
end

keyInfoBtn.MouseButton1Click:Connect(function()
	settingsData.showKeyInfo = not settingsData.showKeyInfo
	applySettingsToUI()
end)

resetBtn.MouseButton1Click:Connect(function()
	settingsData.autoGameDetect = defaultSettings.autoGameDetect
	settingsData.animations     = defaultSettings.animations
	settingsData.uiScaleOption  = defaultSettings.uiScaleOption
	settingsData.showKeyInfo    = defaultSettings.showKeyInfo
	applySettingsToUI()
end)

local isSettingsOpen = false
local function toggleSettingsPanel(open)
	isSettingsOpen = open
	if open then
		tween(settingsPanel, TWEEN_SMOOTH, { Position = UDim2.new(1, -12, 0, 60) })
	else
		tween(settingsPanel, TWEEN_SMOOTH, { Position = UDim2.new(1, 240, 0, 60) })
	end
end

settingsBtn.MouseButton1Click:Connect(function()
	toggleSettingsPanel(not isSettingsOpen)
end)

settingsBackBtn.MouseButton1Click:Connect(function()
	toggleSettingsPanel(false)
end)

local function createGameCard(data, order)
	local gCard = new("Frame", {
		Name = data.name,
		BackgroundColor3 = FIELD,
		BorderSizePixel = 0,
		LayoutOrder = order,
	}, gameList)
	corner(gCard, 10)
	local gStroke = stroke(gCard, BORDER, 1)

	local detectedBadge = new("TextLabel", {
		Name = "DetectedBadge",
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -8, 0, 8),
		Size = UDim2.new(0, 58, 0, 14),
		BackgroundColor3 = BLUE,
		BorderSizePixel = 0,
		Text = "DETECTED",
		Font = Enum.Font.GothamBold,
		TextSize = 8,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		Visible = false,
		ZIndex = 3,
	}, gCard)
	corner(detectedBadge, 4)

	local gameIcon = new("ImageLabel", {
		Name = "GameIcon",
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 8),
		Size = UDim2.new(1, -16, 0, 78),
		BackgroundColor3 = BTN_ALT,
		BackgroundTransparency = 0,
		Image = "",
		ScaleType = Enum.ScaleType.Crop,
		ClipsDescendants = true,
	}, gCard)
	corner(gameIcon, 10)

	task.spawn(function()
		local universeId = data.universeId
		if not universeId then
			local success, info = pcall(function()
				return MarketplaceService:GetProductInfo(data.placeId, Enum.InfoType.Asset)
			end)
			if success and info and info.UniverseId and info.UniverseId ~= 0 then
				universeId = info.UniverseId
			end
		end

		if universeId then
			gameIcon.Image = "rbxthumb://type=GameIcon&id=" .. tostring(universeId) .. "&w=150&h=150"
		else
			gameIcon.Image = "rbxthumb://type=Asset&id=" .. tostring(data.placeId) .. "&w=150&h=150"
		end
	end)

	new("TextLabel", {
		Name = "Name",
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.new(0.5, 0, 0, 92),
		Size = UDim2.new(1, -16, 0, 16),
		BackgroundTransparency = 1,
		Text = data.name,
		Font = Enum.Font.GothamBold,
		TextSize = 13,
		TextColor3 = TEXT_MAIN,
		TextTruncate = Enum.TextTruncate.AtEnd,
		TextXAlignment = Enum.TextXAlignment.Center,
	}, gCard)

	local loadBtn = new("TextButton", {
		Name = "LoadButton",
		AnchorPoint = Vector2.new(0.5, 1),
		Position = UDim2.new(0.5, 0, 1, -10),
		Size = UDim2.new(1, -20, 0, 28),
		BackgroundColor3 = BLUE,
		BorderSizePixel = 0,
		Text = "Load",
		Font = Enum.Font.GothamBold,
		TextSize = 11,
		TextColor3 = Color3.fromRGB(255, 255, 255),
		AutoButtonColor = false,
	}, gCard)
	corner(loadBtn, 6)

	local btnGradient = new("UIGradient", {
		Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromHex("#6B8EF0")),
			ColorSequenceKeypoint.new(1, BLUE_DARK),
		}),
		Rotation = 90,
	}, loadBtn)

	addFeedback(loadBtn, BLUE, Color3.fromHex("#6B8EF0"))

	if data.status == "disabled" then
		loadBtn.Text = "Disabled"
		loadBtn.Active = false
		loadBtn.AutoButtonColor = false
		loadBtn.BackgroundColor3 = BTN_ALT
		loadBtn.TextColor3 = TEXT_MUTED
		btnGradient.Enabled = false
	end

	loadBtn.MouseButton1Click:Connect(function()
		if not loadBtn.Active then return end
		if data.status ~= "active" or type(data.gameId) ~= "string" then return end
		loadBtn.Active = false
		loadBtn.Text = "Loading..."
		tween(loadBtn, TWEEN_FAST, { BackgroundColor3 = AMBER })
		btnGradient.Enabled = false

		task.spawn(function()
			local source, reason = nineFetchScript(data.gameId)
			if type(source) ~= "string" or source == "" then
				loadBtn.Text = (reason == "error") and "Network error" or "Unavailable"
				tween(loadBtn, TWEEN_FAST, { BackgroundColor3 = BTN_ALT })
				task.wait(2)
				loadBtn.Text = "Load"
				loadBtn.BackgroundColor3 = BLUE
				btnGradient.Enabled = true
				loadBtn.Active = true
				return
			end

			local chunk = loadstring(source)
			if gui then gui:Destroy() end
			if chunk then
				task.spawn(function() pcall(chunk) end)
			else
				warn("[Nine] Invalid loadstring for " .. tostring(data.name))
			end
		end)
	end)

	table.insert(gameCardElements, {
		data = data,
		frame = gCard,
		stroke = gStroke,
		badge = detectedBadge,
	})
end

local function prepareLoaderVisually()
	loaderCard.Position = UDim2.new(0.5, 0, 0.54, 0)
	loaderCard.BackgroundTransparency = 1
	for _, d in ipairs(loaderCard:GetDescendants()) do
		if d:IsA("TextLabel") or d:IsA("TextButton") then
			d.TextTransparency = 1
			d.BackgroundTransparency = 1
		elseif d:IsA("ImageLabel") then
			d.ImageTransparency = 1
		elseif d:IsA("Frame") then
			d.BackgroundTransparency = 1
		elseif d:IsA("UIStroke") then
			d.Transparency = 1
		end
	end
end
prepareLoaderVisually()

local function showLoader()
	loaderCard.Visible = true
	tween(backdrop, TWEEN_SMOOTH, { BackgroundTransparency = 0 })
	tween(glow, TWEEN_SMOOTH, { Size = UDim2.fromOffset(840, 840), ImageTransparency = 0.8 })
	tween(loaderCard, TWEEN_SMOOTH, { Position = UDim2.fromScale(0.5, 0.5), BackgroundTransparency = 0 })

	for _, d in ipairs(loaderCard:GetDescendants()) do
		if d:IsA("TextLabel") or d:IsA("TextButton") then
			tween(d, TWEEN_SMOOTH, { TextTransparency = 0, BackgroundTransparency = (d.Name == "CloseButton" or d.Name == "SettingsButton" or d.Name == "LoadButton" or d.Name == "BackButton" or d.Name == "ResetSettings" or d.Name == "Toggle" or d.Name == "SmallBtn" or d.Name == "NormalBtn" or d.Name == "LargeBtn" or d.Name == "DetectedBadge" or d.Name == "Join") and 0 or 1 })
		elseif d:IsA("ImageLabel") then
			tween(d, TWEEN_SMOOTH, { ImageTransparency = 0 })
		elseif d:IsA("Frame") and d.Name ~= "TopBar" and d.Name ~= "BottomBar" and d.Name ~= "Content" and d.Name ~= "NineStatusPanel" and d.Name ~= "DiscordPanel" and d.Name ~= "Header" and d.Name ~= "Container" and d.Name ~= "ScaleSegment" and d.Name ~= "Auto DetectRow" and d.Name ~= "AnimationsRow" and d.Name ~= "UI ScaleRow" and d.Name ~= "Show StatusRow" and d.Name ~= "NineBlock" and d.Name ~= "LumoreBlock" and d.Name ~= "IconHolder" then
			tween(d, TWEEN_SMOOTH, { BackgroundTransparency = 0 })
		elseif d:IsA("UIStroke") then
			tween(d, TWEEN_SMOOTH, { Transparency = 0 })
		end
	end
	applySettingsToUI()
	if nineLoadGames then nineLoadGames() end
end

local HttpService = game:GetService("HttpService")

local function nineRequest(url, body)
	local req = (syn and syn.request) or (http and http.request) or http_request or request
	if not req then return nil, "no_http" end
	local ok, res = pcall(req, {
		Url = url,
		Method = "POST",
		Headers = { ["Content-Type"] = "application/json" },
		Body = HttpService:JSONEncode(body),
	})
	if not ok or type(res) ~= "table" or not res.Body then return nil, "request_failed" end
	local decoded
	ok, decoded = pcall(function() return HttpService:JSONDecode(res.Body) end)
	if not ok or type(decoded) ~= "table" then return nil, "bad_response" end
	return decoded
end

local function nineDeviceId()
	local ok, id = pcall(function()
		return game:GetService("RbxAnalyticsService"):GetClientId()
	end)
	if ok and type(id) == "string" and #id >= 4 then return id end
	return tostring(player.UserId)
end

nineFetchScript = function(gameId)
	if not nineRuntimeSession or type(gameId) ~= "string" then return nil, "unauthorized" end
	local res, err = nineRequest(NINE_SCRIPT_URL, {
		session = nineRuntimeSession,
		game_id = gameId,
	})
	if not res then return nil, err or "error" end
	if res.status ~= "valid" or type(res.source) ~= "string" or res.source == "" then
		return nil, tostring(res.reason or res.status or "unavailable")
	end
	return res.source
end

nineLoadGames = function()
	if gamesFetched then return end
	gamesFetched = true
	local res = nineBootstrapData
	if not res or res.status ~= "ready" or type(res.games) ~= "table" then
		gamesNotice.Text = "Could not load games. Run Nine again to retry."
		gamesNotice.TextColor3 = AMBER
		return
	end

	local order = 0
	for _, g in ipairs(res.games) do
		local placeId = tonumber(g.place_id)
		if type(g.name) == "string" and placeId then
			order = order + 1
			createGameCard({
				name = g.name,
				gameId = tostring(g.id),
				placeId = placeId,
				universeId = tonumber(g.universe_id),
				status = (g.status == "disabled") and "disabled" or "active",
			}, order)
		end
	end

	if order == 0 then
		gamesNotice.Text = "No games available yet."
		gamesNotice.TextColor3 = TEXT_MUTED
	else
		gamesNotice.Visible = false
	end

	local status = res.nine_status
	if type(status) == "table" then
		if type(status.version) == "string" then statusValueLabels.version.Text = status.version end
		if tonumber(status.games) then statusValueLabels.games.Text = tostring(status.games) .. " Available" end
		if tonumber(status.live_users) then statusValueLabels.liveUsers.Text = tostring(status.live_users) end
		if type(status.last_updated) == "string" and #status.last_updated >= 10 then
			statusValueLabels.lastUpdated.Text = string.sub(status.last_updated, 1, 10)
		end
	end
	checkAutoGameDetection()
end

local nineHeartbeatStarted = false
local function nineStartHeartbeat()
	if nineHeartbeatStarted then return end
	nineHeartbeatStarted = true
	task.spawn(function()
		while nineRuntimeSession do
			pcall(function()
				nineRequest(NINE_HEARTBEAT_URL, { session = nineRuntimeSession })
			end)
			task.wait(60)
		end
	end)
end

nineCopy = function(text)
	local fn = setclipboard or toclipboard or (Clipboard and Clipboard.set)
	if fn then
		local ok = pcall(fn, text)
		return ok
	end
	return false
end

local function nineTryAutoExecute()
	if game.PlaceId ~= NINE_AUTOEXEC_PLACE_ID then
		return false
	end

	local res = nineBootstrapData
	if not res or type(res.games) ~= "table" then
		return false
	end

	for _, g in ipairs(res.games) do
		local placeId = tonumber(g.place_id)
		local isDisabled = (g.status == "disabled")
		if placeId == NINE_AUTOEXEC_PLACE_ID and not isDisabled then
			local gameId = tostring(g.id)
			local source, reason = nineFetchScript(gameId)
			if type(source) == "string" and source ~= "" then
				if gui then gui:Destroy() end
				local chunk = loadstring(source)
				if chunk then
					task.spawn(function() pcall(chunk) end)
					return true
				end
				warn("[Nine] Auto-exec produced an invalid loadstring.")
				return false
			end
			warn("[Nine] Auto-exec failed for Steal an Egg: " .. tostring(reason))
			return false
		end
	end

	return false
end

local nineInitializing = false
local function nineInitialize()
	if nineInitializing then return end
	nineInitializing = true

	task.spawn(function()
		local res = nineRequest(NINE_BOOTSTRAP_URL, {})

		if res and res.status == "ready" and type(res.session) == "string" and type(res.games) == "table" then
			nineRuntimeSession = res.session
			nineBootstrapData = res
			nineStartHeartbeat()

			if nineTryAutoExecute() then
				return
			end
		else
			nineBootstrapData = { status = "failed", games = {} }
		end

		showLoader()
	end)
end

task.defer(nineInitialize)