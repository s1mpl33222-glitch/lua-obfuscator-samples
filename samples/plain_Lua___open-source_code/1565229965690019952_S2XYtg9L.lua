--// إعدادات الضب - لوحة تحكم عصرية
--// سكربت محلي كامل (LocalScript)
--// T = تشغيل/إيقاف الاستهداف
--// K = تشغيل/إيقاف المشي ضد الخمول
--// Insert = إظهار/إخفاء اللوحة

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Lighting = game:GetService("Lighting")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local Wild = workspace:WaitForChild("DhabWild")
local Event = ReplicatedStorage:WaitForChild("Dhab"):WaitForChild("Event")

--==================================================
-- الإعدادات
--==================================================

local TOGGLE_KEY = Enum.KeyCode.T
local PANEL_KEY = Enum.KeyCode.Insert
local WALK_KEY = Enum.KeyCode.K

-- المشي ضد الخمول
local IDLE_TIMEOUT = 40          -- ثوانٍ بدون ضب في النطاق أثناء الوقوف
local RETURN_DELAY = 1.5         -- ثوانٍ لترك الاستهداف يطلق قبل العودة (0 = فورًا)
local MAX_WALK_TIME = 120        -- الاستسلام والعودة للمكان الأصلي بعد هذا العدد من الثواني
local STUCK_CHECK_INTERVAL = 1.5 -- كل كم ثانية يُفحص إن كان المشي معرقلًا
local STUCK_DISTANCE = 2         -- أقل من هذه المسافة = عالق، يلتف 90 درجة

local FIRE_INTERVAL = 0.5
local MAX_DISTANCE = 1000
local MIN_AIM_DISTANCE = 25
local MAX_AIM_DISTANCE = 2000
local AIM_LOWER_AMOUNT = 0.3

local FLICKER_WINDOW = 3
local REQUIRED_SWITCHES = 4
local NEEDS_ALERT_COOLDOWN = 5

local HIGHLIGHT_DISTANCE = math.huge
local HIGHLIGHT_UPDATE_INTERVAL = 0.1

local MIN_FOV = 30
local MAX_FOV = 120
local MIN_ZOOM = 0.5
local MAX_ZOOM = 100000

local VEHICLE_ZOOM_STEP = 5
local MAX_VEHICLE_ZOOM_OUT = 200
local vehicleZoomOffset = 0

local TIER_COLORS = {
	T1 = Color3.fromRGB(128, 128, 128),
	T2 = Color3.fromRGB(0, 255, 0),
	T3 = Color3.fromRGB(100, 200, 255),
	T4 = Color3.fromRGB(170, 0, 255),
	T5 = Color3.fromRGB(255, 255, 0),
	T6 = Color3.fromRGB(255, 0, 0),
}

--==================================================
-- تنظيف التشغيل السابق
--==================================================

if _G.DhabAimCleanup then
	pcall(_G.DhabAimCleanup)
end

RunService:UnbindFromRenderStep("PersistentDhabCamera")

local connections = {}
local needsConnections = {}
local needsGeneration = 0

local aiming = false
local lowNeeds = false
local brightLighting = false
local highlightEnabled = false

local activeHighlights = {}
local lastHighlightUpdate = 0
local fireTimer = 0

local autoWalkEnabled = false
local targetVisible = false -- تحدده حلقة الاستهداف: يوجد ضب في النطاق ويمكن الوصول إليه
local idleTimer = 0         -- ثوانٍ بدون هدف وبدون حركة

local camera = workspace.CurrentCamera
local originalFOV = camera and camera.FieldOfView or 70
local currentFOV = originalFOV

local originalMinZoom = player.CameraMinZoomDistance
local originalMaxZoom = player.CameraMaxZoomDistance

local function addConnection(connection, list)
	table.insert(list, connection)
	return connection
end

--==================================================
-- الإضاءة
--==================================================

local originalLighting = {
	Brightness = Lighting.Brightness,
	ClockTime = Lighting.ClockTime,
	GlobalShadows = Lighting.GlobalShadows,
	Ambient = Lighting.Ambient,
	OutdoorAmbient = Lighting.OutdoorAmbient,
	ExposureCompensation = Lighting.ExposureCompensation,
	ColorShift_Top = Lighting.ColorShift_Top,
	ColorShift_Bottom = Lighting.ColorShift_Bottom,
	FogColor = Lighting.FogColor,
	FogStart = Lighting.FogStart,
	FogEnd = Lighting.FogEnd,
}

local storedLighting = Instance.new("Folder")
storedLighting.Name = "StoredDhabLighting"

local function storeLightingEffects()
	for _, effect in ipairs(Lighting:GetChildren()) do
		if effect:IsA("PostEffect")
			or effect:IsA("Atmosphere")
			or effect:IsA("Sky") then
			effect.Parent = storedLighting
		end
	end
end

local function restoreLighting()
	for property, value in pairs(originalLighting) do
		pcall(function()
			Lighting[property] = value
		end)
	end

	for _, effect in ipairs(storedLighting:GetChildren()) do
		effect.Parent = Lighting
	end
end

local function applyBrightLighting()
	storeLightingEffects()

	Lighting.Brightness = 3
	Lighting.ClockTime = 14
	Lighting.GlobalShadows = false
	Lighting.Ambient = Color3.fromRGB(200, 200, 200)
	Lighting.OutdoorAmbient = Color3.fromRGB(200, 200, 200)
	Lighting.ExposureCompensation = 0.3
	Lighting.FogStart = 0
	Lighting.FogEnd = 100000
end

--==================================================
-- إعدادات الكاميرا
--==================================================

local function applyCameraSettings()
	player.CameraMinZoomDistance = MIN_ZOOM
	player.CameraMaxZoomDistance = MAX_ZOOM

	local currentCamera = workspace.CurrentCamera
	if currentCamera then
		currentCamera.FieldOfView = currentFOV
	end
end

