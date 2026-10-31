--[[
	carve.cc  |  LocalScript
	Put this in StarterPlayer > StarterPlayerScripts (as a LocalScript).

	Tabs: Main, Player, Aim, Gun, ???, Local Players, Visuals, Hit Marks, Settings
	Bind a key:   click a bind button, then press a key / mouse button / controller button
	Clear a bind: click it, then press Backspace      Cancel: Esc
	Clear ALL binds: Settings > Keybinds > Unkeybind all
]]

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local GuiService = game:GetService("GuiService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local playerGui = player:WaitForChild("PlayerGui")
local startClock = os.clock()

-- Hit sounds. Paste your Roblox audio IDs here (rbxassetid://123456789 or just the number).
-- You can also paste IDs live in Hit Marks > Hit sounds. Roblox only plays audio that is public
-- or owned by you / your experience.
local hitSounds = {
	{ name = "UwU girl", id = "8323804973" },
	{ name = "Laser", id = "" },
	{ name = "Normal hitmark", id = "160432334" },
	{ name = "Meow", id = "7079272452" },
	{ name = "Bonk", id = "5451260445" },
	{ name = "Custom hitmark", id = "" },
}

local oldGui = playerGui:FindFirstChild("CarveCC")
if oldGui then
	oldGui:Destroy()
end

--------------------------------------------------------------------------
-- Theme
--------------------------------------------------------------------------
local THEME = {
	bg = Color3.fromRGB(9, 9, 11),
	panel = Color3.fromRGB(17, 17, 20),
	card = Color3.fromRGB(22, 22, 26),
	stroke = Color3.fromRGB(44, 44, 52),
	text = Color3.fromRGB(235, 235, 240),
	sub = Color3.fromRGB(140, 140, 152),
	accent = Color3.fromRGB(180, 10, 16),
}

--------------------------------------------------------------------------
-- Helpers
--------------------------------------------------------------------------
local connections = {}
local accentRefs = {} -- { instance, property } pairs that follow the UI accent color
local toggleObjs = {} -- refresh functions for every toggle (used when the accent changes)

local function connect(signal, fn)
	local c = signal:Connect(fn)
	table.insert(connections, c)
	return c
end

local function create(class, props)
	local inst = Instance.new(class)
	if inst:IsA("GuiObject") then
		inst.BorderSizePixel = 0
	end
	local parent
	for key, value in pairs(props) do
		if key == "Parent" then
			parent = value
		else
			inst[key] = value
			if typeof(value) == "Color3" and value == THEME.accent then
				table.insert(accentRefs, { inst, key })
			end
		end
	end
	inst.Parent = parent
	return inst
end

local function round(inst, radius)
	return create("UICorner", { CornerRadius = UDim.new(0, radius), Parent = inst })
end

local function outline(inst, color, thickness)
	return create("UIStroke", {
		Color = color or THEME.stroke,
		Thickness = thickness or 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = inst,
	})
end

local function padding(inst, l, t, r, b)
	return create("UIPadding", {
		PaddingLeft = UDim.new(0, l),
		PaddingTop = UDim.new(0, t),
		PaddingRight = UDim.new(0, r or l),
		PaddingBottom = UDim.new(0, b or t),
		Parent = inst,
	})
end

local function listLayout(inst, gap)
	return create("UIListLayout", {
		Padding = UDim.new(0, gap),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = inst,
	})
end

local function makeLabel(props)
	props.BackgroundTransparency = 1
	props.Font = props.Font or Enum.Font.GothamMedium
	props.TextSize = props.TextSize or 13
	props.TextColor3 = props.TextColor3 or THEME.text
	props.TextXAlignment = props.TextXAlignment or Enum.TextXAlignment.Left
	return create("TextLabel", props)
end

local function isGamepadType(inputType)
	return inputType.Name:sub(1, 7) == "Gamepad"
end

-- Drag `target` by grabbing `handle`. If the pointer barely moved, it counts as a click.
local function makeDraggable(handle, target, onClick)
	local dragging, moved = false, false
	local startPointer, startPos

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging, moved = true, false
			startPointer = input.Position
			startPos = target.Position
		end
	end)

	local c1 = UserInputService.InputChanged:Connect(function(input)
		if not dragging then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			local delta = input.Position - startPointer
			if delta.Magnitude > 5 then
				moved = true
			end
			if moved then
				target.Position = UDim2.new(
					startPos.X.Scale, startPos.X.Offset + delta.X,
					startPos.Y.Scale, startPos.Y.Offset + delta.Y
				)
			end
		end
	end)

	local c2 = UserInputService.InputEnded:Connect(function(input)
		if not dragging then
			return
		end
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
			if not moved and onClick then
				onClick()
			end
		end
	end)

	target.Destroying:Connect(function()
		c1:Disconnect()
		c2:Disconnect()
	end)
end

--------------------------------------------------------------------------
-- State + keybinds
--------------------------------------------------------------------------
local state = {
	walk = { on = false, value = 50 },
	velocity = { on = false, value = 50 }, -- player: sets horizontal speed directly (non-slippery)
	animSpeed = { value = 100 }, -- player: animation speed scale in percent (100 = normal)
	jump = { on = false, value = 100 },
	fly = { on = false, value = 100 },
	range = { on = false }, -- gun: infinite range
	btp = { on = false }, -- gun: bullet TP
	rapid = { on = false, value = 15 }, -- gun: rapid fire (shots per second)
	orbit = { on = false, speed = 180, radius = 12, height = 0 }, -- speed in degrees per second
	above = { on = false, height = 15 }, -- stay above player
	hitbox = { on = false, size = 10, visual = false }, -- aim tab: hitbox expander
	wallbang = { on = false }, -- ???: wallbang
	silent = { on = false, part = 1, useFov = true, fov = 150, drawLine = false, sticky = false, knock = true, health = false, minHealth = 5, center = false, status = true }, -- aim tab: silent aim (part 1-3: Head, Torso, Random)
	desync = { on = false, mode = 1, dist = 20, ghost = true }, -- ???: desync (mode 1-4: Random, Spin, Up, Velocity)
	trigger = { on = false, delay = 50, interval = 100, part = 1, team = true, onlyTarget = false, needKey = false, radius = 0, range = 500 }, -- ???: triggerbot (part 1-3: Any, Head, Torso)
	aa = { on = false, angle = 90, base = 180, speed = 30, random = false, pitch = 0 }, -- ???: jitter anti aim
	aim = { on = false, fov = 150, smooth = 20, part = "Head", team = true, wall = false, notify = true },
	visuals = { fov = true },
	esp = {
		on = false,
		box = true,
		health = true, -- health bar (no number)
		name = true,
		skeleton = false,
		headDot = false,
		held = false, -- held item
		distance = false,
		tracers = false,
		team = false,
		nameSize = 14,
		healthWidth = 2, -- health bar width in pixels
		boxSize = 75, -- percent of the full character height
		font = 2, -- index into fonts below (used by name, held item and distance text)
		fonts = {
			{ "Monospaced", Enum.Font.Code },
			{ "Original", Enum.Font.GothamBold },
			{ "Serif Heavy", Enum.Font:FromName("Merriweather") or Enum.Font.Bodoni },
			{ "Gothic", Enum.Font:FromName("GrenzeGotisch") or Enum.Font.Antique },
		},
	},
	snap = { on = false, color = Color3.fromRGB(255, 255, 255), thickness = 2, team = false, auto = true, targetOnly = false },
	cross = { on = false, style = 1, size = 14, thickness = 2, gap = 4, speed = 180, follow = false, hideCursor = false, color = Color3.fromRGB(255, 255, 255) },
	hit = {
		chams = true,
		chamFill = Color3.fromRGB(255, 60, 60),
		chamOutline = Color3.fromRGB(255, 255, 255),
		chamFillT = 50, -- percent
		chamTime = 6, -- tenths of a second
		marker = true,
		sound = false,
		soundIndex = 1,
		volume = 50, -- percent
	},
	fpsBoost = false,
	menuKeys = true,
}

local whitelist = {} -- [Player] = true : the aimbot ignores these players
local aimTarget = nil -- Player : the aimbot only locks onto this player

local bindRefreshers = {} -- one refresh function per bind button (used by "Unkeybind all")

-- kb = keyboard / mouse bind, pad = controller bind
local binds = {
	menu = { kb = Enum.KeyCode.RightShift, pad = Enum.KeyCode.ButtonSelect },
	walk = { kb = Enum.KeyCode.Z, pad = Enum.KeyCode.DPadLeft },
	velocity = { kb = Enum.KeyCode.C },
	jump = { kb = Enum.KeyCode.X, pad = Enum.KeyCode.DPadRight },
	fly = { kb = Enum.KeyCode.F, pad = Enum.KeyCode.DPadUp },
	aimToggle = { kb = Enum.KeyCode.G, pad = Enum.KeyCode.DPadDown },
	rapid = { kb = Enum.KeyCode.V },
	orbit = { kb = Enum.KeyCode.B },
	desync = { kb = Enum.KeyCode.N },
	trigger = { kb = Enum.KeyCode.J },
	aa = { kb = Enum.KeyCode.K },
	target = { kb = Enum.KeyCode.T }, -- target / untarget the player closest to your mouse
	aim = { kb = Enum.UserInputType.MouseButton2, pad = Enum.KeyCode.ButtonL2 }, -- hold to aim
}

--------------------------------------------------------------------------
-- Root GUI, notifications, FOV circle
--------------------------------------------------------------------------
local gui = create("ScreenGui", {
	Name = "CarveCC",
	ResetOnSpawn = false,
	IgnoreGuiInset = true,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
	DisplayOrder = 100,
	Parent = playerGui,
})

local notifyHolder = create("Frame", {
	BackgroundTransparency = 1,
	AnchorPoint = Vector2.new(0.5, 0),
	Position = UDim2.new(0.5, 0, 0, 20),
	Size = UDim2.fromOffset(280, 300),
	ZIndex = 50,
	Parent = gui,
})
create("UIListLayout", {
	Padding = UDim.new(0, 6),
	HorizontalAlignment = Enum.HorizontalAlignment.Center,
	SortOrder = Enum.SortOrder.LayoutOrder,
	Parent = notifyHolder,
})

local function notify(message)
	local toast = create("Frame", {
		Size = UDim2.fromOffset(250, 34),
		BackgroundColor3 = THEME.panel,
		BackgroundTransparency = 1,
		ZIndex = 51,
		Parent = notifyHolder,
	})
	round(toast, 8)
	local stroke = outline(toast, THEME.accent)
	stroke.Transparency = 1
	local msg = makeLabel({
		Text = message,
		TextTransparency = 1,
		TextXAlignment = Enum.TextXAlignment.Center,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 52,
		Parent = toast,
	})

	local fadeIn = TweenInfo.new(0.2)
	TweenService:Create(toast, fadeIn, { BackgroundTransparency = 0.05 }):Play()
	TweenService:Create(stroke, fadeIn, { Transparency = 0 }):Play()
	TweenService:Create(msg, fadeIn, { TextTransparency = 0 }):Play()

	task.delay(2, function()
		if not toast.Parent then
			return
		end
		local fadeOut = TweenInfo.new(0.3)
		TweenService:Create(toast, fadeOut, { BackgroundTransparency = 1 }):Play()
		TweenService:Create(stroke, fadeOut, { Transparency = 1 }):Play()
		TweenService:Create(msg, fadeOut, { TextTransparency = 1 }):Play()
	end)
	task.delay(2.4, function()
		toast:Destroy()
	end)
end

local fovCircle = create("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(300, 300),
	BackgroundTransparency = 1,
	Visible = false,
	ZIndex = 5,
	Parent = gui,
})
create("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = fovCircle })
outline(fovCircle, THEME.accent, 1)

local function updateFov()
	fovCircle.Size = UDim2.fromOffset(state.aim.fov * 2, state.aim.fov * 2)
	fovCircle.Visible = state.visuals.fov and state.aim.on
end

--------------------------------------------------------------------------
-- Window shell: title (top left), sidebar tabs, pages
--------------------------------------------------------------------------
local espRoot = create("Frame", {
	Name = "ESP",
	BackgroundTransparency = 1,
	Size = UDim2.fromScale(1, 1),
	Parent = gui,
})

local window = create("Frame", {
	Name = "Window",
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(620, 400),
	BackgroundColor3 = THEME.bg,
	Parent = gui,
})
round(window, 10)
outline(window)

local uiScale = create("UIScale", { Parent = window })
local function refreshScale()
	local size = gui.AbsoluteSize
	uiScale.Scale = math.clamp(math.min(size.X / 660, size.Y / 440), 0.45, 1)
end
refreshScale()
connect(gui:GetPropertyChangedSignal("AbsoluteSize"), refreshScale)

local titleBar = create("Frame", {
	Size = UDim2.new(1, 0, 0, 40),
	BackgroundColor3 = THEME.panel,
	Parent = window,
})
round(titleBar, 10)
create("Frame", { -- squares off the bottom corners of the title bar
	Position = UDim2.new(0, 0, 1, -10),
	Size = UDim2.new(1, 0, 0, 10),
	BackgroundColor3 = THEME.panel,
	Parent = titleBar,
})

makeLabel({
	Text = 'carve<font color="#B40A10">.cc</font>',
	RichText = true,
	Font = Enum.Font.GothamBold,
	TextSize = 18,
	Position = UDim2.fromOffset(14, 0),
	Size = UDim2.new(0, 160, 1, 0),
	Parent = titleBar,
})

local hideButton = create("TextButton", {
	AnchorPoint = Vector2.new(1, 0.5),
	Position = UDim2.new(1, -10, 0.5, 0),
	Size = UDim2.fromOffset(28, 28),
	BackgroundColor3 = THEME.card,
	Text = "×",
	Font = Enum.Font.GothamBold,
	TextSize = 18,
	TextColor3 = THEME.text,
	Parent = titleBar,
})
round(hideButton, 6)

makeDraggable(titleBar, window)

local sidebar = create("Frame", {
	Position = UDim2.fromOffset(8, 48),
	Size = UDim2.new(0, 128, 1, -56),
	BackgroundColor3 = THEME.panel,
	Parent = window,
})
round(sidebar, 8)
outline(sidebar)
padding(sidebar, 6, 6)
listLayout(sidebar, 4)

local content = create("Frame", {
	Position = UDim2.fromOffset(144, 48),
	Size = UDim2.new(1, -152, 1, -56),
	BackgroundTransparency = 1,
	ClipsDescendants = true,
	Parent = window,
})

local tabNames = { "Main", "Player", "Aim", "Gun", "???", "Local Players", "Visuals", "Hit Marks", "Settings" }
local pages, tabButtons = {}, {}

local function selectTab(name)
	for n, page in pairs(pages) do
		page.Visible = (n == name)
	end
	for n, btn in pairs(tabButtons) do
		local active = (n == name)
		btn.BackgroundColor3 = active and THEME.card or THEME.panel
		btn.TextColor3 = active and THEME.text or THEME.sub
		btn.Bar.Visible = active
	end
end

for _, name in ipairs(tabNames) do
	local page = create("ScrollingFrame", {
		Size = UDim2.fromScale(1, 1),
		BackgroundTransparency = 1,
		ScrollBarThickness = 3,
		ScrollBarImageColor3 = THEME.stroke,
		CanvasSize = UDim2.new(),
		AutomaticCanvasSize = Enum.AutomaticSize.Y,
		Visible = false,
		Parent = content,
	})
	listLayout(page, 8)
	padding(page, 0, 0, 6, 0)
	pages[name] = page

	local btn = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 32),
		BackgroundColor3 = THEME.panel,
		AutoButtonColor = false,
		Text = "   " .. name,
		Font = Enum.Font.GothamMedium,
		TextSize = 13,
		TextColor3 = THEME.sub,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = sidebar,
	})
	round(btn, 6)
	local bar = create("Frame", {
		Name = "Bar",
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.new(0, 3, 0.6, 0),
		BackgroundColor3 = THEME.accent,
		Visible = false,
		Parent = btn,
	})
	round(bar, 2)
	btn.Activated:Connect(function()
		selectTab(name)
	end)
	tabButtons[name] = btn
end

--------------------------------------------------------------------------
-- Menu open/close (+ floating button for touch, or when menu keybinds are off)
--------------------------------------------------------------------------
local menuOpen = true
local booting = true -- true while the boot screen plays (the menu key is ignored until it ends)

local function setMenuOpen(value)
	menuOpen = value
	window.Visible = value
	if value then
		if isGamepadType(UserInputService:GetLastInputType()) then
			GuiService.SelectedObject = tabButtons.Main -- lets the controller navigate the menu
		end
	else
		GuiService.SelectedObject = nil -- gives the thumbstick back to the character
	end
end

hideButton.Activated:Connect(function()
	setMenuOpen(false)
end)

local fab = create("TextButton", {
	Size = UDim2.fromOffset(44, 44),
	Position = UDim2.new(0, 12, 0.5, 0),
	BackgroundColor3 = THEME.bg,
	AutoButtonColor = false,
	Text = "c",
	Font = Enum.Font.GothamBold,
	TextSize = 20,
	TextColor3 = THEME.accent,
	ZIndex = 30,
	Parent = gui,
})
round(fab, 22)
outline(fab, THEME.accent)
makeDraggable(fab, fab, function()
	if booting then
		return
	end
	setMenuOpen(not menuOpen)
end)

-- the round button also shows when the menu has no keybind left (so you can always reopen it)
local function updateFab()
	local m = binds.menu
	fab.Visible = UserInputService.TouchEnabled or not state.menuKeys or (m.kb == nil and m.pad == nil)
end
updateFab()

--------------------------------------------------------------------------
-- Feature logic: walkspeed, jump boost, fly
--------------------------------------------------------------------------
local function getHumanoid()
	local char = player.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	return hum, char
end

local syncers = {}
local applyFns = {}

local function onChange(name, fn)
	syncers[name] = syncers[name] or {}
	table.insert(syncers[name], fn)
end

local function setEnabled(name, value)
	state[name].on = value
	if applyFns[name] then
		applyFns[name](value)
	end
	for _, fn in ipairs(syncers[name] or {}) do
		fn(value)
	end
end

local originals = { walk = 16, jumpPower = 50, jumpUse = true }

applyFns.walk = function(on)
	local hum = getHumanoid()
	if on then
		if hum then
			originals.walk = hum.WalkSpeed
		end
	elseif hum then
		hum.WalkSpeed = originals.walk
	end
end

applyFns.jump = function(on)
	local hum = getHumanoid()
	if on then
		if hum then
			originals.jumpUse = hum.UseJumpPower
			originals.jumpPower = hum.JumpPower
		end
	elseif hum then
		hum.UseJumpPower = originals.jumpUse
		hum.JumpPower = originals.jumpPower
	end
end

-- Fly
local flyObjs = {}

local function stopFly()
	if flyObjs.bv then
		flyObjs.bv:Destroy()
	end
	if flyObjs.bg then
		flyObjs.bg:Destroy()
	end
	flyObjs = {}
	local hum = getHumanoid()
	if hum then
		hum.PlatformStand = false
	end
end

local function startFly()
	local hum, char = getHumanoid()
	local root = char and char:FindFirstChild("HumanoidRootPart")
	if not (hum and root) then
		return
	end
	if flyObjs.bv then
		flyObjs.bv:Destroy()
	end
	if flyObjs.bg then
		flyObjs.bg:Destroy()
	end
	flyObjs = {
		bv = create("BodyVelocity", {
			MaxForce = Vector3.new(1e9, 1e9, 1e9),
			Velocity = Vector3.zero,
			Parent = root,
		}),
		bg = create("BodyGyro", {
			MaxTorque = Vector3.new(1e9, 1e9, 1e9),
			P = 9e4,
			CFrame = root.CFrame,
			Parent = root,
		}),
	}
	hum.PlatformStand = true
end

