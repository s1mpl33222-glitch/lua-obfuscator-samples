--[[
============================================================
                      C00l Library 
============================================================

C00lgui-inspired UI library made by scink

Features:
    • Tabs
    • Toggles
    • Sliders
    • Dropdowns 
    • Texboxes
And more

============================================================
                    COLOR CONFIGURATION
============================================================

_G.C00lLibColors = {
    Background = Color3.fromRGB(0, 0, 0),
    Border = Color3.fromRGB(255, 0, 0),
    Text = Color3.fromRGB(255, 255, 255),

    Button = Color3.fromRGB(0, 0, 0),
    ButtonHover = Color3.fromRGB(20, 0, 0),

    ToggleOn = Color3.fromRGB(255, 0, 0),
    ToggleOff = Color3.fromRGB(30, 30, 30),

    ExplorerSelected = Color3.fromRGB(40, 0, 0)
}

============================================================
]]

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer

if not LocalPlayer then
	error("C00lLib must run on the client.")
end


local DefaultColors = {
	Background = Color3.fromRGB(0, 0, 0),
	Border = Color3.fromRGB(255, 0, 0),
	Text = Color3.fromRGB(255, 255, 255),

	Button = Color3.fromRGB(0, 0, 0),
	ButtonHover = Color3.fromRGB(20, 0, 0),

	ToggleOn = Color3.fromRGB(255, 0, 0),
	ToggleOff = Color3.fromRGB(40, 40, 40),

	ExplorerSelected = Color3.fromRGB(40, 0, 0)
}

local UserColors = rawget(_G, "C00lLibColors")
local Colors = {}

for name, default in pairs(DefaultColors) do
	if type(UserColors) == "table" and typeof(UserColors[name]) == "Color3" then
		Colors[name] = UserColors[name]
	else
		Colors[name] = default
	end
end

------------------------------------------------------------
-- CONSTANTS
------------------------------------------------------------

local WINDOW_WIDTH = 550
local WINDOW_HEIGHT = 420

local BORDER_SIZE = 3

local TITLE_HEIGHT = 35
local INDICATOR_HEIGHT = 22
local NAV_HEIGHT = 35

local PAGE_TOP = TITLE_HEIGHT + INDICATOR_HEIGHT + NAV_HEIGHT + 6
local PAGE_BOTTOM = PAGE_TOP + 25

local CONTROL_HEIGHT = 32

------------------------------------------------------------
-- UTILITY
------------------------------------------------------------

local function Create(className, properties)
	local object = Instance.new(className)
	for property, value in pairs(properties or {}) do
		object[property] = value
	end
	return object
end

local function ApplyBorder(object, thickness)
	object.BorderSizePixel = thickness or BORDER_SIZE
	object.BorderColor3 = Colors.Border
end

local function GetGuiParent()
	if type(gethui) == "function" then
		local success, result = pcall(gethui)
		if success and result then
			return result
		end
	end
	return LocalPlayer:WaitForChild("PlayerGui")
end

------------------------------------------------------------
-- DRAGGING
------------------------------------------------------------

local function MakeDraggable(handle, target)
	local dragging = false
	local dragStart, startPosition

	handle.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = true
			dragStart = input.Position
			startPosition = target.Position
		end
	end)

	handle.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
			dragging = false
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if not dragging then return end
		if input.UserInputType ~= Enum.UserInputType.MouseMovement and input.UserInputType ~= Enum.UserInputType.Touch then return end

		local delta = input.Position - dragStart
		target.Position = UDim2.new(
			startPosition.X.Scale,
			startPosition.X.Offset + delta.X,
			startPosition.Y.Scale,
			startPosition.Y.Offset + delta.Y
		)
	end)
end

------------------------------------------------------------
-- LIBRARY
------------------------------------------------------------

local C00lLib = {}
C00lLib.Version = "5.0.0"
C00lLib.Colors = Colors

------------------------------------------------------------
-- CREATE WINDOW
------------------------------------------------------------

