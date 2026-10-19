local success, errorMessage = pcall(function()
    -- Wait 10 seconds on game load so auto-execute works reliably
task.wait(10)

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local HttpService = game:GetService("HttpService")
local vim = game:GetService("VirtualInputManager")
local CoreGui = game:GetService("CoreGui")

local localPlayer = Players.LocalPlayer
local CONFIG_FILE = "KeySpammer_Config.json"

--------------------------------------------------------------------
-- Theme
--------------------------------------------------------------------
local THEME = {
	Background = Color3.fromRGB(18, 20, 26),
	Panel = Color3.fromRGB(26, 29, 37),
	Key = Color3.fromRGB(38, 42, 53),
	Stroke = Color3.fromRGB(48, 53, 66),
	Text = Color3.fromRGB(236, 238, 242),
	Muted = Color3.fromRGB(137, 145, 161),
	Accent = Color3.fromRGB(88, 101, 242),
	Green = Color3.fromRGB(52, 168, 110),
	Red = Color3.fromRGB(214, 68, 74),
	Amber = Color3.fromRGB(235, 168, 52),
}

local TWEEN_FAST = TweenInfo.new(0.15, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)

--------------------------------------------------------------------
-- UI helpers
--------------------------------------------------------------------
local function tween(obj, props)
	TweenService:Create(obj, TWEEN_FAST, props):Play()
end

local function create(class, props, children)
	local inst = Instance.new(class)
	for k, v in pairs(props or {}) do
		inst[k] = v
	end
	for _, child in ipairs(children or {}) do
		child.Parent = inst
	end
	return inst
end

local function corner(radius)
	return create("UICorner", { CornerRadius = UDim.new(0, radius) })
end

local function stroke(color, thickness, transparency)
	return create("UIStroke", {
		Color = color,
		Thickness = thickness or 1,
		Transparency = transparency or 0,
		ApplyStrokeMode = Enum.ApplyStrokeMode.Border,
	})
end

local function padding(top, right, bottom, left)
	return create("UIPadding", {
		PaddingTop = UDim.new(0, top),
		PaddingRight = UDim.new(0, right),
		PaddingBottom = UDim.new(0, bottom),
		PaddingLeft = UDim.new(0, left),
	})
end

-- Buttons keep a "base" colour so hover/press effects work with any state colour
local baseColors = {}

local function setBase(btn, color)
	baseColors[btn] = color
	tween(btn, { BackgroundColor3 = color })
end

local function makeButton(props)
	local btn = create("TextButton", {
		Size = props.Size,
		Position = props.Position or UDim2.new(),
		BackgroundColor3 = props.Color,
		AutoButtonColor = false,
		Text = props.Text or "",
		TextColor3 = props.TextColor or THEME.Text,
		Font = props.Font or Enum.Font.GothamMedium,
		TextSize = props.TextSize or 14,
		LayoutOrder = props.LayoutOrder or 0,
		BorderSizePixel = 0,
	}, { corner(props.Radius or 8) })

	baseColors[btn] = props.Color

	btn.MouseEnter:Connect(function()
		tween(btn, { BackgroundColor3 = baseColors[btn]:Lerp(Color3.new(1, 1, 1), 0.12) })
	end)
	btn.MouseLeave:Connect(function()
		tween(btn, { BackgroundColor3 = baseColors[btn] })
	end)
	btn.MouseButton1Down:Connect(function()
		tween(btn, { BackgroundColor3 = baseColors[btn]:Lerp(Color3.new(0, 0, 0), 0.15) })
	end)
	btn.MouseButton1Up:Connect(function()
		tween(btn, { BackgroundColor3 = baseColors[btn]:Lerp(Color3.new(1, 1, 1), 0.12) })
	end)

	return btn
end

local function makeDraggable(handle, target)
	local dragging = false
	local dragStart, startPos

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1
			or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPos = target.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragging = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement
			or input.UserInputType == Enum.UserInputType.Touch) then
			local delta = input.Position - dragStart
			target.Position = UDim2.new(
				startPos.X.Scale, startPos.X.Offset + delta.X,
				startPos.Y.Scale, startPos.Y.Offset + delta.Y
			)
		end
	end)