applyFns.fly = function(on)
	if on then
		startFly()
	else
		stopFly()
	end
end

-- Reads WASD / left stick / mobile joystick through Roblox's own control module.
local controls
task.spawn(function()
	local ok, module = pcall(function()
		return require(player:WaitForChild("PlayerScripts"):WaitForChild("PlayerModule", 10))
	end)
	if ok and module then
		local ok2, c = pcall(function()
			return module:GetControls()
		end)
		if ok2 then
			controls = c
		end
	end
end)

local function getMoveVector()
	if controls then
		local ok, v = pcall(function()
			return controls:GetMoveVector()
		end)
		if ok and typeof(v) == "Vector3" then
			return v
		end
	end
	local hum = getHumanoid()
	local cam = Workspace.CurrentCamera
	if hum and cam then
		local rel = cam.CFrame:VectorToObjectSpace(hum.MoveDirection)
		return Vector3.new(rel.X, 0, rel.Z)
	end
	return Vector3.zero
end

local function flyStep(hum, char)
	local root = char:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end
	local bv, bg = flyObjs.bv, flyObjs.bg
	if not bv or bv.Parent ~= root or not bg or bg.Parent ~= root then
		startFly()
		bv, bg = flyObjs.bv, flyObjs.bg
		if not bv then
			return
		end
	end

	local cf = Workspace.CurrentCamera.CFrame
	local move = getMoveVector()
	local dir = cf.RightVector * move.X + cf.LookVector * (-move.Z)

	local up = 0
	if
		UserInputService:IsKeyDown(Enum.KeyCode.Space)
		or UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonA)
		or hum.Jump
	then
		up += 1
	end
	if
		UserInputService:IsKeyDown(Enum.KeyCode.LeftControl)
		or UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonB)
	then
		up -= 1
	end
	dir += Vector3.new(0, up, 0)

	bv.Velocity = dir.Magnitude > 0 and dir.Unit * state.fly.value or Vector3.zero
	bg.CFrame = cf
end

connect(RunService.Heartbeat, function()
	local hum, char = getHumanoid()
	if not hum then
		return
	end
	if state.walk.on and hum.WalkSpeed ~= state.walk.value then
		hum.WalkSpeed = state.walk.value
	end
	if state.jump.on then
		if not hum.UseJumpPower then
			hum.UseJumpPower = true
		end
		if hum.JumpPower ~= state.jump.value then
			hum.JumpPower = state.jump.value
		end
	end
	if state.fly.on then
		flyStep(hum, char)
	end
end)

--------------------------------------------------------------------------
-- Input / keybind capture
--------------------------------------------------------------------------
local capturing -- { kind, btn, refresh, assign }

local function endCapture()
	if capturing then
		local c = capturing
		capturing = nil
		c.refresh()
	end
end

local function beginCapture(kind, btn, refresh, assign)
	endCapture()
	capturing = { kind = kind, btn = btn, refresh = refresh, assign = assign }
end

local function bindLabel(kind, item)
	local prefix = (kind == "kb") and "Key: " or "Pad: "
	if not item then
		return prefix .. "None"
	end
	local n = item.Name
	n = n:gsub("^MouseButton", "Mouse ")
	if kind == "pad" then
		n = n:gsub("^Button", "")
	end
	return prefix .. n
end

local function matches(input, bind)
	return bind ~= nil and (input.KeyCode == bind or input.UserInputType == bind)
end

local aimHeld = false

local actions = {
	menu = {
		press = function()
			if state.menuKeys and not booting then
				setMenuOpen(not menuOpen)
			end
		end,
	},
	walk = { press = function() setEnabled("walk", not state.walk.on) end },
	velocity = { press = function() setEnabled("velocity", not state.velocity.on) end },
	jump = { press = function() setEnabled("jump", not state.jump.on) end },
	fly = { press = function() setEnabled("fly", not state.fly.on) end },
	aimToggle = { press = function() setEnabled("aim", not state.aim.on) end },
	rapid = { press = function() setEnabled("rapid", not state.rapid.on) end },
	orbit = { press = function() setEnabled("orbit", not state.orbit.on) end },
	desync = { press = function() setEnabled("desync", not state.desync.on) end },
	trigger = { press = function() setEnabled("trigger", not state.trigger.on) end },
	aa = { press = function() setEnabled("aa", not state.aa.on) end },
	aim = {
		press = function() aimHeld = true end,
		release = function() aimHeld = false end,
	},
}

connect(UserInputService.InputBegan, function(input, processed)
	-- 1) rebinding in progress
	if capturing then
		local c = capturing
		local ut, kc = input.UserInputType, input.KeyCode
		if kc == Enum.KeyCode.Escape then
			endCapture()
			return
		end
		if kc == Enum.KeyCode.Backspace then
			capturing = nil
			c.assign(nil)
			c.refresh()
			return
		end
		local chosen
		if c.kind == "kb" then
			if ut == Enum.UserInputType.Keyboard then
				chosen = kc
			elseif ut == Enum.UserInputType.MouseButton2 or ut == Enum.UserInputType.MouseButton3 then
				chosen = ut
			end
		else
			if isGamepadType(ut) and kc ~= Enum.KeyCode.Unknown then
				chosen = kc
			end
		end
		if chosen then
			capturing = nil
			c.assign(chosen)
			c.refresh()
		end
		return
	end

	-- 2) normal keybinds
	if UserInputService:GetFocusedTextBox() then
		return
	end
	if processed and not isGamepadType(input.UserInputType) then
		return
	end
	for name, action in pairs(actions) do
		local b = binds[name]
		if b and (matches(input, b.kb) or matches(input, b.pad)) then
			action.press()
		end
	end
end)

connect(UserInputService.InputEnded, function(input)
	for name, action in pairs(actions) do
		if action.release then
			local b = binds[name]
			if b and (matches(input, b.kb) or matches(input, b.pad)) then
				action.release()
			end
		end
	end
end)

--------------------------------------------------------------------------
-- UI components
--------------------------------------------------------------------------
local function makeCard(page, title)
	local card = create("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundColor3 = THEME.card,
		Parent = page,
	})
	round(card, 8)
	outline(card)
	padding(card, 10, 8)
	listLayout(card, 6)
	if title then
		makeLabel({
			Text = title,
			Font = Enum.Font.GothamBold,
			TextColor3 = THEME.accent,
			Size = UDim2.new(1, 0, 0, 18),
			Parent = card,
		})
	end
	return card
end

local function makeButton(parent, text, callback)
	local btn = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 30),
		BackgroundColor3 = THEME.panel,
		Text = text,
		Font = Enum.Font.GothamMedium,
		TextSize = 13,
		TextColor3 = THEME.text,
		Parent = parent,
	})
	round(btn, 6)
	outline(btn)
	btn.Activated:Connect(function()
		callback(btn)
	end)
	return btn
end

local function makeToggle(parent, text, initial, onChanged)
	local value = initial
	local row = create("TextButton", {
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Text = text,
		Font = Enum.Font.GothamMedium,
		TextSize = 13,
		TextColor3 = THEME.text,
		TextXAlignment = Enum.TextXAlignment.Left,
		Parent = parent,
	})
	local pill = create("Frame", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.fromOffset(40, 20),
		BackgroundColor3 = THEME.stroke,
		Parent = row,
	})
	round(pill, 10)
	local knob = create("Frame", {
		AnchorPoint = Vector2.new(0, 0.5),
		Position = UDim2.new(0, 3, 0.5, 0),
		Size = UDim2.fromOffset(14, 14),
		BackgroundColor3 = THEME.text,
		Parent = pill,
	})
	round(knob, 7)

	local obj = {}
	function obj.setVisual(v)
		value = v
		local info = TweenInfo.new(0.15)
		TweenService:Create(pill, info, { BackgroundColor3 = v and THEME.accent or THEME.stroke }):Play()
		TweenService:Create(knob, info, {
			Position = v and UDim2.new(1, -17, 0.5, 0) or UDim2.new(0, 3, 0.5, 0),
		}):Play()
	end
	row.Activated:Connect(function()
		local nv = not value
		onChanged(nv)
		obj.setVisual(nv)
	end)
	obj.setVisual(initial)
	table.insert(toggleObjs, function()
		obj.setVisual(value)
	end)
	return obj
end

local function makeSlider(parent, text, min, max, initial, onChanged)
	local step = math.max(1, math.ceil((max - min) / 40))
	local value = initial

	local frame = create("Frame", {
		Size = UDim2.new(1, 0, 0, 48),
		BackgroundTransparency = 1,
		Parent = parent,
	})
	makeLabel({ Text = text, Size = UDim2.new(1, -120, 0, 22), Parent = frame })

	local function smallButton(txt, xOffset)
		local b = create("TextButton", {
			AnchorPoint = Vector2.new(1, 0),
			Position = UDim2.new(1, xOffset, 0, 0),
			Size = UDim2.fromOffset(22, 22),
			BackgroundColor3 = THEME.panel,
			Text = txt,
			Font = Enum.Font.GothamBold,
			TextSize = 14,
			TextColor3 = THEME.text,
			Parent = frame,
		})
		round(b, 5)
		return b
	end
	local minus = smallButton("-", -84)
	local plus = smallButton("+", 0)

	local box = create("TextBox", {
		AnchorPoint = Vector2.new(1, 0),
		Position = UDim2.new(1, -26, 0, 0),
		Size = UDim2.fromOffset(54, 22),
		BackgroundColor3 = THEME.panel,
		Text = "",
		ClearTextOnFocus = false,
		Font = Enum.Font.GothamMedium,
		TextSize = 12,
		TextColor3 = THEME.text,
		Parent = frame,
	})
	round(box, 5)

	local bar = create("Frame", {
		Position = UDim2.new(0, 0, 0, 34),
		Size = UDim2.new(1, 0, 0, 6),
		BackgroundColor3 = THEME.panel,
		Parent = frame,
	})
	round(bar, 3)
	local fill = create("Frame", {
		Size = UDim2.fromScale(0, 1),
		BackgroundColor3 = THEME.accent,
		Parent = bar,
	})
	round(fill, 3)
	local knob = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0, 0.5),
		Size = UDim2.fromOffset(12, 12),
		BackgroundColor3 = THEME.text,
		ZIndex = 2,
		Parent = bar,
	})
	round(knob, 6)
	local hit = create("TextButton", {
		Position = UDim2.new(0, 0, 0, 26),
		Size = UDim2.new(1, 0, 0, 22),
		BackgroundTransparency = 1,
		AutoButtonColor = false,
		Selectable = false,
		Text = "",
		ZIndex = 3,
		Parent = frame,
	})

	local function setValue(v)
		v = math.clamp(math.floor(v + 0.5), min, max)
		value = v
		local a = (v - min) / (max - min)
		fill.Size = UDim2.fromScale(a, 1)
		knob.Position = UDim2.fromScale(a, 0.5)
		box.Text = tostring(v)
		onChanged(v)
	end

	local dragging = false
	local scroller
	local function fromX(x)
		local a = math.clamp((x - bar.AbsolutePosition.X) / math.max(bar.AbsoluteSize.X, 1), 0, 1)
		setValue(min + (max - min) * a)
	end

	hit.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			scroller = frame:FindFirstAncestorOfClass("ScrollingFrame")
			if scroller then
				scroller.ScrollingEnabled = false
			end
			fromX(input.Position.X)
		end
	end)
	connect(UserInputService.InputChanged, function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
			fromX(input.Position.X)
		end
	end)
	connect(UserInputService.InputEnded, function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
			dragging = false
			if scroller then
				scroller.ScrollingEnabled = true
			end
		end
	end)

	minus.Activated:Connect(function()
		setValue(value - step)
	end)
	plus.Activated:Connect(function()
		setValue(value + step)
	end)
	box.FocusLost:Connect(function()
		local n = tonumber(box.Text)
		if n then
			setValue(n)
		else
			box.Text = tostring(value)
		end
	end)

	setValue(initial)
	return setValue
end

local function makeBindRow(parent, text, name)
	local row = create("Frame", {
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundTransparency = 1,
		Parent = parent,
	})
	makeLabel({ Text = text, Size = UDim2.new(1, -272, 1, 0), Parent = row })

	for i, kind in ipairs({ "kb", "pad" }) do
		local btn = create("TextButton", {
			AnchorPoint = Vector2.new(1, 0.5),
			Position = UDim2.new(1, -(2 - i) * 136, 0.5, 0),
			Size = UDim2.fromOffset(132, 24),
			BackgroundColor3 = THEME.panel,
			Text = "",
			Font = Enum.Font.GothamMedium,
			TextSize = 11,
			TextColor3 = THEME.text,
			Parent = row,
		})
		round(btn, 5)
		outline(btn)

		local function refresh()
			btn.Text = bindLabel(kind, binds[name][kind])
		end
		refresh()
		table.insert(bindRefreshers, refresh)

		btn.Activated:Connect(function()
			if capturing and capturing.btn == btn then
				endCapture()
				return
			end
			beginCapture(kind, btn, refresh, function(v)
				binds[name][kind] = v
				updateFab() -- keeps the round menu button visible if the menu bind gets cleared
			end)
			btn.Text = "Press input..."
		end)
	end
end

local function featureCard(page, name, title, sliderText, minV, maxV)
	local card = makeCard(page, title)
	local t = makeToggle(card, "Enabled", false, function(v)
		setEnabled(name, v)
	end)
	onChange(name, t.setVisual)
	makeSlider(card, sliderText, minV, maxV, state[name].value, function(v)
		state[name].value = v
	end)
	makeBindRow(card, "Keybind", name)
end

local function statRow(parent, name)
	local row = create("Frame", {
		Size = UDim2.new(1, 0, 0, 22),
		BackgroundTransparency = 1,
		Parent = parent,
	})
	makeLabel({ Text = name, TextColor3 = THEME.sub, Size = UDim2.fromScale(0.5, 1), Parent = row })
	return makeLabel({
		Text = "--",
		TextXAlignment = Enum.TextXAlignment.Right,
		Position = UDim2.fromScale(0.5, 0),
		Size = UDim2.fromScale(0.5, 1),
		Parent = row,
	})
end

local function loadThumbnail(imageLabel, userId)
	task.spawn(function()
		local ok, img = pcall(function()
			return Players:GetUserThumbnailAsync(userId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size150x150)
		end)
		if ok and imageLabel.Parent then
			imageLabel.Image = img
		end
	end)
end

--------------------------------------------------------------------------
-- Aimbot
--------------------------------------------------------------------------
local lockedPlayer
local rayParams = RaycastParams.new()
rayParams.FilterType = Enum.RaycastFilterType.Exclude

local function getTargetPart(char)
	if state.aim.part == "Head" then
		return char:FindFirstChild("Head")
	end
	return char:FindFirstChild("HumanoidRootPart")
end

local function validTarget(plr)
	if whitelist[plr] or (aimTarget and plr ~= aimTarget) then
		return false
	end
	if plr == player then
		return false
	end
	local char = plr.Character
	if not char then
		return false
	end
	local hum = char:FindFirstChildOfClass("Humanoid")
	if not hum or hum.Health <= 0 then
		return false
	end
	if state.aim.team and plr.Team ~= nil and plr.Team == player.Team then
		return false
	end
	local part = getTargetPart(char)
	if not part then
		return false
	end
	return true, part
end

local function isVisible(part, char, cam)
	if not state.aim.wall then
		return true
	end
	rayParams.FilterDescendantsInstances = { player.Character }
	local origin = cam.CFrame.Position
	local result = Workspace:Raycast(origin, part.Position - origin, rayParams)
	return result == nil or result.Instance:IsDescendantOf(char)
end

local function aimPoint(cam)
	local last = UserInputService:GetLastInputType()
	if UserInputService.MouseEnabled and last ~= Enum.UserInputType.Touch and not isGamepadType(last) then
		return UserInputService:GetMouseLocation()
	end
	return cam.ViewportSize / 2
end

local function aimStep(dt)
	local cam = Workspace.CurrentCamera
	if not cam then
		return
	end
	local center = aimPoint(cam)
	fovCircle.Position = UDim2.fromOffset(center.X, center.Y)

	if not (state.aim.on and aimHeld) then
		lockedPlayer = nil
		return
	end

	local part
	if lockedPlayer then
		local ok, p = validTarget(lockedPlayer)
		if ok and isVisible(p, lockedPlayer.Character, cam) then
			part = p
		else
			lockedPlayer = nil
		end
	end

	if not lockedPlayer then
		local bestDist, bestPlayer, bestPart = state.aim.fov, nil, nil
		for _, plr in ipairs(Players:GetPlayers()) do
			local ok, p = validTarget(plr)
			if ok then
				local vp, onScreen = cam:WorldToViewportPoint(p.Position)
				if onScreen then
					local d = (Vector2.new(vp.X, vp.Y) - center).Magnitude
					if d < bestDist and isVisible(p, plr.Character, cam) then
						bestDist, bestPlayer, bestPart = d, plr, p
					end
				end
			end
		end
		if bestPlayer then
			lockedPlayer = bestPlayer
			part = bestPart
			if state.aim.notify then
				notify("Locked onto " .. bestPlayer.DisplayName)
			end
		end
	end

	if lockedPlayer and part then
		local camCF = cam.CFrame
		local targetCF = CFrame.lookAt(camCF.Position, part.Position)
		local alpha = 1 - (state.aim.smooth / 100) ^ (dt * 60)
		cam.CFrame = camCF:Lerp(targetCF, alpha)
	end
end

onChange("aim", updateFov)
RunService:BindToRenderStep("CarveCC_Aim", Enum.RenderPriority.Camera.Value + 1, aimStep)

--------------------------------------------------------------------------
-- Extras: ESP, player actions, FPS boost, crosshairs, hit effects, UI color
--------------------------------------------------------------------------
local cleanups = {}
local accentHooks = {}
local Lighting = game:GetService("Lighting")
local titleLabel = titleBar:FindFirstChildOfClass("TextLabel")

local PALETTE = {
	Color3.fromRGB(255, 255, 255),
	Color3.fromRGB(255, 60, 60),
	Color3.fromRGB(255, 150, 40),
	Color3.fromRGB(255, 230, 60),
	Color3.fromRGB(80, 255, 120),
	Color3.fromRGB(60, 230, 255),
	Color3.fromRGB(70, 120, 255),
	Color3.fromRGB(180, 90, 255),
	Color3.fromRGB(255, 100, 200),
}

local UI_PRESETS = {
	Color3.fromRGB(151, 110, 255),
	Color3.fromRGB(255, 70, 70),
	Color3.fromRGB(70, 140, 255),
	Color3.fromRGB(60, 220, 230),
	Color3.fromRGB(80, 230, 120),
	Color3.fromRGB(255, 100, 190),
	Color3.fromRGB(255, 150, 40),
	Color3.fromRGB(240, 240, 240),
}

local function makeSwatches(parent, text, colors, onPick)
	local frame = create("Frame", {
		Size = UDim2.new(1, 0, 0, 46),
		BackgroundTransparency = 1,
		Parent = parent,
	})
	makeLabel({ Text = text, Size = UDim2.new(1, 0, 0, 18), Parent = frame })
	local row = create("Frame", {
		Position = UDim2.fromOffset(0, 22),
		Size = UDim2.new(1, 0, 0, 22),
		BackgroundTransparency = 1,
		Parent = frame,
	})
	create("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = UDim.new(0, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = row,
	})
	for _, color in ipairs(colors) do
		local swatch = create("TextButton", {
			Size = UDim2.fromOffset(26, 22),
			BackgroundColor3 = color,
			Text = "",
			Parent = row,
		})
		round(swatch, 5)
		outline(swatch)
		swatch.Activated:Connect(function()
			onPick(color)
		end)
	end
end

