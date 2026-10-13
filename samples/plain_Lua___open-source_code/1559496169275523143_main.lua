local L_1_ = {};
L_1_["1"] = Instance.new("ScreenGui", cloneref(game:GetService("CoreGui") or gethui()));
L_1_["1"]["Name"] = [[Z3US Loader]];
L_1_["1"]["ZIndexBehavior"] = Enum.ZIndexBehavior.Global;
L_1_["1"]["ResetOnSpawn"] = false;
local TweenService = cloneref(game:GetService("TweenService"))
local EASE_QUAD = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
local EASE_THUMB = TweenInfo.new(0.26, Enum.EasingStyle.Quint, Enum.EasingDirection.Out)
local BG_DARK = Color3.fromRGB(10, 10, 14)
local BG_MAIN = Color3.fromRGB(14, 14, 20)
local BG_PANEL = Color3.fromRGB(18, 18, 26)
local BG_ROW = Color3.fromRGB(20, 20, 30)
local BG_ROW_SEL = Color3.fromRGB(22, 22, 40)
local ACCENT = Color3.fromRGB(19, 0, 255)
local ACCENT_DIM = Color3.fromRGB(12, 0, 170)
local BORDER = Color3.fromRGB(32, 32, 50)
local BORDER_SEL = Color3.fromRGB(19, 0, 255)
local TEXT_MAIN = Color3.fromRGB(230, 230, 240)
local TEXT_DIM = Color3.fromRGB(110, 110, 140)
local TEXT_LABEL = Color3.fromRGB(160, 160, 190)
local BLACK = Color3.fromRGB(0, 0, 0)
local WHITE = Color3.fromRGB(255, 255, 255)
local BTN_OFF = Color3.fromRGB(35, 35, 55)
local GREEN_DIM = Color3.fromRGB(30, 180, 100)
local FONT_MAIN = Enum.Font.Code
local CORNER_SM = UDim.new(0, 2)
local CORNER_MED = UDim.new(0, 3)
local FILL_LOADING = Color3.fromRGB(140, 120, 255)
local FILL_OK = Color3.fromRGB(70, 225, 135)
local FILL_ERR = Color3.fromRGB(235, 75, 75)
local BTN_ERR = Color3.fromRGB(150, 35, 45)

function make(cls, props, parent)
	local i = Instance.new(cls)
	if parent then
		i.Parent = parent
	end
	for k, v in props do
		i[k] = v
	end
	return i
end
function corner(r, p)
	return make("UICorner", {
		CornerRadius = r
	}, p)
end
function stroke(col, thick, p)
	local s = make("UIStroke", {
		Color = col,
		Thickness = thick,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	}, p)
	return s
end
function label(props, parent)
	local l = make("TextLabel", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Font = FONT_MAIN,
		TextColor3 = TEXT_MAIN,
		TextSize = 14,
		TextXAlignment = Enum.TextXAlignment.Left,
		TextYAlignment = Enum.TextYAlignment.Center,
	}, parent)
	for k, v in props do
		l[k] = v
	end
	return l
end
function btn(props, parent)
	local b = make("TextButton", {
		BackgroundTransparency = 0,
		BorderSizePixel = 0,
		Font = FONT_MAIN,
		TextColor3 = WHITE,
		TextSize = 14,
		AutoButtonColor = false,
	}, parent)
	for k, v in props do
		b[k] = v
	end
	return b
end

local Root = make("Frame", {
	BackgroundColor3 = BG_DARK,
	BorderSizePixel = 0,
	Size = UDim2.fromOffset(620, 480),
	Position = UDim2.new(0.5, -310, 0.5, -240),
	ClipsDescendants = true,
}, L_1_["1"])
corner(CORNER_MED, Root)
stroke(ACCENT, 1.5, Root)

local TopBar = make("Frame", {
	BackgroundColor3 = BG_MAIN,
	BorderSizePixel = 0,
	Size = UDim2.new(1, 0, 0, 32),
}, Root)

make("Frame", {
	BackgroundColor3 = ACCENT,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 0, 1, -1),
	Size = UDim2.new(1, 0, 0, 1),
}, TopBar)

label({
	Text = "Z3US PROJECTS",
	TextColor3 = TEXT_MAIN,
	TextSize = 13,
	Size = UDim2.new(1, -60, 1, 0),
	Position = UDim2.fromOffset(12, 0),
	Font = FONT_MAIN,
}, TopBar)