end

--------------------------------------------------------------------
-- State
--------------------------------------------------------------------
local keyRows = {
	{ "q", "w", "e", "r", "t", "y", "u", "i", "o", "p" },
	{ "a", "s", "d", "f", "g", "h", "j", "k", "l" },
	{ "z", "x", "c", "v", "b", "n", "m" },
}

local selected_keys = {}
local keyButtons = {}
local toggle = false
local loopRunning = false
local flashing = false

local function countKeys()
	local n = 0
	for _ in pairs(selected_keys) do
		n += 1
	end
	return n
end

--------------------------------------------------------------------
-- Clean up old GUI if re-executing
--------------------------------------------------------------------
if CoreGui:FindFirstChild("MultiKeySpammerGui") then
	CoreGui.MultiKeySpammerGui:Destroy()
end

local screenGui = create("ScreenGui", {
	Name = "MultiKeySpammerGui",
	ResetOnSpawn = false,
	ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
})
pcall(function()
	screenGui.Parent = CoreGui
end)
if not screenGui.Parent then
	screenGui.Parent = localPlayer:WaitForChild("PlayerGui")
end

--------------------------------------------------------------------
-- Main panel
--------------------------------------------------------------------
local mainFrame = create("Frame", {
	Name = "MainFrame",
	Size = UDim2.fromOffset(230, 164),
	Position = UDim2.new(0, 20, 0, 20),
	BackgroundColor3 = THEME.Background,
	BorderSizePixel = 0,
	Parent = screenGui,
}, { corner(12), stroke(THEME.Stroke, 1) })

local mainHeader = create("Frame", {
	Name = "Header",
	Size = UDim2.new(1, 0, 0, 38),
	BackgroundTransparency = 1,
	Parent = mainFrame,
}, { padding(0, 14, 0, 14) })

create("Frame", {
	Name = "AccentDot",
	Size = UDim2.fromOffset(8, 8),
	Position = UDim2.new(0, 0, 0.5, -4),
	BackgroundColor3 = THEME.Accent,
	BorderSizePixel = 0,
	Parent = mainHeader,
}, { corner(4) })

create("TextLabel", {
	Name = "Title",
	Size = UDim2.new(1, -90, 1, 0),
	Position = UDim2.fromOffset(16, 0),
	BackgroundTransparency = 1,
	Text = "Key Spammer",
	TextColor3 = THEME.Text,
	Font = Enum.Font.GothamBold,
	TextSize = 15,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = mainHeader,
})

create("TextLabel", {
	Name = "Hint",
	Size = UDim2.new(0, 70, 1, 0),
	Position = UDim2.new(1, -70, 0, 0),
	BackgroundTransparency = 1,
	Text = "G to hide",
	TextColor3 = THEME.Muted,
	Font = Enum.Font.Gotham,
	TextSize = 11,
	TextXAlignment = Enum.TextXAlignment.Right,
	Parent = mainHeader,
})

create("Frame", {
	Name = "Divider",
	Size = UDim2.new(1, -24, 0, 1),
	Position = UDim2.fromOffset(12, 38),
	BackgroundColor3 = THEME.Stroke,
	BackgroundTransparency = 0.4,
	BorderSizePixel = 0,
	Parent = mainFrame,
})

local mainBody = create("Frame", {
	Name = "Body",
	Size = UDim2.new(1, 0, 1, -39),
	Position = UDim2.fromOffset(0, 39),
	BackgroundTransparency = 1,
	Parent = mainFrame,
}, {
	padding(12, 14, 14, 14),
	create("UIListLayout", {
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}),
})