function C00lLib:CreateWindow(options)
	options = options or {}

	local Window = {}
	Window.Width = options.Width or WINDOW_WIDTH
	Window.Height = options.Height or WINDOW_HEIGHT
	Window.Title = options.Title or "c00lgui Reborn Rc7 by v3rx"
	Window.Pages = {}
	Window.Controls = {}
	Window.CurrentPage = 1

	-- Theme options
	Window.ThemeStyle = options.ThemeStyle or "Classic" -- "Classic" or "Molded"
	Window.UseAnimatedToggles = options.UseAnimatedToggles or false

	Window.ThemeObjects = {
		Borders = {},
		Backgrounds = {},
		Texts = {},
		Corners = {}
	}

	--------------------------------------------------------
	-- THEME MANAGERS
	--------------------------------------------------------

	local function RegisterBorder(obj)
		table.insert(Window.ThemeObjects.Borders, obj)
		obj.BorderColor3 = Colors.Border
		obj.BorderSizePixel = (Window.ThemeStyle == "Classic") and BORDER_SIZE or 0
	end

	local function RegisterBackground(obj)
		table.insert(Window.ThemeObjects.Backgrounds, obj)
		obj.BackgroundColor3 = Colors.Background
	end

	local function RegisterText(obj)
		table.insert(Window.ThemeObjects.Texts, obj)
		obj.TextColor3 = Colors.Text
	end

	local function ApplyCorner(obj, radius)
		radius = radius or 6
		local corner = obj:FindFirstChildOfClass("UICorner")
		if Window.ThemeStyle == "Molded" then
			if not corner then
				corner = Create("UICorner", {
					CornerRadius = UDim.new(0, radius),
					Parent = obj
				})
			end
			table.insert(Window.ThemeObjects.Corners, corner)
		else
			if corner then
				corner:Destroy()
			end
		end
	end

	function Window:SetThemeStyle(style)
		Window.ThemeStyle = style
		for _, borderObj in ipairs(Window.ThemeObjects.Borders) do
			if borderObj and borderObj.Parent then
				borderObj.BorderSizePixel = (style == "Classic") and BORDER_SIZE or 0
			end
		end

		for _, obj in ipairs(Window.Root:GetDescendants()) do
			if obj:IsA("GuiObject") and not obj:IsA("UICorner") then
				if style == "Molded" then
					ApplyCorner(obj, 6)
				else
					local corner = obj:FindFirstChildOfClass("UICorner")
					if corner then corner:Destroy() end
				end
			end
		end
	end

	function Window:UpdateColors(bg, border, text)
		if bg then
			Colors.Background = bg
			for _, obj in ipairs(Window.ThemeObjects.Backgrounds) do
				if obj and obj.Parent then obj.BackgroundColor3 = bg end
			end
		end
		if border then
			Colors.Border = border
			for _, obj in ipairs(Window.ThemeObjects.Borders) do
				if obj and obj.Parent then obj.BorderColor3 = border end
			end
		end
		if text then
			Colors.Text = text
			for _, obj in ipairs(Window.ThemeObjects.Texts) do
				if obj and obj.Parent then obj.TextColor3 = text end
			end
		end
	end

	--------------------------------------------------------
	-- SCREEN GUI
	--------------------------------------------------------

	local ScreenGui = Create("ScreenGui", {
		Name = "C00lLib",
		Parent = GetGuiParent(),
		ResetOnSpawn = false,
		ZIndexBehavior = Enum.ZIndexBehavior.Sibling,
		DisplayOrder = options.DisplayOrder or 100
	})

	Window.Gui = ScreenGui

	--------------------------------------------------------
	-- MAIN FRAME
	--------------------------------------------------------

	local Root = Create("Frame", {
		Name = "Frame",
		Parent = ScreenGui,
		BackgroundColor3 = Colors.Background,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 10, 0.25, 0),
		Size = UDim2.fromOffset(Window.Width, Window.Height)
	})

	RegisterBorder(Root)
	RegisterBackground(Root)
	Window.Root = Root

	--------------------------------------------------------
	-- TITLE
	--------------------------------------------------------

	local Title = Create("TextLabel", {
		Name = "Title",
		Parent = Root,
		BackgroundColor3 = Colors.Background,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, 0),
		Size = UDim2.new(1, 0, 0, TITLE_HEIGHT),
		Font = Enum.Font.SourceSans,
		TextSize = 22,
		Text = Window.Title,
		TextColor3 = Colors.Text,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		ZIndex = 5
	})

	RegisterBorder(Title)
	RegisterBackground(Title)
	RegisterText(Title)
	Window.TitleLabel = Title
	MakeDraggable(Title, Root)

	--------------------------------------------------------
	-- PAGE INDICATOR (ARRIBA DE LAS FLECHAS)
	--------------------------------------------------------

	local PageIndicator = Create("TextLabel", {
		Name = "PageIndicator",
		Parent = Root,
		BackgroundColor3 = Colors.Background,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, TITLE_HEIGHT + 2),
		Size = UDim2.new(1, 0, 0, INDICATOR_HEIGHT),
		Font = Enum.Font.SourceSansBold,
		TextSize = 15,
		Text = "Page 1 / 1",
		TextColor3 = Colors.Text,
		TextXAlignment = Enum.TextXAlignment.Center,
		TextYAlignment = Enum.TextYAlignment.Center,
		ZIndex = 8
	})

	RegisterBorder(PageIndicator)
	RegisterBackground(PageIndicator)
	RegisterText(PageIndicator)
	Window.PageIndicator = PageIndicator

	--------------------------------------------------------
	-- LEFT NAVIGATION (<)
	--------------------------------------------------------

	local Previous = Create("TextButton", {
		Name = "Previous",
		Parent = Root,
		BackgroundColor3 = Colors.Background,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, TITLE_HEIGHT + INDICATOR_HEIGHT + 4),
		Size = UDim2.new(0.5, -2, 0, NAV_HEIGHT),
		Font = Enum.Font.SourceSansBold,
		TextSize = 36,
		Text = "<",
		TextColor3 = Colors.Text,
		AutoButtonColor = true,
		ZIndex = 5
	})

	RegisterBorder(Previous)
	RegisterBackground(Previous)
	RegisterText(Previous)

	--------------------------------------------------------
	-- RIGHT NAVIGATION (>)
	--------------------------------------------------------

	local Next = Create("TextButton", {
		Name = "Next",
		Parent = Root,
		BackgroundColor3 = Colors.Background,
		BorderSizePixel = 0,
		Position = UDim2.new(0.5, 2, 0, TITLE_HEIGHT + INDICATOR_HEIGHT + 4),
		Size = UDim2.new(0.5, -2, 0, NAV_HEIGHT),
		Font = Enum.Font.SourceSansBold,
		TextSize = 36,
		Text = ">",
		TextColor3 = Colors.Text,
		AutoButtonColor = true,
		ZIndex = 5
	})

	RegisterBorder(Next)
	RegisterBackground(Next)
	RegisterText(Next)

	--------------------------------------------------------
	-- PAGE HOLDER
	--------------------------------------------------------

	local PageHolder = Create("Frame", {
		Name = "Pages",
		Parent = Root,
		BackgroundColor3 = Colors.Background,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 0, 0, PAGE_TOP),
		Size = UDim2.new(1, 0, 1, -PAGE_TOP - 22),
		ClipsDescendants = false,
		ZIndex = 3
	})

	RegisterBorder(PageHolder)
	RegisterBackground(PageHolder)
	Window.PageHolder = PageHolder

	--------------------------------------------------------
	-- CLOSE / OPEN BAR
	--------------------------------------------------------

	local CloseOpen = Create("TextButton", {
		Name = "Close/Open",
		Parent = ScreenGui,
		BackgroundColor3 = Colors.Background,
		BorderSizePixel = 0,
		Position = UDim2.new(0, 10, 0.25, Window.Height + 5),
		Size = UDim2.fromOffset(Window.Width, 20),
		Font = Enum.Font.SourceSans,
		TextSize = 16,
		Text = "Close",
		TextColor3 = Colors.Text,
		AutoButtonColor = true,
		ZIndex = 20
	})

	RegisterBorder(CloseOpen)
	RegisterBackground(CloseOpen)
	RegisterText(CloseOpen)
	Window.CloseOpen = CloseOpen

	CloseOpen.MouseButton1Click:Connect(function()
		Root.Visible = not Root.Visible
		CloseOpen.Text = Root.Visible and "Close" or "Open"
	end)

	--------------------------------------------------------
	-- PAGE SWITCHING
	--------------------------------------------------------

	local function ShowPage(index)
		if #Window.Pages == 0 then return end
		if index < 1 then index = #Window.Pages end
		if index > #Window.Pages then index = 1 end

		Window.CurrentPage = index

		for i, page in ipairs(Window.Pages) do
			page.Frame.Visible = (i == index)
		end

		local page = Window.Pages[index]
		PageIndicator.Text = string.format("%s    [%d / %d]", page.Name, index, #Window.Pages)
	end

	Window.ShowPage = ShowPage

	Previous.MouseButton1Click:Connect(function() ShowPage(Window.CurrentPage - 1) end)
	Next.MouseButton1Click:Connect(function() ShowPage(Window.CurrentPage + 1) end)

	--------------------------------------------------------
	-- CREATE PAGE
	--------------------------------------------------------

	function Window:CreatePage(name)
		local Page = {}
		Page.Name = name or ("Page " .. tostring(#Window.Pages + 1))
		Page.Controls = {}
		Page.Sections = {}

		local Frame = Create("Frame", {
			Name = Page.Name,
			Parent = PageHolder,
			BackgroundColor3 = Colors.Background,
			BorderSizePixel = 0,
			Position = UDim2.new(0, 0, 0, 0),
			Size = UDim2.new(1, 0, 1, 0),
			Visible = false,
			ClipsDescendants = false,
			ZIndex = 3
		})

		RegisterBorder(Frame)
		RegisterBackground(Frame)
		Page.Frame = Frame

		function Page:Register(control, controlName)
			if controlName ~= nil then
				Page.Controls[controlName] = control
				Window.Controls[controlName] = control
			end
			return control
		end

		--------------------------------------------------------
		-- CREATE SECTION
		--------------------------------------------------------

		function Page:CreateSection(name, side)
			side = string.lower(tostring(side or "left"))
			local isRight = (side == "right")

			local Section = {}
			Section.Name = name or (isRight and "Right" or "Left")
			Section.Controls = {}
			Section.Row = 0

			local SectionFrame = Create("ScrollingFrame", {
				Name = Section.Name,
				Parent = Frame,
				BackgroundColor3 = Colors.Background,
				BorderSizePixel = 0,
				Position = isRight and UDim2.new(0.5, 2, 0, 0) or UDim2.new(0, 0, 0, 0),
				Size = UDim2.new(0.5, -2, 1, 0),
				CanvasSize = UDim2.new(0, 0, 0, 0),
				AutomaticCanvasSize = Enum.AutomaticSize.Y,
				ScrollBarThickness = 4,
				ClipsDescendants = true,
				ZIndex = 4
			})

			RegisterBorder(SectionFrame)
			RegisterBackground(SectionFrame)
			Section.Frame = SectionFrame

			function Section:AddControl(control, controlName)
				if controlName ~= nil then
					Section.Controls[controlName] = control
					Page.Controls[controlName] = control
					Window.Controls[controlName] = control
				end
				return control
			end

			function Section:GetNextY()
				return 5 + (Section.Row * (CONTROL_HEIGHT + 4))
			end

			local function MakeControl(className, text, width, x, y, height)
				local control = Create(className, {
					Name = className,
					Parent = SectionFrame,
					BackgroundColor3 = Colors.Button,
					BorderSizePixel = 0,
					Position = UDim2.new(x or 0, 2, 0, y),
					Size = UDim2.new(width or 1, -8, 0, height or CONTROL_HEIGHT),
					Font = Enum.Font.SourceSans,
					TextSize = 14,
					Text = text or "",
					TextColor3 = Colors.Text,
					ZIndex = 5
				})

				if control:IsA("TextButton") or control:IsA("ImageButton") then
					control.AutoButtonColor = true
				end

				RegisterBorder(control)
				RegisterText(control)
				if Window.ThemeStyle == "Molded" then ApplyCorner(control, 6) end
				return control
			end

			--------------------------------------------------------
			-- BUTTON
			--------------------------------------------------------

			function Section:Button(text, callback, controlName, options)
				options = options or {}
				local y = options.Y or Section:GetNextY()

				local button = MakeControl(
					"TextButton",
					tostring(text or ""),
					options.Width or 1,
					options.X or 0,
					y,
					options.Height or CONTROL_HEIGHT
				)

				local Control = {Instance = button, Type = "Button", Name = controlName}

				function Control:Get() return button end
				function Control:Click(...) if callback then return callback(...) end end

				button.MouseButton1Click:Connect(function()
					if callback then task.spawn(callback) end
				end)

				Section.Row += 1
				return Section:AddControl(Control, controlName)
			end

			--------------------------------------------------------
			-- LABEL
			--------------------------------------------------------

			function Section:Label(text, controlName, options)
				options = options or {}
				local y = options.Y or Section:GetNextY()

				local label = MakeControl(
					"TextLabel",
					tostring(text or ""),
					options.Width or 1,
					options.X or 0,
					y,
					options.Height or CONTROL_HEIGHT
				)

				label.TextXAlignment = Enum.TextXAlignment.Center
				label.TextYAlignment = Enum.TextYAlignment.Center

				local Control = {Instance = label, Type = "Label", Name = controlName}

				function Control:Get() return label.Text end
				function Control:Set(value) label.Text = tostring(value) end

				Section.Row += 1
				return Section:AddControl(Control, controlName)
			end

			--------------------------------------------------------
			-- TOGGLE (SOPORTA MODO ANIMADO O CLÁSICO)
			--------------------------------------------------------

			function Section:Toggle(text, default, callback, controlName, options)
				options = options or {}
				local state = default == true
				local animated = (options.Animated ~= nil) and options.Animated or Window.UseAnimatedToggles
				local listeners = {}
				local y = options.Y or Section:GetNextY()

				local button = MakeControl(
					"TextButton",
					"",
					options.Width or 1,
					options.X or 0,
					y,
					options.Height or CONTROL_HEIGHT
				)

				local Control = {Instance = button, Type = "Toggle", Name = controlName, Value = state}

				local switchBg, switchKnob, labelText

				if animated then
					button.Text = ""

					labelText = Create("TextLabel", {
						Parent = button,
						BackgroundTransparency = 1,
						Position = UDim2.new(0, 8, 0, 0),
						Size = UDim2.new(1, -60, 1, 0),
						Font = Enum.Font.SourceSans,
						TextSize = 14,
						Text = tostring(text or ""),
						TextColor3 = Colors.Text,
						TextXAlignment = Enum.TextXAlignment.Left,
						ZIndex = 6
					})
					RegisterText(labelText)

					switchBg = Create("Frame", {
						Name = "SwitchBg",
						Parent = button,
						BackgroundColor3 = state and Colors.ToggleOn or Colors.ToggleOff,
						BorderSizePixel = 0,
						Position = UDim2.new(1, -48, 0.5, -10),
						Size = UDim2.fromOffset(40, 20),
						ZIndex = 6
					})
					RegisterBorder(switchBg)
					ApplyCorner(switchBg, 10)

					switchKnob = Create("Frame", {
						Name = "Knob",
						Parent = switchBg,
						BackgroundColor3 = Color3.fromRGB(255, 255, 255),
						BorderSizePixel = 0,
						Position = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8),
						Size = UDim2.fromOffset(16, 16),
						ZIndex = 7
					})
					ApplyCorner(switchKnob, 8)
				end

				local function Update()
					if animated and switchBg and switchKnob then
						local targetPos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
						local targetColor = state and Colors.ToggleOn or Colors.ToggleOff

						TweenService:Create(switchKnob, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							Position = targetPos
						}):Play()

						TweenService:Create(switchBg, TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), {
							BackgroundColor3 = targetColor
						}):Play()
					else
						button.Text = tostring(text or "") .. ": " .. (state and "ON" or "OFF")
						button.BackgroundColor3 = Colors.Button -- Mantiene el color constante (no cambia de color)
					end
				end

				function Control:Get() return state end

				function Control:Set(value)
					local newState = value == true
					state = newState
					Control.Value = state
					Update()

					for _, listener in ipairs(listeners) do task.spawn(listener, state) end
					if callback then task.spawn(callback, state) end
				end

				function Control:OnChanged(listener)
					if type(listener) == "function" then table.insert(listeners, listener) end
				end

				button.MouseButton1Click:Connect(function()
					Control:Set(not state)
				end)

				Update()
				Section.Row += 1
				return Section:AddControl(Control, controlName)
			end

			--------------------------------------------------------
			-- BAR DRAGGER (SLIDER INTERACTIVO CON PERILLA)
			--------------------------------------------------------

			function Section:BarDragger(text, min, max, default, callback, controlName, options)
				options = options or {}
				min = min or 0
				max = max or 100
				default = math.clamp(default or min, min, max)

				local y = options.Y or Section:GetNextY()
				local currentValue = default
				local dragging = false

				local container = MakeControl(
					"Frame",
					"",
					options.Width or 1,
					options.X or 0,
					y,
					options.Height or CONTROL_HEIGHT
				)

				local label = Create("TextLabel", {
					Parent = container,
					BackgroundTransparency = 1,
					Position = UDim2.new(0, 6, 0, 0),
					Size = UDim2.new(1, -12, 0, 14),
					Font = Enum.Font.SourceSans,
					TextSize = 13,
					Text = string.format("%s: %s", tostring(text or "Slider"), tostring(currentValue)),
					TextColor3 = Colors.Text,
					TextXAlignment = Enum.TextXAlignment.Left,
					ZIndex = 6
				})
				RegisterText(label)

				local track = Create("Frame", {
					Name = "Track",
					Parent = container,
					BackgroundColor3 = Color3.fromRGB(30, 30, 30),
					BorderSizePixel = 0,
					Position = UDim2.new(0, 6, 0, 18),
					Size = UDim2.new(1, -12, 0, 8),
					ZIndex = 6
				})
				RegisterBorder(track)

				local fillPercent = (currentValue - min) / (max - min)

				local fill = Create("Frame", {
					Name = "Fill",
					Parent = track,
					BackgroundColor3 = Colors.Border,
					BorderSizePixel = 0,
					Size = UDim2.new(fillPercent, 0, 1, 0),
					ZIndex = 7
				})

				local knob = Create("ImageButton", {
					Name = "KnobDragger",
					Parent = track,
					BackgroundColor3 = Color3.fromRGB(255, 255, 255),
					BorderSizePixel = 0,
					Position = UDim2.new(fillPercent, -6, 0.5, -6),
					Size = UDim2.fromOffset(12, 12),
					ZIndex = 8
				})
				ApplyCorner(knob, 6)

				local Control = {Instance = container, Type = "BarDragger", Name = controlName}

				local function UpdateSlider(inputPos)
					local trackAbsPos = track.AbsolutePosition.X
					local trackAbsSize = track.AbsoluteSize.X
					local relativeX = math.clamp(inputPos.X - trackAbsPos, 0, trackAbsSize)
					local alpha = relativeX / trackAbsSize

					currentValue = math.floor(min + (max - min) * alpha)
					fill.Size = UDim2.new(alpha, 0, 1, 0)
					knob.Position = UDim2.new(alpha, -6, 0.5, -6)
					label.Text = string.format("%s: %s", tostring(text or "Slider"), tostring(currentValue))

					if callback then task.spawn(callback, currentValue) end
				end

				knob.InputBegan:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = true
					end
				end)

				knob.InputEnded:Connect(function(input)
					if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
						dragging = false
					end
				end)

				UserInputService.InputChanged:Connect(function(input)
					if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
						UpdateSlider(input.Position)
					end
				end)

				function Control:Get() return currentValue end
				function Control:Set(val)
					currentValue = math.clamp(val, min, max)
					local alpha = (currentValue - min) / (max - min)
					fill.Size = UDim2.new(alpha, 0, 1, 0)
					knob.Position = UDim2.new(alpha, -6, 0.5, -6)
					label.Text = string.format("%s: %s", tostring(text or "Slider"), tostring(currentValue))
					if callback then task.spawn(callback, currentValue) end
				end

				Section.Row += 1
				return Section:AddControl(Control, controlName)
			end

			--------------------------------------------------------
			-- TEXTBOX
			--------------------------------------------------------

			function Section:Textbox(label, placeholder, callback, controlName, options)
				options = options or {}
				local listeners = {}
				local y = options.Y or Section:GetNextY()

				local box = MakeControl(
					"TextBox",
					"",
					options.Width or 1,
					options.X or 0,
					y,
					options.Height or CONTROL_HEIGHT
				)

				box.PlaceholderText = tostring(placeholder or label or "")
				box.PlaceholderColor3 = Colors.Text
				box.ClearTextOnFocus = false
				box.TextXAlignment = Enum.TextXAlignment.Left

				local Control = {Instance = box, TextBox = box, Type = "Textbox", Name = controlName}

				function Control:Get() return box.Text end
				function Control:Set(value) box.Text = tostring(value or "") end

				box.FocusLost:Connect(function(enterPressed)
					if callback then task.spawn(callback, box.Text, enterPressed) end
				end)

				Section.Row += 1
				return Section:AddControl(Control, controlName)
			end

			--------------------------------------------------------
			-- DROPDOWN
			--------------------------------------------------------

			function Section:Dropdown(text, values, callback, controlName, options)
				options = options or {}
				values = values or {}

				local selected = options.Default
				local open = false
				local popup = nil
				local y = options.Y or Section:GetNextY()

				local button = MakeControl(
					"TextButton",
					"",
					options.Width or 1,
					options.X or 0,
					y,
					options.Height or CONTROL_HEIGHT
				)

				local Control = {Instance = button, Type = "Dropdown", Name = controlName}

				local function UpdateText()
					if selected == nil then
						button.Text = tostring(text or "") .. " ▼"
					else
						button.Text = tostring(text or "") .. ": " .. tostring(selected) .. " ▼"
					end
				end

				local function ClosePopup()
					open = false
					if popup then popup:Destroy(); popup = nil end
				end

				local function OpenPopup()
					if open then ClosePopup(); return end
					open = true

					popup = Create("Frame", {
						Parent = ScreenGui,
						BackgroundColor3 = Colors.Background,
						BorderSizePixel = 0,
						Position = UDim2.fromOffset(button.AbsolutePosition.X, button.AbsolutePosition.Y + button.AbsoluteSize.Y),
						Size = UDim2.fromOffset(button.AbsoluteSize.X, math.min(#values * CONTROL_HEIGHT, 150)),
						ZIndex = 150
					})

					RegisterBorder(popup)
					RegisterBackground(popup)

					local list = Create("ScrollingFrame", {
						Parent = popup,
						BackgroundTransparency = 1,
						BorderSizePixel = 0,
						Size = UDim2.fromScale(1, 1),
						CanvasSize = UDim2.new(),
						AutomaticCanvasSize = Enum.AutomaticSize.Y,
						ScrollBarThickness = 3,
						ZIndex = 151
					})

					Create("UIListLayout", {Parent = list, SortOrder = Enum.SortOrder.LayoutOrder})

					for index, value in ipairs(values) do
						local option = Create("TextButton", {
							Parent = list,
							BackgroundColor3 = Colors.Button,
							BorderSizePixel = 0,
							Size = UDim2.new(1, 0, 0, CONTROL_HEIGHT),
							Font = Enum.Font.SourceSans,
							TextSize = 14,
							Text = tostring(value),
							TextColor3 = Colors.Text,
							AutoButtonColor = true,
							LayoutOrder = index,
							ZIndex = 152
						})

						RegisterBorder(option)
						RegisterText(option)

						option.MouseButton1Click:Connect(function()
							Control:Set(value)
							ClosePopup()
						end)
					end
				end

				function Control:Get() return selected end
				function Control:Set(value)
					selected = value
					UpdateText()
					if callback then task.spawn(callback, selected) end
				end

				button.MouseButton1Click:Connect(OpenPopup)
				UpdateText()

				Section.Row += 1
				return Section:AddControl(Control, controlName)
			end

			Page.Sections[Section.Name] = Section
			return Section
		end

		Page.Left = Page:CreateSection("Left", "left")
		Page.Right = Page:CreateSection("Right", "right")

		table.insert(Window.Pages, Page)

		if #Window.Pages == 1 then
			ShowPage(1)
		end

		return Page
	end

	--------------------------------------------------------
	-- LOOKUP & UTILS
	--------------------------------------------------------

	function Window:Get(controlName) return Window.Controls[controlName] end
	function Window:Show() Root.Visible = true; CloseOpen.Text = "Close" end
	function Window:Hide() Root.Visible = false; CloseOpen.Text = "Open" end
	function Window:Destroy() ScreenGui:Destroy() end

	return Window
end

return C00lLib
