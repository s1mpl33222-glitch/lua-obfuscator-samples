-- ZeyHubb.vs Ping Lag — UI Demo
-- Features: LOW/MED/HIGH · Strength presets · Auto Brainrot · UI Scale · Keybinds · Auto-save

local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")

local plr = Players.LocalPlayer
local plrGui = plr:WaitForChild("PlayerGui", 10)
if not plrGui then
	warn("[ZeyHubb.vs] PlayerGui not found")
	return
end

local CONFIG_FILE = "ZeyHubbPingLag_Config.json"

-- Strength presets → power
local STRENGTHS = {
	{ name = "Ultra Weak",  power = 5000 },
	{ name = "Extra Weak",  power = 15000 },
	{ name = "Weak",        power = 35000 },
	{ name = "Normal",      power = 100000 },
	{ name = "Strong",      power = 200000 },
	{ name = "Extra Strong",power = 400000 },
	{ name = "Ultra Strong",power = 750000 },
}

local PRESETS = {
	LOW  = { power = 35000,  interval = 0.18 },
	MED  = { power = 100000, interval = 0.125 },
	HIGH = { power = 400000, interval = 0.08 },
}

local DEFAULT_CFG = {
	power        = 100000,
	interval     = 0.125,
	strength     = "Normal",
	keybindKb    = "F",
	keybindGp    = "ButtonR2",
	autoBrainrot = true,
	uiScale      = 1.0,
	locked       = false,
	posX         = nil,
	posY         = nil,
}

local cfg = {}
for k, v in pairs(DEFAULT_CFG) do cfg[k] = v end

local function resolveKb(name)
	if not name or name == "" or name == "None" then return nil end
	local ok, val = pcall(function() return Enum.KeyCode[name] end)
	return (ok and val) or nil
end

local function saveConfig()
	if not writefile then return end
	local ok, encoded = pcall(function() return HttpService:JSONEncode(cfg) end)
	if ok and encoded then pcall(writefile, CONFIG_FILE, encoded) end
end

local function loadConfig()
	local okLoad = pcall(function()
		if not (type(isfile) == "function" and type(readfile) == "function") then return end
		if not isfile(CONFIG_FILE) then return end
		local raw = readfile(CONFIG_FILE)
		local ok, data = pcall(function() return HttpService:JSONDecode(raw) end)
		if not ok or type(data) ~= "table" then return end
		cfg.power        = tonumber(data.power) or DEFAULT_CFG.power
		cfg.interval     = tonumber(data.interval) or DEFAULT_CFG.interval
		cfg.strength     = type(data.strength) == "string" and data.strength or DEFAULT_CFG.strength
		cfg.keybindKb    = type(data.keybindKb) == "string" and data.keybindKb or DEFAULT_CFG.keybindKb
		cfg.keybindGp    = type(data.keybindGp) == "string" and data.keybindGp or DEFAULT_CFG.keybindGp
		if type(data.autoBrainrot) == "boolean" then cfg.autoBrainrot = data.autoBrainrot end
		local sc = tonumber(data.uiScale)
		if sc then cfg.uiScale = math.clamp(sc, 0.5, 1.8) end
		cfg.locked = data.locked == true
		cfg.posX = tonumber(data.posX)
		cfg.posY = tonumber(data.posY)
	end)
	if not okLoad then warn("[ZeyHubb.vs] loadConfig failed") end
end
pcall(loadConfig)

local active, listeningFor, remote = false, nil, nil
local brainrotMode, lastBrainrotState, manualOverride = false, false, false
local settingsOpen, strengthOpen = false, false

local C = {
	bg      = Color3.fromRGB(20, 10, 5),
	panel   = Color3.fromRGB(35, 17, 5),
	card    = Color3.fromRGB(55, 25, 5),
	input   = Color3.fromRGB(40, 20, 5),
	orange1 = Color3.fromRGB(255, 105, 0),
	orange2 = Color3.fromRGB(255, 145, 20),
	orange3 = Color3.fromRGB(255, 190, 75),
	accent  = Color3.fromRGB(255, 125, 0),
	white   = Color3.fromRGB(240, 235, 255),
	dim     = Color3.fromRGB(210, 125, 65),
	green   = Color3.fromRGB(90, 230, 140),
	red     = Color3.fromRGB(255, 100, 120),
	yellow  = Color3.fromRGB(255, 200, 60),
	waiting = Color3.fromRGB(255, 190, 50),
}

for _, n in ipairs({"ZeyHubbPingLagGui"}) do
	local o = plrGui:FindFirstChild(n)
	if o then o:Destroy() end
end

local screen = Instance.new("ScreenGui")
screen.Name = "ZeyHubbPingLagGui"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = true
screen.DisplayOrder = 999
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen.Enabled = true

local okParent = pcall(function() screen.Parent = plrGui end)
if not okParent or not screen.Parent then
	pcall(function()
		screen.Parent = game:GetService("CoreGui")
	end)
end
if not screen.Parent then
	warn("[ZeyHubb.vs] could not parent ScreenGui")
	return
end

local rootScale = Instance.new("UIScale")
rootScale.Name = "RootScale"
rootScale.Scale = math.clamp(tonumber(cfg.uiScale) or 1, 0.5, 1.8)
rootScale.Parent = screen

local function tw(obj, props, t, style)
	TweenService:Create(obj, TweenInfo.new(t or 0.15, style or Enum.EasingStyle.Quad, Enum.EasingDirection.Out), props):Play()
