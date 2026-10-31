-- Sye Ping Lagger
-- Features: Auto Enable On Steal | Keybinds | Auto-save | Draggable toggle | Sye bg

local UserInputService = game:GetService("UserInputService")
local TweenService     = game:GetService("TweenService")
local HttpService      = game:GetService("HttpService")
local Players          = game:GetService("Players")
local RunService       = game:GetService("RunService")

local plr = Players.LocalPlayer
local plrGui = plr:WaitForChild("PlayerGui", 10)
if not plrGui then
	warn("[Sye Ping Lagger] PlayerGui not found")
	return
end

local CONFIG_FILE = "SyePingLagger_Config.json"

local DEFAULT_CFG = {
	power        = 97000,
	interval     = 0.055,
	keybindKb    = "F",
	keybindGp    = "ButtonR2",
	autoBrainrot = true,
	mainX        = nil,
	mainY        = nil,
	setX         = nil,
	setY         = nil,
	uiLocked     = false,
	halloweenMode = false,
	uiScale = 100,
	accentIndex = 1,
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
		cfg.keybindKb    = type(data.keybindKb) == "string" and data.keybindKb or DEFAULT_CFG.keybindKb
		cfg.keybindGp    = type(data.keybindGp) == "string" and data.keybindGp or DEFAULT_CFG.keybindGp
		if type(data.autoBrainrot) == "boolean" then cfg.autoBrainrot = data.autoBrainrot end
		cfg.mainX = tonumber(data.mainX)
		cfg.mainY = tonumber(data.mainY)
		cfg.setX  = tonumber(data.setX)
		cfg.setY  = tonumber(data.setY)
		if type(data.uiLocked) == "boolean" then cfg.uiLocked = data.uiLocked end
		if type(data.halloweenMode) == "boolean" then cfg.halloweenMode = data.halloweenMode end
		if data.uiScale then cfg.uiScale = math.clamp(tonumber(data.uiScale) or 100, 70, 140) end
		cfg.accentIndex = math.clamp(math.floor(tonumber(data.accentIndex) or 1), 1, 6)
	end)
	if not okLoad then warn("[Sye Ping Lagger] loadConfig failed") end
end
pcall(loadConfig)

local active, listeningFor, remote = false, nil, nil
local brainrotMode, lastBrainrotState, manualOverride = false, false, false
local settingsOpen = false

local C = {
	bg      = Color3.fromRGB(12, 8, 24),
	panel   = Color3.fromRGB(18, 12, 36),
	card    = Color3.fromRGB(28, 18, 48),
	input   = Color3.fromRGB(22, 14, 42),
	purple1 = Color3.fromRGB(100, 50, 180),
	purple2 = Color3.fromRGB(140, 80, 220),
	purple3 = Color3.fromRGB(180, 130, 255),
	white   = Color3.fromRGB(240, 235, 255),
	dim     = Color3.fromRGB(140, 120, 180),
	green   = Color3.fromRGB(90, 230, 140),
	red     = Color3.fromRGB(255, 100, 120),
	waiting = Color3.fromRGB(255, 190, 50),
	gray    = Color3.fromRGB(160, 160, 170),
}
local C_BASE = {}
for k, v in pairs(C) do C_BASE[k] = v end
local C_HALLOWEEN = {
	bg      = Color3.fromRGB(12, 6, 4),
	panel   = Color3.fromRGB(22, 10, 6),
	card    = Color3.fromRGB(36, 18, 8),
	input   = Color3.fromRGB(28, 14, 8),
	purple1 = Color3.fromRGB(220, 90, 20),
	purple2 = Color3.fromRGB(255, 140, 40),
	purple3 = Color3.fromRGB(255, 180, 80),
	white   = Color3.fromRGB(255, 245, 230),
	dim     = Color3.fromRGB(180, 120, 70),
	green   = Color3.fromRGB(90, 230, 140),
	red     = Color3.fromRGB(255, 80, 60),
	waiting = Color3.fromRGB(255, 190, 50),
	gray    = Color3.fromRGB(160, 120, 90),
}

local BG_IMAGE_ID = "119687938459170"

for _, n in ipairs({"SyePingLaggerGui"}) do
	local o = plrGui:FindFirstChild(n)
	if o then o:Destroy() end
end

local screen = Instance.new("ScreenGui")
screen.Name = "SyePingLaggerGui"
screen.ResetOnSpawn = false
screen.IgnoreGuiInset = true
screen.DisplayOrder = 999
screen.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screen.Enabled = true

local okParent = pcall(function() screen.Parent = plrGui end)
if not okParent or not screen.Parent then
	pcall(function() screen.Parent = game:GetService("CoreGui") end)
end
if not screen.Parent then
	warn("[Sye Ping Lagger] could not parent ScreenGui")
	return
end

local function tw(obj, props, t, style, dir)
	TweenService:Create(obj, TweenInfo.new(t or 0.15, style or Enum.EasingStyle.Quad, dir or Enum.EasingDirection.Out), props):Play()
end

local function corner(p, r)
	local c = Instance.new("UICorner", p)
	c.CornerRadius = UDim.new(0, r or 10)
	return c
end

local function stroke(p, col, th, tr)
	local s = Instance.new("UIStroke", p)
	s.Color = col or C.purple1
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

-- ============================================================
-- DRAG
-- ============================================================
local dragTargets = {}

local function registerDrag(frame, handle, saveX, saveY)
	table.insert(dragTargets, {frame = frame, handle = handle, saveX = saveX, saveY = saveY})
end

local dragging = false
local dragInfo = nil
local dragInput = nil

local function pointInGui(gui, pos)
	if not gui or not gui.Visible then return false end
	local abs = gui.AbsolutePosition
	local size = gui.AbsoluteSize
	return pos.X >= abs.X and pos.X <= abs.X + size.X
		and pos.Y >= abs.Y and pos.Y <= abs.Y + size.Y