-- Status row
local statusRow = create("Frame", {
	Name = "StatusRow",
	Size = UDim2.new(1, 0, 0, 18),
	BackgroundTransparency = 1,
	LayoutOrder = 1,
	Parent = mainBody,
})

local statusDot = create("Frame", {
	Size = UDim2.fromOffset(8, 8),
	Position = UDim2.new(0, 0, 0.5, -4),
	BackgroundColor3 = THEME.Muted,
	BorderSizePixel = 0,
	Parent = statusRow,
}, { corner(4) })

local statusLabel = create("TextLabel", {
	Size = UDim2.new(1, -16, 1, 0),
	Position = UDim2.fromOffset(16, 0),
	BackgroundTransparency = 1,
	Text = "Idle",
	TextColor3 = THEME.Muted,
	Font = Enum.Font.GothamMedium,
	TextSize = 13,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = statusRow,
})

local select_key_button = makeButton({
	Size = UDim2.new(1, 0, 0, 34),
	Color = THEME.Panel,
	Text = "Select Keys",
	LayoutOrder = 2,
})
select_key_button.Parent = mainBody
stroke(THEME.Stroke, 1).Parent = select_key_button

local toggle_button = makeButton({
	Size = UDim2.new(1, 0, 0, 36),
	Color = THEME.Green,
	Text = "Enable",
	Font = Enum.Font.GothamBold,
	LayoutOrder = 3,
})
toggle_button.Parent = mainBody

makeDraggable(mainHeader, mainFrame)

--------------------------------------------------------------------
-- UI refresh helpers
--------------------------------------------------------------------
local function refreshStatus()
	local n = countKeys()
	select_key_button.Text = n > 0 and ("Select Keys  ·  " .. n .. " selected") or "Select Keys"

	if flashing then
		return
	end

	if toggle then
		toggle_button.Text = "Disable"
		setBase(toggle_button, THEME.Red)
		tween(statusDot, { BackgroundColor3 = THEME.Green })
		statusLabel.Text = "Running  ·  " .. n .. (n == 1 and " key" or " keys")
		tween(statusLabel, { TextColor3 = THEME.Green })
	else
		toggle_button.Text = "Enable"
		setBase(toggle_button, THEME.Green)
		tween(statusDot, { BackgroundColor3 = THEME.Muted })
		statusLabel.Text = "Idle"
		tween(statusLabel, { TextColor3 = THEME.Muted })
	end
end

local function styleKeyButton(btn, isSelected)
	setBase(btn, isSelected and THEME.Accent or THEME.Key)
	tween(btn, { TextColor3 = isSelected and Color3.new(1, 1, 1) or THEME.Muted })
end

--------------------------------------------------------------------
-- Spam loop
--------------------------------------------------------------------
local function runSpamLoop()
	if loopRunning then
		return
	end
	loopRunning = true

	task.spawn(function()
		while toggle do
			for keyCode in pairs(selected_keys) do
				if not toggle then
					break
				end
				pcall(function()
					vim:SendKeyEvent(true, keyCode, false, game)
					task.wait()
					vim:SendKeyEvent(false, keyCode, false, game)
				end)
				task.wait(0.05)
			end
			task.wait()
		end
		loopRunning = false
	end)
end

--------------------------------------------------------------------
-- Save / load
--------------------------------------------------------------------
local function saveSettings()
	pcall(function()
		local keyNames = {}
		for keyCode in pairs(selected_keys) do
			table.insert(keyNames, keyCode.Name)
		end
		writefile(CONFIG_FILE, HttpService:JSONEncode(keyNames))
	end)
end

--------------------------------------------------------------------
-- Key picker window
--------------------------------------------------------------------
local KEY_SIZE = 34
local KEY_GAP = 4

local pickerFrame = create("Frame", {
	Name = "SelectionFrame",
	Size = UDim2.fromOffset(408, 232),
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	BackgroundColor3 = THEME.Background,
	BorderSizePixel = 0,
	Visible = false,
	Parent = screenGui,
}, { corner(12), stroke(THEME.Stroke, 1) })