end

local function corner(p, r)
	local c = Instance.new("UICorner", p)
	c.CornerRadius = UDim.new(0, r or 10)
	return c
end

local function stroke(p, col, th, tr)
	local s = Instance.new("UIStroke", p)
	s.Color = col or C.orange1
	s.Thickness = th or 1.2
	s.Transparency = tr or 0.35
	return s
end

local function grad(p, c1, c2, rot)
	local g = Instance.new("UIGradient", p)
	g.Color = ColorSequence.new({ColorSequenceKeypoint.new(0, c1), ColorSequenceKeypoint.new(1, c2)})
	g.Rotation = rot or 135
	return g
end

local function makeDraggable(frame, handle)
	handle = handle or frame
	local dragging, start, pos
	handle.InputBegan:Connect(function(i)
		if cfg.locked then return end
		if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			start = i.Position
			pos = frame.Position
			i.Changed:Connect(function()
				if i.UserInputState == Enum.UserInputState.End then
					dragging = false
					cfg.posX = frame.Position.X.Offset
					cfg.posY = frame.Position.Y.Offset
					saveConfig()
				end
			end)
		end
	end)
	UserInputService.InputChanged:Connect(function(i)
		if dragging and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then
			local d = i.Position - start
			frame.Position = UDim2.new(pos.X.Scale, pos.X.Offset + d.X, pos.Y.Scale, pos.Y.Offset + d.Y)
		end
	end)
end


local function mobileClick(btn, fn)
	btn.Active = true
	btn.Selectable = true
	if btn:IsA("TextButton") or btn:IsA("ImageButton") then
		btn.AutoButtonColor = false
	end
	btn.MouseButton1Click:Connect(fn)
	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch
			or input.UserInputType == Enum.UserInputType.MouseButton1 then
			local now = os.clock()
			if (btn:GetAttribute("_lastTap") or 0) + 0.2 > now then return end
			btn:SetAttribute("_lastTap", now)
			task.defer(function() end)
		end
	end)
end

local function bindTap(btn, fn)
	btn.Active = true
	btn.Selectable = true
	local last = 0
	local function fire()
		local now = os.clock()
		if now - last < 0.25 then return end
		last = now
		fn()
	end
	btn.MouseButton1Click:Connect(fire)
	btn.MouseButton1Down:Connect(function() end)
	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			fire()
		end
	end)
end

local function isGamepad(kc)
	local n = kc.Name
	return n:sub(1,6)=="Button" or n:sub(1,10)=="Thumbstick" or n:sub(1,4)=="DPad" or n=="ButtonSelect" or n=="ButtonStart"
end

local BLACKLISTED = {
	[Enum.KeyCode.Escape] = true,
	[Enum.KeyCode.LeftControl] = true,
	[Enum.KeyCode.Unknown] = true,
}

-- ===================== MAIN =====================
local MAIN_W, MAIN_H = 230, 118

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(MAIN_W, MAIN_H)
do
	local cam = workspace.CurrentCamera
	local vs = cam and cam.ViewportSize or Vector2.new(800, 600)
	local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	local useSaved = cfg.posX and cfg.posY and not isMobile
		and cfg.posX > -50 and cfg.posY > -50
		and cfg.posX < vs.X - 40 and cfg.posY < vs.Y - 40
	if useSaved then
		main.Position = UDim2.fromOffset(cfg.posX, cfg.posY)
	else
		main.Position = UDim2.new(0.5, -MAIN_W/2, 0.5, -MAIN_H/2)
	end
end
main.Visible = true
main.BackgroundColor3 = C.bg
main.BorderSizePixel = 0
main.Active = false
main.Parent = screen
-- Background artwork: upload the provided pumpkin image to Roblox and replace YOUR_IMAGE_ID.
local bgImage = Instance.new("ImageLabel")
bgImage.Name = "PumpkinBackground"
bgImage.Size = UDim2.fromScale(1, 1)
bgImage.Position = UDim2.fromScale(0, 0)
bgImage.BackgroundTransparency = 1
bgImage.Image = "rbxassetid://YOUR_IMAGE_ID"
bgImage.ScaleType = Enum.ScaleType.Crop
bgImage.ImageTransparency = 0.12
bgImage.ZIndex = 1
bgImage.Parent = main
corner(bgImage, 14)
main.BackgroundTransparency = 1
corner(main, 14)
stroke(main, C.orange1, 1.4, 0.3)
grad(main, C.bg, Color3.fromRGB(45, 20, 5), 150)

local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 34)
header.BackgroundColor3 = C.panel
header.BorderSizePixel = 0
header.Active = true
header.ZIndex = 2
corner(header, 14)
grad(header, C.orange1, C.orange2, 120)

local headerFill = Instance.new("Frame", main)
headerFill.Size = UDim2.new(1, 0, 0, 10)
headerFill.Position = UDim2.fromOffset(0, 24)
headerFill.BackgroundColor3 = C.panel
headerFill.BorderSizePixel = 0
headerFill.Active = false
headerFill.ZIndex = 2
grad(headerFill, C.orange1, C.orange2, 120)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -100, 1, 0)
title.Position = UDim2.fromOffset(10, 0)
title.BackgroundTransparency = 1
title.Text = "ZEYHUBB.VS PING LAG"
title.TextColor3 = C.white
title.Font = Enum.Font.GothamBlack
title.TextSize = 10
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3