addConnection(UserInputService.InputChanged:Connect(function(input)
	if input.UserInputType ~= Enum.UserInputType.MouseWheel then
		return
	end

	local currentCamera = workspace.CurrentCamera

	if not currentCamera
		or currentCamera.CameraType ~= Enum.CameraType.Scriptable then
		return
	end

	vehicleZoomOffset = math.clamp(
		vehicleZoomOffset - input.Position.Z * VEHICLE_ZOOM_STEP,
		0,
		MAX_VEHICLE_ZOOM_OUT
	)
end), connections)

--==================================================
-- دوال مساعدة للواجهة
--==================================================

local COLORS = {
	Background = Color3.fromRGB(16, 17, 23),
	Sidebar = Color3.fromRGB(20, 21, 29),
	Card = Color3.fromRGB(27, 29, 39),
	CardHover = Color3.fromRGB(36, 38, 50),
	Border = Color3.fromRGB(47, 49, 64),
	Accent = Color3.fromRGB(105, 112, 255),
	AccentDark = Color3.fromRGB(67, 72, 180),
	Text = Color3.fromRGB(242, 243, 250),
	Muted = Color3.fromRGB(150, 153, 174),
	Green = Color3.fromRGB(63, 200, 133),
	Red = Color3.fromRGB(230, 82, 95),
	Track = Color3.fromRGB(53, 55, 71),
}

local function create(className, properties, parent)
	local object = Instance.new(className)

	for property, value in pairs(properties) do
		object[property] = value
	end

	object.Parent = parent
	return object
end

local function round(object, radius)
	create("UICorner", {
		CornerRadius = UDim.new(0, radius or 10),
	}, object)
end

local function stroke(object, color, transparency)
	create("UIStroke", {
		Color = color or COLORS.Border,
		Transparency = transparency or 0,
		Thickness = 1,
	}, object)
end

local function makeLabel(parent, text, size, position, fontSize, color)
	return create("TextLabel", {
		Size = size,
		Position = position,
		BackgroundTransparency = 1,
		Text = text,
		TextColor3 = color or COLORS.Text,
		TextSize = fontSize or 13,
		Font = Enum.Font.Gotham,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
	}, parent)
end

--==================================================
-- النافذة الرئيسية
--==================================================

local gui = create("ScreenGui", {
	Name = "DhabSettings",
	ResetOnSpawn = false,
	DisplayOrder = 100,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
}, playerGui)

local main = create("Frame", {
	Name = "Main",
	Size = UDim2.fromOffset(650, 455),
	Position = UDim2.new(0.5, -325, 0.5, -227),
	BackgroundColor3 = COLORS.Background,
	BorderSizePixel = 0,
	ClipsDescendants = true,
}, gui)

round(main, 14)
stroke(main, COLORS.Border, 0.15)

local topbar = create("Frame", {
	Name = "Topbar",
	Size = UDim2.new(1, 0, 0, 58),
	BackgroundColor3 = COLORS.Sidebar,
	BorderSizePixel = 0,
}, main)

local logo = create("Frame", {
	Size = UDim2.fromOffset(34, 34),
	Position = UDim2.fromOffset(16, 12),
	BackgroundColor3 = COLORS.Accent,
	BorderSizePixel = 0,
}, topbar)

round(logo, 10)

local logoLabel = makeLabel(
	logo,
	"ض",
	UDim2.fromScale(1, 1),
	UDim2.fromOffset(0, 0),
	20,
	Color3.new(1, 1, 1)
)
logoLabel.TextXAlignment = Enum.TextXAlignment.Center
logoLabel.Font = Enum.Font.GothamBold

local appTitle = makeLabel(
	topbar,
	"Oaky",
	UDim2.fromOffset(180, 24),
	UDim2.fromOffset(60, 7),
	16,
	COLORS.Text
)
appTitle.Font = Enum.Font.GothamBold

makeLabel(
	topbar,
	"الإعدادات  /  عميل محلي",
	UDim2.fromOffset(240, 17),
	UDim2.fromOffset(60, 30),
	9,
	COLORS.Muted
)

local statusDot = create("Frame", {
	Size = UDim2.fromOffset(7, 7),
	Position = UDim2.new(1, -125, 0, 25),
	BackgroundColor3 = COLORS.Green,
	BorderSizePixel = 0,
}, topbar)
round(statusDot, 10)

makeLabel(
	topbar,
	"جاهز",
	UDim2.fromOffset(50, 20),
	UDim2.new(1, -112, 0, 19),
	10,
	COLORS.Muted
)

local minimizeButton = create("TextButton", {
	Size = UDim2.fromOffset(30, 30),
	Position = UDim2.new(1, -76, 0, 14),
	BackgroundColor3 = COLORS.Card,
	Text = "—",
	TextColor3 = COLORS.Text,
	TextSize = 18,
	Font = Enum.Font.GothamBold,
	AutoButtonColor = true,
}, topbar)
round(minimizeButton, 8)

local closeButton = create("TextButton", {
	Size = UDim2.fromOffset(30, 30),
	Position = UDim2.new(1, -38, 0, 14),
	BackgroundColor3 = Color3.fromRGB(70, 36, 47),
	Text = "×",
	TextColor3 = COLORS.Red,
	TextSize = 21,
	Font = Enum.Font.Gotham,
	AutoButtonColor = true,
}, topbar)
round(closeButton, 8)

local sidebar = create("Frame", {
	Name = "Sidebar",
	Size = UDim2.new(0, 155, 1, -58),
	Position = UDim2.fromOffset(0, 58),
	BackgroundColor3 = COLORS.Sidebar,
	BorderSizePixel = 0,
}, main)

local sidebarHeader = makeLabel(
	sidebar,
	"مساحة العمل",
	UDim2.new(1, -24, 0, 25),
	UDim2.fromOffset(12, 12),
	10,
	COLORS.Muted
)
sidebarHeader.Font = Enum.Font.GothamBold

local navContainer = create("Frame", {
	Size = UDim2.new(1, -16, 0, 220),
	Position = UDim2.fromOffset(8, 43),
	BackgroundTransparency = 1,
}, sidebar)