end

local function stopDrag()
	if dragInfo and dragInfo.target then
		local t = dragInfo.target
		if t.saveX then cfg[t.saveX] = t.frame.Position.X.Offset end
		if t.saveY then cfg[t.saveY] = t.frame.Position.Y.Offset end
		saveConfig()
	end
	dragging = false
	dragInfo = nil
	dragInput = nil
end

UserInputService.InputBegan:Connect(function(input, processed)
	if input.UserInputType ~= Enum.UserInputType.MouseButton1
	and input.UserInputType ~= Enum.UserInputType.Touch then return end

	if dragging then return end

	if cfg.uiLocked then return end
	local pos = input.Position
	for i = #dragTargets, 1, -1 do
		local t = dragTargets[i]
		if pointInGui(t.handle, pos) then
			dragging = true
			dragInput = input
			dragInfo = {
				target = t,
				startPos = pos,
				startFrame = t.frame.Position,
			}
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					stopDrag()
				end
			end)
			return
		end
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if not dragging or not dragInfo or not dragInput then return end
	if input ~= dragInput then return end
	if input.UserInputType ~= Enum.UserInputType.MouseMovement
	and input.UserInputType ~= Enum.UserInputType.Touch then return end

	local d = input.Position - dragInfo.startPos
	local f = dragInfo.target.frame
	local sp = dragInfo.startFrame
	f.Position = UDim2.new(sp.X.Scale, sp.X.Offset + d.X, sp.Y.Scale, sp.Y.Offset + d.Y)
end)

UserInputService.InputEnded:Connect(function(input)
	if not dragging then return end
	if input ~= dragInput then return end
	stopDrag()
end)

-- ============================================================
-- bindTap
-- ============================================================
local function bindTap(btn, fn)
	btn.Active = true
	btn.Selectable = true

	local touchStart = nil
	local touchInput = nil

	local function fire()
		local now = os.clock()
		if now - (btn:GetAttribute("lastTap") or 0) < 0.25 then return end
		btn:SetAttribute("lastTap", now)
		fn()
	end

	btn.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.Touch then
			touchStart = input.Position
			touchInput = input
		end
	end)

	btn.InputChanged:Connect(function(input)
		if not touchStart or input ~= touchInput then return end
		if input.UserInputType ~= Enum.UserInputType.Touch then return end
		local d = (input.Position - touchStart).Magnitude
		if d > 8 then
			touchStart = nil
			touchInput = nil
		end
	end)

	btn.InputEnded:Connect(function(input)
		if input.UserInputType ~= Enum.UserInputType.Touch then return end
		if not touchStart or input ~= touchInput then
			touchStart = nil
			touchInput = nil
			return
		end
		local d = (input.Position - touchStart).Magnitude
		touchStart = nil
		touchInput = nil
		if d <= 8 then
			fire()
		end
	end)

	btn.MouseButton1Click:Connect(function()
		fire()
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

local function buildSyeBackground(parent, radius, imgTrans)
	local bg = Instance.new("ImageLabel", parent)
	bg.Name = "SyePingLaggerBg"
	bg.Size = UDim2.fromScale(1, 1)
	bg.Position = UDim2.fromScale(0, 0)
	bg.BackgroundTransparency = 1
	bg.Image = "rbxassetid://" .. BG_IMAGE_ID
	bg.ImageColor3 = Color3.fromRGB(255, 255, 255)
	bg.ImageTransparency = imgTrans or 0.15
	bg.ScaleType = Enum.ScaleType.Crop
	bg.ZIndex = 0
	corner(bg, radius)
	return bg
end

-- MAIN
local MAIN_W, MAIN_H = 230, 78

local main = Instance.new("Frame")
main.Name = "Main"
main.Size = UDim2.fromOffset(MAIN_W, MAIN_H)
do
	local cam = workspace.CurrentCamera
	local vs = cam and cam.ViewportSize or Vector2.new(800, 600)
	local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	local useSaved = cfg.mainX and cfg.mainY and not isMobile
		and cfg.mainX > -50 and cfg.mainY > -50
		and cfg.mainX < vs.X - 40 and cfg.mainY < vs.Y - 40
	if useSaved then
		main.Position = UDim2.fromOffset(cfg.mainX, cfg.mainY)
	else
		main.Position = UDim2.new(0.5, -MAIN_W/2, 0.5, -MAIN_H/2)
	end
end
main.Visible = true
main.BackgroundColor3 = C.bg
main.BackgroundTransparency = 0.15
main.BorderSizePixel = 0
main.Active = false
main.Parent = screen
corner(main, 14)
stroke(main, C.gray, 1.5, 0.2)

local mainScale = Instance.new("UIScale", main)
mainScale.Scale = (cfg.uiScale or 100) / 100

buildSyeBackground(main, 14, 0.20)

local header = Instance.new("Frame", main)
header.Size = UDim2.new(1, 0, 0, 34)
header.BackgroundTransparency = 1
header.BorderSizePixel = 0
header.Active = true
header.ZIndex = 2
corner(header, 14)

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, -80, 1, 0)
title.Position = UDim2.fromOffset(10, 0)
title.BackgroundTransparency = 1
title.Text = "SYE PING LAGGER"
title.TextColor3 = C.white
title.Font = Enum.Font.GothamBlack
title.TextSize = 10
title.TextXAlignment = Enum.TextXAlignment.Left
title.ZIndex = 3