local function makeTextInput(parent, text, initial, onSubmit)
	local row = create("Frame", {
		Size = UDim2.new(1, 0, 0, 28),
		BackgroundTransparency = 1,
		Parent = parent,
	})
	makeLabel({ Text = text, Size = UDim2.new(0.4, 0, 1, 0), Parent = row })
	local box = create("TextBox", {
		AnchorPoint = Vector2.new(1, 0.5),
		Position = UDim2.new(1, 0, 0.5, 0),
		Size = UDim2.new(0.6, 0, 0, 24),
		BackgroundColor3 = THEME.panel,
		Text = initial,
		PlaceholderText = "rbxassetid://...",
		PlaceholderColor3 = THEME.sub,
		ClearTextOnFocus = false,
		Font = Enum.Font.GothamMedium,
		TextSize = 12,
		TextColor3 = THEME.text,
		Parent = row,
	})
	round(box, 5)
	outline(box)
	box.FocusLost:Connect(function()
		onSubmit(box.Text)
	end)
	return function(v)
		box.Text = v
	end
end

--------------------------------------------------------------------------
-- ESP (box, health bar, name, skeleton, head dot, held item, distance, tracers)
-- drawn with on-screen GUI
--------------------------------------------------------------------------
local ESP_GREEN = Color3.fromRGB(80, 255, 120)
local ESP_RED = Color3.fromRGB(255, 70, 70)
local espObjects = {}

-- Skeleton data + small drawing helpers live in one table so they only use one local slot.
-- Each bone is { partA, offsetA, partB, offsetB }: offset 1 = top of the part, 0 = center, -1 = bottom.
local ESP_DRAW = {
	bones = 14, -- the most bones any rig uses (R15)
	r15 = {
		{ "Head", 0, "UpperTorso", 1 },
		{ "UpperTorso", 1, "LowerTorso", -1 },
		{ "UpperTorso", 1, "LeftUpperArm", 1 },
		{ "LeftUpperArm", 1, "LeftLowerArm", 1 },
		{ "LeftLowerArm", 1, "LeftHand", 1 },
		{ "UpperTorso", 1, "RightUpperArm", 1 },
		{ "RightUpperArm", 1, "RightLowerArm", 1 },
		{ "RightLowerArm", 1, "RightHand", 1 },
		{ "LowerTorso", -1, "LeftUpperLeg", 1 },
		{ "LeftUpperLeg", 1, "LeftLowerLeg", 1 },
		{ "LeftLowerLeg", 1, "LeftFoot", 1 },
		{ "LowerTorso", -1, "RightUpperLeg", 1 },
		{ "RightUpperLeg", 1, "RightLowerLeg", 1 },
		{ "RightLowerLeg", 1, "RightFoot", 1 },
	},
	r6 = {
		{ "Head", 0, "Torso", 1 },
		{ "Torso", 1, "Torso", -1 },
		{ "Torso", 1, "Left Arm", 1 },
		{ "Left Arm", 1, "Left Arm", -1 },
		{ "Torso", 1, "Right Arm", 1 },
		{ "Right Arm", 1, "Right Arm", -1 },
		{ "Torso", -1, "Left Leg", 1 },
		{ "Left Leg", 1, "Left Leg", -1 },
		{ "Torso", -1, "Right Leg", 1 },
		{ "Right Leg", 1, "Right Leg", -1 },
	},
}

-- world position of a point on a body part (nil if the part is missing)
function ESP_DRAW.point(char, name, off)
	local part = char:FindFirstChild(name)
	if part and part:IsA("BasePart") then
		return part.CFrame * Vector3.new(0, part.Size.Y / 2 * off, 0)
	end
	return nil
end

-- stretches a thin frame between two screen points
function ESP_DRAW.line(frame, from, to, thickness, color)
	local d = to - from
	frame.BackgroundColor3 = color
	frame.Size = UDim2.fromOffset(d.Magnitude, thickness)
	frame.Position = UDim2.fromOffset((from.X + to.X) / 2, (from.Y + to.Y) / 2)
	frame.Rotation = math.deg(math.atan2(d.Y, d.X))
end

local function newEsp()
	local o = {}
	o.root = create("Frame", {
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		Visible = false,
		Parent = espRoot,
	})
	o.box = create("Frame", { BackgroundTransparency = 1, Parent = o.root })
	o.boxStroke = create("UIStroke", {
		Thickness = 1.5,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = o.box,
	})
	o.name = makeLabel({
		Text = "",
		AnchorPoint = Vector2.new(0.5, 1),
		Size = UDim2.fromOffset(240, 20),
		TextXAlignment = Enum.TextXAlignment.Center,
		Font = Enum.Font.GothamBold,
		TextStrokeTransparency = 0.4,
		Parent = o.root,
	})
	o.hpBack = create("Frame", { BackgroundColor3 = Color3.fromRGB(10, 10, 10), Parent = o.root })
	o.hpFill = create("Frame", {
		AnchorPoint = Vector2.new(0, 1),
		Position = UDim2.fromScale(0, 1),
		Size = UDim2.fromScale(1, 1),
		Parent = o.hpBack,
	})
	-- held item and distance text, drawn under the box
	o.tool = makeLabel({
		Text = "",
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.fromOffset(240, 18),
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Top,
		Font = Enum.Font.GothamBold,
		TextStrokeTransparency = 0.4,
		Visible = false,
		Parent = o.root,
	})
	o.dist = makeLabel({
		Text = "",
		AnchorPoint = Vector2.new(0.5, 0),
		Size = UDim2.fromOffset(240, 18),
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Top,
		Font = Enum.Font.GothamBold,
		TextStrokeTransparency = 0.4,
		Visible = false,
		Parent = o.root,
	})
	o.tracer = create("Frame", { AnchorPoint = Vector2.new(0.5, 0.5), Parent = o.root })

	-- head dot
	o.headDot = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Visible = false,
		Parent = o.root,
	})
	create("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = o.headDot })
	create("UIStroke", {
		Color = Color3.new(0, 0, 0),
		Thickness = 1,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = o.headDot,
	})

	-- skeleton bones (a pool of thin frames, reused every frame)
	o.bones = {}
	for i = 1, ESP_DRAW.bones do
		o.bones[i] = create("Frame", {
			AnchorPoint = Vector2.new(0.5, 0.5),
			Visible = false,
			Parent = o.root,
		})
	end
	o.boneCount = 0
	return o
end

local function hideAllEsp()
	for _, o in pairs(espObjects) do
		o.root.Visible = false
	end
end

local function espStep()
	local e = state.esp
	local cam = Workspace.CurrentCamera
	if not e.on or not cam then
		hideAllEsp()
		return
	end
	local viewport = cam.ViewportSize
	local font = e.fonts[e.font][2]
	local smallSize = math.max(e.nameSize - 2, 8)
	local myChar = player.Character
	local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
	local origin = myRoot and myRoot.Position or cam.CFrame.Position

	for _, plr in ipairs(Players:GetPlayers()) do
		if plr ~= player then
			local o = espObjects[plr] or newEsp()
			espObjects[plr] = o

			local show = false
			local char = plr.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			if root and hum and hum.Health > 0 and not (e.team and plr.Team ~= nil and plr.Team == player.Team) then
				local pos, onScreen = cam:WorldToViewportPoint(root.Position)
				if onScreen then
					show = true
					local topV = cam:WorldToViewportPoint(root.Position + Vector3.new(0, 2.8, 0))
					local botV = cam:WorldToViewportPoint(root.Position - Vector3.new(0, 3.2, 0))
					local fullH = math.abs(botV.Y - topV.Y)
					local h = math.max(fullH * (e.boxSize / 100), 4)
					local w = h * 0.55
					local cx = pos.X
					local cy = (topV.Y + botV.Y) / 2
					local color = (whitelist[plr] and ESP_GREEN) or (aimTarget == plr and ESP_RED) or Color3.new(1, 1, 1)

					-- box
					o.box.Visible = e.box
					o.box.Position = UDim2.fromOffset(cx - w / 2, cy - h / 2)
					o.box.Size = UDim2.fromOffset(w, h)
					o.boxStroke.Color = color

					-- name
					o.name.Visible = e.name
					o.name.Text = plr.DisplayName
					o.name.Font = font
					o.name.TextSize = e.nameSize
					o.name.TextColor3 = color
					o.name.Position = UDim2.fromOffset(cx, cy - h / 2 - 2)

					-- health bar (no number)
					local frac = math.clamp(hum.Health / math.max(hum.MaxHealth, 1), 0, 1)
					local barW = e.healthWidth
					local hpColor = Color3.fromHSV(frac * 0.33, 1, 1)
					o.hpBack.Visible = e.health
					o.hpBack.Position = UDim2.fromOffset(cx - w / 2 - barW - 2, cy - h / 2)
					o.hpBack.Size = UDim2.fromOffset(barW, h)
					o.hpFill.Size = UDim2.fromScale(1, frac)
					o.hpFill.BackgroundColor3 = hpColor

					-- skeleton
					local used = 0
					if e.skeleton then
						local rig = char:FindFirstChild("UpperTorso") and ESP_DRAW.r15 or ESP_DRAW.r6
						for _, seg in ipairs(rig) do
							local a = ESP_DRAW.point(char, seg[1], seg[2])
							local b = ESP_DRAW.point(char, seg[3], seg[4])
							if a and b then
								local av = cam:WorldToViewportPoint(a)
								local bv = cam:WorldToViewportPoint(b)
								if av.Z > 0 and bv.Z > 0 then
									used += 1
									local bone = o.bones[used]
									ESP_DRAW.line(bone, Vector2.new(av.X, av.Y), Vector2.new(bv.X, bv.Y), 1.5, color)
									bone.Visible = true
								end
							end
						end
					end
					for i = used + 1, o.boneCount do
						o.bones[i].Visible = false
					end
					o.boneCount = used

					-- head dot
					local dotOn = false
					if e.headDot then
						local head = char:FindFirstChild("Head")
						if head then
							local hv = cam:WorldToViewportPoint(head.Position)
							if hv.Z > 0 then
								dotOn = true
								local size = math.clamp(fullH * 0.16, 3, 24)
								o.headDot.Size = UDim2.fromOffset(size, size)
								o.headDot.Position = UDim2.fromOffset(hv.X, hv.Y)
								o.headDot.BackgroundColor3 = color
							end
						end
					end
					o.headDot.Visible = dotOn

					-- held item + distance (stacked under the box)
					local textY = cy + h / 2 + 2
					local item = nil
					if e.held then
						item = char:FindFirstChildOfClass("Tool")
					end
					if item then
						o.tool.Visible = true
						o.tool.Text = item.Name
						o.tool.Font = font
						o.tool.TextSize = smallSize
						o.tool.TextColor3 = Color3.fromRGB(255, 230, 60)
						o.tool.Position = UDim2.fromOffset(cx, textY)
						textY += smallSize + 2
					else
						o.tool.Visible = false
					end
					if e.distance then
						o.dist.Visible = true
						o.dist.Text = tostring(math.floor((root.Position - origin).Magnitude + 0.5)) .. "m"
						o.dist.Font = font
						o.dist.TextSize = smallSize
						o.dist.TextColor3 = Color3.fromRGB(200, 200, 210)
						o.dist.Position = UDim2.fromOffset(cx, textY)
					else
						o.dist.Visible = false
					end

					-- tracer (bottom center of the screen -> feet of the player)
					o.tracer.Visible = e.tracers
					if e.tracers then
						ESP_DRAW.line(
							o.tracer,
							Vector2.new(viewport.X / 2, viewport.Y),
							Vector2.new(cx, cy + h / 2),
							1.5,
							color
						)
					end
				end
			end
			o.root.Visible = show
		end
	end
end

RunService:BindToRenderStep("CarveCC_ESP", Enum.RenderPriority.Last.Value, espStep)
table.insert(cleanups, function()
	RunService:UnbindFromRenderStep("CarveCC_ESP")
end)

--------------------------------------------------------------------------
-- Local Players actions: teleport, whitelist, target, spectate
--------------------------------------------------------------------------
local spectating = nil
local playerBtns = {}

local function refreshActionButtons()
	for plr, b in pairs(playerBtns) do
		if b.wl.Parent then
			local wl = whitelist[plr] == true
			local tg = aimTarget == plr
			local sp = spectating == plr
			b.wl.BackgroundColor3 = wl and THEME.accent or THEME.card
			b.wl.Text = wl and "Whitelisted" or "Whitelist"
			b.tgt.BackgroundColor3 = tg and THEME.accent or THEME.card
			b.tgt.Text = tg and "Targeted" or "Target"
			b.spec.BackgroundColor3 = sp and THEME.accent or THEME.card
			b.spec.Text = sp and "Stop" or "Spectate"
		end
	end
end

local function stopSpectate()
	spectating = nil
	local cam = Workspace.CurrentCamera
	local hum = getHumanoid()
	if cam and hum then
		cam.CameraSubject = hum
	end
	refreshActionButtons()
end

local function teleportTo(plr)
	local _, myChar = getHumanoid()
	local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
	local theirRoot = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
	if myRoot and theirRoot then
		myRoot.CFrame = theirRoot.CFrame * CFrame.new(0, 0, 3)
		notify("Teleported to " .. plr.DisplayName)
	else
		notify("Can't teleport right now")
	end
end

local function toggleWhitelist(plr)
	if whitelist[plr] then
		whitelist[plr] = nil
	else
		whitelist[plr] = true
		if aimTarget == plr then
			aimTarget = nil
		end
	end
	refreshActionButtons()
end

local function toggleTarget(plr)
	if aimTarget == plr then
		aimTarget = nil
		notify("Target cleared")
	else
		aimTarget = plr
		whitelist[plr] = nil
		notify("Target: " .. plr.DisplayName)
	end
	refreshActionButtons()
end

local function toggleSpectate(plr)
	if spectating == plr then
		stopSpectate()
	else
		spectating = plr
		notify("Spectating " .. plr.DisplayName)
		refreshActionButtons()
	end
end

local function addPlayerActions(row, plr)
	if plr == player then
		return
	end
	row.Size = UDim2.new(1, 0, 0, 74)
	local holder = create("Frame", {
		Position = UDim2.fromOffset(6, 42),
		Size = UDim2.new(1, -12, 0, 26),
		BackgroundTransparency = 1,
		Parent = row,
	})
	local defs = {
		{ "tp", "Teleport", teleportTo },
		{ "wl", "Whitelist", toggleWhitelist },
		{ "tgt", "Target", toggleTarget },
		{ "spec", "Spectate", toggleSpectate },
	}
	local buttons = {}
	for i, def in ipairs(defs) do
		local b = create("TextButton", {
			Position = UDim2.new((i - 1) * 0.25, (i == 1) and 0 or 2, 0, 0),
			Size = UDim2.new(0.25, -2, 1, 0),
			BackgroundColor3 = THEME.card,
			Text = def[2],
			Font = Enum.Font.GothamMedium,
			TextSize = 11,
			TextColor3 = THEME.text,
			Parent = holder,
		})
		round(b, 5)
		outline(b)
		b.Activated:Connect(function()
			def[3](plr)
		end)
		buttons[def[1]] = b
	end
	playerBtns[plr] = buttons
	refreshActionButtons()
end

-- keep the spectate camera glued to the player (they respawn, you respawn...)
connect(RunService.RenderStepped, function()
	if not spectating then
		return
	end
	local cam = Workspace.CurrentCamera
	local char = spectating.Character
	local hum = char and char:FindFirstChildOfClass("Humanoid")
	if cam and hum and cam.CameraSubject ~= hum then
		cam.CameraSubject = hum
	end
end)

connect(Players.PlayerRemoving, function(plr)
	local o = espObjects[plr]
	if o then
		o.root:Destroy()
		espObjects[plr] = nil
	end
	whitelist[plr] = nil
	playerBtns[plr] = nil
	if aimTarget == plr then
		aimTarget = nil
	end
	if spectating == plr then
		stopSpectate()
	end
end)

table.insert(cleanups, function()
	if spectating then
		stopSpectate()
	end
end)

--------------------------------------------------------------------------
-- FPS boost + reset character
--------------------------------------------------------------------------
local fpsBackup = setmetatable({}, { __mode = "k" })
local fpsLighting = {}
local fpsToken = 0
local fpsConn = nil
local fpsPrevQuality = nil

local function boostInstance(inst)
	if inst:IsA("Terrain") then
		return
	end
	if inst:IsA("BasePart") then
		if fpsBackup[inst] == nil then
			fpsBackup[inst] = { Material = inst.Material, Reflectance = inst.Reflectance, CastShadow = inst.CastShadow }
		end
		inst.Material = Enum.Material.SmoothPlastic
		inst.Reflectance = 0
		inst.CastShadow = false
	elseif
		inst:IsA("ParticleEmitter")
		or inst:IsA("Trail")
		or inst:IsA("Smoke")
		or inst:IsA("Fire")
		or inst:IsA("Sparkles")
		or inst:IsA("Beam")
	then
		if fpsBackup[inst] == nil then
			fpsBackup[inst] = { Enabled = inst.Enabled }
		end
		inst.Enabled = false
	end
end

local function setFpsBoost(on)
	state.fpsBoost = on
	fpsToken += 1
	local token = fpsToken
	if fpsConn then
		fpsConn:Disconnect()
		fpsConn = nil
	end

	if on then
		pcall(function()
			fpsPrevQuality = settings().Rendering.QualityLevel
			settings().Rendering.QualityLevel = Enum.QualityLevel.Level01
		end)
		fpsLighting.shadows = Lighting.GlobalShadows
		Lighting.GlobalShadows = false
		fpsLighting.effects = {}
		for _, v in ipairs(Lighting:GetDescendants()) do
			if v:IsA("PostEffect") then
				fpsLighting.effects[v] = v.Enabled
				v.Enabled = false
			end
		end

		fpsConn = Workspace.DescendantAdded:Connect(function(inst)
			pcall(boostInstance, inst)
		end)
		task.spawn(function()
			local list = Workspace:GetDescendants()
			for i, inst in ipairs(list) do
				if token ~= fpsToken then
					return
				end
				pcall(boostInstance, inst)
				if i % 300 == 0 then
					task.wait()
				end
			end
		end)
		notify("FPS boost on")
	else
		for inst, props in pairs(fpsBackup) do
			if inst.Parent then
				for k, v in pairs(props) do
					pcall(function()
						inst[k] = v
					end)
				end
			end
			fpsBackup[inst] = nil
		end
		if fpsLighting.shadows ~= nil then
			Lighting.GlobalShadows = fpsLighting.shadows
		end
		for effect, wasOn in pairs(fpsLighting.effects or {}) do
			if effect.Parent then
				effect.Enabled = wasOn
			end
		end
		fpsLighting = {}
		if fpsPrevQuality then
			pcall(function()
				settings().Rendering.QualityLevel = fpsPrevQuality
			end)
		end
		notify("FPS boost off")
	end
end

table.insert(cleanups, function()
	if state.fpsBoost then
		setFpsBoost(false)
	end
end)

local function resetCharacter()
	local hum, char = getHumanoid()
	if hum then
		hum.Health = 0
		if char then
			pcall(function()
				char:BreakJoints()
			end)
		end
		notify("Resetting character")
	else
		notify("No character found")
	end
end

--------------------------------------------------------------------------
-- Crosshairs (static + spinning)
--------------------------------------------------------------------------
local CROSS_C = 100
local crossHolder = create("Frame", {
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Size = UDim2.fromOffset(200, 200),
	BackgroundTransparency = 1,
	Visible = false,
	ZIndex = 0,
	Parent = gui,
})

local function crossBar(x, y, w, h, rot)
	return create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromOffset(CROSS_C + x, CROSS_C + y),
		Size = UDim2.fromOffset(w, h),
		Rotation = rot or 0,
		BackgroundColor3 = state.cross.color,
		Parent = crossHolder,
	})
end