local lockBtn = Instance.new("TextButton", header)
lockBtn.Size = UDim2.fromOffset(22, 22)
lockBtn.Position = UDim2.new(1, -86, 0.5, -11)
lockBtn.BackgroundColor3 = Color3.fromRGB(80, 35, 5)
lockBtn.Text = cfg.locked and "🔒" or "🔓"
lockBtn.TextSize = 11
lockBtn.AutoButtonColor = false
lockBtn.ZIndex = 4
corner(lockBtn, 6)

local statusPill = Instance.new("Frame", header)
statusPill.Size = UDim2.fromOffset(36, 16)
statusPill.Position = UDim2.new(1, -60, 0.5, -8)
statusPill.BackgroundColor3 = Color3.fromRGB(70, 25, 5)
statusPill.BorderSizePixel = 0
statusPill.ZIndex = 3
corner(statusPill, 8)

local statusLbl = Instance.new("TextLabel", statusPill)
statusLbl.Size = UDim2.fromScale(1, 1)
statusLbl.BackgroundTransparency = 1
statusLbl.Text = "OFF"
statusLbl.TextColor3 = C.red
statusLbl.Font = Enum.Font.GothamBlack
statusLbl.TextSize = 9
statusLbl.ZIndex = 4

local settingsBtn = Instance.new("TextButton", header)
settingsBtn.Size = UDim2.fromOffset(22, 22)
settingsBtn.Position = UDim2.new(1, -28, 0.5, -11)
settingsBtn.BackgroundColor3 = Color3.fromRGB(80, 35, 5)
settingsBtn.Text = "⚙"
settingsBtn.TextColor3 = C.white
settingsBtn.Font = Enum.Font.GothamBold
settingsBtn.TextSize = 12
settingsBtn.AutoButtonColor = false
settingsBtn.ZIndex = 4
corner(settingsBtn, 6)

makeDraggable(main, header)

local activateBtn = Instance.new("TextButton", main)
activateBtn.Size = UDim2.new(1, -16, 0, 28)
activateBtn.Position = UDim2.fromOffset(8, 40)
activateBtn.BackgroundColor3 = C.card
activateBtn.BorderSizePixel = 0
activateBtn.Text = ""
activateBtn.AutoButtonColor = false
activateBtn.Active = true
activateBtn.Selectable = true
activateBtn.ZIndex = 5
corner(activateBtn, 9)
local actGrad = grad(activateBtn, C.orange1, C.orange2, 135)
local actStroke = stroke(activateBtn, C.orange3, 1.1, 0.4)

local activateLbl = Instance.new("TextLabel", activateBtn)
activateLbl.Size = UDim2.fromScale(1, 1)
activateLbl.BackgroundTransparency = 1
activateLbl.Text = "ACTIVATE"
activateLbl.TextColor3 = C.white
activateLbl.Font = Enum.Font.GothamBlack
activateLbl.TextSize = 12
activateLbl.ZIndex = 4

local presetRow = Instance.new("Frame", main)
presetRow.Size = UDim2.new(1, -16, 0, 24)
presetRow.Position = UDim2.fromOffset(8, 72)
presetRow.BackgroundTransparency = 1
presetRow.Active = false
presetRow.ZIndex = 5

local presetBtns = {}
local function makePreset(name, order)
	local b = Instance.new("TextButton", presetRow)
	b.Size = UDim2.new(1/3, -4, 1, 0)
	b.Position = UDim2.new((order-1)/3, 2, 0, 0)
	b.BackgroundColor3 = C.card
	b.BorderSizePixel = 0
	b.Text = name
	b.TextColor3 = C.dim
	b.Font = Enum.Font.GothamBold
	b.TextSize = 10
	b.AutoButtonColor = false
	b.ZIndex = 4
	corner(b, 7)
	stroke(b, C.orange1, 1, 0.55)
	presetBtns[name] = b
	return b
end
makePreset("LOW", 1)
makePreset("MED", 2)
makePreset("HIGH", 3)

local discordLbl = Instance.new("TextLabel", main)
discordLbl.Size = UDim2.new(1, -10, 0, 14)
discordLbl.Position = UDim2.fromOffset(5, 98)
discordLbl.BackgroundTransparency = 1
discordLbl.Text = "ZeyHubb.vs"
discordLbl.TextColor3 = C.dim
discordLbl.Font = Enum.Font.Gotham
discordLbl.TextSize = 9
discordLbl.ZIndex = 3

-- ===================== SETTINGS =====================
local SET_W, SET_H = 240, 420

local settings = Instance.new("Frame")
settings.Name = "Settings"
settings.Size = UDim2.fromOffset(SET_W, SET_H)
settings.Position = UDim2.new(0.5, -SET_W/2, 0.5, -SET_H/2 + 40)
settings.BackgroundColor3 = C.panel
settings.BorderSizePixel = 0
settings.Visible = false
settings.ZIndex = 30
settings.ClipsDescendants = true
settings.Parent = screen
corner(settings, 14)
stroke(settings, C.orange2, 1.4, 0.25)
grad(settings, C.panel, Color3.fromRGB(28, 12, 3), 160)