local pickerHeader = create("Frame", {
	Size = UDim2.new(1, 0, 0, 38),
	BackgroundTransparency = 1,
	Parent = pickerFrame,
}, { padding(0, 14, 0, 14) })

create("TextLabel", {
	Size = UDim2.new(1, -90, 1, 0),
	BackgroundTransparency = 1,
	Text = "Choose keys to spam",
	TextColor3 = THEME.Text,
	Font = Enum.Font.GothamBold,
	TextSize = 15,
	TextXAlignment = Enum.TextXAlignment.Left,
	Parent = pickerHeader,
})

local pickerCount = create("TextLabel", {
	Size = UDim2.new(0, 80, 1, 0),
	Position = UDim2.new(1, -80, 0, 0),
	BackgroundTransparency = 1,
	Text = "0 selected",
	TextColor3 = THEME.Muted,
	Font = Enum.Font.Gotham,
	TextSize = 12,
	TextXAlignment = Enum.TextXAlignment.Right,
	Parent = pickerHeader,
})

create("Frame", {
	Size = UDim2.new(1, -24, 0, 1),
	Position = UDim2.fromOffset(12, 38),
	BackgroundColor3 = THEME.Stroke,
	BackgroundTransparency = 0.4,
	BorderSizePixel = 0,
	Parent = pickerFrame,
})

local keysContainer = create("Frame", {
	Size = UDim2.new(1, 0, 0, KEY_SIZE * 3 + KEY_GAP * 2),
	Position = UDim2.fromOffset(0, 54),
	BackgroundTransparency = 1,
	Parent = pickerFrame,
}, {
	create("UIListLayout", {
		Padding = UDim.new(0, KEY_GAP),
		SortOrder = Enum.SortOrder.LayoutOrder,
		HorizontalAlignment = Enum.HorizontalAlignment.Center,
	}),
})

local function refreshPickerCount()
	local n = countKeys()
	pickerCount.Text = n .. " selected"
end

for rowIndex, row in ipairs(keyRows) do
	local rowFrame = create("Frame", {
		Size = UDim2.new(1, 0, 0, KEY_SIZE),
		BackgroundTransparency = 1,
		LayoutOrder = rowIndex,
		Parent = keysContainer,
	}, {
		create("UIListLayout", {
			FillDirection = Enum.FillDirection.Horizontal,
			Padding = UDim.new(0, KEY_GAP),
			HorizontalAlignment = Enum.HorizontalAlignment.Center,
			SortOrder = Enum.SortOrder.LayoutOrder,
		}),
	})

	for i, key in ipairs(row) do
		local keyCode = Enum.KeyCode[string.upper(key)]
		local button = makeButton({
			Size = UDim2.fromOffset(KEY_SIZE, KEY_SIZE),
			Color = THEME.Key,
			Text = string.upper(key),
			TextColor = THEME.Muted,
			Font = Enum.Font.GothamBold,
			TextSize = 14,
			Radius = 7,
			LayoutOrder = i,
		})
		button.Parent = rowFrame
		keyButtons[keyCode] = button

		if selected_keys[keyCode] then
			styleKeyButton(button, true)
		end

		button.MouseButton1Click:Connect(function()
			if selected_keys[keyCode] then
				selected_keys[keyCode] = nil
				styleKeyButton(button, false)
			else
				selected_keys[keyCode] = true
				styleKeyButton(button, true)
			end
			refreshPickerCount()
			refreshStatus()
			saveSettings()
		end)
	end
end

-- Footer buttons
local footer = create("Frame", {
	Size = UDim2.new(1, -28, 0, 34),
	Position = UDim2.new(0, 14, 1, -48),
	BackgroundTransparency = 1,
	Parent = pickerFrame,
}, {
	create("UIListLayout", {
		FillDirection = Enum.FillDirection.Horizontal,
		Padding = UDim.new(0, 8),
		SortOrder = Enum.SortOrder.LayoutOrder,
	}),
})