create("UIListLayout", {
	Padding = UDim.new(0, 6),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, navContainer)

local footer = makeLabel(
	sidebar,
	"أدوات الضب",
	UDim2.new(1, -24, 0, 24),
	UDim2.new(0, 12, 1, -35),
	9,
	COLORS.Muted
)
footer.Font = Enum.Font.GothamBold

local content = create("Frame", {
	Name = "Content",
	Size = UDim2.new(1, -155, 1, -58),
	Position = UDim2.fromOffset(155, 58),
	BackgroundTransparency = 1,
}, main)

local pageHeader = makeLabel(
	content,
	"الاستهداف",
	UDim2.new(1, -36, 0, 30),
	UDim2.fromOffset(20, 15),
	22,
	COLORS.Text
)
pageHeader.Font = Enum.Font.GothamBold

local pageSubtitle = makeLabel(
	content,
	"إعدادات الاستهداف ونطاق الكشف.",
	UDim2.new(1, -36, 0, 24),
	UDim2.fromOffset(20, 44),
	11,
	COLORS.Muted
)

--==================================================
-- السحب / التصغير / الإغلاق
--==================================================

local draggingWindow = false
local dragStart
local startPosition

addConnection(topbar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingWindow = true
		dragStart = input.Position
		startPosition = main.Position
	end
end), connections)

addConnection(UserInputService.InputChanged:Connect(function(input)
	if draggingWindow
		and input.UserInputType == Enum.UserInputType.MouseMovement then

		local delta = input.Position - dragStart

		main.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end
end), connections)

addConnection(UserInputService.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingWindow = false
	end
end), connections)

local minimized = false
local hidden = false

addConnection(minimizeButton.MouseButton1Click:Connect(function()
	minimized = not minimized
	sidebar.Visible = not minimized
	content.Visible = not minimized

	main.Size = minimized
		and UDim2.fromOffset(650, 58)
		or UDim2.fromOffset(650, 455)

	minimizeButton.Text = minimized and "+" or "—"
end), connections)

addConnection(closeButton.MouseButton1Click:Connect(function()
	hidden = true
	main.Visible = false
end), connections)

--==================================================
-- الصفحات والتنقل
--==================================================

local pages = {}
local navButtons = {}

local pageDescriptions = {
	Aiming = "إعدادات الاستهداف ونطاق الكشف.",
	Visuals = "تخصيص تمييز الضب وأسمائها.",
	Environment = "إدارة الإضاءة وتنبيهات الاحتياجات.",
	Camera = "ضبط مجال الرؤية وإعدادات الكاميرا.",
}

local pageTitles = {
	Aiming = "الاستهداف",
	Visuals = "المرئيات",
	Environment = "البيئة",
	Camera = "الكاميرا",
}

local function switchPage(name)
	for pageName, page in pairs(pages) do
		page.Visible = pageName == name
	end

	for pageName, button in pairs(navButtons) do
		local selected = pageName == name

		button.BackgroundColor3 = selected
			and COLORS.AccentDark
			or COLORS.Sidebar

		button.TextColor3 = selected
			and COLORS.Text
			or COLORS.Muted
	end

	pageHeader.Text = pageTitles[name] or name
	pageSubtitle.Text = pageDescriptions[name] or ""
end

for index, name in ipairs({
	"Aiming",
	"Visuals",
	"Environment",
	"Camera",
}) do
	local button = create("TextButton", {
		Name = name .. "Navigation",
		Size = UDim2.new(1, 0, 0, 42),
		BackgroundColor3 = COLORS.Sidebar,
		BorderSizePixel = 0,
		Text = "   " .. (pageTitles[name] or name),
		TextColor3 = COLORS.Muted,
		TextSize = 12,
		Font = Enum.Font.GothamMedium,
		TextXAlignment = Enum.TextXAlignment.Left,
		AutoButtonColor = false,
		LayoutOrder = index,
	}, navContainer)

	round(button, 8)

	local page = create("ScrollingFrame", {
		Name = name .. "Page",
		Size = UDim2.new(1, -28, 1, -88),
		Position = UDim2.fromOffset(14, 78),
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		ScrollBarThickness = 4,
		ScrollBarImageColor3 = COLORS.Accent,
		CanvasSize = UDim2.new(0, 0, 0, 0),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Visible = false,
	}, content)

	create("UIListLayout", {
		Padding = UDim.new(0, 10),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}, page)

	create("UIPadding", {
		PaddingTop = UDim.new(0, 3),
		PaddingBottom = UDim.new(0, 12),
		PaddingLeft = UDim.new(0, 3),
		PaddingRight = UDim.new(0, 5),
	}, page)

	pages[name] = page
	navButtons[name] = button

	addConnection(button.MouseButton1Click:Connect(function()
		switchPage(name)
	end), connections)
end

--==================================================
-- بطاقات الإعدادات
--==================================================

local function createCard(pageName, height)
	local card = create("Frame", {
		Size = UDim2.new(1, -5, 0, height),
		BackgroundColor3 = COLORS.Card,
		BorderSizePixel = 0,
	}, pages[pageName])

	round(card, 10)
	stroke(card, COLORS.Border, 0.35)

	return card
end