local setHeader = Instance.new("Frame", settings)
setHeader.Size = UDim2.new(1, 0, 0, 34)
setHeader.BackgroundColor3 = C.orange1
setHeader.BorderSizePixel = 0
setHeader.ZIndex = 31
corner(setHeader, 14)
grad(setHeader, C.orange1, C.orange2, 120)

local setHeaderFill = Instance.new("Frame", settings)
setHeaderFill.Size = UDim2.new(1, 0, 0, 10)
setHeaderFill.Position = UDim2.fromOffset(0, 24)
setHeaderFill.BackgroundColor3 = C.orange1
setHeaderFill.BorderSizePixel = 0
setHeaderFill.ZIndex = 31
grad(setHeaderFill, C.orange1, C.orange2, 120)

local setTitle = Instance.new("TextLabel", setHeader)
setTitle.Size = UDim2.new(1, -40, 1, 0)
setTitle.Position = UDim2.fromOffset(12, 0)
setTitle.BackgroundTransparency = 1
setTitle.Text = "Settings"
setTitle.TextColor3 = C.white
setTitle.Font = Enum.Font.GothamBlack
setTitle.TextSize = 13
setTitle.TextXAlignment = Enum.TextXAlignment.Left
setTitle.ZIndex = 32

local setClose = Instance.new("TextButton", setHeader)
setClose.Size = UDim2.fromOffset(24, 24)
setClose.Position = UDim2.new(1, -30, 0.5, -12)
setClose.BackgroundColor3 = Color3.fromRGB(80, 35, 5)
setClose.Text = "X"
setClose.TextColor3 = C.white
setClose.Font = Enum.Font.GothamBold
setClose.TextSize = 12
setClose.AutoButtonColor = false
setClose.ZIndex = 32
corner(setClose, 6)

makeDraggable(settings, setHeader)

local scroll = Instance.new("ScrollingFrame", settings)
scroll.Size = UDim2.new(1, -16, 1, -48)
scroll.Position = UDim2.fromOffset(8, 42)
scroll.BackgroundTransparency = 1
scroll.BorderSizePixel = 0
scroll.ScrollBarThickness = 4
scroll.ScrollBarImageColor3 = C.orange3
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.ScrollingDirection = Enum.ScrollingDirection.Y
scroll.ZIndex = 31

local list = Instance.new("UIListLayout", scroll)
list.Padding = UDim.new(0, 7)
list.SortOrder = Enum.SortOrder.LayoutOrder

local pad = Instance.new("UIPadding", scroll)
pad.PaddingBottom = UDim.new(0, 10)
pad.PaddingTop = UDim.new(0, 2)

local function mkRow(height)
	local row = Instance.new("Frame", scroll)
	row.Size = UDim2.new(1, -4, 0, height or 36)
	row.BackgroundColor3 = C.card
	row.BorderSizePixel = 0
	row.ZIndex = 32
	corner(row, 9)
	stroke(row, C.orange1, 1, 0.55)
	return row
end

local function mkLabel(parent, text, x, w)
	local l = Instance.new("TextLabel", parent)
	l.Size = UDim2.new(w or 0.45, 0, 1, 0)
	l.Position = UDim2.fromOffset(x or 10, 0)
	l.BackgroundTransparency = 1
	l.Text = text
	l.TextColor3 = C.white
	l.Font = Enum.Font.GothamBold
	l.TextSize = 11
	l.TextXAlignment = Enum.TextXAlignment.Left
	l.ZIndex = 33
	return l
end

local powerRow = mkRow(36)
powerRow.LayoutOrder = 1
mkLabel(powerRow, "Power")
local powerBox = Instance.new("TextBox", powerRow)
powerBox.Size = UDim2.fromOffset(90, 24)
powerBox.Position = UDim2.new(1, -100, 0.5, -12)
powerBox.BackgroundColor3 = C.input
powerBox.BorderSizePixel = 0
powerBox.Text = tostring(cfg.power)
powerBox.TextColor3 = C.orange3
powerBox.Font = Enum.Font.GothamBold
powerBox.TextSize = 12
powerBox.ClearTextOnFocus = false
powerBox.ZIndex = 33
corner(powerBox, 7)
stroke(powerBox, C.orange2, 1, 0.45)

local delayRow = mkRow(36)
delayRow.LayoutOrder = 2
mkLabel(delayRow, "Delay (secs)")
local delayBox = Instance.new("TextBox", delayRow)
delayBox.Size = UDim2.fromOffset(90, 24)
delayBox.Position = UDim2.new(1, -100, 0.5, -12)
delayBox.BackgroundColor3 = C.input
delayBox.BorderSizePixel = 0
delayBox.Text = tostring(cfg.interval)
delayBox.TextColor3 = C.orange3
delayBox.Font = Enum.Font.GothamBold
delayBox.TextSize = 12
delayBox.ClearTextOnFocus = false
delayBox.ZIndex = 33
corner(delayBox, 7)
stroke(delayBox, C.orange2, 1, 0.45)

local strengthRow = mkRow(36)
strengthRow.LayoutOrder = 3
mkLabel(strengthRow, "Strength")
local strengthBtn = Instance.new("TextButton", strengthRow)
strengthBtn.Size = UDim2.fromOffset(100, 24)
strengthBtn.Position = UDim2.new(1, -110, 0.5, -12)
strengthBtn.BackgroundColor3 = C.input
strengthBtn.BorderSizePixel = 0
strengthBtn.Text = cfg.strength
strengthBtn.TextColor3 = C.orange3
strengthBtn.Font = Enum.Font.GothamBold
strengthBtn.TextSize = 11
strengthBtn.AutoButtonColor = false
strengthBtn.ZIndex = 33
corner(strengthBtn, 7)
stroke(strengthBtn, C.orange2, 1, 0.45)