local function crossLine(x1, y1, x2, y2, t)
	local dx, dy = x2 - x1, y2 - y1
	local len = math.sqrt(dx * dx + dy * dy)
	return crossBar((x1 + x2) / 2, (y1 + y2) / 2, len + t, t, math.deg(math.atan2(dy, dx)))
end

local function crossDot(x, y, d)
	local f = crossBar(x, y, d, d, 0)
	create("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = f })
end

local function crossOutline(d, circle, rot)
	local f = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromOffset(CROSS_C, CROSS_C),
		Size = UDim2.fromOffset(d, d),
		BackgroundTransparency = 1,
		Rotation = rot or 0,
		Parent = crossHolder,
	})
	create("UIStroke", {
		Color = state.cross.color,
		Thickness = state.cross.thickness,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
		Parent = f,
	})
	if circle then
		create("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = f })
	end
end

local function plusBars(S, t, g)
	local d = g + S / 2
	crossBar(0, -d, t, S)
	crossBar(0, d, t, S)
	crossBar(-d, 0, S, t)
	crossBar(d, 0, S, t)
end

local function triangleLines(S, t, g)
	local R = g + S * 0.8
	local pts = {}
	for i = 0, 2 do
		local a = math.rad(-90 + i * 120)
		pts[i + 1] = Vector2.new(math.cos(a) * R, math.sin(a) * R)
	end
	for i = 1, 3 do
		local a, b = pts[i], pts[i % 3 + 1]
		crossLine(a.X, a.Y, b.X, b.Y, t)
	end
end

local crossStyles = {
	{ name = "Plus", build = plusBars },
	{
		name = "Dot",
		build = function(S, t, g)
			crossDot(0, 0, math.max(t * 2, 3))
		end,
	},
	{
		name = "Ring",
		build = function(S, t, g)
			crossOutline((g + S / 2) * 2, true)
		end,
	},
	{
		name = "Cross X",
		build = function(S, t, g)
			local d = (g + S / 2) / math.sqrt(2)
			for _, sx in ipairs({ -1, 1 }) do
				for _, sy in ipairs({ -1, 1 }) do
					crossBar(sx * d, sy * d, S, t, (sx * sy > 0) and 45 or -45)
				end
			end
		end,
	},
	{
		name = "T Shape",
		build = function(S, t, g)
			local d = g + S / 2
			crossBar(-d, 0, S, t)
			crossBar(d, 0, S, t)
			crossBar(0, d, t, S)
		end,
	},
	{
		name = "Box",
		build = function(S, t, g)
			crossOutline((g + S / 2) * 2, false)
		end,
	},
	{
		name = "Diamond",
		build = function(S, t, g)
			crossOutline((g + S / 2) * 1.5, false, 45)
		end,
	},
	{
		name = "Brackets",
		build = function(S, t, g)
			local half = g + S * 0.6
			local L = S * 0.5
			for _, sx in ipairs({ -1, 1 }) do
				for _, sy in ipairs({ -1, 1 }) do
					local cx, cy = sx * half, sy * half
					crossBar(cx - sx * L / 2, cy, L, t)
					crossBar(cx, cy - sy * L / 2, t, L)
				end
			end
		end,
	},
	{
		name = "Dot + Plus",
		build = function(S, t, g)
			plusBars(S, t, g)
			crossDot(0, 0, math.max(t * 2, 3))
		end,
	},
	{ name = "Triangle", build = triangleLines },
	{ name = "Spinning Plus", spin = true, build = plusBars },
	{
		name = "Spinning Square",
		spin = true,
		build = function(S, t, g)
			crossOutline((g + S / 2) * 2, false)
		end,
	},
	{
		name = "Spinning Dots",
		spin = true,
		build = function(S, t, g)
			local r = g + S / 2
			local ds = math.max(t * 2, 3)
			for i = 0, 3 do
				local a = math.rad(i * 90)
				crossDot(math.cos(a) * r, math.sin(a) * r, ds)
			end
		end,
	},
	{ name = "Spinning Triangle", spin = true, build = triangleLines },
	{
		name = "Spinning Blades",
		spin = true,
		build = function(S, t, g)
			local r = g + S / 2
			for i = 0, 2 do
				local ang = i * 120
				local a = math.rad(ang)
				crossBar(math.cos(a) * r, math.sin(a) * r, S, t, ang)
			end
		end,
	},
}

local function rebuildCrosshair()
	crossHolder:ClearAllChildren()
	local c = state.cross
	local style = crossStyles[c.style]
	style.build(c.size, c.thickness, c.gap)
	crossHolder.Visible = c.on
	if not style.spin then
		crossHolder.Rotation = 0
	end
end

local function setCursor()
	UserInputService.MouseIconEnabled = not (state.cross.on and state.cross.hideCursor)
end

connect(RunService.RenderStepped, function(dt)
	local c = state.cross
	if not c.on then
		return
	end
	if c.follow then
		local m = UserInputService:GetMouseLocation()
		crossHolder.Position = UDim2.fromOffset(m.X, m.Y)
	else
		crossHolder.Position = UDim2.fromScale(0.5, 0.5)
	end
	if crossStyles[c.style].spin then
		crossHolder.Rotation = (crossHolder.Rotation + c.speed * dt) % 360
	end
end)

table.insert(cleanups, function()
	UserInputService.MouseIconEnabled = true
end)

local styleButtons = {}
local function refreshStyleButtons()
	for i, b in ipairs(styleButtons) do
		b.BackgroundColor3 = (i == state.cross.style) and THEME.accent or THEME.panel
	end
end
table.insert(accentHooks, refreshStyleButtons)

--------------------------------------------------------------------------
-- Hit detection: hit chams, hit marker, hit sounds
-- (the client can't see server damage, so a "hit" = a player near your aim lost health right after you fired)
--------------------------------------------------------------------------
local lastShot = -10
local shotTarget, shotDir, shotOrigin = nil, nil, nil
local lastWarn = 0
local chamObjs = {}
local healthConns = {}
local hitRayParams = RaycastParams.new()
hitRayParams.FilterType = Enum.RaycastFilterType.Exclude

local function hitActive()
	local h = state.hit
	return h.chams or h.marker or h.sound
end

local function recordShot()
	local cam = Workspace.CurrentCamera
	if not cam then
		return
	end
	lastShot = os.clock()
	local point = aimPoint(cam)
	local ray = cam:ViewportPointToRay(point.X, point.Y)
	shotOrigin, shotDir = ray.Origin, ray.Direction.Unit
	hitRayParams.FilterDescendantsInstances = { player.Character }
	local result = Workspace:Raycast(ray.Origin, ray.Direction * 1000, hitRayParams)
	shotTarget = nil
	if result then
		local model = result.Instance:FindFirstAncestorOfClass("Model")
		shotTarget = model and Players:GetPlayerFromCharacter(model) or nil
	end
end

local function soundUrl(id)
	id = tostring(id or ""):gsub("%s+", "")
	if id == "" then
		return nil
	end
	if tonumber(id) then
		return "rbxassetid://" .. id
	end
	return id
end

local function playHitSound(force)
	local def = hitSounds[state.hit.soundIndex]
	local url = def and soundUrl(def.id)
	if not url then
		if force or os.clock() - lastWarn > 4 then
			lastWarn = os.clock()
			notify((def and def.name or "Sound") .. ": no sound ID set")
		end
		return
	end
	local s = create("Sound", {
		SoundId = url,
		Volume = state.hit.volume / 100 * 3,
		Parent = gui,
	})
	s:Play()
	s.Ended:Connect(function()
		s:Destroy()
	end)
	task.delay(8, function()
		if s.Parent then
			s:Destroy()
		end
	end)
end

local function showHitMarker(dead)
	local cam = Workspace.CurrentCamera
	if not cam then
		return
	end
	local center = cam.ViewportSize / 2
	if state.cross.on and state.cross.follow then
		center = UserInputService:GetMouseLocation()
	end
	local color = dead and Color3.fromRGB(255, 60, 60) or Color3.fromRGB(255, 255, 255)
	local holder = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromOffset(center.X, center.Y),
		Size = UDim2.fromOffset(40, 40),
		BackgroundTransparency = 1,
		ZIndex = 60,
		Parent = gui,
	})
	for _, sx in ipairs({ -1, 1 }) do
		for _, sy in ipairs({ -1, 1 }) do
			local bar = create("Frame", {
				AnchorPoint = Vector2.new(0.5, 0.5),
				Position = UDim2.fromOffset(20 + sx * 9, 20 + sy * 9),
				Size = UDim2.fromOffset(10, 2),
				Rotation = (sx * sy > 0) and 45 or -45,
				BackgroundColor3 = color,
				ZIndex = 60,
				Parent = holder,
			})
			TweenService:Create(bar, TweenInfo.new(0.3), { BackgroundTransparency = 1 }):Play()
		end
	end
	TweenService:Create(holder, TweenInfo.new(0.3), { Size = UDim2.fromOffset(56, 56) }):Play()
	task.delay(0.4, function()
		holder:Destroy()
	end)
end

local function triggerHit(plr, dead)
	local h = state.hit
	if h.chams then
		local char = plr.Character
		if char then
			if chamObjs[plr] then
				chamObjs[plr]:Destroy()
			end
			local hl = create("Highlight", {
				Adornee = char,
				FillColor = h.chamFill,
				OutlineColor = h.chamOutline,
				FillTransparency = h.chamFillT / 100,
				OutlineTransparency = 0,
				DepthMode = Enum.HighlightDepthMode.AlwaysOnTop,
				Parent = char,
			})
			chamObjs[plr] = hl
			local tween = TweenService:Create(hl, TweenInfo.new(h.chamTime / 10), {
				FillTransparency = 1,
				OutlineTransparency = 1,
			})
			tween:Play()
			tween.Completed:Connect(function()
				if chamObjs[plr] == hl then
					chamObjs[plr] = nil
				end
				hl:Destroy()
			end)
		end
	end
	if h.marker then
		showHitMarker(dead)
	end
	if h.sound then
		playHitSound()
	end
end

local function onDamaged(plr, dead)
	if not hitActive() or os.clock() - lastShot > 0.6 then
		return
	end
	local root = plr.Character and plr.Character:FindFirstChild("HumanoidRootPart")
	if not root then
		return
	end
	local ok = (plr == shotTarget)
	if not ok and shotOrigin then
		local to = root.Position - shotOrigin
		if to.Magnitude > 0 then
			ok = shotDir:Dot(to.Unit) > math.cos(math.rad(8))
		end
	end
	if ok then
		triggerHit(plr, dead)
	end
end

local function hookCharacter(plr, char)
	local hum = char:WaitForChild("Humanoid", 5)
	if not hum then
		return
	end
	local last = hum.Health
	local conn = hum.HealthChanged:Connect(function(hp)
		if hp < last then
			onDamaged(plr, hp <= 0)
		end
		last = hp
	end)
	healthConns[conn] = true
	char.Destroying:Connect(function()
		conn:Disconnect()
		healthConns[conn] = nil
	end)
end

local function hookPlayer(plr)
	if plr == player then
		return
	end
	if plr.Character then
		task.spawn(hookCharacter, plr, plr.Character)
	end
	connect(plr.CharacterAdded, function(char)
		hookCharacter(plr, char)
	end)
end

connect(Players.PlayerAdded, hookPlayer)
for _, plr in ipairs(Players:GetPlayers()) do
	hookPlayer(plr)
end

connect(UserInputService.InputBegan, function(input, processed)
	if processed or not hitActive() then
		return
	end
	if
		input.UserInputType == Enum.UserInputType.MouseButton1
		or input.UserInputType == Enum.UserInputType.Touch
		or input.KeyCode == Enum.KeyCode.ButtonR2
	then
		recordShot()
	end
end)

-- holding the trigger / mouse button keeps counting as shooting (full-auto guns)
connect(RunService.RenderStepped, function()
	if menuOpen or not hitActive() then
		return
	end
	if
		UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
		or UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
	then
		recordShot()
	end
end)

table.insert(cleanups, function()
	for conn in pairs(healthConns) do
		conn:Disconnect()
	end
	healthConns = {}
	for _, hl in pairs(chamObjs) do
		hl:Destroy()
	end
	chamObjs = {}
end)