local CloseBtn = btn({
	Text = "×",
	TextSize = 20,
	BackgroundColor3 = Color3.fromRGB(14, 14, 20),
	Size = UDim2.fromOffset(28, 28),
	AnchorPoint = Vector2.new(1, 0),
	Position = UDim2.new(1, 0, 0, 0),
}, TopBar)
corner(UDim.new(0, 0), CloseBtn)

local LeftPanel = make("Frame", {
	BackgroundColor3 = BG_PANEL,
	BorderSizePixel = 0,
	Position = UDim2.fromOffset(0, 32),
	Size = UDim2.new(0, 220, 1, -32),
}, Root)
make("Frame", {
	BackgroundColor3 = BORDER,
	BorderSizePixel = 0,
	Position = UDim2.new(1, -1, 0, 0),
	Size = UDim2.fromOffset(1, 9999),
}, LeftPanel)

label({
	Text = "GAMES",
	TextColor3 = TEXT_DIM,
	TextSize = 11,
	Size = UDim2.new(1, -16, 0, 24),
	Position = UDim2.fromOffset(12, 6),
	Font = FONT_MAIN,
}, LeftPanel)

local GameScroll = make("ScrollingFrame", {
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.fromOffset(0, 32),
	Size = UDim2.new(1, 0, 1, -32),
	CanvasSize = UDim2.new(0, 0, 0, 0),
	AutomaticCanvasSize = Enum.AutomaticSize.Y,
	ScrollBarThickness = 2,
	ScrollBarImageColor3 = ACCENT,
	TopImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
	BottomImage = "rbxasset://textures/ui/Scroll/scroll-middle.png",
}, LeftPanel)

local GameLayout = make("UIListLayout", {
	Padding = UDim.new(0, 2),
	SortOrder = Enum.SortOrder.LayoutOrder,
}, GameScroll)

make("UIPadding", {
	PaddingLeft = UDim.new(0, 6),
	PaddingRight = UDim.new(0, 6),
	PaddingTop = UDim.new(0, 4),
	PaddingBottom = UDim.new(0, 4),
}, GameScroll)

local RightPanel = make("Frame", {
	BackgroundColor3 = BG_MAIN,
	BorderSizePixel = 0,
	Position = UDim2.fromOffset(220, 32),
	Size = UDim2.new(1, -220, 1, -32),
}, Root)

local PreviewArea = make("Frame", {
	BackgroundColor3 = BG_PANEL,
	BorderSizePixel = 0,
	Position = UDim2.fromOffset(16, 16),
	Size = UDim2.new(1, -32, 0, 180),
}, RightPanel)
corner(CORNER_SM, PreviewArea)
stroke(BORDER, 1, PreviewArea)

make("Frame", {
	BackgroundColor3 = ACCENT,
	BorderSizePixel = 0,
	Size = UDim2.new(1, 0, 0, 2),
}, PreviewArea)

local PreviewIcon = make("ImageLabel", {
	BackgroundTransparency = 1,
	Image = [[rbxassetid://92661965333918]],
	Size = UDim2.fromOffset(72, 72),
	AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0.5, 0, 0, 20),
}, PreviewArea)

local SelectedLabel = label({
	Text = "No script selected",
	TextColor3 = TEXT_MAIN,
	TextSize = 16,
	Size = UDim2.new(1, -20, 0, 22),
	AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0.5, 0, 0, 102),
	TextXAlignment = Enum.TextXAlignment.Center,
	Font = FONT_MAIN,
}, PreviewArea)

local SubLabel = label({
	Text = "select a game from the list",
	TextColor3 = TEXT_DIM,
	TextSize = 12,
	Size = UDim2.new(1, -20, 0, 16),
	AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0.5, 0, 0, 126),
	TextXAlignment = Enum.TextXAlignment.Center,
}, PreviewArea)

local OptionsArea = make("Frame", {
	BackgroundColor3 = BG_PANEL,
	BorderSizePixel = 0,
	Position = UDim2.fromOffset(16, 212),
	Size = UDim2.new(1, -32, 0, 178),
}, RightPanel)
corner(CORNER_SM, OptionsArea)
stroke(BORDER, 1, OptionsArea)
make("Frame", {
	BackgroundColor3 = BORDER,
	BorderSizePixel = 0,
	Size = UDim2.new(1, 0, 0, 1)
}, OptionsArea)

label({
	Text = "OPTIONS",
	TextColor3 = TEXT_DIM,
	TextSize = 11,
	Size = UDim2.new(1, -16, 0, 28),
	Position = UDim2.fromOffset(12, 0),
}, OptionsArea)