local function createToggle(
	pageName,
	titleText,
	description,
	initialState,
	callback
)
	local card = createCard(pageName, 68)

	local title = makeLabel(
		card,
		titleText,
		UDim2.new(1, -105, 0, 25),
		UDim2.fromOffset(13, 9),
		13,
		COLORS.Text
	)
	title.Font = Enum.Font.GothamBold

	local desc = makeLabel(
		card,
		description,
		UDim2.new(1, -105, 0, 24),
		UDim2.fromOffset(13, 34),
		10,
		COLORS.Muted
	)
	desc.TextWrapped = true

	local button = create("TextButton", {
		Size = UDim2.fromOffset(65, 29),
		Position = UDim2.new(1, -78, 0.5, -14),
		BackgroundColor3 = COLORS.CardHover,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
	}, card)

	round(button, 8)

	local indicator = create("Frame", {
		Size = UDim2.fromOffset(19, 19),
		Position = UDim2.fromOffset(5, 5),
		BackgroundColor3 = COLORS.Muted,
		BorderSizePixel = 0,
	}, button)

	round(indicator, 7)

	local stateLabel = makeLabel(
		button,
		"إيقاف",
		UDim2.fromOffset(30, 29),
		UDim2.fromOffset(28, 0),
		10,
		COLORS.Muted
	)
	stateLabel.Font = Enum.Font.GothamBold
	stateLabel.TextXAlignment = Enum.TextXAlignment.Center

	local enabled = initialState == true

	local function refresh()
		button.BackgroundColor3 = enabled
			and COLORS.AccentDark
			or COLORS.CardHover

		indicator.Position = enabled
			and UDim2.new(1, -24, 0, 5)
			or UDim2.fromOffset(5, 5)

		indicator.BackgroundColor3 = enabled
			and COLORS.Green
			or COLORS.Muted

		stateLabel.Text = enabled and "تشغيل" or "إيقاف"
		stateLabel.TextColor3 = enabled and COLORS.Text or COLORS.Muted
		stateLabel.Position = enabled
			and UDim2.fromOffset(2, 0)
			or UDim2.fromOffset(28, 0)
	end

	local function setEnabled(value)
		enabled = value == true
		refresh()
		callback(enabled)
	end

	addConnection(button.MouseButton1Click:Connect(function()
		setEnabled(not enabled)
	end), connections)

	refresh()

	return {
		Set = setEnabled,
		Get = function()
			return enabled
		end,
	}
end

--==================================================
-- شريط تمرير قابل لإعادة الاستخدام
--==================================================

local function createSlider(
	pageName,
	titleText,
	description,
	minValue,
	maxValue,
	initialValue,
	suffix,
	callback
)
	local card = createCard(pageName, 103)

	local title = makeLabel(
		card,
		titleText,
		UDim2.new(1, -130, 0, 24),
		UDim2.fromOffset(13, 9),
		13,
		COLORS.Text
	)
	title.Font = Enum.Font.GothamBold

	local valueLabel = makeLabel(
		card,
		"",
		UDim2.fromOffset(115, 24),
		UDim2.new(1, -128, 0, 9),
		13,
		COLORS.Accent
	)
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Font = Enum.Font.GothamBold

	makeLabel(
		card,
		description,
		UDim2.new(1, -26, 0, 20),
		UDim2.fromOffset(13, 34),
		10,
		COLORS.Muted
	)

	local track = create("TextButton", {
		Name = "SliderTrack",
		Size = UDim2.new(1, -28, 0, 8),
		Position = UDim2.fromOffset(14, 72),
		BackgroundColor3 = COLORS.Track,
		BorderSizePixel = 0,
		Text = "",
		AutoButtonColor = false,
	}, card)

	round(track, 8)

	local fill = create("Frame", {
		Size = UDim2.new(0, 0, 1, 0),
		BackgroundColor3 = COLORS.Accent,
		BorderSizePixel = 0,
	}, track)

	round(fill, 8)

	local knob = create("Frame", {
		Size = UDim2.fromOffset(16, 16),
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.new(0, 0, 0.5, 0),
		BackgroundColor3 = Color3.new(1, 1, 1),
		BorderSizePixel = 0,
	}, track)

	round(knob, 10)

	local value = math.clamp(initialValue, minValue, maxValue)
	local thisSliderDragging = false

	local function refresh()
		local alpha = (value - minValue) / (maxValue - minValue)

		fill.Size = UDim2.new(alpha, 0, 1, 0)
		knob.Position = UDim2.new(alpha, 0, 0.5, 0)
		valueLabel.Text = tostring(value) .. suffix
	end

	local function setValue(newValue)
		value = math.clamp(
			math.floor(newValue + 0.5),
			minValue,
			maxValue
		)

		refresh()
		callback(value)
	end

	local function updateFromX(x)
		local width = track.AbsoluteSize.X

		if width <= 0 then
			return
		end

		local alpha = math.clamp(
			(x - track.AbsolutePosition.X) / width,
			0,
			1
		)

		setValue(minValue + alpha * (maxValue - minValue))
	end

	local function beginDrag(input)
		thisSliderDragging = true
		updateFromX(input.Position.X)
	end

	addConnection(track.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			beginDrag(input)
		end
	end), connections)

	addConnection(knob.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			beginDrag(input)
		end
	end), connections)

	addConnection(UserInputService.InputChanged:Connect(function(input)
		if not thisSliderDragging then
			return
		end

		if input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch then
			updateFromX(input.Position.X)
		end
	end), connections)

	addConnection(UserInputService.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			thisSliderDragging = false
		end
	end), connections)

	refresh()

	return {
		Set = setValue,
		Get = function()
			return value
		end,
	}
end

--==================================================
-- الاستهداف
--==================================================

local aimToggle

aimToggle = createToggle(
	"Aiming",
	"الاستهداف التلقائي",
	"يستهدف الضب ضمن النطاق تلقائيًا.",
	false,
	function(state)
		aiming = state
		fireTimer = 0
		idleTimer = 0
		targetVisible = false
	end
)

createSlider(
	"Aiming",
	"نطاق الكشف",
	"أقصى مسافة للهدف، تُقاس بالستود.",
	MIN_AIM_DISTANCE,
	MAX_AIM_DISTANCE,
	MAX_DISTANCE,
	" ستود",
	function(value)
		MAX_DISTANCE = value
	end
)

--==================================================
-- كشف وميض الاحتياجات
--==================================================

local function disconnectNeeds()
	for _, connection in ipairs(needsConnections) do
		pcall(function()
			connection:Disconnect()
		end)
	end

	table.clear(needsConnections)
end

--==================================================
-- التفاعل التلقائي مع انخفاض الاحتياجات
--==================================================

local NEED_ACTION_COOLDOWN = 12
local HOLD_BUFFER = 0.15
local MAX_HOLD_ATTEMPTS = 3
local NEED_PROMPT_NAMES = {
	Hunger = "كل تمر",
	Thirst = "اشرب موية",
}
local NEED_ORDER = { "Hunger", "Thirst" }