local settingsBtn = Instance.new("TextButton", header)
settingsBtn.Size = UDim2.fromOffset(58, 22)
settingsBtn.Position = UDim2.new(1, -64, 0.5, -11)
settingsBtn.BackgroundColor3 = Color3.fromRGB(80, 35, 150)
settingsBtn.BorderSizePixel = 0
settingsBtn.Text = "Open"
settingsBtn.TextColor3 = C.white
settingsBtn.Font = Enum.Font.GothamBlack
settingsBtn.TextSize = 11
settingsBtn.AutoButtonColor = false
settingsBtn.ZIndex = 4
corner(settingsBtn, 6)
stroke(settingsBtn, C.purple2, 1, 0.4)

registerDrag(main, header, "mainX", "mainY")

local activateBtn = Instance.new("TextButton", main)
activateBtn.Size = UDim2.new(1, -16, 0, 32)
activateBtn.Position = UDim2.fromOffset(8, 40)
activateBtn.BackgroundColor3 = C.card
activateBtn.BackgroundTransparency = 0.15
activateBtn.BorderSizePixel = 0
activateBtn.Text = ""
activateBtn.AutoButtonColor = false
activateBtn.Active = true
activateBtn.Selectable = true
activateBtn.ZIndex = 5
corner(activateBtn, 9)
local actGrad = grad(activateBtn, C.purple1, C.purple2, 135)
local actStroke = stroke(activateBtn, C.gray, 1.4, 0.15)

local activateLbl = Instance.new("TextLabel", activateBtn)
activateLbl.Size = UDim2.fromScale(1, 1)
activateLbl.BackgroundTransparency = 1
activateLbl.Text = "DESACTIVATE"
activateLbl.TextColor3 = C.red
activateLbl.Font = Enum.Font.GothamBlack
activateLbl.TextSize = 12
activateLbl.ZIndex = 4

-- SETTINGS
local SET_W, SET_H = 280, 420

local settings = Instance.new("Frame")
settings.Name = "Settings"
settings.Size = UDim2.fromOffset(SET_W, SET_H)
do
	local cam = workspace.CurrentCamera
	local vs = cam and cam.ViewportSize or Vector2.new(800, 600)
	local isMobile = UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled
	local useSaved = cfg.setX and cfg.setY and not isMobile
		and cfg.setX > -50 and cfg.setY > -50
		and cfg.setX < vs.X - 40 and cfg.setY < vs.Y - 40
	if useSaved then
		settings.Position = UDim2.fromOffset(cfg.setX, cfg.setY)
	else
		settings.Position = UDim2.new(0.5, -SET_W/2, 0.5, -SET_H/2 + 40)
	end
end
settings.BackgroundColor3 = C.panel
settings.BackgroundTransparency = 0.15
settings.BorderSizePixel = 0
settings.Visible = false
settings.ZIndex = 30
settings.ClipsDescendants = true
settings.Parent = screen
corner(settings, 14)
stroke(settings, C.gray, 1.5, 0.2)

local settingsScale = Instance.new("UIScale", settings)
settingsScale.Scale = (cfg.uiScale or 100) / 100

buildSyeBackground(settings, 14, 0.15)

local setHeader = Instance.new("Frame", settings)
setHeader.Size = UDim2.new(1, 0, 0, 30)
setHeader.BackgroundTransparency = 1
setHeader.BorderSizePixel = 0
setHeader.ZIndex = 32
corner(setHeader, 14)

local setTitle = Instance.new("TextLabel", setHeader)
setTitle.Size = UDim2.new(1, -160, 1, 0)
setTitle.Position = UDim2.fromOffset(12, 0)
setTitle.BackgroundTransparency = 1
setTitle.Text = "Settings"
setTitle.TextColor3 = C.white
setTitle.Font = Enum.Font.GothamBlack
setTitle.TextSize = 13
setTitle.TextXAlignment = Enum.TextXAlignment.Left
setTitle.ZIndex = 33

local setClose = Instance.new("TextButton", setHeader)
setClose.Size = UDim2.fromOffset(24, 24)
setClose.Position = UDim2.new(1, -30, 0.5, -12)
setClose.BackgroundColor3 = Color3.fromRGB(80, 35, 150)
setClose.BorderSizePixel = 0
setClose.Text = "X"
setClose.TextColor3 = C.white
setClose.Font = Enum.Font.GothamBlack
setClose.TextSize = 13
setClose.AutoButtonColor = false
setClose.ZIndex = 33
corner(setClose, 6)
stroke(setClose, C.purple2, 1, 0.4)

local lockBtn = Instance.new("TextButton", setHeader)
lockBtn.Size = UDim2.fromOffset(24, 24)
lockBtn.Position = UDim2.new(1, -58, 0.5, -12)
lockBtn.BackgroundColor3 = Color3.fromRGB(80, 35, 150)
lockBtn.BorderSizePixel = 0
lockBtn.Text = cfg.uiLocked and "🔒" or "🔓"
lockBtn.TextColor3 = C.white
lockBtn.Font = Enum.Font.GothamBlack
lockBtn.TextSize = 12
lockBtn.AutoButtonColor = false
lockBtn.ZIndex = 33
corner(lockBtn, 6)
stroke(lockBtn, C.purple2, 1, 0.4)

-- UI size next to lock:  −  100%  +
local sizePlus = Instance.new("TextButton", setHeader)
sizePlus.Size = UDim2.fromOffset(22, 22)
sizePlus.Position = UDim2.new(1, -86, 0.5, -11)
sizePlus.BackgroundColor3 = Color3.fromRGB(80, 35, 150)
sizePlus.BorderSizePixel = 0
sizePlus.Text = "+"
sizePlus.TextColor3 = C.white
sizePlus.Font = Enum.Font.GothamBlack
sizePlus.TextSize = 14
sizePlus.AutoButtonColor = false
sizePlus.ZIndex = 33
corner(sizePlus, 6)
stroke(sizePlus, C.purple2, 1, 0.4)