local RivalsBlock = make("Frame", {
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.fromOffset(0, 30),
	Size = UDim2.new(1, 0, 0, 138),
	Visible = false,
}, OptionsArea)

local VerLabel = label({
	Text = "Version",
	TextColor3 = TEXT_LABEL,
	TextSize = 13,
	Size = UDim2.new(0, 100, 0, 28),
	Position = UDim2.fromOffset(12, 0),
}, RivalsBlock)

local V1Btn = btn({
	Text = "V1",
	BackgroundColor3 = BTN_OFF,
	Size = UDim2.fromOffset(52, 24),
	Position = UDim2.fromOffset(110, 4),
	TextSize = 13,
}, RivalsBlock)
corner(CORNER_SM, V1Btn)

local V2Btn = btn({
	Text = "V2",
	BackgroundColor3 = ACCENT,
	Size = UDim2.fromOffset(52, 24),
	Position = UDim2.fromOffset(168, 4),
	TextSize = 13,
}, RivalsBlock)
corner(CORNER_SM, V2Btn)

local RivalsRow = make("Frame", {
	BackgroundTransparency = 1,
	BorderSizePixel = 0,
	Position = UDim2.fromOffset(0, 38),
	Size = UDim2.new(1, 0, 0, 100),
}, RivalsBlock)

function makeToggleRow(parent, yPos, labelText, defaultOn)
	local row = make("Frame", {
		BackgroundTransparency = 1,
		BorderSizePixel = 0,
		Position = UDim2.fromOffset(12, yPos),
		Size = UDim2.new(1, -24, 0, 26),
	}, parent)

	label({
		Text = labelText,
		TextColor3 = TEXT_LABEL,
		TextSize = 13,
		Size = UDim2.new(0.6, 0, 1, 0),
	}, row)

	local OFF_POS = UDim2.fromOffset(2, 9)
	local ON_POS = UDim2.fromOffset(22, 9)

	local track = make("Frame", {
		BackgroundColor3 = defaultOn and ACCENT or BTN_OFF,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(40, 18),
	}, row)
	corner(UDim.new(0, 9), track)

	local thumb = make("Frame", {
		BackgroundColor3 = WHITE,
		BorderSizePixel = 0,
		AnchorPoint = Vector2.new(0, 0.5),
		Position = defaultOn and ON_POS or OFF_POS,
		Size = UDim2.fromOffset(14, 14),
	}, track)
	corner(UDim.new(0.5, 0), thumb)

	local state = defaultOn
	local trackTween, thumbTween

	local function render(animate)
		if trackTween then trackTween:Cancel() end
		if thumbTween then thumbTween:Cancel() end

		local targetColor = state and ACCENT or BTN_OFF
		local targetPos = state and ON_POS or OFF_POS

		if animate then
			trackTween = TweenService:Create(track, EASE_QUAD, { BackgroundColor3 = targetColor })
			thumbTween = TweenService:Create(thumb, EASE_THUMB, { Position = targetPos })
			trackTween:Play()
			thumbTween:Play()
		else
			track.BackgroundColor3 = targetColor
			thumb.Position = targetPos
		end
	end

	local btn2 = make("TextButton", {
		BackgroundTransparency = 1,
		Text = "",
		Size = UDim2.fromScale(1, 1),
	}, row)

	btn2.MouseButton1Click:Connect(function()
		state = not state
		render(true)
	end)

	return function()
		return state
	end
end

local getAutoload = makeToggleRow(RivalsRow, 2,  "Autoload", false)
local getSilentload = makeToggleRow(RivalsRow, 34, "Silentload", false)

local LoadBtn = btn({
	Text = "LOAD SCRIPT",
	BackgroundColor3 = ACCENT,
	Size = UDim2.new(1, -32, 0, 38),
	Position = UDim2.fromOffset(16, 400),
	TextSize = 14,
	Font = FONT_MAIN,
	ZIndex = 1,
	ClipsDescendants = true,
}, RightPanel)
corner(CORNER_SM, LoadBtn)

local LoadTrack = make("Frame", {
	BackgroundColor3 = ACCENT_DIM,
	BorderSizePixel = 0,
	Position = UDim2.new(0, 0, 1, -3),
	Size = UDim2.new(1, 0, 0, 3),
	ZIndex = 2,
}, LoadBtn)

local LoadFill = make("Frame", {
	BackgroundColor3 = WHITE,
	BorderSizePixel = 0,
	Size = UDim2.new(0, 0, 1, 0),
	ZIndex = 3,
}, LoadTrack)