local brRow = mkRow(36)
brRow.LayoutOrder = 4
mkLabel(brRow, "Auto Brainrot", 10, 0.65)
local brBtn = Instance.new("TextButton", brRow)
brBtn.Size = UDim2.fromOffset(52, 24)
brBtn.Position = UDim2.new(1, -62, 0.5, -12)
brBtn.BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(90, 35, 5)
brBtn.BorderSizePixel = 0
brBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
brBtn.TextColor3 = C.white
brBtn.Font = Enum.Font.GothamBlack
brBtn.TextSize = 11
brBtn.AutoButtonColor = false
brBtn.ZIndex = 33
corner(brBtn, 12)

local scaleRow = mkRow(36)
scaleRow.LayoutOrder = 5
mkLabel(scaleRow, "UI Scale", 10, 0.4)
local scaleMinus = Instance.new("TextButton", scaleRow)
scaleMinus.Size = UDim2.fromOffset(28, 24)
scaleMinus.Position = UDim2.new(1, -120, 0.5, -12)
scaleMinus.BackgroundColor3 = C.input
scaleMinus.Text = "−"
scaleMinus.TextColor3 = C.white
scaleMinus.Font = Enum.Font.GothamBold
scaleMinus.TextSize = 16
scaleMinus.AutoButtonColor = false
scaleMinus.ZIndex = 33
corner(scaleMinus, 7)

local scaleLbl = Instance.new("TextLabel", scaleRow)
scaleLbl.Size = UDim2.fromOffset(48, 24)
scaleLbl.Position = UDim2.new(1, -88, 0.5, -12)
scaleLbl.BackgroundColor3 = C.input
scaleLbl.Text = string.format("%.1f", cfg.uiScale)
scaleLbl.TextColor3 = C.orange3
scaleLbl.Font = Enum.Font.GothamBold
scaleLbl.TextSize = 12
scaleLbl.ZIndex = 33
corner(scaleLbl, 7)

local scalePlus = Instance.new("TextButton", scaleRow)
scalePlus.Size = UDim2.fromOffset(28, 24)
scalePlus.Position = UDim2.new(1, -36, 0.5, -12)
scalePlus.BackgroundColor3 = C.input
scalePlus.Text = "+"
scalePlus.TextColor3 = C.white
scalePlus.Font = Enum.Font.GothamBold
scalePlus.TextSize = 16
scalePlus.AutoButtonColor = false
scalePlus.ZIndex = 33
corner(scalePlus, 7)

local kbHeader = Instance.new("TextLabel", scroll)
kbHeader.Size = UDim2.new(1, -4, 0, 18)
kbHeader.BackgroundTransparency = 1
kbHeader.Text = "KEYBINDS  (click to reassign, X to remove)"
kbHeader.TextColor3 = C.dim
kbHeader.Font = Enum.Font.GothamBold
kbHeader.TextSize = 9
kbHeader.TextXAlignment = Enum.TextXAlignment.Left
kbHeader.LayoutOrder = 6
kbHeader.ZIndex = 32

local kbRow = mkRow(36)
kbRow.LayoutOrder = 7
mkLabel(kbRow, "Keyboard", 10, 0.4)
local kbBind = Instance.new("TextButton", kbRow)
kbBind.Size = UDim2.fromOffset(70, 24)
kbBind.Position = UDim2.new(1, -108, 0.5, -12)
kbBind.BackgroundColor3 = C.input
kbBind.Text = cfg.keybindKb
kbBind.TextColor3 = C.orange3
kbBind.Font = Enum.Font.GothamBold
kbBind.TextSize = 11
kbBind.AutoButtonColor = false
kbBind.ZIndex = 33
corner(kbBind, 7)
stroke(kbBind, C.orange2, 1, 0.5)
local kbClear = Instance.new("TextButton", kbRow)
kbClear.Size = UDim2.fromOffset(24, 24)
kbClear.Position = UDim2.new(1, -32, 0.5, -12)
kbClear.BackgroundColor3 = Color3.fromRGB(85, 30, 5)
kbClear.Text = "X"
kbClear.TextColor3 = C.red
kbClear.Font = Enum.Font.GothamBlack
kbClear.TextSize = 11
kbClear.AutoButtonColor = false
kbClear.ZIndex = 33
corner(kbClear, 7)

local gpRow = mkRow(36)
gpRow.LayoutOrder = 8
mkLabel(gpRow, "Controller", 10, 0.4)
local gpBind = Instance.new("TextButton", gpRow)
gpBind.Size = UDim2.fromOffset(80, 24)
gpBind.Position = UDim2.new(1, -118, 0.5, -12)
gpBind.BackgroundColor3 = C.input
gpBind.Text = cfg.keybindGp
gpBind.TextColor3 = C.orange3
gpBind.Font = Enum.Font.GothamBold
gpBind.TextSize = 10
gpBind.AutoButtonColor = false
gpBind.ZIndex = 33
corner(gpBind, 7)
stroke(gpBind, C.orange2, 1, 0.5)
local gpClear = Instance.new("TextButton", gpRow)
gpClear.Size = UDim2.fromOffset(24, 24)
gpClear.Position = UDim2.new(1, -32, 0.5, -12)
gpClear.BackgroundColor3 = Color3.fromRGB(85, 30, 5)
gpClear.Text = "X"
gpClear.TextColor3 = C.red
gpClear.Font = Enum.Font.GothamBlack
gpClear.TextSize = 11
gpClear.AutoButtonColor = false
gpClear.ZIndex = 33
corner(gpClear, 7)