-- عامل واحد مشترك يعالج كل الاحتياجات المعلقة في رحلة واحدة.
local needWorkerBusy = false
local pendingNeeds = {}
local lastNeedAction = {
	Hunger = 0,
	Thirst = 0,
}

local function getPromptWorldPosition(prompt)
	local parent = prompt.Parent

	if not parent then
		return nil
	end

	if parent:IsA("Attachment") then
		return parent.WorldPosition
	elseif parent:IsA("BasePart") then
		return parent.Position
	end

	local part = parent:FindFirstAncestorWhichIsA("BasePart")
	if part then
		return part.Position
	end

	local model = parent:FindFirstAncestorWhichIsA("Model")
	if model then
		local primary = model.PrimaryPart or model:FindFirstChildWhichIsA("BasePart", true)
		return primary and primary.Position or nil
	end

	return nil
end

local function findNearestNeedPrompt(actionText, origin)
	local nearestPrompt
	local nearestDistance = math.huge
	local searchRoot = workspace:FindFirstChild("DhabEzbas")

	if not searchRoot then
		warn("لم يتم العثور على workspace.DhabEzbas.")
		return nil
	end

	for _, object in ipairs(searchRoot:GetDescendants()) do
		if object:IsA("ProximityPrompt")
			and object.ActionText == actionText
			and object.Enabled then

			local position = getPromptWorldPosition(object)
			if position then
				local distance = (position - origin).Magnitude
				if distance < nearestDistance then
					nearestDistance = distance
					nearestPrompt = object
				end
			end
		end
	end

	return nearestPrompt
end

local function activateNeedPrompt(prompt)
	local holdTime = math.max(prompt.HoldDuration, 0.1)

	for _ = 1, MAX_HOLD_ATTEMPTS do
		if not prompt.Parent or not prompt.Enabled then
			return false
		end

		local triggered = false
		local connection = prompt.Triggered:Connect(function()
			triggered = true
		end)

		local began = pcall(function()
			prompt:InputHoldBegin()
		end)

		if began then
			-- الضغط طوال المدة كاملة مع هامش أمان.
			task.wait(holdTime + HOLD_BUFFER)

			pcall(function()
				prompt:InputHoldEnd()
			end)
		else
			-- بديل للبيئات التي توفر fireproximityprompt.
			local ok, fireFunction = pcall(function()
				return fireproximityprompt
			end)

			if ok and typeof(fireFunction) == "function" then
				pcall(fireFunction, prompt)
				task.wait(holdTime + HOLD_BUFFER)
			end
		end

		task.wait(0.1) -- انتظار وصول حدث Triggered
		connection:Disconnect()

		if triggered then
			return true
		end

		task.wait(0.2) -- توقف قصير قبل إعادة المحاولة
	end

	return false
end

local function waitUntilStill(generation)
	while lowNeeds and generation == needsGeneration do
		local character = player.Character
		local humanoid = character and character:FindFirstChildOfClass("Humanoid")
		local root = character and character:FindFirstChild("HumanoidRootPart")

		if not humanoid or not root then
			task.wait(1)
		elseif humanoid.MoveDirection.Magnitude < 0.05 then
			return true
		else
			task.wait(5)
		end
	end

	return false
end

local function processPendingNeeds(generation)
	if not waitUntilStill(generation) then
		return
	end

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")

	if not root then
		return
	end

	-- يُحفظ مرة واحدة فقط للرحلة كاملة مهما كان عدد الاحتياجات.
	local originalCFrame = root.CFrame

	for _, name in ipairs(NEED_ORDER) do
		if not pendingNeeds[name] then
			continue
		end

		if not lowNeeds or generation ~= needsGeneration then
			break
		end

		if player.Character ~= character or not root.Parent then
			break
		end

		pendingNeeds[name] = nil
		lastNeedAction[name] = os.clock()

		local prompt = findNearestNeedPrompt(NEED_PROMPT_NAMES[name], root.Position)

		if prompt and prompt.Parent then
			local promptPosition = getPromptWorldPosition(prompt)

			if promptPosition then
				root.CFrame = CFrame.new(promptPosition + Vector3.new(0, 2.5, 0))
				root.AssemblyLinearVelocity = Vector3.zero

				-- إعطاء الموقع وقتًا ليستقر قبل الضغط.
				task.wait(0.3)

				activateNeedPrompt(prompt)
				task.wait(0.2)
			end
		else
			warn("لم يتم العثور على ProximityPrompt مفعّل لـ:", NEED_PROMPT_NAMES[name])
		end
	end

	-- العودة إلى المكان الأصلي بعد الانتهاء من كل شيء فقط.
	if player.Character == character and root.Parent then
		root.CFrame = originalCFrame
		root.AssemblyLinearVelocity = Vector3.zero
	end
end

local function handleLowNeed(name, generation)
	if os.clock() - lastNeedAction[name] < NEED_ACTION_COOLDOWN then
		return
	end

	pendingNeeds[name] = true

	-- إذا كان هناك عامل يعمل بالفعل فسيعالج هذه الحاجة أيضًا.
	if needWorkerBusy then
		return
	end

	needWorkerBusy = true

	task.spawn(function()
		local success, err = pcall(processPendingNeeds, generation)

		if not success then
			warn("فشل التفاعل مع الاحتياجات:", err)
		end

		table.clear(pendingNeeds)
		needWorkerBusy = false
	end)
end