local isLoading,loadToken,dotsThread = false, 0 , nil

function stopDots()
	if dotsThread then
		pcall(task.cancel, dotsThread)
		dotsThread = nil
	end
end

function startDots()
	stopDots()
	dotsThread = task.spawn(function()
		local dots = { "", ".", "..", "..." }
		local i = 0
		while isLoading do
			LoadBtn.Text = "LOADING" .. dots[(i % 4) + 1]
			i += 1
			task.wait(0.25)
		end
	end)
end

function startLoadingAnim()
	isLoading = true

	LoadBtn.BackgroundColor3 = ACCENT_DIM
	LoadBtn.TextColor3 = WHITE

	LoadFill.BackgroundColor3 = FILL_LOADING
	LoadFill.Size = UDim2.new(0, 0, 1, 0)

	TweenService:Create(LoadFill, TweenInfo.new(2.4, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(0.78, 0, 1, 0),
	}):Play()

	startDots()
end

function finishLoadingAnim(ok, text)
	stopDots()
	isLoading = false

	local fillColor = ok and FILL_OK or FILL_ERR
	local btnColor = ok and GREEN_DIM or BTN_ERR

	LoadBtn.Text = text
	LoadFill.BackgroundColor3 = fillColor

	TweenService:Create(LoadBtn, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		BackgroundColor3 = btnColor,
	}):Play()

	TweenService:Create(LoadFill, TweenInfo.new(0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(1, 0, 1, 0),
	}):Play()
end

function resetLoadingAnim()
	LoadBtn.Text = "LOAD SCRIPT"
	LoadBtn.BackgroundColor3 = ACCENT
	LoadBtn.TextColor3 = WHITE
	TweenService:Create(LoadFill, TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
		Size = UDim2.new(0, 0, 1, 0),
	}):Play()
end

local selectedGame = nil
local selectedRow = nil
local selectedStroke = nil
local rivalsVersion = "V2"

V1Btn.MouseButton1Click:Connect(function()
	rivalsVersion = "V1"
	V1Btn.BackgroundColor3 = ACCENT
	V2Btn.BackgroundColor3 = BTN_OFF
end)
V2Btn.MouseButton1Click:Connect(function()
	rivalsVersion = "V2"
	V2Btn.BackgroundColor3 = ACCENT
	V1Btn.BackgroundColor3 = BTN_OFF
end)

local GAMES = {
	{
		name = "Arsenal",
		load = function(o)
			getgenv().SCRIPT_KEY = ""
			loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/edb83cf0f1c81ecc7357cccb96979d81cfb2cec3e0114a980dc46751f3ed86c7/download"))()
		end
	},
	{
		name = "Bloxstrike",
		load = function(o)
			getgenv().SCRIPT_KEY = ""
			loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/eab2876b1455703856ef5cef90abe022128d85dbca718bbf0b0d67abd9d6f661/download"))()
		end
	},
	{
		name = "Gunfight Arena",
		load = function(o)
			getgenv().SCRIPT_KEY = ""
			loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/c5335ccfffdf85ccdc01c2ccaeeb884941c55817bd0573e2491934501d033d9b/download"))()
		end
	},
	{
		name = "Universal",
		load = function(o)
			getgenv().SCRIPT_KEY = ""
			loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/3cf9158bbebe2e92ae85890b25db3bc293e79b1e52d6e266df50917de9b09ab5/download"))()
		end
	},
	{
		name = "Rivals",
		rivals = true,
		load = function(o)
			getgenv().autoload   = o.autoload
			getgenv().silentload = o.silentload
			getgenv().SCRIPT_KEY = ""
			if o.version == "V2" then
				loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/2438cfd42af811d55492e854318eeda24a73aa5d0b11a403ec1f7542abd8f2f0/download"))()
			else
				loadstring(game:HttpGet("https://api.junkie-development.de/api/v1/luascripts/public/8be52e21a0145a401c446ca7ab2b5df9bd327ea80b0cf1d2fe99e442edd0f9c9/download"))()
			end
		end
	},
	{
		name = "Overkill",
		load = function(o)
			loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/d603ee0150fbdeb809a036562925966619d3e145a77b4d07b222b0612022ab8f/download"))()
		end
	},
	{
		name = "Planks",
		load = function(o)
			loadstring(game:HttpGet("https://raw.githubusercontent.com/blackowl1231/Z3US/refs/heads/main/Games/Z3US%20Planks.lua"))()
		end
	},
	{
		name = "One Tap",
		load = function(o)
			getgenv().SCRIPT_KEY = ""
			loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/2548ffbebdf21063cd4083f93a27ac276d44d1cb6503093d9c3290c3dfd954e3/download"))()
		end
	},
	{
		name = "Sniper Arena",
		load = function(o)
			loadstring(game:HttpGet("https://api.jnkie.com/api/v1/luascripts/public/03733bd5e2a10e56b753ed47fd11442b47c436fe1a45ee01a074b3010ce26bf5/download"))()
		end
	},
}