local resetBtn = Instance.new("TextButton", scroll)
resetBtn.Size = UDim2.new(1, -4, 0, 32)
resetBtn.BackgroundColor3 = C.orange1
resetBtn.BorderSizePixel = 0
resetBtn.Text = "Reset Mode + Keybinds"
resetBtn.TextColor3 = C.white
resetBtn.Font = Enum.Font.GothamBold
resetBtn.TextSize = 12
resetBtn.AutoButtonColor = false
resetBtn.LayoutOrder = 9
resetBtn.ZIndex = 32
corner(resetBtn, 9)
grad(resetBtn, C.orange1, C.orange2, 135)

-- ===================== STRENGTH POPUP =====================
local strengthPanel = Instance.new("Frame")
strengthPanel.Name = "StrengthPanel"
strengthPanel.Size = UDim2.fromOffset(180, 280)
strengthPanel.Position = UDim2.new(0.5, -90, 0.5, -140)
strengthPanel.BackgroundColor3 = C.panel
strengthPanel.BorderSizePixel = 0
strengthPanel.Visible = false
strengthPanel.ZIndex = 50
strengthPanel.Parent = screen
corner(strengthPanel, 12)
stroke(strengthPanel, C.orange2, 1.3, 0.25)
grad(strengthPanel, C.panel, Color3.fromRGB(32, 14, 3), 150)

local spTitle = Instance.new("TextLabel", strengthPanel)
spTitle.Size = UDim2.new(1, -30, 0, 28)
spTitle.Position = UDim2.fromOffset(10, 4)
spTitle.BackgroundTransparency = 1
spTitle.Text = "Select Strength"
spTitle.TextColor3 = C.white
spTitle.Font = Enum.Font.GothamBold
spTitle.TextSize = 12
spTitle.TextXAlignment = Enum.TextXAlignment.Left
spTitle.ZIndex = 51

local spClose = Instance.new("TextButton", strengthPanel)
spClose.Size = UDim2.fromOffset(22, 22)
spClose.Position = UDim2.new(1, -28, 0, 6)
spClose.BackgroundColor3 = Color3.fromRGB(80, 35, 5)
spClose.Text = "X"
spClose.TextColor3 = C.white
spClose.Font = Enum.Font.GothamBold
spClose.TextSize = 11
spClose.AutoButtonColor = false
spClose.ZIndex = 51
corner(spClose, 6)

local spList = Instance.new("Frame", strengthPanel)
spList.Size = UDim2.new(1, -16, 1, -40)
spList.Position = UDim2.fromOffset(8, 34)
spList.BackgroundTransparency = 1
spList.ZIndex = 51
local spLayout = Instance.new("UIListLayout", spList)
spLayout.Padding = UDim.new(0, 5)

local strengthColors = {
	["Ultra Weak"] = Color3.fromRGB(255, 170, 90),
	["Extra Weak"] = Color3.fromRGB(255, 155, 55),
	["Weak"] = Color3.fromRGB(255, 135, 25),
	["Normal"] = C.white,
	["Strong"] = Color3.fromRGB(255, 200, 100),
	["Extra Strong"] = Color3.fromRGB(255, 160, 80),
	["Ultra Strong"] = Color3.fromRGB(255, 120, 80),
}

local function applyStrength(name)
	for _, s in ipairs(STRENGTHS) do
		if s.name == name then
			cfg.strength = name
			cfg.power = s.power
			powerBox.Text = tostring(cfg.power)
			strengthBtn.Text = name
			saveConfig()
			break
		end
	end
end

for _, s in ipairs(STRENGTHS) do
	local b = Instance.new("TextButton", spList)
	b.Size = UDim2.new(1, 0, 0, 30)
	b.BackgroundColor3 = C.card
	b.BorderSizePixel = 0
	b.Text = s.name
	b.TextColor3 = strengthColors[s.name] or C.white
	b.Font = Enum.Font.GothamBold
	b.TextSize = 12
	b.AutoButtonColor = false
	b.ZIndex = 52
	corner(b, 8)
	b.MouseButton1Click:Connect(function()
		applyStrength(s.name)
		strengthPanel.Visible = false
		strengthOpen = false
	end)
	b.MouseEnter:Connect(function() tw(b, {BackgroundColor3 = Color3.fromRGB(95, 42, 5)}, 0.1) end)
	b.MouseLeave:Connect(function() tw(b, {BackgroundColor3 = C.card}, 0.1) end)
end

-- ===================== LOGIC =====================
local function findRemote()
	local rrs = game:FindFirstChild("RobloxReplicatedStorage")
	if not rrs then return nil end
	local names = {"SetPlayerBlockList", "UpdatePlayerBlockList", "SetBlockList", "UpdateBlockList"}
	for _, name in ipairs(names) do
		local r = rrs:FindFirstChild(name)
		if r and r:IsA("RemoteEvent") then return r end
	end
	for _, c in ipairs(rrs:GetChildren()) do
		if c:IsA("RemoteEvent") and c.Name:find("Block") then return c end
	end
	return nil