local function startNeedsMonitoring()
	needsGeneration += 1
	local generation = needsGeneration

	disconnectNeeds()

	if not lowNeeds then
		return
	end

	task.spawn(function()
		local indicators

		while lowNeeds and generation == needsGeneration do
			local hud = playerGui:FindFirstChild("DhabHUD")
			local root = hud and hud:FindFirstChild("Root")
			local topBar = root and root:FindFirstChild("TopBar")
			local needs = topBar and topBar:FindFirstChild("Needs")

			local hunger = needs and needs:FindFirstChild("Hunger")
			local thirst = needs and needs:FindFirstChild("Thirst")

			local hungerTrack = hunger and hunger:FindFirstChild("Track")
			local thirstTrack = thirst and thirst:FindFirstChild("Track")

			local hungerLow = hungerTrack and hungerTrack:FindFirstChild("FillLow")
			local thirstLow = thirstTrack and thirstTrack:FindFirstChild("FillLow")

			if hungerLow and thirstLow then
				indicators = {
					Hunger = hungerLow,
					Thirst = thirstLow,
				}
				break
			end

			task.wait(0.5)
		end

		if not indicators
			or not lowNeeds
			or generation ~= needsGeneration then
			return
		end

		local switchTimes = {
			Hunger = {},
			Thirst = {},
		}

		local lastStates = {}
		local lastAlert = {
			Hunger = 0,
			Thirst = 0,
		}

		local function checkIndicator(name, indicator)
			if not lowNeeds or generation ~= needsGeneration then
				return
			end

			if not indicator.Parent then
				return
			end

			local currentState = indicator.Visible

			if lastStates[name] == nil then
				lastStates[name] = currentState
				return
			end

			if currentState == lastStates[name] then
				return
			end

			lastStates[name] = currentState

			local now = os.clock()
			local times = switchTimes[name]

			table.insert(times, now)

			for i = #times, 1, -1 do
				if now - times[i] > FLICKER_WINDOW then
					table.remove(times, i)
				end
			end

			if #times >= REQUIRED_SWITCHES
				and now - lastAlert[name] >= NEEDS_ALERT_COOLDOWN then

				lastAlert[name] = now
				table.clear(times)

				print("مؤشر " .. (name == "Hunger" and "الجوع" or "العطش") .. " يومض بسرعة!")

				-- لا يُحاول التفاعل مع الحاجة المطابقة إلا عندما
				-- يومض مؤشرها المنخفض بما يكفي لتفعيل التنبيه.
				handleLowNeed(name, generation)
			end
		end

		for name, indicator in pairs(indicators) do
			lastStates[name] = indicator.Visible

			addConnection(
				indicator:GetPropertyChangedSignal("Visible"):Connect(function()
					checkIndicator(name, indicator)
				end),
				needsConnections
			)
		end

		while lowNeeds and generation == needsGeneration do
			for name, indicator in pairs(indicators) do
				checkIndicator(name, indicator)
			end

			task.wait(0.1)
		end
	end)
end

createToggle(
	"Environment",
	"تنبيه الاحتياجات",
	"ينبّه عند انخفاض الاحتياجات ويستخدم الأكل والماء القريب تلقائيًا.",
	false,
	function(state)
		lowNeeds = state

		if state then
			startNeedsMonitoring()
		else
			needsGeneration += 1
			table.clear(pendingNeeds)
			disconnectNeeds()
		end
	end
)

--==================================================
-- المشي ضد الخمول
--==================================================
-- إذا كان الاستهداف مفعّلًا ولا يوجد ضب في النطاق ويقف اللاعب ساكنًا
-- لمدة IDLE_TIMEOUT ثانية: يحفظ المكان ويمشي في اتجاه واحد حتى
-- يظهر ضب، ثم يعود إلى المكان المحفوظ.

local walkState = "idle" -- "idle" خامل، "walking" يمشي، "returning" يعود
local walkOrigin
local walkDirection = Vector3.new(0, 0, -1)
local walkStartTime = 0
local stuckCheckTime = 0
local stuckCheckPosition = Vector3.zero
local walkGeneration = 0

local function getCharacterParts()
	local character = player.Character
	local humanoid = character and character:FindFirstChildOfClass("Humanoid")
	local root = character and character:FindFirstChild("HumanoidRootPart")

	return character, humanoid, root
end

local function flatDirection(vector)
	local flat = Vector3.new(vector.X, 0, vector.Z)

	if flat.Magnitude < 0.01 then
		return Vector3.new(0, 0, -1)
	end

	return flat.Unit
end

local function resetWalker()
	walkGeneration += 1
	walkState = "idle"
	walkOrigin = nil
	idleTimer = 0
end

local function beginReturn(delayTime)
	if walkState ~= "walking" then
		return
	end

	walkState = "returning"

	local generation = walkGeneration
	local origin = walkOrigin
	local character, humanoid = getCharacterParts()

	-- التوقف عن المشي فورًا حتى لو تأخرت العودة بالانتقال.
	if humanoid then
		humanoid:Move(Vector3.zero, false)
	end

	task.spawn(function()
		if delayTime > 0 then
			task.wait(delayTime)
		end

		-- عدم التعارض مع رحلة الانتقال الخاصة بالاحتياجات.
		while needWorkerBusy and generation == walkGeneration do
			task.wait(0.2)
		end

		if generation ~= walkGeneration then
			return
		end

		local currentCharacter, _, currentRoot = getCharacterParts()

		if currentCharacter == character
			and currentRoot
			and currentRoot.Parent
			and origin then

			currentRoot.CFrame = origin
			currentRoot.AssemblyLinearVelocity = Vector3.zero
		end

		resetWalker()
	end)
end