local sizeLbl = Instance.new("TextLabel", setHeader)
sizeLbl.Size = UDim2.fromOffset(36, 22)
sizeLbl.Position = UDim2.new(1, -124, 0.5, -11)
sizeLbl.BackgroundTransparency = 1
sizeLbl.Text = tostring(cfg.uiScale or 100)
sizeLbl.TextColor3 = C.white
sizeLbl.Font = Enum.Font.GothamBold
sizeLbl.TextSize = 11
sizeLbl.ZIndex = 33

local sizeMinus = Instance.new("TextButton", setHeader)
sizeMinus.Size = UDim2.fromOffset(22, 22)
sizeMinus.Position = UDim2.new(1, -148, 0.5, -11)
sizeMinus.BackgroundColor3 = Color3.fromRGB(80, 35, 150)
sizeMinus.BorderSizePixel = 0
sizeMinus.Text = "−"
sizeMinus.TextColor3 = C.white
sizeMinus.Font = Enum.Font.GothamBlack
sizeMinus.TextSize = 14
sizeMinus.AutoButtonColor = false
sizeMinus.ZIndex = 33
corner(sizeMinus, 6)
stroke(sizeMinus, C.purple2, 1, 0.4)

local function applyUiScale(v)
	v = math.clamp(math.floor(v + 0.5), 70, 140)
	cfg.uiScale = v
	sizeLbl.Text = tostring(v)
	local s = v / 100
	if mainScale then mainScale.Scale = s end
	if settingsScale then settingsScale.Scale = s end
	saveConfig()
end

bindTap(sizeMinus, function() applyUiScale((cfg.uiScale or 100) - 10) end)
bindTap(sizePlus, function() applyUiScale((cfg.uiScale or 100) + 10) end)

bindTap(lockBtn, function()
	cfg.uiLocked = not cfg.uiLocked
	lockBtn.Text = cfg.uiLocked and "🔒" or "🔓"
	saveConfig()
end)

registerDrag(settings, setHeader, "setX", "setY")

-- TABS
local tabsFrame = Instance.new("Frame", settings)
tabsFrame.Size = UDim2.new(1, -16, 0, 30)
tabsFrame.Position = UDim2.fromOffset(8, 34)
tabsFrame.BackgroundTransparency = 1
tabsFrame.ZIndex = 33

local tabConfi = Instance.new("TextButton", tabsFrame)
tabConfi.Size = UDim2.new(1, 0, 1, 0)
tabConfi.Position = UDim2.fromOffset(0, 0)
tabConfi.BackgroundColor3 = C.purple1
tabConfi.BorderSizePixel = 0
tabConfi.Text = "CONFI"
tabConfi.TextColor3 = C.white
tabConfi.Font = Enum.Font.GothamBlack
tabConfi.TextSize = 12
tabConfi.AutoButtonColor = false
tabConfi.ZIndex = 34
corner(tabConfi, 8)

local tabKeyboard = Instance.new("TextButton", tabsFrame)
tabKeyboard.Visible = false
tabKeyboard.Size = UDim2.new(0, 0, 0, 0)
tabKeyboard.Text = "KEYBOARD"
tabKeyboard.BackgroundTransparency = 1
tabKeyboard.ZIndex = 1

local pages = Instance.new("Frame", settings)
pages.Size = UDim2.new(1, -16, 1, -72)
pages.Position = UDim2.fromOffset(8, 68)
pages.BackgroundTransparency = 1
pages.ZIndex = 33

-- ============================================================
-- PÁGINA CONFI
-- ============================================================
local pageConfi = Instance.new("ScrollingFrame", pages)
pageConfi.Size = UDim2.fromScale(1, 1)
pageConfi.BackgroundTransparency = 1
pageConfi.BorderSizePixel = 0
pageConfi.ScrollBarThickness = 4
pageConfi.ScrollBarImageColor3 = C.purple3
pageConfi.CanvasSize = UDim2.new(0, 0, 0, 0)
pageConfi.AutomaticCanvasSize = Enum.AutomaticSize.Y
pageConfi.ScrollingDirection = Enum.ScrollingDirection.Y
pageConfi.Visible = true
pageConfi.ZIndex = 34

local listConfi = Instance.new("UIListLayout", pageConfi)
listConfi.Padding = UDim.new(0, 8)
listConfi.SortOrder = Enum.SortOrder.LayoutOrder

local padConfi = Instance.new("UIPadding", pageConfi)
padConfi.PaddingTop = UDim.new(0, 2)
padConfi.PaddingBottom = UDim.new(0, 10)

-- STATUS (letra blanca)
local statusBig = Instance.new("TextLabel", pageConfi)
statusBig.Size = UDim2.new(1, -4, 0, 30)
statusBig.BackgroundColor3 = C.purple1
statusBig.BorderSizePixel = 0
statusBig.Text = "STATUS: OFF"
statusBig.TextColor3 = C.white
statusBig.Font = Enum.Font.GothamBlack
statusBig.TextSize = 12
statusBig.LayoutOrder = 0
statusBig.ZIndex = 35
corner(statusBig, 8)
local statusBigGrad = grad(statusBig, C.purple1, C.purple2, 135)
local statusBigStroke = stroke(statusBig, C.purple2, 1, 0.35)