end
remote = findRemote()

local function buildPayload(power)
	local mainT = {}
	local nested = {{}}
	local current = nested[1]
	for _ = 1, 186 do
		local n = {}
		table.insert(current, n)
		current = n
	end
	local maxRep = math.min(math.floor(power / 188), 10000)
	for _ = 1, maxRep do
		table.insert(mainT, nested)
	end
	return mainT
end

local function setUIActive(on)
	if on then
		actGrad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, C.orange2),
			ColorSequenceKeypoint.new(1, C.orange3),
		})
		activateLbl.Text = "ACTIVATED"
		actStroke.Color = C.white
		actStroke.Transparency = 0
		statusLbl.Text = "ON"
		statusLbl.TextColor3 = C.green
		tw(statusPill, {BackgroundColor3 = Color3.fromRGB(16, 50, 30)}, 0.15)
	else
		actGrad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, C.orange1),
			ColorSequenceKeypoint.new(1, C.orange2),
		})
		activateLbl.Text = "ACTIVATE"
		actStroke.Color = C.orange3
		actStroke.Transparency = 0.4
		statusLbl.Text = "OFF"
		statusLbl.TextColor3 = C.red
		tw(statusPill, {BackgroundColor3 = Color3.fromRGB(70, 25, 5)}, 0.15)
	end
end

local lagThread = nil
local function runPingLoop()
	local delay = cfg.interval
	while active do
		-- Harmless visual demo: intentionally does not send network requests.
		task.wait(math.clamp(cfg.interval, 0.04, 1))
	end
end

local function flipLag(state, isManual)
	if isManual then
		if brainrotMode then
			manualOverride = not state
		else
			manualOverride = false
		end
	end
	active = state
	if active then
		setUIActive(true)
		task.spawn(runPingLoop)
	else
		setUIActive(false)
	end
end

local function applyPreset(name)
	local p = PRESETS[name]
	if not p then return end
	cfg.power = p.power
	cfg.interval = p.interval
	powerBox.Text = tostring(cfg.power)
	delayBox.Text = tostring(cfg.interval)
	local best, bestDiff = "Normal", math.huge
	for _, s in ipairs(STRENGTHS) do
		local d = math.abs(s.power - p.power)
		if d < bestDiff then bestDiff, best = d, s.name end
	end
	cfg.strength = best
	strengthBtn.Text = best
	for n, b in pairs(presetBtns) do
		if n == name then
			b.BackgroundColor3 = C.orange1
			b.TextColor3 = C.white
		else
			b.BackgroundColor3 = C.card
			b.TextColor3 = C.dim
		end
	end
	saveConfig()
end

bindTap(activateBtn, function()
	flipLag(not active, true)
end)

for name, b in pairs(presetBtns) do
	bindTap(b, function() applyPreset(name) end)
end

bindTap(lockBtn, function()
	cfg.locked = not cfg.locked
	lockBtn.Text = cfg.locked and "🔒" or "🔓"
	saveConfig()
end)

local function openSettings()
	settingsOpen = true
	settings.Visible = true
	settings.Size = UDim2.fromOffset(SET_W, 0)
	tw(settings, {Size = UDim2.fromOffset(SET_W, SET_H)}, 0.2, Enum.EasingStyle.Back)
	powerBox.Text = tostring(cfg.power)
	delayBox.Text = tostring(cfg.interval)
	strengthBtn.Text = cfg.strength
	brBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
	brBtn.BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(90, 35, 5)
	scaleLbl.Text = string.format("%.1f", cfg.uiScale)
	kbBind.Text = cfg.keybindKb
	gpBind.Text = cfg.keybindGp
end

local function closeSettings()
	settingsOpen = false
	listeningFor = nil
	tw(settings, {Size = UDim2.fromOffset(SET_W, 0)}, 0.15)
	task.delay(0.16, function() settings.Visible = false end)
	strengthPanel.Visible = false
	strengthOpen = false
end

bindTap(settingsBtn, function()
	if settingsOpen then closeSettings() else openSettings() end
end)
bindTap(setClose, closeSettings)

bindTap(strengthBtn, function()
	strengthOpen = not strengthOpen
	strengthPanel.Visible = strengthOpen
end)
bindTap(spClose, function()
	strengthPanel.Visible = false
	strengthOpen = false
end)

powerBox.FocusLost:Connect(function()
	local n = tonumber(powerBox.Text)
	if n and n >= 1 then
		cfg.power = math.floor(n)
		powerBox.Text = tostring(cfg.power)
		saveConfig()
	else
		powerBox.Text = tostring(cfg.power)
	end
end)

delayBox.FocusLost:Connect(function()
	local n = tonumber(delayBox.Text)
	if n and n >= 0.01 then
		cfg.interval = n
		delayBox.Text = tostring(cfg.interval)
		saveConfig()
	else
		delayBox.Text = tostring(cfg.interval)
	end
end)

bindTap(brBtn, function()
	cfg.autoBrainrot = not cfg.autoBrainrot
	brBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
	tw(brBtn, {BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(90, 35, 5)}, 0.12)
	saveConfig()
end)

local function setScale(v)
	cfg.uiScale = math.clamp(math.floor(v * 10 + 0.5) / 10, 0.5, 1.8)
	rootScale.Scale = cfg.uiScale
	scaleLbl.Text = string.format("%.1f", cfg.uiScale)
	saveConfig()