--------------------------------------------------------------------------
-- Gun (infinite range, bullet TP, rapid fire) and ??? (orbit, stay above)
-- Wrapped in do ... end so none of these locals count against the main
-- chunk's local-variable limit.
--------------------------------------------------------------------------
do
	local RANGE_HUGE = 50000
	local G = {
		fire = -10, -- last time a shot was detected
		rangeAt = 0, -- last time the tools were re-scanned
		nextShot = 0, -- rapid fire: time the next shot is due (0 = not firing)
		angle = 0, -- orbit angle (degrees)
		warnAt = 0, -- rate limit for the "no player" toast
		pending = {}, -- new parts that might be bullets: [part] = true
		tracked = {}, -- bullets being redirected: [part] = expiry time
		touches = {}, -- touches that are currently held down
		orbitPlayer = nil,
		fromTarget = false,
		hooked = setmetatable({}, { __mode = "k" }),
		failed = setmetatable({}, { __mode = "k" }),
		busy = setmetatable({}, { __mode = "k" }),
		record = setmetatable({}, { __mode = "k" }), -- [target] = { [key] = original value }
	}

	----------------------------------------------------------------------
	-- Infinite range: finds range / distance settings on your tools
	-- (NumberValues, IntValues, attributes and settings ModuleScripts) and
	-- raises them. Originals are restored when you turn it off.
	----------------------------------------------------------------------
	local function isRangeName(name)
		local n = string.lower(name)
		for _, bad in ipairs({ "min", "spread", "recoil", "zoom", "camera", "shake" }) do
			if n:find(bad, 1, true) then
				return false
			end
		end
		return n:find("range", 1, true) ~= nil or n:find("dist", 1, true) ~= nil or n:find("reach", 1, true) ~= nil
	end

	local function boost(target, key, old, setter)
		if not pcall(setter) then
			return
		end
		local rec = G.record[target]
		if not rec then
			rec = {}
			G.record[target] = rec
		end
		if rec[key] == nil then
			rec[key] = old
		end
	end

	local function scanTable(tbl, depth, seen)
		if depth > 4 or seen[tbl] then
			return
		end
		seen[tbl] = true
		for k, v in pairs(tbl) do
			if type(v) == "table" then
				scanTable(v, depth + 1, seen)
			elseif type(k) == "string" and type(v) == "number" and v < RANGE_HUGE and isRangeName(k) then
				boost(tbl, k, v, function()
					tbl[k] = RANGE_HUGE
				end)
			end
		end
	end

	local function scanInstance(inst)
		if inst:IsA("NumberValue") or inst:IsA("IntValue") then
			if inst.Value < RANGE_HUGE and isRangeName(inst.Name) then
				boost(inst, "Value", inst.Value, function()
					inst.Value = RANGE_HUGE
				end)
			end
		elseif inst:IsA("ModuleScript") and not G.failed[inst] and not G.busy[inst] then
			-- settings modules are shared with the gun's own scripts (same client), so editing the table works
			G.busy[inst] = true
			task.spawn(function()
				local ok, result = pcall(require, inst)
				G.busy[inst] = nil
				if not ok then
					G.failed[inst] = true
				elseif type(result) == "table" then
					pcall(scanTable, result, 0, {})
				end
			end)
		end
		for name, val in pairs(inst:GetAttributes()) do
			if type(val) == "number" and val < RANGE_HUGE and isRangeName(name) then
				boost(inst, name, val, function()
					inst:SetAttribute(name, RANGE_HUGE)
				end)
			end
		end
	end

	local function scanTool(tool)
		pcall(scanInstance, tool)
		for _, inst in ipairs(tool:GetDescendants()) do
			pcall(scanInstance, inst)
		end
	end

	local function scanHolder(holder)
		if not holder then
			return
		end
		for _, child in ipairs(holder:GetChildren()) do
			if child:IsA("Tool") then
				scanTool(child)
			end
		end
	end

	local function scanAllTools()
		scanHolder(player.Character)
		scanHolder(player:FindFirstChildOfClass("Backpack"))
	end

	local function restoreRange()
		for target, rec in pairs(G.record) do
			for key, old in pairs(rec) do
				pcall(function()
					if typeof(target) == "Instance" then
						if key == "Value" and target:IsA("ValueBase") then
							target.Value = old
						else
							target:SetAttribute(key, old)
						end
					else
						target[key] = old
					end
				end)
			end
			G.record[target] = nil
		end
	end

	local function countRange()
		local n = 0
		for _, rec in pairs(G.record) do
			for _ in pairs(rec) do
				n += 1
			end
		end
		return n
	end

	applyFns.range = function(on)
		if on then
			G.rangeAt = os.clock()
			scanAllTools()
			task.delay(0.7, function()
				if not state.range.on then
					return
				end
				local n = countRange()
				if n > 0 then
					notify("Infinite range: " .. n .. " setting(s) raised")
				else
					notify("Infinite range: no range settings found")
				end
			end)
		else
			restoreRange()
			notify("Infinite range off")
		end
	end

	----------------------------------------------------------------------
	-- Bullet TP: bullets that spawn right after you fire get moved onto
	-- your Target, your locked aimbot player, or whoever is closest to the
	-- crosshair (uses the Aim tab's FOV, team check and whitelist).
	----------------------------------------------------------------------
	local btpConn

	local function bulletTarget()
		if aimTarget then
			local ok, part = validTarget(aimTarget)
			return ok and part or nil
		end
		if lockedPlayer then
			local ok, part = validTarget(lockedPlayer)
			if ok then
				return part
			end
		end
		local cam = Workspace.CurrentCamera
		if not cam then
			return nil
		end
		local center = aimPoint(cam)
		local bestDist, bestPart = state.aim.fov, nil
		for _, plr in ipairs(Players:GetPlayers()) do
			local ok, part = validTarget(plr)
			if ok then
				local vp, onScreen = cam:WorldToViewportPoint(part.Position)
				if onScreen then
					local d = (Vector2.new(vp.X, vp.Y) - center).Magnitude
					if d < bestDist then
						bestDist, bestPart = d, part
					end
				end
			end
		end
		return bestPart
	end

	local function inCharacter(inst)
		local model = inst:FindFirstAncestorOfClass("Model")
		return model ~= nil and Players:GetPlayerFromCharacter(model) ~= nil
	end

	applyFns.btp = function(on)
		if btpConn then
			btpConn:Disconnect()
			btpConn = nil
		end
		G.pending, G.tracked = {}, {}
		if on then
			btpConn = Workspace.DescendantAdded:Connect(function(inst)
				if os.clock() - G.fire <= 0.5 and inst:IsA("BasePart") then
					G.pending[inst] = true
				end
			end)
			notify("Bullet TP on")
		else
			notify("Bullet TP off")
		end
	end

	----------------------------------------------------------------------
	-- Fire detection (used by bullet TP and rapid fire)
	----------------------------------------------------------------------
	local function markFire()
		G.fire = os.clock()
	end

	local function isFiring()
		if menuOpen then
			return false
		end
		if
			UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
			or UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
		then
			return true
		end
		for input in pairs(G.touches) do
			local s = input.UserInputState
			if s == Enum.UserInputState.End or s == Enum.UserInputState.Cancel then
				G.touches[input] = nil
			else
				return true
			end
		end
		return false
	end

	connect(UserInputService.InputBegan, function(input, processed)
		local t = input.UserInputType
		if t == Enum.UserInputType.Touch and not processed then
			G.touches[input] = true
		end
		if
			((t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch) and not processed)
			or input.KeyCode == Enum.KeyCode.ButtonR2
		then
			if not menuOpen then
				markFire()
			end
		end
	end)

	connect(UserInputService.InputEnded, function(input)
		G.touches[input] = nil
	end)

	----------------------------------------------------------------------
	-- Per-frame: range upkeep, rapid fire, bullet redirect
	----------------------------------------------------------------------
	-- Rapid fire: keeps activating the equipped tool while fire is held.
	-- It is time-based (shots are scheduled by the clock, not per frame), so it can be
	-- called from several frame signals and still hit the exact rate. Up to 100 shots
	-- per call, so 500 shots/s works even at low frame rates.
	local function rapidStep()
		if not state.rapid.on then
			G.nextShot = 0
			return
		end
		local char = player.Character
		local tool = char and char:FindFirstChildOfClass("Tool")
		if not (tool and isFiring()) then
			G.nextShot = 0
			return
		end
		local now = os.clock()
		local interval = 1 / math.max(state.rapid.value, 1)
		if G.nextShot == 0 or now - G.nextShot > 0.25 then
			G.nextShot = now -- first shot goes out right away; also drops a stale backlog after a lag spike
		end
		local shots = 0
		while now >= G.nextShot and shots < 100 do
			G.nextShot += interval
			shots += 1
			markFire()
			pcall(tool.Activate, tool)
		end
	end

	local function gunStep(dt)
		local now = os.clock()

		-- some games reset values, so keep the range settings raised
		if state.range.on and now - G.rangeAt > 1.5 then
			G.rangeAt = now
			scanAllTools()
		end

		local gunMods = state.btp.on or state.rapid.on
		local tool = nil
		if gunMods then
			local char = player.Character
			tool = char and char:FindFirstChildOfClass("Tool")
			if tool and not G.hooked[tool] then
				G.hooked[tool] = true
				connect(tool.Activated, markFire) -- also catches on-screen gun buttons on mobile
			end
		end

		local firing = gunMods and isFiring()
		if firing then
			markFire()
		end

		-- (rapid fire runs in rapidStep, above)

		-- bullet TP
		if state.btp.on then
			local char = player.Character
			local root = char and char:FindFirstChild("HumanoidRootPart")
			for inst in pairs(G.pending) do
				G.pending[inst] = nil
				if root and inst.Parent and not inCharacter(inst) and (inst.Position - root.Position).Magnitude < 35 then
					local s = inst.Size
					if math.max(s.X, s.Y, s.Z) <= 6 then
						G.tracked[inst] = now + 3
					end
				end
			end
			if next(G.tracked) then
				local part = bulletTarget()
				for inst, expires in pairs(G.tracked) do
					if not inst.Parent or now > expires then
						G.tracked[inst] = nil
					elseif part then
						inst.CFrame = CFrame.new(part.Position) * (inst.CFrame - inst.CFrame.Position)
						inst.AssemblyLinearVelocity = Vector3.zero
					end
				end
			end
		end
	end

	connect(RunService.Heartbeat, gunStep)
	-- rapid fire is checked several times per frame so shots are spread out instead of bunched up
	connect(RunService.Heartbeat, rapidStep)
	connect(RunService.RenderStepped, rapidStep)
	connect(RunService.Stepped, rapidStep)

	----------------------------------------------------------------------
	-- Orbit / stay above player
	-- Follows the player you set as Target (Local Players tab), or the
	-- closest player if you have no target.
	----------------------------------------------------------------------
	local function alivePart(plr)
		local char = plr and plr.Character
		local root = char and char:FindFirstChild("HumanoidRootPart")
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if root and hum and hum.Health > 0 then
			return root
		end
		return nil
	end

	local function orbitTarget(myRoot)
		if aimTarget then
			G.orbitPlayer, G.fromTarget = aimTarget, true
		elseif G.fromTarget then
			G.orbitPlayer, G.fromTarget = nil, false
		end
		if G.orbitPlayer then
			local r = alivePart(G.orbitPlayer)
			if r or G.fromTarget then
				return r
			end
			G.orbitPlayer = nil
		end
		-- no target: lock onto the closest player (stays locked so orbiting doesn't make it flip)
		local bestPlr, bestRoot, bestDist
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= player then
				local r = alivePart(plr)
				if r then
					local d = (r.Position - myRoot.Position).Magnitude
					if not bestDist or d < bestDist then
						bestPlr, bestRoot, bestDist = plr, r, d
					end
				end
			end
		end
		G.orbitPlayer = bestPlr
		return bestRoot
	end

	local function orbitStep(dt)
		local orbitOn, aboveOn = state.orbit.on, state.above.on
		if not (orbitOn or aboveOn) then
			G.orbitPlayer, G.fromTarget = nil, false
			return
		end
		local hum, char = getHumanoid()
		local myRoot = char and char:FindFirstChild("HumanoidRootPart")
		if not (hum and myRoot) then
			return
		end

		local targetRoot = orbitTarget(myRoot)
		if not targetRoot then
			if os.clock() - G.warnAt > 3 then
				G.warnAt = os.clock()
				notify("No player to follow")
			end
			return
		end

		local center = targetRoot.Position
		local height = (orbitOn and state.orbit.height or 0) + (aboveOn and state.above.height or 0)
		if orbitOn then
			G.angle = (G.angle + state.orbit.speed * dt) % 360
			local a = math.rad(G.angle)
			local r = state.orbit.radius
			local pos = center + Vector3.new(math.cos(a) * r, height, math.sin(a) * r)
			myRoot.CFrame = CFrame.lookAt(pos, Vector3.new(center.X, pos.Y, center.Z))
		else
			local pos = center + Vector3.new(0, height, 0)
			myRoot.CFrame = CFrame.new(pos) * (myRoot.CFrame - myRoot.CFrame.Position)
		end
		myRoot.AssemblyLinearVelocity = Vector3.zero
		myRoot.AssemblyAngularVelocity = Vector3.zero
	end

	connect(RunService.Heartbeat, orbitStep)

	----------------------------------------------------------------------
	-- Wallbang: while you aim at a player behind a wall, the walls between
	-- you and them are made invisible to raycasts on your client
	-- (CanQuery = false), so guns that check hits on the client shoot
	-- straight through. Everything is restored a moment after you look away.
	-- Aim target = your Target, your locked aimbot player, or whoever is
	-- closest to the crosshair inside the Aim tab FOV.
	----------------------------------------------------------------------
	local WB = { tracked = {} } -- [part] = { last = last time it was in the way }
	local wbParams = RaycastParams.new()
	wbParams.FilterType = Enum.RaycastFilterType.Exclude
	wbParams.IgnoreWater = true

	-- does the segment a -> b pass through this part's box?
	local function segmentHits(part, a, b)
		local cf = part.CFrame
		local la = cf:PointToObjectSpace(a)
		local d = cf:PointToObjectSpace(b) - la
		local half = part.Size / 2
		local tmin, tmax = 0, 1
		for _, axis in ipairs({ "X", "Y", "Z" }) do
			local o, dd, h = la[axis], d[axis], half[axis]
			if math.abs(dd) < 1e-6 then
				if o < -h or o > h then
					return false
				end
			else
				local t1, t2 = (-h - o) / dd, (h - o) / dd
				if t1 > t2 then
					t1, t2 = t2, t1
				end
				tmin = math.max(tmin, t1)
				tmax = math.min(tmax, t2)
				if tmin > tmax then
					return false
				end
			end
		end
		return true
	end

	local function wbRestore(part)
		WB.tracked[part] = nil
		if part.Parent then
			pcall(function()
				part.CanQuery = true
			end)
		end
	end

	-- walks a ray from origin to goal and collects every wall it runs into
	local function wbSweep(origin, goal, myChar, myRoot, targetChar, found)
		local filter = { myChar, targetChar }
		local dir = goal - origin
		for _ = 1, 10 do
			wbParams.FilterDescendantsInstances = filter
			local result = Workspace:Raycast(origin, dir, wbParams)
			if not result then
				return
			end
			local inst = result.Instance
			local model = inst:FindFirstAncestorOfClass("Model")
			if inst:IsA("Terrain") then
				table.insert(filter, inst) -- terrain can't be passed through
			elseif model and model:FindFirstChildOfClass("Humanoid") then
				table.insert(filter, model) -- players / NPCs stay solid
			else
				-- the ground right under you stays solid so you can still stand and jump
				local rel = result.Position - myRoot.Position
				local isFloor = result.Normal.Y > 0.5
					and rel.Y < 0
					and rel.Y > -6
					and Vector3.new(rel.X, 0, rel.Z).Magnitude < 10
				if not isFloor then
					found[inst] = true
				end
				table.insert(filter, inst)
			end
		end
	end

	local function wallbangStep()
		local now = os.clock()
		local segs = {}

		if state.wallbang.on then
			local myChar = player.Character
			local myRoot = myChar and myChar:FindFirstChild("HumanoidRootPart")
			local cam = Workspace.CurrentCamera
			local part = (myRoot and cam) and bulletTarget() or nil
			if part and part.Parent then
				local goal = part.Position
				local origins = { cam.CFrame.Position, myRoot.Position + Vector3.new(0, 1.5, 0) }
				local tool = myChar:FindFirstChildOfClass("Tool")
				local handle = tool and tool:FindFirstChild("Handle")
				if handle and handle:IsA("BasePart") then
					table.insert(origins, handle.Position)
				end
				local found = {}
				for _, origin in ipairs(origins) do
					wbSweep(origin, goal, myChar, myRoot, part.Parent, found)
					table.insert(segs, { origin, goal })
				end
				for inst in pairs(found) do
					if not WB.tracked[inst] then
						WB.tracked[inst] = { last = now }
						pcall(function()
							inst.CanQuery = false
						end)
					end
				end
			end
		end

		-- parts that are no longer in the way come back after a short delay
		for inst, rec in pairs(WB.tracked) do
			local keep = false
			if inst.Parent then
				for _, seg in ipairs(segs) do
					if segmentHits(inst, seg[1], seg[2]) then
						keep = true
						break
					end
				end
			end
			if keep then
				rec.last = now
			elseif not inst.Parent or now - rec.last > 0.15 then
				wbRestore(inst)
			end
		end
	end

	applyFns.wallbang = function(on)
		if on then
			notify("Wallbang on")
		else
			for inst in pairs(WB.tracked) do
				wbRestore(inst)
			end
			notify("Wallbang off")
		end
	end

	connect(RunService.Heartbeat, wallbangStep)
end

--------------------------------------------------------------------------
-- Hitbox expander (Aim tab): a bigger, invisible hitbox is put around other
-- players on your screen. It is a separate anchored part that follows their
-- root part, so their real character is never resized or touched (resizing the
-- real root part is what froze players in place). Whitelisted players and
-- teammates (if Team check is on) are skipped. Everything is removed when you
-- turn it off.
--------------------------------------------------------------------------
do
	local boxes = {} -- [Player] = the hitbox part made for them

	local function removeBox(plr)
		local box = boxes[plr]
		boxes[plr] = nil
		if box then
			box:Destroy()
		end
	end

	local function removeAll()
		for plr in pairs(boxes) do
			removeBox(plr)
		end
	end

	local function shouldExpand(plr)
		if whitelist[plr] then
			return false
		end
		if state.aim.team and plr.Team ~= nil and plr.Team == player.Team then
			return false
		end
		return true
	end

	local function hitboxStep()
		local h = state.hitbox
		if not h.on then
			return
		end
		local size = Vector3.new(h.size, h.size, h.size)

		for plr in pairs(boxes) do
			if not plr.Parent then
				removeBox(plr) -- they left the server
			end
		end

		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= player then
				local char = plr.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				if root and hum and hum.Health > 0 and shouldExpand(plr) then
					local box = boxes[plr]
					if box and box.Parent ~= char then
						removeBox(plr) -- they respawned: make a new one
						box = nil
					end
					if not box then
						box = create("Part", {
							Name = "CarveHitbox",
							Anchored = true,
							CanCollide = false,
							CastShadow = false,
							Transparency = 1,
							Size = size,
							Parent = char,
						})
						boxes[plr] = box
					end
					if box.Size ~= size then
						box.Size = size
					end
					box.CFrame = CFrame.new(root.Position)
					local t = h.visual and 0.6 or 1
					if box.Transparency ~= t then
						box.Transparency = t
					end
					if h.visual and box.Color ~= THEME.accent then
						box.Color = THEME.accent
					end
				else
					removeBox(plr)
				end
			end
		end
	end

	applyFns.hitbox = function(on)
		if on then
			notify("Hitbox expander on")
		else
			removeAll()
			notify("Hitbox expander off")
		end
	end

	connect(RunService.Heartbeat, hitboxStep)
	table.insert(cleanups, removeAll)
end

--------------------------------------------------------------------------
-- Silent aim (Aim tab). Picks a target (your Target, a sticky lock, or the player
-- closest to your crosshair inside the FOV circle) and, while you fire, points the
-- camera at it for the instant the game's gun reads it, then puts it back before
-- your camera script runs and before the frame is drawn. Your view never moves.
-- A LocalScript can't hook the mouse, so this is the closest it gets.
--------------------------------------------------------------------------
do
	local STICKY_IDLE = 3 -- sticky aim lets go after this many seconds without firing
	local KNOCK_NAMES = { "Knocked", "KnockedOut", "Downed", "KO", "K.O" }
	local S = { cur = nil, stuck = nil, lastFire = 0, roll = 1, noteAt = 0 } -- cur = body part silent aim points at
	local saved = nil -- your real camera CFrame while it is pointed at the target
	local touches = {}

	local silentCircle = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		Size = UDim2.fromOffset(300, 300),
		BackgroundTransparency = 1,
		Visible = false,
		ZIndex = 4,
		Parent = gui,
	})
	create("UICorner", { CornerRadius = UDim.new(0.5, 0), Parent = silentCircle })
	outline(silentCircle, Color3.fromRGB(255, 255, 255), 1)

	local silentLine = create("Frame", {
		AnchorPoint = Vector2.new(0.5, 0.5),
		BackgroundColor3 = THEME.accent,
		Visible = false,
		ZIndex = 0,
		Parent = gui,
	})

	-- knocked / downed flags (BodyEffects.K.O, or a Knocked / Downed value or attribute on the character)
	local function isKnocked(char)
		local fx = char:FindFirstChild("BodyEffects")
		local ko = fx and (fx:FindFirstChild("K.O") or fx:FindFirstChild("KO"))
		if ko and ko:IsA("BoolValue") and ko.Value then
			return true
		end
		for _, n in ipairs(KNOCK_NAMES) do
			if char:GetAttribute(n) == true then
				return true
			end
			local v = char:FindFirstChild(n)
			if v and v:IsA("BoolValue") and v.Value then
				return true
			end
		end
		return false
	end

	local function pickPart(char)
		local head = char:FindFirstChild("Head")
		local torso = char:FindFirstChild("UpperTorso") or char:FindFirstChild("Torso") or char:FindFirstChild("HumanoidRootPart")
		local mode = state.silent.part
		if mode == 1 then
			return head or torso
		elseif mode == 2 then
			return torso or head
		end
		if S.roll == 1 then
			return head or torso
		end
		return torso or head
	end

	-- returns the body part to aim at, or nil if this player is not allowed
	local function candidate(plr, cam)
		local s = state.silent
		if plr == player or whitelist[plr] then
			return nil
		end
		local char = plr.Character
		local hum = char and char:FindFirstChildOfClass("Humanoid")
		if not hum or hum.Health <= 0 then
			return nil
		end
		if state.aim.team and plr.Team ~= nil and plr.Team == player.Team then
			return nil
		end
		if s.health and hum.Health <= s.minHealth then
			return nil
		end
		if s.knock and isKnocked(char) then
			return nil
		end
		local part = pickPart(char)
		if not part or not isVisible(part, char, cam) then
			return nil
		end
		return part
	end

	local function screenDist(cam, part, center)
		local vp, onScreen = cam:WorldToViewportPoint(part.Position)
		if not onScreen then
			return math.huge
		end
		return (Vector2.new(vp.X, vp.Y) - center).Magnitude
	end

	local function resolve(cam, center, isFire)
		local s = state.silent
		if S.stuck and (not s.sticky or os.clock() - S.lastFire > STICKY_IDLE) then
			S.stuck = nil
		end

		-- your Target always wins, even outside the FOV circle. If it can't be hit right now
		-- (dead, knocked, behind a wall...) it falls through to the FOV pick below.
		if aimTarget then
			local part = candidate(aimTarget, cam)
			if part then
				return part
			end
		end

		-- sticky aim: keep the player you started shooting at
		if S.stuck then
			local part = candidate(S.stuck, cam)
			if part then
				return part
			end
			S.stuck = nil
		end

		-- otherwise: closest player to the crosshair. With Use FOV on, only players inside the circle
		-- count. With Use FOV off, every valid player counts, even ones off screen or behind you
		-- (the one closest to where you aim wins).
		local bestDist, bestPlr, bestPart = math.huge, nil, nil
		local aimDir = nil
		if not s.useFov then
			aimDir = cam:ViewportPointToRay(center.X, center.Y).Direction.Unit
		end
		for _, plr in ipairs(Players:GetPlayers()) do
			local part = candidate(plr, cam)
			if part then
				local d
				if s.useFov then
					d = screenDist(cam, part, center)
					if d > s.fov then
						d = nil
					end
				else
					local to = part.Position - cam.CFrame.Position
					d = (to.Magnitude > 0.001) and math.acos(math.clamp(aimDir:Dot(to.Unit), -1, 1)) or 0
				end
				if d and d < bestDist then
					bestDist, bestPlr, bestPart = d, plr, part
				end
			end
		end
		if bestPlr and s.sticky and isFire then
			S.stuck = bestPlr
		end
		return bestPart
	end

	local function aimedCFrame(cam)
		local part = S.cur
		if not (state.silent.on and part and part.Parent) then
			return nil
		end
		local pos = cam.CFrame.Position
		local look = CFrame.lookAt(pos, part.Position)
		if state.silent.center then
			return look -- the middle of the screen aims straight at the target (guns that fire along the camera look)
		end
		-- keep the offset between your mouse and the screen center, so guns that aim at the mouse hit too
		local p = aimPoint(cam)
		local ray = cam:ViewportPointToRay(p.X, p.Y)
		local dir = cam.CFrame:VectorToObjectSpace(ray.Direction)
		if dir.Magnitude < 1e-4 then
			return look
		end
		return CFrame.new(pos) * look.Rotation * CFrame.lookAt(Vector3.zero, dir):Inverse()
	end

	local function point()
		local cam = Workspace.CurrentCamera
		if not cam or saved then
			return
		end
		local cf = aimedCFrame(cam)
		if cf then
			saved = cam.CFrame
			cam.CFrame = cf
		end
	end

	local function restore()
		if saved then
			local cam = Workspace.CurrentCamera
			if cam then
				cam.CFrame = saved
			end
			saved = nil
		end
	end

	local function firing()
		if menuOpen then
			return false
		end
		if
			UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
			or UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
		then
			return true
		end
		for input in pairs(touches) do
			local st = input.UserInputState
			if st == Enum.UserInputState.End or st == Enum.UserInputState.Cancel then
				touches[input] = nil
			else
				return true
			end
		end
		return false
	end

	-- every frame (after the camera is restored): pick the target, draw the FOV circle and target line
	local function update()
		local s = state.silent
		local cam = Workspace.CurrentCamera
		if not (s.on and cam) then
			S.cur, S.stuck = nil, nil
			silentCircle.Visible = false
			silentLine.Visible = false
			return
		end
		local center = aimPoint(cam)
		local isFire = firing()
		if isFire then
			S.lastFire = os.clock()
		end
		S.roll = math.random(2)
		S.cur = resolve(cam, center, isFire)

		-- tells you what silent aim is doing when you shoot (so you can see if it has a target at all)
		if isFire and s.status and os.clock() - S.noteAt > 1.5 then
			S.noteAt = os.clock()
			local owner = S.cur and Players:GetPlayerFromCharacter(S.cur.Parent)
			notify(owner and ("Silent aim: " .. owner.DisplayName) or "Silent aim: no target")
		end

		silentCircle.Visible = s.useFov
		silentCircle.Size = UDim2.fromOffset(s.fov * 2, s.fov * 2)
		silentCircle.Position = UDim2.fromOffset(center.X, center.Y)

		local drawn = false
		if s.drawLine and S.cur then
			local vp, onScreen = cam:WorldToViewportPoint(S.cur.Position)
			if onScreen then
				ESP_DRAW.line(silentLine, center, Vector2.new(vp.X, vp.Y), 2, THEME.accent)
				drawn = true
			end
		end
		silentLine.Visible = drawn
	end

	-- the instant you press fire (the gun usually reads your aim right here)
	connect(UserInputService.InputBegan, function(input, processed)
		local t = input.UserInputType
		if t == Enum.UserInputType.Touch and not processed then
			touches[input] = true
		end
		if not state.silent.on or menuOpen then
			return
		end
		if
			((t == Enum.UserInputType.MouseButton1 or t == Enum.UserInputType.Touch) and not processed)
			or input.KeyCode == Enum.KeyCode.ButtonR2
		then
			point()
		end
	end)
	connect(UserInputService.InputEnded, function(input)
		touches[input] = nil
	end)

	-- while fire is held: point the camera after the camera script has run, and put it
	-- back before the frame is drawn (First = before the camera script, Last - 1 = before ESP / snaplines)
	RunService:BindToRenderStep("CarveCC_SilentA", Enum.RenderPriority.First.Value, restore)
	RunService:BindToRenderStep("CarveCC_SilentB", Enum.RenderPriority.Camera.Value + 2, function()
		if state.silent.on and firing() then
			point()
		end
	end)
	RunService:BindToRenderStep("CarveCC_SilentC", Enum.RenderPriority.Last.Value - 1, restore)
	RunService:BindToRenderStep("CarveCC_SilentT", Enum.RenderPriority.Last.Value, update)

	-- also swap right after physics while fire is held, for guns that read your aim in a Heartbeat /
	-- task.wait loop. It is always put back at the start of the next render step, before anything is drawn.
	connect(RunService.Heartbeat, function()
		if state.silent.on and firing() then
			point()
		end
	end)

	applyFns.silent = function(on)
		if on then
			notify("Silent aim on")
		else
			restore()
			S.cur, S.stuck = nil, nil
			silentCircle.Visible = false
			silentLine.Visible = false
			notify("Silent aim off")
		end
	end

	table.insert(cleanups, function()
		restore()
		for _, n in ipairs({ "CarveCC_SilentA", "CarveCC_SilentB", "CarveCC_SilentC", "CarveCC_SilentT" }) do
			pcall(function()
				RunService:UnbindFromRenderStep(n)
			end)
		end
	end)