local function mkRow(order, labelText)
	local row = Instance.new("Frame", pageConfi)
	row.Size = UDim2.new(1, -4, 0, 34)
	row.BackgroundColor3 = C.card
	row.BackgroundTransparency = 0.25
	row.BorderSizePixel = 0
	row.LayoutOrder = order
	row.ZIndex = 35
	corner(row, 9)
	stroke(row, C.purple1, 1, 0.55)

	local lbl = Instance.new("TextLabel", row)
	lbl.Size = UDim2.new(0.45, 0, 1, 0)
	lbl.Position = UDim2.fromOffset(10, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = labelText
	lbl.TextColor3 = C.white
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 11
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 36

	local box = Instance.new("TextBox", row)
	box.Size = UDim2.fromOffset(100, 22)
	box.Position = UDim2.new(1, -110, 0.5, -11)
	box.BackgroundColor3 = C.input
	box.BackgroundTransparency = 0.1
	box.BorderSizePixel = 0
	box.Text = ""
	box.TextColor3 = C.white
	box.Font = Enum.Font.GothamBold
	box.TextSize = 12
	box.ClearTextOnFocus = false
	box.ZIndex = 36
	corner(box, 7)

	return row, box
end

local powerRow, powerInput = mkRow(1, "Power")
powerInput.Text = tostring(cfg.power)

local delayRow, delayInput = mkRow(2, "Delay (secs)")
delayInput.Text = tostring(cfg.interval)

local brRow = Instance.new("Frame", pageConfi)
brRow.Size = UDim2.new(1, -4, 0, 34)
brRow.BackgroundColor3 = C.card
brRow.BackgroundTransparency = 0.25
brRow.BorderSizePixel = 0
brRow.LayoutOrder = 3
brRow.ZIndex = 35
corner(brRow, 9)
stroke(brRow, C.purple1, 1, 0.55)

local brLbl = Instance.new("TextLabel", brRow)
brLbl.Size = UDim2.new(0.65, 0, 1, 0)
brLbl.Position = UDim2.fromOffset(10, 0)
brLbl.BackgroundTransparency = 1
brLbl.Text = "Auto Enable On Steal"
brLbl.TextColor3 = C.white
brLbl.Font = Enum.Font.GothamBold
brLbl.TextSize = 11
brLbl.TextXAlignment = Enum.TextXAlignment.Left
brLbl.ZIndex = 36

local brBtn = Instance.new("TextButton", brRow)
brBtn.Size = UDim2.fromOffset(52, 22)
brBtn.Position = UDim2.new(1, -62, 0.5, -11)
brBtn.BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(70, 25, 40)
brBtn.BorderSizePixel = 0
brBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
brBtn.TextColor3 = C.white
brBtn.Font = Enum.Font.GothamBlack
brBtn.TextSize = 11
brBtn.AutoButtonColor = false
brBtn.ZIndex = 36
corner(brBtn, 12)

-- Halloween mode
local hwRow = Instance.new("Frame", pageConfi)
hwRow.Size = UDim2.new(1, -4, 0, 34)
hwRow.BackgroundColor3 = C.card
hwRow.BackgroundTransparency = 0.25
hwRow.BorderSizePixel = 0
hwRow.LayoutOrder = 3
hwRow.ZIndex = 35
corner(hwRow, 9)
stroke(hwRow, C.purple1, 1, 0.55)

local hwLbl = Instance.new("TextLabel", hwRow)
hwLbl.Size = UDim2.new(0.65, 0, 1, 0)
hwLbl.Position = UDim2.fromOffset(10, 0)
hwLbl.BackgroundTransparency = 1
hwLbl.Text = "Halloween Mode"
hwLbl.TextColor3 = C.white
hwLbl.Font = Enum.Font.GothamBold
hwLbl.TextSize = 11
hwLbl.TextXAlignment = Enum.TextXAlignment.Left
hwLbl.ZIndex = 36

local hwBtn = Instance.new("TextButton", hwRow)
hwBtn.Size = UDim2.fromOffset(52, 22)
hwBtn.Position = UDim2.new(1, -62, 0.5, -11)
hwBtn.BackgroundColor3 = cfg.halloweenMode and Color3.fromRGB(255, 140, 40) or Color3.fromRGB(70, 25, 40)
hwBtn.BorderSizePixel = 0
hwBtn.Text = cfg.halloweenMode and "ON" or "OFF"
hwBtn.TextColor3 = C.white
hwBtn.Font = Enum.Font.GothamBlack
hwBtn.TextSize = 11
hwBtn.AutoButtonColor = false
hwBtn.ZIndex = 36
corner(hwBtn, 12)

-- Accent color selector
local ACCENT_PRESETS = {
	{name = "Purple", c1 = Color3.fromRGB(100, 50, 180), c2 = Color3.fromRGB(140, 80, 220), c3 = Color3.fromRGB(180, 130, 255)},
	{name = "Blue",   c1 = Color3.fromRGB(35, 100, 210), c2 = Color3.fromRGB(55, 160, 255), c3 = Color3.fromRGB(140, 210, 255)},
	{name = "Pink",   c1 = Color3.fromRGB(190, 45, 125), c2 = Color3.fromRGB(245, 90, 175), c3 = Color3.fromRGB(255, 165, 215)},
	{name = "Red",    c1 = Color3.fromRGB(170, 35, 45), c2 = Color3.fromRGB(235, 65, 75), c3 = Color3.fromRGB(255, 145, 150)},
	{name = "Green",  c1 = Color3.fromRGB(25, 125, 75), c2 = Color3.fromRGB(45, 195, 115), c3 = Color3.fromRGB(135, 245, 180)},
	{name = "Gold",   c1 = Color3.fromRGB(165, 110, 20), c2 = Color3.fromRGB(235, 175, 45), c3 = Color3.fromRGB(255, 220, 125)},
}
local accentRow = Instance.new("Frame", pageConfi)
accentRow.Size = UDim2.new(1, -4, 0, 34)
accentRow.BackgroundColor3 = C.card
accentRow.BackgroundTransparency = 0.25
accentRow.BorderSizePixel = 0
accentRow.LayoutOrder = 4
accentRow.ZIndex = 35
corner(accentRow, 9)
stroke(accentRow, C.purple1, 1, 0.55)

local accentLbl = Instance.new("TextLabel", accentRow)
accentLbl.Size = UDim2.new(0.5, 0, 1, 0)
accentLbl.Position = UDim2.fromOffset(10, 0)
accentLbl.BackgroundTransparency = 1
accentLbl.Text = "Accent Color"
accentLbl.TextColor3 = C.white
accentLbl.Font = Enum.Font.GothamBold
accentLbl.TextSize = 11
accentLbl.TextXAlignment = Enum.TextXAlignment.Left
accentLbl.ZIndex = 36

local accentBtn = Instance.new("TextButton", accentRow)
accentBtn.Size = UDim2.fromOffset(100, 22)
accentBtn.Position = UDim2.new(1, -110, 0.5, -11)
accentBtn.BackgroundColor3 = C.purple1
accentBtn.BorderSizePixel = 0
accentBtn.TextColor3 = C.white
accentBtn.Font = Enum.Font.GothamBlack
accentBtn.TextSize = 11
accentBtn.AutoButtonColor = false
accentBtn.ZIndex = 36
corner(accentBtn, 7)

local function applyAccentColor(index)
	index = math.clamp(math.floor(tonumber(index) or 1), 1, #ACCENT_PRESETS)
	cfg.accentIndex = index
	local preset = ACCENT_PRESETS[index]
	C.purple1, C.purple2, C.purple3 = preset.c1, preset.c2, preset.c3
	C_BASE.purple1, C_BASE.purple2, C_BASE.purple3 = preset.c1, preset.c2, preset.c3
	accentBtn.Text = preset.name
	accentBtn.BackgroundColor3 = preset.c1
	local g = ColorSequence.new({ColorSequenceKeypoint.new(0, preset.c1), ColorSequenceKeypoint.new(1, preset.c2)})
	actGrad.Color = g
	statusBigGrad.Color = g
	statusBig.BackgroundColor3 = preset.c1
	statusBigStroke.Color = preset.c2
	pageConfi.ScrollBarImageColor3 = preset.c3
	tabConfi.BackgroundColor3 = preset.c1
	settingsBtn.BackgroundColor3 = preset.c1
	setClose.BackgroundColor3 = preset.c1
	lockBtn.BackgroundColor3 = preset.c1
	sizePlus.BackgroundColor3 = preset.c1
	sizeMinus.BackgroundColor3 = preset.c1
	for _, obj in ipairs({main, settings}) do
		for _, child in ipairs(obj:GetDescendants()) do
			if child:IsA("UIStroke") and child.Color ~= C.green and child.Color ~= C.red then
				child.Color = preset.c2
			end
		end
	end
	saveConfig()
end
bindTap(accentBtn, function()
	applyAccentColor((cfg.accentIndex % #ACCENT_PRESETS) + 1)
end)
applyAccentColor(cfg.accentIndex)

-- RESET CONFIG (letra blanca)
local resetCfgBtn = Instance.new("TextButton", pageConfi)
resetCfgBtn.Size = UDim2.new(1, -4, 0, 28)
resetCfgBtn.BackgroundColor3 = C.purple1
resetCfgBtn.BorderSizePixel = 0
resetCfgBtn.Text = "Reset Config"
resetCfgBtn.TextColor3 = C.white
resetCfgBtn.Font = Enum.Font.GothamBold
resetCfgBtn.TextSize = 11
resetCfgBtn.AutoButtonColor = false
resetCfgBtn.LayoutOrder = 7
resetCfgBtn.ZIndex = 35
corner(resetCfgBtn, 9)
grad(resetCfgBtn, C.purple1, C.purple2, 135)

-- ============================================================
-- PÁGINA KEYBOARD
-- ============================================================
local pageKb = Instance.new("ScrollingFrame", pages)
pageKb.Size = UDim2.fromScale(1, 1)
pageKb.BackgroundTransparency = 1
pageKb.BorderSizePixel = 0
pageKb.ScrollBarThickness = 4
pageKb.ScrollBarImageColor3 = C.purple3
pageKb.CanvasSize = UDim2.new(0, 0, 0, 0)
pageKb.AutomaticCanvasSize = Enum.AutomaticSize.Y
pageKb.ScrollingDirection = Enum.ScrollingDirection.Y
pageKb.Visible = false
pageKb.ZIndex = 34

local listKb = Instance.new("UIListLayout", pageKb)
listKb.Padding = UDim.new(0, 8)
listKb.SortOrder = Enum.SortOrder.LayoutOrder

local padKb = Instance.new("UIPadding", pageKb)
padKb.PaddingTop = UDim.new(0, 2)
padKb.PaddingBottom = UDim.new(0, 10)

local function mkKbRow(order, labelText, initialText)
	local row = Instance.new("Frame", pageConfi)
	row.Size = UDim2.new(1, -4, 0, 34)
	row.BackgroundColor3 = C.card
	row.BackgroundTransparency = 0.25
	row.BorderSizePixel = 0
	row.LayoutOrder = order
	row.ZIndex = 35
	corner(row, 9)
	stroke(row, C.purple1, 1, 0.55)

	local lbl = Instance.new("TextLabel", row)
	lbl.Size = UDim2.new(0.4, 0, 1, 0)
	lbl.Position = UDim2.fromOffset(10, 0)
	lbl.BackgroundTransparency = 1
	lbl.Text = labelText
	lbl.TextColor3 = C.white
	lbl.Font = Enum.Font.GothamBold
	lbl.TextSize = 11
	lbl.TextXAlignment = Enum.TextXAlignment.Left
	lbl.ZIndex = 36

	local bind = Instance.new("TextButton", row)
	bind.Size = UDim2.fromOffset(80, 22)
	bind.Position = UDim2.new(1, -118, 0.5, -11)
	bind.BackgroundColor3 = C.input
	bind.BackgroundTransparency = 0.1
	bind.Text = initialText
	bind.TextColor3 = C.white
	bind.Font = Enum.Font.GothamBold
	bind.TextSize = 11
	bind.AutoButtonColor = false
	bind.ZIndex = 36
	corner(bind, 7)

	local clear = Instance.new("TextButton", row)
	clear.Size = UDim2.fromOffset(24, 22)
	clear.Position = UDim2.new(1, -32, 0.5, -11)
	clear.BackgroundColor3 = Color3.fromRGB(60, 20, 35)
	clear.Text = "X"
	clear.TextColor3 = C.red
	clear.Font = Enum.Font.GothamBlack
	clear.TextSize = 11
	clear.AutoButtonColor = false
	clear.ZIndex = 36
	corner(clear, 7)

	return row, bind, clear
end

local kbRow, kbBind, kbClear = mkKbRow(4, "Keyboard", cfg.keybindKb)
local gpRow, gpBind, gpClear = mkKbRow(5, "Controller", cfg.keybindGp)

-- RESET KEYBINDS on CONFI page
local resetKbBtn = Instance.new("TextButton", pageConfi)
resetKbBtn.Size = UDim2.new(1, -4, 0, 28)
resetKbBtn.BackgroundColor3 = C.purple1
resetKbBtn.BorderSizePixel = 0
resetKbBtn.Text = "Reset Keybinds"
resetKbBtn.TextColor3 = C.white
resetKbBtn.Font = Enum.Font.GothamBold
resetKbBtn.TextSize = 11
resetKbBtn.AutoButtonColor = false
resetKbBtn.LayoutOrder = 6
resetKbBtn.ZIndex = 35
corner(resetKbBtn, 9)
grad(resetKbBtn, C.purple1, C.purple2, 135)

local function switchTab(which)
	pageConfi.Visible = true
	pageKb.Visible = false
end

bindTap(tabConfi, function() switchTab("confi") end)


-- ============================================================
-- LOGIC
-- ============================================================
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
			ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 160, 80)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 230, 140)),
		})
		activateLbl.Text = "ACTIVATE"
		activateLbl.TextColor3 = C.green
		actStroke.Color = C.green
		actStroke.Transparency = 0
		tw(main, {
			BackgroundColor3 = Color3.fromRGB(20, 80, 45),
			BackgroundTransparency = 0.15,
		}, 0.2)
		statusBig.Text = "STATUS: ON"
		statusBig.TextColor3 = C.white
		statusBigGrad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, Color3.fromRGB(40, 160, 80)),
			ColorSequenceKeypoint.new(1, Color3.fromRGB(90, 230, 140)),
		})
		statusBigStroke.Color = C.green
	else
		actGrad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, C.purple1),
			ColorSequenceKeypoint.new(1, C.purple2),
		})
		activateLbl.Text = "DESACTIVATE"
		activateLbl.TextColor3 = C.red
		actStroke.Color = C.gray
		actStroke.Transparency = 0.15
		tw(main, {
			BackgroundColor3 = C.bg,
			BackgroundTransparency = 0.15,
		}, 0.2)
		statusBig.Text = "STATUS: OFF"
		statusBig.TextColor3 = C.white
		statusBigGrad.Color = ColorSequence.new({
			ColorSequenceKeypoint.new(0, C.purple1),
			ColorSequenceKeypoint.new(1, C.purple2),
		})
		statusBigStroke.Color = C.purple2
	end