for i, g in ipairs(GAMES) do
	local row = make("Frame", {
		BackgroundColor3 = BG_ROW,
		BorderSizePixel = 0,
		Size = UDim2.new(1, 0, 0, 34),
		LayoutOrder = i,
	}, GameScroll)
	corner(CORNER_SM, row)
	local rs = stroke(BORDER, 1, row)

	local accentBar = make("Frame", {
		BackgroundColor3 = ACCENT,
		BorderSizePixel = 0,
		Size = UDim2.fromOffset(2, 34),
		Visible = false,
	}, row)
	corner(CORNER_SM, accentBar)
	label({
		Text = g.name,
		TextColor3 = TEXT_MAIN,
		TextSize = 13,
		Size = UDim2.new(1, -16, 1, 0),
		Position = UDim2.fromOffset(10, 0),
	}, row)
	local hitbox = btn({
		BackgroundTransparency = 1,
		Text = "",
		Size = UDim2.fromScale(1, 1),
	}, row)
	hitbox.MouseEnter:Connect(function()
		if selectedGame ~= g then
			row.BackgroundColor3 = Color3.fromRGB(24, 24, 36)
		end
	end)
	hitbox.MouseLeave:Connect(function()
		if selectedGame ~= g then
			row.BackgroundColor3 = BG_ROW
		end
	end)
	hitbox.MouseButton1Click:Connect(function()
		if selectedRow then
			selectedRow.bg.BackgroundColor3 = BG_ROW
			selectedRow.stroke.Color = BORDER
			selectedRow.bar.Visible = false
		end
		selectedGame = g
		selectedRow = {
			bg = row,
			stroke = rs,
			bar = accentBar
		}
		row.BackgroundColor3 = BG_ROW_SEL
		rs.Color = ACCENT
		accentBar.Visible = true
		SelectedLabel.Text = g.name
		SubLabel.Text = g.rivals and "rivals options visible below" or "ready to load"
		RivalsBlock.Visible = g.rivals == true
	end)
end

LoadBtn.MouseButton1Click:Connect(function()
	if isLoading or not selectedGame then
		return
	end

	loadToken += 1
	local token = loadToken
	local target = selectedGame

	local opts = {
		autoload = getAutoload(),
		silentload = getSilentload(),
		version = rivalsVersion,
	}
	startLoadingAnim()

	task.spawn(function()
		task.wait(0.2)

		local done, ok, err = false, nil, nil

		task.spawn(function()
			ok, err = pcall(target.load, opts)
			done = true
		end)

		local deadline = os.clock() + 6
		while not done and os.clock() < deadline do
			task.wait(0.1)
		end

		if token ~= loadToken then
			return
		end

		if not done then
			finishLoadingAnim(true, "RUNNING")
		elseif ok then
			finishLoadingAnim(true, "LOADED")
		else
			finishLoadingAnim(false, "FAILED")
			warn("[Z3US] load error: " .. tostring(err))
		end

		task.delay(1.2, function()
			if token == loadToken then
				resetLoadingAnim()
			end
		end)
	end)
end)
CloseBtn.MouseButton1Click:Connect(function()
	L_1_["1"]:Destroy()
end)

local UIS = cloneref(game:GetService("UserInputService"))
local dragging, dragStart, startPos = false, nil, nil

Root.InputBegan:Connect(function(inp)
	if inp.UserInputType == Enum.UserInputType.MouseButton1 then
		local relY = inp.Position.Y - Root.AbsolutePosition.Y
		if relY > 32 then
			return
		end
		dragging = true
		dragStart = inp.Position
		startPos = Root.Position
		inp.Changed:Connect(function()
			if inp.UserInputState == Enum.UserInputState.End then
				dragging = false
			end
		end)
	end
end)

UIS.InputChanged:Connect(function(inp)
	if dragging and inp.UserInputType == Enum.UserInputType.MouseMovement then
		local d = inp.Position - dragStart
		Root.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
	end
end)