end

--------------------------------------------------------------------------
-- Desync + jitter anti aim (??? tab): other players (and the server) see your
-- character differently than it really is. Right after each physics step the
-- character is moved / turned / given a fake velocity so that is what the
-- network sends, then everything is put back before your camera and the next
-- physics step, so you never see or feel it. Both features share one swap so
-- they can never fight each other.
--   Desync    Random   = random sideways offset every frame
--             Spin     = offset that circles around you
--             Up       = offset straight above you
--             Velocity = fake huge velocity (strength x 50 studs per second)
--   Anti aim  your facing flips between (base yaw + angle) and (base yaw - angle),
--             or uses a random angle, plus an optional pitch tilt
--------------------------------------------------------------------------
do
	local D = { root = nil, real = nil, sent = nil, realVel = nil, sentVel = nil, angle = 0 }
	local A = { timer = 0, flip = false, rand = 0 }

	-- a box where the desync offset puts you (drawn only on your screen)
	local ghost = create("BoxHandleAdornment", {
		Adornee = Workspace.Terrain,
		Size = Vector3.new(3, 6, 2),
		Color3 = THEME.accent,
		Transparency = 0.6,
		AlwaysOnTop = true,
		ZIndex = 1,
		Visible = false,
		Parent = gui,
	})

	local function restore()
		local root = D.root
		local real, sent, realVel, sentVel = D.real, D.sent, D.realVel, D.sentVel
		D.root, D.real, D.sent, D.realVel, D.sentVel = nil, nil, nil, nil, nil
		if not (root and root.Parent) then
			return
		end
		-- only put things back if nothing else (orbit, a teleport...) has moved the character since
		if real then
			local cur = root.CFrame
			if (cur.Position - sent.Position).Magnitude < 0.05 and cur.LookVector:Dot(sent.LookVector) > 0.999 then
				root.CFrame = real
			end
		end
		if realVel and (root.AssemblyLinearVelocity - sentVel).Magnitude < 1 then
			root.AssemblyLinearVelocity = realVel
		end
	end

	local function apply(dt)
		restore() -- never stack two swaps
		local d, a = state.desync, state.aa
		local showGhost = false
		if d.on or a.on then
			local char = player.Character
			local hum = char and char:FindFirstChildOfClass("Humanoid")
			local root = char and char:FindFirstChild("HumanoidRootPart")
			if hum and root and hum.Health > 0 then
				D.root = root
				local real = root.CFrame
				local sent = real

				-- jitter anti aim: turn the character, flipping every 1 / speed seconds
				if a.on then
					A.timer += dt
					local period = 1 / math.max(a.speed, 1)
					if A.timer >= period then
						A.timer = A.timer % period
						A.flip = not A.flip
						A.rand = math.random() * 2 - 1
					end
					local jitter
					if a.random then
						jitter = A.rand * a.angle
					else
						jitter = A.flip and a.angle or -a.angle
					end
					sent = sent
						* CFrame.Angles(0, math.rad(a.base + jitter), 0)
						* CFrame.Angles(math.rad(a.pitch), 0, 0)
				end

				-- desync: move the character or give it a fake velocity
				local offsetOn = false
				if d.on then
					if d.mode == 4 then
						local r = Vector3.new(math.random() - 0.5, math.random() - 0.5, math.random() - 0.5)
						if r.Magnitude < 0.01 then
							r = Vector3.yAxis
						end
						D.realVel = root.AssemblyLinearVelocity
						D.sentVel = r.Unit * (d.dist * 50)
						root.AssemblyLinearVelocity = D.sentVel
					else
						local offset
						if d.mode == 3 then
							offset = Vector3.new(0, d.dist, 0)
						else
							if d.mode == 2 then
								D.angle = (D.angle + 720 * dt) % 360
							else
								D.angle = math.random() * 360
							end
							local ang = math.rad(D.angle)
							offset = Vector3.new(math.cos(ang), 0, math.sin(ang)) * d.dist
						end
						sent = sent + offset
						offsetOn = true
					end
				end

				if a.on or offsetOn then
					D.real, D.sent = real, sent
					root.CFrame = sent
					if offsetOn and d.ghost then
						ghost.CFrame = sent
						showGhost = true
					end
				end
			end
		end
		ghost.Visible = showGhost
	end

	-- the swap goes on right after physics (Heartbeat) and comes off before the camera script runs (First)
	connect(RunService.Heartbeat, apply)
	RunService:BindToRenderStep("CarveCC_Desync", Enum.RenderPriority.First.Value, restore)

	applyFns.desync = function(on)
		if on then
			notify("Desync on")
		else
			restore()
			notify("Desync off")
		end
	end

	applyFns.aa = function(on)
		if on then
			notify("Anti aim on")
		else
			restore()
			notify("Anti aim off")
		end
	end

	table.insert(cleanups, function()
		restore()
		ghost.Visible = false
		pcall(function()
			RunService:UnbindFromRenderStep("CarveCC_Desync")
		end)
	end)
end

--------------------------------------------------------------------------
-- Triggerbot (??? tab): fires your equipped tool by itself while your crosshair
-- (the mouse on PC, the screen center on touch / controller) is on another player.
-- It calls tool:Activate(), so it works for guns that listen to Tool.Activated.
-- Walls block it (it needs a clear line to the player) unless Wallbang is on.
--------------------------------------------------------------------------
do
	local T = { seenAt = nil, nextShot = 0 }
	local params = RaycastParams.new()
	params.FilterType = Enum.RaycastFilterType.Exclude
	params.IgnoreWater = true

	local function playerFromPart(inst)
		local node = inst
		while node and node ~= Workspace do
			if node:IsA("Model") then
				local plr = Players:GetPlayerFromCharacter(node)
				if plr then
					return plr
				end
			end
			node = node.Parent
		end
		return nil
	end

	-- hit part setting: 1 = any part, 2 = head only, 3 = torso only
	local function partOk(inst)
		local mode = state.trigger.part
		if mode == 1 then
			return true
		end
		local n = inst.Name
		if mode == 2 then
			return n == "Head"
		end
		return n == "UpperTorso" or n == "LowerTorso" or n == "Torso" or n == "HumanoidRootPart"
	end

	local function targetable(plr)
		local t = state.trigger
		if plr == player or whitelist[plr] then
			return false
		end
		if t.onlyTarget and plr ~= aimTarget then
			return false
		end
		if t.team and plr.Team ~= nil and plr.Team == player.Team then
			return false
		end
		local hum = plr.Character and plr.Character:FindFirstChildOfClass("Humanoid")
		return hum ~= nil and hum.Health > 0
	end

	-- is the first thing a ray through this screen point hits a valid player?
	local function onPlayer(cam, x, y)
		local ray = cam:ViewportPointToRay(x, y)
		local result = Workspace:Raycast(ray.Origin, ray.Direction.Unit * state.trigger.range, params)
		if not result then
			return false
		end
		local plr = playerFromPart(result.Instance)
		return plr ~= nil and partOk(result.Instance) and targetable(plr)
	end

	local function aimedAtEnemy(cam)
		params.FilterDescendantsInstances = { player.Character }
		local p = aimPoint(cam)
		if onPlayer(cam, p.X, p.Y) then
			return true
		end
		local r = state.trigger.radius
		if r > 0 then
			return onPlayer(cam, p.X + r, p.Y)
				or onPlayer(cam, p.X - r, p.Y)
				or onPlayer(cam, p.X, p.Y + r)
				or onPlayer(cam, p.X, p.Y - r)
		end
		return false
	end

	local function triggerStep()
		local t = state.trigger
		if not t.on or menuOpen or UserInputService:GetFocusedTextBox() or (t.needKey and not aimHeld) then
			T.seenAt = nil
			return
		end
		local cam = Workspace.CurrentCamera
		local char = player.Character
		local tool = char and char:FindFirstChildOfClass("Tool")
		if not (cam and tool) or not aimedAtEnemy(cam) then
			T.seenAt = nil
			return
		end

		local now = os.clock()
		T.seenAt = T.seenAt or now
		if now - T.seenAt < t.delay / 1000 or now < T.nextShot then
			return
		end
		-- you are already holding fire yourself: don't add extra shots on top
		if
			UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1)
			or UserInputService:IsGamepadButtonDown(Enum.UserInputType.Gamepad1, Enum.KeyCode.ButtonR2)
		then
			return
		end

		T.nextShot = now + t.interval / 1000
		recordShot() -- lets hit chams / hit marker / hit sounds count these shots too
		pcall(tool.Activate, tool)
	end

	connect(RunService.Heartbeat, triggerStep)

	applyFns.trigger = function(on)
		T.seenAt = nil
		notify(on and "Triggerbot on" or "Triggerbot off")
	end
end

--------------------------------------------------------------------------
-- Velocity + animation speed (Player tab)
-- Velocity sets your horizontal speed directly every frame, so you stop the
-- moment you let go (no sliding, even on slippery parts).
-- Animation speed scales every playing animation; 100% = normal.
--------------------------------------------------------------------------
do
	local scaled = setmetatable({}, { __mode = "k" }) -- [track] = { base = speed the game set, set = speed we set }

	local function restoreAnims()
		for track, rec in pairs(scaled) do
			scaled[track] = nil
			pcall(function()
				if track.Speed == rec.set then
					track:AdjustSpeed(rec.base)
				end
			end)
		end
	end

	-- Velocity: non-slippery movement
	connect(RunService.Heartbeat, function()
		local v = state.velocity
		if not v.on or state.fly.on or state.orbit.on or state.above.on then
			return
		end
		local hum, char = getHumanoid()
		local root = char and char:FindFirstChild("HumanoidRootPart")
		if not (hum and root) or hum.Health <= 0 or hum.PlatformStand or hum.Sit then
			return
		end
		local move = hum.MoveDirection -- world space, camera relative, zero when there is no input
		local vel = root.AssemblyLinearVelocity
		root.AssemblyLinearVelocity = Vector3.new(move.X * v.value, vel.Y, move.Z * v.value)
	end)

	-- Animation speed scale (100% = normal)
	connect(RunService.Heartbeat, function()
		local scale = state.animSpeed.value / 100
		if scale == 1 then
			if next(scaled) then
				restoreAnims()
			end
			return
		end
		local hum = getHumanoid()
		local animator = hum and hum:FindFirstChildOfClass("Animator")
		if not animator then
			return
		end
		for _, track in ipairs(animator:GetPlayingAnimationTracks()) do
			local rec = scaled[track]
			if not rec then
				rec = { base = track.Speed, set = track.Speed }
				scaled[track] = rec
			elseif track.Speed ~= rec.set then
				rec.base = track.Speed -- the game changed it, use that as the new normal
			end
			local want = rec.base * scale
			if math.abs(track.Speed - want) > 1e-4 then
				track:AdjustSpeed(want)
			end
			rec.set = track.Speed
		end
	end)

	applyFns.velocity = function(on)
		notify(on and "Velocity on" or "Velocity off")
	end

	table.insert(cleanups, restoreAnims)
end

--------------------------------------------------------------------------
-- UI accent color
--------------------------------------------------------------------------
local accentRGB = { r = 180, g = 10, b = 16 }

local function applyAccent()
	local color = Color3.fromRGB(accentRGB.r, accentRGB.g, accentRGB.b)
	THEME.accent = color
	for _, ref in ipairs(accentRefs) do
		pcall(function()
			ref[1][ref[2]] = color
		end)
	end
	if titleLabel then
		titleLabel.Text = 'carve<font color="#' .. color:ToHex() .. '">.cc</font>'
	end
	for _, fn in ipairs(toggleObjs) do
		fn()
	end
	refreshActionButtons()
	for _, fn in ipairs(accentHooks) do
		fn()
	end
end

--------------------------------------------------------------------------
-- Unload
--------------------------------------------------------------------------
local function unload()
	for _, fn in ipairs(cleanups) do
		pcall(fn)
	end
	for _, n in ipairs({ "walk", "jump", "fly", "velocity", "aim", "silent", "desync", "aa", "trigger", "range", "btp", "rapid", "orbit", "above", "hitbox", "wallbang" }) do
		if state[n].on then
			setEnabled(n, false)
		end
	end
	pcall(function()
		RunService:UnbindFromRenderStep("CarveCC_Aim")
	end)
	for _, c in ipairs(connections) do
		c:Disconnect()
	end
	GuiService.SelectedObject = nil
	gui:Destroy()
end