end

local function runPingLoop()
	local delay = cfg.interval
	while active and remote do
		local payload = buildPayload(cfg.power)
		local ok = pcall(function() remote:FireServer(payload) end)
		if not ok then
			delay = math.min(delay * 1.5, 0.5)
		else
			delay = math.max(delay * 0.995, 0.04)
		end
		task.wait(delay)
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
		if not remote then
			remote = findRemote()
			if not remote then
				active = false
				setUIActive(false)
				return
			end
		end
		setUIActive(true)
		task.spawn(runPingLoop)
	else
		setUIActive(false)
	end
end

bindTap(activateBtn, function()
	flipLag(not active, true)
end)

-- ============================================================
-- OPEN / CLOSE lateral
-- ============================================================
local function openSettings()
	settingsOpen = true
	settings.ClipsDescendants = true

	settings.AnchorPoint = Vector2.new(0.5, 0)
	settings.Position = UDim2.new(0.5, 0, settings.Position.Y.Scale, settings.Position.Y.Offset)

	settings.Visible = true
	settings.Size = UDim2.fromOffset(0, SET_H)
	tw(settings, {
		Size = UDim2.fromOffset(SET_W, SET_H),
	}, 0.22, Enum.EasingStyle.Back, Enum.EasingDirection.Out)

	powerInput.Text = tostring(cfg.power)
	delayInput.Text = tostring(cfg.interval)
	brBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
	brBtn.BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(70, 25, 40)
	kbBind.Text = cfg.keybindKb
	gpBind.Text = cfg.keybindGp
	statusBig.Text = active and "STATUS: ON" or "STATUS: OFF"