end
bindTap(scaleMinus, function() setScale(cfg.uiScale - 0.1) end)
bindTap(scalePlus, function() setScale(cfg.uiScale + 0.1) end)

local function updateBindLabels()
	if listeningFor == "kb" then
		kbBind.Text = "..."
		kbBind.TextColor3 = C.waiting
	else
		kbBind.Text = cfg.keybindKb
		kbBind.TextColor3 = C.orange3
	end
	if listeningFor == "gp" then
		gpBind.Text = "..."
		gpBind.TextColor3 = C.waiting
	else
		gpBind.Text = cfg.keybindGp
		gpBind.TextColor3 = C.orange3
	end
end

kbBind.MouseButton1Click:Connect(function()
	listeningFor = (listeningFor == "kb") and nil or "kb"
	updateBindLabels()
end)
gpBind.MouseButton1Click:Connect(function()
	listeningFor = (listeningFor == "gp") and nil or "gp"
	updateBindLabels()
end)
kbClear.MouseButton1Click:Connect(function()
	cfg.keybindKb = "None"
	listeningFor = nil
	updateBindLabels()
	saveConfig()
end)
gpClear.MouseButton1Click:Connect(function()
	cfg.keybindGp = "None"
	listeningFor = nil
	updateBindLabels()
	saveConfig()
end)

resetBtn.MouseButton1Click:Connect(function()
	cfg.power = DEFAULT_CFG.power
	cfg.interval = DEFAULT_CFG.interval
	cfg.strength = DEFAULT_CFG.strength
	cfg.keybindKb = DEFAULT_CFG.keybindKb
	cfg.keybindGp = DEFAULT_CFG.keybindGp
	cfg.autoBrainrot = DEFAULT_CFG.autoBrainrot
	cfg.uiScale = DEFAULT_CFG.uiScale
	powerBox.Text = tostring(cfg.power)
	delayBox.Text = tostring(cfg.interval)
	strengthBtn.Text = cfg.strength
	brBtn.Text = "ON"
	brBtn.BackgroundColor3 = C.green
	setScale(1.0)
	updateBindLabels()
	saveConfig()
end)

RunService.Heartbeat:Connect(function()
	if not cfg.autoBrainrot then
		if brainrotMode then
			brainrotMode = false
			lastBrainrotState = false
		end
		return
	end
	local char = plr.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if not hum then return end
	local hasBrainrot = hum.WalkSpeed < 25
	if hasBrainrot and not lastBrainrotState then
		brainrotMode = true
		lastBrainrotState = true
		manualOverride = false
		flipLag(true)
	elseif not hasBrainrot and lastBrainrotState then
		brainrotMode = false
		lastBrainrotState = false
		manualOverride = false
		flipLag(false)
	end
end)

UserInputService.InputBegan:Connect(function(input, processed)
	local kc = input.KeyCode
	if kc == Enum.KeyCode.Unknown then return end
	local isGp = isGamepad(kc)
	local isKb = input.UserInputType == Enum.UserInputType.Keyboard

	if listeningFor then
		if kc == Enum.KeyCode.Escape then
			listeningFor = nil
			updateBindLabels()
			return
		end
		if listeningFor == "kb" and isKb and not BLACKLISTED[kc] then
			cfg.keybindKb = kc.Name
			listeningFor = nil
			updateBindLabels()
			saveConfig()
			return
		end
		if listeningFor == "gp" and isGp then
			cfg.keybindGp = kc.Name
			listeningFor = nil
			updateBindLabels()
			saveConfig()
			return
		end
		return
	end

	if processed then return end

	if kc == Enum.KeyCode.LeftControl then
		main.Visible = not main.Visible
		if not main.Visible then closeSettings() end
		return
	end

	local kbEnum = resolveKb(cfg.keybindKb)
	local gpEnum = resolveKb(cfg.keybindGp)
	if (kbEnum and kc == kbEnum and isKb) or (gpEnum and kc == gpEnum and isGp) then
		flipLag(not active, true)
	end
end)

local pill = Instance.new("TextButton")
pill.Name = "ZeyHubbReopen"
pill.Size = UDim2.fromOffset(130, 36)
pill.Position = UDim2.new(0.5, -65, 1, -90)
pill.AnchorPoint = Vector2.new(0, 0)
pill.BackgroundColor3 = C.bg
pill.BorderSizePixel = 0
pill.Text = "ZeyHubb.vs Ping Lag"
pill.TextColor3 = C.orange3
pill.Font = Enum.Font.GothamBlack
pill.TextSize = 12
pill.Visible = false
pill.ZIndex = 100
pill.Parent = screen
corner(pill, 12)
stroke(pill, C.orange2, 1.3, 0.3)

pill.MouseButton1Click:Connect(function()
	main.Visible = true
	pill.Visible = false
	main.Position = UDim2.new(0.5, -MAIN_W/2, 0.5, -MAIN_H/2)
end)

main:GetPropertyChangedSignal("Visible"):Connect(function()
	pill.Visible = not main.Visible
end)

main.Visible = true
screen.Enabled = true
print("[ZeyHubb.vs Ping Lag] loaded · GUI center · Ctrl/hide shows reopen pill")
print("[ZeyHubb.vs] parent =", screen.Parent and screen.Parent.Name)