-- نستخدم Stepped لأنه يعمل بعد سكربت التحكم الافتراضي (RenderStepped)
-- وقبل الفيزياء، فلا يُلغى أمر الحركة بـ Move(0) كل إطار.
addConnection(RunService.Stepped:Connect(function(_, dt)
	if not autoWalkEnabled then
		return
	end

	local character, humanoid, root = getCharacterParts()

	if not character or not humanoid or not root or humanoid.Health <= 0 then
		if walkState == "walking" then
			resetWalker()
		end

		idleTimer = 0
		return
	end

	if walkState == "returning" then
		return
	end

	--------------------------------------------------
	-- خامل: عدّ الوقت بدون هدف وبدون حركة
	--------------------------------------------------
	if walkState == "idle" then
		local busy = needWorkerBusy
			or humanoid.Sit
			or humanoid.MoveDirection.Magnitude >= 0.05

		if not aiming or targetVisible or busy then
			idleTimer = 0
			return
		end

		idleTimer += dt

		if idleTimer < IDLE_TIMEOUT then
			return
		end

		walkState = "walking"
		walkOrigin = root.CFrame
		walkDirection = flatDirection(root.CFrame.LookVector)
		walkStartTime = os.clock()
		stuckCheckTime = walkStartTime
		stuckCheckPosition = root.Position

		print("لا يوجد ضب منذ " .. IDLE_TIMEOUT .. " ثانية - بدء المشي لتفعيل الظهور.")

		if humanoid.WalkSpeed <= 0 then
			warn("سرعة المشي تساوي 0، لن يتحرك اللاعب.")
		end
		return
	end

	--------------------------------------------------
	-- المشي
	--------------------------------------------------
	if not aiming then
		beginReturn(0)
		return
	end

	if targetVisible then
		print("ظهر ضب - العودة إلى المكان الأصلي.")
		beginReturn(RETURN_DELAY)
		return
	end

	if os.clock() - walkStartTime >= MAX_WALK_TIME then
		warn("المشي ضد الخمول: لم يظهر ضب بعد " .. MAX_WALK_TIME .. " ثانية، العودة.")
		beginReturn(0)
		return
	end

	-- إذا اعترض جدار الطريق، يلتف 90 درجة ويقفز.
	if os.clock() - stuckCheckTime >= STUCK_CHECK_INTERVAL then
		local movedVector = root.Position - stuckCheckPosition
		local moved = Vector3.new(movedVector.X, 0, movedVector.Z).Magnitude

		if moved < STUCK_DISTANCE then
			walkDirection = CFrame.Angles(0, math.rad(90), 0) * walkDirection
			humanoid.Jump = true
		end

		stuckCheckTime = os.clock()
		stuckCheckPosition = root.Position
	end

	humanoid:Move(walkDirection, false)
end), connections)

local walkToggle

walkToggle = createToggle(
	"Aiming",
	"المشي ضد الخمول (K)",
	"يمشي حتى يظهر ضب بعد 40 ثانية من الخمول ثم يعود.",
	false,
	function(state)
		autoWalkEnabled = state
		idleTimer = 0

		if not state then
			-- إذا كان في منتصف المشي، يتوقف ويعود إلى المكان المحفوظ.
			beginReturn(0)
		end
	end
)

--==================================================
-- الإضاءة الساطعة
--==================================================

createToggle(
	"Environment",
	"إضاءة ساطعة",
	"يُضيء المشهد ويزيل مؤثرات الإضاءة.",
	false,
	function(state)
		brightLighting = state

		if state then
			applyBrightLighting()
		else
			restoreLighting()
		end
	end
)

--==================================================
-- كاشف الضب
--==================================================

local function getTierColor(dhab)
	local tier = dhab:GetAttribute("Tier")

	if tier == nil then
		local hitbox = dhab:FindFirstChild("Hitbox")

		if hitbox then
			tier = hitbox:GetAttribute("Tier")
		end
	end

	return TIER_COLORS[string.upper(tostring(tier or ""))]
		or Color3.new(1, 1, 1)
end

local function getArabicName(dhab)
	local name = dhab:GetAttribute("Arabic")

	if name == nil then
		local hitbox = dhab:FindFirstChild("Hitbox")

		if hitbox then
			name = hitbox:GetAttribute("Arabic")
		end
	end

	return tostring(name or "Unknown")
end

local function getHighlightPart(dhab)
	local hitbox = dhab:FindFirstChild("Hitbox")

	if hitbox and hitbox:IsA("BasePart") then
		return hitbox
	end

	if dhab:IsA("BasePart") then
		return dhab
	end

	if dhab:IsA("Model") and dhab.PrimaryPart then
		return dhab.PrimaryPart
	end

	return dhab:FindFirstChildWhichIsA("BasePart", true)
end

local function removeHighlight(dhab)
	local objects = activeHighlights[dhab]

	if not objects then
		return
	end

	if objects.Highlight then
		objects.Highlight:Destroy()
	end

	if objects.Billboard then
		objects.Billboard:Destroy()
	end

	activeHighlights[dhab] = nil
end

local function addHighlight(dhab, part)
	local highlight = create("Highlight", {
		Name = "DhabTierHighlight",
		Adornee = dhab,
		DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
		FillTransparency = 0.7,
		OutlineTransparency = 0,
	}, dhab)

	local billboard = create("BillboardGui", {
		Name = "DhabArabicName",
		Adornee = part,
		Size = UDim2.fromOffset(180, 35),
		StudsOffset = Vector3.new(0, 3, 0),
		AlwaysOnTop = true,
		MaxDistance = HIGHLIGHT_DISTANCE,
	}, gui)

	local label = create("TextLabel", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		TextColor3 = Color3.new(1, 1, 1),
		TextStrokeTransparency = 0.2,
		TextScaled = true,
		Font = Enum.Font.GothamBold,
		Text = "",
	}, billboard)

	activeHighlights[dhab] = {
		Highlight = highlight,
		Billboard = billboard,
		Label = label,
		Part = part,
	}
end

local function updateHighlights()
	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")

	if not root then
		for dhab in pairs(activeHighlights) do
			removeHighlight(dhab)
		end

		return
	end

	local seen = {}

	for _, dhab in ipairs(Wild:GetChildren()) do
		local part = getHighlightPart(dhab)

		if part and part:IsA("BasePart") then
			local distance = (part.Position - root.Position).Magnitude

			if distance <= HIGHLIGHT_DISTANCE then
				seen[dhab] = true

				if not activeHighlights[dhab] then
					addHighlight(dhab, part)
				end

				local objects = activeHighlights[dhab]
				local color = getTierColor(dhab)

				objects.Highlight.FillColor = color
				objects.Highlight.OutlineColor = color
				objects.Label.Text = getArabicName(dhab)
				objects.Label.TextColor3 = color

				if objects.Part ~= part then
					objects.Billboard.Adornee = part
					objects.Part = part
				end
			end
		end
	end

	for dhab in pairs(activeHighlights) do
		if not seen[dhab] or not dhab.Parent then
			removeHighlight(dhab)
		end
	end
end