end

local function closeSettings()
	settingsOpen = false
	listeningFor = nil

	settings.AnchorPoint = Vector2.new(0.5, 0)
	settings.Position = UDim2.new(0.5, 0, settings.Position.Y.Scale, settings.Position.Y.Offset)

	tw(settings, {
		Size = UDim2.fromOffset(0, SET_H),
	}, 0.18, Enum.EasingStyle.Quad, Enum.EasingDirection.In)

	task.delay(0.19, function()
		settings.Visible = false
		settings.Size = UDim2.fromOffset(SET_W, SET_H)
	end)
end

bindTap(settingsBtn, function()
	if settingsOpen then closeSettings() else openSettings() end
end)
bindTap(setClose, closeSettings)

powerInput.FocusLost:Connect(function()
	local n = tonumber(powerInput.Text)
	if n and n >= 1 then
		cfg.power = math.floor(n)
		powerInput.Text = tostring(cfg.power)
		saveConfig()
	else
		powerInput.Text = tostring(cfg.power)
	end
end)

delayInput.FocusLost:Connect(function()
	local n = tonumber(delayInput.Text)
	if n and n >= 0.01 then
		cfg.interval = n
		delayInput.Text = tostring(cfg.interval)
		saveConfig()
	else
		delayInput.Text = tostring(cfg.interval)
	end
end)