local selectAllBtn = makeButton({
	Size = UDim2.new(1 / 3, -6, 1, 0),
	Color = THEME.Panel,
	Text = "Select All",
	TextSize = 13,
	LayoutOrder = 1,
})
selectAllBtn.Parent = footer
stroke(THEME.Stroke, 1).Parent = selectAllBtn

local clearBtn = makeButton({
	Size = UDim2.new(1 / 3, -6, 1, 0),
	Color = THEME.Panel,
	Text = "Clear",
	TextSize = 13,
	LayoutOrder = 2,
})
clearBtn.Parent = footer
stroke(THEME.Stroke, 1).Parent = clearBtn

local doneBtn = makeButton({
	Size = UDim2.new(1 / 3, -6, 1, 0),
	Color = THEME.Accent,
	Text = "Done",
	Font = Enum.Font.GothamBold,
	TextSize = 13,
	LayoutOrder = 3,
})
doneBtn.Parent = footer

selectAllBtn.MouseButton1Click:Connect(function()
	for keyCode, btn in pairs(keyButtons) do
		selected_keys[keyCode] = true
		styleKeyButton(btn, true)
	end
	refreshPickerCount()
	refreshStatus()
	saveSettings()
end)

clearBtn.MouseButton1Click:Connect(function()
	for keyCode, btn in pairs(keyButtons) do
		selected_keys[keyCode] = nil
		styleKeyButton(btn, false)
	end
	refreshPickerCount()
	refreshStatus()
	saveSettings()
end)

doneBtn.MouseButton1Click:Connect(function()
	pickerFrame.Visible = false
	refreshStatus()
	saveSettings()
end)

makeDraggable(pickerHeader, pickerFrame)

--------------------------------------------------------------------
-- Load settings (after UI exists so it can update it)
--------------------------------------------------------------------
local function loadSettings()
	local ok, raw = pcall(function()
		return readfile(CONFIG_FILE)
	end)
	if not ok then
		return
	end

	local success, decoded = pcall(function()
		return HttpService:JSONDecode(raw)
	end)
	if not (success and type(decoded) == "table") then
		return
	end

	for _, keyName in ipairs(decoded) do
		local okEnum, enumVal = pcall(function()
			return Enum.KeyCode[keyName]
		end)
		if okEnum and enumVal then
			selected_keys[enumVal] = true
			if keyButtons[enumVal] then
				styleKeyButton(keyButtons[enumVal], true)
			end
		end
	end

	refreshPickerCount()

	-- Auto enable on startup if keys exist
	if countKeys() > 0 then
		toggle = true
		runSpamLoop()
	end
end

loadSettings()
refreshStatus()

--------------------------------------------------------------------
-- Interactions
--------------------------------------------------------------------
-- Hide / Show GUI using 'G' key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then
		return
	end
	if input.KeyCode == Enum.KeyCode.G then
		screenGui.Enabled = not screenGui.Enabled
	end
end)

select_key_button.MouseButton1Click:Connect(function()
	pickerFrame.Visible = not pickerFrame.Visible
end)

toggle_button.MouseButton1Click:Connect(function()
	if countKeys() == 0 then
		if flashing then
			return
		end
		flashing = true
		toggle_button.Text = "Pick keys first!"
		setBase(toggle_button, THEME.Amber)
		task.delay(1.2, function()
			flashing = false
			refreshStatus()
		end)
		return
	end

	toggle = not toggle
	if toggle then
		runSpamLoop()
	end
	refreshStatus()
end)
print("Background spammer initialized!")
    
    -- Example:
    -- local vu = game:GetService("VirtualUser")
    -- ... your logic ...
end)

if not success then
    warn("[Spammer Error]: " .. tostring(errorMessage))
end