createToggle(
	"Visuals",
	"كاشف الضب",
	"يعرض إطارات ملونة حسب الفئة مع الأسماء.",
	false,
	function(state)
		highlightEnabled = state

		if not state then
			for dhab in pairs(activeHighlights) do
				removeHighlight(dhab)
			end
		end
	end
)

--==================================================
-- مجال رؤية الكاميرا
--==================================================

createSlider(
	"Camera",
	"مجال الرؤية",
	"ضبط مجال رؤية الكاميرا.",
	MIN_FOV,
	MAX_FOV,
	currentFOV,
	"°",
	function(value)
		currentFOV = value
		applyCameraSettings()
	end
)

--==================================================
-- اختصارات لوحة المفاتيح
--==================================================

addConnection(UserInputService.InputBegan:Connect(function(input, processed)
	if processed then
		return
	end

	if input.KeyCode == TOGGLE_KEY then
		aimToggle.Set(not aimToggle.Get())

	elseif input.KeyCode == WALK_KEY then
		walkToggle.Set(not walkToggle.Get())

	elseif input.KeyCode == PANEL_KEY then
		hidden = not hidden
		main.Visible = not hidden
	end
end), connections)

--==================================================
-- تثبيت إعدادات الكاميرا
--==================================================

addConnection(player.CharacterAdded:Connect(function()
	task.wait(0.2)
	applyCameraSettings()
end), connections)

addConnection(workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
	task.defer(applyCameraSettings)
end), connections)

local lastAppliedCameraCFrame
local lastAppliedZoomOffset = 0

RunService:BindToRenderStep(
	"PersistentDhabCamera",
	Enum.RenderPriority.Camera.Value + 1,
	function()
		local currentCamera = workspace.CurrentCamera

		if not currentCamera then
			return
		end

		if currentCamera.FieldOfView ~= currentFOV then
			currentCamera.FieldOfView = currentFOV
		end

		if currentCamera.CameraType == Enum.CameraType.Scriptable
			and vehicleZoomOffset > 0 then

			local baseCFrame = currentCamera.CFrame

			-- التراجع عن الإزاحة السابقة فقط إذا كانت الكاميرا ما زالت
			-- بنفس CFrame الذي طبّقه هذا السكربت في الإطار الأخير.
			if lastAppliedCameraCFrame
				and baseCFrame == lastAppliedCameraCFrame then

				baseCFrame = baseCFrame
					* CFrame.new(0, 0, -lastAppliedZoomOffset)
			end

			currentCamera.CFrame =
				baseCFrame * CFrame.new(0, 0, vehicleZoomOffset)

			lastAppliedCameraCFrame = currentCamera.CFrame
			lastAppliedZoomOffset = vehicleZoomOffset
		else
			lastAppliedCameraCFrame = nil
			lastAppliedZoomOffset = 0
		end
	end
)

--==================================================
-- حلقة التحديث الرئيسية
--==================================================

addConnection(RunService.Heartbeat:Connect(function(dt)
	if highlightEnabled then
		lastHighlightUpdate += dt

		if lastHighlightUpdate >= HIGHLIGHT_UPDATE_INTERVAL then
			lastHighlightUpdate = 0
			updateHighlights()
		end
	end

	if not aiming then
		return
	end

	fireTimer += dt

	if fireTimer < FIRE_INTERVAL then
		return
	end

	fireTimer = 0

	local character = player.Character
	local root = character and character:FindFirstChild("HumanoidRootPart")

	if not root then
		return
	end

	local nearest
	local nearestDistance = MAX_DISTANCE

	for _, dhab in ipairs(Wild:GetChildren()) do
		local hitbox = dhab:FindFirstChild("Hitbox")

		if hitbox and hitbox:IsA("BasePart") then
			local distance = (hitbox.Position - root.Position).Magnitude

			if distance <= nearestDistance then
				local params = RaycastParams.new()
				params.FilterType = Enum.RaycastFilterType.Exclude
				params.FilterDescendantsInstances = {character}

				local result = workspace:Raycast(
					root.Position,
					hitbox.Position - root.Position,
					params
				)

				-- النتيجة nil تعني أن الشعاع لم يصطدم بعائق.
				if not result or result.Instance:IsDescendantOf(dhab) then
					nearest = dhab
					nearestDistance = distance
				end
			end
		end
	end

	targetVisible = nearest ~= nil

	if nearest then
		local hitbox = nearest:FindFirstChild("Hitbox")

		if hitbox and hitbox:IsA("BasePart") then
			local origin = root.Position
			local targetPosition = hitbox.Position
				- Vector3.new(0, hitbox.Size.Y * AIM_LOWER_AMOUNT, 0)

			local direction = targetPosition - origin

			if direction.Magnitude > 0 then
				Event:FireServer("Fire", {
					draw = 0,
					direction = direction.Unit,
					origin = origin,
				})
			end
		end
	end
end), connections)

--==================================================
-- التهيئة
--==================================================

switchPage("Aiming")
applyCameraSettings()

--==================================================
-- التنظيف
--==================================================

_G.DhabAimCleanup = function()
	aiming = false
	lowNeeds = false
	brightLighting = false
	highlightEnabled = false
	needsGeneration += 1
	table.clear(pendingNeeds)

	autoWalkEnabled = false
	walkGeneration += 1

	local _, cleanupHumanoid = getCharacterParts()
	if cleanupHumanoid then
		pcall(function()
			cleanupHumanoid:Move(Vector3.zero, false)
		end)
	end

	RunService:UnbindFromRenderStep("PersistentDhabCamera")

	for _, connection in ipairs(connections) do
		pcall(function()
			connection:Disconnect()
		end)
	end

	table.clear(connections)
	disconnectNeeds()

	for dhab in pairs(activeHighlights) do
		removeHighlight(dhab)
	end

	restoreLighting()

	player.CameraMinZoomDistance = originalMinZoom
	player.CameraMaxZoomDistance = originalMaxZoom

	local currentCamera = workspace.CurrentCamera
	if currentCamera then
		currentCamera.FieldOfView = originalFOV
	end

	storedLighting:Destroy()
	gui:Destroy()
end