bindTap(brBtn, function()
	cfg.autoBrainrot = not cfg.autoBrainrot
	brBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
	tw(brBtn, {BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(70, 25, 40)}, 0.12)
	saveConfig()
end)

local function updateBindLabels()
	if listeningFor == "kb" then
		kbBind.Text = "..."
		kbBind.TextColor3 = C.waiting
	else
		kbBind.Text = cfg.keybindKb
		kbBind.TextColor3 = C.white
	end
	if listeningFor == "gp" then
		gpBind.Text = "..."
		gpBind.TextColor3 = C.waiting
	else
		gpBind.Text = cfg.keybindGp
		gpBind.TextColor3 = C.white
	end
end

bindTap(kbBind, function()
	listeningFor = (listeningFor == "kb") and nil or "kb"
	updateBindLabels()
end)
bindTap(gpBind, function()
	listeningFor = (listeningFor == "gp") and nil or "gp"
	updateBindLabels()
end)
bindTap(kbClear, function()
	cfg.keybindKb = "None"
	listeningFor = nil
	updateBindLabels()
	saveConfig()
end)
bindTap(gpClear, function()
	cfg.keybindGp = "None"
	listeningFor = nil
	updateBindLabels()
	saveConfig()
end)

bindTap(resetCfgBtn, function()
	cfg.power        = DEFAULT_CFG.power
	cfg.interval     = DEFAULT_CFG.interval
	cfg.autoBrainrot = DEFAULT_CFG.autoBrainrot
	powerInput.Text = tostring(cfg.power)
	delayInput.Text = tostring(cfg.interval)
	brBtn.Text = cfg.autoBrainrot and "ON" or "OFF"
	brBtn.BackgroundColor3 = cfg.autoBrainrot and C.green or Color3.fromRGB(70, 25, 40)
	saveConfig()
end)

bindTap(resetKbBtn, function()
	cfg.keybindKb = DEFAULT_CFG.keybindKb
	cfg.keybindGp = DEFAULT_CFG.keybindGp
	listeningFor = nil
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
pill.Name = "SyePingLaggerReopen"
pill.Size = UDim2.fromOffset(130, 36)
pill.Position = UDim2.new(0.5, -65, 1, -90)
pill.AnchorPoint = Vector2.new(0, 0)
pill.BackgroundColor3 = C.bg
pill.BorderSizePixel = 0
pill.Text = "Sye Ping Lagger"
pill.TextColor3 = C.purple3
pill.Font = Enum.Font.GothamBlack
pill.TextSize = 12
pill.Visible = false
pill.ZIndex = 100
pill.Parent = screen
corner(pill, 12)
stroke(pill, C.purple2, 1.3, 0.3)

bindTap(pill, function()
	main.Visible = true
	pill.Visible = false
	main.Position = UDim2.new(0.5, -MAIN_W/2, 0.5, -MAIN_H/2)
end)

main:GetPropertyChangedSignal("Visible"):Connect(function()
	pill.Visible = not main.Visible
end)

main.Visible = true
screen.Enabled = true

local function applyHalloweenTheme(on)
	local src = on and C_HALLOWEEN or C_BASE
	for k, v in pairs(src) do C[k] = v end
	-- restyle main surfaces
	pcall(function()
		main.BackgroundColor3 = C.bg
		settings.BackgroundColor3 = C.panel
		if not active then
			actGrad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, C.purple1),
				ColorSequenceKeypoint.new(1, C.purple2),
			})
			actStroke.Color = C.gray
			statusBig.BackgroundColor3 = C.purple1
			statusBigGrad.Color = ColorSequence.new({
				ColorSequenceKeypoint.new(0, C.purple1),
				ColorSequenceKeypoint.new(1, C.purple2),
			})
			statusBigStroke.Color = C.purple2
		end
		title.Text = on and "🎃 SYE PING LAGGER" or "SYE PING LAGGER"
		title.TextColor3 = on and C.purple3 or C.white
		tabConfi.BackgroundColor3 = C.purple1
		settingsBtn.BackgroundColor3 = on and Color3.fromRGB(180, 70, 20) or Color3.fromRGB(80, 35, 150)
		setClose.BackgroundColor3 = settingsBtn.BackgroundColor3
		lockBtn.BackgroundColor3 = settingsBtn.BackgroundColor3
		if sizePlus then sizePlus.BackgroundColor3 = settingsBtn.BackgroundColor3 end
		if sizeMinus then sizeMinus.BackgroundColor3 = settingsBtn.BackgroundColor3 end
		hwBtn.Text = on and "ON" or "OFF"
		hwBtn.BackgroundColor3 = on and Color3.fromRGB(255, 140, 40) or Color3.fromRGB(70, 25, 40)
	end)
end

bindTap(hwBtn, function()
	cfg.halloweenMode = not cfg.halloweenMode
	applyHalloweenTheme(cfg.halloweenMode)
	saveConfig()
end)

if cfg.halloweenMode then
	applyHalloweenTheme(true)
end

print("[Sye Ping Lagger] loaded")