--------------------------------------------------------------------------
-- Page: Main
--------------------------------------------------------------------------
do
	local page = pages["Main"]

	local profile = makeCard(page, "Profile")
	local holder = create("Frame", {
		Size = UDim2.new(1, 0, 0, 90),
		BackgroundTransparency = 1,
		Parent = profile,
	})
	local avatar = create("ImageLabel", {
		AnchorPoint = Vector2.new(0.5, 0),
		Position = UDim2.fromScale(0.5, 0),
		Size = UDim2.fromOffset(84, 84),
		BackgroundColor3 = THEME.panel,
		Image = "",
		Parent = holder,
	})
	round(avatar, 42)
	outline(avatar, THEME.accent, 2)
	loadThumbnail(avatar, player.UserId)

	makeLabel({
		Text = "@" .. player.Name,
		Font = Enum.Font.GothamBold,
		TextSize = 15,
		TextXAlignment = Enum.TextXAlignment.Center,
		Size = UDim2.new(1, 0, 0, 22),
		Parent = profile,
	})
	local fpsValue = statRow(profile, "FPS")
	local timeValue = statRow(profile, "Time with UI")

	local gameValue = statRow(profile, "Game")
	gameValue.TextTruncate = Enum.TextTruncate.AtEnd
	gameValue.Text = game.Name
	local playersValue = statRow(profile, "Players")
	playersValue.Text = tostring(#Players:GetPlayers()) .. " / " .. tostring(Players.MaxPlayers)

	-- the real game name (async; it stays on game.Name if it can't be fetched, e.g. in Studio)
	task.spawn(function()
		local ok, info = pcall(function()
			return game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId)
		end)
		if ok and info and info.Name and gameValue.Parent then
			gameValue.Text = info.Name
		end
	end)

	local TeleportService = game:GetService("TeleportService")
	local HttpService = game:GetService("HttpService")
	local teleporting = false

	local function startTeleport(message, fn)
		if teleporting then
			return
		end
		teleporting = true
		notify(message)
		task.delay(8, function()
			teleporting = false
		end)
		if not pcall(fn) then
			teleporting = false
			notify("Teleport failed")
		end
	end

	local function rejoin()
		if game.PrivateServerId ~= "" then
			notify("Can't rejoin a private server")
			return
		end
		startTeleport("Rejoining...", function()
			if #Players:GetPlayers() <= 1 then
				TeleportService:Teleport(game.PlaceId, player) -- you are alone: this server closes when you leave
			else
				TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, player)
			end
		end)
	end

	local function serverHop()
		if teleporting then
			return
		end
		task.spawn(function()
			-- picks a different public server when web requests are available (some executors);
			-- otherwise Roblox picks the server
			local serverId
			local req = (syn and syn.request) or (http and http.request) or http_request or request
			if req then
				local ok, list = pcall(function()
					local res = req({
						Url = "https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100",
						Method = "GET",
					})
					return HttpService:JSONDecode(res.Body)
				end)
				if ok and type(list) == "table" and type(list.data) == "table" then
					local options = {}
					for _, s in ipairs(list.data) do
						if s.id ~= game.JobId and s.playing and s.maxPlayers and s.playing < s.maxPlayers then
							table.insert(options, s.id)
						end
					end
					if #options > 0 then
						serverId = options[math.random(#options)]
					end
				end
			end
			startTeleport("Hopping servers...", function()
				if serverId then
					TeleportService:TeleportToPlaceInstance(game.PlaceId, serverId, player)
				else
					TeleportService:Teleport(game.PlaceId, player)
				end
			end)
		end)
	end

	connect(TeleportService.TeleportInitFailed, function(_, result)
		teleporting = false
		notify("Teleport failed: " .. (typeof(result) == "EnumItem" and result.Name or "unknown"))
	end)

	local serverButtons = create("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent = profile,
	})
	create("UIGridLayout", {
		CellSize = UDim2.new(0.5, -3, 0, 30),
		CellPadding = UDim2.fromOffset(6, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = serverButtons,
	})
	makeButton(serverButtons, "Rejoin", rejoin)
	makeButton(serverButtons, "Server hop", serverHop)

	local frames, lastTick = 0, os.clock()
	connect(RunService.RenderStepped, function()
		frames += 1
		local now = os.clock()
		if now - lastTick >= 0.5 then
			fpsValue.Text = tostring(math.floor(frames / (now - lastTick) + 0.5))
			frames, lastTick = 0, now
			local s = math.floor(now - startClock)
			timeValue.Text = string.format("%02d:%02d:%02d", s // 3600, (s % 3600) // 60, s % 60)
			playersValue.Text = tostring(#Players:GetPlayers()) .. " / " .. tostring(Players.MaxPlayers)
		end
	end)

	local keys = makeCard(page, "Menu keybind")
	makeToggle(keys, "Use keybinds to open the menu", state.menuKeys, function(v)
		state.menuKeys = v
		updateFab()
	end)
	makeBindRow(keys, "Open / close menu", "menu")
end

--------------------------------------------------------------------------
-- Page: Player
--------------------------------------------------------------------------
do
	local page = pages["Player"]
	featureCard(page, "walk", "Walk Speed", "Speed", 0, 7666)

	-- Velocity: non-slippery movement + velocity speed + animation speed
	local vel = makeCard(page, "Velocity")
	local velToggle = makeToggle(vel, "Velocity", state.velocity.on, function(v)
		setEnabled("velocity", v)
	end)
	onChange("velocity", velToggle.setVisual)
	makeSlider(vel, "Velocity speed", 0, 7666, state.velocity.value, function(v)
		state.velocity.value = v
	end)
	makeSlider(vel, "Animation speed (%)", 10, 400, state.animSpeed.value, function(v)
		state.animSpeed.value = v
	end)
	makeBindRow(vel, "Velocity keybind", "velocity")

	featureCard(page, "jump", "Jump Boost", "Jump power", 0, 7666)
	featureCard(page, "fly", "Fly", "Fly speed", 0, 7666)
end

--------------------------------------------------------------------------
-- Page: Aim
--------------------------------------------------------------------------
do
	local page = pages["Aim"]
	local card = makeCard(page, "Aimbot")

	local t = makeToggle(card, "Enabled", false, function(v)
		setEnabled("aim", v)
	end)
	onChange("aim", t.setVisual)

	makeBindRow(card, "Aim key (hold)", "aim")
	makeBindRow(card, "Turn on / off", "aimToggle")

	makeSlider(card, "FOV", 20, 600, state.aim.fov, function(v)
		state.aim.fov = v
		updateFov()
	end)
	makeSlider(card, "Smoothness", 0, 95, state.aim.smooth, function(v)
		state.aim.smooth = v
	end)

	makeButton(card, "Target: " .. state.aim.part, function(btn)
		state.aim.part = (state.aim.part == "Head") and "Torso" or "Head"
		btn.Text = "Target: " .. state.aim.part
	end)

	makeToggle(card, "Team check", state.aim.team, function(v)
		state.aim.team = v
	end)
	makeToggle(card, "Wall check", state.aim.wall, function(v)
		state.aim.wall = v
	end)
	makeToggle(card, "Lock notification", state.aim.notify, function(v)
		state.aim.notify = v
	end)

	local sa = makeCard(page, "Silent aim")
	local saToggle = makeToggle(sa, "Enabled", state.silent.on, function(v)
		setEnabled("silent", v)
	end)
	onChange("silent", saToggle.setVisual)
	local silentParts = { "Head", "Torso", "Random" }
	makeButton(sa, "Target part: " .. silentParts[state.silent.part], function(btn)
		state.silent.part = state.silent.part % #silentParts + 1
		btn.Text = "Target part: " .. silentParts[state.silent.part]
	end)
	makeToggle(sa, "Use FOV", state.silent.useFov, function(v)
		state.silent.useFov = v
	end)
	makeSlider(sa, "Silent aim FOV", 20, 600, state.silent.fov, function(v)
		state.silent.fov = v
	end)
	makeToggle(sa, "Draw target line", state.silent.drawLine, function(v)
		state.silent.drawLine = v
	end)
	makeToggle(sa, "Aim camera center (try if shots miss)", state.silent.center, function(v)
		state.silent.center = v
	end)
	makeToggle(sa, "Show status when firing", state.silent.status, function(v)
		state.silent.status = v
	end)
	makeToggle(sa, "Sticky aim", state.silent.sticky, function(v)
		state.silent.sticky = v
	end)
	makeToggle(sa, "Knock check", state.silent.knock, function(v)
		state.silent.knock = v
	end)
	makeToggle(sa, "Health check", state.silent.health, function(v)
		state.silent.health = v
	end)
	makeSlider(sa, "Skip targets at or below (HP)", 1, 100, state.silent.minHealth, function(v)
		state.silent.minHealth = v
	end)

	local hb = makeCard(page, "Hitbox expander")
	local hbToggle = makeToggle(hb, "Enabled", state.hitbox.on, function(v)
		setEnabled("hitbox", v)
	end)
	onChange("hitbox", hbToggle.setVisual)
	makeSlider(hb, "Hitbox size", 2, 100, state.hitbox.size, function(v)
		state.hitbox.size = v
	end)
	makeToggle(hb, "Show hitbox (visual)", state.hitbox.visual, function(v)
		state.hitbox.visual = v
	end)
end

--------------------------------------------------------------------------
-- Page: Local Players
--------------------------------------------------------------------------
do
	local page = pages["Local Players"]
	local targetCard = makeCard(page, "Target keybind")
	makeBindRow(targetCard, "Target player", "target")

	local card = makeCard(page, "Players in this server")
	local list = create("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent = card,
	})
	listLayout(list, 4)

	local function rebuild(leaving)
		for _, child in ipairs(list:GetChildren()) do
			if child:IsA("Frame") then
				child:Destroy()
			end
		end
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= leaving then
				local row = create("Frame", {
					Size = UDim2.new(1, 0, 0, 40),
					BackgroundColor3 = THEME.panel,
					Parent = list,
				})
				round(row, 6)
				local img = create("ImageLabel", {
					Position = UDim2.fromOffset(6, 4),
					Size = UDim2.fromOffset(32, 32),
					BackgroundColor3 = THEME.card,
					Image = "",
					Parent = row,
				})
				round(img, 16)
				loadThumbnail(img, plr.UserId)
				addPlayerActions(row, plr)
				makeLabel({
					Text = plr.DisplayName .. (plr == player and " (you)" or ""),
					Font = Enum.Font.GothamBold,
					Position = UDim2.fromOffset(46, 2),
					Size = UDim2.new(1, -52, 0, 18),
					Parent = row,
				})
				makeLabel({
					Text = "@" .. plr.Name,
					TextColor3 = THEME.sub,
					TextSize = 11,
					Position = UDim2.fromOffset(46, 20),
					Size = UDim2.new(1, -52, 0, 16),
					Parent = row,
				})
			end
		end
	end

	connect(Players.PlayerAdded, function()
		rebuild()
	end)
	connect(Players.PlayerRemoving, function(leaving)
		rebuild(leaving)
	end)
	rebuild()
end

--------------------------------------------------------------------------
-- Page: Visuals
--------------------------------------------------------------------------
do
	local page = pages["Visuals"]
	local card = makeCard(page, "Visuals")
	makeToggle(card, "Show FOV circle (while aimbot is on)", state.visuals.fov, function(v)
		state.visuals.fov = v
		updateFov()
	end)
end

--------------------------------------------------------------------------
-- Page: Settings
--------------------------------------------------------------------------
do
	local page = pages["Settings"]
	local card = makeCard(page, "Interface")
	makeSlider(card, "Menu transparency (%)", 0, 60, 0, function(v)
		window.BackgroundTransparency = v / 100
	end)
	makeButton(card, "Unload UI", unload)

	local perf = makeCard(page, "Performance & character")
	makeToggle(perf, "Boost FPS", state.fpsBoost, function(v)
		setFpsBoost(v)
	end)
	makeButton(perf, "Reset character", function()
		resetCharacter()
	end)

	local look = makeCard(page, "UI color")
	local setR, setG, setB
	setR = makeSlider(look, "Red", 0, 255, accentRGB.r, function(v)
		accentRGB.r = v
		applyAccent()
	end)
	setG = makeSlider(look, "Green", 0, 255, accentRGB.g, function(v)
		accentRGB.g = v
		applyAccent()
	end)
	setB = makeSlider(look, "Blue", 0, 255, accentRGB.b, function(v)
		accentRGB.b = v
		applyAccent()
	end)
	makeSwatches(look, "Presets", UI_PRESETS, function(c)
		setR(math.floor(c.R * 255 + 0.5))
		setG(math.floor(c.G * 255 + 0.5))
		setB(math.floor(c.B * 255 + 0.5))
	end)

	-- Unkeybind all: clears every keyboard / mouse / controller bind so you can redo them
	local bindCard = makeCard(page, "Keybinds")
	local function unbindAll()
		endCapture()
		for _, b in pairs(binds) do
			b.kb = nil
			b.pad = nil
		end
		aimHeld = false
		for _, fn in ipairs(bindRefreshers) do
			fn()
		end
		updateFab()
		notify("All keybinds cleared")
	end
	local armedAt = 0
	makeButton(bindCard, "Unkeybind all", function(btn)
		if os.clock() - armedAt < 3 then
			armedAt = 0
			btn.Text = "Unkeybind all"
			unbindAll()
		else
			armedAt = os.clock()
			btn.Text = "Click again to confirm"
			task.delay(3, function()
				if armedAt ~= 0 and os.clock() - armedAt >= 3 and btn.Parent then
					armedAt = 0
					btn.Text = "Unkeybind all"
				end
			end)
		end
	end)

	local about = makeCard(page, "About")
	makeLabel({
		Text = "carve.cc  |  build 1.0",
		TextColor3 = THEME.sub,
		Size = UDim2.new(1, 0, 0, 20),
		Parent = about,
	})
end

--------------------------------------------------------------------------
-- Init
--------------------------------------------------------------------------
updateFov()
-- Visuals: ESP
do
	local page = pages["Visuals"]
	local card = makeCard(page, "ESP")
	makeToggle(card, "Enable ESP", state.esp.on, function(v)
		state.esp.on = v
	end)
	makeToggle(card, "Box ESP", state.esp.box, function(v)
		state.esp.box = v
	end)
	makeToggle(card, "Health", state.esp.health, function(v)
		state.esp.health = v
	end)
	makeToggle(card, "Name", state.esp.name, function(v)
		state.esp.name = v
	end)
	makeSlider(card, "Name size", 8, 30, state.esp.nameSize, function(v)
		state.esp.nameSize = v
	end)
	makeToggle(card, "Skeleton ESP", state.esp.skeleton, function(v)
		state.esp.skeleton = v
	end)
	makeToggle(card, "Head dot", state.esp.headDot, function(v)
		state.esp.headDot = v
	end)
	makeToggle(card, "Held item", state.esp.held, function(v)
		state.esp.held = v
	end)
	makeToggle(card, "Distance", state.esp.distance, function(v)
		state.esp.distance = v
	end)

	-- Fonts: a button that opens / closes the list of ESP text fonts
	-- (the header is created first, then the list, so the list sits right under it in the card)
	local fontList
	makeButton(card, "Fonts  [+]", function(btn)
		fontList.Visible = not fontList.Visible
		btn.Text = fontList.Visible and "Fonts  [-]" or "Fonts  [+]"
	end)
	fontList = create("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Visible = false,
		Parent = card,
	})
	listLayout(fontList, 4)

	local fontButtons = {}
	local function refreshFontButtons()
		for i, b in ipairs(fontButtons) do
			b.BackgroundColor3 = (i == state.esp.font) and THEME.accent or THEME.panel
		end
	end
	table.insert(accentHooks, refreshFontButtons)

	for i, def in ipairs(state.esp.fonts) do
		local btn = makeButton(fontList, def[1], function()
			state.esp.font = i
			refreshFontButtons()
		end)
		btn.Font = def[2] -- each button previews its own font
		fontButtons[i] = btn
	end
	refreshFontButtons()

	makeSlider(card, "Health bar width", 1, 8, state.esp.healthWidth, function(v)
		state.esp.healthWidth = v
	end)
	makeSlider(card, "Box size (%)", 30, 200, state.esp.boxSize, function(v)
		state.esp.boxSize = v
	end)
	makeToggle(card, "Tracers", state.esp.tracers, function(v)
		state.esp.tracers = v
	end)
	makeToggle(card, "Hide teammates", state.esp.team, function(v)
		state.esp.team = v
	end)
end

-- Target keybind: press to target the player closest to your mouse, press again to clear.
-- Registered here (not next to the other actions) because toggleTarget is declared further down the file.
do
	local function nearestToMouse()
		local cam = Workspace.CurrentCamera
		if not cam then
			return nil
		end
		local center = aimPoint(cam) -- mouse position (screen center on touch / controller)
		local bestDist, best = math.huge, nil
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= player and not whitelist[plr] then
				local char = plr.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				local sameTeam = state.aim.team and plr.Team ~= nil and plr.Team == player.Team
				if root and hum and hum.Health > 0 and not sameTeam then
					local vp, onScreen = cam:WorldToViewportPoint(root.Position)
					if onScreen then
						local d = (Vector2.new(vp.X, vp.Y) - center).Magnitude
						if d < bestDist then
							bestDist, best = d, plr
						end
					end
				end
			end
		end
		return best
	end

	actions.target = {
		press = function()
			if aimTarget then
				toggleTarget(aimTarget) -- already targeting someone: clear it
				return
			end
			local plr = nearestToMouse()
			if plr then
				toggleTarget(plr)
			else
				notify("No player to target")
			end
		end,
	}
end

-- Visuals: mouse snapline (a line from your mouse to every player)
do
	local snapColors = {
		{ "White", Color3.fromRGB(255, 255, 255) },
		{ "Red", Color3.fromRGB(255, 60, 60) },
		{ "Blue", Color3.fromRGB(70, 120, 255) },
		{ "Green", Color3.fromRGB(80, 255, 120) },
		{ "Pink", Color3.fromRGB(255, 100, 200) },
		{ "Purple", Color3.fromRGB(180, 90, 255) },
	}

	local page = pages["Visuals"]
	local card = makeCard(page, "Mouse snapline")
	makeToggle(card, "Enable snapline", state.snap.on, function(v)
		state.snap.on = v
	end)
	makeToggle(card, "Hide teammates", state.snap.team, function(v)
		state.snap.team = v
	end)
	makeToggle(card, "Show line to selected target", state.snap.auto, function(v)
		state.snap.auto = v
	end)
	makeToggle(card, "Only show line on target (hide everyone else)", state.snap.targetOnly, function(v)
		state.snap.targetOnly = v
	end)
	makeSlider(card, "Line thickness", 1, 6, state.snap.thickness, function(v)
		state.snap.thickness = v
	end)

	local colorLabel = makeLabel({ Text = "Color: White", Size = UDim2.new(1, 0, 0, 18), Parent = card })
	local swatchRow = create("Frame", {
		Size = UDim2.new(1, 0, 0, 26),
		BackgroundTransparency = 1,
		Parent = card,
	})
	create("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = UDim.new(0, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = swatchRow,
	})
	local swatches = {}
	local function pickColor(index)
		state.snap.color = snapColors[index][2]
		colorLabel.Text = "Color: " .. snapColors[index][1]
		for i, sw in ipairs(swatches) do
			local selected = (i == index)
			sw.button.BackgroundTransparency = selected and 0 or 0.6
			sw.stroke.Thickness = selected and 2 or 1
			sw.stroke.Color = selected and Color3.new(1, 1, 1) or THEME.stroke
		end
	end
	for i, def in ipairs(snapColors) do
		local button = create("TextButton", {
			Size = UDim2.fromOffset(34, 24),
			BackgroundColor3 = def[2],
			AutoButtonColor = false,
			Text = "",
			LayoutOrder = i,
			Parent = swatchRow,
		})
		round(button, 5)
		swatches[i] = { button = button, stroke = outline(button) }
		button.Activated:Connect(function()
			pickColor(i)
		end)
	end
	pickColor(1)

	-- ZIndex 0 keeps the lines underneath the menu window
	local snapRoot = create("Frame", {
		Name = "Snap",
		BackgroundTransparency = 1,
		Size = UDim2.fromScale(1, 1),
		ZIndex = 0,
		Parent = gui,
	})
	local lines = {}

	local function snapStep()
		local s = state.snap
		local cam = Workspace.CurrentCamera
		-- with a target selected, the line goes to that player only (even if the snapline is off).
		-- "Only show line on target" also hides everyone else, so with no target nothing is drawn.
		local hasTarget = aimTarget ~= nil
		local onlyTarget = hasTarget and (s.auto or s.targetOnly)
		local showAll = s.on and not s.targetOnly
		if not (cam and (showAll or onlyTarget)) then
			for _, line in pairs(lines) do
				line.Visible = false
			end
			return
		end
		local from = aimPoint(cam) -- mouse position (screen center on touch / controller)
		for _, plr in ipairs(Players:GetPlayers()) do
			if plr ~= player then
				local line = lines[plr]
				if not line then
					line = create("Frame", {
						AnchorPoint = Vector2.new(0.5, 0.5),
						Visible = false,
						Parent = snapRoot,
					})
					lines[plr] = line
				end
				local show = false
				local char = plr.Character
				local root = char and char:FindFirstChild("HumanoidRootPart")
				local hum = char and char:FindFirstChildOfClass("Humanoid")
				local wanted = (not onlyTarget) or plr == aimTarget
				local teamHidden = (not onlyTarget) and s.team and plr.Team ~= nil and plr.Team == player.Team
				if wanted and root and hum and hum.Health > 0 and not teamHidden then
					local vp, onScreen = cam:WorldToViewportPoint(root.Position)
					local to = nil
					if onScreen then
						to = Vector2.new(vp.X, vp.Y)
					elseif onlyTarget then
						-- target is off screen: point toward where they are
						local rel = cam.CFrame:PointToObjectSpace(root.Position)
						local dir = Vector2.new(rel.X, -rel.Y)
						if dir.Magnitude < 0.001 then
							dir = Vector2.new(0, 1)
						end
						to = from + dir.Unit * 140
					end
					if to then
						local d = to - from
						if d.Magnitude > 2 then
							show = true
							line.BackgroundColor3 = s.color
							line.Size = UDim2.fromOffset(d.Magnitude, s.thickness)
							line.Position = UDim2.fromOffset((from.X + to.X) / 2, (from.Y + to.Y) / 2)
							line.Rotation = math.deg(math.atan2(d.Y, d.X))
						end
					end
				end
				line.Visible = show
			end
		end
	end

	RunService:BindToRenderStep("CarveCC_Snap", Enum.RenderPriority.Last.Value, snapStep)
	table.insert(cleanups, function()
		RunService:UnbindFromRenderStep("CarveCC_Snap")
	end)
	connect(Players.PlayerRemoving, function(plr)
		local line = lines[plr]
		if line then
			line:Destroy()
			lines[plr] = nil
		end
	end)
end

-- Hit Marks: crosshairs, hit chams, hit marker, hit sounds
do
	local page = pages["Hit Marks"]

	local card = makeCard(page, "Crosshair")
	makeToggle(card, "Enable crosshair", state.cross.on, function(v)
		state.cross.on = v
		rebuildCrosshair()
		setCursor()
	end)

	local grid = create("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent = card,
	})
	create("UIGridLayout", {
		CellSize = UDim2.new(0.5, -3, 0, 28),
		CellPadding = UDim2.fromOffset(6, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = grid,
	})
	for i, style in ipairs(crossStyles) do
		styleButtons[i] = makeButton(grid, style.name, function()
			state.cross.style = i
			rebuildCrosshair()
			refreshStyleButtons()
		end)
	end

	makeSlider(card, "Size", 4, 80, state.cross.size, function(v)
		state.cross.size = v
		rebuildCrosshair()
	end)
	makeSlider(card, "Thickness", 1, 8, state.cross.thickness, function(v)
		state.cross.thickness = v
		rebuildCrosshair()
	end)
	makeSlider(card, "Gap", 0, 30, state.cross.gap, function(v)
		state.cross.gap = v
		rebuildCrosshair()
	end)
	makeSlider(card, "Spin speed (spinning styles)", 20, 720, state.cross.speed, function(v)
		state.cross.speed = v
	end)
	makeSwatches(card, "Crosshair color", PALETTE, function(c)
		state.cross.color = c
		rebuildCrosshair()
	end)
	makeToggle(card, "Follow mouse", state.cross.follow, function(v)
		state.cross.follow = v
	end)
	makeToggle(card, "Hide Roblox cursor", state.cross.hideCursor, function(v)
		state.cross.hideCursor = v
		setCursor()
	end)

	local chams = makeCard(page, "Hit chams")
	makeToggle(chams, "Enable hit chams", state.hit.chams, function(v)
		state.hit.chams = v
	end)
	makeSwatches(chams, "Hit cham fill color", PALETTE, function(c)
		state.hit.chamFill = c
	end)
	makeSwatches(chams, "Hit cham outline color", PALETTE, function(c)
		state.hit.chamOutline = c
	end)
	makeSlider(chams, "Fill transparency (%)", 0, 100, state.hit.chamFillT, function(v)
		state.hit.chamFillT = v
	end)
	makeSlider(chams, "Duration (x0.1s)", 1, 30, state.hit.chamTime, function(v)
		state.hit.chamTime = v
	end)

	local marker = makeCard(page, "Hit marker")
	makeToggle(marker, "Flash an X on hit (red on kill)", state.hit.marker, function(v)
		state.hit.marker = v
	end)

	local snd = makeCard(page, "Hit sounds")
	makeToggle(snd, "Enable hit sounds", state.hit.sound, function(v)
		state.hit.sound = v
	end)

	local soundButtons = {}
	local function refreshSoundButtons()
		for i, b in ipairs(soundButtons) do
			b.BackgroundColor3 = (i == state.hit.soundIndex) and THEME.accent or THEME.panel
		end
	end
	table.insert(accentHooks, refreshSoundButtons)

	local soundGrid = create("Frame", {
		Size = UDim2.new(1, 0, 0, 0),
		AutomaticSize = Enum.AutomaticSize.Y,
		BackgroundTransparency = 1,
		Parent = snd,
	})
	create("UIGridLayout", {
		CellSize = UDim2.new(0.5, -3, 0, 28),
		CellPadding = UDim2.fromOffset(6, 6),
		SortOrder = Enum.SortOrder.LayoutOrder,
		Parent = soundGrid,
	})

	local setIdText
	for i, def in ipairs(hitSounds) do
		soundButtons[i] = makeButton(soundGrid, def.name, function()
			state.hit.soundIndex = i
			setIdText(hitSounds[i].id)
			refreshSoundButtons()
		end)
	end

	setIdText = makeTextInput(snd, "Sound ID", hitSounds[state.hit.soundIndex].id, function(text)
		hitSounds[state.hit.soundIndex].id = text
	end)
	makeSlider(snd, "Volume (%)", 0, 100, state.hit.volume, function(v)
		state.hit.volume = v
	end)
	makeButton(snd, "Test sound", function()
		playHitSound(true)
	end)

	refreshSoundButtons()
	refreshStyleButtons()
	rebuildCrosshair()
end

-- Rapid fire helper: while it is on, cooldown / delay settings found on your guns
-- (NumberValues, IntValues, attributes and settings ModuleScripts) are lowered so the gun
-- can keep up with the shot rate. Originals are put back when it is turned off.
do
	local FAST = 0.001
	local rec = {} -- [target] = { [key] = original value }
	local failed = setmetatable({}, { __mode = "k" })
	local busy = setmetatable({}, { __mode = "k" })
	local rescanAt = 0
	local SKIP = { "reload", "equip", "spread", "recoil", "respawn", "burst", "ammo", "damage", "anim", "heal" }

	-- "delay" = seconds between shots (lower is faster), "rpm" = shots per minute (higher is faster)
	local function kindOf(name, value)
		local n = string.lower(name)
		for _, bad in ipairs(SKIP) do
			if n:find(bad, 1, true) then
				return nil
			end
		end
		if n:find("rpm", 1, true) then
			return "rpm"
		end
		if value <= FAST or value > 30 then
			return nil
		end
		if
			n:find("cooldown", 1, true)
			or n:find("debounce", 1, true)
			or n:find("delay", 1, true)
			or n:find("interval", 1, true)
		then
			return "delay"
		end
		if (n:find("firerate", 1, true) or n:find("fire_rate", 1, true)) and value <= 2 then
			return "delay" -- small values here are almost always seconds per shot
		end
		return nil
	end

	local function lower(target, key, old, kind, setter)
		local newValue = (kind == "rpm") and 100000 or FAST
		if kind == "rpm" and old >= newValue then
			return
		end
		if not pcall(setter, newValue) then
			return
		end
		local r = rec[target]
		if not r then
			r = {}
			rec[target] = r
		end
		if r[key] == nil then
			r[key] = old
		end
	end

	local function scanTable(tbl, depth, seen)
		if depth > 4 or seen[tbl] then
			return
		end
		seen[tbl] = true
		for k, v in pairs(tbl) do
			if type(v) == "table" then
				scanTable(v, depth + 1, seen)
			elseif type(k) == "string" and type(v) == "number" then
				local kind = kindOf(k, v)
				if kind then
					lower(tbl, k, v, kind, function(x)
						tbl[k] = x
					end)
				end
			end
		end
	end

	local function scanInstance(inst)
		if inst:IsA("NumberValue") or inst:IsA("IntValue") then
			local kind = kindOf(inst.Name, inst.Value)
			if kind then
				lower(inst, "Value", inst.Value, kind, function(x)
					inst.Value = x
				end)
			end
		elseif inst:IsA("ModuleScript") and not failed[inst] and not busy[inst] then
			-- settings modules are shared with the gun's own scripts (same client), so editing the table works
			busy[inst] = true
			task.spawn(function()
				local ok, result = pcall(require, inst)
				busy[inst] = nil
				if not ok then
					failed[inst] = true
				elseif type(result) == "table" then
					pcall(scanTable, result, 0, {})
				end
			end)
		end
		for name, val in pairs(inst:GetAttributes()) do
			if type(val) == "number" then
				local kind = kindOf(name, val)
				if kind then
					lower(inst, name, val, kind, function(x)
						inst:SetAttribute(name, x)
					end)
				end
			end
		end
	end

	local function scanAll()
		local holders = { player.Character or false, player:FindFirstChildOfClass("Backpack") or false }
		for _, holder in ipairs(holders) do
			if holder then
				for _, tool in ipairs(holder:GetChildren()) do
					if tool:IsA("Tool") then
						pcall(scanInstance, tool)
						for _, inst in ipairs(tool:GetDescendants()) do
							pcall(scanInstance, inst)
						end
					end
				end
			end
		end
	end

	local function restore()
		for target, r in pairs(rec) do
			for key, old in pairs(r) do
				pcall(function()
					if typeof(target) == "Instance" then
						if key == "Value" and target:IsA("ValueBase") then
							target.Value = old
						else
							target:SetAttribute(key, old)
						end
					else
						target[key] = old
					end
				end)
			end
			rec[target] = nil
		end
	end

	local function count()
		local n = 0
		for _, r in pairs(rec) do
			for _ in pairs(r) do
				n += 1
			end
		end
		return n
	end

	applyFns.rapid = function(on)
		if on then
			rescanAt = os.clock()
			scanAll()
			task.delay(0.7, function()
				if not state.rapid.on then
					return
				end
				local n = count()
				if n > 0 then
					notify("Rapid fire: " .. n .. " cooldown setting(s) lowered")
				else
					notify("Rapid fire on (no cooldown settings found)")
				end
			end)
		else
			restore()
			notify("Rapid fire off")
		end
	end

	-- some games reset values, and guns you equip later need scanning too
	connect(RunService.Heartbeat, function()
		if state.rapid.on and os.clock() - rescanAt > 1.5 then
			rescanAt = os.clock()
			scanAll()
		end
	end)
end

-- Gun: infinite range, bullet TP, rapid fire
do
	local page = pages["Gun"]

	local mods = makeCard(page, "Gun mods")
	local rangeToggle = makeToggle(mods, "Infinite range", state.range.on, function(v)
		setEnabled("range", v)
	end)
	onChange("range", rangeToggle.setVisual)
	local btpToggle = makeToggle(mods, "Bullet TP", state.btp.on, function(v)
		setEnabled("btp", v)
	end)
	onChange("btp", btpToggle.setVisual)

	local rapid = makeCard(page, "Rapid fire")
	local rapidToggle = makeToggle(rapid, "Enabled", state.rapid.on, function(v)
		setEnabled("rapid", v)
	end)
	onChange("rapid", rapidToggle.setVisual)
	makeBindRow(rapid, "Keybind", "rapid")
	makeSlider(rapid, "Shots per second (500 = fastest)", 1, 500, state.rapid.value, function(v)
		state.rapid.value = v
	end)
end

-- ???: orbit, stay above player
do
	local page = pages["???"]

	local card = makeCard(page, "Orbit")
	local orbitToggle = makeToggle(card, "Orbit", state.orbit.on, function(v)
		setEnabled("orbit", v)
	end)
	onChange("orbit", orbitToggle.setVisual)
	makeBindRow(card, "Orbit keybind", "orbit")
	makeSlider(card, "Orbit speed", 0, 2000, state.orbit.speed, function(v)
		state.orbit.speed = v
	end)
	makeSlider(card, "Orbit radius", 1, 200, state.orbit.radius, function(v)
		state.orbit.radius = v
	end)
	makeSlider(card, "Orbit height", 0, 300, state.orbit.height, function(v)
		state.orbit.height = v
	end)
	makeToggle(card, "Stay above player", state.above.on, function(v)
		setEnabled("above", v)
	end)
	makeSlider(card, "Stay above height", 0, 300, state.above.height, function(v)
		state.above.height = v
	end)
end

-- ???: wallbang
do
	local page = pages["???"]

	local card = makeCard(page, "Wallbang")
	local wbToggle = makeToggle(card, "Wallbang", state.wallbang.on, function(v)
		setEnabled("wallbang", v)
	end)
	onChange("wallbang", wbToggle.setVisual)
end

-- ???: desync
do
	local page = pages["???"]
	local modeNames = { "Random", "Spin", "Up", "Velocity" }

	local card = makeCard(page, "Desync")
	local dsToggle = makeToggle(card, "Desync", state.desync.on, function(v)
		setEnabled("desync", v)
	end)
	onChange("desync", dsToggle.setVisual)
	makeBindRow(card, "Desync keybind", "desync")
	makeButton(card, "Mode: " .. modeNames[state.desync.mode], function(btn)
		state.desync.mode = state.desync.mode % #modeNames + 1
		btn.Text = "Mode: " .. modeNames[state.desync.mode]
	end)
	makeSlider(card, "Strength (studs)", 1, 200, state.desync.dist, function(v)
		state.desync.dist = v
	end)
	makeToggle(card, "Show ghost (where others see you)", state.desync.ghost, function(v)
		state.desync.ghost = v
	end)
end

-- ???: jitter anti aim
do
	local page = pages["???"]

	local card = makeCard(page, "Jitter anti aim")
	local aaToggle = makeToggle(card, "Jitter anti aim", state.aa.on, function(v)
		setEnabled("aa", v)
	end)
	onChange("aa", aaToggle.setVisual)
	makeBindRow(card, "Anti aim keybind", "aa")
	makeSlider(card, "Jitter angle (deg)", 0, 180, state.aa.angle, function(v)
		state.aa.angle = v
	end)
	makeSlider(card, "Base yaw (deg)", 0, 360, state.aa.base, function(v)
		state.aa.base = v
	end)
	makeSlider(card, "Jitter speed (flips per second)", 1, 60, state.aa.speed, function(v)
		state.aa.speed = v
	end)
	makeSlider(card, "Pitch tilt (deg)", -90, 90, state.aa.pitch, function(v)
		state.aa.pitch = v
	end)
	makeToggle(card, "Random angle instead of flipping", state.aa.random, function(v)
		state.aa.random = v
	end)
end

-- ???: triggerbot
do
	local page = pages["???"]
	local partNames = { "Any", "Head", "Torso" }

	local card = makeCard(page, "Triggerbot")
	local trToggle = makeToggle(card, "Triggerbot", state.trigger.on, function(v)
		setEnabled("trigger", v)
	end)
	onChange("trigger", trToggle.setVisual)
	makeBindRow(card, "Triggerbot keybind", "trigger")
	makeButton(card, "Hit part: " .. partNames[state.trigger.part], function(btn)
		state.trigger.part = state.trigger.part % #partNames + 1
		btn.Text = "Hit part: " .. partNames[state.trigger.part]
	end)
	makeSlider(card, "Delay before first shot (ms)", 0, 500, state.trigger.delay, function(v)
		state.trigger.delay = v
	end)
	makeSlider(card, "Time between shots (ms)", 10, 1000, state.trigger.interval, function(v)
		state.trigger.interval = v
	end)
	makeSlider(card, "Max distance (studs)", 20, 2000, state.trigger.range, function(v)
		state.trigger.range = v
	end)
	makeSlider(card, "Trigger radius (px)", 0, 40, state.trigger.radius, function(v)
		state.trigger.radius = v
	end)
	makeToggle(card, "Team check", state.trigger.team, function(v)
		state.trigger.team = v
	end)
	makeToggle(card, "Only shoot my Target", state.trigger.onlyTarget, function(v)
		state.trigger.onlyTarget = v
	end)
	makeToggle(card, "Only while aim key is held", state.trigger.needKey, function(v)
		state.trigger.needKey = v
	end)
end

selectTab("Main")

--------------------------------------------------------------------------
-- Boot screen (CLI style). Plays first, then fades out and opens the menu.
-- Lives in its own function so its locals don't count against the main
-- chunk's local-variable limit.
--------------------------------------------------------------------------
local function bootScreen()
	local TextService = game:GetService("TextService")
	local MONO = Enum.Font.Code
	local TEXT_SIZE = 16
	local LINE_H = 22
	local GREEN = Color3.fromRGB(80, 255, 120)

	-- the menu stays hidden until the boot screen is done
	menuOpen = false
	window.Visible = false
	GuiService.SelectedObject = nil

	-- "carve.cc" in ASCII (4 rows tall). ".cc" uses the UI accent color, like the title bar.
	local glyphs = {
		c = { [[  ___ ]], [[ / __|]], [[| (__ ]], [[ \___|]] },
		a = { [[  __ _ ]], [[ / _` |]], [[| (_| |]], [[ \__,_|]] },
		r = { [[ _ __ ]], [[| '__|]], [[| |   ]], [[|_|   ]] },
		v = { [[__   __]], [[\ \ / /]], [[ \ V / ]], [[  \_/  ]] },
		e = { [[  ___ ]], [[ / _ \]], [[|  __/]], [[ \___|]] },
		["."] = { [[   ]], [[   ]], [[ _ ]], [[(_)]] },
	}
	local function drawWord(word, row)
		local parts = {}
		for ch in word:gmatch(".") do
			parts[#parts + 1] = glyphs[ch][row]
		end
		return table.concat(parts, " ")
	end

	local accentHex = THEME.accent:ToHex()
	local plainRows, richRows = {}, {}
	for row = 1, 4 do
		local left, right = drawWord("carve", row), drawWord(".cc", row)
		plainRows[row] = left .. " " .. right
		richRows[row] = left .. ' <font color="#' .. accentHex .. '">' .. right .. "</font>"
	end

	local logoSize = Vector2.new(540, 66)
	pcall(function()
		logoSize = TextService:GetTextSize(table.concat(plainRows, "\n"), TEXT_SIZE, MONO, Vector2.new(10000, 10000))
	end)

	-- a small, slightly see-through panel in the middle (the rest of the screen stays visible)
	local PAD = 20
	local contentW = math.ceil(logoSize.X) + 4
	local contentH = math.ceil(logoSize.Y) + 14 + LINE_H + (LINE_H + 6) + LINE_H * 3
	local overlay = create("Frame", {
		Name = "Boot",
		AnchorPoint = Vector2.new(0.5, 0.5),
		Position = UDim2.fromScale(0.5, 0.5),
		Size = UDim2.fromOffset(contentW + PAD * 2, contentH + PAD * 2),
		BackgroundColor3 = THEME.bg,
		BackgroundTransparency = 0.3,
		ZIndex = 200,
		Parent = gui,
	})
	round(overlay, 10)
	local overlayStroke = outline(overlay, THEME.accent)
	local holder = create("Frame", {
		Position = UDim2.fromOffset(PAD, PAD),
		Size = UDim2.fromOffset(contentW, contentH),
		BackgroundTransparency = 1,
		ZIndex = 201,
		Parent = overlay,
	})
	listLayout(holder, 0)

	-- shrink the panel on small screens / phones
	local bootScale = create("UIScale", { Parent = overlay })
	local function refreshBootScale()
		local s = gui.AbsoluteSize
		bootScale.Scale = math.clamp(
			math.min(s.X / (contentW + PAD * 2 + 40), s.Y / (contentH + PAD * 2 + 40)),
			0.4,
			1
		)
	end
	refreshBootScale()
	connect(gui:GetPropertyChangedSignal("AbsoluteSize"), refreshBootScale)

	-- every line exists from the start with a fixed height, so nothing jumps while text is typed
	local order = 0
	local labels = {}
	local function addLine(height, props)
		order += 1
		props = props or {}
		props.Font = MONO
		props.TextSize = TEXT_SIZE
		props.Size = UDim2.new(1, 0, 0, height)
		props.LayoutOrder = order
		props.ZIndex = 201
		props.Text = ""
		props.TextColor3 = props.TextColor3 or THEME.text
		props.Parent = holder
		local label = makeLabel(props)
		labels[#labels + 1] = label
		return label
	end
	local function addGap(height)
		order += 1
		create("Frame", {
			BackgroundTransparency = 1,
			Size = UDim2.new(1, 0, 0, height),
			LayoutOrder = order,
			Parent = holder,
		})
	end

	local logoLabel = addLine(math.ceil(logoSize.Y), { RichText = true, TextYAlignment = Enum.TextYAlignment.Top })
	addGap(14)
	local welcomeLabel = addLine(LINE_H)
	addGap(LINE_H + 6) -- blank space under the welcome line
	local launchLabel = addLine(LINE_H)
	local waitLabel = addLine(LINE_H)
	local doneLabel = addLine(LINE_H, { TextColor3 = GREEN })

	local function alive()
		return overlay.Parent ~= nil
	end

	local function typeText(label, text, perChar)
		for i = 1, #text do
			if not alive() then
				return
			end
			label.Text = text:sub(1, i) .. "_"
			task.wait(perChar)
		end
		label.Text = text
	end

	local function dots(label, base, duration)
		local t0, n = os.clock(), 0
		while alive() and os.clock() - t0 < duration do
			n = n % 3 + 1
			label.Text = base .. string.rep(".", n)
			task.wait(0.2)
		end
		label.Text = base .. "..."
	end

	local finished = false
	local function finish()
		if finished then
			return
		end
		finished = true
		booting = false
		if not gui.Parent then
			return
		end
		setMenuOpen(true)
		local info = TweenInfo.new(0.45, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
		TweenService:Create(overlay, info, { BackgroundTransparency = 1 }):Play()
		TweenService:Create(overlayStroke, info, { Transparency = 1 }):Play()
		for _, label in ipairs(labels) do
			TweenService:Create(label, info, { TextTransparency = 1 }):Play()
		end
		task.delay(0.5, function()
			overlay:Destroy()
		end)
	end

	task.spawn(function()
		local ok, err = pcall(function()
			task.wait(0.3)
			for row = 1, 4 do
				if not alive() then
					return
				end
				logoLabel.Text = table.concat(richRows, "\n", 1, row)
				task.wait(0.09)
			end
			task.wait(0.25)
			typeText(welcomeLabel, "welcome back " .. player.Name, 0.03)
			task.wait(0.5)
			typeText(launchLabel, "launching carve", 0.035)
			dots(launchLabel, "launching carve", 0.9)
			typeText(waitLabel, "waiting for response", 0.035)
			dots(waitLabel, "waiting for response", 1.1)
			typeText(doneLabel, "successful", 0.04)
			task.wait(0.8)
		end)
		if not ok then
			warn("carve.cc boot screen error: " .. tostring(err))
		end
		finish() -- always runs, so the menu can never get stuck hidden
	end)
end

bootScreen()
